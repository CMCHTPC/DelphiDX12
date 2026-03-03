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
   this ALWAYS GENERATED file contains the definitions for the interfaces

   This unit consists of the following header files
   File name: d3d11_4.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3D11_4;


{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.DXGI1_5,
    DX12.D3D11,
    DX12.D3D11_1,
    DX12.D3D11_2,
    DX12.D3D11_3;

    {$Z4}

const
    IID_ID3D11Device4: TGUID = '{8992AB71-02E6-4B8D-BA48-B056DCDA42C4}';
    IID_ID3D11Device5: TGUID = '{8FFDE202-A0E7-45DF-9E01-E837801B5EA0}';
    IID_ID3D11Multithread: TGUID = '{9B7E4E00-342C-4106-A19F-4F2704F689F0}';
    IID_ID3D11VideoContext2: TGUID = '{C4E7374C-6243-4D1B-AE87-52B4F740E261}';
    IID_ID3D11VideoDevice2: TGUID = '{59C0CB01-35F0-4A70-8F67-87905C906A53}';
    IID_ID3D11VideoContext3: TGUID = '{A9E2FAA0-CB39-418F-A0B7-D8AAD4DE672E}';


type
    REFIID = ^TGUID;

    (* Forward Declarations *)


    ID3D11Device4 = interface;


    ID3D11Device5 = interface;


    ID3D11Multithread = interface;


    ID3D11VideoContext2 = interface;


    ID3D11VideoDevice2 = interface;


    ID3D11VideoContext3 = interface;


    ID3D11Device4 = interface(ID3D11Device3)
        ['{8992ab71-02e6-4b8d-ba48-b056dcda42c4}']
        function RegisterDeviceRemovedEvent(
        {_In_  } hEvent: HANDLE;
        {_Out_  } pdwCookie: PDWORD): HRESULT; stdcall;

        procedure UnregisterDeviceRemoved(
        {_In_  } dwCookie: DWORD); stdcall;

    end;


    ID3D11Device5 = interface(ID3D11Device4)
        ['{8ffde202-a0e7-45df-9e01-e837801b5ea0}']
        function OpenSharedFence(
        {_In_  } hFence: HANDLE;
        {_In_  } ReturnedInterface: REFIID;
        {_COM_Outptr_opt_  }  out ppFence): HRESULT; stdcall;

        function CreateFence(
        {_In_  } InitialValue: uint64;
        {_In_  } Flags: TD3D11_FENCE_FLAG;
        {_In_  } ReturnedInterface: REFIID;
        {_COM_Outptr_opt_  }  out ppFence): HRESULT; stdcall;

    end;


    ID3D11Multithread = interface(IUnknown)
        ['{9B7E4E00-342C-4106-A19F-4F2704F689F0}']
        procedure Enter(); stdcall;

        procedure Leave(); stdcall;

        function SetMultithreadProtected(
        {_In_  } bMTProtect: boolean): boolean; stdcall;

        function GetMultithreadProtected(): boolean; stdcall;

    end;


    ID3D11VideoContext2 = interface(ID3D11VideoContext1)
        ['{C4E7374C-6243-4D1B-AE87-52B4F740E261}']
        procedure VideoProcessorSetOutputHDRMetaData(
        {_In_  } pVideoProcessor: ID3D11VideoProcessor;
        {_In_  } MetaDataType: TDXGI_HDR_METADATA_TYPE;
        {_In_  } Size: UINT;
        {_In_reads_bytes_opt_(Size)  } pHDRMetaData: Pvoid); stdcall;

        procedure VideoProcessorGetOutputHDRMetaData(
        {_In_  } pVideoProcessor: ID3D11VideoProcessor;
        {_Out_  } pType: PDXGI_HDR_METADATA_TYPE;
        {_In_  } Size: UINT;
        {_Out_writes_bytes_opt_(Size)  } pMetaData: Pvoid); stdcall;

        procedure VideoProcessorSetStreamHDRMetaData(
        {_In_  } pVideoProcessor: ID3D11VideoProcessor;
        {_In_  } StreamIndex: UINT;
        {_In_  } MetaDataType: TDXGI_HDR_METADATA_TYPE;
        {_In_  } Size: UINT;
        {_In_reads_bytes_opt_(Size)  } pHDRMetaData: Pvoid); stdcall;

        procedure VideoProcessorGetStreamHDRMetaData(
        {_In_  } pVideoProcessor: ID3D11VideoProcessor;
        {_In_  } StreamIndex: UINT;
        {_Out_  } pType: PDXGI_HDR_METADATA_TYPE;
        {_In_  } Size: UINT;
        {_Out_writes_bytes_opt_(Size)  } pMetaData: Pvoid); stdcall;

    end;


    TD3D11_FEATURE_VIDEO = (
        D3D11_FEATURE_VIDEO_DECODER_HISTOGRAM = 0);

    PD3D11_FEATURE_VIDEO = ^TD3D11_FEATURE_VIDEO;


    TD3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT = (
        D3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_Y = 0,
        D3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_U = 1,
        D3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_V = 2,
        D3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_R = 0,
        D3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_G = 1,
        D3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_B = 2,
        D3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_A = 3);

    PD3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT = ^TD3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT;


    TD3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_FLAGS = (
        D3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_FLAG_NONE = 0,
        D3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_FLAG_Y = (1 shl Ord(D3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_Y)),
        D3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_FLAG_U = (1 shl Ord(D3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_U)),
        D3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_FLAG_V = (1 shl Ord(D3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_V)),
        D3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_FLAG_R = (1 shl Ord(D3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_R)),
        D3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_FLAG_G = (1 shl Ord(D3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_G)),
        D3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_FLAG_B = (1 shl Ord(D3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_B)),
        D3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_FLAG_A = (1 shl Ord(D3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_A)));

    PD3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_FLAGS = ^TD3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_FLAGS;


    TD3D11_FEATURE_DATA_VIDEO_DECODER_HISTOGRAM = record
        DecoderDesc: TD3D11_VIDEO_DECODER_DESC;
        Components: TD3D11_VIDEO_DECODER_HISTOGRAM_COMPONENT_FLAGS;
        BinCount: UINT;
        CounterBitDepth: UINT;
    end;
    PD3D11_FEATURE_DATA_VIDEO_DECODER_HISTOGRAM = ^TD3D11_FEATURE_DATA_VIDEO_DECODER_HISTOGRAM;


    TD3D11_CRYPTO_SESSION_KEY_EXCHANGE_FLAGS = (
        D3D11_CRYPTO_SESSION_KEY_EXCHANGE_FLAG_NONE = 0);

    PD3D11_CRYPTO_SESSION_KEY_EXCHANGE_FLAGS = ^TD3D11_CRYPTO_SESSION_KEY_EXCHANGE_FLAGS;


    ID3D11VideoDevice2 = interface(ID3D11VideoDevice1)
        ['{59C0CB01-35F0-4A70-8F67-87905C906A53}']
        function CheckFeatureSupport(Feature: TD3D11_FEATURE_VIDEO;
        {_Out_writes_bytes_(FeatureSupportDataSize)  } pFeatureSupportData: Pvoid; FeatureSupportDataSize: UINT): HRESULT; stdcall;

        function NegotiateCryptoSessionKeyExchangeMT(
        {_In_  } pCryptoSession: ID3D11CryptoSession;
        {_In_  } flags: TD3D11_CRYPTO_SESSION_KEY_EXCHANGE_FLAGS;
        {_In_  } DataSize: UINT;
        {_Inout_updates_bytes_(DataSize)  } pData: Pvoid): HRESULT; stdcall;

    end;


    TD3D11_VIDEO_DECODER_BUFFER_DESC2 = record
        BufferType: TD3D11_VIDEO_DECODER_BUFFER_TYPE;
        DataOffset: UINT;
        DataSize: UINT; (* [annotation] *)
        {_Field_size_opt_(IVSize)  } pIV: Pvoid;
        IVSize: UINT; (* [annotation] *)
        {_Field_size_opt_(SubSampleMappingCount)  } pSubSampleMappingBlock: PD3D11_VIDEO_DECODER_SUB_SAMPLE_MAPPING_BLOCK;
        SubSampleMappingCount: UINT;
        cBlocksStripeEncrypted: UINT;
        cBlocksStripeClear: UINT;
    end;
    PD3D11_VIDEO_DECODER_BUFFER_DESC2 = ^TD3D11_VIDEO_DECODER_BUFFER_DESC2;


    ID3D11VideoContext3 = interface(ID3D11VideoContext2)
        ['{A9E2FAA0-CB39-418F-A0B7-D8AAD4DE672E}']
        function DecoderBeginFrame1(
        {_In_  } pDecoder: ID3D11VideoDecoder;
        {_In_  } pView: ID3D11VideoDecoderOutputView; ContentKeySize: UINT;
        {_In_reads_bytes_opt_(ContentKeySize)  } pContentKey: Pvoid;
        {_In_range_(0, D3D11_4_VIDEO_DECODER_MAX_HISTOGRAM_COMPONENTS)  } NumComponentHistograms: UINT;
        {_In_reads_opt_(NumComponentHistograms)  } pHistogramOffsets: PUINT;
        {_In_reads_opt_(NumComponentHistograms)  } ppHistogramBuffers: PID3D11Buffer): HRESULT; stdcall;

        function SubmitDecoderBuffers2(
        {_In_  } pDecoder: ID3D11VideoDecoder;
        {_In_  } NumBuffers: UINT;
        {_In_reads_(NumBuffers)  } pBufferDesc: PD3D11_VIDEO_DECODER_BUFFER_DESC2): HRESULT; stdcall;

    end;


    TD3D11_FEATURE_DATA_D3D11_OPTIONS4 = record
        ExtendedNV12SharedTextureSupported: boolean;
    end;
    PD3D11_FEATURE_DATA_D3D11_OPTIONS4 = ^TD3D11_FEATURE_DATA_D3D11_OPTIONS4;


implementation

end.
