//--------------------------------------------------------------------------------------
// File: BufferHelpers.h
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------
unit DX12TK.BufferHelpers;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.DXGIFormat,
    DX12.D3D12,
    DX12TK.ResourceUploadBatch;

// Helpers for creating initialized Direct3D buffer resources.
function CreateStaticBuffer(
    {_In_ } device: ID3D12Device; resourceUpload: TResourceUploadBatch;
    {_In_reads_bytes_(count* stride) } ptr: Pvoid; Count: size_t; stride: size_t; afterState: TD3D12_RESOURCE_STATES;
    {_COM_Outptr_ }  out pBuffer: ID3D12Resource; resFlags: TD3D12_RESOURCE_FLAGS = D3D12_RESOURCE_FLAG_NONE): HRESULT;

function CreateUAVBuffer(
    {_In_ } device: ID3D12Device; bufferSize: uint64;
    {_COM_Outptr_ }  out pBuffer: ID3D12Resource; initialState: TD3D12_RESOURCE_STATES = D3D12_RESOURCE_STATE_COMMON; additionalResFlags: TD3D12_RESOURCE_FLAGS = D3D12_RESOURCE_FLAG_NONE): HRESULT;


function CreateUploadBuffer(
    {_In_ } device: ID3D12Device;
    {_In_reads_bytes_opt_(count* stride) } ptr: Pvoid; Count: size_t; stride: size_t;
    {_COM_Outptr_ }  out pBuffer: ID3D12Resource; resFlags: TD3D12_RESOURCE_FLAGS = D3D12_RESOURCE_FLAG_NONE): HRESULT;


// Helpers for creating texture from memory arrays.

function CreateTextureFromMemory(
    {_In_ } device: ID3D12Device; resourceUpload: TResourceUploadBatch; Width: size_t; format: TDXGI_FORMAT; initData: TD3D12_SUBRESOURCE_DATA;
    {_COM_Outptr_ }  out texture: ID3D12Resource; afterState: TD3D12_RESOURCE_STATES = D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE; resFlags: TD3D12_RESOURCE_FLAGS = D3D12_RESOURCE_FLAG_NONE): HRESULT;


function CreateTextureFromMemory(
    {_In_ } device: ID3D12Device; resourceUpload: TResourceUploadBatch; Width: size_t; Height: size_t; format: TDXGI_FORMAT; initData: TD3D12_SUBRESOURCE_DATA;
    {_COM_Outptr_ }  out texture: ID3D12Resource; generateMips: boolean = False; afterState: TD3D12_RESOURCE_STATES = D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE; resFlags: TD3D12_RESOURCE_FLAGS = D3D12_RESOURCE_FLAG_NONE): HRESULT;


function CreateTextureFromMemory(
    {_In_ } device: ID3D12Device; resourceUpload: TResourceUploadBatch; Width: size_t; Height: size_t; depth: size_t; format: TDXGI_FORMAT; initData: TD3D12_SUBRESOURCE_DATA;
    {_COM_Outptr_ }  out texture: ID3D12Resource; afterState: TD3D12_RESOURCE_STATES = D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE; resFlags: TD3D12_RESOURCE_FLAGS = D3D12_RESOURCE_FLAG_NONE): HRESULT;


implementation

//------------------------------------- -------------------------------------------------
// File: BufferHelpers.cpp
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------

uses
    Windows.Macros,
    DX12.D3DX12_Core,
    DX12TK.PlatformHelpers,
    DX12TK.LoaderHelpers,
    DX12TK.DirectXHelpers;



function CreateStaticBuffer(device: ID3D12Device; resourceUpload: TResourceUploadBatch; ptr: Pvoid; Count: size_t; stride: size_t; afterState: TD3D12_RESOURCE_STATES; out pBuffer: ID3D12Resource; resFlags: TD3D12_RESOURCE_FLAGS): HRESULT;
var
    sizeInbytes: uint64;
    c_maxBytes: uint64;
    desc: TD3D12_RESOURCE_DESC;
    heapProperties: TD3D12_HEAP_PROPERTIES;
    res: ID3D12Resource;
    initData: TD3D12_SUBRESOURCE_DATA;
begin
    Result := E_INVALIDARG;

    pBuffer := nil;

    if (device = nil) or (ptr = nil) or (Count = 0) or (stride = 0) then
        Exit;

    sizeInbytes := uint64(Count) * uint64(stride);

    c_maxBytes := D3D12_REQ_RESOURCE_SIZE_IN_MEGABYTES_EXPRESSION_A_TERM * 1024 * 1024;

    if (sizeInbytes > c_maxBytes) then
    begin
        DebugTrace('ERROR: Resource size too large for DirectX 12 (size %llu)\n', [sizeInbytes]);
        Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
        Exit;
    end;

    desc.Buffer(sizeInbytes, resFlags);

    Result := device.CreateCommittedResource(@heapProperties, D3D12_HEAP_FLAG_NONE, @desc, c_initialCopyTargetState, nil, @IID_ID3D12Resource, res);
    if (FAILED(Result)) then
        Exit;

    initData.Init(ptr, 0, 0);

    try
        resourceUpload.Upload(res, 0, @initData, 1);
        resourceUpload.Transition(res, D3D12_RESOURCE_STATE_COPY_DEST, afterState);
    except
        Result := E_FAIL;
        Exit;
    end;

    pBuffer := res;

    Result := S_OK;
