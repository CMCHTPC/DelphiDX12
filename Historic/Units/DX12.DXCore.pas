unit DX12.DXCore;

(************************************************************
*                                                           *
* Copyright (c) Microsoft Corporation. All rights reserved. *
*                                                           *
************************************************************)

{ **************************************************************************
  Additional Copyright (C) for this modul:

  Copyright (c) Microsoft Corporation.  All rights reserved.
  File name:  DXCore.h
  File name:  dxcore_interface.h

  Header version: 10.0.19041.0

  ************************************************************************** }

{$mode delphi}

interface

uses
    Windows, Classes, SysUtils;

const

    DLLName = 'DXCore.dll';


const
    IID_IDXCoreAdapterFactory: TGUID = '{78ee5945-c36e-4b13-a669-005dd11c0f06}';
    IID_IDXCoreAdapterList: TGUID = '{526c7776-40e9-459b-b711-f32ad76dfc28}';
    IID_IDXCoreAdapter: TGUID = '{f0db4c7f-fe5a-42a2-bd62-f2a6cf6fc83e}';
    DXCORE_ADAPTER_ATTRIBUTE_D3D11_GRAPHICS: TGUID = '{8c47866b-7583-450d-f0f0-6bada895af4b}';
    DXCORE_ADAPTER_ATTRIBUTE_D3D12_GRAPHICS: TGUID = '{0c9ece4d-2f6e-4f01-8c96-e89e331b47b1}';
    DXCORE_ADAPTER_ATTRIBUTE_D3D12_CORE_COMPUTE: TGUID = '{248e2800-a793-4724-abaa-23a6de1be090}';

const
    _FACDXCORE = $880;

//#define MAKE_DXCORE_HRESULT( code )     MAKE_HRESULT( 1, _FACDXCORE, code )

type

    TDXCoreAdapterProperty = (
        InstanceLuid = 0,
        DriverVersion = 1,
        DriverDescription = 2,
        HardwareID = 3,
        KmdModelVersion = 4,
        ComputePreemptionGranularity = 5,
        GraphicsPreemptionGranularity = 6,
        DedicatedAdapterMemory = 7,
        DedicatedSystemMemory = 8,
        SharedSystemMemory = 9,
        AcgCompatible = 10,
        IsHardware = 11,
        IsIntegrated = 12,
        IsDetachable = 13
        );

    TDXCoreAdapterState = (
        IsDriverUpdateInProgress = 0,
        AdapterMemoryBudget = 1
        );

    TDXCoreSegmentGroup = (
        Local = 0,
        NonLocal = 1);

    TDXCoreNotificationType = (
        AdapterListStale = 0,
        AdapterNoLongerValid = 1,
        AdapterBudgetChange = 2,
        AdapterHardwareContentProtectionTeardown = 3);

    TDXCoreAdapterPreference = (
        Hardware = 0,
        MinimumPower = 1,
        HighPerformance = 2
        );
    PDXCoreAdapterPreference = ^TDXCoreAdapterPreference;

    TDXCoreHardwareID = record
        vendorID: uint32;
        deviceID: uint32;
        subSysID: uint32;
        revision: uint32;
    end;

    TDXCoreAdapterMemoryBudgetNodeSegmentGroup = record
        nodeIndex: uint32;
        segmentGroup: TDXCoreSegmentGroup;
    end;

    TDXCoreAdapterMemoryBudget = record
        budget: uint64;
        currentUsage: uint64;
        availableForReservation: uint64;
        currentReservation: uint64;
    end;

    PFN_DXCORE_NOTIFICATION_CALLBACK = function(notificationType: TDXCoreNotificationType; _object: IUnknown;
        context: pointer): HResult; stdcall;




    IDXCoreAdapter = interface(IUnknown)
        ['{f0db4c7f-fe5a-42a2-bd62-f2a6cf6fc83e}']
        function IsValid(): boolean; stdcall;
        function IsAttributeSupported(const attributeGUID: TGUID): boolean; stdcall;
        function IsPropertySupported(_property: TDXCoreAdapterProperty): boolean; stdcall;
        function GetProperty(_property: TDXCoreAdapterProperty; bufferSize: size_t;
            out propertyData {bufferSize}: pointer): HResult; stdcall;
        function GetPropertySize(_property: TDXCoreAdapterProperty; out bufferSize: size_t): HResult; stdcall;
        function IsQueryStateSupported(_property: TDXCoreAdapterState): boolean; stdcall;
        function QueryState(state: TDXCoreAdapterState; inputStateDetailsSize: size_t;
            const inputStateDetails {inputStateDetailsSize}: Pointer; outputBufferSize: size_t;
            out outputBuffer {outputBufferSize}: pointer): HResult; stdcall;
        function IsSetStateSupported(_property: TDXCoreAdapterState): boolean; stdcall;
        function SetState(state: TDXCoreAdapterState; inputStateDetailsSize: size_t;
            const inputStateDetails {inputStateDetailsSize}: pointer; inputDataSize: size_t;
            const inputData {inputDataSize}: pointer): HResult; stdcall;
        function GetFactory(const riid: TGUID; out ppvFactory): HResult; stdcall;
    end;



    IDXCoreAdapterList = interface(IUnknown)
        ['{526c7776-40e9-459b-b711-f32ad76dfc28}']
        function GetAdapter(index: uint32; const riid: TGUID; out ppvAdapter): HResult; stdcall;
        function GetAdapterCount(): uint32; stdcall;
        function IsStale(): boolean; stdcall;
        function GetFactory(const riid: TGUID; out ppvFactory): HResult; stdcall;
        function Sort(numPreferences: uint32; const preferences {numPreferences}: PDXCoreAdapterPreference): HResult; stdcall;
        function IsAdapterPreferenceSupported(preference: TDXCoreAdapterPreference): boolean; stdcall;
    end;


    IDXCoreAdapterFactory = interface(IUnknown)
        ['{78ee5945-c36e-4b13-a669-005dd11c0f06}']
        function CreateAdapterList(numAttributes: uint32; const filterAttributes {numAttributes}: PGUID;
            const riid: TGUID; out ppvAdapterList): HResult; stdcall;
        function GetAdapterByLuid(const adapterLUID: LUID; const riid: TGUID; out ppvAdapter): HResult; stdcall;
        function IsNotificationTypeSupported(notificationType: TDXCoreNotificationType): boolean; stdcall;
        function RegisterEventNotification(dxCoreObject: IUnknown; notificationType: TDXCoreNotificationType;
            callbackFunction: PFN_DXCORE_NOTIFICATION_CALLBACK; callbackContext: Pointer; out eventCookie: uint32): HResult; stdcall;
        function UnregisterEventNotification(eventCookie: uint32): HResult; stdcall;
    end;



function DXCoreCreateAdapterFactory(const riid: TGUID; out ppvFactory): HResult; stdcall; external DLLName;

implementation

end.
