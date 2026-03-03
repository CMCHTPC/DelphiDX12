//--------------------------------------------------------------------------------------
// File: XDSP.h

// DirectXMath based Digital Signal Processing (DSP) functions for audio,
// primarily Fast Fourier Transform (FFT)

// All buffer parameters must be 16-byte aligned

// All FFT functions support only single-precision floating-point audio

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkID=615557
//--------------------------------------------------------------------------------------
unit DirectX.XDSP;

{$mode Delphi}

interface

uses
    Classes, SysUtils, Windows,
    DirectX.Math;

type
    TXMVECTOR_ARRAY = array of TXMVECTOR;
    PXMVECTOR_ARRAY = ^TXMVECTOR_ARRAY;

function ISPOWEROF2(n: integer): boolean;
procedure vmulComplex(var rResult, iResult: TXMVECTOR; r1, i1, r2: TFXMVECTOR; i2: TGXMVECTOR); overload;
procedure vmulComplex(var r1, i1: TXMVECTOR; r2, i2: TFXMVECTOR); overload;
procedure ButterflyDIT4_1(var r1, i1: TXMVECTOR);
procedure ButterflyDIT4_4(var r0, r1, r2, r3, i0, i1, i2, i3: TXMVECTOR; const pUnityTableReal {uStride * 4}: array of TXMVECTOR; const pUnityTableImaginary {uStride * 4}: array of TXMVECTOR; uStride: size_t; fLast: boolean);
procedure FFT4(var pReal, pImaginary: array of TXMVECTOR; uCount: size_t = 1);
procedure FFT8(var pReal, pImaginary: array of TXMVECTOR; uCount: size_t = 1);
procedure FFT16(var pReal, pImaginary: array of TXMVECTOR; uCount: size_t = 1);
procedure FFT(var pReal, pImaginary: array of TXMVECTOR; const pUnityTable: array of TXMVECTOR; uLength: size_t; uCount: size_t = 1);
procedure FFTInitializeUnityTable(var pUnityTable: TXMVECTOR_ARRAY; uLength: size_t);
procedure FFTUnswizzle(var pOutput: PXMVECTOR_ARRAY; pInput: PXMVECTOR_ARRAY; const uLog2Length: size_t);
procedure FFTPolar(var pOutput: PXMVECTOR_ARRAY; pInputReal: PXMVECTOR_ARRAY; pInputImaginary: PXMVECTOR_ARRAY; uLength: size_t);
procedure Deinterleave(var pOutput: PXMVECTOR_ARRAY; pInput: PXMVECTOR_ARRAY; uChannelCount, uFrameCount: size_t); inline;
procedure Interleave(var pOutput: PXMVECTOR_ARRAY; pInput: PXMVECTOR_ARRAY; uChannelCount, uFrameCount: size_t);
procedure FFTInterleaved(var pReal: PXMVECTOR_ARRAY; var pImaginary: PXMVECTOR_ARRAY; const pUnityTable: PXMVECTOR_ARRAY; uChannelCount, uLog2Length: size_t);
procedure IFFTDeinterleaved(var pReal: PXMVECTOR_ARRAY; const pImaginary: PXMVECTOR_ARRAY; const pUnityTable: PXMVECTOR_ARRAY; uChannelCount, uLog2Length: size_t);

implementation



function ISPOWEROF2(n: integer): boolean; inline;
begin
    Result := (((n and (n - 1)) = 0) and (n <> 0));
end;

// Parallel multiplication of four complex numbers, assuming real and imaginary values are stored in separate vectors.

procedure vmulComplex(var rResult, iResult: TXMVECTOR; r1, i1, r2: TFXMVECTOR; i2: TGXMVECTOR); overload; inline;
var
    vr1r2, vr1i2: TXMVECTOR;
begin
    // (r1, i1) * (r2, i2) := (r1r2 - i1i2, r1i2 + r2i1)
    vr1r2 := XMVectorMultiply(r1, r2);
    vr1i2 := XMVectorMultiply(r1, i2);
    rResult := XMVectorNegativeMultiplySubtract(i1, i2, vr1r2); // real: (r1*r2 - i1*i2)
    iResult := XMVectorMultiplyAdd(r2, i1, vr1i2); // imaginary: (r1*i2 + r2*i1)
end;



procedure vmulComplex(var r1, i1: TXMVECTOR; r2, i2: TFXMVECTOR); overload; inline;
var
    vr1r2, vr1i2: TXMVECTOR;
begin
    // (r1, i1) * (r2, i2) = (r1r2 - i1i2, r1i2 + r2i1)
    vr1r2 := XMVectorMultiply(r1, r2);
    vr1i2 := XMVectorMultiply(r1, i2);
    r1 := XMVectorNegativeMultiplySubtract(i1, i2, vr1r2); // real: (r1*r2 - i1*i2)
    i1 := XMVectorMultiplyAdd(r2, i1, vr1i2); // imaginary: (r1*i2 + r2*i1)
end;


//----------------------------------------------------------------------------------
// Radix-4 decimation-in-time FFT butterfly.
// This version assumes that all four elements of the butterfly are
// adjacent in a single vector.

// Compute the product of the complex input vector and the
// 4-element DFT matrix:
//     | 1  1  1  1 |    | (r1X,i1X) |
//     | 1 -j -1  j |    | (r1Y,i1Y) |
//     | 1 -1  1 -1 |    | (r1Z,i1Z) |
//     | 1  j -1 -j |    | (r1W,i1W) |

// This matrix can be decomposed into two simpler ones to reduce the
// number of additions needed. The decomposed matrices look like this:
//     | 1  0  1  0 |    | 1  0  1  0 |
//     | 0  1  0 -j |    | 1  0 -1  0 |
//     | 1  0 -1  0 |    | 0  1  0  1 |
//     | 0  1  0  j |    | 0  1  0 -1 |

