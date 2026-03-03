//*********************************************************

// Copyright (c) Microsoft. All rights reserved.
// This code is licensed under the MIT License (MIT).
// THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
// IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
// PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.

//*********************************************************
unit FrameResource;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D12,
    DirectX.Math,
    DXSampleHelpers,
    Camera,
    stdafx;

type

    // Note that while ComPtr is used to manage the lifetime of resources on the CPU,
    // it has no understanding of the lifetime of resources on the GPU. Apps must account
    // for the GPU lifetime of resources to avoid destroying objects that may still be
    // referenced by the GPU.
    // An example of this can be found in the class method: OnDestroy().


    TLightState = record
        position: TXMFLOAT4;
        direction: TXMFLOAT4;
        color: TXMFLOAT4;
        falloff: TXMFLOAT4;
        view: TXMFLOAT4X4;
        projection: TXMFLOAT4X4;
    end;
    PLightState = ^TLightState;


    TSceneConstantBuffer = record
        model: TXMFLOAT4X4;
        view: TXMFLOAT4X4;
        projection: TXMFLOAT4X4;
        ambientColor: TXMFLOAT4;
        sampleShadowMap: winbool;
        padding: array [0..3 - 1] of winbool; // Must be aligned to be made up of N float4s.
        lights: array [0..NumLights - 1] of TLightState;
    end;
    PSceneConstantBuffer = ^TSceneConstantBuffer;

    TCameraArray = array [0..NumLights - 1] of TCamera;
    TLightStateArray = array [0..NumLights - 1] of TLightState;

    { TFrameResource }

    TFrameResource = class(TObject)
    protected
        m_pipelineState: ID3D12PipelineState;
        m_pipelineStateShadowMap: ID3D12PipelineState;
        m_shadowTexture: ID3D12Resource;
        m_shadowDepthView: TD3D12_CPU_DESCRIPTOR_HANDLE;
        m_shadowConstantBuffer: ID3D12Resource;
        m_sceneConstantBuffer: ID3D12Resource;
        mp_shadowConstantBufferWO: PSceneConstantBuffer; // WRITE-ONLY pointer to the shadow pass constant buffer.
        mp_sceneConstantBufferWO: PSceneConstantBuffer; // WRITE-ONLY pointer to the scene pass constant buffer.
        m_nullSrvHandle: TD3D12_GPU_DESCRIPTOR_HANDLE; // Null SRV for out of bounds behavior.
        m_shadowDepthHandle: TD3D12_GPU_DESCRIPTOR_HANDLE;
        m_shadowCbvHandle: TD3D12_GPU_DESCRIPTOR_HANDLE;
        m_sceneCbvHandle: TD3D12_GPU_DESCRIPTOR_HANDLE;
    public
        m_batchSubmit: array [0..NumContexts * 2 + CommandListCount - 1] of PID3D12CommandList;
        m_commandAllocators: array [0..CommandListCount - 1] of ID3D12CommandAllocator;
        m_commandLists: array [0..CommandListCount - 1] of ID3D12GraphicsCommandList8;
        m_shadowCommandAllocators: array [0..NumContexts - 1] of ID3D12CommandAllocator;
        m_shadowCommandLists: array [0..NumContexts - 1] of ID3D12GraphicsCommandList;
        m_sceneCommandAllocators: array [0..NumContexts - 1] of ID3D12CommandAllocator;
        m_sceneCommandLists: array [0..NumContexts - 1] of ID3D12GraphicsCommandList;
        m_fenceValue: uint64;
    public
        constructor Create(pDevice: ID3D12Device10; pPso: ID3D12PipelineState; pShadowMapPso: ID3D12PipelineState; pDsvHeap: ID3D12DescriptorHeap; pCbvSrvHeap: ID3D12DescriptorHeap; pViewport: PD3D12_VIEWPORT; frameResourceIndex: UINT);
        destructor Destroy; override;
        procedure Bind(pCommandList: ID3D12GraphicsCommandList; scenePass: winbool; pRtvHandle: PD3D12_CPU_DESCRIPTOR_HANDLE; pDsvHandle: PD3D12_CPU_DESCRIPTOR_HANDLE);
        procedure Init();
        procedure SwapBarriers();
        procedure Finish();
        procedure WriteConstantBuffers(pViewport: PD3D12_VIEWPORT; pSceneCamera: TCamera; lightCams: TCameraArray; lights: TLightStateArray);
    end;

    PFrameResource = ^TFrameResource;