end;



function CreateUAVBuffer(device: ID3D12Device; bufferSize: uint64; out pBuffer: ID3D12Resource; initialState: TD3D12_RESOURCE_STATES; additionalResFlags: TD3D12_RESOURCE_FLAGS): HRESULT;
var
    c_maxBytes: uint64;
    desc: TD3D12_RESOURCE_DESC;
    heapProperties: TD3D12_HEAP_PROPERTIES;
    res: ID3D12Resource;
begin
    Result := E_INVALIDARG;

    pBuffer := nil;

    if (device = nil) or (bufferSize = 0) then
        Exit;


    c_maxBytes := D3D12_REQ_RESOURCE_SIZE_IN_MEGABYTES_EXPRESSION_A_TERM * 1024 * 1024;

    if (bufferSize > c_maxBytes) then
    begin
        DebugTrace('ERROR: Resource size too large for DirectX 12 (size %llu)\n', [bufferSize]);
        Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
        Exit;
    end;

    desc.Buffer(bufferSize, TD3D12_RESOURCE_FLAGS(Ord(D3D12_RESOURCE_FLAG_ALLOW_UNORDERED_ACCESS) or Ord(additionalResFlags)));


    Result := device.CreateCommittedResource(@heapProperties, D3D12_HEAP_FLAG_NONE, @desc, initialState, nil, @IID_ID3D12Resource, res);
    if (FAILED(Result)) then
        Exit;

    pBuffer := res;

    Result := S_OK;
end;



function CreateUploadBuffer(device: ID3D12Device; ptr: Pvoid; Count: size_t; stride: size_t; out pBuffer: ID3D12Resource; resFlags: TD3D12_RESOURCE_FLAGS): HRESULT;
var
    sizeInbytes: uint64;
    c_maxBytes: uint64;
    desc: TD3D12_RESOURCE_DESC;
    heapProperties: TD3D12_HEAP_PROPERTIES;
    res: ID3D12Resource;
    mappedPtr: pointer;
begin
    Result := E_INVALIDARG;

    pBuffer := nil;

    if (device = nil) or (Count = 0) or (stride = 0) then
        Exit;

    sizeInbytes := uint64(Count) * uint64(stride);

    c_maxBytes := D3D12_REQ_RESOURCE_SIZE_IN_MEGABYTES_EXPRESSION_A_TERM * 1024 * 1024;

    if (sizeInbytes > c_maxBytes) then
    begin
        DebugTrace('ERROR: Resource size too large for DirectX 12 (size %llu)\n', [sizeInbytes]);
        Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
        Exit;
    end;

    desc.Buffer(sizeInbytes, resFlags);


    Result := device.CreateCommittedResource(@heapProperties, D3D12_HEAP_FLAG_NONE, @desc, D3D12_RESOURCE_STATE_GENERIC_READ, nil, @IID_ID3D12Resource, res);
    if (FAILED(Result)) then
        Exit;


    if (ptr <> nil) then
    begin
        mappedPtr := nil;
        Result := res.Map(0, nil, mappedPtr);
        if (FAILED(Result)) then
            exit;
        Move(ptr^, mappedPtr^, sizeInbytes);
        res.Unmap(0, nil);
    end;

    pBuffer := res;

    Result := S_OK;
end;



function CreateTextureFromMemory(device: ID3D12Device; resourceUpload: TResourceUploadBatch; Width: size_t; format: TDXGI_FORMAT; initData: TD3D12_SUBRESOURCE_DATA; out texture: ID3D12Resource;
    afterState: TD3D12_RESOURCE_STATES; resFlags: TD3D12_RESOURCE_FLAGS): HRESULT;
var
    desc: TD3D12_RESOURCE_DESC;
    heapProperties: TD3D12_HEAP_PROPERTIES;
    res: ID3D12Resource;
begin
    Result := E_INVALIDARG;

    texture := nil;

    if (device = nil) or (Width = 0) or (initData.pData = nil) then
        Exit;

    // assert(D3D12_REQ_TEXTURE1D_U_DIMENSION <= UINT64_MAX, 'Exceeded integer limits');

    if (Width > D3D12_REQ_TEXTURE1D_U_DIMENSION) then
    begin
        DebugTrace('ERROR: Resource dimensions too large for DirectX 12 (1D: size %zu)\n', [Width]);
        Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
        Exit;
    end;

    desc.Tex1D(format, uint64(Width), 1, 1, resFlags);


    Result := device.CreateCommittedResource(@heapProperties, D3D12_HEAP_FLAG_NONE, @desc, c_initialCopyTargetState, nil, @IID_ID3D12Resource, res);
    if (FAILED(Result)) then
        Exit;

    try
        begin
            resourceUpload.Upload(res, 0, @initData, 1);

            resourceUpload.Transition(res, D3D12_RESOURCE_STATE_COPY_DEST, afterState);
        end;
    except
        Result := E_FAIL;
        Exit;
    end;

    texture := res;

    Result := S_OK;

