program Tut03;

uses
  MultiMon,
  SysUtils,
  Windows,
  Messages,
  DX12.D2D1 in '..\..\..\..\..\Units\DX12.D2D1.pas',
  DX12.D2D1_3 in '..\..\..\..\..\Units\DX12.D2D1_3.pas',
  DX12.D2D1EffectAuthor_1 in '..\..\..\..\..\Units\DX12.D2D1EffectAuthor_1.pas',
  DX12.D2D1Effects2 in '..\..\..\..\..\Units\DX12.D2D1Effects2.pas',
  DX12.D2D1SVG in '..\..\..\..\..\Units\DX12.D2D1SVG.pas',
  DX12.D3D9Types in '..\..\..\..\..\Units\DX12.D3D9Types.pas',
  DX12.D3D10 in '..\..\..\..\..\Units\DX12.D3D10.pas',
  DX12.D3D10_1 in '..\..\..\..\..\Units\DX12.D3D10_1.pas',
  DX12.D3D11 in '..\..\..\..\..\Units\DX12.D3D11.pas',
  DX12.D3D11_1 in '..\..\..\..\..\Units\DX12.D3D11_1.pas',
  DX12.D3D11_2 in '..\..\..\..\..\Units\DX12.D3D11_2.pas',
  DX12.D3D11_3 in '..\..\..\..\..\Units\DX12.D3D11_3.pas',
  DX12.D3D11_4 in '..\..\..\..\..\Units\DX12.D3D11_4.pas',
  DX12.D3D11On12 in '..\..\..\..\..\Units\DX12.D3D11On12.pas',
  DX12.D3D12 in '..\..\..\..\..\Units\DX12.D3D12.pas',
  DX12.D3D12SDKLayers in '..\..\..\..\..\Units\DX12.D3D12SDKLayers.pas',
  DX12.D3D12Shader in '..\..\..\..\..\Units\DX12.D3D12Shader.pas',
  DX12.D3D12Video in '..\..\..\..\..\Units\DX12.D3D12Video.pas',
  DX12.D3DCommon in '..\..\..\..\..\Units\DX12.D3DCommon.pas',
  DX12.D3DCompiler in '..\..\..\..\..\Units\DX12.D3DCompiler.pas',
  DX12.D3DCSX in '..\..\..\..\..\Units\DX12.D3DCSX.pas',
  DX12.D3DUKMDT in '..\..\..\..\..\Units\DX12.D3DUKMDT.pas',
  DX12.D3DX10 in '..\..\..\..\..\Units\DX12.D3DX10.pas',
  DX12.D3DX11 in '..\..\..\..\..\Units\DX12.D3DX11.pas',
  DX12.D3DX11Effect in '..\..\..\..\..\Units\DX12.D3DX11Effect.pas',
  dx12.d3dx12 in '..\..\..\..\..\Units\dx12.d3dx12.pas',
  DX12.DCommon in '..\..\..\..\..\Units\DX12.DCommon.pas',
  DX12.DComp in '..\..\..\..\..\Units\DX12.DComp.pas',
  DX12.DCompAnimation in '..\..\..\..\..\Units\DX12.DCompAnimation.pas',
  DX12.DCompTypes in '..\..\..\..\..\Units\DX12.DCompTypes.pas',
  DX12.DocumentTarget in '..\..\..\..\..\Units\DX12.DocumentTarget.pas',
  DX12.DWrite in '..\..\..\..\..\Units\DX12.DWrite.pas',
  DX12.DWrite3 in '..\..\..\..\..\Units\DX12.DWrite3.pas',
  DX12.DXGI in '..\..\..\..\..\Units\DX12.DXGI.pas',
  DX12.DXGI1_2 in '..\..\..\..\..\Units\DX12.DXGI1_2.pas',
  DX12.DXGI1_3 in '..\..\..\..\..\Units\DX12.DXGI1_3.pas',
  DX12.DXGI1_4 in '..\..\..\..\..\Units\DX12.DXGI1_4.pas',
  DX12.DXGI1_5 in '..\..\..\..\..\Units\DX12.DXGI1_5.pas',
  DX12.DXGI1_6 in '..\..\..\..\..\Units\DX12.DXGI1_6.pas',
  DX12.DXGIDebug in '..\..\..\..\..\Units\DX12.DXGIDebug.pas',
  DX12.DXGIMessages in '..\..\..\..\..\Units\DX12.DXGIMessages.pas',
  DX12.DXProgrammableCapture in '..\..\..\..\..\Units\DX12.DXProgrammableCapture.pas',
  DX12.OCIdl in '..\..\..\..\..\Units\DX12.OCIdl.pas',
  DX12.WinCodec in '..\..\..\..\..\Units\DX12.WinCodec.pas',
  DX12.Xinput in '..\..\..\..\..\Units\DX12.Xinput.pas';

