unit DX12.D3DX12_Core;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

{$DEFINE D3D12_SDK_VERSION_609}

interface

uses
    Windows, Classes, SysUtils,
    DX12.DXGIFormat,
    DX12.D3DCommon,
    DX12.D3D12,
    DX12.D3DX12_Default;



//const
//    cMaxSubresources = 16; // adapt to your needs

type







    { TD3DX12_BOX }

    TD3DX12_BOX = type helper for TD3D12_BOX
        procedure Init(Left: LONG; Right: LONG); overload;
        procedure Init(Left: LONG; Top: LONG; Right: LONG; Bottom: LONG); overload;
        procedure Init(Left: LONG; Top: LONG; Front: LONG; Right: LONG; Bottom: LONG; Back: LONG); overload;
    end;

    { TD3DX12_DEPTH_STENCIL_DESC }

    TD3DX12_DEPTH_STENCIL_DESC = type helper for TD3D12_DEPTH_STENCIL_DESC
        procedure Init; overload;
        procedure Init(depthEnable: boolean; depthWriteMask: TD3D12_DEPTH_WRITE_MASK; depthFunc: TD3D12_COMPARISON_FUNC; stencilEnable: boolean; stencilReadMask: uint8; stencilWriteMask: uint8;
            frontStencilFailOp: TD3D12_STENCIL_OP; frontStencilDepthFailOp: TD3D12_STENCIL_OP; frontStencilPassOp: TD3D12_STENCIL_OP; frontStencilFunc: TD3D12_COMPARISON_FUNC;
            backStencilFailOp: TD3D12_STENCIL_OP; backStencilDepthFailOp: TD3D12_STENCIL_OP; backStencilPassOp: TD3D12_STENCIL_OP; backStencilFunc: TD3D12_COMPARISON_FUNC); overload;
    end;

    { TD3DX12_BLEND_DESC }

    TD3DX12_BLEND_DESC = type helper for TD3D12_BLEND_DESC
        constructor Create(Default: TD3D12_DEFAULT); overload;
        procedure Init;
    end;

    { TD3DX12_RASTERIZER_DESC }

    TD3DX12_RASTERIZER_DESC = type helper for TD3D12_RASTERIZER_DESC
        procedure Init; overload;
        procedure Init(fillMode: TD3D12_FILL_MODE; cullMode: TD3D12_CULL_MODE; frontCounterClockwise: boolean; depthBias: int32; depthBiasClamp: single; slopeScaledDepthBias: single;
            depthClipEnable: boolean; multisampleEnable: boolean; antialiasedLineEnable: boolean; forcedSampleCount: UINT; conservativeRaster: TD3D12_CONSERVATIVE_RASTERIZATION_MODE); overload;
        constructor Create(Default: TD3D12_DEFAULT); overload;
        constructor Create(fillMode: TD3D12_FILL_MODE; cullMode: TD3D12_CULL_MODE; frontCounterClockwise: boolean; depthBias: integer; depthBiasClamp: single; slopeScaledDepthBias: single;
            depthClipEnable: boolean; multisampleEnable: boolean; antialiasedLineEnable: boolean; forcedSampleCount: UINT; conservativeRaster: TD3D12_CONSERVATIVE_RASTERIZATION_MODE); overload;
    end;

    { TD3DX12_GRAPHICS_PIPELINE_STATE_DESC }

    TD3DX12_GRAPHICS_PIPELINE_STATE_DESC = type helper for TD3D12_GRAPHICS_PIPELINE_STATE_DESC
        procedure Init;
    end;

    { TD3DX12_STREAM_OUTPUT_DESC }

    TD3DX12_STREAM_OUTPUT_DESC = type helper for TD3D12_STREAM_OUTPUT_DESC
        procedure Init;
    end;


    { TD3DX12_RASTERIZER_DESC1 }

    TD3DX12_RASTERIZER_DESC1 = type helper for TD3D12_RASTERIZER_DESC1
        procedure Init(fillMode: TD3D12_FILL_MODE; cullMode: TD3D12_CULL_MODE; frontCounterClockwise: boolean; depthBias: single; depthBiasClamp: single; slopeScaledDepthBias: single;
            depthClipEnable: boolean; multisampleEnable: boolean; antialiasedLineEnable: boolean; forcedSampleCount: UINT; conservativeRaster: TD3D12_CONSERVATIVE_RASTERIZATION_MODE);

    end;

    { TD3DX12_RASTERIZER_DESC2 }

    TD3DX12_RASTERIZER_DESC2 = type helper for TD3D12_RASTERIZER_DESC2
        procedure Init(fillMode: TD3D12_FILL_MODE; cullMode: TD3D12_CULL_MODE; frontCounterClockwise: boolean; depthBias: single; depthBiasClamp: single; slopeScaledDepthBias: single;
            depthClipEnable: boolean; lineRasterizationMode: TD3D12_LINE_RASTERIZATION_MODE; forcedSampleCount: UINT; conservativeRaster: TD3D12_CONSERVATIVE_RASTERIZATION_MODE); overload;


    end;

    { TD3DX12_RESOURCE_ALLOCATION_INFO }

    TD3DX12_RESOURCE_ALLOCATION_INFO = type helper for TD3D12_RESOURCE_ALLOCATION_INFO
        procedure Init(size: uint64; alignment: uint64);
    end;

    { TD3DX12_HEAP_PROPERTIES }

    TD3DX12_HEAP_PROPERTIES = type helper for TD3D12_HEAP_PROPERTIES
        procedure Init(); overload;
        procedure Init(cpuPageProperty: TD3D12_CPU_PAGE_PROPERTY; memoryPoolPreference: TD3D12_MEMORY_POOL; creationNodeMask: UINT = 1; nodeMask: UINT = 1); overload;
        procedure Init(HeapType: TD3D12_HEAP_TYPE; creationNodeMask: UINT = 1; nodeMask: UINT = 1); overload;
        function IsCPUAccessible(): boolean;
        class function Create(AType: TD3D12_HEAP_TYPE; CreationNodeMask: UINT = 1; NodeMask: UINT = 1): PD3D12_HEAP_PROPERTIES; static;
    end;

    { TD3DX12_HEAP_DESC }

    TD3DX12_HEAP_DESC = type helper for TD3D12_HEAP_DESC
        procedure Init(size: uint64; properties: TD3D12_HEAP_PROPERTIES; alignment: uint64 = 0; flags: TD3D12_HEAP_FLAGS = D3D12_HEAP_FLAG_NONE); overload;
        procedure Init(size: uint64; HeapType: TD3D12_HEAP_TYPE; alignment: uint64 = 0; flags: TD3D12_HEAP_FLAGS = D3D12_HEAP_FLAG_NONE); overload;
        procedure Init(size: uint64; cpuPageProperty: TD3D12_CPU_PAGE_PROPERTY; memoryPoolPreference: TD3D12_MEMORY_POOL; alignment: uint64 = 0; flags: TD3D12_HEAP_FLAGS = D3D12_HEAP_FLAG_NONE); overload;
        procedure Init(resAllocInfo: TD3D12_RESOURCE_ALLOCATION_INFO; properties: TD3D12_HEAP_PROPERTIES; flags: TD3D12_HEAP_FLAGS = D3D12_HEAP_FLAG_NONE); overload;
        procedure Init(resAllocInfo: TD3D12_RESOURCE_ALLOCATION_INFO; HeapType: TD3D12_HEAP_TYPE; flags: TD3D12_HEAP_FLAGS = D3D12_HEAP_FLAG_NONE); overload;
        procedure Init(resAllocInfo: TD3D12_RESOURCE_ALLOCATION_INFO; cpuPageProperty: TD3D12_CPU_PAGE_PROPERTY; memoryPoolPreference: TD3D12_MEMORY_POOL; flags: TD3D12_HEAP_FLAGS = D3D12_HEAP_FLAG_NONE); overload;
        function IsCPUAccessible(): boolean;
    end;

    { TD3DX12_CLEAR_VALUE }

    TD3DX12_CLEAR_VALUE = type helper for TD3D12_CLEAR_VALUE
        procedure Init(format: TDXGI_FORMAT; color: TFloatArray4); overload;
        procedure Init(format: TDXGI_FORMAT; depth: single; stencil: uint8); overload;
    end;

    { TD3DX12_RANGE }

    TD3DX12_RANGE = type helper for TD3D12_RANGE
        procedure Init(RangeBegin: SIZE_T; RangeEnd: SIZE_T);
        constructor Create(RangeBegin: SIZE_T; RangeEnd: SIZE_T);
    end;

    { TD3DX12_RANGE_UINT64 }

    TD3DX12_RANGE_UINT64 = type helper for TD3D12_RANGE_UINT64
        procedure Init(RangeBegin: uint64; RangeEnd: uint64);
    end;


    { TD3DX12_SUBRESOURCE_RANGE_UINT64 }

    TD3DX12_SUBRESOURCE_RANGE_UINT64 = type helper for TD3D12_SUBRESOURCE_RANGE_UINT64
        procedure Init(subresource: UINT; range: TD3D12_RANGE_UINT64); overload;
        procedure Init(subresource: UINT; RangeBegin: uint64; RangeEnd: uint64); overload;
    end;

    { TD3DX12_SHADER_BYTECODE }

    TD3DX12_SHADER_BYTECODE = type helper for TD3D12_SHADER_BYTECODE
        procedure Init;
        procedure Init({In_} pShaderBlob: ID3DBlob); overload;
        procedure Init(_pShaderBytecode: Pvoid; bytecodeLength: SIZE_T); overload;
        constructor Create(pShaderBlob: ID3DBlob); overload;
        constructor Create(const pShaderBytecode: pointer; bytecodeLength: SIZE_T); overload;
    end;


    { TD3DX12_TILED_RESOURCE_COORDINATE }

    TD3DX12_TILED_RESOURCE_COORDINATE = type helper for TD3D12_TILED_RESOURCE_COORDINATE
        procedure Init(x: UINT; y: UINT; z: UINT; subresource: UINT);
    end;


    { TD3DX12_TILE_REGION_SIZE }

    TD3DX12_TILE_REGION_SIZE = type helper for TD3D12_TILE_REGION_SIZE
        procedure Init(numTiles: UINT; useBox: boolean; Width: UINT; Height: uint16; depth: uint16);
    end;

    { TD3DX12_SUBRESOURCE_TILING }

    TD3DX12_SUBRESOURCE_TILING = type helper for TD3D12_SUBRESOURCE_TILING
        procedure Init(widthInTiles: UINT; heightInTiles: uint16; depthInTiles: uint16; startTileIndexInOverallResource: UINT);
    end;

    { TD3DX12_TILE_SHAPE }

    TD3DX12_TILE_SHAPE = type helper for TD3D12_TILE_SHAPE
        procedure Init(widthInTexels: UINT; heightInTexels: UINT; depthInTexels: UINT);
    end;

    { TD3DX12_PACKED_MIP_INFO }

    TD3DX12_PACKED_MIP_INFO = type helper for TD3D12_PACKED_MIP_INFO
        procedure Init(numStandardMips: uint8; numPackedMips: uint8; numTilesForPackedMips: UINT; startTileIndexInOverallResource: UINT);
    end;


    { TD3DX12_SUBRESOURCE_FOOTPRINT }

    TD3DX12_SUBRESOURCE_FOOTPRINT = type helper for TD3D12_SUBRESOURCE_FOOTPRINT
        procedure Init(); overload;
        procedure Init(format: TDXGI_FORMAT; Width: UINT; Height: UINT; depth: UINT; rowPitch: UINT); overload;
        procedure Init(resDesc: TD3D12_RESOURCE_DESC; rowPitch: UINT); overload;
    end;


    { TD3DX12_PLACED_SUBRESOURCE_FOOTPRINT }

    TD3DX12_PLACED_SUBRESOURCE_FOOTPRINT = type helper for TD3D12_PLACED_SUBRESOURCE_FOOTPRINT
        procedure Init();
    end;

    { TD3DX12_TEXTURE_COPY_LOCATION }

    TD3DX12_TEXTURE_COPY_LOCATION = type helper for TD3D12_TEXTURE_COPY_LOCATION
        procedure Init(
        {_In_ } pRes: PID3D12Resource); overload;
        procedure InitFootprint(
        {_In_ } pRes: PID3D12Resource; Footprint: TD3D12_PLACED_SUBRESOURCE_FOOTPRINT);
        procedure Init(
        {_In_ } pRes: PID3D12Resource; Sub: UINT); overload;
    end;

    { TD3DX12_FEATURE_DATA_FORMAT_INFO }

    TD3DX12_FEATURE_DATA_FORMAT_INFO = type helper for TD3D12_FEATURE_DATA_FORMAT_INFO
        procedure Init(Format: TDXGI_FORMAT; PlaneCount: uint8);
    end;


    { TD3DX12_RESOURCE_DESC }

    TD3DX12_RESOURCE_DESC = type helper for TD3D12_RESOURCE_DESC
        procedure Init(dimension: TD3D12_RESOURCE_DIMENSION; alignment: uint64; Width: uint64; Height: UINT; depthOrArraySize: uint16; mipLevels: uint16; format: TDXGI_FORMAT; sampleCount: UINT;
            sampleQuality: UINT; layout: TD3D12_TEXTURE_LAYOUT; flags: TD3D12_RESOURCE_FLAGS);
        procedure Buffer(resAllocInfo: TD3D12_RESOURCE_ALLOCATION_INFO; flags: TD3D12_RESOURCE_FLAGS = D3D12_RESOURCE_FLAG_NONE); overload;
        procedure Buffer(Width: uint64; flags: TD3D12_RESOURCE_FLAGS = D3D12_RESOURCE_FLAG_NONE; alignment: uint64 = 0); overload;
        procedure Tex1D(format: TDXGI_FORMAT; Width: uint64; arraySize: uint16 = 1; mipLevels: uint16 = 0; flags: TD3D12_RESOURCE_FLAGS = D3D12_RESOURCE_FLAG_NONE;
            layout: TD3D12_TEXTURE_LAYOUT = D3D12_TEXTURE_LAYOUT_UNKNOWN; alignment: uint64 = 0);
        procedure Tex2D(format: TDXGI_FORMAT; Width: uint64; Height: UINT; arraySize: uint16 = 1; mipLevels: uint16 = 0; sampleCount: UINT = 1; sampleQuality: UINT = 0;
            flags: TD3D12_RESOURCE_FLAGS = D3D12_RESOURCE_FLAG_NONE; layout: TD3D12_TEXTURE_LAYOUT = D3D12_TEXTURE_LAYOUT_UNKNOWN; alignment: uint64 = 0);
        procedure Tex3D(format: TDXGI_FORMAT; Width: uint64; Height: UINT; depth: uint16; mipLevels: uint16 = 0; flags: TD3D12_RESOURCE_FLAGS = D3D12_RESOURCE_FLAG_NONE;
            layout: TD3D12_TEXTURE_LAYOUT = D3D12_TEXTURE_LAYOUT_UNKNOWN; alignment: uint64 = 0);

        function Depth(): uint16;
        function ArraySize(): uint16;
        function PlaneCount({_In_ } pDevice: ID3D12Device): uint8;
        function Subresources({_In_ } pDevice: ID3D12Device): UINT;
        function CalcSubresource(MipSlice: UINT; ArraySlice: UINT; PlaneSlice: UINT): UINT;
        class function Create(dimension: TD3D12_RESOURCE_DIMENSION; alignment: uint64; Width: uint64; Height: UINT; depthOrArraySize: uint16; mipLevels: uint16; format: TDXGI_FORMAT; sampleCount: UINT;
            sampleQuality: UINT; layout: TD3D12_TEXTURE_LAYOUT; flags: TD3D12_RESOURCE_FLAGS): PD3D12_RESOURCE_DESC; static;
        class function CreateBuffer(resAllocInfo: TD3D12_RESOURCE_ALLOCATION_INFO; flags: TD3D12_RESOURCE_FLAGS = D3D12_RESOURCE_FLAG_NONE): PD3D12_RESOURCE_DESC; overload; static;
        class function CreateBuffer(Width: uint64; flags: TD3D12_RESOURCE_FLAGS = D3D12_RESOURCE_FLAG_NONE; alignment: uint64 = 0): PD3D12_RESOURCE_DESC; overload; static;
        class function CreateTex1D(format: TDXGI_FORMAT; Width: uint64; arraySize: uint16 = 1; mipLevels: uint16 = 0; flags: TD3D12_RESOURCE_FLAGS = D3D12_RESOURCE_FLAG_NONE;
            layout: TD3D12_TEXTURE_LAYOUT = D3D12_TEXTURE_LAYOUT_UNKNOWN; alignment: uint64 = 0): PD3D12_RESOURCE_DESC; static;
        class function CreateTex2D(format: TDXGI_FORMAT; Width: uint64; Height: UINT; arraySize: uint16 = 1; mipLevels: uint16 = 0; sampleCount: UINT = 1; sampleQuality: UINT = 0;
            flags: TD3D12_RESOURCE_FLAGS = D3D12_RESOURCE_FLAG_NONE; layout: TD3D12_TEXTURE_LAYOUT = D3D12_TEXTURE_LAYOUT_UNKNOWN; alignment: uint64 = 0): PD3D12_RESOURCE_DESC; static;
        class function CreateTex3D(format: TDXGI_FORMAT; Width: uint64; Height: UINT; depth: uint16; mipLevels: uint16 = 0; flags: TD3D12_RESOURCE_FLAGS = D3D12_RESOURCE_FLAG_NONE;
            layout: TD3D12_TEXTURE_LAYOUT = D3D12_TEXTURE_LAYOUT_UNKNOWN; alignment: uint64 = 0): PD3D12_RESOURCE_DESC; static;
    end;

    { TD3XD12_MIP_REGION }

    TD3XD12_MIP_REGION = type helper for TD3D12_MIP_REGION
        procedure Init();
    end;

    { TD3DX12_RESOURCE_DESC1 }

    TD3DX12_RESOURCE_DESC1 = type helper for TD3D12_RESOURCE_DESC1
         class function CreateBuffer(Width: uint64; flags: TD3D12_RESOURCE_FLAGS = D3D12_RESOURCE_FLAG_NONE; alignment: uint64 = 0):PD3D12_RESOURCE_DESC1;static;
        procedure Init(dimension: TD3D12_RESOURCE_DIMENSION; alignment: uint64; Width: uint64; Height: UINT; depthOrArraySize: uint16; mipLevels: uint16; format: TDXGI_FORMAT; sampleCount: UINT;
            sampleQuality: UINT; layout: TD3D12_TEXTURE_LAYOUT; flags: TD3D12_RESOURCE_FLAGS; samplerFeedbackMipRegionWidth: UINT = 0; samplerFeedbackMipRegionHeight: UINT = 0; samplerFeedbackMipRegionDepth: UINT = 0);
        procedure Buffer(resAllocInfo: TD3D12_RESOURCE_ALLOCATION_INFO; flags: TD3D12_RESOURCE_FLAGS = D3D12_RESOURCE_FLAG_NONE); overload;
        procedure Buffer(Width: uint64; flags: TD3D12_RESOURCE_FLAGS = D3D12_RESOURCE_FLAG_NONE; alignment: uint64 = 0); overload;
        procedure Tex1D(format: TDXGI_FORMAT; Width: uint64; arraySize: uint16 = 1; mipLevels: uint16 = 0; flags: TD3D12_RESOURCE_FLAGS = D3D12_RESOURCE_FLAG_NONE;
            layout: TD3D12_TEXTURE_LAYOUT = D3D12_TEXTURE_LAYOUT_UNKNOWN; alignment: uint64 = 0);
        procedure Tex2D(format: TDXGI_FORMAT; Width: uint64; Height: UINT; arraySize: uint16 = 1; mipLevels: uint16 = 0; sampleCount: UINT = 1; sampleQuality: UINT = 0;
            flags: TD3D12_RESOURCE_FLAGS = D3D12_RESOURCE_FLAG_NONE; layout: TD3D12_TEXTURE_LAYOUT = D3D12_TEXTURE_LAYOUT_UNKNOWN; alignment: uint64 = 0; samplerFeedbackMipRegionWidth: UINT = 0;
            samplerFeedbackMipRegionHeight: UINT = 0; samplerFeedbackMipRegionDepth: UINT = 0);
        procedure Tex3D(format: TDXGI_FORMAT; Width: uint64; Height: UINT; depth: uint16; mipLevels: uint16 = 0; flags: TD3D12_RESOURCE_FLAGS = D3D12_RESOURCE_FLAG_NONE;
            layout: TD3D12_TEXTURE_LAYOUT = D3D12_TEXTURE_LAYOUT_UNKNOWN; alignment: uint64 = 0);

        function Depth(): uint16; inline;
        function ArraySize(): uint16; inline;
        function PlaneCount({_In_ } pDevice: ID3D12Device): uint8; inline;
        function Subresources({_In_ } pDevice: ID3D12Device): UINT; inline;
        function CalcSubresource(MipSlice: UINT; ArraySlice: UINT; PlaneSlice: UINT): UINT; inline;
    end;

    { TD3DX12_SHADER_RESOURCE_VIEW_DESC }

    TD3DX12_SHADER_RESOURCE_VIEW_DESC = type helper for TD3D12_SHADER_RESOURCE_VIEW_DESC
        procedure StructuredBuffer(NumElements: UINT; StructureByteStride: UINT; FirstElement: uint64 = 0);
        procedure RawBuffer(NumElements: UINT; FirstElement: uint64 = 0);
        procedure TypedBuffer(Format: TDXGI_FORMAT; NumElements: UINT; FirstElement: uint64 = 0; Shader4ComponentMapping: UINT = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING);
        procedure Tex1D(Format: TDXGI_FORMAT; MipLevels: UINT = -1; MostDetailedMip: UINT = 0; ResourceMinLODClamp: single = 0.0; Shader4ComponentMapping: UINT = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING);
        procedure Tex1DArray(Format: TDXGI_FORMAT; ArraySize: UINT = -1; MipLevels: UINT = -1; FirstArraySlice: UINT = 0; MostDetailedMip: UINT = 0; ResourceMinLODClamp: single = 0.0;
            Shader4ComponentMapping: UINT = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING);
        procedure Tex2D(Format: TDXGI_FORMAT; MipLevels: UINT = -1; MostDetailedMip: UINT = 0; PlaneSlice: UINT = 0; ResourceMinLODClamp: single = 0.0; Shader4ComponentMapping: UINT = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING);
        procedure Tex2DArray(Format: TDXGI_FORMAT; ArraySize: UINT = -1; MipLevels: UINT = -1; FirstArraySlice: UINT = 0; MostDetailedMip: UINT = 0; PlaneSlice: UINT = 0; ResourceMinLODClamp: single = 0.0;
            Shader4ComponentMapping: UINT = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING);
        procedure Tex2DMS(Format: TDXGI_FORMAT; Shader4ComponentMapping: UINT = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING);
        procedure Tex2DMSArray(Format: TDXGI_FORMAT; ArraySize: UINT; FirstArraySlice: UINT = 0; Shader4ComponentMapping: UINT = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING);
        procedure Tex3D(Format: TDXGI_FORMAT; MipLevels: UINT = -1; MostDetailedMip: UINT = 0; ResourceMinLODClamp: single = 0.0; Shader4ComponentMapping: UINT = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING);
        procedure TexCube(Format: TDXGI_FORMAT; MipLevels: UINT = -1; MostDetailedMip: UINT = 0; ResourceMinLODClamp: single = 0.0; Shader4ComponentMapping: UINT = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING);
        procedure TexCubeArray(Format: TDXGI_FORMAT; NumCubes: UINT; MipLevels: UINT = -1; First2DArrayFace: UINT = 0; MostDetailedMip: UINT = 0; ResourceMinLODClamp: single = 0.0;
            Shader4ComponentMapping: UINT = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING);
        procedure RaytracingAccelStruct(Location: TD3D12_GPU_VIRTUAL_ADDRESS);
    end;


    { TD3DX12_UNORDERED_ACCESS_VIEW_DESC }

    TD3DX12_UNORDERED_ACCESS_VIEW_DESC = type helper for TD3D12_UNORDERED_ACCESS_VIEW_DESC
        procedure Init;
        procedure StructuredBuffer(NumElements: UINT; StructureByteStride: UINT; FirstElement: uint64 = 0; CounterOffsetInBytes: uint64 = 0);
        procedure RawBuffer(NumElements: UINT; FirstElement: uint64 = 0; CounterOffsetInBytes: uint64 = 0);
        procedure TypedBuffer(Format: TDXGI_FORMAT; NumElements: UINT; FirstElement: uint64 = 0; CounterOffsetInBytes: uint64 = 0);
        procedure Tex1D(Format: TDXGI_FORMAT; MipSlice: UINT = 0);
        procedure Tex1DArray(Format: TDXGI_FORMAT; ArraySize: UINT = -1; FirstArraySlice: UINT = 0; MipSlice: UINT = 0);
        procedure Tex2D(Format: TDXGI_FORMAT; MipSlice: UINT = 0; PlaneSlice: UINT = 0);
        procedure Tex2DArray(Format: TDXGI_FORMAT; ArraySize: UINT = -1; FirstArraySlice: UINT = 0; MipSlice: UINT = 0; PlaneSlice: UINT = 0);
        procedure Tex2DMS(Format: TDXGI_FORMAT);
        procedure Tex2DMSArray(Format: TDXGI_FORMAT; ArraySize: UINT = -1; FirstArraySlice: UINT = 0);
        procedure Tex3D(Format: TDXGI_FORMAT; WSize: UINT = -1; FirstWSlice: UINT = 0; MipSlice: UINT = 0);
    end;


    { TD3DX12_VIEW_INSTANCING_DESC }

    TD3DX12_VIEW_INSTANCING_DESC = type helper for TD3D12_VIEW_INSTANCING_DESC
        procedure Init(); overload;
        procedure Init(InViewInstanceCount: UINT; InViewInstanceLocations: PD3D12_VIEW_INSTANCE_LOCATION; InFlags: TD3D12_VIEW_INSTANCING_FLAGS); overload;
    end;


    { TD3DX12_RT_FORMAT_ARRAY }

    TD3DX12_RT_FORMAT_ARRAY = type helper for TD3D12_RT_FORMAT_ARRAY
        procedure Init({_In_reads_(NumFormats)} pFormats: PDXGI_FORMAT; NumFormats: UINT);
    end;

    { TD3DX12_SERIALIZED_ROOT_SIGNATURE_DESC }

    TD3DX12_SERIALIZED_ROOT_SIGNATURE_DESC = type helper for TD3D12_SERIALIZED_ROOT_SIGNATURE_DESC
        procedure Init(); overload;
        procedure Init(pData: Pvoid; size: SIZE_T); overload;
    end;


    { TD3DX12_MEMCPY_DEST }

    TD3DX12_MEMCPY_DEST = type helper for TD3D12_MEMCPY_DEST
        procedure Init(pData: Pvoid; RowPitch: SIZE_T; SlicePitch: SIZE_T);
    end;


    { TD3DX12_NODE_ID }

    TD3DX12_NODE_ID = type helper for TD3D12_NODE_ID
        procedure Init(Name: LPCWSTR; ArrayIndex: UINT);
    end;


    { TD3DX12_INPUT_LAYOUT_DESC }

    TD3DX12_INPUT_LAYOUT_DESC = type helper for TD3D12_INPUT_LAYOUT_DESC
        procedure Init;
    end;


