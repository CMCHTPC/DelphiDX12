unit DX12.D3DX12;
//*********************************************************

// Copyright (c) Microsoft. All rights reserved.
// This code is licensed under the MIT License (MIT).
// THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
// IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
// PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.

//*********************************************************

{$IFDEF FPC}
{$mode delphi}
//{$mode objfpc}
{$MODESWITCH ADVANCEDRECORDS}
{$MODESWITCH TYPEHELPERS}
{$macro on}
{$ELSE}
{$POINTERMATH ON}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3DCommon,
    DX12.D3D12, DX12.DXGI;

const
    UINT_MAX: UINT = $ffffffff;
    {$IFDEF WIN32}
    SIZE_MAX: UINT32 = $ffffffff;
    {$ELSE}
    SIZE_MAX: UINT64 = $ffffffffffffffff;
    {$ENDIF}
    MaxSubresources: UINT = 100; // ToDo

type

    TD3DX12_HEAP_PROPERTIES = TD3D12_HEAP_PROPERTIES;
    TD3DX12_RESOURCE_DESC = TD3D12_RESOURCE_DESC;
    TD3DX12_RESOURCE_BARRIER = TD3D12_RESOURCE_BARRIER;
    TD3DX12_DESCRIPTOR_RANGE = TD3D12_DESCRIPTOR_RANGE;
    TD3DX12_ROOT_PARAMETER = TD3D12_ROOT_PARAMETER;
    TD3DX12_ROOT_DESCRIPTOR_TABLE = TD3D12_ROOT_DESCRIPTOR_TABLE;
    TD3DX12_ROOT_SIGNATURE_DESC = TD3D12_ROOT_SIGNATURE_DESC;

    TD3DX12_DEPTH_STENCIL_DESC1 = TD3D12_DEPTH_STENCIL_DESC1;
    TD3DX12_VIEW_INSTANCING_DESC= TD3D12_VIEW_INSTANCING_DESC;


    TD3DX12_RASTERIZER_DESC = TD3D12_RASTERIZER_DESC;
    TD3DX12_BLEND_DESC = TD3D12_BLEND_DESC;
    TD3DX12_DEPTH_STENCIL_DESC = TD3D12_DEPTH_STENCIL_DESC;

    TD3DX12_TEXTURE_COPY_LOCATION = TD3D12_TEXTURE_COPY_LOCATION;
    TD3DX12_RANGE = TD3D12_RANGE;


    //------------------------------------------------------------------------------------------------

    { TD3DX12_CPU_DESCRIPTOR_HANDLE }

    {$IFDEF FPC}
    TD3DX12_CPU_DESCRIPTOR_HANDLE = type helper for TD3D12_CPU_DESCRIPTOR_HANDLE
        //  class operator Explicit(a:TD3D12_CPU_DESCRIPTOR_HANDLE): TD3DX12_CPU_DESCRIPTOR_HANDLE;
        //   class operator initialize(var aRec:TD3DX12_CPU_DESCRIPTOR_HANDLE);
        procedure Offset(offsetScaledByIncrementSize: integer); overload;
        procedure Offset(offsetInDescriptors: integer; descriptorIncrementSize: UINT); overload;
    end;
    {$ENDIF}



    { TD3DX12_PIPELINE_STATE_STREAM_FLAGS }

    TD3DX12_PIPELINE_STATE_STREAM_FLAGS = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE;// D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_FLAGS;
       _Inner:TD3D12_PIPELINE_STATE_FLAGS;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_FLAGS);
       {$ENDIF}
       constructor Create(i:TD3D12_PIPELINE_STATE_FLAGS);
    end;

    { TD3DX12_PIPELINE_STATE_STREAM_NODE_MASK }

    TD3DX12_PIPELINE_STATE_STREAM_NODE_MASK = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; // D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_NODE_MASK;
       _Inner:UINT;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_NODE_MASK);
       {$ENDIF}
       constructor Create(i:UINT);
    end;

    { TD3DX12_PIPELINE_STATE_STREAM_ROOT_SIGNATURE }

    TD3DX12_PIPELINE_STATE_STREAM_ROOT_SIGNATURE = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; // D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE;
       _Inner:ID3D12RootSignature;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_ROOT_SIGNATURE);
       {$ENDIF}
       constructor Create(i:ID3D12RootSignature);
    end;


    { TD3DX12_PIPELINE_STATE_STREAM_INPUT_LAYOUT }

    TD3DX12_PIPELINE_STATE_STREAM_INPUT_LAYOUT = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; // D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE;
       _Inner:TD3D12_INPUT_LAYOUT_DESC;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_INPUT_LAYOUT);
       {$ENDIF}
       constructor Create(i:TD3D12_INPUT_LAYOUT_DESC);
    end;

     { TD3DX12_PIPELINE_STATE_STREAM_IB_STRIP_CUT_VALUE }

     TD3DX12_PIPELINE_STATE_STREAM_IB_STRIP_CUT_VALUE = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; // D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE;
       _Inner:TD3D12_INDEX_BUFFER_STRIP_CUT_VALUE;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_IB_STRIP_CUT_VALUE);
       {$ENDIF}
       constructor Create(i:TD3D12_INDEX_BUFFER_STRIP_CUT_VALUE);
    end;

      { TD3DX12_PIPELINE_STATE_STREAM_PRIMITIVE_TOPOLOGY }

      TD3DX12_PIPELINE_STATE_STREAM_PRIMITIVE_TOPOLOGY = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; // D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE;
       _Inner:TD3D12_PRIMITIVE_TOPOLOGY_TYPE;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_PRIMITIVE_TOPOLOGY);
       {$ENDIF}
       constructor Create(i:TD3D12_PRIMITIVE_TOPOLOGY_TYPE);
    end;

       { TD3DX12_PIPELINE_STATE_STREAM_VS }

    TD3DX12_PIPELINE_STATE_STREAM_VS = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; // D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE;
       _Inner:TD3D12_SHADER_BYTECODE;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_VS);
       {$ENDIF}
       constructor Create(i:TD3D12_SHADER_BYTECODE);
    end;

        { TD3DX12_PIPELINE_STATE_STREAM_GS }

        TD3DX12_PIPELINE_STATE_STREAM_GS = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; // D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE;
       _Inner:TD3D12_SHADER_BYTECODE;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_GS);
       {$ENDIF}
       constructor Create(i:TD3D12_SHADER_BYTECODE);
    end;

    { TD3DX12_PIPELINE_STATE_STREAM_STREAM_OUTPUT }

    TD3DX12_PIPELINE_STATE_STREAM_STREAM_OUTPUT = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; // D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE;
       _Inner:TD3D12_STREAM_OUTPUT_DESC;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_STREAM_OUTPUT);
       {$ENDIF}
       constructor Create(i:TD3D12_STREAM_OUTPUT_DESC);
    end;

        { TD3DX12_PIPELINE_STATE_STREAM_HS }

        TD3DX12_PIPELINE_STATE_STREAM_HS = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; // D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE;
       _Inner:TD3D12_SHADER_BYTECODE;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_HS);
       {$ENDIF}
       constructor Create(i:TD3D12_SHADER_BYTECODE);
    end;

    { TD3DX12_PIPELINE_STATE_STREAM_DS }

    TD3DX12_PIPELINE_STATE_STREAM_DS = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; // D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE;
       _Inner:TD3D12_SHADER_BYTECODE;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_DS);
       {$ENDIF}
       constructor Create(i:TD3D12_SHADER_BYTECODE);
    end;


    { TD3DX12_PIPELINE_STATE_STREAM_PS }

    TD3DX12_PIPELINE_STATE_STREAM_PS = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; // D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE;
       _Inner:TD3D12_SHADER_BYTECODE;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_PS);
       {$ENDIF}
       constructor Create(i:TD3D12_SHADER_BYTECODE);
    end;

    { TD3DX12_PIPELINE_STATE_STREAM_CS }

    TD3DX12_PIPELINE_STATE_STREAM_CS = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; // D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE;
       _Inner:TD3D12_SHADER_BYTECODE;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_CS);
       {$ENDIF}
       constructor Create(i:TD3D12_SHADER_BYTECODE);
    end;

    { TD3DX12_PIPELINE_STATE_STREAM_BLEND_DESC }

    TD3DX12_PIPELINE_STATE_STREAM_BLEND_DESC = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; // D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE;
       _Inner:TD3DX12_BLEND_DESC;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_BLEND_DESC);
       {$ENDIF}
       constructor Create(i:TD3DX12_BLEND_DESC { ToDo ,TD3DX12_DEFAULT});
    end;

    { TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL }

    TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; // D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE;
       _Inner:TD3DX12_DEPTH_STENCIL_DESC;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL);
       {$ENDIF}
       constructor Create(i:TD3DX12_DEPTH_STENCIL_DESC);
    end;

    { TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL1 }

    TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL1 = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; // D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE;
       _Inner:TD3DX12_DEPTH_STENCIL_DESC1;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL1);
       {$ENDIF}
       constructor Create(i:TD3DX12_DEPTH_STENCIL_DESC1);
    end;

    { TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL_FORMAT }

    TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL_FORMAT = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; // D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE;
       _Inner:TDXGI_FORMAT;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL_FORMAT);
       {$ENDIF}
       constructor Create(i:TDXGI_FORMAT);
    end;

    { TD3DX12_PIPELINE_STATE_STREAM_RASTERIZER }

    TD3DX12_PIPELINE_STATE_STREAM_RASTERIZER = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; // D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE;
       _Inner:TD3DX12_RASTERIZER_DESC;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_RASTERIZER);
       {$ENDIF}
       constructor Create(i:TD3DX12_RASTERIZER_DESC);
    end;

     { TD3DX12_PIPELINE_STATE_STREAM_RENDER_TARGET_FORMATS }

     TD3DX12_PIPELINE_STATE_STREAM_RENDER_TARGET_FORMATS = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; // D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE;
       _Inner:TD3D12_RT_FORMAT_ARRAY;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_RENDER_TARGET_FORMATS);
       {$ENDIF}
       constructor Create(i:TD3D12_RT_FORMAT_ARRAY);
    end;

    { TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_DESC }

    TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_DESC = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; // D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE;
       _Inner:TDXGI_SAMPLE_DESC;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_DESC);
       {$ENDIF}
       constructor Create(i:TDXGI_SAMPLE_DESC);
    end;

    { TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_MASK }

    TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_MASK = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; // D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE;
       _Inner:UINT;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_MASK);
       {$ENDIF}
       constructor Create(i:UINT);
    end;


    { TD3DX12_PIPELINE_STATE_STREAM_CACHED_PSO }

    TD3DX12_PIPELINE_STATE_STREAM_CACHED_PSO = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; // D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE;
       _Inner:TD3D12_CACHED_PIPELINE_STATE;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_CACHED_PSO);
       {$ENDIF}
       constructor Create(i:TD3D12_CACHED_PIPELINE_STATE);
    end;


    { TD3DX12_PIPELINE_STATE_STREAM_VIEW_INSTANCING }

    TD3DX12_PIPELINE_STATE_STREAM_VIEW_INSTANCING = record
       _Type:TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; // D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE;
       _Inner:TD3DX12_VIEW_INSTANCING_DESC;
       {$IFDEF FPC}
       class operator Initialize(var A: TD3DX12_PIPELINE_STATE_STREAM_VIEW_INSTANCING);
       {$ENDIF}
       constructor Create(i:TD3DX12_VIEW_INSTANCING_DESC);
    end;




    // TD3DX12_PIPELINE_STATE_STREAM works on RS2+ but does not support new subobject(s) added in RS3+.
    // See TD3DX12_PIPELINE_STATE_STREAM1 for instance.
    TD3DX12_PIPELINE_STATE_STREAM = record
        Flags: TD3DX12_PIPELINE_STATE_STREAM_FLAGS;
        NodeMask: TD3DX12_PIPELINE_STATE_STREAM_NODE_MASK;
        pRootSignature: TD3DX12_PIPELINE_STATE_STREAM_ROOT_SIGNATURE;
        InputLayout: TD3DX12_PIPELINE_STATE_STREAM_INPUT_LAYOUT;
        IBStripCutValue: TD3DX12_PIPELINE_STATE_STREAM_IB_STRIP_CUT_VALUE;
        PrimitiveTopologyType: TD3DX12_PIPELINE_STATE_STREAM_PRIMITIVE_TOPOLOGY;
        VS: TD3DX12_PIPELINE_STATE_STREAM_VS;
        GS: TD3DX12_PIPELINE_STATE_STREAM_GS;
        StreamOutput: TD3DX12_PIPELINE_STATE_STREAM_STREAM_OUTPUT;
        HS: TD3DX12_PIPELINE_STATE_STREAM_HS;
        DS: TD3DX12_PIPELINE_STATE_STREAM_DS;
        PS: TD3DX12_PIPELINE_STATE_STREAM_PS;
        CS: TD3DX12_PIPELINE_STATE_STREAM_CS;
        BlendState: TD3DX12_PIPELINE_STATE_STREAM_BLEND_DESC;
        DepthStencilState: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL1;
        DSVFormat: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL_FORMAT;
        RasterizerState: TD3DX12_PIPELINE_STATE_STREAM_RASTERIZER;
        RTVFormats: TD3DX12_PIPELINE_STATE_STREAM_RENDER_TARGET_FORMATS;
        SampleDesc: TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_DESC;
        SampleMask: TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_MASK;
        CachedPSO: TD3DX12_PIPELINE_STATE_STREAM_CACHED_PSO;
    end;



   TErrorUnknownSubobject = procedure(UnknownTypeValue: UINT);

    ID3DX12PipelineParserCallbacks = object
        procedure FlagsCb (flag: PD3D12_PIPELINE_STATE_FLAGS); virtual; abstract;
        procedure NodeMaskCb(NodeMaskCb: PUINT);  virtual; abstract;
        procedure RootSignatureCb (RootSignatureCb: PID3D12RootSignature);  virtual; abstract;

        procedure InputLayoutCb(const Desc: PD3D12_INPUT_LAYOUT_DESC);  virtual; abstract;
    procedure IBStripCutValueCb(CutValue: PD3D12_INDEX_BUFFER_STRIP_CUT_VALUE);  virtual; abstract;
    procedure PrimitiveTopologyTypeCb(_Type: PD3D12_PRIMITIVE_TOPOLOGY_TYPE);  virtual; abstract;
    procedure VSCb(const ByteCode:PD3D12_SHADER_BYTECODE);  virtual; abstract;
    procedure GSCb(const ByteCode:PD3D12_SHADER_BYTECODE);  virtual; abstract;
    procedure StreamOutputCb(const Desc: PD3D12_STREAM_OUTPUT_DESC);  virtual; abstract;
    procedure HSCb(const ByteCode:PD3D12_SHADER_BYTECODE);  virtual; abstract;
    procedure DSCb(const ByteCode:PD3D12_SHADER_BYTECODE);  virtual; abstract;
    procedure PSCb(const ByteCode:PD3D12_SHADER_BYTECODE);  virtual; abstract;
    procedure CSCb(const ByteCode:PD3D12_SHADER_BYTECODE);  virtual; abstract;
    procedure BlendStateCb(const Desc: PD3D12_BLEND_DESC);  virtual; abstract;
    procedure DepthStencilStateCb(const Desc:PD3D12_DEPTH_STENCIL_DESC);  virtual; abstract;
    procedure DepthStencilState1Cb(const Desc:PD3D12_DEPTH_STENCIL_DESC1);  virtual; abstract;
    procedure DSVFormatCb(Format:PDXGI_FORMAT);  virtual; abstract;
    procedure RasterizerStateCb(const Desc: PD3D12_RASTERIZER_DESC);  virtual; abstract;
    procedure RTVFormatsCb(const PD3D12_RT_FORMAT_ARRAY);  virtual; abstract;
    procedure SampleDescCb(const Desc:PDXGI_SAMPLE_DESC) ;  virtual; abstract;
    procedure SampleMaskCb(Mask: PUINT);  virtual; abstract;
    procedure ViewInstancingCb(const Desc: PD3D12_VIEW_INSTANCING_DESC);  virtual; abstract;
    procedure CachedPSOCb(const State: PD3D12_CACHED_PIPELINE_STATE);  virtual; abstract;

        // Error Callbacks
        procedure ErrorBadInputParameter (ParameterIndex: UINT); virtual; abstract;
        procedure ErrorDuplicateSubobject (DuplicateType: TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE); virtual; abstract;
        procedure ErrorUnknownSubobject (UnknownTypeValue: UINT);  virtual; abstract;
    end;




