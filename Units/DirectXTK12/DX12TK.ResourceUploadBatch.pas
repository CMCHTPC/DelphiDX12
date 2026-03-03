//--------------------------------------------------------------------------------------
// File: ResourceUploadBatch.h

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------
unit DX12TK.ResourceUploadBatch;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DirectX.Math,
    CStdVector,
    CStdUniquePtr,
    DX12.D3D12,
    DX12TK.PlatformHelpers,
    DX12TK.GraphicsMemory,
    DX12.DXGIFormat;

type
    TUploadBatch = record
        TrackedObjects: specialize TCStdVector<PID3D12DeviceChild>;
        TrackedMemoryResources: specialize TCStdVector<TSharedGraphicsResource>;
        CommandList: PID3D12GraphicsCommandList;
        Fence: PID3D12Fence;
        GpuCompleteEvent: TScopedHandle;
    end;
    PUploadBatch = ^TUploadBatch;

    // Has a command list of it's own so it can upload at any time.

    TGenerateMipsResources = class;

    { TResourceUploadBatch }

    TResourceUploadBatch = class
    private
        mDevice: ID3D12Device;
        mCmdAlloc: ID3D12CommandAllocator;
        mList: ID3D12GraphicsCommandList;
        mCommandType: TD3D12_COMMAND_LIST_TYPE;
        mInBeginEndBlock: boolean;
        mTypedUAVLoadAdditionalFormats: boolean;
        mStandardSwizzle64KBSupported: boolean;
        mTrackedObjects: specialize TCStdVector<PID3D12DeviceChild>;
        mTrackedMemoryResources: specialize TCStdVector<TSharedGraphicsResource>;
        mGenMipsResources: TGenerateMipsResources;
    private
        // Resource is UAV compatible
        procedure GenerateMips_UnorderedAccessPath({_In_ } resource: ID3D12Resource);
        // Resource is not UAV compatible
        procedure GenerateMips_TexturePath({_In_ } resource: ID3D12Resource);
        // Resource is not UAV compatible (copy via alias to avoid validation failure)
        procedure GenerateMips_TexturePathBGR({_In_ } resource: ID3D12Resource);
    public
        constructor Create({_In_} device: ID3D12Device);
        // Call this before your multiple calls to Upload.
        procedure BeginUpload(commandType: TD3D12_COMMAND_LIST_TYPE= D3D12_COMMAND_LIST_TYPE_DIRECT);
        // Asynchronously uploads a resource. The memory in subRes is copied.
        // The resource must be in the COPY_DEST or COMMON state.
        procedure Upload({_In_ } resource: ID3D12Resource; subresourceIndexStart: uint32; {_In_reads_(numSubresources) } subRes: PD3D12_SUBRESOURCE_DATA; numSubresources: uint32);
        procedure Upload({_In_ } resource: ID3D12Resource; buffer: TSharedGraphicsResource);

        // Asynchronously generate mips from a resource.
        // Resource must be in the PIXEL_SHADER_RESOURCE state
        procedure GenerateMips({_In_ } resource: ID3D12Resource);

        // Transition a resource once you're done with it
        procedure Transition(
        {_In_ } resource: ID3D12Resource;
        {_In_ } stateBefore: TD3D12_RESOURCE_STATES;
        {_In_ } stateAfter: TD3D12_RESOURCE_STATES);

        // Submits all the uploads to the driver.
        // No more uploads can happen after this call until Begin is called again.
        // This returns a handle to an event that can be waited on.
        procedure EndUpload(
        {_In_ } commandQueue: ID3D12CommandQueue);
        // Validates if the given DXGI format is supported for autogen mipmaps
        function IsSupportedForGenerateMips(format: TDXGI_FORMAT): boolean;
    end;

    { TGenerateMipsResources }

    TGenerateMipsResources = class
    type
        TRootParameterIndex = (
            Constants,
            SourceTexture,
            TargetTexture,
            RootParameterCount);
        PRootParameterIndex = ^TRootParameterIndex;
        {$PACKRECORDS 4}
        TConstantData = record
            InvOutTexelSize: TXMFLOAT2;
            SrcMipIndex: uint32;
        end;
        PConstantData = ^TConstantData;

        {$PACKRECORDS DEFAULT}
    const
        ThreadGroupSize = 8;
        Num32BitConstants = (sizeof(TConstantData) div sizeof(uint32));








    private
        function CreateGenMipsRootSignature(
        {_In_}  device: ID3D12Device): ID3D12RootSignature;

        function CreateGenMipsPipelineState(
        {_In_ } device: ID3D12Device;
        {_In_ } rootSignature: ID3D12RootSignature;
        {_In_reads_(bytecodeSize) } bytecode: Puint8;
        {_In_ } bytecodeSize: size_t): ID3D12PipelineState;
    public
        rootSignature: ID3D12RootSignature;
        generateMipsPSO: ID3D12PipelineState;
        constructor Create({_In_}  device: ID3D12Device);
    end;

implementation

uses
    Win32.SynchAPI,
    DX12.D3DX12_Core,
    DX12.D3DCompiler,
    DX12.D3DCommon,
    DX12.D3DX12_Root_Signature,
    DX12.D3DX12_Resource_Helpers,
    DX12TK.DirectXHelpers;

    //--------------------------------------------------------------------------------------
    // File: ResourceUploadBatch.cpp

    // Copyright (c) Microsoft Corporation.
    // Licensed under the MIT License.

    // http://go.microsoft.com/fwlink/?LinkID=615561
    //--------------------------------------------------------------------------------------


function FormatIsUAVCompatible({_In_}  device: ID3D12Device; typedUAVLoadAdditionalFormats: boolean; format: TDXGI_FORMAT): boolean;
var
    mask: DWORD;
    formatSupport: TD3D12_FEATURE_DATA_FORMAT_SUPPORT;
