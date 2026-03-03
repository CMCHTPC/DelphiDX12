unit D3DClass;

{$mode delphi}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3DCommon,
    DX12.D3D12,
    DX12.DXGI,
    DX12.DXGI1_4,
    DX12.D3DCompiler;

type

    { TD3DClass }

    TD3DClass = class(TObject)
    private
        m_vsync_enabled: boolean;
        m_device: ID3D12Device;
        m_commandQueue: ID3D12CommandQueue;
        m_videoCardMemory: integer;
        m_videoCardDescription: array[0..127] of char;
        m_swapChain: IDXGISwapChain3;
        m_renderTargetViewHeap: ID3D12DescriptorHeap;
        m_backBufferRenderTarget: array[0..1] of ID3D12Resource;
        m_bufferIndex: uint;
        m_commandAllocator: ID3D12CommandAllocator;
        m_commandList: ID3D12GraphicsCommandList;
        m_pipelineState: ID3D12PipelineState;
        m_fence: ID3D12Fence;
        m_fenceEvent: THANDLE;
        m_fenceValue: Ulonglong;
    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(screenHeight, screenWidth: integer; Handle: HWND; vsync, fullscreen: boolean): boolean;
        procedure Shutdown();

        function Render(): boolean;
    end;

function CreateEventExW(lpEventAttributes: LPSECURITY_ATTRIBUTES; lpName: LPCWSTR; dwFlags: DWORD; dwDesiredAccess: DWORD): HANDLE;
    stdcall; external 'Kernel32.dll';

implementation

{ TD3DClass }

constructor TD3DClass.Create;
begin
    m_device := nil;
    m_commandQueue := nil;
    m_swapChain := nil;
    m_renderTargetViewHeap := nil;
    m_backBufferRenderTarget[0] := nil;
    m_backBufferRenderTarget[1] := nil;
    m_commandAllocator := nil;
    m_commandList := nil;
    m_pipelineState := nil;
    m_fence := nil;
    m_fenceEvent := 0;
end;



destructor TD3DClass.Destroy;
begin
    inherited Destroy;
end;



function TD3DClass.Initialize(screenHeight, screenWidth: integer; Handle: HWND; vsync, fullscreen: boolean): boolean;
var
    featureLevel: TD3D_FEATURE_LEVEL;
    hr: HRESULT;
    commandQueueDesc: TD3D12_COMMAND_QUEUE_DESC;
    factory: IDXGIFactory4;
    adapter: IDXGIAdapter;
    adapterOutput: IDXGIOutput;
    numModes, i, numerator, denominator, renderTargetViewDescriptorSize: uint;
    stringLength: ulonglong;
    displayModeList: array of TDXGI_MODE_DESC;
    adapterDesc: TDXGI_ADAPTER_DESC;
    error: integer;
    swapChainDesc: TDXGI_SWAP_CHAIN_DESC;
    swapChain: IDXGISwapChain;
    renderTargetViewHeapDesc: TD3D12_DESCRIPTOR_HEAP_DESC;
    renderTargetViewHandle: TD3D12_CPU_DESCRIPTOR_HANDLE;
