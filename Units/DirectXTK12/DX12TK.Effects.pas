unit DX12TK.Effects;

{$IFDEF FPC}
{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}


interface

uses
    Windows, Classes, SysUtils,
    CStdMap,
    CStdVector,
    CStdSharedPtr,
    DX12.D3D12,
    DirectX.Math,
    DX12TK.GraphicsMemory,
    DX12TK.SharedResourcePool,
    DX12TK.ResourceUploadBatch,
    DX12TK.DescriptorHeap,
    DX12TK.RenderTargetState,
    DX12TK.EffectPipelineStateDescription;

const


    MaxDirectionalLights = 3;
    MaxBones = 72;

    INT_MAX = 2147483647;

type
    TEffectFlags = (
        None = $00,
        Fog = $01,
        Lighting = $02,

        PerPixelLightingBit =$04,
        PerPixelLighting = $04 or ord(Lighting),
        // per pixel lighting implies lighting enabled

        VertexColor = $08,
        Texture = $10,
        Instancing = $20,

        Specular = $100,
        // enable optional specular/specularMap feature

        Emissive = $200,
        // enable optional emissive/emissiveMap feature

        Fresnel = $400,
        // enable optional Fresnel feature

        Velocity = $800,
        // enable optional velocity feature

        BiasedVertexNormals = $10000
        // compressed vertex normals need x2 bias
        );

    {$INTERFACES CORBA}
    //------------------------------------------------------------------------------
    // Abstract interface representing any effect which can be applied onto a D3D device context.

    { IEffect }

    IEffect = interface
        procedure Apply({_In_} commandList: ID3D12GraphicsCommandList);
    end;

    // Abstract interface for effects with world, view, and projection matrices.

    { IEffectMatrices }

    IEffectMatrices = interface
        procedure SetWorld(Value: TFXMMATRIX);
        procedure SetView(Value: TFXMMATRIX);
        procedure SetProjection(Value: TFXMMATRIX);
        procedure SetMatrices(world: TFXMMATRIX; view: TCXMMATRIX; projection: TCXMMATRIX);
    end;


    // Abstract interface for effects which support directional lighting.
    IEffectLights = interface
        procedure SetAmbientLightColor(Value: TFXMVECTOR);
        procedure SetLightEnabled(whichLight: int32; Value: winbool);
        procedure SetLightDirection(whichLight: int32; Value: TFXMVECTOR);
        procedure SetLightDiffuseColor(whichLight: int32; Value: TFXMVECTOR);
        procedure SetLightSpecularColor(whichLight: int32; Value: TFXMVECTOR);
        procedure EnableDefaultLighting();
    end;



    // Abstract interface for effects which support fog.
    IEffectFog = interface
        procedure SetFogStart(Value: single);
        procedure SetFogEnd(Value: single);
        procedure SetFogColor(Value: TFXMVECTOR);
    end;

    // Abstract interface for effects which support skinning
    IEffectSkinning = interface
        procedure SetBoneTransforms(
        {_In_reads_(count) } Value: PXMMATRIX; Count: size_t);
        procedure ResetBoneTransforms();
    end;

    //------------------------------------------------------------------------------
    // Built-in shader supports optional texture mapping, vertex coloring, directional lighting, and fog.

    { TBasicEffect }

    TBasicEffect = class(TObject, IEffect, IEffectMatrices, IEffectLights, IEffectFog)
    public
        constructor Create({_In_ } device: ID3D12Device; effectFlags: uint32; pipelineDescription: TEffectPipelineStateDescription);
        destructor Destroy; override;
        // IEffect methods.
        procedure Apply({_In_} commandList: ID3D12GraphicsCommandList);

        // Camera settings.
        procedure SetWorld(Value: TFXMMATRIX);
        procedure SetView(Value: TFXMMATRIX);
        procedure SetProjection(Value: TFXMMATRIX);
        procedure SetMatrices(world: TFXMMATRIX; view: TCXMMATRIX; projection: TCXMMATRIX);

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

        // Material settings.
        procedure SetDiffuseColor(Value: TFXMVECTOR);
        procedure SetEmissiveColor(Value: TFXMVECTOR);
        procedure SetSpecularColor(Value: TFXMVECTOR);
        procedure SetSpecularPower(Value: single);
        procedure DisableSpecular();
        procedure SetAlpha(Value: single);
        procedure SetColorAndAlpha(Value: TFXMVECTOR);

        // Texture setting.
        procedure SetTexture(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE; samplerDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);
    end;


    // Built-in shader supports per-pixel alpha testing.



    // Built-in shader supports two layer multitexturing (eg. for lightmaps or detail textures).

    { TDualTextureEffect }

    TDualTextureEffect = class(TObject, IEffect, IEffectMatrices, IEffectFog)
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
        procedure SetAlpha(Value: single);
        procedure SetColorAndAlpha(Value: TFXMVECTOR);

        // Fog settings.
        procedure SetFogStart(Value: single);
        procedure SetFogEnd(Value: single);
        procedure SetFogColor(Value: TFXMVECTOR);

        // Texture settings.
        procedure SetTexture(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE; samplerDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);
        procedure SetTexture2(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE; samplerDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);
    end;


    // Built-in shader supports cubic environment mapping.

    TMapping = (
        Mapping_Cube = 0,   // Cubic environment map
        Mapping_Sphere,     // Spherical environment map
        Mapping_DualParabola// Dual-parabola environment map (requires Feature Level 10.0)
        );

    PMapping = ^TMapping;


    { TEnvironmentMapEffect }

    TEnvironmentMapEffect = class(TObject, IEffect, IEffectMatrices, IEffectLights, IEffectFog)
    private
        // Unsupported interface methods.
        procedure SetLightSpecularColor(whichLight: int32; Value: TFXMVECTOR);
    public
        constructor Create(
        {_In_ } device: ID3D12Device; effectFlags: uint32; pipelineDescription: TEffectPipelineStateDescription; mapping: TMapping = Mapping_Cube);
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
        procedure SetAlpha(Value: single);
        procedure SetColorAndAlpha(Value: TFXMVECTOR);

        // Light settings.
        procedure SetAmbientLightColor(Value: TFXMVECTOR);
        procedure SetLightEnabled(whichLight: int32; Value: winbool);
        procedure SetLightDirection(whichLight: int32; Value: TFXMVECTOR);
        procedure SetLightDiffuseColor(whichLight: int32; Value: TFXMVECTOR);
        procedure EnableDefaultLighting();

        // Fog settings.
        procedure SetFogStart(Value: single);
        procedure SetFogEnd(Value: single);
        procedure SetFogColor(Value: TFXMVECTOR);

        // Texture settings.
        procedure SetTexture(texture: TD3D12_GPU_DESCRIPTOR_HANDLE; sampler: TD3D12_GPU_DESCRIPTOR_HANDLE);

        // Environment map settings.
        procedure SetEnvironmentMap(texture: TD3D12_GPU_DESCRIPTOR_HANDLE; sampler: TD3D12_GPU_DESCRIPTOR_HANDLE);
        procedure SetEnvironmentMapAmount(Value: single);
        procedure SetEnvironmentMapSpecular(Value: TFXMVECTOR);
        procedure SetFresnelFactor(Value: single);
    end;



    //------------------------------------------------------------------------------
    // Built-in shader extends BasicEffect with normal map and optional specular map

    { TNormalMapEffect }

    TNormalMapEffect = class(TObject, IEffect, IEffectMatrices, IEffectLights, IEffectFog)
    protected
        procedure NormalMapEffect(
        {_In_}  device: ID3D12Device; effectFlags: uint32; const pipelineDescription: PEffectPipelineStateDescription; skinningEnabled: boolean);
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

        // Texture setting - albedo, normal and specular intensity
        procedure SetTexture(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE; samplerDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);
        procedure SetNormalTexture(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);
        procedure SetSpecularTexture(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);


    end;

    { TSkinnedNormalMapEffect }

    TSkinnedNormalMapEffect = class(TObject, IEffectSkinning)
    public
        constructor Create(
        {_In_ } device: ID3D12Device; effectFlags: uint32; pipelineDescription: TEffectPipelineStateDescription);
        destructor Destroy; override;

        // Animation settings.
        procedure SetBoneTransforms({_In_reads_(count) } Value: PXMMATRIX; Count: size_t);
        procedure ResetBoneTransforms();
    end;

    //------------------------------------------------------------------------------
    // Built-in shader for Physically-Based Rendering (Roughness/Metalness) with Image-based lighting

    { TPBREffect }

    TPBREffect = class(TObject, IEffect, IEffectMatrices, IEffectLights)
    protected
        procedure PBREffect(
        {_In_}  device: ID3D12Device; effectFlags: uint32; const pipelineDescription: PEffectPipelineStateDescription; skinningEnabled: boolean);
        // Unsupported interface methods.
        procedure SetAmbientLightColor(Value: TFXMVECTOR);
        procedure SetLightSpecularColor(whichLight: int32; Value: TFXMVECTOR);
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

        // Light settings.
        procedure SetLightEnabled(whichLight: int32; Value: winbool);
        procedure SetLightDirection(whichLight: int32; Value: TFXMVECTOR);
        procedure SetLightDiffuseColor(whichLight: int32; Value: TFXMVECTOR);
        procedure EnableDefaultLighting();

        // PBR Settings.
        procedure SetAlpha(Value: single);
        procedure SetConstantAlbedo(Value: TFXMVECTOR);
        procedure SetConstantMetallic(Value: single);
        procedure SetConstantRoughness(Value: single);

        // Texture setting.
        procedure SetAlbedoTexture(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE; samplerDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);
        procedure SetNormalTexture(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);
        procedure SetRMATexture(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);

        procedure SetEmissiveTexture(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);
        procedure SetSurfaceTextures(albedo, normal, roughnessMetallicAmbientOcclusionsampler: TD3D12_GPU_DESCRIPTOR_HANDLE);
        procedure SetIBLTextures(radiance: TD3D12_GPU_DESCRIPTOR_HANDLE; numRadianceMips: longint; irradiance: TD3D12_GPU_DESCRIPTOR_HANDLE; sampler: TD3D12_GPU_DESCRIPTOR_HANDLE);
        // Render target size, required for velocity buffer output.
        procedure SetRenderTargetSizeInPixels(Width, Height: int32);
    end;

    { TSkinnedPBREffect }

    TSkinnedPBREffect = class(TPBREffect, IEffectSkinning)
    public
        constructor Create(
        {_In_ } device: ID3D12Device; effectFlags: uint32; pipelineDescription: TEffectPipelineStateDescription);
        destructor Destroy; override;

        // Animation settings.
        procedure SetBoneTransforms({_In_reads_(count) } Value: PXMMATRIX; Count: size_t);
        procedure ResetBoneTransforms();
    end;


    TDebugEffectMode = (
        Mode_Default = 0, // Hemispherical ambient lighting
        Mode_Normals,     // RGB normals
        Mode_Tangents,    // RGB tangents
        Mode_BiTangents   // RGB bi-tangents
        );

    PDebugEffectMode = ^TDebugEffectMode;


    //------------------------------------------------------------------------------
    // Built-in shader for debug visualization of normals, tangents, etc.

    { TDebugEffect }

    TDebugEffect = class(TObject, IEffect, IEffectMatrices)
    public
        constructor Create(
        {_In_ } device: ID3D12Device; effectFlags: uint32; pipelineDescription: TEffectPipelineStateDescription; debugMode: TDebugEffectMode = Mode_Default);
        destructor Destroy; override;

        // IEffect methods.
        procedure Apply({_In_} commandList: ID3D12GraphicsCommandList);

        // Camera settings.
        procedure SetWorld(Value: TFXMMATRIX);
        procedure SetView(Value: TFXMMATRIX);
        procedure SetProjection(Value: TFXMMATRIX);
        procedure SetMatrices(world: TFXMMATRIX; view: TCXMMATRIX; projection: TCXMMATRIX);

        // Debug Settings.
        procedure SetHemisphericalAmbientColor(upper, lower: TFXMVECTOR);
        procedure SetAlpha(Value: single);
    end;


    //------------------------------------------------------------------------------
    // Abstract interface to factory texture resources
    IEffectTextureFactory = interface
        function CreateTexture({_In_z_} const Name: widestring; descriptorIndex: int32): size_t;
    end;

    // Factory for sharing texture resources

    { TTextureCacheEntry }

    TTextureCacheEntry = record
        mResource: ID3D12Resource;
        mIsCubeMap: boolean;
        slot: size_t;
        class operator Initialize(var aVar: TTextureCacheEntry);
    end;
    PTextureCacheEntry = ^TTextureCacheEntry;

    TTextureCache = specialize TCStdMap<widestring, TTextureCacheEntry>;


    { TEffectTextureFactory }

    TEffectTextureFactory = class(TObject, IEffectTextureFactory)
    protected
        mDevice: ID3D12Device;
        mResourceUploadBatch: TResourceUploadBatch;
        mTextureCache: TTextureCache;
        mSharing: boolean;
        mForceSRGB: boolean;
        mAutoGenMips: boolean;
        mPath: widestring;
        mTextureDescriptorHeap: TDescriptorHeap;
        mResources: specialize TCStdVector<TTextureCacheEntry>; // flat list of unique resources so we can index into it
    public
        constructor Create(
        {_In_}  device: ID3D12Device; resourceUploadBatch: TResourceUploadBatch;
        {_In_}  descriptorHeap: ID3D12DescriptorHeap);
        constructor Create(
        {_In_}  device: ID3D12Device; resourceUploadBatch: TResourceUploadBatch;
        {_In_}  numDescriptors: size_t;
        {_In_}  descriptorHeapFlags: TD3D12_DESCRIPTOR_HEAP_FLAGS = D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE);
        destructor Destroy; override;

        function CreateTexture({_In_z_} const Name: widestring; descriptorIndex: int32): size_t;

        function Heap(): ID3D12DescriptorHeap;

        // Shorthand accessors for the descriptor heap
        function GetCpuDescriptorHandle(index: size_t): TD3D12_CPU_DESCRIPTOR_HANDLE;
        function GetGpuDescriptorHandle(index: size_t): TD3D12_GPU_DESCRIPTOR_HANDLE;

        // How many textures are there in this factory?
        function ResourceCount(): size_t;

        // Get a resource in a specific slot (note: increases reference count on resource)
        procedure GetResource(slot: size_t; {_Out_} out resource: ID3D12Resource; {_Out_opt_} isCubeMap: Pboolean = nil);

        // Settings.
        procedure ReleaseCache();

        procedure SetSharing(Enabled: boolean);

        procedure EnableForceSRGB(forceSRGB: boolean);
        procedure EnableAutoGenMips(generateMips: boolean);

        procedure SetDirectory({_In_opt_z_} const path: widestring);
    end;

    { TEffectInfo }

    TEffectInfo = record
        Name: widestring;
        perVertexColor: winbool;
        enableSkinning: winbool;
        enableDualTexture: winbool;
        enableNormalMaps: winbool;
        biasedVertexNormals: winbool;
        specularPower: single;
        alphaValue: single;
        ambientColor: TXMFLOAT3;
        diffuseColor: TXMFLOAT3;
        specularColor: TXMFLOAT3;
        emissiveColor: TXMFLOAT3;
        diffuseTextureIndex: int32;
        specularTextureIndex: int32;
        normalTextureIndex: int32;
        emissiveTextureIndex: int32;
        samplerIndex: int32;
        samplerIndex2: int32;
        class operator Initialize(var a: TEffectInfo);
    end;
    PEffectInfo = ^TEffectInfo;

    //------------------------------------------------------------------------------
    // Abstract interface to factory for sharing effects
    IEffectFactory = interface
        procedure CreateEffect(const info: PEffectInfo; const opaquePipelineState: PEffectPipelineStateDescription; const alphaPipelineState: PEffectPipelineStateDescription;
            const inputLayout: PD3D12_INPUT_LAYOUT_DESC; textureDescriptorOffset: int32 = 0; samplerDescriptorOffset: int32 = 0);
    end;

    // Factory for sharing effects

    { TEffectFactory }

    TEffectFactory = class(TObject, IEffectFactory)
    public
        constructor Create({_In_}  device: ID3D12Device);
        constructor Create({_In_}  textureDescriptors: ID3D12DescriptorHeap;
        {_In_}  samplerDescriptors: ID3D12DescriptorHeap);
        destructor Destroy; override;
        // IEffectFactory methods.
        procedure CreateEffect(const info: PEffectInfo; const opaquePipelineState: PEffectPipelineStateDescription; const alphaPipelineState: PEffectPipelineStateDescription;
            const inputLayout: PD3D12_INPUT_LAYOUT_DESC; textureDescriptorOffset: int32 = 0; samplerDescriptorOffset: int32 = 0);

        // Settings.
        procedure ReleaseCache(); cdecl;
        procedure SetSharing(Enabled: boolean); cdecl;
        procedure EnableLighting(Enabled: boolean); cdecl;
        procedure EnablePerPixelLighting(Enabled: boolean); cdecl;
        procedure EnableNormalMapEffect(Enabled: boolean); cdecl;
        procedure EnableFogging(Enabled: boolean); cdecl;
        procedure EnableInstancing(Enabled: boolean); cdecl;

    end;

    // Factory for Physically Based Rendering (PBR)

    { TPBREffectFactory }

    TPBREffectFactory = class(TObject, IEffectFactory)
    public
        constructor Create({_In_}  device: ID3D12Device);
        constructor Create({_In_}  textureDescriptors: ID3D12DescriptorHeap; {_In_} samplerDescriptors: ID3D12DescriptorHeap);
        destructor Destroy; override;
        // IEffectFactory methods.
        procedure CreateEffect(const info: PEffectInfo; const opaquePipelineState: PEffectPipelineStateDescription; const alphaPipelineState: PEffectPipelineStateDescription;
            const inputLayout: PD3D12_INPUT_LAYOUT_DESC; textureDescriptorOffset: int32 = 0; samplerDescriptorOffset: int32 = 0);

        // Settings.
        procedure ReleaseCache(); cdecl;
        procedure SetSharing(Enabled: boolean); cdecl;
        procedure EnableInstancing(Enabled: boolean); cdecl;
    end;



    // BasicEffect, SkinnedEffect, et al, have many things in common, but also significant
    // differences (for instance, not all the effects support lighting). This header breaks
    // out common functionality into a set of helpers which can be assembled in different
    // combinations to build up whatever subset is needed by each effect.



    // Only one of these helpers is allocated per D3D device, even if there are multiple effect instances.
    {$IFDEF Test}

    generic TTraits<T> = class
        ConstantBufferType:T;
        class function RootSignatureCount: int32; virtual; abstract;
    end;

    { TDeviceResources }


    type




    {$ENDIF}

    {$INTERFACES COM}