// Combine as follows:
//          | 1  0  1  0 |   | (r1X,i1X) |         | (r1X + r1Z, i1X + i1Z) |
// Temp   := | 1  0 -1  0 | * | (r1Y,i1Y) |       := | (r1X - r1Z, i1X - i1Z) |
//          | 0  1  0  1 |   | (r1Z,i1Z) |         | (r1Y + r1W, i1Y + i1W) |
//          | 0  1  0 -1 |   | (r1W,i1W) |         | (r1Y - r1W, i1Y - i1W) |

//          | 1  0  1  0 |   | (rTempX,iTempX) |   | (rTempX + rTempZ, iTempX + iTempZ) |
// Result := | 0  1  0 -j | * | (rTempY,iTempY) | := | (rTempY + iTempW, iTempY - rTempW) |
//          | 1  0 -1  0 |   | (rTempZ,iTempZ) |   | (rTempX - rTempZ, iTempX - iTempZ) |
//          | 0  1  0  j |   | (rTempW,iTempW) |   | (rTempY - iTempW, iTempY + rTempW) |
//----------------------------------------------------------------------------------
procedure ButterflyDIT4_1(var r1, i1: TXMVECTOR); inline;
// sign constants for radix-4 butterflies
const
    vDFT4SignBits1: TXMVECTOR = (f: (1.0, -1.0, 1.0, -1.0));
    vDFT4SignBits2: TXMVECTOR = (f: (1.0, 1.0, -1.0, -1.0));
    vDFT4SignBits3: TXMVECTOR = (f: (1.0, -1.0, -1.0, 1.0));
var
    r1L, r1H, i1L, i1H, rTemp, iTemp: TXMVECTOR;
    rZrWiZiW, rZiWrZiW, iZrWiZrW: TXMVECTOR;
    rTempL, iTempL: TXMVECTOR;
begin
    // calculating Temp
    // [r1X| r1X|r1Y| r1Y] + [r1Z|-r1Z|r1W|-r1W]
    // [i1X| i1X|i1Y| i1Y] + [i1Z|-i1Z|i1W|-i1W]
    r1L := XMVectorSwizzle(0, 0, 1, 1, r1);
    r1H := XMVectorSwizzle(2, 2, 3, 3, r1);

    i1L := XMVectorSwizzle(0, 0, 1, 1, i1);
    i1H := XMVectorSwizzle(2, 2, 3, 3, i1);

    rTemp := XMVectorMultiplyAdd(r1H, vDFT4SignBits1, r1L);
    iTemp := XMVectorMultiplyAdd(i1H, vDFT4SignBits1, i1L);

    // calculating Result
    rZrWiZiW := XMVectorPermute(2, 3, 6, 7, rTemp, iTemp);   // [rTempZ|rTempW|iTempZ|iTempW]
    rZiWrZiW := XMVectorSwizzle(0, 3, 0, 3, rZrWiZiW);       // [rTempZ|iTempW|rTempZ|iTempW]
    iZrWiZrW := XMVectorSwizzle(2, 1, 2, 1, rZrWiZiW);       // [rTempZ|iTempW|rTempZ|iTempW]

    // [rTempX| rTempY| rTempX| rTempY] + [rTempZ| iTempW|-rTempZ|-iTempW]
    // [iTempX| iTempY| iTempX| iTempY] + // [iTempZ|-rTempW|-iTempZ| rTempW]
    rTempL := XMVectorSwizzle(0, 1, 0, 1, rTemp);
    iTempL := XMVectorSwizzle(0, 1, 0, 1, iTemp);

    r1 := XMVectorMultiplyAdd(rZiWrZiW, vDFT4SignBits2, rTempL);
    i1 := XMVectorMultiplyAdd(iZrWiZrW, vDFT4SignBits3, iTempL);
end;


//----------------------------------------------------------------------------------
// Radix-4 decimation-in-time FFT butterfly.
// This version assumes that elements of the butterfly are
// in different vectors, so that each vector in the input
// contains elements from four different butterflies.
// The four separate butterflies are processed in parallel.

// The calculations here are the same as the ones in the single-vector
// radix-4 DFT, but instead of being done on a single vector (X,Y,Z,W)
// they are done in parallel on sixteen independent complex values.
// There is no interdependence between the vector elements:
// | 1  0  1  0 |    | (rIn0,iIn0) |               | (rIn0 + rIn2, iIn0 + iIn2) |
// | 1  0 -1  0 | *  | (rIn1,iIn1) |  :=   Temp   := | (rIn0 - rIn2, iIn0 - iIn2) |
// | 0  1  0  1 |    | (rIn2,iIn2) |               | (rIn1 + rIn3, iIn1 + iIn3) |
// | 0  1  0 -1 |    | (rIn3,iIn3) |               | (rIn1 - rIn3, iIn1 - iIn3) |

//          | 1  0  1  0 |   | (rTemp0,iTemp0) |   | (rTemp0 + rTemp2, iTemp0 + iTemp2) |
// Result := | 0  1  0 -j | * | (rTemp1,iTemp1) | := | (rTemp1 + iTemp3, iTemp1 - rTemp3) |
//          | 1  0 -1  0 |   | (rTemp2,iTemp2) |   | (rTemp0 - rTemp2, iTemp0 - iTemp2) |
//          | 0  1  0  j |   | (rTemp3,iTemp3) |   | (rTemp1 - iTemp3, iTemp1 + rTemp3) |
//----------------------------------------------------------------------------------
procedure ButterflyDIT4_4(var r0, r1, r2, r3, i0, i1, i2, i3: TXMVECTOR; const pUnityTableReal {uStride * 4}: array of TXMVECTOR; const pUnityTableImaginary {uStride * 4}: array of TXMVECTOR; uStride: size_t; fLast: boolean); inline;
var
    rTemp0, rTemp2, rTemp1, rTemp3: TXMVECTOR;
    iTemp0, iTemp2, iTemp1, iTemp3: TXMVECTOR;
    rTemp4, rTemp5, rTemp6, rTemp7: TXMVECTOR;
    iTemp4, iTemp5, iTemp6, iTemp7: TXMVECTOR;
