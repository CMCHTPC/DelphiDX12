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

   This unit consists of the following header files
   File name: d3d11_1.j
   Header version: 10.0.26100.6584

  ************************************************************************** }


unit DX12.D3D11_1;


{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}


interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D11,
    DX12.DXGIFormat,
    DX12.DXGICommon,
    DX12.D3DCommon,
    DX12.DXGI1_2;

    {$Z4}

const

    IID_ID3D11BlendState1: TGUID = '{CC86FABE-DA55-401D-85E7-E3C9DE2877E9}';
    IID_ID3D11RasterizerState1: TGUID = '{1217D7A6-5039-418C-B042-9CBE256AFD6E}';
    IID_ID3DDeviceContextState: TGUID = '{5C1E0D8A-7C23-48F9-8C59-A92958CEFF11}';
    IID_ID3D11DeviceContext1: TGUID = '{BB2C6FAA-B5FB-4082-8E6B-388B8CFA90E1}';
    IID_ID3D11VideoContext1: TGUID = '{A7F026DA-A5F8-4487-A564-15E34357651E}';
    IID_ID3D11VideoDevice1: TGUID = '{29DA1D51-1321-4454-804B-F5FC9F861F0F}';
    IID_ID3D11VideoProcessorEnumerator1: TGUID = '{465217F2-5568-43CF-B5B9-F61D54531CA1}';
    IID_ID3D11Device1: TGUID = '{A04BFB29-08EF-43D6-A49C-A9BDBDCBE686}';
    IID_ID3DUserDefinedAnnotation: TGUID = '{B2DAAD8B-03D4-4DBF-95EB-32AB4B63D0AB}';


type

    REFIID = ^TGUID;

    (* Forward Declarations *)


    ID3D11BlendState1 = interface;


    ID3D11RasterizerState1 = interface;


    ID3DDeviceContextState = interface;


    ID3D11DeviceContext1 = interface;


    ID3D11VideoContext1 = interface;


    ID3D11VideoDevice1 = interface;


    ID3D11VideoProcessorEnumerator1 = interface;


    ID3D11Device1 = interface;


    ID3DUserDefinedAnnotation = interface;


    TD3D11_COPY_FLAGS = (
        D3D11_COPY_NO_OVERWRITE = $1,
        D3D11_COPY_DISCARD = $2);

    PD3D11_COPY_FLAGS = ^TD3D11_COPY_FLAGS;


    TD3D11_LOGIC_OP = (
        D3D11_LOGIC_OP_CLEAR = 0,
        D3D11_LOGIC_OP_SET = (D3D11_LOGIC_OP_CLEAR + 1),
        D3D11_LOGIC_OP_COPY = (D3D11_LOGIC_OP_SET + 1),
        D3D11_LOGIC_OP_COPY_INVERTED = (D3D11_LOGIC_OP_COPY + 1),
        D3D11_LOGIC_OP_NOOP = (D3D11_LOGIC_OP_COPY_INVERTED + 1),
        D3D11_LOGIC_OP_INVERT = (D3D11_LOGIC_OP_NOOP + 1),
        D3D11_LOGIC_OP_AND = (D3D11_LOGIC_OP_INVERT + 1),
        D3D11_LOGIC_OP_NAND = (D3D11_LOGIC_OP_AND + 1),
        D3D11_LOGIC_OP_OR = (D3D11_LOGIC_OP_NAND + 1),
        D3D11_LOGIC_OP_NOR = (D3D11_LOGIC_OP_OR + 1),
        D3D11_LOGIC_OP_XOR = (D3D11_LOGIC_OP_NOR + 1),
        D3D11_LOGIC_OP_EQUIV = (D3D11_LOGIC_OP_XOR + 1),
        D3D11_LOGIC_OP_AND_REVERSE = (D3D11_LOGIC_OP_EQUIV + 1),
        D3D11_LOGIC_OP_AND_INVERTED = (D3D11_LOGIC_OP_AND_REVERSE + 1),
        D3D11_LOGIC_OP_OR_REVERSE = (D3D11_LOGIC_OP_AND_INVERTED + 1),
        D3D11_LOGIC_OP_OR_INVERTED = (D3D11_LOGIC_OP_OR_REVERSE + 1));

    PD3D11_LOGIC_OP = ^TD3D11_LOGIC_OP;


    { TD3D11_RENDER_TARGET_BLEND_DESC1 }

    TD3D11_RENDER_TARGET_BLEND_DESC1 = record
        BlendEnable: boolean;
        LogicOpEnable: boolean;
        SrcBlend: TD3D11_BLEND;
        DestBlend: TD3D11_BLEND;
        BlendOp: TD3D11_BLEND_OP;
        SrcBlendAlpha: TD3D11_BLEND;
        DestBlendAlpha: TD3D11_BLEND;
        BlendOpAlpha: TD3D11_BLEND_OP;
        LogicOp: TD3D11_LOGIC_OP;
        RenderTargetWriteMask: uint8;
        procedure DefaultRenderTargetBlendDesc;
    end;
    PD3D11_RENDER_TARGET_BLEND_DESC1 = ^TD3D11_RENDER_TARGET_BLEND_DESC1;


    { TD3D11_BLEND_DESC1 }

    TD3D11_BLEND_DESC1 = record
        AlphaToCoverageEnable: boolean;
        IndependentBlendEnable: boolean;
        RenderTarget: array [0..8 - 1] of TD3D11_RENDER_TARGET_BLEND_DESC1;
        class operator Initialize(var aRec: TD3D11_BLEND_DESC1);
    end;
    PD3D11_BLEND_DESC1 = ^TD3D11_BLEND_DESC1;


