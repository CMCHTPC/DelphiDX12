unit DX12.D3D11On12;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

{$Z4}

uses
    Windows, Classes, SysUtils, DX12.D3D12, DX12.D3D11, DX12.D3DCommon;

const
	D3D11_DLL = 'd3d11.dll';
    IID_ID3D11On12Device: TGUID = '{85611e73-70a9-490e-9614-a9e302777904}';

type
    TD3D11_RESOURCE_FLAGS = record
        BindFlags: UINT;
        MiscFlags: UINT;
        CPUAccessFlags: UINT;
        StructureByteStride: UINT;
    end;


    ID3D11On12Device = interface(IUnknown)
        ['{85611e73-70a9-490e-9614-a9e302777904}']
        function CreateWrappedResource(pResource12: IUnknown; const pFlags11: TD3D11_RESOURCE_FLAGS;
            InState: TD3D12_RESOURCE_STATES; OutState: TD3D12_RESOURCE_STATES; const riid: TGUID; out ppResource11): HResult; stdcall;
        procedure ReleaseWrappedResources(ppResources: PID3D11Resource; NumResources: UINT); stdcall;
        procedure AcquireWrappedResources(ppResources: PID3D11Resource; NumResources: UINT); stdcall;
    end;


///////////////////////////////////////////////////////////////////////////
// D3D11On12CreateDevice
// ------------------

// pDevice
//      Specifies a pre-existing D3D12 device to use for D3D11 interop.
//      May not be NULL.
// Flags
//      Any of those documented for D3D11CreateDeviceAndSwapChain.
// pFeatureLevels
//      Array of any of the following:
//          D3D_FEATURE_LEVEL_12_1
//          D3D_FEATURE_LEVEL_12_0
//          D3D_FEATURE_LEVEL_11_1
//          D3D_FEATURE_LEVEL_11_0
//          D3D_FEATURE_LEVEL_10_1
//          D3D_FEATURE_LEVEL_10_0
//          D3D_FEATURE_LEVEL_9_3
//          D3D_FEATURE_LEVEL_9_2
//          D3D_FEATURE_LEVEL_9_1
//       The first feature level which is less than or equal to the
//       D3D12 device's feature level will be used to perform D3D11 validation.
//       Creation will fail if no acceptable feature levels are provided.
//       Providing NULL will default to the D3D12 device's feature level.
// FeatureLevels
//      Size of feature levels array.
// ppCommandQueues
//      Array of unique queues for D3D11On12 to use. Valid queue types:
//          3D command queue.
//      Flags must be compatible with device flags, and its NodeMask must
//      be a subset of the NodeMask provided to this API.
// NumQueues
//      Size of command queue array.
// NodeMask
//      Which node of the D3D12 device to use.  Only 1 bit may be set.
// ppDevice
//      Pointer to returned interface. May be NULL.
// ppImmediateContext
//      Pointer to returned interface. May be NULL.
// pChosenFeatureLevel
//      Pointer to returned feature level. May be NULL.

// Return Values
//  Any of those documented for
//          D3D11CreateDevice

///////////////////////////////////////////////////////////////////////////

function D3D11On12CreateDevice(pDevice: IUnknown; Flags: UINT; pFeatureLevels: PD3D_FEATURE_LEVEL; FeatureLevels: UINT;
    ppCommandQueues: PIUnknown; NumQueues: UINT; NodeMask: UINT; out ppDevice: ID3D11Device; out ppImmediateContext: ID3D11DeviceContext;
    out pChosenFeatureLevel: TD3D_FEATURE_LEVEL): HResult; stdcall; external D3D11_DLL;


implementation

end.


























