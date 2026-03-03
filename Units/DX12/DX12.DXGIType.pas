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
   
   Copyright (C) Microsoft.  All rights reserved.
   
   This unit consists of the following header files
   File name: dxgitype_h
   Header version: 10.0.26100.6584
   
  ************************************************************************** }
unit DX12.DXGIType;

{$IFDEF FPC}
{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$ENDIF}



interface

uses
    Windows, Classes, SysUtils,
    DX12.DXGICommon,
    DX12.DXGIFormat;

{$Z4}
{$A4}

const
    // DXGI error messages have moved to winerror.h
    _FACDXGI = $87a;

    cMAKE_DXGI_HRESULT = longint(_FACDXGI shl 16) or longint(1 shl 31);
    cMAKE_DXGI_STATUS = longint(_FACDXGI shl 16);

    DXGI_STATUS_OCCLUDED = cMAKE_DXGI_STATUS or 1;
    DXGI_STATUS_CLIPPED = cMAKE_DXGI_STATUS or 2;
    DXGI_STATUS_NO_REDIRECTION = cMAKE_DXGI_STATUS or 4;
    DXGI_STATUS_NO_DESKTOP_ACCESS = cMAKE_DXGI_STATUS or 5;
    DXGI_STATUS_GRAPHICS_VIDPN_SOURCE_IN_USE = cMAKE_DXGI_STATUS or 6;
    DXGI_STATUS_MODE_CHANGED = cMAKE_DXGI_STATUS or 7;
    DXGI_STATUS_MODE_CHANGE_IN_PROGRESS = cMAKE_DXGI_STATUS or 8;


    DXGI_ERROR_INVALID_CALL = cMAKE_DXGI_HRESULT or 1;
    DXGI_ERROR_NOT_FOUND = cMAKE_DXGI_HRESULT or 2;
    DXGI_ERROR_MORE_DATA = cMAKE_DXGI_HRESULT or 3;
    DXGI_ERROR_UNSUPPORTED = cMAKE_DXGI_HRESULT or 4;
    DXGI_ERROR_DEVICE_REMOVED = cMAKE_DXGI_HRESULT or 5;
    DXGI_ERROR_DEVICE_HUNG = cMAKE_DXGI_HRESULT or 6;
    DXGI_ERROR_DEVICE_RESET = cMAKE_DXGI_HRESULT or 7;
    DXGI_ERROR_WAS_STILL_DRAWING = cMAKE_DXGI_HRESULT or 10;
    DXGI_ERROR_FRAME_STATISTICS_DISJOINT = cMAKE_DXGI_HRESULT or 11;
    DXGI_ERROR_GRAPHICS_VIDPN_SOURCE_IN_USE = cMAKE_DXGI_HRESULT or 12;
    DXGI_ERROR_DRIVER_INTERNAL_ERROR = cMAKE_DXGI_HRESULT or 32;
    DXGI_ERROR_NONEXCLUSIVE = cMAKE_DXGI_HRESULT or 33;
    DXGI_ERROR_NOT_CURRENTLY_AVAILABLE = cMAKE_DXGI_HRESULT or 34;
    DXGI_ERROR_REMOTE_CLIENT_DISCONNECTED = cMAKE_DXGI_HRESULT or 35;
    DXGI_ERROR_REMOTE_OUTOFMEMORY = cMAKE_DXGI_HRESULT or 36;



    DXGI_CPU_ACCESS_NONE = (0);
    DXGI_CPU_ACCESS_DYNAMIC = (1);
    DXGI_CPU_ACCESS_READ_WRITE = (2);
    DXGI_CPU_ACCESS_SCRATCH = (3);
    DXGI_CPU_ACCESS_FIELD = 15;

const
    sc_redShift = 16;
    sc_greenShift = 8;
    sc_blueShift = 0;

    sc_redMask: uint32 = $ff shl sc_redShift;
    sc_greenMask: uint32 = $ff shl sc_greenShift;
    sc_blueMask: uint32 = $ff shl sc_blueShift;