begin
    case (format) of

        DXGI_FORMAT_R32_FLOAT,
        DXGI_FORMAT_R32_UINT,
        DXGI_FORMAT_R32_SINT:
            // Unconditionally supported.
            Result := True;

        DXGI_FORMAT_R32G32B32A32_FLOAT,
        DXGI_FORMAT_R32G32B32A32_UINT,
        DXGI_FORMAT_R32G32B32A32_SINT,
        DXGI_FORMAT_R16G16B16A16_FLOAT,
        DXGI_FORMAT_R16G16B16A16_UINT,
        DXGI_FORMAT_R16G16B16A16_SINT,
        DXGI_FORMAT_R8G8B8A8_UNORM,
        DXGI_FORMAT_R8G8B8A8_UINT,
        DXGI_FORMAT_R8G8B8A8_SINT,
        DXGI_FORMAT_R16_FLOAT,
        DXGI_FORMAT_R16_UINT,
        DXGI_FORMAT_R16_SINT,
        DXGI_FORMAT_R8_UNORM,
        DXGI_FORMAT_R8_UINT,
        DXGI_FORMAT_R8_SINT:
            // All these are supported if this optional feature is set.
            Result := typedUAVLoadAdditionalFormats;

        DXGI_FORMAT_R16G16B16A16_UNORM,
        DXGI_FORMAT_R16G16B16A16_SNORM,
        DXGI_FORMAT_R32G32_FLOAT,
        DXGI_FORMAT_R32G32_UINT,
        DXGI_FORMAT_R32G32_SINT,
        DXGI_FORMAT_R10G10B10A2_UNORM,
        DXGI_FORMAT_R10G10B10A2_UINT,
        DXGI_FORMAT_R11G11B10_FLOAT,
        DXGI_FORMAT_R8G8B8A8_SNORM,
        DXGI_FORMAT_R16G16_FLOAT,
        DXGI_FORMAT_R16G16_UNORM,
        DXGI_FORMAT_R16G16_UINT,
        DXGI_FORMAT_R16G16_SNORM,
        DXGI_FORMAT_R16G16_SINT,
        DXGI_FORMAT_R8G8_UNORM,
        DXGI_FORMAT_R8G8_UINT,
        DXGI_FORMAT_R8G8_SNORM,
        DXGI_FORMAT_R8G8_SINT,
        DXGI_FORMAT_R16_UNORM,
        DXGI_FORMAT_R16_SNORM,
        DXGI_FORMAT_R8_SNORM,
        DXGI_FORMAT_A8_UNORM,
        DXGI_FORMAT_B5G6R5_UNORM,
        DXGI_FORMAT_B5G5R5A1_UNORM,
        DXGI_FORMAT_B4G4R4A4_UNORM:
        begin
            // Conditionally supported by specific devices.
            if (typedUAVLoadAdditionalFormats) then
            begin

                formatSupport.Format := format;
                formatSupport.Support1 := D3D12_FORMAT_SUPPORT1_NONE;
                formatSupport.Support2 := D3D12_FORMAT_SUPPORT2_NONE;

                if (SUCCEEDED(device.CheckFeatureSupport(D3D12_FEATURE_FORMAT_SUPPORT, @formatSupport, sizeof(formatSupport)))) then
                begin
                    mask := Ord(D3D12_FORMAT_SUPPORT2_UAV_TYPED_LOAD) or Ord(D3D12_FORMAT_SUPPORT2_UAV_TYPED_STORE);
                    Result := ((Ord(formatSupport.Support2) and mask) = mask);
                    Exit;
                end;
            end;
            Result := False;
        end;

        else
            Result := False;
    end;
end;



function FormatIsBGR(format: TDXGI_FORMAT): boolean; inline;
begin
    case (format) of
        DXGI_FORMAT_B8G8R8A8_UNORM,
        DXGI_FORMAT_B8G8R8X8_UNORM,
        DXGI_FORMAT_B8G8R8A8_UNORM_SRGB,
        DXGI_FORMAT_B8G8R8X8_UNORM_SRGB:
            Result := True;
        else
            Result := False;
    end;
end;



function FormatIsSRGB(format: TDXGI_FORMAT): boolean; inline;
begin
    case (format) of
        DXGI_FORMAT_R8G8B8A8_UNORM_SRGB,
        DXGI_FORMAT_B8G8R8A8_UNORM_SRGB,
        DXGI_FORMAT_B8G8R8X8_UNORM_SRGB:
            Result := True;
        else
            Result := False;
    end;
end;



function ConvertSRVtoResourceFormat(format: TDXGI_FORMAT): TDXGI_FORMAT; inline;
begin
    case (format) of
        DXGI_FORMAT_R32G32B32A32_FLOAT,
        DXGI_FORMAT_R32G32B32A32_UINT,
        DXGI_FORMAT_R32G32B32A32_SINT:
            Result := DXGI_FORMAT_R32G32B32A32_TYPELESS;

        DXGI_FORMAT_R16G16B16A16_FLOAT,
        DXGI_FORMAT_R16G16B16A16_UNORM,
        DXGI_FORMAT_R16G16B16A16_UINT,
        DXGI_FORMAT_R16G16B16A16_SNORM,
        DXGI_FORMAT_R16G16B16A16_SINT:
            Result := DXGI_FORMAT_R16G16B16A16_TYPELESS;

        DXGI_FORMAT_R32G32_FLOAT,
        DXGI_FORMAT_R32G32_UINT,
        DXGI_FORMAT_R32G32_SINT:
            Result := DXGI_FORMAT_R32G32_TYPELESS;

        DXGI_FORMAT_R10G10B10A2_UNORM,
        DXGI_FORMAT_R10G10B10A2_UINT:
            Result := DXGI_FORMAT_R10G10B10A2_TYPELESS;

        DXGI_FORMAT_R8G8B8A8_UNORM,
        DXGI_FORMAT_R8G8B8A8_UINT,
        DXGI_FORMAT_R8G8B8A8_SNORM,
        DXGI_FORMAT_R8G8B8A8_SINT:
            Result := DXGI_FORMAT_R8G8B8A8_TYPELESS;

        DXGI_FORMAT_R16G16_FLOAT,
        DXGI_FORMAT_R16G16_UNORM,
        DXGI_FORMAT_R16G16_UINT,
        DXGI_FORMAT_R16G16_SNORM,
        DXGI_FORMAT_R16G16_SINT:
            Result := DXGI_FORMAT_R16G16_TYPELESS;

        DXGI_FORMAT_R32_FLOAT,
        DXGI_FORMAT_R32_UINT,
        DXGI_FORMAT_R32_SINT:
            Result := DXGI_FORMAT_R32_TYPELESS;

        DXGI_FORMAT_R8G8_UNORM,
        DXGI_FORMAT_R8G8_UINT,
        DXGI_FORMAT_R8G8_SNORM,
        DXGI_FORMAT_R8G8_SINT:
            Result := DXGI_FORMAT_R8G8_TYPELESS;

        DXGI_FORMAT_R16_FLOAT,
        DXGI_FORMAT_R16_UNORM,
        DXGI_FORMAT_R16_UINT,
        DXGI_FORMAT_R16_SNORM,
        DXGI_FORMAT_R16_SINT:
            Result := DXGI_FORMAT_R16_TYPELESS;

        DXGI_FORMAT_R8_UNORM,
        DXGI_FORMAT_R8_UINT,
        DXGI_FORMAT_R8_SNORM,
        DXGI_FORMAT_R8_SINT:
            Result := DXGI_FORMAT_R8_TYPELESS;

        else
            Result := format;
    end;
