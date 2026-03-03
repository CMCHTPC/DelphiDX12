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

   This unit consists of the following header files
   File name: d3d11shadertracing.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3D11ShaderTracing;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3DCommon;

    {$Z4}

const
    D3D11SDKLayers_DLL = 'D3D11_2SDKLayers.dll '; // D3D11SDKLayers.dll; D3D11_1SDKLayers.dll;


    D3D11_TRACE_COMPONENT_X = $1;
    D3D11_TRACE_COMPONENT_Y = $2;
    D3D11_TRACE_COMPONENT_Z = $4;
    D3D11_TRACE_COMPONENT_W = $8;


    D3D11_SHADER_TRACE_FLAG_RECORD_REGISTER_WRITES = $1;
    D3D11_SHADER_TRACE_FLAG_RECORD_REGISTER_READS = $2;

    D3D11_TRACE_REGISTER_FLAGS_RELATIVE_INDEXING = $1;


    D3D11_TRACE_MISC_GS_EMIT = $1;
    D3D11_TRACE_MISC_GS_CUT = $2;
    D3D11_TRACE_MISC_PS_DISCARD = $4;
    D3D11_TRACE_MISC_GS_EMIT_STREAM = $8;
    D3D11_TRACE_MISC_GS_CUT_STREAM = $10;
    D3D11_TRACE_MISC_HALT = $20;
    D3D11_TRACE_MISC_MESSAGE = $40;


    IID_ID3D11ShaderTrace: TGUID = '{36b013e6-2811-4845-baa7-d623fe0df104}';
    IID_ID3D11ShaderTraceFactory: TGUID = '{1fbad429-66ab-41cc-9617-667ac10e4459}';

