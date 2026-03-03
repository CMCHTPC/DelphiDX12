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

   Copyright (C) Microsoft Corporation.  All Rights Reserved.
   Content:    Direct3D include file

   This unit consists of the following header files
   File name: d3d9.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3D9;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D9Types,
    DX12.D3D9Caps;

    {$Z4}

const
    D3D9_DLL = 'd3d9.dll';

const
  (* This identifier is passed to Direct3DCreate9 in order to ensure that an
 * application was built against the correct header files. This number is
 * incremented whenever a header (or other) change would require applications
 * to be rebuilt. If the version doesn't match, Direct3DCreate9 will fail.
 * (The number itself has no meaning.)*)

    DIRECT3D_VERSION = $0900;

    D3D_SDK_VERSION_DEBUG_INFO = (32 or $80000000);
    D3D9b_SDK_VERSION_DEBUG_INFO = (31 or $80000000);


    D3D_SDK_VERSION = 32;
    D3D9b_SDK_VERSION = 31;


    (* IID_IDirect3D9 *)
    (* {81BDCBCA-64D4-426d-AE8D-AD0147F4275C} *)
    IID_IDirect3D9: TGUID = '{81BDCBCA-64D4-426D-AE8D-AD0147F4275C}';

    (* IID_IDirect3DDevice9 *)
    // {D0223B96-BF7A-43fd-92BD-A43B0D82B9EB} */
    IID_IDirect3DDevice9: TGUID = '{D0223B96-BF7A-43FD-92BD-A43B0D82B9EB}';

    (* IID_IDirect3DResource9 *)
    // {05EEC05D-8F7D-4362-B999-D1BAF357C704}
    IID_IDirect3DResource9: TGUID = '{05EEC05D-8F7D-4362-B999-D1BAF357C704}';

    (* IID_IDirect3DBaseTexture9 *)
    (* {580CA87E-1D3C-4d54-991D-B7D3E3C298CE} *)
    IID_IDirect3DBaseTexture9: TGUID = '{580CA87E-1D3C-4D54-991D-B7D3E3C298CE}';

    (* IID_IDirect3DTexture9 *)
    (* {85C31227-3DE5-4f00-9B3A-F11AC38C18B5} *)
    IID_IDirect3DTexture9: TGUID = '{85C31227-3DE5-4F00-9B3A-F11AC38C18B5}';

    (* IID_IDirect3DCubeTexture9 *)
    (* {FFF32F81-D953-473a-9223-93D652ABA93F} *)
    IID_IDirect3DCubeTexture9: TGUID = '{FFF32F81-D953-473A-9223-93D652ABA93F}';

    (* IID_IDirect3DVolumeTexture9 *)
    (* {2518526C-E789-4111-A7B9-47EF328D13E6} *)
    IID_IDirect3DVolumeTexture9: TGUID = '{2518526C-E789-4111-A7B9-47EF328D13E6}';

    (* IID_IDirect3DVertexBuffer9 *)
    (* {B64BB1B5-FD70-4df6-BF91-19D0A12455E3} *)
    IID_IDirect3DVertexBuffer9: TGUID = '{B64BB1B5-FD70-4DF6-BF91-19D0A12455E3}';

    (* IID_IDirect3DIndexBuffer9 *)
    (* {7C9DD65E-D3F7-4529-ACEE-785830ACDE35} *)
    IID_IDirect3DIndexBuffer9: TGUID = '{7C9DD65E-D3F7-4529-ACEE-785830ACDE35}';

    (* IID_IDirect3DSurface9 *)
    (* {0CFBAF3A-9FF6-429a-99B3-A2796AF8B89B} *)
    IID_IDirect3DSurface9: TGUID = '{0CFBAF3A-9FF6-429A-99B3-A2796AF8B89B}';

    (* IID_IDirect3DVolume9 *)
    (* {24F416E6-1F67-4aa7-B88E-D33F6F3128A1} *)
    IID_IDirect3DVolume9: TGUID = '{24F416E6-1F67-4AA7-B88E-D33F6F3128A1}';

    (* IID_IDirect3DSwapChain9 *)
    (* {794950F2-ADFC-458a-905E-10A10B0B503B} *)
    IID_IDirect3DSwapChain9: TGUID = '{794950F2-ADFC-458A-905E-10A10B0B503B}';

    (* IID_IDirect3DVertexDeclaration9 *)
    (* {DD13C59C-36FA-4098-A8FB-C7ED39DC8546} *)
    IID_IDirect3DVertexDeclaration9: TGUID = '{DD13C59C-36FA-4098-A8FB-C7ED39DC8546}';

    (* IID_IDirect3DVertexShader9 *)
    (* {EFC5557E-6265-4613-8A94-43857889EB36} *)
    IID_IDirect3DVertexShader9: TGUID = '{EFC5557E-6265-4613-8A94-43857889EB36}';

    (* IID_IDirect3DPixelShader9 *)
    (* {6D3BDBDC-5B02-4415-B852-CE5E8BCCB289} *)
    IID_IDirect3DPixelShader9: TGUID = '{6D3BDBDC-5B02-4415-B852-CE5E8BCCB289}';

    (* IID_IDirect3DStateBlock9 *)
    (* {B07C4FE5-310D-4ba8-A23C-4F0F206F218B} *)
    IID_IDirect3DStateBlock9: TGUID = '{B07C4FE5-310D-4BA8-A23C-4F0F206F218B}';

    (* IID_IDirect3DQuery9 *)
    (* {d9771460-a695-4f26-bbd3-27b840b541cc} *)
    IID_IDirect3DQuery9: TGUID = '{D9771460-A695-4F26-BBD3-27B840B541CC}';


    (* IID_HelperName *)
    (* {E4A36723-FDFE-4b22-B146-3C04C07F4CC8} *)
    IID_HelperName: TGUID = '{E4A36723-FDFE-4B22-B146-3C04C07F4CC8}';

    (* D3D9Ex only -- *)
    (* IID_IDirect3D9Ex *)
    (* {02177241-69FC-400C-8FF1-93A44DF6861D} *)


    IID_IDirect3D9Ex: TGUID = '{02177241-69FC-400C-8FF1-93A44DF6861D}';

    (* IID_IDirect3DDevice9Ex *)
    // {B18B10CE-2649-405a-870F-95F777D4313A}
    IID_IDirect3DDevice9Ex: TGUID = '{B18B10CE-2649-405A-870F-95F777D4313A}';

    (* IID_IDirect3DSwapChain9Ex *)
    (* {91886CAF-1C3D-4d2e-A0AB-3E4C7D8D3303} *)
    IID_IDirect3DSwapChain9Ex: TGUID = '{91886CAF-1C3D-4D2E-A0AB-3E4C7D8D3303}';

    (* IID_IDirect3D9ExOverlayExtension *)
    (* {187aeb13-aaf5-4c59-876d-e059088c0df8} *)
    IID_IDirect3D9ExOverlayExtension: TGUID = '{187AEB13-AAF5-4C59-876D-E059088C0DF8}';

    (* IID_IDirect3DDevice9Video *)
    // {26DC4561-A1EE-4ae7-96DA-118A36C0EC95}
    IID_IDirect3DDevice9Video: TGUID = '{26DC4561-A1EE-4AE7-96DA-118A36C0EC95}';

    (* IID_IDirect3D9AuthenticatedChannel *)
    // {FF24BEEE-DA21-4beb-98B5-D2F899F98AF9}
    IID_IDirect3DAuthenticatedChannel9: TGUID = '{FF24BEEE-DA21-4BEB-98B5-D2F899F98AF9}';

    (* IID_IDirect3DCryptoSession9 *)
    // {FA0AB799-7A9C-48ca-8C5B-237E71A54434}
    IID_IDirect3DCryptoSession9: TGUID = '{FA0AB799-7A9C-48CA-8C5B-237E71A54434}';


    (* -- D3D9Ex only *)



(****************************************************************************
 * Flags for SetPrivateData method on all D3D9 interfaces
 *
 * The passed pointer is an IUnknown ptr. The SizeOfData argument to SetPrivateData
 * must be set to sizeof(IUnknown* ). Direct3D will call AddRef through this
 * pointer and Release when the private data is destroyed. The data will be
 * destroyed when another SetPrivateData with the same GUID is set, when
 * FreePrivateData is called, or when the D3D9 object is freed.
 ****************************************************************************)
    D3DSPD_IUNKNOWN = $00000001;