implementation

uses
    Win32.FileAPI,
    Win32.MinWinBase,
    DX12TK.WICTextureLoader,
    DX12TK.DDSTextureLoader,
    DX12TK.PlatformHelpers,
    DX12TK.DirectXHelpers;




    { TDeviceResources }
{$IFDEF Test}

{$ENDIF}




    { TBasicEffect }

constructor TBasicEffect.Create(device: ID3D12Device; effectFlags: uint32; pipelineDescription: TEffectPipelineStateDescription);
begin

end;



destructor TBasicEffect.Destroy;
begin
    inherited Destroy;
end;



procedure TBasicEffect.Apply(commandList: ID3D12GraphicsCommandList);
begin

end;



procedure TBasicEffect.SetWorld(Value: TFXMMATRIX);
begin

end;



procedure TBasicEffect.SetView(Value: TFXMMATRIX);
begin

end;



procedure TBasicEffect.SetProjection(Value: TFXMMATRIX);
begin

end;



procedure TBasicEffect.SetMatrices(world: TFXMMATRIX; view: TCXMMATRIX; projection: TCXMMATRIX);
begin

end;



procedure TBasicEffect.SetAmbientLightColor(Value: TFXMVECTOR);
begin

end;



procedure TBasicEffect.SetLightEnabled(whichLight: int32; Value: winbool);
begin

