// -------------------------------------------------------------------------------------
// DirectXMath.h -- SIMD C++ Math library

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkID=615560
// -------------------------------------------------------------------------------------

unit DirectX.Math;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
    Classes, SysUtils, Windows;

{$Z4}
{$A4}
{$DEFINE _XM_NO_INTRINSICS_}
// {$DEFINE _XM_SSE_INTRINSICS_}
// {$DEFINE _XM_SSE4_INTRINSICS_}
// {$DEFINE _XM_AVX_INTRINSICS_}
// {$DEFINE _XM_AVX2_INTRINSICS_}

const
    DIRECTX_MATH_VERSION = 318;

    (* ***************************************************************************
      *
      * Constant definitions
      *
      *************************************************************************** *)
const
    XM_PI = 3.141592654;
    XM_2PI = 6.283185307;
    XM_1DIVPI = 0.318309886;
    XM_1DIV2PI = 0.159154943;
    XM_PIDIV2 = 1.570796327;
    XM_PIDIV4 = 0.785398163;

    XM_SELECT_0 = $00000000;
    XM_SELECT_1 = $FFFFFFFF;

    XM_PERMUTE_0X: uint32 = 0;
    XM_PERMUTE_0Y: uint32 = 1;
    XM_PERMUTE_0Z: uint32 = 2;
    XM_PERMUTE_0W: uint32 = 3;
    XM_PERMUTE_1X: uint32 = 4;
    XM_PERMUTE_1Y: uint32 = 5;
    XM_PERMUTE_1Z: uint32 = 6;
    XM_PERMUTE_1W: uint32 = 7;

    XM_SWIZZLE_X: uint32 = 0;
    XM_SWIZZLE_Y: uint32 = 1;
    XM_SWIZZLE_Z: uint32 = 2;
    XM_SWIZZLE_W: uint32 = 3;

    XM_CRMASK_CR6 = $000000F0;
    XM_CRMASK_CR6TRUE = $00000080;
    XM_CRMASK_CR6FALSE = $00000020;
    XM_CRMASK_CR6BOUNDS = XM_CRMASK_CR6FALSE;

    XM_CACHE_LINE_SIZE = 64;

    (* ***************************************************************************
      *
      * Data types
      *
      *************************************************************************** *)
type

    TArray4UINT32 = array [0 .. 3] of uint32;
    PArray4UINT32 = ^TArray4UINT32;

    { TXMVECTOR }

    TXMVECTOR = record
        constructor Create(pArray: PSingle); overload;
        constructor Create(x, y, z, w: single); overload;
        // Vector operators
        class operator Negative(a: TXMVECTOR): TXMVECTOR;
        class operator Positive(a: TXMVECTOR): TXMVECTOR;
        class operator Equal(a: TXMVECTOR; b: TXMVECTOR): boolean;
        class operator NotEqual(a: TXMVECTOR; b: TXMVECTOR): boolean;
        class operator Add(a, b: TXMVECTOR): TXMVECTOR; // Addition of two operands of type TXMVECTOR
        class operator Subtract(a: TXMVECTOR; b: TXMVECTOR): TXMVECTOR;
        class operator Multiply(a: TXMVECTOR; b: TXMVECTOR): TXMVECTOR;
        class operator Divide(a: TXMVECTOR; b: TXMVECTOR): TXMVECTOR;
        class operator Multiply(a: single; b: TXMVECTOR): TXMVECTOR;
        class operator Multiply(a: TXMVECTOR; b: single): TXMVECTOR;
        class operator Divide(a: TXMVECTOR; b: single): TXMVECTOR;

        case byte of
            0: (vector4_f32: array [0 .. 3] of single); // TXMVECTORF32
            1: (vector4_u32: array [0 .. 3] of uint32); // TXMVECTORU32
            2: (vector4_i32: array [0 .. 3] of int32); // TXMVECTORI32
            3: (vector16_u8: array [0 .. 15] of byte); // TXMVECTORU8
            4: (f: array [0 .. 3] of single);
            5: (u: array [0 .. 3] of uint32);
            6: (i: array [0 .. 3] of int32);
            7: (b: array [0 .. 15] of byte);
            8: (x, y, z, w: single);
    end;

    PXMVECTOR = ^TXMVECTOR;

    TXMVECTORF32 = TXMVECTOR;
    TXMVECTORI32 = TXMVECTOR;
    TXMVECTORU8 = TXMVECTOR;

    // Fix-up for (1st-3rd) XMVECTOR parameters that are pass-in-register for x86, ARM, ARM64, and vector call; by reference otherwise
    TFXMVECTOR = TXMVECTOR;

    // Fix-up for (4th) XMVECTOR parameter to pass in-register for ARM, ARM64, and vector call; by reference otherwise
    TGXMVECTOR = TXMVECTOR;

    // Fix-up for (5th & 6th) XMVECTOR parameter to pass in-register for ARM64 and vector call; by reference otherwise
    THXMVECTOR = TXMVECTOR;

    // Fix-up for (7th+) XMVECTOR parameters to pass by reference
    TCXMVECTOR = TXMVECTOR;



    // ------------------------------------------------------------------------------
    // Matrix type: Sixteen 32 bit floating point components aligned on a
    // 16 byte boundary and mapped to four hardware vector registers

    { TXMMATRIX }

    TXMMATRIX = record
        constructor Create(pArray: PSingle); overload;
        constructor Create(r0, r1, r2, r3: TXMVECTOR); overload;
        constructor Create(m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33: single); overload;
        class operator Negative(a: TXMMATRIX): TXMMATRIX;
        class operator Add(a, b: TXMMATRIX): TXMMATRIX; // Addition of two operands of type TXMVECTOR
        class operator Subtract(a: TXMMATRIX; b: TXMMATRIX): TXMMATRIX;
        class operator Multiply(a: TXMMATRIX; b: TXMMATRIX): TXMMATRIX;
        class operator Divide(a: TXMMATRIX; b: single): TXMMATRIX;
        class operator Multiply(a: single; b: TXMMATRIX): TXMMATRIX;
        class operator Multiply(a: TXMMATRIX; b: single): TXMMATRIX;

        case byte of
            0: (r: array [0 .. 3] of TXMVECTOR);
            1: (m: array [0 .. 3, 0 .. 3] of single);
            2: (f: array [0 .. 15] of single);
            3: (u: array [0 .. 15] of uint32);
            4: (_11, _12, _13, _14: single;
                _21, _22, _23, _24: single;
                _31, _32, _33, _34: single;
                _41, _42, _43, _44: single);

    end;

    TFXMMATRIX = TXMMATRIX;
    TCXMMATRIX = TXMMATRIX;

    // ------------------------------------------------------------------------------
    // 2D Vector; 32 bit floating point components

    { TXMFLOAT2 }

    TXMFLOAT2 = record
        constructor Create(x, y: single); overload;
        constructor Create(pArray: PSingle); overload;
        class operator Equal(a: TXMFLOAT2; b: TXMFLOAT2): boolean;
        function ThreeWayComparison(const a, b: TXMFLOAT2): integer;
        case byte of
            0: (x: single;
                y: single);
            1: (f: array [0 .. 1] of single);
    end;

    PXMFLOAT2 = ^TXMFLOAT2;


    // 2D Vector; 32 bit floating point components aligned on a 16 byte boundary

    { TXMFLOAT2A }

    TXMFLOAT2A = record
        constructor Create(x, y: single); overload;
        constructor Create(pArray: PSingle); overload;
        case byte of
            0: (x: single;
                y: single;
                Reserved: array [0 .. 1] of single // an opaque record
            );
            1: (f: array [0 .. 1] of single);
            2: (v: TXMFLOAT2);
    end;

    PXMFLOAT2A = ^TXMFLOAT2A;

    { TXMINT2 }
    // 2D Vector; 32 bit signed integer components
    TXMINT2 = record
        constructor Create(x, y: int32); overload;
        constructor Create(pArray: PLongint); overload;
        case byte of
            0: (x: int32;
                y: int32);
            1: (i: array [0 .. 1] of int32);
    end;

    PXMINT2 = ^TXMINT2;

    { TXMUINT2 }
    // 2D Vector; 32 bit unsigned integer components
    TXMUINT2 = record
        constructor Create(x, y: uint32); overload;
        constructor Create(pArray: Puint32); overload;
        case byte of
            0: (x: uint32;
                y: uint32);
            1: (u: array [0 .. 1] of uint32);
    end;

    PXMUINT2 = ^TXMUINT2;

    // 3D Vector; 32 bit floating point components

    { TXMFLOAT3 }

    TXMFLOAT3 = record
        constructor Create(x, y, z: single); overload;
        constructor Create(pArray: PSingle); overload;
        case byte of
            0: (x: single;
                y: single;
                z: single);
            1: (f: array [0 .. 2] of single);

    end;

    PXMFLOAT3 = ^TXMFLOAT3;

    // 3D Vector; 32 bit floating point components aligned on a 16 byte boundary

    { TXMFLOAT3A }

    TXMFLOAT3A = record
        constructor Create(x, y, z: single); overload;
        constructor Create(pArray: PSingle); overload;
        case byte of
            0: (x: single;
                y: single;
                z: single;
                Reserved: single);
            1: (f: array [0 .. 2] of single);
            2: (v: TXMFLOAT3);
    end;

    PXMFLOAT3A = ^TXMFLOAT3A;

    // 3D Vector; 32 bit signed integer components

    { TXMINT3 }

    TXMINT3 = record
        constructor Create(x, y, z: int32); overload;
        constructor Create(pArray: PLongint); overload;
        case byte of
            0: (x: int32;
                y: int32;
                z: int32);
            1: (i: array [0 .. 2] of int32);
    end;

    PXMINT3 = ^TXMINT3;

    // 3D Vector; 32 bit unsigned integer components

    { TXMUINT3 }

    TXMUINT3 = record
        constructor Create(x, y, z: uint32); overload;
        constructor Create(pArray: Puint32); overload;
        case byte of
            0: (x: uint32;
                y: uint32;
                z: uint32);
            1: (u: array [0 .. 2] of uint32);

    end;

    PXMUINT3 = ^TXMUINT3;

    // 4D Vector; 32 bit floating point components

    { TXMFLOAT4 }

    TXMFLOAT4 = record
        constructor Create(x, y, z, w: single); overload;
        constructor Create(pArray: PSingle); overload;
        case byte of
            0: (x: single;
                y: single;
                z: single;
                w: single);
            1: (f: array [0 .. 3] of single);
            2: (r: single;
                g: single;
                b: single;
                a: single);
            3: (ux: uint32;
                uy: uint32;
                uz: uint32;
                uw: uint32);
    end;

    PXMFLOAT4 = ^TXMFLOAT4;

    // 4D Vector; 32 bit floating point components aligned on a 16 byte boundary
    TXMFLOAT4A = TXMFLOAT4;
    PXMFLOAT4A = ^TXMFLOAT4A;

    // 4D Vector; 32 bit signed integer components

    { TXMINT4 }

    TXMINT4 = record
        constructor Create(x, y, z, w: int32); overload;
        constructor Create(pArray: PLongint); overload;
        case byte of
            0: (x: int32;
                y: int32;
                z: int32;
                w: int32);
            1: (i: array [0 .. 3] of int32);
    end;

    PXMINT4 = ^TXMINT4;

    // 4D Vector; 32 bit unsigned integer components

    { TXMUINT4 }

    TXMUINT4 = record
        constructor Create(x, y, z, w: uint32); overload;
        constructor Create(pArray: Puint32); overload;
        case byte of
            0: (x: uint32;
                y: uint32;
                z: uint32;
                w: uint32);
            1: (u: array [0 .. 3] of uint32);

    end;

    PXMUINT4 = ^TXMUINT4;

    // 3x3 Matrix: 32 bit floating point components

    { TXMFLOAT3X3 }

    TXMFLOAT3X3 = record
        constructor Create(m00, m01, m02, m10, m11, m12, m20, m21, m22: single); overload;
        constructor Create(pArray: PSingle); overload;
        function Value(Row, Column: DWORD): single;
        case byte of
            0: (_11, _12, _13: single;
                _21, _22, _23: single;
                _31, _32, _33: single);
            1: (m: array [0 .. 2, 0 .. 2] of single);
            2: (f: array [0 .. 8] of single);
    end;

    PXMFLOAT3X3 = ^TXMFLOAT3X3;

    // 4x3 Row-major Matrix: 32 bit floating point components

    { TXMFLOAT4X3 }

    TXMFLOAT4X3 = record
        constructor Create(m00, m01, m02, m10, m11, m12, m20, m21, m22, m30, m31, m32: single); overload;
        constructor Create(pArray: PSingle); overload;
        function Value(Row, Column: DWORD): single;
        case byte of
            0: (_11, _12, _13: single;
                _21, _22, _23: single;
                _31, _32, _33: single;
                _41, _42, _43: single);
            1: (m: array [0 .. 3, 0 .. 2] of single);
            2: (f: array [0 .. 11] of single);
    end;

    PXMFLOAT4X3 = ^TXMFLOAT4X3;

    // 4x3 Row-major Matrix: 32 bit floating point components aligned on a 16 byte boundary
    TXMFLOAT4X3A = TXMFLOAT4X3;
    PXMFLOAT4X3A = ^TXMFLOAT4X3A;

    // 3x4 Column-major Matrix: 32 bit floating point components

    { TXMFLOAT3X4 }

    TXMFLOAT3X4 = record
        constructor Create(m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23: single); overload;
        constructor Create(pArray: PSingle); overload;
        case byte of
            0: (_11, _12, _13, _14: single;
                _21, _22, _23, _24: single;
                _31, _32, _33, _34: single);
            1: (m: array [0 .. 2, 0 .. 3] of single);
            2: (f: array [0 .. 11] of single);
    end;

    PXMFLOAT3X4 = ^TXMFLOAT3X4;

    TXMFLOAT3X4A = TXMFLOAT3X4;
    PXMFLOAT3X4A = ^TXMFLOAT3X4A;

    // 4x4 Matrix: 32 bit floating point components

    { TXMFLOAT4X4 }

    TXMFLOAT4X4 = record
        constructor Create(m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33: single); overload;
        constructor Create(pArray: PSingle); overload;
        case byte of
            0: (_11, _12, _13, _14: single;
                _21, _22, _23, _24: single;
                _31, _32, _33, _34: single;
                _41, _42, _43, _44: single);
            1: (m: array [0 .. 3, 0 .. 3] of single);
    end;

    PXMFLOAT4X4 = ^TXMFLOAT4X4;

    // 4x4 Matrix: 32 bit floating point components aligned on a 16 byte boundary
    TXMFLOAT4X4A = TXMFLOAT4X4;
    PXMFLOAT4X4A = ^TXMFLOAT4X4A;

    (* ***************************************************************************
      *
      * Globals
      *
      *************************************************************************** *)
const
    // The purpose of the following global constants is to prevent redundant
    // reloading of the constants when they are referenced by more than one
    // separate inline math routine called within the same function.  Declaring
    // a constant locally within a routine is sufficient to prevent redundant
    // reloads of that constant when that single routine is called multiple
    // times in a function, but if the constant is used (and declared) in a
    // separate math routine it would be reloaded.

    g_XMSinCoefficients0: TXMVECTOR = (vector4_f32: (-0.16666667, +0.0083333310, -0.00019840874, +2.7525562E-06));
    g_XMSinCoefficients1: TXMVECTOR = (vector4_f32: (-2.3889859E-08, -0.16665852, +0.0083139502, -0.00018524670));
    g_XMCosCoefficients0: TXMVECTOR = (vector4_f32: (-0.5, +0.041666638, -0.0013888378, +2.4760495E-05));
    g_XMCosCoefficients1: TXMVECTOR = (vector4_f32: (-2.6051615E-07, -0.49992746, +0.041493919, -0.0012712436));
    g_XMTanCoefficients0: TXMVECTOR = (vector4_f32: (1.0, 0.333333333, 0.133333333, 5.396825397E-2));
    g_XMTanCoefficients1: TXMVECTOR = (vector4_f32: (2.186948854E-2, 8.863235530E-3, 3.592128167E-3, 1.455834485E-3));
    g_XMTanCoefficients2: TXMVECTOR = (vector4_f32: (5.900274264E-4, 2.391290764E-4, 9.691537707E-5, 3.927832950E-5));
    g_XMArcCoefficients0: TXMVECTOR = (vector4_f32: (+1.5707963050, -0.2145988016, +0.0889789874, -0.0501743046));
    g_XMArcCoefficients1: TXMVECTOR = (vector4_f32: (+0.0308918810, -0.0170881256, +0.0066700901, -0.0012624911));
    g_XMATanCoefficients0: TXMVECTOR = (vector4_f32: (-0.3333314528, +0.1999355085, -0.1420889944, +0.1065626393));
    g_XMATanCoefficients1: TXMVECTOR = (vector4_f32: (-0.0752896400, +0.0429096138, -0.0161657367, +0.0028662257));
    g_XMATanEstCoefficients0: TXMVECTOR = (vector4_f32: (+0.999866, +0.999866, +0.999866, +0.999866));
    g_XMATanEstCoefficients1: TXMVECTOR = (vector4_f32: (-0.3302995, +0.180141, -0.085133, +0.0208351));
    g_XMTanEstCoefficients: TXMVECTOR = (vector4_f32: (2.484, -1.954923183E-1, 2.467401101, XM_1DIVPI));
    g_XMArcEstCoefficients: TXMVECTOR = (vector4_f32: (+1.5707288, -0.2121144, +0.0742610, -0.0187293));
    g_XMPiConstants0: TXMVECTOR = (vector4_f32: (XM_PI, XM_2PI, XM_1DIVPI, XM_1DIV2PI));
    g_XMIdentityR0: TXMVECTOR = (vector4_f32: (1.0, 0.0, 0.0, 0.0));
    g_XMIdentityR1: TXMVECTOR = (vector4_f32: (0.0, 1.0, 0.0, 0.0));
    g_XMIdentityR2: TXMVECTOR = (vector4_f32: (0.0, 0.0, 1.0, 0.0));
    g_XMIdentityR3: TXMVECTOR = (vector4_f32: (0.0, 0.0, 0.0, 1.0));
    g_XMNegIdentityR0: TXMVECTOR = (vector4_f32: (-1.0, 0.0, 0.0, 0.0));
    g_XMNegIdentityR1: TXMVECTOR = (vector4_f32: (0.0, -1.0, 0.0, 0.0));
    g_XMNegIdentityR2: TXMVECTOR = (vector4_f32: (0.0, 0.0, -1.0, 0.0));
    g_XMNegIdentityR3: TXMVECTOR = (vector4_f32: (0.0, 0.0, 0.0, -1.0));
    g_XMNegativeZero: TXMVECTOR = (vector4_u32: ($80000000, $80000000, $80000000, $80000000));
    g_XMNegate3: TXMVECTOR = (vector4_u32: ($80000000, $80000000, $80000000, $00000000));
    g_XMMaskXY: TXMVECTOR = (vector4_u32: ($FFFFFFFF, $FFFFFFFF, $00000000, $00000000));
    g_XMMask3: TXMVECTOR = (vector4_u32: ($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $00000000));
    g_XMMaskX: TXMVECTOR = (vector4_u32: ($FFFFFFFF, $00000000, $00000000, $00000000));
    g_XMMaskY: TXMVECTOR = (vector4_u32: ($00000000, $FFFFFFFF, $00000000, $00000000));
    g_XMMaskZ: TXMVECTOR = (vector4_u32: ($00000000, $00000000, $FFFFFFFF, $00000000));
    g_XMMaskW: TXMVECTOR = (vector4_u32: ($00000000, $00000000, $00000000, $FFFFFFFF));
    g_XMOne: TXMVECTOR = (vector4_f32: (1.0, 1.0, 1.0, 1.0));
    g_XMOne3: TXMVECTOR = (vector4_f32: (1.0, 1.0, 1.0, 0.0));
    g_XMZero: TXMVECTOR = (vector4_f32: (0.0, 0.0, 0.0, 0.0));
    g_XMTwo: TXMVECTOR = (vector4_f32: (2.0, 2.0, 2.0, 2.0));
    g_XMFour: TXMVECTOR = (vector4_f32: (4.0, 4.0, 4.0, 4.0));
    g_XMSix: TXMVECTOR = (vector4_f32: (6.0, 6.0, 6.0, 6.0));
    g_XMNegativeOne: TXMVECTOR = (vector4_f32: (-1.0, -1.0, -1.0, -1.0));
    g_XMOneHalf: TXMVECTOR = (vector4_f32: (0.5, 0.5, 0.5, 0.5));
    g_XMNegativeOneHalf: TXMVECTOR = (vector4_f32: (-0.5, -0.5, -0.5, -0.5));
    g_XMNegativeTwoPi: TXMVECTOR = (vector4_f32: (-XM_2PI, -XM_2PI, -XM_2PI, -XM_2PI));
    g_XMNegativePi: TXMVECTOR = (vector4_f32: (-XM_PI, -XM_PI, -XM_PI, -XM_PI));
    g_XMHalfPi: TXMVECTOR = (vector4_f32: (XM_PIDIV2, XM_PIDIV2, XM_PIDIV2, XM_PIDIV2));
    g_XMPi: TXMVECTOR = (vector4_f32: (XM_PI, XM_PI, XM_PI, XM_PI));
    g_XMReciprocalPi: TXMVECTOR = (vector4_f32: (XM_1DIVPI, XM_1DIVPI, XM_1DIVPI, XM_1DIVPI));
    g_XMTwoPi: TXMVECTOR = (vector4_f32: (XM_2PI, XM_2PI, XM_2PI, XM_2PI));
    g_XMReciprocalTwoPi: TXMVECTOR = (vector4_f32: (XM_1DIV2PI, XM_1DIV2PI, XM_1DIV2PI, XM_1DIV2PI));
    g_XMEpsilon: TXMVECTOR = (vector4_f32: (1.192092896E-7, 1.192092896E-7, 1.192092896E-7, 1.192092896E-7));

    g_XMInfinity: TXMVECTOR = (vector4_i32: ($7F800000, $7F800000, $7F800000, $7F800000));
    g_XMQNaN: TXMVECTOR = (vector4_i32: ($7FC00000, $7FC00000, $7FC00000, $7FC00000));
    g_XMQNaNTest: TXMVECTOR = (vector4_i32: ($007FFFFF, $007FFFFF, $007FFFFF, $007FFFFF));
    g_XMAbsMask: TXMVECTOR = (vector4_i32: ($7FFFFFFF, $7FFFFFFF, $7FFFFFFF, $7FFFFFFF));
    g_XMFltMin: TXMVECTOR = (vector4_i32: ($00800000, $00800000, $00800000, $00800000));
    g_XMFltMax: TXMVECTOR = (vector4_i32: ($7F7FFFFF, $7F7FFFFF, $7F7FFFFF, $7F7FFFFF));
    g_XMNegOneMask: TXMVECTOR = (vector4_u32: ($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF));
    g_XMMaskA8R8G8B8: TXMVECTOR = (vector4_u32: ($00FF0000, $0000FF00, $000000FF, $FF000000));
    g_XMFlipA8R8G8B8: TXMVECTOR = (vector4_u32: ($00000000, $00000000, $00000000, $80000000));
    g_XMFixAA8R8G8B8: TXMVECTOR = (vector4_f32: (0.0, 0.0, 0.0, $80000000));
    g_XMNormalizeA8R8G8B8: TXMVECTOR = (vector4_f32: (1.0 / (255.0 * $10000), 1.0 / (255.0 * $100), 1.0 / 255.0, 1.0 / (255.0 * $1000000)));
    g_XMMaskA2B10G10R10: TXMVECTOR = (vector4_u32: ($000003FF, $000FFC00, $3FF00000, $C0000000));
    g_XMFlipA2B10G10R10: TXMVECTOR = (vector4_u32: ($00000200, $00080000, $20000000, $80000000));
    g_XMFixAA2B10G10R10: TXMVECTOR = (vector4_f32: (-512.0, -512.0 * $400, -512.0 * $100000, $80000000));
    g_XMNormalizeA2B10G10R10: TXMVECTOR = (vector4_f32: (1.0 / 511.0, 1.0 / (511.0 * $400), 1.0 / (511.0 * $100000), 1.0 / (3.0 * $40000000)));
    g_XMMaskX16Y16: TXMVECTOR = (vector4_u32: ($0000FFFF, $FFFF0000, $00000000, $00000000));

    g_XMFlipX16Y16: TXMVECTOR = (vector4_i32: ($00008000, $00000000, $00000000, $00000000));
    g_XMFixX16Y16: TXMVECTOR = (vector4_f32: (-32768.0, 0.0, 0.0, 0.0));
    g_XMNormalizeX16Y16: TXMVECTOR = (vector4_f32: (1.0 / 32767.0, 1.0 / (32767.0 * 65536.0), 0.0, 0.0));
    g_XMMaskX16Y16Z16W16: TXMVECTOR = (vector4_u32: ($0000FFFF, $0000FFFF, $FFFF0000, $FFFF0000));
    g_XMFlipX16Y16Z16W16: TXMVECTOR = (vector4_i32: ($00008000, $00008000, $00000000, $00000000));
    g_XMFixX16Y16Z16W16: TXMVECTOR = (vector4_f32: (-32768.0, -32768.0, 0.0, 0.0));
    g_XMNormalizeX16Y16Z16W16: TXMVECTOR = (vector4_f32: (1.0 / 32767.0, 1.0 / 32767.0, 1.0 / (32767.0 * 65536.0), 1.0 / (32767.0 * 65536.0)));
    g_XMNoFraction: TXMVECTOR = (vector4_f32: (8388608.0, 8388608.0, 8388608.0, 8388608.0));
    g_XMMaskByte: TXMVECTOR = (vector4_i32: ($000000FF, $000000FF, $000000FF, $000000FF));
    g_XMNegateX: TXMVECTOR = (vector4_f32: (-1.0, 1.0, 1.0, 1.0));
    g_XMNegateY: TXMVECTOR = (vector4_f32: (1.0, -1.0, 1.0, 1.0));
    g_XMNegateZ: TXMVECTOR = (vector4_f32: (1.0, 1.0, -1.0, 1.0));
    g_XMNegateW: TXMVECTOR = (vector4_f32: (1.0, 1.0, 1.0, -1.0));
    g_XMSelect0101: TXMVECTOR = (vector4_u32: (XM_SELECT_0, XM_SELECT_1, XM_SELECT_0, XM_SELECT_1));
    g_XMSelect1010: TXMVECTOR = (vector4_u32: (XM_SELECT_1, XM_SELECT_0, XM_SELECT_1, XM_SELECT_0));
    g_XMOneHalfMinusEpsilon: TXMVECTOR = (vector4_i32: ($3EFFFFFD, $3EFFFFFD, $3EFFFFFD, $3EFFFFFD));
    g_XMSelect1000: TXMVECTOR = (vector4_u32: (XM_SELECT_1, XM_SELECT_0, XM_SELECT_0, XM_SELECT_0));
    g_XMSelect1100: TXMVECTOR = (vector4_u32: (XM_SELECT_1, XM_SELECT_1, XM_SELECT_0, XM_SELECT_0));
    g_XMSelect1110: TXMVECTOR = (vector4_u32: (XM_SELECT_1, XM_SELECT_1, XM_SELECT_1, XM_SELECT_0));
    g_XMSelect1011: TXMVECTOR = (vector4_u32: (XM_SELECT_1, XM_SELECT_0, XM_SELECT_1, XM_SELECT_1));
    g_XMFixupY16: TXMVECTOR = (vector4_f32: (1.0, 1.0 / 65536.0, 0.0, 0.0));
    g_XMFixupY16W16: TXMVECTOR = (vector4_f32: (1.0, 1.0, 1.0 / 65536.0, 1.0 / 65536.0));
    g_XMFlipY: TXMVECTOR = (vector4_u32: (0, $80000000, 0, 0));
    g_XMFlipZ: TXMVECTOR = (vector4_u32: (0, 0, $80000000, 0));
    g_XMFlipW: TXMVECTOR = (vector4_u32: (0, 0, 0, $80000000));
    g_XMFlipYZ: TXMVECTOR = (vector4_u32: (0, $80000000, $80000000, 0));
    g_XMFlipZW: TXMVECTOR = (vector4_u32: (0, 0, $80000000, $80000000));
    g_XMFlipYW: TXMVECTOR = (vector4_u32: (0, $80000000, 0, $80000000));
    g_XMMaskDec4: TXMVECTOR = (vector4_i32: ($3FF, $3FF shl 10, $3FF shl 20, $C0000000));
    g_XMXorDec4: TXMVECTOR = (vector4_i32: ($200, $200 shl 10, $200 shl 20, 0));
    g_XMAddUDec4: TXMVECTOR = (vector4_f32: (0, 0, 0, 32768.0 * 65536.0));
    g_XMAddDec4: TXMVECTOR = (vector4_f32: (-512.0, -512.0 * 1024.0, -512.0 * 1024.0 * 1024.0, 0));
    g_XMMulDec4: TXMVECTOR = (vector4_f32: (1.0, 1.0 / 1024.0, 1.0 / (1024.0 * 1024.0), 1.0 / (1024.0 * 1024.0 * 1024.0)));
    g_XMMaskByte4: TXMVECTOR = (vector4_u32: ($FF, $FF00, $FF0000, $FF000000));
    g_XMXorByte4: TXMVECTOR = (vector4_i32: ($80, $8000, $800000, $00000000));
    g_XMAddByte4: TXMVECTOR = (vector4_f32: (-128.0, -128.0 * 256.0, -128.0 * 65536.0, 0));
    g_XMFixUnsigned: TXMVECTOR = (vector4_f32: (32768.0 * 65536.0, 32768.0 * 65536.0, 32768.0 * 65536.0, 32768.0 * 65536.0));
    g_XMMaxInt: TXMVECTOR = (vector4_f32: (65536.0 * 32768.0 - 128.0, 65536.0 * 32768.0 - 128.0, 65536.0 * 32768.0 - 128.0, 65536.0 * 32768.0 - 128.0));
    g_XMMaxUInt: TXMVECTOR = (vector4_f32: (65536.0 * 65536.0 - 256.0, 65536.0 * 65536.0 - 256.0, 65536.0 * 65536.0 - 256.0, 65536.0 * 65536.0 - 256.0));
    g_XMUnsignedFix: TXMVECTOR = (vector4_f32: (32768.0 * 65536.0, 32768.0 * 65536.0, 32768.0 * 65536.0, 32768.0 * 65536.0));
    g_XMsrgbScale: TXMVECTOR = (vector4_f32: (12.92, 12.92, 12.92, 1.0));
    g_XMsrgbA: TXMVECTOR = (vector4_f32: (0.055, 0.055, 0.055, 0.0));
    g_XMsrgbA1: TXMVECTOR = (vector4_f32: (1.055, 1.055, 1.055, 1.0));
    g_XMExponentBias: TXMVECTOR = (vector4_i32: (127, 127, 127, 127));
    g_XMSubnormalExponent: TXMVECTOR = (vector4_i32: (-126, -126, -126, -126));
    g_XMNumTrailing: TXMVECTOR = (vector4_i32: (23, 23, 23, 23));
    g_XMMinNormal: TXMVECTOR = (vector4_i32: ($00800000, $00800000, $00800000, $00800000));
    g_XMNegInfinity: TXMVECTOR = (vector4_u32: ($FF800000, $FF800000, $FF800000, $FF800000));
    g_XMNegQNaN: TXMVECTOR = (vector4_u32: ($FFC00000, $FFC00000, $FFC00000, $FFC00000));
    g_XMBin128: TXMVECTOR = (vector4_i32: ($43000000, $43000000, $43000000, $43000000));
    g_XMBinNeg150: TXMVECTOR = (vector4_u32: ($C3160000, $C3160000, $C3160000, $C3160000));
    g_XM253: TXMVECTOR = (vector4_i32: (253, 253, 253, 253));
    g_XMExpEst1: TXMVECTOR = (vector4_f32: (-6.93147182E-1, -6.93147182E-1, -6.93147182E-1, -6.93147182E-1));
    g_XMExpEst2: TXMVECTOR = (vector4_f32: (+2.40226462E-1, +2.40226462E-1, +2.40226462E-1, +2.40226462E-1));
    g_XMExpEst3: TXMVECTOR = (vector4_f32: (-5.55036440E-2, -5.55036440E-2, -5.55036440E-2, -5.55036440E-2));
    g_XMExpEst4: TXMVECTOR = (vector4_f32: (+9.61597636E-3, +9.61597636E-3, +9.61597636E-3, +9.61597636E-3));
    g_XMExpEst5: TXMVECTOR = (vector4_f32: (-1.32823968E-3, -1.32823968E-3, -1.32823968E-3, -1.32823968E-3));
    g_XMExpEst6: TXMVECTOR = (vector4_f32: (+1.47491097E-4, +1.47491097E-4, +1.47491097E-4, +1.47491097E-4));
    g_XMExpEst7: TXMVECTOR = (vector4_f32: (-1.08635004E-5, -1.08635004E-5, -1.08635004E-5, -1.08635004E-5));
    g_XMLogEst0: TXMVECTOR = (vector4_f32: (+1.442693, +1.442693, +1.442693, +1.442693));
    g_XMLogEst1: TXMVECTOR = (vector4_f32: (-0.721242, -0.721242, -0.721242, -0.721242));
    g_XMLogEst2: TXMVECTOR = (vector4_f32: (+0.479384, +0.479384, +0.479384, +0.479384));
    g_XMLogEst3: TXMVECTOR = (vector4_f32: (-0.350295, -0.350295, -0.350295, -0.350295));
    g_XMLogEst4: TXMVECTOR = (vector4_f32: (+0.248590, +0.248590, +0.248590, +0.248590));
    g_XMLogEst5: TXMVECTOR = (vector4_f32: (-0.145700, -0.145700, -0.145700, -0.145700));
    g_XMLogEst6: TXMVECTOR = (vector4_f32: (+0.057148, +0.057148, +0.057148, +0.057148));
    g_XMLogEst7: TXMVECTOR = (vector4_f32: (-0.010578, -0.010578, -0.010578, -0.010578));
    g_XMLgE: TXMVECTOR = (vector4_f32: (+1.442695, +1.442695, +1.442695, +1.442695));
    g_XMInvLgE: TXMVECTOR = (vector4_f32: (+6.93147182E-1, +6.93147182E-1, +6.93147182E-1, +6.93147182E-1));
    g_XMLg10: TXMVECTOR = (vector4_f32: (+3.321928, +3.321928, +3.321928, +3.321928));
    g_XMInvLg10: TXMVECTOR = (vector4_f32: (+3.010299956E-1, +3.010299956E-1, +3.010299956E-1, +3.010299956E-1));
    g_UByteMax: TXMVECTOR = (vector4_f32: (255.0, 255.0, 255.0, 255.0));
    g_ByteMin: TXMVECTOR = (vector4_f32: (-127.0, -127.0, -127.0, -127.0));
    g_ByteMax: TXMVECTOR = (vector4_f32: (127.0, 127.0, 127.0, 127.0));
    g_ShortMin: TXMVECTOR = (vector4_f32: (-32767.0, -32767.0, -32767.0, -32767.0));
    g_ShortMax: TXMVECTOR = (vector4_f32: (32767.0, 32767.0, 32767.0, 32767.0));
    g_UShortMax: TXMVECTOR = (vector4_f32: (65535.0, 65535.0, 65535.0, 65535.0));

    (* ***************************************************************************
      *
      * Data conversion operations
      *
      *************************************************************************** *)

function XMConvertVectorIntToFloat(VInt: TFXMVECTOR; DivExponent: uint32): TXMVECTOR;
function XMConvertVectorFloatToInt(VFloat: TFXMVECTOR; MulExponent: uint32): TXMVECTOR;
function XMConvertVectorUIntToFloat(VUInt: TFXMVECTOR; DivExponent: uint32): TXMVECTOR;
function XMConvertVectorFloatToUInt(VFloat: TFXMVECTOR; MulExponent: uint32): TXMVECTOR;

function XMVectorSetBinaryConstant(C0: uint32; C1: uint32; C2: uint32; C3: uint32): TXMVECTOR;
function XMVectorSplatConstant(IntConstant: int32; DivExponent: uint32): TXMVECTOR;
function XMVectorSplatConstantInt(IntConstant: int32): TXMVECTOR;

(* ***************************************************************************
  *
  * Load operations
  *
  ************************************************************************** *)

function XMLoadInt(const pSource: Puint32): TXMVECTOR;
function XMLoadFloat(const pSource: PSingle): TXMVECTOR;

function XMLoadInt2(const pSource { 2 }: Puint32): TXMVECTOR;
function XMLoadInt2A(const pSource { 2 }: Puint32): TXMVECTOR;
function XMLoadFloat2(const pSource: PXMFLOAT2): TXMVECTOR;
function XMLoadFloat2A(const pSource: PXMFLOAT2A): TXMVECTOR;
function XMLoadSInt2(const pSource: PXMINT2): TXMVECTOR;
function XMLoadUInt2(const pSource: PXMUINT2): TXMVECTOR;

function XMLoadInt3(const pSource { 3 }: Puint32): TXMVECTOR;
function XMLoadInt3A(const pSource { 3 }: Puint32): TXMVECTOR;
function XMLoadFloat3(const pSource: TXMFLOAT3): TXMVECTOR;
function XMLoadFloat3A(const pSource: PXMFLOAT3A): TXMVECTOR;
function XMLoadSInt3(const pSource: PXMINT3): TXMVECTOR;
function XMLoadUInt3(const pSource: PXMUINT3): TXMVECTOR;

function XMLoadInt4(const pSource { 4 }: Puint32): TXMVECTOR;
function XMLoadInt4A(const pSource { 4 }: Puint32): TXMVECTOR;
function XMLoadFloat4(const pSource: TXMFLOAT4): TXMVECTOR;
function XMLoadFloat4A(const pSource: PXMFLOAT4A): TXMVECTOR;
function XMLoadSInt4(const pSource: PXMINT4): TXMVECTOR;
function XMLoadUInt4(const pSource: PXMUINT4): TXMVECTOR;

function XMLoadFloat3x3(const pSource: PXMFLOAT3X3): TXMMATRIX;
function XMLoadFloat4x3(const pSource: PXMFLOAT4X3): TXMMATRIX;
function XMLoadFloat4x3A(const pSource: PXMFLOAT4X3A): TXMMATRIX;
function XMLoadFloat3x4(const pSource: PXMFLOAT3X4): TXMMATRIX;
function XMLoadFloat3x4A(const pSource: PXMFLOAT3X4A): TXMMATRIX;
function XMLoadFloat4x4(const pSource: PXMFLOAT4X4): TXMMATRIX;
function XMLoadFloat4x4A(const pSource: PXMFLOAT4X4A): TXMMATRIX;

(* ***************************************************************************
  *
  * Store operations
  *
  *************************************************************************** *)

procedure XMStoreInt(out pDestination: uint32; v: TFXMVECTOR);
procedure XMStoreFloat(out pDestination: single; v: TFXMVECTOR);

procedure XMStoreInt2(out pDestination: array of uint32; v: TFXMVECTOR);
procedure XMStoreInt2A(out pDestination: array of uint32; v: TFXMVECTOR);
procedure XMStoreFloat2(var pDestination: PXMFLOAT2; v: TFXMVECTOR);
procedure XMStoreFloat2A(out pDestination: TXMFLOAT2A; v: TFXMVECTOR);
procedure XMStoreSInt2(out pDestination: TXMINT2; v: TFXMVECTOR);
procedure XMStoreUInt2(out pDestination: TXMUINT2; v: TFXMVECTOR);

procedure XMStoreInt3(out pDestination: array of uint32; v: TFXMVECTOR);
procedure XMStoreInt3A(out pDestination: array of uint32; v: TFXMVECTOR);
procedure XMStoreFloat3(var pDestination: TXMFLOAT3; v: TFXMVECTOR);
procedure XMStoreFloat3A(out pDestination: TXMFLOAT3A; v: TFXMVECTOR);
procedure XMStoreSInt3(out pDestination: TXMINT3; v: TFXMVECTOR);
procedure XMStoreUInt3(out pDestination: TXMUINT3; v: TFXMVECTOR);

procedure XMStoreInt4(out pDestination: array { 4 } of uint32; v: TFXMVECTOR);
procedure XMStoreInt4A(out pDestination: array of uint32; v: TFXMVECTOR);
procedure XMStoreFloat4(var pDestination: TXMFLOAT4; v: TFXMVECTOR);
procedure XMStoreFloat4A(out pDestination: TXMFLOAT4A; v: TFXMVECTOR);
procedure XMStoreSInt4(out pDestination: TXMINT4; v: TFXMVECTOR);
procedure XMStoreUInt4(out pDestination: TXMUINT4; v: TFXMVECTOR);

procedure XMStoreFloat3x3(out pDestination: TXMFLOAT3X3; m: TFXMMATRIX);
procedure XMStoreFloat4x3(out pDestination: TXMFLOAT4X3; m: TFXMMATRIX);
procedure XMStoreFloat4x3A(var pDestination: TXMFLOAT4X3A; m: TFXMMATRIX);
procedure XMStoreFloat3x4(out pDestination: TXMFLOAT3X4; m: TFXMMATRIX);
procedure XMStoreFloat3x4A(out pDestination: TXMFLOAT3X4A; m: TFXMMATRIX);
procedure XMStoreFloat4x4(out pDestination: TXMFLOAT4X4; m: TFXMMATRIX);
procedure XMStoreFloat4x4A(out pDestination: TXMFLOAT4X4A; m: TFXMMATRIX);

(* ***************************************************************************
  *
  * General vector operations
  *
  *************************************************************************** *)

function XMVectorZero(): TXMVECTOR;
function XMVectorSet(x, y, z, w: single): TXMVECTOR;
function XMVectorSetInt(x, y, z, w: uint32): TXMVECTOR;
function XMVectorReplicate(const Value: single): TXMVECTOR;
function XMVectorReplicatePtr(const pValue: PSingle): TXMVECTOR;
function XMVectorReplicateInt(Value: uint32): TXMVECTOR;
function XMVectorReplicateIntPtr(const pValue: Puint32): TXMVECTOR;
function XMVectorTrueInt(): TXMVECTOR;
function XMVectorFalseInt(): TXMVECTOR;
function XMVectorSplatX(const v: TFXMVECTOR): TXMVECTOR;
function XMVectorSplatY(v: TFXMVECTOR): TXMVECTOR;
function XMVectorSplatZ(v: TFXMVECTOR): TXMVECTOR;
function XMVectorSplatW(v: TFXMVECTOR): TXMVECTOR;
function XMVectorSplatOne(): TXMVECTOR;
function XMVectorSplatInfinity(): TXMVECTOR;
function XMVectorSplatQNaN(): TXMVECTOR;
function XMVectorSplatEpsilon(): TXMVECTOR;
function XMVectorSplatSignMask(): TXMVECTOR;

function XMVectorGetByIndex(v: TFXMVECTOR; i: size_t): single;
function XMVectorGetX(const v: TFXMVECTOR): single;
function XMVectorGetY(v: TFXMVECTOR): single;
function XMVectorGetZ(v: TFXMVECTOR): single;
function XMVectorGetW(v: TFXMVECTOR): single;

procedure XMVectorGetByIndexPtr(out f: single; v: TFXMVECTOR; i: size_t);
procedure XMVectorGetXPtr(out x: single; v: TFXMVECTOR);
procedure XMVectorGetYPtr(out y: single; v: TFXMVECTOR);
procedure XMVectorGetZPtr(out z: single; v: TFXMVECTOR);
procedure XMVectorGetWPtr(out w: single; v: TFXMVECTOR);

function XMVectorGetIntByIndex(v: TFXMVECTOR; i: size_t): uint32;
function XMVectorGetIntX(v: TFXMVECTOR): uint32;
function XMVectorGetIntY(v: TFXMVECTOR): uint32;
function XMVectorGetIntZ(v: TFXMVECTOR): uint32;
function XMVectorGetIntW(v: TFXMVECTOR): uint32;

procedure XMVectorGetIntByIndexPtr(out x: uint32; v: TFXMVECTOR; i: size_t);
procedure XMVectorGetIntXPtr(out x: uint32; v: TFXMVECTOR);
procedure XMVectorGetIntYPtr(out y: uint32; v: TFXMVECTOR);
procedure XMVectorGetIntZPtr(out z: uint32; v: TFXMVECTOR);
procedure XMVectorGetIntWPtr(out w: uint32; v: TFXMVECTOR);

function XMVectorSetByIndex(v: TFXMVECTOR; f: single; i: size_t): TXMVECTOR;
function XMVectorSetX(v: TFXMVECTOR; x: single): TXMVECTOR;
function XMVectorSetY(v: TFXMVECTOR; y: single): TXMVECTOR;
function XMVectorSetZ(v: TFXMVECTOR; z: single): TXMVECTOR;
function XMVectorSetW(v: TFXMVECTOR; w: single): TXMVECTOR;

function XMVectorSetByIndexPtr(v: TFXMVECTOR; const f: PSingle; i: size_t): TXMVECTOR;
function XMVectorSetXPtr(v: TFXMVECTOR; const x: PSingle): TXMVECTOR;
function XMVectorSetYPtr(v: TFXMVECTOR; const y: PSingle): TXMVECTOR;
function XMVectorSetZPtr(v: TFXMVECTOR; const z: PSingle): TXMVECTOR;
function XMVectorSetWPtr(v: TFXMVECTOR; const w: PSingle): TXMVECTOR;

function XMVectorSetIntByIndex(v: TFXMVECTOR; x: uint32; i: size_t): TXMVECTOR;
function XMVectorSetIntX(v: TFXMVECTOR; x: uint32): TXMVECTOR;
function XMVectorSetIntY(v: TFXMVECTOR; y: uint32): TXMVECTOR;
function XMVectorSetIntZ(v: TFXMVECTOR; z: uint32): TXMVECTOR;
function XMVectorSetIntW(v: TFXMVECTOR; w: uint32): TXMVECTOR;

function XMVectorSetIntByIndexPtr(v: TFXMVECTOR; const x: Puint32; i: size_t): TXMVECTOR;
function XMVectorSetIntXPtr(v: TFXMVECTOR; const x: Puint32): TXMVECTOR;
function XMVectorSetIntYPtr(v: TFXMVECTOR; const y: Puint32): TXMVECTOR;
function XMVectorSetIntZPtr(v: TFXMVECTOR; const z: Puint32): TXMVECTOR;
function XMVectorSetIntWPtr(v: TFXMVECTOR; const w: Puint32): TXMVECTOR;

function XMVectorSwizzle(v: TFXMVECTOR; E0, E1, E2, E3: uint32): TXMVECTOR; overload;
function XMVectorPermute(const V1: TFXMVECTOR; const V2: TFXMVECTOR; PermuteX, PermuteY, PermuteZ, PermuteW: uint32): TXMVECTOR; overload;
function XMVectorSelectControl(VectorIndex0, VectorIndex1, VectorIndex2, VectorIndex3: uint32): TXMVECTOR;
function XMVectorSelect(V1: TFXMVECTOR; V2: TFXMVECTOR; Control: TFXMVECTOR): TXMVECTOR;
function XMVectorMergeXY(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorMergeZW(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;

function XMVectorShiftLeft(V1: TFXMVECTOR; V2: TFXMVECTOR; Elements: uint32): TXMVECTOR;
function XMVectorRotateLeft(v: TFXMVECTOR; Elements: uint32): TXMVECTOR;
function XMVectorRotateRight(v: TFXMVECTOR; Elements: uint32): TXMVECTOR;
function XMVectorInsert(VD: TFXMVECTOR; VS: TFXMVECTOR; VSLeftRotateElements, Select0, Select1, Select2, Select3: uint32): TXMVECTOR; overload;
function XMVectorInsert(VSLeftRotateElements, Select0, Select1, Select2, Select3: uint32; VD, VS: TFXMVECTOR): TXMVECTOR; overload;

function XMVectorEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorEqualR(out CR: uint32; V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorEqualInt(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorEqualIntR(out CR: uint32; V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorNearEqual(V1: TFXMVECTOR; V2: TFXMVECTOR; Epsilon: TFXMVECTOR): TXMVECTOR;
function XMVectorNotEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorNotEqualInt(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorGreater(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorGreaterR(out CR: uint32; V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorGreaterOrEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorGreaterOrEqualR(out CR: uint32; V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorLess(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorLessOrEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorInBounds(v: TFXMVECTOR; Bounds: TFXMVECTOR): TXMVECTOR;
function XMVectorInBoundsR(out CR: uint32; v: TFXMVECTOR; Bounds: TFXMVECTOR): TXMVECTOR;

function XMVectorIsNaN(v: TFXMVECTOR): TXMVECTOR;
function XMVectorIsInfinite(v: TFXMVECTOR): TXMVECTOR;

function XMVectorMin(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorMax(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorRound(v: TFXMVECTOR): TXMVECTOR;
function XMVectorTruncate(v: TFXMVECTOR): TXMVECTOR;
function XMVectorFloor(v: TFXMVECTOR): TXMVECTOR;
function XMVectorCeiling(v: TFXMVECTOR): TXMVECTOR;
function XMVectorClamp(v: TFXMVECTOR; Min: TFXMVECTOR; Max: TFXMVECTOR): TXMVECTOR;
function XMVectorSaturate(v: TFXMVECTOR): TXMVECTOR;

function XMVectorAndInt(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorAndCInt(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorOrInt(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorNorInt(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorXorInt(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;

function XMVectorNegate({$IFDEF FPC}constref{$ELSE}{$ENDIF}v: TFXMVECTOR): TXMVECTOR;
function XMVectorAdd(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorSum(v: TFXMVECTOR): TXMVECTOR;
function XMVectorAddAngles(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorSubtract(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorSubtractAngles(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorMultiply(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorMultiplyAdd(V1: TFXMVECTOR; V2: TFXMVECTOR; V3: TFXMVECTOR): TXMVECTOR;
function XMVectorDivide(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorNegativeMultiplySubtract(V1: TFXMVECTOR; V2: TFXMVECTOR; V3: TFXMVECTOR): TXMVECTOR;
function XMVectorScale(v: TFXMVECTOR; ScaleFactor: single): TXMVECTOR;
function XMVectorReciprocalEst(v: TFXMVECTOR): TXMVECTOR;
function XMVectorReciprocal(v: TFXMVECTOR): TXMVECTOR;
function XMVectorSqrtEst(v: TFXMVECTOR): TXMVECTOR;
function XMVectorSqrt(v: TFXMVECTOR): TXMVECTOR;
function XMVectorReciprocalSqrtEst(v: TFXMVECTOR): TXMVECTOR;
function XMVectorReciprocalSqrt(v: TFXMVECTOR): TXMVECTOR;
function XMVectorExp2(v: TFXMVECTOR): TXMVECTOR;
function XMVectorExp10(v: TFXMVECTOR): TXMVECTOR;
function XMVectorExpE(v: TFXMVECTOR): TXMVECTOR;
function XMVectorExp(v: TFXMVECTOR): TXMVECTOR;
function XMVectorLog2(v: TFXMVECTOR): TXMVECTOR;
function XMVectorLog10(v: TFXMVECTOR): TXMVECTOR;
function XMVectorLogE(v: TFXMVECTOR): TXMVECTOR;
function XMVectorLog(v: TFXMVECTOR): TXMVECTOR;
function XMVectorPow(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorAbs(v: TFXMVECTOR): TXMVECTOR;
function XMVectorMod(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVectorModAngles(Angles: TFXMVECTOR): TXMVECTOR;
function XMVectorSin(v: TFXMVECTOR): TXMVECTOR;
function XMVectorSinEst(v: TFXMVECTOR): TXMVECTOR;
function XMVectorCos(v: TFXMVECTOR): TXMVECTOR;
function XMVectorCosEst(v: TFXMVECTOR): TXMVECTOR;
procedure XMVectorSinCos(out pSin: TXMVECTOR; out pCos: TXMVECTOR; v: TFXMVECTOR);
procedure XMVectorSinCosEst(out pSin: TXMVECTOR; out pCos: TXMVECTOR; v: TFXMVECTOR);
function XMVectorTan(v: TFXMVECTOR): TXMVECTOR;
function XMVectorTanEst(v: TFXMVECTOR): TXMVECTOR;
function XMVectorSinH(v: TFXMVECTOR): TXMVECTOR;
function XMVectorCosH(v: TFXMVECTOR): TXMVECTOR;
function XMVectorTanH(v: TFXMVECTOR): TXMVECTOR;
function XMVectorASin(v: TFXMVECTOR): TXMVECTOR;
function XMVectorASinEst(v: TFXMVECTOR): TXMVECTOR;
function XMVectorACos(v: TFXMVECTOR): TXMVECTOR;
function XMVectorACosEst(v: TFXMVECTOR): TXMVECTOR;
function XMVectorATan(v: TFXMVECTOR): TXMVECTOR;
function XMVectorATanEst(v: TFXMVECTOR): TXMVECTOR;
function XMVectorATan2(y: TFXMVECTOR; x: TFXMVECTOR): TXMVECTOR;
function XMVectorATan2Est(y: TFXMVECTOR; x: TFXMVECTOR): TXMVECTOR;
function XMVectorLerp(V0: TFXMVECTOR; V1: TFXMVECTOR; t: single): TXMVECTOR;
function XMVectorLerpV(V0: TFXMVECTOR; V1: TFXMVECTOR; t: TFXMVECTOR): TXMVECTOR;
function XMVectorHermite(Position0: TFXMVECTOR; Tangent0: TFXMVECTOR; Position1: TFXMVECTOR; Tangent1: TGXMVECTOR; t: single): TXMVECTOR;
function XMVectorHermiteV(Position0: TFXMVECTOR; Tangent0: TFXMVECTOR; Position1: TFXMVECTOR; Tangent1: TGXMVECTOR; t: THXMVECTOR): TXMVECTOR;
function XMVectorCatmullRom(Position0: TFXMVECTOR; Position1: TFXMVECTOR; Position2: TFXMVECTOR; Position3: TGXMVECTOR; t: single): TXMVECTOR;
function XMVectorCatmullRomV(Position0: TFXMVECTOR; Position1: TFXMVECTOR; Position2: TFXMVECTOR; Position3: TGXMVECTOR; t: THXMVECTOR): TXMVECTOR;
function XMVectorBaryCentric(Position0: TFXMVECTOR; Position1: TFXMVECTOR; Position2: TFXMVECTOR; f, g: single): TXMVECTOR;
function XMVectorBaryCentricV(Position0: TFXMVECTOR; Position1: TFXMVECTOR; Position2: TFXMVECTOR; f: TGXMVECTOR; g: THXMVECTOR): TXMVECTOR;

(* ***************************************************************************
  *
  * 2D vector operations
  *
  *************************************************************************** *)

function XMVector2Equal(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector2EqualR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
function XMVector2EqualInt(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector2EqualIntR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
function XMVector2NearEqual(V1: TFXMVECTOR; V2: TFXMVECTOR; Epsilon: TFXMVECTOR): boolean;
function XMVector2NotEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector2NotEqualInt(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector2Greater(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector2GreaterR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
function XMVector2GreaterOrEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector2GreaterOrEqualR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
function XMVector2Less(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector2LessOrEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector2InBounds(v: TFXMVECTOR; Bounds: TFXMVECTOR): boolean;

function XMVector2IsNaN(v: TFXMVECTOR): boolean;
function XMVector2IsInfinite(v: TFXMVECTOR): boolean;

function XMVector2Dot(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVector2Cross(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVector2LengthSq(v: TFXMVECTOR): TXMVECTOR;
function XMVector2ReciprocalLengthEst(v: TFXMVECTOR): TXMVECTOR;
function XMVector2ReciprocalLength(v: TFXMVECTOR): TXMVECTOR;
function XMVector2LengthEst(v: TFXMVECTOR): TXMVECTOR;
function XMVector2Length(v: TFXMVECTOR): TXMVECTOR;
function XMVector2NormalizeEst(v: TFXMVECTOR): TXMVECTOR;
function XMVector2Normalize(v: TFXMVECTOR): TXMVECTOR;
function XMVector2ClampLength(v: TFXMVECTOR; LengthMin, LengthMax: single): TXMVECTOR;
function XMVector2ClampLengthV(v: TFXMVECTOR; LengthMin: TFXMVECTOR; LengthMax: TFXMVECTOR): TXMVECTOR;
function XMVector2Reflect(Incident: TFXMVECTOR; Normal: TFXMVECTOR): TXMVECTOR;
function XMVector2Refract(Incident: TFXMVECTOR; Normal: TFXMVECTOR; RefractionIndex: single): TXMVECTOR;
function XMVector2RefractV(Incident: TFXMVECTOR; Normal: TFXMVECTOR; RefractionIndex: TFXMVECTOR): TXMVECTOR;
function XMVector2Orthogonal(v: TFXMVECTOR): TXMVECTOR;
function XMVector2AngleBetweenNormalsEst(N1: TFXMVECTOR; N2: TFXMVECTOR): TXMVECTOR;
function XMVector2AngleBetweenNormals(N1: TFXMVECTOR; N2: TFXMVECTOR): TXMVECTOR;
function XMVector2AngleBetweenVectors(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVector2LinePointDistance(LinePoint1: TFXMVECTOR; LinePoint2: TFXMVECTOR; Point: TFXMVECTOR): TXMVECTOR;
function XMVector2IntersectLine(Line1Point1: TFXMVECTOR; Line1Point2: TFXMVECTOR; Line2Point1: TFXMVECTOR; Line2Point2: TGXMVECTOR): TXMVECTOR;
function XMVector2Transform(v: TFXMVECTOR; m: TFXMMATRIX): TXMVECTOR;
function XMVector2TransformStream(var pOutputStream: PXMFLOAT4; OutputStride: size_t; const pInputStream: PXMFLOAT2; InputStride: size_t; VectorCount: size_t; m: TFXMMATRIX): PXMFLOAT4;
function XMVector2TransformCoord(v: TFXMVECTOR; m: TFXMMATRIX): TXMVECTOR;
function XMVector2TransformCoordStream(var pOutputStream: PXMFLOAT2; OutputStride: size_t; const pInputStream: PXMFLOAT2; InputStride: size_t; VectorCount: size_t; m: TFXMMATRIX): PXMFLOAT2;
function XMVector2TransformNormal(v: TFXMVECTOR; m: TFXMMATRIX): TXMVECTOR;
function XMVector2TransformNormalStream(var pOutputStream: PXMFLOAT2; OutputStride: size_t; const pInputStream: PXMFLOAT2; InputStride: size_t; VectorCount: size_t; m: TFXMMATRIX): PXMFLOAT2;

(* ***************************************************************************
  *
  * 3D vector operations
  *
  *************************************************************************** *)

function XMVector3Equal(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector3EqualR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
function XMVector3EqualInt(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector3EqualIntR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
function XMVector3NearEqual(V1: TFXMVECTOR; V2: TFXMVECTOR; Epsilon: TFXMVECTOR): boolean;
function XMVector3NotEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector3NotEqualInt(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector3Greater(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector3GreaterR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
function XMVector3GreaterOrEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector3GreaterOrEqualR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
function XMVector3Less(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector3LessOrEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector3InBounds(v: TFXMVECTOR; Bounds: TFXMVECTOR): boolean;

function XMVector3IsNaN(v: TFXMVECTOR): boolean;
function XMVector3IsInfinite(v: TFXMVECTOR): boolean;

function XMVector3Dot(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVector3Cross(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVector3LengthSq(v: TFXMVECTOR): TXMVECTOR;
function XMVector3ReciprocalLengthEst(v: TFXMVECTOR): TXMVECTOR;
function XMVector3ReciprocalLength(v: TFXMVECTOR): TXMVECTOR;
function XMVector3LengthEst(v: TFXMVECTOR): TXMVECTOR;
function XMVector3Length(v: TFXMVECTOR): TXMVECTOR;
function XMVector3NormalizeEst(v: TFXMVECTOR): TXMVECTOR;
function XMVector3Normalize(v: TFXMVECTOR): TXMVECTOR;
function XMVector3ClampLength(v: TFXMVECTOR; LengthMin, LengthMax: single): TXMVECTOR;
function XMVector3ClampLengthV(v: TFXMVECTOR; LengthMin: TFXMVECTOR; LengthMax: TFXMVECTOR): TXMVECTOR;
function XMVector3Reflect(Incident: TFXMVECTOR; Normal: TFXMVECTOR): TXMVECTOR;
function XMVector3Refract(Incident: TFXMVECTOR; Normal: TFXMVECTOR; RefractionIndex: single): TXMVECTOR;
function XMVector3RefractV(Incident: TFXMVECTOR; Normal: TFXMVECTOR; RefractionIndex: TFXMVECTOR): TXMVECTOR;
function XMVector3Orthogonal(v: TFXMVECTOR): TXMVECTOR;
function XMVector3AngleBetweenNormalsEst(N1: TFXMVECTOR; N2: TFXMVECTOR): TXMVECTOR;
function XMVector3AngleBetweenNormals(N1: TFXMVECTOR; N2: TFXMVECTOR): TXMVECTOR;
function XMVector3AngleBetweenVectors(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVector3LinePointDistance(LinePoint1: TFXMVECTOR; LinePoint2: TFXMVECTOR; Point: TFXMVECTOR): TXMVECTOR;
procedure XMVector3ComponentsFromNormal(var Parallel: TXMVECTOR; var Perpendicular: TXMVECTOR; v: TFXMVECTOR; Normal: TFXMVECTOR);
function XMVector3Rotate(v: TFXMVECTOR; RotationQuaternion: TFXMVECTOR): TXMVECTOR;
function XMVector3InverseRotate(v: TFXMVECTOR; RotationQuaternion: TFXMVECTOR): TXMVECTOR;
function XMVector3Transform(v: TFXMVECTOR; m: TFXMMATRIX): TXMVECTOR;
function XMVector3TransformStream(var pOutputStream: PXMFLOAT4; OutputStride: size_t; const pInputStream: PXMFLOAT3; InputStride: size_t; VectorCount: size_t; m: TFXMMATRIX): PXMFLOAT4;
function XMVector3TransformCoord(v: TFXMVECTOR; m: TFXMMATRIX): TXMVECTOR;
function XMVector3TransformCoordStream(var pOutputStream: PXMFLOAT3; OutputStride: size_t; const pInputStream: PXMFLOAT3; InputStride: size_t; VectorCount: size_t; m: TFXMMATRIX): PXMFLOAT3;
function XMVector3TransformNormal(v: TFXMVECTOR; m: TFXMMATRIX): TXMVECTOR;
function XMVector3TransformNormalStream(var pOutputStream: PXMFLOAT3; OutputStride: size_t; const pInputStream: PXMFLOAT3; InputStride: size_t; VectorCount: size_t; m: TFXMMATRIX): PXMFLOAT3;
function XMVector3Project(v: TFXMVECTOR; ViewportX, ViewportY, ViewportWidth, ViewportHeight, ViewportMinZ, ViewportMaxZ: single; Projection: TFXMMATRIX; View: TCXMMATRIX; World: TCXMMATRIX): TXMVECTOR;
function XMVector3ProjectStream(var pOutputStream: PXMFLOAT3; OutputStride: size_t; const pInputStream: PXMFLOAT3; InputStride: size_t; VectorCount: size_t;
    ViewportX, ViewportY, ViewportWidth, ViewportHeight, ViewportMinZ, ViewportMaxZ: single; Projection: TFXMMATRIX; View: TCXMMATRIX; World: TCXMMATRIX): PXMFLOAT3;
function XMVector3Unproject(v: TFXMVECTOR; ViewportX, ViewportY, ViewportWidth, ViewportHeight, ViewportMinZ, ViewportMaxZ: single; Projection: TFXMMATRIX; View: TCXMMATRIX; World: TCXMMATRIX): TXMVECTOR;
function XMVector3UnprojectStream(var pOutputStream: PXMFLOAT3; OutputStride: size_t; const pInputStream: PXMFLOAT3; InputStride: size_t; VectorCount: size_t;
    ViewportX, ViewportY, ViewportWidth, ViewportHeight, ViewportMinZ, ViewportMaxZ: single; Projection: TFXMMATRIX; View: TCXMMATRIX; World: TCXMMATRIX): PXMFLOAT3;

(* ***************************************************************************
  *
  * 4D vector operations
  *
  *************************************************************************** *)

function XMVector4Equal(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector4EqualR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
function XMVector4EqualInt(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector4EqualIntR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
function XMVector4NearEqual(V1: TFXMVECTOR; V2: TFXMVECTOR; Epsilon: TFXMVECTOR): boolean;
function XMVector4NotEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector4NotEqualInt(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector4Greater(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector4GreaterR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
function XMVector4GreaterOrEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector4GreaterOrEqualR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
function XMVector4Less(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector4LessOrEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
function XMVector4InBounds(v: TFXMVECTOR; Bounds: TFXMVECTOR): boolean;

function XMVector4IsNaN(v: TFXMVECTOR): boolean;
function XMVector4IsInfinite(v: TFXMVECTOR): boolean;

function XMVector4Dot(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVector4Cross(V1: TFXMVECTOR; V2: TFXMVECTOR; V3: TFXMVECTOR): TXMVECTOR;
function XMVector4LengthSq(v: TFXMVECTOR): TXMVECTOR;
function XMVector4ReciprocalLengthEst(v: TFXMVECTOR): TXMVECTOR;
function XMVector4ReciprocalLength(v: TFXMVECTOR): TXMVECTOR;
function XMVector4LengthEst(v: TFXMVECTOR): TXMVECTOR;
function XMVector4Length(v: TFXMVECTOR): TXMVECTOR;
function XMVector4NormalizeEst(v: TFXMVECTOR): TXMVECTOR;
function XMVector4Normalize(v: TFXMVECTOR): TXMVECTOR;
function XMVector4ClampLength(v: TFXMVECTOR; LengthMin, LengthMax: single): TXMVECTOR;
function XMVector4ClampLengthV(v: TFXMVECTOR; LengthMin: TFXMVECTOR; LengthMax: TFXMVECTOR): TXMVECTOR;
function XMVector4Reflect(Incident: TFXMVECTOR; Normal: TFXMVECTOR): TXMVECTOR;
function XMVector4Refract(Incident: TFXMVECTOR; Normal: TFXMVECTOR; RefractionIndex: single): TXMVECTOR;
function XMVector4RefractV(Incident: TFXMVECTOR; Normal: TFXMVECTOR; RefractionIndex: TFXMVECTOR): TXMVECTOR;
function XMVector4Orthogonal(v: TFXMVECTOR): TXMVECTOR;
function XMVector4AngleBetweenNormalsEst(N1: TFXMVECTOR; N2: TFXMVECTOR): TXMVECTOR;
function XMVector4AngleBetweenNormals(N1: TFXMVECTOR; N2: TFXMVECTOR): TXMVECTOR;
function XMVector4AngleBetweenVectors(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
function XMVector4Transform(v: TFXMVECTOR; m: TFXMMATRIX): TXMVECTOR;
function XMVector4TransformStream(var pOutputStream: PXMFLOAT4; OutputStride: size_t; const pInputStream: PXMFLOAT4; InputStride: size_t; VectorCount: size_t; m: TFXMMATRIX): PXMFLOAT4;

(* ***************************************************************************
  *
  * Matrix operations
  *
  *************************************************************************** *)

function XMMatrixIsNaN(m: TFXMMATRIX): boolean;
function XMMatrixIsInfinite(m: TFXMMATRIX): boolean;
function XMMatrixIsIdentity(m: TFXMMATRIX): boolean;

function XMMatrixMultiply(M1: TFXMMATRIX; M2: TCXMMATRIX): TXMMATRIX;
function XMMatrixMultiplyTranspose(M1: TFXMMATRIX; M2: TCXMMATRIX): TXMMATRIX;
function XMMatrixTranspose(m: TFXMMATRIX): TXMMATRIX;
function XMMatrixInverse(var pDeterminant: TXMVECTOR; m: TFXMMATRIX): TXMMATRIX;
function XMMatrixVectorTensorProduct(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMMATRIX;
function XMMatrixDeterminant(m: TFXMMATRIX): TXMVECTOR;

function XMMatrixDecompose(out outScale: TXMVECTOR; out outRotQuat: TXMVECTOR; out outTrans: TXMVECTOR; m: TFXMMATRIX): boolean;

function XMMatrixIdentity(): TXMMATRIX;
function XMMatrixSet(m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33: single): TXMMATRIX;
function XMMatrixTranslation(OffsetX, OffsetY, OffsetZ: single): TXMMATRIX;
function XMMatrixTranslationFromVector(Offset: TFXMVECTOR): TXMMATRIX;
function XMMatrixScaling(ScaleX, ScaleY, ScaleZ: single): TXMMATRIX;
function XMMatrixScalingFromVector(Scale: TFXMVECTOR): TXMMATRIX;
function XMMatrixRotationX(Angle: single): TXMMATRIX;
function XMMatrixRotationY(Angle: single): TXMMATRIX;
function XMMatrixRotationZ(Angle: single): TXMMATRIX;

// Rotates about y-axis (Yaw), then x-axis (Pitch), then z-axis (Roll)
function XMMatrixRotationRollPitchYaw(Pitch, Yaw, Roll: single): TXMMATRIX;

// Rotates about y-axis (Angles.y), then x-axis (Angles.x), then z-axis (Angles.z)
function XMMatrixRotationRollPitchYawFromVector(Angles: TFXMVECTOR): TXMMATRIX;

function XMMatrixRotationNormal(NormalAxis: TFXMVECTOR; Angle: single): TXMMATRIX;
function XMMatrixRotationAxis(Axis: TFXMVECTOR; Angle: single): TXMMATRIX;
function XMMatrixRotationQuaternion(Quaternion: TFXMVECTOR): TXMMATRIX;
function XMMatrixTransformation2D(ScalingOrigin: TFXMVECTOR; ScalingOrientation: single; Scaling: TFXMVECTOR; RotationOrigin: TFXMVECTOR; Rotation: single; Translation: TGXMVECTOR): TXMMATRIX;
function XMMatrixTransformation(ScalingOrigin: TFXMVECTOR; ScalingOrientationQuaternion: TFXMVECTOR; Scaling: TFXMVECTOR; RotationOrigin: TGXMVECTOR; RotationQuaternion: THXMVECTOR; Translation: THXMVECTOR): TXMMATRIX;
function XMMatrixAffineTransformation2D(Scaling: TFXMVECTOR; RotationOrigin: TFXMVECTOR; Rotation: single; Translation: TFXMVECTOR): TXMMATRIX;

function XMMatrixAffineTransformation(Scaling: TFXMVECTOR; RotationOrigin: TFXMVECTOR; RotationQuaternion: TFXMVECTOR; Translation: TGXMVECTOR): TXMMATRIX;
function XMMatrixReflect(ReflectionPlane: TFXMVECTOR): TXMMATRIX;
function XMMatrixShadow(ShadowPlane: TFXMVECTOR; LightPosition: TFXMVECTOR): TXMMATRIX;

function XMMatrixLookAtLH(EyePosition: TFXMVECTOR; FocusPosition: TFXMVECTOR; UpDirection: TFXMVECTOR): TXMMATRIX;
function XMMatrixLookAtRH(EyePosition: TFXMVECTOR; FocusPosition: TFXMVECTOR; UpDirection: TFXMVECTOR): TXMMATRIX;
function XMMatrixLookToLH(EyePosition: TFXMVECTOR; EyeDirection: TFXMVECTOR; UpDirection: TFXMVECTOR): TXMMATRIX;
function XMMatrixLookToRH(EyePosition: TFXMVECTOR; EyeDirection: TFXMVECTOR; UpDirection: TFXMVECTOR): TXMMATRIX;
function XMMatrixPerspectiveLH(ViewWidth, ViewHeight, NearZ, FarZ: single): TXMMATRIX;
function XMMatrixPerspectiveRH(ViewWidth, ViewHeight, NearZ, FarZ: single): TXMMATRIX;
function XMMatrixPerspectiveFovLH(FovAngleY, AspectRatio, NearZ, FarZ: single): TXMMATRIX;
function XMMatrixPerspectiveFovRH(FovAngleY, AspectRatio, NearZ, FarZ: single): TXMMATRIX;
function XMMatrixPerspectiveOffCenterLH(ViewLeft, ViewRight, ViewBottom, ViewTop, NearZ, FarZ: single): TXMMATRIX;
function XMMatrixPerspectiveOffCenterRH(ViewLeft, ViewRight, ViewBottom, ViewTop, NearZ, FarZ: single): TXMMATRIX;
function XMMatrixOrthographicLH(ViewWidth, ViewHeight, NearZ, FarZ: single): TXMMATRIX;
function XMMatrixOrthographicRH(ViewWidth, ViewHeight, NearZ, FarZ: single): TXMMATRIX;
function XMMatrixOrthographicOffCenterLH(ViewLeft, ViewRight, ViewBottom, ViewTop, NearZ, FarZ: single): TXMMATRIX;
function XMMatrixOrthographicOffCenterRH(ViewLeft, ViewRight, ViewBottom, ViewTop, NearZ, FarZ: single): TXMMATRIX;

(* ***************************************************************************
  *
  * Quaternion operations
  *
  *************************************************************************** *)

function XMQuaternionEqual(Q1: TFXMVECTOR; Q2: TFXMVECTOR): boolean;
function XMQuaternionNotEqual(Q1: TFXMVECTOR; Q2: TFXMVECTOR): boolean;

function XMQuaternionIsNaN(Q: TFXMVECTOR): boolean;
function XMQuaternionIsInfinite(Q: TFXMVECTOR): boolean;
function XMQuaternionIsIdentity(Q: TFXMVECTOR): boolean;

function XMQuaternionDot(Q1: TFXMVECTOR; Q2: TFXMVECTOR): TXMVECTOR;
function XMQuaternionMultiply(Q1: TFXMVECTOR; Q2: TFXMVECTOR): TXMVECTOR;
function XMQuaternionLengthSq(Q: TFXMVECTOR): TXMVECTOR;
function XMQuaternionReciprocalLength(Q: TFXMVECTOR): TXMVECTOR;
function XMQuaternionLength(Q: TFXMVECTOR): TXMVECTOR;
function XMQuaternionNormalizeEst(Q: TFXMVECTOR): TXMVECTOR;
function XMQuaternionNormalize(Q: TFXMVECTOR): TXMVECTOR;
function XMQuaternionConjugate(Q: TFXMVECTOR): TXMVECTOR;
function XMQuaternionInverse(Q: TFXMVECTOR): TXMVECTOR;
function XMQuaternionLn(Q: TFXMVECTOR): TXMVECTOR;
function XMQuaternionExp(Q: TFXMVECTOR): TXMVECTOR;
function XMQuaternionSlerp(Q0: TFXMVECTOR; Q1: TFXMVECTOR; t: single): TXMVECTOR;
function XMQuaternionSlerpV(Q0: TFXMVECTOR; Q1: TFXMVECTOR; t: TFXMVECTOR): TXMVECTOR;
function XMQuaternionSquad(Q0: TFXMVECTOR; Q1: TFXMVECTOR; Q2: TFXMVECTOR; Q3: TGXMVECTOR; t: single): TXMVECTOR;
function XMQuaternionSquadV(Q0: TFXMVECTOR; Q1: TFXMVECTOR; Q2: TFXMVECTOR; Q3: TGXMVECTOR; t: THXMVECTOR): TXMVECTOR;
procedure XMQuaternionSquadSetup(out pA: TXMVECTOR; out pB: TXMVECTOR; out pC: TXMVECTOR; Q0: TFXMVECTOR; Q1: TFXMVECTOR; Q2: TFXMVECTOR; Q3: TGXMVECTOR);
function XMQuaternionBaryCentric(Q0: TFXMVECTOR; Q1: TFXMVECTOR; Q2: TFXMVECTOR; f, g: single): TXMVECTOR;
function XMQuaternionBaryCentricV(Q0: TFXMVECTOR; Q1: TFXMVECTOR; Q2: TFXMVECTOR; f: TGXMVECTOR; g: THXMVECTOR): TXMVECTOR;

function XMQuaternionIdentity(): TXMVECTOR;

// Rotates about y-axis (Yaw), then x-axis (Pitch), then z-axis (Roll)
function XMQuaternionRotationRollPitchYaw(Pitch, Yaw, Roll: single): TXMVECTOR;

// Rotates about y-axis (Angles.y), then x-axis (Angles.x), then z-axis (Angles.z)
function XMQuaternionRotationRollPitchYawFromVector(Angles: TFXMVECTOR): TXMVECTOR;

function XMQuaternionRotationNormal(NormalAxis: TFXMVECTOR; Angle: single): TXMVECTOR;
function XMQuaternionRotationAxis(Axis: TFXMVECTOR; Angle: single): TXMVECTOR;
function XMQuaternionRotationMatrix(m: TFXMMATRIX): TXMVECTOR;

procedure XMQuaternionToAxisAngle(out pAxis: TXMVECTOR; out pAngle: single; Q: TFXMVECTOR);

(* ***************************************************************************
  *
  * Plane operations
  *
  *************************************************************************** *)

function XMPlaneEqual(P1: TFXMVECTOR; P2: TFXMVECTOR): boolean;
function XMPlaneNearEqual(P1: TFXMVECTOR; P2: TFXMVECTOR; Epsilon: TFXMVECTOR): boolean;
function XMPlaneNotEqual(P1: TFXMVECTOR; P2: TFXMVECTOR): boolean;

function XMPlaneIsNaN(P: TFXMVECTOR): boolean;
function XMPlaneIsInfinite(P: TFXMVECTOR): boolean;

function XMPlaneDot(P: TFXMVECTOR; v: TFXMVECTOR): TXMVECTOR;
function XMPlaneDotCoord(P: TFXMVECTOR; v: TFXMVECTOR): TXMVECTOR;
function XMPlaneDotNormal(P: TFXMVECTOR; v: TFXMVECTOR): TXMVECTOR;
function XMPlaneNormalizeEst(P: TFXMVECTOR): TXMVECTOR;
function XMPlaneNormalize(P: TFXMVECTOR): TXMVECTOR;
function XMPlaneIntersectLine(P: TFXMVECTOR; LinePoint1: TFXMVECTOR; LinePoint2: TFXMVECTOR): TXMVECTOR;
procedure XMPlaneIntersectPlane(out pLinePoint1: TXMVECTOR; out pLinePoint2: TXMVECTOR; P1: TFXMVECTOR; P2: TFXMVECTOR);

// Transforms a plane given an inverse transpose matrix
function XMPlaneTransform(P: TFXMVECTOR; m: TFXMMATRIX): TXMVECTOR;

// Transforms an array of planes given an inverse transpose matrix
function XMPlaneTransformStream(var pOutputStream: PXMFLOAT4; OutputStride: size_t; const pInputStream: PXMFLOAT4; InputStride: size_t; PlaneCount: size_t; m: TFXMMATRIX): PXMFLOAT4;


function XMPlaneFromPointNormal(Point: TFXMVECTOR; Normal: TFXMVECTOR): TXMVECTOR;
function XMPlaneFromPoints(Point1: TFXMVECTOR; Point2: TFXMVECTOR; Point3: TFXMVECTOR): TXMVECTOR;

(* ***************************************************************************
  *
  * Color operations
  *
  *************************************************************************** *)

function XMColorEqual(C1: TFXMVECTOR; C2: TFXMVECTOR): boolean;
function XMColorNotEqual(C1: TFXMVECTOR; C2: TFXMVECTOR): boolean;
function XMColorGreater(C1: TFXMVECTOR; C2: TFXMVECTOR): boolean;
function XMColorGreaterOrEqual(C1: TFXMVECTOR; C2: TFXMVECTOR): boolean;
function XMColorLess(C1: TFXMVECTOR; C2: TFXMVECTOR): boolean;
function XMColorLessOrEqual(C1: TFXMVECTOR; C2: TFXMVECTOR): boolean;

function XMColorIsNaN(C: TFXMVECTOR): boolean;
function XMColorIsInfinite(C: TFXMVECTOR): boolean;

function XMColorNegative(C: TFXMVECTOR): TXMVECTOR;
function XMColorModulate(C1: TFXMVECTOR; C2: TFXMVECTOR): TXMVECTOR;
function XMColorAdjustSaturation(C: TFXMVECTOR; Saturation: single): TXMVECTOR;
function XMColorAdjustContrast(C: TFXMVECTOR; Contrast: single): TXMVECTOR;

function XMColorRGBToHSL(rgb: TFXMVECTOR): TXMVECTOR;
function XMColorHSLToRGB(hsl: TFXMVECTOR): TXMVECTOR;

function XMColorRGBToHSV(rgb: TFXMVECTOR): TXMVECTOR;
function XMColorHSVToRGB(hsv: TFXMVECTOR): TXMVECTOR;

function XMColorRGBToYUV(rgb: TFXMVECTOR): TXMVECTOR;
function XMColorYUVToRGB(yuv: TFXMVECTOR): TXMVECTOR;

function XMColorRGBToYUV_HD(rgb: TFXMVECTOR): TXMVECTOR;
function XMColorYUVToRGB_HD(yuv: TFXMVECTOR): TXMVECTOR;

function XMColorRGBToYUV_UHD(rgb: TFXMVECTOR): TXMVECTOR;
function XMColorYUVToRGB_UHD(yuv: TFXMVECTOR): TXMVECTOR;

function XMColorRGBToXYZ(rgb: TFXMVECTOR): TXMVECTOR;
function XMColorXYZToRGB(xyz: TFXMVECTOR): TXMVECTOR;

function XMColorXYZToSRGB(xyz: TFXMVECTOR): TXMVECTOR;
function XMColorSRGBToXYZ(srgb: TFXMVECTOR): TXMVECTOR;

function XMColorRGBToSRGB(rgb: TFXMVECTOR): TXMVECTOR;
function XMColorSRGBToRGB(srgb: TFXMVECTOR): TXMVECTOR;

(* ***************************************************************************
  *
  * Miscellaneous operations
  *
  *************************************************************************** *)

function XMVerifyCPUSupport(): boolean;

function XMFresnelTerm(CosIncidentAngle: TFXMVECTOR; RefractionIndex: TFXMVECTOR): TXMVECTOR;

function XMScalarNearEqual(S1, S2, Epsilon: single): boolean;
function XMScalarModAngle(Value: single): single;

function XMScalarSin(Value: single): single;
function XMScalarSinEst(Value: single): single;

function XMScalarCos(Value: single): single;
function XMScalarCosEst(Value: single): single;

procedure XMScalarSinCos(out pSin: single; out pCos: single; Value: single);
procedure XMScalarSinCosEst(out pSin: single; out pCos: single; Value: single);

function XMScalarASin(Value: single): single;
function XMScalarASinEst(Value: single): single;

function XMScalarACos(Value: single): single;
function XMScalarACosEst(Value: single): single;

(* ***************************************************************************
  *
  * Macros
  *
  *************************************************************************** *)

// Unit conversion
function XMConvertToRadians(fDegrees: single): single;
function XMConvertToDegrees(fRadians: single): single;
// Condition register evaluation proceeding a recording (R) comparison
function XMComparisonAllTrue(CR: uint32): boolean;
function XMComparisonAnyTrue(CR: uint32): boolean;
function XMComparisonAllFalse(CR: uint32): boolean;
function XMComparisonAnyFalse(CR: uint32): boolean;
function XMComparisonMixed(CR: uint32): boolean;
function XMComparisonAllInBounds(CR: uint32): boolean;
function XMComparisonAnyOutOfBounds(CR: uint32): boolean;

(* ***************************************************************************
  *
  * Templates
  *
  *************************************************************************** *)
// General permute template
function XMVectorPermute(PermuteX, PermuteY, PermuteZ, PermuteW: uint32; V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR; overload;
// General swizzle template
function XMVectorSwizzle(SwizzleX, SwizzleY, SwizzleZ, SwizzleW: uint32; v: TFXMVECTOR): TXMVECTOR; overload;

{$IFDEF FPC}
function XMMin<t>(a, b: t): t;
function XMMax<t>(a, b: t): t;
{$ENDIF}
(* ***************************************************************************
  *
  * General vector operations
  *
  *************************************************************************** *)

implementation

uses
    Math;



function XMConvertToRadians(fDegrees: single): single; inline;
begin
    Result := fDegrees * (XM_PI / 180.0);
end;



function XMConvertToDegrees(fRadians: single): single; inline;
begin
    Result := fRadians * (180.0 / XM_PI);
end;



function XMComparisonAllTrue(CR: uint32): boolean; inline;
begin
    Result := (CR and XM_CRMASK_CR6TRUE) = XM_CRMASK_CR6TRUE;
end;



function XMComparisonAnyTrue(CR: uint32): boolean;
begin
    Result := (CR and XM_CRMASK_CR6FALSE) <> XM_CRMASK_CR6FALSE;
end;



function XMComparisonAllFalse(CR: uint32): boolean;
begin
    Result := (CR and XM_CRMASK_CR6FALSE) = XM_CRMASK_CR6FALSE;
end;



function XMComparisonAnyFalse(CR: uint32): boolean;
begin
    Result := (CR and XM_CRMASK_CR6TRUE) <> XM_CRMASK_CR6TRUE;
end;



function XMComparisonMixed(CR: uint32): boolean;
begin
    Result := (CR and XM_CRMASK_CR6) = 0;
end;



function XMComparisonAllInBounds(CR: uint32): boolean;
begin
    Result := (CR and XM_CRMASK_CR6BOUNDS) = XM_CRMASK_CR6BOUNDS;
end;



function XMComparisonAnyOutOfBounds(CR: uint32): boolean;
begin
    Result := (CR and XM_CRMASK_CR6BOUNDS) <> XM_CRMASK_CR6BOUNDS;
end;

{$REGION DirectXMathConvert}
// ------------------------------------------------------------------------------
// Assignment operations
// ------------------------------------------------------------------------------

(* ***************************************************************************
  *
  * Data conversion
  *
  *************************************************************************** *)

function XMConvertVectorIntToFloat(VInt: TFXMVECTOR; DivExponent: uint32): TXMVECTOR;
var
    ElementIndex: uint32;
    fScale: single;
    iTemp: int32;
begin
    assert(DivExponent < 32);

    fScale := 1.0 / (1 shl DivExponent);
    ElementIndex := 0;
    while ElementIndex < 4 do
    begin
        iTemp := int32(VInt.vector4_u32[ElementIndex]);
        Result.vector4_f32[ElementIndex] := iTemp * fScale;
        Inc(ElementIndex);
    end;
end;



function XMConvertVectorFloatToInt(VFloat: TFXMVECTOR; MulExponent: uint32): TXMVECTOR;
var
    fScale: single;
    ElementIndex: uint32;
    fTemp: single;
    iResult: int32;
begin
    assert(MulExponent < 32);
    // Get the scalar factor.
    fScale := (1 shl MulExponent);
    ElementIndex := 0;
    while (ElementIndex < 4) do
    begin
        fTemp := VFloat.vector4_f32[ElementIndex] * fScale;
        if (fTemp <= -(65536.0 * 32768.0)) then
            iResult := (-$7FFFFFFF) - 1
        else if (fTemp > (65536.0 * 32768.0) - 128.0) then
            iResult := $7FFFFFFF
        else
            iResult := trunc(fTemp);
        Result.vector4_u32[ElementIndex] := uint32(iResult);
        Inc(ElementIndex);
    end;
end;



function XMConvertVectorUIntToFloat(VUInt: TFXMVECTOR; DivExponent: uint32): TXMVECTOR;
var
    fScale: single;
    ElementIndex: uint32;
begin
    assert(DivExponent < 32);
    fScale := 1.0 / (1 shl DivExponent);
    ElementIndex := 0;

    while ElementIndex < 4 do
    begin
        Result.vector4_f32[ElementIndex] := (VUInt.vector4_u32[ElementIndex]) * fScale;
        Inc(ElementIndex);
    end;
end;



function XMConvertVectorFloatToUInt(VFloat: TFXMVECTOR; MulExponent: uint32): TXMVECTOR;
var
    fScale: single;
    ElementIndex: uint32;
    uResult: uint32;
    fTemp: single;
begin
    assert(MulExponent < 32);
    // Get the scalar factor.
    fScale := (1 shl MulExponent);
    ElementIndex := 0;

    while (ElementIndex < 4) do
    begin

        fTemp := VFloat.vector4_f32[ElementIndex] * fScale;
        if (fTemp <= 0.0) then
            uResult := 0
        else if (fTemp >= (65536.0 * 65536.0)) then
            uResult := $FFFFFFFF
        else
            uResult := trunc(fTemp);

        Result.vector4_u32[ElementIndex] := uResult;
        Inc(ElementIndex);
    end;

end;

(* ***************************************************************************
  *
  * Implementation
  *
  *************************************************************************** *)

function XMVectorSetBinaryConstant(C0: uint32; C1: uint32; C2: uint32; C3: uint32): TXMVECTOR;
begin
    Result.vector4_u32[0] := (0 - (C0 and 1)) and $3F800000;
    Result.vector4_u32[1] := (0 - (C1 and 1)) and $3F800000;
    Result.vector4_u32[2] := (0 - (C2 and 1)) and $3F800000;
    Result.vector4_u32[3] := (0 - (C3 and 1)) and $3F800000;
end;



function XMVectorSplatConstant(IntConstant: int32; DivExponent: uint32): TXMVECTOR;
var
    v: TXMVECTOR;
begin
{$IFDEF WithAssert}
    assert((IntConstant >= -16) AND (IntConstant <= 15));
    assert(DivExponent < 32);
{$ENDIF}
    v.vector4_i32[0] := IntConstant;
    v.vector4_i32[1] := IntConstant;
    v.vector4_i32[2] := IntConstant;
    v.vector4_i32[3] := IntConstant;
    Result := XMConvertVectorIntToFloat(v, DivExponent);
end;



function XMVectorSplatConstantInt(IntConstant: int32): TXMVECTOR;
begin
{$IFDEF WithAssert}
    assert((IntConstant >= -16) AND (IntConstant <= 15));
{$ENDIF}
    Result.vector4_i32[0] := IntConstant;
    Result.vector4_i32[1] := IntConstant;
    Result.vector4_i32[2] := IntConstant;
    Result.vector4_i32[3] := IntConstant;
end;



function XMLoadInt(const pSource: Puint32): TXMVECTOR;
begin
    Result.vector4_u32[0] := pSource^;
    Result.vector4_u32[1] := 0;
    Result.vector4_u32[2] := 0;
    Result.vector4_u32[3] := 0;
end;



function XMLoadFloat(const pSource: PSingle): TXMVECTOR;
begin
    Result.f[1] := pSource^;
    Result.f[0] := 0;
    Result.f[2] := 0;
    Result.f[3] := 0;
end;



function XMLoadInt2(const pSource: Puint32): TXMVECTOR;
var
    lSource: array [0 .. 1] of uint32 absolute pSource;
begin
    Result.vector4_u32[0] := lSource[0];
    Result.vector4_u32[1] := lSource[1];
    Result.vector4_u32[2] := 0;
    Result.vector4_u32[3] := 0;

end;



function XMLoadInt2A(const pSource: Puint32): TXMVECTOR;
var
    lSource: array [0 .. 1] of uint32 absolute pSource;
begin
    assert(pSource <> nil);
    assert((uintptr(pSource) and $F) = 0);
    Result.vector4_u32[0] := lSource[0];
    Result.vector4_u32[1] := lSource[1];
    Result.vector4_u32[2] := 0;
    Result.vector4_u32[3] := 0;
end;



function XMLoadFloat2(const pSource: PXMFLOAT2): TXMVECTOR;
begin
    assert(pSource <> nil);
    Move(pSource^, Result.f[0], 8);
    Result.f[2] := 0;
    Result.f[3] := 0;
end;



function XMLoadFloat2A(const pSource: PXMFLOAT2A): TXMVECTOR;
begin
    Result.vector4_f32[0] := pSource.x;
    Result.vector4_f32[1] := pSource.y;
    Result.vector4_f32[2] := 0.0;
    Result.vector4_f32[3] := 0.0;
end;



function XMLoadSInt2(const pSource: PXMINT2): TXMVECTOR;
begin
    Result.vector4_i32[0] := pSource.x;
    Result.vector4_i32[1] := pSource.y;
    Result.vector4_i32[2] := 0;
    Result.vector4_i32[3] := 0;
end;



function XMLoadUInt2(const pSource: PXMUINT2): TXMVECTOR;
begin
    Result.vector4_u32[0] := pSource.x;
    Result.vector4_u32[1] := pSource.y;
    Result.vector4_u32[2] := 0;
    Result.vector4_u32[3] := 0;
end;



function XMLoadInt3(const pSource: Puint32): TXMVECTOR;
var
    lSource: array [0 .. 2] of uint32 absolute pSource;
begin
{$IFDEF WithAssert}
    assert(pSource <> nil);
{$ENDIF}
    Result.vector4_u32[0] := lSource[0];
    Result.vector4_u32[1] := lSource[1];
    Result.vector4_u32[2] := lSource[2];
    Result.vector4_u32[3] := 0;
end;



function XMLoadInt3A(const pSource: Puint32): TXMVECTOR;
var
    lSource: array [0 .. 2] of uint32 absolute pSource;
begin
    Result.vector4_u32[0] := lSource[0];
    Result.vector4_u32[1] := lSource[1];
    Result.vector4_u32[2] := lSource[2];
    Result.vector4_u32[3] := 0;
end;

{$IF defined(_XM_SSE4_INTRINSICS_)}

function XMLoadFloat3(constref pSource: TXMFLOAT3): TXMVECTOR; assembler;
    nostackframe;
asm
           MOVSD   XMM0, [pSource]
           MOVSS   XMM1, [pSource].TXMFLOAT3.z
           INSERTPS XMM0, XMM1, $20
           VMOVUPS  [Result],XMM0
end;
{$ELSEIF defined(_XM_SSE_INTRINSICS_)}

function XMLoadFloat3(const pSource: PXMFLOAT3): TXMVECTOR; assembler;
nostackframe;
asm
    MOVSD   XMM0, [pSource]
    MOVSS   XMM1, [pSource].TXMFLOAT3.z
    MOVLHPS XMM0, XMM1
    VMOVUPS  [Result],XMM0
end;
{$ELSE}

function XMLoadFloat3(const pSource: TXMFLOAT3): TXMVECTOR;
begin
{$IFDEF WithAssert}
    assert(pSource <> nil);
{$ENDIF}
    // Move(pSource^, Result.f[0], 12);
    Result.vector4_f32[0] := pSource.x;
    Result.vector4_f32[1] := pSource.y;
    Result.vector4_f32[2] := pSource.z;
    Result.vector4_f32[3] := 0;
end;
{$ENDIF}



function XMLoadFloat3A(const pSource: PXMFLOAT3A): TXMVECTOR;
begin
    Result.vector4_f32[0] := pSource.x;
    Result.vector4_f32[1] := pSource.y;
    Result.vector4_f32[2] := pSource.z;
    Result.vector4_f32[3] := 0.0;
end;



function XMLoadSInt3(const pSource: PXMINT3): TXMVECTOR;
begin
    Result.vector4_f32[0] := pSource.x;
    Result.vector4_f32[1] := pSource.y;
    Result.vector4_f32[2] := pSource.z;
    Result.vector4_f32[3] := 0.0;
end;



function XMLoadUInt3(const pSource: PXMUINT3): TXMVECTOR;
begin
    Result.vector4_f32[0] := pSource.x;
    Result.vector4_f32[1] := pSource.y;
    Result.vector4_f32[2] := pSource.z;
    Result.vector4_f32[3] := 0.0;
end;



function XMLoadInt4(const pSource: Puint32): TXMVECTOR;
var
    lSource: array [0 .. 3] of uint32 absolute pSource;
begin
{$IFDEF WithAssert}
    assert(pSource <> nil);
{$ENDIF}
    Result.vector4_u32[0] := lSource[0];
    Result.vector4_u32[1] := lSource[1];
    Result.vector4_u32[2] := lSource[2];
    Result.vector4_u32[3] := lSource[3];
end;



function XMLoadInt4A(const pSource: Puint32): TXMVECTOR;
var
    lSource: array [0 .. 3] of uint32 absolute pSource;
begin
    Result.vector4_u32[0] := lSource[0];
    Result.vector4_u32[1] := lSource[1];
    Result.vector4_u32[2] := lSource[2];
    Result.vector4_u32[3] := lSource[3];
end;

{$IF defined(_XM_SSE_INTRINSICS_)}

function XMLoadFloat4(constref pSource: TXMFLOAT4): TXMVECTOR; assembler;
    nostackframe;
asm
           MOVUPS  XMM0, [pSource]
           VMOVUPS  [Result],XMM0
end;

{$ELSE}

function XMLoadFloat4(const pSource: TXMFLOAT4): TXMVECTOR;
begin
{$IFDEF WithAssert}
    assert(pSource <> nil);
{$ENDIF}
    Result.vector4_f32[0] := pSource.x;
    Result.vector4_f32[1] := pSource.y;
    Result.vector4_f32[2] := pSource.z;
    Result.vector4_f32[3] := pSource.w;
    // Move(pSource^, Result.f[0], 16);
end;
{$ENDIF}



function XMLoadFloat4A(const pSource: PXMFLOAT4A): TXMVECTOR;
begin
    Result.vector4_f32[0] := pSource.x;
    Result.vector4_f32[1] := pSource.y;
    Result.vector4_f32[2] := pSource.z;
    Result.vector4_f32[3] := pSource.w;
end;



function XMLoadSInt4(const pSource: PXMINT4): TXMVECTOR;
begin
    Result.vector4_f32[0] := pSource.x;
    Result.vector4_f32[1] := pSource.y;
    Result.vector4_f32[2] := pSource.z;
    Result.vector4_f32[3] := pSource.w;
end;



function XMLoadUInt4(const pSource: PXMUINT4): TXMVECTOR;
begin
    Result.vector4_f32[0] := pSource.x;
    Result.vector4_f32[1] := pSource.y;
    Result.vector4_f32[2] := pSource.z;
    Result.vector4_f32[3] := pSource.w;
end;



function XMLoadFloat3x3(const pSource: PXMFLOAT3X3): TXMMATRIX;
begin
    Result.r[0].vector4_f32[0] := pSource.m[0][0];
    Result.r[0].vector4_f32[1] := pSource.m[0][1];
    Result.r[0].vector4_f32[2] := pSource.m[0][2];
    Result.r[0].vector4_f32[3] := 0.0;

    Result.r[1].vector4_f32[0] := pSource.m[1][0];
    Result.r[1].vector4_f32[1] := pSource.m[1][1];
    Result.r[1].vector4_f32[2] := pSource.m[1][2];
    Result.r[1].vector4_f32[3] := 0.0;

    Result.r[2].vector4_f32[0] := pSource.m[2][0];
    Result.r[2].vector4_f32[1] := pSource.m[2][1];
    Result.r[2].vector4_f32[2] := pSource.m[2][2];
    Result.r[2].vector4_f32[3] := 0.0;
    Result.r[3].vector4_f32[0] := 0.0;
    Result.r[3].vector4_f32[1] := 0.0;
    Result.r[3].vector4_f32[2] := 0.0;
    Result.r[3].vector4_f32[3] := 1.0;
end;



function XMLoadFloat4x3(const pSource: PXMFLOAT4X3): TXMMATRIX;
begin
    Result.r[0].vector4_f32[0] := pSource.m[0][0];
    Result.r[0].vector4_f32[1] := pSource.m[0][1];
    Result.r[0].vector4_f32[2] := pSource.m[0][2];
    Result.r[0].vector4_f32[3] := 0.0;

    Result.r[1].vector4_f32[0] := pSource.m[1][0];
    Result.r[1].vector4_f32[1] := pSource.m[1][1];
    Result.r[1].vector4_f32[2] := pSource.m[1][2];
    Result.r[1].vector4_f32[3] := 0.0;

    Result.r[2].vector4_f32[0] := pSource.m[2][0];
    Result.r[2].vector4_f32[1] := pSource.m[2][1];
    Result.r[2].vector4_f32[2] := pSource.m[2][2];
    Result.r[2].vector4_f32[3] := 0.0;

    Result.r[3].vector4_f32[0] := pSource.m[3][0];
    Result.r[3].vector4_f32[1] := pSource.m[3][1];
    Result.r[3].vector4_f32[2] := pSource.m[3][2];
    Result.r[3].vector4_f32[3] := 1.0;
end;



function XMLoadFloat4x3A(const pSource: PXMFLOAT4X3A): TXMMATRIX;
begin
    Result.r[0].vector4_f32[0] := pSource.m[0][0];
    Result.r[0].vector4_f32[1] := pSource.m[0][1];
    Result.r[0].vector4_f32[2] := pSource.m[0][2];
    Result.r[0].vector4_f32[3] := 0.0;

    Result.r[1].vector4_f32[0] := pSource.m[1][0];
    Result.r[1].vector4_f32[1] := pSource.m[1][1];
    Result.r[1].vector4_f32[2] := pSource.m[1][2];
    Result.r[1].vector4_f32[3] := 0.0;

    Result.r[2].vector4_f32[0] := pSource.m[2][0];
    Result.r[2].vector4_f32[1] := pSource.m[2][1];
    Result.r[2].vector4_f32[2] := pSource.m[2][2];
    Result.r[2].vector4_f32[3] := 0.0;

    Result.r[3].vector4_f32[0] := pSource.m[3][0];
    Result.r[3].vector4_f32[1] := pSource.m[3][1];
    Result.r[3].vector4_f32[2] := pSource.m[3][2];
    Result.r[3].vector4_f32[3] := 1.0;
end;



function XMLoadFloat3x4(const pSource: PXMFLOAT3X4): TXMMATRIX;
begin
    Result.r[0].vector4_f32[0] := pSource.m[0][0];
    Result.r[0].vector4_f32[1] := pSource.m[1][0];
    Result.r[0].vector4_f32[2] := pSource.m[2][0];
    Result.r[0].vector4_f32[3] := 0.0;

    Result.r[1].vector4_f32[0] := pSource.m[0][1];
    Result.r[1].vector4_f32[1] := pSource.m[1][1];
    Result.r[1].vector4_f32[2] := pSource.m[2][1];
    Result.r[1].vector4_f32[3] := 0.0;

    Result.r[2].vector4_f32[0] := pSource.m[0][2];
    Result.r[2].vector4_f32[1] := pSource.m[1][2];
    Result.r[2].vector4_f32[2] := pSource.m[2][2];
    Result.r[2].vector4_f32[3] := 0.0;

    Result.r[3].vector4_f32[0] := pSource.m[0][3];
    Result.r[3].vector4_f32[1] := pSource.m[1][3];
    Result.r[3].vector4_f32[2] := pSource.m[2][3];
    Result.r[3].vector4_f32[3] := 1.0;
end;



function XMLoadFloat3x4A(const pSource: PXMFLOAT3X4A): TXMMATRIX;
begin
    Result.r[0].vector4_f32[0] := pSource.m[0][0];
    Result.r[0].vector4_f32[1] := pSource.m[1][0];
    Result.r[0].vector4_f32[2] := pSource.m[2][0];
    Result.r[0].vector4_f32[3] := 0.0;

    Result.r[1].vector4_f32[0] := pSource.m[0][1];
    Result.r[1].vector4_f32[1] := pSource.m[1][1];
    Result.r[1].vector4_f32[2] := pSource.m[2][1];
    Result.r[1].vector4_f32[3] := 0.0;

    Result.r[2].vector4_f32[0] := pSource.m[0][2];
    Result.r[2].vector4_f32[1] := pSource.m[1][2];
    Result.r[2].vector4_f32[2] := pSource.m[2][2];
    Result.r[2].vector4_f32[3] := 0.0;

    Result.r[3].vector4_f32[0] := pSource.m[0][3];
    Result.r[3].vector4_f32[1] := pSource.m[1][3];
    Result.r[3].vector4_f32[2] := pSource.m[2][3];
    Result.r[3].vector4_f32[3] := 1.0;

end;



function XMLoadFloat4x4(const pSource: PXMFLOAT4X4): TXMMATRIX;
begin
    Result.r[0].vector4_f32[0] := pSource.m[0][0];
    Result.r[0].vector4_f32[1] := pSource.m[0][1];
    Result.r[0].vector4_f32[2] := pSource.m[0][2];
    Result.r[0].vector4_f32[3] := pSource.m[0][3];

    Result.r[1].vector4_f32[0] := pSource.m[1][0];
    Result.r[1].vector4_f32[1] := pSource.m[1][1];
    Result.r[1].vector4_f32[2] := pSource.m[1][2];
    Result.r[1].vector4_f32[3] := pSource.m[1][3];

    Result.r[2].vector4_f32[0] := pSource.m[2][0];
    Result.r[2].vector4_f32[1] := pSource.m[2][1];
    Result.r[2].vector4_f32[2] := pSource.m[2][2];
    Result.r[2].vector4_f32[3] := pSource.m[2][3];

    Result.r[3].vector4_f32[0] := pSource.m[3][0];
    Result.r[3].vector4_f32[1] := pSource.m[3][1];
    Result.r[3].vector4_f32[2] := pSource.m[3][2];
    Result.r[3].vector4_f32[3] := pSource.m[3][3];

end;



function XMLoadFloat4x4A(const pSource: PXMFLOAT4X4A): TXMMATRIX;
begin
    Result.r[0].vector4_f32[0] := pSource.m[0][0];
    Result.r[0].vector4_f32[1] := pSource.m[0][1];
    Result.r[0].vector4_f32[2] := pSource.m[0][2];
    Result.r[0].vector4_f32[3] := pSource.m[0][3];

    Result.r[1].vector4_f32[0] := pSource.m[1][0];
    Result.r[1].vector4_f32[1] := pSource.m[1][1];
    Result.r[1].vector4_f32[2] := pSource.m[1][2];
    Result.r[1].vector4_f32[3] := pSource.m[1][3];

    Result.r[2].vector4_f32[0] := pSource.m[2][0];
    Result.r[2].vector4_f32[1] := pSource.m[2][1];
    Result.r[2].vector4_f32[2] := pSource.m[2][2];
    Result.r[2].vector4_f32[3] := pSource.m[2][3];

    Result.r[3].vector4_f32[0] := pSource.m[3][0];
    Result.r[3].vector4_f32[1] := pSource.m[3][1];
    Result.r[3].vector4_f32[2] := pSource.m[3][2];
    Result.r[3].vector4_f32[3] := pSource.m[3][3];
end;

(* ***************************************************************************
  *
  * Vector and matrix store operations
  *
  *************************************************************************** *)

procedure XMStoreInt(out pDestination: uint32; v: TFXMVECTOR);
begin
    pDestination := XMVectorGetIntX(v);
end;



procedure XMStoreFloat(out pDestination: single; v: TFXMVECTOR);
begin
    pDestination := XMVectorGetX(v);
end;



procedure XMStoreInt2(out pDestination: array of uint32; v: TFXMVECTOR);
begin
    pDestination[0] := v.vector4_u32[0];
    pDestination[1] := v.vector4_u32[1];
end;



procedure XMStoreInt2A(out pDestination: array of uint32; v: TFXMVECTOR);
begin
    pDestination[0] := v.vector4_u32[0];
    pDestination[1] := v.vector4_u32[1];
end;



procedure XMStoreFloat2(var pDestination: PXMFLOAT2; v: TFXMVECTOR);
begin
    pDestination.x := v.vector4_f32[0];
    pDestination.y := v.vector4_f32[1];
end;



procedure XMStoreFloat2A(out pDestination: TXMFLOAT2A; v: TFXMVECTOR);
begin
    pDestination.x := v.vector4_f32[0];
    pDestination.y := v.vector4_f32[1];
end;



procedure XMStoreSInt2(out pDestination: TXMINT2; v: TFXMVECTOR);
begin
    pDestination.x := trunc(v.vector4_f32[0]);
    pDestination.y := trunc(v.vector4_f32[1]);
end;



procedure XMStoreUInt2(out pDestination: TXMUINT2; v: TFXMVECTOR);
begin
    pDestination.x := trunc(v.vector4_f32[0]);
    pDestination.y := trunc(v.vector4_f32[1]);
end;



procedure XMStoreInt3(out pDestination: array of uint32; v: TFXMVECTOR);
begin
    pDestination[0] := v.vector4_u32[0];
    pDestination[1] := v.vector4_u32[1];
    pDestination[2] := v.vector4_u32[2];
end;



procedure XMStoreInt3A(out pDestination: array of uint32; v: TFXMVECTOR);
begin
    pDestination[0] := v.vector4_u32[0];
    pDestination[1] := v.vector4_u32[1];
    pDestination[2] := v.vector4_u32[2];
end;



procedure XMStoreFloat3(var pDestination: TXMFLOAT3; v: TFXMVECTOR);
begin
    pDestination.x := v.vector4_f32[0];
    pDestination.y := v.vector4_f32[1];
    pDestination.z := v.vector4_f32[2];
end;



procedure XMStoreFloat3A(out pDestination: TXMFLOAT3A; v: TFXMVECTOR);
begin
    pDestination.x := v.vector4_f32[0];
    pDestination.y := v.vector4_f32[1];
    pDestination.z := v.vector4_f32[2];
end;



procedure XMStoreSInt3(out pDestination: TXMINT3; v: TFXMVECTOR);
begin
    pDestination.x := trunc(v.vector4_f32[0]);
    pDestination.y := trunc(v.vector4_f32[1]);
    pDestination.z := trunc(v.vector4_f32[2]);
end;



procedure XMStoreUInt3(out pDestination: TXMUINT3; v: TFXMVECTOR);
begin
    pDestination.x := trunc(v.vector4_f32[0]);
    pDestination.y := trunc(v.vector4_f32[1]);
    pDestination.z := trunc(v.vector4_f32[2]);
end;



procedure XMStoreInt4(out pDestination: array of uint32; v: TFXMVECTOR);
begin
    pDestination[0] := v.vector4_u32[0];
    pDestination[1] := v.vector4_u32[1];
    pDestination[2] := v.vector4_u32[2];
    pDestination[3] := v.vector4_u32[3];
end;



procedure XMStoreInt4A(out pDestination: array of uint32; v: TFXMVECTOR);
begin
    pDestination[0] := v.vector4_u32[0];
    pDestination[1] := v.vector4_u32[1];
    pDestination[2] := v.vector4_u32[2];
    pDestination[3] := v.vector4_u32[3];
end;



procedure XMStoreFloat4(var pDestination: TXMFLOAT4; v: TFXMVECTOR);
begin
    pDestination.x := v.vector4_f32[0];
    pDestination.y := v.vector4_f32[1];
    pDestination.z := v.vector4_f32[2];
    pDestination.w := v.vector4_f32[3];
end;



procedure XMStoreFloat4A(out pDestination: TXMFLOAT4A; v: TFXMVECTOR);
begin
    pDestination.x := v.vector4_f32[0];
    pDestination.y := v.vector4_f32[1];
    pDestination.z := v.vector4_f32[2];
    pDestination.w := v.vector4_f32[3];
end;



procedure XMStoreSInt4(out pDestination: TXMINT4; v: TFXMVECTOR);
begin
    pDestination.x := trunc(v.vector4_f32[0]);
    pDestination.y := trunc(v.vector4_f32[1]);
    pDestination.z := trunc(v.vector4_f32[2]);
    pDestination.w := trunc(v.vector4_f32[3]);
end;



procedure XMStoreUInt4(out pDestination: TXMUINT4; v: TFXMVECTOR);
begin
    pDestination.x := trunc(v.vector4_f32[0]);
    pDestination.y := trunc(v.vector4_f32[1]);
    pDestination.z := trunc(v.vector4_f32[2]);
    pDestination.w := trunc(v.vector4_f32[3]);
end;



procedure XMStoreFloat3x3(out pDestination: TXMFLOAT3X3; m: TFXMMATRIX);
begin
    pDestination.m[0][0] := m.r[0].vector4_f32[0];
    pDestination.m[0][1] := m.r[0].vector4_f32[1];
    pDestination.m[0][2] := m.r[0].vector4_f32[2];

    pDestination.m[1][0] := m.r[1].vector4_f32[0];
    pDestination.m[1][1] := m.r[1].vector4_f32[1];
    pDestination.m[1][2] := m.r[1].vector4_f32[2];

    pDestination.m[2][0] := m.r[2].vector4_f32[0];
    pDestination.m[2][1] := m.r[2].vector4_f32[1];
    pDestination.m[2][2] := m.r[2].vector4_f32[2];
end;



procedure XMStoreFloat4x3(out pDestination: TXMFLOAT4X3; m: TFXMMATRIX);
begin
    pDestination.m[0][0] := m.r[0].vector4_f32[0];
    pDestination.m[0][1] := m.r[0].vector4_f32[1];
    pDestination.m[0][2] := m.r[0].vector4_f32[2];

    pDestination.m[1][0] := m.r[1].vector4_f32[0];
    pDestination.m[1][1] := m.r[1].vector4_f32[1];
    pDestination.m[1][2] := m.r[1].vector4_f32[2];

    pDestination.m[2][0] := m.r[2].vector4_f32[0];
    pDestination.m[2][1] := m.r[2].vector4_f32[1];
    pDestination.m[2][2] := m.r[2].vector4_f32[2];

    pDestination.m[3][0] := m.r[3].vector4_f32[0];
    pDestination.m[3][1] := m.r[3].vector4_f32[1];
    pDestination.m[3][2] := m.r[3].vector4_f32[2];
end;



procedure XMStoreFloat4x3A(var pDestination: TXMFLOAT4X3A; m: TFXMMATRIX);
begin
    assert(@pDestination <> nil);
    assert((uintptr(@pDestination) and $F) = 0);

    pDestination.m[0][0] := m.r[0].vector4_f32[0];
    pDestination.m[0][1] := m.r[0].vector4_f32[1];
    pDestination.m[0][2] := m.r[0].vector4_f32[2];

    pDestination.m[1][0] := m.r[1].vector4_f32[0];
    pDestination.m[1][1] := m.r[1].vector4_f32[1];
    pDestination.m[1][2] := m.r[1].vector4_f32[2];

    pDestination.m[2][0] := m.r[2].vector4_f32[0];
    pDestination.m[2][1] := m.r[2].vector4_f32[1];
    pDestination.m[2][2] := m.r[2].vector4_f32[2];

    pDestination.m[3][0] := m.r[3].vector4_f32[0];
    pDestination.m[3][1] := m.r[3].vector4_f32[1];
    pDestination.m[3][2] := m.r[3].vector4_f32[2];
end;



procedure XMStoreFloat3x4(out pDestination: TXMFLOAT3X4; m: TFXMMATRIX);
begin
    pDestination.m[0][0] := m.r[0].vector4_f32[0];
    pDestination.m[0][1] := m.r[1].vector4_f32[0];
    pDestination.m[0][2] := m.r[2].vector4_f32[0];
    pDestination.m[0][3] := m.r[3].vector4_f32[0];

    pDestination.m[1][0] := m.r[0].vector4_f32[1];
    pDestination.m[1][1] := m.r[1].vector4_f32[1];
    pDestination.m[1][2] := m.r[2].vector4_f32[1];
    pDestination.m[1][3] := m.r[3].vector4_f32[1];

    pDestination.m[2][0] := m.r[0].vector4_f32[2];
    pDestination.m[2][1] := m.r[1].vector4_f32[2];
    pDestination.m[2][2] := m.r[2].vector4_f32[2];
    pDestination.m[2][3] := m.r[3].vector4_f32[2];
end;



procedure XMStoreFloat3x4A(out pDestination: TXMFLOAT3X4A; m: TFXMMATRIX);
begin
    pDestination.m[0][0] := m.r[0].vector4_f32[0];
    pDestination.m[0][1] := m.r[1].vector4_f32[0];
    pDestination.m[0][2] := m.r[2].vector4_f32[0];
    pDestination.m[0][3] := m.r[3].vector4_f32[0];

    pDestination.m[1][0] := m.r[0].vector4_f32[1];
    pDestination.m[1][1] := m.r[1].vector4_f32[1];
    pDestination.m[1][2] := m.r[2].vector4_f32[1];
    pDestination.m[1][3] := m.r[3].vector4_f32[1];

    pDestination.m[2][0] := m.r[0].vector4_f32[2];
    pDestination.m[2][1] := m.r[1].vector4_f32[2];
    pDestination.m[2][2] := m.r[2].vector4_f32[2];
    pDestination.m[2][3] := m.r[3].vector4_f32[2];
end;



procedure XMStoreFloat4x4(out pDestination: TXMFLOAT4X4; m: TFXMMATRIX);
begin
    pDestination.m[0][0] := m.r[0].vector4_f32[0];
    pDestination.m[0][1] := m.r[0].vector4_f32[1];
    pDestination.m[0][2] := m.r[0].vector4_f32[2];
    pDestination.m[0][3] := m.r[0].vector4_f32[3];

    pDestination.m[1][0] := m.r[1].vector4_f32[0];
    pDestination.m[1][1] := m.r[1].vector4_f32[1];
    pDestination.m[1][2] := m.r[1].vector4_f32[2];
    pDestination.m[1][3] := m.r[1].vector4_f32[3];

    pDestination.m[2][0] := m.r[2].vector4_f32[0];
    pDestination.m[2][1] := m.r[2].vector4_f32[1];
    pDestination.m[2][2] := m.r[2].vector4_f32[2];
    pDestination.m[2][3] := m.r[2].vector4_f32[3];

    pDestination.m[3][0] := m.r[3].vector4_f32[0];
    pDestination.m[3][1] := m.r[3].vector4_f32[1];
    pDestination.m[3][2] := m.r[3].vector4_f32[2];
    pDestination.m[3][3] := m.r[3].vector4_f32[3];
end;



procedure XMStoreFloat4x4A(out pDestination: TXMFLOAT4X4A; m: TFXMMATRIX);
begin
    pDestination.m[0][0] := m.r[0].vector4_f32[0];
    pDestination.m[0][1] := m.r[0].vector4_f32[1];
    pDestination.m[0][2] := m.r[0].vector4_f32[2];
    pDestination.m[0][3] := m.r[0].vector4_f32[3];

    pDestination.m[1][0] := m.r[1].vector4_f32[0];
    pDestination.m[1][1] := m.r[1].vector4_f32[1];
    pDestination.m[1][2] := m.r[1].vector4_f32[2];
    pDestination.m[1][3] := m.r[1].vector4_f32[3];

    pDestination.m[2][0] := m.r[2].vector4_f32[0];
    pDestination.m[2][1] := m.r[2].vector4_f32[1];
    pDestination.m[2][2] := m.r[2].vector4_f32[2];
    pDestination.m[2][3] := m.r[2].vector4_f32[3];

    pDestination.m[3][0] := m.r[3].vector4_f32[0];
    pDestination.m[3][1] := m.r[3].vector4_f32[1];
    pDestination.m[3][2] := m.r[3].vector4_f32[2];
    pDestination.m[3][3] := m.r[3].vector4_f32[3];
end;

{$ENDREGION}// DirectXMathConvert

{$REGION DirectXMathVector}

function XMISNAN(x: single): boolean;
begin
    Result := IsNan(x);
end;



function XMISINF(x: single): boolean;
begin
    Result := IsInfinite(x);
end;

// ------------------------------------------------------------------------------
// Return a vector with all elements equaling zero
function XMVectorZero(): TXMVECTOR;
begin
    Result.vector4_f32[0] := 0;
    Result.vector4_f32[1] := 0;
    Result.vector4_f32[2] := 0;
    Result.vector4_f32[3] := 0;
end;

// Initialize a vector with four floating point values

function XMVectorSet(x, y, z, w: single): TXMVECTOR;
begin
    Result.vector4_f32[0] := x;
    Result.vector4_f32[1] := y;
    Result.vector4_f32[2] := z;
    Result.vector4_f32[3] := w;
end;

// Initialize a vector with four integer values

function XMVectorSetInt(x, y, z, w: uint32): TXMVECTOR;
begin
    Result.vector4_u32[0] := x;
    Result.vector4_u32[1] := y;
    Result.vector4_u32[2] := z;
    Result.vector4_u32[3] := w;
end;

{$IF defined(_XM_AVX_INTRINSICS_)}

function XMVectorReplicate(constref Value: single): TXMVECTOR; assembler;
    nostackframe;
asm
           VBROADCASTSS XMM0,[Value]
           VMOVUPS  [Result],XMM0
end;
{$ELSE}

// Initialize a vector with a replicated floating point value
function XMVectorReplicate(const Value: single): TXMVECTOR;
begin
    Result.vector4_f32[0] := Value;
    Result.vector4_f32[1] := Value;
    Result.vector4_f32[2] := Value;
    Result.vector4_f32[3] := Value;
end;
{$ENDIF}
// Initialize a vector with a replicated floating point value passed by pointer
{$IF defined(_XM_AVX_INTRINSICS_)}

function XMVectorReplicatePtr(const pValue: PSingle): TXMVECTOR; assembler;
    nostackframe;
asm
           VBROADCASTSS XMM0,[pValue]
           VMOVUPS  [Result],XMM0
end;
{$ELSE}

function XMVectorReplicatePtr(const pValue: PSingle): TXMVECTOR;
begin
    Result.vector4_f32[0] := pValue^;
    Result.vector4_f32[1] := pValue^;
    Result.vector4_f32[2] := pValue^;
    Result.vector4_f32[3] := pValue^;
end;
{$ENDIF}
// Initialize a vector with a replicated integer value


function XMVectorReplicateInt(Value: uint32): TXMVECTOR;
begin
    Result.vector4_u32[0] := Value;
    Result.vector4_u32[1] := Value;
    Result.vector4_u32[2] := Value;
    Result.vector4_u32[3] := Value;
end;

// Initialize a vector with a replicated integer value passed by pointer

function XMVectorReplicateIntPtr(const pValue: Puint32): TXMVECTOR;
begin
    Result.vector4_u32[0] := pValue^;
    Result.vector4_u32[1] := pValue^;
    Result.vector4_u32[2] := pValue^;
    Result.vector4_u32[3] := pValue^;
end;

// Initialize a vector with all bits set (true mask)

function XMVectorTrueInt(): TXMVECTOR;
begin
    Result.vector4_u32[0] := $FFFFFFFF;
    Result.vector4_u32[1] := $FFFFFFFF;
    Result.vector4_u32[2] := $FFFFFFFF;
    Result.vector4_u32[3] := $FFFFFFFF;
end;


// Initialize a vector with all bits clear (false mask)
{$IF defined(_XM_SSE_INTRINSICS_)}

function XMVectorFalseInt(): TXMVECTOR; assembler;
    nostackframe;
asm
           XORPS   XMM0, XMM0
           VMOVUPS  [Result],XMM0
end;
{$ELSE}

function XMVectorFalseInt(): TXMVECTOR;
begin
    Result.vector4_f32[0] := 0;
    Result.vector4_f32[1] := 0;
    Result.vector4_f32[2] := 0;
    Result.vector4_f32[3] := 0;
end;
{$ENDIF}
// Replicate the x component of the vector

(*
  {$IF defined(_XM_AVX2_INTRINSICS_)}
  function XMVectorSplatX(constref V: TFXMVECTOR): TXMVECTOR; assembler; nostackframe;
  asm
  MOVUPS  XMM2, [V]
  VBROADCASTSS XMM2, XMM1
  VMOVUPS  [Result],XMM1
  end;
  {$ELSEIF defined(_XM_SSE_INTRINSICS_)} *)
{$IF defined(_XM_SSE_INTRINSICS_)}

function XMVectorSplatX(constref v: TFXMVECTOR): TXMVECTOR; assembler;
    nostackframe;
asm
           MOVUPS  XMM0, [V]
           SHUFPS  XMM0, XMM0, $0
           VMOVUPS  [Result],XMM0
end;
{$ELSE}

function XMVectorSplatX(const v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := v.vector4_f32[0];
    Result.vector4_f32[1] := v.vector4_f32[0];
    Result.vector4_f32[2] := v.vector4_f32[0];
    Result.vector4_f32[3] := v.vector4_f32[0];
end;
{$ENDIF}
// Replicate the y component of the vector

{$IF defined(_XM_SSE_INTRINSICS_)}

function XMVectorSplatY(v: TFXMVECTOR): TXMVECTOR; assembler;
    nostackframe;
asm
           MOVUPS  XMM0, [V]
           SHUFPS  XMM0, XMM0, $55 // (1 shl 6) or (1 shl 4) or (1 shl 2) or 1
           VMOVUPS  [Result],XMM0
end;
{$ELSE}

function XMVectorSplatY(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := v.vector4_f32[1];
    Result.vector4_f32[1] := v.vector4_f32[1];
    Result.vector4_f32[2] := v.vector4_f32[1];
    Result.vector4_f32[3] := v.vector4_f32[1];
end;
{$ENDIF}
// Replicate the z component of the vector
{$IF defined(_XM_SSE_INTRINSICS_)}

function XMVectorSplatZ(v: TFXMVECTOR): TXMVECTOR; assembler;
    nostackframe;
asm
           MOVUPS  XMM0, [V]
           SHUFPS  XMM0, XMM0, $AA // (2 shl 6) or (2 shl 4) or (2 shl 2) or 2
           VMOVUPS  [Result],XMM0
end;
{$ELSE}

function XMVectorSplatZ(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := v.vector4_f32[2];
    Result.vector4_f32[1] := v.vector4_f32[2];
    Result.vector4_f32[2] := v.vector4_f32[2];
    Result.vector4_f32[3] := v.vector4_f32[2];
end;
{$ENDIF}
// Replicate the w component of the vector

{$IF defined(_XM_SSE_INTRINSICS_)}

function XMVectorSplatW(v: TFXMVECTOR): TXMVECTOR; assembler;
    nostackframe;
asm
           MOVUPS  XMM0, [V]
           SHUFPS  XMM0, XMM0, $FF // (3 shl 6) or (3 shl 4) or (3 shl 2) or 3
           VMOVUPS  [Result],XMM0
end;
{$ELSE}

function XMVectorSplatW(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := v.vector4_f32[3];
    Result.vector4_f32[1] := v.vector4_f32[3];
    Result.vector4_f32[2] := v.vector4_f32[3];
    Result.vector4_f32[3] := v.vector4_f32[3];
end;
{$ENDIF}
// Return a vector of 1.0f,1.0f,1.0f,1.0f


function XMVectorSplatOne(): TXMVECTOR;
begin
    Result.vector4_f32[0] := 1;
    Result.vector4_f32[1] := 1;
    Result.vector4_f32[2] := 1;
    Result.vector4_f32[3] := 1;
end;

// Return a vector of INF,INF,INF,INF

function XMVectorSplatInfinity(): TXMVECTOR;
begin
    Result.vector4_u32[0] := $7F800000;
    Result.vector4_u32[1] := $7F800000;
    Result.vector4_u32[2] := $7F800000;
    Result.vector4_u32[3] := $7F800000;
end;

// Return a vector of Q_NAN,Q_NAN,Q_NAN,Q_NAN

function XMVectorSplatQNaN(): TXMVECTOR;
begin
    Result.vector4_u32[0] := $7FC00000;
    Result.vector4_u32[1] := $7FC00000;
    Result.vector4_u32[2] := $7FC00000;
    Result.vector4_u32[3] := $7FC00000;
end;

// Return a vector of 1.192092896e-7f,1.192092896e-7f,1.192092896e-7f,1.192092896e-7f

function XMVectorSplatEpsilon(): TXMVECTOR;
begin
    Result.vector4_u32[0] := $34000000;
    Result.vector4_u32[1] := $34000000;
    Result.vector4_u32[2] := $34000000;
    Result.vector4_u32[3] := $34000000;
end;

// Return a vector of -0.0f ($80000000),-0.0f,-0.0f,-0.0f

function XMVectorSplatSignMask(): TXMVECTOR;
begin
    Result.vector4_u32[0] := $80000000;
    Result.vector4_u32[1] := $80000000;
    Result.vector4_u32[2] := $80000000;
    Result.vector4_u32[3] := $80000000;
end;

// Return a floating point value via an index. This is not a recommended
// function to use due to performance loss.
function XMVectorGetByIndex(v: TFXMVECTOR; i: size_t): single;
begin
    assert(i < 4);
    Result := v.vector4_f32[i];
end;


// Return the X component in an FPU register.
{$IF defined(_XM_SSE_INTRINSICS_)}

function XMVectorGetX(constref v: TFXMVECTOR): single; { assembler; nostackframe; }
begin
{$ASMMODE intel}
    asm
               MOVUPS  XMM0, [EAX]
               MOVSS   [result], XMM0
    end;
end;

{$ELSE}

function XMVectorGetX(const v: TFXMVECTOR): single;
begin
    Result := v.vector4_f32[0];
end;
{$ENDIF}
// Return the Y component in an FPU register.


function XMVectorGetY(v: TFXMVECTOR): single;
begin
    Result := v.vector4_f32[1];
end;

// Return the Z component in an FPU register.

function XMVectorGetZ(v: TFXMVECTOR): single;
begin
    Result := v.vector4_f32[2];
end;

// Return the W component in an FPU register.

function XMVectorGetW(v: TFXMVECTOR): single;
begin
    Result := v.vector4_f32[3];
end;

// Store a component indexed by i into a 32 bit float location in memory.

procedure XMVectorGetByIndexPtr(out f: single; v: TFXMVECTOR; i: size_t);
begin
    assert(i < 4);
    f := v.vector4_f32[i];
end;

// Store the X component into a 32 bit float location in memory.

procedure XMVectorGetXPtr(out x: single; v: TFXMVECTOR);
begin
    x := v.vector4_f32[0];
end;

// Store the Y component into a 32 bit float location in memory.

procedure XMVectorGetYPtr(out y: single; v: TFXMVECTOR);
begin
    y := v.vector4_f32[1];
end;

// Store the Z component into a 32 bit float location in memory.

procedure XMVectorGetZPtr(out z: single; v: TFXMVECTOR);
begin
    z := v.vector4_f32[2];
end;

// Store the W component into a 32 bit float location in memory.

procedure XMVectorGetWPtr(out w: single; v: TFXMVECTOR);
begin
    w := v.vector4_f32[3];
end;

// Return an integer value via an index. This is not a recommended
// function to use due to performance loss.
function XMVectorGetIntByIndex(v: TFXMVECTOR; i: size_t): uint32;
begin
    assert(i < 4);
    Result := v.vector4_u32[i];
end;

// Return the X component in an integer register.

function XMVectorGetIntX(v: TFXMVECTOR): uint32;
begin
    Result := v.vector4_u32[0];
end;

// Return the Y component in an integer register.

function XMVectorGetIntY(v: TFXMVECTOR): uint32;
begin
    Result := v.vector4_u32[1];
end;

// Return the Z component in an integer register.

function XMVectorGetIntZ(v: TFXMVECTOR): uint32;
begin
    Result := v.vector4_u32[2];
end;

// Return the W component in an integer register.

function XMVectorGetIntW(v: TFXMVECTOR): uint32;
begin
    Result := v.vector4_u32[3];
end;

// Store a component indexed by i into a 32 bit integer location in memory.

procedure XMVectorGetIntByIndexPtr(out x: uint32; v: TFXMVECTOR; i: size_t);
begin
    assert(i < 4);
    x := v.vector4_u32[i];
end;

// Store the X component into a 32 bit integer location in memory.

procedure XMVectorGetIntXPtr(out x: uint32; v: TFXMVECTOR);
begin
    x := v.vector4_u32[0];
end;

// Store the Y component into a 32 bit integer location in memory.

procedure XMVectorGetIntYPtr(out y: uint32; v: TFXMVECTOR);
begin
    y := v.vector4_u32[1];
end;

// Store the Z component into a 32 bit integer locaCantion in memory.

procedure XMVectorGetIntZPtr(out z: uint32; v: TFXMVECTOR);
begin
    z := v.vector4_u32[2];
end;

// Store the W component into a 32 bit integer location in memory.

procedure XMVectorGetIntWPtr(out w: uint32; v: TFXMVECTOR);
begin
    w := v.vector4_u32[3];
end;

// Set a single indexed floating point component

function XMVectorSetByIndex(v: TFXMVECTOR; f: single; i: size_t): TXMVECTOR;
begin
    assert(i < 4);
    Result := v;
    Result.vector4_f32[i] := f;
end;

// Sets the X component of a vector to a passed floating point value

function XMVectorSetX(v: TFXMVECTOR; x: single): TXMVECTOR;
begin
    Result.vector4_f32[0] := x;
    Result.vector4_f32[1] := v.vector4_f32[1];
    Result.vector4_f32[2] := v.vector4_f32[2];
    Result.vector4_f32[3] := v.vector4_f32[3];
end;

// Sets the Y component of a vector to a passed floating point value

function XMVectorSetY(v: TFXMVECTOR; y: single): TXMVECTOR;
begin
    Result.vector4_f32[0] := v.vector4_f32[0];
    Result.vector4_f32[1] := y;
    Result.vector4_f32[2] := v.vector4_f32[2];
    Result.vector4_f32[3] := v.vector4_f32[3];
end;

// Sets the Z component of a vector to a passed floating point value

function XMVectorSetZ(v: TFXMVECTOR; z: single): TXMVECTOR;
begin
    Result.vector4_f32[0] := v.vector4_f32[0];
    Result.vector4_f32[1] := v.vector4_f32[1];
    Result.vector4_f32[2] := z;
    Result.vector4_f32[3] := v.vector4_f32[3];
end;

// Sets the W component of a vector to a passed floating point value

function XMVectorSetW(v: TFXMVECTOR; w: single): TXMVECTOR;
begin
    Result.vector4_f32[0] := v.vector4_f32[0];
    Result.vector4_f32[1] := v.vector4_f32[1];
    Result.vector4_f32[2] := v.vector4_f32[2];
    Result.vector4_f32[3] := w;
end;

// Sets a component of a vector to a floating point value passed by pointer

function XMVectorSetByIndexPtr(v: TFXMVECTOR; const f: PSingle; i: size_t): TXMVECTOR;
begin
    assert(i < 4);
    Result := v;
    Result.vector4_f32[i] := f^;
end;

// Sets the X component of a vector to a floating point value passed by pointer

function XMVectorSetXPtr(v: TFXMVECTOR; const x: PSingle): TXMVECTOR;
begin
    Result.vector4_f32[0] := x^;
    Result.vector4_f32[1] := v.vector4_f32[1];
    Result.vector4_f32[2] := v.vector4_f32[2];
    Result.vector4_f32[3] := v.vector4_f32[3];
end;

// Sets the Y component of a vector to a floating point value passed by pointer

function XMVectorSetYPtr(v: TFXMVECTOR; const y: PSingle): TXMVECTOR;
begin
    Result.vector4_f32[0] := v.vector4_f32[0];
    Result.vector4_f32[1] := y^;
    Result.vector4_f32[2] := v.vector4_f32[2];
    Result.vector4_f32[3] := v.vector4_f32[3];
end;

// Sets the Z component of a vector to a floating point value passed by pointer

function XMVectorSetZPtr(v: TFXMVECTOR; const z: PSingle): TXMVECTOR;
begin
    Result.vector4_f32[0] := v.vector4_f32[0];
    Result.vector4_f32[1] := v.vector4_f32[1];
    Result.vector4_f32[2] := z^;
    Result.vector4_f32[3] := v.vector4_f32[3];
end;

// Sets the W component of a vector to a floating point value passed by pointer

function XMVectorSetWPtr(v: TFXMVECTOR; const w: PSingle): TXMVECTOR;
begin
    Result.vector4_f32[0] := v.vector4_f32[0];
    Result.vector4_f32[1] := v.vector4_f32[1];
    Result.vector4_f32[2] := v.vector4_f32[2];
    Result.vector4_f32[3] := w^;
end;

// Sets a component of a vector to an integer passed by value

function XMVectorSetIntByIndex(v: TFXMVECTOR; x: uint32; i: size_t): TXMVECTOR;
begin
    assert(i < 4);
    Result := v;
    Result.vector4_u32[i] := x;
end;

// Sets the X component of a vector to an integer passed by value

function XMVectorSetIntX(v: TFXMVECTOR; x: uint32): TXMVECTOR;
begin
    Result.vector4_u32[0] := x;
    Result.vector4_u32[1] := v.vector4_u32[1];
    Result.vector4_u32[2] := v.vector4_u32[2];
    Result.vector4_u32[3] := v.vector4_u32[3];
end;

// Sets the Y component of a vector to an integer passed by value

function XMVectorSetIntY(v: TFXMVECTOR; y: uint32): TXMVECTOR;
begin
    Result.vector4_u32[0] := v.vector4_u32[0];
    Result.vector4_u32[1] := y;
    Result.vector4_u32[2] := v.vector4_u32[2];
    Result.vector4_u32[3] := v.vector4_u32[3];
end;

// Sets the Z component of a vector to an integer passed by value

function XMVectorSetIntZ(v: TFXMVECTOR; z: uint32): TXMVECTOR;
begin
    Result.vector4_u32[0] := v.vector4_u32[0];
    Result.vector4_u32[1] := v.vector4_u32[1];
    Result.vector4_u32[2] := z;
    Result.vector4_u32[3] := v.vector4_u32[3];
end;

// Sets the W component of a vector to an integer passed by value

function XMVectorSetIntW(v: TFXMVECTOR; w: uint32): TXMVECTOR;
begin
    Result.vector4_u32[0] := v.vector4_u32[0];
    Result.vector4_u32[1] := v.vector4_u32[1];
    Result.vector4_u32[2] := v.vector4_u32[2];
    Result.vector4_u32[3] := w;
end;

// Sets a component of a vector to an integer value passed by pointer

function XMVectorSetIntByIndexPtr(v: TFXMVECTOR; const x: Puint32; i: size_t): TXMVECTOR;
begin
    assert(i < 4);
    Result := v;
    Result.vector4_u32[i] := x^;
end;

// Sets the X component of a vector to an integer value passed by pointer

function XMVectorSetIntXPtr(v: TFXMVECTOR; const x: Puint32): TXMVECTOR;
begin
    Result.vector4_u32[0] := x^;
    Result.vector4_u32[1] := v.vector4_u32[1];
    Result.vector4_u32[2] := v.vector4_u32[2];
    Result.vector4_u32[3] := v.vector4_u32[3];
end;

// Sets the Y component of a vector to an integer value passed by pointer

function XMVectorSetIntYPtr(v: TFXMVECTOR; const y: Puint32): TXMVECTOR;
begin
    Result.vector4_u32[0] := v.vector4_u32[0];
    Result.vector4_u32[1] := y^;
    Result.vector4_u32[2] := v.vector4_u32[2];
    Result.vector4_u32[3] := v.vector4_u32[3];
end;

// Sets the Z component of a vector to an integer value passed by pointer

function XMVectorSetIntZPtr(v: TFXMVECTOR; const z: Puint32): TXMVECTOR;
begin
    Result.vector4_u32[0] := v.vector4_u32[0];
    Result.vector4_u32[1] := v.vector4_u32[1];
    Result.vector4_u32[2] := z^;
    Result.vector4_u32[3] := v.vector4_u32[3];
end;

// Sets the W component of a vector to an integer value passed by pointer

function XMVectorSetIntWPtr(v: TFXMVECTOR; const w: Puint32): TXMVECTOR;
begin
    Result.vector4_u32[0] := v.vector4_u32[0];
    Result.vector4_u32[1] := v.vector4_u32[1];
    Result.vector4_u32[2] := v.vector4_u32[2];
    Result.vector4_u32[3] := w^;
end;



function XMVectorSwizzle(v: TFXMVECTOR; E0, E1, E2, E3: uint32): TXMVECTOR; overload;
begin
    assert((E0 < 4) and (E1 < 4) and (E2 < 4) and (E3 < 4));
    Result.vector4_f32[0] := v.vector4_f32[E0];
    Result.vector4_f32[1] := v.vector4_f32[E1];
    Result.vector4_f32[2] := v.vector4_f32[E2];
    Result.vector4_f32[3] := v.vector4_f32[E3];
end;

// Permutes the components of two vectors to create a new vector.
// Index form 0-7 indicating where the component of the new vector should be copied from.
function XMVectorPermute(const V1: TFXMVECTOR; const V2: TFXMVECTOR; PermuteX, PermuteY, PermuteZ, PermuteW: uint32): TXMVECTOR;
var
    i0, i1, i2, i3: uint32;
    vi0, vi1, vi2, vi3: uint32;
    // aPtr: array [0..1] of PUINT32;
    aPtr: array [0 .. 1] of PArray4UINT32;

begin
    assert((PermuteX <= 7) and (PermuteY <= 7) and (PermuteZ <= 7) and (PermuteW <= 7));

    aPtr[0] := PArray4UINT32(@V1);
    aPtr[1] := PArray4UINT32(@V2);

    i0 := PermuteX and 3;
    vi0 := PermuteX shr 2;
    Result.vector4_u32[0] := aPtr[vi0][i0];

    i1 := PermuteY and 3;
    vi1 := PermuteY shr 2;
    Result.vector4_u32[1] := aPtr[vi1][i1];

    i2 := PermuteZ and 3;
    vi2 := PermuteZ shr 2;
    Result.vector4_u32[2] := aPtr[vi2][i2];

    i3 := PermuteW and 3;
    vi3 := PermuteW shr 2;
    Result.vector4_u32[3] := aPtr[vi3][i3];
end;

// Define a control vector to be used in XMVectorSelect
// operations.  The four integers specified in XMVectorSelectControl
// serve as indices to select between components in two vectors.
// The first index controls selection for the first component of
// the vectors involved in a select operation, the second index
// controls selection for the second component etc.  A value of
// zero for an index causes the corresponding component from the first
// vector to be selected whereas a one causes the component from the
// second vector to be selected instead.
function XMVectorSelectControl(VectorIndex0, VectorIndex1, VectorIndex2, VectorIndex3: uint32): TXMVECTOR;
const
    ControlElement: array [0 .. 1] of uint32 = (XM_SELECT_0, XM_SELECT_1);
begin
    assert(VectorIndex0 < 2);
    assert(VectorIndex1 < 2);
    assert(VectorIndex2 < 2);
    assert(VectorIndex3 < 2);

    Result.vector4_u32[0] := ControlElement[VectorIndex0];
    Result.vector4_u32[1] := ControlElement[VectorIndex1];
    Result.vector4_u32[2] := ControlElement[VectorIndex2];
    Result.vector4_u32[3] := ControlElement[VectorIndex3];
end;



function XMVectorSelect(V1: TFXMVECTOR; V2: TFXMVECTOR; Control: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_u32[0] := (V1.vector4_u32[0] and not Control.vector4_u32[0]) or (V2.vector4_u32[0] and Control.vector4_u32[0]);
    Result.vector4_u32[1] := (V1.vector4_u32[1] and not Control.vector4_u32[1]) or (V2.vector4_u32[1] and Control.vector4_u32[1]);
    Result.vector4_u32[2] := (V1.vector4_u32[2] and not Control.vector4_u32[2]) or (V2.vector4_u32[2] and Control.vector4_u32[2]);
    Result.vector4_u32[3] := (V1.vector4_u32[3] and not Control.vector4_u32[3]) or (V2.vector4_u32[3] and Control.vector4_u32[3]);

end;



function XMVectorMergeXY(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_u32[0] := V1.vector4_u32[0];
    Result.vector4_u32[1] := V2.vector4_u32[0];
    Result.vector4_u32[2] := V1.vector4_u32[1];
    Result.vector4_u32[3] := V2.vector4_u32[1];
end;



function XMVectorMergeZW(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_u32[0] := V1.vector4_u32[2];
    Result.vector4_u32[1] := V2.vector4_u32[2];
    Result.vector4_u32[2] := V1.vector4_u32[3];
    Result.vector4_u32[3] := V2.vector4_u32[3];
end;



function XMVectorShiftLeft(V1: TFXMVECTOR; V2: TFXMVECTOR; Elements: uint32): TXMVECTOR;
begin
    assert(Elements < 4);
    Result := XMVectorPermute(V1, V2, Elements, ((Elements) + 1), ((Elements) + 2), ((Elements) + 3));
end;



function XMVectorRotateLeft(v: TFXMVECTOR; Elements: uint32): TXMVECTOR;
begin
    assert(Elements < 4);
    Result := XMVectorSwizzle(v, Elements and 3, (Elements + 1) and 3, (Elements + 2) and 3, (Elements + 3) and 3);
end;



function XMVectorRotateRight(v: TFXMVECTOR; Elements: uint32): TXMVECTOR;
begin
    assert(Elements < 4);
    Result := XMVectorSwizzle(v, (4 - (Elements)) and 3, (5 - (Elements)) and 3, (6 - (Elements)) and 3, (7 - (Elements)) and 3);
end;



function XMVectorInsert(VD: TFXMVECTOR; VS: TFXMVECTOR; VSLeftRotateElements, Select0, Select1, Select2, Select3: uint32): TXMVECTOR;
var
    Control: TXMVECTOR;
begin
    Control := XMVectorSelectControl(Select0 and 1, Select1 and 1, Select2 and 1, Select3 and 1);
    Result := XMVectorSelect(VD, XMVectorRotateLeft(VS, VSLeftRotateElements), Control);
end;



function XMVectorInsert(VSLeftRotateElements, Select0, Select1, Select2, Select3: uint32; VD, VS: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVectorInsert(VD, VS, VSLeftRotateElements, Select0, Select1, Select2, Select3);
end;

// ------------------------------------------------------------------------------
// Comparison operations
// ------------------------------------------------------------------------------

function XMVectorEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin

    if (V1.vector4_f32[0] = V2.vector4_f32[0]) then
        Result.vector4_u32[0] := $FFFFFFFF
    else
        Result.vector4_u32[0] := 0;
    if (V1.vector4_f32[1] = V2.vector4_f32[1]) then
        Result.vector4_u32[1] := $FFFFFFFF
    else
        Result.vector4_u32[1] := 0;
    if (V1.vector4_f32[2] = V2.vector4_f32[2]) then
        Result.vector4_u32[2] := $FFFFFFFF
    else
        Result.vector4_u32[2] := 0;
    if (V1.vector4_f32[3] = V2.vector4_f32[3]) then
        Result.vector4_u32[3] := $FFFFFFFF
    else
        Result.vector4_u32[3] := 0;
end;



function XMVectorEqualR(out CR: uint32; V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
var
    ux, uy, uz, uw: uint32;
begin
    if (V1.vector4_f32[0] = V2.vector4_f32[0]) then
        ux := $FFFFFFFF
    else
        ux := 0;
    if (V1.vector4_f32[1] = V2.vector4_f32[1]) then
        uy := $FFFFFFFF
    else
        uy := 0;
    if (V1.vector4_f32[2] = V2.vector4_f32[2]) then
        uz := $FFFFFFFF
    else
        uz := 0;
    if (V1.vector4_f32[3] = V2.vector4_f32[3]) then
        uw := $FFFFFFFF
    else
        uw := 0;
    CR := 0;
    if (ux and uy and uz and uw) <> 0 then
        // All elements are greater
        CR := XM_CRMASK_CR6TRUE
    else if ((ux or uy or uz or uw) = 0) then
        // All elements are not greater
        CR := XM_CRMASK_CR6FALSE;

    Result.vector4_u32[0] := ux;
    Result.vector4_u32[1] := uy;
    Result.vector4_u32[2] := uz;
    Result.vector4_u32[3] := uw;
end;

// Treat the components of the vectors as unsigned integers and
// compare individual bits between the two.  This is useful for
// comparing control vectors and result vectors returned from
// other comparison operations.
function XMVectorEqualInt(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    if (V1.vector4_u32[0] = V2.vector4_u32[0]) then
        Result.vector4_u32[0] := $FFFFFFFF
    else
        Result.vector4_u32[0] := 0;
    if (V1.vector4_u32[1] = V2.vector4_u32[1]) then
        Result.vector4_u32[1] := $FFFFFFFF
    else
        Result.vector4_u32[1] := 0;
    if (V1.vector4_u32[2] = V2.vector4_u32[2]) then
        Result.vector4_u32[2] := $FFFFFFFF
    else
        Result.vector4_u32[2] := 0;
    if (V1.vector4_u32[3] = V2.vector4_u32[3]) then
        Result.vector4_u32[3] := $FFFFFFFF
    else
        Result.vector4_u32[3] := 0;
end;



function XMVectorEqualIntR(out CR: uint32; V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVectorEqualInt(V1, V2);

    CR := 0;
    if (XMVector4EqualInt(Result, XMVectorTrueInt())) then
        // All elements are equal
        CR := CR or XM_CRMASK_CR6TRUE

    else if (XMVector4EqualInt(Result, XMVectorFalseInt())) then
        // All elements are not equal
        CR := CR or XM_CRMASK_CR6FALSE;
end;



function XMVectorNearEqual(V1: TFXMVECTOR; V2: TFXMVECTOR; Epsilon: TFXMVECTOR): TXMVECTOR;
var
    fDeltax, fDeltay, fDeltaz, fDeltaw: single;
begin
    fDeltax := V1.vector4_f32[0] - V2.vector4_f32[0];
    fDeltay := V1.vector4_f32[1] - V2.vector4_f32[1];
    fDeltaz := V1.vector4_f32[2] - V2.vector4_f32[2];
    fDeltaw := V1.vector4_f32[3] - V2.vector4_f32[3];

    fDeltax := abs(fDeltax);
    fDeltay := abs(fDeltay);
    fDeltaz := abs(fDeltaz);
    fDeltaw := abs(fDeltaw);

    if (fDeltax <= Epsilon.vector4_f32[0]) then
        Result.vector4_u32[0] := $FFFFFFFF
    else
        Result.vector4_u32[0] := 0;
    if (fDeltay <= Epsilon.vector4_f32[1]) then
        Result.vector4_u32[1] := $FFFFFFFF
    else
        Result.vector4_u32[1] := 0;
    if (fDeltaz <= Epsilon.vector4_f32[2]) then
        Result.vector4_u32[2] := $FFFFFFFF
    else
        Result.vector4_u32[2] := 0;
    if (fDeltaw <= Epsilon.vector4_f32[3]) then
        Result.vector4_u32[3] := $FFFFFFFF
    else
        Result.vector4_u32[3] := 0;
end;



function XMVectorNotEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    if (V1.vector4_f32[0] <> V2.vector4_f32[0]) then
        Result.vector4_u32[0] := $FFFFFFFF
    else
        Result.vector4_u32[0] := 0;
    if (V1.vector4_f32[1] <> V2.vector4_f32[1]) then
        Result.vector4_u32[1] := $FFFFFFFF
    else
        Result.vector4_u32[1] := 0;
    if (V1.vector4_f32[2] <> V2.vector4_f32[2]) then
        Result.vector4_u32[2] := $FFFFFFFF
    else
        Result.vector4_u32[2] := 0;
    if (V1.vector4_f32[3] <> V2.vector4_f32[3]) then
        Result.vector4_u32[3] := $FFFFFFFF
    else
        Result.vector4_u32[3] := 0;
end;



function XMVectorNotEqualInt(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    if (V1.vector4_u32[0] <> V2.vector4_u32[0]) then
        Result.vector4_u32[0] := $FFFFFFFF
    else
        Result.vector4_u32[0] := 0;
    if (V1.vector4_u32[1] <> V2.vector4_u32[1]) then
        Result.vector4_u32[1] := $FFFFFFFF
    else
        Result.vector4_u32[1] := 0;
    if (V1.vector4_u32[2] <> V2.vector4_u32[2]) then
        Result.vector4_u32[2] := $FFFFFFFF
    else
        Result.vector4_u32[2] := 0;
    if (V1.vector4_u32[3] <> V2.vector4_u32[3]) then
        Result.vector4_u32[3] := $FFFFFFFF
    else
        Result.vector4_u32[3] := 0;
end;



function XMVectorGreater(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    if (V1.vector4_f32[0] > V2.vector4_f32[0]) then
        Result.vector4_u32[0] := $FFFFFFFF
    else
        Result.vector4_u32[0] := 0;
    if (V1.vector4_f32[1] > V2.vector4_f32[1]) then
        Result.vector4_u32[1] := $FFFFFFFF
    else
        Result.vector4_u32[1] := 0;
    if (V1.vector4_f32[2] > V2.vector4_f32[2]) then
        Result.vector4_u32[2] := $FFFFFFFF
    else
        Result.vector4_u32[2] := 0;
    if (V1.vector4_f32[3] > V2.vector4_f32[3]) then
        Result.vector4_u32[3] := $FFFFFFFF
    else
        Result.vector4_u32[3] := 0;
end;



function XMVectorGreaterR(out CR: uint32; V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
var
    ux, uy, uz, uw: uint32;
begin

    if (V1.vector4_f32[0] > V2.vector4_f32[0]) then
        ux := $FFFFFFFF
    else
        ux := 0;
    if (V1.vector4_f32[1] > V2.vector4_f32[1]) then
        uy := $FFFFFFFF
    else
        uy := 0;
    if (V1.vector4_f32[2] > V2.vector4_f32[2]) then
        uz := $FFFFFFFF
    else
        uz := 0;
    if (V1.vector4_f32[3] > V2.vector4_f32[3]) then
        uw := $FFFFFFFF
    else
        uw := 0;
    CR := 0;
    if (ux and uy and uz and uw) <> 0 then
        // All elements are greater
        CR := XM_CRMASK_CR6TRUE
    else if ((ux or uy or uz or uw) = 0) then
        // All elements are not greater
        CR := XM_CRMASK_CR6FALSE;

    Result.vector4_u32[0] := ux;
    Result.vector4_u32[1] := uy;
    Result.vector4_u32[2] := uz;
    Result.vector4_u32[3] := uw;

end;



function XMVectorGreaterOrEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    if (V1.vector4_f32[0] >= V2.vector4_f32[0]) then
        Result.vector4_u32[0] := $FFFFFFFF
    else
        Result.vector4_u32[0] := 0;
    if (V1.vector4_f32[1] >= V2.vector4_f32[1]) then
        Result.vector4_u32[1] := $FFFFFFFF
    else
        Result.vector4_u32[1] := 0;
    if (V1.vector4_f32[2] >= V2.vector4_f32[2]) then
        Result.vector4_u32[2] := $FFFFFFFF
    else
        Result.vector4_u32[2] := 0;
    if (V1.vector4_f32[3] >= V2.vector4_f32[3]) then
        Result.vector4_u32[3] := $FFFFFFFF
    else
        Result.vector4_u32[3] := 0;
end;



function XMVectorGreaterOrEqualR(out CR: uint32; V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
var
    ux, uy, uz, uw: uint32;
begin

    if (V1.vector4_f32[0] >= V2.vector4_f32[0]) then
        ux := $FFFFFFFF
    else
        ux := 0;
    if (V1.vector4_f32[1] >= V2.vector4_f32[1]) then
        uy := $FFFFFFFF
    else
        uy := 0;
    if (V1.vector4_f32[2] >= V2.vector4_f32[2]) then
        uz := $FFFFFFFF
    else
        uz := 0;
    if (V1.vector4_f32[3] >= V2.vector4_f32[3]) then
        uw := $FFFFFFFF
    else
        uw := 0;
    CR := 0;
    if (ux and uy and uz and uw) <> 0 then
        // All elements are greater
        CR := XM_CRMASK_CR6TRUE
    else if ((ux or uy or uz or uw) = 0) then
        // All elements are not greater
        CR := XM_CRMASK_CR6FALSE;

    Result.vector4_u32[0] := ux;
    Result.vector4_u32[1] := uy;
    Result.vector4_u32[2] := uz;
    Result.vector4_u32[3] := uw;

end;



function XMVectorLess(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    if (V1.vector4_f32[0] < V2.vector4_f32[0]) then
        Result.vector4_u32[0] := $FFFFFFFF
    else
        Result.vector4_u32[0] := 0;
    if (V1.vector4_f32[1] < V2.vector4_f32[1]) then
        Result.vector4_u32[1] := $FFFFFFFF
    else
        Result.vector4_u32[1] := 0;
    if (V1.vector4_f32[2] < V2.vector4_f32[2]) then
        Result.vector4_u32[2] := $FFFFFFFF
    else
        Result.vector4_u32[2] := 0;
    if (V1.vector4_f32[3] < V2.vector4_f32[3]) then
        Result.vector4_u32[3] := $FFFFFFFF
    else
        Result.vector4_u32[3] := 0;
end;



function XMVectorLessOrEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    if (V1.vector4_f32[0] <= V2.vector4_f32[0]) then
        Result.vector4_u32[0] := $FFFFFFFF
    else
        Result.vector4_u32[0] := 0;
    if (V1.vector4_f32[1] <= V2.vector4_f32[1]) then
        Result.vector4_u32[1] := $FFFFFFFF
    else
        Result.vector4_u32[1] := 0;
    if (V1.vector4_f32[2] <= V2.vector4_f32[2]) then
        Result.vector4_u32[2] := $FFFFFFFF
    else
        Result.vector4_u32[2] := 0;
    if (V1.vector4_f32[3] <= V2.vector4_f32[3]) then
        Result.vector4_u32[3] := $FFFFFFFF
    else
        Result.vector4_u32[3] := 0;
end;



function XMVectorInBounds(v: TFXMVECTOR; Bounds: TFXMVECTOR): TXMVECTOR;
begin
    if (v.vector4_f32[0] <= Bounds.vector4_f32[0]) and (v.vector4_f32[0] >= -Bounds.vector4_f32[0]) then
        Result.vector4_u32[0] := $FFFFFFFF
    else
        Result.vector4_u32[0] := 0;
    if (v.vector4_f32[1] <= Bounds.vector4_f32[1]) and (v.vector4_f32[1] >= -Bounds.vector4_f32[1]) then
        Result.vector4_u32[1] := $FFFFFFFF
    else
        Result.vector4_u32[1] := 0;
    if (v.vector4_f32[2] <= Bounds.vector4_f32[2]) and (v.vector4_f32[2] >= -Bounds.vector4_f32[2]) then
        Result.vector4_u32[2] := $FFFFFFFF
    else
        Result.vector4_u32[2] := 0;
    if (v.vector4_f32[3] <= Bounds.vector4_f32[3]) and (v.vector4_f32[3] >= -Bounds.vector4_f32[3]) then
        Result.vector4_u32[3] := $FFFFFFFF
    else
        Result.vector4_u32[3] := 0;
end;



function XMVectorInBoundsR(out CR: uint32; v: TFXMVECTOR; Bounds: TFXMVECTOR): TXMVECTOR;
var
    ux, uy, uz, uw: uint32;
begin
    if (v.vector4_f32[0] <= Bounds.vector4_f32[0]) and (v.vector4_f32[0] >= -Bounds.vector4_f32[0]) then
        ux := $FFFFFFFF
    else
        ux := 0;
    if (v.vector4_f32[1] <= Bounds.vector4_f32[1]) and (v.vector4_f32[1] >= -Bounds.vector4_f32[1]) then
        uy := $FFFFFFFF
    else
        uy := 0;
    if (v.vector4_f32[2] <= Bounds.vector4_f32[2]) and (v.vector4_f32[2] >= -Bounds.vector4_f32[2]) then
        uz := $FFFFFFFF
    else
        uz := 0;
    if (v.vector4_f32[3] <= Bounds.vector4_f32[3]) and (v.vector4_f32[3] >= -Bounds.vector4_f32[3]) then
        uw := $FFFFFFFF
    else
        uw := 0;

    CR := 0;
    if (ux and uy and uz and uw) <> 0 then
        // All elements are in bounds
        CR := XM_CRMASK_CR6BOUNDS;

    Result.vector4_u32[0] := ux;
    Result.vector4_u32[1] := uy;
    Result.vector4_u32[2] := uz;
    Result.vector4_u32[3] := uw;
end;



function XMVectorIsNaN(v: TFXMVECTOR): TXMVECTOR;
begin
    if XMISNAN(v.vector4_f32[0]) then
        Result.vector4_u32[0] := $FFFFFFFF
    else
        Result.vector4_u32[0] := 0;
    if XMISNAN(v.vector4_f32[1]) then
        Result.vector4_u32[1] := $FFFFFFFF
    else
        Result.vector4_u32[1] := 0;
    if XMISNAN(v.vector4_f32[2]) then
        Result.vector4_u32[2] := $FFFFFFFF
    else
        Result.vector4_u32[2] := 0;
    if XMISNAN(v.vector4_f32[3]) then
        Result.vector4_u32[3] := $FFFFFFFF
    else
        Result.vector4_u32[3] := 0;
end;



function XMVectorIsInfinite(v: TFXMVECTOR): TXMVECTOR;
begin
    if XMISINF(v.vector4_f32[0]) then
        Result.vector4_u32[0] := $FFFFFFFF
    else
        Result.vector4_u32[0] := 0;
    if XMISINF(v.vector4_f32[1]) then
        Result.vector4_u32[1] := $FFFFFFFF
    else
        Result.vector4_u32[1] := 0;
    if XMISINF(v.vector4_f32[2]) then
        Result.vector4_u32[2] := $FFFFFFFF
    else
        Result.vector4_u32[2] := 0;
    if XMISINF(v.vector4_f32[3]) then
        Result.vector4_u32[3] := $FFFFFFFF
    else
        Result.vector4_u32[3] := 0;
end;

// ------------------------------------------------------------------------------
// Rounding and clamping operations
// ------------------------------------------------------------------------------

function XMVectorMin(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    if (V1.vector4_f32[0] < V2.vector4_f32[0]) then
        Result.vector4_f32[0] := V1.vector4_f32[0]
    else
        Result.vector4_f32[0] := V2.vector4_f32[0];
    if (V1.vector4_f32[1] < V2.vector4_f32[1]) then
        Result.vector4_f32[1] := V1.vector4_f32[1]
    else
        Result.vector4_f32[1] := V2.vector4_f32[1];
    if (V1.vector4_f32[2] < V2.vector4_f32[2]) then
        Result.vector4_f32[2] := V1.vector4_f32[2]
    else
        Result.vector4_f32[2] := V2.vector4_f32[2];
    if (V1.vector4_f32[3] < V2.vector4_f32[3]) then
        Result.vector4_f32[3] := V1.vector4_f32[3]
    else
        Result.vector4_f32[3] := V2.vector4_f32[3];
end;



function XMVectorMax(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    if (V1.vector4_f32[0] > V2.vector4_f32[0]) then
        Result.vector4_f32[0] := V1.vector4_f32[0]
    else
        Result.vector4_f32[0] := V2.vector4_f32[0];
    if (V1.vector4_f32[1] > V2.vector4_f32[1]) then
        Result.vector4_f32[1] := V1.vector4_f32[1]
    else
        Result.vector4_f32[1] := V2.vector4_f32[1];
    if (V1.vector4_f32[2] > V2.vector4_f32[2]) then
        Result.vector4_f32[2] := V1.vector4_f32[2]
    else
        Result.vector4_f32[2] := V2.vector4_f32[2];
    if (V1.vector4_f32[3] > V2.vector4_f32[3]) then
        Result.vector4_f32[3] := V1.vector4_f32[3]
    else
        Result.vector4_f32[3] := V2.vector4_f32[3];
end;

// Round to nearest (even) a.k.a. banker's rounding

function round_to_nearest(x: single): single;
var
    i: single;
    int_part: single;
begin
    i := floor(x);
    x := x - i;
    if (x < 0.5) then
        Result := i
    else if (x > 0.5) then
        Result := i + 1.0
    else
    begin
        int_part := trunc(i / 2.0);
        if ((2.0 * int_part) = i) then
            Result := i
        else
            Result := i + 1.0;
    end;
end;



function XMVectorRound(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := round_to_nearest(v.vector4_f32[0]);
    Result.vector4_f32[1] := round_to_nearest(v.vector4_f32[1]);
    Result.vector4_f32[2] := round_to_nearest(v.vector4_f32[2]);
    Result.vector4_f32[3] := round_to_nearest(v.vector4_f32[3]);
end;



function XMVectorTruncate(v: TFXMVECTOR): TXMVECTOR;
var
    i: integer;
begin
    for i := 0 to 3 do
    begin
        if (XMISNAN(v.vector4_f32[i])) then
            Result.vector4_u32[i] := $7FC00000
        else if (abs(v.vector4_f32[i]) < 8388608.0) then
            Result.vector4_f32[i] := trunc(v.vector4_f32[i])
        else
            Result.vector4_f32[i] := v.vector4_f32[i];
    end;
end;



function XMVectorFloor(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := floor(v.vector4_f32[0]);
    Result.vector4_f32[1] := floor(v.vector4_f32[1]);
    Result.vector4_f32[2] := floor(v.vector4_f32[2]);
    Result.vector4_f32[3] := floor(v.vector4_f32[3]);

end;



function XMVectorCeiling(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := ceil(v.vector4_f32[0]);
    Result.vector4_f32[1] := ceil(v.vector4_f32[1]);
    Result.vector4_f32[2] := ceil(v.vector4_f32[2]);
    Result.vector4_f32[3] := ceil(v.vector4_f32[3]);
end;



function XMVectorClamp(v: TFXMVECTOR; Min: TFXMVECTOR; Max: TFXMVECTOR): TXMVECTOR;
begin
    assert(XMVector4LessOrEqual(Min, Max));
    Result := XMVectorMax(Min, v);
    Result := XMVectorMin(Max, Result);
end;



function XMVectorSaturate(v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVectorClamp(v, g_XMZero, g_XMOne);
end;

// ------------------------------------------------------------------------------
// Bitwise logical operations
// ------------------------------------------------------------------------------

function XMVectorAndInt(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_u32[0] := V1.vector4_u32[0] and V2.vector4_u32[0];
    Result.vector4_u32[1] := V1.vector4_u32[1] and V2.vector4_u32[1];
    Result.vector4_u32[2] := V1.vector4_u32[2] and V2.vector4_u32[2];
    Result.vector4_u32[3] := V1.vector4_u32[3] and V2.vector4_u32[3];
end;



function XMVectorAndCInt(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_u32[0] := V1.vector4_u32[0] and not V2.vector4_u32[0];
    Result.vector4_u32[1] := V1.vector4_u32[1] and not V2.vector4_u32[1];
    Result.vector4_u32[2] := V1.vector4_u32[2] and not V2.vector4_u32[2];
    Result.vector4_u32[3] := V1.vector4_u32[3] and not V2.vector4_u32[3];
end;



function XMVectorOrInt(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_u32[0] := V1.vector4_u32[0] or V2.vector4_u32[0];
    Result.vector4_u32[1] := V1.vector4_u32[1] or V2.vector4_u32[1];
    Result.vector4_u32[2] := V1.vector4_u32[2] or V2.vector4_u32[2];
    Result.vector4_u32[3] := V1.vector4_u32[3] or V2.vector4_u32[3];
end;



function XMVectorNorInt(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_u32[0] := not (V1.vector4_u32[0] or V2.vector4_u32[0]);
    Result.vector4_u32[1] := not (V1.vector4_u32[1] or V2.vector4_u32[1]);
    Result.vector4_u32[2] := not (V1.vector4_u32[2] or V2.vector4_u32[2]);
    Result.vector4_u32[3] := not (V1.vector4_u32[3] or V2.vector4_u32[3]);
end;



function XMVectorXorInt(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_u32[0] := V1.vector4_u32[0] xor V2.vector4_u32[0];
    Result.vector4_u32[1] := V1.vector4_u32[1] xor V2.vector4_u32[1];
    Result.vector4_u32[2] := V1.vector4_u32[2] xor V2.vector4_u32[2];
    Result.vector4_u32[3] := V1.vector4_u32[3] xor V2.vector4_u32[3];
end;

// ------------------------------------------------------------------------------
// Computation operations
// ------------------------------------------------------------------------------

function XMVectorNegate({$IFDEF FPC}constref{$ELSE}{$ENDIF}v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := -v.vector4_f32[0];
    Result.vector4_f32[1] := -v.vector4_f32[1];
    Result.vector4_f32[2] := -v.vector4_f32[2];
    Result.vector4_f32[3] := -v.vector4_f32[3];
end;



function XMVectorAdd(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := V1.vector4_f32[0] + V2.vector4_f32[0];
    Result.vector4_f32[1] := V1.vector4_f32[1] + V2.vector4_f32[1];
    Result.vector4_f32[2] := V1.vector4_f32[2] + V2.vector4_f32[2];
    Result.vector4_f32[3] := V1.vector4_f32[3] + V2.vector4_f32[3];

end;



function XMVectorSum(v: TFXMVECTOR): TXMVECTOR;
var
    s: single;
begin
    s := v.vector4_f32[0] + v.vector4_f32[1] + v.vector4_f32[2] + v.vector4_f32[3];
    Result.vector4_f32[0] := s;
    Result.vector4_f32[1] := s;
    Result.vector4_f32[2] := s;
    Result.vector4_f32[3] := s;
end;



function XMVectorAddAngles(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
var
    Mask: TXMVECTOR;
    Offset: TXMVECTOR;
begin
    // Add the given angles together.  If the range of V1 is such
    // that -Pi <= V1 < Pi and the range of V2 is such that
    // -2Pi <= V2 <= 2Pi, then the range of the resulting angle
    // will be -Pi <= Result < Pi.
    Result := XMVectorAdd(V1, V2);

    Mask := XMVectorLess(Result, g_XMNegativePi);
    Offset := XMVectorSelect(g_XMZero, g_XMTwoPi, Mask);

    Mask := XMVectorGreaterOrEqual(Result, g_XMPi);
    Offset := XMVectorSelect(Offset, g_XMNegativeTwoPi, Mask);

    Result := XMVectorAdd(Result, Offset);
end;



function XMVectorSubtract(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := V1.vector4_f32[0] - V2.vector4_f32[0];
    Result.vector4_f32[1] := V1.vector4_f32[1] - V2.vector4_f32[1];
    Result.vector4_f32[2] := V1.vector4_f32[2] - V2.vector4_f32[2];
    Result.vector4_f32[3] := V1.vector4_f32[3] - V2.vector4_f32[3];
end;



function XMVectorSubtractAngles(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
var
    Mask: TXMVECTOR;
    Offset: TXMVECTOR;
begin
    // Subtract the given angles.  If the range of V1 is such
    // that -Pi <= V1 < Pi and the range of V2 is such that
    // -2Pi <= V2 <= 2Pi, then the range of the resulting angle
    // will be -Pi <= Result < Pi.
    Result := XMVectorSubtract(V1, V2);

    Mask := XMVectorLess(Result, g_XMNegativePi);
    Offset := XMVectorSelect(g_XMZero, g_XMTwoPi, Mask);

    Mask := XMVectorGreaterOrEqual(Result, g_XMPi);
    Offset := XMVectorSelect(Offset, g_XMNegativeTwoPi, Mask);

    Result := XMVectorAdd(Result, Offset);
end;



function XMVectorMultiply(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := V1.vector4_f32[0] * V2.vector4_f32[0];
    Result.vector4_f32[1] := V1.vector4_f32[1] * V2.vector4_f32[1];
    Result.vector4_f32[2] := V1.vector4_f32[2] * V2.vector4_f32[2];
    Result.vector4_f32[3] := V1.vector4_f32[3] * V2.vector4_f32[3];
end;



function XMVectorMultiplyAdd(V1: TFXMVECTOR; V2: TFXMVECTOR; V3: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := V1.vector4_f32[0] * V2.vector4_f32[0] + V3.vector4_f32[0];
    Result.vector4_f32[1] := V1.vector4_f32[1] * V2.vector4_f32[1] + V3.vector4_f32[1];
    Result.vector4_f32[2] := V1.vector4_f32[2] * V2.vector4_f32[2] + V3.vector4_f32[2];
    Result.vector4_f32[3] := V1.vector4_f32[3] * V2.vector4_f32[3] + V3.vector4_f32[3];
end;



function XMVectorDivide(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := V1.vector4_f32[0] / V2.vector4_f32[0];
    Result.vector4_f32[1] := V1.vector4_f32[1] / V2.vector4_f32[1];
    Result.vector4_f32[2] := V1.vector4_f32[2] / V2.vector4_f32[2];
    Result.vector4_f32[3] := V1.vector4_f32[3] / V2.vector4_f32[3];
end;



function XMVectorNegativeMultiplySubtract(V1: TFXMVECTOR; V2: TFXMVECTOR; V3: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := V3.vector4_f32[0] - (V1.vector4_f32[0] * V2.vector4_f32[0]);
    Result.vector4_f32[1] := V3.vector4_f32[1] - (V1.vector4_f32[1] * V2.vector4_f32[1]);
    Result.vector4_f32[2] := V3.vector4_f32[2] - (V1.vector4_f32[2] * V2.vector4_f32[2]);
    Result.vector4_f32[3] := V3.vector4_f32[3] - (V1.vector4_f32[3] * V2.vector4_f32[3]);
end;



function XMVectorScale(v: TFXMVECTOR; ScaleFactor: single): TXMVECTOR;
begin
    Result.vector4_f32[0] := v.vector4_f32[0] * ScaleFactor;
    Result.vector4_f32[1] := v.vector4_f32[1] * ScaleFactor;
    Result.vector4_f32[2] := v.vector4_f32[2] * ScaleFactor;
    Result.vector4_f32[3] := v.vector4_f32[3] * ScaleFactor;
end;



function XMVectorReciprocalEst(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := 1.0 / v.vector4_f32[0];
    Result.vector4_f32[1] := 1.0 / v.vector4_f32[1];
    Result.vector4_f32[2] := 1.0 / v.vector4_f32[2];
    Result.vector4_f32[3] := 1.0 / v.vector4_f32[3];
end;



function XMVectorReciprocal(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := 1.0 / v.vector4_f32[0];
    Result.vector4_f32[1] := 1.0 / v.vector4_f32[1];
    Result.vector4_f32[2] := 1.0 / v.vector4_f32[2];
    Result.vector4_f32[3] := 1.0 / v.vector4_f32[3];
end;

// Return an estimated square root

function XMVectorSqrtEst(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := sqrt(v.vector4_f32[0]);
    Result.vector4_f32[1] := sqrt(v.vector4_f32[1]);
    Result.vector4_f32[2] := sqrt(v.vector4_f32[2]);
    Result.vector4_f32[3] := sqrt(v.vector4_f32[3]);
end;



function XMVectorSqrt(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := sqrt(v.vector4_f32[0]);
    Result.vector4_f32[1] := sqrt(v.vector4_f32[1]);
    Result.vector4_f32[2] := sqrt(v.vector4_f32[2]);
    Result.vector4_f32[3] := sqrt(v.vector4_f32[3]);
end;



function XMVectorReciprocalSqrtEst(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := 1.0 / sqrt(v.vector4_f32[0]);
    Result.vector4_f32[1] := 1.0 / sqrt(v.vector4_f32[1]);
    Result.vector4_f32[2] := 1.0 / sqrt(v.vector4_f32[2]);
    Result.vector4_f32[3] := 1.0 / sqrt(v.vector4_f32[3]);
end;



function XMVectorReciprocalSqrt(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := 1.0 / sqrt(v.vector4_f32[0]);
    Result.vector4_f32[1] := 1.0 / sqrt(v.vector4_f32[1]);
    Result.vector4_f32[2] := 1.0 / sqrt(v.vector4_f32[2]);
    Result.vector4_f32[3] := 1.0 / sqrt(v.vector4_f32[3]);
end;



function XMVectorExp2(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := Power(2, v.vector4_f32[0]);
    Result.vector4_f32[1] := Power(2, v.vector4_f32[1]);
    Result.vector4_f32[2] := Power(2, v.vector4_f32[2]);
    Result.vector4_f32[3] := Power(2, v.vector4_f32[3]);
end;



function XMVectorExp10(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := Power(10.0, v.vector4_f32[0]);
    Result.vector4_f32[1] := Power(10.0, v.vector4_f32[1]);
    Result.vector4_f32[2] := Power(10.0, v.vector4_f32[2]);
    Result.vector4_f32[3] := Power(10.0, v.vector4_f32[3]);

end;



function XMVectorExpE(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := exp(v.vector4_f32[0]);
    Result.vector4_f32[1] := exp(v.vector4_f32[1]);
    Result.vector4_f32[2] := exp(v.vector4_f32[2]);
    Result.vector4_f32[3] := exp(v.vector4_f32[3]);
end;



function XMVectorExp(v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVectorExp2(v);
end;



function XMVectorLog2(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := log2(v.vector4_f32[0]);
    Result.vector4_f32[1] := log2(v.vector4_f32[1]);
    Result.vector4_f32[2] := log2(v.vector4_f32[2]);
    Result.vector4_f32[3] := log2(v.vector4_f32[3]);
end;



function XMVectorLog10(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := log10(v.vector4_f32[0]);
    Result.vector4_f32[1] := log10(v.vector4_f32[1]);
    Result.vector4_f32[2] := log10(v.vector4_f32[2]);
    Result.vector4_f32[3] := log10(v.vector4_f32[3]);
end;



function XMVectorLogE(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := LN(v.vector4_f32[0]);
    Result.vector4_f32[1] := LN(v.vector4_f32[1]);
    Result.vector4_f32[2] := LN(v.vector4_f32[2]);
    Result.vector4_f32[3] := LN(v.vector4_f32[3]);
end;



function XMVectorLog(v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVectorLog2(v);
end;



function XMVectorPow(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := Power(V1.vector4_f32[0], V2.vector4_f32[0]);
    Result.vector4_f32[1] := Power(V1.vector4_f32[1], V2.vector4_f32[1]);
    Result.vector4_f32[2] := Power(V1.vector4_f32[2], V2.vector4_f32[2]);
    Result.vector4_f32[3] := Power(V1.vector4_f32[3], V2.vector4_f32[3]);
end;



function XMVectorAbs(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := abs(v.vector4_f32[0]);
    Result.vector4_f32[1] := abs(v.vector4_f32[1]);
    Result.vector4_f32[2] := abs(v.vector4_f32[2]);
    Result.vector4_f32[3] := abs(v.vector4_f32[3]);
end;

// V1 % V2 = V1 - V2 * truncate(V1 / V2)

function XMVectorMod(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
var
    Quotient: TXMVECTOR;
begin
    Quotient := XMVectorDivide(V1, V2);
    Quotient := XMVectorTruncate(Quotient);
    Result := XMVectorNegativeMultiplySubtract(V2, Quotient, V1);
end;

// Modulo the range of the given angles such that -XM_PI <= Angles < XM_PI

function XMVectorModAngles(Angles: TFXMVECTOR): TXMVECTOR;
var
    v: TXMVECTOR;
begin
    v := XMVectorMultiply(Angles, g_XMReciprocalTwoPi);
    v := XMVectorRound(v);
    Result := XMVectorNegativeMultiplySubtract(g_XMTwoPi, v, Angles);
end;



function XMVectorSin(v: TFXMVECTOR): TXMVECTOR;
begin
    // 11-degree minimax approximation
    Result.vector4_f32[0] := sin(v.vector4_f32[0]);
    Result.vector4_f32[1] := sin(v.vector4_f32[1]);
    Result.vector4_f32[2] := sin(v.vector4_f32[2]);
    Result.vector4_f32[3] := sin(v.vector4_f32[3]);
end;



function XMVectorSinEst(v: TFXMVECTOR): TXMVECTOR;
begin
    // 7-degree minimax approximation
    Result.vector4_f32[0] := sin(v.vector4_f32[0]);
    Result.vector4_f32[1] := sin(v.vector4_f32[1]);
    Result.vector4_f32[2] := sin(v.vector4_f32[2]);
    Result.vector4_f32[3] := sin(v.vector4_f32[3]);
end;



function XMVectorCos(v: TFXMVECTOR): TXMVECTOR;
begin
    // 10-degree minimax approximation
    Result.vector4_f32[0] := cos(v.vector4_f32[0]);
    Result.vector4_f32[1] := cos(v.vector4_f32[1]);
    Result.vector4_f32[2] := cos(v.vector4_f32[2]);
    Result.vector4_f32[3] := cos(v.vector4_f32[3]);
end;



function XMVectorCosEst(v: TFXMVECTOR): TXMVECTOR;
begin
    // 6-degree minimax approximation
    Result.vector4_f32[0] := cos(v.vector4_f32[0]);
    Result.vector4_f32[1] := cos(v.vector4_f32[1]);
    Result.vector4_f32[2] := cos(v.vector4_f32[2]);
    Result.vector4_f32[3] := cos(v.vector4_f32[3]);
end;



procedure XMVectorSinCos(out pSin: TXMVECTOR; out pCos: TXMVECTOR; v: TFXMVECTOR);
begin
    // 11/10-degree minimax approximation
    pSin.vector4_f32[0] := sin(v.vector4_f32[0]);
    pSin.vector4_f32[1] := sin(v.vector4_f32[1]);
    pSin.vector4_f32[2] := sin(v.vector4_f32[2]);
    pSin.vector4_f32[3] := sin(v.vector4_f32[3]);

    pCos.vector4_f32[0] := cos(v.vector4_f32[0]);
    pCos.vector4_f32[1] := cos(v.vector4_f32[1]);
    pCos.vector4_f32[2] := cos(v.vector4_f32[2]);
    pCos.vector4_f32[3] := cos(v.vector4_f32[3]);
end;



procedure XMVectorSinCosEst(out pSin: TXMVECTOR; out pCos: TXMVECTOR; v: TFXMVECTOR);
begin
    // 7/6-degree minimax approximation
    pSin.vector4_f32[0] := sin(v.vector4_f32[0]);
    pSin.vector4_f32[1] := sin(v.vector4_f32[1]);
    pSin.vector4_f32[2] := sin(v.vector4_f32[2]);
    pSin.vector4_f32[3] := sin(v.vector4_f32[3]);

    pCos.vector4_f32[0] := cos(v.vector4_f32[0]);
    pCos.vector4_f32[1] := cos(v.vector4_f32[1]);
    pCos.vector4_f32[2] := cos(v.vector4_f32[2]);
    pCos.vector4_f32[3] := cos(v.vector4_f32[3]);
end;



function XMVectorTan(v: TFXMVECTOR): TXMVECTOR;
begin
    // Cody and Waite algorithm to compute tangent.
    Result.vector4_f32[0] := tan(v.vector4_f32[0]);
    Result.vector4_f32[1] := tan(v.vector4_f32[1]);
    Result.vector4_f32[2] := tan(v.vector4_f32[2]);
    Result.vector4_f32[3] := tan(v.vector4_f32[3]);
end;



function XMVectorTanEst(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := tan(v.vector4_f32[0]);
    Result.vector4_f32[1] := tan(v.vector4_f32[1]);
    Result.vector4_f32[2] := tan(v.vector4_f32[2]);
    Result.vector4_f32[3] := tan(v.vector4_f32[3]);
end;



function XMVectorSinH(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := sinh(v.vector4_f32[0]);
    Result.vector4_f32[1] := sinh(v.vector4_f32[1]);
    Result.vector4_f32[2] := sinh(v.vector4_f32[2]);
    Result.vector4_f32[3] := sinh(v.vector4_f32[3]);
end;



function XMVectorCosH(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := cosh(v.vector4_f32[0]);
    Result.vector4_f32[1] := cosh(v.vector4_f32[1]);
    Result.vector4_f32[2] := cosh(v.vector4_f32[2]);
    Result.vector4_f32[3] := cosh(v.vector4_f32[3]);
end;



function XMVectorTanH(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := tanh(v.vector4_f32[0]);
    Result.vector4_f32[1] := tanh(v.vector4_f32[1]);
    Result.vector4_f32[2] := tanh(v.vector4_f32[2]);
    Result.vector4_f32[3] := tanh(v.vector4_f32[3]);
end;



function XMVectorASin(v: TFXMVECTOR): TXMVECTOR;
begin
    // 7-degree minimax approximation
    Result.vector4_f32[0] := ArcSin(v.vector4_f32[0]);
    Result.vector4_f32[1] := ArcSin(v.vector4_f32[1]);
    Result.vector4_f32[2] := ArcSin(v.vector4_f32[2]);
    Result.vector4_f32[3] := ArcSin(v.vector4_f32[3]);
end;



function XMVectorASinEst(v: TFXMVECTOR): TXMVECTOR;
begin
    // 3-degree minimax approximation
    Result.vector4_f32[0] := ArcSin(v.vector4_f32[0]);
    Result.vector4_f32[1] := ArcSin(v.vector4_f32[1]);
    Result.vector4_f32[2] := ArcSin(v.vector4_f32[2]);
    Result.vector4_f32[3] := ArcSin(v.vector4_f32[3]);
end;



function XMVectorACos(v: TFXMVECTOR): TXMVECTOR;
begin
    // 7-degree minimax approximation
    Result.vector4_f32[0] := ArcCos(v.vector4_f32[0]);
    Result.vector4_f32[1] := ArcCos(v.vector4_f32[1]);
    Result.vector4_f32[2] := ArcCos(v.vector4_f32[2]);
    Result.vector4_f32[3] := ArcCos(v.vector4_f32[3]);
end;



function XMVectorACosEst(v: TFXMVECTOR): TXMVECTOR;
begin
    // 3-degree minimax approximation
    Result.vector4_f32[0] := ArcCos(v.vector4_f32[0]);
    Result.vector4_f32[1] := ArcCos(v.vector4_f32[1]);
    Result.vector4_f32[2] := ArcCos(v.vector4_f32[2]);
    Result.vector4_f32[3] := ArcCos(v.vector4_f32[3]);
end;



function XMVectorATan(v: TFXMVECTOR): TXMVECTOR;
begin
    // 17-degree minimax approximation
    Result.vector4_f32[0] := ArcTan(v.vector4_f32[0]);
    Result.vector4_f32[1] := ArcTan(v.vector4_f32[1]);
    Result.vector4_f32[2] := ArcTan(v.vector4_f32[2]);
    Result.vector4_f32[3] := ArcTan(v.vector4_f32[3]);
end;



function XMVectorATanEst(v: TFXMVECTOR): TXMVECTOR;
begin
    // 9-degree minimax approximation
    Result.vector4_f32[0] := ArcTan(v.vector4_f32[0]);
    Result.vector4_f32[1] := ArcTan(v.vector4_f32[1]);
    Result.vector4_f32[2] := ArcTan(v.vector4_f32[2]);
    Result.vector4_f32[3] := ArcTan(v.vector4_f32[3]);
end;



function XMVectorATan2(y: TFXMVECTOR; x: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := ArcTan2(y.vector4_f32[0], x.vector4_f32[0]);
    Result.vector4_f32[1] := ArcTan2(y.vector4_f32[1], x.vector4_f32[1]);
    Result.vector4_f32[2] := ArcTan2(y.vector4_f32[2], x.vector4_f32[2]);
    Result.vector4_f32[3] := ArcTan2(y.vector4_f32[3], x.vector4_f32[3]);
end;



function XMVectorATan2Est(y: TFXMVECTOR; x: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := ArcTan2(y.vector4_f32[0], x.vector4_f32[0]);
    Result.vector4_f32[1] := ArcTan2(y.vector4_f32[1], x.vector4_f32[1]);
    Result.vector4_f32[2] := ArcTan2(y.vector4_f32[2], x.vector4_f32[2]);
    Result.vector4_f32[3] := ArcTan2(y.vector4_f32[3], x.vector4_f32[3]);
end;



function XMVectorLerp(V0: TFXMVECTOR; V1: TFXMVECTOR; t: single): TXMVECTOR;
var
    Scale: TXMVECTOR;
    Length: TXMVECTOR;
begin
    // V0 + t * (V1 - V0)
    Scale := XMVectorReplicate(t);
    Length := XMVectorSubtract(V1, V0);
    Result := XMVectorMultiplyAdd(Length, Scale, V0);
end;



function XMVectorLerpV(V0: TFXMVECTOR; V1: TFXMVECTOR; t: TFXMVECTOR): TXMVECTOR;
var
    Length: TXMVECTOR;
begin
    // V0 + T * (V1 - V0)
    Length := XMVectorSubtract(V1, V0);
    Result := XMVectorMultiplyAdd(Length, t, V0);
end;



function XMVectorHermite(Position0: TFXMVECTOR; Tangent0: TFXMVECTOR; Position1: TFXMVECTOR; Tangent1: TGXMVECTOR; t: single): TXMVECTOR;
var
    t2, t3: single;
    P0, P1: TXMVECTOR;
    T0, T1: TXMVECTOR;
begin
    // Result = (2 * t^3 - 3 * t^2 + 1) * Position0 +
    // (t^3 - 2 * t^2 + t) * Tangent0 +
    // (-2 * t^3 + 3 * t^2) * Position1 +
    // (t^3 - t^2) * Tangent1

    t2 := t * t;
    t3 := t * t2;

    P0 := XMVectorReplicate(2.0 * t3 - 3.0 * t2 + 1.0);
    T0 := XMVectorReplicate(t3 - 2.0 * t2 + t);
    P1 := XMVectorReplicate(-2.0 * t3 + 3.0 * t2);
    T1 := XMVectorReplicate(t3 - t2);

    Result := XMVectorMultiply(P0, Position0);
    Result := XMVectorMultiplyAdd(T0, Tangent0, Result);
    Result := XMVectorMultiplyAdd(P1, Position1, Result);
    Result := XMVectorMultiplyAdd(T1, Tangent1, Result);
end;



function XMVectorHermiteV(Position0: TFXMVECTOR; Tangent0: TFXMVECTOR; Position1: TFXMVECTOR; Tangent1: TGXMVECTOR; t: THXMVECTOR): TXMVECTOR;
var
    t2, t3: TXMVECTOR;
    P0, P1: TXMVECTOR;
    T0, T1: TXMVECTOR;
begin
    // Result = (2 * t^3 - 3 * t^2 + 1) * Position0 +
    // (t^3 - 2 * t^2 + t) * Tangent0 +
    // (-2 * t^3 + 3 * t^2) * Position1 +
    // (t^3 - t^2) * Tangent1
    t2 := XMVectorMultiply(t, t);
    t3 := XMVectorMultiply(t, t2);

    P0 := XMVectorReplicate(2.0 * t3.vector4_f32[0] - 3.0 * t2.vector4_f32[0] + 1.0);
    T0 := XMVectorReplicate(t3.vector4_f32[1] - 2.0 * t2.vector4_f32[1] + t.vector4_f32[1]);
    P1 := XMVectorReplicate(-2.0 * t3.vector4_f32[2] + 3.0 * t2.vector4_f32[2]);
    T1 := XMVectorReplicate(t3.vector4_f32[3] - t2.vector4_f32[3]);

    Result := XMVectorMultiply(P0, Position0);
    Result := XMVectorMultiplyAdd(T0, Tangent0, Result);
    Result := XMVectorMultiplyAdd(P1, Position1, Result);
    Result := XMVectorMultiplyAdd(T1, Tangent1, Result);
end;



function XMVectorCatmullRom(Position0: TFXMVECTOR; Position1: TFXMVECTOR; Position2: TFXMVECTOR; Position3: TGXMVECTOR; t: single): TXMVECTOR;
var
    t2, t3: single;
    P0, P1, P2, P3: TXMVECTOR;

begin
    // Result = ((-t^3 + 2 * t^2 - t) * Position0 +
    // (3 * t^3 - 5 * t^2 + 2) * Position1 +
    // (-3 * t^3 + 4 * t^2 + t) * Position2 +
    // (t^3 - t^2) * Position3) * 0.5

    t2 := t * t;
    t3 := t * t2;

    P0 := XMVectorReplicate((-t3 + 2.0 * t2 - t) * 0.5);
    P1 := XMVectorReplicate((3.0 * t3 - 5.0 * t2 + 2.0) * 0.5);
    P2 := XMVectorReplicate((-3.0 * t3 + 4.0 * t2 + t) * 0.5);
    P3 := XMVectorReplicate((t3 - t2) * 0.5);

    Result := XMVectorMultiply(P0, Position0);
    Result := XMVectorMultiplyAdd(P1, Position1, Result);
    Result := XMVectorMultiplyAdd(P2, Position2, Result);
    Result := XMVectorMultiplyAdd(P3, Position3, Result);
end;



function XMVectorCatmullRomV(Position0: TFXMVECTOR; Position1: TFXMVECTOR; Position2: TFXMVECTOR; Position3: TGXMVECTOR; t: THXMVECTOR): TXMVECTOR;
var
    fx, fy, fz, fw: single;
begin
    fx := t.vector4_f32[0];
    fy := t.vector4_f32[1];
    fz := t.vector4_f32[2];
    fw := t.vector4_f32[3];
    Result.vector4_f32[0] := 0.5 * ((-fx * fx * fx + 2 * fx * fx - fx) * Position0.vector4_f32[0] + (3 * fx * fx * fx - 5 * fx * fx + 2) * Position1.vector4_f32[0] + (-3 * fx * fx * fx + 4 * fx * fx + fx) *
        Position2.vector4_f32[0] + (fx * fx * fx - fx * fx) * Position3.vector4_f32[0]);

    Result.vector4_f32[1] := 0.5 * ((-fy * fy * fy + 2 * fy * fy - fy) * Position0.vector4_f32[1] + (3 * fy * fy * fy - 5 * fy * fy + 2) * Position1.vector4_f32[1] + (-3 * fy * fy * fy + 4 * fy * fy + fy) *
        Position2.vector4_f32[1] + (fy * fy * fy - fy * fy) * Position3.vector4_f32[1]);

    Result.vector4_f32[2] := 0.5 * ((-fz * fz * fz + 2 * fz * fz - fz) * Position0.vector4_f32[2] + (3 * fz * fz * fz - 5 * fz * fz + 2) * Position1.vector4_f32[2] + (-3 * fz * fz * fz + 4 * fz * fz + fz) *
        Position2.vector4_f32[2] + (fz * fz * fz - fz * fz) * Position3.vector4_f32[2]);

    Result.vector4_f32[3] := 0.5 * ((-fw * fw * fw + 2 * fw * fw - fw) * Position0.vector4_f32[3] + (3 * fw * fw * fw - 5 * fw * fw + 2) * Position1.vector4_f32[3] + (-3 * fw * fw * fw + 4 * fw * fw + fw) *
        Position2.vector4_f32[3] + (fw * fw * fw - fw * fw) * Position3.vector4_f32[3]);
end;



function XMVectorBaryCentric(Position0: TFXMVECTOR; Position1: TFXMVECTOR; Position2: TFXMVECTOR; f, g: single): TXMVECTOR;
var
    P10, P20: TXMVECTOR;
    ScaleF: TXMVECTOR;
    ScaleG: TXMVECTOR;
begin
    // Result = Position0 + f * (Position1 - Position0) + g * (Position2 - Position0)
    P10 := XMVectorSubtract(Position1, Position0);
    ScaleF := XMVectorReplicate(f);

    P20 := XMVectorSubtract(Position2, Position0);
    ScaleG := XMVectorReplicate(g);

    Result := XMVectorMultiplyAdd(P10, ScaleF, Position0);
    Result := XMVectorMultiplyAdd(P20, ScaleG, Result);
end;



function XMVectorBaryCentricV(Position0: TFXMVECTOR; Position1: TFXMVECTOR; Position2: TFXMVECTOR; f: TGXMVECTOR; g: THXMVECTOR): TXMVECTOR;
var
    P10, P20: TXMVECTOR;
begin
    // Result = Position0 + f * (Position1 - Position0) + g * (Position2 - Position0)
    P10 := XMVectorSubtract(Position1, Position0);
    P20 := XMVectorSubtract(Position2, Position0);

    Result := XMVectorMultiplyAdd(P10, f, Position0);
    Result := XMVectorMultiplyAdd(P20, g, Result);
end;

(* ***************************************************************************
  *
  * 2D Vector
  *
  *************************************************************************** *)

// ------------------------------------------------------------------------------
// Comparison operations
// ------------------------------------------------------------------------------

function XMVector2Equal(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_f32[0] = V2.vector4_f32[0]) and (V1.vector4_f32[1] = V2.vector4_f32[1]));
end;



function XMVector2EqualR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
begin
    Result := 0;
    if ((V1.vector4_f32[0] = V2.vector4_f32[0]) and (V1.vector4_f32[1] = V2.vector4_f32[1])) then
        Result := XM_CRMASK_CR6TRUE
    else if ((V1.vector4_f32[0] <> V2.vector4_f32[0]) and (V1.vector4_f32[1] <> V2.vector4_f32[1])) then
        Result := XM_CRMASK_CR6FALSE;
end;



function XMVector2EqualInt(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_u32[0] = V2.vector4_u32[0]) and (V1.vector4_u32[1] = V2.vector4_u32[1]));
end;



function XMVector2EqualIntR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
begin
    Result := 0;
    if ((V1.vector4_u32[0] = V2.vector4_u32[0]) and (V1.vector4_u32[1] = V2.vector4_u32[1])) then
        Result := XM_CRMASK_CR6TRUE
    else if ((V1.vector4_u32[0] <> V2.vector4_u32[0]) and (V1.vector4_u32[1] <> V2.vector4_u32[1])) then
        Result := XM_CRMASK_CR6FALSE;
end;



function XMVector2NearEqual(V1: TFXMVECTOR; V2: TFXMVECTOR; Epsilon: TFXMVECTOR): boolean;
var
    dx, dy: single;
begin
    dx := abs(V1.vector4_f32[0] - V2.vector4_f32[0]);
    dy := abs(V1.vector4_f32[1] - V2.vector4_f32[1]);
    Result := ((dx <= Epsilon.vector4_f32[0]) and (dy <= Epsilon.vector4_f32[1]));
end;



function XMVector2NotEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_f32[0] <> V2.vector4_f32[0]) or (V1.vector4_f32[1] <> V2.vector4_f32[1]));
end;



function XMVector2NotEqualInt(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_u32[0] <> V2.vector4_u32[0]) or (V1.vector4_u32[1] <> V2.vector4_u32[1]));
end;



function XMVector2Greater(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_f32[0] > V2.vector4_f32[0]) and (V1.vector4_f32[1] > V2.vector4_f32[1]));
end;



function XMVector2GreaterR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
begin
    Result := 0;
    if ((V1.vector4_f32[0] > V2.vector4_f32[0]) and (V1.vector4_f32[1] > V2.vector4_f32[1])) then
        Result := XM_CRMASK_CR6TRUE
    else if ((V1.vector4_f32[0] <= V2.vector4_f32[0]) and (V1.vector4_f32[1] <= V2.vector4_f32[1])) then
        Result := XM_CRMASK_CR6FALSE;
end;



function XMVector2GreaterOrEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_f32[0] >= V2.vector4_f32[0]) and (V1.vector4_f32[1] >= V2.vector4_f32[1]));
end;



function XMVector2GreaterOrEqualR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
begin
    Result := 0;
    if ((V1.vector4_f32[0] >= V2.vector4_f32[0]) and (V1.vector4_f32[1] >= V2.vector4_f32[1])) then
        Result := XM_CRMASK_CR6TRUE
    else if ((V1.vector4_f32[0] < V2.vector4_f32[0]) and (V1.vector4_f32[1] < V2.vector4_f32[1])) then
        Result := XM_CRMASK_CR6FALSE;
end;



function XMVector2Less(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_f32[0] < V2.vector4_f32[0]) and (V1.vector4_f32[1] < V2.vector4_f32[1]));
end;



function XMVector2LessOrEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_f32[0] <= V2.vector4_f32[0]) and (V1.vector4_f32[1] <= V2.vector4_f32[1]));
end;



function XMVector2InBounds(v: TFXMVECTOR; Bounds: TFXMVECTOR): boolean;
begin
    Result := ((v.vector4_f32[0] <= Bounds.vector4_f32[0]) and (v.vector4_f32[0] >= -Bounds.vector4_f32[0]) and (v.vector4_f32[1] <= Bounds.vector4_f32[1]) and (v.vector4_f32[1] >= -Bounds.vector4_f32[1]));
end;



function XMVector2IsNaN(v: TFXMVECTOR): boolean;
begin
    Result := (XMISNAN(v.vector4_f32[0]) or XMISNAN(v.vector4_f32[1]));
end;



function XMVector2IsInfinite(v: TFXMVECTOR): boolean;
begin
    Result := (XMISINF(v.vector4_f32[0]) or XMISINF(v.vector4_f32[1]));
end;

// ------------------------------------------------------------------------------
// Computation operations
// ------------------------------------------------------------------------------

function XMVector2Dot(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    Result.f[0] := V1.vector4_f32[0] * V2.vector4_f32[0] + V1.vector4_f32[1] * V2.vector4_f32[1];
    Result.f[1] := Result.f[0];
    Result.f[2] := Result.f[0];
    Result.f[3] := Result.f[0];
end;



function XMVector2Cross(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
var
    fCross: single;
begin
    // [ V1.x*V2.y - V1.y*V2.x, V1.x*V2.y - V1.y*V2.x ]
    fCross := (V1.vector4_f32[0] * V2.vector4_f32[1]) - (V1.vector4_f32[1] * V2.vector4_f32[0]);
    Result.f[0] := fCross;
    Result.f[1] := fCross;
    Result.f[2] := fCross;
    Result.f[3] := fCross;
end;



function XMVector2LengthSq(v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector2Dot(v, v);
end;



function XMVector2ReciprocalLengthEst(v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector2LengthSq(v);
    Result := XMVectorReciprocalSqrtEst(Result);
end;



function XMVector2ReciprocalLength(v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector2LengthSq(v);
    Result := XMVectorReciprocalSqrt(Result);
end;



function XMVector2LengthEst(v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector2LengthSq(v);
    Result := XMVectorSqrtEst(Result);
end;



function XMVector2Length(v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector2LengthSq(v);
    Result := XMVectorSqrt(Result);
end;

// XMVector2NormalizeEst uses a reciprocal estimate and
// returns QNaN on zero and infinite vectors.
function XMVector2NormalizeEst(v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector2ReciprocalLength(v);
    Result := XMVectorMultiply(v, Result);
end;



function XMVector2Normalize(v: TFXMVECTOR): TXMVECTOR;
var
    fLength: single;
begin
    Result := XMVector2Length(v);
    fLength := Result.vector4_f32[0];

    // Prevent divide by zero
    if (fLength > 0) then
        fLength := 1.0 / fLength;

    Result.vector4_f32[0] := v.vector4_f32[0] * fLength;
    Result.vector4_f32[1] := v.vector4_f32[1] * fLength;
    Result.vector4_f32[2] := v.vector4_f32[2] * fLength;
    Result.vector4_f32[3] := v.vector4_f32[3] * fLength;
end;



function XMVector2ClampLength(v: TFXMVECTOR; LengthMin, LengthMax: single): TXMVECTOR;
var
    ClampMax, ClampMin: TXMVECTOR;
begin
    ClampMax := XMVectorReplicate(LengthMax);
    ClampMin := XMVectorReplicate(LengthMin);
    Result := XMVector2ClampLengthV(v, ClampMin, ClampMax);
end;



function XMVector2ClampLengthV(v: TFXMVECTOR; LengthMin: TFXMVECTOR; LengthMax: TFXMVECTOR): TXMVECTOR;
var
    LengthSq: TXMVECTOR;
    RcpLength: TXMVECTOR;
    InfiniteLength: TXMVECTOR;
    ZeroLength: TXMVECTOR;
    Length: TXMVECTOR;
    Normal: TXMVECTOR;
    Select: TXMVECTOR;
    ControlMax, ControlMin: TXMVECTOR;
    ClampLength: TXMVECTOR;
    Control: TXMVECTOR;
begin
{$IFDEF WithAssert}
    assert((XMVectorGetY(LengthMin) = XMVectorGetX(LengthMin)));
    assert((XMVectorGetY(LengthMax) = XMVectorGetX(LengthMax)));
    assert(XMVector2GreaterOrEqual(LengthMin, g_XMZero));
    assert(XMVector2GreaterOrEqual(LengthMax, g_XMZero));
    assert(XMVector2GreaterOrEqual(LengthMax, LengthMin));
{$ENDIF}
    LengthSq := XMVector2LengthSq(v);
    RcpLength := XMVectorReciprocalSqrt(LengthSq);
    InfiniteLength := XMVectorEqualInt(LengthSq, g_XMInfinity);
    ZeroLength := XMVectorEqual(LengthSq, g_XMZero);
    Length := XMVectorMultiply(LengthSq, RcpLength);
    Normal := XMVectorMultiply(v, RcpLength);
    Select := XMVectorEqualInt(InfiniteLength, ZeroLength);
    Length := XMVectorSelect(LengthSq, Length, Select);
    Normal := XMVectorSelect(LengthSq, Normal, Select);
    ControlMax := XMVectorGreater(Length, LengthMax);
    ControlMin := XMVectorLess(Length, LengthMin);
    ClampLength := XMVectorSelect(Length, LengthMax, ControlMax);
    ClampLength := XMVectorSelect(ClampLength, LengthMin, ControlMin);
    Result := XMVectorMultiply(Normal, ClampLength);
    // Preserve the original vector (with no precision loss) if the length falls within the given range
    Control := XMVectorEqualInt(ControlMax, ControlMin);
    Result := XMVectorSelect(Result, v, Control);
end;



function XMVector2Reflect(Incident: TFXMVECTOR; Normal: TFXMVECTOR): TXMVECTOR;
begin
    // Result = Incident - (2 * dot(Incident, Normal)) * Normal
    Result := XMVector2Dot(Incident, Normal);
    Result := XMVectorAdd(Result, Result);
    Result := XMVectorNegativeMultiplySubtract(Result, Normal, Incident);
end;



function XMVector2Refract(Incident: TFXMVECTOR; Normal: TFXMVECTOR; RefractionIndex: single): TXMVECTOR;
var
    Index: TXMVECTOR;
begin
    Index := XMVectorReplicate(RefractionIndex);
    Result := XMVector2RefractV(Incident, Normal, Index);
end;

// Return the refraction of a 2D vector

function XMVector2RefractV(Incident: TFXMVECTOR; Normal: TFXMVECTOR; RefractionIndex: TFXMVECTOR): TXMVECTOR;
var
    IDotN: single;
    RY, RX: single;
begin
    // Result = RefractionIndex * Incident - Normal * (RefractionIndex * dot(Incident, Normal) +
    // sqrt(1 - RefractionIndex * RefractionIndex * (1 - dot(Incident, Normal) * dot(Incident, Normal))))
    IDotN := (Incident.vector4_f32[0] * Normal.vector4_f32[0]) + (Incident.vector4_f32[1] * Normal.vector4_f32[1]);
    // R = 1.0f - RefractionIndex * RefractionIndex * (1.0f - IDotN * IDotN)
    RY := 1.0 - (IDotN * IDotN);
    RX := 1.0 - (RY * RefractionIndex.vector4_f32[0] * RefractionIndex.vector4_f32[0]);
    RY := 1.0 - (RY * RefractionIndex.vector4_f32[1] * RefractionIndex.vector4_f32[1]);
    if (RX >= 0.0) then
        RX := (RefractionIndex.vector4_f32[0] * Incident.vector4_f32[0]) - (Normal.vector4_f32[0] * ((RefractionIndex.vector4_f32[0] * IDotN) + sqrt(RX)))
    else
        RX := 0.0;

    if (RY >= 0.0) then
        RY := (RefractionIndex.vector4_f32[1] * Incident.vector4_f32[1]) - (Normal.vector4_f32[1] * ((RefractionIndex.vector4_f32[1] * IDotN) + sqrt(RY)))
    else
        RY := 0.0;

    Result.vector4_f32[0] := RX;
    Result.vector4_f32[1] := RY;
    Result.vector4_f32[2] := 0.0;
    Result.vector4_f32[3] := 0.0;
end;



function XMVector2Orthogonal(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := -v.vector4_f32[1];
    Result.vector4_f32[0] := v.vector4_f32[0];
    Result.vector4_f32[0] := 0.0;
    Result.vector4_f32[0] := 0.0;
end;



function XMVector2AngleBetweenNormalsEst(N1: TFXMVECTOR; N2: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector2Dot(N1, N2);
    Result := XMVectorClamp(Result, g_XMNegativeOne, g_XMOne);
    Result := XMVectorACosEst(Result);
end;



function XMVector2AngleBetweenNormals(N1: TFXMVECTOR; N2: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector2Dot(N1, N2);
    Result := XMVectorClamp(Result, g_XMNegativeOne, g_XMOne);
    Result := XMVectorACos(Result);
end;



function XMVector2AngleBetweenVectors(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
var
    L1, L2: TXMVECTOR;
    Dot: TXMVECTOR;
    CosAngle: TXMVECTOR;
begin
    L1 := XMVector2ReciprocalLength(V1);
    L2 := XMVector2ReciprocalLength(V2);

    Dot := XMVector2Dot(V1, V2);

    L1 := XMVectorMultiply(L1, L2);

    CosAngle := XMVectorMultiply(Dot, L1);
    CosAngle := XMVectorClamp(CosAngle, g_XMNegativeOne, g_XMOne);

    Result := XMVectorACos(CosAngle);
end;



function XMVector2LinePointDistance(LinePoint1: TFXMVECTOR; LinePoint2: TFXMVECTOR; Point: TFXMVECTOR): TXMVECTOR;
var
    PointVector: TXMVECTOR;
    LineVector: TXMVECTOR;
    LengthSq: TXMVECTOR;
    PointProjectionScale: TXMVECTOR;
    DistanceVector: TXMVECTOR;
begin
    // Given a vector PointVector from LinePoint1 to Point and a vector
    // LineVector from LinePoint1 to LinePoint2, the scaled distance
    // PointProjectionScale from LinePoint1 to the perpendicular projection
    // of PointVector onto the line is defined as:

    // PointProjectionScale = dot(PointVector, LineVector) / LengthSq(LineVector)

    PointVector := XMVectorSubtract(Point, LinePoint1);
    LineVector := XMVectorSubtract(LinePoint2, LinePoint1);

    LengthSq := XMVector2LengthSq(LineVector);

    PointProjectionScale := XMVector2Dot(PointVector, LineVector);
    PointProjectionScale := XMVectorDivide(PointProjectionScale, LengthSq);

    DistanceVector := XMVectorMultiply(LineVector, PointProjectionScale);
    DistanceVector := XMVectorSubtract(PointVector, DistanceVector);

    Result := XMVector2Length(DistanceVector);
end;



function XMVector2IntersectLine(Line1Point1: TFXMVECTOR; Line1Point2: TFXMVECTOR; Line2Point1: TFXMVECTOR; Line2Point2: TGXMVECTOR): TXMVECTOR;
var
    V1, V2, V3: TXMVECTOR;
    C1, C2: TXMVECTOR;
    Scale: TXMVECTOR;
begin
    V1 := XMVectorSubtract(Line1Point2, Line1Point1);
    V2 := XMVectorSubtract(Line2Point2, Line2Point1);
    V3 := XMVectorSubtract(Line1Point1, Line2Point1);

    C1 := XMVector2Cross(V1, V2);
    C2 := XMVector2Cross(V2, V3);

    if (XMVector2NearEqual(C1, g_XMZero, g_XMEpsilon)) then
    begin
        if (XMVector2NearEqual(C2, g_XMZero, g_XMEpsilon)) then
        begin
            // Coincident
            Result := g_XMInfinity;
        end
        else
        begin
            // Parallel
            Result := g_XMQNaN;
        end;
    end
    else
    begin
        // Intersection point = Line1Point1 + V1 * (C2 / C1)
        Scale := XMVectorReciprocal(C1);
        Scale := XMVectorMultiply(C2, Scale);
        Result := XMVectorMultiplyAdd(V1, Scale, Line1Point1);
    end;
end;



function XMVector2Transform(v: TFXMVECTOR; m: TFXMMATRIX): TXMVECTOR;
var
    x, y: TXMVECTOR;
begin
    y := XMVectorSplatY(v);
    x := XMVectorSplatX(v);

    Result := XMVectorMultiplyAdd(y, m.r[1], m.r[3]);
    Result := XMVectorMultiplyAdd(x, m.r[0], Result);
end;



function XMVector2TransformStream(var pOutputStream: PXMFLOAT4; OutputStride: size_t; const pInputStream: PXMFLOAT2; InputStride: size_t; VectorCount: size_t; m: TFXMMATRIX): PXMFLOAT4;
var
    row0, row1, row3: TXMVECTOR;
    i: integer;
    v, y, x: TXMVECTOR;
    pInputVector: pbyte;
    pOutputVector: pbyte;
    vResult: TXMVECTOR;
begin
{$IFDEF WithAssert}
    assert(pOutputStream <> nil);
    assert(pInputStream <> nil);
    assert(InputStride >= sizeofT(XMFLOAT2));
    assert(OutputStride >= sizeof(TXMFLOAT4));
{$ENDIF}
    pInputVector := pbyte(pInputStream);
    pOutputVector := pbyte(pOutputStream);

    row0 := m.r[0];
    row1 := m.r[1];
    row3 := m.r[3];

    for i := 0 to VectorCount - 1 do
    begin
        v := XMLoadFloat2(PXMFLOAT2(pInputVector));
        y := XMVectorSplatY(v);
        x := XMVectorSplatX(v);
        vResult := XMVectorMultiplyAdd(y, row1, row3);
        vResult := XMVectorMultiplyAdd(x, row0, vResult);
        XMStoreFloat4(PXMFLOAT4(pOutputVector)^, vResult);
        pInputVector := pInputVector + InputStride;
        pOutputVector := pOutputVector + OutputStride;
    end;
    Result := pOutputStream;
end;



function XMVector2TransformCoord(v: TFXMVECTOR; m: TFXMMATRIX): TXMVECTOR;
var
    x, y, w: TXMVECTOR;
begin
    y := XMVectorSplatY(v);
    x := XMVectorSplatX(v);

    Result := XMVectorMultiplyAdd(y, m.r[1], m.r[3]);
    Result := XMVectorMultiplyAdd(x, m.r[0], Result);

    w := XMVectorSplatW(Result);
    Result := XMVectorDivide(Result, w);
end;



function XMVector2TransformCoordStream(var pOutputStream: PXMFLOAT2; OutputStride: size_t; const pInputStream: PXMFLOAT2; InputStride: size_t; VectorCount: size_t; m: TFXMMATRIX): PXMFLOAT2;
var
    pInputVector: pbyte;
    pOutputVector: pbyte;
    row0, row1, row3: TXMVECTOR;
    i: integer;
    vResult: TXMVECTOR;
    v, y, x, w: TXMVECTOR;
begin
    pInputVector := pbyte(pInputStream);
    pOutputVector := pbyte(pOutputStream);

    row0 := m.r[0];
    row1 := m.r[1];
    row3 := m.r[3];

    for i := 0 to VectorCount - 1 do
    begin
        v := XMLoadFloat2(PXMFLOAT2(pInputVector));
        y := XMVectorSplatY(v);
        x := XMVectorSplatX(v);
        vResult := XMVectorMultiplyAdd(y, row1, row3);
        vResult := XMVectorMultiplyAdd(x, row0, vResult);
        w := XMVectorSplatW(vResult);
        vResult := XMVectorDivide(vResult, w);
        XMStoreFloat2(PXMFLOAT2(pOutputVector), vResult);
        pInputVector := pInputVector + InputStride;
        pOutputVector := pOutputVector + OutputStride;
    end;
    Result := pOutputStream;
end;



function XMVector2TransformNormal(v: TFXMVECTOR; m: TFXMMATRIX): TXMVECTOR;
var
    x, y: TXMVECTOR;
begin
    y := XMVectorSplatY(v);
    x := XMVectorSplatX(v);

    Result := XMVectorMultiply(y, m.r[1]);
    Result := XMVectorMultiplyAdd(x, m.r[0], Result);
end;



function XMVector2TransformNormalStream(var pOutputStream: PXMFLOAT2; OutputStride: size_t; const pInputStream: PXMFLOAT2; InputStride: size_t; VectorCount: size_t; m: TFXMMATRIX): PXMFLOAT2;
var
    pInputVector: pbyte;
    pOutputVector: pbyte;
    row0, row1: TXMVECTOR;
    i: integer;
    v, x, y: TXMVECTOR;
    vResult: TXMVECTOR;
begin
    pInputVector := pbyte(pInputStream);
    pOutputVector := pbyte(pOutputStream);

    row0 := m.r[0];
    row1 := m.r[1];

    for i := 0 to VectorCount - 1 do
    begin
        v := XMLoadFloat2(PXMFLOAT2(pInputVector));
        y := XMVectorSplatY(v);
        x := XMVectorSplatX(v);
        vResult := XMVectorMultiply(y, row1);
        vResult := XMVectorMultiplyAdd(x, row0, vResult);
        XMStoreFloat2(PXMFLOAT2(pOutputVector), vResult);
        pInputVector := pInputVector + InputStride;
        pOutputVector := pOutputVector + OutputStride;
    end;
    Result := pOutputStream;
end;

(* ***************************************************************************
  *
  * 3D Vector
  *
  *************************************************************************** *)

// ------------------------------------------------------------------------------
// Comparison operations
// ------------------------------------------------------------------------------

function XMVector3Equal(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_f32[0] = V2.vector4_f32[0]) and (V1.vector4_f32[1] = V2.vector4_f32[1]) and (V1.vector4_f32[2] = V2.vector4_f32[2]));
end;



function XMVector3EqualR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
begin
    Result := 0;
    if ((V1.vector4_f32[0] = V2.vector4_f32[0]) and (V1.vector4_f32[1] = V2.vector4_f32[1]) and (V1.vector4_f32[2] = V2.vector4_f32[2])) then
        Result := XM_CRMASK_CR6TRUE
    else if ((V1.vector4_f32[0] <> V2.vector4_f32[0]) and (V1.vector4_f32[1] <> V2.vector4_f32[1]) and (V1.vector4_f32[2] <> V2.vector4_f32[2])) then
        Result := XM_CRMASK_CR6FALSE;

end;



function XMVector3EqualInt(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_u32[0] = V2.vector4_u32[0]) and (V1.vector4_u32[1] = V2.vector4_u32[1]) and (V1.vector4_u32[2] = V2.vector4_u32[2]));
end;



function XMVector3EqualIntR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
begin
    Result := 0;
    if ((V1.vector4_u32[0] = V2.vector4_u32[0]) and (V1.vector4_u32[1] = V2.vector4_u32[1]) and (V1.vector4_u32[2] = V2.vector4_u32[2])) then
        Result := XM_CRMASK_CR6TRUE
    else if ((V1.vector4_u32[0] <> V2.vector4_u32[0]) and (V1.vector4_u32[1] <> V2.vector4_u32[1]) and (V1.vector4_u32[2] <> V2.vector4_u32[2])) then
        Result := XM_CRMASK_CR6FALSE;
end;



function XMVector3NearEqual(V1: TFXMVECTOR; V2: TFXMVECTOR; Epsilon: TFXMVECTOR): boolean;
var
    dx, dy, dz: single;
begin
    dx := abs(V1.vector4_f32[0] - V2.vector4_f32[0]);
    dy := abs(V1.vector4_f32[1] - V2.vector4_f32[1]);
    dz := abs(V1.vector4_f32[2] - V2.vector4_f32[2]);
    Result := ((dx <= Epsilon.vector4_f32[0]) and (dy <= Epsilon.vector4_f32[1]) and (dz <= Epsilon.vector4_f32[2]));
end;



function XMVector3NotEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_f32[0] <> V2.vector4_f32[0]) or (V1.vector4_f32[1] <> V2.vector4_f32[1]) or (V1.vector4_f32[2] <> V2.vector4_f32[2]));
end;



function XMVector3NotEqualInt(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_u32[0] <> V2.vector4_u32[0]) or (V1.vector4_u32[1] <> V2.vector4_u32[1]) or (V1.vector4_u32[2] <> V2.vector4_u32[2]));
end;



function XMVector3Greater(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_f32[0] > V2.vector4_f32[0]) and (V1.vector4_f32[1] > V2.vector4_f32[1]) and (V1.vector4_f32[2] > V2.vector4_f32[2]));
end;



function XMVector3GreaterR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
begin
    Result := 0;
    if ((V1.vector4_f32[0] > V2.vector4_f32[0]) and (V1.vector4_f32[1] > V2.vector4_f32[1]) and (V1.vector4_f32[2] > V2.vector4_f32[2])) then
        Result := XM_CRMASK_CR6TRUE
    else if ((V1.vector4_f32[0] <= V2.vector4_f32[0]) and (V1.vector4_f32[1] <= V2.vector4_f32[1]) and (V1.vector4_f32[2] <= V2.vector4_f32[2])) then
        Result := XM_CRMASK_CR6FALSE;
end;



function XMVector3GreaterOrEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_f32[0] >= V2.vector4_f32[0]) and (V1.vector4_f32[1] >= V2.vector4_f32[1]) and (V1.vector4_f32[2] >= V2.vector4_f32[2]));
end;



function XMVector3GreaterOrEqualR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
begin
    Result := 0;
    if ((V1.vector4_f32[0] >= V2.vector4_f32[0]) and (V1.vector4_f32[1] >= V2.vector4_f32[1]) and (V1.vector4_f32[2] >= V2.vector4_f32[2])) then
        Result := XM_CRMASK_CR6TRUE
    else if ((V1.vector4_f32[0] < V2.vector4_f32[0]) and (V1.vector4_f32[1] < V2.vector4_f32[1]) and (V1.vector4_f32[2] < V2.vector4_f32[2])) then
        Result := XM_CRMASK_CR6FALSE;
end;



function XMVector3Less(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_f32[0] < V2.vector4_f32[0]) and (V1.vector4_f32[1] < V2.vector4_f32[1]) and (V1.vector4_f32[2] < V2.vector4_f32[2]));
end;



function XMVector3LessOrEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_f32[0] <= V2.vector4_f32[0]) and (V1.vector4_f32[1] <= V2.vector4_f32[1]) and (V1.vector4_f32[2] <= V2.vector4_f32[2]));
end;



function XMVector3InBounds(v: TFXMVECTOR; Bounds: TFXMVECTOR): boolean;
begin
    Result := ((v.vector4_f32[0] <= Bounds.vector4_f32[0]) and (v.vector4_f32[0] >= -Bounds.vector4_f32[0]) and (v.vector4_f32[1] <= Bounds.vector4_f32[1]) and (v.vector4_f32[1] >= -Bounds.vector4_f32[1]) and
        (v.vector4_f32[2] <= Bounds.vector4_f32[2]) and (v.vector4_f32[2] >= -Bounds.vector4_f32[2]));

end;



function XMVector3IsNaN(v: TFXMVECTOR): boolean;
begin
    Result := (XMISNAN(v.vector4_f32[0]) or XMISNAN(v.vector4_f32[1]) or XMISNAN(v.vector4_f32[2]));
end;



function XMVector3IsInfinite(v: TFXMVECTOR): boolean;
begin
    Result := (XMISINF(v.vector4_f32[0]) or XMISINF(v.vector4_f32[1]) or XMISINF(v.vector4_f32[2]));
end;

// ------------------------------------------------------------------------------
// Computation operations
// ------------------------------------------------------------------------------

function XMVector3Dot(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
var
    fValue: single;
begin
    fValue := V1.vector4_f32[0] * V2.vector4_f32[0] + V1.vector4_f32[1] * V2.vector4_f32[1] + V1.vector4_f32[2] * V2.vector4_f32[2];
    Result.f[0] := fValue;
    Result.f[1] := fValue;
    Result.f[2] := fValue;
    Result.f[3] := fValue;
end;



function XMVector3Cross(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    // [ V1.y*V2.z - V1.z*V2.y, V1.z*V2.x - V1.x*V2.z, V1.x*V2.y - V1.y*V2.x ]
    Result.vector4_f32[0] := (V1.vector4_f32[1] * V2.vector4_f32[2]) - (V1.vector4_f32[2] * V2.vector4_f32[1]);
    Result.vector4_f32[1] := (V1.vector4_f32[2] * V2.vector4_f32[0]) - (V1.vector4_f32[0] * V2.vector4_f32[2]);
    Result.vector4_f32[2] := (V1.vector4_f32[0] * V2.vector4_f32[1]) - (V1.vector4_f32[1] * V2.vector4_f32[0]);
    Result.vector4_f32[3] := 0.0;
end;



function XMVector3LengthSq(v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector3Dot(v, v);
end;



function XMVector3ReciprocalLengthEst(v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector3LengthSq(v);
    Result := XMVectorReciprocalSqrtEst(Result);
end;



function XMVector3ReciprocalLength(v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector3LengthSq(v);
    Result := XMVectorReciprocalSqrt(Result);
end;



function XMVector3LengthEst(v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector3LengthSq(v);
    Result := XMVectorSqrtEst(Result);
end;



function XMVector3Length(v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector3LengthSq(v);
    Result := XMVectorSqrt(Result);
end;

// XMVector3NormalizeEst uses a reciprocal estimate and
// returns QNaN on zero and infinite vectors.
function XMVector3NormalizeEst(v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector3ReciprocalLength(v);
    Result := XMVectorMultiply(v, Result);
end;



function XMVector3Normalize(v: TFXMVECTOR): TXMVECTOR;
var
    fLength: single;
begin
    Result := XMVector3Length(v);
    fLength := Result.vector4_f32[0];

    // Prevent divide by zero
    if (fLength > 0) then
        fLength := 1.0 / fLength;

    Result.vector4_f32[0] := v.vector4_f32[0] * fLength;
    Result.vector4_f32[1] := v.vector4_f32[1] * fLength;
    Result.vector4_f32[2] := v.vector4_f32[2] * fLength;
    Result.vector4_f32[3] := v.vector4_f32[3] * fLength;
end;



function XMVector3ClampLength(v: TFXMVECTOR; LengthMin, LengthMax: single): TXMVECTOR;
var
    ClampMin, ClampMax: TXMVECTOR;
begin
    ClampMax := XMVectorReplicate(LengthMax);
    ClampMin := XMVectorReplicate(LengthMin);

    Result := XMVector3ClampLengthV(v, ClampMin, ClampMax);
end;



function XMVector3ClampLengthV(v: TFXMVECTOR; LengthMin: TFXMVECTOR; LengthMax: TFXMVECTOR): TXMVECTOR;
var
    LengthSq, RcpLength, InfiniteLength, ZeroLength: TXMVECTOR;
    Normal, Length, Select: TXMVECTOR;
    ControlMin, ControlMax, ClampLength, Control: TXMVECTOR;
begin
    LengthSq := XMVector3LengthSq(v);
    RcpLength := XMVectorReciprocalSqrt(LengthSq);
    InfiniteLength := XMVectorEqualInt(LengthSq, g_XMInfinity);
    ZeroLength := XMVectorEqual(LengthSq, g_XMZero);

    Normal := XMVectorMultiply(v, RcpLength);
    Length := XMVectorMultiply(LengthSq, RcpLength);
    Select := XMVectorEqualInt(InfiniteLength, ZeroLength);
    Length := XMVectorSelect(LengthSq, Length, Select);
    Normal := XMVectorSelect(LengthSq, Normal, Select);

    ControlMax := XMVectorGreater(Length, LengthMax);
    ControlMin := XMVectorLess(Length, LengthMin);

    ClampLength := XMVectorSelect(Length, LengthMax, ControlMax);
    ClampLength := XMVectorSelect(ClampLength, LengthMin, ControlMin);

    Result := XMVectorMultiply(Normal, ClampLength);

    // Preserve the original vector (with no precision loss) if the length falls within the given range
    Control := XMVectorEqualInt(ControlMax, ControlMin);
    Result := XMVectorSelect(Result, v, Control);
end;



function XMVector3Reflect(Incident: TFXMVECTOR; Normal: TFXMVECTOR): TXMVECTOR;
begin
    // Result = Incident - (2 * dot(Incident, Normal)) * Normal

    Result := XMVector3Dot(Incident, Normal);
    Result := XMVectorAdd(Result, Result);
    Result := XMVectorNegativeMultiplySubtract(Result, Normal, Incident);
end;



function XMVector3Refract(Incident: TFXMVECTOR; Normal: TFXMVECTOR; RefractionIndex: single): TXMVECTOR;
var
    Index: TXMVECTOR;
begin
    Index := XMVectorReplicate(RefractionIndex);
    Result := XMVector3RefractV(Incident, Normal, Index);
end;



function XMVector3RefractV(Incident: TFXMVECTOR; Normal: TFXMVECTOR; RefractionIndex: TFXMVECTOR): TXMVECTOR;
var
    IDotN: TXMVECTOR;
    r: TXMVECTOR;
begin
    // Result = RefractionIndex * Incident - Normal * (RefractionIndex * dot(Incident, Normal) +
    // sqrt(1 - RefractionIndex * RefractionIndex * (1 - dot(Incident, Normal) * dot(Incident, Normal))))

    IDotN := XMVector3Dot(Incident, Normal);

    // R = 1.0f - RefractionIndex * RefractionIndex * (1.0f - IDotN * IDotN)
    r := XMVectorNegativeMultiplySubtract(IDotN, IDotN, g_XMOne);
    r := XMVectorMultiply(r, RefractionIndex);
    r := XMVectorNegativeMultiplySubtract(r, RefractionIndex, g_XMOne);

    if (XMVector4LessOrEqual(r, g_XMZero)) then
        // Total internal reflection
        Result := g_XMZero
    else
    begin
        // R = RefractionIndex * IDotN + sqrt(R)
        r := XMVectorSqrt(r);
        r := XMVectorMultiplyAdd(RefractionIndex, IDotN, r);

        // Result = RefractionIndex * Incident - Normal * R
        Result := XMVectorMultiply(RefractionIndex, Incident);
        Result := XMVectorNegativeMultiplySubtract(Normal, r, Result);
    end;
end;



function XMVector3Orthogonal(v: TFXMVECTOR): TXMVECTOR;
var
    z, YZYY: TXMVECTOR;
    NegativeV, ZIsNegative, YZYYIsNegative: TXMVECTOR;
    s, D, r0, r1: TXMVECTOR;
    Select: TXMVECTOR;
begin
    z := XMVectorSplatZ(v);
    YZYY := XMVectorSwizzle(XM_SWIZZLE_Y, XM_SWIZZLE_Z, XM_SWIZZLE_Y, XM_SWIZZLE_Y, v);

    NegativeV := XMVectorSubtract(g_XMZero, v);

    ZIsNegative := XMVectorLess(z, g_XMZero);
    YZYYIsNegative := XMVectorLess(YZYY, g_XMZero);

    s := XMVectorAdd(YZYY, z);
    D := XMVectorSubtract(YZYY, z);

    Select := XMVectorEqualInt(ZIsNegative, YZYYIsNegative);

    r0 := XMVectorPermute(XM_PERMUTE_1X, XM_PERMUTE_0X, XM_PERMUTE_0X, XM_PERMUTE_0X, NegativeV, s);
    r1 := XMVectorPermute(XM_PERMUTE_1X, XM_PERMUTE_0X, XM_PERMUTE_0X, XM_PERMUTE_0X, v, D);

    Result := XMVectorSelect(r1, r0, Select);
end;



function XMVector3AngleBetweenNormalsEst(N1: TFXMVECTOR; N2: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector3Dot(N1, N2);
    Result := XMVectorClamp(Result, g_XMNegativeOne, g_XMOne);
    Result := XMVectorACosEst(Result);
end;



function XMVector3AngleBetweenNormals(N1: TFXMVECTOR; N2: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector3Dot(N1, N2);
    Result := XMVectorClamp(Result, g_XMNegativeOne, g_XMOne);
    Result := XMVectorACos(Result);
end;



function XMVector3AngleBetweenVectors(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
var
    L1, L2, Dot, CosAngle: TXMVECTOR;
begin
    L1 := XMVector3ReciprocalLength(V1);
    L2 := XMVector3ReciprocalLength(V2);

    Dot := XMVector3Dot(V1, V2);

    L1 := XMVectorMultiply(L1, L2);

    CosAngle := XMVectorMultiply(Dot, L1);
    CosAngle := XMVectorClamp(CosAngle, g_XMNegativeOne, g_XMOne);

    Result := XMVectorACos(CosAngle);
end;



function XMVector3LinePointDistance(LinePoint1: TFXMVECTOR; LinePoint2: TFXMVECTOR; Point: TFXMVECTOR): TXMVECTOR;
var
    PointVector, LineVector, LengthSq, PointProjectionScale: TXMVECTOR;
    DistanceVector: TXMVECTOR;
begin
    // Given a vector PointVector from LinePoint1 to Point and a vector
    // LineVector from LinePoint1 to LinePoint2, the scaled distance
    // PointProjectionScale from LinePoint1 to the perpendicular projection
    // of PointVector onto the line is defined as:

    // PointProjectionScale = dot(PointVector, LineVector) / LengthSq(LineVector)

    PointVector := XMVectorSubtract(Point, LinePoint1);
    LineVector := XMVectorSubtract(LinePoint2, LinePoint1);

    LengthSq := XMVector3LengthSq(LineVector);

    PointProjectionScale := XMVector3Dot(PointVector, LineVector);
    PointProjectionScale := XMVectorDivide(PointProjectionScale, LengthSq);

    DistanceVector := XMVectorMultiply(LineVector, PointProjectionScale);
    DistanceVector := XMVectorSubtract(PointVector, DistanceVector);

    Result := XMVector3Length(DistanceVector);
end;



procedure XMVector3ComponentsFromNormal(var Parallel: TXMVECTOR; var Perpendicular: TXMVECTOR; v: TFXMVECTOR; Normal: TFXMVECTOR);
var
    Scale: TXMVECTOR;
begin
    Scale := XMVector3Dot(v, Normal);
    Parallel := XMVectorMultiply(Normal, Scale);
    Perpendicular := XMVectorSubtract(v, Parallel);
end;

// Transform a vector using a rotation expressed as a unit quaternion

function XMVector3Rotate(v: TFXMVECTOR; RotationQuaternion: TFXMVECTOR): TXMVECTOR;
var
    a, Q: TXMVECTOR;
begin
    a := XMVectorSelect(g_XMSelect1110, v, g_XMSelect1110);
    Q := XMQuaternionConjugate(RotationQuaternion);
    Result := XMQuaternionMultiply(Q, a);
    Result := XMQuaternionMultiply(Result, RotationQuaternion);
end;

// Transform a vector using the inverse of a rotation expressed as a unit quaternion

function XMVector3InverseRotate(v: TFXMVECTOR; RotationQuaternion: TFXMVECTOR): TXMVECTOR;
var
    a, Q: TXMVECTOR;
begin
    a := XMVectorSelect(g_XMSelect1110, v, g_XMSelect1110);
    Result := XMQuaternionMultiply(RotationQuaternion, a);
    Q := XMQuaternionConjugate(RotationQuaternion);
    Result := XMQuaternionMultiply(Result, Q);
end;



function XMVector3Transform(v: TFXMVECTOR; m: TFXMMATRIX): TXMVECTOR;
var
    x, y, z: TXMVECTOR;
begin
    z := XMVectorSplatZ(v);
    y := XMVectorSplatY(v);
    x := XMVectorSplatX(v);

    Result := XMVectorMultiplyAdd(z, m.r[2], m.r[3]);
    Result := XMVectorMultiplyAdd(y, m.r[1], Result);
    Result := XMVectorMultiplyAdd(x, m.r[0], Result);
end;



function XMVector3TransformStream(var pOutputStream: PXMFLOAT4; OutputStride: size_t; const pInputStream: PXMFLOAT3; InputStride: size_t; VectorCount: size_t; m: TFXMMATRIX): PXMFLOAT4;
var
    pInputVector: pbyte;
    pOutputVector: pbyte;
    row0, row1, row2, row3: TXMVECTOR;
    i: integer;
    v, x, y, z: TXMVECTOR;
    vResult: TXMVECTOR;
begin
    pInputVector := pbyte(pInputStream);
    pOutputVector := pbyte(pOutputStream);

    row0 := m.r[0];
    row1 := m.r[1];
    row2 := m.r[2];
    row3 := m.r[3];

    for i := 0 to VectorCount - 1 do
    begin
        v := XMLoadFloat3(PXMFLOAT3(pInputVector)^);
        z := XMVectorSplatZ(v);
        y := XMVectorSplatY(v);
        x := XMVectorSplatX(v);

        vResult := XMVectorMultiplyAdd(z, row2, row3);
        vResult := XMVectorMultiplyAdd(y, row1, vResult);
        vResult := XMVectorMultiplyAdd(x, row0, vResult);

        XMStoreFloat4(PXMFLOAT4(pOutputVector)^, vResult);

        pInputVector := pInputVector + InputStride;
        pOutputVector := pOutputVector + OutputStride;
    end;

    Result := pOutputStream;
end;



function XMVector3TransformCoord(v: TFXMVECTOR; m: TFXMMATRIX): TXMVECTOR;
var
    x, y, z, w: TXMVECTOR;
begin
    z := XMVectorSplatZ(v);
    y := XMVectorSplatY(v);
    x := XMVectorSplatX(v);

    Result := XMVectorMultiplyAdd(z, m.r[2], m.r[3]);
    Result := XMVectorMultiplyAdd(y, m.r[1], Result);
    Result := XMVectorMultiplyAdd(x, m.r[0], Result);

    w := XMVectorSplatW(Result);
    Result := XMVectorDivide(Result, w);
end;



function XMVector3TransformCoordStream(var pOutputStream: PXMFLOAT3; OutputStride: size_t; const pInputStream: PXMFLOAT3; InputStride: size_t; VectorCount: size_t; m: TFXMMATRIX): PXMFLOAT3;
var
    pInputVector: pbyte;
    pOutputVector: pbyte;
    row0, row1, row2, row3: TXMVECTOR;
    i: integer;
    v, x, y, z, w: TXMVECTOR;
    vResult: TXMVECTOR;
begin
    pInputVector := pbyte(pInputStream);
    pOutputVector := pbyte(pOutputStream);

    row0 := m.r[0];
    row1 := m.r[1];
    row2 := m.r[2];
    row3 := m.r[3];

    for i := 0 to VectorCount - 1 do
    begin
        v := XMLoadFloat3(PXMFLOAT3(pInputVector)^);
        z := XMVectorSplatZ(v);
        y := XMVectorSplatY(v);
        x := XMVectorSplatX(v);

        vResult := XMVectorMultiplyAdd(z, row2, row3);
        vResult := XMVectorMultiplyAdd(y, row1, vResult);
        vResult := XMVectorMultiplyAdd(x, row0, vResult);

        w := XMVectorSplatW(vResult);

        vResult := XMVectorDivide(vResult, w);

        XMStoreFloat3(PXMFLOAT3(pOutputVector)^, vResult);

        pInputVector := pInputVector + InputStride;
        pOutputVector := pOutputVector + OutputStride;
    end;

    Result := pOutputStream;
end;



function XMVector3TransformNormal(v: TFXMVECTOR; m: TFXMMATRIX): TXMVECTOR;
var
    x, y, z: TXMVECTOR;
begin
    z := XMVectorSplatZ(v);
    y := XMVectorSplatY(v);
    x := XMVectorSplatX(v);

    Result := XMVectorMultiply(z, m.r[2]);
    Result := XMVectorMultiplyAdd(y, m.r[1], Result);
    Result := XMVectorMultiplyAdd(x, m.r[0], Result);
end;



function XMVector3TransformNormalStream(var pOutputStream: PXMFLOAT3; OutputStride: size_t; const pInputStream: PXMFLOAT3; InputStride: size_t; VectorCount: size_t; m: TFXMMATRIX): PXMFLOAT3;
var
    pInputVector: pbyte;
    pOutputVector: pbyte;
    row0, row1, row2, row3: TXMVECTOR;
    i: integer;
    v, x, y, z, w: TXMVECTOR;
    vResult: TXMVECTOR;
begin
    pInputVector := pbyte(pInputStream);
    pOutputVector := pbyte(pOutputStream);

    row0 := m.r[0];
    row1 := m.r[1];
    row2 := m.r[2];

    for i := 0 to VectorCount - 1 do
    begin
        v := XMLoadFloat3(PXMFLOAT3(pInputVector)^);
        z := XMVectorSplatZ(v);
        y := XMVectorSplatY(v);
        x := XMVectorSplatX(v);

        vResult := XMVectorMultiply(z, row2);
        vResult := XMVectorMultiplyAdd(y, row1, vResult);
        vResult := XMVectorMultiplyAdd(x, row0, vResult);

        XMStoreFloat3(PXMFLOAT3(pOutputVector)^, vResult);

        pInputVector := pInputVector + InputStride;
        pOutputVector := pOutputVector + OutputStride;
    end;
    Result := pOutputStream;
end;



function XMVector3Project(v: TFXMVECTOR; ViewportX, ViewportY, ViewportWidth, ViewportHeight, ViewportMinZ, ViewportMaxZ: single; Projection: TFXMMATRIX; View: TCXMMATRIX; World: TCXMMATRIX): TXMVECTOR;
var
    HalfViewportWidth, HalfViewportHeight: single;
    Scale, Offset: TXMVECTOR;
    Transform: TXMMATRIX;
begin
    HalfViewportWidth := ViewportWidth * 0.5;
    HalfViewportHeight := ViewportHeight * 0.5;

    Scale := XMVectorSet(HalfViewportWidth, -HalfViewportHeight, ViewportMaxZ - ViewportMinZ, 0.0);
    Offset := XMVectorSet(ViewportX + HalfViewportWidth, ViewportY + HalfViewportHeight, ViewportMinZ, 0.0);

    Transform := XMMatrixMultiply(World, View);
    Transform := XMMatrixMultiply(Transform, Projection);

    Result := XMVector3TransformCoord(v, Transform);
    Result := XMVectorMultiplyAdd(Result, Scale, Offset);
end;



function XMVector3ProjectStream(var pOutputStream: PXMFLOAT3; OutputStride: size_t; const pInputStream: PXMFLOAT3; InputStride: size_t; VectorCount: size_t;
    ViewportX, ViewportY, ViewportWidth, ViewportHeight, ViewportMinZ, ViewportMaxZ: single; Projection: TFXMMATRIX; View: TCXMMATRIX; World: TCXMMATRIX): PXMFLOAT3;
var
    pInputVector: pbyte;
    pOutputVector: pbyte;
    HalfViewportWidth, HalfViewportHeight: single;
    Scale, Offset: TXMVECTOR;
    Transform: TXMMATRIX;

    i: integer;
    v, x, y, z, w: TXMVECTOR;
    vResult: TXMVECTOR;
begin
    pInputVector := pbyte(pInputStream);
    pOutputVector := pbyte(pOutputStream);

    HalfViewportWidth := ViewportWidth * 0.5;
    HalfViewportHeight := ViewportHeight * 0.5;

    Scale := XMVectorSet(HalfViewportWidth, -HalfViewportHeight, ViewportMaxZ - ViewportMinZ, 1.0);
    Offset := XMVectorSet(ViewportX + HalfViewportWidth, ViewportY + HalfViewportHeight, ViewportMinZ, 0.0);

    Transform := XMMatrixMultiply(World, View);
    Transform := XMMatrixMultiply(Transform, Projection);

    for i := 0 to VectorCount - 1 do
    begin
        v := XMLoadFloat3(PXMFLOAT3(pInputVector)^);

        vResult := XMVector3TransformCoord(v, Transform);
        vResult := XMVectorMultiplyAdd(vResult, Scale, Offset);

        XMStoreFloat3(PXMFLOAT3(pOutputVector)^, vResult);

        pInputVector := pInputVector + InputStride;
        pOutputVector := pOutputVector + OutputStride;
    end;
    Result := pOutputStream;
end;



function XMVector3Unproject(v: TFXMVECTOR; ViewportX, ViewportY, ViewportWidth, ViewportHeight, ViewportMinZ, ViewportMaxZ: single; Projection: TFXMMATRIX; View: TCXMMATRIX; World: TCXMMATRIX): TXMVECTOR;
const
    D: TXMVECTOR = (vector4_f32: (-1.0, 1.0, 0.0, 0.0));
var
    Scale: TXMVECTOR;
    Offset: TXMVECTOR;
    Transform: TXMMATRIX;
begin
    Scale := XMVectorSet(ViewportWidth * 0.5, -ViewportHeight * 0.5, ViewportMaxZ - ViewportMinZ, 1.0);
    Scale := XMVectorReciprocal(Scale);

    Offset := XMVectorSet(-ViewportX, -ViewportY, -ViewportMinZ, 0.0);
    Offset := XMVectorMultiplyAdd(Scale, Offset, D);

    Transform := XMMatrixMultiply(World, View);
    Transform := XMMatrixMultiply(Transform, Projection);
    Transform := XMMatrixInverse(TXMVECTOR(nil^), Transform);

    Result := XMVectorMultiplyAdd(v, Scale, Offset);

    Result := XMVector3TransformCoord(Result, Transform);
end;



function XMVector3UnprojectStream(var pOutputStream: PXMFLOAT3; OutputStride: size_t; const pInputStream: PXMFLOAT3; InputStride: size_t; VectorCount: size_t;
    ViewportX, ViewportY, ViewportWidth, ViewportHeight, ViewportMinZ, ViewportMaxZ: single; Projection: TFXMMATRIX; View: TCXMMATRIX; World: TCXMMATRIX): PXMFLOAT3;
const
    D: TXMVECTOR = (vector4_f32: (-1.0, 1.0, 0.0, 0.0));
var
    Scale: TXMVECTOR;
    Offset: TXMVECTOR;
    Transform: TXMMATRIX;
    pInputVector: pbyte;
    pOutputVector: pbyte;
    v: TXMVECTOR;
    vResult: TXMVECTOR;
    i: integer;
begin
    Scale := XMVectorSet(ViewportWidth * 0.5, -ViewportHeight * 0.5, ViewportMaxZ - ViewportMinZ, 1.0);
    Scale := XMVectorReciprocal(Scale);

    Offset := XMVectorSet(-ViewportX, -ViewportY, -ViewportMinZ, 0.0);
    Offset := XMVectorMultiplyAdd(Scale, Offset, D);

    Transform := XMMatrixMultiply(World, View);
    Transform := XMMatrixMultiply(Transform, Projection);
    Transform := XMMatrixInverse(TXMVECTOR(nil^), Transform);

    pInputVector := pbyte(pInputStream);
    pOutputVector := pbyte(pOutputStream);

    for i := 0 to VectorCount - 1 do
    begin
        v := XMLoadFloat3(PXMFLOAT3(pInputVector)^);
        vResult := XMVectorMultiplyAdd(v, Scale, Offset);
        vResult := XMVector3TransformCoord(vResult, Transform);
        XMStoreFloat3(PXMFLOAT3(pOutputVector)^, vResult);

        pInputVector := pInputVector + InputStride;
        pOutputVector := pOutputVector + OutputStride;
    end;
    Result := pOutputStream;
end;

(* ***************************************************************************
  *
  * 4D Vector
  *
  *************************************************************************** *)

// ------------------------------------------------------------------------------
// Comparison operations
// ------------------------------------------------------------------------------

function XMVector4Equal(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_f32[0] = V2.vector4_f32[0]) and (V1.vector4_f32[1] = V2.vector4_f32[1]) and (V1.vector4_f32[2] = V2.vector4_f32[2]) and (V1.vector4_f32[3] = V2.vector4_f32[3]));
end;



function XMVector4EqualR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
begin
    Result := 0;

    if ((V1.vector4_f32[0] = V2.vector4_f32[0]) and (V1.vector4_f32[1] = V2.vector4_f32[1]) and (V1.vector4_f32[2] = V2.vector4_f32[2]) and (V1.vector4_f32[3] = V2.vector4_f32[3])) then
        Result := XM_CRMASK_CR6TRUE
    else if ((V1.vector4_f32[0] <> V2.vector4_f32[0]) and (V1.vector4_f32[1] <> V2.vector4_f32[1]) and (V1.vector4_f32[2] <> V2.vector4_f32[2]) and (V1.vector4_f32[3] <> V2.vector4_f32[3])) then
        Result := XM_CRMASK_CR6FALSE;
end;



function XMVector4EqualInt(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_u32[0] = V2.vector4_u32[0]) and (V1.vector4_u32[1] = V2.vector4_u32[1]) and (V1.vector4_u32[2] = V2.vector4_u32[2]) and (V1.vector4_u32[3] = V2.vector4_u32[3]));
end;



function XMVector4EqualIntR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
begin
    Result := 0;
    if (V1.vector4_u32[0] = V2.vector4_u32[0]) and (V1.vector4_u32[1] = V2.vector4_u32[1]) and (V1.vector4_u32[2] = V2.vector4_u32[2]) and (V1.vector4_u32[3] = V2.vector4_u32[3]) then
        Result := XM_CRMASK_CR6TRUE
    else if (V1.vector4_u32[0] <> V2.vector4_u32[0]) and (V1.vector4_u32[1] <> V2.vector4_u32[1]) and (V1.vector4_u32[2] <> V2.vector4_u32[2]) and (V1.vector4_u32[3] <> V2.vector4_u32[3]) then
        Result := XM_CRMASK_CR6FALSE;
end;



function XMVector4NearEqual(V1: TFXMVECTOR; V2: TFXMVECTOR; Epsilon: TFXMVECTOR): boolean;
var
    dx, dy, dz, dw: single;
begin
    dx := abs(V1.vector4_f32[0] - V2.vector4_f32[0]);
    dy := abs(V1.vector4_f32[1] - V2.vector4_f32[1]);
    dz := abs(V1.vector4_f32[2] - V2.vector4_f32[2]);
    dw := abs(V1.vector4_f32[3] - V2.vector4_f32[3]);
    Result := ((dx <= Epsilon.vector4_f32[0]) and (dy <= Epsilon.vector4_f32[1]) and (dz <= Epsilon.vector4_f32[2]) and (dw <= Epsilon.vector4_f32[3]));
end;



function XMVector4NotEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_f32[0] <> V2.vector4_f32[0]) or (V1.vector4_f32[1] <> V2.vector4_f32[1]) or (V1.vector4_f32[2] <> V2.vector4_f32[2]) or (V1.vector4_f32[3] <> V2.vector4_f32[3]));
end;



function XMVector4NotEqualInt(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_u32[0] <> V2.vector4_u32[0]) or (V1.vector4_u32[1] <> V2.vector4_u32[1]) or (V1.vector4_u32[2] <> V2.vector4_u32[2]) or (V1.vector4_u32[3] <> V2.vector4_u32[3]));
end;



function XMVector4Greater(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_f32[0] > V2.vector4_f32[0]) and (V1.vector4_f32[1] > V2.vector4_f32[1]) and (V1.vector4_f32[2] > V2.vector4_f32[2]) and (V1.vector4_f32[3] > V2.vector4_f32[3]));
end;



function XMVector4GreaterR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
begin
    Result := 0;
    if (V1.vector4_f32[0] > V2.vector4_f32[0]) and (V1.vector4_f32[1] > V2.vector4_f32[1]) and (V1.vector4_f32[2] > V2.vector4_f32[2]) and (V1.vector4_f32[3] > V2.vector4_f32[3]) then
        Result := XM_CRMASK_CR6TRUE
    else if (V1.vector4_f32[0] <= V2.vector4_f32[0]) and (V1.vector4_f32[1] <= V2.vector4_f32[1]) and (V1.vector4_f32[2] <= V2.vector4_f32[2]) and (V1.vector4_f32[3] <= V2.vector4_f32[3]) then
        Result := XM_CRMASK_CR6FALSE;
end;



function XMVector4GreaterOrEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_f32[0] >= V2.vector4_f32[0]) and (V1.vector4_f32[1] >= V2.vector4_f32[1]) and (V1.vector4_f32[2] >= V2.vector4_f32[2]) and (V1.vector4_f32[3] >= V2.vector4_f32[3]));
end;



function XMVector4GreaterOrEqualR(V1: TFXMVECTOR; V2: TFXMVECTOR): uint32;
begin
    Result := 0;
    if ((V1.vector4_f32[0] >= V2.vector4_f32[0]) and (V1.vector4_f32[1] >= V2.vector4_f32[1]) and (V1.vector4_f32[2] >= V2.vector4_f32[2]) and (V1.vector4_f32[3] >= V2.vector4_f32[3])) then
        Result := XM_CRMASK_CR6TRUE
    else if ((V1.vector4_f32[0] < V2.vector4_f32[0]) and (V1.vector4_f32[1] < V2.vector4_f32[1]) and (V1.vector4_f32[2] < V2.vector4_f32[2]) and (V1.vector4_f32[3] < V2.vector4_f32[3])) then
        Result := XM_CRMASK_CR6FALSE;
end;



function XMVector4Less(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_f32[0] < V2.vector4_f32[0]) and (V1.vector4_f32[1] < V2.vector4_f32[1]) and (V1.vector4_f32[2] < V2.vector4_f32[2]) and (V1.vector4_f32[3] < V2.vector4_f32[3]));
end;



function XMVector4LessOrEqual(V1: TFXMVECTOR; V2: TFXMVECTOR): boolean;
begin
    Result := ((V1.vector4_f32[0] <= V2.vector4_f32[0]) and (V1.vector4_f32[1] <= V2.vector4_f32[1]) and (V1.vector4_f32[2] <= V2.vector4_f32[2]) and (V1.vector4_f32[3] <= V2.vector4_f32[3]));
end;



function XMVector4InBounds(v: TFXMVECTOR; Bounds: TFXMVECTOR): boolean;
begin
    Result := ((v.vector4_f32[0] <= Bounds.vector4_f32[0]) and (v.vector4_f32[0] >= -Bounds.vector4_f32[0]) and (v.vector4_f32[1] <= Bounds.vector4_f32[1]) and (v.vector4_f32[1] >= -Bounds.vector4_f32[1]) and
        (v.vector4_f32[2] <= Bounds.vector4_f32[2]) and (v.vector4_f32[2] >= -Bounds.vector4_f32[2]) and (v.vector4_f32[3] <= Bounds.vector4_f32[3]) and (v.vector4_f32[3] >= -Bounds.vector4_f32[3]));

end;



function XMVector4IsNaN(v: TFXMVECTOR): boolean;
begin
    Result := (XMISNAN(v.vector4_f32[0]) or XMISNAN(v.vector4_f32[1]) or XMISNAN(v.vector4_f32[2]) or XMISNAN(v.vector4_f32[3]));
end;



function XMVector4IsInfinite(v: TFXMVECTOR): boolean;
begin
    Result := (XMISINF(v.vector4_f32[0]) or XMISINF(v.vector4_f32[1]) or XMISINF(v.vector4_f32[2]) or XMISINF(v.vector4_f32[3]));

end;

// ------------------------------------------------------------------------------
// Computation operations
// ------------------------------------------------------------------------------

function XMVector4Dot(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
begin
    Result.f[0] := V1.vector4_f32[0] * V2.vector4_f32[0] + V1.vector4_f32[1] * V2.vector4_f32[1] + V1.vector4_f32[2] * V2.vector4_f32[2] + V1.vector4_f32[3] * V2.vector4_f32[3];
    Result.f[1] := Result.f[0];
    Result.f[2] := Result.f[0];
    Result.f[3] := Result.f[0];
end;



function XMVector4Cross(V1: TFXMVECTOR; V2: TFXMVECTOR; V3: TFXMVECTOR): TXMVECTOR;
begin
    // [ ((v2.z*v3.w-v2.w*v3.z)*v1.y)-((v2.y*v3.w-v2.w*v3.y)*v1.z)+((v2.y*v3.z-v2.z*v3.y)*v1.w),
    // ((v2.w*v3.z-v2.z*v3.w)*v1.x)-((v2.w*v3.x-v2.x*v3.w)*v1.z)+((v2.z*v3.x-v2.x*v3.z)*v1.w),
    // ((v2.y*v3.w-v2.w*v3.y)*v1.x)-((v2.x*v3.w-v2.w*v3.x)*v1.y)+((v2.x*v3.y-v2.y*v3.x)*v1.w),
    // ((v2.z*v3.y-v2.y*v3.z)*v1.x)-((v2.z*v3.x-v2.x*v3.z)*v1.y)+((v2.y*v3.x-v2.x*v3.y)*v1.z) ]

    Result.vector4_f32[0] := (((V2.vector4_f32[2] * V3.vector4_f32[3]) - (V2.vector4_f32[3] * V3.vector4_f32[2])) * V1.vector4_f32[1]) - (((V2.vector4_f32[1] * V3.vector4_f32[3]) -
        (V2.vector4_f32[3] * V3.vector4_f32[1])) * V1.vector4_f32[2]) + (((V2.vector4_f32[1] * V3.vector4_f32[2]) - (V2.vector4_f32[2] * V3.vector4_f32[1])) * V1.vector4_f32[3]);
    Result.vector4_f32[1] := (((V2.vector4_f32[3] * V3.vector4_f32[2]) - (V2.vector4_f32[2] * V3.vector4_f32[3])) * V1.vector4_f32[0]) - (((V2.vector4_f32[3] * V3.vector4_f32[0]) -
        (V2.vector4_f32[0] * V3.vector4_f32[3])) * V1.vector4_f32[2]) + (((V2.vector4_f32[2] * V3.vector4_f32[0]) - (V2.vector4_f32[0] * V3.vector4_f32[2])) * V1.vector4_f32[3]);
    Result.vector4_f32[2] := (((V2.vector4_f32[1] * V3.vector4_f32[3]) - (V2.vector4_f32[3] * V3.vector4_f32[1])) * V1.vector4_f32[0]) - (((V2.vector4_f32[0] * V3.vector4_f32[3]) -
        (V2.vector4_f32[3] * V3.vector4_f32[0])) * V1.vector4_f32[1]) + (((V2.vector4_f32[0] * V3.vector4_f32[1]) - (V2.vector4_f32[1] * V3.vector4_f32[0])) * V1.vector4_f32[3]);
    Result.vector4_f32[3] := (((V2.vector4_f32[2] * V3.vector4_f32[1]) - (V2.vector4_f32[1] * V3.vector4_f32[2])) * V1.vector4_f32[0]) - (((V2.vector4_f32[2] * V3.vector4_f32[0]) -
        (V2.vector4_f32[0] * V3.vector4_f32[2])) * V1.vector4_f32[1]) + (((V2.vector4_f32[1] * V3.vector4_f32[0]) - (V2.vector4_f32[0] * V3.vector4_f32[1])) * V1.vector4_f32[2]);
end;



function XMVector4LengthSq(v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector4Dot(v, v);
end;



function XMVector4ReciprocalLengthEst(v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector4LengthSq(v);
    Result := XMVectorReciprocalSqrtEst(Result);
end;



function XMVector4ReciprocalLength(v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector4LengthSq(v);
    Result := XMVectorReciprocalSqrt(Result);
end;



function XMVector4LengthEst(v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector4LengthSq(v);
    Result := XMVectorSqrtEst(Result);
end;



function XMVector4Length(v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector4LengthSq(v);
    Result := XMVectorSqrt(Result);
end;

// XMVector4NormalizeEst uses a reciprocal estimate and
// returns QNaN on zero and infinite vectors.
function XMVector4NormalizeEst(v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector4ReciprocalLength(v);
    Result := XMVectorMultiply(v, Result);
end;



function XMVector4Normalize(v: TFXMVECTOR): TXMVECTOR;
var
    fLength: single;
begin
    Result := XMVector4Length(v);
    fLength := Result.vector4_f32[0];

    // Prevent divide by zero
    if (fLength > 0) then
        fLength := 1.0 / fLength;

    Result.vector4_f32[0] := v.vector4_f32[0] * fLength;
    Result.vector4_f32[1] := v.vector4_f32[1] * fLength;
    Result.vector4_f32[2] := v.vector4_f32[2] * fLength;
    Result.vector4_f32[3] := v.vector4_f32[3] * fLength;
end;



function XMVector4ClampLength(v: TFXMVECTOR; LengthMin, LengthMax: single): TXMVECTOR;
var
    ClampMin, ClampMax: TXMVECTOR;
begin
    ClampMax := XMVectorReplicate(LengthMax);
    ClampMin := XMVectorReplicate(LengthMin);

    Result := XMVector4ClampLengthV(v, ClampMin, ClampMax);
end;



function XMVector4ClampLengthV(v: TFXMVECTOR; LengthMin: TFXMVECTOR; LengthMax: TFXMVECTOR): TXMVECTOR;
var
    LengthSq, RcpLength, InfiniteLength, ZeroLength: TXMVECTOR;
    Normal, Length, Select: TXMVECTOR;
    ControlMax, ControlMin, ClampLength, Control: TXMVECTOR;
begin
    LengthSq := XMVector4LengthSq(v);
    RcpLength := XMVectorReciprocalSqrt(LengthSq);
    InfiniteLength := XMVectorEqualInt(LengthSq, g_XMInfinity);
    ZeroLength := XMVectorEqual(LengthSq, g_XMZero);

    Normal := XMVectorMultiply(v, RcpLength);

    Length := XMVectorMultiply(LengthSq, RcpLength);

    Select := XMVectorEqualInt(InfiniteLength, ZeroLength);
    Length := XMVectorSelect(LengthSq, Length, Select);
    Normal := XMVectorSelect(LengthSq, Normal, Select);

    ControlMax := XMVectorGreater(Length, LengthMax);
    ControlMin := XMVectorLess(Length, LengthMin);

    ClampLength := XMVectorSelect(Length, LengthMax, ControlMax);
    ClampLength := XMVectorSelect(ClampLength, LengthMin, ControlMin);

    Result := XMVectorMultiply(Normal, ClampLength);

    // Preserve the original vector (with no precision loss) if the length falls within the given range
    Control := XMVectorEqualInt(ControlMax, ControlMin);
    Result := XMVectorSelect(Result, v, Control);
end;



function XMVector4Reflect(Incident: TFXMVECTOR; Normal: TFXMVECTOR): TXMVECTOR;
begin
    // Result = Incident - (2 * dot(Incident, Normal)) * Normal
    Result := XMVector4Dot(Incident, Normal);
    Result := XMVectorAdd(Result, Result);
    Result := XMVectorNegativeMultiplySubtract(Result, Normal, Incident);
end;



function XMVector4Refract(Incident: TFXMVECTOR; Normal: TFXMVECTOR; RefractionIndex: single): TXMVECTOR;
var
    Index: TXMVECTOR;
begin
    Index := XMVectorReplicate(RefractionIndex);
    Result := XMVector4RefractV(Incident, Normal, Index);
end;



function XMVector4RefractV(Incident: TFXMVECTOR; Normal: TFXMVECTOR; RefractionIndex: TFXMVECTOR): TXMVECTOR;
var
    IDotN: TXMVECTOR;
    r: TXMVECTOR;
begin
    // Result = RefractionIndex * Incident - Normal * (RefractionIndex * dot(Incident, Normal) +
    // sqrt(1 - RefractionIndex * RefractionIndex * (1 - dot(Incident, Normal) * dot(Incident, Normal))))

    IDotN := XMVector4Dot(Incident, Normal);

    // R = 1.0f - RefractionIndex * RefractionIndex * (1.0f - IDotN * IDotN)
    r := XMVectorNegativeMultiplySubtract(IDotN, IDotN, g_XMOne);
    r := XMVectorMultiply(r, RefractionIndex);
    r := XMVectorNegativeMultiplySubtract(r, RefractionIndex, g_XMOne);

    if (XMVector4LessOrEqual(r, g_XMZero)) then
        // Total internal reflection
        Result := g_XMZero
    else
    begin
        // R = RefractionIndex * IDotN + sqrt(R)
        r := XMVectorSqrt(r);
        r := XMVectorMultiplyAdd(RefractionIndex, IDotN, r);

        // Result = RefractionIndex * Incident - Normal * R
        Result := XMVectorMultiply(RefractionIndex, Incident);
        Result := XMVectorNegativeMultiplySubtract(Normal, r, Result);
    end;
end;



function XMVector4Orthogonal(v: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := v.vector4_f32[2];
    Result.vector4_f32[1] := v.vector4_f32[3];
    Result.vector4_f32[2] := -v.vector4_f32[0];
    Result.vector4_f32[3] := -v.vector4_f32[1];
end;



function XMVector4AngleBetweenNormalsEst(N1: TFXMVECTOR; N2: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector4Dot(N1, N2);
    Result := XMVectorClamp(Result, g_XMNegativeOne, g_XMOne);
    Result := XMVectorACosEst(Result);
end;



function XMVector4AngleBetweenNormals(N1: TFXMVECTOR; N2: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector4Dot(N1, N2);
    Result := XMVectorClamp(Result, g_XMNegativeOne, g_XMOne);
    Result := XMVectorACos(Result);
end;



function XMVector4AngleBetweenVectors(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR;
var
    L1, L2: TXMVECTOR;
    Dot, CosAngle: TXMVECTOR;
begin
    L1 := XMVector4ReciprocalLength(V1);
    L2 := XMVector4ReciprocalLength(V2);

    Dot := XMVector4Dot(V1, V2);

    L1 := XMVectorMultiply(L1, L2);

    CosAngle := XMVectorMultiply(Dot, L1);
    CosAngle := XMVectorClamp(CosAngle, g_XMNegativeOne, g_XMOne);

    Result := XMVectorACos(CosAngle);
end;



function XMVector4Transform(v: TFXMVECTOR; m: TFXMMATRIX): TXMVECTOR;
begin
    Result.vector4_f32[0] := (m.m[0][0] * v.vector4_f32[0]) + (m.m[1][0] * v.vector4_f32[1]) + (m.m[2][0] * v.vector4_f32[2]) + (m.m[3][0] * v.vector4_f32[3]);
    Result.vector4_f32[1] := (m.m[0][1] * v.vector4_f32[0]) + (m.m[1][1] * v.vector4_f32[1]) + (m.m[2][1] * v.vector4_f32[2]) + (m.m[3][1] * v.vector4_f32[3]);
    Result.vector4_f32[2] := (m.m[0][2] * v.vector4_f32[0]) + (m.m[1][2] * v.vector4_f32[1]) + (m.m[2][2] * v.vector4_f32[2]) + (m.m[3][2] * v.vector4_f32[3]);
    Result.vector4_f32[3] := (m.m[0][3] * v.vector4_f32[0]) + (m.m[1][3] * v.vector4_f32[1]) + (m.m[2][3] * v.vector4_f32[2]) + (m.m[3][3] * v.vector4_f32[3]);
end;



function XMVector4TransformStream(var pOutputStream: PXMFLOAT4; OutputStride: size_t; const pInputStream: PXMFLOAT4; InputStride: size_t; VectorCount: size_t; m: TFXMMATRIX): PXMFLOAT4;
var
    i: integer;
    pInputVector: pbyte;
    pOutputVector: pbyte;
    row0, row1, row2, row3: TXMVECTOR;
    v, w, z, x, y: TXMVECTOR;
    vResult: TXMVECTOR;
begin
    pInputVector := pbyte(pInputStream);
    pOutputVector := pbyte(pOutputStream);

    row0 := m.r[0];
    row1 := m.r[1];
    row2 := m.r[2];
    row3 := m.r[3];

    for i := 0 to VectorCount - 1 do
    begin
        v := XMLoadFloat4(PXMFLOAT4(pInputVector)^);
        w := XMVectorSplatW(v);
        z := XMVectorSplatZ(v);
        y := XMVectorSplatY(v);
        x := XMVectorSplatX(v);

        vResult := XMVectorMultiply(w, row3);
        vResult := XMVectorMultiplyAdd(z, row2, vResult);
        vResult := XMVectorMultiplyAdd(y, row1, vResult);
        vResult := XMVectorMultiplyAdd(x, row0, vResult);

        XMStoreFloat4(PXMFLOAT4(pOutputVector)^, vResult);

        pInputVector := pInputVector + InputStride;
        pOutputVector := pOutputVector + OutputStride;
    end;
    Result := pOutputStream;
end;

(* ***************************************************************************
  *
  * XMVECTOR operators
  *
  *************************************************************************** *)

constructor TXMVECTOR.Create(pArray: PSingle);
begin
    Move(pArray^, self.vector4_f32[0], 16);
end;



constructor TXMVECTOR.Create(x, y, z, w: single);
begin
    self.vector4_f32[0] := x;
    self.vector4_f32[1] := y;
    self.vector4_f32[2] := z;
    self.vector4_f32[3] := w;
end;



class operator TXMVECTOR.Negative(a: TXMVECTOR): TXMVECTOR;
begin
    Result := XMVectorNegate(a);
end;



class operator TXMVECTOR.Positive(a: TXMVECTOR): TXMVECTOR;
begin
    Result := a;
end;



class operator TXMVECTOR.Equal(a: TXMVECTOR; b: TXMVECTOR): boolean;
begin
    Result := XMVector4Equal(a, b);
end;



class operator TXMVECTOR.NotEqual(a: TXMVECTOR; b: TXMVECTOR): boolean;
begin
    Result := XMVector4NotEqual(a, b);
end;



class operator TXMVECTOR.Add(a, b: TXMVECTOR): TXMVECTOR;
begin
    Result := XMVectorAdd(a, b);
end;



class operator TXMVECTOR.Subtract(a: TXMVECTOR; b: TXMVECTOR): TXMVECTOR;
begin
    Result := XMVectorSubtract(a, b);
end;



class operator TXMVECTOR.Multiply(a: TXMVECTOR; b: TXMVECTOR): TXMVECTOR;
begin
    Result := XMVectorMultiply(a, b);
end;



class operator TXMVECTOR.Divide(a: TXMVECTOR; b: TXMVECTOR): TXMVECTOR;
begin
    Result := XMVectorDivide(a, b);
end;



class operator TXMVECTOR.Multiply(a: single; b: TXMVECTOR): TXMVECTOR;
begin
    Result := XMVectorScale(b, a);
end;



class operator TXMVECTOR.Multiply(a: TXMVECTOR; b: single): TXMVECTOR;
begin
    Result := XMVectorScale(a, b);
end;



class operator TXMVECTOR.Divide(a: TXMVECTOR; b: single): TXMVECTOR;
var
    VS: TXMVECTOR;
begin
    VS := XMVectorReplicate(b);
    Result := XMVectorDivide(a, VS);
end;

{ TXMFLOAT2 }

constructor TXMFLOAT2.Create(x, y: single);
begin
    self.x := x;
    self.y := y;
end;



constructor TXMFLOAT2.Create(pArray: PSingle);
begin
    Move(pArray^, self.f[0], 8);
end;



class operator TXMFLOAT2.Equal(a: TXMFLOAT2; b: TXMFLOAT2): boolean;
begin
    Result := (a.x = b.x) and (a.y = b.y);
end;



function TXMFLOAT2.ThreeWayComparison(const a, b: TXMFLOAT2): integer;
begin
    // ??? if a<b then result :=-1 else if a>b result:=+1 else result:=0;
end;

{ TXMFLOAT2A }

constructor TXMFLOAT2A.Create(x, y: single);
begin
    self.x := x;
    self.y := y;
end;



constructor TXMFLOAT2A.Create(pArray: PSingle);
var
    lArray: array [0 .. 1] of single absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
end;

{ TXMINT2 }

constructor TXMINT2.Create(x, y: int32);
begin
    self.x := x;
    self.y := y;
end;



constructor TXMINT2.Create(pArray: PLongint);
begin
    Move(pArray^, self.i[0], 8);
end;

{ TXMUINT2 }

constructor TXMUINT2.Create(x, y: uint32);
begin
    self.x := x;
    self.y := y;
end;



constructor TXMUINT2.Create(pArray: Puint32);
begin
    Move(pArray^, self.u[0], 8);
end;

{ TXMFLOAT3 }

constructor TXMFLOAT3.Create(x, y, z: single);
begin
    self.x := x;
    self.y := y;
    self.z := z;
end;



constructor TXMFLOAT3.Create(pArray: PSingle);
begin
    Move(pArray^, self.f[0], 12);
end;

{ TXMFLOAT3A }

constructor TXMFLOAT3A.Create(x, y, z: single);
begin
    self.x := x;
    self.y := y;
    self.z := z;
end;



constructor TXMFLOAT3A.Create(pArray: PSingle);
var
    lArray: array [0 .. 2] of single absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
    self.z := lArray[2];
end;

{ TXMINT3 }

constructor TXMINT3.Create(x, y, z: int32);
begin
    self.x := x;
    self.y := y;
    self.z := z;
end;



constructor TXMINT3.Create(pArray: PLongint);
begin
    Move(pArray^, self.i[0], 12);
end;

{ TXMUINT3 }

constructor TXMUINT3.Create(x, y, z: uint32);
begin
    self.x := x;
    self.y := y;
    self.z := z;
end;



constructor TXMUINT3.Create(pArray: Puint32);
begin
    Move(pArray^, self.u[0], 12);
end;

{ TXMUINT4 }

constructor TXMUINT4.Create(x, y, z, w: uint32);
begin
    self.x := x;
    self.y := y;
    self.z := z;
    self.w := w;
end;



constructor TXMUINT4.Create(pArray: Puint32);
begin
    Move(pArray^, self.u[0], 16);
end;

{ TXMINT4 }

constructor TXMINT4.Create(x, y, z, w: int32);
begin
    self.x := x;
    self.y := y;
    self.z := z;
    self.w := w;
end;



constructor TXMINT4.Create(pArray: PLongint);
begin
    Move(pArray^, self.i[0], 16);
end;

{ TXMFLOAT4 }

constructor TXMFLOAT4.Create(x, y, z, w: single);
begin
    self.x := x;
    self.y := y;
    self.z := z;
    self.w := w;
end;



constructor TXMFLOAT4.Create(pArray: PSingle);
begin
    Move(pArray^, self.f[0], 16);
end;

{$ENDREGION}// DirectXMathVector

{$REGION DirectXMathMatrix}
(* ***************************************************************************
  *
  * Matrix
  *
  *************************************************************************** *)

// ------------------------------------------------------------------------------
// Comparison operations
// ------------------------------------------------------------------------------

// Return true if any entry in the matrix is NaN
function XMMatrixIsNaN(m: TFXMMATRIX): boolean;
var
    i: integer;
    uTest: uint32;
begin
    i := 16;
    repeat
        // Fetch value into integer unit
        uTest := m.u[i - 1];
        // Remove sign
        uTest := uTest and $7FFFFFFF;
        // NaN is 0x7F800001 through 0x7FFFFFFF inclusive
        uTest := uTest - $7F800001;
        if (uTest < $007FFFFF) then
            break; // NaN found
        Dec(i); // Next entry
    until (i = 0);
    Result := (i <> 0); // i == 0 if nothing matched
end;

// Return true if any entry in the matrix is +/-INF

function XMMatrixIsInfinite(m: TFXMMATRIX): boolean;
var
    i: integer;
    uTest: uint32;
begin
    i := 16;
    repeat
        // Fetch value into integer unit
        uTest := m.u[i - 1];
        // Remove sign
        uTest := uTest and $7FFFFFFF;
        // INF is 0x7F800000
        if (uTest = $7F800000) then
            break; // INF found
        Dec(i); // Next entry
    until (i = 0);
    Result := (i <> 0); // i == 0 if nothing matched
end;

// Return true if the XMMatrix is equal to identity

function XMMatrixIsIdentity(m: TFXMMATRIX): boolean;
var
    uOne, uZero: uint32;
begin
    // Use the integer pipeline to reduce branching to a minimum
    // Convert 1.0f to zero and or them together
    uOne := m.u[0] xor $3F800000;
    // Or all the 0.0f entries together
    uZero := m.u[1];
    uZero := uZero or m.u[2];
    uZero := uZero or m.u[3];
    // 2nd row
    uZero := uZero or m.u[4];
    uOne := uOne or m.u[5] xor $3F800000;
    uZero := uZero or m.u[6];
    uZero := uZero or m.u[7];
    // 3rd row
    uZero := uZero or m.u[8];
    uZero := uZero or m.u[9];
    uOne := uOne or m.u[10] xor $3F800000;
    uZero := uZero or m.u[11];
    // 4th row
    uZero := uZero or m.u[12];
    uZero := uZero or m.u[13];
    uZero := uZero or m.u[14];
    uOne := uOne or m.u[15] xor $3F800000;
    // If all zero entries are zero, the uZero==0
    uZero := uZero and $7FFFFFFF; // Allow -0.0f
    // If all 1.0f entries are 1.0f, then uOne==0
    uOne := uOne or uZero;
    Result := (uOne = 0);
end;


// ------------------------------------------------------------------------------
// Computation operations
// ------------------------------------------------------------------------------

// Perform a 4x4 matrix multiply by a 4x4 matrix
function XMMatrixMultiply(M1: TFXMMATRIX; M2: TCXMMATRIX): TXMMATRIX;
var
    x, y, z, w: single;
begin
    // Cache the invariants in registers
    x := M1.m[0][0];
    y := M1.m[0][1];
    z := M1.m[0][2];
    w := M1.m[0][3];
    // Perform the operation on the first row
    Result.m[0][0] := (M2.m[0][0] * x) + (M2.m[1][0] * y) + (M2.m[2][0] * z) + (M2.m[3][0] * w);
    Result.m[0][1] := (M2.m[0][1] * x) + (M2.m[1][1] * y) + (M2.m[2][1] * z) + (M2.m[3][1] * w);
    Result.m[0][2] := (M2.m[0][2] * x) + (M2.m[1][2] * y) + (M2.m[2][2] * z) + (M2.m[3][2] * w);
    Result.m[0][3] := (M2.m[0][3] * x) + (M2.m[1][3] * y) + (M2.m[2][3] * z) + (M2.m[3][3] * w);
    // Repeat for all the other rows
    x := M1.m[1][0];
    y := M1.m[1][1];
    z := M1.m[1][2];
    w := M1.m[1][3];
    Result.m[1][0] := (M2.m[0][0] * x) + (M2.m[1][0] * y) + (M2.m[2][0] * z) + (M2.m[3][0] * w);
    Result.m[1][1] := (M2.m[0][1] * x) + (M2.m[1][1] * y) + (M2.m[2][1] * z) + (M2.m[3][1] * w);
    Result.m[1][2] := (M2.m[0][2] * x) + (M2.m[1][2] * y) + (M2.m[2][2] * z) + (M2.m[3][2] * w);
    Result.m[1][3] := (M2.m[0][3] * x) + (M2.m[1][3] * y) + (M2.m[2][3] * z) + (M2.m[3][3] * w);
    x := M1.m[2][0];
    y := M1.m[2][1];
    z := M1.m[2][2];
    w := M1.m[2][3];
    Result.m[2][0] := (M2.m[0][0] * x) + (M2.m[1][0] * y) + (M2.m[2][0] * z) + (M2.m[3][0] * w);
    Result.m[2][1] := (M2.m[0][1] * x) + (M2.m[1][1] * y) + (M2.m[2][1] * z) + (M2.m[3][1] * w);
    Result.m[2][2] := (M2.m[0][2] * x) + (M2.m[1][2] * y) + (M2.m[2][2] * z) + (M2.m[3][2] * w);
    Result.m[2][3] := (M2.m[0][3] * x) + (M2.m[1][3] * y) + (M2.m[2][3] * z) + (M2.m[3][3] * w);
    x := M1.m[3][0];
    y := M1.m[3][1];
    z := M1.m[3][2];
    w := M1.m[3][3];
    Result.m[3][0] := (M2.m[0][0] * x) + (M2.m[1][0] * y) + (M2.m[2][0] * z) + (M2.m[3][0] * w);
    Result.m[3][1] := (M2.m[0][1] * x) + (M2.m[1][1] * y) + (M2.m[2][1] * z) + (M2.m[3][1] * w);
    Result.m[3][2] := (M2.m[0][2] * x) + (M2.m[1][2] * y) + (M2.m[2][2] * z) + (M2.m[3][2] * w);
    Result.m[3][3] := (M2.m[0][3] * x) + (M2.m[1][3] * y) + (M2.m[2][3] * z) + (M2.m[3][3] * w);
end;



function XMMatrixMultiplyTranspose(M1: TFXMMATRIX; M2: TCXMMATRIX): TXMMATRIX;
var
    x, y, z, w: single;
begin
    // Cache the invariants in registers
    x := M2.m[0][0];
    y := M2.m[1][0];
    z := M2.m[2][0];
    w := M2.m[3][0];
    // Perform the operation on the first row
    Result.m[0][0] := (M1.m[0][0] * x) + (M1.m[0][1] * y) + (M1.m[0][2] * z) + (M1.m[0][3] * w);
    Result.m[0][1] := (M1.m[1][0] * x) + (M1.m[1][1] * y) + (M1.m[1][2] * z) + (M1.m[1][3] * w);
    Result.m[0][2] := (M1.m[2][0] * x) + (M1.m[2][1] * y) + (M1.m[2][2] * z) + (M1.m[2][3] * w);
    Result.m[0][3] := (M1.m[3][0] * x) + (M1.m[3][1] * y) + (M1.m[3][2] * z) + (M1.m[3][3] * w);
    // Repeat for all the other rows
    x := M2.m[0][1];
    y := M2.m[1][1];
    z := M2.m[2][1];
    w := M2.m[3][1];
    Result.m[1][0] := (M1.m[0][0] * x) + (M1.m[0][1] * y) + (M1.m[0][2] * z) + (M1.m[0][3] * w);
    Result.m[1][1] := (M1.m[1][0] * x) + (M1.m[1][1] * y) + (M1.m[1][2] * z) + (M1.m[1][3] * w);
    Result.m[1][2] := (M1.m[2][0] * x) + (M1.m[2][1] * y) + (M1.m[2][2] * z) + (M1.m[2][3] * w);
    Result.m[1][3] := (M1.m[3][0] * x) + (M1.m[3][1] * y) + (M1.m[3][2] * z) + (M1.m[3][3] * w);
    x := M2.m[0][2];
    y := M2.m[1][2];
    z := M2.m[2][2];
    w := M2.m[3][2];
    Result.m[2][0] := (M1.m[0][0] * x) + (M1.m[0][1] * y) + (M1.m[0][2] * z) + (M1.m[0][3] * w);
    Result.m[2][1] := (M1.m[1][0] * x) + (M1.m[1][1] * y) + (M1.m[1][2] * z) + (M1.m[1][3] * w);
    Result.m[2][2] := (M1.m[2][0] * x) + (M1.m[2][1] * y) + (M1.m[2][2] * z) + (M1.m[2][3] * w);
    Result.m[2][3] := (M1.m[3][0] * x) + (M1.m[3][1] * y) + (M1.m[3][2] * z) + (M1.m[3][3] * w);
    x := M2.m[0][3];
    y := M2.m[1][3];
    z := M2.m[2][3];
    w := M2.m[3][3];
    Result.m[3][0] := (M1.m[0][0] * x) + (M1.m[0][1] * y) + (M1.m[0][2] * z) + (M1.m[0][3] * w);
    Result.m[3][1] := (M1.m[1][0] * x) + (M1.m[1][1] * y) + (M1.m[1][2] * z) + (M1.m[1][3] * w);
    Result.m[3][2] := (M1.m[2][0] * x) + (M1.m[2][1] * y) + (M1.m[2][2] * z) + (M1.m[2][3] * w);
    Result.m[3][3] := (M1.m[3][0] * x) + (M1.m[3][1] * y) + (M1.m[3][2] * z) + (M1.m[3][3] * w);
end;



function XMMatrixTranspose(m: TFXMMATRIX): TXMMATRIX;
var
    P: TXMMATRIX;
begin
    // Original matrix:

    // m00m01m02m03
    // m10m11m12m13
    // m20m21m22m23
    // m30m31m32m33

    P.r[0] := XMVectorMergeXY(m.r[0], m.r[2]); // m00m20m01m21
    P.r[1] := XMVectorMergeXY(m.r[1], m.r[3]); // m10m30m11m31
    P.r[2] := XMVectorMergeZW(m.r[0], m.r[2]); // m02m22m03m23
    P.r[3] := XMVectorMergeZW(m.r[1], m.r[3]); // m12m32m13m33

    Result.r[0] := XMVectorMergeXY(P.r[0], P.r[1]); // m00m10m20m30
    Result.r[1] := XMVectorMergeZW(P.r[0], P.r[1]); // m01m11m21m31
    Result.r[2] := XMVectorMergeXY(P.r[2], P.r[3]); // m02m12m22m32
    Result.r[3] := XMVectorMergeZW(P.r[2], P.r[3]); // m03m13m23m33
end;

// Return the inverse and the determinant of a 4x4 matrix

function XMMatrixInverse(var pDeterminant: TXMVECTOR; m: TFXMMATRIX): TXMMATRIX;
var
    MT: TXMMATRIX;
    V0, V1: array [0 .. 3] of TXMVECTOR;
    D0, D1, D2: TXMVECTOR;
    C0, C1, C2, C3, C4, C5, C6, C7: TXMVECTOR;
    r: TXMMATRIX;
    Determinant: TXMVECTOR;
    Reciprocal: TXMVECTOR;
begin
    MT := XMMatrixTranspose(m);

    V0[0] := XMVectorSwizzle(XM_SWIZZLE_X, XM_SWIZZLE_X, XM_SWIZZLE_Y, XM_SWIZZLE_Y, MT.r[2]);
    V1[0] := XMVectorSwizzle(XM_SWIZZLE_Z, XM_SWIZZLE_W, XM_SWIZZLE_Z, XM_SWIZZLE_W, MT.r[3]);
    V0[1] := XMVectorSwizzle(XM_SWIZZLE_X, XM_SWIZZLE_X, XM_SWIZZLE_Y, XM_SWIZZLE_Y, MT.r[0]);
    V1[1] := XMVectorSwizzle(XM_SWIZZLE_Z, XM_SWIZZLE_W, XM_SWIZZLE_Z, XM_SWIZZLE_W, MT.r[1]);
    V0[2] := XMVectorPermute(XM_PERMUTE_0X, XM_PERMUTE_0Z, XM_PERMUTE_1X, XM_PERMUTE_1Z, MT.r[2], MT.r[0]);
    V1[2] := XMVectorPermute(XM_PERMUTE_0Y, XM_PERMUTE_0W, XM_PERMUTE_1Y, XM_PERMUTE_1W, MT.r[3], MT.r[1]);

    D0 := XMVectorMultiply(V0[0], V1[0]);
    D1 := XMVectorMultiply(V0[1], V1[1]);
    D2 := XMVectorMultiply(V0[2], V1[2]);

    V0[0] := XMVectorSwizzle(XM_SWIZZLE_Z, XM_SWIZZLE_W, XM_SWIZZLE_Z, XM_SWIZZLE_W, MT.r[2]);
    V1[0] := XMVectorSwizzle(XM_SWIZZLE_X, XM_SWIZZLE_X, XM_SWIZZLE_Y, XM_SWIZZLE_Y, MT.r[3]);
    V0[1] := XMVectorSwizzle(XM_SWIZZLE_Z, XM_SWIZZLE_W, XM_SWIZZLE_Z, XM_SWIZZLE_W, MT.r[0]);
    V1[1] := XMVectorSwizzle(XM_SWIZZLE_X, XM_SWIZZLE_X, XM_SWIZZLE_Y, XM_SWIZZLE_Y, MT.r[1]);
    V0[2] := XMVectorPermute(XM_PERMUTE_0Y, XM_PERMUTE_0W, XM_PERMUTE_1Y, XM_PERMUTE_1W, MT.r[2], MT.r[0]);
    V1[2] := XMVectorPermute(XM_PERMUTE_0X, XM_PERMUTE_0Z, XM_PERMUTE_1X, XM_PERMUTE_1Z, MT.r[3], MT.r[1]);

    D0 := XMVectorNegativeMultiplySubtract(V0[0], V1[0], D0);
    D1 := XMVectorNegativeMultiplySubtract(V0[1], V1[1], D1);
    D2 := XMVectorNegativeMultiplySubtract(V0[2], V1[2], D2);

    V0[0] := XMVectorSwizzle(XM_SWIZZLE_Y, XM_SWIZZLE_Z, XM_SWIZZLE_X, XM_SWIZZLE_Y, MT.r[1]);
    V1[0] := XMVectorPermute(XM_PERMUTE_1Y, XM_PERMUTE_0Y, XM_PERMUTE_0W, XM_PERMUTE_0X, D0, D2);
    V0[1] := XMVectorSwizzle(XM_SWIZZLE_Z, XM_SWIZZLE_X, XM_SWIZZLE_Y, XM_SWIZZLE_X, MT.r[0]);
    V1[1] := XMVectorPermute(XM_PERMUTE_0W, XM_PERMUTE_1Y, XM_PERMUTE_0Y, XM_PERMUTE_0Z, D0, D2);
    V0[2] := XMVectorSwizzle(XM_SWIZZLE_Y, XM_SWIZZLE_Z, XM_SWIZZLE_X, XM_SWIZZLE_Y, MT.r[3]);
    V1[2] := XMVectorPermute(XM_PERMUTE_1W, XM_PERMUTE_0Y, XM_PERMUTE_0W, XM_PERMUTE_0X, D1, D2);
    V0[3] := XMVectorSwizzle(XM_SWIZZLE_Z, XM_SWIZZLE_X, XM_SWIZZLE_Y, XM_SWIZZLE_X, MT.r[2]);
    V1[3] := XMVectorPermute(XM_PERMUTE_0W, XM_PERMUTE_1W, XM_PERMUTE_0Y, XM_PERMUTE_0Z, D1, D2);

    C0 := XMVectorMultiply(V0[0], V1[0]);
    C2 := XMVectorMultiply(V0[1], V1[1]);
    C4 := XMVectorMultiply(V0[2], V1[2]);
    C6 := XMVectorMultiply(V0[3], V1[3]);

    V0[0] := XMVectorSwizzle(XM_SWIZZLE_Z, XM_SWIZZLE_W, XM_SWIZZLE_Y, XM_SWIZZLE_Z, MT.r[1]);
    V1[0] := XMVectorPermute(XM_PERMUTE_0W, XM_PERMUTE_0X, XM_PERMUTE_0Y, XM_PERMUTE_1X, D0, D2);
    V0[1] := XMVectorSwizzle(XM_SWIZZLE_W, XM_SWIZZLE_Z, XM_SWIZZLE_W, XM_SWIZZLE_Y, MT.r[0]);
    V1[1] := XMVectorPermute(XM_PERMUTE_0Z, XM_PERMUTE_0Y, XM_PERMUTE_1X, XM_PERMUTE_0X, D0, D2);
    V0[2] := XMVectorSwizzle(XM_SWIZZLE_Z, XM_SWIZZLE_W, XM_SWIZZLE_Y, XM_SWIZZLE_Z, MT.r[3]);
    V1[2] := XMVectorPermute(XM_PERMUTE_0W, XM_PERMUTE_0X, XM_PERMUTE_0Y, XM_PERMUTE_1Z, D1, D2);
    V0[3] := XMVectorSwizzle(XM_SWIZZLE_W, XM_SWIZZLE_Z, XM_SWIZZLE_W, XM_SWIZZLE_Y, MT.r[2]);
    V1[3] := XMVectorPermute(XM_PERMUTE_0Z, XM_PERMUTE_0Y, XM_PERMUTE_1Z, XM_PERMUTE_0X, D1, D2);

    C0 := XMVectorNegativeMultiplySubtract(V0[0], V1[0], C0);
    C2 := XMVectorNegativeMultiplySubtract(V0[1], V1[1], C2);
    C4 := XMVectorNegativeMultiplySubtract(V0[2], V1[2], C4);
    C6 := XMVectorNegativeMultiplySubtract(V0[3], V1[3], C6);

    V0[0] := XMVectorSwizzle(XM_SWIZZLE_W, XM_SWIZZLE_X, XM_SWIZZLE_W, XM_SWIZZLE_X, MT.r[1]);
    V1[0] := XMVectorPermute(XM_PERMUTE_0Z, XM_PERMUTE_1Y, XM_PERMUTE_1X, XM_PERMUTE_0Z, D0, D2);
    V0[1] := XMVectorSwizzle(XM_SWIZZLE_Y, XM_SWIZZLE_W, XM_SWIZZLE_X, XM_SWIZZLE_Z, MT.r[0]);
    V1[1] := XMVectorPermute(XM_PERMUTE_1Y, XM_PERMUTE_0X, XM_PERMUTE_0W, XM_PERMUTE_1X, D0, D2);
    V0[2] := XMVectorSwizzle(XM_SWIZZLE_W, XM_SWIZZLE_X, XM_SWIZZLE_W, XM_SWIZZLE_X, MT.r[3]);
    V1[2] := XMVectorPermute(XM_PERMUTE_0Z, XM_PERMUTE_1W, XM_PERMUTE_1Z, XM_PERMUTE_0Z, D1, D2);
    V0[3] := XMVectorSwizzle(XM_SWIZZLE_Y, XM_SWIZZLE_W, XM_SWIZZLE_X, XM_SWIZZLE_Z, MT.r[2]);
    V1[3] := XMVectorPermute(XM_PERMUTE_1W, XM_PERMUTE_0X, XM_PERMUTE_0W, XM_PERMUTE_1Z, D1, D2);

    C1 := XMVectorNegativeMultiplySubtract(V0[0], V1[0], C0);
    C0 := XMVectorMultiplyAdd(V0[0], V1[0], C0);
    C3 := XMVectorMultiplyAdd(V0[1], V1[1], C2);
    C2 := XMVectorNegativeMultiplySubtract(V0[1], V1[1], C2);
    C5 := XMVectorNegativeMultiplySubtract(V0[2], V1[2], C4);
    C4 := XMVectorMultiplyAdd(V0[2], V1[2], C4);
    C7 := XMVectorMultiplyAdd(V0[3], V1[3], C6);
    C6 := XMVectorNegativeMultiplySubtract(V0[3], V1[3], C6);

    r.r[0] := XMVectorSelect(C0, C1, g_XMSelect0101);
    r.r[1] := XMVectorSelect(C2, C3, g_XMSelect0101);
    r.r[2] := XMVectorSelect(C4, C5, g_XMSelect0101);
    r.r[3] := XMVectorSelect(C6, C7, g_XMSelect0101);

    Determinant := XMVector4Dot(r.r[0], MT.r[0]);

    if (@pDeterminant <> nil) then
        pDeterminant := Determinant;

    Reciprocal := XMVectorReciprocal(Determinant);

    Result.r[0] := XMVectorMultiply(r.r[0], Reciprocal);
    Result.r[1] := XMVectorMultiply(r.r[1], Reciprocal);
    Result.r[2] := XMVectorMultiply(r.r[2], Reciprocal);
    Result.r[3] := XMVectorMultiply(r.r[3], Reciprocal);
end;



function XMMatrixVectorTensorProduct(V1: TFXMVECTOR; V2: TFXMVECTOR): TXMMATRIX;
begin
    Result.r[0] := XMVectorMultiply(XMVectorSwizzle(0, 0, 0, 0, V1), V2);
    Result.r[1] := XMVectorMultiply(XMVectorSwizzle(1, 1, 1, 1, V1), V2);
    Result.r[2] := XMVectorMultiply(XMVectorSwizzle(2, 2, 2, 2, V1), V2);
    Result.r[3] := XMVectorMultiply(XMVectorSwizzle(3, 3, 3, 3, V1), V2);
end;



function XMMatrixDeterminant(m: TFXMMATRIX): TXMVECTOR;
const
    Sign: TXMVECTOR = (vector4_f32: (1.0, -1.0, 1.0, -1.0));
var
    V0, V1, V2, V3, V4, V5: TXMVECTOR;
    P0, P1, P2: TXMVECTOR;
    s, r: TXMVECTOR;
begin
    V0 := XMVectorSwizzle(XM_SWIZZLE_Y, XM_SWIZZLE_X, XM_SWIZZLE_X, XM_SWIZZLE_X, m.r[2]);
    V1 := XMVectorSwizzle(XM_SWIZZLE_Z, XM_SWIZZLE_Z, XM_SWIZZLE_Y, XM_SWIZZLE_Y, m.r[3]);
    V2 := XMVectorSwizzle(XM_SWIZZLE_Y, XM_SWIZZLE_X, XM_SWIZZLE_X, XM_SWIZZLE_X, m.r[2]);
    V3 := XMVectorSwizzle(XM_SWIZZLE_W, XM_SWIZZLE_W, XM_SWIZZLE_W, XM_SWIZZLE_Z, m.r[3]);
    V4 := XMVectorSwizzle(XM_SWIZZLE_Z, XM_SWIZZLE_Z, XM_SWIZZLE_Y, XM_SWIZZLE_Y, m.r[2]);
    V5 := XMVectorSwizzle(XM_SWIZZLE_W, XM_SWIZZLE_W, XM_SWIZZLE_W, XM_SWIZZLE_Z, m.r[3]);

    P0 := XMVectorMultiply(V0, V1);
    P1 := XMVectorMultiply(V2, V3);
    P2 := XMVectorMultiply(V4, V5);

    V0 := XMVectorSwizzle(XM_SWIZZLE_Z, XM_SWIZZLE_Z, XM_SWIZZLE_Y, XM_SWIZZLE_Y, m.r[2]);
    V1 := XMVectorSwizzle(XM_SWIZZLE_Y, XM_SWIZZLE_X, XM_SWIZZLE_X, XM_SWIZZLE_X, m.r[3]);
    V2 := XMVectorSwizzle(XM_SWIZZLE_W, XM_SWIZZLE_W, XM_SWIZZLE_W, XM_SWIZZLE_Z, m.r[2]);
    V3 := XMVectorSwizzle(XM_SWIZZLE_Y, XM_SWIZZLE_X, XM_SWIZZLE_X, XM_SWIZZLE_X, m.r[3]);
    V4 := XMVectorSwizzle(XM_SWIZZLE_W, XM_SWIZZLE_W, XM_SWIZZLE_W, XM_SWIZZLE_Z, m.r[2]);
    V5 := XMVectorSwizzle(XM_SWIZZLE_Z, XM_SWIZZLE_Z, XM_SWIZZLE_Y, XM_SWIZZLE_Y, m.r[3]);

    P0 := XMVectorNegativeMultiplySubtract(V0, V1, P0);
    P1 := XMVectorNegativeMultiplySubtract(V2, V3, P1);
    P2 := XMVectorNegativeMultiplySubtract(V4, V5, P2);

    V0 := XMVectorSwizzle(XM_SWIZZLE_W, XM_SWIZZLE_W, XM_SWIZZLE_W, XM_SWIZZLE_Z, m.r[1]);
    V1 := XMVectorSwizzle(XM_SWIZZLE_Z, XM_SWIZZLE_Z, XM_SWIZZLE_Y, XM_SWIZZLE_Y, m.r[1]);
    V2 := XMVectorSwizzle(XM_SWIZZLE_Y, XM_SWIZZLE_X, XM_SWIZZLE_X, XM_SWIZZLE_X, m.r[1]);

    s := XMVectorMultiply(m.r[0], Sign);
    r := XMVectorMultiply(V0, P0);
    r := XMVectorNegativeMultiplySubtract(V1, P1, r);
    r := XMVectorMultiplyAdd(V2, P2, r);

    Result := XMVector4Dot(s, r);
end;



function XMMatrixDecompose(out outScale: TXMVECTOR; out outRotQuat: TXMVECTOR; out outTrans: TXMVECTOR; m: TFXMMATRIX): boolean;
begin

end;


// ------------------------------------------------------------------------------
// Transformation operations
// ------------------------------------------------------------------------------

function XMMatrixIdentity(): TXMMATRIX;
begin
    Result.r[0] := g_XMIdentityR0;
    Result.r[1] := g_XMIdentityR1;
    Result.r[2] := g_XMIdentityR2;
    Result.r[3] := g_XMIdentityR3;
end;



function XMMatrixSet(m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33: single): TXMMATRIX;
begin
    Result.m[0][0] := m00;
    Result.m[0][1] := m01;
    Result.m[0][2] := m02;
    Result.m[0][3] := m03;
    Result.m[1][0] := m10;
    Result.m[1][1] := m11;
    Result.m[1][2] := m12;
    Result.m[1][3] := m13;
    Result.m[2][0] := m20;
    Result.m[2][1] := m21;
    Result.m[2][2] := m22;
    Result.m[2][3] := m23;
    Result.m[3][0] := m30;
    Result.m[3][1] := m31;
    Result.m[3][2] := m32;
    Result.m[3][3] := m33;
end;



function XMMatrixTranslation(OffsetX, OffsetY, OffsetZ: single): TXMMATRIX;
begin
    Result.m[0][0] := 1.0;
    Result.m[0][1] := 0.0;
    Result.m[0][2] := 0.0;
    Result.m[0][3] := 0.0;

    Result.m[1][0] := 0.0;
    Result.m[1][1] := 1.0;
    Result.m[1][2] := 0.0;
    Result.m[1][3] := 0.0;

    Result.m[2][0] := 0.0;
    Result.m[2][1] := 0.0;
    Result.m[2][2] := 1.0;
    Result.m[2][3] := 0.0;

    Result.m[3][0] := OffsetX;
    Result.m[3][1] := OffsetY;
    Result.m[3][2] := OffsetZ;
    Result.m[3][3] := 1.0;
end;



function XMMatrixTranslationFromVector(Offset: TFXMVECTOR): TXMMATRIX;
begin
    Result.m[0][0] := 1.0;
    Result.m[0][1] := 0.0;
    Result.m[0][2] := 0.0;
    Result.m[0][3] := 0.0;

    Result.m[1][0] := 0.0;
    Result.m[1][1] := 1.0;
    Result.m[1][2] := 0.0;
    Result.m[1][3] := 0.0;

    Result.m[2][0] := 0.0;
    Result.m[2][1] := 0.0;
    Result.m[2][2] := 1.0;
    Result.m[2][3] := 0.0;

    Result.m[3][0] := Offset.vector4_f32[0];
    Result.m[3][1] := Offset.vector4_f32[1];
    Result.m[3][2] := Offset.vector4_f32[2];
    Result.m[3][3] := 1.0;
end;



function XMMatrixScaling(ScaleX, ScaleY, ScaleZ: single): TXMMATRIX;
begin
    Result.m[0][0] := ScaleX;
    Result.m[0][1] := 0.0;
    Result.m[0][2] := 0.0;
    Result.m[0][3] := 0.0;

    Result.m[1][0] := 0.0;
    Result.m[1][1] := ScaleY;
    Result.m[1][2] := 0.0;
    Result.m[1][3] := 0.0;

    Result.m[2][0] := 0.0;
    Result.m[2][1] := 0.0;
    Result.m[2][2] := ScaleZ;
    Result.m[2][3] := 0.0;

    Result.m[3][0] := 0;
    Result.m[3][1] := 0;
    Result.m[3][2] := 0;
    Result.m[3][3] := 1.0;
end;



function XMMatrixScalingFromVector(Scale: TFXMVECTOR): TXMMATRIX;
begin
    Result.m[0][0] := Scale.vector4_f32[0];
    Result.m[0][1] := 0.0;
    Result.m[0][2] := 0.0;
    Result.m[0][3] := 0.0;

    Result.m[1][0] := 0.0;
    Result.m[1][1] := Scale.vector4_f32[1];
    Result.m[1][2] := 0.0;
    Result.m[1][3] := 0.0;

    Result.m[2][0] := 0.0;
    Result.m[2][1] := 0.0;
    Result.m[2][2] := Scale.vector4_f32[2];
    Result.m[2][3] := 0.0;

    Result.m[3][0] := 0;
    Result.m[3][1] := 0;
    Result.m[3][2] := 0;
    Result.m[3][3] := 1.0;
end;



function XMMatrixRotationX(Angle: single): TXMMATRIX;
var
    fSinAngle: single;
    fCosAngle: single;

begin
    XMScalarSinCos(fSinAngle, fCosAngle, Angle);

    Result.m[0][0] := 1.0;
    Result.m[0][1] := 0.0;
    Result.m[0][2] := 0.0;
    Result.m[0][3] := 0.0;

    Result.m[1][0] := 0.0;
    Result.m[1][1] := fCosAngle;
    Result.m[1][2] := fSinAngle;
    Result.m[1][3] := 0.0;

    Result.m[2][0] := 0.0;
    Result.m[2][1] := -fSinAngle;
    Result.m[2][2] := fCosAngle;
    Result.m[2][3] := 0.0;

    Result.m[3][0] := 0;
    Result.m[3][1] := 0;
    Result.m[3][2] := 0;
    Result.m[3][3] := 1.0;
end;



function XMMatrixRotationY(Angle: single): TXMMATRIX;
var
    fSinAngle: single;
    fCosAngle: single;

begin
    XMScalarSinCos(fSinAngle, fCosAngle, Angle);

    Result.m[0][0] := fCosAngle;
    Result.m[0][1] := 0.0;
    Result.m[0][2] := -fSinAngle;
    Result.m[0][3] := 0.0;

    Result.m[1][0] := 0.0;
    Result.m[1][1] := 1.0;
    Result.m[1][2] := 0.0;
    Result.m[1][3] := 0.0;

    Result.m[2][0] := fSinAngle;
    Result.m[2][1] := 0.0;
    Result.m[2][2] := fCosAngle;
    Result.m[2][3] := 0.0;

    Result.m[3][0] := 0;
    Result.m[3][1] := 0;
    Result.m[3][2] := 0;
    Result.m[3][3] := 1.0;
end;



function XMMatrixRotationZ(Angle: single): TXMMATRIX;
var
    fSinAngle: single;
    fCosAngle: single;

begin
    XMScalarSinCos(fSinAngle, fCosAngle, Angle);

    Result.m[0][0] := fCosAngle;
    Result.m[0][1] := fSinAngle;
    Result.m[0][2] := 0.0;
    Result.m[0][3] := 0.0;

    Result.m[1][0] := -fSinAngle;
    Result.m[1][1] := fCosAngle;
    Result.m[1][2] := 0.0;
    Result.m[1][3] := 0.0;

    Result.m[2][0] := 0.0;
    Result.m[2][1] := 0.0;
    Result.m[2][2] := 1.0;
    Result.m[2][3] := 0.0;

    Result.m[3][0] := 0;
    Result.m[3][1] := 0;
    Result.m[3][2] := 0;
    Result.m[3][3] := 1.0;
end;



function XMMatrixRotationRollPitchYaw(Pitch, Yaw, Roll: single): TXMMATRIX;
var
    Angles: TXMVECTOR;
    cp, sp, cy, sy, cr, sr: single;
begin
{$if defined(_XM_NO_INTRINSICS_)}
    cp := cos(Pitch);
    sp := sin(Pitch);

    cy := cos(Yaw);
    sy := sin(Yaw);

    cr := cos(Roll);
    sr := sin(Roll);


    Result.m[0][0] := cr * cy + sr * sp * sy;
    Result.m[0][1] := sr * cp;
    Result.m[0][2] := sr * sp * cy - cr * sy;
    Result.m[0][3] := 0.0;

    Result.m[1][0] := cr * sp * sy - sr * cy;
    Result.m[1][1] := cr * cp;
    Result.m[1][2] := sr * sy + cr * sp * cy;
    Result.m[1][3] := 0.0;

    Result.m[2][0] := cp * sy;
    Result.m[2][1] := -sp;
    Result.m[2][2] := cp * cy;
    Result.m[2][3] := 0.0;

    Result.m[3][0] := 0.0;
    Result.m[3][1] := 0.0;
    Result.m[3][2] := 0.0;
    Result.m[3][3] := 1.0;
{$else}
    Angles := XMVectorSet(Pitch, Yaw, Roll, 0.0);
    Result := XMMatrixRotationRollPitchYawFromVector(Angles);
{$ENDIF}
end;

// <Pitch, Yaw, Roll, undefined>

function XMMatrixRotationRollPitchYawFromVector(Angles: TFXMVECTOR): TXMMATRIX;
var
    Q: TXMVECTOR;
    cp, sp, cy, sy, cr, sr: single;

begin
{$if defined(_XM_NO_INTRINSICS_)}
    cp := cos(Angles.f[0]);
    sp := sin(Angles.f[0]);

    cy := cos(Angles.f[1]);
    sy := sin(Angles.f[1]);

    cr := cos(Angles.f[2]);
    sr := sin(Angles.f[2]);


    Result.m[0][0] := cr * cy + sr * sp * sy;
    Result.m[0][1] := sr * cp;
    Result.m[0][2] := sr * sp * cy - cr * sy;
    Result.m[0][3] := 0.0;

    Result.m[1][0] := cr * sp * sy - sr * cy;
    Result.m[1][1] := cr * cp;
    Result.m[1][2] := sr * sy + cr * sp * cy;
    Result.m[1][3] := 0.0;

    Result.m[2][0] := cp * sy;
    Result.m[2][1] := -sp;
    Result.m[2][2] := cp * cy;
    Result.m[2][3] := 0.0;

    Result.m[3][0] := 0.0;
    Result.m[3][1] := 0.0;
    Result.m[3][2] := 0.0;
    Result.m[3][3] := 1.0;

{$else}
    Q := XMQuaternionRotationRollPitchYawFromVector(Angles);
    Result := XMMatrixRotationQuaternion(Q);
{$ENDIF}
end;



function XMMatrixRotationNormal(NormalAxis: TFXMVECTOR; Angle: single): TXMMATRIX;
var
    fSinAngle: single;
    fCosAngle: single;
    a: TXMVECTOR;
    C0, C1, C2: TXMVECTOR;
    N0, N1: TXMVECTOR;
    r0, r1, r2: TXMVECTOR;
    V0, V1, V2: TXMVECTOR;
begin

    XMScalarSinCos(fSinAngle, fCosAngle, Angle);

    a := XMVectorSet(fSinAngle, fCosAngle, 1.0 - fCosAngle, 0.0);

    C2 := XMVectorSplatZ(a);
    C1 := XMVectorSplatY(a);
    C0 := XMVectorSplatX(a);

    N0 := XMVectorSwizzle(XM_SWIZZLE_Y, XM_SWIZZLE_Z, XM_SWIZZLE_X, XM_SWIZZLE_W, NormalAxis);
    N1 := XMVectorSwizzle(XM_SWIZZLE_Z, XM_SWIZZLE_X, XM_SWIZZLE_Y, XM_SWIZZLE_W, NormalAxis);

    V0 := XMVectorMultiply(C2, N0);
    V0 := XMVectorMultiply(V0, N1);

    r0 := XMVectorMultiply(C2, NormalAxis);
    r0 := XMVectorMultiplyAdd(r0, NormalAxis, C1);

    r1 := XMVectorMultiplyAdd(C0, NormalAxis, V0);
    r2 := XMVectorNegativeMultiplySubtract(C0, NormalAxis, V0);

    V0 := XMVectorSelect(a, r0, g_XMSelect1110);
    V1 := XMVectorPermute(XM_PERMUTE_0Z, XM_PERMUTE_1Y, XM_PERMUTE_1Z, XM_PERMUTE_0X, r1, r2);
    V2 := XMVectorPermute(XM_PERMUTE_0Y, XM_PERMUTE_1X, XM_PERMUTE_0Y, XM_PERMUTE_1X, r1, r2);

    Result.r[0] := XMVectorPermute(XM_PERMUTE_0X, XM_PERMUTE_1X, XM_PERMUTE_1Y, XM_PERMUTE_0W, V0, V1);
    Result.r[1] := XMVectorPermute(XM_PERMUTE_1Z, XM_PERMUTE_0Y, XM_PERMUTE_1W, XM_PERMUTE_0W, V0, V1);
    Result.r[2] := XMVectorPermute(XM_PERMUTE_1X, XM_PERMUTE_1Y, XM_PERMUTE_0Z, XM_PERMUTE_0W, V0, V2);
    Result.r[3] := g_XMIdentityR3;
end;



function XMMatrixRotationAxis(Axis: TFXMVECTOR; Angle: single): TXMMATRIX;
var
    Normal: TXMVECTOR;
begin
    Normal := XMVector3Normalize(Axis);
    Result := XMMatrixRotationNormal(Normal, Angle);
end;



function XMMatrixRotationQuaternion(Quaternion: TFXMVECTOR): TXMMATRIX;
const
    Constant1110: TXMVECTOR = (vector4_f32: (1.0, 1.0, 1.0, 0.0));
var
    Q0, Q1: TXMVECTOR;
    V0, V1, V2: TXMVECTOR;
    r0, r1, r2: TXMVECTOR;
    qx, qxx, qy, qyy, qz, qzz, qw: single;
begin
    {$if defined(_XM_NO_INTRINSICS_)}

    qx := Quaternion.f[0];
    qxx := qx * qx;

    qy := Quaternion.f[1];
    qyy := qy * qy;

    qz := Quaternion.f[2];
    qzz := qz * qz;

    qw := Quaternion.f[3];

    ;
    Result.m[0][0] := 1.0 - 2.0 * qyy - 2.0 * qzz;
    Result.m[0][1] := 2.0 * qx * qy + 2.0 * qz * qw;
    Result.m[0][2] := 2.0 * qx * qz - 2.0 * qy * qw;
    Result.m[0][3] := 0.0;

    Result.m[1][0] := 2.0 * qx * qy - 2.0 * qz * qw;
    Result.m[1][1] := 1.0 - 2.0 * qxx - 2.0 * qzz;
    Result.m[1][2] := 2.0 * qy * qz + 2.0 * qx * qw;
    Result.m[1][3] := 0.0;

    Result.m[2][0] := 2.0 * qx * qz + 2.0 * qy * qw;
    Result.m[2][1] := 2.0 * qy * qz - 2.0 * qx * qw;
    Result.m[2][2] := 1.0 - 2.0 * qxx - 2.0 * qyy;
    Result.m[2][3] := 0.0;

    Result.m[3][0] := 0.0;
    Result.m[3][1] := 0.0;
    Result.m[3][2] := 0.0;
    Result.m[3][3] := 1.0;


{$elseif defined(_XM_ARM_NEON_INTRINSICS_)}
    Q0 := XMVectorAdd(Quaternion, Quaternion);
    Q1 := XMVectorMultiply(Quaternion, Q0);

    V0 := XMVectorPermute(XM_PERMUTE_0Y, XM_PERMUTE_0X, XM_PERMUTE_0X, XM_PERMUTE_1W, Q1, Constant1110);
    V1 := XMVectorPermute(XM_PERMUTE_0Z, XM_PERMUTE_0Z, XM_PERMUTE_0Y, XM_PERMUTE_1W, Q1, Constant1110);
    r0 := XMVectorSubtract(Constant1110, V0);
    r0 := XMVectorSubtract(r0, V1);

    V0 := XMVectorSwizzle(XM_SWIZZLE_X, XM_SWIZZLE_X, XM_SWIZZLE_Y, XM_SWIZZLE_W, Quaternion);
    V1 := XMVectorSwizzle(XM_SWIZZLE_Z, XM_SWIZZLE_Y, XM_SWIZZLE_Z, XM_SWIZZLE_W, Q0);
    V0 := XMVectorMultiply(V0, V1);

    V1 := XMVectorSplatW(Quaternion);
    V2 := XMVectorSwizzle(XM_SWIZZLE_Y, XM_SWIZZLE_Z, XM_SWIZZLE_X, XM_SWIZZLE_W, Q0);
    V1 := XMVectorMultiply(V1, V2);

    r1 := XMVectorAdd(V0, V1);
    r2 := XMVectorSubtract(V0, V1);

    V0 := XMVectorPermute(XM_PERMUTE_0Y, XM_PERMUTE_1X, XM_PERMUTE_1Y, XM_PERMUTE_0Z, r1, r2);
    V1 := XMVectorPermute(XM_PERMUTE_0X, XM_PERMUTE_1Z, XM_PERMUTE_0X, XM_PERMUTE_1Z, r1, r2);

    Result.r[0] := XMVectorPermute(XM_PERMUTE_0X, XM_PERMUTE_1X, XM_PERMUTE_1Y, XM_PERMUTE_0W, r0, V0);
    Result.r[1] := XMVectorPermute(XM_PERMUTE_1Z, XM_PERMUTE_0Y, XM_PERMUTE_1W, XM_PERMUTE_0W, r0, V0);
    Result.r[2] := XMVectorPermute(XM_PERMUTE_1X, XM_PERMUTE_1Y, XM_PERMUTE_0Z, XM_PERMUTE_0W, r0, V1);
    Result.r[3] := g_XMIdentityR3;
{$ENDIF}
end;



function XMMatrixTransformation2D(ScalingOrigin: TFXMVECTOR; ScalingOrientation: single; Scaling: TFXMVECTOR; RotationOrigin: TFXMVECTOR; Rotation: single; Translation: TGXMVECTOR): TXMMATRIX;
var
    VScalingOrigin, NegScalingOrigin: TXMVECTOR;
    MScalingOriginI, MScalingOrientation, MScalingOrientationT: TXMMATRIX;
    VScaling, VRotationOrigin, VTranslation: TXMVECTOR;
    MScaling, MRotation: TXMMATRIX;
begin
    // M = Inverse(MScalingOrigin) * Transpose(MScalingOrientation) * MScaling * MScalingOrientation *
    // MScalingOrigin * Inverse(MRotationOrigin) * MRotation * MRotationOrigin * MTranslation;

    VScalingOrigin := XMVectorSelect(g_XMSelect1100, ScalingOrigin, g_XMSelect1100);
    NegScalingOrigin := XMVectorNegate(VScalingOrigin);

    MScalingOriginI := XMMatrixTranslationFromVector(NegScalingOrigin);
    MScalingOrientation := XMMatrixRotationZ(ScalingOrientation);
    MScalingOrientationT := XMMatrixTranspose(MScalingOrientation);
    VScaling := XMVectorSelect(g_XMOne, Scaling, g_XMSelect1100);
    MScaling := XMMatrixScalingFromVector(VScaling);
    VRotationOrigin := XMVectorSelect(g_XMSelect1100, RotationOrigin, g_XMSelect1100);
    MRotation := XMMatrixRotationZ(Rotation);
    VTranslation := XMVectorSelect(g_XMSelect1100, Translation, g_XMSelect1100);

    Result := XMMatrixMultiply(MScalingOriginI, MScalingOrientationT);
    Result := XMMatrixMultiply(Result, MScaling);
    Result := XMMatrixMultiply(Result, MScalingOrientation);
    Result.r[3] := XMVectorAdd(Result.r[3], VScalingOrigin);
    Result.r[3] := XMVectorSubtract(Result.r[3], VRotationOrigin);
    Result := XMMatrixMultiply(Result, MRotation);
    Result.r[3] := XMVectorAdd(Result.r[3], VRotationOrigin);
    Result.r[3] := XMVectorAdd(Result.r[3], VTranslation);
end;



function XMMatrixTransformation(ScalingOrigin: TFXMVECTOR; ScalingOrientationQuaternion: TFXMVECTOR; Scaling: TFXMVECTOR; RotationOrigin: TGXMVECTOR; RotationQuaternion: THXMVECTOR; Translation: THXMVECTOR): TXMMATRIX;
var
    VScalingOrigin, NegScalingOrigin: TXMVECTOR;
    MScalingOriginI, MScalingOrientation, MScalingOrientationT, MScaling: TXMMATRIX;
    VRotationOrigin, VTranslation: TXMVECTOR;
    MRotation: TXMMATRIX;
begin
    // M = Inverse(MScalingOrigin) * Transpose(MScalingOrientation) * MScaling * MScalingOrientation *
    // MScalingOrigin * Inverse(MRotationOrigin) * MRotation * MRotationOrigin * MTranslation;

    VScalingOrigin := XMVectorSelect(g_XMSelect1110, ScalingOrigin, g_XMSelect1110);
    NegScalingOrigin := XMVectorNegate(ScalingOrigin);

    MScalingOriginI := XMMatrixTranslationFromVector(NegScalingOrigin);
    MScalingOrientation := XMMatrixRotationQuaternion(ScalingOrientationQuaternion);
    MScalingOrientationT := XMMatrixTranspose(MScalingOrientation);
    MScaling := XMMatrixScalingFromVector(Scaling);
    VRotationOrigin := XMVectorSelect(g_XMSelect1110, RotationOrigin, g_XMSelect1110);
    MRotation := XMMatrixRotationQuaternion(RotationQuaternion);
    VTranslation := XMVectorSelect(g_XMSelect1110, Translation, g_XMSelect1110);

    Result := XMMatrixMultiply(MScalingOriginI, MScalingOrientationT);
    Result := XMMatrixMultiply(Result, MScaling);
    Result := XMMatrixMultiply(Result, MScalingOrientation);
    Result.r[3] := XMVectorAdd(Result.r[3], VScalingOrigin);
    Result.r[3] := XMVectorSubtract(Result.r[3], VRotationOrigin);
    Result := XMMatrixMultiply(Result, MRotation);
    Result.r[3] := XMVectorAdd(Result.r[3], VRotationOrigin);
    Result.r[3] := XMVectorAdd(Result.r[3], VTranslation);
end;



function XMMatrixAffineTransformation2D(Scaling: TFXMVECTOR; RotationOrigin: TFXMVECTOR; Rotation: single; Translation: TFXMVECTOR): TXMMATRIX;
var
    VScaling, VRotationOrigin, VTranslation: TXMVECTOR;
    MScaling, MRotation: TXMMATRIX;
begin
    // M = MScaling * Inverse(MRotationOrigin) * MRotation * MRotationOrigin * MTranslation;
    VScaling := XMVectorSelect(g_XMOne, Scaling, g_XMSelect1100);
    MScaling := XMMatrixScalingFromVector(VScaling);
    VRotationOrigin := XMVectorSelect(g_XMSelect1100, RotationOrigin, g_XMSelect1100);
    MRotation := XMMatrixRotationZ(Rotation);
    VTranslation := XMVectorSelect(g_XMSelect1100, Translation, g_XMSelect1100);

    Result := MScaling;
    Result.r[3] := XMVectorSubtract(Result.r[3], VRotationOrigin);
    Result := XMMatrixMultiply(Result, MRotation);
    Result.r[3] := XMVectorAdd(Result.r[3], VRotationOrigin);
    Result.r[3] := XMVectorAdd(Result.r[3], VTranslation);
end;



function XMMatrixAffineTransformation(Scaling: TFXMVECTOR; RotationOrigin: TFXMVECTOR; RotationQuaternion: TFXMVECTOR; Translation: TGXMVECTOR): TXMMATRIX;
var
    MScaling, MRotation: TXMMATRIX;
    VRotationOrigin, VTranslation: TXMVECTOR;
begin
    // M = MScaling * Inverse(MRotationOrigin) * MRotation * MRotationOrigin * MTranslation;
    MScaling := XMMatrixScalingFromVector(Scaling);
    VRotationOrigin := XMVectorSelect(g_XMSelect1110, RotationOrigin, g_XMSelect1110);
    MRotation := XMMatrixRotationQuaternion(RotationQuaternion);
    VTranslation := XMVectorSelect(g_XMSelect1110, Translation, g_XMSelect1110);

    Result := MScaling;
    Result.r[3] := XMVectorSubtract(Result.r[3], VRotationOrigin);
    Result := XMMatrixMultiply(Result, MRotation);
    Result.r[3] := XMVectorAdd(Result.r[3], VRotationOrigin);
    Result.r[3] := XMVectorAdd(Result.r[3], VTranslation);
end;



function XMMatrixReflect(ReflectionPlane: TFXMVECTOR): TXMMATRIX;
const
    NegativeTwo: TXMVECTOR = (vector4_f32: (-2.0, -2.0, -2.0, 0.0));
var
    P, s, a, b, C, D: TXMVECTOR;
begin
    P := XMPlaneNormalize(ReflectionPlane);
    s := XMVectorMultiply(P, NegativeTwo);

    a := XMVectorSplatX(P);
    b := XMVectorSplatY(P);
    C := XMVectorSplatZ(P);
    D := XMVectorSplatW(P);

    Result.r[0] := XMVectorMultiplyAdd(a, s, g_XMIdentityR0);
    Result.r[1] := XMVectorMultiplyAdd(b, s, g_XMIdentityR1);
    Result.r[2] := XMVectorMultiplyAdd(C, s, g_XMIdentityR2);
    Result.r[3] := XMVectorMultiplyAdd(D, s, g_XMIdentityR3);
end;



function XMMatrixShadow(ShadowPlane: TFXMVECTOR; LightPosition: TFXMVECTOR): TXMMATRIX;
const
    Select0001: TXMVECTOR = (vector4_u32: (XM_SELECT_0, XM_SELECT_0, XM_SELECT_0, XM_SELECT_1));
var
    P, Dot: TXMVECTOR;
    a, b, C, D: TXMVECTOR;
begin
    P := XMPlaneNormalize(ShadowPlane);
    Dot := XMPlaneDot(P, LightPosition);
    P := XMVectorNegate(P);
    D := XMVectorSplatW(P);
    C := XMVectorSplatZ(P);
    b := XMVectorSplatY(P);
    a := XMVectorSplatX(P);
    Dot := XMVectorSelect(Select0001, Dot, Select0001);

    Result.r[3] := XMVectorMultiplyAdd(D, LightPosition, Dot);
    Dot := XMVectorRotateLeft(Dot, 1);
    Result.r[2] := XMVectorMultiplyAdd(C, LightPosition, Dot);
    Dot := XMVectorRotateLeft(Dot, 1);
    Result.r[1] := XMVectorMultiplyAdd(b, LightPosition, Dot);
    Dot := XMVectorRotateLeft(Dot, 1);
    Result.r[0] := XMVectorMultiplyAdd(a, LightPosition, Dot);
end;


// ------------------------------------------------------------------------------
// View and projection initialization operations
// ------------------------------------------------------------------------------

function XMMatrixLookAtLH(EyePosition: TFXMVECTOR; FocusPosition: TFXMVECTOR; UpDirection: TFXMVECTOR): TXMMATRIX;
var
    EyeDirection: TXMVECTOR;
begin
    EyeDirection := XMVectorSubtract(FocusPosition, EyePosition);
    Result := XMMatrixLookToLH(EyePosition, EyeDirection, UpDirection);
end;



function XMMatrixLookAtRH(EyePosition: TFXMVECTOR; FocusPosition: TFXMVECTOR; UpDirection: TFXMVECTOR): TXMMATRIX;
var
    NegEyeDirection: TXMVECTOR;
begin
    NegEyeDirection := XMVectorSubtract(EyePosition, FocusPosition);
    Result := XMMatrixLookToLH(EyePosition, NegEyeDirection, UpDirection);
end;



function XMMatrixLookToLH(EyePosition: TFXMVECTOR; EyeDirection: TFXMVECTOR; UpDirection: TFXMVECTOR): TXMMATRIX;
var
    r0, r1, r2: TXMVECTOR;
    D0, D1, D2: TXMVECTOR;
    NegEyePosition: TXMVECTOR;
begin
    r2 := XMVector3Normalize(EyeDirection);

    r0 := XMVector3Cross(UpDirection, r2);
    r0 := XMVector3Normalize(r0);

    r1 := XMVector3Cross(r2, r0);

    NegEyePosition := XMVectorNegate(EyePosition);

    D0 := XMVector3Dot(r0, NegEyePosition);
    D1 := XMVector3Dot(r1, NegEyePosition);
    D2 := XMVector3Dot(r2, NegEyePosition);

    Result.r[0] := XMVectorSelect(D0, r0, g_XMSelect1110);
    Result.r[1] := XMVectorSelect(D1, r1, g_XMSelect1110);
    Result.r[2] := XMVectorSelect(D2, r2, g_XMSelect1110);
    Result.r[3] := g_XMIdentityR3;

    Result := XMMatrixTranspose(Result);
end;



function XMMatrixLookToRH(EyePosition: TFXMVECTOR; EyeDirection: TFXMVECTOR; UpDirection: TFXMVECTOR): TXMMATRIX;
var
    NegEyeDirection: TXMVECTOR;
begin
    NegEyeDirection := XMVectorNegate(EyeDirection);
    Result := XMMatrixLookToLH(EyePosition, NegEyeDirection, UpDirection);
end;



function XMMatrixPerspectiveLH(ViewWidth, ViewHeight, NearZ, FarZ: single): TXMMATRIX;
var
    TwoNearZ, fRange: single;
begin
    TwoNearZ := NearZ + NearZ;
    fRange := FarZ / (FarZ - NearZ);

    Result.m[0][0] := TwoNearZ / ViewWidth;
    Result.m[0][1] := 0.0;
    Result.m[0][2] := 0.0;
    Result.m[0][3] := 0.0;

    Result.m[1][0] := 0.0;
    Result.m[1][1] := TwoNearZ / ViewHeight;
    Result.m[1][2] := 0.0;
    Result.m[1][3] := 0.0;

    Result.m[2][0] := 0.0;
    Result.m[2][1] := 0.0;
    Result.m[2][2] := fRange;
    Result.m[2][3] := 1.0;

    Result.m[3][0] := 0.0;
    Result.m[3][1] := 0.0;
    Result.m[3][2] := -fRange * NearZ;
    Result.m[3][3] := 0.0;

end;



function XMMatrixPerspectiveRH(ViewWidth, ViewHeight, NearZ, FarZ: single): TXMMATRIX;
var
    TwoNearZ, fRange: single;
begin
    TwoNearZ := NearZ + NearZ;
    fRange := FarZ / (NearZ - FarZ);

    Result.m[0][0] := TwoNearZ / ViewWidth;
    Result.m[0][1] := 0.0;
    Result.m[0][2] := 0.0;
    Result.m[0][3] := 0.0;

    Result.m[1][0] := 0.0;
    Result.m[1][1] := TwoNearZ / ViewHeight;
    Result.m[1][2] := 0.0;
    Result.m[1][3] := 0.0;

    Result.m[2][0] := 0.0;
    Result.m[2][1] := 0.0;
    Result.m[2][2] := fRange;
    Result.m[2][3] := -1.0;

    Result.m[3][0] := 0.0;
    Result.m[3][1] := 0.0;
    Result.m[3][2] := fRange * NearZ;
    Result.m[3][3] := 0.0;
end;



function XMMatrixPerspectiveFovLH(FovAngleY, AspectRatio, NearZ, FarZ: single): TXMMATRIX;
var
    SinFov: single;
    CosFov: single;
    Height, Width, fRange: single;
begin
    XMScalarSinCos(SinFov, CosFov, 0.5 * FovAngleY);

    Height := CosFov / SinFov;
    Width := Height / AspectRatio;
    fRange := FarZ / (FarZ - NearZ);

    Result.m[0][0] := Width;
    Result.m[0][1] := 0.0;
    Result.m[0][2] := 0.0;
    Result.m[0][3] := 0.0;

    Result.m[1][0] := 0.0;
    Result.m[1][1] := Height;
    Result.m[1][2] := 0.0;
    Result.m[1][3] := 0.0;

    Result.m[2][0] := 0.0;
    Result.m[2][1] := 0.0;
    Result.m[2][2] := fRange;
    Result.m[2][3] := 1.0;

    Result.m[3][0] := 0.0;
    Result.m[3][1] := 0.0;
    Result.m[3][2] := -fRange * NearZ;
    Result.m[3][3] := 0.0;
end;



function XMMatrixPerspectiveFovRH(FovAngleY, AspectRatio, NearZ, FarZ: single): TXMMATRIX;
var
    SinFov: single;
    CosFov: single;
    Height, Width, fRange: single;
begin
    XMScalarSinCos(SinFov, CosFov, 0.5 * FovAngleY);

    Height := CosFov / SinFov;
    Width := Height / AspectRatio;
    fRange := FarZ / (NearZ - FarZ);

    Result.m[0][0] := Width;
    Result.m[0][1] := 0.0;
    Result.m[0][2] := 0.0;
    Result.m[0][3] := 0.0;

    Result.m[1][0] := 0.0;
    Result.m[1][1] := Height;
    Result.m[1][2] := 0.0;
    Result.m[1][3] := 0.0;

    Result.m[2][0] := 0.0;
    Result.m[2][1] := 0.0;
    Result.m[2][2] := fRange;
    Result.m[2][3] := -1.0;

    Result.m[3][0] := 0.0;
    Result.m[3][1] := 0.0;
    Result.m[3][2] := fRange * NearZ;
    Result.m[3][3] := 0.0;
end;



function XMMatrixPerspectiveOffCenterLH(ViewLeft, ViewRight, ViewBottom, ViewTop, NearZ, FarZ: single): TXMMATRIX;
var
    TwoNearZ: single;
    ReciprocalWidth, ReciprocalHeight, fRange: single;
begin
    TwoNearZ := NearZ + NearZ;
    ReciprocalWidth := 1.0 / (ViewRight - ViewLeft);
    ReciprocalHeight := 1.0 / (ViewTop - ViewBottom);
    fRange := FarZ / (FarZ - NearZ);

    Result.m[0][0] := TwoNearZ * ReciprocalWidth;
    Result.m[0][1] := 0.0;
    Result.m[0][2] := 0.0;
    Result.m[0][3] := 0.0;

    Result.m[1][0] := 0.0;
    Result.m[1][1] := TwoNearZ * ReciprocalHeight;
    Result.m[1][2] := 0.0;
    Result.m[1][3] := 0.0;

    Result.m[2][0] := -(ViewLeft + ViewRight) * ReciprocalWidth;
    Result.m[2][1] := -(ViewTop + ViewBottom) * ReciprocalHeight;
    Result.m[2][2] := fRange;
    Result.m[2][3] := 1.0;

    Result.m[3][0] := 0.0;
    Result.m[3][1] := 0.0;
    Result.m[3][2] := -fRange * NearZ;
    Result.m[3][3] := 0.0;
end;



function XMMatrixPerspectiveOffCenterRH(ViewLeft, ViewRight, ViewBottom, ViewTop, NearZ, FarZ: single): TXMMATRIX;
var
    TwoNearZ: single;
    ReciprocalWidth, ReciprocalHeight, fRange: single;
begin
    TwoNearZ := NearZ + NearZ;
    ReciprocalWidth := 1.0 / (ViewRight - ViewLeft);
    ReciprocalHeight := 1.0 / (ViewTop - ViewBottom);
    fRange := FarZ / (NearZ - FarZ);

    Result.m[0][0] := TwoNearZ * ReciprocalWidth;
    Result.m[0][1] := 0.0;
    Result.m[0][2] := 0.0;
    Result.m[0][3] := 0.0;

    Result.m[1][0] := 0.0;
    Result.m[1][1] := TwoNearZ * ReciprocalHeight;
    Result.m[1][2] := 0.0;
    Result.m[1][3] := 0.0;

    Result.m[2][0] := (ViewLeft + ViewRight) * ReciprocalWidth;
    Result.m[2][1] := (ViewTop + ViewBottom) * ReciprocalHeight;
    Result.m[2][2] := fRange;
    Result.m[2][3] := -1.0;

    Result.m[3][0] := 0.0;
    Result.m[3][1] := 0.0;
    Result.m[3][2] := fRange * NearZ;
    Result.m[3][3] := 0.0;
end;



function XMMatrixOrthographicLH(ViewWidth, ViewHeight, NearZ, FarZ: single): TXMMATRIX;
var
    fRange: single;
begin
    fRange := 1.0 / (FarZ - NearZ);

    Result.m[0][0] := 2.0 / ViewWidth;
    Result.m[0][1] := 0.0;
    Result.m[0][2] := 0.0;
    Result.m[0][3] := 0.0;

    Result.m[1][0] := 0.0;
    Result.m[1][1] := 2.0 / ViewHeight;
    Result.m[1][2] := 0.0;
    Result.m[1][3] := 0.0;

    Result.m[2][0] := 0.0;
    Result.m[2][1] := 0.0;
    Result.m[2][2] := fRange;
    Result.m[2][3] := 0.0;

    Result.m[3][0] := 0.0;
    Result.m[3][1] := 0.0;
    Result.m[3][2] := -fRange * NearZ;
    Result.m[3][3] := 1.0;
end;



function XMMatrixOrthographicRH(ViewWidth, ViewHeight, NearZ, FarZ: single): TXMMATRIX;
var
    fRange: single;
begin
    fRange := 1.0 / (NearZ - FarZ);

    Result.m[0][0] := 2.0 / ViewWidth;
    Result.m[0][1] := 0.0;
    Result.m[0][2] := 0.0;
    Result.m[0][3] := 0.0;

    Result.m[1][0] := 0.0;
    Result.m[1][1] := 2.0 / ViewHeight;
    Result.m[1][2] := 0.0;
    Result.m[1][3] := 0.0;

    Result.m[2][0] := 0.0;
    Result.m[2][1] := 0.0;
    Result.m[2][2] := fRange;
    Result.m[2][3] := 0.0;

    Result.m[3][0] := 0.0;
    Result.m[3][1] := 0.0;
    Result.m[3][2] := fRange * NearZ;
    Result.m[3][3] := 1.0;
end;



function XMMatrixOrthographicOffCenterLH(ViewLeft, ViewRight, ViewBottom, ViewTop, NearZ, FarZ: single): TXMMATRIX;
var
    ReciprocalWidth, ReciprocalHeight, fRange: single;
begin
    ReciprocalWidth := 1.0 / (ViewRight - ViewLeft);
    ReciprocalHeight := 1.0 / (ViewTop - ViewBottom);
    fRange := 1.0 / (FarZ - NearZ);

    Result.m[0][0] := ReciprocalWidth + ReciprocalWidth;
    Result.m[0][1] := 0.0;
    Result.m[0][2] := 0.0;
    Result.m[0][3] := 0.0;

    Result.m[1][0] := 0.0;
    Result.m[1][1] := ReciprocalHeight + ReciprocalHeight;
    Result.m[1][2] := 0.0;
    Result.m[1][3] := 0.0;

    Result.m[2][0] := 0.0;
    Result.m[2][1] := 0.0;
    Result.m[2][2] := fRange;
    Result.m[2][3] := 0.0;

    Result.m[3][0] := -(ViewLeft + ViewRight) * ReciprocalWidth;
    Result.m[3][1] := -(ViewTop + ViewBottom) * ReciprocalHeight;
    Result.m[3][2] := -fRange * NearZ;
    Result.m[3][3] := 1.0;
end;



function XMMatrixOrthographicOffCenterRH(ViewLeft, ViewRight, ViewBottom, ViewTop, NearZ, FarZ: single): TXMMATRIX;
var
    ReciprocalWidth, ReciprocalHeight, fRange: single;
begin
    ReciprocalWidth := 1.0 / (ViewRight - ViewLeft);
    ReciprocalHeight := 1.0 / (ViewTop - ViewBottom);
    fRange := 1.0 / (NearZ - FarZ);

    Result.m[0][0] := ReciprocalWidth + ReciprocalWidth;
    Result.m[0][1] := 0.0;
    Result.m[0][2] := 0.0;
    Result.m[0][3] := 0.0;

    Result.m[1][0] := 0.0;
    Result.m[1][1] := ReciprocalHeight + ReciprocalHeight;
    Result.m[1][2] := 0.0;
    Result.m[1][3] := 0.0;

    Result.m[2][0] := 0.0;
    Result.m[2][1] := 0.0;
    Result.m[2][2] := fRange;
    Result.m[2][3] := 0.0;

    Result.r[3] := XMVectorSet(-(ViewLeft + ViewRight) * ReciprocalWidth, -(ViewTop + ViewBottom) * ReciprocalHeight, fRange * NearZ, 1.0);
end;

(* ***************************************************************************
  *
  * XMMATRIX operators and methods
  *
  *************************************************************************** *)

{ TXMMATRIX }

constructor TXMMATRIX.Create(pArray: PSingle);
begin
    Move(pArray^, self.f[0], 16 * 4);
end;



constructor TXMMATRIX.Create(r0, r1, r2, r3: TXMVECTOR);
begin
    self.r[0] := r0;
    self.r[1] := r1;
    self.r[2] := r2;
    self.r[3] := r3;
end;



constructor TXMMATRIX.Create(m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33: single);
begin
    r[0] := XMVectorSet(m00, m01, m02, m03);
    r[1] := XMVectorSet(m10, m11, m12, m13);
    r[2] := XMVectorSet(m20, m21, m22, m23);
    r[3] := XMVectorSet(m30, m31, m32, m33);
end;



class operator TXMMATRIX.Negative(a: TXMMATRIX): TXMMATRIX;
begin
    Result.r[0] := XMVectorNegate(a.r[0]);
    Result.r[1] := XMVectorNegate(a.r[1]);
    Result.r[2] := XMVectorNegate(a.r[2]);
    Result.r[3] := XMVectorNegate(a.r[3]);
end;



class operator TXMMATRIX.Add(a, b: TXMMATRIX): TXMMATRIX;
begin
    Result.r[0] := XMVectorAdd(a.r[0], b.r[0]);
    Result.r[1] := XMVectorAdd(a.r[1], b.r[1]);
    Result.r[2] := XMVectorAdd(a.r[2], b.r[2]);
    Result.r[3] := XMVectorAdd(a.r[3], b.r[3]);
end;



class operator TXMMATRIX.Subtract(a: TXMMATRIX; b: TXMMATRIX): TXMMATRIX;
begin
    Result.r[0] := XMVectorSubtract(a.r[0], b.r[0]);
    Result.r[1] := XMVectorSubtract(a.r[1], b.r[1]);
    Result.r[2] := XMVectorSubtract(a.r[2], b.r[2]);
    Result.r[3] := XMVectorSubtract(a.r[3], b.r[3]);
end;



class operator TXMMATRIX.Multiply(a: TXMMATRIX; b: TXMMATRIX): TXMMATRIX;
begin
    Result := XMMatrixMultiply(a, b);
end;



class operator TXMMATRIX.Divide(a: TXMMATRIX; b: single): TXMMATRIX;
var
    VS: TXMVECTOR;
begin
    VS := XMVectorReplicate(b);
    Result.r[0] := XMVectorDivide(a.r[0], VS);
    Result.r[1] := XMVectorDivide(a.r[1], VS);
    Result.r[2] := XMVectorDivide(a.r[2], VS);
    Result.r[3] := XMVectorDivide(a.r[3], VS);
end;



class operator TXMMATRIX.Multiply(a: single; b: TXMMATRIX): TXMMATRIX;
begin
    Result.r[0] := XMVectorScale(b.r[0], a);
    Result.r[1] := XMVectorScale(b.r[1], a);
    Result.r[2] := XMVectorScale(b.r[2], a);
    Result.r[3] := XMVectorScale(b.r[3], a);
end;



class operator TXMMATRIX.Multiply(a: TXMMATRIX; b: single): TXMMATRIX;
begin
    Result.r[0] := XMVectorScale(a.r[0], b);
    Result.r[1] := XMVectorScale(a.r[1], b);
    Result.r[2] := XMVectorScale(a.r[2], b);
    Result.r[3] := XMVectorScale(a.r[3], b);
end;

(* ***************************************************************************
  *
  * XMFLOAT3X3 operators
  *
  *************************************************************************** *)

{ TXMFLOAT3X3 }

constructor TXMFLOAT3X3.Create(m00, m01, m02, m10, m11, m12, m20, m21, m22: single);
begin
    _11 := m00;
    _12 := m01;
    _13 := m02;
    _21 := m10;
    _22 := m11;
    _23 := m12;
    _31 := m20;
    _32 := m21;
    _33 := m22;
end;



constructor TXMFLOAT3X3.Create(pArray: PSingle);
var
    Row, Column: integer;
    lArray: array [0 .. 8] of single absolute pArray;
begin
{$IFDEF WithAssert}
    assert(pArray <> nil);
{$ENDIF}
    for Row := 0 to 2 do
    begin
        for Column := 0 to 2 do
        begin
            m[Row][Column] := lArray[Row * 3 + Column];
        end;
    end;
    // Move(pArray^, f[0], 36);
end;



function TXMFLOAT3X3.Value(Row, Column: DWORD): single;
begin
    Result := m[Row][Column];
end;

(* ***************************************************************************
  *
  * XMFLOAT4X3 operators
  *
  *************************************************************************** *)

{ TXMFLOAT4X3 }

constructor TXMFLOAT4X3.Create(m00, m01, m02, m10, m11, m12, m20, m21, m22, m30, m31, m32: single);
begin
    _11 := m00;
    _12 := m01;
    _13 := m02;
    _21 := m10;
    _22 := m11;
    _23 := m12;
    _31 := m20;
    _32 := m21;
    _33 := m22;
    _41 := m30;
    _42 := m31;
    _43 := m32;
end;



constructor TXMFLOAT4X3.Create(pArray: PSingle);
var
    lArray: array [0 .. 11] of single absolute pArray;
begin
{$IFDEF WithAssert}
    assert(pArray <> nil);
{$ENDIF}
    self.m[0][0] := lArray[0];
    self.m[0][1] := lArray[1];
    self.m[0][2] := lArray[2];

    self.m[1][0] := lArray[3];
    self.m[1][1] := lArray[4];
    self.m[1][2] := lArray[5];

    self.m[2][0] := lArray[6];
    self.m[2][1] := lArray[7];
    self.m[2][2] := lArray[8];

    self.m[3][0] := lArray[9];
    self.m[3][1] := lArray[10];
    self.m[3][2] := lArray[11];

    // Move(pArray^, f[0], 48);
end;



function TXMFLOAT4X3.Value(Row, Column: DWORD): single;
begin
    Result := m[Row][Column];
end;

(* ***************************************************************************
  *
  * XMFLOAT3X4 operators
  *
  *************************************************************************** *)

{ TXMFLOAT3X4 }

constructor TXMFLOAT3X4.Create(m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23: single);
begin
    _11 := m00;
    _12 := m01;
    _13 := m02;
    _14 := m03;
    _21 := m10;
    _22 := m11;
    _23 := m12;
    _24 := m13;
    _31 := m20;
    _32 := m21;
    _33 := m22;
    _34 := m23;
end;



constructor TXMFLOAT3X4.Create(pArray: PSingle);
var
    lArray: array [0 .. 11] of single absolute pArray;
begin
{$IFDEF WithAssert}
    assert(pArray <> nil);
{$ENDIF}
    m[0][0] := lArray[0];
    m[0][1] := lArray[1];
    m[0][2] := lArray[2];
    m[0][3] := lArray[3];

    m[1][0] := lArray[4];
    m[1][1] := lArray[5];
    m[1][2] := lArray[6];
    m[1][3] := lArray[7];

    m[2][0] := lArray[8];
    m[2][1] := lArray[9];
    m[2][2] := lArray[10];
    m[2][3] := lArray[11];
end;

(* ***************************************************************************
  *
  * XMFLOAT4X4 operators
  *
  *************************************************************************** *)

{ TXMFLOAT4X4 }

constructor TXMFLOAT4X4.Create(m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33: single);
begin
    _11 := m00;
    _12 := m01;
    _13 := m02;
    _14 := m03;
    _21 := m10;
    _22 := m11;
    _23 := m12;
    _24 := m13;
    _31 := m20;
    _32 := m21;
    _33 := m22;
    _34 := m23;
    _41 := m30;
    _42 := m31;
    _43 := m32;
    _44 := m33;
end;



constructor TXMFLOAT4X4.Create(pArray: PSingle);
var
    lArray: array [0 .. 15] of single absolute pArray;
begin
{$IFDEF WithAssert}
    assert(pArray <> nil);
{$ENDIF}
    m[0][0] := lArray[0];
    m[0][1] := lArray[1];
    m[0][2] := lArray[2];
    m[0][3] := lArray[3];

    m[1][0] := lArray[4];
    m[1][1] := lArray[5];
    m[1][2] := lArray[6];
    m[1][3] := lArray[7];

    m[2][0] := lArray[8];
    m[2][1] := lArray[9];
    m[2][2] := lArray[10];
    m[2][3] := lArray[11];

    m[3][0] := lArray[12];
    m[3][1] := lArray[13];
    m[3][2] := lArray[14];
    m[3][3] := lArray[15];
end;

{$ENDREGION}
{$REGION DirectXMathMisc}
(* ***************************************************************************
  *
  * Quaternion
  *
  *************************************************************************** *)

// ------------------------------------------------------------------------------
// Comparison operations
// ------------------------------------------------------------------------------

function XMQuaternionEqual(Q1: TFXMVECTOR; Q2: TFXMVECTOR): boolean;
begin
    Result := XMVector4Equal(Q1, Q2);
end;



function XMQuaternionNotEqual(Q1: TFXMVECTOR; Q2: TFXMVECTOR): boolean;
begin
    Result := XMVector4NotEqual(Q1, Q2);
end;



function XMQuaternionIsNaN(Q: TFXMVECTOR): boolean;
begin
    Result := XMVector4IsNaN(Q);
end;



function XMQuaternionIsInfinite(Q: TFXMVECTOR): boolean;
begin
    Result := XMVector4IsInfinite(Q);
end;



function XMQuaternionIsIdentity(Q: TFXMVECTOR): boolean;
begin
    Result := XMVector4Equal(Q, g_XMIdentityR3);
end;

// ------------------------------------------------------------------------------
// Computation operations
// ------------------------------------------------------------------------------

function XMQuaternionDot(Q1: TFXMVECTOR; Q2: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector4Dot(Q1, Q2);
end;



function XMQuaternionMultiply(Q1: TFXMVECTOR; Q2: TFXMVECTOR): TXMVECTOR;
begin
    // Returns the product Q2*Q1 (which is the concatenation of a rotation Q1 followed by the rotation Q2)

    // [ (Q2.w * Q1.x) + (Q2.x * Q1.w) + (Q2.y * Q1.z) - (Q2.z * Q1.y),
    // (Q2.w * Q1.y) - (Q2.x * Q1.z) + (Q2.y * Q1.w) + (Q2.z * Q1.x),
    // (Q2.w * Q1.z) + (Q2.x * Q1.y) - (Q2.y * Q1.x) + (Q2.z * Q1.w),
    // (Q2.w * Q1.w) - (Q2.x * Q1.x) - (Q2.y * Q1.y) - (Q2.z * Q1.z) ]

    Result.vector4_f32[0] := (Q2.vector4_f32[3] * Q1.vector4_f32[0]) + (Q2.vector4_f32[0] * Q1.vector4_f32[3]) + (Q2.vector4_f32[1] * Q1.vector4_f32[2]) - (Q2.vector4_f32[2] * Q1.vector4_f32[1]);
    Result.vector4_f32[1] := (Q2.vector4_f32[3] * Q1.vector4_f32[1]) - (Q2.vector4_f32[0] * Q1.vector4_f32[2]) + (Q2.vector4_f32[1] * Q1.vector4_f32[3]) + (Q2.vector4_f32[2] * Q1.vector4_f32[0]);
    Result.vector4_f32[2] := (Q2.vector4_f32[3] * Q1.vector4_f32[2]) + (Q2.vector4_f32[0] * Q1.vector4_f32[1]) - (Q2.vector4_f32[1] * Q1.vector4_f32[0]) + (Q2.vector4_f32[2] * Q1.vector4_f32[3]);
    Result.vector4_f32[3] := (Q2.vector4_f32[3] * Q1.vector4_f32[3]) - (Q2.vector4_f32[0] * Q1.vector4_f32[0]) - (Q2.vector4_f32[1] * Q1.vector4_f32[1]) - (Q2.vector4_f32[2] * Q1.vector4_f32[2]);

end;



function XMQuaternionLengthSq(Q: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector4LengthSq(Q);
end;



function XMQuaternionReciprocalLength(Q: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector4ReciprocalLength(Q);
end;



function XMQuaternionLength(Q: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector4Length(Q);
end;



function XMQuaternionNormalizeEst(Q: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector4NormalizeEst(Q);
end;



function XMQuaternionNormalize(Q: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector4Normalize(Q);
end;



function XMQuaternionConjugate(Q: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := -Q.vector4_f32[0];
    Result.vector4_f32[1] := -Q.vector4_f32[1];
    Result.vector4_f32[2] := -Q.vector4_f32[2];
    Result.vector4_f32[3] := Q.vector4_f32[3];

end;



function XMQuaternionInverse(Q: TFXMVECTOR): TXMVECTOR;
var
    L, Conjugate, Control: TXMVECTOR;
begin
    L := XMVector4LengthSq(Q);
    Conjugate := XMQuaternionConjugate(Q);
    Control := XMVectorLessOrEqual(L, g_XMEpsilon);
    Result := XMVectorDivide(Conjugate, L);
    Result := XMVectorSelect(Result, g_XMZero, Control);
end;



function XMQuaternionLn(Q: TFXMVECTOR): TXMVECTOR;
const
    OneMinusEpsilon: TXMVECTOR = (vector4_f32: (1.0 - 0.00001, 1.0 - 0.00001, 1.0 - 0.00001, 1.0 - 0.00001));
var
    QW, Q0, s: TXMVECTOR;
    ControlW, Theta, SinTheta: TXMVECTOR;
begin

    QW := XMVectorSplatW(Q);
    Q0 := XMVectorSelect(g_XMSelect1110, Q, g_XMSelect1110);

    ControlW := XMVectorInBounds(QW, OneMinusEpsilon);

    Theta := XMVectorACos(QW);
    SinTheta := XMVectorSin(Theta);

    s := XMVectorDivide(Theta, SinTheta);

    Result := XMVectorMultiply(Q0, s);
    Result := XMVectorSelect(Q0, Result, ControlW);
end;



function XMQuaternionExp(Q: TFXMVECTOR): TXMVECTOR;
var
    Theta, s, Control: TXMVECTOR;
    SinTheta, CosTheta: TXMVECTOR;
begin
    Theta := XMVector3Length(Q);
    XMVectorSinCos(SinTheta, CosTheta, Theta);
    s := XMVectorDivide(SinTheta, Theta);
    Result := XMVectorMultiply(Q, s);
    Control := XMVectorNearEqual(Theta, g_XMZero, g_XMEpsilon);
    Result := XMVectorSelect(Result, Q, Control);
    Result := XMVectorSelect(CosTheta, Result, g_XMSelect1110);
end;



function XMQuaternionSlerp(Q0: TFXMVECTOR; Q1: TFXMVECTOR; t: single): TXMVECTOR;
var
    TV: TXMVECTOR;
begin
    TV := XMVectorReplicate(t);
    Result := XMQuaternionSlerpV(Q0, Q1, TV);
end;



function XMQuaternionSlerpV(Q0: TFXMVECTOR; Q1: TFXMVECTOR; t: TFXMVECTOR): TXMVECTOR;
const
    OneMinusEpsilon: TXMVECTOR = (vector4_f32: (1.0 - 0.00001, 1.0 - 0.00001, 1.0 - 0.00001, 1.0 - 0.00001));
var
    CosOmega, Control, Sign: TXMVECTOR;
    SinOmega, Omega, SignMask: TXMVECTOR;
    V01, InvSinOmega, S0, S1: TXMVECTOR;
begin
    // Result = Q0 * sin((1.0 - t) * Omega) / sin(Omega) + Q1 * sin(t * Omega) / sin(Omega)
    CosOmega := XMQuaternionDot(Q0, Q1);

    Control := XMVectorLess(CosOmega, g_XMZero);
    Sign := XMVectorSelect(g_XMOne, g_XMNegativeOne, Control);

    CosOmega := XMVectorMultiply(CosOmega, Sign);

    Control := XMVectorLess(CosOmega, OneMinusEpsilon);

    SinOmega := XMVectorNegativeMultiplySubtract(CosOmega, CosOmega, g_XMOne);
    SinOmega := XMVectorSqrt(SinOmega);

    Omega := XMVectorATan2(SinOmega, CosOmega);

    SignMask := XMVectorSplatSignMask();
    V01 := XMVectorShiftLeft(t, g_XMZero, 2);
    SignMask := XMVectorShiftLeft(SignMask, g_XMZero, 3);
    V01 := XMVectorXorInt(V01, SignMask);
    V01 := XMVectorAdd(g_XMIdentityR0, V01);

    InvSinOmega := XMVectorReciprocal(SinOmega);

    S0 := XMVectorMultiply(V01, Omega);
    S0 := XMVectorSin(S0);
    S0 := XMVectorMultiply(S0, InvSinOmega);

    S0 := XMVectorSelect(V01, S0, Control);

    S1 := XMVectorSplatY(S0);
    S0 := XMVectorSplatX(S0);

    S1 := XMVectorMultiply(S1, Sign);

    Result := XMVectorMultiply(Q0, S0);
    Result := XMVectorMultiplyAdd(Q1, S1, Result);
end;



function XMQuaternionSquad(Q0: TFXMVECTOR; Q1: TFXMVECTOR; Q2: TFXMVECTOR; Q3: TGXMVECTOR; t: single): TXMVECTOR;
var
    TV: TXMVECTOR;
begin
    TV := XMVectorReplicate(t);
    Result := XMQuaternionSquadV(Q0, Q1, Q2, Q3, TV);
end;



function XMQuaternionSquadV(Q0: TFXMVECTOR; Q1: TFXMVECTOR; Q2: TFXMVECTOR; Q3: TGXMVECTOR; t: THXMVECTOR): TXMVECTOR;
var
    TP, Two: TXMVECTOR;
    Q03, Q12: TXMVECTOR;
begin
    TP := t;
    Two := XMVectorSplatConstant(2, 0);

    Q03 := XMQuaternionSlerpV(Q0, Q3, t);
    Q12 := XMQuaternionSlerpV(Q1, Q2, t);

    TP := XMVectorNegativeMultiplySubtract(TP, TP, TP);
    TP := XMVectorMultiply(TP, Two);

    Result := XMQuaternionSlerpV(Q03, Q12, TP);
end;



procedure XMQuaternionSquadSetup(out pA: TXMVECTOR; out pB: TXMVECTOR; out pC: TXMVECTOR; Q0: TFXMVECTOR; Q1: TFXMVECTOR; Q2: TFXMVECTOR; Q3: TGXMVECTOR);
var
    LS12, LD12, SQ2, Control1: TXMVECTOR;
    LS01, LD01, SQ0: TXMVECTOR;
    LS23, LD23, SQ3: TXMVECTOR;
    Control0, Control2: TXMVECTOR;
    InvQ1, InvQ2: TXMVECTOR;
    LnQ0, LnQ1, LnQ2, LnQ3: TXMVECTOR;
    ExpQ02, ExpQ13: TXMVECTOR;
    NegativeOneQuarter: TXMVECTOR;
begin
    LS12 := XMQuaternionLengthSq(XMVectorAdd(Q1, Q2));
    LD12 := XMQuaternionLengthSq(XMVectorSubtract(Q1, Q2));
    SQ2 := XMVectorNegate(Q2);

    Control1 := XMVectorLess(LS12, LD12);
    SQ2 := XMVectorSelect(Q2, SQ2, Control1);

    LS01 := XMQuaternionLengthSq(XMVectorAdd(Q0, Q1));
    LD01 := XMQuaternionLengthSq(XMVectorSubtract(Q0, Q1));
    SQ0 := XMVectorNegate(Q0);

    LS23 := XMQuaternionLengthSq(XMVectorAdd(SQ2, Q3));
    LD23 := XMQuaternionLengthSq(XMVectorSubtract(SQ2, Q3));
    SQ3 := XMVectorNegate(Q3);

    Control0 := XMVectorLess(LS01, LD01);
    Control2 := XMVectorLess(LS23, LD23);

    SQ0 := XMVectorSelect(Q0, SQ0, Control0);
    SQ3 := XMVectorSelect(Q3, SQ3, Control2);

    InvQ1 := XMQuaternionInverse(Q1);
    InvQ2 := XMQuaternionInverse(SQ2);

    LnQ0 := XMQuaternionLn(XMQuaternionMultiply(InvQ1, SQ0));
    LnQ2 := XMQuaternionLn(XMQuaternionMultiply(InvQ1, SQ2));
    LnQ1 := XMQuaternionLn(XMQuaternionMultiply(InvQ2, Q1));
    LnQ3 := XMQuaternionLn(XMQuaternionMultiply(InvQ2, SQ3));

    NegativeOneQuarter := XMVectorSplatConstant(-1, 2);

    ExpQ02 := XMVectorMultiply(XMVectorAdd(LnQ0, LnQ2), NegativeOneQuarter);
    ExpQ13 := XMVectorMultiply(XMVectorAdd(LnQ1, LnQ3), NegativeOneQuarter);
    ExpQ02 := XMQuaternionExp(ExpQ02);
    ExpQ13 := XMQuaternionExp(ExpQ13);

    pA := XMQuaternionMultiply(Q1, ExpQ02);
    pB := XMQuaternionMultiply(SQ2, ExpQ13);
    pC := SQ2;
end;



function XMQuaternionBaryCentric(Q0: TFXMVECTOR; Q1: TFXMVECTOR; Q2: TFXMVECTOR; f, g: single): TXMVECTOR;
var
    s: single;
    Q01, Q02: TXMVECTOR;
begin
    s := f + g;

    if ((s < 0.00001) and (s > -0.00001)) then
        Result := Q0
    else
    begin
        Q01 := XMQuaternionSlerp(Q0, Q1, s);
        Q02 := XMQuaternionSlerp(Q0, Q2, s);

        Result := XMQuaternionSlerp(Q01, Q02, g / s);
    end;
end;



function XMQuaternionBaryCentricV(Q0: TFXMVECTOR; Q1: TFXMVECTOR; Q2: TFXMVECTOR; f: TGXMVECTOR; g: THXMVECTOR): TXMVECTOR;
var
    Epsilon: TXMVECTOR;
    s, Q01, Q02, GS: TXMVECTOR;
begin
    Epsilon := XMVectorSplatConstant(1, 16);

    s := XMVectorAdd(f, g);

    if (XMVector4InBounds(s, Epsilon)) then
        Result := Q0
    else
    begin
        Q01 := XMQuaternionSlerpV(Q0, Q1, s);
        Q02 := XMQuaternionSlerpV(Q0, Q2, s);
        GS := XMVectorReciprocal(s);
        GS := XMVectorMultiply(g, GS);

        Result := XMQuaternionSlerpV(Q01, Q02, GS);
    end;
end;


// ------------------------------------------------------------------------------
// Transformation operations
// ------------------------------------------------------------------------------

function XMQuaternionIdentity(): TXMVECTOR;
begin
    Result := g_XMIdentityR3;
end;



function XMQuaternionRotationRollPitchYaw(Pitch, Yaw, Roll: single): TXMVECTOR;
var
    Angles: TXMVECTOR;
    halfpitch, halfyaw, halfroll: single;
    cp, sp, cy, sy, cr, sr: single;
begin

    //if defined(_XM_NO_INTRINSICS_)
    halfpitch := Pitch * 0.5;
    cp := cos(halfpitch);
    sp := sin(halfpitch);

    halfyaw := Yaw * 0.5;
    cy := cos(halfyaw);
    sy := sin(halfyaw);

    halfroll := Roll * 0.5;
    cr := cos(halfroll);
    sr := sin(halfroll);

    Result.f[0] := cr * sp * cy + sr * cp * sy;
    Result.f[1] := cr * cp * sy - sr * sp * cy;
    Result.f[2] := sr * cp * cy - cr * sp * sy;
    Result.f[3] := cr * cp * cy + sr * sp * sy;

    {
    Angles := XMVectorSet(Pitch, Yaw, Roll, 0.0);
    Result := XMQuaternionRotationRollPitchYawFromVector(Angles);
    }
end;

// <Pitch, Yaw, Roll, 0>

function XMQuaternionRotationRollPitchYawFromVector(Angles: TFXMVECTOR): TXMVECTOR;
const
    Sign: TXMVECTOR = (vector4_f32: (1.0, -1.0, -1.0, 1.0));
var
    HalfAngles: TXMVECTOR;
    SinAngles, CosAngles: TXMVECTOR;
    P0, Y0, r0: TXMVECTOR;
    P1, Y1, r1, Q1, Q0: TXMVECTOR;

    halfpitch, halfyaw, halfroll: single;
    cp, sp, cy, sy, cr, sr: single;
begin
    //if defined(_XM_NO_INTRINSICS_)
    halfpitch := Angles.f[0] * 0.5;
    cp := cos(halfpitch);
    sp := sin(halfpitch);

    halfyaw := Angles.f[1] * 0.5;
    cy := cos(halfyaw);
    sy := sin(halfyaw);

    halfroll := Angles.f[2] * 0.5;
    cr := cos(halfroll);
    sr := sin(halfroll);

    Result.f[0] := cr * sp * cy + sr * cp * sy;
    Result.f[1] := cr * cp * sy - sr * sp * cy;
    Result.f[2] := sr * cp * cy - cr * sp * sy;
    Result.f[3] := cr * cp * cy + sr * sp * sy;


{else
    HalfAngles := XMVectorMultiply(Angles, g_XMOneHalf);

    XMVectorSinCos(SinAngles, CosAngles, HalfAngles);

    P0 := XMVectorPermute(XM_PERMUTE_0X, XM_PERMUTE_1X, XM_PERMUTE_1X, XM_PERMUTE_1X, SinAngles, CosAngles);
    Y0 := XMVectorPermute(XM_PERMUTE_1Y, XM_PERMUTE_0Y, XM_PERMUTE_1Y, XM_PERMUTE_1Y, SinAngles, CosAngles);
    r0 := XMVectorPermute(XM_PERMUTE_1Z, XM_PERMUTE_1Z, XM_PERMUTE_0Z, XM_PERMUTE_1Z, SinAngles, CosAngles);
    P1 := XMVectorPermute(XM_PERMUTE_0X, XM_PERMUTE_1X, XM_PERMUTE_1X, XM_PERMUTE_1X, CosAngles, SinAngles);
    Y1 := XMVectorPermute(XM_PERMUTE_1Y, XM_PERMUTE_0Y, XM_PERMUTE_1Y, XM_PERMUTE_1Y, CosAngles, SinAngles);
    r1 := XMVectorPermute(XM_PERMUTE_1Z, XM_PERMUTE_1Z, XM_PERMUTE_0Z, XM_PERMUTE_1Z, CosAngles, SinAngles);

    Q1 := XMVectorMultiply(P1, Sign);
    Q0 := XMVectorMultiply(P0, Y0);
    Q1 := XMVectorMultiply(Q1, Y1);
    Q0 := XMVectorMultiply(Q0, r0);
    Result := XMVectorMultiplyAdd(Q1, r1, Q0); }
end;



function XMQuaternionRotationNormal(NormalAxis: TFXMVECTOR; Angle: single): TXMVECTOR;
var
    N, Scale: TXMVECTOR;
    SinV, CosV: single;
begin
    N := XMVectorSelect(g_XMOne, NormalAxis, g_XMSelect1110);
    XMScalarSinCos(SinV, CosV, 0.5 * Angle);
    Scale := XMVectorSet(SinV, SinV, SinV, CosV);
    Result := XMVectorMultiply(N, Scale);
end;



function XMQuaternionRotationAxis(Axis: TFXMVECTOR; Angle: single): TXMVECTOR;
var
    Normal: TXMVECTOR;
begin
    Normal := XMVector3Normalize(Axis);
    Result := XMQuaternionRotationNormal(Normal, Angle);
end;



function XMQuaternionRotationMatrix(m: TFXMMATRIX): TXMVECTOR;
var
    Q: TXMVECTOR;
    r22: single;
    dif10, omr22: single;
    sum10, opr22: single;
    fourXSqr, inv4x, fourYSqr, inv4y: single;
    fourZSqr, inv4z, fourWSqr, inv4w: single;
begin
    r22 := m.m[2][2];
    if (r22 <= 0.0) then // x^2 + y^2 >= z^2 + w^2
    begin
        dif10 := m.m[1][1] - m.m[0][0];
        omr22 := 1. - r22;
        if (dif10 <= 0.0) then // x^2 >= y^2
        begin
            fourXSqr := omr22 - dif10;
            inv4x := 0.5 / sqrt(fourXSqr);
            Q.f[0] := fourXSqr * inv4x;
            Q.f[1] := (m.m[0][1] + m.m[1][0]) * inv4x;
            Q.f[2] := (m.m[0][2] + m.m[2][0]) * inv4x;
            Q.f[3] := (m.m[1][2] - m.m[2][1]) * inv4x;
        end
        else // y^2 >= x^2
        begin
            fourYSqr := omr22 + dif10;
            inv4y := 0.5 / sqrt(fourYSqr);
            Q.f[0] := (m.m[0][1] + m.m[1][0]) * inv4y;
            Q.f[1] := fourYSqr * inv4y;
            Q.f[2] := (m.m[1][2] + m.m[2][1]) * inv4y;
            Q.f[3] := (m.m[2][0] - m.m[0][2]) * inv4y;
        end;
    end
    else // z^2 + w^2 >= x^2 + y^2
    begin
        sum10 := m.m[1][1] + m.m[0][0];
        opr22 := 1.0 + r22;
        if (sum10 <= 0.0) then // z^2 >= w^2
        begin
            fourZSqr := opr22 - sum10;
            inv4z := 0.5 / sqrt(fourZSqr);
            Q.f[0] := (m.m[0][2] + m.m[2][0]) * inv4z;
            Q.f[1] := (m.m[1][2] + m.m[2][1]) * inv4z;
            Q.f[2] := fourZSqr * inv4z;
            Q.f[3] := (m.m[0][1] - m.m[1][0]) * inv4z;
        end
        else // w^2 >= z^2
        begin
            fourWSqr := opr22 + sum10;
            inv4w := 0.5 / sqrt(fourWSqr);
            Q.f[0] := (m.m[1][2] - m.m[2][1]) * inv4w;
            Q.f[1] := (m.m[2][0] - m.m[0][2]) * inv4w;
            Q.f[2] := (m.m[0][1] - m.m[1][0]) * inv4w;
            Q.f[3] := fourWSqr * inv4w;
        end;
    end;
    Result := Q;
end;

// ------------------------------------------------------------------------------
// Conversion operations
// ------------------------------------------------------------------------------

procedure XMQuaternionToAxisAngle(out pAxis: TXMVECTOR; out pAngle: single; Q: TFXMVECTOR);
begin
    pAxis := Q;
    pAngle := 2.0 * XMScalarACos(XMVectorGetW(Q));
end;

(* ***************************************************************************
  *
  * Plane
  *
  *************************************************************************** *)

// ------------------------------------------------------------------------------
// Comparison operations
// ------------------------------------------------------------------------------

function XMPlaneEqual(P1: TFXMVECTOR; P2: TFXMVECTOR): boolean;
begin
    Result := XMVector4Equal(P1, P2);
end;



function XMPlaneNearEqual(P1: TFXMVECTOR; P2: TFXMVECTOR; Epsilon: TFXMVECTOR): boolean;
var
    NP1, NP2: TXMVECTOR;
begin
    NP1 := XMPlaneNormalize(P1);
    NP2 := XMPlaneNormalize(P2);
    Result := XMVector4NearEqual(NP1, NP2, Epsilon);
end;



function XMPlaneNotEqual(P1: TFXMVECTOR; P2: TFXMVECTOR): boolean;
begin
    Result := XMVector4NotEqual(P1, P2);
end;



function XMPlaneIsNaN(P: TFXMVECTOR): boolean;
begin
    Result := XMVector4IsNaN(P);
end;



function XMPlaneIsInfinite(P: TFXMVECTOR): boolean;
begin
    Result := XMVector4IsInfinite(P);
end;

// ------------------------------------------------------------------------------
// Computation operations
// ------------------------------------------------------------------------------

function XMPlaneDot(P: TFXMVECTOR; v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector4Dot(P, v);
end;



function XMPlaneDotCoord(P: TFXMVECTOR; v: TFXMVECTOR): TXMVECTOR;
var
    V3: TXMVECTOR;
begin
    // Result = P[0] * V[0] + P[1] * V[1] + P[2] * V[2] + P[3]

    V3 := XMVectorSelect(g_XMOne, v, g_XMSelect1110);
    Result := XMVector4Dot(P, V3);

end;



function XMPlaneDotNormal(P: TFXMVECTOR; v: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector3Dot(P, v);
end;

// XMPlaneNormalizeEst uses a reciprocal estimate and
// returns QNaN on zero and infinite vectors.
function XMPlaneNormalizeEst(P: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVector3ReciprocalLengthEst(P);
    Result := XMVectorMultiply(P, Result);
end;



function XMPlaneNormalize(P: TFXMVECTOR): TXMVECTOR;
var
    fLengthSq: single;
begin
    fLengthSq := sqrt((P.vector4_f32[0] * P.vector4_f32[0]) + (P.vector4_f32[1] * P.vector4_f32[1]) + (P.vector4_f32[2] * P.vector4_f32[2]));
    // Prevent divide by zero
    if (fLengthSq > 0) then
        fLengthSq := 1.0 / fLengthSq;

    Result.vector4_f32[0] := P.vector4_f32[0] * fLengthSq;
    Result.vector4_f32[1] := P.vector4_f32[1] * fLengthSq;
    Result.vector4_f32[2] := P.vector4_f32[2] * fLengthSq;
    Result.vector4_f32[3] := P.vector4_f32[3] * fLengthSq;
end;



function XMPlaneIntersectLine(P: TFXMVECTOR; LinePoint1: TFXMVECTOR; LinePoint2: TFXMVECTOR): TXMVECTOR;
var
    V1, V2, D, VT: TXMVECTOR;
    Point, Control: TXMVECTOR;
begin
    V1 := XMVector3Dot(P, LinePoint1);
    V2 := XMVector3Dot(P, LinePoint2);
    D := XMVectorSubtract(V1, V2);

    VT := XMPlaneDotCoord(P, LinePoint1);
    VT := XMVectorDivide(VT, D);

    Point := XMVectorSubtract(LinePoint2, LinePoint1);
    Point := XMVectorMultiplyAdd(Point, VT, LinePoint1);

    Control := XMVectorNearEqual(D, g_XMZero, g_XMEpsilon);

    Result := XMVectorSelect(Point, g_XMQNaN, Control);
end;



procedure XMPlaneIntersectPlane(out pLinePoint1: TXMVECTOR; out pLinePoint2: TXMVECTOR; P1: TFXMVECTOR; P2: TFXMVECTOR);
var
    V1, V2, V3: TXMVECTOR;
    LengthSq, P1W, Point: TXMVECTOR;
    P2W, Control: TXMVECTOR;
    LinePoint1, LinePoint2: TXMVECTOR;
begin
    V1 := XMVector3Cross(P2, P1);

    LengthSq := XMVector3LengthSq(V1);

    V2 := XMVector3Cross(P2, V1);

    P1W := XMVectorSplatW(P1);
    Point := XMVectorMultiply(V2, P1W);

    V3 := XMVector3Cross(V1, P1);

    P2W := XMVectorSplatW(P2);
    Point := XMVectorMultiplyAdd(V3, P2W, Point);

    LinePoint1 := XMVectorDivide(Point, LengthSq);

    LinePoint2 := XMVectorAdd(LinePoint1, V1);

    Control := XMVectorLessOrEqual(LengthSq, g_XMEpsilon);
    pLinePoint1 := XMVectorSelect(LinePoint1, g_XMQNaN, Control);
    pLinePoint2 := XMVectorSelect(LinePoint2, g_XMQNaN, Control);
end;



function XMPlaneTransform(P: TFXMVECTOR; m: TFXMMATRIX): TXMVECTOR;
var
    x, y, z, w: TXMVECTOR;
begin
    w := XMVectorSplatW(P);
    z := XMVectorSplatZ(P);
    y := XMVectorSplatY(P);
    x := XMVectorSplatX(P);

    Result := XMVectorMultiply(w, m.r[3]);
    Result := XMVectorMultiplyAdd(z, m.r[2], Result);
    Result := XMVectorMultiplyAdd(y, m.r[1], Result);
    Result := XMVectorMultiplyAdd(x, m.r[0], Result);
end;



function XMPlaneTransformStream(var pOutputStream: PXMFLOAT4; OutputStride: size_t; const pInputStream: PXMFLOAT4; InputStride: size_t; PlaneCount: size_t; m: TFXMMATRIX): PXMFLOAT4;
begin
    Result := XMVector4TransformStream(pOutputStream, OutputStride, pInputStream, InputStride, PlaneCount, m);
end;

// ------------------------------------------------------------------------------
// Conversion operations
// ------------------------------------------------------------------------------

function XMPlaneFromPointNormal(Point: TFXMVECTOR; Normal: TFXMVECTOR): TXMVECTOR;
var
    w: TXMVECTOR;
begin
    w := XMVector3Dot(Point, Normal);
    w := XMVectorNegate(w);
    Result := XMVectorSelect(w, Normal, g_XMSelect1110);
end;



function XMPlaneFromPoints(Point1: TFXMVECTOR; Point2: TFXMVECTOR; Point3: TFXMVECTOR): TXMVECTOR;
var
    V21, V31: TXMVECTOR;
    N, D: TXMVECTOR;
begin
    V21 := XMVectorSubtract(Point1, Point2);
    V31 := XMVectorSubtract(Point1, Point3);

    N := XMVector3Cross(V21, V31);
    N := XMVector3Normalize(N);

    D := XMPlaneDotNormal(N, Point1);
    D := XMVectorNegate(D);

    Result := XMVectorSelect(D, N, g_XMSelect1110);
end;

(* ***************************************************************************
  *
  * Color
  *
  *************************************************************************** *)

// ------------------------------------------------------------------------------
// Comparison operations
// ------------------------------------------------------------------------------

function XMColorEqual(C1: TFXMVECTOR; C2: TFXMVECTOR): boolean;
begin
    Result := XMVector4Equal(C1, C2);
end;



function XMColorNotEqual(C1: TFXMVECTOR; C2: TFXMVECTOR): boolean;
begin
    Result := XMVector4NotEqual(C1, C2);
end;



function XMColorGreater(C1: TFXMVECTOR; C2: TFXMVECTOR): boolean;
begin
    Result := XMVector4Greater(C1, C2);
end;



function XMColorGreaterOrEqual(C1: TFXMVECTOR; C2: TFXMVECTOR): boolean;
begin
    Result := XMVector4GreaterOrEqual(C1, C2);
end;



function XMColorLess(C1: TFXMVECTOR; C2: TFXMVECTOR): boolean;
begin
    Result := XMVector4Less(C1, C2);
end;



function XMColorLessOrEqual(C1: TFXMVECTOR; C2: TFXMVECTOR): boolean;
begin
    Result := XMVector4LessOrEqual(C1, C2);
end;



function XMColorIsNaN(C: TFXMVECTOR): boolean;
begin
    Result := XMVector4IsNaN(C);
end;



function XMColorIsInfinite(C: TFXMVECTOR): boolean;
begin
    Result := XMVector4IsInfinite(C);
end;

// ------------------------------------------------------------------------------
// Computation operations
// ------------------------------------------------------------------------------

function XMColorNegative(C: TFXMVECTOR): TXMVECTOR;
begin
    Result.vector4_f32[0] := 1.0 - C.vector4_f32[0];
    Result.vector4_f32[1] := 1.0 - C.vector4_f32[1];
    Result.vector4_f32[2] := 1.0 - C.vector4_f32[2];
    Result.vector4_f32[3] := C.vector4_f32[3];

end;



function XMColorModulate(C1: TFXMVECTOR; C2: TFXMVECTOR): TXMVECTOR;
begin
    Result := XMVectorMultiply(C1, C2);
end;



function XMColorAdjustSaturation(C: TFXMVECTOR; Saturation: single): TXMVECTOR;
const
    gvLuminance: TXMVECTOR = (vector4_f32: (0.2125, 0.7154, 0.0721, 0.0));
var
    fLuminance: single;
begin
    // Luminance = 0.2125f * C[0] + 0.7154f * C[1] + 0.0721f * C[2];
    // Result = (C - Luminance) * Saturation + Luminance;

    fLuminance := (C.vector4_f32[0] * gvLuminance.f[0]) + (C.vector4_f32[1] * gvLuminance.f[1]) + (C.vector4_f32[2] * gvLuminance.f[2]);

    Result.vector4_f32[0] := ((C.vector4_f32[0] - fLuminance) * Saturation) + fLuminance;
    Result.vector4_f32[1] := ((C.vector4_f32[1] - fLuminance) * Saturation) + fLuminance;
    Result.vector4_f32[2] := ((C.vector4_f32[2] - fLuminance) * Saturation) + fLuminance;
    Result.vector4_f32[3] := C.vector4_f32[3];
end;



function XMColorAdjustContrast(C: TFXMVECTOR; Contrast: single): TXMVECTOR;
begin
    // Result = (vColor - 0.5f) * fContrast + 0.5f;
    Result.vector4_f32[0] := ((C.vector4_f32[0] - 0.5) * Contrast) + 0.5;
    Result.vector4_f32[1] := ((C.vector4_f32[1] - 0.5) * Contrast) + 0.5;
    Result.vector4_f32[2] := ((C.vector4_f32[2] - 0.5) * Contrast) + 0.5;
    Result.vector4_f32[3] := C.vector4_f32[3]; // Leave W untouched
end;



function XMColorRGBToHSL(rgb: TFXMVECTOR): TXMVECTOR;
var
    r, g, b: TXMVECTOR;
    Min, Max: TXMVECTOR;
    L, D, la: TXMVECTOR;
    s, h: TXMVECTOR;
    D2: TXMVECTOR;
    lha: TXMVECTOR;
begin
    r := XMVectorSplatX(rgb);
    g := XMVectorSplatY(rgb);
    b := XMVectorSplatZ(rgb);

    Min := XMVectorMin(r, XMVectorMin(g, b));
    Max := XMVectorMax(r, XMVectorMax(g, b));

    L := XMVectorMultiply(XMVectorAdd(Min, Max), g_XMOneHalf);

    D := XMVectorSubtract(Max, Min);

    la := XMVectorSelect(rgb, L, g_XMSelect1110);

    if (XMVector3Less(D, g_XMEpsilon)) then
        // Achromatic, assume H and S of 0
        Result := XMVectorSelect(la, g_XMZero, g_XMSelect1100)

    else
    begin

        D2 := XMVectorAdd(Min, Max);

        if (XMVector3Greater(L, g_XMOneHalf)) then

            // d / (2-max-min)
            s := XMVectorDivide(D, XMVectorSubtract(g_XMTwo, D2))
        else

            // d / (max+min)
            s := XMVectorDivide(D, D2);

        if (XMVector3Equal(r, Max)) then
            // Red is max
            h := XMVectorDivide(XMVectorSubtract(g, b), D)
        else if (XMVector3Equal(g, Max)) then
        begin
            // Green is max
            h := XMVectorDivide(XMVectorSubtract(b, r), D);
            h := XMVectorAdd(h, g_XMTwo);
        end
        else
        begin
            // Blue is max
            h := XMVectorDivide(XMVectorSubtract(r, g), D);
            h := XMVectorAdd(h, g_XMFour);
        end;

        h := XMVectorDivide(h, g_XMSix);

        if (XMVector3Less(h, g_XMZero)) then
            h := XMVectorAdd(h, g_XMOne);

        lha := XMVectorSelect(la, h, g_XMSelect1100);
        Result := XMVectorSelect(s, lha, g_XMSelect1011);
    end;
end;



function XMColorHue2Clr(P: TFXMVECTOR; Q: TFXMVECTOR; h: TFXMVECTOR): TXMVECTOR;
const
    oneSixth: TXMVECTOR = (vector4_f32: (1.0 / 6.0, 1.0 / 6.0, 1.0 / 6.0, 1.0 / 6.0));
    twoThirds: TXMVECTOR = (vector4_f32: (2.0 / 3.0, 2.0 / 3.0, 2.0 / 3.0, 2.0 / 3.0));
var
    t, T1, t2: TXMVECTOR;
begin
    t := h;

    if (XMVector3Less(t, g_XMZero)) then
        t := XMVectorAdd(t, g_XMOne);

    if (XMVector3Greater(t, g_XMOne)) then
        t := XMVectorSubtract(t, g_XMOne);

    if (XMVector3Less(t, oneSixth)) then
    begin
        // p + (q - p) * 6 * t
        T1 := XMVectorSubtract(Q, P);
        t2 := XMVectorMultiply(g_XMSix, t);
        Result := XMVectorMultiplyAdd(T1, t2, P);
        Exit;
    end;

    if (XMVector3Less(t, g_XMOneHalf)) then
    begin
        Result := Q;
        Exit;
    end;

    if (XMVector3Less(t, twoThirds)) then
    begin
        // p + (q - p) * 6 * (2/3 - t)
        T1 := XMVectorSubtract(Q, P);
        t2 := XMVectorMultiply(g_XMSix, XMVectorSubtract(twoThirds, t));
        Result := XMVectorMultiplyAdd(T1, t2, P);
        Exit;
    end;

    Result := P;
end;



function XMColorHSLToRGB(hsl: TFXMVECTOR): TXMVECTOR;
const
    oneThird: TXMVECTOR = (vector4_f32: (1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0));
var
    s, L, h, Q, P, r, g, b, rg, ba: TXMVECTOR;
begin
    s := XMVectorSplatY(hsl);
    L := XMVectorSplatZ(hsl);

    if (XMVector3NearEqual(s, g_XMZero, g_XMEpsilon)) then
    begin
        // Achromatic
        Result := XMVectorSelect(hsl, L, g_XMSelect1110);
    end
    else
    begin
        h := XMVectorSplatX(hsl);

        if (XMVector3Less(L, g_XMOneHalf)) then
        begin
            Q := XMVectorMultiply(L, XMVectorAdd(g_XMOne, s));
        end
        else
        begin
            Q := XMVectorSubtract(XMVectorAdd(L, s), XMVectorMultiply(L, s));
        end;

        P := XMVectorSubtract(XMVectorMultiply(g_XMTwo, L), Q);

        r := XMColorHue2Clr(P, Q, XMVectorAdd(h, oneThird));
        g := XMColorHue2Clr(P, Q, h);
        b := XMColorHue2Clr(P, Q, XMVectorSubtract(h, oneThird));

        rg := XMVectorSelect(g, r, g_XMSelect1000);
        ba := XMVectorSelect(hsl, b, g_XMSelect1110);

        Result := XMVectorSelect(ba, rg, g_XMSelect1100);
    end;
end;



function XMColorRGBToHSV(rgb: TFXMVECTOR): TXMVECTOR;
var
    r, g, b, Min, v, D, s: TXMVECTOR;
    hv, hva, h: TXMVECTOR;
begin
    r := XMVectorSplatX(rgb);
    g := XMVectorSplatY(rgb);
    b := XMVectorSplatZ(rgb);

    Min := XMVectorMin(r, XMVectorMin(g, b));
    v := XMVectorMax(r, XMVectorMax(g, b));

    D := XMVectorSubtract(v, Min);

    if (XMVector3NearEqual(v, g_XMZero, g_XMEpsilon)) then
        s := g_XMZero
    else
        s := XMVectorDivide(D, v);

    if (XMVector3Less(D, g_XMEpsilon)) then
    begin
        // Achromatic, assume H of 0
        hv := XMVectorSelect(v, g_XMZero, g_XMSelect1000);
        hva := XMVectorSelect(rgb, hv, g_XMSelect1110);
        Result := XMVectorSelect(s, hva, g_XMSelect1011);
    end
    else
    begin
        if (XMVector3Equal(r, v)) then
        begin
            // Red is max
            h := XMVectorDivide(XMVectorSubtract(g, b), D);

            if (XMVector3Less(g, b)) then
                h := XMVectorAdd(h, g_XMSix);
        end
        else if (XMVector3Equal(g, v)) then
        begin
            // Green is max
            h := XMVectorDivide(XMVectorSubtract(b, r), D);
            h := XMVectorAdd(h, g_XMTwo);
        end
        else
        begin
            // Blue is max
            h := XMVectorDivide(XMVectorSubtract(r, g), D);
            h := XMVectorAdd(h, g_XMFour);
        end;

        h := XMVectorDivide(h, g_XMSix);

        hv := XMVectorSelect(v, h, g_XMSelect1000);
        hva := XMVectorSelect(rgb, hv, g_XMSelect1110);
        Result := XMVectorSelect(s, hva, g_XMSelect1011);
    end;
end;



function XMColorHSVToRGB(hsv: TFXMVECTOR): TXMVECTOR;
var
    h, s, v: TXMVECTOR;
    h6, i, f: TXMVECTOR;
    P, Q, t: TXMVECTOR;
    _rgb: TXMVECTOR;
    VT, qv, pv, pq, TP, vp: TXMVECTOR;
    ii: integer;
begin
    h := XMVectorSplatX(hsv);
    s := XMVectorSplatY(hsv);
    v := XMVectorSplatZ(hsv);

    h6 := XMVectorMultiply(h, g_XMSix);

    i := XMVectorFloor(h6);
    f := XMVectorSubtract(h6, i);

    // p = v* (1-s)
    P := XMVectorMultiply(v, XMVectorSubtract(g_XMOne, s));

    // q = v*(1-f*s)
    Q := XMVectorMultiply(v, XMVectorSubtract(g_XMOne, XMVectorMultiply(f, s)));

    // t = v*(1 - (1-f)*s)
    t := XMVectorMultiply(v, XMVectorSubtract(g_XMOne, XMVectorMultiply(XMVectorSubtract(g_XMOne, f), s)));

    ii := trunc(XMVectorGetX(XMVectorMod(i, g_XMSix)));
    case (ii) of

        0: // rgb = vtp
        begin
            VT := XMVectorSelect(t, v, g_XMSelect1000);
            _rgb := XMVectorSelect(P, VT, g_XMSelect1100);
        end;
        1: // rgb = qvp
        begin
            qv := XMVectorSelect(v, Q, g_XMSelect1000);
            _rgb := XMVectorSelect(P, qv, g_XMSelect1100);
        end;
        2: // rgb = pvt
        begin
            pv := XMVectorSelect(v, P, g_XMSelect1000);
            _rgb := XMVectorSelect(t, pv, g_XMSelect1100);
        end;
        3: // rgb = pqv
        begin
            pq := XMVectorSelect(Q, P, g_XMSelect1000);
            _rgb := XMVectorSelect(v, pq, g_XMSelect1100);
        end;
        4: // rgb = tpv
        begin
            TP := XMVectorSelect(P, t, g_XMSelect1000);
            _rgb := XMVectorSelect(v, TP, g_XMSelect1100);
        end;
        else // rgb = vpq
        begin
            vp := XMVectorSelect(P, v, g_XMSelect1000);
            _rgb := XMVectorSelect(Q, vp, g_XMSelect1100);
        end;
    end;

    Result := XMVectorSelect(hsv, _rgb, g_XMSelect1110);
end;



function XMColorRGBToYUV(rgb: TFXMVECTOR): TXMVECTOR;
const
    Scale0: TXMVECTOR = (vector4_f32: (0.299, -0.147, 0.615, 0.0));
    Scale1: TXMVECTOR = (vector4_f32: (0.587, -0.289, -0.515, 0.0));
    Scale2: TXMVECTOR = (vector4_f32: (0.114, 0.436, -0.100, 0.0));
var
    m: TXMMATRIX;
    clr: TXMVECTOR;
begin
    m := TXMMATRIX.Create(Scale0, Scale1, Scale2, g_XMZero);
    clr := XMVector3Transform(rgb, m);

    Result := XMVectorSelect(rgb, clr, g_XMSelect1110);
end;



function XMColorYUVToRGB(yuv: TFXMVECTOR): TXMVECTOR;
const
    Scale1: TXMVECTOR = (vector4_f32: (0.0, -0.395, 2.032, 0.0));
    Scale2: TXMVECTOR = (vector4_f32: (1.140, -0.581, 0.0, 0.0));
var
    m: TXMMATRIX;
    clr: TXMVECTOR;
begin
    m := TXMMATRIX.Create(g_XMOne, Scale1, Scale2, g_XMZero);
    clr := XMVector3Transform(yuv, m);

    Result := XMVectorSelect(yuv, clr, g_XMSelect1110);
end;



function XMColorRGBToYUV_HD(rgb: TFXMVECTOR): TXMVECTOR;
const
    Scale0: TXMVECTOR = (vector4_f32: (0.2126, -0.0997, 0.6150, 0.0));
    Scale1: TXMVECTOR = (vector4_f32: (0.7152, -0.3354, -0.5586, 0.0));
    Scale2: TXMVECTOR = (vector4_f32: (0.0722, 0.4351, -0.0564, 0.0));
var
    m: TXMMATRIX;
    clr: TXMVECTOR;
begin
    m := TXMMATRIX.Create(Scale0, Scale1, Scale2, g_XMZero);
    clr := XMVector3Transform(rgb, m);

    Result := XMVectorSelect(rgb, clr, g_XMSelect1110);
end;



function XMColorYUVToRGB_HD(yuv: TFXMVECTOR): TXMVECTOR;
const
    Scale1: TXMVECTOR = (vector4_f32: (0.0, -0.2153, 2.1324, 0.0));
    Scale2: TXMVECTOR = (vector4_f32: (1.2803, -0.3806, 0.0, 0.0));
var
    m: TXMMATRIX;
    clr: TXMVECTOR;
begin
    m := TXMMATRIX.Create(g_XMOne, Scale1, Scale2, g_XMZero);
    clr := XMVector3Transform(yuv, m);

    Result := XMVectorSelect(yuv, clr, g_XMSelect1110);
end;



function XMColorRGBToYUV_UHD(rgb: TFXMVECTOR): TXMVECTOR;
const
    Scale0: TXMVECTOR = (vector4_f32: (0.2627, -0.1215, 0.6150, 0.0));
    Scale1: TXMVECTOR = (vector4_f32: (0.6780, -0.3136, -0.5655, 0.0));
    Scale2: TXMVECTOR = (vector4_f32: (0.0593, 0.4351, -0.0495, 0.0));
var
    m: TXMMATRIX;
    clr: TXMVECTOR;
begin
    m := TXMMATRIX.Create(Scale0, Scale1, Scale2, g_XMZero);
    clr := XMVector3Transform(rgb, m);

    Result := XMVectorSelect(rgb, clr, g_XMSelect1110);
end;



function XMColorYUVToRGB_UHD(yuv: TFXMVECTOR): TXMVECTOR;
const
    Scale1: TXMVECTOR = (vector4_f32: (0.0, -0.1891, 2.1620, 0.0));
    Scale2: TXMVECTOR = (vector4_f32: (1.1989, -0.4645, 0.0, 0.0));
var
    m: TXMMATRIX;
    clr: TXMVECTOR;
begin
    m := TXMMATRIX.Create(g_XMOne, Scale1, Scale2, g_XMZero);
    clr := XMVector3Transform(yuv, m);

    Result := XMVectorSelect(yuv, clr, g_XMSelect1110);
end;



function XMColorRGBToXYZ(rgb: TFXMVECTOR): TXMVECTOR;
const
    Scale0: TXMVECTOR = (vector4_f32: (0.4887180, 0.1762044, 0.0000000, 0.0));
    Scale1: TXMVECTOR = (vector4_f32: (0.3106803, 0.8129847, 0.0102048, 0.0));
    Scale2: TXMVECTOR = (vector4_f32: (0.2006017, 0.0108109, 0.9897952, 0.0));
    Scale: TXMVECTOR = (vector4_f32: (1.0 / 0.17697, 1.0 / 0.17697, 1.0 / 0.17697, 0.0));
var
    m: TXMMATRIX;
    clr: TXMVECTOR;
begin
    m := TXMMATRIX.Create(Scale0, Scale1, Scale2, g_XMZero);
    clr := XMVectorMultiply(XMVector3Transform(rgb, m), Scale);

    Result := XMVectorSelect(rgb, clr, g_XMSelect1110);
end;



function XMColorXYZToRGB(xyz: TFXMVECTOR): TXMVECTOR;
const
    Scale0: TXMVECTOR = (vector4_f32: (2.3706743, -0.5138850, 0.0052982, 0.0));
    Scale1: TXMVECTOR = (vector4_f32: (-0.9000405, 1.4253036, -0.0146949, 0.0));
    Scale2: TXMVECTOR = (vector4_f32: (-0.4706338, 0.0885814, 1.0093968, 0.0));
    Scale: TXMVECTOR = (vector4_f32: (0.17697, 0.17697, 0.17697, 0.0));
var
    m: TXMMATRIX;
    clr: TXMVECTOR;
begin
    m := TXMMATRIX.Create(Scale0, Scale1, Scale2, g_XMZero);
    clr := XMVector3Transform(XMVectorMultiply(xyz, Scale), m);

    Result := XMVectorSelect(xyz, clr, g_XMSelect1110);
end;



function XMColorXYZToSRGB(xyz: TFXMVECTOR): TXMVECTOR;
const
    Scale0: TXMVECTOR = (vector4_f32: (3.2406, -0.9689, 0.0557, 0.0));
    Scale1: TXMVECTOR = (vector4_f32: (-1.5372, 1.8758, -0.2040, 0.0));
    Scale2: TXMVECTOR = (vector4_f32: (-0.4986, 0.0415, 1.0570, 0.0));
    Cutoff: TXMVECTOR = (vector4_f32: (0.0031308, 0.0031308, 0.0031308, 0.0));
    exp: TXMVECTOR = (vector4_f32: (1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4, 1.0));
var
    m: TXMMATRIX;
    lclr, sel, clr: TXMVECTOR;
    smallC, largeC: TXMVECTOR;
begin
    m := TXMMATRIX.Create(Scale0, Scale1, Scale2, g_XMZero);
    lclr := XMVector3Transform(xyz, m);

    sel := XMVectorGreater(lclr, Cutoff);

    // clr = 12.92 * lclr for lclr <= 0.0031308f
    smallC := XMVectorMultiply(lclr, g_XMsrgbScale);

    // clr = (1+a)*pow(lclr, 1/2.4) - a for lclr > 0.0031308 (where a = 0.055)
    largeC := XMVectorSubtract(XMVectorMultiply(g_XMsrgbA1, XMVectorPow(lclr, exp)), g_XMsrgbA);

    clr := XMVectorSelect(smallC, largeC, sel);

    Result := XMVectorSelect(xyz, clr, g_XMSelect1110);
end;



function XMColorSRGBToXYZ(srgb: TFXMVECTOR): TXMVECTOR;
const
    Scale0: TXMVECTOR = (vector4_f32: (0.4124, 0.2126, 0.0193, 0.0));
    Scale1: TXMVECTOR = (vector4_f32: (0.3576, 0.7152, 0.1192, 0.0));
    Scale2: TXMVECTOR = (vector4_f32: (0.1805, 0.0722, 0.9505, 0.0));
    Cutoff: TXMVECTOR = (vector4_f32: (0.04045, 0.04045, 0.04045, 0.0));
    exp: TXMVECTOR = (vector4_f32: (2.4, 2.4, 2.4, 1.0));
var
    m: TXMMATRIX;
    clr: TXMVECTOR;
    sel, smallC, largeC, lclr: TXMVECTOR;
begin
    sel := XMVectorGreater(srgb, Cutoff);

    // lclr = clr / 12.92
    smallC := XMVectorDivide(srgb, g_XMsrgbScale);

    // lclr = pow( (clr + a) / (1+a), 2.4 )
    largeC := XMVectorPow(XMVectorDivide(XMVectorAdd(srgb, g_XMsrgbA), g_XMsrgbA1), exp);

    lclr := XMVectorSelect(smallC, largeC, sel);

    m := TXMMATRIX.Create(Scale0, Scale1, Scale2, g_XMZero);
    clr := XMVector3Transform(lclr, m);

    Result := XMVectorSelect(srgb, clr, g_XMSelect1110);
end;



function XMColorRGBToSRGB(rgb: TFXMVECTOR): TXMVECTOR;
const
    Cutoff: TXMVECTOR = (vector4_f32: (0.0031308, 0.0031308, 0.0031308, 1.0));
    Linear: TXMVECTOR = (vector4_f32: (12.92, 12.92, 12.92, 1.0));
    Scale: TXMVECTOR = (vector4_f32: (1.055, 1.055, 1.055, 1.0));
    Bias: TXMVECTOR = (vector4_f32: (0.055, 0.055, 0.055, 0.0));
    InvGamma: TXMVECTOR = (vector4_f32: (1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4, 1.0));
var
    v, V0, V1, Select: TXMVECTOR;
begin
    v := XMVectorSaturate(rgb);
    V0 := XMVectorMultiply(v, Linear);
    V1 := XMVectorSubtract(XMVectorMultiply(Scale, XMVectorPow(v, InvGamma)), Bias);
    Select := XMVectorLess(v, Cutoff);
    v := XMVectorSelect(V1, V0, Select);
    Result := XMVectorSelect(rgb, v, g_XMSelect1110);
end;



function XMColorSRGBToRGB(srgb: TFXMVECTOR): TXMVECTOR;

const
    Cutoff: TXMVECTOR = (vector4_f32: (0.04045, 0.04045, 0.04045, 1.0));
    ILinear: TXMVECTOR = (vector4_f32: (1.0 / 12.92, 1.0 / 12.92, 1.0 / 12.92, 1.0));
    Scale: TXMVECTOR = (vector4_f32: (1.0 / 1.055, 1.0 / 1.055, 1.0 / 1.055, 1.0));
    Bias: TXMVECTOR = (vector4_f32: (0.055, 0.055, 0.055, 0.0));
    Gamma: TXMVECTOR = (vector4_f32: (2.4, 2.4, 2.4, 1.0));
var
    v, V0, V1, Select: TXMVECTOR;
begin
    v := XMVectorSaturate(srgb);
    V0 := XMVectorMultiply(v, ILinear);
    V1 := XMVectorPow(XMVectorMultiply(XMVectorAdd(v, Bias), Scale), Gamma);
    Select := XMVectorGreater(v, Cutoff);
    v := XMVectorSelect(V0, V1, Select);
    Result := XMVectorSelect(srgb, v, g_XMSelect1110);
end;

(* ***************************************************************************
  *
  * Miscellaneous
  *
  *************************************************************************** *)

function XMVerifyCPUSupport(): boolean;
begin

end;



function XMFresnelTerm(CosIncidentAngle: TFXMVECTOR; RefractionIndex: TFXMVECTOR): TXMVECTOR;
var
    g, s, D: TXMVECTOR;
    V0, V1, V2, V3: TXMVECTOR;
begin
    // Result = 0.5f * (g - c)^2 / (g + c)^2 * ((c * (g + c) - 1)^2 / (c * (g - c) + 1)^2 + 1) where
    // c = CosIncidentAngle
    // g = sqrt(c^2 + RefractionIndex^2 - 1)

    g := XMVectorMultiplyAdd(RefractionIndex, RefractionIndex, g_XMNegativeOne);
    g := XMVectorMultiplyAdd(CosIncidentAngle, CosIncidentAngle, g);
    g := XMVectorAbs(g);
    g := XMVectorSqrt(g);

    s := XMVectorAdd(g, CosIncidentAngle);
    D := XMVectorSubtract(g, CosIncidentAngle);

    V0 := XMVectorMultiply(D, D);
    V1 := XMVectorMultiply(s, s);
    V1 := XMVectorReciprocal(V1);
    V0 := XMVectorMultiply(g_XMOneHalf, V0);
    V0 := XMVectorMultiply(V0, V1);

    V2 := XMVectorMultiplyAdd(CosIncidentAngle, s, g_XMNegativeOne);
    V3 := XMVectorMultiplyAdd(CosIncidentAngle, D, g_XMOne);
    V2 := XMVectorMultiply(V2, V2);
    V3 := XMVectorMultiply(V3, V3);
    V3 := XMVectorReciprocal(V3);
    V2 := XMVectorMultiplyAdd(V2, V3, g_XMOne);

    Result := XMVectorMultiply(V0, V2);

    Result := XMVectorSaturate(Result);
end;



function XMScalarNearEqual(S1, S2, Epsilon: single): boolean;
var
    Delta: single;
begin
    Delta := S1 - S2;
    Result := (abs(Delta) <= Epsilon);
end;

// Modulo the range of the given angle such that -XM_PI <= Angle < XM_PI

function XMScalarModAngle(Value: single): single;
begin
    // Note: The modulo is performed with unsigned math only to work
    // around a precision error on numbers that are close to PI

    // Normalize the range from 0.0f to XM_2PI
    Value := Value + XM_PI;
    // Perform the modulo, unsigned
    Result := abs(Value);
    Result := Result - (XM_2PI * trunc(Result / XM_2PI));
    // Restore the number to the range of -XM_PI to XM_PI-epsilon
    Result := Result - XM_PI;
    // If the modulo'd value was negative, restore negation
    if (Value < 0.0) then
        Result := -Result;
end;



function XMScalarSin(Value: single): single;
var
    Quotient, y, y2: single;
begin
    // Map Value to y in [-pi,pi], x = 2*pi*quotient + remainder.
    Quotient := XM_1DIV2PI * Value;
    if (Value >= 0.0) then
        Quotient := trunc(Quotient + 0.5)
    else
        Quotient := trunc(Quotient - 0.5);

    y := Value - XM_2PI * Quotient;

    // Map y to [-pi/2,pi/2] with sin(y) = sin(Value).
    if (y > XM_PIDIV2) then
        y := XM_PI - y
    else if (y < -XM_PIDIV2) then
        y := -XM_PI - y;

    // 11-degree minimax approximation
    y2 := y * y;
    Result := (((((-2.3889859E-08 * y2 + 2.7525562E-06) * y2 - 0.00019840874) * y2 + 0.0083333310) * y2 - 0.16666667) * y2 + 1.0) * y;
end;



function XMScalarSinEst(Value: single): single;
var
    Quotient, y, y2: single;
begin
    // Map Value to y in [-pi,pi], x = 2*pi*quotient + remainder.
    Quotient := XM_1DIV2PI * Value;
    if (Value >= 0.0) then
        Quotient := trunc(Quotient + 0.5)
    else
        Quotient := trunc(Quotient - 0.5);

    y := Value - XM_2PI * Quotient;

    // Map y to [-pi/2,pi/2] with sin(y) = sin(Value).
    if (y > XM_PIDIV2) then

        y := XM_PI - y

    else if (y < -XM_PIDIV2) then
        y := -XM_PI - y;

    // 7-degree minimax approximation
    y2 := y * y;
    Result := (((-0.00018524670 * y2 + 0.0083139502) * y2 - 0.16665852) * y2 + 1.0) * y;
end;



function XMScalarCos(Value: single): single;
var
    Quotient, y, y2, Sign: single;
begin
    // Map Value to y in [-pi,pi], x = 2*pi*quotient + remainder.
    Quotient := XM_1DIV2PI * Value;
    if (Value >= 0.0) then
        Quotient := trunc(Quotient + 0.5)
    else
        Quotient := trunc(Quotient - 0.5);
    y := Value - XM_2PI * Quotient;

    // Map y to [-pi/2,pi/2] with cos(y) = sign*cos(x).

    if (y > XM_PIDIV2) then
    begin
        y := XM_PI - y;
        Sign := -1.0;
    end
    else if (y < -XM_PIDIV2) then
    begin
        y := -XM_PI - y;
        Sign := -1.0;
    end
    else
        Sign := +1.0;

    // 10-degree minimax approximation
    y2 := y * y;
    Result := ((((-2.6051615E-07 * y2 + 2.4760495E-05) * y2 - 0.0013888378) * y2 + 0.041666638) * y2 - 0.5) * y2 + 1.0;
    Result := Sign * Result;
end;



function XMScalarCosEst(Value: single): single;
var
    Quotient, y, y2, Sign: single;
begin
    // Map Value to y in [-pi,pi], x = 2*pi*quotient + remainder.
    Quotient := XM_1DIV2PI * Value;
    if (Value >= 0.0) then
        Quotient := trunc(Quotient + 0.5)
    else
        Quotient := trunc(Quotient - 0.5);

    y := Value - XM_2PI * Quotient;

    // Map y to [-pi/2,pi/2] with cos(y) = sign*cos(x).
    if (y > XM_PIDIV2) then
    begin
        y := XM_PI - y;
        Sign := -1.0;
    end
    else if (y < -XM_PIDIV2) then
    begin
        y := -XM_PI - y;
        Sign := -1.0;
    end
    else
        Sign := +1.0;

    // 6-degree minimax approximation
    y2 := y * y;
    Result := ((-0.0012712436 * y2 + 0.041493919) * y2 - 0.49992746) * y2 + 1.0;
    Result := Sign * Result;
end;



procedure XMScalarSinCos(out pSin: single; out pCos: single; Value: single);
var
    Quotient, y, y2, Sign: single;
begin
    // Map Value to y in [-pi,pi], x = 2*pi*quotient + remainder.
    Quotient := XM_1DIV2PI * Value;
    if (Value >= 0.0) then
        Quotient := trunc(Quotient + 0.5)
    else
        Quotient := trunc(Quotient - 0.5);

    y := Value - XM_2PI * Quotient;

    // Map y to [-pi/2,pi/2] with sin(y) = sin(Value).
    if (y > XM_PIDIV2) then
    begin
        y := XM_PI - y;
        Sign := -1.0;
    end
    else if (y < -XM_PIDIV2) then
    begin
        y := -XM_PI - y;
        Sign := -1.0;
    end
    else
        Sign := +1.0;

    y2 := y * y;

    // 11-degree minimax approximation
    pSin := (((((-2.3889859E-08 * y2 + 2.7525562E-06) * y2 - 0.00019840874) * y2 + 0.0083333310) * y2 - 0.16666667) * y2 + 1.0) * y;

    // 10-degree minimax approximation
    pCos := ((((-2.6051615E-07 * y2 + 2.4760495E-05) * y2 - 0.0013888378) * y2 + 0.041666638) * y2 - 0.5) * y2 + 1.0;
    pCos := Sign * pCos;
end;



procedure XMScalarSinCosEst(out pSin: single; out pCos: single; Value: single);
var
    Quotient, y, y2, Sign: single;
begin
    // Map Value to y in [-pi,pi], x = 2*pi*quotient + remainder.
    Quotient := XM_1DIV2PI * Value;
    if (Value >= 0.0) then
        Quotient := trunc(Quotient + 0.5)
    else
        Quotient := trunc(Quotient - 0.5);

    y := Value - XM_2PI * Quotient;

    // Map y to [-pi/2,pi/2] with sin(y) = sin(Value).
    if (y > XM_PIDIV2) then
    begin
        y := XM_PI - y;
        Sign := -1.0;
    end
    else if (y < -XM_PIDIV2) then
    begin
        y := -XM_PI - y;
        Sign := -1.0;
    end
    else
        Sign := +1.0;

    y2 := y * y;

    // 7-degree minimax approximation
    pSin := (((-0.00018524670 * y2 + 0.0083139502) * y2 - 0.16665852) * y2 + 1.0) * y;

    // 6-degree minimax approximation
    pCos := ((-0.0012712436 * y2 + 0.041493919) * y2 - 0.49992746) * y2 + 1.0;
    pCos := Sign * pCos;
end;



function XMScalarASin(Value: single): single;
var
    nonnegative: boolean;
    x, omx, root: single;
begin
    // Clamp input to [-1,1].
    nonnegative := (Value >= 0.0);
    x := abs(Value);
    omx := 1.0 - x;
    if (omx < 0.0) then
        omx := 0.0;

    root := sqrt(omx);

    // 7-degree minimax approximation
    Result := ((((((-0.0012624911 * x + 0.0066700901) * x - 0.0170881256) * x + 0.0308918810) * x - 0.0501743046) * x + 0.0889789874) * x - 0.2145988016) * x + 1.5707963050;
    Result := Result * root; // acos(|x|)

    // acos(x) = pi - acos(-x) when x < 0, asin(x) = pi/2 - acos(x)
    if nonnegative then
        Result := XM_PIDIV2 - Result
    else
        Result := Result - XM_PIDIV2;
end;



function XMScalarASinEst(Value: single): single;
var
    nonnegative: boolean;
    x, omx, root: single;
begin
    // Clamp input to [-1,1].
    nonnegative := (Value >= 0.0);
    x := abs(Value);
    omx := 1.0 - x;
    if (omx < 0.0) then
        omx := 0.0;

    root := sqrt(omx);

    // 3-degree minimax approximation
    Result := ((-0.0187293 * x + 0.0742610) * x - 0.2121144) * x + 1.5707288;
    Result := Result * root; // acos(|x|)

    // acos(x) = pi - acos(-x) when x < 0, asin(x) = pi/2 - acos(x)
    if nonnegative then
        Result := XM_PIDIV2 - Result
    else
        Result := Result - XM_PIDIV2;
end;



function XMScalarACos(Value: single): single;
var
    nonnegative: boolean;
    x, omx, root: single;
begin
    // Clamp input to [-1,1].
    nonnegative := (Value >= 0.0);
    x := abs(Value);
    omx := 1.0 - x;
    if (omx < 0.0) then
        omx := 0.0;
    root := sqrt(omx);

    // 7-degree minimax approximation
    Result := ((((((-0.0012624911 * x + 0.0066700901) * x - 0.0170881256) * x + 0.0308918810) * x - 0.0501743046) * x + 0.0889789874) * x - 0.2145988016) * x + 1.5707963050;
    Result := Result * root;

    // acos(x) = pi - acos(-x) when x < 0
    if nonnegative then
        Result := Result
    else
        Result := XM_PI - Result;
end;



function XMScalarACosEst(Value: single): single;
var
    nonnegative: boolean;
    x, omx, root: single;
begin
    // Clamp input to [-1,1].
    nonnegative := (Value >= 0.0);
    x := abs(Value);
    omx := 1.0 - x;
    if (omx < 0.0) then
        omx := 0.0;

    root := sqrt(omx);

    // 3-degree minimax approximation
    Result := ((-0.0187293 * x + 0.0742610) * x - 0.2121144) * x + 1.5707288;
    Result := Result * root;

    // acos(x) = pi - acos(-x) when x < 0
    if nonnegative then
        Result := Result
    else
        Result := XM_PI - Result;
end;

{$ENDREGION}// DirectXMathMisc

// General permute template
function XMVectorPermute(PermuteX, PermuteY, PermuteZ, PermuteW: uint32; V1: TFXMVECTOR; V2: TFXMVECTOR): TXMVECTOR; overload;
begin
{$IFDEF WithAssert}
    assert(PermuteX <= 7, 'PermuteX template parameter out of range');
    assert(PermuteY <= 7, 'PermuteY template parameter out of range');
    assert(PermuteZ <= 7, 'PermuteZ template parameter out of range');
    assert(PermuteW <= 7, 'PermuteW template parameter out of range');
{$ENDIF}
    // Special-case permute templates
    if ((PermuteX = 0) and (PermuteY = 1) and (PermuteZ = 2) and (PermuteZ = 3)) then
        Result := V1
    else if ((PermuteX = 4) and (PermuteY = 5) and (PermuteZ = 6) and (PermuteZ = 7)) then
        Result := V2
    else
        Result := XMVectorPermute(V1, V2, PermuteX, PermuteY, PermuteZ, PermuteW);
end;

// General swizzle template

function XMVectorSwizzle(SwizzleX, SwizzleY, SwizzleZ, SwizzleW: uint32; v: TFXMVECTOR): TXMVECTOR; overload;
begin
{$IFDEF WithAssert}
    assert(SwizzleX <= 3, 'SwizzleX template parameter out of range');
    assert(SwizzleY <= 3, 'SwizzleY template parameter out of range');
    assert(SwizzleZ <= 3, 'SwizzleZ template parameter out of range');
    assert(SwizzleW <= 3, 'SwizzleW template parameter out of range');
{$ENDIF}
    // Specialized swizzles
    if ((SwizzleX = 0) and (SwizzleY = 1) and (SwizzleZ = 2) and (SwizzleW = 3)) then
        Result := v
    else
        Result := XMVectorSwizzle(v, SwizzleX, SwizzleY, SwizzleZ, SwizzleW);
end;

{$IFDEF FPC}

function XMMin<t>(a, b: t): t;
begin
    if a < b then
        Result := a
    else
        Result := b;
end;

function XMMax<t>(a, b: t): t;
begin
    if a > b then
        Result := a
    else
        Result := b;
end;
{$ENDIF}


end.
