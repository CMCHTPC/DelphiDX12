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

    { TXMBYTEN2 }

    TXMBYTEN2 = packed record
        class operator Initialize(var a: TXMBYTEN2);
        constructor Create(a: uint16); overload;
        constructor Create(_x, _y: int8); overload;
        constructor Create(pArray: Pint8); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y: single); overload;
        class operator Explicit(c: TXMBYTEN2): uint16;
        class operator Explicit(c: uint16): TXMBYTEN2;
        case byte of
            0: (x: int8;
                y: int8);
            1: (v: uint16);
    end;

    PXMBYTEN2 = ^TXMBYTEN2;

    // 2D Vector; 8 bit signed integer components

    { TXMBYTE2 }

    TXMBYTE2 = packed record
        class operator Initialize(var a: TXMBYTE2);
        constructor Create(a: uint16); overload;
        constructor Create(_x, _y: int8); overload;
        constructor Create(pArray: Pint8); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y: single); overload;
        class operator Explicit(c: TXMBYTE2): uint16;
        class operator Explicit(c: uint16): TXMBYTE2;
        case byte of
            0: (x: int8;
                y: int8);
            1: (v: uint16);
    end;

    PXMBYTE2 = ^TXMBYTE2;

    // 2D Vector; 8 bit unsigned normalized integer components

    { TXMUBYTEN2 }

    TXMUBYTEN2 = packed record
        class operator Initialize(var a: TXMUBYTEN2);
        constructor Create(a: uint16); overload;
        constructor Create(_x, _y: uint8); overload;
        constructor Create(pArray: Puint8); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y: single); overload;
        class operator Explicit(c: TXMUBYTEN2): uint16;
        class operator Explicit(c: uint16): TXMUBYTEN2;
        case byte of
            0: (x: byte;
                y: byte);
            1: (v: uint16);
    end;
    PXMUBYTEN2 = ^TXMUBYTEN2;

    // 2D Vector; 8 bit unsigned integer components

    { TXMUBYTE2 }

    TXMUBYTE2 = record
        class operator Initialize(var a: TXMUBYTE2);
        constructor Create(a: uint16); overload;
        constructor Create(_x, _y: uint8); overload;
        constructor Create(pArray: Puint8); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y: single); overload;
        class operator Explicit(c: TXMUBYTE2): uint16;
        class operator Explicit(c: uint16): TXMUBYTE2;
        case byte of
            0: (x: byte;
                y: byte);
            1: (v: uint16);
    end;
    PXMUBYTE2 = ^TXMUBYTE2;

    // 3D vector: 5/6/5 unsigned integer components

    { TXMU565 }

    TXMU565 = bitpacked record
        constructor Create(a: uint16); overload;
        constructor Create(_x, _y, _z: uint8); overload;
        constructor Create(pArray: Puint8); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y, _z: single); overload;
        class operator Explicit(c: TXMU565): uint16;
        class operator Explicit(c: uint16): TXMU565;
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

    { TXMFLOAT3PK }

    TXMFLOAT3PK = bitpacked record
        constructor Create(a: uint32); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y, _z: single); overload;
        class operator Explicit(c: TXMFLOAT3PK): uint32;
        class operator Explicit(c: uint32): TXMFLOAT3PK;
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

    { TXMFLOAT3SE }

    TXMFLOAT3SE = bitpacked record
        constructor Create(a: uint32); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y, _z: single); overload;
        class operator Explicit(c: TXMFLOAT3SE): uint32;
        class operator Explicit(c: uint32): TXMFLOAT3SE;
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

    { TXMHALF4 }

    TXMHALF4 = packed record
        class operator Initialize(var a: TXMHALF4);
        constructor Create(a: uint64); overload;
        constructor Create(_x, _y, _z, _w: THALF); overload;
        constructor Create(pArray: PHALF); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y, _z, _w: single); overload;
        class operator Explicit(c: TXMHALF4): uint64;
        class operator Explicit(c: uint64): TXMHALF4;
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

    { TXMSHORTN4 }

    TXMSHORTN4 = packed record
        class operator Initialize(var a: TXMSHORTN4);
        constructor Create(a: uint64); overload;
        constructor Create(_x, _y, _z, _w: int16); overload;
        constructor Create(pArray: Pint16); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y, _z, _w: single); overload;
        class operator Explicit(c: TXMSHORTN4): uint64;
        class operator Explicit(c: uint64): TXMSHORTN4;
        case byte of
            0: (x: int16;
                y: int16;
                z: int16;
                w: int16);
            1: (v: uint64);
    end;

    PXMSHORTN4 = ^TXMSHORTN4;

    // 4D Vector; 16 bit signed integer components

    { TXMSHORT4 }

    TXMSHORT4 = packed record
        class operator Initialize(var a: TXMSHORT4);
        constructor Create(a: uint64); overload;
        constructor Create(_x, _y, _z, _w: int16); overload;
        constructor Create(pArray: Pint16); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y, _z, _w: single); overload;
        class operator Explicit(c: TXMSHORT4): uint64;
        class operator Explicit(c: uint64): TXMSHORT4;
        case byte of
            0: (x: int16;
                y: int16;
                z: int16;
                w: int16);
            1: (v: uint64);
    end;

    PXMSHORT4 = ^TXMSHORT4;

    // 4D Vector; 16 bit unsigned normalized integer components

    { TXMUSHORTN4 }

    TXMUSHORTN4 = packed record
        class operator Initialize(var a: TXMUSHORTN4);
        constructor Create(a: uint64); overload;
        constructor Create(_x, _y, _z, _w: int16); overload;
        constructor Create(pArray: Pint16); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y, _z, _w: single); overload;
        class operator Explicit(c: TXMUSHORTN4): uint64;
        class operator Explicit(c: uint64): TXMUSHORTN4;
        case byte of
            0: (x: uint16;
                y: uint16;
                z: uint16;
                w: uint16);
            1: (v: uint64);
    end;

    PXMUSHORTN4 = ^TXMUSHORTN4;

    // 4D Vector; 16 bit unsigned integer components

    { TXMUSHORT4 }

    TXMUSHORT4 = packed record
        class operator Initialize(var a: TXMUSHORT4);
        constructor Create(a: uint64); overload;
        constructor Create(_x, _y, _z, _w: uint16); overload;
        constructor Create(pArray: Puint16); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y, _z, _w: single); overload;
        class operator Explicit(c: TXMUSHORT4): uint64;
        class operator Explicit(c: uint64): TXMUSHORT4;
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

    { TXMXDECN4 }

    TXMXDECN4 = bitpacked record
        constructor Create(a: uint32); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y, _z, _w: single); overload;
        class operator Explicit(c: TXMXDECN4): uint32;
        class operator Explicit(c: uint32): TXMXDECN4;
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

    { TXMXDEC4 }

    TXMXDEC4 = bitpacked record
        constructor Create(a: uint32); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y, _z, _w: single); overload;
        class operator Explicit(c: TXMXDEC4): uint32;
        class operator Explicit(c: uint32): TXMXDEC4;
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

    { TXMDECN4 }

    TXMDECN4 = bitpacked record
        constructor Create(a: uint32); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y, _z, _w: single); overload;
        class operator Explicit(c: TXMDECN4): uint32;
        class operator Explicit(c: uint32): TXMDECN4;
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

    { TXMDEC4 }

    TXMDEC4 = bitpacked record
        constructor Create(a: uint32); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y, _z, _w: single); overload;
        class operator Explicit(c: TXMDEC4): uint32;
        class operator Explicit(c: uint32): TXMDEC4;
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

    { TXMUDECN4 }

    TXMUDECN4 = bitpacked record
        constructor Create(a: uint32); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y, _z, _w: single); overload;
        class operator Explicit(c: TXMUDECN4): uint32;
        class operator Explicit(c: uint32): TXMUDECN4;
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

    { TXMUDEC4 }

    TXMUDEC4 = bitpacked record
        constructor Create(a: uint32); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y, _z, _w: single); overload;
        class operator Explicit(c: TXMUDEC4): uint32;
        class operator Explicit(c: uint32): TXMUDEC4;
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

    { TXMBYTEN4 }

    TXMBYTEN4 = packed record
        class operator Initialize(var a: TXMBYTEN4);
        constructor Create(a: uint32); overload;
        constructor Create(_x, _y, _z, _w: int8); overload;
        constructor Create(pArray: Pint8); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y, _z, _w: single); overload;
        class operator Explicit(c: TXMBYTEN4): uint32;
        class operator Explicit(c: uint32): TXMBYTEN4;
        case byte of
            0: (
                x: int8;
                y: int8;
                z: int8;
                w: int8;
            );
            1: (v: uint32);
    end;

    PXMBYTEN4 = ^TXMBYTEN4;

    // 4D Vector; 8 bit signed integer components

    { TXMBYTE4 }

    TXMBYTE4 = packed record
        class operator Initialize(var a: TXMBYTE4);
        constructor Create(a: uint32); overload;
        constructor Create(_x, _y, _z, _w: int8); overload;
        constructor Create(pArray: Pint8); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y, _z, _w: single); overload;
        class operator Explicit(c: TXMBYTE4): uint32;
        class operator Explicit(c: uint32): TXMBYTE4;
        case byte of
            0: (x: int8;
                y: int8;
                z: int8;
                w: int8;);
            1: (v: uint32);
    end;

    PXMBYTE4 = ^TXMBYTE4;

    // 4D Vector; 8 bit unsigned normalized integer components

    { TXMUBYTEN4 }

    TXMUBYTEN4 = packed record
        class operator Initialize(var a: TXMUBYTEN4);
        constructor Create(a: uint32); overload;
        constructor Create(_x, _y, _z, _w: byte); overload;
        constructor Create(pArray: pbyte); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y, _z, _w: single); overload;
        class operator Explicit(c: TXMUBYTEN4): uint32;
        class operator Explicit(c: uint32): TXMUBYTEN4;
        case byte of
            0: (x: byte;
                y: byte;
                z: byte;
                w: byte;);
            1: (v: uint32);
    end;

    PXMUBYTEN4 = ^TXMUBYTEN4;

    // 4D Vector; 8 bit unsigned integer components

    { TXMUBYTE4 }

    TXMUBYTE4 = packed record
        class operator Initialize(var a: TXMUBYTE4);
        constructor Create(a: uint32); overload;
        constructor Create(_x, _y, _z, _w: byte); overload;
        constructor Create(pArray: pbyte); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y, _z, _w: single); overload;
        class operator Explicit(c: TXMUBYTE4): uint32;
        class operator Explicit(c: uint32): TXMUBYTE4;
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

    { TXMUNIBBLE4 }

    TXMUNIBBLE4 = bitpacked record
        constructor Create(a: uint16); overload;
        constructor Create(_x, _y, _z, _w: byte); overload;
        constructor Create(pArray: pbyte); overload;
        constructor Create(pArray: PSingle); overload;
        constructor Create(_x, _y, _z, _w: single); overload;
        class operator Explicit(c: TXMUNIBBLE4): uint16;
        class operator Explicit(c: uint16): TXMUNIBBLE4;
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

    { TXMU555 }

    TXMU555 = bitpacked record
        constructor Create(a: uint16); overload;
        constructor Create(_x, _y, _z: byte; _w: boolean); overload;
        constructor Create(pArray: pbyte; _w: boolean); overload;
        constructor Create(pArray: PSingle; _w: boolean); overload;
        constructor Create(_x, _y, _z: single; _w: boolean); overload;
        class operator Explicit(c: TXMU555): uint16;
        class operator Explicit(c: uint16): TXMU555;
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
procedure XMStoreByteN2(var pDestination: TXMBYTEN2; V: TFXMVECTOR);
procedure XMStoreByte2(var pDestination: TXMBYTE2; V: TFXMVECTOR);
procedure XMStoreUByteN2(var pDestination: TXMUBYTEN2; V: TFXMVECTOR);
procedure XMStoreUByte2(var pDestination: TXMUBYTE2; V: TFXMVECTOR);
procedure XMStoreU565(var pDestination: TXMU565; V: TFXMVECTOR);
procedure XMStoreFloat3PK(var pDestination: TXMFLOAT3PK; V: TFXMVECTOR);
procedure XMStoreFloat3SE(var pDestination: TXMFLOAT3SE; V: TFXMVECTOR);
procedure XMStoreHalf4(var pDestination: TXMHALF4; V: TFXMVECTOR);
procedure XMStoreShortN4(var pDestination: TXMSHORTN4; V: TFXMVECTOR);
procedure XMStoreShort4(var pDestination: TXMSHORT4; V: TFXMVECTOR);
procedure XMStoreUShortN4(var pDestination: TXMUSHORTN4; V: TFXMVECTOR);
procedure XMStoreUShort4(var pDestination: TXMUSHORT4; V: TFXMVECTOR);
procedure XMStoreXDecN4(var pDestination: TXMXDECN4; V: TFXMVECTOR);
procedure XMStoreXDec4(var pDestination: TXMXDEC4; V: TFXMVECTOR);
procedure XMStoreUDecN4(var pDestination: TXMUDECN4; V: TFXMVECTOR);
procedure XMStoreUDecN4_XR(var pDestination: TXMUDECN4; V: TFXMVECTOR);
procedure XMStoreUDec4(var pDestination: TXMUDEC4; V: TFXMVECTOR);
procedure XMStoreDecN4(var pDestination: TXMDECN4; V: TFXMVECTOR);
procedure XMStoreDec4(var pDestination: TXMDEC4; V: TFXMVECTOR);
procedure XMStoreUByteN4(var pDestination: TXMUBYTEN4; V: TFXMVECTOR);
procedure XMStoreUByte4(var pDestination: TXMUBYTE4; V: TFXMVECTOR);
procedure XMStoreByteN4(var pDestination: TXMBYTEN4; V: TFXMVECTOR);
procedure XMStoreByte4(var pDestination: TXMBYTE4; V: TFXMVECTOR);
procedure XMStoreUNibble4(var pDestination: TXMUNIBBLE4; V: TFXMVECTOR);
procedure XMStoreU555(var pDestination: TXMU555; V: TFXMVECTOR);


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

    pDestination.x := trunc(tmp.x); // temporär typecast
    pDestination.y := trunc(tmp.y);
