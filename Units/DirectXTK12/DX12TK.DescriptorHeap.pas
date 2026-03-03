//--------------------------------------------------------------------------------------
// File: DescriptorHeap.h

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------

unit DX12TK.DescriptorHeap;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D12,
    DX12TK.PlatformHelpers,
    DX12TK.DirectXHelpers;

const
    UINT32_MAX = $FFFFFFFF;

type
    // A contiguous linear random-access descriptor heap

    { TDescriptorHeap }

    TDescriptorHeap = class(TObject)
    protected
        m_pHeap: ID3D12DescriptorHeap;
        m_desc: TD3D12_DESCRIPTOR_HEAP_DESC;
        m_hCPU: TD3D12_CPU_DESCRIPTOR_HANDLE;
        m_hGPU: TD3D12_GPU_DESCRIPTOR_HANDLE;
        m_increment: uint32;
        procedure CreateIntern({_In_}  pDevice: ID3D12Device; {_In_ const}  pDesc: PD3D12_DESCRIPTOR_HEAP_DESC);
    public
        constructor Create({_In_}  pExistingHeap: ID3D12DescriptorHeap);
        constructor Create({_In_}  device: ID3D12Device; {_In_ const}  pDesc: PD3D12_DESCRIPTOR_HEAP_DESC);
        constructor Create({_In_ } device: ID3D12Device; HeapType: TD3D12_DESCRIPTOR_HEAP_TYPE; flags: TD3D12_DESCRIPTOR_HEAP_FLAGS; Count: size_t);
        constructor Create({_In_ } device: ID3D12Device; Count: size_t);
        function Heap(): ID3D12DescriptorHeap;

        function GetFirstGpuHandle(): TD3D12_GPU_DESCRIPTOR_HANDLE;
        function GetFirstCpuHandle(): TD3D12_CPU_DESCRIPTOR_HANDLE;
        function GetCpuHandle({_In_}  index: size_t): TD3D12_CPU_DESCRIPTOR_HANDLE;
        function GetGpuHandle({_In_}  index: size_t): TD3D12_GPU_DESCRIPTOR_HANDLE;

        function Count(): size_t;
        function Flags(): longword;
        function HeapType(): TD3D12_DESCRIPTOR_HEAP_TYPE;
        function Increment(): uint32;
        procedure DefaultDesc({_In} AHeapType: TD3D12_DESCRIPTOR_HEAP_TYPE;
        {_Out_}  pDesc: PD3D12_DESCRIPTOR_HEAP_DESC);


        function WriteDescriptors(
        {_In_ } device: ID3D12Device; offsetIntoHeap: uint32; totalDescriptorCount: uint32;
        {_In_reads_(descriptorRangeCount) } pDescriptorRangeStarts: PD3D12_CPU_DESCRIPTOR_HANDLE;
        {_In_reads_(descriptorRangeCount) } pDescriptorRangeSizes: Puint32; descriptorRangeCount: uint32): TD3D12_GPU_DESCRIPTOR_HANDLE; overload;

        function WriteDescriptors(
        {_In_ } device: ID3D12Device; offsetIntoHeap: uint32;
        {_In_reads_(descriptorRangeCount) } pDescriptorRangeStarts: PD3D12_CPU_DESCRIPTOR_HANDLE;
        {_In_reads_(descriptorRangeCount) } pDescriptorRangeSizes: Puint32; descriptorRangeCount: uint32): TD3D12_GPU_DESCRIPTOR_HANDLE; overload;

        function WriteDescriptors(
        {_In_ } device: ID3D12Device; offsetIntoHeap: uint32;
        {_In_reads_(descriptorCount) } pDescriptors: PD3D12_CPU_DESCRIPTOR_HANDLE; descriptorCount: uint32): TD3D12_GPU_DESCRIPTOR_HANDLE; overload;


    end;

    TDescriptorHeapDesc = record
        HeapType: TD3D12_DESCRIPTOR_HEAP_TYPE;
        Flags: TD3D12_DESCRIPTOR_HEAP_FLAGS;
    end;
    PDescriptorHeapDesc = ^TDescriptorHeapDesc;

    TIndexType = size_t;
    PIndexType = ^TIndexType;

    // Helper class for dynamically allocating descriptor indices.
    // The pile is statically sized and will throw an exception if it becomes full.

    { TDescriptorPile }

    TDescriptorPile = class(TDescriptorHeap)
    const
        INVALID_INDEX: TIndexType = size_t(-1);
    private
        m_top: TIndexType;
    public
        constructor Create({_In_ } pExistingHeap: ID3D12DescriptorHeap; reserve: size_t = 0);
        constructor Create({_In_ } device: ID3D12Device; {_In_ } pDesc: PD3D12_DESCRIPTOR_HEAP_DESC; reserve: size_t = 0);
        constructor Create({_In_ } device: ID3D12Device; AHeapType: TD3D12_DESCRIPTOR_HEAP_TYPE; AFlags: TD3D12_DESCRIPTOR_HEAP_FLAGS; capacity: size_t; reserve: size_t = 0);
        constructor Create({_In_ } device: ID3D12Device; ACount: size_t; reserve: size_t = 0);
        function Allocate(): TIndexType;
        procedure AllocateRange(numDescriptors: size_t; {_Out_}  AStart: PIndexType; {_Out_}  AEnd: PIndexType);
    end;


