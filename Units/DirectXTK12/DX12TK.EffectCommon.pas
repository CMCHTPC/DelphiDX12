 //--------------------------------------------------------------------------------------
 // File: EffectCommon.h

 // Copyright (c) Microsoft Corporation.
 // Licensed under the MIT License.

 // http://go.microsoft.com/fwlink/?LinkID:=615561
 //--------------------------------------------------------------------------------------
unit DX12TK.EffectCommon;

{$IFDEF FPC}
{$mode delphi}{$H+}
//{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$modeswitch nestedprocvars}
{$ENDIF}


interface

uses
    Windows, Classes, SysUtils,
    CStdSharedPtr,
    syncobjs,
    DX12.D3D12,
    DX12TK.Effects,
    DX12TK.GraphicsMemory,
    DX12TK.Traits,
    DirectX.Math;

type
    // Bitfield tracks which derived parameter values need to be recomputed.
    TEffectDirtyFlags = (
        ConstantBuffer = $01,
        WorldViewProj = $02,
        WorldInverseTranspose = $04,
        EyePosition = $08,
        MaterialColor = $10,
        FogVector = $20,
        FogEnable = $40,
        AlphaTest = $80);

    PEffectDirtyFlags = ^TEffectDirtyFlags;

    // Helper stores matrix parameter values, and computes derived matrices.

    { TEffectMatrices }

    TEffectMatrices = record
        world: TXMMATRIX;
        view: TXMMATRIX;
        projection: TXMMATRIX;
        worldView: TXMMATRIX;

        procedure SetConstants(
        {_Inout_ } var dirtyFlags: int32;
        {_Inout_ } var worldViewProjConstant: TXMMATRIX);
        class operator Initialize(var A: TEffectMatrices);

    end;
    PEffectMatrices = ^TEffectMatrices;

    // Helper stores the current fog settings, and computes derived shader parameters.

    { TEffectFog }

    TEffectFog = record
        Enabled: boolean;
        startFog: single;
        endFog: single;

        procedure SetConstants(
        {_Inout_ } var dirtyFlags: int32;
        {_In_ } worldView: TFXMMATRIX;
        {_Inout_ } var fogVectorConstant: TXMVECTOR);
        class operator Initialize(var A: TEffectFog);
    end;
    PEffectFog = ^TEffectFog;




    // Helper stores material color settings, and computes derived parameters for shaders that do not support realtime lighting.

    { TEffectColor }

    TEffectColor = record
        diffuseColor: TXMVECTOR;
        alpha: single;
        procedure SetConstants(
        {_Inout_ } var dirtyFlags: int32;
        {_Inout_ } var diffuseColorConstant: TXMVECTOR);
        class operator Initialize(var A: TEffectColor);
    end;
    PEffectColor = ^TEffectColor;


    // Helper stores the current light settings, and computes derived shader parameters.

    { TEffectLights }

    TEffectLights = record
        // Fields.
        diffuseColor: tXMVECTOR;
        alpha: single;
        emissiveColor: tXMVECTOR;
        ambientLightColor: tXMVECTOR;
        lightEnabled: array [0..MaxDirectionalLights - 1] of boolean;
        lightDiffuseColor: array [0..MaxDirectionalLights - 1] of tXMVECTOR;
        lightSpecularColor: array [0..MaxDirectionalLights - 1] of tXMVECTOR;

        // Methods.
        procedure InitializeConstants(
        {_Out_ } specularColorAndPowerConstant: PXMVECTOR;
        {_Out_writes_all_(MaxDirectionalLights) } lightDirectionConstant: PXMVECTOR;
        {_Out_writes_all_(MaxDirectionalLights) } lightDiffuseConstant: PXMVECTOR;
        {_Out_writes_all_(MaxDirectionalLights) } lightSpecularConstant: PXMVECTOR);

        procedure SetConstants(
        {_Inout_ } dirtyFlags: int32;
        {_In_ } matrices: TEffectMatrices;
        {_Inout_ } var worldConstant: TXMMATRIX;
        {_Inout_updates_(3) } worldInverseTransposeConstant: PXMVECTOR;
        {_Inout_ } var eyePositionConstant: TXMVECTOR;
        {_Inout_ } var diffuseColorConstant: TXMVECTOR;
        {_Inout_ } var emissiveColorConstant: TXMVECTOR; lightingEnabled: boolean); overload;


        function SetLightEnabled(whichLight: int32; Value: boolean;
        {_Inout_updates_(MaxDirectionalLights) } lightDiffuseConstant: PXMVECTOR;
        {_Inout_updates_(MaxDirectionalLights) } lightSpecularConstant: PXMVECTOR): int32;

        function SetLightDiffuseColor(whichLight: int32; Value: TFXMVECTOR;
        {_Inout_updates_(MaxDirectionalLights) } lightDiffuseConstant: PXMVECTOR): int32;

        function SetLightSpecularColor(whichLight: int32; Value: TFXMVECTOR;
        {_Inout_updates_(MaxDirectionalLights) } lightSpecularConstant: PXMVECTOR): int32;
        class procedure ValidateLightIndex(whichLight: int32); static;
        class procedure EnableDefaultLighting(
        {_In_ } effect: IEffectLights); static;

        //function MaxDirectionalLights(): integer; //  IEffectLights_MaxDirectionalLights;
        class operator Initialize(var A: TEffectLights);
    end;
    PEffectLights = ^TEffectLights;

    // Factory for lazily instantiating shared root signatures.

    { TEffectDeviceResources }

    TEffectDeviceResources = class(TObject)
    protected
        mDevice: ID3D12Device;
        mMutex: TCriticalSection;
    public
        constructor Create({_In_}  device: ID3D12Device);
        destructor Destroy; override;
        function DemandCreateRootSig({_Inout_} var rootSig: ID3D12RootSignature; const desc: PD3D12_ROOT_SIGNATURE_DESC): ID3D12RootSignature;
    end;


    {generic} TTraits<T> = class
        ConstantBufferType: T;
        function VertexShaderCount: int32; virtual; abstract;
        function PixelShaderCount: int32; virtual; abstract;
        function ShaderPermutationCount: int32; virtual; abstract;
        function RootSignatureCount: int32; virtual; abstract;
    end;
    { TDeviceResources }

    TDeviceResources<TT> = class(TEffectDeviceResources)
    private
        mRootSignature: array {[0..T.RootSignatureCount - 1]} of ID3D12RootSignature;
        FTrait: TT;
    public
        constructor Create({_In_} device: ID3D12Device);
        destructor Destroy; override;
        function GetDevice(): ID3D12Device;
        // Gets or lazily creates the specified root signature
        function GetRootSignature(slot: int32; desc: PD3D12_ROOT_SIGNATURE_DESC): ID3D12RootSignature;
    end;


    { TEffectBase }

    TEffectBase<TT, TC> = class(TObject)
    private
        // D3D constant buffer holds a copy of the same data as the public 'constants' field.
        mConstantBuffer: TGraphicsResource;
        //        deviceResourcesPool: specialize TSharedResourcePool<ID3D12Device, specialize TDeviceResources<T>>;
    protected
        // Static arrays hold all the precompiled shader permutations.
        VertexShaderBytecode: array of TD3D12_SHADER_BYTECODE;
        PixelShaderBytecode: array of TD3D12_SHADER_BYTECODE;
        // .. and shader entry points
        VertexShaderIndices: array of int32;
        PixelShaderIndices: array of int32;
        // ... and vertex layout tables
        VertexShaderInputLayouts: array of TD3D12_INPUT_LAYOUT_DESC;

        // Per instance cache of PSOs, populated with variants for each shader & layout
        mPipelineState: ID3D12PipelineState;

        // Per instance root signature
        mRootSignature: ID3D12RootSignature;
        // Per-device resources.
        mDeviceResources: TCStdSharedPtr<TDeviceResources<TT>>;
    public
        // Fields.
        matrices: TEffectMatrices;
        fog: TEffectFog;
        dirtyFlags: int32;
        constants: TT;
    public
        // Constructor.
        constructor Create({_In_}  device: ID3D12Device);
        // Commits constants to the constant buffer memory
        procedure UpdateConstants();
        function GetConstantBufferGpuAddress(): TD3D12_GPU_VIRTUAL_ADDRESS;
        function GetRootSignature(slot: int32; rootSig: PD3D12_ROOT_SIGNATURE_DESC): ID3D12RootSignature;
        function GetDevice(): ID3D12Device;
    end;