end;

{ TResourceUploadBatch }

procedure TResourceUploadBatch.GenerateMips_UnorderedAccessPath(resource: ID3D12Resource);
var
    defaultHeapProperties: TD3D12_HEAP_PROPERTIES;
    originalState: TD3D12_RESOURCE_STATES;
    staging: ID3D12Resource;
    desc: TD3D12_RESOURCE_DESC;
    stagingDesc: TD3D12_RESOURCE_DESC;
    descriptorHeap: ID3D12DescriptorHeap;
    descriptorHeapDesc: TD3D12_DESCRIPTOR_HEAP_DESC;
    descriptorSize: integer;
    handleIt: TD3D12_CPU_DESCRIPTOR_HANDLE;
    srvDesc: TD3D12_SHADER_RESOURCE_VIEW_DESC;
    uavDesc: TD3D12_UNORDERED_ACCESS_VIEW_DESC;
    mip: uint16;
    src, dst: TD3D12_TEXTURE_COPY_LOCATION;
    barrierUAV: TD3D12_RESOURCE_BARRIER;
    srv2uavDesc: TD3D12_RESOURCE_BARRIER;
    uav2srvDesc: TD3D12_RESOURCE_BARRIER;
    pso: ID3D12PipelineState;
    handle: TD3D12_GPU_DESCRIPTOR_HANDLE;
    barrier: array[0..2 - 1] of TD3D12_RESOURCE_BARRIER;
    uavH: TD3D12_GPU_DESCRIPTOR_HANDLE;
    mipWidth, mipHeight, mip32: uint32;
    constants: TGenerateMipsResources.TConstantData;
begin
    resource.GetDesc(@desc);

    assert(not FormatIsBGR(desc.Format) and not FormatIsSRGB(desc.Format));

    defaultHeapProperties.Init(D3D12_HEAP_TYPE_DEFAULT);

    assert(mCommandType <> D3D12_COMMAND_LIST_TYPE_COPY);
    if (mCommandType = D3D12_COMMAND_LIST_TYPE_COMPUTE) then
        originalState := D3D12_RESOURCE_STATE_COPY_DEST
    else
        originalState := D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE;

    // Create a staging resource if we have to
    if ((Ord(desc.Flags) and Ord(D3D12_RESOURCE_FLAG_ALLOW_UNORDERED_ACCESS)) = 0) then
    begin

        stagingDesc := desc;
        stagingDesc.Flags := TD3D12_RESOURCE_FLAGS(Ord(stagingDesc.Flags) or Ord(D3D12_RESOURCE_FLAG_ALLOW_UNORDERED_ACCESS));
        stagingDesc.Format := ConvertSRVtoResourceFormat(desc.Format);

        ThrowIfFailed(mDevice.CreateCommittedResource(@defaultHeapProperties, D3D12_HEAP_FLAG_NONE, @stagingDesc, D3D12_RESOURCE_STATE_COPY_DEST, nil, @IID_ID3D12Resource, staging));

        SetDebugObjectName(staging, 'GenerateMips Staging');

        // Copy the top mip of resource to staging
        TransitionResource(mList, resource, originalState, D3D12_RESOURCE_STATE_COPY_SOURCE);


        src.Init(PID3D12Resource(resource), 0);
        dst.Init(PID3D12Resource(staging), 0);
        mList.CopyTextureRegion(@dst, 0, 0, 0, @src, nil);

        TransitionResource(mList, staging, D3D12_RESOURCE_STATE_COPY_DEST, D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE);
    end
    else
    begin
        // Resource is already a UAV so we can do this in-place
        staging := resource;

        TransitionResource(mList, staging, originalState, D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE);
    end;

    // Create a descriptor heap that holds our resource descriptors

    descriptorHeapDesc.HeapType := D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV;
    descriptorHeapDesc.Flags := D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE;
    descriptorHeapDesc.NumDescriptors := desc.MipLevels;
    mDevice.CreateDescriptorHeap(@descriptorHeapDesc, @IID_ID3D12DescriptorHeap, descriptorHeap);

    SetDebugObjectName(descriptorHeap, 'ResourceUploadBatch');

    descriptorSize := mDevice.GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV);

    // Create the top-level SRV

    descriptorHeap.GetCPUDescriptorHandleForHeapStart(@handleIt);


    srvDesc.Format := desc.Format;
    srvDesc.ViewDimension := D3D12_SRV_DIMENSION_TEXTURE2D;
    srvDesc.Shader4ComponentMapping := D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
    srvDesc.Texture2D.MostDetailedMip := 0;
    srvDesc.Texture2D.MipLevels := desc.MipLevels;

    mDevice.CreateShaderResourceView(staging, @srvDesc, handleIt);

    // Create the UAVs for the tail

    for mip := 1 to desc.MipLevels - 1 do
    begin
        uavDesc.Init;
        uavDesc.Format := desc.Format;
        uavDesc.ViewDimension := D3D12_UAV_DIMENSION_TEXTURE2D;
        uavDesc.Texture2D.MipSlice := mip;

        handleIt.Offset(descriptorSize);
        mDevice.CreateUnorderedAccessView(staging, nil, @uavDesc, handleIt);
    end;

    // Set up UAV barrier (used in loop)

    barrierUAV.BarrierType := D3D12_RESOURCE_BARRIER_TYPE_UAV;
    barrierUAV.Flags := D3D12_RESOURCE_BARRIER_FLAG_NONE;
    barrierUAV.UAV.pResource := PID3D12Resource(staging);

    // Barrier for transitioning the subresources to UAVs

    srv2uavDesc.BarrierType := D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
    srv2uavDesc.Transition.pResource := PID3D12Resource(staging);
    srv2uavDesc.Transition.Subresource := 0;
    srv2uavDesc.Transition.StateBefore := D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE;
    srv2uavDesc.Transition.StateAfter := D3D12_RESOURCE_STATE_UNORDERED_ACCESS;

    // Barrier for transitioning the subresources to SRVs

    uav2srvDesc.BarrierType := D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
    uav2srvDesc.Transition.pResource := PID3D12Resource(staging);
    uav2srvDesc.Transition.Subresource := 0;
    uav2srvDesc.Transition.StateBefore := D3D12_RESOURCE_STATE_UNORDERED_ACCESS;
    uav2srvDesc.Transition.StateAfter := D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE;

    // based on format, select srgb or not

    pso := mGenMipsResources.generateMipsPSO;

    // Set up state
    mList.SetComputeRootSignature(mGenMipsResources.rootSignature);
    mList.SetPipelineState(pso);
    mList.SetDescriptorHeaps(1, @descriptorHeap);


    descriptorHeap.GetGPUDescriptorHandleForHeapStart(@handle);

    mList.SetComputeRootDescriptorTable(Ord(TGenerateMipsResources.TRootParameterIndex.SourceTexture), handle);

    // Get the descriptor handle -- uavH will increment over each loop

    uavH. Create(@handle, descriptorSize); // offset by 1 descriptor

    // Process each mip

    mipWidth := desc.Width;
    mipHeight := desc.Height;
    for mip32 := 1 to desc.MipLevels - 1 do
    begin
        mipWidth := max(1, mipWidth shr 1);
        mipHeight := max(1, mipHeight shr 1);

        // Transition the mip to a UAV
        srv2uavDesc.Transition.Subresource := mip32;
        mList.ResourceBarrier(1, @srv2uavDesc);

        // Bind the mip subresources
        mList.SetComputeRootDescriptorTable(Ord(TGenerateMipsResources.TRootParameterIndex.TargetTexture), uavH);

        // Set constants

        constants.SrcMipIndex := mip32 - 1;
        constants.InvOutTexelSize.Create(1 / (mipWidth), 1 / (mipHeight));
        mList.SetComputeRoot32BitConstants(
            Ord(TGenerateMipsResources.TRootParameterIndex.Constants),
            TGenerateMipsResources.Num32BitConstants, @constants,
            0);

        // Process this mip
        mList.Dispatch(
            (mipWidth + TGenerateMipsResources.ThreadGroupSize - 1) div TGenerateMipsResources.ThreadGroupSize,
            (mipHeight + TGenerateMipsResources.ThreadGroupSize - 1) div TGenerateMipsResources.ThreadGroupSize,
            1);

        mList.ResourceBarrier(1, @barrierUAV);

        // Transition the mip to an SRV
        uav2srvDesc.Transition.Subresource := mip;
        mList.ResourceBarrier(1, @uav2srvDesc);

        // Offset the descriptor heap handles
        uavH.Offset(descriptorSize);
    end;

    // If the staging resource is NOT the same as the resource, we need to copy everything back
    if (staging <> resource) then
    begin
        // Transition the resources ready for copy

        barrier[0].BarrierType := D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
        barrier[1].BarrierType := D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;

        barrier[0].Transition.Subresource := D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
        barrier[1].Transition.Subresource := D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;

        barrier[0].Transition.pResource := PID3D12Resource(staging);
        barrier[0].Transition.StateBefore := D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE;
        barrier[0].Transition.StateAfter := D3D12_RESOURCE_STATE_COPY_SOURCE;

        barrier[1].Transition.pResource := PID3D12Resource(resource);
        barrier[1].Transition.StateBefore := D3D12_RESOURCE_STATE_COPY_SOURCE;
        barrier[1].Transition.StateAfter := D3D12_RESOURCE_STATE_COPY_DEST;

        mList.ResourceBarrier(2, @barrier[0]);

        // Copy the entire resource back
        mList.CopyResource(resource, staging);

        // Transition the target resource back to pixel shader resource
        TransitionResource(mList, resource, D3D12_RESOURCE_STATE_COPY_DEST, originalState);

        mTrackedObjects.push_back(PID3D12Resource(staging));
    end
    else
    begin
        TransitionResource(mList, staging, D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE, originalState);
    end;

    // Add our temporary objects to the deferred deletion queue
    mTrackedObjects.push_back(PID3D12RootSignature(mGenMipsResources.rootSignature));
    mTrackedObjects.push_back(PID3D12PipelineState(pso));
    mTrackedObjects.push_back(PID3D12Resource(resource));
    mTrackedObjects.push_back(PID3D12DescriptorHeap(descriptorHeap));
