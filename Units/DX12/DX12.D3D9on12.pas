unit DX12.D3D9on12;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D9,
    DX12.D3D12;

    {$Z4}

    // include this file content only if compiling for DX9 interfaces

const
    MAX_D3D9ON12_QUEUES = 2;
    IID_IDirect3DDevice9On12: TGUID = '{E7FDA234-B589-4049-940D-8878977531C8}';


type


    _D3D9ON12_ARGS = record
        Enable9On12: boolean;
        pD3D12Device: PIUnknown;
        ppD3D12Queues: array [0..MAX_D3D9ON12_QUEUES - 1] of PIUnknown;
        NumQueues: UINT;
        NodeMask: UINT;
    end;
    TD3D9ON12_ARGS = _D3D9ON12_ARGS;
    PD3D9ON12_ARGS = ^TD3D9ON12_ARGS;


    IDirect3DDevice9On12 = interface(IUnknown)
        ['{E7FDA234-B589-4049-940D-8878977531C8}']
        (*** IDirect3DDevice9On12 methods ***)
        function GetD3D12Device(riid: REFIID;
        {out}    ppvDevice: pointer): HRESULT; stdcall;

        function UnwrapUnderlyingResource(pResource: IDirect3DResource9; pCommandQueue: ID3D12CommandQueue; riid: REFIID; {out} ppvResource12: pointer): HRESULT; stdcall;

        function ReturnUnderlyingResource(pResource: IDirect3DResource9; NumSync: UINT; pSignalValues: PUINT64; {out} ppFences: PID3D12Fence): HRESULT; stdcall;

    end;


(*
 * Entry point interfaces for creating a IDirect3D9 with 9On12 arguments
 *)

    PFN_Direct3DCreate9On12Ex = function(SDKVersion: UINT; pOverrideList: PD3D9ON12_ARGS; NumOverrideEntries: UINT; ppOutputInterface: PIDirect3D9Ex): HRESULT; stdcall;
    PFN_Direct3DCreate9On12 = function(SDKVersion: UINT; pOverrideList: PD3D9ON12_ARGS; NumOverrideEntries: UINT): HRESULT; stdcall;


function Direct3DCreate9On12Ex(SDKVersion: UINT; pOverrideList: PD3D9ON12_ARGS; NumOverrideEntries: UINT; ppOutputInterface: PIDirect3D9Ex): HRESULT; stdcall; external;


function Direct3DCreate9On12(SDKVersion: UINT; pOverrideList: PD3D9ON12_ARGS; NumOverrideEntries: UINT): IDirect3D9; stdcall; external;


implementation

end.
