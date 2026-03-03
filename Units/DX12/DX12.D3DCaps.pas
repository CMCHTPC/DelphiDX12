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
   Content:    Direct3D capabilities include file

   This unit consists of the following header files
   File name: d3dcaps.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3DCaps;

{$mode ObjFPC}{$H+}

interface

uses
    Windows,Classes, SysUtils,
    DX12.D3DTypes;

    {$Z4}

const


    D3DTRANSFORMCAPS_CLIP = $00000001; (* Will clip whilst transforming *)



    D3DLIGHTINGMODEL_RGB = $00000001;
    D3DLIGHTINGMODEL_MONO = $00000002;

    D3DLIGHTCAPS_POINT = $00000001; (* Point lights supported *)
    D3DLIGHTCAPS_SPOT = $00000002; (* Spot lights supported *)
    D3DLIGHTCAPS_DIRECTIONAL = $00000004; (* Directional lights supported *)

    D3DLIGHTCAPS_PARALLELPOINT = $00000008; (* Parallel point lights supported *)


    D3DLIGHTCAPS_GLSPOT = $00000010; (* GL syle spot lights supported *)


    (* D3DPRIMCAPS dwMiscCaps *)

    D3DPMISCCAPS_MASKPLANES = $00000001;
    D3DPMISCCAPS_MASKZ = $00000002;
    D3DPMISCCAPS_LINEPATTERNREP = $00000004;
    D3DPMISCCAPS_CONFORMANT = $00000008;
    D3DPMISCCAPS_CULLNONE = $00000010;
    D3DPMISCCAPS_CULLCW = $00000020;
    D3DPMISCCAPS_CULLCCW = $00000040;

    (* D3DPRIMCAPS dwRasterCaps *)

    D3DPRASTERCAPS_DITHER = $00000001;
    D3DPRASTERCAPS_ROP2 = $00000002;
    D3DPRASTERCAPS_XOR = $00000004;
    D3DPRASTERCAPS_PAT = $00000008;
    D3DPRASTERCAPS_ZTEST = $00000010;
    D3DPRASTERCAPS_SUBPIXEL = $00000020;
    D3DPRASTERCAPS_SUBPIXELX = $00000040;
    D3DPRASTERCAPS_FOGVERTEX = $00000080;
    D3DPRASTERCAPS_FOGTABLE = $00000100;
    D3DPRASTERCAPS_STIPPLE = $00000200;

    D3DPRASTERCAPS_ANTIALIASSORTDEPENDENT = $00000400;
    D3DPRASTERCAPS_ANTIALIASSORTINDEPENDENT = $00000800;
    D3DPRASTERCAPS_ANTIALIASEDGES = $00001000;
    D3DPRASTERCAPS_MIPMAPLODBIAS = $00002000;
    D3DPRASTERCAPS_ZBIAS = $00004000;
    D3DPRASTERCAPS_ZBUFFERLESSHSR = $00008000;
    D3DPRASTERCAPS_FOGRANGE = $00010000;
    D3DPRASTERCAPS_ANISOTROPY = $00020000;


    D3DPRASTERCAPS_WBUFFER = $00040000;
    D3DPRASTERCAPS_TRANSLUCENTSORTINDEPENDENT = $00080000;
    D3DPRASTERCAPS_WFOG = $00100000;
    D3DPRASTERCAPS_ZFOG = $00200000;


    (* D3DPRIMCAPS dwZCmpCaps, dwAlphaCmpCaps *)

    D3DPCMPCAPS_NEVER = $00000001;
    D3DPCMPCAPS_LESS = $00000002;
    D3DPCMPCAPS_EQUAL = $00000004;
    D3DPCMPCAPS_LESSEQUAL = $00000008;
    D3DPCMPCAPS_GREATER = $00000010;
    D3DPCMPCAPS_NOTEQUAL = $00000020;
    D3DPCMPCAPS_GREATEREQUAL = $00000040;
    D3DPCMPCAPS_ALWAYS = $00000080;

    (* D3DPRIMCAPS dwSourceBlendCaps, dwDestBlendCaps *)

    D3DPBLENDCAPS_ZERO = $00000001;
    D3DPBLENDCAPS_ONE = $00000002;
    D3DPBLENDCAPS_SRCCOLOR = $00000004;
    D3DPBLENDCAPS_INVSRCCOLOR = $00000008;
    D3DPBLENDCAPS_SRCALPHA = $00000010;
    D3DPBLENDCAPS_INVSRCALPHA = $00000020;
    D3DPBLENDCAPS_DESTALPHA = $00000040;
    D3DPBLENDCAPS_INVDESTALPHA = $00000080;
    D3DPBLENDCAPS_DESTCOLOR = $00000100;
    D3DPBLENDCAPS_INVDESTCOLOR = $00000200;
    D3DPBLENDCAPS_SRCALPHASAT = $00000400;
    D3DPBLENDCAPS_BOTHSRCALPHA = $00000800;
    D3DPBLENDCAPS_BOTHINVSRCALPHA = $00001000;

    (* D3DPRIMCAPS dwShadeCaps *)

    D3DPSHADECAPS_COLORFLATMONO = $00000001;
    D3DPSHADECAPS_COLORFLATRGB = $00000002;
    D3DPSHADECAPS_COLORGOURAUDMONO = $00000004;
    D3DPSHADECAPS_COLORGOURAUDRGB = $00000008;
    D3DPSHADECAPS_COLORPHONGMONO = $00000010;
    D3DPSHADECAPS_COLORPHONGRGB = $00000020;

    D3DPSHADECAPS_SPECULARFLATMONO = $00000040;
    D3DPSHADECAPS_SPECULARFLATRGB = $00000080;
    D3DPSHADECAPS_SPECULARGOURAUDMONO = $00000100;
    D3DPSHADECAPS_SPECULARGOURAUDRGB = $00000200;
    D3DPSHADECAPS_SPECULARPHONGMONO = $00000400;
    D3DPSHADECAPS_SPECULARPHONGRGB = $00000800;

    D3DPSHADECAPS_ALPHAFLATBLEND = $00001000;
    D3DPSHADECAPS_ALPHAFLATSTIPPLED = $00002000;
    D3DPSHADECAPS_ALPHAGOURAUDBLEND = $00004000;
    D3DPSHADECAPS_ALPHAGOURAUDSTIPPLED = $00008000;
    D3DPSHADECAPS_ALPHAPHONGBLEND = $00010000;
    D3DPSHADECAPS_ALPHAPHONGSTIPPLED = $00020000;

    D3DPSHADECAPS_FOGFLAT = $00040000;
    D3DPSHADECAPS_FOGGOURAUD = $00080000;
    D3DPSHADECAPS_FOGPHONG = $00100000;

    (* D3DPRIMCAPS dwTextureCaps *)