const

    c_DescriptorHeapDescs: array [0..Ord(D3D12_DESCRIPTOR_HEAP_TYPE_NUM_TYPES) - 1] of TDescriptorHeapDesc = ((HeapType: D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV;
        Flags: D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE), (HeapType: D3D12_DESCRIPTOR_HEAP_TYPE_SAMPLER; Flags: D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE), (HeapType: D3D12_DESCRIPTOR_HEAP_TYPE_RTV;
        Flags: D3D12_DESCRIPTOR_HEAP_FLAG_NONE), (HeapType: D3D12_DESCRIPTOR_HEAP_TYPE_DSV; Flags: D3D12_DESCRIPTOR_HEAP_FLAG_NONE));

implementation

//--------------------------------------------------------------------------------------
// File: DescriptorHeap.cpp

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------


{ TDescriptorHeap }

procedure TDescriptorHeap.CreateIntern(pDevice: ID3D12Device; pDesc: PD3D12_DESCRIPTOR_HEAP_DESC);
begin
    if (pDevice = nil) then
        raise Exception.Create('Direct3D device is null');

    assert(pDesc <> nil);

    m_desc := pDesc^;
    m_increment := pDevice.GetDescriptorHandleIncrementSize(pDesc^.HeapType);

    if (pDesc^.NumDescriptors = 0) then
    begin
        m_pHeap := nil;
        m_hCPU.ptr := 0;
        m_hGPU.ptr := 0;
    end
    else
    begin
        m_pHeap := nil;
        ThrowIfFailed(pDevice.CreateDescriptorHeap(pDesc, @IID_ID3D12DescriptorHeap, m_pHeap));

        SetDebugObjectName(m_pHeap, 'DescriptorHeap');


        m_pHeap.GetCPUDescriptorHandleForHeapStart(@m_hCPU);
        if (Ord(pDesc^.Flags) and Ord(D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE)) <> 0 then
        begin
            m_pHeap.GetGPUDescriptorHandleForHeapStart(@m_hGPU);
        end;

    end;
end;



constructor TDescriptorHeap.Create(pExistingHeap: ID3D12DescriptorHeap);
var
    device: ID3D12Device;
begin
    m_pHeap := pExistingHeap;
    if (pExistingHeap = nil) then
        raise Exception.Create('Heap is null');

    pExistingHeap.GetCPUDescriptorHandleForHeapStart(@m_hCPU);
    pExistingHeap.GetGPUDescriptorHandleForHeapStart(@m_hGPU);
    pExistingHeap.GetDesc(@m_desc);

    pExistingHeap.GetDevice(@IID_ID3D12Device, device);

    m_increment := device.GetDescriptorHandleIncrementSize(m_desc.HeapType);
end;



constructor TDescriptorHeap.Create(device: ID3D12Device; pDesc: PD3D12_DESCRIPTOR_HEAP_DESC);
begin
    m_increment := 0;
    CreateIntern(device, pDesc);
end;



