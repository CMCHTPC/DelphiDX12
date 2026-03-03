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

   Copyright (c) Microsoft Corporation. All rights reserved.
   Master include file for versioning windows SDK/DDK.

   This unit consists of the following header files
   File name: sdkddkver.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.SDKDDKVer;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils;

    {$Z4}

const

    // _WIN32_WINNT version constants

    _WIN32_WINNT_NT4 = $0400;
    _WIN32_WINNT_WIN2K = $0500;
    _WIN32_WINNT_WINXP = $0501;
    _WIN32_WINNT_WS03 = $0502;
    _WIN32_WINNT_WIN6 = $0600;
    _WIN32_WINNT_VISTA = $0600;
    _WIN32_WINNT_WS08 = $0600;
    _WIN32_WINNT_LONGHORN = $0600;
    _WIN32_WINNT_WIN7 = $0601;
    _WIN32_WINNT_WIN8 = $0602;
    _WIN32_WINNT_WINBLUE = $0603;
    _WIN32_WINNT_WINTHRESHOLD = $0A00;
    _WIN32_WINNT_WIN10 = $0A00;


    // _WIN32_IE_ version constants

    _WIN32_IE_IE20 = $0200;
    _WIN32_IE_IE30 = $0300;
    _WIN32_IE_IE302 = $0302;
    _WIN32_IE_IE40 = $0400;
    _WIN32_IE_IE401 = $0401;
    _WIN32_IE_IE50 = $0500;
    _WIN32_IE_IE501 = $0501;
    _WIN32_IE_IE55 = $0550;
    _WIN32_IE_IE60 = $0600;
    _WIN32_IE_IE60SP1 = $0601;
    _WIN32_IE_IE60SP2 = $0603;
    _WIN32_IE_IE70 = $0700;
    _WIN32_IE_IE80 = $0800;
    _WIN32_IE_IE90 = $0900;
    _WIN32_IE_IE100 = $0A00;
    _WIN32_IE_IE110 = $0A00;


    // IE <-> OS version mapping

    // NT4 supports IE versions 2.0 -> 6.0 SP1
    _WIN32_IE_NT4 = _WIN32_IE_IE20;
    _WIN32_IE_NT4SP1 = _WIN32_IE_IE20;
    _WIN32_IE_NT4SP2 = _WIN32_IE_IE20;
    _WIN32_IE_NT4SP3 = _WIN32_IE_IE302;
    _WIN32_IE_NT4SP4 = _WIN32_IE_IE401;
    _WIN32_IE_NT4SP5 = _WIN32_IE_IE401;
    _WIN32_IE_NT4SP6 = _WIN32_IE_IE50;
    // Win98 supports IE versions 4.01 -> 6.0 SP1
    _WIN32_IE_WIN98 = _WIN32_IE_IE401;
    // Win98SE supports IE versions 5.0 -> 6.0 SP1
    _WIN32_IE_WIN98SE = _WIN32_IE_IE50;
    // WinME supports IE versions 5.5 -> 6.0 SP1
    _WIN32_IE_WINME = _WIN32_IE_IE55;
    // Win2k supports IE versions 5.01 -> 6.0 SP1
    _WIN32_IE_WIN2K = _WIN32_IE_IE501;
    _WIN32_IE_WIN2KSP1 = _WIN32_IE_IE501;
    _WIN32_IE_WIN2KSP2 = _WIN32_IE_IE501;
    _WIN32_IE_WIN2KSP3 = _WIN32_IE_IE501;
    _WIN32_IE_WIN2KSP4 = _WIN32_IE_IE501;
    _WIN32_IE_XP = _WIN32_IE_IE60;
    _WIN32_IE_XPSP1 = _WIN32_IE_IE60SP1;
    _WIN32_IE_XPSP2 = _WIN32_IE_IE60SP2;
    _WIN32_IE_WS03 = $0602;
    _WIN32_IE_WS03SP1 = _WIN32_IE_IE60SP2;
    _WIN32_IE_WIN6 = _WIN32_IE_IE70;
    _WIN32_IE_LONGHORN = _WIN32_IE_IE70;
    _WIN32_IE_WIN7 = _WIN32_IE_IE80;
    _WIN32_IE_WIN8 = _WIN32_IE_IE100;
    _WIN32_IE_WINBLUE = _WIN32_IE_IE100;
    _WIN32_IE_WINTHRESHOLD = _WIN32_IE_IE110;
    _WIN32_IE_WIN10 = _WIN32_IE_IE110;



    // NTDDI version constants

    NTDDI_WIN4 = $04000000;

    NTDDI_WIN2K = $05000000;
    NTDDI_WIN2KSP1 = $05000100;
    NTDDI_WIN2KSP2 = $05000200;
    NTDDI_WIN2KSP3 = $05000300;
    NTDDI_WIN2KSP4 = $05000400;

    NTDDI_WINXP = $05010000;
    NTDDI_WINXPSP1 = $05010100;
    NTDDI_WINXPSP2 = $05010200;
    NTDDI_WINXPSP3 = $05010300;
    NTDDI_WINXPSP4 = $05010400;

    NTDDI_WS03 = $05020000;
    NTDDI_WS03SP1 = $05020100;
    NTDDI_WS03SP2 = $05020200;
    NTDDI_WS03SP3 = $05020300;
    NTDDI_WS03SP4 = $05020400;

    NTDDI_WIN6 = $06000000;
    NTDDI_WIN6SP1 = $06000100;
    NTDDI_WIN6SP2 = $06000200;
    NTDDI_WIN6SP3 = $06000300;
    NTDDI_WIN6SP4 = $06000400;

    NTDDI_VISTA = NTDDI_WIN6;
    NTDDI_VISTASP1 = NTDDI_WIN6SP1;
    NTDDI_VISTASP2 = NTDDI_WIN6SP2;
    NTDDI_VISTASP3 = NTDDI_WIN6SP3;
    NTDDI_VISTASP4 = NTDDI_WIN6SP4;

    NTDDI_LONGHORN = NTDDI_VISTA;

    NTDDI_WS08 = NTDDI_WIN6SP1;
    NTDDI_WS08SP2 = NTDDI_WIN6SP2;
    NTDDI_WS08SP3 = NTDDI_WIN6SP3;
    NTDDI_WS08SP4 = NTDDI_WIN6SP4;

    NTDDI_WIN7 = $06010000;
    NTDDI_WIN8 = $06020000;
    NTDDI_WINBLUE = $06030000;
    NTDDI_WINTHRESHOLD = $0A000000;
    NTDDI_WIN10 = $0A000000;
    NTDDI_WIN10_TH2 = $0A000001;
    NTDDI_WIN10_RS1 = $0A000002;
    NTDDI_WIN10_RS2 = $0A000003;
    NTDDI_WIN10_RS3 = $0A000004;
    NTDDI_WIN10_RS4 = $0A000005;
    NTDDI_WIN10_RS5 = $0A000006;
    NTDDI_WIN10_19H1 = $0A000007;
    NTDDI_WIN10_VB = $0A000008;
    NTDDI_WIN10_MN = $0A000009;
    NTDDI_WIN10_FE = $0A00000A;
    NTDDI_WIN10_CO = $0A00000B;
    NTDDI_WIN10_NI = $0A00000C;
    NTDDI_WIN10_CU = $0A00000D;
    NTDDI_WIN11_ZN = $0A00000E;
    NTDDI_WIN11_GA = $0A00000F;
    NTDDI_WIN11_GE = $0A000010;

    WDK_NTDDI_VERSION = NTDDI_WIN11_GE;



    // masks for version macros

    OSVERSION_MASK = $FFFF0000;
    SPVERSION_MASK = $0000FF00;
    SUBVERSION_MASK = $000000FF;



    // macros to extract various version fields from the NTDDI version

function OSVER(Version: uint32): uint32;
function SPVER(Version: uint32): uint32;
function SUBVER(Version: uint32): uint32;


implementation



function OSVER(Version: uint32): uint32;
begin
    Result := (Version and OSVERSION_MASK);
end;



function SPVER(Version: uint32): uint32;
begin
    Result := ((Version and SPVERSION_MASK) shr 8);
end;



function SUBVER(Version: uint32): uint32;
begin
    Result := (Version and SUBVERSION_MASK);
end;

end.