(*
 * Perspective-correct texturing is supported
 *)

    D3DPTEXTURECAPS_PERSPECTIVE = $00000001;

(*
 * Power-of-2 texture dimensions are required
 *)
    D3DPTEXTURECAPS_POW2 = $00000002;

(*
 * Alpha in texture pixels is supported
 *)
    D3DPTEXTURECAPS_ALPHA = $00000004;

(*
 * Color-keyed textures are supported
 *)
    D3DPTEXTURECAPS_TRANSPARENCY = $00000008;

(*
 * obsolete, see D3DPTADDRESSCAPS_BORDER
 *)
    D3DPTEXTURECAPS_BORDER = $00000010;

(*
 * Only square textures are supported
 *)
    D3DPTEXTURECAPS_SQUAREONLY = $00000020;


(*
 * Texture indices are not scaled by the texture size prior
 * to interpolation.
 *)
    D3DPTEXTURECAPS_TEXREPEATNOTSCALEDBYSIZE = $00000040;

(*
 * Device can draw alpha from texture palettes
 *)
    D3DPTEXTURECAPS_ALPHAPALETTE = $00000080;

(*
 * Device can use non-POW2 textures if:
 *  1) D3DTEXTURE_ADDRESS is set to CLAMP for this texture's stage
 *  2) D3DRS_WRAP(N) is zero for this texture's coordinates
 *  3) mip mapping is not enabled (use magnification filter only)
 *)
    D3DPTEXTURECAPS_NONPOW2CONDITIONAL = $00000100;


    // 0x00000200L unused
