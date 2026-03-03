//--------------------------------------------------------------------------------------
// File: GraphicsMemory.h

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------
unit DX12TK.GraphicsMemory;

{$mode delphi}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}

interface

uses
    Windows, Classes, SysUtils,
    CStdUniquePtr,
    CStdSharedPtr,
    DX12.D3D12,
    DX12TK.LinearAllocator;

const
    MinPageSize = 64 * 1024;
    MinAllocSize = 4 * 1024;
    AllocatorIndexShift = 12; // start block sizes at 4KB
    AllocatorPoolCount = 21; // allocation sizes up to 2GB supported
    PoolIndexScale = 1; // multiply the allocation size this amount to push large values into the next bucket




type

    TGraphicsMemoryStatistics = record
        committedMemory: size_t;     // Bytes of memory currently committed/in-flight
        totalMemory: size_t;         // Total bytes of memory used by the allocators
        totalPages: size_t;          // Total page count
        peakCommitedMemory: size_t;  // Peak commited memory value since last reset
        peakTotalMemory: size_t;     // Peak total bytes
        peakTotalPages: size_t;      // Peak total page count
    end;

    // Works a little like a smart pointer. The memory will only be fenced by the GPU once the pointer
    // has been invalidated or the user explicitly marks it for fencing.

    { TGraphicsResource }

    TGraphicsResource = class(TObject)
    protected
        mPage: TLinearAllocatorPage;
        mGpuAddress: TD3D12_GPU_VIRTUAL_ADDRESS;
        mResource: ID3D12Resource;
        mMemory: Pvoid;
        mBufferOffset: size_t;
        mSize: size_t;
    public
        constructor Create(); overload;
        constructor Create(
        {_In_ } page: TLinearAllocatorPage;
        {_In_ } gpuAddress: TD3D12_GPU_VIRTUAL_ADDRESS;
        {_In_ } resource: ID3D12Resource;
        {_In_ } memory: Pvoid;
        {_In_ } offset: size_t;
        {_In_ } size: size_t); overload;
        destructor Destroy; override;
        function GpuAddress(): TD3D12_GPU_VIRTUAL_ADDRESS;
        function Resource(): ID3D12Resource;
        function Memory(): Pointer;
        function ResourceOffset(): size_t;
        function Size(): size_t;

        // Clear the pointer. Using operator -> will produce bad results (as usual in C++ ;) )
        procedure Reset();

    end;


    { TSharedGraphicsResource }

    TSharedGraphicsResource = class(TObject)
    protected
        mSharedResource: {specialize} TCStdSharedPtr<TGraphicsResource>;
    public
        constructor Create;
        destructor Destroy; override;
        function GpuAddress():TD3D12_GPU_VIRTUAL_ADDRESS;
        function Resource(): ID3D12Resource;
        function Memory():pointer;
        function ResourceOffset(): size_t;
        function Size(): size_t;
        // Clear the pointer. Using operator -> will produce bad results.
        procedure Reset();
        procedure Assign(var Source: TGraphicsResource);
    end;

    //--------------------------------------------------------------------------------------
    // DeviceAllocator : honors memory requests associated with a particular device
    //--------------------------------------------------------------------------------------

    { TDeviceAllocator }

    TDeviceAllocator = class(TObject)
    protected
        mDevice: ID3D12Device;
        mPools: array[0..AllocatorPoolCount - 1] of {specialize} TCStdUniquePtr<TLinearAllocator>;
    public
        constructor Create( {_In_}  device: ID3D12Device);
        // Explicitly destroy LinearAllocators inside a critical section
        destructor Destroy; override;
        function Alloc({_In_ } size: size_t;{_In_ } alignment: size_t): TGraphicsResource;
        // Submit page fences to the command queue
        procedure KickFences({_In_ } commandQueue: ID3D12CommandQueue);
        procedure GarbageCollect();
        procedure GetStatistics(var stats: TGraphicsMemoryStatistics);
        function GetDevice(): ID3D12Device;
    end;

    { TGraphicsMemory }

    TGraphicsMemory = class(TObject)
    type
        TTag = (
            TAG_GENERIC = 0,
            TAG_CONSTANT,
            TAG_VERTEX,
            TAG_INDEX,
            TAG_SPRITES,
            TAG_TEXTURE,
            TAG_COMPUTE);

    protected
        m_peakCommited: size_t;
        m_peakBytes: size_t;
        m_peakPages: size_t;
        mDeviceAllocator: {specialize} TCStdUniquePtr<TDeviceAllocator>;
    protected
        function AllocateImpl(size: size_t; alignment: size_t): TGraphicsResource;
        procedure DoGetStatistics(var stats: TGraphicsMemoryStatistics);
        procedure Initialize({_In_ } device: ID3D12Device);
        function ImplAllocate(size: size_t; alignment: size_t): TGraphicsResource;
    public
        constructor Create({_In_} device: ID3D12Device);
        destructor Destroy; override;

        // Make sure to keep the GraphicsResource handle alive as long as you need to access
        // the memory on the CPU. For example, do not simply cache GpuAddress() and discard
        // the GraphicsResource object, or your memory may be overwritten later.
        function Allocate(size: size_t; alignment: size_t = 16; ATag: uint32 = Ord(TAG_GENERIC)): TGraphicsResource;

        // Singleton
        // Should only use nullptr for single GPU scenarios; mGPU requires a specific device
        class function Get({_In_opt_ } device: ID3D12Device = nil): TGraphicsMemory;
        // Submits all the pending one-shot memory to the GPU.
        // The memory will be recycled once the GPU is done with it.
        procedure Commit({_In_ } commandQueue: ID3D12CommandQueue);
        // This frees up any unused memory.
        // If you want to make sure all memory is reclaimed, idle the GPU before calling this.
        // It is not recommended that you call this unless absolutely necessary (e.g. your
        // memory budget changes at run-time, or perhaps you're changing levels in your game.)
        procedure GarbageCollect();
        // Memory statistics
        function GetStatistics(): TGraphicsMemoryStatistics;
        procedure ResetStatistics();
        // Properties
        function GetDevice(): ID3D12Device;
        // Version of Allocate that aligns to D3D12 constant buffer requirements
         function AllocateConstant<T>():TGraphicsResource; overload;
         function AllocateConstant<T>(constref setData:T):TGraphicsResource; overload;
    end;

