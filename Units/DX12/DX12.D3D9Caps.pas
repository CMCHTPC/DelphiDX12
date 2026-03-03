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
   File name: d3d9caps.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.D3D9Caps;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D9Types;

    {$Z4}

const
    DIRECT3D_VERSION      =   $0900;

    D3DVS20CAPS_PREDICATION = (1 shl 0);

    D3DVS20_MAX_DYNAMICFLOWCONTROLDEPTH = 24;
    D3DVS20_MIN_DYNAMICFLOWCONTROLDEPTH = 0;
    D3DVS20_MAX_NUMTEMPS = 32;
    D3DVS20_MIN_NUMTEMPS = 12;
    D3DVS20_MAX_STATICFLOWCONTROLDEPTH = 4;
    D3DVS20_MIN_STATICFLOWCONTROLDEPTH = 1;



    D3DPS20CAPS_ARBITRARYSWIZZLE = (1 shl 0);
    D3DPS20CAPS_GRADIENTINSTRUCTIONS = (1 shl 1);
    D3DPS20CAPS_PREDICATION = (1 shl 2);
    D3DPS20CAPS_NODEPENDENTREADLIMIT = (1 shl 3);
    D3DPS20CAPS_NOTEXINSTRUCTIONLIMIT = (1 shl 4);

    D3DPS20_MAX_DYNAMICFLOWCONTROLDEPTH = 24;
    D3DPS20_MIN_DYNAMICFLOWCONTROLDEPTH = 0;
    D3DPS20_MAX_NUMTEMPS = 32;
    D3DPS20_MIN_NUMTEMPS = 12;
    D3DPS20_MAX_STATICFLOWCONTROLDEPTH = 4;
    D3DPS20_MIN_STATICFLOWCONTROLDEPTH = 0;
    D3DPS20_MAX_NUMINSTRUCTIONSLOTS = 512;
    D3DPS20_MIN_NUMINSTRUCTIONSLOTS = 96;

    D3DMIN30SHADERINSTRUCTIONS = 512;
    D3DMAX30SHADERINSTRUCTIONS = 32768;

    (* D3D9Ex only -- *)



    D3DOVERLAYCAPS_FULLRANGERGB = $00000001;
    D3DOVERLAYCAPS_LIMITEDRANGERGB = $00000002;
    D3DOVERLAYCAPS_YCbCr_BT601 = $00000004;
    D3DOVERLAYCAPS_YCbCr_BT709 = $00000008;
    D3DOVERLAYCAPS_YCbCr_BT601_xvYCC = $00000010;
    D3DOVERLAYCAPS_YCbCr_BT709_xvYCC = $00000020;
    D3DOVERLAYCAPS_STRETCHX = $00000040;
    D3DOVERLAYCAPS_STRETCHY = $00000080;




    D3DCPCAPS_SOFTWARE = $00000001;
    D3DCPCAPS_HARDWARE = $00000002;
    D3DCPCAPS_PROTECTIONALWAYSON = $00000004;
    D3DCPCAPS_PARTIALDECRYPTION = $00000008;
    D3DCPCAPS_CONTENTKEY = $00000010;
    D3DCPCAPS_FRESHENSESSIONKEY = $00000020;
    D3DCPCAPS_ENCRYPTEDREADBACK = $00000040;
    D3DCPCAPS_ENCRYPTEDREADBACKKEY = $00000080;
    D3DCPCAPS_SEQUENTIAL_CTR_IV = $00000100;
    D3DCPCAPS_ENCRYPTSLICEDATAONLY = $00000200;

    D3DCRYPTOTYPE_AES128_CTR: TGUID = '{9B6BD711-4F74-41C9-9E7B-0BE2D7D93B4F}';

    D3DCRYPTOTYPE_PROPRIETARY: TGUID = '{AB4E9AFD-1D1C-46E6-A72F-0869917B0DE8}';


    D3DKEYEXCHANGE_RSAES_OAEP: TGUID = '{C1949895-D72A-4A1D-8E5D-ED857D171520}';

    D3DKEYEXCHANGE_DXVA: TGUID = '{43D3775C-38E5-4924-8D86-D3FCCF153E9B}';



    (* -- D3D9Ex only *)



    // BIT DEFINES FOR D3DCAPS9 DWORD MEMBERS


    // Caps


    D3DCAPS_OVERLAY = $00000800;
    D3DCAPS_READ_SCANLINE = $00020000;


    // Caps2

    D3DCAPS2_FULLSCREENGAMMA = $00020000;
    D3DCAPS2_CANCALIBRATEGAMMA = $00100000;
    D3DCAPS2_RESERVED = $02000000;
    D3DCAPS2_CANMANAGERESOURCE = $10000000;
    D3DCAPS2_DYNAMICTEXTURES = $20000000;
    D3DCAPS2_CANAUTOGENMIPMAP = $40000000;

    (* D3D9Ex only -- *)


    D3DCAPS2_CANSHARERESOURCE = $80000000;


    (* -- D3D9Ex only *)

    // Caps3


    D3DCAPS3_RESERVED = $8000001f;

    // Indicates that the device can respect the ALPHABLENDENABLE render state
    // when fullscreen while using the FLIP or DISCARD swap effect.
    // COPY and COPYVSYNC swap effects work whether or not this flag is set.
    D3DCAPS3_ALPHA_FULLSCREEN_FLIP_OR_DISCARD = $00000020;

    // Indicates that the device can perform a gamma correction from
    // a windowed back buffer containing linear content to the sRGB desktop.
    D3DCAPS3_LINEAR_TO_SRGB_PRESENTATION = $00000080;

    D3DCAPS3_COPY_TO_VIDMEM = $00000100; (* Device can acclerate copies from sysmem to local vidmem *)
    D3DCAPS3_COPY_TO_SYSTEMMEM = $00000200; (* Device can acclerate copies from local vidmem to sysmem *)
    D3DCAPS3_DXVAHD = $00000400;
    D3DCAPS3_DXVAHD_LIMITED = $00000800;



    // PresentationIntervals

    D3DPRESENT_INTERVAL_DEFAULT = $00000000;
    D3DPRESENT_INTERVAL_ONE = $00000001;
    D3DPRESENT_INTERVAL_TWO = $00000002;
    D3DPRESENT_INTERVAL_THREE = $00000004;
    D3DPRESENT_INTERVAL_FOUR = $00000008;
    D3DPRESENT_INTERVAL_IMMEDIATE = $80000000;


    // CursorCaps

    // Driver supports HW color cursor in at least hi-res modes(height >=400)
    D3DCURSORCAPS_COLOR = $00000001;
    // Driver supports HW cursor also in low-res modes(height < 400)
    D3DCURSORCAPS_LOWRES = $00000002;


    // DevCaps

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
    D3DDEVCAPS_PUREDEVICE = $00100000; (* Device supports D3DCREATE_PUREDEVICE *)
    D3DDEVCAPS_QUINTICRTPATCHES = $00200000; (* Device supports quintic Beziers and BSplines *)
    D3DDEVCAPS_RTPATCHES = $00400000; (* Device supports Rect and Tri patches *)
    D3DDEVCAPS_RTPATCHHANDLEZERO = $00800000; (* Indicates that RT Patches may be drawn efficiently using handle 0 *)
    D3DDEVCAPS_NPATCHES = $01000000; (* Device supports N-Patches *)


    // PrimitiveMiscCaps

    D3DPMISCCAPS_MASKZ = $00000002;
    D3DPMISCCAPS_CULLNONE = $00000010;
    D3DPMISCCAPS_CULLCW = $00000020;
    D3DPMISCCAPS_CULLCCW = $00000040;
    D3DPMISCCAPS_COLORWRITEENABLE = $00000080;
    D3DPMISCCAPS_CLIPPLANESCALEDPOINTS = $00000100; (* Device correctly clips scaled points to clip planes *)
    D3DPMISCCAPS_CLIPTLVERTS = $00000200; (* device will clip post-transformed vertex primitives *)
    D3DPMISCCAPS_TSSARGTEMP = $00000400; (* device supports D3DTA_TEMP for temporary register *)
    D3DPMISCCAPS_BLENDOP = $00000800; (* device supports D3DRS_BLENDOP *)
    D3DPMISCCAPS_NULLREFERENCE = $00001000; (* Reference Device that doesnt render *)
    D3DPMISCCAPS_INDEPENDENTWRITEMASKS = $00004000; (* Device supports independent write masks for MET or MRT *)
    D3DPMISCCAPS_PERSTAGECONSTANT = $00008000; (* Device supports per-stage constants *)
    D3DPMISCCAPS_FOGANDSPECULARALPHA = $00010000; (* Device supports separate fog and specular alpha (many devices
                                                          use the specular alpha channel to store fog factor) *)
    D3DPMISCCAPS_SEPARATEALPHABLEND = $00020000; (* Device supports separate blend settings for the alpha channel *)
    D3DPMISCCAPS_MRTINDEPENDENTBITDEPTHS = $00040000; (* Device supports different bit depths for MRT *)
    D3DPMISCCAPS_MRTPOSTPIXELSHADERBLENDING = $00080000; (* Device supports post-pixel shader operations for MRT *)
    D3DPMISCCAPS_FOGVERTEXCLAMPED = $00100000; (* Device clamps fog blend factor per vertex *)

    (* D3D9Ex only -- *)


    D3DPMISCCAPS_POSTBLENDSRGBCONVERT = $00200000; (* Indicates device can perform conversion to sRGB after blending. *)


    (* -- D3D9Ex only *)

    // LineCaps



    D3DLINECAPS_TEXTURE = $00000001;
    D3DLINECAPS_ZTEST = $00000002;
    D3DLINECAPS_BLEND = $00000004;
    D3DLINECAPS_ALPHACMP = $00000008;
    D3DLINECAPS_FOG = $00000010;
    D3DLINECAPS_ANTIALIAS = $00000020;


    // RasterCaps

    D3DPRASTERCAPS_DITHER = $00000001;
    D3DPRASTERCAPS_ZTEST = $00000010;
    D3DPRASTERCAPS_FOGVERTEX = $00000080;
    D3DPRASTERCAPS_FOGTABLE = $00000100;
    D3DPRASTERCAPS_MIPMAPLODBIAS = $00002000;
    D3DPRASTERCAPS_ZBUFFERLESSHSR = $00008000;
    D3DPRASTERCAPS_FOGRANGE = $00010000;
    D3DPRASTERCAPS_ANISOTROPY = $00020000;
    D3DPRASTERCAPS_WBUFFER = $00040000;
    D3DPRASTERCAPS_WFOG = $00100000;
    D3DPRASTERCAPS_ZFOG = $00200000;
    D3DPRASTERCAPS_COLORPERSPECTIVE = $00400000; (* Device iterates colors perspective correct *)
    D3DPRASTERCAPS_SCISSORTEST = $01000000;
    D3DPRASTERCAPS_SLOPESCALEDEPTHBIAS = $02000000;
    D3DPRASTERCAPS_DEPTHBIAS = $04000000;
    D3DPRASTERCAPS_MULTISAMPLE_TOGGLE = $08000000;


    // ZCmpCaps, AlphaCmpCaps

    D3DPCMPCAPS_NEVER = $00000001;
    D3DPCMPCAPS_LESS = $00000002;
    D3DPCMPCAPS_EQUAL = $00000004;
    D3DPCMPCAPS_LESSEQUAL = $00000008;
    D3DPCMPCAPS_GREATER = $00000010;
    D3DPCMPCAPS_NOTEQUAL = $00000020;
    D3DPCMPCAPS_GREATEREQUAL = $00000040;
    D3DPCMPCAPS_ALWAYS = $00000080;


    // SourceBlendCaps, DestBlendCaps

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
    D3DPBLENDCAPS_BLENDFACTOR = $00002000; (* Supports both D3DBLEND_BLENDFACTOR and D3DBLEND_INVBLENDFACTOR *)

    (* D3D9Ex only -- *)


    D3DPBLENDCAPS_SRCCOLOR2 = $00004000;
    D3DPBLENDCAPS_INVSRCCOLOR2 = $00008000;


    (* -- D3D9Ex only *)

    // ShadeCaps



    D3DPSHADECAPS_COLORGOURAUDRGB = $00000008;
    D3DPSHADECAPS_SPECULARGOURAUDRGB = $00000200;
    D3DPSHADECAPS_ALPHAGOURAUDBLEND = $00004000;
    D3DPSHADECAPS_FOGGOURAUD = $00080000;


    // TextureCaps

    D3DPTEXTURECAPS_PERSPECTIVE = $00000001; (* Perspective-correct texturing is supported *)
    D3DPTEXTURECAPS_POW2 = $00000002; (* Power-of-2 texture dimensions are required - applies to non-Cube/Volume textures only. *)
    D3DPTEXTURECAPS_ALPHA = $00000004; (* Alpha in texture pixels is supported *)
    D3DPTEXTURECAPS_SQUAREONLY = $00000020; (* Only square textures are supported *)
    D3DPTEXTURECAPS_TEXREPEATNOTSCALEDBYSIZE = $00000040; (* Texture indices are not scaled by the texture size prior to interpolation *)
    D3DPTEXTURECAPS_ALPHAPALETTE = $00000080; (* Device can draw alpha from texture palettes *)
    // Device can use non-POW2 textures if:
    //  1) D3DTEXTURE_ADDRESS is set to CLAMP for this texture's stage
    //  2) D3DRS_WRAP(N) is zero for this texture's coordinates
    //  3) mip mapping is not enabled (use magnification filter only)
    D3DPTEXTURECAPS_NONPOW2CONDITIONAL = $00000100;
    D3DPTEXTURECAPS_PROJECTED = $00000400; (* Device can do D3DTTFF_PROJECTED *)
    D3DPTEXTURECAPS_CUBEMAP = $00000800; (* Device can do cubemap textures *)
    D3DPTEXTURECAPS_VOLUMEMAP = $00002000; (* Device can do volume textures *)
    D3DPTEXTURECAPS_MIPMAP = $00004000; (* Device can do mipmapped textures *)
    D3DPTEXTURECAPS_MIPVOLUMEMAP = $00008000; (* Device can do mipmapped volume textures *)
    D3DPTEXTURECAPS_MIPCUBEMAP = $00010000; (* Device can do mipmapped cube maps *)
    D3DPTEXTURECAPS_CUBEMAP_POW2 = $00020000; (* Device requires that cubemaps be power-of-2 dimension *)
    D3DPTEXTURECAPS_VOLUMEMAP_POW2 = $00040000; (* Device requires that volume maps be power-of-2 dimension *)
    D3DPTEXTURECAPS_NOPROJECTEDBUMPENV = $00200000; (* Device does not support projected bump env lookup operation
                                                           in programmable and fixed function pixel shaders *)


    // TextureFilterCaps, StretchRectFilterCaps

    D3DPTFILTERCAPS_MINFPOINT = $00000100; (* Min Filter *)
    D3DPTFILTERCAPS_MINFLINEAR = $00000200;
    D3DPTFILTERCAPS_MINFANISOTROPIC = $00000400;
    D3DPTFILTERCAPS_MINFPYRAMIDALQUAD = $00000800;
    D3DPTFILTERCAPS_MINFGAUSSIANQUAD = $00001000;
    D3DPTFILTERCAPS_MIPFPOINT = $00010000; (* Mip Filter *)
    D3DPTFILTERCAPS_MIPFLINEAR = $00020000;

    (* D3D9Ex only -- *)


    D3DPTFILTERCAPS_CONVOLUTIONMONO = $00040000; (* Min and Mag for the convolution mono filter *)


    (* -- D3D9Ex only *)

    D3DPTFILTERCAPS_MAGFPOINT = $01000000; (* Mag Filter *)
    D3DPTFILTERCAPS_MAGFLINEAR = $02000000;
    D3DPTFILTERCAPS_MAGFANISOTROPIC = $04000000;
    D3DPTFILTERCAPS_MAGFPYRAMIDALQUAD = $08000000;
    D3DPTFILTERCAPS_MAGFGAUSSIANQUAD = $10000000;


    // TextureAddressCaps

    D3DPTADDRESSCAPS_WRAP = $00000001;
    D3DPTADDRESSCAPS_MIRROR = $00000002;
    D3DPTADDRESSCAPS_CLAMP = $00000004;
    D3DPTADDRESSCAPS_BORDER = $00000008;
    D3DPTADDRESSCAPS_INDEPENDENTUV = $00000010;
    D3DPTADDRESSCAPS_MIRRORONCE = $00000020;


    // StencilCaps

    D3DSTENCILCAPS_KEEP = $00000001;
    D3DSTENCILCAPS_ZERO = $00000002;
    D3DSTENCILCAPS_REPLACE = $00000004;
    D3DSTENCILCAPS_INCRSAT = $00000008;
    D3DSTENCILCAPS_DECRSAT = $00000010;
    D3DSTENCILCAPS_INVERT = $00000020;
    D3DSTENCILCAPS_INCR = $00000040;
    D3DSTENCILCAPS_DECR = $00000080;
    D3DSTENCILCAPS_TWOSIDED = $00000100;


    // TextureOpCaps

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
    D3DTEXOPCAPS_MULTIPLYADD = $01000000;
    D3DTEXOPCAPS_LERP = $02000000;


    // FVFCaps

    D3DFVFCAPS_TEXCOORDCOUNTMASK = $0000ffff; (* mask for texture coordinate count field *)
    D3DFVFCAPS_DONOTSTRIPELEMENTS = $00080000; (* Device prefers that vertex elements not be stripped *)
    D3DFVFCAPS_PSIZE = $00100000; (* Device can receive point size *)


    // VertexProcessingCaps

    D3DVTXPCAPS_TEXGEN = $00000001; (* device can do texgen *)
    D3DVTXPCAPS_MATERIALSOURCE7 = $00000002; (* device can do DX7-level colormaterialsource ops *)
    D3DVTXPCAPS_DIRECTIONALLIGHTS = $00000008; (* device can do directional lights *)
    D3DVTXPCAPS_POSITIONALLIGHTS = $00000010; (* device can do positional lights (includes point and spot) *)
    D3DVTXPCAPS_LOCALVIEWER = $00000020; (* device can do local viewer *)
    D3DVTXPCAPS_TWEENING = $00000040; (* device can do vertex tweening *)
    D3DVTXPCAPS_TEXGEN_SPHEREMAP = $00000100; (* device supports D3DTSS_TCI_SPHEREMAP *)
    D3DVTXPCAPS_NO_TEXGEN_NONLOCALVIEWER = $00000200; (* device does not support TexGen in non-local
                                                            viewer mode *)


    // DevCaps2

    D3DDEVCAPS2_STREAMOFFSET = $00000001; (* Device supports offsets in streams. Must be set by DX9 drivers *)
    D3DDEVCAPS2_DMAPNPATCH = $00000002; (* Device supports displacement maps for N-Patches*)
    D3DDEVCAPS2_ADAPTIVETESSRTPATCH = $00000004; (* Device supports adaptive tesselation of RT-patches*)
    D3DDEVCAPS2_ADAPTIVETESSNPATCH = $00000008; (* Device supports adaptive tesselation of N-patches*)
    D3DDEVCAPS2_CAN_STRETCHRECT_FROM_TEXTURES = $00000010; (* Device supports StretchRect calls with a texture as the source*)
    D3DDEVCAPS2_PRESAMPLEDDMAPNPATCH = $00000020; (* Device supports presampled displacement maps for N-Patches *)
    D3DDEVCAPS2_VERTEXELEMENTSCANSHARESTREAMOFFSET = $00000040; (* Vertex elements in a vertex declaration can share the same stream offset *)


    // DeclTypes

    D3DDTCAPS_UBYTE4 = $00000001;
    D3DDTCAPS_UBYTE4N = $00000002;
    D3DDTCAPS_SHORT2N = $00000004;
    D3DDTCAPS_SHORT4N = $00000008;
    D3DDTCAPS_USHORT2N = $00000010;
    D3DDTCAPS_USHORT4N = $00000020;
    D3DDTCAPS_UDEC3 = $00000040;
    D3DDTCAPS_DEC3N = $00000080;
    D3DDTCAPS_FLOAT16_2 = $00000100;
    D3DDTCAPS_FLOAT16_4 = $00000200;