(*
 * Device can divide transformed texture coordinates by the
 * COUNTth texture coordinate (can do D3DTTFF_PROJECTED)
 *)

    D3DPTEXTURECAPS_PROJECTED = $00000400;

(*
 * Device can do cubemap textures
 *)
    D3DPTEXTURECAPS_CUBEMAP = $00000800;

    D3DPTEXTURECAPS_COLORKEYBLEND = $00001000;


    (* D3DPRIMCAPS dwTextureFilterCaps *)

    D3DPTFILTERCAPS_NEAREST = $00000001;
    D3DPTFILTERCAPS_LINEAR = $00000002;
    D3DPTFILTERCAPS_MIPNEAREST = $00000004;
    D3DPTFILTERCAPS_MIPLINEAR = $00000008;
    D3DPTFILTERCAPS_LINEARMIPNEAREST = $00000010;
    D3DPTFILTERCAPS_LINEARMIPLINEAR = $00000020;


    (* Device3 Min Filter *)
    D3DPTFILTERCAPS_MINFPOINT = $00000100;
    D3DPTFILTERCAPS_MINFLINEAR = $00000200;
    D3DPTFILTERCAPS_MINFANISOTROPIC = $00000400;

    (* Device3 Mip Filter *)
    D3DPTFILTERCAPS_MIPFPOINT = $00010000;
    D3DPTFILTERCAPS_MIPFLINEAR = $00020000;

    (* Device3 Mag Filter *)
    D3DPTFILTERCAPS_MAGFPOINT = $01000000;
    D3DPTFILTERCAPS_MAGFLINEAR = $02000000;
    D3DPTFILTERCAPS_MAGFANISOTROPIC = $04000000;
    D3DPTFILTERCAPS_MAGFAFLATCUBIC = $08000000;
    D3DPTFILTERCAPS_MAGFGAUSSIANCUBIC = $10000000;


    (* D3DPRIMCAPS dwTextureBlendCaps *)

    D3DPTBLENDCAPS_DECAL = $00000001;
    D3DPTBLENDCAPS_MODULATE = $00000002;
    D3DPTBLENDCAPS_DECALALPHA = $00000004;
    D3DPTBLENDCAPS_MODULATEALPHA = $00000008;
    D3DPTBLENDCAPS_DECALMASK = $00000010;
    D3DPTBLENDCAPS_MODULATEMASK = $00000020;
    D3DPTBLENDCAPS_COPY = $00000040;

    D3DPTBLENDCAPS_ADD = $00000080;


    (* D3DPRIMCAPS dwTextureAddressCaps *)
    D3DPTADDRESSCAPS_WRAP = $00000001;
    D3DPTADDRESSCAPS_MIRROR = $00000002;
    D3DPTADDRESSCAPS_CLAMP = $00000004;

    D3DPTADDRESSCAPS_BORDER = $00000008;
    D3DPTADDRESSCAPS_INDEPENDENTUV = $00000010;




    (* D3DDEVICEDESC dwStencilCaps *)

    D3DSTENCILCAPS_KEEP = $00000001;
    D3DSTENCILCAPS_ZERO = $00000002;
    D3DSTENCILCAPS_REPLACE = $00000004;
    D3DSTENCILCAPS_INCRSAT = $00000008;
    D3DSTENCILCAPS_DECRSAT = $00000010;
    D3DSTENCILCAPS_INVERT = $00000020;
    D3DSTENCILCAPS_INCR = $00000040;
    D3DSTENCILCAPS_DECR = $00000080;

    (* D3DDEVICEDESC dwTextureOpCaps *)

    D3DTEXOPCAPS_DISABLE = $00000001;
    D3DTEXOPCAPS_SELECTARG1 = $00000002;
    D3DTEXOPCAPS_SELECTARG2 = $00000004;
    D3DTEXOPCAPS_MODULATE = $00000008;
    D3DTEXOPCAPS_MODULATE2X = $00000010;
    D3DTEXOPCAPS_MODULATE4X = $00000020;
    D3DTEXOPCAPS_ADD = $00000040;
    D3DTEXOPCAPS_ADDSIGNED = $00000080;
    D3DTEXOPCAPS_ADDSIGNED2X = $00000100;
    D3DTEXOPCAPS_SUBTRACT = $00000200;
    D3DTEXOPCAPS_ADDSMOOTH = $00000400;
    D3DTEXOPCAPS_BLENDDIFFUSEALPHA = $00000800;
    D3DTEXOPCAPS_BLENDTEXTUREALPHA = $00001000;
    D3DTEXOPCAPS_BLENDFACTORALPHA = $00002000;
    D3DTEXOPCAPS_BLENDTEXTUREALPHAPM = $00004000;
    D3DTEXOPCAPS_BLENDCURRENTALPHA = $00008000;
    D3DTEXOPCAPS_PREMODULATE = $00010000;
    D3DTEXOPCAPS_MODULATEALPHA_ADDCOLOR = $00020000;
    D3DTEXOPCAPS_MODULATECOLOR_ADDALPHA = $00040000;
    D3DTEXOPCAPS_MODULATEINVALPHA_ADDCOLOR = $00080000;
    D3DTEXOPCAPS_MODULATEINVCOLOR_ADDALPHA = $00100000;
    D3DTEXOPCAPS_BUMPENVMAP = $00200000;
    D3DTEXOPCAPS_BUMPENVMAPLUMINANCE = $00400000;
    D3DTEXOPCAPS_DOTPRODUCT3 = $00800000;

    (* D3DDEVICEDESC dwFVFCaps flags *)

    D3DFVFCAPS_TEXCOORDCOUNTMASK = $0000ffff; (* mask for texture coordinate count field *)
    D3DFVFCAPS_DONOTSTRIPELEMENTS = $00080000; (* Device prefers that vertex elements not be stripped *)

    (* D3DDEVICEDESC dwFlags indicating valid fields *)

    D3DDD_COLORMODEL = $00000001; (* dcmColorModel is valid *)
    D3DDD_DEVCAPS = $00000002; (* dwDevCaps is valid *)
    D3DDD_TRANSFORMCAPS = $00000004; (* dtcTransformCaps is valid *)
    D3DDD_LIGHTINGCAPS = $00000008; (* dlcLightingCaps is valid *)
    D3DDD_BCLIPPING = $00000010; (* bClipping is valid *)
    D3DDD_LINECAPS = $00000020; (* dpcLineCaps is valid *)
    D3DDD_TRICAPS = $00000040; (* dpcTriCaps is valid *)
    D3DDD_DEVICERENDERBITDEPTH = $00000080; (* dwDeviceRenderBitDepth is valid *)
    D3DDD_DEVICEZBUFFERBITDEPTH = $00000100; (* dwDeviceZBufferBitDepth is valid *)
    D3DDD_MAXBUFFERSIZE = $00000200; (* dwMaxBufferSize is valid *)
    D3DDD_MAXVERTEXCOUNT = $00000400; (* dwMaxVertexCount is valid *)

    (* D3DDEVICEDESC dwDevCaps flags *)

    D3DDEVCAPS_FLOATTLVERTEX = $00000001; (* Device accepts floating point *)
    (* for post-transform vertex data *)
    D3DDEVCAPS_SORTINCREASINGZ = $00000002; (* Device needs data sorted for increasing Z *)
    D3DDEVCAPS_SORTDECREASINGZ = $00000004; (* Device needs data sorted for decreasing Z *)
    D3DDEVCAPS_SORTEXACT = $00000008; (* Device needs data sorted exactly *)

    D3DDEVCAPS_EXECUTESYSTEMMEMORY = $00000010; (* Device can use execute buffers from system memory *)
    D3DDEVCAPS_EXECUTEVIDEOMEMORY = $00000020; (* Device can use execute buffers from video memory *)
    D3DDEVCAPS_TLVERTEXSYSTEMMEMORY = $00000040; (* Device can use TL buffers from system memory *)
    D3DDEVCAPS_TLVERTEXVIDEOMEMORY = $00000080; (* Device can use TL buffers from video memory *)
    D3DDEVCAPS_TEXTURESYSTEMMEMORY = $00000100; (* Device can texture from system memory *)
    D3DDEVCAPS_TEXTUREVIDEOMEMORY = $00000200; (* Device can texture from device memory *)

    D3DDEVCAPS_DRAWPRIMTLVERTEX = $00000400; (* Device can draw TLVERTEX primitives *)
    D3DDEVCAPS_CANRENDERAFTERFLIP = $00000800; (* Device can render without waiting for flip to complete *)
    D3DDEVCAPS_TEXTURENONLOCALVIDMEM = $00001000; (* Device can texture from nonlocal video memory *)

    D3DDEVCAPS_DRAWPRIMITIVES2 = $00002000; (* Device can support DrawPrimitives2 *)
    D3DDEVCAPS_SEPARATETEXTUREMEMORIES = $00004000; (* Device is texturing from separate memory pools *)
    D3DDEVCAPS_DRAWPRIMITIVES2EX = $00008000; (* Device can support Extended DrawPrimitives2 i.e. DX7 compliant driver*)

    D3DDEVCAPS_HWTRANSFORMANDLIGHT = $00010000; (* Device can support transformation and lighting in hardware and DRAWPRIMITIVES2EX must be also *)
    D3DDEVCAPS_CANBLTSYSTONONLOCAL = $00020000; (* Device supports a Tex Blt from system memory to non-local vidmem *)
    D3DDEVCAPS_HWRASTERIZATION = $00080000; (* Device has HW acceleration for rasterization *)

