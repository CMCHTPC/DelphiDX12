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
   
   Copyright (C) Microsoft Corporation.
   Licensed under the MIT license
   
   This unit consists of the following header files
   File name: dxgi.h 
   Header version: 10.0.26100.6584
   
  ************************************************************************** }
unit DX12.DXGI;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface


uses
    Windows, Classes, SysUtils,
    ActiveX,
    DX12.DXGICommon,
    DX12.DXGIFormat,
    DX12.DXGIType;

    {$Z4}

const

    DXGI_CPU_ACCESS_NONE = (0);
    DXGI_CPU_ACCESS_DYNAMIC = (1);
    DXGI_CPU_ACCESS_READ_WRITE = (2);
    DXGI_CPU_ACCESS_SCRATCH = (3);
    DXGI_CPU_ACCESS_FIELD = 15;
    DXGI_USAGE_SHADER_INPUT = $00000010;
    DXGI_USAGE_RENDER_TARGET_OUTPUT = $00000020;
    DXGI_USAGE_BACK_BUFFER = $00000040;
    DXGI_USAGE_SHARED = $00000080;
    DXGI_USAGE_READ_ONLY = $00000100;
    DXGI_USAGE_DISCARD_ON_PRESENT = $00000200;
    DXGI_USAGE_UNORDERED_ACCESS = $00000400;


    DXGI_RESOURCE_PRIORITY_MINIMUM = ($28000000);
    DXGI_RESOURCE_PRIORITY_LOW = ($50000000);
    DXGI_RESOURCE_PRIORITY_NORMAL = ($78000000);
    DXGI_RESOURCE_PRIORITY_HIGH = ($a0000000);
    DXGI_RESOURCE_PRIORITY_MAXIMUM = ($c8000000);


    DXGI_MAP_READ = (1);
    DXGI_MAP_WRITE = (2);
    DXGI_MAP_DISCARD = (4);


    DXGI_ENUM_MODES_INTERLACED = (1);
    DXGI_ENUM_MODES_SCALING = (2);


    DXGI_MAX_SWAP_CHAIN_BUFFERS = (16);
    DXGI_PRESENT_TEST = $00000001;
    DXGI_PRESENT_DO_NOT_SEQUENCE = $00000002;
    DXGI_PRESENT_RESTART = $00000004;
    DXGI_PRESENT_DO_NOT_WAIT = $00000008;
    DXGI_PRESENT_STEREO_PREFER_RIGHT = $00000010;
    DXGI_PRESENT_STEREO_TEMPORARY_MONO = $00000020;
    DXGI_PRESENT_RESTRICT_TO_OUTPUT = $00000040;
    DXGI_PRESENT_USE_DURATION = $00000100;
    DXGI_PRESENT_ALLOW_TEARING = $00000200;


    DXGI_MWA_NO_WINDOW_CHANGES = (1 shl 0);
    DXGI_MWA_NO_ALT_ENTER = (1 shl 1);
    DXGI_MWA_NO_PRINT_SCREEN = (1 shl 2);
    DXGI_MWA_VALID = ($7);


    IID_IDXGIObject: TGUID = '{AEC22FB8-76F3-4639-9BE0-28EB43A67A2E}';
    IID_IDXGIDeviceSubObject: TGUID = '{3D3E0379-F9DE-4D58-BB6C-18D62992F1A6}';
    IID_IDXGIResource: TGUID = '{035F3AB4-482E-4E50-B41F-8A7F8BD8960B}';
    IID_IDXGIKeyedMutex: TGUID = '{9D8E1289-D7B3-465F-8126-250E349AF85D}';
    IID_IDXGISurface: TGUID = '{CAFCB56C-6AC3-4889-BF47-9E23BBD260EC}';
    IID_IDXGISurface1: TGUID = '{4AE63092-6327-4C1B-80AE-BFE12EA32B86}';
    IID_IDXGIAdapter: TGUID = '{2411E7E1-12AC-4CCF-BD14-9798E8534DC0}';
    IID_IDXGIOutput: TGUID = '{AE02EEDB-C735-4690-8D52-5A8DC20213AA}';
    IID_IDXGISwapChain: TGUID = '{310D36A0-D2E7-4C0A-AA04-6A9D23B8886A}';
    IID_IDXGIFactory: TGUID = '{7B7166EC-21C7-44AE-B21A-C9AE321AE369}';
    IID_IDXGIDevice: TGUID = '{54EC77FA-1377-44E6-8C32-88FD5F44C84C}';
    IID_IDXGIFactory1: TGUID = '{770AAE78-F26F-4DBA-A829-253C83D1B387}';
    IID_IDXGIAdapter1: TGUID = '{29038F61-3839-4626-91FD-086879011A05}';
    IID_IDXGIDevice1: TGUID = '{77DB970F-6276-48BA-BA28-070143B4392C}';


