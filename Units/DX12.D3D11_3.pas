unit DX12.D3D11_3;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

{$Z4}

uses
    Windows, Classes, SysUtils, DX12.DXGI1_3, DX12.D3D11_2, DX12.D3D11_1, DX12.D3DCommon, DX12.DXGI, DX12.D3D11;

const

    IID_ID3D11Texture2D1: TGUID = '{51218251-1E33-4617-9CCB-4D3A4367E7BB}';
    IID_ID3D11Texture3D1: TGUID = '{0C711683-2853-4846-9BB0-F3E60639E46A}';
    IID_ID3D11RasterizerState2: TGUID = '{6fbd02fb-209f-46c4-b059-2ed15586a6ac}';
    IID_ID3D11ShaderResourceView1: TGUID = '{91308b87-9040-411d-8c67-c39253ce3802}';
    IID_ID3D11RenderTargetView1: TGUID = '{ffbe2e23-f011-418a-ac56-5ceed7c5b94b}';
    IID_ID3D11UnorderedAccessView1: TGUID = '{7b3b6153-a886-4544-ab37-6537c8500403}';
    IID_ID3D11Query1: TGUID = '{631b4766-36dc-461d-8db6-c47e13e60916}';
    IID_ID3D11DeviceContext3: TGUID = '{b4e3c01d-e79e-4637-91b2-510e9f4c9b8f}';
    IID_ID3D11Device3: TGUID = '{A05C8C37-D2C6-4732-B3A0-9CE0B0DC9AE6}';