implementation

uses
    CStdFunctions,
    SquidRoom,
    D3D12Multithreading,
    DX12.DXGIFormat,
    DX12.D3DX12_Core,
    DX12.D3DX12_Root_Signature,
    DX12.D3DX12_Barriers;

    { TFrameResource }

constructor TFrameResource.Create(pDevice: ID3D12Device10; pPso: ID3D12PipelineState; pShadowMapPso: ID3D12PipelineState; pDsvHeap: ID3D12DescriptorHeap; pCbvSrvHeap: ID3D12DescriptorHeap; pViewport: PD3D12_VIEWPORT; frameResourceIndex: UINT);
var
    i,jj: UINT;
    shadowTexDesc: TD3D12_RESOURCE_DESC;
    clearValue: TD3D12_CLEAR_VALUE;        // Performance tip: Tell the runtime at resource creation the desired clear value.
    dsvDescriptorSize: UINT;

    depthStencilViewDesc: TD3D12_DEPTH_STENCIL_VIEW_DESC;

    depthHandle: TD3D12_CPU_DESCRIPTOR_HANDLE;

    nullSrvCount: UINT;
    textureCount: UINT;
    cbvSrvDescriptorSize: UINT;
    cbvSrvCpuHandle: TD3D12_CPU_DESCRIPTOR_HANDLE;
    cbvSrvGpuHandle: TD3D12_GPU_DESCRIPTOR_HANDLE;

    shadowSrvDesc: TD3D12_SHADER_RESOURCE_VIEW_DESC;

    constantBufferSize: UINT;

    readRange: TD3D12_RANGE;
    cbvDesc: TD3D12_CONSTANT_BUFFER_VIEW_DESC;
    batchSize: UINT;
    HeapProp: TD3D12_HEAP_PROPERTIES;
    r1: TD3D12_RESOURCE_DESC1;