function UpdateSubresources(pCmdList: ID3D12GraphicsCommandList; pDestinationResource: ID3D12Resource;
    pIntermediate: ID3D12Resource; FirstSubresource: UINT; //   n_range_(0;D3D12_REQ_SUBRESOURCES)
    NumSubresources: UINT; //     _In_range_(0;D3D12_REQ_SUBRESOURCES-FirstSubresource)
    RequiredSize: UINT64; const pLayouts: PD3D12_PLACED_SUBRESOURCE_FOOTPRINT{NumSubresources}; const pNumRows: PUINT;
    const pRowSizesInBytes: PUINT64; const pSrcData: PD3D12_SUBRESOURCE_DATA): UINT64; overload;

function UpdateSubresources(MaxSubresources: UINT; pCmdList: ID3D12GraphicsCommandList; pDestinationResource: ID3D12Resource;
    pIntermediate: ID3D12Resource; IntermediateOffset: UINT64; FirstSubresource: UINT; NumSubresources: UINT;
    pSrcData: PD3D12_SUBRESOURCE_DATA{NumSubresources}): UINT64; overload;

//------------------------------------------------------------------------------------------------
// Heap-allocating UpdateSubresources implementation
function UpdateSubresources(pCmdList: ID3D12GraphicsCommandList; pDestinationResource: ID3D12Resource;
    pIntermediate: ID3D12Resource; IntermediateOffset: UINT64; FirstSubresource: UINT; NumSubresources: UINT;
    pSrcData: PD3D12_SUBRESOURCE_DATA{NumSubresources}): UINT64; overload;

