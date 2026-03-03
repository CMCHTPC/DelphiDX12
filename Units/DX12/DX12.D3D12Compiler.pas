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
unit DX12.D3D12Compiler;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.DXGICommon,
    DX12.D3DCommon,
    DX12.D3D12;

    {$Z4}


const

    D3D12StateObjectCompiler_DLL = 'D3D12StateObjectCompiler.dll';

    IID_ID3D12CompilerFactoryChild: TGUID = '{E0D06420-9F31-47E8-AE9A-DD2BA25AC0BC}';
    IID_ID3D12CompilerCacheSession: TGUID = '{5704E5E6-054B-4738-B661-7B0D68D8DDE2}';
    IID_ID3D12CompilerStateObject: TGUID = '{5981CCA4-E8AE-44CA-9B92-4FA86F5A3A3A}';
    IID_ID3D12Compiler: TGUID = '{8C403C12-993B-4583-80F1-6824138FA68E}';
    IID_ID3D12CompilerFactory: TGUID = '{C1EE4B59-3F59-47A5-9B4E-A855C858A878}';


type


    (* Forward Declarations *)


    ID3D12CompilerFactoryChild = interface;
    PID3D12CompilerFactoryChild = ^ID3D12CompilerFactoryChild;


    ID3D12CompilerCacheSession = interface;
    PID3D12CompilerCacheSession = ^ID3D12CompilerCacheSession;


    ID3D12CompilerStateObject = interface;
    PID3D12CompilerStateObject = ^ID3D12CompilerStateObject;


    ID3D12Compiler = interface;
    PID3D12Compiler = ^ID3D12Compiler;


    ID3D12CompilerFactory = interface;
    PID3D12CompilerFactory = ^ID3D12CompilerFactory;


    TD3D12_ADAPTER_FAMILY = record
        szAdapterFamily: array [0..128 - 1] of WCHAR;
    end;
    PD3D12_ADAPTER_FAMILY = ^TD3D12_ADAPTER_FAMILY;


    PFN_D3D12_COMPILER_CREATE_FACTORY = function(
        {_In_ } pPluginCompilerDllPath: LPCWSTR;
        {_In_ } riid: REFIID;
        {_COM_Outptr_opt_ }  out ppFactory): HRESULT; stdcall;


    PFN_D3D12_COMPILER_SERIALIZE_VERSIONED_ROOT_SIGNATURE = function(
        {_In_ } pRootSignature: PD3D12_VERSIONED_ROOT_SIGNATURE_DESC;
        {_Out_ }  out ppBlob: ID3DBlob;
        {_Always_(_Outptr_opt_result_maybenull_) }  out ppErrorBlob: ID3DBlob): HRESULT; stdcall;


    ID3D12CompilerFactoryChild = interface(IUnknown)
        ['{e0d06420-9f31-47e8-ae9a-dd2ba25ac0bc}']
        function GetFactory(
        {_In_  } riid: REFIID;
        {_COM_Outptr_  }  out ppCompilerFactory): HRESULT; stdcall;

    end;


    TD3D12_COMPILER_VALUE_TYPE = (
        D3D12_COMPILER_VALUE_TYPE_OBJECT_CODE = 0,
        D3D12_COMPILER_VALUE_TYPE_METADATA = 1,
        D3D12_COMPILER_VALUE_TYPE_DEBUG_PDB = 2,
        D3D12_COMPILER_VALUE_TYPE_PERFORMANCE_DATA = 3);

    PD3D12_COMPILER_VALUE_TYPE = ^TD3D12_COMPILER_VALUE_TYPE;


    TD3D12_COMPILER_VALUE_TYPE_FLAGS = (
        D3D12_COMPILER_VALUE_TYPE_FLAGS_NONE = 0,
        D3D12_COMPILER_VALUE_TYPE_FLAGS_OBJECT_CODE = 1 shl Ord(D3D12_COMPILER_VALUE_TYPE_OBJECT_CODE),
        D3D12_COMPILER_VALUE_TYPE_FLAGS_METADATA = 1 shl Ord(D3D12_COMPILER_VALUE_TYPE_METADATA),
        D3D12_COMPILER_VALUE_TYPE_FLAGS_DEBUG_PDB = 1 shl Ord(D3D12_COMPILER_VALUE_TYPE_DEBUG_PDB),
        D3D12_COMPILER_VALUE_TYPE_FLAGS_PERFORMANCE_DATA = 1 shl Ord(D3D12_COMPILER_VALUE_TYPE_PERFORMANCE_DATA));

    PD3D12_COMPILER_VALUE_TYPE_FLAGS = ^TD3D12_COMPILER_VALUE_TYPE_FLAGS;


    TD3D12_COMPILER_DATABASE_PATH = record
        Types: TD3D12_COMPILER_VALUE_TYPE_FLAGS;
        pPath: LPCWSTR;
    end;
    PD3D12_COMPILER_DATABASE_PATH = ^TD3D12_COMPILER_DATABASE_PATH;


    TD3D12_COMPILER_CACHE_GROUP_KEY = record
        {_Field_size_bytes_full_(KeySize)  } pKey: Pvoid;
        KeySize: UINT;
    end;
    PD3D12_COMPILER_CACHE_GROUP_KEY = ^TD3D12_COMPILER_CACHE_GROUP_KEY;


    TD3D12_COMPILER_CACHE_VALUE_KEY = record
        {_Field_size_bytes_full_(KeySize)  } pKey: Pvoid;
        KeySize: UINT;
    end;
    PD3D12_COMPILER_CACHE_VALUE_KEY = ^TD3D12_COMPILER_CACHE_VALUE_KEY;


    TD3D12_COMPILER_CACHE_VALUE = record
        {_Field_size_bytes_full_(ValueSize)  } pValue: Pvoid;
        ValueSize: UINT;
    end;
    PD3D12_COMPILER_CACHE_VALUE = ^TD3D12_COMPILER_CACHE_VALUE;


    TD3D12_COMPILER_CACHE_TYPED_VALUE = record
        CompilerValueType: TD3D12_COMPILER_VALUE_TYPE;
        Value: TD3D12_COMPILER_CACHE_VALUE;
    end;
    PD3D12_COMPILER_CACHE_TYPED_VALUE = ^TD3D12_COMPILER_CACHE_TYPED_VALUE;


    TD3D12_COMPILER_CACHE_CONST_VALUE = record
        {_Field_size_bytes_full_(ValueSize)  } pValue: Pvoid;
        ValueSize: UINT;
    end;
    PD3D12_COMPILER_CACHE_CONST_VALUE = ^TD3D12_COMPILER_CACHE_CONST_VALUE;


    TD3D12_COMPILER_CACHE_TYPED_CONST_VALUE = record
        CompilerValueType: TD3D12_COMPILER_VALUE_TYPE;
        Value: TD3D12_COMPILER_CACHE_CONST_VALUE;
    end;
    PD3D12_COMPILER_CACHE_TYPED_CONST_VALUE = ^TD3D12_COMPILER_CACHE_TYPED_CONST_VALUE;


    TD3D12_COMPILER_TARGET = record
        AdapterFamilyIndex: UINT;
        ABIVersion: uint64;
    end;
    PD3D12_COMPILER_TARGET = ^TD3D12_COMPILER_TARGET;


    TD3D12CompilerCacheSessionAllocationFunc = procedure(SizeInBytes: SIZE_T;
        {_Inout_opt_  } pContext: Pvoid); stdcall;


    TD3D12CompilerCacheSessionGroupValueKeysFunc = procedure(
        {_In_  } pValueKey: PD3D12_COMPILER_CACHE_VALUE_KEY;
        {_Inout_opt_  } pContext: Pvoid); stdcall;


    TD3D12CompilerCacheSessionGroupValuesFunc = procedure(ValueKeyIndex: UINT;
        {_In_  } pTypedValue: PD3D12_COMPILER_CACHE_TYPED_CONST_VALUE;
        {_Inout_opt_  } pContext: Pvoid); stdcall;


    ID3D12CompilerCacheSession = interface(ID3D12CompilerFactoryChild)
        ['{5704e5e6-054b-4738-b661-7b0d68d8dde2}']
        function FindGroup(
        {_In_  } pGroupKey: PD3D12_COMPILER_CACHE_GROUP_KEY;
        {_Out_opt_  } pGroupVersion: PUINT): HRESULT; stdcall;

        function FindGroupValueKeys(
        {_In_  } pGroupKey: PD3D12_COMPILER_CACHE_GROUP_KEY;
        {_In_opt_  } pExpectedGroupVersion: PUINT;
        {_In_  } CallbackFunc: TD3D12CompilerCacheSessionGroupValueKeysFunc;
        {_Inout_opt_  } pContext: Pvoid): HRESULT; stdcall;

        function FindGroupValues(
        {_In_  } pGroupKey: PD3D12_COMPILER_CACHE_GROUP_KEY;
        {_In_opt_  } pExpectedGroupVersion: PUINT; ValueTypeFlags: TD3D12_COMPILER_VALUE_TYPE_FLAGS;
        {_In_opt_  } CallbackFunc: TD3D12CompilerCacheSessionGroupValuesFunc;
        {_Inout_opt_  } pContext: Pvoid): HRESULT; stdcall;

        function FindValue(
        {_In_  } pValueKey: PD3D12_COMPILER_CACHE_VALUE_KEY;
        {_Inout_count_(NumTypedValues)  } pTypedValues: PD3D12_COMPILER_CACHE_TYPED_VALUE; NumTypedValues: UINT;
        {_In_opt_  } pCallbackFunc: TD3D12CompilerCacheSessionAllocationFunc;
        {_Inout_opt_  } pContext: Pvoid): HRESULT; stdcall;

        function GetApplicationDesc(): TD3D12_APPLICATION_DESC; stdcall;

        function GetCompilerTarget(RetVal: PD3D12_COMPILER_TARGET): TD3D12_COMPILER_TARGET; stdcall;

        function GetValueTypes(): TD3D12_COMPILER_VALUE_TYPE_FLAGS; stdcall;

        function StoreGroupValueKeys(
        {_In_  } pGroupKey: PD3D12_COMPILER_CACHE_GROUP_KEY; GroupVersion: UINT;
        {_In_reads_(NumValueKeys)  } pValueKeys: PD3D12_COMPILER_CACHE_VALUE_KEY; NumValueKeys: UINT): HRESULT; stdcall;

        function StoreValue(
        {_In_  } pValueKey: PD3D12_COMPILER_CACHE_VALUE_KEY;
        {_In_reads_(NumTypedValues)  } pTypedValues: PD3D12_COMPILER_CACHE_TYPED_CONST_VALUE; NumTypedValues: UINT): HRESULT; stdcall;

    end;


    ID3D12CompilerStateObject = interface(IUnknown)
        ['{5981cca4-e8ae-44ca-9b92-4fa86f5a3a3a}']
        function GetCompiler(
        {_In_  } riid: REFIID;
        {_COM_Outptr_  }  out ppCompiler): HRESULT; stdcall;

    end;


    TD3D12_COMPILER_EXISTING_COLLECTION_DESC = record
        pExistingCollection: PID3D12CompilerStateObject;
        NumExports: UINT;
        {_In_reads_(NumExports)  } pExports: PD3D12_EXPORT_DESC;
    end;
    PD3D12_COMPILER_EXISTING_COLLECTION_DESC = ^TD3D12_COMPILER_EXISTING_COLLECTION_DESC;


    ID3D12Compiler = interface(ID3D12CompilerFactoryChild)
        ['{8c403c12-993b-4583-80f1-6824138fa68e}']
        function CompilePipelineState(
        {_In_  } pGroupKey: PD3D12_COMPILER_CACHE_GROUP_KEY; GroupVersion: UINT;
        {_In_  } pDesc: PD3D12_PIPELINE_STATE_STREAM_DESC): HRESULT; stdcall;

        function CompileStateObject(
        {_In_  } pGroupKey: PD3D12_COMPILER_CACHE_GROUP_KEY; GroupVersion: UINT;
        {_In_  } pDesc: PD3D12_STATE_OBJECT_DESC;
        {_In_  } riid: REFIID;
        {_COM_Outptr_  }  out ppCompilerStateObject): HRESULT; stdcall;

        function CompileAddToStateObject(
        {_In_  } pGroupKey: PD3D12_COMPILER_CACHE_GROUP_KEY; GroupVersion: UINT;
        {_In_  } pAddition: PD3D12_STATE_OBJECT_DESC;
        {_In_  } pCompilerStateObjectToGrowFrom: ID3D12CompilerStateObject;
        {_In_  } riid: REFIID;
        {_COM_Outptr_  }  out ppNewCompilerStateObject): HRESULT; stdcall;

        function GetCacheSession(
        {_In_  } riid: REFIID;
        {_COM_Outptr_  }  out ppCompilerCacheSession): HRESULT; stdcall;

    end;


    ID3D12CompilerFactory = interface(IUnknown)
        ['{c1ee4b59-3f59-47a5-9b4e-a855c858a878}']
        function EnumerateAdapterFamilies(AdapterFamilyIndex: UINT;
        {_Out_  } pAdapterFamily: PD3D12_ADAPTER_FAMILY): HRESULT; stdcall;

        function EnumerateAdapterFamilyABIVersions(AdapterFamilyIndex: UINT;
        {_Inout_  } pNumABIVersions: PUINT32;
        {_Out_writes_opt_(*pNumABIVersions)  } pABIVersions: PUINT64): HRESULT; stdcall;

        function EnumerateAdapterFamilyCompilerVersion(AdapterFamilyIndex: UINT;
        {_Out_  } pCompilerVersion: PD3D12_VERSION_NUMBER): HRESULT; stdcall;

        function GetApplicationProfileVersion(
        {_In_  } pTarget: PD3D12_COMPILER_TARGET;
        {_In_  } pApplicationDesc: PD3D12_APPLICATION_DESC;
        {_Out_  } pApplicationProfileVersion: PD3D12_VERSION_NUMBER): HRESULT; stdcall;

        function CreateCompilerCacheSession(
        {_In_reads_(NumPaths)  } pPaths: PD3D12_COMPILER_DATABASE_PATH; NumPaths: UINT;
        {_In_opt_  } pTarget: PD3D12_COMPILER_TARGET;
        {_In_opt_  } pApplicationDesc: PD3D12_APPLICATION_DESC;
        {_In_  } riid: REFIID;
        {_COM_Outptr_  }  out ppCompilerCacheSession): HRESULT; stdcall;

        function CreateCompiler(
        {_In_  } pCompilerCacheSession: ID3D12CompilerCacheSession;
        {_In_  } riid: REFIID;
        {_COM_Outptr_  }  out ppCompiler): HRESULT; stdcall;

    end;


function D3D12CompilerCreateFactory(
    {_In_ } pPluginCompilerDllPath: LPCWSTR;
    // Expected: ID3D12CompilerFactory
    {_In_ } riid: REFIID;
    {_COM_Outptr_opt_ }  out ppFactory): HRESULT; stdcall; external D3D12StateObjectCompiler_DLL;


function D3D12CompilerSerializeVersionedRootSignature(
    {_In_ } pRootSignature: PD3D12_VERSIONED_ROOT_SIGNATURE_DESC;
    {_Out_ }  out ppBlob: ID3DBlob;
    {_Always_(_Outptr_opt_result_maybenull_) }  out ppErrorBlob: ID3DBlob): HRESULT; stdcall; external D3D12StateObjectCompiler_DLL;


implementation

end.
