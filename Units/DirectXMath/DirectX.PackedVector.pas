//-------------------------------------------------------------------------------------
// DirectXPackedVector.h -- SIMD C++ Math library

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkID=615560
//-------------------------------------------------------------------------------------
unit DirectX.PackedVector;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
    Classes, SysUtils, Windows,
    DirectX.Math;

type

    //------------------------------------------------------------------------------
    // ARGB Color; 8-8-8-8 bit unsigned normalized integer components packed into
    // a 32 bit integer.  The normalized color is packed into 32 bits using 8 bit
    // unsigned, normalized integers for the alpha, red, green, and blue components.
    // The alpha component is stored in the most significant bits and the blue
    // component in the least significant bits (A8R8G8B8):
    // [32] aaaaaaaa rrrrrrrr gggggggg bbbbbbbb [0]

    { TXMCOLOR }

    TXMCOLOR = packed record
        class operator Initialize(var color: TXMCOLOR);
        constructor Create(Color: uint32); overload;
        constructor Create(r, g, b, a: single); overload;
        constructor Create(pArray: PSingle); overload;
        class operator Explicit(c: TXMCOLOR): uint32;
        class operator Explicit(_c: uint32): TXMCOLOR;
        case byte of
            0: (b: byte;  // Blue:    0/255 to 255/255
                g: byte;  // Green:   0/255 to 255/255
                r: byte;  // Red:     0/255 to 255/255
                a: byte;  // Alpha:   0/255 to 255/255
            );
            1: (c: uint32);

    end;
    PXMCOLOR = ^TXMCOLOR;


    //------------------------------------------------------------------------------
    // 16 bit floating point number consisting of a sign bit, a 5 bit biased
    // exponent, and a 10 bit mantissa
    THALF = uint16;
    PHALF = ^THALF;

    //------------------------------------------------------------------------------
    // 2D Vector; 16 bit floating point components

    { TXMHALF2 }

    TXMHALF2 = packed record
        class operator Initialize(var a: TXMHALF2);
        constructor Create(a: uint32); overload;
        constructor Create(_x, _y: THALF); overload;
        constructor Create(pArray: PHALF); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y: single); overload;
        class operator Explicit(c: TXMHALF2): uint32;
        class operator Explicit(c: uint32): TXMHALF2;
        case byte of
            0: (x: THALF;
                y: THALF);
            1: (v: uint32);
    end;

    PXMHALF2 = ^TXMHALF2;

    // 2D Vector; 16 bit signed normalized integer components

    { TXMSHORTN2 }

    TXMSHORTN2 = packed record
        class operator Initialize(var a: TXMSHORTN2);
        constructor Create(a: uint32); overload;
        constructor Create(_x, _y: int16); overload;
        constructor Create(pArray: Pint16); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y: single); overload;
        class operator Explicit(c: TXMSHORTN2): uint32;
        class operator Explicit(c: uint32): TXMSHORTN2;
        case byte of
            0: (x: int16;
                y: int16;);
            1: (v: uint32);
    end;

    PXMSHORTN2 = ^TXMSHORTN2;


    // 2D Vector; 16 bit signed integer components

    { TXMSHORT2 }

    TXMSHORT2 = packed record
        class operator Initialize(var a: TXMSHORT2);
        constructor Create(a: uint32); overload;
        constructor Create(_x, _y: int16); overload;
        constructor Create(pArray: Pint16); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y: single); overload;
        class operator Explicit(c: TXMSHORT2): uint32;
        class operator Explicit(c: uint32): TXMSHORT2;

        case byte of
            0: (x: int16;
                y: int16);
            1: (v: uint32);
    end;

    PXMSHORT2 = ^TXMSHORT2;

    // 2D Vector; 16 bit unsigned normalized integer components

    { TXMUSHORTN2 }

    TXMUSHORTN2 = packed record
        class operator Initialize(var a: TXMUSHORTN2);
        constructor Create(a: uint32); overload;
        constructor Create(_x, _y: uint16); overload;
        constructor Create(pArray: PUint16); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y: single); overload;
        class operator Explicit(c: TXMUSHORTN2): uint32;
        class operator Explicit(c: uint32): TXMUSHORTN2;
        case byte of
            0: (x: uint16;
                y: uint16);
            1: (v: uint32);
    end;

    PXMUSHORTN2 = ^TXMUSHORTN2;

    // 2D Vector; 16 bit unsigned integer components

    { TXMUSHORT2 }

    TXMUSHORT2 = packed record
        class operator Initialize(var a: TXMUSHORT2);
        constructor Create(a: uint32); overload;
        constructor Create(_x, _y: uint16); overload;
        constructor Create(pArray: PUint16); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y: single); overload;
        class operator Explicit(c: TXMUSHORT2): uint32;
        class operator Explicit(c: uint32): TXMUSHORT2;

        case byte of
            0: (x: uint16;
                y: uint16);
            1: (v: uint32);
    end;

    PXMUSHORT2 = ^TXMUSHORT2;

    //------------------------------------------------------------------------------
    // 2D Vector; 8 bit signed normalized integer components
    TXMBYTEN2 = packed record
        case byte of
            0: (x: byte;
                y: byte);
            1: (v: uint16);
    end;

    PXMBYTEN2 = ^TXMBYTEN2;

    // 2D Vector; 8 bit signed integer components
    TXMBYTE2 = record
        case byte of
            0: (x: byte;
                y: byte);
            1: (v: uint16);
    end;

    PXMBYTE2 = ^TXMBYTE2;

    // 2D Vector; 8 bit unsigned normalized integer components
    TXMUBYTEN2 = record
        case byte of
            0: (x: byte;
                y: byte);
            1: (v: uint16);
    end;
    PXMUBYTEN2 = ^TXMUBYTEN2;

    // 2D Vector; 8 bit unsigned integer components
    TXMUBYTE2 = record
        case byte of
            0: (x: byte;
                y: byte);
            1: (v: uint16);
    end;
    PXMUBYTE2 = ^TXMUBYTE2;

    // 3D vector: 5/6/5 unsigned integer components
    TXMU565 = bitpacked record
        case byte of
            0: (x: 0..31;    // 0 to 31
                y: 0..63;    // 0 to 63
                z: 0..31    // 0 to 31
            );
            1: (v: uint16);
    end;

    PXMU565 = ^TXMU565;


    //------------------------------------------------------------------------------
    // 3D vector: 11/11/10 floating-point components
    // The 3D vector is packed into 32 bits as follows: a 5-bit biased exponent
    // and 6-bit mantissa for x component, a 5-bit biased exponent and
    // 6-bit mantissa for y component, a 5-bit biased exponent and a 5-bit
    // mantissa for z. The z component is stored in the most significant bits
    // and the x component in the least significant bits. No sign bits so
    // all partial-precision numbers are positive.
    // (Z10Y11X11): [32] ZZZZZzzz zzzYYYYY yyyyyyXX XXXxxxxx [0]

    TXMFLOAT3PK = bitpacked record
        case byte of
            0: (xm: 0..63; // x-mantissa
                xe: 0..31; // x-exponent
                ym: 0..63; // y-mantissa
                ye: 0..31; // y-exponent
                zm: 0..31; // z-mantissa
                ze: 0..31 // z-exponent
            );
            1: (v: uint32);
    end;
    PXMFLOAT3PK = ^TXMFLOAT3PK;

    //------------------------------------------------------------------------------
    // 3D vector: 9/9/9 floating-point components with shared 5-bit exponent
    // The 3D vector is packed into 32 bits as follows: a 5-bit biased exponent
    // with 9-bit mantissa for the x, y, and z component. The shared exponent
    // is stored in the most significant bits and the x component mantissa is in
    // the least significant bits. No sign bits so all partial-precision numbers
    // are positive.
    // (E5Z9Y9X9): [32] EEEEEzzz zzzzzzyy yyyyyyyx xxxxxxxx [0]
    TXMFLOAT3SE = packed record
        case byte of
            0: (xm: 0..511; // x-mantissa
                ym: 0..511; // y-mantissa
                zm: 0..511; // z-mantissa
                e: 0..31 // shared exponent
            );
            1: (v: uint32);
    end;
    PXMFLOAT3SE = ^TXMFLOAT3SE;

    //------------------------------------------------------------------------------
    // 4D Vector; 16 bit floating point components
    TXMHALF4 = packed record
        case byte of
            0: (x: THALF;
                y: THALF;
                z: THALF;
                w: THALF);
            1: (v: uint64);
    end;

    PXMHALF4 = ^TXMHALF4;

    //------------------------------------------------------------------------------
    // 4D Vector; 16 bit signed normalized integer components
    TXMSHORTN4 = packed record
        case byte of
            0: (x: int16;
                y: int16;
                z: int16;
                w: int16);
            1: (v: uint64);
    end;

    PXMSHORTN4 = ^TXMSHORTN4;

    // 4D Vector; 16 bit signed integer components
    TXMSHORT4 = packed record
        case byte of
            0: (x: int16;
                y: int16;
                z: int16;
                w: int16);
            1: (v: uint64);
    end;

    PXMSHORT4 = ^TXMSHORT4;

    // 4D Vector; 16 bit unsigned normalized integer components
    TXMUSHORTN4 = packed record
        case byte of
            0: (x: uint16;
                y: uint16;
                z: uint16;
                w: uint16);
            1: (v: uint64);
    end;

    PXMUSHORTN4 = ^TXMUSHORTN4;

    // 4D Vector; 16 bit unsigned integer components
    TXMUSHORT4 = packed record
        case byte of
            0: (x: uint16;
                y: uint16;
                z: uint16;
                w: uint16);
            1: (v: uint64);
    end;

    PXMUSHORT4 = ^TXMUSHORT4;

    //------------------------------------------------------------------------------
    // 4D Vector; 10-10-10-2 bit normalized components packed into a 32 bit integer
    // The normalized 4D Vector is packed into 32 bits as follows: a 2 bit unsigned,
    // normalized integer for the w component and 10 bit signed, normalized
    // integers for the z, y, and x components.  The w component is stored in the
    // most significant bits and the x component in the least significant bits
    // (W2Z10Y10X10): [32] wwzzzzzz zzzzyyyy yyyyyyxx xxxxxxxx [0]
    TXMXDECN4 = packed record
        case byte of
            0: (x: -511..511;    // -511/511 to 511/511
                y: -511..511;    // -511/511 to 511/511
                z: -511..511;    // -511/511 to 511/511
                w: 0..3;     //      0/3 to     3/3
            );
            1: (v: uint32);
    end;

    PXMXDECN4 = ^TXMXDECN4;


    // 4D Vector; 10-10-10-2 bit components packed into a 32 bit integer
    // The normalized 4D Vector is packed into 32 bits as follows: a 2 bit unsigned
    // integer for the w component and 10 bit signed integers for the
    // z, y, and x components.  The w component is stored in the
    // most significant bits and the x component in the least significant bits
    // (W2Z10Y10X10): [32] wwzzzzzz zzzzyyyy yyyyyyxx xxxxxxxx [0]
    TXMXDEC4 = packed record
        case byte of
            0: (x: -511..511;    // -511 to 511
                y: -511..511;    // -511 to 511
                z: -511..511;    // -511 to 511
                w: 0..3;     // 0 to 3
            );
            1: (v: uint32);
    end;

    PXMXDEC4 = ^TXMXDEC4;

    // 4D Vector; 10-10-10-2 bit normalized components packed into a 32 bit integer
    // The normalized 4D Vector is packed into 32 bits as follows: a 2 bit signed,
    // normalized integer for the w component and 10 bit signed, normalized
    // integers for the z, y, and x components.  The w component is stored in the
    // most significant bits and the x component in the least significant bits
    // (W2Z10Y10X10): [32] wwzzzzzz zzzzyyyy yyyyyyxx xxxxxxxx [0]
    TXMDECN4 = packed record
        case byte of
            0: (x: -511..511;    // -511/511 to 511/511
                y: -511..511;    // -511/511 to 511/511
                z: -511..511;    // -511/511 to 511/511
                w: 0..3;     //     -1/1 to     1/1
            );
            1: (v: uint32);
    end;

    PXMDECN4 = ^TXMDECN4;

    // 4D Vector; 10-10-10-2 bit components packed into a 32 bit integer
    // The 4D Vector is packed into 32 bits as follows: a 2 bit signed,
    // integer for the w component and 10 bit signed integers for the
    // z, y, and x components.  The w component is stored in the
    // most significant bits and the x component in the least significant bits
    // (W2Z10Y10X10): [32] wwzzzzzz zzzzyyyy yyyyyyxx xxxxxxxx [0]
    TXMDEC4 = packed record
        case byte of
            0: (x: -511..511;    // -511 to 511
                y: -511..511;    // -511 to 511
                z: -511..511;    // -511 to 511
                w: 0..3;      //   -1 to   1
            );
            1: (v: uint32);
    end;

    PXMDEC4 = ^TXMDEC4;

    // 4D Vector; 10-10-10-2 bit normalized components packed into a 32 bit integer
    // The normalized 4D Vector is packed into 32 bits as follows: a 2 bit unsigned,
    // normalized integer for the w component and 10 bit unsigned, normalized
    // integers for the z, y, and x components.  The w component is stored in the
    // most significant bits and the x component in the least significant bits
    // (W2Z10Y10X10): [32] wwzzzzzz zzzzyyyy yyyyyyxx xxxxxxxx [0]
    TXMUDECN4 = packed record
        case byte of
            0: (x: -511..511;     // 0/1023 to 1023/1023
                y: -511..511;     // 0/1023 to 1023/1023
                z: -511..511;     // 0/1023 to 1023/1023
                w: 0..3;     //    0/3 to       3/3
            );
            1: (v: uint32);
    end;

    PXMUDECN4 = ^TXMUDECN4;


    // 4D Vector; 10-10-10-2 bit components packed into a 32 bit integer
    // The 4D Vector is packed into 32 bits as follows: a 2 bit unsigned,
    // integer for the w component and 10 bit unsigned integers
    // for the z, y, and x components.  The w component is stored in the
    // most significant bits and the x component in the least significant bits
    // (W2Z10Y10X10): [32] wwzzzzzz zzzzyyyy yyyyyyxx xxxxxxxx [0]
    TXMUDEC4 = packed record
        case byte of
            0: (x: -511..511;    // 0 to 1023
                y: -511..511;    // 0 to 1023
                z: -511..511;    // 0 to 1023
                w: 0..3;     // 0 to    3
            );
            1: (v: uint32);
    end;

    PXMUDEC4 = ^TXMUDEC4;

    //------------------------------------------------------------------------------
    // 4D Vector; 8 bit signed normalized integer components
    TXMBYTEN4 = packed record
        case byte of
            0: (
                x: byte;
                y: byte;
                z: byte;
                w: byte;
            );
            1: (v: uint32);
    end;

    PXMBYTEN4 = ^TXMBYTEN4;

    // 4D Vector; 8 bit signed integer components
    TXMBYTE4 = packed record
        case byte of
            0: (x: byte;
                y: byte;
                z: byte;
                w: byte;);
            1: (v: uint32);
    end;

    PXMBYTE4 = ^TXMBYTE4;

    // 4D Vector; 8 bit unsigned normalized integer components
    TXMUBYTEN4 = packed record
        case byte of
            0: (x: byte;
                y: byte;
                z: byte;
                w: byte;);
            1: (v: uint32);
    end;

    PXMUBYTEN4 = ^TXMUBYTEN4;

    // 4D Vector; 8 bit unsigned integer components
    TXMUBYTE4 = packed record
        case byte of
            0: (x: byte;
                y: byte;
                z: byte;
                w: byte;);
            1: (v: uint32);
    end;

    PXMUBYTE4 = ^TXMUBYTE4;

    //------------------------------------------------------------------------------
    // 4D vector; 4 bit unsigned integer components
    TXMUNIBBLE4 = packed record
        case byte of
            0: (x: 0..15;    // 0 to 15
                y: 0..15;    // 0 to 15
                z: 0..15;    // 0 to 15
                w: 0..15;    // 0 to 15
            );
            1: (v: uint16);
    end;

    PXMUNIBBLE4 = ^TXMUNIBBLE4;


    //------------------------------------------------------------------------------
    // 4D vector: 5/5/5/1 unsigned integer components
    TXMU555 = packed record
        case byte of
            0: (x: 0..31;    // 0 to 31
                y: 0..31;    // 0 to 31
                z: 0..31;    // 0 to 31
                w: 0..1;    // 0 or 1
            );
            1: (v: uint16);
    end;

    PXMU555 = ^TXMU555;