function D3D12CalcSubresource(MipSlice: UINT; ArraySlice: UINT; PlaneSlice: UINT; MipLevels: UINT; ArraySize: UINT): UINT; inline;
function D3D12GetFormatPlaneCount({_In_ } pDevice: ID3D12Device; Format: TDXGI_FORMAT): uint8; inline;

//------------------------------------------------------------------------------------------------
// Fills in the mipmap and alignment values of pDesc when either members are zero
// Used to replace an implicit field to an explicit (0 mip map := max mip map level)
// If expansion has occured, returns LclDesc, else returns the original pDesc
function D3DX12ConditionallyExpandAPIDesc(LclDesc: PD3D12_RESOURCE_DESC1; pDesc: PD3D12_RESOURCE_DESC1; tightAlignmentSupported: boolean = False; alignAsCommitted: boolean = False): PD3D12_RESOURCE_DESC1;




implementation



function D3D12CalcSubresource(MipSlice: UINT; ArraySlice: UINT; PlaneSlice: UINT; MipLevels: UINT; ArraySize: UINT): UINT; inline;
begin
    Result := MipSlice + ArraySlice * MipLevels + PlaneSlice * MipLevels * ArraySize;
end;



function D3D12GetFormatPlaneCount(pDevice: ID3D12Device; Format: TDXGI_FORMAT): uint8; inline;
var
    formatInfo: TD3D12_FEATURE_DATA_FORMAT_INFO;