begin
    {$IFDEF UseAssert}
    assert(pUnityTableReal<>nil);
    assert(pUnityTableImaginary<>nil);
    assert(uintptr(pUnityTableReal) mod 16 = 0);
    assert(uintptr(pUnityTableImaginary) mod 16 = 0);
    assert(ISPOWEROF2(uStride));
    {$ENDIF}

    // calculating Temp
    rTemp0 := XMVectorAdd(r0, r2);
    iTemp0 := XMVectorAdd(i0, i2);

    rTemp2 := XMVectorAdd(r1, r3);
    iTemp2 := XMVectorAdd(i1, i3);

    rTemp1 := XMVectorSubtract(r0, r2);
    iTemp1 := XMVectorSubtract(i0, i2);

    rTemp3 := XMVectorSubtract(r1, r3);
    iTemp3 := XMVectorSubtract(i1, i3);

    rTemp4 := XMVectorAdd(rTemp0, rTemp2);
    iTemp4 := XMVectorAdd(iTemp0, iTemp2);

    rTemp5 := XMVectorAdd(rTemp1, iTemp3);
    iTemp5 := XMVectorSubtract(iTemp1, rTemp3);

    rTemp6 := XMVectorSubtract(rTemp0, rTemp2);
    iTemp6 := XMVectorSubtract(iTemp0, iTemp2);

    rTemp7 := XMVectorSubtract(rTemp1, iTemp3);
    iTemp7 := XMVectorAdd(iTemp1, rTemp3);

    // calculating Result
    // vmulComplex(rTemp0, iTemp0, rTemp0, iTemp0, pUnityTableReal[0], pUnityTableImaginary[0]); // first one is always trivial
    vmulComplex(rTemp5, iTemp5, pUnityTableReal[uStride], pUnityTableImaginary[uStride]);
    vmulComplex(rTemp6, iTemp6, pUnityTableReal[uStride * 2], pUnityTableImaginary[uStride * 2]);
    vmulComplex(rTemp7, iTemp7, pUnityTableReal[uStride * 3], pUnityTableImaginary[uStride * 3]);

    if (fLast) then
    begin
        ButterflyDIT4_1(rTemp4, iTemp4);
        ButterflyDIT4_1(rTemp5, iTemp5);
        ButterflyDIT4_1(rTemp6, iTemp6);
        ButterflyDIT4_1(rTemp7, iTemp7);
    end;

    r0 := rTemp4;
    i0 := iTemp4;
    r1 := rTemp5;
    i1 := iTemp5;
    r2 := rTemp6;
    i2 := iTemp6;
    r3 := rTemp7;
    i3 := iTemp7;
end;

//==================================================================================
// F-U-N-C-T-I-O-N-S
//==================================================================================

//----------------------------------------------------------------------------------
// DESCRIPTION:
//  4-sample FFT.

// PARAMETERS:
//  pReal      - [inout] real components, must have at least uCount elements
//  pImaginary - [inout] imaginary components, must have at least uCount elements
//  uCount     - [in]    number of FFT iterations
//----------------------------------------------------------------------------------

procedure FFT4(var pReal, pImaginary: array of TXMVECTOR; uCount: size_t = 1); inline;
var
    uIndex: size_t;
begin
    {$IFDEF UseAssert}
    assert(pReal<>nil);
    assert(pImaginary<>nil);
    assert(uintptr(pReal) mod 16 = 0);
    assert(uintptr(pImaginary) mod 16 = 0);
    assert(ISPOWEROF2(uCount));
    {$ENDIF}

    for  uIndex := 0 to uCount - 1 do
        ButterflyDIT4_1(pReal[uIndex], pImaginary[uIndex]);
end;


//----------------------------------------------------------------------------------
// DESCRIPTION:
//  8-sample FFT.

// PARAMETERS:
//  pReal      - [inout] real components, must have at least uCount*2 elements
//  pImaginary - [inout] imaginary components, must have at least uCount*2 elements
//  uCount     - [in]    number of FFT iterations
//----------------------------------------------------------------------------------
procedure FFT8(var pReal, pImaginary: array of TXMVECTOR; uCount: size_t = 1); inline;
const
    wr1: TXMVECTOR = (f: (1.0, 0.70710677, 0.0, -0.70710677));
    wi1: TXMVECTOR = (f: (0.0, -0.70710677, -1.0, -0.70710677));
    wr2: TXMVECTOR = (f: (-1.0, -0.70710677, 0.0, 0.70710677));
    wi2: TXMVECTOR = (f: (0.0, 0.70710677, 1.0, 0.70710677));
var
    uIndex: size_t;
    oddsR, evensR, oddsI, evensI: TXMVECTOR;
    r, i: TXMVECTOR;
    k: integer;