end;



procedure TResourceUploadBatch.GenerateMips_TexturePath(resource: ID3D12Resource);
var
    resourceDesc, copyDesc: TD3D12_RESOURCE_DESC;
    heapProperties: TD3D12_HEAP_PROPERTIES;
    resourceCopy: ID3D12Resource;
    originalState: TD3D12_RESOURCE_STATES;
    src, dst: TD3D12_TEXTURE_COPY_LOCATION;
    barrier: array[0..1] of TD3D12_RESOURCE_BARRIER;
begin
    resource.GetDesc(@resourceDesc);

    assert(not FormatIsBGR(resourceDesc.Format) or FormatIsSRGB(resourceDesc.Format));

    copyDesc := resourceDesc;
    copyDesc.Format := DXGI_FORMAT_R8G8B8A8_UNORM;
    copyDesc.Flags := TD3D12_RESOURCE_FLAGS(Ord(copyDesc.Flags) or Ord(D3D12_RESOURCE_FLAG_ALLOW_UNORDERED_ACCESS));

    heapProperties.Init();

    // Create a resource with the same description, but without SRGB, and with UAV flags

    ThrowIfFailed(mDevice.CreateCommittedResource(@heapProperties, D3D12_HEAP_FLAG_NONE, @copyDesc, D3D12_RESOURCE_STATE_COPY_DEST, nil, @IID_ID3D12Resource, resourceCopy));

    SetDebugObjectName(resourceCopy, 'GenerateMips Resource Copy');

    assert(mCommandType <> D3D12_COMMAND_LIST_TYPE_COPY);
    if (mCommandType = D3D12_COMMAND_LIST_TYPE_COMPUTE) then
        originalState := D3D12_RESOURCE_STATE_COPY_DEST
    else
        originalState := D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE;

    // Copy the top mip of resource data
    TransitionResource(mList, resource, originalState, D3D12_RESOURCE_STATE_COPY_SOURCE);

    src.Init(PID3D12Resource(resource), 0);
    dst.Init(PID3D12Resource(resourceCopy), 0);
    mList.CopyTextureRegion(@dst, 0, 0, 0, @src, nil);

    TransitionResource(mList, resourceCopy, D3D12_RESOURCE_STATE_COPY_DEST, originalState);

    // Generate the mips
    GenerateMips_UnorderedAccessPath(resourceCopy);

    // Direct copy back
    barrier[0].BarrierType := D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
    barrier[1].BarrierType := D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;

    barrier[0].Transition.Subresource := D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
    barrier[1].Transition.Subresource := D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;

    barrier[0].Transition.pResource := PID3D12Resource(resourceCopy);
    barrier[0].Transition.StateBefore := originalState;
    barrier[0].Transition.StateAfter := D3D12_RESOURCE_STATE_COPY_SOURCE;

    barrier[1].Transition.pResource := PID3D12Resource(resource);
    barrier[1].Transition.StateBefore := D3D12_RESOURCE_STATE_COPY_SOURCE;
    barrier[1].Transition.StateAfter := D3D12_RESOURCE_STATE_COPY_DEST;

    mList.ResourceBarrier(2, @barrier[0]);

    // Copy the entire resource back
    mList.CopyResource(resource, resourceCopy);

    TransitionResource(mList, resource, D3D12_RESOURCE_STATE_COPY_DEST, originalState);

    // Track these object lifetimes on the GPU
    mTrackedObjects.push_back(PID3D12Resource(resourceCopy));
    mTrackedObjects.push_back(PID3D12Resource(resource));
