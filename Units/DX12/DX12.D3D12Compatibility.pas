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
   File name: d3d12compatibility.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3D12Compatibility;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D12,
    DX12.D3D11on12;

    {$Z4}

const

    IID_ID3D12CompatibilityDevice: TGUID = '{8F1C0E3C-FAE3-4A82-B098-BFE1708207FF}';
    IID_D3D11On12CreatorID: TGUID = '{EDBF5678-2960-4E81-8429-99D4B2630C4E}';
    IID_D3D9On12CreatorID: TGUID = '{FFFCBB7F-15D3-42A2-841E-9D8D32F37DDD}';
    IID_OpenGLOn12CreatorID: TGUID = '{6BB3CD34-0D19-45AB-97ED-D720BA3DFC80}';
    IID_OpenCLOn12CreatorID: TGUID = '{3F76BB74-91B5-4A88-B126-20CA0331CD60}';
    IID_VulkanOn12CreatorID: TGUID = '{BC806E01-3052-406C-A3E8-9FC07F048F98}';
    IID_DirectMLTensorFlowCreatorID: TGUID = '{CB7490AC-8A0F-44EC-9B7B-6F4CAFE8E9AB}';
    IID_DirectMLPyTorchCreatorID: TGUID = '{AF029192-FBA1-4B05-9116-235E06560354}';
    IID_DirectMLWebNNCreatorID: TGUID = '{fdf01a76-1e11-450f-902b-74f04ea08094}';


type


    (* Forward Declarations *)


    ID3D12CompatibilityDevice = interface;
    PID3D12CompatibilityDevice = ^ID3D12CompatibilityDevice;


    D3D11On12CreatorID = interface;
    PD3D11On12CreatorID = ^D3D11On12CreatorID;


    D3D9On12CreatorID = interface;
    PD3D9On12CreatorID = ^D3D9On12CreatorID;


    OpenGLOn12CreatorID = interface;
    POpenGLOn12CreatorID = ^OpenGLOn12CreatorID;


    OpenCLOn12CreatorID = interface;
    POpenCLOn12CreatorID = ^OpenCLOn12CreatorID;


    VulkanOn12CreatorID = interface;
    PVulkanOn12CreatorID = ^VulkanOn12CreatorID;


    DirectMLTensorFlowCreatorID = interface;
    PDirectMLTensorFlowCreatorID = ^DirectMLTensorFlowCreatorID;


    DirectMLPyTorchCreatorID = interface;
    PDirectMLPyTorchCreatorID = ^DirectMLPyTorchCreatorID;


    DirectMLWebNNCreatorID = interface;
    PDirectMLWebNNCreatorID = ^DirectMLWebNNCreatorID;

    TD3D12_COMPATIBILITY_SHARED_FLAGS = (
        D3D12_COMPATIBILITY_SHARED_FLAG_NONE = 0,
        D3D12_COMPATIBILITY_SHARED_FLAG_NON_NT_HANDLE = $1,
        D3D12_COMPATIBILITY_SHARED_FLAG_KEYED_MUTEX = $2,
        D3D12_COMPATIBILITY_SHARED_FLAG_9_ON_12 = $4);

    PD3D12_COMPATIBILITY_SHARED_FLAGS = ^TD3D12_COMPATIBILITY_SHARED_FLAGS;


    TD3D12_REFLECT_SHARED_PROPERTY = (
        D3D12_REFLECT_SHARED_PROPERTY_D3D11_RESOURCE_FLAGS = 0,
        D3D12_REFELCT_SHARED_PROPERTY_COMPATIBILITY_SHARED_FLAGS = (D3D12_REFLECT_SHARED_PROPERTY_D3D11_RESOURCE_FLAGS + 1),
        D3D12_REFLECT_SHARED_PROPERTY_NON_NT_SHARED_HANDLE = (D3D12_REFELCT_SHARED_PROPERTY_COMPATIBILITY_SHARED_FLAGS + 1));

    PD3D12_REFLECT_SHARED_PROPERTY = ^TD3D12_REFLECT_SHARED_PROPERTY;


    ID3D12CompatibilityDevice = interface(IUnknown)
        ['{8f1c0e3c-fae3-4a82-b098-bfe1708207ff}']
        function CreateSharedResource(
        {_In_  } pHeapProperties: PD3D12_HEAP_PROPERTIES; HeapFlags: TD3D12_HEAP_FLAGS;
        {_In_  } pDesc: PD3D12_RESOURCE_DESC; InitialResourceState: TD3D12_RESOURCE_STATES;
        {_In_opt_  } pOptimizedClearValue: PD3D12_CLEAR_VALUE;
        {_In_opt_  } pFlags11: PD3D11_RESOURCE_FLAGS; CompatibilityFlags: TD3D12_COMPATIBILITY_SHARED_FLAGS;
        {_In_opt_  } pLifetimeTracker: ID3D12LifetimeTracker;
        {_In_opt_  } pOwningSwapchain: ID3D12SwapChainAssistant; riid: REFIID;
        {_COM_Outptr_opt_  }  out ppResource): HRESULT; stdcall;

        function CreateSharedHeap(
        {_In_  } pHeapDesc: PD3D12_HEAP_DESC; CompatibilityFlags: TD3D12_COMPATIBILITY_SHARED_FLAGS; riid: REFIID;
        {_COM_Outptr_opt_  }  out ppHeap): HRESULT; stdcall;

        function ReflectSharedProperties(
        {_In_  } pHeapOrResource: ID3D12Object; ReflectType: TD3D12_REFLECT_SHARED_PROPERTY;
        {_Out_writes_bytes_(DataSize)  } pData: Pvoid; DataSize: UINT): HRESULT; stdcall;

    end;


    D3D11On12CreatorID = interface(IUnknown)
        ['{edbf5678-2960-4e81-8429-99d4b2630c4e}']
    end;


    D3D9On12CreatorID = interface(IUnknown)
        ['{fffcbb7f-15d3-42a2-841e-9d8d32f37ddd}']
    end;


    OpenGLOn12CreatorID = interface(IUnknown)
        ['{6bb3cd34-0d19-45ab-97ed-d720ba3dfc80}']
    end;


    OpenCLOn12CreatorID = interface(IUnknown)
        ['{3f76bb74-91b5-4a88-b126-20ca0331cd60}']
    end;


    VulkanOn12CreatorID = interface(IUnknown)
        ['{bc806e01-3052-406c-a3e8-9fc07f048f98}']
    end;


    DirectMLTensorFlowCreatorID = interface(IUnknown)
        ['{cb7490ac-8a0f-44ec-9b7b-6f4cafe8e9ab}']
    end;


    DirectMLPyTorchCreatorID = interface(IUnknown)
        ['{af029192-fba1-4b05-9116-235e06560354}']
    end;

    DirectMLWebNNCreatorID = interface(IUnknown)
        ['{fdf01a76-1e11-450f-902b-74f04ea08094}']
    end;


implementation

end.
