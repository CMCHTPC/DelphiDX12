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
   DXCore Interface

   This unit consists of the following header files
   File name: d3dx12_root_signature.h
   Header version: SDK 1.717.1-preview  2025 12 28

  ************************************************************************** }
unit DX12.D3DX12_Root_Signature;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3DX12_Default,
    DX12.D3DCommon,
    DX12.D3D12;

    {$I DX12.DX12SDKVersion.inc}

type

    { TD3DX12_DESCRIPTOR_RANGE }

    TD3DX12_DESCRIPTOR_RANGE = type helper for TD3D12_DESCRIPTOR_RANGE
        class function Create(o: PD3D12_DESCRIPTOR_RANGE = nil): PD3D12_DESCRIPTOR_RANGE; inline; overload; static;
        class function Create(numDescriptors: UINT; baseShaderRegister: UINT; registerSpace: UINT = 0; offsetInDescriptorsFromTableStart: UINT = D3D12_DESCRIPTOR_RANGE_OFFSET_APPEND): PD3D12_DESCRIPTOR_RANGE; inline; overload; static;
        procedure Init(); overload;
        procedure Init(numDescriptors: UINT; baseShaderRegister: UINT; registerSpace: UINT = 0; offsetInDescriptorsFromTableStart: UINT = D3D12_DESCRIPTOR_RANGE_OFFSET_APPEND); overload;
    end;

    { TD3DX12_ROOT_DESCRIPTOR_TABLE }

    TD3DX12_ROOT_DESCRIPTOR_TABLE = type helper for TD3D12_ROOT_DESCRIPTOR_TABLE
        class function Create(o: PD3D12_ROOT_DESCRIPTOR_TABLE = nil): PD3D12_ROOT_DESCRIPTOR_TABLE; inline; overload; static;
        class function Create(numDescriptorRanges: UINT; {_In_reads_opt_(numDescriptorRanges) } _pDescriptorRanges: PD3D12_DESCRIPTOR_RANGE_ARRAY): PD3D12_ROOT_DESCRIPTOR_TABLE; inline; overload; static;
        procedure Init(); overload;
        procedure Init(numDescriptorRanges: UINT;
        {_In_reads_opt_(numDescriptorRanges) } _pDescriptorRanges: PD3D12_DESCRIPTOR_RANGE_ARRAY); overload;
    end;

    { TD3DX12_ROOT_CONSTANTS }

    TD3DX12_ROOT_CONSTANTS = type helper for TD3D12_ROOT_CONSTANTS
        class function Create(o: PD3D12_ROOT_CONSTANTS = nil): PD3D12_ROOT_CONSTANTS; inline; overload; static;
        class function Create(num32BitValues: UINT; shaderRegister: UINT; registerSpace: UINT = 0): PD3D12_ROOT_CONSTANTS; inline; overload; static;
        procedure Init(); overload;
        procedure Init(num32BitValues: UINT; shaderRegister: UINT; registerSpace: UINT = 0); overload;
    end;

    TD3DX12_ROOT_DESCRIPTOR = type helper for TD3D12_ROOT_DESCRIPTOR
        class function Create(o: PD3D12_ROOT_DESCRIPTOR = nil): PD3D12_ROOT_DESCRIPTOR; inline; overload; static;
        class function Create(shaderRegister: UINT; registerSpace: UINT = 0): PD3D12_ROOT_DESCRIPTOR; inline; overload; static;
        procedure Init(); overload;
        procedure Init(shaderRegister: UINT; registerSpace: UINT = 0); overload;
    end;

    { TD3DX12_ROOT_PARAMETER }

    TD3DX12_ROOT_PARAMETER = type helper for TD3D12_ROOT_PARAMETER
        class function Create(o: PD3D12_ROOT_PARAMETER = nil): PD3D12_ROOT_PARAMETER; inline; static;
        class function CreateAsDescriptorTable(numDescriptorRanges: UINT;
        {_In_reads_(numDescriptorRanges) } pDescriptorRanges: PD3D12_DESCRIPTOR_RANGE_ARRAY; visibility: TD3D12_SHADER_VISIBILITY = D3D12_SHADER_VISIBILITY_ALL): PD3D12_ROOT_PARAMETER; inline; static;
        class function CreateAsConstants(num32BitValues: UINT; shaderRegister: UINT; registerSpace: UINT = 0; visibility: TD3D12_SHADER_VISIBILITY = D3D12_SHADER_VISIBILITY_ALL): PD3D12_ROOT_PARAMETER; inline; static;
        class function CreateAsConstantBufferView(shaderRegister: UINT; registerSpace: UINT = 0; visibility: TD3D12_SHADER_VISIBILITY = D3D12_SHADER_VISIBILITY_ALL): PD3D12_ROOT_PARAMETER; inline; static;
        class function CreateAsShaderResourceView(shaderRegister: UINT; registerSpace: UINT = 0; visibility: TD3D12_SHADER_VISIBILITY = D3D12_SHADER_VISIBILITY_ALL): PD3D12_ROOT_PARAMETER; inline; static;
        class function CreateAsUnorderedAccessView(shaderRegister: UINT; registerSpace: UINT = 0; visibility: TD3D12_SHADER_VISIBILITY = D3D12_SHADER_VISIBILITY_ALL): PD3D12_ROOT_PARAMETER; inline; static;
        procedure Init();
        procedure InitAsDescriptorTable(numDescriptorRanges: UINT;
        {_In_reads_(numDescriptorRanges) } pDescriptorRanges: PD3D12_DESCRIPTOR_RANGE_ARRAY; visibility: TD3D12_SHADER_VISIBILITY = D3D12_SHADER_VISIBILITY_ALL);
        procedure InitAsConstants(num32BitValues: UINT; shaderRegister: UINT; registerSpace: UINT = 0; visibility: TD3D12_SHADER_VISIBILITY = D3D12_SHADER_VISIBILITY_ALL);
        procedure InitAsConstantBufferView(shaderRegister: UINT; registerSpace: UINT = 0; visibility: TD3D12_SHADER_VISIBILITY = D3D12_SHADER_VISIBILITY_ALL);
        procedure InitAsShaderResourceView(shaderRegister: UINT; registerSpace: UINT = 0; visibility: TD3D12_SHADER_VISIBILITY = D3D12_SHADER_VISIBILITY_ALL);
        procedure InitAsUnorderedAccessView(shaderRegister: UINT; registerSpace: UINT = 0; visibility: TD3D12_SHADER_VISIBILITY = D3D12_SHADER_VISIBILITY_ALL);
    end;


    { TD3DX12_STATIC_SAMPLER_DESC }

    TD3DX12_STATIC_SAMPLER_DESC = type helper for TD3D12_STATIC_SAMPLER_DESC
        class function Create(o: PD3D12_STATIC_SAMPLER_DESC = nil): PD3D12_STATIC_SAMPLER_DESC; inline; overload; static;
        class function Create(shaderRegister: UINT; filter: TD3D12_FILTER = D3D12_FILTER_ANISOTROPIC; addressU: TD3D12_TEXTURE_ADDRESS_MODE = D3D12_TEXTURE_ADDRESS_MODE_WRAP;
            addressV: TD3D12_TEXTURE_ADDRESS_MODE = D3D12_TEXTURE_ADDRESS_MODE_WRAP; addressW: TD3D12_TEXTURE_ADDRESS_MODE = D3D12_TEXTURE_ADDRESS_MODE_WRAP; mipLODBias: single = 0;
            maxAnisotropy: UINT = 16; comparisonFunc: TD3D12_COMPARISON_FUNC = D3D12_COMPARISON_FUNC_LESS_EQUAL; borderColor: TD3D12_STATIC_BORDER_COLOR = D3D12_STATIC_BORDER_COLOR_OPAQUE_WHITE;
            minLOD: single = 0.0; maxLOD: single = D3D12_FLOAT32_MAX; shaderVisibility: TD3D12_SHADER_VISIBILITY = D3D12_SHADER_VISIBILITY_ALL; registerSpace: UINT = 0): PD3D12_STATIC_SAMPLER_DESC; inline; overload; static;

        procedure Init(); overload;
        procedure Init(shaderRegister: UINT; filter: TD3D12_FILTER = D3D12_FILTER_ANISOTROPIC; addressU: TD3D12_TEXTURE_ADDRESS_MODE = D3D12_TEXTURE_ADDRESS_MODE_WRAP;
            addressV: TD3D12_TEXTURE_ADDRESS_MODE = D3D12_TEXTURE_ADDRESS_MODE_WRAP; addressW: TD3D12_TEXTURE_ADDRESS_MODE = D3D12_TEXTURE_ADDRESS_MODE_WRAP; mipLODBias: single = 0;
            maxAnisotropy: UINT = 16; comparisonFunc: TD3D12_COMPARISON_FUNC = D3D12_COMPARISON_FUNC_LESS_EQUAL; borderColor: TD3D12_STATIC_BORDER_COLOR = D3D12_STATIC_BORDER_COLOR_OPAQUE_WHITE;
            minLOD: single = 0.0; maxLOD: single = D3D12_FLOAT32_MAX; shaderVisibility: TD3D12_SHADER_VISIBILITY = D3D12_SHADER_VISIBILITY_ALL; registerSpace: UINT = 0); overload;
    end;

    { TD3DX12_STATIC_SAMPLER_DESC1 }

    TD3DX12_STATIC_SAMPLER_DESC1 = type helper for TD3D12_STATIC_SAMPLER_DESC1
        class function Create(o: PD3D12_STATIC_SAMPLER_DESC1 = nil): PD3D12_STATIC_SAMPLER_DESC1; inline; overload; static;
        class function Create(o: PD3D12_STATIC_SAMPLER_DESC = nil): PD3D12_STATIC_SAMPLER_DESC1; inline; overload; static;
        class function Create(shaderRegister: UINT; filter: TD3D12_FILTER = D3D12_FILTER_ANISOTROPIC; addressU: TD3D12_TEXTURE_ADDRESS_MODE = D3D12_TEXTURE_ADDRESS_MODE_WRAP;
            addressV: TD3D12_TEXTURE_ADDRESS_MODE = D3D12_TEXTURE_ADDRESS_MODE_WRAP; addressW: TD3D12_TEXTURE_ADDRESS_MODE = D3D12_TEXTURE_ADDRESS_MODE_WRAP; mipLODBias: single = 0;
            maxAnisotropy: UINT = 16; comparisonFunc: TD3D12_COMPARISON_FUNC = D3D12_COMPARISON_FUNC_LESS_EQUAL; borderColor: TD3D12_STATIC_BORDER_COLOR = D3D12_STATIC_BORDER_COLOR_OPAQUE_WHITE;
            minLOD: single = 0.0; maxLOD: single = D3D12_FLOAT32_MAX; shaderVisibility: TD3D12_SHADER_VISIBILITY = D3D12_SHADER_VISIBILITY_ALL; registerSpace: UINT = 0;
            flags: TD3D12_SAMPLER_FLAGS = TD3D12_SAMPLER_FLAGS.D3D12_SAMPLER_FLAG_NONE): PD3D12_STATIC_SAMPLER_DESC1; inline; overload; static;

        procedure Init(); overload;
        procedure Init(shaderRegister: UINT; filter: TD3D12_FILTER = D3D12_FILTER_ANISOTROPIC; addressU: TD3D12_TEXTURE_ADDRESS_MODE = D3D12_TEXTURE_ADDRESS_MODE_WRAP;
            addressV: TD3D12_TEXTURE_ADDRESS_MODE = D3D12_TEXTURE_ADDRESS_MODE_WRAP; addressW: TD3D12_TEXTURE_ADDRESS_MODE = D3D12_TEXTURE_ADDRESS_MODE_WRAP; mipLODBias: single = 0;
            maxAnisotropy: UINT = 16; comparisonFunc: TD3D12_COMPARISON_FUNC = D3D12_COMPARISON_FUNC_LESS_EQUAL; borderColor: TD3D12_STATIC_BORDER_COLOR = D3D12_STATIC_BORDER_COLOR_OPAQUE_WHITE;
            minLOD: single = 0.0; maxLOD: single = D3D12_FLOAT32_MAX; shaderVisibility: TD3D12_SHADER_VISIBILITY = D3D12_SHADER_VISIBILITY_ALL; registerSpace: UINT = 0;
            flags: TD3D12_SAMPLER_FLAGS = TD3D12_SAMPLER_FLAGS.D3D12_SAMPLER_FLAG_NONE); overload;
    end;

    { TD3DX12_ROOT_SIGNATURE_DESC }

    TD3DX12_ROOT_SIGNATURE_DESC = type helper for TD3D12_ROOT_SIGNATURE_DESC
        class function Create(o: PD3D12_ROOT_SIGNATURE_DESC = nil): PD3D12_ROOT_SIGNATURE_DESC; inline; overload; static;
        class function Create(numParameters: UINT;
        {_In_reads_opt_(numParameters) } _pParameters: PD3D12_ROOT_PARAMETER_ARRAY; numStaticSamplers: UINT = 0;
        {_In_reads_opt_(numStaticSamplers) } _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC_ARRAY = nil; flags: TD3D12_ROOT_SIGNATURE_FLAGS = D3D12_ROOT_SIGNATURE_FLAG_NONE): PD3D12_ROOT_SIGNATURE_DESC; inline; overload; static;
        procedure Init(); overload;
        procedure Init(numParameters: UINT;
        {_In_reads_opt_(numParameters) } _pParameters: PD3D12_ROOT_PARAMETER_ARRAY; numStaticSamplers: UINT = 0;
        {_In_reads_opt_(numStaticSamplers) } _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC_ARRAY = nil; flags: TD3D12_ROOT_SIGNATURE_FLAGS = D3D12_ROOT_SIGNATURE_FLAG_NONE); overload;
    end;


    { TD3DX12_ROOT_DESCRIPTOR_TABLE1 }

    TD3DX12_ROOT_DESCRIPTOR_TABLE1 = type helper for TD3D12_ROOT_DESCRIPTOR_TABLE1
        class function Create(o: PD3D12_ROOT_DESCRIPTOR_TABLE1 = nil): PD3D12_ROOT_DESCRIPTOR_TABLE1; inline; overload; static;
        class function Create(numDescriptorRanges: UINT;
        {_In_reads_opt_(numDescriptorRanges) } _pDescriptorRanges: PD3D12_DESCRIPTOR_RANGE1_ARRAY): PD3D12_ROOT_DESCRIPTOR_TABLE1; inline; overload; static;
        procedure Init(); overload;
        procedure Init(numDescriptorRanges: UINT;
        {_In_reads_opt_(numDescriptorRanges) } _pDescriptorRanges: PD3D12_DESCRIPTOR_RANGE1_ARRAY); overload;
    end;

    { TD3DX12_ROOT_DESCRIPTOR1 }

    TD3DX12_ROOT_DESCRIPTOR1 = type helper for TD3D12_ROOT_DESCRIPTOR1
        class function Create(o: PD3D12_ROOT_DESCRIPTOR1 = nil): PD3D12_ROOT_DESCRIPTOR1; inline; overload; static;
        class function Create(shaderRegister: UINT; registerSpace: UINT = 0; flags: TD3D12_ROOT_DESCRIPTOR_FLAGS = D3D12_ROOT_DESCRIPTOR_FLAG_NONE): PD3D12_ROOT_DESCRIPTOR1; inline; overload; static;
        procedure Init(); overload;
        procedure Init(shaderRegister: UINT; registerSpace: UINT = 0; flags: TD3D12_ROOT_DESCRIPTOR_FLAGS = D3D12_ROOT_DESCRIPTOR_FLAG_NONE); overload;
    end;


    { TD3DX12_VERSIONED_ROOT_SIGNATURE_DESC }

    TD3DX12_VERSIONED_ROOT_SIGNATURE_DESC = type helper for TD3D12_VERSIONED_ROOT_SIGNATURE_DESC
        class function Create(o: PD3D12_VERSIONED_ROOT_SIGNATURE_DESC = nil): PD3D12_VERSIONED_ROOT_SIGNATURE_DESC; inline; overload; static;
        class function Create(o: PD3D12_ROOT_SIGNATURE_DESC): PD3D12_VERSIONED_ROOT_SIGNATURE_DESC; inline; overload; static;
        class function Create(o: PD3D12_ROOT_SIGNATURE_DESC1): PD3D12_VERSIONED_ROOT_SIGNATURE_DESC; inline; overload; static;
        class function Create(o: PD3D12_ROOT_SIGNATURE_DESC2): PD3D12_VERSIONED_ROOT_SIGNATURE_DESC; inline; overload; static;
        class function Create(numParameters: UINT;
        {_In_reads_opt_(numParameters) } _pParameters: PD3D12_ROOT_PARAMETER_ARRAY; numStaticSamplers: UINT = 0;
        {_In_reads_opt_(numStaticSamplers) } _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC_ARRAY = nil; flags: TD3D12_ROOT_SIGNATURE_FLAGS = D3D12_ROOT_SIGNATURE_FLAG_NONE): PD3D12_VERSIONED_ROOT_SIGNATURE_DESC; overload; static;
        class function Create(numParameters: UINT;
        {_In_reads_opt_(numParameters) } _pParameters: PD3D12_ROOT_PARAMETER1_ARRAY; numStaticSamplers: UINT = 0;
        {_In_reads_opt_(numStaticSamplers) } _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC_ARRAY = nil; flags: TD3D12_ROOT_SIGNATURE_FLAGS = D3D12_ROOT_SIGNATURE_FLAG_NONE): PD3D12_VERSIONED_ROOT_SIGNATURE_DESC; overload; static;
        class function Create_1_0(numParameters: UINT;
        {_In_reads_opt_(numParameters) } _pParameters: PD3D12_ROOT_PARAMETER_ARRAY; numStaticSamplers: UINT = 0;
        {_In_reads_opt_(numStaticSamplers) } _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC_ARRAY = nil; flags: TD3D12_ROOT_SIGNATURE_FLAGS = D3D12_ROOT_SIGNATURE_FLAG_NONE): PD3D12_VERSIONED_ROOT_SIGNATURE_DESC; static;
        class function Create_1_1(numParameters: UINT;
        {_In_reads_opt_(numParameters) } _pParameters: PD3D12_ROOT_PARAMETER1_ARRAY; numStaticSamplers: UINT = 0;
        {_In_reads_opt_(numStaticSamplers) } _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC_ARRAY = nil; flags: TD3D12_ROOT_SIGNATURE_FLAGS = D3D12_ROOT_SIGNATURE_FLAG_NONE): PD3D12_VERSIONED_ROOT_SIGNATURE_DESC; static;
        class function Create_1_2(numParameters: UINT;
        {_In_reads_opt_(numParameters) } _pParameters: PD3D12_ROOT_PARAMETER1_ARRAY; numStaticSamplers: UINT = 0;
        {_In_reads_opt_(numStaticSamplers) } _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC1_ARRAY = nil; flags: TD3D12_ROOT_SIGNATURE_FLAGS = D3D12_ROOT_SIGNATURE_FLAG_NONE): PD3D12_VERSIONED_ROOT_SIGNATURE_DESC; static;

        procedure Init(); overload; inline;
        procedure Init(o: TD3D12_ROOT_SIGNATURE_DESC); overload;
        procedure Init(o: TD3D12_ROOT_SIGNATURE_DESC1); overload;
        procedure Init(o: TD3D12_ROOT_SIGNATURE_DESC2); overload;
        procedure Init(numParameters: UINT;
        {_In_reads_opt_(numParameters) } _pParameters: PD3D12_ROOT_PARAMETER_ARRAY; numStaticSamplers: UINT = 0;
        {_In_reads_opt_(numStaticSamplers) } _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC_ARRAY = nil; flags: TD3D12_ROOT_SIGNATURE_FLAGS = D3D12_ROOT_SIGNATURE_FLAG_NONE); overload;
        procedure Init(numParameters: UINT;
        {_In_reads_opt_(numParameters) } _pParameters: PD3D12_ROOT_PARAMETER1_ARRAY; numStaticSamplers: UINT = 0;
        {_In_reads_opt_(numStaticSamplers) } _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC_ARRAY = nil; flags: TD3D12_ROOT_SIGNATURE_FLAGS = D3D12_ROOT_SIGNATURE_FLAG_NONE); overload;
        procedure Init_1_0(numParameters: UINT;
        {_In_reads_opt_(numParameters) } _pParameters: PD3D12_ROOT_PARAMETER_ARRAY; numStaticSamplers: UINT = 0;
        {_In_reads_opt_(numStaticSamplers) } _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC_ARRAY = nil; flags: TD3D12_ROOT_SIGNATURE_FLAGS = D3D12_ROOT_SIGNATURE_FLAG_NONE);
        procedure Init_1_1(numParameters: UINT;
        {_In_reads_opt_(numParameters) } _pParameters: PD3D12_ROOT_PARAMETER1_ARRAY; numStaticSamplers: UINT = 0;
        {_In_reads_opt_(numStaticSamplers) } _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC_ARRAY = nil; flags: TD3D12_ROOT_SIGNATURE_FLAGS = D3D12_ROOT_SIGNATURE_FLAG_NONE);
        procedure Init_1_2(numParameters: UINT;
        {_In_reads_opt_(numParameters) } _pParameters: PD3D12_ROOT_PARAMETER1_ARRAY; numStaticSamplers: UINT = 0;
        {_In_reads_opt_(numStaticSamplers) } _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC1_ARRAY = nil; flags: TD3D12_ROOT_SIGNATURE_FLAGS = D3D12_ROOT_SIGNATURE_FLAG_NONE);

    end;


    { TD3DX12_CPU_DESCRIPTOR_HANDLE }

    TD3DX12_CPU_DESCRIPTOR_HANDLE = type helper for TD3D12_CPU_DESCRIPTOR_HANDLE
        constructor Create(const o: PD3D12_CPU_DESCRIPTOR_HANDLE); overload;
        constructor Create(constref o: TD3D12_CPU_DESCRIPTOR_HANDLE); overload;
        constructor Create(Value: TD3D12_DEFAULT); overload;
        constructor Create({_In_} const other: PD3D12_CPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32); overload;
        constructor Create({_In_} const other: PD3D12_CPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT); overload;

        constructor Create({_In_} constref other: TD3D12_CPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32); overload;
        constructor Create({_In_} constref other: TD3D12_CPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT); overload;

        function Offset(offsetInDescriptors: int32; descriptorIncrementSize: UINT): PD3D12_CPU_DESCRIPTOR_HANDLE;{$IFOPT D-} inline;{$ENDIF} overload;
        function Offset(offsetScaledByIncrementSize: int32): PD3D12_CPU_DESCRIPTOR_HANDLE;{$IFOPT D-} inline;{$ENDIF} overload;
        procedure InitOffsetted({_In_} const base: PD3D12_CPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32);{$IFOPT D-} inline;{$ENDIF} overload;
        procedure InitOffsetted({_In_} const base: PD3D12_CPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT);{$IFOPT D-} inline;{$ENDIF} overload;
        procedure InitOffsetted({_Out_} handle: PD3D12_CPU_DESCRIPTOR_HANDLE; {_In_} const base: PD3D12_CPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32);{$IFOPT D-} inline;{$ENDIF} overload;
        procedure InitOffsetted({_Out_} handle: PD3D12_CPU_DESCRIPTOR_HANDLE; {_In_} const base: PD3D12_CPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT);{$IFOPT D-} inline;{$ENDIF} overload;

        (*
        class function Create(o: PD3D12_CPU_DESCRIPTOR_HANDLE = nil): PD3D12_CPU_DESCRIPTOR_HANDLE; inline; overload; static;
        class function Create(
        {_In_ } other: PD3D12_CPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32): PD3D12_CPU_DESCRIPTOR_HANDLE; overload; static;
        class function Create(
        {_In_ } other: PD3D12_CPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT): PD3D12_CPU_DESCRIPTOR_HANDLE; overload; static;
        class function Create(offsetInDescriptors: int32; descriptorIncrementSize: UINT): PD3D12_CPU_DESCRIPTOR_HANDLE; overload; static;
        class function Create(offsetScaledByIncrementSize: int32): PD3D12_CPU_DESCRIPTOR_HANDLE; overload; static;
        class function CreateOffsetted(
        {_In_ } base: TD3D12_CPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32): PD3D12_CPU_DESCRIPTOR_HANDLE; overload; static;
        class function CreateOffsetted(
        {_In_ } base: TD3D12_CPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT): PD3D12_CPU_DESCRIPTOR_HANDLE; overload; static;


        procedure Init(); overload;
        procedure Init(
        {_In_ } other: PD3D12_CPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32); overload;
        procedure Init(
        {_In_ } other: PD3D12_CPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT);
        procedure Offset(offsetInDescriptors: int32; descriptorIncrementSize: UINT); overload;
        procedure Offset(offsetScaledByIncrementSize: int32); overload;

        procedure InitOffsetted(
        {_In_ } base: TD3D12_CPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32); overload;
        procedure InitOffsetted(
        {_In_ } base: TD3D12_CPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT); overload;
        *)
    end;

    { TD3DX12_GPU_DESCRIPTOR_HANDLE }

    TD3DX12_GPU_DESCRIPTOR_HANDLE = type helper for TD3D12_GPU_DESCRIPTOR_HANDLE
        constructor Create(const o: PD3D12_GPU_DESCRIPTOR_HANDLE); overload;
        constructor Create(constref o: TD3D12_GPU_DESCRIPTOR_HANDLE); overload;
        constructor Create(AValue: TD3D12_DEFAULT); overload;
        constructor Create({_In_} const other: PD3D12_GPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32); overload;
        constructor Create({_In_} const other: PD3D12_GPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT); overload;
         constructor Create({_In_} constref other: TD3D12_GPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32); overload;
        constructor Create({_In_} constref other: TD3D12_GPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT); overload;

        function Offset(offsetInDescriptors: INT32; descriptorIncrementSize: UINT): PD3D12_GPU_DESCRIPTOR_HANDLE; {$IFOPT D-} inline;{$ENDIF} overload;
        function Offset(offsetScaledByIncrementSize: int32): PD3D12_GPU_DESCRIPTOR_HANDLE;{$IFOPT D-} inline;{$ENDIF} overload;
        procedure InitOffsetted({_In_} const base: PD3D12_GPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32); {$IFOPT D-} inline;{$ENDIF} overload;
        procedure InitOffsetted({_In_} const base: PD3D12_GPU_DESCRIPTOR_HANDLE; offsetInDescriptors: INT32; descriptorIncrementSize: UINT); {$IFOPT D-} inline;{$ENDIF} overload;
        procedure InitOffsetted({_Out_} handle: PD3D12_GPU_DESCRIPTOR_HANDLE; {_In_} const base: PD3D12_GPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32); {$IFOPT D-} inline;{$ENDIF} overload;
        procedure InitOffsetted({_Out_}  handle: PD3D12_GPU_DESCRIPTOR_HANDLE; {_In_} const base: PD3D12_GPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: uint32); {$IFOPT D-} inline;{$ENDIF} overload;


       (* class function Create(o: PD3D12_GPU_DESCRIPTOR_HANDLE = nil): PD3D12_GPU_DESCRIPTOR_HANDLE; inline; overload; static;
        class function Create(
        {_In_ } other: PD3D12_GPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32): PD3D12_GPU_DESCRIPTOR_HANDLE; inline; overload; static;
        class function Create(
        {_In_ } other: PD3D12_GPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT): PD3D12_GPU_DESCRIPTOR_HANDLE; inline; overload; static;
        class function Create(offsetInDescriptors: int32; descriptorIncrementSize: UINT): PD3D12_GPU_DESCRIPTOR_HANDLE; inline; overload; static;
        class function Create(offsetScaledByIncrementSize: int32): PD3D12_GPU_DESCRIPTOR_HANDLE; inline; overload; static;
        class function CreateOffsetted(
        {_In_ } base: TD3D12_GPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32): PD3D12_GPU_DESCRIPTOR_HANDLE; inline; overload; static;
        class function CreateOffsetted(
        {_In_ } base: TD3D12_GPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT): PD3D12_GPU_DESCRIPTOR_HANDLE; inline; overload; static;


        procedure Init(); overload;
        procedure Init(
        {_In_ } other: PD3D12_GPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32); overload;
        procedure Init(
        {_In_ } other: PD3D12_GPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT);
        procedure Offset(offsetInDescriptors: int32; descriptorIncrementSize: UINT); overload;
        procedure Offset(offsetScaledByIncrementSize: int32); overload;
        procedure InitOffsetted(
        {_In_ } base: TD3D12_GPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32); overload;
        procedure InitOffsetted(
        {_In_ } base: TD3D12_GPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT); overload;
        *)
    end;