end;



procedure TResourceUploadBatch.GenerateMips_TexturePathBGR(resource: ID3D12Resource);
var
    resourceDesc, copyDesc, aliasDesc: TD3D12_RESOURCE_DESC;
    heapDesc: TD3D12_HEAP_DESC;
    allocInfo: TD3D12_RESOURCE_ALLOCATION_INFO;
    heap: ID3D12Heap;
    resourceCopy: ID3D12Resource;
    aliasCopy: ID3D12Resource;
    originalState: TD3D12_RESOURCE_STATES;
    aliasBarrier: array [0..3 - 1] of TD3D12_RESOURCE_BARRIER;
    src, dst: TD3D12_TEXTURE_COPY_LOCATION;
begin
    resource.GetDesc(@resourceDesc);

    assert(FormatIsBGR(resourceDesc.Format));

    // Create a resource with the same description with RGB and with UAV flags
    copyDesc := resourceDesc;
    copyDesc.Format := DXGI_FORMAT_R8G8B8A8_UNORM;
    copyDesc.Flags := TD3D12_RESOURCE_FLAGS(Ord(copyDesc.Flags) or Ord(D3D12_RESOURCE_FLAG_ALLOW_UNORDERED_ACCESS));
    {$IFNDEF XBOX}
    copyDesc.Layout := D3D12_TEXTURE_LAYOUT_64KB_STANDARD_SWIZZLE;
    {$ENDIF}


    mDevice.GetResourceAllocationInfo(@allocInfo, 0, 1, @copyDesc);

    heapDesc.SizeInBytes := allocInfo.SizeInBytes;
    heapDesc.Flags := D3D12_HEAP_FLAG_ALLOW_ONLY_NON_RT_DS_TEXTURES;
    heapDesc.Properties.HeapType := D3D12_HEAP_TYPE_DEFAULT;


    ThrowIfFailed(mDevice.CreateHeap(@heapDesc, @IID_ID3D12Heap, heap));

    SetDebugObjectName(heap, 'ResourceUploadBatch');


    ThrowIfFailed(mDevice.CreatePlacedResource(heap, 0, @copyDesc, D3D12_RESOURCE_STATE_COPY_DEST, nil, @IID_ID3D12Resource, resourceCopy));

    SetDebugObjectName(resourceCopy, 'GenerateMips Resource Copy');

    // Create a BGRA alias
    aliasDesc := resourceDesc;
    if (resourceDesc.Format = DXGI_FORMAT_B8G8R8X8_UNORM) or (resourceDesc.Format = DXGI_FORMAT_B8G8R8X8_UNORM_SRGB) then
        aliasDesc.Format := DXGI_FORMAT_B8G8R8X8_UNORM
    else
        aliasDesc.Format := DXGI_FORMAT_B8G8R8A8_UNORM;

    aliasDesc.Layout := copyDesc.Layout;
    aliasDesc.Flags := TD3D12_RESOURCE_FLAGS(Ord(aliasDesc.Flags) or Ord(D3D12_RESOURCE_FLAG_ALLOW_UNORDERED_ACCESS));


    ThrowIfFailed(mDevice.CreatePlacedResource(heap, 0, @aliasDesc, D3D12_RESOURCE_STATE_COPY_DEST, nil, @IID_ID3D12Resource, aliasCopy));

    SetDebugObjectName(aliasCopy, 'GenerateMips BGR Alias Copy');

    assert(mCommandType <> D3D12_COMMAND_LIST_TYPE_COPY);
    if (mCommandType = D3D12_COMMAND_LIST_TYPE_COMPUTE) then
        originalState := D3D12_RESOURCE_STATE_COPY_DEST
    else
        originalState := D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE;

    // Copy the top mip of the resource data BGR to RGB

    aliasBarrier[0].BarrierType := D3D12_RESOURCE_BARRIER_TYPE_ALIASING;
    aliasBarrier[0].Aliasing.pResourceAfter := PID3D12Resource(aliasCopy);

    aliasBarrier[1].BarrierType := D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
    aliasBarrier[2].BarrierType := D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
    aliasBarrier[1].Transition.Subresource := D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
    aliasBarrier[2].Transition.Subresource := D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
    aliasBarrier[1].Transition.pResource := PID3D12Resource(resource);
    aliasBarrier[1].Transition.StateBefore := originalState;
    aliasBarrier[1].Transition.StateAfter := D3D12_RESOURCE_STATE_COPY_SOURCE;

    mList.ResourceBarrier(2, @aliasBarrier[0]);

    src.Init(PID3D12Resource(resource), 0);
    dst.Init(PID3D12Resource(aliasCopy), 0);
    mList.CopyTextureRegion(@dst, 0, 0, 0, @src, nil);

    // Generate the mips
    aliasBarrier[0].Aliasing.pResourceBefore := PID3D12Resource(aliasCopy);
    aliasBarrier[0].Aliasing.pResourceAfter := PID3D12Resource(resourceCopy);

    aliasBarrier[1].Transition.pResource := PID3D12Resource(resourceCopy);
    aliasBarrier[1].Transition.StateBefore := D3D12_RESOURCE_STATE_COPY_DEST;
    aliasBarrier[1].Transition.StateAfter := originalState;

    mList.ResourceBarrier(2, @aliasBarrier[0]);
    GenerateMips_UnorderedAccessPath(resourceCopy);

    // Direct copy back RGB to BGR
    aliasBarrier[0].Aliasing.pResourceBefore := PID3D12Resource(resourceCopy);
    aliasBarrier[0].Aliasing.pResourceAfter := PID3D12Resource(aliasCopy);

    aliasBarrier[1].Transition.pResource := PID3D12Resource(aliasCopy);
    aliasBarrier[1].Transition.StateBefore := D3D12_RESOURCE_STATE_COPY_DEST;
    aliasBarrier[1].Transition.StateAfter := D3D12_RESOURCE_STATE_COPY_SOURCE;

    aliasBarrier[2].Transition.pResource := PID3D12Resource(resource);
    aliasBarrier[2].Transition.StateBefore := D3D12_RESOURCE_STATE_COPY_SOURCE;
    aliasBarrier[2].Transition.StateAfter := D3D12_RESOURCE_STATE_COPY_DEST;

    mList.ResourceBarrier(3, @aliasBarrier[0]);

    // Copy the entire resource back
    mList.CopyResource(resource, aliasCopy);
    TransitionResource(mList, resource, D3D12_RESOURCE_STATE_COPY_DEST, originalState);

    // Track these object lifetimes on the GPU
    mTrackedObjects.push_back(PID3D12Heap(heap));
    mTrackedObjects.push_back(PID3D12Resource(resourceCopy));
    mTrackedObjects.push_back(PID3D12Resource(aliasCopy));
    mTrackedObjects.push_back(PID3D12Resource(resource));