begin
    m_fenceValue := 0;
    m_pipelineState := pPso;
    m_pipelineStateShadowMap := pShadowMapPso;


    for i := 0 to CommandListCount-1 do
    begin
        ThrowIfFailed(pDevice.CreateCommandAllocator(D3D12_COMMAND_LIST_TYPE_DIRECT, @IID_ID3D12CommandAllocator, m_commandAllocators[i]));
        ThrowIfFailed(pDevice.CreateCommandList(0, D3D12_COMMAND_LIST_TYPE_DIRECT, m_commandAllocators[i], m_pipelineState, @IID_ID3D12GraphicsCommandList8,m_commandLists[i]));

        NAME_D3D12_OBJECT_INDEXED(m_commandLists[i],'m_commandLists', i);

        // Close these command lists; don't record into them for now.
        ThrowIfFailed(m_commandLists[i].Close());
    end;

    for i := 0 to NumContexts-1 do
    begin
        // Create command list allocators for worker threads. One alloc is
        // for the shadow pass command list, and one is for the scene pass.
        ThrowIfFailed(pDevice.CreateCommandAllocator(D3D12_COMMAND_LIST_TYPE_DIRECT, @IID_ID3D12CommandAllocator,m_shadowCommandAllocators[i]));
        ThrowIfFailed(pDevice.CreateCommandAllocator(D3D12_COMMAND_LIST_TYPE_DIRECT, @IID_ID3D12CommandAllocator,m_sceneCommandAllocators[i]));

        ThrowIfFailed(pDevice.CreateCommandList(0, D3D12_COMMAND_LIST_TYPE_DIRECT, m_shadowCommandAllocators[i], m_pipelineStateShadowMap, @IID_ID3D12GraphicsCommandList,m_shadowCommandLists[i]));
        ThrowIfFailed(pDevice.CreateCommandList(0, D3D12_COMMAND_LIST_TYPE_DIRECT, m_sceneCommandAllocators[i], m_pipelineState, @IID_ID3D12GraphicsCommandList,m_sceneCommandLists[i]));

        NAME_D3D12_OBJECT_INDEXED(m_shadowCommandLists[i],'m_shadowCommandLists', i);
        NAME_D3D12_OBJECT_INDEXED(m_sceneCommandLists[i],'m_sceneCommandLists', i);

        // Close these command lists; don't record into them for now. We will
        // reset them to a recording state when we start the render loop.
        ThrowIfFailed(m_shadowCommandLists[i].Close());
        ThrowIfFailed(m_sceneCommandLists[i].Close());
    end;

    // Describe and create the shadow map texture.
     shadowTexDesc.Init(
        D3D12_RESOURCE_DIMENSION_TEXTURE2D,
        0,
        trunc(pViewport^.Width),
        trunc(pViewport^.Height),
        1,
        1,
        DXGI_FORMAT_R32_TYPELESS,
        1,
        0,
        D3D12_TEXTURE_LAYOUT_UNKNOWN,
        D3D12_RESOURCE_FLAG_ALLOW_DEPTH_STENCIL);

    clearValue:=Default(TD3D12_CLEAR_VALUE);
    clearValue.Format := DXGI_FORMAT_D32_FLOAT;
    clearValue.DepthStencil.Depth := 1.0;
    clearValue.DepthStencil.Stencil := 0;

    if (gD3D12Multithreading.IsEnhancedBarriersEnabled()) then
    begin
        r1:= TD3D12_RESOURCE_DESC1(shadowTexDesc);
        ThrowIfFailed(pDevice.CreateCommittedResource3(
            @HeapProp,
            D3D12_HEAP_FLAG_NONE,
            @r1,
            D3D12_BARRIER_LAYOUT_DEPTH_STENCIL_WRITE,
            @clearValue,
            nil,
            0,
            nil,
            @IID_ID3D12Resource,m_shadowTexture));
    end
    else
    begin
        ThrowIfFailed(pDevice.CreateCommittedResource(
            TD3D12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_DEFAULT),
            D3D12_HEAP_FLAG_NONE,
            @shadowTexDesc,
            D3D12_RESOURCE_STATE_DEPTH_WRITE,
            @clearValue,
            @IID_ID3D12Resource,m_shadowTexture));
    end;

    NAME_D3D12_OBJECT(m_shadowTexture,'m_shadowTexture');

    // Get a handle to the start of the descriptor heap then offset
    // it based on the frame resource index.
     dsvDescriptorSize := pDevice.GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_DSV);
     depthHandle.Create(pDsvHeap.GetCPUDescriptorHandleForHeapStart(), 1 + frameResourceIndex, dsvDescriptorSize); // + 1 for the shadow map.

    // Describe and create the shadow depth view and cache the CPU
    // descriptor handle.
    depthStencilViewDesc.Format := DXGI_FORMAT_D32_FLOAT;
    depthStencilViewDesc.ViewDimension := D3D12_DSV_DIMENSION_TEXTURE2D;
    depthStencilViewDesc.Texture2D.MipSlice := 0;
    pDevice.CreateDepthStencilView(m_shadowTexture, @depthStencilViewDesc, depthHandle);
    m_shadowDepthView := depthHandle;

    // Get a handle to the start of the descriptor heap then offset it
    // based on the existing textures and the frame resource index. Each
    // frame has 1 SRV (shadow tex) and 2 CBVs.
      nullSrvCount := 2;                                // Null descriptors at the start of the heap.
      textureCount := length(SquidRoom.Textures);    // Diffuse + normal textures near the start of the heap.  Ideally, track descriptor heap contents/offsets at a higher level.
      cbvSrvDescriptorSize := pDevice.GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV);
     cbvSrvCpuHandle.Create(pCbvSrvHeap.GetCPUDescriptorHandleForHeapStart());
     cbvSrvGpuHandle.Create(pCbvSrvHeap.GetGPUDescriptorHandleForHeapStart());
    m_nullSrvHandle := cbvSrvGpuHandle;
    cbvSrvCpuHandle.Offset(nullSrvCount + textureCount + (frameResourceIndex * FrameCount), cbvSrvDescriptorSize);
    cbvSrvGpuHandle.Offset(nullSrvCount + textureCount + (frameResourceIndex * FrameCount), cbvSrvDescriptorSize);

    // Describe and create a shader resource view (SRV) for the shadow depth
    // texture and cache the GPU descriptor handle. This SRV is for sampling
    // the shadow map from our shader. It uses the same texture that we use
    // as a depth-stencil during the shadow pass.
    shadowSrvDesc.Format := DXGI_FORMAT_R32_FLOAT;
    shadowSrvDesc.ViewDimension := D3D12_SRV_DIMENSION_TEXTURE2D;
    shadowSrvDesc.Texture2D.MipLevels := 1;
    shadowSrvDesc.Shader4ComponentMapping := D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
    pDevice.CreateShaderResourceView(m_shadowTexture, @shadowSrvDesc, cbvSrvCpuHandle);
    m_shadowDepthHandle := cbvSrvGpuHandle;

    // Increment the descriptor handles.
    cbvSrvCpuHandle.Offset(cbvSrvDescriptorSize);
    cbvSrvGpuHandle.Offset(cbvSrvDescriptorSize);

    // Create the constant buffers.
     constantBufferSize := (sizeof(TSceneConstantBuffer) + (D3D12_CONSTANT_BUFFER_DATA_PLACEMENT_ALIGNMENT - 1)) and not(D3D12_CONSTANT_BUFFER_DATA_PLACEMENT_ALIGNMENT - 1); // must be a multiple 256 bytes

    if (gD3D12Multithreading.IsEnhancedBarriersEnabled()) then
    begin
        ThrowIfFailed(pDevice.CreateCommittedResource3(
            TD3D12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_UPLOAD),
            D3D12_HEAP_FLAG_NONE,
            TD3D12_RESOURCE_DESC1.CreateBuffer(constantBufferSize),
            D3D12_BARRIER_LAYOUT_UNDEFINED,
            nil,
            nil,
            0,
            nil,
            @IID_ID3D12Resource,m_shadowConstantBuffer));
        ThrowIfFailed(pDevice.CreateCommittedResource3(
            TD3D12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_UPLOAD),
            D3D12_HEAP_FLAG_NONE,
            TD3D12_RESOURCE_DESC1.CreateBuffer(constantBufferSize),
            D3D12_BARRIER_LAYOUT_UNDEFINED,
            nil,
            nil,
            0,
            nil,
            @IID_ID3D12Resource,m_sceneConstantBuffer));
    end
    else
    begin
        ThrowIfFailed(pDevice.CreateCommittedResource(
            TD3D12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_UPLOAD),
            D3D12_HEAP_FLAG_NONE,
            TD3D12_RESOURCE_DESC.CreateBuffer(constantBufferSize),
            D3D12_RESOURCE_STATE_GENERIC_READ,
            nil,
            @IID_ID3D12Resource,m_shadowConstantBuffer));

        ThrowIfFailed(pDevice.CreateCommittedResource(
            TD3D12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_UPLOAD),
            D3D12_HEAP_FLAG_NONE,
            TD3D12_RESOURCE_DESC.CreateBuffer(constantBufferSize),
            D3D12_RESOURCE_STATE_GENERIC_READ,
            nil,
            @IID_ID3D12Resource,m_sceneConstantBuffer));
    end;

    // Map the constant buffers and cache their heap pointers.
     readRange.Init(0, 0);        // We do not intend to read from this resource on the CPU.
    ThrowIfFailed(m_shadowConstantBuffer.Map(0, @readRange, pointer(mp_shadowConstantBufferWO)));
    ThrowIfFailed(m_sceneConstantBuffer.Map(0, @readRange, pointer(mp_sceneConstantBufferWO)));

    // Create the constant buffer views: one for the shadow pass and
    // another for the scene pass.
    cbvDesc.SizeInBytes := constantBufferSize;

    // Describe and create the shadow constant buffer view (CBV) and
    // cache the GPU descriptor handle.
    cbvDesc.BufferLocation := m_shadowConstantBuffer.GetGPUVirtualAddress();
    pDevice.CreateConstantBufferView(@cbvDesc, cbvSrvCpuHandle);
    m_shadowCbvHandle := cbvSrvGpuHandle;

    // Increment the descriptor handles.
    cbvSrvCpuHandle.Offset(cbvSrvDescriptorSize);
    cbvSrvGpuHandle.Offset(cbvSrvDescriptorSize);

    // Describe and create the scene constant buffer view (CBV) and
    // cache the GPU descriptor handle.
    cbvDesc.BufferLocation := m_sceneConstantBuffer.GetGPUVirtualAddress();
    pDevice.CreateConstantBufferView(@cbvDesc, cbvSrvCpuHandle);
    m_sceneCbvHandle := cbvSrvGpuHandle;

    // Batch up command lists for execution later.
    batchSize := length(m_sceneCommandLists) + length(m_shadowCommandLists) + 3;
    m_batchSubmit[0] := PID3D12CommandList(m_commandLists[CommandListPre]);
    ID3D12CommandList(m_batchSubmit[0])._AddRef;

