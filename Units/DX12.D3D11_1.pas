unit DX12.D3D11_1;

{$IFDEF FPC}
{$MODE delphi}{$H+}
{$ENDIF}

interface
{$Z4}

uses
    Windows, Classes, SysUtils,
    DX12.DXGI, DX12.D3D11,
    DX12.D3DCommon;

const

    IID_ID3D11BlendState1: TGUID = '{cc86fabe-da55-401d-85e7-e3c9de2877e9}';
    IID_ID3D11RasterizerState1: TGUID = '{1217d7a6-5039-418c-b042-9cbe256afd6e}';
    IID_ID3DDeviceContextState: TGUID = '{5c1e0d8a-7c23-48f9-8c59-a92958ceff11}';
    IID_ID3D11DeviceContext1: TGUID = '{bb2c6faa-b5fb-4082-8e6b-388b8cfa90e1}';
    IID_ID3D11Device1: TGUID = '{a04bfb29-08ef-43d6-a49c-a9bdbdcbe686}';
    IID_ID3DUserDefinedAnnotation: TGUID = '{b2daad8b-03d4-4dbf-95eb-32ab4b63d0ab}';

type
    TD3D11_COPY_FLAGS = (
        D3D11_COPY_NO_OVERWRITE = $1,
        D3D11_COPY_DISCARD = $2
        );

    TD3D11_LOGIC_OP = (
        D3D11_LOGIC_OP_CLEAR = 0,
        D3D11_LOGIC_OP_SET = (D3D11_LOGIC_OP_CLEAR + 1),
        D3D11_LOGIC_OP_COPY = (D3D11_LOGIC_OP_SET + 1),
        D3D11_LOGIC_OP_COPY_INVERTED = (D3D11_LOGIC_OP_COPY + 1),
        D3D11_LOGIC_OP_NOOP = (D3D11_LOGIC_OP_COPY_INVERTED + 1),
        D3D11_LOGIC_OP_INVERT = (D3D11_LOGIC_OP_NOOP + 1),
        D3D11_LOGIC_OP_AND = (D3D11_LOGIC_OP_INVERT + 1),
        D3D11_LOGIC_OP_NAND = (D3D11_LOGIC_OP_AND + 1),
        D3D11_LOGIC_OP_OR = (D3D11_LOGIC_OP_NAND + 1),
        D3D11_LOGIC_OP_NOR = (D3D11_LOGIC_OP_OR + 1),
        D3D11_LOGIC_OP_XOR = (D3D11_LOGIC_OP_NOR + 1),
        D3D11_LOGIC_OP_EQUIV = (D3D11_LOGIC_OP_XOR + 1),
        D3D11_LOGIC_OP_AND_REVERSE = (D3D11_LOGIC_OP_EQUIV + 1),
        D3D11_LOGIC_OP_AND_INVERTED = (D3D11_LOGIC_OP_AND_REVERSE + 1),
        D3D11_LOGIC_OP_OR_REVERSE = (D3D11_LOGIC_OP_AND_INVERTED + 1),
        D3D11_LOGIC_OP_OR_INVERTED = (D3D11_LOGIC_OP_OR_REVERSE + 1)
        );

    TD3D11_RENDER_TARGET_BLEND_DESC1 = record
        BlendEnable: longbool;
        LogicOpEnable: longbool;
        SrcBlend: TD3D11_BLEND;
        DestBlend: TD3D11_BLEND;
        BlendOp: TD3D11_BLEND_OP;
        SrcBlendAlpha: TD3D11_BLEND;
        DestBlendAlpha: TD3D11_BLEND;
        BlendOpAlpha: TD3D11_BLEND_OP;
        LogicOp: TD3D11_LOGIC_OP;
        RenderTargetWriteMask: UINT8;
    end;

    { TD3D11_BLEND_DESC1 }

    TD3D11_BLEND_DESC1 = record
        AlphaToCoverageEnable: longbool;
        IndependentBlendEnable: longbool;
        RenderTarget: array[0..7] of TD3D11_RENDER_TARGET_BLEND_DESC1;
        procedure Init;
    end;
    PD3D11_BLEND_DESC1 = ^TD3D11_BLEND_DESC1;

    ID3D11BlendState1 = interface(ID3D11BlendState)
        ['{cc86fabe-da55-401d-85e7-e3c9de2877e9}']
        procedure GetDesc1(out pDesc: TD3D11_BLEND_DESC1); stdcall;
    end;

    { TD3D11_RASTERIZER_DESC1 }

    TD3D11_RASTERIZER_DESC1 = record
        FillMode: TD3D11_FILL_MODE;
        CullMode: TD3D11_CULL_MODE;
        FrontCounterClockwise: longbool;
        DepthBias: integer;
        DepthBiasClamp: single;
        SlopeScaledDepthBias: single;
        DepthClipEnable: longbool;
        ScissorEnable: longbool;
        MultisampleEnable: longbool;
        AntialiasedLineEnable: longbool;
        ForcedSampleCount: UINT;
        procedure Init; overload;
        procedure Init(AFillMode: TD3D11_FILL_MODE; ACullMode: TD3D11_CULL_MODE; AFrontCounterClockwise: BOOL;
                ADepthBias: integer; ADepthBiasClamp: single; ASlopeScaledDepthBias: single; ADepthClipEnable: longbool;
                AScissorEnable: longbool; AMultisampleEnable: longbool; AAntialiasedLineEnable: longbool;
                AForcedSampleCount: UINT); overload;
    end;

    PD3D11_RASTERIZER_DESC1 = ^TD3D11_RASTERIZER_DESC1;

    ID3D11RasterizerState1 = interface(ID3D11RasterizerState)
        ['{1217d7a6-5039-418c-b042-9cbe256afd6e}']
        procedure GetDesc1(out pDesc: TD3D11_RASTERIZER_DESC1); stdcall;
    end;


    TD3D11_1_CREATE_DEVICE_CONTEXT_STATE_FLAG = (
        D3D11_1_CREATE_DEVICE_CONTEXT_STATE_SINGLETHREADED = $1
        );

    ID3DDeviceContextState = interface(ID3D11DeviceChild)
        ['{5c1e0d8a-7c23-48f9-8c59-a92958ceff11}']
    end;


    ID3D11DeviceContext1 = interface(ID3D11DeviceContext)
        ['{bb2c6faa-b5fb-4082-8e6b-388b8cfa90e1}']
        procedure CopySubresourceRegion1(pDstResource: ID3D11Resource; DstSubresource: UINT; DstX: UINT;
            DstY: UINT; DstZ: UINT; pSrcResource: ID3D11Resource; SrcSubresource: UINT; pSrcBox: PD3D11_BOX; CopyFlags: UINT); stdcall;
        procedure UpdateSubresource1(pDstResource: ID3D11Resource; DstSubresource: UINT; pDstBox: PD3D11_BOX;
            pSrcData: pointer; SrcRowPitch: UINT; SrcDepthPitch: UINT; CopyFlags: UINT); stdcall;
        procedure DiscardResource(pResource: ID3D11Resource); stdcall;
        procedure DiscardView(pResourceView: ID3D11View); stdcall;
        procedure VSSetConstantBuffers1(StartSlot: UINT; NumBuffers: UINT; ppConstantBuffers: PID3D11Buffer;
            pFirstConstant: PUINT; pNumConstants: PUINT); stdcall;
        procedure HSSetConstantBuffers1(StartSlot: UINT; NumBuffers: UINT; ppConstantBuffers: PID3D11Buffer;
            pFirstConstant: PUINT; pNumConstants: PUINT); stdcall;
        procedure DSSetConstantBuffers1(StartSlot: UINT; NumBuffers: UINT; ppConstantBuffers: PID3D11Buffer;
            pFirstConstant: PUINT; pNumConstants: PUINT); stdcall;
        procedure GSSetConstantBuffers1(StartSlot: UINT; NumBuffers: UINT; ppConstantBuffers: PID3D11Buffer;
            pFirstConstant: PUINT; pNumConstants: PUINT); stdcall;
        procedure PSSetConstantBuffers1(StartSlot: UINT; NumBuffers: UINT; ppConstantBuffers: PID3D11Buffer;
            pFirstConstant: PUINT; pNumConstants: PUINT); stdcall;
        procedure CSSetConstantBuffers1(StartSlot: UINT; NumBuffers: UINT; ppConstantBuffers: PID3D11Buffer;
            pFirstConstant: PUINT; pNumConstants: PUINT); stdcall;
        procedure VSGetConstantBuffers1(StartSlot: UINT; NumBuffers: UINT; out ppConstantBuffers: PID3D11Buffer;
            out pFirstConstant: PUINT; out pNumConstants: PUINT); stdcall;
        procedure HSGetConstantBuffers1(StartSlot: UINT; NumBuffers: UINT; out ppConstantBuffers: PID3D11Buffer;
            out pFirstConstant: PUINT; out pNumConstants: PUINT); stdcall;
        procedure DSGetConstantBuffers1(StartSlot: UINT; NumBuffers: UINT; out ppConstantBuffers: PID3D11Buffer;
            out pFirstConstant: PUINT; out pNumConstants: PUINT); stdcall;
        procedure GSGetConstantBuffers1(StartSlot: UINT; NumBuffers: UINT; out ppConstantBuffers: PID3D11Buffer;
            out pFirstConstant: PUINT; out pNumConstants: PUINT); stdcall;
        procedure PSGetConstantBuffers1(StartSlot: UINT; NumBuffers: UINT; out ppConstantBuffers: PID3D11Buffer;
            out pFirstConstant: PUINT; out pNumConstants: PUINT); stdcall;
        procedure CSGetConstantBuffers1(StartSlot: UINT; NumBuffers: UINT; out ppConstantBuffers: PID3D11Buffer;
            out pFirstConstant: PUINT; out pNumConstants: PUINT); stdcall;
        procedure SwapDeviceContextState(pState: ID3DDeviceContextState; out ppPreviousState: ID3DDeviceContextState); stdcall;
        procedure ClearView(pView: ID3D11View; Color: TFloatArray4; pRect: PD3D11_RECT; NumRects: UINT); stdcall;
        procedure DiscardView1(pResourceView: ID3D11View; pRects: PD3D11_RECT; NumRects: UINT); stdcall;
    end;


    ID3D11Device1 = interface(ID3D11Device)
        ['{a04bfb29-08ef-43d6-a49c-a9bdbdcbe686}']
        procedure GetImmediateContext1(out ppImmediateContext: ID3D11DeviceContext1); stdcall;
        function CreateDeferredContext1(ContextFlags: UINT; out ppDeferredContext: ID3D11DeviceContext1): HResult; stdcall;
        function CreateBlendState1(pBlendStateDesc: PD3D11_BLEND_DESC1; out ppBlendState: ID3D11BlendState1): HResult; stdcall;
        function CreateRasterizerState1(pRasterizerDesc: PD3D11_RASTERIZER_DESC1;
            out ppRasterizerState: ID3D11RasterizerState1): HResult; stdcall;
        function CreateDeviceContextState(Flags: UINT; pFeatureLevels: PD3D_FEATURE_LEVEL; FeatureLevels: UINT;
            SDKVersion: UINT; EmulatedInterface: TGUID; out pChosenFeatureLevel: TD3D_FEATURE_LEVEL;
            out ppContextState: ID3DDeviceContextState): HResult; stdcall;
        function OpenSharedResource1(hResource: THANDLE; const returnedInterface: TGUID; out ppResource{: pointer}): HResult; stdcall;
        function OpenSharedResourceByName(lpName: PWideChar; dwDesiredAccess: DWORD; returnedInterface: TGUID;
            out ppResource: Pointer): HResult; stdcall;
    end;


    ID3DUserDefinedAnnotation = interface(IUnknown)
        ['{b2daad8b-03d4-4dbf-95eb-32ab4b63d0ab}']
        function BeginEvent(Name: PWideChar): integer; stdcall;
        function EndEvent(): integer; stdcall;
        procedure SetMarker(Name: PWideChar); stdcall;
        function GetStatus(): longbool; stdcall;
    end;