(* Note, the array size for RenderTarget[] above is D3D11_SIMULTANEOUS_RENDERTARGET_COUNT.
   IDL processing/generation of this header replaces the define; this comment is merely explaining what happened. *)


    ID3D11BlendState1 = interface(ID3D11BlendState)
        ['{cc86fabe-da55-401d-85e7-e3c9de2877e9}']
        procedure GetDesc1(
        {_Out_  } pDesc: PD3D11_BLEND_DESC1); stdcall;

    end;


    { TD3D11_RASTERIZER_DESC1 }

    TD3D11_RASTERIZER_DESC1 = record
        FillMode: TD3D11_FILL_MODE;
        CullMode: TD3D11_CULL_MODE;
        FrontCounterClockwise: boolean;
        DepthBias: int32;
        DepthBiasClamp: single;
        SlopeScaledDepthBias: single;
        DepthClipEnable: boolean;
        ScissorEnable: boolean;
        MultisampleEnable: boolean;
        AntialiasedLineEnable: boolean;
        ForcedSampleCount: UINT;
        class operator Initialize(var aRec: TD3D11_RASTERIZER_DESC1);
        procedure Init(fillMode: TD3D11_FILL_MODE; cullMode: TD3D11_CULL_MODE; frontCounterClockwise: boolean; depthBias: int32; depthBiasClamp: single; slopeScaledDepthBias: single;
            depthClipEnable: boolean; scissorEnable: boolean; multisampleEnable: boolean; antialiasedLineEnable: boolean; forcedSampleCount: UINT);
    end;
    PD3D11_RASTERIZER_DESC1 = ^TD3D11_RASTERIZER_DESC1;


    ID3D11RasterizerState1 = interface(ID3D11RasterizerState)
        ['{1217d7a6-5039-418c-b042-9cbe256afd6e}']
        procedure GetDesc1(
        {_Out_  } pDesc: PD3D11_RASTERIZER_DESC1); stdcall;

    end;


    TD3D11_1_CREATE_DEVICE_CONTEXT_STATE_FLAG = (
        D3D11_1_CREATE_DEVICE_CONTEXT_STATE_SINGLETHREADED = $1);

    PD3D11_1_CREATE_DEVICE_CONTEXT_STATE_FLAG = ^TD3D11_1_CREATE_DEVICE_CONTEXT_STATE_FLAG;


    ID3DDeviceContextState = interface(ID3D11DeviceChild)
        ['{5c1e0d8a-7c23-48f9-8c59-a92958ceff11}']
    end;


    ID3D11DeviceContext1 = interface(ID3D11DeviceContext)
        ['{bb2c6faa-b5fb-4082-8e6b-388b8cfa90e1}']
        procedure CopySubresourceRegion1(
        {_In_  } pDstResource: ID3D11Resource;
        {_In_  } DstSubresource: UINT;
        {_In_  } DstX: UINT;
        {_In_  } DstY: UINT;
        {_In_  } DstZ: UINT;
        {_In_  } pSrcResource: ID3D11Resource;
        {_In_  } SrcSubresource: UINT;
        {_In_opt_  } pSrcBox: PD3D11_BOX;
        {_In_  } CopyFlags: UINT); stdcall;

        procedure UpdateSubresource1(
        {_In_  } pDstResource: ID3D11Resource;
        {_In_  } DstSubresource: UINT;
        {_In_opt_  } pDstBox: PD3D11_BOX;
        {_In_  } pSrcData: Pvoid;
        {_In_  } SrcRowPitch: UINT;
        {_In_  } SrcDepthPitch: UINT;
        {_In_  } CopyFlags: UINT); stdcall;

        procedure DiscardResource(
        {_In_  } pResource: ID3D11Resource); stdcall;

        procedure DiscardView(
        {_In_  } pResourceView: ID3D11View); stdcall;

        procedure VSSetConstantBuffers1(
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - StartSlot )  } NumBuffers: UINT;
        {_In_reads_opt_(NumBuffers)  } ppConstantBuffers: PID3D11Buffer;
        {_In_reads_opt_(NumBuffers)  } pFirstConstant: PUINT;
        {_In_reads_opt_(NumBuffers)  } pNumConstants: PUINT); stdcall;

        procedure HSSetConstantBuffers1(
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - StartSlot )  } NumBuffers: UINT;
        {_In_reads_opt_(NumBuffers)  } ppConstantBuffers: PID3D11Buffer;
        {_In_reads_opt_(NumBuffers)  } pFirstConstant: PUINT;
        {_In_reads_opt_(NumBuffers)  } pNumConstants: PUINT); stdcall;

        procedure DSSetConstantBuffers1(
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - StartSlot )  } NumBuffers: UINT;
        {_In_reads_opt_(NumBuffers)  } ppConstantBuffers: PID3D11Buffer;
        {_In_reads_opt_(NumBuffers)  } pFirstConstant: PUINT;
        {_In_reads_opt_(NumBuffers)  } pNumConstants: PUINT); stdcall;

        procedure GSSetConstantBuffers1(
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - StartSlot )  } NumBuffers: UINT;
        {_In_reads_opt_(NumBuffers)  } ppConstantBuffers: PID3D11Buffer;
        {_In_reads_opt_(NumBuffers)  } pFirstConstant: PUINT;
        {_In_reads_opt_(NumBuffers)  } pNumConstants: PUINT); stdcall;

        procedure PSSetConstantBuffers1(
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - StartSlot )  } NumBuffers: UINT;
        {_In_reads_opt_(NumBuffers)  } ppConstantBuffers: PID3D11Buffer;
        {_In_reads_opt_(NumBuffers)  } pFirstConstant: PUINT;
        {_In_reads_opt_(NumBuffers)  } pNumConstants: PUINT); stdcall;

        procedure CSSetConstantBuffers1(
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - StartSlot )  } NumBuffers: UINT;
        {_In_reads_opt_(NumBuffers)  } ppConstantBuffers: PID3D11Buffer;
        {_In_reads_opt_(NumBuffers)  } pFirstConstant: PUINT;
        {_In_reads_opt_(NumBuffers)  } pNumConstants: PUINT); stdcall;

        procedure VSGetConstantBuffers1(
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - StartSlot )  } NumBuffers: UINT;
        {_Out_writes_opt_(NumBuffers)  }  out ppConstantBuffers: ID3D11Buffer;
        {_Out_writes_opt_(NumBuffers)  } pFirstConstant: PUINT;
        {_Out_writes_opt_(NumBuffers)  } pNumConstants: PUINT); stdcall;

        procedure HSGetConstantBuffers1(
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - StartSlot )  } NumBuffers: UINT;
        {_Out_writes_opt_(NumBuffers)  }  out ppConstantBuffers: ID3D11Buffer;
        {_Out_writes_opt_(NumBuffers)  } pFirstConstant: PUINT;
        {_Out_writes_opt_(NumBuffers)  } pNumConstants: PUINT); stdcall;

        procedure DSGetConstantBuffers1(
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - StartSlot )  } NumBuffers: UINT;
        {_Out_writes_opt_(NumBuffers)  }  out ppConstantBuffers: ID3D11Buffer;
        {_Out_writes_opt_(NumBuffers)  } pFirstConstant: PUINT;
        {_Out_writes_opt_(NumBuffers)  } pNumConstants: PUINT); stdcall;

        procedure GSGetConstantBuffers1(
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - StartSlot )  } NumBuffers: UINT;
        {_Out_writes_opt_(NumBuffers)  }  out ppConstantBuffers: ID3D11Buffer;
        {_Out_writes_opt_(NumBuffers)  } pFirstConstant: PUINT;
        {_Out_writes_opt_(NumBuffers)  } pNumConstants: PUINT); stdcall;

        procedure PSGetConstantBuffers1(
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - StartSlot )  } NumBuffers: UINT;
        {_Out_writes_opt_(NumBuffers)  }  out ppConstantBuffers: ID3D11Buffer;
        {_Out_writes_opt_(NumBuffers)  } pFirstConstant: PUINT;
        {_Out_writes_opt_(NumBuffers)  } pNumConstants: PUINT); stdcall;

        procedure CSGetConstantBuffers1(
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - StartSlot )  } NumBuffers: UINT;
        {_Out_writes_opt_(NumBuffers)  }  out ppConstantBuffers: ID3D11Buffer;
        {_Out_writes_opt_(NumBuffers)  } pFirstConstant: PUINT;
        {_Out_writes_opt_(NumBuffers)  } pNumConstants: PUINT); stdcall;

        procedure SwapDeviceContextState(
        {_In_  } pState: ID3DDeviceContextState;
        {_Outptr_opt_  }  out ppPreviousState: ID3DDeviceContextState); stdcall;

        procedure ClearView(
        {_In_  } pView: ID3D11View;
        {_In_  } Color: TFloatArray4;
        {_In_reads_opt_(NumRects)  } pRect: PD3D11_RECT; NumRects: UINT); stdcall;

        procedure DiscardView1(
        {_In_  } pResourceView: ID3D11View;
        {_In_reads_opt_(NumRects)  } pRects: PD3D11_RECT; NumRects: UINT); stdcall;

    end;


    TD3D11_VIDEO_DECODER_SUB_SAMPLE_MAPPING_BLOCK = record
        ClearSize: UINT;
        EncryptedSize: UINT;
    end;
    PD3D11_VIDEO_DECODER_SUB_SAMPLE_MAPPING_BLOCK = ^TD3D11_VIDEO_DECODER_SUB_SAMPLE_MAPPING_BLOCK;


    TD3D11_VIDEO_DECODER_BUFFER_DESC1 = record
        BufferType: TD3D11_VIDEO_DECODER_BUFFER_TYPE;
        DataOffset: UINT;
        DataSize: UINT; (* [annotation] *)
        {_Field_size_opt_(IVSize)  } pIV: Pvoid;
        IVSize: UINT; (* [annotation] *)
        {_Field_size_opt_(SubSampleMappingCount)  } pSubSampleMappingBlock: PD3D11_VIDEO_DECODER_SUB_SAMPLE_MAPPING_BLOCK;
        SubSampleMappingCount: UINT;
    end;
    PD3D11_VIDEO_DECODER_BUFFER_DESC1 = ^TD3D11_VIDEO_DECODER_BUFFER_DESC1;


    TD3D11_VIDEO_DECODER_BEGIN_FRAME_CRYPTO_SESSION = record
        pCryptoSession: PID3D11CryptoSession;
        BlobSize: UINT; (* [annotation] *)
        {_Field_size_opt_(BlobSize)  } pBlob: Pvoid;
        pKeyInfoId: PGUID;
        PrivateDataSize: UINT; (* [annotation] *)
        {_Field_size_opt_(PrivateDataSize)  } pPrivateData: Pvoid;
    end;
    PD3D11_VIDEO_DECODER_BEGIN_FRAME_CRYPTO_SESSION = ^TD3D11_VIDEO_DECODER_BEGIN_FRAME_CRYPTO_SESSION;


    TD3D11_VIDEO_DECODER_CAPS = (
        D3D11_VIDEO_DECODER_CAPS_DOWNSAMPLE = $1,
        D3D11_VIDEO_DECODER_CAPS_NON_REAL_TIME = $2,
        D3D11_VIDEO_DECODER_CAPS_DOWNSAMPLE_DYNAMIC = $4,
        D3D11_VIDEO_DECODER_CAPS_DOWNSAMPLE_REQUIRED = $8,
        D3D11_VIDEO_DECODER_CAPS_UNSUPPORTED = $10);

    PD3D11_VIDEO_DECODER_CAPS = ^TD3D11_VIDEO_DECODER_CAPS;


    TD3D11_VIDEO_PROCESSOR_BEHAVIOR_HINTS = (
        D3D11_VIDEO_PROCESSOR_BEHAVIOR_HINT_MULTIPLANE_OVERLAY_ROTATION = $1,
        D3D11_VIDEO_PROCESSOR_BEHAVIOR_HINT_MULTIPLANE_OVERLAY_RESIZE = $2,
        D3D11_VIDEO_PROCESSOR_BEHAVIOR_HINT_MULTIPLANE_OVERLAY_COLOR_SPACE_CONVERSION = $4,
        D3D11_VIDEO_PROCESSOR_BEHAVIOR_HINT_TRIPLE_BUFFER_OUTPUT = $8);

    PD3D11_VIDEO_PROCESSOR_BEHAVIOR_HINTS = ^TD3D11_VIDEO_PROCESSOR_BEHAVIOR_HINTS;


    TD3D11_VIDEO_PROCESSOR_STREAM_BEHAVIOR_HINT = record
        Enable: boolean;
        Width: UINT;
        Height: UINT;
        Format: TDXGI_FORMAT;
    end;
    PD3D11_VIDEO_PROCESSOR_STREAM_BEHAVIOR_HINT = ^TD3D11_VIDEO_PROCESSOR_STREAM_BEHAVIOR_HINT;


    TD3D11_CRYPTO_SESSION_STATUS = (
        D3D11_CRYPTO_SESSION_STATUS_OK = 0,
        D3D11_CRYPTO_SESSION_STATUS_KEY_LOST = 1,
        D3D11_CRYPTO_SESSION_STATUS_KEY_AND_CONTENT_LOST = 2);

    PD3D11_CRYPTO_SESSION_STATUS = ^TD3D11_CRYPTO_SESSION_STATUS;


    TD3D11_KEY_EXCHANGE_HW_PROTECTION_INPUT_DATA = record
        PrivateDataSize: UINT;
        HWProtectionDataSize: UINT;
        pbInput: array [0..4 - 1] of TBYTE;
    end;
    PD3D11_KEY_EXCHANGE_HW_PROTECTION_INPUT_DATA = ^TD3D11_KEY_EXCHANGE_HW_PROTECTION_INPUT_DATA;


    TD3D11_KEY_EXCHANGE_HW_PROTECTION_OUTPUT_DATA = record
        PrivateDataSize: UINT;
        MaxHWProtectionDataSize: UINT;
        HWProtectionDataSize: UINT;
        TransportTime: uint64;
        ExecutionTime: uint64;
        pbOutput: array [0..4 - 1] of TBYTE;
    end;
    PD3D11_KEY_EXCHANGE_HW_PROTECTION_OUTPUT_DATA = ^TD3D11_KEY_EXCHANGE_HW_PROTECTION_OUTPUT_DATA;


    TD3D11_KEY_EXCHANGE_HW_PROTECTION_DATA = record
        HWProtectionFunctionID: UINT;
        pInputData: PD3D11_KEY_EXCHANGE_HW_PROTECTION_INPUT_DATA;
        pOutputData: PD3D11_KEY_EXCHANGE_HW_PROTECTION_OUTPUT_DATA;
        Status: HRESULT;
    end;
    PD3D11_KEY_EXCHANGE_HW_PROTECTION_DATA = ^TD3D11_KEY_EXCHANGE_HW_PROTECTION_DATA;


    TD3D11_VIDEO_SAMPLE_DESC = record
        Width: UINT;
        Height: UINT;
        Format: TDXGI_FORMAT;
        ColorSpace: TDXGI_COLOR_SPACE_TYPE;
    end;
    PD3D11_VIDEO_SAMPLE_DESC = ^TD3D11_VIDEO_SAMPLE_DESC;


    ID3D11VideoContext1 = interface(ID3D11VideoContext)
        ['{A7F026DA-A5F8-4487-A564-15E34357651E}']
        function SubmitDecoderBuffers1(
        {_In_  } pDecoder: ID3D11VideoDecoder;
        {_In_  } NumBuffers: UINT;
        {_In_reads_(NumBuffers)  } pBufferDesc: PD3D11_VIDEO_DECODER_BUFFER_DESC1): HRESULT; stdcall;

        function GetDataForNewHardwareKey(
        {_In_  } pCryptoSession: ID3D11CryptoSession;
        {_In_  } PrivateInputSize: UINT;
        {_In_reads_(PrivateInputSize)  } pPrivatInputData: Pvoid;
        {_Out_  } pPrivateOutputData: PUINT64): HRESULT; stdcall;

        function CheckCryptoSessionStatus(
        {_In_  } pCryptoSession: ID3D11CryptoSession;
        {_Out_  } pStatus: PD3D11_CRYPTO_SESSION_STATUS): HRESULT; stdcall;

        function DecoderEnableDownsampling(
        {_In_  } pDecoder: ID3D11VideoDecoder;
        {_In_  } InputColorSpace: TDXGI_COLOR_SPACE_TYPE;
        {_In_  } pOutputDesc: PD3D11_VIDEO_SAMPLE_DESC;
        {_In_  } ReferenceFrameCount: UINT): HRESULT; stdcall;

        function DecoderUpdateDownsampling(
        {_In_  } pDecoder: ID3D11VideoDecoder;
        {_In_  } pOutputDesc: PD3D11_VIDEO_SAMPLE_DESC): HRESULT; stdcall;

        procedure VideoProcessorSetOutputColorSpace1(
        {_In_  } pVideoProcessor: ID3D11VideoProcessor;
        {_In_  } ColorSpace: TDXGI_COLOR_SPACE_TYPE); stdcall;

        procedure VideoProcessorSetOutputShaderUsage(
        {_In_  } pVideoProcessor: ID3D11VideoProcessor;
        {_In_  } ShaderUsage: boolean); stdcall;

        procedure VideoProcessorGetOutputColorSpace1(
        {_In_  } pVideoProcessor: ID3D11VideoProcessor;
        {_Out_  } pColorSpace: PDXGI_COLOR_SPACE_TYPE); stdcall;

        procedure VideoProcessorGetOutputShaderUsage(
        {_In_  } pVideoProcessor: ID3D11VideoProcessor;
        {_Out_  } pShaderUsage: Pboolean); stdcall;

        procedure VideoProcessorSetStreamColorSpace1(
        {_In_  } pVideoProcessor: ID3D11VideoProcessor;
        {_In_  } StreamIndex: UINT;
        {_In_  } ColorSpace: TDXGI_COLOR_SPACE_TYPE); stdcall;

        procedure VideoProcessorSetStreamMirror(
        {_In_  } pVideoProcessor: ID3D11VideoProcessor;
        {_In_  } StreamIndex: UINT;
        {_In_  } Enable: boolean;
        {_In_  } FlipHorizontal: boolean;
        {_In_  } FlipVertical: boolean); stdcall;

        procedure VideoProcessorGetStreamColorSpace1(
        {_In_  } pVideoProcessor: ID3D11VideoProcessor;
        {_In_  } StreamIndex: UINT;
        {_Out_  } pColorSpace: PDXGI_COLOR_SPACE_TYPE); stdcall;

        procedure VideoProcessorGetStreamMirror(
        {_In_  } pVideoProcessor: ID3D11VideoProcessor;
        {_In_  } StreamIndex: UINT;
        {_Out_  } pEnable: Pboolean;
        {_Out_  } pFlipHorizontal: Pboolean;
        {_Out_  } pFlipVertical: Pboolean); stdcall;

        function VideoProcessorGetBehaviorHints(
        {_In_  } pVideoProcessor: ID3D11VideoProcessor;
        {_In_  } OutputWidth: UINT;
        {_In_  } OutputHeight: UINT;
        {_In_  } OutputFormat: TDXGI_FORMAT;
        {_In_  } StreamCount: UINT;
        {_In_reads_(StreamCount)  } pStreams: PD3D11_VIDEO_PROCESSOR_STREAM_BEHAVIOR_HINT;
        {_Out_  } pBehaviorHints: PUINT): HRESULT; stdcall;

    end;


    ID3D11VideoDevice1 = interface(ID3D11VideoDevice)
        ['{29DA1D51-1321-4454-804B-F5FC9F861F0F}']
        function GetCryptoSessionPrivateDataSize(
        {_In_  } pCryptoType: PGUID;
        {_In_opt_  } pDecoderProfile: PGUID;
        {_In_  } pKeyExchangeType: PGUID;
        {_Out_  } pPrivateInputSize: PUINT;
        {_Out_  } pPrivateOutputSize: PUINT): HRESULT; stdcall;

        function GetVideoDecoderCaps(
        {_In_  } pDecoderProfile: PGUID;
        {_In_  } SampleWidth: UINT;
        {_In_  } SampleHeight: UINT;
        {_In_  } pFrameRate: PDXGI_RATIONAL;
        {_In_  } BitRate: UINT;
        {_In_opt_  } pCryptoType: PGUID;
        {_Out_  } pDecoderCaps: PUINT): HRESULT; stdcall;

        function CheckVideoDecoderDownsampling(
        {_In_  } pInputDesc: PD3D11_VIDEO_DECODER_DESC;
        {_In_  } InputColorSpace: TDXGI_COLOR_SPACE_TYPE;
        {_In_  } pInputConfig: PD3D11_VIDEO_DECODER_CONFIG;
        {_In_  } pFrameRate: PDXGI_RATIONAL;
        {_In_  } pOutputDesc: PD3D11_VIDEO_SAMPLE_DESC;
        {_Out_  } pSupported: Pboolean;
        {_Out_  } pRealTimeHint: Pboolean): HRESULT; stdcall;

        function RecommendVideoDecoderDownsampleParameters(
        {_In_  } pInputDesc: PD3D11_VIDEO_DECODER_DESC;
        {_In_  } InputColorSpace: TDXGI_COLOR_SPACE_TYPE;
        {_In_  } pInputConfig: PD3D11_VIDEO_DECODER_CONFIG;
        {_In_  } pFrameRate: PDXGI_RATIONAL;
        {_Out_  } pRecommendedOutputDesc: PD3D11_VIDEO_SAMPLE_DESC): HRESULT; stdcall;

    end;


    ID3D11VideoProcessorEnumerator1 = interface(ID3D11VideoProcessorEnumerator)
        ['{465217F2-5568-43CF-B5B9-F61D54531CA1}']
        function CheckVideoProcessorFormatConversion(
        {_In_  } InputFormat: TDXGI_FORMAT;
        {_In_  } InputColorSpace: TDXGI_COLOR_SPACE_TYPE;
        {_In_  } OutputFormat: TDXGI_FORMAT;
        {_In_  } OutputColorSpace: TDXGI_COLOR_SPACE_TYPE;
        {_Out_  } pSupported: Pboolean): HRESULT; stdcall;

    end;


    ID3D11Device1 = interface(ID3D11Device)
        ['{a04bfb29-08ef-43d6-a49c-a9bdbdcbe686}']
        procedure GetImmediateContext1(
        {_Outptr_  }  out ppImmediateContext: ID3D11DeviceContext1); stdcall;

        function CreateDeferredContext1(ContextFlags: UINT;
        {_COM_Outptr_opt_  }  out ppDeferredContext: ID3D11DeviceContext1): HRESULT; stdcall;

        function CreateBlendState1(
        {_In_  } pBlendStateDesc: PD3D11_BLEND_DESC1;
        {_COM_Outptr_opt_  }  out ppBlendState: ID3D11BlendState1): HRESULT; stdcall;

        function CreateRasterizerState1(
        {_In_  } pRasterizerDesc: PD3D11_RASTERIZER_DESC1;
        {_COM_Outptr_opt_  }  out ppRasterizerState: ID3D11RasterizerState1): HRESULT; stdcall;

        function CreateDeviceContextState(Flags: UINT;
        {_In_reads_( FeatureLevels )  } pFeatureLevels: PD3D_FEATURE_LEVEL; FeatureLevels: UINT; SDKVersion: UINT; EmulatedInterface: REFIID;
        {_Out_opt_  } pChosenFeatureLevel: PD3D_FEATURE_LEVEL;
        {_Out_opt_  }  out ppContextState: ID3DDeviceContextState): HRESULT; stdcall;

        function OpenSharedResource1(
        {_In_  } hResource: HANDLE;
        {_In_  } returnedInterface: REFIID;
        {_COM_Outptr_  }  out ppResource): HRESULT; stdcall;

        function OpenSharedResourceByName(
        {_In_  } lpName: LPCWSTR;
        {_In_  } dwDesiredAccess: DWORD;
        {_In_  } returnedInterface: REFIID;
        {_COM_Outptr_  }  out ppResource): HRESULT; stdcall;

    end;


    ID3DUserDefinedAnnotation = interface(IUnknown)
        ['{b2daad8b-03d4-4dbf-95eb-32ab4b63d0ab}']
        function BeginEvent(
        {_In_  } Name: LPCWSTR): int32; stdcall;

        function EndEvent(): int32; stdcall;

        procedure SetMarker(
        {_In_  } Name: LPCWSTR); stdcall;

        function GetStatus(): boolean; stdcall;

    end;


