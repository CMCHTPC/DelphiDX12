
//--------------------------------------------------------------------------------------
// LinearAllocator.h

// A linear allocator. When Allocate is called it will try to return you a pointer into
// existing graphics memory. If there is no space left from what is allocated, more
// pages are allocated on-the-fly.

// Each allocation must be smaller or equal to pageSize. It is not necessary but is most
// efficient for the sizes to be some fraction of pageSize. pageSize does not determine
// the size of the physical pages underneath the virtual memory (that's given by the
// XMemAttributes) but is how much additional memory the allocator should allocate
// each time you run out of space.

// preallocatePages specifies how many pages to initially allocate. Specifying zero will
// preallocate two pages by default.

// This class is NOT thread safe. You should protect this with the appropriate sync
// primitives or, even better, use one linear allocator per thread.

// Pages are freed once the GPU is done with them. As such, you need to specify when a
// page is in use and when it is no longer in use. Use RetirePages to prompt the
// allocator to check if pages are no longer being used by the GPU. Use InsertFences to
// mark all used pages as in-use by the GPU, removing them from the available pages
// list. It is recommended you call RetirePages and InsertFences once a frame, usually
// just before Present().

// Why is RetirePages decoupled from InsertFences? It's possible that you might want to
// reclaim pages more frequently than locking used pages. For example, if you find the
// allocator is burning through pages too quickly you can call RetirePages to reclaim
// some that the GPU has finished with. However, this adds additional CPU overhead so it
// is left to you to decide. In most cases this is sufficient:

//      allocator.RetirePages();
//      allocator.InsertFences( pContext, 0 );
//      Present(...);

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------
unit DX12TK.LinearAllocator;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D12;


    {$IFOPT D+}
    // Set this to 1 to enable some additional debug validation
    {$DEFINE VALIDATE_LISTS}
    {$ENDIF}

type

    { TLinearAllocatorPage }

    TLinearAllocatorPage = class(TObject)
    private
        mRefCount: int32; // std::atomic<>
    protected
        pPrevPage: TLinearAllocatorPage;
        pNextPage: TLinearAllocatorPage;
        mMemory: pointer;
        mPendingFence: uint64;
        mGpuAddress: TD3D12_GPU_VIRTUAL_ADDRESS;
        mOffset: size_t;
        mSize: size_t;
        mUploadResource: ID3D12Resource;
    public
        constructor Create;
        destructor Destroy; override;
        function Suballocate({_In_ } size: size_t;{_In_ } alignment: size_t): size_t;
        function BaseMemory(): pointer;
        function UploadResource(): ID3D12Resource;
        function GpuAddress(): TD3D12_GPU_VIRTUAL_ADDRESS;
        function BytesUsed(): size_t;
        function Size(): size_t;
        procedure AddRef();
        function RefCount(): int32;
        procedure Release();

    end;

    PLinearAllocatorPage = TLinearAllocatorPage;

    { TLinearAllocator }

    TLinearAllocator = class(TObject)
    protected
        m_pendingPages: TLinearAllocatorPage; // Pages in use by the GPU
        m_usedPages: TLinearAllocatorPage;    // Pages to be submitted to the GPU
        m_unusedPages: TLinearAllocatorPage;  // Pages not being used right now
        m_increment: size_t;
        m_numPending: size_t;
        m_totalPages: size_t;
        m_fenceCount: uint64;
        m_device: ID3D12Device;
        m_fence: ID3D12Fence;
        {$IFOPT D+}
         m_debugName: widestring;
         class procedure ValidateList(list :TLinearAllocatorPage);
         procedure ValidatePageLists();
         procedure SetPageDebugName(list :TLinearAllocatorPage);
        {$ENDIF}
    protected
        function GetPageForAlloc(sizeBytes: size_t; alignment: size_t): TLinearAllocatorPage;
        function GetCleanPageForAlloc(): TLinearAllocatorPage;
        function FindPageForAlloc(list: PLinearAllocatorPage; sizeBytes: size_t; alignment: size_t): TLinearAllocatorPage; overload;


        function GetNewPage(): TLinearAllocatorPage;
        procedure UnlinkPage(page: PLinearAllocatorPage);
        procedure LinkPage(page: TLinearAllocatorPage; var list: TLinearAllocatorPage);
        procedure LinkPageChain(page: TLinearAllocatorPage; var list: TLinearAllocatorPage);
        procedure ReleasePage(page: TLinearAllocatorPage);
        procedure FreePages(page: TLinearAllocatorPage);
    public
        // These values will be rounded up to the nearest 64k.
        // You can specify zero for incrementalSizeBytes to increment
        // by 1 page (64k).
        constructor Create({_In_ } pDevice: ID3D12Device;{_In_ } pageSize: size_t;{_In_ } preallocateBytes: size_t = 0);
        destructor Destroy; override;

        // Call this at least once a frame to check if pages have become available.
        procedure RetirePendingPages();
        // Call this after you submit your work to the driver.
        // (e.g. immediately before Present.)
        procedure FenceCommittedPages({_In_ } commandQueue: ID3D12CommandQueue);
        // Throws away all currently unused pages
        procedure Shrink();
        {$IFOPT D+}
        function GetDebugName(): widestring;
        procedure SetDebugName(AName :widestring);
        {$ENDIF}

        // Statistics
        function CommittedPageCount(): size_t;
        function TotalPageCount(): size_t;
        function CommittedMemoryUsage(): size_t;
        function TotalMemoryUsage(): size_t;
        function PageSize(): size_t;
        function FindPageForAlloc({_In_ } requestedSize: size_t;{_In_ } alignment: size_t): TLinearAllocatorPage; overload;
    end;