constructor TDescriptorHeap.Create(device: ID3D12Device; HeapType: TD3D12_DESCRIPTOR_HEAP_TYPE; flags: TD3D12_DESCRIPTOR_HEAP_FLAGS; Count: size_t);
var
    desc: TD3D12_DESCRIPTOR_HEAP_DESC;
begin
    m_increment := 0;
    if (Count > UINT32_MAX) then
        raise Exception.Create('Too many descriptors');

    desc.Flags := flags;
    desc.NumDescriptors := UINT(Count);
    desc.HeapType := HeapType;
    Create(device, @desc);
end;



constructor TDescriptorHeap.Create(device: ID3D12Device; Count: size_t);
begin
    Create(device, D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV, D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE, Count);
end;



function TDescriptorHeap.Heap(): ID3D12DescriptorHeap;
begin
    Result := m_pHeap;
end;



function TDescriptorHeap.GetFirstGpuHandle(): TD3D12_GPU_DESCRIPTOR_HANDLE;
begin
    assert((Ord(m_desc.Flags) and Ord(D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE)) = Ord(D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE));
    assert(m_pHeap <> nil);
    Result := m_hGPU;
end;



function TDescriptorHeap.GetFirstCpuHandle(): TD3D12_CPU_DESCRIPTOR_HANDLE;
begin
    assert(m_pHeap <> nil);
    Result := m_hCPU;
end;



function TDescriptorHeap.GetCpuHandle(index: size_t): TD3D12_CPU_DESCRIPTOR_HANDLE;
var
    handle: TD3D12_CPU_DESCRIPTOR_HANDLE;
begin
    {$IFOPT D+}
    assert(m_pHeap <> nil);
    if (index >= m_desc.NumDescriptors) then
    begin
        raise Exception.Create('D3DX12_CPU_DESCRIPTOR_HANDLE');
    end;
    {$ENDIF}
    handle.ptr := SIZE_T(m_hCPU.ptr + uint64(index) * uint64(m_increment));
    Result := handle;
end;



function TDescriptorHeap.GetGpuHandle(index: size_t): TD3D12_GPU_DESCRIPTOR_HANDLE;
var
    handle: TD3D12_GPU_DESCRIPTOR_HANDLE;
begin
    {$IFOPT D+}
    assert(m_pHeap <> nil);
    if (index >= m_desc.NumDescriptors) then
    begin
        raise Exception.Create('D3DX12_GPU_DESCRIPTOR_HANDLE');
    end;
    assert((ord(m_desc.Flags) and ord(D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE)) = ord(D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE));
    {$ENDIF}

    handle.ptr := m_hGPU.ptr + uint64(index) * uint64(m_increment);
    Result := handle;
end;



function TDescriptorHeap.Count(): size_t;
begin
    Result := m_desc.NumDescriptors;
end;



function TDescriptorHeap.Flags(): longword;
begin
    Result := Ord(m_desc.Flags);
end;



function TDescriptorHeap.HeapType(): TD3D12_DESCRIPTOR_HEAP_TYPE;
begin
    Result := m_desc.HeapType;
end;



function TDescriptorHeap.Increment(): uint32;
begin
    Result := m_increment;
end;



procedure TDescriptorHeap.DefaultDesc(AHeapType: TD3D12_DESCRIPTOR_HEAP_TYPE; pDesc: PD3D12_DESCRIPTOR_HEAP_DESC);
begin
    assert(c_DescriptorHeapDescs[Ord(AHeapType)].HeapType = AHeapType);
    pDesc^.Flags := c_DescriptorHeapDescs[Ord(AHeapType)].Flags;
    pDesc^.NumDescriptors := 0;
    pDesc^.HeapType := AHeapType;
end;



function TDescriptorHeap.WriteDescriptors(device: ID3D12Device; offsetIntoHeap: uint32; totalDescriptorCount: uint32; pDescriptorRangeStarts: PD3D12_CPU_DESCRIPTOR_HANDLE; pDescriptorRangeSizes: Puint32;
    descriptorRangeCount: uint32): TD3D12_GPU_DESCRIPTOR_HANDLE;
var
    cpuHandle: TD3D12_CPU_DESCRIPTOR_HANDLE;
    gpuHandle: TD3D12_GPU_DESCRIPTOR_HANDLE;
