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
   Content:    DirectX Diagnostic Tool include file

   This unit consists of the following header files
   File name: dxdiag.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.DXDiag;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils;

    {$Z4}

const
    // This identifier is passed to IDxDiagProvider::Initialize in order to ensure that an
    // application was built against the correct header files. This number is
    // incremented whenever a header (or other) change would require applications
    // to be rebuilt. If the version doesn't match, IDxDiagProvider::Initialize will fail.
    // (The number itself has no meaning.)
    DXDIAG_DX9_SDK_VERSION = 111;


(****************************************************************************
 *
 * DxDiag Errors
 *
 ****************************************************************************)
    DXDIAG_E_INSUFFICIENT_BUFFER = HRESULT($8007007A); // HRESULT_FROM_WIN32(ERROR_INSUFFICIENT_BUFFER)


(****************************************************************************
 *
 * DxDiag CLSIDs
 *
 ****************************************************************************)
    // {A65B8071-3BFE-4213-9A5B-491DA4461CA7}

    CLSID_DxDiagProvider: TGUID = '{A65B8071-3BFE-4213-9A5B-491DA4461CA7}';



(****************************************************************************
 *
 * DxDiag Interface IIDs
 *
 ****************************************************************************)
    // {9C6B4CB0-23F8-49CC-A3ED-45A55000A6D2}

    IID_IDxDiagProvider: TGUID = '{9C6B4CB0-23F8-49CC-A3ED-45A55000A6D2}';


    // {0x7D0F462F-0x4064-0x4862-BC7F-933E5058C10F}
    IID_IDxDiagContainer: TGUID = '{7D0F462F-4064-4862-BC7F-933E5058C10F}';

type
  (****************************************************************************
 *
 * DxDiag Structures
 *
 ****************************************************************************)

    T_DXDIAG_INIT_PARAMS = record
        dwSize: DWORD;
        dwDxDiagHeaderVersion: DWORD; // the header and dll are correctly matched.
        bAllowWHQLChecks: boolean; // connect via internet to update WHQL certificates.
        pReserved: pointer;
    end;
    P_DXDIAG_INIT_PARAMS = ^T_DXDIAG_INIT_PARAMS;

    TDXDIAG_INIT_PARAMS = T_DXDIAG_INIT_PARAMS;
    PDXDIAG_INIT_PARAMS = ^TDXDIAG_INIT_PARAMS;


(****************************************************************************
 *
 * DxDiag Application Interfaces
 *
 ****************************************************************************)

    // COM definition for IDxDiagProvider

    IDxDiagContainer = interface;

    IDxDiagProvider = interface(IUnknown)
        ['{9C6B4CB0-23F8-49CC-A3ED-45A55000A6D2}']
        (*** IDxDiagProvider methods ***)
        function Initialize(pParams: PDXDIAG_INIT_PARAMS): HRESULT; stdcall;
        function GetRootContainer(out ppInstance: IDxDiagContainer): HRESULT; stdcall;
    end;




    // COM definition for IDxDiagContainer


    IDxDiagContainer = interface(IUnknown)
        ['{7D0F462F-4064-4862-BC7F-933E5058C10F}']
        (*** IDxDiagContainer methods ***)
        function GetNumberOfChildContainers(pdwCount: PDWORD): HRESULT; stdcall;
        function EnumChildContainerNames(dwIndex: DWORD; pwszContainer: LPWSTR; cchContainer: DWORD): HRESULT; stdcall;
        function GetChildContainer(pwszContainer: LPCWSTR; out ppInstance: IDxDiagContainer): HRESULT; stdcall;
        function GetNumberOfProps(pdwCount: PDWORD): HRESULT; stdcall;
        function EnumPropNames(dwIndex: DWORD; pwszPropName: LPWSTR; cchPropName: DWORD): HRESULT; stdcall;
        function GetProp(pwszPropName: LPCWSTR; pvarProp: PVARIANT): HRESULT; stdcall;
    end;


(****************************************************************************
 *
 * DxDiag Interface Pointer definitions
 *
 ****************************************************************************)

    LPDXDIAGPROVIDER = ^IDxDiagProvider;
    PDXDIAGPROVIDER = ^IDxDiagProvider;

    LPDXDIAGCONTAINER = ^IDxDiagContainer;
    PDXDIAGCONTAINER = ^IDxDiagContainer;


implementation

end.