begin
    {$IFDEF UseAssert}
    assert(pReal<>nil);
    assert(pImaginary<>nil);
    assert(uintptr(pReal) mod 16 = 0);
    assert(uintptr(pImaginary) mod 16 = 0);
    assert(ISPOWEROF2(uCount));
    {$ENDIF}
    k := 0;
    for  uIndex := 0 to uCount - 1 do
    begin
        k := uIndex * 2;

        oddsR := XMVectorPermute(1, 3, 5, 7, pReal[k], pReal[k + 1]);
        evensR := XMVectorPermute(0, 2, 4, 6, pReal[k], pReal[k + 1]);
        oddsI := XMVectorPermute(1, 3, 5, 7, pImaginary[k], pImaginary[k + 1]);
        evensI := XMVectorPermute(0, 2, 4, 6, pImaginary[k], pImaginary[k + 1]);
        ButterflyDIT4_1(oddsR, oddsI);
        ButterflyDIT4_1(evensR, evensI);

        vmulComplex(r, i, oddsR, oddsI, wr1, wi1);
        pReal[k] := XMVectorAdd(evensR, r);
        pImaginary[k] := XMVectorAdd(evensI, i);

        vmulComplex(r, i, oddsR, oddsI, wr2, wi2);
        pReal[k + 1] := XMVectorAdd(evensR, r);
        pImaginary[k + 1] := XMVectorAdd(evensI, i);
    end;
end;


//----------------------------------------------------------------------------------
// DESCRIPTION:
//  16-sample FFT.

// PARAMETERS:
//  pReal      - [inout] real components, must have at least uCount*4 elements
//  pImaginary - [inout] imaginary components, must have at least uCount*4 elements
//  uCount     - [in]    number of FFT iterations
//----------------------------------------------------------------------------------

procedure FFT16(var pReal, pImaginary: array of TXMVECTOR; uCount: size_t = 1); inline;
const
    aUnityTableReal: array [0..3] of TXMVECTOR = (
        (f: (1.0, 1.0, 1.0, 1.0)),
        (f: (1.0, 0.92387950, 0.70710677, 0.38268343)),
        (f: (1.0, 0.70710677, -4.3711388e-008, -0.70710677)),
        (f: (1.0, 0.38268343, -0.70710677, -0.92387950))
        );

    aUnityTableImaginary: array [0..3] of TXMVECTOR = (
        (f: (-0.0, -0.0, -0.0, -0.0)),
        (f: (-0.0, -0.38268343, -0.70710677, -0.92387950)),
        (f: (-0.0, -0.70710677, -1.0, -0.70710677)),
        (f: (-0.0, -0.92387950, -0.70710677, 0.38268343))
        );
var
    uIndex: size_t;
begin
    {$IFDEF UseAssert}
    assert(pReal<>nil);
    assert(pImaginary<>nil);
    assert(uintptr(pReal) mod 16 = 0);
    assert(uintptr(pImaginary) mod 16 = 0);
    assert(ISPOWEROF2(uCount));
    {$ENDIF}
    for  uIndex := 0 to uCount - 1 do
    begin
        ButterflyDIT4_4(pReal[uIndex * 4],
            pReal[uIndex * 4 + 1],
            pReal[uIndex * 4 + 2],
            pReal[uIndex * 4 + 3],
            pImaginary[uIndex * 4],
            pImaginary[uIndex * 4 + 1],
            pImaginary[uIndex * 4 + 2],
            pImaginary[uIndex * 4 + 3],
            aUnityTableReal,
            aUnityTableImaginary,
            1, True);
    end;
end;


//----------------------------------------------------------------------------------
// DESCRIPTION:
//  2^N-sample FFT.

// REMARKS:
//  For FFTs length 16 and below, call FFT16(), FFT8(), or FFT4().

// PARAMETERS:
//  pReal       - [inout] real components, must have at least (uLength*uCount)/4 elements
//  pImaginary  - [inout] imaginary components, must have at least (uLength*uCount)/4 elements
//  pUnityTable - [in]    unity table, must have at least uLength*uCount elements, see FFTInitializeUnityTable()
//  uLength     - [in]    FFT length in samples, must be a power of 2 > 16
//  uCount      - [in]    number of FFT iterations
//----------------------------------------------------------------------------------

procedure FFT(var pReal, pImaginary: array of TXMVECTOR; const pUnityTable: array of TXMVECTOR; uLength: size_t; uCount: size_t = 1); inline;
var
    pUnityTableReal: PXMVECTOR_ARRAY;
    pUnityTableImaginary: PXMVECTOR_ARRAY;
    uTotal, uTotal_vectors, uStage_vectors, uStage_vectors_mask, uStride, uStrideMask, uStride2, uStride3, uStrideInvMask: size_t;
    uIndex, n: size_t;
begin
    {$IFDEF UseAssert}
    assert(pReal<>nil);
    assert(pImaginary<>nil);
    assert(pUnityTable<>nil);
    assert(uintptr(pReal) mod 16 = 0);
    assert(uintptr(pImaginary) mod 16 = 0);
    assert(uintptr(pUnityTable) mod 16 = 0);
    assert(uLength > 16);
    assert(ISPOWEROF2(uLength));
    assert(ISPOWEROF2(uCount));
    {$ENDIF}
    pUnityTableReal := @pUnityTable[0];
    pUnityTableImaginary := @pUnityTable[uLength shr 2];

    uTotal := uCount * uLength;
    uTotal_vectors := uTotal shr 2;
    uStage_vectors := uLength shr 2;
    uStage_vectors_mask := uStage_vectors - 1;
    uStride := uLength shr 4; // stride between butterfly elements
    uStrideMask := uStride - 1;
    uStride2 := uStride * 2;
    uStride3 := uStride * 3;
    uStrideInvMask := not uStrideMask;

    for  uIndex := 0 to (uTotal_vectors shr 2) - 1 do
    begin
        n := ((uIndex and uStrideInvMask) shl 2) + (uIndex and uStrideMask);
        ButterflyDIT4_4(pReal[n],
            pReal[n + uStride],
            pReal[n + uStride2],
            pReal[n + uStride3],
            pImaginary[n],
            pImaginary[n + uStride],
            pImaginary[n + uStride2],
            pImaginary[n + uStride3],
            PXMVECTOR_ARRAY(pointer(pUnityTableReal) + (n and uStage_vectors_mask))^,
            PXMVECTOR_ARRAY(pointer(pUnityTableImaginary) + (n and uStage_vectors_mask))^,
            uStride, False);
    end;

    if (uLength > 16 * 4) then
    begin
        FFT(pReal, pImaginary, PXMVECTOR_ARRAY(@pUnityTable[0] + (uLength shr 1))^, uLength shr 2, uCount * 4);
    end
    else if (uLength = 16 * 4) then
    begin
        FFT16(pReal, pImaginary, uCount * 4);
    end
    else if (uLength = 8 * 4) then
    begin
        FFT8(pReal, pImaginary, uCount * 4);
    end
    else if (uLength = 4 * 4) then
    begin
        FFT4(pReal, pImaginary, uCount * 4);
    end;