(****************************************************************************
*
* Data conversion operations
*
****************************************************************************)
function XMConvertHalfToFloat(constref Value: THALF): single;
function XMConvertHalfToFloatStream(    {var} pOutputStream: PSingle; OutputStride: size_t; const pInputStream: PHALF;
    InputStride: size_t; HalfCount: size_t): PSingle;
function XMConvertFloatToHalf(constref Value: single): THALF;
function XMConvertFloatToHalfStream({var} pOutputStream: PHALF; OutputStride: size_t; pInputStream: PSingle;
    InputStride: size_t; FloatCount: size_t): PHALF;

(****************************************************************************
*
* Load operations
*
****************************************************************************)
function XMLoadColor(const pSource: PXMCOLOR): TXMVECTOR;
function XMLoadHalf2(const pSource: PXMHALF2): TXMVECTOR;
function XMLoadShortN2(const pSource: PXMSHORTN2): TXMVECTOR;
function XMLoadShort2(const pSource: PXMSHORT2): TXMVECTOR;
function XMLoadUShortN2(const pSource: PXMUSHORTN2): TXMVECTOR;
function XMLoadUShort2(const pSource: PXMUSHORT2): TXMVECTOR;
function XMLoadByteN2(const pSource: PXMBYTEN2): TXMVECTOR;
function XMLoadByte2(const pSource: PXMBYTE2): TXMVECTOR;
function XMLoadUByteN2(const pSource: PXMUBYTEN2): TXMVECTOR;
function XMLoadUByte2(const pSource: PXMUBYTE2): TXMVECTOR;
function XMLoadU565(const pSource: PXMU565): TXMVECTOR;
function XMLoadFloat3PK(const pSource: PXMFLOAT3PK): TXMVECTOR;
function XMLoadFloat3SE(const pSource: PXMFLOAT3SE): TXMVECTOR;
function XMLoadHalf4(const pSource: PXMHALF4): TXMVECTOR;
function XMLoadShortN4(const pSource: PXMSHORTN4): TXMVECTOR;
function XMLoadShort4(const pSource: PXMSHORT4): TXMVECTOR;
function XMLoadUShortN4(const pSource: PXMUSHORTN4): TXMVECTOR;
function XMLoadUShort4(const pSource: PXMUSHORT4): TXMVECTOR;
function XMLoadXDecN4(const pSource: PXMXDECN4): TXMVECTOR;
function XMLoadXDec4(const pSource: PXMXDEC4): TXMVECTOR;
function XMLoadUDecN4(const pSource: PXMUDECN4): TXMVECTOR;
function XMLoadUDecN4_XR(const pSource: PXMUDECN4): TXMVECTOR;
function XMLoadUDec4(const pSource: PXMUDEC4): TXMVECTOR;
function XMLoadDecN4(const pSource: PXMDECN4): TXMVECTOR;
function XMLoadDec4(const pSource: PXMDEC4): TXMVECTOR;
function XMLoadUByteN4(const pSource: PXMUBYTEN4): TXMVECTOR;
function XMLoadUByte4(const pSource: PXMUBYTE4): TXMVECTOR;
function XMLoadByteN4(const pSource: PXMBYTEN4): TXMVECTOR;
function XMLoadByte4(const pSource: PXMBYTE4): TXMVECTOR;
function XMLoadUNibble4(const pSource: PXMUNIBBLE4): TXMVECTOR;
function XMLoadU555(const pSource: PXMU555): TXMVECTOR;