//------------------------------------------------------------------------------------------------
// D3D12 exports a new method for serializing root signatures in the Windows 10 Anniversary Update.
// To help enable root signature 1.1 features when they are available and not require maintaining
// two code paths for building root signatures, this helper method reconstructs a 1.0 signature when
// 1.1 is not supported.
function D3DX12SerializeVersionedRootSignature(
    {_In_ } pRootSignatureDesc: PD3D12_VERSIONED_ROOT_SIGNATURE_DESC; MaxVersion: TD3D_ROOT_SIGNATURE_VERSION;
    {_Outptr_ }  out ppBlob: ID3DBlob;
    {_Always_(_Outptr_opt_result_maybenull_) }  ppErrorBlob: PID3DBlob): HRESULT;


implementation


//------------------------------------------------------------------------------------------------
// D3D12 exports a new method for serializing root signatures in the Windows 10 Anniversary Update.
// To help enable root signature 1.1 features when they are available and not require maintaining
// two code paths for building root signatures, this helper method reconstructs a 1.0 signature when
// 1.1 is not supported.
function D3DX12SerializeVersionedRootSignature(pRootSignatureDesc: PD3D12_VERSIONED_ROOT_SIGNATURE_DESC; MaxVersion: TD3D_ROOT_SIGNATURE_VERSION; out ppBlob: ID3DBlob; ppErrorBlob: PID3DBlob): HRESULT;
var
    hr: HRESULT;
    ParametersSize: SIZE_T;
    pParameters: pointer;

    pParameters_1_0: PD3D12_ROOT_PARAMETER_ARRAY;
    n: UINT;

    table_1_1: TD3D12_ROOT_DESCRIPTOR_TABLE1;
    DescriptorRangesSize: SIZE_T;
    pDescriptorRanges: pointer;
    pDescriptorRanges_1_0: PD3D12_DESCRIPTOR_RANGE_ARRAY;
    x: UINT;
    table_1_0: TD3D12_ROOT_DESCRIPTOR_TABLE;

    pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC_ARRAY;
    SamplersSize: SIZE_T;
    desc_1_2: TD3D12_ROOT_SIGNATURE_DESC2;
    desc_1_0: TD3D12_ROOT_SIGNATURE_DESC;
    desc_1_1: TD3D12_ROOT_SIGNATURE_DESC1;

    desc: TD3D12_VERSIONED_ROOT_SIGNATURE_DESC;