begin
    formatInfo.Init(Format, 0);
    if (FAILED(pDevice.CheckFeatureSupport(D3D12_FEATURE_FORMAT_INFO, @formatInfo, sizeof(formatInfo)))) then
    begin
        Result := 0;
        Exit;
    end;
    Result := formatInfo.PlaneCount;
end;

//------------------------------------------------------------------------------------------------
// Fills in the mipmap and alignment values of pDesc when either members are zero
// Used to replace an implicit field to an explicit (0 mip map := max mip map level)
// If expansion has occured, returns LclDesc, else returns the original pDesc
function D3DX12ConditionallyExpandAPIDesc(LclDesc: PD3D12_RESOURCE_DESC1; pDesc: PD3D12_RESOURCE_DESC1; tightAlignmentSupported: boolean; alignAsCommitted: boolean): PD3D12_RESOURCE_DESC1;



    function MaxMipLevels(uiMaxDimension: uint64): uint16;
    var
        uiRet: uint16 = 0;
    begin
        while (uiMaxDimension > 0) do
        begin
            Inc(uiRet);
            uiMaxDimension := uiMaxDimension shr 1;
        end;
        Result := uiRet;
    end;



    function Max(a, b: uint64): uint64;
    begin
        if (a < b) then
            Result := b
        else
            Result := a;
    end;

begin
    // Expand mip levels:
    if ((pDesc.MipLevels = 0) or (pDesc.Alignment = 0)) then
    begin
        LclDesc := pDesc;
        if (pDesc.MipLevels = 0) then
        begin
            if (LclDesc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE3D) then
                LclDesc.MipLevels := MaxMipLevels(Max(LclDesc.DepthOrArraySize, Max(LclDesc.Width, LclDesc.Height)))
            else
                LclDesc.MipLevels := MaxMipLevels(Max(1, Max(LclDesc.Width, LclDesc.Height)));

        end;
        if (pDesc.Alignment = 0) then
        begin
            if (pDesc.Layout = D3D12_TEXTURE_LAYOUT_64KB_UNDEFINED_SWIZZLE) or (pDesc.Layout = D3D12_TEXTURE_LAYOUT_64KB_STANDARD_SWIZZLE) then
            begin
                LclDesc.Alignment := D3D12_DEFAULT_RESOURCE_PLACEMENT_ALIGNMENT;
            end
            else if (not (tightAlignmentSupported) and ((Ord(pDesc.Flags) and Ord(D3D12_RESOURCE_FLAG_USE_TIGHT_ALIGNMENT)) = Ord(D3D12_RESOURCE_FLAG_USE_TIGHT_ALIGNMENT))) or
                ((Ord(pDesc.Flags) and Ord(D3D12_RESOURCE_FLAG_ALLOW_CROSS_ADAPTER)) = Ord(D3D12_RESOURCE_FLAG_ALLOW_CROSS_ADAPTER)) then
            begin
                if (pDesc.SampleDesc.Count > 1) then
                    LclDesc.Alignment := D3D12_DEFAULT_MSAA_RESOURCE_PLACEMENT_ALIGNMENT
                else
                    LclDesc.Alignment := D3D12_DEFAULT_RESOURCE_PLACEMENT_ALIGNMENT;
            end
            else
            begin
                // Tight alignment is supported and we aren't a cross adapter resource, now just need to set the alignment field to the minimum alignment for each type
                if (alignAsCommitted) then
                    LclDesc.Alignment := D3D12_TIGHT_ALIGNMENT_MIN_COMMITTED_RESOURCE_ALIGNMENT
                else
                    LclDesc.Alignment := D3D12_TIGHT_ALIGNMENT_MIN_PLACED_RESOURCE_ALIGNMENT;
            end;
        end;
        Result := LclDesc;
    end
    else
    begin
        Result := pDesc;
    end;
end;







{ TD3DX12_BOX }

procedure TD3DX12_BOX.Init(Left: LONG; Right: LONG);
begin
    left := (Left);
    top := 0;
    front := 0;
    right := (Right);
    bottom := 1;
    back := 1;
end;



procedure TD3DX12_BOX.Init(Left: LONG; Top: LONG; Right: LONG; Bottom: LONG);
begin
    left := (Left);
    top := (Top);
    front := 0;
    right := (Right);
    bottom := (Bottom);
    back := 1;
end;



procedure TD3DX12_BOX.Init(Left: LONG; Top: LONG; Front: LONG; Right: LONG; Bottom: LONG; Back: LONG);
begin
    left := (Left);
    top := (Top);
    front := (Front);
    right := (Right);
    bottom := (Bottom);
    back := (Back);
end;

{ TD3DX12_DEPTH_STENCIL_DESC }

procedure TD3DX12_DEPTH_STENCIL_DESC.Init;
begin
    self.DepthEnable := True;
    self.DepthWriteMask := D3D12_DEPTH_WRITE_MASK_ALL;
    self.DepthFunc := D3D12_COMPARISON_FUNC_LESS;
    self.StencilEnable := False;
    self.StencilReadMask := D3D12_DEFAULT_STENCIL_READ_MASK;
    self.StencilWriteMask := D3D12_DEFAULT_STENCIL_WRITE_MASK;
    self.FrontFace.Default;
    self.BackFace.Default;
end;