end;



function CreateTextureFromMemory(device: ID3D12Device; resourceUpload: TResourceUploadBatch; Width: size_t; Height: size_t; format: TDXGI_FORMAT; initData: TD3D12_SUBRESOURCE_DATA;
    out texture: ID3D12Resource; generateMips: boolean; afterState: TD3D12_RESOURCE_STATES; resFlags: TD3D12_RESOURCE_FLAGS): HRESULT;
var
    mipCount: uint16 = 1;
    desc: TD3D12_RESOURCE_DESC;
    heapProperties: TD3D12_HEAP_PROPERTIES;
    res: ID3D12Resource;
begin
    Result := E_INVALIDARG;

    texture := nil;

    if (device = nil) or (Width = 0) or (Height = 0) or (initData.pData = nil) or (initData.RowPitch = 0) then
        Exit;

    //static_assert(D3D12_REQ_TEXTURE2D_U_OR_V_DIMENSION <= UINT32_MAX, "Exceeded integer limits");

    if ((Width > D3D12_REQ_TEXTURE2D_U_OR_V_DIMENSION)) or ((Height > D3D12_REQ_TEXTURE2D_U_OR_V_DIMENSION)) then
    begin
        DebugTrace('ERROR: Resource dimensions too large for DirectX 12 (2D: size %zu by %zu)\n', [Width, Height]);
        Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
        Exit;
    end;


    if (generateMips) then
    begin
        generateMips := resourceUpload.IsSupportedForGenerateMips(format);
        if (generateMips) then
        begin
            mipCount := uint16(DX12TK.LoaderHelpers.CountMips(uint32(Width), uint32(Height)));
        end;
    end;

    desc.Tex2D(format, uint64(Width), UINT(Height),
        1, mipCount, 1, 0, resFlags);


    Result := device.CreateCommittedResource(@heapProperties, D3D12_HEAP_FLAG_NONE, @desc, c_initialCopyTargetState, nil, @IID_ID3D12Resource, res);
    if (FAILED(Result)) then
        Exit;

    try
        begin
            resourceUpload.Upload(res, 0, @initData, 1);

            resourceUpload.Transition(res, D3D12_RESOURCE_STATE_COPY_DEST, afterState);

            if (generateMips) then
            begin
                resourceUpload.GenerateMips(res);
            end;
        end;
    except
        Result := E_FAIL;
        Exit;
    end;

    texture := res;

    Result := S_OK;

end;



function CreateTextureFromMemory(device: ID3D12Device; resourceUpload: TResourceUploadBatch; Width: size_t; Height: size_t; depth: size_t; format: TDXGI_FORMAT; initData: TD3D12_SUBRESOURCE_DATA;
    out texture: ID3D12Resource; afterState: TD3D12_RESOURCE_STATES; resFlags: TD3D12_RESOURCE_FLAGS): HRESULT;
var
    desc: TD3D12_RESOURCE_DESC;
    heapProperties: TD3D12_HEAP_PROPERTIES;
    res: ID3D12Resource;
begin
    Result := E_INVALIDARG;
    texture := nil;

    if (device = nil) or (Width = 0) or (Height = 0) or (depth = 0) or (initData.pData = nil) or (initData.RowPitch = 0) or (initData.SlicePitch = 0) then
        Exit;

    // static_assert(D3D12_REQ_TEXTURE3D_U_V_OR_W_DIMENSION <= UINT16_MAX, "Exceeded integer limits");

    if ((Width > D3D12_REQ_TEXTURE3D_U_V_OR_W_DIMENSION)) or ((Height > D3D12_REQ_TEXTURE3D_U_V_OR_W_DIMENSION)) or ((depth > D3D12_REQ_TEXTURE3D_U_V_OR_W_DIMENSION)) then
    begin
        DebugTrace('ERROR: Resource dimensions too large for DirectX 12 (3D: size %zu by %zu by %zu)\n', [Width, Height, depth]);
        Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
        Exit;
    end;

    desc.Tex3D(format,
        uint64(Width), UINT(Height), uint16(depth),
        1, resFlags);


    Result := device.CreateCommittedResource(@heapProperties, D3D12_HEAP_FLAG_NONE, @desc, c_initialCopyTargetState, nil, @IID_ID3D12Resource, res);
    if (FAILED(Result)) then
        Exit;

    try
        begin
            resourceUpload.Upload(res, 0, @initData, 1);
            resourceUpload.Transition(res, D3D12_RESOURCE_STATE_COPY_DEST, afterState);
        end;
    except
        Result := E_FAIL;
        Exit;
    end;

    texture := res;

    Result := S_OK;
end;


end.