begin
    if (ppErrorBlob <> nil) then
    begin
        ppErrorBlob^ := nil;
    end;

    case (MaxVersion) of

        D3D_ROOT_SIGNATURE_VERSION_1_0:
        begin
            case (pRootSignatureDesc.Version) of

                D3D_ROOT_SIGNATURE_VERSION_1_0:
                begin
                    Result := D3D12SerializeRootSignature(@pRootSignatureDesc.Desc_1_0, D3D_ROOT_SIGNATURE_VERSION_1, ppBlob, ppErrorBlob);
                    Exit;
                end;
                D3D_ROOT_SIGNATURE_VERSION_1_1
                    {$IFDEF D3D12_SDK_VERSION_609}
                    , D3D_ROOT_SIGNATURE_VERSION_1_2
                    {$ENDIF}
                    :
                begin
                    hr := S_OK;
                    desc_1_1 := pRootSignatureDesc.Desc_1_1;

                    ParametersSize := sizeof(TD3D12_ROOT_PARAMETER) * desc_1_1.NumParameters;
                    if (ParametersSize > 0) then
                        pParameters := HeapAlloc(GetProcessHeap(), 0, ParametersSize)
                    else
                        pParameters := nil;
                    if ((ParametersSize > 0) and (pParameters = nil)) then
                    begin
                        hr := E_OUTOFMEMORY;
                    end;

                    pParameters_1_0 := PD3D12_ROOT_PARAMETER_ARRAY(pParameters);

                    if (SUCCEEDED(hr)) then
                    begin
                        for n := 0 to desc_1_1.NumParameters - 1 do
                        begin
                            //__analysis_assume(ParametersSize = sizeof(TD3D12_ROOT_PARAMETER) * desc_1_1.NumParameters);
                            pParameters_1_0[n].ParameterType := desc_1_1.pParameters[n].ParameterType;
                            pParameters_1_0[n].ShaderVisibility := desc_1_1.pParameters[n].ShaderVisibility;

                            case (desc_1_1.pParameters[n].ParameterType) of

                                D3D12_ROOT_PARAMETER_TYPE_32BIT_CONSTANTS:
                                begin
                                    pParameters_1_0[n].Constants.Num32BitValues := desc_1_1.pParameters[n].Constants.Num32BitValues;
                                    pParameters_1_0[n].Constants.RegisterSpace := desc_1_1.pParameters[n].Constants.RegisterSpace;
                                    pParameters_1_0[n].Constants.ShaderRegister := desc_1_1.pParameters[n].Constants.ShaderRegister;
                                end;

                                D3D12_ROOT_PARAMETER_TYPE_CBV,
                                D3D12_ROOT_PARAMETER_TYPE_SRV,
                                D3D12_ROOT_PARAMETER_TYPE_UAV:
                                begin
                                    pParameters_1_0[n].Descriptor.RegisterSpace := desc_1_1.pParameters[n].Descriptor.RegisterSpace;
                                    pParameters_1_0[n].Descriptor.ShaderRegister := desc_1_1.pParameters[n].Descriptor.ShaderRegister;
                                end;

                                D3D12_ROOT_PARAMETER_TYPE_DESCRIPTOR_TABLE:
                                begin

                                    table_1_1 := desc_1_1.pParameters[n].DescriptorTable;

                                    DescriptorRangesSize := sizeof(TD3D12_DESCRIPTOR_RANGE) * table_1_1.NumDescriptorRanges;
                                    if (DescriptorRangesSize > 0) and (SUCCEEDED(hr)) then
                                        pDescriptorRanges := HeapAlloc(GetProcessHeap(), 0, DescriptorRangesSize)
                                    else
                                        pDescriptorRanges := nil;
                                    if (DescriptorRangesSize > 0) and (pDescriptorRanges = nil) then
                                    begin
                                        hr := E_OUTOFMEMORY;
                                    end;
                                    pDescriptorRanges_1_0 := PD3D12_DESCRIPTOR_RANGE_ARRAY(pDescriptorRanges);

                                    if (SUCCEEDED(hr)) then
                                    begin
                                        for  x := 0 to table_1_1.NumDescriptorRanges - 1 do
                                        begin
                                            // __analysis_assume(DescriptorRangesSize = sizeof(D3D12_DESCRIPTOR_RANGE) * table_1_1.NumDescriptorRanges);
                                            pDescriptorRanges_1_0[x].BaseShaderRegister := table_1_1.pDescriptorRanges[x].BaseShaderRegister;
                                            pDescriptorRanges_1_0[x].NumDescriptors := table_1_1.pDescriptorRanges[x].NumDescriptors;
                                            pDescriptorRanges_1_0[x].OffsetInDescriptorsFromTableStart := table_1_1.pDescriptorRanges[x].OffsetInDescriptorsFromTableStart;
                                            pDescriptorRanges_1_0[x].RangeType := table_1_1.pDescriptorRanges[x].RangeType;
                                            pDescriptorRanges_1_0[x].RegisterSpace := table_1_1.pDescriptorRanges[x].RegisterSpace;
                                        end;
                                    end;

                                    table_1_0 := pParameters_1_0[n].DescriptorTable;
                                    table_1_0.NumDescriptorRanges := table_1_1.NumDescriptorRanges;
                                    table_1_0.pDescriptorRanges := pDescriptorRanges_1_0;
                                end;
                            end;
                        end;
                    end;

                    pStaticSamplers := nil;
                    {$IFDEF D3D12_SDK_VERSION_609}
                    if (desc_1_1.NumStaticSamplers > 0) and (pRootSignatureDesc.Version = D3D_ROOT_SIGNATURE_VERSION_1_2) then
                    begin
                        SamplersSize := sizeof(TD3D12_STATIC_SAMPLER_DESC) * desc_1_1.NumStaticSamplers;
                        pStaticSamplers := PD3D12_STATIC_SAMPLER_DESC_ARRAY(HeapAlloc(GetProcessHeap(), 0, SamplersSize));

                        if (pStaticSamplers = nil) then
                        begin
                            hr := E_OUTOFMEMORY;
                        end
                        else
                        begin
                            desc_1_2 := pRootSignatureDesc.Desc_1_2;
                            for n := 0 to desc_1_1.NumStaticSamplers - 1 do
                            begin
                                if ((Ord(desc_1_2.pStaticSamplers[n].Flags) and not Ord(D3D12_SAMPLER_FLAG_UINT_BORDER_COLOR)) <> 0) then
                                begin
                                    hr := E_INVALIDARG;
                                    break;
                                end;
                                Move(desc_1_2.pStaticSamplers[n], pStaticSamplers[n], sizeof(TD3D12_STATIC_SAMPLER_DESC));

                            end;
                        end;
                    end;
                    {$ENDIF}

                    if (SUCCEEDED(hr)) then
                    begin

                        if pStaticSamplers = nil then
                            desc_1_0.init(desc_1_1.NumParameters, pParameters_1_0, desc_1_1.NumStaticSamplers, desc_1_1.pStaticSamplers, desc_1_1.Flags)
                        else
                            desc_1_0.init(desc_1_1.NumParameters, pParameters_1_0, desc_1_1.NumStaticSamplers, pStaticSamplers, desc_1_1.Flags);
                        hr := D3D12SerializeRootSignature(@desc_1_0, D3D_ROOT_SIGNATURE_VERSION_1, ppBlob, ppErrorBlob);
                    end;

                    if (pParameters <> nil) then
                    begin
                        for n := 0 to desc_1_1.NumParameters - 1 do
                        begin
                            if (desc_1_1.pParameters[n].ParameterType = D3D12_ROOT_PARAMETER_TYPE_DESCRIPTOR_TABLE) then
                            begin
                                pDescriptorRanges_1_0 := pParameters_1_0[n].DescriptorTable.pDescriptorRanges;
                                HeapFree(GetProcessHeap(), 0, pointer(PD3D12_DESCRIPTOR_RANGE(pDescriptorRanges_1_0)));
                            end;
                        end;
                        HeapFree(GetProcessHeap(), 0, pParameters);
                    end;

                    if (pStaticSamplers <> nil) then
                    begin
                        HeapFree(GetProcessHeap(), 0, pStaticSamplers);
                    end;

                    Result := hr;
                    Exit;
                end;

            end;

        end;

        D3D_ROOT_SIGNATURE_VERSION_1_1:
        begin
            case (pRootSignatureDesc.Version) of
                D3D_ROOT_SIGNATURE_VERSION_1_0,
                D3D_ROOT_SIGNATURE_VERSION_1_1:
                begin
                    Result := D3D12SerializeVersionedRootSignature(pRootSignatureDesc, ppBlob, ppErrorBlob);
                    Exit;
                end;

                {$IFDEF D3D12_SDK_VERSION_609}
                D3D_ROOT_SIGNATURE_VERSION_1_2:
                begin
                    hr := S_OK;
                    desc_1_1 := pRootSignatureDesc.Desc_1_1;
                    pStaticSamplers := nil;
                    if (desc_1_1.NumStaticSamplers > 0) then
                    begin
                        SamplersSize := sizeof(TD3D12_STATIC_SAMPLER_DESC) * desc_1_1.NumStaticSamplers;
                        pStaticSamplers := PD3D12_STATIC_SAMPLER_DESC_ARRAY(HeapAlloc(GetProcessHeap(), 0, SamplersSize));

                        if (pStaticSamplers = nil) then
                        begin
                            hr := E_OUTOFMEMORY;
                        end
                        else
                        begin
                            desc_1_2 := pRootSignatureDesc.Desc_1_2;
                            for  n := 0 to desc_1_1.NumStaticSamplers - 1 do
                            begin
                                if ((Ord(desc_1_2.pStaticSamplers[n].Flags) and not Ord(D3D12_SAMPLER_FLAG_UINT_BORDER_COLOR)) <> 0) then
                                begin
                                    hr := E_INVALIDARG;
                                    break;
                                end;
                                Move(desc_1_2.pStaticSamplers[n], pStaticSamplers[n], sizeof(TD3D12_STATIC_SAMPLER_DESC));
                            end;
                        end;
                    end;

                    if (SUCCEEDED(hr)) then
                    begin
                        if pStaticSamplers = nil then
                            desc.init(desc_1_1.NumParameters, desc_1_1.pParameters, desc_1_1.NumStaticSamplers, desc_1_1.pStaticSamplers, desc_1_1.Flags)
                        else
                            desc.init(desc_1_1.NumParameters, desc_1_1.pParameters, desc_1_1.NumStaticSamplers, pStaticSamplers, desc_1_1.Flags);
                        hr := D3D12SerializeVersionedRootSignature(@desc, ppBlob, ppErrorBlob);
                    end;

                    if (pStaticSamplers <> nil) then
                    begin
                        HeapFree(GetProcessHeap(), 0, pStaticSamplers);
                    end;

                    Result := hr;
                    Exit;
                end;
                {$ENDIF}
            end;
        end;

        {$IFDEF D3D12_SDK_VERSION_609}
        D3D_ROOT_SIGNATURE_VERSION_1_2:
        begin
            Result := D3D12SerializeVersionedRootSignature(pRootSignatureDesc, ppBlob, ppErrorBlob);
            Exit;
        end;
        {$ENDIF}
        else
        begin
            Result := D3D12SerializeVersionedRootSignature(pRootSignatureDesc, ppBlob, ppErrorBlob);
            Exit;
        end;
    end;
    Result := E_INVALIDARG;
