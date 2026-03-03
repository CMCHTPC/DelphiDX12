unit DX12TK.NormalMapEffect;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DirectX.Math,
    DX12TK.GraphicsMemory,
    DX12TK.Effects,
    DX12TK.EffectPipelineStateDescription,
    DX12.D3D12;

const
    cConstantBufferBones = $100000;

type
    // Constant buffer layout. Must match the shader!
    TNormalMapEffectConstants = record
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
        worldInverseTranspose: array [0..3 - 1] of TXMVECTOR;
        worldViewProj: TXMMATRIX;
    end;
    PNormalMapEffectConstants = ^TNormalMapEffectConstants;

    TBoneConstants = record
        Bones: array [0..MaxBones - 1, 0..3 - 1] of TXMVECTOR;
    end align 16;

    // Traits type describes our characteristics to the EffectBase template.

    { TNormalMapEffectTraits }
    {$IFDEF Test}

    TNormalMapEffectTraits =  class(specialize TTraits<TNormalMapEffectConstants>)
        // using ConstantBufferType = NormalMapEffectConstants;
        class function RootSignatureCount: int32; override;

    {    VertexShaderCount: int32 = 20; static;
        PixelShaderCount = 4;
        ShaderPermutationCount = 40;
            }
    end;



    TRootParameterIndex = (
        TextureSRV,
        TextureNormalSRV,
        TextureSampler,
        ConstantBuffer,
        ConstantBufferBones,
        TextureSpecularSRV,
        RootParameterCount);

    PRootParameterIndex = ^TRootParameterIndex;


    // Internal NormalMapEffect implementation class.
    TNormalMapEffect = class(specialize TEffectBase<TNormalMapEffectTraits>)
    private
        mBones: TGraphicsResource;
    public
        weightsPerVertex: int32;
        specularMap: boolean;
        texture: TD3D12_GPU_DESCRIPTOR_HANDLE;
        normal: TD3D12_GPU_DESCRIPTOR_HANDLE;
        specular: TD3D12_GPU_DESCRIPTOR_HANDLE;
        sampler: TD3D12_GPU_DESCRIPTOR_HANDLE;

        lights: TEffectLights;
        boneConstants: TBoneConstants;
    public
        constructor Create({_In_} device: ID3D12Device);
        destructor Destroy; override;
        procedure Initialize(
        {_In_ } device: ID3D12Device; effectFlags: uint32; pipelineDescription: PEffectPipelineStateDescription; enableSkinning: boolean);
        function GetPipelineStatePermutation(effectFlags: uint32): int32;

        procedure Apply({_In_} commandList: ID3D12GraphicsCommandList);
    end;
      {$ENDIF}

implementation

{$IFDEF Test}
{ TNormalMapEffectTraits }

class function TNormalMapEffectTraits.RootSignatureCount: int32;
begin
    Result := 2;
end;


// Constructor.
constructor TNormalMapEffect.Create(device: ID3D12Device);
begin
    inherited Create(Device);
    weightsPerVertex := 0;
    specularMap      := False;

   // assert((EffectBase<NormalMapEffectTraits>::VertexShaderIndices)) == NormalMapEffectTraits::ShaderPermutationCount, "array/max mismatch");
  //  assert((EffectBase<NormalMapEffectTraits>::VertexShaderBytecode)) == NormalMapEffectTraits::VertexShaderCount, "array/max mismatch");
   // assert((EffectBase<NormalMapEffectTraits>::PixelShaderBytecode)) == NormalMapEffectTraits::PixelShaderCount, "array/max mismatch");
    //assert((EffectBase<NormalMapEffectTraits>::PixelShaderIndices)) == NormalMapEffectTraits::ShaderPermutationCount, "array/max mismatch");
end;



destructor TNormalMapEffect.Destroy;
begin
    inherited Destroy;
end;



procedure TNormalMapEffect.Initialize(device: ID3D12Device; effectFlags: uint32; pipelineDescription: PEffectPipelineStateDescription; enableSkinning: boolean);
begin
   specularMap := (effectFlags and TEffectFlags.Specular) <> 0;
end;



function TNormalMapEffect.GetPipelineStatePermutation(effectFlags: uint32): int32;
begin

end;



procedure TNormalMapEffect.Apply(commandList: ID3D12GraphicsCommandList);
begin

end;
{$ENDIF}

end.