implementation

uses
    DX12TK.DirectXHelpers,
    DX12TK.DemandCreate;


    //--------------------------------------------------------------------------------------
    // File: EffectCommon.cpp

    // Copyright (c) Microsoft Corporation.
    // Licensed under the MIT License.

    // http://go.microsoft.com/fwlink/?LinkID:=615561
    //--------------------------------------------------------------------------------------

    { TEffectDeviceResources }

constructor TEffectDeviceResources.Create(device: ID3D12Device);
begin
    mDevice := device;
end;



destructor TEffectDeviceResources.Destroy;
begin
    inherited Destroy;
end;


// Gets or lazily creates the specified root signature.
function TEffectDeviceResources.DemandCreateRootSig(var rootSig: ID3D12RootSignature; const desc: PD3D12_ROOT_SIGNATURE_DESC): ID3D12RootSignature;
begin
    // this is realy bad, Delphi mode has no nested functions but generics is simpler
    // ObjFPC has nested function but generics are ugly
    // so we make a helper function %)

    // at the moment I do not know if such Bu**s*it is also necessary in Pascal, I don't believe...
    Result := TEffectDeviceResources_DemandCreateRootSig(mDevice, mMutex, rootSig, desc);
end;

{ TDeviceResources }

constructor TDeviceResources<TT>.Create(device: ID3D12Device);
begin
    inherited Create(Device);
    SetLength(mRootSignature, 0);
    FTrait := TT.Create;