(*
 * These are the flags in the D3DDEVICEDESC7.dwVertexProcessingCaps field
 *)
    (* device can do texgen *)

    D3DVTXPCAPS_TEXGEN = $00000001;
    (* device can do IDirect3DDevice7 colormaterialsource ops *)
    D3DVTXPCAPS_MATERIALSOURCE7 = $00000002;
    (* device can do vertex fog *)
    D3DVTXPCAPS_VERTEXFOG = $00000004;
    (* device can do directional lights *)
    D3DVTXPCAPS_DIRECTIONALLIGHTS = $00000008;
    (* device can do positional lights (includes point and spot) *)
    D3DVTXPCAPS_POSITIONALLIGHTS = $00000010;
    (* device can do local viewer *)
    D3DVTXPCAPS_LOCALVIEWER = $00000020;



    D3DFDS_COLORMODEL = $00000001; (* Match color model *)
    D3DFDS_GUID = $00000002; (* Match guid *)
    D3DFDS_HARDWARE = $00000004; (* Match hardware/software *)
    D3DFDS_TRIANGLES = $00000008; (* Match in triCaps *)
    D3DFDS_LINES = $00000010; (* Match in lineCaps  *)
    D3DFDS_MISCCAPS = $00000020; (* Match primCaps.dwMiscCaps *)
    D3DFDS_RASTERCAPS = $00000040; (* Match primCaps.dwRasterCaps *)
    D3DFDS_ZCMPCAPS = $00000080; (* Match primCaps.dwZCmpCaps *)
    D3DFDS_ALPHACMPCAPS = $00000100; (* Match primCaps.dwAlphaCmpCaps *)
    D3DFDS_SRCBLENDCAPS = $00000200; (* Match primCaps.dwSourceBlendCaps *)
    D3DFDS_DSTBLENDCAPS = $00000400; (* Match primCaps.dwDestBlendCaps *)
    D3DFDS_SHADECAPS = $00000800; (* Match primCaps.dwShadeCaps *)
    D3DFDS_TEXTURECAPS = $00001000; (* Match primCaps.dwTextureCaps *)
    D3DFDS_TEXTUREFILTERCAPS = $00002000; (* Match primCaps.dwTextureFilterCaps *)
    D3DFDS_TEXTUREBLENDCAPS = $00004000; (* Match primCaps.dwTextureBlendCaps *)
    D3DFDS_TEXTUREADDRESSCAPS = $00008000; (* Match primCaps.dwTextureBlendCaps *)

    (* D3DEXECUTEBUFFER dwFlags indicating valid fields *)

    D3DDEB_BUFSIZE = $00000001; (* buffer size valid *)
    D3DDEB_CAPS = $00000002; (* caps valid *)
    D3DDEB_LPDATA = $00000004; (* lpData valid *)

    (* D3DEXECUTEBUFFER dwCaps *)

    D3DDEBCAPS_SYSTEMMEMORY = $00000001; (* buffer in system memory *)
    D3DDEBCAPS_VIDEOMEMORY = $00000002; (* buffer in device memory *)
    D3DDEBCAPS_MEM = (D3DDEBCAPS_SYSTEMMEMORY or D3DDEBCAPS_VIDEOMEMORY);