type

    TD3D11_CONTEXT_TYPE = (
        D3D11_CONTEXT_TYPE_ALL = 0,
        D3D11_CONTEXT_TYPE_3D = 1,
        D3D11_CONTEXT_TYPE_COMPUTE = 2,
        D3D11_CONTEXT_TYPE_COPY = 3,
        D3D11_CONTEXT_TYPE_VIDEO = 4
        );

    TD3D11_TEXTURE_LAYOUT = (
        D3D11_TEXTURE_LAYOUT_UNDEFINED = 0,
        D3D11_TEXTURE_LAYOUT_ROW_MAJOR = 1,
        D3D11_TEXTURE_LAYOUT_64K_STANDARD_SWIZZLE = 2
        );

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
        procedure Init(Aformat: TDXGI_FORMAT; Awidth: UINT; Aheight: UINT; AarraySize: UINT = 1; AmipLevels: UINT = 0;
                AbindFlags: UINT = Ord(D3D11_BIND_SHADER_RESOURCE); Ausage: TD3D11_USAGE = D3D11_USAGE_DEFAULT;
                AcpuaccessFlags: UINT = 0; AsampleCount: UINT = 1; AsampleQuality: UINT = 0; AmiscFlags: UINT = 0;
                AtextureLayout: TD3D11_TEXTURE_LAYOUT = D3D11_TEXTURE_LAYOUT_UNDEFINED); overload;
        procedure Init(desc: TD3D11_TEXTURE2D_DESC; AtextureLayout: TD3D11_TEXTURE_LAYOUT = D3D11_TEXTURE_LAYOUT_UNDEFINED); overload;
    end;


    ID3D11Texture2D1 = interface(ID3D11Texture2D)
        ['{51218251-1E33-4617-9CCB-4D3A4367E7BB}']
        procedure GetDesc1(out pDesc: TD3D11_TEXTURE2D_DESC1); stdcall;
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
        procedure Init(AFormat: TDXGI_FORMAT; AWidth: UINT; AHeight: UINT; ADepth: UINT; AMipLevels: UINT = 0;
                ABindFlags: UINT = Ord(D3D11_BIND_SHADER_RESOURCE); AUsage: TD3D11_USAGE = D3D11_USAGE_DEFAULT;
                ACpuaccessFlags: UINT = 0; AMiscFlags: UINT = 0; ATextureLayout: TD3D11_TEXTURE_LAYOUT = D3D11_TEXTURE_LAYOUT_UNDEFINED);
                overload;
        procedure Init(desc: TD3D11_TEXTURE3D_DESC; ATextureLayout: TD3D11_TEXTURE_LAYOUT = D3D11_TEXTURE_LAYOUT_UNDEFINED);
                overload;
    end;


    ID3D11Texture3D1 = interface(ID3D11Texture3D)
        ['{0C711683-2853-4846-9BB0-F3E60639E46A}']
        procedure GetDesc1(out pDesc: TD3D11_TEXTURE3D_DESC1); stdcall;
    end;

    TD3D11_CONSERVATIVE_RASTERIZATION_MODE = (
        D3D11_CONSERVATIVE_RASTERIZATION_MODE_OFF = 0,
        D3D11_CONSERVATIVE_RASTERIZATION_MODE_ON = 1
        );

    { TD3D11_RASTERIZER_DESC2 }

    TD3D11_RASTERIZER_DESC2 = record
        FillMode: TD3D11_FILL_MODE;
        CullMode: TD3D11_CULL_MODE;
        FrontCounterClockwise: boolean;
        DepthBias: INT32;
        DepthBiasClamp: single;
        SlopeScaledDepthBias: single;
        DepthClipEnable: boolean;
        ScissorEnable: boolean;
        MultisampleEnable: boolean;
        AntialiasedLineEnable: boolean;
        ForcedSampleCount: UINT;
        ConservativeRaster: TD3D11_CONSERVATIVE_RASTERIZATION_MODE;
        procedure Init; overload;
        procedure Init(AfillMode: TD3D11_FILL_MODE; AcullMode: TD3D11_CULL_MODE; AfrontCounterClockwise: boolean;
                AdepthBias: INT32; AdepthBiasClamp: single; AslopeScaledDepthBias: single; AdepthClipEnable: boolean;
                AscissorEnable: boolean; AmultisampleEnable: boolean; AantialiasedLineEnable: boolean;
                AforcedSampleCount: UINT; AconservativeRaster: TD3D11_CONSERVATIVE_RASTERIZATION_MODE); overload;
    end;


    ID3D11RasterizerState2 = interface(ID3D11RasterizerState1)
        ['{6fbd02fb-209f-46c4-b059-2ed15586a6ac}']
        procedure GetDesc2(out pDesc: TD3D11_RASTERIZER_DESC2); stdcall;
    end;


    TD3D11_TEX2D_SRV1 = record
        MostDetailedMip: UINT;
        MipLevels: UINT;
        PlaneSlice: UINT;
    end;

    TD3D11_TEX2D_ARRAY_SRV1 = record
        MostDetailedMip: UINT;
        MipLevels: UINT;
        FirstArraySlice: UINT;
        ArraySize: UINT;
        PlaneSlice: UINT;
    end;


    { TD3D11_SHADER_RESOURCE_VIEW_DESC1 }

    TD3D11_SHADER_RESOURCE_VIEW_DESC1 = record
        Format: TDXGI_FORMAT;
        ViewDimension: TD3D11_SRV_DIMENSION;
        procedure Init(AviewDimension: TD3D11_SRV_DIMENSION; Aformat: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN;
                AmostDetailedMip: UINT = 0; AmipLevels: INT32 = -1; AfirstArraySlice: UINT = 0; AarraySize: INT32 = -1;
                Aflags: UINT = 0; AplaneSlice: UINT = 0); overload;
        procedure Init(AFormat: TDXGI_FORMAT; firstElement: UINT; numElements: UINT; flags: UINT = 0); overload;
        procedure Init(pTex1D: ID3D11Texture1D; AviewDimension: TD3D11_SRV_DIMENSION; Aformat: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN;
                mostDetailedMip: UINT = 0; mipLevels: INT32 = -1; firstArraySlice: UINT = 0; arraySize: INT32 = -1); overload;
        procedure Init(pTex2D: ID3D11Texture2D; AviewDimension: TD3D11_SRV_DIMENSION; Aformat: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN;
                mostDetailedMip: UINT = 0; mipLevels: INT32 = -1; firstArraySlice: UINT = 0; arraySize: INT32 = -1; planeSlice: UINT = 0); overload;
        procedure Init(pTex3D: ID3D11Texture3D; Aformat: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN; mostDetailedMip: UINT = 0;
                mipLevels: INT32 = -1); overload;
        case integer of
            0: (Buffer: TD3D11_BUFFER_SRV);
            1: (Texture1D: TD3D11_TEX1D_SRV);
            2: (Texture1DArray: TD3D11_TEX1D_ARRAY_SRV);
            3: (Texture2D: TD3D11_TEX2D_SRV1);
            4: (Texture2DArray: TD3D11_TEX2D_ARRAY_SRV1);
            5: (Texture2DMS: TD3D11_TEX2DMS_SRV);
            6: (Texture2DMSArray: TD3D11_TEX2DMS_ARRAY_SRV);
            7: (Texture3D: TD3D11_TEX3D_SRV);
            8: (TextureCube: TD3D11_TEXCUBE_SRV);
            9: (TextureCubeArray: TD3D11_TEXCUBE_ARRAY_SRV);
            10: (BufferEx: TD3D11_BUFFEREX_SRV);
    end;


    ID3D11ShaderResourceView1 = interface(ID3D11ShaderResourceView)
        ['{91308b87-9040-411d-8c67-c39253ce3802}']
        procedure GetDesc1(out pDesc1: TD3D11_SHADER_RESOURCE_VIEW_DESC1); stdcall;
    end;


    TD3D11_TEX2D_RTV1 = record
        MipSlice: UINT;
        PlaneSlice: UINT;
    end;

    TD3D11_TEX2D_ARRAY_RTV1 = record
        MipSlice: UINT;
        FirstArraySlice: UINT;
        ArraySize: UINT;
        PlaneSlice: UINT;
    end;

    { TD3D11_RENDER_TARGET_VIEW_DESC1 }

    TD3D11_RENDER_TARGET_VIEW_DESC1 = record
        Format: TDXGI_FORMAT;
        ViewDimension: TD3D11_RTV_DIMENSION;
        procedure Init(AviewDimension: TD3D11_RTV_DIMENSION; Aformat: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN;
                mipSlice: UINT = 0; firstArraySlice: UINT = 0; arraySize: INT32 = -1; planeSlice: UINT = 0); overload;
        procedure Init(Aformat: TDXGI_FORMAT; firstElement: UINT; numElements: UINT); overload;
        procedure Init(pTex1D: ID3D11Texture1D; AviewDimension: TD3D11_RTV_DIMENSION; Aformat: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN;
                mipSlice: UINT = 0; firstArraySlice: UINT = 0; arraySize: INT32 = -1); overload;
        procedure Init(pTex2D: ID3D11Texture2D; AviewDimension: TD3D11_RTV_DIMENSION; Aformat: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN;
                mipSlice: UINT = 0; firstArraySlice: UINT = 0; arraySize: INT32 = -1; planeSlice: UINT = 0); overload;
        procedure Init(pTex3D: ID3D11Texture3D; AFormat: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN; mipSlice: UINT = 0;
                firstWSlice: UINT = 0; wSize: INT32 = -1); overload;
        case integer of
            0: (Buffer: TD3D11_BUFFER_RTV);
            1: (Texture1D: TD3D11_TEX1D_RTV);
            2: (Texture1DArray: TD3D11_TEX1D_ARRAY_RTV);
            3: (Texture2D: TD3D11_TEX2D_RTV1);
            4: (Texture2DArray: TD3D11_TEX2D_ARRAY_RTV1);
            5: (Texture2DMS: TD3D11_TEX2DMS_RTV);
            6: (Texture2DMSArray: TD3D11_TEX2DMS_ARRAY_RTV);
            7: (Texture3D: TD3D11_TEX3D_RTV);
    end;


    ID3D11RenderTargetView1 = interface(ID3D11RenderTargetView)
        ['{ffbe2e23-f011-418a-ac56-5ceed7c5b94b}']
        procedure GetDesc1(out pDesc1: TD3D11_RENDER_TARGET_VIEW_DESC1); stdcall;
    end;


    TD3D11_TEX2D_UAV1 = record
        MipSlice: UINT;
        PlaneSlice: UINT;
    end;

    TD3D11_TEX2D_ARRAY_UAV1 = record
        MipSlice: UINT;
        FirstArraySlice: UINT;
        ArraySize: UINT;
        PlaneSlice: UINT;
    end;


    { TD3D11_UNORDERED_ACCESS_VIEW_DESC1 }

    TD3D11_UNORDERED_ACCESS_VIEW_DESC1 = record
        Format: TDXGI_FORMAT;
        ViewDimension: TD3D11_UAV_DIMENSION;

        procedure Init(AviewDimension: TD3D11_UAV_DIMENSION; Aformat: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN;
                mipSlice: UINT = 0; firstArraySlice: UINT = 0; arraySize: INT32 = -1; flags: UINT = 0;
                planeSlice: UINT = 0); overload;
        procedure Init(Aformat: TDXGI_FORMAT; firstElement: UINT; numElements: UINT; flags: UINT = 0); overload;

        procedure Init(pTex1D: ID3D11Texture1D; AviewDimension: TD3D11_UAV_DIMENSION; Aformat: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN;
                mipSlice: UINT = 0; firstArraySlice: UINT = 0; arraySize: INT32 = -1); overload;

        procedure Init(pTex2D: ID3D11Texture2D; AviewDimension: TD3D11_UAV_DIMENSION; Aformat: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN;
                mipSlice: UINT = 0; firstArraySlice: UINT = 0; arraySize: INT32 = -1; planeSlice: UINT = 0); overload;

        procedure Init(pTex3D: ID3D11Texture3D; Aformat: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN; mipSlice: UINT = 0;
                firstWSlice: UINT = 0; wSize: INT32 = -1); overload;

        case integer of
            0: (Buffer: TD3D11_BUFFER_UAV);
            1: (Texture1D: TD3D11_TEX1D_UAV);
            2: (Texture1DArray: TD3D11_TEX1D_ARRAY_UAV);
            3: (Texture2D: TD3D11_TEX2D_UAV1);
            4: (Texture2DArray: TD3D11_TEX2D_ARRAY_UAV1);
            5: (Texture3D: TD3D11_TEX3D_UAV);

    end;

    ID3D11UnorderedAccessView1 = interface(ID3D11UnorderedAccessView)
        ['{7b3b6153-a886-4544-ab37-6537c8500403}']
        procedure GetDesc1(out pDesc1: TD3D11_UNORDERED_ACCESS_VIEW_DESC1); stdcall;
    end;


    { TD3D11_QUERY_DESC1 }

    TD3D11_QUERY_DESC1 = record
        Query: TD3D11_QUERY;
        MiscFlags: UINT;
        ContextType: TD3D11_CONTEXT_TYPE;
        procedure Init(Aquery: TD3D11_QUERY; AmiscFlags: UINT = 0; AcontextType: TD3D11_CONTEXT_TYPE = D3D11_CONTEXT_TYPE_ALL);
    end;


    ID3D11Query1 = interface(ID3D11Query)
        ['{631b4766-36dc-461d-8db6-c47e13e60916}']
        procedure GetDesc1(out pDesc1: TD3D11_QUERY_DESC1); stdcall;
    end;


    ID3D11DeviceContext3 = interface(ID3D11DeviceContext2)
        ['{b4e3c01d-e79e-4637-91b2-510e9f4c9b8f}']
        procedure Flush1(ContextType: TD3D11_CONTEXT_TYPE; hEvent: THANDLE); stdcall;
		procedure SetHardwareProtectionState( HwProtectionEnable:BOOLean); stdcall;
        procedure GetHardwareProtectionState( Out pHwProtectionEnable:BOOLean); stdcall;
    end;


    ID3D11Device3 = interface(ID3D11Device2)
        ['{A05C8C37-D2C6-4732-B3A0-9CE0B0DC9AE6}']
        function CreateTexture2D1(const pDesc1: TD3D11_TEXTURE2D_DESC1; pInitialData: PD3D11_SUBRESOURCE_DATA;
            out ppTexture2D: ID3D11Texture2D1): HResult; stdcall;
        function CreateTexture3D1(const pDesc1: TD3D11_TEXTURE3D_DESC1; pInitialData: PD3D11_SUBRESOURCE_DATA;
            out ppTexture3D: ID3D11Texture3D1): HResult; stdcall;
        function CreateRasterizerState2(const pRasterizerDesc: TD3D11_RASTERIZER_DESC2;
            out ppRasterizerState: ID3D11RasterizerState2): HResult; stdcall;
        function CreateShaderResourceView1(pResource: ID3D11Resource; const pDesc1: TD3D11_SHADER_RESOURCE_VIEW_DESC1;
            out ppSRView1: ID3D11ShaderResourceView1): HResult; stdcall;
        function CreateUnorderedAccessView1(pResource: ID3D11Resource; const pDesc1: TD3D11_UNORDERED_ACCESS_VIEW_DESC1;
            out ppUAView1: ID3D11UnorderedAccessView1): HResult; stdcall;
        function CreateRenderTargetView1(pResource: ID3D11Resource; const pDesc1: TD3D11_RENDER_TARGET_VIEW_DESC1;
            out ppRTView1: ID3D11RenderTargetView1): HResult; stdcall;
        function CreateQuery1(const pQueryDesc1: TD3D11_QUERY_DESC1; out ppQuery1: ID3D11Query1): HResult; stdcall;
        procedure GetImmediateContext3(out ppImmediateContext: ID3D11DeviceContext3); stdcall;
        function CreateDeferredContext3(ContextFlags: UINT; out ppDeferredContext: ID3D11DeviceContext3): HResult; stdcall;
        procedure WriteToSubresource(pDstResource: ID3D11Resource; DstSubresource: UINT; const pDstBox: TD3D11_BOX;
            pSrcData: Pointer; SrcRowPitch: UINT; SrcDepthPitch: UINT); stdcall;
        procedure ReadFromSubresource(out pDstData: pointer; DstRowPitch: UINT; DstDepthPitch: UINT;
            pSrcResource: ID3D11Resource; SrcSubresource: UINT; const pSrcBox: TD3D11_BOX); stdcall;
    end;