//------------------------------------------------------------------------------------------------
// Returns required size of a buffer to be used for data upload
function GetRequiredIntermediateSize(pDestinationResource: ID3D12Resource; FirstSubresource: UINT; NumSubresources: UINT): UINT64;{ inline;}

function D3D12IsLayoutOpaque(Layout: TD3D12_TEXTURE_LAYOUT): boolean;


//------------------------------------------------------------------------------------------------
// D3D12 exports a new method for serializing root signatures in the Windows 10 Anniversary Update.
// To help enable root signature 1.1 features when they are available and not require maintaining
// two code paths for building root signatures; this helper method reconstructs a 1.0 signature when
// 1.1 is not supported.
function D3DX12SerializeVersionedRootSignature(const pRootSignatureDesc: TD3D12_VERSIONED_ROOT_SIGNATURE_DESC;
    MaxVersion: TD3D_ROOT_SIGNATURE_VERSION; out ppBlob;
    {out} ppErrorBlob: PID3DBlob): HRESULT; {inline}

function D3DX12GetBaseSubobjectType(SubobjectType: TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE): TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE;{inline}

function D3DX12ParsePipelineStream(const Desc: TD3D12_PIPELINE_STATE_STREAM_DESC; pCallbacks: ID3DX12PipelineParserCallbacks): HRESULT; {inline}