//     memcpy(@m_batchSubmit[1], @m_shadowCommandLists[0], length(m_shadowCommandLists) * sizeof(PID3D12CommandList));
    for i:=0 to Length(m_shadowCommandLists)-1 do
    begin
        m_batchSubmit[1+i] :=PID3D12CommandList(m_shadowCommandLists[i]);
       ID3D12CommandList(m_batchSubmit[1+i])._AddRef;
    end;
    jj:=length(m_shadowCommandLists) + 1;
    m_batchSubmit[jj] :=PID3D12CommandList(m_commandLists[CommandListMid]);
    ID3D12CommandList(m_batchSubmit[jj])._AddRef;
    inc(jj);


//    memcpy(@m_batchSubmit[Length(m_shadowCommandLists) + 2], @m_sceneCommandLists[0], Length(m_sceneCommandLists) * sizeof(PID3D12CommandList));
     for i:=0 to Length(m_sceneCommandLists)-1 do
     begin
        m_batchSubmit[jj+i]:= PID3D12CommandList(m_sceneCommandLists[i]);
        ID3D12CommandList(m_batchSubmit[jj+i])._AddRef;
     end;

    m_batchSubmit[batchSize - 1] :=PID3D12CommandList( m_commandLists[CommandListPost]);
    ID3D12CommandList(m_batchSubmit[batchSize - 1])._AddRef;
