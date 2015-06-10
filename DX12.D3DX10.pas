unit DX12.D3DX10;

{$IFDEF FPC}
{$MODE delphi}{$H+}
{$ENDIF}


interface

{$Z4}

uses
    Windows, Classes, SysUtils,
    DX12.D3D10, DX12.D3DCommon, DX12.D3D10_1,
    DX12.DXGI;

const
    IID_ID3DXMatrixStack: TGUID = '{C7885BA7-F990-4fe7-922D-8515E477DD85}';
    IID_ID3DX10BaseMesh: TGUID = '{7ED943DD-52E8-40b5-A8D8-76685C406330}';
    IID_ID3DX10PMesh: TGUID = '{8875769A-D579-4088-AAEB-534D1AD84E96}';
    IID_ID3DX10SPMesh: TGUID = '{667EA4C7-F1CD-4386-B523-7C0290B83CC5}';
    IID_ID3DX10PatchMesh: TGUID = '{3CE6CC22-DBF2-44f4-894D-F9C34A337139}';
    IID_ID3DX10MeshBuffer: TGUID = '{04B0D117-1041-46b1-AA8A-3952848BA22E}';
    IID_ID3DX10Mesh: TGUID = '{4020E5C2-1403-4929-883F-E2E849FAC195}';
    IID_ID3DX10SkinInfo: TGUID = '{420BD604-1C76-4a34-A466-E45D0658A32C}';

{$IFDEF DEBUG}
    DLL_D3DX10 = 'd3dx10d_43.dll';
{$ELSE}
    DLL_D3DX10 = 'd3dx10_43.dll';
{$ENDIF}
    DLL_D3DX10_DIAG = 'd3dx10d_43.dll';
    D3DX10_SDK_VERSION = 43;

    D3DX10_DEFAULT = UINT(-1);
    D3DX10_FROM_FILE = UINT(-3);
    DXGI_FORMAT_FROM_FILE = TDXGI_FORMAT(-3);

    _FACDD = $876;
    MAKE_DDHRESULT = longword(1 shl 31) or longword(_FACDD shl 16);

    D3DX10_ERR_CANNOT_MODIFY_INDEX_BUFFER = MAKE_DDHRESULT or 2900;
    D3DX10_ERR_INVALID_MESH = MAKE_DDHRESULT or 2901;
    D3DX10_ERR_CANNOT_ATTR_SORT = MAKE_DDHRESULT or 2902;
    D3DX10_ERR_SKINNING_NOT_SUPPORTED = MAKE_DDHRESULT or 2903;
    D3DX10_ERR_TOO_MANY_INFLUENCES = MAKE_DDHRESULT or 2904;
    D3DX10_ERR_INVALID_DATA = MAKE_DDHRESULT or 2905;
    D3DX10_ERR_LOADED_MESH_HAS_NO_DATA = MAKE_DDHRESULT or 2906;
    D3DX10_ERR_DUPLICATE_NAMED_FRAGMENT = MAKE_DDHRESULT or 2907;
    D3DX10_ERR_CANNOT_REMOVE_LAST_ITEM = MAKE_DDHRESULT or 2908;

    _FACD3D = $876;

    MAKE_D3DHRESULT = longword(1 shl 31) or longword(_FACD3D shl 16);
    MAKE_D3DSTATUS = longword(0 shl 31) or longword(_FACD3D shl 16);

    D3DERR_INVALIDCALL = MAKE_D3DHRESULT or 2156;
    D3DERR_WASSTILLDRAWING = MAKE_D3DHRESULT or 540;


// D3DX10 and D3DX9 math look the same. You can include either one into your project.
// We are intentionally using the header define from D3DX9 math to prevent double-inclusion.

// ===========================================================================

// Type definitions from D3D9

// ===========================================================================

const
    D3DX_PI = (3.14159265358979323846);
    D3DX_1BYPI = (1.0 / D3DX_PI);

    D3DX_16F_DIG = 3; // # of decimal digits of precision
    D3DX_16F_EPSILON = 4.8875809E-4; // smallest such that 1.0 + epsilon != 1.0
    D3DX_16F_MANT_DIG = 11; // # of bits in mantissa
    D3DX_16F_MAX = 6.550400E+004; // max value
    D3DX_16F_MAX_10_EXP = 4; // max decimal exponent
    D3DX_16F_MAX_EXP = 15; // max binary exponent
    D3DX_16F_MIN = 6.1035156E-5; // min positive value
    D3DX_16F_MIN_10_EXP = (-4); // min decimal exponent
    D3DX_16F_MIN_EXP = (-14); // min binary exponent
    D3DX_16F_RADIX = 2; // exponent radix
    D3DX_16F_ROUNDS = 1; // addition rounding: near
    D3DX_16F_SIGN_MASK = $8000;
    D3DX_16F_EXP_MASK = $7C00;
    D3DX_16F_FRAC_MASK = $03FF;

const
    // scaling modes for ID3DX10SkinInfo::Compact() & ID3DX10SkinInfo::UpdateMesh()
    D3DX10_SKININFO_NO_SCALING = 0;
    D3DX10_SKININFO_SCALE_TO_1 = 1;
    D3DX10_SKININFO_SCALE_TO_TOTAL = 2;


type
    {$IFNDEF FPC}
    PHRESULT = ^HRESULT;
    {$ENDIF}
    TD3DVECTOR = record
        x: single;
        y: single;
        z: single;
    end;

    TD3DMATRIX = record
        case integer of
            0: (_11, _12, _13, _14: single;
                _21, _22, _23, _24: single;
                _31, _32, _33, _34: single;
                _41, _42, _43, _44: single;);
            1: (m: array [0 .. 3, 0 .. 3] of single;);
    end;

    { TD3DXFLOAT16 }

    TD3DXFLOAT16 = record
        Value: word;
        class operator Equal(a, b: TD3DXFLOAT16): longbool;
        class operator NotEqual(a, b: TD3DXFLOAT16): longbool;
        class operator Implicit(a: single): TD3DXFLOAT16; // Implicit conversion of an FLOAT to type TD3DXFLOAT16
        class operator Explicit(a: TD3DXFLOAT16): single;
        constructor Create(f: single); overload;
        constructor Create(f: TD3DXFLOAT16); overload;
    end;

    PD3DXFLOAT16 = ^TD3DXFLOAT16;
    TD3DXFLOAT16ARRAY4 = array [0..3] of TD3DXFLOAT16;
    TD3DXFLOAT16ARRAY3 = array [0..2] of TD3DXFLOAT16;
    TD3DXFLOAT16ARRAY2 = array [0..1] of TD3DXFLOAT16;
    PD3DXFLOAT16ARRAY4 = ^TD3DXFLOAT16ARRAY4;
    PD3DXFLOAT16ARRAY3 = ^TD3DXFLOAT16ARRAY3;
    PD3DXFLOAT16ARRAY2 = ^TD3DXFLOAT16ARRAY2;
    

    { TD3DXVECTOR2 }

    TD3DXVECTOR2 = record
        x, y: single;
        constructor Create(ix, iy: single); overload;
        constructor Create(pf: PFloatArray2); overload;
        constructor Create(f: PD3DXFLOAT16); overload;
    // assignment operators
        class operator Add(a, b: TD3DXVECTOR2): TD3DXVECTOR2;
        class operator Subtract(a, b: TD3DXVECTOR2): TD3DXVECTOR2;
        class operator Multiply(a: TD3DXVECTOR2; b: single): TD3DXVECTOR2;
        class operator Divide(a: TD3DXVECTOR2; b: single): TD3DXVECTOR2;
    // unary operators
        class operator Positive(a: TD3DXVECTOR2): TD3DXVECTOR2;
        class operator Negative(a: TD3DXVECTOR2): TD3DXVECTOR2;
    // binary operators
        class operator Equal(a, b: TD3DXVECTOR2): longbool;
        class operator NotEqual(a, b: TD3DXVECTOR2): longbool;
        procedure Init(lx, ly: single);
    end;

    PD3DXVECTOR2 = ^TD3DXVECTOR2;

    { TD3DXVECTOR2_16F }

    TD3DXVECTOR2_16F = record
        x, y: TD3DXFLOAT16;
        constructor CreateBySingle(pf: PFloatArray2); overload;
        constructor CreateByFloat16(pf: PD3DXFLOAT16ARRAY2); overload;
        constructor Create(ix, iy: TD3DXFLOAT16); overload;
    // binary operators
        class operator Equal(a, b: TD3DXVECTOR2_16F): longbool;
        class operator NotEqual(a, b: TD3DXVECTOR2_16F): longbool;
    end;

    PD3DXVECTOR2_16F = ^TD3DXVECTOR2_16F;

    { TD3DXVECTOR3 }

    TD3DXVECTOR3 = record
        x: single;
        y: single;
        z: single;
        constructor Create(fx, fy, fz: single); overload;
        constructor CreateBySingle(f: PFloatArray3); overload;
        constructor Create(v: TD3DXVECTOR3); overload;
        constructor CreateByFloat16(pf: PD3DXFLOAT16);
    // assignment operators
        class operator Add(a, b: TD3DXVECTOR3): TD3DXVECTOR3;
        class operator Subtract(a, b: TD3DXVECTOR3): TD3DXVECTOR3;
        class operator Multiply(a: TD3DXVECTOR3; b: single): TD3DXVECTOR3;
        class operator Divide(a: TD3DXVECTOR3; b: single): TD3DXVECTOR3;
    // unary operators
        class operator Positive(a: TD3DXVECTOR3): TD3DXVECTOR3;
        class operator Negative(a: TD3DXVECTOR3): TD3DXVECTOR3;
    // binary operators
        class operator Equal(a, b: TD3DXVECTOR3): longbool;
        class operator NotEqual(a, b: TD3DXVECTOR3): longbool;
        procedure Init(lx, ly, lz: single);
    end;

    PD3DXVECTOR3 = ^TD3DXVECTOR3;

    { TD3DXVECTOR3_16F }

    TD3DXVECTOR3_16F = record
        x, y, z: TD3DXFLOAT16;
        constructor CreateBySingle(pf: PFloatArray3); overload;
        constructor Create(v: TD3DXVECTOR3); overload;
        constructor CreateByFloat16(pf: PD3DXFLOAT16);
        constructor Create(fx, fy, fz: TD3DXFLOAT16); overload;
    // binary operators
        class operator Equal(a, b: TD3DXVECTOR3_16F): longbool;
        class operator NotEqual(a, b: TD3DXVECTOR3_16F): longbool;
    end;

    PD3DXVECTOR3_16F = ^TD3DXVECTOR3_16F;

    { TD3DXVECTOR4 }

    TD3DXVECTOR4 = record
        x, y, z, w: single;
        constructor CreateBySingle(pf: PFloatArray4); overload;
        constructor CreateByFloat16(pf: PD3DXFLOAT16);
        constructor Create(v: TD3DXVECTOR3; fw: single); overload;
        constructor Create(fx, fy, fz, fw: single); overload;
    // assignment operators
        class operator Add(a, b: TD3DXVECTOR4): TD3DXVECTOR4;
        class operator Subtract(a, b: TD3DXVECTOR4): TD3DXVECTOR4;
        class operator Multiply(a: TD3DXVECTOR4; b: single): TD3DXVECTOR4;
        class operator Divide(a: TD3DXVECTOR4; b: single): TD3DXVECTOR4;
    // unary operators
        class operator Positive(a: TD3DXVECTOR4): TD3DXVECTOR4;
        class operator Negative(a: TD3DXVECTOR4): TD3DXVECTOR4;
    // binary operators
        class operator Equal(a, b: TD3DXVECTOR4): longbool;
        class operator NotEqual(a, b: TD3DXVECTOR4): longbool;
    end;

    PD3DXVECTOR4 = ^TD3DXVECTOR4;

    { TD3DXVECTOR4_16F }

    TD3DXVECTOR4_16F = record
        x, y, z, w: TD3DXFLOAT16;
        constructor CreateBySingle(pf: PSingle); overload;
        constructor CreateByFloat16(pf: PD3DXFLOAT16);
        constructor Create(v: TD3DXVECTOR3_16F; fw: TD3DXFLOAT16); overload;
        constructor Create(fx, fy, fz, fw: TD3DXFLOAT16); overload;
    // binary operators
        class operator Equal(a, b: TD3DXVECTOR4_16F): longbool;
        class operator NotEqual(a, b: TD3DXVECTOR4_16F): longbool;
    end;

    PD3DXVECTOR4_16F = ^TD3DXVECTOR4_16F;

    // ===========================================================================

    // Matrices

    // ===========================================================================

    { TD3DXMATRIX }

    TD3DXMATRIX = record
        constructor CreateBySingle(pf: PSingle);
        constructor Create(m: TD3DMATRIX); overload;
        constructor CreateByFloat16(pf: PD3DXFLOAT16);
        constructor Create(f11, f12, f13, f14, f21, f22, f23, f24, f31, f32, f33, f34, f41, f42, f43, f44: single); overload;
    // assignment operators
        class operator Add(a, b: TD3DXMATRIX): TD3DXMATRIX;
        class operator Subtract(a, b: TD3DXMATRIX): TD3DXMATRIX;
        class operator Multiply(a: TD3DXMATRIX; b: TD3DXMATRIX): TD3DXMATRIX;
                overload;
        class operator Multiply(a: TD3DXMATRIX; b: single): TD3DXMATRIX;
                overload;
        class operator Divide(a: TD3DXMATRIX; b: single): TD3DXMATRIX;
    // unary operators
        class operator Positive(a: TD3DXMATRIX): TD3DXMATRIX;
        class operator Negative(a: TD3DXMATRIX): TD3DXMATRIX;
    // binary operators
        class operator Equal(a, b: TD3DXMATRIX): longbool;
        class operator NotEqual(a, b: TD3DXMATRIX): longbool;

        procedure Identity;

        case integer of
            0: (_11, _12, _13, _14: single;
                _21, _22, _23, _24: single;
                _31, _32, _33, _34: single;
                _41, _42, _43, _44: single;);
            1: (m: array [0 .. 3, 0 .. 3] of single;);
    end;

    PD3DXMATRIX = ^TD3DXMATRIX;

    // ===========================================================================

    // Quaternions

    // ===========================================================================

    TD3DXQUATERNION = record
        x, y, z, w: single;
        constructor CreateBySingle(pf: PFloatArray4);
        constructor CreateByFloat16(pf: PD3DXFLOAT16);
        constructor Create(fx, fy, fz, fw: single);
    // assignment operators
        class operator Add(a, b: TD3DXQUATERNION): TD3DXQUATERNION;
        class operator Subtract(a, b: TD3DXQUATERNION): TD3DXQUATERNION;
        class operator Multiply(a: TD3DXQUATERNION; b: TD3DXQUATERNION): TD3DXQUATERNION;
                overload;
        class operator Multiply(a: TD3DXQUATERNION; b: single): TD3DXQUATERNION;
                overload;
        class operator Divide(a: TD3DXQUATERNION; b: single): TD3DXQUATERNION;
    // unary operators
        class operator Positive(a: TD3DXQUATERNION): TD3DXQUATERNION;
        class operator Negative(a: TD3DXQUATERNION): TD3DXQUATERNION;
    // binary operators
        class operator Equal(a, b: TD3DXQUATERNION): longbool;
        class operator NotEqual(a, b: TD3DXQUATERNION): longbool;
    end;

    PD3DXQUATERNION = ^TD3DXQUATERNION;


    { TD3DXPLANE }

    TD3DXPLANE = record
        a, b, c, d: single;
        constructor CreateBySingle(pf: PFloatArray4);
        constructor CreateByFloat16(pf: PD3DXFLOAT16);
        constructor Create(fa, fb, fc, fd: single);
    // assignment operators
        class operator Multiply(a: TD3DXPLANE; b: single): TD3DXPLANE;
        class operator Divide(a: TD3DXPLANE; b: single): TD3DXPLANE;
    // unary operators
        class operator Positive(a: TD3DXPLANE): TD3DXPLANE;
        class operator Negative(a: TD3DXPLANE): TD3DXPLANE;
    // binary operators
        class operator Equal(a, b: TD3DXPLANE): longbool;
        class operator NotEqual(a, b: TD3DXPLANE): longbool;
    end;
    PD3DXPLANE = ^TD3DXPLANE;

    { TD3DXCOLOR }

    TD3DXCOLOR = record
        r, g, b, a: single;
        constructor Create(argb: UINT); overload;
        constructor CreateBySingle(pf: PFloatArray4);
        constructor CreateByFloat16(pf: PD3DXFLOAT16);
        constructor Create(fr, fg, fb, fa: single); overload;
        // type casting
        function AsUINT: UINT;
    // assignment operators
        class operator Add(a, b: TD3DXCOLOR): TD3DXCOLOR;
        class operator Subtract(a, b: TD3DXCOLOR): TD3DXCOLOR;
        class operator Multiply(a: TD3DXCOLOR; b: single): TD3DXCOLOR;
        class operator Multiply(b: single; a: TD3DXCOLOR): TD3DXCOLOR;
        class operator Divide(a: TD3DXCOLOR; b: single): TD3DXCOLOR;
    // unary operators
        class operator Positive(a: TD3DXCOLOR): TD3DXCOLOR;
        class operator Negative(a: TD3DXCOLOR): TD3DXCOLOR;
    // binary operators
        class operator Equal(a, b: TD3DXCOLOR): longbool;
        class operator NotEqual(a, b: TD3DXCOLOR): longbool;

    end;
    PD3DXCOLOR = ^TD3DXCOLOR;

// ===========================================================================

// D3DX math functions:

// NOTE:
// * All these functions can take the same object as in and out parameters.

// * Out parameters are typically also returned as return values, so that
// the output of one function may be used as a parameter to another.

// ===========================================================================


// --------------------------
// Float16
// --------------------------

// Converts an array 32-bit floats to 16-bit floats
function D3DXFloat32To16Array(pOut: PD3DXFLOAT16; pIn: PSingle; n: UINT): PD3DXFLOAT16; stdcall; external DLL_D3DX10;
// Converts an array 16-bit floats to 32-bit floats
function D3DXFloat16To32Array(pOut: PSingle; pIn: PD3DXFLOAT16; n: UINT): PSingle; stdcall; external DLL_D3DX10;


// --------------------------
// 2D Vector
// --------------------------

// inline

function D3DXVec2Length(const pV: PD3DXVECTOR2): single;

function D3DXVec2LengthSq(const pV: PD3DXVECTOR2): single;

function D3DXVec2Dot(const pV1: PD3DXVECTOR2; const pV2: PD3DXVECTOR2): single;

// Z component of ((x1,y1,0) cross (x2,y2,0))
function D3DXVec2CCW(const pV1: PD3DXVECTOR2; const pV2: PD3DXVECTOR2): single;

function D3DXVec2Add(pOut: PD3DXVECTOR2; const pV1: PD3DXVECTOR2; const pV2: PD3DXVECTOR2): PD3DXVECTOR2;

function D3DXVec2Subtract(pOut: PD3DXVECTOR2; const pV1: PD3DXVECTOR2; const pV2: PD3DXVECTOR2): PD3DXVECTOR2;

// Minimize each component.  x = min(x1, x2), y = min(y1, y2)
function D3DXVec2Minimize(pOut: PD3DXVECTOR2; const pV1: PD3DXVECTOR2; const pV2: PD3DXVECTOR2): PD3DXVECTOR2;

// Maximize each component.  x = max(x1, x2), y = max(y1, y2)
function D3DXVec2Maximize(pOut: PD3DXVECTOR2; const pV1: PD3DXVECTOR2; const pV2: PD3DXVECTOR2): PD3DXVECTOR2;

function D3DXVec2Scale(pOut: PD3DXVECTOR2; const pV: PD3DXVECTOR2; s: single): PD3DXVECTOR2;

