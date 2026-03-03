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
   
   Copyright (C) Microsoft Corporation.
   Licensed under the MIT license
   
   This unit consists of the following header files
   File name: dxgicommon.h 
   Header version: 10.0.26100.6584
   
  ************************************************************************** }
unit DX12.DXGICommon;

{$IFDEF FPC}
{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils;

    {$Z4}
    {$A4}
const
    // The following values are used with DXGI_SAMPLE_DESC::Quality:
    DXGI_STANDARD_MULTISAMPLE_QUALITY_PATTERN = $ffffffff;
    DXGI_CENTER_MULTISAMPLE_QUALITY_PATTERN = $fffffffe;


type

    TDXGI_RATIONAL = record
        Numerator: UINT;
        Denominator: UINT;
    end;
    PDXGI_RATIONAL = ^TDXGI_RATIONAL;


    { TDXGI_SAMPLE_DESC }

    TDXGI_SAMPLE_DESC = record
        Count: UINT;
        Quality: UINT;
        {$IFDEF FPC}
        class operator Initialize(var A: TDXGI_SAMPLE_DESC);
        {$ENDIF}
        procedure Init; overload;
        procedure Init(ACount: UINT; AQuality: UINT); overload;

    end;
    PDXGI_SAMPLE_DESC = ^TDXGI_SAMPLE_DESC;

    TDXGI_COLOR_SPACE_TYPE = (
        DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709 = 0,
        DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709 = 1,
        DXGI_COLOR_SPACE_RGB_STUDIO_G22_NONE_P709 = 2,
        DXGI_COLOR_SPACE_RGB_STUDIO_G22_NONE_P2020 = 3,
        DXGI_COLOR_SPACE_RESERVED = 4,
        DXGI_COLOR_SPACE_YCBCR_FULL_G22_NONE_P709_X601 = 5,
        DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P601 = 6,
        DXGI_COLOR_SPACE_YCBCR_FULL_G22_LEFT_P601 = 7,
        DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P709 = 8,
        DXGI_COLOR_SPACE_YCBCR_FULL_G22_LEFT_P709 = 9,
        DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P2020 = 10,
        DXGI_COLOR_SPACE_YCBCR_FULL_G22_LEFT_P2020 = 11,
        DXGI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020 = 12,
        DXGI_COLOR_SPACE_YCBCR_STUDIO_G2084_LEFT_P2020 = 13,
        DXGI_COLOR_SPACE_RGB_STUDIO_G2084_NONE_P2020 = 14,
        DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_TOPLEFT_P2020 = 15,
        DXGI_COLOR_SPACE_YCBCR_STUDIO_G2084_TOPLEFT_P2020 = 16,
        DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P2020 = 17,
        DXGI_COLOR_SPACE_YCBCR_STUDIO_GHLG_TOPLEFT_P2020 = 18,
        DXGI_COLOR_SPACE_YCBCR_FULL_GHLG_TOPLEFT_P2020 = 19,
        DXGI_COLOR_SPACE_RGB_STUDIO_G24_NONE_P709 = 20,
        DXGI_COLOR_SPACE_RGB_STUDIO_G24_NONE_P2020 = 21,
        DXGI_COLOR_SPACE_YCBCR_STUDIO_G24_LEFT_P709 = 22,
        DXGI_COLOR_SPACE_YCBCR_STUDIO_G24_LEFT_P2020 = 23,
        DXGI_COLOR_SPACE_YCBCR_STUDIO_G24_TOPLEFT_P2020 = 24,
        DXGI_COLOR_SPACE_CUSTOM = longint($FFFFFFFF)
        );

    PDXGI_COLOR_SPACE_TYPE = ^TDXGI_COLOR_SPACE_TYPE;

implementation

{ TDXGI_SAMPLE_DESC }

class operator TDXGI_SAMPLE_DESC.Initialize(var A: TDXGI_SAMPLE_DESC);
begin
    A.Init;
end;



procedure TDXGI_SAMPLE_DESC.Init;
begin
    // Default values MSDN
    Count := 1;
    Quality := 0;
end;



procedure TDXGI_SAMPLE_DESC.Init(ACount: UINT; AQuality: UINT);
begin
    self.Count := ACount;
    self.Quality := AQuality;
end;

end.
