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
   File name: dxgi1_2.h
   Header version: 10.0.26100.6584
   
  ************************************************************************** }
unit DX12.DXGI1_2;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$ENDIF}

{$Z4}

interface

uses
    Windows, Classes, SysUtils,
    ActiveX,
    DX12.DXGI,
    DX12.DXGICommon,
    DX12.DXGIFormat,
    DX12.DXGIType;

const
    DXGI_ENUM_MODES_STEREO = (4);
    DXGI_ENUM_MODES_DISABLED_STEREO = (8);
    DXGI_SHARED_RESOURCE_READ = ($80000000);
    DXGI_SHARED_RESOURCE_WRITE = (1);


    IID_IDXGIDisplayControl: TGUID = '{EA9DBF1A-C88E-4486-854A-98AA0138F30C}';
    IID_IDXGIOutputDuplication: TGUID = '{191CFAC3-A341-470D-B26E-A864F428319C}';
    IID_IDXGISurface2: TGUID = '{ABA496DD-B617-4CB8-A866-BC44D7EB1FA2}';
    IID_IDXGIResource1: TGUID = '{30961379-4609-4A41-998E-54FE567EE0C1}';
    IID_IDXGIDevice2: TGUID = '{05008617-FBFD-4051-A790-144884B4F6A9}';
    IID_IDXGISwapChain1: TGUID = '{790A45F7-0D42-4876-983A-0A55CFE6F4AA}';
    IID_IDXGIFactory2: TGUID = '{50C83A1C-E072-4C48-87B0-3630FA36A6D0}';
    IID_IDXGIAdapter2: TGUID = '{0AA1AE0A-FA0E-4B84-8644-E05FF8E5ACB5}';
    IID_IDXGIOutput1: TGUID = '{00CDDEA8-939B-4B83-A340-A685226666CC}';




