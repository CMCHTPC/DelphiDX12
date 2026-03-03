//*********************************************************

// Copyright (c) Microsoft. All rights reserved.
// This code is licensed under the MIT License (MIT).
// THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
// IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
// PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.

//*********************************************************

unit D3D12Multithreading;

{$mode ObjFPC}{$H+}

// {$DEFINE SINGLETHREADED}
    {$DEFINE USESTACK}
    // use PIX only in debug builds
    {$IFOPT D+}
    {$DEFINE USEPIX}
    {$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DXSample,
    stdafx,
    DX12.D3D12,
    DX12.D3DCommon,
    DX12.DXGI1_4,
    DirectX.Math,
    Camera,
    FrameResource,
    {$IFDEF USEPIX}
    DX12.PIX3,
    DX12.PIXEvents,
    {$ENDIF}
    StepTimer,
    SquidRoom;


type


    TThreadParameter = record
        threadIndex: int32;
    end;
    PThreadParameter = ^TThreadParameter;


    { TD3D12Multithreading }

    TD3D12Multithreading = class(TDXSample)
    type
        TInputState = record
            rightArrowPressed: winbool;
            leftArrowPressed: winbool;
            upArrowPressed: winbool;
            downArrowPressed: winbool;
            animate: winbool;
        end;

    protected
        // Pipeline objects.
        m_viewport: TD3D12_VIEWPORT;
        m_scissorRect: TD3D12_RECT;
        m_swapChain: IDXGISwapChain3;
        m_device: ID3D12Device10;
        m_renderTargets: array [0..FrameCount - 1] of ID3D12Resource;
        m_depthStencil: ID3D12Resource;
        m_commandAllocator: ID3D12CommandAllocator;
        m_commandQueue: ID3D12CommandQueue;
        m_rootSignature: ID3D12RootSignature;
        m_rtvHeap: ID3D12DescriptorHeap;
        m_dsvHeap: ID3D12DescriptorHeap;
        m_cbvSrvHeap: ID3D12DescriptorHeap;
        m_samplerHeap: ID3D12DescriptorHeap;
        m_pipelineState: ID3D12PipelineState;
        m_pipelineStateShadowMap: ID3D12PipelineState;

        // App resources.
        m_vertexBufferView: TD3D12_VERTEX_BUFFER_VIEW;
        m_indexBufferView: TD3D12_INDEX_BUFFER_VIEW;
        m_textures: array [0..SquidRoom.TexturesCount - 1] of ID3D12Resource;
        m_textureUploads: array [0..SquidRoom.TexturesCount - 1] of ID3D12Resource;
        m_indexBuffer: ID3D12Resource;
        m_indexBufferUpload: ID3D12Resource;
        m_vertexBuffer: ID3D12Resource;
        m_vertexBufferUpload: ID3D12Resource;
        m_rtvDescriptorSize: UINT;
        m_keyboardInput: TInputState;
        m_lights: array [0..NumLights - 1] of TLightState;
        m_lightCameras: array [0..NumLights - 1] of TCamera;
        m_camera: TCamera;
        m_timer: TStepTimer;
        m_cpuTimer: TStepTimer;
        m_titleCount: int32;
        m_cpuTime: double;

        // Synchronization objects.
        m_workerBeginRenderFrame: array [0..NumContexts - 1] of HANDLE;
        m_workerFinishShadowPass: array [0..NumContexts - 1] of HANDLE;
        m_workerFinishedRenderFrame: array [0..NumContexts - 1] of HANDLE;
        m_threadHandles: array [0..NumContexts - 1] of HANDLE;
        m_frameIndex: UINT;
        m_fenceEvent: HANDLE;
        m_fence: ID3D12Fence;
        m_fenceValue: uint64;
        // Singleton object so that worker threads can share members.
        s_app: TD3D12Multithreading;
        // Frame resources.
        m_frameResources: array [0..FrameCount - 1] of TFrameResource;
        m_pCurrentFrameResource: TFrameResource;
        m_currentFrameResourceIndex: int32;
        s_bIsEnhancedBarriersEnabled: winbool;
        m_threadParameters: array [0..NumContexts - 1] of TThreadParameter;
    protected
        procedure WorkerThread(threadIndex: int32);
        procedure SetCommonPipelineState(pCommandList: ID3D12GraphicsCommandList);
        procedure LoadPipeline();
        procedure LoadAssets();
        procedure RestoreD3DResources();
        procedure ReleaseD3DResources();
        procedure WaitForGpu();
        procedure LoadContexts();
        procedure BeginFrame();
        procedure MidFrame();
        procedure EndFrame();
    public
        constructor Create(Width: UINT; Height: UINT; Name: widestring);
        destructor Destroy; override;
        function Get(): TD3D12Multithreading;
        function IsEnhancedBarriersEnabled(): boolean;
        procedure OnInit(); override;
        procedure OnUpdate(); override;
        procedure OnRender(); override;
        procedure OnDestroy(); override;
        // Samples override the event handlers to handle specific messages.
        procedure OnKeyDown(key: uint8); override;
        procedure OnKeyUp(key: uint8); override;
    end;

var
    gD3D12Multithreading: TD3D12Multithreading;

implementation

uses
    Win32Application,
    DX12.D3DX12_Root_Signature,
    DX12.DXGI,
    DX12.D3D12SDKLayers,
    DX12.DXGI1_2,
    DX12.DXGI1_3,
    DX12.DXGI1_6,
    DX12.D3DX12_Core,
    DX12.DXGIFormat,
    DX12.D3DCompiler,
    DX12.D3DX12_Resource_Helpers,
    DX12.D3DX12_Barriers,
    Windows.Macros,
    Math,
    DXSampleHelpers;

    { TD3D12Multithreading }

// Worker thread body. workerIndex is an integer from 0 to NumContexts
// describing the worker's thread index.
procedure TD3D12Multithreading.WorkerThread(threadIndex: int32);
var
    pShadowCommandList: ID3D12GraphicsCommandList;
    pSceneCommandList: ID3D12GraphicsCommandList;
    j: integer;
    cbvSrvDescriptorSize: UINT;
    cbvSrvHeapStart: TD3D12_GPU_DESCRIPTOR_HANDLE;
    nullSrvCount: UINT;
    cbvSrvHandle: TD3D12_GPU_DESCRIPTOR_HANDLE;
    rtvHandle: TD3D12_CPU_DESCRIPTOR_HANDLE;
    dsvHandle: TD3D12_CPU_DESCRIPTOR_HANDLE;
    drawArgs: SquidRoom.TDrawParameters;
begin
    assert(threadIndex >= 0);
    assert(threadIndex < NumContexts);
    {$IFNDEF SINGLETHREADED}

    while (threadIndex >= 0) and (threadIndex < NumContexts) do
    begin
        // Wait for main thread to tell us to draw.

        WaitForSingleObject(m_workerBeginRenderFrame[threadIndex], INFINITE);

    {$ENDIF}
    pShadowCommandList := ID3D12GraphicsCommandList(m_pCurrentFrameResource.m_shadowCommandLists[threadIndex]);
    pSceneCommandList := ID3D12GraphicsCommandList(m_pCurrentFrameResource.m_sceneCommandLists[threadIndex]);


    // Shadow pass


    // Populate the command list.
    SetCommonPipelineState(pShadowCommandList);
    m_pCurrentFrameResource.Bind(pShadowCommandList, False, nil, nil);    // No need to pass RTV or DSV descriptor heap.

    // Set null SRVs for the diffuse/normal textures.
    pShadowCommandList.SetGraphicsRootDescriptorTable(0, m_cbvSrvHeap.GetGPUDescriptorHandleForHeapStart());

    // Distribute objects over threads by drawing only 1/NumContexts
    // objects per worker (i.e. every object such that objectnum %
    // NumContexts == threadIndex).
    {$IFDEF USEPIX}
    specialize PIXBeginEvent<ID3D12GraphicsCommandList>(ID3D12GraphicsCommandList(pShadowCommandList), 0, 'Worker drawing shadow pass...',[]);
    {$ENDIF}

    j := threadIndex;
    while j < Length(SquidRoom.Draws) do
    begin
        drawArgs := SquidRoom.Draws[j];

        pShadowCommandList.DrawIndexedInstanced(drawArgs.IndexCount, 1, drawArgs.IndexStart, drawArgs.VertexBase, 0);
        j := j + NumContexts;
    end;

    {$IFDEF USEPIX}
    specialize PIXEndEvent<PID3D12GraphicsCommandList>(PID3D12GraphicsCommandList(pShadowCommandList));
    {$ENDIF}



    ThrowIfFailed(pShadowCommandList.Close());

    {$IFNDEF SINGLETHREADED}
        // Submit shadow pass.
        SetEvent(m_workerFinishShadowPass[threadIndex]);
    {$ENDIF}


    // Scene pass


    // Populate the command list.  These can only be sent after the shadow
    // passes for this frame have been submitted.
    SetCommonPipelineState(pSceneCommandList);
    rtvHandle.Create(m_rtvHeap.GetCPUDescriptorHandleForHeapStart(), m_frameIndex, m_rtvDescriptorSize);
    dsvHandle.Create(m_dsvHeap.GetCPUDescriptorHandleForHeapStart());
    m_pCurrentFrameResource.Bind(pSceneCommandList, True, @rtvHandle, @dsvHandle);

    {$IFDEF USEPIX}
    specialize PIXBeginEvent<ID3D12GraphicsCommandList>(ID3D12GraphicsCommandList(pSceneCommandList), 0, 'Worker drawing scene pass...',[]);
    {$ENDIF}




    cbvSrvHeapStart := m_cbvSrvHeap.GetGPUDescriptorHandleForHeapStart();
    cbvSrvDescriptorSize := m_device.GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV);
    nullSrvCount := 2;
    j := threadIndex;
    while j < Length(SquidRoom.Draws) do
    begin
        drawArgs := SquidRoom.Draws[j];

        // Set the diffuse and normal textures for the current object.
        cbvSrvHandle.Create(@cbvSrvHeapStart, nullSrvCount + drawArgs.DiffuseTextureIndex, cbvSrvDescriptorSize);
        pSceneCommandList.SetGraphicsRootDescriptorTable(0, cbvSrvHandle);

        pSceneCommandList.DrawIndexedInstanced(drawArgs.IndexCount, 1, drawArgs.IndexStart, drawArgs.VertexBase, 0);
        j := j + NumContexts;
    end;

    {$IFDEF USEPIX}
    specialize PIXEndEvent<PID3D12GraphicsCommandList>(PID3D12GraphicsCommandList(pSceneCommandList));
    {$ENDIF}

    ThrowIfFailed(pSceneCommandList.Close());

    {$IFNDEF SINGLETHREADED}
        // Tell main thread that we are done.
        SetEvent(m_workerFinishedRenderFrame[threadIndex]);
    end;
    {$ENDIF}