type

    (* Forward Declarations *)


    ID3D11ShaderTrace = interface;


    ID3D11ShaderTraceFactory = interface;


    TD3D11_SHADER_TYPE = (
        D3D11_VERTEX_SHADER = 1,
        D3D11_HULL_SHADER = 2,
        D3D11_DOMAIN_SHADER = 3,
        D3D11_GEOMETRY_SHADER = 4,
        D3D11_PIXEL_SHADER = 5,
        D3D11_COMPUTE_SHADER = 6);

    PD3D11_SHADER_TYPE = ^TD3D11_SHADER_TYPE;


    TD3D11_TRACE_COMPONENT_MASK = uint8;

    TD3D11_VERTEX_SHADER_TRACE_DESC = record
        Invocation: uint64;
    end;
    PD3D11_VERTEX_SHADER_TRACE_DESC = ^TD3D11_VERTEX_SHADER_TRACE_DESC;


    TD3D11_HULL_SHADER_TRACE_DESC = record
        Invocation: uint64;
    end;
    PD3D11_HULL_SHADER_TRACE_DESC = ^TD3D11_HULL_SHADER_TRACE_DESC;


    TD3D11_DOMAIN_SHADER_TRACE_DESC = record
        Invocation: uint64;
    end;
    PD3D11_DOMAIN_SHADER_TRACE_DESC = ^TD3D11_DOMAIN_SHADER_TRACE_DESC;


    TD3D11_GEOMETRY_SHADER_TRACE_DESC = record
        Invocation: uint64;
    end;
    PD3D11_GEOMETRY_SHADER_TRACE_DESC = ^TD3D11_GEOMETRY_SHADER_TRACE_DESC;


    TD3D11_PIXEL_SHADER_TRACE_DESC = record
        Invocation: uint64;
        X: int32;
        Y: int32;
        SampleMask: uint64;
    end;
    PD3D11_PIXEL_SHADER_TRACE_DESC = ^TD3D11_PIXEL_SHADER_TRACE_DESC;


    TD3D11_COMPUTE_SHADER_TRACE_DESC = record
        Invocation: uint64;
        ThreadIDInGroup: array [0..3 - 1] of UINT;
        ThreadGroupID: array [0..3 - 1] of UINT;
    end;
    PD3D11_COMPUTE_SHADER_TRACE_DESC = ^TD3D11_COMPUTE_SHADER_TRACE_DESC;


    TD3D11_SHADER_TRACE_DESC = record
        ShadersType: TD3D11_SHADER_TYPE;
        Flags: UINT;
        case integer of
            0: (
                VertexShaderTraceDesc: TD3D11_VERTEX_SHADER_TRACE_DESC;
            );
            1: (
                HullShaderTraceDesc: TD3D11_HULL_SHADER_TRACE_DESC;
            );
            2: (
                DomainShaderTraceDesc: TD3D11_DOMAIN_SHADER_TRACE_DESC;
            );
            3: (
                GeometryShaderTraceDesc: TD3D11_GEOMETRY_SHADER_TRACE_DESC;
            );
            4: (
                PixelShaderTraceDesc: TD3D11_PIXEL_SHADER_TRACE_DESC;
            );
            5: (
                ComputeShaderTraceDesc: TD3D11_COMPUTE_SHADER_TRACE_DESC;
            );
    end;
    PD3D11_SHADER_TRACE_DESC = ^TD3D11_SHADER_TRACE_DESC;


    TD3D11_TRACE_GS_INPUT_PRIMITIVE = (
        D3D11_TRACE_GS_INPUT_PRIMITIVE_UNDEFINED = 0,
        D3D11_TRACE_GS_INPUT_PRIMITIVE_POINT = 1,
        D3D11_TRACE_GS_INPUT_PRIMITIVE_LINE = 2,
        D3D11_TRACE_GS_INPUT_PRIMITIVE_TRIANGLE = 3,
        D3D11_TRACE_GS_INPUT_PRIMITIVE_LINE_ADJ = 6,
        D3D11_TRACE_GS_INPUT_PRIMITIVE_TRIANGLE_ADJ = 7);

    PD3D11_TRACE_GS_INPUT_PRIMITIVE = ^TD3D11_TRACE_GS_INPUT_PRIMITIVE;


    TD3D11_TRACE_STATS = record
        TraceDesc: TD3D11_SHADER_TRACE_DESC;
        NumInvocationsInStamp: uint8;
        TargetStampIndex: uint8;
        NumTraceSteps: UINT;
        InputMask: array [0..32 - 1] of TD3D11_TRACE_COMPONENT_MASK;
        OutputMask: array [0..32 - 1] of TD3D11_TRACE_COMPONENT_MASK;
        NumTemps: uint16;
        MaxIndexableTempIndex: uint16;
        IndexableTempSize: array [0..4096 - 1] of uint16;
        ImmediateConstantBufferSize: uint16;
        PixelPosition: array [0..42 - 1] of UINT;
        PixelCoverageMask: array [0..4 - 1] of uint64;
        PixelDiscardedMask: array [0..4 - 1] of uint64;
        PixelCoverageMaskAfterShader: array [0..4 - 1] of uint64;
        PixelCoverageMaskAfterA2CSampleMask: array [0..4 - 1] of uint64;
        PixelCoverageMaskAfterA2CSampleMaskDepth: array [0..4 - 1] of uint64;
        PixelCoverageMaskAfterA2CSampleMaskDepthStencil: array [0..4 - 1] of uint64;
        PSOutputsDepth: boolean;
        PSOutputsMask: boolean;
        GSInputPrimitive: TD3D11_TRACE_GS_INPUT_PRIMITIVE;
        GSInputsPrimitiveID: boolean;
        HSOutputPatchConstantMask: array [0..32 - 1] of TD3D11_TRACE_COMPONENT_MASK;
        DSInputPatchConstantMask: array [0..32 - 1] of TD3D11_TRACE_COMPONENT_MASK;
    end;
    PD3D11_TRACE_STATS = ^TD3D11_TRACE_STATS;


    TD3D11_TRACE_VALUE = record
        Bits: array [0..4 - 1] of UINT;
        ValidMask: TD3D11_TRACE_COMPONENT_MASK;
    end;
    PD3D11_TRACE_VALUE = ^TD3D11_TRACE_VALUE;


    TD3D11_TRACE_REGISTER_TYPE = (
        D3D11_TRACE_OUTPUT_NULL_REGISTER = 0,
        D3D11_TRACE_INPUT_REGISTER = (D3D11_TRACE_OUTPUT_NULL_REGISTER + 1),
        D3D11_TRACE_INPUT_PRIMITIVE_ID_REGISTER = (D3D11_TRACE_INPUT_REGISTER + 1),
        D3D11_TRACE_IMMEDIATE_CONSTANT_BUFFER = (D3D11_TRACE_INPUT_PRIMITIVE_ID_REGISTER + 1),
        D3D11_TRACE_TEMP_REGISTER = (D3D11_TRACE_IMMEDIATE_CONSTANT_BUFFER + 1),
        D3D11_TRACE_INDEXABLE_TEMP_REGISTER = (D3D11_TRACE_TEMP_REGISTER + 1),
        D3D11_TRACE_OUTPUT_REGISTER = (D3D11_TRACE_INDEXABLE_TEMP_REGISTER + 1),
        D3D11_TRACE_OUTPUT_DEPTH_REGISTER = (D3D11_TRACE_OUTPUT_REGISTER + 1),
        D3D11_TRACE_CONSTANT_BUFFER = (D3D11_TRACE_OUTPUT_DEPTH_REGISTER + 1),
        D3D11_TRACE_IMMEDIATE32 = (D3D11_TRACE_CONSTANT_BUFFER + 1),
        D3D11_TRACE_SAMPLER = (D3D11_TRACE_IMMEDIATE32 + 1),
        D3D11_TRACE_RESOURCE = (D3D11_TRACE_SAMPLER + 1),
        D3D11_TRACE_RASTERIZER = (D3D11_TRACE_RESOURCE + 1),
        D3D11_TRACE_OUTPUT_COVERAGE_MASK = (D3D11_TRACE_RASTERIZER + 1),
        D3D11_TRACE_STREAM = (D3D11_TRACE_OUTPUT_COVERAGE_MASK + 1),
        D3D11_TRACE_THIS_POINTER = (D3D11_TRACE_STREAM + 1),
        D3D11_TRACE_OUTPUT_CONTROL_POINT_ID_REGISTER = (D3D11_TRACE_THIS_POINTER + 1),
        D3D11_TRACE_INPUT_FORK_INSTANCE_ID_REGISTER = (D3D11_TRACE_OUTPUT_CONTROL_POINT_ID_REGISTER + 1),
        D3D11_TRACE_INPUT_JOIN_INSTANCE_ID_REGISTER = (D3D11_TRACE_INPUT_FORK_INSTANCE_ID_REGISTER + 1),
        D3D11_TRACE_INPUT_CONTROL_POINT_REGISTER = (D3D11_TRACE_INPUT_JOIN_INSTANCE_ID_REGISTER + 1),
        D3D11_TRACE_OUTPUT_CONTROL_POINT_REGISTER = (D3D11_TRACE_INPUT_CONTROL_POINT_REGISTER + 1),
        D3D11_TRACE_INPUT_PATCH_CONSTANT_REGISTER = (D3D11_TRACE_OUTPUT_CONTROL_POINT_REGISTER + 1),
        D3D11_TRACE_INPUT_DOMAIN_POINT_REGISTER = (D3D11_TRACE_INPUT_PATCH_CONSTANT_REGISTER + 1),
        D3D11_TRACE_UNORDERED_ACCESS_VIEW = (D3D11_TRACE_INPUT_DOMAIN_POINT_REGISTER + 1),
        D3D11_TRACE_THREAD_GROUP_SHARED_MEMORY = (D3D11_TRACE_UNORDERED_ACCESS_VIEW + 1),
        D3D11_TRACE_INPUT_THREAD_ID_REGISTER = (D3D11_TRACE_THREAD_GROUP_SHARED_MEMORY + 1),
        D3D11_TRACE_INPUT_THREAD_GROUP_ID_REGISTER = (D3D11_TRACE_INPUT_THREAD_ID_REGISTER + 1),
        D3D11_TRACE_INPUT_THREAD_ID_IN_GROUP_REGISTER = (D3D11_TRACE_INPUT_THREAD_GROUP_ID_REGISTER + 1),
        D3D11_TRACE_INPUT_COVERAGE_MASK_REGISTER = (D3D11_TRACE_INPUT_THREAD_ID_IN_GROUP_REGISTER + 1),
        D3D11_TRACE_INPUT_THREAD_ID_IN_GROUP_FLATTENED_REGISTER = (D3D11_TRACE_INPUT_COVERAGE_MASK_REGISTER + 1),
        D3D11_TRACE_INPUT_GS_INSTANCE_ID_REGISTER = (D3D11_TRACE_INPUT_THREAD_ID_IN_GROUP_FLATTENED_REGISTER + 1),
        D3D11_TRACE_OUTPUT_DEPTH_GREATER_EQUAL_REGISTER = (D3D11_TRACE_INPUT_GS_INSTANCE_ID_REGISTER + 1),
        D3D11_TRACE_OUTPUT_DEPTH_LESS_EQUAL_REGISTER = (D3D11_TRACE_OUTPUT_DEPTH_GREATER_EQUAL_REGISTER + 1),
        D3D11_TRACE_IMMEDIATE64 = (D3D11_TRACE_OUTPUT_DEPTH_LESS_EQUAL_REGISTER + 1),
        D3D11_TRACE_INPUT_CYCLE_COUNTER_REGISTER = (D3D11_TRACE_IMMEDIATE64 + 1),
        D3D11_TRACE_INTERFACE_POINTER = (D3D11_TRACE_INPUT_CYCLE_COUNTER_REGISTER + 1));

    PD3D11_TRACE_REGISTER_TYPE = ^TD3D11_TRACE_REGISTER_TYPE;


    TD3D11_TRACE_REGISTER = record
        RegType: TD3D11_TRACE_REGISTER_TYPE;
        case integer of
            0: (
                Index1D: uint16;
            );
            1: (
                Index2D: array [0..2 - 1] of uint16;
                OperandIndex: uint8;
                Flags: uint8;
            );
    end;
    PD3D11_TRACE_REGISTER = ^TD3D11_TRACE_REGISTER;


    TD3D11_TRACE_MISC_OPERATIONS_MASK = uint16;

    TD3D11_TRACE_STEP = record
        ID: UINT;
        InstructionActive: boolean;
        NumRegistersWritten: uint8;
        NumRegistersRead: uint8;
        MiscOperations: TD3D11_TRACE_MISC_OPERATIONS_MASK;
        OpcodeType: UINT;
        CurrentGlobalCycle: uint64;
    end;
    PD3D11_TRACE_STEP = ^TD3D11_TRACE_STEP;


    ID3D11ShaderTrace = interface(IUnknown)
        ['{36b013e6-2811-4845-baa7-d623fe0df104}']
        function TraceReady(
        {_Out_opt_  } pTestCount: PUINT64): HRESULT; stdcall;

        procedure ResetTrace(); stdcall;

        function GetTraceStats(
        {_Out_  } pTraceStats: PD3D11_TRACE_STATS): HRESULT; stdcall;

        function PSSelectStamp(
        {_In_  } stampIndex: UINT): HRESULT; stdcall;

        function GetInitialRegisterContents(
        {_In_  } pRegister: PD3D11_TRACE_REGISTER;
        {_Out_  } pValue: PD3D11_TRACE_VALUE): HRESULT; stdcall;

        function GetStep(
        {_In_  } stepIndex: UINT;
        {_Out_  } pTraceStep: PD3D11_TRACE_STEP): HRESULT; stdcall;

        function GetWrittenRegister(
        {_In_  } stepIndex: UINT;
        {_In_  } writtenRegisterIndex: UINT;
        {_Out_  } pRegister: PD3D11_TRACE_REGISTER;
        {_Out_  } pValue: PD3D11_TRACE_VALUE): HRESULT; stdcall;

        function GetReadRegister(
        {_In_  } stepIndex: UINT;
        {_In_  } readRegisterIndex: UINT;
        {_Out_  } pRegister: PD3D11_TRACE_REGISTER;
        {_Out_  } pValue: PD3D11_TRACE_VALUE): HRESULT; stdcall;

    end;


    ID3D11ShaderTraceFactory = interface(IUnknown)
        ['{1fbad429-66ab-41cc-9617-667ac10e4459}']
        function CreateShaderTrace(
        {_In_  } pShader: IUnknown;
        {_In_  } pTraceDesc: PD3D11_SHADER_TRACE_DESC;
        {_COM_Outptr_  }  out ppShaderTrace: ID3D11ShaderTrace): HRESULT; stdcall;

    end;



function D3DDisassemble11Trace(
{_In_reads_bytes_(SrcDataSize) } pSrcData : LPCVOID ;
{_In_ } SrcDataSize : SIZE_T ;
{_In_ } pTrace : ID3D11ShaderTrace ;
{_In_ } StartStep : UINT ;
{_In_ } NumSteps : UINT ;
{_In_ } Flags : UINT ;
{_COM_Outptr_ } out ppDisassembly : ID3D10Blob
    ) : HRESULT;stdcall; external D3D11SDKLayers_DLL;






implementation

end.
