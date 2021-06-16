{ **************************************************************************
  FreePascal/Delphi DirectX 12 Header Files
  
  Copyright 2013-2021 Norbert Sonnleitner

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

  Copyright (c) Microsoft Corporation.  All rights reserved.

  This unit consists of the following header files
  File name: DXGI1_6.h
  Header version: 10.0.19041.0

  ************************************************************************** }
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
    IID_IDXGIFactory7: TGUID = '{a4966eed-76db-44da-84c1-ee9a7afb20a8}';
	
	DXGI1_6_DLL ='dxgi.dll';

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

    IDXGIFactory7 = interface(IDXGIFactory6)
        ['{a4966eed-76db-44da-84c1-ee9a7afb20a8}']
        function RegisterAdaptersChangedEvent(hEvent: THANDLE; out pdwCookie: DWORD): HRESULT; stdcall;
        function UnregisterAdaptersChangedEvent(dwCookie: DWORD): HRESULT; stdcall;
    end;




function DXGIDeclareAdapterRemovalSupport(): HRESULT; stdcall; external DXGI1_6_DLL;

implementation

end.