implementation



//------------------------------------------------------------------------------------------------
// Row-by-row memcpy

{$POINTERMATH ON}

procedure MemcpySubresource(const pDest: PD3D12_MEMCPY_DEST; const pSrc: TD3D12_SUBRESOURCE_DATA; RowSizeInBytes: SIZE_T;
    NumRows: UINT; NumSlices: UINT);
var
    z, y: UINT;
    pDestSlice: PByte;
    pSrcSlice: PBYTE;
    p1, p2: PBYTE;
begin
    for  z := 0 to NumSlices - 1 do
    begin
        pDestSlice := PByte(pDest^.pData) + pDest.SlicePitch * z;
        pSrcSlice := PByte(pSrc.pData) + pSrc.SlicePitch * z;
        for y := 0 to NumRows - 1 do
        begin
            move((pSrcSlice + pSrc.RowPitch * y)^,(pDestSlice + pDest^.RowPitch * y)^,RowSizeInBytes);
        end;
    end;
end;




//------------------------------------------------------------------------------------------------
// All arrays must be populated (e.g. by calling GetCopyableFootprints)
function UpdateSubresources(pCmdList: ID3D12GraphicsCommandList; pDestinationResource: ID3D12Resource;
    pIntermediate: ID3D12Resource; FirstSubresource: UINT; NumSubresources: UINT; RequiredSize: UINT64;
    const pLayouts: PD3D12_PLACED_SUBRESOURCE_FOOTPRINT{NumSubresources}; const pNumRows: PUINT; const pRowSizesInBytes: PUINT64;
    const pSrcData: PD3D12_SUBRESOURCE_DATA): UINT64; {inline;} {overload;}
var
    pData: PByte;
    hr: HResult;
    i: UINT;
    IntermediateDesc: TD3D12_RESOURCE_DESC;
    DestinationDesc: TD3D12_RESOURCE_DESC;
    DestData: TD3D12_MEMCPY_DEST;
    lLayouts: array of TD3D12_PLACED_SUBRESOURCE_FOOTPRINT absolute pLayouts;

    lNumRows: array of UINT absolute pNumRows;
    lRowSizesInBytes: array of UINT64 absolute pRowSizesInBytes;
    lSrcData: array of TD3D12_SUBRESOURCE_DATA absolute pSrcData;

    SrcBox: TD3D12_BOX;
    Dst: TD3D12_TEXTURE_COPY_LOCATION;
    Src: TD3D12_TEXTURE_COPY_LOCATION;
begin
    Result := 0;
    // Minor validation
    IntermediateDesc := pIntermediate.GetDesc();
    DestinationDesc := pDestinationResource.GetDesc();
    if ((IntermediateDesc.Dimension <> D3D12_RESOURCE_DIMENSION_BUFFER) or (IntermediateDesc.Width < RequiredSize + lLayouts[0].Offset) or
        (RequiredSize > SIZE_T(-1)) or ((DestinationDesc.Dimension = D3D12_RESOURCE_DIMENSION_BUFFER) and
        ((FirstSubresource <> 0) or (NumSubresources <> 1)))) then
        Exit;

    hr := pIntermediate.Map(0, nil, pData);
    if (FAILED(hr)) then
        Exit;

    for i := 0 to NumSubresources - 1 do
    begin
        if (lRowSizesInBytes[i] > SIZE_T(-1)) then
            Exit;
        DestData.pData := pData + lLayouts[i].Offset;
        DestData.RowPitch := lLayouts[i].Footprint.RowPitch;
        DestData.SlicePitch := lLayouts[i].Footprint.RowPitch * lNumRows[i];
        MemcpySubresource(@DestData, lSrcData[i], lRowSizesInBytes[i], lNumRows[i], lLayouts[i].Footprint.Depth);
    end;
    pIntermediate.Unmap(0, nil);

    if (DestinationDesc.Dimension = D3D12_RESOURCE_DIMENSION_BUFFER) then
    begin
        SrcBox := TD3D12_BOX.Create(UINT(lLayouts[0].Offset), UINT(lLayouts[0].Offset + lLayouts[0].Footprint.Width));
        pCmdList.CopyBufferRegion(
            pDestinationResource, 0, pIntermediate, lLayouts[0].Offset, lLayouts[0].Footprint.Width);
    end
    else
    begin
        for  i := 0 to NumSubresources - 1 do
        begin
            Dst := TD3D12_TEXTURE_COPY_LOCATION.Create(pDestinationResource, i + FirstSubresource);
            Src := TD3D12_TEXTURE_COPY_LOCATION.Create(pIntermediate, lLayouts[i]);
            pCmdList.CopyTextureRegion(@Dst, 0, 0, 0, @Src, nil);
        end;
    end;
    Result := RequiredSize;
end;


//------------------------------------------------------------------------------------------------
// Stack-allocating UpdateSubresources implementation
//template <UINT >
function UpdateSubresources(MaxSubresources: UINT; pCmdList: ID3D12GraphicsCommandList; pDestinationResource: ID3D12Resource;
    pIntermediate: ID3D12Resource; IntermediateOffset: UINT64; FirstSubresource: UINT; NumSubresources: UINT;
    pSrcData: PD3D12_SUBRESOURCE_DATA{NumSubresources}): UINT64;
var
    RequiredSize: UINT64;
    Layouts: array {[0..MaxSubresources - 1]} of TD3D12_PLACED_SUBRESOURCE_FOOTPRINT;
    NumRows: array {[0..MaxSubresources - 1]} of UINT;
    RowSizesInBytes: array { [0..MaxSubresources - 1]} of UINT64;
    Desc: TD3D12_RESOURCE_DESC;
    pDevice: ID3D12Device;
begin
    RequiredSize := 0;
    SetLength(Layouts, MaxSubresources);
    SetLength(NumRows, MaxSubresources);
    SetLength(RowSizesInBytes, MaxSubresources);

    Desc := pDestinationResource.GetDesc();

    pDestinationResource.GetDevice(IID_ID3D12Device, pDevice);
    pDevice.GetCopyableFootprints(Desc, FirstSubresource, NumSubresources, IntermediateOffset, @Layouts[0], @NumRows[0],
        @RowSizesInBytes[0], RequiredSize);
    pDevice := nil;

    Result := UpdateSubresources(pCmdList, pDestinationResource, pIntermediate, FirstSubresource, NumSubresources,
        RequiredSize, @Layouts[0], @NumRows[0], @RowSizesInBytes[0], pSrcData);

    SetLength(Layouts, 0);
    SetLength(NumRows, 0);
    SetLength(RowSizesInBytes, 0);