function defaultRenderTargetBlendDesc: TD3D11_RENDER_TARGET_BLEND_DESC1;


implementation



function defaultRenderTargetBlendDesc: TD3D11_RENDER_TARGET_BLEND_DESC1;
begin
    Result.BlendEnable := False;
    Result.LogicOpEnable := False;
    Result.SrcBlend := D3D11_BLEND_ONE;
    Result.DestBlend := D3D11_BLEND_ZERO;
    Result.BlendOp := D3D11_BLEND_OP_ADD;
    Result.SrcBlendAlpha := D3D11_BLEND_ONE;
    Result.DestBlendAlpha := D3D11_BLEND_ZERO;
    Result.BlendOpAlpha := D3D11_BLEND_OP_ADD;
    Result.LogicOp := D3D11_LOGIC_OP_NOOP;
    Result.RenderTargetWriteMask := Ord(D3D11_COLOR_WRITE_ENABLE_ALL);
end;

{ TD3D11_RASTERIZER_DESC1 }

procedure TD3D11_RASTERIZER_DESC1.Init;
begin
    FillMode := D3D11_FILL_SOLID;
    CullMode := D3D11_CULL_BACK;
    FrontCounterClockwise := False;
    DepthBias := D3D11_DEFAULT_DEPTH_BIAS;
    DepthBiasClamp := D3D11_DEFAULT_DEPTH_BIAS_CLAMP;
    SlopeScaledDepthBias := D3D11_DEFAULT_SLOPE_SCALED_DEPTH_BIAS;
    DepthClipEnable := True;
    ScissorEnable := False;
    MultisampleEnable := False;
    AntialiasedLineEnable := False;
    ForcedSampleCount := 0;