end;



procedure TBasicEffect.SetLightDirection(whichLight: int32; Value: TFXMVECTOR);
begin

end;



procedure TBasicEffect.SetLightDiffuseColor(whichLight: int32; Value: TFXMVECTOR);
begin

end;



procedure TBasicEffect.SetLightSpecularColor(whichLight: int32; Value: TFXMVECTOR);
begin

end;



procedure TBasicEffect.EnableDefaultLighting();
begin

end;



procedure TBasicEffect.SetFogStart(Value: single);
begin

end;



procedure TBasicEffect.SetFogEnd(Value: single);
begin

end;



procedure TBasicEffect.SetFogColor(Value: TFXMVECTOR);
begin

end;



procedure TBasicEffect.SetDiffuseColor(Value: TFXMVECTOR);
begin

end;



procedure TBasicEffect.SetEmissiveColor(Value: TFXMVECTOR);
begin

end;



procedure TBasicEffect.SetSpecularColor(Value: TFXMVECTOR);
begin

end;



procedure TBasicEffect.SetSpecularPower(Value: single);
begin

end;



procedure TBasicEffect.DisableSpecular();
begin

end;



procedure TBasicEffect.SetAlpha(Value: single);
begin

end;



procedure TBasicEffect.SetColorAndAlpha(Value: TFXMVECTOR);
begin