implementation

{ TD3D11_RENDER_TARGET_BLEND_DESC1 }

procedure TD3D11_RENDER_TARGET_BLEND_DESC1.DefaultRenderTargetBlendDesc;
begin
    BlendEnable := False;
    LogicOpEnable := False;
    SrcBlend := D3D11_BLEND_ONE;
    DestBlend := D3D11_BLEND_ZERO;
    BlendOp := D3D11_BLEND_OP_ADD;
    SrcBlendAlpha := D3D11_BLEND_ONE;
    DestBlendAlpha := D3D11_BLEND_ZERO;
    BlendOpAlpha := D3D11_BLEND_OP_ADD;
    LogicOp := D3D11_LOGIC_OP_NOOP;
    RenderTargetWriteMask := Ord(D3D11_COLOR_WRITE_ENABLE_ALL);
end;

{ TD3D11_BLEND_DESC1 }

class operator TD3D11_BLEND_DESC1.Initialize(var aRec: TD3D11_BLEND_DESC1);
var
    i: UINT;
begin
    ARec.AlphaToCoverageEnable := False;
    ARec.IndependentBlendEnable := False;
    for i := 0 to D3D11_SIMULTANEOUS_RENDER_TARGET_COUNT - 1 do
        ARec.RenderTarget[i].DefaultRenderTargetBlendDesc;
