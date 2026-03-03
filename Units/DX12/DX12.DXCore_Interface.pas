{ **************************************************************************
    FreePascal/Delphi DirectX 12 Header Files

    Copyright (C) 2013-2025 Norbert Sonnleitner

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
************************************************************************** }

{ **************************************************************************
   Additional Copyright (C) for this modul:

   Copyright (c) Microsoft Corporation
   Licensed under the MIT license
   DXCore Interface

   This unit consists of the following header files
   File name: dxcore_interface.h
   Header version: SDK 1.717.1-preview  2025 12 28

  ************************************************************************** }
unit DX12.DXCore_Interface;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils;

    {$Z4}

const

    _FACDXCORE = $880;


    IID_IDXCoreAdapterFactory: TGUID = '{78EE5945-C36E-4B13-A669-005DD11C0F06}';
    IID_IDXCoreAdapterFactory1: TGUID = '{D5682E19-6D21-401C-827A-9A51A4EA35D7}';
    IID_IDXCoreAdapterList: TGUID = '{526C7776-40E9-459B-B711-F32AD76DFC28}';
    IID_IDXCoreAdapter: TGUID = '{F0DB4C7F-FE5A-42A2-BD62-F2A6CF6FC83E}';
    IID_IDXCoreAdapter1: TGUID = '{A0783366-CFA3-43BE-9D79-55B2DA97C63C}';

    DXCORE_ADAPTER_ATTRIBUTE_D3D11_GRAPHICS: TGUID = '{8C47866B-7583-450D-F0F0-6BADA895AF4B}';
    DXCORE_ADAPTER_ATTRIBUTE_D3D12_GRAPHICS: TGUID = '{0C9ECE4D-2F6E-4F01-8C96-E89E331B47B1}';
    DXCORE_ADAPTER_ATTRIBUTE_D3D12_CORE_COMPUTE: TGUID = '{248E2800-A793-4724-ABAA-23A6DE1BE090}';
    DXCORE_ADAPTER_ATTRIBUTE_D3D12_GENERIC_ML: TGUID = '{B71B0D41-1088-422F-A27C-0250B7D3A988}';
    DXCORE_ADAPTER_ATTRIBUTE_D3D12_GENERIC_MEDIA: TGUID = '{8EB2C848-82F6-4B49-AA87-AECFCF0174C6}';

    DXCORE_HARDWARE_TYPE_ATTRIBUTE_GPU: TGUID = '{B69EB219-3DED-4464-979F-A00BD4687006}';
    DXCORE_HARDWARE_TYPE_ATTRIBUTE_COMPUTE_ACCELERATOR: TGUID = '{E0B195DA-58EF-4A22-90F1-1F28169CAB8D}';
    DXCORE_HARDWARE_TYPE_ATTRIBUTE_NPU: TGUID = '{D46140C4-ADD7-451B-9E56-06FE8C3B58ED}';
    DXCORE_HARDWARE_TYPE_ATTRIBUTE_MEDIA_ACCELERATOR: TGUID = '{66BDB96A-050B-44C7-A4FD-D144CE0AB443}';


