{ **************************************************************************
    FreePascal/Delphi DirectX 12 Header Files

    Copyright (C) 2013-2025 Norbert Sonnleitner

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
************************************************************************** }

{ **************************************************************************
   Additional Copyright (C) for this modul:

   Copyright (C) Microsoft Corporation.  All Rights Reserved.
   Content:    D3DX math types and functions
   Content:    D3DX math inline functions

   This unit consists of the following header files
   File name: d3dx9math.h
              d3dx9math.inl
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.D3DX9Math;


{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}


interface

uses
    Windows, Classes, SysUtils,
    DX12.D3DX9,
    DX12.D3D9,
    DX12.D3D9Types;

    {$Z4}

    // for different SDK versions
    {$I DX12.DX9SDKVersion.inc}

const
    //===========================================================================

    // General purpose utilities

    //===========================================================================
    D3DX_PI: single = 3.141592654;
    D3DX_1BYPI: single = 0.318309886;


    //===========================================================================

    // 16 bit floating point numbers

    //===========================================================================

    D3DX_16F_DIG = 3; // # of decimal digits of precision
    D3DX_16F_EPSILON = 4.8875809e-4; // smallest such that 1.0 + epsilon != 1.0
    D3DX_16F_MANT_DIG = 11; // # of bits in mantissa
    D3DX_16F_MAX = 6.550400e+004; // max value
    D3DX_16F_MAX_10_EXP = 4; // max decimal exponent
    D3DX_16F_MAX_EXP = 15; // max binary exponent
    D3DX_16F_MIN = 6.1035156e-5; // min positive value
    D3DX_16F_MIN_10_EXP = (-4); // min decimal exponent
    {$IFDEF USESDK43 }
    D3DX_16F_MIN_EXP = (-14);            // min binary exponent
    {$ELSE}
    D3DX_16F_MIN_EXP = (-12); // min binary exponent
    {$ENDIF}

    D3DX_16F_RADIX = 2; // exponent radix
    D3DX_16F_ROUNDS = 1; // addition rounding: near

    {$IFDEF USESDK43}
    // {C7885BA7-F990-4fe7-922D-8515E477DD85}
    IID_ID3DXMatrixStack: TGUID = '{C7885BA7-F990-4FE7-922D-8515E477DD85}';
    {$ELSE}
    // {E3357330-CC5E-11d2-A434-00A0C90629A8}
    IID_ID3DXMatrixStack: TGUID = '{E3357330-CC5E-11D2-A434-00A0C90629A8}';
    {$ENDIF}

    //============================================================================
    //  Basic Spherical Harmonic math routines
    //============================================================================

    D3DXSH_MINORDER = 2;
    D3DXSH_MAXORDER = 6;

type

    { TD3DXFLOAT16 }

    TD3DXFLOAT16 = record
        Value: word;
        class operator Explicit(a: TD3DXFLOAT16): single;
        class operator Equal(a: TD3DXFLOAT16; b: TD3DXFLOAT16): boolean;
        class operator  NotEqual(a: TD3DXFLOAT16; b: TD3DXFLOAT16): boolean;
        procedure Init(f: single); overload;
        procedure Init(f: TD3DXFLOAT16); overload;

    end;
    LPD3DXFLOAT16 = ^TD3DXFLOAT16;
    PD3DXFLOAT16 = ^TD3DXFLOAT16;

    //===========================================================================

    // Vectors

    //===========================================================================


    //--------------------------
    // 2D Vector
    //--------------------------

    { TD3DXVECTOR2 }

    TD3DXVECTOR2 = record
        class operator Initialize(var aRec: TD3DXVECTOR2);
        procedure Init(pf: PSingle); overload;
        procedure Init(f: PD3DXFLOAT16); overload;
        procedure Init(fx, fy: single); overload;

        // casting
        class operator Explicit(a: TD3DXVECTOR2): PSingle;

        // assignment operators
        class operator Add(a: TD3DXVECTOR2; b: TD3DXVECTOR2): TD3DXVECTOR2;
        class operator Subtract(a: TD3DXVECTOR2; b: TD3DXVECTOR2): TD3DXVECTOR2;
        class operator Multiply(a: TD3DXVECTOR2; b: single): TD3DXVECTOR2;
        class operator Divide(a: TD3DXVECTOR2; b: single): TD3DXVECTOR2;

        // unary operators
        class operator Positive(a: TD3DXVECTOR2): TD3DXVECTOR2;
        class operator Negative(a: TD3DXVECTOR2): TD3DXVECTOR2;
        class operator Equal(a: TD3DXVECTOR2; b: TD3DXVECTOR2): boolean;
        class operator  NotEqual(a: TD3DXVECTOR2; b: TD3DXVECTOR2): boolean;
        case integer of
            0: (x, y: single);
            1: (f: array[0..1] of single);

    end;
    LPD3DXVECTOR2 = ^TD3DXVECTOR2;
    PD3DXVECTOR2 = ^TD3DXVECTOR2;

    //--------------------------
    // 2D Vector (16 bit)
    //--------------------------

    { TD3DXVECTOR2_16F }

    TD3DXVECTOR2_16F = record
        x, y: TD3DXFLOAT16;
        class operator Initialize(var aRec: TD3DXVECTOR2_16F);
        procedure Init(f: PSingle); overload;
        procedure Init(f: PD3DXFLOAT16); overload;
        procedure Init(x, y: TD3DXFLOAT16); overload;

        // binary operators
        class operator Equal(a: TD3DXVECTOR2_16F; b: TD3DXVECTOR2_16F): boolean;
        class operator  NotEqual(a: TD3DXVECTOR2_16F; b: TD3DXVECTOR2_16F): boolean;


    end;
    LPD3DXVECTOR2_16F = ^TD3DXVECTOR2_16F;
    PD3DXVECTOR2_16F = ^TD3DXVECTOR2_16F;

    //--------------------------
    // 3D Vector
    //--------------------------

    { TD3DXVECTOR3 }

    TD3DXVECTOR3 = record
        class operator Initialize(var aRec: TD3DXVECTOR3);
        procedure Init(x, y, z: single); overload;
        procedure Init(x: PSingle); overload;
        procedure Init(x: PD3DVECTOR); overload;
        procedure Init(f: PD3DXFLOAT16); overload;

        // casting
        class operator Explicit(a: TD3DXVECTOR3): PSingle;
        class operator Implicit(a: TD3DXVECTOR3): TD3DVector;

        // assignment operators
        class operator Add(a: TD3DXVECTOR3; b: TD3DXVECTOR3): TD3DXVECTOR3;
        class operator Subtract(a: TD3DXVECTOR3; b: TD3DXVECTOR3): TD3DXVECTOR3;
        class operator Multiply(a: TD3DXVECTOR3; b: single): TD3DXVECTOR3;
        class operator Divide(a: TD3DXVECTOR3; b: single): TD3DXVECTOR3;

        // unary operators
        class operator Positive(a: TD3DXVECTOR3): TD3DXVECTOR3;
        class operator Negative(a: TD3DXVECTOR3): TD3DXVECTOR3;

        // binary operators
        class operator Equal(a: TD3DXVECTOR3; b: TD3DXVECTOR3): boolean;
        class operator  NotEqual(a: TD3DXVECTOR3; b: TD3DXVECTOR3): boolean;
        case integer of
            0: (x, y, z: single);
            1: (f: array[0..2] of single);
            2: (t: TD3DVector);

    end;
    PD3DXVECTOR3 = ^TD3DXVECTOR3;
    LPD3DXVECTOR3 = ^TD3DXVECTOR3;


    //--------------------------
    // 3D Vector (16 bit)
    //--------------------------

    { TD3DXVECTOR3_16F }

    TD3DXVECTOR3_16F = record
        x, y, z: TD3DXFLOAT16;
        class operator Initialize(var aRec: TD3DXVECTOR3_16F);
        procedure Init(pf: PSingle); overload;
        procedure Init(v: PD3DVECTOR); overload;
        procedure Init(f: PD3DXFLOAT16); overload;
        procedure Init(x, y, z: TD3DXFLOAT16); overload;

        // casting
        //        class operator Explicit(a: TD3DXVECTOR3_16F): PSingle;

        // binary operators
        class operator Equal(a: TD3DXVECTOR3_16F; b: TD3DXVECTOR3_16F): boolean;
        class operator  NotEqual(a: TD3DXVECTOR3_16F; b: TD3DXVECTOR3_16F): boolean;

    end;
    PD3DXVECTOR3_16F = ^TD3DXVECTOR3_16F;
    LPD3DXVECTOR3_16F = ^TD3DXVECTOR3_16F;

    //--------------------------
    // 4D Vector
    //--------------------------

    { TD3DXVECTOR4 }

    TD3DXVECTOR4 = record
        class operator Initialize(var aRec: TD3DXVECTOR4);
        procedure Init(pf: PSingle); overload;
        procedure Init(f: PD3DXFLOAT16); overload;
        procedure Init(f: PD3DVECTOR; w: single); overload;
        procedure Init(fx, fy, fz, fw: single); overload;

        // casting
        class operator Explicit(a: TD3DXVECTOR4): PSingle;

        // assignment operators
        class operator Add(a: TD3DXVECTOR4; b: TD3DXVECTOR4): TD3DXVECTOR4;
        class operator Subtract(a: TD3DXVECTOR4; b: TD3DXVECTOR4): TD3DXVECTOR4;
        class operator Multiply(a: TD3DXVECTOR4; b: single): TD3DXVECTOR4;
        class operator Divide(a: TD3DXVECTOR4; b: single): TD3DXVECTOR4;

        // unary operators
        class operator Positive(a: TD3DXVECTOR4): TD3DXVECTOR4;
        class operator Negative(a: TD3DXVECTOR4): TD3DXVECTOR4;
        class operator Equal(a: TD3DXVECTOR4; v: TD3DXVECTOR4): boolean;
        class operator  NotEqual(a: TD3DXVECTOR4; v: TD3DXVECTOR4): boolean;
        case integer of
            0: (x, y, z, w: single);
            1: (f: array [0..3] of single);
    end;
    PD3DXVECTOR4 = ^TD3DXVECTOR4;
    LPD3DXVECTOR4 = ^TD3DXVECTOR4;


    //--------------------------
    // 4D Vector (16 bit)
    //--------------------------

    { TD3DXVECTOR4_16F }

    TD3DXVECTOR4_16F = record
        class operator Initialize(var aRec: TD3DXVECTOR4_16F);
        procedure Init(pf: PSingle); overload;
        procedure Init(f: PD3DXFLOAT16); overload;
        procedure Init(xyz: PD3DXVECTOR3_16F; w: TD3DXFLOAT16); overload;
        procedure Init(x, y, z, w: TD3DXFLOAT16); overload;

        // casting
        class operator Explicit(a: TD3DXVECTOR4_16F): PD3DXFLOAT16;

        // binary operators
        class operator Equal(a: TD3DXVECTOR4_16F; b: TD3DXVECTOR4_16F): boolean;
        class operator  NotEqual(a: TD3DXVECTOR4_16F; b: TD3DXVECTOR4_16F): boolean;
        case integer of
            0: (x, y, z, w: TD3DXFLOAT16);
            1: (f: array[0..3] of TD3DXFLOAT16);
    end;
    PD3DXVECTOR4_16F = ^TD3DXVECTOR4_16F;
    LPD3DXVECTOR4_16F = ^TD3DXVECTOR4_16F;

    //===========================================================================

    // Matrices

    //===========================================================================

    { TD3DXMATRIX }

    TD3DXMATRIX = record
        class operator Initialize(var aRec: TD3DXMATRIX);
        procedure Init(x: PD3DMATRIX); overload;
        procedure Init(pf: PD3DXFLOAT16); overload;
        procedure Init(pf: PSingle); overload;
        procedure Initf(f11, f12, f13, f14, f21, f22, f23, f24, f31, f32, f33, f34, f41, f42, f43, f44: single); overload;
        // access grants
        function Element(Row: UINT; Col: UINT): single;
        // casting operators
        class operator Explicit(a: TD3DXMATRIX): PSingle;
        // assignment operators
        class operator Add(a: TD3DXMATRIX; b: TD3DXMATRIX): TD3DXMATRIX;
        class operator Subtract(a: TD3DXMATRIX; b: TD3DXMATRIX): TD3DXMATRIX;
        class operator Multiply(a: TD3DXMATRIX; b: TD3DXMATRIX): TD3DXMATRIX;
        class operator Multiply(a: TD3DXMATRIX; b: single): TD3DXMATRIX;
        class operator Divide(a: TD3DXMATRIX; b: single): TD3DXMATRIX;

        // unary operators
        class operator Positive(a: TD3DXMATRIX): TD3DXMATRIX;
        class operator Negative(a: TD3DXMATRIX): TD3DXMATRIX;
        class operator Equal(a: TD3DXMATRIX; b: TD3DXMATRIX): boolean;
        class operator  NotEqual(a: TD3DXMATRIX; b: TD3DXMATRIX): boolean;
        case integer of
            0: (
                _11, _12, _13, _14: single;
                _21, _22, _23, _24: single;
                _31, _32, _33, _34: single;
                _41, _42, _43, _44: single;
            );
            1: (
                m: array [0..3, 0..3] of single;
            );
            2: (f: array[0..15] of single);
    end;
    LPD3DXMATRIX = ^TD3DXMATRIX;
    PD3DXMATRIX = ^TD3DXMATRIX;


    //---------------------------------------------------------------------------
    // Aligned Matrices

    // This class helps keep matrices 16-byte aligned as preferred by P4 cpus.
    // It aligns matrices on the stack and on the heap or in global scope.
    // It does this using __declspec(align(16)) which works on VC7 and on VC 6
    // with the processor pack. Unfortunately there is no way to detect the
    // latter so this is turned on only on VC7. On other compilers this is the
    // the same as D3DXMATRIX.

    // Using this class on a compiler that does not actually do the alignment
    // can be dangerous since it will not expose bugs that ignore alignment.
    // E.g if an object of this class in inside a struct or class, and some code
    // memcopys data in it assuming tight packing. This could break on a compiler
    // that eventually start aligning the matrix.
    //---------------------------------------------------------------------------

    { TD3DXMATRIXA16 }

    TD3DXMATRIXA16 = record
        class operator Initialize(var aRec: TD3DXMATRIXA16);
        procedure Init(x: PD3DMATRIX); overload;
        procedure Init(pf: PD3DXFLOAT16); overload;
        procedure Init(x: PSingle); overload;


        procedure Initf(f11, f12, f13, f14, f21, f22, f23, f24, f31, f32, f33, f34, f41, f42, f43, f44: single); overload;


        // access grants
        function Element(Row: UINT; Col: UINT): single;

        // casting operators
        class operator Explicit(a: TD3DXMATRIXA16): PSingle;
        class operator Explicit(a: TD3DXMATRIXA16): TD3DXMATRIX;

        // assignment operators
        class operator Add(a: TD3DXMATRIXA16; b: TD3DXMATRIXA16): TD3DXMATRIXA16;
        class operator Subtract(a: TD3DXMATRIXA16; b: TD3DXMATRIXA16): TD3DXMATRIXA16;
        class operator Multiply(a: TD3DXMATRIXA16; b: TD3DXMATRIXA16): TD3DXMATRIXA16;
        class operator Multiply(a: TD3DXMATRIXA16; b: single): TD3DXMATRIXA16;
        class operator Divide(a: TD3DXMATRIXA16; b: single): TD3DXMATRIXA16;

        // unary operators
        class operator Positive(a: TD3DXMATRIXA16): TD3DXMATRIXA16;
        class operator Negative(a: TD3DXMATRIXA16): TD3DXMATRIXA16;
        class operator Equal(a: TD3DXMATRIXA16; b: TD3DXMATRIXA16): boolean;
        class operator  NotEqual(a: TD3DXMATRIXA16; b: TD3DXMATRIXA16): boolean;
        case integer of
            0: (
                _11, _12, _13, _14: single;
                _21, _22, _23, _24: single;
                _31, _32, _33, _34: single;
                _41, _42, _43, _44: single;
            );
            1: (
                m: array [0..3, 0..3] of single;
            );
            2: (f: array[0..15] of single);
    end align (16);
    PD3DXMATRIXA16 = ^TD3DXMATRIXA16;
    LPD3DXMATRIXA16 = ^TD3DXMATRIXA16;


    //===========================================================================

    //    Quaternions

    //===========================================================================


    { TD3DXQUATERNION }

    TD3DXQUATERNION = record
        class operator Initialize(var aRec: TD3DXQUATERNION);
        procedure Init(pf: PSingle); overload;
        procedure Init(pf: PD3DXFLOAT16); overload;
        procedure Init(fx, fy, fz, fw: single); overload;

        // casting
        class operator Explicit(a: TD3DXQUATERNION): PSingle;

        // assignment operators
        class operator Add(a: TD3DXQUATERNION; b: TD3DXQUATERNION): TD3DXQUATERNION;
        class operator Subtract(a: TD3DXQUATERNION; b: TD3DXQUATERNION): TD3DXQUATERNION;
        class operator Multiply(a: TD3DXQUATERNION; b: TD3DXQUATERNION): TD3DXQUATERNION;
        class operator Multiply(a: TD3DXQUATERNION; b: single): TD3DXQUATERNION;
        class operator Divide(a: TD3DXQUATERNION; b: single): TD3DXQUATERNION;

        // unary operators
        class operator Positive(a: TD3DXQUATERNION): TD3DXQUATERNION;
        class operator Negative(a: TD3DXQUATERNION): TD3DXQUATERNION;
        class operator Equal(a: TD3DXQUATERNION; q: TD3DXQUATERNION): boolean;
        class operator  NotEqual(a: TD3DXQUATERNION; q: TD3DXQUATERNION): boolean;
        case integer of
            0: (x, y, z, w: single);
            1: (f: array [0..3] of single);
    end;
    LPD3DXQUATERNION = ^TD3DXQUATERNION;
    PD3DXQUATERNION = ^TD3DXQUATERNION;

    //===========================================================================

    // Planes

    //===========================================================================

    { TD3DXPLANE }

    TD3DXPLANE = record
        class operator Initialize(var aRec: TD3DXPLANE);
        procedure Init(f: PSingle); overload;
        procedure Init(pf: PD3DXFLOAT16); overload;
        procedure Init(a, b, c, d: single); overload;

        // casting
        class operator Explicit(a: TD3DXPLANE): PSingle;
        class operator Multiply(a: TD3DXPLANE; b: single): TD3DXPLANE;
        class operator Divide(a: TD3DXPLANE; b: single): TD3DXPLANE;
        // unary operators
        class operator Positive(a: TD3DXPLANE): TD3DXPLANE;
        class operator Negative(a: TD3DXPLANE): TD3DXPLANE;

        // binary operators
        class operator Equal(a: TD3DXPLANE; p: TD3DXPLANE): boolean;
        class operator  NotEqual(a: TD3DXPLANE; p: TD3DXPLANE): boolean;
        case integer of
            0: (a, b, c, d: single);
            1: (f: array[0..3] of single);
    end;
    PD3DXPLANE = ^TD3DXPLANE;
    LPD3DXPLANE = ^TD3DXPLANE;

    //===========================================================================

    // Colors

    //===========================================================================

    { TD3DXCOLOR }

    TD3DXCOLOR = record
        class operator Initialize(var aRec: TD3DXCOLOR);
        procedure Init(argb: DWORD); overload;
        procedure Init(f: PSingle); overload;
        procedure Init(pf: PD3DXFLOAT16); overload;
        procedure Init(f: TD3DCOLORVALUE); overload;
        procedure Init(r, g, b, a: single); overload;

        // casting
        class operator Explicit(a: TD3DXCOLOR): DWORD;
        class operator Explicit(a: TD3DXCOLOR): PSingle;
        class operator Explicit(a: TD3DXCOLOR): PD3DCOLORVALUE;
        class operator Explicit(a: TD3DXCOLOR): TD3DCOLORVALUE;

        // assignment operators
        class operator Add(a: TD3DXCOLOR; b: TD3DXCOLOR): TD3DXCOLOR;
        class operator Subtract(a: TD3DXCOLOR; b: TD3DXCOLOR): TD3DXCOLOR;
        class operator Multiply(a: TD3DXCOLOR; b: single): TD3DXCOLOR;
        class operator Divide(a: TD3DXCOLOR; b: single): TD3DXCOLOR;

        // unary operators
        class operator Positive(a: TD3DXCOLOR): TD3DXCOLOR;
        class operator Negative(a: TD3DXCOLOR): TD3DXCOLOR;

        // binary operators

        class operator Equal(a: TD3DXCOLOR; c: TD3DXCOLOR): boolean;
        class operator  NotEqual(a: TD3DXCOLOR; c: TD3DXCOLOR): boolean;
        case integer of
            0: (r, g, b, a: single);
            1: (f: array[0..3] of single);
            2: (c: TD3DCOLORVALUE);
    end;
    PD3DXCOLOR = ^TD3DXCOLOR;
    LPD3DXCOLOR = ^TD3DXCOLOR;


    //===========================================================================

    //    Matrix Stack

    //===========================================================================

    ID3DXMatrixStack = interface(IUnknown)
        ['{E3357330-CC5E-11D2-A434-00A0C90629A8}']

        // ID3DXMatrixStack methods

        // Pops the top of the stack, returns the current top
        // *after* popping the top.
        function Pop(): HRESULT; stdcall;

        // Pushes the stack by one, duplicating the current matrix.
        function Push(): HRESULT; stdcall;

        // Loads identity in the current matrix.
        function LoadIdentity(): HRESULT; stdcall;

        // Loads the given matrix into the current matrix
        function LoadMatrix(pM: PD3DXMATRIX): HRESULT; stdcall;

        // Right-Multiplies the given matrix to the current matrix.
        // (transformation is about the current world origin)
        function MultMatrix(pM: PD3DXMATRIX): HRESULT; stdcall;

        // Left-Multiplies the given matrix to the current matrix
        // (transformation is about the local origin of the object)
        function MultMatrixLocal(pM: PD3DXMATRIX): HRESULT; stdcall;

        // Right multiply the current matrix with the computed rotation
        // matrix, counterclockwise about the given axis with the given angle.
        // (rotation is about the current world origin)
        function RotateAxis(pV: PD3DXVECTOR3; Angle: single): HRESULT; stdcall;

        // Left multiply the current matrix with the computed rotation
        // matrix, counterclockwise about the given axis with the given angle.
        // (rotation is about the local origin of the object)
        function RotateAxisLocal(pV: PD3DXVECTOR3; Angle: single): HRESULT; stdcall;

        // Right multiply the current matrix with the computed rotation
        // matrix. All angles are counterclockwise. (rotation is about the
        // current world origin)
        // The rotation is composed of a yaw around the Y axis, a pitch around
        // the X axis, and a roll around the Z axis.
        function RotateYawPitchRoll(Yaw: single; Pitch: single; Roll: single): HRESULT; stdcall;

        // Left multiply the current matrix with the computed rotation
        // matrix. All angles are counterclockwise. (rotation is about the
        // local origin of the object)
        // The rotation is composed of a yaw around the Y axis, a pitch around
        // the X axis, and a roll around the Z axis.
        function RotateYawPitchRollLocal(Yaw: single; Pitch: single; Roll: single): HRESULT; stdcall;

        // Right multiply the current matrix with the computed scale
        // matrix. (transformation is about the current world origin)
        function Scale(x: single; y: single; z: single): HRESULT; stdcall;

        // Left multiply the current matrix with the computed scale
        // matrix. (transformation is about the local origin of the object)
        function ScaleLocal(x: single; y: single; z: single): HRESULT; stdcall;

        // Right multiply the current matrix with the computed translation
        // matrix. (transformation is about the current world origin)
        function Translate(x: single; y: single; z: single): HRESULT; stdcall;

        // Left multiply the current matrix with the computed translation
        // matrix. (transformation is about the local origin of the object)
        function TranslateLocal(x: single; y: single; z: single): HRESULT; stdcall;

        // Obtain the current matrix at the top of the stack
        function GetTop(): PD3DXMATRIX; stdcall;

    end;

    PID3DXMatrixStack = ^ID3DXMatrixStack;
    LPD3DXMATRIXSTACK = ^ID3DXMatrixStack;

    {$PACKRECORDS DEFAULT}


    //===========================================================================
    // D3DX math functions:
    // NOTE:
    //  * All these functions can take the same object as in and out parameters.
    //  * Out parameters are typically also returned as return values, so that
    //    the output of one function may be used as a parameter to another.
    //===========================================================================


    //--------------------------
    // Float16
    //--------------------------

// non-inline
// Converts an array 32-bit floats to 16-bit floats
function D3DXFloat32To16Array(pOut: PD3DXFLOAT16; pIn: Psingle; n: UINT): PD3DXFLOAT16; stdcall; external D3DX9_DLL;


// Converts an array 16-bit floats to 32-bit floats
function D3DXFloat16To32Array(pOut: Psingle; pIn: PD3DXFLOAT16; n: UINT): single; stdcall; external D3DX9_DLL;


//--------------------------
// 2D Vector
//--------------------------
// inline


function D3DXVec2Length(pV: PD3DXVECTOR2): single;


function D3DXVec2LengthSq(pV: PD3DXVECTOR2): single;


function D3DXVec2Dot(pV1: PD3DXVECTOR2; pV2: PD3DXVECTOR2): single;


// Z component of ((x1,y1,0) cross (x2,y2,0))
function D3DXVec2CCW(pV1: PD3DXVECTOR2; pV2: PD3DXVECTOR2): single;


function D3DXVec2Add(pOut: PD3DXVECTOR2; pV1: PD3DXVECTOR2; pV2: PD3DXVECTOR2): TD3DXVECTOR2;


function D3DXVec2Subtract(pOut: PD3DXVECTOR2; pV1: PD3DXVECTOR2; pV2: PD3DXVECTOR2): TD3DXVECTOR2;


// Minimize each component.  x = min(x1, x2), y = min(y1, y2)
function D3DXVec2Minimize(pOut: PD3DXVECTOR2; pV1: PD3DXVECTOR2; pV2: PD3DXVECTOR2): TD3DXVECTOR2;


// Maximize each component.  x = max(x1, x2), y = max(y1, y2)
function D3DXVec2Maximize(pOut: PD3DXVECTOR2; pV1: PD3DXVECTOR2; pV2: PD3DXVECTOR2): TD3DXVECTOR2;


function D3DXVec2Scale(pOut: PD3DXVECTOR2; pV: PD3DXVECTOR2; s: single): TD3DXVECTOR2;


// Linear interpolation. V1 + s(V2-V1)
function D3DXVec2Lerp(pOut: PD3DXVECTOR2; pV1: PD3DXVECTOR2; pV2: PD3DXVECTOR2; s: single): TD3DXVECTOR2;


// non-inline


function D3DXVec2Normalize(pOut: PD3DXVECTOR2; pV: PD3DXVECTOR2): PD3DXVECTOR2; stdcall; external D3DX9_DLL;


// Hermite interpolation between position V1, tangent T1 (when s == 0)
// and position V2, tangent T2 (when s == 1).
function D3DXVec2Hermite(pOut: PD3DXVECTOR2; pV1: PD3DXVECTOR2; pT1: PD3DXVECTOR2; pV2: PD3DXVECTOR2; pT2: PD3DXVECTOR2; s: single): PD3DXVECTOR2; stdcall; external D3DX9_DLL;


// CatmullRom interpolation between V1 (when s == 0) and V2 (when s == 1)
function D3DXVec2CatmullRom(pOut: PD3DXVECTOR2; pV0: PD3DXVECTOR2; pV1: PD3DXVECTOR2; pV2: PD3DXVECTOR2; pV3: PD3DXVECTOR2; s: single): PD3DXVECTOR2; stdcall; external D3DX9_DLL;


// Barycentric coordinates.  V1 + f(V2-V1) + g(V3-V1)
function D3DXVec2BaryCentric(pOut: PD3DXVECTOR2; pV1: PD3DXVECTOR2; pV2: PD3DXVECTOR2; pV3: PD3DXVECTOR2; f: single; g: single): PD3DXVECTOR2; stdcall; external D3DX9_DLL;


// Transform (x, y, 0, 1) by matrix.
function D3DXVec2Transform(pOut: PD3DXVECTOR4; pV: PD3DXVECTOR2; pM: PD3DXMATRIX): PD3DXVECTOR4; stdcall; external D3DX9_DLL;


// Transform (x, y, 0, 1) by matrix, project result back into w=1.
function D3DXVec2TransformCoord(pOut: PD3DXVECTOR2; pV: PD3DXVECTOR2; pM: PD3DXMATRIX): PD3DXVECTOR2; stdcall; external D3DX9_DLL;


// Transform (x, y, 0, 0) by matrix.
function D3DXVec2TransformNormal(pOut: PD3DXVECTOR2; pV: PD3DXVECTOR2; pM: PD3DXMATRIX): PD3DXVECTOR2; stdcall; external D3DX9_DLL;


// Transform Array (x, y, 0, 1) by matrix.
function D3DXVec2TransformArray(pOut: PD3DXVECTOR4; OutStride: UINT; pV: PD3DXVECTOR2; VStride: UINT; pM: PD3DXMATRIX; n: UINT): PD3DXVECTOR4; stdcall; external D3DX9_DLL;


// Transform Array (x, y, 0, 1) by matrix, project result back into w=1.
function D3DXVec2TransformCoordArray(pOut: PD3DXVECTOR2; OutStride: UINT; pV: PD3DXVECTOR2; VStride: UINT; pM: PD3DXMATRIX; n: UINT): PD3DXVECTOR2; stdcall; external D3DX9_DLL;


// Transform Array (x, y, 0, 0) by matrix.
function D3DXVec2TransformNormalArray(pOut: PD3DXVECTOR2; OutStride: UINT; pV: PD3DXVECTOR2; VStride: UINT; pM: PD3DXMATRIX; n: UINT): PD3DXVECTOR2; stdcall; external D3DX9_DLL;

//--------------------------
// 3D Vector
//--------------------------

// inline
function D3DXVector3(x, y, z: single): TD3DXVECTOR3;

function D3DXVec3Length(pV: PD3DXVECTOR3): single;


function D3DXVec3LengthSq(pV: PD3DXVECTOR3): single;


function D3DXVec3Dot(pV1: PD3DXVECTOR3; pV2: PD3DXVECTOR3): single;


function D3DXVec3Cross(pOut: PD3DXVECTOR3; pV1: PD3DXVECTOR3; pV2: PD3DXVECTOR3): TD3DXVECTOR3;


function D3DXVec3Add(pOut: PD3DXVECTOR3; pV1: PD3DXVECTOR3; pV2: PD3DXVECTOR3): TD3DXVECTOR3;


function D3DXVec3Subtract(pOut: PD3DXVECTOR3; pV1: PD3DXVECTOR3; pV2: PD3DXVECTOR3): TD3DXVECTOR3;


// Minimize each component.  x = min(x1, x2), y = min(y1, y2), ...
function D3DXVec3Minimize(pOut: PD3DXVECTOR3; pV1: PD3DXVECTOR3; pV2: PD3DXVECTOR3): TD3DXVECTOR3;


// Maximize each component.  x = max(x1, x2), y = max(y1, y2), ...
function D3DXVec3Maximize(pOut: PD3DXVECTOR3; pV1: PD3DXVECTOR3; pV2: PD3DXVECTOR3): TD3DXVECTOR3;


function D3DXVec3Scale(pOut: PD3DXVECTOR3; pV: PD3DXVECTOR3; s: single): TD3DXVECTOR3;


// Linear interpolation. V1 + s(V2-V1)
function D3DXVec3Lerp(pOut: PD3DXVECTOR3; pV1: PD3DXVECTOR3; pV2: PD3DXVECTOR3; s: single): TD3DXVECTOR3;


// non-inline


function D3DXVec3Normalize(pOut: PD3DXVECTOR3; pV: PD3DXVECTOR3): PD3DXVECTOR3; stdcall; external D3DX9_DLL;


// Hermite interpolation between position V1, tangent T1 (when s == 0)
// and position V2, tangent T2 (when s == 1).
function D3DXVec3Hermite(pOut: PD3DXVECTOR3; pV1: PD3DXVECTOR3; pT1: PD3DXVECTOR3; pV2: PD3DXVECTOR3; pT2: PD3DXVECTOR3; s: single): PD3DXVECTOR3; stdcall; external D3DX9_DLL;


// CatmullRom interpolation between V1 (when s == 0) and V2 (when s == 1)
function D3DXVec3CatmullRom(pOut: PD3DXVECTOR3; pV0: PD3DXVECTOR3; pV1: PD3DXVECTOR3; pV2: PD3DXVECTOR3; pV3: PD3DXVECTOR3; s: single): PD3DXVECTOR3; stdcall; external D3DX9_DLL;


// Barycentric coordinates.  V1 + f(V2-V1) + g(V3-V1)
function D3DXVec3BaryCentric(pOut: PD3DXVECTOR3; pV1: PD3DXVECTOR3; pV2: PD3DXVECTOR3; pV3: PD3DXVECTOR3; f: single; g: single): PD3DXVECTOR3; stdcall; external D3DX9_DLL;


// Transform (x, y, z, 1) by matrix.
function D3DXVec3Transform(pOut: PD3DXVECTOR4; pV: PD3DXVECTOR3; pM: PD3DXMATRIX): PD3DXVECTOR4; stdcall; external D3DX9_DLL;


// Transform (x, y, z, 1) by matrix, project result back into w=1.
function D3DXVec3TransformCoord(pOut: PD3DXVECTOR3; pV: PD3DXVECTOR3; pM: PD3DXMATRIX): PD3DXVECTOR3; stdcall; external D3DX9_DLL;


// Transform (x, y, z, 0) by matrix.  If you transforming a normal by a
// non-affine matrix, the matrix you pass to this function should be the
// transpose of the inverse of the matrix you would use to transform a coord.
function D3DXVec3TransformNormal(pOut: PD3DXVECTOR3; pV: PD3DXVECTOR3; pM: PD3DXMATRIX): PD3DXVECTOR3; stdcall; external D3DX9_DLL;


// Transform Array (x, y, z, 1) by matrix.
function D3DXVec3TransformArray(pOut: PD3DXVECTOR4; OutStride: UINT; pV: PD3DXVECTOR3; VStride: UINT; pM: PD3DXMATRIX; n: UINT): PD3DXVECTOR4; stdcall; external D3DX9_DLL;


// Transform Array (x, y, z, 1) by matrix, project result back into w=1.
function D3DXVec3TransformCoordArray(pOut: PD3DXVECTOR3; OutStride: UINT; pV: PD3DXVECTOR3; VStride: UINT; pM: PD3DXMATRIX; n: UINT): PD3DXVECTOR3; stdcall; external D3DX9_DLL;


// Transform (x, y, z, 0) by matrix.  If you transforming a normal by a
// non-affine matrix, the matrix you pass to this function should be the
// transpose of the inverse of the matrix you would use to transform a coord.
function D3DXVec3TransformNormalArray(pOut: PD3DXVECTOR3; OutStride: UINT; pV: PD3DXVECTOR3; VStride: UINT; pM: PD3DXMATRIX; n: UINT): PD3DXVECTOR3; stdcall; external D3DX9_DLL;


// Project vector from object space into screen space
function D3DXVec3Project(pOut: PD3DXVECTOR3; pV: PD3DXVECTOR3; pViewport: PD3DVIEWPORT9; pProjection: PD3DXMATRIX; pView: PD3DXMATRIX; pWorld: PD3DXMATRIX): PD3DXVECTOR3; stdcall; external D3DX9_DLL;


// Project vector from screen space into object space
function D3DXVec3Unproject(pOut: PD3DXVECTOR3; pV: PD3DXVECTOR3; pViewport: PD3DVIEWPORT9; pProjection: PD3DXMATRIX; pView: PD3DXMATRIX; pWorld: PD3DXMATRIX): PD3DXVECTOR3; stdcall; external D3DX9_DLL;


// Project vector Array from object space into screen space
function D3DXVec3ProjectArray(pOut: PD3DXVECTOR3; OutStride: UINT; pV: PD3DXVECTOR3; VStride: UINT; pViewport: PD3DVIEWPORT9; pProjection: PD3DXMATRIX; pView: PD3DXMATRIX; pWorld: PD3DXMATRIX; n: UINT): PD3DXVECTOR3; stdcall; external D3DX9_DLL;


// Project vector Array from screen space into object space
function D3DXVec3UnprojectArray(pOut: PD3DXVECTOR3; OutStride: UINT; pV: PD3DXVECTOR3; VStride: UINT; pViewport: PD3DVIEWPORT9; pProjection: PD3DXMATRIX; pView: PD3DXMATRIX; pWorld: PD3DXMATRIX; n: UINT): PD3DXVECTOR3; stdcall; external D3DX9_DLL;

//--------------------------
// 4D Vector
//--------------------------

// inline


function D3DXVec4Length(pV: PD3DXVECTOR4): single;


function D3DXVec4LengthSq(pV: PD3DXVECTOR4): single;


function D3DXVec4Dot(pV1: PD3DXVECTOR4; pV2: PD3DXVECTOR4): single;


function D3DXVec4Add(pOut: PD3DXVECTOR4; pV1: PD3DXVECTOR4; pV2: PD3DXVECTOR4): TD3DXVECTOR4;


function D3DXVec4Subtract(pOut: PD3DXVECTOR4; pV1: PD3DXVECTOR4; pV2: PD3DXVECTOR4): TD3DXVECTOR4;


// Minimize each component.  x = min(x1, x2), y = min(y1, y2), ...
function D3DXVec4Minimize(pOut: PD3DXVECTOR4; pV1: PD3DXVECTOR4; pV2: PD3DXVECTOR4): TD3DXVECTOR4;


// Maximize each component.  x = max(x1, x2), y = max(y1, y2), ...
function D3DXVec4Maximize(pOut: PD3DXVECTOR4; pV1: PD3DXVECTOR4; pV2: PD3DXVECTOR4): TD3DXVECTOR4;


function D3DXVec4Scale(pOut: PD3DXVECTOR4; pV: PD3DXVECTOR4; s: single): TD3DXVECTOR4;


// Linear interpolation. V1 + s(V2-V1)
function D3DXVec4Lerp(pOut: PD3DXVECTOR4; pV1: PD3DXVECTOR4; pV2: PD3DXVECTOR4; s: single): TD3DXVECTOR4;


// non-inline
// Cross-product in 4 dimensions.

function D3DXVec4Cross(pOut: PD3DXVECTOR4; pV1: PD3DXVECTOR4; pV2: PD3DXVECTOR4; pV3: PD3DXVECTOR4): TD3DXVECTOR4; stdcall; external D3DX9_DLL;


function D3DXVec4Normalize(pOut: PD3DXVECTOR4; pV: PD3DXVECTOR4): TD3DXVECTOR4; stdcall; external D3DX9_DLL;


// Hermite interpolation between position V1, tangent T1 (when s == 0)
// and position V2, tangent T2 (when s == 1).
function D3DXVec4Hermite(pOut: PD3DXVECTOR4; pV1: PD3DXVECTOR4; pT1: PD3DXVECTOR4; pV2: PD3DXVECTOR4; pT2: PD3DXVECTOR4; s: single): TD3DXVECTOR4; stdcall; external D3DX9_DLL;


// CatmullRom interpolation between V1 (when s == 0) and V2 (when s == 1)
function D3DXVec4CatmullRom(pOut: PD3DXVECTOR4; pV0: PD3DXVECTOR4; pV1: PD3DXVECTOR4; pV2: PD3DXVECTOR4; pV3: PD3DXVECTOR4; s: single): TD3DXVECTOR4; stdcall; external D3DX9_DLL;


// Barycentric coordinates.  V1 + f(V2-V1) + g(V3-V1)
function D3DXVec4BaryCentric(pOut: PD3DXVECTOR4; pV1: PD3DXVECTOR4; pV2: PD3DXVECTOR4; pV3: PD3DXVECTOR4; f: single; g: single): TD3DXVECTOR4; stdcall; external D3DX9_DLL;


// Transform vector by matrix.
function D3DXVec4Transform(pOut: PD3DXVECTOR4; pV: PD3DXVECTOR4; pM: PD3DXMATRIX): TD3DXVECTOR4; stdcall; external D3DX9_DLL;


// Transform vector array by matrix.
function D3DXVec4TransformArray(pOut: PD3DXVECTOR4; OutStride: UINT; pV: PD3DXVECTOR4; VStride: UINT; pM: PD3DXMATRIX; n: UINT): TD3DXVECTOR4; stdcall; external D3DX9_DLL;


//--------------------------
// 4D Matrix
//--------------------------
// inline


function D3DXMatrixIdentity(pOut: PD3DXMATRIX): TD3DXMATRIX;


function D3DXMatrixIsIdentity(pM: PD3DXMATRIX): boolean;


// non-inline

function D3DXMatrixDeterminant(pM: PD3DXMATRIX): single; stdcall; external D3DX9_DLL;

{$IFDEF USESDK43 }
function D3DXMatrixDecompose(pOutScale: PD3DXVECTOR3; pOutRotation: PD3DXQUATERNION; pOutTranslation: PD3DXVECTOR3; pM: PD3DXMATRIX): HRESULT; stdcall; external D3DX9_DLL;
{$ENDIF}


function D3DXMatrixTranspose(pOut: PD3DXMATRIX; pM: PD3DXMATRIX): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Matrix multiplication.  The result represents the transformation M2
// followed by the transformation M1.  (Out = M1 * M2)
function D3DXMatrixMultiply(pOut: PD3DXMATRIX; pM1: PD3DXMATRIX; pM2: PD3DXMATRIX): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Matrix multiplication, followed by a transpose. (Out = T(M1 * M2))
function D3DXMatrixMultiplyTranspose(pOut: PD3DXMATRIX; pM1: PD3DXMATRIX; pM2: PD3DXMATRIX): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Calculate inverse of matrix.  Inversion my fail, in which case NULL will
// be returned.  The determinant of pM is also returned it pfDeterminant
// is non-NULL.
function D3DXMatrixInverse(pOut: PD3DXMATRIX; pDeterminant: Psingle; pM: PD3DXMATRIX): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Build a matrix which scales by (sx, sy, sz)
function D3DXMatrixScaling(pOut: PD3DXMATRIX; sx: single; sy: single; sz: single): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Build a matrix which translates by (x, y, z)
function D3DXMatrixTranslation(pOut: PD3DXMATRIX; x: single; y: single; z: single): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Build a matrix which rotates around the X axis
function D3DXMatrixRotationX(pOut: PD3DXMATRIX; Angle: single): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Build a matrix which rotates around the Y axis
function D3DXMatrixRotationY(pOut: PD3DXMATRIX; Angle: single): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Build a matrix which rotates around the Z axis
function D3DXMatrixRotationZ(pOut: PD3DXMATRIX; Angle: single): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Build a matrix which rotates around an arbitrary axis
function D3DXMatrixRotationAxis(pOut: PD3DXMATRIX; pV: PD3DXVECTOR3; Angle: single): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Build a matrix from a quaternion
function D3DXMatrixRotationQuaternion(pOut: PD3DXMATRIX; pQ: PD3DXQUATERNION): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Yaw around the Y axis, a pitch around the X axis,
// and a roll around the Z axis.
function D3DXMatrixRotationYawPitchRoll(pOut: PD3DXMATRIX; Yaw: single; Pitch: single; Roll: single): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Build transformation matrix.  NULL arguments are treated as identity.
// Mout = Msc-1 * Msr-1 * Ms * Msr * Msc * Mrc-1 * Mr * Mrc * Mt
function D3DXMatrixTransformation(pOut: PD3DXMATRIX; pScalingCenter: PD3DXVECTOR3; pScalingRotation: PD3DXQUATERNION; pScaling: PD3DXVECTOR3; pRotationCenter: PD3DXVECTOR3; pRotation: PD3DXQUATERNION;
    pTranslation: PD3DXVECTOR3): PD3DXMATRIX; stdcall; external D3DX9_DLL;

{$IFDEF USESDK43 }
// Build 2D transformation matrix in XY plane.  NULL arguments are treated as identity.
// Mout = Msc-1 * Msr-1 * Ms * Msr * Msc * Mrc-1 * Mr * Mrc * Mt
function D3DXMatrixTransformation2D(pOut: PD3DXMATRIX; pScalingCenter: PD3DXVECTOR2; ScalingRotation: single; pScaling: PD3DXVECTOR2; pRotationCenter: PD3DXVECTOR2; Rotation: single;
    pTranslation: PD3DXVECTOR2): TD3DXMATRIX; stdcall; external D3DX9_DLL;
{$ENDIF}


// Build affine transformation matrix.  NULL arguments are treated as identity.
// Mout = Ms * Mrc-1 * Mr * Mrc * Mt
function D3DXMatrixAffineTransformation(pOut: PD3DXMATRIX; Scaling: single; pRotationCenter: PD3DXVECTOR3; pRotation: PD3DXQUATERNION; pTranslation: PD3DXVECTOR3): PD3DXMATRIX; stdcall; external D3DX9_DLL;

{$IFDEF USESDK43 }
// Build 2D affine transformation matrix in XY plane.  NULL arguments are treated as identity.
// Mout = Ms * Mrc-1 * Mr * Mrc * Mt
function D3DXMatrixAffineTransformation2D(pOut: PD3DXMATRIX; Scaling: single; pRotationCenter: PD3DXVECTOR2; Rotation: single; pTranslation: PD3DXVECTOR2): TD3DXMATRIX; stdcall; external D3DX9_DLL;
{$ENDIF}


// Build a lookat matrix. (right-handed)
function D3DXMatrixLookAtRH(pOut: PD3DXMATRIX; pEye: PD3DXVECTOR3; pAt: PD3DXVECTOR3; pUp: PD3DXVECTOR3): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Build a lookat matrix. (left-handed)
function D3DXMatrixLookAtLH(pOut: PD3DXMATRIX; pEye: PD3DXVECTOR3; pAt: PD3DXVECTOR3; pUp: PD3DXVECTOR3): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Build a perspective projection matrix. (right-handed)
function D3DXMatrixPerspectiveRH(pOut: PD3DXMATRIX; w: single; h: single; zn: single; zf: single): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Build a perspective projection matrix. (left-handed)
function D3DXMatrixPerspectiveLH(pOut: PD3DXMATRIX; w: single; h: single; zn: single; zf: single): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Build a perspective projection matrix. (right-handed)
function D3DXMatrixPerspectiveFovRH(pOut: PD3DXMATRIX; fovy: single; Aspect: single; zn: single; zf: single): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Build a perspective projection matrix. (left-handed)
function D3DXMatrixPerspectiveFovLH(pOut: PD3DXMATRIX; fovy: single; Aspect: single; zn: single; zf: single): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Build a perspective projection matrix. (right-handed)
function D3DXMatrixPerspectiveOffCenterRH(pOut: PD3DXMATRIX; l: single; r: single; b: single; t: single; zn: single; zf: single): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Build a perspective projection matrix. (left-handed)
function D3DXMatrixPerspectiveOffCenterLH(pOut: PD3DXMATRIX; l: single; r: single; b: single; t: single; zn: single; zf: single): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Build an ortho projection matrix. (right-handed)
function D3DXMatrixOrthoRH(pOut: PD3DXMATRIX; w: single; h: single; zn: single; zf: single): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Build an ortho projection matrix. (left-handed)
function D3DXMatrixOrthoLH(pOut: PD3DXMATRIX; w: single; h: single; zn: single; zf: single): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Build an ortho projection matrix. (right-handed)
function D3DXMatrixOrthoOffCenterRH(pOut: PD3DXMATRIX; l: single; r: single; b: single; t: single; zn: single; zf: single): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Build an ortho projection matrix. (left-handed)
function D3DXMatrixOrthoOffCenterLH(pOut: PD3DXMATRIX; l: single; r: single; b: single; t: single; zn: single; zf: single): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Build a matrix which flattens geometry into a plane, as if casting
// a shadow from a light.
function D3DXMatrixShadow(pOut: PD3DXMATRIX; pLight: PD3DXVECTOR4; pPlane: PD3DXPLANE): PD3DXMATRIX; stdcall; external D3DX9_DLL;


// Build a matrix which reflects the coordinate system about a plane
function D3DXMatrixReflect(pOut: PD3DXMATRIX; pPlane: PD3DXPLANE): PD3DXMATRIX; stdcall; external D3DX9_DLL;

//--------------------------
// Quaternion
//--------------------------

// inline

function D3DXQuaternionLength(pQ: PD3DXQUATERNION): single;


// Length squared, or "norm"
function D3DXQuaternionLengthSq(pQ: PD3DXQUATERNION): single;


function D3DXQuaternionDot(pQ1: PD3DXQUATERNION; pQ2: PD3DXQUATERNION): single;


// (0, 0, 0, 1)
function D3DXQuaternionIdentity(pOut: PD3DXQUATERNION): TD3DXQUATERNION;


function D3DXQuaternionIsIdentity(pQ: PD3DXQUATERNION): boolean;


// (-x, -y, -z, w)
function D3DXQuaternionConjugate(pOut: PD3DXQUATERNION; pQ: PD3DXQUATERNION): TD3DXQUATERNION;


// non-inline
// Compute a quaternin's axis and angle of rotation. Expects unit quaternions.

procedure D3DXQuaternionToAxisAngle(pQ: PD3DXQUATERNION; pAxis: PD3DXVECTOR3; pAngle: Psingle); stdcall; external D3DX9_DLL;


// Build a quaternion from a rotation matrix.
function D3DXQuaternionRotationMatrix(pOut: PD3DXQUATERNION; pM: PD3DXMATRIX): PD3DXQUATERNION; stdcall; external D3DX9_DLL;


// Rotation about arbitrary axis.
function D3DXQuaternionRotationAxis(pOut: PD3DXQUATERNION; pV: PD3DXVECTOR3; Angle: single): PD3DXQUATERNION; stdcall; external D3DX9_DLL;


// Yaw around the Y axis, a pitch around the X axis,
// and a roll around the Z axis.
function D3DXQuaternionRotationYawPitchRoll(pOut: PD3DXQUATERNION; Yaw: single; Pitch: single; Roll: single): PD3DXQUATERNION; stdcall; external D3DX9_DLL;


// Quaternion multiplication.  The result represents the rotation Q2
// followed by the rotation Q1.  (Out = Q2 * Q1)
function D3DXQuaternionMultiply(pOut: PD3DXQUATERNION; pQ1: PD3DXQUATERNION; pQ2: PD3DXQUATERNION): PD3DXQUATERNION; stdcall; external D3DX9_DLL;


function D3DXQuaternionNormalize(pOut: PD3DXQUATERNION; pQ: PD3DXQUATERNION): PD3DXQUATERNION; stdcall; external D3DX9_DLL;


// Conjugate and re-norm
function D3DXQuaternionInverse(pOut: PD3DXQUATERNION; pQ: PD3DXQUATERNION): PD3DXQUATERNION; stdcall; external D3DX9_DLL;


// Expects unit quaternions.
// if q = (cos(theta), sin(theta) * v); ln(q) = (0, theta * v)
function D3DXQuaternionLn(pOut: PD3DXQUATERNION; pQ: PD3DXQUATERNION): PD3DXQUATERNION; stdcall; external D3DX9_DLL;


// Expects pure quaternions. (w == 0)  w is ignored in calculation.
// if q = (0, theta * v); exp(q) = (cos(theta), sin(theta) * v)
function D3DXQuaternionExp(pOut: PD3DXQUATERNION; pQ: PD3DXQUATERNION): PD3DXQUATERNION; stdcall; external D3DX9_DLL;


// Spherical linear interpolation between Q1 (t == 0) and Q2 (t == 1).
// Expects unit quaternions.
function D3DXQuaternionSlerp(pOut: PD3DXQUATERNION; pQ1: PD3DXQUATERNION; pQ2: PD3DXQUATERNION; t: single): PD3DXQUATERNION; stdcall; external D3DX9_DLL;


// Spherical quadrangle interpolation.
// Slerp(Slerp(Q1, C, t), Slerp(A, B, t), 2t(1-t))
function D3DXQuaternionSquad(pOut: PD3DXQUATERNION; pQ1: PD3DXQUATERNION; pA: PD3DXQUATERNION; pB: PD3DXQUATERNION; pC: PD3DXQUATERNION; t: single): PD3DXQUATERNION; stdcall; external D3DX9_DLL;


// Setup control points for spherical quadrangle interpolation
// from Q1 to Q2.  The control points are chosen in such a way
// to ensure the continuity of tangents with adjacent segments.
procedure D3DXQuaternionSquadSetup(pAOut: PD3DXQUATERNION; pBOut: PD3DXQUATERNION; pCOut: PD3DXQUATERNION; pQ0: PD3DXQUATERNION; pQ1: PD3DXQUATERNION; pQ2: PD3DXQUATERNION; pQ3: PD3DXQUATERNION); stdcall; external D3DX9_DLL;


// Barycentric interpolation.
// Slerp(Slerp(Q1, Q2, f+g), Slerp(Q1, Q3, f+g), g/(f+g))
function D3DXQuaternionBaryCentric(pOut: PD3DXQUATERNION; pQ1: PD3DXQUATERNION; pQ2: PD3DXQUATERNION; pQ3: PD3DXQUATERNION; f: single; g: single): PD3DXQUATERNION; stdcall; external D3DX9_DLL;


//--------------------------
// Plane
//--------------------------

// inline

// ax + by + cz + dw
function D3DXPlaneDot(pP: PD3DXPLANE; pV: PD3DXVECTOR4): single;


// ax + by + cz + d
function D3DXPlaneDotCoord(pP: PD3DXPLANE; pV: PD3DXVECTOR3): single;


// ax + by + cz
function D3DXPlaneDotNormal(pP: PD3DXPLANE; pV: PD3DXVECTOR3): single;

function D3DXPlaneScale(pOut: PD3DXPLANE; pP: PD3DXPLANE; s: single): TD3DXPLANE;


// non-inline
// Normalize plane (so that |a,b,c| == 1)


function D3DXPlaneNormalize(pOut: PD3DXPLANE; pP: PD3DXPLANE): PD3DXPLANE; stdcall; external D3DX9_DLL;


// Find the intersection between a plane and a line.  If the line is
// parallel to the plane, NULL is returned.
function D3DXPlaneIntersectLine(pOut: PD3DXVECTOR3; pP: PD3DXPLANE; pV1: PD3DXVECTOR3; pV2: PD3DXVECTOR3): PD3DXVECTOR3; stdcall; external D3DX9_DLL;


// Construct a plane from a point and a normal
function D3DXPlaneFromPointNormal(pOut: PD3DXPLANE; pPoint: PD3DXVECTOR3; pNormal: PD3DXVECTOR3): PD3DXPLANE; stdcall; external D3DX9_DLL;


// Construct a plane from 3 points
function D3DXPlaneFromPoints(pOut: PD3DXPLANE; pV1: PD3DXVECTOR3; pV2: PD3DXVECTOR3; pV3: PD3DXVECTOR3): PD3DXPLANE; stdcall; external D3DX9_DLL;


// Transform a plane by a matrix.  The vector (a,b,c) must be normal.
// M should be the inverse transpose of the transformation desired.
function D3DXPlaneTransform(pOut: PD3DXPLANE; pP: PD3DXPLANE; pM: PD3DXMATRIX): PD3DXPLANE; stdcall; external D3DX9_DLL;


// Transform an array of planes by a matrix.  The vectors (a,b,c) must be normal.
// M should be the inverse transpose of the transformation desired.
function D3DXPlaneTransformArray(pOut: PD3DXPLANE; OutStride: UINT; pP: PD3DXPLANE; PStride: UINT; pM: PD3DXMATRIX; n: UINT): PD3DXPLANE; stdcall; external D3DX9_DLL;


//--------------------------
// Color
//--------------------------

// inline


// (1-r, 1-g, 1-b, a)
function D3DXColorNegative(pOut: PD3DXCOLOR; pC: PD3DXCOLOR): TD3DXCOLOR;


function D3DXColorAdd(pOut: PD3DXCOLOR; pC1: PD3DXCOLOR; pC2: PD3DXCOLOR): TD3DXCOLOR;


function D3DXColorSubtract(pOut: PD3DXCOLOR; pC1: PD3DXCOLOR; pC2: PD3DXCOLOR): TD3DXCOLOR;


function D3DXColorScale(pOut: PD3DXCOLOR; pC: PD3DXCOLOR; s: single): TD3DXCOLOR;


// (r1*r2, g1*g2, b1*b2, a1*a2)
function D3DXColorModulate(pOut: PD3DXCOLOR; pC1: PD3DXCOLOR; pC2: PD3DXCOLOR): TD3DXCOLOR;


// Linear interpolation of r,g,b, and a. C1 + s(C2-C1)
function D3DXColorLerp(pOut: PD3DXCOLOR; pC1: PD3DXCOLOR; pC2: PD3DXCOLOR; s: single): TD3DXCOLOR;


// non-inline
// Interpolate r,g,b between desaturated color and color.
// DesaturatedColor + s(Color - DesaturatedColor)

function D3DXColorAdjustSaturation(pOut: PD3DXCOLOR; pC: PD3DXCOLOR; s: single): PD3DXCOLOR; stdcall; external D3DX9_DLL;


// Interpolate r,g,b between 50% grey and color.  Grey + s(Color - Grey)
function D3DXColorAdjustContrast(pOut: PD3DXCOLOR; pC: PD3DXCOLOR; c: single): PD3DXCOLOR; stdcall; external D3DX9_DLL;

//--------------------------
// Misc
//--------------------------
// Calculate Fresnel term given the cosine of theta (likely obtained by
// taking the dot of two normals), and the refraction index of the material.


function D3DXFresnelTerm(CosTheta: single; RefractionIndex: single): single; stdcall; external D3DX9_DLL;


//===========================================================================

//    Matrix Stack

//===========================================================================

function D3DXCreateMatrixStack(Flags: DWORD; out ppStack: ID3DXMatrixStack): HRESULT; stdcall; external D3DX9_DLL;

//===========================================================================

// General purpose utilities

//===========================================================================

function D3DXToRadian(degree: single): single;
function D3DXToDegree(radian: single): single;


{$IFDEF USESDK43 }


//===========================================================================

//  Spherical Harmonic Runtime Routines

// NOTE:
//  * Most of these functions can take the same object as in and out parameters.
//    The exceptions are the rotation functions.

//  * Out parameters are typically also returned as return values, so that
//    the output of one function may be used as a parameter to another.

//============================================================================
// non-inline
//============================================================================

//  Basic Spherical Harmonic math routines

//============================================================================
//============================================================================

//  D3DXSHEvalDirection:
//  --------------------
//  Evaluates the Spherical Harmonic basis functions

//  Parameters:
//   pOut
//      Output SH coefficients - basis function Ylm is stored at l*l + m+l
//      This is the pointer that is returned.
//   Order
//      Order of the SH evaluation, generates Order^2 coefs, degree is Order-1
//   pDir
//      Direction to evaluate in - assumed to be normalized

//============================================================================


function D3DXSHEvalDirection(pOut: Psingle; Order: UINT; pDir: PD3DXVECTOR3): single; stdcall; external D3DX9_DLL;


//============================================================================

//  D3DXSHRotate:
//  --------------------
//  Rotates SH vector by a rotation matrix

//  Parameters:
//   pOut
//      Output SH coefficients - basis function Ylm is stored at l*l + m+l
//      This is the pointer that is returned (should not alias with pIn.)
//   Order
//      Order of the SH evaluation, generates Order^2 coefs, degree is Order-1
//   pMatrix
//      Matrix used for rotation - rotation sub matrix should be orthogonal
//      and have a unit determinant.
//   pIn
//      Input SH coeffs (rotated), incorect results if this is also output.

//============================================================================

function D3DXSHRotate(pOut: Psingle; Order: UINT; pMatrix: PD3DXMATRIX; pIn: Psingle): single; stdcall; external D3DX9_DLL;


//============================================================================

//  D3DXSHRotateZ:
//  --------------------
//  Rotates the SH vector in the Z axis by an angle

//  Parameters:
//   pOut
//      Output SH coefficients - basis function Ylm is stored at l*l + m+l
//      This is the pointer that is returned (should not alias with pIn.)
//   Order
//      Order of the SH evaluation, generates Order^2 coefs, degree is Order-1
//   Angle
//      Angle in radians to rotate around the Z axis.
//   pIn
//      Input SH coeffs (rotated), incorect results if this is also output.

//============================================================================


function D3DXSHRotateZ(pOut: Psingle; Order: UINT; Angle: single; pIn: Psingle): single; stdcall; external D3DX9_DLL;


//============================================================================

//  D3DXSHAdd:
//  --------------------
//  Adds two SH vectors, pOut[i] = pA[i] + pB[i];

//  Parameters:
//   pOut
//      Output SH coefficients - basis function Ylm is stored at l*l + m+l
//      This is the pointer that is returned.
//   Order
//      Order of the SH evaluation, generates Order^2 coefs, degree is Order-1
//   pA
//      Input SH coeffs.
//   pB
//      Input SH coeffs (second vector.)

//============================================================================

function D3DXSHAdd(pOut: Psingle; Order: UINT; pA: Psingle; pB: Psingle): single; stdcall; external D3DX9_DLL;


//============================================================================

//  D3DXSHScale:
//  --------------------
//  Adds two SH vectors, pOut[i] = pA[i]*Scale;

//  Parameters:
//   pOut
//      Output SH coefficients - basis function Ylm is stored at l*l + m+l
//      This is the pointer that is returned.
//   Order
//      Order of the SH evaluation, generates Order^2 coefs, degree is Order-1
//   pIn
//      Input SH coeffs.
//   Scale
//      Scale factor.

//============================================================================

function D3DXSHScale(pOut: Psingle; Order: UINT; pIn: Psingle; Scale: single): single; stdcall; external D3DX9_DLL;


//============================================================================

//  D3DXSHDot:
//  --------------------
//  Computes the dot product of two SH vectors

//  Parameters:
//   Order
//      Order of the SH evaluation, generates Order^2 coefs, degree is Order-1
//   pA
//      Input SH coeffs.
//   pB
//      Second set of input SH coeffs.

//============================================================================

function D3DXSHDot(Order: UINT; pA: Psingle; pB: Psingle): single; stdcall; external D3DX9_DLL;


//============================================================================

//  D3DXSHMultiply[O]:
//  --------------------
//  Computes the product of two functions represented using SH (f and g), where:
//  pOut[i] = int(y_i(s) * f(s) * g(s)), where y_i(s) is the ith SH basis
//  function, f(s) and g(s) are SH functions (sum_i(y_i(s)*c_i)).  The order O
//  determines the lengths of the arrays, where there should always be O^2
//  coefficients.  In general the product of two SH functions of order O generates
//  and SH function of order 2*O - 1, but we truncate the result.  This means
//  that the product commutes (f*g == g*f) but doesn't associate
//  (f*(g*h) != (f*g)*h.

//  Parameters:
//   pOut
//      Output SH coefficients - basis function Ylm is stored at l*l + m+l
//      This is the pointer that is returned.
//   pF
//      Input SH coeffs for first function.
//   pG
//      Second set of input SH coeffs.

//============================================================================

function D3DXSHMultiply2(pOut: Psingle; pF: Psingle; pG: Psingle): single; stdcall; external D3DX9_DLL;

function D3DXSHMultiply3(pOut: Psingle; pF: Psingle; pG: Psingle): single; stdcall; external D3DX9_DLL;

function D3DXSHMultiply4(pOut: Psingle; pF: Psingle; pG: Psingle): single; stdcall; external D3DX9_DLL;

function D3DXSHMultiply5(pOut: Psingle; pF: Psingle; pG: Psingle): single; stdcall; external D3DX9_DLL;

function D3DXSHMultiply6(pOut: Psingle; pF: Psingle; pG: Psingle): single; stdcall; external D3DX9_DLL;


//============================================================================

//  Basic Spherical Harmonic lighting routines

//============================================================================
//============================================================================

//  D3DXSHEvalDirectionalLight:
//  --------------------
//  Evaluates a directional light and returns spectral SH data.  The output
//  vector is computed so that if the intensity of R/G/B is unit the resulting
//  exit radiance of a point directly under the light on a diffuse object with
//  an albedo of 1 would be 1.0.  This will compute 3 spectral samples, pROut
//  has to be specified, while pGout and pBout are optional.

//  Parameters:
//   Order
//      Order of the SH evaluation, generates Order^2 coefs, degree is Order-1
//   pDir
//      Direction light is coming from (assumed to be normalized.)
//   RIntensity
//      Red intensity of light.
//   GIntensity
//      Green intensity of light.
//   BIntensity
//      Blue intensity of light.
//   pROut
//      Output SH vector for Red.
//   pGOut
//      Output SH vector for Green (optional.)
//   pBOut
//      Output SH vector for Blue (optional.)

//============================================================================


function D3DXSHEvalDirectionalLight(Order: UINT; pDir: PD3DXVECTOR3; RIntensity: single; GIntensity: single; BIntensity: single; pROut: Psingle; pGOut: Psingle; pBOut: Psingle): HRESULT; stdcall; external D3DX9_DLL;


//============================================================================

//  D3DXSHEvalSphericalLight:
//  --------------------
//  Evaluates a spherical light and returns spectral SH data.  There is no
//  normalization of the intensity of the light like there is for directional
//  lights, care has to be taken when specifiying the intensities.  This will
//  compute 3 spectral samples, pROut has to be specified, while pGout and
//  pBout are optional.

//  Parameters:
//   Order
//      Order of the SH evaluation, generates Order^2 coefs, degree is Order-1
//   pPos
//      Position of light - reciever is assumed to be at the origin.
//   Radius
//      Radius of the spherical light source.
//   RIntensity
//      Red intensity of light.
//   GIntensity
//      Green intensity of light.
//   BIntensity
//      Blue intensity of light.
//   pROut
//      Output SH vector for Red.
//   pGOut
//      Output SH vector for Green (optional.)
//   pBOut
//      Output SH vector for Blue (optional.)

//============================================================================

function D3DXSHEvalSphericalLight(Order: UINT; pPos: PD3DXVECTOR3; Radius: single; RIntensity: single; GIntensity: single; BIntensity: single; pROut: Psingle; pGOut: Psingle; pBOut: Psingle): HRESULT; stdcall; external D3DX9_DLL;


//============================================================================

//  D3DXSHEvalConeLight:
//  --------------------
//  Evaluates a light that is a cone of constant intensity and returns spectral
//  SH data.  The output vector is computed so that if the intensity of R/G/B is
//  unit the resulting exit radiance of a point directly under the light oriented
//  in the cone direction on a diffuse object with an albedo of 1 would be 1.0.
//  This will compute 3 spectral samples, pROut has to be specified, while pGout
//  and pBout are optional.

//  Parameters:
//   Order
//      Order of the SH evaluation, generates Order^2 coefs, degree is Order-1
//   pDir
//      Direction light is coming from (assumed to be normalized.)
//   Radius
//      Radius of cone in radians.
//   RIntensity
//      Red intensity of light.
//   GIntensity
//      Green intensity of light.
//   BIntensity
//      Blue intensity of light.
//   pROut
//      Output SH vector for Red.
//   pGOut
//      Output SH vector for Green (optional.)
//   pBOut
//      Output SH vector for Blue (optional.)

//============================================================================

function D3DXSHEvalConeLight(Order: UINT; pDir: PD3DXVECTOR3; Radius: single; RIntensity: single; GIntensity: single; BIntensity: single; pROut: Psingle; pGOut: Psingle; pBOut: Psingle): HRESULT; stdcall; external D3DX9_DLL;


//============================================================================

//  D3DXSHEvalHemisphereLight:
//  --------------------
//  Evaluates a light that is a linear interpolant between two colors over the
//  sphere.  The interpolant is linear along the axis of the two points, not
//  over the surface of the sphere (ie: if the axis was (0,0,1) it is linear in
//  Z, not in the azimuthal angle.)  The resulting spherical lighting function
//  is normalized so that a point on a perfectly diffuse surface with no
//  shadowing and a normal pointed in the direction pDir would result in exit
//  radiance with a value of 1 if the top color was white and the bottom color
//  was black.  This is a very simple model where Top represents the intensity
//  of the "sky" and Bottom represents the intensity of the "ground".

//  Parameters:
//   Order
//      Order of the SH evaluation, generates Order^2 coefs, degree is Order-1
//   pDir
//      Axis of the hemisphere.
//   Top
//      Color of the upper hemisphere.
//   Bottom
//      Color of the lower hemisphere.
//   pROut
//      Output SH vector for Red.
//   pGOut
//      Output SH vector for Green
//   pBOut
//      Output SH vector for Blue

//============================================================================

function D3DXSHEvalHemisphereLight(Order: UINT; pDir: PD3DXVECTOR3; Top: TD3DXCOLOR; Bottom: TD3DXCOLOR; pROut: Psingle; pGOut: Psingle; pBOut: Psingle): HRESULT; stdcall; external D3DX9_DLL;


//============================================================================

//  Basic Spherical Harmonic projection routines

//============================================================================
//============================================================================

//  D3DXSHProjectCubeMap:
//  --------------------
//  Projects a function represented on a cube map into spherical harmonics.

//  Parameters:
//   Order
//      Order of the SH evaluation, generates Order^2 coefs, degree is Order-1
//   pCubeMap
//      CubeMap that is going to be projected into spherical harmonics
//   pROut
//      Output SH vector for Red.
//   pGOut
//      Output SH vector for Green
//   pBOut
//      Output SH vector for Blue

//============================================================================


function D3DXSHProjectCubeMap(uOrder: UINT; pCubeMap: IDirect3DCubeTexture9; pROut: Psingle; pGOut: Psingle; pBOut: Psingle): HRESULT; stdcall; external D3DX9_DLL;

{$ENDIF}

implementation

uses
    Math;


    //===========================================================================

    // Inline functions

    //===========================================================================

function D3DXVec2Length(pV: PD3DXVECTOR2): single;
begin
    {$IFOPT D+}
    if pV=nil then
    begin
        result:=0;
        Exit;
    end;
    {$ENDIF}

    Result := sqrt(pV.x * pV.x + pV.y * pV.y);
end;



function D3DXVec2LengthSq(pV: PD3DXVECTOR2): single;
begin
    {$IFOPT D+}
    if pV=nil then
    begin
        result:=0;
        Exit;
    end;
    {$ENDIF}
    Result := pV.x * pV.x + pV.y * pV.y;
end;



function D3DXVec2Dot(pV1: PD3DXVECTOR2; pV2: PD3DXVECTOR2): single;
begin
    {$IFOPT D+}
    if (pV1=nil) or (pV2=nil) then
    begin
        result:=0;
        Exit;
    end;
    {$ENDIF}
    Result := pV1.x * pV2.x + pV1.y * pV2.y;
end;



function D3DXVec2CCW(pV1: PD3DXVECTOR2; pV2: PD3DXVECTOR2): single;
begin
    {$IFOPT D+}
    if (pV1=nil) or (pV2=nil) then
    begin
        result:=0;
        Exit;
    end;
    {$ENDIF}
    Result := pV1.x * pV2.y - pV1.y * pV2.x;
end;



function D3DXVec2Add(pOut: PD3DXVECTOR2; pV1: PD3DXVECTOR2; pV2: PD3DXVECTOR2): TD3DXVECTOR2;
begin
    {$IFOPT D+}
    if (pV1=nil) or (pV2=nil) or (pOut =nil) then
    begin
        result:=TD3DXVECTOR2(nil^);
        Exit;
    end;
    {$ENDIF}
    pOut^.x := pV1.x + pV2.x;
    pOut^.y := pV1.y + pV2.y;
    Result := pOut^;
end;



function D3DXVec2Subtract(pOut: PD3DXVECTOR2; pV1: PD3DXVECTOR2; pV2: PD3DXVECTOR2): TD3DXVECTOR2;
begin
    {$IFOPT D+}
    if (pV1=nil) or (pV2=nil) or (pOut =nil) then
    begin
        result:=TD3DXVECTOR2(nil^);
        Exit;
    end;
    {$ENDIF}
    pOut^.x := pV1.x - pV2.x;
    pOut^.y := pV1.y - pV2.y;
    Result := pOut^;
end;



function D3DXVec2Minimize(pOut: PD3DXVECTOR2; pV1: PD3DXVECTOR2; pV2: PD3DXVECTOR2): TD3DXVECTOR2;
begin
    {$IFOPT D+}
    if (pV1=nil) or (pV2=nil) or (pOut =nil) then
    begin
        result:=TD3DXVECTOR2(nil^);
        Exit;
    end;
    {$ENDIF}
    if pV1.x < pV2.x then
        pOut^.x := pV1.x
    else
        pOut^.x := pV2.x;
    if pV1.y < pV2.y then
        pOut^.y := pV1.y
    else
        pOut^.y := pV2.y;
    Result := pOut^;
end;



function D3DXVec2Maximize(pOut: PD3DXVECTOR2; pV1: PD3DXVECTOR2; pV2: PD3DXVECTOR2): TD3DXVECTOR2;
begin
    {$IFOPT D+}
    if (pV1=nil) or (pV2=nil) or (pOut =nil) then
    begin
        result:=TD3DXVECTOR2(nil^);
        Exit;
    end;
    {$ENDIF}
    if pV1.x > pV2.x then
        pOut^.x := pV1.x
    else
        pOut^.x := pV2.x;
    if pV1.y > pV2.y then
        pOut^.y := pV1.y
    else
        pOut^.y := pV2.y;
    Result := pOut^;
end;



function D3DXVec2Scale(pOut: PD3DXVECTOR2; pV: PD3DXVECTOR2; s: single): TD3DXVECTOR2;
begin
    {$IFOPT D+}
    if (pV=nil)  or (pOut =nil) then
    begin
        result:=TD3DXVECTOR2(nil^);
        Exit;
    end;
    {$ENDIF}
    pOut^.x := pV.x * s;
    pOut^.y := pV.y * s;
    Result := pOut^;
end;



function D3DXVec2Lerp(pOut: PD3DXVECTOR2; pV1: PD3DXVECTOR2; pV2: PD3DXVECTOR2; s: single): TD3DXVECTOR2;
begin
    {$IFOPT D+}
    if (pV1=nil) or (pV2=nil) or (pOut =nil) then
    begin
        result:=TD3DXVECTOR2(nil^);
        Exit;
    end;
    {$ENDIF}
    pOut^.x := pV1.x + s * (pV2.x - pV1.x);
    pOut^.y := pV1.y + s * (pV2.y - pV1.y);
    Result := pOut^;
end;



function D3DXVector3(x, y, z: single): TD3DXVECTOR3;
var
    a: TD3DXVECTOR3;
begin
    a.x := x;
    a.y := y;
    a.z := z;
    Result := a;
end;



function D3DXVec3Length(pV: PD3DXVECTOR3): single;
begin
    {$IFOPT D+}
    if pV=nil then
    begin
        result:=0;
        Exit;
    end;
    {$ENDIF}
    Result := sqrt(pV.x * pV.x + pV.y * pV.y + pV.z * pV.z);
end;



function D3DXVec3LengthSq(pV: PD3DXVECTOR3): single;
begin
    {$IFOPT D+}
    if pV=nil then
    begin
        result:=0;
        Exit;
    end;
    {$ENDIF}
    Result := (pV.x * pV.x + pV.y * pV.y + pV.z * pV.z);
end;



function D3DXVec3Dot(pV1: PD3DXVECTOR3; pV2: PD3DXVECTOR3): single;
begin
    {$IFOPT D+}
    if (pV1=nil) or (pV2=nil) then
    begin
        result:=0;
        Exit;
    end;
    {$ENDIF}
    Result := pV1.x * pV2.x + pV1.y * pV2.y + pV1.z * pV2.z;
end;



function D3DXVec3Cross(pOut: PD3DXVECTOR3; pV1: PD3DXVECTOR3; pV2: PD3DXVECTOR3): TD3DXVECTOR3;
var
    v: TD3DXVECTOR3;
begin
    {$IFOPT D+}
    if (pV1=nil) or (pV2=nil) or (pOut =nil) then
    begin
        result:=TD3DXVECTOR3(nil^);
        Exit;
    end;
    {$ENDIF}
    pOut^.x := pV1.y * pV2.z - pV1.z * pV2.y;
    pOut^.y := pV1.z * pV2.x - pV1.x * pV2.z;
    pOut^.z := pV1.x * pV2.y - pV1.y * pV2.x;
    Result := pOut^;
end;



function D3DXVec3Add(pOut: PD3DXVECTOR3; pV1: PD3DXVECTOR3; pV2: PD3DXVECTOR3): TD3DXVECTOR3;
begin
    {$IFOPT D+}
    if (pV1=nil) or (pV2=nil) or (pOut =nil) then
    begin
        result:=TD3DXVECTOR3(nil^);
        Exit;
    end;
    {$ENDIF}
    pOut^.x := pV1.x + pV2.x;
    pOut^.y := pV1.y + pV2.y;
    pOut^.z := pV1.z + pV2.z;
    Result := pOut^;
end;



function D3DXVec3Subtract(pOut: PD3DXVECTOR3; pV1: PD3DXVECTOR3; pV2: PD3DXVECTOR3): TD3DXVECTOR3;
begin
    {$IFOPT D+}
    if (pV1=nil) or (pV2=nil) or (pOut =nil) then
    begin
        result:=TD3DXVECTOR3(nil^);
        Exit;
    end;
    {$ENDIF}
    pOut^.x := pV1.x - pV2.x;
    pOut^.y := pV1.y - pV2.y;
    pOut^.z := pV1.z - pV2.z;
    Result := pOut^;
end;



function D3DXVec3Minimize(pOut: PD3DXVECTOR3; pV1: PD3DXVECTOR3; pV2: PD3DXVECTOR3): TD3DXVECTOR3;
begin
    {$IFOPT D+}
    if (pV1=nil) or (pV2=nil) or (pOut =nil) then
    begin
        result:=TD3DXVECTOR3(nil^);
        Exit;
    end;
    {$ENDIF}
    if pV1.x < pV2.x then
        pOut^.x := pV1.x
    else
        pOut^.x := pV2.x;
    if pV1.y < pV2.y then
        pOut^.y := pV1.y
    else
        pOut^.y := pV2.y;
    if pV1.z < pV2.z then
        pOut^.z := pV1.z
    else
        pOut^.z := pV2.z;
    Result := pOut^;
end;



function D3DXVec3Maximize(pOut: PD3DXVECTOR3; pV1: PD3DXVECTOR3; pV2: PD3DXVECTOR3): TD3DXVECTOR3;
begin
    {$IFOPT D+}
    if (pV1=nil) or (pV2=nil) or (pOut =nil) then
    begin
        result:=TD3DXVECTOR3(nil^);
        Exit;
    end;
    {$ENDIF}
    if pV1.x > pV2.x then
        pOut^.x := pV1.x
    else
        pOut^.x := pV2.x;
    if pV1.y > pV2.y then
        pOut^.y := pV1.y
    else
        pOut^.y := pV2.y;
    if pV1.z > pV2.z then
        pOut^.z := pV1.z
    else
        pOut^.z := pV2.z;
    Result := pOut^;
end;



function D3DXVec3Scale(pOut: PD3DXVECTOR3; pV: PD3DXVECTOR3; s: single): TD3DXVECTOR3;
begin
    {$IFOPT D+}
    if (pV=nil) or (pOut =nil) then
    begin
        result:=TD3DXVECTOR3(nil^);
        Exit;
    end;
    {$ENDIF}
    pOut.x := pV.x * s;
    pOut.y := pV.y * s;
    pOut.z := pV.z * s;
    Result := pOut^;
end;



function D3DXVec3Lerp(pOut: PD3DXVECTOR3; pV1: PD3DXVECTOR3; pV2: PD3DXVECTOR3; s: single): TD3DXVECTOR3;
begin
    {$IFOPT D+}
    if (pV1=nil) or (pV2=nil) or (pOut =nil) then
    begin
        result:=TD3DXVECTOR3(nil^);
        Exit;
    end;
    {$ENDIF}
    pOut.x := pV1.x + s * (pV2.x - pV1.x);
    pOut.y := pV1.y + s * (pV2.y - pV1.y);
    pOut.z := pV1.z + s * (pV2.z - pV1.z);
    Result := pOut^;
end;



function D3DXVec4Length(pV: PD3DXVECTOR4): single;
begin
    {$IFOPT D+}
    if pV=nil then
    begin
        result:=0;
        Exit;
    end;
    {$ENDIF}
    Result := sqrt(pV.x * pV.x + pV.y * pV.y + pV.z * pV.z + pV.w * pV.w);
end;



function D3DXVec4LengthSq(pV: PD3DXVECTOR4): single;
begin
    {$IFOPT D+}
    if pV=nil then
    begin
        result:=0;
        Exit;
    end;
    {$ENDIF}
    Result := (pV.x * pV.x + pV.y * pV.y + pV.z * pV.z + pV.w * pV.w);
end;



function D3DXVec4Dot(pV1: PD3DXVECTOR4; pV2: PD3DXVECTOR4): single;
begin
    {$IFOPT D+}
    if (pV1=nil) or (pV2=nil) then
    begin
        result:=0;
        Exit;
    end;
    {$ENDIF}
    Result := pV1.x * pV2.x + pV1.y * pV2.y + pV1.z * pV2.z + pV1.w * pV2.w;
end;



function D3DXVec4Add(pOut: PD3DXVECTOR4; pV1: PD3DXVECTOR4; pV2: PD3DXVECTOR4): TD3DXVECTOR4;
begin
    {$IFOPT D+}
    if (pV1=nil) or (pV2=nil) or (pOut =nil) then
    begin
        result:=TD3DXVECTOR4(nil^);
        Exit;
    end;
    {$ENDIF}
    pOut.x := pV1.x + pV2.x;
    pOut.y := pV1.y + pV2.y;
    pOut.z := pV1.z + pV2.z;
    pOut.w := pV1.w + pV2.w;
    Result := pOut^;
end;



function D3DXVec4Subtract(pOut: PD3DXVECTOR4; pV1: PD3DXVECTOR4; pV2: PD3DXVECTOR4): TD3DXVECTOR4;
begin
    {$IFOPT D+}
    if (pV1=nil) or (pV2=nil) or (pOut =nil) then
    begin
        result:=TD3DXVECTOR4(nil^);
        Exit;
    end;
    {$ENDIF}
    pOut.x := pV1.x - pV2.x;
    pOut.y := pV1.y - pV2.y;
    pOut.z := pV1.z - pV2.z;
    pOut.w := pV1.w - pV2.w;
    Result := pOut^;
end;



function D3DXVec4Minimize(pOut: PD3DXVECTOR4; pV1: PD3DXVECTOR4; pV2: PD3DXVECTOR4): TD3DXVECTOR4;
begin
    {$IFOPT D+}
    if (pV1=nil) or (pV2=nil) or (pOut =nil) then
    begin
        result:=TD3DXVECTOR4(nil^);
        Exit;
    end;
    {$ENDIF}
    if pV1.x < pV2.x then
        pOut.x := pV1.x
    else
        pOut.x := pV2.x;
    if pV1.y < pV2.y then
        pOut.y := pV1.y
    else
        pOut.y := pV2.y;
    if pV1.z < pV2.z then
        pOut.z := pV1.z
    else
        pOut.z := pV2.z;
    if pV1.w < pV2.w then
        pOut.w := pV1.w
    else
        pOut.w := pV2.w;
    Result := pOut^;
end;



function D3DXVec4Maximize(pOut: PD3DXVECTOR4; pV1: PD3DXVECTOR4; pV2: PD3DXVECTOR4): TD3DXVECTOR4;
begin
    {$IFOPT D+}
    if (pV1=nil) or (pV2=nil) or (pOut =nil) then
    begin
        result:=TD3DXVECTOR4(nil^);
        Exit;
    end;
    {$ENDIF}
    if pV1.x > pV2.x then
        pOut.x := pV1.x
    else
        pOut.x := pV2.x;
    if pV1.y > pV2.y then
        pOut.y := pV1.y
    else
        pOut.y := pV2.y;
    if pV1.z > pV2.z then
        pOut.z := pV1.z
    else
        pOut.z := pV2.z;
    if pV1.w > pV2.w then
        pOut.w := pV1.w
    else
        pOut.w := pV2.w;
    Result := pOut^;
end;



function D3DXVec4Scale(pOut: PD3DXVECTOR4; pV: PD3DXVECTOR4; s: single): TD3DXVECTOR4;
begin
    {$IFOPT D+}
    if (pV=nil) or (pOut =nil) then
    begin
        result:=TD3DXVECTOR4(nil^);
        Exit;
    end;
    {$ENDIF}
    pOut.x := pV.x * s;
    pOut.y := pV.y * s;
    pOut.z := pV.z * s;
    pOut.w := pV.w * s;
    Result := pOut^;
end;



function D3DXVec4Lerp(pOut: PD3DXVECTOR4; pV1: PD3DXVECTOR4; pV2: PD3DXVECTOR4; s: single): TD3DXVECTOR4;
begin
    {$IFOPT D+}
    if (pV1=nil) or (pV2=nil) or (pOut =nil) then
    begin
        result:=TD3DXVECTOR4(nil^);
        Exit;
    end;
    {$ENDIF}
    pOut.x := pV1.x + s * (pV2.x - pV1.x);
    pOut.y := pV1.y + s * (pV2.y - pV1.y);
    pOut.z := pV1.z + s * (pV2.z - pV1.z);
    pOut.w := pV1.w + s * (pV2.w - pV1.w);
    Result := pOut^;
end;



function D3DXMatrixIdentity(pOut: PD3DXMATRIX): TD3DXMATRIX;
begin
    {$IFOPT D+}
    if (pOut =nil) then
    begin
        result:=TD3DXMATRIX(nil^);
        Exit;
    end;
    {$ENDIF}
    pOut.m[0][1] := 0.0;
    pOut.m[0][2] := 0.0;
    pOut.m[0][3] := 0.0;
    pOut.m[1][0] := 0.0;
    pOut.m[1][2] := 0.0;
    pOut.m[1][3] := 0.0;
    pOut.m[2][0] := 0.0;
    pOut.m[2][1] := 0.0;
    pOut.m[2][3] := 0.0;
    pOut.m[3][0] := 0.0;
    pOut.m[3][1] := 0.0;
    pOut.m[3][2] := 0.0;

    pOut.m[0][0] := 1.0;
    pOut.m[1][1] := 1.0;
    pOut.m[2][2] := 1.0;
    pOut.m[3][3] := 1.0;
    Result := pOut^;
end;



function D3DXMatrixIsIdentity(pM: PD3DXMATRIX): boolean;
begin
    {$IFOPT D+}
    if (pM =nil) then
    begin
        result:=false;
        Exit;
    end;
    {$ENDIF}
    Result := (pM.m[0][0] = 1.0) and (pM.m[0][1] = 0.0) and (pM.m[0][2] = 0.0) and (pM.m[0][3] = 0.0) and (pM.m[1][0] = 0.0) and (pM.m[1][1] = 1.0) and (pM.m[1][2] = 0.0) and (pM.m[1][3] = 0.0) and
        (pM.m[2][0] = 0.0) and (pM.m[2][1] = 0.0) and (pM.m[2][2] = 1.0) and (pM.m[2][3] = 0.0) and (pM.m[3][0] = 0.0) and (pM.m[3][1] = 0.0) and (pM.m[3][2] = 0.0) and (pM.m[3][3] = 1.0);
end;



function D3DXQuaternionLength(pQ: PD3DXQUATERNION): single;
begin
    {$IFOPT D+}
    if (pQ=nil) then
    begin
        result:=0;
        Exit;
    end;
    {$ENDIF}
    Result := sqrt(pQ.x * pQ.x + pQ.y * pQ.y + pQ.z * pQ.z + pQ.w * pQ.w);
end;



function D3DXQuaternionLengthSq(pQ: PD3DXQUATERNION): single;
begin
    {$IFOPT D+}
    if (pQ=nil) then
    begin
        result:=0;
        Exit;
    end;
    {$ENDIF}
    Result := (pQ.x * pQ.x + pQ.y * pQ.y + pQ.z * pQ.z + pQ.w * pQ.w);
end;



function D3DXQuaternionDot(pQ1: PD3DXQUATERNION; pQ2: PD3DXQUATERNION): single;
begin
    {$IFOPT D+}
    if (pQ1=nil) or (pQ2 =nil) then
    begin
        result:=0;
        Exit;
    end;
    {$ENDIF}
    Result := pQ1.x * pQ2.x + pQ1.y * pQ2.y + pQ1.z * pQ2.z + pQ1.w * pQ2.w;
end;



function D3DXQuaternionIdentity(pOut: PD3DXQUATERNION): TD3DXQUATERNION;
begin
    {$IFOPT D+}
    if (pOut=nil) then
    begin
        result:=TD3DXQUATERNION(nil^);
        Exit;
    end;
    {$ENDIF}
    pOut.x := 0.0;
    pOut.y := 0.0;
    pOut.z := 0.0;
    pOut.w := 1.0;
    Result := pOut^;
end;



function D3DXQuaternionIsIdentity(pQ: PD3DXQUATERNION): boolean;
begin
    {$IFOPT D+}
    if (pQ=nil) then
    begin
        result:=false;
        Exit;
    end;
    {$ENDIF}
    Result := (pQ.x = 0.0) and (pQ.y = 0.0) and (pQ.z = 0.0) and (pQ.w = 1.0);
end;



function D3DXQuaternionConjugate(pOut: PD3DXQUATERNION; pQ: PD3DXQUATERNION): TD3DXQUATERNION;
begin
    {$IFOPT D+}
    if (pQ=nil) or (pOut =nil) then
    begin
        result:=TD3DXQUATERNION(nil^);
        Exit;
    end;
    {$ENDIF}
    pOut.x := -pQ.x;
    pOut.y := -pQ.y;
    pOut.z := -pQ.z;
    pOut.w := pQ.w;
    Result := pOut^;
end;



function D3DXPlaneDot(pP: PD3DXPLANE; pV: PD3DXVECTOR4): single;
begin
    {$IFOPT D+}
    if (pP=nil) or (pV =nil) then
    begin
        result:=0;
        Exit;
    end;
    {$ENDIF}
    Result := pP.a * pV.x + pP.b * pV.y + pP.c * pV.z + pP.d * pV.w;
end;



function D3DXPlaneDotCoord(pP: PD3DXPLANE; pV: PD3DXVECTOR3): single;
begin
    {$IFOPT D+}
    if (pP=nil) or (pV =nil) then
    begin
        result:=0;
        Exit;
    end;
    {$ENDIF}
    Result := pP.a * pV.x + pP.b * pV.y + pP.c * pV.z + pP.d;
end;



function D3DXPlaneDotNormal(pP: PD3DXPLANE; pV: PD3DXVECTOR3): single;
begin
    {$IFOPT D+}
    if (pP=nil) or (pV =nil) then
    begin
        result:=0;
        Exit;
    end;
    {$ENDIF}
    Result := pP.a * pV.x + pP.b * pV.y + pP.c * pV.z;
end;



function D3DXPlaneScale(pOut: PD3DXPLANE; pP: PD3DXPLANE; s: single): TD3DXPLANE;
begin
    {$IFOPT D+}
    if (pOut=nil) or (pP =nil) then
    begin
        result:=TD3DXPLANE(nil^ );
        Exit;
    end;
    {$ENDIF}

    pOut.a := pP.a * s;
    pOut.b := pP.b * s;
    pOut.c := pP.c * s;
    pOut.d := pP.d * s;
    Result := pOut^;
end;



function D3DXColorNegative(pOut: PD3DXCOLOR; pC: PD3DXCOLOR): TD3DXCOLOR;
begin
    {$IFOPT D+}
    if (pOut=nil) or (pC =nil) then
    begin
        result:=TD3DXCOLOR(nil^);
        Exit;
    end;
    {$ENDIF}
    pOut.r := 1.0 - pC.r;
    pOut.g := 1.0 - pC.g;
    pOut.b := 1.0 - pC.b;
    pOut.a := pC.a;
    Result := pOut^;
end;



function D3DXColorAdd(pOut: PD3DXCOLOR; pC1: PD3DXCOLOR; pC2: PD3DXCOLOR): TD3DXCOLOR;
begin
    {$IFOPT D+}
    if (pOut=nil) or (pC1 =nil) or (pC2 =nil) then
    begin
        result:=TD3DXCOLOR(nil^);
        Exit;
    end;
    {$ENDIF}
    pOut.r := pC1.r + pC2.r;
    pOut.g := pC1.g + pC2.g;
    pOut.b := pC1.b + pC2.b;
    pOut.a := pC1.a + pC2.a;
    Result := pOut^;
end;



function D3DXColorSubtract(pOut: PD3DXCOLOR; pC1: PD3DXCOLOR; pC2: PD3DXCOLOR): TD3DXCOLOR;
begin
    {$IFOPT D+}
    if (pOut=nil) or (pC1 =nil) or (pC2 =nil) then
    begin
        result:=TD3DXCOLOR(nil^);
        Exit;
    end;
    {$ENDIF}
    pOut.r := pC1.r - pC2.r;
    pOut.g := pC1.g - pC2.g;
    pOut.b := pC1.b - pC2.b;
    pOut.a := pC1.a - pC2.a;
    Result := pOut^;
end;



function D3DXColorScale(pOut: PD3DXCOLOR; pC: PD3DXCOLOR; s: single): TD3DXCOLOR;
begin
    {$IFOPT D+}
    if (pOut=nil) or (pC =nil)then
    begin
        result:=TD3DXCOLOR(nil^);
        Exit;
    end;
    {$ENDIF}
    pOut.r := pC.r * s;
    pOut.g := pC.g * s;
    pOut.b := pC.b * s;
    pOut.a := pC.a * s;
    Result := pOut^;
end;



function D3DXColorModulate(pOut: PD3DXCOLOR; pC1: PD3DXCOLOR; pC2: PD3DXCOLOR): TD3DXCOLOR;
begin
    {$IFOPT D+}
    if (pOut=nil) or (pC1 =nil) or (pC2 =nil) then
    begin
        result:=TD3DXCOLOR(nil^);
        Exit;
    end;
    {$ENDIF}
    pOut.r := pC1.r * pC2.r;
    pOut.g := pC1.g * pC2.g;
    pOut.b := pC1.b * pC2.b;
    pOut.a := pC1.a * pC2.a;
    Result := pOut^;
end;



function D3DXColorLerp(pOut: PD3DXCOLOR; pC1: PD3DXCOLOR; pC2: PD3DXCOLOR; s: single): TD3DXCOLOR;
begin
    {$IFOPT D+}
    if (pOut=nil) or (pC1 =nil) or (pC2 =nil) then
    begin
        result:=TD3DXCOLOR(nil^);
        Exit;
    end;
    {$ENDIF}
    pOut.r := pC1.r + s * (pC2.r - pC1.r);
    pOut.g := pC1.g + s * (pC2.g - pC1.g);
    pOut.b := pC1.b + s * (pC2.b - pC1.b);
    pOut.a := pC1.a + s * (pC2.a - pC1.a);
    Result := pOut^;
end;



function D3DXToRadian(degree: single): single; inline;
begin
    Result := degree * (D3DX_PI / 180.0);
end;



function D3DXToDegree(radian: single): single; inline;
begin
    Result := radian * (180.0 / D3DX_PI);
end;

//===========================================================================

// Inline Class Methods

//===========================================================================

{ TD3DXFLOAT16 }

class operator TD3DXFLOAT16.Explicit(a: TD3DXFLOAT16): single;
var
    f: single;
begin
    D3DXFloat16To32Array(@f, @a, 1);
    Result := f;
end;



class operator TD3DXFLOAT16.Equal(a: TD3DXFLOAT16; b: TD3DXFLOAT16): boolean;
begin
    Result := a.Value = b.Value;
end;



class operator TD3DXFLOAT16.NotEqual(a: TD3DXFLOAT16; b: TD3DXFLOAT16): boolean;
begin
    Result := a.Value <> b.Value;
end;



procedure TD3DXFLOAT16.Init(f: single);
begin
    D3DXFloat32To16Array(@self, @f, 1);
end;



procedure TD3DXFLOAT16.Init(f: TD3DXFLOAT16);
begin
    Value := f.Value;
end;

//--------------------------
// 2D Vector
//--------------------------

{ TD3DXVECTOR2 }

class operator TD3DXVECTOR2.Initialize(var aRec: TD3DXVECTOR2);
begin
    aRec.x := 0;
    aRec.y := 0;
end;



procedure TD3DXVECTOR2.Init(pf: PSingle);
begin
    {$IFOPT D+}
    if (pf=nil) then
    begin
        Exit;
    end;
    {$ENDIF}
    x := pf[0];
    y := pf[1];
end;



procedure TD3DXVECTOR2.Init(f: PD3DXFLOAT16);
begin
    {$IFOPT D+}
    if (f=nil) then
    begin
        Exit;
    end;
    {$ENDIF}
    D3DXFloat16To32Array(@self, @f, 2);
end;



procedure TD3DXVECTOR2.Init(fx, fy: single);
begin
    x := fx;
    y := fy;
end;



class operator TD3DXVECTOR2.Explicit(a: TD3DXVECTOR2): PSingle;
begin
    Result := @a.f[0];
end;



class operator TD3DXVECTOR2.Add(a: TD3DXVECTOR2; b: TD3DXVECTOR2): TD3DXVECTOR2;
begin
    Result.x := a.x + b.x;
    Result.y := a.y + b.y;

end;



class operator TD3DXVECTOR2.Subtract(a: TD3DXVECTOR2; b: TD3DXVECTOR2): TD3DXVECTOR2;
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
var
    fInv: single;
begin
    {$IFOPT D+}
    if (b=0) then
    begin
        result.x:=0;
        result.y:=0;
        Exit;
    end;
    {$ENDIF}
    fInv := 1.0 / b;
    Result.x := a.x * fInv;
    Result.y := a.y * fInv;
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



class operator TD3DXVECTOR2.Equal(a: TD3DXVECTOR2; b: TD3DXVECTOR2): boolean;
begin
    Result := (a.x = b.x) and (a.y = b.y);
end;



class operator TD3DXVECTOR2.NotEqual(a: TD3DXVECTOR2; b: TD3DXVECTOR2): boolean;
begin
    Result := (a.x <> b.x) or (a.y <> b.y);
end;

{ TD3DXVECTOR2_16F }

class operator TD3DXVECTOR2_16F.Initialize(var aRec: TD3DXVECTOR2_16F);
begin
    aRec.x.Value := 0;
    aRec.Y.Value := 0;
end;



procedure TD3DXVECTOR2_16F.Init(f: PSingle);
begin
    {$IFOPT D+}
    if (f=nil) then
    begin
        Exit;
    end;
    {$ENDIF}
    D3DXFloat32To16Array(@self, f, 2);
end;



procedure TD3DXVECTOR2_16F.Init(f: PD3DXFLOAT16);
var
    a: array of TD3DXFLOAT16 absolute f;
begin
    {$IFOPT D+}
    if (f=nil) then
    begin
        Exit;
    end;
    {$ENDIF}
    Self.x := a[0];
    Self.y := a[1];
end;



procedure TD3DXVECTOR2_16F.Init(x, y: TD3DXFLOAT16);
begin
    self.x := x;
    self.y := y;
end;



class operator TD3DXVECTOR2_16F.Equal(a: TD3DXVECTOR2_16F; b: TD3DXVECTOR2_16F): boolean;
begin
    Result := (a.x = b.x) and (a.y = b.y);

end;



class operator TD3DXVECTOR2_16F.NotEqual(a: TD3DXVECTOR2_16F; b: TD3DXVECTOR2_16F): boolean;
begin
    Result := (a.x <> b.x) or (a.y <> b.y);
end;

{ TD3DXVECTOR3 }

class operator TD3DXVECTOR3.Initialize(var aRec: TD3DXVECTOR3);
begin
    aRec.x := 0;
    aRec.y := 0;
    aRec.z := 0;

end;



procedure TD3DXVECTOR3.Init(x, y, z: single);
begin
    self.x := x;
    self.y := y;
    self.z := z;
end;



procedure TD3DXVECTOR3.Init(x: PSingle);
var
    a: array of single absolute x;
begin
    {$IFOPT D+}
    if (x=nil) then
    begin
        Exit;
    end;
    {$ENDIF}
    self.x := a[0];
    self.y := a[1];
    self.z := a[2];
end;



procedure TD3DXVECTOR3.Init(x: PD3DVECTOR);
begin
    self.x := x^.x;
    self.y := x^.y;
    self.z := x^.z;

end;



procedure TD3DXVECTOR3.Init(f: PD3DXFLOAT16);
begin
    {$IFOPT D+}
    if (f=nil) then
    begin
        Exit;
    end;
    {$ENDIF}
    D3DXFloat16To32Array(@self, f, 3);
end;



class operator TD3DXVECTOR3.Explicit(a: TD3DXVECTOR3): PSingle;
begin
    Result := @a.f[0];
end;



class operator TD3DXVECTOR3.Implicit(a: TD3DXVECTOR3): TD3DVector;
begin
    Result.x := a.x;
    Result.y := a.y;
    Result.z := a.z;

end;



class operator TD3DXVECTOR3.Add(a: TD3DXVECTOR3; b: TD3DXVECTOR3): TD3DXVECTOR3;
begin
    Result.x := a.x + b.x;
    Result.y := a.y + b.y;
    Result.z := a.z + b.z;

end;



class operator TD3DXVECTOR3.Subtract(a: TD3DXVECTOR3; b: TD3DXVECTOR3): TD3DXVECTOR3;
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
var
    fInv: single;
begin
    fInv := 1.0 / b;
    Result.x := a.x * fInv;
    Result.y := a.y * fInv;
    Result.z := a.z * fInv;
end;



class operator TD3DXVECTOR3.Positive(a: TD3DXVECTOR3): TD3DXVECTOR3;
begin
    Result := a;
end;



class operator TD3DXVECTOR3.Negative(a: TD3DXVECTOR3): TD3DXVECTOR3;
begin
    Result.x := -a.x;
    Result.y := -a.y;
    Result.z := -a.z;

end;



class operator TD3DXVECTOR3.Equal(a: TD3DXVECTOR3; b: TD3DXVECTOR3): boolean;
begin
    Result := (a.x = b.x) and (a.y = b.y) and (a.z = b.z);
end;



class operator TD3DXVECTOR3.NotEqual(a: TD3DXVECTOR3; b: TD3DXVECTOR3): boolean;
begin
    Result := (a.x <> b.x) or (a.y <> b.y) or (a.z <> b.z);
end;

{ TD3DXVECTOR3_16F }

class operator TD3DXVECTOR3_16F.Initialize(var aRec: TD3DXVECTOR3_16F);
begin
    aRec.x.Value := 0;
    aRec.y.Value := 0;
    aRec.z.Value := 0;
end;



procedure TD3DXVECTOR3_16F.Init(pf: PSingle);
begin
    {$IFOPT D+}
    if (pf=nil) then
    begin
        Exit;
    end;
    {$ENDIF}
    D3DXFloat32To16Array(@self.x, pf, 3);

end;



procedure TD3DXVECTOR3_16F.Init(v: PD3DVECTOR);
begin
    {$IFOPT D+}
    if (v=nil) then
    begin
        Exit;
    end;
    {$ENDIF}
    D3DXFloat32To16Array(@self.x, @(v^.x), 1);
    D3DXFloat32To16Array(@self.y, @(v^.y), 1);
    D3DXFloat32To16Array(@self.z, @(v^.z), 1);
end;



procedure TD3DXVECTOR3_16F.Init(f: PD3DXFLOAT16);
var
    a: array of TD3DXFLOAT16 absolute f;
begin
    {$IFOPT D+}
    if (f=nil) then
    begin
        Exit;
    end;
    {$ENDIF}
    self.x.Value := a[0].Value;
    self.y.Value := a[1].Value;
    self.z.Value := a[2].Value;

end;



procedure TD3DXVECTOR3_16F.Init(x, y, z: TD3DXFLOAT16);
begin
    self.x := x;
    self.y := y;
    self.z := z;
end;



class operator TD3DXVECTOR3_16F.Equal(a: TD3DXVECTOR3_16F; b: TD3DXVECTOR3_16F): boolean;
begin
    Result := (a.x.Value = b.x.Value) and (a.y.Value = b.y.Value) and (a.z.Value = b.z.Value);
end;



class operator TD3DXVECTOR3_16F.NotEqual(a: TD3DXVECTOR3_16F; b: TD3DXVECTOR3_16F): boolean;
begin
    Result := (a.x.Value <> b.x.Value) and (a.y.Value <> b.y.Value) and (a.z.Value <> b.z.Value);
end;

{ TD3DXVECTOR4 }

//--------------------------
// 4D Vector
//--------------------------

class operator TD3DXVECTOR4.Initialize(var aRec: TD3DXVECTOR4);
begin
    aRec.x := 0;
    aRec.y := 0;
    aRec.z := 0;
    aRec.w := 0;
end;



procedure TD3DXVECTOR4.Init(pf: PSingle);
var
    a: array of single absolute pf;
begin
    {$IFOPT D+}
    if (pf=nil) then
    begin
        Exit;
    end;
    {$ENDIF}
    x := pf[0];
    y := pf[1];
    z := pf[2];
    w := pf[3];
end;



procedure TD3DXVECTOR4.Init(f: PD3DXFLOAT16);
begin
    {$IFOPT D+}
    if (f=nil) then
    begin
        Exit;
    end;
    {$ENDIF}
    D3DXFloat16To32Array(@self.x, f, 4);
end;



procedure TD3DXVECTOR4.Init(f: PD3DVECTOR; w: single);
begin
    Self.x := f.x;
    Self.y := f.y;
    Self.z := f.z;
    Self.w := w;
end;



procedure TD3DXVECTOR4.Init(fx, fy, fz, fw: single);
begin
    x := fx;
    y := fy;
    z := fz;
    w := fw;
end;



class operator TD3DXVECTOR4.Explicit(a: TD3DXVECTOR4): PSingle;
begin
    Result := a.f;
end;



class operator TD3DXVECTOR4.Add(a: TD3DXVECTOR4; b: TD3DXVECTOR4): TD3DXVECTOR4;
begin
    Result.x := a.x + b.x;
    Result.y := a.y + b.y;
    Result.z := a.z + b.z;
    Result.w := a.w + b.w;

end;



class operator TD3DXVECTOR4.Subtract(a: TD3DXVECTOR4; b: TD3DXVECTOR4): TD3DXVECTOR4;
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
var
    fInv: single;
begin
    fInv := 1 / b;
    Result.x := a.x * fInv;
    Result.y := a.y * fInv;
    Result.z := a.z * fInv;
    Result.w := a.w * fInv;
end;



class operator TD3DXVECTOR4.Positive(a: TD3DXVECTOR4): TD3DXVECTOR4;
begin
    Result := a;
end;



class operator TD3DXVECTOR4.Negative(a: TD3DXVECTOR4): TD3DXVECTOR4;
begin
    Result.x := -a.x;
    Result.y := -a.y;
    Result.z := -a.z;
    Result.w := -a.w;
end;



class operator TD3DXVECTOR4.Equal(a: TD3DXVECTOR4; v: TD3DXVECTOR4): boolean;
begin
    Result := (a.x = v.x) and (a.y = v.y) and (a.z = v.z) and (a.w = v.w);
end;



class operator TD3DXVECTOR4.NotEqual(a: TD3DXVECTOR4; v: TD3DXVECTOR4): boolean;
begin
    Result := (a.x <> v.x) or (a.y <> v.y) or (a.z <> v.z) or (a.w <> v.w);
end;

{ TD3DXVECTOR4_16F }

//--------------------------
// 4D Vector (16 bit)
//--------------------------

class operator TD3DXVECTOR4_16F.Initialize(var aRec: TD3DXVECTOR4_16F);
begin
    aRec.x.Value := 0;
    aRec.y.Value := 0;
    aRec.z.Value := 0;
    aRec.w.Value := 0;

end;



procedure TD3DXVECTOR4_16F.Init(pf: PSingle);
begin
    D3DXFloat32To16Array(@self.f[0], pf, 4);
end;



procedure TD3DXVECTOR4_16F.Init(f: PD3DXFLOAT16);
var
    pf: array of TD3DXFLOAT16 absolute f;
begin
    self.f[0] := pf[0];
    self.f[1] := pf[1];
    self.f[2] := pf[2];
    self.f[3] := pf[3];
end;



procedure TD3DXVECTOR4_16F.Init(xyz: PD3DXVECTOR3_16F; w: TD3DXFLOAT16);
begin
    Self.x := xyz.x;
    Self.y := xyz.y;
    Self.z := xyz.z;
    Self.w := w;
end;



procedure TD3DXVECTOR4_16F.Init(x, y, z, w: TD3DXFLOAT16);
begin
    self.x := x;
    self.y := y;
    self.z := z;
    self.w := w;
end;



class operator TD3DXVECTOR4_16F.Explicit(a: TD3DXVECTOR4_16F): PD3DXFLOAT16;
begin
    Result := @a.f[0];
end;



class operator TD3DXVECTOR4_16F.Equal(a: TD3DXVECTOR4_16F; b: TD3DXVECTOR4_16F): boolean;
begin
    Result := (a.x.Value = b.x.Value) and (a.y.Value = b.y.Value) and (a.z.Value = b.z.Value) and (a.w.Value = b.w.Value);
end;



class operator TD3DXVECTOR4_16F.NotEqual(a: TD3DXVECTOR4_16F; b: TD3DXVECTOR4_16F): boolean;
begin
    Result := (a.x.Value <> b.x.Value) or (a.y.Value <> b.y.Value) or (a.z.Value <> b.z.Value) or (a.w.Value <> b.w.Value);
end;

{ TD3DXMATRIX }
//--------------------------
// Matrix
//--------------------------

class operator TD3DXMATRIX.Initialize(var aRec: TD3DXMATRIX);
var
    i: integer;
begin
    for i := 0 to 15 do
        arec.f[i] := 0;
end;



procedure TD3DXMATRIX.Init(x: PD3DMATRIX);
var
    i: integer;
begin
    for i := 0 to 15 do
        self.f[i] := x^.f[i];
end;



procedure TD3DXMATRIX.Init(pf: PD3DXFLOAT16);
begin
    {$IFOPT D+}
    if (pf=nil) then
    begin
        Exit;
    end;
    {$ENDIF}
    D3DXFloat16To32Array(@self.f[0], pf, 16);
end;



procedure TD3DXMATRIX.Init(pf: PSingle);
var
    f: array of single absolute pf;
    i: integer;
begin
    {$IFOPT D+}
    if (pf=nil) then
    begin
        Exit;
    end;
    {$ENDIF}
    for i := 0 to 15 do
        self.f[i] := f[i];
end;



procedure TD3DXMATRIX.Initf(f11, f12, f13, f14, f21, f22, f23, f24, f31, f32, f33, f34, f41, f42, f43, f44: single);
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



function TD3DXMATRIX.Element(Row: UINT; Col: UINT): single;
begin
    Result := m[Row][Col];
end;



class operator TD3DXMATRIX.Explicit(a: TD3DXMATRIX): PSingle;
begin
    Result := @a.f[0];
end;



class operator TD3DXMATRIX.Add(a: TD3DXMATRIX; b: TD3DXMATRIX): TD3DXMATRIX;
var
    i: integer;
begin
    for i := 0 to 15 do
        Result.f[i] := a.f[i] + b.f[i];
end;



class operator TD3DXMATRIX.Subtract(a: TD3DXMATRIX; b: TD3DXMATRIX): TD3DXMATRIX;
var
    i: integer;
begin
    for i := 0 to 15 do
        Result.f[i] := a.f[i] - b.f[i];
end;



class operator TD3DXMATRIX.Multiply(a: TD3DXMATRIX; b: TD3DXMATRIX): TD3DXMATRIX;
var
    mT: TD3DXMATRIX;
begin
    mT := D3DXMatrixMultiply(@mT, @a, @b)^;
    Result := mT;
end;



class operator TD3DXMATRIX.Multiply(a: TD3DXMATRIX; b: single): TD3DXMATRIX;
var
    i: integer;
begin
    for i := 0 to 15 do
        Result.f[i] := a.f[i] * b;
end;



class operator TD3DXMATRIX.Divide(a: TD3DXMATRIX; b: single): TD3DXMATRIX;
var
    i: integer;
    fInv: single;
begin
    fInv := 1 / b;
    for i := 0 to 15 do
        Result.f[i] := a.f[i] * fInv;
end;



class operator TD3DXMATRIX.Positive(a: TD3DXMATRIX): TD3DXMATRIX;
var
    i: integer;
begin
    for i := 0 to 15 do
        Result.f[i] := a.f[i];

end;



class operator TD3DXMATRIX.Negative(a: TD3DXMATRIX): TD3DXMATRIX;
var
    i: integer;
begin
    for i := 0 to 15 do
        Result.f[i] := -a.f[i];
end;



class operator TD3DXMATRIX.Equal(a: TD3DXMATRIX; b: TD3DXMATRIX): boolean;
var
    i: integer;
begin
    Result := True;
    for i := 0 to 15 do
        Result := Result and (a.f[i] = b.f[i]);
end;



class operator TD3DXMATRIX.NotEqual(a: TD3DXMATRIX; b: TD3DXMATRIX): boolean;
var
    i: integer;
begin
    Result := False;
    for i := 0 to 15 do
        Result := Result or (a.f[i] <> b.f[i]);
end;

{ TD3DXMATRIXA16 }

class operator TD3DXMATRIXA16.Initialize(var aRec: TD3DXMATRIXA16);
var
    i: integer;
begin
    for i := 0 to 15 do
        arec.f[i] := 0;
end;



procedure TD3DXMATRIXA16.Init(x: PD3DMATRIX);
var
    i: integer;
begin
    for i := 0 to 15 do
        self.f[i] := x^.f[i];
end;



procedure TD3DXMATRIXA16.Init(pf: PD3DXFLOAT16);
begin
    {$IFOPT D+}
    if (pf=nil) then
    begin
        Exit;
    end;
    {$ENDIF}
    D3DXFloat16To32Array(@self.f[0], pf, 16);
end;



procedure TD3DXMATRIXA16.Init(x: PSingle);
var
    f: array of single absolute x;
    i: integer;
begin
    {$IFOPT D+}
    if (x=nil) then
    begin
        Exit;
    end;
    {$ENDIF}
    for i := 0 to 15 do
        self.f[i] := f[i];
end;



procedure TD3DXMATRIXA16.Initf(f11, f12, f13, f14, f21, f22, f23, f24, f31, f32, f33, f34, f41, f42, f43, f44: single);
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



function TD3DXMATRIXA16.Element(Row: UINT; Col: UINT): single;
begin
    Result := m[Row][Col];
end;



class operator TD3DXMATRIXA16.Explicit(a: TD3DXMATRIXA16): PSingle;
begin
    Result := @a.f[0];
end;



class operator TD3DXMATRIXA16.Explicit(a: TD3DXMATRIXA16): TD3DXMATRIX;
begin
    Result := TD3DXMATRIX(a);
end;



class operator TD3DXMATRIXA16.Add(a: TD3DXMATRIXA16; b: TD3DXMATRIXA16): TD3DXMATRIXA16;
var
    i: integer;
begin
    for i := 0 to 15 do
        Result.f[i] := a.f[i] + b.f[i];
end;



class operator TD3DXMATRIXA16.Subtract(a: TD3DXMATRIXA16; b: TD3DXMATRIXA16): TD3DXMATRIXA16;
var
    i: integer;
begin
    for i := 0 to 15 do
        Result.f[i] := a.f[i] - b.f[i];
end;



class operator TD3DXMATRIXA16.Multiply(a: TD3DXMATRIXA16; b: TD3DXMATRIXA16): TD3DXMATRIXA16;
var
    mT: TD3DXMATRIXA16;
begin
    D3DXMatrixMultiply(@mT, @a, @b);
    Result := mT;
end;



class operator TD3DXMATRIXA16.Multiply(a: TD3DXMATRIXA16; b: single): TD3DXMATRIXA16;
var
    i: integer;
begin
    for i := 0 to 15 do
        Result.f[i] := a.f[i] * b;
end;



class operator TD3DXMATRIXA16.Divide(a: TD3DXMATRIXA16; b: single): TD3DXMATRIXA16;
var
    i: integer;
    fInv: single;
begin
    fInv := 1 / b;
    for i := 0 to 15 do
        Result.f[i] := a.f[i] * fInv;
end;



class operator TD3DXMATRIXA16.Positive(a: TD3DXMATRIXA16): TD3DXMATRIXA16;
var
    i: integer;
begin
    for i := 0 to 15 do
        Result.f[i] := a.f[i];
end;



class operator TD3DXMATRIXA16.Negative(a: TD3DXMATRIXA16): TD3DXMATRIXA16;
var
    i: integer;
begin
    for i := 0 to 15 do
        Result.f[i] := -a.f[i];
end;



class operator TD3DXMATRIXA16.Equal(a: TD3DXMATRIXA16; b: TD3DXMATRIXA16): boolean;
var
    i: integer;
begin
    Result := True;
    for i := 0 to 15 do
        Result := Result and (a.f[i] = b.f[i]);

end;



class operator TD3DXMATRIXA16.NotEqual(a: TD3DXMATRIXA16; b: TD3DXMATRIXA16): boolean;
var
    i: integer;
begin
    Result := False;
    for i := 0 to 15 do
        Result := Result or (a.f[i] <> b.f[i]);

end;

{ TD3DXQUATERNION }

//--------------------------
// Quaternion
//--------------------------

class operator TD3DXQUATERNION.Initialize(var aRec: TD3DXQUATERNION);
begin
    aRec.x := 0;
    aRec.y := 0;
    aRec.z := 0;
    aRec.w := 0;

end;



procedure TD3DXQUATERNION.Init(pf: PSingle);
var
    a: array of single absolute pf;
begin
    {$IFOPT D+}
    if (pf=nil) then
    begin
        Exit;
    end;
    {$ENDIF}
    x := a[0];
    y := a[1];
    z := a[2];
    w := a[3];
end;



procedure TD3DXQUATERNION.Init(pf: PD3DXFLOAT16);
begin
    {$IFOPT D+}
    if (pf=nil) then
    begin
        Exit;
    end;
    {$ENDIF}
    D3DXFloat16To32Array(@f[0], pf, 4);
end;



procedure TD3DXQUATERNION.Init(fx, fy, fz, fw: single);
begin
    x := fx;
    y := fy;
    z := fz;
    w := fw;
end;



class operator TD3DXQUATERNION.Explicit(a: TD3DXQUATERNION): PSingle;
begin
    Result := @a.f[0];
end;



class operator TD3DXQUATERNION.Add(a: TD3DXQUATERNION; b: TD3DXQUATERNION): TD3DXQUATERNION;
begin
    Result.x := a.x + b.x;
    Result.y := a.y + b.y;
    Result.z := a.z + b.z;
    Result.w := a.w + b.w;
end;



class operator TD3DXQUATERNION.Subtract(a: TD3DXQUATERNION; b: TD3DXQUATERNION): TD3DXQUATERNION;
begin
    Result.x := a.x - b.x;
    Result.y := a.y - b.y;
    Result.z := a.z - b.z;
    Result.w := a.w - b.w;
end;



class operator TD3DXQUATERNION.Multiply(a: TD3DXQUATERNION; b: TD3DXQUATERNION): TD3DXQUATERNION;
var
    qT: TD3DXQUATERNION;
begin
    D3DXQuaternionMultiply(@qT, @a, @b);
    Result := qT;
end;



class operator TD3DXQUATERNION.Multiply(a: TD3DXQUATERNION; b: single): TD3DXQUATERNION;
begin
    Result.x := a.x * b;
    Result.y := a.y * b;
    Result.z := a.z * b;
    Result.w := a.w * b;
end;



class operator TD3DXQUATERNION.Divide(a: TD3DXQUATERNION; b: single): TD3DXQUATERNION;
var
    fInv: single;
begin
    fInv := 1 / b;
    Result.x := a.x * fInv;
    Result.y := a.y * fInv;
    Result.z := a.z * fInv;
    Result.w := a.w * fInv;
end;



class operator TD3DXQUATERNION.Positive(a: TD3DXQUATERNION): TD3DXQUATERNION;
begin
    Result.x := a.x;
    Result.y := a.y;
    Result.z := a.z;
    Result.w := a.w;
end;



class operator TD3DXQUATERNION.Negative(a: TD3DXQUATERNION): TD3DXQUATERNION;
begin
    Result.x := -a.x;
    Result.y := -a.y;
    Result.z := -a.z;
    Result.w := -a.w;
end;



class operator TD3DXQUATERNION.Equal(a: TD3DXQUATERNION; q: TD3DXQUATERNION): boolean;
begin
    Result := (a.x = q.x) and (a.y = q.y) and (a.z = q.z) and (a.w = q.w);
end;



class operator TD3DXQUATERNION.NotEqual(a: TD3DXQUATERNION; q: TD3DXQUATERNION): boolean;
begin
    Result := (a.x <> q.x) or (a.y <> q.y) or (a.z <> q.z) or (a.w <> q.w);
end;

{ TD3DXPLANE }

//--------------------------
// Plane
//--------------------------

class operator TD3DXPLANE.Initialize(var aRec: TD3DXPLANE);
begin
    aRec.a := 0;
    aRec.b := 0;
    aRec.c := 0;
    aRec.d := 0;

end;



procedure TD3DXPLANE.Init(f: PSingle);
var
    pf: array of single absolute f;
begin
    {$IFOPT D+}
    if (f=nil) then
    begin
        Exit;
    end;
    {$ENDIF}
    a := pf[0];
    b := pf[1];
    c := pf[2];
    d := pf[3];
end;



procedure TD3DXPLANE.Init(pf: PD3DXFLOAT16);
begin
    {$IFOPT D+}
    if (pf=nil) then
    begin
        Exit;
    end;
    {$ENDIF}
    D3DXFloat16To32Array(@self.f[0], pf, 4);
end;



procedure TD3DXPLANE.Init(a, b, c, d: single);
begin
    self.a := a;
    self.b := b;
    self.c := c;
    self.d := d;

end;



class operator TD3DXPLANE.Explicit(a: TD3DXPLANE): PSingle;
begin
    Result := @a.f[0];
end;



class operator TD3DXPLANE.Multiply(a: TD3DXPLANE; b: single): TD3DXPLANE;
begin
    Result.a := a.a * b;
    Result.b := a.b * b;
    Result.c := a.c * b;
    Result.d := a.d * b;

end;



class operator TD3DXPLANE.Divide(a: TD3DXPLANE; b: single): TD3DXPLANE;
var
    fInv: single;
begin

    fInv := 1 / b;
    Result.a := a.a * b;
    Result.b := a.b * b;
    Result.c := a.c * b;
    Result.d := a.d * b;
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



class operator TD3DXPLANE.Equal(a: TD3DXPLANE; p: TD3DXPLANE): boolean;
begin
    Result := (a.a = p.a) and (a.b = p.b) and (a.c = p.c) and (a.d = p.d);
end;



class operator TD3DXPLANE.NotEqual(a: TD3DXPLANE; p: TD3DXPLANE): boolean;
begin
    Result := (a.a <> p.a) or (a.b <> p.b) or (a.c <> p.c) or (a.d <> p.d);
end;

{ TD3DXCOLOR }

//--------------------------
// Color
//--------------------------

class operator TD3DXCOLOR.Initialize(var aRec: TD3DXCOLOR);
begin
    aRec.a := 0;
    aRec.r := 0;
    aRec.g := 0;
    aRec.b := 0;

end;



procedure TD3DXCOLOR.Init(argb: DWORD);
const
    f: single = 1.0 / 255.0;
begin
    r := f * single(argb shr 16);
    g := f * single(argb shr 8);
    b := f * single(argb shr 0);
    a := f * single(argb shr 24);
end;



procedure TD3DXCOLOR.Init(f: PSingle);
var
    pf: array of single absolute f;
begin
    {$IFOPT D+}
    if (f=nil) then
    begin
        Exit;
    end;
    {$ENDIF}
    r := pf[0];
    g := pf[1];
    b := pf[2];
    a := pf[3];
end;



procedure TD3DXCOLOR.Init(pf: PD3DXFLOAT16);
begin
    D3DXFloat16To32Array(@f[0], pf, 4);
end;



procedure TD3DXCOLOR.Init(f: TD3DCOLORVALUE);
begin
    self.a := f.a;
    self.r := f.r;
    self.g := f.g;
    self.b := f.b;

end;



procedure TD3DXCOLOR.Init(r, g, b, a: single);
begin
    self.r := r;
    self.g := g;
    self.b := b;
    self.a := a;

end;



class operator TD3DXCOLOR.Explicit(a: TD3DXCOLOR): DWORD;
var
    dwR, dwG, dwB, dwA: dword;
begin

    if a.r >= 1.0 then
        dwR := $ff
    else if a.r <= 0.0 then
        dwR := $00
    else
        dwR := trunc(a.r * 255.0 + 0.5);
    if a.g >= 1.0 then
        dwG := $ff
    else if a.g <= 0.0 then
        dwG := $00
    else
        dwG := trunc(a.g * 255.0 + 0.5);
    if a.b >= 1.0 then
        dwB := $ff
    else if a.b <= 0.0 then
        dwB := $00
    else
        dwB := trunc(a.b * 255.0 + 0.5);
    if a.a >= 1.0 then
        dwA := $ff
    else if a.a <= 0.0 then
        dwA := $00
    else
        dwA := trunc(a.a * 255.0 + 0.5);

    Result := (dwA shl 24) or (dwR shl 16) or (dwG shl 8) or dwB;
end;



class operator TD3DXCOLOR.Explicit(a: TD3DXCOLOR): PSingle;
begin
    Result := @a.f[0];
end;



class operator TD3DXCOLOR.Explicit(a: TD3DXCOLOR): PD3DCOLORVALUE;
begin
    Result := @(a.c);
end;



class operator TD3DXCOLOR.Explicit(a: TD3DXCOLOR): TD3DCOLORVALUE;
begin
    Result := a.c;
end;



class operator TD3DXCOLOR.Add(a: TD3DXCOLOR; b: TD3DXCOLOR): TD3DXCOLOR;
begin
    Result.a := a.a + b.a;
    Result.r := a.r + b.r;
    Result.g := a.g + b.g;
    Result.b := a.b + b.b;

end;



class operator TD3DXCOLOR.Subtract(a: TD3DXCOLOR; b: TD3DXCOLOR): TD3DXCOLOR;
begin
    Result.a := a.a - b.a;
    Result.r := a.r - b.r;
    Result.g := a.g - b.g;
    Result.b := a.b - b.b;
end;



class operator TD3DXCOLOR.Multiply(a: TD3DXCOLOR; b: single): TD3DXCOLOR;
begin
    Result.a := a.a * b;
    Result.r := a.r * b;
    Result.g := a.g * b;
    Result.b := a.b * b;
end;



class operator TD3DXCOLOR.Divide(a: TD3DXCOLOR; b: single): TD3DXCOLOR;
var
    fInv: single;
begin
    fInv := 1 / b;
    Result.a := a.a * fInv;
    Result.r := a.r * fInv;
    Result.g := a.g * fInv;
    Result.b := a.b * fInv;
end;



class operator TD3DXCOLOR.Positive(a: TD3DXCOLOR): TD3DXCOLOR;
begin
    Result.a := a.a;
    Result.r := a.r;
    Result.g := a.g;
    Result.b := a.b;
end;



class operator TD3DXCOLOR.Negative(a: TD3DXCOLOR): TD3DXCOLOR;
begin
    Result.a := -a.a;
    Result.r := -a.r;
    Result.g := -a.g;
    Result.b := -a.b;
end;



class operator TD3DXCOLOR.Equal(a: TD3DXCOLOR; c: TD3DXCOLOR): boolean;
begin
    Result := (a.r = c.r) and (a.g = c.g) and (a.b = c.b) and (a.a = c.a);
end;



class operator TD3DXCOLOR.NotEqual(a: TD3DXCOLOR; c: TD3DXCOLOR): boolean;
begin
    Result := (a.r <> c.r) or (a.g <> c.g) or (a.b <> c.b) or (a.a <> c.a);
end;


end.