type
//    {$PACKRECORDS 4}

    _D3DVSHADERCAPS2_0 = record
        Caps: DWORD;
        DynamicFlowControlDepth: int32;
        NumTemps: int32;
        StaticFlowControlDepth: int32;
    end;
    TD3DVSHADERCAPS2_0 = _D3DVSHADERCAPS2_0;
    PD3DVSHADERCAPS2_0 = ^TD3DVSHADERCAPS2_0;


    _D3DPSHADERCAPS2_0 = record
        Caps: DWORD;
        DynamicFlowControlDepth: int32;
        NumTemps: int32;
        StaticFlowControlDepth: int32;
        NumInstructionSlots: int32;
    end;
    TD3DPSHADERCAPS2_0 = _D3DPSHADERCAPS2_0;
    PD3DPSHADERCAPS2_0 = ^TD3DPSHADERCAPS2_0;


    (* D3D9Ex only -- *)

    _D3DOVERLAYCAPS = record
        Caps: UINT;
        MaxOverlayDisplayWidth: UINT;
        MaxOverlayDisplayHeight: UINT;
    end;
    TD3DOVERLAYCAPS = _D3DOVERLAYCAPS;
    PD3DOVERLAYCAPS = ^TD3DOVERLAYCAPS;

    _D3DCONTENTPROTECTIONCAPS = record
        Caps: DWORD;
        KeyExchangeType: TGUID;
        BufferAlignmentStart: UINT;
        BlockAlignmentSize: UINT;
        ProtectedMemorySize: ULONGLONG;
    end;
    TD3DCONTENTPROTECTIONCAPS = _D3DCONTENTPROTECTIONCAPS;
    PD3DCONTENTPROTECTIONCAPS = ^TD3DCONTENTPROTECTIONCAPS;

    (* -- D3D9Ex only *)



    _D3DCAPS9 = record
        (* Device Info *)
        DeviceType: TD3DDEVTYPE;
        AdapterOrdinal: UINT;
        (* Caps from DX7 Draw *)
        Caps: DWORD;
        Caps2: DWORD;
        Caps3: DWORD;
        PresentationIntervals: DWORD;
        (* Cursor Caps *)
        CursorCaps: DWORD;
        (* 3D Device Caps *)
        DevCaps: DWORD;
        PrimitiveMiscCaps: DWORD;
        RasterCaps: DWORD;
        ZCmpCaps: DWORD;
        SrcBlendCaps: DWORD;
        DestBlendCaps: DWORD;
        AlphaCmpCaps: DWORD;
        ShadeCaps: DWORD;
        TextureCaps: DWORD;
        TextureFilterCaps: DWORD; // D3DPTFILTERCAPS for IDirect3DTexture9's
        CubeTextureFilterCaps: DWORD; // D3DPTFILTERCAPS for IDirect3DCubeTexture9's
        VolumeTextureFilterCaps: DWORD; // D3DPTFILTERCAPS for IDirect3DVolumeTexture9's
        TextureAddressCaps: DWORD; // D3DPTADDRESSCAPS for IDirect3DTexture9's
        VolumeTextureAddressCaps: DWORD; // D3DPTADDRESSCAPS for IDirect3DVolumeTexture9's
        LineCaps: DWORD; // D3DLINECAPS
        MaxTextureWidthMaxTextureHeight: DWORD;
        MaxVolumeExtent: DWORD;
        MaxTextureRepeat: DWORD;
        MaxTextureAspectRatio: DWORD;
        MaxAnisotropy: DWORD;
        MaxVertexW: single;
        GuardBandLeft: single;
        GuardBandTop: single;
        GuardBandRight: single;
        GuardBandBottom: single;
        ExtentsAdjust: single;
        StencilCaps: DWORD;
        FVFCaps: DWORD;
        TextureOpCaps: DWORD;
        MaxTextureBlendStages: DWORD;
        MaxSimultaneousTextures: DWORD;
        VertexProcessingCaps: DWORD;
        MaxActiveLights: DWORD;
        MaxUserClipPlanes: DWORD;
        MaxVertexBlendMatrices: DWORD;
        MaxVertexBlendMatrixIndex: DWORD;
        MaxPointSize: single;
        MaxPrimitiveCount: DWORD; // max number of primitives per DrawPrimitive call
        MaxVertexIndex: DWORD;
        MaxStreams: DWORD;
        MaxStreamStride: DWORD; // max stride for SetStreamSource
        VertexShaderVersion: DWORD;
        MaxVertexShaderConst: DWORD; // number of vertex shader constant registers
        PixelShaderVersion: DWORD;
        PixelShader1xMaxValue: single; // max value storable in registers of ps.1.x shaders
        // Here are the DX9 specific ones
        DevCaps2: DWORD;
        MaxNpatchTessellationLevel: single;
        Reserved5: DWORD;
        MasterAdapterOrdinal: UINT; // ordinal of master adaptor for adapter group
        AdapterOrdinalInGroup: UINT; // ordinal inside the adapter group
        NumberOfAdaptersInGroup: UINT; // number of adapters in this adapter group (only if master)
        DeclTypes: DWORD; // Data types, supported in vertex declarations
        NumSimultaneousRTs: DWORD; // Will be at least 1
        StretchRectFilterCaps: DWORD; // Filter caps supported by StretchRect
        VS20Caps: TD3DVSHADERCAPS2_0;
        PS20Caps: TD3DPSHADERCAPS2_0;
        VertexTextureFilterCaps: DWORD; // D3DPTFILTERCAPS for IDirect3DTexture9's for texture, used in vertex shaders
        MaxVShaderInstructionsExecuted: DWORD; // maximum number of vertex shader instructions that can be executed
        MaxPShaderInstructionsExecuted: DWORD; // maximum number of pixel shader instructions that can be executed
        MaxVertexShader30InstructionSlots: DWORD;
        MaxPixelShader30InstructionSlots: DWORD;
    end;
    TD3DCAPS9 = _D3DCAPS9;
    PD3DCAPS9 = ^TD3DCAPS9;


   {$PACKRECORDS DEFAULT}



implementation

end.
