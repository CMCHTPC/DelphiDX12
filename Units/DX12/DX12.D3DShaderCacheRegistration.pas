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

   Copyright (c) Microsoft Corporation
   Licensed under the MIT license

   This unit consists of the following header files
   File name: d3d12compiler.h
   Header version: SDK 1.717.1-preview  2025 12 28

  ************************************************************************** }
unit DX12.D3DShaderCacheRegistration;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils;

    {$Z4}

const

    IID_ID3DShaderCacheInstallerClient: TGUID = '{A16EE930-D9F6-4222-A514-244473E5D266}';
    IID_ID3DShaderCacheComponent: TGUID = '{EED1BF00-F5C7-4CF7-885C-D0F9C0CB4828}';
    IID_ID3DShaderCacheApplication: TGUID = '{FC688EE2-1B35-4913-93BE-1CA3FA7DF39E}';
    IID_ID3DShaderCacheInstaller: TGUID = '{BBE30DE1-6318-4526-AE17-776693191BB4}';
    IID_ID3DShaderCacheExplorer: TGUID = '{90432322-32F5-487F-9264-E9390FA58B2A}';
    IID_ID3DShaderCacheInstallerFactory: TGUID = '{09B2DFE4-840F-401A-804C-0DD8AADC9E9F}';

    CLSID_D3DShaderCacheInstallerFactory: TGUID = '{16195A0B-607C-41F1-BF03-C7694D60A8D4}';