(****************************************************************************
 *
 * Flags for IDirect3D9::CreateDevice's BehaviorFlags
 *
 ****************************************************************************)

    D3DCREATE_FPU_PRESERVE = $00000002;
    D3DCREATE_MULTITHREADED = $00000004;

    D3DCREATE_PUREDEVICE = $00000010;
    D3DCREATE_SOFTWARE_VERTEXPROCESSING = $00000020;
    D3DCREATE_HARDWARE_VERTEXPROCESSING = $00000040;
    D3DCREATE_MIXED_VERTEXPROCESSING = $00000080;

    D3DCREATE_DISABLE_DRIVER_MANAGEMENT = $00000100;
    D3DCREATE_ADAPTERGROUP_DEVICE = $00000200;
    D3DCREATE_DISABLE_DRIVER_MANAGEMENT_EX = $00000400;

    // This flag causes the D3D runtime not to alter the focus
    // window in any way. Use with caution- the burden of supporting
    // focus management events (alt-tab, etc.) falls on the
    // application, and appropriate responses (switching display
    // mode, etc.) should be coded.
    D3DCREATE_NOWINDOWCHANGES = $00000800;

    (* D3D9Ex only -- *)
    // Disable multithreading for software vertex processing


    D3DCREATE_DISABLE_PSGP_THREADING = $00002000;
    // This flag enables present statistics on device.
    D3DCREATE_ENABLE_PRESENTSTATS = $00004000;
    // This flag disables printscreen support in the runtime for this device
    D3DCREATE_DISABLE_PRINTSCREEN = $00008000;

    D3DCREATE_SCREENSAVER = $10000000;

    (* -- D3D9Ex only *)



(****************************************************************************
 *
 * Parameter for IDirect3D9::CreateDevice's Adapter argument
 *
 ****************************************************************************)

    D3DADAPTER_DEFAULT = 0;

(****************************************************************************
 *
 * Flags for IDirect3D9::EnumAdapters
 *
 ****************************************************************************)
(*
 * The D3DENUM_WHQL_LEVEL value has been retired for 9Ex and future versions,
 * but it needs to be defined here for compatibility with DX9 and earlier versions.
 * See the DirectX SDK for sample code on discovering driver signatures.
 *)

    D3DENUM_WHQL_LEVEL = $00000002;

    (* D3D9Ex only -- *)
(* NO_DRIVERVERSION will not fill out the DriverVersion field, nor will the
   DriverVersion be incorporated into the DeviceIdentifier GUID. WINNT only *)


    D3DENUM_NO_DRIVERVERSION = $00000004;


    (* -- D3D9Ex only *)
(****************************************************************************
 *
 * Maximum number of back-buffers supported in DX9
 *
 ****************************************************************************)



    D3DPRESENT_BACK_BUFFERS_MAX = 3;

    (* D3D9Ex only -- *)
(****************************************************************************
 *
 * Maximum number of back-buffers supported when apps use CreateDeviceEx
 *
 ****************************************************************************)



    D3DPRESENT_BACK_BUFFERS_MAX_EX = 30;


    (* -- D3D9Ex only *)
(****************************************************************************
 *
 * Flags for IDirect3DDevice9::SetGammaRamp
 *
 ****************************************************************************)


    D3DSGR_NO_CALIBRATION = $00000000;
    D3DSGR_CALIBRATE = $00000001;

(****************************************************************************
 *
 * Flags for IDirect3DDevice9::SetCursorPosition
 *
 ****************************************************************************)

    D3DCURSOR_IMMEDIATE_UPDATE = $00000001;

(****************************************************************************
 *
 * Flags for IDirect3DSwapChain9::Present
 *
 ****************************************************************************)

    D3DPRESENT_DONOTWAIT = $00000001;
    D3DPRESENT_LINEAR_CONTENT = $00000002;

    (* D3D9Ex only -- *)


    D3DPRESENT_DONOTFLIP = $00000004;
    D3DPRESENT_FLIPRESTART = $00000008;
    D3DPRESENT_VIDEO_RESTRICT_TO_MONITOR = $00000010;
    D3DPRESENT_UPDATEOVERLAYONLY = $00000020;
    D3DPRESENT_HIDEOVERLAY = $00000040;
    D3DPRESENT_UPDATECOLORKEY = $00000080;
    D3DPRESENT_FORCEIMMEDIATE = $00000100;


    (* -- D3D9Ex only *)
(****************************************************************************
 *
 * Flags for DrawPrimitive/DrawIndexedPrimitive
 *   Also valid for Begin/BeginIndexed
 *   Also valid for VertexBuffer::CreateVertexBuffer
 ****************************************************************************)



(*
 *  DirectDraw error codes
 *)
    _FACD3D = $876;



(*
 * Direct3D Errors
 *)
    D3D_OK = S_OK;

    D3DERR_WRONGTEXTUREFORMAT = ((1 shl 31) or (_FACD3D shl 16) or (2072));
    D3DERR_UNSUPPORTEDCOLOROPERATION = ((1 shl 31) or (_FACD3D shl 16) or (2073));
    D3DERR_UNSUPPORTEDCOLORARG = ((1 shl 31) or (_FACD3D shl 16) or (2074));
    D3DERR_UNSUPPORTEDALPHAOPERATION = ((1 shl 31) or (_FACD3D shl 16) or (2075));
    D3DERR_UNSUPPORTEDALPHAARG = ((1 shl 31) or (_FACD3D shl 16) or (2076));
    D3DERR_TOOMANYOPERATIONS = ((1 shl 31) or (_FACD3D shl 16) or (2077));
    D3DERR_CONFLICTINGTEXTUREFILTER = ((1 shl 31) or (_FACD3D shl 16) or (2078));
    D3DERR_UNSUPPORTEDFACTORVALUE = ((1 shl 31) or (_FACD3D shl 16) or (2079));
    D3DERR_CONFLICTINGRENDERSTATE = ((1 shl 31) or (_FACD3D shl 16) or (2081));
    D3DERR_UNSUPPORTEDTEXTUREFILTER = ((1 shl 31) or (_FACD3D shl 16) or (2082));
    D3DERR_CONFLICTINGTEXTUREPALETTE = ((1 shl 31) or (_FACD3D shl 16) or (2086));
    D3DERR_DRIVERINTERNALERROR = ((1 shl 31) or (_FACD3D shl 16) or (2087));

    D3DERR_NOTFOUND = ((1 shl 31) or (_FACD3D shl 16) or (2150));
    D3DERR_MOREDATA = ((1 shl 31) or (_FACD3D shl 16) or (2151));
    D3DERR_DEVICELOST = ((1 shl 31) or (_FACD3D shl 16) or (2152));
    D3DERR_DEVICENOTRESET = ((1 shl 31) or (_FACD3D shl 16) or (2153));
    D3DERR_NOTAVAILABLE = ((1 shl 31) or (_FACD3D shl 16) or (2154));
    D3DERR_OUTOFVIDEOMEMORY = ((1 shl 31) or (_FACD3D shl 16) or (380));
    D3DERR_INVALIDDEVICE = ((1 shl 31) or (_FACD3D shl 16) or (2155));
    D3DERR_INVALIDCALL = ((1 shl 31) or (_FACD3D shl 16) or (2156));
    D3DERR_DRIVERINVALIDCALL = ((1 shl 31) or (_FACD3D shl 16) or (2157));
    D3DERR_WASSTILLDRAWING = ((1 shl 31) or (_FACD3D shl 16) or (540));
    D3DOK_NOAUTOGEN = ((0 shl 31) or (_FACD3D shl 16) or (2159));



    (* D3D9Ex only -- *)

    D3DERR_DEVICEREMOVED = ((1 shl 31) or (_FACD3D shl 16) or (2160));
    S_NOT_RESIDENT = ((0 shl 31) or (_FACD3D shl 16) or (2165));
    S_RESIDENT_IN_SHARED_MEMORY = ((0 shl 31) or (_FACD3D shl 16) or (2166));
    S_PRESENT_MODE_CHANGED = ((0 shl 31) or (_FACD3D shl 16) or (2167));
    S_PRESENT_OCCLUDED = ((0 shl 31) or (_FACD3D shl 16) or (2168));
    D3DERR_DEVICEHUNG = ((1 shl 31) or (_FACD3D shl 16) or (2164));
    D3DERR_UNSUPPORTEDOVERLAY = ((1 shl 31) or (_FACD3D shl 16) or (2171));
    D3DERR_UNSUPPORTEDOVERLAYFORMAT = ((1 shl 31) or (_FACD3D shl 16) or (2172));
    D3DERR_CANNOTPROTECTCONTENT = ((1 shl 31) or (_FACD3D shl 16) or (2173));
    D3DERR_UNSUPPORTEDCRYPTO = ((1 shl 31) or (_FACD3D shl 16) or (2174));
    D3DERR_PRESENT_STATISTICS_DISJOINT = ((1 shl 31) or (_FACD3D shl 16) or (2180));