begin

    // Store the vsync setting.
    m_vsync_enabled := vsync;

    // Set the feature level to DirectX 12.1 to enable using all the DirectX 12 features.
    // Note: Not all cards support full DirectX 12, this feature level may need to be reduced on some cards to 12.0.
    featureLevel := D3D_FEATURE_LEVEL_12_1;

    // Create the Direct3D 12 device.
    hr := D3D12CreateDevice(nil, featureLevel, IID_ID3D12Device, m_device);
    if (FAILED(hr)) then
    begin
        MessageBox(Handle, 'Could not create a DirectX 12.1 device.  The default video card does not support DirectX 12.1.',
            'DirectX Device Failure', MB_OK);
        Result := False;
        Exit;
    end;

    // Initialize the description of the command queue.
    ZeroMemory(@commandQueueDesc, sizeof(commandQueueDesc));

    // Set up the description of the command queue.
    commandQueueDesc._Type := D3D12_COMMAND_LIST_TYPE_DIRECT;
    commandQueueDesc.Priority := D3D12_COMMAND_QUEUE_PRIORITY_NORMAL;
    commandQueueDesc.Flags := D3D12_COMMAND_QUEUE_FLAG_NONE;
    commandQueueDesc.NodeMask := 0;

    // Create the command queue.
    hr := m_device.CreateCommandQueue(commandQueueDesc, IID_ID3D12CommandQueue, m_commandQueue);
    if (FAILED(hr)) then
    begin
        Result := False;
        Exit;
    end;

    // Create a DirectX graphics interface factory.
    hr := CreateDXGIFactory1(IID_IDXGIFactory4, factory);
    if (FAILED(hr)) then
    begin
        Result := False;
        Exit;
    end;

    // Use the factory to create an adapter for the primary graphics interface (video card).
    hr := factory.EnumAdapters(0, adapter);
    if (FAILED(hr)) then
    begin
        Result := False;
        Exit;
    end;

    // Enumerate the primary adapter output (monitor).
    hr := adapter.EnumOutputs(0, adapterOutput);
    if (FAILED(hr)) then
    begin
        Result := False;
        Exit;
    end;

    // Get the number of modes that fit the DXGI_FORMAT_R8G8B8A8_UNORM display format for the adapter output (monitor).
    hr := adapterOutput.GetDisplayModeList(DXGI_FORMAT_R8G8B8A8_UNORM, DXGI_ENUM_MODES_INTERLACED, numModes, nil);
    if (FAILED(hr)) then
    begin
        Result := False;
        Exit;
    end;

    // Create a list to hold all the possible display modes for this monitor/video card combination.
    SetLength(displayModeList, numModes);

    // Now fill the display mode list structures.
    hr := adapterOutput.GetDisplayModeList(DXGI_FORMAT_R8G8B8A8_UNORM, DXGI_ENUM_MODES_INTERLACED, numModes, @displayModeList[0]);
    if (FAILED(hr)) then
    begin
        Result := False;
        Exit;
    end;

    // Now go through all the display modes and find the one that matches the screen height and width.
    // When a match is found store the numerator and denominator of the refresh rate for that monitor.
    for i := 0 to numModes - 1 do
    begin
        if (displayModeList[i].Height = screenHeight) then
        begin
            if (displayModeList[i].Width = screenWidth) then
            begin
                numerator := displayModeList[i].RefreshRate.Numerator;
                denominator := displayModeList[i].RefreshRate.Denominator;
            end;
        end;
    end;

    // Get the adapter (video card) description.
    hr := adapter.GetDesc(adapterDesc);
    if (FAILED(hr)) then
    begin
        Result := False;
        Exit;
    end;

    // Store the dedicated video card memory in megabytes.
    m_videoCardMemory := trunc(adapterDesc.DedicatedVideoMemory / 1024 / 1024);

    // Convert the name of the video card to a character array and store it.
    error := 0;
    //    error := wcstombs_s(&stringLength, m_videoCardDescription, 128, adapterDesc.Description, 128);
    if (error <> 0) then
    begin
        Result := False;
        Exit;
    end;

    // Release the display mode list.
    SetLength(displayModeList, 0);

    // Release the adapter output.
    adapterOutput := nil;

    // Release the adapter.
    adapter := nil;

    // Initialize the swap chain description.
    ZeroMemory(@swapChainDesc, sizeof(swapChainDesc));

    // Set the swap chain to use double buffering.
    swapChainDesc.BufferCount := 2;

    // Set the height and width of the back buffers in the swap chain.
    swapChainDesc.BufferDesc.Height := screenHeight;
    swapChainDesc.BufferDesc.Width := screenWidth;

    // Set a regular 32-bit surface for the back buffers.
    swapChainDesc.BufferDesc.Format := DXGI_FORMAT_R8G8B8A8_UNORM;

    // Set the usage of the back buffers to be render target outputs.
    swapChainDesc.BufferUsage := DXGI_USAGE_RENDER_TARGET_OUTPUT;

    // Set the swap effect to discard the previous buffer contents after swapping.
    swapChainDesc.SwapEffect := DXGI_SWAP_EFFECT_FLIP_DISCARD;

    // Set the handle for the window to render to.
    swapChainDesc.OutputWindow := Handle;

    // Set to full screen or windowed mode.
    if (fullscreen) then
    begin
        swapChainDesc.Windowed := False;
    end
    else
    begin
        swapChainDesc.Windowed := True;
    end;

    // Set the refresh rate of the back buffer.
    if (m_vsync_enabled) then
    begin
        swapChainDesc.BufferDesc.RefreshRate.Numerator := numerator;
        swapChainDesc.BufferDesc.RefreshRate.Denominator := denominator;
    end
    else
    begin
        swapChainDesc.BufferDesc.RefreshRate.Numerator := 0;
        swapChainDesc.BufferDesc.RefreshRate.Denominator := 1;
    end;

    // Turn multisampling off.
    swapChainDesc.SampleDesc.Count := 1;
    swapChainDesc.SampleDesc.Quality := 0;

    // Set the scan line ordering and scaling to unspecified.
    swapChainDesc.BufferDesc.ScanlineOrdering := DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED;
    swapChainDesc.BufferDesc.Scaling := DXGI_MODE_SCALING_UNSPECIFIED;

    // Don't set the advanced flags.
    swapChainDesc.Flags := 0;

    // Finally create the swap chain using the swap chain description.
    hr := factory.CreateSwapChain(m_commandQueue, @swapChainDesc, swapChain);
    if (FAILED(hr)) then
    begin
        Result := False;
        Exit;
    end;

    // Next upgrade the IDXGISwapChain to a IDXGISwapChain3 interface and store it in a private member variable named m_swapChain.
    // This will allow us to use the newer functionality such as getting the current back buffer index.
    hr := swapChain.QueryInterface(IID_IDXGISwapChain3, m_swapChain);
    if (FAILED(hr)) then
    begin
        Result := False;
        Exit;
    end;

    // Clear pointer to original swap chain interface since we are using version 3 instead (m_swapChain).
    swapChain := nil;

    // Release the factory now that the swap chain has been created.
    factory := nil;

    // Initialize the render target view heap description for the two back buffers.
    ZeroMemory(@renderTargetViewHeapDesc, sizeof(renderTargetViewHeapDesc));

    // Set the number of descriptors to two for our two back buffers.  Also set the heap tyupe to render target views.
    renderTargetViewHeapDesc.NumDescriptors := 2;
    renderTargetViewHeapDesc._Type := D3D12_DESCRIPTOR_HEAP_TYPE_RTV;
    renderTargetViewHeapDesc.Flags := D3D12_DESCRIPTOR_HEAP_FLAG_NONE;

    // Create the render target view heap for the back buffers.
    hr := m_device.CreateDescriptorHeap(renderTargetViewHeapDesc, IID_ID3D12DescriptorHeap, m_renderTargetViewHeap);
    if (FAILED(hr)) then
    begin
        Result := False;
        Exit;
    end;

    // Get a handle to the starting memory location in the render target view heap to identify where the render target views will be located for the two back buffers.
    renderTargetViewHandle := m_renderTargetViewHeap.GetCPUDescriptorHandleForHeapStart();

    // Get the size of the memory location for the render target view descriptors.
    renderTargetViewDescriptorSize := m_device.GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_RTV);

    // Get a pointer to the first back buffer from the swap chain.
    hr := m_swapChain.GetBuffer(0, IID_ID3D12Resource, m_backBufferRenderTarget[0]);
    if (FAILED(hr)) then
    begin
        Result := False;
        Exit;
    end;

    // Create a render target view for the first back buffer.
    m_device.CreateRenderTargetView(m_backBufferRenderTarget[0], nil, renderTargetViewHandle);

    // Increment the view handle to the next descriptor location in the render target view heap.
    renderTargetViewHandle.ptr += renderTargetViewDescriptorSize;

    // Get a pointer to the second back buffer from the swap chain.
    hr := m_swapChain.GetBuffer(1, IID_ID3D12Resource, m_backBufferRenderTarget[1]);
    if (FAILED(hr)) then
    begin
        Result := False;
        Exit;
    end;

    // Create a render target view for the second back buffer.
    m_device.CreateRenderTargetView(m_backBufferRenderTarget[1], nil, renderTargetViewHandle);

    // Finally get the initial index to which buffer is the current back buffer.
    m_bufferIndex := m_swapChain.GetCurrentBackBufferIndex();

    // Create a command allocator.
    hr := m_device.CreateCommandAllocator(D3D12_COMMAND_LIST_TYPE_DIRECT, IID_ID3D12CommandAllocator, m_commandAllocator);
    if (FAILED(hr)) then
    begin
        Result := False;
        Exit;
    end;

    // Create a basic command list.
    hr := m_device.CreateCommandList(0, D3D12_COMMAND_LIST_TYPE_DIRECT, m_commandAllocator, nil, IID_ID3D12GraphicsCommandList, m_commandList);
    if (FAILED(hr)) then
    begin
        Result := False;
        Exit;
    end;

    // Initially we need to close the command list during initialization as it is created in a recording state.
    hr := m_commandList.Close();
    if (FAILED(hr)) then
    begin
        Result := False;
        Exit;
    end;

    // Create a fence for GPU synchronization.
    hr := m_device.CreateFence(0, D3D12_FENCE_FLAG_NONE, IID_ID3D12Fence, m_fence);
    if (FAILED(hr)) then
    begin
        Result := False;
        Exit;
    end;

    // Create an event object for the fence.
    m_fenceEvent := CreateEventExW(0, 0, 0, EVENT_ALL_ACCESS);
    if (m_fenceEvent = 0) then
    begin
        Result := False;
        Exit;
    end;

    // Initialize the starting fence value.
    m_fenceValue := 1;

    Result := True;