implementation

{ TD3D11_QUERY_DESC1 }

procedure TD3D11_QUERY_DESC1.Init(Aquery: TD3D11_QUERY; AmiscFlags: UINT; AcontextType: TD3D11_CONTEXT_TYPE);
begin
    Query := Aquery;
    MiscFlags := AmiscFlags;
    ContextType := AcontextType;
end;

{ TD3D11_UNORDERED_ACCESS_VIEW_DESC1 }

procedure TD3D11_UNORDERED_ACCESS_VIEW_DESC1.Init(AviewDimension: TD3D11_UAV_DIMENSION; Aformat: TDXGI_FORMAT;
    mipSlice: UINT; firstArraySlice: UINT; arraySize: INT32; flags: UINT; planeSlice: UINT);
begin
    Format := Aformat;
    ViewDimension := AviewDimension;
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



procedure TD3D11_UNORDERED_ACCESS_VIEW_DESC1.Init(Aformat: TDXGI_FORMAT; firstElement: UINT; numElements: UINT; flags: UINT);
begin
    Format := Aformat;
    ViewDimension := D3D11_UAV_DIMENSION_BUFFER;
    Buffer.FirstElement := firstElement;
    Buffer.NumElements := numElements;
    Buffer.Flags := flags;
end;



procedure TD3D11_UNORDERED_ACCESS_VIEW_DESC1.Init(pTex1D: ID3D11Texture1D; AviewDimension: TD3D11_UAV_DIMENSION;
    Aformat: TDXGI_FORMAT; mipSlice: UINT; firstArraySlice: UINT; arraySize: INT32);