(****************************************************************************
*
* Store operations
*
****************************************************************************)
procedure XMStoreColor(pDestination: PXMCOLOR; V: TFXMVECTOR);
procedure XMStoreHalf2(pDestination: PXMHALF2; V: TFXMVECTOR);
procedure XMStoreShortN2(var pDestination: TXMSHORTN2; V: TFXMVECTOR);
procedure XMStoreShort2(var pDestination: TXMSHORT2; V: TFXMVECTOR);
procedure XMStoreUShortN2(var pDestination: TXMUSHORTN2; V: TFXMVECTOR);
procedure XMStoreUShort2(var pDestination: TXMUSHORT2; V: TFXMVECTOR);


procedure XMStoreU555(pDestination: PXMU555; V: TFXMVECTOR);


implementation

const
    _MM_FROUND_TO_NEAREST_INT = $0;

// {$DEFINE _XM_F16C_INTRINSICS_}
 {$ASMMODE INTEL}

 (****************************************************************************
 *
 * Data conversion
 *
 ****************************************************************************)

{$IFDEF _XM_F16C_INTRINSICS_}
function XMConvertHalfToFloat(constref Value: THALF): single; assembler; nostackframe;
asm
           MOV     CX, [Value]
           VCVTPH2PS XMM1, XMM0
           MOVSS   [XMConvertHalfToFloat], XMM1