end;


//----------------------------------------------------------------------------------
// DESCRIPTION:
//  Initializes unity roots lookup table used by FFT functions.
//  Once initialized, the table need not be initialized again unless a
//  different FFT length is desired.

// REMARKS:
//  The unity tables of FFT length 16 and below are hard coded into the
//  respective FFT functions and so need not be initialized.

// PARAMETERS:
//  pUnityTable - [out] unity table, receives unity roots lookup table, must have at least uLength elements
//  uLength     - [in]  FFT length in frames, must be a power of 2 > 16
//----------------------------------------------------------------------------------

procedure FFTInitializeUnityTable(var pUnityTable: TXMVECTOR_ARRAY; uLength: size_t); inline;
const
    vXM0123: TXMVECTOR = (f: (0.0, 1.0, 2.0, 3.0));
var
    vlStep, vJP: TXMVECTOR;
    j: size_t;
    vSin, vCos: TXMVECTOR;
    viJP, vlS: TXMVECTOR;
begin
    {$IFDEF UseAssert}
    assert(@pUnityTable[0]<>nil);
    assert(uLength > 16);
    assert(ISPOWEROF2(uLength));
    {$ENDIF}
    // initialize unity table for recursive FFT lengths: uLength, uLength/4, uLength/16... > 16
    // pUnityTable[0 to uLength*4-1] contains real components for current FFT length
    // pUnityTable[uLength*4 to uLength*8-1] contains imaginary components for current FFT length

    uLength := uLength shr 2;
    vlStep := XMVectorReplicate(XM_PIDIV2 / uLength);
    repeat
        uLength := uLength shr 2;
        vJP := vXM0123;
        for  j := 0 to uLength - 1 do
        begin
            pUnityTable[j] := g_XMOne;
            pUnityTable[j + uLength * 4] := XMVectorZero();

            vlS := XMVectorMultiply(vJP, vlStep);
            XMVectorSinCos(&vSin, &vCos, vlS);
            pUnityTable[j + uLength] := vCos;
            pUnityTable[j + uLength * 5] := XMVectorMultiply(vSin, g_XMNegativeOne);

            viJP := XMVectorAdd(vJP, vJP);
            vlS := XMVectorMultiply(viJP, vlStep);
            XMVectorSinCos(vSin, vCos, vlS);
            pUnityTable[j + uLength * 2] := vCos;
            pUnityTable[j + uLength * 6] := XMVectorMultiply(vSin, g_XMNegativeOne);

            viJP := XMVectorAdd(viJP, vJP);
            vlS := XMVectorMultiply(viJP, vlStep);
            XMVectorSinCos(&vSin, &vCos, vlS);
            pUnityTable[j + uLength * 3] := vCos;
            pUnityTable[j + uLength * 7] := XMVectorMultiply(vSin, g_XMNegativeOne);

            vJP := XMVectorAdd(vJP, g_XMFour);
        end;
        vlStep := XMVectorMultiply(vlStep, g_XMFour);
        pUnityTable := PXMVECTOR_ARRAY(pointer(PXMVECTOR_ARRAY(pUnityTable)) + uLength * 8)^;
    until (uLength > 4);
end;




//----------------------------------------------------------------------------------
// DESCRIPTION:
//  The FFT functions generate output in bit reversed order.
//  Use this function to re-arrange them into order of increasing frequency.

// REMARKS:
//  Exponential values and bits correspond, so the reversed upper index can be omitted depending on the number of exponents.

// PARAMETERS:
//  pOutput     - [out] output buffer, receives samples in order of increasing frequency, cannot overlap pInput, must have at least (1<<uLog2Length)/4 elements
//  pInput      - [in]  input buffer, samples in bit reversed order as generated by FFT functions, cannot overlap pOutput, must have at least (1<<uLog2Length)/4 elements
//  uLog2Length - [in]  LOG (base 2) of FFT length in samples, must be >= 2
//----------------------------------------------------------------------------------