implementation

//--------------------------------------------------------------------------------------
// File: LinearAllocator.cpp

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkID:=615561
//--------------------------------------------------------------------------------------

uses
    DX12.D3DX12_Core,
    DX12TK.DirectXHelpers,
    DX12TK.PlatformHelpers;

    { TLinearAllocatorPage }

constructor TLinearAllocatorPage.Create;
begin
    pPrevPage := nil;
    pNextPage := nil;
    mMemory := nil;
    mPendingFence := 0;
    mOffset := 0;
    mSize := 0;
    mRefCount := 0;
end;



destructor TLinearAllocatorPage.Destroy;
begin
    inherited Destroy;
end;



function TLinearAllocatorPage.Suballocate(size: size_t; alignment: size_t): size_t;
var
    offset: size_t;
begin
    offset := specialize AlignUp<size_T>(mOffset, alignment);
    if (offset + size > mSize) then
    begin
        // Use of suballocate should be limited to pages with free space,
        // so really shouldn't happen.
        raise Exception.Create('LinearAllocatorPage::Suballocate');
    end;
    mOffset := offset + size;
    Result := offset;
end;



function TLinearAllocatorPage.BaseMemory(): pointer;
begin
    Result := mMemory;
end;



function TLinearAllocatorPage.UploadResource(): ID3D12Resource;
begin
    Result := mUploadResource;
end;



function TLinearAllocatorPage.GpuAddress(): TD3D12_GPU_VIRTUAL_ADDRESS;
begin
    Result := mGpuAddress;
end;



function TLinearAllocatorPage.BytesUsed(): size_t;
begin
    Result := mOffset;
end;



function TLinearAllocatorPage.Size(): size_t;
begin
    Result := mSize;
end;



procedure TLinearAllocatorPage.AddRef();
begin
    InterLockedIncrement(mRefCount);
end;



function TLinearAllocatorPage.RefCount(): int32;
begin
    Result := mRefCount;
end;



procedure TLinearAllocatorPage.Release();
begin
    assert(mRefCount > 0);

    if InterlockedDecrement(mRefCount) = 0 then
    begin
        mUploadResource.Unmap(0, nil);
        self.Free;
    end;
end;


{ TLinearAllocator }

{$IFOPT D+}
{$IFDEF  VALIDATE_LISTS}
class procedure TLinearAllocator.ValidateList(list: TLinearAllocatorPage);
var
    page: TLinearAllocatorPage;
    lastPage: TLinearAllocatorPage;
begin
    page := list;
    lastPage := nil;
    while (page <> nil) do
    begin
        if (page.pPrevPage <> lastPage) then
        begin
            raise Exception.Create('Broken link to previous');
        end;
        lastPage := page;
        page := page.pNextPage;
    end;
end;



procedure TLinearAllocator.ValidatePageLists();
begin
    ValidateList(m_pendingPages);
    ValidateList(m_usedPages);
    ValidateList(m_unusedPages);
end;
{$ENDIF}


procedure TLinearAllocator.SetPageDebugName(list: TLinearAllocatorPage);
var
    page: TLinearAllocatorPage;
begin
    page := list;
    while ( page <> nil) do
    begin
        page.mUploadResource.SetName(PWideChar(m_debugName));
        page := page.pNextPage;
    end;
end;
{$ENDIF}



function TLinearAllocator.GetPageForAlloc(sizeBytes: size_t; alignment: size_t): TLinearAllocatorPage;
var
    page: TLinearAllocatorPage;