end;



procedure TD3D12Multithreading.SetCommonPipelineState(pCommandList: ID3D12GraphicsCommandList);
var
    ppHeaps: array[0..1] of PID3D12DescriptorHeap;
begin
    pCommandList.SetGraphicsRootSignature(m_rootSignature);

    ppHeaps[0] := PID3D12DescriptorHeap(m_cbvSrvHeap);
    ppHeaps[1] := PID3D12DescriptorHeap(m_samplerHeap);

    pCommandList.SetDescriptorHeaps(Length(ppHeaps), @ppHeaps[0]);

    pCommandList.RSSetViewports(1, @m_viewport);
    pCommandList.RSSetScissorRects(1, @m_scissorRect);
    pCommandList.IASetPrimitiveTopology(D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
    pCommandList.IASetVertexBuffers(0, 1, @m_vertexBufferView);
    pCommandList.IASetIndexBuffer(@m_indexBufferView);
    pCommandList.SetGraphicsRootDescriptorTable(3, m_samplerHeap.GetGPUDescriptorHandleForHeapStart());
    pCommandList.OMSetStencilRef(0);

    // Render targets and depth stencil are set elsewhere because the
    // depth stencil depends on the frame resource being used.

    // Constant buffers are set elsewhere because they depend on the
    // frame resource being used.

    // SRVs are set elsewhere because they change based on the object
    // being drawn.
end;


// Load the rendering pipeline dependencies.
procedure TD3D12Multithreading.LoadPipeline();
var
    dxgiFactoryFlags: UINT = 0;
    factory: IDXGIFactory4;
    warpAdapter: IDXGIAdapter;
    debugController: ID3D12Debug;
    hardwareAdapter: IDXGIAdapter1;
    options12: TD3D12_FEATURE_DATA_D3D12_OPTIONS12;
    queueDesc: TD3D12_COMMAND_QUEUE_DESC;
    swapChainDesc: TDXGI_SWAP_CHAIN_DESC1;
    swapChain: IDXGISwapChain1;

    rtvHeapDesc: TD3D12_DESCRIPTOR_HEAP_DESC;
    dsvHeapDesc: TD3D12_DESCRIPTOR_HEAP_DESC;
    nullSrvCount, cbvCount, srvCount: UINT;

    cbvSrvHeapDesc: TD3D12_DESCRIPTOR_HEAP_DESC;

    samplerHeapDesc: TD3D12_DESCRIPTOR_HEAP_DESC;
    nxx: integer;
    hr: Hresult;
begin
    {$IFOPT D+}

    // Enable the debug layer (requires the Graphics Tools "optional feature").
    // NOTE: Enabling the debug layer after device creation will invalidate the active device.
    begin

        if (SUCCEEDED(D3D12GetDebugInterface(@IID_ID3D12Debug,@debugController))) then
        begin
            debugController.EnableDebugLayer();

            // Enable additional debug layers.
            dxgiFactoryFlags := dxgiFactoryFlags or DXGI_CREATE_FACTORY_DEBUG;
        end;
    end;
    {$ENDIF}


    ThrowIfFailed(CreateDXGIFactory2(dxgiFactoryFlags, @IID_IDXGIFactory4, factory));

    if (m_useWarpDevice) then
    begin
        ThrowIfFailed(factory.EnumWarpAdapter(IID_IDXGIAdapter, warpAdapter));
        ThrowIfFailed(D3D12CreateDevice(warpAdapter, D3D_FEATURE_LEVEL_11_0, @IID_ID3D12Device10, @m_device));
    end
    else
    begin
        GetHardwareAdapter(factory, hardwareAdapter, True);
        ThrowIfFailed(D3D12CreateDevice(hardwareAdapter, D3D_FEATURE_LEVEL_11_0, @IID_ID3D12Device10, @m_device));
    end;

    ZeroMemory(@options12, sizeof(TD3D12_FEATURE_DATA_D3D12_OPTIONS12));
    ThrowIfFailed(m_device.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS12, @options12, sizeof(TD3D12_FEATURE_DATA_D3D12_OPTIONS12)));
    s_bIsEnhancedBarriersEnabled := (options12.EnhancedBarriersSupported);

    // Describe and create the command queue.

    queueDesc.Flags := D3D12_COMMAND_QUEUE_FLAG_NONE;
    queueDesc.CommandListType := D3D12_COMMAND_LIST_TYPE_DIRECT;

    ThrowIfFailed(m_device.CreateCommandQueue(@queueDesc, @IID_ID3D12CommandQueue, m_commandQueue));
    NAME_D3D12_OBJECT(m_commandQueue,'m_commandQueue');

    // Describe and create the swap chain.
    swapChainDesc.BufferCount := FrameCount;
    swapChainDesc.Width := m_width;
    swapChainDesc.Height := m_height;
    swapChainDesc.Format := DXGI_FORMAT_R8G8B8A8_UNORM;
    swapChainDesc.BufferUsage := DXGI_USAGE_RENDER_TARGET_OUTPUT;
    swapChainDesc.SwapEffect := DXGI_SWAP_EFFECT_FLIP_DISCARD;
    swapChainDesc.SampleDesc.Count := 1;


    ThrowIfFailed(factory.CreateSwapChainForHwnd(m_commandQueue,        // Swap chain needs the queue so that it can force a flush on it.
        gWin32Application.GetHwnd(), @swapChainDesc, nil, nil, swapChain));

    // This sample does not support fullscreen transitions.
    ThrowIfFailed(factory.MakeWindowAssociation(gWin32Application.GetHwnd(), DXGI_MWA_NO_ALT_ENTER));

    ThrowIfFailed(swapChain.QueryInterface(IID_IDXGISwapChain3, m_swapChain));
    m_frameIndex := m_swapChain.GetCurrentBackBufferIndex();

    // Create descriptor heaps.
    begin
        // Describe and create a render target view (RTV) descriptor heap.

        rtvHeapDesc.NumDescriptors := FrameCount;
        rtvHeapDesc.HeapType := D3D12_DESCRIPTOR_HEAP_TYPE_RTV;
        rtvHeapDesc.Flags := D3D12_DESCRIPTOR_HEAP_FLAG_NONE;
        ThrowIfFailed(m_device.CreateDescriptorHeap(@rtvHeapDesc, @IID_ID3D12DescriptorHeap, m_rtvHeap));

        // Describe and create a depth stencil view (DSV) descriptor heap.
        // Each frame has its own depth stencils (to write shadows onto)
        // and then there is one for the scene itself.

        dsvHeapDesc.NumDescriptors := 1 + FrameCount * 1;
        dsvHeapDesc.HeapType := D3D12_DESCRIPTOR_HEAP_TYPE_DSV;
        dsvHeapDesc.Flags := D3D12_DESCRIPTOR_HEAP_FLAG_NONE;
        ThrowIfFailed(m_device.CreateDescriptorHeap(@dsvHeapDesc, @IID_ID3D12DescriptorHeap, m_dsvHeap));

        // Describe and create a shader resource view (SRV) and constant
        // buffer view (CBV) descriptor heap.  Heap layout: null views,
        // object diffuse + normal textures views, frame 1's shadow buffer,
        // frame 1's 2x constant buffer, frame 2's shadow buffer, frame 2's
        // 2x constant buffers, etc...
        nullSrvCount := 2;        // Null descriptors are needed for out of bounds behavior reads.
        cbvCount := FrameCount * 2;
        srvCount := Length(SquidRoom.Textures) + (FrameCount * 1);

        cbvSrvHeapDesc.NumDescriptors := nullSrvCount + cbvCount + srvCount;
        cbvSrvHeapDesc.HeapType := D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV;
        cbvSrvHeapDesc.Flags := D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE;
        ThrowIfFailed(m_device.CreateDescriptorHeap(@cbvSrvHeapDesc, @IID_ID3D12DescriptorHeap, m_cbvSrvHeap));
        NAME_D3D12_OBJECT(m_cbvSrvHeap,'m_cbvSrvHeap');

        // Describe and create a sampler descriptor heap.

        samplerHeapDesc.NumDescriptors := 2;        // One clamp and one wrap sampler.
        samplerHeapDesc.HeapType := D3D12_DESCRIPTOR_HEAP_TYPE_SAMPLER;
        samplerHeapDesc.Flags := D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE;
        ThrowIfFailed(m_device.CreateDescriptorHeap(@samplerHeapDesc, @IID_ID3D12DescriptorHeap, m_samplerHeap));
        NAME_D3D12_OBJECT(m_samplerHeap,'m_samplerHeap');

        m_rtvDescriptorSize := m_device.GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_RTV);
    end;

    ThrowIfFailed(m_device.CreateCommandAllocator(D3D12_COMMAND_LIST_TYPE_DIRECT, @IID_ID3D12CommandAllocator, m_commandAllocator));