end;

{ TD3DX12_DESCRIPTOR_RANGE }

class function TD3DX12_DESCRIPTOR_RANGE.Create(o: PD3D12_DESCRIPTOR_RANGE): PD3D12_DESCRIPTOR_RANGE;
begin
    new(Result);
    if o <> nil then
        Result^ := o^
    else
        Result^.Init();
end;



class function TD3DX12_DESCRIPTOR_RANGE.Create(numDescriptors: UINT; baseShaderRegister: UINT; registerSpace: UINT; offsetInDescriptorsFromTableStart: UINT): PD3D12_DESCRIPTOR_RANGE;
begin
    new(Result);
    Result^.Init(numDescriptors, baseShaderRegister, registerSpace, offsetInDescriptorsFromTableStart);
end;



procedure TD3DX12_DESCRIPTOR_RANGE.Init();
begin
    ZeroMemory(@self, SizeOf(TD3D12_DESCRIPTOR_RANGE));
end;



procedure TD3DX12_DESCRIPTOR_RANGE.Init(numDescriptors: UINT; baseShaderRegister: UINT; registerSpace: UINT; offsetInDescriptorsFromTableStart: UINT);
begin
    self.RangeType := rangeType;
    self.NumDescriptors := numDescriptors;
    self.BaseShaderRegister := baseShaderRegister;
    self.RegisterSpace := registerSpace;
    self.OffsetInDescriptorsFromTableStart := offsetInDescriptorsFromTableStart;
