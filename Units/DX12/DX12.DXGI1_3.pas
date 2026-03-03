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
   File name: dxgi1_3.h
   Header version: 10.0.26100.6584
   
  ************************************************************************** }
unit DX12.DXGI1_3;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.DXGI,
    DX12.DXGIFormat,
    DX12.DXGI1_2;

    {$Z4}

const

    DXGI_CREATE_FACTORY_DEBUG = $1;


    IID_IDXGIDevice3: TGUID = '{6007896C-3244-4AFD-BF18-A6D3BEDA5023}';
    IID_IDXGISwapChain2: TGUID = '{A8BE2AC4-199F-4946-B331-79599FB98DE7}';
    IID_IDXGIOutput2: TGUID = '{595E39D1-2724-4663-99B1-DA969DE28364}';
    IID_IDXGIFactory3: TGUID = '{25483823-CD46-4C7D-86CA-47AA95B837BD}';
    IID_IDXGIDecodeSwapChain: TGUID = '{2633066B-4514-4C7A-8FD8-12EA98059D18}';
    IID_IDXGIFactoryMedia: TGUID = '{41E7D1F2-A591-4F7B-A2E5-FA9C843E1C12}';
    IID_IDXGISwapChainMedia: TGUID = '{DD95B90B-F05F-4F6A-BD65-25BFB264BD84}';
    IID_IDXGIOutput3: TGUID = '{8A6BB301-7E7E-41F4-A8E0-5B32F7F99B18}';