end;



destructor TFrameResource.Destroy;
var
    i: integer;
begin
    for i := 0 to CommandListCount - 1 do
    begin
        m_commandAllocators[i] := nil;
        m_commandLists[i] := nil;
    end;

    m_shadowConstantBuffer := nil;
    m_sceneConstantBuffer := nil;

    for  i := 0 to NumContexts - 1 do
    begin
        m_shadowCommandLists[i] := nil;
        m_shadowCommandAllocators[i] := nil;

        m_sceneCommandLists[i] := nil;
        m_sceneCommandAllocators[i] := nil;
    end;

    m_shadowTexture := nil;

    inherited Destroy;
end;


// Sets up the descriptor tables for the worker command list to use
// resources provided by frame resource.
procedure TFrameResource.Bind(pCommandList: ID3D12GraphicsCommandList; scenePass: winbool; pRtvHandle: PD3D12_CPU_DESCRIPTOR_HANDLE; pDsvHandle: PD3D12_CPU_DESCRIPTOR_HANDLE);
begin
    if (scenePass) then
    begin
        // Scene pass. We use constant buf #2 and depth stencil #2
        // with rendering to the render target enabled.
        pCommandList.SetGraphicsRootDescriptorTable(2, m_shadowDepthHandle);        // Set the shadow texture as an SRV.
        pCommandList.SetGraphicsRootDescriptorTable(1, m_sceneCbvHandle);

        assert(pRtvHandle <> nil);
        assert(pDsvHandle <> nil);

        pCommandList.OMSetRenderTargets(1, pRtvHandle, False, pDsvHandle);
    end
    else
    begin
        // Shadow pass. We use constant buf #1 and depth stencil #1
        // with rendering to the render target disabled.
        pCommandList.SetGraphicsRootDescriptorTable(2, m_nullSrvHandle);            // Set a null SRV for the shadow texture.
        pCommandList.SetGraphicsRootDescriptorTable(1, m_shadowCbvHandle);

        pCommandList.OMSetRenderTargets(0, nil, False, @m_shadowDepthView);    // No render target needed for the shadow pass.
    end;