end;

{ TD3DX12_ROOT_DESCRIPTOR_TABLE }

class function TD3DX12_ROOT_DESCRIPTOR_TABLE.Create(o: PD3D12_ROOT_DESCRIPTOR_TABLE): PD3D12_ROOT_DESCRIPTOR_TABLE;
begin
    new(Result);
    if o <> nil then
        Result^ := o^
    else
        Result^.Init();
end;



class function TD3DX12_ROOT_DESCRIPTOR_TABLE.Create(numDescriptorRanges: UINT; _pDescriptorRanges: PD3D12_DESCRIPTOR_RANGE_ARRAY): PD3D12_ROOT_DESCRIPTOR_TABLE;
begin
    new(Result);
    Result^.Init(numDescriptorRanges, _pDescriptorRanges);
end;



procedure TD3DX12_ROOT_DESCRIPTOR_TABLE.Init();
begin
    ZeroMemory(@self, SizeOf(TD3D12_ROOT_DESCRIPTOR_TABLE));
end;



procedure TD3DX12_ROOT_DESCRIPTOR_TABLE.Init(numDescriptorRanges: UINT; _pDescriptorRanges: PD3D12_DESCRIPTOR_RANGE_ARRAY);
begin
    self.NumDescriptorRanges := numDescriptorRanges;
    self.pDescriptorRanges := _pDescriptorRanges;
end;

{ TD3DX12_ROOT_CONSTANTS }

class function TD3DX12_ROOT_CONSTANTS.Create(o: PD3D12_ROOT_CONSTANTS): PD3D12_ROOT_CONSTANTS;
begin
    new(Result);
    if o <> nil then
        Result^ := o^
    else
        Result^.Init();
end;



class function TD3DX12_ROOT_CONSTANTS.Create(num32BitValues: UINT; shaderRegister: UINT; registerSpace: UINT): PD3D12_ROOT_CONSTANTS;
begin
    new(Result);
    Result^.Init(num32BitValues, shaderRegister, registerSpace);
end;



procedure TD3DX12_ROOT_CONSTANTS.Init();
begin
    ShaderRegister := 0;
    RegisterSpace := 0;
    Num32BitValues := 0;
end;



procedure TD3DX12_ROOT_CONSTANTS.Init(num32BitValues: UINT; shaderRegister: UINT; registerSpace: UINT);
begin
    self.Num32BitValues := num32BitValues;
    self.ShaderRegister := shaderRegister;
    self.RegisterSpace := registerSpace;
end;



class function TD3DX12_ROOT_DESCRIPTOR.Create(o: PD3D12_ROOT_DESCRIPTOR): PD3D12_ROOT_DESCRIPTOR;
begin
    new(Result);
    if o <> nil then
        Result^ := o^
    else
        Result^.Init();
end;



class function TD3DX12_ROOT_DESCRIPTOR.Create(shaderRegister: UINT; registerSpace: UINT): PD3D12_ROOT_DESCRIPTOR;
begin
    new(Result);
    Result^.Init(shaderRegister, registerSpace);
end;



procedure TD3DX12_ROOT_DESCRIPTOR.Init();
begin
    ShaderRegister := 0;
    RegisterSpace := 0;
end;



procedure TD3DX12_ROOT_DESCRIPTOR.Init(shaderRegister: UINT; registerSpace: UINT);
begin
    self.ShaderRegister := shaderRegister;
    self.RegisterSpace := registerSpace;
end;

{ TD3DX12_ROOT_PARAMETER }

class function TD3DX12_ROOT_PARAMETER.Create(o: PD3D12_ROOT_PARAMETER): PD3D12_ROOT_PARAMETER;
begin
    new(Result);
    if o <> nil then
        Result^ := o^
    else
        Result^.Init();
end;



class function TD3DX12_ROOT_PARAMETER.CreateAsDescriptorTable(numDescriptorRanges: UINT; pDescriptorRanges: PD3D12_DESCRIPTOR_RANGE_ARRAY; visibility: TD3D12_SHADER_VISIBILITY): PD3D12_ROOT_PARAMETER;
begin
    new(Result);
    Result^.InitAsDescriptorTable(numDescriptorRanges, pDescriptorRanges, visibility);
end;



class function TD3DX12_ROOT_PARAMETER.CreateAsConstants(num32BitValues: UINT; shaderRegister: UINT; registerSpace: UINT; visibility: TD3D12_SHADER_VISIBILITY): PD3D12_ROOT_PARAMETER;
begin
    new(Result);
    Result^.InitAsConstants(num32BitValues, shaderRegister, registerSpace, visibility);
end;



class function TD3DX12_ROOT_PARAMETER.CreateAsConstantBufferView(shaderRegister: UINT; registerSpace: UINT; visibility: TD3D12_SHADER_VISIBILITY): PD3D12_ROOT_PARAMETER;
begin
    new(Result);
    Result^.InitAsConstantBufferView(shaderRegister, registerSpace, visibility);
end;



class function TD3DX12_ROOT_PARAMETER.CreateAsShaderResourceView(shaderRegister: UINT; registerSpace: UINT; visibility: TD3D12_SHADER_VISIBILITY): PD3D12_ROOT_PARAMETER;
begin
    new(Result);
    Result^.InitAsShaderResourceView(shaderRegister, registerSpace, visibility);
end;



class function TD3DX12_ROOT_PARAMETER.CreateAsUnorderedAccessView(shaderRegister: UINT; registerSpace: UINT; visibility: TD3D12_SHADER_VISIBILITY): PD3D12_ROOT_PARAMETER;
begin
    new(Result);
    Result^.InitAsUnorderedAccessView(shaderRegister, registerSpace, visibility);
end;



procedure TD3DX12_ROOT_PARAMETER.Init();
begin
    ZeroMemory(@self, SizeOf(TD3D12_ROOT_PARAMETER));
end;



procedure TD3DX12_ROOT_PARAMETER.InitAsDescriptorTable(numDescriptorRanges: UINT; pDescriptorRanges: PD3D12_DESCRIPTOR_RANGE_ARRAY; visibility: TD3D12_SHADER_VISIBILITY);
begin
    self.ParameterType := D3D12_ROOT_PARAMETER_TYPE_DESCRIPTOR_TABLE;
    self.ShaderVisibility := visibility;
    self.DescriptorTable.Init(numDescriptorRanges, pDescriptorRanges);
end;



procedure TD3DX12_ROOT_PARAMETER.InitAsConstants(num32BitValues: UINT; shaderRegister: UINT; registerSpace: UINT; visibility: TD3D12_SHADER_VISIBILITY);
begin
    self.ParameterType := D3D12_ROOT_PARAMETER_TYPE_32BIT_CONSTANTS;
    self.ShaderVisibility := visibility;
    self.Constants.Init(num32BitValues, shaderRegister, registerSpace);
end;



procedure TD3DX12_ROOT_PARAMETER.InitAsConstantBufferView(shaderRegister: UINT; registerSpace: UINT; visibility: TD3D12_SHADER_VISIBILITY);
begin
    self.ParameterType := D3D12_ROOT_PARAMETER_TYPE_CBV;
    self.ShaderVisibility := visibility;
    self.Descriptor.Init(shaderRegister, registerSpace);
end;



procedure TD3DX12_ROOT_PARAMETER.InitAsShaderResourceView(shaderRegister: UINT; registerSpace: UINT; visibility: TD3D12_SHADER_VISIBILITY);
begin
    self.ParameterType := D3D12_ROOT_PARAMETER_TYPE_SRV;
    self.ShaderVisibility := visibility;
    self.Descriptor.Init(shaderRegister, registerSpace);
end;



procedure TD3DX12_ROOT_PARAMETER.InitAsUnorderedAccessView(shaderRegister: UINT; registerSpace: UINT; visibility: TD3D12_SHADER_VISIBILITY);
begin
    self.ParameterType := D3D12_ROOT_PARAMETER_TYPE_UAV;
    self.ShaderVisibility := visibility;
    self.Descriptor.Init(shaderRegister, registerSpace);
end;

{ TD3DX12_STATIC_SAMPLER_DESC }

class function TD3DX12_STATIC_SAMPLER_DESC.Create(o: PD3D12_STATIC_SAMPLER_DESC): PD3D12_STATIC_SAMPLER_DESC;
begin
    new(Result);
    if o <> nil then
        Result^ := o^
    else
        Result^.Init();
end;



class function TD3DX12_STATIC_SAMPLER_DESC.Create(shaderRegister: UINT; filter: TD3D12_FILTER; addressU: TD3D12_TEXTURE_ADDRESS_MODE; addressV: TD3D12_TEXTURE_ADDRESS_MODE;
    addressW: TD3D12_TEXTURE_ADDRESS_MODE; mipLODBias: single; maxAnisotropy: UINT; comparisonFunc: TD3D12_COMPARISON_FUNC; borderColor: TD3D12_STATIC_BORDER_COLOR; minLOD: single; maxLOD: single;
    shaderVisibility: TD3D12_SHADER_VISIBILITY; registerSpace: UINT): PD3D12_STATIC_SAMPLER_DESC;
begin
    new(Result);
    Result^.Init(shaderRegister, filter, addressU, addressV, addressW, mipLODBias, maxAnisotropy, comparisonFunc, borderColor, minLOD, maxLOD, shaderVisibility, registerSpace);
end;



procedure TD3DX12_STATIC_SAMPLER_DESC.Init();
begin
    ZeroMemory(@self, SizeOf(TD3D12_STATIC_SAMPLER_DESC));
end;



procedure TD3DX12_STATIC_SAMPLER_DESC.Init(shaderRegister: UINT; filter: TD3D12_FILTER; addressU: TD3D12_TEXTURE_ADDRESS_MODE; addressV: TD3D12_TEXTURE_ADDRESS_MODE; addressW: TD3D12_TEXTURE_ADDRESS_MODE;
    mipLODBias: single; maxAnisotropy: UINT; comparisonFunc: TD3D12_COMPARISON_FUNC; borderColor: TD3D12_STATIC_BORDER_COLOR; minLOD: single; maxLOD: single; shaderVisibility: TD3D12_SHADER_VISIBILITY; registerSpace: UINT);