procedure FFTUnswizzle(var pOutput: PXMVECTOR_ARRAY; pInput: PXMVECTOR_ARRAY; const uLog2Length: size_t); inline;
const
    cSwizzleTable: array [0..255] of byte = (
        $00, $40, $80, $C0, $10, $50, $90, $D0, $20, $60, $A0, $E0, $30, $70, $B0, $F0,
        $04, $44, $84, $C4, $14, $54, $94, $D4, $24, $64, $A4, $E4, $34, $74, $B4, $F4,
        $08, $48, $88, $C8, $18, $58, $98, $D8, $28, $68, $A8, $E8, $38, $78, $B8, $F8,
        $0C, $4C, $8C, $CC, $1C, $5C, $9C, $DC, $2C, $6C, $AC, $EC, $3C, $7C, $BC, $FC,
        $01, $41, $81, $C1, $11, $51, $91, $D1, $21, $61, $A1, $E1, $31, $71, $B1, $F1,
        $05, $45, $85, $C5, $15, $55, $95, $D5, $25, $65, $A5, $E5, $35, $75, $B5, $F5,
        $09, $49, $89, $C9, $19, $59, $99, $D9, $29, $69, $A9, $E9, $39, $79, $B9, $F9,
        $0D, $4D, $8D, $CD, $1D, $5D, $9D, $DD, $2D, $6D, $AD, $ED, $3D, $7D, $BD, $FD,
        $02, $42, $82, $C2, $12, $52, $92, $D2, $22, $62, $A2, $E2, $32, $72, $B2, $F2,
        $06, $46, $86, $C6, $16, $56, $96, $D6, $26, $66, $A6, $E6, $36, $76, $B6, $F6,
        $0A, $4A, $8A, $CA, $1A, $5A, $9A, $DA, $2A, $6A, $AA, $EA, $3A, $7A, $BA, $FA,
        $0E, $4E, $8E, $CE, $1E, $5E, $9E, $DE, $2E, $6E, $AE, $EE, $3E, $7E, $BE, $FE,
        $03, $43, $83, $C3, $13, $53, $93, $D3, $23, $63, $A3, $E3, $33, $73, $B3, $F3,
        $07, $47, $87, $C7, $17, $57, $97, $D7, $27, $67, $A7, $E7, $37, $77, $B7, $F7,
        $0B, $4B, $8B, $CB, $1B, $5B, $9B, $DB, $2B, $6B, $AB, $EB, $3B, $7B, $BB, $FB,
        $0F, $4F, $8F, $CF, $1F, $5F, $9F, $DF, $2F, $6F, $AF, $EF, $3F, $7F, $BF, $FF
        );
var
    pfOutput: array of single absolute pOutput;
    uRev32: size_t;
    uIndex: size_t;
    f4a: TXMFLOAT4A;
    n, uAddr, uRev7, uLength: size_t;
begin
    {$IFDEF UseAssert}
    assert(pOutput <> nil);
    assert(pInput <> nil);
    assert(uLog2Length >= 2);
    uLength := 1 shl (uLog2Length - 2);
    {$ENDIF}

    if ((uLog2Length and 1) = 0) then
    begin
        // even powers of two
        uRev32 := 32 - uLog2Length;
        for  uIndex := 0 to uLength - 1 do
        begin

            XMStoreFloat4A(f4a, pInput[uIndex]);
            n := uIndex * 4;
            uAddr := ((cSwizzleTable[n and $ff]) shl 24) or ((cSwizzleTable[(n shr 8) and $ff]) shl 16) or ((cSwizzleTable[(n shr 16) and $ff]) shl 8) or ((cSwizzleTable[(n shr 24)]));
            pfOutput[uAddr shr uRev32] := f4a.x;
            pfOutput[($40000000 or uAddr) shr uRev32] := f4a.y;
            pfOutput[($80000000 or uAddr) shr uRev32] := f4a.z;
            pfOutput[($C0000000 or uAddr) shr uRev32] := f4a.w;
        end;
    end
    else
    begin
        // odd powers of two
        uRev7 := size_t(1) shl (uLog2Length - 3);
        uRev32 := 32 - (uLog2Length - 3);
        for  uIndex := 0 to uLength - 1 do
        begin

            XMStoreFloat4A(f4a, pInput[uIndex]);
            n := (uIndex shr 1);
            uAddr := ((((cSwizzleTable[n and $ff]) shl 24) or ((cSwizzleTable[(n shr 8) and $ff]) shl 16) or ((cSwizzleTable[(n shr 16) and $ff]) shl 8) or ((cSwizzleTable[(n shr 24)]))) shr uRev32) or ((uIndex and 1) * uRev7 * 4);
            pfOutput[uAddr] := f4a.x;
            uAddr := uAddr + uRev7;
            pfOutput[uAddr] := f4a.y;
            uAddr := uAddr + uRev7;
            pfOutput[uAddr] := f4a.z;
            uAddr := uAddr + uRev7;
            pfOutput[uAddr] := f4a.w;
        end;
    end;
end;


//----------------------------------------------------------------------------------
// DESCRIPTION:
//  Convert complex components to polar form.

// PARAMETERS:
//  pOutput         - [out] output buffer, receives samples in polar form, must have at least uLength/4 elements
//  pInputReal      - [in]  input buffer (real components), must have at least uLength/4 elements
//  pInputImaginary - [in]  input buffer (imaginary components), must have at least uLength/4 elements
//  uLength         - [in]  FFT length in samples, must be a power of 2 >= 4
//----------------------------------------------------------------------------------
procedure FFTPolar(var pOutput: PXMVECTOR_ARRAY; pInputReal: PXMVECTOR_ARRAY; pInputImaginary: PXMVECTOR_ARRAY; uLength: size_t); inline;
var
    flOneOverLength: single;
    vOneOverLength, vReal, vImaginary, vRR, vII, vRRplusII, vTotal: TXMVECTOR;
    uIndex: size_t;
begin
    {$IFDEF UseAssert}
    assert(pOutput<>nil);
    assert(pInputReal<>nil);
    assert(pInputImaginary<>nil);
    assert(uLength >= 4);
    assert(ISPOWEROF2(uLength));
    {$ENDIF}

    flOneOverLength := 1.0 / uLength;

    // result := sqrtf((real/uLength)^2 + (imaginary/uLength)^2) * 2
    vOneOverLength := XMVectorReplicate(flOneOverLength);

    for  uIndex := 0 to (uLength shr 2) - 1 do
    begin
        vReal := XMVectorMultiply(pInputReal[uIndex], vOneOverLength);
        vImaginary := XMVectorMultiply(pInputImaginary[uIndex], vOneOverLength);
        vRR := XMVectorMultiply(vReal, vReal);
        vII := XMVectorMultiply(vImaginary, vImaginary);
        vRRplusII := XMVectorAdd(vRR, vII);
        vTotal := XMVectorSqrt(vRRplusII);
        pOutput[uIndex] := XMVectorAdd(vTotal, vTotal);
    end;
