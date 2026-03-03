program Tut06;

{$mode delphi}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
    cthreads, {$ENDIF} {$ENDIF}
    Interfaces, // this includes the adLCL widgetset
    MultiMon,
    SysUtils,
    Windows,
    DX12.D3D12,
    DX12.D3DX12,
    DX12.DXGI,
    DX12.DXGI1_4,
    DX12.DXGI1_3,
    DirectX.Math,
    DX12.D3D12SDKLayers,
    DX12.D3DCommon,
    DX12.D3DCompiler;

{$R *.res}

const
    // name of the window (not the title)
    WindowName: WideString = 'BzTutsApp';

    // title of the window
    WindowTitle: WideString = 'Bz Window';

const
    frameBufferCount = 3; // number of buffers we want, 2 for double buffering, 3 for tripple buffering


type

    TVertex = record
        pos: TXMFLOAT3;
        color: TXMFLOAT4;
    end;



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

    pipelineStateObject: ID3D12PipelineState = nil; // pso containing a pipeline state

    rootSignature: ID3D12RootSignature = nil; // root signature defines data shaders will access

    viewport: TD3D12_VIEWPORT; // area that output from rasterizer will be stretched to.

    scissorRect: TD3D12_RECT; // the area to draw in. pixels outside that area will not be drawn onto

    vertexBuffer: ID3D12Resource; // a default buffer in GPU memory that we will load vertex data for our triangle into
    indexBuffer: ID3D12Resource; // a default buffer in GPU memory that we will load index data for our triangle into

    vertexBufferView: TD3D12_VERTEX_BUFFER_VIEW; // a structure containing a pointer to the vertex data in gpu memory
    // the total size of the buffer, and the size of each element (vertex)
    indexBufferView: TD3D12_INDEX_BUFFER_VIEW; // a structure holding information about the index buffer



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



    function InitializeWindow(Instance: PtrUInt; ShowWnd: integer; Width: integer; Height: integer; fullscreen: boolean): boolean;
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
    const
        inputLayout: array [0..1] of TD3D12_INPUT_ELEMENT_DESC =
            ((SemanticName: 'POSITION'; SemanticIndex: 0; Format: DXGI_FORMAT_R32G32B32_FLOAT; InputSlot: 0; AlignedByteOffset: 0;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA; InstanceDataStepRate: 0),
            (SemanticName: 'COLOR'; SemanticIndex: 0; Format: DXGI_FORMAT_R32G32B32A32_FLOAT; InputSlot: 0; AlignedByteOffset: 12;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA; InstanceDataStepRate: 0));

        // a triangle
        vList: array [0..3] of TVertex = (
            (pos: (x: -0.5; y: 0.5; z: 0.5); color: (r: 1.0; g: 0.0; b: 0.0; a: 1.0)),
            (pos: (x: 0.5; y: -0.5; z: 0.5); color: (r: 0.0; g: 1.0; b: 0.0; a: 1.0)),
            (pos: (x: -0.5; y: -0.5; z: 0.5); color: (r: 0.0; g: 0.0; b: 1.0; a: 1.0)),
            (pos: (x: 0.5; y: 0.5; z: 0.5); color: (r: 1.0; g: 0.0; b: 1.0; a: 1.0))
            );

    var
        hr: HRESULT;
        dxgiFactory: IDXGIFactory4;
        adapter: IDXGIAdapter1; // adapters are the graphics card (this includes the embedded graphics on the motherboard)
        WarpAdapter: IDXGIAdapter;
        adapterIndex: integer = 0; // we'll start looking for directx 12  compatible graphics devices starting at index 0
        adapterFound: boolean = False; // set this to true when a good one was found
        desc: TDXGI_ADAPTER_DESC1;
        cqDesc: TD3D12_COMMAND_QUEUE_DESC;
        backBufferDesc: TDXGI_MODE_DESC; // this is to describe our display mode
        sampleDesc: TDXGI_SAMPLE_DESC;
        swapChainDesc: TDXGI_SWAP_CHAIN_DESC;
        tempSwapChain: IDXGISwapChain;
        rtvHeapDesc: TD3D12_DESCRIPTOR_HEAP_DESC;
        rtvHandle: TD3D12_CPU_DESCRIPTOR_HANDLE;
        i: integer;

        rootSignatureDesc: TD3DX12_ROOT_SIGNATURE_DESC;
        signature: ID3DBlob;

        vertexShader: ID3DBlob; // d3d blob for holding vertex shader bytecode
        errorBuff: ID3DBlob; // a buffer holding the error data if any
        vertexShaderBytecode: TD3D12_SHADER_BYTECODE;
        pixelShader: ID3DBlob;
        pixelShaderBytecode: TD3D12_SHADER_BYTECODE;

        inputLayoutDesc: TD3D12_INPUT_LAYOUT_DESC;
        psoDesc: TD3D12_GRAPHICS_PIPELINE_STATE_DESC; // a structure to define a pso

        vBufferSize: integer;
        vBufferUploadHeap: ID3D12Resource;
        vertexData: TD3D12_SUBRESOURCE_DATA;
        ppCommandLists: array [0..0] of ID3D12CommandList;

        debugController: ID3D12Debug;

        lUseWarpDevice: boolean = False;
        lUseDebug: boolean = False;
        debugdevice: ID3D12DebugDevice;

        dxgiFactoryFlags: UINT = 0;
        iTemp: UINT;
        lltemp: TD3DX12_RESOURCE_BARRIER;

        // a quad (2 triangles)
        iList: array [0..5] of DWORD = (0, 1, 2, // first triangle
            0, 3, 1 // second triangle
            );
        iBufferSize: integer;
        iBufferUploadHeap: ID3D12Resource;
        indexData: TD3D12_SUBRESOURCE_DATA;
    begin
        Result := False;

        if lUseDebug then
        begin
            hr := D3D12GetDebugInterface(IID_ID3D12Debug, debugController);
            debugController.EnableDebugLayer();
            dxgiFactoryFlags := dxgiFactoryFlags or DXGI_CREATE_FACTORY_DEBUG;
        end;

        // -- Create the Device -- //
        // hr := CreateDXGIFactory2(dxgiFactoryFlags, IID_IDXGIFactory4, dxgiFactory);
        hr := CreateDXGIFactory1(IID_IDXGIFactory4, dxgiFactory);
        if (hr = S_OK) then
        begin
            if lUseDebug then
            begin
                hr := dxgiFactory.EnumWarpAdapter(IID_IDXGIAdapter, warpAdapter);

                adapterFound := True;
                hr := D3D12CreateDevice(warpAdapter, D3D_FEATURE_LEVEL_11_0, IID_ID3D12Device, @device);
                outputDebugStringA(pAnsichar(IntToHex(hr, 8)));
            end
            else
            begin
                // find first hardware gpu that supports d3d 12
                while (dxgiFactory.EnumAdapters1(adapterIndex, adapter) <> DXGI_ERROR_NOT_FOUND) do
                begin
                    adapter.GetDesc1(desc);

                    if (desc.Flags and Ord(DXGI_ADAPTER_FLAG_SOFTWARE) = Ord(DXGI_ADAPTER_FLAG_SOFTWARE)) then
                    begin
                        // we dont want a software device
                        Inc(adapterIndex);
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
        backBufferDesc.Width := Width; // buffer width
        backBufferDesc.Height := Height; // buffer height
        backBufferDesc.Format := DXGI_FORMAT_R8G8B8A8_UNORM; // format of the buffer (rgba 32 bits, 8 bits for each chanel)

        // describe our multi-sampling. We are not multi-sampling, so we set the count to 1 (we need at least one sample of course)
        sampleDesc.Count := 1; // multisample count (no multisampling, so we just put 1, since we still need 1 sample)

        // Describe and create the swap chain.
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

        rtvHeapDesc.NumDescriptors := frameBufferCount; // number of descriptors for this heap.
        rtvHeapDesc._Type := D3D12_DESCRIPTOR_HEAP_TYPE_RTV; // this heap is a render target view heap

        // This heap will not be directly referenced by the shaders (not shader visible), as this will store the output from the pipeline
        // otherwise we would set the heap's flag to D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE
        rtvHeapDesc.Flags := D3D12_DESCRIPTOR_HEAP_FLAG_NONE;
        hr := device.CreateDescriptorHeap(rtvHeapDesc, IID_ID3D12DescriptorHeap, @rtvDescriptorHeap);
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
        hr := device.CreateCommandList(0, D3D12_COMMAND_LIST_TYPE_DIRECT, commandAllocator[frameIndex], nil,
            IID_ID3D12GraphicsCommandList, commandList);
        if (hr <> S_OK) then
            Exit;

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


        // create root signature
        rootSignatureDesc.Init(0, nil, 0, nil, D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT);

        hr := D3D12SerializeRootSignature(rootSignatureDesc, D3D_ROOT_SIGNATURE_VERSION_1, signature, nil);
        if (FAILED(hr)) then
            Exit;

        hr := device.CreateRootSignature(0, signature.GetBufferPointer(), signature.GetBufferSize(), IID_ID3D12RootSignature, rootSignature);
        if (FAILED(hr)) then
            Exit;

        // create vertex and pixel shaders

        // when debugging, we can compile the shader files at runtime.
        // but for release versions, we can compile the hlsl shaders
        // with fxc.exe to create .cso files, which contain the shader
        // bytecode. We can load the .cso files at runtime to get the
        // shader bytecode, which of course is faster than compiling
        // them at runtime

        // compile vertex shader


        hr := D3DCompileFromFile('VertexShader.hlsl', nil, nil, 'main', 'vs_5_0', D3DCOMPILE_DEBUG or D3DCOMPILE_SKIP_OPTIMIZATION,
            0, vertexShader, errorBuff);
        if (FAILED(hr)) then
        begin
            OutputDebugStringA(PAnsiChar(errorBuff.GetBufferPointer()));
            exit;
        end;

        // fill out a shader bytecode structure, which is basically just a pointer
        // to the shader bytecode and the size of the shader bytecode


        vertexShaderBytecode.BytecodeLength := vertexShader.GetBufferSize();
        vertexShaderBytecode.pShaderBytecode := vertexShader.GetBufferPointer();

        // compile pixel shader

        hr := D3DCompileFromFile('PixelShader.hlsl', nil, nil, 'main', 'ps_5_0', D3DCOMPILE_DEBUG or D3DCOMPILE_SKIP_OPTIMIZATION,
            0, pixelShader, errorBuff);
        if (FAILED(hr)) then
        begin
            OutputDebugStringA(pAnsiChar(errorBuff.GetBufferPointer()));
            Exit;
        end;

        // fill out shader bytecode structure for pixel shader

        pixelShaderBytecode.BytecodeLength := pixelShader.GetBufferSize();
        pixelShaderBytecode.pShaderBytecode := pixelShader.GetBufferPointer();

        // create input layout

        // The input layout is used by the Input Assembler so that it knows
        // how to read the vertex data bound to it.



        // fill out an input layout description structure


        // we can get the number of elements in an array by "sizeof(array) / sizeof(arrayElementType)"
        inputLayoutDesc.NumElements := sizeof(inputLayout) div sizeof(TD3D12_INPUT_ELEMENT_DESC);
        inputLayoutDesc.pInputElementDescs := @inputLayout[0];

        // create a pipeline state object (PSO)

        // In a real application, you will have many pso's. for each different shader
        // or different combinations of shaders, different blend states or different rasterizer states,
        // different topology types (point, line, triangle, patch), or a different number
        // of render targets you will need a pso

        // VS is the only required shader for a pso. You might be wondering when a case would be where
        // you only set the VS. It's possible that you have a pso that only outputs data with the stream
        // output, and not on a render target, which means you would not need anything after the stream
        // output.


        psoDesc.InputLayout := inputLayoutDesc; // the structure describing our input layout
        psoDesc.pRootSignature := rootSignature; // the root signature that describes the input data this pso needs
        psoDesc.VS := vertexShaderBytecode; // structure describing where to find the vertex shader bytecode and how large it is
        psoDesc.PS := pixelShaderBytecode; // same as VS but for pixel shader
        psoDesc.PrimitiveTopologyType := D3D12_PRIMITIVE_TOPOLOGY_TYPE_TRIANGLE; // type of topology we are drawing
        psoDesc.RTVFormats[0] := DXGI_FORMAT_R8G8B8A8_UNORM; // format of the render target
        psoDesc.SampleDesc := sampleDesc; // must be the same sample description as the swapchain and depth/stencil buffer
        psoDesc.SampleMask := $ffffffff; // sample mask has to do with multi-sampling. 0xffffffff means point sampling is done
        psoDesc.RasterizerState.Create(D3D12_DEFAULT); // a default rasterizer state.
        psoDesc.BlendState.Create(D3D12_DEFAULT);  // a default blent state.
        psoDesc.NumRenderTargets := 1; // we are only binding one render target

        // create the pso
        hr := device.CreateGraphicsPipelineState(@psoDesc, IID_ID3D12PipelineState, pipelineStateObject);
        if (FAILED(hr)) then
            Exit;

        // Create vertex buffer

        vBufferSize := sizeof(vList);

        // create default heap
        // default heap is memory on the GPU. Only the GPU has access to this memory
        // To get data into this heap, we will have to upload the data using
        // an upload heap
        hr := device.CreateCommittedResource(TD3DX12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_DEFAULT), // a default heap
            D3D12_HEAP_FLAG_NONE, // no flags
            TD3DX12_RESOURCE_DESC.Buffer(vBufferSize), // resource description for a buffer
            D3D12_RESOURCE_STATE_COPY_DEST, // we will start this heap in the copy destination state since we will copy data
            // from the upload heap to this heap
            nil, // optimized clear value must be null for this type of resource. used for render targets and depth/stencil buffers
            IID_ID3D12Resource, vertexBuffer);

        // we can give resource heaps a name so when we debug with the graphics debugger we know what resource we are looking at
        vertexBuffer.SetName('Vertex Buffer Resource Heap');

        // create upload heap
        // upload heaps are used to upload data to the GPU. CPU can write to it, GPU can read from it
        // We will upload the vertex buffer using this heap to the default heap

        hr := device.CreateCommittedResource(TD3DX12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_UPLOAD), // upload heap
            D3D12_HEAP_FLAG_NONE, // no flags
            TD3DX12_RESOURCE_DESC.Buffer(vBufferSize), // resource description for a buffer
            D3D12_RESOURCE_STATE_GENERIC_READ, // GPU will read from this buffer and copy its contents to the default heap
            nil, IID_ID3D12Resource, vBufferUploadHeap);
        vBufferUploadHeap.SetName('Vertex Buffer Upload Resource Heap');

        // store vertex buffer in upload heap

        vertexData.pData := @vList[0]; // pointer to our vertex array
        vertexData.RowPitch := vBufferSize; // size of all our triangle vertex data
        vertexData.SlicePitch := vBufferSize; // also the size of our triangle vertex data


        // we are now creating a command with the command list to copy the data from
        // the upload heap to the default heap
        UpdateSubresources(commandList, vertexBuffer, vBufferUploadHeap, 0, 0, 1, @vertexData);

        // transition the vertex buffer data from copy destination state to vertex buffer state
        lltemp := TD3DX12_RESOURCE_BARRIER.CreateTransition(vertexBuffer, D3D12_RESOURCE_STATE_COPY_DEST,
            D3D12_RESOURCE_STATE_VERTEX_AND_CONSTANT_BUFFER);
        commandList.ResourceBarrier(1, @lltemp);


        // Create index buffer


        iBufferSize := sizeof(iList);

        // create default heap to hold index buffer
        device.CreateCommittedResource(
            TD3DX12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_DEFAULT), // a default heap
            D3D12_HEAP_FLAG_NONE, // no flags
            TD3DX12_RESOURCE_DESC.Buffer(iBufferSize), // resource description for a buffer
            D3D12_RESOURCE_STATE_COPY_DEST, // start in the copy destination state
            nil, // optimized clear value must be null for this type of resource
            IID_ID3D12Resource, indexBuffer);

        // we can give resource heaps a name so when we debug with the graphics debugger we know what resource we are looking at
        vertexBuffer.SetName('Index Buffer Resource Heap');

        // create upload heap to upload index buffer

        device.CreateCommittedResource(
            TD3DX12_HEAP_PROPERTIES.Create(D3D12_HEAP_TYPE_UPLOAD), // upload heap
            D3D12_HEAP_FLAG_NONE, // no flags
            TD3DX12_RESOURCE_DESC.Buffer(vBufferSize), // resource description for a buffer
            D3D12_RESOURCE_STATE_GENERIC_READ, // GPU will read from this buffer and copy its contents to the default heap
            nil,
            IID_ID3D12Resource, iBufferUploadHeap);
        vBufferUploadHeap.SetName('Index Buffer Upload Resource Heap');

        // store vertex buffer in upload heap


        indexData.pData := @iList[0]; // pointer to our index array
        indexData.RowPitch := iBufferSize; // size of all our index buffer
        indexData.SlicePitch := iBufferSize; // also the size of our index buffer

        // we are now creating a command with the command list to copy the data from
        // the upload heap to the default heap
        UpdateSubresources(commandList, indexBuffer, iBufferUploadHeap, 0, 0, 1, @indexData);

        // transition the vertex buffer data from copy destination state to vertex buffer state
        lltemp := TD3DX12_RESOURCE_BARRIER.CreateTransition(indexBuffer, D3D12_RESOURCE_STATE_COPY_DEST, D3D12_RESOURCE_STATE_VERTEX_AND_CONSTANT_BUFFER);
        commandList.ResourceBarrier(1, @lltemp);


        // Now we execute the command list to upload the initial assets (triangle data)
        commandList.Close();


        ppCommandLists[0] := commandList;
        commandQueue.ExecuteCommandLists(Length(ppCommandLists), @ppCommandLists[0]);
        Sleep(1); // Why that BULLSHIT, without this sleep no triangle is shown, the C++ don't need a sleep here ?!?
        // increment the fence value now, otherwise the buffer might not be uploaded by the time we start drawing
        Inc(fenceValue[frameIndex]);
        hr := commandQueue.Signal(fence[frameIndex], fenceValue[frameIndex]);
        if (FAILED(hr)) then
            Exit;

        // create a vertex buffer view for the triangle. We get the GPU memory address to the vertex pointer using the GetGPUVirtualAddress() method
        vertexBufferView.BufferLocation := vertexBuffer.GetGPUVirtualAddress();
        vertexBufferView.StrideInBytes := sizeof(TVertex);
        vertexBufferView.SizeInBytes := vBufferSize;

        // create a vertex buffer view for the triangle. We get the GPU memory address to the vertex pointer using the GetGPUVirtualAddress() method
        indexBufferView.BufferLocation := indexBuffer.GetGPUVirtualAddress();
        indexBufferView.Format := DXGI_FORMAT_R32_UINT; // 32-bit unsigned integer (this is what a dword is, double word, a word is 2 bytes)
        indexBufferView.SizeInBytes := iBufferSize;


        // Fill out the Viewport
        viewport.TopLeftX := 0;
        viewport.TopLeftY := 0;
        viewport.Width := Width;
        viewport.Height := Height;
        viewport.MinDepth := 0.0;
        viewport.MaxDepth := 1.0;

        // Fill out a scissor rect
        scissorRect.left := 0;
        scissorRect.top := 0;
        scissorRect.right := Width;
        scissorRect.bottom := Height;

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
        // swap the current rtv buffer index so we draw on the correct buffer
        frameIndex := swapChain.GetCurrentBackBufferIndex();

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

    end;



    procedure UpdatePipeline();
    const
        clearColor: array[0..3] of single = (0.0, 0.2, 0.4, 1.0);
    var
        hr: Hresult;
        rtvHandle: TD3D12_CPU_DESCRIPTOR_HANDLE;
        ltest: TD3DX12_RESOURCE_BARRIER;
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
        hr := commandList.Reset(commandAllocator[frameIndex], pipelineStateObject);
        if (hr <> S_OK) then
        begin
            Running := False;
        end;

        // here we start recording commands into the commandList (which all the commands will be stored in the commandAllocator)

        // transition the "frameIndex" render target from the present state to the render target state so the command list draws to it starting from here
        ltest := TD3DX12_RESOURCE_BARRIER.CreateTransition(renderTargets[frameIndex], D3D12_RESOURCE_STATE_PRESENT,
            D3D12_RESOURCE_STATE_RENDER_TARGET);
        commandList.ResourceBarrier(1, @lTest);

        // here we again get the handle to our current render target view so we can set it as the render target in the output merger stage of the pipeline
        rtvDescriptorHeap.GetCPUDescriptorHandleForHeapStart(rtvHandle);
        rtvHandle := TD3D12_CPU_DESCRIPTOR_HANDLE.Create(rtvHandle, frameIndex, rtvDescriptorSize);

        // set the render target for the output merger stage (the output of the pipeline)
        commandList.OMSetRenderTargets(1, @rtvHandle, False, nil);

        // Clear the render target by using the ClearRenderTargetView command
        commandList.ClearRenderTargetView(rtvHandle, TSingleArray4(clearColor), 0, nil);

        // draw triangle
        commandList.SetGraphicsRootSignature(rootSignature); // set the root signature
        commandList.RSSetViewports(1, @viewport); // set the viewports
        commandList.RSSetScissorRects(1, @scissorRect); // set the scissor rects
        commandList.IASetPrimitiveTopology(D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST); // set the primitive topology
        commandList.IASetVertexBuffers(0, 1, @vertexBufferView); // set the vertex buffer (using the vertex buffer view)
        commandList.IASetIndexBuffer(indexBufferView);
        commandList.DrawIndexedInstanced(6, 1, 0, 0, 0); // draw 2 triangles (draw 1 instance of 2 triangles)


        // transition the "frameIndex" render target from the render target state to the present state. If the debug layer is enabled, you will receive a
        // warning if present is called on the render target when it's not in the present state
        ltest := TD3DX12_RESOURCE_BARRIER.CreateTransition(renderTargets[frameIndex], D3D12_RESOURCE_STATE_RENDER_TARGET,
            D3D12_RESOURCE_STATE_PRESENT);
        commandList.ResourceBarrier(1, @ltest);

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
        outputDebugStringA(pAnsichar(IntToHex(hr, 8)));
        if (hr <> S_OK) then
        begin
            Running := False;
        end;
    end;



    procedure Cleanup();
    var
        i: integer;
        fs: longbool = False;
    begin
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

        SAFE_RELEASE(pipelineStateObject);
        SAFE_RELEASE(rootSignature);
        SAFE_RELEASE(vertexBuffer);
        SAFE_RELEASE(indexBuffer);
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