end;



procedure XMStoreShort2(var pDestination: TXMSHORT2; V: TFXMVECTOR);
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorClamp(V, g_ShortMin, g_ShortMax);
    N := XMVectorRound(N);

    XMStoreFloat4A(tmp, N);

    pDestination.x := trunc(tmp.x);
    pDestination.y := trunc(tmp.y);
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

    pDestination.x := trunc(tmp.x);
    pDestination.y := trunc(tmp.y);
end;



procedure XMStoreUShort2(var pDestination: TXMUSHORT2; V: TFXMVECTOR);
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorClamp(V, XMVectorZero(), g_UShortMax);
    N := XMVectorRound(N);

    XMStoreFloat4A(tmp, N);

    pDestination.x := trunc(tmp.ux);
    pDestination.y := trunc(tmp.uy);
end;



procedure XMStoreByteN2(var pDestination: TXMBYTEN2; V: TFXMVECTOR);
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorClamp(V, g_XMNegativeOne, g_XMOne);
    N := XMVectorMultiply(N, g_ByteMax);
    N := XMVectorRound(N);

    XMStoreFloat4A(tmp, N);

    pDestination.x := trunc(tmp.x);
    pDestination.y := trunc(tmp.y);
end;



procedure XMStoreByte2(var pDestination: TXMBYTE2; V: TFXMVECTOR);
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorClamp(V, g_ByteMin, g_ByteMax);
    N := XMVectorRound(N);

    XMStoreFloat4A(tmp, N);

    pDestination.x := trunc(tmp.x);
    pDestination.y := trunc(tmp.y);
