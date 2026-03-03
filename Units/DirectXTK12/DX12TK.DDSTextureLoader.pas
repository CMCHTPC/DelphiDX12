//--------------------------------------------------------------------------------------
// File: DDSTextureLoader.h

// Functions for loading a DDS texture and creating a Direct3D runtime resource for it

// Note these functions are useful as a light-weight runtime loader for DDS files. For
// a full-featured DDS file reader, writer, and texture processing pipeline see
// the 'Texconv' sample and the 'DirectXTex' library.

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------
unit DX12TK.DDSTextureLoader;

{$IFDEF FPC}
{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    CStdVector,
    DX12TK.ResourceUploadBatch,
    DX12.D3D12;

type
    TDDS_ALPHA_MODE = (
        DDS_ALPHA_MODE_UNKNOWN = 0,
        DDS_ALPHA_MODE_STRAIGHT = 1,
        DDS_ALPHA_MODE_PREMULTIPLIED = 2,
        DDS_ALPHA_MODE_OPAQUE = 3,
        DDS_ALPHA_MODE_CUSTOM = 4);

    PDDS_ALPHA_MODE = ^TDDS_ALPHA_MODE;


    TDDS_LOADER_FLAGS = (
        DDS_LOADER_DEFAULT = 0,
        DDS_LOADER_FORCE_SRGB = $1,
        DDS_LOADER_IGNORE_SRGB = $2,
        DDS_LOADER_MIP_AUTOGEN = $8,
        DDS_LOADER_MIP_RESERVE = $10,
        DDS_LOADER_IGNORE_MIPS = $20);

    PDDS_LOADER_FLAGS = ^TDDS_LOADER_FLAGS;

    TSubResourceData = specialize TCStdVector<TD3D12_SUBRESOURCE_DATA>;

// Standard version
function LoadDDSTextureFromMemory(
    {_In_ } device: ID3D12Device;
    {_In_reads_bytes_(ddsDataSize) } ddsData: pbyte; ddsDataSize: size_t;
    {_Outptr_ }  out texture: ID3D12Resource; subresources: TSubResourceData; maxsize: size_t = 0;
    {_Out_opt_ } alphaMode: PDDS_ALPHA_MODE = nil;
    {_Out_opt_ } isCubeMap: Pboolean = nil): HRESULT; cdecl;


function LoadDDSTextureFromFile(
    {_In_ } device: ID3D12Device;
    {_In_z_ } szFileName: pwidechar;
    {_Outptr_ }  out texture: ID3D12Resource; ddsData: pbyte; subresources: TSubResourceData; maxsize: size_t = 0;
    {_Out_opt_ } alphaMode: PDDS_ALPHA_MODE = nil;
    {_Out_opt_ } isCubeMap: Pboolean = nil): HRESULT; cdecl;


// Standard version with resource upload
function CreateDDSTextureFromMemory(
    {_In_ } device: ID3D12Device; resourceUpload: TResourceUploadBatch;
    {_In_reads_bytes_(ddsDataSize) } ddsData: pbyte; ddsDataSize: size_t;
    {_Outptr_ }  out texture: ID3D12Resource; generateMipsIfMissing: boolean = False; maxsize: size_t = 0;
    {_Out_opt_ } alphaMode: PDDS_ALPHA_MODE = nil;
    {_Out_opt_ } isCubeMap: Pboolean = nil): HRESULT; cdecl;


function CreateDDSTextureFromFile(
    {_In_ } device: ID3D12Device; resourceUpload: TResourceUploadBatch;
    {_In_z_ } szFileName: pwidechar;
    {_Outptr_ }  out texture: ID3D12Resource; generateMipsIfMissing: boolean = False; maxsize: size_t = 0;
    {_Out_opt_ } alphaMode: PDDS_ALPHA_MODE = nil;
    {_Out_opt_ } isCubeMap: Pboolean = nil): HRESULT; cdecl;


// Extended version
function LoadDDSTextureFromMemoryEx(
    {_In_ } device: ID3D12Device;
    {_In_reads_bytes_(ddsDataSize) } ddsData: pbyte; ddsDataSize: size_t; maxsize: size_t; resFlags: TD3D12_RESOURCE_FLAGS; loadFlags: TDDS_LOADER_FLAGS;
    {_Outptr_ }  out texture: ID3D12Resource; subresources: TSubResourceData;
    {_Out_opt_ } alphaMode: PDDS_ALPHA_MODE = nil;
    {_Out_opt_ } isCubeMap: Pboolean = nil): HRESULT; cdecl;


function LoadDDSTextureFromFileEx(
    {_In_ } device: ID3D12Device;
    {_In_z_ } szFileName: pwidechar; maxsize: size_t; resFlags: TD3D12_RESOURCE_FLAGS; loadFlags: TDDS_LOADER_FLAGS;
    {_Outptr_ }  out texture: ID3D12Resource; ddsData: pbyte; subresources: TSubResourceData;
    {_Out_opt_ } alphaMode: PDDS_ALPHA_MODE = nil;
    {_Out_opt_ } isCubeMap: Pboolean = nil): HRESULT; cdecl;


// Extended version with resource upload
function CreateDDSTextureFromMemoryEx(
    {_In_ } device: ID3D12Device; resourceUpload: TResourceUploadBatch;
    {_In_reads_bytes_(ddsDataSize) } ddsData: pbyte; ddsDataSize: size_t; maxsize: size_t; resFlags: TD3D12_RESOURCE_FLAGS; loadFlags: TDDS_LOADER_FLAGS;
    {_Outptr_ }  out texture: ID3D12Resource;
    {_Out_opt_ } alphaMode: PDDS_ALPHA_MODE = nil;
    {_Out_opt_ } isCubeMap: Pboolean = nil): HRESULT; cdecl;


function CreateDDSTextureFromFileEx(
    {_In_ } device: ID3D12Device; resourceUpload: TResourceUploadBatch;
    {_In_z_ } szFileName: pwidechar; maxsize: size_t; resFlags: TD3D12_RESOURCE_FLAGS; loadFlags: TDDS_LOADER_FLAGS;
    {_Outptr_ }  out texture: ID3D12Resource;
    {_Out_opt_ } alphaMode: PDDS_ALPHA_MODE = nil;
    {_Out_opt_ } isCubeMap: Pboolean = nil): HRESULT; cdecl;




implementation



function LoadDDSTextureFromMemory(device: ID3D12Device; ddsData: pbyte;
  ddsDataSize: size_t; out texture: ID3D12Resource;
  subresources: TSubResourceData; maxsize: size_t; alphaMode: PDDS_ALPHA_MODE;
  isCubeMap: Pboolean): HRESULT; cdecl;
begin

end;



function LoadDDSTextureFromFile(device: ID3D12Device; szFileName: pwidechar;
  out texture: ID3D12Resource; ddsData: pbyte; subresources: TSubResourceData;
  maxsize: size_t; alphaMode: PDDS_ALPHA_MODE; isCubeMap: Pboolean): HRESULT;
  cdecl;
begin

end;



function CreateDDSTextureFromMemory(device: ID3D12Device;
  resourceUpload: TResourceUploadBatch; ddsData: pbyte; ddsDataSize: size_t;
  out texture: ID3D12Resource; generateMipsIfMissing: boolean; maxsize: size_t;
  alphaMode: PDDS_ALPHA_MODE; isCubeMap: Pboolean): HRESULT; cdecl;
begin

end;



function CreateDDSTextureFromFile(device: ID3D12Device;
  resourceUpload: TResourceUploadBatch; szFileName: pwidechar; out
  texture: ID3D12Resource; generateMipsIfMissing: boolean; maxsize: size_t;
  alphaMode: PDDS_ALPHA_MODE; isCubeMap: Pboolean): HRESULT; cdecl;
begin

end;



function LoadDDSTextureFromMemoryEx(device: ID3D12Device; ddsData: pbyte;
  ddsDataSize: size_t; maxsize: size_t; resFlags: TD3D12_RESOURCE_FLAGS;
  loadFlags: TDDS_LOADER_FLAGS; out texture: ID3D12Resource;
  subresources: TSubResourceData; alphaMode: PDDS_ALPHA_MODE;
  isCubeMap: Pboolean): HRESULT; cdecl;
begin

end;



function LoadDDSTextureFromFileEx(device: ID3D12Device; szFileName: pwidechar;
  maxsize: size_t; resFlags: TD3D12_RESOURCE_FLAGS;
  loadFlags: TDDS_LOADER_FLAGS; out texture: ID3D12Resource; ddsData: pbyte;
  subresources: TSubResourceData; alphaMode: PDDS_ALPHA_MODE;
  isCubeMap: Pboolean): HRESULT; cdecl;
begin

end;



function CreateDDSTextureFromMemoryEx(device: ID3D12Device;
  resourceUpload: TResourceUploadBatch; ddsData: pbyte; ddsDataSize: size_t;
  maxsize: size_t; resFlags: TD3D12_RESOURCE_FLAGS;
  loadFlags: TDDS_LOADER_FLAGS; out texture: ID3D12Resource;
  alphaMode: PDDS_ALPHA_MODE; isCubeMap: Pboolean): HRESULT; cdecl;
begin

end;



function CreateDDSTextureFromFileEx(device: ID3D12Device;
  resourceUpload: TResourceUploadBatch; szFileName: pwidechar; maxsize: size_t;
  resFlags: TD3D12_RESOURCE_FLAGS; loadFlags: TDDS_LOADER_FLAGS; out
  texture: ID3D12Resource; alphaMode: PDDS_ALPHA_MODE; isCubeMap: Pboolean
  ): HRESULT; cdecl;
begin

end;

end.