var
    TexDesc: TD3D11_TEXTURE1D_DESC;
begin
    ViewDimension := AviewDimension;
    if (DXGI_FORMAT_UNKNOWN = Aformat) or ((-1 = arraySize) and (D3D11_UAV_DIMENSION_TEXTURE1DARRAY = viewDimension)) then
    begin

        pTex1D.GetDesc(TexDesc);
        if (DXGI_FORMAT_UNKNOWN = Aformat) then
            Aformat := TexDesc.Format;
        if (-1 = arraySize) then
            arraySize := TexDesc.ArraySize - firstArraySlice;
    end;
    Format := Aformat;
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



procedure TD3D11_UNORDERED_ACCESS_VIEW_DESC1.Init(pTex2D: ID3D11Texture2D; AviewDimension: TD3D11_UAV_DIMENSION;
    Aformat: TDXGI_FORMAT; mipSlice: UINT; firstArraySlice: UINT; arraySize: INT32; planeSlice: UINT);
var
    TexDesc: TD3D11_TEXTURE2D_DESC;
begin
    ViewDimension := AviewDimension;
    if (DXGI_FORMAT_UNKNOWN = Aformat) or ((-1 = arraySize) and (D3D11_UAV_DIMENSION_TEXTURE2DARRAY = viewDimension)) then
    begin

        pTex2D.GetDesc(TexDesc);
        if (DXGI_FORMAT_UNKNOWN = Aformat) then
            Aformat := TexDesc.Format;
        if (-1 = arraySize) then
            arraySize := TexDesc.ArraySize - firstArraySlice;
    end;
    Format := Aformat;
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