end;



procedure XMStoreUByteN2(var pDestination: TXMUBYTEN2; V: TFXMVECTOR);
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorSaturate(V);
    N := XMVectorMultiplyAdd(N, g_UByteMax, g_XMOneHalf);
    N := XMVectorTruncate(N);

    XMStoreFloat4A(tmp, N);

    pDestination.x := trunc(tmp.x);
    pDestination.y := trunc(tmp.y);
end;



procedure XMStoreUByte2(var pDestination: TXMUBYTE2; V: TFXMVECTOR);
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorClamp(V, XMVectorZero(), g_UByteMax);
    N := XMVectorRound(N);

    XMStoreFloat4A(tmp, N);

    pDestination.x := uint8(uint32(tmp.x));
    pDestination.y := uint8(uint32(tmp.y));
end;



procedure XMStoreU565(var pDestination: TXMU565; V: TFXMVECTOR);
const
    Max: TXMVECTOR = (f: (31.0, 63.0, 31.0, 0.0));
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorClamp(V, XMVectorZero(), Max);
    N := XMVectorRound(N);

    XMStoreFloat4A(tmp, N);

    pDestination.v := uint16(((int32(tmp.z) and $1F) shl 11) or ((int32(tmp.y) and $3F) shl 5) or ((int32(tmp.x) and $1F)));
end;



procedure XMStoreFloat3PK(var pDestination: TXMFLOAT3PK; V: TFXMVECTOR);
var
    j, Sign, I, Shift: uint32;
    lResult: array [0..2] of uint32;
    IValue: array[0..3] of uint32;
begin
    // X AND Y Channels (5-bit exponent, 6-bit mantissa)
    for j := 0 to 1 do
    begin
        Sign := IValue[j] and $80000000;
        I := IValue[j] and $7FFFFFFF;

        if ((I and $7F800000) = $7F800000) then
        begin
            // INF or NAN
            lResult[j] := $7C0;
            if ((I and $7FFFFF) <> 0) then
            begin
                lResult[j] := $7FF;
            end
            else if (Sign <> 0) then
            begin
                // -INF is clamped to 0 since 3PK is positive only
                lResult[j] := 0;
            end;
        end
        else if ((Sign <> 0) or (I < $35800000)) then
        begin
            // 3PK is positive only, so clamp to zero
            lResult[j] := 0;
        end
        else if (I > $477E0000) then
        begin
            // The number is too large to be represented as a float11, set to max
            lResult[j] := $7BF;
        end
        else
        begin
            if (I < $38800000) then
            begin
                // The number is too small to be represented as a normalized float11
                // Convert it to a denormalized value.
                Shift := 113 - (I shr 23);
                I := ($800000 or (I and $7FFFFF)) shr Shift;
            end
            else
            begin
                // Rebias the exponent to represent the value as a normalized float11
                I := I + $C8000000;
            end;

            lResult[j] := ((I + $FFFF + ((I shr 17) and 1)) shr 17) and $7ff;
        end;
    end;

    // Z Channel (5-bit exponent, 5-bit mantissa)
    Sign := IValue[2] and $80000000;
    I := IValue[2] and $7FFFFFFF;

    if ((I and $7F800000) = $7F800000) then
    begin
        // INF or NAN
        lResult[2] := $3E0;
        if ((I and $7FFFFF) <> 0) then
        begin
            lResult[2] := $3FF;
        end
        else if ((Sign <> 0) or (I < $36000000)) then
        begin
            // -INF is clamped to 0 since 3PK is positive only
            lResult[2] := 0;
        end;
    end
    else if (Sign <> 0) then
    begin
        // 3PK is positive only, so clamp to zero
        lResult[2] := 0;
    end
    else if (I > $477C0000) then
    begin
        // The number is too large to be represented as a float10, set to max
        lResult[2] := $3DF;
    end
    else
    begin
        if (I < $38800000) then
        begin
            // The number is too small to be represented as a normalized float10
            // Convert it to a denormalized value.
            Shift := 113 - (I shr 23);
            I := ($800000 or (I and $7FFFFF)) shr Shift;
        end
        else
        begin
            // Rebias the exponent to represent the value as a normalized float10
            I := I + $C8000000;
        end;

        lResult[2] := ((I + $1FFFF + ((I shr 18) and 1)) shr 18) and $3ff;
    end;

    // Pack Result into memory
    pDestination.v := (lResult[0] and $7ff) or ((lResult[1] and $7ff) shl 11) or ((lResult[2] and $3ff) shl 22);
end;



procedure XMStoreFloat3SE(var pDestination: TXMFLOAT3SE; V: TFXMVECTOR);
type
    TFI = record
        case byte of
            0: (f: single);
            1: (i: int32);
    end;
var
    tmp: TXMFLOAT3A;
    maxf9, minf9: single;
    max_xy, max_xyz, maxColor, ScaleR: single;
    x, y, z: single;
    fi: TFI;
    exp: uint32;
begin
    XMStoreFloat3A(tmp, V);

    maxf9 := ($1FF shl 7);
    minf9 := (1.0 / (1 shl 16));

    if (tmp.x >= 0.0) then
        if (tmp.x > maxf9) then x := maxf9
        else
            x := tmp.x
    else
        x := 0.0;
    if (tmp.y >= 0.0) then
        if (tmp.y > maxf9) then
            y := maxf9
        else
            y := tmp.y
    else
        y := 0.0;
    if (tmp.z >= 0.0) then
        if (tmp.z > maxf9) then z := maxf9
        else
            z := tmp.z
    else
        z := 0.0;


    if (x > y) then max_xy := x
    else
        max_xy := y;
    if (max_xy > z) then max_xyz := max_xy
    else
        max_xyz := z;

    if (max_xyz > minf9) then maxColor := max_xyz
    else
        maxColor := minf9;

    fi.f := maxColor;
    fi.i := fi.i + $00004000; // round up leaving 9 bits in fraction (including assumed 1)


    exp := uint32(fi.i) shr 23;
    pDestination.e := exp - $6f;

    fi.i := int32($83000000 - (exp shl 23));
    ScaleR := fi.f;

    pDestination.xm := uint32(round(x * ScaleR));
    pDestination.ym := uint32(round(y * ScaleR));
    pDestination.zm := uint32(round(z * ScaleR));