end;



procedure TD3DClass.Shutdown();
var
    error: winbool;
begin

    // Before shutting down set to windowed mode or when you release the swap chain it will throw an exception.
    if (m_swapChain <> nil) then
    begin
        m_swapChain.SetFullscreenState(False, nil);
    end;

    // Close the object handle to the fence event.
    error := CloseHandle(m_fenceEvent);

    // Release the fence.
    if (m_fence <> nil) then
        m_fence := nil;

    // Release the empty pipe line state.
    if (m_pipelineState <> nil) then
        m_pipelineState := nil;

    // Release the command list.
    if (m_commandList <> nil) then
        m_commandList := nil;

    // Release the command allocator.
    if (m_commandAllocator <> nil) then
        m_commandAllocator := nil;

    // Release the back buffer render target views.
    if (m_backBufferRenderTarget[0] <> nil) then
        m_backBufferRenderTarget[0] := nil;

    if (m_backBufferRenderTarget[1] <> nil) then
        m_backBufferRenderTarget[1] := nil;

    // Release the render target view heap.
    if (m_renderTargetViewHeap <> nil) then
        m_renderTargetViewHeap := nil;
    // Release the swap chain.
    if (m_swapChain <> nil) then
        m_swapChain := nil;

    // Release the command queue.
    if (m_commandQueue <> nil) then

        m_commandQueue := nil;

    // Release the device.
    if (m_device <> nil) then
        m_device := nil;