end;



procedure TFrameResource.Init();
var
    i: integer;
begin
    // Reset the command allocators and lists for the main thread.
    for  i := 0 to CommandListCount - 1 do
    begin
        ThrowIfFailed(m_commandAllocators[i].Reset());
        ThrowIfFailed(m_commandLists[i].Reset(m_commandAllocators[i], m_pipelineState));
    end;

    // Clear the depth stencil buffer in preparation for rendering the shadow map.
    m_commandLists[CommandListPre].ClearDepthStencilView(m_shadowDepthView, D3D12_CLEAR_FLAG_DEPTH, 1.0, 0, 0, nil);

    // Reset the worker command allocators and lists.
    for i := 0 to NumContexts - 1 do
    begin
        ThrowIfFailed(m_shadowCommandAllocators[i].Reset());
        ThrowIfFailed(m_shadowCommandLists[i].Reset(m_shadowCommandAllocators[i], m_pipelineStateShadowMap));

        ThrowIfFailed(m_sceneCommandAllocators[i].Reset());
        ThrowIfFailed(m_sceneCommandLists[i].Reset(m_sceneCommandAllocators[i], m_pipelineState));
    end;
end;



procedure TFrameResource.SwapBarriers();
var
    ShadowTextureBarriers: array of TD3D12_TEXTURE_BARRIER = ((SyncBefore: D3D12_BARRIER_SYNC_DEPTH_STENCIL;              // SyncBefore
        SyncAfter: D3D12_BARRIER_SYNC_PIXEL_SHADING;              // SyncAfter
        AccessBefore: D3D12_BARRIER_ACCESS_DEPTH_STENCIL_WRITE;      // AccessBefore
        AccessAfter: D3D12_BARRIER_ACCESS_SHADER_RESOURCE;          // AccessAfter
        LayoutBefore: D3D12_BARRIER_LAYOUT_DEPTH_STENCIL_WRITE;      // LayoutBefore
        LayoutAfter: D3D12_BARRIER_LAYOUT_SHADER_RESOURCE;          // LayoutAfter
        pResource: nil;
        Subresources: (IndexOrFirstMipLevel: $ffffffff;
        NumMipLevels: 0;
        FirstArraySlice: 0;
        NumArraySlices: 0;
        FirstPlane: 0;
        NumPlanes: 0); // All subresources
        Flags: D3D12_TEXTURE_BARRIER_FLAG_NONE));
    ShadowTextureBarrierGroups: array [0..0] of TD3D12_BARRIER_GROUP;
    lBarrier: TD3D12_RESOURCE_BARRIER;
begin
    if (gD3D12Multithreading.IsEnhancedBarriersEnabled()) then
    begin
        ShadowTextureBarriers[0].pResource := PID3D12Resource(m_shadowTexture);
        ShadowTextureBarrierGroups[0].InitTexture(Length(ShadowTextureBarriers), @ShadowTextureBarriers[0]);
        m_commandLists[CommandListMid].Barrier(Length(ShadowTextureBarrierGroups), @ShadowTextureBarrierGroups[0]);
    end
    else
    begin
        // Transition the shadow map from writeable to readable.
        lBarrier.InitTransition(m_shadowTexture, D3D12_RESOURCE_STATE_DEPTH_WRITE, D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE);
        m_commandLists[CommandListMid].ResourceBarrier(1, @lBarrier);
    end;
end;



