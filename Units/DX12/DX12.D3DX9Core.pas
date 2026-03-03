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
   Content:    D3DX core types and functions

   This unit consists of the following header files
   File name: d3dx9core.h
   Header version: 10.0.26100.6584  and v9.0

  ************************************************************************** }
unit DX12.D3DX9Core;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D9,
    DX12.D3D9Types,
    DX12.D3DX9Math;

    {$Z4}

    // for different SDK versions
    {$I DX12.DX9SDKVersion.inc}

const
    {$IFDEF USESDK43 }
    // {8BA5FB08-5195-40e2-AC58-0D989C3A0102}
    IID_ID3DXBuffer: TGUID = '{8BA5FB08-5195-40E2-AC58-0D989C3A0102}';
    {$ELSE}
    // {932E6A7E-C68E-45dd-A7BF-53D19C86DB1F}
    IID_ID3DXBuffer: TGUID = '{932E6A7E-C68E-45DD-A7BF-53D19C86DB1F}';
    {$ENDIF}



    {$IFDEF USESDK43}
    // {D79DBB70-5F21-4d36-BBC2-FF525C213CDC}
    IID_ID3DXFont: TGUID = '{D79DBB70-5F21-4D36-BBC2-FF525C213CDC}';
    {$ELSE}
// {4AAE6B4D-D15F-4909-B09F-8D6AA34AC06B}
    IID_ID3DXFont: TGUID = '{4AAE6B4D-D15F-4909-B09F-8D6AA34AC06B}';
    {$ENDIF}



    {$IFDEF USESDK43}
    // {6985F346-2C3D-43b3-BE8B-DAAE8A03D894}
    IID_ID3DXRenderToSurface: TGUID = '{6985F346-2C3D-43B3-BE8B-DAAE8A03D894}';
    {$ELSE}
    // {0D014791-8863-4c2c-A1C0-02F3E0C0B653}
    IID_ID3DXRenderToSurface: TGUID = '{0D014791-8863-4C2C-A1C0-02F3E0C0B653}';
    {$ENDIF}



    {$IFDEF USESDK43}
    // {313F1B4B-C7B0-4fa2-9D9D-8D380B64385E}
    IID_ID3DXRenderToEnvMap: TGUID = '{313F1B4B-C7B0-4FA2-9D9D-8D380B64385E}';
    {$ELSE}
    // {1561135E-BC78-495b-8586-94EA537BD557}
    IID_ID3DXRenderToEnvMap: TGUID = '{1561135E-BC78-495B-8586-94EA537BD557}';
    {$ENDIF}



    {$IFDEF USESDK43}
    // {D379BA7F-9042-4ac4-9F5E-58192A4C6BD8}
    IID_ID3DXLine: TGUID = '{D379BA7F-9042-4AC4-9F5E-58192A4C6BD8}';
    {$ELSE}
    // {72CE4D70-CC40-4143-A896-32E50AD2EF35}
    IID_ID3DXLine: TGUID = '{72CE4D70-CC40-4143-A896-32E50AD2EF35}';
    {$ENDIF}

    //////////////////////////////////////////////////////////////////////////////
    // D3DXSPRITE flags:
    // -----------------
    // D3DXSPRITE_DONOTSAVESTATE
    //   Specifies device state is not to be saved and restored in Begin/End.
    // D3DXSPRITE_DONOTMODIFY_RENDERSTATE
    //   Specifies device render state is not to be changed in Begin.  The device
    //   is assumed to be in a valid state to draw vertices containing POSITION0,
    //   TEXCOORD0, and COLOR0 data.
    // D3DXSPRITE_OBJECTSPACE
    //   The WORLD, VIEW, and PROJECTION transforms are NOT modified.  The
    //   transforms currently set to the device are used to transform the sprites
    //   when the batch is drawn (at Flush or End).  If this is not specified,
    //   WORLD, VIEW, and PROJECTION transforms are modified so that sprites are
    //   drawn in screenspace coordinates.
    // D3DXSPRITE_BILLBOARD
    //   Rotates each sprite about its center so that it is facing the viewer.
    // D3DXSPRITE_ALPHABLEND
    //   Enables ALPHABLEND(SRCALPHA, INVSRCALPHA) and ALPHATEST(alpha > 0).
    //   ID3DXFont expects this to be set when drawing text.
    // D3DXSPRITE_SORT_TEXTURE
    //   Sprites are sorted by texture prior to drawing.  This is recommended when
    //   drawing non-overlapping sprites of uniform depth.  For example, drawing
    //   screen-aligned text with ID3DXFont.
    // D3DXSPRITE_SORT_DEPTH_FRONTTOBACK
    //   Sprites are sorted by depth front-to-back prior to drawing.  This is
    //   recommended when drawing opaque sprites of varying depths.
    // D3DXSPRITE_SORT_DEPTH_BACKTOFRONT
    //   Sprites are sorted by depth back-to-front prior to drawing.  This is
    //   recommended when drawing transparent sprites of varying depths.
    // D3DXSPRITE_DO_NOT_ADDREF_TEXTURE
    //   Disables calling AddRef() on every draw, and Release() on Flush() for
    //   better performance.
    //////////////////////////////////////////////////////////////////////////////

    D3DXSPRITE_DONOTSAVESTATE = (1 shl 0);
    D3DXSPRITE_DONOTMODIFY_RENDERSTATE = (1 shl 1);
    D3DXSPRITE_OBJECTSPACE = (1 shl 2);
    D3DXSPRITE_BILLBOARD = (1 shl 3);
    D3DXSPRITE_ALPHABLEND = (1 shl 4);
    D3DXSPRITE_SORT_TEXTURE = (1 shl 5);
    D3DXSPRITE_SORT_DEPTH_FRONTTOBACK = (1 shl 6);
    D3DXSPRITE_SORT_DEPTH_BACKTOFRONT = (1 shl 7);
    D3DXSPRITE_DO_NOT_ADDREF_TEXTURE = (1 shl 8);



    {$IFDEF USESDK43}
    // {BA0B762D-7D28-43ec-B9DC-2F84443B0614}
    IID_ID3DXSprite: TGUID = '{BA0B762D-7D28-43EC-B9DC-2F84443B0614}';
    {$ELSE}