// Linear interpolation. V1 + s(V2-V1)
function D3DXVec2Lerp(pOut: PD3DXVECTOR2; const pV1: PD3DXVECTOR2; const pV2: PD3DXVECTOR2; s: single): PD3DXVECTOR2;

// non-inline

function D3DXVec2Normalize(pOut: PD3DXVECTOR2; const pV: PD3DXVECTOR2): PD3DXVECTOR2; stdcall; external DLL_D3DX10;

// Hermite interpolation between position V1, tangent T1 (when s == 0)
// and position V2, tangent T2 (when s == 1).
function D3DXVec2Hermite(pOut: PD3DXVECTOR2; const pV1: PD3DXVECTOR2; const pT1: PD3DXVECTOR2; const pV2: PD3DXVECTOR2;
    const pT2: PD3DXVECTOR2; s: single): PD3DXVECTOR2; stdcall; external DLL_D3DX10;

// CatmullRom interpolation between V1 (when s == 0) and V2 (when s == 1)
function D3DXVec2CatmullRom(pOut: PD3DXVECTOR2; const pV0: PD3DXVECTOR2; const pV1: PD3DXVECTOR2; const pV2: PD3DXVECTOR2;
    const pV3: PD3DXVECTOR2; s: single): PD3DXVECTOR2; stdcall; external DLL_D3DX10;

// Barycentric coordinates.  V1 + f(V2-V1) + g(V3-V1)
function D3DXVec2BaryCentric(pOut: PD3DXVECTOR2; const pV1: PD3DXVECTOR2; const pV2: PD3DXVECTOR2; const pV3: PD3DXVECTOR2;
    f, g: single): PD3DXVECTOR2;
    stdcall; external DLL_D3DX10;

// Transform (x, y, 0, 1) by matrix.
function D3DXVec2Transform(pOut: PD3DXVECTOR4; const pV: PD3DXVECTOR2; const pM: PD3DXMATRIX): PD3DXVECTOR4; stdcall; external DLL_D3DX10;

// Transform (x, y, 0, 1) by matrix, project result back into w=1.
function D3DXVec2TransformCoord(pOut: PD3DXVECTOR2; const pV: PD3DXVECTOR2; const pM: PD3DXMATRIX): PD3DXVECTOR2; stdcall; external DLL_D3DX10;

// Transform (x, y, 0, 0) by matrix.
function D3DXVec2TransformNormal(pOut: PD3DXVECTOR2; const pV: PD3DXVECTOR2; const pM: PD3DXMATRIX): PD3DXVECTOR2; stdcall; external DLL_D3DX10;

// Transform Array (x, y, 0, 1) by matrix.
function D3DXVec2TransformArray(pOut: PD3DXVECTOR4; OutStride: UINT; const pV: PD3DXVECTOR2; VStride: UINT;
    const pM: PD3DXMATRIX; n: UINT): PD3DXVECTOR4;
    stdcall; external DLL_D3DX10;

// Transform Array (x, y, 0, 1) by matrix, project result back into w=1.
function D3DXVec2TransformCoordArray(pOut: PD3DXVECTOR2; OutStride: UINT; const pV: PD3DXVECTOR2; VStride: UINT;
    const pM: PD3DXMATRIX; n: UINT): PD3DXVECTOR2;
    stdcall; external DLL_D3DX10;

// Transform Array (x, y, 0, 0) by matrix.
function D3DXVec2TransformNormalArray(pOut: PD3DXVECTOR2; OutStride: UINT; const pV: PD3DXVECTOR2; VStride: UINT;
    const pM: PD3DXMATRIX; n: UINT): PD3DXVECTOR2; stdcall; external DLL_D3DX10;


// --------------------------
// 3D Vector
// --------------------------

// inline

function D3DXVec3Length(const pV: PD3DXVECTOR3): single;

function D3DXVec3LengthSq(const pV: PD3DXVECTOR3): single;

function D3DXVec3Dot(const pV1: PD3DXVECTOR3; const pV2: PD3DXVECTOR3): single;

function D3DXVec3Cross(pOut: PD3DXVECTOR3; const pV1: PD3DXVECTOR3; const pV2: PD3DXVECTOR3): PD3DXVECTOR3;

function D3DXVec3Add(pOut: PD3DXVECTOR3; const pV1: PD3DXVECTOR3; const pV2: PD3DXVECTOR3): PD3DXVECTOR3;

function D3DXVec3Subtract(pOut: PD3DXVECTOR3; const pV1: PD3DXVECTOR3; const pV2: PD3DXVECTOR3): PD3DXVECTOR3;

// Minimize each component.  x = min(x1, x2), y = min(y1, y2), ...
function D3DXVec3Minimize(pOut: PD3DXVECTOR3; const pV1: PD3DXVECTOR3; const pV2: PD3DXVECTOR3): PD3DXVECTOR3;

// Maximize each component.  x = max(x1, x2), y = max(y1, y2), ...
function D3DXVec3Maximize(pOut: PD3DXVECTOR3; const pV1: PD3DXVECTOR3; const pV2: PD3DXVECTOR3): PD3DXVECTOR3;

function D3DXVec3Scale(pOut: PD3DXVECTOR3; const pV: PD3DXVECTOR3; s: single): PD3DXVECTOR3;

// Linear interpolation. V1 + s(V2-V1)
function D3DXVec3Lerp(pOut: PD3DXVECTOR3; const pV1: PD3DXVECTOR3; const pV2: PD3DXVECTOR3; s: single): PD3DXVECTOR3;

// non-inline

function D3DXVec3Normalize(pOut: PD3DXVECTOR3; const pV: PD3DXVECTOR3): PD3DXVECTOR3; stdcall; external DLL_D3DX10;

// Hermite interpolation between position V1, tangent T1 (when s == 0)
// and position V2, tangent T2 (when s == 1).
function D3DXVec3Hermite(pOut: PD3DXVECTOR3; const pV1: PD3DXVECTOR3; const pT1: PD3DXVECTOR3; const pV2: PD3DXVECTOR3;
    const pT2: PD3DXVECTOR3; s: single): PD3DXVECTOR3; stdcall; external DLL_D3DX10;

// CatmullRom interpolation between V1 (when s == 0) and V2 (when s == 1)
function D3DXVec3CatmullRom(pOut: PD3DXVECTOR3; const pV0: PD3DXVECTOR3; const pV1: PD3DXVECTOR3; const pV2: PD3DXVECTOR3;
    const pV3: PD3DXVECTOR3; s: single): PD3DXVECTOR3; stdcall; external DLL_D3DX10;

// Barycentric coordinates.  V1 + f(V2-V1) + g(V3-V1)
function D3DXVec3BaryCentric(pOut: PD3DXVECTOR3; const pV1: PD3DXVECTOR3; const pV2: PD3DXVECTOR3; const pV3: PD3DXVECTOR3;
    f: single; g: single): PD3DXVECTOR3; stdcall; external DLL_D3DX10;

// Transform (x, y, z, 1) by matrix.
function D3DXVec3Transform(pOut: PD3DXVECTOR4; const pV: PD3DXVECTOR3; const pM: PD3DXMATRIX): PD3DXVECTOR4; stdcall; external DLL_D3DX10;

// Transform (x, y, z, 1) by matrix, project result back into w=1.
function D3DXVec3TransformCoord(pOut: PD3DXVECTOR3; const pV: PD3DXVECTOR3; const pM: PD3DXMATRIX): PD3DXVECTOR3; stdcall; external DLL_D3DX10;

// Transform (x, y, z, 0) by matrix.  If you transforming a normal by a
// non-affine matrix, the matrix you pass to this function should be the
// transpose of the inverse of the matrix you would use to transform a coord.
function D3DXVec3TransformNormal(pOut: PD3DXVECTOR3; const pV: PD3DXVECTOR3; const pM: PD3DXMATRIX): PD3DXVECTOR3; stdcall; external DLL_D3DX10;

// Transform Array (x, y, z, 1) by matrix.
function D3DXVec3TransformArray(pOut: PD3DXVECTOR4; OutStride: UINT; const pV: PD3DXVECTOR3; VStride: UINT;
    const pM: PD3DXMATRIX; n: UINT): PD3DXVECTOR4;
    stdcall; external DLL_D3DX10;

// Transform Array (x, y, z, 1) by matrix, project result back into w=1.
function D3DXVec3TransformCoordArray(pOut: PD3DXVECTOR3; OutStride: UINT; const pV: PD3DXVECTOR3; VStride: UINT;
    const pM: PD3DXMATRIX; n: UINT): PD3DXVECTOR3;
    stdcall; external DLL_D3DX10;

// Transform (x, y, z, 0) by matrix.  If you transforming a normal by a
// non-affine matrix, the matrix you pass to this function should be the
// transpose of the inverse of the matrix you would use to transform a coord.
function D3DXVec3TransformNormalArray(pOut: PD3DXVECTOR3; OutStride: UINT; const pV: PD3DXVECTOR3; VStride: UINT;
    const pM: PD3DXMATRIX; n: UINT): PD3DXVECTOR3; stdcall; external DLL_D3DX10;

// Project vector from object space into screen space
function D3DXVec3Project(pOut: PD3DXVECTOR3; const pV: PD3DXVECTOR3; const pViewport: PD3D10_VIEWPORT;
    const pProjection: PD3DXMATRIX; const pView: PD3DXMATRIX; const pWorld: PD3DXMATRIX): PD3DXVECTOR3; stdcall; external DLL_D3DX10;

// Project vector from screen space into object space
function D3DXVec3Unproject(pOut: PD3DXVECTOR3; const pV: PD3DXVECTOR3; const pViewport: PD3D10_VIEWPORT;
    const pProjection: PD3DXMATRIX; const pView: PD3DXMATRIX; const pWorld: PD3DXMATRIX): PD3DXVECTOR3; stdcall; external DLL_D3DX10;

// Project vector Array from object space into screen space
function D3DXVec3ProjectArray(pOut: PD3DXVECTOR3; OutStride: UINT; const pV: PD3DXVECTOR3; VStride: UINT;
    const pViewport: PD3D10_VIEWPORT; const pProjection: PD3DXMATRIX; const pView: PD3DXMATRIX; const pWorld: PD3DXMATRIX;
    n: UINT): PD3DXVECTOR3; stdcall; external DLL_D3DX10;

// Project vector Array from screen space into object space
function D3DXVec3UnprojectArray(pOut: PD3DXVECTOR3; OutStride: UINT; const pV: PD3DXVECTOR3; VStride: UINT;
    const pViewport: PD3D10_VIEWPORT; const pProjection: PD3DXMATRIX; const pView: PD3DXMATRIX; const pWorld: PD3DXMATRIX;
    n: UINT): PD3DXVECTOR3; stdcall; external DLL_D3DX10;


// --------------------------
// 4D Vector
// --------------------------

// inline

function D3DXVec4Length(const pV: PD3DXVECTOR4): single;

function D3DXVec4LengthSq(const pV: PD3DXVECTOR4): single;

function D3DXVec4Dot(const pV1: PD3DXVECTOR4; const pV2: PD3DXVECTOR4): single;

function D3DXVec4Add(pOut: PD3DXVECTOR4; const pV1: PD3DXVECTOR4; const pV2: PD3DXVECTOR4): PD3DXVECTOR4;

function D3DXVec4Subtract(pOut: PD3DXVECTOR4; const pV1: PD3DXVECTOR4; const pV2: PD3DXVECTOR4): PD3DXVECTOR4;

// Minimize each component.  x = min(x1, x2), y = min(y1, y2), ...
function D3DXVec4Minimize(pOut: PD3DXVECTOR4; const pV1: PD3DXVECTOR4; const pV2: PD3DXVECTOR4): PD3DXVECTOR4;

// Maximize each component.  x = max(x1, x2), y = max(y1, y2), ...
function D3DXVec4Maximize(pOut: PD3DXVECTOR4; const pV1: PD3DXVECTOR4; const pV2: PD3DXVECTOR4): PD3DXVECTOR4;

function D3DXVec4Scale(pOut: PD3DXVECTOR4; const pV: PD3DXVECTOR4; s: single): PD3DXVECTOR4;

// Linear interpolation. V1 + s(V2-V1)
function D3DXVec4Lerp(pOut: PD3DXVECTOR4; const pV1: PD3DXVECTOR4; const pV2: PD3DXVECTOR4; s: single): PD3DXVECTOR4;

// non-inline

// Cross-product in 4 dimensions.
function D3DXVec4Cross(pOut: PD3DXVECTOR4; const pV1: PD3DXVECTOR4; const pV2: PD3DXVECTOR4; const pV3: PD3DXVECTOR4): PD3DXVECTOR4; stdcall;
    external DLL_D3DX10;

function D3DXVec4Normalize(pOut: PD3DXVECTOR4; const pV: PD3DXVECTOR4): PD3DXVECTOR4; stdcall; external DLL_D3DX10;

// Hermite interpolation between position V1, tangent T1 (when s == 0)
// and position V2, tangent T2 (when s == 1).
function D3DXVec4Hermite(pOut: PD3DXVECTOR4; const pV1: PD3DXVECTOR4; const pT1: PD3DXVECTOR4; const pV2: PD3DXVECTOR4;
    const pT2: PD3DXVECTOR4; s: single): PD3DXVECTOR4; stdcall; external DLL_D3DX10;

// CatmullRom interpolation between V1 (when s == 0) and V2 (when s == 1)
function D3DXVec4CatmullRom(pOut: PD3DXVECTOR4; const pV0: PD3DXVECTOR4; const pV1: PD3DXVECTOR4; const pV2: PD3DXVECTOR4;
    const pV3: PD3DXVECTOR4; s: single): PD3DXVECTOR4; stdcall; external DLL_D3DX10;

// Barycentric coordinates.  V1 + f(V2-V1) + g(V3-V1)
function D3DXVec4BaryCentric(pOut: PD3DXVECTOR4; const pV1: PD3DXVECTOR4; const pV2: PD3DXVECTOR4; const pV3: PD3DXVECTOR4;
    f: single; g: single): PD3DXVECTOR4; stdcall; external DLL_D3DX10;

// Transform vector by matrix.
function D3DXVec4Transform(pOut: PD3DXVECTOR4; const pV: PD3DXVECTOR4; const pM: PD3DXMATRIX): PD3DXVECTOR4; stdcall; external DLL_D3DX10;

// Transform vector array by matrix.
function D3DXVec4TransformArray(pOut: PD3DXVECTOR4; OutStride: UINT; const pV: PD3DXVECTOR4; VStride: UINT;
    const pM: PD3DXMATRIX; n: UINT): PD3DXVECTOR4;
    stdcall; external DLL_D3DX10;


// --------------------------
// Plane
// --------------------------

// inline

// ax + by + cz + dw
function D3DXPlaneDot(const pP: PD3DXPLANE; const pV: PD3DXVECTOR4): single;

// ax + by + cz + d
function D3DXPlaneDotCoord(const pP: PD3DXPLANE; const pV: PD3DXVECTOR3): single;

// ax + by + cz
function D3DXPlaneDotNormal(const pP: PD3DXPLANE; const pV: PD3DXVECTOR3): single;

function D3DXPlaneScale(pOut: PD3DXPLANE; const pP: PD3DXPLANE; s: single): PD3DXPLANE;

// non-inline

// Normalize plane (so that |a,b,c| == 1)
function D3DXPlaneNormalize(pOut: PD3DXPLANE; const pP: PD3DXPLANE): PD3DXPLANE; stdcall; external DLL_D3DX10;

// Find the intersection between a plane and a line.  If the line is
// parallel to the plane, NULL is returned.
function D3DXPlaneIntersectLine(pOut: PD3DXVECTOR3; const pP: PD3DXPLANE; const pV1: PD3DXVECTOR3; const pV2: PD3DXVECTOR3): PD3DXVECTOR3; stdcall;
    external DLL_D3DX10;

// Construct a plane from a point and a normal
function D3DXPlaneFromPointNormal(pOut: PD3DXPLANE; const pPoint: PD3DXVECTOR3; const pNormal: PD3DXVECTOR3): PD3DXPLANE;
    stdcall; external DLL_D3DX10;

// Construct a plane from 3 points
function D3DXPlaneFromPoints(pOut: PD3DXPLANE; const pV1: PD3DXVECTOR3; const pV2: PD3DXVECTOR3; const pV3: PD3DXVECTOR3): PD3DXPLANE; stdcall;
    external DLL_D3DX10;

// Transform a plane by a matrix.  The vector (a,b,c) must be normal.
// M should be the inverse transpose of the transformation desired.
function D3DXPlaneTransform(pOut: PD3DXPLANE; const pP: PD3DXPLANE; const pM: PD3DXMATRIX): PD3DXPLANE; stdcall; external DLL_D3DX10;

// Transform an array of planes by a matrix.  The vectors (a,b,c) must be normal.
// M should be the inverse transpose of the transformation desired.
function D3DXPlaneTransformArray(pOut: PD3DXPLANE; OutStride: UINT; const pP: PD3DXPLANE; PStride: UINT;
    const pM: PD3DXMATRIX; n: UINT): PD3DXPLANE; stdcall;
    external DLL_D3DX10;


// --------------------------
// Color
// --------------------------

// inline

// (1-r, 1-g, 1-b, a)
function D3DXColorNegative(pOut: PD3DXCOLOR; const pC: PD3DXCOLOR): PD3DXCOLOR;

function D3DXColorAdd(pOut: PD3DXCOLOR; const pC1: PD3DXCOLOR; const pC2: PD3DXCOLOR): PD3DXCOLOR;

function D3DXColorSubtract(pOut: PD3DXCOLOR; const pC1: PD3DXCOLOR; const pC2: PD3DXCOLOR): PD3DXCOLOR;

function D3DXColorScale(pOut: PD3DXCOLOR; const pC: PD3DXCOLOR; s: single): PD3DXCOLOR;

// (r1*r2, g1*g2, b1*b2, a1*a2)
function D3DXColorModulate(pOut: PD3DXCOLOR; const pC1: PD3DXCOLOR; const pC2: PD3DXCOLOR): PD3DXCOLOR;

// Linear interpolation of r,g,b, and a. C1 + s(C2-C1)
function D3DXColorLerp(pOut: PD3DXCOLOR; const pC1: PD3DXCOLOR; const pC2: PD3DXCOLOR; s: single): PD3DXCOLOR;

// non-inline

// Interpolate r,g,b between desaturated color and color.
// DesaturatedColor + s(Color - DesaturatedColor)
function D3DXColorAdjustSaturation(pOut: PD3DXCOLOR; const pC: PD3DXCOLOR; s: single): PD3DXCOLOR; stdcall; external DLL_D3DX10;

// Interpolate r,g,b between 50% grey and color.  Grey + s(Color - Grey)
function D3DXColorAdjustContrast(pOut: PD3DXCOLOR; const pC: PD3DXCOLOR; c: single): PD3DXCOLOR; stdcall; external DLL_D3DX10;

// --------------------------
// 4D Matrix
// --------------------------
function D3DXMatrixIdentity(pOut: PD3DXMATRIX): PD3DXMATRIX;

function D3DXMatrixIsIdentity(pM: PD3DXMATRIX): longbool;

function D3DXMatrixDeterminant(const pM: PD3DXMATRIX): single; stdcall; external DLL_D3DX10;

function D3DXMatrixDecompose(pOutScale: PD3DXVECTOR3; pOutRotation: PD3DXQUATERNION; pOutTranslation: PD3DXVECTOR3;
    pM: PD3DXMATRIX): HResult; stdcall;
    external DLL_D3DX10;

