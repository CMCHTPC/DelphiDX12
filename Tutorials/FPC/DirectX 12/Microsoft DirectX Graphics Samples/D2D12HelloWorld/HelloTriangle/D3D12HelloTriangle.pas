//*********************************************************

// Copyright (c) Microsoft. All rights reserved.
// This code is licensed under the MIT License (MIT).
// THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
// IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
// PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.

//*********************************************************
unit D3D12HelloTriangle;

{$mode Delphi}

interface

uses
    Classes, SysUtils, Windows,
    DX12.DXGI1_4,
    DX12.DXGI1_3,
    DX12.DXGI,
    DX12.DXGI1_2,
    DX12.D3D12,
    DX12.D3D12SDKLayers,
    DX12.D3DCommon,
    DX12.D3DX12,
    DX12.D3DCompiler,
    DirectX.Math,
    DXSample;

const
    FrameCount = 2;

// Note that while ComPtr is used to manage the lifetime of resources on the CPU,
// it has no understanding of the lifetime of resources on the GPU. Apps must account
// for the GPU lifetime of resources to avoid destroying objects that may still be
// referenced by the GPU.
// An example of this can be found in the class method: OnDestroy().

type
    TVertex = record
        position: TXMFLOAT3;
        color: TXMFLOAT4;
    end;

    { TD3D12HelloTriangle }

    TD3D12HelloTriangle = class(TDXSample)
    private

        // Pipeline objects.
        m_viewport: TD3D12_VIEWPORT;
        m_scissorRect: TD3D12_RECT;
        m_swapChain: IDXGISwapChain3;
        m_device: ID3D12Device;
        m_renderTargets: array [0..FrameCount - 1] of ID3D12Resource;
        m_commandAllocator: ID3D12CommandAllocator;
        m_commandQueue: ID3D12CommandQueue;
        m_rootSignature: ID3D12RootSignature;
        m_rtvHeap: ID3D12DescriptorHeap;
        m_pipelineState: ID3D12PipelineState;
        m_commandList: ID3D12GraphicsCommandList;
        m_rtvDescriptorSize: UINT;

        // App resources.
        m_vertexBuffer: ID3D12Resource;
        m_vertexBufferView: TD3D12_VERTEX_BUFFER_VIEW;


        // Synchronization objects.
        m_frameIndex: UINT;
        m_fenceEvent: THANDLE;
        m_fence: ID3D12Fence;
        m_fenceValue: uint64;
    private
        procedure LoadPipeline();
        procedure LoadAssets();
        procedure PopulateCommandList();
        procedure WaitForPreviousFrame();
    public
        constructor Create(Width, Height: UINT; Name: WideString);
        destructor Destroy; override;
        procedure OnInit(); override;
        procedure OnUpdate(); override;
        procedure OnRender(); override;
        procedure OnDestroy(); override;
    end;

implementation

uses
    DXSampleHelper, Win32Application;

{ TD3D12HelloTriangle }

// Load the rendering pipeline dependencies.
procedure TD3D12HelloTriangle.LoadPipeline();
var
    dxgiFactoryFlags: UINT;
    factory: IDXGIFactory4;
    hr: HResult;
    queueDesc: TD3D12_COMMAND_QUEUE_DESC;
    debugController: ID3D12Debug;
    warpAdapter: IDXGIAdapter;
    hardwareAdapter: IDXGIAdapter1;
    swapChainDesc: TDXGI_SWAP_CHAIN_DESC1;
    swapChain: IDXGISwapChain1;
    rtvHeapDesc: TD3D12_DESCRIPTOR_HEAP_DESC;
    rtvHandle: TD3D12_CPU_DESCRIPTOR_HANDLE;
    n: UINT;