procedure TD3DX12_DEPTH_STENCIL_DESC.Init(depthEnable: boolean; depthWriteMask: TD3D12_DEPTH_WRITE_MASK; depthFunc: TD3D12_COMPARISON_FUNC; stencilEnable: boolean; stencilReadMask: uint8;
    stencilWriteMask: uint8; frontStencilFailOp: TD3D12_STENCIL_OP; frontStencilDepthFailOp: TD3D12_STENCIL_OP; frontStencilPassOp: TD3D12_STENCIL_OP; frontStencilFunc: TD3D12_COMPARISON_FUNC;
    backStencilFailOp: TD3D12_STENCIL_OP; backStencilDepthFailOp: TD3D12_STENCIL_OP; backStencilPassOp: TD3D12_STENCIL_OP; backStencilFunc: TD3D12_COMPARISON_FUNC);
begin
    self.DepthEnable := depthEnable;
    self.DepthWriteMask := depthWriteMask;
    self.DepthFunc := depthFunc;
    self.StencilEnable := stencilEnable;
    self.StencilReadMask := stencilReadMask;
    self.StencilWriteMask := stencilWriteMask;
    self.FrontFace.StencilFailOp := frontStencilFailOp;
    self.FrontFace.StencilDepthFailOp := frontStencilDepthFailOp;
    self.FrontFace.StencilPassOp := frontStencilPassOp;
    self.FrontFace.StencilFunc := frontStencilFunc;
    self.BackFace.StencilFailOp := backStencilFailOp;
    self.BackFace.StencilDepthFailOp := backStencilDepthFailOp;
    self.BackFace.StencilPassOp := backStencilPassOp;
    self.BackFace.StencilFunc := backStencilFunc;
end;

{ TD3DX12_BLEND_DESC }

constructor TD3DX12_BLEND_DESC.Create(Default: TD3D12_DEFAULT);
begin
    // nothing to do, initialize values are used
end;



procedure TD3DX12_BLEND_DESC.Init;
var
    i: uint;
begin
    self.AlphaToCoverageEnable := False;
    self.IndependentBlendEnable := False;

    for i := 0 to D3D12_SIMULTANEOUS_RENDER_TARGET_COUNT - 1 do
        self.RenderTarget[i].DefaultBlendDesc;
end;

{ TD3DX12_RASTERIZER_DESC }

procedure TD3DX12_RASTERIZER_DESC.Init;
begin
    self.FillMode := D3D12_FILL_MODE_SOLID;
    self.CullMode := D3D12_CULL_MODE_BACK;
    self.FrontCounterClockwise := False;
    self.DepthBias := D3D12_DEFAULT_DEPTH_BIAS;
    self.DepthBiasClamp := D3D12_DEFAULT_DEPTH_BIAS_CLAMP;
    self.SlopeScaledDepthBias := D3D12_DEFAULT_SLOPE_SCALED_DEPTH_BIAS;
    self.DepthClipEnable := True;
    self.MultisampleEnable := False;
    self.AntialiasedLineEnable := False;
    self.ForcedSampleCount := 0;
    self.ConservativeRaster := D3D12_CONSERVATIVE_RASTERIZATION_MODE_OFF;
end;



procedure TD3DX12_RASTERIZER_DESC.Init(fillMode: TD3D12_FILL_MODE; cullMode: TD3D12_CULL_MODE; frontCounterClockwise: boolean; depthBias: int32; depthBiasClamp: single; slopeScaledDepthBias: single;
    depthClipEnable: boolean; multisampleEnable: boolean; antialiasedLineEnable: boolean; forcedSampleCount: UINT; conservativeRaster: TD3D12_CONSERVATIVE_RASTERIZATION_MODE);
begin
    self.FillMode := fillMode;
    self.CullMode := cullMode;
    self.FrontCounterClockwise := frontCounterClockwise;
    self.DepthBias := depthBias;
    self.DepthBiasClamp := depthBiasClamp;
    self.SlopeScaledDepthBias := slopeScaledDepthBias;
    self.DepthClipEnable := depthClipEnable;
    self.MultisampleEnable := multisampleEnable;
    self.AntialiasedLineEnable := antialiasedLineEnable;
    self.ForcedSampleCount := forcedSampleCount;
    self.ConservativeRaster := conservativeRaster;
end;



constructor TD3DX12_RASTERIZER_DESC.Create(Default: TD3D12_DEFAULT);
begin
    // nothing to do, initialize values are used
end;



constructor TD3DX12_RASTERIZER_DESC.Create(fillMode: TD3D12_FILL_MODE; cullMode: TD3D12_CULL_MODE; frontCounterClockwise: boolean; depthBias: integer; depthBiasClamp: single;
    slopeScaledDepthBias: single; depthClipEnable: boolean; multisampleEnable: boolean; antialiasedLineEnable: boolean; forcedSampleCount: UINT; conservativeRaster: TD3D12_CONSERVATIVE_RASTERIZATION_MODE);
begin
    self.FillMode := fillMode;
    self.CullMode := cullMode;
    self.FrontCounterClockwise := frontCounterClockwise;
    self.DepthBias := depthBias;
    self.DepthBiasClamp := depthBiasClamp;
    self.SlopeScaledDepthBias := slopeScaledDepthBias;
    self.DepthClipEnable := depthClipEnable;
    self.MultisampleEnable := multisampleEnable;
    self.AntialiasedLineEnable := antialiasedLineEnable;
    self.ForcedSampleCount := forcedSampleCount;
    self.ConservativeRaster := conservativeRaster;
end;

{ TD3DX12_GRAPHICS_PIPELINE_STATE_DESC }

procedure TD3DX12_GRAPHICS_PIPELINE_STATE_DESC.Init;
var
    i: integer;
begin
    self.pRootSignature := nil;
    self.VS.Init;
    self.PS.Init;
    self.DS.Init;
    self.HS.Init;
    self.GS.Init;
    self.StreamOutput.Init;
    self.BlendState.Init;
    self.SampleMask := 0;
    self.RasterizerState.Init;
    self.DepthStencilState.Init;
    self.InputLayout.Init;
    self.IBStripCutValue := D3D12_INDEX_BUFFER_STRIP_CUT_VALUE_DISABLED;
    self.PrimitiveTopologyType := D3D12_PRIMITIVE_TOPOLOGY_TYPE_UNDEFINED;
    self.NumRenderTargets := 0;
    for i := 0 to 7 do
        self.RTVFormats[i] := DXGI_FORMAT_UNKNOWN;
    self.DSVFormat := DXGI_FORMAT_UNKNOWN;
    self.SampleDesc.Init;
    self.NodeMask := 0;
    self.CachedPSO.Init;
    self.Flags := D3D12_PIPELINE_STATE_FLAG_NONE;
end;

{ TD3DX12_STREAM_OUTPUT_DESC }

procedure TD3DX12_STREAM_OUTPUT_DESC.Init;
begin
    self.pSODeclaration := nil;
    self.NumEntries := 0;
    self.pBufferStrides := nil;
    self.NumStrides := 0;
    self.RasterizedStream := 0;
end;

{ TD3DX12_RASTERIZER_DESC1 }

procedure TD3DX12_RASTERIZER_DESC1.Init(fillMode: TD3D12_FILL_MODE; cullMode: TD3D12_CULL_MODE; frontCounterClockwise: boolean; depthBias: single; depthBiasClamp: single; slopeScaledDepthBias: single;
    depthClipEnable: boolean; multisampleEnable: boolean; antialiasedLineEnable: boolean; forcedSampleCount: UINT; conservativeRaster: TD3D12_CONSERVATIVE_RASTERIZATION_MODE);
begin
    self.FillMode := fillMode;
    self.CullMode := cullMode;
    self.FrontCounterClockwise := frontCounterClockwise;
    self.DepthBias := depthBias;
    self.DepthBiasClamp := depthBiasClamp;
    self.SlopeScaledDepthBias := slopeScaledDepthBias;
    self.DepthClipEnable := depthClipEnable;
    self.MultisampleEnable := multisampleEnable;
    self.AntialiasedLineEnable := antialiasedLineEnable;
    self.ForcedSampleCount := forcedSampleCount;
    self.ConservativeRaster := conservativeRaster;
end;

{ TD3DX12_RASTERIZER_DESC2 }

procedure TD3DX12_RASTERIZER_DESC2.Init(fillMode: TD3D12_FILL_MODE; cullMode: TD3D12_CULL_MODE; frontCounterClockwise: boolean; depthBias: single; depthBiasClamp: single; slopeScaledDepthBias: single;
    depthClipEnable: boolean; lineRasterizationMode: TD3D12_LINE_RASTERIZATION_MODE; forcedSampleCount: UINT; conservativeRaster: TD3D12_CONSERVATIVE_RASTERIZATION_MODE);
begin
    self.FillMode := fillMode;
    self.CullMode := cullMode;
    self.FrontCounterClockwise := frontCounterClockwise;
    self.DepthBias := depthBias;
    self.DepthBiasClamp := depthBiasClamp;
    self.SlopeScaledDepthBias := slopeScaledDepthBias;
    self.DepthClipEnable := depthClipEnable;
    self.LineRasterizationMode := lineRasterizationMode;
    self.ForcedSampleCount := forcedSampleCount;
    self.ConservativeRaster := conservativeRaster;
end;

{ TD3DX12_RESOURCE_ALLOCATION_INFO }

procedure TD3DX12_RESOURCE_ALLOCATION_INFO.Init(size: uint64; alignment: uint64);
begin
    self.SizeInBytes := size;
    self.Alignment := alignment;
end;

{ TD3DX12_HEAP_PROPERTIES }

procedure TD3DX12_HEAP_PROPERTIES.Init();
begin
  ZeroMemory(@self, SizeOf(TD3D12_HEAP_PROPERTIES));
end;

procedure TD3DX12_HEAP_PROPERTIES.Init(cpuPageProperty: TD3D12_CPU_PAGE_PROPERTY; memoryPoolPreference: TD3D12_MEMORY_POOL; creationNodeMask: UINT; nodeMask: UINT);
begin
    self.HeapType := D3D12_HEAP_TYPE_CUSTOM;
    self.CPUPageProperty := cpuPageProperty;
    self.MemoryPoolPreference := memoryPoolPreference;
    self.CreationNodeMask := creationNodeMask;
    self.VisibleNodeMask := nodeMask;
end;



procedure TD3DX12_HEAP_PROPERTIES.Init(HeapType: TD3D12_HEAP_TYPE; creationNodeMask: UINT; nodeMask: UINT);
begin
    self.HeapType := HeapType;
    self.CPUPageProperty := D3D12_CPU_PAGE_PROPERTY_UNKNOWN;
    self.MemoryPoolPreference := D3D12_MEMORY_POOL_UNKNOWN;
    self.CreationNodeMask := creationNodeMask;
    self.VisibleNodeMask := nodeMask;
end;



function TD3DX12_HEAP_PROPERTIES.IsCPUAccessible(): boolean;
begin
    Result := (HeapType = D3D12_HEAP_TYPE_UPLOAD) or (HeapType = D3D12_HEAP_TYPE_READBACK)
        {$IFDEF D3D12_SDK_VERSION_609}
        or (HeapType = D3D12_HEAP_TYPE_GPU_UPLOAD)
        {$ENDIF}
        or ((HeapType = D3D12_HEAP_TYPE_CUSTOM) and ((CPUPageProperty = D3D12_CPU_PAGE_PROPERTY_WRITE_COMBINE) or (CPUPageProperty = D3D12_CPU_PAGE_PROPERTY_WRITE_BACK)));