begin
    self.ShaderRegister := shaderRegister;
    self.Filter := filter;
    self.AddressU := addressU;
    self.AddressV := addressV;
    self.AddressW := addressW;
    self.MipLODBias := mipLODBias;
    self.MaxAnisotropy := maxAnisotropy;
    self.ComparisonFunc := comparisonFunc;
    self.BorderColor := borderColor;
    self.MinLOD := minLOD;
    self.MaxLOD := maxLOD;
    self.ShaderVisibility := shaderVisibility;
    self.RegisterSpace := registerSpace;
end;

{ TD3DX12_STATIC_SAMPLER_DESC1 }

class function TD3DX12_STATIC_SAMPLER_DESC1.Create(o: PD3D12_STATIC_SAMPLER_DESC1): PD3D12_STATIC_SAMPLER_DESC1;
begin
    new(Result);
    if o <> nil then
        Result^ := o^
    else
        Result^.Init();
end;



class function TD3DX12_STATIC_SAMPLER_DESC1.Create(o: PD3D12_STATIC_SAMPLER_DESC): PD3D12_STATIC_SAMPLER_DESC1;
begin
    new(Result);
    if o <> nil then
    begin
        Result^.Filter := o^.Filter;
        Result^.AddressU := o^.AddressU;
        Result^.AddressV := o^.AddressV;
        Result^.AddressW := o^.AddressW;
        Result^.MipLODBias := o^.MipLODBias;
        Result^.MaxAnisotropy := o^.MaxAnisotropy;
        Result^.ComparisonFunc := o^.ComparisonFunc;
        Result^.BorderColor := o^.BorderColor;
        Result^.MinLOD := o^.MinLOD;
        Result^.MaxLOD := o^.MaxLOD;
        Result^.ShaderRegister := o^.ShaderRegister;
        Result^.RegisterSpace := o^.RegisterSpace;
        Result^.ShaderVisibility := o^.ShaderVisibility;

        Result^.Flags := TD3D12_SAMPLER_FLAGS.D3D12_SAMPLER_FLAG_NONE;
    end
    else
        Result^.Init();
end;



class function TD3DX12_STATIC_SAMPLER_DESC1.Create(shaderRegister: UINT; filter: TD3D12_FILTER; addressU: TD3D12_TEXTURE_ADDRESS_MODE; addressV: TD3D12_TEXTURE_ADDRESS_MODE;
    addressW: TD3D12_TEXTURE_ADDRESS_MODE; mipLODBias: single; maxAnisotropy: UINT; comparisonFunc: TD3D12_COMPARISON_FUNC; borderColor: TD3D12_STATIC_BORDER_COLOR; minLOD: single; maxLOD: single;
    shaderVisibility: TD3D12_SHADER_VISIBILITY; registerSpace: UINT; flags: TD3D12_SAMPLER_FLAGS): PD3D12_STATIC_SAMPLER_DESC1;
begin
    new(Result);
    Result^.Init(shaderRegister, filter, addressU, addressV, addressW, mipLODBias, maxAnisotropy, comparisonFunc, borderColor, minLOD, maxLOD, shaderVisibility, registerSpace, flags);
end;



procedure TD3DX12_STATIC_SAMPLER_DESC1.Init();
begin
    ZeroMemory(@self, SizeOf(TD3D12_STATIC_SAMPLER_DESC1));
end;



procedure TD3DX12_STATIC_SAMPLER_DESC1.Init(shaderRegister: UINT; filter: TD3D12_FILTER; addressU: TD3D12_TEXTURE_ADDRESS_MODE; addressV: TD3D12_TEXTURE_ADDRESS_MODE; addressW: TD3D12_TEXTURE_ADDRESS_MODE;
    mipLODBias: single; maxAnisotropy: UINT; comparisonFunc: TD3D12_COMPARISON_FUNC; borderColor: TD3D12_STATIC_BORDER_COLOR; minLOD: single; maxLOD: single; shaderVisibility: TD3D12_SHADER_VISIBILITY;
    registerSpace: UINT; flags: TD3D12_SAMPLER_FLAGS);
begin
    self.ShaderRegister := shaderRegister;
    self.Filter := filter;
    self.AddressU := addressU;
    self.AddressV := addressV;
    self.AddressW := addressW;
    self.MipLODBias := mipLODBias;
    self.MaxAnisotropy := maxAnisotropy;
    self.ComparisonFunc := comparisonFunc;
    self.BorderColor := borderColor;
    self.MinLOD := minLOD;
    self.MaxLOD := maxLOD;
    self.ShaderVisibility := shaderVisibility;
    self.RegisterSpace := registerSpace;
    self.Flags := flags;
end;

{ TD3DX12_ROOT_SIGNATURE_DESC }

class function TD3DX12_ROOT_SIGNATURE_DESC.Create(o: PD3D12_ROOT_SIGNATURE_DESC): PD3D12_ROOT_SIGNATURE_DESC;
begin
    new(Result);
    if o <> nil then
        Result^ := o^
    else
        Result^.Init();
end;



class function TD3DX12_ROOT_SIGNATURE_DESC.Create(numParameters: UINT; _pParameters: PD3D12_ROOT_PARAMETER_ARRAY; numStaticSamplers: UINT; _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC_ARRAY;
    flags: TD3D12_ROOT_SIGNATURE_FLAGS): PD3D12_ROOT_SIGNATURE_DESC;
begin
    new(Result);
    Result^.Init(numParameters, _pParameters, numStaticSamplers, _pStaticSamplers, flags);
end;



procedure TD3DX12_ROOT_SIGNATURE_DESC.Init();
begin
    Self.NumParameters := 0;
    self.pParameters := nil;
    self.NumStaticSamplers := 0;
    self.pStaticSamplers := nil;
    self.Flags := D3D12_ROOT_SIGNATURE_FLAG_NONE;
end;



procedure TD3DX12_ROOT_SIGNATURE_DESC.Init(numParameters: UINT; _pParameters: PD3D12_ROOT_PARAMETER_ARRAY; numStaticSamplers: UINT; _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC_ARRAY; flags: TD3D12_ROOT_SIGNATURE_FLAGS);
begin
    self.NumParameters := numParameters;
    self.pParameters := _pParameters;
    self.NumStaticSamplers := numStaticSamplers;
    self.pStaticSamplers := _pStaticSamplers;
    self.Flags := flags;
end;



{ TD3DX12_ROOT_DESCRIPTOR_TABLE1 }

class function TD3DX12_ROOT_DESCRIPTOR_TABLE1.Create(o: PD3D12_ROOT_DESCRIPTOR_TABLE1): PD3D12_ROOT_DESCRIPTOR_TABLE1;
begin
    new(Result);
    if o <> nil then
        Result^ := o^
    else
        Result^.Init();
end;



class function TD3DX12_ROOT_DESCRIPTOR_TABLE1.Create(numDescriptorRanges: UINT; _pDescriptorRanges: PD3D12_DESCRIPTOR_RANGE1_ARRAY): PD3D12_ROOT_DESCRIPTOR_TABLE1;
begin
    new(Result);
    Result^.Init(numDescriptorRanges, _pDescriptorRanges);
end;



procedure TD3DX12_ROOT_DESCRIPTOR_TABLE1.Init();
begin
    self.NumDescriptorRanges := 0;
    self.pDescriptorRanges := nil;
end;



procedure TD3DX12_ROOT_DESCRIPTOR_TABLE1.Init(numDescriptorRanges: UINT; _pDescriptorRanges: PD3D12_DESCRIPTOR_RANGE1_ARRAY);
begin
    self.NumDescriptorRanges := numDescriptorRanges;
    self.pDescriptorRanges := _pDescriptorRanges;
end;

{ TD3DX12_ROOT_DESCRIPTOR1 }

class function TD3DX12_ROOT_DESCRIPTOR1.Create(o: PD3D12_ROOT_DESCRIPTOR1): PD3D12_ROOT_DESCRIPTOR1;
begin
    new(Result);
    if o <> nil then
        Result^ := o^
    else
        Result^.Init();
end;



class function TD3DX12_ROOT_DESCRIPTOR1.Create(shaderRegister: UINT; registerSpace: UINT; flags: TD3D12_ROOT_DESCRIPTOR_FLAGS): PD3D12_ROOT_DESCRIPTOR1;
begin
    new(Result);
    Result^.Init(shaderRegister, registerSpace, flags);
end;



procedure TD3DX12_ROOT_DESCRIPTOR1.Init();
begin
    self.ShaderRegister := 0;
    self.RegisterSpace := 0;
    self.Flags := D3D12_ROOT_DESCRIPTOR_FLAG_NONE;
end;



procedure TD3DX12_ROOT_DESCRIPTOR1.Init(shaderRegister: UINT; registerSpace: UINT; flags: TD3D12_ROOT_DESCRIPTOR_FLAGS);
begin
    self.ShaderRegister := shaderRegister;
    self.RegisterSpace := registerSpace;
    self.Flags := flags;
end;


{ TD3DX12_VERSIONED_ROOT_SIGNATURE_DESC }

class function TD3DX12_VERSIONED_ROOT_SIGNATURE_DESC.Create(o: PD3D12_VERSIONED_ROOT_SIGNATURE_DESC): PD3D12_VERSIONED_ROOT_SIGNATURE_DESC;
begin
    new(Result);
    if o <> nil then
        Result^ := o^
    else
        Result^.Init();
end;



class function TD3DX12_VERSIONED_ROOT_SIGNATURE_DESC.Create(o: PD3D12_ROOT_SIGNATURE_DESC): PD3D12_VERSIONED_ROOT_SIGNATURE_DESC;
begin
    new(Result);
    Result^.Init(o^);
end;



class function TD3DX12_VERSIONED_ROOT_SIGNATURE_DESC.Create(o: PD3D12_ROOT_SIGNATURE_DESC1): PD3D12_VERSIONED_ROOT_SIGNATURE_DESC;
begin
    new(Result);
    Result^.Init(o^);
end;



class function TD3DX12_VERSIONED_ROOT_SIGNATURE_DESC.Create(o: PD3D12_ROOT_SIGNATURE_DESC2): PD3D12_VERSIONED_ROOT_SIGNATURE_DESC;
begin
    new(Result);
    Result^.Init(o^);
end;



procedure TD3DX12_VERSIONED_ROOT_SIGNATURE_DESC.Init();
begin
    self.Init_1_1(0, nil, 0, nil, D3D12_ROOT_SIGNATURE_FLAG_NONE);
end;



procedure TD3DX12_VERSIONED_ROOT_SIGNATURE_DESC.Init(o: TD3D12_ROOT_SIGNATURE_DESC);
begin
    self.Version := D3D_ROOT_SIGNATURE_VERSION_1_0;
    self.Desc_1_0 := o;
end;



