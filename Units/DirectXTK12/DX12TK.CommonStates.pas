//--------------------------------------------------------------------------------------
// File: CommonStates.h

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------
unit DX12TK.CommonStates;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12TK.DescriptorHeap,
    DX12.D3D12;

const
    FLT_MAX = 3.402823466e+38;        // max value

type

    { TCommonStates }

    TCommonStates = class(TObject)
    type
        // These index into the heap returned by SamplerDescriptorHeap
        TSamplerIndex = (
            PointWrap,
            PointClamp,
            LinearWrap,
            LinearClamp,
            AnisotropicWrap,
            AnisotropicClamp,
            Count);


    private
        mDescriptors: TDescriptorHeap;
    public
        // Blend states.
        Opaque: TD3D12_BLEND_DESC;
        AlphaBlend: TD3D12_BLEND_DESC;
        Additive: TD3D12_BLEND_DESC;
        NonPremultiplied: TD3D12_BLEND_DESC;
        // Depth stencil states.
        DepthNone: TD3D12_DEPTH_STENCIL_DESC;
        DepthDefault: TD3D12_DEPTH_STENCIL_DESC;
        DepthRead: TD3D12_DEPTH_STENCIL_DESC;
        DepthReverseZ: TD3D12_DEPTH_STENCIL_DESC;
        DepthReadReverseZ: TD3D12_DEPTH_STENCIL_DESC;
        // Rasterizer states.
        CullNone: TD3D12_RASTERIZER_DESC;
        CullClockwise: TD3D12_RASTERIZER_DESC;
        CullCounterClockwise: TD3D12_RASTERIZER_DESC;
        Wireframe: TD3D12_RASTERIZER_DESC;

        SamplerDescs: array [0..Ord(TSamplerIndex.Count) - 1] of TD3D12_SAMPLER_DESC;
    public
        constructor Create({_In_}  device: ID3D12Device);
        destructor Destroy; override;
        function StaticPointWrap(shaderRegister: uint32 = 0; shaderVisibility: TD3D12_SHADER_VISIBILITY = D3D12_SHADER_VISIBILITY_ALL; registerSpace: uint32 = 0): TD3D12_STATIC_SAMPLER_DESC;
        function StaticPointClamp(shaderRegister: uint32 = 0; shaderVisibility: TD3D12_SHADER_VISIBILITY = D3D12_SHADER_VISIBILITY_ALL; registerSpace: uint32 = 0): TD3D12_STATIC_SAMPLER_DESC;
        function StaticLinearWrap(shaderRegister: uint32 = 0; shaderVisibility: TD3D12_SHADER_VISIBILITY = D3D12_SHADER_VISIBILITY_ALL; registerSpace: uint32 = 0): TD3D12_STATIC_SAMPLER_DESC;
        function StaticLinearClamp(shaderRegister: uint32 = 0; shaderVisibility: TD3D12_SHADER_VISIBILITY = D3D12_SHADER_VISIBILITY_ALL; registerSpace: uint32 = 0): TD3D12_STATIC_SAMPLER_DESC;
        function StaticAnisotropicWrap(shaderRegister: uint32 = 0; shaderVisibility: TD3D12_SHADER_VISIBILITY = D3D12_SHADER_VISIBILITY_ALL; registerSpace: uint32 = 0): TD3D12_STATIC_SAMPLER_DESC;
        function StaticAnisotropicClamp(shaderRegister: uint32 = 0; shaderVisibility: TD3D12_SHADER_VISIBILITY = D3D12_SHADER_VISIBILITY_ALL; registerSpace: uint32 = 0): TD3D12_STATIC_SAMPLER_DESC;

        // Sampler states.
        function PointWrap(): TD3D12_GPU_DESCRIPTOR_HANDLE;
        function PointClamp(): TD3D12_GPU_DESCRIPTOR_HANDLE;
        function LinearWrap(): TD3D12_GPU_DESCRIPTOR_HANDLE;
        function LinearClamp(): TD3D12_GPU_DESCRIPTOR_HANDLE;
        function AnisotropicWrap(): TD3D12_GPU_DESCRIPTOR_HANDLE;
        function AnisotropicClamp(): TD3D12_GPU_DESCRIPTOR_HANDLE;

        function Get(i: TSamplerIndex): TD3D12_GPU_DESCRIPTOR_HANDLE;


        function Heap: ID3D12DescriptorHeap;
    end;

