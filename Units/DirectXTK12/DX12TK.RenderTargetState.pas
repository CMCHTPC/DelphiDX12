//--------------------------------------------------------------------------------------
// File: RenderTargetState.h

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------
unit DX12TK.RenderTargetState;

{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}


interface

uses
    Windows, Classes, SysUtils,
    DX12.D3DCommon,
    DX12.DCommon,
    DX12.DXGICommon,
    DX12.DXGIFormat,
    DX12.DXGIType,
    DX12.DXGI,
    DX12.D3D12,
    DX12.DXGI1_2;

type
    // Encapsulates all render target state when creating pipeline state objects

    { TRenderTargetState }

    TRenderTargetState = record
        sampleMask: uint32;
        numRenderTargets: uint32;
        rtvFormats: array [0..D3D12_SIMULTANEOUS_RENDER_TARGET_COUNT - 1] of TDXGI_FORMAT;
        dsvFormat: TDXGI_FORMAT;
        sampleDesc: TDXGI_SAMPLE_DESC;
        nodeMask: uint32;
        class operator Initialize(var aRec: TRenderTargetState);
        // Single render target convenience constructor
        constructor Create({_In_ } rtFormat: TDXGI_FORMAT;{_In_ } dsFormat: TDXGI_FORMAT);
        // MSAA single render target convenience constructor
        constructor Create({_In_ } rtFormat: TDXGI_FORMAT; {_In_ } dsFormat: TDXGI_FORMAT; {_In_ } sampleCount: uint32;{_In_ } quality: uint32 = 0);
        // Convenience constructors converting from DXGI_SWAPCHAIN_DESC
        constructor Create({_In_ } desc: PDXGI_SWAP_CHAIN_DESC;{_In_ } dsFormat: TDXGI_FORMAT);
        constructor Create({_In_ } desc: PDXGI_SWAP_CHAIN_DESC1;{_In_ } dsFormat: TDXGI_FORMAT);
    end;
    PRenderTargetState = ^TRenderTargetState;

implementation

{ TRenderTargetState }

class operator TRenderTargetState.Initialize(var aRec: TRenderTargetState);
var
    i: integer;
begin
    aRec.sampleMask := uint32(not (0));
    aRec.numRenderTargets := 0;
    for i := 0 to Length(aRec.rtvFormats) - 1 do
        aRec.rtvFormats[i] := DXGI_FORMAT_UNKNOWN;
    aRec.dsvFormat := DXGI_FORMAT_UNKNOWN;
    aRec.sampleDesc.Init;
    aRec.nodeMask := 0;
end;



constructor TRenderTargetState.Create(rtFormat: TDXGI_FORMAT; dsFormat: TDXGI_FORMAT);
begin
    self.sampleMask := UINT_MAX;
    self.numRenderTargets := 1;
    self.dsvFormat := dsFormat;
    self.nodeMask := 0;
    self.sampleDesc.Count := 1;
    self.rtvFormats[0] := rtFormat;
end;



constructor TRenderTargetState.Create(rtFormat: TDXGI_FORMAT; dsFormat: TDXGI_FORMAT; sampleCount: uint32; quality: uint32);
begin
    self.sampleMask := UINT_MAX;
    self.numRenderTargets := 1;
    self.dsvFormat := dsFormat;
    self.sampleDesc.Init(sampleCount, quality);
    self.nodeMask := 0;
    self.rtvFormats[0] := rtFormat;
end;



constructor TRenderTargetState.Create(desc: PDXGI_SWAP_CHAIN_DESC; dsFormat: TDXGI_FORMAT);
begin
    self.sampleMask := UINT_MAX;
    self.numRenderTargets := 1;
    self.dsvFormat := dsFormat;
    self.nodeMask := 0;
    self.rtvFormats[0] := desc^.BufferDesc.Format;
    self.sampleDesc := desc^.SampleDesc;
end;

constructor TRenderTargetState.Create(desc: PDXGI_SWAP_CHAIN_DESC1;
  dsFormat: TDXGI_FORMAT);
begin
     self.sampleMask := UINT_MAX;
    self.numRenderTargets := 1;
    self.dsvFormat := dsFormat;
    self.nodeMask := 0;
    self.rtvFormats[0] := desc^.Format;
    self.sampleDesc := desc^.SampleDesc;
end;

end.