function D3DXMatrixTranspose(pOut: PD3DXMATRIX; const pM: PD3DXMATRIX): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Matrix multiplication.  The result represents the transformation M2
// followed by the transformation M1.  (Out = M1 * M2)
function D3DXMatrixMultiply(pOut: PD3DXMATRIX; const pM1: PD3DXMATRIX; const pM2: PD3DXMATRIX): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Matrix multiplication, followed by a transpose. (Out = T(M1 * M2))
function D3DXMatrixMultiplyTranspose(pOut: PD3DXMATRIX; const pM1: PD3DXMATRIX; const pM2: PD3DXMATRIX): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Calculate inverse of matrix.  Inversion my fail, in which case NULL will
// be returned.  The determinant of pM is also returned it pfDeterminant
// is non-NULL.
function D3DXMatrixInverse(pOut: PD3DXMATRIX; pDeterminant: PSingle; const pM: PD3DXMATRIX): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Build a matrix which scales by (sx, sy, sz)
function D3DXMatrixScaling(pOut: PD3DXMATRIX; sx, sy, sz: single): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Build a matrix which translates by (x, y, z)
function D3DXMatrixTranslation(pOut: PD3DXMATRIX; x, y, z: single): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Build a matrix which rotates around the X axis
function D3DXMatrixRotationX(pOut: PD3DXMATRIX; Angle: single): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Build a matrix which rotates around the Y axis
function D3DXMatrixRotationY(pOut: PD3DXMATRIX; Angle: single): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Build a matrix which rotates around the Z axis
function D3DXMatrixRotationZ(pOut: PD3DXMATRIX; Angle: single): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Build a matrix which rotates around an arbitrary axis
function D3DXMatrixRotationAxis(pOut: PD3DXMATRIX; pV: PD3DXVECTOR3; Angle: single): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Build a matrix from a quaternion
function D3DXMatrixRotationQuaternion(pOut: PD3DXMATRIX; pQ: PD3DXQUATERNION): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Yaw around the Y axis, a pitch around the X axis,
// and a roll around the Z axis.
function D3DXMatrixRotationYawPitchRoll(pOut: PD3DXMATRIX; Yaw, Pitch, Roll: single): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Build transformation matrix.  NULL arguments are treated as identity.
// Mout = Msc-1 * Msr-1 * Ms * Msr * Msc * Mrc-1 * Mr * Mrc * Mt
function D3DXMatrixTransformation(pOut: PD3DXMATRIX; const pScalingCenter: PD3DXVECTOR3; const pScalingRotation: PD3DXQUATERNION;
    const pScaling: PD3DXVECTOR3; const pRotationCenter: PD3DXVECTOR3; const pRotation: PD3DXQUATERNION;
    const pTranslation: PD3DXVECTOR3): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Build 2D transformation matrix in XY plane.  NULL arguments are treated as identity.
// Mout = Msc-1 * Msr-1 * Ms * Msr * Msc * Mrc-1 * Mr * Mrc * Mt
function D3DXMatrixTransformation2D(pOut: PD3DXMATRIX; const pScalingCenter: PD3DXVECTOR2; ScalingRotation: single;
    const pScaling: PD3DXVECTOR2; const pRotationCenter: PD3DXVECTOR2; Rotation: single; const pTranslation: PD3DXVECTOR2): PD3DXMATRIX;
    stdcall; external DLL_D3DX10;

// Build affine transformation matrix.  NULL arguments are treated as identity.
// Mout = Ms * Mrc-1 * Mr * Mrc * Mt
function D3DXMatrixAffineTransformation(pOut: PD3DXMATRIX; Scaling: single; const pRotationCenter: PD3DXVECTOR3;
    const pRotation: PD3DXQUATERNION; const pTranslation: PD3DXVECTOR3): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Build 2D affine transformation matrix in XY plane.  NULL arguments are treated as identity.
// Mout = Ms * Mrc-1 * Mr * Mrc * Mt
function D3DXMatrixAffineTransformation2D(pOut: PD3DXMATRIX; Scaling: single; const pRotationCenter: PD3DXVECTOR2;
    Rotation: single; const pTranslation: PD3DXVECTOR2): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Build a lookat matrix. (right-handed)
function D3DXMatrixLookAtRH(pOut: PD3DXMATRIX; const pEye: TD3DXVECTOR3; const pAt: TD3DXVECTOR3; const pUp: TD3DXVECTOR3): PD3DXMATRIX; stdcall;
    external DLL_D3DX10;

// Build a lookat matrix. (left-handed)
function D3DXMatrixLookAtLH(pOut: PD3DXMATRIX; const pEye: TD3DXVECTOR3; const pAt: TD3DXVECTOR3; const pUp: TD3DXVECTOR3): PD3DXMATRIX; stdcall;
    external DLL_D3DX10;

// Build a perspective projection matrix. (right-handed)
function D3DXMatrixPerspectiveRH(pOut: PD3DXMATRIX; w, h, zn, zf: single): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Build a perspective projection matrix. (left-handed)
function D3DXMatrixPerspectiveLH(pOut: PD3DXMATRIX; w, h, zn, zf: single): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Build a perspective projection matrix. (right-handed)
function D3DXMatrixPerspectiveFovRH(pOut: PD3DXMATRIX; fovy, Aspect, zn, zf: single): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Build a perspective projection matrix. (left-handed)
function D3DXMatrixPerspectiveFovLH(pOut: PD3DXMATRIX; fovy, Aspect, zn, zf: single): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Build a perspective projection matrix. (right-handed)
function D3DXMatrixPerspectiveOffCenterRH(pOut: PD3DXMATRIX; l, r, b, t, zn, zf: single): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Build a perspective projection matrix. (left-handed)
function D3DXMatrixPerspectiveOffCenterLH(pOut: PD3DXMATRIX; l, r, b, t, zn, zf: single): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Build an ortho projection matrix. (right-handed)
function D3DXMatrixOrthoRH(pOut: PD3DXMATRIX; w, h, zn, zf: single): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Build an ortho projection matrix. (left-handed)
function D3DXMatrixOrthoLH(pOut: PD3DXMATRIX; w, h, zn, zf: single): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Build an ortho projection matrix. (right-handed)
function D3DXMatrixOrthoOffCenterRH(pOut: PD3DXMATRIX; l, r, b, t, zn, zf: single): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Build an ortho projection matrix. (left-handed)
function D3DXMatrixOrthoOffCenterLH(pOut: PD3DXMATRIX; l, r, b, t, zn, zf: single): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Build a matrix which flattens geometry into a plane, as if casting
// a shadow from a light.
function D3DXMatrixShadow(pOut: PD3DXMATRIX; const pLight: PD3DXVECTOR4; const pPlane: PD3DXPLANE): PD3DXMATRIX; stdcall; external DLL_D3DX10;

// Build a matrix which reflects the coordinate system about a plane
function D3DXMatrixReflect(pOut: PD3DXMATRIX; const pPlane: PD3DXPLANE): PD3DXMATRIX; stdcall; external DLL_D3DX10;


// --------------------------
// Quaternion
// --------------------------

function D3DXQuaternionLength(pQ: PD3DXQUATERNION): single;

// Length squared, or "norm"
function D3DXQuaternionLengthSq(pQ: PD3DXQUATERNION): single;

function D3DXQuaternionDot(pQ1: PD3DXQUATERNION; pQ2: PD3DXQUATERNION): single;

// (0, 0, 0, 1)
function D3DXQuaternionIdentity(pOut: PD3DXQUATERNION): PD3DXQUATERNION;

function D3DXQuaternionIsIdentity(pQ: PD3DXQUATERNION): longbool;

// (-x, -y, -z, w)
function D3DXQuaternionConjugate(pOut: PD3DXQUATERNION; pQ: PD3DXQUATERNION): PD3DXQUATERNION;

// Compute a quaternin's axis and angle of rotation. Expects unit quaternions.
procedure D3DXQuaternionToAxisAngle(pQ: PD3DXQUATERNION; pAxis: PD3DXVECTOR3; pAngle: PSingle); stdcall; external DLL_D3DX10;

// Build a quaternion from a rotation matrix.
function D3DXQuaternionRotationMatrix(pOut: PD3DXQUATERNION; pM: PD3DXMATRIX): PD3DXQUATERNION; stdcall; external DLL_D3DX10;

// Rotation about arbitrary axis.
function D3DXQuaternionRotationAxis(pOut: PD3DXQUATERNION; pV: PD3DXVECTOR3; Angle: PSingle): PD3DXQUATERNION; stdcall; external DLL_D3DX10;

// Yaw around the Y axis, a pitch around the X axis,
// and a roll around the Z axis.
function D3DXQuaternionRotationYawPitchRoll(pOut: PD3DXQUATERNION; Yaw, Pitch, Roll: single): PD3DXQUATERNION; stdcall; external DLL_D3DX10;

// Quaternion multiplication.  The result represents the rotation Q2
// followed by the rotation Q1.  (Out = Q2 * Q1)
function D3DXQuaternionMultiply(pOut: PD3DXQUATERNION; pQ1: PD3DXQUATERNION; pQ2: PD3DXQUATERNION): PD3DXQUATERNION; stdcall; external DLL_D3DX10;

function D3DXQuaternionNormalize(pOut: PD3DXQUATERNION; pQ: PD3DXQUATERNION): PD3DXQUATERNION; stdcall; external DLL_D3DX10;

// Conjugate and re-norm
function D3DXQuaternionInverse(pOut: PD3DXQUATERNION; pQ: PD3DXQUATERNION): PD3DXQUATERNION; stdcall; external DLL_D3DX10;

// Expects unit quaternions.
// if q = (cos(theta), sin(theta) * v); ln(q) = (0, theta * v)
function D3DXQuaternionLn(pOut: PD3DXQUATERNION; pQ: PD3DXQUATERNION): PD3DXQUATERNION; stdcall; external DLL_D3DX10;

// Expects pure quaternions. (w == 0)  w is ignored in calculation.
// if q = (0, theta * v); exp(q) = (cos(theta), sin(theta) * v)
function D3DXQuaternionExp(pOut: PD3DXQUATERNION; pQ: PD3DXQUATERNION): PD3DXQUATERNION; stdcall; external DLL_D3DX10;

// Spherical linear interpolation between Q1 (t == 0) and Q2 (t == 1).
// Expects unit quaternions.
function D3DXQuaternionSlerp(pOut: PD3DXQUATERNION; pQ1: PD3DXQUATERNION; pQ2: PD3DXQUATERNION; t: single): PD3DXQUATERNION;
    stdcall; external DLL_D3DX10;

// Spherical quadrangle interpolation.
// Slerp(Slerp(Q1, C, t), Slerp(A, B, t), 2t(1-t))
function D3DXQuaternionSquad(pOut: PD3DXQUATERNION; pQ1: PD3DXQUATERNION; pA: PD3DXQUATERNION; pB: PD3DXQUATERNION;
    pC: PD3DXQUATERNION; t: single): PD3DXQUATERNION; stdcall; external DLL_D3DX10;

// Setup control points for spherical quadrangle interpolation
// from Q1 to Q2.  The control points are chosen in such a way
// to ensure the continuity of tangents with adjacent segments.
procedure D3DXQuaternionSquadSetup(pAOut: PD3DXQUATERNION; pBOut: PD3DXQUATERNION; pCOut: PD3DXQUATERNION;
    pQ0: PD3DXQUATERNION; pQ1: PD3DXQUATERNION; pQ2: PD3DXQUATERNION; pQ3: PD3DXQUATERNION); stdcall; external DLL_D3DX10;

// Barycentric interpolation.
// Slerp(Slerp(Q1, Q2, f+g), Slerp(Q1, Q3, f+g), g/(f+g))
function D3DXQuaternionBaryCentric(pOut: PD3DXQUATERNION; pQ1: PD3DXQUATERNION; pQ2: PD3DXQUATERNION; pQ3: PD3DXQUATERNION;
    f, g: single): PD3DXQUATERNION;
    stdcall; external DLL_D3DX10;


// --------------------------
// Misc
// --------------------------

// Calculate Fresnel term given the cosine of theta (likely obtained by
// taking the dot of two normals), and the refraction index of the material.
function D3DXFresnelTerm(CosTheta, RefractionIndex: single): single; stdcall; external DLL_D3DX10;


// ===========================================================================

// Matrix Stack

// ===========================================================================

type
    ID3DXMatrixStack = interface(IUnknown)
        ['{C7885BA7-F990-4fe7-922D-8515E477DD85}']
        function Pop(): HResult; stdcall;
        function Push(): HResult; stdcall;
        function LoadIdentity(): HResult; stdcall;
        function LoadMatrix(pM: PD3DXMATRIX): HResult; stdcall;
        function MultMatrix(pM: PD3DXMATRIX): HResult; stdcall;
        function MultMatrixLocal(pM: PD3DXMATRIX): HResult; stdcall;
        function RotateAxis(pV: PD3DXVECTOR3; Angle: single): HResult; stdcall;
        function RotateAxisLocal(pV: PD3DXVECTOR3; Angle: single): HResult; stdcall;
        function RotateYawPitchRoll(Yaw, Pitch, Roll: single): HResult; stdcall;
        function RotateYawPitchRollLocal(Yaw, Pitch, Roll: single): HResult; stdcall;
        function Scale(x, y, z: single): HResult; stdcall;
        function ScaleLocal(x, y, z: single): HResult; stdcall;
        function Translate(x, y, z: single): HResult; stdcall;
        function TranslateLocal(x, y, z: single): HResult; stdcall;
        function GetTop(): PD3DXMATRIX; stdcall;
    end;

    PID3DXMatrixStack = ^ID3DXMatrixStack;

function D3DXCreateMatrixStack(Flags: UINT; out ppStack: ID3DXMatrixStack): HResult; stdcall; external DLL_D3DX10;

// ============================================================================

// Basic Spherical Harmonic math routines

// ============================================================================

const
    D3DXSH_MINORDER = 2;
    D3DXSH_MAXORDER = 6;

type
    TD3DX_CPU_OPTIMIZATION = (D3DX_NOT_OPTIMIZED = 0, D3DX_3DNOW_OPTIMIZED, D3DX_SSE2_OPTIMIZED, D3DX_SSE_OPTIMIZED);

function D3DXSHEvalDirection(pOut: PSingle; Order: UINT; const pDir: PD3DXVECTOR3): PSingle; stdcall; external DLL_D3DX10;

function D3DXSHRotate(pOut: PSingle; Order: UINT; pMatrix: PD3DXMATRIX; pIn: PSingle): PSingle; stdcall; external DLL_D3DX10;

function D3DXSHRotateZ(pOut: PSingle; Order: UINT; Angle: single; pIn: PSingle): PSingle; stdcall; external DLL_D3DX10;

function D3DXSHAdd(pOut: PSingle; Order: UINT; pA: PSingle; pB: PSingle): PSingle; stdcall; external DLL_D3DX10;

function D3DXSHScale(pOut: PSingle; Order: UINT; pIn: PSingle; const Scale: single): PSingle; stdcall; external DLL_D3DX10;

function D3DXSHDot(Order: UINT; pA: PSingle; pB: PSingle): single; stdcall; external DLL_D3DX10;

function D3DXSHEvalDirectionalLight(Order: UINT; pDir: PD3DXVECTOR3; RIntensity, GIntensity, BIntensity: single;
    pROut: PSingle; pGOut: PSingle; pBOut: PSingle): HResult; stdcall; external DLL_D3DX10;

function D3DXSHEvalSphericalLight(Order: UINT; pPos: PD3DXVECTOR3; Radius: single; RIntensity, GIntensity, BIntensity: single;
    pROut: PSingle; pGOut: PSingle; pBOut: PSingle): HResult; stdcall; external DLL_D3DX10;

function D3DXSHEvalConeLight(Order: UINT; pDir: PD3DXVECTOR3; Radius: single; RIntensity, GIntensity, BIntensity: single;
    pROut: PSingle; pGOut: PSingle; pBOut: PSingle): HResult; stdcall; external DLL_D3DX10;

function D3DXSHEvalHemisphereLight(Order: UINT; pDir: PD3DXVECTOR3; Top: TD3DXCOLOR; Bottom: TD3DXCOLOR; pROut: PSingle;
    pGOut: PSingle; pBOut: PSingle): HResult; stdcall; external DLL_D3DX10;

// Math intersection functions

function D3DXIntersectTri(p0: PD3DXVECTOR3; // Triangle vertex 0 position
    p1: PD3DXVECTOR3; // Triangle vertex 1 position
    p2: PD3DXVECTOR3; // Triangle vertex 2 position
    pRayPos: PD3DXVECTOR3; // Ray origin
    pRayDir: PD3DXVECTOR3; // Ray direction
    pU: PSingle; // Barycentric Hit Coordinates
    pV: PSingle; // Barycentric Hit Coordinates
    pDist: PSingle): longbool; stdcall; external DLL_D3DX10; // Ray-Intersection Parameter Distance

function D3DXSphereBoundProbe(pCenter: PD3DXVECTOR3; Radius: single; pRayPosition: PD3DXVECTOR3; pRayDirection: PD3DXVECTOR3): longbool; stdcall;
    external DLL_D3DX10;

function D3DXBoxBoundProbe(pMin: PD3DXVECTOR3; pMax: PD3DXVECTOR3; pRayPosition: PD3DXVECTOR3; pRayDirection: PD3DXVECTOR3): longbool; stdcall;
    external DLL_D3DX10;

function D3DXComputeBoundingSphere(pFirstPosition: PD3DXVECTOR3; // pointer to first position
    NumVertices: DWORD; dwStride: DWORD; // count in bytes to subsequent position vectors
    pCenter: PD3DXVECTOR3; pRadius: PSingle): HResult; stdcall; external DLL_D3DX10;

function D3DXComputeBoundingBox(pFirstPosition: PD3DXVECTOR3; // pointer to first position
    NumVertices: DWORD; dwStride: DWORD; // count in bytes to subsequent position vectors
    pMin: PD3DXVECTOR3; pMax: PD3DXVECTOR3): HResult; stdcall; external DLL_D3DX10;

function D3DXCpuOptimizations(Enable: longbool): TD3DX_CPU_OPTIMIZATION; stdcall; external DLL_D3DX10;

function D3DXSHMultiply2(pOut: PSingle; pF: PSingle; pG: PSingle): PSingle; stdcall; external DLL_D3DX10;
function D3DXSHMultiply3(pOut: PSingle; pF: PSingle; pG: PSingle): PSingle; stdcall; external DLL_D3DX10;
function D3DXSHMultiply4(pOut: PSingle; pF: PSingle; pG: PSingle): PSingle; stdcall; external DLL_D3DX10;
function D3DXSHMultiply5(pOut: PSingle; pF: PSingle; pG: PSingle): PSingle; stdcall; external DLL_D3DX10;
function D3DXSHMultiply6(pOut: PSingle; pF: PSingle; pG: PSingle): PSingle; stdcall; external DLL_D3DX10;


{ D3DX10Core.h}
const
    IID_ID3DX10Sprite: TGUID = '{BA0B762D-8D28-43ec-B9DC-2F84443B0614}';
    IID_ID3DX10ThreadPump: TGUID = '{C93FECFA-6967-478a-ABBC-402D90621FCB}';
    IID_ID3DX10Font: TGUID = '{D79DBB70-5F21-4d36-BBC2-FF525C213CDC}';