end;


// Load the sample assets.
procedure TD3D12Multithreading.LoadAssets();
var
    featureData: TD3D12_FEATURE_DATA_ROOT_SIGNATURE;
    ranges: array[0..4 - 1] of TD3D12_DESCRIPTOR_RANGE1; // Perfomance TIP: Order from most frequent to least frequent.
    rootParameters: array [0..4 - 1] of TD3D12_ROOT_PARAMETER1;
    rootSignatureDesc: TD3D12_VERSIONED_ROOT_SIGNATURE_DESC;
    signature: ID3DBlob;
    error: ID3DBlob;

    vertexShader: ID3DBlob;
    pixelShader: ID3DBlob;
    compileFlags: UINT;

    inputLayoutDesc: TD3D12_INPUT_LAYOUT_DESC;
    depthStencilDesc: TD3D12_DEPTH_STENCIL_DESC;
    psoDesc: TD3D12_GRAPHICS_PIPELINE_STATE_DESC;

    commandList: ID3D12GraphicsCommandList8;
    rtvHandle: TD3D12_CPU_DESCRIPTOR_HANDLE;
    i: UINT;

    shadowTextureDesc: TD3D12_RESOURCE_DESC;
    fileSize: UINT;
    pAssetData: pbyte;

    vertexData: TD3D12_SUBRESOURCE_DATA;
    indexData: TD3D12_SUBRESOURCE_DATA;
    cbvSrvDescriptorSize: UINT;
    cbvSrvHandle: TD3D12_CPU_DESCRIPTOR_HANDLE;
    nullSrvDesc: TD3D12_SHADER_RESOURCE_VIEW_DESC;

    srvCount: UINT;
    tex: SquidRoom.TTextureResource;
    texDesc: TD3D12_RESOURCE_DESC;
    subresourceCount: UINT;
    uploadBufferSize: uint64;
    textureData: TD3D12_SUBRESOURCE_DATA;
    //    TexturesBarriers: array of TD3D12_TEXTURE_BARRIER;
    srvDesc: TD3D12_SHADER_RESOURCE_VIEW_DESC;
    samplerDescriptorSize: UINT;
    samplerHandle: TD3D12_CPU_DESCRIPTOR_HANDLE;
    wrapSamplerDesc: TD3D12_SAMPLER_DESC;
    clampSamplerDesc: TD3D12_SAMPLER_DESC;
    eye, at, up: TXMVECTOR;
    ppCommandLists: array[0..0] of PID3D12CommandList;
    fenceToWaitFor: uint64;
    clearValue: TD3D12_CLEAR_VALUE;    // Performance tip: Tell the runtime at resource creation the desired clear value.

    VertexBufBarriers: array of TD3D12_BUFFER_BARRIER = ((SyncBefore: D3D12_BARRIER_SYNC_COPY;            // SyncBefore
        SyncAfter: D3D12_BARRIER_SYNC_VERTEX_SHADING;  // SyncAfter
        AccessBefore: D3D12_BARRIER_ACCESS_COPY_DEST;     // AccessBefore
        AccessAfter: D3D12_BARRIER_ACCESS_VERTEX_BUFFER // AccessAfter
        ));

    VertexBufBarrierGroups: array[0..0] of TD3D12_BARRIER_GROUP;
    lBarrier: TD3D12_RESOURCE_BARRIER;

    BufBarriers: array of TD3D12_BUFFER_BARRIER = ((SyncBefore: D3D12_BARRIER_SYNC_COPY;           // SyncBefore
        SyncAfter: D3D12_BARRIER_SYNC_INDEX_INPUT;    // SyncAfter
        AccessBefore: D3D12_BARRIER_ACCESS_COPY_DEST;    // AccessBefore
        AccessAfter: D3D12_BARRIER_ACCESS_INDEX_BUFFER // AccessAfter
        ));

    BufBarrierGroups: array[0..0] of TD3D12_BARRIER_GROUP;

    TextureBarrierGroups: array [0..0] of TD3D12_BARRIER_GROUP;

    TexturesBarriers: array of TD3D12_TEXTURE_BARRIER = ((SyncBefore: D3D12_BARRIER_SYNC_COPY;                       // SyncBefore
        SyncAfter: D3D12_BARRIER_SYNC_PIXEL_SHADING;              // SyncAfter
        AccessBefore: D3D12_BARRIER_ACCESS_COPY_DEST;                // AccessBefore
        AccessAfter: D3D12_BARRIER_ACCESS_SHADER_RESOURCE;          // AccessAfter
        LayoutBefore: D3D12_BARRIER_LAYOUT_COPY_DEST;                // LayoutBefore
        LayoutAfter: D3D12_BARRIER_LAYOUT_SHADER_RESOURCE;          // LayoutAfter
        pResource: nil;
        Subresources: (IndexOrFirstMipLevel: $ffffffff;
        NumMipLevels: 0;
        FirstArraySlice: 0;
        NumArraySlices: 0;
        FirstPlane: 0;
        NumPlanes: 0); // All subresources
        Flags: D3D12_TEXTURE_BARRIER_FLAG_NONE));
    HeapProperties: TD3D12_HEAP_PROPERTIES;

    nxx: integer;
