unit DX12TK.AlphaTestEffect;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D12,
    DirectX.Math,
    DX12TK.Effects,
    DX12TK.EffectPipelineStateDescription,
    DX12TK.EffectCommon;

type
    // Constant buffer layout. Must match the shader!
    TAlphaTestEffectConstants = record
        diffuseColor: TXMVECTOR;
        alphaTest: TXMVECTOR;
        fogColor: TXMVECTOR;
        fogVector: TXMVECTOR;
        worldViewProj: TXMMATRIX;
    end;
    PAlphaTestEffectConstants = ^TAlphaTestEffectConstants;


    // Traits type describes our characteristics to the EffectBase template.

    { TAlphaTestEffectTraits }

    TAlphaTestEffectTraits = class(specialize TTraits<TAlphaTestEffectConstants>)
        function VertexShaderCount: int32; override;
        function PixelShaderCount: int32; override;
        function ShaderPermutationCount: int32; override;
        function RootSignatureCount: int32; override;
    end;


    { TAlphaTestEffect }

    TAlphaTestEffect = class(specialize TEffectBase<TAlphaTestEffectTraits, TAlphaTestEffectConstants>, IEffect, IEffectMatrices, IEffectFog)
    public
        mAlphaFunction: TD3D12_COMPARISON_FUNC;
        referenceAlpha: int32;

        color: TEffectColor;

        texture: TD3D12_GPU_DESCRIPTOR_HANDLE;
        textureSampler: TD3D12_GPU_DESCRIPTOR_HANDLE;
    public
        constructor Create({_In_ } device: ID3D12Device; effectFlags: uint32; pipelineDescription: TEffectPipelineStateDescription; alphaFunction: TD3D12_COMPARISON_FUNC = D3D12_COMPARISON_FUNC_GREATER);
        destructor Destroy; override;

        // IEffect methods.
        procedure Apply({_In_} commandList: ID3D12GraphicsCommandList);

        // Camera settings.
        procedure SetWorld(Value: TFXMMATRIX);
        procedure SetView(Value: TFXMMATRIX);
        procedure SetProjection(Value: TFXMMATRIX);
        procedure SetMatrices(world: TFXMMATRIX; view: TCXMMATRIX; projection: TCXMMATRIX);

        // Material settings.
        procedure SetDiffuseColor(Value: TFXMVECTOR);
        procedure SetAlpha(Value: single);
        procedure SetColorAndAlpha(Value: TFXMVECTOR);

        // Fog settings.
        procedure SetFogStart(Value: single);
        procedure SetFogEnd(Value: single);
        procedure SetFogColor(Value: TFXMVECTOR);

        // Texture setting.
        procedure SetTexture(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE; samplerDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);

        // Alpha test settings.
        procedure SetReferenceAlpha(Value: int32);
    public
        function GetPipelineStatePermutation(effectFlags: uint32): int32;
    end;



implementation

uses
    DX12.D3DX12_Core,
    DX12.D3DX12_Root_Signature,
    DX12.D3DCommon,
    DX12TK.PlatformHelpers,
    DX12TK.DirectXHelpers,
    DX12.D3DCompiler;

    //--------------------------------------------------------------------------------------
    // File: AlphaTestEffect.cpp

    // Copyright (c) Microsoft Corporation.
    // Licensed under the MIT License.

    // http://go.microsoft.com/fwlink/?LinkID=615561
    //--------------------------------------------------------------------------------------

type
    TRootParameterIndex = (
        ConstantBuffer,
        TextureSRV,
        TextureSampler,
        RootParameterCount
        );

    { TAlphaTestEffectTraits }

function TAlphaTestEffectTraits.VertexShaderCount: int32;
begin
    Result := 4;
end;



function TAlphaTestEffectTraits.PixelShaderCount: int32;
begin
    Result := 4;
end;



function TAlphaTestEffectTraits.ShaderPermutationCount: int32;
begin
    Result := 8;
end;



function TAlphaTestEffectTraits.RootSignatureCount: int32;
begin
    Result := 1;
end;



{ TAlphaTestEffect }