begin
    // Fast path
    if ((sizeBytes = m_increment) and (alignment = 0) and (alignment = m_increment)) then
    begin
        Result := GetCleanPageForAlloc();
        Exit;
    end;

    // Find a page in the pending pages list that has space.
    page := FindPageForAlloc(m_usedPages, sizeBytes, alignment);
    if (page = nil) then
    begin
        page := GetCleanPageForAlloc();
    end;

    Result := page;
end;



function TLinearAllocator.GetCleanPageForAlloc(): TLinearAllocatorPage;
var
    page: TLinearAllocatorPage;
begin
    // Grab the first unused page, if one exists. Else, allocate a new page.
    page := m_unusedPages;
    if (page = nil) then
    begin
        // Allocate a new page
        page := GetNewPage();
        if (page = nil) then
        begin
            Result := nil;
            Exit;
        end;
    end;

    // Mark this page as used
    UnlinkPage(page);
    LinkPage(page, m_usedPages);

    assert(page.mOffset = 0);

    Result := page;
end;



function TLinearAllocator.FindPageForAlloc(list: PLinearAllocatorPage; sizeBytes: size_t; alignment: size_t): TLinearAllocatorPage;
var
    page: TLinearAllocatorPage;
    offset: size_t;
begin
    page := list;
    while (page <> nil) do
    begin
        offset := specialize AlignUp<size_t>(page.mOffset, alignment);
        if (offset + sizeBytes <= m_increment) then
        begin
            Result := page;
            Exit;
        end;
        page := page.pNextPage;
    end;
    Result := nil;
end;



function TLinearAllocator.FindPageForAlloc(requestedSize: size_t; alignment: size_t): TLinearAllocatorPage;
var
    page: TLinearAllocatorPage;
begin
    {$IFOPT D+}
    if (requestedSize > m_increment) then
        raise Exception.Create('Size must be less or equal to the allocator''s increment');
    if (alignment > m_increment)  then
        raise Exception.Create('Alignment must be less or equal to the allocator''s increment');
    if (requestedSize = 0)  then
        raise Exception.Create('Cannot honor zero size allocation request.');
    {$ENDIF}

    page := GetPageForAlloc(requestedSize, alignment);
    if (page = nil) then
    begin
        Result := nil;
        Exit;
    end;
    Result := page;
end;



function TLinearAllocator.GetNewPage(): TLinearAllocatorPage;
var
    spResource: ID3D12Resource;
    hr: HRESULT;
    pMemory: pointer;
    page: TLinearAllocatorPage;
    uploadHeapProperties: TD3D12_HEAP_PROPERTIES;
    bufferDesc: TD3D12_RESOURCE_DESC;
    temp: Pointer;
begin
    uploadHeapProperties.Init(D3D12_HEAP_TYPE_UPLOAD);
    bufferDesc.Buffer(m_increment);
    // Allocate the upload heap

    hr := m_device.CreateCommittedResource(@uploadHeapProperties, D3D12_HEAP_FLAG_NONE, @bufferDesc, D3D12_RESOURCE_STATE_GENERIC_READ, nil, @IID_ID3D12Resource, spResource);
    if (FAILED(hr)) then
    begin
        if (hr <> E_OUTOFMEMORY) then
        begin
            DebugTrace('LinearAllocator.GetNewPage resource allocation failed due to unexpected error %08X\n', [hr]);
        end;
        Result := nil;
        Exit;
    end;

    {$IFOPT D+}
    if (m_debugName='') then
        m_debugName:='LinearAllocator';
    spResource.SetName(PWideChar(m_debugName));
    {$ENDIF}

    // Get a pointer to the memory
    pMemory := nil;
    ThrowIfFailed(spResource.Map(0, nil, pMemory));
    FillByte(pMemory^, m_increment, 0);

    // Add the page to the page list
    page := TLinearAllocatorPage.Create;
    page.mMemory := pMemory;
    page.mGpuAddress := spResource.GetGPUVirtualAddress();
    page.mSize := m_increment;

    // just pointers swap for page.mUploadResource.Swap(spResource);
    temp := PID3D12Resource(spResource);
    PID3D12Resource(spResource) := PID3D12Resource(page.mUploadResource);
    PID3D12Resource(page.mUploadResource) := temp;


    // Set as head of the list
    page.pNextPage := m_unusedPages;
    if (m_unusedPages <> nil) then m_unusedPages.pPrevPage := page;
    m_unusedPages := page;
    Inc(m_totalPages);

    {$IFDEF VALIDATE_LISTS}
    ValidatePageLists();
    {$ENDIF}

    Result := page;