end;



function TD3DClass.Render(): boolean;
var
    hr: Hresult;
    barrier: TD3D12_RESOURCE_BARRIER;
    renderTargetViewHandle: TD3D12_CPU_DESCRIPTOR_HANDLE;
    renderTargetViewDescriptorSize: uint;
    color: array [0..3] of single;
    ppCommandLists: array [0..0] of ID3D12CommandList;
    fenceToWaitFor: ulonglong;
begin

    Result := False;

    // Reset (re-use) the memory associated command allocator.
    hr := m_commandAllocator.Reset();
    if (FAILED(hr)) then
        Exit;

    // Reset the command list, use empty pipeline state for now since there are no shaders and we are just clearing the screen.
    hr := m_commandList.Reset(m_commandAllocator, m_pipelineState);
    if (FAILED(hr)) then
        Exit;

    // Record commands in the command list now.
    // Start by setting the resource barrier.
    barrier.Flags := D3D12_RESOURCE_BARRIER_FLAG_NONE;
    barrier._Transition.pResource := m_backBufferRenderTarget[m_bufferIndex];
    barrier._Transition.StateBefore := D3D12_RESOURCE_STATE_PRESENT;
    barrier._Transition.StateAfter := D3D12_RESOURCE_STATE_RENDER_TARGET;
    barrier._Transition.Subresource := D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
    barrier._Type := D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
    m_commandList.ResourceBarrier(1, @barrier);

    // Get the render target view handle for the current back buffer.
    renderTargetViewHandle := m_renderTargetViewHeap.GetCPUDescriptorHandleForHeapStart();
    renderTargetViewDescriptorSize := m_device.GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_RTV);
    if (m_bufferIndex = 1) then
    begin
        renderTargetViewHandle.ptr += renderTargetViewDescriptorSize;
    end;

    // Set the back buffer as the render target.
    m_commandList.OMSetRenderTargets(1, @renderTargetViewHandle, False, nil);

    // Then set the color to clear the window to.
    color[0] := 0.5;
    color[1] := 0.5;
    color[2] := 0.5;
    color[3] := 1.0;
    m_commandList.ClearRenderTargetView(renderTargetViewHandle, TSingleArray4(color), 0, nil);

    // Indicate that the back buffer will now be used to present.
    barrier._Transition.StateBefore := D3D12_RESOURCE_STATE_RENDER_TARGET;
    barrier._Transition.StateAfter := D3D12_RESOURCE_STATE_PRESENT;
    m_commandList.ResourceBarrier(1, @barrier);

    // Close the list of commands.
    hr := m_commandList.Close();
    if (FAILED(hr)) then
        Exit;

    // Load the command list array (only one command list for now).
    ppCommandLists[0] := m_commandList;

    // Execute the list of commands.
    m_commandQueue.ExecuteCommandLists(1, @ppCommandLists[0]);

    // Finally present the back buffer to the screen since rendering is complete.
    if (m_vsync_enabled) then
    begin
        // Lock to screen refresh rate.
        hr := m_swapChain.Present(1, 0);
        if (FAILED(hr)) then
            Exit;
    end
    else
    begin
        // Present as fast as possible.
        hr := m_swapChain.Present(0, 0);
        if (FAILED(hr)) then
            Exit;
    end;

    // Signal and increment the fence value.
    fenceToWaitFor := m_fenceValue;
    hr := m_commandQueue.Signal(m_fence, fenceToWaitFor);
    if (FAILED(hr)) then
        Exit;
    Inc(m_fenceValue);

    // Wait until the GPU is done rendering.
    if (m_fence.GetCompletedValue() < fenceToWaitFor) then
    begin
        hr := m_fence.SetEventOnCompletion(fenceToWaitFor, m_fenceEvent);
        if (FAILED(hr)) then
            Exit;
        WaitForSingleObject(m_fenceEvent, INFINITE);
    end;

    // Alternate the back buffer index back and forth between 0 and 1 each frame.
    if (m_bufferIndex = 0) then
        m_bufferIndex := 1
    else
        m_bufferIndex := 0;

    Result := True;

end;

end.