// Internal AlphaTestEffect implementation class.
constructor TAlphaTestEffect.Create(device: ID3D12Device; effectFlags: uint32; pipelineDescription: TEffectPipelineStateDescription; alphaFunction: TD3D12_COMPARISON_FUNC);
var
    hr:    HResult;
    compileFlags: UINT;
    VertexShader: ID3DBlob;
    PixelShader: ID3DBlob;
    error: ID3DBlob;
    i:     integer;

    rootSignatureFlags: TD3D12_ROOT_SIGNATURE_FLAGS;
    textureRange: TD3D12_DESCRIPTOR_RANGE;
    textureSamplerRange: TD3D12_DESCRIPTOR_RANGE;
    rootParameters: array [0..Ord(TRootParameterIndex.RootParameterCount) - 1] of TD3D12_ROOT_PARAMETER;
    rsigDesc:   TD3D12_ROOT_SIGNATURE_DESC;
    sp, vi, pi: int32;
begin
    inherited Create(device);
    mAlphaFunction := alphaFunction;
    referenceAlpha := 0;

    // assert(length(VertexShaderIndices)) = AlphaTestEffectTraits.ShaderPermutationCount, 'array/max mismatch');
    //static_assert(static_cast<int>(std.size(EffectBase<AlphaTestEffectTraits>.VertexShaderBytecode)) == AlphaTestEffectTraits.VertexShaderCount, 'array/max mismatch');
    //static_assert(static_cast<int>(std.size(EffectBase<AlphaTestEffectTraits>.PixelShaderBytecode)) == AlphaTestEffectTraits.PixelShaderCount, 'array/max mismatch');
    //static_assert(static_cast<int>(std.size(EffectBase<AlphaTestEffectTraits>.PixelShaderIndices)) == AlphaTestEffectTraits.ShaderPermutationCount, 'array/max mismatch');


    // Include the shader code.
    hr := D3DCompileFromFile(pwidechar('.\shaders\AlphaTestEffect.fx'), nil, nil, 'VSAlphaTest', 'vs_6_0', compileFlags, 0, VertexShader, @error);
    if hr = S_OK then
    begin
        VertexShaderBytecode[0].pShaderBytecode := VertexShader.GetBufferPointer();
        VertexShaderBytecode[0].BytecodeLength  := VertexShader.GetBufferSize();
    end;

    hr := D3DCompileFromFile(pwidechar('.\shaders\AlphaTestEffect.fx'), nil, nil, 'VSAlphaTestNoFog', 'vs_6_0', compileFlags, 0, VertexShader, @error);
    if hr = S_OK then
    begin
        VertexShaderBytecode[1].pShaderBytecode := VertexShader.GetBufferPointer();
        VertexShaderBytecode[1].BytecodeLength  := VertexShader.GetBufferSize();
    end;

    hr := D3DCompileFromFile(pwidechar('.\shaders\AlphaTestEffect.fx'), nil, nil, 'VSAlphaTestVc', 'vs_6_0', compileFlags, 0, VertexShader, @error);
    if hr = S_OK then
    begin
        VertexShaderBytecode[2].pShaderBytecode := VertexShader.GetBufferPointer();
        VertexShaderBytecode[2].BytecodeLength  := VertexShader.GetBufferSize();
    end;

    hr := D3DCompileFromFile(pwidechar('.\shaders\AlphaTestEffect.fx'), nil, nil, 'VSAlphaTestVcNoFog', 'vs_6_0', compileFlags, 0, VertexShader, @error);
    if hr = S_OK then
    begin
        VertexShaderBytecode[2].pShaderBytecode := VertexShader.GetBufferPointer();
        VertexShaderBytecode[2].BytecodeLength  := VertexShader.GetBufferSize();
    end;

    hr := D3DCompileFromFile(pwidechar('.\shaders\AlphaTestEffect.fx'), nil, nil, 'PSAlphaTestLtGt', 'ps_6_0', compileFlags, 0, PixelShader, @error);
    if hr = S_OK then
    begin
        PixelShaderBytecode[0].pShaderBytecode := VertexShader.GetBufferPointer();
        PixelShaderBytecode[0].BytecodeLength  := VertexShader.GetBufferSize();
    end;

    hr := D3DCompileFromFile(pwidechar('.\shaders\AlphaTestEffect.fx'), nil, nil, 'PSAlphaTestLtGtNoFog', 'ps_6_0', compileFlags, 0, PixelShader, @error);
    if hr = S_OK then
    begin
        PixelShaderBytecode[1].pShaderBytecode := VertexShader.GetBufferPointer();
        PixelShaderBytecode[1].BytecodeLength  := VertexShader.GetBufferSize();
    end;

    hr := D3DCompileFromFile(pwidechar('.\shaders\AlphaTestEffect.fx'), nil, nil, 'PSAlphaTestEqNe', 'ps_6_0', compileFlags, 0, PixelShader, @error);
    if hr = S_OK then
    begin
        PixelShaderBytecode[2].pShaderBytecode := VertexShader.GetBufferPointer();
        PixelShaderBytecode[2].BytecodeLength  := VertexShader.GetBufferSize();
    end;

    hr := D3DCompileFromFile(pwidechar('.\shaders\AlphaTestEffect.fx'), nil, nil, 'PSAlphaTestEqNeNoFog', 'ps_6_0', compileFlags, 0, PixelShader, @error);
    if hr = S_OK then
    begin
        PixelShaderBytecode[3].pShaderBytecode := VertexShader.GetBufferPointer();
        PixelShaderBytecode[3].BytecodeLength  := VertexShader.GetBufferSize();
    end;




    VertexShaderIndices := [0,      // lt/gt
        1,      // lt/gt, no fog
        2,      // lt/gt, vertex color
        3,      // lt/gt, vertex color, no fog

        0,      // eq/ne
        1,      // eq/ne, no fog
        2,      // eq/ne, vertex color
        3       // eq/ne, vertex color, no fog
        ];

    PixelShaderIndices := [0,      // lt/gt
        1,      // lt/gt, no fog
        0,      // lt/gt, vertex color
        1,      // lt/gt, vertex color, no fog

        2,      // eq/ne
        3,      // eq/ne, no fog
        2,      // eq/ne, vertex color
        3       // eq/ne, vertex color, no fog
        ];

    // Create root signature.
    begin
        rootSignatureFlags := TD3D12_ROOT_SIGNATURE_FLAGS(Ord(D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT) or Ord(D3D12_ROOT_SIGNATURE_FLAG_DENY_DOMAIN_SHADER_ROOT_ACCESS) or
            Ord(D3D12_ROOT_SIGNATURE_FLAG_DENY_GEOMETRY_SHADER_ROOT_ACCESS) or Ord(D3D12_ROOT_SIGNATURE_FLAG_DENY_HULL_SHADER_ROOT_ACCESS)
            {$IFDEF _GAMING_XBOX_SCARLETT}
            or  ord( D3D12_ROOT_SIGNATURE_FLAG_DENY_AMPLIFICATION_SHADER_ROOT_ACCESS)
            or  ord( D3D12_ROOT_SIGNATURE_FLAG_DENY_MESH_SHADER_ROOT_ACCESS)
            {$ENDIF}
            );

        textureRange.Init(Ord(D3D12_DESCRIPTOR_RANGE_TYPE_SRV), 1, 0);
        textureSamplerRange.Init(Ord(D3D12_DESCRIPTOR_RANGE_TYPE_SAMPLER), 1, 0);


        rootParameters[Ord(TRootParameterIndex.TextureSRV)].InitAsDescriptorTable(1, @textureRange, D3D12_SHADER_VISIBILITY_PIXEL);
        rootParameters[Ord(TRootParameterIndex.TextureSampler)].InitAsDescriptorTable(1, @textureSamplerRange, D3D12_SHADER_VISIBILITY_PIXEL);
        rootParameters[Ord(TRootParameterIndex.ConstantBuffer)].InitAsConstantBufferView(0, 0, D3D12_SHADER_VISIBILITY_ALL);


        rsigDesc.Init(Length(rootParameters), @rootParameters[0], 0, nil, rootSignatureFlags);

        mRootSignature := GetRootSignature(0, @rsigDesc);
    end;

    assert(mRootSignature <> nil);

    fog.Enabled := (effectFlags and Ord(TEffectFlags.Fog)) <> 0;

    if ((effectFlags and Ord(TEffectFlags.PerPixelLightingBit)) <> 0) then
    begin
        DebugTrace('ERROR: AlphaTestEffect does not implement EffectFlags.PerPixelLighting\n', []);
        raise Exception.Create('PerPixelLighting effect flag is invalid');
    end
    else if ((effectFlags and Ord(TEffectFlags.Lighting)) <> 0) then
    begin
        DebugTrace('ERROR: AlphaTestEffect does not implement EffectFlags.Lighting\n', []);
        raise Exception.Create('Lighting effect flag is invalid');
    end
    else if ((effectFlags and Ord(TEffectFlags.Instancing)) <> 0) then
    begin
        DebugTrace('ERROR: AlphaTestEffect does not implement EffectFlags.Instancing\n', []);
        raise Exception.Create('Instancing effect flag is invalid');
    end;

    // Create pipeline state.
    sp := GetPipelineStatePermutation(effectFlags);
    assert((sp >= 0) and (sp < constants.ShaderPermutationCount));


    vi := VertexShaderIndices[sp];
    assert((vi >= 0) and (vi < constants.VertexShaderCount));

    pi := PixelShaderIndices[sp];
    assert((pi >= 0) and (pi < constants.PixelShaderCount));


    pipelineDescription.CreatePipelineState(
        device,
        mRootSignature,
        VertexShaderBytecode[vi],
        PixelShaderBytecode[pi],
        mPipelineState);

    SetDebugObjectName(mPipelineState, 'AlphaTestEffect');