end;


//----------------------------------------------------------------------------------
// DESCRIPTION:
//  Deinterleaves audio samples

// REMARKS:
//  For example, audio of the form [LRLRLR] becomes [LLLRRR].

// PARAMETERS:
//  pOutput       - [out] output buffer, receives samples in deinterleaved form, cannot overlap pInput, must have at least (uChannelCount*uFrameCount)/4 elements
//  pInput        - [in]  input buffer, cannot overlap pOutput, must have at least (uChannelCount*uFrameCount)/4 elements
//  uChannelCount - [in]  number of channels, must be > 1
//  uFrameCount   - [in]  number of frames of valid data, must be > 0
//----------------------------------------------------------------------------------
procedure Deinterleave(var pOutput: PXMVECTOR_ARRAY; pInput: PXMVECTOR_ARRAY; uChannelCount, uFrameCount: size_t); inline;
var
    pfOutput: array of single absolute pOutput;
    pfInput: array of single absolute pInput;
    uChannel, uFrame: size_t;
begin
    {$IFDEF UseAssert}
    assert(pOutput<>nil);
    assert(pInput<>nil);
    assert(uChannelCount > 1);
    assert(uFrameCount > 0);
    {$ENDIF}

    for  uChannel := 0 to uChannelCount - 1 do
    begin
        for uFrame := 0 to uFrameCount - 1 do
        begin
            pfOutput[uChannel * uFrameCount + uFrame] := pfInput[uFrame * uChannelCount + uChannel];
        end;
    end;
end;



//----------------------------------------------------------------------------------
// DESCRIPTION:
//  Interleaves audio samples

// REMARKS:
//  For example, audio of the form [LLLRRR] becomes [LRLRLR].

// PARAMETERS:
//  pOutput       - [out] output buffer, receives samples in interleaved form, cannot overlap pInput, must have at least (uChannelCount*uFrameCount)/4 elements
//  pInput        - [in]  input buffer, cannot overlap pOutput, must have at least (uChannelCount*uFrameCount)/4 elements
//  uChannelCount - [in]  number of channels, must be > 1
//  uFrameCount   - [in]  number of frames of valid data, must be > 0
//----------------------------------------------------------------------------------
procedure Interleave(var pOutput: PXMVECTOR_ARRAY; pInput: PXMVECTOR_ARRAY; uChannelCount, uFrameCount: size_t); inline;
var
    pfOutput: array of single absolute pOutput;
    pfInput: array of single absolute pInput;
    uChannel, uFrame: size_t;
begin
    {$IFDEF UseAssert}
    assert(pOutput<>nil);
    assert(pInput<>nil);
    assert(uChannelCount > 1);
    assert(uFrameCount > 0);
    {$ENDIF}
    for  uChannel := 0 to uChannelCount - 1 do
    begin
        for uFrame := 0 to uFrameCount - 1 do
        begin
            pfOutput[uFrame * uChannelCount + uChannel] := pfInput[uChannel * uFrameCount + uFrame];
        end;
    end;
end;


//----------------------------------------------------------------------------------
// DESCRIPTION:
//  This function applies a 2^N-sample FFT and unswizzles the result such
//  that the samples are in order of increasing frequency.
//  Audio is first deinterleaved if multichannel.

// PARAMETERS:
//  pReal         - [inout] real components, must have at least (1SHLuLog2Length*uChannelCount)/4 elements
//  pImaginary    - [out]   imaginary components, must have at least (1SHLuLog2Length*uChannelCount)/4 elements
//  pUnityTable   - [in]    unity table, must have at least (1SHLuLog2Length) elements, see FFTInitializeUnityTable()
//  uChannelCount - [in]    number of channels, must be within [1, 6]
//  uLog2Length   - [in]    LOG (base 2) of FFT length in frames, must within [2, 9]
//----------------------------------------------------------------------------------
procedure FFTInterleaved(var pReal: PXMVECTOR_ARRAY; var pImaginary: PXMVECTOR_ARRAY; const pUnityTable: PXMVECTOR_ARRAY; uChannelCount, uLog2Length: size_t); inline;
var
    vRealTemp: TXMVECTOR_ARRAY; // array [0..768 - 1] of TXMVECTOR;
    vImaginaryTemp: TXMVECTOR_ARRAY; // array [0..768 - 1] of TXMVECTOR;
    uLength, uChannel: size_t;