procedure TD3DX12_VERSIONED_ROOT_SIGNATURE_DESC.Init(o: TD3D12_ROOT_SIGNATURE_DESC1);
begin
    self.Version := D3D_ROOT_SIGNATURE_VERSION_1_1;
    self.Desc_1_1 := o;
end;



procedure TD3DX12_VERSIONED_ROOT_SIGNATURE_DESC.Init(o: TD3D12_ROOT_SIGNATURE_DESC2);
begin
    self.Version := D3D_ROOT_SIGNATURE_VERSION_1_2;
    self.Desc_1_2 := o;
end;



procedure TD3DX12_VERSIONED_ROOT_SIGNATURE_DESC.Init(numParameters: UINT; _pParameters: PD3D12_ROOT_PARAMETER_ARRAY; numStaticSamplers: UINT; _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC_ARRAY; flags: TD3D12_ROOT_SIGNATURE_FLAGS);
begin
    Init_1_0(numParameters, _pParameters, numStaticSamplers, _pStaticSamplers, flags);
end;



procedure TD3DX12_VERSIONED_ROOT_SIGNATURE_DESC.Init(numParameters: UINT; _pParameters: PD3D12_ROOT_PARAMETER1_ARRAY; numStaticSamplers: UINT; _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC_ARRAY; flags: TD3D12_ROOT_SIGNATURE_FLAGS);
begin
    Init_1_1(numParameters, _pParameters, numStaticSamplers, _pStaticSamplers, flags);
end;



procedure TD3DX12_VERSIONED_ROOT_SIGNATURE_DESC.Init_1_0(numParameters: UINT; _pParameters: PD3D12_ROOT_PARAMETER_ARRAY; numStaticSamplers: UINT; _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC_ARRAY; flags: TD3D12_ROOT_SIGNATURE_FLAGS);
begin
    self.Version := D3D_ROOT_SIGNATURE_VERSION_1_0;
    self.Desc_1_0.NumParameters := numParameters;
    self.Desc_1_0.pParameters := _pParameters;
    self.Desc_1_0.NumStaticSamplers := numStaticSamplers;
    self.Desc_1_0.pStaticSamplers := _pStaticSamplers;
    self.Desc_1_0.Flags := flags;
end;



procedure TD3DX12_VERSIONED_ROOT_SIGNATURE_DESC.Init_1_1(numParameters: UINT; _pParameters: PD3D12_ROOT_PARAMETER1_ARRAY; numStaticSamplers: UINT; _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC_ARRAY; flags: TD3D12_ROOT_SIGNATURE_FLAGS);
begin
    self.Version := D3D_ROOT_SIGNATURE_VERSION_1_1;
    self.Desc_1_1.NumParameters := numParameters;
    self.Desc_1_1.pParameters := _pParameters;
    self.Desc_1_1.NumStaticSamplers := numStaticSamplers;
    self.Desc_1_1.pStaticSamplers := _pStaticSamplers;
    self.Desc_1_1.Flags := flags;
end;



procedure TD3DX12_VERSIONED_ROOT_SIGNATURE_DESC.Init_1_2(numParameters: UINT; _pParameters: PD3D12_ROOT_PARAMETER1_ARRAY; numStaticSamplers: UINT; _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC1_ARRAY; flags: TD3D12_ROOT_SIGNATURE_FLAGS);
begin
    self.Version := D3D_ROOT_SIGNATURE_VERSION_1_2;
    self.Desc_1_2.NumParameters := numParameters;
    self.Desc_1_2.pParameters := _pParameters;
    self.Desc_1_2.NumStaticSamplers := numStaticSamplers;
    self.Desc_1_2.pStaticSamplers := _pStaticSamplers;
    self.Desc_1_2.Flags := flags;
end;



class function TD3DX12_VERSIONED_ROOT_SIGNATURE_DESC.Create(numParameters: UINT; _pParameters: PD3D12_ROOT_PARAMETER_ARRAY; numStaticSamplers: UINT; _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC_ARRAY;
    flags: TD3D12_ROOT_SIGNATURE_FLAGS): PD3D12_VERSIONED_ROOT_SIGNATURE_DESC;
begin
    New(Result);
    Result^.Init_1_0(numParameters, _pParameters, numStaticSamplers, _pStaticSamplers, flags);
end;



class function TD3DX12_VERSIONED_ROOT_SIGNATURE_DESC.Create(numParameters: UINT; _pParameters: PD3D12_ROOT_PARAMETER1_ARRAY; numStaticSamplers: UINT; _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC_ARRAY;
    flags: TD3D12_ROOT_SIGNATURE_FLAGS): PD3D12_VERSIONED_ROOT_SIGNATURE_DESC;
begin
    new(Result);
    Result^.Init(numParameters, _pParameters, numStaticSamplers, _pStaticSamplers, flags);
end;



class function TD3DX12_VERSIONED_ROOT_SIGNATURE_DESC.Create_1_0(numParameters: UINT; _pParameters: PD3D12_ROOT_PARAMETER_ARRAY; numStaticSamplers: UINT; _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC_ARRAY;
    flags: TD3D12_ROOT_SIGNATURE_FLAGS): PD3D12_VERSIONED_ROOT_SIGNATURE_DESC;
begin
    new(Result);
    Result^.Init_1_0(numParameters, _pParameters, numStaticSamplers, _pStaticSamplers, flags);
end;



class function TD3DX12_VERSIONED_ROOT_SIGNATURE_DESC.Create_1_1(numParameters: UINT; _pParameters: PD3D12_ROOT_PARAMETER1_ARRAY; numStaticSamplers: UINT; _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC_ARRAY;
    flags: TD3D12_ROOT_SIGNATURE_FLAGS): PD3D12_VERSIONED_ROOT_SIGNATURE_DESC;
begin
    new(Result);
    Result^.Init_1_1(numParameters, _pParameters, numStaticSamplers, _pStaticSamplers, flags);
end;



class function TD3DX12_VERSIONED_ROOT_SIGNATURE_DESC.Create_1_2(numParameters: UINT; _pParameters: PD3D12_ROOT_PARAMETER1_ARRAY; numStaticSamplers: UINT; _pStaticSamplers: PD3D12_STATIC_SAMPLER_DESC1_ARRAY;
    flags: TD3D12_ROOT_SIGNATURE_FLAGS): PD3D12_VERSIONED_ROOT_SIGNATURE_DESC;
begin
    new(Result);
    Result^.Init_1_2(numParameters, _pParameters, numStaticSamplers, _pStaticSamplers, flags);
end;

{ TD3DX12_CPU_DESCRIPTOR_HANDLE }

(*
procedure TD3DX12_CPU_DESCRIPTOR_HANDLE.Init(other: PD3D12_CPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32);
begin
    InitOffsetted(other^, offsetScaledByIncrementSize);
end;



procedure TD3DX12_CPU_DESCRIPTOR_HANDLE.Init(other: PD3D12_CPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT);
begin
    InitOffsetted(other^, offsetInDescriptors, descriptorIncrementSize);
end;



procedure TD3DX12_CPU_DESCRIPTOR_HANDLE.Offset(offsetInDescriptors: int32; descriptorIncrementSize: UINT);
begin
    self.ptr := SIZE_T(int64(self.ptr) + int64(offsetInDescriptors) * int64(descriptorIncrementSize));
end;



procedure TD3DX12_CPU_DESCRIPTOR_HANDLE.Offset(offsetScaledByIncrementSize: int32);
begin
    self.ptr := SIZE_T(int64(self.ptr) + int64(offsetScaledByIncrementSize));
end;



procedure TD3DX12_CPU_DESCRIPTOR_HANDLE.InitOffsetted(base: TD3D12_CPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32);
begin
    self.ptr := SIZE_T(int64(base.ptr) + int64(offsetScaledByIncrementSize));
end;



procedure TD3DX12_CPU_DESCRIPTOR_HANDLE.InitOffsetted(base: TD3D12_CPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT);
begin
    self.ptr := SIZE_T(int64(base.ptr) + int64(offsetInDescriptors) * int64(descriptorIncrementSize));
end;



class function TD3DX12_CPU_DESCRIPTOR_HANDLE.Create(o: PD3D12_CPU_DESCRIPTOR_HANDLE): PD3D12_CPU_DESCRIPTOR_HANDLE;
begin
    new(Result);
    if o <> nil then
        Result^ := o^
    else
        Result^.Init();
end;



class function TD3DX12_CPU_DESCRIPTOR_HANDLE.Create(other: PD3D12_CPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32): PD3D12_CPU_DESCRIPTOR_HANDLE;
begin
    New(Result);
    Result^.InitOffsetted(other^, offsetScaledByIncrementSize);
end;



class function TD3DX12_CPU_DESCRIPTOR_HANDLE.Create(other: PD3D12_CPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT): PD3D12_CPU_DESCRIPTOR_HANDLE;
begin
    New(Result);
    Result^.InitOffsetted(other^, offsetInDescriptors, descriptorIncrementSize);
end;



class function TD3DX12_CPU_DESCRIPTOR_HANDLE.Create(offsetInDescriptors: int32; descriptorIncrementSize: UINT): PD3D12_CPU_DESCRIPTOR_HANDLE;
begin
    new(Result);
    Result^.Offset(offsetInDescriptors, descriptorIncrementSize);
end;



class function TD3DX12_CPU_DESCRIPTOR_HANDLE.Create(offsetScaledByIncrementSize: int32): PD3D12_CPU_DESCRIPTOR_HANDLE;
begin
    new(Result);
    Result^.Offset(offsetScaledByIncrementSize);
end;



class function TD3DX12_CPU_DESCRIPTOR_HANDLE.CreateOffsetted(base: TD3D12_CPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32): PD3D12_CPU_DESCRIPTOR_HANDLE;
begin
    new(Result);
    Result^.InitOffsetted(base, offsetScaledByIncrementSize);
end;



class function TD3DX12_CPU_DESCRIPTOR_HANDLE.CreateOffsetted(base: TD3D12_CPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT): PD3D12_CPU_DESCRIPTOR_HANDLE;
begin
    new(Result);
    Result^.InitOffsetted(base, offsetInDescriptors, descriptorIncrementSize);
end;



procedure TD3DX12_CPU_DESCRIPTOR_HANDLE.Init();
begin
    self.Ptr := 0;
end;

*)

constructor TD3DX12_CPU_DESCRIPTOR_HANDLE.Create(const o: PD3D12_CPU_DESCRIPTOR_HANDLE); overload;
begin
    self.ptr := o^.ptr;
end;



constructor TD3DX12_CPU_DESCRIPTOR_HANDLE.Create(constref o: TD3D12_CPU_DESCRIPTOR_HANDLE); overload;
begin
    self.ptr := o.ptr;
end;



constructor TD3DX12_CPU_DESCRIPTOR_HANDLE.Create(Value: TD3D12_DEFAULT); overload;
begin
    self.ptr := 0;
end;



constructor TD3DX12_CPU_DESCRIPTOR_HANDLE.Create({_In_} const other: PD3D12_CPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32); overload;
begin
    InitOffsetted(other, offsetScaledByIncrementSize);