end;



procedure TD3D11_RASTERIZER_DESC1.Init(AFillMode: TD3D11_FILL_MODE; ACullMode: TD3D11_CULL_MODE; AFrontCounterClockwise: BOOL;
    ADepthBias: integer; ADepthBiasClamp: single; ASlopeScaledDepthBias: single; ADepthClipEnable: longbool;
    AScissorEnable: longbool; AMultisampleEnable: longbool; AAntialiasedLineEnable: longbool; AForcedSampleCount: UINT);
begin
    FillMode := AfillMode;
    CullMode := AcullMode;
    FrontCounterClockwise := AfrontCounterClockwise;
    DepthBias := AdepthBias;
    DepthBiasClamp := AdepthBiasClamp;
    SlopeScaledDepthBias := AslopeScaledDepthBias;
    DepthClipEnable := AdepthClipEnable;
    ScissorEnable := AscissorEnable;
    MultisampleEnable := AmultisampleEnable;
    AntialiasedLineEnable := antialiasedLineEnable;
    ForcedSampleCount := AforcedSampleCount;
end;

{ TD3D11_BLEND_DESC1 }

procedure TD3D11_BLEND_DESC1.Init;
var
    i: uint;
begin
    AlphaToCoverageEnable := False;
    IndependentBlendEnable := False;
    for i := 0 to D3D11_SIMULTANEOUS_RENDER_TARGET_COUNT - 1 do
    begin
        RenderTarget[i] := defaultRenderTargetBlendDesc;
    end;
end;

end.











































































































































































