begin
    {$IFDEF UseAssert}
    assert(pReal<>nil);
    assert(pImaginary<>nil);
    assert(pUnityTable<>nil);
    assert(uintptr(pReal) mod 16 = 0);
    assert(uintptr(pImaginary) mod 16 = 0);
    assert(uintptr(pUnityTable) mod 16 = 0);
    assert((uChannelCount > 0) AND (uChannelCount <= 6));
    assert((uLog2Length >= 2) AND (uLog2Length <= 9));
    {$ENDIF}
    uLength := 1 shl uLog2Length;
    SetLength(vRealTemp, 768);
    SetLength(vImaginaryTemp, 768);
    if (uChannelCount > 1) then
    begin
        Deinterleave(PXMVECTOR_ARRAY(vRealTemp), pReal, uChannelCount, uLength);
    end
    else
    begin
        move(pReal[0], vRealTemp, (uLength shr 2) * sizeof(TXMVECTOR));
        //memcpy_s(vRealTemp, sizeof(vRealTemp), pReal, (uLength shr 2) * sizeof(XMVECTOR));
    end;

    ZeroMemory(@vImaginaryTemp, (uChannelCount * (uLength shr 2)) * sizeof(TXMVECTOR));
    // ++ uChannelCount
    { #todo : ++x -> nicht x++ !!! }
    if (uLength > 16) then
    begin
        for  uChannel := 0 to uChannelCount - 1 do
        begin
            FFT(&vRealTemp[uChannel * (uLength shr 2)], &vImaginaryTemp[uChannel * (uLength shr 2)], pUnityTable^, uLength);
        end;
    end
    else if (uLength = 16) then
    begin
        for  uChannel := 0 to uChannelCount - 1 do
        begin
            FFT16(&vRealTemp[uChannel * (uLength shr 2)], &vImaginaryTemp[uChannel * (uLength shr 2)]);
        end;
    end
    else if (uLength = 8) then
    begin
        for uChannel := 0 to uChannelCount - 1 do
        begin
            FFT8(&vRealTemp[uChannel * (uLength shr 2)], &vImaginaryTemp[uChannel * (uLength shr 2)]);
        end;
    end
    else if (uLength = 4) then
    begin
        for uChannel := 0 to uChannelCount - 1 do
        begin
            FFT4(&vRealTemp[uChannel * (uLength shr 2)], &vImaginaryTemp[uChannel * (uLength shr 2)]);
        end;
    end;


    for uChannel := 0 to uChannelCount - 1 do
    begin
        //ToDo        FFTUnswizzle(PXMVECTOR_ARRAY(@pReal[uChannel * (uLength shr 2)]), PXMVECTOR_ARRAY(@vRealTemp[uChannel * (uLength shr 2)]), uLog2Length);
        //ToDo         FFTUnswizzle(pImaginary[uChannel * (uLength shr 2)], &vImaginaryTemp[uChannel * (uLength shr 2)], uLog2Length);
    end;

    SetLength(vRealTemp, 0);
    SetLength(vImaginaryTemp, 0);
end;


//----------------------------------------------------------------------------------
// DESCRIPTION:
//  This function applies a 2^N-sample inverse FFT.
//  Audio is interleaved if multichannel.

// PARAMETERS:
//  pReal         - [inout] real components, must have at least (1SHLuLog2Length*uChannelCount)/4 elements
//  pImaginary    - [in]    imaginary components, must have at least (1SHLuLog2Length*uChannelCount)/4 elements
//  pUnityTable   - [in]    unity table, must have at least (1SHLuLog2Length) elements, see FFTInitializeUnityTable()
//  uChannelCount - [in]    number of channels, must be > 0
//  uLog2Length   - [in]    LOG (base 2) of FFT length in frames, must within [2, 9]
//----------------------------------------------------------------------------------
procedure IFFTDeinterleaved(var pReal: PXMVECTOR_ARRAY; const pImaginary: PXMVECTOR_ARRAY; const pUnityTable: PXMVECTOR_ARRAY; uChannelCount, uLog2Length: size_t); inline;
var
    vRealTemp: array of TXMVECTOR; // 768
    vImaginaryTemp: array of TXMVECTOR; // 768
    uLength, u, uChannel: size_t;
    vRnp, vRnm: TXMVECTOR;
begin
    {$IFDEF UseAssert}
    assert(pReal<>nil);
    assert(pImaginary<>nil);
    assert(pUnityTable<>nil);
    assert(uintptr(pReal) mod 16 = 0);
    assert(uintptr(pImaginary) mod 16 = 0);
    assert(uintptr(pUnityTable) mod 16 = 0);
    assert((uChannelCount > 0 ) and ( uChannelCount <= 6));
    Assert((uLog2Length >= 2 ) and (  uLog2Length <= 9));
    {$ENDIF}
    uLength := (1) shl uLog2Length;

    SetLength(vRealTemp, 768);
    SetLength(vImaginaryTemp, 768);

    vRnp := XMVectorReplicate(1.0 / uLength);
    vRnm := XMVectorReplicate(-1.0 / uLength);

    for  u := 0 to uChannelCount * (uLength shr 2) - 1 do
    begin
        vRealTemp[u] := XMVectorMultiply(pReal[u], vRnp);
        vImaginaryTemp[u] := XMVectorMultiply(pImaginary[u], vRnm);
    end;

    if (uLength > 16) then
    begin
        for uChannel := 0 to uChannelCount - 1 do
        begin
            //ToDo            FFT(vRealTemp[uChannel * (uLength shr 2)], &vImaginaryTemp[uChannel * (uLength shr 2)], pUnityTable, uLength);
        end;
    end
    else if (uLength = 16) then
    begin
        for uChannel := 0 to uChannelCount - 1 do
        begin
            //ToDo           FFT16(&vRealTemp[uChannel * (uLength shr 2)], &vImaginaryTemp[uChannel * (uLength shr 2)]);
        end;
    end
    else if (uLength = 8) then
    begin
        for uChannel := 0 to uChannelCount - 1 do
        begin
            //ToDo           FFT8(&vRealTemp[uChannel * (uLength shr 2)], &vImaginaryTemp[uChannel * (uLength shr 2)]);
        end;
    end
    else if (uLength = 4) then
    begin
        for uChannel := 0 to uChannelCount - 1 do
        begin
            //ToDo            FFT4(&vRealTemp[uChannel * (uLength shr 2)], &vImaginaryTemp[uChannel * (uLength shr 2)]);
        end;
    end;

    for uChannel := 0 to uChannelCount - 1 do
    begin
        //ToDo        FFTUnswizzle(&vImaginaryTemp[uChannel * (uLength shr 2)], &vRealTemp[uChannel * (uLength shr 2)], uLog2Length);
    end;

    if (uChannelCount > 1) then
    begin
        Interleave(pReal, @vImaginaryTemp[0], uChannelCount, uLength);
    end
    else
    begin
        move(vImaginaryTemp[0], pReal^, (uLength shr 2) * sizeof(TXMVECTOR));
    end;

    SetLength(vRealTemp, 0);
    SetLength(vImaginaryTemp, 0);
end;

end.
