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
   File name:  dxgi1_4.h
   Header version: 10.0.26100.6584
   
  ************************************************************************** }
unit DX12.DXGI1_4;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    ActiveX,
    DX12.DXGIFormat,
    DX12.DXGICommon,
    DX12.DXGI1_2,
    DX12.DXGI1_3;

    {$Z4}

const


    IID_IDXGISwapChain3: TGUID = '{94D99BDB-F1F8-4AB0-B236-7DA0170EDAB1}';
    IID_IDXGIOutput4: TGUID = '{DC7DCA35-2196-414D-9F53-617884032A60}';
    IID_IDXGIFactory4: TGUID = '{1BC6EA02-EF36-464F-BF0C-21CA39E5168A}';
    IID_IDXGIAdapter3: TGUID = '{645967A4-1392-4310-A798-8053CE3E93FD}';



type
    PIUnknown = ^IUnknown;

    IDXGISwapChain3 = interface;
    IDXGIOutput4 = interface;
    IDXGIFactory4 = interface;
    IDXGIAdapter3 = interface;


    TDXGI_SWAP_CHAIN_COLOR_SPACE_SUPPORT_FLAG = (
        DXGI_SWAP_CHAIN_COLOR_SPACE_SUPPORT_FLAG_PRESENT = $1,
        DXGI_SWAP_CHAIN_COLOR_SPACE_SUPPORT_FLAG_OVERLAY_PRESENT = $2
        );

    PDXGI_SWAP_CHAIN_COLOR_SPACE_SUPPORT_FLAG = ^TDXGI_SWAP_CHAIN_COLOR_SPACE_SUPPORT_FLAG;

    IDXGISwapChain3 = interface(IDXGISwapChain2)
        ['{94d99bdb-f1f8-4ab0-b236-7da0170edab1}']
        function GetCurrentBackBufferIndex(): UINT; stdcall;

        function CheckColorSpaceSupport(
        {_In_} ColorSpace: TDXGI_COLOR_SPACE_TYPE;
        {_Out_} pColorSpaceSupport: PUINT): HRESULT; stdcall;

        function SetColorSpace1(
        {_In_} ColorSpace: TDXGI_COLOR_SPACE_TYPE): HRESULT; stdcall;

        function ResizeBuffers1(
        {_In_} BufferCount: UINT;
        {_In_} Width: UINT;
        {_In_} Height: UINT;
        {_In_} Format: TDXGI_FORMAT;
        {_In_} SwapChainFlags: UINT;
        {_In_reads_(BufferCount)} pCreationNodeMask: PUINT;
        {_In_reads_(BufferCount)} ppPresentQueue: PIUnknown): HRESULT; stdcall;

    end;




    TDXGI_OVERLAY_COLOR_SPACE_SUPPORT_FLAG = (
        DXGI_OVERLAY_COLOR_SPACE_SUPPORT_FLAG_PRESENT = $1
        );

    PDXGI_OVERLAY_COLOR_SPACE_SUPPORT_FLAG = ^TDXGI_OVERLAY_COLOR_SPACE_SUPPORT_FLAG;

    IDXGIOutput4 = interface(IDXGIOutput3)
        ['{dc7dca35-2196-414d-9F53-617884032a60}']
        function CheckOverlayColorSpaceSupport(
        {_In_} Format: TDXGI_FORMAT;
        {_In_} ColorSpace: TDXGI_COLOR_SPACE_TYPE;
        {_In_} pConcernedDevice: IUnknown;
        {_Out_} pFlags: PUINT): HRESULT; stdcall;

    end;




    IDXGIFactory4 = interface(IDXGIFactory3)
        ['{1bc6ea02-ef36-464f-bf0c-21ca39e5168a}']
        function EnumAdapterByLuid(
        {_In_} AdapterLuid: TLUID;
        {_In_} riid: TREFIID;
        {_COM_Outptr_} out ppvAdapter): HRESULT; stdcall;

        function EnumWarpAdapter(
        {_In_} riid: TREFIID;
        {_COM_Outptr_} out ppvAdapter): HRESULT; stdcall;

    end;




    TDXGI_MEMORY_SEGMENT_GROUP = (
        DXGI_MEMORY_SEGMENT_GROUP_LOCAL = 0,
        DXGI_MEMORY_SEGMENT_GROUP_NON_LOCAL = 1
        );


    PDXGI_MEMORY_SEGMENT_GROUP = ^TDXGI_MEMORY_SEGMENT_GROUP;

    TDXGI_QUERY_VIDEO_MEMORY_INFO = record
        Budget: uint64;
        CurrentUsage: uint64;
        AvailableForReservation: uint64;
        CurrentReservation: uint64;
    end;

    PDXGI_QUERY_VIDEO_MEMORY_INFO = ^TDXGI_QUERY_VIDEO_MEMORY_INFO;

    IDXGIAdapter3 = interface(IDXGIAdapter2)
        ['{645967A4-1392-4310-A798-8053CE3E93FD}']
        function RegisterHardwareContentProtectionTeardownStatusEvent(
        {_In_} hEvent: HANDLE;
        {_Out_} pdwCookie: PDWORD): HRESULT; stdcall;

        procedure UnregisterHardwareContentProtectionTeardownStatus(
        {_In_} dwCookie: DWORD); stdcall;

        function QueryVideoMemoryInfo(
        {_In_} NodeIndex: UINT;
        {_In_} MemorySegmentGroup: TDXGI_MEMORY_SEGMENT_GROUP;
        {_Out_} pVideoMemoryInfo: PDXGI_QUERY_VIDEO_MEMORY_INFO): HRESULT; stdcall;

        function SetVideoMemoryReservation(
        {_In_} NodeIndex: UINT;
        {_In_} MemorySegmentGroup: TDXGI_MEMORY_SEGMENT_GROUP;
        {_In_} Reservation: uint64): HRESULT; stdcall;

        function RegisterVideoMemoryBudgetChangeNotificationEvent(
        {_In_} hEvent: HANDLE;
        {_Out_} pdwCookie: PDWORD): HRESULT; stdcall;

        procedure UnregisterVideoMemoryBudgetChangeNotification(
        {_In_} dwCookie: DWORD); stdcall;

    end;




implementation


end.
