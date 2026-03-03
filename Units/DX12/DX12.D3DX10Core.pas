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
   Content:    D3DX10 core types and functions

   This unit consists of the following header files
   File name: d3dx10core.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3DX10Core;


{$IFDEF FPC}
{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.DXGI,
    DX12.D3D10Misc,
    DX12.D3D10,
    DX12.D3D10_1,
    DX12.D3DX10Math;

    {$Z4}

const
    // Current name of the DLL shipped in the same SDK as this header.
    D3DX10_DLL = 'd3dx10_43.dll';

    ///////////////////////////////////////////////////////////////////////////
    // D3DX10_SDK_VERSION:
    // -----------------
    // This identifier is passed to D3DX10CheckVersion in order to ensure that an
    // application was built against the correct header files and lib files.
    // This number is incremented whenever a header (or other) change would
    // require applications to be rebuilt. If the version doesn't match,
    // D3DX10CreateVersion will return FALSE. (The number itself has no meaning.)
    ///////////////////////////////////////////////////////////////////////////


    D3DX10_SDK_VERSION = 43;

    _FACD3D = $876;

    D3DERR_INVALIDCALL = ((1 shl 31) or (_FACD3D shl 16) or (2156));
    D3DERR_WASSTILLDRAWING = ((1 shl 31) or (_FACD3D shl 16) or (540));


    // {BA0B762D-8D28-43ec-B9DC-2F84443B0614}
    IID_ID3DX10Sprite: TGUID = '{BA0B762D-8D28-43EC-B9DC-2F84443B0614}';


    // {C93FECFA-6967-478a-ABBC-402D90621FCB}
    IID_ID3DX10ThreadPump: TGUID = '{C93FECFA-6967-478A-ABBC-402D90621FCB}';


    // {D79DBB70-5F21-4d36-BBC2-FF525C213CDC}
    IID_ID3DX10Font: TGUID = '{D79DBB70-5F21-4D36-BBC2-FF525C213CDC}';


type
    ID3DX10Sprite = interface;
    LPD3DX10SPRITE = ^ID3DX10Sprite;


    ID3DX10Font = interface;
    LPD3DX10FONT = ^ID3DX10Font;

    //////////////////////////////////////////////////////////////////////////////
    // D3DX10_SPRITE flags:
    // -----------------
    // D3DX10_SPRITE_SAVE_STATE
    //   Specifies device state should be saved and restored in Begin/End.
    // D3DX10SPRITE_SORT_TEXTURE
    //   Sprites are sorted by texture prior to drawing.  This is recommended when
    //   drawing non-overlapping sprites of uniform depth.  For example, drawing
    //   screen-aligned text with ID3DX10Font.
    // D3DX10SPRITE_SORT_DEPTH_FRONT_TO_BACK
    //   Sprites are sorted by depth front-to-back prior to drawing.  This is
    //   recommended when drawing opaque sprites of varying depths.
    // D3DX10SPRITE_SORT_DEPTH_BACK_TO_FRONT
    //   Sprites are sorted by depth back-to-front prior to drawing.  This is
    //   recommended when drawing transparent sprites of varying depths.
    // D3DX10SPRITE_ADDREF_TEXTURES
    //   AddRef/Release all textures passed in to DrawSpritesBuffered
    //////////////////////////////////////////////////////////////////////////////

    _D3DX10_SPRITE_FLAG = (
        D3DX10_SPRITE_SORT_TEXTURE = $01,
        D3DX10_SPRITE_SORT_DEPTH_BACK_TO_FRONT = $02,
        D3DX10_SPRITE_SORT_DEPTH_FRONT_TO_BACK = $04,
        D3DX10_SPRITE_SAVE_STATE = $08,
        D3DX10_SPRITE_ADDREF_TEXTURES = $10);

    TD3DX10_SPRITE_FLAG = _D3DX10_SPRITE_FLAG;
    PD3DX10_SPRITE_FLAG = ^TD3DX10_SPRITE_FLAG;


    _D3DX10_SPRITE = record
        matWorld: TD3DXMATRIX;
        TexCoord: TD3DXVECTOR2;
        TexSize: TD3DXVECTOR2;
        ColorModulate: TD3DXCOLOR;
        pTexture: PID3D10ShaderResourceView;
        TextureIndex: UINT;
    end;
    TD3DX10_SPRITE = _D3DX10_SPRITE;
    PD3DX10_SPRITE = ^TD3DX10_SPRITE;


    //////////////////////////////////////////////////////////////////////////////
    // ID3DX10Sprite:
    // ------------
    // This object intends to provide an easy way to drawing sprites using D3D.

    // Begin -
    //    Prepares device for drawing sprites.

    // Draw -
    //    Draws a sprite

    // Flush -
    //    Forces all batched sprites to submitted to the device.

    // End -
    //    Restores device state to how it was when Begin was called.

    //////////////////////////////////////////////////////////////////////////////

    ID3DX10Sprite = interface(IUnknown)
        ['{BA0B762D-8D28-43ec-B9DC-2F84443B0614}']
        // ID3DX10Sprite
        function _Begin(flags: UINT): HRESULT; stdcall;

        function DrawSpritesBuffered(pSprites: PD3DX10_SPRITE; cSprites: UINT): HRESULT; stdcall;

        function Flush(): HRESULT; stdcall;

        function DrawSpritesImmediate(pSprites: PD3DX10_SPRITE; cSprites: UINT; cbSprite: UINT; flags: UINT): HRESULT; stdcall;

        function _End(): HRESULT; stdcall;

        function GetViewTransform(pViewTransform: PD3DXMATRIX): HRESULT; stdcall;

        function SetViewTransform(pViewTransform: PD3DXMATRIX): HRESULT; stdcall;

        function GetProjectionTransform(pProjectionTransform: PD3DXMATRIX): HRESULT; stdcall;

        function SetProjectionTransform(pProjectionTransform: PD3DXMATRIX): HRESULT; stdcall;

        function GetDevice(out ppDevice: ID3D10Device): HRESULT; stdcall;

    end;


    //////////////////////////////////////////////////////////////////////////////
    // ID3DX10ThreadPump:
    //////////////////////////////////////////////////////////////////////////////


    {$interfaces corba}
    ID3DX10DataLoader = interface
        function Load(): HRESULT; stdcall;

        function Decompress(
        {out} out ppData: pointer; pcBytes: PSIZE_T): HRESULT; stdcall;

        function Destroy(): HRESULT; stdcall;

    end;

    {$interfaces COM}


    {$interfaces corba}
    ID3DX10DataProcessor = interface
        function Process(pData: Pvoid; cBytes: SIZE_T): HRESULT; stdcall;

        function CreateDeviceObject(
        {out} out ppDataObject: pointer): HRESULT; stdcall;

        function Destroy(): HRESULT; stdcall;

    end;

    {$interfaces COM}


    ID3DX10ThreadPump = interface(IUnknown)
        ['{C93FECFA-6967-478a-ABBC-402D90621FCB}']
        // ID3DX10ThreadPump
        function AddWorkItem(
        {in} pDataLoader: ID3DX10DataLoader;
        {in} pDataProcessor: ID3DX10DataProcessor;
        {in} pHResult: PHRESULT;
        {out} out ppDeviceObject: pointer): HRESULT; stdcall;

        function GetWorkItemCount(): UINT; stdcall;

        function WaitForAllItems(): HRESULT; stdcall;

        function ProcessDeviceWorkItems(
        {in} iWorkItemCount: UINT): HRESULT; stdcall;

        function PurgeAllItems(): HRESULT; stdcall;

        function GetQueueStatus(pIoQueue: PUINT; pProcessQueue: PUINT; pDeviceQueue: PUINT): HRESULT; stdcall;

    end;


    //////////////////////////////////////////////////////////////////////////////
    // ID3DX10Font:
    // ----------
    // Font objects contain the textures and resources needed to render a specific
    // font on a specific device.

    // GetGlyphData -
    //    Returns glyph cache data, for a given glyph.

    // PreloadCharacters/PreloadGlyphs/PreloadText -
    //    Preloads glyphs into the glyph cache textures.

    // DrawText -
    //    Draws formatted text on a D3D device.  Some parameters are
    //    surprisingly similar to those of GDI's DrawText function.  See GDI
    //    documentation for a detailed description of these parameters.
    //    If pSprite is NULL, an internal sprite object will be used.

    //////////////////////////////////////////////////////////////////////////////

    _D3DX10_FONT_DESCA = record
        Height: int32;
        Width: UINT;
        Weight: UINT;
        MipLevels: UINT;
        Italic: boolean;
        CharSet: TBYTE;
        OutputPrecision: TBYTE;
        Quality: TBYTE;
        PitchAndFamily: TBYTE;
        FaceName: array [0..LF_FACESIZE - 1] of TCHAR;
    end;
    TD3DX10_FONT_DESCA = _D3DX10_FONT_DESCA;
    PD3DX10_FONT_DESCA = ^TD3DX10_FONT_DESCA;

    LPD3DX10_FONT_DESCA = ^TD3DX10_FONT_DESCA;

    _D3DX10_FONT_DESCW = record
        Height: int32;
        Width: UINT;
        Weight: UINT;
        MipLevels: UINT;
        Italic: boolean;
        CharSet: TBYTE;
        OutputPrecision: TBYTE;
        Quality: TBYTE;
        PitchAndFamily: TBYTE;
        FaceName: array [0..LF_FACESIZE - 1] of WCHAR;
    end;
    TD3DX10_FONT_DESCW = _D3DX10_FONT_DESCW;
    PD3DX10_FONT_DESCW = ^TD3DX10_FONT_DESCW;

    LPD3DX10_FONT_DESCW = ^TD3DX10_FONT_DESCW;


    ID3DX10Font = interface(IUnknown)
        ['{D79DBB70-5F21-4d36-BBC2-FF525C213CDC}']
        // ID3DX10Font
        function GetDevice({out} out ppDevice: ID3D10Device): HRESULT; stdcall;

        function GetDescA(pDesc: PD3DX10_FONT_DESCA): HRESULT; stdcall;

        function GetDescW(pDesc: PD3DX10_FONT_DESCW): HRESULT; stdcall;

        function GetTextMetricsA(pTextMetrics: PTEXTMETRICA): boolean; stdcall;

        function GetTextMetricsW(pTextMetrics: PTEXTMETRICW): boolean; stdcall;

        function GetDC(): HDC; stdcall;

        function GetGlyphData(Glyph: UINT; {out} out ppTexture: ID3D10ShaderResourceView; pBlackBox: PRECT; pCellInc: PPOINT): HRESULT; stdcall;

        function PreloadCharacters(First: UINT; Last: UINT): HRESULT; stdcall;

        function PreloadGlyphs(First: UINT; Last: UINT): HRESULT; stdcall;

        function PreloadTextA(pString: LPCSTR; Count: int32): HRESULT; stdcall;

        function PreloadTextW(pString: LPCWSTR; Count: int32): HRESULT; stdcall;

        function DrawTextA(pSprite: LPD3DX10SPRITE; pString: LPCSTR; Count: int32; pRect: LPRECT; Format: UINT; Color: TD3DXCOLOR): int32; stdcall;

        function DrawTextW(pSprite: LPD3DX10SPRITE; pString: LPCWSTR; Count: int32; pRect: LPRECT; Format: UINT; Color: TD3DXCOLOR): int32; stdcall;

    end;

    { ID3DX10FontHelper }

    ID3DX10FontHelper = type helper for ID3DX10Font
        function GetDesc(pDesc: PD3DX10_FONT_DESCW): HRESULT; stdcall;

        function PreloadText(pString: LPCWSTR; Count: int32): HRESULT; stdcall;

        function GetDesc(pDesc: PD3DX10_FONT_DESCA): HRESULT; stdcall;

        function PreloadText(pString: LPCSTR; Count: int32): HRESULT; stdcall;

    end;

function MAKE_D3DHRESULT(code: longword): HResult;
function MAKE_D3DSTATUS(code: longword): HResult;


function D3DX10CreateThreadPump(
    {_In_} cIoThreads: UINT;
    {_In_} cProcThreads: UINT;
    {_Out_} out ppThreadPump: ID3DX10ThreadPump): HRESULT; stdcall; external D3DX10_DLL;


///////////////////////////////////////////////////////////////////////////
// D3DX10CreateDevice
// D3DX10CreateDeviceAndSwapChain
// D3DX10GetFeatureLevel1
///////////////////////////////////////////////////////////////////////////
function D3DX10CreateDevice(
    {_In_} pAdapter: IDXGIAdapter;
    {_In_} DriverType: TD3D10_DRIVER_TYPE;
    {_In_} Software: HMODULE;
    {_In_} Flags: UINT;
    {_Out_} out ppDevice: ID3D10Device): HRESULT; stdcall; external D3DX10_DLL;


function D3DX10CreateDeviceAndSwapChain(
    {_In_} pAdapter: IDXGIAdapter;
    {_In_} DriverType: TD3D10_DRIVER_TYPE;
    {_In_} Software: HMODULE;
    {_In_} Flags: UINT;
    {_In_} pSwapChainDesc: PDXGI_SWAP_CHAIN_DESC;
    {_Out_} out ppSwapChain: IDXGISwapChain;
    {_Out_} out ppDevice: ID3D10Device): HRESULT; stdcall;external D3DX10_DLL;


function D3DX10GetFeatureLevel1(pDevice: ID3D10Device; out ppDevice1: ID3D10Device1): HRESULT; stdcall; external D3DX10_DLL;


function D3DX10DebugMute(Mute: boolean): boolean; stdcall;external D3DX10_DLL;


function D3DX10CheckVersion(D3DSdkVersion: UINT; D3DX10SdkVersion: UINT): HRESULT; stdcall; external D3DX10_DLL;


function D3DX10CreateSprite(
    {_In_} pDevice: ID3D10Device;
    {_In_} cDeviceBufferSize: UINT;
    {_Out_} out ppSprite: ID3DX10Sprite): HRESULT; stdcall; external D3DX10_DLL;


function D3DX10CreateFontA(
    {_In_} pDevice: ID3D10Device;
    {_In_} Height: int32;
    {_In_} Width: UINT;
    {_In_} Weight: UINT;
    {_In_} MipLevels: UINT;
    {_In_} Italic: boolean;
    {_In_} CharSet: UINT;
    {_In_} OutputPrecision: UINT;
    {_In_} Quality: UINT;
    {_In_} PitchAndFamily: UINT;
    {_In_} pFaceName: LPCSTR;
    {_Out_} out ppFont: ID3DX10Font): HRESULT; stdcall;external D3DX10_DLL;


function D3DX10CreateFontW(
    {_In_} pDevice: ID3D10Device;
    {_In_} Height: int32;
    {_In_} Width: UINT;
    {_In_} Weight: UINT;
    {_In_} MipLevels: UINT;
    {_In_} Italic: boolean;
    {_In_} CharSet: UINT;
    {_In_} OutputPrecision: UINT;
    {_In_} Quality: UINT;
    {_In_} PitchAndFamily: UINT;
    {_In_}  pFaceName: LPCWSTR;
    {_Out_} out ppFont: ID3DX10Font): HRESULT; stdcall; external D3DX10_DLL;


function D3DX10CreateFontIndirectA(
    {_In_} pDevice: ID3D10Device;
    {_In_} pDesc: PD3DX10_FONT_DESCA;
    {_Out_} out ppFont: ID3DX10Font): HRESULT; stdcall; external D3DX10_DLL;


function D3DX10CreateFontIndirectW(
    {_In_} pDevice: ID3D10Device;
    {_In_} pDesc: PD3DX10_FONT_DESCW;
    {_Out_} out ppFont: ID3DX10Font): HRESULT; stdcall;external D3DX10_DLL;


function D3DX10UnsetAllDeviceObjects(pDevice: ID3D10Device): HRESULT; stdcall;external D3DX10_DLL;


implementation

uses
    Windows.Macros;



function MAKE_D3DHRESULT(code: longword): HResult;
begin
    Result := MAKE_HRESULT(1, _FACD3D, code);
end;



function MAKE_D3DSTATUS(code: longword): HResult;
begin
    Result := MAKE_HRESULT(0, _FACD3D, code);
end;


{ ID3DX10FontHelper }

function ID3DX10FontHelper.GetDesc(pDesc: PD3DX10_FONT_DESCW): HRESULT; stdcall;
begin
    Result := GetDescW(pDesc);
end;



function ID3DX10FontHelper.PreloadText(pString: LPCWSTR; Count: int32): HRESULT; stdcall;
begin
    Result := PreloadTextW(pString, Count);
end;



function ID3DX10FontHelper.GetDesc(pDesc: PD3DX10_FONT_DESCA): HRESULT; stdcall;
begin
    Result := GetDescA(pDesc);
end;



function ID3DX10FontHelper.PreloadText(pString: LPCSTR; Count: int32): HRESULT; stdcall;
begin
    Result := PreloadTextA(pString, Count);
end;

end.
