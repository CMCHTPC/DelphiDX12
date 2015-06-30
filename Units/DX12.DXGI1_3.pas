unit DX12.DXGI1_3;

{$IFDEF FPC}
{$MODE delphi}{$H+}
{$ENDIF}


interface

{$Z4}

uses
    Windows, Classes, SysUtils, DX12.DXGI, DX12.DXGI1_2;

const
    DLL_DXGI = 'dxgi.dll';

    DXGI_CREATE_FACTORY_DEBUG = $1;

    IID_IDXGIDevice3: TGUID = '{6007896c-3244-4afd-bf18-a6d3beda5023}';
    IID_IDXGISwapChain2: TGUID = '{a8be2ac4-199f-4946-b331-79599fb98de7}';
    IID_IDXGIOutput2: TGUID = '{595e39d1-2724-4663-99b1-da969de28364}';
    IID_IDXGIFactory3: TGUID = '{25483823-cd46-4c7d-86ca-47aa95b837bd}';
    IID_IDXGIDecodeSwapChain: TGUID = '{2633066b-4514-4c7a-8fd8-12ea98059d18}';
    IID_IDXGIFactoryMedia: TGUID = '{41e7d1f2-a591-4f7b-a2e5-fa9c843e1c12}';
    IID_IDXGISwapChainMedia: TGUID = '{dd95b90b-f05f-4f6a-bd65-25bfb264bd84}';
    IID_IDXGIOutput3: TGUID = '{8a6bb301-7e7e-41F4-a8e0-5b32f7f99b18}';