end;



constructor TResourceUploadBatch.Create(device: ID3D12Device);
var
    options: TD3D12_FEATURE_DATA_D3D12_OPTIONS;
begin
    mDevice := device;
    mCommandType := D3D12_COMMAND_LIST_TYPE_DIRECT;
    mInBeginEndBlock := False;
    mTypedUAVLoadAdditionalFormats := False;
    mStandardSwizzle64KBSupported := False;

    if (device = nil) then
        raise Exception.Create('Direct3D device is null');

    if (SUCCEEDED(device.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS, @options, sizeof(options)))) then
    begin
        mTypedUAVLoadAdditionalFormats := options.TypedUAVLoadAdditionalFormats;
        mStandardSwizzle64KBSupported := options.StandardSwizzle64KBSupported;
    end;
end;

// Call this before your multiple calls to Upload.

procedure TResourceUploadBatch.BeginUpload(commandType: TD3D12_COMMAND_LIST_TYPE);
begin
    if (mInBeginEndBlock) then
        raise Exception.Create('Can''t Begin: already in a Begin-End block.');


    case (commandType) of

        D3D12_COMMAND_LIST_TYPE_DIRECT,
        D3D12_COMMAND_LIST_TYPE_COMPUTE,
        D3D12_COMMAND_LIST_TYPE_COPY:
        begin
        end;

        else
            DebugTrace('ResourceUploadBatch only supports Direct, Compute, and Copy command queues\n', []);
            raise Exception.Create('commandType parameter is invalid');
    end;

    mCmdAlloc := nil;
    ThrowIfFailed(mDevice.CreateCommandAllocator(commandType, @IID_ID3D12CommandAllocator, mCmdAlloc));

    SetDebugObjectName(mCmdAlloc, 'ResourceUploadBatch');

    mList := nil;
    ThrowIfFailed(mDevice.CreateCommandList(1, commandType, mCmdAlloc, nil, @IID_ID3D12GraphicsCommandList, mList));

    SetDebugObjectName(mList, 'ResourceUploadBatch');

    mCommandType := commandType;
    mInBeginEndBlock := True;
end;


// Asynchronously uploads a resource. The memory in subRes is copied.
// The resource must be in the COPY_DEST or COMMON state.
procedure TResourceUploadBatch.Upload(resource: ID3D12Resource; subresourceIndexStart: uint32; subRes: PD3D12_SUBRESOURCE_DATA; numSubresources: uint32);
var
    uploadSize: uint64;
    heapProps: TD3D12_HEAP_PROPERTIES;
    resDesc: TD3D12_RESOURCE_DESC;
    scratchResource: ID3D12Resource;
begin
    if (not mInBeginEndBlock) then
        raise Exception.Create('Can''t call Upload on a closed ResourceUploadBatch.');

    if ((resource = nil) or (subRes = nil) or (numSubresources = 0)) then
        raise Exception.Create('Resource/subresource are nil');

    uploadSize := GetRequiredIntermediateSize(resource, subresourceIndexStart, numSubresources);

    heapProps.Init(D3D12_HEAP_TYPE_UPLOAD);
    resDesc.Buffer(uploadSize);

    // Create a temporary buffer
    scratchResource := nil;
    ThrowIfFailed(mDevice.CreateCommittedResource(@heapProps, D3D12_HEAP_FLAG_NONE, @resDesc, D3D12_RESOURCE_STATE_GENERIC_READ, nil, // D3D12_CLEAR_VALUE* pOptimizedClearValue
        @IID_ID3D12Resource, scratchResource));

    SetDebugObjectName(scratchResource, 'ResourceUploadBatch Temporary');

    // Submit resource copy to command list
    UpdateSubresources_Heap(mList, resource, scratchResource, 0, subresourceIndexStart, numSubresources, PD3D12_SUBRESOURCE_DATA_ARRAY(subRes));

    // Remember this upload object for delayed release
    mTrackedObjects.push_back(PID3D12Resource(scratchResource));
end;



procedure TResourceUploadBatch.Upload(resource: ID3D12Resource; buffer: TSharedGraphicsResource);
begin
    if (not mInBeginEndBlock) then
        raise Exception.Create('Can''t call Upload on a closed ResourceUploadBatch.');

    if (resource = nil) then
        raise Exception.Create('Resource is nil');

    // Submit resource copy to command list
    mList.CopyBufferRegion(resource, 0, buffer.Resource(), buffer.ResourceOffset(), buffer.Size());

    // Remember this upload resource for delayed release
    mTrackedMemoryResources.push_back(buffer);
end;

// Asynchronously generate mips from a resource.
// Resource must be in the PIXEL_SHADER_RESOURCE state
procedure TResourceUploadBatch.GenerateMips(resource: ID3D12Resource);
var
    desc: TD3D12_RESOURCE_DESC;
    uavCompat: boolean;