// {B07EC84A-8D35-4e86-A9A0-8DFF21D71075}
    IID_ID3DXSprite: TGUID = '{B07EC84A-8D35-4E86-A9A0-8DFF21D71075}';
    {$ENDIF}



type

    ID3DXBuffer = interface;
    LPD3DXBUFFER = ^ID3DXBuffer;

    ID3DXFont = interface;
    LPD3DXFONT = ^ID3DXFont;

    ID3DXSprite = interface;
    LPD3DXSPRITE = ^ID3DXSprite;

    ID3DXRenderToSurface = interface;
    LPD3DXRENDERTOSURFACE = ^ID3DXRenderToSurface;

    ID3DXRenderToEnvMap = interface;
    LPD3DXRenderToEnvMap = ^ID3DXRenderToEnvMap;

    ID3DXLine = interface;
    LPD3DXLINE = ^ID3DXLine;

    ///////////////////////////////////////////////////////////////////////////
    // ID3DXBuffer:
    // ------------
    // The buffer object is used by D3DX to return arbitrary size data.

    // GetBufferPointer -
    //    Returns a pointer to the beginning of the buffer.

    // GetBufferSize -
    //    Returns the size of the buffer, in bytes.
    ///////////////////////////////////////////////////////////////////////////

    {$IFDEF USESDK43 }
    ID3DXBuffer = interface(IUnknown)
        ['{8BA5FB08-5195-40E2-AC58-0D989C3A0102}']
        // ID3DXBuffer
        function GetBufferPointer(): LPVOID; stdcall;
        function GetBufferSize(): DWORD; stdcall;
    end;
    PID3DXBuffer = ^ID3DXBuffer;

    {$ELSE}
    ID3DXBuffer = interface(IUnknown)
        ['{932E6A7E-C68E-45DD-A7BF-53D19C86DB1F}']
        // ID3DXBuffer
        function GetBufferPointer(): pointer; stdcall;
        function GetBufferSize(): DWORD; stdcall;
    end;
    {$ENDIF}


    {$IFDEF USESDK43 }
    //////////////////////////////////////////////////////////////////////////////
    // ID3DXSprite:
    // ------------
    // This object intends to provide an easy way to drawing sprites using D3D.

    // Begin -
    //    Prepares device for drawing sprites.

    // Draw -
    //    Draws a sprite.  Before transformation, the sprite is the size of
    //    SrcRect, with its top-left corner specified by Position.  The color
    //    and alpha channels are modulated by Color.

    // Flush -
    //    Forces all batched sprites to submitted to the device.

    // End -
    //    Restores device state to how it was when Begin was called.

    // OnLostDevice, OnResetDevice -
    //    Call OnLostDevice() on this object before calling Reset() on the
    //    device, so that this object can release any stateblocks and video
    //    memory resources.  After Reset(), the call OnResetDevice().
    //////////////////////////////////////////////////////////////////////////////


    ID3DXSprite = interface(IUnknown)
        ['{BA0B762D-7D28-43EC-B9DC-2F84443B0614}']
        // ID3DXSprite
        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;

        function GetTransform(pTransform: PD3DXMATRIX): HRESULT; stdcall;

        function SetTransform(pTransform: PD3DXMATRIX): HRESULT; stdcall;

        function SetWorldViewRH(pWorld: PD3DXMATRIX; pView: PD3DXMATRIX): HRESULT; stdcall;

        function SetWorldViewLH(pWorld: PD3DXMATRIX; pView: PD3DXMATRIX): HRESULT; stdcall;

        function _Begin(Flags: DWORD): HRESULT; stdcall;

        function Draw(pTexture: IDirect3DTexture9; pSrcRect: PRECT; pCenter: PD3DXVECTOR3; pPosition: PD3DXVECTOR3; Color: TD3DCOLOR): HRESULT; stdcall;

        function Flush(): HRESULT; stdcall;

        function _End(): HRESULT; stdcall;

        function OnLostDevice(): HRESULT; stdcall;

        function OnResetDevice(): HRESULT; stdcall;

    end;

    {$ELSE}