implementation

//--------------------------------------------------------------------------------------
// File: CommonStates.cpp

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------

uses
    DX12TK.DirectXHelpers;


    { TCommonStates }

constructor TCommonStates.Create(device: ID3D12Device);
var
    i: size_t;
begin
    mDescriptors := TDescriptorHeap.Create(device, D3D12_DESCRIPTOR_HEAP_TYPE_SAMPLER, D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE, Ord(TSamplerIndex.Count));

    if (device = nil) then
        raise Exception.Create('Direct3D device is null');

    SetDebugObjectName(mDescriptors.Heap(), 'CommonStates');

    // --------------------------------------------------------------------------
    // Samplers
    // --------------------------------------------------------------------------

    // PointWrap
    with SamplerDescs[0] do
    begin
        Filter := D3D12_FILTER_MIN_MAG_MIP_POINT;
        AddressU := D3D12_TEXTURE_ADDRESS_MODE_WRAP;
        AddressV := D3D12_TEXTURE_ADDRESS_MODE_WRAP;
        AddressW := D3D12_TEXTURE_ADDRESS_MODE_WRAP;
        MipLODBias := 0;
        MaxAnisotropy := D3D12_MAX_MAXANISOTROPY;
        ComparisonFunc := D3D12_COMPARISON_FUNC_NEVER;
        BorderColor := [0, 0, 0, 0];
        MinLOD := 0;
        MaxLOD := FLT_MAX;
    end;
    // PointClamp
    with SamplerDescs[1] do
    begin
        Filter := D3D12_FILTER_MIN_MAG_MIP_POINT;
        AddressU := D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
        AddressV := D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
        AddressW := D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
        MipLODBias := 0;
        MaxAnisotropy := D3D12_MAX_MAXANISOTROPY;
        ComparisonFunc := D3D12_COMPARISON_FUNC_NEVER;
        BorderColor := [0, 0, 0, 0];
        MinLOD := 0;
        MaxLOD := FLT_MAX;
    end;
    // LinearWrap
    with SamplerDescs[2] do
    begin
        Filter := D3D12_FILTER_MIN_MAG_MIP_LINEAR;
        AddressU := D3D12_TEXTURE_ADDRESS_MODE_WRAP;
        AddressV := D3D12_TEXTURE_ADDRESS_MODE_WRAP;
        AddressW := D3D12_TEXTURE_ADDRESS_MODE_WRAP;
        MipLODBias := 0;
        MaxAnisotropy := D3D12_MAX_MAXANISOTROPY;
        ComparisonFunc := D3D12_COMPARISON_FUNC_NEVER;
        BorderColor := [0, 0, 0, 0];
        MinLOD := 0;
        MaxLOD := FLT_MAX;
    end;

    // LinearClamp
    with SamplerDescs[3] do
    begin
        Filter := D3D12_FILTER_MIN_MAG_MIP_LINEAR;
        AddressU := D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
        AddressV := D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
        AddressW := D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
        MipLODBias := 0;
        MaxAnisotropy := D3D12_MAX_MAXANISOTROPY;
        ComparisonFunc := D3D12_COMPARISON_FUNC_NEVER;
        BorderColor := [0, 0, 0, 0];
        MinLOD := 0;
        MaxLOD := FLT_MAX;
    end;

    // AnisotropicWrap
    with SamplerDescs[4] do
    begin
        Filter := D3D12_FILTER_ANISOTROPIC;
        AddressU := D3D12_TEXTURE_ADDRESS_MODE_WRAP;
        AddressV := D3D12_TEXTURE_ADDRESS_MODE_WRAP;
        AddressW := D3D12_TEXTURE_ADDRESS_MODE_WRAP;
        MipLODBias := 0;
        MaxAnisotropy := D3D12_MAX_MAXANISOTROPY;
        ComparisonFunc := D3D12_COMPARISON_FUNC_NEVER;
        BorderColor := [0, 0, 0, 0];
        MinLOD := 0;
        MaxLOD := FLT_MAX;
    end;

    // AnisotropicClamp
    with SamplerDescs[5] do
    begin
        Filter := D3D12_FILTER_ANISOTROPIC;
        AddressU := D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
        AddressV := D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
        AddressW := D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
        MipLODBias := 0;
        MaxAnisotropy := D3D12_MAX_MAXANISOTROPY;
        ComparisonFunc := D3D12_COMPARISON_FUNC_NEVER;
        BorderColor := [0, 0, 0, 0];
        MinLOD := 0;
        MaxLOD := FLT_MAX;
    end;


    for i := 0 to Ord(TSamplerIndex.Count) - 1 do
    begin
        device.CreateSampler(@SamplerDescs[i], mDescriptors.GetCpuHandle(i));
    end;

    // --------------------------------------------------------------------------
    // Blend States
    // --------------------------------------------------------------------------
    with Opaque do
    begin
        AlphaToCoverageEnable := False;
        IndependentBlendEnable := False;
        with RenderTarget[0] do
        begin
            BlendEnable := False;
            LogicOpEnable := False;
            SrcBlend := D3D12_BLEND_ONE;
            DestBlend := D3D12_BLEND_ZERO;
            BlendOp := D3D12_BLEND_OP_ADD;
            SrcBlendAlpha := D3D12_BLEND_ONE;
            DestBlendAlpha := D3D12_BLEND_ZERO;
            BlendOpAlpha := D3D12_BLEND_OP_ADD;
            LogicOp := D3D12_LOGIC_OP_NOOP;
            RenderTargetWriteMask := Ord(D3D12_COLOR_WRITE_ENABLE_ALL);
        end;
    end;

    with AlphaBlend do
    begin
        AlphaToCoverageEnable := False;
        IndependentBlendEnable := False;
        with RenderTarget[0] do
        begin
            BlendEnable := True;
            LogicOpEnable := False;
            SrcBlend := D3D12_BLEND_ONE;
            DestBlend := D3D12_BLEND_INV_SRC_ALPHA;
            BlendOp := D3D12_BLEND_OP_ADD;
            SrcBlendAlpha := D3D12_BLEND_ONE;
            DestBlendAlpha := D3D12_BLEND_INV_SRC_ALPHA;
            BlendOpAlpha := D3D12_BLEND_OP_ADD;
            LogicOp := D3D12_LOGIC_OP_NOOP;
            RenderTargetWriteMask := Ord(D3D12_COLOR_WRITE_ENABLE_ALL);
        end;
    end;


    with Additive do
    begin
        AlphaToCoverageEnable := False;
        IndependentBlendEnable := False;
        with RenderTarget[0] do
        begin
            BlendEnable := True;
            LogicOpEnable := False;
            SrcBlend := D3D12_BLEND_SRC_ALPHA;
            DestBlend := D3D12_BLEND_ONE;
            BlendOp := D3D12_BLEND_OP_ADD;
            SrcBlendAlpha := D3D12_BLEND_SRC_ALPHA;
            DestBlendAlpha := D3D12_BLEND_ONE;
            BlendOpAlpha := D3D12_BLEND_OP_ADD;
            LogicOp := D3D12_LOGIC_OP_NOOP;
            RenderTargetWriteMask := Ord(D3D12_COLOR_WRITE_ENABLE_ALL);
        end;
    end;

    with NonPremultiplied do
    begin
        AlphaToCoverageEnable := False;
        IndependentBlendEnable := False;
        with RenderTarget[0] do
        begin
            BlendEnable := True;
            LogicOpEnable := False;
            SrcBlend := D3D12_BLEND_SRC_ALPHA;
            DestBlend := D3D12_BLEND_INV_SRC_ALPHA;
            BlendOp := D3D12_BLEND_OP_ADD;
            SrcBlendAlpha := D3D12_BLEND_SRC_ALPHA;
            DestBlendAlpha := D3D12_BLEND_INV_SRC_ALPHA;
            BlendOpAlpha := D3D12_BLEND_OP_ADD;
            LogicOp := D3D12_LOGIC_OP_NOOP;
            RenderTargetWriteMask := Ord(D3D12_COLOR_WRITE_ENABLE_ALL);
        end;
    end;

    // --------------------------------------------------------------------------
    // Depth-Stencil States
    // --------------------------------------------------------------------------
    with DepthNone do
    begin
        DepthEnable := False;
        DepthWriteMask := D3D12_DEPTH_WRITE_MASK_ZERO;
        DepthFunc := D3D12_COMPARISON_FUNC_LESS_EQUAL;
        StencilEnable := False;
        StencilReadMask := D3D12_DEFAULT_STENCIL_READ_MASK;
        StencilWriteMask := D3D12_DEFAULT_STENCIL_WRITE_MASK;
        with FrontFace do
        begin
            StencilFailOp := D3D12_STENCIL_OP_KEEP;
            StencilDepthFailOp := D3D12_STENCIL_OP_KEEP;
            StencilPassOp := D3D12_STENCIL_OP_KEEP;
            StencilFunc := D3D12_COMPARISON_FUNC_ALWAYS;
        end;
        with BackFace do
        begin
            StencilFailOp := D3D12_STENCIL_OP_KEEP;
            StencilDepthFailOp := D3D12_STENCIL_OP_KEEP;
            StencilPassOp := D3D12_STENCIL_OP_KEEP;
            StencilFunc := D3D12_COMPARISON_FUNC_ALWAYS;
        end;
    end;

    with DepthDefault do
    begin
        DepthEnable := True;
        DepthWriteMask := D3D12_DEPTH_WRITE_MASK_ALL;
        DepthFunc := D3D12_COMPARISON_FUNC_LESS_EQUAL;
        StencilEnable := False;
        StencilReadMask := D3D12_DEFAULT_STENCIL_READ_MASK;
        StencilWriteMask := D3D12_DEFAULT_STENCIL_WRITE_MASK;
        with FrontFace do
        begin
            StencilFailOp := D3D12_STENCIL_OP_KEEP;
            StencilDepthFailOp := D3D12_STENCIL_OP_KEEP;
            StencilPassOp := D3D12_STENCIL_OP_KEEP;
            StencilFunc := D3D12_COMPARISON_FUNC_ALWAYS;
        end;
        with BackFace do
        begin
            StencilFailOp := D3D12_STENCIL_OP_KEEP;
            StencilDepthFailOp := D3D12_STENCIL_OP_KEEP;
            StencilPassOp := D3D12_STENCIL_OP_KEEP;
            StencilFunc := D3D12_COMPARISON_FUNC_ALWAYS;
        end;
    end;

    with DepthRead do
    begin
        DepthEnable := True;
        DepthWriteMask := D3D12_DEPTH_WRITE_MASK_ZERO;
        DepthFunc := D3D12_COMPARISON_FUNC_LESS_EQUAL;
        StencilEnable := False;
        StencilReadMask := D3D12_DEFAULT_STENCIL_READ_MASK;
        StencilWriteMask := D3D12_DEFAULT_STENCIL_WRITE_MASK;
        with FrontFace do
        begin
            StencilFailOp := D3D12_STENCIL_OP_KEEP;
            StencilDepthFailOp := D3D12_STENCIL_OP_KEEP;
            StencilPassOp := D3D12_STENCIL_OP_KEEP;
            StencilFunc := D3D12_COMPARISON_FUNC_ALWAYS;
        end;
        with BackFace do
        begin
            StencilFailOp := D3D12_STENCIL_OP_KEEP;
            StencilDepthFailOp := D3D12_STENCIL_OP_KEEP;
            StencilPassOp := D3D12_STENCIL_OP_KEEP;
            StencilFunc := D3D12_COMPARISON_FUNC_ALWAYS;
        end;
    end;


    with DepthReverseZ do
    begin
        DepthEnable := True;
        DepthWriteMask := D3D12_DEPTH_WRITE_MASK_ALL;
        DepthFunc := D3D12_COMPARISON_FUNC_GREATER_EQUAL;
        StencilEnable := False;
        StencilReadMask := D3D12_DEFAULT_STENCIL_READ_MASK;
        StencilWriteMask := D3D12_DEFAULT_STENCIL_WRITE_MASK;
        with FrontFace do
        begin
            StencilFailOp := D3D12_STENCIL_OP_KEEP;
            StencilDepthFailOp := D3D12_STENCIL_OP_KEEP;
            StencilPassOp := D3D12_STENCIL_OP_KEEP;
            StencilFunc := D3D12_COMPARISON_FUNC_ALWAYS;
        end;
        with BackFace do
        begin
            StencilFailOp := D3D12_STENCIL_OP_KEEP;
            StencilDepthFailOp := D3D12_STENCIL_OP_KEEP;
            StencilPassOp := D3D12_STENCIL_OP_KEEP;
            StencilFunc := D3D12_COMPARISON_FUNC_ALWAYS;
        end;
    end;


    with DepthReadReverseZ do
    begin
        DepthEnable := True;
        DepthWriteMask := D3D12_DEPTH_WRITE_MASK_ZERO;
        DepthFunc := D3D12_COMPARISON_FUNC_GREATER_EQUAL;
        StencilEnable := False;
        StencilReadMask := D3D12_DEFAULT_STENCIL_READ_MASK;
        StencilWriteMask := D3D12_DEFAULT_STENCIL_WRITE_MASK;
        with FrontFace do
        begin
            StencilFailOp := D3D12_STENCIL_OP_KEEP;
            StencilDepthFailOp := D3D12_STENCIL_OP_KEEP;
            StencilPassOp := D3D12_STENCIL_OP_KEEP;
            StencilFunc := D3D12_COMPARISON_FUNC_ALWAYS;
        end;
        with BackFace do
        begin
            StencilFailOp := D3D12_STENCIL_OP_KEEP;
            StencilDepthFailOp := D3D12_STENCIL_OP_KEEP;
            StencilPassOp := D3D12_STENCIL_OP_KEEP;
            StencilFunc := D3D12_COMPARISON_FUNC_ALWAYS;
        end;
    end;


    // --------------------------------------------------------------------------
    // Rasterizer States
    // --------------------------------------------------------------------------

    with CullNone do
    begin
        FillMode := D3D12_FILL_MODE_SOLID;
        CullMode := D3D12_CULL_MODE_NONE;
        FrontCounterClockwise := False;
        DepthBias := D3D12_DEFAULT_DEPTH_BIAS;
        DepthBiasClamp := D3D12_DEFAULT_DEPTH_BIAS_CLAMP;
        SlopeScaledDepthBias := D3D12_DEFAULT_SLOPE_SCALED_DEPTH_BIAS;
        DepthClipEnable := True;
        MultisampleEnable := True;
        AntialiasedLineEnable := False;
        ForcedSampleCount := 0;
        ConservativeRaster := D3D12_CONSERVATIVE_RASTERIZATION_MODE_OFF;
    end;


    with CullClockwise do
    begin
        FillMode := D3D12_FILL_MODE_SOLID;
        CullMode := D3D12_CULL_MODE_FRONT;
        FrontCounterClockwise := False;
        DepthBias := D3D12_DEFAULT_DEPTH_BIAS;
        DepthBiasClamp := D3D12_DEFAULT_DEPTH_BIAS_CLAMP;
        SlopeScaledDepthBias := D3D12_DEFAULT_SLOPE_SCALED_DEPTH_BIAS;
        DepthClipEnable := True;
        MultisampleEnable := True;
        AntialiasedLineEnable := False;
        ForcedSampleCount := 0;
        ConservativeRaster := D3D12_CONSERVATIVE_RASTERIZATION_MODE_OFF;
    end;

    with CullCounterClockwise do
    begin
        FillMode := D3D12_FILL_MODE_SOLID;
        CullMode := D3D12_CULL_MODE_BACK;
        FrontCounterClockwise := False;
        DepthBias := D3D12_DEFAULT_DEPTH_BIAS;
        DepthBiasClamp := D3D12_DEFAULT_DEPTH_BIAS_CLAMP;
        SlopeScaledDepthBias := D3D12_DEFAULT_SLOPE_SCALED_DEPTH_BIAS;
        DepthClipEnable := True;
        MultisampleEnable := True;
        AntialiasedLineEnable := False;
        ForcedSampleCount := 0;
        ConservativeRaster := D3D12_CONSERVATIVE_RASTERIZATION_MODE_OFF;
    end;


    with Wireframe do
    begin
        FillMode := D3D12_FILL_MODE_WIREFRAME;
        CullMode := D3D12_CULL_MODE_NONE;
        FrontCounterClockwise := False;
        DepthBias := D3D12_DEFAULT_DEPTH_BIAS;
        DepthBiasClamp := D3D12_DEFAULT_DEPTH_BIAS_CLAMP;
        SlopeScaledDepthBias := D3D12_DEFAULT_SLOPE_SCALED_DEPTH_BIAS;
        DepthClipEnable := True;
        MultisampleEnable := True;
        AntialiasedLineEnable := False;
        ForcedSampleCount := 0;
        ConservativeRaster := D3D12_CONSERVATIVE_RASTERIZATION_MODE_OFF;
    end;