type

    REFGUID = ^TGUID;
    REFIID = ^TGUID;

    TDXCoreAdapterProperty = (
        InstanceLuid = 0,
        DriverVersion = 1,
        DriverDescription = 2,
        HardwareID = 3, // Use HardwareIDParts instead, if available.
        KmdModelVersion = 4,
        ComputePreemptionGranularity = 5,
        GraphicsPreemptionGranularity = 6,
        DedicatedAdapterMemory = 7,
        DedicatedSystemMemory = 8,
        SharedSystemMemory = 9,
        AcgCompatible = 10,
        IsHardware = 11,
        IsIntegrated = 12,
        IsDetachable = 13,
        HardwareIDParts = 14,
        PhysicalAdapterCount = 15,
        AdapterEngineCount = 16,
        AdapterEngineName = 17);

    PDXCoreAdapterProperty = ^TDXCoreAdapterProperty;


    TDXCoreAdapterState = (
        IsDriverUpdateInProgress = 0,
        AdapterMemoryBudget = 1,
        AdapterMemoryUsageBytes = 2,
        AdapterMemoryUsageByProcessBytes = 3,
        AdapterEngineRunningTimeMicroseconds = 4,
        AdapterEngineRunningTimeByProcessMicroseconds = 5,
        AdapterTemperatureCelsius = 6,
        AdapterInUseProcessCount = 7,
        AdapterInUseProcessSet = 8,
        AdapterEngineFrequencyHertz = 9,
        AdapterMemoryFrequencyHertz = 10);

    PDXCoreAdapterState = ^TDXCoreAdapterState;


    TDXCoreSegmentGroup = (
        Local = 0,
        NonLocal = 1);

    PDXCoreSegmentGroup = ^TDXCoreSegmentGroup;


    TDXCoreNotificationType = (
        AdapterListStale = 0,
        AdapterNoLongerValid = 1,
        AdapterBudgetChange = 2,
        AdapterHardwareContentProtectionTeardown = 3);

    PDXCoreNotificationType = ^TDXCoreNotificationType;


    TDXCoreAdapterPreference = (
        Hardware = 0,
        MinimumPower = 1,
        HighPerformance = 2);

    PDXCoreAdapterPreference = ^TDXCoreAdapterPreference;


    TDXCoreWorkload = (
        Graphics = 0,
        Compute = 1,
        Media = 2,
        MachineLearning = 3);

    PDXCoreWorkload = ^TDXCoreWorkload;


    TDXCoreRuntimeFilterFlags = (
        RuntimeFilterFlag_None = $0,
        RuntimeFilterFlag_D3D11 = $1,
        RuntimeFilterFlag_D3D12 = $2);

    PDXCoreRuntimeFilterFlags = ^TDXCoreRuntimeFilterFlags;


    TDXCoreHardwareTypeFilterFlags = (
        HardwareTypeFilterFlag_None = $0,
        HardwareTypeFilterFlag_GPU = $1,
        HardwareTypeFilterFlag_ComputeAccelerator = $2,
        HardwareTypeFilterFlag_NPU = $4,
        HardwareTypeFilterFlag_MediaAccelerator = $8);

    PDXCoreHardwareTypeFilterFlags = ^TDXCoreHardwareTypeFilterFlags;


    TDXCoreHardwareID = record
        vendorID: uint32;
        deviceID: uint32;
        subSysID: uint32;
        revision: uint32;
    end;
    PDXCoreHardwareID = ^TDXCoreHardwareID;


    TDXCoreHardwareIDParts = record
        vendorID: uint32;
        deviceID: uint32;
        subSystemID: uint32;
        subVendorID: uint32;
        revisionID: uint32;
    end;
    PDXCoreHardwareIDParts = ^TDXCoreHardwareIDParts;


    TDXCoreAdapterMemoryBudgetNodeSegmentGroup = record
        nodeIndex: uint32;
        segmentGroup: TDXCoreSegmentGroup;
    end;
    PDXCoreAdapterMemoryBudgetNodeSegmentGroup = ^TDXCoreAdapterMemoryBudgetNodeSegmentGroup;


    TDXCoreAdapterMemoryBudget = record
        budget: uint64;
        currentUsage: uint64;
        availableForReservation: uint64;
        currentReservation: uint64;
    end;
    PDXCoreAdapterMemoryBudget = ^TDXCoreAdapterMemoryBudget;


    TDXCoreAdapterEngineIndex = record
        physicalAdapterIndex: uint32;
        engineIndex: uint32;
    end;
    PDXCoreAdapterEngineIndex = ^TDXCoreAdapterEngineIndex;


    TDXCoreEngineQueryInput = record
        adapterEngineIndex: TDXCoreAdapterEngineIndex;
        processId: uint32;
    end;
    PDXCoreEngineQueryInput = ^TDXCoreEngineQueryInput;


    TDXCoreEngineQueryOutput = record
        runningTime: uint64;
        processQuerySucceeded: boolean; // 1 byte
    end;
    PDXCoreEngineQueryOutput = ^TDXCoreEngineQueryOutput;


    TDXCoreMemoryType = (
        Dedicated = 0,
        Shared = 1);

    PDXCoreMemoryType = ^TDXCoreMemoryType;


    TDXCoreMemoryUsage = record
        committed: uint64;
        resident: uint64;
    end;
    PDXCoreMemoryUsage = ^TDXCoreMemoryUsage;


    TDXCoreMemoryQueryInput = record
        physicalAdapterIndex: uint32;
        memoryType: TDXCoreMemoryType;
    end;
    PDXCoreMemoryQueryInput = ^TDXCoreMemoryQueryInput;


    TDXCoreProcessMemoryQueryInput = record
        physicalAdapterIndex: uint32;
        memoryType: TDXCoreMemoryType;
        processId: uint32;
    end;
    PDXCoreProcessMemoryQueryInput = ^TDXCoreProcessMemoryQueryInput;


    TDXCoreProcessMemoryQueryOutput = record
        memoryUsage: TDXCoreMemoryUsage;
        processQuerySucceeded: boolean;
    end;
    PDXCoreProcessMemoryQueryOutput = ^TDXCoreProcessMemoryQueryOutput;


    TDXCoreAdapterProcessSetQueryInput = record
        arraySize: uint32;
        {_Field_size_(arraySize) } processIds: Puint32;
    end;
    PDXCoreAdapterProcessSetQueryInput = ^TDXCoreAdapterProcessSetQueryInput;


    TDXCoreAdapterProcessSetQueryOutput = record
        processesWritten: uint32;
        processesTotal: uint32;
    end;
    PDXCoreAdapterProcessSetQueryOutput = ^TDXCoreAdapterProcessSetQueryOutput;


    TDXCoreEngineNamePropertyInput = record
        adapterEngineIndex: TDXCoreAdapterEngineIndex;
        engineNameLength: uint32;
        {_Field_size_(engineNameLength) } engineName: pwidechar;
    end;
    PDXCoreEngineNamePropertyInput = ^TDXCoreEngineNamePropertyInput;


    TDXCoreEngineNamePropertyOutput = record
        engineNameLength: uint32;
    end;
    PDXCoreEngineNamePropertyOutput = ^TDXCoreEngineNamePropertyOutput;


    TDXCoreFrequencyQueryOutput = record
        frequency: uint64;
        maxFrequency: uint64;
        maxOverclockedFrequency: uint64;
    end;
    PDXCoreFrequencyQueryOutput = ^TDXCoreFrequencyQueryOutput;


    PFN_DXCORE_NOTIFICATION_CALLBACK = procedure(notificationType: TDXCoreNotificationType;
        {_In_ } CoreObject: IUnknown;
        {_In_opt_ } context: Pvoid); stdcall;


    (* interface IDXCoreAdapter *)
    IDXCoreAdapter = interface(IUnknown)
        ['{f0db4c7f-fe5a-42a2-bd62-f2a6cf6fc83e}']
        function IsValid(): boolean; stdcall;

        function IsAttributeSupported(attributeGUID: REFGUID): boolean; stdcall;

        function IsPropertySupported(AdapterProperty: TDXCoreAdapterProperty): boolean; stdcall;

        function GetProperty(AdapterProperty: TDXCoreAdapterProperty; bufferSize: size_t;
        {_Out_writes_bytes_(bufferSize)  } propertyData: Pvoid): HRESULT; stdcall;

        function GetPropertySize(AdapterProperty: TDXCoreAdapterProperty;
        {_Out_ } bufferSize: Psize_t): HRESULT; stdcall;

        function IsQueryStateSupported(AdapterProperty: TDXCoreAdapterState): boolean; stdcall;

        function QueryState(state: TDXCoreAdapterState; inputStateDetailsSize: size_t;
        {_In_reads_bytes_opt_(inputStateDetailsSize) } inputStateDetails: Pvoid; outputBufferSize: size_t;
        {_Out_writes_bytes_(outputBufferSize) } outputBuffer: Pvoid): HRESULT; stdcall;

        function IsSetStateSupported(AdapterState: TDXCoreAdapterState): boolean; stdcall;

        function SetState(state: TDXCoreAdapterState; inputStateDetailsSize: size_t;
        {_In_reads_bytes_opt_(inputStateDetailsSize) } inputStateDetails: Pvoid; inputDataSize: size_t;
        {_In_reads_bytes_(inputDataSize) } inputData: Pvoid): HRESULT; stdcall;

        function GetFactory(riid: REFIID;
        {_COM_Outptr_ }  out ppvFactory): HRESULT; stdcall;

    end;


    (* interface IDXCoreAdapter1 *)
    IDXCoreAdapter1 = interface(IDXCoreAdapter)
        ['{a0783366-cfa3-43be-9d79-55b2da97c63c}']
        function GetPropertyWithInput(AdapterProperty: TDXCoreAdapterProperty; inputPropertyDetailsSize: size_t;
        {_In_reads_bytes_opt_(inputPropertyDetailsSize) } inputPropertyDetails: Pvoid; outputBufferSize: size_t;
        {_Out_writes_bytes_(outputBufferSize) } outputBuffer: Pvoid): HRESULT; stdcall;

    end;


    (* interface IDXCoreAdapterList *)
    IDXCoreAdapterList = interface(IUnknown)
        ['{526c7776-40e9-459b-b711-f32ad76dfc28}']
        function GetAdapter(index: uint32; riid: REFIID;
        {_COM_Outptr_ }  out ppvAdapter): HRESULT; stdcall;

        function GetAdapterCount(): uint32; stdcall;

        function IsStale(): boolean; stdcall;

        function GetFactory(riid: REFIID;
        {_COM_Outptr_ }  out ppvFactory): HRESULT; stdcall;

        function Sort(numPreferences: uint32;
        {_In_reads_(numPreferences) } preferences: PDXCoreAdapterPreference): HRESULT; stdcall;

        function IsAdapterPreferenceSupported(preference: TDXCoreAdapterPreference): boolean; stdcall;

    end;


    (* interface IDXCoreAdapterFactory *)
    IDXCoreAdapterFactory = interface(IUnknown)
        ['{78ee5945-c36e-4b13-a669-005dd11c0f06}']
        function CreateAdapterList(numAttributes: uint32;
        {_In_reads_(numAttributes) } filterAttributes: PGUID; riid: REFIID;
        {_COM_Outptr_ }  out ppvAdapterList): HRESULT; stdcall;

        function GetAdapterByLuid(adapterLUID: TLUID; riid: REFIID;
        {_COM_Outptr_ }  out ppvAdapter): HRESULT; stdcall;

        function IsNotificationTypeSupported(notificationType: TDXCoreNotificationType): boolean; stdcall;

        function RegisterEventNotification(
        {_In_ } dxCoreObject: IUnknown; notificationType: TDXCoreNotificationType;
        {_In_ } callbackFunction: PFN_DXCORE_NOTIFICATION_CALLBACK;
        {_In_opt_ } callbackContext: Pvoid;
        {_Out_ } eventCookie: Puint32): HRESULT; stdcall;

        function UnregisterEventNotification(eventCookie: uint32): HRESULT; stdcall;

    end;


    (* interface IDXCoreAdapterFactory1 *)
    IDXCoreAdapterFactory1 = interface(IDXCoreAdapterFactory)
        ['{d5682e19-6d21-401c-827a-9a51a4ea35d7}']
        function CreateAdapterListByWorkload(workload: TDXCoreWorkload; runtimeFilter: TDXCoreRuntimeFilterFlags; hardwareTypeFilter: TDXCoreHardwareTypeFilterFlags; riid: REFIID;
        {_COM_Outptr_ }  out ppvAdapterList): HRESULT; stdcall;

    end;


function MAKE_DXCORE_HRESULT(code: longword): Hresult;

implementation

uses
    Windows.Macros;



function MAKE_DXCORE_HRESULT(code: longword): Hresult;
begin
    Result := MAKE_HRESULT(1, _FACDXCORE, code);

end;

end.