begin
    dxgiFactoryFlags := 0;

    {$ifdef _DEBUG}
    // Enable the debug layer (requires the Graphics Tools "optional feature").
    // NOTE: Enabling the debug layer after device creation will invalidate the active device.

    if (SUCCEEDED(D3D12GetDebugInterface(IID_ID3D12Debug,debugController)))) then
    begin
        debugController.EnableDebugLayer();
        // Enable additional debug layers.
        dxgiFactoryFlags := dxgiFactoryFlags or DXGI_CREATE_FACTORY_DEBUG;
    end
    {$endif}
    hr := CreateDXGIFactory2(dxgiFactoryFlags, IID_IDXGIFactory4, factory);

    if (m_useWarpDevice) then
    begin
        ThrowIfFailed(factory.EnumWarpAdapter(IID_IDXGIAdapter, warpAdapter));
        ThrowIfFailed(D3D12CreateDevice(warpAdapter, D3D_FEATURE_LEVEL_11_0, IID_ID3D12Device, @m_device));
    end
    else
    begin
        GetHardwareAdapter(factory, hardwareAdapter);
        ThrowIfFailed(D3D12CreateDevice(hardwareAdapter, D3D_FEATURE_LEVEL_11_0, IID_ID3D12Device, @m_device));
    end;

    // Describe and create the command queue.
    ZeroMemory(@queueDesc, SizeOf(queueDesc));
    queueDesc.Flags := D3D12_COMMAND_QUEUE_FLAG_NONE;
    queueDesc._Type := D3D12_COMMAND_LIST_TYPE_DIRECT;

    ThrowIfFailed(m_device.CreateCommandQueue(@queueDesc, IID_ID3D12CommandQueue, m_commandQueue));

    // Describe and create the swap chain.
    ZeroMemory(@swapChainDesc, Sizeof(swapChainDesc));
    swapChainDesc.BufferCount := FrameCount;
    swapChainDesc.Width := m_width;
    swapChainDesc.Height := m_height;
    swapChainDesc.Format := DXGI_FORMAT_R8G8B8A8_UNORM;
    swapChainDesc.BufferUsage := DXGI_USAGE_RENDER_TARGET_OUTPUT;
    swapChainDesc.SwapEffect := DXGI_SWAP_EFFECT_FLIP_DISCARD;
    swapChainDesc.SampleDesc.Count := 1;


    ThrowIfFailed(factory.CreateSwapChainForHwnd(m_commandQueue,        // Swap chain needs the queue so that it can force a flush on it.
        Win32App.GetHwnd(), @swapChainDesc, nil, nil, swapChain));

    // This sample does not support fullscreen transitions.
    ThrowIfFailed(factory.MakeWindowAssociation(Win32App.GetHwnd(), DXGI_MWA_NO_ALT_ENTER));

    swapChain.QueryInterface(IDXGISwapChain3, m_swapChain);

    m_frameIndex := m_swapChain.GetCurrentBackBufferIndex();

    // Create descriptor heaps.

    // Describe and create a render target view (RTV) descriptor heap.
    ZeroMemory(@rtvHeapDesc, SizeOf(rtvHeapDesc));
    rtvHeapDesc.NumDescriptors := FrameCount;
    rtvHeapDesc._Type := D3D12_DESCRIPTOR_HEAP_TYPE_RTV;
    rtvHeapDesc.Flags := D3D12_DESCRIPTOR_HEAP_FLAG_NONE;
    ThrowIfFailed(m_device.CreateDescriptorHeap(@rtvHeapDesc, IID_ID3D12DescriptorHeap, @m_rtvHeap));

    m_rtvDescriptorSize := m_device.GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_RTV);


    // Create frame resources.
    m_rtvHeap.GetCPUDescriptorHandleForHeapStart(rtvHandle);

    // Create a RTV for each frame.
    for  n := 0 to FrameCount - 1 do
    begin
        ThrowIfFailed(m_swapChain.GetBuffer(n, IID_ID3D12Resource, m_renderTargets[n]));
        m_device.CreateRenderTargetView(m_renderTargets[n], nil, rtvHandle);
        rtvHandle.Offset(1, m_rtvDescriptorSize);
    end;

    ThrowIfFailed(m_device.CreateCommandAllocator(D3D12_COMMAND_LIST_TYPE_DIRECT, IID_ID3D12CommandAllocator, m_commandAllocator));

end;