end;


  {
constructor TD3DX12_HEAP_PROPERTIES.Create(AType: TD3D12_HEAP_TYPE; CreationNodeMask: UINT; NodeMask: UINT);
begin
    Self.HeapType := AType;
    Self.CPUPageProperty := D3D12_CPU_PAGE_PROPERTY_UNKNOWN;
    Self.MemoryPoolPreference := D3D12_MEMORY_POOL_UNKNOWN;
    Self.CreationNodeMask := CreationNodeMask;
    Self.VisibleNodeMask := NodeMask;
end;



constructor TD3DX12_HEAP_PROPERTIES.Create(cpuPageProperty: TD3D12_CPU_PAGE_PROPERTY; memoryPoolPreference: TD3D12_MEMORY_POOL; creationNodeMask: UINT; nodeMask: UINT);
begin
    self.HeapType := D3D12_HEAP_TYPE_CUSTOM;
    self.CPUPageProperty := cpuPageProperty;
    self.MemoryPoolPreference := memoryPoolPreference;
    self.CreationNodeMask := creationNodeMask;
    self.VisibleNodeMask := nodeMask;
end;       }


class function TD3DX12_HEAP_PROPERTIES.Create(AType: TD3D12_HEAP_TYPE; CreationNodeMask: UINT; NodeMask: UINT): PD3D12_HEAP_PROPERTIES;
begin
    New(Result);
    Result^.HeapType := AType;
    Result^.CPUPageProperty := D3D12_CPU_PAGE_PROPERTY_UNKNOWN;
    Result^.MemoryPoolPreference := D3D12_MEMORY_POOL_UNKNOWN;
    Result^.CreationNodeMask := CreationNodeMask;
    Result^.VisibleNodeMask := NodeMask;

end;

{ TD3DX12_HEAP_DESC }

procedure TD3DX12_HEAP_DESC.Init(size: uint64; properties: TD3D12_HEAP_PROPERTIES; alignment: uint64; flags: TD3D12_HEAP_FLAGS);
begin
    self.SizeInBytes := size;
    self.Properties := properties;
    self.Alignment := alignment;
    self.Flags := flags;
end;



procedure TD3DX12_HEAP_DESC.Init(size: uint64; HeapType: TD3D12_HEAP_TYPE; alignment: uint64; flags: TD3D12_HEAP_FLAGS);
begin
    self.SizeInBytes := size;
    self.Properties.Init(HeapType);
    self.Alignment := alignment;
    self.Flags := flags;
end;



procedure TD3DX12_HEAP_DESC.Init(size: uint64; cpuPageProperty: TD3D12_CPU_PAGE_PROPERTY; memoryPoolPreference: TD3D12_MEMORY_POOL; alignment: uint64; flags: TD3D12_HEAP_FLAGS);
begin
    self.SizeInBytes := size;
    self.Properties.Init(cpuPageProperty, memoryPoolPreference);
    self.Alignment := alignment;
    self.Flags := flags;
end;



procedure TD3DX12_HEAP_DESC.Init(resAllocInfo: TD3D12_RESOURCE_ALLOCATION_INFO; properties: TD3D12_HEAP_PROPERTIES; flags: TD3D12_HEAP_FLAGS);
begin
    self.SizeInBytes := resAllocInfo.SizeInBytes;
    self.Properties := properties;
    self.Alignment := resAllocInfo.Alignment;
    self.Flags := flags;
end;



procedure TD3DX12_HEAP_DESC.Init(resAllocInfo: TD3D12_RESOURCE_ALLOCATION_INFO; HeapType: TD3D12_HEAP_TYPE; flags: TD3D12_HEAP_FLAGS);
begin
    self.SizeInBytes := resAllocInfo.SizeInBytes;
    self.Properties.Init(HeapType);
    self.Alignment := resAllocInfo.Alignment;
    self.Flags := flags;
end;



procedure TD3DX12_HEAP_DESC.Init(resAllocInfo: TD3D12_RESOURCE_ALLOCATION_INFO; cpuPageProperty: TD3D12_CPU_PAGE_PROPERTY; memoryPoolPreference: TD3D12_MEMORY_POOL; flags: TD3D12_HEAP_FLAGS);
begin
    self.SizeInBytes := resAllocInfo.SizeInBytes;
    self.Properties.Init(cpuPageProperty, memoryPoolPreference);
    self.Alignment := resAllocInfo.Alignment;
    self.Flags := flags;
end;



function TD3DX12_HEAP_DESC.IsCPUAccessible(): boolean;
begin
    Result := self.Properties.IsCPUAccessible();
end;

{ TD3DX12_CLEAR_VALUE }

procedure TD3DX12_CLEAR_VALUE.Init(format: TDXGI_FORMAT; color: TFloatArray4);
begin
    self.Format := format;
    move(color, self.color[0], SizeOf(TFloatArray4));
end;



procedure TD3DX12_CLEAR_VALUE.Init(format: TDXGI_FORMAT; depth: single; stencil: uint8);
begin
    self.Format := format;
    FillByte(Self.Color, sizeof(Color), 0);
    (* Use memcpy to preserve NAN values *)
    move(depth, self.DepthStencil.Depth, SizeOf(depth));
    self.DepthStencil.Stencil := stencil;
end;

{ TD3DX12_RANGE }

procedure TD3DX12_RANGE.Init(RangeBegin: SIZE_T; RangeEnd: SIZE_T);
begin
    self.RangeBegin := RangeBegin;
    self.RangeEnd := RangeEnd;
end;



constructor TD3DX12_RANGE.Create(RangeBegin: SIZE_T; RangeEnd: SIZE_T);
begin
    self.RangeBegin := RangeBegin;
    self.RangeEnd := RangeEnd;
end;

{ TD3DX12_RANGE_UINT64 }

procedure TD3DX12_RANGE_UINT64.Init(RangeBegin: uint64; RangeEnd: uint64);
begin
    self.RangeBegin := RangeBegin;
    self.RangeEnd := RangeEnd;
end;

{ TD3DX12_SUBRESOURCE_RANGE_UINT64 }

procedure TD3DX12_SUBRESOURCE_RANGE_UINT64.Init(subresource: UINT; range: TD3D12_RANGE_UINT64);
begin
    self.Subresource := subresource;
    self.Range := range;
end;



procedure TD3DX12_SUBRESOURCE_RANGE_UINT64.Init(subresource: UINT; RangeBegin: uint64; RangeEnd: uint64);
begin
    self.Subresource := subresource;
    self.Range.RangeBegin := RangeBegin;
    self.Range.RangeEnd := RangeEnd;
end;

{ TD3DX12_SHADER_BYTECODE }

procedure TD3DX12_SHADER_BYTECODE.Init(pShaderBlob: ID3DBlob);
begin
    self.pShaderBytecode := pShaderBlob.GetBufferPointer();
    self.BytecodeLength := pShaderBlob.GetBufferSize();
end;



procedure TD3DX12_SHADER_BYTECODE.Init(_pShaderBytecode: Pvoid; bytecodeLength: SIZE_T);
begin
    self.pShaderBytecode := _pShaderBytecode;
    self.BytecodeLength := bytecodeLength;
end;



constructor TD3DX12_SHADER_BYTECODE.Create(pShaderBlob: ID3DBlob);
begin
    self.pShaderBytecode := pShaderBlob.GetBufferPointer();
    self.BytecodeLength := pShaderBlob.GetBufferSize();
end;



constructor TD3DX12_SHADER_BYTECODE.Create(const pShaderBytecode: pointer; bytecodeLength: SIZE_T);
begin
    self.pShaderBytecode := pShaderBytecode;
    self.BytecodeLength := bytecodeLength;
end;



procedure TD3DX12_SHADER_BYTECODE.Init;
begin
    self.pShaderBytecode := nil;
    self.BytecodeLength := 0;
end;

{ TD3DX12_TILED_RESOURCE_COORDINATE }

procedure TD3DX12_TILED_RESOURCE_COORDINATE.Init(x: UINT; y: UINT; z: UINT; subresource: UINT);
begin
    self.X := x;
    self.Y := y;
    self.Z := z;
    self.Subresource := subresource;
end;

{ TD3DX12_TILE_REGION_SIZE }

procedure TD3DX12_TILE_REGION_SIZE.Init(numTiles: UINT; useBox: boolean; Width: UINT; Height: uint16; depth: uint16);
begin
    self.NumTiles := numTiles;
    self.UseBox := useBox;
    self.Width := Width;
    self.Height := Height;
    self.Depth := depth;
end;

{ TD3DX12_SUBRESOURCE_TILING }

procedure TD3DX12_SUBRESOURCE_TILING.Init(widthInTiles: UINT; heightInTiles: uint16; depthInTiles: uint16; startTileIndexInOverallResource: UINT);
begin
    self.WidthInTiles := widthInTiles;
    self.HeightInTiles := heightInTiles;
    self.DepthInTiles := depthInTiles;
    self.StartTileIndexInOverallResource := startTileIndexInOverallResource;
end;

{ TD3DX12_TILE_SHAPE }

procedure TD3DX12_TILE_SHAPE.Init(widthInTexels: UINT; heightInTexels: UINT; depthInTexels: UINT);
begin
    self.WidthInTexels := widthInTexels;
    self.HeightInTexels := heightInTexels;
    self.DepthInTexels := depthInTexels;
end;

{ TD3DX12_PACKED_MIP_INFO }

procedure TD3DX12_PACKED_MIP_INFO.Init(numStandardMips: uint8; numPackedMips: uint8; numTilesForPackedMips: UINT; startTileIndexInOverallResource: UINT);
begin
    self.NumStandardMips := numStandardMips;
    self.NumPackedMips := numPackedMips;
    self.NumTilesForPackedMips := numTilesForPackedMips;
    self.StartTileIndexInOverallResource := startTileIndexInOverallResource;
end;

{ TD3DX12_SUBRESOURCE_FOOTPRINT }

procedure TD3DX12_SUBRESOURCE_FOOTPRINT.Init();
begin
    ZeroMemory(@self, SizeOf(TD3DX12_SUBRESOURCE_FOOTPRINT));
end;



procedure TD3DX12_SUBRESOURCE_FOOTPRINT.Init(format: TDXGI_FORMAT; Width: UINT; Height: UINT; depth: UINT; rowPitch: UINT);
begin
    self.Format := format;
    self.Width := Width;
    self.Height := Height;
    self.Depth := depth;
    self.RowPitch := rowPitch;
end;



procedure TD3DX12_SUBRESOURCE_FOOTPRINT.Init(resDesc: TD3D12_RESOURCE_DESC; rowPitch: UINT);
begin
    self.Format := resDesc.Format;
    self.Width := UINT(resDesc.Width);
    self.Height := resDesc.Height;
    if (resDesc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE3D) then
        self.Depth := resDesc.DepthOrArraySize
    else
        self.Depth := 1;
    self.RowPitch := rowPitch;
end;

{ TD3DX12_PLACED_SUBRESOURCE_FOOTPRINT }

procedure TD3DX12_PLACED_SUBRESOURCE_FOOTPRINT.Init();
begin
    self.Offset := 0;
    self.Footprint.Init();
end;

{ TD3DX12_TEXTURE_COPY_LOCATION }

procedure TD3DX12_TEXTURE_COPY_LOCATION.Init(pRes: PID3D12Resource);overload;
begin
    self.pResource := pRes;
    self.CopyType := D3D12_TEXTURE_COPY_TYPE_SUBRESOURCE_INDEX;
    self.PlacedFootprint.Init();
end;



