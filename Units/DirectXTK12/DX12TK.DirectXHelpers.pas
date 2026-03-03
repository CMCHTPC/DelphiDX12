 //--------------------------------------------------------------------------------------
 // File: DirectXHelpers.h

 // Copyright (c) Microsoft Corporation.
 // Licensed under the MIT License.

 // http://go.microsoft.com/fwlink/?LinkID=615561
 //--------------------------------------------------------------------------------------
unit DX12TK.DirectXHelpers;


{$IFDEF FPC}
{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D12,
    DX12.D3DX12_Core;

    // The d3dx12.h header includes the following helper C++ classes and functions
    //  CD3DX12_RECT
    //  CD3DX12_VIEWPORT
    //  CD3DX12_BOX
    //  CD3DX12_DEPTH_STENCIL_DESC / CD3DX12_DEPTH_STENCIL_DESC1 / CD3DX12_DEPTH_STENCIL_DESC2
    //  CD3DX12_BLEND_DESC
    //  CD3DX12_RASTERIZER_DESC / CD3DX12_RASTERIZER_DESC1
    //  CD3DX12_RESOURCE_ALLOCATION_INFO
    //  CD3DX12_HEAP_PROPERTIES
    //  CD3DX12_HEAP_DESC
    //  CD3DX12_CLEAR_VALUE
    //  CD3DX12_RANGE
    //  CD3DX12_RANGE_UINT64
    //  CD3DX12_SUBRESOURCE_RANGE_UINT64
    //  CD3DX12_SHADER_BYTECODE
    //  CD3DX12_TILED_RESOURCE_COORDINATE
    //  CD3DX12_TILE_REGION_SIZE
    //  CD3DX12_SUBRESOURCE_TILING
    //  CD3DX12_TILE_SHAPE
    //  CD3DX12_RESOURCE_BARRIER
    //  CD3DX12_PACKED_MIP_INFO
    //  CD3DX12_SUBRESOURCE_FOOTPRINT
    //  CD3DX12_TEXTURE_COPY_LOCATION
    //  CD3DX12_DESCRIPTOR_RANGE / CD3DX12_DESCRIPTOR_RANGE1
    //  CD3DX12_ROOT_DESCRIPTOR_TABLE / CD3DX12_ROOT_DESCRIPTOR_TABLE1
    //  CD3DX12_ROOT_CONSTANTS
    //  CD3DX12_ROOT_DESCRIPTOR / CD3DX12_ROOT_DESCRIPTOR1
    //  CD3DX12_ROOT_PARAMETER / CD3DX12_ROOT_PARAMETER1
    //  CD3DX12_STATIC_SAMPLER_DESC
    //  CD3DX12_ROOT_SIGNATURE_DESC
    //  CD3DX12_VERSIONED_ROOT_SIGNATURE_DESC
    //  CD3DX12_CPU_DESCRIPTOR_HANDLE
    //  CD3DX12_GPU_DESCRIPTOR_HANDLE
    //  CD3DX12_RESOURCE_DESC / CD3DX12_RESOURCE_DESC1
    //  CD3DX12_VIEW_INSTANCING_DESC
    //  CD3DX12_RT_FORMAT_ARRAY
    //  CD3DX12_MESH_SHADER_PIPELINE_STATE_DESC
    //  CD3DX12_PIPELINE_STATE_STREAM - CD3DX12_PIPELINE_STATE_STREAM4
    //  CD3DX12_PIPELINE_MESH_STATE_STREAM
    //  CD3DX12_PIPELINE_STATE_STREAM_PARSE_HELPER - CD3DX12_PIPELINE_STATE_STREAM4_PARSE_HELPER
    //  D3D12CalcSubresource
    //  D3D12DecomposeSubresource
    //  D3D12GetFormatPlaneCount
    //  MemcpySubresource
    //  GetRequiredIntermediateSize
    //  UpdateSubresources
    //  D3D12IsLayoutOpaque
    //  CommandListCast
    //  D3DX12SerializeVersionedRootSignature
    //  D3DX12GetBaseSubobjectType
    //  D3DX12ParsePipelineStream

    //  CD3DX12_STATE_OBJECT_DESC
    //  CD3DX12_DXIL_LIBRARY_SUBOBJECT
    //  CD3DX12_EXISTING_COLLECTION_SUBOSetDebugObjectNameBJECT
    //  CD3DX12_SUBOBJECT_TO_EXPORTS_ASSOCIATION_SUBOBJECT
    //  CD3DX12_DXIL_SUBOBJECT_TO_EXPORTS_ASSOCIATION
    //  CD3DX12_HIT_GROUP_SUBOBJECT
    //  CD3DX12_RAYTRACING_SHADER_CONFIG_SUBOBJECT
    //  CD3DX12_RAYTRACING_PIPELINE_CONFIG_SUBOBJECT // CD3DX12_RAYTRACING_PIPELINE_CONFIG1_SUBOBJECT
    //  CD3DX12_GLOBAL_ROOT_SIGNATURE_SUBOBJECT
    //  CD3DX12_LOCAL_ROOT_SIGNATURE_SUBOBJECT
    //  CD3DX12_STATE_OBJECT_CONFIG_SUBOBJECT
    //  CD3DX12_NODE_MASK_SUBOBJECT

    //  CD3DX12_BARRIER_SUBRESOURCE_RANGE
    //  CD3DX12_GLOBAL_BARRIER
    //  CD3DX12_BUFFER_BARRIER
    //  CD3DX12_TEXTURE_BARRIER
    //  CD3DX12_BARRIER_GROUP

    //  CD3DX12FeatureSupport


const
    {$IFDEF XBOX}
    c_initialCopyTargetState: TD3D12_RESOURCE_STATES = D3D12_RESOURCE_STATE_COPY_DEST;
    c_initialReadTargetState: TD3D12_RESOURCE_STATES = D3D12_RESOURCE_STATE_GENERIC_READ;
    c_initialUAVTargetState: TD3D12_RESOURCE_STATES = D3D12_RESOURCE_STATE_UNORDERED_ACCESS;
    {$ELSE}
    c_initialCopyTargetState: TD3D12_RESOURCE_STATES = D3D12_RESOURCE_STATE_COMMON;
    c_initialReadTargetState: TD3D12_RESOURCE_STATES = D3D12_RESOURCE_STATE_COMMON;
    c_initialUAVTargetState: TD3D12_RESOURCE_STATES = D3D12_RESOURCE_STATE_COMMON;
    {$ENDIF}

// Creates a shader resource view from an arbitrary resource
procedure CreateShaderResourceView(
    {_In_ } device: ID3D12Device;
    {_In_ } tex: ID3D12Resource; srvDescriptor: TD3D12_CPU_DESCRIPTOR_HANDLE; isCubeMap: boolean = False); cdecl;



// Helper sets a D3D resource name string (used by PIX and debug layer leak reporting).
procedure SetDebugObjectName({_In_}  resource: ID3D12DeviceChild; {_In_z_} Name: ansistring); inline; overload;
procedure SetDebugObjectName({_In_}  resource: ID3D12DeviceChild; {_In_z_} Name: widestring); inline; overload;


// Shorthand for creating a root signature
function CreateRootSignature(
    {_In_ } device: ID3D12Device;
    {_In_ } rootSignatureDesc: PD3D12_ROOT_SIGNATURE_DESC;
    {_Out_ }  out rootSignature: ID3D12RootSignature): HRESULT; inline;

// Helper for resource barrier.
procedure TransitionResource(
    {_In_ } commandList: ID3D12GraphicsCommandList;
    {_In_ } resource: ID3D12Resource; stateBefore: TD3D12_RESOURCE_STATES; stateAfter: TD3D12_RESOURCE_STATES);

// Helper to check for power-of-2
generic function IsPowerOf2<T>(x: T): boolean; inline;

// Helpers for aligning values by a power of 2
generic function AlignDown<T>(size: T; alignment: size_t): T; inline;
generic function AlignUp<T>(size: T; alignment: size_t): T; inline;

implementation

uses
    DX12.D3DCommon,
    DX12TK.PlatformHelpers;



function CreateRootSignature(device: ID3D12Device; rootSignatureDesc: PD3D12_ROOT_SIGNATURE_DESC; out rootSignature: ID3D12RootSignature): HRESULT;
var
    pSignature: ID3DBlob;
    pError:     ID3DBlob;
begin
    if (device = nil) or (rootSignatureDesc = nil) then
    begin
        Result := E_INVALIDARG;
        exit;
    end;
    Result := D3D12SerializeRootSignature(rootSignatureDesc, D3D_ROOT_SIGNATURE_VERSION_1, pSignature, @pError);
    if (SUCCEEDED(Result)) then
    begin
        Result := device.CreateRootSignature(0, pSignature.GetBufferPointer(), pSignature.GetBufferSize(), @IID_ID3D12RootSignature, rootSignature);
    end;
end;



procedure TransitionResource(commandList: ID3D12GraphicsCommandList; resource: ID3D12Resource; stateBefore: TD3D12_RESOURCE_STATES; stateAfter: TD3D12_RESOURCE_STATES);
var
    desc: TD3D12_RESOURCE_BARRIER;
begin
    assert(commandList <> nil);
    assert(resource <> nil);

    if (stateBefore = stateAfter) then
        Exit;


    desc.BarrierType := D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
    desc.Transition.pResource := PID3D12Resource(resource);
    desc.Transition.Subresource := D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
    desc.Transition.StateBefore := stateBefore;
    desc.Transition.StateAfter := stateAfter;

    commandList.ResourceBarrier(1, @desc);
end;



generic function IsPowerOf2<T>(x: T): boolean; inline;
begin
    Result := ((x <> 0) and ((x and (x - 1)) = 0));
end;



generic function AlignDown<T>(size: T; alignment: size_t): T;
var
    mask: T;
begin
    if (alignment > 0) then
    begin
        assert(((alignment - 1) and alignment) = 0);
        mask   := T(alignment - 1);
        Result := size and not mask;
        Exit;
    end;
    Result := size;
end;



generic function AlignUp<T>(size: T; alignment: size_t): T;
var
    mask: T;
begin
    if (alignment > 0) then
    begin
        assert(((alignment - 1) and alignment) = 0);
        mask   := T(alignment - 1);
        Result := (size + mask) and not mask;
        Exit;
    end;
    Result := size;
end;



procedure CreateShaderResourceView(device: ID3D12Device; tex: ID3D12Resource; srvDescriptor: TD3D12_CPU_DESCRIPTOR_HANDLE; isCubeMap: boolean); cdecl;
var
    desc:      TD3D12_RESOURCE_DESC;
    srvDesc:   TD3D12_SHADER_RESOURCE_VIEW_DESC;
    mipLevels: UINT;
begin
    if (device = nil) or (tex = nil) then
        raise Exception.Create('Direct3D device and resource must be valid');

    tex.GetDesc(@desc);


    if ((Ord(desc.Flags) and Ord(D3D12_RESOURCE_FLAG_DENY_SHADER_RESOURCE)) <> 0) then
    begin
        DebugTrace('ERROR: CreateShaderResourceView called on a resource created without support for SRV.\n', []);
        raise Exception.Create('Can''t have D3D12_RESOURCE_FLAG_DENY_SHADER_RESOURCE');
    end;

    srvDesc.Format := desc.Format;
    srvDesc.Shader4ComponentMapping := D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;

    if (desc.MipLevels > 0) then
        mipLevels := desc.MipLevels
    else
        mipLevels := UINT(-1);

    case (desc.Dimension) of

        D3D12_RESOURCE_DIMENSION_TEXTURE1D:
        begin
            if (desc.DepthOrArraySize > 1) then
            begin
                srvDesc.ViewDimension := D3D12_SRV_DIMENSION_TEXTURE1DARRAY;
                srvDesc.Texture1DArray.MipLevels := mipLevels;
                srvDesc.Texture1DArray.ArraySize := desc.DepthOrArraySize;
            end
            else
            begin
                srvDesc.ViewDimension := D3D12_SRV_DIMENSION_TEXTURE1D;
                srvDesc.Texture1D.MipLevels := mipLevels;
            end;
        end;

        D3D12_RESOURCE_DIMENSION_TEXTURE2D:
        begin
            if (isCubeMap) then
            begin
                if (desc.DepthOrArraySize > 6) then
                begin
                    srvDesc.ViewDimension := D3D12_SRV_DIMENSION_TEXTURECUBEARRAY;
                    srvDesc.TextureCubeArray.MipLevels := mipLevels;
                    srvDesc.TextureCubeArray.NumCubes := desc.DepthOrArraySize div 6;
                end
                else
                begin
                    srvDesc.ViewDimension := D3D12_SRV_DIMENSION_TEXTURECUBE;
                    srvDesc.TextureCube.MipLevels := mipLevels;
                end;
            end
            else if (desc.DepthOrArraySize > 1) then
            begin
                srvDesc.ViewDimension := D3D12_SRV_DIMENSION_TEXTURE2DARRAY;
                srvDesc.Texture2DArray.MipLevels := mipLevels;
                srvDesc.Texture2DArray.ArraySize := desc.DepthOrArraySize;
            end
            else
            begin
                srvDesc.ViewDimension := D3D12_SRV_DIMENSION_TEXTURE2D;
                srvDesc.Texture2D.MipLevels := mipLevels;
            end;
        end;

        D3D12_RESOURCE_DIMENSION_TEXTURE3D:
        begin
            srvDesc.ViewDimension := D3D12_SRV_DIMENSION_TEXTURE3D;
            srvDesc.Texture3D.MipLevels := mipLevels;
        end;

        D3D12_RESOURCE_DIMENSION_BUFFER:
        begin
            DebugTrace('ERROR: CreateShaderResourceView cannot be used with DIMENSION_BUFFER.\n\tUse CreateBufferShaderResourceView.\n', []);
            raise Exception.Create('buffer resources not supported');
        end;
        else
        begin
            DebugTrace('ERROR: CreateShaderResourceView cannot be used with DIMENSION_UNKNOWN (%d).\n', [desc.Dimension]);
            raise Exception.Create('unknown resource dimension');
        end;
    end;

    device.CreateShaderResourceView(tex, @srvDesc, srvDescriptor);
end;

// Helper sets a D3D resource name string (used by PIX and debug layer leak reporting).
{$IFOPT D+}


procedure SetDebugObjectName(resource: ID3D12DeviceChild; Name: ansistring);
var
    wname: widestring;
    result: longint;
begin
    result := MultiByteToWideChar(CP_UTF8, 0, LPCStr(name), Length(name), LPWSTR(wname), MAX_PATH);
    if (result > 0) then
    begin
    resource.SetName(LPCWSTR(wname));
    end;
end;


procedure SetDebugObjectName(resource: ID3D12DeviceChild; Name: widestring);
begin
    resource.SetName(LPCWSTR(name));
end;



{$ELSE}



procedure SetDebugObjectName({_In_}  resource: ID3D12DeviceChild; {_In_z_} Name: widestring); inline; overload;
begin

end;



procedure SetDebugObjectName({_In_}  resource: ID3D12DeviceChild; {_In_z_} Name: widestring); inline; overload;
begin

end;
{$ENDIF}

end.