end;



destructor TAlphaTestEffect.Destroy;
begin
    inherited Destroy;
end;


// Sets our state onto the D3D device.
procedure TAlphaTestEffect.Apply(commandList: ID3D12GraphicsCommandList);
// What to do if the alpha comparison passes or fails. Positive accepts the pixel, negative clips it.
const
    selectIfTrue: TXMVECTORF32 = (f: (1, -1, 0, 0));
    selectIfFalse: TXMVECTORF32 = (f: (-1, 1, 0, 0));
    selectNever: TXMVECTORF32 = (f: (-1, -1, 0, 0));
    selectAlways: TXMVECTORF32 = (f: (1, 1, 0, 0));
var
    reference, threshold, compareTo: single;
    resultSelector: TXMVECTOR;
begin
    // Compute derived parameter values.
    matrices.SetConstants(dirtyFlags, constants.ConstantBufferType.worldViewProj);
    fog.SetConstants(dirtyFlags, matrices.worldView, constants.ConstantBufferType.fogVector);
    color.SetConstants(dirtyFlags, constants.ConstantBufferType.diffuseColor);

    UpdateConstants();

    // Recompute the alpha test settings?
    if ((dirtyFlags and Ord(TEffectDirtyFlags.AlphaTest)) <> 0) then
    begin
        // Convert reference alpha from 8 bit integer to 0-1 float format.
        reference := referenceAlpha / 255.0;

        // Comparison tolerance of half the 8 bit integer precision.
        threshold := 0.5 / 255.0;




        case (mAlphaFunction) of

            D3D12_COMPARISON_FUNC_LESS:
            begin
                // Shader will evaluate: clip((a < x) ? z : w)
                compareTo      := reference - threshold;
                resultSelector := selectIfTrue;
            end;

            D3D12_COMPARISON_FUNC_LESS_EQUAL:
            begin
                // Shader will evaluate: clip((a < x) ? z : w)
                compareTo      := reference + threshold;
                resultSelector := selectIfTrue;
            end;

            D3D12_COMPARISON_FUNC_GREATER_EQUAL:
            begin
                // Shader will evaluate: clip((a < x) ? z : w)
                compareTo      := reference - threshold;
                resultSelector := selectIfFalse;
            end;

            D3D12_COMPARISON_FUNC_GREATER:
            begin
                // Shader will evaluate: clip((a < x) ? z : w)
                compareTo      := reference + threshold;
                resultSelector := selectIfFalse;
            end;

            D3D12_COMPARISON_FUNC_EQUAL:
            begin
                // Shader will evaluate: clip((abs(a - x) < y) ? z : w)
                compareTo      := reference;
                resultSelector := selectIfTrue;
            end;

            D3D12_COMPARISON_FUNC_NOT_EQUAL:
            begin
                // Shader will evaluate: clip((abs(a - x) < y) ? z : w)
                compareTo      := reference;
                resultSelector := selectIfFalse;
            end;

            D3D12_COMPARISON_FUNC_NEVER:
            begin
                // Shader will evaluate: clip((a < x) ? z : w)
                compareTo      := 0;
                resultSelector := selectNever;
            end;

            D3D12_COMPARISON_FUNC_ALWAYS:
            begin
                // Shader will evaluate: clip((a < x) ? z : w)
                compareTo      := 0;
                resultSelector := selectAlways;
            end;

            else
                raise Exception.Create('Unknown alpha test function');
        end;

        // x := compareTo, y := threshold, zw := resultSelector.
        constants.ConstantBufferType.alphaTest := XMVectorPermute(0, 1, 4, 5, XMVectorSet(compareTo, threshold, 0, 0), resultSelector);

        dirtyFlags := dirtyFlags and not Ord(TEffectDirtyFlags.AlphaTest);
        dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.ConstantBuffer);
    end;

    // Set the root signature
    commandList.SetGraphicsRootSignature(mRootSignature);

    // Set the texture
    if (texture.ptr = 0) or (textureSampler.ptr = 0) then
    begin
        DebugTrace('ERROR: Missing texture or sampler for AlphaTestEffect (texture %llu, sampler %llu)\n', [texture.ptr, textureSampler.ptr]);
        raise Exception.Create('AlphaTestEffect');
    end;

    // **NOTE** If D3D asserts or crashes here, you probably need to call commandList.SetDescriptorHeaps() with the required descriptor heaps.
    commandList.SetGraphicsRootDescriptorTable(Ord(TRootParameterIndex.TextureSRV), texture);
    commandList.SetGraphicsRootDescriptorTable(Ord(TRootParameterIndex.TextureSampler), textureSampler);

    // Set constants
    commandList.SetGraphicsRootConstantBufferView(Ord(TRootParameterIndex.ConstantBuffer), GetConstantBufferGpuAddress());

    // Set the pipeline state
    commandList.SetPipelineState(mPipelineState);
