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
   File name: d3d.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.D3D;

{ #todo : Check D3D Doku und DDraw Doku für namless und typen }

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3DCaps,
    DX12.D3DTypes,
    DX12.DDraw;

    {$Z4}

const
    DIRECT3D_VERSION = $0700;
(*
 * Interface IID's
 *)

    IID_IDirect3D: TGUID = '{3BBA0080-2421-11CF-A31A-00AA00B93356}';
    IID_IDirect3D2: TGUID = '{6AAE1EC1-662A-11D0-889D-00AA00BBB76A}';
    IID_IDirect3D3: TGUID = '{BB223240-E72B-11D0-A9B4-00AA00C0993E}';
    IID_IDirect3D7: TGUID = '{F5049E77-4861-11D2-A407-00A0C90629A8}';

    IID_IDirect3DRampDevice: TGUID = '{F2086B20-259F-11CF-A31A-00AA00B93356}';
    IID_IDirect3DRGBDevice: TGUID = '{A4665C60-2673-11CF-A31A-00AA00B93356}';
    IID_IDirect3DHALDevice: TGUID = '{84E63DE0-46AA-11CF-816F-0000C020156E}';
    IID_IDirect3DMMXDevice: TGUID = '{881949A1-D6F3-11D0-89AB-00A0C9054129}';

    IID_IDirect3DRefDevice: TGUID = '{50936643-13E9-11D1-89AA-00A0C9054129}';
    IID_IDirect3DNullDevice: TGUID = '{8767DF22-BACC-11D1-8969-00A0C90629A8}';
    IID_IDirect3DTnLHalDevice: TGUID = '{F5049E78-4861-11D2-A407-00A0C90629A8}';


(*
 * Internal Guid to distinguish requested MMX from MMX being used as an RGB rasterizer
 *)

    IID_IDirect3DDevice: TGUID = '{64108800-957D-11D0-89AB-00A0C9054129}';
    IID_IDirect3DDevice2: TGUID = '{93281501-8CF8-11D0-89AB-00A0C9054129}';
    IID_IDirect3DDevice3: TGUID = '{B0AB3B60-33D7-11D1-A981-00C04FD7B174}';
    IID_IDirect3DDevice7: TGUID = '{F5049E79-4861-11D2-A407-00A0C90629A8}';
    IID_IDirect3DTexture: TGUID = '{2CDCD9E0-25A0-11CF-A31A-00AA00B93356}';
    IID_IDirect3DTexture2: TGUID = '{93281502-8CF8-11D0-89AB-00A0C9054129}';
    IID_IDirect3DLight: TGUID = '{4417C142-33AD-11CF-816F-0000C020156E}';

    IID_IDirect3DMaterial: TGUID = '{4417C144-33AD-11CF-816F-0000C020156E}';
    IID_IDirect3DMaterial2: TGUID = '{93281503-8CF8-11D0-89AB-00A0C9054129}';
    IID_IDirect3DMaterial3: TGUID = '{CA9C46F4-D3C5-11D1-B75A-00600852B312}';

    IID_IDirect3DExecuteBuffer: TGUID = '{4417C145-33AD-11CF-816F-0000C020156E}';
    IID_IDirect3DViewport: TGUID = '{4417C146-33AD-11CF-816F-0000C020156E}';
    IID_IDirect3DViewport2: TGUID = '{93281500-8CF8-11D0-89AB-00A0C9054129}';
    IID_IDirect3DViewport3: TGUID = '{B0AB3B61-33D7-11D1-A981-00C04FD7B174}';
    IID_IDirect3DVertexBuffer: TGUID = '{7A503555-4A83-11D1-A5DB-00A0C90367F8}';
    IID_IDirect3DVertexBuffer7: TGUID = '{F5049E7D-4861-11D2-A407-00A0C90629A8}';




(****************************************************************************
 *
 * Flags for IDirect3DDevice::NextViewport
 *
 ****************************************************************************)
(*
 * Return the next viewport
 *)

    D3DNEXT_NEXT = $00000001;

(*
 * Return the first viewport
 *)
    D3DNEXT_HEAD = $00000002;

(*
 * Return the last viewport
 *)
    D3DNEXT_TAIL = $00000004;


(****************************************************************************
 *
 * Flags for DrawPrimitive/DrawIndexedPrimitive
 *   Also valid for Begin/BeginIndexed
 *   Also valid for VertexBuffer::CreateVertexBuffer
 ****************************************************************************)
(*
 * Wait until the device is ready to draw the primitive
 * This will cause DP to not return DDERR_WASSTILLDRAWING
 *)

    D3DDP_WAIT = $00000001;

(*
 * Hint that it is acceptable to render the primitive out of order.
 *)
    D3DDP_OUTOFORDER = $00000002;




(*
 * Hint that the primitives have been clipped by the application.
 *)
    D3DDP_DONOTCLIP = $00000004;

(*
 * Hint that the extents need not be updated.
 *)
    D3DDP_DONOTUPDATEEXTENTS = $00000008;




(*
 * Hint that the lighting should not be applied on vertices.
 *)

    D3DDP_DONOTLIGHT = $00000010;




(*
 * Direct3D Errors
 * DirectDraw error codes are used when errors not specified here.
 *)
    D3D_OK = DD_OK;
    D3DERR_BADMAJORVERSION = ((1 shl 31) or (_FACDD shl 16) or (700));
    D3DERR_BADMINORVERSION = ((1 shl 31) or (_FACDD shl 16) or (701));


(*
 * An invalid device was requested by the application.
 *)
    D3DERR_INVALID_DEVICE = ((1 shl 31) or (_FACDD shl 16) or (705));
    D3DERR_INITFAILED = ((1 shl 31) or (_FACDD shl 16) or (706));

(*
 * SetRenderTarget attempted on a device that was
 * QI'd off the render target.
 *)
    D3DERR_DEVICEAGGREGATED = ((1 shl 31) or (_FACDD shl 16) or (707));


    D3DERR_EXECUTE_CREATE_FAILED = ((1 shl 31) or (_FACDD shl 16) or (710));
    D3DERR_EXECUTE_DESTROY_FAILED = ((1 shl 31) or (_FACDD shl 16) or (711));
    D3DERR_EXECUTE_LOCK_FAILED = ((1 shl 31) or (_FACDD shl 16) or (712));
    D3DERR_EXECUTE_UNLOCK_FAILED = ((1 shl 31) or (_FACDD shl 16) or (713));
    D3DERR_EXECUTE_LOCKED = ((1 shl 31) or (_FACDD shl 16) or (714));
    D3DERR_EXECUTE_NOT_LOCKED = ((1 shl 31) or (_FACDD shl 16) or (715));

    D3DERR_EXECUTE_FAILED = ((1 shl 31) or (_FACDD shl 16) or (716));
    D3DERR_EXECUTE_CLIPPED_FAILED = ((1 shl 31) or (_FACDD shl 16) or (717));

    D3DERR_TEXTURE_NO_SUPPORT = ((1 shl 31) or (_FACDD shl 16) or (720));
    D3DERR_TEXTURE_CREATE_FAILED = ((1 shl 31) or (_FACDD shl 16) or (721));
    D3DERR_TEXTURE_DESTROY_FAILED = ((1 shl 31) or (_FACDD shl 16) or (722));
    D3DERR_TEXTURE_LOCK_FAILED = ((1 shl 31) or (_FACDD shl 16) or (723));
    D3DERR_TEXTURE_UNLOCK_FAILED = ((1 shl 31) or (_FACDD shl 16) or (724));
    D3DERR_TEXTURE_LOAD_FAILED = ((1 shl 31) or (_FACDD shl 16) or (725));
    D3DERR_TEXTURE_SWAP_FAILED = ((1 shl 31) or (_FACDD shl 16) or (726));
    D3DERR_TEXTURE_LOCKED = ((1 shl 31) or (_FACDD shl 16) or (727));
    D3DERR_TEXTURE_NOT_LOCKED = ((1 shl 31) or (_FACDD shl 16) or (728));
    D3DERR_TEXTURE_GETSURF_FAILED = ((1 shl 31) or (_FACDD shl 16) or (729));

    D3DERR_MATRIX_CREATE_FAILED = ((1 shl 31) or (_FACDD shl 16) or (730));
    D3DERR_MATRIX_DESTROY_FAILED = ((1 shl 31) or (_FACDD shl 16) or (731));
    D3DERR_MATRIX_SETDATA_FAILED = ((1 shl 31) or (_FACDD shl 16) or (732));
    D3DERR_MATRIX_GETDATA_FAILED = ((1 shl 31) or (_FACDD shl 16) or (733));
    D3DERR_SETVIEWPORTDATA_FAILED = ((1 shl 31) or (_FACDD shl 16) or (734));


    D3DERR_INVALIDCURRENTVIEWPORT = ((1 shl 31) or (_FACDD shl 16) or (735));
    D3DERR_INVALIDPRIMITIVETYPE = ((1 shl 31) or (_FACDD shl 16) or (736));
    D3DERR_INVALIDVERTEXTYPE = ((1 shl 31) or (_FACDD shl 16) or (737));
    D3DERR_TEXTURE_BADSIZE = ((1 shl 31) or (_FACDD shl 16) or (738));
    D3DERR_INVALIDRAMPTEXTURE = ((1 shl 31) or (_FACDD shl 16) or (739));


    D3DERR_MATERIAL_CREATE_FAILED = ((1 shl 31) or (_FACDD shl 16) or (740));
    D3DERR_MATERIAL_DESTROY_FAILED = ((1 shl 31) or (_FACDD shl 16) or (741));
    D3DERR_MATERIAL_SETDATA_FAILED = ((1 shl 31) or (_FACDD shl 16) or (742));
    D3DERR_MATERIAL_GETDATA_FAILED = ((1 shl 31) or (_FACDD shl 16) or (743));


    D3DERR_INVALIDPALETTE = ((1 shl 31) or (_FACDD shl 16) or (744));

    D3DERR_ZBUFF_NEEDS_SYSTEMMEMORY = ((1 shl 31) or (_FACDD shl 16) or (745));
    D3DERR_ZBUFF_NEEDS_VIDEOMEMORY = ((1 shl 31) or (_FACDD shl 16) or (746));
    D3DERR_SURFACENOTINVIDMEM = ((1 shl 31) or (_FACDD shl 16) or (747));


    D3DERR_LIGHT_SET_FAILED = ((1 shl 31) or (_FACDD shl 16) or (750));

    D3DERR_LIGHTHASVIEWPORT = ((1 shl 31) or (_FACDD shl 16) or (751));
    D3DERR_LIGHTNOTINTHISVIEWPORT = ((1 shl 31) or (_FACDD shl 16) or (752));


    D3DERR_SCENE_IN_SCENE = ((1 shl 31) or (_FACDD shl 16) or (760));
    D3DERR_SCENE_NOT_IN_SCENE = ((1 shl 31) or (_FACDD shl 16) or (761));
    D3DERR_SCENE_BEGIN_FAILED = ((1 shl 31) or (_FACDD shl 16) or (762));
    D3DERR_SCENE_END_FAILED = ((1 shl 31) or (_FACDD shl 16) or (763));


    D3DERR_INBEGIN = ((1 shl 31) or (_FACDD shl 16) or (770));
    D3DERR_NOTINBEGIN = ((1 shl 31) or (_FACDD shl 16) or (771));
    D3DERR_NOVIEWPORTS = ((1 shl 31) or (_FACDD shl 16) or (772));
    D3DERR_VIEWPORTDATANOTSET = ((1 shl 31) or (_FACDD shl 16) or (773));
    D3DERR_VIEWPORTHASNODEVICE = ((1 shl 31) or (_FACDD shl 16) or (774));
    D3DERR_NOCURRENTVIEWPORT = ((1 shl 31) or (_FACDD shl 16) or (775));



    D3DERR_INVALIDVERTEXFORMAT = ((1 shl 31) or (_FACDD shl 16) or (2048));

(*
 * Attempted to CreateTexture on a surface that had a color key
 *)
    D3DERR_COLORKEYATTACHED = ((1 shl 31) or (_FACDD shl 16) or (2050));

    D3DERR_VERTEXBUFFEROPTIMIZED = ((1 shl 31) or (_FACDD shl 16) or (2060));
    D3DERR_VBUF_CREATE_FAILED = ((1 shl 31) or (_FACDD shl 16) or (2061));
    D3DERR_VERTEXBUFFERLOCKED = ((1 shl 31) or (_FACDD shl 16) or (2062));
    D3DERR_VERTEXBUFFERUNLOCKFAILED = ((1 shl 31) or (_FACDD shl 16) or (2063));

    D3DERR_ZBUFFER_NOTPRESENT = ((1 shl 31) or (_FACDD shl 16) or (2070));
    D3DERR_STENCILBUFFER_NOTPRESENT = ((1 shl 31) or (_FACDD shl 16) or (2071));

    D3DERR_WRONGTEXTUREFORMAT = ((1 shl 31) or (_FACDD shl 16) or (2072));
    D3DERR_UNSUPPORTEDCOLOROPERATION = ((1 shl 31) or (_FACDD shl 16) or (2073));
    D3DERR_UNSUPPORTEDCOLORARG = ((1 shl 31) or (_FACDD shl 16) or (2074));
    D3DERR_UNSUPPORTEDALPHAOPERATION = ((1 shl 31) or (_FACDD shl 16) or (2075));
    D3DERR_UNSUPPORTEDALPHAARG = ((1 shl 31) or (_FACDD shl 16) or (2076));
    D3DERR_TOOMANYOPERATIONS = ((1 shl 31) or (_FACDD shl 16) or (2077));
    D3DERR_CONFLICTINGTEXTUREFILTER = ((1 shl 31) or (_FACDD shl 16) or (2078));
    D3DERR_UNSUPPORTEDFACTORVALUE = ((1 shl 31) or (_FACDD shl 16) or (2079));
    D3DERR_CONFLICTINGRENDERSTATE = ((1 shl 31) or (_FACDD shl 16) or (2081));
    D3DERR_UNSUPPORTEDTEXTUREFILTER = ((1 shl 31) or (_FACDD shl 16) or (2082));
    D3DERR_TOOMANYPRIMITIVES = ((1 shl 31) or (_FACDD shl 16) or (2083));
    D3DERR_INVALIDMATRIX = ((1 shl 31) or (_FACDD shl 16) or (2084));
    D3DERR_TOOMANYVERTICES = ((1 shl 31) or (_FACDD shl 16) or (2085));
    D3DERR_CONFLICTINGTEXTUREPALETTE = ((1 shl 31) or (_FACDD shl 16) or (2086));




    D3DERR_INVALIDSTATEBLOCK = ((1 shl 31) or (_FACDD shl 16) or (2100));
    D3DERR_INBEGINSTATEBLOCK = ((1 shl 31) or (_FACDD shl 16) or (2101));
    D3DERR_NOTINBEGINSTATEBLOCK = ((1 shl 31) or (_FACDD shl 16) or (2102));




type

    REFCLSID = ^TGUID;

(*
 * Direct3D interfaces
  *)

    IDirect3DDevice3 = interface;
    IDirect3DLight = interface;
    IDirect3DMaterial = interface;
    IDirect3DViewport3 = interface;
    IDirect3DDevice7 = interface;
    IDirect3DVertexBuffer7 = interface;
    IDirect3DTexture = interface;
    IDirect3DExecuteBuffer = interface;
    IDirect3DViewport = interface;

    LPDIRECT3D2 = ^IDirect3D2;
    LPDIRECT3DDEVICE2 = ^IDirect3DDevice2;
    LPDIRECT3DMATERIAL2 = ^IDirect3DMaterial2;
    LPDIRECT3DTEXTURE2 = ^IDirect3DTexture2;
    LPDIRECT3DVIEWPORT2 = ^IDirect3DViewport2;

    LPDIRECT3DEXECUTEBUFFER = ^IDirect3DExecuteBuffer;
    LPDIRECT3DLIGHT = ^IDirect3DLight;
    LPDIRECT3DMATERIAL = ^IDirect3DMaterial;
    LPDIRECT3DMATERIAL3 = ^IDirect3DMaterial3;


    LPDIRECT3DTEXTURE = ^IDirect3DTexture;

    LPDIRECT3DVIEWPORT = ^IDirect3DViewport;




    LPDIRECT3DVIEWPORT3 = ^IDirect3DViewport3;

    LPDIRECT3DVERTEXBUFFER = ^IDirect3DVertexBuffer;
    LPDIRECT3DVERTEXBUFFER7 = ^IDirect3DVertexBuffer7;




    IDirect3D = interface(IUnknown)
        ['{3BBA0080-2421-11CF-A31A-00AA00B93356}']
        (*** IDirect3D methods ***)
        function Initialize(lpREFIID: REFCLSID): HRESULT; stdcall;
        function EnumDevices(lpEnumDevicesCallback: LPD3DENUMDEVICESCALLBACK; lpUserArg: LPVOID): HRESULT; stdcall;
        function CreateLight(out lplpDirect3DLight: IDirect3DLight; pUnkOuter: IUnknown = nil): HRESULT; stdcall;
        function CreateMaterial(out IDirect3DLight: IDirect3DMaterial; pUnkOuter: IUnknown = nil): HRESULT; stdcall;
        function CreateViewport(out lplpD3DViewport: IDirect3DViewport3; pUnkOuter: IUnknown = nil): HRESULT; stdcall;
        function FindDevice(lpD3DFDS: LPD3DFINDDEVICESEARCH; lpD3DFDR: LPD3DFINDDEVICERESULT): HRESULT; stdcall;

    end;

    LPDIRECT3D = ^IDirect3D;

    IDirect3D2 = interface(IUnknown)
        ['{6AAE1EC1-662A-11D0-889D-00AA00BBB76A}']
        (*** IDirect3D2 methods ***)
        function EnumDevices(Nameless1: LPD3DENUMDEVICESCALLBACK; Nameless2: LPVOID): HRESULT; stdcall;

        function CreateLight(Nameless1: LPDIRECT3DLIGHT; Nameless2: IUnknown): HRESULT; stdcall;

        function CreateMaterial(Nameless1: LPDIRECT3DMATERIAL2; Nameless2: IUnknown): HRESULT; stdcall;

        function CreateViewport(Nameless1: LPDIRECT3DVIEWPORT2; Nameless2: IUnknown): HRESULT; stdcall;

        function FindDevice(Nameless1: LPD3DFINDDEVICESEARCH; Nameless2: LPD3DFINDDEVICERESULT): HRESULT; stdcall;

        function CreateDevice(Nameless1: REFCLSID; Nameless2: LPDIRECTDRAWSURFACE; Nameless3: LPDIRECT3DDEVICE2): HRESULT; stdcall;

    end;




    IDirect3D3 = interface(IUnknown)
        ['{BB223240-E72B-11D0-A9B4-00AA00C0993E}']


        (*** IDirect3D3 methods ***)
        function EnumDevices(Nameless1: LPD3DENUMDEVICESCALLBACK; Nameless2: LPVOID): HRESULT; stdcall;

        function CreateLight(Nameless1: LPDIRECT3DLIGHT; Nameless2: IUnknown): HRESULT; stdcall;

        function CreateMaterial(Nameless1: LPDIRECT3DMATERIAL3; Nameless2: IUnknown): HRESULT; stdcall;

        function CreateViewport(Nameless1: LPDIRECT3DVIEWPORT3; Nameless2: IUnknown): HRESULT; stdcall;

        function FindDevice(Nameless1: LPD3DFINDDEVICESEARCH; Nameless2: LPD3DFINDDEVICERESULT): HRESULT; stdcall;

        function CreateDevice(Nameless1: REFCLSID; Nameless2: LPDIRECTDRAWSURFACE4; out lplpD3DDevice: IDirect3DDevice3; Nameless4: IUnknown): HRESULT; stdcall;

        function CreateVertexBuffer(Nameless1: LPD3DVERTEXBUFFERDESC; Nameless2: LPDIRECT3DVERTEXBUFFER; Nameless3: DWORD; Nameless4: IUnknown): HRESULT; stdcall;

        function EnumZBufferFormats(Nameless1: REFCLSID; Nameless2: LPD3DENUMPIXELFORMATSCALLBACK; Nameless3: LPVOID): HRESULT; stdcall;

        function EvictManagedTextures(): HRESULT; stdcall;

    end;

    LPDIRECT3D3 = ^IDirect3D3;



    IDirect3D7 = interface(IUnknown)
        ['{F5049E77-4861-11D2-A407-00A0C90629A8}']
        (*** IDirect3D7 methods ***)
        function EnumDevices(lpEnumDevicesCallback: LPD3DENUMDEVICESCALLBACK7; lpUserArg: LPVOID): HRESULT; stdcall;
        function CreateDevice(rclsid: REFCLSID; lpDDS: IDirectDrawSurface7; out lplpD3DDevice: IDirect3DDevice7): HRESULT; stdcall;
        function CreateVertexBuffer(lpVBDesc: LPD3DVERTEXBUFFERDESC; out lplpD3DVertexBuffer: IDirect3DVertexBuffer7; dwFlags: DWORD): HRESULT; stdcall;
        function EnumZBufferFormats(riidDevice: REFCLSID; lpEnumCallback: LPD3DENUMPIXELFORMATSCALLBACK; lpContext: LPVOID): HRESULT; stdcall;
        function EvictManagedTextures(): HRESULT; stdcall;
    end;

    LPDIRECT3D7 = ^IDirect3D7;




    IDirect3DDevice = interface(IUnknown)
        ['{64108800-957D-11D0-89AB-00A0C9054129}']
        (*** IDirect3DDevice methods ***)
        function Initialize(lpd3d: IDirect3D; lpGUID: LPGUID; lpd3ddvdesc: LPD3DDEVICEDESC): HRESULT; stdcall;
        function GetCaps(lpD3DHWDevDesc: LPD3DDEVICEDESC; lpD3DHELDevDesc: LPD3DDEVICEDESC): HRESULT; stdcall;
        function SwapTextureHandles(lpD3DTex1: IDirect3DTexture; lpD3DTex2: IDirect3DTexture): HRESULT; stdcall;
        function CreateExecuteBuffer(lpDesc: LPD3DEXECUTEBUFFERDESC; out lplpDirect3DExecuteBuffer: IDirect3DExecuteBuffer; pUnkOuter: IUnknown): HRESULT; stdcall;
        function GetStats(lpD3DStats: LPD3DSTATS): HRESULT; stdcall;
        function Execute(lpDirect3DExecuteBuffer: IDirect3DExecuteBuffer; lpDirect3DViewport: IDirect3DViewport; dwFlags: DWORD): HRESULT; stdcall;
        function AddViewport(lpDirect3DViewport: IDirect3DViewport): HRESULT; stdcall;
        function DeleteViewport(lpDirect3DViewport: IDirect3DViewport): HRESULT; stdcall;
        function NextViewport(lpDirect3DViewport: IDirect3DViewport; out lplpDirect3DViewport: IDirect3DViewport; dwFlags: DWORD): HRESULT; stdcall;
        function Pick(lpDirect3DExecuteBuffer: IDirect3DExecuteBuffer; lpDirect3DViewport: IDirect3DViewport; dwFlags: DWORD; lpRect: PD3DRECT): HRESULT; stdcall;
        function GetPickRecords(lpCount: LPDWORD; {out array} lpD3DPickRec: LPD3DPICKRECORD): HRESULT; stdcall;
        function EnumTextureFormats(lpd3dEnumTextureProc: LPD3DENUMTEXTUREFORMATSCALLBACK; lpArg: LPVOID): HRESULT; stdcall;
        function CreateMatrix(lpD3DMatHandle: LPD3DMATRIXHANDLE): HRESULT; stdcall;
        function SetMatrix(d3dMatHandle: TD3DMATRIXHANDLE; lpD3DMatrix: LPD3DMATRIX): HRESULT; stdcall;
        function GetMatrix(lpD3DMatHandle: TD3DMATRIXHANDLE; lpD3DMatrix: LPD3DMATRIX): HRESULT; stdcall;
        function DeleteMatrix(d3dMatHandle: TD3DMATRIXHANDLE): HRESULT; stdcall;
        function BeginScene(): HRESULT; stdcall;
        function EndScene(): HRESULT; stdcall;
        function GetDirect3D(out lpD3D: IDirect3D): HRESULT; stdcall;

    end;

    LPDIRECT3DDEVICE = ^IDirect3DDevice;


    IDirect3DDevice2 = interface(IUnknown)
        ['{93281501-8CF8-11D0-89AB-00A0C9054129}']

        (*** IDirect3DDevice2 methods ***)
        function GetCaps(Nameless1: LPD3DDEVICEDESC; Nameless2: LPD3DDEVICEDESC): HRESULT; stdcall;

        function SwapTextureHandles(Nameless1: LPDIRECT3DTEXTURE2; Nameless2: LPDIRECT3DTEXTURE2): HRESULT; stdcall;

        function GetStats(Nameless1: LPD3DSTATS): HRESULT; stdcall;

        function AddViewport(Nameless1: LPDIRECT3DVIEWPORT2): HRESULT; stdcall;

        function DeleteViewport(Nameless1: LPDIRECT3DVIEWPORT2): HRESULT; stdcall;

        function NextViewport(Nameless1: LPDIRECT3DVIEWPORT2; Nameless2: LPDIRECT3DVIEWPORT2; Nameless3: DWORD): HRESULT; stdcall;

        function EnumTextureFormats(Nameless1: LPD3DENUMTEXTUREFORMATSCALLBACK; Nameless2: LPVOID): HRESULT; stdcall;

        function BeginScene(): HRESULT; stdcall;

        function EndScene(): HRESULT; stdcall;

        function GetDirect3D(Nameless1: LPDIRECT3D2): HRESULT; stdcall;

        function SetCurrentViewport(Nameless1: LPDIRECT3DVIEWPORT2): HRESULT; stdcall;

        function GetCurrentViewport(Nameless1: LPDIRECT3DVIEWPORT2): HRESULT; stdcall;

        function SetRenderTarget(Nameless1: LPDIRECTDRAWSURFACE; Nameless2: DWORD): HRESULT; stdcall;

        function GetRenderTarget(Nameless1: LPDIRECTDRAWSURFACE): HRESULT; stdcall;

        function _Begin(Nameless1: TD3DPRIMITIVETYPE; Nameless2: TD3DVERTEXTYPE; Nameless3: DWORD): HRESULT; stdcall;

        function BeginIndexed(Nameless1: TD3DPRIMITIVETYPE; Nameless2: TD3DVERTEXTYPE; Nameless3: LPVOID; Nameless4: DWORD; Nameless5: DWORD): HRESULT; stdcall;

        function Vertex(Nameless1: LPVOID): HRESULT; stdcall;

        function Index(Nameless1: word): HRESULT; stdcall;

        function _End(Nameless1: DWORD): HRESULT; stdcall;

        function GetRenderState(Nameless1: TD3DRENDERSTATETYPE; Nameless2: LPDWORD): HRESULT; stdcall;

        function SetRenderState(Nameless1: TD3DRENDERSTATETYPE; Nameless2: DWORD): HRESULT; stdcall;

        function GetLightState(Nameless1: TD3DLIGHTSTATETYPE; Nameless2: LPDWORD): HRESULT; stdcall;

        function SetLightState(Nameless1: TD3DLIGHTSTATETYPE; Nameless2: DWORD): HRESULT; stdcall;

        function SetTransform(Nameless1: TD3DTRANSFORMSTATETYPE; Nameless2: LPD3DMATRIX): HRESULT; stdcall;

        function GetTransform(Nameless1: TD3DTRANSFORMSTATETYPE; Nameless2: LPD3DMATRIX): HRESULT; stdcall;

        function MultiplyTransform(Nameless1: TD3DTRANSFORMSTATETYPE; Nameless2: LPD3DMATRIX): HRESULT; stdcall;

        function DrawPrimitive(Nameless1: TD3DPRIMITIVETYPE; Nameless2: TD3DVERTEXTYPE; Nameless3: LPVOID; Nameless4: DWORD; Nameless5: DWORD): HRESULT; stdcall;

        function DrawIndexedPrimitive(Nameless1: TD3DPRIMITIVETYPE; Nameless2: TD3DVERTEXTYPE; Nameless3: LPVOID; Nameless4: DWORD; Nameless5: LPWORD; Nameless6: DWORD; Nameless7: DWORD): HRESULT; stdcall;

        function SetClipStatus(Nameless1: LPD3DCLIPSTATUS): HRESULT; stdcall;

        function GetClipStatus(Nameless1: LPD3DCLIPSTATUS): HRESULT; stdcall;

    end;



    IDirect3DDevice3 = interface(IUnknown)
        ['{B0AB3B60-33D7-11D1-A981-00C04FD7B174}']

        (*** IDirect3DDevice3 methods ***)
        function GetCaps(Nameless1: LPD3DDEVICEDESC; Nameless2: LPD3DDEVICEDESC): HRESULT; stdcall;

        function GetStats(Nameless1: LPD3DSTATS): HRESULT; stdcall;

        function AddViewport(Nameless1: LPDIRECT3DVIEWPORT3): HRESULT; stdcall;

        function DeleteViewport(Nameless1: LPDIRECT3DVIEWPORT3): HRESULT; stdcall;

        function NextViewport(Nameless1: LPDIRECT3DVIEWPORT3; Nameless2: LPDIRECT3DVIEWPORT3; Nameless3: DWORD): HRESULT; stdcall;

        function EnumTextureFormats(Nameless1: LPD3DENUMPIXELFORMATSCALLBACK; Nameless2: LPVOID): HRESULT; stdcall;

        function BeginScene(): HRESULT; stdcall;

        function EndScene(): HRESULT; stdcall;

        function GetDirect3D(Nameless1: LPDIRECT3D3): HRESULT; stdcall;

        function SetCurrentViewport(Nameless1: LPDIRECT3DVIEWPORT3): HRESULT; stdcall;

        function GetCurrentViewport(Nameless1: LPDIRECT3DVIEWPORT3): HRESULT; stdcall;

        function SetRenderTarget(Nameless1: LPDIRECTDRAWSURFACE4; Nameless2: DWORD): HRESULT; stdcall;

        function GetRenderTarget(Nameless1: LPDIRECTDRAWSURFACE4): HRESULT; stdcall;

        function _Begin(Nameless1: TD3DPRIMITIVETYPE; Nameless2: DWORD; Nameless3: DWORD): HRESULT; stdcall;

        function BeginIndexed(Nameless1: TD3DPRIMITIVETYPE; Nameless2: DWORD; Nameless3: LPVOID; Nameless4: DWORD; Nameless5: DWORD): HRESULT; stdcall;

        function Vertex(Nameless1: LPVOID): HRESULT; stdcall;

        function Index(Nameless1: word): HRESULT; stdcall;

        function _End(Nameless1: DWORD): HRESULT; stdcall;

        function GetRenderState(Nameless1: TD3DRENDERSTATETYPE; Nameless2: LPDWORD): HRESULT; stdcall;

        function SetRenderState(Nameless1: TD3DRENDERSTATETYPE; Nameless2: DWORD): HRESULT; stdcall;

        function GetLightState(Nameless1: TD3DLIGHTSTATETYPE; Nameless2: LPDWORD): HRESULT; stdcall;

        function SetLightState(Nameless1: TD3DLIGHTSTATETYPE; Nameless2: DWORD): HRESULT; stdcall;

        function SetTransform(Nameless1: TD3DTRANSFORMSTATETYPE; Nameless2: LPD3DMATRIX): HRESULT; stdcall;

        function GetTransform(Nameless1: TD3DTRANSFORMSTATETYPE; Nameless2: LPD3DMATRIX): HRESULT; stdcall;

        function MultiplyTransform(Nameless1: TD3DTRANSFORMSTATETYPE; Nameless2: LPD3DMATRIX): HRESULT; stdcall;

        function DrawPrimitive(Nameless1: TD3DPRIMITIVETYPE; Nameless2: DWORD; Nameless3: LPVOID; Nameless4: DWORD; Nameless5: DWORD): HRESULT; stdcall;

        function DrawIndexedPrimitive(Nameless1: TD3DPRIMITIVETYPE; Nameless2: DWORD; Nameless3: LPVOID; Nameless4: DWORD; Nameless5: LPWORD; Nameless6: DWORD; Nameless7: DWORD): HRESULT; stdcall;

        function SetClipStatus(Nameless1: LPD3DCLIPSTATUS): HRESULT; stdcall;

        function GetClipStatus(Nameless1: LPD3DCLIPSTATUS): HRESULT; stdcall;

        function DrawPrimitiveStrided(Nameless1: TD3DPRIMITIVETYPE; Nameless2: DWORD; Nameless3: LPD3DDRAWPRIMITIVESTRIDEDDATA; Nameless4: DWORD; Nameless5: DWORD): HRESULT; stdcall;

        function DrawIndexedPrimitiveStrided(Nameless1: TD3DPRIMITIVETYPE; Nameless2: DWORD; Nameless3: LPD3DDRAWPRIMITIVESTRIDEDDATA; Nameless4: DWORD; Nameless5: LPWORD; Nameless6: DWORD; Nameless7: DWORD): HRESULT; stdcall;

        function DrawPrimitiveVB(Nameless1: TD3DPRIMITIVETYPE; Nameless2: LPDIRECT3DVERTEXBUFFER; Nameless3: DWORD; Nameless4: DWORD; Nameless5: DWORD): HRESULT; stdcall;

        function DrawIndexedPrimitiveVB(Nameless1: TD3DPRIMITIVETYPE; Nameless2: LPDIRECT3DVERTEXBUFFER; Nameless3: LPWORD; Nameless4: DWORD; Nameless5: DWORD): HRESULT; stdcall;

        function ComputeSphereVisibility(Nameless1: LPD3DVECTOR; Nameless2: LPD3DVALUE; Nameless3: DWORD; Nameless4: DWORD; Nameless5: LPDWORD): HRESULT; stdcall;

        function GetTexture(Nameless1: DWORD; Nameless2: LPDIRECT3DTEXTURE2): HRESULT; stdcall;

        function SetTexture(Nameless1: DWORD; Nameless2: LPDIRECT3DTEXTURE2): HRESULT; stdcall;

        function GetTextureStageState(Nameless1: DWORD; Nameless2: TD3DTEXTURESTAGESTATETYPE; Nameless3: LPDWORD): HRESULT; stdcall;

        function SetTextureStageState(Nameless1: DWORD; Nameless2: TD3DTEXTURESTAGESTATETYPE; Nameless3: DWORD): HRESULT; stdcall;

        function ValidateDevice(Nameless1: LPDWORD): HRESULT; stdcall;

    end;

    LPDIRECT3DDEVICE3 = ^IDirect3DDevice3;



    IDirect3DDevice7 = interface(IUnknown)
        ['{F5049E79-4861-11D2-A407-00A0C90629A8}']

        (*** IDirect3DDevice7 methods ***)
        function GetCaps(Nameless1: LPD3DDEVICEDESC7): HRESULT; stdcall;

        function EnumTextureFormats(Nameless1: LPD3DENUMPIXELFORMATSCALLBACK; Nameless2: LPVOID): HRESULT; stdcall;

        function BeginScene(): HRESULT; stdcall;

        function EndScene(): HRESULT; stdcall;

        function GetDirect3D(Nameless1: LPDIRECT3D7): HRESULT; stdcall;

        function SetRenderTarget(Nameless1: LPDIRECTDRAWSURFACE7; Nameless2: DWORD): HRESULT; stdcall;

        function GetRenderTarget(Nameless1: LPDIRECTDRAWSURFACE7): HRESULT; stdcall;

        function Clear(Nameless1: DWORD; Nameless2: LPD3DRECT; Nameless3: DWORD; Nameless4: TD3DCOLOR; Nameless5: TD3DVALUE; Nameless6: DWORD): HRESULT; stdcall;

        function SetTransform(Nameless1: TD3DTRANSFORMSTATETYPE; Nameless2: LPD3DMATRIX): HRESULT; stdcall;

        function GetTransform(Nameless1: TD3DTRANSFORMSTATETYPE; Nameless2: LPD3DMATRIX): HRESULT; stdcall;

        function SetViewport(Nameless1: LPD3DVIEWPORT7): HRESULT; stdcall;

        function MultiplyTransform(Nameless1: TD3DTRANSFORMSTATETYPE; Nameless2: LPD3DMATRIX): HRESULT; stdcall;

        function GetViewport(Nameless1: LPD3DVIEWPORT7): HRESULT; stdcall;

        function SetMaterial(Nameless1: LPD3DMATERIAL7): HRESULT; stdcall;

        function GetMaterial(Nameless1: LPD3DMATERIAL7): HRESULT; stdcall;

        function SetLight(Nameless1: DWORD; Nameless2: LPD3DLIGHT7): HRESULT; stdcall;

        function GetLight(Nameless1: DWORD; Nameless2: LPD3DLIGHT7): HRESULT; stdcall;

        function SetRenderState(Nameless1: TD3DRENDERSTATETYPE; Nameless2: DWORD): HRESULT; stdcall;

        function GetRenderState(Nameless1: TD3DRENDERSTATETYPE; Nameless2: LPDWORD): HRESULT; stdcall;

        function BeginStateBlock(): HRESULT; stdcall;

        function EndStateBlock(Nameless1: LPDWORD): HRESULT; stdcall;

        function PreLoad(Nameless1: LPDIRECTDRAWSURFACE7): HRESULT; stdcall;

        function DrawPrimitive(Nameless1: TD3DPRIMITIVETYPE; Nameless2: DWORD; Nameless3: LPVOID; Nameless4: DWORD; Nameless5: DWORD): HRESULT; stdcall;

        function DrawIndexedPrimitive(Nameless1: TD3DPRIMITIVETYPE; Nameless2: DWORD; Nameless3: LPVOID; Nameless4: DWORD; Nameless5: LPWORD; Nameless6: DWORD; Nameless7: DWORD): HRESULT; stdcall;

        function SetClipStatus(Nameless1: LPD3DCLIPSTATUS): HRESULT; stdcall;

        function GetClipStatus(Nameless1: LPD3DCLIPSTATUS): HRESULT; stdcall;

        function DrawPrimitiveStrided(Nameless1: TD3DPRIMITIVETYPE; Nameless2: DWORD; Nameless3: LPD3DDRAWPRIMITIVESTRIDEDDATA; Nameless4: DWORD; Nameless5: DWORD): HRESULT; stdcall;

        function DrawIndexedPrimitiveStrided(Nameless1: TD3DPRIMITIVETYPE; Nameless2: DWORD; Nameless3: LPD3DDRAWPRIMITIVESTRIDEDDATA; Nameless4: DWORD; Nameless5: LPWORD; Nameless6: DWORD; Nameless7: DWORD): HRESULT; stdcall;

        function DrawPrimitiveVB(Nameless1: TD3DPRIMITIVETYPE; Nameless2: LPDIRECT3DVERTEXBUFFER7; Nameless3: DWORD; Nameless4: DWORD; Nameless5: DWORD): HRESULT; stdcall;

        function DrawIndexedPrimitiveVB(Nameless1: TD3DPRIMITIVETYPE; Nameless2: LPDIRECT3DVERTEXBUFFER7; Nameless3: DWORD; Nameless4: DWORD; Nameless5: LPWORD; Nameless6: DWORD; Nameless7: DWORD): HRESULT; stdcall;

        function ComputeSphereVisibility(Nameless1: LPD3DVECTOR; Nameless2: LPD3DVALUE; Nameless3: DWORD; Nameless4: DWORD; Nameless5: LPDWORD): HRESULT; stdcall;

        function GetTexture(Nameless1: DWORD; Nameless2: LPDIRECTDRAWSURFACE7): HRESULT; stdcall;

        function SetTexture(Nameless1: DWORD; Nameless2: LPDIRECTDRAWSURFACE7): HRESULT; stdcall;

        function GetTextureStageState(Nameless1: DWORD; Nameless2: TD3DTEXTURESTAGESTATETYPE; Nameless3: LPDWORD): HRESULT; stdcall;

        function SetTextureStageState(Nameless1: DWORD; Nameless2: TD3DTEXTURESTAGESTATETYPE; Nameless3: DWORD): HRESULT; stdcall;

        function ValidateDevice(Nameless1: LPDWORD): HRESULT; stdcall;

        function ApplyStateBlock(Nameless1: DWORD): HRESULT; stdcall;

        function CaptureStateBlock(Nameless1: DWORD): HRESULT; stdcall;

        function DeleteStateBlock(Nameless1: DWORD): HRESULT; stdcall;

        function CreateStateBlock(Nameless1: TD3DSTATEBLOCKTYPE; Nameless2: LPDWORD): HRESULT; stdcall;

        function Load(Nameless1: LPDIRECTDRAWSURFACE7; Nameless2: LPPOINT; Nameless3: LPDIRECTDRAWSURFACE7; Nameless4: LPRECT; Nameless5: DWORD): HRESULT; stdcall;

        function LightEnable(Nameless1: DWORD; Nameless2: boolean): HRESULT; stdcall;

        function GetLightEnable(Nameless1: DWORD; Nameless2: Pboolean): HRESULT; stdcall;

        function SetClipPlane(Nameless1: DWORD; Nameless2: PD3DVALUE): HRESULT; stdcall;

        function GetClipPlane(Nameless1: DWORD; Nameless2: PD3DVALUE): HRESULT; stdcall;

        function GetInfo(Nameless1: DWORD; Nameless2: LPVOID; Nameless3: DWORD): HRESULT; stdcall;

    end;

    LPDIRECT3DDEVICE7 = ^IDirect3DDevice7;



    IDirect3DExecuteBuffer = interface(IUnknown)
        ['{4417C145-33AD-11CF-816F-0000C020156E}']

        (*** IDirect3DExecuteBuffer methods ***)
        function Initialize(Nameless1: LPDIRECT3DDEVICE; Nameless2: LPD3DEXECUTEBUFFERDESC): HRESULT; stdcall;

        function Lock(Nameless1: LPD3DEXECUTEBUFFERDESC): HRESULT; stdcall;

        function Unlock(): HRESULT; stdcall;

        function SetExecuteData(Nameless1: LPD3DEXECUTEDATA): HRESULT; stdcall;

        function GetExecuteData(Nameless1: LPD3DEXECUTEDATA): HRESULT; stdcall;

        function Validate(Nameless1: LPDWORD; Nameless2: LPD3DVALIDATECALLBACK; Nameless3: LPVOID; Nameless4: DWORD): HRESULT; stdcall;

        function Optimize(Nameless1: DWORD): HRESULT; stdcall;

    end;




(*
 * Light interfaces
 *)


    IDirect3DLight = interface(IUnknown)
        ['{4417C142-33AD-11CF-816F-0000C020156E}']

        (*** IDirect3DLight methods ***)
        function Initialize(Nameless1: LPDIRECT3D): HRESULT; stdcall;

        function SetLight(Nameless1: LPD3DLIGHT): HRESULT; stdcall;

        function GetLight(Nameless1: LPD3DLIGHT): HRESULT; stdcall;

    end;




(*
 * Material interfaces
 *)


    IDirect3DMaterial = interface(IUnknown)
        ['{4417C144-33AD-11CF-816F-0000C020156E}']

        (*** IDirect3DMaterial methods ***)
        function Initialize(Nameless1: LPDIRECT3D): HRESULT; stdcall;

        function SetMaterial(Nameless1: LPD3DMATERIAL): HRESULT; stdcall;

        function GetMaterial(Nameless1: LPD3DMATERIAL): HRESULT; stdcall;

        function GetHandle(Nameless1: LPDIRECT3DDEVICE; Nameless2: LPD3DMATERIALHANDLE): HRESULT; stdcall;

        function Reserve(): HRESULT; stdcall;

        function Unreserve(): HRESULT; stdcall;

    end;




    IDirect3DMaterial2 = interface(IUnknown)
        ['{93281503-8CF8-11D0-89AB-00A0C9054129}']


        (*** IDirect3DMaterial2 methods ***)
        function SetMaterial(Nameless1: LPD3DMATERIAL): HRESULT; stdcall;

        function GetMaterial(Nameless1: LPD3DMATERIAL): HRESULT; stdcall;

        function GetHandle(Nameless1: LPDIRECT3DDEVICE2; Nameless2: LPD3DMATERIALHANDLE): HRESULT; stdcall;

    end;




    IDirect3DMaterial3 = interface(IUnknown)
        ['{CA9C46F4-D3C5-11D1-B75A-00600852B312}']


        (*** IDirect3DMaterial3 methods ***)
        function SetMaterial(Nameless1: LPD3DMATERIAL): HRESULT; stdcall;

        function GetMaterial(Nameless1: LPD3DMATERIAL): HRESULT; stdcall;

        function GetHandle(Nameless1: LPDIRECT3DDEVICE3; Nameless2: LPD3DMATERIALHANDLE): HRESULT; stdcall;

    end;




(*
 * Texture interfaces
 *)


    IDirect3DTexture = interface(IUnknown)
        ['{2CDCD9E0-25A0-11CF-A31A-00AA00B93356}']

        (*** IDirect3DTexture methods ***)
        function Initialize(Nameless1: LPDIRECT3DDEVICE; Nameless2: LPDIRECTDRAWSURFACE): HRESULT; stdcall;

        function GetHandle(Nameless1: LPDIRECT3DDEVICE; Nameless2: LPD3DTEXTUREHANDLE): HRESULT; stdcall;

        function PaletteChanged(Nameless1: DWORD; Nameless2: DWORD): HRESULT; stdcall;

        function Load(Nameless1: LPDIRECT3DTEXTURE): HRESULT; stdcall;

        function Unload(): HRESULT; stdcall;

    end;




    IDirect3DTexture2 = interface(IUnknown)
        ['{93281502-8CF8-11D0-89AB-00A0C9054129}']
        (*** IDirect3DTexture2 methods ***)
        function GetHandle(Nameless1: LPDIRECT3DDEVICE2; Nameless2: LPD3DTEXTUREHANDLE): HRESULT; stdcall;
        function PaletteChanged(Nameless1: DWORD; Nameless2: DWORD): HRESULT; stdcall;
        function Load(Nameless1: LPDIRECT3DTEXTURE2): HRESULT; stdcall;

    end;



(*
 * Viewport interfaces
 *)


    IDirect3DViewport = interface(IUnknown)
        ['{4417C146-33AD-11CF-816F-0000C020156E}']
        (*** IDirect3DViewport methods ***)
        function Initialize(lpDirect3D: IDirect3D): HRESULT; stdcall;
        function GetViewport(lpData: LPD3DVIEWPORT): HRESULT; stdcall;
        function SetViewport(lpData: LPD3DVIEWPORT): HRESULT; stdcall;
        function TransformVertices(dwVertexCount: DWORD; lpData: LPD3DTRANSFORMDATA; dwFlags: DWORD; lpOffscreen: LPDWORD): HRESULT; stdcall;
        function LightElements(dwElementCount: DWORD; lpData: LPD3DLIGHTDATA): HRESULT; stdcall;
        function SetBackground(dwFlags: TD3DMATERIALHANDLE): HRESULT; stdcall;
        function GetBackground(lphMat: LPD3DMATERIALHANDLE; lpValid: LPBOOL): HRESULT; stdcall;
        function SetBackgroundDepth(lpDDSurface: IDirectDrawSurface): HRESULT; stdcall;
        function GetBackgroundDepth(out lplpDDSurface: IDirectDrawSurface; lpValid: LPBOOL): HRESULT; stdcall;
        function Clear(dwCount: DWORD; lpRects: LPD3DRECT; dwFlags: DWORD): HRESULT; stdcall;
        function AddLight(lpDirect3DLight: IDirect3DLight): HRESULT; stdcall;
        function DeleteLight(lpDirect3DLight: IDirect3DLight): HRESULT; stdcall;
        function NextLight(lpDirect3DLight: IDirect3DLight; out lplpDirect3DLight: IDirect3DLight; dwFlags: DWORD): HRESULT; stdcall;
    end;


    IDirect3DViewport2 = interface(IDirect3DViewport)
        ['{93281500-8CF8-11D0-89AB-00A0C9054129}']
        (*** IDirect3DViewport methods ***)
        function Initialize(lpDirect3D: IDirect3D): HRESULT; stdcall;
        function GetViewport(lpData: LPD3DVIEWPORT): HRESULT; stdcall;
        function SetViewport(lpData: LPD3DVIEWPORT): HRESULT; stdcall;
        function TransformVertices(dwVertexCount: DWORD; lpData: LPD3DTRANSFORMDATA; dwFlags: DWORD; lpOffscreen: LPDWORD): HRESULT; stdcall;
        function LightElements(dwElementCount: DWORD; lpData: LPD3DLIGHTDATA): HRESULT; stdcall;
        function SetBackground(hMat: TD3DMATERIALHANDLE): HRESULT; stdcall;
        function GetBackground(lphMat: LPD3DMATERIALHANDLE; lpValid: LPBOOL): HRESULT; stdcall;
        function SetBackgroundDepth(lpDDSurface: IDirectDrawSurface): HRESULT; stdcall;
        function GetBackgroundDepth(out lplpDDSurface: IDirectDrawSurface; lpValid: LPBOOL): HRESULT; stdcall;
        function Clear(dwCount: DWORD; {array of D3DRECT}  lpRects: LPD3DRECT; dwFlags: DWORD): HRESULT; stdcall;
        function AddLight(lpDirect3DLight: IDirect3DLight): HRESULT; stdcall;
        function DeleteLight(lpDirect3DLight: IDirect3DLight): HRESULT; stdcall;
        function NextLight(lpDirect3DLight: IDirect3DLight; out lplpDirect3DLight: IDirect3DLight; dwFlags: DWORD): HRESULT; stdcall;
        function GetViewport2(lpData: LPD3DVIEWPORT2): HRESULT; stdcall;
        function SetViewport2(lpData: LPD3DVIEWPORT2): HRESULT; stdcall;
    end;




    IDirect3DViewport3 = interface(IDirect3DViewport2)
        ['{B0AB3B61-33D7-11D1-A981-00C04FD7B174}']
        (*** IDirect3DViewport2 methods ***)
        function Initialize(lpDirect3D: IDirect3D): HRESULT; stdcall;
        function GetViewport(lpData: LPD3DVIEWPORT): HRESULT; stdcall;
        function SetViewport(lpData: LPD3DVIEWPORT): HRESULT; stdcall;
        function TransformVertices(dwVertexCount: DWORD; lpData: LPD3DTRANSFORMDATA; dwFlags: DWORD; lpOffscreen: LPDWORD): HRESULT; stdcall;
        function LightElements(dwElementCount: DWORD; lpData: LPD3DLIGHTDATA): HRESULT; stdcall;
        function SetBackground(hMat: TD3DMATERIALHANDLE): HRESULT; stdcall;
        function GetBackground(lphMat: LPD3DMATERIALHANDLE; lpValid: LPBOOL): HRESULT; stdcall;
        function SetBackgroundDepth(lpDDSurface: IDirectDrawSurface): HRESULT; stdcall;
        function GetBackgroundDepth(out lplpDDSurface: IDirectDrawSurface; lpValid: LPBOOL): HRESULT; stdcall;
        function Clear(dwCount: DWORD; lpRects: LPD3DRECT; dwFlags: DWORD): HRESULT; stdcall;
        function AddLight(lpDirect3DLight: IDirect3DLight): HRESULT; stdcall;
        function DeleteLight(lpDirect3DLight: IDirect3DLight): HRESULT; stdcall;
        function NextLight(lpDirect3DLight: IDirect3DLight; out lplpDirect3DLight: IDirect3DLight; dwFlags: DWORD): HRESULT; stdcall;
        function GetViewport2(lpData: LPD3DVIEWPORT2): HRESULT; stdcall;
        function SetViewport2(lpData: LPD3DVIEWPORT2): HRESULT; stdcall;
        function SetBackgroundDepth2(lpDDS: IDirectDrawSurface4): HRESULT; stdcall;
        function GetBackgroundDepth2(out lplpDDS: IDirectDrawSurface4; lpValid: LPBOOL): HRESULT; stdcall;
        function Clear2(dwCount: DWORD; lpRects: LPD3DRECT; dwFlags: DWORD; dwColor: TD3DCOLOR; dvZ: TD3DVALUE; dwStencil: DWORD): HRESULT; stdcall;
    end;


    IDirect3DVertexBuffer = interface(IUnknown)
        ['{7A503555-4A83-11D1-A5DB-00A0C90367F8}']
        (*** IDirect3DVertexBuffer methods ***)
        function Lock(dwFlags: DWORD; out lplpData: LPVOID; lpdwSize: LPDWORD): HRESULT; stdcall;
        function Unlock(): HRESULT; stdcall;
        function ProcessVertices(dwVertexOp: DWORD; dwDestIndex: DWORD; dwCount: DWORD; lpSrcBuffer: IDirect3DVertexBuffer; dwSrcIndex: DWORD; lpD3DDevice: IDirect3DDevice3; dwFlags: DWORD): HRESULT; stdcall;
        function GetVertexBufferDesc(lpVBDesc: LPD3DVERTEXBUFFERDESC): HRESULT; stdcall;
        function Optimize(lpD3DDevice: IDirect3DDevice3; dwFlags: DWORD): HRESULT; stdcall;
    end;




    IDirect3DVertexBuffer7 = interface(IUnknown)
        ['{F5049E7D-4861-11D2-A407-00A0C90629A8}']
        (*** IDirect3DVertexBuffer7 methods ***)
        function Lock(dwFlags: DWORD; out lplpData: LPVOID; lpdwSize: LPDWORD): HRESULT; stdcall;
        function Unlock(): HRESULT; stdcall;
        function ProcessVertices(dwVertexOp: DWORD; dwDestIndex: DWORD; dwCount: DWORD; lpSrcBuffer: IDirect3DVertexBuffer7; dwSrcIndex: DWORD; lpD3DDevice: IDirect3DDevice7; dwFlags: DWORD): HRESULT; stdcall;
        function GetVertexBufferDesc(lpVBDesc: LPD3DVERTEXBUFFERDESC): HRESULT; stdcall;
        function Optimize(lpD3DDevice: IDirect3DDevice7; Nameless2: DWORD): HRESULT; stdcall;
        function ProcessVerticesStrided(dwVertexOp: DWORD; dwDestIndex: DWORD; dwCount: DWORD; lpVertexArray: LPD3DDRAWPRIMITIVESTRIDEDDATA; dwSrcIndex: DWORD; lpD3DDevice: IDirect3DDevice7; dwFlags: DWORD): HRESULT; stdcall;

    end;




implementation

end.