procedure TD3DX12_TEXTURE_COPY_LOCATION.InitFootprint(pRes: PID3D12Resource; Footprint: TD3D12_PLACED_SUBRESOURCE_FOOTPRINT);
begin
    self.pResource := pRes;
    self.CopyType := D3D12_TEXTURE_COPY_TYPE_PLACED_FOOTPRINT;
    self.PlacedFootprint := Footprint;
end;



procedure TD3DX12_TEXTURE_COPY_LOCATION.Init(pRes: PID3D12Resource; Sub: UINT); overload;
begin
    self.pResource := pRes;
    self.CopyType := D3D12_TEXTURE_COPY_TYPE_SUBRESOURCE_INDEX;
    self.PlacedFootprint.Init;
    self.SubresourceIndex := Sub;
end;

{ TD3DX12_FEATURE_DATA_FORMAT_INFO }

procedure TD3DX12_FEATURE_DATA_FORMAT_INFO.Init(Format: TDXGI_FORMAT; PlaneCount: uint8);
begin
    self.Format := Format;
    self.PlaneCount := PlaneCount;
end;

{ TD3DX12_RESOURCE_DESC }

procedure TD3DX12_RESOURCE_DESC.Init(dimension: TD3D12_RESOURCE_DIMENSION; alignment: uint64; Width: uint64; Height: UINT; depthOrArraySize: uint16; mipLevels: uint16; format: TDXGI_FORMAT;
    sampleCount: UINT; sampleQuality: UINT; layout: TD3D12_TEXTURE_LAYOUT; flags: TD3D12_RESOURCE_FLAGS);
begin
    self.Dimension := dimension;
    self.Alignment := alignment;
    self.Width := Width;
    self.Height := Height;
    self.DepthOrArraySize := depthOrArraySize;
    self.MipLevels := mipLevels;
    self.Format := format;
    self.SampleDesc.Count := sampleCount;
    self.SampleDesc.Quality := sampleQuality;
    self.Layout := layout;
    self.Flags := flags;
end;



procedure TD3DX12_RESOURCE_DESC.Buffer(resAllocInfo: TD3D12_RESOURCE_ALLOCATION_INFO; flags: TD3D12_RESOURCE_FLAGS);
begin
    Init(D3D12_RESOURCE_DIMENSION_BUFFER, resAllocInfo.Alignment, resAllocInfo.SizeInBytes,
        1, 1, 1, DXGI_FORMAT_UNKNOWN, 1, 0, D3D12_TEXTURE_LAYOUT_ROW_MAJOR, flags);
end;



procedure TD3DX12_RESOURCE_DESC.Buffer(Width: uint64; flags: TD3D12_RESOURCE_FLAGS; alignment: uint64);
begin
    self.Dimension := D3D12_RESOURCE_DIMENSION_BUFFER;
    self.Alignment := Alignment;
    self.Width := Width;
    self.Height := 1;
    self.DepthOrArraySize := 1;
    self.MipLevels := 1;
    self.Format := DXGI_FORMAT_UNKNOWN;
    self.SampleDesc.Count := 1;
    self.SampleDesc.Quality := 0;
    self.Layout := D3D12_TEXTURE_LAYOUT_ROW_MAJOR;
    self.Flags := flags;
end;



procedure TD3DX12_RESOURCE_DESC.Tex1D(format: TDXGI_FORMAT; Width: uint64; arraySize: uint16; mipLevels: uint16; flags: TD3D12_RESOURCE_FLAGS; layout: TD3D12_TEXTURE_LAYOUT; alignment: uint64);
begin
    Init(D3D12_RESOURCE_DIMENSION_TEXTURE1D, alignment, Width, 1, arraySize,
        mipLevels, format, 1, 0, layout, flags);
end;



procedure TD3DX12_RESOURCE_DESC.Tex2D(format: TDXGI_FORMAT; Width: uint64; Height: UINT; arraySize: uint16; mipLevels: uint16; sampleCount: UINT; sampleQuality: UINT; flags: TD3D12_RESOURCE_FLAGS;
    layout: TD3D12_TEXTURE_LAYOUT; alignment: uint64);
begin
    Init(D3D12_RESOURCE_DIMENSION_TEXTURE2D, alignment, Width, Height, arraySize,
        mipLevels, format, sampleCount, sampleQuality, layout, flags);
end;



procedure TD3DX12_RESOURCE_DESC.Tex3D(format: TDXGI_FORMAT; Width: uint64; Height: UINT; depth: uint16; mipLevels: uint16; flags: TD3D12_RESOURCE_FLAGS; layout: TD3D12_TEXTURE_LAYOUT; alignment: uint64);
begin
    Init(D3D12_RESOURCE_DIMENSION_TEXTURE3D, alignment, Width, Height, depth,
        mipLevels, format, 1, 0, layout, flags);
end;



function TD3DX12_RESOURCE_DESC.Depth(): uint16;
begin
    if (Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE3D) then
        Result := DepthOrArraySize
    else
        Result := 1;
end;



function TD3DX12_RESOURCE_DESC.ArraySize(): uint16;
begin
    if (Dimension <> D3D12_RESOURCE_DIMENSION_TEXTURE3D) then
        Result := DepthOrArraySize
    else
        Result := 1;
end;



function TD3DX12_RESOURCE_DESC.PlaneCount(pDevice: ID3D12Device): uint8;
begin
    Result := D3D12GetFormatPlaneCount(pDevice, Format);
end;



function TD3DX12_RESOURCE_DESC.Subresources(pDevice: ID3D12Device): UINT;
begin
    Result := UINT(MipLevels) * ArraySize() * PlaneCount(pDevice);
end;



function TD3DX12_RESOURCE_DESC.CalcSubresource(MipSlice: UINT; ArraySlice: UINT; PlaneSlice: UINT): UINT;
begin
    Result := D3D12CalcSubresource(MipSlice, ArraySlice, PlaneSlice, MipLevels, ArraySize());
end;



class function TD3DX12_RESOURCE_DESC.Create(dimension: TD3D12_RESOURCE_DIMENSION; alignment: uint64; Width: uint64; Height: UINT; depthOrArraySize: uint16; mipLevels: uint16; format: TDXGI_FORMAT;
    sampleCount: UINT; sampleQuality: UINT; layout: TD3D12_TEXTURE_LAYOUT; flags: TD3D12_RESOURCE_FLAGS): PD3D12_RESOURCE_DESC;
begin
    New(Result);
    Result^.Dimension := dimension;
    Result^.Alignment := alignment;
    Result^.Width := Width;
    Result^.Height := Height;
    Result^.DepthOrArraySize := depthOrArraySize;
    Result^.MipLevels := mipLevels;
    Result^.Format := format;
    Result^.SampleDesc.Count := sampleCount;
    Result^.SampleDesc.Quality := sampleQuality;
    Result^.Layout := layout;
    Result^.Flags := flags;
end;



class function TD3DX12_RESOURCE_DESC.CreateBuffer(resAllocInfo: TD3D12_RESOURCE_ALLOCATION_INFO; flags: TD3D12_RESOURCE_FLAGS): PD3D12_RESOURCE_DESC;
begin
    New(Result);
    Result^.Dimension := D3D12_RESOURCE_DIMENSION_BUFFER;
    Result^.Alignment := resAllocInfo.Alignment;
    Result^.Width := resAllocInfo.SizeInBytes;
    Result^.Height := 1;
    Result^.DepthOrArraySize := 1;
    Result^.MipLevels := 1;
    Result^.Format := DXGI_FORMAT_UNKNOWN;
    Result^.SampleDesc.Count := 1;
    Result^.SampleDesc.Quality := 0;
    Result^.Layout := D3D12_TEXTURE_LAYOUT_ROW_MAJOR;
    Result^.Flags := flags;
end;



class function TD3DX12_RESOURCE_DESC.CreateBuffer(Width: uint64; flags: TD3D12_RESOURCE_FLAGS; alignment: uint64): PD3D12_RESOURCE_DESC;
begin
    New(Result);
    Result^.Dimension := D3D12_RESOURCE_DIMENSION_BUFFER;
    Result^.Alignment := Alignment;
    Result^.Width := Width;
    Result^.Height := 1;
    Result^.DepthOrArraySize := 1;
    Result^.MipLevels := 1;
    Result^.Format := DXGI_FORMAT_UNKNOWN;
    Result^.SampleDesc.Count := 1;
    Result^.SampleDesc.Quality := 0;
    Result^.Layout := D3D12_TEXTURE_LAYOUT_ROW_MAJOR;
    Result^.Flags := flags;
end;



class function TD3DX12_RESOURCE_DESC.CreateTex1D(format: TDXGI_FORMAT; Width: uint64; arraySize: uint16; mipLevels: uint16; flags: TD3D12_RESOURCE_FLAGS; layout: TD3D12_TEXTURE_LAYOUT; alignment: uint64): PD3D12_RESOURCE_DESC;
begin
    New(Result);
    Result^.Dimension := D3D12_RESOURCE_DIMENSION_TEXTURE1D;
    Result^.Alignment := Alignment;
    Result^.Width := Width;
    Result^.Height := 1;
    Result^.DepthOrArraySize := arraySize;
    Result^.MipLevels := mipLevels;
    Result^.Format := format;
    Result^.SampleDesc.Count := 1;
    Result^.SampleDesc.Quality := 0;
    Result^.Layout := layout;
    Result^.Flags := flags;
end;



class function TD3DX12_RESOURCE_DESC.CreateTex2D(format: TDXGI_FORMAT; Width: uint64; Height: UINT; arraySize: uint16; mipLevels: uint16; sampleCount: UINT; sampleQuality: UINT;
    flags: TD3D12_RESOURCE_FLAGS; layout: TD3D12_TEXTURE_LAYOUT; alignment: uint64): PD3D12_RESOURCE_DESC;
begin
    New(Result);
    Result^.Dimension := D3D12_RESOURCE_DIMENSION_TEXTURE2D;
    Result^.Alignment := Alignment;
    Result^.Width := Width;
    Result^.Height := Height;
    Result^.DepthOrArraySize := arraySize;
    Result^.MipLevels := mipLevels;
    Result^.Format := format;
    Result^.SampleDesc.Count := sampleCount;
    Result^.SampleDesc.Quality := sampleQuality;
    Result^.Layout := layout;
    Result^.Flags := flags;
end;



class function TD3DX12_RESOURCE_DESC.CreateTex3D(format: TDXGI_FORMAT; Width: uint64; Height: UINT; depth: uint16; mipLevels: uint16; flags: TD3D12_RESOURCE_FLAGS; layout: TD3D12_TEXTURE_LAYOUT; alignment: uint64): PD3D12_RESOURCE_DESC;
begin
    New(Result);
    Result^.Dimension := D3D12_RESOURCE_DIMENSION_TEXTURE3D;
    Result^.Alignment := Alignment;
    Result^.Width := Width;
    Result^.Height := Height;
    Result^.DepthOrArraySize := depth;
    Result^.MipLevels := mipLevels;
    Result^.Format := format;
    Result^.SampleDesc.Count := 1;
    Result^.SampleDesc.Quality := 0;
    Result^.Layout := layout;
    Result^.Flags := flags;
end;


{ TD3XD12_MIP_REGION }

procedure TD3XD12_MIP_REGION.Init();
begin
    Self.Width := 0;
    Self.Height := 0;
    Self.Depth := 0;
end;

{ TD3DX12_RESOURCE_DESC1 }

