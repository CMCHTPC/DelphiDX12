unit DX12.D3D11on12;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}


interface

uses
    Windows, Classes, SysUtils,
    DX12.D3DCommon,
    DX12.D3D12,
    DX12.D3D11;

    {$Z4}

const
    D3D11_DLL = 'D3D11.dll';

    IID_ID3D11On12Device: TGUID = '{85611E73-70A9-490E-9614-A9E302777904}';
    IID_ID3D11On12Device1: TGUID = '{BDB64DF4-EA2F-4C70-B861-AAAB1258BB5D}';
    IID_ID3D11On12Device2: TGUID = '{DC90F331-4740-43FA-866E-67F12CB58223}';


type


    (* Forward Declarations *)


    ID3D11On12Device = interface;
    PID3D11On12Device = ^ID3D11On12Device;


    ID3D11On12Device1 = interface;
    PID3D11On12Device1 = ^ID3D11On12Device1;


    ID3D11On12Device2 = interface;
    PID3D11On12Device2 = ^ID3D11On12Device2;


    TD3D11_RESOURCE_FLAGS = record
        BindFlags: UINT;
        MiscFlags: UINT;
        CPUAccessFlags: UINT;
        StructureByteStride: UINT;
    end;
    PD3D11_RESOURCE_FLAGS = ^TD3D11_RESOURCE_FLAGS;


    ID3D11On12Device = interface(IUnknown)
        ['{85611e73-70a9-490e-9614-a9e302777904}']
        function CreateWrappedResource(
        {_In_  } pResource12: IUnknown;
        {_In_  } pFlags11: PD3D11_RESOURCE_FLAGS; InState: TD3D12_RESOURCE_STATES; OutState: TD3D12_RESOURCE_STATES; riid: REFIID;
        {_COM_Outptr_opt_  }  out ppResource11): HRESULT; stdcall;

        procedure ReleaseWrappedResources(
        {_In_reads_( NumResources )  } ppResources: PID3D11Resource; NumResources: UINT); stdcall;

        procedure AcquireWrappedResources(
        {_In_reads_( NumResources )  } ppResources: PID3D11Resource; NumResources: UINT); stdcall;

    end;


    ID3D11On12Device1 = interface(ID3D11On12Device)
        ['{bdb64df4-ea2f-4c70-b861-aaab1258bb5d}']
        function GetD3D12Device(riid: REFIID;
        {_COM_Outptr_  }  out ppvDevice): HRESULT; stdcall;

    end;


    ID3D11On12Device2 = interface(ID3D11On12Device1)
        ['{dc90f331-4740-43fa-866e-67f12cb58223}']
        function UnwrapUnderlyingResource(
        {_In_  } pResource11: ID3D11Resource;
        {_In_  } pCommandQueue: ID3D12CommandQueue; riid: REFIID;
        {_COM_Outptr_  }  out ppvResource12): HRESULT; stdcall;

        function ReturnUnderlyingResource(
        {_In_  } pResource11: ID3D11Resource; NumSync: UINT;
        {_In_reads_(NumSync)   } pSignalValues: PUINT64;
        {_In_reads_(NumSync)   } ppFences: PID3D12Fence): HRESULT; stdcall;

    end;

    PFN_D3D11ON12_CREATE_DEVICE = function(
        {_In_ } pDevice: IUnknown; Flags: UINT;
        {_In_reads_opt_( FeatureLevels ) } pFeatureLevels: PD3D_FEATURE_LEVEL; FeatureLevels: UINT;
        {_In_reads_opt_( NumQueues ) } ppCommandQueues: PIUnknown; NumQueues: UINT; NodeMask: UINT;
        {_COM_Outptr_opt_ }  out ppDevice: ID3D11Device;
        {_COM_Outptr_opt_ }  out ppImmediateContext: ID3D11DeviceContext;
        {_Out_opt_ } pChosenFeatureLevel: PD3D_FEATURE_LEVEL): HRESULT; stdcall;


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


function D3D11On12CreateDevice(
    {_In_ } pDevice: IUnknown; Flags: UINT;
    {_In_reads_opt_( FeatureLevels ) } pFeatureLevels: PD3D_FEATURE_LEVEL; FeatureLevels: UINT;
    {_In_reads_opt_( NumQueues ) } ppCommandQueues: PIUnknown ; NumQueues: UINT; NodeMask: UINT;
    {_COM_Outptr_opt_ }   ppDevice: PID3D11Device = nil;
    {_COM_Outptr_opt_ }  ppImmediateContext: PID3D11DeviceContext = nil;
    {_Out_opt_ } pChosenFeatureLevel: PD3D_FEATURE_LEVEL = nil): HRESULT; stdcall; external D3D11_DLL;


implementation

end.