begin
    // Create the root signature.
    begin

        // This is the highest version the sample supports. If CheckFeatureSupport succeeds, the HighestVersion returned will not be greater than this.
        featureData.HighestVersion := D3D_ROOT_SIGNATURE_VERSION_1_1;

        if (FAILED(m_device.CheckFeatureSupport(D3D12_FEATURE_ROOT_SIGNATURE, @featureData, sizeof(featureData)))) then
        begin
            featureData.HighestVersion := D3D_ROOT_SIGNATURE_VERSION_1_0;
        end;


        ranges[0].Init(D3D12_DESCRIPTOR_RANGE_TYPE_SRV, 2, 1, 0, D3D12_DESCRIPTOR_RANGE_FLAG_DATA_STATIC);    // 2 frequently changed diffuse + normal textures - using registers t1 and t2.
        ranges[1].Init(D3D12_DESCRIPTOR_RANGE_TYPE_CBV, 1, 0, 0, D3D12_DESCRIPTOR_RANGE_FLAG_DATA_STATIC);    // 1 frequently changed constant buffer.
        ranges[2].Init(D3D12_DESCRIPTOR_RANGE_TYPE_SRV, 1, 0);                                                // 1 infrequently changed shadow texture - starting in register t0.
        ranges[3].Init(D3D12_DESCRIPTOR_RANGE_TYPE_SAMPLER, 2, 0);                                            // 2 static samplers.


        rootParameters[0].InitAsDescriptorTable(1, @ranges[0], D3D12_SHADER_VISIBILITY_PIXEL);
        rootParameters[1].InitAsDescriptorTable(1, @ranges[1], D3D12_SHADER_VISIBILITY_ALL);
        rootParameters[2].InitAsDescriptorTable(1, @ranges[2], D3D12_SHADER_VISIBILITY_PIXEL);
        rootParameters[3].InitAsDescriptorTable(1, @ranges[3], D3D12_SHADER_VISIBILITY_PIXEL);


        rootSignatureDesc.Init_1_1(Length(rootParameters), @rootParameters[0], 0, nil, D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT);


        ThrowIfFailed(D3DX12SerializeVersionedRootSignature(@rootSignatureDesc, featureData.HighestVersion, signature, @error));
        ThrowIfFailed(m_device.CreateRootSignature(0, signature.GetBufferPointer(), signature.GetBufferSize(), @IID_ID3D12RootSignature, m_rootSignature));
        NAME_D3D12_OBJECT(m_rootSignature,'m_rootSignature');
    end;

    // Create the pipeline state, which includes loading shaders.
    begin

        {$IFOPT D+}
        // Enable better shader debugging with the graphics debugging tools.
         compileFlags := D3DCOMPILE_DEBUG or D3DCOMPILE_SKIP_OPTIMIZATION;
        {$ELSE}
        compileFlags := D3DCOMPILE_OPTIMIZATION_LEVEL3;
        {$ENDIF}

        ThrowIfFailed(D3DCompileFromFile(pwidechar(GetAssetFullPath('shaders.hlsl')), nil, nil, 'VSMain', 'vs_5_0', compileFlags, 0, vertexShader, nil));
        ThrowIfFailed(D3DCompileFromFile(pwidechar(GetAssetFullPath('shaders.hlsl')), nil, nil, 'PSMain', 'ps_5_0', compileFlags, 0, pixelShader, nil));


        inputLayoutDesc.pInputElementDescs := @SquidRoom.StandardVertexDescription[0];
        inputLayoutDesc.NumElements := Length(SquidRoom.StandardVertexDescription);


        depthStencilDesc.DepthEnable := True;
        depthStencilDesc.DepthWriteMask := D3D12_DEPTH_WRITE_MASK_ALL;
        depthStencilDesc.DepthFunc := D3D12_COMPARISON_FUNC_LESS_EQUAL;
        depthStencilDesc.StencilEnable := False;

        // Describe and create the PSO for rendering the scene.

        psoDesc.InputLayout := inputLayoutDesc;
        psoDesc.pRootSignature := PID3D12RootSignature(m_rootSignature);
        psoDesc.VS.Init(vertexShader);
        psoDesc.PS.Init(pixelShader);
        psoDesc.RasterizerState.Init;
        psoDesc.BlendState.Init;
        psoDesc.DepthStencilState := depthStencilDesc;
        psoDesc.SampleMask := UINT_MAX;
        psoDesc.PrimitiveTopologyType := D3D12_PRIMITIVE_TOPOLOGY_TYPE_TRIANGLE;
        psoDesc.NumRenderTargets := 1;
        psoDesc.RTVFormats[0] := DXGI_FORMAT_R8G8B8A8_UNORM;
        psoDesc.DSVFormat := DXGI_FORMAT_D32_FLOAT;
        psoDesc.SampleDesc.Count := 1;

        ThrowIfFailed(m_device.CreateGraphicsPipelineState(@psoDesc, @IID_ID3D12PipelineState, m_pipelineState));
        NAME_D3D12_OBJECT(m_pipelineState,'m_pipelineState');

        // Alter the description and create the PSO for rendering
        // the shadow map.  The shadow map does not use a pixel
        // shader or render targets.
        psoDesc.PS.Init(nil, 0);
        psoDesc.RTVFormats[0] := DXGI_FORMAT_UNKNOWN;
        psoDesc.NumRenderTargets := 0;

        ThrowIfFailed(m_device.CreateGraphicsPipelineState(@psoDesc, @IID_ID3D12PipelineState, m_pipelineStateShadowMap));
        NAME_D3D12_OBJECT(m_pipelineStateShadowMap,'m_pipelineStateShadowMap');
    end;

    // Create temporary command list for initial GPU setup.

    ThrowIfFailed(m_device.CreateCommandList(0, D3D12_COMMAND_LIST_TYPE_DIRECT, m_commandAllocator, m_pipelineState, @IID_ID3D12GraphicsCommandList8, commandList));

    // Create render target views (RTVs).
    rtvHandle.Create(m_rtvHeap.GetCPUDescriptorHandleForHeapStart());
    for i := 0 to FrameCount - 1 do
    begin
        nxx := SizeOf(m_renderTargets);
        ThrowIfFailed(m_swapChain.GetBuffer(i, @IID_ID3D12Resource, m_renderTargets[i]));
        m_device.CreateRenderTargetView(m_renderTargets[i], nil, rtvHandle);
        rtvHandle.Offset(1, m_rtvDescriptorSize);
        NAME_D3D12_OBJECT_INDEXED(m_renderTargets[i],'m_renderTargets', i);

    end;


    // Create the depth stencil.
    begin
        with shadowTextureDesc do
        begin
            Dimension := D3D12_RESOURCE_DIMENSION_TEXTURE2D;
            Alignment := 0;
            Width := trunc(m_viewport.Width);
            Height := trunc(m_viewport.Height);
            DepthOrArraySize := 1;
            MipLevels := 1;
            Format := DXGI_FORMAT_D32_FLOAT;
            SampleDesc.Count := 1;
            SampleDesc.Quality := 0;
            Layout := D3D12_TEXTURE_LAYOUT_UNKNOWN;
            Flags := TD3D12_RESOURCE_FLAGS(Ord(D3D12_RESOURCE_FLAG_ALLOW_DEPTH_STENCIL) or Ord(D3D12_RESOURCE_FLAG_DENY_SHADER_RESOURCE));
        end;


        clearValue := Default(TD3D12_CLEAR_VALUE);
        clearValue.Format := DXGI_FORMAT_D32_FLOAT;
        clearValue.DepthStencil.Depth := 1.0;
        clearValue.DepthStencil.Stencil := 0;

        if (s_bIsEnhancedBarriersEnabled) then
        begin
            ThrowIfFailed(m_device.CreateCommittedResource3(TD3D12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_DEFAULT), D3D12_HEAP_FLAG_NONE, PD3D12_RESOURCE_DESC1(@shadowTextureDesc),
                D3D12_BARRIER_LAYOUT_DEPTH_STENCIL_WRITE, @clearValue, nil, 0, nil, @IID_ID3D12Resource, m_depthStencil));
        end
        else
        begin
            HeapProperties.Init(D3D12_HEAP_TYPE_DEFAULT);
            ThrowIfFailed(m_device.CreateCommittedResource(@HeapProperties, D3D12_HEAP_FLAG_NONE, @shadowTextureDesc, D3D12_RESOURCE_STATE_DEPTH_WRITE, @clearValue, @IID_ID3D12Resource, m_depthStencil));
        end;

        NAME_D3D12_OBJECT(m_depthStencil,'m_depthStencil');

        // Create the depth stencil view.
        m_device.CreateDepthStencilView(m_depthStencil, nil, m_dsvHeap.GetCPUDescriptorHandleForHeapStart());
    end;

    // Load scene assets.
    fileSize := 0;

    ThrowIfFailed(ReadDataFromFile(pwidechar(GetAssetFullPath(SquidRoom.DataFileName)), pAssetData, fileSize));

    // Create the vertex buffer.
    begin
        if (s_bIsEnhancedBarriersEnabled) then
        begin
            ThrowIfFailed(m_device.CreateCommittedResource3(TD3D12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_DEFAULT), D3D12_HEAP_FLAG_NONE, TD3D12_RESOURCE_DESC1.CreateBuffer(SquidRoom.VertexDataSize),
                D3D12_BARRIER_LAYOUT_UNDEFINED, nil, nil, 0, nil, @IID_ID3D12Resource, m_vertexBuffer));
        end
        else
        begin
            ThrowIfFailed(m_device.CreateCommittedResource(TD3D12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_DEFAULT), D3D12_HEAP_FLAG_NONE, TD3D12_RESOURCE_DESC.CreateBuffer(SquidRoom.VertexDataSize),
                D3D12_RESOURCE_STATE_COPY_DEST, nil, @IID_ID3D12Resource, m_vertexBuffer));
        end;

        NAME_D3D12_OBJECT(m_vertexBuffer,'m_vertexBuffer');

        begin
            if (s_bIsEnhancedBarriersEnabled) then
            begin
                ThrowIfFailed(m_device.CreateCommittedResource3(TD3D12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_UPLOAD), D3D12_HEAP_FLAG_NONE, TD3D12_RESOURCE_DESC1.CreateBuffer(SquidRoom.VertexDataSize),
                    D3D12_BARRIER_LAYOUT_UNDEFINED, nil, nil, 0, nil, @IID_ID3D12Resource, m_vertexBufferUpload));
            end
            else
            begin
                ThrowIfFailed(m_device.CreateCommittedResource(TD3D12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_UPLOAD), D3D12_HEAP_FLAG_NONE, TD3D12_RESOURCE_DESC.CreateBuffer(SquidRoom.VertexDataSize),
                    D3D12_RESOURCE_STATE_GENERIC_READ, nil, @IID_ID3D12Resource, m_vertexBufferUpload));
            end;

            // Copy data to the upload heap and then schedule a copy
            // from the upload heap to the vertex buffer.
            vertexData.pData := pAssetData + SquidRoom.VertexDataOffset;
            vertexData.RowPitch := SquidRoom.VertexDataSize;
            vertexData.SlicePitch := vertexData.RowPitch;

            //   PIXBeginEvent(commandList.Get(), 0, 'Copy vertex buffer data to default resource...');

            {$IFDEF USESTACK}
            specialize UpdateSubresources_Stack<1>(commandList, m_vertexBuffer, m_vertexBufferUpload, 0, 0, 1, @vertexData);
            {$ELSE}
            UpdateSubresources_Heap(commandList, m_vertexBuffer, m_vertexBufferUpload, 0, 0, 1, @vertexData);
            {$ENDIF}
            if (s_bIsEnhancedBarriersEnabled) then
            begin

                VertexBufBarriers[0].pResource := PID3D12Resource(m_vertexBuffer);
                VertexBufBarriers[0].Offset := 0;
                VertexBufBarriers[0].Size := 0;
                VertexBufBarrierGroups[0].BarrierType := D3D12_BARRIER_TYPE_BUFFER;
                VertexBufBarrierGroups[0].NumBarriers := Length(VertexBufBarriers);
                VertexBufBarrierGroups[0].pBufferBarriers := @VertexBufBarriers[0];

                commandList.Barrier(Length(VertexBufBarrierGroups), @VertexBufBarrierGroups[0]);
            end
            else
            begin
                lBarrier.InitTransition(m_vertexBuffer, D3D12_RESOURCE_STATE_COPY_DEST, D3D12_RESOURCE_STATE_VERTEX_AND_CONSTANT_BUFFER);
                commandList.ResourceBarrier(1, @lBarrier);
            end;
            //            PIXEndEvent(commandList.Get());
        end;

        // Initialize the vertex buffer view.
        m_vertexBufferView.BufferLocation := m_vertexBuffer.GetGPUVirtualAddress();
        m_vertexBufferView.SizeInBytes := SquidRoom.VertexDataSize;
        m_vertexBufferView.StrideInBytes := SquidRoom.StandardVertexStride;
    end;

    // Create the index buffer.
    begin
        if (s_bIsEnhancedBarriersEnabled) then
        begin
            ThrowIfFailed(m_device.CreateCommittedResource3(TD3D12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_DEFAULT), D3D12_HEAP_FLAG_NONE, TD3D12_RESOURCE_DESC1.CreateBuffer(SquidRoom.IndexDataSize),
                D3D12_BARRIER_LAYOUT_UNDEFINED, nil, nil, 0, nil, @IID_ID3D12Resource, m_indexBuffer));
        end
        else
        begin
            ThrowIfFailed(m_device.CreateCommittedResource(TD3D12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_DEFAULT), D3D12_HEAP_FLAG_NONE, TD3D12_RESOURCE_DESC.CreateBuffer(SquidRoom.IndexDataSize),
                D3D12_RESOURCE_STATE_COPY_DEST, nil, @IID_ID3D12Resource, m_indexBuffer));
        end;

        NAME_D3D12_OBJECT(m_indexBuffer,'m_indexBuffer');

        begin
            if (s_bIsEnhancedBarriersEnabled) then
            begin
                ThrowIfFailed(m_device.CreateCommittedResource3(TD3D12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_UPLOAD), D3D12_HEAP_FLAG_NONE, TD3D12_RESOURCE_DESC1.CreateBuffer(SquidRoom.IndexDataSize),
                    D3D12_BARRIER_LAYOUT_UNDEFINED, nil, nil, 0, nil, @IID_ID3D12Resource, m_indexBufferUpload));
            end
            else
            begin
                ThrowIfFailed(m_device.CreateCommittedResource(TD3D12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_UPLOAD), D3D12_HEAP_FLAG_NONE, TD3D12_RESOURCE_DESC.CreateBuffer(SquidRoom.IndexDataSize),
                    D3D12_RESOURCE_STATE_GENERIC_READ, nil, @IID_ID3D12Resource, m_indexBufferUpload));
            end;

            // Copy data to the upload heap and then schedule a copy
            // from the upload heap to the index buffer.
            indexData.pData := pAssetData + SquidRoom.IndexDataOffset;
            indexData.RowPitch := SquidRoom.IndexDataSize;
            indexData.SlicePitch := indexData.RowPitch;

            //   PIXBeginEvent(commandList.Get(), 0, 'Copy index buffer data to default resource...');
            {$IFDEF USESTACK}
            specialize UpdateSubresources_Stack<1>(commandList, m_indexBuffer, m_indexBufferUpload, 0, 0, 1, @indexData);
            {$ELSE}
            UpdateSubresources_Heap(commandList, m_indexBuffer, m_indexBufferUpload, 0, 0, 1, @indexData);
            {$ENDIF}
            if (s_bIsEnhancedBarriersEnabled) then
            begin
                BufBarriers[0].pResource := PID3D12Resource(m_indexBuffer);

                BufBarrierGroups[0].BarrierType := D3D12_BARRIER_TYPE_BUFFER;
                BufBarrierGroups[0].NumBarriers := Length(BufBarriers);
                BufBarrierGroups[0].pBufferBarriers := @BufBarriers[0];

                commandList.Barrier(Length(BufBarrierGroups), @BufBarrierGroups[0]);
            end
            else
            begin
                commandList.ResourceBarrier(1, TD3D12_RESOURCE_BARRIER.CreateTransition(ID3D12Resource(m_indexBuffer), D3D12_RESOURCE_STATE_COPY_DEST, D3D12_RESOURCE_STATE_INDEX_BUFFER));
            end;

            //PIXEndEvent(commandList.Get());
        end;

        // Initialize the index buffer view.
        m_indexBufferView.BufferLocation := m_indexBuffer.GetGPUVirtualAddress();
        m_indexBufferView.SizeInBytes := SquidRoom.IndexDataSize;
        m_indexBufferView.Format := SquidRoom.StandardIndexFormat;
    end;

    // Create shader resources.
    begin
        // Get the CBV SRV descriptor size for the current device.
        cbvSrvDescriptorSize := m_device.GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV);

        // Get a handle to the start of the descriptor heap.
        cbvSrvHandle.Create(m_cbvSrvHeap.GetCPUDescriptorHandleForHeapStart());

        begin
            // Describe and create 2 null SRVs. Null descriptors are needed in order
            // to achieve the effect of an "unbound" resource.

            nullSrvDesc.ViewDimension := D3D12_SRV_DIMENSION_TEXTURE2D;
            nullSrvDesc.Shader4ComponentMapping := D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
            nullSrvDesc.Format := DXGI_FORMAT_R8G8B8A8_UNORM;
            nullSrvDesc.Texture2D.MipLevels := 1;
            nullSrvDesc.Texture2D.MostDetailedMip := 0;
            nullSrvDesc.Texture2D.ResourceMinLODClamp := 0.0;

            m_device.CreateShaderResourceView(nil, @nullSrvDesc, cbvSrvHandle);
            cbvSrvHandle.Offset(cbvSrvDescriptorSize);

            m_device.CreateShaderResourceView(nil, @nullSrvDesc, cbvSrvHandle);
            cbvSrvHandle.Offset(cbvSrvDescriptorSize);
        end;

        // Create each texture and SRV descriptor.
        srvCount := Length(SquidRoom.Textures);
        //        PIXBeginEvent(commandList.Get(), 0, 'Copy diffuse and normal texture data to default resources...');
        for i := 0 to srvCount - 1 do
        begin
            // Describe and create a Texture2D.

            tex := SquidRoom.Textures[i];
            texDesc.Init(
                D3D12_RESOURCE_DIMENSION_TEXTURE2D,
                0,
                tex.Width,
                tex.Height,
                1,
                uint16(tex.MipLevels),
                tex.Format,
                1,
                0,
                D3D12_TEXTURE_LAYOUT_UNKNOWN,
                D3D12_RESOURCE_FLAG_NONE);

            if (s_bIsEnhancedBarriersEnabled) then
            begin
                ThrowIfFailed(m_device.CreateCommittedResource3(TD3D12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_DEFAULT), D3D12_HEAP_FLAG_NONE, PD3D12_RESOURCE_DESC1(@texDesc),
                    D3D12_BARRIER_LAYOUT_COPY_DEST, nil, nil, 0, nil, @IID_ID3D12Resource, m_textures[i]));
            end
            else
            begin
                ThrowIfFailed(m_device.CreateCommittedResource(TD3D12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_DEFAULT), D3D12_HEAP_FLAG_NONE, @texDesc, D3D12_RESOURCE_STATE_COPY_DEST, nil, @IID_ID3D12Resource, m_textures[i]));
            end;

            NAME_D3D12_OBJECT_INDEXED(m_textures[i],'m_textures' ,i);

            begin
                subresourceCount := texDesc.DepthOrArraySize * texDesc.MipLevels;
                uploadBufferSize := GetRequiredIntermediateSize(m_textures[i], 0, subresourceCount);

                if (s_bIsEnhancedBarriersEnabled) then
                begin
                    ThrowIfFailed(m_device.CreateCommittedResource3(TD3D12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_UPLOAD), D3D12_HEAP_FLAG_NONE, TD3D12_RESOURCE_DESC1.CreateBuffer(uploadBufferSize),
                        D3D12_BARRIER_LAYOUT_UNDEFINED, nil, nil, 0, nil, @IID_ID3D12Resource, m_textureUploads[i]));
                end
                else
                begin
                    ThrowIfFailed(m_device.CreateCommittedResource(TD3D12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_UPLOAD), D3D12_HEAP_FLAG_NONE, TD3D12_RESOURCE_DESC.CreateBuffer(uploadBufferSize),
                        D3D12_RESOURCE_STATE_GENERIC_READ, nil, @IID_ID3D12Resource, m_textureUploads[i]));
                end;

                // Copy data to the intermediate upload heap and then schedule a copy
                // from the upload heap to the Texture2D.

                textureData.pData := pAssetData + tex.Data[0].Offset;
                textureData.RowPitch := tex.Data[0].Pitch;
                textureData.SlicePitch := tex.Data[0].Size;

                UpdateSubresources_Heap(commandList, m_textures[i], m_textureUploads[i], 0, 0, subresourceCount, @textureData);

                if (s_bIsEnhancedBarriersEnabled) then
                begin

                    TexturesBarriers[0].pResource := PID3D12Resource(m_textures[i]);
                    TextureBarrierGroups[0].NumBarriers := Length(TexturesBarriers);
                    TextureBarrierGroups[0].pBufferBarriers := @TexturesBarriers[0];
                    commandList.Barrier(Length(TextureBarrierGroups), @TextureBarrierGroups[0]);
                end
                else
                begin
                    commandList.ResourceBarrier(1, TD3D12_RESOURCE_BARRIER.CreateTransition(ID3D12Resource(m_textures[i]), D3D12_RESOURCE_STATE_COPY_DEST, D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE));
                end;
            end;

            // Describe and create an SRV.
            srvDesc.ViewDimension := D3D12_SRV_DIMENSION_TEXTURE2D;
            srvDesc.Shader4ComponentMapping := D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
            srvDesc.Format := tex.Format;
            srvDesc.Texture2D.MipLevels := tex.MipLevels;
            srvDesc.Texture2D.MostDetailedMip := 0;
            srvDesc.Texture2D.ResourceMinLODClamp := 0.0;
            m_device.CreateShaderResourceView(m_textures[i], @srvDesc, cbvSrvHandle);

            // Move to the next descriptor slot.
            cbvSrvHandle.Offset(cbvSrvDescriptorSize);
        end;
        // PIXEndEvent(commandList.Get());
    end;

    freeMem(pAssetData);

    // Create the samplers.
    begin
        // Get the sampler descriptor size for the current device.
        samplerDescriptorSize := m_device.GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_SAMPLER);

        // Get a handle to the start of the descriptor heap.
        samplerHandle.Create(m_samplerHeap.GetCPUDescriptorHandleForHeapStart());

        // Describe and create the wrapping sampler, which is used for
        // sampling diffuse/normal maps.

        wrapSamplerDesc.Filter := D3D12_FILTER_MIN_MAG_MIP_LINEAR;
        wrapSamplerDesc.AddressU := D3D12_TEXTURE_ADDRESS_MODE_WRAP;
        wrapSamplerDesc.AddressV := D3D12_TEXTURE_ADDRESS_MODE_WRAP;
        wrapSamplerDesc.AddressW := D3D12_TEXTURE_ADDRESS_MODE_WRAP;
        wrapSamplerDesc.MinLOD := 0;
        wrapSamplerDesc.MaxLOD := D3D12_FLOAT32_MAX;
        wrapSamplerDesc.MipLODBias := 0.0;
        wrapSamplerDesc.MaxAnisotropy := 1;
        wrapSamplerDesc.ComparisonFunc := D3D12_COMPARISON_FUNC_ALWAYS;
        wrapSamplerDesc.BorderColor[0] := 0;
        wrapSamplerDesc.BorderColor[1] := 0;
        wrapSamplerDesc.BorderColor[2] := 0;
        wrapSamplerDesc.BorderColor[3] := 0;
        m_device.CreateSampler(@wrapSamplerDesc, samplerHandle);

        // Move the handle to the next slot in the descriptor heap.
        samplerHandle.Offset(samplerDescriptorSize);

        // Describe and create the point clamping sampler, which is
        // used for the shadow map.

        clampSamplerDesc.Filter := D3D12_FILTER_MIN_MAG_MIP_POINT;
        clampSamplerDesc.AddressU := D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
        clampSamplerDesc.AddressV := D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
        clampSamplerDesc.AddressW := D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
        clampSamplerDesc.MipLODBias := 0.0;
        clampSamplerDesc.MaxAnisotropy := 1;
        clampSamplerDesc.ComparisonFunc := D3D12_COMPARISON_FUNC_ALWAYS;
        clampSamplerDesc.BorderColor[0] := 0;
        clampSamplerDesc.BorderColor[1] := 0;
        clampSamplerDesc.BorderColor[2] := 0;
        clampSamplerDesc.BorderColor[3] := 0;
        clampSamplerDesc.MinLOD := 0;
        clampSamplerDesc.MaxLOD := D3D12_FLOAT32_MAX;
        m_device.CreateSampler(@clampSamplerDesc, samplerHandle);
    end;

    // Create lights.
    for  i := 0 to NumLights - 1 do
    begin
        // Set up each of the light positions and directions (they all start
        // in the same place).
        m_lights[i].position.f := [0.0, 15.0, -30.0, 1.0];
        m_lights[i].direction.f := [0.0, 0.0, 1.0, 0.0];
        m_lights[i].falloff.f := [800.0, 1.0, 0.0, 1.0];
        m_lights[i].color.f := [0.7, 0.7, 0.7, 1.0];

        eye := XMLoadFloat4(m_lights[i].position);
        at := XMVectorAdd(eye, XMLoadFloat4(m_lights[i].direction));
        up := XMVectorSet(0.0, 1.0, 0.0, 0.0);

        m_lightCameras[i].SetCamera(eye, at, up);
    end;

    // Close the command list and use it to execute the initial GPU setup.
    ThrowIfFailed(commandList.Close());
    ppCommandLists[0] := PID3D12CommandList(commandList);
    ID3D12CommandList(ppCommandLists[0])._AddRef;
    m_commandQueue.ExecuteCommandLists(Length(ppCommandLists), @ppCommandLists[0]);

    // Create frame resources.
    for i := 0 to FrameCount - 1 do
    begin
        m_frameResources[i] := TFrameResource.Create(m_device, m_pipelineState, m_pipelineStateShadowMap, m_dsvHeap, m_cbvSrvHeap, @m_viewport, i);
        m_frameResources[i].WriteConstantBuffers(@m_viewport, m_camera, m_lightCameras, m_lights);
    end;
    m_currentFrameResourceIndex := 0;
    m_pCurrentFrameResource := m_frameResources[m_currentFrameResourceIndex];

    // Create synchronization objects and wait until assets have been uploaded to the GPU.
    begin
        ThrowIfFailed(m_device.CreateFence(m_fenceValue, D3D12_FENCE_FLAG_NONE, @IID_ID3D12Fence, m_fence));
        Inc(m_fenceValue);

        // Create an event handle to use for frame synchronization.
        m_fenceEvent := CreateEvent(nil, False, False, nil);
        if (m_fenceEvent = 0) then
        begin
            ThrowIfFailed(HRESULT_FROM_WIN32(GetLastError()));
        end;

        // Wait for the command list to execute; we are reusing the same command
        // list in our main loop but for now, we just want to wait for setup to
        // complete before continuing.

        // Signal and increment the fence value.
        fenceToWaitFor := m_fenceValue;
        ThrowIfFailed(m_commandQueue.Signal(m_fence, fenceToWaitFor));
        Inc(m_fenceValue);

        // Wait until the fence is completed.
        ThrowIfFailed(m_fence.SetEventOnCompletion(fenceToWaitFor, m_fenceEvent));
        WaitForSingleObject(m_fenceEvent, INFINITE);
    end;