type

    REFIID = ^TGUID;

    (* Forward Declarations *)

    {$interfaces corba}
    ID3DShaderCacheInstallerClient = interface;
    PID3DShaderCacheInstallerClient = ^ID3DShaderCacheInstallerClient;
    {$interfaces com}

    ID3DShaderCacheComponent = interface;
    PID3DShaderCacheComponent = ^ID3DShaderCacheComponent;


    ID3DShaderCacheApplication = interface;
    PID3DShaderCacheApplication = ^ID3DShaderCacheApplication;


    ID3DShaderCacheInstaller = interface;
    PID3DShaderCacheInstaller = ^ID3DShaderCacheInstaller;


    ID3DShaderCacheExplorer = interface;
    PID3DShaderCacheExplorer = ^ID3DShaderCacheExplorer;


    ID3DShaderCacheInstallerFactory = interface;
    PID3DShaderCacheInstallerFactory = ^ID3DShaderCacheInstallerFactory;


    TD3D_SHADER_CACHE_APP_REGISTRATION_SCOPE = (
        D3D_SHADER_CACHE_APP_REGISTRATION_SCOPE_USER = 0,
        D3D_SHADER_CACHE_APP_REGISTRATION_SCOPE_SYSTEM = (D3D_SHADER_CACHE_APP_REGISTRATION_SCOPE_USER + 1));

    PD3D_SHADER_CACHE_APP_REGISTRATION_SCOPE = ^TD3D_SHADER_CACHE_APP_REGISTRATION_SCOPE;


    {$interfaces corba}
    ID3DShaderCacheInstallerClient = interface
        ['{a16ee930-d9f6-4222-a514-244473e5d266}']
        function GetInstallerName(
        {_Inout_  } pNameLength: PSIZE_T;
        {_Out_writes_opt_(*pNameLength)  } pName: pwidechar): HRESULT; stdcall;

        function GetInstallerScope(): TD3D_SHADER_CACHE_APP_REGISTRATION_SCOPE; stdcall;

        function HandleDriverUpdate(
        {_In_  } pInstaller: ID3DShaderCacheInstaller): HRESULT; stdcall;

    end;
    {$interfaces com}


    TD3D_SHADER_CACHE_PSDB_PROPERTIES = record
        pAdapterFamily: pwidechar;
        pPsdbPath: pwidechar;
    end;
    PD3D_SHADER_CACHE_PSDB_PROPERTIES = ^TD3D_SHADER_CACHE_PSDB_PROPERTIES;


    ID3DShaderCacheComponent = interface(IUnknown)
        ['{eed1bf00-f5c7-4cf7-885c-d0f9c0cb4828}']
        function GetComponentName(
        {_Out_  }  out pName: pwidechar): HRESULT; stdcall;

        function GetStateObjectDatabasePath(
        {_Out_  }  out pPath: pwidechar): HRESULT; stdcall;

        function GetPrecompiledCachePath(
        {_In_  } pAdapterFamily: pwidechar;
        {_Inout_  } pPath: pwidechar): HRESULT; stdcall;

        function GetPrecompiledShaderDatabaseCount(): UINT; stdcall;

        function GetPrecompiledShaderDatabases(ArraySize: UINT;
        {_Out_writes_(ArraySize)  } pPSDBs: PD3D_SHADER_CACHE_PSDB_PROPERTIES): HRESULT; stdcall;

    end;


    TD3D_SHADER_CACHE_TARGET_FLAGS = (
        D3D_SHADER_CACHE_TARGET_FLAG_NONE = 0);

    PD3D_SHADER_CACHE_TARGET_FLAGS = ^TD3D_SHADER_CACHE_TARGET_FLAGS;


    TD3D_VERSION_NUMBER = record
        case integer of
            0: (
                Version: uint64;);
            1: (
                VersionParts: array [0..4 - 1] of uint16;);
    end;
    PD3D_VERSION_NUMBER = ^TD3D_VERSION_NUMBER;

    TD3D_SHADER_CACHE_COMPILER_PROPERTIES = record
        szAdapterFamily: array [0..128 - 1] of widechar;
        MinimumABISupportVersion: uint64;
        MaximumABISupportVersion: uint64;
        CompilerVersion: TD3D_VERSION_NUMBER;
        ApplicationProfileVersion: TD3D_VERSION_NUMBER;
    end;
    PD3D_SHADER_CACHE_COMPILER_PROPERTIES = ^TD3D_SHADER_CACHE_COMPILER_PROPERTIES;


    TD3D_SHADER_CACHE_APPLICATION_DESC = record
        pExeFilename: pwidechar;
        pName: pwidechar;
        Version: TD3D_VERSION_NUMBER;
        pEngineName: pwidechar;
        EngineVersion: TD3D_VERSION_NUMBER;
    end;
    PD3D_SHADER_CACHE_APPLICATION_DESC = ^TD3D_SHADER_CACHE_APPLICATION_DESC;


    ID3DShaderCacheApplication = interface(IUnknown)
        ['{fc688ee2-1b35-4913-93be-1ca3fa7df39e}']
        function GetExePath(
        {_Out_  }  out pExePath: pwidechar): HRESULT; stdcall;

        function GetDesc(
        {_Out_  } pApplicationDesc: PD3D_SHADER_CACHE_APPLICATION_DESC): HRESULT; stdcall;

        function RegisterComponent(
        {_In_  } pName: pwidechar;
        {_In_  } pStateObjectDBPath: pwidechar;
        {_In_  } NumPSDB: UINT;
        {_In_reads_(NumPSDB)  } pPSDBs: PD3D_SHADER_CACHE_PSDB_PROPERTIES; riid: REFIID;
        {_COM_Outptr_  }  out ppvComponent): HRESULT; stdcall;

        function RemoveComponent(
        {_In_  } pComponent: ID3DShaderCacheComponent): HRESULT; stdcall;

        function GetComponentCount(): UINT; stdcall;

        function GetComponent(
        {_In_  } index: UINT; riid: REFIID;
        {_COM_Outptr_  }  out ppvComponent): HRESULT; stdcall;

        function GetPrecompileTargetCount(flags: TD3D_SHADER_CACHE_TARGET_FLAGS): UINT; stdcall;

        function GetPrecompileTargets(
        {_In_  } ArraySize: UINT;
        {_In_reads_(ArraySize)  } pArray: PD3D_SHADER_CACHE_COMPILER_PROPERTIES; flags: TD3D_SHADER_CACHE_TARGET_FLAGS): HRESULT; stdcall;

        function GetInstallerName(
        {_Out_  }  out pInstallerName: pwidechar): HRESULT; stdcall;

    end;


    ID3DShaderCacheInstaller = interface(IUnknown)
        ['{bbe30de1-6318-4526-ae17-776693191bb4}']
        function RegisterDriverUpdateListener(): HRESULT; stdcall;

        function UnregisterDriverUpdateListener(): HRESULT; stdcall;

        function RegisterServiceDriverUpdateTrigger(hServiceHandle: SC_HANDLE): HRESULT; stdcall;

        function UnregisterServiceDriverUpdateTrigger(hServiceHandle: SC_HANDLE): HRESULT; stdcall;

        function RegisterApplication(
        {_In_  } pExePath: pwidechar;
        {_In_  } pApplicationDesc: PD3D_SHADER_CACHE_APPLICATION_DESC; riid: REFIID;
        {_COM_Outptr_  }  out ppvApp): HRESULT; stdcall;

        function RemoveApplication(
        {_In_  } pApplication: ID3DShaderCacheApplication): HRESULT; stdcall;

        function GetApplicationCount(): UINT; stdcall;

        function GetApplication(
        {_In_  } index: UINT; riid: REFIID;
        {_COM_Outptr_  }  out ppvApp): HRESULT; stdcall;

        function ClearAllState(): HRESULT; stdcall;

        function GetMaxPrecompileTargetCount(): UINT; stdcall;

        function GetPrecompileTargets(
        {_In_opt_  } pApplicationDesc: PD3D_SHADER_CACHE_APPLICATION_DESC;
        {_Inout_  } pArraySize: PUINT;
        {_Out_writes_(*pArraySize)  } pArray: PD3D_SHADER_CACHE_COMPILER_PROPERTIES; flags: TD3D_SHADER_CACHE_TARGET_FLAGS): HRESULT; stdcall;

    end;


    ID3DShaderCacheExplorer = interface(IUnknown)
        ['{90432322-32f5-487f-9264-e9390fa58b2a}']
        function GetApplicationFromExePath(
        {_In_  } pFullExePath: pwidechar; riid: REFIID;
        {_COM_Outptr_  }  out ppvApp): HRESULT; stdcall;

    end;


    ID3DShaderCacheInstallerFactory = interface(IUnknown)
        ['{09b2dfe4-840f-401a-804c-0dd8aadc9e9f}']
        function CreateInstaller(
        {_In_  } pClient: ID3DShaderCacheInstallerClient; riid: REFIID;
        {_COM_Outptr_  }  out ppvInstaller): HRESULT; stdcall;

        function CreateExplorer(pUnknown: IUnknown; riid: REFIID;
        {_COM_Outptr_  }  out ppvExplorer): HRESULT; stdcall;

    end;


implementation

end.