end;



destructor TCommonStates.Destroy;
begin
    inherited Destroy;
end;

// --------------------------------------------------------------------------
// Static sampler States
// --------------------------------------------------------------------------

function TCommonStates.StaticPointWrap(shaderRegister: uint32; shaderVisibility: TD3D12_SHADER_VISIBILITY; registerSpace: uint32): TD3D12_STATIC_SAMPLER_DESC;
var
    desc: TD3D12_STATIC_SAMPLER_DESC;
begin
    with desc do
    begin
        Filter := D3D12_FILTER_MIN_MAG_MIP_POINT;
        AddressU := D3D12_TEXTURE_ADDRESS_MODE_WRAP;
        AddressV := D3D12_TEXTURE_ADDRESS_MODE_WRAP;
        AddressW := D3D12_TEXTURE_ADDRESS_MODE_WRAP;
        MipLODBias := 0;
        MaxAnisotropy := D3D12_MAX_MAXANISOTROPY;
        ComparisonFunc := D3D12_COMPARISON_FUNC_NEVER;
        BorderColor := D3D12_STATIC_BORDER_COLOR_OPAQUE_BLACK;
        MinLOD := 0;
        MaxLOD := FLT_MAX;
        ShaderRegister := shaderRegister;
        RegisterSpace := registerSpace;
        ShaderVisibility := shaderVisibility;
    end;
    Result := desc;