end;


// Tears down D3D resources and reinitializes them.
procedure TD3D12Multithreading.RestoreD3DResources();
begin
    // Give GPU a chance to finish its execution in progress.
    try
        begin
            WaitForGpu();
        end;
    except // (HrException&)
        begin
            // Do nothing, currently attached adapter is unresponsive.
        end;
    end;
    ReleaseD3DResources();
    OnInit();
end;


// Release sample's D3D objects.
procedure TD3D12Multithreading.ReleaseD3DResources();
var
    i: integer;
begin
    m_fence := nil;
    for i := 0 to Length(m_renderTargets) - 1 do
        m_renderTargets[i] := nil;

    m_commandQueue := nil;
    m_swapChain := nil;
    m_device := nil;
end;


// Wait for pending GPU work to complete.
procedure TD3D12Multithreading.WaitForGpu();
begin
    // Schedule a Signal command in the queue.
    ThrowIfFailed(m_commandQueue.Signal(m_fence, m_fenceValue));

    // Wait until the fence has been processed.
    ThrowIfFailed(m_fence.SetEventOnCompletion(m_fenceValue, m_fenceEvent));
    WaitForSingleObjectEx(m_fenceEvent, INFINITE, False);
end;


 (*
function thunk(lpParameter: LPVOID): longword; stdcall;
var
    parameter: TThreadParameter;
begin
    parameter := TThreadParameter(lpParameter^);
    gD3D12Multithreading.WorkerThread(parameter.threadIndex);
    Result := 0;
end;
*)