var
    GraphicsMemory: TGraphicsMemory = nil;

implementation

//--------------------------------------------------------------------------------------
// File: GraphicsMemory.cpp
//
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
//
// http://go.microsoft.com/fwlink/?LinkID:=615561
//--------------------------------------------------------------------------------------

uses
    DX12TK.PlatformHelpers;



function NextPow2(x1: size_t): size_t; inline;
var
    x: size_t;
begin
    x := x1 - 1;
    x := x or (x shr 1);
    x := x or (x shr 2);
    x := x or (x shr 4);
    x := x or (x shr 8);
    x := x or (x shr 16);
    {$IFDEF WIN64}
        x :=x or (x shr 32);
    {$ENDIF}
    Result := x + 1;
end;



function GetPoolIndexFromSize(x: size_t): size_t; inline;
var
    allocatorPageSize: size_t;
    bitIndex: ulong = 0;
begin
    allocatorPageSize := x shr AllocatorIndexShift;
    // gives a value from range:
    // 0 - sub-4k allocator
    // 1 - 4k allocator
    // 2 - 8k allocator
    // 4 - 16k allocator
    // etc...
    // Need to convert to an index.

    {$IFDEF WIN64}
    if  allocatorPageSize=0 then
        result:=0
    else
        result:=BsfQWord(allocatorPageSize)+1;
    {$ELSE}
    if allocatorPageSize = 0 then
        Result := 0
    else
        Result := BsfDWord(ulong(allocatorPageSize)) + 1;
    {$ENDIF}

end;



function GetPageSizeFromPoolIndex(x: size_t): size_t; inline;
var
    x1: size_t;