end;



function TCommonStates.StaticPointClamp(shaderRegister: uint32; shaderVisibility: TD3D12_SHADER_VISIBILITY; registerSpace: uint32): TD3D12_STATIC_SAMPLER_DESC;
var
    desc: TD3D12_STATIC_SAMPLER_DESC;
begin
    with desc do
    begin
        Filter := D3D12_FILTER_MIN_MAG_MIP_POINT;
        AddressU := D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
        AddressV := D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
        AddressW := D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
        MipLODBias := 0;
        MaxAnisotropy := D3D12_MAX_MAXANISOTROPY;
        ComparisonFunc := D3D12_COMPARISON_FUNC_NEVER;
        BorderColor := D3D12_STATIC_BORDER_COLOR_OPAQUE_BLACK;
        MinLOD := 0;
        MaxLOD := FLT_MAX;
        ShaderRegister := shaderRegister;
        RegisterSpace := registerSpace;
        ShaderVisibility := shaderVisibility;
    end;
    Result := desc;
end;



function TCommonStates.StaticLinearWrap(shaderRegister: uint32; shaderVisibility: TD3D12_SHADER_VISIBILITY; registerSpace: uint32): TD3D12_STATIC_SAMPLER_DESC;
var
    desc: TD3D12_STATIC_SAMPLER_DESC;
