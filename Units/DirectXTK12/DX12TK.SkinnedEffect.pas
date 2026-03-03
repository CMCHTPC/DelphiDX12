unit DX12TK.SkinnedEffect;

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
    // Built-in shader supports skinned animation.

    // Constant buffer layout. Must match the shader!
    TSkinnedEffectConstants = record
        diffuseColor: TXMVECTOR;
        emissiveColor: TXMVECTOR;
        specularColorAndPower: TXMVECTOR;
        lightDirection: array [0..MaxDirectionalLights - 1] of TXMVECTOR;
        lightDiffuseColor: array [0..MaxDirectionalLights - 1] of TXMVECTOR;
        lightSpecularColor: array [0..MaxDirectionalLights - 1] of TXMVECTOR;
        eyePosition: TXMVECTOR;
        fogColor: TXMVECTOR;
        fogVector: TXMVECTOR;
        world: TXMMATRIX;
        worldInverseTranspose: array [0..2] of TXMVECTOR;
        worldViewProj: TXMMATRIX;
        bones: array [0..MaxBones - 1, 0..2] of TXMVECTOR;
    end;

    { TSkinnedEffectTraits }

    // Traits type describes our characteristics to the EffectBase template.
    TSkinnedEffectTraits = class(specialize TTraits<TSkinnedEffectConstants>)
        function VertexShaderCount: int32; override;
        function PixelShaderCount: int32; override;
        function ShaderPermutationCount: int32; override;
        function RootSignatureCount: int32; override;
    end;




    { TSkinnedEffect }

    // SkinnedEffect implementation class.
    TSkinnedEffect = class(specialize TEffectBase<TSkinnedEffectTraits, TSkinnedEffectConstants>, IEffect, IEffectMatrices, IEffectLights, IEffectFog, IEffectSkinning)
    public
        texture: TD3D12_GPU_DESCRIPTOR_HANDLE;
        sampler: TD3D12_GPU_DESCRIPTOR_HANDLE;

        lights: TEffectLights;
        function GetPipelineStatePermutation(effectFlags: uint32): int32;
    public
        constructor Create(
        {_In_ } device: ID3D12Device; effectFlags: uint32; pipelineDescription: TEffectPipelineStateDescription);
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
        procedure SetEmissiveColor(Value: TFXMVECTOR);
        procedure SetSpecularColor(Value: TFXMVECTOR);
        procedure SetSpecularPower(Value: single);
        procedure DisableSpecular();
        procedure SetAlpha(Value: single);
        procedure SetColorAndAlpha(Value: TFXMVECTOR);


        // Light settings.
        procedure SetAmbientLightColor(Value: TFXMVECTOR);
        procedure SetLightEnabled(whichLight: int32; Value: winbool);
        procedure SetLightDirection(whichLight: int32; Value: TFXMVECTOR);
        procedure SetLightDiffuseColor(whichLight: int32; Value: TFXMVECTOR);
        procedure SetLightSpecularColor(whichLight: int32; Value: TFXMVECTOR);
        procedure EnableDefaultLighting();

        // Fog settings.
        procedure SetFogStart(Value: single);
        procedure SetFogEnd(Value: single);
        procedure SetFogColor(Value: TFXMVECTOR);

        // Texture settings.
        procedure SetTexture(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE; samplerDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);

        // Animation settings.
        procedure SetBoneTransforms({_In_reads_(count) } Value: PXMMATRIX; Count: size_t);
        procedure ResetBoneTransforms();
    end;


implementation

uses
    DX12.D3DX12_Core,
    DX12.D3DX12_Root_Signature,
    DX12.D3DCommon,
    DX12TK.PlatformHelpers,
    DX12TK.DirectXHelpers,
    DX12.D3DCompiler;

type
    TRootParameterIndex = (
        ConstantBuffer,
        TextureSRV,
        TextureSampler,
        RootParameterCount);

    PRootParameterIndex = ^TRootParameterIndex;

    {TSkinnedEffectTraits }

function TSkinnedEffectTraits.VertexShaderCount: int32;
begin
    Result := 4;
end;



function TSkinnedEffectTraits.PixelShaderCount: int32;
begin
    Result := 3;
end;



function TSkinnedEffectTraits.ShaderPermutationCount: int32;
begin
    Result := 8;
end;



function TSkinnedEffectTraits.RootSignatureCount: int32;
begin
    Result := 1;
end;


{ TSkinnedEffect }

function TSkinnedEffect.GetPipelineStatePermutation(effectFlags: uint32): int32;
var
    permutation: int32;