type
 //   {$PACKRECORDS 4}

    (* Description of capabilities of transform *)

    T_D3DTRANSFORMCAPS = record
        dwSize: DWORD;
        dwCaps: DWORD;
    end;
    P_D3DTRANSFORMCAPS = ^T_D3DTRANSFORMCAPS;

    TD3DTRANSFORMCAPS = T_D3DTRANSFORMCAPS;
    LPD3DTRANSFORMCAPS = ^T_D3DTRANSFORMCAPS;


    (* Description of capabilities of lighting *)

    T_D3DLIGHTINGCAPS = record
        dwSize: DWORD;
        dwCaps: DWORD; (* Lighting caps *)
        dwLightingModel: DWORD; (* Lighting model - RGB or mono *)
        dwNumLights: DWORD; (* Number of lights that can be handled *)
    end;
    P_D3DLIGHTINGCAPS = ^T_D3DLIGHTINGCAPS;

    TD3DLIGHTINGCAPS = T_D3DLIGHTINGCAPS;
    LPD3DLIGHTINGCAPS = ^T_D3DLIGHTINGCAPS;


    (* Description of capabilities for each primitive type *)

    T_D3DPrimCaps = record
        dwSize: DWORD;
        dwMiscCaps: DWORD; (* Capability flags *)
        dwRasterCaps: DWORD;
        dwZCmpCaps: DWORD;
        dwSrcBlendCaps: DWORD;
        dwDestBlendCaps: DWORD;
        dwAlphaCmpCaps: DWORD;
        dwShadeCaps: DWORD;
        dwTextureCaps: DWORD;
        dwTextureFilterCaps: DWORD;
        dwTextureBlendCaps: DWORD;
        dwTextureAddressCaps: DWORD;
        dwStippleWidth: DWORD; (* maximum width and height of *)
        dwStippleHeight: DWORD; (* of supported stipple (up to 32x32) *)
    end;
    P_D3DPrimCaps = ^T_D3DPrimCaps;

    TD3DPRIMCAPS = T_D3DPrimCaps;
    LPD3DPRIMCAPS = ^T_D3DPrimCaps;

