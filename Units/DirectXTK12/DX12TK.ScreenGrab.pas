//--------------------------------------------------------------------------------------
// File: ScreenGrab.h

// Function for capturing a 2D texture and saving it to a file (aka a 'screenshot'
// when used on a Direct3D Render Target).

// Note these functions are useful as a light-weight runtime screen grabber. For
// full-featured texture capture, DDS writer, and texture processing pipeline,
// see the 'Texconv' sample and the 'DirectXTex' library.

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------
unit DX12TK.ScreenGrab;

{$mode delphi}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D12,
    Win32.OCIdl;

const
    UINT32_MAX = $FFFFFFFF;

type
    REFGUID = ^TGUID;

    TSetCustomProps = procedure(Prop: IPropertyBag2);
    PSetCustomProps = ^TSetCustomProps;


function SaveDDSTextureToFile(
    {_In_ } pCommandQueue: ID3D12CommandQueue;
    {_In_ } pSource: ID3D12Resource;
    {_In_z_ } fileName: pwidechar; beforeState: TD3D12_RESOURCE_STATES = D3D12_RESOURCE_STATE_RENDER_TARGET; afterState: TD3D12_RESOURCE_STATES = D3D12_RESOURCE_STATE_RENDER_TARGET): HRESULT;


function SaveWICTextureToFile(
    {_In_ } pCommandQ: ID3D12CommandQueue;
    {_In_ } pSource: ID3D12Resource; guidContainerFormat: REFGUID;
    {_In_z_ } fileName: pwidechar; beforeState: TD3D12_RESOURCE_STATES = D3D12_RESOURCE_STATE_RENDER_TARGET; afterState: TD3D12_RESOURCE_STATES = D3D12_RESOURCE_STATE_RENDER_TARGET;
    {_In_opt_ } targetFormat: REFGUID = nil;
    {_In_ } setCustomProps: TSetCustomProps = nil; forceSRGB: winbool = False): HRESULT;


implementation

uses
    Windows.Macros,
    Win32.PropIDLBase,
    Win32.WTypes,
    Win32.FileApi,
    Win32.ProcessThreadsAPI,
    Win32.OAIdl,
    DX12.DXGIFormat,
    DX12TK.DDS,
    DX12.D3DCommon,
    DX12.D3DX12_Core,
    DX12TK.DirectXHelpers,
    DX12TK.LoaderHelpers,
    DX12TK.PlatformHelpers,
    DX12.WinCodec,
    DX12.WinCodecD2D1,
    DX12TK.WICTextureLoader,
    CStdFunctions;

    //--------------------------------------------------------------------------------------
    // File: ScreenGrab.cpp

    // Function for capturing a 2D texture and saving it to a file (aka a 'screenshot'
    // when used on a Direct3D Render Target).

    // Note these functions are useful as a light-weight runtime screen grabber. For
    // full-featured texture capture, DDS writer, and texture processing pipeline,
    // see the 'Texconv' sample and the 'DirectXTex' library.

    // Copyright (c) Microsoft Corporation.
    // Licensed under the MIT License.

    // http://go.microsoft.com/fwlink/?LinkID=615561
    //--------------------------------------------------------------------------------------

    // Does not capture 1D textures or 3D textures (volume maps)

    // Does not capture mipmap chains, only the top-most texture level is saved

    // For 2D array textures and cubemaps, it captures only the first image in the array


function CaptureTexture(
    {_In_ } device: ID3D12Device;
    {_In_ } pCommandQ: ID3D12CommandQueue;
    {_In_ } pSource: ID3D12Resource; srcPitch: uint64; desc: TD3D12_RESOURCE_DESC;
    {_COM_Outptr_ }  out pStaging: ID3D12Resource; beforeState: TD3D12_RESOURCE_STATES; afterState: TD3D12_RESOURCE_STATES): HRESULT;
var
    numberOfPlanes: UINT;

    sourceHeapProperties: TD3D12_HEAP_PROPERTIES;
    commandAlloc: ID3D12CommandAllocator;
    commandList: ID3D12GraphicsCommandList;
    fence: ID3D12Fence;

    defaultHeapProperties: TD3D12_HEAP_PROPERTIES;
    readBackHeapProperties: TD3D12_HEAP_PROPERTIES;
    bufferDesc: TD3D12_RESOURCE_DESC;

    beforeStateSource: TD3D12_RESOURCE_STATES;

    descCopy: TD3D12_RESOURCE_DESC;

    pTemp: ID3D12Resource;
    fmt: TDXGI_FORMAT;

    formatInfo: TD3D12_FEATURE_DATA_FORMAT_SUPPORT;
    item, level, index: UINT;
    copySource: ID3D12Resource;
    bufferFootprint: TD3D12_PLACED_SUBRESOURCE_FOOTPRINT;

    copyDest: TD3D12_TEXTURE_COPY_LOCATION;
    copySrc: TD3D12_TEXTURE_COPY_LOCATION;