// Load the sample assets.
procedure TD3D12HelloTriangle.LoadAssets();
const
    // Define the vertex input layout.
    inputElementDescs: array [0..1] of TD3D12_INPUT_ELEMENT_DESC = (
        (SemanticName: 'POSITION'; SemanticIndex: 0; Format: DXGI_FORMAT_R32G32B32_FLOAT; InputSlot: 0;
        AlignedByteOffset: 0; InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA; InstanceDataStepRate: 0),
        (SemanticName: 'COLOR'; SemanticIndex: 0; Format: DXGI_FORMAT_R32G32B32A32_FLOAT; InputSlot: 0;
        AlignedByteOffset: 12; InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA; InstanceDataStepRate: 0));
var
    rootSignatureDesc: TD3DX12_ROOT_SIGNATURE_DESC;
    signature: ID3DBlob;
    error: ID3DBlob;
    compileFlags: UINT;
    vertexShader: ID3DBlob;
    pixelShader: ID3DBlob;
    psoDesc: TD3D12_GRAPHICS_PIPELINE_STATE_DESC;
    vertexBufferSize: UINT;
    // Define the geometry for a triangle.
    triangleVertices: array [0..2] of TVertex;

    pVertexDataBegin: pbyte;
    readRange: TD3D12_RANGE;
    hr: HResult;