end;

//------------------------------------------------------------------------------------------------
// Heap-allocating UpdateSubresources implementation
function UpdateSubresources(pCmdList: ID3D12GraphicsCommandList; pDestinationResource: ID3D12Resource;
    pIntermediate: ID3D12Resource; IntermediateOffset: UINT64; FirstSubresource: UINT; NumSubresources: UINT;
    pSrcData: PD3D12_SUBRESOURCE_DATA{NumSubresources}): UINT64; overload;
var
    RequiredSize: UINT64;
    MemToAlloc: UINT64;

    Desc: TD3D12_RESOURCE_DESC;
    pDevice: ID3D12Device;
    pMem: pointer;
    pLayouts: PD3D12_PLACED_SUBRESOURCE_FOOTPRINT;
    pRowSizesInBytes: PUINT64;
    pNumRows: PUINT;
begin
    Result := 0;
    RequiredSize:=0;
    MemToAlloc := (sizeof(TD3D12_PLACED_SUBRESOURCE_FOOTPRINT) + sizeof(UINT) + sizeof(UINT64)) * NumSubresources;
    if (MemToAlloc > SIZE_MAX) then
        Exit;

    pMem := HeapAlloc(GetProcessHeap(), 0, MemToAlloc);
    if (pMem = nil) then
        Exit;

    pLayouts := pMem;
    pRowSizesInBytes := PUINT64(pLayouts) + SizeOf(TD3D12_PLACED_SUBRESOURCE_FOOTPRINT) * NumSubresources;
    pNumRows := PUINT(pRowSizesInBytes) + Sizeof(UINT64) * NumSubresources;

    Desc := pDestinationResource.GetDesc();

    pDestinationResource.GetDevice(IID_ID3D12Device, pDevice);
    pDevice.GetCopyableFootprints(@Desc, FirstSubresource, NumSubresources, IntermediateOffset, pLayouts, pNumRows, pRowSizesInBytes, RequiredSize);
    pDevice := nil;

    Result := UpdateSubresources(pCmdList, pDestinationResource, pIntermediate, FirstSubresource, NumSubresources,
        RequiredSize, pLayouts, pNumRows, pRowSizesInBytes, pSrcData);
    HeapFree(GetProcessHeap(), 0, pMem);
end;



function GetRequiredIntermediateSize(pDestinationResource: ID3D12Resource; FirstSubresource: UINT; NumSubresources: UINT): UINT64;
var
    Desc: TD3D12_RESOURCE_DESC;
    RequiredSize: UINT64;
    pDevice: ID3D12Device;
begin
    RequiredSize := 0;
    Desc := pDestinationResource.GetDesc();
    pDestinationResource.GetDevice(IID_ID3D12Device, pDevice);
    pDevice.GetCopyableFootprints(Desc, FirstSubresource, NumSubresources, 0, nil, nil, nil, RequiredSize);
    pDevice := nil;
    Result := RequiredSize;
end;



function D3D12IsLayoutOpaque(Layout: TD3D12_TEXTURE_LAYOUT): boolean;
begin
    Result := (Layout = D3D12_TEXTURE_LAYOUT_UNKNOWN) or (Layout = D3D12_TEXTURE_LAYOUT_64KB_UNDEFINED_SWIZZLE);
end;



function D3DX12SerializeVersionedRootSignature(const pRootSignatureDesc: TD3D12_VERSIONED_ROOT_SIGNATURE_DESC;
    MaxVersion: TD3D_ROOT_SIGNATURE_VERSION; out ppBlob;
    {out} ppErrorBlob: PID3DBlob): HRESULT; {inline}

var
    hr: HResult;
    desc_1_1: TD3D12_ROOT_SIGNATURE_DESC1;
    ParametersSize: SIZE_T;
    pParameters: pointer;
    pParameters_1_0: TD3D12_ROOT_PARAMETER_ARRAY;
    n: UINT;
    table_1_1: TD3D12_ROOT_DESCRIPTOR_TABLE1;
    DescriptorRangesSize: SIZE_T;
    pDescriptorRanges: pointer;
    pDescriptorRanges_1_0: TD3D12_DESCRIPTOR_RANGE_ARRAY;
    x: uint;
    table_1_0: TD3D12_ROOT_DESCRIPTOR_TABLE;
    desc_1_0: TD3DX12_ROOT_SIGNATURE_DESC;
