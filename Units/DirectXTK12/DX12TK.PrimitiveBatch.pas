//--------------------------------------------------------------------------------------
// File: PrimitiveBatch.h

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------

unit DX12TK.PrimitiveBatch;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3DCommon,
    DX12.D3D12,
    DX12TK.GraphicsMemory;

type
    // Base class, not to be used directly: clients should access this via the derived PrimitiveBatch<T>.

    { TPrimitiveBatchBase }

    TPrimitiveBatchBase = class(TObject)
    protected
        mVertexSegment: TGraphicsResource;
        mIndexSegment: TGraphicsResource;

        mDevice: ID3D12Device;
        mCommandList: ID3D12GraphicsCommandList;

        mMaxIndices: size_t;
        mMaxVertices: size_t;
        mVertexSize: size_t;
        mVertexPageSize: size_t;
        mIndexPageSize: size_t;
        mCurrentTopology: TD3D_PRIMITIVE_TOPOLOGY;
        mInBeginEndPair: winbool;
        mCurrentlyIndexed: winbool;
        mIndexCount: size_t;
        mVertexCount: size_t;
        mBaseIndex: size_t;
        mBaseVertex: size_t;
    protected
        // Sends queued primitives to the graphics device.
        procedure FlushBatch();
        // Internal, untyped drawing method.
        procedure Draw(topology: TD3D_PRIMITIVE_TOPOLOGY; isIndexed: winbool;{_In_opt_count_(indexCount) } indices: Puint16; indexCount: size_t; vertexCount: size_t;  {_Outptr_ }  out pMappedVertices: pointer);
    public
        constructor Create({_In_ } device: ID3D12Device; maxIndices: size_t; maxVertices: size_t; vertexSize: size_t);
        destructor Destroy; override;
        // Begin/End a batch of primitive drawing operations.
        procedure BeginBatch({_In_ } cmdList: ID3D12GraphicsCommandList);
        procedure EndBatch();


    end;

implementation

uses
    DX12.DXGIFormat;

    //--------------------------------------------------------------------------------------
    // File: PrimitiveBatch.cpp

    // Copyright (c) Microsoft Corporation.
    // Licensed under the MIT License.

    // http://go.microsoft.com/fwlink/?LinkID=615561
    //--------------------------------------------------------------------------------------

// Can we combine adjacent primitives using this topology into a single draw call?
function CanBatchPrimitives(topology: TD3D_PRIMITIVE_TOPOLOGY): boolean;
begin
    case (topology) of
        D3D_PRIMITIVE_TOPOLOGY_POINTLIST,
        D3D_PRIMITIVE_TOPOLOGY_LINELIST,
        D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST:
            // Lists can easily be merged.
            Result := True;
        else
            // Strips cannot.
            Result := False;
    end;

    // We could also merge indexed strips by inserting degenerates,
    // but that's not always a perf win, so let's keep things simple.
end;

{ TPrimitiveBatchBase }

// Sends queued primitives to the graphics device.
procedure TPrimitiveBatchBase.FlushBatch();
var
    vbv: TD3D12_VERTEX_BUFFER_VIEW;
    ibv: TD3D12_INDEX_BUFFER_VIEW;
begin
    // Early out if there is nothing to flush.
    if (mCurrentTopology = D3D_PRIMITIVE_TOPOLOGY_UNDEFINED) then
        Exit;

    mCommandList.IASetPrimitiveTopology(mCurrentTopology);

    // Set the vertex buffer view
    vbv.BufferLocation := mVertexSegment.GpuAddress();
    vbv.SizeInBytes := UINT(mVertexSize * (mVertexCount - mBaseVertex));
    vbv.StrideInBytes := UINT(mVertexSize);
    mCommandList.IASetVertexBuffers(0, 1, @vbv);

    if (mCurrentlyIndexed) then
    begin
        // Set the index buffer view

        ibv.BufferLocation := mIndexSegment.GpuAddress();
        ibv.Format := DXGI_FORMAT_R16_UINT;
        ibv.SizeInBytes := UINT(mIndexCount - mBaseIndex) * sizeof(uint16);
        mCommandList.IASetIndexBuffer(@ibv);

        // Draw indexed geometry.
        mCommandList.DrawIndexedInstanced(UINT(mIndexCount - mBaseIndex), 1, 0, 0, 0);
    end
    else
    begin
        // Draw non-indexed geometry.
        mCommandList.DrawInstanced(UINT(mVertexCount - mBaseVertex), 1, 0, 0);
    end;

    mCurrentTopology := D3D_PRIMITIVE_TOPOLOGY_UNDEFINED;
end;