end;



procedure XMStoreHalf4(var pDestination: TXMHALF4; V: TFXMVECTOR);
var
    t: TXMFLOAT4A;
begin
    XMStoreFloat4A(t, V);

    pDestination.x := XMConvertFloatToHalf(t.x);
    pDestination.y := XMConvertFloatToHalf(t.y);
    pDestination.z := XMConvertFloatToHalf(t.z);
    pDestination.w := XMConvertFloatToHalf(t.w);
end;



procedure XMStoreShortN4(var pDestination: TXMSHORTN4; V: TFXMVECTOR);
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
    i: int32;
begin
    N := XMVectorClamp(V, g_XMNegativeOne, g_XMOne);
    N := XMVectorMultiply(N, g_ShortMax);
    N := XMVectorRound(N);

    XMStoreFloat4A(tmp, N);

    pDestination.x := trunc(tmp.x);
    pDestination.y := trunc(tmp.y);
    pDestination.z := trunc(tmp.z);
    pDestination.w := trunc(tmp.w);
end;



procedure XMStoreShort4(var pDestination: TXMSHORT4; V: TFXMVECTOR);
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorClamp(V, g_ShortMin, g_ShortMax);
    N := XMVectorRound(N);


    XMStoreFloat4A(tmp, N);

    pDestination.x := trunc(tmp.x);
    pDestination.y := trunc(tmp.y);
    pDestination.z := trunc(tmp.z);
    pDestination.w := trunc(tmp.w);
end;



procedure XMStoreUShortN4(var pDestination: TXMUSHORTN4; V: TFXMVECTOR);
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorSaturate(V);
    N := XMVectorMultiplyAdd(N, g_UShortMax, g_XMOneHalf);
    N := XMVectorTruncate(N);


    XMStoreFloat4A(tmp, N);

    pDestination.x := trunc(tmp.x);
    pDestination.y := trunc(tmp.y);
    pDestination.z := trunc(tmp.z);
    pDestination.w := trunc(tmp.w);
end;



procedure XMStoreUShort4(var pDestination: TXMUSHORT4; V: TFXMVECTOR);
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorClamp(V, XMVectorZero(), g_UShortMax);
    N := XMVectorRound(N);

    XMStoreFloat4A(tmp, N);

    pDestination.x := trunc(tmp.x);
    pDestination.y := trunc(tmp.y);
    pDestination.z := trunc(tmp.z);
    pDestination.w := trunc(tmp.w);
end;



procedure XMStoreXDecN4(var pDestination: TXMXDECN4; V: TFXMVECTOR);

const
    Min: TXMVECTOR = (f: (-1.0, -1.0, -1.0, 0.0));
    Scale: TXMVECTOR = (f: (511.0, 511.0, 511.0, 3.0));
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin

    N := XMVectorClamp(V, Min, g_XMOne);
    N := XMVectorMultiply(N, Scale);
    N := XMVectorRound(N);

    XMStoreFloat4A(tmp, N);

    pDestination.v := ((trunc(tmp.w) shl 30) or ((trunc(tmp.z) and $3FF) shl 20) or ((trunc(tmp.y) and $3FF) shl 10) or
        (trunc(tmp.x) and $3FF));
end;



procedure XMStoreXDec4(var pDestination: TXMXDEC4; V: TFXMVECTOR);
const
    MinXDec4: TXMVECTOR = (f: (-511.0, -511.0, -511.0, 0.0));
    MaxXDec4: TXMVECTOR = (f: (511.0, 511.0, 511.0, 3.0));
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorClamp(V, MinXDec4, MaxXDec4);

    XMStoreFloat4A(tmp, N);

    pDestination.v := ((trunc(tmp.w) shl 30) or ((trunc(tmp.z) and $3FF) shl 20) or ((trunc(tmp.y) and $3FF) shl 10) or
        ((trunc(tmp.x) and $3FF)));
end;



procedure XMStoreUDecN4(var pDestination: TXMUDECN4; V: TFXMVECTOR);
const
    Scale: TXMVECTOR = (f: (1023.0, 1023.0, 1023.0, 3.0));
var
    tmp: TXMFLOAT4A;
    N: TXMVECTOR;
begin
    N := XMVectorSaturate(V);
    N := XMVectorMultiply(N, Scale);

    XMStoreFloat4A(tmp, N);

    pDestination.v := ((trunc(tmp.w) shl 30) or ((trunc(tmp.z) and $3FF) shl 20) or ((trunc(tmp.y) and $3FF) shl 10) or
        ((trunc(tmp.x) and $3FF)));
end;



procedure XMStoreUDecN4_XR(var pDestination: TXMUDECN4; V: TFXMVECTOR);
const
    Scale: TXMVECTOR = (f: (510.0, 510.0, 510.0, 3.0));
    Bias: TXMVECTOR = (f: (384.0, 384.0, 384.0, 0.0));
    C: TXMVECTOR = (f: (1023.0, 1023.0, 1023.0, 3.0));
var
    tmp: TXMFLOAT4A;
    N: TXMVECTOR;
begin
    N := XMVectorMultiplyAdd(V, Scale, Bias);
    N := XMVectorClamp(N, g_XMZero, C);

    XMStoreFloat4A(tmp, N);

    pDestination.v := ((trunc(tmp.w) shl 30) or ((trunc(tmp.z) and $3FF) shl 20) or ((trunc(tmp.y) and $3FF) shl 10) or
        ((trunc(tmp.x) and $3FF)));
end;



procedure XMStoreUDec4(var pDestination: TXMUDEC4; V: TFXMVECTOR);
const
    MaxUDec4: TXMVECTOR = (f: (1023.0, 1023.0, 1023.0, 3.0));
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorClamp(V, XMVectorZero(), MaxUDec4);
    XMStoreFloat4A(tmp, N);
    pDestination.v := ((trunc(tmp.w) shl 30) or ((trunc(tmp.z) and $3FF) shl 20) or ((trunc(tmp.y) and $3FF) shl 10) or
        ((trunc(tmp.x) and $3FF)));
end;



procedure XMStoreDecN4(var pDestination: TXMDECN4; V: TFXMVECTOR);
const
    Scale: TXMVECTOR = (f: (511.0, 511.0, 511.0, 1.0));
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorClamp(V, g_XMNegativeOne, g_XMOne);
    N := XMVectorMultiply(N, Scale);
    XMStoreFloat4A(tmp, N);
    pDestination.v := ((trunc(tmp.w) shl 30) or ((trunc(tmp.z) and $3FF) shl 20) or ((trunc(tmp.y) and $3FF) shl 10) or
        ((trunc(tmp.x) and $3FF)));
end;



procedure XMStoreDec4(var pDestination: TXMDEC4; V: TFXMVECTOR);
const
    MinDec4: TXMVECTOR = (f: (-511.0, -511.0, -511.0, -1.0));
    MaxDec4: TXMVECTOR = (f: (511.0, 511.0, 511.0, 1.0));
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorClamp(V, MinDec4, MaxDec4);
    XMStoreFloat4A(tmp, N);
    pDestination.v := ((trunc(tmp.w) shl 30) or ((trunc(tmp.z) and $3FF) shl 20) or ((trunc(tmp.y) and $3FF) shl 10) or
        ((trunc(tmp.x) and $3FF)));
end;