type

    TDXGI_RGB = record
        Red: single;
        Green: single;
        Blue: single;
    end;

    { T_D3DCOLORVALUE }

    T_D3DCOLORVALUE = record
        procedure Init(rgb: uint32; alpha: single); overload;
        procedure Init(lr, lg, lb, la: single); overload;
        case integer of
            0: (
                r: single;
                g: single;
                b: single;
                a: single);
            1: (dvR: single;
                dvG: single;
                dvB: single;
                dvA: single);
    end;

    TD3DCOLORVALUE = T_D3DCOLORVALUE;
    PD3DCOLORVALUE = ^TD3DCOLORVALUE;

    TDXGI_RGBA = TD3DCOLORVALUE;
    PDXGI_RGBA = ^TDXGI_RGBA;

    TDXGI_GAMMA_CONTROL = record
        Scale: TDXGI_RGB;
        Offset: TDXGI_RGB;
        GammaCurve: array [0..1025 - 1] of TDXGI_RGB;
    end;
    PDXGI_GAMMA_CONTROL = ^TDXGI_GAMMA_CONTROL;

    TDXGI_GAMMA_CONTROL_CAPABILITIES = record
        ScaleAndOffsetSupported: boolean;
        MaxConvertedValue: single;
        MinConvertedValue: single;
        NumGammaControlPoints: UINT;
        ControlPointPositions: array [0..1025 - 1] of single;
    end;
    PDXGI_GAMMA_CONTROL_CAPABILITIES = ^TDXGI_GAMMA_CONTROL_CAPABILITIES;

    TDXGI_MODE_SCANLINE_ORDER = (
        DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED = 0,
        DXGI_MODE_SCANLINE_ORDER_PROGRESSIVE = 1,
        DXGI_MODE_SCANLINE_ORDER_UPPER_FIELD_FIRST = 2,
        DXGI_MODE_SCANLINE_ORDER_LOWER_FIELD_FIRST = 3
        );

    TDXGI_MODE_SCALING = (
        DXGI_MODE_SCALING_UNSPECIFIED = 0,
        DXGI_MODE_SCALING_CENTERED = 1,
        DXGI_MODE_SCALING_STRETCHED = 2
        );

    TDXGI_MODE_ROTATION = (
        DXGI_MODE_ROTATION_UNSPECIFIED = 0,
        DXGI_MODE_ROTATION_IDENTITY = 1,
        DXGI_MODE_ROTATION_ROTATE90 = 2,
        DXGI_MODE_ROTATION_ROTATE180 = 3,
        DXGI_MODE_ROTATION_ROTATE270 = 4
        );
    PDXGI_MODE_ROTATION = ^TDXGI_MODE_ROTATION;

    { TDXGI_MODE_DESC }

    TDXGI_MODE_DESC = record
        Width: UINT;
        Height: UINT;
        RefreshRate: TDXGI_RATIONAL;
        Format: TDXGI_FORMAT;
        ScanlineOrdering: TDXGI_MODE_SCANLINE_ORDER;
        Scaling: TDXGI_MODE_SCALING;
        {$IFDEF FPC}
        class operator Initialize(var A: TDXGI_MODE_DESC);
        {$ENDIF}
        procedure Init;
    end;
    PDXGI_MODE_DESC = ^TDXGI_MODE_DESC;

    TDXGI_JPEG_DC_HUFFMAN_TABLE = record
        CodeCounts: array [0..12 - 1] of byte;
        CodeValues: array [0..12 - 1] of byte;
    end;
    PDXGI_JPEG_DC_HUFFMAN_TABLE = ^TDXGI_JPEG_DC_HUFFMAN_TABLE;

    TDXGI_JPEG_AC_HUFFMAN_TABLE = record
        CodeCounts: array [0..16 - 1] of byte;
        CodeValues: array [0..162 - 1] of byte;
    end;
    PDXGI_JPEG_AC_HUFFMAN_TABLE = ^TDXGI_JPEG_AC_HUFFMAN_TABLE;

    TDXGI_JPEG_QUANTIZATION_TABLE = record
        Elements: array [0..64 - 1] of byte;
    end;
    PDXGI_JPEG_QUANTIZATION_TABLE = ^TDXGI_JPEG_QUANTIZATION_TABLE;


function MAKE_DXGI_HRESULT(code: longword): HRESULT;
function MAKE_DXGI_STATUS(code: longword): HRESULT;


implementation

uses
    Windows.Macros;



function MAKE_DXGI_HRESULT(code: longword): HRESULT; inline;
begin
    Result := MAKE_HRESULT(1, _FACDXGI, code);
end;



function MAKE_DXGI_STATUS(code: longword): HRESULT; inline;
begin
    Result := MAKE_HRESULT(0, _FACDXGI, code);
end;

{ T_D3DCOLORVALUE }

procedure T_D3DCOLORVALUE.Init(rgb: uint32; alpha: single);
begin
    r := ((rgb and sc_redMask) shr sc_redShift) / 255.0;
    g := ((rgb and sc_greenMask) shr sc_greenShift) / 255.0;
    b := ((rgb and sc_blueMask) shr sc_blueShift) / 255.0;
    a := alpha;
end;



procedure T_D3DCOLORVALUE.Init(lr, lg, lb, la: single);
begin
    r := lr;
    g := lg;
    b := lb;
    a := la;
end;

{ TDXGI_MODE_DESC }

class operator TDXGI_MODE_DESC.Initialize(var A: TDXGI_MODE_DESC);
begin
    A.Init;
end;



procedure TDXGI_MODE_DESC.Init;
begin
    Width := 0;
    Height := 0;
    RefreshRate.Denominator := 0;
    RefreshRate.Numerator := 0;
    Format := DXGI_FORMAT_UNKNOWN;
    ScanlineOrdering := DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED;
    Scaling := DXGI_MODE_SCALING_UNSPECIFIED;
end;

end.