(*
 * Description for a device.
 * This is used to describe a device that is to be created or to query
 * the current device.
 *)
    T_D3DDeviceDesc = record
        dwSize: DWORD; (* Size of D3DDEVICEDESC structure *)
        dwFlags: DWORD; (* Indicates which fields have valid data *)
        dcmColorModel: TD3DCOLORMODEL; (* Color model of device *)
        dwDevCaps: DWORD; (* Capabilities of device *)
        dtcTransformCaps: TD3DTRANSFORMCAPS; (* Capabilities of transform *)
        bClipping: boolean; (* Device can do 3D clipping *)
        dlcLightingCaps: TD3DLIGHTINGCAPS; (* Capabilities of lighting *)
        dpcLineCaps: TD3DPRIMCAPS;
        dpcTriCaps: TD3DPRIMCAPS;
        dwDeviceRenderBitDepth: DWORD; (* One of DDBB_8, 16, etc.. *)
        dwDeviceZBufferBitDepth: DWORD; (* One of DDBD_16, 32, etc.. *)
        dwMaxBufferSize: DWORD; (* Maximum execute buffer size *)
        dwMaxVertexCount: DWORD; (* Maximum vertex count *)
        // *** New fields for DX5 *** //
        // Width and height caps are 0 for legacy HALs.
        dwMinTextureWidthdwMinTextureHeight: DWORD;
        dwMaxTextureWidthdwMaxTextureHeight: DWORD;
        dwMinStippleWidthdwMaxStippleWidth: DWORD;
        dwMinStippleHeightdwMaxStippleHeight: DWORD;
        // New fields for DX6
        dwMaxTextureRepeat: DWORD;
        dwMaxTextureAspectRatio: DWORD;
        dwMaxAnisotropy: DWORD;
        // Guard band that the rasterizer can accommodate
        // Screen-space vertices inside this space but outside the viewport
        // will get clipped properly.
        dvGuardBandLeft: TD3DVALUE;
        dvGuardBandTop: TD3DVALUE;
        dvGuardBandRight: TD3DVALUE;
        dvGuardBandBottom: TD3DVALUE;
        dvExtentsAdjust: TD3DVALUE;
        dwStencilCaps: DWORD;
        dwFVFCaps: DWORD;
        dwTextureOpCaps: DWORD;
        wMaxTextureBlendStages: WORD;
        wMaxSimultaneousTextures: WORD;
    end;
    P_D3DDeviceDesc = ^T_D3DDeviceDesc;

    TD3DDEVICEDESC = T_D3DDeviceDesc;
    LPD3DDEVICEDESC = ^T_D3DDeviceDesc;




    T_D3DDeviceDesc7 = record
        dwDevCaps: DWORD; (* Capabilities of device *)
        dpcLineCaps: TD3DPRIMCAPS;
        dpcTriCaps: TD3DPRIMCAPS;
        dwDeviceRenderBitDepth: DWORD; (* One of DDBB_8, 16, etc.. *)
        dwDeviceZBufferBitDepth: DWORD; (* One of DDBD_16, 32, etc.. *)
        dwMinTextureWidthdwMinTextureHeight: DWORD;
        dwMaxTextureWidthdwMaxTextureHeight: DWORD;
        dwMaxTextureRepeat: DWORD;
        dwMaxTextureAspectRatio: DWORD;
        dwMaxAnisotropy: DWORD;
        dvGuardBandLeft: TD3DVALUE;
        dvGuardBandTop: TD3DVALUE;
        dvGuardBandRight: TD3DVALUE;
        dvGuardBandBottom: TD3DVALUE;
        dvExtentsAdjust: TD3DVALUE;
        dwStencilCaps: DWORD;
        dwFVFCaps: DWORD;
        dwTextureOpCaps: DWORD;
        wMaxTextureBlendStages: WORD;
        wMaxSimultaneousTextures: WORD;
        dwMaxActiveLights: DWORD;
        dvMaxVertexW: TD3DVALUE;
        deviceGUID: TGUID;
        wMaxUserClipPlanes: WORD;
        wMaxVertexBlendMatrices: WORD;
        dwVertexProcessingCaps: DWORD;
        dwReserved1: DWORD;
        dwReserved2: DWORD;
        dwReserved3: DWORD;
        dwReserved4: DWORD;
    end;
    P_D3DDeviceDesc7 = ^T_D3DDeviceDesc7;

    TD3DDEVICEDESC7 = T_D3DDeviceDesc7;
    LPD3DDEVICEDESC7 = ^T_D3DDeviceDesc7;