end;



procedure TLinearAllocator.UnlinkPage(page: PLinearAllocatorPage);
begin
    if (page.pPrevPage <> nil) then
        page.pPrevPage.pNextPage := page.pNextPage

    // Check that it isn't the head of any of our tracked lists
    else if (page = m_unusedPages) then
        m_unusedPages := page.pNextPage
    else if (page = m_usedPages) then
        m_usedPages := page.pNextPage
    else if (page = m_pendingPages) then
        m_pendingPages := page.pNextPage;

    if (page.pNextPage <> nil) then
        page.pNextPage.pPrevPage := page.pPrevPage;

    page.pNextPage := nil;
    page.pPrevPage := nil;

    {$IFDEF  VALIDATE_LISTS}
    ValidatePageLists();
    {$ENDIF}
end;



procedure TLinearAllocator.LinkPage(page: TLinearAllocatorPage; var list: TLinearAllocatorPage);
var
    cur: TLinearAllocatorPage;
begin
    {$IFDEF  VALIDATE_LISTS}
    // Walk the chain and ensure it's not in the list twice
    cur := list;
    while (  cur <> nil) do
    begin
        assert(cur <> page);
        cur := cur.pNextPage;
    end;
    {$ENDIF}
    assert(page.pNextPage = nil);
    assert(page.pPrevPage = nil);
    assert((list = nil) or (list.pPrevPage = nil));

    page.pNextPage := list;
    if (list <> nil) then
        list.pPrevPage := page;

    list := page;

    {$IFDEF  VALIDATE_LISTS}
    ValidatePageLists();
    {$ENDIF}
end;



procedure TLinearAllocator.LinkPageChain(page: TLinearAllocatorPage; var list: TLinearAllocatorPage);
var
    cur: TLinearAllocatorPage;
    lastPage: TLinearAllocatorPage;
begin
    {$IFDEF  VALIDATE_LISTS}
        // Walk the chain and ensure it's not in the list twice
        cur := list;
        while (cur <> nil) do
        begin
            assert(cur <> page);
            cur := cur.pNextPage;
        end;
    {$ENDIF}
    assert(page.pPrevPage = nil);
    assert((list = nil) or (list.pPrevPage = nil));

    // Follow chain to the end and append
    lastPage := page;
    while (lastPage.pNextPage <> nil) do
    begin
        lastPage := lastPage.pNextPage;
    end;

    lastPage.pNextPage := list;
    if (list <> nil) then
        list.pPrevPage := lastPage;

    list := page;

    {$IFDEF  VALIDATE_LISTS}
        ValidatePageLists();
    {$ENDIF}
end;



procedure TLinearAllocator.ReleasePage(page: TLinearAllocatorPage);
begin
    assert(m_numPending > 0);
    Dec(m_numPending);

    UnlinkPage(page);
    LinkPage(page, m_unusedPages);

    // Reset the page offset (effectively erasing the memory)
    page.mOffset := 0;

    {$IFOPT D+}
    FillByte(page.mMemory^,m_increment,0);
    {$ENDIF}

    {$IFDEF  VALIDATE_LISTS}
    ValidatePageLists();
    {$ENDIF}
end;



procedure TLinearAllocator.FreePages(page: TLinearAllocatorPage);
var
    nextPage: TLinearAllocatorPage;
begin
    while (page <> nil) do
    begin
        nextPage := page.pNextPage;

        page.Release();

        page := nextPage;
        assert(m_totalPages > 0);
        Dec(m_totalPages);
    end;
end;



constructor TLinearAllocator.Create(pDevice: ID3D12Device; pageSize: size_t; preallocateBytes: size_t);
var
    preallocatePageCount: size_t;
    preallocatePages: size_t;
begin
    m_pendingPages := nil;
    m_usedPages := nil;
    m_unusedPages := nil;
    m_increment := pageSize;
    m_numPending := 0;
    m_totalPages := 0;
    m_fenceCount := 0;
    m_device := pDevice;

    assert(pDevice <> nil);
    {$IFOPT D+}
    m_debugName := 'LinearAllocator';
    {$ENDIF}

    preallocatePageCount := ((preallocateBytes + pageSize - 1) div pageSize);
    preallocatePages := 0;
    while (preallocateBytes <> 0) and (preallocatePages < preallocatePageCount) do
    begin
        if (GetNewPage() = nil) then
        begin
            DebugTrace('LinearAllocator failed to preallocate pages (%zu required bytes, %zu pages)\n', [preallocatePageCount * m_increment, preallocatePageCount]);
            raise EOutOfMemory.Create('LinearAllocator out of memory');
        end;
        preallocatePages := preallocatePages + 1;
    end;

    ThrowIfFailed(pDevice.CreateFence(0, D3D12_FENCE_FLAG_NONE, @IID_ID3D12Fence, m_fence));