///////////////////////////////////////////////////////////////////////////
  // ID3DXSprite:
  // ------------
  // This object intends to provide an easy way to drawing sprites using D3D.

  // Begin -
  //    Prepares device for drawing sprites

  // Draw, DrawAffine, DrawTransform -
  //    Draws a sprite in screen-space.  Before transformation, the sprite is
  //    the size of SrcRect, with its top-left corner at the origin (0,0).
  //    The color and alpha channels are modulated by Color.

  // End -
  //     Restores device state to how it was when Begin was called.

  // OnLostDevice, OnResetDevice -
  //    Call OnLostDevice() on this object before calling Reset() on the
  //    device, so that this object can release any stateblocks and video
  //    memory resources.  After Reset(), the call OnResetDevice().
  ///////////////////////////////////////////////////////////////////////////



  ID3DXSprite = interface(IUnknown)
      ['{B07EC84A-8D35-4E86-A9A0-8DFF21D71075}']
      // ID3DXSprite
      function GetDevice(out ppDevice: LPDIRECT3DDEVICE9): HRESULT; stdcall;
      function _Begin(): HRESULT; stdcall;
      function Draw(pSrcTexture: IDirect3DTexture9; pSrcRect: PRECT; pScaling: PD3DXVECTOR2; pRotationCenter: PD3DXVECTOR2; Rotation: single; pTranslation: PD3DXVECTOR2; Color: TD3DCOLOR): HRESULT; stdcall;
      function DrawTransform(pSrcTexture: LPDIRECT3DTEXTURE9; pSrcRect: PRECT; pTransform: PD3DXMATRIX; Color: TD3DCOLOR): HRESULT; stdcall;
      function _End(): HRESULT; stdcall;
      function OnLostDevice(): HRESULT; stdcall;
      function OnResetDevice(): HRESULT; stdcall;
  end;


    {$ENDIF}


    ///////////////////////////////////////////////////////////////////////////
    // ID3DXFont:
    // ----------
    // Font objects contain the textures and resources needed to render
    // a specific font on a specific device.

    // Begin -
    //    Prepartes device for drawing text.  This is optional.. if DrawText
    //    is called outside of Begin/End, it will call Begin and End for you.

    // DrawText -
    //    Draws formatted text on a D3D device.  Some parameters are
    //    surprisingly similar to those of GDI's DrawText function.  See GDI
    //    documentation for a detailed description of these parameters.

    // End -
    //    Restores device state to how it was when Begin was called.

    // OnLostDevice, OnResetDevice -
    //    Call OnLostDevice() on this object before calling Reset() on the
    //    device, so that this object can release any stateblocks and video
    //    memory resources.  After Reset(), the call OnResetDevice().

    ///////////////////////////////////////////////////////////////////////////


    //////////////////////////////////////////////////////////////////////////////
    // ID3DXFont:
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

    // OnLostDevice, OnResetDevice -
    //    Call OnLostDevice() on this object before calling Reset() on the
    //    device, so that this object can release any stateblocks and video
    //    memory resources.  After Reset(), the call OnResetDevice().
    //////////////////////////////////////////////////////////////////////////////

    _D3DXFONT_DESCA = record
        Height: int32;
        Width: UINT;
        Weight: UINT;
        MipLevels: UINT;
        Italic: boolean;
        CharSet: byte;
        OutputPrecision: byte;
        Quality: byte;
        PitchAndFamily: byte;
        FaceName: array [0..LF_FACESIZE - 1] of ansichar;
    end;
    TD3DXFONT_DESCA = _D3DXFONT_DESCA;
    PD3DXFONT_DESCA = ^TD3DXFONT_DESCA;
    LPD3DXFONT_DESCA = ^TD3DXFONT_DESCA;

    _D3DXFONT_DESCW = record
        Height: int32;
        Width: UINT;
        Weight: UINT;
        MipLevels: UINT;
        Italic: boolean;
        CharSet: byte;
        OutputPrecision: byte;
        Quality: byte;
        PitchAndFamily: byte;
        FaceName: array [0..LF_FACESIZE - 1] of WCHAR;
    end;
    TD3DXFONT_DESCW = _D3DXFONT_DESCW;
    PD3DXFONT_DESCW = ^TD3DXFONT_DESCW;
    LPD3DXFONT_DESCW = ^TD3DXFONT_DESCW;

    {$IFDEF USESDK43}
    ID3DXFont = interface(IUnknown)
        ['{D79DBB70-5F21-4D36-BBC2-FF525C213CDC}']
        // ID3DXFont
        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;

        function GetDescA(pDesc: PD3DXFONT_DESCA): HRESULT; stdcall;

        function GetDescW(pDesc: PD3DXFONT_DESCW): HRESULT; stdcall;

        function GetTextMetricsA(pTextMetrics: PTEXTMETRICA): boolean; stdcall;

        function GetTextMetricsW(pTextMetrics: PTEXTMETRICW): boolean; stdcall;

        function GetDC(): HDC; stdcall;

        function GetGlyphData(Glyph: UINT; out ppTexture: IDirect3DTexture9; pBlackBox: PRECT; pCellInc: PPOINT): HRESULT; stdcall;

        function PreloadCharacters(First: UINT; Last: UINT): HRESULT; stdcall;

        function PreloadGlyphs(First: UINT; Last: UINT): HRESULT; stdcall;

        function PreloadTextA(pString: LPCSTR; Count: int32): HRESULT; stdcall;

        function PreloadTextW(pString: LPCWSTR; Count: int32): HRESULT; stdcall;

        function DrawTextA(pSprite: LPD3DXSPRITE; pString: LPCSTR; Count: int32; pRect: LPRECT; Format: DWORD; Color: TD3DCOLOR): int32; stdcall;

        function DrawTextW(pSprite: LPD3DXSPRITE; pString: LPCWSTR; Count: int32; pRect: LPRECT; Format: DWORD; Color: TD3DCOLOR): int32; stdcall;

        function OnLostDevice(): HRESULT; stdcall;

        function OnResetDevice(): HRESULT; stdcall;

    end;

    { ID3DXFontHelper }

    ID3DXFontHelper = type helper for ID3DXFont
        function GetDesc(pDesc: PD3DXFONT_DESCW): HRESULT; overload;

        function PreloadText(pString: LPCWSTR; Count: int32): HRESULT; overload;

        function GetDesc(pDesc: PD3DXFONT_DESCA): HRESULT; overload;

        function PreloadText(pString: LPCSTR; Count: int32): HRESULT; overload;

    end;
    {$ELSE}

    ID3DXFont = interface(IUnknown)
        ['{4AAE6B4D-D15F-4909-B09F-8D6AA34AC06B}']
        // ID3DXFont
        function GetDevice(out ppDevice: LPDIRECT3DDEVICE9): HRESULT; stdcall;
        function GetLogFont(pLogFont: PLOGFONT): HRESULT; stdcall;
        function _Begin(): HRESULT; stdcall;
        function DrawTextA(pString: LPCSTR; Count: int32; pRect: LPRECT; Format: DWORD; Color: TD3DCOLOR): int32; stdcall;
        function DrawTextW(pString: LPCWSTR; Count: int32; pRect: LPRECT; Format: DWORD; Color: TD3DCOLOR): int32; stdcall;
        function _End(): HRESULT; stdcall;
        function OnLostDevice(): HRESULT; stdcall;
        function OnResetDevice(): HRESULT; stdcall;
    end;
    {$ENDIF}



    ///////////////////////////////////////////////////////////////////////////
    // ID3DXRenderToSurface:
    // ---------------------
    // This object abstracts rendering to surfaces.  These surfaces do not
    // necessarily need to be render targets.  If they are not, a compatible
    // render target is used, and the result copied into surface at end scene.

    // BeginScene, EndScene -
    //    Call BeginScene() and EndScene() at the beginning and ending of your
    //    scene.  These calls will setup and restore render targets, viewports,
    //    etc..

    // OnLostDevice, OnResetDevice -
    //    Call OnLostDevice() on this object before calling Reset() on the
    //    device, so that this object can release any stateblocks and video
    //    memory resources.  After Reset(), the call OnResetDevice().
    ///////////////////////////////////////////////////////////////////////////

    _D3DXRTS_DESC = record
        Width: UINT;
        Height: UINT;
        Format: TD3DFORMAT;
        DepthStencil: boolean;
        DepthStencilFormat: TD3DFORMAT;
    end;
    TD3DXRTS_DESC = _D3DXRTS_DESC;
    PD3DXRTS_DESC = ^TD3DXRTS_DESC;


    {$IFDEF USESDK43}
    ID3DXRenderToSurface = interface(IUnknown)
        ['{6985F346-2C3D-43B3-BE8B-DAAE8A03D894}']
        // ID3DXRenderToSurface
        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;
        function GetDesc(pDesc: PD3DXRTS_DESC): HRESULT; stdcall;
        function BeginScene(pSurface: IDirect3DSurface9; pViewport: PD3DVIEWPORT9): HRESULT; stdcall;
        function EndScene(MipFilter: DWORD): HRESULT; stdcall;
        function OnLostDevice(): HRESULT; stdcall;
        function OnResetDevice(): HRESULT; stdcall;
    end;

    {$ELSE}
    ID3DXRenderToSurface = interface(IUnknown)
        ['{0D014791-8863-4C2C-A1C0-02F3E0C0B653}']
        // ID3DXRenderToSurface
        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;
        function GetDesc(pDesc: PD3DXRTS_DESC): HRESULT; stdcall;
        function BeginScene(pSurface: IDirect3DSurface9; pViewport: PD3DVIEWPORT9): HRESULT; stdcall;
        function EndScene(MipFilter: DWORD): HRESULT; stdcall;
        function OnLostDevice(): HRESULT; stdcall;
        function OnResetDevice(): HRESULT; stdcall;
    end;
    {$ENDIF}



    ///////////////////////////////////////////////////////////////////////////
    // ID3DXRenderToEnvMap:
    // --------------------
    // This object abstracts rendering to environment maps.  These surfaces
    // do not necessarily need to be render targets.  If they are not, a
    // compatible render target is used, and the result copied into the
    // environment map at end scene.

    // BeginCube, BeginSphere, BeginHemisphere, BeginParabolic -
    //    This function initiates the rendering of the environment map.  As
    //    parameters, you pass the textures in which will get filled in with
    //    the resulting environment map.

    // Face -
    //    Call this function to initiate the drawing of each face.  For each
    //    environment map, you will call this six times.. once for each face
    //    in D3DCUBEMAP_FACES.

    // End -
    //    This will restore all render targets, and if needed compose all the
    //    rendered faces into the environment map surfaces.

    // OnLostDevice, OnResetDevice -
    //    Call OnLostDevice() on this object before calling Reset() on the
    //    device, so that this object can release any stateblocks and video
    //    memory resources.  After Reset(), the call OnResetDevice().
    ///////////////////////////////////////////////////////////////////////////

    _D3DXRTE_DESC = record
        Size: UINT;
        MipLevels: UINT;
        Format: TD3DFORMAT;
        DepthStencil: boolean;
        DepthStencilFormat: TD3DFORMAT;
    end;
    TD3DXRTE_DESC = _D3DXRTE_DESC;
    PD3DXRTE_DESC = ^TD3DXRTE_DESC;


    ID3DXRenderToEnvMap = interface(IUnknown)
        ['{313F1B4B-C7B0-4fa2-9D9D-8D380B64385E}']
        // ID3DXRenderToEnvMap
        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;

        function GetDesc(pDesc: PD3DXRTE_DESC): HRESULT; stdcall;

        function BeginCube(pCubeTex: IDirect3DCubeTexture9): HRESULT; stdcall;

        function BeginSphere(pTex: IDirect3DTexture9): HRESULT; stdcall;

        function BeginHemisphere(pTexZPos: IDirect3DTexture9; pTexZNeg: IDirect3DTexture9): HRESULT; stdcall;

        function BeginParabolic(pTexZPos: IDirect3DTexture9; pTexZNeg: IDirect3DTexture9): HRESULT; stdcall;

        function Face(Face: TD3DCUBEMAP_FACES; MipFilter: DWORD): HRESULT; stdcall;

        function _End(MipFilter: DWORD): HRESULT; stdcall;

        function OnLostDevice(): HRESULT; stdcall;

        function OnResetDevice(): HRESULT; stdcall;

    end;


    {$IFDEF USESDK43}
    {$ELSE}
    ID3DXRenderToEnvMap = interface(IUnknown)
        ['{1561135E-BC78-495B-8586-94EA537BD557}']
        // ID3DXRenderToEnvMap
        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;
        function GetDesc(pDesc: PD3DXRTE_DESC): HRESULT; stdcall;
        function BeginCube(pCubeTex: IDirect3DCubeTexture9): HRESULT; stdcall;
        function BeginSphere(pTex: IDirect3DTexture9): HRESULT; stdcall;
        function BeginHemisphere(pTexZPos: IDirect3DTexture9; pTexZNeg: IDirect3DTexture9): HRESULT; stdcall;
        function BeginParabolic(pTexZPos: IDirect3DTexture9; pTexZNeg: IDirect3DTexture9): HRESULT; stdcall;
        function Face(Face: TD3DCUBEMAP_FACES; MipFilter: DWORD): HRESULT; stdcall;
        function _End(MipFilter: DWORD): HRESULT; stdcall;
        function OnLostDevice(): HRESULT; stdcall;
        function OnResetDevice(): HRESULT; stdcall;
    end;
    {$ENDIF}


    ///////////////////////////////////////////////////////////////////////////
    // ID3DXLine:
    // ------------
    // This object intends to provide an easy way to draw lines using D3D.
    // Begin -
    //    Prepares device for drawing lines
    // Draw -
    //    Draws a line strip in screen-space.
    //    Input is in the form of a array defining points on the line strip. of D3DXVECTOR2
    // DrawTransform -
    //    Draws a line in screen-space with a specified input transformation matrix.
    // End -
    //     Restores device state to how it was when Begin was called.
    // SetPattern -
    //     Applies a stipple pattern to the line.  Input is one 32-bit
    //     DWORD which describes the stipple pattern. 1 is opaque, 0 is
    //     transparent.
    // SetPatternScale -
    //     Stretches the stipple pattern in the u direction.  Input is one
    //     floating-point value.  0.0f is no scaling, whereas 1.0f doubles
    //     the length of the stipple pattern.
    // SetWidth -
    //     Specifies the thickness of the line in the v direction.  Input is
    //     one floating-point value.
    // SetAntialias -
    //     Toggles line antialiasing.  Input is a BOOL.
    //     TRUE  = Antialiasing on.
    //     FALSE = Antialiasing off.
    // SetGLLines -
    //     Toggles non-antialiased OpenGL line emulation.  Input is a BOOL.
    //     TRUE  = OpenGL line emulation on.
    //     FALSE = OpenGL line emulation off.
    // OpenGL line:     Regular line:
    //   *\                *\
    //   | \              /  \
    //   |  \            *\   \
    //   *\  \             \   \
    //     \  \             \   \
    //      \  *             \   *
    //       \ |              \ /
    //        \|               *
    //         *
    // OnLostDevice, OnResetDevice -
    //    Call OnLostDevice() on this object before calling Reset() on the
    //    device, so that this object can release any stateblocks and video
    //    memory resources.  After Reset(), the call OnResetDevice().
    ///////////////////////////////////////////////////////////////////////////