end;



constructor TD3DX12_CPU_DESCRIPTOR_HANDLE.Create({_In_} const other: PD3D12_CPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT); overload;
begin
    InitOffsetted(other, offsetInDescriptors, descriptorIncrementSize);
end;



constructor TD3DX12_CPU_DESCRIPTOR_HANDLE.Create(constref other: TD3D12_CPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32);
begin
    InitOffsetted(@other, offsetScaledByIncrementSize);
end;



constructor TD3DX12_CPU_DESCRIPTOR_HANDLE.Create(constref other: TD3D12_CPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT);
begin
    InitOffsetted(@other, offsetInDescriptors, descriptorIncrementSize);
end;



function TD3DX12_CPU_DESCRIPTOR_HANDLE.Offset(offsetInDescriptors: int32; descriptorIncrementSize: UINT): PD3D12_CPU_DESCRIPTOR_HANDLE;{$IFOPT D-} inline;{$ENDIF} overload;
begin
    self.ptr := SIZE_T(int64(self.ptr) + int64(offsetInDescriptors) * int64(descriptorIncrementSize));
    Result := @self;
end;



function TD3DX12_CPU_DESCRIPTOR_HANDLE.Offset(offsetScaledByIncrementSize: int32): PD3D12_CPU_DESCRIPTOR_HANDLE;{$IFOPT D-} inline;{$ENDIF} overload;
begin
    self.ptr := SIZE_T(int64(self.ptr) + int64(offsetScaledByIncrementSize));
    Result := @self;
end;



procedure TD3DX12_CPU_DESCRIPTOR_HANDLE.InitOffsetted({_In_} const base: PD3D12_CPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32);{$IFOPT D-} inline;{$ENDIF} overload;
begin
    InitOffsetted(@self, base, offsetScaledByIncrementSize);
end;



procedure TD3DX12_CPU_DESCRIPTOR_HANDLE.InitOffsetted({_In_} const base: PD3D12_CPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT);{$IFOPT D-} inline;{$ENDIF} overload;
begin
    InitOffsetted(@self, base, offsetInDescriptors, descriptorIncrementSize);
end;



procedure TD3DX12_CPU_DESCRIPTOR_HANDLE.InitOffsetted({_Out_} handle: PD3D12_CPU_DESCRIPTOR_HANDLE; {_In_} const base: PD3D12_CPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32);{$IFOPT D-} inline;{$ENDIF} overload;
begin
    handle^.ptr := SIZE_T(int64(base^.ptr) + int64(offsetScaledByIncrementSize));
end;



procedure TD3DX12_CPU_DESCRIPTOR_HANDLE.InitOffsetted({_Out_} handle: PD3D12_CPU_DESCRIPTOR_HANDLE; {_In_} const base: PD3D12_CPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT);{$IFOPT D-} inline;{$ENDIF} overload;
begin
    handle^.ptr := SIZE_T(int64(base^.ptr) + int64(offsetInDescriptors) * int64(descriptorIncrementSize));
end;

{ TD3DX12_GPU_DESCRIPTOR_HANDLE }

(*
class function TD3DX12_GPU_DESCRIPTOR_HANDLE.Create(o: PD3D12_GPU_DESCRIPTOR_HANDLE): PD3D12_GPU_DESCRIPTOR_HANDLE;
begin
    new(Result);
    if o <> nil then
        Result^ := o^
    else
        Result^.Init();
end;



class function TD3DX12_GPU_DESCRIPTOR_HANDLE.Create(other: PD3D12_GPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32): PD3D12_GPU_DESCRIPTOR_HANDLE;
begin
    new(Result);
    Result^.Init(other, offsetScaledByIncrementSize);
end;



class function TD3DX12_GPU_DESCRIPTOR_HANDLE.Create(other: PD3D12_GPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT): PD3D12_GPU_DESCRIPTOR_HANDLE;
begin
    new(Result);
    Result^.Init(other, offsetInDescriptors, descriptorIncrementSize);
end;



class function TD3DX12_GPU_DESCRIPTOR_HANDLE.Create(offsetInDescriptors: int32; descriptorIncrementSize: UINT): PD3D12_GPU_DESCRIPTOR_HANDLE;
begin
    new(Result);
    Result^.Offset(offsetInDescriptors, descriptorIncrementSize);
end;



class function TD3DX12_GPU_DESCRIPTOR_HANDLE.Create(offsetScaledByIncrementSize: int32): PD3D12_GPU_DESCRIPTOR_HANDLE;
begin
    new(Result);
    Result^.Offset(offsetScaledByIncrementSize);
end;



class function TD3DX12_GPU_DESCRIPTOR_HANDLE.CreateOffsetted(base: TD3D12_GPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32): PD3D12_GPU_DESCRIPTOR_HANDLE;
begin
    new(Result);
    Result^.InitOffsetted(base, offsetScaledByIncrementSize);
end;



class function TD3DX12_GPU_DESCRIPTOR_HANDLE.CreateOffsetted(base: TD3D12_GPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT): PD3D12_GPU_DESCRIPTOR_HANDLE;
begin
    new(Result);
    Result^.InitOffsetted(base, offsetInDescriptors, descriptorIncrementSize);
end;



procedure TD3DX12_GPU_DESCRIPTOR_HANDLE.Init();
begin
    self.ptr := 0;
end;



procedure TD3DX12_GPU_DESCRIPTOR_HANDLE.Init(other: PD3D12_GPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32);
begin
    InitOffsetted(other^, offsetScaledByIncrementSize);
end;



procedure TD3DX12_GPU_DESCRIPTOR_HANDLE.Init(other: PD3D12_GPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT);
begin
    InitOffsetted(other^, offsetInDescriptors, descriptorIncrementSize);
end;



procedure TD3DX12_GPU_DESCRIPTOR_HANDLE.Offset(offsetInDescriptors: int32; descriptorIncrementSize: UINT);
begin
    self.ptr := uint64(int64(self.ptr) + int64(offsetInDescriptors) * int64(descriptorIncrementSize));
end;



procedure TD3DX12_GPU_DESCRIPTOR_HANDLE.Offset(offsetScaledByIncrementSize: int32);
begin
    self.ptr := uint64(int64(self.ptr) + int64(offsetScaledByIncrementSize));
end;



procedure TD3DX12_GPU_DESCRIPTOR_HANDLE.InitOffsetted(base: TD3D12_GPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32);
begin
    self.ptr := uint64(int64(base.ptr) + int64(offsetScaledByIncrementSize));
end;



procedure TD3DX12_GPU_DESCRIPTOR_HANDLE.InitOffsetted(base: TD3D12_GPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT);
begin
    self.ptr := uint64(int64(base.ptr) + int64(offsetInDescriptors) * int64(descriptorIncrementSize));
end;
        **)

constructor TD3DX12_GPU_DESCRIPTOR_HANDLE.Create(const o: PD3D12_GPU_DESCRIPTOR_HANDLE); overload;
begin
    self.ptr := o^.ptr;
end;

constructor TD3DX12_GPU_DESCRIPTOR_HANDLE.Create(constref
  o: TD3D12_GPU_DESCRIPTOR_HANDLE);
begin
  self.ptr := o.ptr;
end;



constructor TD3DX12_GPU_DESCRIPTOR_HANDLE.Create(AValue: TD3D12_DEFAULT); overload;
begin
    self.ptr := 0;
end;



constructor TD3DX12_GPU_DESCRIPTOR_HANDLE.Create({_In_} const other: PD3D12_GPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32); overload;
begin
    InitOffsetted(other, offsetScaledByIncrementSize);
end;



constructor TD3DX12_GPU_DESCRIPTOR_HANDLE.Create({_In_} const other: PD3D12_GPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: UINT); overload;
begin
    InitOffsetted(other, offsetInDescriptors, descriptorIncrementSize);
end;

constructor TD3DX12_GPU_DESCRIPTOR_HANDLE.Create(constref
  other: TD3D12_GPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32);
begin
     InitOffsetted(@other, offsetScaledByIncrementSize);
end;

constructor TD3DX12_GPU_DESCRIPTOR_HANDLE.Create(constref
  other: TD3D12_GPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32;
  descriptorIncrementSize: UINT);
begin
    InitOffsetted(@other, offsetInDescriptors, descriptorIncrementSize);
end;



function TD3DX12_GPU_DESCRIPTOR_HANDLE.Offset(offsetInDescriptors: INT32; descriptorIncrementSize: UINT): PD3D12_GPU_DESCRIPTOR_HANDLE; {$IFOPT D-} inline;{$ENDIF} overload;
begin
    self.ptr := uint64(int64(self.ptr) + int64(offsetInDescriptors) * int64(descriptorIncrementSize));
    Result := @self;
end;



function TD3DX12_GPU_DESCRIPTOR_HANDLE.Offset(offsetScaledByIncrementSize: int32): PD3D12_GPU_DESCRIPTOR_HANDLE;{$IFOPT D-} inline;{$ENDIF} overload;
begin
    self.ptr := uint64(int64(self.ptr) + int64(offsetScaledByIncrementSize));
    Result := @self;
end;



procedure TD3DX12_GPU_DESCRIPTOR_HANDLE.InitOffsetted({_In_} const base: PD3D12_GPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32); {$IFOPT D-} inline;{$ENDIF} overload;
begin
    InitOffsetted(@self, base, offsetScaledByIncrementSize);
end;



procedure TD3DX12_GPU_DESCRIPTOR_HANDLE.InitOffsetted({_In_} const base: PD3D12_GPU_DESCRIPTOR_HANDLE; offsetInDescriptors: INT32; descriptorIncrementSize: UINT); {$IFOPT D-} inline;{$ENDIF} overload;
begin
    InitOffsetted(@self, base, offsetInDescriptors, descriptorIncrementSize);
end;



procedure TD3DX12_GPU_DESCRIPTOR_HANDLE.InitOffsetted({_Out_} handle: PD3D12_GPU_DESCRIPTOR_HANDLE; {_In_} const base: PD3D12_GPU_DESCRIPTOR_HANDLE; offsetScaledByIncrementSize: int32); {$IFOPT D-} inline;{$ENDIF} overload;
begin
    handle.ptr := uint64(int64(base.ptr) + int64(offsetScaledByIncrementSize));
end;



procedure TD3DX12_GPU_DESCRIPTOR_HANDLE.InitOffsetted({_Out_}  handle: PD3D12_GPU_DESCRIPTOR_HANDLE; {_In_} const base: PD3D12_GPU_DESCRIPTOR_HANDLE; offsetInDescriptors: int32; descriptorIncrementSize: uint32); {$IFOPT D-} inline;{$ENDIF} overload;
begin
    handle^.ptr := uint64(int64(base^.ptr) + int64(offsetInDescriptors) * int64(descriptorIncrementSize));
end;

end.