procedure XMStoreUByteN4(var pDestination: TXMUBYTEN4; V: TFXMVECTOR);
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorSaturate(V);
    N := XMVectorMultiply(N, g_UByteMax);
    N := XMVectorTruncate(N);

    XMStoreFloat4A(tmp, N);
    pDestination.x := trunc(tmp.x);
    pDestination.y := trunc(tmp.y);
    pDestination.z := trunc(tmp.z);
    pDestination.w := trunc(tmp.w);
end;



procedure XMStoreUByte4(var pDestination: TXMUBYTE4; V: TFXMVECTOR);
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorClamp(V, XMVectorZero(), g_UByteMax);
    N := XMVectorRound(N);

    XMStoreFloat4A(tmp, N);

    pDestination.x := trunc(tmp.x);
    pDestination.y := trunc(tmp.y);
    pDestination.z := trunc(tmp.z);
    pDestination.w := trunc(tmp.w);
end;



procedure XMStoreByteN4(var pDestination: TXMBYTEN4; V: TFXMVECTOR);
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorClamp(V, g_XMNegativeOne, g_XMOne);
    N := XMVectorMultiply(N, g_ByteMax);
    N := XMVectorTruncate(N);

    XMStoreFloat4A(tmp, N);

    pDestination.x := trunc(tmp.x);
    pDestination.y := trunc(tmp.y);
    pDestination.z := trunc(tmp.z);
    pDestination.w := trunc(tmp.w);
end;



procedure XMStoreByte4(var pDestination: TXMBYTE4; V: TFXMVECTOR);
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorClamp(V, g_ByteMin, g_ByteMax);
    N := XMVectorRound(N);
    XMStoreFloat4A(tmp, N);

    pDestination.x := trunc(tmp.x);
    pDestination.y := trunc(tmp.y);
    pDestination.z := trunc(tmp.z);
    pDestination.w := trunc(tmp.w);
end;



procedure XMStoreUNibble4(var pDestination: TXMUNIBBLE4; V: TFXMVECTOR);
const
    Max: TXMVECTOR = (f: (15.0, 15.0, 15.0, 15.0));
var
    N: TXMVECTOR;
    tmp: TXMFLOAT4A;
begin
    N := XMVectorClamp(V, XMVectorZero(), Max);
    N := XMVectorRound(N);
    XMStoreFloat4A(tmp, N);
    pDestination.v := (((trunc(tmp.w) and $F) shl 12) or ((trunc(tmp.z) and $F) shl 8) or ((trunc(tmp.y) and $F) shl 4) or
        (trunc(tmp.x) and $F));
end;



procedure XMStoreU555(var pDestination: TXMU555; V: TFXMVECTOR);
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
 * XMU555 operators
 *
 ****************************************************************************)

{ TXMU555 }

constructor TXMU555.Create(a: uint16);
begin
    self.v := a;
end;



constructor TXMU555.Create(_x, _y, _z: byte; _w: boolean);
begin
    self.x := _x;
    self.y := _y;
    self.z := _z;
    self.w := shortint(_w);

end;



constructor TXMU555.Create(pArray: pbyte; _w: boolean);
var
    lArray: array of byte absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
    self.z := lArray[2];
    self.w := shortint(_w);
end;



constructor TXMU555.Create(pArray: PSingle; _w: boolean);
var
    V: TXMVECTOR;
begin
    V := XMLoadFloat3(PXMFLOAT3(pArray)^);
    if _w then
        XMStoreU555(self, XMVectorSetW(V, 1.0))
    else
        XMStoreU555(self, XMVectorSetW(V, 0.0));
end;



constructor TXMU555.Create(_x, _y, _z: single; _w: boolean);
begin
    if _w then
        XMStoreU555(self, XMVectorSet(_x, _y, _z, 1.0))
    else
        XMStoreU555(self, XMVectorSet(_x, _y, _z, 0.0));
end;



class operator TXMU555.Explicit(c: TXMU555): uint16;
begin
    Result := c.v;
end;



class operator TXMU555.Explicit(c: uint16): TXMU555;
begin
    Result.v := c;
end;

(****************************************************************************
 *
 * XMUNIBBLE4 operators
 *
 ****************************************************************************)

{ TXMUNIBBLE4 }

constructor TXMUNIBBLE4.Create(a: uint16);
begin
    self.v := a;
end;



constructor TXMUNIBBLE4.Create(_x, _y, _z, _w: byte);
begin
    self.x := _x;
    self.y := _y;
    self.z := _z;
    self.w := _w;
end;



constructor TXMUNIBBLE4.Create(pArray: pbyte);
var
    lArray: array of byte absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
    self.z := lArray[2];
    self.w := lArray[3];
end;



constructor TXMUNIBBLE4.Create(pArray: PSingle);
begin
    XMStoreUNibble4(self, XMLoadFloat4(PXMFLOAT4(pArray)^));
end;



constructor TXMUNIBBLE4.Create(_x, _y, _z, _w: single);
begin
    XMStoreUNibble4(self, XMVectorSet(_x, _y, _z, _w));
end;



class operator TXMUNIBBLE4.Explicit(c: TXMUNIBBLE4): uint16;
begin
    Result := c.v;
end;



class operator TXMUNIBBLE4.Explicit(c: uint16): TXMUNIBBLE4;
begin
    Result.v := c;
end;


(****************************************************************************
 *
 * XMUBYTE4 operators
 *
 ****************************************************************************)

{ TXMUBYTE4 }

class operator TXMUBYTE4.Initialize(var a: TXMUBYTE4);
begin
    a.v := 0;
end;



constructor TXMUBYTE4.Create(a: uint32);
begin
    self.v := a;
end;



constructor TXMUBYTE4.Create(_x, _y, _z, _w: byte);
begin
    self.x := _x;
    self.y := _y;
    self.z := _z;
    self.w := _w;
end;



constructor TXMUBYTE4.Create(pArray: pbyte);
var
    lArray: array of byte absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
    self.z := lArray[2];
    self.w := lArray[3];
end;



constructor TXMUBYTE4.Create(pArray: PSingle);
begin
    XMStoreUByte4(self, XMLoadFloat4(PXMFLOAT4(pArray)^));
end;



constructor TXMUBYTE4.Create(_x, _y, _z, _w: single);
begin
    XMStoreUByte4(self, XMVectorSet(_x, _y, _z, _w));
end;



class operator TXMUBYTE4.Explicit(c: TXMUBYTE4): uint32;
begin
    Result := c.v;
end;



class operator TXMUBYTE4.Explicit(c: uint32): TXMUBYTE4;
begin
    Result.v := c;
end;


(****************************************************************************
 *
 * XMUBYTEN4 operators
 *
 ****************************************************************************)

{ TXMUBYTEN4 }

class operator TXMUBYTEN4.Initialize(var a: TXMUBYTEN4);
begin
    a.v := 0;
end;



constructor TXMUBYTEN4.Create(a: uint32);
begin
    self.v := a;
end;



constructor TXMUBYTEN4.Create(_x, _y, _z, _w: byte);
begin
    self.x := _x;
    self.y := _y;
    self.z := _z;
    self.w := _w;
end;



constructor TXMUBYTEN4.Create(pArray: pbyte);
var
    lArray: array of byte absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
    self.z := lArray[2];
    self.w := lArray[3];

end;