begin
    if (x = 0) then
        x1 := 0
    else
        x1 := x - 1; // clamp to zero
    Result := max(MinPageSize, size_t(1) shl (x1 + AllocatorIndexShift));
end;


{ TGraphicsResource }

//--------------------------------------------------------------------------------------
// GraphicsResource smart-pointer interface
//--------------------------------------------------------------------------------------
constructor TGraphicsResource.Create();
begin
     mPage:=nil;
     mResource:=nil;
     mMemory:=nil;
     mBufferOffset:=0;
     mSize:=0;
end;



constructor TGraphicsResource.Create(page: TLinearAllocatorPage; gpuAddress: TD3D12_GPU_VIRTUAL_ADDRESS; resource: ID3D12Resource; memory: Pvoid; offset: size_t; size: size_t);
begin
     mPage:=page;
     mGpuAddress:=gpuAddress;
     mResource:=resource;
     mMemory:=memory;
     mBufferOffset:=offset;
     mSize:=size;
     assert(mPage <> nil);
     mPage.AddRef();
end;



destructor TGraphicsResource.Destroy;
begin
    if (mPage<>nil) then
    begin
        mPage.Release();
        mPage := nil;
    end;
    inherited Destroy;
end;



function TGraphicsResource.GpuAddress(): TD3D12_GPU_VIRTUAL_ADDRESS;
begin
    Result := mGpuAddress;
end;



function TGraphicsResource.Resource(): ID3D12Resource;
begin
    Result := mResource;
end;



function TGraphicsResource.Memory(): Pointer;
begin
    Result := mMemory;
end;



function TGraphicsResource.ResourceOffset(): size_t;
begin
    Result := mBufferOffset;
end;



function TGraphicsResource.Size(): size_t;
begin
    Result := mSize;
end;



procedure TGraphicsResource.Reset();
begin
    if (mPage<>nil) then
    begin
        mPage.Release();
        mPage := nil;
    end;
    mResource := nil;
    mMemory := nil;
    mBufferOffset := 0;
    mSize := 0;
end;

{ TSharedGraphicsResource }

//--------------------------------------------------------------------------------------
// SharedGraphicsResource
//--------------------------------------------------------------------------------------

constructor TSharedGraphicsResource.Create;
begin
    mSharedResource.Value:=nil;
end;



destructor TSharedGraphicsResource.Destroy;
begin
    inherited Destroy;
end;

function TSharedGraphicsResource.GpuAddress(): TD3D12_GPU_VIRTUAL_ADDRESS;
begin
    result := mSharedResource.Value.GpuAddress();
end;



function TSharedGraphicsResource.Resource(): ID3D12Resource;
begin
    result := mSharedResource.Value.Resource();
end;

function TSharedGraphicsResource.Memory(): pointer;
begin
    result := mSharedResource.Value.Memory();
end;



function TSharedGraphicsResource.ResourceOffset(): size_t;
begin
    result := mSharedResource.Value.ResourceOffset();
end;



function TSharedGraphicsResource.Size(): size_t;
begin
    result := mSharedResource.Value.Size();
end;

procedure TSharedGraphicsResource.Reset();
begin
      mSharedResource.Value.reset();
end;

procedure TSharedGraphicsResource.Assign(var Source: TGraphicsResource);
begin
    //  std::make_shared<GraphicsResource>(std::move(resource));
    mSharedResource.Value:=Source;
    source:=nil;
end;

{ TDeviceAllocator }

constructor TDeviceAllocator.Create(device: ID3D12Device);
var
    i: size_t;
    pageSize: size_t;
begin
    mDevice := device;
    if (device = nil) then
        raise Exception.Create('Invalid device parameter');

    for i := 0 to Length(mPools) - 1 do
    begin
        pageSize := GetPageSizeFromPoolIndex(i);
        mPools[i] := {specialize} TCStdUniquePtr<TLinearAllocator>.Create(TLinearAllocator.Create(mDevice, pageSize));
    end;
end;



destructor TDeviceAllocator.Destroy;
var
    i: size_t;
begin
    for i := 0 to Length(mPools) - 1 do
    begin
        mPools[i].Value.Free;
    end;
    inherited Destroy;