procedure TD3D11_UNORDERED_ACCESS_VIEW_DESC1.Init(pTex3D: ID3D11Texture3D; Aformat: TDXGI_FORMAT; mipSlice: UINT; firstWSlice: UINT; wSize: INT32);
var
    TexDesc: TD3D11_TEXTURE3D_DESC;
begin
    ViewDimension := D3D11_UAV_DIMENSION_TEXTURE3D;
    if (DXGI_FORMAT_UNKNOWN = Aformat) or (-1 = wSize) then
    begin

        pTex3D.GetDesc(TexDesc);
        if (DXGI_FORMAT_UNKNOWN = Aformat) then
            Aformat := TexDesc.Format;
        if (-1 = wSize) then
            wSize := TexDesc.Depth - firstWSlice;
    end;
    Format := Aformat;
    Texture3D.MipSlice := mipSlice;
    Texture3D.FirstWSlice := firstWSlice;
    Texture3D.WSize := wSize;
end;

{ TD3D11_RENDER_TARGET_VIEW_DESC1 }

procedure TD3D11_RENDER_TARGET_VIEW_DESC1.Init(AviewDimension: TD3D11_RTV_DIMENSION; Aformat: TDXGI_FORMAT;
    mipSlice: UINT; firstArraySlice: UINT; arraySize: INT32; planeSlice: UINT);
begin
    Format := Aformat;
    ViewDimension := AviewDimension;
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



procedure TD3D11_RENDER_TARGET_VIEW_DESC1.Init(Aformat: TDXGI_FORMAT; firstElement: UINT; numElements: UINT);
begin
    Format := Aformat;
    ViewDimension := D3D11_RTV_DIMENSION_BUFFER;
    Buffer.FirstElement := firstElement;
    Buffer.NumElements := numElements;
end;



procedure TD3D11_RENDER_TARGET_VIEW_DESC1.Init(pTex1D: ID3D11Texture1D; AviewDimension: TD3D11_RTV_DIMENSION;
    Aformat: TDXGI_FORMAT; mipSlice: UINT; firstArraySlice: UINT; arraySize: INT32);
var
    TexDesc: TD3D11_TEXTURE1D_DESC;
begin
    ViewDimension := AviewDimension;
    if (DXGI_FORMAT_UNKNOWN = Aformat) or ((-1 = arraySize) and (D3D11_RTV_DIMENSION_TEXTURE1DARRAY = viewDimension)) then
    begin
        pTex1D.GetDesc(TexDesc);
        if (DXGI_FORMAT_UNKNOWN = Aformat) then
            Aformat := TexDesc.Format;
        if (-1 = arraySize) then
            arraySize := TexDesc.ArraySize - firstArraySlice;
    end;
    Format := Aformat;
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



procedure TD3D11_RENDER_TARGET_VIEW_DESC1.Init(pTex2D: ID3D11Texture2D; AviewDimension: TD3D11_RTV_DIMENSION;
    Aformat: TDXGI_FORMAT; mipSlice: UINT; firstArraySlice: UINT; arraySize: INT32; planeSlice: UINT);