end;

{$ELSE}



function XMConvertHalfToFloat(constref Value: THALF): single;
var
    Mantissa, Exponent, lResult: uint32;
begin
    Mantissa := uint32(Value) and $03FF;
    Exponent := Value and $7C00;

    if (Exponent = $7C00) then // INF/NAN
    begin
        Exponent := $8f;
    end
    else if (Exponent <> 0) then  // The value is normalized
    begin
        Exponent := uint32((int16(Value) shr 10) and $1F);
    end
    else if (Mantissa <> 0) then     // The value is denormalized
    begin
        // Normalize the value in the resulting float
        Exponent := 1;

        repeat
            Dec(Exponent);
            Mantissa := Mantissa shl 1;
        until ((Mantissa and $0400) <> 0);

        Mantissa := Mantissa and $03FF;
    end
    else                        // The value is zero
    begin
        Exponent := uint32(-112);
    end;

    lResult :=
        ((uint32(Value) and $8000) shl 16) // Sign
        or ((Exponent + 112) shl 23)                      // Exponent
        or (Mantissa shl 13);                             // Mantissa
    Result := single(lResult);
end;

{$ENDIF}

{$IFDEF _XM_F16C_INTRINSICS_}

function XMConvertFloatToHalf(constref Value: single): THALF; assembler; nostackframe;
asm
           MOVSS   XMM0 ,[Value]
           VCVTPS2PH XMM1, XMM0, _MM_FROUND_TO_NEAREST_INT
           PEXTRW  ECX, XMM1, 0
           MOV      [Result],CX
end;

{$ELSE}



function XMConvertFloatToHalf(constref Value: single): THALF;
var
    IValue, Sign, Shift, s: uint32;
    lResult: uint32;
begin

    IValue := uint32(Value);
    Sign := (IValue and $80000000) shr 16;
    IValue := IValue and $7FFFFFFF;      // Hack off the sign
    if (IValue >= $47800000 {e+16}) then
    begin
        // The number is too large to be represented as a half. Return infinity or NaN
        if (IValue > $7F800000) then
            lResult := $7C00 or ($200 or ((IValue shr 13) and $3FF))
        else
            lResult := 0;
    end
    else if (IValue <= $33000000 {e-25}) then
    begin
        lResult := 0;
    end
    else if (IValue < $38800000 {e-14}) then
    begin
        // The number is too small to be represented as a normalized half.
        // Convert it to a denormalized value.
        Shift := 125 - (IValue shr 23);
        IValue := $800000 or (IValue and $7FFFFF);
        lResult := IValue shr (Shift + 1);
        s := (IValue and ((1 shl Shift) - 1)); // <>0 ??
        lResult := lResult + (lResult or s) and ((IValue shr Shift) and 1);
    end
    else
    begin
        // Rebias the exponent to represent the value as a normalized half.
        IValue := IValue + $C8000000;
        lResult := ((IValue + $0FFF + ((IValue shr 13) and 1)) shr 13) and $7FFF;
    end;
    Result := THALF(lResult or Sign);
end;



{$ENDIF}

function XMConvertHalfToFloatStream(pOutputStream: PSingle; OutputStride: size_t; const pInputStream: PHALF;
    InputStride: size_t; HalfCount: size_t): PSingle;
var
    i: size_t;
    ptrHalf: pbyte;
    ptrFloat: pbyte;
begin
    ptrHalf := pbyte(pInputStream);
    ptrFloat := pbyte(pOutputStream);
    for  i := 0 to HalfCount - 1 do
    begin
        pSingle(ptrFloat)^ := XMConvertHalfToFloat(PHALF(ptrHalf)^);
        ptrHalf := ptrHalf + InputStride;
        ptrFloat := ptrFloat + OutputStride;
    end;
    Result := pOutputStream;
end;



function XMConvertFloatToHalfStream(pOutputStream: PHALF; OutputStride: size_t; pInputStream: PSingle; InputStride: size_t;
    FloatCount: size_t): PHALF;
var
    i: size_t;
    ptrHalf: pbyte;
    ptrFloat: pbyte;
begin
    ptrFloat := pbyte(pInputStream);
    ptrHalf := pbyte(pOutputStream);

    for i := 0 to FloatCount - 1 do
    begin
        PHALF(ptrHalf)^ := XMConvertFloatToHalf(PSingle(ptrFloat)^);
        ptrFloat := ptrFloat + InputStride;
        ptrHalf := ptrHalf + OutputStride;
    end;
    Result := pOutputStream;