{$IFDEF USESDK43}

    ID3DXLine = interface(IUnknown)
        ['{D379BA7F-9042-4ac4-9F5E-58192A4C6BD8}']
        // ID3DXLine
        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;

        function _Begin(): HRESULT; stdcall;

        function Draw(pVertexList: PD3DXVECTOR2; dwVertexListCount: DWORD; Color: TD3DCOLOR): HRESULT; stdcall;

        function DrawTransform(pVertexList: PD3DXVECTOR3; dwVertexListCount: DWORD; pTransform: PD3DXMATRIX; Color: TD3DCOLOR): HRESULT; stdcall;

        function SetPattern(dwPattern: DWORD): HRESULT; stdcall;

        function GetPattern(): DWORD; stdcall;

        function SetPatternScale(fPatternScale: single): HRESULT; stdcall;

        function GetPatternScale(): single; stdcall;

        function SetWidth(fWidth: single): HRESULT; stdcall;

        function GetWidth(): single; stdcall;

        function SetAntialias(bAntialias: boolean): HRESULT; stdcall;

        function GetAntialias(): boolean; stdcall;

        function SetGLLines(bGLLines: boolean): HRESULT; stdcall;

        function GetGLLines(): boolean; stdcall;

        function _End(): HRESULT; stdcall;

        function OnLostDevice(): HRESULT; stdcall;

        function OnResetDevice(): HRESULT; stdcall;

    end;