end;


// Camera settings
procedure TAlphaTestEffect.SetWorld(Value: TFXMMATRIX);
begin
    matrices.world := Value;
    dirtyFlags     := dirtyFlags or Ord(TEffectDirtyFlags.WorldViewProj) or Ord(TEffectDirtyFlags.WorldInverseTranspose) or Ord(TEffectDirtyFlags.FogVector);
end;



procedure TAlphaTestEffect.SetView(Value: TFXMMATRIX);
begin
    matrices.view := Value;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.WorldViewProj) or Ord(TEffectDirtyFlags.EyePosition) or Ord(TEffectDirtyFlags.FogVector);

end;



procedure TAlphaTestEffect.SetProjection(Value: TFXMMATRIX);
begin
    matrices.projection := Value;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.WorldViewProj);
end;



procedure TAlphaTestEffect.SetMatrices(world: TFXMMATRIX; view: TCXMMATRIX; projection: TCXMMATRIX);
begin
    matrices.world := world;
    matrices.view  := view;
    matrices.projection := projection;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.WorldViewProj) or Ord(TEffectDirtyFlags.WorldInverseTranspose) or Ord(TEffectDirtyFlags.EyePosition) or Ord(TEffectDirtyFlags.FogVector);

end;


// Material settings
procedure TAlphaTestEffect.SetDiffuseColor(Value: TFXMVECTOR);
begin
    color.diffuseColor := Value;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.MaterialColor);