type

    REFGUID = ^TGUID;
    REFIID = ^TGUID;
    PHDC = ^HDC;

    IDirect3D9 = interface;
    LPDIRECT3D9 = ^ IDirect3D9;
    PDIRECT3D9 = ^ IDirect3D9;

    IDirect3DDevice9 = interface;
    LPDIRECT3DDEVICE9 = ^IDirect3DDevice9;
    PDIRECT3DDEVICE9 = ^IDirect3DDevice9;



    IDirect3DStateBlock9 = interface;
    LPDIRECT3DSTATEBLOCK9 = ^IDirect3DStateBlock9;
    PDIRECT3DSTATEBLOCK9 = ^IDirect3DStateBlock9;


    IDirect3DVertexDeclaration9 = interface;
    LPDIRECT3DVERTEXDECLARATION9 = ^IDirect3DVertexDeclaration9;
    PDIRECT3DVERTEXDECLARATION9 = ^IDirect3DVertexDeclaration9;



    IDirect3DVertexShader9 = interface;
    LPDIRECT3DVERTEXSHADER9 = ^IDirect3DVertexShader9;
    PDIRECT3DVERTEXSHADER9 = ^IDirect3DVertexShader9;

    IDirect3DPixelShader9 = interface;
    LPDIRECT3DPIXELSHADER9 = ^IDirect3DPixelShader9;
    PDIRECT3DPIXELSHADER9 = ^IDirect3DPixelShader9;

    IDirect3DResource9 = interface;
    LPDIRECT3DRESOURCE9 = ^IDirect3DResource9;
    PDIRECT3DRESOURCE9 = ^IDirect3DResource9;
    PIDirect3DResource9 = ^IDirect3DResource9;

    IDirect3DBaseTexture9 = interface;
    LPDIRECT3DBASETEXTURE9 = ^IDirect3DBaseTexture9;
    PDIRECT3DBASETEXTURE9 = IDirect3DBaseTexture9;

    IDirect3DTexture9 = interface;
    LPDIRECT3DTEXTURE9 = ^IDirect3DTexture9;
    PDIRECT3DTEXTURE9 = ^IDirect3DTexture9;

    IDirect3DVolumeTexture9 = interface;
    LPDIRECT3DVOLUMETEXTURE9 = ^IDirect3DVolumeTexture9;
    PDIRECT3DVOLUMETEXTURE9 = ^IDirect3DVolumeTexture9;

    IDirect3DCubeTexture9 = interface;
    LPDIRECT3DCUBETEXTURE9 = IDirect3DCubeTexture9;
    PDIRECT3DCUBETEXTURE9 = ^IDirect3DCubeTexture9;

    IDirect3DVertexBuffer9 = interface;
    LPDIRECT3DVERTEXBUFFER9 = ^IDirect3DVertexBuffer9;
    PDIRECT3DVERTEXBUFFER9 = ^IDirect3DVertexBuffer9;

    IDirect3DIndexBuffer9 = interface;
    LPDIRECT3DINDEXBUFFER9 = ^IDirect3DIndexBuffer9;
    PDIRECT3DINDEXBUFFER9 = ^IDirect3DIndexBuffer9;

    IDirect3DSurface9 = interface;
    LPDIRECT3DSURFACE9 = ^IDirect3DSurface9;
    PDIRECT3DSURFACE9 = ^IDirect3DSurface9;

    IDirect3DVolume9 = interface;
    LPDIRECT3DVOLUME9 = ^IDirect3DVolume9;
    PDIRECT3DVOLUME9 = ^IDirect3DVolume9;

    IDirect3DSwapChain9 = interface;
    LPDIRECT3DSWAPCHAIN9 = ^IDirect3DSwapChain9;
    PDIRECT3DSWAPCHAIN9 = ^IDirect3DSwapChain9;


    IDirect3DQuery9 = interface;
    LPDIRECT3DQUERY9 = ^IDirect3DQuery9;
    PDIRECT3DQUERY9 = ^IDirect3DQuery9;


    (* D3D9Ex only -- *)




    IDirect3D9Ex = interface;
    LPDIRECT3D9EX = IDirect3D9Ex;
    PIDIRECT3D9EX = ^IDirect3D9Ex;

    IDirect3DDevice9Ex = interface;
    LPDIRECT3DDEVICE9EX = ^IDirect3DDevice9Ex;
    PDIRECT3DDEVICE9EX = ^IDirect3DDevice9Ex;


    IDirect3DSwapChain9Ex = interface;
    LPDIRECT3DSWAPCHAIN9EX = ^IDirect3DSwapChain9Ex;
    PDIRECT3DSWAPCHAIN9EX = ^IDirect3DSwapChain9Ex;

    IDirect3D9ExOverlayExtension = interface;
    LPDIRECT3D9EXOVERLAYEXTENSION = ^IDirect3D9ExOverlayExtension;
    PDIRECT3D9EXOVERLAYEXTENSION = ^IDirect3D9ExOverlayExtension;

    IDirect3DDevice9Video = interface;
    LPDIRECT3DDEVICE9VIDEO = ^IDirect3DDevice9Video;
    PDIRECT3DDEVICE9VIDEO = ^IDirect3DDevice9Video;

    IDirect3DAuthenticatedChannel9 = interface;
    LPDIRECT3DAUTHENTICATEDCHANNEL9 = ^IDirect3DAuthenticatedChannel9;
    PDIRECT3DAUTHENTICATEDCHANNEL9 = ^IDirect3DAuthenticatedChannel9;

    IDirect3DCryptoSession9 = interface;
    LPDIRECT3DCRYPTOSESSION9 = ^IDirect3DCryptoSession9;
    PDIRECT3DCRYPTOSESSION9 = ^IDirect3DCryptoSession9;


    (* -- D3D9Ex only *)




    IDirect3D9 = interface(IUnknown)
        ['{81BDCBCA-64D4-426D-AE8D-AD0147F4275C}']
        (*** IDirect3D9 methods ***)
        function RegisterSoftwareDevice(pInitializeFunction: pointer): HRESULT; stdcall;

        function GetAdapterCount(): UINT; stdcall;

        function GetAdapterIdentifier(Adapter: UINT; Flags: DWORD; pIdentifier: PD3DADAPTER_IDENTIFIER9): HRESULT; stdcall;

        function GetAdapterModeCount(Adapter: UINT; Format: TD3DFORMAT): UINT; stdcall;

        function EnumAdapterModes(Adapter: UINT; Format: TD3DFORMAT; Mode: UINT; pMode: PD3DDISPLAYMODE): HRESULT; stdcall;

        function GetAdapterDisplayMode(Adapter: UINT; pMode: PD3DDISPLAYMODE): HRESULT; stdcall;

        function CheckDeviceType(Adapter: UINT; DevType: TD3DDEVTYPE; AdapterFormat: TD3DFORMAT; BackBufferFormat: TD3DFORMAT; bWindowed: boolean): HRESULT; stdcall;

        function CheckDeviceFormat(Adapter: UINT; DeviceType: TD3DDEVTYPE; AdapterFormat: TD3DFORMAT; Usage: DWORD; RType: TD3DRESOURCETYPE; CheckFormat: TD3DFORMAT): HRESULT; stdcall;

        function CheckDeviceMultiSampleType(Adapter: UINT; DeviceType: TD3DDEVTYPE; SurfaceFormat: TD3DFORMAT; Windowed: boolean; MultiSampleType: TD3DMULTISAMPLE_TYPE; pQualityLevels: PDWORD): HRESULT; stdcall;

        function CheckDepthStencilMatch(Adapter: UINT; DeviceType: TD3DDEVTYPE; AdapterFormat: TD3DFORMAT; RenderTargetFormat: TD3DFORMAT; DepthStencilFormat: TD3DFORMAT): HRESULT; stdcall;

        function CheckDeviceFormatConversion(Adapter: UINT; DeviceType: TD3DDEVTYPE; SourceFormat: TD3DFORMAT; TargetFormat: TD3DFORMAT): HRESULT; stdcall;

        function GetDeviceCaps(Adapter: UINT; DeviceType: TD3DDEVTYPE; pCaps: PD3DCAPS9): HRESULT; stdcall;

        function GetAdapterMonitor(Adapter: UINT): HMONITOR; stdcall;

        function CreateDevice(Adapter: UINT; DeviceType: TD3DDEVTYPE; hFocusWindow: HWND; BehaviorFlags: DWORD; pPresentationParameters: PD3DPRESENT_PARAMETERS; out ppReturnedDeviceInterface: IDirect3DDevice9): HRESULT; stdcall;

    end;
    PIDirect3D9 = ^IDirect3D9;



    IDirect3DDevice9 = interface(IUnknown)
        ['{D0223B96-BF7A-43FD-92BD-A43B0D82B9EB}']

        (*** IDirect3DDevice9 methods ***)
        function TestCooperativeLevel(): HRESULT; stdcall;

        function GetAvailableTextureMem(): UINT; stdcall;

        function EvictManagedResources(): HRESULT; stdcall;

        function GetDirect3D(out ppD3D9: IDirect3D9): HRESULT; stdcall;

        function GetDeviceCaps(pCaps: PD3DCAPS9): HRESULT; stdcall;

        function GetDisplayMode(iSwapChain: UINT; pMode: PD3DDISPLAYMODE): HRESULT; stdcall;

        function GetCreationParameters(pParameters: PD3DDEVICE_CREATION_PARAMETERS): HRESULT; stdcall;

        function SetCursorProperties(XHotSpot: UINT; YHotSpot: UINT; pCursorBitmap: IDirect3DSurface9): HRESULT; stdcall;

        procedure SetCursorPosition(X: int32; Y: int32; Flags: DWORD); stdcall;

        function ShowCursor(bShow: boolean): boolean; stdcall;

        function CreateAdditionalSwapChain(pPresentationParameters: PD3DPRESENT_PARAMETERS; out pSwapChain: IDirect3DSwapChain9): HRESULT; stdcall;

        function GetSwapChain(iSwapChain: UINT; out pSwapChain: IDirect3DSwapChain9): HRESULT; stdcall;

        function GetNumberOfSwapChains(): UINT; stdcall;

        function Reset(pPresentationParameters: PD3DPRESENT_PARAMETERS): HRESULT; stdcall;

        function Present(pSourceRect: PRECT; pDestRect: PRECT; hDestWindowOverride: HWND; pDirtyRegion: PRGNDATA): HRESULT; stdcall;

        function GetBackBuffer(iSwapChain: UINT; iBackBuffer: UINT; BackBufferType: TD3DBACKBUFFER_TYPE; out ppBackBuffer: IDirect3DSurface9): HRESULT; stdcall;

        function GetRasterStatus(iSwapChain: UINT; pRasterStatus: PD3DRASTER_STATUS): HRESULT; stdcall;

        function SetDialogBoxMode(bEnableDialogs: boolean): HRESULT; stdcall;

        procedure SetGammaRamp(iSwapChain: UINT; Flags: DWORD; pRamp: PD3DGAMMARAMP); stdcall;

        procedure GetGammaRamp(iSwapChain: UINT; pRamp: PD3DGAMMARAMP); stdcall;

        function CreateTexture(Width: UINT; Height: UINT; Levels: UINT; Usage: DWORD; Format: TD3DFORMAT; Pool: TD3DPOOL; out ppTexture: IDirect3DTexture9; pSharedHandle: PHANDLE): HRESULT; stdcall;

        function CreateVolumeTexture(Width: UINT; Height: UINT; Depth: UINT; Levels: UINT; Usage: DWORD; Format: TD3DFORMAT; Pool: TD3DPOOL; out ppVolumeTexture: IDirect3DVolumeTexture9; pSharedHandle: PHANDLE): HRESULT; stdcall;

        function CreateCubeTexture(EdgeLength: UINT; Levels: UINT; Usage: DWORD; Format: TD3DFORMAT; Pool: TD3DPOOL; out ppCubeTexture: IDirect3DCubeTexture9; pSharedHandle: PHANDLE): HRESULT; stdcall;

        function CreateVertexBuffer(Length: UINT; Usage: DWORD; FVF: DWORD; Pool: TD3DPOOL; out ppVertexBuffer: IDirect3DVertexBuffer9; pSharedHandle: PHANDLE): HRESULT; stdcall;

        function CreateIndexBuffer(Length: UINT; Usage: DWORD; Format: TD3DFORMAT; Pool: TD3DPOOL; out ppIndexBuffer: IDirect3DIndexBuffer9; pSharedHandle: PHANDLE): HRESULT; stdcall;

        function CreateRenderTarget(Width: UINT; Height: UINT; Format: TD3DFORMAT; MultiSample: TD3DMULTISAMPLE_TYPE; MultisampleQuality: DWORD; Lockable: boolean; out ppSurface: IDirect3DSurface9;
            pSharedHandle: PHANDLE): HRESULT; stdcall;

        function CreateDepthStencilSurface(Width: UINT; Height: UINT; Format: TD3DFORMAT; MultiSample: TD3DMULTISAMPLE_TYPE; MultisampleQuality: DWORD; Discard: boolean;
            out ppSurface: IDirect3DSurface9; pSharedHandle: PHANDLE): HRESULT; stdcall;

        function UpdateSurface(pSourceSurface: IDirect3DSurface9; pSourceRect: PRECT; pDestinationSurface: IDirect3DSurface9; pDestPoint: PPOINT): HRESULT; stdcall;

        function UpdateTexture(pSourceTexture: IDirect3DBaseTexture9; pDestinationTexture: IDirect3DBaseTexture9): HRESULT; stdcall;

        function GetRenderTargetData(pRenderTarget: IDirect3DSurface9; pDestSurface: IDirect3DSurface9): HRESULT; stdcall;

        function GetFrontBufferData(iSwapChain: UINT; pDestSurface: IDirect3DSurface9): HRESULT; stdcall;

        function StretchRect(pSourceSurface: IDirect3DSurface9; pSourceRect: PRECT; pDestSurface: IDirect3DSurface9; pDestRect: PRECT; Filter: TD3DTEXTUREFILTERTYPE): HRESULT; stdcall;

        function ColorFill(pSurface: IDirect3DSurface9; pRect: PRECT; color: TD3DCOLOR): HRESULT; stdcall;

        function CreateOffscreenPlainSurface(Width: UINT; Height: UINT; Format: TD3DFORMAT; Pool: TD3DPOOL; out ppSurface: IDirect3DSurface9; pSharedHandle: PHANDLE): HRESULT; stdcall;

        function SetRenderTarget(RenderTargetIndex: DWORD; pRenderTarget: IDirect3DSurface9): HRESULT; stdcall;

        function GetRenderTarget(RenderTargetIndex: DWORD; out ppRenderTarget: IDirect3DSurface9): HRESULT; stdcall;

        function SetDepthStencilSurface(pNewZStencil: IDirect3DSurface9): HRESULT; stdcall;

        function GetDepthStencilSurface(out ppZStencilSurface: IDirect3DSurface9): HRESULT; stdcall;

        function BeginScene(): HRESULT; stdcall;

        function EndScene(): HRESULT; stdcall;

        function Clear(Count: DWORD; pRects: PD3DRECT; Flags: DWORD; Color: TD3DCOLOR; Z: single; Stencil: DWORD): HRESULT; stdcall;

        function SetTransform(State: TD3DTRANSFORMSTATETYPE; pMatrix: PD3DMATRIX): HRESULT; stdcall;

        function GetTransform(State: TD3DTRANSFORMSTATETYPE; pMatrix: PD3DMATRIX): HRESULT; stdcall;

        function MultiplyTransform(Nameless1: TD3DTRANSFORMSTATETYPE; Nameless2: PD3DMATRIX): HRESULT; stdcall;

        function SetViewport(pViewport: PD3DVIEWPORT9): HRESULT; stdcall;

        function GetViewport(pViewport: PD3DVIEWPORT9): HRESULT; stdcall;

        function SetMaterial(pMaterial: PD3DMATERIAL9): HRESULT; stdcall;

        function GetMaterial(pMaterial: PD3DMATERIAL9): HRESULT; stdcall;

        function SetLight(Index: DWORD; Nameless2: PD3DLIGHT9): HRESULT; stdcall;

        function GetLight(Index: DWORD; Nameless2: PD3DLIGHT9): HRESULT; stdcall;

        function LightEnable(Index: DWORD; Enable: boolean): HRESULT; stdcall;

        function GetLightEnable(Index: DWORD; pEnable: Pboolean): HRESULT; stdcall;

        function SetClipPlane(Index: DWORD; pPlane: Psingle): HRESULT; stdcall;

        function GetClipPlane(Index: DWORD; pPlane: Psingle): HRESULT; stdcall;

        function SetRenderState(State: TD3DRENDERSTATETYPE; Value: DWORD): HRESULT; stdcall;

        function GetRenderState(State: TD3DRENDERSTATETYPE; pValue: PDWORD): HRESULT; stdcall;

        function CreateStateBlock(StateBlockType: TD3DSTATEBLOCKTYPE; out ppSB: IDirect3DStateBlock9): HRESULT; stdcall;

        function BeginStateBlock(): HRESULT; stdcall;

        function EndStateBlock(out ppSB: IDirect3DStateBlock9): HRESULT; stdcall;

        function SetClipStatus(pClipStatus: PD3DCLIPSTATUS9): HRESULT; stdcall;

        function GetClipStatus(pClipStatus: PD3DCLIPSTATUS9): HRESULT; stdcall;

        function GetTexture(Stage: DWORD; out ppTexture: IDirect3DBaseTexture9): HRESULT; stdcall;

        function SetTexture(Stage: DWORD; pTexture: IDirect3DBaseTexture9): HRESULT; stdcall;

        function GetTextureStageState(Stage: DWORD; StageStateType: TD3DTEXTURESTAGESTATETYPE; pValue: PDWORD): HRESULT; stdcall;

        function SetTextureStageState(Stage: DWORD; StageStateType: TD3DTEXTURESTAGESTATETYPE; Value: DWORD): HRESULT; stdcall;

        function GetSamplerState(Sampler: DWORD; SamplerStateType: TD3DSAMPLERSTATETYPE; pValue: PDWORD): HRESULT; stdcall;

        function SetSamplerState(Sampler: DWORD; SamplerStateType: TD3DSAMPLERSTATETYPE; Value: DWORD): HRESULT; stdcall;

        function ValidateDevice(pNumPasses: PDWORD): HRESULT; stdcall;

        function SetPaletteEntries(PaletteNumber: UINT; pEntries: PPALETTEENTRY): HRESULT; stdcall;

        function GetPaletteEntries(PaletteNumber: UINT; pEntries: PPALETTEENTRY): HRESULT; stdcall;

        function SetCurrentTexturePalette(PaletteNumber: UINT): HRESULT; stdcall;

        function GetCurrentTexturePalette(PaletteNumber: PUINT): HRESULT; stdcall;

        function SetScissorRect(pRect: PRECT): HRESULT; stdcall;

        function GetScissorRect(pRect: PRECT): HRESULT; stdcall;

        function SetSoftwareVertexProcessing(bSoftware: boolean): HRESULT; stdcall;

        function GetSoftwareVertexProcessing(): boolean; stdcall;

        function SetNPatchMode(nSegments: single): HRESULT; stdcall;

        function GetNPatchMode(): single; stdcall;

        function DrawPrimitive(PrimitiveType: TD3DPRIMITIVETYPE; StartVertex: UINT; PrimitiveCount: UINT): HRESULT; stdcall;

        function DrawIndexedPrimitive(Nameless1: TD3DPRIMITIVETYPE; BaseVertexIndex: int32; MinVertexIndex: UINT; NumVertices: UINT; startIndex: UINT; primCount: UINT): HRESULT; stdcall;

        function DrawPrimitiveUP(PrimitiveType: TD3DPRIMITIVETYPE; PrimitiveCount: UINT; pVertexStreamZeroData: pointer; VertexStreamZeroStride: UINT): HRESULT; stdcall;

        function DrawIndexedPrimitiveUP(PrimitiveType: TD3DPRIMITIVETYPE; MinVertexIndex: UINT; NumVertices: UINT; PrimitiveCount: UINT; pIndexData: pointer; IndexDataFormat: TD3DFORMAT;
            pVertexStreamZeroData: pointer; VertexStreamZeroStride: UINT): HRESULT; stdcall;

        function ProcessVertices(SrcStartIndex: UINT; DestIndex: UINT; VertexCount: UINT; pDestBuffer: IDirect3DVertexBuffer9; pVertexDecl: IDirect3DVertexDeclaration9; Flags: DWORD): HRESULT; stdcall;

        function CreateVertexDeclaration(pVertexElements: PD3DVERTEXELEMENT9; out ppDecl: IDirect3DVertexDeclaration9): HRESULT; stdcall;

        function SetVertexDeclaration(pDecl: IDirect3DVertexDeclaration9): HRESULT; stdcall;

        function GetVertexDeclaration(out ppDecl: IDirect3DVertexDeclaration9): HRESULT; stdcall;

        function SetFVF(FVF: DWORD): HRESULT; stdcall;

        function GetFVF(pFVF: PDWORD): HRESULT; stdcall;

        function CreateVertexShader(pFunction: PDWORD; out ppShader: IDirect3DVertexShader9): HRESULT; stdcall;

        function SetVertexShader(pShader: IDirect3DVertexShader9): HRESULT; stdcall;

        function GetVertexShader(out ppShader: IDirect3DVertexShader9): HRESULT; stdcall;

        function SetVertexShaderConstantF(StartRegister: UINT; pConstantData: Psingle; Vector4fCount: UINT): HRESULT; stdcall;

        function GetVertexShaderConstantF(StartRegister: UINT; pConstantData: Psingle; Vector4fCount: UINT): HRESULT; stdcall;

        function SetVertexShaderConstantI(StartRegister: UINT; pConstantData: PINT32; Vector4iCount: UINT): HRESULT; stdcall;

        function GetVertexShaderConstantI(StartRegister: UINT; pConstantData: PINT32; Vector4iCount: UINT): HRESULT; stdcall;

        function SetVertexShaderConstantB(StartRegister: UINT; pConstantData: Pboolean; BoolCount: UINT): HRESULT; stdcall;

        function GetVertexShaderConstantB(StartRegister: UINT; pConstantData: Pboolean; BoolCount: UINT): HRESULT; stdcall;

        function SetStreamSource(StreamNumber: UINT; pStreamData: IDirect3DVertexBuffer9; OffsetInBytes: UINT; Stride: UINT): HRESULT; stdcall;

        function GetStreamSource(StreamNumber: UINT; out ppStreamData: IDirect3DVertexBuffer9; pOffsetInBytes: PUINT; pStride: PUINT): HRESULT; stdcall;

        function SetStreamSourceFreq(StreamNumber: UINT; Setting: UINT): HRESULT; stdcall;

        function GetStreamSourceFreq(StreamNumber: UINT; pSetting: PUINT): HRESULT; stdcall;

        function SetIndices(pIndexData: IDirect3DIndexBuffer9): HRESULT; stdcall;

        function GetIndices(out ppIndexData: IDirect3DIndexBuffer9): HRESULT; stdcall;

        function CreatePixelShader(pFunction: PDWORD; out ppShader: IDirect3DPixelShader9): HRESULT; stdcall;

        function SetPixelShader(pShader: IDirect3DPixelShader9): HRESULT; stdcall;

        function GetPixelShader(out ppShader: IDirect3DPixelShader9): HRESULT; stdcall;

        function SetPixelShaderConstantF(StartRegister: UINT; pConstantData: Psingle; Vector4fCount: UINT): HRESULT; stdcall;

        function GetPixelShaderConstantF(StartRegister: UINT; pConstantData: Psingle; Vector4fCount: UINT): HRESULT; stdcall;

        function SetPixelShaderConstantI(StartRegister: UINT; pConstantData: PINT32; Vector4iCount: UINT): HRESULT; stdcall;

        function GetPixelShaderConstantI(StartRegister: UINT; pConstantData: PINT32; Vector4iCount: UINT): HRESULT; stdcall;

        function SetPixelShaderConstantB(StartRegister: UINT; pConstantData: Pboolean; BoolCount: UINT): HRESULT; stdcall;

        function GetPixelShaderConstantB(StartRegister: UINT; pConstantData: Pboolean; BoolCount: UINT): HRESULT; stdcall;

        function DrawRectPatch(Handle: UINT; pNumSegs: Psingle; pRectPatchInfo: PD3DRECTPATCH_INFO): HRESULT; stdcall;

        function DrawTriPatch(Handle: UINT; pNumSegs: Psingle; pTriPatchInfo: PD3DTRIPATCH_INFO): HRESULT; stdcall;

        function DeletePatch(Handle: UINT): HRESULT; stdcall;

        function CreateQuery(QueryType: TD3DQUERYTYPE; out ppQuery: IDirect3DQuery9): HRESULT; stdcall;

    end;




    IDirect3DStateBlock9 = interface(IUnknown)
        ['{B07C4FE5-310D-4BA8-A23C-4F0F206F218B}']

        (*** IDirect3DStateBlock9 methods ***)
        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;

        function Capture(): HRESULT; stdcall;

        function Apply(): HRESULT; stdcall;

    end;


    IDirect3DSwapChain9 = interface(IUnknown)
        ['{794950F2-ADFC-458A-905E-10A10B0B503B}']
        (*** IDirect3DSwapChain9 methods ***)
        function Present(pSourceRect: PRECT; pDestRect: PRECT; hDestWindowOverride: HWND; pDirtyRegion: PRGNDATA; dwFlags: DWORD): HRESULT; stdcall;

        function GetFrontBufferData(pDestSurface: IDirect3DSurface9): HRESULT; stdcall;

        function GetBackBuffer(iBackBuffer: UINT; BackBufferType: TD3DBACKBUFFER_TYPE; out ppBackBuffer: IDirect3DSurface9): HRESULT; stdcall;

        function GetRasterStatus(pRasterStatus: PD3DRASTER_STATUS): HRESULT; stdcall;

        function GetDisplayMode(pMode: PD3DDISPLAYMODE): HRESULT; stdcall;

        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;

        function GetPresentParameters(pPresentationParameters: PD3DPRESENT_PARAMETERS): HRESULT; stdcall;

    end;


    IDirect3DResource9 = interface(IUnknown)
        ['{05EEC05D-8F7D-4362-B999-D1BAF357C704}']


        (*** IDirect3DResource9 methods ***)
        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;

        function SetPrivateData(refguid: REFGUID; pData: pointer; SizeOfData: DWORD; Flags: DWORD): HRESULT; stdcall;

        function GetPrivateData(refguid: REFGUID; pData: pointer; pSizeOfData: PDWORD): HRESULT; stdcall;

        function FreePrivateData(refguid: REFGUID): HRESULT; stdcall;

        function SetPriority(PriorityNew: DWORD): DWORD; stdcall;

        function GetPriority(): DWORD; stdcall;

        procedure PreLoad(); stdcall;

        function GetType(): TD3DRESOURCETYPE; stdcall;

    end;

    IDirect3DVertexDeclaration9 = interface(IUnknown)
        ['{DD13C59C-36FA-4098-A8FB-C7ED39DC8546}']

        (*** IDirect3DVertexDeclaration9 methods ***)
        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;

        function GetDeclaration(pElement: PD3DVERTEXELEMENT9; pNumElements: PUINT): HRESULT; stdcall;

    end;

    IDirect3DVertexShader9 = interface(IUnknown)
        ['{EFC5557E-6265-4613-8A94-43857889EB36}']


        (*** IDirect3DVertexShader9 methods ***)
        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;

        function GetFunction(Nameless1: pointer; pSizeOfData: PUINT): HRESULT; stdcall;

    end;


    IDirect3DPixelShader9 = interface(IUnknown)
        ['{6D3BDBDC-5B02-4415-B852-CE5E8BCCB289}']


        (*** IDirect3DPixelShader9 methods ***)
        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;

        function GetFunction(Nameless1: pointer; pSizeOfData: PUINT): HRESULT; stdcall;

    end;


    IDirect3DBaseTexture9 = interface(IDirect3DResource9)
        ['{580CA87E-1D3C-4D54-991D-B7D3E3C298CE}']

        (*** IDirect3DResource9 methods ***)
        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;

        function SetPrivateData(refguid: REFGUID; pData: pointer; SizeOfData: DWORD; Flags: DWORD): HRESULT; stdcall;

        function GetPrivateData(refguid: REFGUID; pData: pointer; pSizeOfData: PDWORD): HRESULT; stdcall;

        function FreePrivateData(refguid: REFGUID): HRESULT; stdcall;

        function SetPriority(PriorityNew: DWORD): DWORD; stdcall;

        function GetPriority(): DWORD; stdcall;

        procedure PreLoad(); stdcall;

        function GetType(): TD3DRESOURCETYPE; stdcall;

        function SetLOD(LODNew: DWORD): DWORD; stdcall;

        function GetLOD(): DWORD; stdcall;

        function GetLevelCount(): DWORD; stdcall;

        function SetAutoGenFilterType(FilterType: TD3DTEXTUREFILTERTYPE): HRESULT; stdcall;

        function GetAutoGenFilterType(): TD3DTEXTUREFILTERTYPE; stdcall;

        procedure GenerateMipSubLevels(); stdcall;

    end;


    IDirect3DTexture9 = interface(IDirect3DBaseTexture9)
        ['{85C31227-3DE5-4F00-9B3A-F11AC38C18B5}']
        function GetLevelDesc(Level: UINT; pDesc: PD3DSURFACE_DESC): HRESULT; stdcall;

        function GetSurfaceLevel(Level: UINT; out ppSurfaceLevel: IDirect3DSurface9): HRESULT; stdcall;

        function LockRect(Level: UINT; pLockedRect: PD3DLOCKED_RECT; pRect: PRECT; Flags: DWORD): HRESULT; stdcall;

        function UnlockRect(Level: UINT): HRESULT; stdcall;

        function AddDirtyRect(pDirtyRect: PRECT): HRESULT; stdcall;

    end;


    IDirect3DVolumeTexture9 = interface(IDirect3DBaseTexture9)
        ['{2518526C-E789-4111-A7B9-47EF328D13E6}']
        function GetLevelDesc(Level: UINT; pDesc: PD3DVOLUME_DESC): HRESULT; stdcall;

        function GetVolumeLevel(Level: UINT; out ppVolumeLevel: IDirect3DVolume9): HRESULT; stdcall;

        function LockBox(Level: UINT; pLockedVolume: PD3DLOCKED_BOX; pBox: PD3DBOX; Flags: DWORD): HRESULT; stdcall;

        function UnlockBox(Level: UINT): HRESULT; stdcall;

        function AddDirtyBox(pDirtyBox: PD3DBOX): HRESULT; stdcall;

    end;


    IDirect3DCubeTexture9 = interface(IDirect3DBaseTexture9)
        ['{FFF32F81-D953-473A-9223-93D652ABA93F}']
        function GetLevelDesc(Level: UINT; pDesc: PD3DSURFACE_DESC): HRESULT; stdcall;

        function GetCubeMapSurface(FaceType: TD3DCUBEMAP_FACES; Level: UINT; out ppCubeMapSurface: IDirect3DSurface9): HRESULT; stdcall;

        function LockRect(FaceType: TD3DCUBEMAP_FACES; Level: UINT; pLockedRect: PD3DLOCKED_RECT; pRect: PRECT; Flags: DWORD): HRESULT; stdcall;

        function UnlockRect(FaceType: TD3DCUBEMAP_FACES; Level: UINT): HRESULT; stdcall;

        function AddDirtyRect(FaceType: TD3DCUBEMAP_FACES; pDirtyRect: PRECT): HRESULT; stdcall;

    end;



    IDirect3DVertexBuffer9 = interface(IDirect3DResource9)
        ['{B64BB1B5-FD70-4DF6-BF91-19D0A12455E3}']
        function Lock(OffsetToLock: UINT; SizeToLock: UINT; out ppbData: pointer; Flags: DWORD): HRESULT; stdcall;

        function Unlock(): HRESULT; stdcall;

        function GetDesc(pDesc: PD3DVERTEXBUFFER_DESC): HRESULT; stdcall;

    end;


    IDirect3DIndexBuffer9 = interface(IDirect3DResource9)
        ['{7C9DD65E-D3F7-4529-ACEE-785830ACDE35}']
        function Lock(OffsetToLock: UINT; SizeToLock: UINT; out ppbData: pointer; Flags: DWORD): HRESULT; stdcall;

        function Unlock(): HRESULT; stdcall;

        function GetDesc(pDesc: PD3DINDEXBUFFER_DESC): HRESULT; stdcall;

    end;

    IDirect3DSurface9 = interface(IDirect3DResource9)
        ['{0CFBAF3A-9FF6-429A-99B3-A2796AF8B89B}']
        function GetContainer(riid: REFIID; out ppContainer: pointer): HRESULT; stdcall;

        function GetDesc(pDesc: PD3DSURFACE_DESC): HRESULT; stdcall;

        function LockRect(pLockedRect: PD3DLOCKED_RECT; pRect: PRECT; Flags: DWORD): HRESULT; stdcall;

        function UnlockRect(): HRESULT; stdcall;

        function GetDC(phdc: PHDC): HRESULT; stdcall;

        function ReleaseDC(hdc: HDC): HRESULT; stdcall;

    end;



    IDirect3DVolume9 = interface(IUnknown)
        ['{24F416E6-1F67-4AA7-B88E-D33F6F3128A1}']
        (*** IDirect3DVolume9 methods ***)
        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;

        function SetPrivateData(refguid: REFGUID; pData: Pvoid; SizeOfData: DWORD; Flags: DWORD): HRESULT; stdcall;

        function GetPrivateData(refguid: REFGUID; pData: Pvoid; pSizeOfData: PDWORD): HRESULT; stdcall;

        function FreePrivateData(refguid: REFGUID): HRESULT; stdcall;

        function GetContainer(riid: REFIID; out ppContainer: pointer): HRESULT; stdcall;

        function GetDesc(pDesc: PD3DVOLUME_DESC): HRESULT; stdcall;

        function LockBox(pLockedVolume: PD3DLOCKED_BOX; pBox: PD3DBOX; Flags: DWORD): HRESULT; stdcall;

        function UnlockBox(): HRESULT; stdcall;

    end;



    IDirect3DQuery9 = interface(IUnknown)
        ['{D9771460-A695-4F26-BBD3-27B840B541CC}']
        (*** IDirect3DQuery9 methods ***)
        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;

        function GetType(): TD3DQUERYTYPE; stdcall;

        function GetDataSize(): DWORD; stdcall;

        function Issue(dwIssueFlags: DWORD): HRESULT; stdcall;

        function GetData(pData: Pvoid; dwSize: DWORD; dwGetDataFlags: DWORD): HRESULT; stdcall;

    end;



    IDirect3D9Ex = interface(IDirect3D9)
        ['{02177241-69FC-400C-8FF1-93A44DF6861D}']
        function GetAdapterModeCountEx(Adapter: UINT; pFilter: PD3DDISPLAYMODEFILTER): UINT; stdcall;

        function EnumAdapterModesEx(Adapter: UINT; pFilter: PD3DDISPLAYMODEFILTER; Mode: UINT; pMode: PD3DDISPLAYMODEEX): HRESULT; stdcall;

        function GetAdapterDisplayModeEx(Adapter: UINT; pMode: PD3DDISPLAYMODEEX; pRotation: PD3DDISPLAYROTATION): HRESULT; stdcall;

        function CreateDeviceEx(Adapter: UINT; DeviceType: TD3DDEVTYPE; hFocusWindow: HWND; BehaviorFlags: DWORD; pPresentationParameters: PD3DPRESENT_PARAMETERS; pFullscreenDisplayMode: PD3DDISPLAYMODEEX;
            out ppReturnedDeviceInterface: IDirect3DDevice9Ex): HRESULT; stdcall;

        function GetAdapterLUID(Adapter: UINT; pLUID: PLUID): HRESULT; stdcall;

    end;


    IDirect3DDevice9Ex = interface(IDirect3DDevice9)
        ['{B18B10CE-2649-405A-870F-95F777D4313A}']
        function SetConvolutionMonoKernel(Width: UINT; Height: UINT; rows: Psingle; columns: Psingle): HRESULT; stdcall;

        function ComposeRects(pSrc: IDirect3DSurface9; pDst: IDirect3DSurface9; pSrcRectDescs: IDirect3DVertexBuffer9; NumRects: UINT; pDstRectDescs: IDirect3DVertexBuffer9;
            Operation: TD3DCOMPOSERECTSOP; Xoffset: int32; Yoffset: int32): HRESULT; stdcall;

        function PresentEx(pSourceRect: PRECT; pDestRect: PRECT; hDestWindowOverride: HWND; pDirtyRegion: PRGNDATA; dwFlags: DWORD): HRESULT; stdcall;

        function GetGPUThreadPriority(pPriority: PINT32): HRESULT; stdcall;

        function SetGPUThreadPriority(Priority: int32): HRESULT; stdcall;

        function WaitForVBlank(iSwapChain: UINT): HRESULT; stdcall;

        function CheckResourceResidency(pResourceArray: PIDirect3DResource9; NumResources: uint32): HRESULT; stdcall;

        function SetMaximumFrameLatency(MaxLatency: UINT): HRESULT; stdcall;

        function GetMaximumFrameLatency(pMaxLatency: PUINT): HRESULT; stdcall;

        function CheckDeviceState(hDestinationWindow: HWND): HRESULT; stdcall;

        function CreateRenderTargetEx(Width: UINT; Height: UINT; Format: TD3DFORMAT; MultiSample: TD3DMULTISAMPLE_TYPE; MultisampleQuality: DWORD; Lockable: boolean; out ppSurface: IDirect3DSurface9;
            pSharedHandle: PHANDLE; Usage: DWORD): HRESULT; stdcall;

        function CreateOffscreenPlainSurfaceEx(Width: UINT; Height: UINT; Format: TD3DFORMAT; Pool: TD3DPOOL; out ppSurface: IDirect3DSurface9; pSharedHandle: PHANDLE; Usage: DWORD): HRESULT; stdcall;

        function CreateDepthStencilSurfaceEx(Width: UINT; Height: UINT; Format: TD3DFORMAT; MultiSample: TD3DMULTISAMPLE_TYPE; MultisampleQuality: DWORD; Discard: boolean;
            out ppSurface: IDirect3DSurface9; pSharedHandle: PHANDLE; Usage: DWORD): HRESULT; stdcall;

        function ResetEx(pPresentationParameters: PD3DPRESENT_PARAMETERS; pFullscreenDisplayMode: PD3DDISPLAYMODEEX): HRESULT; stdcall;

        function GetDisplayModeEx(iSwapChain: UINT; pMode: PD3DDISPLAYMODEEX; pRotation: PD3DDISPLAYROTATION): HRESULT; stdcall;

    end;


    IDirect3DSwapChain9Ex = interface(IDirect3DSwapChain9)
        ['{91886CAF-1C3D-4D2E-A0AB-3E4C7D8D3303}']
        function GetLastPresentCount(pLastPresentCount: PUINT): HRESULT; stdcall;

        function GetPresentStats(pPresentationStatistics: PD3DPRESENTSTATS): HRESULT; stdcall;

        function GetDisplayModeEx(pMode: PD3DDISPLAYMODEEX; pRotation: PD3DDISPLAYROTATION): HRESULT; stdcall;

    end;



    IDirect3D9ExOverlayExtension = interface(IUnknown)
        ['{187AEB13-AAF5-4C59-876D-E059088C0DF8}']
        (*** IDirect3D9ExOverlayExtension methods ***)
        function CheckDeviceOverlayType(Adapter: UINT; DevType: TD3DDEVTYPE; OverlayWidth: UINT; OverlayHeight: UINT; OverlayFormat: TD3DFORMAT; pDisplayMode: PD3DDISPLAYMODEEX;
            DisplayRotation: TD3DDISPLAYROTATION; pOverlayCaps: PD3DOVERLAYCAPS): HRESULT; stdcall;

    end;


    IDirect3DDevice9Video = interface(IUnknown)
        ['{26DC4561-A1EE-4AE7-96DA-118A36C0EC95}']
        (*** IDirect3DDevice9Video methods ***)
        function GetContentProtectionCaps(pCryptoType: PGUID; pDecodeProfile: PGUID; pCaps: PD3DCONTENTPROTECTIONCAPS): HRESULT; stdcall;

        function CreateAuthenticatedChannel(ChannelType: TD3DAUTHENTICATEDCHANNELTYPE; out ppAuthenticatedChannel: IDirect3DAuthenticatedChannel9; pChannelHandle: PHANDLE): HRESULT; stdcall;

        function CreateCryptoSession(pCryptoType: PGUID; pDecodeProfile: PGUID; out ppCryptoSession: IDirect3DCryptoSession9; pCryptoHandle: PHANDLE): HRESULT; stdcall;

    end;



    IDirect3DAuthenticatedChannel9 = interface(IUnknown)
        ['{FF24BEEE-DA21-4BEB-98B5-D2F899F98AF9}']
        (*** IDirect3DAuthenticatedChannel9 methods ***)
        function GetCertificateSize(pCertificateSize: PUINT): HRESULT; stdcall;

        function GetCertificate(CertifacteSize: UINT; ppCertificate: pbyte): HRESULT; stdcall;

        function NegotiateKeyExchange(DataSize: UINT; pData: PVOID): HRESULT; stdcall;

        function Query(InputSize: UINT; pInput: PVOID; OutputSize: UINT; pOutput: PVOID): HRESULT; stdcall;

        function Configure(InputSize: UINT; pInput: PVOID; pOutput: PD3DAUTHENTICATEDCHANNEL_CONFIGURE_OUTPUT): HRESULT; stdcall;

    end;


    IDirect3DCryptoSession9 = interface(IUnknown)
        ['{FA0AB799-7A9C-48CA-8C5B-237E71A54434}']
        (*** IDirect3DCryptoSession9 methods ***)
        function GetCertificateSize(pCertificateSize: PUINT): HRESULT; stdcall;

        function GetCertificate(CertifacteSize: UINT; ppCertificate: pbyte): HRESULT; stdcall;

        function NegotiateKeyExchange(DataSize: UINT; pData: PVOID): HRESULT; stdcall;

        function EncryptionBlt(pSrcSurface: IDirect3DSurface9; pDstSurface: IDirect3DSurface9; DstSurfaceSize: UINT; pIV: PVOID): HRESULT; stdcall;

        function DecryptionBlt(pSrcSurface: IDirect3DSurface9; pDstSurface: IDirect3DSurface9; SrcSurfaceSize: UINT; pEncryptedBlockInfo: PD3DENCRYPTED_BLOCK_INFO; pContentKey: PVOID; pIV: PVOID): HRESULT; stdcall;

        function GetSurfacePitch(pSrcSurface: IDirect3DSurface9; pSurfacePitch: PUINT): HRESULT; stdcall;

        function StartSessionKeyRefresh(pRandomNumber: PVOID; RandomNumberSize: UINT): HRESULT; stdcall;

        function FinishSessionKeyRefresh(): HRESULT; stdcall;

        function GetEncryptionBltKey(pReadbackKey: PVOID; KeySize: UINT): HRESULT; stdcall;

    end;


    IDirect3D9Helper = class
        Version: LPCWSTR;
    end;

    IDirect3DDevice9Helper = class
        CreationParameters: TD3DDEVICE_CREATION_PARAMETERS;
        PresentParameters: TD3DPRESENT_PARAMETERS;
        DisplayMode: TD3DDISPLAYMODE;
        Caps: TD3DCAPS9;
        AvailableTextureMem: UINT;
        SwapChains: UINT;
        Textures: UINT;
        VertexBuffers: UINT;
        IndexBuffers: UINT;
        VertexShaders: UINT;
        PixelShaders: UINT;
        Viewport: TD3DVIEWPORT9;
        ProjectionMatrix: TD3DMATRIX;
        ViewMatrix: TD3DMATRIX;
        WorldMatrix: TD3DMATRIX;
        TextureMatrices: array [0..7] of TD3DMATRIX;
        FVF: DWORD;
        VertexSize: UINT;
        VertexShaderVersion: DWORD;
        PixelShaderVersion: DWORD;
        SoftwareVertexProcessing: boolean;
        Material: TD3DMATERIAL9;
        Lights: array [0..15] of TD3DLIGHT9;
        LightsEnabled: array [0..15] of boolean;
        GammaRamp: TD3DGAMMARAMP;
        ScissorRect: TRECT;
        DialogBoxMode: boolean;
    end;


    IDirect3DStateBlock9Helper = class
        CreationCallStack: LPCWSTR;
    end;




    IDirect3DSwapChain9Helper = class
        PresentParameters: TD3DPRESENT_PARAMETERS;
        DisplayMode: TD3DDISPLAYMODE;
        CreationCallStack: LPCWSTR;
    end;




    IDirect3DVertexDeclaration9Helper = class
        CreationCallStack: LPCWSTR;
    end;




    IDirect3DVertexShader9Helper = class
        Version: DWORD;
        CreationCallStack: LPCWSTR;
    end;




    IDirect3DPixelShader9Helper = class
        Version: DWORD;
        CreationCallStack: LPCWSTR;
    end;




    IDirect3DTexture9Helper = class
        Name: LPCWSTR;
        Width: UINT;
        Height: UINT;
        Levels: UINT;
        Usage: DWORD;
        Format: TD3DFORMAT;
        Pool: TD3DPOOL;
        Priority: DWORD;
        LOD: DWORD;
        FilterType: TD3DTEXTUREFILTERTYPE;
        LockCount: UINT;
        CreationCallStack: LPCWSTR;
    end;




    IDirect3DVolumeTexture9Helper = class
        Name: LPCWSTR;
        Width: UINT;
        Height: UINT;
        Depth: UINT;
        Levels: UINT;
        Usage: DWORD;
        Format: TD3DFORMAT;
        Pool: TD3DPOOL;
        Priority: DWORD;
        LOD: DWORD;
        FilterType: TD3DTEXTUREFILTERTYPE;
        LockCount: UINT;
        CreationCallStack: LPCWSTR;
    end;




    IDirect3DCubeTexture9Helper = class
        Name: LPCWSTR;
        Width: UINT;
        Height: UINT;
        Levels: UINT;
        Usage: DWORD;
        Format: TD3DFORMAT;
        Pool: TD3DPOOL;
        Priority: DWORD;
        LOD: DWORD;
        FilterType: TD3DTEXTUREFILTERTYPE;
        LockCount: UINT;
        CreationCallStack: LPCWSTR;
    end;




    IDirect3DVertexBuffer9Helper = class
        Name: LPCWSTR;
        Length: UINT;
        Usage: DWORD;
        FVF: DWORD;
        Pool: TD3DPOOL;
        Priority: DWORD;
        LockCount: UINT;
        CreationCallStack: LPCWSTR;
    end;




    IDirect3DIndexBuffer9Helper = class
        Name: LPCWSTR;
        Length: UINT;
        Usage: DWORD;
        Format: TD3DFORMAT;
        Pool: TD3DPOOL;
        Priority: DWORD;
        LockCount: UINT;
        CreationCallStack: LPCWSTR;
    end;




    IDirect3DSurface9Helper = class
        Name: LPCWSTR;
        Width: UINT;
        Height: UINT;
        Usage: DWORD;
        Format: TD3DFORMAT;
        Pool: TD3DPOOL;
        MultiSampleType: TD3DMULTISAMPLE_TYPE;
        MultiSampleQuality: DWORD;
        Priority: DWORD;
        LockCount: UINT;
        DCCount: UINT;
        CreationCallStack: LPCWSTR;
    end;




    IDirect3DVolume9Helper = class
        Name: LPCWSTR;
        Width: UINT;
        Height: UINT;
        Depth: UINT;
        Usage: DWORD;
        Format: TD3DFORMAT;
        Pool: TD3DPOOL;
        LockCount: UINT;
        CreationCallStack: LPCWSTR;
    end;




    IDirect3DQuery9Helper = class
        QueryType: TD3DQUERYTYPE;
        DataSize: DWORD;
        CreationCallStack: LPCWSTR;
    end;