type
    TD3DX10_SPRITE_FLAG = (
        D3DX10_SPRITE_SORT_TEXTURE = $01,
        D3DX10_SPRITE_SORT_DEPTH_BACK_TO_FRONT = $02,
        D3DX10_SPRITE_SORT_DEPTH_FRONT_TO_BACK = $04,
        D3DX10_SPRITE_SAVE_STATE = $08,
        D3DX10_SPRITE_ADDREF_TEXTURES = $10);


    TD3DX10_SPRITE = record
        matWorld: TD3DXMATRIX;
        TexCoord: TD3DXVECTOR2;
        TexSize: TD3DXVECTOR2;
        ColorModulate: TD3DXCOLOR;
        pTexture: ID3D10ShaderResourceView;
        TextureIndex: UINT;
    end;
    PD3DX10_SPRITE = ^TD3DX10_SPRITE;


    {$IFDEF FPC}
    {$interfaces corba}

    ID3DX10DataLoader = interface
        function Load(): HResult; stdcall;
        function Decompress(out ppData: pointer; out pcBytes: SIZE_T): HResult; stdcall;
        function Destroy(): HResult; stdcall;
    end;

    ID3DX10DataProcessor = interface
        function Process(pData: pointer; cBytes: SIZE_T): HResult; stdcall;
        function CreateDeviceObject(out ppDataObject: pointer): HResult; stdcall;
        function Destroy(): HResult; stdcall;
    end;

    {$interfaces com}
    {$ELSE}
    ID3DX10DataLoader = class // Cannot use 'interface'
        function Load(): HResult; virtual; stdcall; abstract;
        function Decompress(out ppData: pointer; out pcBytes: SIZE_T): HResult; virtual; stdcall; abstract;
        function Destroy(): HResult; virtual; stdcall; abstract;
    end;

    ID3DX10DataProcessor = class // Cannot use 'interface'
        function Process(pData: pointer; cBytes: SIZE_T): HResult; virtual; stdcall; abstract;
        function CreateDeviceObject(out ppDataObject: pointer): HResult; virtual; stdcall; abstract;
        function Destroy(): HResult; virtual; stdcall; abstract;
    end;

    {$ENDIF}

    ID3DX10Sprite = interface(IUnknown)
        ['{BA0B762D-8D28-43ec-B9DC-2F84443B0614}']
        function _Begin(flags: UINT): HResult; stdcall;
        function DrawSpritesBuffered(pSprites: PD3DX10_SPRITE; cSprites: UINT): HResult; stdcall;
        function Flush(): HResult; stdcall;
        function DrawSpritesImmediate(pSprites: PD3DX10_SPRITE; cSprites: UINT; cbSprite: UINT; flags: UINT): HResult; stdcall;
        function _End(): HResult; stdcall;
        function GetViewTransform(out pViewTransform: TD3DXMATRIX): HResult; stdcall;
        function SetViewTransform(pViewTransform: PD3DXMATRIX): HResult; stdcall;
        function GetProjectionTransform(out pProjectionTransform: TD3DXMATRIX): HResult; stdcall;
        function SetProjectionTransform(pProjectionTransform: PD3DXMATRIX): HResult; stdcall;
        function GetDevice(out ppDevice: ID3D10Device): HResult; stdcall;
    end;

    PID3DX10Sprite = ^ID3DX10Sprite;

    ID3DX10ThreadPump = interface(IUnknown)
        ['{C93FECFA-6967-478a-ABBC-402D90621FCB}']
        function AddWorkItem(pDataLoader: ID3DX10DataLoader; pDataProcessor: ID3DX10DataProcessor; pHResult: PHRESULT;
            out ppDeviceObject: Pointer): HResult; stdcall;
        function GetWorkItemCount(): UINT; stdcall;
        function WaitForAllItems(): HResult; stdcall;
        function ProcessDeviceWorkItems(iWorkItemCount: UINT): HResult; stdcall;
        function PurgeAllItems(): HResult; stdcall;
        function GetQueueStatus(pIoQueue: PUINT; pProcessQueue: PUINT; pDeviceQueue: PUINT): HResult; stdcall;
    end;


    TD3DX10_FONT_DESCA = record
        Height: integer;
        Width: UINT;
        Weight: UINT;
        MipLevels: UINT;
        Italic: longbool;
        CharSet: byte;
        OutputPrecision: byte;
        Quality: byte;
        PitchAndFamily: byte;
        FaceName: array [0..LF_FACESIZE - 1] of AnsiChar;
    end;
    PD3DX10_FONT_DESCA = ^TD3DX10_FONT_DESCA;


    TD3DX10_FONT_DESCW = record
        Height: integer;
        Width: UINT;
        Weight: UINT;
        MipLevels: UINT;
        Italic: longbool;
        CharSet: byte;
        OutputPrecision: byte;
        Quality: byte;
        PitchAndFamily: byte;
        FaceName: array [0..LF_FACESIZE - 1] of widechar;
    end;
    PD3DX10_FONT_DESCW = ^TD3DX10_FONT_DESCW;


    ID3DX10Font = interface(IUnknown)
        ['{D79DBB70-5F21-4d36-BBC2-FF525C213CDC}']
        function GetDevice(out ppDevice: ID3D10Device): HResult; stdcall;
        function GetDescA(pDesc: TD3DX10_FONT_DESCA): HResult; stdcall;
        function GetDescW(out pDesc: TD3DX10_FONT_DESCW): HResult; stdcall;
        function GetTextMetricsA(out pTextMetrics: TTEXTMETRICA): longbool; stdcall;
        function GetTextMetricsW(out pTextMetrics: TEXTMETRICW): longbool; stdcall;

        function GetDC(): HDC; stdcall;
        function GetGlyphData(Glyph: UINT; out ppTexture: ID3D10ShaderResourceView; out pBlackBox: TRECT; out pCellInc: TPOINT): HResult; stdcall;

        function PreloadCharacters(First: UINT; Last: UINT): HResult; stdcall;
        function PreloadGlyphs(First: UINT; Last: UINT): HResult; stdcall;
        function PreloadTextA(pString: PAnsiChar; Count: integer): HResult; stdcall;
        function PreloadTextW(pString: PWideChar; Count: integer): HResult; stdcall;

        function DrawTextA(pSprite: ID3DX10SPRITE; pString: PAnsiChar; Count: integer; pRect: PRECT; Format: UINT;
            Color: TD3DXCOLOR): integer; stdcall;
        function DrawTextW(pSprite: ID3DX10SPRITE; pString: PWideChar; Count: integer; pRect: PRECT; Format: UINT;
            Color: TD3DXCOLOR): integer; stdcall;
    end;


    { D3DX10Tex.h }

    TD3DX10_FILTER_FLAG = (
        D3DX10_FILTER_NONE = (1 shl 0),
        D3DX10_FILTER_POINT = (2 shl 0),
        D3DX10_FILTER_LINEAR = (3 shl 0),
        D3DX10_FILTER_TRIANGLE = (4 shl 0),
        D3DX10_FILTER_BOX = (5 shl 0),
        D3DX10_FILTER_MIRROR_U = (1 shl 16),
        D3DX10_FILTER_MIRROR_V = (2 shl 16),
        D3DX10_FILTER_MIRROR_W = (4 shl 16),
        D3DX10_FILTER_MIRROR = (7 shl 16),
        D3DX10_FILTER_DITHER = (1 shl 19),
        D3DX10_FILTER_DITHER_DIFFUSION = (2 shl 19),
        D3DX10_FILTER_SRGB_IN = (1 shl 21),
        D3DX10_FILTER_SRGB_OUT = (2 shl 21),
        D3DX10_FILTER_SRGB = (3 shl 21));


    TD3DX10_NORMALMAP_FLAG = (
        D3DX10_NORMALMAP_MIRROR_U = (1 shl 16),
        D3DX10_NORMALMAP_MIRROR_V = (2 shl 16),
        D3DX10_NORMALMAP_MIRROR = (3 shl 16),
        D3DX10_NORMALMAP_INVERTSIGN = (8 shl 16),
        D3DX10_NORMALMAP_COMPUTE_OCCLUSION = (16 shl 16));


    TD3DX10_CHANNEL_FLAG = (
        D3DX10_CHANNEL_RED = (1 shl 0),
        D3DX10_CHANNEL_BLUE = (1 shl 1),
        D3DX10_CHANNEL_GREEN = (1 shl 2),
        D3DX10_CHANNEL_ALPHA = (1 shl 3),
        D3DX10_CHANNEL_LUMINANCE = (1 shl 4));

    TD3DX10_IMAGE_FILE_FORMAT = (
        D3DX10_IFF_BMP = 0,
        D3DX10_IFF_JPG = 1,
        D3DX10_IFF_PNG = 3,
        D3DX10_IFF_DDS = 4,
        D3DX10_IFF_TIFF = 10,
        D3DX10_IFF_GIF = 11,
        D3DX10_IFF_WMP = 12,
        D3DX10_IFF_FORCE_DWORD = $7fffffff
        );


    TD3DX10_SAVE_TEXTURE_FLAG = (
        D3DX10_STF_USEINPUTBLOB = $0001);


    TD3DX10_IMAGE_INFO = record
        Width: UINT;
        Height: UINT;
        Depth: UINT;
        ArraySize: UINT;
        MipLevels: UINT;
        MiscFlags: UINT;
        Format: TDXGI_FORMAT;
        ResourceDimension: TD3D10_RESOURCE_DIMENSION;
        ImageFileFormat: TD3DX10_IMAGE_FILE_FORMAT;
    end;
    PD3DX10_IMAGE_INFO = ^TD3DX10_IMAGE_INFO;

    { TD3DX10_IMAGE_LOAD_INFO }

    TD3DX10_IMAGE_LOAD_INFO = record
        Width: UINT;
        Height: UINT;
        Depth: UINT;
        FirstMipLevel: UINT;
        MipLevels: UINT;
        Usage: TD3D10_USAGE;
        BindFlags: UINT;
        CpuAccessFlags: UINT;
        MiscFlags: UINT;
        Format: TDXGI_FORMAT;
        Filter: UINT;
        MipFilter: UINT;
        pSrcInfo: PD3DX10_IMAGE_INFO;
        procedure Init;
    end;
    PD3DX10_IMAGE_LOAD_INFO = ^TD3DX10_IMAGE_LOAD_INFO;

    { TD3DX10_TEXTURE_LOAD_INFO }

    TD3DX10_TEXTURE_LOAD_INFO = record
        pSrcBox: pD3D10_BOX;
        pDstBox: PD3D10_BOX;
        SrcFirstMip: UINT;
        DstFirstMip: UINT;
        NumMips: UINT;
        SrcFirstElement: UINT;
        DstFirstElement: UINT;
        NumElements: UINT;
        Filter: UINT;
        MipFilter: UINT;
        procedure Init;
    end;
    PD3DX10_TEXTURE_LOAD_INFO = ^TD3DX10_TEXTURE_LOAD_INFO;


    {D3DX10Mesh.h}

    // Mesh options - lower 3 bytes only, upper byte used by _D3DX10MESHOPT option flags
    TD3DX10_MESH = (
        D3DX10_MESH_32_BIT = $001, // If set, then use 32 bit indices, if not set use 16 bit indices.
        D3DX10_MESH_GS_ADJACENCY = $004 // If set, mesh contains GS adjacency info. Not valid on input.

        );

    TD3DX10_ATTRIBUTE_RANGE = record
        AttribId: UINT;
        FaceStart: UINT;
        FaceCount: UINT;
        VertexStart: UINT;
        VertexCount: UINT;
    end;

    PD3DX10_ATTRIBUTE_RANGE = ^TD3DX10_ATTRIBUTE_RANGE;


    TD3DX10_MESH_DISCARD_FLAGS = (
        D3DX10_MESH_DISCARD_ATTRIBUTE_BUFFER = $01,
        D3DX10_MESH_DISCARD_ATTRIBUTE_TABLE = $02,
        D3DX10_MESH_DISCARD_POINTREPS = $04,
        D3DX10_MESH_DISCARD_ADJACENCY = $08,
        D3DX10_MESH_DISCARD_DEVICE_BUFFERS = $10);

    TD3DX10_WELD_EPSILONS = record
        Position: single;                 // NOTE: This does NOT replace the epsilon in GenerateAdjacency
        // in general, it should be the same value or greater than the one passed to GeneratedAdjacency
        BlendWeights: single;
        Normal: single;
        PSize: single;
        Specular: single;
        Diffuse: single;
        Texcoord: array [0..7] of single;
        Tangent: single;
        Binormal: single;
        TessFactor: single;
    end;

    PD3DX10_WELD_EPSILONS = ^TD3DX10_WELD_EPSILONS;

    TD3DX10_INTERSECT_INFO = record
        FaceIndex: UINT;                // index of face intersected
        U: single;                        // Barycentric Hit Coordinates
        V: single;                        // Barycentric Hit Coordinates
        Dist: single;                     // Ray-Intersection Parameter Distance
    end;

    PD3DX10_INTERSECT_INFO = TD3DX10_INTERSECT_INFO;

    // ID3DX10Mesh::Optimize options - upper byte only, lower 3 bytes used from _D3DX10MESH option flags
    TD3DX10_MESHOPT = (
        D3DX10_MESHOPT_COMPACT = $01000000,
        D3DX10_MESHOPT_ATTR_SORT = $02000000,
        D3DX10_MESHOPT_VERTEX_CACHE = $04000000,
        D3DX10_MESHOPT_STRIP_REORDER = $08000000,
        D3DX10_MESHOPT_IGNORE_VERTS = $10000000,  // optimize faces only, don't touch vertices
        D3DX10_MESHOPT_DO_NOT_SPLIT = $20000000,  // do not split vertices shared between attribute groups when attribute sorting
        D3DX10_MESHOPT_DEVICE_INDEPENDENT = $00400000  // Only affects VCache.  uses a static known good cache size for all cards

        // D3DX10_MESHOPT_SHAREVB has been removed, please use D3DX10MESH_VB_SHARE instead

        );

    TD3DX10_SKINNING_CHANNEL = record
        SrcOffset: UINT;
        DestOffset: UINT;
        IsNormal: longbool;
    end;

    PD3DX10_SKINNING_CHANNEL = ^TD3DX10_SKINNING_CHANNEL;


    TD3DX10_ATTRIBUTE_WEIGHTS = record
        Position: single;
        Boundary: single;
        Normal: single;
        Diffuse: single;
        Specular: single;
        Texcoord: array [0..7] of single;
        Tangent: single;
        Binormal: single;
    end;
    PD3DX10_ATTRIBUTE_WEIGHTS = ^TD3DX10_ATTRIBUTE_WEIGHTS;

    // ID3DX10MeshBuffer is used by D3DX10Mesh vertex and index buffers


    ID3DX10MeshBuffer = interface(IUnknown)
        ['{04B0D117-1041-46b1-AA8A-3952848BA22E}']
        function Map(out ppData: Pointer; out pSize: SIZE_T): HResult; stdcall;
        function Unmap(): HResult; stdcall;
        function GetSize(): SIZE_T; stdcall;
    end;


    ID3DX10Mesh = interface(IUnknown)
        ['{4020E5C2-1403-4929-883F-E2E849FAC195}']
        function GetFaceCount(): UINT; stdcall;
        function GetVertexCount(): UINT; stdcall;
        function GetVertexBufferCount(): UINT; stdcall;
        function GetFlags(): UINT; stdcall;
        function GetVertexDescription(out ppDesc: PD3D10_INPUT_ELEMENT_DESC; pDeclCount: PUINT): HResult; stdcall;

        function SetVertexData(iBuffer: UINT; pData: pointer): HResult; stdcall;
        function GetVertexBuffer(iBuffer: UINT; out ppVertexBuffer: ID3DX10MeshBuffer): HResult; stdcall;

        function SetIndexData(pData: pointer; cIndices: UINT): HResult; stdcall;
        function GetIndexBuffer(out ppIndexBuffer: ID3DX10MeshBuffer): HResult; stdcall;

        function SetAttributeData(pData: PUINT): HResult; stdcall;
        function GetAttributeBuffer(out ppAttributeBuffer: ID3DX10MeshBuffer): HResult; stdcall;

        function SetAttributeTable(pAttribTable: PD3DX10_ATTRIBUTE_RANGE; cAttribTableSize: UINT): HResult; stdcall;
        function GetAttributeTable(pAttribTable: PD3DX10_ATTRIBUTE_RANGE; pAttribTableSize: PUINT): HResult; stdcall;

        function GenerateAdjacencyAndPointReps(Epsilon: single): HResult; stdcall;
        function GenerateGSAdjacency(): HResult; stdcall;

        function SetAdjacencyData(pAdjacency: PUINT): HResult; stdcall;
        function GetAdjacencyBuffer(out ppAdjacency: ID3DX10MeshBuffer): HResult; stdcall;

        function SetPointRepData(pPointReps: PUINT): HResult; stdcall;
        function GetPointRepBuffer(out ppPointReps: ID3DX10MeshBuffer): HResult; stdcall;

        function Discard(dwDiscard: TD3DX10_MESH_DISCARD_FLAGS): HResult; stdcall;
        function CloneMesh(Flags: UINT; pPosSemantic: PAnsiChar; pDesc: PD3D10_INPUT_ELEMENT_DESC; DeclCount: UINT;
            out ppCloneMesh: ID3DX10Mesh): HResult; stdcall;

        function Optimize(Flags: UINT; pFaceRemap: PUINT; out ppVertexRemap: PID3D10BLOB): HResult; stdcall;
        function GenerateAttributeBufferFromTable(): HResult; stdcall;

        function Intersect(pRayPos: PD3DXVECTOR3; pRayDir: PD3DXVECTOR3; pHitCount: PUINT; pFaceIndex: PUINT;
            pU: PSingle; pV: PSingle; pDist: PSingle; out ppAllHits: ID3D10Blob): HResult; stdcall;
        function IntersectSubset(AttribId: UINT; pRayPos: PD3DXVECTOR3; pRayDir: PD3DXVECTOR3; pHitCount: PUINT;
            pFaceIndex: PUINT; pU: PSingle; pV: PSingle; pDist: PSingle; out ppAllHits: ID3D10Blob): HResult; stdcall;

        // ID3DX10Mesh - Device functions
        function CommitToDevice(): HResult; stdcall;
        function DrawSubset(AttribId: UINT): HResult; stdcall;
        function DrawSubsetInstanced(AttribId: UINT; InstanceCount: UINT; StartInstanceLocation: UINT): HResult; stdcall;

        function GetDeviceVertexBuffer(iBuffer: UINT; out ppVertexBuffer: ID3D10Buffer): HResult; stdcall;
        function GetDeviceIndexBuffer(out ppIndexBuffer: ID3D10Buffer): HResult; stdcall;
    end;


    ID3DX10SkinInfo = interface(IUnknown)
        ['{420BD604-1C76-4a34-A466-E45D0658A32C}']
        function GetNumVertices(): UINT; stdcall;
        function GetNumBones(): UINT; stdcall;
        function GetMaxBoneInfluences(): UINT; stdcall;

        function AddVertices(Count: UINT): HResult; stdcall;
        function RemapVertices(NewVertexCount: UINT; pVertexRemap: PUINT): HResult; stdcall;

        function AddBones(Count: UINT): HResult; stdcall;
        function RemoveBone(Index: UINT): HResult; stdcall;
        function RemapBones(NewBoneCount: UINT; pBoneRemap: PUINT): HResult; stdcall;

        function AddBoneInfluences(BoneIndex: UINT; InfluenceCount: UINT; pIndices: UINT; pWeights: PSingle): HResult; stdcall;
        function ClearBoneInfluences(BoneIndex: UINT): HResult; stdcall;
        function GetBoneInfluenceCount(BoneIndex: UINT): UINT; stdcall;
        function GetBoneInfluences(BoneIndex: UINT; Offset: UINT; Count: UINT; pDestIndices: PUINT;
            pDestWeights: PSingle): HResult; stdcall;
        function FindBoneInfluenceIndex(BoneIndex: UINT; VertexIndex: UINT; pInfluenceIndex: PUINT): HResult; stdcall;
        function SetBoneInfluence(BoneIndex: UINT; InfluenceIndex: UINT; Weight: single): HResult; stdcall;
        function GetBoneInfluence(BoneIndex: UINT; InfluenceIndex: UINT; pWeight: PSingle): HResult; stdcall;

        function Compact(MaxPerVertexInfluences: UINT; ScaleMode: UINT; MinWeight: single): HResult; stdcall;
        function DoSoftwareSkinning(StartVertex: UINT; VertexCount: UINT; pSrcVertices: Pointer; SrcStride: UINT;
            pDestVertices: Pointer; DestStride: UINT; pBoneMatrices: PD3DXMATRIX; pInverseTransposeBoneMatrices: PD3DXMATRIX;
            pChannelDescs: PD3DX10_SKINNING_CHANNEL; NumChannels: UINT): HResult; stdcall;
    end;


