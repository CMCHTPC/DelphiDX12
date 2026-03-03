//--------------------------------------------------------------------------------------
// File: GeometricPrimitive.h

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------
unit DX12TK.GeometricPrimitive;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    CStdVector,
    DX12TK.VertexTypes,
    DX12TK.GraphicsMemory,
    DX12TK.ResourceUploadBatch,
    DX12.D3D12;

const
    USHRT_MAX = $ffff;
    UINT32_MAX = $ffffffff;


type

    { TGeometricPrimitive }

    TGeometricPrimitive = class(TObject)
    type
        TVertexType = TVertexPositionNormalTexture;
        TVertexCollection = specialize TCStdVector<TVertexType>;
        TIndexCollection = specialize TCStdVector<uint16>;



    protected
        mIndexCount: UINT;
        mIndexBuffer: TSharedGraphicsResource;
        mVertexBuffer: TSharedGraphicsResource;
        mStaticIndexBuffer: ID3D12Resource;
        mStaticVertexBuffer: ID3D12Resource;
        mVertexBufferView: TD3D12_VERTEX_BUFFER_VIEW;
        mIndexBufferView: TD3D12_INDEX_BUFFER_VIEW;
    public
        constructor Create;
        destructor Destroy; override;

        // Initializes a geometric primitive instance that will draw the specified vertex and index data.
        procedure Initialize(constref vertices: TVertexCollection; constref indices: TIndexCollection; {_In_opt_}  device: ID3D12Device = nil);
        // Load VB/IB resources for static geometry.
        procedure LoadStaticBuffers({_In_}  device: ID3D12Device; resourceUploadBatch: TResourceUploadBatch);
        // Transition VB/IB resources for static geometry.
        procedure Transition({_In_}  commandList: ID3D12GraphicsCommandList; stateBeforeVB: TD3D12_RESOURCE_STATES; stateAfterVB: TD3D12_RESOURCE_STATES; stateBeforeIB: TD3D12_RESOURCE_STATES; stateAfterIB: TD3D12_RESOURCE_STATES);
        // Draws the primitive.
        procedure DrawInstanced({_In_ } commandList: ID3D12GraphicsCommandList; instanceCount: uint32; startInstanceLocation: uint32);
        procedure Draw({_In_ } commandList: ID3D12GraphicsCommandList);

        // Factory methods.

        function CreateCube(size: single = 1; rhcoords: winbool = True;{_In_opt_ } device: ID3D12Device = nil): TGeometricPrimitive;

    end;

implementation

uses
    DX12.D3DCommon,
    DX12TK.Geometry,
    DX12TK.PlatformHelpers,
    DX12TK.DirectXHelpers,
    DX12.DXGIFormat,
    DX12.D3DX12_Core,
    DirectX.Math;

    { TGeometricPrimitive }

    //--------------------------------------------------------------------------------------
    // GeometricPrimitive
    //--------------------------------------------------------------------------------------

// Constructor.
constructor TGeometricPrimitive.Create;
begin
    mIndexCount := 0;
end;


// Destructor.
destructor TGeometricPrimitive.Destroy;
begin
    inherited Destroy;
end;

// Initializes a geometric primitive instance that will draw the specified vertex and index data.

procedure TGeometricPrimitive.Initialize(constref vertices: TVertexCollection; constref indices: TIndexCollection; device: ID3D12Device);
var
    sizeInBytes: uint64;
    vertSizeBytes, indSizeBytes: size_t;
    verts, ind: pbyte;
    tTemp: TGraphicsResource;
begin
    if (vertices.size() >= USHRT_MAX) then
        raise Exception.Create('Too many vertices for 16-bit index buffer');

    if (indices.size() > UINT32_MAX) then
        raise Exception.Create('Too many indices');

    // Vertex data
    sizeInBytes := uint64(vertices.size()) * sizeof(vertices.Item[0]);
    if (sizeInBytes > uint64(D3D12_REQ_RESOURCE_SIZE_IN_MEGABYTES_EXPRESSION_A_TERM * 1024 * 1024)) then
        raise Exception.Create('VB too large for DirectX 12');

    vertSizeBytes := size_t(sizeInBytes);

    tTemp := GraphicsMemory.Get(device).Allocate(vertSizeBytes, 16, Ord(GraphicsMemory.TTag.TAG_VERTEX));
    mVertexBuffer.Assign(tTemp);

    verts := puint8(vertices.Data());
    move(verts, mVertexBuffer.Memory()^, vertSizeBytes);

    // Index data
    sizeInBytes := uint64(indices.size()) * sizeof(indices.Item[0]);
    if (sizeInBytes > uint64(D3D12_REQ_RESOURCE_SIZE_IN_MEGABYTES_EXPRESSION_A_TERM * 1024 * 1024)) then
        raise Exception.Create('IB too large for DirectX 12');

    indSizeBytes := size_t(sizeInBytes);

    tTemp := GraphicsMemory.Get(device).Allocate(indSizeBytes, 16, Ord(GraphicsMemory.TTag.TAG_INDEX));
    mIndexBuffer.Assign(tTemp);

    ind := Puint8(indices.Data());

    //memcpy(mIndexBuffer.Memory(), ind, indSizeBytes);
    move(ind, mIndexBuffer.Memory()^, indSizeBytes);

    // Record index count for draw
    mIndexCount := UINT(indices.size());

    // Create views
    mVertexBufferView.BufferLocation := mVertexBuffer.GpuAddress();
    mVertexBufferView.StrideInBytes := UINT(sizeof(TVertexCollection.TValueType));
    mVertexBufferView.SizeInBytes := UINT(mVertexBuffer.Size());

    mIndexBufferView.BufferLocation := mIndexBuffer.GpuAddress();
    mIndexBufferView.SizeInBytes := UINT(mIndexBuffer.Size());
    mIndexBufferView.Format := DXGI_FORMAT_R16_UINT;