begin
    with desc do
    begin
        Filter := D3D12_FILTER_MIN_MAG_MIP_LINEAR;
        AddressU := D3D12_TEXTURE_ADDRESS_MODE_WRAP;
        AddressV := D3D12_TEXTURE_ADDRESS_MODE_WRAP;
        AddressW := D3D12_TEXTURE_ADDRESS_MODE_WRAP;
        MipLODBias := 0;
        MaxAnisotropy := D3D12_MAX_MAXANISOTROPY;
        ComparisonFunc := D3D12_COMPARISON_FUNC_NEVER;
        BorderColor := D3D12_STATIC_BORDER_COLOR_OPAQUE_BLACK;
        MinLOD := 0;
        MaxLOD := FLT_MAX;
        ShaderRegister := shaderRegister;
        RegisterSpace := registerSpace;
        ShaderVisibility := shaderVisibility;
    end;
    Result := desc;

end;



function TCommonStates.StaticLinearClamp(shaderRegister: uint32; shaderVisibility: TD3D12_SHADER_VISIBILITY; registerSpace: uint32): TD3D12_STATIC_SAMPLER_DESC;
var
    desc: TD3D12_STATIC_SAMPLER_DESC;
begin
    with desc do
    begin
        Filter := D3D12_FILTER_MIN_MAG_MIP_LINEAR;
        AddressU := D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
        AddressV := D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
        AddressW := D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
        MipLODBias := 0;
        MaxAnisotropy := D3D12_MAX_MAXANISOTROPY;
        ComparisonFunc := D3D12_COMPARISON_FUNC_NEVER;
        BorderColor := D3D12_STATIC_BORDER_COLOR_OPAQUE_BLACK;
        MinLOD := 0;
        MaxLOD := FLT_MAX;
        ShaderRegister := shaderRegister;
        RegisterSpace := registerSpace;
        ShaderVisibility := shaderVisibility;
    end;
    Result := desc;
