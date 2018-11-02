unit DX12.DXGI1_6;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils, DX12.DXGI1_5, DX12.DXGI1_2, DX12.DXGI1_4, DX12.DXGI;

const
    IID_IDXGIAdapter4: TGUID = '{3c8d99d1-4fbf-4181-a82c-af66bf7bd24e}';
    IID_IDXGIOutput6: TGUID = '{068346e8-aaec-4b84-add7-137f513f77a1}';
    IID_IDXGIFactory6: TGUID = '{c1b6694f-ff09-44a9-b03c-77900a0a1d17}';

type

    TDXGI_ADAPTER_FLAG3 = (
        DXGI_ADAPTER_FLAG3_NONE = 0,
        DXGI_ADAPTER_FLAG3_REMOTE = 1,
        DXGI_ADAPTER_FLAG3_SOFTWARE = 2,
        DXGI_ADAPTER_FLAG3_ACG_COMPATIBLE = 4,
        DXGI_ADAPTER_FLAG3_SUPPORT_MONITORED_FENCES = 8,
        DXGI_ADAPTER_FLAG3_SUPPORT_NON_MONITORED_FENCES = $10,
        DXGI_ADAPTER_FLAG3_KEYED_MUTEX_CONFORMANCE = $20,
        DXGI_ADAPTER_FLAG3_FORCE_DWORD = $ffffffff
        );


    TDXGI_ADAPTER_DESC3 = record
        Description: array [0.. 127] of WCHAR;
        VendorId: UINT;
        DeviceId: UINT;
        SubSysId: UINT;
        Revision: UINT;
        DedicatedVideoMemory: SIZE_T;
        DedicatedSystemMemory: SIZE_T;
        SharedSystemMemory: SIZE_T;
        AdapterLuid: LUID;
        Flags: TDXGI_ADAPTER_FLAG3;
        GraphicsPreemptionGranularity: TDXGI_GRAPHICS_PREEMPTION_GRANULARITY;
        ComputePreemptionGranularity: TDXGI_COMPUTE_PREEMPTION_GRANULARITY;
    end;




    IDXGIAdapter4 = interface(IDXGIAdapter3)
        ['{3c8d99d1-4fbf-4181-a82c-af66bf7bd24e}']
        function GetDesc3(out pDesc: TDXGI_ADAPTER_DESC3): HResult; stdcall;

    end;




    TDXGI_OUTPUT_DESC1 = record
        DeviceName: array [0..31] of WCHAR;
        DesktopCoordinates: TRECT;
        AttachedToDesktop: boolean;
        Rotation: TDXGI_MODE_ROTATION;
        Monitor: HMONITOR;
        BitsPerColor: UINT;
        ColorSpace: TDXGI_COLOR_SPACE_TYPE;
        RedPrimary: array [0.. 1] of single;
        GreenPrimary: array [0..1] of single;
        BluePrimary: array [0..1] of single;
        WhitePoint: array [0.. 1] of single;
        MinLuminance: single;
        MaxLuminance: single;
        MaxFullFrameLuminance: single;
    end;

    TDXGI_HARDWARE_COMPOSITION_SUPPORT_FLAGS = (
        DXGI_HARDWARE_COMPOSITION_SUPPORT_FLAG_FULLSCREEN = 1,
        DXGI_HARDWARE_COMPOSITION_SUPPORT_FLAG_WINDOWED = 2,
        DXGI_HARDWARE_COMPOSITION_SUPPORT_FLAG_CURSOR_STRETCHED = 4
        );




    IDXGIOutput6 = interface(IDXGIOutput5)
        ['{068346e8-aaec-4b84-add7-137f513f77a1}']
        function GetDesc1(out pDesc: TDXGI_OUTPUT_DESC1): HResult; stdcall;
        function CheckHardwareCompositionSupport(out pFlags: UINT): HResult; stdcall;
    end;


    TDXGI_GPU_PREFERENCE = (
        DXGI_GPU_PREFERENCE_UNSPECIFIED = 0,
        DXGI_GPU_PREFERENCE_MINIMUM_POWER = (DXGI_GPU_PREFERENCE_UNSPECIFIED + 1),
        DXGI_GPU_PREFERENCE_HIGH_PERFORMANCE = (DXGI_GPU_PREFERENCE_MINIMUM_POWER + 1)
        );




    IDXGIFactory6 = interface(IDXGIFactory5)
        ['{c1b6694f-ff09-44a9-b03c-77900a0a1d17}']
        function EnumAdapterByGpuPreference(Adapter: UINT; GpuPreference: TDXGI_GPU_PREFERENCE; const riid: TGUID; out ppvAdapter): HRESULT; stdcall;
    end;




function DXGIDeclareAdapterRemovalSupport(): HRESULT; stdcall; external '';

implementation

end.