end;

{ TD3D11_RASTERIZER_DESC1 }

class operator TD3D11_RASTERIZER_DESC1.Initialize(var aRec: TD3D11_RASTERIZER_DESC1);
begin
    aRec.FillMode := D3D11_FILL_SOLID;
    aRec.CullMode := D3D11_CULL_BACK;
    aRec.FrontCounterClockwise := False;
    aRec.DepthBias := D3D11_DEFAULT_DEPTH_BIAS;
    aRec.DepthBiasClamp := D3D11_DEFAULT_DEPTH_BIAS_CLAMP;
    aRec.SlopeScaledDepthBias := D3D11_DEFAULT_SLOPE_SCALED_DEPTH_BIAS;
    aRec.DepthClipEnable := True;
    aRec.ScissorEnable := False;
    aRec.MultisampleEnable := False;
    aRec.AntialiasedLineEnable := False;
    aRec.ForcedSampleCount := 0;
end;



procedure TD3D11_RASTERIZER_DESC1.Init(fillMode: TD3D11_FILL_MODE; cullMode: TD3D11_CULL_MODE; frontCounterClockwise: boolean; depthBias: int32; depthBiasClamp: single; slopeScaledDepthBias: single;
    depthClipEnable: boolean; scissorEnable: boolean; multisampleEnable: boolean; antialiasedLineEnable: boolean; forcedSampleCount: UINT);
begin
    Self.FillMode := fillMode;
    Self.CullMode := cullMode;
    Self.FrontCounterClockwise := frontCounterClockwise;
    Self.DepthBias := depthBias;
    Self.DepthBiasClamp := depthBiasClamp;
    Self.SlopeScaledDepthBias := slopeScaledDepthBias;
    Self.DepthClipEnable := depthClipEnable;
    Self.ScissorEnable := scissorEnable;
    Self.MultisampleEnable := multisampleEnable;
    Self.AntialiasedLineEnable := antialiasedLineEnable;
    Self.ForcedSampleCount := forcedSampleCount;
end;

end.