end;

(****************************************************************************
 *
 * Vector and matrix load operations
 *
 ****************************************************************************)

function XMLoadColor(const pSource: PXMCOLOR): TXMVECTOR;
var
    iColor: int32;
begin
    // int32_t -> Float conversions are done in one instruction.
    // uint32_t -> Float calls a runtime function. Keep in int32_t
    iColor := int32(pSource.c);
    Result := TXMVECTOR.Create(((iColor shr 16) and $FF) * (1.0 / 255.0), ((iColor shr 8) and $FF) * (1.0 / 255.0),
        (iColor and $FF) * (1.0 / 255.0), ((iColor shr 24) and $FF) * (1.0 / 255.0));
end;



function XMLoadHalf2(const pSource: PXMHALF2): TXMVECTOR;
begin
    Result := TXMVECTOR.Create(XMConvertHalfToFloat(pSource.x), XMConvertHalfToFloat(pSource.y), 0.0, 0.0);
end;



function XMLoadShortN2(const pSource: PXMSHORTN2): TXMVECTOR;
var
    x, y: single;
begin
    if (pSource.x = -32768) then
        x := -1.0
    else
        x := (pSource.x) * (1.0 / 32767.0);
    if (pSource.y = -32768) then
        y := -1.0
    else
        y := (pSource.y) * (1.0 / 32767.0);
    Result := TXMVECTOR.Create(x, y, 0.0, 0.0);
end;



function XMLoadShort2(const pSource: PXMSHORT2): TXMVECTOR;
begin
    Result := TXMVECTOR.Create(pSource.x, pSource.y, 0.0, 0.0);
end;



function XMLoadUShortN2(const pSource: PXMUSHORTN2): TXMVECTOR;
begin
    Result := TXMVECTOR.Create((pSource.x) / 65535.0, (pSource.y) / 65535.0, 0.0, 0.0);
end;



function XMLoadUShort2(const pSource: PXMUSHORT2): TXMVECTOR;
begin
    Result := TXMVECTOR.Create(pSource.x, pSource.y, 0.0, 0.0);
end;



function XMLoadByteN2(const pSource: PXMBYTEN2): TXMVECTOR;
var
    x, y: single;
begin
    if (pSource.x = -128) then
        x := -1.0
    else
        x := ((pSource.x) * (1.0 / 127.0));
    if (pSource.y = -128) then
        y := -1.0
    else
        y := ((pSource.y) * (1.0 / 127.0));
    Result := TXMVECTOR.Create(x, y, 0.0, 0.0);
end;



function XMLoadByte2(const pSource: PXMBYTE2): TXMVECTOR;
begin
    Result := TXMVECTOR.Create(pSource.x, pSource.y, 0.0, 0.0);
end;



function XMLoadUByteN2(const pSource: PXMUBYTEN2): TXMVECTOR;
begin
    Result := TXMVECTOR.Create((pSource.x) * (1.0 / 255.0), (pSource.y) * (1.0 / 255.0), 0.0, 0.0);
end;



function XMLoadUByte2(const pSource: PXMUBYTE2): TXMVECTOR;
begin
    Result := TXMVECTOR.Create(pSource.x, pSource.y, 0.0, 0.0);
end;



function XMLoadU565(const pSource: PXMU565): TXMVECTOR;
begin
    Result := TXMVECTOR.Create((pSource.v and $1F), ((pSource.v shr 5) and $3F), ((pSource.v shr 11) and $1F), 0.0);
end;



function XMLoadFloat3PK(const pSource: PXMFLOAT3PK): TXMVECTOR;
var
    Mantissa: uint32;
    Exponent: uint32;
begin
    assert(pSource <> nil);
    Result.f[3] := 0;

    // X Channel (6-bit mantissa)
    Mantissa := pSource.xm;

    if (pSource.xe = $1f) then // INF or NAN
    begin
        Result.f[0] := uint32($7f800000 or (int32(pSource.xm) shl 17));
    end
    else
    begin
        if (pSource.xe <> 0) then // The value is normalized
        begin
            Exponent := pSource.xe;
        end
        else if (Mantissa <> 0) then // The value is denormalized
        begin
            // Normalize the value in the resulting float
            Exponent := 1;

            repeat
                Dec(Exponent);
                Mantissa := Mantissa shl 1;
            until ((Mantissa and $40) <> 0);

            Mantissa := Mantissa and $3F;
        end
        else // The value is zero
        begin
            Exponent := uint32(-112);
        end;

        Result.f[0] := ((Exponent + 112) shl 23) or (Mantissa shl 17);
    end;

    // Y Channel (6-bit mantissa)
    Mantissa := pSource.ym;

    if (pSource.ye = $1f) then // INF or NAN
    begin
        Result.f[1] := uint32($7f800000 or (int32(pSource.ym) shl 17));
    end
    else
    begin
        if (pSource.ye <> 0) then // The value is normalized
        begin
            Exponent := pSource.ye;
        end
        else if (Mantissa <> 0) then // The value is denormalized
        begin
            // Normalize the value in the resulting float
            Exponent := 1;

            repeat
                Dec(Exponent);
                Mantissa := Mantissa shl 1;
            until ((Mantissa and $40) <> 0);

            Mantissa := Mantissa and $3F;
        end
        else // The value is zero
        begin
            Exponent := uint32(-112);
        end;

        Result.f[1] := ((Exponent + 112) shl 23) or (Mantissa shl 17);
    end;

    // Z Channel (5-bit mantissa)
    Mantissa := pSource.zm;

    if (pSource.ze = $1f) then // INF or NAN
    begin
        Result.f[2] := uint32($7f800000 or (int32(pSource.zm) shl 17));
    end
    else
    begin
        if (pSource.ze <> 0) then // The value is normalized
        begin
            Exponent := pSource.ze;
        end
        else if (Mantissa <> 0) then // The value is denormalized
        begin
            // Normalize the value in the resulting float
            Exponent := 1;

            repeat
                Dec(Exponent);
                Mantissa := Mantissa shl 1;
            until ((Mantissa and $20) <> 0);

            Mantissa := Mantissa and $1F;
        end
        else // The value is zero
        begin
            Exponent := uint32(-112);
        end;

        Result.f[2] := ((Exponent + 112) shl 23) or (Mantissa shl 18);
    end;
end;



