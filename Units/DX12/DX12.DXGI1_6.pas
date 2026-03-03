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
   File name: dxgi1_6.h
   Header version: 10.0.26100.6584
   
  ************************************************************************** }
unit DX12.DXGI1_6;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.DXGIType,
    DX12.DXGICommon,
    DX12.DXGI1_2,
    DX12.DXGI1_4,
    DX12.DXGI1_5;

    {$Z4}

const

    IID_IDXGIAdapter4: TGUID = '{3C8D99D1-4FBF-4181-A82C-AF66BF7BD24E}';
    IID_IDXGIOutput6: TGUID = '{068346E8-AAEC-4B84-ADD7-137F513F77A1}';
    IID_IDXGIFactory6: TGUID = '{C1B6694F-FF09-44A9-B03C-77900A0A1D17}';
    IID_IDXGIFactory7: TGUID = '{A4966EED-76DB-44DA-84C1-EE9A7AFB20A8}';




type
    REFIID = ^TGUID;

    IDXGIAdapter4 = interface;
    IDXGIOutput6 = interface;
    IDXGIFactory6 = interface;
    IDXGIFactory7 = interface;



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


    PDXGI_ADAPTER_FLAG3 = ^TDXGI_ADAPTER_FLAG3;

    TDXGI_ADAPTER_DESC3 = record
        Description: array [0..127] of WCHAR;
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




    PDXGI_ADAPTER_DESC3 = ^TDXGI_ADAPTER_DESC3;

    IDXGIAdapter4 = interface(IDXGIAdapter3)
        ['{3c8d99d1-4fbf-4181-a82c-af66bf7bd24e}']
        function GetDesc3(
        {_Out_} pDesc: PDXGI_ADAPTER_DESC3): HRESULT; stdcall;

    end;




    TDXGI_OUTPUT_DESC1 = record
        DeviceName: array [0..31] of WCHAR;
        DesktopCoordinates: RECT;
        AttachedToDesktop: boolean;
        Rotation: TDXGI_MODE_ROTATION;
        Monitor: HMONITOR;
        BitsPerColor: UINT;
        ColorSpace: TDXGI_COLOR_SPACE_TYPE;
        RedPrimary: array [0..1] of single;
        GreenPrimary: array [0..1] of single;
        BluePrimary: array [0..1] of single;
        WhitePoint: array [0..1] of single;
        MinLuminance: single;
        MaxLuminance: single;
        MaxFullFrameLuminance: single;
    end;


    PDXGI_OUTPUT_DESC1 = ^TDXGI_OUTPUT_DESC1;
    TDXGI_HARDWARE_COMPOSITION_SUPPORT_FLAGS = (
        DXGI_HARDWARE_COMPOSITION_SUPPORT_FLAG_FULLSCREEN = 1,
        DXGI_HARDWARE_COMPOSITION_SUPPORT_FLAG_WINDOWED = 2,
        DXGI_HARDWARE_COMPOSITION_SUPPORT_FLAG_CURSOR_STRETCHED = 4
        );


    PDXGI_HARDWARE_COMPOSITION_SUPPORT_FLAGS = ^TDXGI_HARDWARE_COMPOSITION_SUPPORT_FLAGS;

    IDXGIOutput6 = interface(IDXGIOutput5)
        ['{068346e8-aaec-4b84-add7-137f513f77a1}']
        function GetDesc1(
        {_Out_} pDesc: PDXGI_OUTPUT_DESC1): HRESULT; stdcall;

        function CheckHardwareCompositionSupport(
        {_Out_} pFlags: PUINT): HRESULT; stdcall;

    end;




    TDXGI_GPU_PREFERENCE = (
        DXGI_GPU_PREFERENCE_UNSPECIFIED = 0,
        DXGI_GPU_PREFERENCE_MINIMUM_POWER = (DXGI_GPU_PREFERENCE_UNSPECIFIED + 1),
        DXGI_GPU_PREFERENCE_HIGH_PERFORMANCE = (DXGI_GPU_PREFERENCE_MINIMUM_POWER + 1)
        );




    PDXGI_GPU_PREFERENCE = ^TDXGI_GPU_PREFERENCE;

    IDXGIFactory6 = interface(IDXGIFactory5)
        ['{c1b6694f-ff09-44a9-b03c-77900a0a1d17}']
        function EnumAdapterByGpuPreference(
        {_In_} Adapter: UINT;
        {_In_} GpuPreference: TDXGI_GPU_PREFERENCE;
        {_In_} riid: REFIID;
        {_COM_Outptr_} out ppvAdapter): HRESULT; stdcall;

    end;




    IDXGIFactory7 = interface(IDXGIFactory6)
        ['{a4966eed-76db-44da-84c1-ee9a7afb20a8}']
        function RegisterAdaptersChangedEvent(
        {_In_} hEvent: HANDLE;
        {_Out_} pdwCookie: PDWORD): HRESULT; stdcall;

        function UnregisterAdaptersChangedEvent(
        {_In_} dwCookie: DWORD): HRESULT; stdcall;

    end;




function DXGIDeclareAdapterRemovalSupport(): HRESULT; stdcall; external 'Dxgi.dll';

function DXGIDisableVBlankVirtualization(): HRESULT; stdcall; external 'dxgi.dll';


implementation


end.