// Initialize threads and events.

function thunk( lpParameter:pointer): ptrint;
    var
          parameter: PThreadParameter;
        begin
            parameter := PThreadParameter(lpParameter);
            gD3D12Multithreading.WorkerThread(parameter^.threadIndex);
            result:= 0;
        end;

procedure TD3D12Multithreading.LoadContexts();


var
    i: integer;
    temp: QWord;
begin
    {$IFNDEF SINGLETHREADED}


    for  i := 0 to NumContexts-1 do
    begin
        m_workerBeginRenderFrame[i] := CreateEvent(
            nil,
            FALSE,
            FALSE,
            nil);

        m_workerFinishedRenderFrame[i] := CreateEvent(
            nil,
            FALSE,
            FALSE,
            nil);

        m_workerFinishShadowPass[i] := CreateEvent(
            nil,
            FALSE,
            FALSE,
            nil);

        m_threadParameters[i].threadIndex := i;

        // C/C++ is ill ...
        temp:= m_threadParameters[i].threadIndex;
        m_threadHandles[i] :=BeginThread(
        nil, 0, @thunk, LPVOID(@m_threadParameters[i]),0,temp);


        assert(m_workerBeginRenderFrame[i] <> NULL);
        assert(m_workerFinishedRenderFrame[i] <> NULL);
        assert(m_threadHandles[i] <> NULL);

    end;
    {$ENDIF}