begin
    pStaging := nil;

    Result := E_INVALIDARG;
    if (pCommandQ = nil) or (pSource = nil) then
        Exit;

    if (desc.Dimension <> D3D12_RESOURCE_DIMENSION_TEXTURE2D) then
    begin
        DebugTrace('ERROR: ScreenGrab does not support 1D or volume textures. Consider using DirectXTex instead.\n', []);
        Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
        Exit;
    end;

    if (desc.DepthOrArraySize > 1) or (desc.MipLevels > 1) then
    begin
        DebugTrace('WARNING: ScreenGrab does not support 2D arrays, cubemaps, or mipmaps; only the first surface is written. Consider using DirectXTex instead.\n', []);
    end;

    if (srcPitch > UINT32_MAX) then
    begin
        Result := HRESULT_FROM_WIN32(ERROR_ARITHMETIC_OVERFLOW);
        Exit;
    end;

    numberOfPlanes := D3D12GetFormatPlaneCount(device, desc.Format);
    if (numberOfPlanes <> 1) then
    begin
        Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
        Exit;
    end;


    Result := pSource.GetHeapProperties(@sourceHeapProperties, nil);
    if (SUCCEEDED(Result) and (sourceHeapProperties.HeapType = D3D12_HEAP_TYPE_READBACK)) then
    begin
        // Handle case where the source is already a staging texture we can use directly
        pStaging := pSource;

        Result := S_OK;
        Exit;
    end;

    // Create a command allocator

    Result := device.CreateCommandAllocator(D3D12_COMMAND_LIST_TYPE_DIRECT, @IID_ID3D12CommandAllocator, commandAlloc);
    if (FAILED(Result)) then
        Exit;

    SetDebugObjectName(commandAlloc, 'ScreenGrab');

    // Spin up a new command list

    Result := device.CreateCommandList(0, D3D12_COMMAND_LIST_TYPE_DIRECT, commandAlloc, nil, @IID_ID3D12GraphicsCommandList, commandList);
    if (FAILED(Result)) then
        Exit;

    SetDebugObjectName(commandList, 'ScreenGrab');

    // Create a fence
    Result := device.CreateFence(0, D3D12_FENCE_FLAG_NONE, @IID_ID3D12Fence, fence);
    if (FAILED(Result)) then
        Exit;

    SetDebugObjectName(fence, 'ScreenGrab');

    assert((srcPitch and $FF) = 0);

    defaultHeapProperties.Init(D3D12_HEAP_TYPE_DEFAULT);
    readBackHeapProperties.Init(D3D12_HEAP_TYPE_READBACK);

    // Readback resources must be buffers

    bufferDesc.DepthOrArraySize := 1;
    bufferDesc.Dimension := D3D12_RESOURCE_DIMENSION_BUFFER;
    bufferDesc.Flags := D3D12_RESOURCE_FLAG_NONE;
    bufferDesc.Format := DXGI_FORMAT_UNKNOWN;
    bufferDesc.Height := 1;
    bufferDesc.Width := srcPitch * desc.Height;
    bufferDesc.Layout := D3D12_TEXTURE_LAYOUT_ROW_MAJOR;
    bufferDesc.MipLevels := 1;
    bufferDesc.SampleDesc.Count := 1;


    copySource := pSource;
    beforeStateSource := beforeState;
    if (desc.SampleDesc.Count > 1) then
    begin
        TransitionResource(commandList, pSource, beforeState, D3D12_RESOURCE_STATE_RESOLVE_SOURCE);

        // MSAA content must be resolved before being copied to a staging texture
        descCopy := desc;
        descCopy.SampleDesc.Count := 1;
        descCopy.SampleDesc.Quality := 0;
        descCopy.Alignment := D3D12_DEFAULT_RESOURCE_PLACEMENT_ALIGNMENT;


        Result := device.CreateCommittedResource(@defaultHeapProperties, D3D12_HEAP_FLAG_NONE, @descCopy, D3D12_RESOURCE_STATE_RESOLVE_DEST, nil, @IID_ID3D12Resource, pTemp);
        if (FAILED(Result)) then
            Exit;

        assert(pTemp <> nil);

        SetDebugObjectName(pTemp, 'ScreenGrab temporary');

        fmt := EnsureNotTypeless(desc.Format);

        formatInfo.Format := fmt;
        formatInfo.Support1 := D3D12_FORMAT_SUPPORT1_NONE;
        formatInfo.Support2 := D3D12_FORMAT_SUPPORT2_NONE;


        Result := device.CheckFeatureSupport(D3D12_FEATURE_FORMAT_SUPPORT, @formatInfo, sizeof(formatInfo));
        if (FAILED(Result)) then
            Exit;

        if ((Ord(formatInfo.Support1) and Ord(D3D12_FORMAT_SUPPORT1_TEXTURE2D)) <> Ord(D3D12_FORMAT_SUPPORT1_TEXTURE2D)) then
        begin
            Result := E_FAIL;

            Exit;
        end;
        for  item := 0 to desc.DepthOrArraySize - 1 do
        begin
            for  level := 0 to desc.MipLevels - 1 do
            begin
                index := D3D12CalcSubresource(level, item, 0, desc.MipLevels, desc.DepthOrArraySize);
                commandList.ResolveSubresource(pTemp, index, pSource, index, fmt);
            end;
        end;

        copySource := pTemp;
        beforeState := D3D12_RESOURCE_STATE_RESOLVE_DEST;
    end
    else
    begin
        beforeStateSource := D3D12_RESOURCE_STATE_COPY_SOURCE;
    end;

    // Create a staging texture
    Result := device.CreateCommittedResource(@readBackHeapProperties, D3D12_HEAP_FLAG_NONE, @bufferDesc, D3D12_RESOURCE_STATE_COPY_DEST, nil, @IID_ID3D12Resource, pStaging);
    if (FAILED(Result)) then
    begin
        pStaging := nil;

        Exit;
    end;

    SetDebugObjectName(pStaging, 'ScreenGrab staging');

    // Transition the resource if necessary
    TransitionResource(commandList, copySource, beforeState, D3D12_RESOURCE_STATE_COPY_SOURCE);

    // Get the copy target location

    bufferFootprint.Footprint.Width := UINT(desc.Width);
    bufferFootprint.Footprint.Height := desc.Height;
    bufferFootprint.Footprint.Depth := 1;
    bufferFootprint.Footprint.RowPitch := UINT(srcPitch);
    bufferFootprint.Footprint.Format := desc.Format;

    copyDest.InitFootprint(PID3D12Resource(pStaging), bufferFootprint);
    copySrc.Init(PID3D12Resource(copySource), 0);

    // Copy the texture
    commandList.CopyTextureRegion(@copyDest, 0, 0, 0, @copySrc, nil);

    // Transition the source resource to the next state
    TransitionResource(commandList, pSource, beforeStateSource, afterState);

    Result := commandList.Close();
    if (FAILED(Result)) then
    begin
        pStaging := nil;
        exit;
    end;

    // Execute the command list
    pCommandQ.ExecuteCommandLists(1, PID3D12CommandList(commandList));

    // Signal the fence
    Result := pCommandQ.Signal(fence, 1);
    if (FAILED(Result)) then
    begin
        pStaging := nil;
        exit;
    end;

    // Block until the copy is complete
    while (fence.GetCompletedValue() < 1) do
        SwitchToThread();

    Result := S_OK;