type
    REFGUID = ^TGUID;
    PHDC = ^HDC;
    PHWND = ^HWND;
    PIUnknown = ^IUnknown;
    REFIID = ^TGUID;

    (* Forward Declarations *)


    IDXGIObject = interface;


    IDXGIDeviceSubObject = interface;


    IDXGIResource = interface;
    PIDXGIResource = ^IDXGIResource;


    IDXGIKeyedMutex = interface;


    IDXGISurface = interface;


    IDXGISurface1 = interface;


    IDXGIAdapter = interface;
    PIDXGIAdapter = ^IDXGIAdapter;


    IDXGIOutput = interface;
    PIDXGIOutput = ^IDXGIOutput;


    IDXGISwapChain = interface;


    IDXGIFactory = interface;


    IDXGIDevice = interface;


    IDXGIFactory1 = interface;


    IDXGIAdapter1 = interface;


    IDXGIDevice1 = interface;


    TDXGI_USAGE = UINT;
    PDXGI_USAGE = ^TDXGI_USAGE;

    TDXGI_FRAME_STATISTICS = record
        PresentCount: UINT;
        PresentRefreshCount: UINT;
        SyncRefreshCount: UINT;
        SyncQPCTime: LARGE_INTEGER;
        SyncGPUTime: LARGE_INTEGER;
    end;
    PDXGI_FRAME_STATISTICS = ^TDXGI_FRAME_STATISTICS;

    TDXGI_MAPPED_RECT = record
        Pitch: int32;
        pBits: pbyte;
    end;
    PDXGI_MAPPED_RECT = ^TDXGI_MAPPED_RECT;


    T_LUID = record
        LowPart: DWORD;
        HighPart: LONG;
    end;
    TLUID = T_LUID;

    PLUID = ^TLUID;


    TDXGI_ADAPTER_DESC = record
        Description: array [0..128 - 1] of WCHAR;
        VendorId: UINT;
        DeviceId: UINT;
        SubSysId: UINT;
        Revision: UINT;
        DedicatedVideoMemory: SIZE_T;
        DedicatedSystemMemory: SIZE_T;
        SharedSystemMemory: SIZE_T;
        AdapterLuid: TLUID;
    end;
    PDXGI_ADAPTER_DESC = ^TDXGI_ADAPTER_DESC;


    HMONITOR = HANDLE;


    TDXGI_OUTPUT_DESC = record
        DeviceName: array [0..32 - 1] of WCHAR;
        DesktopCoordinates: TRECT;
        AttachedToDesktop: boolean;
        Rotation: TDXGI_MODE_ROTATION;
        Monitor: HMONITOR;
    end;
    PDXGI_OUTPUT_DESC = ^TDXGI_OUTPUT_DESC;

    TDXGI_SHARED_RESOURCE = record
        Handle: HANDLE;
    end;
    PDXGI_SHARED_RESOURCE = ^TDXGI_SHARED_RESOURCE;

    TDXGI_RESIDENCY = (
        DXGI_RESIDENCY_FULLY_RESIDENT = 1,
        DXGI_RESIDENCY_RESIDENT_IN_SHARED_MEMORY = 2,
        DXGI_RESIDENCY_EVICTED_TO_DISK = 3
        );
    PDXGI_RESIDENCY = ^TDXGI_RESIDENCY;


    TDXGI_SURFACE_DESC = record
        Width: UINT;
        Height: UINT;
        Format: TDXGI_FORMAT;
        SampleDesc: TDXGI_SAMPLE_DESC;
    end;
    PDXGI_SURFACE_DESC = ^TDXGI_SURFACE_DESC;

    TDXGI_SWAP_EFFECT = (
        DXGI_SWAP_EFFECT_DISCARD = 0,
        DXGI_SWAP_EFFECT_SEQUENTIAL = 1,
        DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL = 3,
        DXGI_SWAP_EFFECT_FLIP_DISCARD = 4
        );


    TDXGI_SWAP_CHAIN_FLAG = (
        DXGI_SWAP_CHAIN_FLAG_NONPREROTATED = 1,
        DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH = 2,
        DXGI_SWAP_CHAIN_FLAG_GDI_COMPATIBLE = 4,
        DXGI_SWAP_CHAIN_FLAG_RESTRICTED_CONTENT = 8,
        DXGI_SWAP_CHAIN_FLAG_RESTRICT_SHARED_RESOURCE_DRIVER = 16,
        DXGI_SWAP_CHAIN_FLAG_DISPLAY_ONLY = 32,
        DXGI_SWAP_CHAIN_FLAG_FRAME_LATENCY_WAITABLE_OBJECT = 64,
        DXGI_SWAP_CHAIN_FLAG_FOREGROUND_LAYER = 128,
        DXGI_SWAP_CHAIN_FLAG_FULLSCREEN_VIDEO = 256,
        DXGI_SWAP_CHAIN_FLAG_YUV_VIDEO = 512,
        DXGI_SWAP_CHAIN_FLAG_HW_PROTECTED = 1024,
        DXGI_SWAP_CHAIN_FLAG_ALLOW_TEARING = 2048,
        DXGI_SWAP_CHAIN_FLAG_RESTRICTED_TO_ALL_HOLOGRAPHIC_DISPLAYS = 4096
        );


    { TDXGI_SWAP_CHAIN_DESC }

    TDXGI_SWAP_CHAIN_DESC = record
        BufferDesc: TDXGI_MODE_DESC;
        SampleDesc: TDXGI_SAMPLE_DESC;
        BufferUsage: TDXGI_USAGE;
        BufferCount: UINT;
        OutputWindow: HWND;
        Windowed: longbool;
        SwapEffect: TDXGI_SWAP_EFFECT;
        Flags: UINT;
        {$IFDEF FPC}
        class operator Initialize(var A: TDXGI_SWAP_CHAIN_DESC);
        {$ENDIF}
        procedure Init;
    end;
    PDXGI_SWAP_CHAIN_DESC = ^TDXGI_SWAP_CHAIN_DESC;


    IDXGIObject = interface(IUnknown)
        ['{aec22fb8-76f3-4639-9be0-28eb43a67a2e}']
        function SetPrivateData(
        {_In_} Name: REFGUID; DataSize: UINT;
        {_In_reads_bytes_(DataSize)} pData: pointer): HRESULT; stdcall;

        function SetPrivateDataInterface(
        {_In_} Name: REFGUID;
        {_In_opt_} pUnknown: IUnknown): HRESULT; stdcall;

        function GetPrivateData(
        {_In_} Name: REFGUID;
        {_Inout_} pDataSize: PUINT;
        {_Out_writes_bytes_(*pDataSize)} pData: pointer): HRESULT; stdcall;

        function GetParent(
        {_In_} riid: REFIID;
        {_COM_Outptr_} out ppParent): HRESULT; stdcall;

    end;


    IDXGIDeviceSubObject = interface(IDXGIObject)
        ['{3d3e0379-f9de-4d58-bb6c-18d62992f1a6}']
        function GetDevice(
        {_In_} riid: REFIID;
        {_COM_Outptr_} out ppDevice): HRESULT; stdcall;

    end;


    IDXGIResource = interface(IDXGIDeviceSubObject)
        ['{035f3ab4-482e-4e50-b41f-8a7f8bd8960b}']
        function GetSharedHandle(
        {_Out_} pSharedHandle: PHANDLE): HRESULT; stdcall;

        function GetUsage(pUsage: PDXGI_USAGE): HRESULT; stdcall;

        function SetEvictionPriority(EvictionPriority: UINT): HRESULT; stdcall;

        function GetEvictionPriority(
        {_Out_} pEvictionPriority: PUINT): HRESULT; stdcall;

    end;


    IDXGIKeyedMutex = interface(IDXGIDeviceSubObject)
        ['{9d8e1289-d7b3-465f-8126-250e349af85d}']
        function AcquireSync(Key: uint64; dwMilliseconds: DWORD): HRESULT; stdcall;

        function ReleaseSync(Key: uint64): HRESULT; stdcall;

    end;


    IDXGISurface = interface(IDXGIDeviceSubObject)
        ['{cafcb56c-6ac3-4889-bf47-9e23bbd260ec}']
        function GetDesc(
        {_Out_} pDesc: PDXGI_SURFACE_DESC): HRESULT; stdcall;

        function Map(
        {_Out_} pLockedRect: PDXGI_MAPPED_RECT; MapFlags: UINT): HRESULT; stdcall;

        function Unmap(): HRESULT; stdcall;

    end;

    PIDXGISurface = ^IDXGISurface;


    IDXGISurface1 = interface(IDXGISurface)
        ['{4AE63092-6327-4c1b-80AE-BFE12EA32B86}']
        function GetDC(Discard: boolean;
        {_Out_} phdc: PHDC): HRESULT; stdcall;

        function ReleaseDC(
        {_In_opt_} pDirtyRect: PRECT): HRESULT; stdcall;

    end;


    IDXGIAdapter = interface(IDXGIObject)
        ['{2411e7e1-12ac-4ccf-bd14-9798e8534dc0}']
        function EnumOutputs(Output: UINT;
        {_COM_Outptr_} out ppOutput: IDXGIOutput): HRESULT; stdcall;

        function GetDesc(
        {_Out_} pDesc: PDXGI_ADAPTER_DESC): HRESULT; stdcall;

        function CheckInterfaceSupport(
        {_In_} InterfaceName: REFGUID;
        {_Out_} pUMDVersion: PLARGE_INTEGER): HRESULT; stdcall;

    end;

    { IDXGIAdapterHelper }

    IDXGIAdapterHelper = type helper for IDXGIAdapter
        function GetDesc(
        {_Out_}out pDesc: TDXGI_ADAPTER_DESC): HRESULT; stdcall; overload;
    end;


    IDXGIOutput = interface(IDXGIObject)
        ['{ae02eedb-c735-4690-8d52-5a8dc20213aa}']
        function GetDesc(
        {_Out_} pDesc: PDXGI_OUTPUT_DESC): HRESULT; stdcall;

        function GetDisplayModeList(EnumFormat: TDXGI_FORMAT; Flags: UINT;
        {_Inout_} pNumModes: PUINT;
        {_Out_writes_to_opt_(*pNumModes,*pNumModes)} pDesc: PDXGI_MODE_DESC): HRESULT; stdcall;

        function FindClosestMatchingMode(
        {_In_} pModeToMatch: PDXGI_MODE_DESC;
        {_Out_} pClosestMatch: PDXGI_MODE_DESC;
        {_In_opt_} pConcernedDevice: IUnknown): HRESULT; stdcall;

        function WaitForVBlank(): HRESULT; stdcall;

        function TakeOwnership(
        {_In_} pDevice: IUnknown; Exclusive: boolean): HRESULT; stdcall;

        procedure ReleaseOwnership(); stdcall;

        function GetGammaControlCapabilities(
        {_Out_} pGammaCaps: PDXGI_GAMMA_CONTROL_CAPABILITIES): HRESULT; stdcall;

        function SetGammaControl(
        {_In_} pArray: PDXGI_GAMMA_CONTROL): HRESULT; stdcall;

        function GetGammaControl(
        {_Out_} pArray: PDXGI_GAMMA_CONTROL): HRESULT; stdcall;

        function SetDisplaySurface(
        {_In_} pScanoutSurface: IDXGISurface): HRESULT; stdcall;

        function GetDisplaySurfaceData(
        {_In_} pDestination: IDXGISurface): HRESULT; stdcall;

        function GetFrameStatistics(
        {_Out_} pStats: PDXGI_FRAME_STATISTICS): HRESULT; stdcall;

    end;

    { IDXGIOutputHelper }

    IDXGIOutputHelper = type helper for IDXGIOutput
        function GetDisplayModeList(EnumFormat: TDXGI_FORMAT; Flags: UINT;
        {_Inout_} var pNumModes: UINT;
        {_Out_writes_to_opt_(*pNumModes,*pNumModes)} pDesc: PDXGI_MODE_DESC): HRESULT; stdcall; overload;
    end;


    IDXGISwapChain = interface(IDXGIDeviceSubObject)
        ['{310d36a0-d2e7-4c0a-aa04-6a9d23b8886a}']
        function Present(SyncInterval: UINT; Flags: UINT): HRESULT; stdcall;

        function GetBuffer(Buffer: UINT;
        {_In_} riid: REFIID;
        {_COM_Outptr_} out ppSurface): HRESULT; stdcall;

        function SetFullscreenState(Fullscreen: boolean;
        {_In_opt_} pTarget: IDXGIOutput): HRESULT; stdcall;

        function GetFullscreenState(
        {_Out_opt_} pFullscreen: Pboolean;
        {_COM_Outptr_opt_result_maybenull_} ppTarget: PIDXGIOutput): HRESULT; stdcall;

        function GetDesc(
        {_Out_} pDesc: PDXGI_SWAP_CHAIN_DESC): HRESULT; stdcall;

        function ResizeBuffers(BufferCount: UINT; Width: UINT; Height: UINT; NewFormat: TDXGI_FORMAT; SwapChainFlags: UINT): HRESULT; stdcall;

        function ResizeTarget(
        {_In_} pNewTargetParameters: PDXGI_MODE_DESC): HRESULT; stdcall;

        function GetContainingOutput(
        {_COM_Outptr_} out ppOutput: IDXGIOutput): HRESULT; stdcall;

        function GetFrameStatistics(
        {_Out_} pStats: PDXGI_FRAME_STATISTICS): HRESULT; stdcall;

        function GetLastPresentCount(
        {_Out_} pLastPresentCount: PUINT): HRESULT; stdcall;

    end;

    PIDXGISwapChain = ^IDXGISwapChain;

    { IDXGISwapChainHelper }

    IDXGISwapChainHelper = type helper for IDXGISwapChain
        function GetBuffer(Buffer: UINT;
        {_In_} riid: TGUID;
        {_COM_Outptr_} out ppSurface): HRESULT; stdcall; overload;
    end;


    IDXGIFactory = interface(IDXGIObject)
        ['{7b7166ec-21c7-44ae-b21a-c9ae321ae369}']
        function EnumAdapters(Adapter: UINT;
        {_COM_Outptr_} out ppAdapter: IDXGIAdapter): HRESULT; stdcall;

        function MakeWindowAssociation(WindowHandle: HWND; Flags: UINT): HRESULT; stdcall;

        function GetWindowAssociation(
        {_Out_} pWindowHandle: PHWND): HRESULT; stdcall;

        function CreateSwapChain(
        {_In_} pDevice: IUnknown;
        {_In_} pDesc: PDXGI_SWAP_CHAIN_DESC;
        {_COM_Outptr_} out ppSwapChain: IDXGISwapChain): HRESULT; stdcall;

        function CreateSoftwareAdapter(Module: HMODULE;
        {_COM_Outptr_} out ppAdapter: IDXGIAdapter): HRESULT; stdcall;

    end;


    IDXGIDevice = interface(IDXGIObject)
        ['{54ec77fa-1377-44e6-8c32-88fd5f44c84c}']
        function GetAdapter(
        {_COM_Outptr_} out pAdapter: IDXGIAdapter): HRESULT; stdcall;

        function CreateSurface(
        {_In_} pDesc: PDXGI_SURFACE_DESC; NumSurfaces: UINT; Usage: TDXGI_USAGE;
        {_In_opt_} pSharedResource: PDXGI_SHARED_RESOURCE;
        {_Out_writes_(NumSurfaces)} out ppSurface: IDXGISurface): HRESULT; stdcall;

        function QueryResourceResidency(
        {_In_reads_(NumResources)} ppResources: PIUnknown;
        {_Out_writes_(NumResources)} pResidencyStatus: PDXGI_RESIDENCY; NumResources: UINT): HRESULT; stdcall;

        function SetGPUThreadPriority(Priority: int32): HRESULT; stdcall;

        function GetGPUThreadPriority(
        {_Out_} pPriority: int32): HRESULT; stdcall;

    end;


    TDXGI_ADAPTER_FLAG = (
        DXGI_ADAPTER_FLAG_NONE = 0,
        DXGI_ADAPTER_FLAG_REMOTE = 1,
        DXGI_ADAPTER_FLAG_SOFTWARE = 2,
        DXGI_ADAPTER_FLAG_FORCE_DWORD = longint($ffffffff)
        );


    TDXGI_ADAPTER_DESC1 = record
        Description: array [0..128 - 1] of WCHAR;
        VendorId: UINT;
        DeviceId: UINT;
        SubSysId: UINT;
        Revision: UINT;
        DedicatedVideoMemory: SIZE_T;
        DedicatedSystemMemory: SIZE_T;
        SharedSystemMemory: SIZE_T;
        AdapterLuid: TLUID;
        Flags: UINT;
    end;
    PDXGI_ADAPTER_DESC1 = ^TDXGI_ADAPTER_DESC1;

    TDXGI_DISPLAY_COLOR_SPACE = record
        PrimaryCoordinates: array [0..8, 0..2 - 1] of single;
        WhitePoints: array [0..16, 0..2 - 1] of single;
    end;
    PDXGI_DISPLAY_COLOR_SPACE = ^TDXGI_DISPLAY_COLOR_SPACE;


    IDXGIFactory1 = interface(IDXGIFactory)
        ['{770aae78-f26f-4dba-a829-253c83d1b387}']
        function EnumAdapters1(Adapter: UINT;
        {_COM_Outptr_} out ppAdapter: IDXGIAdapter1): HRESULT; stdcall;

        function IsCurrent(): boolean; stdcall;

    end;


    IDXGIAdapter1 = interface(IDXGIAdapter)
        ['{29038f61-3839-4626-91fd-086879011a05}']
        function GetDesc1(
        {_Out_} pDesc: PDXGI_ADAPTER_DESC1): HRESULT; stdcall;

    end;


    IDXGIDevice1 = interface(IDXGIDevice)
        ['{77db970f-6276-48ba-ba28-070143b4392c}']
        function SetMaximumFrameLatency(MaxLatency: UINT): HRESULT; stdcall;

        function GetMaximumFrameLatency(
        {_Out_} pMaxLatency: PUINT): HRESULT; stdcall;

    end;