function D3DX10CreateFontA(pDevice: ID3D10Device; Height: integer; Width: UINT; Weight: UINT; MipLevels: UINT;
    Italic: longbool; CharSet: UINT; OutputPrecision: UINT; Quality: UINT; PitchAndFamily: UINT; pFaceName: PAnsiChar;
    out ppFont: ID3DX10FONT): HResult; stdcall; external DLL_D3DX10;

function D3DX10CreateFontW(pDevice: ID3D10Device; Height: integer; Width: UINT; Weight: UINT; MipLevels: UINT;
    Italic: longbool; CharSet: UINT; OutputPrecision: UINT; Quality: UINT; PitchAndFamily: UINT; pFaceName: PWideChar;
    out ppFont: ID3DX10FONT): HResult; stdcall; external DLL_D3DX10;


function D3DX10CreateFontIndirectA(pDevice: ID3D10Device; pDesc: PD3DX10_FONT_DESCA; out ppFont: ID3DX10FONT): HResult;
    stdcall; external DLL_D3DX10;

function D3DX10CreateFontIndirectW(pDevice: ID3D10Device; pDesc: PD3DX10_FONT_DESCW; out ppFont: ID3DX10FONT): HResult;
    stdcall; external DLL_D3DX10;


function D3DX10UnsetAllDeviceObjects(pDevice: ID3D10Device): HResult; stdcall; external DLL_D3DX10;


function D3DX10CreateSprite(pDevice: ID3D10Device; cDeviceBufferSize: UINT; out ppSprite: ID3DX10Sprite): HResult; stdcall; external DLL_D3DX10;
function D3DX10CreateThreadPump(cIoThreads: UINT; cProcThreads: UINT; out ppThreadPump: ID3DX10ThreadPump): HResult; stdcall; external DLL_D3DX10;


function D3DX10CreateDevice(pAdapter: IDXGIAdapter; DriverType: TD3D10_DRIVER_TYPE; Software: HMODULE; Flags: UINT;
    out ppDevice: ID3D10Device): HResult; stdcall; external DLL_D3DX10;

function D3DX10CreateDeviceAndSwapChain(pAdapter: IDXGIAdapter; DriverType: TD3D10_DRIVER_TYPE; Software: HMODULE;
    Flags: UINT; pSwapChainDesc: PDXGI_SWAP_CHAIN_DESC; out ppSwapChain: IDXGISwapChain; out ppDevice: ID3D10Device): HResult;
    stdcall; external DLL_D3DX10;


{ D3DX10Asycn.h}

function D3DX10CompileFromFileA(pSrcFile: pAnsiChar; pDefines: PD3D10_SHADER_MACRO; pInclude: PID3D10INCLUDE;
    pFunctionName: pAnsiChar; pProfile: pAnsiChar; Flags1: UINT; Flags2: UINT; pPump: ID3DX10ThreadPump;
    out ppShader: ID3D10Blob; out ppErrorMsgs: ID3D10Blob; out pHResult: HRESULT): HRESULT; stdcall; external DLL_D3DX10;

function D3DX10CompileFromFileW(pSrcFile: PWideChar; pDefines: PD3D10_SHADER_MACRO; pInclude: PID3D10INCLUDE;
    pFunctionName: pAnsiChar; pProfile: pAnsiChar; Flags1: UINT; Flags2: UINT; pPump: ID3DX10ThreadPump;
    out ppShader: ID3D10Blob; out ppErrorMsgs: ID3D10Blob; out pHResult: HRESULT): HRESULT; stdcall; external DLL_D3DX10;


function D3DX10CompileFromResourceA(hSrcModule: HMODULE; pSrcResource: pAnsiChar; pSrcFileName: pAnsiChar;
    pDefines: PD3D10_SHADER_MACRO; pInclude: PID3D10INCLUDE; pFunctionName: pAnsiChar; pProfile: pAnsiChar;
    Flags1: UINT; Flags2: UINT; pPump: ID3DX10ThreadPump; out ppShader: ID3D10Blob; out ppErrorMsgs: ID3D10Blob;
    out pHResult: HRESULT): HRESULT; stdcall; external DLL_D3DX10;

function D3DX10CompileFromResourceW(hSrcModule: HMODULE; pSrcResource: PWideChar; pSrcFileName: PWideChar;
    pDefines: PD3D10_SHADER_MACRO; pInclude: PID3D10INCLUDE; pFunctionName: pAnsiChar; pProfile: pAnsiChar;
    Flags1: UINT; Flags2: UINT; pPump: ID3DX10ThreadPump; out ppShader: ID3D10Blob; out ppErrorMsgs: ID3D10Blob;
    out pHResult: HRESULT): HRESULT; stdcall; external DLL_D3DX10;


function D3DX10CompileFromMemory(pSrcData: pAnsiChar; SrcDataLen: SIZE_T; pFileName: pAnsiChar; pDefines: PD3D10_SHADER_MACRO;
    pInclude: PID3D10INCLUDE; pFunctionName: pAnsiChar; pProfile: pAnsiChar; Flags1: UINT; Flags2: UINT;
    pPump: ID3DX10ThreadPump; out ppShader: ID3D10Blob; out ppErrorMsgs: ID3D10Blob; out pHResult: HRESULT): HRESULT;
    stdcall; external DLL_D3DX10;


function D3DX10CreateEffectFromFileA(pFileName: pAnsiChar; pDefines: PD3D10_SHADER_MACRO; pInclude: ID3D10Include;
    pProfile: pAnsiChar; HLSLFlags: UINT; FXFlags: UINT; pDevice: ID3D10Device; pEffectPool: ID3D10EffectPool;
    pPump: ID3DX10ThreadPump; out ppEffect: ID3D10Effect; out ppErrors: ID3D10Blob; out pHResult: HRESULT): HRESULT; stdcall; external DLL_D3DX10;

function D3DX10CreateEffectFromFileW(pFileName: PWideChar; pDefines: PD3D10_SHADER_MACRO; pInclude: ID3D10Include;
    pProfile: pAnsiChar; HLSLFlags: UINT; FXFlags: UINT; pDevice: ID3D10Device; pEffectPool: ID3D10EffectPool;
    pPump: ID3DX10ThreadPump; out ppEffect: ID3D10Effect; out ppErrors: ID3D10Blob; out pHResult: HRESULT): HRESULT; stdcall; external DLL_D3DX10;

function D3DX10CreateEffectFromMemory(pData: Pointer; DataLength: SIZE_T; pSrcFileName: pAnsiChar; pDefines: PD3D10_SHADER_MACRO;
    pInclude: ID3D10Include; pProfile: pAnsiChar; HLSLFlags: UINT; FXFlags: UINT; pDevice: ID3D10Device;
    pEffectPool: ID3D10EffectPool; pPump: ID3DX10ThreadPump; out ppEffect: ID3D10Effect; out ppErrors: ID3D10Blob;
    out pHResult: HRESULT): HRESULT; stdcall; external DLL_D3DX10;

function D3DX10CreateEffectFromResourceA(hModule: HMODULE; pResourceName: pAnsiChar; pSrcFileName: pAnsiChar;
    pDefines: PD3D10_SHADER_MACRO; pInclude: ID3D10Include; pProfile: pAnsiChar; HLSLFlags: UINT; FXFlags: UINT;
    pDevice: ID3D10Device; pEffectPool: ID3D10EffectPool; pPump: ID3DX10ThreadPump; out ppEffect: ID3D10Effect;
    out ppErrors: ID3D10Blob; out pHResult: HRESULT): HRESULT; stdcall; external DLL_D3DX10;

function D3DX10CreateEffectFromResourceW(hModule: HMODULE; pResourceName: PWideChar; pSrcFileName: PWideChar;
    pDefines: PD3D10_SHADER_MACRO; pInclude: ID3D10Include; pProfile: pAnsiChar; HLSLFlags: UINT; FXFlags: UINT;
    pDevice: ID3D10Device; pEffectPool: ID3D10EffectPool; pPump: ID3DX10ThreadPump; out ppEffect: ID3D10Effect;
    out ppErrors: ID3D10Blob; out pHResult: HRESULT): HRESULT; stdcall; external DLL_D3DX10;


function D3DX10CreateEffectPoolFromFileA(pFileName: pAnsiChar; pDefines: PD3D10_SHADER_MACRO; pInclude: ID3D10Include;
    pProfile: pAnsiChar; HLSLFlags: UINT; FXFlags: UINT; pDevice: ID3D10Device; pPump: ID3DX10ThreadPump;
    out ppEffectPool: ID3D10EffectPool; out ppErrors: ID3D10Blob; out pHResult: HRESULT): HRESULT; stdcall; external DLL_D3DX10;

function D3DX10CreateEffectPoolFromFileW(pFileName: pWideChar; pDefines: PD3D10_SHADER_MACRO; pInclude: ID3D10Include;
    pProfile: pAnsiChar; HLSLFlags: UINT; FXFlags: UINT; pDevice: ID3D10Device; pPump: ID3DX10ThreadPump;
    out ppEffectPool: ID3D10EffectPool; out ppErrors: ID3D10Blob; out pHResult: HRESULT): HRESULT; stdcall; external DLL_D3DX10;

function D3DX10CreateEffectPoolFromMemory(pData: Pointer; DataLength: SIZE_T; pSrcFileName: pAnsiChar;
    pDefines: PD3D10_SHADER_MACRO; pInclude: ID3D10Include; pProfile: pAnsiChar; HLSLFlags: UINT; FXFlags: UINT;
    pDevice: ID3D10Device; pPump: ID3DX10ThreadPump; out ppEffectPool: ID3D10EffectPool; out ppErrors: ID3D10Blob;
    out pHResult: HRESULT): HRESULT; stdcall; external DLL_D3DX10;

function D3DX10CreateEffectPoolFromResourceA(hModule: HMODULE; pResourceName: pAnsiChar; pSrcFileName: pAnsiChar;
    pDefines: PD3D10_SHADER_MACRO; pInclude: ID3D10Include; pProfile: pAnsiChar; HLSLFlags: UINT; FXFlags: UINT;
    pDevice: ID3D10Device; pPump: ID3DX10ThreadPump; out ppEffectPool: ID3D10EffectPool; out ppErrors: ID3D10Blob;
    out pHResult: HRESULT): HRESULT; stdcall; external DLL_D3DX10;

function D3DX10CreateEffectPoolFromResourceW(hModule: HMODULE; pResourceName: pWideChar; pSrcFileName: pWideChar;
    pDefines: PD3D10_SHADER_MACRO; pInclude: ID3D10Include; pProfile: pAnsiChar; HLSLFlags: UINT; FXFlags: UINT;
    pDevice: ID3D10Device; pPump: ID3DX10ThreadPump; out ppEffectPool: ID3D10EffectPool; out ppErrors: ID3D10Blob;
    out pHResult: HRESULT): HRESULT; stdcall; external DLL_D3DX10;


function D3DX10PreprocessShaderFromFileA(pFileName: pAnsiChar; pDefines: PD3D10_SHADER_MACRO; pInclude: PID3D10INCLUDE;
    pPump: ID3DX10ThreadPump; out ppShaderText: ID3D10Blob; out ppErrorMsgs: ID3D10Blob; out pHResult: HRESULT): HRESULT;
    stdcall; external DLL_D3DX10;

function D3DX10PreprocessShaderFromFileW(pFileName: pWideChar; pDefines: PD3D10_SHADER_MACRO; pInclude: PID3D10INCLUDE;
    pPump: ID3DX10ThreadPump; out ppShaderText: ID3D10Blob; out ppErrorMsgs: ID3D10Blob; out pHResult: HRESULT): HRESULT;
    stdcall; external DLL_D3DX10;

function D3DX10PreprocessShaderFromMemory(pSrcData: pAnsiChar; SrcDataSize: SIZE_T; pFileName: pAnsiChar;
    pDefines: PD3D10_SHADER_MACRO; pInclude: PID3D10INCLUDE; pPump: ID3DX10ThreadPump; out ppShaderText: ID3D10Blob;
    out ppErrorMsgs: ID3D10Blob; out pHResult: HRESULT): HRESULT; stdcall; external DLL_D3DX10;

function D3DX10PreprocessShaderFromResourceA(hModule: HMODULE; pResourceName: pAnsiChar; pSrcFileName: pAnsiChar;
    pDefines: PD3D10_SHADER_MACRO; pInclude: PID3D10INCLUDE; pPump: ID3DX10ThreadPump; out ppShaderText: ID3D10Blob;
    out ppErrorMsgs: ID3D10Blob; out pHResult: HRESULT): HRESULT; stdcall; external DLL_D3DX10;

function D3DX10PreprocessShaderFromResourceW(hModule: HMODULE; pResourceName: pWideChar; pSrcFileName: pWideChar;
    pDefines: PD3D10_SHADER_MACRO; pInclude: PID3D10INCLUDE; pPump: ID3DX10ThreadPump; out ppShaderText: ID3D10Blob;
    out ppErrorMsgs: ID3D10Blob; out pHResult: HRESULT): HRESULT; stdcall; external DLL_D3DX10;


function D3DX10CreateAsyncCompilerProcessor(pFileName: pAnsiChar; pDefines: PD3D10_SHADER_MACRO; pInclude: PID3D10INCLUDE;
    pFunctionName: pAnsiChar; pProfile: pAnsiChar; Flags1: UINT; Flags2: UINT; out ppCompiledShader: ID3D10Blob;
    out ppErrorBuffer: ID3D10Blob; out ppProcessor: ID3DX10DataProcessor): HRESULT;
    stdcall; external DLL_D3DX10;

function D3DX10CreateAsyncEffectCreateProcessor(pFileName: pAnsiChar; pDefines: PD3D10_SHADER_MACRO; pInclude: PID3D10INCLUDE;
    pProfile: pAnsiChar; Flags: UINT; FXFlags: UINT; pDevice: ID3D10Device; pPool: ID3D10EffectPool;
    out ppErrorBuffer: ID3D10Blob; out ppProcessor: ID3DX10DataProcessor): HRESULT; stdcall; external DLL_D3DX10;

function D3DX10CreateAsyncEffectPoolCreateProcessor(pFileName: pAnsiChar; pDefines: PD3D10_SHADER_MACRO;
    pInclude: PID3D10INCLUDE; pProfile: pAnsiChar; Flags: UINT; FXFlags: UINT; pDevice: ID3D10Device;
    out ppErrorBuffer: ID3D10Blob; out ppProcessor: ID3DX10DataProcessor): HRESULT; stdcall; external DLL_D3DX10;

function D3DX10CreateAsyncShaderPreprocessProcessor(pFileName: pAnsiChar; pDefines: PD3D10_SHADER_MACRO;
    pInclude: PID3D10INCLUDE; out ppShaderText: ID3D10Blob; out ppErrorBuffer: ID3D10Blob; out ppProcessor: ID3DX10DataProcessor): HRESULT;
    stdcall; external DLL_D3DX10;


function D3DX10CreateAsyncFileLoaderW(pFileName: pWideChar; out ppDataLoader: ID3DX10DataLoader): HRESULT; stdcall; external DLL_D3DX10;
function D3DX10CreateAsyncFileLoaderA(pFileName: pAnsiChar; out ppDataLoader: ID3DX10DataLoader): HRESULT; stdcall; external DLL_D3DX10;
function D3DX10CreateAsyncMemoryLoader(pData: Pointer; cbData: SIZE_T; out ppDataLoader: ID3DX10DataLoader): HRESULT; stdcall; external DLL_D3DX10;
function D3DX10CreateAsyncResourceLoaderW(hSrcModule: HMODULE; pSrcResource: pWideChar; out ppDataLoader: ID3DX10DataLoader): HRESULT;
    stdcall; external DLL_D3DX10;
function D3DX10CreateAsyncResourceLoaderA(hSrcModule: HMODULE; pSrcResource: pAnsiChar; out ppDataLoader: ID3DX10DataLoader): HRESULT;
    stdcall; external DLL_D3DX10;


function D3DX10CreateAsyncTextureProcessor(pDevice: ID3D10Device; pLoadInfo: PD3DX10_IMAGE_LOAD_INFO;
    out ppDataProcessor: ID3DX10DataProcessor): HRESULT; stdcall; external DLL_D3DX10;
function D3DX10CreateAsyncTextureInfoProcessor(pImageInfo: PD3DX10_IMAGE_INFO; out ppDataProcessor: ID3DX10DataProcessor): HRESULT;
    stdcall; external DLL_D3DX10;
function D3DX10CreateAsyncShaderResourceViewProcessor(pDevice: ID3D10Device; pLoadInfo: PD3DX10_IMAGE_LOAD_INFO;
    out ppDataProcessor: ID3DX10DataProcessor): HRESULT; stdcall; external DLL_D3DX10;


function D3DX10GetImageInfoFromFileA(pSrcFile: PAnsiChar; pPump: ID3DX10ThreadPump; pSrcInfo: PD3DX10_IMAGE_INFO;
    out pHResult: HRESULT): HResult; stdcall; external DLL_D3DX10;

function D3DX10GetImageInfoFromFileW(pSrcFile: PWideChar; pPump: ID3DX10ThreadPump; pSrcInfo: PD3DX10_IMAGE_INFO;
    out pHResult: HRESULT): HResult; stdcall; external DLL_D3DX10;


function D3DX10GetImageInfoFromResourceA(hSrcModule: HMODULE; pSrcResource: PAnsiChar; pPump: ID3DX10ThreadPump;
    pSrcInfo: PD3DX10_IMAGE_INFO; out pHResult: HRESULT): HResult; stdcall; external DLL_D3DX10;

function D3DX10GetImageInfoFromResourceW(hSrcModule: HMODULE; pSrcResource: PWideChar; pPump: ID3DX10ThreadPump;
    pSrcInfo: PD3DX10_IMAGE_INFO; out pHResult: HRESULT): HResult; stdcall; external DLL_D3DX10;


function D3DX10GetImageInfoFromMemory(pSrcData: pointer; SrcDataSize: SIZE_T; pPump: ID3DX10ThreadPump;
    pSrcInfo: PD3DX10_IMAGE_INFO; out pHResult: HRESULT): HResult; stdcall; external DLL_D3DX10;


function D3DX10CreateShaderResourceViewFromFileA(pDevice: ID3D10Device; pSrcFile: PAnsiChar; pLoadInfo: PD3DX10_IMAGE_LOAD_INFO;
    pPump: ID3DX10ThreadPump; out ppShaderResourceView: ID3D10ShaderResourceView; out pHResult: HRESULT): HResult; stdcall; external DLL_D3DX10;

function D3DX10CreateShaderResourceViewFromFileW(pDevice: ID3D10Device; pSrcFile: PWideChar; pLoadInfo: PD3DX10_IMAGE_LOAD_INFO;
    pPump: ID3DX10ThreadPump; out ppShaderResourceView: ID3D10ShaderResourceView; out pHResult: HRESULT): HResult; stdcall; external DLL_D3DX10;


function D3DX10CreateTextureFromFileA(pDevice: ID3D10Device; pSrcFile: PAnsiChar; pLoadInfo: PD3DX10_IMAGE_LOAD_INFO;
    pPump: ID3DX10ThreadPump; out ppTexture: ID3D10Resource; out pHResult: HRESULT): HResult; stdcall; external DLL_D3DX10;