(*
 * FindDevice arguments
 *)
    T_D3DFINDDEVICESEARCH = record
        dwSize: DWORD;
        dwFlags: DWORD;
        bHardware: boolean;
        dcmColorModel: TD3DCOLORMODEL;
        guid: TGUID;
        dwCaps: DWORD;
        dpcPrimCaps: TD3DPRIMCAPS;
    end;
    P_D3DFINDDEVICESEARCH = ^T_D3DFINDDEVICESEARCH;

    TD3DFINDDEVICESEARCH = T_D3DFINDDEVICESEARCH;
    LPD3DFINDDEVICESEARCH = ^T_D3DFINDDEVICESEARCH;

    T_D3DFINDDEVICERESULT = record
        dwSize: DWORD;
        guid: TGUID; (* guid which matched *)
        ddHwDesc: TD3DDEVICEDESC; (* hardware D3DDEVICEDESC *)
        ddSwDesc: TD3DDEVICEDESC; (* software D3DDEVICEDESC *)
    end;
    P_D3DFINDDEVICERESULT = ^T_D3DFINDDEVICERESULT;

    TD3DFINDDEVICERESULT = T_D3DFINDDEVICERESULT;
    LPD3DFINDDEVICERESULT = ^T_D3DFINDDEVICERESULT;