end;



destructor TDeviceResources<TT>.Destroy;
begin
    inherited Destroy;
end;



function TDeviceResources<TT>.GetDevice(): ID3D12Device;
begin
    Result := mDevice;
end;



function TDeviceResources<TT>.GetRootSignature(slot: int32; desc: PD3D12_ROOT_SIGNATURE_DESC): ID3D12RootSignature;
begin
    assert((slot >= 0) and (slot < FTrait.RootSignatureCount));
    Result := DemandCreateRootSig(mRootSignature[slot], desc);
end;

{ TEffectBase }

{ TEffectLights }

// Initializes constant buffer fields to match the current lighting state.
procedure TEffectLights.InitializeConstants(specularColorAndPowerConstant: PXMVECTOR; lightDirectionConstant: PXMVECTOR; lightDiffuseConstant: PXMVECTOR; lightSpecularConstant: PXMVECTOR);
const
    defaultSpecular: TXMVECTORF32 = (f: (1, 1, 1, 16));
    defaultLightDirection: TXMVECTORF32 = (f: (0, -1, 0, 0));
var
    i: integer;
begin
    specularColorAndPowerConstant^ := defaultSpecular;

    for  i := 0 to MaxDirectionalLights - 1 do
    begin
        lightDirectionConstant^ := defaultLightDirection;
        Inc(lightDirectionConstant);

        if lightEnabled[i] then lightDiffuseConstant^ := lightDiffuseColor[i]
        else
            lightDiffuseConstant^ := g_XMZero;
        Inc(lightDiffuseConstant);
        if lightEnabled[i] then lightSpecularConstant^ := lightSpecularColor[i]
        else
            lightSpecularConstant^ := g_XMZero;
        Inc(lightSpecularConstant);
    end;
end;


// Lazily recomputes derived parameter values used by shader lighting calculations.
procedure TEffectLights.SetConstants(dirtyFlags: int32; matrices: TEffectMatrices; var worldConstant: TXMMATRIX; worldInverseTransposeConstant: PXMVECTOR; var eyePositionConstant: TXMVECTOR;
    var diffuseColorConstant: TXMVECTOR; var emissiveColorConstant: TXMVECTOR; lightingEnabled: boolean);
var
    worldInverse: TXMMATRIX;
    viewInverse:  TXMMATRIX;
    diffuse:      TXMVECTOR;
    alphaVector:  TXMVECTOR;