end;


// Assemble the CommandListPre command list.
procedure TD3D12Multithreading.BeginFrame();
var
    BeginFrameBarriers: array of TD3D12_TEXTURE_BARRIER = (
        // Using SYNC_NONE and ACCESS_NO_ACCESS with Enhanced Barrier to avoid unnecessary sync/flush.
        // Using them explicitly tells the GPU it is okay to immediately transition
        // the layout without waiting for preceding work to complete.
        // In this case, the legacy barrier would flush and finish any preceding work that may potentially be reading from the RT
        // resource (in this case there is none)
        (SyncBefore: D3D12_BARRIER_SYNC_NONE;                       // SyncBefore
        SyncAfter: D3D12_BARRIER_SYNC_RENDER_TARGET;              // SyncAfter
        AccessBefore: D3D12_BARRIER_ACCESS_NO_ACCESS;                // AccessBefore
        AccessAfter: D3D12_BARRIER_ACCESS_RENDER_TARGET;            // AccessAfter
        LayoutBefore: D3D12_BARRIER_LAYOUT_PRESENT;                  // LayoutBefore
        LayoutAfter: D3D12_BARRIER_LAYOUT_RENDER_TARGET;            // LayoutAfter
        pResource: nil;
        Subresources: (IndexOrFirstMipLevel: $ffffffff;
        NumMipLevels: 0;
        FirstArraySlice: 0;
        NumArraySlices: 0;
        FirstPlane: 0;
        NumPlanes: 0);  // All subresources
        Flags: D3D12_TEXTURE_BARRIER_FLAG_NONE));

    BeginFrameBarriersGroups: array[0..0] of TD3D12_BARRIER_GROUP;

    clearColor: array [0..3] of single;
    rtvHandle: TD3D12_CPU_DESCRIPTOR_HANDLE;
begin
    m_pCurrentFrameResource.Init();

    if (s_bIsEnhancedBarriersEnabled) then
    begin
        BeginFrameBarriers[0].pResource := PID3D12Resource(m_renderTargets[m_frameIndex]);
        BeginFrameBarriersGroups[0].NumBarriers := Length(BeginFrameBarriers);
        BeginFrameBarriersGroups[0].pBufferBarriers := @BeginFrameBarriers[0];

        m_pCurrentFrameResource.m_commandLists[CommandListPre].Barrier(Length(BeginFrameBarriersGroups), @BeginFrameBarriersGroups[0]);
    end
    else
    begin
        // Indicate that the back buffer will be used as a render target.
        m_pCurrentFrameResource.m_commandLists[CommandListPre].ResourceBarrier(1, TD3D12_RESOURCE_BARRIER.CreateTransition(ID3D12Resource(m_renderTargets[m_frameIndex]), D3D12_RESOURCE_STATE_PRESENT, D3D12_RESOURCE_STATE_RENDER_TARGET));
    end;

    // Clear the render target and depth stencil.
    clearColor := [0.0, 0.0, 0.0, 1.0];
    rtvHandle.Create(m_rtvHeap.GetCPUDescriptorHandleForHeapStart(), m_frameIndex, m_rtvDescriptorSize);
    m_pCurrentFrameResource.m_commandLists[CommandListPre].ClearRenderTargetView(rtvHandle, clearColor, 0, nil);
    m_pCurrentFrameResource.m_commandLists[CommandListPre].ClearDepthStencilView(m_dsvHeap.GetCPUDescriptorHandleForHeapStart(), D3D12_CLEAR_FLAG_DEPTH, 1.0, 0, 0, nil);

    ThrowIfFailed(m_pCurrentFrameResource.m_commandLists[CommandListPre].Close());
end;


// Assemble the CommandListMid command list.
procedure TD3D12Multithreading.MidFrame();
begin
    // Transition our shadow map from the shadow pass to readable in the scene pass.
    m_pCurrentFrameResource.SwapBarriers();

    ThrowIfFailed(m_pCurrentFrameResource.m_commandLists[CommandListMid].Close());
end;


// Assemble the CommandListPost command list.
procedure TD3D12Multithreading.EndFrame();
var
    EndFrameBarriers: array of TD3D12_TEXTURE_BARRIER = (
        // Using SYNC_NONE and ACCESS_NO_ACCESS with Enhanced Barrier means subsequent
        // commands are unblocked without having to wait for the barrier to complete.
        (SyncBefore: D3D12_BARRIER_SYNC_RENDER_TARGET;              // SyncBefore
        SyncAfter: D3D12_BARRIER_SYNC_NONE;                       // SyncAfter
        AccessBefore: D3D12_BARRIER_ACCESS_RENDER_TARGET;            // AccessBefore
        AccessAfter: D3D12_BARRIER_ACCESS_NO_ACCESS;                // AccessAfter
        LayoutBefore: D3D12_BARRIER_LAYOUT_RENDER_TARGET;            // LayoutBefore
        LayoutAfter: D3D12_BARRIER_LAYOUT_PRESENT;                  // LayoutAfter
        pResource: nil;
        Subresources: (IndexOrFirstMipLevel: $ffffffff;
        NumMipLevels: 0;
        FirstArraySlice: 0;
        NumArraySlices: 0;
        FirstPlane: 0;
        NumPlanes: 0); // All subresources
        Flags: D3D12_TEXTURE_BARRIER_FLAG_NONE));

    EndFrameBarrierGroups: array [0..0] of TD3D12_BARRIER_GROUP;
begin
    m_pCurrentFrameResource.Finish();

    if (s_bIsEnhancedBarriersEnabled) then
    begin
        EndFrameBarriers[0].pResource := PID3D12Resource(m_renderTargets[m_frameIndex]);
        EndFrameBarrierGroups[0].NumBarriers := Length(EndFrameBarriers);
        EndFrameBarrierGroups[0].pBufferBarriers := @EndFrameBarriers[0];
        m_pCurrentFrameResource.m_commandLists[CommandListPost].Barrier(Length(EndFrameBarrierGroups), @EndFrameBarrierGroups[0]);
    end
    else
    begin
        // Indicate that the back buffer will now be used to present.
        m_pCurrentFrameResource.m_commandLists[CommandListPost].ResourceBarrier(1, TD3D12_RESOURCE_BARRIER.CreateTransition(m_renderTargets[m_frameIndex], D3D12_RESOURCE_STATE_RENDER_TARGET, D3D12_RESOURCE_STATE_PRESENT));
    end;

    ThrowIfFailed(m_pCurrentFrameResource.m_commandLists[CommandListPost].Close());
end;



constructor TD3D12Multithreading.Create(Width: UINT; Height: UINT; Name: widestring);
begin
    inherited Create(Width, Height, Name);
    m_frameIndex := 0;
    m_viewport:=(TD3D12_VIEWPORT.Create(0.0, 0.0, Width, Height))^;
    m_scissorRect.Init(0, 0, LONG(Width), LONG(Height));
    //??    m_keyboardInput(),
    m_titleCount := 0;
    m_cpuTime := 0;
    m_fenceValue := 0;
    m_rtvDescriptorSize := 0;
    m_currentFrameResourceIndex := 0;
    m_pCurrentFrameResource := nil;
    s_app := self;

    m_keyboardInput.animate := True;

    m_timer := TStepTimer.Create;
    m_cpuTimer := TStepTimer.Create;

    ThrowIfFailed(DXGIDeclareAdapterRemovalSupport());
end;



destructor TD3D12Multithreading.Destroy;
begin
    m_timer.Free;
    m_cpuTimer.Free;
    s_app := nil;
    inherited Destroy;
