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
   
   This unit consists of the following header files
   File name: D2DErr.h
   Header version: 10.0.26100.6584
   
  ************************************************************************** }
unit DX12.D2DErr;

{$IFDEF FPC}
{$mode ObjFPC}{$H+}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils;

    {$Z4}

const

    FACILITY_D2D = $899;


    //+----------------------------------------------------------------------------

    // D2D error codes

    //------------------------------------------------------------------------------


    //  Error codes shared with WINCODECS


    // The pixel format is not supported.

    D2DERR_UNSUPPORTED_PIXEL_FORMAT = $88982F80; // WINCODEC_ERR_UNSUPPORTEDPIXELFORMAT;



    // Error codes that were already returned in prior versions and were part of the
    // MIL facility.

    // Error codes mapped from WIN32 where there isn't already another HRESULT based
    // define


    // The supplied buffer was too small to accommodate the data.

    ERROR_INSUFFICIENT_BUFFER = 122;
    D2DERR_INSUFFICIENT_BUFFER = (ERROR_INSUFFICIENT_BUFFER and $0000FFFF) or (FACILITY_WIN32 shl 16) or $80000000;


    // The file specified was not found.

    ERROR_FILE_NOT_FOUND = 2;
    D2DERR_FILE_NOT_FOUND = (ERROR_FILE_NOT_FOUND and $0000FFFF) or (FACILITY_WIN32 shl 16) or $80000000;



    // D2D specific codes now live in winerror.h



   (*=========================================================================
    D2D Status Codes
    =========================================================================*)
function MAKE_D2DHR(sev, code: longword): HRESULT;
function MAKE_D2DHR_ERR(code: longword): HRESULT;


implementation

uses
    Windows.Macros;



function MAKE_D2DHR(sev, code: longword): HRESULT;
begin
    Result := MAKE_HRESULT(sev, FACILITY_D2D, code);
end;



function MAKE_D2DHR_ERR(code: longword): HRESULT;
begin
    Result := MAKE_D2DHR(1, code);
end;

end.