function XMLoadFloat3SE(const pSource: PXMFLOAT3SE): TXMVECTOR;
type
    TFI = record
        case
            byte of
            0: (f: single);
            1: (i: int32)
    end;
var
    fi: TFI;
    Scale: single;
begin
    assert(pSource <> nil);
    fi.i := $33800000 + (pSource.e shl 23);
    Scale := fi.f;

    Result := TXMVECTOR.Create(Scale * (pSource.xm), Scale * (pSource.ym), Scale * (pSource.zm), 1.0);
end;



function XMLoadHalf4(const pSource: PXMHALF4): TXMVECTOR;
begin
    Result := TXMVECTOR.Create(XMConvertHalfToFloat(pSource.x), XMConvertHalfToFloat(pSource.y),
        XMConvertHalfToFloat(pSource.z), XMConvertHalfToFloat(pSource.w));
end;



function XMLoadShortN4(const pSource: PXMSHORTN4): TXMVECTOR;
begin
    if (pSource.x = -32768) then
        Result.f[0] := -1.0
    else
        Result.f[0] := (pSource.x * (1.0 / 32767.0));
    if (pSource.y = -32768) then
        Result.f[1] := -1.0
    else
        Result.f[1] := (pSource.y * (1.0 / 32767.0));
    if (pSource.z = -32768) then
        Result.f[2] := -1.0
    else
        Result.f[2] := (pSource.z * (1.0 / 32767.0));
    if (pSource.w = -32768) then
        Result.f[3] := -1.0
    else
        Result.f[3] := (pSource.w * (1.0 / 32767.0));
end;



function XMLoadShort4(const pSource: PXMSHORT4): TXMVECTOR;
begin
    Result := TXMVECTOR.Create((pSource.x), (pSource.y), (pSource.z), (pSource.w));
end;



function XMLoadUShortN4(const pSource: PXMUSHORTN4): TXMVECTOR;
begin
    Result := TXMVECTOR.Create((pSource.x) / 65535.0, (pSource.y) / 65535.0, (pSource.z) / 65535.0, (pSource.w) / 65535.0);
end;



function XMLoadUShort4(const pSource: PXMUSHORT4): TXMVECTOR;
begin
    Result := TXMVECTOR.Create((pSource.x), (pSource.y), (pSource.z), (pSource.w));
end;



function XMLoadXDecN4(const pSource: PXMXDECN4): TXMVECTOR;
const
    SignExtend: array[0..1] of uint32 = ($00000000, $FFFFFC00);
var
    ElementX, ElementY, ElementZ: uint32;
begin

    ElementX := pSource.v and $3FF;
    ElementY := (pSource.v shr 10) and $3FF;
    ElementZ := (pSource.v shr 20) and $3FF;

    if (ElementX = $200) then
        Result.f[0] := -1.0
    else
        Result.f[0] := ((int16(ElementX or SignExtend[ElementX shr 9])) / 511.0);
    if (ElementY = $200) then
        Result.f[1] := -1.0
    else
        Result.f[1] := ((int16(ElementY or SignExtend[ElementY shr 9])) / 511.0);
    if (ElementZ = $200) then
        Result.f[2] := -1.0
    else
        Result.f[2] := ((int16(ElementZ or SignExtend[ElementZ shr 9])) / 511.0);
    Result.f[3] := (pSource.v shr 30) / 3.0;
end;



function XMLoadXDec4(const pSource: PXMXDEC4): TXMVECTOR;
const
    SignExtend: array[0..1] of uint32 = ($00000000, $FFFFFC00);
var
    ElementX, ElementY, ElementZ: uint32;
begin
    ElementX := pSource.v and $3FF;
    ElementY := (pSource.v shr 10) and $3FF;
    ElementZ := (pSource.v shr 20) and $3FF;

    Result := TXMVECTOR.Create((int16(ElementX or SignExtend[ElementX shr 9])), (int16(ElementY or SignExtend[ElementY shr 9])),
        (int16(ElementZ or SignExtend[ElementZ shr 9])), (pSource.v shr 30));

end;



function XMLoadUDecN4(const pSource: PXMUDECN4): TXMVECTOR;
var
    ElementX, ElementY, ElementZ: uint32;
begin
    ElementX := pSource.v and $3FF;
    ElementY := (pSource.v shr 10) and $3FF;
    ElementZ := (pSource.v shr 20) and $3FF;

    Result := TXMVECTOR.Create((ElementX) / 1023.0, (ElementY) / 1023.0, (ElementZ) / 1023.0, (pSource.v shr 30) / 3.0);
end;



function XMLoadUDecN4_XR(const pSource: PXMUDECN4): TXMVECTOR;
var
    ElementX, ElementY, ElementZ: int32;
begin
    ElementX := pSource.v and $3FF;
    ElementY := (pSource.v shr 10) and $3FF;
    ElementZ := (pSource.v shr 20) and $3FF;

    Result := TXMVECTOR.Create((ElementX - $180) / 510.0, (ElementY - $180) / 510.0, (ElementZ - $180) / 510.0, (pSource.v shr 30) / 3.0);
end;



function XMLoadUDec4(const pSource: PXMUDEC4): TXMVECTOR;
var
    ElementX, ElementY, ElementZ: uint32;
begin
    ElementX := pSource.v and $3FF;
    ElementY := (pSource.v shr 10) and $3FF;
    ElementZ := (pSource.v shr 20) and $3FF;

    Result := TXMVECTOR.Create((ElementX), (ElementY), (ElementZ), (pSource.v shr 30));
end;



function XMLoadDecN4(const pSource: PXMDECN4): TXMVECTOR;
var
    ElementX, ElementY, ElementZ, ElementW: uint32;
const
    SignExtend: array[0..1] of uint32 = ($00000000, $FFFFFC00);
    SignExtendW: array[0..1] of uint32 = ($00000000, $FFFFFFFC);
begin
    ElementX := pSource.v and $3FF;
    ElementY := (pSource.v shr 10) and $3FF;
    ElementZ := (pSource.v shr 20) and $3FF;
    ElementW := pSource.v shr 30;


    if (ElementX = $200) then
        Result.f[0] := -1.0
    else
        Result.f[0] := ((int16(ElementX or SignExtend[ElementX shr 9])) / 511.0);
    if (ElementY = $200) then
        Result.f[1] := -1.0
    else
        Result.f[1] := ((int16(ElementY or SignExtend[ElementY shr 9])) / 511.0);
    if (ElementZ = $200) then
        Result.f[2] := -1.0
    else
        Result.f[2] := ((int16(ElementZ or SignExtend[ElementZ shr 9])) / 511.0);
    if (ElementW = $2) then
        Result.f[3] := -1.0
    else
        Result.f[3] := (int16(ElementW or SignExtendW[(ElementW shr 1) and 1]));