end;



function TD3D12Multithreading.Get(): TD3D12Multithreading;
begin
    Result := self;
end;



function TD3D12Multithreading.IsEnhancedBarriersEnabled(): boolean;
begin
    Result := s_bIsEnhancedBarriersEnabled;
end;



procedure TD3D12Multithreading.OnInit();
begin
    LoadPipeline();
    LoadAssets();
    LoadContexts();
end;


// Update frame-based values.
procedure TD3D12Multithreading.OnUpdate();
var
    lastCompletedFence: uint64;
    eventHandle: HANDLE;
    frameTime: single;
    frameChange: single;
    i: integer;
    direction: single;
    eye, at, up: TXMVECTOR;
begin
    inherited OnUpdate();
    m_timer.Tick(nil);

    //  PIXSetMarker(m_commandQueue.Get(), 0, L"Getting last completed fence.");

    // Get current GPU progress against submitted workload. Resources still scheduled
    // for GPU execution cannot be modified or else undefined behavior will result.
    lastCompletedFence := m_fence.GetCompletedValue();

    // Move to the next frame resource.
    m_currentFrameResourceIndex := (m_currentFrameResourceIndex + 1) mod FrameCount;
    m_pCurrentFrameResource := m_frameResources[m_currentFrameResourceIndex];

    // Make sure that this frame resource isn't still in use by the GPU.
    // If it is, wait for it to complete.
    if (m_pCurrentFrameResource.m_fenceValue > lastCompletedFence) then
    begin
        eventHandle := CreateEvent(nil, False, False, nil);
        if (eventHandle = 0) then
        begin
            ThrowIfFailed(HRESULT_FROM_WIN32(GetLastError()));
        end;
        ThrowIfFailed(m_fence.SetEventOnCompletion(m_pCurrentFrameResource.m_fenceValue, eventHandle));
        WaitForSingleObject(eventHandle, INFINITE);
        CloseHandle(eventHandle);
    end;

    m_cpuTimer.Tick(nil);
    frameTime := single(m_timer.GetElapsedSeconds());
    frameChange := 2.0 * frameTime;

    if (m_keyboardInput.leftArrowPressed) then
        m_camera.RotateYaw(-frameChange);
    if (m_keyboardInput.rightArrowPressed) then
        m_camera.RotateYaw(frameChange);
    if (m_keyboardInput.upArrowPressed) then
        m_camera.RotatePitch(frameChange);
    if (m_keyboardInput.downArrowPressed) then
        m_camera.RotatePitch(-frameChange);

    if (m_keyboardInput.animate) then
    begin
        for i := 0 to NumLights - 1 do
        begin
            direction := frameChange * power(-1.0, single(i));
            XMStoreFloat4(@m_lights[i].position, XMVector4Transform(XMLoadFloat4(m_lights[i].position), XMMatrixRotationY(direction)));

            eye := XMLoadFloat4(m_lights[i].position);
            at := XMVectorSet(0.0, 8.0, 0.0, 0.0);
            XMStoreFloat4(@m_lights[i].direction, XMVector3Normalize(XMVectorSubtract(at, eye)));
            up := XMVectorSet(0.0, 1.0, 0.0, 0.0);
            m_lightCameras[i].SetCamera(eye, at, up);

            m_lightCameras[i].Get3DViewProjMatrices(@m_lights[i].view, @m_lights[i].projection, 90.0, single(m_width), single(m_height));
        end;
    end;

    m_pCurrentFrameResource.WriteConstantBuffers(@m_viewport, m_camera, m_lightCameras, m_lights);
end;


// Render the scene.
procedure TD3D12Multithreading.OnRender();
var
    i: integer;
    cpu: widestring;
begin
    inherited OnRender();
    try
        begin
            BeginFrame();

            {$IFDEF SINGLETHREADED}
            for i := 0 to NumContexts - 1 do
            begin
                WorkerThread(i);
            end;
            MidFrame();
            EndFrame();
            m_commandQueue.ExecuteCommandLists(Length(m_pCurrentFrameResource.m_batchSubmit), @m_pCurrentFrameResource.m_batchSubmit[0]);
            {$ELSE}
        for  i := 0 to NumContexts-1 do
        begin
            SetEvent(m_workerBeginRenderFrame[i]); // Tell each worker to start drawing.
        end;

        MidFrame();
        EndFrame();

        WaitForMultipleObjects(NumContexts, @m_workerFinishShadowPass[0], TRUE, INFINITE);

        // You can execute command lists on any thread. Depending on the work
        // load, apps can choose between using ExecuteCommandLists on one thread
        // vs ExecuteCommandList from multiple threads.
        m_commandQueue.ExecuteCommandLists(NumContexts + 2, @m_pCurrentFrameResource.m_batchSubmit[0]); // Submit PRE, MID and shadows.

        WaitForMultipleObjects(NumContexts, @m_workerFinishedRenderFrame[0], TRUE, INFINITE);

        // Submit remaining command lists.
        m_commandQueue.ExecuteCommandLists(Length(m_pCurrentFrameResource.m_batchSubmit) - NumContexts - 2, @m_pCurrentFrameResource.m_batchSubmit[NumContexts + 2]);
            {$ENDIF}

            m_cpuTimer.Tick(nil);
            if (m_titleCount = TitleThrottle) then
            begin
                cpu := format('%.4f CPU', [m_cpuTime / m_titleCount]);
                SetCustomWindowText('Free Pascal DirectX12 Multithreading sample: '+cpu);

                m_titleCount := 0;
                m_cpuTime := 0;
            end
            else
            begin
                Inc(m_titleCount);
                m_cpuTime := m_cpuTime + m_cpuTimer.GetElapsedSeconds() * 1000;
                m_cpuTimer.ResetElapsedTime();
            end;

            // Present and update the frame index for the next frame.
            // PIXBeginEvent(m_commandQueue.Get(), 0, L"Presenting to screen");
            ThrowIfFailed(m_swapChain.Present(1, 0));
            // PIXEndEvent(m_commandQueue.Get());
            m_frameIndex := m_swapChain.GetCurrentBackBufferIndex();

            // Signal and increment the fence value.
            m_pCurrentFrameResource.m_fenceValue := m_fenceValue;
            ThrowIfFailed(m_commandQueue.Signal(m_fence, m_fenceValue));
            Inc(m_fenceValue);
        end;

    except // (HrException& e)
        begin
        (*
        if (e.Error() = DXGI_ERROR_DEVICE_REMOVED or e.Error() = DXGI_ERROR_DEVICE_RESET)
        begin
            RestoreD3DResources();
        end;
        else
        begin
            throw;
        end;   *)
        end;

    end;

end;



procedure TD3D12Multithreading.OnDestroy();
var
    fence: uint64;
    lastCompletedFence: uint64;
    i: integer;
begin
    inherited OnDestroy();

    // Ensure that the GPU is no longer referencing resources that are about to be
    // cleaned up by the destructor.
    begin
        fence := m_fenceValue;
        lastCompletedFence := m_fence.GetCompletedValue();

        // Signal and increment the fence value.
        ThrowIfFailed(m_commandQueue.Signal(m_fence, m_fenceValue));
        Inc(m_fenceValue);

        // Wait until the previous frame is finished.
        if (lastCompletedFence < fence) then
        begin
            ThrowIfFailed(m_fence.SetEventOnCompletion(fence, m_fenceEvent));
            WaitForSingleObject(m_fenceEvent, INFINITE);
        end;
        CloseHandle(m_fenceEvent);
    end;

    // Close thread events and thread handles.
    for i := 0 to NumContexts - 1 do
    begin
        CloseHandle(m_workerBeginRenderFrame[i]);
        CloseHandle(m_workerFinishShadowPass[i]);
        CloseHandle(m_workerFinishedRenderFrame[i]);
        CloseHandle(m_threadHandles[i]);
    end;

    for i := 0 to Length(m_frameResources) - 1 do
    begin
        m_frameResources[i].Free;
        m_frameResources[i] := nil;
    end;
end;



procedure TD3D12Multithreading.OnKeyDown(key: uint8);
begin
    inherited OnKeyDown(key);
    case (key) of

        VK_LEFT:
            m_keyboardInput.leftArrowPressed := True;

        VK_RIGHT:
            m_keyboardInput.rightArrowPressed := True;

        VK_UP:
            m_keyboardInput.upArrowPressed := True;

        VK_DOWN:
            m_keyboardInput.downArrowPressed := True;

        VK_SPACE:
            m_keyboardInput.animate := not m_keyboardInput.animate;

    end;
end;



procedure TD3D12Multithreading.OnKeyUp(key: uint8);
begin
    inherited OnKeyUp(key);

    case (key) of

        VK_LEFT:
            m_keyboardInput.leftArrowPressed := False;

        VK_RIGHT:
            m_keyboardInput.rightArrowPressed := False;

        VK_UP:
            m_keyboardInput.upArrowPressed := False;

        VK_DOWN:
            m_keyboardInput.downArrowPressed := False;

    end;
end;

end.