end;



procedure TBasicEffect.SetTexture(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE; samplerDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);
begin

end;


{ TDualTextureEffect }

constructor TDualTextureEffect.Create(device: ID3D12Device; effectFlags: uint32; pipelineDescription: TEffectPipelineStateDescription);
begin

end;



destructor TDualTextureEffect.Destroy;
begin
    inherited Destroy;
end;



procedure TDualTextureEffect.Apply(commandList: ID3D12GraphicsCommandList);
begin

end;



procedure TDualTextureEffect.SetWorld(Value: TFXMMATRIX);
begin

end;



procedure TDualTextureEffect.SetView(Value: TFXMMATRIX);
begin

end;



procedure TDualTextureEffect.SetProjection(Value: TFXMMATRIX);
begin

end;



procedure TDualTextureEffect.SetMatrices(world: TFXMMATRIX; view: TCXMMATRIX; projection: TCXMMATRIX);
begin

end;



procedure TDualTextureEffect.SetDiffuseColor(Value: TFXMVECTOR);
begin

end;



procedure TDualTextureEffect.SetAlpha(Value: single);
begin

end;



procedure TDualTextureEffect.SetColorAndAlpha(Value: TFXMVECTOR);
begin

end;



procedure TDualTextureEffect.SetFogStart(Value: single);
begin