function D3DX10CreateTextureFromFileW(pDevice: ID3D10Device; pSrcFile: PWideChar; pLoadInfo: PD3DX10_IMAGE_LOAD_INFO;
    pPump: ID3DX10ThreadPump; out ppTexture: ID3D10Resource; out pHResult: HRESULT): HResult; stdcall; external DLL_D3DX10;


// FromResource (resources in dll/exes)

function D3DX10CreateShaderResourceViewFromResourceA(pDevice: ID3D10Device; hSrcModule: HMODULE; pSrcResource: PAnsiChar;
    pLoadInfo: PD3DX10_IMAGE_LOAD_INFO; pPump: ID3DX10ThreadPump; out ppShaderResourceView: ID3D10ShaderResourceView;
    out pHResult: HRESULT): HResult;
    stdcall; external DLL_D3DX10;

function D3DX10CreateShaderResourceViewFromResourceW(pDevice: ID3D10Device; hSrcModule: HMODULE; pSrcResource: PWideChar;
    pLoadInfo: PD3DX10_IMAGE_LOAD_INFO; pPump: ID3DX10ThreadPump; out ppShaderResourceView: ID3D10ShaderResourceView;
    out pHResult: HRESULT): HResult;
    stdcall; external DLL_D3DX10;


function D3DX10CreateTextureFromResourceA(pDevice: ID3D10Device; hSrcModule: HMODULE; pSrcResource: PAnsiChar;
    pLoadInfo: PD3DX10_IMAGE_LOAD_INFO; pPump: ID3DX10ThreadPump; out ppTexture: ID3D10Resource; out pHResult: HRESULT): HResult;
    stdcall; external DLL_D3DX10;

function D3DX10CreateTextureFromResourceW(pDevice: ID3D10Device; hSrcModule: HMODULE; pSrcResource: PWideChar;
    pLoadInfo: PD3DX10_IMAGE_LOAD_INFO; pPump: ID3DX10ThreadPump; out ppTexture: ID3D10Resource; out pHResult: HRESULT): HResult;
    stdcall; external DLL_D3DX10;


// FromFileInMemory

function D3DX10CreateShaderResourceViewFromMemory(pDevice: ID3D10Device; pSrcData: pointer; SrcDataSize: SIZE_T;
    pLoadInfo: PD3DX10_IMAGE_LOAD_INFO; pPump: ID3DX10ThreadPump; out ppShaderResourceView: ID3D10ShaderResourceView;
    out pHResult: HRESULT): HResult;
    stdcall; external DLL_D3DX10;

function D3DX10CreateTextureFromMemory(pDevice: ID3D10Device; pSrcData: pointer; SrcDataSize: SIZE_T;
    pLoadInfo: PD3DX10_IMAGE_LOAD_INFO; pPump: ID3DX10ThreadPump; out ppTexture: ID3D10Resource; out pHResult: HRESULT): HResult;
    stdcall; external DLL_D3DX10;


function D3DX10LoadTextureFromTexture(pSrcTexture: ID3D10Resource; pLoadInfo: PD3DX10_TEXTURE_LOAD_INFO; pDstTexture: ID3D10Resource): HResult;
    stdcall; external DLL_D3DX10;


function D3DX10FilterTexture(pTexture: ID3D10Resource; SrcLevel: UINT; MipFilter: UINT): HResult; stdcall; external DLL_D3DX10;


function D3DX10SaveTextureToFileA(pSrcTexture: ID3D10Resource; DestFormat: TD3DX10_IMAGE_FILE_FORMAT; pDestFile: PAnsiChar): HResult;
    stdcall; external DLL_D3DX10;

function D3DX10SaveTextureToFileW(pSrcTexture: ID3D10Resource; DestFormat: TD3DX10_IMAGE_FILE_FORMAT; pDestFile: PWideChar): HResult;
    stdcall; external DLL_D3DX10;


function D3DX10SaveTextureToMemory(pSrcTexture: ID3D10Resource; DestFormat: TD3DX10_IMAGE_FILE_FORMAT;
    ppDestBuf: PID3D10BLOB; Flags: UINT): HResult; stdcall; external DLL_D3DX10;


function D3DX10ComputeNormalMap(pSrcTexture: ID3D10Texture2D; Flags: UINT; Channel: UINT; Amplitude: single;
    pDestTexture: ID3D10Texture2D): HResult; stdcall; external DLL_D3DX10;


function D3DX10SHProjectCubeMap(Order: UINT; pCubeMap: ID3D10Texture2D; out pROut: PSingle; out pGOut: PSingle;
    out pBOut: PSingle): HResult; stdcall; external DLL_D3DX10;


function D3DX10CreateMesh(pDevice: ID3D10Device; pDeclaration: PD3D10_INPUT_ELEMENT_DESC; DeclCount: UINT;
    pPositionSemantic: PAnsiChar; VertexCount: UINT; FaceCount: UINT; Options: UINT; out ppMesh: ID3DX10Mesh): HResult; stdcall; external DLL_D3DX10;


function D3DX10CreateSkinInfo(out ppSkinInfo: ID3DX10SKININFO): HResult; stdcall; external DLL_D3DX10;

{ D3D10_1 functions }
function D3DX10GetFeatureLevel1(pDevice: ID3D10Device; out ppDevice1: ID3D10Device1): HResult; stdcall; external DLL_D3DX10;
function D3DX10DebugMute(Mute: longbool): longbool; stdcall; external DLL_D3DX10_DIAG;
function D3DX10CheckVersion(D3DSdkVersion: UINT; D3DX10SdkVersion: UINT): HResult; stdcall; external DLL_D3DX10;


function D3DXToRadian(degree: single): single;
function D3DXToDegree(radian: single): single;

implementation



function D3DXToRadian(degree: single): single;
begin
    Result := (degree * (D3DX_PI / 180.0));
end;



function D3DXToDegree(radian: single): single;
begin
    Result := (radian * (180.0 / D3DX_PI));
end;

{ TD3DX10_TEXTURE_LOAD_INFO }

procedure TD3DX10_TEXTURE_LOAD_INFO.Init;
begin
    pSrcBox := nil;
    pDstBox := nil;
    SrcFirstMip := 0;
    DstFirstMip := 0;
    NumMips := D3DX10_DEFAULT;
    SrcFirstElement := 0;
    DstFirstElement := 0;
    NumElements := D3DX10_DEFAULT;
    Filter := D3DX10_DEFAULT;
    MipFilter := D3DX10_DEFAULT;
end;

{ TD3DX10_IMAGE_LOAD_INFO }

procedure TD3DX10_IMAGE_LOAD_INFO.Init;
begin
    Width := D3DX10_DEFAULT;
    Height := D3DX10_DEFAULT;
    Depth := D3DX10_DEFAULT;
    FirstMipLevel := D3DX10_DEFAULT;
    MipLevels := D3DX10_DEFAULT;
    Usage := TD3D10_USAGE(D3DX10_DEFAULT);
    BindFlags := D3DX10_DEFAULT;
    CpuAccessFlags := D3DX10_DEFAULT;
    MiscFlags := D3DX10_DEFAULT;
    Format := DXGI_FORMAT_FROM_FILE;
    Filter := D3DX10_DEFAULT;
    MipFilter := D3DX10_DEFAULT;
    pSrcInfo := nil;
end;


{ TD3DXCOLOR }

constructor TD3DXCOLOR.Create(argb: UINT);
var
    f: single;
begin
    f := 1.0 / 255.0;
    r := f * (argb shr 16);
    g := f * (argb shr 8);
    b := f * (argb shr 0);
    a := f * (argb shr 24);
end;



constructor TD3DXCOLOR.CreateBySingle(pf: PFloatArray4);
var
    lPF: array [0..3] of single;
begin
    if pf = nil then
        Exit;
    {$IFDEF FPC}
    r := pf[0];
    g := pf[1];
    b := pf[2];
    a := pf[3];
    {$ELSE}
    r := pf^[0];
    g := pf^[1];
    b := pf^[2];
    a := pf^[3];
    {$ENDIF}
end;



constructor TD3DXCOLOR.CreateByFloat16(pf: PD3DXFLOAT16);
begin
    if pf = nil then
        Exit;
    D3DXFloat16To32Array(@r, pf, 4);
end;



constructor TD3DXCOLOR.Create(fr, fg, fb, fa: single);
begin
    r := fr;
    g := fg;
    b := fb;
    a := fa;
end;



function TD3DXCOLOR.AsUINT: UINT;
var
    dwR, dwG, dwB, dwA: UINT;
begin
    if r >= 1.0 then
        dwR := $FF
    else if r <= 0.0 then
        dwR := $00
    else
        dwR := Trunc(r * 255 + 0.5);

    if g >= 1.0 then
        dwG := $FF
    else if g <= 0.0 then
        dwG := $00
    else
        dwG := Trunc(g * 255 + 0.5);

    if b >= 1.0 then
        dwB := $FF
    else if b <= 0.0 then
        dwB := $00
    else
        dwB := Trunc(b * 255 + 0.5);

    if a >= 1.0 then
        dwA := $FF
    else if a <= 0.0 then
        dwA := $00
    else
        dwA := Trunc(a * 255 + 0.5);

    Result := (dwA shl 24) or (dwR shl 16) or (dwG shl 8) or (dwB shl 0);

end;



class operator TD3DXCOLOR.Add(a, b: TD3DXCOLOR): TD3DXCOLOR;
begin
    Result.r := a.r + b.r;
    Result.g := a.g + b.g;
    Result.b := a.b + b.b;
    Result.a := a.a + b.a;
end;



class operator TD3DXCOLOR.Subtract(a, b: TD3DXCOLOR): TD3DXCOLOR;
begin
    Result.r := a.r - b.r;
    Result.g := a.g - b.g;
    Result.b := a.b - b.b;
    Result.a := a.a - b.a;
end;



class operator TD3DXCOLOR.Multiply(a: TD3DXCOLOR; b: single): TD3DXCOLOR;
begin
    Result.r := a.r * b;
    Result.g := a.g * b;
    Result.b := a.b * b;
    Result.a := a.a * b;
end;



class operator TD3DXCOLOR.Multiply(b: single; a: TD3DXCOLOR): TD3DXCOLOR;
begin
    Result.r := a.r * b;
    Result.g := a.g * b;
    Result.b := a.b * b;
    Result.a := a.a * b;
end;



class operator TD3DXCOLOR.Divide(a: TD3DXCOLOR; b: single): TD3DXCOLOR;
begin
    Result.r := a.r / b;
    Result.g := a.g / b;
    Result.b := a.b / b;
    Result.a := a.a / b;
end;



class operator TD3DXCOLOR.Positive(a: TD3DXCOLOR): TD3DXCOLOR;
begin
    Result.r := a.r;
    Result.g := a.g;
    Result.b := a.b;
    Result.a := a.a;
end;



class operator TD3DXCOLOR.Negative(a: TD3DXCOLOR): TD3DXCOLOR;
begin
    Result.r := -a.r;
    Result.g := -a.g;
    Result.b := -a.b;
    Result.a := -a.a;
end;



class operator TD3DXCOLOR.Equal(a, b: TD3DXCOLOR): longbool;
begin
    Result := (a.r = b.r) and (a.g = b.g) and (a.b = b.b) and (a.a = b.a);
end;



class operator TD3DXCOLOR.NotEqual(a, b: TD3DXCOLOR): longbool;
begin
    Result := (a.r <> b.r) or (a.g <> b.g) or (a.b <> b.b) or (a.a <> b.a);
end;

{ TD3DXPLANE }

constructor TD3DXPLANE.CreateBySingle(pf: PFloatArray4);
begin
    if pf = nil then
        Exit;
    a := pf[0];
    b := pf[1];
    c := pf[2];
    d := pf[3];
end;



constructor TD3DXPLANE.CreateByFloat16(pf: PD3DXFLOAT16);
begin
    if pf = nil then
        Exit;
    D3DXFloat16To32Array(@a, pf, 4);
end;



constructor TD3DXPLANE.Create(fa, fb, fc, fd: single);
begin
    a := fa;
    b := fb;
    c := fc;
    d := fd;
end;



class operator TD3DXPLANE.Multiply(a: TD3DXPLANE; b: single): TD3DXPLANE;
begin
    Result.a := a.a * b;
    Result.b := a.b * b;
    Result.c := a.c * b;
    Result.d := a.d * b;
end;



class operator TD3DXPLANE.Divide(a: TD3DXPLANE; b: single): TD3DXPLANE;
begin
    Result.a := a.a / b;
    Result.b := a.b / b;
    Result.c := a.c / b;
    Result.d := a.d / b;
end;



class operator TD3DXPLANE.Positive(a: TD3DXPLANE): TD3DXPLANE;
begin
    Result.a := a.a;
    Result.b := a.b;
    Result.c := a.c;
    Result.d := a.d;
end;



class operator TD3DXPLANE.Negative(a: TD3DXPLANE): TD3DXPLANE;
begin
    Result.a := -a.a;
    Result.b := -a.b;
    Result.c := -a.c;
    Result.d := -a.d;
end;



class operator TD3DXPLANE.Equal(a, b: TD3DXPLANE): longbool;
begin
    Result := (a.a = b.a) and (a.b = b.b) and (a.c = b.c) and (a.d = b.d);
end;



class operator TD3DXPLANE.NotEqual(a, b: TD3DXPLANE): longbool;
begin
    Result := (a.a <> b.a) or (a.b <> b.b) or (a.c <> b.c) or (a.d <> b.d);
end;

{ TD3DXMATRIX }

constructor TD3DXMATRIX.Create(f11, f12, f13, f14, f21, f22, f23, f24, f31, f32, f33, f34, f41, f42, f43, f44: single);
begin
    _11 := f11;
    _12 := f12;
    _13 := f13;
    _14 := f14;
    _21 := f21;
    _22 := f22;
    _23 := f23;
    _24 := f24;
    _31 := f31;
    _32 := f32;
    _33 := f33;
    _34 := f34;
    _41 := f41;
    _42 := f42;
    _43 := f43;
    _44 := f44;
end;



constructor TD3DXMATRIX.CreateByFloat16(pf: PD3DXFLOAT16);
begin
    if pf = nil then
        Exit;
    D3DXFloat16To32Array(@_11, pf, 16);
end;



constructor TD3DXMATRIX.Create(m: TD3DMATRIX);
begin
    Move(m, _11, SizeOf(TD3DXMATRIX));
end;



constructor TD3DXMATRIX.CreateBySingle(pf: PSingle);
begin
    if pf = nil then
        Exit;
    Move(pf^, _11, SizeOf(TD3DXMATRIX));
end;



class operator TD3DXMATRIX.Add(a, b: TD3DXMATRIX): TD3DXMATRIX;
begin
    Result._11 := a._11 + b._11;
    Result._12 := a._12 + b._12;
    Result._13 := a._13 + b._13;
    Result._14 := a._14 + b._14;
    Result._21 := a._21 + b._21;
    Result._22 := a._22 + b._22;
    Result._23 := a._23 + b._23;
    Result._24 := a._24 + b._24;
    Result._31 := a._31 + b._31;
    Result._32 := a._32 + b._32;
    Result._33 := a._33 + b._33;
    Result._34 := a._34 + b._34;
    Result._41 := a._41 + b._41;
    Result._42 := a._42 + b._42;
    Result._43 := a._43 + b._43;
    Result._44 := a._44 + b._44;
end;



class operator TD3DXMATRIX.Divide(a: TD3DXMATRIX; b: single): TD3DXMATRIX;
begin
    Result._11 := a._11 / b;
    Result._12 := a._12 / b;
    Result._13 := a._13 / b;
    Result._14 := a._14 / b;
    Result._21 := a._21 / b;
    Result._22 := a._22 / b;
    Result._23 := a._23 / b;
    Result._24 := a._24 / b;
    Result._31 := a._31 / b;
    Result._32 := a._32 / b;
    Result._33 := a._33 / b;
    Result._34 := a._34 / b;
    Result._41 := a._41 / b;
    Result._42 := a._42 / b;
    Result._43 := a._43 / b;
    Result._44 := a._44 / b;
end;



class operator TD3DXMATRIX.Equal(a, b: TD3DXMATRIX): longbool;
begin
    {$IFDEF FPC}
    Result := (0 = CompareByte(a, b, SizeOf(TD3DXMATRIX)));
    {$ELSE}
        {$MESSAGE 'Nicht implementiert'}
    {$ENDIF}

end;



class operator TD3DXMATRIX.Multiply(a: TD3DXMATRIX; b: TD3DXMATRIX): TD3DXMATRIX;
begin
    D3DXMatrixMultiply(@Result, @a, @b);
end;



class operator TD3DXMATRIX.Multiply(a: TD3DXMATRIX; b: single): TD3DXMATRIX;
begin
    Result._11 := a._11 * b;
    Result._12 := a._12 * b;
    Result._13 := a._13 * b;
    Result._14 := a._14 * b;
    Result._21 := a._21 * b;
    Result._22 := a._22 * b;
    Result._23 := a._23 * b;
    Result._24 := a._24 * b;
    Result._31 := a._31 * b;
    Result._32 := a._32 * b;
    Result._33 := a._33 * b;
    Result._34 := a._34 * b;
    Result._41 := a._41 * b;
    Result._42 := a._42 * b;
    Result._43 := a._43 * b;
    Result._44 := a._44 * b;

end;



class operator TD3DXMATRIX.Negative(a: TD3DXMATRIX): TD3DXMATRIX;
begin
    Result._11 := -a._11;
    Result._12 := -a._12;
    Result._13 := -a._13;
    Result._14 := -a._14;
    Result._21 := -a._21;
    Result._22 := -a._22;
    Result._23 := -a._23;
    Result._24 := -a._24;
    Result._31 := -a._31;
    Result._32 := -a._32;
    Result._33 := -a._33;
    Result._34 := -a._34;
    Result._41 := -a._41;
    Result._42 := -a._42;
    Result._43 := -a._43;
    Result._44 := -a._44;
end;



class operator TD3DXMATRIX.NotEqual(a, b: TD3DXMATRIX): longbool;
begin
    {$IFDEF FPC}
    Result := (0 <> CompareByte(a, b, SizeOf(TD3DXMATRIX)));
    {$ELSE}
    {$Message 'Nicht implementiert'}
    {$ENDIF}
end;



procedure TD3DXMATRIX.Identity;
begin
    ZeroMemory(@Self, sizeof(TD3DXMATRIX));
    _11 := 1;
    _22 := 1;
    _33 := 1;
    _44 := 1;
end;



class operator TD3DXMATRIX.Positive(a: TD3DXMATRIX): TD3DXMATRIX;
begin
    Result._11 := a._11;
    Result._12 := a._12;
    Result._13 := a._13;
    Result._14 := a._14;
    Result._21 := a._21;
    Result._22 := a._22;
    Result._23 := a._23;
    Result._24 := a._24;
    Result._31 := a._31;
    Result._32 := a._32;
    Result._33 := a._33;
    Result._34 := a._34;
    Result._41 := a._41;
    Result._42 := a._42;
    Result._43 := a._43;
    Result._44 := a._44;
end;



class operator TD3DXMATRIX.Subtract(a, b: TD3DXMATRIX): TD3DXMATRIX;
begin
    Result._11 := a._11 - b._11;
    Result._12 := a._12 - b._12;
    Result._13 := a._13 - b._13;
    Result._14 := a._14 - b._14;
    Result._21 := a._21 - b._21;
    Result._22 := a._22 - b._22;
    Result._23 := a._23 - b._23;
    Result._24 := a._24 - b._24;
    Result._31 := a._31 - b._31;
    Result._32 := a._32 - b._32;
    Result._33 := a._33 - b._33;
    Result._34 := a._34 - b._34;
    Result._41 := a._41 - b._41;
    Result._42 := a._42 - b._42;
    Result._43 := a._43 - b._43;
    Result._44 := a._44 - b._44;
end;