end;



function XMLoadDec4(const pSource: PXMDEC4): TXMVECTOR;
var
    ElementX, ElementY, ElementZ, ElementW: uint32;
const
    SignExtend: array[0..1] of uint32 = ($00000000, $FFFFFC00);
    SignExtendW: array[0..1] of uint32 = ($00000000, $FFFFFFFC);
begin
    ElementX := pSource.v and $3FF;
    ElementY := (pSource.v shr 10) and $3FF;
    ElementZ := (pSource.v shr 20) and $3FF;
    ElementW := pSource.v shr 30;

    Result := TXMVECTOR.Create((int16(ElementX or SignExtend[ElementX shr 9])), (int16(ElementY or SignExtend[ElementY shr 9])),
        (int16(ElementZ or SignExtend[ElementZ shr 9])), (int16(ElementW or SignExtendW[ElementW shr 1])));
end;



function XMLoadUByteN4(const pSource: PXMUBYTEN4): TXMVECTOR;
begin
    Result := TXMVECTOR.Create((pSource.x) / 255.0, (pSource.y) / 255.0, (pSource.z) / 255.0, (pSource.w) / 255.0);
end;



function XMLoadUByte4(const pSource: PXMUBYTE4): TXMVECTOR;
begin
    Result := TXMVECTOR.Create((pSource.x), (pSource.y), (pSource.z), (pSource.w));
end;



function XMLoadByteN4(const pSource: PXMBYTEN4): TXMVECTOR;
begin
    if (pSource.x = -128) then
        Result.f[0] := -1.0
    else
        Result.f[0] := ((pSource.x) / 127.0);
    if (pSource.y = -128) then
        Result.f[1] := -1.0
    else
        Result.f[1] := ((pSource.y) / 127.0);
    if (pSource.z = -128) then
        Result.f[2] := -1.0
    else
        Result.f[2] := ((pSource.z) / 127.0);
    if (pSource.w = -128) then
        Result.f[3] := -1.0
    else
        Result.f[3] := ((pSource.w) / 127.0);
end;



function XMLoadByte4(const pSource: PXMBYTE4): TXMVECTOR;
begin
    Result := TXMVECTOR.Create((pSource.x), (pSource.y), (pSource.z), (pSource.w));
end;



function XMLoadUNibble4(const pSource: PXMUNIBBLE4): TXMVECTOR;
begin
    Result := TXMVECTOR.Create((pSource.v and $F), ((pSource.v shr 4) and $F), ((pSource.v shr 8) and $F), ((pSource.v shr 12) and $F));
end;



function XMLoadU555(const pSource: PXMU555): TXMVECTOR;
begin
    Result := TXMVECTOR.Create((pSource.v and $1F), ((pSource.v shr 5) and $1F), ((pSource.v shr 10) and $1F), ((pSource.v shr 15) and $1));
end;



(****************************************************************************
 *
 * Vector and matrix store operations
 *
 ****************************************************************************)

procedure XMStoreColor(pDestination: PXMCOLOR; V: TFXMVECTOR);
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorSaturate(V);
    N := XMVectorMultiply(N, g_UByteMax);
    N := XMVectorRound(N);
    XMStoreFloat4A(tmp, N);
    pDestination.c := (uint32(tmp.w) shl 24) or (uint32(tmp.x) shl 16) or (uint32(tmp.y) shl 8) or uint32(tmp.z);
end;



procedure XMStoreHalf2(pDestination: PXMHALF2; V: TFXMVECTOR);
begin
    pDestination.x := XMConvertFloatToHalf(XMVectorGetX(V));
    pDestination.y := XMConvertFloatToHalf(XMVectorGetY(V));
end;



procedure XMStoreShortN2(var pDestination: TXMSHORTN2; V: TFXMVECTOR);
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorClamp(V, g_XMNegativeOne, g_XMOne);
    N := XMVectorMultiply(N, g_ShortMax);
    N := XMVectorRound(N);

    XMStoreFloat4A(&tmp, N);

    pDestination.x := int32(tmp.x); // temporär typecast
    pDestination.y := int32(tmp.y);
end;



procedure XMStoreShort2(var pDestination: TXMSHORT2; V: TFXMVECTOR);
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorClamp(V, g_ShortMin, g_ShortMax);
    N := XMVectorRound(N);

    XMStoreFloat4A(tmp, N);

    pDestination.x := int32(tmp.x);
    pDestination.y := int32(tmp.y);
end;



procedure XMStoreUShortN2(var pDestination: TXMUSHORTN2; V: TFXMVECTOR);
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorSaturate(V);
    N := XMVectorMultiplyAdd(N, g_UShortMax, g_XMOneHalf);
    N := XMVectorTruncate(N);


    XMStoreFloat4A(tmp, N);

    pDestination.x := uint32(tmp.x);
    pDestination.y := uint32(tmp.y);
end;



procedure XMStoreUShort2(var pDestination: TXMUSHORT2; V: TFXMVECTOR);
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorClamp(V, XMVectorZero(), g_UShortMax);
    N := XMVectorRound(N);

    XMStoreFloat4A(tmp, N);

    pDestination.x := uint16(tmp.ux);
    pDestination.y := uint16(tmp.uy);
end;



{ todo }

procedure XMStoreU555(pDestination: PXMU555; V: TFXMVECTOR);
const
    Max: TXMVECTOR = (f: (31.0, 31.0, 31.0, 1.0));
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
    w: uint16;
begin
    N := XMVectorClamp(V, XMVectorZero(), Max);
    N := XMVectorRound(N);

    XMStoreFloat4A(tmp, N);

    if (tmp.w > 0.0) then
        w := $8000
    else
        W := 0;
    pDestination.v := uint16(w or ((int32(tmp.z) and $1F) shl 10) or ((int32(tmp.y) and $1F) shl 5) or (int32(tmp.x) and $1F));
end;

(****************************************************************************
 *
 * XMUSHORT2 operators
 *
 ****************************************************************************)

{ TXMUSHORT2 }

class operator TXMUSHORT2.Initialize(var a: TXMUSHORT2);
begin
    a.v := 0;
end;



constructor TXMUSHORT2.Create(a: uint32);
begin
    self.v := a;
end;



constructor TXMUSHORT2.Create(_x, _y: uint16);
begin
    self.x := _x;
    self.y := _y;