type


    IDXGIDevice3 = interface(IDXGIDevice2)
        ['{6007896c-3244-4afd-bf18-a6d3beda5023}']
        procedure Trim(); stdcall;
    end;


    TDXGI_MATRIX_3X2_F = record
        _11: single;
        _12: single;
        _21: single;
        _22: single;
        _31: single;
        _32: single;
    end;
    PDXGI_MATRIX_3X2_F = ^  TDXGI_MATRIX_3X2_F;


    IDXGISwapChain2 = interface(IDXGISwapChain1)
        ['{a8be2ac4-199f-4946-b331-79599fb98de7}']
        function SetSourceSize(Width: UINT; Height: UINT): HResult; stdcall;
        function GetSourceSize(out pWidth: UINT; out pHeight: UINT): HResult; stdcall;
        function SetMaximumFrameLatency(MaxLatency: UINT): HResult; stdcall;
        function GetMaximumFrameLatency(out pMaxLatency: UINT): HResult; stdcall;
        function GetFrameLatencyWaitableObject(): THANDLE; stdcall;
        function SetMatrixTransform(pMatrix: PDXGI_MATRIX_3X2_F): HResult; stdcall;
        function GetMatrixTransform(out pMatrix: TDXGI_MATRIX_3X2_F): HResult; stdcall;
    end;


    IDXGIOutput2 = interface(IDXGIOutput1)
        ['{595e39d1-2724-4663-99b1-da969de28364}']
        function SupportsOverlays(): longbool; stdcall;
    end;


    IDXGIFactory3 = interface(IDXGIFactory2)
        ['{25483823-cd46-4c7d-86ca-47aa95b837bd}']
        function GetCreationFlags(): UINT; stdcall;
    end;


    TDXGI_DECODE_SWAP_CHAIN_DESC = record
        Flags: UINT;
    end;
    PDXGI_DECODE_SWAP_CHAIN_DESC = ^TDXGI_DECODE_SWAP_CHAIN_DESC;

    TDXGI_MULTIPLANE_OVERLAY_YCbCr_FLAGS = (
        DXGI_MULTIPLANE_OVERLAY_YCbCr_FLAG_NOMINAL_RANGE = $1,
        DXGI_MULTIPLANE_OVERLAY_YCbCr_FLAG_BT709 = $2,
        DXGI_MULTIPLANE_OVERLAY_YCbCr_FLAG_xvYCC = $4
        );


    IDXGIDecodeSwapChain = interface(IUnknown)
        ['{2633066b-4514-4c7a-8fd8-12ea98059d18}']
        function PresentBuffer(BufferToPresent: UINT; SyncInterval: UINT; Flags: UINT): HResult; stdcall;
        function SetSourceRect(pRect: PRECT): HResult; stdcall;
        function SetTargetRect(pRect: PRECT): HResult; stdcall;
        function SetDestSize(Width: UINT; Height: UINT): HResult; stdcall;
        function GetSourceRect(out pRect: TRECT): HResult; stdcall;
        function GetTargetRect(out pRect: TRECT): HResult; stdcall;
        function GetDestSize(out pWidth: UINT; out pHeight: UINT): HResult; stdcall;
        function SetColorSpace(ColorSpace: TDXGI_MULTIPLANE_OVERLAY_YCbCr_FLAGS): HResult; stdcall;
        function GetColorSpace(): TDXGI_MULTIPLANE_OVERLAY_YCbCr_FLAGS; stdcall;
    end;


    IDXGIFactoryMedia = interface(IUnknown)
        ['{41e7d1f2-a591-4f7b-a2e5-fa9c843e1c12}']
        function CreateSwapChainForCompositionSurfaceHandle(pDevice: IUnknown; hSurface: THANDLE;
            pDesc: PDXGI_SWAP_CHAIN_DESC1; pRestrictToOutput: IDXGIOutput; out ppSwapChain: IDXGISwapChain1): HResult; stdcall;
        function CreateDecodeSwapChainForCompositionSurfaceHandle(pDevice: IUnknown; hSurface: THANDLE;
            pDesc: PDXGI_DECODE_SWAP_CHAIN_DESC; pYuvDecodeBuffers: IDXGIResource; pRestrictToOutput: IDXGIOutput;
            out ppSwapChain: IDXGIDecodeSwapChain): HResult; stdcall;
    end;


    TDXGI_FRAME_PRESENTATION_MODE = (
        DXGI_FRAME_PRESENTATION_MODE_COMPOSED = 0,
        DXGI_FRAME_PRESENTATION_MODE_OVERLAY = 1,
        DXGI_FRAME_PRESENTATION_MODE_NONE = 2,
        DXGI_FRAME_PRESENTATION_MODE_COMPOSITION_FAILURE = 3
        );

    TDXGI_FRAME_STATISTICS_MEDIA = record
        PresentCount: UINT;
        PresentRefreshCount: UINT;
        SyncRefreshCount: UINT;
        SyncQPCTime: LARGE_INTEGER;
        SyncGPUTime: LARGE_INTEGER;
        CompositionMode: TDXGI_FRAME_PRESENTATION_MODE;
        ApprovedPresentDuration: UINT;
    end;


    IDXGISwapChainMedia = interface(IUnknown)
        ['{dd95b90b-f05f-4f6a-bd65-25bfb264bd84}']
        function GetFrameStatisticsMedia(out pStats: TDXGI_FRAME_STATISTICS_MEDIA): HResult; stdcall;
        function SetPresentDuration(Duration: UINT): HResult; stdcall;
        function CheckPresentDurationSupport(DesiredPresentDuration: UINT; out pClosestSmallerPresentDuration: UINT;
            out pClosestLargerPresentDuration: UINT): HResult; stdcall;
    end;


    TDXGI_OVERLAY_SUPPORT_FLAG = (
        DXGI_OVERLAY_SUPPORT_FLAG_DIRECT = $1,
        DXGI_OVERLAY_SUPPORT_FLAG_SCALING = $2
        );


    IDXGIOutput3 = interface(IDXGIOutput2)
        ['{8a6bb301-7e7e-41F4-a8e0-5b32f7f99b18}']
        function CheckOverlaySupport(EnumFormat: TDXGI_FORMAT; pConcernedDevice: IUnknown; out pFlags: UINT): HResult; stdcall;
    end;

function CreateDXGIFactory2(Flags: UINT; riid: TGUID; out ppFactory: pointer): HResult; stdcall; external DLL_DXGI;
function DXGIGetDebugInterface1(Flags: UINT; riid: TGUID; out pDebug: pointer): HResult; stdcall; external DLL_DXGI;

implementation

end.


































