// Constructor.
constructor TPrimitiveBatchBase.Create(device: ID3D12Device; maxIndices: size_t; maxVertices: size_t; vertexSize: size_t);
begin
    mDevice := device;
    mCommandList := nil;
    mMaxIndices := maxIndices;
    mMaxVertices := maxVertices;
    mVertexSize := vertexSize;
    mVertexPageSize := maxVertices * vertexSize;
    mIndexPageSize := maxIndices * sizeof(uint16);
    mCurrentTopology := D3D_PRIMITIVE_TOPOLOGY_UNDEFINED;
    mInBeginEndPair := False;
    mCurrentlyIndexed := False;
    mIndexCount := 0;
    mVertexCount := 0;
    mBaseIndex := 0;
    mBaseVertex := 0;

    if (device = nil) then
        raise Exception.Create('Direct3D device is null');

    if (maxVertices = 0) then
        raise Exception.Create('maxVertices must be greater than 0');

    if (vertexSize > D3D12_REQ_MULTI_ELEMENT_STRUCTURE_SIZE_IN_BYTES) then
        raise Exception.Create('Vertex size is too large for DirectX 12');

    if ((uint64(maxIndices) * sizeof(uint16)) > uint64(D3D12_REQ_RESOURCE_SIZE_IN_MEGABYTES_EXPRESSION_A_TERM * 1024 * 1024)) then
        raise Exception.Create('IB too large for DirectX 12');

    if ((uint64(maxVertices) * uint64(vertexSize)) > uint64(D3D12_REQ_RESOURCE_SIZE_IN_MEGABYTES_EXPRESSION_A_TERM * 1024 * 1024)) then
        raise Exception.Create('VB too large for DirectX 12');
end;



destructor TPrimitiveBatchBase.Destroy;
begin
    inherited Destroy;
end;


// Begins a batch of primitive drawing operations.
procedure TPrimitiveBatchBase.BeginBatch(cmdList: ID3D12GraphicsCommandList);
begin
    if (mInBeginEndPair) then
        raise Exception.Create('Cannot nest Begin calls');

    mCommandList := cmdList;
    mInBeginEndPair := True;
end;


// Ends a batch of primitive drawing operations.
procedure TPrimitiveBatchBase.EndBatch();
begin
    if (not mInBeginEndPair) then
        raise Exception.Create('Begin must be called before End');

    FlushBatch();

    // Release our smart pointers and end the block
    mIndexSegment.Reset();
    mVertexSegment.Reset();
    mCommandList := nil;
    mInBeginEndPair := False;
end;


// Adds new geometry to the batch.
procedure TPrimitiveBatchBase.Draw(topology: TD3D_PRIMITIVE_TOPOLOGY; isIndexed: winbool; indices: Puint16; indexCount: size_t; vertexCount: size_t; out pMappedVertices: pointer);
var
    wrapIndexBuffer: boolean;
    wrapVertexBuffer: boolean;
    i: size_t;
    outputIndices: Puint16;
begin
    if (isIndexed and (indices = nil)) then
        raise Exception.Create('Indices cannot be null');

    if (indexCount >= mMaxIndices) then
        raise Exception.Create('Too many indices');

    if (vertexCount >= mMaxVertices) then
        raise Exception.Create('Too many vertices');

    if (not mInBeginEndPair) then
        raise Exception.Create('Begin must be called before Draw');

    assert(pMappedVertices <> nil);

    // Can we merge this primitive in with an existing batch, or must we flush first?
    wrapIndexBuffer := (mIndexCount + indexCount > mMaxIndices);
    wrapVertexBuffer := (mVertexCount + vertexCount > mMaxVertices);

    if ((topology <> mCurrentTopology) or (isIndexed <> mCurrentlyIndexed) or not CanBatchPrimitives(topology) or wrapIndexBuffer or wrapVertexBuffer) then
    begin
        FlushBatch();
    end;

    // If we are not already in a batch, lock the buffers.
    if (mCurrentTopology = D3D_PRIMITIVE_TOPOLOGY_UNDEFINED) then
    begin
        mIndexCount := 0;
        mVertexCount := 0;
        mBaseIndex := 0;
        mBaseVertex := 0;
        mCurrentTopology := topology;
        mCurrentlyIndexed := isIndexed;

        // Allocate a page for the primitive data
        if (isIndexed) then
        begin
            mIndexSegment := GraphicsMemory.Get(mDevice).Allocate(mIndexPageSize, 16, Ord(GraphicsMemory.TTag.TAG_INDEX));
        end;

        mVertexSegment := GraphicsMemory.Get(mDevice).Allocate(mVertexPageSize, 16, Ord(GraphicsMemory.TTag.TAG_VERTEX));
    end;

    // Copy over the index data.
    if (isIndexed) then
    begin
        {$POINTERMATH ON}
        outputIndices := Puint16(mIndexSegment.Memory()) + mIndexCount;

        for i := 0 to indexCount - 1 do
        begin
            outputIndices^ := uint16(indices[i] + mVertexCount - mBaseIndex);
            outputIndices := outputIndices + 1;
        end;
        mIndexCount := mIndexCount + indexCount;
    end;

    // Return the output vertex data location.
    pMappedVertices := puint8(mVertexSegment.Memory()) + mVertexSize * mVertexCount;

    mVertexCount := mVertexCount + vertexCount;
end;

end.