end;



procedure TDualTextureEffect.SetFogEnd(Value: single);
begin

end;



procedure TDualTextureEffect.SetFogColor(Value: TFXMVECTOR);
begin

end;



procedure TDualTextureEffect.SetTexture(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE; samplerDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);
begin

end;



procedure TDualTextureEffect.SetTexture2(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE; samplerDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);
begin

end;

{ TEnvironmentMapEffect }

procedure TEnvironmentMapEffect.SetLightSpecularColor(whichLight: int32; Value: TFXMVECTOR);
begin

end;



constructor TEnvironmentMapEffect.Create(device: ID3D12Device; effectFlags: uint32; pipelineDescription: TEffectPipelineStateDescription; mapping: TMapping);
begin

end;



destructor TEnvironmentMapEffect.Destroy;
begin
    inherited Destroy;
end;



procedure TEnvironmentMapEffect.Apply(commandList: ID3D12GraphicsCommandList);
begin

end;



procedure TEnvironmentMapEffect.SetWorld(Value: TFXMMATRIX);
begin

end;



procedure TEnvironmentMapEffect.SetView(Value: TFXMMATRIX);
begin

end;



procedure TEnvironmentMapEffect.SetProjection(Value: TFXMMATRIX);
begin

end;



procedure TEnvironmentMapEffect.SetMatrices(world: TFXMMATRIX; view: TCXMMATRIX; projection: TCXMMATRIX);
begin

end;



procedure TEnvironmentMapEffect.SetDiffuseColor(Value: TFXMVECTOR);
begin

end;



procedure TEnvironmentMapEffect.SetEmissiveColor(Value: TFXMVECTOR);
begin

end;



procedure TEnvironmentMapEffect.SetAlpha(Value: single);
begin

end;



procedure TEnvironmentMapEffect.SetColorAndAlpha(Value: TFXMVECTOR);
begin

end;



procedure TEnvironmentMapEffect.SetAmbientLightColor(Value: TFXMVECTOR);
begin

end;



procedure TEnvironmentMapEffect.SetLightEnabled(whichLight: int32; Value: winbool);
begin

end;



procedure TEnvironmentMapEffect.SetLightDirection(whichLight: int32; Value: TFXMVECTOR);
begin

end;



procedure TEnvironmentMapEffect.SetLightDiffuseColor(whichLight: int32; Value: TFXMVECTOR);
begin

end;



procedure TEnvironmentMapEffect.EnableDefaultLighting();
begin

end;



procedure TEnvironmentMapEffect.SetFogStart(Value: single);
begin

end;



procedure TEnvironmentMapEffect.SetFogEnd(Value: single);
begin

end;



procedure TEnvironmentMapEffect.SetFogColor(Value: TFXMVECTOR);
begin

end;



procedure TEnvironmentMapEffect.SetTexture(texture: TD3D12_GPU_DESCRIPTOR_HANDLE; sampler: TD3D12_GPU_DESCRIPTOR_HANDLE);
begin

end;



procedure TEnvironmentMapEffect.SetEnvironmentMap(texture: TD3D12_GPU_DESCRIPTOR_HANDLE; sampler: TD3D12_GPU_DESCRIPTOR_HANDLE);
begin

end;



procedure TEnvironmentMapEffect.SetEnvironmentMapAmount(Value: single);
begin

end;



procedure TEnvironmentMapEffect.SetEnvironmentMapSpecular(Value: TFXMVECTOR);
begin

end;



procedure TEnvironmentMapEffect.SetFresnelFactor(Value: single);
begin

end;

{ TNormalMapEffect }

procedure TNormalMapEffect.NormalMapEffect(device: ID3D12Device; effectFlags: uint32; const pipelineDescription: PEffectPipelineStateDescription; skinningEnabled: boolean);
begin

end;



constructor TNormalMapEffect.Create(device: ID3D12Device; effectFlags: uint32; pipelineDescription: TEffectPipelineStateDescription);
begin
    NormalMapEffect(device, effectFlags, @pipelineDescription, False);
end;



destructor TNormalMapEffect.Destroy;
begin
    inherited Destroy;
end;



procedure TNormalMapEffect.Apply(commandList: ID3D12GraphicsCommandList);
begin

end;



procedure TNormalMapEffect.SetWorld(Value: TFXMMATRIX);
begin

end;



procedure TNormalMapEffect.SetView(Value: TFXMMATRIX);
begin

end;



procedure TNormalMapEffect.SetProjection(Value: TFXMMATRIX);
begin

end;



procedure TNormalMapEffect.SetMatrices(world: TFXMMATRIX; view: TCXMMATRIX; projection: TCXMMATRIX);
begin

end;



procedure TNormalMapEffect.SetDiffuseColor(Value: TFXMVECTOR);
begin

end;



procedure TNormalMapEffect.SetEmissiveColor(Value: TFXMVECTOR);
begin

end;



procedure TNormalMapEffect.SetSpecularColor(Value: TFXMVECTOR);
begin

end;



procedure TNormalMapEffect.SetSpecularPower(Value: single);
begin

end;



procedure TNormalMapEffect.DisableSpecular();
begin

end;



procedure TNormalMapEffect.SetAlpha(Value: single);
begin

end;



procedure TNormalMapEffect.SetColorAndAlpha(Value: TFXMVECTOR);
begin

end;



procedure TNormalMapEffect.SetAmbientLightColor(Value: TFXMVECTOR);
begin

end;



procedure TNormalMapEffect.SetLightEnabled(whichLight: int32; Value: winbool);
begin

end;



procedure TNormalMapEffect.SetLightDirection(whichLight: int32; Value: TFXMVECTOR);
begin

end;



procedure TNormalMapEffect.SetLightDiffuseColor(whichLight: int32; Value: TFXMVECTOR);
begin