class function TD3DX12_RESOURCE_DESC1.CreateBuffer(Width: uint64;
  flags: TD3D12_RESOURCE_FLAGS; alignment: uint64): PD3D12_RESOURCE_DESC1; static;
var
    x: PD3D12_RESOURCE_DESC1;
begin
   New(x);
   x^.Buffer(Width,flags,alignment);
   result:=x;
end;


procedure TD3DX12_RESOURCE_DESC1.Init(dimension: TD3D12_RESOURCE_DIMENSION; alignment: uint64; Width: uint64; Height: UINT; depthOrArraySize: uint16; mipLevels: uint16; format: TDXGI_FORMAT;
    sampleCount: UINT; sampleQuality: UINT; layout: TD3D12_TEXTURE_LAYOUT; flags: TD3D12_RESOURCE_FLAGS; samplerFeedbackMipRegionWidth: UINT; samplerFeedbackMipRegionHeight: UINT; samplerFeedbackMipRegionDepth: UINT);
begin
    Self.Dimension := dimension;
    Self.Alignment := alignment;
    Self.Width := Width;
    Self.Height := Height;
    Self.DepthOrArraySize := depthOrArraySize;
    Self.MipLevels := mipLevels;
    Self.Format := format;
    Self.SampleDesc.Count := sampleCount;
    Self.SampleDesc.Quality := sampleQuality;
    Self.Layout := layout;
    Self.Flags := flags;
    Self.SamplerFeedbackMipRegion.Width := samplerFeedbackMipRegionWidth;
    Self.SamplerFeedbackMipRegion.Height := samplerFeedbackMipRegionHeight;
    Self.SamplerFeedbackMipRegion.Depth := samplerFeedbackMipRegionDepth;
end;



procedure TD3DX12_RESOURCE_DESC1.Buffer(resAllocInfo: TD3D12_RESOURCE_ALLOCATION_INFO; flags: TD3D12_RESOURCE_FLAGS);
begin
    Init(D3D12_RESOURCE_DIMENSION_BUFFER, resAllocInfo.Alignment, resAllocInfo.SizeInBytes,
        1, 1, 1, DXGI_FORMAT_UNKNOWN, 1, 0, D3D12_TEXTURE_LAYOUT_ROW_MAJOR, flags, 0, 0, 0);
end;



procedure TD3DX12_RESOURCE_DESC1.Buffer(Width: uint64; flags: TD3D12_RESOURCE_FLAGS; alignment: uint64);
begin
    Init(D3D12_RESOURCE_DIMENSION_BUFFER, alignment, Width, 1, 1, 1,
        DXGI_FORMAT_UNKNOWN, 1, 0, D3D12_TEXTURE_LAYOUT_ROW_MAJOR, flags, 0, 0, 0);
end;



procedure TD3DX12_RESOURCE_DESC1.Tex1D(format: TDXGI_FORMAT; Width: uint64; arraySize: uint16; mipLevels: uint16; flags: TD3D12_RESOURCE_FLAGS; layout: TD3D12_TEXTURE_LAYOUT; alignment: uint64);
begin
    Init(D3D12_RESOURCE_DIMENSION_TEXTURE1D, alignment, Width, 1, arraySize,
        mipLevels, format, 1, 0, layout, flags, 0, 0, 0);
end;



procedure TD3DX12_RESOURCE_DESC1.Tex2D(format: TDXGI_FORMAT; Width: uint64; Height: UINT; arraySize: uint16; mipLevels: uint16; sampleCount: UINT; sampleQuality: UINT; flags: TD3D12_RESOURCE_FLAGS;
    layout: TD3D12_TEXTURE_LAYOUT; alignment: uint64; samplerFeedbackMipRegionWidth: UINT; samplerFeedbackMipRegionHeight: UINT; samplerFeedbackMipRegionDepth: UINT);
begin
    Init(D3D12_RESOURCE_DIMENSION_TEXTURE2D, alignment, Width, Height, arraySize,
        mipLevels, format, sampleCount, sampleQuality, layout, flags, samplerFeedbackMipRegionWidth,
        samplerFeedbackMipRegionHeight, samplerFeedbackMipRegionDepth);
end;



procedure TD3DX12_RESOURCE_DESC1.Tex3D(format: TDXGI_FORMAT; Width: uint64; Height: UINT; depth: uint16; mipLevels: uint16; flags: TD3D12_RESOURCE_FLAGS; layout: TD3D12_TEXTURE_LAYOUT; alignment: uint64);
begin
    Init(D3D12_RESOURCE_DIMENSION_TEXTURE3D, alignment, Width, Height, depth,
        mipLevels, format, 1, 0, layout, flags, 0, 0, 0);
end;



function TD3DX12_RESOURCE_DESC1.Depth(): uint16;
begin
    if (Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE3D) then
        Result := DepthOrArraySize
    else
        Result := 1;
end;



function TD3DX12_RESOURCE_DESC1.ArraySize(): uint16;
begin
    if (Dimension <> D3D12_RESOURCE_DIMENSION_TEXTURE3D) then
        Result := DepthOrArraySize
    else
        Result := 1;
end;



function TD3DX12_RESOURCE_DESC1.PlaneCount(pDevice: ID3D12Device): uint8;
begin
    Result := D3D12GetFormatPlaneCount(pDevice, Format);
end;



function TD3DX12_RESOURCE_DESC1.Subresources(pDevice: ID3D12Device): UINT;
begin
    Result := UINT(MipLevels) * ArraySize() * PlaneCount(pDevice);
end;



function TD3DX12_RESOURCE_DESC1.CalcSubresource(MipSlice: UINT; ArraySlice: UINT; PlaneSlice: UINT): UINT;
begin
    Result := D3D12CalcSubresource(MipSlice, ArraySlice, PlaneSlice, MipLevels, ArraySize());
end;

{ TD3DX12_SHADER_RESOURCE_VIEW_DESC }

procedure TD3DX12_SHADER_RESOURCE_VIEW_DESC.StructuredBuffer(NumElements: UINT; StructureByteStride: UINT; FirstElement: uint64);
begin
    self.Format := DXGI_FORMAT_UNKNOWN;
    self.ViewDimension := D3D12_SRV_DIMENSION_BUFFER;
    self.Shader4ComponentMapping := D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
    self.Buffer.FirstElement := FirstElement;
    self.Buffer.NumElements := NumElements;
    self.Buffer.StructureByteStride := StructureByteStride;
    self.Buffer.Flags := D3D12_BUFFER_SRV_FLAG_NONE;
end;



procedure TD3DX12_SHADER_RESOURCE_VIEW_DESC.RawBuffer(NumElements: UINT; FirstElement: uint64);
begin
    self.Format := DXGI_FORMAT_R32_TYPELESS; // DXGI_FORMAT_R32_UINT;
    self.ViewDimension := D3D12_SRV_DIMENSION_BUFFER;
    self.Shader4ComponentMapping := D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
    self.Buffer.FirstElement := FirstElement;
    self.Buffer.NumElements := NumElements;
    self.Buffer.StructureByteStride := 0;
    self.Buffer.Flags := D3D12_BUFFER_SRV_FLAG_RAW;
end;



procedure TD3DX12_SHADER_RESOURCE_VIEW_DESC.TypedBuffer(Format: TDXGI_FORMAT; NumElements: UINT; FirstElement: uint64; Shader4ComponentMapping: UINT);
begin
    self.Format := Format;
    self.ViewDimension := D3D12_SRV_DIMENSION_BUFFER;
    self.Shader4ComponentMapping := Shader4ComponentMapping;
    self.Buffer.FirstElement := FirstElement;
    self.Buffer.NumElements := NumElements;
    self.Buffer.StructureByteStride := 0;
    self.Buffer.Flags := D3D12_BUFFER_SRV_FLAG_NONE;
end;



procedure TD3DX12_SHADER_RESOURCE_VIEW_DESC.Tex1D(Format: TDXGI_FORMAT; MipLevels: UINT; MostDetailedMip: UINT; ResourceMinLODClamp: single; Shader4ComponentMapping: UINT);
begin
    self.Format := Format;
    self.ViewDimension := D3D12_SRV_DIMENSION_TEXTURE1D;
    self.Shader4ComponentMapping := Shader4ComponentMapping;
    self.Texture1D.MostDetailedMip := MostDetailedMip;
    self.Texture1D.MipLevels := MipLevels;
    self.Texture1D.ResourceMinLODClamp := ResourceMinLODClamp;
end;



procedure TD3DX12_SHADER_RESOURCE_VIEW_DESC.Tex1DArray(Format: TDXGI_FORMAT; ArraySize: UINT; MipLevels: UINT; FirstArraySlice: UINT; MostDetailedMip: UINT; ResourceMinLODClamp: single; Shader4ComponentMapping: UINT);
begin
    self.Format := Format;
    self.ViewDimension := D3D12_SRV_DIMENSION_TEXTURE1DARRAY;
    self.Shader4ComponentMapping := Shader4ComponentMapping;
    self.Texture1DArray.MostDetailedMip := MostDetailedMip;
    self.Texture1DArray.MipLevels := MipLevels;
    self.Texture1DArray.FirstArraySlice := FirstArraySlice;
    self.Texture1DArray.ArraySize := ArraySize;
    self.Texture1DArray.ResourceMinLODClamp := ResourceMinLODClamp;
end;



procedure TD3DX12_SHADER_RESOURCE_VIEW_DESC.Tex2D(Format: TDXGI_FORMAT; MipLevels: UINT; MostDetailedMip: UINT; PlaneSlice: UINT; ResourceMinLODClamp: single; Shader4ComponentMapping: UINT);
begin
    self.Format := Format;
    self.ViewDimension := D3D12_SRV_DIMENSION_TEXTURE2D;
    self.Shader4ComponentMapping := Shader4ComponentMapping;
    self.Texture2D.MostDetailedMip := MostDetailedMip;
    self.Texture2D.MipLevels := MipLevels;
    self.Texture2D.PlaneSlice := PlaneSlice;
    self.Texture2D.ResourceMinLODClamp := ResourceMinLODClamp;
end;



procedure TD3DX12_SHADER_RESOURCE_VIEW_DESC.Tex2DArray(Format: TDXGI_FORMAT; ArraySize: UINT; MipLevels: UINT; FirstArraySlice: UINT; MostDetailedMip: UINT; PlaneSlice: UINT; ResourceMinLODClamp: single; Shader4ComponentMapping: UINT);
begin
    self.Format := Format;
    self.ViewDimension := D3D12_SRV_DIMENSION_TEXTURE2DARRAY;
    self.Shader4ComponentMapping := Shader4ComponentMapping;
    self.Texture2DArray.MostDetailedMip := MostDetailedMip;
    self.Texture2DArray.MipLevels := MipLevels;
    self.Texture2DArray.FirstArraySlice := FirstArraySlice;
    self.Texture2DArray.ArraySize := ArraySize;
    self.Texture2DArray.PlaneSlice := PlaneSlice;
    self.Texture2DArray.ResourceMinLODClamp := ResourceMinLODClamp;
end;



procedure TD3DX12_SHADER_RESOURCE_VIEW_DESC.Tex2DMS(Format: TDXGI_FORMAT; Shader4ComponentMapping: UINT);
begin
    self.Format := Format;
    self.ViewDimension := D3D12_SRV_DIMENSION_TEXTURE2DMS;
    self.Shader4ComponentMapping := Shader4ComponentMapping;
    // self.Texture2DMS.UnusedField_NothingToDefine := 0;
end;