end;



procedure TAlphaTestEffect.SetAlpha(Value: single);
begin
    color.alpha := Value;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.MaterialColor);
end;



procedure TAlphaTestEffect.SetColorAndAlpha(Value: TFXMVECTOR);
begin
    color.diffuseColor := Value;
    color.alpha := XMVectorGetW(Value);

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.MaterialColor);
end;


// Fog settings.
procedure TAlphaTestEffect.SetFogStart(Value: single);
begin
    fog.startfog := Value;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.FogVector);
end;



procedure TAlphaTestEffect.SetFogEnd(Value: single);
begin
    fog.endfog := Value;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.FogVector);
end;



procedure TAlphaTestEffect.SetFogColor(Value: TFXMVECTOR);
begin
    constants.ConstantBufferType.fogColor := Value;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.ConstantBuffer);
end;


// Texture settings.
procedure TAlphaTestEffect.SetTexture(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE; samplerDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);
begin
    texture := srvDescriptor;
    textureSampler := samplerDescriptor;
end;



procedure TAlphaTestEffect.SetReferenceAlpha(Value: int32);
begin
    referenceAlpha := Value;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.AlphaTest);
end;



function TAlphaTestEffect.GetPipelineStatePermutation(effectFlags: uint32): int32;
var
    permutation: int32 = 0;
begin
    // Use optimized shaders if fog is disabled.
    if (not fog.Enabled) then
    begin
        permutation := permutation + 1;
    end;

    // Support vertex coloring?
    if ((effectFlags and Ord(TEffectFlags.VertexColor)) <> 0) then
    begin
        permutation := permutation + 2;
    end;

    // Which alpha compare mode?
    if (mAlphaFunction = D3D12_COMPARISON_FUNC_EQUAL) or (mAlphaFunction = D3D12_COMPARISON_FUNC_NOT_EQUAL) then
    begin
        permutation := permutation + 4;
    end;

    Result := permutation;
end;

end.
