 //--------------------------------------------------------------------------------------
 // File: BasicEffect.cpp

 // Copyright (c) Microsoft Corporation.
 // Licensed under the MIT License.

 // http://go.microsoft.com/fwlink/?LinkID=615561
 //--------------------------------------------------------------------------------------

unit DX12TK.BasicEffect;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12TK.Effects,
    DX12TK.EffectCommon,
    DirectX.Math;

type
    // Constant buffer layout. Must match the shader!
    TBasicEffectConstants = record
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
    PBasicEffectConstants = ^TBasicEffectConstants;

    // Traits type describes our characteristics to the EffectBase template.

    { TBasicEffectTraits }

    TBasicEffectTraits = class(specialize TTraits<TBasicEffectConstants>)
        function VertexShaderCount: int32; override;
        function PixelShaderCount: int32; override;
        function ShaderPermutationCount: int32; override;
        function RootSignatureCount: int32; override;
    end;

    TRootParameterIndex = (
        ConstantBuffer,
        TextureSRV,
        TextureSampler,
        RootParameterCount);

    PRootParameterIndex = ^TRootParameterIndex;

    // Internal BasicEffect implementation class.
    // TBasicEffect = class(specialize TEffectBase<TBasicEffectTraits, TBasicEffectConstants>, IEffect, IEffectMatrices, IEffectFog)

    // end;

implementation

{ TBasicEffectTraits }

function TBasicEffectTraits.VertexShaderCount: int32;
begin
    Result := 24;
end;



function TBasicEffectTraits.PixelShaderCount: int32;
begin
    Result := 10;
end;



function TBasicEffectTraits.ShaderPermutationCount: int32;
begin
    Result := 40;
end;



function TBasicEffectTraits.RootSignatureCount: int32;
begin
    Result := 2;
end;

end.