begin
    if (lightingEnabled) then
    begin
        // World inverse transpose matrix.
        if ((dirtyFlags and Ord(TEffectDirtyFlags.WorldInverseTranspose)) <> 0) then
        begin
            worldConstant := XMMatrixTranspose(matrices.world);

            worldInverse := XMMatrixInverse(nil, matrices.world);

            worldInverseTransposeConstant^ := worldInverse.r[0];
            Inc(worldInverseTransposeConstant);
            worldInverseTransposeConstant ^ := worldInverse.r[1];
            Inc(worldInverseTransposeConstant);
            worldInverseTransposeConstant^ := worldInverse.r[2];

            dirtyFlags := dirtyFlags and not Ord(TEffectDirtyFlags.WorldInverseTranspose);
            dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.ConstantBuffer);
        end;

        // Eye position vector.
        if ((dirtyFlags and Ord(TEffectDirtyFlags.EyePosition)) <> 0) then
        begin
            viewInverse := XMMatrixInverse(nil, matrices.view);

            eyePositionConstant := viewInverse.r[3];

            dirtyFlags := dirtyFlags and not Ord(TEffectDirtyFlags.EyePosition);
            dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.ConstantBuffer);
        end;
    end;

    // Material color parameters. The desired lighting model is:

    //     ((ambientLightColor + sum(diffuse directional light)) * diffuseColor) + emissiveColor

    // When lighting is disabled, ambient and directional lights are ignored, leaving:

    //     diffuseColor + emissiveColor

    // For the lighting disabled case, we can save one shader instruction by precomputing
    // diffuse+emissive on the CPU, after which the shader can use diffuseColor directly,
    // ignoring its emissive parameter.

    // When lighting is enabled, we can merge the ambient and emissive settings. If we
    // set our emissive parameter to emissive+(ambient*diffuse), the shader no longer
    // needs to bother adding the ambient contribution, simplifying its computation to:

    //     (sum(diffuse directional light) * diffuseColor) + emissiveColor

    // For futher optimization goodness, we merge material alpha with the diffuse
    // color parameter, and premultiply all color values by this alpha.

    if ((dirtyFlags and Ord(TEffectDirtyFlags.MaterialColor)) <> 0) then
    begin

        diffuse     := diffuseColor;
        alphaVector := XMVectorReplicate(alpha);

        if (lightingEnabled) then
        begin
            // Merge emissive and ambient light contributions.
            // (emissiveColor + ambientLightColor * diffuse) * alphaVector;
            emissiveColorConstant := XMVectorMultiply(XMVectorMultiplyAdd(ambientLightColor, diffuse, emissiveColor), alphaVector);
        end
        else
        begin
            // Merge diffuse and emissive light contributions.
            diffuse := XMVectorAdd(diffuse, emissiveColor);
        end;

        // xyz := diffuse * alpha, w := alpha.
        diffuseColorConstant := XMVectorSelect(alphaVector, XMVectorMultiply(diffuse, alphaVector), g_XMSelect1110);

        dirtyFlags := dirtyFlags and not Ord(TEffectDirtyFlags.MaterialColor);
        dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.ConstantBuffer);
    end;
end;


// Helper for turning one of the directional lights on or off.
function TEffectLights.SetLightEnabled(whichLight: int32; Value: boolean; lightDiffuseConstant: PXMVECTOR; lightSpecularConstant: PXMVECTOR): int32;
begin
    ValidateLightIndex(whichLight);

    if (lightEnabled[whichLight] = Value) then
    begin
        Result := 0;
        Exit;
    end;

    lightEnabled[whichLight] := Value;

    if (Value) then
    begin
        // If this light is now on, store its color in the constant buffer.
        Inc(lightDiffuseConstant, whichLight);
        lightDiffuseConstant^ := lightDiffuseColor[whichLight];
        Inc(lightSpecularConstant, whichLight);
        lightSpecularConstant^ := lightSpecularColor[whichLight];
    end
    else
    begin
        // If the light is off, reset constant buffer colors to zero.
        Inc(lightDiffuseConstant, whichLight);
        lightDiffuseConstant^ := g_XMZero;
        Inc(lightSpecularConstant, whichLight);
        lightSpecularConstant^ := g_XMZero;
    end;

    Result := Ord(TEffectDirtyFlags.ConstantBuffer);
end;


// Helper for setting diffuse color of one of the directional lights.
function TEffectLights.SetLightDiffuseColor(whichLight: int32; Value: TFXMVECTOR; lightDiffuseConstant: PXMVECTOR): int32;
begin
    Result := 0;
    ValidateLightIndex(whichLight);

    // Locally store the new color.

    lightDiffuseColor[whichLight] := Value;

    // If this light is currently on, also update the constant buffer.
    if (lightEnabled[whichLight]) then
    begin
        Inc(lightDiffuseConstant, whichLight);
        lightDiffuseConstant^ := Value;

        Result := Ord(TEffectDirtyFlags.ConstantBuffer);
    end;
end;


// Helper for setting specular color of one of the directional lights.
function TEffectLights.SetLightSpecularColor(whichLight: int32; Value: TFXMVECTOR; lightSpecularConstant: PXMVECTOR): int32;
begin
    Result := 0;
    ValidateLightIndex(whichLight);

    // Locally store the new color.
    lightSpecularColor[whichLight] := Value;

    // If this light is currently on, also update the constant buffer.
    if (lightEnabled[whichLight]) then
    begin
        // set the light
        Inc(lightSpecularConstant, whichLight);
        lightSpecularConstant^ := Value;

        Result := Ord(TEffectDirtyFlags.ConstantBuffer);
    end;