end;



procedure TNormalMapEffect.SetLightSpecularColor(whichLight: int32; Value: TFXMVECTOR);
begin

end;



procedure TNormalMapEffect.EnableDefaultLighting();
begin

end;



procedure TNormalMapEffect.SetFogStart(Value: single);
begin

end;



procedure TNormalMapEffect.SetFogEnd(Value: single);
begin

end;



procedure TNormalMapEffect.SetFogColor(Value: TFXMVECTOR);
begin

end;



procedure TNormalMapEffect.SetTexture(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE; samplerDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);
begin

end;



procedure TNormalMapEffect.SetNormalTexture(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);
begin

end;



procedure TNormalMapEffect.SetSpecularTexture(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);
begin

end;

{ TSkinnedNormalMapEffect }

constructor TSkinnedNormalMapEffect.Create(device: ID3D12Device; effectFlags: uint32; pipelineDescription: TEffectPipelineStateDescription);
begin
    //NormalMapEffect(device, effectFlags, pipelineDescription, true);
end;



destructor TSkinnedNormalMapEffect.Destroy;
begin
    inherited Destroy;
end;



procedure TSkinnedNormalMapEffect.SetBoneTransforms(Value: PXMMATRIX; Count: size_t);
begin

end;



procedure TSkinnedNormalMapEffect.ResetBoneTransforms();
begin

end;

{ TPBREffect }

procedure TPBREffect.PBREffect(device: ID3D12Device; effectFlags: uint32; const pipelineDescription: PEffectPipelineStateDescription; skinningEnabled: boolean);
begin

end;



procedure TPBREffect.SetAmbientLightColor(Value: TFXMVECTOR);
begin

end;



procedure TPBREffect.SetLightSpecularColor(whichLight: int32; Value: TFXMVECTOR);
begin

end;



constructor TPBREffect.Create(device: ID3D12Device; effectFlags: uint32; pipelineDescription: TEffectPipelineStateDescription);
begin
    //    PBREffect(device, effectFlags, pipelineDescription, false);
end;



destructor TPBREffect.Destroy;
begin
    inherited Destroy;
end;



procedure TPBREffect.Apply(commandList: ID3D12GraphicsCommandList);
begin

end;



procedure TPBREffect.SetWorld(Value: TFXMMATRIX);
begin

end;



procedure TPBREffect.SetView(Value: TFXMMATRIX);
begin

end;



procedure TPBREffect.SetProjection(Value: TFXMMATRIX);
begin

end;



procedure TPBREffect.SetMatrices(world: TFXMMATRIX; view: TCXMMATRIX; projection: TCXMMATRIX);
begin

end;



procedure TPBREffect.SetLightEnabled(whichLight: int32; Value: winbool);
begin

end;



procedure TPBREffect.SetLightDirection(whichLight: int32; Value: TFXMVECTOR);
begin

end;



procedure TPBREffect.SetLightDiffuseColor(whichLight: int32; Value: TFXMVECTOR);
begin

end;



procedure TPBREffect.EnableDefaultLighting();
begin

end;



procedure TPBREffect.SetAlpha(Value: single);
begin

end;



procedure TPBREffect.SetConstantAlbedo(Value: TFXMVECTOR);
begin

end;



procedure TPBREffect.SetConstantMetallic(Value: single);
begin

end;



procedure TPBREffect.SetConstantRoughness(Value: single);
begin

end;



procedure TPBREffect.SetAlbedoTexture(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE; samplerDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);
begin

end;



procedure TPBREffect.SetNormalTexture(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);
begin

end;



procedure TPBREffect.SetRMATexture(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);
begin

end;



procedure TPBREffect.SetEmissiveTexture(srvDescriptor: TD3D12_GPU_DESCRIPTOR_HANDLE);
begin

end;



procedure TPBREffect.SetSurfaceTextures(albedo, normal, roughnessMetallicAmbientOcclusionsampler: TD3D12_GPU_DESCRIPTOR_HANDLE);
begin

end;



procedure TPBREffect.SetIBLTextures(radiance: TD3D12_GPU_DESCRIPTOR_HANDLE; numRadianceMips: longint; irradiance: TD3D12_GPU_DESCRIPTOR_HANDLE; sampler: TD3D12_GPU_DESCRIPTOR_HANDLE);
begin

end;



procedure TPBREffect.SetRenderTargetSizeInPixels(Width, Height: int32);
begin

end;

{ TSkinnedPBREffect }

constructor TSkinnedPBREffect.Create(device: ID3D12Device; effectFlags: uint32; pipelineDescription: TEffectPipelineStateDescription);
begin
    PBREffect(device, effectFlags, @pipelineDescription, True);
end;



destructor TSkinnedPBREffect.Destroy;
begin
    inherited Destroy;
end;



procedure TSkinnedPBREffect.SetBoneTransforms(Value: PXMMATRIX; Count: size_t);
begin

end;



procedure TSkinnedPBREffect.ResetBoneTransforms();
begin

end;

{ TDebugEffect }

constructor TDebugEffect.Create(device: ID3D12Device; effectFlags: uint32; pipelineDescription: TEffectPipelineStateDescription; debugMode: TDebugEffectMode);
begin

end;



destructor TDebugEffect.Destroy;
begin
    inherited Destroy;
end;



procedure TDebugEffect.Apply(commandList: ID3D12GraphicsCommandList);
begin

end;



procedure TDebugEffect.SetWorld(Value: TFXMMATRIX);
begin

end;



procedure TDebugEffect.SetView(Value: TFXMMATRIX);
begin

end;



procedure TDebugEffect.SetProjection(Value: TFXMMATRIX);
begin

end;



procedure TDebugEffect.SetMatrices(world: TFXMMATRIX; view: TCXMMATRIX; projection: TCXMMATRIX);
begin