begin

    // Create an empty root signature.
    ZeroMemory(@rootSignatureDesc, SizeOf(rootSignatureDesc));
    rootSignatureDesc.Init(0, nil, 0, nil, D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT);

    ThrowIfFailed(D3D12SerializeRootSignature(rootSignatureDesc, D3D_ROOT_SIGNATURE_VERSION_1, @signature, @error));
    ThrowIfFailed(m_device.CreateRootSignature(0, signature.GetBufferPointer(), signature.GetBufferSize(),
        IID_ID3D12RootSignature, m_rootSignature));


    // Create the pipeline state, which includes compiling and loading shaders.
{$ifdef _DEBUG}
        // Enable better shader debugging with the graphics debugging tools.
        UINT compileFlags := D3DCOMPILE_DEBUG | D3DCOMPILE_SKIP_OPTIMIZATION;
{$else}
    compileFlags := 0;
{$endif}

    hr := D3DCompileFromFile(pwidechar(GetAssetFullPath('shaders.hlsl')), nil, nil, 'VSMain', 'vs_5_0', compileFlags, 0, vertexShader, error);
    hr := D3DCompileFromFile(pwidechar(GetAssetFullPath('shaders.hlsl')), nil, nil, 'PSMain', 'ps_5_0', compileFlags, 0, pixelShader, error);



    // Describe and create the graphics pipeline state object (PSO).
    ZeroMemory(@psoDesc, SizeOf(psoDesc));
    psoDesc.InputLayout.pInputElementDescs := @inputElementDescs[0];
    psoDesc.InputLayout.NumElements := Length(inputElementDescs);
    psoDesc.pRootSignature := m_rootSignature;
    psoDesc.VS := CD3DX12_SHADER_BYTECODE.Create(vertexShader);
    psoDesc.PS := CD3DX12_SHADER_BYTECODE.Create(pixelShader);
    psoDesc.RasterizerState := CD3DX12_RASTERIZER_DESC.Create(D3D12_DEFAULT);
    psoDesc.BlendState := CD3DX12_BLEND_DESC.Create(D3D12_DEFAULT);
    psoDesc.DepthStencilState.DepthEnable := False;
    psoDesc.DepthStencilState.StencilEnable := False;
    psoDesc.SampleMask := UINT_MAX;
    psoDesc.PrimitiveTopologyType := D3D12_PRIMITIVE_TOPOLOGY_TYPE_TRIANGLE;
    psoDesc.NumRenderTargets := 1;
    psoDesc.RTVFormats[0] := DXGI_FORMAT_R8G8B8A8_UNORM;
    psoDesc.SampleDesc.Count := 1;
    ThrowIfFailed(m_device.CreateGraphicsPipelineState(@psoDesc, IID_ID3D12PipelineState, m_pipelineState));


    // Create the command list.
    ThrowIfFailed(m_device.CreateCommandList(0, D3D12_COMMAND_LIST_TYPE_DIRECT, m_commandAllocator, m_pipelineState,
        IID_ID3D12GraphicsCommandList, m_commandList));

    // Command lists are created in the recording state, but there is nothing
    // to record yet. The main loop expects it to be closed, so close it now.
    ThrowIfFailed(m_commandList.Close());

    // Create the vertex buffer.
    triangleVertices[0].position := TXMFLOAT3.Create(0.0, 0.25 * m_aspectRatio, 0.0);
    triangleVertices[0].color := TXMFLOAT4.Create(1.0, 0.0, 0.0, 1.0);
    triangleVertices[1].position := TXMFLOAT3.Create(0.25, -0.25 * m_aspectRatio, 0.0);
    triangleVertices[1].color := TXMFLOAT4.Create(0.0, 1.0, 0.0, 1.0);
    triangleVertices[2].position := TXMFLOAT3.Create(-0.25, -0.25 * m_aspectRatio, 0.0);
    triangleVertices[2].color := TXMFLOAT4.Create(0.0, 0.0, 1.0, 1.0);


    vertexBufferSize := sizeof(triangleVertices);

    // Note: using upload heaps to transfer static data like vert buffers is not
    // recommended. Every time the GPU needs it, the upload heap will be marshalled
    // over. Please read up on Default Heap usage. An upload heap is used here for
    // code simplicity and because there are very few verts to actually transfer.
    ThrowIfFailed(m_device.CreateCommittedResource(CD3DX12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_UPLOAD),
        D3D12_HEAP_FLAG_NONE, CD3DX12_RESOURCE_DESC.CreateBuffer(vertexBufferSize), D3D12_RESOURCE_STATE_GENERIC_READ,
        nil, IID_ID3D12Resource, m_vertexBuffer));

    // Copy the triangle data to the vertex buffer.

    readRange := CD3DX12_RANGE.Create(0, 0);        // We do not intend to read from this resource on the CPU.
    ThrowIfFailed(m_vertexBuffer.Map(0, @readRange, pVertexDataBegin));
    Move(triangleVertices[0], pVertexDataBegin^, vertexBufferSize);
    m_vertexBuffer.Unmap(0, nil);

    // Initialize the vertex buffer view.
    m_vertexBufferView.BufferLocation := m_vertexBuffer.GetGPUVirtualAddress();
    m_vertexBufferView.StrideInBytes := sizeof(TVertex);
    m_vertexBufferView.SizeInBytes := vertexBufferSize;

    // Create synchronization objects.
    ThrowIfFailed(m_device.CreateFence(0, D3D12_FENCE_FLAG_NONE, IID_ID3D12Fence, m_fence));
    m_fenceValue := 1;

    // Create an event handle to use for frame synchronization.
    m_fenceEvent := CreateEvent(nil, False, False, nil);
    if (m_fenceEvent = 0) then
    begin
        ThrowIfFailed(HRESULT_FROM_WIN32(GetLastError()));
    end;


    // Wait for the command list to execute; we are reusing the same command
    // list in our main loop but for now, we just want to wait for setup to
    // complete before continuing.
    WaitForPreviousFrame();

end;



procedure TD3D12HelloTriangle.PopulateCommandList();
const
    clearColor: TSingleArray4 = (0.0, 0.2, 0.4, 1.0);
var
    rtvHandle: CD3DX12_CPU_DESCRIPTOR_HANDLE;