{$ELSE}





    ID3DXLine = interface(IUnknown)
        ['{72CE4D70-CC40-4143-A896-32E50AD2EF35}']
        // ID3DXLine
        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;

        function _Begin(): HRESULT; stdcall;

        function Draw(pVertexList: PD3DXVECTOR2; dwVertexListCount: DWORD; Color: TD3DCOLOR): HRESULT; stdcall;

        function DrawTransform(pVertexList: PD3DXVECTOR3; dwVertexListCount: DWORD; pTransform: PD3DXMATRIX; Color: TD3DCOLOR): HRESULT; stdcall;

        function SetPattern(dwPattern: DWORD): HRESULT; stdcall;

        function GetPattern(): DWORD; stdcall;

        function SetPatternScale(fPatternScale: single): HRESULT; stdcall;

        function GetPatternScale(): single; stdcall;

        function SetWidth(fWidth: single): HRESULT; stdcall;

        function GetWidth(): single; stdcall;

        function SetAntialias(bAntialias: boolean): HRESULT; stdcall;

        function GetAntialias(): boolean; stdcall;

        function SetGLLines(bGLLines: boolean): HRESULT; stdcall;

        function GetGLLines(): boolean; stdcall;

        function _End(): HRESULT; stdcall;

        function OnLostDevice(): HRESULT; stdcall;

        function OnResetDevice(): HRESULT; stdcall;

    end;
{$ENDIF}