end;



procedure TDebugEffect.SetHemisphericalAmbientColor(upper, lower: TFXMVECTOR);
begin

end;



procedure TDebugEffect.SetAlpha(Value: single);
begin

end;

{ TTextureCacheEntry }

class operator TTextureCacheEntry.Initialize(var aVar: TTextureCacheEntry);
begin
    aVar.mIsCubeMap := False;
    aVar.slot      := 0;
    aVar.mResource := nil;
end;

{ TEffectTextureFactory }

constructor TEffectTextureFactory.Create(device: ID3D12Device; resourceUploadBatch: TResourceUploadBatch; descriptorHeap: ID3D12DescriptorHeap);
begin
    mTextureDescriptorHeap := TDescriptorHeap.Create(descriptorHeap);
    mDevice      := device;
    mResourceUploadBatch := resourceUploadBatch;
    mSharing     := True;
    mForceSRGB   := False;
    mAutoGenMips := False;

    if (device = nil) then
        raise Exception.Create('Direct3D device is null');

    mPath := '';
end;



constructor TEffectTextureFactory.Create(device: ID3D12Device; resourceUploadBatch: TResourceUploadBatch; numDescriptors: size_t; descriptorHeapFlags: TD3D12_DESCRIPTOR_HEAP_FLAGS);
begin
    mPath      := '';
    mTextureDescriptorHeap := TDescriptorHeap.Create(device, D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV, descriptorHeapFlags, numDescriptors);
    mDevice    := device;
    mResourceUploadBatch := resourceUploadBatch;
    mSharing   := True;
    mForceSRGB := False;
    mAutoGenMips := False;

    SetDebugObjectName(mTextureDescriptorHeap.Heap(), 'EffectTextureFactory');
end;



destructor TEffectTextureFactory.Destroy;
begin
    inherited Destroy;
end;



function TEffectTextureFactory.CreateTexture(const Name: widestring; descriptorIndex: int32): size_t;
var
    textureEntry: TTextureCacheEntry;
    fileAttr: TWIN32_FILE_ATTRIBUTE_DATA;
    loadFlags: TDDS_LOADER_FLAGS;
    hr:    HResult;
    isdds: boolean;
    fullname: widestring;
    ext:   widestring;
    it:    TTextureCache.TMapIterator;
    textureDescriptor: TD3D12_CPU_DESCRIPTOR_HANDLE;
begin
    if (Name = '') then
        raise Exception.Create('name required for CreateTexture');

    it := mTextureCache.find(Name);


    if (mSharing and (it <> mTextureCache._end())) then
    begin
        textureEntry := it.second;
    end
    else
    begin
        fullName := mPath + Name;


        if (not GetFileAttributesExW(pwidechar(fullName), Win32.MinWinBase.GetFileExInfoStandard, @fileAttr)) then
        begin
            // Try Current Working Directory (CWD)
            fullName := Name;
            if (not GetFileAttributesExW(pwidechar(fullName), GetFileExInfoStandard, @fileAttr)) then
            begin
                DebugTrace('ERROR: EffectTextureFactory could not find texture file ''%ls''\n', [Name]);
                raise Exception.Create('EffectTextureFactory::CreateTexture');
            end;
        end;


        ext := ExtractFileExt(Name);

        isdds := (ext = '.dds');

        loadFlags := DDS_LOADER_DEFAULT;
        if (mForceSRGB) then
            loadFlags := TDDS_LOADER_FLAGS(Ord(loadFlags) or Ord(DDS_LOADER_FORCE_SRGB));
        if (mAutoGenMips) then
            loadFlags := TDDS_LOADER_FLAGS(Ord(loadFlags) or Ord(DDS_LOADER_MIP_AUTOGEN));

        if (isdds) then
        begin
            hr := CreateDDSTextureFromFileEx(mDevice, mResourceUploadBatch, pwidechar(fullName), 0, D3D12_RESOURCE_FLAG_NONE, loadFlags, textureEntry.mResource, nil, @textureEntry.mIsCubeMap);
            if (FAILED(hr)) then
            begin
                DebugTrace('ERROR: CreateDDSTextureFromFile failed (%08X) for ''%ls''\n',
                    [hr, fullName]);
                raise Exception.Create('EffectTextureFactory::CreateDDSTextureFromFile');
            end;
        end
        else
        begin
            assert(Ord(DDS_LOADER_DEFAULT) = Ord(WIC_LOADER_DEFAULT), 'DDS/WIC Load flags mismatch');
            assert(Ord(DDS_LOADER_FORCE_SRGB) = Ord(WIC_LOADER_FORCE_SRGB), 'DDS/WIC Load flags mismatch');
            assert(Ord(DDS_LOADER_MIP_AUTOGEN) = Ord(WIC_LOADER_MIP_AUTOGEN), 'DDS/WIC Load flags mismatch');
            assert(Ord(DDS_LOADER_MIP_RESERVE) = Ord(WIC_LOADER_MIP_RESERVE), 'DDS/WIC Load flags mismatch');

            textureEntry.mIsCubeMap := False;

            hr := CreateWICTextureFromFileEx(mDevice, mResourceUploadBatch, pwidechar(fullName), 0, D3D12_RESOURCE_FLAG_NONE, TWIC_LOADER_FLAGS(loadFlags), textureEntry.mResource);
            if (FAILED(hr)) then
            begin
                DebugTrace('ERROR: CreateWICTextureFromFile failed (%08X) for ''%ls''\n',
                    [hr, fullName]);
                raise Exception.Create('EffectTextureFactory::CreateWICTextureFromFile');
            end;
        end;

        // ToDo std::lock_guard<std::mutex> lock(mutex);
        textureEntry.slot := mResources.size();
        if (mSharing) then
        begin
            // ToDo
{            TextureCache.value_type v(name, textureEntry);
            mTextureCache.insert(v); }
        end;
        mResources.push_back(textureEntry);
    end;

    assert(textureEntry.mResource <> nil);

    // bind a new descriptor in slot

    textureDescriptor := mTextureDescriptorHeap.GetCpuHandle((descriptorIndex));
    CreateShaderResourceView(mDevice, textureEntry.mResource, textureDescriptor, textureEntry.mIsCubeMap);

    Result := textureEntry.slot;
