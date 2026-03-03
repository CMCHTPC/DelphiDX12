{ **************************************************************************
    FreePascal/Delphi DirectX 12 Header Files

    Copyright (C) 2013-2025 Norbert Sonnleitner

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
************************************************************************** }
{ **************************************************************************
   Additional Copyright (C) for this modul:

   Copyright (c) Microsoft Corporation
   Licensed under the MIT license
   DXCore Interface

   This unit consists of the following header files
   File name: d3dx12_resource_helpers.h
   Header version: SDK 1.717.1-preview  2025 12 28

  ************************************************************************** }
unit DX12.D3DX12_Resource_Helpers;

{$IFDEF FPC}
{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.DXGIFormat,
    DX12.D3DCommon,
    DX12.D3D12;

    {$I DX12.DX12SDKVersion.inc}

type
    generic TStaticArray<N> = array[1..N] of integer;




generic procedure D3D12DecomposeSubresource<T, U, V>(Subresource: UINT; MipLevels: UINT; ArraySize: UINT;
    {_Out_ } MipSlice: T;
    {_Out_ } ArraySlice: U;
    {_Out_ } PlaneSlice: V);

generic function D3DX12Align<T>(uValue: T; uAlign: T): T; inline;

generic function D3DX12AlignAtLeast<T>(uValue: T; uAlign: T): T; inline;


//------------------------------------------------------------------------------------------------
// Row-by-row memcpy
procedure MemcpySubresource(
    {_In_ } pDest: PD3D12_MEMCPY_DEST;
    {_In_ } pSrc: PD3D12_SUBRESOURCE_DATA; RowSizeInBytes: SIZE_T; NumRows: UINT; NumSlices: UINT); overload;

procedure MemcpySubresource(
    {_In_ } pDest: PD3D12_MEMCPY_DEST;
    {_In_ } pResourceData: Pvoid;
    {_In_ } pSrc: PD3D12_SUBRESOURCE_INFO; RowSizeInBytes: SIZE_T; NumRows: UINT; NumSlices: UINT); overload;


//------------------------------------------------------------------------------------------------
// Returns required size of a buffer to be used for data upload
function GetRequiredIntermediateSize(
    {_In_ } pDestinationResource: ID3D12Resource;
    {_In_range_(0,D3D12_REQ_SUBRESOURCES) } FirstSubresource: UINT;
    {_In_range_(0,D3D12_REQ_SUBRESOURCES-FirstSubresource) } NumSubresources: UINT): uint64;

//------------------------------------------------------------------------------------------------
// All arrays must be populated (e.g. by calling GetCopyableFootprints)
function UpdateSubresources(
    {_In_ } pCmdList: ID3D12GraphicsCommandList;
    {_In_ } pDestinationResource: ID3D12Resource;
    {_In_ } pIntermediate: ID3D12Resource;
    {_In_range_(0,D3D12_REQ_SUBRESOURCES) } FirstSubresource: UINT;
    {_In_range_(0,D3D12_REQ_SUBRESOURCES-FirstSubresource) } NumSubresources: UINT; RequiredSize: uint64;
    {_In_reads_(NumSubresources) } pLayouts: PD3D12_PLACED_SUBRESOURCE_FOOTPRINT_ARRAY;
    {_In_reads_(NumSubresources) } pNumRows: PUINT_ARRAY;
    {_In_reads_(NumSubresources) } pRowSizesInBytes: PUINT64_ARRAY;
    {_In_reads_(NumSubresources) } pSrcData: PD3D12_SUBRESOURCE_DATA_ARRAY): uint64; overload;

//------------------------------------------------------------------------------------------------
// All arrays must be populated (e.g. by calling GetCopyableFootprints)
function UpdateSubresources(
    {_In_ } pCmdList: ID3D12GraphicsCommandList;
    {_In_ } pDestinationResource: ID3D12Resource;
    {_In_ } pIntermediate: ID3D12Resource;
    {_In_range_(0,D3D12_REQ_SUBRESOURCES) } FirstSubresource: UINT;
    {_In_range_(0,D3D12_REQ_SUBRESOURCES-FirstSubresource) } NumSubresources: UINT; RequiredSize: uint64;
    {_In_reads_(NumSubresources) } pLayouts: PD3D12_PLACED_SUBRESOURCE_FOOTPRINT_ARRAY;
    {_In_reads_(NumSubresources) } pNumRows: PUINT_ARRAY;
    {_In_reads_(NumSubresources) } pRowSizesInBytes: PUINT64_ARRAY;
    {_In_ } pResourceData: Pvoid;
    {_In_reads_(NumSubresources) } pSrcData: PD3D12_SUBRESOURCE_INFO_ARRAY): uint64; overload;


//------------------------------------------------------------------------------------------------
// Heap-allocating UpdateSubresources implementation
function UpdateSubresources_Heap(
    {_In_ } pCmdList: ID3D12GraphicsCommandList;
    {_In_ } pDestinationResource: ID3D12Resource;
    {_In_ } pIntermediate: ID3D12Resource; IntermediateOffset: uint64;
    {_In_range_(0,D3D12_REQ_SUBRESOURCES) } FirstSubresource: UINT;
    {_In_range_(0,D3D12_REQ_SUBRESOURCES-FirstSubresource) } NumSubresources: UINT;
    {_In_reads_(NumSubresources) } pSrcData: PD3D12_SUBRESOURCE_DATA_ARRAY): uint64; overload;

//------------------------------------------------------------------------------------------------
// Heap-allocating UpdateSubresources implementation
function UpdateSubresources_Heap(
    {_In_ } pCmdList: ID3D12GraphicsCommandList;
    {_In_ } pDestinationResource: ID3D12Resource;
    {_In_ } pIntermediate: ID3D12Resource; IntermediateOffset: uint64;
    {_In_range_(0,D3D12_REQ_SUBRESOURCES) } FirstSubresource: UINT;
    {_In_range_(0,D3D12_REQ_SUBRESOURCES-FirstSubresource) } NumSubresources: UINT;
    {_In_ } pResourceData: Pvoid;
    {_In_reads_(NumSubresources) } pSrcData: PD3D12_SUBRESOURCE_INFO_ARRAY): uint64; overload;



//------------------------------------------------------------------------------------------------
// Stack-allocating UpdateSubresources implementation
generic function UpdateSubresources_Stack<const MaxSubresources: integer>(
    {_In_ } pCmdList: ID3D12GraphicsCommandList;
    {_In_ } pDestinationResource: ID3D12Resource;
    {_In_ } pIntermediate: ID3D12Resource; IntermediateOffset: uint64;
    {_In_range_(0,MaxSubresources) } FirstSubresource: UINT;
    {_In_range_(1,MaxSubresources-FirstSubresource) } NumSubresources: UINT;
    {_In_reads_(NumSubresources) } pSrcData: PD3D12_SUBRESOURCE_DATA_ARRAY): uint64;


//------------------------------------------------------------------------------------------------
// Stack-allocating UpdateSubresources implementation
generic function UpdateSubresources_StackR<const MaxSubresources: integer>(
    {_In_ } pCmdList: ID3D12GraphicsCommandList;
    {_In_ } pDestinationResource: ID3D12Resource;
    {_In_ } pIntermediate: ID3D12Resource; IntermediateOffset: uint64;
    {_In_range_(0,MaxSubresources) } FirstSubresource: UINT;
    {_In_range_(1,MaxSubresources-FirstSubresource) } NumSubresources: UINT;
    {_In_ } pResourceData: Pvoid;
    {_In_reads_(NumSubresources) } pSrcData: PD3D12_SUBRESOURCE_INFO_ARRAY): uint64;


function D3D12IsLayoutOpaque(Layout: TD3D12_TEXTURE_LAYOUT): boolean;

function D3DX12ConditionallyExpandAPIDesc(LclDesc: PD3D12_RESOURCE_DESC1; pDesc: PD3D12_RESOURCE_DESC1; tightAlignmentSupported: boolean = False; alignAsCommitted: boolean = False): PD3D12_RESOURCE_DESC1;

//------------------------------------------------------------------------------------------------
// The difference between D3DX12GetCopyableFootprints and ID3D12Device::GetCopyableFootprints
// is that this one loses a lot of error checking by assuming the arguments are correct
function D3DX12GetCopyableFootprints(
    {_In_  } ResourceDesc: TD3D12_RESOURCE_DESC1;
    {_In_range_(0, D3D12_REQ_SUBRESOURCES) } FirstSubresource: UINT;
    {_In_range_(0, D3D12_REQ_SUBRESOURCES - FirstSubresource) } NumSubresources: UINT; BaseOffset: uint64;
    {_Out_writes_opt_(NumSubresources) } pLayouts: PD3D12_PLACED_SUBRESOURCE_FOOTPRINT_ARRAY;
    {_Out_writes_opt_(NumSubresources) } pNumRows: PUINT_ARRAY;
    {_Out_writes_opt_(NumSubresources) } pRowSizeInBytes: PUINT64_ARRAY;
    {_Out_opt_ } pTotalBytes: PUINT64): boolean;


function D3DX12ResourceDesc0ToDesc1(desc0: TD3D12_RESOURCE_DESC): TD3D12_RESOURCE_DESC1; inline;

function D3DX12GetCopyableFootprints(
    {_In_  } pResourceDesc: TD3D12_RESOURCE_DESC;
    {_In_range_(0, D3D12_REQ_SUBRESOURCES) } FirstSubresource: UINT;
    {_In_range_(0, D3D12_REQ_SUBRESOURCES - FirstSubresource) } NumSubresources: UINT; BaseOffset: uint64;
    {_Out_writes_opt_(NumSubresources) } pLayouts: PD3D12_PLACED_SUBRESOURCE_FOOTPRINT_ARRAY;
    {_Out_writes_opt_(NumSubresources) } pNumRows: PUINT_ARRAY;
    {_Out_writes_opt_(NumSubresources) } pRowSizeInBytes: PUINT64_ARRAY;
    {_Out_opt_ } pTotalBytes: PUINT64): boolean; inline;


implementation

uses
    DX12.D3DX12_Core,
    DX12.D3DX12_Property_Format_Table;

generic function TimesX<const N: integer>(aArg: integer): integer;
begin
    Result := aArg * N;
end;

generic procedure D3D12DecomposeSubresource<T, U, V>(Subresource: UINT; MipLevels: UINT; ArraySize: UINT; MipSlice: T; ArraySlice: U; PlaneSlice: V);
begin
    MipSlice := T(Subresource mod MipLevels);
    ArraySlice := U((Subresource div MipLevels) mod ArraySize);
    PlaneSlice := V(Subresource div (MipLevels * ArraySize));
end;



generic function D3DX12Align<T>(uValue: T; uAlign: T): T; inline;
var
    uMask: T;
    uResult: T;
begin
    // Assert power of 2 alignment
    D3DX12_ASSERT(0 = (uAlign and (uAlign - 1)));
    uMask := uAlign - 1;
    uResult := (uValue + uMask) and not uMask;
    D3DX12_ASSERT(uResult >= uValue);
    D3DX12_ASSERT(0 = (uResult mod uAlign));
    Result := uResult;
end;



generic function D3DX12AlignAtLeast<T>(uValue: T; uAlign: T): T; inline;
var
    aligned: T;
begin
    aligned := specialize D3DX12Align<T>(uValue, uAlign);
    if aligned > uAlign then
        Result := aligned
    else
        Result := uAlign;
end;


//------------------------------------------------------------------------------------------------
// Row-by-row memcpy
procedure MemcpySubresource(pDest: PD3D12_MEMCPY_DEST; pSrc: PD3D12_SUBRESOURCE_DATA; RowSizeInBytes: SIZE_T; NumRows: UINT; NumSlices: UINT);
var
    z, y: UINT;
    pDestSlice: pbyte;
    pSrcSlice: pbyte;
begin
    for  z := 0 to NumSlices - 1 do
    begin
        pDestSlice := pbyte(pDest^.pData) + pDest^.SlicePitch * z;
        pSrcSlice := pbyte(pSrc^.pData) + pSrc^.SlicePitch * LONG_PTR(z);
        for y := 0 to NumRows - 1 do
        begin
            Move((pSrcSlice + pSrc^.RowPitch * LONG_PTR(y))^, (pDestSlice + pDest^.RowPitch * y)^, RowSizeInBytes);
        end;
    end;
end;


//------------------------------------------------------------------------------------------------
// Row-by-row memcpy
procedure MemcpySubresource(pDest: PD3D12_MEMCPY_DEST; pResourceData: Pvoid; pSrc: PD3D12_SUBRESOURCE_INFO; RowSizeInBytes: SIZE_T; NumRows: UINT; NumSlices: UINT);
var
    z, y: UINT;
    pDestSlice: pbyte;
    pSrcSlice: pbyte;
begin
    for  z := 0 to NumSlices - 1 do
    begin
        pDestSlice := pbyte(pDest^.pData) + pDest^.SlicePitch * z;
        pSrcSlice := pbyte(pResourceData) + pSrc^.Offset + pSrc^.DepthPitch * ULONG_PTR(z);
        for y := 0 to NumRows - 1 do
        begin
            Move((pSrcSlice + pSrc^.RowPitch * ULONG_PTR(y))^, (pDestSlice + pDest^.RowPitch * y)^, RowSizeInBytes);
        end;
    end;
end;


//------------------------------------------------------------------------------------------------
// Returns required size of a buffer to be used for data upload
function GetRequiredIntermediateSize(pDestinationResource: ID3D12Resource; FirstSubresource: UINT; NumSubresources: UINT): uint64;
var
    Desc: TD3D12_RESOURCE_DESC;
    RequiredSize: uint64 = 0;
    pDevice: ID3D12Device = nil;
begin
    pDestinationResource.GetDesc(@Desc);
    pDestinationResource.GetDevice(@IID_ID3D12Device, pDevice);
    pDevice.GetCopyableFootprints(@Desc, FirstSubresource, NumSubresources, 0, nil, nil, nil, @RequiredSize);
    pDevice := nil;
    Result := RequiredSize;
end;


//------------------------------------------------------------------------------------------------
// All arrays must be populated (e.g. by calling GetCopyableFootprints)
function UpdateSubresources(pCmdList: ID3D12GraphicsCommandList; pDestinationResource: ID3D12Resource; pIntermediate: ID3D12Resource; FirstSubresource: UINT; NumSubresources: UINT;
    RequiredSize: uint64; pLayouts: PD3D12_PLACED_SUBRESOURCE_FOOTPRINT_ARRAY; pNumRows: PUINT_ARRAY; pRowSizesInBytes: PUINT64_ARRAY; pSrcData: PD3D12_SUBRESOURCE_DATA_ARRAY): uint64;
var
    IntermediateDesc, DestinationDesc: TD3D12_RESOURCE_DESC;
    pData: pbyte;
    hr: HRESULT;
    i: UINT;
    DestData: TD3D12_MEMCPY_DEST;
    Dst: TD3D12_TEXTURE_COPY_LOCATION;
    Src: TD3D12_TEXTURE_COPY_LOCATION;
begin
    // Minor validation

    pIntermediate.GetDesc(@IntermediateDesc);
    pDestinationResource.GetDesc(@DestinationDesc);

    if ((IntermediateDesc.Dimension <> D3D12_RESOURCE_DIMENSION_BUFFER) or (IntermediateDesc.Width < RequiredSize + pLayouts^[0].Offset) or (RequiredSize > SIZE_T(-1)) or
        ((DestinationDesc.Dimension = D3D12_RESOURCE_DIMENSION_BUFFER) and ((FirstSubresource <> 0) or (NumSubresources <> 1)))) then
    begin
        Result := 0;
        Exit;
    end;


    hr := pIntermediate.Map(0, nil, pData);
    if (FAILED(hr)) then
    begin
        Result := 0;
        Exit;
    end;

    for i := 0 to NumSubresources - 1 do
    begin
        if (pRowSizesInBytes^[i] > SIZE_T(-1)) then
        begin
            Result := 0;
            Exit;
        end;
        DestData.Init(pData + pLayouts^[i].Offset, pLayouts^[i].Footprint.RowPitch, SIZE_T(pLayouts^[i].Footprint.RowPitch) * SIZE_T(pNumRows^[i]));
        MemcpySubresource(@DestData, @pSrcData[i], SIZE_T(pRowSizesInBytes^[i]), pNumRows^[i], pLayouts^[i].Footprint.Depth);
    end;
    pIntermediate.Unmap(0, nil);

    if (DestinationDesc.Dimension = D3D12_RESOURCE_DIMENSION_BUFFER) then
    begin
        pCmdList.CopyBufferRegion(
            pDestinationResource, 0, pIntermediate, pLayouts^[0].Offset, pLayouts^[0].Footprint.Width);
    end
    else
    begin
        for  i := 0 to NumSubresources - 1 do
        begin
            Dst.Init(PID3D12Resource(pDestinationResource), i + FirstSubresource);
            Src.InitFootprint(PID3D12Resource(pIntermediate), pLayouts^[i]);
            pCmdList.CopyTextureRegion(@Dst, 0, 0, 0, @Src, nil);
        end;
    end;
    Result := RequiredSize;
end;

//------------------------------------------------------------------------------------------------
// All arrays must be populated (e.g. by calling GetCopyableFootprints)
function UpdateSubresources(pCmdList: ID3D12GraphicsCommandList; pDestinationResource: ID3D12Resource; pIntermediate: ID3D12Resource; FirstSubresource: UINT; NumSubresources: UINT;
    RequiredSize: uint64; pLayouts: PD3D12_PLACED_SUBRESOURCE_FOOTPRINT_ARRAY; pNumRows: PUINT_ARRAY; pRowSizesInBytes: PUINT64_ARRAY; pResourceData: Pvoid; pSrcData: PD3D12_SUBRESOURCE_INFO_ARRAY): uint64;
var
    IntermediateDesc, DestinationDesc: TD3D12_RESOURCE_DESC;
    pData: pbyte;
    hr: HRESULT;
    i: UINT;
    DestData: TD3D12_MEMCPY_DEST;
    Dst: TD3D12_TEXTURE_COPY_LOCATION;
    Src: TD3D12_TEXTURE_COPY_LOCATION;
begin
    // Minor validation
    pIntermediate.GetDesc(@IntermediateDesc);
    pDestinationResource.GetDesc(@DestinationDesc);

    if ((IntermediateDesc.Dimension <> D3D12_RESOURCE_DIMENSION_BUFFER) or (IntermediateDesc.Width < RequiredSize + pLayouts^[0].Offset) or (RequiredSize > SIZE_T(-1)) or
        ((DestinationDesc.Dimension = D3D12_RESOURCE_DIMENSION_BUFFER) and ((FirstSubresource <> 0) or (NumSubresources <> 1)))) then
    begin
        Result := 0;
        Exit;
    end;


    hr := pIntermediate.Map(0, nil, pData);
    if (FAILED(hr)) then
    begin
        Result := 0;
        exit;
    end;

    for i := 0 to NumSubresources - 1 do
    begin
        if (pRowSizesInBytes^[i] > SIZE_T(-1)) then
        begin
            Result := 0;
            exit;

        end;
        DestData.Init(pData + pLayouts^[i].Offset, pLayouts^[i].Footprint.RowPitch, SIZE_T(pLayouts^[i].Footprint.RowPitch) * SIZE_T(pNumRows^[i]));
        MemcpySubresource(@DestData, pResourceData, @pSrcData^[i], SIZE_T(pRowSizesInBytes^[i]), pNumRows^[i], pLayouts^[i].Footprint.Depth);
    end;
    pIntermediate.Unmap(0, nil);

    if (DestinationDesc.Dimension = D3D12_RESOURCE_DIMENSION_BUFFER) then
    begin
        pCmdList.CopyBufferRegion(
            pDestinationResource, 0, pIntermediate, pLayouts^[0].Offset, pLayouts^[0].Footprint.Width);
    end
    else
    begin
        for  i := 0 to NumSubresources - 1 do
        begin
            Dst.Init(PID3D12Resource(pDestinationResource), i + FirstSubresource);
            Src.InitFootprint(PID3D12Resource(pIntermediate), pLayouts^[i]);
            pCmdList.CopyTextureRegion(@Dst, 0, 0, 0, @Src, nil);
        end;
    end;
    Result := RequiredSize;
end;


//------------------------------------------------------------------------------------------------
// Heap-allocating UpdateSubresources implementation
function UpdateSubresources_Heap(pCmdList: ID3D12GraphicsCommandList; pDestinationResource: ID3D12Resource; pIntermediate: ID3D12Resource; IntermediateOffset: uint64; FirstSubresource: UINT;
    NumSubresources: UINT; pSrcData: PD3D12_SUBRESOURCE_DATA_ARRAY): uint64;
var
    RequiredSize: uint64 = 0;
    MemToAlloc: uint64;
    pMem: pointer;
    pLayouts: PD3D12_PLACED_SUBRESOURCE_FOOTPRINT_ARRAY;
    pRowSizesInBytes: PUINT64_ARRAY;
    pNumRows: PUINT_ARRAY;
    Desc: TD3D12_RESOURCE_DESC;
    pDevice: ID3D12Device = nil;
begin

    MemToAlloc := uint64(sizeof(TD3D12_PLACED_SUBRESOURCE_FOOTPRINT) + sizeof(UINT) + sizeof(uint64)) * NumSubresources;
    if (MemToAlloc > SIZE_MAX) then
    begin
        Result := 0;
        Exit;
    end;
    pMem := HeapAlloc(GetProcessHeap(), 0, SIZE_T(MemToAlloc));
    if (pMem = nil) then
    begin
        Result := 0;
        Exit;
    end;
    pLayouts := PD3D12_PLACED_SUBRESOURCE_FOOTPRINT_ARRAY(pMem);
    pRowSizesInBytes := PUINT64_ARRAY(pLayouts + NumSubresources);
    pNumRows := PUINT_ARRAY(pRowSizesInBytes + NumSubresources);

    pDestinationResource.GetDesc(@Desc);

    pDestinationResource.GetDevice(@IID_ID3D12Device, pDevice);
    pDevice.GetCopyableFootprints(@Desc, FirstSubresource, NumSubresources, IntermediateOffset, PD3D12_PLACED_SUBRESOURCE_FOOTPRINT(pLayouts), PUINT(pNumRows), PUINT64(pRowSizesInBytes), @RequiredSize);
    pDevice := nil;

    Result := UpdateSubresources(pCmdList, pDestinationResource, pIntermediate, FirstSubresource, NumSubresources, RequiredSize, pLayouts, pNumRows, pRowSizesInBytes, pSrcData);
    HeapFree(GetProcessHeap(), 0, pMem);
end;


//------------------------------------------------------------------------------------------------
// Heap-allocating UpdateSubresources implementation
function UpdateSubresources_Heap(pCmdList: ID3D12GraphicsCommandList; pDestinationResource: ID3D12Resource; pIntermediate: ID3D12Resource; IntermediateOffset: uint64; FirstSubresource: UINT;
    NumSubresources: UINT; pResourceData: Pvoid; pSrcData: PD3D12_SUBRESOURCE_INFO_ARRAY): uint64;
var
    RequiredSize: uint64 = 0;
    MemToAlloc: uint64;
    pMem: pointer;
    pLayouts: PD3D12_PLACED_SUBRESOURCE_FOOTPRINT_ARRAY;
    pRowSizesInBytes: PUINT64_ARRAY;
    pNumRows: PUINT_ARRAY;
    Desc: TD3D12_RESOURCE_DESC;
    pDevice: ID3D12Device = nil;
begin
    MemToAlloc := uint64(sizeof(TD3D12_PLACED_SUBRESOURCE_FOOTPRINT) + sizeof(UINT) + sizeof(uint64)) * NumSubresources;
    if (MemToAlloc > SIZE_MAX) then
    begin
        Result := 0;
        Exit;
    end;
    pMem := HeapAlloc(GetProcessHeap(), 0, SIZE_T(MemToAlloc));
    if (pMem = nil) then
    begin
        Result := 0;
        Exit;
    end;
    pLayouts := PD3D12_PLACED_SUBRESOURCE_FOOTPRINT_ARRAY(pMem);
    pRowSizesInBytes := PUINT64_ARRAY(pLayouts + NumSubresources);
    pNumRows := PUINT_ARRAY(pRowSizesInBytes + NumSubresources);

    pDestinationResource.GetDesc(@Desc);
    pDestinationResource.GetDevice(@IID_ID3D12Device, pDevice);
    pDevice.GetCopyableFootprints(@Desc, FirstSubresource, NumSubresources, IntermediateOffset, PD3D12_PLACED_SUBRESOURCE_FOOTPRINT(pLayouts), PUINT(pNumRows), PUINT64(pRowSizesInBytes), @RequiredSize);
    pDevice := nil;

    Result := UpdateSubresources(pCmdList, pDestinationResource, pIntermediate, FirstSubresource, NumSubresources, RequiredSize, pLayouts, pNumRows, pRowSizesInBytes, pResourceData, pSrcData);
    HeapFree(GetProcessHeap(), 0, pMem);
end;


//------------------------------------------------------------------------------------------------
// Stack-allocating UpdateSubresources implementation
generic function UpdateSubresources_Stack<MaxSubresources>(pCmdList: ID3D12GraphicsCommandList; pDestinationResource: ID3D12Resource; pIntermediate: ID3D12Resource; IntermediateOffset: uint64;
    FirstSubresource: UINT; NumSubresources: UINT; pSrcData: PD3D12_SUBRESOURCE_DATA_ARRAY): uint64;
var
    RequiredSize: uint64 = 0;
    Layouts: array [0..MaxSubresources - 1] of TD3D12_PLACED_SUBRESOURCE_FOOTPRINT;
    NumRows: array [0..MaxSubresources - 1] of UINT;
    RowSizesInBytes: array [0..MaxSubresources - 1] of uint64;
    Desc: TD3D12_RESOURCE_DESC;
    pDevice: ID3D12Device = nil;
begin
    if ((NumSubresources + FirstSubresource) > MaxSubresources) then
    begin
        Result := 0;
        Exit;
    end;

    pDestinationResource.GetDesc(@Desc);

    pDestinationResource.GetDevice(@IID_ID3D12Device, pDevice);
    pDevice.GetCopyableFootprints(@Desc, FirstSubresource, NumSubresources, IntermediateOffset, @Layouts[0], NumRows, RowSizesInBytes, @RequiredSize);
    pDevice := nil;

    Result := UpdateSubresources(pCmdList, pDestinationResource, pIntermediate, FirstSubresource, NumSubresources, RequiredSize, @Layouts[0], @NumRows[0], @RowSizesInBytes[0], pSrcData);
end;


//------------------------------------------------------------------------------------------------
// Stack-allocating UpdateSubresources implementation
generic function UpdateSubresources_StackR<MaxSubresources>(pCmdList: ID3D12GraphicsCommandList; pDestinationResource: ID3D12Resource; pIntermediate: ID3D12Resource; IntermediateOffset: uint64;
    FirstSubresource: UINT; NumSubresources: UINT; pResourceData: Pvoid; pSrcData: PD3D12_SUBRESOURCE_INFO_ARRAY): uint64;
var
    RequiredSize: uint64 = 0;
    Layouts: array [0..MaxSubresources - 1] of TD3D12_PLACED_SUBRESOURCE_FOOTPRINT;
    NumRows: array [0..MaxSubresources - 1] of UINT;
    RowSizesInBytes: array[0..MaxSubresources - 1] of uint64;
    Desc: TD3D12_RESOURCE_DESC;
    pDevice: ID3D12Device = nil;
begin
    if ((NumSubresources + FirstSubresource) > MaxSubresources) then
    begin
        Result := 0;
        Exit;
    end;

    pDestinationResource.GetDesc(@Desc);

    pDestinationResource.GetDevice(@IID_ID3D12Device, pDevice);
    pDevice.GetCopyableFootprints(@Desc, FirstSubresource, NumSubresources, IntermediateOffset, @Layouts[0], @NumRows[0], @RowSizesInBytes[0], @RequiredSize);
    pDevice := nil;

    Result := UpdateSubresources(pCmdList, pDestinationResource, pIntermediate, FirstSubresource, NumSubresources, RequiredSize, @Layouts[0], @NumRows[0], @RowSizesInBytes[0], pResourceData, pSrcData);
end;



function D3D12IsLayoutOpaque(Layout: TD3D12_TEXTURE_LAYOUT): boolean;
begin
    Result := (Layout = D3D12_TEXTURE_LAYOUT_UNKNOWN) or (Layout = D3D12_TEXTURE_LAYOUT_64KB_UNDEFINED_SWIZZLE);
end;



function D3DX12ConditionallyExpandAPIDesc(LclDesc: PD3D12_RESOURCE_DESC1; pDesc: PD3D12_RESOURCE_DESC1; tightAlignmentSupported: boolean; alignAsCommitted: boolean): PD3D12_RESOURCE_DESC1;
begin
    Result := DX12.D3DX12_Core.D3DX12ConditionallyExpandAPIDesc(LclDesc, pDesc, tightAlignmentSupported, alignAsCommitted);
end;

//------------------------------------------------------------------------------------------------
// The difference between D3DX12GetCopyableFootprints and ID3D12Device::GetCopyableFootprints
// is that this one loses a lot of error checking by assuming the arguments are correct
function D3DX12GetCopyableFootprints(ResourceDesc: TD3D12_RESOURCE_DESC1; FirstSubresource: UINT; NumSubresources: UINT; BaseOffset: uint64; pLayouts: PD3D12_PLACED_SUBRESOURCE_FOOTPRINT_ARRAY;
    pNumRows: PUINT_ARRAY; pRowSizeInBytes: PUINT64_ARRAY; pTotalBytes: PUINT64): boolean;
const
    uint64_max = uint64(not 0);
var
    TotalBytes: uint64 = uint64_max;
    uSubRes: UINT = 0;
    bResourceOverflow: boolean = False;
    Format: TDXGI_FORMAT;
    LresourceDesc: TD3D12_RESOURCE_DESC1;
    RresourceDesc: TD3D12_RESOURCE_DESC1;
    WidthAlignment: UINT;
    HeightAlignment: UINT;
    DepthAlignment: uint16;
    bOverflow: boolean;
    Subresource: UINT;
    subresourceCount: UINT;
    MipLevel, ArraySlice, PlaneSlice: UINT;
    Width: uint64;
    Height: UINT;
    Depth: uint16;
    PlaneFormat: TDXGI_FORMAT;
    MinPlanePitchWidth, PlaneWidth, PlaneHeight: uint32;
    NumSlices: uint16;
    SubresourceSize: uint64;
    LocalPlacement: TD3D12_SUBRESOURCE_FOOTPRINT;
    Placement: TD3D12_SUBRESOURCE_FOOTPRINT;
    MinPlaneRowPitch: UINT = 0;
    PlaneRowSize: UINT;
    NumRows: UINT;
begin

    TotalBytes := 0;

    Format := ResourceDesc.Format;


    RResourceDesc := D3DX12ConditionallyExpandAPIDesc(@LresourceDesc, @ResourceDesc)^;

    // Check if its a valid format
    D3DX12_ASSERT(D3D12_PROPERTY_LAYOUT_FORMAT_TABLE.FormatExists(Format));

    // D3DX12GetCopyableFootprints does not support buffers with width larger than UINT_MAX.
    if ((ResourceDesc.Dimension = D3D12_RESOURCE_DIMENSION_BUFFER) and (ResourceDesc.Width >= UINT_MAX)) then
    begin
        Result := False;
        Exit;
    end;

    WidthAlignment := D3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetWidthAlignment(Format);
    HeightAlignment := D3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetHeightAlignment(Format);
    DepthAlignment := uint16(D3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetDepthAlignment(Format));

    while uSubRes < NumSubresources do
    begin
        bOverflow := False;
        Subresource := FirstSubresource + uSubRes;

        D3DX12_ASSERT(resourceDesc.MipLevels <> 0);
        subresourceCount := resourceDesc.MipLevels * resourceDesc.ArraySize() * D3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetPlaneCount(resourceDesc.Format);

        if (Subresource > subresourceCount) then
        begin
            break;
        end;

        TotalBytes := specialize D3DX12Align<uint64>(TotalBytes, D3D12_TEXTURE_DATA_PLACEMENT_ALIGNMENT);


        specialize D3D12DecomposeSubresource<UINT, UINT, UINT>(Subresource, resourceDesc.MipLevels, resourceDesc.ArraySize(), (*_Out_*) MipLevel, (*_Out_*) ArraySlice, (*_Out_*) PlaneSlice);


        Width := specialize D3DX12AlignAtLeast<uint64>(resourceDesc.Width shr MipLevel, WidthAlignment);
        Height := specialize D3DX12AlignAtLeast<UINT>(resourceDesc.Height shr MipLevel, HeightAlignment);
        Depth := specialize D3DX12AlignAtLeast<uint16>(resourceDesc.Depth() shr MipLevel, DepthAlignment);

        // Adjust for the current PlaneSlice.  Most formats have only one plane.

        D3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetPlaneSubsampledSizeAndFormatForCopyableLayout(PlaneSlice, Format, UINT(Width), Height, (*_Out_*) PlaneFormat, (*_Out_*) MinPlanePitchWidth,
            (* _Out_ *) PlaneWidth, (*_Out_*) PlaneHeight);


        if pLayouts <> nil then
            Placement := pLayouts^[uSubRes].Footprint
        else
            Placement := LocalPlacement;
        Placement.Format := PlaneFormat;
        Placement.Width := PlaneWidth;
        Placement.Height := PlaneHeight;
        Placement.Depth := Depth;

        // Calculate row pitch

        MinPlaneRowPitch := 0;
        D3D12_PROPERTY_LAYOUT_FORMAT_TABLE.CalculateMinimumRowMajorRowPitch(PlaneFormat, MinPlanePitchWidth, MinPlaneRowPitch);

        // Formats with more than one plane choose a larger pitch alignment to ensure that each plane begins on the row
        // immediately following the previous plane while still adhering to subresource alignment restrictions.
        assert((D3D12_TEXTURE_DATA_PLACEMENT_ALIGNMENT >= D3D12_TEXTURE_DATA_PITCH_ALIGNMENT) and (((D3D12_TEXTURE_DATA_PLACEMENT_ALIGNMENT mod D3D12_TEXTURE_DATA_PITCH_ALIGNMENT) = 0)),
            'D3D12_TEXTURE_DATA_PLACEMENT_ALIGNMENT  must be >= and evenly divisible by D3D12_TEXTURE_DATA_PITCH_ALIGNMENT.');

        if D3D12_PROPERTY_LAYOUT_FORMAT_TABLE.Planar(Format) then
            Placement.RowPitch := specialize D3DX12Align<UINT>(MinPlaneRowPitch, D3D12_TEXTURE_DATA_PLACEMENT_ALIGNMENT)
        else
            Placement.RowPitch := specialize D3DX12Align<UINT>(MinPlaneRowPitch, D3D12_TEXTURE_DATA_PITCH_ALIGNMENT);

        if (pRowSizeInBytes <> nil) then
        begin

            PlaneRowSize := 0;
            D3D12_PROPERTY_LAYOUT_FORMAT_TABLE.CalculateMinimumRowMajorRowPitch(PlaneFormat, PlaneWidth, PlaneRowSize);

            pRowSizeInBytes^[uSubRes] := PlaneRowSize;
        end;

        // Number of rows (accounting for block compression and additional planes)
        NumRows := 0;
        if (D3D12_PROPERTY_LAYOUT_FORMAT_TABLE.Planar(Format)) then
        begin
            NumRows := PlaneHeight;
        end
        else
        begin
            D3DX12_ASSERT(Height mod HeightAlignment = 0);
            NumRows := Height div HeightAlignment;
        end;

        if (pNumRows <> nil) then
        begin
            pNumRows^[uSubRes] := NumRows;
        end;

        // Offsetting
        if (pLayouts <> nil) then
        begin
            if (bOverflow) then
                pLayouts^[uSubRes].Offset := uint64_max
            else
                pLayouts^[uSubRes].Offset := TotalBytes + BaseOffset;
        end;

        NumSlices := Depth;
        SubresourceSize := (NumRows * NumSlices - 1) * Placement.RowPitch + MinPlaneRowPitch;

        // uint64 addition with overflow checking
        TotalBytes := TotalBytes + SubresourceSize;
        if (TotalBytes < SubresourceSize) then
        begin
            TotalBytes := uint64_max;
        end;
        bResourceOverflow := bResourceOverflow or bOverflow;
        Inc(uSubRes);
    end;

    // Overflow error
    if (bResourceOverflow) then
    begin
        TotalBytes := uint64_max;
    end;


    if (pLayouts <> nil) then
    begin
        FillByte((pLayouts + uSubRes)^, sizeof(pLayouts^) * (NumSubresources - uSubRes), $FF);
    end;
    if (pNumRows <> nil) then
    begin
        FillByte((pNumRows + uSubRes)^, sizeof(pNumRows^) * (NumSubresources - uSubRes), $FF);
    end;
    if (pRowSizeInBytes <> nil) then
    begin
        FillByte((pRowSizeInBytes + uSubRes)^, sizeof(pRowSizeInBytes^) * (NumSubresources - uSubRes), $FF);
    end;
    if (pTotalBytes <> nil) then
    begin
        pTotalBytes^ := TotalBytes;
    end;
    if (TotalBytes = uint64_max) then
    begin
        Result := False;
        Exit;
    end;
    Result := True;

end;



function D3DX12ResourceDesc0ToDesc1(desc0: TD3D12_RESOURCE_DESC): TD3D12_RESOURCE_DESC1;
var
    desc1: TD3D12_RESOURCE_DESC1;
begin

    desc1.Dimension := desc0.Dimension;
    desc1.Alignment := desc0.Alignment;
    desc1.Width := desc0.Width;
    desc1.Height := desc0.Height;
    desc1.DepthOrArraySize := desc0.DepthOrArraySize;
    desc1.MipLevels := desc0.MipLevels;
    desc1.Format := desc0.Format;
    desc1.SampleDesc.Count := desc0.SampleDesc.Count;
    desc1.SampleDesc.Quality := desc0.SampleDesc.Quality;
    desc1.Layout := desc0.Layout;
    desc1.Flags := desc0.Flags;
    desc1.SamplerFeedbackMipRegion.Width := 0;
    desc1.SamplerFeedbackMipRegion.Height := 0;
    desc1.SamplerFeedbackMipRegion.Depth := 0;
    Result := desc1;
end;



function D3DX12GetCopyableFootprints(pResourceDesc: TD3D12_RESOURCE_DESC; FirstSubresource: UINT; NumSubresources: UINT; BaseOffset: uint64; pLayouts: PD3D12_PLACED_SUBRESOURCE_FOOTPRINT_ARRAY;
    pNumRows: PUINT_ARRAY; pRowSizeInBytes: PUINT64_ARRAY; pTotalBytes: PUINT64): boolean;
var
    desc: TD3D12_RESOURCE_DESC1;
begin
    // From D3D12_RESOURCE_DESC to D3D12_RESOURCE_DESC1
    desc := D3DX12ResourceDesc0ToDesc1(pResourceDesc);
    Result := D3DX12GetCopyableFootprints(TD3D12_RESOURCE_DESC1(desc),// From D3D12_RESOURCE_DESC1 to CD3DX12_RESOURCE_DESC1
        FirstSubresource, NumSubresources, BaseOffset, pLayouts, pNumRows, pRowSizeInBytes, pTotalBytes);
end;

end.