function D3DXCheckVersion(D3DSdkVersion: UINT; D3DXSdkVersion: UINT): longbool; stdcall; external D3DX9_DLL;

///////////////////////////////////////////////////////////////////////////
// D3DXGetDriverLevel:
//    Returns driver version information:

//    700 - DX7 level driver
//    800 - DX8 level driver
//    900 - DX9 level driver
///////////////////////////////////////////////////////////////////////////
function D3DXGetDriverLevel(out pDevice: IDirect3DDevice9): UINT; stdcall; external D3DX9_DLL;


function D3DXCreateFont(pDevice: IDirect3DDevice9; hFont: HFONT; out ppFont: ID3DXFont): HRESULT; stdcall; external D3DX9_DLL;
function D3DXCreateFontIndirect(pDevice: IDirect3DDevice9; pLogFont: PLOGFONT; out ppFont: ID3DXFont): HRESULT; stdcall; external D3DX9_DLL;
function D3DXCreateSprite(pDevice: IDirect3DDevice9; out ppSprite: ID3DXSprite): HRESULT; stdcall; external D3DX9_DLL;



function D3DXCreateRenderToSurface(pDevice: IDirect3DDevice9; Width: UINT; Height: UINT; Format: TD3DFORMAT; DepthStencil: boolean; DepthStencilFormat: TD3DFORMAT; out ppRenderToSurface: ID3DXRenderToSurface): HRESULT;
    stdcall; external D3DX9_DLL;