begin
    if (not mInBeginEndBlock) then
        raise Exception.Create('Can''t call GenerateMips on a closed ResourceUploadBatch.');

    if (resource = nil) then
        raise Exception.Create('GenerateMips resource is null');

    if (mCommandType = D3D12_COMMAND_LIST_TYPE_COPY) then
    begin
        DebugTrace('ERROR: GenerateMips cannot operate on a copy queue\n', []);
        raise Exception.Create('GenerateMips cannot operate on a copy queue');
    end;


    resource.GetDesc(@Desc);


    if (desc.MipLevels = 1) then
    begin
        // Nothing to do
        Exit;
    end;
    if (desc.MipLevels = 0) then
    begin
        raise Exception.Create('GenerateMips: texture has no mips');
    end;
    if (desc.Dimension <> D3D12_RESOURCE_DIMENSION_TEXTURE2D) then
    begin
        raise Exception.Create('GenerateMips only supports Texture2D resources');
    end;
    if (desc.DepthOrArraySize <> 1) then
    begin
        raise Exception.Create('GenerateMips only supports 2D textures of array size 1');
    end;

    uavCompat := FormatIsUAVCompatible(mDevice, mTypedUAVLoadAdditionalFormats, desc.Format);

    if (not uavCompat and not FormatIsSRGB(desc.Format) and not FormatIsBGR(desc.Format)) then
    begin
        raise Exception.Create('GenerateMips doesn''t support this texture format on this device');
    end;

    // Ensure that we have valid generate mips data
    if (mGenMipsResources = nil) then
    begin
        mGenMipsResources := TGenerateMipsResources.Create(mDevice);
    end;

    // If the texture's format doesn't support UAVs we'll have to copy it to a texture that does first.
    // This is true of BGRA or sRGB textures, for example.
    if (uavCompat) then
    begin
        GenerateMips_UnorderedAccessPath(resource);
    end
    else if (not mTypedUAVLoadAdditionalFormats) then
    begin
        raise Exception.Create('GenerateMips needs TypedUAVLoadAdditionalFormats device support for sRGB/BGR');
    end
    else if (FormatIsBGR(desc.Format)) then
    begin
        {$IFNDEF XBOX}
        if (not mStandardSwizzle64KBSupported) then
        begin
            raise Exception.Create('GenerateMips needs StandardSwizzle64KBSupported device support for BGR');
        end;
        {$ENDIF}

        GenerateMips_TexturePathBGR(resource);
    end
    else
    begin
        GenerateMips_TexturePath(resource);
    end;
end;
// Transition a resource once you're done with it

// Transition a resource once you're done with it
procedure TResourceUploadBatch.Transition(resource: ID3D12Resource; stateBefore: TD3D12_RESOURCE_STATES; stateAfter: TD3D12_RESOURCE_STATES);
begin
    if (not mInBeginEndBlock) then
        raise Exception.Create('Can''t call Upload on a closed ResourceUploadBatch.');

    if (resource = nil) then
        raise Exception.Create('Transition resource is null');

    if (mCommandType = D3D12_COMMAND_LIST_TYPE_COPY) then
    begin
        case (stateAfter) of

            D3D12_RESOURCE_STATE_COPY_DEST,
            D3D12_RESOURCE_STATE_COPY_SOURCE:
            begin
            end

            else
                // Ignore other states for copy queues.
                Exit;
        end;
    end
    else if (mCommandType = D3D12_COMMAND_LIST_TYPE_COMPUTE) then
    begin
        case (stateAfter) of

            D3D12_RESOURCE_STATE_VERTEX_AND_CONSTANT_BUFFER,
            D3D12_RESOURCE_STATE_UNORDERED_ACCESS,
            D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE,
            D3D12_RESOURCE_STATE_INDIRECT_ARGUMENT,
            D3D12_RESOURCE_STATE_COPY_DEST,
            D3D12_RESOURCE_STATE_COPY_SOURCE:
            begin
            end;

            else
                // Ignore other states for compute queues.
                Exit;
        end;
    end;
    TransitionResource(mList, resource, stateBefore, stateAfter);
end;


// Submits all the uploads to the driver.
// No more uploads can happen after this call until Begin is called again.
// This returns a handle to an event that can be waited on.
procedure TResourceUploadBatch.EndUpload(commandQueue: ID3D12CommandQueue);
var
    fence: ID3D12Fence;
    gpuCompletedEvent: HANDLE;
    uploadBatch: PUploadBatch;
    wr: dword;
    tmpObjects: specialize TCStdVector<PID3D12DeviceChild>;
    tmpResources: specialize TCStdVector<TSharedGraphicsResource>;
begin
    if (not mInBeginEndBlock) then
        raise Exception.Create('ResourceUploadBatch already closed.');

    if (commandQueue = nil) then
        raise Exception.Create('Direct3D queue is null');

    ThrowIfFailed(mList.Close());

    // Submit the job to the GPU
    commandQueue.ExecuteCommandLists(1, PID3D12CommandList(mList));

    // Set an event so we get notified when the GPU has completed all its work

    ThrowIfFailed(mDevice.CreateFence(0, D3D12_FENCE_FLAG_NONE, @IID_ID3D12Fence, fence));

    SetDebugObjectName(fence, 'ResourceUploadBatch');

    gpuCompletedEvent := CreateEventExW(nil, nil, 0, EVENT_MODIFY_STATE or SYNCHRONIZE);
    if (gpuCompletedEvent = 0) then
        raise Exception.Create('CreateEventExW');

    ThrowIfFailed(commandQueue.Signal(fence, 1));
    ThrowIfFailed(fence.SetEventOnCompletion(1, gpuCompletedEvent));

    // Create a packet of data that'll be passed to our waiting upload thread
    new(uploadBatch);
    uploadBatch^.CommandList := PID3D12GraphicsCommandList(mList);
    uploadBatch^.Fence := PID3D12Fence(fence);
    uploadBatch^.GpuCompleteEvent.reset(gpuCompletedEvent);
    tmpObjects := mTrackedObjects;
    mTrackedObjects := uploadBatch^.TrackedObjects;
    uploadBatch^.TrackedObjects := tmpObjects;

    tmpResources := mTrackedMemoryResources;
    mTrackedMemoryResources := uploadBatch^.TrackedMemoryResources;
    uploadBatch^.TrackedMemoryResources := tmpResources;

    // Kick off a thread that waits for the upload to complete on the GPU timeline.
    // Let the thread run autonomously, but provide a future the user can wait on.

    // ToDo
        (*
        std::future<void> future := std::async(std::launch::async, [uploadBatch]()
            begin
                // Wait on the GPU-complete notification
                wr := WaitForSingleObject(uploadBatch.GpuCompleteEvent, INFINITE);
                if (wr <> WAIT_OBJECT_0) then
                begin
                    if (wr = WAIT_FAILED) then
                    begin
                        raise exception.create('WaitForSingleObject');
                    end
                    else
                    begin
                        raise exception.create('WaitForSingleObject');
                    end;
                end:

                // Delete the batch
                // Because the vectors contain smart-pointers, their destructors will
                // fire and the resources will be released.
                delete uploadBatch;
            end);
         *)
    // Reset our state
    mCommandType := D3D12_COMMAND_LIST_TYPE_DIRECT;
    mInBeginEndBlock := False;
    mList := nil;
    mCmdAlloc := nil;

    // Swap above should have cleared these
    assert(mTrackedObjects.empty());
    assert(mTrackedMemoryResources.empty());

    // ToDo return future;
