unit DX12.DXGI1_4;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

{$Z4}

uses
    Windows, Classes, SysUtils, DX12.DXGI1_3, DX12.DXGI, DX12.DXGI1_2;

const
    IID_IDXGISwapChain3: TGUID = '{94d99bdb-f1f8-4ab0-b236-7da0170edab1}';
    IID_IDXGIOutput4: TGUID = '{dc7dca35-2196-414d-9F53-617884032a60}';
    IID_IDXGIFactory4: TGUID = '{1bc6ea02-ef36-464f-bf0c-21ca39e5168a}';
    IID_IDXGIAdapter3: TGUID = '{645967A4-1392-4310-A798-8053CE3E93FD}';


type
    TDXGI_SWAP_CHAIN_COLOR_SPACE_SUPPORT_FLAG = (
        DXGI_SWAP_CHAIN_COLOR_SPACE_SUPPORT_FLAG_PRESENT = $1,
        DXGI_SWAP_CHAIN_COLOR_SPACE_SUPPORT_FLAG_OVERLAY_PRESENT = $2
        );


    IDXGISwapChain3 = interface(IDXGISwapChain2)
        ['{94d99bdb-f1f8-4ab0-b236-7da0170edab1}']
        function GetCurrentBackBufferIndex(): UINT; stdcall;
        function CheckColorSpaceSupport(ColorSpace: TDXGI_COLOR_SPACE_TYPE; out pColorSpaceSupport: UINT): HRESULT; stdcall;
        function SetColorSpace1(ColorSpace: TDXGI_COLOR_SPACE_TYPE): HRESULT; stdcall;
        function ResizeBuffers1(BufferCount: UINT; Width: UINT; Height: UINT; Format: TDXGI_FORMAT;
            SwapChainFlags: UINT; pCreationNodeMask: PUINT; ppPresentQueue: PIUnknown): HRESULT; stdcall;
    end;


    TDXGI_OVERLAY_COLOR_SPACE_SUPPORT_FLAG = (
        DXGI_OVERLAY_COLOR_SPACE_SUPPORT_FLAG_PRESENT = $1
        );


    IDXGIOutput4 = interface(IDXGIOutput3)
        ['{dc7dca35-2196-414d-9F53-617884032a60}']
        function CheckOverlayColorSpaceSupport(Format: TDXGI_FORMAT; ColorSpace: TDXGI_COLOR_SPACE_TYPE;
            pConcernedDevice: IUnknown; out pFlags: UINT): HRESULT; stdcall;
    end;


    IDXGIFactory4 = interface(IDXGIFactory3)
        ['{1bc6ea02-ef36-464f-bf0c-21ca39e5168a}']
        function EnumAdapterByLuid(AdapterLuid: LUID; const riid: TGUID; out ppvAdapter): HRESULT; stdcall;
        function EnumWarpAdapter(const riid: TGUID; out ppvAdapter): HRESULT; stdcall;
    end;


    TDXGI_MEMORY_SEGMENT_GROUP = (
        DXGI_MEMORY_SEGMENT_GROUP_LOCAL = 0,
        DXGI_MEMORY_SEGMENT_GROUP_NON_LOCAL = 1
        );


    TDXGI_QUERY_VIDEO_MEMORY_INFO = record
        Budget: UINT64;
        CurrentUsage: UINT64;
        AvailableForReservation: UINT64;
        CurrentReservation: UINT64;
    end;


    IDXGIAdapter3 = interface(IDXGIAdapter2)
        ['{645967A4-1392-4310-A798-8053CE3E93FD}']
        function RegisterHardwareContentProtectionTeardownStatusEvent(hEvent: THANDLE; out pdwCookie: DWORD): HRESULT; stdcall;
        procedure UnregisterHardwareContentProtectionTeardownStatus(dwCookie: DWORD); stdcall;
        function QueryVideoMemoryInfo(NodeIndex: UINT; MemorySegmentGroup: TDXGI_MEMORY_SEGMENT_GROUP;
            out pVideoMemoryInfo: TDXGI_QUERY_VIDEO_MEMORY_INFO): HRESULT; stdcall;
        function SetVideoMemoryReservation(NodeIndex: UINT; MemorySegmentGroup: TDXGI_MEMORY_SEGMENT_GROUP;
            Reservation: UINT64): HRESULT; stdcall;
        function RegisterVideoMemoryBudgetChangeNotificationEvent(hEvent: THANDLE; out pdwCookie: DWORD): HRESULT; stdcall;
        procedure UnregisterVideoMemoryBudgetChangeNotification(dwCookie: DWORD); stdcall;
    end;


implementation

end.