function D3DXCreateRenderToEnvMap(pDevice: IDirect3DDevice9; Size: UINT; MipLevels: UINT; Format: TD3DFORMAT; DepthStencil: boolean; DepthStencilFormat: TD3DFORMAT; out ppRenderToEnvMap: ID3DXRenderToEnvMap): HRESULT; stdcall; external D3DX9_DLL;



function D3DXCreateLine(pDevice: IDirect3DDevice9; out ppLine: ID3DXLine): HRESULT; stdcall; external D3DX9_DLL;


{$IFDEF USESDK43 }
///////////////////////////////////////////////////////////////////////////
// D3DXDebugMute
//    Mutes D3DX and D3D debug spew (TRUE - mute, FALSE - not mute)

//  returns previous mute value

///////////////////////////////////////////////////////////////////////////

function D3DXDebugMute(Mute: boolean): boolean; stdcall; external D3DX9_DLL;

function D3DXCreateFontA(pDevice: IDirect3DDevice9; Height: int32; Width: UINT; Weight: UINT; MipLevels: UINT; Italic: boolean; CharSet: DWORD; OutputPrecision: DWORD; Quality: DWORD; PitchAndFamily: DWORD; pFaceName: LPCSTR;
    out ppFont: ID3DXFont): HRESULT; stdcall; external D3DX9_DLL;