constructor TXMUBYTEN4.Create(pArray: PSingle);
begin
    XMStoreUByteN4(self, XMLoadFloat4(PXMFLOAT4(pArray)^));
end;



constructor TXMUBYTEN4.Create(_x, _y, _z, _w: single);
begin
    XMStoreUByteN4(self, XMVectorSet(_x, _y, _z, _w));
end;



class operator TXMUBYTEN4.Explicit(c: TXMUBYTEN4): uint32;
begin
    Result := c.v;
end;



class operator TXMUBYTEN4.Explicit(c: uint32): TXMUBYTEN4;
begin
    Result.v := c;
end;

(****************************************************************************
 *
 * XMBYTE4 operators
 *
 ****************************************************************************)

{ TXMBYTE4 }

class operator TXMBYTE4.Initialize(var a: TXMBYTE4);
begin
    a.v := 0;
end;



constructor TXMBYTE4.Create(a: uint32);
begin
    self.v := a;
end;



constructor TXMBYTE4.Create(_x, _y, _z, _w: int8);
begin
    self.x := _x;
    self.y := _y;
    self.z := _z;
    self.w := _w;
end;



constructor TXMBYTE4.Create(pArray: Pint8);
var
    lArray: array of int8 absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
    self.z := lArray[2];
    self.w := lArray[3];
end;



constructor TXMBYTE4.Create(pArray: PSingle);
begin
    XMStoreByte4(self, XMLoadFloat4(PXMFLOAT4(pArray)^));
end;



constructor TXMBYTE4.Create(_x, _y, _z, _w: single);
begin
    XMStoreByte4(self, XMVectorSet(_x, _y, _z, _w));
end;



class operator TXMBYTE4.Explicit(c: TXMBYTE4): uint32;
begin
    Result := c.v;
end;



class operator TXMBYTE4.Explicit(c: uint32): TXMBYTE4;
begin
    Result.v := c;
end;

(****************************************************************************
 *
 * XMBYTEN4 operators
 *
 ****************************************************************************)

{ TXMBYTEN4 }

class operator TXMBYTEN4.Initialize(var a: TXMBYTEN4);
begin
    a.v := 0;
end;



constructor TXMBYTEN4.Create(a: uint32);
begin
    self.v := a;
end;



constructor TXMBYTEN4.Create(_x, _y, _z, _w: int8);
begin
    self.x := _x;
    self.y := _y;
    self.z := _z;
    self.w := _w;
end;



constructor TXMBYTEN4.Create(pArray: Pint8);
var
    lArray: array of int8 absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
    self.z := lArray[2];
    self.w := lArray[3];
end;



constructor TXMBYTEN4.Create(pArray: PSingle);
begin
    XMStoreByteN4(self, XMLoadFloat4(PXMFLOAT4(pArray)^));
end;



constructor TXMBYTEN4.Create(_x, _y, _z, _w: single);
begin
    XMStoreByteN4(self, XMVectorSet(_x, _y, _z, _w));
end;



class operator TXMBYTEN4.Explicit(c: TXMBYTEN4): uint32;
begin
    Result := c.v;
end;



class operator TXMBYTEN4.Explicit(c: uint32): TXMBYTEN4;
begin
    Result.v := c;
end;

(****************************************************************************
 *
 * XMUDEC4 operators
 *
 ****************************************************************************)

{ TXMUDEC4 }

constructor TXMUDEC4.Create(a: uint32);
begin
    self.v := a;
end;



constructor TXMUDEC4.Create(pArray: PSingle);
begin
    XMStoreUDec4(self, XMLoadFloat4(PXMFLOAT4(pArray)^));
end;



constructor TXMUDEC4.Create(_x, _y, _z, _w: single);
begin
    XMStoreUDec4(self, XMVectorSet(_x, _y, _z, _w));
end;



class operator TXMUDEC4.Explicit(c: TXMUDEC4): uint32;
begin
    Result := c.v;
end;



class operator TXMUDEC4.Explicit(c: uint32): TXMUDEC4;
begin
    Result.v := c;
end;

(****************************************************************************
 *
 * XMUDECN4 operators
 *
 ****************************************************************************)

{ TXMUDECN4 }

constructor TXMUDECN4.Create(a: uint32);
begin
    self.v := a;
end;



constructor TXMUDECN4.Create(pArray: PSingle);
begin
    XMStoreUDecN4(self, XMLoadFloat4(PXMFLOAT4(pArray)^));
end;



constructor TXMUDECN4.Create(_x, _y, _z, _w: single);
begin
    XMStoreUDecN4(self, XMVectorSet(_x, _y, _z, _w));
end;



class operator TXMUDECN4.Explicit(c: TXMUDECN4): uint32;
begin
    Result := c.v;
end;



class operator TXMUDECN4.Explicit(c: uint32): TXMUDECN4;
begin
    Result.v := c;
end;

(****************************************************************************
 *
 * XMDEC4 operators
 *
 ****************************************************************************)

{ TXMDEC4 }

constructor TXMDEC4.Create(a: uint32);
begin
    self.v := a;
end;



constructor TXMDEC4.Create(pArray: PSingle);
begin
    XMStoreDec4(self, XMLoadFloat4(PXMFLOAT4(pArray)^));
end;



constructor TXMDEC4.Create(_x, _y, _z, _w: single);
begin
    XMStoreDec4(self, XMVectorSet(_x, _y, _z, _w));
end;



class operator TXMDEC4.Explicit(c: TXMDEC4): uint32;
begin
    Result := c.v;
end;



class operator TXMDEC4.Explicit(c: uint32): TXMDEC4;
begin
    Result.v := c;
end;


(****************************************************************************
 *
 * XMDECN4 operators
 *
 ****************************************************************************)

{ TXMDECN4 }

constructor TXMDECN4.Create(a: uint32);
begin
    self.v := a;
end;



constructor TXMDECN4.Create(pArray: PSingle);
begin
    XMStoreDecN4(self, XMLoadFloat4(PXMFLOAT4(pArray)^));
end;



constructor TXMDECN4.Create(_x, _y, _z, _w: single);
begin
    XMStoreDecN4(self, XMVectorSet(_x, _y, _z, _w));
end;



class operator TXMDECN4.Explicit(c: TXMDECN4): uint32;
begin
    Result := c.v;
end;



class operator TXMDECN4.Explicit(c: uint32): TXMDECN4;
begin
    Result.v := c;
end;


(****************************************************************************
 *
 * XMXDEC4 operators
 *
 ****************************************************************************)

{ TXMXDEC4 }

constructor TXMXDEC4.Create(a: uint32);
begin
    self.v := a;
end;



constructor TXMXDEC4.Create(pArray: PSingle);
begin
    XMStoreXDec4(self, XMLoadFloat4(PXMFLOAT4(pArray)^));
end;



constructor TXMXDEC4.Create(_x, _y, _z, _w: single);
begin
    XMStoreXDec4(self, XMVectorSet(_x, _y, _z, _w));
end;



class operator TXMXDEC4.Explicit(c: TXMXDEC4): uint32;
begin
    Result := c.v;
end;



class operator TXMXDEC4.Explicit(c: uint32): TXMXDEC4;
begin
    Result.v := c;
end;

(****************************************************************************
 *
 * XMXDECN4 operators
 *
 ****************************************************************************)

{ TXMXDECN4 }

constructor TXMXDECN4.Create(a: uint32);
begin
    self.v := a;
end;