procedure TFrameResource.Finish();
var
    FinishTexBarrier: array of TD3D12_TEXTURE_BARRIER = ((SyncBefore: D3D12_BARRIER_SYNC_PIXEL_SHADING;              // SyncBefore
        SyncAfter: D3D12_BARRIER_SYNC_DEPTH_STENCIL;              // SyncAfter
        AccessBefore: D3D12_BARRIER_ACCESS_SHADER_RESOURCE;          // AccessBefore
        AccessAfter: D3D12_BARRIER_ACCESS_DEPTH_STENCIL_WRITE;      // AccessAfter
        LayoutBefore: D3D12_BARRIER_LAYOUT_SHADER_RESOURCE;          // LayoutBefore
        LayoutAfter: D3D12_BARRIER_LAYOUT_DEPTH_STENCIL_WRITE;      // LayoutAfter
        pResource: nil;
        Subresources: (IndexOrFirstMipLevel: $ffffffff;
        NumMipLevels: 0;
        FirstArraySlice: 0;
        NumArraySlices: 0;
        FirstPlane: 0;
        NumPlanes: 0);
        // All subresources
        Flags: D3D12_TEXTURE_BARRIER_FLAG_NONE));

    FinishTexBarrierGroups: array[0..0] of TD3D12_BARRIER_GROUP;
    lBarrier: TD3D12_RESOURCE_BARRIER;
begin
    if (gD3D12Multithreading.IsEnhancedBarriersEnabled()) then
    begin
        FinishTexBarrier[0].pResource := PID3D12Resource(m_shadowTexture);
        FinishTexBarrierGroups[0].InitTexture(Length(FinishTexBarrier), @FinishTexBarrier[0]);
        m_commandLists[CommandListPost].Barrier(Length(FinishTexBarrierGroups), @FinishTexBarrierGroups[0]);
    end
    else
    begin
        lBarrier.InitTransition(m_shadowTexture, D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE, D3D12_RESOURCE_STATE_DEPTH_WRITE);
        m_commandLists[CommandListPost].ResourceBarrier(1, @lBarrier);

    end;
end;


// Builds and writes constant buffers from scratch to the proper slots for
// this frame resource.
procedure TFrameResource.WriteConstantBuffers(pViewport: PD3D12_VIEWPORT; pSceneCamera: TCamera; lightCams: TCameraArray; lights: TLightStateArray);
var
    sceneConsts: TSceneConstantBuffer = ();
    shadowConsts: TSceneConstantBuffer = ();
    i: integer;
begin
    // Scale down the world a bit.
    XMStoreFloat4x4(sceneConsts.model, XMMatrixScaling(0.1, 0.1, 0.1));
    XMStoreFloat4x4(shadowConsts.model, XMMatrixScaling(0.1, 0.1, 0.1));

    // The scene pass is drawn from the camera.
    pSceneCamera.Get3DViewProjMatrices(@sceneConsts.view, @sceneConsts.projection, 90.0, pViewport^.Width, pViewport^.Height);

    // The light pass is drawn from the first light.
    lightCams[0].Get3DViewProjMatrices(@shadowConsts.view, @shadowConsts.projection, 90.0, pViewport^.Width, pViewport^.Height);

    for  i := 0 to NumLights - 1 do
    begin
        memcpy(@sceneConsts.lights[i], @lights[i], sizeof(TLightState));
        memcpy(@shadowConsts.lights[i], @lights[i], sizeof(TLightState));
    end;

    // The shadow pass won't sample the shadow map, but rather write to it.
    shadowConsts.sampleShadowMap := False;

    // The scene pass samples the shadow map.
    sceneConsts.sampleShadowMap := True;

    shadowConsts.ambientColor.f := [0.1, 0.2, 0.3, 1.0];
    sceneConsts.ambientColor.f := [0.1, 0.2, 0.3, 1.0];

    memcpy(mp_sceneConstantBufferWO, @sceneConsts, sizeof(TSceneConstantBuffer));
    memcpy(mp_shadowConstantBufferWO, @shadowConsts, sizeof(TSceneConstantBuffer));
end;

end.
