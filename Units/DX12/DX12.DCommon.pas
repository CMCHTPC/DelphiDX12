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
   
   Copyright (c) Microsoft Corporation.  All rights reserved.
   Abstract:
          Public API definitions shared by DWrite, D2D, and DImage.
   
   This unit consists of the following header files
   File name: dcommon.h
   Header version: 10.0.26100.6584
   
  ************************************************************************** }
unit DX12.DCommon;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

{$Z4}

uses
    Windows, Classes, SysUtils, DX12.DXGIFormat;

type

    // Forward declarations

    // IDXGISurface = interface;

    /// The measuring method used for text layout.
    TDWRITE_MEASURING_MODE = (
        /// Text is measured using glyph ideal metrics whose values are independent to the current display resolution.
        DWRITE_MEASURING_MODE_NATURAL,
        /// Text is measured using glyph display compatible metrics whose values tuned for the current display resolution.
        DWRITE_MEASURING_MODE_GDI_CLASSIC,
        // Text is measured using the same glyph display metrics as text measured by GDI using a font
        // created with CLEARTYPE_NATURAL_QUALITY.
        DWRITE_MEASURING_MODE_GDI_NATURAL
        );

    //{$IF NTDDI_VERSION >= NTDDI_WIN10_RS1}
    /// Fonts may contain multiple drawable data formats for glyphs. These flags specify which formats
    /// are supported in the font, either at a font-wide level or per glyph, and the app may use them
    /// to tell DWrite which formats to return when splitting a color glyph run.
    TDWRITE_GLYPH_IMAGE_FORMATS = (
        /// Indicates no data is available for this glyph.
        DWRITE_GLYPH_IMAGE_FORMATS_NONE = $00000000,
        /// The glyph has TrueType outlines.
        DWRITE_GLYPH_IMAGE_FORMATS_TRUETYPE = $00000001,
        /// The glyph has CFF outlines.
        DWRITE_GLYPH_IMAGE_FORMATS_CFF = $00000002,
        /// The glyph has multilayered COLR data.
        DWRITE_GLYPH_IMAGE_FORMATS_COLR = $00000004,
        /// The glyph has SVG outlines as standard XML.
        /// <remarks>
        /// Fonts may store the content gzip'd rather than plain text,
        /// indicated by the first two bytes as gzip header {0x1F 0x8B}.
        /// </remarks>
        DWRITE_GLYPH_IMAGE_FORMATS_SVG = $00000008,
        /// The glyph has PNG image data, with standard PNG IHDR.
        DWRITE_GLYPH_IMAGE_FORMATS_PNG = $00000010,
        /// The glyph has JPEG image data, with standard JIFF SOI header.
        DWRITE_GLYPH_IMAGE_FORMATS_JPEG = $00000020,
        /// The glyph has TIFF image data.
        DWRITE_GLYPH_IMAGE_FORMATS_TIFF = $00000040,
        /// The glyph has raw 32-bit premultiplied BGRA data.
        DWRITE_GLYPH_IMAGE_FORMATS_PREMULTIPLIED_B8G8R8A8 = $00000080,
        /// The glyph is represented by a tree of paint elements in the
        /// font's COLR table.
        DWRITE_GLYPH_IMAGE_FORMATS_COLR_PAINT_TREE = $00000100
        );

    PDWRITE_GLYPH_IMAGE_FORMATS = ^TDWRITE_GLYPH_IMAGE_FORMATS;
    //{$ENDIF}

    /// Qualifies how alpha is to be treated in a bitmap or render target containing
    /// alpha.
    TD2D1_ALPHA_MODE = (
        /// Alpha mode should be determined implicitly. Some target surfaces do not supply
        /// or imply this information in which case alpha must be specified.
        D2D1_ALPHA_MODE_UNKNOWN = 0,
        /// Treat the alpha as premultipled.
        D2D1_ALPHA_MODE_PREMULTIPLIED = 1,
        /// Opacity is in the 'A' component only.
        D2D1_ALPHA_MODE_STRAIGHT = 2,
        /// Ignore any alpha channel information.
        D2D1_ALPHA_MODE_IGNORE = 3,
        D2D1_ALPHA_MODE_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_ALPHA_MODE = ^TD2D1_ALPHA_MODE;

    /// Description of a pixel format.
    TD2D1_PIXEL_FORMAT = record
        format: TDXGI_FORMAT;
        alphaMode: TD2D1_ALPHA_MODE;
    end;
    PD2D1_PIXEL_FORMAT = ^TD2D1_PIXEL_FORMAT;

    /// Represents an x-coordinate and y-coordinate pair in two-dimensional space.

    { TD2D_POINT_2U }

    TD2D_POINT_2U = record
        x: uint32;
        y: uint32;
        procedure Init(x: uint32 = 0; y: uint32 = 0);
    end;
    PD2D_POINT_2U = ^TD2D_POINT_2U;

    /// Represents a 3-by-2 matrix.

    { TD2D_MATRIX_3X2_F }
    TD2D_MATRIX_3X2_F = record
        // Named quasi-constructors
        class operator Initialize(var aRec: TD2D_MATRIX_3X2_F);
        class operator Multiply(a, b: TD2D_MATRIX_3X2_F): TD2D_MATRIX_3X2_F;
        procedure Init(m11, m12, m21, m22, m31, m32: single);
        procedure Identity;

        case byte of
            0: (
                // Horizontal scaling / cosine of rotation
                m11: single;
                // Vertical shear / sine of rotation
                m12: single;
                // Horizontal shear / negative sine of rotation
                m21: single;
                // Vertical scaling / cosine of rotation
                m22: single;
                // Horizontal shift (always orthogonal regardless of rotation)
                dx: single;
                // Vertical shift (always orthogonal regardless of rotation)
                dy: single);
            1: (_11, _12: single;
                _21, _22: single;
                _31, _32: single);
            2: (m: array [0..3 - 1, 0..2 - 1] of single);
    end;
    PD2D_MATRIX_3X2_F = ^TD2D_MATRIX_3X2_F;

    /// Represents an x-coordinate and y-coordinate pair in two-dimensional space.

    { TD2D_POINT_2F }

    TD2D_POINT_2F = record
        x: single;
        y: single;
        class operator Initialize(var aRec: TD2D_POINT_2F);
        class operator Multiply(a: TD2D_POINT_2F; b: TD2D_MATRIX_3X2_F): TD2D_POINT_2F;
        procedure Init(x: single = 0; y: single = 0);
    end;
    PD2D_POINT_2F = ^TD2D_POINT_2F;

    TD2D_POINT_2L = TPOINT;
    PD2D_POINT_2L = ^TD2D_POINT_2L;

    /// A vector of 2 FLOAT values (x, y).

    { TD2D_VECTOR_2F }

    TD2D_VECTOR_2F = record
        x: single;
        y: single;
        procedure Init(x: single = 0; y: single = 0);
    end;
    PD2D_VECTOR_2F = ^TD2D_VECTOR_2F;

    /// A vector of 3 FLOAT values (x, y, z).

    { TD2D_VECTOR_3F }

    TD2D_VECTOR_3F = record
        x: single;
        y: single;
        z: single;
        procedure Init(x: single = 0; y: single = 0; z: single = 0);
    end;
    PD2D_VECTOR_3F = ^TD2D_VECTOR_3F;

    /// A vector of 4 FLOAT values (x, y, z, w).

    { TD2D_VECTOR_4F }

    TD2D_VECTOR_4F = record
        x: single;
        y: single;
        z: single;
        w: single;
        procedure Init(x: single = 0; y: single = 0; z: single = 0; w: single = 0);
    end;
    PD2D_VECTOR_4F = ^TD2D_VECTOR_4F;

    /// Represents a rectangle defined by the coordinates of the upper-left corner
    /// (left, top) and the coordinates of the lower-right corner (right, bottom).

    { TD2D_RECT_F }

    TD2D_RECT_F = record
        left: single;
        top: single;
        right: single;
        bottom: single;
        procedure Init(left: single = 0; top: single = 0; right: single = 0; bottom: single = 0);
        procedure InfiniteRect;
    end;
    PD2D_RECT_F = ^TD2D_RECT_F;

    /// Represents a rectangle defined by the coordinates of the upper-left corner
    /// (left, top) and the coordinates of the lower-right corner (right, bottom).

    { TD2D_RECT_U }

    TD2D_RECT_U = record
        left: uint32;
        top: uint32;
        right: uint32;
        bottom: uint32;
        procedure Init(left: uint32 = 0; top: uint32 = 0; right: uint32 = 0; bottom: uint32 = 0);
        class operator Equal(a: TD2D_RECT_U; r: TD2D_RECT_U): boolean;
        procedure InfiniteRectU;
    end;
    PD2D_RECT_U = ^TD2D_RECT_U;

    TD2D_RECT_L = RECT;

    PD2D_RECT_L = ^TD2D_RECT_L;

    /// Stores an ordered pair of floats, typically the width and height of a rectangle.

    { TD2D_SIZE_F }

    TD2D_SIZE_F = record
        Width: single;
        Height: single;
        procedure Init(Width: single = 0; Height: single = 0);
    end;
    PD2D_SIZE_F = ^TD2D_SIZE_F;

    /// Stores an ordered pair of integers, typically the width and height of a
    /// rectangle.

    { TD2D_SIZE_U }

    TD2D_SIZE_U = record
        Width: uint32;
        Height: uint32;
        procedure Init(Width: uint32 = 0; Height: uint32 = 0);
        class operator Equal(a: TD2D_SIZE_U; r: TD2D_SIZE_U): boolean;
    end;
    PD2D_SIZE_U = ^TD2D_SIZE_U;



    // Represents a 4-by-3 matrix.

    { TD2D_MATRIX_4X3_F }

    TD2D_MATRIX_4X3_F = record
        class operator Initialize(var aRec: TD2D_MATRIX_4X3_F);
        procedure Init(m11, m12, m13, m21, m22, m23, m31, m32, m33, m41, m42, m43: single);
        case byte of
            0: (
                _11, _12, _13: single;
                _21, _22, _23: single;
                _31, _32, _33: single;
                _41, _42, _43: single);
            1: (m: array [0..3, 0..2] of single);
            2:(f: array[0..11] of single);
    end;
    PD2D_MATRIX_4X3_F = ^TD2D_MATRIX_4X3_F;

    // Represents a 4-by-4 matrix.

    { TD2D_MATRIX_4X4_F }

    TD2D_MATRIX_4X4_F = record
        class operator Initialize(var aRec: TD2D_MATRIX_4X4_F);
        class operator Equal(a: TD2D_MATRIX_4X4_F; r: TD2D_MATRIX_4X4_F): boolean;
        class operator NotEqual(a: TD2D_MATRIX_4X4_F; r: TD2D_MATRIX_4X4_F): boolean;
        class operator Multiply(a, b: TD2D_MATRIX_4X4_F): TD2D_MATRIX_4X4_F;
        procedure Init(m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44: single);
        procedure Translation(x, y, z: single);
        procedure Scale(x, y, z: single);
        procedure RotationX(degreeX: single);
        procedure RotationY(degreeY: single);
        procedure RotationZ(degreeZ: single);
        // 3D Rotation matrix for an arbitrary axis specified by x, y and z
        procedure RotationArbitraryAxis(x, y, z, degree: single);
        procedure SkewX(degreeX: single);
        procedure SkewY(degreeY: single);
        procedure PerspectiveProjection(depth: single);
        function Determinant: single;
        function IsIdentity: boolean;
        procedure SetProduct(a, b: TD2D_MATRIX_4X4_F);
        case byte of
            0: (_11, _12, _13, _14: single;
                _21, _22, _23, _24: single;
                _31, _32, _33, _34: single;
                _41, _42, _43, _44: single);
            1: (m: array [0..4 - 1, 0..4 - 1] of single);
            2:(f: array[0..15] of single);
    end;
    PD2D_MATRIX_4X4_F = ^TD2D_MATRIX_4X4_F;

    // Represents a 5-by-4 matrix.

    { TD2D_MATRIX_5X4_F }

    TD2D_MATRIX_5X4_F = record
        class operator Initialize(var aRec: TD2D_MATRIX_5X4_F);
        procedure Init(m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44, m51, m52, m53, m54: single);
        case byte of
            0: (_11, _12, _13, _14: single;
                _21, _22, _23, _24: single;
                _31, _32, _33, _34: single;
                _41, _42, _43, _44: single;
                _51, _52, _53, _54: single);
            1: (m: array [0..5 - 1, 0..4 - 1] of single);
            2:(f: array[0..19] of single);
    end;
    PD2D_MATRIX_5X4_F = ^TD2D_MATRIX_5X4_F;

    TD2D1_POINT_2F = TD2D_POINT_2F;
    PD2D1_POINT_2F = ^TD2D1_POINT_2F;

    TD2D1_POINT_2U = TD2D_POINT_2U;
    PD2D1_POINT_2U = ^TD2D1_POINT_2U;

    TD2D1_POINT_2L = TD2D_POINT_2L;
    PD2D1_POINT_2L = ^TD2D1_POINT_2L;

    { TD2D1_POINT_2LHelper }

    TD2D1_POINT_2LHelper = record helper for TD2D1_POINT_2L
        procedure Init(x: int32 = 0; y: int32 = 0);
    end;

    TD2D1_RECT_F = TD2D_RECT_F;
    PD2D1_RECT_F = ^TD2D1_RECT_F;

    TD2D1_RECT_U = TD2D_RECT_U;
    PD2D1_RECT_U = ^TD2D1_RECT_U;

    TD2D1_RECT_L = TD2D_RECT_L;
    PD2D1_RECT_L = ^TD2D1_RECT_L;

    { TD2D1_RECT_LHelper }

    TD2D1_RECT_LHelper = record helper for  TD2D1_RECT_L
        procedure Init(left: int32 = 0; top: int32 = 0; right: int32 = 0; bottom: int32 = 0);
    end;




    TD2D1_SIZE_F = TD2D_SIZE_F;
    PD2D1_SIZE_F = ^TD2D1_SIZE_F;

    TD2D1_SIZE_U = TD2D_SIZE_U;
    PD2D1_SIZE_U = ^TD2D1_SIZE_U;

    TD2D1_MATRIX_3X2_F = TD2D_MATRIX_3X2_F;
    PD2D1_MATRIX_3X2_F = ^TD2D1_MATRIX_3X2_F;


implementation


uses
    DX12.D2D1_1,
    DX12.D2D1Helper;

    { TD2D_POINT_2U }

procedure TD2D_POINT_2U.Init(x: uint32; y: uint32);
begin
    self.x := x;
    self.y := y;
end;

{ TD2D_POINT_2F }

class operator TD2D_POINT_2F.Initialize(var aRec: TD2D_POINT_2F);
begin
    aRec.x := 0;
    aRec.Y := 0;
end;



class operator TD2D_POINT_2F.Multiply(a: TD2D_POINT_2F; b: TD2D_MATRIX_3X2_F): TD2D_POINT_2F;
begin
    Result.x := a.x * b._11 + a.y * b._21 + b._31;
    Result.y := a.x * b._12 + a.y * b._22 + b._32;
end;



procedure TD2D_POINT_2F.Init(x: single; y: single);
begin
    self.x := x;
    self.y := y;
end;

{ TD2D_VECTOR_2F }

procedure TD2D_VECTOR_2F.Init(x: single; y: single);
begin
   self.x := x;
    self.y := y;
end;

{ TD2D_VECTOR_3F }

procedure TD2D_VECTOR_3F.Init(x: single; y: single; z: single);
begin
  self.x := x;
    self.y := y;
    self.z := z;
end;

{ TD2D_VECTOR_4F }

procedure TD2D_VECTOR_4F.Init(x: single; y: single; z: single; w: single);
begin
  self.x := x;
    self.y := y;
    self.z := z;
    self.w := w;
end;

{ TD2D_RECT_F }

procedure TD2D_RECT_F.Init(left: single; top: single; right: single; bottom: single);
begin
    self.left := left;
    self.top := top;
    self.right := right;
    self.bottom := bottom;
end;



procedure TD2D_RECT_F.InfiniteRect;
begin
    self.left := -FloatMax;
    self.top := -FloatMax;
    self.right := FloatMax;
    self.bottom := FloatMax;
end;

{ TD2D_RECT_U }

procedure TD2D_RECT_U.Init(left: uint32; top: uint32; right: uint32; bottom: uint32);
begin
    self.left := left;
    self.top := top;
    self.right := right;
    self.bottom := bottom;
end;



class operator TD2D_RECT_U.Equal(a: TD2D_RECT_U; r: TD2D_RECT_U): boolean;
begin
    Result := (a.left = r.left) and (a.top = r.top) and (a.right = r.right) and (a.bottom = r.bottom);
end;

procedure TD2D_RECT_U.InfiniteRectU;
begin
  left:=0;
  top:=0;
  right:=UINT_MAX;
  bottom:=UINT_MAX;
end;

{ TD2D_SIZE_F }

procedure TD2D_SIZE_F.Init(Width: single; Height: single);
begin
    self.Width := Width;
    self.Height := Height;
end;

{ TD2D_SIZE_U }

procedure TD2D_SIZE_U.Init(Width: uint32; Height: uint32);
begin
    self.Width := Width;
    self.Height := Height;
end;



class operator TD2D_SIZE_U.Equal(a: TD2D_SIZE_U; r: TD2D_SIZE_U): boolean;
begin
    Result := (a.Width = r.Width) and (a.Height = r.Height);
end;

{ TD2D_MATRIX_3X2_F }

class operator TD2D_MATRIX_3X2_F.Initialize(var aRec: TD2D_MATRIX_3X2_F);
begin
    aRec._11 := 0.0;
    aRec._12 := 0.0;
    aRec._21 := 0.0;
    aRec._22 := 0.0;
    aRec._31 := 0.0;
    aRec._32 := 0.0;

end;



class operator TD2D_MATRIX_3X2_F.Multiply(a, b: TD2D_MATRIX_3X2_F): TD2D_MATRIX_3X2_F;
begin
    Result._11 := a._11 * b._11 + a._12 * b._21;
    Result._12 := a._11 * b._12 + a._12 * b._22;
    Result._21 := a._21 * b._11 + a._22 * b._21;
    Result._22 := a._21 * b._12 + a._22 * b._22;
    Result._31 := a._31 * b._11 + a._32 * b._21 + b._31;
    Result._32 := a._31 * b._12 + a._32 * b._22 + b._32;
end;



procedure TD2D_MATRIX_3X2_F.Init(m11, m12, m21, m22, m31, m32: single);
begin
    _11 := m11;
    _12 := m12;
    _21 := m21;
    _22 := m22;
    _31 := m31;
    _32 := m32;
end;



procedure TD2D_MATRIX_3X2_F.Identity;
begin
    _11 := 1.0;
    _12 := 0.0;
    _21 := 0.0;
    _22 := 1.0;
    _31 := 0.0;
    _32 := 0.0;
end;




{ TD2D_MATRIX_4X3_F }

class operator TD2D_MATRIX_4X3_F.Initialize(var aRec: TD2D_MATRIX_4X3_F);
begin
    aRec._11 := 1;
    aRec._12 := 0;
    aRec._13 := 0;

    aRec._21 := 0;
    aRec._22 := 1;
    aRec._23 := 0;

    aRec._31 := 0;
    aRec._32 := 0;
    aRec._33 := 1;

    aRec._41 := 0;
    aRec._42 := 0;
    aRec._43 := 0;
end;



procedure TD2D_MATRIX_4X3_F.Init(m11, m12, m13, m21, m22, m23, m31, m32, m33, m41, m42, m43: single);
begin
    self._11 := m11;
    self._12 := m12;
    self._13 := m13;

    self._21 := m21;
    self._22 := m22;
    self._23 := m23;

    self._31 := m31;
    self._32 := m32;
    self._33 := m33;

    self._41 := m41;
    self._42 := m42;
    self._43 := m43;
end;

{ TD2D_MATRIX_4X4_F }

class operator TD2D_MATRIX_4X4_F.Initialize(var aRec: TD2D_MATRIX_4X4_F);
begin
    aRec._11 := 1;
    aRec._12 := 0;
    aRec._13 := 0;
    aRec._14 := 0;

    aRec._21 := 0;
    aRec._22 := 1;
    aRec._23 := 0;
    aRec._24 := 0;

    aRec._31 := 0;
    aRec._32 := 0;
    aRec._33 := 1;
    aRec._34 := 0;

    aRec._41 := 0;
    aRec._42 := 0;
    aRec._43 := 0;
    aRec._44 := 1;
end;



class operator TD2D_MATRIX_4X4_F.Equal(a: TD2D_MATRIX_4X4_F; r: TD2D_MATRIX_4X4_F): boolean;
begin
    Result := (a._11 = r._11) and (a._12 = r._12) and (a._13 = r._13) and (a._14 = r._14) and (a._21 = r._21) and (a._22 = r._22) and (a._23 = r._23) and (a._24 = r._24) and (a._31 = r._31) and
        (a._32 = r._32) and (a._33 = r._33) and (a._34 = r._34) and (a._41 = r._41) and (a._42 = r._42) and (a._43 = r._43) and (a._44 = r._44);
end;



class operator TD2D_MATRIX_4X4_F.NotEqual(a: TD2D_MATRIX_4X4_F; r: TD2D_MATRIX_4X4_F): boolean;
begin
    Result := not (a = r);
end;



class operator TD2D_MATRIX_4X4_F.Multiply(a, b: TD2D_MATRIX_4X4_F): TD2D_MATRIX_4X4_F;
begin
    Result.SetProduct(a, b);
end;



procedure TD2D_MATRIX_4X4_F.Init(m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44: single);
begin
    self._11 := m11;
    self._12 := m12;
    self._13 := m13;
    self._14 := m14;

    self._21 := m21;
    self._22 := m22;
    self._23 := m23;
    self._24 := m24;

    self._31 := m31;
    self._32 := m32;
    self._33 := m33;
    self._34 := m34;

    self._41 := m41;
    self._42 := m42;
    self._43 := m43;
    self._44 := m44;
end;



procedure TD2D_MATRIX_4X4_F.Translation(x, y, z: single);
begin
    self._11 := 1.0;
    self._12 := 0.0;
    self._13 := 0.0;
    self._14 := 0.0;
    self._21 := 0.0;
    self._22 := 1.0;
    self._23 := 0.0;
    self._24 := 0.0;
    self._31 := 0.0;
    self._32 := 0.0;
    self._33 := 1.0;
    self._34 := 0.0;
    self._41 := x;
    self._42 := y;
    self._43 := z;
    self._44 := 1.0;
end;



procedure TD2D_MATRIX_4X4_F.Scale(x, y, z: single);
begin
    self._11 := x;
    self._12 := 0.0;
    self._13 := 0.0;
    self._14 := 0.0;
    self._21 := 0.0;
    self._22 := y;
    self._23 := 0.0;
    self._24 := 0.0;
    self._31 := 0.0;
    self._32 := 0.0;
    self._33 := z;
    self._34 := 0.0;
    self._41 := 0.0;
    self._42 := 0.0;
    self._43 := 0.0;
    self._44 := 1.0;
end;



procedure TD2D_MATRIX_4X4_F.RotationX(degreeX: single);
var
    angleInRadian: single;
    sinAngle: single;
    cosAngle: single;
begin
    angleInRadian := degreeX * (3.141592654 / 180.0);
    sinAngle := 0.0;
    cosAngle := 0.0;
    D2D1SinCos(angleInRadian, @sinAngle, @cosAngle);
    Self.Init(1, 0, 0, 0,
        0, cosAngle, sinAngle, 0,
        0, -sinAngle, cosAngle, 0,
        0, 0, 0, 1);
end;



procedure TD2D_MATRIX_4X4_F.RotationY(degreeY: single);
var
    angleInRadian: single;
    sinAngle: single;
    cosAngle: single;
begin
    angleInRadian := degreeY * (3.141592654 / 180.0);
    sinAngle := 0.0;
    cosAngle := 0.0;
    D2D1SinCos(angleInRadian, @sinAngle, @cosAngle);
    Self.init(cosAngle, 0, -sinAngle, 0,
        0, 1, 0, 0,
        sinAngle, 0, cosAngle, 0,
        0, 0, 0, 1);
end;



procedure TD2D_MATRIX_4X4_F.RotationZ(degreeZ: single);
var
    angleInRadian: single;
    sinAngle: single;
    cosAngle: single;
begin
    angleInRadian := degreeZ * (3.141592654 / 180.0);
    sinAngle := 0.0;
    cosAngle := 0.0;
    D2D1SinCos(angleInRadian, @sinAngle, @cosAngle);
    Self.Init(cosAngle, sinAngle, 0, 0, -sinAngle, cosAngle, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
        );
end;



procedure TD2D_MATRIX_4X4_F.RotationArbitraryAxis(x, y, z, degree: single);
var
    magnitude: single;
    angleInRadian: single;
    sinAngle: single;
    cosAngle: single;
    oneMinusCosAngle: single;
begin
    // Normalize the vector represented by x, y, and z
    magnitude := D2D1Vec3Length(x, y, z);
    x := x / magnitude;
    y := y / magnitude;
    z := z / magnitude;

    angleInRadian := degree * (3.141592654 / 180.0);

    sinAngle := 0.0;
    cosAngle := 0.0;
    D2D1SinCos(angleInRadian, @sinAngle, @cosAngle);

    oneMinusCosAngle := 1 - cosAngle;

    Self.Init(1 + oneMinusCosAngle * (x * x - 1),
        z * sinAngle + oneMinusCosAngle * x * y, -y * sinAngle + oneMinusCosAngle * x * z,
        0, -z * sinAngle + oneMinusCosAngle * y * x,
        1 + oneMinusCosAngle * (y * y - 1),
        x * sinAngle + oneMinusCosAngle * y * z,
        0,

        y * sinAngle + oneMinusCosAngle * z * x, -x * sinAngle + oneMinusCosAngle * z * y,
        1 + oneMinusCosAngle * (z * z - 1),
        0,

        0, 0, 0, 1
        );
end;



procedure TD2D_MATRIX_4X4_F.SkewX(degreeX: single);
var
    angleInRadian: single;
    tanAngle: single;
begin
    angleInRadian := degreeX * (3.141592654 / 180.0);

    tanAngle := D2D1Tan(angleInRadian);
    Self.Init(
        1, 0, 0, 0,
        tanAngle, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
        );
end;



procedure TD2D_MATRIX_4X4_F.SkewY(degreeY: single);
var
    angleInRadian: single;
    tanAngle: single;
begin
    angleInRadian := degreeY * (3.141592654 / 180.0);

    tanAngle := D2D1Tan(angleInRadian);
    Self.Init(1, tanAngle, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
        );
end;



procedure TD2D_MATRIX_4X4_F.PerspectiveProjection(depth: single);
var
    proj: single = 0;
begin
    if (depth > 0) then
        proj := -1 / depth;
    Self.Init(1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, proj,
        0, 0, 0, 1
        );
end;



function TD2D_MATRIX_4X4_F.Determinant: single;
var
    minor1, minor2, minor3, minor4: single;
begin
    minor1 := _41 * (_12 * (_23 * _34 - _33 * _24) - _13 * (_22 * _34 - _24 * _32) + _14 * (_22 * _33 - _23 * _32));
    minor2 := _42 * (_11 * (_21 * _34 - _31 * _24) - _13 * (_21 * _34 - _24 * _31) + _14 * (_21 * _33 - _23 * _31));
    minor3 := _43 * (_11 * (_22 * _34 - _32 * _24) - _12 * (_21 * _34 - _24 * _31) + _14 * (_21 * _32 - _22 * _31));
    minor4 := _44 * (_11 * (_22 * _33 - _32 * _23) - _12 * (_21 * _33 - _23 * _31) + _13 * (_21 * _32 - _22 * _31));

    Result := minor1 - minor2 + minor3 - minor4;
end;



function TD2D_MATRIX_4X4_F.IsIdentity: boolean;
begin
    Result := (_11 = 1.0) and (_12 = 0.0) and (_13 = 0.0) and (_14 = 0.0) and (_21 = 0.0) and (_22 = 1.0) and (_23 = 0.0) and (_24 = 0.0) and (_31 = 0.0) and (_32 = 0.0) and (_33 = 1.0) and
        (_34 = 0.0) and (_41 = 0.0) and (_42 = 0.0) and (_43 = 0.0) and (_44 = 1.0);
end;



procedure TD2D_MATRIX_4X4_F.SetProduct(a, b: TD2D_MATRIX_4X4_F);
begin
    _11 := a._11 * b._11 + a._12 * b._21 + a._13 * b._31 + a._14 * b._41;
    _12 := a._11 * b._12 + a._12 * b._22 + a._13 * b._32 + a._14 * b._42;
    _13 := a._11 * b._13 + a._12 * b._23 + a._13 * b._33 + a._14 * b._43;
    _14 := a._11 * b._14 + a._12 * b._24 + a._13 * b._34 + a._14 * b._44;

    _21 := a._21 * b._11 + a._22 * b._21 + a._23 * b._31 + a._24 * b._41;
    _22 := a._21 * b._12 + a._22 * b._22 + a._23 * b._32 + a._24 * b._42;
    _23 := a._21 * b._13 + a._22 * b._23 + a._23 * b._33 + a._24 * b._43;
    _24 := a._21 * b._14 + a._22 * b._24 + a._23 * b._34 + a._24 * b._44;

    _31 := a._31 * b._11 + a._32 * b._21 + a._33 * b._31 + a._34 * b._41;
    _32 := a._31 * b._12 + a._32 * b._22 + a._33 * b._32 + a._34 * b._42;
    _33 := a._31 * b._13 + a._32 * b._23 + a._33 * b._33 + a._34 * b._43;
    _34 := a._31 * b._14 + a._32 * b._24 + a._33 * b._34 + a._34 * b._44;

    _41 := a._41 * b._11 + a._42 * b._21 + a._43 * b._31 + a._44 * b._41;
    _42 := a._41 * b._12 + a._42 * b._22 + a._43 * b._32 + a._44 * b._42;
    _43 := a._41 * b._13 + a._42 * b._23 + a._43 * b._33 + a._44 * b._43;
    _44 := a._41 * b._14 + a._42 * b._24 + a._43 * b._34 + a._44 * b._44;
end;

{ TD2D_MATRIX_5X4_F }

class operator TD2D_MATRIX_5X4_F.Initialize(var aRec: TD2D_MATRIX_5X4_F);
begin
    aRec._11 := 1;
    aRec._12 := 0;
    aRec._13 := 0;
    aRec._14 := 0;

    aRec._21 := 0;
    aRec._22 := 1;
    aRec._23 := 0;
    aRec._24 := 0;

    aRec._31 := 0;
    aRec._32 := 0;
    aRec._33 := 1;
    aRec._34 := 0;

    aRec._41 := 0;
    aRec._42 := 0;
    aRec._43 := 0;
    aRec._44 := 1;

    aRec._51 := 0;
    aRec._52 := 0;
    aRec._53 := 0;
    aRec._54 := 0;
end;



procedure TD2D_MATRIX_5X4_F.Init(m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44, m51, m52, m53, m54: single);
begin
    _11 := m11;
    _12 := m12;
    _13 := m13;
    _14 := m14;

    _21 := m21;
    _22 := m22;
    _23 := m23;
    _24 := m24;

    _31 := m31;
    _32 := m32;
    _33 := m33;
    _34 := m34;

    _41 := m41;
    _42 := m42;
    _43 := m43;
    _44 := m44;

    _51 := m51;
    _52 := m52;
    _53 := m53;
    _54 := m54;
end;

{ TD2D1_POINT_2LHelper }

procedure TD2D1_POINT_2LHelper.Init(x: int32; y: int32);
begin
  self.x:=x;
  self.y:=y;
end;

{ TD2D1_RECT_LHelper }

procedure TD2D1_RECT_LHelper.Init(left: int32; top: int32; right: int32;
  bottom: int32);
begin
    self.Left:=left;
    Self.Top:=top;
    self.Right:=right;
    self.Bottom:=bottom;
end;

end.