constructor TXMXDECN4.Create(pArray: PSingle);
begin
    XMStoreXDecN4(self, XMLoadFloat4(PXMFLOAT4(pArray)^));
end;



constructor TXMXDECN4.Create(_x, _y, _z, _w: single);
begin
    XMStoreXDecN4(self, XMVectorSet(_x, _y, _z, _w));
end;



class operator TXMXDECN4.Explicit(c: TXMXDECN4): uint32;
begin
    Result := c.v;
end;



class operator TXMXDECN4.Explicit(c: uint32): TXMXDECN4;
begin
    Result.v := c;
end;

(****************************************************************************
 *
 * XMUSHORT4 operators
 *
 ****************************************************************************)

{ TXMUSHORT4 }

class operator TXMUSHORT4.Initialize(var a: TXMUSHORT4);
begin
    a.v := 0;
end;



constructor TXMUSHORT4.Create(a: uint64);
begin
    self.v := a;
end;



constructor TXMUSHORT4.Create(_x, _y, _z, _w: uint16);
begin
    self.x := _x;
    self.y := _y;
    self.z := _z;
    self.w := _w;
end;



constructor TXMUSHORT4.Create(pArray: Puint16);
var
    lArray: array of uint16 absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
    self.z := lArray[2];
    self.w := lArray[3];
end;



constructor TXMUSHORT4.Create(pArray: PSingle);
begin
    XMStoreUShort4(self, XMLoadFloat4(PXMFLOAT4(pArray)^));
end;



constructor TXMUSHORT4.Create(_x, _y, _z, _w: single);
begin
    XMStoreUShort4(self, XMVectorSet(_x, _y, _z, _w));
end;



class operator TXMUSHORT4.Explicit(c: TXMUSHORT4): uint64;
begin
    Result := c.v;
end;



class operator TXMUSHORT4.Explicit(c: uint64): TXMUSHORT4;
begin
    Result.v := c;
end;

(****************************************************************************
 *
 * XMUSHORTN4 operators
 *
 ****************************************************************************)

{ TXMUSHORTN4 }

class operator TXMUSHORTN4.Initialize(var a: TXMUSHORTN4);
begin
    a.v := 0;
end;



constructor TXMUSHORTN4.Create(a: uint64);
begin
    self.v := a;
end;



constructor TXMUSHORTN4.Create(_x, _y, _z, _w: int16);
begin
    self.x := _x;
    self.y := _y;
    self.z := _z;
    self.w := _w;
end;



constructor TXMUSHORTN4.Create(pArray: Pint16);
var
    lArray: array of int16 absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
    self.z := lArray[2];
    self.w := lArray[3];
end;



constructor TXMUSHORTN4.Create(pArray: PSingle);
begin
    XMStoreUShortN4(self, XMLoadFloat4(PXMFLOAT4(pArray)^));
end;



constructor TXMUSHORTN4.Create(_x, _y, _z, _w: single);
begin
    XMStoreUShortN4(self, XMVectorSet(_x, _y, _z, _w));
end;



class operator TXMUSHORTN4.Explicit(c: TXMUSHORTN4): uint64;
begin
    Result := c.v;
end;



class operator TXMUSHORTN4.Explicit(c: uint64): TXMUSHORTN4;
begin
    Result.v := c;
end;


(****************************************************************************
 *
 * XMSHORT4 operators
 *
 ****************************************************************************)

{ TXMSHORT4 }

class operator TXMSHORT4.Initialize(var a: TXMSHORT4);
begin
    a.v := 0;
end;



constructor TXMSHORT4.Create(a: uint64);
begin
    self.v := a;
end;



constructor TXMSHORT4.Create(_x, _y, _z, _w: int16);
begin
    self.x := _x;
    self.y := _y;
    self.z := _z;
    self.w := _w;
end;



constructor TXMSHORT4.Create(pArray: Pint16);
var
    lArray: array of int16 absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
    self.z := lArray[2];
    self.w := lArray[3];
end;



constructor TXMSHORT4.Create(pArray: PSingle);
begin
    XMStoreShort4(self, XMLoadFloat4(PXMFLOAT4(pArray)^));
end;



constructor TXMSHORT4.Create(_x, _y, _z, _w: single);
begin
    XMStoreShort4(self, XMVectorSet(_x, _y, _z, _w));
end;



class operator TXMSHORT4.Explicit(c: TXMSHORT4): uint64;
begin
    Result := c.v;
end;



class operator TXMSHORT4.Explicit(c: uint64): TXMSHORT4;
begin
    Result.v := c;
end;


(****************************************************************************
 *
 * XMSHORTN4 operators
 *
 ****************************************************************************)

{ TXMSHORTN4 }

class operator TXMSHORTN4.Initialize(var a: TXMSHORTN4);
begin
    a.v := 0;
end;



constructor TXMSHORTN4.Create(a: uint64);
begin
    self.v := a;
end;



constructor TXMSHORTN4.Create(_x, _y, _z, _w: int16);
begin
    self.x := _x;
    self.y := _y;
    self.z := _z;
    self.w := _w;
end;



constructor TXMSHORTN4.Create(pArray: Pint16);
var
    lArray: array of int16 absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
    self.z := lArray[2];
    self.w := lArray[3];
end;



constructor TXMSHORTN4.Create(pArray: PSingle);
begin
    XMStoreShortN4(self, XMLoadFloat4(PXMFLOAT4(pArray)^));
end;



constructor TXMSHORTN4.Create(_x, _y, _z, _w: single);
begin
    XMStoreShortN4(self, XMVectorSet(_x, _y, _z, _w));
end;



class operator TXMSHORTN4.Explicit(c: TXMSHORTN4): uint64;
begin
    Result := c.v;
end;



class operator TXMSHORTN4.Explicit(c: uint64): TXMSHORTN4;
begin
    Result.v := c;
end;

(****************************************************************************
 *
 * XMHALF4 operators
 *
 ****************************************************************************)

{ TXMHALF4 }

class operator TXMHALF4.Initialize(var a: TXMHALF4);
begin
    a.v := 0;
end;



constructor TXMHALF4.Create(a: uint64);
begin
    self.v := a;
end;



constructor TXMHALF4.Create(_x, _y, _z, _w: THALF);
begin
    self.x := _x;
    self.y := _y;
    self.z := _z;
    self.w := _w;
end;



constructor TXMHALF4.Create(pArray: PHALF);
var
    lArray: array of THALF absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
    self.z := lArray[2];
    self.w := lArray[3];
end;



constructor TXMHALF4.Create(pArray: PSingle);
begin
    XMConvertFloatToHalfStream(@x, sizeof(THALF), pArray, sizeof(single), 4);
end;



constructor TXMHALF4.Create(_x, _y, _z, _w: single);
begin
    x := XMConvertFloatToHalf(_x);
    y := XMConvertFloatToHalf(_y);
    z := XMConvertFloatToHalf(_z);
    w := XMConvertFloatToHalf(_w);
end;



class operator TXMHALF4.Explicit(c: TXMHALF4): uint64;
begin
    Result := c.v;
end;



class operator TXMHALF4.Explicit(c: uint64): TXMHALF4;
begin
    Result.v := c;
end;


(****************************************************************************
 *
 * XMFLOAT3SE operators
 *
 ****************************************************************************)

{ TXMFLOAT3SE }

constructor TXMFLOAT3SE.Create(a: uint32);
begin
    self.v := a;