end;



constructor TXMUSHORT2.Create(pArray: PUint16);
var
    lArray: array of uint16 absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
end;



constructor TXMUSHORT2.Create(pArray: PSingle);
begin
    XMStoreUShort2(self, XMLoadFloat2(PXMFLOAT2(pArray)));
end;



constructor TXMUSHORT2.Create(_x, _y: single);
begin
    XMStoreUShort2(self, XMVectorSet(_x, _y, 0.0, 0.0));
end;



class operator TXMUSHORT2.Explicit(c: TXMUSHORT2): uint32;
begin
    Result := c.v;
end;



class operator TXMUSHORT2.Explicit(c: uint32): TXMUSHORT2;
begin
    Result.v := c;
end;



(****************************************************************************
 *
 * XMUSHORTN2 operators
 *
 ****************************************************************************)

{ TXMUSHORTN2 }

class operator TXMUSHORTN2.Initialize(var a: TXMUSHORTN2);
begin
    a.v := 0;
end;



constructor TXMUSHORTN2.Create(a: uint32);
begin
    self.v := a;
end;



constructor TXMUSHORTN2.Create(_x, _y: uint16);
begin
    self.x := _x;
    self.y := _y;
end;



constructor TXMUSHORTN2.Create(pArray: PUint16);
var
    lArray: array of uint16 absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
end;



constructor TXMUSHORTN2.Create(pArray: PSingle);
begin
    XMStoreUShortN2(self, XMLoadFloat2(PXMFLOAT2(pArray)));
end;



constructor TXMUSHORTN2.Create(_x, _y: single);
begin
    XMStoreUShortN2(self, XMVectorSet(_x, _y, 0.0, 0.0));
end;



class operator TXMUSHORTN2.Explicit(c: TXMUSHORTN2): uint32;
begin
    Result := c.v;
end;



class operator TXMUSHORTN2.Explicit(c: uint32): TXMUSHORTN2;
begin
    Result.v := c;
end;


(****************************************************************************
 *
 * XMSHORT2 operators
 *
 ****************************************************************************)

{ TXMSHORT2 }

class operator TXMSHORT2.Initialize(var a: TXMSHORT2);
begin
    a.v := 0;
end;



constructor TXMSHORT2.Create(a: uint32);
begin
    self.v := a;
end;



constructor TXMSHORT2.Create(_x, _y: int16);
begin
    self.x := _x;
    self.y := _y;
end;



constructor TXMSHORT2.Create(pArray: Pint16);
var
    lArray: array of int16 absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
end;



constructor TXMSHORT2.Create(pArray: PSingle);
begin
    XMStoreShort2(self, XMLoadFloat2(PXMFLOAT2(pArray)));
end;



constructor TXMSHORT2.Create(_x, _y: single);
begin
    XMStoreShort2(self, XMVectorSet(_x, _y, 0.0, 0.0));
end;



class operator TXMSHORT2.Explicit(c: TXMSHORT2): uint32;
begin
    Result := c.v;
end;



class operator TXMSHORT2.Explicit(c: uint32): TXMSHORT2;
begin
    Result.v := c;
end;



(****************************************************************************
 *
 * XMSHORTN2 operators
 *
 ****************************************************************************)
{ TXMSHORTN2 }

class operator TXMSHORTN2.Initialize(var a: TXMSHORTN2);
begin
    a.v := 0;
end;



constructor TXMSHORTN2.Create(a: uint32);
begin
    self.v := a;
end;



constructor TXMSHORTN2.Create(_x, _y: int16);
begin
    self.x := _x;
    self.y := _y;
end;



constructor TXMSHORTN2.Create(pArray: Pint16);
var
    lArray: array of int16 absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
end;



constructor TXMSHORTN2.Create(pArray: PSingle);
begin
    XMStoreShortN2(self, XMLoadFloat2(PXMFLOAT2(pArray)));
end;



constructor TXMSHORTN2.Create(_x, _y: single);
begin
    XMStoreShortN2(self, XMVectorSet(_x, _y, 0.0, 0.0));
end;



class operator TXMSHORTN2.Explicit(c: TXMSHORTN2): uint32;
begin
    Result := c.v;
end;



class operator TXMSHORTN2.Explicit(c: uint32): TXMSHORTN2;
begin
    Result.v := c;
end;


(****************************************************************************
 *
 * XMHALF2 operators
 *
 ****************************************************************************)

{ TXMHALF2 }

class operator TXMHALF2.Initialize(var a: TXMHALF2);
begin
    a.x := 0;
    a.y := 0;
end;



constructor TXMHALF2.Create(a: uint32);
begin
    self.v := a;
end;



constructor TXMHALF2.Create(_x, _y: THALF);
begin
    self.x := _x;
    self.y := _y;
end;



constructor TXMHALF2.Create(pArray: PHALF);
var
    lArray: array of THALF absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
end;



constructor TXMHALF2.Create(pArray: PSingle);
begin
    {$IFDEF UseAssert}
    assert(pArray <> nil);
    {$ENDIF}
    x := XMConvertFloatToHalf(pArray[0]);
    y := XMConvertFloatToHalf(pArray[1]);
end;



constructor TXMHALF2.Create(_x, _y: single);
begin
    x := XMConvertFloatToHalf(_x);
    y := XMConvertFloatToHalf(_y);
end;



class operator TXMHALF2.Explicit(c: TXMHALF2): uint32;
begin
    Result := c.v;
end;



class operator TXMHALF2.Explicit(c: uint32): TXMHALF2;
begin
    Result.v := c;
end;



(****************************************************************************
 *
 * XMCOLOR operators
 *
 ****************************************************************************)

{ TXMCOLOR }

class operator TXMCOLOR.Initialize(var color: TXMCOLOR);
begin
    Color.c := 0;
end;



constructor TXMCOLOR.Create(Color: uint32);
begin
    self.c := Color;
end;



constructor TXMCOLOR.Create(r, g, b, a: single);
begin
    XMStoreColor(@self, XMVectorSet(r, g, b, a));
end;



constructor TXMCOLOR.Create(pArray: PSingle);
begin
    XMStoreColor(@self, XMLoadFloat4(PXMFLOAT4(pArray)^));
end;



class operator TXMCOLOR.Explicit(c: TXMCOLOR): uint32;
begin
    Result := c.c;
end;



class operator TXMCOLOR.Explicit(_c: uint32): TXMCOLOR;
begin
    Result.c := _c;
end;



end.