end;



function TDeviceAllocator.Alloc(size: size_t; alignment: size_t): TGraphicsResource;
var
    poolSize: size_t;
    poolIndex: size_t;
    allocator: TLinearAllocator;
    page: TLinearAllocatorPage;
    offset: size_t;
begin
    // Which memory pool does it live in?
    poolSize := NextPow2((alignment + size) * PoolIndexScale);
    poolIndex := GetPoolIndexFromSize(poolSize);
    assert(poolIndex < length(mPools));

    // If the allocator isn't initialized yet, do so now
    allocator := mPools[poolIndex].Value;
    assert(allocator <> nil);
    assert((poolSize < MinPageSize) or (poolSize = allocator.PageSize()));

    page := allocator.FindPageForAlloc(size, alignment);
    if (page = nil) then
    begin
        DebugTrace('GraphicsMemory failed to allocate page (%zu requested bytes, %zu alignment)\n', [size, alignment]);
        raise EOutOfMemory.Create('GraphicsMemory out of memory');
    end;

    offset := page.Suballocate(size, alignment);

    // Return the information to the user
    Result := TGraphicsResource.Create(page, page.GpuAddress() + offset, page.UploadResource(), pbyte(page.BaseMemory()) + offset, offset, size);
end;

// Submit page fences to the command queue

procedure TDeviceAllocator.KickFences(commandQueue: ID3D12CommandQueue);
var
    i: size_t;
begin
    for i := 0 to Length(mPools) - 1 do
    begin
        if mPools[i].Value <> nil then
        begin
            mPools[i].Value.RetirePendingPages();
            mPools[i].Value.FenceCommittedPages(commandQueue);
        end;
    end;
end;



procedure TDeviceAllocator.GarbageCollect();
var
    i: size_t;
begin
    for i := 0 to Length(mPools) - 1 do
    begin
        if mPools[i].Value <> nil then
        begin
            mPools[i].Value.Shrink();
        end;
    end;
end;



procedure TDeviceAllocator.GetStatistics(var stats: TGraphicsMemoryStatistics);
var
    i: size_t;
    totalPageCount: size_t = 0;
    committedMemoryUsage: size_t = 0;
    totalMemoryUsage: size_t = 0;
begin
    for i := 0 to Length(mPools) - 1 do
    begin
        if mPools[i].Value <> nil then
        begin
            totalPageCount := totalPageCount + mPools[i].Value.TotalPageCount();
            committedMemoryUsage := committedMemoryUsage + mPools[i].Value.CommittedMemoryUsage();
            totalMemoryUsage := totalMemoryUsage + mPools[i].Value.TotalMemoryUsage();

        end;
    end;

    stats.committedMemory := committedMemoryUsage;
    stats.totalMemory := totalMemoryUsage;
    stats.totalPages := totalPageCount;

end;



function TDeviceAllocator.GetDevice(): ID3D12Device;
begin
    Result := mDevice;
end;

{ TGraphicsMemory }

//--------------------------------------------------------------------------------------
// GraphicsMemory
//--------------------------------------------------------------------------------------


function TGraphicsMemory.AllocateImpl(size: size_t; alignment: size_t): TGraphicsResource;
begin
    assert(alignment >= 4); // Should use at least DWORD alignment
    Result := ImplAllocate(size, alignment);
end;


// Public constructor.
constructor TGraphicsMemory.Create(device: ID3D12Device);
begin
    m_peakCommited := 0;
    m_peakBytes := 0;
    m_peakPages := 0;
    Initialize(device);
end;


// Public destructor.
destructor TGraphicsMemory.Destroy;
begin
    inherited;
end;



function TGraphicsMemory.Allocate(size: size_t; alignment: size_t; ATag: uint32): TGraphicsResource;
var
    alloc: TGraphicsResource;
begin
    alloc := AllocateImpl(size, alignment);
    Result := alloc;
end;