{ TD3DXVECTOR4_16F }

constructor TD3DXVECTOR4_16F.CreateBySingle(pf: PSingle);
begin
    if pf = nil then
        Exit;
    D3DXFloat32To16Array(@x, pf, 4);
end;



constructor TD3DXVECTOR4_16F.CreateByFloat16(pf: PD3DXFLOAT16);
var
    {$IFDEF FPC}
    lTemp: array [0 .. 3] of TD3DXFLOAT16;
    {$ELSE}
     lTemp : PD3DXFLOAT16ARRAY4;
     {$ENDIF}
begin
    if (pf = nil) then
        Exit;
    {$IFDEF FPC}
    lTemp := pf;
        x.Value := UINT(lTemp[0].Value);
    y.Value := UINT(lTemp[1].Value);
    z.Value := UINT(lTemp[2].Value);
    w.Value := UINT(lTemp[3].Value);

    {$ELSE}
    ltemp := PD3DXFLOAT16ARRAY4(pf);
    x.Value := UINT(lTemp^[0].Value);
    y.Value := UINT(lTemp[1].Value);
    z.Value := UINT(lTemp[2].Value);
    w.Value := UINT(lTemp[3].Value);

    {$ENDIF}
end;



constructor TD3DXVECTOR4_16F.Create(v: TD3DXVECTOR3_16F; fw: TD3DXFLOAT16);
begin
    x := v.x;
    y := v.y;
    z := v.z;
    w := fw;
end;



constructor TD3DXVECTOR4_16F.Create(fx, fy, fz, fw: TD3DXFLOAT16);
begin
    x := fx;
    y := fy;
    z := fz;
    w := fw;
end;



class operator TD3DXVECTOR4_16F.Equal(a, b: TD3DXVECTOR4_16F): longbool;
begin
    Result := (a.x = b.x) and (a.y = b.y) and (a.z = b.z) and (a.w = b.w);
end;



class operator TD3DXVECTOR4_16F.NotEqual(a, b: TD3DXVECTOR4_16F): longbool;
begin
    Result := (a.x <> b.x) or (a.y <> b.y) or (a.z <> b.z) or (a.w <> b.w);
end;

{ TD3DXVECTOR4 }

constructor TD3DXVECTOR4.CreateBySingle(pf: PFloatArray4);
var
    a: PFloatArray4;
begin
    if pf = nil then
        Exit;
    x := pf^[0];
    y := pf^[1];
    z := pf^[2];
    w := pf^[3];

end;



constructor TD3DXVECTOR4.CreateByFloat16(pf: PD3DXFLOAT16);
begin
    if pf = nil then
        Exit;
    D3DXFloat16To32Array(@x, pf, 4);
end;



constructor TD3DXVECTOR4.Create(v: TD3DXVECTOR3; fw: single);
begin
    x := v.x;
    y := v.y;
    z := v.z;
    w := fw;
end;



constructor TD3DXVECTOR4.Create(fx, fy, fz, fw: single);
begin
    x := fx;
    y := fy;
    z := fz;
    w := fw;
end;



class operator TD3DXVECTOR4.Add(a, b: TD3DXVECTOR4): TD3DXVECTOR4;
begin
    Result.x := a.x + b.x;
    Result.y := a.y + b.y;
    Result.z := a.z + b.z;
    Result.w := a.w + b.w;
end;



class operator TD3DXVECTOR4.Subtract(a, b: TD3DXVECTOR4): TD3DXVECTOR4;
begin
    Result.x := a.x - b.x;
    Result.y := a.y - b.y;
    Result.z := a.z - b.z;
    Result.w := a.w - b.w;
end;



class operator TD3DXVECTOR4.Multiply(a: TD3DXVECTOR4; b: single): TD3DXVECTOR4;
begin
    Result.x := a.x * b;
    Result.y := a.y * b;
    Result.z := a.z * b;
    Result.w := a.w * b;
end;



class operator TD3DXVECTOR4.Divide(a: TD3DXVECTOR4; b: single): TD3DXVECTOR4;
begin
    if b = 0 then
        Exit;
    Result.x := a.x / b;
    Result.y := a.y / b;
    Result.z := a.z / b;
    Result.w := a.w / b;
end;



class operator TD3DXVECTOR4.Positive(a: TD3DXVECTOR4): TD3DXVECTOR4;
begin
    Result.x := a.x;
    Result.y := a.y;
    Result.z := a.z;
    Result.w := a.w;
end;



class operator TD3DXVECTOR4.Negative(a: TD3DXVECTOR4): TD3DXVECTOR4;
begin
    Result.x := -a.x;
    Result.y := -a.y;
    Result.z := -a.z;
    Result.w := -a.w;
end;



class operator TD3DXVECTOR4.Equal(a, b: TD3DXVECTOR4): longbool;
begin
    Result := (a.x = b.x) and (a.y = b.y) and (a.z = b.z) and (a.w = b.w);
end;



class operator TD3DXVECTOR4.NotEqual(a, b: TD3DXVECTOR4): longbool;
begin
    Result := (a.x <> b.x) or (a.y <> b.y) or (a.z <> b.z) or (a.w <> b.w);
end;

{ TD3DXVECTOR3_16F }

constructor TD3DXVECTOR3_16F.CreateBySingle(pf: PFloatArray3);
begin
    if pf = nil then
        Exit;
    D3DXFloat32To16Array(@x, PSingle(pf), 3);
end;



constructor TD3DXVECTOR3_16F.Create(v: TD3DXVECTOR3);
begin
    D3DXFloat32To16Array(@x, @v.x, 1);
    D3DXFloat32To16Array(@y, @v.y, 1);
    D3DXFloat32To16Array(@z, @v.z, 1);
end;



constructor TD3DXVECTOR3_16F.CreateByFloat16(pf: PD3DXFLOAT16);
var
    {$IFDEF FPC}
    lTemp: array [0 .. 2] of TD3DXFLOAT16;
    {$ELSE}
    lTemp: PD3DXFLOAT16ARRAY3;
    {$ENDIF}
begin
    if (pf = nil) then
        Exit;
    {$IFDEF FPC}
    lTemp := pf;
    x.Value := UINT(lTemp[0].Value);
    y.Value := UINT(lTemp[1].Value);
    z.Value := word(lTemp[2].Value);
    {$ELSE}
    lTemp := PD3DXFLOAT16ARRAY3(pf);
    x.Value := UINT(lTemp^[0].Value);
    y.Value := UINT(lTemp^[1].Value);
    z.Value := word(lTemp^[2].Value);
    {$ENDIF}
end;



constructor TD3DXVECTOR3_16F.Create(fx, fy, fz: TD3DXFLOAT16);
begin
    x := fx;
    y := fy;
    z := fz;
end;



class operator TD3DXVECTOR3_16F.Equal(a, b: TD3DXVECTOR3_16F): longbool;
begin
    Result := (a.x = b.y) and (a.y = b.y) and (a.z = b.z);
end;



class operator TD3DXVECTOR3_16F.NotEqual(a, b: TD3DXVECTOR3_16F): longbool;
begin
    Result := (a.x <> b.y) or (a.y <> b.y) or (a.z <> b.z);
end;

{ TD3DXVECTOR2_16F }

constructor TD3DXVECTOR2_16F.CreateBySingle(pf: PFloatArray2);
begin
    if pf = nil then
        Exit;
    D3DXFloat32To16Array(@x, PSingle(pf), 2);
end;



constructor TD3DXVECTOR2_16F.CreateByFloat16(pf: PD3DXFLOAT16ARRAY2);
begin
    if (pf = nil) then
        Exit;
    x.Value :=pf^[0].Value;
    y.Value :=pf^[1].Value;
end;



constructor TD3DXVECTOR2_16F.Create(ix, iy: TD3DXFLOAT16);
begin
    x := ix;
    y := iy;
end;



class operator TD3DXVECTOR2_16F.Equal(a, b: TD3DXVECTOR2_16F): longbool;
begin
    Result := (a.x = b.x) and (a.y = b.y);
end;



class operator TD3DXVECTOR2_16F.NotEqual(a, b: TD3DXVECTOR2_16F): longbool;
begin
    Result := (a.x <> b.x) or (a.y <> b.y);
end;

{ TD3DXVECTOR2 }

constructor TD3DXVECTOR2.Create(ix, iy: single);
begin
    x := ix;
    y := iy;
end;



constructor TD3DXVECTOR2.Create(pf: PFloatArray2);
begin
    if pf = nil then
        Exit;
    x := pf^[0];
    y := pf^[1];
end;



constructor TD3DXVECTOR2.Create(f: PD3DXFLOAT16);
begin
    if f = nil then
        Exit;
    D3DXFloat16To32Array(@x, f, 2);
end;



class operator TD3DXVECTOR2.Add(a, b: TD3DXVECTOR2): TD3DXVECTOR2;
begin
    Result.x := a.x + b.x;
    Result.y := a.y + b.y;
end;



class operator TD3DXVECTOR2.Subtract(a, b: TD3DXVECTOR2): TD3DXVECTOR2;
begin
    Result.x := a.x - b.x;
    Result.y := a.y - b.y;
end;



class operator TD3DXVECTOR2.Multiply(a: TD3DXVECTOR2; b: single): TD3DXVECTOR2;
begin
    Result.x := a.x * b;
    Result.y := a.y * b;
end;



class operator TD3DXVECTOR2.Divide(a: TD3DXVECTOR2; b: single): TD3DXVECTOR2;
begin
    if b = 0 then
        Exit;
    Result.x := a.x / b;
    Result.y := a.y / b;
end;



class operator TD3DXVECTOR2.Positive(a: TD3DXVECTOR2): TD3DXVECTOR2;
begin
    Result := a;
end;



class operator TD3DXVECTOR2.Negative(a: TD3DXVECTOR2): TD3DXVECTOR2;
begin
    Result.x := -a.x;
    Result.y := -a.y;
end;



class operator TD3DXVECTOR2.Equal(a, b: TD3DXVECTOR2): longbool;
begin
    Result := (a.x = b.x) and (a.y = b.y);
end;



class operator TD3DXVECTOR2.NotEqual(a, b: TD3DXVECTOR2): longbool;
begin
    Result := (a.x <> b.x) or (a.y <> b.y);
end;



procedure TD3DXVECTOR2.Init(lx, ly: single);
begin
    x := lx;
    y := ly;
end;

{ TD3DXVECTOR3 }

constructor TD3DXVECTOR3.Create(fx, fy, fz: single);
begin
    x := fx;
    y := fy;
    z := fz;
end;



constructor TD3DXVECTOR3.CreateBySingle(f: PFloatArray3);
begin
    if f = nil then
        Exit;
    x := f[0];
    y := f[1];
    z := f[2];
end;



constructor TD3DXVECTOR3.Create(v: TD3DXVECTOR3);
begin
    x := v.x;
    y := v.y;
    z := v.z;
end;



constructor TD3DXVECTOR3.CreateByFloat16(pf: PD3DXFLOAT16);
begin
    if (pf = nil) then
        Exit;
    D3DXFloat16To32Array(@x, pf, 3);
end;



class operator TD3DXVECTOR3.Add(a, b: TD3DXVECTOR3): TD3DXVECTOR3;
begin
    Result.x := a.x + b.x;
    Result.y := a.y + b.y;
    Result.z := a.z + b.z;
end;



class operator TD3DXVECTOR3.Subtract(a, b: TD3DXVECTOR3): TD3DXVECTOR3;
begin
    Result.x := a.x - b.x;
    Result.y := a.y - b.y;
    Result.z := a.z - b.z;
end;



class operator TD3DXVECTOR3.Multiply(a: TD3DXVECTOR3; b: single): TD3DXVECTOR3;
begin
    Result.x := a.x * b;
    Result.y := a.y * b;
    Result.z := a.z * b;
end;



class operator TD3DXVECTOR3.Divide(a: TD3DXVECTOR3; b: single): TD3DXVECTOR3;
begin
    if b = 0 then
        Exit;
    Result.x := a.x / b;
    Result.y := a.y / b;
    Result.z := a.z / b;
end;



class operator TD3DXVECTOR3.Positive(a: TD3DXVECTOR3): TD3DXVECTOR3;
begin
    Result.x := a.x;
    Result.y := a.y;
    Result.z := a.z;
end;



class operator TD3DXVECTOR3.Negative(a: TD3DXVECTOR3): TD3DXVECTOR3;
begin
    Result.x := -a.x;
    Result.y := -a.y;
    Result.z := -a.z;
end;



class operator TD3DXVECTOR3.Equal(a, b: TD3DXVECTOR3): longbool;
begin
    Result := (a.x = b.x) and (a.y = b.y) and (a.z = b.z);
end;



class operator TD3DXVECTOR3.NotEqual(a, b: TD3DXVECTOR3): longbool;
begin
    Result := (a.x <> b.x) or (a.y <> b.y) or (a.z <> b.z);
end;



procedure TD3DXVECTOR3.Init(lx, ly, lz: single);
begin
    x := lx;
    y := ly;
    z := lz;
end;

{ TD3DXFLOAT16 }

class operator TD3DXFLOAT16.Equal(a, b: TD3DXFLOAT16): longbool;
begin
    // At least one is NaN
    if ((((a.Value and D3DX_16F_EXP_MASK) = D3DX_16F_EXP_MASK) and ((a.Value and D3DX_16F_FRAC_MASK) = D3DX_16F_FRAC_MASK)) or
        (((b.Value and D3DX_16F_EXP_MASK) = D3DX_16F_EXP_MASK) and ((b.Value and D3DX_16F_FRAC_MASK) = D3DX_16F_FRAC_MASK))) then
        Result := False
    // +/- Zero
    else if (((a.Value and not D3DX_16F_SIGN_MASK) = 0) and ((b.Value and not D3DX_16F_SIGN_MASK) = 0)) then
        Result := True
    else
        Result := (a.Value = b.Value);
end;



class operator TD3DXFLOAT16.NotEqual(a, b: TD3DXFLOAT16): longbool;
begin
    // At least one is NaN
    if ((((a.Value and D3DX_16F_EXP_MASK) = D3DX_16F_EXP_MASK) and ((a.Value and D3DX_16F_FRAC_MASK) = D3DX_16F_FRAC_MASK)) or
        (((b.Value and D3DX_16F_EXP_MASK) = D3DX_16F_EXP_MASK) and ((b.Value and D3DX_16F_FRAC_MASK) = D3DX_16F_FRAC_MASK))) then
        Result := True
    // +/- Zero
    else if (((a.Value and not D3DX_16F_SIGN_MASK) = 0) and ((b.Value and not D3DX_16F_SIGN_MASK) = 0)) then
        Result := False
    else
        Result := (a.Value <> b.Value);
end;



class operator TD3DXFLOAT16.Implicit(a: single): TD3DXFLOAT16;
begin
    D3DXFloat32To16Array(@result,@a,1);
end;



class operator TD3DXFLOAT16.Explicit(a: TD3DXFLOAT16): single;
begin
    D3DXFloat16To32Array(@result, @a, 1);
end;



constructor TD3DXFLOAT16.Create(f: single);
begin
    D3DXFloat32To16Array(@Value, @f, 1);
end;



constructor TD3DXFLOAT16.Create(f: TD3DXFLOAT16);
begin
    Value := f.Value;
end;

{ TD3DXQUATERNION }

class operator TD3DXQUATERNION.Add(a, b: TD3DXQUATERNION): TD3DXQUATERNION;
begin
    Result.x := a.x + b.x;
    Result.y := a.y + b.y;
    Result.z := a.z + b.z;
    Result.w := a.w + b.w;
end;



constructor TD3DXQUATERNION.Create(fx, fy, fz, fw: single);
begin
    x := fx;
    y := fy;
    z := fz;
    w := fw;
end;



constructor TD3DXQUATERNION.CreateByFloat16(pf: PD3DXFLOAT16);
begin
    if pf = nil then
        Exit;
    D3DXFloat16To32Array(@x, pf, 4);
end;



constructor TD3DXQUATERNION.CreateBySingle(pf: PFloatArray4);
begin
    if pf = nil then
        Exit;
    x := pf^[0];
    y := pf^[1];
    z := pf^[2];
    w := pf^[3];
end;



class operator TD3DXQUATERNION.Divide(a: TD3DXQUATERNION; b: single): TD3DXQUATERNION;
begin
    Result.x := a.x / b;
    Result.y := a.y / b;
    Result.z := a.z / b;
    Result.w := a.w / b;
end;



class operator TD3DXQUATERNION.Equal(a, b: TD3DXQUATERNION): longbool;
begin
    Result := (a.x = b.x) and (a.y = b.y) and (a.z = b.z) and (a.w = b.w);
end;



class operator TD3DXQUATERNION.Multiply(a: TD3DXQUATERNION; b: single): TD3DXQUATERNION;
begin
    Result.x := a.x * b;
    Result.y := a.y * b;
    Result.z := a.z * b;
    Result.w := a.w * b;
end;



class operator TD3DXQUATERNION.Multiply(a, b: TD3DXQUATERNION): TD3DXQUATERNION;
begin
    D3DXQuaternionMultiply(@Result, @a, @b);
end;



class operator TD3DXQUATERNION.Negative(a: TD3DXQUATERNION): TD3DXQUATERNION;
begin
    Result.x := -a.x;
    Result.y := -a.y;
    Result.z := -a.z;
    Result.w := -a.w;
end;



class operator TD3DXQUATERNION.NotEqual(a, b: TD3DXQUATERNION): longbool;
begin
    Result := (a.x <> b.x) or (a.y <> b.y) or (a.z <> b.z) or (a.w <> b.w);
end;



class operator TD3DXQUATERNION.Positive(a: TD3DXQUATERNION): TD3DXQUATERNION;
begin
    Result.x := a.x;
    Result.y := a.y;
    Result.z := a.z;
    Result.w := a.w;

end;



class operator TD3DXQUATERNION.Subtract(a, b: TD3DXQUATERNION): TD3DXQUATERNION;
begin
    Result.x := a.x - b.x;
    Result.y := a.y - b.y;
    Result.z := a.z - b.z;
    Result.w := a.w - b.w;
end;


// --------------------------
// 4D Matrix
// --------------------------

function D3DXVec2Length(const pV: PD3DXVECTOR2): single;
begin
    Result := 0.0;
    if (pV = nil) then
        Exit;
    Result := sqrt(pV.x * pV.x + pV.y * pV.y);
end;



function D3DXVec2LengthSq(const pV: PD3DXVECTOR2): single;
begin
    Result := 0.0;
    if (pV = nil) then
        Exit;


    Result := pV.x * pV.x + pV.y * pV.y;
end;



function D3DXVec2Dot(const pV1: PD3DXVECTOR2; const pV2: PD3DXVECTOR2): single;
begin
    Result := 0.0;
    if (pV1 = nil) or (pV2 = nil) then
        Exit;
    Result := pV1.x * pV2.x + pV1.y * pV2.y;
end;



function D3DXVec2CCW(const pV1: PD3DXVECTOR2; const pV2: PD3DXVECTOR2): single;
begin
    Result := 0.0;
    if (pV1 = nil) or (pV2 = nil) then
        Exit;
    Result := pV1.x * pV2.y - pV1.y * pV2.x;
end;



function D3DXVec2Add(pOut: PD3DXVECTOR2; const pV1: PD3DXVECTOR2; const pV2: PD3DXVECTOR2): PD3DXVECTOR2;
begin
    Result := nil;
    if (pOut = nil) or (pV1 = nil) or (pV2 = nil) then
        Exit;
    pOut.x := pV1.x + pV2.x;
    pOut.y := pV1.y + pV2.y;
    Result := pOut;
end;