type
    REFIID = ^TGUID;

    IDXGIDevice3 = interface;
    IDXGISwapChain2 = interface;
    IDXGIOutput2 = interface;
    IDXGIFactory3 = interface;
    IDXGIDecodeSwapChain = interface;
    IDXGIFactoryMedia = interface;
    IDXGISwapChainMedia = interface;
    IDXGIOutput3 = interface;

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
    PDXGI_MATRIX_3X2_F = ^TDXGI_MATRIX_3X2_F;

    IDXGISwapChain2 = interface(IDXGISwapChain1)
        ['{a8be2ac4-199f-4946-b331-79599fb98de7}']
        function SetSourceSize(Width: UINT; Height: UINT): HRESULT; stdcall;

        function GetSourceSize(
        {_Out_} pWidth: PUINT;
        {_Out_} pHeight: PUINT): HRESULT; stdcall;

        function SetMaximumFrameLatency(MaxLatency: UINT): HRESULT; stdcall;

        function GetMaximumFrameLatency(
        {_Out_} pMaxLatency: PUINT): HRESULT; stdcall;

        function GetFrameLatencyWaitableObject(): HANDLE; stdcall;

        function SetMatrixTransform(pMatrix: PDXGI_MATRIX_3X2_F): HRESULT; stdcall;

        function GetMatrixTransform(
        {_Out_} pMatrix: PDXGI_MATRIX_3X2_F): HRESULT; stdcall;

    end;




    IDXGIOutput2 = interface(IDXGIOutput1)
        ['{595e39d1-2724-4663-99b1-da969de28364}']
        function SupportsOverlays(): boolean; stdcall;
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

    PDXGI_MULTIPLANE_OVERLAY_YCbCr_FLAGS = ^TDXGI_MULTIPLANE_OVERLAY_YCbCr_FLAGS;

    IDXGIDecodeSwapChain = interface(IUnknown)
        ['{2633066b-4514-4c7a-8fd8-12ea98059d18}']
        function PresentBuffer(BufferToPresent: UINT; SyncInterval: UINT; Flags: UINT): HRESULT; stdcall;

        function SetSourceRect(pRect: PRECT): HRESULT; stdcall;

        function SetTargetRect(pRect: PRECT): HRESULT; stdcall;

        function SetDestSize(Width: UINT; Height: UINT): HRESULT; stdcall;

        function GetSourceRect(
        {_Out_} pRect: PRECT): HRESULT; stdcall;

        function GetTargetRect(
        {_Out_} pRect: PRECT): HRESULT; stdcall;

        function GetDestSize(
        {_Out_} pWidth: PUINT;
        {_Out_} pHeight: PUINT): HRESULT; stdcall;

        function SetColorSpace(ColorSpace: TDXGI_MULTIPLANE_OVERLAY_YCbCr_FLAGS): HRESULT; stdcall;

        function GetColorSpace(): TDXGI_MULTIPLANE_OVERLAY_YCbCr_FLAGS; stdcall;

    end;




    IDXGIFactoryMedia = interface(IUnknown)
        ['{41e7d1f2-a591-4f7b-a2e5-fa9c843e1c12}']
        function CreateSwapChainForCompositionSurfaceHandle(
        {_In_} pDevice: IUnknown;
        {_In_opt_} hSurface: HANDLE;
        {_In_} pDesc: PDXGI_SWAP_CHAIN_DESC1;
        {_In_opt_} pRestrictToOutput: IDXGIOutput;
        {_COM_Outptr_} out ppSwapChain: IDXGISwapChain1): HRESULT; stdcall;

        function CreateDecodeSwapChainForCompositionSurfaceHandle(
        {_In_} pDevice: IUnknown;
        {_In_opt_} hSurface: HANDLE;
        {_In_} pDesc: PDXGI_DECODE_SWAP_CHAIN_DESC;
        {_In_} pYuvDecodeBuffers: IDXGIResource;
        {_In_opt_} pRestrictToOutput: IDXGIOutput;
        {_COM_Outptr_} out ppSwapChain: IDXGIDecodeSwapChain): HRESULT; stdcall;

    end;




    TDXGI_FRAME_PRESENTATION_MODE = (
        DXGI_FRAME_PRESENTATION_MODE_COMPOSED = 0,
        DXGI_FRAME_PRESENTATION_MODE_OVERLAY = 1,
        DXGI_FRAME_PRESENTATION_MODE_NONE = 2,
        DXGI_FRAME_PRESENTATION_MODE_COMPOSITION_FAILURE = 3
        );


    PDXGI_FRAME_PRESENTATION_MODE = ^TDXGI_FRAME_PRESENTATION_MODE;

    TDXGI_FRAME_STATISTICS_MEDIA = record
        PresentCount: UINT;
        PresentRefreshCount: UINT;
        SyncRefreshCount: UINT;
        SyncQPCTime: LARGE_INTEGER;
        SyncGPUTime: LARGE_INTEGER;
        CompositionMode: TDXGI_FRAME_PRESENTATION_MODE;
        ApprovedPresentDuration: UINT;
    end;




    PDXGI_FRAME_STATISTICS_MEDIA = ^TDXGI_FRAME_STATISTICS_MEDIA;

    IDXGISwapChainMedia = interface(IUnknown)
        ['{dd95b90b-f05f-4f6a-bd65-25bfb264bd84}']
        function GetFrameStatisticsMedia(
        {_Out_} pStats: PDXGI_FRAME_STATISTICS_MEDIA): HRESULT; stdcall;

        function SetPresentDuration(Duration: UINT): HRESULT; stdcall;

        function CheckPresentDurationSupport(DesiredPresentDuration: UINT;
        {_Out_} pClosestSmallerPresentDuration: PUINT;
        {_Out_} pClosestLargerPresentDuration: PUINT): HRESULT; stdcall;

    end;




    TDXGI_OVERLAY_SUPPORT_FLAG = (
        DXGI_OVERLAY_SUPPORT_FLAG_DIRECT = $1,
        DXGI_OVERLAY_SUPPORT_FLAG_SCALING = $2
        );


    PDXGI_OVERLAY_SUPPORT_FLAG = ^TDXGI_OVERLAY_SUPPORT_FLAG;

    IDXGIOutput3 = interface(IDXGIOutput2)
        ['{8a6bb301-7e7e-41F4-a8e0-5b32f7f99b18}']
        function CheckOverlaySupport(
        {_In_} EnumFormat: TDXGI_FORMAT;
        {_In_} pConcernedDevice: IUnknown;
        {_Out_} pFlags: PUINT): HRESULT; stdcall;

    end;




function CreateDXGIFactory2(Flags: UINT; riid: REFIID;
    {_COM_Outptr_} out ppFactory): HRESULT; stdcall; external 'Dxgi.dll';

function DXGIGetDebugInterface1(Flags: UINT; riid: REFIID;
    {_COM_Outptr_} out pDebug): HRESULT; stdcall; external 'Dxgi.dll';



implementation


end.
