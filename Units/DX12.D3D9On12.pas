unit DX12.D3D9On12;

(*==========================================================================;
 *
 *  Copyright (C) Microsoft Corporation.  All Rights Reserved.
 *
 *  File:   d3d9on12.h
 *  Content:    Direct3D include file
 *
 ****************************************************************************)

interface


uses
  Windows, DX12.D3D9,
  DX12.D3D12;

const
  DLL = 'd3d9on12.dll';

const
  MAX_D3D9ON12_QUEUES = 2;

  IID_IDirect3DDevice9On12: TGUID = '{e7fda234-b589-4049-940d-8878977531c8}';

type

  TD3D9ON12_ARGS = record
    Enable9On12: boolean;
    pD3D12Device: IUnknown;
    ppD3D12Queues: array [0..MAX_D3D9ON12_QUEUES - 1] of IUnknown;
    NumQueues: UINT;
    NodeMask: UINT;
  end;
  PD3D9ON12_ARGS = ^TD3D9ON12_ARGS;




  IDirect3DDevice9On12 = interface(IUnknown)
    ['{e7fda234-b589-4049-940d-8878977531c8}']
    (*** IDirect3DDevice9On12 methods ***)
    function GetD3D12Device(const riid: TGUID; out ppvDevice): HResult; stdcall;
    function UnwrapUnderlyingResource(pResource: IDirect3DResource9; pCommandQueue: ID3D12CommandQueue; const riid: TGUID;
      out ppvResource12): HResult; stdcall;
    function ReturnUnderlyingResource(pResource: IDirect3DResource9; NumSync: UINT; pSignalValues {NumSync}: PUINT64;
      ppFences {NumSync}: PID3D12Fence): HResult; stdcall;
  end;

(* Entry point interfaces for creating a IDirect3D9 with 9On12 arguments *)


function Direct3DCreate9On12Ex(SDKVersion: UINT; pOverrideList: PD3D9ON12_ARGS; NumOverrideEntries: UINT;
  out ppOutputInterface: IDirect3D9Ex): HResult; stdcall; external DLL;


function Direct3DCreate9On12(SDKVersion: UINT; pOverrideList: PD3D9ON12_ARGS; NumOverrideEntries: UINT): IDirect3D9; stdcall; external DLL;



implementation

end.