end;



destructor TLinearAllocator.Destroy;
begin
    // Must wait for all pending fences!
    while (m_pendingPages <> nil) do
    begin
        RetirePendingPages();
    end;

    assert(m_pendingPages = nil);

    // Return all the memory
    FreePages(m_unusedPages);
    FreePages(m_usedPages);

    m_pendingPages := nil;
    m_usedPages := nil;
    m_unusedPages := nil;
    m_increment := 0;

    inherited Destroy;
end;


// Call this once a frame after all of your driver submissions.
// (immediately before or after Present-time)
procedure TLinearAllocator.RetirePendingPages();
var
    fenceValue: uint64;
    page: TLinearAllocatorPage;
    nextPage: TLinearAllocatorPage;
begin
    fenceValue := m_fence.GetCompletedValue();

    // For each page that we know has a fence pending, check it. If the fence has passed,
    // we can mark the page for re-use.
    page := m_pendingPages;
    while (page <> nil) do
    begin
        nextPage := page.pNextPage;

        assert(page.mPendingFence <> 0);

        if (fenceValue >= page.mPendingFence) then
        begin
            // Fence has passed. It is safe to use this page again.
            ReleasePage(page);
        end;

        page := nextPage;
    end;
end;


// Call this after you submit your work to the driver.
procedure TLinearAllocator.FenceCommittedPages(commandQueue: ID3D12CommandQueue);
var
    numReady: UINT = 0;
    readyPages: TLinearAllocatorPage = nil;
    unreadyPages: TLinearAllocatorPage = nil;
    nextPage: TLinearAllocatorPage = nil;
    page: TLinearAllocatorPage;
begin
    // No pending pages
    if (m_usedPages = nil) then
        Exit;

    // For all the used pages, fence them
    page := m_usedPages;
    while (page <> nil) do
    begin
        nextPage := page.pNextPage;

        // Disconnect from the list
        page.pPrevPage := nil;

        // This implies the allocator is the only remaining reference to the page, and therefore the memory is ready for re-use.
        if (page.RefCount() = 1) then
        begin
            // Signal the fence
            Inc(numReady);
            page.mPendingFence := page.mPendingFence + m_fenceCount;
            ThrowIfFailed(commandQueue.Signal(m_fence, m_fenceCount));

            // Link to the ready pages list
            page.pNextPage := readyPages;
            if (readyPages <> nil) then readyPages.pPrevPage := page;
            readyPages := page;
        end
        else
        begin
            // Link to the unready list
            page.pNextPage := unreadyPages;
            if (unreadyPages <> nil) then unreadyPages.pPrevPage := page;
            unreadyPages := page;
        end;
        page := nextPage;
    end;

    // Replace the used pages list with the new unready list
    m_usedPages := unreadyPages;

    // Append all those pages from the ready list to the pending list
    if (numReady > 0) then
    begin
        m_numPending := m_numPending + numReady;
        LinkPageChain(readyPages, m_pendingPages);
    end;

    {$IFDEF VALIDATE_LISTS}
    ValidatePageLists();
    {$ENDIF}
end;



procedure TLinearAllocator.Shrink();
begin
    FreePages(m_unusedPages);
    m_unusedPages := nil;

    {$IFDEF VALIDATE_LISTS}
    ValidatePageLists();
    {$ENDIF}
end;


{$IFOPT D+}
function TLinearAllocator.GetDebugName(): widestring;
begin

end;



procedure TLinearAllocator.SetDebugName(AName: widestring);
begin
   m_debugName := Aname;

    // Rename existing pages
    m_fence.SetName(PWideChar(Aname));
    SetPageDebugName(m_pendingPages);
    SetPageDebugName(m_usedPages);
    SetPageDebugName(m_unusedPages);
end;
{$ENDIF}



function TLinearAllocator.CommittedPageCount(): size_t;
begin
    Result := m_numPending;
end;



function TLinearAllocator.TotalPageCount(): size_t;
begin
    Result := m_totalPages;
end;



function TLinearAllocator.CommittedMemoryUsage(): size_t;
begin
    Result := m_numPending * m_increment;
end;



function TLinearAllocator.TotalMemoryUsage(): size_t;
begin
    Result := m_totalPages * m_increment;
end;



function TLinearAllocator.PageSize(): size_t;
begin
    Result := m_increment;
end;

end.