begin
    permutation := 0;

    // Use optimized shaders if fog is disabled.
    if (not fog.Enabled) then
    begin
        permutation := permutation + 1;
    end;

    if ((effectFlags and Ord(TEffectFlags.PerPixelLightingBit)) <> 0) then
    begin
        // Do lighting in the pixel shader.
        permutation := permutation + 2;
    end;

    if ((effectFlags and Ord(TEffectFlags.BiasedVertexNormals)) <> 0) then
    begin
        // Compressed normals need to be scaled and biased in the vertex shader.
        permutation := permutation + 4;
    end;

    Result := permutation;
end;



constructor TSkinnedEffect.Create(device: ID3D12Device; effectFlags: uint32; pipelineDescription: TEffectPipelineStateDescription);
var
    hr:    HResult;
    compileFlags: UINT;
    VertexShader: ID3DBlob;
    PixelShader: ID3DBlob;
    error: ID3DBlob;
    i:     integer;

    rootSignatureFlags: TD3D12_ROOT_SIGNATURE_FLAGS;
    textureSrvDescriptorRange: TD3D12_DESCRIPTOR_RANGE;
    textureSamplerDescriptorRange: TD3D12_DESCRIPTOR_RANGE;
    rootParameters: array of TD3D12_ROOT_PARAMETER;
    rsigDesc:   TD3D12_ROOT_SIGNATURE_DESC;
    sp, vi, pi: int32;