end;



constructor TXMFLOAT3SE.Create(pArray: PSingle);
begin
    XMStoreFloat3SE(self, XMLoadFloat3(PXMFLOAT3(pArray)^));
end;



constructor TXMFLOAT3SE.Create(_x, _y, _z: single);
begin
    XMStoreFloat3SE(self, XMVectorSet(_x, _y, _z, 0.0));
end;



class operator TXMFLOAT3SE.Explicit(c: TXMFLOAT3SE): uint32;
begin
    Result := c.v;
end;



class operator TXMFLOAT3SE.Explicit(c: uint32): TXMFLOAT3SE;
begin
    Result.v := c;
end;


(****************************************************************************
 *
 * XMFLOAT3PK operators
 *
 ****************************************************************************)

{ TXMFLOAT3PK }

constructor TXMFLOAT3PK.Create(a: uint32);
begin
    self.v := a;
end;



constructor TXMFLOAT3PK.Create(pArray: PSingle);
begin
    XMStoreFloat3PK(self, XMLoadFloat3(PXMFLOAT3(pArray)^));
end;



constructor TXMFLOAT3PK.Create(_x, _y, _z: single);
begin
    XMStoreFloat3PK(self, XMVectorSet(_x, _y, _z, 0.0));
end;



class operator TXMFLOAT3PK.Explicit(c: TXMFLOAT3PK): uint32;
begin
    Result := c.v;
end;



class operator TXMFLOAT3PK.Explicit(c: uint32): TXMFLOAT3PK;
begin
    Result.v := c;
end;


(****************************************************************************
 *
 * XMU565 operators
 *
 ****************************************************************************)

{ TXMU565 }


constructor TXMU565.Create(a: uint16);
begin
    self.v := a;
end;



constructor TXMU565.Create(_x, _y, _z: uint8);
begin
    self.x := _x;
    self.y := _y;
    self.z := _z;
end;



constructor TXMU565.Create(pArray: Puint8);
var
    lArray: array of uint8 absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
    self.z := lArray[2];
end;



constructor TXMU565.Create(pArray: PSingle);
begin
    XMStoreU565(self, XMLoadFloat3(PXMFLOAT3(pArray)^));
end;



constructor TXMU565.Create(_x, _y, _z: single);
begin
    XMStoreU565(self, XMVectorSet(_x, _y, _z, 0.0));
end;



class operator TXMU565.Explicit(c: TXMU565): uint16;
begin
    Result := c.v;
end;



class operator TXMU565.Explicit(c: uint16): TXMU565;
begin
    Result.v := c;
end;


(****************************************************************************
 *
 * XMUBYTE2 operators
 *
 ****************************************************************************)

{ TXMUBYTE2 }

class operator TXMUBYTE2.Initialize(var a: TXMUBYTE2);
begin
    a.v := 0;
end;



constructor TXMUBYTE2.Create(a: uint16);
begin
    self.v := a;
end;



constructor TXMUBYTE2.Create(_x, _y: uint8);
begin
    self.x := _x;
    self.y := _y;
end;



constructor TXMUBYTE2.Create(pArray: Puint8);
var
    lArray: array of uint8 absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
end;



constructor TXMUBYTE2.Create(pArray: PSingle);
begin
    XMStoreUByte2(self, XMLoadFloat2(PXMFLOAT2(pArray)));
end;



constructor TXMUBYTE2.Create(_x, _y: single);
begin
    XMStoreUByte2(self, XMVectorSet(_x, _y, 0.0, 0.0));
end;



class operator TXMUBYTE2.Explicit(c: TXMUBYTE2): uint16;
begin
    Result := c.v;
end;



class operator TXMUBYTE2.Explicit(c: uint16): TXMUBYTE2;
begin
    Result.v := c;
end;


(****************************************************************************
 *
 * XMUBYTEN2 operators
 *
 ****************************************************************************)

{ TXMUBYTEN2 }

class operator TXMUBYTEN2.Initialize(var a: TXMUBYTEN2);
begin
    a.v := 0;
end;



constructor TXMUBYTEN2.Create(a: uint16);
begin
    self.v := a;
end;



constructor TXMUBYTEN2.Create(_x, _y: uint8);
begin
    self.x := _x;
    self.y := _y;
end;



constructor TXMUBYTEN2.Create(pArray: Puint8);
var
    lArray: array of uint8 absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
end;



constructor TXMUBYTEN2.Create(pArray: PSingle);
begin
    XMStoreUByteN2(self, XMLoadFloat2(PXMFLOAT2(pArray)));
end;



constructor TXMUBYTEN2.Create(_x, _y: single);
begin
    XMStoreUByteN2(self, XMVectorSet(_x, _y, 0.0, 0.0));
end;



class operator TXMUBYTEN2.Explicit(c: TXMUBYTEN2): uint16;
begin
    Result := c.v;

end;



class operator TXMUBYTEN2.Explicit(c: uint16): TXMUBYTEN2;
begin
    Result.v := c;
end;


(****************************************************************************
 *
 * XMBYTE2 operators
 *
 ****************************************************************************)
{ TXMBYTE2 }

class operator TXMBYTE2.Initialize(var a: TXMBYTE2);
begin
    a.v := 0;
end;



constructor TXMBYTE2.Create(a: uint16);
begin
    self.v := a;
end;



constructor TXMBYTE2.Create(_x, _y: int8);
begin
    self.x := _x;
    self.y := _y;
end;



constructor TXMBYTE2.Create(pArray: Pint8);
var
    lArray: array of int8 absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
end;



constructor TXMBYTE2.Create(pArray: PSingle);
begin
    XMStoreByte2(self, XMLoadFloat2(PXMFLOAT2(pArray)));
end;



constructor TXMBYTE2.Create(_x, _y: single);
begin
    XMStoreByte2(self, XMVectorSet(_x, _y, 0.0, 0.0));
end;



class operator TXMBYTE2.Explicit(c: TXMBYTE2): uint16;
begin
    Result := c.v;
end;



class operator TXMBYTE2.Explicit(c: uint16): TXMBYTE2;
begin
    Result.v := c;
end;


(****************************************************************************
 *
 * XMBYTEN2 operators
 *
 ****************************************************************************)

{ TXMBYTEN2 }

class operator TXMBYTEN2.Initialize(var a: TXMBYTEN2);
begin
    a.v := 0;
end;



constructor TXMBYTEN2.Create(a: uint16);
begin
    self.v := a;
end;



constructor TXMBYTEN2.Create(_x, _y: int8);
begin
    self.x := _x;
    self.y := _y;
end;



constructor TXMBYTEN2.Create(pArray: Pint8);
var
    lArray: array of int8 absolute pArray;
begin
    self.x := lArray[0];
    self.y := lArray[1];
end;



constructor TXMBYTEN2.Create(pArray: PSingle);
begin
    XMStoreByteN2(self, XMLoadFloat2(PXMFLOAT2(pArray)));
end;



constructor TXMBYTEN2.Create(_x, _y: single);
begin
    XMStoreByteN2(self, XMVectorSet(_x, _y, 0.0, 0.0));
end;



class operator TXMBYTEN2.Explicit(c: TXMBYTEN2): uint16;
begin
    Result := c.v;
end;



class operator TXMBYTEN2.Explicit(c: uint16): TXMBYTEN2;
begin
    Result.v := c;
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