function CreateDXGIFactory(riid: REFIID;
    {_COM_Outptr_} out ppFactory): HRESULT; stdcall; overload; external 'DXGI.dll';

function CreateDXGIFactory(riid: TGUID;
    {_COM_Outptr_} out ppFactory): HRESULT; overload;


function CreateDXGIFactory1(riid: REFIID;
    {_COM_Outptr_} out ppFactory): HRESULT; stdcall; external 'DXGI.dll';


implementation



function CreateDXGIFactory(riid: TGUID; out ppFactory): HRESULT; overload;
begin
    Result := CreateDXGIFactory(@riid, ppFactory);
end;


{ TDXGI_SWAP_CHAIN_DESC }

class operator TDXGI_SWAP_CHAIN_DESC.Initialize(var A: TDXGI_SWAP_CHAIN_DESC);
begin
    A.Init;
end;



procedure TDXGI_SWAP_CHAIN_DESC.Init;
begin
    BufferDesc.Init;
    SampleDesc.Init;
    BufferUsage := DXGI_USAGE_RENDER_TARGET_OUTPUT;
    BufferCount := 0;
    OutputWindow := 0;
    Windowed := False;
    SwapEffect := DXGI_SWAP_EFFECT_DISCARD;
    Flags := 0;
end;

{ IDXGIAdapterHelper }

function IDXGIAdapterHelper.GetDesc(out pDesc: TDXGI_ADAPTER_DESC): HRESULT; stdcall;
begin
    Result := GetDesc(@pDesc);
end;

{ IDXGIOutputHelper }

function IDXGIOutputHelper.GetDisplayModeList(EnumFormat: TDXGI_FORMAT; Flags: UINT; var pNumModes: UINT; pDesc: PDXGI_MODE_DESC): HRESULT; stdcall;
begin
    Result := GetDisplayModeList(EnumFormat, Flags, @pNumModes, pDesc);
end;

{ IDXGISwapChainHelper }

function IDXGISwapChainHelper.GetBuffer(Buffer: UINT; riid: TGUID; out ppSurface): HRESULT; stdcall;
begin
    Result := GetBuffer(Buffer, @riid, ppSurface);
end;

end.