end;



function TCommonStates.StaticAnisotropicWrap(shaderRegister: uint32; shaderVisibility: TD3D12_SHADER_VISIBILITY; registerSpace: uint32): TD3D12_STATIC_SAMPLER_DESC;
var
    desc: TD3D12_STATIC_SAMPLER_DESC;
begin
    with desc do
    begin
        Filter := D3D12_FILTER_ANISOTROPIC;
        AddressU := D3D12_TEXTURE_ADDRESS_MODE_WRAP;
        AddressV := D3D12_TEXTURE_ADDRESS_MODE_WRAP;
        AddressW := D3D12_TEXTURE_ADDRESS_MODE_WRAP;
        MipLODBias := 0;
        MaxAnisotropy := D3D12_MAX_MAXANISOTROPY;
        ComparisonFunc := D3D12_COMPARISON_FUNC_NEVER;
        BorderColor := D3D12_STATIC_BORDER_COLOR_OPAQUE_BLACK;
        MinLOD := 0;
        MaxLOD := FLT_MAX;
        ShaderRegister := shaderRegister;
        RegisterSpace := registerSpace;
        ShaderVisibility := shaderVisibility;
    end;

    Result := desc;
end;



function TCommonStates.StaticAnisotropicClamp(shaderRegister: uint32; shaderVisibility: TD3D12_SHADER_VISIBILITY; registerSpace: uint32): TD3D12_STATIC_SAMPLER_DESC;
var
    desc: TD3D12_STATIC_SAMPLER_DESC;