var
    TexDesc: TD3D11_TEXTURE2D_DESC;
begin
    ViewDimension := AviewDimension;
    if (DXGI_FORMAT_UNKNOWN = Aformat) or ((-1 = arraySize) and ((D3D11_RTV_DIMENSION_TEXTURE2DARRAY = viewDimension) or
        (D3D11_RTV_DIMENSION_TEXTURE2DMSARRAY = viewDimension))) then
    begin
        pTex2D.GetDesc(TexDesc);
        if (DXGI_FORMAT_UNKNOWN = Aformat) then
            Aformat := TexDesc.Format;
        if (-1 = arraySize) then
            arraySize := TexDesc.ArraySize - firstArraySlice;
    end;
    Format := Aformat;
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



procedure TD3D11_RENDER_TARGET_VIEW_DESC1.Init(pTex3D: ID3D11Texture3D; AFormat: TDXGI_FORMAT; mipSlice: UINT; firstWSlice: UINT; wSize: INT32);
var
    TexDesc: TD3D11_TEXTURE3D_DESC;
begin
    ViewDimension := D3D11_RTV_DIMENSION_TEXTURE3D;
    if (DXGI_FORMAT_UNKNOWN = AFormat) or (-1 = wSize) then
    begin
        pTex3D.GetDesc(TexDesc);
        if (DXGI_FORMAT_UNKNOWN = AFormat) then
            AFormat := TexDesc.Format;
        if (-1 = wSize) then
            wSize := TexDesc.Depth - firstWSlice;
    end;
    Format := format;
    Texture3D.MipSlice := mipSlice;
    Texture3D.FirstWSlice := firstWSlice;
    Texture3D.WSize := wSize;
end;

{ TD3D11_SHADER_RESOURCE_VIEW_DESC1 }

procedure TD3D11_SHADER_RESOURCE_VIEW_DESC1.Init(AviewDimension: TD3D11_SRV_DIMENSION; Aformat: TDXGI_FORMAT;
    AmostDetailedMip: UINT; AmipLevels: INT32; AfirstArraySlice: UINT; AarraySize: INT32; Aflags: UINT; AplaneSlice: UINT);
begin
    Format := Aformat;
    ViewDimension := viewDimension;
    case (viewDimension) of
        D3D11_SRV_DIMENSION_BUFFER:
        begin
            Buffer.FirstElement := AmostDetailedMip;
            Buffer.NumElements := AmipLevels;
        end;
        D3D11_SRV_DIMENSION_TEXTURE1D:
        begin
            Texture1D.MostDetailedMip := AmostDetailedMip;
            Texture1D.MipLevels := AmipLevels;
        end;
        D3D11_SRV_DIMENSION_TEXTURE1DARRAY:
        begin
            Texture1DArray.MostDetailedMip := AmostDetailedMip;
            Texture1DArray.MipLevels := AmipLevels;
            Texture1DArray.FirstArraySlice := AfirstArraySlice;
            Texture1DArray.ArraySize := AarraySize;
        end;
        D3D11_SRV_DIMENSION_TEXTURE2D:
        begin
            Texture2D.MostDetailedMip := AmostDetailedMip;
            Texture2D.MipLevels := AmipLevels;
            Texture2D.PlaneSlice := AplaneSlice;
        end;
        D3D11_SRV_DIMENSION_TEXTURE2DARRAY:
        begin
            Texture2DArray.MostDetailedMip := AmostDetailedMip;
            Texture2DArray.MipLevels := AmipLevels;
            Texture2DArray.FirstArraySlice := AfirstArraySlice;
            Texture2DArray.ArraySize := AarraySize;
            Texture2DArray.PlaneSlice := AplaneSlice;
        end;
        D3D11_SRV_DIMENSION_TEXTURE2DMS:
        begin
        end;
        D3D11_SRV_DIMENSION_TEXTURE2DMSARRAY:
        begin
            Texture2DMSArray.FirstArraySlice := AfirstArraySlice;
            Texture2DMSArray.ArraySize := AarraySize;
        end;
        D3D11_SRV_DIMENSION_TEXTURE3D:
        begin
            Texture3D.MostDetailedMip := AmostDetailedMip;
            Texture3D.MipLevels := AmipLevels;
        end;
        D3D11_SRV_DIMENSION_TEXTURECUBE:
        begin
            TextureCube.MostDetailedMip := AmostDetailedMip;
            TextureCube.MipLevels := AmipLevels;
        end;
        D3D11_SRV_DIMENSION_TEXTURECUBEARRAY:
        begin
            TextureCubeArray.MostDetailedMip := AmostDetailedMip;
            TextureCubeArray.MipLevels := AmipLevels;
            TextureCubeArray.First2DArrayFace := AfirstArraySlice;
            TextureCubeArray.NumCubes := AarraySize;
        end;
        D3D11_SRV_DIMENSION_BUFFEREX:
        begin
            BufferEx.FirstElement := AmostDetailedMip;
            BufferEx.NumElements := AmipLevels;
            BufferEx.Flags := Aflags;
        end;
    end;