(*
 * Description of execute buffer.
 *)
    T_D3DExecuteBufferDesc = record
        dwSize: DWORD; (* size of this structure *)
        dwFlags: DWORD; (* flags indicating which fields are valid *)
        dwCaps: DWORD; (* capabilities of execute buffer *)
        dwBufferSize: DWORD; (* size of execute buffer data *)
        lpData: LPVOID; (* pointer to actual data *)
    end;
    P_D3DExecuteBufferDesc = ^T_D3DExecuteBufferDesc;

    TD3DEXECUTEBUFFERDESC = T_D3DExecuteBufferDesc;
    LPD3DEXECUTEBUFFERDESC = ^T_D3DExecuteBufferDesc;


    T_D3DDEVINFO_TEXTUREMANAGER = record
        bThrashing: boolean; (* indicates if thrashing *)
        dwApproxBytesDownloaded: DWORD; (* Approximate number of bytes downloaded by texture manager *)
        dwNumEvicts: DWORD; (* number of textures evicted *)
        dwNumVidCreates: DWORD; (* number of textures created in video memory *)
        dwNumTexturesUsed: DWORD; (* number of textures used *)
        dwNumUsedTexInVid: DWORD; (* number of used textures present in video memory *)
        dwWorkingSet: DWORD; (* number of textures in video memory *)
        dwWorkingSetBytes: DWORD; (* number of bytes in video memory *)
        dwTotalManaged: DWORD; (* total number of managed textures *)
        dwTotalBytes: DWORD; (* total number of bytes of managed textures *)
        dwLastPri: DWORD; (* priority of last texture evicted *)
    end;
    P_D3DDEVINFO_TEXTUREMANAGER = ^T_D3DDEVINFO_TEXTUREMANAGER;

    TD3DDEVINFO_TEXTUREMANAGER = T_D3DDEVINFO_TEXTUREMANAGER;
    LPD3DDEVINFO_TEXTUREMANAGER = ^T_D3DDEVINFO_TEXTUREMANAGER;

    T_D3DDEVINFO_TEXTURING = record
        dwNumLoads: DWORD; (* counts Load() API calls *)
        dwApproxBytesLoaded: DWORD; (* Approximate number bytes loaded via Load() *)
        dwNumPreLoads: DWORD; (* counts PreLoad() API calls *)
        dwNumSet: DWORD; (* counts SetTexture() API calls *)
        dwNumCreates: DWORD; (* counts texture creates *)
        dwNumDestroys: DWORD; (* counts texture destroys *)
        dwNumSetPriorities: DWORD; (* counts SetPriority() API calls *)
        dwNumSetLODs: DWORD; (* counts SetLOD() API calls *)
        dwNumLocks: DWORD; (* counts number of texture locks *)
        dwNumGetDCs: DWORD; (* counts number of GetDCs to textures *)
    end;
    P_D3DDEVINFO_TEXTURING = ^T_D3DDEVINFO_TEXTURING;

    TD3DDEVINFO_TEXTURING = T_D3DDEVINFO_TEXTURING;
    LPD3DDEVINFO_TEXTURING = ^T_D3DDEVINFO_TEXTURING;



    LPD3DENUMDEVICESCALLBACK = function(lpGuid: PGUID; lpDeviceDescription: LPSTR; lpDeviceName: LPSTR; Nameless4: LPD3DDEVICEDESC; Nameless5: LPD3DDEVICEDESC; Nameless6: LPVOID): HRESULT; stdcall;

    LPD3DENUMDEVICESCALLBACK7 = function(lpDeviceDescription: LPSTR; lpDeviceName: LPSTR; Nameless3: LPD3DDEVICEDESC7; Nameless4: LPVOID): HRESULT; stdcall;


    {$PACKRECORDS DEFAULT}

const
     D3DDEVICEDESCSIZE = (sizeof(TD3DDEVICEDESC));
 D3DDEVICEDESC7SIZE = (sizeof(TD3DDEVICEDESC7));
implementation

end.