begin
    Result := E_INVALIDARG;

    if (ppErrorBlob <> nil) then
        ppErrorBlob := nil;


    case (MaxVersion) of
        D3D_ROOT_SIGNATURE_VERSION_1_0:
            case (pRootSignatureDesc.Version) of

                D3D_ROOT_SIGNATURE_VERSION_1_0:
                begin
                    Result := D3D12SerializeRootSignature(pRootSignatureDesc.Desc_1_0, D3D_ROOT_SIGNATURE_VERSION_1,
                        ID3D10Blob(ppBlob), ppErrorBlob);
                end;

                D3D_ROOT_SIGNATURE_VERSION_1_1:
                begin
                    hr := S_OK;
                    desc_1_1 := pRootSignatureDesc.Desc_1_1;

                    ParametersSize := sizeof(TD3D12_ROOT_PARAMETER) * desc_1_1.NumParameters;
                    if (ParametersSize > 0) then
                        pParameters := HeapAlloc(GetProcessHeap(), 0, ParametersSize)
                    else
                        pParameters := nil;
                    if (ParametersSize > 0) and (pParameters = nil) then
                    begin
                        hr := E_OUTOFMEMORY;
                    end;
                    pParameters_1_0 := TD3D12_ROOT_PARAMETER_ARRAY(pParameters);

                    if (SUCCEEDED(hr)) then
                    begin
                        for n := 0 to desc_1_1.NumParameters - 1 do
                        begin
                            //?? __analysis_assume(ParametersSize = sizeof(TD3D12_ROOT_PARAMETER) * desc_1_1.NumParameters);
                            pParameters_1_0[n].ParameterType := desc_1_1.GetParameter(n).ParameterType;
                            pParameters_1_0[n].ShaderVisibility := desc_1_1.GetParameter(n).ShaderVisibility;

                            case (desc_1_1.GetParameter(n).ParameterType) of

                                D3D12_ROOT_PARAMETER_TYPE_32BIT_CONSTANTS:
                                begin
                                    pParameters_1_0[n].Constants.Num32BitValues := desc_1_1.GetParameter(n).Constants.Num32BitValues;
                                    pParameters_1_0[n].Constants.RegisterSpace := desc_1_1.GetParameter(n).Constants.RegisterSpace;
                                    pParameters_1_0[n].Constants.ShaderRegister := desc_1_1.GetParameter(n).Constants.ShaderRegister;
                                end;

                                D3D12_ROOT_PARAMETER_TYPE_CBV,
                                D3D12_ROOT_PARAMETER_TYPE_SRV,
                                D3D12_ROOT_PARAMETER_TYPE_UAV:
                                begin
                                    pParameters_1_0[n].Descriptor.RegisterSpace := desc_1_1.GetParameter(n).Descriptor.RegisterSpace;
                                    pParameters_1_0[n].Descriptor.ShaderRegister := desc_1_1.GetParameter(n).Descriptor.ShaderRegister;
                                end;

                                D3D12_ROOT_PARAMETER_TYPE_DESCRIPTOR_TABLE:
                                begin

                                    table_1_1 := desc_1_1.GetParameter(n).DescriptorTable;

                                    DescriptorRangesSize := sizeof(TD3D12_DESCRIPTOR_RANGE) * table_1_1.NumDescriptorRanges;
                                    if ((DescriptorRangesSize > 0) and SUCCEEDED(hr)) then
                                        pDescriptorRanges := HeapAlloc(GetProcessHeap(), 0, DescriptorRangesSize)
                                    else
                                        pDescriptorRanges := nil;
                                    if ((DescriptorRangesSize > 0) and (pDescriptorRanges = nil)) then
                                    begin
                                        hr := E_OUTOFMEMORY;
                                    end;
                                    pDescriptorRanges_1_0 := TD3D12_DESCRIPTOR_RANGE_ARRAY(pDescriptorRanges);

                                    if (SUCCEEDED(hr)) then
                                    begin
                                        for x := 0 to table_1_1.NumDescriptorRanges - 1 do
                                        begin
                                            //?? __analysis_assume(DescriptorRangesSize = sizeof(TD3D12_DESCRIPTOR_RANGE) * table_1_1.NumDescriptorRanges);
                                            pDescriptorRanges_1_0[x].BaseShaderRegister := table_1_1.GetDescriptorRange(x).BaseShaderRegister;
                                            pDescriptorRanges_1_0[x].NumDescriptors := table_1_1.GetDescriptorRange(x).NumDescriptors;
                                            pDescriptorRanges_1_0[x].OffsetInDescriptorsFromTableStart :=
                                                table_1_1.GetDescriptorRange(x).OffsetInDescriptorsFromTableStart;
                                            pDescriptorRanges_1_0[x].RangeType := table_1_1.GetDescriptorRange(x).RangeType;
                                            pDescriptorRanges_1_0[x].RegisterSpace := table_1_1.GetDescriptorRange(x).RegisterSpace;
                                        end;
                                    end;

                                    table_1_0 := pParameters_1_0[n].DescriptorTable;
                                    table_1_0.NumDescriptorRanges := table_1_1.NumDescriptorRanges;
                                    table_1_0.pDescriptorRanges := @pDescriptorRanges_1_0[0];
                                end;
                            end;
                        end;

                        if (SUCCEEDED(hr)) then
                        begin
                            desc_1_0.Create(desc_1_1.NumParameters, @pParameters_1_0[0], desc_1_1.NumStaticSamplers,
                                desc_1_1.pStaticSamplers, desc_1_1.Flags);
                            hr := D3D12SerializeRootSignature(desc_1_0, D3D_ROOT_SIGNATURE_VERSION_1, ID3DBlob(ppBlob), ppErrorBlob);
                        end;

                        if (pParameters <> nil) then
                        begin
                            for  n := 0 to desc_1_1.NumParameters - 1 do
                            begin
                                if (desc_1_1.GetParameter(n).ParameterType = D3D12_ROOT_PARAMETER_TYPE_DESCRIPTOR_TABLE) then
                                begin
                                    HeapFree(GetProcessHeap(), 0, pParameters_1_0[n].DescriptorTable.pDescriptorRanges);
                                end;
                            end;
                            HeapFree(GetProcessHeap(), 0, pParameters);
                        end;
                        Result := hr;
                    end;
                end;
            end;
        D3D_ROOT_SIGNATURE_VERSION_1_1:
        begin
            Result := D3D12SerializeVersionedRootSignature(pRootSignatureDesc, PID3DBlob(ppBlob), ppErrorBlob);
        end;
    end;
end;



function D3DX12GetBaseSubobjectType(SubobjectType: TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE): TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE;
begin
    case (SubobjectType) of
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_DEPTH_STENCIL1:
            Result := D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_DEPTH_STENCIL;
        else
            Result := SubobjectType;
    end;
end;



function D3DX12ParsePipelineStream(const Desc: TD3D12_PIPELINE_STATE_STREAM_DESC; pCallbacks: ID3DX12PipelineParserCallbacks): HRESULT;
var
    CurOffset: SIZE_T;
    SizeOfSubobject: SIZE_T; // ??? TODO
    pStream: PBYTE;
    SubobjectSeen: array [0..ord(D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_MAX_VALID) - 1] of longbool;
    SubobjectType: TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE;