end;


// Parameter validation helper.
class procedure TEffectLights.ValidateLightIndex(whichLight: int32);
begin
    if (whichLight < 0) or (whichLight >= MaxDirectionalLights) then
    begin
        raise Exception.Create('whichLight parameter invalid');
    end;
end;


// Activates the default lighting rig (key, fill, and back lights).
class procedure TEffectLights.EnableDefaultLighting(effect: IEffectLights);
var
    i: integer;
const
    defaultDirections: array [0..MaxDirectionalLights - 1] of TXMVECTORF32 = (
        (f: (-0.5265408, -0.5735765, -0.6275069, 0)),
        (f: (0.7198464, 0.3420201, 0.6040227, 0)),
        (f: (0.4545195, -0.7660444, 0.4545195, 0))
        );

    defaultDiffuse: array [0..MaxDirectionalLights - 1] of TXMVECTORF32 = (
        (f: (1.0000000, 0.9607844, 0.8078432, 0)),
        (f: (0.9647059, 0.7607844, 0.4078432, 0)),
        (f: (0.3231373, 0.3607844, 0.3937255, 0))
        );

    defaultSpecular: array [0..MaxDirectionalLights - 1] of TXMVECTORF32 = (
        (f: (1.0000000, 0.9607844, 0.8078432, 0)),
        (f: (0.0000000, 0.0000000, 0.0000000, 0)),
        (f: (0.3231373, 0.3607844, 0.3937255, 0))
        );

    defaultAmbient: TXMVECTORF32 = (f: (0.05333332, 0.09882354, 0.1819608, 0));
begin

    effect.SetAmbientLightColor(defaultAmbient);

    for i := 0 to MaxDirectionalLights - 1 do
    begin
        effect.SetLightEnabled(i, True);
        effect.SetLightDirection(i, defaultDirections[i]);
        effect.SetLightDiffuseColor(i, defaultDiffuse[i]);
        effect.SetLightSpecularColor(i, defaultSpecular[i]);
    end;
end;




// Constructor initializes default light settings.
class operator TEffectLights.Initialize(var A: TEffectLights);
var
    i: integer;
begin
    for i := 0 to MaxDirectionalLights - 1 do
    begin
        a.lightEnabled[i]      := (i = 0);
        a.lightDiffuseColor[i] := g_XMOne;
    end;
end;

{ TEffectColor }

// Lazily recomputes the material color parameter for shaders that do not support realtime lighting.
procedure TEffectColor.SetConstants(var dirtyFlags: int32; var diffuseColorConstant: TXMVECTOR);
var
    alphaVector: TXMVECTOR;
begin
    if ((dirtyFlags and Ord(TEffectDirtyFlags.MaterialColor)) <> 0) then
    begin
        alphaVector := XMVectorReplicate(alpha);

        // xyz := diffuse * alpha, w := alpha.
        diffuseColorConstant := XMVectorSelect(alphaVector, XMVectorMultiply(diffuseColor, alphaVector), g_XMSelect1110);

        dirtyFlags := dirtyFlags and not Ord(TEffectDirtyFlags.MaterialColor);
        dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.ConstantBuffer);
    end;
end;

// Constructor initializes default material color settings.

class operator TEffectColor.Initialize(var A: TEffectColor);
begin
    a.diffuseColor := g_XMOne;
    a.alpha := 1.0;
end;

{ TEffectFog }

// Lazily recomputes the derived vector used by shader fog calculations.
procedure TEffectFog.SetConstants(var dirtyFlags: int32; worldView: TFXMMATRIX; var fogVectorConstant: TXMVECTOR);
const
    fullyFogged: TXMVECTORF32 = (f: (0, 0, 0, 1));
var
    worldViewZ: TXMVECTOR;
    wOffset:    TXMVECTOR;