end;



function TResourceUploadBatch.IsSupportedForGenerateMips(format: TDXGI_FORMAT): boolean;
begin
    if (mCommandType = D3D12_COMMAND_LIST_TYPE_COPY) then
    begin
        Result := False;
        exit;
    end;

    if (FormatIsUAVCompatible(mDevice, mTypedUAVLoadAdditionalFormats, format)) then
    begin
        Result := True;
        Exit;
    end;

    if (FormatIsBGR(format)) then
    begin
        {$IFDEF XBOX}
        // We know the RGB and BGR memory layouts match for Xbox One
        result:= true;
        {$ELSE}
        // BGR path requires DXGI_FORMAT_R8G8B8A8_UNORM support for UAV load/store plus matching layouts
        Result := mTypedUAVLoadAdditionalFormats and mStandardSwizzle64KBSupported;
        {$ENDIF}
        Exit;
    end;

    if (FormatIsSRGB(format)) then
    begin
        // sRGB path requires DXGI_FORMAT_R8G8B8A8_UNORM support for UAV load/store
        Result := mTypedUAVLoadAdditionalFormats;
        Exit;
    end;

    Result := False;
end;

{ TGenerateMipsResources }

function TGenerateMipsResources.CreateGenMipsRootSignature(device: ID3D12Device): ID3D12RootSignature;
var
    lRootSignature: ID3D12RootSignature;
    rsigDesc: TD3D12_ROOT_SIGNATURE_DESC;
    rootParameters: array [0..Ord(TRootParameterIndex.RootParameterCount) - 1] of TD3D12_ROOT_PARAMETER;
    sampler: TD3D12_STATIC_SAMPLER_DESC;
    rootSignatureFlags: TD3D12_ROOT_SIGNATURE_FLAGS;
const
    sourceDescriptorRange: TD3D12_DESCRIPTOR_RANGE = (RangeType: D3D12_DESCRIPTOR_RANGE_TYPE_SRV; NumDescriptors: 1; BaseShaderRegister: 0);
    targetDescriptorRange: TD3D12_DESCRIPTOR_RANGE = (RangeType: D3D12_DESCRIPTOR_RANGE_TYPE_UAV; NumDescriptors: 1; BaseShaderRegister: 0);
begin
    rootSignatureFlags := TD3D12_ROOT_SIGNATURE_FLAGS(Ord(D3D12_ROOT_SIGNATURE_FLAG_DENY_VERTEX_SHADER_ROOT_ACCESS) or Ord(D3D12_ROOT_SIGNATURE_FLAG_DENY_DOMAIN_SHADER_ROOT_ACCESS) or
        Ord(D3D12_ROOT_SIGNATURE_FLAG_DENY_GEOMETRY_SHADER_ROOT_ACCESS) or Ord(D3D12_ROOT_SIGNATURE_FLAG_DENY_HULL_SHADER_ROOT_ACCESS)
        {$IFDEF _GAMING_XBOX_SCARLETT}
                or ord(D3D12_ROOT_SIGNATURE_FLAG_DENY_AMPLIFICATION_SHADER_ROOT_ACCESS)
                or ord(D3D12_ROOT_SIGNATURE_FLAG_DENY_MESH_SHADER_ROOT_ACCESS)
        {$ENDIF}
        or Ord(D3D12_ROOT_SIGNATURE_FLAG_DENY_PIXEL_SHADER_ROOT_ACCESS));
    sampler.Init(0, // register
        D3D12_FILTER_MIN_MAG_LINEAR_MIP_POINT,
        D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
        D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
        D3D12_TEXTURE_ADDRESS_MODE_CLAMP);


    rootParameters[Ord(TRootParameterIndex.Constants)].InitAsConstants(Num32BitConstants, 0);
    rootParameters[Ord(TRootParameterIndex.SourceTexture)].InitAsDescriptorTable(1, @sourceDescriptorRange);
    rootParameters[Ord(TRootParameterIndex.TargetTexture)].InitAsDescriptorTable(1, @targetDescriptorRange);


    rsigDesc.Init(UINT(Length(rootParameters)), @rootParameters[0], 1, @sampler, rootSignatureFlags);
    ThrowIfFailed(CreateRootSignature(device, @rsigDesc, lRootSignature));
    SetDebugObjectName(lRootSignature, 'GenerateMips RootSignature');
    Result := lRootSignature;
end;



function TGenerateMipsResources.CreateGenMipsPipelineState(device: ID3D12Device; rootSignature: ID3D12RootSignature; bytecode: Puint8; bytecodeSize: size_t): ID3D12PipelineState;
var
    desc: TD3D12_COMPUTE_PIPELINE_STATE_DESC;
    pso: ID3D12PipelineState;
begin

    desc.CS.BytecodeLength := bytecodeSize;
    desc.CS.pShaderBytecode := bytecode;
    desc.pRootSignature := PID3D12RootSignature(rootSignature);


    ThrowIfFailed(device.CreateComputePipelineState(@desc, @IID_ID3D12PipelineState, pso));

    SetDebugObjectName(pso, 'GenerateMips PSO');

    Result := pso;
end;



constructor TGenerateMipsResources.Create(device: ID3D12Device);
var
    hr: HResult;
    compileFlags: UINT;
    ComputeShader: ID3DBlob;
    error: ID3DBlob;
begin
    rootSignature := CreateGenMipsRootSignature(device);
    {$IFOPT D+}
        // Enable better shader debugging with the graphics debugging tools.
        compileFlags := D3DCOMPILE_DEBUG or D3DCOMPILE_SKIP_OPTIMIZATION;
    {$ELSE}
    compileFlags := 0;
    {$ENDIF}
    hr := D3DCompileFromFile(pwidechar('.\shaders\GenerateMips.hlsl'), nil, nil, 'main', 'cs_6_0', compileFlags, 0, ComputeShader, @error);
    generateMipsPSO := CreateGenMipsPipelineState(device, rootSignature, ComputeShader.GetBufferPointer(), ComputeShader.GetBufferSize());
end;


end.