class function TGraphicsMemory.Get(device: ID3D12Device): TGraphicsMemory;
begin
    if GraphicsMemory = nil then
        raise Exception.Create('GraphicsMemory singleton not created');
  (*
    std::map<ID3D12Device*, GraphicsMemory::Impl*>::const_iterator it;
    if (device=nil) then
    begin
        // Should only use nullptr for device for single GPU usage
        assert(GraphicsMemory.size() = 1);

        it := GraphicsMemory.cbegin();
    end
    else
    begin
        it := GraphicsMemory.find(device);
    end;

    if (it = GraphicsMemory.cend() or not it.second.mOwner) then
        throw std::logic_error("GraphicsMemory per-device singleton not created");

    result:= it.second.mOwner;
                *)
end;



procedure TGraphicsMemory.Initialize(device: ID3D12Device);
begin
    mDeviceAllocator := {specialize} TCStdUniquePtr<TDeviceAllocator>.Create(TDeviceAllocator.Create(device));
end;



function TGraphicsMemory.ImplAllocate(size: size_t; alignment: size_t): TGraphicsResource;
begin
    Result := mDeviceAllocator.Value.Alloc(size, alignment);
end;



procedure TGraphicsMemory.Commit(commandQueue: ID3D12CommandQueue);
begin
    mDeviceAllocator.Value.KickFences(commandQueue);
end;



procedure TGraphicsMemory.GarbageCollect();
begin
    mDeviceAllocator.Value.GarbageCollect();
end;



procedure TGraphicsMemory.DoGetStatistics(var stats: TGraphicsMemoryStatistics);
begin
    mDeviceAllocator.Value.GetStatistics(stats);

    if (stats.committedMemory > m_peakCommited) then
    begin
        m_peakCommited := stats.committedMemory;
    end;
    stats.peakCommitedMemory := m_peakCommited;

    if (stats.totalMemory > m_peakBytes) then
    begin
        m_peakBytes := stats.totalMemory;
    end;
    stats.peakTotalMemory := m_peakBytes;

    if (stats.totalPages > m_peakPages) then
    begin
        m_peakPages := stats.totalPages;
    end;
    stats.peakTotalPages := m_peakPages;
end;



procedure TGraphicsMemory.ResetStatistics();
begin
    m_peakCommited := 0;
    m_peakBytes := 0;
    m_peakPages := 0;
end;



function TGraphicsMemory.GetDevice(): ID3D12Device;
begin
    if mDeviceAllocator.Value <> nil then
        Result := mDeviceAllocator.Value.GetDevice()
    else
        Result := nil;
end;

{generic} function TGraphicsMemory.AllocateConstant<T>(): TGraphicsResource;
var
    alignment: size_t;
    alignedSize: size_t;
    alloc:TGraphicsResource;
begin
    alignment := D3D12_CONSTANT_BUFFER_DATA_PLACEMENT_ALIGNMENT;
    alignedSize := (sizeof(T) + alignment - 1) and not(alignment - 1);
    alloc := AllocateImpl(alignedSize, alignment);
    result:= alloc;
end;

{generic} function TGraphicsMemory.AllocateConstant<T>(constref setData: T
  ): TGraphicsResource;
var
    alloc: TGraphicsResource;
begin
    alloc := {specialize} AllocateConstant<T>();
    move(setData,alloc.Memory()^,sizeof(T));
    Result := alloc;
end;



function TGraphicsMemory.GetStatistics(): TGraphicsMemoryStatistics;
var
    stats: TGraphicsMemoryStatistics;
begin

    DoGetStatistics(stats);
    Result := stats;
end;


initialization

    {$IFOPT D+}
    assert((1 shl AllocatorIndexShift) = MinAllocSize, '1 << AllocatorIndexShift must == MinPageSize (in KiB)');
    assert((MinPageSize and (MinPageSize - 1)) = 0, 'MinPageSize size must be a power of 2');
    assert((MinAllocSize and (MinAllocSize - 1)) = 0, 'MinAllocSize size must be a power of 2');
    assert(MinAllocSize >= (4 * 1024), 'MinAllocSize size must be greater than 4K');
    {$ENDIF}
end.