type
    PSECURITY_ATTRIBUTES = ^SECURITY_ATTRIBUTES; // Missing in Winapi.Windows or Windows;

    IDXGIDisplayControl = interface;
    IDXGIOutputDuplication = interface;
    IDXGISurface2 = interface;
    IDXGIResource1 = interface;
    IDXGIDevice2 = interface;
    IDXGISwapChain1 = interface;
    IDXGIFactory2 = interface;
    IDXGIAdapter2 = interface;
    IDXGIOutput1 = interface;

    IDXGIDisplayControl = interface(IUnknown)
        ['{ea9dbf1a-c88e-4486-854a-98aa0138f30c}']
        function IsStereoEnabled(): boolean; stdcall;
        procedure SetStereoEnabled(Enabled: boolean); stdcall;
    end;




    TDXGI_OUTDUPL_MOVE_RECT = record
        SourcePoint: TPOINT;
        DestinationRect: TRECT;
    end;
    PDXGI_OUTDUPL_MOVE_RECT = ^TDXGI_OUTDUPL_MOVE_RECT;


    TDXGI_OUTDUPL_DESC = record
        ModeDesc: TDXGI_MODE_DESC;
        Rotation: TDXGI_MODE_ROTATION;
        DesktopImageInSystemMemory: boolean;
    end;
    PDXGI_OUTDUPL_DESC = ^TDXGI_OUTDUPL_DESC;


    TDXGI_OUTDUPL_POINTER_POSITION = record
        Position: TPOINT;
        Visible: boolean;
    end;
    PDXGI_OUTDUPL_POINTER_POSITION = ^TDXGI_OUTDUPL_POINTER_POSITION;


    TDXGI_OUTDUPL_POINTER_SHAPE_TYPE = (
        DXGI_OUTDUPL_POINTER_SHAPE_TYPE_MONOCHROME = $1,
        DXGI_OUTDUPL_POINTER_SHAPE_TYPE_COLOR = $2,
        DXGI_OUTDUPL_POINTER_SHAPE_TYPE_MASKED_COLOR = $4
        );


    TDXGI_OUTDUPL_POINTER_SHAPE_INFO = record
        _Type: UINT;
        Width: UINT;
        Height: UINT;
        Pitch: UINT;
        HotSpot: TPOINT;
    end;
    PDXGI_OUTDUPL_POINTER_SHAPE_INFO = ^TDXGI_OUTDUPL_POINTER_SHAPE_INFO;


    TDXGI_OUTDUPL_FRAME_INFO = record
        LastPresentTime: LARGE_INTEGER;
        LastMouseUpdateTime: LARGE_INTEGER;
        AccumulatedFrames: UINT;
        RectsCoalesced: boolean;
        ProtectedContentMaskedOut: boolean;
        PointerPosition: TDXGI_OUTDUPL_POINTER_POSITION;
        TotalMetadataBufferSize: UINT;
        PointerShapeBufferSize: UINT;
    end;
    PDXGI_OUTDUPL_FRAME_INFO = ^TDXGI_OUTDUPL_FRAME_INFO;




    IDXGIOutputDuplication = interface(IDXGIObject)
        ['{191cfac3-a341-470d-b26e-a864f428319c}']
        procedure GetDesc(
        {_Out_} pDesc: PDXGI_OUTDUPL_DESC); stdcall;

        function AcquireNextFrame(
        {_In_} TimeoutInMilliseconds: UINT;
        {_Out_} pFrameInfo: PDXGI_OUTDUPL_FRAME_INFO;
        {_COM_Outptr_} out ppDesktopResource: IDXGIResource): HRESULT; stdcall;

        function GetFrameDirtyRects(
        {_In_} DirtyRectsBufferSize: UINT;
        {_Out_writes_bytes_to_(DirtyRectsBufferSize, *pDirtyRectsBufferSizeRequired)} pDirtyRectsBuffer: PRECT;
        {_Out_} pDirtyRectsBufferSizeRequired: PUINT): HRESULT; stdcall;

        function GetFrameMoveRects(
        {_In_} MoveRectsBufferSize: UINT;
        {_Out_writes_bytes_to_(MoveRectsBufferSize, *pMoveRectsBufferSizeRequired)} pMoveRectBuffer: PDXGI_OUTDUPL_MOVE_RECT;
        {_Out_} pMoveRectsBufferSizeRequired: PUINT): HRESULT; stdcall;

        function GetFramePointerShape(
        {_In_} PointerShapeBufferSize: UINT;
        {_Out_writes_bytes_to_(PointerShapeBufferSize, *pPointerShapeBufferSizeRequired)} pPointerShapeBuffer: pointer;
        {_Out_} pPointerShapeBufferSizeRequired: PUINT;
        {_Out_} pPointerShapeInfo: PDXGI_OUTDUPL_POINTER_SHAPE_INFO): HRESULT; stdcall;

        function MapDesktopSurface(
        {_Out_} pLockedRect: PDXGI_MAPPED_RECT): HRESULT; stdcall;

        function UnMapDesktopSurface(): HRESULT; stdcall;

        function ReleaseFrame(): HRESULT; stdcall;

    end;




    TDXGI_ALPHA_MODE = (
        DXGI_ALPHA_MODE_UNSPECIFIED = 0,
        DXGI_ALPHA_MODE_PREMULTIPLIED = 1,
        DXGI_ALPHA_MODE_STRAIGHT = 2,
        DXGI_ALPHA_MODE_IGNORE = 3,
        DXGI_ALPHA_MODE_FORCE_DWORD = longint($ffffffff)
        );




    IDXGISurface2 = interface(IDXGISurface1)
        ['{aba496dd-b617-4cb8-a866-bc44d7eb1fa2}']
        function GetResource(
        {_In_} riid: TREFIID;
        {_COM_Outptr_} out ppParentResource;
        {_Out_} pSubresourceIndex: PUINT): HRESULT; stdcall;

    end;




    IDXGIResource1 = interface(IDXGIResource)
        ['{30961379-4609-4a41-998e-54fe567ee0c1}']
        function CreateSubresourceSurface(index: UINT;
        {_COM_Outptr_} out ppSurface: IDXGISurface2): HRESULT; stdcall;

        function CreateSharedHandle(
        {_In_opt_} pAttributes: PSECURITY_ATTRIBUTES;
        {_In_} dwAccess: DWORD;
        {_In_opt_} lpName: PCWSTR;
        {_Out_} pHandle: PHANDLE): HRESULT; stdcall;

    end;




    T_DXGI_OFFER_RESOURCE_PRIORITY = (
        DXGI_OFFER_RESOURCE_PRIORITY_LOW = 1,
        DXGI_OFFER_RESOURCE_PRIORITY_NORMAL = (DXGI_OFFER_RESOURCE_PRIORITY_LOW + 1),
        DXGI_OFFER_RESOURCE_PRIORITY_HIGH = (DXGI_OFFER_RESOURCE_PRIORITY_NORMAL + 1)
        );

    TDXGI_OFFER_RESOURCE_PRIORITY = T_DXGI_OFFER_RESOURCE_PRIORITY;




    IDXGIDevice2 = interface(IDXGIDevice1)
        ['{05008617-fbfd-4051-a790-144884b4f6a9}']
        function OfferResources(
        {_In_} NumResources: UINT;
        {_In_reads_(NumResources)} ppResources: PIDXGIResource;
        {_In_} Priority: TDXGI_OFFER_RESOURCE_PRIORITY): HRESULT; stdcall;

        function ReclaimResources(
        {_In_} NumResources: UINT;
        {_In_reads_(NumResources)} ppResources: PIDXGIResource;
        {_Out_writes_all_opt_(NumResources)} pDiscarded: Pboolean): HRESULT; stdcall;

        function EnqueueSetEvent(
        {_In_} hEvent: HANDLE): HRESULT; stdcall;

    end;




    TDXGI_MODE_DESC1 = record
        Width: UINT;
        Height: UINT;
        RefreshRate: TDXGI_RATIONAL;
        Format: TDXGI_FORMAT;
        ScanlineOrdering: TDXGI_MODE_SCANLINE_ORDER;
        Scaling: TDXGI_MODE_SCALING;
        Stereo: boolean;
    end;
    PDXGI_MODE_DESC1 = ^TDXGI_MODE_DESC1;


    TDXGI_SCALING = (
        DXGI_SCALING_STRETCH = 0,
        DXGI_SCALING_NONE = 1,
        DXGI_SCALING_ASPECT_RATIO_STRETCH = 2
        );


    { TDXGI_SWAP_CHAIN_DESC1 }

    TDXGI_SWAP_CHAIN_DESC1 = record
        Width: UINT;
        Height: UINT;
        Format: TDXGI_FORMAT;
        Stereo: boolean;
        SampleDesc: TDXGI_SAMPLE_DESC;
        BufferUsage: TDXGI_USAGE;
        BufferCount: UINT;
        Scaling: TDXGI_SCALING;
        SwapEffect: TDXGI_SWAP_EFFECT;
        AlphaMode: TDXGI_ALPHA_MODE;
        Flags: UINT;
        class operator Initialize(var A: TDXGI_SWAP_CHAIN_DESC1);
    end;
    PDXGI_SWAP_CHAIN_DESC1 = ^TDXGI_SWAP_CHAIN_DESC1;


    TDXGI_SWAP_CHAIN_FULLSCREEN_DESC = record
        RefreshRate: TDXGI_RATIONAL;
        ScanlineOrdering: TDXGI_MODE_SCANLINE_ORDER;
        Scaling: TDXGI_MODE_SCALING;
        Windowed: boolean;
    end;
    PDXGI_SWAP_CHAIN_FULLSCREEN_DESC = ^TDXGI_SWAP_CHAIN_FULLSCREEN_DESC;


    TDXGI_PRESENT_PARAMETERS = record
        DirtyRectsCount: UINT;
        pDirtyRects: PRECT;
        pScrollRect: PRECT;
        pScrollOffset: PPOINT;
    end;
    PDXGI_PRESENT_PARAMETERS = ^TDXGI_PRESENT_PARAMETERS;



    IDXGISwapChain1 = interface(IDXGISwapChain)
        ['{790a45f7-0d42-4876-983a-0a55cfe6f4aa}']
        function GetDesc1(
        {_Out_} pDesc: PDXGI_SWAP_CHAIN_DESC1): HRESULT; stdcall;

        function GetFullscreenDesc(
        {_Out_} pDesc: PDXGI_SWAP_CHAIN_FULLSCREEN_DESC): HRESULT; stdcall;

        function GetHwnd(
        {_Out_} pHwnd: PHWND): HRESULT; stdcall;

        function GetCoreWindow(
        {_In_} refiid: TREFIID;
        {_COM_Outptr_} out ppUnk): HRESULT; stdcall;

        function Present1(SyncInterval: UINT; PresentFlags: UINT;
        {_In_} pPresentParameters: PDXGI_PRESENT_PARAMETERS): HRESULT; stdcall;

        function IsTemporaryMonoSupported(): boolean; stdcall;

        function GetRestrictToOutput(
        {_Out_} out ppRestrictToOutput: IDXGIOutput): HRESULT; stdcall;

        function SetBackgroundColor(
        {_In_} pColor: PDXGI_RGBA): HRESULT; stdcall;

        function GetBackgroundColor(
        {_Out_} pColor: PDXGI_RGBA): HRESULT; stdcall;

        function SetRotation(
        {_In_} Rotation: TDXGI_MODE_ROTATION): HRESULT; stdcall;

        function GetRotation(
        {_Out_} pRotation: PDXGI_MODE_ROTATION): HRESULT; stdcall;

    end;




    IDXGIFactory2 = interface(IDXGIFactory1)
        ['{50c83a1c-e072-4c48-87b0-3630fa36a6d0}']
        function IsWindowedStereoEnabled(): boolean; stdcall;

        function CreateSwapChainForHwnd(
        {_In_} pDevice: IUnknown;
        {_In_} hWnd: HWND;
        {_In_} pDesc: PDXGI_SWAP_CHAIN_DESC1;
        {_In_opt_} pFullscreenDesc: PDXGI_SWAP_CHAIN_FULLSCREEN_DESC;
        {_In_opt_} pRestrictToOutput: IDXGIOutput;
        {_COM_Outptr_} out ppSwapChain: IDXGISwapChain1): HRESULT; stdcall;

        function CreateSwapChainForCoreWindow(
        {_In_} pDevice: IUnknown;
        {_In_} pWindow: IUnknown;
        {_In_} pDesc: PDXGI_SWAP_CHAIN_DESC1;
        {_In_opt_} pRestrictToOutput: IDXGIOutput;
        {_COM_Outptr_} out ppSwapChain: IDXGISwapChain1): HRESULT; stdcall;

        function GetSharedResourceAdapterLuid(
        {_In_} hResource: HANDLE;
        {_Out_} pLuid: PLUID): HRESULT; stdcall;

        function RegisterStereoStatusWindow(
        {_In_} WindowHandle: HWND;
        {_In_} wMsg: UINT;
        {_Out_} pdwCookie: PDWORD): HRESULT; stdcall;

        function RegisterStereoStatusEvent(
        {_In_} hEvent: HANDLE;
        {_Out_} pdwCookie: PDWORD): HRESULT; stdcall;

        procedure UnregisterStereoStatus(
        {_In_} dwCookie: DWORD); stdcall;

        function RegisterOcclusionStatusWindow(
        {_In_} WindowHandle: HWND;
        {_In_} wMsg: UINT;
        {_Out_} pdwCookie: PDWORD): HRESULT; stdcall;

        function RegisterOcclusionStatusEvent(
        {_In_} hEvent: HANDLE;
        {_Out_} pdwCookie: PDWORD): HRESULT; stdcall;

        procedure UnregisterOcclusionStatus(
        {_In_} dwCookie: DWORD); stdcall;

        function CreateSwapChainForComposition(
        {_In_} pDevice: IUnknown;
        {_In_} pDesc: PDXGI_SWAP_CHAIN_DESC1;
        {_In_opt_} pRestrictToOutput: IDXGIOutput;
        {_COM_Outptr_} out ppSwapChain: IDXGISwapChain1): HRESULT; stdcall;

    end;




    TDXGI_GRAPHICS_PREEMPTION_GRANULARITY = (
        DXGI_GRAPHICS_PREEMPTION_DMA_BUFFER_BOUNDARY = 0,
        DXGI_GRAPHICS_PREEMPTION_PRIMITIVE_BOUNDARY = 1,
        DXGI_GRAPHICS_PREEMPTION_TRIANGLE_BOUNDARY = 2,
        DXGI_GRAPHICS_PREEMPTION_PIXEL_BOUNDARY = 3,
        DXGI_GRAPHICS_PREEMPTION_INSTRUCTION_BOUNDARY = 4
        );


    TDXGI_COMPUTE_PREEMPTION_GRANULARITY = (
        DXGI_COMPUTE_PREEMPTION_DMA_BUFFER_BOUNDARY = 0,
        DXGI_COMPUTE_PREEMPTION_DISPATCH_BOUNDARY = 1,
        DXGI_COMPUTE_PREEMPTION_THREAD_GROUP_BOUNDARY = 2,
        DXGI_COMPUTE_PREEMPTION_THREAD_BOUNDARY = 3,
        DXGI_COMPUTE_PREEMPTION_INSTRUCTION_BOUNDARY = 4
        );


    TDXGI_ADAPTER_DESC2 = record
        Description: array [0..127] of WCHAR;
        VendorId: UINT;
        DeviceId: UINT;
        SubSysId: UINT;
        Revision: UINT;
        DedicatedVideoMemory: SIZE_T;
        DedicatedSystemMemory: SIZE_T;
        SharedSystemMemory: SIZE_T;
        AdapterLuid: LUID;
        Flags: UINT;
        GraphicsPreemptionGranularity: TDXGI_GRAPHICS_PREEMPTION_GRANULARITY;
        ComputePreemptionGranularity: TDXGI_COMPUTE_PREEMPTION_GRANULARITY;
    end;
    PDXGI_ADAPTER_DESC2 = ^TDXGI_ADAPTER_DESC2;




    IDXGIAdapter2 = interface(IDXGIAdapter1)
        ['{0AA1AE0A-FA0E-4B84-8644-E05FF8E5ACB5}']
        function GetDesc2(
        {_Out_} pDesc: PDXGI_ADAPTER_DESC2): HRESULT; stdcall;
    end;




    IDXGIOutput1 = interface(IDXGIOutput)
        ['{00cddea8-939b-4b83-a340-a685226666cc}']
        function GetDisplayModeList1(EnumFormat: TDXGI_FORMAT; Flags: UINT;
        {_Inout_} pNumModes: PUINT;
        {_Out_writes_to_opt_(*pNumModes,*pNumModes)} pDesc: PDXGI_MODE_DESC1): HRESULT; stdcall;

        function FindClosestMatchingMode1(
        {_In_} pModeToMatch: PDXGI_MODE_DESC1;
        {_Out_} pClosestMatch: PDXGI_MODE_DESC1;
        {_In_opt_} pConcernedDevice: IUnknown): HRESULT; stdcall;

        function GetDisplaySurfaceData1(
        {_In_} pDestination: IDXGIResource): HRESULT; stdcall;

        function DuplicateOutput(
        {_In_} pDevice: IUnknown;
        {_COM_Outptr_} out ppOutputDuplication: IDXGIOutputDuplication): HRESULT; stdcall;
    end;




implementation


{ TDXGI_SWAP_CHAIN_DESC1 }

class operator TDXGI_SWAP_CHAIN_DESC1.Initialize(var A: TDXGI_SWAP_CHAIN_DESC1);
begin
  ZeroMemory(@a,SizeOf(TDXGI_SWAP_CHAIN_DESC1));
end;

end.
