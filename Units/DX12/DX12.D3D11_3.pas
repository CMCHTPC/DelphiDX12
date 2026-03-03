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
   File name: d3d11_3.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3D11_3;


{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.DXGIFormat,
    DX12.D3D11,
    DX12.D3DCommon,
    DX12.DXGICommon,
    DX12.D3D11_1,
    DX12.D3D11_2;

    {$Z4}

const

    IID_ID3D11Texture2D1: TGUID = '{51218251-1E33-4617-9CCB-4D3A4367E7BB}';
    IID_ID3D11Texture3D1: TGUID = '{0C711683-2853-4846-9BB0-F3E60639E46A}';
    IID_ID3D11RasterizerState2: TGUID = '{6FBD02FB-209F-46C4-B059-2ED15586A6AC}';
    IID_ID3D11ShaderResourceView1: TGUID = '{91308B87-9040-411D-8C67-C39253CE3802}';
    IID_ID3D11RenderTargetView1: TGUID = '{FFBE2E23-F011-418A-AC56-5CEED7C5B94B}';
    IID_ID3D11UnorderedAccessView1: TGUID = '{7B3B6153-A886-4544-AB37-6537C8500403}';
    IID_ID3D11Query1: TGUID = '{631B4766-36DC-461D-8DB6-C47E13E60916}';
    IID_ID3D11DeviceContext3: TGUID = '{B4E3C01D-E79E-4637-91B2-510E9F4C9B8F}';
    IID_ID3D11Fence: TGUID = '{AFFDE9D1-1DF7-4BB7-8A34-0F46251DAB80}';
    IID_ID3D11DeviceContext4: TGUID = '{917600DA-F58C-4C33-98D8-3E15B390FA24}';
    IID_ID3D11Device3: TGUID = '{A05C8C37-D2C6-4732-B3A0-9CE0B0DC9AE6}';

type


    (* Forward Declarations *)


    ID3D11Texture2D1 = interface;


    ID3D11Texture3D1 = interface;


    ID3D11RasterizerState2 = interface;


    ID3D11ShaderResourceView1 = interface;


    ID3D11RenderTargetView1 = interface;


    ID3D11UnorderedAccessView1 = interface;


    ID3D11Query1 = interface;


    ID3D11DeviceContext3 = interface;


    ID3D11Fence = interface;


    ID3D11DeviceContext4 = interface;


    ID3D11Device3 = interface;

    TD3D11_CONTEXT_TYPE = (
        D3D11_CONTEXT_TYPE_ALL = 0,
        D3D11_CONTEXT_TYPE_3D = 1,
        D3D11_CONTEXT_TYPE_COMPUTE = 2,
        D3D11_CONTEXT_TYPE_COPY = 3,
        D3D11_CONTEXT_TYPE_VIDEO = 4);

    PD3D11_CONTEXT_TYPE = ^TD3D11_CONTEXT_TYPE;

    {$Z2}
    TD3D11_TEXTURE_LAYOUT = (
        D3D11_TEXTURE_LAYOUT_UNDEFINED = 0,
        D3D11_TEXTURE_LAYOUT_ROW_MAJOR = 1,
        D3D11_TEXTURE_LAYOUT_64K_STANDARD_SWIZZLE = 2);
    {$Z4}

    PD3D11_TEXTURE_LAYOUT = ^TD3D11_TEXTURE_LAYOUT;


    { TD3D11_TEXTURE2D_DESC1 }

    TD3D11_TEXTURE2D_DESC1 = record
        Width: UINT;
        Height: UINT;
        MipLevels: UINT;
        ArraySize: UINT;
        Format: TDXGI_FORMAT;
        SampleDesc: TDXGI_SAMPLE_DESC;
        Usage: TD3D11_USAGE;
        BindFlags: UINT;
        CPUAccessFlags: UINT;
        MiscFlags: UINT;
        TextureLayout: TD3D11_TEXTURE_LAYOUT;
        class operator Initialize(var aRec: TD3D11_TEXTURE2D_DESC1);
        procedure Init(format: TDXGI_FORMAT; Width: UINT; Height: UINT; arraySize: UINT = 1; mipLevels: UINT = 0; bindFlags: UINT = Ord(D3D11_BIND_SHADER_RESOURCE); usage: TD3D11_USAGE = D3D11_USAGE_DEFAULT;
            cpuaccessFlags: UINT = 0; sampleCount: UINT = 1; sampleQuality: UINT = 0; miscFlags: UINT = 0; textureLayout: TD3D11_TEXTURE_LAYOUT = D3D11_TEXTURE_LAYOUT_UNDEFINED); overload;
        procedure Init(constref desc: TD3D11_TEXTURE2D_DESC; textureLayout: TD3D11_TEXTURE_LAYOUT = D3D11_TEXTURE_LAYOUT_UNDEFINED); overload;
    end;
    PD3D11_TEXTURE2D_DESC1 = ^TD3D11_TEXTURE2D_DESC1;


    ID3D11Texture2D1 = interface(ID3D11Texture2D)
        ['{51218251-1E33-4617-9CCB-4D3A4367E7BB}']
        procedure GetDesc1(
        {_Out_  } pDesc: PD3D11_TEXTURE2D_DESC1); stdcall;

    end;


    { TD3D11_TEXTURE3D_DESC1 }

    TD3D11_TEXTURE3D_DESC1 = record
        Width: UINT;
        Height: UINT;
        Depth: UINT;
        MipLevels: UINT;
        Format: TDXGI_FORMAT;
        Usage: TD3D11_USAGE;
        BindFlags: UINT;
        CPUAccessFlags: UINT;
        MiscFlags: UINT;
        TextureLayout: TD3D11_TEXTURE_LAYOUT;
        class operator Initialize(var aRec: TD3D11_TEXTURE3D_DESC1);
        procedure Init(format: TDXGI_FORMAT; Width: UINT; Height: UINT; depth: UINT; mipLevels: UINT = 0; bindFlags: UINT = Ord(D3D11_BIND_SHADER_RESOURCE); usage: TD3D11_USAGE = D3D11_USAGE_DEFAULT;
            cpuaccessFlags: UINT = 0; miscFlags: UINT = 0; textureLayout: TD3D11_TEXTURE_LAYOUT = D3D11_TEXTURE_LAYOUT_UNDEFINED); overload;
        procedure Init(constref desc: TD3D11_TEXTURE3D_DESC; textureLayout: TD3D11_TEXTURE_LAYOUT = D3D11_TEXTURE_LAYOUT_UNDEFINED); overload;
    end;
    PD3D11_TEXTURE3D_DESC1 = ^TD3D11_TEXTURE3D_DESC1;


    ID3D11Texture3D1 = interface(ID3D11Texture3D)
        ['{0C711683-2853-4846-9BB0-F3E60639E46A}']
        procedure GetDesc1(
        {_Out_  } pDesc: PD3D11_TEXTURE3D_DESC1); stdcall;

    end;


    TD3D11_CONSERVATIVE_RASTERIZATION_MODE = (
        D3D11_CONSERVATIVE_RASTERIZATION_MODE_OFF = 0,
        D3D11_CONSERVATIVE_RASTERIZATION_MODE_ON = 1);

    PD3D11_CONSERVATIVE_RASTERIZATION_MODE = ^TD3D11_CONSERVATIVE_RASTERIZATION_MODE;


    { TD3D11_RASTERIZER_DESC2 }

    TD3D11_RASTERIZER_DESC2 = record
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
        ConservativeRaster: TD3D11_CONSERVATIVE_RASTERIZATION_MODE;
        class operator Initialize(var aRec: TD3D11_RASTERIZER_DESC2);
        procedure Init(fillMode: TD3D11_FILL_MODE; cullMode: TD3D11_CULL_MODE; frontCounterClockwise: boolean; depthBias: int32; depthBiasClamp: single; slopeScaledDepthBias: single;
            depthClipEnable: boolean; scissorEnable: boolean; multisampleEnable: boolean; antialiasedLineEnable: boolean; forcedSampleCount: UINT; conservativeRaster: TD3D11_CONSERVATIVE_RASTERIZATION_MODE);
    end;
    PD3D11_RASTERIZER_DESC2 = ^TD3D11_RASTERIZER_DESC2;


    ID3D11RasterizerState2 = interface(ID3D11RasterizerState1)
        ['{6fbd02fb-209f-46c4-b059-2ed15586a6ac}']
        procedure GetDesc2(
        {_Out_  } pDesc: PD3D11_RASTERIZER_DESC2); stdcall;

    end;


    TD3D11_TEX2D_SRV1 = record
        MostDetailedMip: UINT;
        MipLevels: UINT;
        PlaneSlice: UINT;
    end;
    PD3D11_TEX2D_SRV1 = ^TD3D11_TEX2D_SRV1;


    TD3D11_TEX2D_ARRAY_SRV1 = record
        MostDetailedMip: UINT;
        MipLevels: UINT;
        FirstArraySlice: UINT;
        ArraySize: UINT;
        PlaneSlice: UINT;
    end;
    PD3D11_TEX2D_ARRAY_SRV1 = ^TD3D11_TEX2D_ARRAY_SRV1;


    { TD3D11_SHADER_RESOURCE_VIEW_DESC1 }

    TD3D11_SHADER_RESOURCE_VIEW_DESC1 = record
        Format: TDXGI_FORMAT;
        ViewDimension: TD3D11_SRV_DIMENSION;
        class operator Initialize(var aRec: TD3D11_SHADER_RESOURCE_VIEW_DESC1);
        procedure Init(viewDimension: TD3D11_SRV_DIMENSION; format: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN; mostDetailedMip: UINT = 0; // FirstElement for BUFFER
            mipLevels: UINT = -1; // NumElements for BUFFER
            firstArraySlice: UINT = 0; // First2DArrayFace for TEXTURECUBEARRAY
            arraySize: UINT = -1; // NumCubes for TEXTURECUBEARRAY
            flags: UINT = 0; // BUFFEREX only
            planeSlice: UINT = 0); overload; // Texture2D and Texture2DArray only
        procedure Init({_In_ } Nameless1: ID3D11Buffer; format: TDXGI_FORMAT; firstElement: UINT; numElements: UINT; flags: UINT = 0); overload;
        procedure Init({_In_ } pTex1D: ID3D11Texture1D; viewDimension: TD3D11_SRV_DIMENSION; format: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN; mostDetailedMip: UINT = 0; mipLevels: UINT = -1;
            firstArraySlice: UINT = 0; arraySize: UINT = -1); overload;
        procedure Init(
        {_In_}  pTex2D: ID3D11Texture2D; viewDimension: TD3D11_SRV_DIMENSION; format: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN; mostDetailedMip: UINT = 0; mipLevels: UINT = -1; firstArraySlice: UINT = 0; // First2DArrayFace for TEXTURECUBEARRAY
            arraySize: UINT = -1;  // NumCubes for TEXTURECUBEARRAY
            planeSlice: UINT = 0); overload; // PlaneSlice for TEXTURE2D or TEXTURE2DARRAY
        procedure Init(
        {_In_}  pTex3D: ID3D11Texture3D; format: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN; mipLevels: UINT = -1; mostDetailedMip: UINT = 0); overload;

        case integer of
            0: (
                Buffer: TD3D11_BUFFER_SRV;
            );
            1: (
                Texture1D: TD3D11_TEX1D_SRV;
            );
            2: (
                Texture1DArray: TD3D11_TEX1D_ARRAY_SRV;
            );
            3: (
                Texture2D: TD3D11_TEX2D_SRV1;
            );
            4: (
                Texture2DArray: TD3D11_TEX2D_ARRAY_SRV1;
            );
            5: (
                Texture2DMS: TD3D11_TEX2DMS_SRV;
            );
            6: (
                Texture2DMSArray: TD3D11_TEX2DMS_ARRAY_SRV;
            );
            7: (
                Texture3D: TD3D11_TEX3D_SRV;
            );
            8: (
                TextureCube: TD3D11_TEXCUBE_SRV;
            );
            9: (
                TextureCubeArray: TD3D11_TEXCUBE_ARRAY_SRV;
            );
            10: (
                BufferEx: TD3D11_BUFFEREX_SRV;
            );
    end;
    PD3D11_SHADER_RESOURCE_VIEW_DESC1 = ^TD3D11_SHADER_RESOURCE_VIEW_DESC1;


    ID3D11ShaderResourceView1 = interface(ID3D11ShaderResourceView)
        ['{91308b87-9040-411d-8c67-c39253ce3802}']
        procedure GetDesc1(
        {_Out_  } pDesc1: PD3D11_SHADER_RESOURCE_VIEW_DESC1); stdcall;

    end;


    TD3D11_TEX2D_RTV1 = record
        MipSlice: UINT;
        PlaneSlice: UINT;
    end;
    PD3D11_TEX2D_RTV1 = ^TD3D11_TEX2D_RTV1;


    TD3D11_TEX2D_ARRAY_RTV1 = record
        MipSlice: UINT;
        FirstArraySlice: UINT;
        ArraySize: UINT;
        PlaneSlice: UINT;
    end;
    PD3D11_TEX2D_ARRAY_RTV1 = ^TD3D11_TEX2D_ARRAY_RTV1;


    { TD3D11_RENDER_TARGET_VIEW_DESC1 }

    TD3D11_RENDER_TARGET_VIEW_DESC1 = record
        Format: TDXGI_FORMAT;
        ViewDimension: TD3D11_RTV_DIMENSION;
        class operator Initialize(var aRec: TD3D11_RENDER_TARGET_VIEW_DESC1);
        procedure Init(viewDimension: TD3D11_RTV_DIMENSION; format: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN; mipSlice: UINT = 0; // FirstElement for BUFFER
            firstArraySlice: UINT = 0; // NumElements for BUFFER, FirstWSlice for TEXTURE3D
            arraySize: UINT = -1; // WSize for TEXTURE3D
            planeSlice: UINT = 0); overload; // PlaneSlice for TEXTURE2D and TEXTURE2DARRAY
        procedure Init(
        {_In_} Buffer: ID3D11Buffer; format: TDXGI_FORMAT; firstElement: UINT; numElements: UINT); overload;
        procedure Init(
        {_In_}  pTex1D: ID3D11Texture1D; viewDimension: TD3D11_RTV_DIMENSION; format: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN; mipSlice: UINT = 0; firstArraySlice: UINT = 0; arraySize: UINT = -1); overload;

        procedure Init(
        {_In_}  pTex2D: ID3D11Texture2D; viewDimension: TD3D11_RTV_DIMENSION; format: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN; mipSlice: UINT = 0; firstArraySlice: UINT = 0; arraySize: UINT = -1; planeSlice: UINT = 0); overload;
        procedure Init(
        {_In_}  pTex3D: ID3D11Texture3D; format: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN; mipSlice: UINT = 0; firstWSlice: UINT = 0; wSize: UINT = -1); overload;
        case integer of
            0: (
                Buffer: TD3D11_BUFFER_RTV;
            );
            1: (
                Texture1D: TD3D11_TEX1D_RTV;
            );
            2: (
                Texture1DArray: TD3D11_TEX1D_ARRAY_RTV;
            );
            3: (
                Texture2D: TD3D11_TEX2D_RTV1;
            );
            4: (
                Texture2DArray: TD3D11_TEX2D_ARRAY_RTV1;
            );
            5: (
                Texture2DMS: TD3D11_TEX2DMS_RTV;
            );
            6: (
                Texture2DMSArray: TD3D11_TEX2DMS_ARRAY_RTV;
            );
            7: (
                Texture3D: TD3D11_TEX3D_RTV;
            );
    end;
    PD3D11_RENDER_TARGET_VIEW_DESC1 = ^TD3D11_RENDER_TARGET_VIEW_DESC1;


    ID3D11RenderTargetView1 = interface(ID3D11RenderTargetView)
        ['{ffbe2e23-f011-418a-ac56-5ceed7c5b94b}']
        procedure GetDesc1(
        {_Out_  } pDesc1: PD3D11_RENDER_TARGET_VIEW_DESC1); stdcall;

    end;


    TD3D11_TEX2D_UAV1 = record
        MipSlice: UINT;
        PlaneSlice: UINT;
    end;
    PD3D11_TEX2D_UAV1 = ^TD3D11_TEX2D_UAV1;


    TD3D11_TEX2D_ARRAY_UAV1 = record
        MipSlice: UINT;
        FirstArraySlice: UINT;
        ArraySize: UINT;
        PlaneSlice: UINT;
    end;
    PD3D11_TEX2D_ARRAY_UAV1 = ^TD3D11_TEX2D_ARRAY_UAV1;


    { TD3D11_UNORDERED_ACCESS_VIEW_DESC1 }

    TD3D11_UNORDERED_ACCESS_VIEW_DESC1 = record
        Format: TDXGI_FORMAT;
        ViewDimension: TD3D11_UAV_DIMENSION;
        class operator Initialize(var aRec: TD3D11_UNORDERED_ACCESS_VIEW_DESC1);
        procedure Init(viewDimension: TD3D11_UAV_DIMENSION; format: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN; mipSlice: UINT = 0; // FirstElement for BUFFER
            firstArraySlice: UINT = 0; // NumElements for BUFFER, FirstWSlice for TEXTURE3D
            arraySize: UINT = -1; // WSize for TEXTURE3D
            flags: UINT = 0; // BUFFER only
            planeSlice: UINT = 0); overload; // PlaneSlice for TEXTURE2D and TEXTURE2DARRAY
        procedure Init({_In_} Buffer: ID3D11Buffer; format: TDXGI_FORMAT; firstElement: UINT; numElements: UINT; flags: UINT = 0); overload;
        procedure Init({_In_} pTex1D: ID3D11Texture1D; viewDimension: TD3D11_UAV_DIMENSION; format: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN; mipSlice: UINT = 0; firstArraySlice: UINT = 0; arraySize: UINT = -1); overload;
        procedure Init({_In_} pTex2D: ID3D11Texture2D; viewDimension: TD3D11_UAV_DIMENSION; format: TDXGI_FORMAT; mipSlice: UINT; firstArraySlice: UINT; arraySize: UINT; planeSlice: UINT); overload;
        procedure Init({_In_} pTex3D: ID3D11Texture3D; format: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN; mipSlice: UINT = 0; firstWSlice: UINT = 0; wSize: UINT = -1); overload;
        case integer of
            0: (
                Buffer: TD3D11_BUFFER_UAV;
            );
            1: (
                Texture1D: TD3D11_TEX1D_UAV;
            );
            2: (
                Texture1DArray: TD3D11_TEX1D_ARRAY_UAV;
            );
            3: (
                Texture2D: TD3D11_TEX2D_UAV1;
            );
            4: (
                Texture2DArray: TD3D11_TEX2D_ARRAY_UAV1;
            );
            5: (
                Texture3D: TD3D11_TEX3D_UAV;
            );
    end;
    PD3D11_UNORDERED_ACCESS_VIEW_DESC1 = ^TD3D11_UNORDERED_ACCESS_VIEW_DESC1;


    ID3D11UnorderedAccessView1 = interface(ID3D11UnorderedAccessView)
        ['{7b3b6153-a886-4544-ab37-6537c8500403}']
        procedure GetDesc1(
        {_Out_  } pDesc1: PD3D11_UNORDERED_ACCESS_VIEW_DESC1); stdcall;

    end;


    { TD3D11_QUERY_DESC1 }

    TD3D11_QUERY_DESC1 = record
        Query: TD3D11_QUERY;
        MiscFlags: UINT;
        ContextType: TD3D11_CONTEXT_TYPE;
        procedure Init(query: TD3D11_QUERY; miscFlags: UINT = 0; contextType: TD3D11_CONTEXT_TYPE = D3D11_CONTEXT_TYPE_ALL);
    end;
    PD3D11_QUERY_DESC1 = ^TD3D11_QUERY_DESC1;


    ID3D11Query1 = interface(ID3D11Query)
        ['{631b4766-36dc-461d-8db6-c47e13e60916}']
        procedure GetDesc1(
        {_Out_  } pDesc1: PD3D11_QUERY_DESC1); stdcall;

    end;


    TD3D11_FENCE_FLAG = (
        D3D11_FENCE_FLAG_NONE = 0,
        D3D11_FENCE_FLAG_SHARED = $2,
        D3D11_FENCE_FLAG_SHARED_CROSS_ADAPTER = $4,
        D3D11_FENCE_FLAG_NON_MONITORED = $8);

    PD3D11_FENCE_FLAG = ^TD3D11_FENCE_FLAG;


    ID3D11DeviceContext3 = interface(ID3D11DeviceContext2)
        ['{b4e3c01d-e79e-4637-91b2-510e9f4c9b8f}']
        procedure Flush1(ContextType: TD3D11_CONTEXT_TYPE;
        {_In_opt_  } hEvent: HANDLE); stdcall;

        procedure SetHardwareProtectionState(
        {_In_  } HwProtectionEnable: boolean); stdcall;

        procedure GetHardwareProtectionState(
        {_Out_  } pHwProtectionEnable: Pboolean); stdcall;

    end;


    ID3D11Fence = interface(ID3D11DeviceChild)
        ['{affde9d1-1df7-4bb7-8a34-0f46251dab80}']
        function CreateSharedHandle(
        {_In_opt_  } pAttributes: PSECURITY_ATTRIBUTES;
        {_In_  } dwAccess: DWORD;
        {_In_opt_  } lpName: LPCWSTR;
        {_Out_  } pHandle: PHANDLE): HRESULT; stdcall;

        function GetCompletedValue(): uint64; stdcall;

        function SetEventOnCompletion(
        {_In_  } Value: uint64;
        {_In_  } hEvent: HANDLE): HRESULT; stdcall;

    end;


    ID3D11DeviceContext4 = interface(ID3D11DeviceContext3)
        ['{917600da-f58c-4c33-98d8-3e15b390fa24}']
        function Signal(
        {_In_  } pFence: ID3D11Fence;
        {_In_  } Value: uint64): HRESULT; stdcall;

        function Wait(
        {_In_  } pFence: ID3D11Fence;
        {_In_  } Value: uint64): HRESULT; stdcall;

    end;


    ID3D11Device3 = interface(ID3D11Device2)
        ['{A05C8C37-D2C6-4732-B3A0-9CE0B0DC9AE6}']
        function CreateTexture2D1(
        {_In_  } pDesc1: PD3D11_TEXTURE2D_DESC1;
        {_In_reads_opt_(_Inexpressible_(pDesc1->MipLevels * pDesc1->ArraySize))  } pInitialData: PD3D11_SUBRESOURCE_DATA;
        {_COM_Outptr_opt_  }  out ppTexture2D: ID3D11Texture2D1): HRESULT; stdcall;

        function CreateTexture3D1(
        {_In_  } pDesc1: PD3D11_TEXTURE3D_DESC1;
        {_In_reads_opt_(_Inexpressible_(pDesc1->MipLevels))  } pInitialData: PD3D11_SUBRESOURCE_DATA;
        {_COM_Outptr_opt_  }  out ppTexture3D: ID3D11Texture3D1): HRESULT; stdcall;

        function CreateRasterizerState2(
        {_In_  } pRasterizerDesc: PD3D11_RASTERIZER_DESC2;
        {_COM_Outptr_opt_  }  out ppRasterizerState: ID3D11RasterizerState2): HRESULT; stdcall;

        function CreateShaderResourceView1(
        {_In_  } pResource: ID3D11Resource;
        {_In_opt_  } pDesc1: PD3D11_SHADER_RESOURCE_VIEW_DESC1;
        {_COM_Outptr_opt_  }  out ppSRView1: ID3D11ShaderResourceView1): HRESULT; stdcall;

        function CreateUnorderedAccessView1(
        {_In_  } pResource: ID3D11Resource;
        {_In_opt_  } pDesc1: PD3D11_UNORDERED_ACCESS_VIEW_DESC1;
        {_COM_Outptr_opt_  }  out ppUAView1: ID3D11UnorderedAccessView1): HRESULT; stdcall;

        function CreateRenderTargetView1(
        {_In_  } pResource: ID3D11Resource;
        {_In_opt_  } pDesc1: PD3D11_RENDER_TARGET_VIEW_DESC1;
        {_COM_Outptr_opt_  }  out ppRTView1: ID3D11RenderTargetView1): HRESULT; stdcall;

        function CreateQuery1(
        {_In_  } pQueryDesc1: PD3D11_QUERY_DESC1;
        {_COM_Outptr_opt_  }  out ppQuery1: ID3D11Query1): HRESULT; stdcall;

        procedure GetImmediateContext3(
        {_Outptr_  }  out ppImmediateContext: ID3D11DeviceContext3); stdcall;

        function CreateDeferredContext3(ContextFlags: UINT;
        {_COM_Outptr_opt_  }  out ppDeferredContext: ID3D11DeviceContext3): HRESULT; stdcall;

        procedure WriteToSubresource(
        {_In_  } pDstResource: ID3D11Resource;
        {_In_  } DstSubresource: UINT;
        {_In_opt_  } pDstBox: PD3D11_BOX;
        {_In_  } pSrcData: Pvoid;
        {_In_  } SrcRowPitch: UINT;
        {_In_  } SrcDepthPitch: UINT); stdcall;

        procedure ReadFromSubresource(
        {_Out_  } pDstData: Pvoid;
        {_In_  } DstRowPitch: UINT;
        {_In_  } DstDepthPitch: UINT;
        {_In_  } pSrcResource: ID3D11Resource;
        {_In_  } SrcSubresource: UINT;
        {_In_opt_  } pSrcBox: PD3D11_BOX); stdcall;

    end;


implementation

{ TD3D11_TEXTURE2D_DESC1 }

class operator TD3D11_TEXTURE2D_DESC1.Initialize(var aRec: TD3D11_TEXTURE2D_DESC1);
begin
    aRec.Width := 0;
    aRec.Height := 0;
    aRec.MipLevels := 0;
    aRec.ArraySize := 1;
    aRec.Format := DXGI_FORMAT_UNKNOWN;
    aRec.SampleDesc.Count := 1;
    aRec.SampleDesc.Quality := 0;
    aRec.Usage := D3D11_USAGE_DEFAULT;
    aRec.BindFlags := Ord(D3D11_BIND_SHADER_RESOURCE);
    aRec.CPUAccessFlags := 0;
    aRec.MiscFlags := 0;
    aRec.TextureLayout := D3D11_TEXTURE_LAYOUT_UNDEFINED;
end;



procedure TD3D11_TEXTURE2D_DESC1.Init(format: TDXGI_FORMAT; Width: UINT; Height: UINT; arraySize: UINT; mipLevels: UINT; bindFlags: UINT; usage: TD3D11_USAGE; cpuaccessFlags: UINT;
    sampleCount: UINT; sampleQuality: UINT; miscFlags: UINT; textureLayout: TD3D11_TEXTURE_LAYOUT);
begin
    Self.Width := Width;
    Self.Height := Height;
    Self.MipLevels := mipLevels;
    Self.ArraySize := arraySize;
    Self.Format := format;
    Self.SampleDesc.Count := sampleCount;
    Self.SampleDesc.Quality := sampleQuality;
    Self.Usage := usage;
    Self.BindFlags := bindFlags;
    Self.CPUAccessFlags := cpuaccessFlags;
    Self.MiscFlags := miscFlags;
    Self.TextureLayout := textureLayout;
end;



procedure TD3D11_TEXTURE2D_DESC1.Init(constref desc: TD3D11_TEXTURE2D_DESC; textureLayout: TD3D11_TEXTURE_LAYOUT);
begin
    Self.Width := desc.Width;
    Self.Height := desc.Height;
    Self.MipLevels := desc.MipLevels;
    Self.ArraySize := desc.ArraySize;
    Self.Format := desc.Format;
    Self.SampleDesc.Count := desc.SampleDesc.Count;
    Self.SampleDesc.Quality := desc.SampleDesc.Quality;
    Self.Usage := desc.Usage;
    Self.BindFlags := desc.BindFlags;
    Self.CPUAccessFlags := desc.CPUAccessFlags;
    Self.MiscFlags := desc.MiscFlags;
    Self.TextureLayout := textureLayout;
end;

{ TD3D11_TEXTURE3D_DESC1 }

class operator TD3D11_TEXTURE3D_DESC1.Initialize(var aRec: TD3D11_TEXTURE3D_DESC1);
begin
    aRec.Width := 0;
    aRec.Height := 0;
    aRec.Depth := 0;
    aRec.MipLevels := 0;
    aRec.Format := DXGI_FORMAT_UNKNOWN;
    aRec.Usage := D3D11_USAGE_DEFAULT;
    aRec.BindFlags := Ord(D3D11_BIND_SHADER_RESOURCE);
    aRec.CPUAccessFlags := 0;
    aRec.MiscFlags := 0;
    aRec.TextureLayout := D3D11_TEXTURE_LAYOUT_UNDEFINED;
end;



procedure TD3D11_TEXTURE3D_DESC1.Init(format: TDXGI_FORMAT; Width: UINT; Height: UINT; depth: UINT; mipLevels: UINT; bindFlags: UINT; usage: TD3D11_USAGE; cpuaccessFlags: UINT; miscFlags: UINT; textureLayout: TD3D11_TEXTURE_LAYOUT);
begin
    self.Width := Width;
    self.Height := Height;
    self.Depth := depth;
    self.MipLevels := mipLevels;
    self.Format := format;
    self.Usage := usage;
    self.BindFlags := bindFlags;
    self.CPUAccessFlags := cpuaccessFlags;
    self.MiscFlags := miscFlags;
    self.TextureLayout := textureLayout;
end;



procedure TD3D11_TEXTURE3D_DESC1.Init(constref desc: TD3D11_TEXTURE3D_DESC; textureLayout: TD3D11_TEXTURE_LAYOUT);
begin
    self.Width := desc.Width;
    self.Height := desc.Height;
    self.Depth := desc.Depth;
    self.MipLevels := desc.MipLevels;
    self.Format := desc.Format;
    self.Usage := desc.Usage;
    self.BindFlags := desc.BindFlags;
    self.CPUAccessFlags := desc.CPUAccessFlags;
    self.MiscFlags := desc.MiscFlags;
    self.TextureLayout := textureLayout;
end;

{ TD3D11_RASTERIZER_DESC2 }

class operator TD3D11_RASTERIZER_DESC2.Initialize(var aRec: TD3D11_RASTERIZER_DESC2);
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
    aRec.ConservativeRaster := D3D11_CONSERVATIVE_RASTERIZATION_MODE_OFF;
end;



procedure TD3D11_RASTERIZER_DESC2.Init(fillMode: TD3D11_FILL_MODE; cullMode: TD3D11_CULL_MODE; frontCounterClockwise: boolean; depthBias: int32; depthBiasClamp: single; slopeScaledDepthBias: single;
    depthClipEnable: boolean; scissorEnable: boolean; multisampleEnable: boolean; antialiasedLineEnable: boolean; forcedSampleCount: UINT; conservativeRaster: TD3D11_CONSERVATIVE_RASTERIZATION_MODE);
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
    Self.ConservativeRaster := conservativeRaster;
end;

{ TD3D11_SHADER_RESOURCE_VIEW_DESC1 }

class operator TD3D11_SHADER_RESOURCE_VIEW_DESC1.Initialize(var aRec: TD3D11_SHADER_RESOURCE_VIEW_DESC1);
begin

end;



procedure TD3D11_SHADER_RESOURCE_VIEW_DESC1.Init(viewDimension: TD3D11_SRV_DIMENSION; format: TDXGI_FORMAT; mostDetailedMip: UINT; mipLevels: UINT; firstArraySlice: UINT; arraySize: UINT; flags: UINT; planeSlice: UINT);
begin
    Self.Format := format;
    Self.ViewDimension := viewDimension;
    case (viewDimension) of

        D3D11_SRV_DIMENSION_BUFFER:
        begin
            Buffer.FirstElement := mostDetailedMip;
            Buffer.NumElements := mipLevels;
        end;
        D3D11_SRV_DIMENSION_TEXTURE1D:
        begin
            Texture1D.MostDetailedMip := mostDetailedMip;
            Texture1D.MipLevels := mipLevels;
        end;
        D3D11_SRV_DIMENSION_TEXTURE1DARRAY:
        begin
            Texture1DArray.MostDetailedMip := mostDetailedMip;
            Texture1DArray.MipLevels := mipLevels;
            Texture1DArray.FirstArraySlice := firstArraySlice;
            Texture1DArray.ArraySize := arraySize;
        end;
        D3D11_SRV_DIMENSION_TEXTURE2D:
        begin
            Texture2D.MostDetailedMip := mostDetailedMip;
            Texture2D.MipLevels := mipLevels;
            Texture2D.PlaneSlice := planeSlice;
        end;
        D3D11_SRV_DIMENSION_TEXTURE2DARRAY:
        begin
            Texture2DArray.MostDetailedMip := mostDetailedMip;
            Texture2DArray.MipLevels := mipLevels;
            Texture2DArray.FirstArraySlice := firstArraySlice;
            Texture2DArray.ArraySize := arraySize;
            Texture2DArray.PlaneSlice := planeSlice;
        end;
        D3D11_SRV_DIMENSION_TEXTURE2DMS:
        begin
        end;
        D3D11_SRV_DIMENSION_TEXTURE2DMSARRAY:
        begin
            Texture2DMSArray.FirstArraySlice := firstArraySlice;
            Texture2DMSArray.ArraySize := arraySize;
        end;
        D3D11_SRV_DIMENSION_TEXTURE3D:
        begin
            Texture3D.MostDetailedMip := mostDetailedMip;
            Texture3D.MipLevels := mipLevels;
        end;
        D3D11_SRV_DIMENSION_TEXTURECUBE:
        begin
            TextureCube.MostDetailedMip := mostDetailedMip;
            TextureCube.MipLevels := mipLevels;
        end;
        D3D11_SRV_DIMENSION_TEXTURECUBEARRAY:
        begin
            TextureCubeArray.MostDetailedMip := mostDetailedMip;
            TextureCubeArray.MipLevels := mipLevels;
            TextureCubeArray.First2DArrayFace := firstArraySlice;
            TextureCubeArray.NumCubes := arraySize;
        end;
        D3D11_SRV_DIMENSION_BUFFEREX:
        begin
            BufferEx.FirstElement := mostDetailedMip;
            BufferEx.NumElements := mipLevels;
            BufferEx.Flags := flags;
        end;
    end;
end;



procedure TD3D11_SHADER_RESOURCE_VIEW_DESC1.Init(Nameless1: ID3D11Buffer; format: TDXGI_FORMAT; firstElement: UINT; numElements: UINT; flags: UINT);
begin
    Self.Format := format;
    Self.ViewDimension := D3D11_SRV_DIMENSION_BUFFEREX;
    Self.BufferEx.FirstElement := firstElement;
    Self.BufferEx.NumElements := numElements;
    Self.BufferEx.Flags := flags;
end;



procedure TD3D11_SHADER_RESOURCE_VIEW_DESC1.Init(pTex1D: ID3D11Texture1D; viewDimension: TD3D11_SRV_DIMENSION; format: TDXGI_FORMAT; mostDetailedMip: UINT; mipLevels: UINT; firstArraySlice: UINT; arraySize: UINT);
var
    TexDesc: TD3D11_TEXTURE1D_DESC;
begin
    Self.ViewDimension := viewDimension;
    if (DXGI_FORMAT_UNKNOWN = format) or (UINT(-1) = mipLevels) or ((UINT(-1) = arraySize) and (D3D11_SRV_DIMENSION_TEXTURE1DARRAY = viewDimension)) then
    begin

        pTex1D.GetDesc(@TexDesc);
        if (DXGI_FORMAT_UNKNOWN = format) then format := TexDesc.Format;
        if (UINT(-1) = mipLevels) then mipLevels := TexDesc.MipLevels - mostDetailedMip;
        if (UINT(-1) = arraySize) then arraySize := TexDesc.ArraySize - firstArraySlice;
    end;
    Self.Format := format;
    case (viewDimension) of

        D3D11_SRV_DIMENSION_TEXTURE1D:
        begin
            Texture1D.MostDetailedMip := mostDetailedMip;
            Texture1D.MipLevels := mipLevels;
        end;
        D3D11_SRV_DIMENSION_TEXTURE1DARRAY:
        begin
            Texture1DArray.MostDetailedMip := mostDetailedMip;
            Texture1DArray.MipLevels := mipLevels;
            Texture1DArray.FirstArraySlice := firstArraySlice;
            Texture1DArray.ArraySize := arraySize;
        end;
    end;
end;



procedure TD3D11_SHADER_RESOURCE_VIEW_DESC1.Init(pTex2D: ID3D11Texture2D; viewDimension: TD3D11_SRV_DIMENSION; format: TDXGI_FORMAT; mostDetailedMip: UINT; mipLevels: UINT; firstArraySlice: UINT; arraySize: UINT; planeSlice: UINT);
var
    TexDesc: TD3D11_TEXTURE2D_DESC;
begin
    Self.ViewDimension := viewDimension;
    if (DXGI_FORMAT_UNKNOWN = format) or ((UINT(-1) = mipLevels) and (D3D11_SRV_DIMENSION_TEXTURE2DMS <> viewDimension) and (D3D11_SRV_DIMENSION_TEXTURE2DMSARRAY <> viewDimension)) or
        ((UINT(-1) = arraySize) and ((D3D11_SRV_DIMENSION_TEXTURE2DARRAY = viewDimension) or (D3D11_SRV_DIMENSION_TEXTURE2DMSARRAY = viewDimension) or (D3D11_SRV_DIMENSION_TEXTURECUBEARRAY = viewDimension))) then
    begin

        pTex2D.GetDesc(@TexDesc);
        if (DXGI_FORMAT_UNKNOWN = format) then format := TexDesc.Format;
        if (UINT(-1) = mipLevels) then mipLevels := TexDesc.MipLevels - mostDetailedMip;
        if (UINT(-1) = arraySize) then
        begin
            arraySize := TexDesc.ArraySize - firstArraySlice;
            if (D3D11_SRV_DIMENSION_TEXTURECUBEARRAY = viewDimension) then arraySize := arraySize div 6;
        end;
    end;
    Self.Format := format;
    case (viewDimension) of

        D3D11_SRV_DIMENSION_TEXTURE2D:
        begin
            Texture2D.MostDetailedMip := mostDetailedMip;
            Texture2D.MipLevels := mipLevels;
            Texture2D.PlaneSlice := planeSlice;
        end;
        D3D11_SRV_DIMENSION_TEXTURE2DARRAY:
        begin
            Texture2DArray.MostDetailedMip := mostDetailedMip;
            Texture2DArray.MipLevels := mipLevels;
            Texture2DArray.FirstArraySlice := firstArraySlice;
            Texture2DArray.ArraySize := arraySize;
            Texture2DArray.PlaneSlice := planeSlice;
        end;
        D3D11_SRV_DIMENSION_TEXTURE2DMS:
        begin
        end;
        D3D11_SRV_DIMENSION_TEXTURE2DMSARRAY:
        begin
            Texture2DMSArray.FirstArraySlice := firstArraySlice;
            Texture2DMSArray.ArraySize := arraySize;
        end;
        D3D11_SRV_DIMENSION_TEXTURECUBE:
        begin
            TextureCube.MostDetailedMip := mostDetailedMip;
            TextureCube.MipLevels := mipLevels;
        end;
        D3D11_SRV_DIMENSION_TEXTURECUBEARRAY:
        begin
            TextureCubeArray.MostDetailedMip := mostDetailedMip;
            TextureCubeArray.MipLevels := mipLevels;
            TextureCubeArray.First2DArrayFace := firstArraySlice;
            TextureCubeArray.NumCubes := arraySize;
        end;
    end;
end;



procedure TD3D11_SHADER_RESOURCE_VIEW_DESC1.Init(pTex3D: ID3D11Texture3D; format: TDXGI_FORMAT; mipLevels: UINT; mostDetailedMip: UINT);
var
    TexDesc: TD3D11_TEXTURE3D_DESC;
begin
    Self.ViewDimension := D3D11_SRV_DIMENSION_TEXTURE3D;
    if (DXGI_FORMAT_UNKNOWN = format) or (UINT(-1) = mipLevels) then
    begin
        pTex3D.GetDesc(@TexDesc);
        if (DXGI_FORMAT_UNKNOWN = format) then format := TexDesc.Format;
        if (UINT(-1) = mipLevels) then mipLevels := TexDesc.MipLevels - mostDetailedMip;
    end;
    Self.Format := format;
    Texture3D.MostDetailedMip := mostDetailedMip;
    Texture3D.MipLevels := mipLevels;
end;

{ TD3D11_RENDER_TARGET_VIEW_DESC1 }

class operator TD3D11_RENDER_TARGET_VIEW_DESC1.Initialize(var aRec: TD3D11_RENDER_TARGET_VIEW_DESC1);
begin
    ZeroMemory(@arec, SizeOf(Arec));
end;



procedure TD3D11_RENDER_TARGET_VIEW_DESC1.Init(viewDimension: TD3D11_RTV_DIMENSION; format: TDXGI_FORMAT; mipSlice: UINT; firstArraySlice: UINT; arraySize: UINT; planeSlice: UINT);
begin
    Format := format;
    ViewDimension := viewDimension;
    case (viewDimension) of

        D3D11_RTV_DIMENSION_BUFFER:
        begin
            Buffer.FirstElement := mipSlice;
            Buffer.NumElements := firstArraySlice;
        end;
        D3D11_RTV_DIMENSION_TEXTURE1D:
        begin
            Texture1D.MipSlice := mipSlice;
        end;
        D3D11_RTV_DIMENSION_TEXTURE1DARRAY:
        begin
            Texture1DArray.MipSlice := mipSlice;
            Texture1DArray.FirstArraySlice := firstArraySlice;
            Texture1DArray.ArraySize := arraySize;
        end;
        D3D11_RTV_DIMENSION_TEXTURE2D:
        begin
            Texture2D.MipSlice := mipSlice;
            Texture2D.PlaneSlice := planeSlice;
        end;
        D3D11_RTV_DIMENSION_TEXTURE2DARRAY:
        begin
            Texture2DArray.MipSlice := mipSlice;
            Texture2DArray.FirstArraySlice := firstArraySlice;
            Texture2DArray.ArraySize := arraySize;
            Texture2DArray.PlaneSlice := planeSlice;
        end;
        D3D11_RTV_DIMENSION_TEXTURE2DMS:
        begin
        end;
        D3D11_RTV_DIMENSION_TEXTURE2DMSARRAY:
        begin
            Texture2DMSArray.FirstArraySlice := firstArraySlice;
            Texture2DMSArray.ArraySize := arraySize;
        end;
        D3D11_RTV_DIMENSION_TEXTURE3D:
        begin
            Texture3D.MipSlice := mipSlice;
            Texture3D.FirstWSlice := firstArraySlice;
            Texture3D.WSize := arraySize;
        end;
    end;
end;



procedure TD3D11_RENDER_TARGET_VIEW_DESC1.Init(Buffer: ID3D11Buffer; format: TDXGI_FORMAT; firstElement: UINT; numElements: UINT);
begin
    Self.Format := format;
    Self.ViewDimension := D3D11_RTV_DIMENSION_BUFFER;
    Self.Buffer.FirstElement := firstElement;
    Self.Buffer.NumElements := numElements;
end;



procedure TD3D11_RENDER_TARGET_VIEW_DESC1.Init(pTex1D: ID3D11Texture1D; viewDimension: TD3D11_RTV_DIMENSION; format: TDXGI_FORMAT; mipSlice: UINT; firstArraySlice: UINT; arraySize: UINT);
var
    TexDesc: TD3D11_TEXTURE1D_DESC;
begin
    ViewDimension := viewDimension;
    if (DXGI_FORMAT_UNKNOWN = format) or ((UINT(-1) = arraySize) and (D3D11_RTV_DIMENSION_TEXTURE1DARRAY = viewDimension)) then
    begin

        pTex1D.GetDesc(@TexDesc);
        if (DXGI_FORMAT_UNKNOWN = format) then  format := TexDesc.Format;
        if (UINT(-1) = arraySize) then  arraySize := TexDesc.ArraySize - firstArraySlice;
    end;
    Format := format;
    case (viewDimension) of

        D3D11_RTV_DIMENSION_TEXTURE1D:
        begin
            Texture1D.MipSlice := mipSlice;
        end;
        D3D11_RTV_DIMENSION_TEXTURE1DARRAY:
        begin
            Texture1DArray.MipSlice := mipSlice;
            Texture1DArray.FirstArraySlice := firstArraySlice;
            Texture1DArray.ArraySize := arraySize;
        end;
    end;
end;



procedure TD3D11_RENDER_TARGET_VIEW_DESC1.Init(pTex2D: ID3D11Texture2D; viewDimension: TD3D11_RTV_DIMENSION; format: TDXGI_FORMAT; mipSlice: UINT; firstArraySlice: UINT; arraySize: UINT; planeSlice: UINT);
var
    TexDesc: TD3D11_TEXTURE2D_DESC;
begin
    Self.ViewDimension := viewDimension;
    if (DXGI_FORMAT_UNKNOWN = format) or ((UINT(-1) = arraySize) and ((D3D11_RTV_DIMENSION_TEXTURE2DARRAY = viewDimension) or (D3D11_RTV_DIMENSION_TEXTURE2DMSARRAY = viewDimension))) then
    begin

        pTex2D.GetDesc(@TexDesc);
        if (DXGI_FORMAT_UNKNOWN = format) then format := TexDesc.Format;
        if (UINT(-1) = arraySize) then arraySize := TexDesc.ArraySize - firstArraySlice;
    end;
    Self.Format := format;
    case (viewDimension) of

        D3D11_RTV_DIMENSION_TEXTURE2D:
        begin
            Texture2D.MipSlice := mipSlice;
            Texture2D.PlaneSlice := planeSlice;
        end;
        D3D11_RTV_DIMENSION_TEXTURE2DARRAY:
        begin
            Texture2DArray.MipSlice := mipSlice;
            Texture2DArray.FirstArraySlice := firstArraySlice;
            Texture2DArray.ArraySize := arraySize;
            Texture2DArray.PlaneSlice := planeSlice;
        end;
        D3D11_RTV_DIMENSION_TEXTURE2DMS:
        begin
        end;
        D3D11_RTV_DIMENSION_TEXTURE2DMSARRAY:
        begin
            Texture2DMSArray.FirstArraySlice := firstArraySlice;
            Texture2DMSArray.ArraySize := arraySize;
        end;
    end;

end;



procedure TD3D11_RENDER_TARGET_VIEW_DESC1.Init(pTex3D: ID3D11Texture3D; format: TDXGI_FORMAT; mipSlice: UINT; firstWSlice: UINT; wSize: UINT);
var
    TexDesc: TD3D11_TEXTURE3D_DESC;
begin
    Self.ViewDimension := D3D11_RTV_DIMENSION_TEXTURE3D;
    if (DXGI_FORMAT_UNKNOWN = format) or (UINT(-1) = wSize) then
    begin
        pTex3D.GetDesc(@TexDesc);
        if (DXGI_FORMAT_UNKNOWN = format) then format := TexDesc.Format;
        if (UINT(-1) = wSize) then wSize := TexDesc.Depth - firstWSlice;
    end;
    Self.Format := format;
    Texture3D.MipSlice := mipSlice;
    Texture3D.FirstWSlice := firstWSlice;
    Texture3D.WSize := wSize;
end;

{ TD3D11_UNORDERED_ACCESS_VIEW_DESC1 }

class operator TD3D11_UNORDERED_ACCESS_VIEW_DESC1.Initialize(var aRec: TD3D11_UNORDERED_ACCESS_VIEW_DESC1);
begin
    ZeroMemory(@aRec, SizeOf(aRec));
end;



procedure TD3D11_UNORDERED_ACCESS_VIEW_DESC1.Init(viewDimension: TD3D11_UAV_DIMENSION; format: TDXGI_FORMAT; mipSlice: UINT; firstArraySlice: UINT; arraySize: UINT; flags: UINT; planeSlice: UINT);
begin
    Self.Format := format;
    Self.ViewDimension := viewDimension;
    case (viewDimension) of
        D3D11_UAV_DIMENSION_BUFFER:
        begin
            Buffer.FirstElement := mipSlice;
            Buffer.NumElements := firstArraySlice;
            Buffer.Flags := flags;
        end;
        D3D11_UAV_DIMENSION_TEXTURE1D:
        begin
            Texture1D.MipSlice := mipSlice;
        end;
        D3D11_UAV_DIMENSION_TEXTURE1DARRAY:
        begin
            Texture1DArray.MipSlice := mipSlice;
            Texture1DArray.FirstArraySlice := firstArraySlice;
            Texture1DArray.ArraySize := arraySize;
        end;
        D3D11_UAV_DIMENSION_TEXTURE2D:
        begin
            Texture2D.MipSlice := mipSlice;
            Texture2D.PlaneSlice := planeSlice;
        end;
        D3D11_UAV_DIMENSION_TEXTURE2DARRAY:
        begin
            Texture2DArray.MipSlice := mipSlice;
            Texture2DArray.FirstArraySlice := firstArraySlice;
            Texture2DArray.ArraySize := arraySize;
            Texture2DArray.PlaneSlice := planeSlice;
        end;
        D3D11_UAV_DIMENSION_TEXTURE3D:
        begin
            Texture3D.MipSlice := mipSlice;
            Texture3D.FirstWSlice := firstArraySlice;
            Texture3D.WSize := arraySize;
        end;
    end;
end;



procedure TD3D11_UNORDERED_ACCESS_VIEW_DESC1.Init(Buffer: ID3D11Buffer; format: TDXGI_FORMAT; firstElement: UINT; numElements: UINT; flags: UINT);
begin
    Self.Format := format;
    Self.ViewDimension := D3D11_UAV_DIMENSION_BUFFER;
    Self.Buffer.FirstElement := firstElement;
    Self.Buffer.NumElements := numElements;
    Self.Buffer.Flags := flags;
end;



procedure TD3D11_UNORDERED_ACCESS_VIEW_DESC1.Init(pTex1D: ID3D11Texture1D; viewDimension: TD3D11_UAV_DIMENSION; format: TDXGI_FORMAT; mipSlice: UINT; firstArraySlice: UINT; arraySize: UINT);
var
    TexDesc: TD3D11_TEXTURE1D_DESC;
begin
    ViewDimension := viewDimension;
    if (DXGI_FORMAT_UNKNOWN = format) or ((UINT(-1) = arraySize) and (D3D11_UAV_DIMENSION_TEXTURE1DARRAY = viewDimension)) then
    begin
        pTex1D.GetDesc(@TexDesc);
        if (DXGI_FORMAT_UNKNOWN = format) then  format := TexDesc.Format;
        if (UINT(-1) = arraySize) then arraySize := TexDesc.ArraySize - firstArraySlice;
    end;
    Format := format;
    case (viewDimension) of
        D3D11_UAV_DIMENSION_TEXTURE1D:
        begin
            Texture1D.MipSlice := mipSlice;
        end;
        D3D11_UAV_DIMENSION_TEXTURE1DARRAY:
        begin
            Texture1DArray.MipSlice := mipSlice;
            Texture1DArray.FirstArraySlice := firstArraySlice;
            Texture1DArray.ArraySize := arraySize;
        end;
    end;
end;



procedure TD3D11_UNORDERED_ACCESS_VIEW_DESC1.Init(pTex2D: ID3D11Texture2D; viewDimension: TD3D11_UAV_DIMENSION; format: TDXGI_FORMAT; mipSlice: UINT; firstArraySlice: UINT; arraySize: UINT; planeSlice: UINT);
var
    TexDesc: TD3D11_TEXTURE2D_DESC;
begin
    Self.ViewDimension := viewDimension;
    if (DXGI_FORMAT_UNKNOWN = format) or ((UINT(-1) = arraySize) and (D3D11_UAV_DIMENSION_TEXTURE2DARRAY = viewDimension)) then
    begin
        pTex2D.GetDesc(@TexDesc);
        if (DXGI_FORMAT_UNKNOWN = format) then format := TexDesc.Format;
        if (UINT(-1) = arraySize) then  arraySize := TexDesc.ArraySize - firstArraySlice;
    end;
    Self.Format := format;
    case (viewDimension) of
        D3D11_UAV_DIMENSION_TEXTURE2D:
        begin
            Texture2D.MipSlice := mipSlice;
            Texture2D.PlaneSlice := planeSlice;
        end;
        D3D11_UAV_DIMENSION_TEXTURE2DARRAY:
        begin
            Texture2DArray.MipSlice := mipSlice;
            Texture2DArray.FirstArraySlice := firstArraySlice;
            Texture2DArray.ArraySize := arraySize;
            Texture2DArray.PlaneSlice := planeSlice;
        end;
    end;
end;



procedure TD3D11_UNORDERED_ACCESS_VIEW_DESC1.Init(pTex3D: ID3D11Texture3D; format: TDXGI_FORMAT; mipSlice: UINT; firstWSlice: UINT; wSize: UINT);
var
    TexDesc: TD3D11_TEXTURE3D_DESC;
begin
    Self.ViewDimension := D3D11_UAV_DIMENSION_TEXTURE3D;
    if (DXGI_FORMAT_UNKNOWN = format) or (UINT(-1) = wSize) then
    begin
        pTex3D.GetDesc(@TexDesc);
        if (DXGI_FORMAT_UNKNOWN = format) then  format := TexDesc.Format;
        if (UINT(-1) = wSize) then  wSize := TexDesc.Depth - firstWSlice;
    end;
    Self.Format := format;
    Texture3D.MipSlice := mipSlice;
    Texture3D.FirstWSlice := firstWSlice;
    Texture3D.WSize := wSize;
end;

{ TD3D11_QUERY_DESC1 }

procedure TD3D11_QUERY_DESC1.Init(query: TD3D11_QUERY; miscFlags: UINT; contextType: TD3D11_CONTEXT_TYPE);
begin
    Self.Query := query;
    Self.MiscFlags := miscFlags;
    Self.ContextType := contextType;
end;

end.