begin
    if ((Desc.SizeInBytes = 0) or (Desc.pPipelineStateSubobjectStream = nil)) then
    begin
        pCallbacks.ErrorBadInputParameter(1); // first parameter issue
        Result := E_INVALIDARG;
        Exit;
    end;

    if (@pCallbacks = nil) then
    begin
        pCallbacks.ErrorBadInputParameter(2); // second parameter issue
        Result := E_INVALIDARG;
        Exit;
    end;


    CurOffset := 0;
    while CurOffset < Desc.SizeInBytes do
        //   for  CurOffset := 0 to   ; SizeOfSubobject := 0; CurOffset < Desc.SizeInBytes; CurOffset += SizeOfSubobject)
    begin
        SizeOfSubobject := 0;

        pStream := PBYTE(Desc.pPipelineStateSubobjectStream) + CurOffset;
        //  auto SubobjectType := *reinterpret_cast<TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE*>(pStream);

        if (SubobjectType >= D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_MAX_VALID) then
        begin
            pCallbacks.ErrorUnknownSubobject(Ord(SubobjectType));
            Result := E_INVALIDARG;
            Exit;
        end;
        if (SubobjectSeen[Ord(D3DX12GetBaseSubobjectType(SubobjectType))]) then
        begin
            pCallbacks.ErrorDuplicateSubobject(SubobjectType);
            Result := E_INVALIDARG; // disallow subobject duplicates in a stream
            exit;
        end;
        SubobjectSeen[Ord(SubobjectType)] := True;
        case (SubobjectType) of

            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE:
            begin
                pCallbacks.RootSignatureCb(PID3D12RootSignature(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_ROOT_SIGNATURE);
            end;
         D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_VS:
         begin
           pCallbacks.VSCb(PD3D12_SHADER_BYTECODE(pStream));
           SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_VS);
           end;
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_PS:
        begin
           pCallbacks.PSCb(PD3D12_SHADER_BYTECODE(pStream));
           SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_PS);
           end;
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_DS:
        begin
           pCallbacks.DSCb( PD3D12_SHADER_BYTECODE(pStream));
           SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_DS);
           end;
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_HS:
        begin
           pCallbacks.HSCb( PD3D12_SHADER_BYTECODE(pStream));
           SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_HS);
           end;
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_GS:
        begin
           pCallbacks.GSCb (PD3D12_SHADER_BYTECODE(pStream));
           SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_GS);
           end;
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_CS:
        begin
           pCallbacks.CSCb( PD3D12_SHADER_BYTECODE(pStream));
           SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_CS);
           end;
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_STREAM_OUTPUT:
        begin
           pCallbacks.StreamOutputCb( PD3D12_STREAM_OUTPUT_DESC(pStream));
           SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_STREAM_OUTPUT);
           end;
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_BLEND:
        begin
           pCallbacks.BlendStateCb( PD3D12_BLEND_DESC(pStream));
           SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_BLEND_DESC);
           end;
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_SAMPLE_MASK:
        begin
           pCallbacks.SampleMaskCb( PUINT(pStream));
           SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_MASK);
           end;
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_RASTERIZER:
        begin
           pCallbacks.RasterizerStateCb( PD3D12_RASTERIZER_DESC(pStream));
           SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_RASTERIZER);
           end;
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_DEPTH_STENCIL:
        begin
           pCallbacks.DepthStencilStateCb( PD3D12_DEPTH_STENCIL_DESC(pStream));
           SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL);
           end;
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_DEPTH_STENCIL1:
        begin
           pCallbacks.DepthStencilState1Cb( PD3D12_DEPTH_STENCIL_DESC1(pStream));
           SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL1);
           end;
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_INPUT_LAYOUT:
        begin
           pCallbacks.InputLayoutCb( PD3D12_INPUT_LAYOUT_DESC(pStream));
           SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_INPUT_LAYOUT);
           end;
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_IB_STRIP_CUT_VALUE:
        begin
           pCallbacks.IBStripCutValueCb( PD3D12_INDEX_BUFFER_STRIP_CUT_VALUE(pStream));
           SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_IB_STRIP_CUT_VALUE);
           end;
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_PRIMITIVE_TOPOLOGY:
        begin
           pCallbacks.PrimitiveTopologyTypeCb( PD3D12_PRIMITIVE_TOPOLOGY_TYPE(pStream));
           SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_PRIMITIVE_TOPOLOGY);
           end;
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_RENDER_TARGET_FORMATS:
        begin
           pCallbacks.RTVFormatsCb( PD3D12_RT_FORMAT_ARRAY(pStream));
           SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_RENDER_TARGET_FORMATS);
           end;
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_DEPTH_STENCIL_FORMAT:
        begin
           pCallbacks.DSVFormatCb( PDXGI_FORMAT(pStream));
           SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL_FORMAT);
           end;
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_SAMPLE_DESC:
        begin
           pCallbacks.SampleDescCb( PDXGI_SAMPLE_DESC(pStream));
           SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_DESC);
           end;
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_NODE_MASK:
        begin
           pCallbacks.NodeMaskCb( PUINT(pStream));
           SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_NODE_MASK);
           end;
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_CACHED_PSO:
        begin
           pCallbacks.CachedPSOCb( PD3D12_CACHED_PIPELINE_STATE(pStream));
           SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_CACHED_PSO);
           end;
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_FLAGS:
        begin
           pCallbacks.FlagsCb( PD3D12_PIPELINE_STATE_FLAGS(pStream));
           SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_FLAGS);
           end;
        (*
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_VIEW_INSTANCING:
        begin
           pCallbacks.ViewInstancingCb( PD3D12_VIEW_INSTANCING_DESC(pStream));
           SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM1.ViewInstancingDesc);
           end;
           *)

            else
            begin
                pCallbacks.ErrorUnknownSubobject(ord(SubobjectType));
                Result := E_INVALIDARG;
                Exit;
            end;
        end;
        CurOffset := CurOffset + SizeOfSubobject;
    end;

    Result := S_OK;

end;

{ TD3DX12_PIPELINE_STATE_STREAM_CACHED_PSO }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_CACHED_PSO.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_CACHED_PSO);
begin
    a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_CACHED_PSO;
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_CACHED_PSO.Create(
  i: TD3D12_CACHED_PIPELINE_STATE);
begin
     _Inner:=i;
end;

{ TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_MASK }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_MASK.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_MASK);
begin
    a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_SAMPLE_MASK;   // ToDo DefaultSampleMask;
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_MASK.Create(i: UINT);
begin
    _Inner:=i;
end;

{ TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_DESC }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_DESC.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_DESC);
begin
    a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_SAMPLE_DESC;   // ToDo DefaultSampleDesc;
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_DESC.Create(
  i: TDXGI_SAMPLE_DESC);
begin
    _Inner:=i;
end;

{ TD3DX12_PIPELINE_STATE_STREAM_RENDER_TARGET_FORMATS }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_RENDER_TARGET_FORMATS.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_RENDER_TARGET_FORMATS);
begin
    a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_RENDER_TARGET_FORMATS;
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_RENDER_TARGET_FORMATS.Create(
  i: TD3D12_RT_FORMAT_ARRAY);
begin
    _Inner:=i;
end;

{ TD3DX12_PIPELINE_STATE_STREAM_RASTERIZER }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_RASTERIZER.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_RASTERIZER);
begin
    a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_RASTERIZER;  // TD3DX12_DEFAULT
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_RASTERIZER.Create(
  i: TD3DX12_RASTERIZER_DESC);