begin
    // Command list allocators can only be reset when the associated
    // command lists have finished execution on the GPU; apps should use
    // fences to determine GPU execution progress.
    ThrowIfFailed(m_commandAllocator.Reset());

    // However, when ExecuteCommandList() is called on a particular command
    // list, that command list can then be reset at any time and must be before
    // re-recording.
    ThrowIfFailed(m_commandList.Reset(m_commandAllocator, m_pipelineState));

    // Set necessary state.
    m_commandList.SetGraphicsRootSignature(m_rootSignature);
    m_commandList.RSSetViewports(1, @m_viewport);
    m_commandList.RSSetScissorRects(1, @m_scissorRect);

    // Indicate that the back buffer will be used as a render target.
    m_commandList.ResourceBarrier(1, TD3D12_RESOURCE_BARRIER.CreateTransition(m_renderTargets[m_frameIndex],
        D3D12_RESOURCE_STATE_PRESENT, D3D12_RESOURCE_STATE_RENDER_TARGET));

    m_rtvHeap.GetCPUDescriptorHandleForHeapStart(rtvHandle);
    rtvHandle := CD3DX12_CPU_DESCRIPTOR_HANDLE.Create(rtvHandle, m_frameIndex, m_rtvDescriptorSize);
    m_commandList.OMSetRenderTargets(1, @rtvHandle, False, nil);

    // Record commands.

    m_commandList.ClearRenderTargetView(rtvHandle, clearColor, 0, nil);
    m_commandList.IASetPrimitiveTopology(D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
    m_commandList.IASetVertexBuffers(0, 1, @m_vertexBufferView);
    m_commandList.DrawInstanced(3, 1, 0, 0);

    // Indicate that the back buffer will now be used to present.
    m_commandList.ResourceBarrier(1, TD3D12_RESOURCE_BARRIER.CreateTransition(m_renderTargets[m_frameIndex],
        D3D12_RESOURCE_STATE_RENDER_TARGET, D3D12_RESOURCE_STATE_PRESENT));

    ThrowIfFailed(m_commandList.Close());
end;



procedure TD3D12HelloTriangle.WaitForPreviousFrame();
var
    fence: uint64;
    hr: HResult;
begin
    // WAITING FOR THE FRAME TO COMPLETE BEFORE CONTINUING IS NOT BEST PRACTICE.
    // This is code implemented as such for simplicity. The D3D12HelloFrameBuffering
    // sample illustrates how to use fences for efficient resource usage and to
    // maximize GPU utilization.

    // Signal and increment the fence value.
    fence := m_fenceValue;
    hr := m_commandQueue.Signal(m_fence, fence);
    Inc(m_fenceValue);

    // Wait until the previous frame is finished.
    if (m_fence.GetCompletedValue() < fence) then
    begin
        hr := m_fence.SetEventOnCompletion(fence, m_fenceEvent);
        WaitForSingleObject(m_fenceEvent, INFINITE);
    end;

    m_frameIndex := m_swapChain.GetCurrentBackBufferIndex();
end;



constructor TD3D12HelloTriangle.Create(Width, Height: UINT; Name: WideString);
begin
    inherited Create(Width, Height, Name);
    m_frameIndex := 0;
    m_rtvDescriptorSize := 0;


    m_viewport := TD3D12_VIEWPORT.Create(0.0, 0.0, Width, Height);
    m_scissorRect := TD3D12_RECT.Create(0, 0, Width, Height);

end;



destructor TD3D12HelloTriangle.Destroy;
begin
    inherited Destroy;
end;



procedure TD3D12HelloTriangle.OnInit();
begin
    LoadPipeline();
    LoadAssets();
end;



// Update frame-based values.
procedure TD3D12HelloTriangle.OnUpdate();
begin

end;


// Render the scene.
procedure TD3D12HelloTriangle.OnRender();
var
    ppCommandLists: array[0..0] of ID3D12CommandList;
begin
    // Record all the commands we need to render the scene into the command list.
    PopulateCommandList();

    // Execute the command list.
    ppCommandLists[0] := m_commandList;
    m_commandQueue.ExecuteCommandLists(Length(ppCommandLists), @ppCommandLists[0]);
    // Present the frame.
    ThrowIfFailed(m_swapChain.Present(1, 0));

    WaitForPreviousFrame();
end;



procedure TD3D12HelloTriangle.OnDestroy();
begin
    // Ensure that the GPU is no longer referencing resources that are about to be
    // cleaned up by the destructor.
    WaitForPreviousFrame();
    CloseHandle(m_fenceEvent);
end;

end.