begin
    inherited Create(device);

    hr := D3DCompileFromFile(pwidechar('.\shaders\SkinnedEffect.fx'), nil, nil, 'VSSkinnedVertexLightingFourBones', 'vs_6_0', compileFlags, 0, VertexShader, @error);
    if hr = S_OK then
    begin
        VertexShaderBytecode[0].pShaderBytecode := VertexShader.GetBufferPointer();
        VertexShaderBytecode[0].BytecodeLength  := VertexShader.GetBufferSize();
    end;

    hr := D3DCompileFromFile(pwidechar('.\shaders\SkinnedEffect.fx'), nil, nil, 'VSSkinnedPixelLightingFourBones', 'vs_6_0', compileFlags, 0, VertexShader, @error);
    if hr = S_OK then
    begin
        VertexShaderBytecode[1].pShaderBytecode := VertexShader.GetBufferPointer();
        VertexShaderBytecode[1].BytecodeLength  := VertexShader.GetBufferSize();
    end;

    hr := D3DCompileFromFile(pwidechar('.\shaders\SkinnedEffect.fx'), nil, nil, 'VSSkinnedVertexLightingFourBonesBn', 'vs_6_0', compileFlags, 0, VertexShader, @error);
    if hr = S_OK then
    begin
        VertexShaderBytecode[2].pShaderBytecode := VertexShader.GetBufferPointer();
        VertexShaderBytecode[2].BytecodeLength  := VertexShader.GetBufferSize();
    end;

    hr := D3DCompileFromFile(pwidechar('.\shaders\SkinnedEffect.fx'), nil, nil, 'VSSkinnedPixelLightingFourBonesBn', 'vs_6_0', compileFlags, 0, VertexShader, @error);
    if hr = S_OK then
    begin
        VertexShaderBytecode[3].pShaderBytecode := PixelShader.GetBufferPointer();
        VertexShaderBytecode[3].BytecodeLength  := PixelShader.GetBufferSize();
    end;

    hr := D3DCompileFromFile(pwidechar('.\shaders\SkinnedEffect.fx'), nil, nil, 'PSSkinnedVertexLighting', 'ps_6_0', compileFlags, 0, PixelShader, @error);
    if hr = S_OK then
    begin
        PixelShaderBytecode[0].pShaderBytecode := VertexShader.GetBufferPointer();
        PixelShaderBytecode[0].BytecodeLength  := VertexShader.GetBufferSize();

    end;

    hr := D3DCompileFromFile(pwidechar('.\shaders\SkinnedEffect.fx'), nil, nil, 'PSSkinnedVertexLightingNoFog', 'ps_6_0', compileFlags, 0, PixelShader, @error);
    if hr = S_OK then
    begin
        PixelShaderBytecode[1].pShaderBytecode := VertexShader.GetBufferPointer();
        PixelShaderBytecode[1].BytecodeLength  := VertexShader.GetBufferSize();

    end;

    hr := D3DCompileFromFile(pwidechar('.\shaders\SkinnedEffect.fx'), nil, nil, 'PSSkinnedPixelLighting', 'ps_6_0', compileFlags, 0, PixelShader, @error);
    if hr = S_OK then
    begin
        PixelShaderBytecode[2].pShaderBytecode := VertexShader.GetBufferPointer();
        PixelShaderBytecode[2].BytecodeLength  := VertexShader.GetBufferSize();

    end;

    VertexShaderIndices := [0,  // vertex lighting, four bones
        0,  // vertex lighting, four bones, no fog

        1,  // pixel lighting, four bones
        1,  // pixel lighting, four bones, no fog

        2,  // vertex lighting (biased vertex normals), four bones
        2,  // vertex lighting (biased vertex normals), four bones, no fog

        3,  // pixel lighting (biased vertex normals), four bones
        3   // pixel lighting (biased vertex normals), four bones, no fog
        ];

    PixelShaderIndices := [0,      // vertex lighting, four bones
        1,      // vertex lighting, four bones, no fog

        2,      // pixel lighting, four bones
        2,      // pixel lighting, four bones, no fog

        0,      // vertex lighting (biased vertex normals), four bones
        1,      // vertex lighting (biased vertex normals), four bones, no fog

        2,      // pixel lighting (biased vertex normals), four bones
        2       // pixel lighting (biased vertex normals), four bones, no fog
        ];

    assert(length(VertexShaderIndices) = TSkinnedEffectTraits(constants).ShaderPermutationCount, 'array/max mismatch');
  (* assert(static_cast<int>(std::size(EffectBase<>::VertexShaderBytecode)) == SkinnedEffectTraits::VertexShaderCount, "array/max mismatch");
    assert(static_cast<int>(std::size(EffectBase<SkinnedEffectTraits>::PixelShaderBytecode)) == SkinnedEffectTraits::PixelShaderCount, "array/max mismatch");
    assert(static_cast<int>(std::size(EffectBase<SkinnedEffectTraits>::PixelShaderIndices)) == SkinnedEffectTraits::ShaderPermutationCount, "array/max mismatch");
 *)
    lights.InitializeConstants(@constants.ConstantBufferType.specularColorAndPower, @constants.ConstantBufferType.lightDirection, @constants.ConstantBufferType.lightDiffuseColor[0], @constants.ConstantBufferType.lightSpecularColor[0]);

    for   i := 0 to MaxBones - 1 do
    begin
        constants.ConstantBufferType.bones[i][0] := g_XMIdentityR0;
        constants.ConstantBufferType.bones[i][1] := g_XMIdentityR1;
        constants.ConstantBufferType.bones[i][2] := g_XMIdentityR2;
    end;

    // Create root signature.
    begin
        rootSignatureFlags := TD3D12_ROOT_SIGNATURE_FLAGS(Ord(D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT) or Ord(D3D12_ROOT_SIGNATURE_FLAG_DENY_DOMAIN_SHADER_ROOT_ACCESS) or
            Ord(D3D12_ROOT_SIGNATURE_FLAG_DENY_GEOMETRY_SHADER_ROOT_ACCESS) or Ord(D3D12_ROOT_SIGNATURE_FLAG_DENY_HULL_SHADER_ROOT_ACCESS)
            {$IFDEF _GAMING_XBOX_SCARLETT}
            or ord(D3D12_ROOT_SIGNATURE_FLAG_DENY_AMPLIFICATION_SHADER_ROOT_ACCESS)
            or ord(D3D12_ROOT_SIGNATURE_FLAG_DENY_MESH_SHADER_ROOT_ACCESS)
            {$ENDIF}
            );

        textureSrvDescriptorRange.Init(Ord(D3D12_DESCRIPTOR_RANGE_TYPE_SRV), 1, 0);
        textureSamplerDescriptorRange.Init(Ord(D3D12_DESCRIPTOR_RANGE_TYPE_SAMPLER), 1, 0);


        SetLength(rootParameters, Ord(TRootParameterIndex.RootParameterCount));

        rootParameters[Ord(TRootParameterIndex.TextureSRV)].InitAsDescriptorTable(1, @textureSrvDescriptorRange, D3D12_SHADER_VISIBILITY_PIXEL);
        rootParameters[Ord(TRootParameterIndex.TextureSampler)].InitAsDescriptorTable(1, @textureSamplerDescriptorRange, D3D12_SHADER_VISIBILITY_PIXEL);
        rootParameters[Ord(TRootParameterIndex.ConstantBuffer)].InitAsConstantBufferView(0, 0, D3D12_SHADER_VISIBILITY_ALL);


        rsigDesc.Init(Length(rootParameters), @rootParameters[0], 0, nil, rootSignatureFlags);

        mRootSignature := GetRootSignature(0, @rsigDesc);
    end;

    assert(mRootSignature <> nil);

    fog.Enabled := (effectFlags and Ord(TEffectFlags.Fog)) <> 0;

    if ((effectFlags and Ord(TEffectFlags.VertexColor)) <> 0) then
    begin
        DebugTrace('ERROR: SkinnedEffect does not implement EffectFlags::VertexColor\n', []);
        raise Exception.Create('VertexColor effect flag is invalid');
    end
    else if ((effectFlags and Ord(TEffectFlags.Instancing)) <> 0) then
    begin
        DebugTrace('ERROR: SkinnedEffect does not implement EffectFlags::Instancing\n', []);
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

    SetDebugObjectName(mPipelineState, 'SkinnedEffect');

