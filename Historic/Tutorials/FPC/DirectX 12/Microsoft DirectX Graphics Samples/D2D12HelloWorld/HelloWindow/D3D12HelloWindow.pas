//*********************************************************

// Copyright (c) Microsoft. All rights reserved.
// This code is licensed under the MIT License (MIT).
// THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
// IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
// PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.

//*********************************************************
unit D3D12HelloWindow;

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
    DXSample;

const
    FrameCount = 2;

// Note that while ComPtr is used to manage the lifetime of resources on the CPU,
// it has no understanding of the lifetime of resources on the GPU. Apps must account
// for the GPU lifetime of resources to avoid destroying objects that may still be
// referenced by the GPU.
// An example of this can be found in the class method: OnDestroy().

type

    { TD3D12HelloWindow }

    TD3D12HelloWindow = class(TDXSample)
    private

        // Pipeline objects.
        m_swapChain: IDXGISwapChain3;
        m_device: ID3D12Device;
        m_renderTargets: array [0..FrameCount - 1] of ID3D12Resource;
        m_commandAllocator: ID3D12CommandAllocator;
        m_commandQueue: ID3D12CommandQueue;
        m_rtvHeap: ID3D12DescriptorHeap;
        m_pipelineState: ID3D12PipelineState;
        m_commandList: ID3D12GraphicsCommandList;
        m_rtvDescriptorSize: UINT;

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

{ TD3D12HelloWindow }

// Load the rendering pipeline dependencies.
procedure TD3D12HelloWindow.LoadPipeline();
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
    rtvHandle: CD3DX12_CPU_DESCRIPTOR_HANDLE;
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
procedure TD3D12HelloWindow.LoadAssets();
begin
    // Create the command list.
    ThrowIfFailed(m_device.CreateCommandList(0, D3D12_COMMAND_LIST_TYPE_DIRECT, m_commandAllocator, nil,
        IID_ID3D12GraphicsCommandList, m_commandList));

    // Command lists are created in the recording state, but there is nothing
    // to record yet. The main loop expects it to be closed, so close it now.
    ThrowIfFailed(m_commandList.Close());

    // Create synchronization objects.
    begin
        ThrowIfFailed(m_device.CreateFence(0, D3D12_FENCE_FLAG_NONE, IID_ID3D12Fence, m_fence));
        m_fenceValue := 1;

        // Create an event handle to use for frame synchronization.
        m_fenceEvent := CreateEvent(nil, False, False, nil);
        if (m_fenceEvent = 0) then
        begin
            ThrowIfFailed(HRESULT_FROM_WIN32(GetLastError()));
        end;
    end;
end;



procedure TD3D12HelloWindow.PopulateCommandList();
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

    // Indicate that the back buffer will be used as a render target.
    m_commandList.ResourceBarrier(1, CD3DX12_RESOURCE_BARRIER.CreateTransition(m_renderTargets[m_frameIndex],
        D3D12_RESOURCE_STATE_PRESENT, D3D12_RESOURCE_STATE_RENDER_TARGET));

    m_rtvHeap.GetCPUDescriptorHandleForHeapStart(rtvHandle);
    rtvHandle := CD3DX12_CPU_DESCRIPTOR_HANDLE.Create(rtvHandle, m_frameIndex, m_rtvDescriptorSize);

    // Record commands.

    m_commandList.ClearRenderTargetView(rtvHandle, clearColor, 0, nil);

    // Indicate that the back buffer will now be used to present.
    m_commandList.ResourceBarrier(1, CD3DX12_RESOURCE_BARRIER.CreateTransition(m_renderTargets[m_frameIndex],
        D3D12_RESOURCE_STATE_RENDER_TARGET, D3D12_RESOURCE_STATE_PRESENT));

    ThrowIfFailed(m_commandList.Close());
end;



procedure TD3D12HelloWindow.WaitForPreviousFrame();
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



constructor TD3D12HelloWindow.Create(Width, Height: UINT; Name: WideString);
begin
    inherited Create(Width, Height, Name);
    m_frameIndex := 0;
    m_rtvDescriptorSize := 0;
end;



destructor TD3D12HelloWindow.Destroy;
begin
    inherited Destroy;
end;



procedure TD3D12HelloWindow.OnInit();
begin
    LoadPipeline();
    LoadAssets();
end;



// Update frame-based values.
procedure TD3D12HelloWindow.OnUpdate();
begin

end;


// Render the scene.
procedure TD3D12HelloWindow.OnRender();
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



procedure TD3D12HelloWindow.OnDestroy();
begin
    // Ensure that the GPU is no longer referencing resources that are about to be
    // cleaned up by the destructor.
    WaitForPreviousFrame();

    CloseHandle(m_fenceEvent);
end;

end.
