unit DX12.D3DX12_Pipeline_State_Stream;

// d3dx12_pipeline_state_stream.h

{$IFDEF FPC}
{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.DXGICommon,
    DX12.DXGIFormat,
    DX12.D3D12;

    //------------------------------------------------------------------------------------------------
    // Pipeline State Stream Helpers
    //------------------------------------------------------------------------------------------------

    {$I DX12.DX12SDKVersion.inc}


    {$DEFINE AssignOperator}
type
    //------------------------------------------------------------------------------------------------
    // Stream Subobjects, i.e. elements of a stream

    { TDefaultSampleMask }

    TDefaultSampleMask = record
        class operator Explicit(o: TDefaultSampleMask): UINT;
    end;

    { TDefaultSampleDesc }

    TDefaultSampleDesc = record
        class operator Explicit(o: TDefaultSampleDesc): TDXGI_SAMPLE_DESC;
    end;

    { TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT }

    generic TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<T> = record
        pssType: TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE;
        pssInner: T;
        {$IFNDEF FPC}
        class operator Assign(var Dest: TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT; const Scr: T);
        class operator Assign(var Dest: T; const Scr: TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT);
        {$ELSE}
        {$IFDEF AssignOperator}
        class operator := (x: TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT) y: T;
        class operator := (x: T) y: TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT;
        {$ENDIF}
    {$ENDIF}
        property InnerStructType: T read pssInner write pssInner;
    end;


    TD3DX12_PIPELINE_STATE_STREAM_FLAGS = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_PIPELINE_STATE_FLAGS>;

    CD3DX12_PIPELINE_STATE_STREAM_FLAGS = record helper for TD3DX12_PIPELINE_STATE_STREAM_FLAGS

    end;

    TD3DX12_PIPELINE_STATE_STREAM_NODE_MASK = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<UINT>;
    TD3DX12_PIPELINE_STATE_STREAM_ROOT_SIGNATURE = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<PID3D12RootSignature>;
    TD3DX12_PIPELINE_STATE_STREAM_INPUT_LAYOUT = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_INPUT_LAYOUT_DESC>;
    TD3DX12_PIPELINE_STATE_STREAM_IB_STRIP_CUT_VALUE = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_INDEX_BUFFER_STRIP_CUT_VALUE>;
    TD3DX12_PIPELINE_STATE_STREAM_PRIMITIVE_TOPOLOGY = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_PRIMITIVE_TOPOLOGY_TYPE>;
    TD3DX12_PIPELINE_STATE_STREAM_VS = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_SHADER_BYTECODE>;
    TD3DX12_PIPELINE_STATE_STREAM_GS = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_SHADER_BYTECODE>;
    TD3DX12_PIPELINE_STATE_STREAM_STREAM_OUTPUT = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_STREAM_OUTPUT_DESC>;
    TD3DX12_PIPELINE_STATE_STREAM_HS = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_SHADER_BYTECODE>;
    TD3DX12_PIPELINE_STATE_STREAM_DS = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_SHADER_BYTECODE>;
    TD3DX12_PIPELINE_STATE_STREAM_PS = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_SHADER_BYTECODE>;
    TD3DX12_PIPELINE_STATE_STREAM_AS = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_SHADER_BYTECODE>;
    TD3DX12_PIPELINE_STATE_STREAM_MS = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_SHADER_BYTECODE>;
    TD3DX12_PIPELINE_STATE_STREAM_CS = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_SHADER_BYTECODE>;
    TD3DX12_PIPELINE_STATE_STREAM_BLEND_DESC = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_BLEND_DESC>;
    TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_DEPTH_STENCIL_DESC>;
    TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL1 = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_DEPTH_STENCIL_DESC1>;
    {$IFDEF D3D12_SDK_VERSION_606}
    TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL2 = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_DEPTH_STENCIL_DESC2>;
    {$ENDIF}
    TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL_FORMAT = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TDXGI_FORMAT>;
    TD3DX12_PIPELINE_STATE_STREAM_RASTERIZER = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_RASTERIZER_DESC>;
    {$IFDEF D3D12_SDK_VERSION_608}
    TD3DX12_PIPELINE_STATE_STREAM_RASTERIZER1 = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_RASTERIZER_DESC1>;
    {$ENDIF}
    {$IFDEF D3D12_SDK_VERSION_610}
    TD3DX12_PIPELINE_STATE_STREAM_RASTERIZER2 = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_RASTERIZER_DESC2>;
    {$ENDIF}
    TD3DX12_PIPELINE_STATE_STREAM_RENDER_TARGET_FORMATS = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_RT_FORMAT_ARRAY>;
    TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_DESC = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TDXGI_SAMPLE_DESC>;
    TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_MASK = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<UINT>;
    TD3DX12_PIPELINE_STATE_STREAM_CACHED_PSO = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_CACHED_PIPELINE_STATE>;
    TD3DX12_PIPELINE_STATE_STREAM_VIEW_INSTANCING = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_VIEW_INSTANCING_DESC>;
    {$IFDEF D3D12_SDK_VERSION_618}
    TD3DX12_PIPELINE_STATE_STREAM_SERIALIZED_ROOT_SIGNATURE = specialize TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TD3D12_SERIALIZED_ROOT_SIGNATURE_DESC>;
    {$ENDIF}


    //------------------------------------------------------------------------------------------------
    // Stream Parser Helpers


    {$interfaces corba}

    ID3DX12PipelineParserCallbacks = interface
        // Subobject Callbacks
        procedure FlagsCb(Flags: TD3D12_PIPELINE_STATE_FLAGS);
        procedure NodeMaskCb(NodeMask: UINT);
        procedure RootSignatureCb(pRootSignature: PID3D12RootSignature);
        procedure InputLayoutCb(InputLayout: PD3D12_INPUT_LAYOUT_DESC);
        procedure IBStripCutValueCb(IBStripCutValue: TD3D12_INDEX_BUFFER_STRIP_CUT_VALUE);
        procedure PrimitiveTopologyTypeCb(PrimitiveTopologyType: TD3D12_PRIMITIVE_TOPOLOGY_TYPE);
        procedure VSCb(VS_Code: PD3D12_SHADER_BYTECODE);
        procedure GSCb(GS_Code: PD3D12_SHADER_BYTECODE);
        procedure StreamOutputCb(StreamOutput: PD3D12_STREAM_OUTPUT_DESC);
        procedure HSCb(HS_Code: PD3D12_SHADER_BYTECODE);
        procedure DSCb(DS_Code: PD3D12_SHADER_BYTECODE);
        procedure PSCb(PS_Code: PD3D12_SHADER_BYTECODE);
        procedure CSCb(CS_Code: PD3D12_SHADER_BYTECODE);
        procedure ASCb(AS_Code: PD3D12_SHADER_BYTECODE);
        procedure MSCb(MS_Code: PD3D12_SHADER_BYTECODE);
        procedure BlendStateCb(BlendState: PD3D12_BLEND_DESC);
        procedure DepthStencilStateCb(DepthStencilState: PD3D12_DEPTH_STENCIL_DESC);
        procedure DepthStencilState1Cb(DepthStencilState: PD3D12_DEPTH_STENCIL_DESC1);
        {$IFDEF D3D12_SDK_VERSION_606}
        procedure DepthStencilState2Cb(DepthStencilState: PD3D12_DEPTH_STENCIL_DESC2);
    {$ENDIF}
        procedure DSVFormatCb(DSVFormat: TDXGI_FORMAT);
        procedure RasterizerStateCb(RasterizerState: PD3D12_RASTERIZER_DESC);
        {$IFDEF D3D12_SDK_VERSION_608}
        procedure RasterizerState1Cb(RasterizerState: PD3D12_RASTERIZER_DESC1);
    {$ENDIF}
        {$IFDEF D3D12_SDK_VERSION_610}
        procedure RasterizerState2Cb(RasterizerState: PD3D12_RASTERIZER_DESC2);
    {$ENDIF}
        procedure RTVFormatsCb(RTVFormats: PD3D12_RT_FORMAT_ARRAY);
        procedure SampleDescCb(SampleDesc: PDXGI_SAMPLE_DESC);
        procedure SampleMaskCb(SampleMask: UINT);
        procedure ViewInstancingCb(ViewInstancingDesc: PD3D12_VIEW_INSTANCING_DESC);
        procedure CachedPSOCb(CachedPSO: PD3D12_CACHED_PIPELINE_STATE);
        {$IFDEF D3D12_SDK_VERSION_618}
        procedure SerializedRootSignatureCb(SerializedRootSignature: PD3D12_SERIALIZED_ROOT_SIGNATURE_DESC);
    {$ENDIF}

        // Error Callbacks
        procedure ErrorBadInputParameter(Nameless1: UINT (*ParameterIndex*));
        procedure ErrorDuplicateSubobject(Nameless1: TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE (*DuplicateType*));
        procedure ErrorUnknownSubobject(Nameless1: UINT (*UnknownTypeValue*));
        {$IFDEF D3D12_SDK_VERSION_613}
        procedure FinalizeCb();
    {$ENDIF}
    end;
    {$interfaces com}

    TD3DX12_MESH_SHADER_PIPELINE_STATE_DESC = record
        pRootSignature: PID3D12RootSignature;
        AS_Code: TD3D12_SHADER_BYTECODE;
        MS_Code: TD3D12_SHADER_BYTECODE;
        PS_Code: TD3D12_SHADER_BYTECODE;
        BlendState: TD3D12_BLEND_DESC;
        SampleMask: UINT;
        RasterizerState: TD3D12_RASTERIZER_DESC;
        DepthStencilState: TD3D12_DEPTH_STENCIL_DESC;
        PrimitiveTopologyType: TD3D12_PRIMITIVE_TOPOLOGY_TYPE;
        NumRenderTargets: UINT;
        RTVFormats: array [0..D3D12_SIMULTANEOUS_RENDER_TARGET_COUNT - 1] of TDXGI_FORMAT;
        DSVFormat: TDXGI_FORMAT;
        SampleDesc: TDXGI_SAMPLE_DESC;
        NodeMask: UINT;
        CachedPSO: TD3D12_CACHED_PIPELINE_STATE;
        Flags: TD3D12_PIPELINE_STATE_FLAGS;
    end;
    PD3DX12_MESH_SHADER_PIPELINE_STATE_DESC = ^TD3DX12_MESH_SHADER_PIPELINE_STATE_DESC;

    {$IFDEF D3D12_SDK_VERSION_618}
    { TCD3DX12_PIPELINE_STATE_STREAM6 }

    { TD3DX12_PIPELINE_STATE_STREAM6 }

    // for D3D12_SDK_VERSION >= 618 Use CD3DX12_PIPELINE_STATE_STREAM6
    // for D3D12_SDK_VERSION >= 610 Use CD3DX12_PIPELINE_STATE_STREAM5 for D3D12_RASTERIZER_DESC2 when CheckFeatureSupport returns true for Options19::RasterizerDesc2Supported is true
    // for D3D12_SDK_VERSION >= 608 Use CD3DX12_PIPELINE_STATE_STREAM4 for D3D12_RASTERIZER_DESC1 when CheckFeatureSupport returns true for Options16::DynamicDepthBiasSupported is true
    // for D3D12_SDK_VERSION >= 606 Use CD3DX12_PIPELINE_STATE_STREAM3 for D3D12_DEPTH_STENCIL_DESC2 when CheckFeatureSupport returns true for Options14::IndependentFrontAndBackStencilSupported is true
    // Use CD3DX12_PIPELINE_STATE_STREAM2 for OS Build 19041+ (where there is a new mesh shader pipeline).
    // Use CD3DX12_PIPELINE_STATE_STREAM1 for OS Build 16299+ (where there is a new view instancing subobject).
    // Use CD3DX12_PIPELINE_STATE_STREAM for OS Build 15063+ support.


    TD3DX12_PIPELINE_STATE_STREAM6 = record
        Flags: TD3DX12_PIPELINE_STATE_STREAM_FLAGS;
        NodeMask: TD3DX12_PIPELINE_STATE_STREAM_NODE_MASK;
        pRootSignature: TD3DX12_PIPELINE_STATE_STREAM_ROOT_SIGNATURE;
        InputLayout: TD3DX12_PIPELINE_STATE_STREAM_INPUT_LAYOUT;
        IBStripCutValue: TD3DX12_PIPELINE_STATE_STREAM_IB_STRIP_CUT_VALUE;
        PrimitiveTopologyType: TD3DX12_PIPELINE_STATE_STREAM_PRIMITIVE_TOPOLOGY;
        Stream_VS: TD3DX12_PIPELINE_STATE_STREAM_VS;
        Stream_GS: TD3DX12_PIPELINE_STATE_STREAM_GS;
        StreamOutput: TD3DX12_PIPELINE_STATE_STREAM_STREAM_OUTPUT;
        Stream_HS: TD3DX12_PIPELINE_STATE_STREAM_HS;
        Stream_DS: TD3DX12_PIPELINE_STATE_STREAM_DS;
        Stream_PS: TD3DX12_PIPELINE_STATE_STREAM_PS;
        Stream_AS: TD3DX12_PIPELINE_STATE_STREAM_AS;
        Stream_MS: TD3DX12_PIPELINE_STATE_STREAM_MS;
        Stream_CS: TD3DX12_PIPELINE_STATE_STREAM_CS;
        BlendState: TD3DX12_PIPELINE_STATE_STREAM_BLEND_DESC;
        DepthStencilState: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL2;
        DSVFormat: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL_FORMAT;
        RasterizerState: TD3DX12_PIPELINE_STATE_STREAM_RASTERIZER2;
        RTVFormats: TD3DX12_PIPELINE_STATE_STREAM_RENDER_TARGET_FORMATS;
        SampleDesc: TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_DESC;
        SampleMask: TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_MASK;
        CachedPSO: TD3DX12_PIPELINE_STATE_STREAM_CACHED_PSO;
        ViewInstancingDesc: TD3DX12_PIPELINE_STATE_STREAM_VIEW_INSTANCING;
        SerializedRootSignature: TD3DX12_PIPELINE_STATE_STREAM_SERIALIZED_ROOT_SIGNATURE;
        function GraphicsDescV0(): TD3D12_GRAPHICS_PIPELINE_STATE_DESC;
        function ComputeDescV0(): TD3D12_COMPUTE_PIPELINE_STATE_DESC;
        // Mesh and amplification shaders must be set manually, since they do not have representation in D3D12_GRAPHICS_PIPELINE_STATE_DESC
        procedure Init(Desc: TD3D12_GRAPHICS_PIPELINE_STATE_DESC);
        procedure Init(Desc: TD3DX12_MESH_SHADER_PIPELINE_STATE_DESC);
        procedure Init(Desc: TD3D12_COMPUTE_PIPELINE_STATE_DESC);
        class operator Initialize(var aRec: TD3DX12_PIPELINE_STATE_STREAM6);
    end;
    PD3DX12_PIPELINE_STATE_STREAM = ^TD3DX12_PIPELINE_STATE_STREAM;
    {$ENDIF}

    {$IFDEF D3D12_SDK_VERSION_610}
    // Use CD3DX12_PIPELINE_STATE_STREAM5 for D3D12_RASTERIZER_DESC2 when CheckFeatureSupport returns true for Options19::RasterizerDesc2Supported is true
    // Use CD3DX12_PIPELINE_STATE_STREAM4 for D3D12_RASTERIZER_DESC1 when CheckFeatureSupport returns true for Options16::DynamicDepthBiasSupported is true
    // Use CD3DX12_PIPELINE_STATE_STREAM3 for D3D12_DEPTH_STENCIL_DESC2 when CheckFeatureSupport returns true for Options14::IndependentFrontAndBackStencilSupported is true
    // Use CD3DX12_PIPELINE_STATE_STREAM2 for OS Build 19041+ (where there is a new mesh shader pipeline).
    // Use CD3DX12_PIPELINE_STATE_STREAM1 for OS Build 16299+ (where there is a new view instancing subobject).
    // Use CD3DX12_PIPELINE_STATE_STREAM for OS Build 15063+ support.

    { TD3DX12_PIPELINE_STATE_STREAM5 }

    TD3DX12_PIPELINE_STATE_STREAM5 = record
        Flags: TD3DX12_PIPELINE_STATE_STREAM_FLAGS;
        NodeMask: TD3DX12_PIPELINE_STATE_STREAM_NODE_MASK;
        pRootSignature: TD3DX12_PIPELINE_STATE_STREAM_ROOT_SIGNATURE;
        InputLayout: TD3DX12_PIPELINE_STATE_STREAM_INPUT_LAYOUT;
        IBStripCutValue: TD3DX12_PIPELINE_STATE_STREAM_IB_STRIP_CUT_VALUE;
        PrimitiveTopologyType: TD3DX12_PIPELINE_STATE_STREAM_PRIMITIVE_TOPOLOGY;
        Stream_VS: TD3DX12_PIPELINE_STATE_STREAM_VS;
        Stream_GS: TD3DX12_PIPELINE_STATE_STREAM_GS;
        StreamOutput: TD3DX12_PIPELINE_STATE_STREAM_STREAM_OUTPUT;
        Stream_HS: TD3DX12_PIPELINE_STATE_STREAM_HS;
        Stream_DS: TD3DX12_PIPELINE_STATE_STREAM_DS;
        Stream_PS: TD3DX12_PIPELINE_STATE_STREAM_PS;
        Stream_AS: TD3DX12_PIPELINE_STATE_STREAM_AS;
        Stream_MS: TD3DX12_PIPELINE_STATE_STREAM_MS;
        Stream_CS: TD3DX12_PIPELINE_STATE_STREAM_CS;
        BlendState: TD3DX12_PIPELINE_STATE_STREAM_BLEND_DESC;
        DepthStencilState: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL2;
        DSVFormat: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL_FORMAT;
        RasterizerState: TD3DX12_PIPELINE_STATE_STREAM_RASTERIZER2;
        RTVFormats: TD3DX12_PIPELINE_STATE_STREAM_RENDER_TARGET_FORMATS;
        SampleDesc: TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_DESC;
        SampleMask: TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_MASK;
        CachedPSO: TD3DX12_PIPELINE_STATE_STREAM_CACHED_PSO;
        ViewInstancingDesc: TD3DX12_PIPELINE_STATE_STREAM_VIEW_INSTANCING;
        function GraphicsDescV0(): TD3D12_GRAPHICS_PIPELINE_STATE_DESC;
        function ComputeDescV0(): TD3D12_COMPUTE_PIPELINE_STATE_DESC;
        // Mesh and amplification shaders must be set manually, since they do not have representation in D3D12_GRAPHICS_PIPELINE_STATE_DESC
        procedure Init(Desc: TD3D12_GRAPHICS_PIPELINE_STATE_DESC);
        procedure Init(Desc: TD3DX12_MESH_SHADER_PIPELINE_STATE_DESC);
        procedure Init(Desc: TD3D12_COMPUTE_PIPELINE_STATE_DESC);

    end;
    {$ENDIF}// D3D12_SDK_VERSION >= 610

    {$IFDEF D3D12_SDK_VERSION_608}
    // Use CD3DX12_PIPELINE_STATE_STREAM4 for D3D12_RASTERIZER_DESC1 when CheckFeatureSupport returns true for Options16::DynamicDepthBiasSupported is true
    // Use CD3DX12_PIPELINE_STATE_STREAM3 for D3D12_DEPTH_STENCIL_DESC2 when CheckFeatureSupport returns true for Options14::IndependentFrontAndBackStencilSupported is true
    // Use CD3DX12_PIPELINE_STATE_STREAM2 for OS Build 19041+ (where there is a new mesh shader pipeline).
    // Use CD3DX12_PIPELINE_STATE_STREAM1 for OS Build 16299+ (where there is a new view instancing subobject).
    // Use CD3DX12_PIPELINE_STATE_STREAM for OS Build 15063+ support.

    { TD3DX12_PIPELINE_STATE_STREAM4 }

    TD3DX12_PIPELINE_STATE_STREAM4 = record
        Flags: TD3DX12_PIPELINE_STATE_STREAM_FLAGS;
        NodeMask: TD3DX12_PIPELINE_STATE_STREAM_NODE_MASK;
        pRootSignature: TD3DX12_PIPELINE_STATE_STREAM_ROOT_SIGNATURE;
        InputLayout: TD3DX12_PIPELINE_STATE_STREAM_INPUT_LAYOUT;
        IBStripCutValue: TD3DX12_PIPELINE_STATE_STREAM_IB_STRIP_CUT_VALUE;
        PrimitiveTopologyType: TD3DX12_PIPELINE_STATE_STREAM_PRIMITIVE_TOPOLOGY;
        Stream_VS: TD3DX12_PIPELINE_STATE_STREAM_VS;
        Stream_GS: TD3DX12_PIPELINE_STATE_STREAM_GS;
        StreamOutput: TD3DX12_PIPELINE_STATE_STREAM_STREAM_OUTPUT;
        Stream_HS: TD3DX12_PIPELINE_STATE_STREAM_HS;
        Stream_DS: TD3DX12_PIPELINE_STATE_STREAM_DS;
        Stream_PS: TD3DX12_PIPELINE_STATE_STREAM_PS;
        Stream_AS: TD3DX12_PIPELINE_STATE_STREAM_AS;
        Stream_MS: TD3DX12_PIPELINE_STATE_STREAM_MS;
        Stream_CS: TD3DX12_PIPELINE_STATE_STREAM_CS;
        BlendState: TD3DX12_PIPELINE_STATE_STREAM_BLEND_DESC;
        DepthStencilState: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL2;
        DSVFormat: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL_FORMAT;
        RasterizerState: TD3DX12_PIPELINE_STATE_STREAM_RASTERIZER1;
        RTVFormats: TD3DX12_PIPELINE_STATE_STREAM_RENDER_TARGET_FORMATS;
        SampleDesc: TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_DESC;
        SampleMask: TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_MASK;
        CachedPSO: TD3DX12_PIPELINE_STATE_STREAM_CACHED_PSO;
        ViewInstancingDesc: TD3DX12_PIPELINE_STATE_STREAM_VIEW_INSTANCING;
        function GraphicsDescV0(): TD3D12_GRAPHICS_PIPELINE_STATE_DESC;
        function ComputeDescV0(): TD3D12_COMPUTE_PIPELINE_STATE_DESC;
        // Mesh and amplification shaders must be set manually, since they do not have representation in D3D12_GRAPHICS_PIPELINE_STATE_DESC
        procedure Init(Desc: TD3D12_GRAPHICS_PIPELINE_STATE_DESC);
        procedure Init(Desc: TD3DX12_MESH_SHADER_PIPELINE_STATE_DESC);
        procedure Init(Desc: TD3D12_COMPUTE_PIPELINE_STATE_DESC);
    end;
    {$ENDIF}// D3D12_SDK_VERSION >= 608

    {$IFDEF D3D12_SDK_VERSION_606}
    // Use CD3DX12_PIPELINE_STATE_STREAM3 for D3D12_DEPTH_STENCIL_DESC2 when CheckFeatureSupport returns true for Options14::IndependentFrontAndBackStencilSupported is true
    // Use CD3DX12_PIPELINE_STATE_STREAM2 for OS Build 19041+ (where there is a new mesh shader pipeline).
    // Use CD3DX12_PIPELINE_STATE_STREAM1 for OS Build 16299+ (where there is a new view instancing subobject).
    // Use CD3DX12_PIPELINE_STATE_STREAM for OS Build 15063+ support.

    { TD3DX12_PIPELINE_STATE_STREAM3 }

    TD3DX12_PIPELINE_STATE_STREAM3 = record
        Flags: TD3DX12_PIPELINE_STATE_STREAM_FLAGS;
        NodeMask: TD3DX12_PIPELINE_STATE_STREAM_NODE_MASK;
        pRootSignature: TD3DX12_PIPELINE_STATE_STREAM_ROOT_SIGNATURE;
        InputLayout: TD3DX12_PIPELINE_STATE_STREAM_INPUT_LAYOUT;
        IBStripCutValue: TD3DX12_PIPELINE_STATE_STREAM_IB_STRIP_CUT_VALUE;
        PrimitiveTopologyType: TD3DX12_PIPELINE_STATE_STREAM_PRIMITIVE_TOPOLOGY;
        Stream_VS: TD3DX12_PIPELINE_STATE_STREAM_VS;
        Stream_GS: TD3DX12_PIPELINE_STATE_STREAM_GS;
        StreamOutput: TD3DX12_PIPELINE_STATE_STREAM_STREAM_OUTPUT;
        Stream_HS: TD3DX12_PIPELINE_STATE_STREAM_HS;
        Stream_DS: TD3DX12_PIPELINE_STATE_STREAM_DS;
        Stream_PS: TD3DX12_PIPELINE_STATE_STREAM_PS;
        Stream_AS: TD3DX12_PIPELINE_STATE_STREAM_AS;
        Stream_MS: TD3DX12_PIPELINE_STATE_STREAM_MS;
        Stream_CS: TD3DX12_PIPELINE_STATE_STREAM_CS;
        BlendState: TD3DX12_PIPELINE_STATE_STREAM_BLEND_DESC;
        DepthStencilState: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL2;
        DSVFormat: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL_FORMAT;
        RasterizerState: TD3DX12_PIPELINE_STATE_STREAM_RASTERIZER;
        RTVFormats: TD3DX12_PIPELINE_STATE_STREAM_RENDER_TARGET_FORMATS;
        SampleDesc: TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_DESC;
        SampleMask: TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_MASK;
        CachedPSO: TD3DX12_PIPELINE_STATE_STREAM_CACHED_PSO;
        ViewInstancingDesc: TD3DX12_PIPELINE_STATE_STREAM_VIEW_INSTANCING;
        function GraphicsDescV0(): TD3D12_GRAPHICS_PIPELINE_STATE_DESC;
        function ComputeDescV0(): TD3D12_COMPUTE_PIPELINE_STATE_DESC;
        // Mesh and amplification shaders must be set manually, since they do not have representation in D3D12_GRAPHICS_PIPELINE_STATE_DESC
        procedure Init(Desc: TD3D12_GRAPHICS_PIPELINE_STATE_DESC);
        procedure Init(Desc: TD3DX12_MESH_SHADER_PIPELINE_STATE_DESC);
        procedure Init(Desc: TD3D12_COMPUTE_PIPELINE_STATE_DESC);
    end;
    {$ENDIF}// D3D12_SDK_VERSION >= 606

    // CD3DX12_PIPELINE_STATE_STREAM2 Works on OS Build 19041+ (where there is a new mesh shader pipeline).
    // Use CD3DX12_PIPELINE_STATE_STREAM1 for OS Build 16299+ (where there is a new view instancing subobject).
    // Use CD3DX12_PIPELINE_STATE_STREAM for OS Build 15063+ support.

    { TD3DX12_PIPELINE_STATE_STREAM2 }

    TD3DX12_PIPELINE_STATE_STREAM2 = record
        Flags: TD3DX12_PIPELINE_STATE_STREAM_FLAGS;
        NodeMask: TD3DX12_PIPELINE_STATE_STREAM_NODE_MASK;
        pRootSignature: TD3DX12_PIPELINE_STATE_STREAM_ROOT_SIGNATURE;
        InputLayout: TD3DX12_PIPELINE_STATE_STREAM_INPUT_LAYOUT;
        IBStripCutValue: TD3DX12_PIPELINE_STATE_STREAM_IB_STRIP_CUT_VALUE;
        PrimitiveTopologyType: TD3DX12_PIPELINE_STATE_STREAM_PRIMITIVE_TOPOLOGY;
        Stream_VS: TD3DX12_PIPELINE_STATE_STREAM_VS;
        Stream_GS: TD3DX12_PIPELINE_STATE_STREAM_GS;
        StreamOutput: TD3DX12_PIPELINE_STATE_STREAM_STREAM_OUTPUT;
        Stream_HS: TD3DX12_PIPELINE_STATE_STREAM_HS;
        Stream_DS: TD3DX12_PIPELINE_STATE_STREAM_DS;
        Stream_PS: TD3DX12_PIPELINE_STATE_STREAM_PS;
        Stream_AS: TD3DX12_PIPELINE_STATE_STREAM_AS;
        Stream_MS: TD3DX12_PIPELINE_STATE_STREAM_MS;
        Stream_CS: TD3DX12_PIPELINE_STATE_STREAM_CS;
        BlendState: TD3DX12_PIPELINE_STATE_STREAM_BLEND_DESC;
        DepthStencilState: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL1;
        DSVFormat: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL_FORMAT;
        RasterizerState: TD3DX12_PIPELINE_STATE_STREAM_RASTERIZER;
        RTVFormats: TD3DX12_PIPELINE_STATE_STREAM_RENDER_TARGET_FORMATS;
        SampleDesc: TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_DESC;
        SampleMask: TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_MASK;
        CachedPSO: TD3DX12_PIPELINE_STATE_STREAM_CACHED_PSO;
        ViewInstancingDesc: TD3DX12_PIPELINE_STATE_STREAM_VIEW_INSTANCING;
        function GraphicsDescV0(): TD3D12_GRAPHICS_PIPELINE_STATE_DESC;
        function ComputeDescV0(): TD3D12_COMPUTE_PIPELINE_STATE_DESC;
        // Mesh and amplification shaders must be set manually, since they do not have representation in D3D12_GRAPHICS_PIPELINE_STATE_DESC
        procedure Init(Desc: TD3D12_GRAPHICS_PIPELINE_STATE_DESC);
        procedure Init(Desc: TD3DX12_MESH_SHADER_PIPELINE_STATE_DESC);
        procedure Init(Desc: TD3D12_COMPUTE_PIPELINE_STATE_DESC);
    end;

    // CD3DX12_PIPELINE_STATE_STREAM1 Works on OS Build 16299+ (where there is a new view instancing subobject).
    // Use CD3DX12_PIPELINE_STATE_STREAM for OS Build 15063+ support.

    { TD3DX12_PIPELINE_STATE_STREAM1 }

    TD3DX12_PIPELINE_STATE_STREAM1 = record
        Flags: TD3DX12_PIPELINE_STATE_STREAM_FLAGS;
        NodeMask: TD3DX12_PIPELINE_STATE_STREAM_NODE_MASK;
        pRootSignature: TD3DX12_PIPELINE_STATE_STREAM_ROOT_SIGNATURE;
        InputLayout: TD3DX12_PIPELINE_STATE_STREAM_INPUT_LAYOUT;
        IBStripCutValue: TD3DX12_PIPELINE_STATE_STREAM_IB_STRIP_CUT_VALUE;
        PrimitiveTopologyType: TD3DX12_PIPELINE_STATE_STREAM_PRIMITIVE_TOPOLOGY;
        Stream_VS: TD3DX12_PIPELINE_STATE_STREAM_VS;
        Stream_GS: TD3DX12_PIPELINE_STATE_STREAM_GS;
        StreamOutput: TD3DX12_PIPELINE_STATE_STREAM_STREAM_OUTPUT;
        Stream_HS: TD3DX12_PIPELINE_STATE_STREAM_HS;
        Stream_DS: TD3DX12_PIPELINE_STATE_STREAM_DS;
        Stream_PS: TD3DX12_PIPELINE_STATE_STREAM_PS;
        Stream_CS: TD3DX12_PIPELINE_STATE_STREAM_CS;
        BlendState: TD3DX12_PIPELINE_STATE_STREAM_BLEND_DESC;
        DepthStencilState: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL1;
        DSVFormat: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL_FORMAT;
        RasterizerState: TD3DX12_PIPELINE_STATE_STREAM_RASTERIZER;
        RTVFormats: TD3DX12_PIPELINE_STATE_STREAM_RENDER_TARGET_FORMATS;
        SampleDesc: TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_DESC;
        SampleMask: TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_MASK;
        CachedPSO: TD3DX12_PIPELINE_STATE_STREAM_CACHED_PSO;
        ViewInstancingDesc: TD3DX12_PIPELINE_STATE_STREAM_VIEW_INSTANCING;
        function GraphicsDescV0(): TD3D12_GRAPHICS_PIPELINE_STATE_DESC;
        function ComputeDescV0(): TD3D12_COMPUTE_PIPELINE_STATE_DESC;
        // Mesh and amplification shaders must be set manually, since they do not have representation in D3D12_GRAPHICS_PIPELINE_STATE_DESC
        procedure Init(Desc: TD3D12_GRAPHICS_PIPELINE_STATE_DESC);
        procedure Init(Desc: TD3DX12_MESH_SHADER_PIPELINE_STATE_DESC);
        procedure Init(Desc: TD3D12_COMPUTE_PIPELINE_STATE_DESC);
    end;

    // CD3DX12_PIPELINE_STATE_STREAM works on OS Build 15063+ but does not support new subobject(s) added in OS Build 16299+.
    // See CD3DX12_PIPELINE_STATE_STREAM1 for instance.
    TD3DX12_PIPELINE_STATE_STREAM = record
        Flags: TD3DX12_PIPELINE_STATE_STREAM_FLAGS;
        NodeMask: TD3DX12_PIPELINE_STATE_STREAM_NODE_MASK;
        pRootSignature: TD3DX12_PIPELINE_STATE_STREAM_ROOT_SIGNATURE;
        InputLayout: TD3DX12_PIPELINE_STATE_STREAM_INPUT_LAYOUT;
        IBStripCutValue: TD3DX12_PIPELINE_STATE_STREAM_IB_STRIP_CUT_VALUE;
        PrimitiveTopologyType: TD3DX12_PIPELINE_STATE_STREAM_PRIMITIVE_TOPOLOGY;
        Stream_VS: TD3DX12_PIPELINE_STATE_STREAM_VS;
        Stream_GS: TD3DX12_PIPELINE_STATE_STREAM_GS;
        StreamOutput: TD3DX12_PIPELINE_STATE_STREAM_STREAM_OUTPUT;
        Stream_HS: TD3DX12_PIPELINE_STATE_STREAM_HS;
        Stream_DS: TD3DX12_PIPELINE_STATE_STREAM_DS;
        Stream_PS: TD3DX12_PIPELINE_STATE_STREAM_PS;
        Stream_CS: TD3DX12_PIPELINE_STATE_STREAM_CS;
        BlendState: TD3DX12_PIPELINE_STATE_STREAM_BLEND_DESC;
        DepthStencilState: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL1;
        DSVFormat: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL_FORMAT;
        RasterizerState: TD3DX12_PIPELINE_STATE_STREAM_RASTERIZER;
        RTVFormats: TD3DX12_PIPELINE_STATE_STREAM_RENDER_TARGET_FORMATS;
        SampleDesc: TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_DESC;
        SampleMask: TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_MASK;
        CachedPSO: TD3DX12_PIPELINE_STATE_STREAM_CACHED_PSO;
        function GraphicsDescV0(): TD3D12_GRAPHICS_PIPELINE_STATE_DESC;
        function ComputeDescV0(): TD3D12_COMPUTE_PIPELINE_STATE_DESC;
        // Mesh and amplification shaders must be set manually, since they do not have representation in D3D12_GRAPHICS_PIPELINE_STATE_DESC
        procedure Init(Desc: TD3D12_GRAPHICS_PIPELINE_STATE_DESC);
        procedure Init(Desc: TD3DX12_MESH_SHADER_PIPELINE_STATE_DESC);
        procedure Init(Desc: TD3D12_COMPUTE_PIPELINE_STATE_DESC);
    end;

    { TD3DX12_PIPELINE_MESH_STATE_STREAM }

    TD3DX12_PIPELINE_MESH_STATE_STREAM = record
        Flags: TD3DX12_PIPELINE_STATE_STREAM_FLAGS;
        NodeMask: TD3DX12_PIPELINE_STATE_STREAM_NODE_MASK;
        pRootSignature: TD3DX12_PIPELINE_STATE_STREAM_ROOT_SIGNATURE;
        PrimitiveTopologyType: TD3DX12_PIPELINE_STATE_STREAM_PRIMITIVE_TOPOLOGY;
        Stream_PS: TD3DX12_PIPELINE_STATE_STREAM_PS;
        Stream_AS: TD3DX12_PIPELINE_STATE_STREAM_AS;
        Stream_MS: TD3DX12_PIPELINE_STATE_STREAM_MS;
        BlendState: TD3DX12_PIPELINE_STATE_STREAM_BLEND_DESC;
        DepthStencilState: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL1;
        DSVFormat: TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL_FORMAT;
        RasterizerState: TD3DX12_PIPELINE_STATE_STREAM_RASTERIZER;
        RTVFormats: TD3DX12_PIPELINE_STATE_STREAM_RENDER_TARGET_FORMATS;
        SampleDesc: TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_DESC;
        SampleMask: TD3DX12_PIPELINE_STATE_STREAM_SAMPLE_MASK;
        CachedPSO: TD3DX12_PIPELINE_STATE_STREAM_CACHED_PSO;
        ViewInstancingDesc: TD3DX12_PIPELINE_STATE_STREAM_VIEW_INSTANCING;
        procedure Init(Desc: TD3DX12_MESH_SHADER_PIPELINE_STATE_DESC);
        function MeshShaderDescV0: TD3DX12_MESH_SHADER_PIPELINE_STATE_DESC;
    end;

    PD3DX12_PIPELINE_MESH_STATE_STREAM = ^TD3DX12_PIPELINE_MESH_STATE_STREAM;
{
    // CD3DX12_PIPELINE_STATE_STREAM works on OS Build 15063+ but does not support new subobject(s) added in OS Build 16299+.
    // See CD3DX12_PIPELINE_STATE_STREAM1 for instance.
    TD3DX12_PIPELINE_STATE_STREAM = record

    end;   }

    {$interfaces corba}

    // since the SDK_Version is defined not as a number in Pascal, we use one implementation and use the $DEFINE statemens here
    // also the code therefore gets simpler than in the original MS C++ header file.
    // remember: Pascal is always smarter :)

    { TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER }

    TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER = class(ID3DX12PipelineParserCallbacks)
    protected
        SeenDSS: boolean;
        SeenMS: boolean;
        SeenTopology: boolean;
        {$IFDEF D3D12_SDK_VERSION_618}
        PipelineStream: TD3DX12_PIPELINE_STATE_STREAM6;
    {$ELSE}
        {$IFDEF D3D12_SDK_VERSION_613}
        // This SDK 613 version has better primitive topology default handling than the v610 equivalent below.
        PipelineStream: TD3DX12_PIPELINE_STATE_STREAM5;
        {$ELSE}
        {$IFDEF D3D12_SDK_VERSION_608}
        PipelineStream: TD3DX12_PIPELINE_STATE_STREAM4;
        {$ELSE}
        {$IFDEF D3D12_SDK_VERSION_606}
        PipelineStream: TD3DX12_PIPELINE_STATE_STREAM3;
        {$ELSE}
         PipelineStream: TD3DX12_PIPELINE_STATE_STREAM2;
        // StreamHelper1 is defined in MS C++ header, but not implemented here
        // PipelineStream: TD3DX12_PIPELINE_STATE_STREAM1;
        {$ENDIF} // D3D12_SDK_VERSION >= 606
        {$ENDIF} // D3D12_SDK_VERSION >= 608
        {$ENDIF} // D3D12_SDK_VERSION >= 613
    {$ENDIF}// D3D12_SDK_VERSION >= 618
    public
        constructor Create;

        // ID3DX12PipelineParserCallbacks
        procedure FlagsCb(Flags: TD3D12_PIPELINE_STATE_FLAGS);
        procedure NodeMaskCb(NodeMask: UINT);
        procedure RootSignatureCb(pRootSignature: PID3D12RootSignature);
        procedure InputLayoutCb(InputLayout: PD3D12_INPUT_LAYOUT_DESC);
        procedure IBStripCutValueCb(IBStripCutValue: TD3D12_INDEX_BUFFER_STRIP_CUT_VALUE);
        procedure PrimitiveTopologyTypeCb(PrimitiveTopologyType: TD3D12_PRIMITIVE_TOPOLOGY_TYPE);
        procedure VSCb(VS_Code: PD3D12_SHADER_BYTECODE);
        procedure GSCb(GS_Code: PD3D12_SHADER_BYTECODE);
        procedure StreamOutputCb(StreamOutput: PD3D12_STREAM_OUTPUT_DESC);
        procedure HSCb(HS_Code: PD3D12_SHADER_BYTECODE);
        procedure DSCb(DS_Code: PD3D12_SHADER_BYTECODE);
        procedure PSCb(PS_Code: PD3D12_SHADER_BYTECODE);
        procedure CSCb(CS_Code: PD3D12_SHADER_BYTECODE);
        procedure ASCb(AS_Code: PD3D12_SHADER_BYTECODE);
        procedure MSCb(MS_Code: PD3D12_SHADER_BYTECODE);
        procedure BlendStateCb(BlendState: PD3D12_BLEND_DESC);
        procedure DepthStencilStateCb(DepthStencilState: PD3D12_DEPTH_STENCIL_DESC);
        procedure DepthStencilState1Cb(DepthStencilState: PD3D12_DEPTH_STENCIL_DESC1);
        {$IFDEF D3D12_SDK_VERSION_606}
        procedure DepthStencilState2Cb(DepthStencilState: PD3D12_DEPTH_STENCIL_DESC2);
    {$ENDIF}
        procedure DSVFormatCb(DSVFormat: TDXGI_FORMAT);
        procedure RasterizerStateCb(RasterizerState: PD3D12_RASTERIZER_DESC);
        {$IFDEF D3D12_SDK_VERSION_608}
        procedure RasterizerState1Cb(RasterizerState: PD3D12_RASTERIZER_DESC1);
    {$ENDIF}
        {$IFDEF D3D12_SDK_VERSION_610}
        procedure RasterizerState2Cb(RasterizerState: PD3D12_RASTERIZER_DESC2);
    {$ENDIF}
        procedure RTVFormatsCb(RTVFormats: PD3D12_RT_FORMAT_ARRAY);
        procedure SampleDescCb(SampleDesc: PDXGI_SAMPLE_DESC);
        procedure SampleMaskCb(SampleMask: UINT);
        procedure ViewInstancingCb(ViewInstancingDesc: PD3D12_VIEW_INSTANCING_DESC);
        procedure CachedPSOCb(CachedPSO: PD3D12_CACHED_PIPELINE_STATE);
        {$IFDEF D3D12_SDK_VERSION_618}
        procedure SerializedRootSignatureCb(SerializedRootSignature: PD3D12_SERIALIZED_ROOT_SIGNATURE_DESC);
    {$ENDIF}

        // Error Callbacks
        procedure ErrorBadInputParameter(Nameless1: UINT (*ParameterIndex*));
        procedure ErrorDuplicateSubobject(Nameless1: TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE (*DuplicateType*));
        procedure ErrorUnknownSubobject(Nameless1: UINT (*UnknownTypeValue*));
        {$IFDEF D3D12_SDK_VERSION_613}
        procedure FinalizeCb();
    {$ENDIF}
    end;


    {$interfaces com}


function D3DX12GetBaseSubobjectType(SubobjectType: TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE): TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE; {$IFDEF D3DX12INLINE}inline;{$ENDIF}

function D3DX12ParsePipelineStream(Desc: PD3D12_PIPELINE_STATE_STREAM_DESC; pCallbacks: ID3DX12PipelineParserCallbacks): HRESULT; {$IFDEF D3DX12INLINE}inline;{$ENDIF}


implementation

uses
    DX12.D3DCommon,
    DX12.D3DX12_Core;



function D3DX12GetBaseSubobjectType(SubobjectType: TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE): TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE;
begin
    case (SubobjectType) of
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_DEPTH_STENCIL1:
            Result := D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_DEPTH_STENCIL;
        {$IFDEF D3D12_SDK_VERSION_606}
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_DEPTH_STENCIL2:
            Result := D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_DEPTH_STENCIL;
    {$ENDIF}
        {$IFDEF D3D12_SDK_VERSION_608}
        D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_RASTERIZER1:
            Result := D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_RASTERIZER;
    {$ENDIF}
        else
            Result := SubobjectType;
    end;
end;



function D3DX12ParsePipelineStream(Desc: PD3D12_PIPELINE_STATE_STREAM_DESC; pCallbacks: ID3DX12PipelineParserCallbacks): HRESULT;
var
    SubobjectSeen: array [0..Ord(D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_MAX_VALID) - 1] of boolean;
    CurOffset: SIZE_T;
    pStream: pbyte;
    SizeOfSubobject: Size_T;
    SubobjectType: PD3D12_PIPELINE_STATE_SUBOBJECT_TYPE;
begin
    if (pCallbacks = nil) then
    begin
        Result := E_INVALIDARG;
        Exit;
    end;

    if (Desc^.SizeInBytes = 0) or (Desc^.pPipelineStateSubobjectStream = nil) then
    begin
        pCallbacks.ErrorBadInputParameter(1); // first parameter issue
        Result := E_INVALIDARG;
        Exit;
    end;

    SizeOfSubobject := 0;
    CurOffset := 0;
    while CurOffset < Desc^.SizeInBytes - 1 do
    begin
        pStream := pbyte(Desc^.pPipelineStateSubobjectStream) + CurOffset;
        SubobjectType := PD3D12_PIPELINE_STATE_SUBOBJECT_TYPE(pStream);
        if (Ord(SubobjectType^) < 0) or (Ord(SubobjectType^) >= Ord(D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_MAX_VALID)) then
        begin
            pCallbacks.ErrorUnknownSubobject(Ord(SubobjectType^));
            Result := E_INVALIDARG;
            Exit;
        end;
        if (SubobjectSeen[Ord(D3DX12GetBaseSubobjectType(SubobjectType^))]) then
        begin
            pCallbacks.ErrorDuplicateSubobject((SubobjectType^));
            Result := E_INVALIDARG; // disallow subobject duplicates in a stream
            Exit;
        end;
        SubobjectSeen[Ord(SubobjectType^)] := True;
        case (SubobjectType^) of

            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_ROOT_SIGNATURE:
            begin
                pCallbacks.RootSignatureCb(PID3D12RootSignature(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.pRootSignature);
            end;
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_VS:
            begin
                pCallbacks.VSCb(PD3D12_SHADER_BYTECODE(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.Stream_VS);
            end;
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_PS:
            begin
                pCallbacks.PSCb(PD3D12_SHADER_BYTECODE(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.Stream_PS);
            end;
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_DS:
            begin
                pCallbacks.DSCb(PD3D12_SHADER_BYTECODE(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.Stream_DS);
            end;
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_HS:
            begin
                pCallbacks.HSCb(PD3D12_SHADER_BYTECODE(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.Stream_HS);
            end;
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_GS:
            begin
                pCallbacks.GSCb(PD3D12_SHADER_BYTECODE(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.Stream_GS);
            end;
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_CS:
            begin
                pCallbacks.CSCb(PD3D12_SHADER_BYTECODE(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM2.Stream_CS);
            end;
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_AS:
            begin
                pCallbacks.ASCb(PD3D12_SHADER_BYTECODE(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM2.Stream_AS);
            end;
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_MS:
            begin
                pCallbacks.MSCb(PD3D12_SHADER_BYTECODE(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM2.Stream_MS);
            end;
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_STREAM_OUTPUT:
            begin
                pCallbacks.StreamOutputCb(PD3D12_STREAM_OUTPUT_DESC(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.StreamOutput);
            end;
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_BLEND:
            begin
                pCallbacks.BlendStateCb(PD3D12_BLEND_DESC(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.BlendState);
            end;
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_SAMPLE_MASK:
            begin
                pCallbacks.SampleMaskCb(PUINT(pStream)^);
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.SampleMask);
            end;
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_RASTERIZER:
            begin
                pCallbacks.RasterizerStateCb(PD3D12_RASTERIZER_DESC(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.RasterizerState);
            end;
            {$IFDEF D3D12_SDK_VERSION_608}
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_RASTERIZER1:
            begin
                pCallbacks.RasterizerState1Cb(PD3D12_RASTERIZER_DESC1(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.RasterizerState);
            end;
    {$ENDIF}
            {$IFDEF D3D12_SDK_VERSION_610}
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_RASTERIZER2:
            begin
                pCallbacks.RasterizerState2Cb(PD3D12_RASTERIZER_DESC2(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.RasterizerState);
            end;
    {$ENDIF}
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_DEPTH_STENCIL:
            begin
                pCallbacks.DepthStencilStateCb(PD3D12_DEPTH_STENCIL_DESC(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM_DEPTH_STENCIL);
            end;
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_DEPTH_STENCIL1:
            begin
                pCallbacks.DepthStencilState1Cb(PD3D12_DEPTH_STENCIL_DESC1(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.DepthStencilState);
            end;
            {$IFDEF D3D12_SDK_VERSION_606}
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_DEPTH_STENCIL2:
            begin
                pCallbacks.DepthStencilState2Cb(PD3D12_DEPTH_STENCIL_DESC2(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.DepthStencilState);
            end;
    {$ENDIF}
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_INPUT_LAYOUT:
            begin
                pCallbacks.InputLayoutCb(PD3D12_INPUT_LAYOUT_DESC(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.InputLayout);
            end;
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_IB_STRIP_CUT_VALUE:
            begin
                pCallbacks.IBStripCutValueCb((PD3D12_INDEX_BUFFER_STRIP_CUT_VALUE(pStream))^);
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.IBStripCutValue);
            end;
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_PRIMITIVE_TOPOLOGY:
            begin
                pCallbacks.PrimitiveTopologyTypeCb(PD3D12_PRIMITIVE_TOPOLOGY_TYPE(pStream)^);
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.PrimitiveTopologyType);
            end;
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_RENDER_TARGET_FORMATS:
            begin
                pCallbacks.RTVFormatsCb(PD3D12_RT_FORMAT_ARRAY(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.RTVFormats);
            end;
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_DEPTH_STENCIL_FORMAT:
            begin
                pCallbacks.DSVFormatCb(PDXGI_FORMAT(pStream)^);
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.DSVFormat);
            end;
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_SAMPLE_DESC:
            begin
                pCallbacks.SampleDescCb(PDXGI_SAMPLE_DESC(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.SampleDesc);
            end;
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_NODE_MASK:
            begin
                pCallbacks.NodeMaskCb(PUINT(pStream)^);
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.NodeMask);
            end;
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_CACHED_PSO:
            begin
                pCallbacks.CachedPSOCb(PD3D12_CACHED_PIPELINE_STATE(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.CachedPSO);
            end;
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_FLAGS:
            begin
                pCallbacks.FlagsCb(PD3D12_PIPELINE_STATE_FLAGS(pStream)^);
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM.Flags);
            end;
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_VIEW_INSTANCING:
            begin
                pCallbacks.ViewInstancingCb(PD3D12_VIEW_INSTANCING_DESC(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM1.ViewInstancingDesc);
            end;
            {$IFDEF D3D12_SDK_VERSION_618}
            D3D12_PIPELINE_STATE_SUBOBJECT_TYPE_SERIALIZED_ROOT_SIGNATURE:
            begin
                pCallbacks.SerializedRootSignatureCb(PD3D12_SERIALIZED_ROOT_SIGNATURE_DESC(pStream));
                SizeOfSubobject := sizeof(TD3DX12_PIPELINE_STATE_STREAM6.SerializedRootSignature);
            end;
    {$ENDIF}
            else
                pCallbacks.ErrorUnknownSubobject(Ord(SubobjectType^));
                Result := E_INVALIDARG;
                Exit;
        end;
        CurOffset := CurOffset + SizeOfSubobject;
    end;
    {$IFDEF D3D12_SDK_VERSION_613}
    pCallbacks.FinalizeCb();
    {$ENDIF}

    Result := S_OK;

end;

{ TDefaultSampleMask }

class operator TDefaultSampleMask.Explicit(o: TDefaultSampleMask): UINT;
begin
    Result := UINT_MAX;
end;

{ TDefaultSampleDesc }

class operator TDefaultSampleDesc.Explicit(o: TDefaultSampleDesc): TDXGI_SAMPLE_DESC;
begin
    Result.Init(1, 0);
end;

{ TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT }

{$IFDEF AssignOperator}
class operator TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT.:=(
  x: TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT)y: T;
begin
    y:=x.pssInner;
end;

class operator TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT.:=(x: T)
  y: TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT;
begin
    y.pssInner := x;
end;
{$ENDIF}


{ TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT }


{ TD3DX12_PIPELINE_STATE_STREAM6 }
{$IFDEF D3D12_SDK_VERSION_618}
function TD3DX12_PIPELINE_STATE_STREAM6.GraphicsDescV0(): TD3D12_GRAPHICS_PIPELINE_STATE_DESC;
var
    D: TD3D12_GRAPHICS_PIPELINE_STATE_DESC;
begin
    D.Flags := self.Flags;
    D.NodeMask := self.NodeMask;
    D.pRootSignature := self.pRootSignature;
    D.InputLayout := self.InputLayout;
    D.IBStripCutValue := self.IBStripCutValue;
    D.PrimitiveTopologyType := self.PrimitiveTopologyType;
    D.VS := self.Stream_VS;
    D.GS := self.Stream_GS;
    D.StreamOutput := self.StreamOutput;
    D.HS := self.Stream_HS;
    D.DS := self.Stream_DS;
    D.PS := self.Stream_PS;
    D.BlendState := self.BlendState;
    D.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC(TD3D12_DEPTH_STENCIL_DESC2(self.DepthStencilState));
    D.DSVFormat := self.DSVFormat;
    D.RasterizerState := TD3D12_RASTERIZER_DESC(TD3D12_RASTERIZER_DESC2(self.RasterizerState));
    D.NumRenderTargets := TD3D12_RT_FORMAT_ARRAY(self.RTVFormats).NumRenderTargets;
    Move(TD3D12_RT_FORMAT_ARRAY(self.RTVFormats).RTFormats, D.RTVFormats, sizeof(D.RTVFormats));
    D.SampleDesc := self.SampleDesc;
    D.SampleMask := self.SampleMask;
    D.CachedPSO := self.CachedPSO;
    Result := D;
end;



function TD3DX12_PIPELINE_STATE_STREAM6.ComputeDescV0(): TD3D12_COMPUTE_PIPELINE_STATE_DESC;
var
    D: TD3D12_COMPUTE_PIPELINE_STATE_DESC;
begin

    D.Flags := self.Flags;
    D.NodeMask := self.NodeMask;
    D.pRootSignature := self.pRootSignature;
    D.CS := self.Stream_CS;
    D.CachedPSO := self.CachedPSO;
    Result := D;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6.Init(Desc: TD3D12_GRAPHICS_PIPELINE_STATE_DESC);
begin
    self.Flags := Desc.Flags;
    self.NodeMask := Desc.NodeMask;
    self.pRootSignature := Desc.pRootSignature;
    self.InputLayout := Desc.InputLayout;
    self.IBStripCutValue := Desc.IBStripCutValue;
    self.PrimitiveTopologyType := Desc.PrimitiveTopologyType;
    self.Stream_VS := Desc.VS;
    self.Stream_GS := Desc.GS;
    self.StreamOutput := Desc.StreamOutput;
    self.Stream_HS := Desc.HS;
    self.Stream_DS := Desc.DS;
    self.Stream_PS := Desc.PS;
    self.BlendState := TD3D12_BLEND_DESC(Desc.BlendState);
    self.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC2(Desc.DepthStencilState);
    self.DSVFormat := Desc.DSVFormat;
    self.RasterizerState := TD3D12_RASTERIZER_DESC2(TD3D12_RASTERIZER_DESC(Desc.RasterizerState));
    self.RTVFormats.pssInner.Init(Desc.RTVFormats, Desc.NumRenderTargets);
    self.SampleDesc := Desc.SampleDesc;
    self.SampleMask := Desc.SampleMask;
    self.CachedPSO := Desc.CachedPSO;
    self.ViewInstancingDesc.pssInner.Init();
    self.SerializedRootSignature.pssInner.Init();
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6.Init(Desc: TD3DX12_MESH_SHADER_PIPELINE_STATE_DESC);
begin
    self.Flags := Desc.Flags;
    self.NodeMask := Desc.NodeMask;
    self.pRootSignature := (Desc.pRootSignature);
    self.PrimitiveTopologyType := (Desc.PrimitiveTopologyType);
    self.Stream_PS := Desc.PS_Code;
    self.Stream_AS := Desc.AS_Code;
    self.Stream_MS := Desc.MS_Code;
    self.BlendState := TD3D12_BLEND_DESC(Desc.BlendState);
    self.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC2(Desc.DepthStencilState);
    self.DSVFormat := Desc.DSVFormat;
    self.RasterizerState := TD3D12_RASTERIZER_DESC2(Desc.RasterizerState);
    self.RTVFormats.pssInner.Init(Desc.RTVFormats, Desc.NumRenderTargets);
    self.SampleDesc := Desc.SampleDesc;
    self.SampleMask := Desc.SampleMask;
    self.CachedPSO := Desc.CachedPSO;
    self.ViewInstancingDesc.pssInner.Init();
    self.SerializedRootSignature.pssInner.Init();
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6.Init(Desc: TD3D12_COMPUTE_PIPELINE_STATE_DESC);
begin
    self.Flags := Desc.Flags;
    self.NodeMask := Desc.NodeMask;
    self.pRootSignature := Desc.pRootSignature;
    self.Stream_CS := TD3D12_SHADER_BYTECODE(Desc.CS);
    self.CachedPSO := Desc.CachedPSO;
    self.SerializedRootSignature.pssInner.Init();
    self.DepthStencilState.pssInner.DepthEnable := False;
end;



class operator TD3DX12_PIPELINE_STATE_STREAM6.Initialize(var aRec: TD3DX12_PIPELINE_STATE_STREAM6);
begin
    // this will init the State Stream with the default values for the specialized generics
    arec.Flags.pssInner := D3D12_PIPELINE_STATE_FLAG_NONE;


    arec.NodeMask.pssInner := 0;
    arec.pRootSignature.pssInner := nil;
    arec.InputLayout.pssInner.Init;
    arec.IBStripCutValue.pssInner := D3D12_INDEX_BUFFER_STRIP_CUT_VALUE_DISABLED;
    arec.PrimitiveTopologyType.pssInner := D3D12_PRIMITIVE_TOPOLOGY_TYPE_UNDEFINED;
    arec.Stream_VS.pssInner.Init;
    arec.Stream_GS.pssInner.Init;
    arec.StreamOutput.pssInner.Init;
    arec.Stream_HS.pssInner.Init;
    arec.Stream_DS.pssInner.Init;
    arec.Stream_PS.pssInner.Init;
    arec.Stream_AS.pssInner.Init;
    arec.Stream_MS.pssInner.Init;
    arec.Stream_CS.pssInner.Init;
    arec.BlendState.pssInner.Init;
    arec.DepthStencilState.pssInner.Init;
    arec.DSVFormat.pssInner := DXGI_FORMAT_UNKNOWN;
    arec.RasterizerState.pssInner.Init;
    arec.RTVFormats.pssInner.Init(nil, 0);
    arec.SampleDesc.pssInner.Init(1, 0);
    arec.SampleMask.pssInner := UINT_MAX;
    arec.CachedPSO.pssInner.Init;
    arec.ViewInstancingDesc.pssInner.Init;
    arec.SerializedRootSignature.pssInner.Init;
end;

{$ENDIF}

{$IFDEF D3D12_SDK_VERSION_610}
{ TD3DX12_PIPELINE_STATE_STREAM5 }

function TD3DX12_PIPELINE_STATE_STREAM5.GraphicsDescV0(): TD3D12_GRAPHICS_PIPELINE_STATE_DESC;
var
    D: TD3D12_GRAPHICS_PIPELINE_STATE_DESC;
begin
    D.Flags := self.Flags;
    D.NodeMask := self.NodeMask;
    D.pRootSignature := self.pRootSignature;
    D.InputLayout := self.InputLayout;
    D.IBStripCutValue := self.IBStripCutValue;
    D.PrimitiveTopologyType := self.PrimitiveTopologyType;
    D.VS := self.Stream_VS;
    D.GS := self.Stream_GS;
    D.StreamOutput := self.StreamOutput;
    D.HS := self.Stream_HS;
    D.DS := self.Stream_DS;
    D.PS := self.Stream_PS;
    D.BlendState := self.BlendState;
    D.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC(TD3D12_DEPTH_STENCIL_DESC2(self.DepthStencilState));
    D.DSVFormat := self.DSVFormat;
    D.RasterizerState := TD3D12_RASTERIZER_DESC(TD3D12_RASTERIZER_DESC2(self.RasterizerState));
    D.NumRenderTargets := TD3D12_RT_FORMAT_ARRAY(self.RTVFormats).NumRenderTargets;
    Move(TD3D12_RT_FORMAT_ARRAY(self.RTVFormats).RTFormats, D.RTVFormats, sizeof(D.RTVFormats));
    D.SampleDesc := self.SampleDesc;
    D.SampleMask := self.SampleMask;
    D.CachedPSO := self.CachedPSO;
    Result := D;

end;



function TD3DX12_PIPELINE_STATE_STREAM5.ComputeDescV0(): TD3D12_COMPUTE_PIPELINE_STATE_DESC;
var
    D: TD3D12_COMPUTE_PIPELINE_STATE_DESC;
begin

    D.Flags := self.Flags;
    D.NodeMask := self.NodeMask;
    D.pRootSignature := self.pRootSignature;
    D.CS := self.Stream_CS;
    D.CachedPSO := self.CachedPSO;
    Result := D;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM5.Init(Desc: TD3D12_GRAPHICS_PIPELINE_STATE_DESC);
begin
    self.Flags := Desc.Flags;
    self.NodeMask := Desc.NodeMask;
    self.pRootSignature := Desc.pRootSignature;
    self.InputLayout := Desc.InputLayout;
    self.IBStripCutValue := Desc.IBStripCutValue;
    self.PrimitiveTopologyType := Desc.PrimitiveTopologyType;
    self.Stream_VS := Desc.VS;
    self.Stream_GS := Desc.GS;
    self.StreamOutput := Desc.StreamOutput;
    self.Stream_HS := Desc.HS;
    self.Stream_DS := Desc.DS;
    self.Stream_PS := Desc.PS;
    self.BlendState := TD3D12_BLEND_DESC(Desc.BlendState);
    self.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC2(Desc.DepthStencilState);
    self.DSVFormat := Desc.DSVFormat;
    self.RasterizerState := TD3D12_RASTERIZER_DESC2(TD3D12_RASTERIZER_DESC(Desc.RasterizerState));
    self.RTVFormats.pssInner.Init(Desc.RTVFormats, Desc.NumRenderTargets);
    self.SampleDesc := Desc.SampleDesc;
    self.SampleMask := Desc.SampleMask;
    self.CachedPSO := Desc.CachedPSO;
    self.ViewInstancingDesc.pssInner.Init();
end;



procedure TD3DX12_PIPELINE_STATE_STREAM5.Init(Desc: TD3DX12_MESH_SHADER_PIPELINE_STATE_DESC);
begin
    self.Flags := Desc.Flags;
    self.NodeMask := Desc.NodeMask;
    self.pRootSignature := (Desc.pRootSignature);
    self.PrimitiveTopologyType := (Desc.PrimitiveTopologyType);
    self.Stream_PS := Desc.PS_Code;
    self.Stream_AS := Desc.AS_Code;
    self.Stream_MS := Desc.MS_Code;
    self.BlendState := TD3D12_BLEND_DESC(Desc.BlendState);
    self.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC2(Desc.DepthStencilState);
    self.DSVFormat := Desc.DSVFormat;
    self.RasterizerState := TD3D12_RASTERIZER_DESC2(Desc.RasterizerState);
    self.RTVFormats.pssInner.Init(Desc.RTVFormats, Desc.NumRenderTargets);
    self.SampleDesc := Desc.SampleDesc;
    self.SampleMask := Desc.SampleMask;
    self.CachedPSO := Desc.CachedPSO;
    self.ViewInstancingDesc.pssInner.Init();
end;



procedure TD3DX12_PIPELINE_STATE_STREAM5.Init(Desc: TD3D12_COMPUTE_PIPELINE_STATE_DESC);
begin
    self.Flags := Desc.Flags;
    self.NodeMask := Desc.NodeMask;
    self.pRootSignature := Desc.pRootSignature;
    self.Stream_CS := TD3D12_SHADER_BYTECODE(Desc.CS);
    self.CachedPSO := Desc.CachedPSO;
    self.DepthStencilState.pssInner.DepthEnable := False;
end;
{$ENDIF}

{$IFDEF D3D12_SDK_VERSION_608}
{ TD3DX12_PIPELINE_STATE_STREAM4 }

function TD3DX12_PIPELINE_STATE_STREAM4.GraphicsDescV0(): TD3D12_GRAPHICS_PIPELINE_STATE_DESC;
var
    D: TD3D12_GRAPHICS_PIPELINE_STATE_DESC;
begin
    D.Flags := self.Flags;
    D.NodeMask := self.NodeMask;
    D.pRootSignature := self.pRootSignature;
    D.InputLayout := self.InputLayout;
    D.IBStripCutValue := self.IBStripCutValue;
    D.PrimitiveTopologyType := self.PrimitiveTopologyType;
    D.VS := self.Stream_VS;
    D.GS := self.Stream_GS;
    D.StreamOutput := self.StreamOutput;
    D.HS := self.Stream_HS;
    D.DS := self.Stream_DS;
    D.PS := self.Stream_PS;
    D.BlendState := self.BlendState;
    D.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC(TD3D12_DEPTH_STENCIL_DESC2(self.DepthStencilState));
    D.DSVFormat := self.DSVFormat;
    D.RasterizerState := TD3D12_RASTERIZER_DESC(TD3D12_RASTERIZER_DESC1(self.RasterizerState));
    D.NumRenderTargets := TD3D12_RT_FORMAT_ARRAY(self.RTVFormats).NumRenderTargets;
    Move(TD3D12_RT_FORMAT_ARRAY(self.RTVFormats).RTFormats, D.RTVFormats, sizeof(D.RTVFormats));
    D.SampleDesc := self.SampleDesc;
    D.SampleMask := self.SampleMask;
    D.CachedPSO := self.CachedPSO;
    Result := D;

end;



function TD3DX12_PIPELINE_STATE_STREAM4.ComputeDescV0(): TD3D12_COMPUTE_PIPELINE_STATE_DESC;
var
    D: TD3D12_COMPUTE_PIPELINE_STATE_DESC;
begin

    D.Flags := self.Flags;
    D.NodeMask := self.NodeMask;
    D.pRootSignature := self.pRootSignature;
    D.CS := self.Stream_CS;
    D.CachedPSO := self.CachedPSO;
    Result := D;

end;



procedure TD3DX12_PIPELINE_STATE_STREAM4.Init(Desc: TD3D12_GRAPHICS_PIPELINE_STATE_DESC);
begin
    self.Flags := Desc.Flags;
    self.NodeMask := Desc.NodeMask;
    self.pRootSignature := Desc.pRootSignature;
    self.InputLayout := Desc.InputLayout;
    self.IBStripCutValue := Desc.IBStripCutValue;
    self.PrimitiveTopologyType := Desc.PrimitiveTopologyType;
    self.Stream_VS := Desc.VS;
    self.Stream_GS := Desc.GS;
    self.StreamOutput := Desc.StreamOutput;
    self.Stream_HS := Desc.HS;
    self.Stream_DS := Desc.DS;
    self.Stream_PS := Desc.PS;
    self.BlendState := TD3D12_BLEND_DESC(Desc.BlendState);
    self.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC2(Desc.DepthStencilState);
    self.DSVFormat := Desc.DSVFormat;
    self.RasterizerState := TD3D12_RASTERIZER_DESC1(TD3D12_RASTERIZER_DESC(Desc.RasterizerState));
    self.RTVFormats.pssInner.Init(Desc.RTVFormats, Desc.NumRenderTargets);
    self.SampleDesc := Desc.SampleDesc;
    self.SampleMask := Desc.SampleMask;
    self.CachedPSO := Desc.CachedPSO;
    self.ViewInstancingDesc.pssInner.Init();
end;



procedure TD3DX12_PIPELINE_STATE_STREAM4.Init(Desc: TD3DX12_MESH_SHADER_PIPELINE_STATE_DESC);
begin
    self.Flags := Desc.Flags;
    self.NodeMask := Desc.NodeMask;
    self.pRootSignature := (Desc.pRootSignature);
    self.PrimitiveTopologyType := (Desc.PrimitiveTopologyType);
    self.Stream_PS := Desc.PS_Code;
    self.Stream_AS := Desc.AS_Code;
    self.Stream_MS := Desc.MS_Code;
    self.BlendState := TD3D12_BLEND_DESC(Desc.BlendState);
    self.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC2(Desc.DepthStencilState);
    self.DSVFormat := Desc.DSVFormat;
    self.RasterizerState := TD3D12_RASTERIZER_DESC1(Desc.RasterizerState);
    self.RTVFormats.pssInner.Init(Desc.RTVFormats, Desc.NumRenderTargets);
    self.SampleDesc := Desc.SampleDesc;
    self.SampleMask := Desc.SampleMask;
    self.CachedPSO := Desc.CachedPSO;
    self.ViewInstancingDesc.pssInner.Init();
end;



procedure TD3DX12_PIPELINE_STATE_STREAM4.Init(Desc: TD3D12_COMPUTE_PIPELINE_STATE_DESC);
begin
    self.Flags := Desc.Flags;
    self.NodeMask := Desc.NodeMask;
    self.pRootSignature := Desc.pRootSignature;
    self.Stream_CS := TD3D12_SHADER_BYTECODE(Desc.CS);
    self.CachedPSO := Desc.CachedPSO;
    self.DepthStencilState.pssInner.DepthEnable := False;
end;

{$ENDIF}

{$IFDEF D3D12_SDK_VERSION_606}

{ TD3DX12_PIPELINE_STATE_STREAM3 }

function TD3DX12_PIPELINE_STATE_STREAM3.GraphicsDescV0(): TD3D12_GRAPHICS_PIPELINE_STATE_DESC;
var
    D: TD3D12_GRAPHICS_PIPELINE_STATE_DESC;
begin
    D.Flags := self.Flags;
    D.NodeMask := self.NodeMask;
    D.pRootSignature := self.pRootSignature;
    D.InputLayout := self.InputLayout;
    D.IBStripCutValue := self.IBStripCutValue;
    D.PrimitiveTopologyType := self.PrimitiveTopologyType;
    D.VS := self.Stream_VS;
    D.GS := self.Stream_GS;
    D.StreamOutput := self.StreamOutput;
    D.HS := self.Stream_HS;
    D.DS := self.Stream_DS;
    D.PS := self.Stream_PS;
    D.BlendState := self.BlendState;
    D.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC(TD3D12_DEPTH_STENCIL_DESC2(self.DepthStencilState));
    D.DSVFormat := self.DSVFormat;
    D.RasterizerState := TD3D12_RASTERIZER_DESC(self.RasterizerState);
    D.NumRenderTargets := TD3D12_RT_FORMAT_ARRAY(self.RTVFormats).NumRenderTargets;
    Move(TD3D12_RT_FORMAT_ARRAY(self.RTVFormats).RTFormats, D.RTVFormats, sizeof(D.RTVFormats));
    D.SampleDesc := self.SampleDesc;
    D.SampleMask := self.SampleMask;
    D.CachedPSO := self.CachedPSO;
    Result := D;
end;



function TD3DX12_PIPELINE_STATE_STREAM3.ComputeDescV0(): TD3D12_COMPUTE_PIPELINE_STATE_DESC;
var
    D: TD3D12_COMPUTE_PIPELINE_STATE_DESC;
begin

    D.Flags := self.Flags;
    D.NodeMask := self.NodeMask;
    D.pRootSignature := self.pRootSignature;
    D.CS := self.Stream_CS;
    D.CachedPSO := self.CachedPSO;
    Result := D;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM3.Init(Desc: TD3D12_GRAPHICS_PIPELINE_STATE_DESC);
begin
    self.Flags := Desc.Flags;
    self.NodeMask := Desc.NodeMask;
    self.pRootSignature := Desc.pRootSignature;
    self.InputLayout := Desc.InputLayout;
    self.IBStripCutValue := Desc.IBStripCutValue;
    self.PrimitiveTopologyType := Desc.PrimitiveTopologyType;
    self.Stream_VS := Desc.VS;
    self.Stream_GS := Desc.GS;
    self.StreamOutput := Desc.StreamOutput;
    self.Stream_HS := Desc.HS;
    self.Stream_DS := Desc.DS;
    self.Stream_PS := Desc.PS;
    self.BlendState := TD3D12_BLEND_DESC(Desc.BlendState);
    self.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC2(Desc.DepthStencilState);
    self.DSVFormat := Desc.DSVFormat;
    self.RasterizerState := TD3D12_RASTERIZER_DESC(Desc.RasterizerState);
    self.RTVFormats.pssInner.Init(Desc.RTVFormats, Desc.NumRenderTargets);
    self.SampleDesc := Desc.SampleDesc;
    self.SampleMask := Desc.SampleMask;
    self.CachedPSO := Desc.CachedPSO;
    self.ViewInstancingDesc.pssInner.Init();
end;



procedure TD3DX12_PIPELINE_STATE_STREAM3.Init(Desc: TD3DX12_MESH_SHADER_PIPELINE_STATE_DESC);
begin
    self.Flags := Desc.Flags;
    self.NodeMask := Desc.NodeMask;
    self.pRootSignature := (Desc.pRootSignature);
    self.PrimitiveTopologyType := (Desc.PrimitiveTopologyType);
    self.Stream_PS := Desc.PS_Code;
    self.Stream_AS := Desc.AS_Code;
    self.Stream_MS := Desc.MS_Code;
    self.BlendState := TD3D12_BLEND_DESC(Desc.BlendState);
    self.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC2(Desc.DepthStencilState);
    self.DSVFormat := Desc.DSVFormat;
    self.RasterizerState := TD3D12_RASTERIZER_DESC(Desc.RasterizerState);
    self.RTVFormats.pssInner.Init(Desc.RTVFormats, Desc.NumRenderTargets);
    self.SampleDesc := Desc.SampleDesc;
    self.SampleMask := Desc.SampleMask;
    self.CachedPSO := Desc.CachedPSO;
    self.ViewInstancingDesc.pssInner.Init();
end;



procedure TD3DX12_PIPELINE_STATE_STREAM3.Init(Desc: TD3D12_COMPUTE_PIPELINE_STATE_DESC);
begin
    self.Flags := Desc.Flags;
    self.NodeMask := Desc.NodeMask;
    self.pRootSignature := Desc.pRootSignature;
    self.Stream_CS := TD3D12_SHADER_BYTECODE(Desc.CS);
    self.CachedPSO := Desc.CachedPSO;
    self.DepthStencilState.pssInner.DepthEnable := False;
end;
{$ENDIF}
{ TD3DX12_PIPELINE_STATE_STREAM2 }

function TD3DX12_PIPELINE_STATE_STREAM2.GraphicsDescV0(): TD3D12_GRAPHICS_PIPELINE_STATE_DESC;
var
    D: TD3D12_GRAPHICS_PIPELINE_STATE_DESC;
begin
    D.Flags := self.Flags;
    D.NodeMask := self.NodeMask;
    D.pRootSignature := self.pRootSignature;
    D.InputLayout := self.InputLayout;
    D.IBStripCutValue := self.IBStripCutValue;
    D.PrimitiveTopologyType := self.PrimitiveTopologyType;
    D.VS := self.Stream_VS;
    D.GS := self.Stream_GS;
    D.StreamOutput := self.StreamOutput;
    D.HS := self.Stream_HS;
    D.DS := self.Stream_DS;
    D.PS := self.Stream_PS;
    D.BlendState := self.BlendState;
    D.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC(TD3D12_DEPTH_STENCIL_DESC2(self.DepthStencilState));
    D.DSVFormat := self.DSVFormat;
    D.RasterizerState := TD3D12_RASTERIZER_DESC(self.RasterizerState);
    D.NumRenderTargets := TD3D12_RT_FORMAT_ARRAY(self.RTVFormats).NumRenderTargets;
    Move(TD3D12_RT_FORMAT_ARRAY(self.RTVFormats).RTFormats, D.RTVFormats, sizeof(D.RTVFormats));
    D.SampleDesc := self.SampleDesc;
    D.SampleMask := self.SampleMask;
    D.CachedPSO := self.CachedPSO;
    Result := D;
end;



function TD3DX12_PIPELINE_STATE_STREAM2.ComputeDescV0(): TD3D12_COMPUTE_PIPELINE_STATE_DESC;
var
    D: TD3D12_COMPUTE_PIPELINE_STATE_DESC;
begin

    D.Flags := self.Flags;
    D.NodeMask := self.NodeMask;
    D.pRootSignature := self.pRootSignature;
    D.CS := self.Stream_CS;
    D.CachedPSO := self.CachedPSO;
    Result := D;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM2.Init(Desc: TD3D12_GRAPHICS_PIPELINE_STATE_DESC);
begin
    self.Flags := Desc.Flags;
    self.NodeMask := Desc.NodeMask;
    self.pRootSignature := Desc.pRootSignature;
    self.InputLayout := Desc.InputLayout;
    self.IBStripCutValue := Desc.IBStripCutValue;
    self.PrimitiveTopologyType := Desc.PrimitiveTopologyType;
    self.Stream_VS := Desc.VS;
    self.Stream_GS := Desc.GS;
    self.StreamOutput := Desc.StreamOutput;
    self.Stream_HS := Desc.HS;
    self.Stream_DS := Desc.DS;
    self.Stream_PS := Desc.PS;
    self.BlendState := TD3D12_BLEND_DESC(Desc.BlendState);
    self.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC1(Desc.DepthStencilState);
    self.DSVFormat := Desc.DSVFormat;
    self.RasterizerState := TD3D12_RASTERIZER_DESC(Desc.RasterizerState);
    self.RTVFormats.pssInner.Init(Desc.RTVFormats, Desc.NumRenderTargets);
    self.SampleDesc := Desc.SampleDesc;
    self.SampleMask := Desc.SampleMask;
    self.CachedPSO := Desc.CachedPSO;
    self.ViewInstancingDesc.pssInner.Init();
end;



procedure TD3DX12_PIPELINE_STATE_STREAM2.Init(Desc: TD3DX12_MESH_SHADER_PIPELINE_STATE_DESC);
begin
    self.Flags := Desc.Flags;
    self.NodeMask := Desc.NodeMask;
    self.pRootSignature := (Desc.pRootSignature);
    self.PrimitiveTopologyType := (Desc.PrimitiveTopologyType);
    self.Stream_PS := Desc.PS_Code;
    self.Stream_AS := Desc.AS_Code;
    self.Stream_MS := Desc.MS_Code;
    self.BlendState := TD3D12_BLEND_DESC(Desc.BlendState);
    self.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC1(Desc.DepthStencilState);
    self.DSVFormat := Desc.DSVFormat;
    self.RasterizerState := TD3D12_RASTERIZER_DESC(Desc.RasterizerState);
    self.RTVFormats.pssInner.Init(Desc.RTVFormats, Desc.NumRenderTargets);
    self.SampleDesc := Desc.SampleDesc;
    self.SampleMask := Desc.SampleMask;
    self.CachedPSO := Desc.CachedPSO;
    self.ViewInstancingDesc.pssInner.Init();
end;



procedure TD3DX12_PIPELINE_STATE_STREAM2.Init(Desc: TD3D12_COMPUTE_PIPELINE_STATE_DESC);
begin
    self.Flags := Desc.Flags;
    self.NodeMask := Desc.NodeMask;
    self.pRootSignature := Desc.pRootSignature;
    self.Stream_CS := TD3D12_SHADER_BYTECODE(Desc.CS);
    self.CachedPSO := Desc.CachedPSO;
    self.DepthStencilState.pssInner.DepthEnable := False;
end;

{ TD3DX12_PIPELINE_STATE_STREAM1 }

function TD3DX12_PIPELINE_STATE_STREAM1.GraphicsDescV0(): TD3D12_GRAPHICS_PIPELINE_STATE_DESC;
var
    D: TD3D12_GRAPHICS_PIPELINE_STATE_DESC;
begin
    D.Flags := self.Flags;
    D.NodeMask := self.NodeMask;
    D.pRootSignature := self.pRootSignature;
    D.InputLayout := self.InputLayout;
    D.IBStripCutValue := self.IBStripCutValue;
    D.PrimitiveTopologyType := self.PrimitiveTopologyType;
    D.VS := self.Stream_VS;
    D.GS := self.Stream_GS;
    D.StreamOutput := self.StreamOutput;
    D.HS := self.Stream_HS;
    D.DS := self.Stream_DS;
    D.PS := self.Stream_PS;
    D.BlendState := self.BlendState;
    D.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC(TD3D12_DEPTH_STENCIL_DESC2(self.DepthStencilState));
    D.DSVFormat := self.DSVFormat;
    D.RasterizerState := TD3D12_RASTERIZER_DESC(self.RasterizerState);
    D.NumRenderTargets := TD3D12_RT_FORMAT_ARRAY(self.RTVFormats).NumRenderTargets;
    Move(TD3D12_RT_FORMAT_ARRAY(self.RTVFormats).RTFormats, D.RTVFormats, sizeof(D.RTVFormats));
    D.SampleDesc := self.SampleDesc;
    D.SampleMask := self.SampleMask;
    D.CachedPSO := self.CachedPSO;
    Result := D;
end;



function TD3DX12_PIPELINE_STATE_STREAM1.ComputeDescV0(): TD3D12_COMPUTE_PIPELINE_STATE_DESC;
var
    D: TD3D12_COMPUTE_PIPELINE_STATE_DESC;
begin

    D.Flags := self.Flags;
    D.NodeMask := self.NodeMask;
    D.pRootSignature := self.pRootSignature;
    D.CS := self.Stream_CS;
    D.CachedPSO := self.CachedPSO;
    Result := D;

end;



procedure TD3DX12_PIPELINE_STATE_STREAM1.Init(Desc: TD3D12_GRAPHICS_PIPELINE_STATE_DESC);
begin
    self.Flags := Desc.Flags;
    self.NodeMask := Desc.NodeMask;
    self.pRootSignature := Desc.pRootSignature;
    self.InputLayout := Desc.InputLayout;
    self.IBStripCutValue := Desc.IBStripCutValue;
    self.PrimitiveTopologyType := Desc.PrimitiveTopologyType;
    self.Stream_VS := Desc.VS;
    self.Stream_GS := Desc.GS;
    self.StreamOutput := Desc.StreamOutput;
    self.Stream_HS := Desc.HS;
    self.Stream_DS := Desc.DS;
    self.Stream_PS := Desc.PS;
    self.BlendState := TD3D12_BLEND_DESC(Desc.BlendState);
    self.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC1(Desc.DepthStencilState);
    self.DSVFormat := Desc.DSVFormat;
    self.RasterizerState := TD3D12_RASTERIZER_DESC(Desc.RasterizerState);
    self.RTVFormats.pssInner.Init(Desc.RTVFormats, Desc.NumRenderTargets);
    self.SampleDesc := Desc.SampleDesc;
    self.SampleMask := Desc.SampleMask;
    self.CachedPSO := Desc.CachedPSO;
    self.ViewInstancingDesc.pssInner.Init();
end;



procedure TD3DX12_PIPELINE_STATE_STREAM1.Init(Desc: TD3DX12_MESH_SHADER_PIPELINE_STATE_DESC);
begin
    self.Flags := Desc.Flags;
    self.NodeMask := Desc.NodeMask;
    self.pRootSignature := (Desc.pRootSignature);
    self.PrimitiveTopologyType := (Desc.PrimitiveTopologyType);
    self.Stream_PS := Desc.PS_Code;
    self.BlendState := TD3D12_BLEND_DESC(Desc.BlendState);
    self.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC1(Desc.DepthStencilState);
    self.DSVFormat := Desc.DSVFormat;
    self.RasterizerState := TD3D12_RASTERIZER_DESC(Desc.RasterizerState);
    self.RTVFormats.pssInner.Init(Desc.RTVFormats, Desc.NumRenderTargets);
    self.SampleDesc := Desc.SampleDesc;
    self.SampleMask := Desc.SampleMask;
    self.CachedPSO := Desc.CachedPSO;
    self.ViewInstancingDesc.pssInner.Init();
end;



procedure TD3DX12_PIPELINE_STATE_STREAM1.Init(Desc: TD3D12_COMPUTE_PIPELINE_STATE_DESC);
begin
    self.Flags := Desc.Flags;
    self.NodeMask := Desc.NodeMask;
    self.pRootSignature := Desc.pRootSignature;
    self.Stream_CS := TD3D12_SHADER_BYTECODE(Desc.CS);
    self.CachedPSO := Desc.CachedPSO;
    self.DepthStencilState.pssInner.DepthEnable := False;
end;



function TD3DX12_PIPELINE_STATE_STREAM.GraphicsDescV0(): TD3D12_GRAPHICS_PIPELINE_STATE_DESC;
var
    D: TD3D12_GRAPHICS_PIPELINE_STATE_DESC;
begin
    D.Flags := self.Flags;
    D.NodeMask := self.NodeMask;
    D.pRootSignature := self.pRootSignature;
    D.InputLayout := self.InputLayout;
    D.IBStripCutValue := self.IBStripCutValue;
    D.PrimitiveTopologyType := self.PrimitiveTopologyType;
    D.VS := self.Stream_VS;
    D.GS := self.Stream_GS;
    D.StreamOutput := self.StreamOutput;
    D.HS := self.Stream_HS;
    D.DS := self.Stream_DS;
    D.PS := self.Stream_PS;
    D.BlendState := self.BlendState;
    D.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC(TD3D12_DEPTH_STENCIL_DESC2(self.DepthStencilState));
    D.DSVFormat := self.DSVFormat;
    D.RasterizerState := TD3D12_RASTERIZER_DESC(self.RasterizerState);
    D.NumRenderTargets := TD3D12_RT_FORMAT_ARRAY(self.RTVFormats).NumRenderTargets;
    Move(TD3D12_RT_FORMAT_ARRAY(self.RTVFormats).RTFormats, D.RTVFormats, sizeof(D.RTVFormats));
    D.SampleDesc := self.SampleDesc;
    D.SampleMask := self.SampleMask;
    D.CachedPSO := self.CachedPSO;
    Result := D;

end;



function TD3DX12_PIPELINE_STATE_STREAM.ComputeDescV0(): TD3D12_COMPUTE_PIPELINE_STATE_DESC;
var
    D: TD3D12_COMPUTE_PIPELINE_STATE_DESC;
begin

    D.Flags := self.Flags;
    D.NodeMask := self.NodeMask;
    D.pRootSignature := self.pRootSignature;
    D.CS := self.Stream_CS;
    D.CachedPSO := self.CachedPSO;
    Result := D;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM.Init(Desc: TD3D12_GRAPHICS_PIPELINE_STATE_DESC);
begin
    self.Flags := Desc.Flags;
    self.NodeMask := Desc.NodeMask;
    self.pRootSignature := Desc.pRootSignature;
    self.InputLayout := Desc.InputLayout;
    self.IBStripCutValue := Desc.IBStripCutValue;
    self.PrimitiveTopologyType := Desc.PrimitiveTopologyType;
    self.Stream_VS := Desc.VS;
    self.Stream_GS := Desc.GS;
    self.StreamOutput := Desc.StreamOutput;
    self.Stream_HS := Desc.HS;
    self.Stream_DS := Desc.DS;
    self.Stream_PS := Desc.PS;
    self.BlendState := TD3D12_BLEND_DESC(Desc.BlendState);
    self.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC1(Desc.DepthStencilState);
    self.DSVFormat := Desc.DSVFormat;
    self.RasterizerState := TD3D12_RASTERIZER_DESC(Desc.RasterizerState);
    self.RTVFormats.pssInner.Init(Desc.RTVFormats, Desc.NumRenderTargets);
    self.SampleDesc := Desc.SampleDesc;
    self.SampleMask := Desc.SampleMask;
    self.CachedPSO := Desc.CachedPSO;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM.Init(Desc: TD3DX12_MESH_SHADER_PIPELINE_STATE_DESC);
begin
    self.Flags := Desc.Flags;
    self.NodeMask := Desc.NodeMask;
    self.pRootSignature := (Desc.pRootSignature);
    self.PrimitiveTopologyType := (Desc.PrimitiveTopologyType);
    self.Stream_PS := Desc.PS_Code;
    self.BlendState := TD3D12_BLEND_DESC(Desc.BlendState);
    self.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC1(Desc.DepthStencilState);
    self.DSVFormat := Desc.DSVFormat;
    self.RasterizerState := TD3D12_RASTERIZER_DESC(Desc.RasterizerState);
    self.RTVFormats.pssInner.Init(Desc.RTVFormats, Desc.NumRenderTargets);
    self.SampleDesc := Desc.SampleDesc;
    self.SampleMask := Desc.SampleMask;
    self.CachedPSO := Desc.CachedPSO;

end;



procedure TD3DX12_PIPELINE_STATE_STREAM.Init(Desc: TD3D12_COMPUTE_PIPELINE_STATE_DESC);
begin
    self.Flags := Desc.Flags;
    self.NodeMask := Desc.NodeMask;
    self.pRootSignature := Desc.pRootSignature;
    self.Stream_CS := TD3D12_SHADER_BYTECODE(Desc.CS);
    self.CachedPSO := Desc.CachedPSO;
    self.DepthStencilState.pssInner.DepthEnable := False;
end;


{ TD3DX12_PIPELINE_MESH_STATE_STREAM }

procedure TD3DX12_PIPELINE_MESH_STATE_STREAM.Init(Desc: TD3DX12_MESH_SHADER_PIPELINE_STATE_DESC);
begin
    self.Flags := Desc.Flags;
    self.NodeMask := Desc.NodeMask;
    self.pRootSignature := Desc.pRootSignature;
    self.PrimitiveTopologyType := Desc.PrimitiveTopologyType;
    self.Stream_PS := Desc.PS_Code;
    self.Stream_AS := Desc.AS_Code;
    self.Stream_MS := Desc.MS_Code;
    self.BlendState := TD3D12_BLEND_DESC(Desc.BlendState);
    self.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC1(Desc.DepthStencilState);
    self.DSVFormat := Desc.DSVFormat;
    self.RasterizerState := TD3D12_RASTERIZER_DESC(Desc.RasterizerState);
    self.RTVFormats.pssInner.Init(Desc.RTVFormats, Desc.NumRenderTargets);
    self.SampleDesc := Desc.SampleDesc;
    self.SampleMask := Desc.SampleMask;
    self.CachedPSO := Desc.CachedPSO;
    self.ViewInstancingDesc.pssInner.Init();// := TD3DX12_VIEW_INSTANCING_DESC(TD3DX12_DEFAULT());
end;



function TD3DX12_PIPELINE_MESH_STATE_STREAM.MeshShaderDescV0: TD3DX12_MESH_SHADER_PIPELINE_STATE_DESC;
var
    D: TD3DX12_MESH_SHADER_PIPELINE_STATE_DESC;
begin
    D.Flags := self.Flags;
    D.NodeMask := self.NodeMask;
    D.pRootSignature := self.pRootSignature;
    D.PrimitiveTopologyType := self.PrimitiveTopologyType;
    D.PS_Code := self.Stream_PS;
    D.AS_Code := self.Stream_AS;
    D.MS_Code := self.Stream_MS;
    D.BlendState := self.BlendState;
    D.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC(TD3D12_DEPTH_STENCIL_DESC1(self.DepthStencilState));
    D.DSVFormat := self.DSVFormat;
    D.RasterizerState := self.RasterizerState;
    D.NumRenderTargets := TD3D12_RT_FORMAT_ARRAY(self.RTVFormats).NumRenderTargets;
    move(TD3D12_RT_FORMAT_ARRAY(self.RTVFormats).RTFormats, D.RTVFormats, sizeof(D.RTVFormats));
    D.SampleDesc := self.SampleDesc;
    D.SampleMask := self.SampleMask;
    D.CachedPSO := self.CachedPSO;
    Result := D;
end;


{ TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER }

constructor TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.Create;
begin
    SeenDSS := False;
    SeenMS := False;
    SeenTopology := False;
    // Adjust defaults to account for absent members.
    PipelineStream.PrimitiveTopologyType := D3D12_PRIMITIVE_TOPOLOGY_TYPE_TRIANGLE;
    // Depth disabled if no DSV format specified.
    PipelineStream.DepthStencilState.pssInner.DepthEnable := False;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.FlagsCb(Flags: TD3D12_PIPELINE_STATE_FLAGS);
begin
    PipelineStream.Flags := Flags;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.NodeMaskCb(NodeMask: UINT);
begin
    PipelineStream.NodeMask := NodeMask;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.RootSignatureCb(pRootSignature: PID3D12RootSignature);
begin
    PipelineStream.pRootSignature.pssInner := pRootSignature;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.InputLayoutCb(InputLayout: PD3D12_INPUT_LAYOUT_DESC);
begin
    PipelineStream.InputLayout.pssInner := InputLayout^;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.IBStripCutValueCb(IBStripCutValue: TD3D12_INDEX_BUFFER_STRIP_CUT_VALUE);
begin
    PipelineStream.IBStripCutValue := IBStripCutValue;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.PrimitiveTopologyTypeCb(PrimitiveTopologyType: TD3D12_PRIMITIVE_TOPOLOGY_TYPE);
begin
    PipelineStream.PrimitiveTopologyType := PrimitiveTopologyType;
    SeenTopology := True;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.VSCb(VS_Code: PD3D12_SHADER_BYTECODE);
begin
    PipelineStream.Stream_VS.pssInner := VS_Code^;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.GSCb(GS_Code: PD3D12_SHADER_BYTECODE);
begin
    PipelineStream.Stream_GS := GS_Code^;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.StreamOutputCb(StreamOutput: PD3D12_STREAM_OUTPUT_DESC);
begin
    PipelineStream.StreamOutput := StreamOutput^;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.HSCb(HS_Code: PD3D12_SHADER_BYTECODE);
begin
    PipelineStream.Stream_HS.pssInner := HS_Code^;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.DSCb(DS_Code: PD3D12_SHADER_BYTECODE);
begin
    PipelineStream.Stream_DS := DS_Code^;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.PSCb(PS_Code: PD3D12_SHADER_BYTECODE);
begin
    PipelineStream.Stream_PS := PS_Code^;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.CSCb(CS_Code: PD3D12_SHADER_BYTECODE);
begin
    PipelineStream.Stream_CS := CS_Code^;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.ASCb(AS_Code: PD3D12_SHADER_BYTECODE);
begin
    PipelineStream.Stream_AS := AS_Code^;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.MSCb(MS_Code: PD3D12_SHADER_BYTECODE);
begin
    PipelineStream.Stream_MS := MS_Code^;
    SeenMS := True;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.BlendStateCb(BlendState: PD3D12_BLEND_DESC);
begin
    PipelineStream.BlendState.pssInner := BlendState^;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.DepthStencilStateCb(DepthStencilState: PD3D12_DEPTH_STENCIL_DESC);
begin
    {$IFDEF D3D12_SDK_VERSION_606}
    PipelineStream.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC2(DepthStencilState^);
    {$ELSE}
    PipelineStream.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC1(DepthStencilState^);
    {$ENDIF}
    SeenDSS := True;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.DepthStencilState1Cb(DepthStencilState: PD3D12_DEPTH_STENCIL_DESC1);
begin
    {$IFDEF D3D12_SDK_VERSION_606}
    PipelineStream.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC2(DepthStencilState^);
    {$ELSE}
    PipelineStream.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC1(DepthStencilState^);
    {$ENDIF}
    SeenDSS := True;
end;


{$IFDEF D3D12_SDK_VERSION_606}
procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.DepthStencilState2Cb(DepthStencilState: PD3D12_DEPTH_STENCIL_DESC2);
begin
    PipelineStream.DepthStencilState := TD3D12_DEPTH_STENCIL_DESC2(DepthStencilState^);
    SeenDSS := True;
end;
{$ENDIF}


procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.DSVFormatCb(DSVFormat: TDXGI_FORMAT);
begin
    PipelineStream.DSVFormat := DSVFormat;

    if not SeenDSS and (DSVFormat <> DXGI_FORMAT_UNKNOWN) then
    begin
        // Re-enable depth for the default state.
        PipelineStream.DepthStencilState.pssInner.DepthEnable := True;
    end;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.RasterizerStateCb(RasterizerState: PD3D12_RASTERIZER_DESC);
begin
    {$IFDEF D3D12_SDK_VERSION_613}
    PipelineStream.RasterizerState := TD3D12_RASTERIZER_DESC2(RasterizerState^);
    {$ELSE}
    {$IFDEF D3D12_SDK_VERSION_608}
    PipelineStream.RasterizerState := TD3D12_RASTERIZER_DESC1(RasterizerState^);
    {$ELSE}
    PipelineStream.RasterizerState := TD3D12_RASTERIZER_DESC(RasterizerState^);
    {$ENDIF}
    {$ENDIF}
end;


{$IFDEF D3D12_SDK_VERSION_608}
procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.RasterizerState1Cb(RasterizerState: PD3D12_RASTERIZER_DESC1);
begin
    {$IFDEF D3D12_SDK_VERSION_613}
    PipelineStream.RasterizerState := TD3D12_RASTERIZER_DESC2(RasterizerState^);
    {$ELSE}
    PipelineStream.RasterizerState := TD3D12_RASTERIZER_DESC1(RasterizerState^);
    {$ENDIF}
end;
{$ENDIF}

{$IFDEF D3D12_SDK_VERSION_610}
procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.RasterizerState2Cb(RasterizerState: PD3D12_RASTERIZER_DESC2);
begin
    PipelineStream.RasterizerState := TD3D12_RASTERIZER_DESC2(RasterizerState^);
end;
{$ENDIF}


procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.RTVFormatsCb(RTVFormats: PD3D12_RT_FORMAT_ARRAY);
begin
    PipelineStream.RTVFormats := RTVFormats^;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.SampleDescCb(SampleDesc: PDXGI_SAMPLE_DESC);
begin
    PipelineStream.SampleDesc := SampleDesc^;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.SampleMaskCb(SampleMask: UINT);
begin
    PipelineStream.SampleMask := SampleMask;
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.ViewInstancingCb(ViewInstancingDesc: PD3D12_VIEW_INSTANCING_DESC);
begin
    PipelineStream.ViewInstancingDesc := TD3D12_VIEW_INSTANCING_DESC(ViewInstancingDesc^);
end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.CachedPSOCb(CachedPSO: PD3D12_CACHED_PIPELINE_STATE);
begin
    PipelineStream.CachedPSO := CachedPSO^;
end;


{$IFDEF D3D12_SDK_VERSION_618}
procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.SerializedRootSignatureCb(SerializedRootSignature: PD3D12_SERIALIZED_ROOT_SIGNATURE_DESC);
begin
    PipelineStream.SerializedRootSignature := TD3D12_SERIALIZED_ROOT_SIGNATURE_DESC(SerializedRootSignature^);
end;
{$ENDIF}


procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.ErrorBadInputParameter(Nameless1: UINT);
begin

end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.ErrorDuplicateSubobject(Nameless1: TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE);
begin

end;



procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.ErrorUnknownSubobject(Nameless1: UINT);
begin

end;


{$IFDEF D3D12_SDK_VERSION_613}
procedure TD3DX12_PIPELINE_STATE_STREAM6_PARSE_HELPER.FinalizeCb();
begin
    if (not SeenDSS and (PipelineStream.DSVFormat.pssInner <> DXGI_FORMAT_UNKNOWN)) then
    begin
        // Re-enable depth for the default state.
        PipelineStream.DepthStencilState.pssInner.DepthEnable := True;
    end;
    if (not SeenTopology and SeenMS) then
    begin
        PipelineStream.PrimitiveTopologyType := D3D12_PRIMITIVE_TOPOLOGY_TYPE_UNDEFINED;
    end;
end;
{$ENDIF}


end.