begin
    assert((size_t(offsetIntoHeap) + size_t(totalDescriptorCount)) <= size_t(m_desc.NumDescriptors));

    cpuHandle := GetCpuHandle(offsetIntoHeap);

    device.CopyDescriptors(
        1, @cpuHandle, @totalDescriptorCount,
        descriptorRangeCount,
        pDescriptorRangeStarts,
        pDescriptorRangeSizes,
        m_desc.HeapType);

    gpuHandle := GetGpuHandle(offsetIntoHeap);

    Result := gpuHandle;
end;



function TDescriptorHeap.WriteDescriptors(device: ID3D12Device; offsetIntoHeap: uint32; pDescriptorRangeStarts: PD3D12_CPU_DESCRIPTOR_HANDLE; pDescriptorRangeSizes: Puint32; descriptorRangeCount: uint32): TD3D12_GPU_DESCRIPTOR_HANDLE;
var
    totalDescriptorCount: uint32 = 0;
    i: uint32;
begin

    for i := 0 to descriptorRangeCount - 1 do
        totalDescriptorCount := totalDescriptorCount + pDescriptorRangeSizes[i];

    Result := WriteDescriptors(device, offsetIntoHeap, totalDescriptorCount, pDescriptorRangeStarts, pDescriptorRangeSizes, descriptorRangeCount);
end;



function TDescriptorHeap.WriteDescriptors(device: ID3D12Device; offsetIntoHeap: uint32; pDescriptors: PD3D12_CPU_DESCRIPTOR_HANDLE; descriptorCount: uint32): TD3D12_GPU_DESCRIPTOR_HANDLE;
begin
    Result := WriteDescriptors(device, offsetIntoHeap, descriptorCount, pDescriptors, @descriptorCount, 1);
end;


//======================================================================================
// DescriptorPile
//======================================================================================

{ TDescriptorPile }

constructor TDescriptorPile.Create(pExistingHeap: ID3D12DescriptorHeap; reserve: size_t);
begin
    inherited Create(pExistingHeap);
    m_top := reserve;
    if (reserve > 0) and (m_top >= Count()) then
    begin
        raise Exception.Create('Reserve descriptor range is too large');
    end;
end;



constructor TDescriptorPile.Create(device: ID3D12Device; pDesc: PD3D12_DESCRIPTOR_HEAP_DESC; reserve: size_t);
begin
    inherited Create(device, pDesc);
    m_top := reserve;
    if (reserve > 0) and (m_top >= Count()) then
    begin
        raise Exception.Create('Reserve descriptor range is too large');
    end;
end;



constructor TDescriptorPile.Create(device: ID3D12Device; AHeapType: TD3D12_DESCRIPTOR_HEAP_TYPE; AFlags: TD3D12_DESCRIPTOR_HEAP_FLAGS; capacity: size_t; reserve: size_t);
begin
    inherited Create(device, AHeapType, AFlags, capacity);
    m_top := reserve;
    if (reserve > 0) and (m_top >= Count()) then
    begin
        raise Exception.Create('Reserve descriptor range is too large');
    end;
end;



constructor TDescriptorPile.Create(device: ID3D12Device; ACount: size_t; reserve: size_t);
begin
    Create(device, D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV, D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE, ACount, reserve);
end;



function TDescriptorPile.Allocate(): TIndexType;
var
    lStart, lEnd: TIndexType;
begin
    AllocateRange(1, @lStart, @lEnd);
    Result := lStart;
end;



procedure TDescriptorPile.AllocateRange(numDescriptors: size_t; AStart: PIndexType; AEnd: PIndexType);
begin
    // make sure we didn't allocate zero
    if (numDescriptors = 0) then
    begin
        raise Exception.Create('Can''t allocate zero descriptors');
    end;

    // get the current top
    AStart^ := m_top;

    // increment top with new request
    m_top := m_top + numDescriptors;
    AEnd^ := m_top;

    // make sure we have enough room
    if (m_top > Count()) then
    begin
        DebugTrace('DescriptorPile has %zu of %zu descriptors; failed request for %zu more\n', [Astart^, Count(), numDescriptors]);
        raise Exception.Create('Can''t allocate more descriptors');
    end;
end;

end.