end;



function SaveDDSTextureToFile(pCommandQueue: ID3D12CommandQueue; pSource: ID3D12Resource; fileName: pwidechar; beforeState: TD3D12_RESOURCE_STATES; afterState: TD3D12_RESOURCE_STATES): HRESULT;
var

    device: ID3D12Device;
    desc: TD3D12_RESOURCE_DESC;
    totalResourceSize: uint64 = 0;
    fpRowPitch: uint64 = 0;
    fpRowCount: UINT = 0;
    dstRowPitch: uint64;
    pStaging: ID3D12Resource;
    hFile: TScopedHandle;

    fileHeader: array [0..DDS_DX10_HEADER_SIZE - 1] of uint8;
    header: PDDS_HEADER;
    headerSize: size_t;
    extHeader: PDDS_HEADER_DXT10 = nil;
    rowPitch, slicePitch, rowCount: size_t;

    imageSize: uint64;
    pMappedMemory: Pointer = nil;
    pixels: pbyte;

    readRange: TD3D12_RANGE;
    writeRange: TD3D12_RANGE;

    sptr: Puint8;
    dptr: Puint8;

    msize: size_t;
    h: size_t;

    delonfail: TAutoDeleteFile;

    bytesWritten: DWORD;
begin

    Result := E_INVALIDARG;
    if (fileName = '') then
        Exit;


    pCommandQueue.GetDevice(@IID_ID3D12Device, device);

    // Get the size of the image
    pSource.GetDesc(@desc);


    if (desc.Width > UINT32_MAX) then
        Exit;


    // Get the rowcount, pitch and size of the top mip
    device.GetCopyableFootprints(@desc,
        0,
        1,
        0,
        nil, @fpRowCount, @fpRowPitch, @totalResourceSize);

    {$IFDEF XBOX}
    // Round up the srcPitch to multiples of 1024
    dstRowPitch := (fpRowPitch + uint64(D3D12XBOX_TEXTURE_DATA_PITCH_ALIGNMENT) - 1) AND not(uint64(D3D12XBOX_TEXTURE_DATA_PITCH_ALIGNMENT) - 1);
    {$ELSE}
    // Round up the srcPitch to multiples of 256
    dstRowPitch := (fpRowPitch + 255) and not $FF;
    {$ENDIF}

    if (dstRowPitch > UINT32_MAX) then
    begin
        Result := HRESULT_FROM_WIN32(ERROR_ARITHMETIC_OVERFLOW);
        Exit;
    end;


    Result := CaptureTexture(device, pCommandQueue, pSource, dstRowPitch, desc, pStaging, beforeState, afterState);
    if (FAILED(Result)) then
        Exit;

    // Create file
    hFile := safe_handle(CreateFile2(fileName, GENERIC_WRITE, 0, CREATE_ALWAYS, nil));
    if (hFile = 0) then
    begin
        Result := HRESULT_FROM_WIN32(GetLastError());
        Exit;
    end;

    delonfail := TAutoDeleteFile.Create(hFile);


    // Setup header


    (Puint32(@fileHeader[0]))^ := DDS_MAGIC;

    header := PDDS_HEADER(@fileHeader[0] + sizeof(uint32));
    headerSize := DDS_MIN_HEADER_SIZE;
    header.size := sizeof(TDDS_HEADER);
    header.flags := DDS_HEADER_FLAGS_TEXTURE or DDS_HEADER_FLAGS_MIPMAP;
    header.Height := desc.Height;
    header.Width := uint32(desc.Width);
    header.mipMapCount := 1;
    header.caps := DDS_SURFACE_FLAGS_TEXTURE;

    // Try to use a legacy .DDS pixel format for better tools support, otherwise fallback to 'DX10' header extension

    case (desc.Format) of

        DXGI_FORMAT_R8G8B8A8_UNORM: begin
            memcpy(@header.ddspf, @DDSPF_A8B8G8R8, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_R16G16_UNORM: begin
            memcpy(@header.ddspf, @DDSPF_G16R16, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_R8G8_UNORM: begin
            memcpy(@header.ddspf, @DDSPF_A8L8, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_R16_UNORM: begin
            memcpy(@header.ddspf, @DDSPF_L16, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_R8_UNORM: begin
            memcpy(@header.ddspf, @DDSPF_L8, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_A8_UNORM: begin
            memcpy(@header.ddspf, @DDSPF_A8, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_R8G8_B8G8_UNORM: begin
            memcpy(@header.ddspf, @DDSPF_R8G8_B8G8, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_G8R8_G8B8_UNORM: begin
            memcpy(@header.ddspf, @DDSPF_G8R8_G8B8, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_BC1_UNORM: begin
            memcpy(@header.ddspf, @DDSPF_DXT1, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_BC2_UNORM: begin
            memcpy(@header.ddspf, @DDSPF_DXT3, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_BC3_UNORM: begin
            memcpy(@header.ddspf, @DDSPF_DXT5, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_BC4_UNORM: begin
            memcpy(@header.ddspf, @DDSPF_BC4_UNORM, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_BC4_SNORM: begin
            memcpy(@header.ddspf, @DDSPF_BC4_SNORM, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_BC5_UNORM: begin
            memcpy(@header.ddspf, @DDSPF_BC5_UNORM, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_BC5_SNORM: begin
            memcpy(@header.ddspf, @DDSPF_BC5_SNORM, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_B5G6R5_UNORM: begin
            memcpy(@header.ddspf, @DDSPF_R5G6B5, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_B5G5R5A1_UNORM: begin
            memcpy(@header.ddspf, @DDSPF_A1R5G5B5, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_R8G8_SNORM: begin
            memcpy(@header.ddspf, @DDSPF_V8U8, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_R8G8B8A8_SNORM: begin
            memcpy(@header.ddspf, @DDSPF_Q8W8V8U8, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_R16G16_SNORM: begin
            memcpy(@header.ddspf, @DDSPF_V16U16, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_B8G8R8A8_UNORM: begin
            memcpy(@header.ddspf, @DDSPF_A8R8G8B8, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_B8G8R8X8_UNORM: begin
            memcpy(@header.ddspf, @DDSPF_X8R8G8B8, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_YUY2: begin
            memcpy(@header.ddspf, @DDSPF_YUY2, sizeof(TDDS_PIXELFORMAT));
        end;
        DXGI_FORMAT_B4G4R4A4_UNORM: begin
            memcpy(@header.ddspf, @DDSPF_A4R4G4B4, sizeof(TDDS_PIXELFORMAT));
        end;

        // Legacy D3DX formats using D3DFMT enum value as FourCC
        DXGI_FORMAT_R32G32B32A32_FLOAT: begin
            header.ddspf.size := sizeof(TDDS_PIXELFORMAT);
            header.ddspf.flags := DDS_FOURCC;
            header.ddspf.fourCC := 116;
        end; // D3DFMT_A32B32G32R32F
        DXGI_FORMAT_R16G16B16A16_FLOAT: begin
            header.ddspf.size := sizeof(TDDS_PIXELFORMAT);
            header.ddspf.flags := DDS_FOURCC;
            header.ddspf.fourCC := 113;
        end; // D3DFMT_A16B16G16R16F
        DXGI_FORMAT_R16G16B16A16_UNORM: begin
            header.ddspf.size := sizeof(TDDS_PIXELFORMAT);
            header.ddspf.flags := DDS_FOURCC;
            header.ddspf.fourCC := 36;
        end; // D3DFMT_A16B16G16R16
        DXGI_FORMAT_R16G16B16A16_SNORM: begin
            header.ddspf.size := sizeof(TDDS_PIXELFORMAT);
            header.ddspf.flags := DDS_FOURCC;
            header.ddspf.fourCC := 110;
        end; // D3DFMT_Q16W16V16U16
        DXGI_FORMAT_R32G32_FLOAT: begin
            header.ddspf.size := sizeof(TDDS_PIXELFORMAT);
            header.ddspf.flags := DDS_FOURCC;
            header.ddspf.fourCC := 115;
        end; // D3DFMT_G32R32F
        DXGI_FORMAT_R16G16_FLOAT: begin
            header.ddspf.size := sizeof(TDDS_PIXELFORMAT);
            header.ddspf.flags := DDS_FOURCC;
            header.ddspf.fourCC := 112;
        end; // D3DFMT_G16R16F
        DXGI_FORMAT_R32_FLOAT: begin
            header.ddspf.size := sizeof(TDDS_PIXELFORMAT);
            header.ddspf.flags := DDS_FOURCC;
            header.ddspf.fourCC := 114;
        end; // D3DFMT_R32F
        DXGI_FORMAT_R16_FLOAT: begin
            header.ddspf.size := sizeof(TDDS_PIXELFORMAT);
            header.ddspf.flags := DDS_FOURCC;
            header.ddspf.fourCC := 111;
        end; // D3DFMT_R16F

        DXGI_FORMAT_AI44,
        DXGI_FORMAT_IA44,
        DXGI_FORMAT_P8,
        DXGI_FORMAT_A8P8:
        begin
            DebugTrace('ERROR: ScreenGrab does not support video textures. Consider using DirectXTex.\n', []);
            Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
            Exit;
        end;
        else
        begin
            memcpy(@header.ddspf, @DDSPF_DX10, sizeof(TDDS_PIXELFORMAT));

            headerSize := headerSize + sizeof(TDDS_HEADER_DXT10);
            extHeader := PDDS_HEADER_DXT10(@fileHeader[0] + DDS_MIN_HEADER_SIZE);
            extHeader.dxgiFormat := desc.Format;
            extHeader.resourceDimension := Ord(D3D12_RESOURCE_DIMENSION_TEXTURE2D);
            extHeader.arraySize := 1;
        end;
    end;


    Result := GetSurfaceInfo(size_t(desc.Width), desc.Height, desc.Format, @slicePitch, @rowPitch, @rowCount);
    if (FAILED(Result)) then
        Exit;

    if (rowPitch > UINT32_MAX) or (slicePitch > UINT32_MAX) then
    begin
        Result := HRESULT_FROM_WIN32(ERROR_ARITHMETIC_OVERFLOW);
        Exit;
    end;

    if (IsCompressed(desc.Format)) then
    begin
        header.flags := header.flags or DDS_HEADER_FLAGS_LINEARSIZE;
        header.pitchOrLinearSize := uint32(slicePitch);
    end
    else
    begin
        header.flags := header.flags or DDS_HEADER_FLAGS_PITCH;
        header.pitchOrLinearSize := uint32(rowPitch);
    end;

    // Setup pixels
    GetMem(pixels, slicePitch);
    if (pixels = nil) then
    begin
        Result := E_OUTOFMEMORY;
        Exit;
    end;
    assert(fpRowCount = rowCount);
    assert(fpRowPitch = rowPitch);

    imageSize := dstRowPitch * uint64(rowCount);
    if (imageSize > UINT32_MAX) then
    begin
        Result := HRESULT_FROM_WIN32(ERROR_ARITHMETIC_OVERFLOW);
        Exit;
    end;

    readRange.Init(0, SIZE_T(imageSize));
    writeRange.Init(0, 0);
    Result := pStaging.Map(0, @readRange, pMappedMemory);
    if (FAILED(Result)) then
        Exit;

    sptr := Puint8(pMappedMemory);
    if (sptr = nil) then
    begin
        pStaging.Unmap(0, @writeRange);
        Result := E_POINTER;
        Exit;
    end;

    dptr := pixels;

    msize := min(rowPitch, size_t(dstRowPitch));
    for h := 0 to rowCount - 1 do
    begin
        memcpy(dptr, sptr, msize);
        sptr := sptr + dstRowPitch;
        dptr := dptr + rowPitch;
    end;

    pStaging.Unmap(0, @writeRange);

    // Write header & pixels

    if (not WriteFile(hFile, @fileHeader[0], DWORD(headerSize), @bytesWritten, nil)) then
    begin
        Result := HRESULT_FROM_WIN32(GetLastError());
        Exit;
    end;
    if (bytesWritten <> headerSize) then
    begin
        Result := E_FAIL;
        Exit;
    end;

    if (not WriteFile(hFile, pixels, DWORD(slicePitch), @bytesWritten, nil)) then
    begin
        Result := HRESULT_FROM_WIN32(GetLastError());
        Exit;
    end;

    if (bytesWritten <> slicePitch) then
    begin
        Result := E_FAIL;
        Exit;
    end;

    delonfail.Clear();

    Result := S_OK;
end;



function SaveWICTextureToFile(pCommandQ: ID3D12CommandQueue; pSource: ID3D12Resource; guidContainerFormat: REFGUID; fileName: pwidechar; beforeState: TD3D12_RESOURCE_STATES;
    afterState: TD3D12_RESOURCE_STATES; targetFormat: REFGUID; setCustomProps: TSetCustomProps; forceSRGB: winbool): HRESULT;
var

    device: ID3D12Device;
    desc: TD3D12_RESOURCE_DESC;
    totalResourceSize: uint64 = 0;
    fpRowPitch: uint64 = 0;
    fpRowCount: UINT = 0;
    dstRowPitch: uint64;
    pStaging: ID3D12Resource;
    pfGuid: TWICPixelFormatGUID;
    sRGB: boolean;

    pWIC: IWICImagingFactory2;
    stream: IWICStream;
    delonfail: TAutoDeleteFileWIC;
    encoder: IWICBitmapEncoder;
    frame: IWICBitmapFrameEncode;
    props: IPropertyBag2;
    varValue: TVARIANT;
    option: TPROPBAG2;
    targetGuid: TWICPixelFormatGUID;
    metawriter: IWICMetadataQueryWriter;

    Value: TPROPVARIANT;
    imageSize: uint64;
    pMappedMemory: pointer = nil;

    readRange: TD3D12_RANGE;
    writeRange: TD3D12_RANGE;

    Source: IWICBitmap;
    FC: IWICFormatConverter;
    canConvert: winBOOL = False;

    rect: TWICRect;
begin
    Result := E_INVALIDARG;
    if (fileName = '') then
        Exit;


    pCommandQ.GetDevice(@IID_ID3D12Device, device);

    // Get the size of the image
    pSource.GetDesc(@desc);


    if (desc.Width > UINT32_MAX) then
        Exit;


    // Get the rowcount, pitch and size of the top mip
    device.GetCopyableFootprints(@desc,
        0,
        1,
        0,
        nil, @fpRowCount, @fpRowPitch, @totalResourceSize);

    {$IFDEF XBOX}
    // Round up the srcPitch to multiples of 1024
    dstRowPitch := (fpRowPitch + uint64(D3D12XBOX_TEXTURE_DATA_PITCH_ALIGNMENT) - 1) and not(uint64(D3D12XBOX_TEXTURE_DATA_PITCH_ALIGNMENT) - 1);
    {$ELSE}
    // Round up the srcPitch to multiples of 256 (D3D12_TEXTURE_DATA_PITCH_ALIGNMENT)
    dstRowPitch := (fpRowPitch + 255) and not $FF;
    {$ENDIF}

    if (dstRowPitch > UINT32_MAX) then
    begin
        Result := HRESULT_FROM_WIN32(ERROR_ARITHMETIC_OVERFLOW);
        Exit;
    end;


    Result := CaptureTexture(device, pCommandQ, pSource, dstRowPitch, desc, pStaging, beforeState, afterState);
    if (FAILED(Result)) then
        Exit;

    // Determine source format's WIC equivalent

    sRGB := forceSRGB;
    case (desc.Format) of

        DXGI_FORMAT_R32G32B32A32_FLOAT: begin
            pfGuid := GUID_WICPixelFormat128bppRGBAFloat;
        end;
        DXGI_FORMAT_R16G16B16A16_FLOAT: begin
            pfGuid := GUID_WICPixelFormat64bppRGBAHalf;
        end;
        DXGI_FORMAT_R16G16B16A16_UNORM: begin
            pfGuid := GUID_WICPixelFormat64bppRGBA;
        end;
        DXGI_FORMAT_R10G10B10_XR_BIAS_A2_UNORM: begin
            pfGuid := GUID_WICPixelFormat32bppRGBA1010102XR;
        end;
        DXGI_FORMAT_R10G10B10A2_UNORM: begin
            pfGuid := GUID_WICPixelFormat32bppRGBA1010102;
        end;
        DXGI_FORMAT_B5G5R5A1_UNORM: begin
            pfGuid := GUID_WICPixelFormat16bppBGRA5551;
        end;
        DXGI_FORMAT_B5G6R5_UNORM: begin
            pfGuid := GUID_WICPixelFormat16bppBGR565;
        end;
        DXGI_FORMAT_R32_FLOAT: begin
            pfGuid := GUID_WICPixelFormat32bppGrayFloat;
        end;
        DXGI_FORMAT_R16_FLOAT: begin
            pfGuid := GUID_WICPixelFormat16bppGrayHalf;
        end;
        DXGI_FORMAT_R16_UNORM: begin
            pfGuid := GUID_WICPixelFormat16bppGray;
        end;
        DXGI_FORMAT_R8_UNORM: begin
            pfGuid := GUID_WICPixelFormat8bppGray;
        end;
        DXGI_FORMAT_A8_UNORM: begin
            pfGuid := GUID_WICPixelFormat8bppAlpha;
        end;

        DXGI_FORMAT_R8G8B8A8_UNORM: begin
            pfGuid := GUID_WICPixelFormat32bppRGBA;
        end;

        DXGI_FORMAT_R8G8B8A8_UNORM_SRGB: begin
            pfGuid := GUID_WICPixelFormat32bppRGBA;
            sRGB := True;
        end;

        DXGI_FORMAT_B8G8R8A8_UNORM: begin
            pfGuid := GUID_WICPixelFormat32bppBGRA;
        end;

        DXGI_FORMAT_B8G8R8A8_UNORM_SRGB: begin
            pfGuid := GUID_WICPixelFormat32bppBGRA;
            sRGB := True;
        end;

        DXGI_FORMAT_B8G8R8X8_UNORM: begin
            pfGuid := GUID_WICPixelFormat32bppBGR;
        end;

        DXGI_FORMAT_B8G8R8X8_UNORM_SRGB: begin
            pfGuid := GUID_WICPixelFormat32bppBGR;
            sRGB := True;
        end;

        else
        begin
            DebugTrace('ERROR: ScreenGrab does not support all DXGI formats (%u). Consider using DirectXTex.\n', [uint32(desc.Format)]);
            Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
            Exit;
        end;
    end;

    pWIC := GetWIC();
    if (pWIC = nil) then
    begin
        Result := E_NOINTERFACE;
        Exit;
    end;


    Result := pWIC.CreateStream(stream);
    if (FAILED(Result)) then
        Exit;

    Result := stream.InitializeFromFilename(fileName, GENERIC_WRITE);
    if (FAILED(Result)) then
        Exit;

    delonfail := TAutoDeleteFileWIC.Create(stream, fileName);


    Result := pWIC.CreateEncoder(guidContainerFormat, nil, encoder);
    if (FAILED(Result)) then
        Exit;

    Result := encoder.Initialize(stream, WICBitmapEncoderNoCache);
    if (FAILED(Result)) then
        Exit;


    Result := encoder.CreateNewFrame(frame, props);
    if (FAILED(Result)) then
        Exit;

    if (targetFormat <> nil) and (memcmp(@guidContainerFormat, @GUID_ContainerFormatBmp, sizeof(TWICPixelFormatGUID)) = 0) then
    begin
        // Opt-in to the WIC2 support for writing 32-bit Windows BMP files with an alpha channel
        option.pstrName := pwchar('EnableV5Header32bppBGRA');


        varValue.vt := Ord(VT_BOOL);
        varValue.boolVal := VARIANT_TRUE;
        props.Write(1, @option, @varValue);
    end;

    if (@setCustomProps <> nil) then
    begin
        setCustomProps(props);
    end;

    Result := frame.Initialize(props);
    if (FAILED(Result)) then
        Exit;

    Result := frame.SetSize(UINT(desc.Width), desc.Height);
    if (FAILED(Result)) then
        Exit;

    Result := frame.SetResolution(72, 72);
    if (FAILED(Result)) then
        Exit;

    // Pick a target format

    if (targetFormat <> nil) then
    begin
        targetGuid := targetFormat^;
    end
    else
    begin
        // Screenshots don't typically include the alpha channel of the render target
        case (desc.Format) of

            DXGI_FORMAT_R32G32B32A32_FLOAT,
            DXGI_FORMAT_R16G16B16A16_FLOAT:
            begin
                targetGuid := GUID_WICPixelFormat96bppRGBFloat; // WIC 2
            end;

            DXGI_FORMAT_R16G16B16A16_UNORM: begin
                targetGuid := GUID_WICPixelFormat48bppBGR;
            end;
            DXGI_FORMAT_B5G5R5A1_UNORM: begin
                targetGuid := GUID_WICPixelFormat16bppBGR555;
            end;
            DXGI_FORMAT_B5G6R5_UNORM: begin
                targetGuid := GUID_WICPixelFormat16bppBGR565;
            end;

            DXGI_FORMAT_R32_FLOAT,
            DXGI_FORMAT_R16_FLOAT,
            DXGI_FORMAT_R16_UNORM,
            DXGI_FORMAT_R8_UNORM,
            DXGI_FORMAT_A8_UNORM: begin
                targetGuid := GUID_WICPixelFormat8bppGray;
            end;

            else
            begin
                targetGuid := GUID_WICPixelFormat24bppBGR;
            end;
        end;
    end;

    Result := frame.SetPixelFormat(@targetGuid);
    if (FAILED(Result)) then
        Exit;

    if (targetFormat <> nil) and (memcmp(targetFormat, @targetGuid, sizeof(TWICPixelFormatGUID)) <> 0) then
    begin
        // Requested output pixel format is not supported by the WIC codec
        Result := E_FAIL;
        Exit;
    end;

    // Encode WIC metadata

    if (SUCCEEDED(frame.GetMetadataQueryWriter(metawriter))) then
    begin

        PropVariantInit(@Value);

        Value.vt := Ord(VT_LPSTR);
        Value.pszVal := pansichar('DirectXTK');

        if (memcmp(@guidContainerFormat, @GUID_ContainerFormatPng, sizeof(TGUID)) = 0) then
        begin
            // Set Software name
            metawriter.SetMetadataByName('/tEXt/{str:=Software}', @Value);

            // Set sRGB chunk
            if (sRGB) then
            begin
                Value.vt := Ord(VT_UI1);
                Value.bVal := 0;
                metawriter.SetMetadataByName('/sRGB/RenderingIntent', @Value);
            end
            else
            begin
                // add gAMA chunk with gamma 1.0
                Value.vt := Ord(VT_UI4);
                Value.uintVal := 100000; // gama value * 100,000 -- i.e. gamma 1.0
                metawriter.SetMetadataByName('/gAMA/ImageGamma', @Value);

                // remove sRGB chunk which is added by default.
                metawriter.RemoveMetadataByName('/sRGB/RenderingIntent');
            end;
        end
        {$IFDEF XBOX}
        else if (memcmp(@guidContainerFormat, @GUID_ContainerFormatJpeg, sizeof(TGUID)) = 0)     then
        begin
            // Set Software name
             metawriter.SetMetadataByName('/app1/ifd/{ushort:=305}', @value);

            if (sRGB)      then
            begin
                // Set EXIF Colorspace of sRGB
                value.vt := VT_UI2;
                value.uiVal := 1;
                 metawriter.SetMetadataByName('/app1/ifd/exif/{ushort:=40961}', @value);
            end;
        end
        else if (memcmp(@guidContainerFormat, @GUID_ContainerFormatTiff, sizeof(TGUID)) = 0)  then
        begin
            // Set Software name
             metawriter.SetMetadataByName('/ifd/{ushort:=305}', @value);

            if (sRGB)   then
            begin
                // Set EXIF Colorspace of sRGB
                value.vt := VT_UI2;
                value.uiVal := 1;
                 metawriter.SetMetadataByName('/ifd/exif/{ushort:=40961}', @value);
            end;
        end
        {$ELSE}
        else
        begin
            // Set Software name
            metawriter.SetMetadataByName('System.ApplicationName', @Value);

            if (sRGB) then
            begin
                // Set EXIF Colorspace of sRGB
                Value.vt := Ord(VT_UI2);
                Value.uiVal := 1;
                metawriter.SetMetadataByName('System.Image.ColorSpace', @Value);
            end;
        end;
        {$ENDIF}
    end;

    imageSize := dstRowPitch * uint64(desc.Height);
    if (imageSize > UINT32_MAX) then
    begin
        Result := HRESULT_FROM_WIN32(ERROR_ARITHMETIC_OVERFLOW);
        exit;
    end;


    readRange.Init(0, SIZE_T(imageSize));
    writeRange.Init(0, 0);
    Result := pStaging.Map(0, @readRange, pMappedMemory);
    if (FAILED(Result)) then
        Exit;

    if (memcmp(@targetGuid, @pfGuid, sizeof(TWICPixelFormatGUID)) <> 0) then
    begin
        // Conversion required to write

        Result := pWIC.CreateBitmapFromMemory(UINT(desc.Width), desc.Height, @pfGuid, UINT(dstRowPitch), UINT(imageSize), pbyte(pMappedMemory), Source);
        if (FAILED(Result)) then
        begin
            pStaging.Unmap(0, @writeRange);
            Exit;
        end;


        Result := pWIC.CreateFormatConverter(FC);
        if (FAILED(Result)) then
        begin
            pStaging.Unmap(0, @writeRange);
            Exit;
        end;


        Result := FC.CanConvert(@pfGuid, @targetGuid, @canConvert);
        if (FAILED(Result) or not canConvert) then
        begin
            pStaging.Unmap(0, @writeRange);
            Result := E_UNEXPECTED;
            Exit;
        end;

        Result := FC.Initialize(Source, @targetGuid, WICBitmapDitherTypeNone, nil, 0, WICBitmapPaletteTypeMedianCut);
        if (FAILED(Result)) then
        begin
            pStaging.Unmap(0, @writeRange);
            Exit;
        end;

        rect.Init(0, 0, int32(desc.Width), int32(desc.Height));
        Result := frame.WriteSource(FC, @rect);
    end
    else
    begin
        // No conversion required
        Result := frame.WritePixels(desc.Height, UINT(dstRowPitch), UINT(imageSize), pbyte(pMappedMemory));
    end;

    pStaging.Unmap(0, @writeRange);

    if (FAILED(Result)) then
        exit;

    Result := frame.Commit();
    if (FAILED(Result)) then
        Exit;

    Result := encoder.Commit();
    if (FAILED(Result)) then
        Exit;

    delonfail.Clear();

    Result := S_OK;
end;


end.