end;



procedure TD3D11_SHADER_RESOURCE_VIEW_DESC1.Init(AFormat: TDXGI_FORMAT; firstElement: UINT; numElements: UINT; flags: UINT);
begin
    Format := AFormat;
    ViewDimension := D3D11_SRV_DIMENSION_BUFFEREX;
    BufferEx.FirstElement := firstElement;
    BufferEx.NumElements := numElements;
    BufferEx.Flags := flags;
end;



procedure TD3D11_SHADER_RESOURCE_VIEW_DESC1.Init(pTex1D: ID3D11Texture1D; AviewDimension: TD3D11_SRV_DIMENSION;
    Aformat: TDXGI_FORMAT; mostDetailedMip: UINT; mipLevels: INT32; firstArraySlice: UINT; arraySize: INT32);
var
    TexDesc: TD3D11_TEXTURE1D_DESC;
begin
    ViewDimension := AviewDimension;
    if (DXGI_FORMAT_UNKNOWN = Aformat) or (-1 = mipLevels) or ((-1 = arraySize) and (D3D11_SRV_DIMENSION_TEXTURE1DARRAY = viewDimension)) then
    begin
        pTex1D.GetDesc(TexDesc);
        if (DXGI_FORMAT_UNKNOWN = format) then
            Aformat := TexDesc.Format;
        if (-1 = mipLevels) then
            mipLevels := TexDesc.MipLevels - mostDetailedMip;
        if (-1 = arraySize) then
            arraySize := TexDesc.ArraySize - firstArraySlice;
    end;
    Format := Aformat;
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



procedure TD3D11_SHADER_RESOURCE_VIEW_DESC1.Init(pTex2D: ID3D11Texture2D; AviewDimension: TD3D11_SRV_DIMENSION;
    Aformat: TDXGI_FORMAT; mostDetailedMip: UINT; mipLevels: INT32; firstArraySlice: UINT; arraySize: INT32; planeSlice: UINT);
var
    TexDesc: TD3D11_TEXTURE2D_DESC;
begin
    ViewDimension := AviewDimension;
    if (DXGI_FORMAT_UNKNOWN = AFormat) or ((-1 = mipLevels) and (D3D11_SRV_DIMENSION_TEXTURE2DMS <> viewDimension) and
        (D3D11_SRV_DIMENSION_TEXTURE2DMSARRAY <> viewDimension)) or ((-1 = arraySize) and
        ((D3D11_SRV_DIMENSION_TEXTURE2DARRAY = viewDimension) or (D3D11_SRV_DIMENSION_TEXTURE2DMSARRAY = viewDimension) or
        (D3D11_SRV_DIMENSION_TEXTURECUBEARRAY = viewDimension))) then
    begin
        pTex2D.GetDesc(TexDesc);
        if (DXGI_FORMAT_UNKNOWN = Aformat) then
            Aformat := TexDesc.Format;
        if (-1 = mipLevels) then
            mipLevels := TexDesc.MipLevels - mostDetailedMip;
        if (-1 = arraySize) then
        begin
            arraySize := TexDesc.ArraySize - firstArraySlice;
            if (D3D11_SRV_DIMENSION_TEXTURECUBEARRAY = viewDimension) then
                arraySize := arraySize div 6;
        end;
    end;
    Format := AFormat;
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



procedure TD3D11_SHADER_RESOURCE_VIEW_DESC1.Init(pTex3D: ID3D11Texture3D; Aformat: TDXGI_FORMAT; mostDetailedMip: UINT; mipLevels: INT32);
var
    TexDesc: TD3D11_TEXTURE3D_DESC;
begin
    ViewDimension := D3D11_SRV_DIMENSION_TEXTURE3D;
    if (DXGI_FORMAT_UNKNOWN = Aformat) or (-1 = mipLevels) then
    begin
        pTex3D.GetDesc(TexDesc);
        if (DXGI_FORMAT_UNKNOWN = Aformat) then
            Aformat := TexDesc.Format;
        if (-1 = mipLevels) then
            mipLevels := TexDesc.MipLevels - mostDetailedMip;
    end;
    Format := Aformat;
    Texture3D.MostDetailedMip := mostDetailedMip;
    Texture3D.MipLevels := mipLevels;
end;

{ TD3D11_RASTERIZER_DESC2 }