end;



destructor TSkinnedEffect.Destroy;
begin
    inherited Destroy;
end;


// Sets our state onto the D3D device.
procedure TSkinnedEffect.Apply(commandList: ID3D12GraphicsCommandList);
begin
    // Compute derived parameter values.
    matrices.SetConstants(dirtyFlags, constants.ConstantBufferType.worldViewProj);
    fog.SetConstants(dirtyFlags, matrices.worldView, constants.ConstantBufferType.fogVector);
    lights.SetConstants(dirtyFlags, matrices, constants.ConstantBufferType.world, constants.ConstantBufferType.worldInverseTranspose, constants.ConstantBufferType.eyePosition,
        constants.ConstantBufferType.diffuseColor, constants.ConstantBufferType.emissiveColor, True);

    UpdateConstants();

    // Set the root signature
    commandList.SetGraphicsRootSignature(mRootSignature);

    // Set the texture
    if (texture.ptr = 0) or (sampler.ptr = 0) then
    begin
        DebugTrace('ERROR: Missing texture or sampler for SkinnedEffect (texture %llu, sampler %llu)\n', [texture.ptr, sampler.ptr]);
        raise Exception.Create('SkinnedEffect');
    end;

    // **NOTE** If D3D asserts or crashes here, you probably need to call commandList.SetDescriptorHeaps() with the required descriptor heaps.
    commandList.SetGraphicsRootDescriptorTable(Ord(TRootParameterIndex.TextureSRV), texture);
    commandList.SetGraphicsRootDescriptorTable(Ord(TRootParameterIndex.TextureSampler), sampler);

    // Set constants
    commandList.SetGraphicsRootConstantBufferView(Ord(TRootParameterIndex.ConstantBuffer), GetConstantBufferGpuAddress());

    // Set the pipeline state
    commandList.SetPipelineState(mPipelineState);
end;


// Camera settings.
procedure TSkinnedEffect.SetWorld(Value: TFXMMATRIX);
begin
    matrices.world := Value;
    dirtyFlags     := dirtyFlags or Ord(TEffectDirtyFlags.WorldViewProj) or Ord(TEffectDirtyFlags.WorldInverseTranspose) or Ord(TEffectDirtyFlags.FogVector);
end;



procedure TSkinnedEffect.SetView(Value: TFXMMATRIX);
begin
    matrices.view := Value;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.WorldViewProj) or Ord(TEffectDirtyFlags.EyePosition) or Ord(TEffectDirtyFlags.FogVector);

end;



procedure TSkinnedEffect.SetProjection(Value: TFXMMATRIX);
begin
    matrices.projection := Value;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.WorldViewProj);
end;



procedure TSkinnedEffect.SetMatrices(world: TFXMMATRIX; view: TCXMMATRIX; projection: TCXMMATRIX);
begin
    matrices.world := world;
    matrices.view  := view;
    matrices.projection := projection;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.WorldViewProj) or Ord(TEffectDirtyFlags.WorldInverseTranspose) or Ord(TEffectDirtyFlags.EyePosition) or Ord(TEffectDirtyFlags.FogVector);

end;


// Material settings.
procedure TSkinnedEffect.SetDiffuseColor(Value: TFXMVECTOR);
begin
    lights.diffuseColor := Value;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.MaterialColor);
end;



procedure TSkinnedEffect.SetEmissiveColor(Value: TFXMVECTOR);
begin
    lights.emissiveColor := Value;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.MaterialColor);
end;



procedure TSkinnedEffect.SetSpecularColor(Value: TFXMVECTOR);
begin
    // Set xyz to new value, but preserve existing w (specular power).
    constants.ConstantBufferType.specularColorAndPower := XMVectorSelect(constants.ConstantBufferType.specularColorAndPower, Value, g_XMSelect1110);

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.ConstantBuffer);
end;