function D3DXVec2Subtract(pOut: PD3DXVECTOR2; const pV1: PD3DXVECTOR2; const pV2: PD3DXVECTOR2): PD3DXVECTOR2;
begin
    Result := nil;
    if (pOut = nil) or (pV1 = nil) or (pV2 = nil) then
        Exit;

    pOut.x := pV1.x - pV2.x;
    pOut.y := pV1.y - pV2.y;
    Result := pOut;
end;



function D3DXVec2Minimize(pOut: PD3DXVECTOR2; const pV1: PD3DXVECTOR2; const pV2: PD3DXVECTOR2): PD3DXVECTOR2;
begin
    Result := nil;
    if (pOut = nil) or (pV1 = nil) or (pV2 = nil) then
        Exit;


    if (pV1.x < pV2.x) then
        pOut.x := pV1.x
    else
        pOut.x := pV2.x;
    if (pV1.y < pV2.y) then
        pOut.y := pV1.y
    else
        pOut.y := pV2.y;
    Result := pOut;
end;



function D3DXVec2Maximize(pOut: PD3DXVECTOR2; const pV1: PD3DXVECTOR2; const pV2: PD3DXVECTOR2): PD3DXVECTOR2;
begin
    Result := nil;
    if (pOut = nil) or (pV1 = nil) or (pV2 = nil) then
        Exit;


    if (pV1.x > pV2.x) then
        pOut.x := pV1.x
    else
        pOut.x := pV2.x;
    if (pV1.y > pV2.y) then
        pOut.y := pV1.y
    else
        pOut.y := pV2.y;
    Result := pOut;
end;



function D3DXVec2Scale(pOut: PD3DXVECTOR2; const pV: PD3DXVECTOR2; s: single): PD3DXVECTOR2;
begin
    Result := nil;
    if (pOut = nil) or (pV = nil) then
        Exit;


    pOut.x := pV.x * s;
    pOut.y := pV.y * s;
    Result := pOut;
end;



function D3DXVec2Lerp(pOut: PD3DXVECTOR2; const pV1: PD3DXVECTOR2; const pV2: PD3DXVECTOR2; s: single): PD3DXVECTOR2;
begin
    Result := nil;
    if (pOut = nil) or (pV1 = nil) or (pV2 = nil) then
        Exit;
    pOut.x := pV1.x + s * (pV2.x - pV1.x);
    pOut.y := pV1.y + s * (pV2.y - pV1.y);
    Result := pOut;
end;



function D3DXVec3Length(const pV: PD3DXVECTOR3): single;
begin
    Result := 0.0;
    if (pV = nil) then
        Exit;
    Result := sqrt(pV.x * pV.x + pV.y * pV.y + pV.z * pV.z);

end;



function D3DXVec3LengthSq(const pV: PD3DXVECTOR3): single;
begin
    Result := 0.0;
    if (pV = nil) then
        Exit;
    Result := pV.x * pV.x + pV.y * pV.y + pV.z * pV.z;
end;



function D3DXVec3Dot(const pV1: PD3DXVECTOR3; const pV2: PD3DXVECTOR3): single;
begin
    Result := 0.0;
    if (pV1 = nil) or (pV2 = nil) then
        Exit;
    Result := pV1.x * pV2.x + pV1.y * pV2.y + pV1.z * pV2.z;
end;



function D3DXVec3Cross(pOut: PD3DXVECTOR3; const pV1: PD3DXVECTOR3; const pV2: PD3DXVECTOR3): PD3DXVECTOR3;
begin
    Result := nil;
    if (pOut = nil) or (pV1 = nil) or (pV2 = nil) then
        Exit;

    pOut.x := pV1.y * pV2.z - pV1.z * pV2.y;
    pOut.y := pV1.z * pV2.x - pV1.x * pV2.z;
    pOut.z := pV1.x * pV2.y - pV1.y * pV2.x;
    Result := pOut;
end;



function D3DXVec3Add(pOut: PD3DXVECTOR3; const pV1: PD3DXVECTOR3; const pV2: PD3DXVECTOR3): PD3DXVECTOR3;
begin
    Result := nil;
    if (pOut = nil) or (pV1 = nil) or (pV2 = nil) then
        Exit;


    pOut.x := pV1.x + pV2.x;
    pOut.y := pV1.y + pV2.y;
    pOut.z := pV1.z + pV2.z;
    Result := pOut;
end;



function D3DXVec3Subtract(pOut: PD3DXVECTOR3; const pV1: PD3DXVECTOR3; const pV2: PD3DXVECTOR3): PD3DXVECTOR3;
begin
    Result := nil;
    if (pOut = nil) or (pV1 = nil) or (pV2 = nil) then
        Exit;


    pOut.x := pV1.x - pV2.x;
    pOut.y := pV1.y - pV2.y;
    pOut.z := pV1.z - pV2.z;
    Result := pOut;
end;



function D3DXVec3Minimize(pOut: PD3DXVECTOR3; const pV1: PD3DXVECTOR3; const pV2: PD3DXVECTOR3): PD3DXVECTOR3;
begin
    Result := nil;
    if (pOut = nil) or (pV1 = nil) or (pV2 = nil) then
        Exit;


    if (pV1.x < pV2.x) then
        pOut.x := pV1.x
    else
        pOut.x := pV2.x;
    if (pV1.y < pV2.y) then
        pOut.y := pV1.y
    else
        pOut.y := pV2.y;
    if (pV1.z < pV2.z) then
        pOut.z := pV1.z
    else
        pOut.z := pV2.z;
    Result := pOut;
end;



function D3DXVec3Maximize(pOut: PD3DXVECTOR3; const pV1: PD3DXVECTOR3; const pV2: PD3DXVECTOR3): PD3DXVECTOR3;
begin
    Result := nil;
    if (pOut = nil) or (pV1 = nil) or (pV2 = nil) then
        Exit;


    if (pV1.x > pV2.x) then
        pOut.x := pV1.x
    else
        pOut.x := pV2.x;
    if (pV1.y > pV2.y) then
        pOut.y := pV1.y
    else
        pOut.y := pV2.y;
    if (pV1.z > pV2.z) then
        pOut.z := pV1.z
    else
        pOut.z := pV2.z;
    Result := pOut;
end;



function D3DXVec3Scale(pOut: PD3DXVECTOR3; const pV: PD3DXVECTOR3; s: single): PD3DXVECTOR3;
begin
    Result := nil;
    if (pOut = nil) or (pV = nil) then
        Exit;
    pOut.x := pV.x * s;
    pOut.y := pV.y * s;
    pOut.z := pV.z * s;
    Result := pOut;
end;



function D3DXVec3Lerp(pOut: PD3DXVECTOR3; const pV1: PD3DXVECTOR3; const pV2: PD3DXVECTOR3; s: single): PD3DXVECTOR3;
begin
    if (pOut = nil) or (pV1 = nil) or (pV2 = nil) then
        Exit;
    Result := nil;
    pOut.x := pV1.x + s * (pV2.x - pV1.x);
    pOut.y := pV1.y + s * (pV2.y - pV1.y);
    pOut.z := pV1.z + s * (pV2.z - pV1.z);
    Result := pOut;
end;



function D3DXVec4Length(const pV: PD3DXVECTOR4): single;
begin
    Result := 0.0;
    if (pV = nil) then
        Exit;
    Result := sqrt(pV.x * pV.x + pV.y * pV.y + pV.z * pV.z + pV.w * pV.w);
end;



function D3DXVec4LengthSq(const pV: PD3DXVECTOR4): single;
begin
    Result := 0.0;
    if (pV = nil) then
        Exit;
    Result := pV.x * pV.x + pV.y * pV.y + pV.z * pV.z + pV.w * pV.w;
end;



function D3DXVec4Dot(const pV1: PD3DXVECTOR4; const pV2: PD3DXVECTOR4): single;
begin
    Result := 0.0;
    if (pV1 = nil) or (pV2 = nil) then
        Exit;
    Result := pV1.x * pV2.x + pV1.y * pV2.y + pV1.z * pV2.z + pV1.w * pV2.w;
end;



function D3DXVec4Add(pOut: PD3DXVECTOR4; const pV1: PD3DXVECTOR4; const pV2: PD3DXVECTOR4): PD3DXVECTOR4;
begin
    Result := nil;
    if (pOut = nil) or (pV1 = nil) or (pV2 = nil) then
        Exit;
    pOut.x := pV1.x + pV2.x;
    pOut.y := pV1.y + pV2.y;
    pOut.z := pV1.z + pV2.z;
    pOut.w := pV1.w + pV2.w;
    Result := pOut;
end;



function D3DXVec4Subtract(pOut: PD3DXVECTOR4; const pV1: PD3DXVECTOR4; const pV2: PD3DXVECTOR4): PD3DXVECTOR4;
begin
    Result := nil;
    if (pOut = nil) or (pV1 = nil) or (pV2 = nil) then
        Exit;
    pOut.x := pV1.x - pV2.x;
    pOut.y := pV1.y - pV2.y;
    pOut.z := pV1.z - pV2.z;
    pOut.w := pV1.w - pV2.w;
    Result := pOut;
end;



function D3DXVec4Minimize(pOut: PD3DXVECTOR4; const pV1: PD3DXVECTOR4; const pV2: PD3DXVECTOR4): PD3DXVECTOR4;
begin
    Result := nil;
    if (pOut = nil) or (pV1 = nil) or (pV2 = nil) then
        Exit;
    if (pV1.x < pV2.x) then
        pOut.x := pV1.x
    else
        pOut.x := pV2.x;
    if (pV1.y < pV2.y) then
        pOut.y := pV1.y
    else
        pOut.y := pV2.y;
    if (pV1.z < pV2.z) then
        pOut.z := pV1.z
    else
        pOut.z := pV2.z;
    if (pV1.w < pV2.w) then
        pOut.w := pV1.w
    else
        pOut.w := pV2.w;
    Result := pOut;
end;



function D3DXVec4Maximize(pOut: PD3DXVECTOR4; const pV1: PD3DXVECTOR4; const pV2: PD3DXVECTOR4): PD3DXVECTOR4;
begin
    Result := nil;
    if (pOut = nil) or (pV1 = nil) or (pV2 = nil) then
        Exit;
    if (pV1.x > pV2.x) then
        pOut.x := pV1.x
    else
        pOut.x := pV2.x;
    if (pV1.y > pV2.y) then
        pOut.y := pV1.y
    else
        pOut.y := pV2.y;
    if (pV1.z > pV2.z) then
        pOut.z := pV1.z
    else
        pOut.z := pV2.z;
    if (pV1.w > pV2.w) then
        pOut.w := pV1.w
    else
        pOut.w := pV2.w;
    Result := pOut;
end;



function D3DXVec4Scale(pOut: PD3DXVECTOR4; const pV: PD3DXVECTOR4; s: single): PD3DXVECTOR4;
begin
    Result := nil;
    if (pOut = nil) or (pV = nil) then
        Exit;
    pOut.x := pV.x * s;
    pOut.y := pV.y * s;
    pOut.z := pV.z * s;
    pOut.w := pV.w * s;
    Result := pOut;
end;



function D3DXVec4Lerp(pOut: PD3DXVECTOR4; const pV1: PD3DXVECTOR4; const pV2: PD3DXVECTOR4; s: single): PD3DXVECTOR4;
begin
    Result := nil;
    if (pOut = nil) or (pV1 = nil) or (pV2 = nil) then
        Exit;
    pOut.x := pV1.x + s * (pV2.x - pV1.x);
    pOut.y := pV1.y + s * (pV2.y - pV1.y);
    pOut.z := pV1.z + s * (pV2.z - pV1.z);
    pOut.w := pV1.w + s * (pV2.w - pV1.w);
    Result := pOut;
end;



function D3DXPlaneDot(const pP: PD3DXPLANE; const pV: PD3DXVECTOR4): single;
begin
    Result := 0.0;
    if (pP = nil) or (pV = nil) then
        Exit;
    Result := pP.a * pV.x + pP.b * pV.y + pP.c * pV.z + pP.d * pV.w;
end;



function D3DXPlaneDotCoord(const pP: PD3DXPLANE; const pV: PD3DXVECTOR3): single;
begin
    Result := 0.0;
    if (pP = nil) or (pV = nil) then
        Exit;
    Result := pP.a * pV.x + pP.b * pV.y + pP.c * pV.z + pP.d;
end;



function D3DXPlaneDotNormal(const pP: PD3DXPLANE; const pV: PD3DXVECTOR3): single;
begin
    Result := 0.0;
    if (pP = nil) or (pV = nil) then
        Exit;


    Result := pP.a * pV.x + pP.b * pV.y + pP.c * pV.z;
end;



function D3DXPlaneScale(pOut: PD3DXPLANE; const pP: PD3DXPLANE; s: single): PD3DXPLANE;
begin
    Result := nil;
    if (pOut = nil) or (pP = nil) then
        Exit;
    pOut.a := pP.a * s;
    pOut.b := pP.b * s;
    pOut.c := pP.c * s;
    pOut.d := pP.d * s;
    Result := pOut;
end;



function D3DXColorNegative(pOut: PD3DXCOLOR; const pC: PD3DXCOLOR): PD3DXCOLOR;
begin
    Result := nil;
    if (pOut = nil) or (pC = nil) then
        Exit;
    pOut.r := 1.0 - pC.r;
    pOut.g := 1.0 - pC.g;
    pOut.b := 1.0 - pC.b;
    pOut.a := pC.a;
    Result := pOut;
end;



function D3DXColorAdd(pOut: PD3DXCOLOR; const pC1: PD3DXCOLOR; const pC2: PD3DXCOLOR): PD3DXCOLOR;
begin
    Result := nil;
    if (pOut = nil) or (pC1 = nil) or (pC2 = nil) then
        Exit;


    pOut.r := pC1.r + pC2.r;
    pOut.g := pC1.g + pC2.g;
    pOut.b := pC1.b + pC2.b;
    pOut.a := pC1.a + pC2.a;
    Result := pOut;
end;



function D3DXColorSubtract(pOut: PD3DXCOLOR; const pC1: PD3DXCOLOR; const pC2: PD3DXCOLOR): PD3DXCOLOR;
begin
    Result := nil;
    if (pOut = nil) or (pC1 = nil) or (pC2 = nil) then
        Exit;
    pOut.r := pC1.r - pC2.r;
    pOut.g := pC1.g - pC2.g;
    pOut.b := pC1.b - pC2.b;
    pOut.a := pC1.a - pC2.a;
    Result := pOut;
end;



function D3DXColorScale(pOut: PD3DXCOLOR; const pC: PD3DXCOLOR; s: single): PD3DXCOLOR;
begin
    Result := nil;
    if (pOut = nil) or (pC = nil) then
        Exit;
    pOut.r := pC.r * s;
    pOut.g := pC.g * s;
    pOut.b := pC.b * s;
    pOut.a := pC.a * s;
    Result := pOut;
end;



function D3DXColorModulate(pOut: PD3DXCOLOR; const pC1: PD3DXCOLOR; const pC2: PD3DXCOLOR): PD3DXCOLOR;
begin
    Result := nil;
    if (pOut = nil) or (pC1 = nil) or (pC2 = nil) then
        Exit;
    pOut.r := pC1.r * pC2.r;
    pOut.g := pC1.g * pC2.g;
    pOut.b := pC1.b * pC2.b;
    pOut.a := pC1.a * pC2.a;
    Result := pOut;
end;



function D3DXColorLerp(pOut: PD3DXCOLOR; const pC1: PD3DXCOLOR; const pC2: PD3DXCOLOR; s: single): PD3DXCOLOR;
begin
    Result := nil;
    if (pOut = nil) or (pC1 = nil) or (pC2 = nil) then
        Exit;

    pOut.r := pC1.r + s * (pC2.r - pC1.r);
    pOut.g := pC1.g + s * (pC2.g - pC1.g);
    pOut.b := pC1.b + s * (pC2.b - pC1.b);
    pOut.a := pC1.a + s * (pC2.a - pC1.a);
    Result := pOut;
end;



function D3DXMatrixIdentity(pOut: PD3DXMATRIX): PD3DXMATRIX;
begin
    Result := nil;
    if (pOut = nil) then
        Exit;
    pOut.m[0, 1] := 0.0;
    pOut.m[0, 2] := 0.0;
    pOut.m[0, 3] := 0.0;
    pOut.m[1, 0] := 0.0;
    pOut.m[1, 2] := 0.0;
    pOut.m[1, 3] := 0.0;
    pOut.m[2, 0] := 0.0;
    pOut.m[2, 1] := 0.0;
    pOut.m[2, 3] := 0.0;
    pOut.m[3, 0] := 0.0;
    pOut.m[3, 1] := 0.0;
    pOut.m[3, 2] := 0.0;

    pOut.m[0, 0] := 1.0;
    pOut.m[1, 1] := 1.0;
    pOut.m[2, 2] := 1.0;
    pOut.m[3, 3] := 1.0;
    Result := pOut;
end;



function D3DXMatrixIsIdentity(pM: PD3DXMATRIX): longbool;
begin
    Result := False;
    if (pM = nil) then
        Exit;
    Result := (pM.m[0][0] = 1.0) and (pM.m[0][1] = 0.0) and (pM.m[0][2] = 0.0) and (pM.m[0][3] = 0.0) and
        (pM.m[1][0] = 0.0) and (pM.m[1][1] = 1.0) and (pM.m[1][2] = 0.0) and (pM.m[1][3] = 0.0) and (pM.m[2][0] = 0.0) and
        (pM.m[2][1] = 0.0) and (pM.m[2][2] = 1.0) and (pM.m[2][3] = 0.0) and (pM.m[3][0] = 0.0) and (pM.m[3][1] = 0.0) and
        (pM.m[3][2] = 0.0) and (pM.m[3][3] = 1.0);
end;


// --------------------------
// Quaternion
// --------------------------

function D3DXQuaternionLength(pQ: PD3DXQUATERNION): single;
begin
    Result := 0;
    if (pQ = nil) then
        Exit;
    Result := sqrt(pQ.x * pQ.x + pQ.y * pQ.y + pQ.z * pQ.z + pQ.w * pQ.w);
end;

// Length squared, or "norm"

function D3DXQuaternionLengthSq(pQ: PD3DXQUATERNION): single;
begin
    Result := 0;
    if (pQ = nil) then
        Exit;
    Result := (pQ.x * pQ.x + pQ.y * pQ.y + pQ.z * pQ.z + pQ.w * pQ.w);
end;



function D3DXQuaternionDot(pQ1: PD3DXQUATERNION; pQ2: PD3DXQUATERNION): single;
begin
    Result := 0;
    if (pQ1 = nil) or (pQ2 = nil) then
        Exit;
    Result := pQ1.x * pQ2.x + pQ1.y * pQ2.y + pQ1.z * pQ2.z + pQ1.w * pQ2.w;
end;

// (0, 0, 0, 1)

function D3DXQuaternionIdentity(pOut: PD3DXQUATERNION): PD3DXQUATERNION;
begin
    Result := nil;
    if (pOut = nil) then
        Exit;
    pOut.x := 0.0;
    pOut.y := 0.0;
    pOut.z := 0.0;
    pOut.w := 1.0;
    Result := pOut;
end;



function D3DXQuaternionIsIdentity(pQ: PD3DXQUATERNION): longbool;
begin
    Result := False;
    if (pQ = nil) then
        Exit;
    Result := (pQ.x = 0.0) and (pQ.y = 0.0) and (pQ.z = 0.0) and (pQ.w = 1.0);
end;

// (-x, -y, -z, w)

function D3DXQuaternionConjugate(pOut: PD3DXQUATERNION; pQ: PD3DXQUATERNION): PD3DXQUATERNION;
begin
    Result := nil;
    if (pOut = nil) or (pQ = nil) then
        Exit;
    pOut.x := -pQ.x;
    pOut.y := -pQ.y;
    pOut.z := -pQ.z;
    pOut.w := pQ.w;
    Result := pOut;
end;

end.