begin
    with desc do
    begin
        Filter := D3D12_FILTER_ANISOTROPIC;
        AddressU := D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
        AddressV := D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
        AddressW := D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
        MipLODBias := 0;
        MaxAnisotropy := D3D12_MAX_MAXANISOTROPY;
        ComparisonFunc := D3D12_COMPARISON_FUNC_NEVER;
        BorderColor := D3D12_STATIC_BORDER_COLOR_OPAQUE_BLACK;
        MinLOD := 0;
        MaxLOD := FLT_MAX;
        ShaderRegister := shaderRegister;
        RegisterSpace := registerSpace;
        ShaderVisibility := shaderVisibility;
    end;

    Result := desc;
end;



function TCommonStates.PointWrap(): TD3D12_GPU_DESCRIPTOR_HANDLE;
begin
    Result := Get(TSamplerIndex.PointWrap);
end;



function TCommonStates.PointClamp(): TD3D12_GPU_DESCRIPTOR_HANDLE;
begin
    Result := Get(TSamplerIndex.PointClamp);
end;



function TCommonStates.LinearWrap(): TD3D12_GPU_DESCRIPTOR_HANDLE;
begin
    Result := Get(TSamplerIndex.LinearWrap);
end;



function TCommonStates.LinearClamp(): TD3D12_GPU_DESCRIPTOR_HANDLE;
begin
    Result := Get(TSamplerIndex.LinearClamp);
end;



function TCommonStates.AnisotropicWrap(): TD3D12_GPU_DESCRIPTOR_HANDLE;
begin
    Result := Get(TSamplerIndex.AnisotropicWrap);
end;



function TCommonStates.AnisotropicClamp(): TD3D12_GPU_DESCRIPTOR_HANDLE;
begin
    Result := Get(TSamplerIndex.AnisotropicClamp);
end;



function TCommonStates.Get(i: TSamplerIndex): TD3D12_GPU_DESCRIPTOR_HANDLE;
begin
    Result := mDescriptors.GetGpuHandle(size_t(i));
end;



function TCommonStates.Heap: ID3D12DescriptorHeap;
begin
    Result := mDescriptors.Heap();
end;

end.