procedure TD3DX12_SHADER_RESOURCE_VIEW_DESC.Tex2DMSArray(Format: TDXGI_FORMAT; ArraySize: UINT; FirstArraySlice: UINT; Shader4ComponentMapping: UINT);
begin
    self.Format := Format;
    self.ViewDimension := D3D12_SRV_DIMENSION_TEXTURE2DMSARRAY;
    self.Shader4ComponentMapping := Shader4ComponentMapping;
    self.Texture2DMSArray.ArraySize := ArraySize;
    self.Texture2DMSArray.FirstArraySlice := FirstArraySlice;
end;



procedure TD3DX12_SHADER_RESOURCE_VIEW_DESC.Tex3D(Format: TDXGI_FORMAT; MipLevels: UINT; MostDetailedMip: UINT; ResourceMinLODClamp: single; Shader4ComponentMapping: UINT);
begin
    self.Format := Format;
    self.ViewDimension := D3D12_SRV_DIMENSION_TEXTURE3D;
    self.Shader4ComponentMapping := Shader4ComponentMapping;
    self.Texture3D.MostDetailedMip := MostDetailedMip;
    self.Texture3D.MipLevels := MipLevels;
    self.Texture3D.ResourceMinLODClamp := ResourceMinLODClamp;
end;



procedure TD3DX12_SHADER_RESOURCE_VIEW_DESC.TexCube(Format: TDXGI_FORMAT; MipLevels: UINT; MostDetailedMip: UINT; ResourceMinLODClamp: single; Shader4ComponentMapping: UINT);
begin
    self.Format := Format;
    self.ViewDimension := D3D12_SRV_DIMENSION_TEXTURECUBE;
    self.Shader4ComponentMapping := Shader4ComponentMapping;
    self.TextureCube.MostDetailedMip := MostDetailedMip;
    self.TextureCube.MipLevels := MipLevels;
    self.TextureCube.ResourceMinLODClamp := ResourceMinLODClamp;
end;



procedure TD3DX12_SHADER_RESOURCE_VIEW_DESC.TexCubeArray(Format: TDXGI_FORMAT; NumCubes: UINT; MipLevels: UINT; First2DArrayFace: UINT; MostDetailedMip: UINT; ResourceMinLODClamp: single; Shader4ComponentMapping: UINT);
begin
    self.Format := Format;
    self.ViewDimension := D3D12_SRV_DIMENSION_TEXTURECUBEARRAY;
    self.Shader4ComponentMapping := Shader4ComponentMapping;
    self.TextureCubeArray.NumCubes := NumCubes;
    self.TextureCubeArray.MostDetailedMip := MostDetailedMip;
    self.TextureCubeArray.MipLevels := MipLevels;
    self.TextureCubeArray.First2DArrayFace := First2DArrayFace;
    self.TextureCubeArray.ResourceMinLODClamp := ResourceMinLODClamp;
end;



procedure TD3DX12_SHADER_RESOURCE_VIEW_DESC.RaytracingAccelStruct(Location: TD3D12_GPU_VIRTUAL_ADDRESS);
begin
    self.Format := DXGI_FORMAT_UNKNOWN;
    self.ViewDimension := D3D12_SRV_DIMENSION_RAYTRACING_ACCELERATION_STRUCTURE;
    self.Shader4ComponentMapping := D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
    self.RaytracingAccelerationStructure.Location := Location;
end;

{ TD3DX12_UNORDERED_ACCESS_VIEW_DESC }

procedure TD3DX12_UNORDERED_ACCESS_VIEW_DESC.Init;
begin
  ZeroMemory(@self, SizeOf(TD3D12_UNORDERED_ACCESS_VIEW_DESC));
end;

procedure TD3DX12_UNORDERED_ACCESS_VIEW_DESC.StructuredBuffer(NumElements: UINT; StructureByteStride: UINT; FirstElement: uint64; CounterOffsetInBytes: uint64);
begin
    self.Format := DXGI_FORMAT_UNKNOWN;
    self.ViewDimension := D3D12_UAV_DIMENSION_BUFFER;
    self.Buffer.FirstElement := FirstElement;
    self.Buffer.NumElements := NumElements;
    self.Buffer.StructureByteStride := StructureByteStride;
    self.Buffer.Flags := D3D12_BUFFER_UAV_FLAG_NONE;
    self.Buffer.CounterOffsetInBytes := CounterOffsetInBytes;
end;



procedure TD3DX12_UNORDERED_ACCESS_VIEW_DESC.RawBuffer(NumElements: UINT; FirstElement: uint64; CounterOffsetInBytes: uint64);
begin
    self.Format :=DXGI_FORMAT_R32_TYPELESS ; // DXGI_FORMAT_R32_UINT;
    self.ViewDimension := D3D12_UAV_DIMENSION_BUFFER;
    self.Buffer.FirstElement := FirstElement;
    self.Buffer.NumElements := NumElements;
    self.Buffer.StructureByteStride := 0;
    self.Buffer.Flags := D3D12_BUFFER_UAV_FLAG_RAW;
    self.Buffer.CounterOffsetInBytes := CounterOffsetInBytes;
end;



procedure TD3DX12_UNORDERED_ACCESS_VIEW_DESC.TypedBuffer(Format: TDXGI_FORMAT; NumElements: UINT; FirstElement: uint64; CounterOffsetInBytes: uint64);
begin
    self.Format := Format;
    self.ViewDimension := D3D12_UAV_DIMENSION_BUFFER;
    self.Buffer.FirstElement := FirstElement;
    self.Buffer.NumElements := NumElements;
    self.Buffer.StructureByteStride := 0;
    self.Buffer.Flags := D3D12_BUFFER_UAV_FLAG_NONE;
    self.Buffer.CounterOffsetInBytes := CounterOffsetInBytes;
end;



procedure TD3DX12_UNORDERED_ACCESS_VIEW_DESC.Tex1D(Format: TDXGI_FORMAT; MipSlice: UINT);
begin
    self.Format := Format;
    self.ViewDimension := D3D12_UAV_DIMENSION_TEXTURE1D;
    self.Texture1D.MipSlice := MipSlice;
end;



procedure TD3DX12_UNORDERED_ACCESS_VIEW_DESC.Tex1DArray(Format: TDXGI_FORMAT; ArraySize: UINT; FirstArraySlice: UINT; MipSlice: UINT);
begin
    self.Format := Format;
    self.ViewDimension := D3D12_UAV_DIMENSION_TEXTURE1DARRAY;
    self.Texture1DArray.MipSlice := MipSlice;
    self.Texture1DArray.FirstArraySlice := FirstArraySlice;
    self.Texture1DArray.ArraySize := ArraySize;
end;



procedure TD3DX12_UNORDERED_ACCESS_VIEW_DESC.Tex2D(Format: TDXGI_FORMAT; MipSlice: UINT; PlaneSlice: UINT);
begin
    self.Format := Format;
    self.ViewDimension := D3D12_UAV_DIMENSION_TEXTURE2D;
    self.Texture2D.MipSlice := MipSlice;
    self.Texture2D.PlaneSlice := PlaneSlice;
end;



procedure TD3DX12_UNORDERED_ACCESS_VIEW_DESC.Tex2DArray(Format: TDXGI_FORMAT; ArraySize: UINT; FirstArraySlice: UINT; MipSlice: UINT; PlaneSlice: UINT);
begin
    self.Format := Format;
    self.ViewDimension := D3D12_UAV_DIMENSION_TEXTURE2DARRAY;
    self.Texture2DArray.MipSlice := MipSlice;
    self.Texture2DArray.FirstArraySlice := FirstArraySlice;
    self.Texture2DArray.ArraySize := ArraySize;
    self.Texture2DArray.PlaneSlice := PlaneSlice;
end;



procedure TD3DX12_UNORDERED_ACCESS_VIEW_DESC.Tex2DMS(Format: TDXGI_FORMAT);
begin
    self.Format := Format;
    self.ViewDimension := D3D12_UAV_DIMENSION_TEXTURE2DMS;
    //self.Texture2DMS.UnusedField_NothingToDefine := 0;
end;



procedure TD3DX12_UNORDERED_ACCESS_VIEW_DESC.Tex2DMSArray(Format: TDXGI_FORMAT; ArraySize: UINT; FirstArraySlice: UINT);
begin
    self.Format := Format;
    self.ViewDimension := D3D12_UAV_DIMENSION_TEXTURE2DMSARRAY;
    self.Texture2DMSArray.FirstArraySlice := FirstArraySlice;
    self.Texture2DMSArray.ArraySize := ArraySize;
end;



procedure TD3DX12_UNORDERED_ACCESS_VIEW_DESC.Tex3D(Format: TDXGI_FORMAT; WSize: UINT; FirstWSlice: UINT; MipSlice: UINT);
begin
    self.Format := Format;
    self.ViewDimension := D3D12_UAV_DIMENSION_TEXTURE3D;
    self.Texture3D.MipSlice := MipSlice;
    self.Texture3D.FirstWSlice := FirstWSlice;
    self.Texture3D.WSize := WSize;
end;

{ TD3DX12_VIEW_INSTANCING_DESC }

procedure TD3DX12_VIEW_INSTANCING_DESC.Init();
begin
    self.ViewInstanceCount := 0;
    self.pViewInstanceLocations := nil;
    self.Flags := D3D12_VIEW_INSTANCING_FLAG_NONE;
end;



procedure TD3DX12_VIEW_INSTANCING_DESC.Init(InViewInstanceCount: UINT; InViewInstanceLocations: PD3D12_VIEW_INSTANCE_LOCATION; InFlags: TD3D12_VIEW_INSTANCING_FLAGS);
begin
    self.ViewInstanceCount := InViewInstanceCount;
    self.pViewInstanceLocations := InViewInstanceLocations;
    self.Flags := InFlags;
end;

{ TD3DX12_RT_FORMAT_ARRAY }

procedure TD3DX12_RT_FORMAT_ARRAY.Init(pFormats: PDXGI_FORMAT; NumFormats: UINT);
begin
    self.NumRenderTargets := NumFormats;
    Move(pFormats^, self.RTFormats, sizeof(RTFormats));
    // assumes ARRAY_SIZE(pFormats) = ARRAY_SIZE(RTFormats)
end;

{ TD3DX12_SERIALIZED_ROOT_SIGNATURE_DESC }

procedure TD3DX12_SERIALIZED_ROOT_SIGNATURE_DESC.Init();
begin
    self.pSerializedBlob := nil;
    self.SerializedBlobSizeInBytes := 0;
end;



procedure TD3DX12_SERIALIZED_ROOT_SIGNATURE_DESC.Init(pData: Pvoid; size: SIZE_T);
begin
    self.pSerializedBlob := pData;
    self.SerializedBlobSizeInBytes := size;
end;

{ TD3DX12_MEMCPY_DEST }

procedure TD3DX12_MEMCPY_DEST.Init(pData: Pvoid; RowPitch: SIZE_T; SlicePitch: SIZE_T);
begin
    self.pData := pData;
    self.RowPitch := RowPitch;
    self.SlicePitch := SlicePitch;
end;

{ TD3DX12_NODE_ID }

procedure TD3DX12_NODE_ID.Init(Name: LPCWSTR; ArrayIndex: UINT);
begin
    self.Name := Name;
    self.ArrayIndex := ArrayIndex;
end;

{ TD3DX12_INPUT_LAYOUT_DESC }

procedure TD3DX12_INPUT_LAYOUT_DESC.Init;
begin
    self.pInputElementDescs := nil;
    self.NumElements := 0;
end;

end.