procedure TSkinnedEffect.SetSpecularPower(Value: single);
begin
    // Set w to new value, but preserve existing xyz (specular color).
    constants.ConstantBufferType.specularColorAndPower := XMVectorSetW(constants.ConstantBufferType.specularColorAndPower, Value);

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.ConstantBuffer);
end;



procedure TSkinnedEffect.DisableSpecular();
begin
    // Set specular color to black, power to 1
    // Note: Don't use a power of 0 or the shader will generate strange highlights on non-specular materials

    constants.ConstantBufferType.specularColorAndPower := g_XMIdentityR3;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.ConstantBuffer);
end;



procedure TSkinnedEffect.SetAlpha(Value: single);
begin
    lights.alpha := Value;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.MaterialColor);
end;



procedure TSkinnedEffect.SetColorAndAlpha(Value: TFXMVECTOR);
begin
    lights.diffuseColor := Value;
    lights.alpha := XMVectorGetW(Value);

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.MaterialColor);
end;


// Light settings.
procedure TSkinnedEffect.SetAmbientLightColor(Value: TFXMVECTOR);
begin
    lights.ambientLightColor := Value;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.MaterialColor);
end;



procedure TSkinnedEffect.SetLightEnabled(whichLight: int32; Value: winbool);
begin
    dirtyFlags := dirtyFlags or lights.SetLightEnabled(whichLight, Value, constants.ConstantBufferType.lightDiffuseColor, constants.ConstantBufferType.lightSpecularColor);
end;



procedure TSkinnedEffect.SetLightDirection(whichLight: int32; Value: TFXMVECTOR);
begin
    TEffectLights.ValidateLightIndex(whichLight);

    constants.ConstantBufferType.lightDirection[whichLight] := Value;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.ConstantBuffer);
end;



procedure TSkinnedEffect.SetLightDiffuseColor(whichLight: int32; Value: TFXMVECTOR);
begin
    dirtyFlags := dirtyFlags or lights.SetLightDiffuseColor(whichLight, Value, constants.ConstantBufferType.lightDiffuseColor);
end;



procedure TSkinnedEffect.SetLightSpecularColor(whichLight: int32; Value: TFXMVECTOR);
begin
    dirtyFlags := dirtyFlags or lights.SetLightSpecularColor(whichLight, Value, constants.ConstantBufferType.lightSpecularColor);
end;



procedure TSkinnedEffect.EnableDefaultLighting();
begin
    TEffectLights.EnableDefaultLighting(self);
end;


// Fog settings.
procedure TSkinnedEffect.SetFogStart(Value: single);
begin
    fog.startFog := Value;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.FogVector);
end;



procedure TSkinnedEffect.SetFogEnd(Value: single);
begin
    fog.endFog := Value;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.FogVector);
end;



procedure TSkinnedEffect.SetFogColor(Value: TFXMVECTOR);
begin
    constants.ConstantBufferType.fogColor := Value;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.ConstantBuffer);
end;


// Texture settings.
procedure TSkinnedEffect.SetTexture(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE; samplerDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);
begin
    texture := srvDescriptor;
    sampler := samplerDescriptor;
end;


// Animation settings.
procedure TSkinnedEffect.SetBoneTransforms(Value: PXMMATRIX; Count: size_t);
var
    i: size_t;
begin
    if (Count > MaxBones) then
        raise Exception.Create('count parameter exceeds MaxBones');


    for i := 0 to Count - 1 do
    begin
        //#if DIRECTX_MATH_VERSION >= 313
        XMStoreFloat3x4A(TXMFLOAT3X4A(constants.ConstantBufferType.bones[i]), Value[i]);
 {   #else
            // Xbox One XDK has an older version of DirectXMath
        XMMATRIX boneMatrix := XMMatrixTranspose(value[i]);

        boneConstant[i][0] := boneMatrix.r[0];
        boneConstant[i][1] := boneMatrix.r[1];
        boneConstant[i][2] := boneMatrix.r[2];
    #endif      }
    end;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.ConstantBuffer);
end;



procedure TSkinnedEffect.ResetBoneTransforms();
var
    i: size_t;
begin
    for  i := 0 to MaxBones - 1 do
    begin
        constants.ConstantBufferType.bones[i, 0] := g_XMIdentityR0;
        constants.ConstantBufferType.bones[i, 1] := g_XMIdentityR1;
        constants.ConstantBufferType.bones[i, 2] := g_XMIdentityR2;
    end;

    dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.ConstantBuffer);
end;

initialization
    {$IFOPT D+}
    assert((sizeof(TSkinnedEffectConstants) mod 16) = 0, 'CB size not padded correctly');
    {$ENDIF}



end.