{$R *.res}

const
    // name of the window (not the title)
    WindowName: WideString = 'BzTutsApp';

    // title of the window
    WindowTitle: WideString = 'Bz Window';

const
    frameBufferCount = 3; // number of buffers we want, 2 for double buffering, 3 for tripple buffering

var
    // Handle to the window
    Handle: HWnd = 0;
    Running: boolean = True;

    // width and height of the window
    Width: integer = 800;
    Height: integer = 600;

    // is window full screen?
    FullScreen: boolean = False;

    // direct3d stuff
    device: ID3D12Device; // direct3d device
    swapChain: IDXGISwapChain3; // swapchain used to switch between render targets
    commandQueue: ID3D12CommandQueue; // container for command lists
    rtvDescriptorHeap: ID3D12DescriptorHeap; // a descriptor heap to hold resources like the render targets
    renderTargets: array [0..frameBufferCount - 1] of ID3D12Resource; // number of render targets equal to buffer count
    commandAllocator: array [0..frameBufferCount - 1] of ID3D12CommandAllocator;
    // we want enough allocators for each buffer * number of threads (we only have one thread)
    commandList: ID3D12GraphicsCommandList; // a command list we can record commands into, then execute them to render the frame
    fence: array [0..frameBufferCount - 1] of ID3D12Fence;
    // an object that is locked while our command list is being executed by the gpu. We need as many
    //as we have allocators (more if we want to know when the gpu is finished with an asset)
    fenceEvent: THANDLE; // a handle to an event when our fence is unlocked by the gpu
    fenceValue: array [0..frameBufferCount - 1] of UINT64; // this value is incremented each frame. each fence will have its own value
    frameIndex: integer; // current rtv we are on
    rtvDescriptorSize: integer; // size of the rtv descriptor on the device (all front and back buffers will be the same size)



    procedure Safe_Release(var i);
    begin
        if IUnknown(i) <> nil then
            IUnknown(i) := nil;
    end;



    function WndProc(Handle: HWND; msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
    begin
        case (msg) of
            WM_KEYDOWN:
            begin
                if (wParam = VK_ESCAPE) then
                begin
                    if (MessageBox(0, 'Are you sure you want to exit?', 'Really?', MB_YESNO or MB_ICONQUESTION) = idYes) then
                    begin
                        Running := False;
                        DestroyWindow(Handle);
                    end;
                end;
                Result := 0;
            end;

            WM_DESTROY:
            begin
                Running := False;
                PostQuitMessage(0);
                Result := 0;
            end
            else
                Result := DefWindowProc(Handle, msg, wParam, lParam);
        end;
    end;



    function InitializeWindow(Instance: DWord; ShowWnd: integer; Width: integer; Height: integer; fullscreen: boolean): boolean;
    var
        hMon: HMonitor;
        mi: TMONITORINFO;
        wc: WNDCLASSEXW;
    begin
        Result := False;
        if (fullscreen) then
        begin
            hmon := MonitorFromWindow(Handle, MONITOR_DEFAULTTONEAREST);
            mi.cbSize := sizeof(mi);
            GetMonitorInfo(hmon, @mi);

            Width := mi.rcMonitor.right - mi.rcMonitor.left;
            Height := mi.rcMonitor.bottom - mi.rcMonitor.top;
        end;

        wc.cbSize := sizeof(WNDCLASSEXW);
        wc.style := CS_HREDRAW or CS_VREDRAW;
        wc.lpfnWndProc := @WndProc;
        wc.cbClsExtra := 0;
        wc.cbWndExtra := 0;
        wc.hInstance := hInstance;
        wc.hIcon := LoadIcon(0, IDI_APPLICATION);
        wc.hCursor := LoadCursor(0, IDC_ARROW);
        wc.hbrBackground := (COLOR_WINDOW + 2);
        wc.lpszMenuName := nil;
        wc.lpszClassName := PWideChar(WindowName);
        wc.hIconSm := LoadIcon(0, IDI_APPLICATION);

        if (RegisterClassExW(wc) = 0) then
        begin
            MessageBox(0, 'Error registering class', 'Error', MB_OK or MB_ICONERROR);
            Exit;
        end;

        Handle := CreateWindowExW(0, PWideChar(WindowName), PWideChar(WindowTitle), WS_OVERLAPPEDWINDOW, CW_USEDEFAULT,
            CW_USEDEFAULT, Width, Height, 0, 0, hInstance, nil);

        if (Handle = 0) then
        begin
            MessageBox(0, 'Error creating window', 'Error', MB_OK or MB_ICONERROR);
            Exit;
        end;

        if (fullscreen) then
        begin
            SetWindowLong(Handle, GWL_STYLE, 0);
        end;

        ShowWindow(Handle, ShowWnd);
        UpdateWindow(Handle);

        Result := True;
    end;



    function InitD3D(): boolean;
    var
        hr: HRESULT;
        dxgiFactory: IDXGIFactory4;
        adapter: IDXGIAdapter1; // adapters are the graphics card (this includes the embedded graphics on the motherboard)
        adapterIndex: integer ; // we'll start looking for directx 12  compatible graphics devices starting at index 0
        adapterFound: boolean ; // set this to true when a good one was found
        desc: TDXGI_ADAPTER_DESC1;
        cqDesc: TD3D12_COMMAND_QUEUE_DESC;
        backBufferDesc: TDXGI_MODE_DESC; // this is to describe our display mode
        sampleDesc: TDXGI_SAMPLE_DESC;
        swapChainDesc: TDXGI_SWAP_CHAIN_DESC;
        tempSwapChain: IDXGISwapChain;
        rtvHeapDesc: TD3D12_DESCRIPTOR_HEAP_DESC;
        rtvHandle: TD3D12_CPU_DESCRIPTOR_HANDLE;
        i: integer;
    begin
        Result := False;
        adapterIndex:=0;
        adapterFound:= FALSE;

        // -- Create the Device -- //
        hr := CreateDXGIFactory1(IID_IDXGIFactory4, dxgiFactory);
        if (hr = S_OK) then
        begin
            // find first hardware gpu that supports d3d 12
            while (dxgiFactory.EnumAdapters1(adapterIndex, adapter) <> DXGI_ERROR_NOT_FOUND) do
            begin
                adapter.GetDesc1(desc);

                if (desc.Flags and Ord(DXGI_ADAPTER_FLAG_SOFTWARE) = Ord(DXGI_ADAPTER_FLAG_SOFTWARE)) then
                begin
                    // we dont want a software device
                    continue;
                end;

                // we want a device that is compatible with direct3d 12 (feature level 11 or higher)
                hr := D3D12CreateDevice(adapter, D3D_FEATURE_LEVEL_11_0, IID_ID3D12Device, nil);
                if (SUCCEEDED(hr)) then
                begin
                    adapterFound := True;
                    break;
                end;

                Inc(adapterIndex);
            end;

            if (not adapterFound) then
                Exit;
        end;
        if (SUCCEEDED(hr)) then
        begin
            // Create the device
            hr := D3D12CreateDevice(adapter, D3D_FEATURE_LEVEL_11_0, IID_ID3D12Device, @device);
            outputDebugStringA(pAnsichar(IntToHex(hr, 8)));
        end;

        // -- Create a direct command queue -- //
        if (SUCCEEDED(hr)) then
        begin
            cqDesc.Flags := D3D12_COMMAND_QUEUE_FLAG_NONE;
            cqDesc._Type := D3D12_COMMAND_LIST_TYPE_DIRECT; // direct means the gpu can directly execute this command queue

            hr := device.CreateCommandQueue(cqDesc, IID_ID3D12CommandQueue, commandQueue); // create the command queue
            outputDebugStringA(pAnsichar(IntToHex(hr, 8)));
        end;
        if (hr <> S_OK) then
            Exit;

        // -- Create the Swap Chain (double/tripple buffering) -- //
        {$IFNDEF FPC}
        backBufferDesc.Init;
        {$ENDIF}
        backBufferDesc.Width := Width; // buffer width
        backBufferDesc.Height := Height; // buffer height
        backBufferDesc.Format := DXGI_FORMAT_R8G8B8A8_UNORM; // format of the buffer (rgba 32 bits, 8 bits for each chanel)

        // describe our multi-sampling. We are not multi-sampling, so we set the count to 1 (we need at least one sample of course)
        {$IFNDEF FPC}
        sampleDesc.Init;
        {$ENDIF}
        sampleDesc.Count := 1; // multisample count (no multisampling, so we just put 1, since we still need 1 sample)

        // Describe and create the swap chain.
        {$IFNDEF FPC}
        swapChainDesc.Init;
        {$ENDIF}
        swapChainDesc.BufferCount := frameBufferCount; // number of buffers we have
        swapChainDesc.BufferDesc := backBufferDesc; // our back buffer description
        swapChainDesc.BufferUsage := DXGI_USAGE_RENDER_TARGET_OUTPUT; // this says the pipeline will render to this swap chain
        swapChainDesc.SwapEffect := DXGI_SWAP_EFFECT_FLIP_DISCARD; // dxgi will discard the buffer (data) after we call present
        swapChainDesc.OutputWindow := Handle; // handle to our window
        swapChainDesc.SampleDesc := sampleDesc; // our multi-sampling description
        swapChainDesc.Windowed := not FullScreen;
        // set to true, then if in fullscreen must call SetFullScreenState with true for full screen to get uncapped fps

        hr := dxgiFactory.CreateSwapChain(commandQueue, // the queue will be flushed once the swap chain is created
            @swapChainDesc, // give it the swap chain description we created above
            tempSwapChain // store the created swap chain in a temp IDXGISwapChain interface
            );
        outputDebugStringA(pAnsichar(IntToHex(hr, 8)));

        swapChain := IDXGISwapChain3(tempSwapChain);
        frameIndex := swapChain.GetCurrentBackBufferIndex();

        // -- Create the Back Buffers (render target views) Descriptor Heap -- //

        // describe an rtv descriptor heap and create
        {$IFNDEF FPC}
        rtvHeapDesc.Init;
        {$ENDIF}
        rtvHeapDesc.NumDescriptors := frameBufferCount; // number of descriptors for this heap.
        rtvHeapDesc._Type := D3D12_DESCRIPTOR_HEAP_TYPE_RTV; // this heap is a render target view heap

        // This heap will not be directly referenced by the shaders (not shader visible), as this will store the output from the pipeline
        // otherwise we would set the heap's flag to D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE
        rtvHeapDesc.Flags := D3D12_DESCRIPTOR_HEAP_FLAG_NONE;
        hr := device.CreateDescriptorHeap(@rtvHeapDesc, IID_ID3D12DescriptorHeap,@rtvDescriptorHeap);
        if (hr <> S_OK) then
            Exit;

        // get the size of a descriptor in this heap (this is a rtv heap, so only rtv descriptors should be stored in it.
        // descriptor sizes may vary from device to device, which is why there is no set size and we must ask the
        // device to give us the size. we will use this size to increment a descriptor handle offset
        rtvDescriptorSize := device.GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_RTV);

        // get a handle to the first descriptor in the descriptor heap. a handle is basically a pointer,
        // but we cannot literally use it like a c++ pointer.

        rtvDescriptorHeap.GetCPUDescriptorHandleForHeapStart(rtvHandle);

        // Create a RTV for each buffer (double buffering is two buffers, tripple buffering is 3).
        for i := 0 to frameBufferCount - 1 do
        begin
            // first we get the n'th buffer in the swap chain and store it in the n'th
            // position of our ID3D12Resource array
            hr := swapChain.GetBuffer(i, IID_ID3D12Resource, renderTargets[i]);
            if (hr <> S_OK) then
                Exit;

            // the we "create" a render target view which binds the swap chain buffer (ID3D12Resource[n]) to the rtv handle
            device.CreateRenderTargetView(renderTargets[i], nil, rtvHandle);

            // we increment the rtv handle by the rtv descriptor size we got above
            rtvHandle.Offset(1, rtvDescriptorSize);
        end;

        // -- Create the Command Allocators -- //
        for i := 0 to frameBufferCount - 1 do
        begin
            hr := device.CreateCommandAllocator(D3D12_COMMAND_LIST_TYPE_DIRECT, IID_ID3D12CommandAllocator, commandAllocator[i]);
            if (hr <> S_OK) then
                Exit;
        end;

        // -- Create a Command List -- //

        // create the command list with the first allocator
        hr := device.CreateCommandList(0, D3D12_COMMAND_LIST_TYPE_DIRECT, commandAllocator[0], nil, IID_ID3D12GraphicsCommandList, commandList);
        if (hr <> S_OK) then
            Exit;

        // command lists are created in the recording state. our main loop will set it up for recording again so close it now
        commandList.Close();

        // -- Create a Fence & Fence Event -- //

        // create the fences
        for i := 0 to frameBufferCount - 1 do
        begin
            hr := device.CreateFence(0, D3D12_FENCE_FLAG_NONE, IID_ID3D12Fence, fence[i]);
            if (hr <> S_OK) then
                Exit;
            fenceValue[i] := 0; // set the initial fence value to 0
        end;

        // create a handle to a fence event
        fenceEvent := CreateEvent(0, False, False, nil);
        if (fenceEvent = 0) then
            Exit;

        Result := True;
    end;



    procedure Update();
    begin
        // update app logic, such as moving the camera or figuring out what objects are in view
    end;



    procedure WaitForPreviousFrame();
    var
        hr: HResult;
    begin

        // if the current fence value is still less than "fenceValue", then we know the GPU has not finished executing
        // the command queue since it has not reached the "commandQueue.Signal(fence, fenceValue)" command
        if (fence[frameIndex].GetCompletedValue() < fenceValue[frameIndex]) then
        begin
            // we have the fence create an event which is signaled once the fence's current value is "fenceValue"
            hr := fence[frameIndex].SetEventOnCompletion(fenceValue[frameIndex], fenceEvent);
            if (hr <> S_OK) then
            begin
                Running := False;
            end;

            // We will wait until the fence has triggered the event that it's current value has reached "fenceValue". once it's value
            // has reached "fenceValue", we know the command queue has finished executing
            WaitForSingleObject(fenceEvent, INFINITE);
        end;

        // increment fenceValue for next frame
        Inc(fenceValue[frameIndex]);

        // swap the current rtv buffer index so we draw on the correct buffer
        frameIndex := swapChain.GetCurrentBackBufferIndex();
    end;



    procedure UpdatePipeline();
    const
        clearColor: array[0..3] of single = (0.0, 0.2, 0.4, 1.0);
    var
        hr: Hresult;
        rtvHandle: TD3D12_CPU_DESCRIPTOR_HANDLE;
    begin

        // We have to wait for the gpu to finish with the command allocator before we reset it
        WaitForPreviousFrame();

        // we can only reset an allocator once the gpu is done with it
        // resetting an allocator frees the memory that the command list was stored in
        hr := commandAllocator[frameIndex].Reset();
        if (hr <> S_OK) then
        begin
            Running := False;
        end;

        // reset the command list. by resetting the command list we are putting it into
        // a recording state so we can start recording commands into the command allocator.
        // the command allocator that we reference here may have multiple command lists
        // associated with it, but only one can be recording at any time. Make sure
        // that any other command lists associated to this command allocator are in
        // the closed state (not recording).
        // Here you will pass an initial pipeline state object as the second parameter,
        // but in this tutorial we are only clearing the rtv, and do not actually need
        // anything but an initial default pipeline, which is what we get by setting
        // the second parameter to NULL
        hr := commandList.Reset(commandAllocator[frameIndex], nil);
        if (hr <> S_OK) then
        begin
            Running := False;
        end;

        // here we start recording commands into the commandList (which all the commands will be stored in the commandAllocator)

        // transition the "frameIndex" render target from the present state to the render target state so the command list draws to it starting from here
        commandList.ResourceBarrier(1, TD3DX12_RESOURCE_BARRIER.CreateTransition(renderTargets[frameIndex],
            D3D12_RESOURCE_STATE_PRESENT, D3D12_RESOURCE_STATE_RENDER_TARGET));

        // here we again get the handle to our current render target view so we can set it as the render target in the output merger stage of the pipeline

        rtvDescriptorHeap.GetCPUDescriptorHandleForHeapStart(rtvHandle);

        rtvHandle := TD3D12_CPU_DESCRIPTOR_HANDLE.Create(rtvHandle, frameIndex, rtvDescriptorSize);

        // set the render target for the output merger stage (the output of the pipeline)
        commandList.OMSetRenderTargets(1, @rtvHandle, False, nil);

        // Clear the render target by using the ClearRenderTargetView command

        commandList.ClearRenderTargetView(rtvHandle, TSingleArray4(clearColor), 0, nil);

        // transition the "frameIndex" render target from the render target state to the present state. If the debug layer is enabled, you will receive a
        // warning if present is called on the render target when it's not in the present state
        commandList.ResourceBarrier(1, TD3DX12_RESOURCE_BARRIER.CreateTransition(renderTargets[frameIndex],
            D3D12_RESOURCE_STATE_RENDER_TARGET, D3D12_RESOURCE_STATE_PRESENT));

        hr := commandList.Close();
        if (hr <> S_OK) then
        begin
            Running := False;
        end;
    end;



    procedure Render();
    var
        hr: HRESULT;
        ppCommandLists: array [0..0] of ID3D12CommandList;
    begin
        UpdatePipeline(); // update the pipeline by sending commands to the commandqueue

        // create an array of command lists (only one command list here)
        ppCommandLists[0] := commandList;

        // execute the array of command lists
        commandQueue.ExecuteCommandLists(Length(ppCommandLists), @ppCommandLists[0]);

        // this command goes in at the end of our command queue. we will know when our command queue
        // has finished because the fence value will be set to "fenceValue" from the GPU since the command
        // queue is being executed on the GPU
        hr := commandQueue.Signal(fence[frameIndex], fenceValue[frameIndex]);
        if (hr <> S_OK) then
        begin
            Running := False;
        end;

        // present the current backbuffer
        hr := swapChain.Present(0, 0);
        if (hr <> S_OK) then
        begin
            Running := False;
        end;
    end;



    procedure Cleanup();
    var
        i: integer;
        fs: longbool;
    begin
    fs:=FALSE;
        // wait for the gpu to finish all frames
        for  i := 0 to frameBufferCount - 1 do
        begin
            frameIndex := i;
            WaitForPreviousFrame();
        end;

        // get swapchain out of full screen before exiting
        if (swapChain.GetFullscreenState(fs, nil)) = S_OK then
            swapChain.SetFullscreenState(False, nil);

        SAFE_RELEASE(device);
        SAFE_RELEASE(swapChain);
        SAFE_RELEASE(commandQueue);
        SAFE_RELEASE(rtvDescriptorHeap);
        SAFE_RELEASE(commandList);

        for i := 0 to frameBufferCount - 1 do
        begin
            SAFE_RELEASE(renderTargets[i]);
            SAFE_RELEASE(commandAllocator[i]);
            SAFE_RELEASE(fence[i]);
        end;
    end;




    procedure mainloop();
    var
        msg: TMSG;
    begin

        ZeroMemory(@msg, sizeof(MSG));

        while (Running) do
        begin
            if (PeekMessage(msg, 0, 0, 0, PM_REMOVE)) then
            begin
                if (msg.message = WM_QUIT) then
                    break;

                TranslateMessage(msg);
                DispatchMessage(msg);
            end
            else
            begin
                // run game code
                Update(); // update the game logic
                Render(); // execute the command queue (rendering the scene is the result of the gpu executing the command lists)
            end;
        end;
    end;


begin
    // create the window
    if (not InitializeWindow(hInstance, SW_SHOW, Width, Height, FullScreen)) then
    begin
        MessageBox(0, 'Window Initialization - Failed',
            'Error', MB_OK);
        Exit;
    end;
    // initialize direct3d
    if (not InitD3D()) then
    begin
        MessageBox(0, 'Failed to initialize direct3d 12',
            'Error', MB_OK);
        Cleanup();
        Exit;
    end;


    // start the main loop
    mainloop();

    // we want to wait for the gpu to finish executing the command list before we start releasing everything
    WaitForPreviousFrame();

    // close the fence event
    CloseHandle(fenceEvent);

    // clean up everything
    Cleanup();

end.