begin
    _Inner:=i;
end;

{ TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL_FORMAT }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL_FORMAT.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL_FORMAT);
begin
    a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_DEPTH_STENCIL_FORMAT;
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL_FORMAT.Create(
  i: TDXGI_FORMAT);
begin
     _Inner:=i;
end;

{ TD3DX12_PIPELINE_STATE_STREAM_VIEW_INSTANCING }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_VIEW_INSTANCING.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_VIEW_INSTANCING);
begin
     a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_VIEW_INSTANCING; // ToDo TD3DX12_DEFAULT
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_VIEW_INSTANCING.Create(
  i: TD3DX12_VIEW_INSTANCING_DESC);
begin
    _Inner:=i;
end;

{ TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL1 }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL1.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL1);
begin
    a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_DEPTH_STENCIL1; // ToDo TD3DX12_DEFAULT
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL1.Create(
  i: TD3DX12_DEPTH_STENCIL_DESC1);
begin
    _Inner:=i;
end;

{ TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL);
begin
    a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_DEPTH_STENCIL;  // ToDo TD3DX12_DEFAULT
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL.Create(
  i: TD3DX12_DEPTH_STENCIL_DESC);
begin
    _Inner:=i;
end;

{ TD3DX12_PIPELINE_STATE_STREAM_BLEND_DESC }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_BLEND_DESC.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_BLEND_DESC);
begin
    a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_BLEND;
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_BLEND_DESC.Create(
  i: TD3DX12_BLEND_DESC);
begin
    _Inner:=i;
end;

{ TD3DX12_PIPELINE_STATE_STREAM_CS }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_CS.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_CS);
begin
    a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_CS;
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_CS.Create(i: TD3D12_SHADER_BYTECODE);
begin
    _Inner:=i;
end;

{ TD3DX12_PIPELINE_STATE_STREAM_PS }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_PS.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_PS);
begin
    a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_PS;
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_PS.Create(i: TD3D12_SHADER_BYTECODE);
begin
    _Inner:=i;
end;

{ TD3DX12_PIPELINE_STATE_STREAM_DS }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_DS.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_DS);
begin
    a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_DS;
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_DS.Create(i: TD3D12_SHADER_BYTECODE);
begin
    _Inner:=i;
end;

{ TD3DX12_PIPELINE_STATE_STREAM_HS }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_HS.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_HS);
begin
    a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_HS;
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_HS.Create(i: TD3D12_SHADER_BYTECODE);
begin
    _Inner:=i;
end;

{ TD3DX12_PIPELINE_STATE_STREAM_STREAM_OUTPUT }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_STREAM_OUTPUT.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_STREAM_OUTPUT);
begin
    a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_STREAM_OUTPUT;
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_STREAM_OUTPUT.Create(
  i: TD3D12_STREAM_OUTPUT_DESC);
begin
    _Inner:=i;
end;

{ TD3DX12_PIPELINE_STATE_STREAM_GS }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_GS.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_GS);
begin
    a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_GS;
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_GS.Create(i: TD3D12_SHADER_BYTECODE);
begin
    _Inner:=i;
end;

{ TD3DX12_PIPELINE_STATE_STREAM_VS }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_VS.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_VS);
begin
    a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_VS;
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_VS.Create(i: TD3D12_SHADER_BYTECODE);
begin
    _Inner:=i;
end;

{ TD3DX12_PIPELINE_STATE_STREAM_PRIMITIVE_TOPOLOGY }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_PRIMITIVE_TOPOLOGY.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_PRIMITIVE_TOPOLOGY);
begin
    a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_PRIMITIVE_TOPOLOGY;
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_PRIMITIVE_TOPOLOGY.Create(
  i: TD3D12_PRIMITIVE_TOPOLOGY_TYPE);
begin
    _Inner:=i;
end;

{ TD3DX12_PIPELINE_STATE_STREAM_IB_STRIP_CUT_VALUE }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_IB_STRIP_CUT_VALUE.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_IB_STRIP_CUT_VALUE);
begin
    a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_IB_STRIP_CUT_VALUE;
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_IB_STRIP_CUT_VALUE.Create(
  i: TD3D12_INDEX_BUFFER_STRIP_CUT_VALUE);
begin
    _Inner:=i;
end;

{ TD3DX12_PIPELINE_STATE_STREAM_INPUT_LAYOUT }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_INPUT_LAYOUT.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_INPUT_LAYOUT);
begin
    a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_INPUT_LAYOUT;
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_INPUT_LAYOUT.Create(
  i: TD3D12_INPUT_LAYOUT_DESC);
begin
    _Inner:=i;
end;

{ TD3DX12_PIPELINE_STATE_STREAM_ROOT_SIGNATURE }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_ROOT_SIGNATURE.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_ROOT_SIGNATURE);
begin
    a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE;
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_ROOT_SIGNATURE.Create(
  i: ID3D12RootSignature);
begin
    _Inner:=i;
end;

{ TD3DX12_PIPELINE_STATE_STREAM_NODE_MASK }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_NODE_MASK.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_NODE_MASK);
begin
    a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_NODE_MASK;
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_NODE_MASK.Create(i: UINT);
begin
    _Inner:=i;
end;

{ TD3DX12_PIPELINE_STATE_STREAM_FLAGS }

{$IFDEF FPC}
class operator TD3DX12_PIPELINE_STATE_STREAM_FLAGS.Initialize(
  var A: TD3DX12_PIPELINE_STATE_STREAM_FLAGS);
begin
   a._Type:=D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_FLAGS;
end;
{$ENDIF}

constructor TD3DX12_PIPELINE_STATE_STREAM_FLAGS.Create(
  i: TD3D12_PIPELINE_STATE_FLAGS);
begin
    _Inner:=i;
end;




{ TD3DX12_CPU_DESCRIPTOR_HANDLE }

{$IFDEF FPC}
procedure TD3DX12_CPU_DESCRIPTOR_HANDLE.Offset(offsetScaledByIncrementSize: integer);
begin
    Self.ptr := Self.ptr + offsetScaledByIncrementSize;
end;



procedure TD3DX12_CPU_DESCRIPTOR_HANDLE.Offset(offsetInDescriptors: integer; descriptorIncrementSize: UINT);
begin
    Self.ptr := Self.ptr + offsetInDescriptors * descriptorIncrementSize;
end;
{$ENDIF}


end.