(*
 * DLL Function for creating a Direct3D9 object. This object supports
 * enumeration and allows the creation of Direct3DDevice9 objects.
 * Pass the value of the constant D3D_SDK_VERSION to this function, so
 * that the run-time can validate that your application was compiled
 * against the right headers.
 *)

function Direct3DCreate9(SDKVersion: UINT32): pointer; stdcall; external D3D9_DLL;


(*********************
/* D3D9Ex interfaces
/*********************)

function Direct3DCreate9Ex(SDKVersion: UINT32; out unnamedParam2: IDirect3D9Ex): HRESULT; stdcall; external D3D9_DLL;


(*
 * Stubs for graphics profiling.
 *)

function D3DPERF_BeginEvent(col: D3DCOLOR; wszName: LPCWSTR): int32; stdcall; external D3D9_DLL;
function D3DPERF_EndEvent(): int32; stdcall; external D3D9_DLL;
procedure D3DPERF_SetMarker(col: D3DCOLOR; wszName: LPCWSTR); stdcall; external D3D9_DLL;
procedure D3DPERF_SetRegion(col: D3DCOLOR; wszName: LPCWSTR); stdcall; external D3D9_DLL;
function D3DPERF_QueryRepeatFrame(): boolean; stdcall; external D3D9_DLL;
procedure D3DPERF_SetOptions(dwOptions: DWORD); stdcall; external D3D9_DLL;
function D3DPERF_GetStatus(): DWORD; external D3D9_DLL;


implementation




end.