end;

// Load VB/IB resources for static geometry.

procedure TGeometricPrimitive.LoadStaticBuffers(device: ID3D12Device; resourceUploadBatch: TResourceUploadBatch);
var
    heapProperties: TD3D12_HEAP_PROPERTIES;
    desc: TD3D12_RESOURCE_DESC;
begin
    if (device = nil) then
        raise Exception.Create('Direct3D device is null');

    heapProperties.Init(D3D12_HEAP_TYPE_DEFAULT);

    // Convert dynamic VB to static VB
    if (mStaticVertexBuffer = nil) then
    begin
        assert(mVertexBuffer <> nil);

        desc.Buffer(mVertexBuffer.Size());

        ThrowIfFailed(device.CreateCommittedResource(@heapProperties, D3D12_HEAP_FLAG_NONE, @desc, c_initialCopyTargetState, nil, @IID_ID3D12Resource, mStaticVertexBuffer));

        SetDebugObjectName(mStaticVertexBuffer, 'GeometricPrimitive');

        resourceUploadBatch.Upload(mStaticVertexBuffer, mVertexBuffer);

        resourceUploadBatch.Transition(mStaticVertexBuffer,
            D3D12_RESOURCE_STATE_COPY_DEST, D3D12_RESOURCE_STATE_VERTEX_AND_CONSTANT_BUFFER);

        // Update view
        mVertexBufferView.BufferLocation := mStaticVertexBuffer.GetGPUVirtualAddress();

        mVertexBuffer.Reset();
    end;

    // Convert dynamic IB to static IB
    if (mStaticIndexBuffer = nil) then
    begin
        assert(mIndexBuffer <> nil);

        desc.Buffer(mIndexBuffer.Size());

        ThrowIfFailed(device.CreateCommittedResource(@heapProperties, D3D12_HEAP_FLAG_NONE, @desc, c_initialCopyTargetState, nil, @IID_ID3D12Resource, mStaticIndexBuffer));

        SetDebugObjectName(mStaticIndexBuffer, 'GeometricPrimitive');

        resourceUploadBatch.Upload(mStaticIndexBuffer, mIndexBuffer);

        resourceUploadBatch.Transition(mStaticIndexBuffer,
            D3D12_RESOURCE_STATE_COPY_DEST, D3D12_RESOURCE_STATE_INDEX_BUFFER);

        // Update view
        mIndexBufferView.BufferLocation := mStaticIndexBuffer.GetGPUVirtualAddress();

        mIndexBuffer.Reset();
    end;
end;


// Transition VB/IB resources for static geometry.
procedure TGeometricPrimitive.Transition(commandList: ID3D12GraphicsCommandList; stateBeforeVB: TD3D12_RESOURCE_STATES; stateAfterVB: TD3D12_RESOURCE_STATES; stateBeforeIB: TD3D12_RESOURCE_STATES; stateAfterIB: TD3D12_RESOURCE_STATES);
var
    start: UINT = 0;
    Count: UINT = 0;
    barrier: array[0..2 - 1] of TD3D12_RESOURCE_BARRIER;
begin
    barrier[0].BarrierType := D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
    barrier[0].Transition.Subresource := D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
    barrier[0].Transition.pResource := PID3D12Resource(mStaticIndexBuffer);
    barrier[0].Transition.StateBefore := stateBeforeIB;
    barrier[0].Transition.StateAfter := stateAfterIB;

    barrier[1].BarrierType := D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
    barrier[1].Transition.Subresource := D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
    barrier[1].Transition.pResource := PID3D12Resource(mStaticVertexBuffer);
    barrier[1].Transition.StateBefore := stateBeforeVB;
    barrier[1].Transition.StateAfter := stateAfterVB;

    if (stateBeforeIB = stateAfterIB) or (mStaticIndexBuffer = nil) then
    begin
        Inc(start);
    end
    else
    begin
        Inc(Count);
    end;

    if (stateBeforeVB <> stateAfterVB) and (mStaticVertexBuffer <> nil) then
    begin
        Inc(Count);
    end;

    if (Count > 0) then
    begin
        commandList.ResourceBarrier(Count, @barrier[start]);
    end;
end;


// Draws the primitive.
procedure TGeometricPrimitive.DrawInstanced(commandList: ID3D12GraphicsCommandList; instanceCount: uint32; startInstanceLocation: uint32);
begin
    commandList.IASetVertexBuffers(0, 1, @mVertexBufferView);
    commandList.IASetIndexBuffer(@mIndexBufferView);
    commandList.IASetPrimitiveTopology(D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST);

    commandList.DrawIndexedInstanced(mIndexCount, instanceCount, 0, 0, startInstanceLocation);
end;



procedure TGeometricPrimitive.Draw(commandList: ID3D12GraphicsCommandList);
begin
    DrawInstanced(commandList, 1, 0);
end;

// Creates a cube primitive.

function TGeometricPrimitive.CreateCube(size: single; rhcoords: winbool; device: ID3D12Device): TGeometricPrimitive;
var
    vertices: TVertexCollection;
    indices: TIndexCollection;
    primitive: TGeometricPrimitive;
begin

    ComputeBox(vertices, indices, TXMFLOAT3.Create(size, size, size), rhcoords, False);

    // Create the primitive object.
    primitive := TGeometricPrimitive.Create();

    primitive.Initialize(vertices, indices, device);

    Result := primitive;
end;

end.