end;



function TEffectTextureFactory.Heap(): ID3D12DescriptorHeap;
begin
    Result := mTextureDescriptorHeap.Heap();
end;


// Shorthand accessors for the descriptor heap
function TEffectTextureFactory.GetCpuDescriptorHandle(index: size_t): TD3D12_CPU_DESCRIPTOR_HANDLE;
begin
    Result := mTextureDescriptorHeap.GetCpuHandle(index);
end;



function TEffectTextureFactory.GetGpuDescriptorHandle(index: size_t): TD3D12_GPU_DESCRIPTOR_HANDLE;
begin
    Result := mTextureDescriptorHeap.GetGpuHandle(index);
end;



function TEffectTextureFactory.ResourceCount(): size_t;
begin
    Result := mResources.size();
end;



procedure TEffectTextureFactory.GetResource(slot: size_t; out resource: ID3D12Resource; isCubeMap: Pboolean);
var
    textureEntry: TTextureCacheEntry;
begin
    if (slot >= mResources.size()) then
        raise Exception.Create('Resource slot is invalid');

    textureEntry := mResources.Item[slot];

    // ToDo ComPtr CopyTo
    // textureEntry.mResource.CopyTo(resource);

    if (isCubeMap <> nil) then
    begin
        isCubeMap^ := textureEntry.mIsCubeMap;
    end;
end;



procedure TEffectTextureFactory.ReleaseCache();
begin

end;



procedure TEffectTextureFactory.SetSharing(Enabled: boolean);
begin
    mSharing := Enabled;
end;



procedure TEffectTextureFactory.EnableForceSRGB(forceSRGB: boolean);
begin
    mForceSRGB := forceSRGB;
end;



procedure TEffectTextureFactory.EnableAutoGenMips(generateMips: boolean);
begin
    mAutoGenMips := generateMips;
end;



procedure TEffectTextureFactory.SetDirectory(const path: widestring);
begin
    // Ensure it has a trailing slash
    mPath := IncludeTrailingBackslash(path);
end;

{ TEffectInfo }

class operator TEffectInfo.Initialize(var a: TEffectInfo);
begin
    a.perVertexColor  := False;
    a.enableSkinning  := False;
    a.enableDualTexture := False;
    a.enableNormalMaps := False;
    a.biasedVertexNormals := False;
    a.specularPower   := 0;
    a.alphaValue      := 0;
    a.ambientColor.f  := [0, 0, 0];
    a.diffuseColor.f  := [0, 0, 0];
    a.specularColor.f := [0, 0, 0];
    a.emissiveColor.f := [0, 0, 0];
    a.diffuseTextureIndex := -1;
    a.specularTextureIndex := -1;
    a.normalTextureIndex := -1;
    a.emissiveTextureIndex := -1;
    a.samplerIndex    := -1;
    a.samplerIndex2   := -1;
end;

{ TEffectFactory }

constructor TEffectFactory.Create(device: ID3D12Device);
begin

end;



constructor TEffectFactory.Create(textureDescriptors: ID3D12DescriptorHeap; samplerDescriptors: ID3D12DescriptorHeap);
begin

end;



destructor TEffectFactory.Destroy;
begin
    inherited Destroy;
end;



procedure TEffectFactory.CreateEffect(const info: PEffectInfo; const opaquePipelineState: PEffectPipelineStateDescription; const alphaPipelineState: PEffectPipelineStateDescription;
    const inputLayout: PD3D12_INPUT_LAYOUT_DESC; textureDescriptorOffset: int32; samplerDescriptorOffset: int32);
begin

end;



procedure TEffectFactory.ReleaseCache(); cdecl;
begin

end;



procedure TEffectFactory.SetSharing(Enabled: boolean); cdecl;
begin

end;



procedure TEffectFactory.EnableLighting(Enabled: boolean); cdecl;
begin

end;



procedure TEffectFactory.EnablePerPixelLighting(Enabled: boolean); cdecl;
begin

end;



procedure TEffectFactory.EnableNormalMapEffect(Enabled: boolean); cdecl;
begin

end;



procedure TEffectFactory.EnableFogging(Enabled: boolean); cdecl;
begin

end;



procedure TEffectFactory.EnableInstancing(Enabled: boolean); cdecl;
begin

end;

{ TPBREffectFactory }

constructor TPBREffectFactory.Create(device: ID3D12Device);
begin

end;



constructor TPBREffectFactory.Create(textureDescriptors: ID3D12DescriptorHeap; samplerDescriptors: ID3D12DescriptorHeap);
begin

end;



destructor TPBREffectFactory.Destroy;
begin
    inherited Destroy;
end;



procedure TPBREffectFactory.CreateEffect(const info: PEffectInfo; const opaquePipelineState: PEffectPipelineStateDescription; const alphaPipelineState: PEffectPipelineStateDescription;
    const inputLayout: PD3D12_INPUT_LAYOUT_DESC; textureDescriptorOffset: int32; samplerDescriptorOffset: int32);
begin

end;



procedure TPBREffectFactory.ReleaseCache(); cdecl;
begin

end;



procedure TPBREffectFactory.SetSharing(Enabled: boolean); cdecl;
begin

end;



procedure TPBREffectFactory.EnableInstancing(Enabled: boolean); cdecl;
begin

end;



end.