begin
    if (Enabled) then
    begin
        if ((dirtyFlags and (Ord(TEffectDirtyFlags.FogVector) or Ord(TEffectDirtyFlags.FogEnable))) <> 0) then
        begin
            if (startfog = endfog) then
            begin
                // Degenerate case: force everything to 100% fogged if start and end are the same.

                fogVectorConstant := fullyFogged;
            end
            else
            begin
                // We want to transform vertex positions into view space, take the resulting
                // Z value, then scale and offset according to the fog start/end distances.
                // Because we only care about the Z component, the shader can do all this
                // with a single dot product, using only the Z row of the world+view matrix.

                // _13, _23, _33, _43
                worldViewZ := XMVectorMergeXY(XMVectorMergeZW(worldView.r[0], worldView.r[2]), XMVectorMergeZW(worldView.r[1], worldView.r[3]));

                // 0, 0, 0, fogStart
                wOffset := XMVectorSwizzle(1, 2, 3, 0, XMLoadFloat(@startfog));

                // (worldViewZ + wOffset) / (start - end);
                fogVectorConstant := XMVectorDivide(XMVectorAdd(worldViewZ, wOffset), XMVectorReplicate(startfog - endfog));
            end;

            dirtyFlags := dirtyFlags and not (Ord(TEffectDirtyFlags.FogVector) or Ord(TEffectDirtyFlags.FogEnable));
            dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.ConstantBuffer);
        end;
    end
    else
    begin
        // When fog is disabled, make sure the fog vector is reset to zero.
        if ((dirtyFlags and Ord(TEffectDirtyFlags.FogEnable)) <> 0) then
        begin
            fogVectorConstant := g_XMZero;

            dirtyFlags := dirtyFlags and not Ord(TEffectDirtyFlags.FogEnable);
            dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.ConstantBuffer);
        end;
    end;
end;


// Constructor initializes default fog settings.
class operator TEffectFog.Initialize(var A: TEffectFog);
begin
    a.Enabled  := False;
    a.startfog := 0;
    a.endfog   := 1.0;
end;

{ TEffectMatrices }

// Lazily recomputes the combined world+view+projection matrix.
procedure TEffectMatrices.SetConstants(var dirtyFlags: int32; var worldViewProjConstant: TXMMATRIX);
begin
    if ((dirtyFlags and Ord(TEffectDirtyFlags.WorldViewProj)) <> 0) then
    begin
        worldView := XMMatrixMultiply(world, view);

        worldViewProjConstant := XMMatrixTranspose(XMMatrixMultiply(worldView, projection));

        dirtyFlags := dirtyFlags and not Ord(TEffectDirtyFlags.WorldViewProj);
        dirtyFlags := dirtyFlags or Ord(TEffectDirtyFlags.ConstantBuffer);
    end;
end;

// Constructor initializes default matrix values.

class operator TEffectMatrices.Initialize(var A: TEffectMatrices);
var
    id: TXMMATRIX;
begin
    id      := XMMatrixIdentity();
    a.world := id;
    a.view  := id;
    a.projection := id;
    a.worldView := id;
end;



{ TEffectBase }

// Constructor.
constructor TEffectBase<TT, TC>.Create(device: ID3D12Device);
begin
    dirtyFlags     := INT_MAX;
    mRootSignature := nil;

    if (device = nil) then
        raise Exception.Create('Direct3D device is null');

    constants := TT.Create;

    SetLength(VertexShaderBytecode, constants.VertexShaderCount);
    SetLength(VertexShaderIndices, constants.ShaderPermutationCount);
    SetLength(PixelShaderBytecode, constants.PixelShaderCount);
    SetLength(PixelShaderIndices, constants.ShaderPermutationCount);
    SetLength(VertexShaderInputLayouts, constants.ShaderPermutationCount);



    //mDeviceResources := deviceResourcesPool.DemandCreate(device);

    // Initialize the constant buffer data
    mConstantBuffer := GraphicsMemory.Get(device).AllocateConstant<TC>(constants.ConstantBufferType);
end;

// Commits constants to the constant buffer memory

procedure TEffectBase<TT, TC>.UpdateConstants();
begin
    // Make sure the constant buffer is up to date.
    if ((dirtyFlags and Ord(TEffectDirtyFlags.ConstantBuffer)) <> 0) then
    begin
        mConstantBuffer := GraphicsMemory.Get(mDeviceResources.Value.GetDevice()).AllocateConstant<TT>(constants);

        dirtyFlags := dirtyFlags and not Ord(TEffectDirtyFlags.ConstantBuffer);
    end;
end;



function TEffectBase<TT, TC>.GetConstantBufferGpuAddress(): TD3D12_GPU_VIRTUAL_ADDRESS;
begin
    Result := mConstantBuffer.GpuAddress();
end;



function TEffectBase<TT, TC>.GetRootSignature(slot: int32; rootSig: PD3D12_ROOT_SIGNATURE_DESC): ID3D12RootSignature;
begin
    Result := mDeviceResources.Value.GetRootSignature(slot, rootSig);
end;



function TEffectBase<TT, TC>.GetDevice(): ID3D12Device;
begin
    Result := mDeviceResources.Value.GetDevice();
end;




end.