function D3DXCreateFontW(pDevice: IDirect3DDevice9; Height: int32; Width: UINT; Weight: UINT; MipLevels: UINT; Italic: boolean; CharSet: DWORD; OutputPrecision: DWORD; Quality: DWORD; PitchAndFamily: DWORD; pFaceName: LPCWSTR;
    out ppFont: ID3DXFont): HRESULT; stdcall; external D3DX9_DLL;

function D3DXCreateFontIndirectA(pDevice: IDirect3DDevice9; pDesc: PD3DXFONT_DESCA; out ppFont: ID3DXFont): HRESULT; stdcall; external D3DX9_DLL;

function D3DXCreateFontIndirectW(pDevice: IDirect3DDevice9; pDesc: PD3DXFONT_DESCW; out ppFont: ID3DXFont): HRESULT; stdcall; external D3DX9_DLL;



{$ENDIF}



implementation

{$IFDEF USESDK43}


{ ID3DXFontHelper }

function ID3DXFontHelper.GetDesc(pDesc: PD3DXFONT_DESCW): HRESULT;
begin
    Result := GetDescW(pDesc);
end;



function ID3DXFontHelper.PreloadText(pString: LPCWSTR; Count: int32): HRESULT;
begin
    Result := PreloadTextW(pString, Count);
end;



function ID3DXFontHelper.GetDesc(pDesc: PD3DXFONT_DESCA): HRESULT;
begin
    Result := GetDescA(pDesc);
end;



function ID3DXFontHelper.PreloadText(pString: LPCSTR; Count: int32): HRESULT;
begin
    Result := PreloadTextA(pString, Count);
end;
{$ENDIF}

end.