procedure TD3D11_RASTERIZER_DESC2.Init;
begin
    FillMode := D3D11_FILL_SOLID;
    CullMode := D3D11_CULL_BACK;
    FrontCounterClockwise := False;
    DepthBias := D3D11_DEFAULT_DEPTH_BIAS;
    DepthBiasClamp := D3D11_DEFAULT_DEPTH_BIAS_CLAMP;
    SlopeScaledDepthBias := D3D11_DEFAULT_SLOPE_SCALED_DEPTH_BIAS;
    DepthClipEnable := True;
    ScissorEnable := False;
    MultisampleEnable := False;
    AntialiasedLineEnable := False;
    ForcedSampleCount := 0;
    ConservativeRaster := D3D11_CONSERVATIVE_RASTERIZATION_MODE_OFF;
end;



procedure TD3D11_RASTERIZER_DESC2.Init(AfillMode: TD3D11_FILL_MODE; AcullMode: TD3D11_CULL_MODE; AfrontCounterClockwise: boolean;
    AdepthBias: INT32; AdepthBiasClamp: single; AslopeScaledDepthBias: single; AdepthClipEnable: boolean;
    AscissorEnable: boolean; AmultisampleEnable: boolean; AantialiasedLineEnable: boolean; AforcedSampleCount: UINT;
    AconservativeRaster: TD3D11_CONSERVATIVE_RASTERIZATION_MODE);
begin
    FillMode := AfillMode;
    CullMode := AcullMode;
    FrontCounterClockwise := AfrontCounterClockwise;
    DepthBias := AdepthBias;
    DepthBiasClamp := AdepthBiasClamp;
    SlopeScaledDepthBias := AslopeScaledDepthBias;
    DepthClipEnable := AdepthClipEnable;
    ScissorEnable := AscissorEnable;
    MultisampleEnable := AmultisampleEnable;
    AntialiasedLineEnable := AantialiasedLineEnable;
    ForcedSampleCount := AforcedSampleCount;
    ConservativeRaster := AconservativeRaster;
end;

{ TD3D11_TEXTURE3D_DESC1 }

procedure TD3D11_TEXTURE3D_DESC1.Init(AFormat: TDXGI_FORMAT; AWidth: UINT; AHeight: UINT; ADepth: UINT; AMipLevels: UINT;
    ABindFlags: UINT; AUsage: TD3D11_USAGE; ACpuaccessFlags: UINT; AMiscFlags: UINT; ATextureLayout: TD3D11_TEXTURE_LAYOUT);
begin
    Width := Awidth;
    Height := Aheight;
    Depth := Adepth;
    MipLevels := AmipLevels;
    Format := Aformat;
    Usage := Ausage;
    BindFlags := AbindFlags;
    CPUAccessFlags := AcpuaccessFlags;
    MiscFlags := AmiscFlags;
    TextureLayout := AtextureLayout;
end;



procedure TD3D11_TEXTURE3D_DESC1.Init(desc: TD3D11_TEXTURE3D_DESC; ATextureLayout: TD3D11_TEXTURE_LAYOUT);
begin
    Width := desc.Width;
    Height := desc.Height;
    Depth := desc.Depth;
    MipLevels := desc.MipLevels;
    Format := desc.Format;
    Usage := desc.Usage;
    BindFlags := desc.BindFlags;
    CPUAccessFlags := desc.CPUAccessFlags;
    MiscFlags := desc.MiscFlags;
    TextureLayout := ATextureLayout;
end;

{ TD3D11_TEXTURE2D_DESC1 }

procedure TD3D11_TEXTURE2D_DESC1.Init(Aformat: TDXGI_FORMAT; Awidth: UINT; Aheight: UINT; AarraySize: UINT;
    AmipLevels: UINT; AbindFlags: UINT; Ausage: TD3D11_USAGE; AcpuaccessFlags: UINT; AsampleCount: UINT;
    AsampleQuality: UINT; AmiscFlags: UINT; AtextureLayout: TD3D11_TEXTURE_LAYOUT);
begin
    Width := Awidth;
    Height := Aheight;
    MipLevels := AmipLevels;
    ArraySize := AarraySize;
    Format := Aformat;
    SampleDesc.Count := AsampleCount;
    SampleDesc.Quality := AsampleQuality;
    Usage := Ausage;
    BindFlags := AbindFlags;
    CPUAccessFlags := AcpuaccessFlags;
    MiscFlags := AmiscFlags;
    TextureLayout := AtextureLayout;
end;



procedure TD3D11_TEXTURE2D_DESC1.Init(desc: TD3D11_TEXTURE2D_DESC; AtextureLayout: TD3D11_TEXTURE_LAYOUT);
begin
    Width := desc.Width;
    Height := desc.Height;
    MipLevels := desc.MipLevels;
    ArraySize := desc.ArraySize;
    Format := desc.Format;
    SampleDesc.Count := desc.SampleDesc.Count;
    SampleDesc.Quality := desc.SampleDesc.Quality;
    Usage := desc.Usage;
    BindFlags := desc.BindFlags;
    CPUAccessFlags := desc.CPUAccessFlags;
    MiscFlags := desc.MiscFlags;
    TextureLayout := AtextureLayout;
end;

end.
