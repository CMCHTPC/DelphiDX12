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
   File name: d3d9types.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3D9Types;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

{$Z4}

interface

uses
    Windows, Classes, SysUtils;

const



(*
 * Values for clip fields.
 *)
    // Max number of user clipping planes, supported in D3D.

    D3DMAXUSERCLIPPLANES = 32;

    // These bits could be ORed together to use with D3DRS_CLIPPLANEENABLE

    D3DCLIPPLANE0 = (1 shl 0);
    D3DCLIPPLANE1 = (1 shl 1);
    D3DCLIPPLANE2 = (1 shl 2);
    D3DCLIPPLANE3 = (1 shl 3);
    D3DCLIPPLANE4 = (1 shl 4);
    D3DCLIPPLANE5 = (1 shl 5);

    // The following bits are used in the ClipUnion and ClipIntersection
    // members of the D3DCLIPSTATUS9


    D3DCS_LEFT = $00000001;
    D3DCS_RIGHT = $00000002;
    D3DCS_TOP = $00000004;
    D3DCS_BOTTOM = $00000008;
    D3DCS_FRONT = $00000010;
    D3DCS_BACK = $00000020;
    D3DCS_PLANE0 = $00000040;
    D3DCS_PLANE1 = $00000080;
    D3DCS_PLANE2 = $00000100;
    D3DCS_PLANE3 = $00000200;
    D3DCS_PLANE4 = $00000400;
    D3DCS_PLANE5 = $00000800;

    D3DCS_ALL = (D3DCS_LEFT or D3DCS_RIGHT or D3DCS_TOP or D3DCS_BOTTOM or D3DCS_FRONT or D3DCS_BACK or D3DCS_PLANE0 or D3DCS_PLANE1 or D3DCS_PLANE2 or D3DCS_PLANE3 or D3DCS_PLANE4 or D3DCS_PLANE5);




(*
 * Options for clearing
 *)
    D3DCLEAR_TARGET = $00000001; (* Clear target surface *)
    D3DCLEAR_ZBUFFER = $00000002; (* Clear target z buffer *)
    D3DCLEAR_STENCIL = $00000004; (* Clear stencil planes *)




    // Maximum number of simultaneous render targets D3D supports
    D3D_MAX_SIMULTANEOUS_RENDERTARGETS = 4;

    // Bias to apply to the texture coordinate set to apply a wrap to.
    D3DRENDERSTATE_WRAPBIAS = 128;

    (* Flags to construct the WRAP render states *)
    D3DWRAP_U = $00000001;
    D3DWRAP_V = $00000002;
    D3DWRAP_W = $00000004;

    (* Flags to construct the WRAP render states for 1D thru 4D texture coordinates *)
    D3DWRAPCOORD_0 = $00000001; // same as D3DWRAP_U
    D3DWRAPCOORD_1 = $00000002; // same as D3DWRAP_V
    D3DWRAPCOORD_2 = $00000004; // same as D3DWRAP_W
    D3DWRAPCOORD_3 = $00000008;

    (* Flags to construct D3DRS_COLORWRITEENABLE *)
    D3DCOLORWRITEENABLE_RED = (1 shl 0);
    D3DCOLORWRITEENABLE_GREEN = (1 shl 1);
    D3DCOLORWRITEENABLE_BLUE = (1 shl 2);
    D3DCOLORWRITEENABLE_ALPHA = (1 shl 3);


    (* Special sampler which is used in the tesselator *)
    D3DDMAPSAMPLER = 256;

    // Samplers used in vertex shaders
    D3DVERTEXTEXTURESAMPLER0 = (D3DDMAPSAMPLER + 1);
    D3DVERTEXTEXTURESAMPLER1 = (D3DDMAPSAMPLER + 2);
    D3DVERTEXTEXTURESAMPLER2 = (D3DDMAPSAMPLER + 3);
    D3DVERTEXTEXTURESAMPLER3 = (D3DDMAPSAMPLER + 4);

    // Values, used with D3DTSS_TEXCOORDINDEX, to specify that the vertex data(position
    // and normal in the camera space) should be taken as texture coordinates
    // Low 16 bits are used to specify texture coordinate index, to take the WRAP mode from

    D3DTSS_TCI_PASSTHRU = $00000000;
    D3DTSS_TCI_CAMERASPACENORMAL = $00010000;
    D3DTSS_TCI_CAMERASPACEPOSITION = $00020000;
    D3DTSS_TCI_CAMERASPACEREFLECTIONVECTOR = $00030000;
    D3DTSS_TCI_SPHEREMAP = $00040000;


(*
 * Values for COLORARG0,1,2, ALPHAARG0,1,2, and RESULTARG texture blending
 * operations set in texture processing stage controls in D3DRENDERSTATE.
 *)
    D3DTA_SELECTMASK = $0000000f; // mask for arg selector
    D3DTA_DIFFUSE = $00000000; // select diffuse color (read only)
    D3DTA_CURRENT = $00000001; // select stage destination register (read/write)
    D3DTA_TEXTURE = $00000002; // select texture color (read only)
    D3DTA_TFACTOR = $00000003; // select D3DRS_TEXTUREFACTOR (read only)
    D3DTA_SPECULAR = $00000004; // select specular color (read only)
    D3DTA_TEMP = $00000005; // select temporary register color (read/write)
    D3DTA_CONSTANT = $00000006; // select texture stage constant
    D3DTA_COMPLEMENT = $00000010; // take 1.0 - x (read modifier)
    D3DTA_ALPHAREPLICATE = $00000020; // replicate alpha to color components (read modifier)




    (* Bits for Flags in ProcessVertices call *)

    D3DPV_DONOTCOPYDATA = (1 shl 0);

    //-------------------------------------------------------------------
    // Flexible vertex format bits


    D3DFVF_RESERVED0 = $001;
    D3DFVF_POSITION_MASK = $400E;
    D3DFVF_XYZ = $002;
    D3DFVF_XYZRHW = $004;
    D3DFVF_XYZB1 = $006;
    D3DFVF_XYZB2 = $008;
    D3DFVF_XYZB3 = $00a;
    D3DFVF_XYZB4 = $00c;
    D3DFVF_XYZB5 = $00e;
    D3DFVF_XYZW = $4002;

    D3DFVF_NORMAL = $010;
    D3DFVF_PSIZE = $020;
    D3DFVF_DIFFUSE = $040;
    D3DFVF_SPECULAR = $080;

    D3DFVF_TEXCOUNT_MASK = $f00;
    D3DFVF_TEXCOUNT_SHIFT = 8;
    D3DFVF_TEX0 = $000;
    D3DFVF_TEX1 = $100;
    D3DFVF_TEX2 = $200;
    D3DFVF_TEX3 = $300;
    D3DFVF_TEX4 = $400;
    D3DFVF_TEX5 = $500;
    D3DFVF_TEX6 = $600;
    D3DFVF_TEX7 = $700;
    D3DFVF_TEX8 = $800;

    D3DFVF_LASTBETA_UBYTE4 = $1000;
    D3DFVF_LASTBETA_D3DCOLOR = $8000;

    D3DFVF_RESERVED2 = $6000; // 2 reserved bits




    MAXD3DDECLUSAGEINDEX = 15;
    MAXD3DDECLLENGTH = 64; // does not include "end" marker vertex element




    // This is used to initialize the last vertex element in a vertex declaration
    // array



    // Maximum supported number of texture coordinate sets
    D3DDP_MAXTEXCOORD = 8;

    //---------------------------------------------------------------------
    // Values for IDirect3DDevice9::SetStreamSourceFreq's Setting parameter
    //---------------------------------------------------------------------
    D3DSTREAMSOURCE_INDEXEDDATA = (1 shl 30);
    D3DSTREAMSOURCE_INSTANCEDATA = (2 shl 30);



    //---------------------------------------------------------------------

    // The internal format of Pixel Shader (PS) & Vertex Shader (VS)
    // Instruction Tokens is defined in the Direct3D Device Driver Kit

    //---------------------------------------------------------------------

    // Instruction Token Bit Definitions


    D3DSI_OPCODE_MASK = $0000FFFF;

    D3DSI_INSTLENGTH_MASK = $0F000000;
    D3DSI_INSTLENGTH_SHIFT = 24;

    //---------------------------------------------------------------------
    // Use these constants with D3DSIO_SINCOS macro as SRC2, SRC3

    // ToDo D3DSINCOSCONST1 = -1.5500992e-006,-2.1701389e-005,0.0026041667,0.00026041668;
    // ToDo D3DSINCOSCONST2 = -0.020833334,-0.12500000,1.0,0.50000000;

    //---------------------------------------------------------------------
    // Co-Issue Instruction Modifier - if set then this instruction is to be
    // issued in parallel with the previous instruction(s) for which this bit
    // is not set.

    D3DSI_COISSUE = $40000000;

    //---------------------------------------------------------------------
    // Opcode specific controls

    D3DSP_OPCODESPECIFICCONTROL_MASK = $00ff0000;
    D3DSP_OPCODESPECIFICCONTROL_SHIFT = 16;

    // ps_2_0 texld controls
    D3DSI_TEXLD_PROJECT = ($01 shl D3DSP_OPCODESPECIFICCONTROL_SHIFT);
    D3DSI_TEXLD_BIAS = ($02 shl D3DSP_OPCODESPECIFICCONTROL_SHIFT);


    // Comparison is part of instruction opcode token:
    D3DSHADER_COMPARISON_SHIFT = D3DSP_OPCODESPECIFICCONTROL_SHIFT;
    D3DSHADER_COMPARISON_MASK = ($7 shl D3DSHADER_COMPARISON_SHIFT);

    //---------------------------------------------------------------------
    // Predication flags on instruction token
    D3DSHADER_INSTRUCTION_PREDICATED = ($1 shl 28);

    //---------------------------------------------------------------------
    // DCL Info Token Controls
    // For dcl info tokens requiring a semantic (usage + index)

    D3DSP_DCL_USAGE_SHIFT = 0;
    D3DSP_DCL_USAGE_MASK = $0000000f;

    D3DSP_DCL_USAGEINDEX_SHIFT = 16;
    D3DSP_DCL_USAGEINDEX_MASK = $000f0000;

    // DCL pixel shader sampler info token.
    D3DSP_TEXTURETYPE_SHIFT = 27;
    D3DSP_TEXTURETYPE_MASK = $78000000;


    //---------------------------------------------------------------------
    // Parameter Token Bit Definitions

    D3DSP_REGNUM_MASK = $000007FF;

    // destination parameter write mask
    D3DSP_WRITEMASK_0 = $00010000; // Component 0 (X;Red)
    D3DSP_WRITEMASK_1 = $00020000; // Component 1 (Y;Green)
    D3DSP_WRITEMASK_2 = $00040000; // Component 2 (Z;Blue)
    D3DSP_WRITEMASK_3 = $00080000; // Component 3 (W;Alpha)
    D3DSP_WRITEMASK_ALL = $000F0000; // All Components

    // destination parameter modifiers
    D3DSP_DSTMOD_SHIFT = 20;
    D3DSP_DSTMOD_MASK = $00F00000;

    // Bit masks for destination parameter modifiers
    D3DSPDM_NONE = (0 shl D3DSP_DSTMOD_SHIFT); // nop
    D3DSPDM_SATURATE = (1 shl D3DSP_DSTMOD_SHIFT); // clamp to 0. to 1. range
    D3DSPDM_PARTIALPRECISION = (2 shl D3DSP_DSTMOD_SHIFT); // Partial precision hint
    D3DSPDM_MSAMPCENTROID = (4 shl D3DSP_DSTMOD_SHIFT); // Relevant to multisampling only:
    //      When the pixel center is not covered, sample
    //      attribute or compute gradients/LOD
    //      using multisample "centroid" location.
    //      "Centroid" is some location within the covered
    //      region of the pixel.
    // destination parameter

    D3DSP_DSTSHIFT_SHIFT = 24;
    D3DSP_DSTSHIFT_MASK = $0F000000;

    // destination/source parameter register type
    D3DSP_REGTYPE_SHIFT = 28;
    D3DSP_REGTYPE_SHIFT2 = 8;
    D3DSP_REGTYPE_MASK = $70000000;
    D3DSP_REGTYPE_MASK2 = $00001800;



    // Source operand addressing modes

    D3DVS_ADDRESSMODE_SHIFT = 13;
    D3DVS_ADDRESSMODE_MASK = (1 shl D3DVS_ADDRESSMODE_SHIFT);



    D3DSHADER_ADDRESSMODE_SHIFT = 13;
    D3DSHADER_ADDRESSMODE_MASK = (1 shl D3DSHADER_ADDRESSMODE_SHIFT);



    // Source operand swizzle definitions

    D3DVS_SWIZZLE_SHIFT = 16;
    D3DVS_SWIZZLE_MASK = $00FF0000;

    // The following bits define where to take component X from:

    D3DVS_X_X = (0 shl D3DVS_SWIZZLE_SHIFT);
    D3DVS_X_Y = (1 shl D3DVS_SWIZZLE_SHIFT);
    D3DVS_X_Z = (2 shl D3DVS_SWIZZLE_SHIFT);
    D3DVS_X_W = (3 shl D3DVS_SWIZZLE_SHIFT);

    // The following bits define where to take component Y from:

    D3DVS_Y_X = (0 shl (D3DVS_SWIZZLE_SHIFT + 2));
    D3DVS_Y_Y = (1 shl (D3DVS_SWIZZLE_SHIFT + 2));
    D3DVS_Y_Z = (2 shl (D3DVS_SWIZZLE_SHIFT + 2));
    D3DVS_Y_W = (3 shl (D3DVS_SWIZZLE_SHIFT + 2));

    // The following bits define where to take component Z from:

    D3DVS_Z_X = (0 shl (D3DVS_SWIZZLE_SHIFT + 4));
    D3DVS_Z_Y = (1 shl (D3DVS_SWIZZLE_SHIFT + 4));
    D3DVS_Z_Z = (2 shl (D3DVS_SWIZZLE_SHIFT + 4));
    D3DVS_Z_W = (3 shl (D3DVS_SWIZZLE_SHIFT + 4));

    // The following bits define where to take component W from:

    D3DVS_W_X = (0 shl (D3DVS_SWIZZLE_SHIFT + 6));
    D3DVS_W_Y = (1 shl (D3DVS_SWIZZLE_SHIFT + 6));
    D3DVS_W_Z = (2 shl (D3DVS_SWIZZLE_SHIFT + 6));
    D3DVS_W_W = (3 shl (D3DVS_SWIZZLE_SHIFT + 6));

    // Value when there is no swizzle (X is taken from X, Y is taken from Y,
    // Z is taken from Z, W is taken from W

    D3DVS_NOSWIZZLE = (D3DVS_X_X or D3DVS_Y_Y or D3DVS_Z_Z or D3DVS_W_W);

    // source parameter swizzle
    D3DSP_SWIZZLE_SHIFT = 16;
    D3DSP_SWIZZLE_MASK = $00FF0000;

    D3DSP_NOSWIZZLE = ((0 shl (D3DSP_SWIZZLE_SHIFT + 0)) or (1 shl (D3DSP_SWIZZLE_SHIFT + 2)) or (2 shl (D3DSP_SWIZZLE_SHIFT + 4)) or (3 shl (D3DSP_SWIZZLE_SHIFT + 6)));




    // pixel-shader swizzle ops
    D3DSP_REPLICATERED = ((0 shl (D3DSP_SWIZZLE_SHIFT + 0)) or (0 shl (D3DSP_SWIZZLE_SHIFT + 2)) or (0 shl (D3DSP_SWIZZLE_SHIFT + 4)) or (0 shl (D3DSP_SWIZZLE_SHIFT + 6)));




    D3DSP_REPLICATEGREEN = ((1 shl (D3DSP_SWIZZLE_SHIFT + 0)) or (1 shl (D3DSP_SWIZZLE_SHIFT + 2)) or (1 shl (D3DSP_SWIZZLE_SHIFT + 4)) or (1 shl (D3DSP_SWIZZLE_SHIFT + 6)));




    D3DSP_REPLICATEBLUE = ((2 shl (D3DSP_SWIZZLE_SHIFT + 0)) or (2 shl (D3DSP_SWIZZLE_SHIFT + 2)) or (2 shl (D3DSP_SWIZZLE_SHIFT + 4)) or (2 shl (D3DSP_SWIZZLE_SHIFT + 6)));




    D3DSP_REPLICATEALPHA = ((3 shl (D3DSP_SWIZZLE_SHIFT + 0)) or (3 shl (D3DSP_SWIZZLE_SHIFT + 2)) or (3 shl (D3DSP_SWIZZLE_SHIFT + 4)) or (3 shl (D3DSP_SWIZZLE_SHIFT + 6)));




    // source parameter modifiers
    D3DSP_SRCMOD_SHIFT = 24;
    D3DSP_SRCMOD_MASK = $0F000000;

    (* Formats
 * Most of these names have the following convention:
 *      A = Alpha
 *      R = Red
 *      G = Green
 *      B = Blue
 *      X = Unused Bits
 *      P = Palette
 *      L = Luminance
 *      U = dU coordinate for BumpMap
 *      V = dV coordinate for BumpMap
 *      S = Stencil
 *      D = Depth (e.g. Z or W buffer)
 *      C = Computed from other channels (typically on certain read operations)
 *
 *      Further, the order of the pieces are from MSB first; hence
 *      D3DFMT_A8L8 indicates that the high byte of this two byte
 *      format is alpha.
 *
 *      D3DFMT_D16_LOCKABLE indicates:
 *           - An integer 16-bit value.
 *           - An app-lockable surface.
 *
 *      D3DFMT_D32F_LOCKABLE indicates:
 *           - An IEEE 754 floating-point value.
 *           - An app-lockable surface.
 *
 *      All Depth/Stencil formats except D3DFMT_D16_LOCKABLE and D3DFMT_D32F_LOCKABLE indicate:
 *          - no particular bit ordering per pixel, and
 *          - are not app lockable, and
 *          - the driver is allowed to consume more than the indicated
 *            number of bits per Depth channel (but not Stencil channel).
 *)



    (* RefreshRate pre-defines *)
    D3DPRESENT_RATE_DEFAULT = $00000000;


    // Values for D3DPRESENT_PARAMETERS.Flags

    D3DPRESENTFLAG_LOCKABLE_BACKBUFFER = $00000001;
    D3DPRESENTFLAG_DISCARD_DEPTHSTENCIL = $00000002;
    D3DPRESENTFLAG_DEVICECLIP = $00000004;
    D3DPRESENTFLAG_VIDEO = $00000010;

    (* D3D9Ex only -- *)


    D3DPRESENTFLAG_NOAUTOROTATE = $00000020;
    D3DPRESENTFLAG_UNPRUNEDMODE = $00000040;
    D3DPRESENTFLAG_OVERLAY_LIMITEDRGB = $00000080;
    D3DPRESENTFLAG_OVERLAY_YCbCr_BT709 = $00000100;
    D3DPRESENTFLAG_OVERLAY_YCbCr_xvYCC = $00000200;
    D3DPRESENTFLAG_RESTRICTED_CONTENT = $00000400;
    D3DPRESENTFLAG_RESTRICT_SHARED_RESOURCE_DRIVER = $00000800;



    (* Usages *)
    D3DUSAGE_RENDERTARGET = ($00000001);
    D3DUSAGE_DEPTHSTENCIL = ($00000002);
    D3DUSAGE_DYNAMIC = ($00000200);

    (* D3D9Ex only -- *)


    D3DUSAGE_NONSECURE = ($00800000);


    (* -- D3D9Ex only *)
    // When passed to CheckDeviceFormat, D3DUSAGE_AUTOGENMIPMAP may return
    // D3DOK_NOAUTOGEN if the device doesn't support autogeneration for that format.
    // D3DOK_NOAUTOGEN is a success code, not a failure code... the SUCCEEDED and FAILED macros
    // will return true and false respectively for this code.

    D3DUSAGE_AUTOGENMIPMAP = ($00000400);
    D3DUSAGE_DMAP = ($00004000);

    // The following usages are valid only for querying CheckDeviceFormat
    D3DUSAGE_QUERY_LEGACYBUMPMAP = ($00008000);
    D3DUSAGE_QUERY_SRGBREAD = ($00010000);
    D3DUSAGE_QUERY_FILTER = ($00020000);
    D3DUSAGE_QUERY_SRGBWRITE = ($00040000);
    D3DUSAGE_QUERY_POSTPIXELSHADER_BLENDING = ($00080000);
    D3DUSAGE_QUERY_VERTEXTEXTURE = ($00100000);
    D3DUSAGE_QUERY_WRAPANDMIP = ($00200000);

    (* Usages for Vertex/Index buffers *)
    D3DUSAGE_WRITEONLY = ($00000008);
    D3DUSAGE_SOFTWAREPROCESSING = ($00000010);
    D3DUSAGE_DONOTCLIP = ($00000020);
    D3DUSAGE_POINTS = ($00000040);
    D3DUSAGE_RTPATCHES = ($00000080);
    D3DUSAGE_NPATCHES = ($00000100);

    (* D3D9Ex only -- *)


    D3DUSAGE_TEXTAPI = ($10000000);
    D3DUSAGE_RESTRICTED_CONTENT = ($00000800);
    D3DUSAGE_RESTRICT_SHARED_RESOURCE = ($00002000);
    D3DUSAGE_RESTRICT_SHARED_RESOURCE_DRIVER = ($00001000);


    (* -- D3D9Ex only *)
    (* Lock flags *)




    D3DLOCK_READONLY = $00000010;
    D3DLOCK_DISCARD = $00002000;
    D3DLOCK_NOOVERWRITE = $00001000;
    D3DLOCK_NOSYSLOCK = $00000800;
    D3DLOCK_DONOTWAIT = $00004000;

    D3DLOCK_NO_DIRTY_UPDATE = $00008000;




    (* Adapter Identifier *)

    MAX_DEVICE_IDENTIFIER_STRING = 512;




    // Flags field for Issue
    D3DISSUE_END = (1 shl 0); // Tells the runtime to issue the end of a query, changing it's state to "non-signaled".
    D3DISSUE_BEGIN = (1 shl 1); // Tells the runtime to issue the beginng of a query.


    // Flags field for GetData
    D3DGETDATA_FLUSH = (1 shl 0); // Tells the runtime to flush if the query is outstanding.




    D3DCOMPOSERECTS_MAXNUMRECTS = $FFFF;
    D3DCONVOLUTIONMONO_MAXWIDTH = 7;
    D3DCONVOLUTIONMONO_MAXHEIGHT = D3DCONVOLUTIONMONO_MAXWIDTH;
    D3DFMT_A1_SURFACE_MAXWIDTH = 8192;
    D3DFMT_A1_SURFACE_MAXHEIGHT = 2048;



    (* For use in ID3DResource9::SetPriority calls *)
    D3D9_RESOURCE_PRIORITY_MINIMUM = $28000000;
    D3D9_RESOURCE_PRIORITY_LOW = $50000000;
    D3D9_RESOURCE_PRIORITY_NORMAL = $78000000;
    D3D9_RESOURCE_PRIORITY_HIGH = $a0000000;
    D3D9_RESOURCE_PRIORITY_MAXIMUM = $c8000000;

    D3D_OMAC_SIZE = 16;

    D3DAUTHENTICATEDQUERY_PROTECTION: TGUID = '{A84EB584-C495-48AA-B94D-8BD2D6FBCE05}';

    D3DAUTHENTICATEDQUERY_CHANNELTYPE: TGUID = '{BC1B18A5-B1FB-42AB-BD94-B5828B4BF7BE}';

    D3DAUTHENTICATEDQUERY_DEVICEHANDLE: TGUID = '{EC1C539D-8CFF-4E2A-BCC4-F5692F99F480}';

    D3DAUTHENTICATEDQUERY_CRYPTOSESSION: TGUID = '{2634499E-D018-4D74-AC17-7F724059528D}';


    D3DAUTHENTICATEDQUERY_RESTRICTEDSHAREDRESOURCEPROCESSCOUNT: TGUID = '{0DB207B3-9450-46A6-82DE-1B96D44F9CF2}';




    D3DAUTHENTICATEDQUERY_RESTRICTEDSHAREDRESOURCEPROCESS: TGUID = '{649BBADB-F0F4-4639-A15B-24393FC3ABAC}';




    D3DAUTHENTICATEDQUERY_UNRESTRICTEDPROTECTEDSHAREDRESOURCECOUNT: TGUID = '{012F0BD6-E662-4474-BEFD-AA53E5143C6D}';




    D3DAUTHENTICATEDQUERY_OUTPUTIDCOUNT: TGUID = '{2C042B5E-8C07-46D5-AABE-8F75CBAD4C31}';



    D3DAUTHENTICATEDQUERY_OUTPUTID: TGUID = '{839DDCA3-9B4E-41E4-B053-892BD2A11EE7}';



    D3DAUTHENTICATEDQUERY_ACCESSIBILITYATTRIBUTES: TGUID = '{6214D9D2-432C-4ABB-9FCE-216EEA269E3B}';




    D3DAUTHENTICATEDQUERY_ENCRYPTIONWHENACCESSIBLEGUIDCOUNT: TGUID = '{B30F7066-203C-4B07-93FC-CEAAFD61241E}';




    D3DAUTHENTICATEDQUERY_ENCRYPTIONWHENACCESSIBLEGUID: TGUID = '{F83A5958-E986-4BDA-BEB0-411F6A7A01B7}';




    D3DAUTHENTICATEDQUERY_CURRENTENCRYPTIONWHENACCESSIBLE: TGUID = '{EC1791C7-DAD3-4F15-9EC3-FAA93D60D4F0}';



    D3DAUTHENTICATEDCONFIGURE_INITIALIZE: TGUID = '{06114BDB-3523-470A-8DCA-FBC2845154F0}';



    D3DAUTHENTICATEDCONFIGURE_PROTECTION: TGUID = '{50455658-3F47-4362-BF99-BFDFCDE9ED29}';




    D3DAUTHENTICATEDCONFIGURE_CRYPTOSESSION: TGUID = '{6346CC54-2CFC-4AD4-8224-D15837DE7700}';




    D3DAUTHENTICATEDCONFIGURE_SHAREDRESOURCE: TGUID = '{0772D047-1B40-48E8-9CA6-B5F510DE9F01}';



    D3DAUTHENTICATEDCONFIGURE_ENCRYPTIONWHENACCESSIBLE: TGUID = '{41FFF286-6AE0-4D43-9D55-A46E9EFD158A}';


    // Source or dest token bits [15:14]:
    // destination parameter modifiers
    D3DSP_MIN_PRECISION_SHIFT = 14;
    D3DSP_MIN_PRECISION_MASK = $0000C000;

    // destination/source parameter register type
    D3DSI_COMMENTSIZE_SHIFT = 16;
    D3DSI_COMMENTSIZE_MASK = $7FFF0000;


    // Macros to set texture coordinate format bits in the FVF id

    D3DFVF_TEXTUREFORMAT2 = 0; // Two floating point values
    D3DFVF_TEXTUREFORMAT1 = 3; // One floating point value
    D3DFVF_TEXTUREFORMAT3 = 1; // Three floating point values
    D3DFVF_TEXTUREFORMAT4 = 2; // Four floating point values


    // pixel/vertex shader end token
    D3DPS_END = $0000FFFF;
    D3DVS_END = $0000FFFF;


type
    (* Types *)
    _D3DRESOURCETYPE = (
        D3DRTYPE_SURFACE = 1,
        D3DRTYPE_VOLUME = 2,
        D3DRTYPE_TEXTURE = 3,
        D3DRTYPE_VOLUMETEXTURE = 4,
        D3DRTYPE_CUBETEXTURE = 5,
        D3DRTYPE_VERTEXBUFFER = 6,
        D3DRTYPE_INDEXBUFFER = 7, //if this changes, change _D3DDEVINFO_RESOURCEMANAGER definition
        D3DRTYPE_FORCE_DWORD = $7fffffff);

    TD3DRESOURCETYPE = _D3DRESOURCETYPE;
    PD3DRESOURCETYPE = ^TD3DRESOURCETYPE;

const
    D3DRTYPECOUNT = (Ord(D3DRTYPE_INDEXBUFFER) + 1);

type
    //    {$IFDEF WIN32}
    //    {$PACKRECORDS 4}
    //    {$ELSE}
    //    {$PACKRECORDS 8}
    //    {$ENDIF}

    // D3DCOLOR is equivalent to D3DFMT_A8R8G8B8
    D3DCOLOR = DWORD;
    TD3DCOLOR = D3DCOLOR;

    _D3DVECTOR = record
        x: single;
        y: single;
        z: single;
    end;


    TD3DVECTOR = _D3DVECTOR;
    PD3DVECTOR = ^TD3DVECTOR;



    _D3DCOLORVALUE = record
        r: single;
        g: single;
        b: single;
        a: single;
    end;


    TD3DCOLORVALUE = _D3DCOLORVALUE;
    PD3DCOLORVALUE = ^TD3DCOLORVALUE;



    _D3DRECT = record
        x1: LONG;
        y1: LONG;
        x2: LONG;
        y2: LONG;
    end;

    TD3DRECT = _D3DRECT;
    PD3DRECT = ^TD3DRECT;


    _D3DMATRIX = record
        case integer of
            0: (
                _11,_12,_13,_14: single;
                _21,_22,_23,_24: single;
                _31,_32,_33,_34: single;
                _41,_42,_43,_44: single;
            );
            1: (
                m: array [0..3, 0..3] of single;
            );
            2: (f: array [0..15] of single)
    end;

    TD3DMATRIX = _D3DMATRIX;
    PD3DMATRIX = ^TD3DMATRIX;


    _D3DVIEWPORT9 = record
        X: DWORD;
        Y: DWORD; (* Viewport Top left *)
        Width: DWORD;
        Height: DWORD; (* Viewport Dimensions *)
        MinZ: single; (* Min/max of clip Volume *)
        MaxZ: single;
    end;


    TD3DVIEWPORT9 = _D3DVIEWPORT9;
    PD3DVIEWPORT9 = ^TD3DVIEWPORT9;



    _D3DCLIPSTATUS9 = record
        ClipUnion: DWORD;
        ClipIntersection: DWORD;
    end;


    TD3DCLIPSTATUS9 = _D3DCLIPSTATUS9;
    PD3DCLIPSTATUS9 = ^TD3DCLIPSTATUS9;

    _D3DMATERIAL9 = record
        Diffuse: TD3DCOLORVALUE; (* Diffuse color RGBA *)
        Ambient: TD3DCOLORVALUE; (* Ambient color RGB *)
        Specular: TD3DCOLORVALUE; (* Specular 'shininess' *)
        Emissive: TD3DCOLORVALUE; (* Emissive color RGB *)
        Power: single; (* Sharpness if specular highlight *)
    end;


    TD3DMATERIAL9 = _D3DMATERIAL9;
    PD3DMATERIAL9 = ^TD3DMATERIAL9;

    _D3DLIGHTTYPE = (
        D3DLIGHT_POINT = 1,
        D3DLIGHT_SPOT = 2,
        D3DLIGHT_DIRECTIONAL = 3,
        D3DLIGHT_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    TD3DLIGHTTYPE = _D3DLIGHTTYPE;
    PD3DLIGHTTYPE = ^TD3DLIGHTTYPE;

    _D3DLIGHT9 = record
        LightType: TD3DLIGHTTYPE; (* Type of light source *)
        Diffuse: TD3DCOLORVALUE; (* Diffuse color of light *)
        Specular: TD3DCOLORVALUE; (* Specular color of light *)
        Ambient: TD3DCOLORVALUE; (* Ambient color of light *)
        Position: TD3DVECTOR; (* Position in world space *)
        Direction: TD3DVECTOR; (* Direction in world space *)
        Range: single; (* Cutoff range *)
        Falloff: single; (* Falloff *)
        Attenuation0: single; (* Constant attenuation *)
        Attenuation1: single; (* Linear attenuation *)
        Attenuation2: single; (* Quadratic attenuation *)
        Theta: single; (* Inner angle of spotlight cone *)
        Phi: single; (* Outer angle of spotlight cone *)
    end;


    TD3DLIGHT9 = _D3DLIGHT9;
    PD3DLIGHT9 = ^TD3DLIGHT9;



(*
 * The following defines the rendering states
 *)

    _D3DSHADEMODE = (
        D3DSHADE_FLAT = 1,
        D3DSHADE_GOURAUD = 2,
        D3DSHADE_PHONG = 3,
        D3DSHADE_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    TD3DSHADEMODE = _D3DSHADEMODE;
    PD3DSHADEMODE = ^TD3DSHADEMODE;

    _D3DFILLMODE = (
        D3DFILL_POINT = 1,
        D3DFILL_WIREFRAME = 2,
        D3DFILL_SOLID = 3,
        D3DFILL_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    TD3DFILLMODE = _D3DFILLMODE;
    PD3DFILLMODE = ^TD3DFILLMODE;

    _D3DBLEND = (
        D3DBLEND_ZERO = 1,
        D3DBLEND_ONE = 2,
        D3DBLEND_SRCCOLOR = 3,
        D3DBLEND_INVSRCCOLOR = 4,
        D3DBLEND_SRCALPHA = 5,
        D3DBLEND_INVSRCALPHA = 6,
        D3DBLEND_DESTALPHA = 7,
        D3DBLEND_INVDESTALPHA = 8,
        D3DBLEND_DESTCOLOR = 9,
        D3DBLEND_INVDESTCOLOR = 10,
        D3DBLEND_SRCALPHASAT = 11,
        D3DBLEND_BOTHSRCALPHA = 12,
        D3DBLEND_BOTHINVSRCALPHA = 13,
        D3DBLEND_BLENDFACTOR = 14, (* Only supported if D3DPBLENDCAPS_BLENDFACTOR is on *)
        D3DBLEND_INVBLENDFACTOR = 15, (* Only supported if D3DPBLENDCAPS_BLENDFACTOR is on *)
        (* D3D9Ex only -- *)
        D3DBLEND_SRCCOLOR2 = 16,
        D3DBLEND_INVSRCCOLOR2 = 17,
        (* -- D3D9Ex only *)
        D3DBLEND_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    TD3DBLEND = _D3DBLEND;
    PD3DBLEND = ^TD3DBLEND;

    _D3DBLENDOP = (
        D3DBLENDOP_ADD = 1,
        D3DBLENDOP_SUBTRACT = 2,
        D3DBLENDOP_REVSUBTRACT = 3,
        D3DBLENDOP_MIN = 4,
        D3DBLENDOP_MAX = 5,
        D3DBLENDOP_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    TD3DBLENDOP = _D3DBLENDOP;
    PD3DBLENDOP = ^TD3DBLENDOP;

    _D3DTEXTUREADDRESS = (
        D3DTADDRESS_WRAP = 1,
        D3DTADDRESS_MIRROR = 2,
        D3DTADDRESS_CLAMP = 3,
        D3DTADDRESS_BORDER = 4,
        D3DTADDRESS_MIRRORONCE = 5,
        D3DTADDRESS_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    TD3DTEXTUREADDRESS = _D3DTEXTUREADDRESS;
    PD3DTEXTUREADDRESS = ^TD3DTEXTUREADDRESS;

    _D3DCULL = (
        D3DCULL_NONE = 1,
        D3DCULL_CW = 2,
        D3DCULL_CCW = 3,
        D3DCULL_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));



    TD3DCULL = _D3DCULL;
    PD3DCULL = ^TD3DCULL;

    _D3DCMPFUNC = (
        D3DCMP_NEVER = 1,
        D3DCMP_LESS = 2,
        D3DCMP_EQUAL = 3,
        D3DCMP_LESSEQUAL = 4,
        D3DCMP_GREATER = 5,
        D3DCMP_NOTEQUAL = 6,
        D3DCMP_GREATEREQUAL = 7,
        D3DCMP_ALWAYS = 8,
        D3DCMP_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));


    TD3DCMPFUNC = _D3DCMPFUNC;
    PD3DCMPFUNC = ^TD3DCMPFUNC;

    _D3DSTENCILOP = (
        D3DSTENCILOP_KEEP = 1,
        D3DSTENCILOP_ZERO = 2,
        D3DSTENCILOP_REPLACE = 3,
        D3DSTENCILOP_INCRSAT = 4,
        D3DSTENCILOP_DECRSAT = 5,
        D3DSTENCILOP_INVERT = 6,
        D3DSTENCILOP_INCR = 7,
        D3DSTENCILOP_DECR = 8,
        D3DSTENCILOP_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    TD3DSTENCILOP = _D3DSTENCILOP;
    PD3DSTENCILOP = ^TD3DSTENCILOP;

    _D3DFOGMODE = (
        D3DFOG_NONE = 0,
        D3DFOG_EXP = 1,
        D3DFOG_EXP2 = 2,
        D3DFOG_LINEAR = 3,
        D3DFOG_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    TD3DFOGMODE = _D3DFOGMODE;
    PD3DFOGMODE = ^TD3DFOGMODE;

    _D3DZBUFFERTYPE = (
        D3DZB_FALSE = 0,
        D3DZB_TRUE = 1, // Z buffering
        D3DZB_USEW = 2, // W buffering
        D3DZB_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    TD3DZBUFFERTYPE = _D3DZBUFFERTYPE;
    PD3DZBUFFERTYPE = ^TD3DZBUFFERTYPE;

    // Primitives supported by draw-primitive API
    _D3DPRIMITIVETYPE = (
        D3DPT_POINTLIST = 1,
        D3DPT_LINELIST = 2,
        D3DPT_LINESTRIP = 3,
        D3DPT_TRIANGLELIST = 4,
        D3DPT_TRIANGLESTRIP = 5,
        D3DPT_TRIANGLEFAN = 6,
        D3DPT_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));


    TD3DPRIMITIVETYPE = _D3DPRIMITIVETYPE;
    PD3DPRIMITIVETYPE = ^TD3DPRIMITIVETYPE;

    _D3DTRANSFORMSTATETYPE = (
        D3DTS_VIEW = 2,
        D3DTS_PROJECTION = 3,
        D3DTS_TEXTURE0 = 16,
        D3DTS_TEXTURE1 = 17,
        D3DTS_TEXTURE2 = 18,
        D3DTS_TEXTURE3 = 19,
        D3DTS_TEXTURE4 = 20,
        D3DTS_TEXTURE5 = 21,
        D3DTS_TEXTURE6 = 22,
        D3DTS_TEXTURE7 = 23,
        D3DTS_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));



    TD3DTRANSFORMSTATETYPE = _D3DTRANSFORMSTATETYPE;
    PD3DTRANSFORMSTATETYPE = ^TD3DTRANSFORMSTATETYPE;


    _D3DRENDERSTATETYPE = (
        D3DRS_ZENABLE = 7, (* D3DZBUFFERTYPE (or TRUE/FALSE for legacy) *)
        D3DRS_FILLMODE = 8, (* D3DFILLMODE *)
        D3DRS_SHADEMODE = 9, (* D3DSHADEMODE *)
        D3DRS_ZWRITEENABLE = 14, (* TRUE to enable z writes *)
        D3DRS_ALPHATESTENABLE = 15, (* TRUE to enable alpha tests *)
        D3DRS_LASTPIXEL = 16, (* TRUE for last-pixel on lines *)
        D3DRS_SRCBLEND = 19, (* D3DBLEND *)
        D3DRS_DESTBLEND = 20, (* D3DBLEND *)
        D3DRS_CULLMODE = 22, (* D3DCULL *)
        D3DRS_ZFUNC = 23, (* D3DCMPFUNC *)
        D3DRS_ALPHAREF = 24, (* D3DFIXED *)
        D3DRS_ALPHAFUNC = 25, (* D3DCMPFUNC *)
        D3DRS_DITHERENABLE = 26, (* TRUE to enable dithering *)
        D3DRS_ALPHABLENDENABLE = 27, (* TRUE to enable alpha blending *)
        D3DRS_FOGENABLE = 28, (* TRUE to enable fog blending *)
        D3DRS_SPECULARENABLE = 29, (* TRUE to enable specular *)
        D3DRS_FOGCOLOR = 34, (* D3DCOLOR *)
        D3DRS_FOGTABLEMODE = 35, (* D3DFOGMODE *)
        D3DRS_FOGSTART = 36, (* Fog start (for both vertex and pixel fog) *)
        D3DRS_FOGEND = 37, (* Fog end      *)
        D3DRS_FOGDENSITY = 38, (* Fog density  *)
        D3DRS_RANGEFOGENABLE = 48, (* Enables range-based fog *)
        D3DRS_STENCILENABLE = 52, (* BOOL enable/disable stenciling *)
        D3DRS_STENCILFAIL = 53, (* D3DSTENCILOP to do if stencil test fails *)
        D3DRS_STENCILZFAIL = 54, (* D3DSTENCILOP to do if stencil test passes and Z test fails *)
        D3DRS_STENCILPASS = 55, (* D3DSTENCILOP to do if both stencil and Z tests pass *)
        D3DRS_STENCILFUNC = 56, (* D3DCMPFUNC fn.  Stencil Test passes if ((ref & mask) stencilfn (stencil & mask)) is true *)
        D3DRS_STENCILREF = 57, (* Reference value used in stencil test *)
        D3DRS_STENCILMASK = 58, (* Mask value used in stencil test *)
        D3DRS_STENCILWRITEMASK = 59, (* Write mask applied to values written to stencil buffer *)
        D3DRS_TEXTUREFACTOR = 60, (* D3DCOLOR used for multi-texture blend *)
        D3DRS_WRAP0 = 128, (* wrap for 1st texture coord. set *)
        D3DRS_WRAP1 = 129, (* wrap for 2nd texture coord. set *)
        D3DRS_WRAP2 = 130, (* wrap for 3rd texture coord. set *)
        D3DRS_WRAP3 = 131, (* wrap for 4th texture coord. set *)
        D3DRS_WRAP4 = 132, (* wrap for 5th texture coord. set *)
        D3DRS_WRAP5 = 133, (* wrap for 6th texture coord. set *)
        D3DRS_WRAP6 = 134, (* wrap for 7th texture coord. set *)
        D3DRS_WRAP7 = 135, (* wrap for 8th texture coord. set *)
        D3DRS_CLIPPING = 136,
        D3DRS_LIGHTING = 137,
        D3DRS_AMBIENT = 139,
        D3DRS_FOGVERTEXMODE = 140,
        D3DRS_COLORVERTEX = 141,
        D3DRS_LOCALVIEWER = 142,
        D3DRS_NORMALIZENORMALS = 143,
        D3DRS_DIFFUSEMATERIALSOURCE = 145,
        D3DRS_SPECULARMATERIALSOURCE = 146,
        D3DRS_AMBIENTMATERIALSOURCE = 147,
        D3DRS_EMISSIVEMATERIALSOURCE = 148,
        D3DRS_VERTEXBLEND = 151,
        D3DRS_CLIPPLANEENABLE = 152,
        D3DRS_POINTSIZE = 154, (* float point size *)
        D3DRS_POINTSIZE_MIN = 155, (* float point size min threshold *)
        D3DRS_POINTSPRITEENABLE = 156, (* BOOL point texture coord control *)
        D3DRS_POINTSCALEENABLE = 157, (* BOOL point size scale enable *)
        D3DRS_POINTSCALE_A = 158, (* float point attenuation A value *)
        D3DRS_POINTSCALE_B = 159, (* float point attenuation B value *)
        D3DRS_POINTSCALE_C = 160, (* float point attenuation C value *)
        D3DRS_MULTISAMPLEANTIALIAS = 161, // BOOL - set to do FSAA with multisample buffer
        D3DRS_MULTISAMPLEMASK = 162, // DWORD - per-sample enable/disable
        D3DRS_PATCHEDGESTYLE = 163, // Sets whether patch edges will use float style tessellation
        D3DRS_DEBUGMONITORTOKEN = 165, // DEBUG ONLY - token to debug monitor
        D3DRS_POINTSIZE_MAX = 166, (* float point size max threshold *)
        D3DRS_INDEXEDVERTEXBLENDENABLE = 167,
        D3DRS_COLORWRITEENABLE = 168, // per-channel write enable
        D3DRS_TWEENFACTOR = 170, // float tween factor
        D3DRS_BLENDOP = 171, // D3DBLENDOP setting
        D3DRS_POSITIONDEGREE = 172, // NPatch position interpolation degree. D3DDEGREE_LINEAR or D3DDEGREE_CUBIC (default)
        D3DRS_NORMALDEGREE = 173, // NPatch normal interpolation degree. D3DDEGREE_LINEAR (default) or D3DDEGREE_QUADRATIC
        D3DRS_SCISSORTESTENABLE = 174,
        D3DRS_SLOPESCALEDEPTHBIAS = 175,
        D3DRS_ANTIALIASEDLINEENABLE = 176,
        D3DRS_MINTESSELLATIONLEVEL = 178,
        D3DRS_MAXTESSELLATIONLEVEL = 179,
        D3DRS_ADAPTIVETESS_X = 180,
        D3DRS_ADAPTIVETESS_Y = 181,
        D3DRS_ADAPTIVETESS_Z = 182,
        D3DRS_ADAPTIVETESS_W = 183,
        D3DRS_ENABLEADAPTIVETESSELLATION = 184,
        D3DRS_TWOSIDEDSTENCILMODE = 185, (* BOOL enable/disable 2 sided stenciling *)
        D3DRS_CCW_STENCILFAIL = 186, (* D3DSTENCILOP to do if ccw stencil test fails *)
        D3DRS_CCW_STENCILZFAIL = 187, (* D3DSTENCILOP to do if ccw stencil test passes and Z test fails *)
        D3DRS_CCW_STENCILPASS = 188, (* D3DSTENCILOP to do if both ccw stencil and Z tests pass *)
        D3DRS_CCW_STENCILFUNC = 189, (* D3DCMPFUNC fn.  ccw Stencil Test passes if ((ref & mask) stencilfn (stencil & mask)) is true *)
        D3DRS_COLORWRITEENABLE1 = 190, (* Additional ColorWriteEnables for the devices that support D3DPMISCCAPS_INDEPENDENTWRITEMASKS *)
        D3DRS_COLORWRITEENABLE2 = 191, (* Additional ColorWriteEnables for the devices that support D3DPMISCCAPS_INDEPENDENTWRITEMASKS *)
        D3DRS_COLORWRITEENABLE3 = 192, (* Additional ColorWriteEnables for the devices that support D3DPMISCCAPS_INDEPENDENTWRITEMASKS *)
        D3DRS_BLENDFACTOR = 193, (* D3DCOLOR used for a constant blend factor during alpha blending for devices that support D3DPBLENDCAPS_BLENDFACTOR *)
        D3DRS_SRGBWRITEENABLE = 194, (* Enable rendertarget writes to be DE-linearized to SRGB (for formats that expose D3DUSAGE_QUERY_SRGBWRITE) *)
        D3DRS_DEPTHBIAS = 195,
        D3DRS_WRAP8 = 198, (* Additional wrap states for vs_3_0+ attributes with D3DDECLUSAGE_TEXCOORD *)
        D3DRS_WRAP9 = 199,
        D3DRS_WRAP10 = 200,
        D3DRS_WRAP11 = 201,
        D3DRS_WRAP12 = 202,
        D3DRS_WRAP13 = 203,
        D3DRS_WRAP14 = 204,
        D3DRS_WRAP15 = 205,
        D3DRS_SEPARATEALPHABLENDENABLE = 206, (* TRUE to enable a separate blending function for the alpha channel *)
        D3DRS_SRCBLENDALPHA = 207, (* SRC blend factor for the alpha channel when D3DRS_SEPARATEDESTALPHAENABLE is TRUE *)
        D3DRS_DESTBLENDALPHA = 208, (* DST blend factor for the alpha channel when D3DRS_SEPARATEDESTALPHAENABLE is TRUE *)
        D3DRS_BLENDOPALPHA = 209, (* Blending operation for the alpha channel when D3DRS_SEPARATEDESTALPHAENABLE is TRUE *)
        D3DRS_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    TD3DRENDERSTATETYPE = _D3DRENDERSTATETYPE;
    PD3DRENDERSTATETYPE = ^TD3DRENDERSTATETYPE;




    // Values for material source
    _D3DMATERIALCOLORSOURCE = (
        D3DMCS_MATERIAL = 0, // Color from material is used
        D3DMCS_COLOR1 = 1, // Diffuse vertex color is used
        D3DMCS_COLOR2 = 2, // Specular vertex color is used
        D3DMCS_FORCE_DWORD = $7fffffff// force 32-bit size enum
        );

    TD3DMATERIALCOLORSOURCE = _D3DMATERIALCOLORSOURCE;
    PD3DMATERIALCOLORSOURCE = ^TD3DMATERIALCOLORSOURCE;


(*
 * State enumerants for per-stage processing of fixed function pixel processing
 * Two of these affect fixed function vertex processing as well: TEXTURETRANSFORMFLAGS and TEXCOORDINDEX.
 *)
    _D3DTEXTURESTAGESTATETYPE = (
        D3DTSS_COLOROP = 1, (* D3DTEXTUREOP - per-stage blending controls for color channels *)
        D3DTSS_COLORARG1 = 2, (* D3DTA_* (texture arg) *)
        D3DTSS_COLORARG2 = 3, (* D3DTA_* (texture arg) *)
        D3DTSS_ALPHAOP = 4, (* D3DTEXTUREOP - per-stage blending controls for alpha channel *)
        D3DTSS_ALPHAARG1 = 5, (* D3DTA_* (texture arg) *)
        D3DTSS_ALPHAARG2 = 6, (* D3DTA_* (texture arg) *)
        D3DTSS_BUMPENVMAT00 = 7, (* float (bump mapping matrix) *)
        D3DTSS_BUMPENVMAT01 = 8, (* float (bump mapping matrix) *)
        D3DTSS_BUMPENVMAT10 = 9, (* float (bump mapping matrix) *)
        D3DTSS_BUMPENVMAT11 = 10, (* float (bump mapping matrix) *)
        D3DTSS_TEXCOORDINDEX = 11, (* identifies which set of texture coordinates index this texture *)
        D3DTSS_BUMPENVLSCALE = 22, (* float scale for bump map luminance *)
        D3DTSS_BUMPENVLOFFSET = 23, (* float offset for bump map luminance *)
        D3DTSS_TEXTURETRANSFORMFLAGS = 24, (* D3DTEXTURETRANSFORMFLAGS controls texture transform *)
        D3DTSS_COLORARG0 = 26, (* D3DTA_* third arg for triadic ops *)
        D3DTSS_ALPHAARG0 = 27, (* D3DTA_* third arg for triadic ops *)
        D3DTSS_RESULTARG = 28, (* D3DTA_* arg for result (CURRENT or TEMP) *)
        D3DTSS_CONSTANT = 32, (* Per-stage constant D3DTA_CONSTANT *)
        D3DTSS_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    TD3DTEXTURESTAGESTATETYPE = _D3DTEXTURESTAGESTATETYPE;
    PD3DTEXTURESTAGESTATETYPE = ^TD3DTEXTURESTAGESTATETYPE;

(*
 * State enumerants for per-sampler texture processing.
 *)
    _D3DSAMPLERSTATETYPE = (
        D3DSAMP_ADDRESSU = 1, (* D3DTEXTUREADDRESS for U coordinate *)
        D3DSAMP_ADDRESSV = 2, (* D3DTEXTUREADDRESS for V coordinate *)
        D3DSAMP_ADDRESSW = 3, (* D3DTEXTUREADDRESS for W coordinate *)
        D3DSAMP_BORDERCOLOR = 4, (* D3DCOLOR *)
        D3DSAMP_MAGFILTER = 5, (* D3DTEXTUREFILTER filter to use for magnification *)
        D3DSAMP_MINFILTER = 6, (* D3DTEXTUREFILTER filter to use for minification *)
        D3DSAMP_MIPFILTER = 7, (* D3DTEXTUREFILTER filter to use between mipmaps during minification *)
        D3DSAMP_MIPMAPLODBIAS = 8, (* float Mipmap LOD bias *)
        D3DSAMP_MAXMIPLEVEL = 9, (* DWORD 0..(n-1) LOD index of largest map to use (0 == largest) *)
        D3DSAMP_MAXANISOTROPY = 10, (* DWORD maximum anisotropy *)
        D3DSAMP_SRGBTEXTURE = 11, (* Default = 0 (which means Gamma 1.0,
                                   no correction required.) else correct for
                                   Gamma = 2.2 *)
        D3DSAMP_ELEMENTINDEX = 12, (* When multi-element texture is assigned to sampler, this
                                    indicates which element index to use.  Default = 0.  *)
        D3DSAMP_DMAPOFFSET = 13, (* Offset in vertices in the pre-sampled displacement map.
                                    Only valid for D3DDMAPSAMPLER sampler  *)
        D3DSAMP_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    TD3DSAMPLERSTATETYPE = _D3DSAMPLERSTATETYPE;
    PD3DSAMPLERSTATETYPE = ^TD3DSAMPLERSTATETYPE;


(*
 * Enumerations for COLOROP and ALPHAOP texture blending operations set in
 * texture processing stage controls in D3DTSS.
 *)
    _D3DTEXTUREOP = (
        // Control
        D3DTOP_DISABLE = 1, // disables stage
        D3DTOP_SELECTARG1 = 2, // the default
        D3DTOP_SELECTARG2 = 3,
        // Modulate
        D3DTOP_MODULATE = 4, // multiply args together
        D3DTOP_MODULATE2X = 5, // multiply and  1 bit
        D3DTOP_MODULATE4X = 6, // multiply and  2 bits
        // Add
        D3DTOP_ADD = 7, // add arguments together
        D3DTOP_ADDSIGNED = 8, // add with -0.5 bias
        D3DTOP_ADDSIGNED2X = 9, // as above but left  1 bit
        D3DTOP_SUBTRACT = 10, // Arg1 - Arg2, with no saturation
        D3DTOP_ADDSMOOTH = 11, // add 2 args, subtract product
        // Arg1 + Arg2 - Arg1*Arg2
        // = Arg1 + (1-Arg1)*Arg2
        // Linear alpha blend: Arg1*(Alpha) + Arg2*(1-Alpha)
        D3DTOP_BLENDDIFFUSEALPHA = 12, // iterated alpha
        D3DTOP_BLENDTEXTUREALPHA = 13, // texture alpha
        D3DTOP_BLENDFACTORALPHA = 14, // alpha from D3DRS_TEXTUREFACTOR
        // Linear alpha blend with pre-multiplied arg1 input: Arg1 + Arg2*(1-Alpha)
        D3DTOP_BLENDTEXTUREALPHAPM = 15, // texture alpha
        D3DTOP_BLENDCURRENTALPHA = 16, // by alpha of current color
        // Specular mapping
        D3DTOP_PREMODULATE = 17, // modulate with next texture before use
        D3DTOP_MODULATEALPHA_ADDCOLOR = 18, // Arg1.RGB + Arg1.A*Arg2.RGB
        // COLOROP only
        D3DTOP_MODULATECOLOR_ADDALPHA = 19, // Arg1.RGB*Arg2.RGB + Arg1.A
        // COLOROP only
        D3DTOP_MODULATEINVALPHA_ADDCOLOR = 20, // (1-Arg1.A)*Arg2.RGB + Arg1.RGB
        // COLOROP only
        D3DTOP_MODULATEINVCOLOR_ADDALPHA = 21, // (1-Arg1.RGB)*Arg2.RGB + Arg1.A
        // COLOROP only
        // Bump mapping
        D3DTOP_BUMPENVMAP = 22, // per pixel env map perturbation
        D3DTOP_BUMPENVMAPLUMINANCE = 23, // with luminance channel
        // This can do either diffuse or specular bump mapping with correct input.
        // Performs the function (Arg1.R*Arg2.R + Arg1.G*Arg2.G + Arg1.B*Arg2.B)
        // where each component has been scaled and offset to make it signed.
        // The result is replicated into all four (including alpha) channels.
        // This is a valid COLOROP only.
        D3DTOP_DOTPRODUCT3 = 24,
        // Triadic ops
        D3DTOP_MULTIPLYADD = 25, // Arg0 + Arg1*Arg2
        D3DTOP_LERP = 26, // (Arg0)*Arg1 + (1-Arg0)*Arg2
        D3DTOP_FORCE_DWORD = $7fffffff);

    TD3DTEXTUREOP = _D3DTEXTUREOP;
    PD3DTEXTUREOP = ^TD3DTEXTUREOP;




    // Values for D3DSAMP_***FILTER texture stage states

    _D3DTEXTUREFILTERTYPE = (
        D3DTEXF_NONE = 0, // filtering disabled (valid for mip filter only)
        D3DTEXF_POINT = 1, // nearest
        D3DTEXF_LINEAR = 2, // linear interpolation
        D3DTEXF_ANISOTROPIC = 3, // anisotropic
        D3DTEXF_PYRAMIDALQUAD = 6, // 4-sample tent
        D3DTEXF_GAUSSIANQUAD = 7, // 4-sample gaussian
        (* D3D9Ex only -- *)
        D3DTEXF_CONVOLUTIONMONO = 8, // Convolution filter for monochrome textures
        (* -- D3D9Ex only *)
        D3DTEXF_FORCE_DWORD = $7fffffff// force 32-bit size enum
        );



    TD3DTEXTUREFILTERTYPE = _D3DTEXTUREFILTERTYPE;
    PD3DTEXTUREFILTERTYPE = ^TD3DTEXTUREFILTERTYPE;


    //---------------------------------------------------------------------
    // Vertex Shaders

    // Vertex shader declaration
    // Vertex element semantics



    _D3DDECLUSAGE = (
        D3DDECLUSAGE_POSITION = 0,
        D3DDECLUSAGE_BLENDWEIGHT, // 1
        D3DDECLUSAGE_BLENDINDICES, // 2
        D3DDECLUSAGE_NORMAL, // 3
        D3DDECLUSAGE_PSIZE, // 4
        D3DDECLUSAGE_TEXCOORD, // 5
        D3DDECLUSAGE_TANGENT, // 6
        D3DDECLUSAGE_BINORMAL, // 7
        D3DDECLUSAGE_TESSFACTOR, // 8
        D3DDECLUSAGE_POSITIONT, // 9
        D3DDECLUSAGE_COLOR, // 10
        D3DDECLUSAGE_FOG, // 11
        D3DDECLUSAGE_DEPTH, // 12
        D3DDECLUSAGE_SAMPLE// 13
        );



    TD3DDECLUSAGE = _D3DDECLUSAGE;
    PD3DDECLUSAGE = ^TD3DDECLUSAGE;



    _D3DDECLMETHOD = (
        D3DDECLMETHOD_DEFAULT = 0,
        D3DDECLMETHOD_PARTIALU,
        D3DDECLMETHOD_PARTIALV,
        D3DDECLMETHOD_CROSSUV, // Normal
        D3DDECLMETHOD_UV,
        D3DDECLMETHOD_LOOKUP, // Lookup a displacement map
        D3DDECLMETHOD_LOOKUPPRESAMPLED// Lookup a pre-sampled displacement map
        );

    TD3DDECLMETHOD = _D3DDECLMETHOD;
    PD3DDECLMETHOD = ^TD3DDECLMETHOD;



    // Declarations for _Type fields

    _D3DDECLTYPE = (
        D3DDECLTYPE_FLOAT1 = 0, // 1D float expanded to (value, 0., 0., 1.)
        D3DDECLTYPE_FLOAT2 = 1, // 2D float expanded to (value, value, 0., 1.)
        D3DDECLTYPE_FLOAT3 = 2, // 3D float expanded to (value, value, value, 1.)
        D3DDECLTYPE_FLOAT4 = 3, // 4D float
        D3DDECLTYPE_D3DCOLOR = 4, // 4D packed unsigned bytes mapped to 0. to 1. range
        // Input is in D3DCOLOR format (ARGB) expanded to (R, G, B, A)
        D3DDECLTYPE_UBYTE4 = 5, // 4D unsigned byte
        D3DDECLTYPE_SHORT2 = 6, // 2D signed short expanded to (value, value, 0., 1.)
        D3DDECLTYPE_SHORT4 = 7, // 4D signed short
        // The following types are valid only with vertex shaders >= 2.0
        D3DDECLTYPE_UBYTE4N = 8, // Each of 4 bytes is normalized by dividing to 255.0
        D3DDECLTYPE_SHORT2N = 9, // 2D signed short normalized (v[0]/32767.0,v[1]/32767.0,0,1)
        D3DDECLTYPE_SHORT4N = 10, // 4D signed short normalized (v[0]/32767.0,v[1]/32767.0,v[2]/32767.0,v[3]/32767.0)
        D3DDECLTYPE_USHORT2N = 11, // 2D unsigned short normalized (v[0]/65535.0,v[1]/65535.0,0,1)
        D3DDECLTYPE_USHORT4N = 12, // 4D unsigned short normalized (v[0]/65535.0,v[1]/65535.0,v[2]/65535.0,v[3]/65535.0)
        D3DDECLTYPE_UDEC3 = 13, // 3D unsigned 10 10 10 format expanded to (value, value, value, 1)
        D3DDECLTYPE_DEC3N = 14, // 3D signed 10 10 10 format normalized and expanded to (v[0]/511.0, v[1]/511.0, v[2]/511.0, 1)
        D3DDECLTYPE_FLOAT16_2 = 15, // Two 16-bit floating point values, expanded to (value, value, 0, 1)
        D3DDECLTYPE_FLOAT16_4 = 16, // Four 16-bit floating point values
        D3DDECLTYPE_UNUSED = 17// When the type field in a decl is unused.
        );

    TD3DDECLTYPE = _D3DDECLTYPE;
    PD3DDECLTYPE = ^TD3DDECLTYPE;


    _D3DVERTEXELEMENT9 = record
        Stream: word; // Stream index
        Offset: word; // Offset in the stream in bytes
        DataType: TBYTE; // Data type
        Method: TBYTE; // Processing method
        Usage: TBYTE; // Semantics
        UsageIndex: TBYTE; // Semantic index
    end;


    TD3DVERTEXELEMENT9 = _D3DVERTEXELEMENT9;
    PD3DVERTEXELEMENT9 = ^TD3DVERTEXELEMENT9;
    LPD3DVERTEXELEMENT9 = ^TD3DVERTEXELEMENT9;


    // Instruction Token Bit Definitions


    _D3DSHADER_INSTRUCTION_OPCODE_TYPE = (
        D3DSIO_NOP = 0,
        D3DSIO_MOV,
        D3DSIO_ADD,
        D3DSIO_SUB,
        D3DSIO_MAD,
        D3DSIO_MUL,
        D3DSIO_RCP,
        D3DSIO_RSQ,
        D3DSIO_DP3,
        D3DSIO_DP4,
        D3DSIO_MIN,
        D3DSIO_MAX,
        D3DSIO_SLT,
        D3DSIO_SGE,
        D3DSIO_EXP,
        D3DSIO_LOG,
        D3DSIO_LIT,
        D3DSIO_DST,
        D3DSIO_LRP,
        D3DSIO_FRC,
        D3DSIO_M4x4,
        D3DSIO_M4x3,
        D3DSIO_M3x4,
        D3DSIO_M3x3,
        D3DSIO_M3x2,
        D3DSIO_CALL,
        D3DSIO_CALLNZ,
        D3DSIO_LOOP,
        D3DSIO_RET,
        D3DSIO_ENDLOOP,
        D3DSIO_LABEL,
        D3DSIO_DCL,
        D3DSIO_POW,
        D3DSIO_CRS,
        D3DSIO_SGN,
        D3DSIO_ABS,
        D3DSIO_NRM,
        D3DSIO_SINCOS,
        D3DSIO_REP,
        D3DSIO_ENDREP,
        D3DSIO_IF,
        D3DSIO_IFC,
        D3DSIO_ELSE,
        D3DSIO_ENDIF,
        D3DSIO_BREAK,
        D3DSIO_BREAKC,
        D3DSIO_MOVA,
        D3DSIO_DEFB,
        D3DSIO_DEFI,
        D3DSIO_TEXCOORD = 64,
        D3DSIO_TEXKILL,
        D3DSIO_TEX,
        D3DSIO_TEXBEM,
        D3DSIO_TEXBEML,
        D3DSIO_TEXREG2AR,
        D3DSIO_TEXREG2GB,
        D3DSIO_TEXM3x2PAD,
        D3DSIO_TEXM3x2TEX,
        D3DSIO_TEXM3x3PAD,
        D3DSIO_TEXM3x3TEX,
        D3DSIO_RESERVED0,
        D3DSIO_TEXM3x3SPEC,
        D3DSIO_TEXM3x3VSPEC,
        D3DSIO_EXPP,
        D3DSIO_LOGP,
        D3DSIO_CND,
        D3DSIO_DEF,
        D3DSIO_TEXREG2RGB,
        D3DSIO_TEXDP3TEX,
        D3DSIO_TEXM3x2DEPTH,
        D3DSIO_TEXDP3,
        D3DSIO_TEXM3x3,
        D3DSIO_TEXDEPTH,
        D3DSIO_CMP,
        D3DSIO_BEM,
        D3DSIO_DP2ADD,
        D3DSIO_DSX,
        D3DSIO_DSY,
        D3DSIO_TEXLDD,
        D3DSIO_SETP,
        D3DSIO_TEXLDL,
        D3DSIO_BREAKP,
        D3DSIO_PHASE = $FFFD,
        D3DSIO_COMMENT = $FFFE,
        D3DSIO_END = $FFFF,
        D3DSIO_FORCE_DWORD = $7fffffff// force 32-bit size enum
        );


    TD3DSHADER_INSTRUCTION_OPCODE_TYPE = _D3DSHADER_INSTRUCTION_OPCODE_TYPE;
    PD3DSHADER_INSTRUCTION_OPCODE_TYPE = ^TD3DSHADER_INSTRUCTION_OPCODE_TYPE;



    // Comparison for dynamic conditional instruction opcodes (i.e. if, breakc)
    _D3DSHADER_COMPARISON = (
        // < = >
        D3DSPC_RESERVED0 = 0, // 0 0 0
        D3DSPC_GT = 1, // 0 0 1
        D3DSPC_EQ = 2, // 0 1 0
        D3DSPC_GE = 3, // 0 1 1
        D3DSPC_LT = 4, // 1 0 0
        D3DSPC_NE = 5, // 1 0 1
        D3DSPC_LE = 6, // 1 1 0
        D3DSPC_RESERVED1 = 7// 1 1 1
        );

    TD3DSHADER_COMPARISON = _D3DSHADER_COMPARISON;
    PD3DSHADER_COMPARISON = ^TD3DSHADER_COMPARISON;


    _D3DSAMPLER_TEXTURE_TYPE = (
        D3DSTT_UNKNOWN = 0 shl Ord(D3DSP_TEXTURETYPE_SHIFT), // uninitialized value
        D3DSTT_2D = 2 shl Ord(D3DSP_TEXTURETYPE_SHIFT), // dcl_2d s# (for declaring a 2-D texture)
        D3DSTT_CUBE = 3 shl Ord(D3DSP_TEXTURETYPE_SHIFT), // dcl_cube s# (for declaring a cube texture)
        D3DSTT_VOLUME = 4 shl Ord(D3DSP_TEXTURETYPE_SHIFT), // dcl_volume s# (for declaring a volume texture)
        D3DSTT_FORCE_DWORD = $7fffffff// force 32-bit size enum
        );

    TD3DSAMPLER_TEXTURE_TYPE = _D3DSAMPLER_TEXTURE_TYPE;
    PD3DSAMPLER_TEXTURE_TYPE = ^TD3DSAMPLER_TEXTURE_TYPE;


    _D3DSHADER_PARAM_REGISTER_TYPE = (
        D3DSPR_TEMP = 0, // Temporary Register File
        D3DSPR_INPUT = 1, // Input Register File
        D3DSPR_CONST = 2, // Constant Register File
        D3DSPR_ADDR = 3, // Address Register (VS)
        D3DSPR_TEXTURE = 3, // Texture Register File (PS)
        D3DSPR_RASTOUT = 4, // Rasterizer Register File
        D3DSPR_ATTROUT = 5, // Attribute Output Register File
        D3DSPR_TEXCRDOUT = 6, // Texture Coordinate Output Register File
        D3DSPR_OUTPUT = 6, // Output register file for VS3.0+
        D3DSPR_CONSTINT = 7, // Constant Integer Vector Register File
        D3DSPR_COLOROUT = 8, // Color Output Register File
        D3DSPR_DEPTHOUT = 9, // Depth Output Register File
        D3DSPR_SAMPLER = 10, // Sampler State Register File
        D3DSPR_CONST2 = 11, // Constant Register File  2048 - 4095
        D3DSPR_CONST3 = 12, // Constant Register File  4096 - 6143
        D3DSPR_CONST4 = 13, // Constant Register File  6144 - 8191
        D3DSPR_CONSTBOOL = 14, // Constant Boolean register file
        D3DSPR_LOOP = 15, // Loop counter register file
        D3DSPR_TEMPFLOAT16 = 16, // 16-bit float temp register file
        D3DSPR_MISCTYPE = 17, // Miscellaneous (single) registers.
        D3DSPR_LABEL = 18, // Label
        D3DSPR_PREDICATE = 19, // Predicate register
        D3DSPR_FORCE_DWORD = $7fffffff// force 32-bit size enum
        );

    TD3DSHADER_PARAM_REGISTER_TYPE = _D3DSHADER_PARAM_REGISTER_TYPE;
    PD3DSHADER_PARAM_REGISTER_TYPE = ^TD3DSHADER_PARAM_REGISTER_TYPE;




    // The miscellaneous register file (D3DSPR_MISCTYPES)
    // contains register types for which there is only ever one
    // register (i.e. the register # is not needed).
    // Rather than use up additional register types for such
    // registers, they are defined
    // as particular offsets into the misc. register file:
    _D3DSHADER_MISCTYPE_OFFSETS = (
        D3DSMO_POSITION = 0, // Input position x,y,z,rhw (PS)
        D3DSMO_FACE = 1// Floating point primitive area (PS)
        );

    TD3DSHADER_MISCTYPE_OFFSETS = _D3DSHADER_MISCTYPE_OFFSETS;
    PD3DSHADER_MISCTYPE_OFFSETS = ^TD3DSHADER_MISCTYPE_OFFSETS;

    // Register offsets in the Rasterizer Register File

    _D3DVS_RASTOUT_OFFSETS = (
        D3DSRO_POSITION = 0,
        D3DSRO_FOG,
        D3DSRO_POINT_SIZE,
        D3DSRO_FORCE_DWORD = $7fffffff// force 32-bit size enum
        );

    TD3DVS_RASTOUT_OFFSETS = _D3DVS_RASTOUT_OFFSETS;
    PD3DVS_RASTOUT_OFFSETS = ^TD3DVS_RASTOUT_OFFSETS;

    // Source operand addressing modes
    _D3DVS_ADDRESSMODE_TYPE = (
        D3DVS_ADDRMODE_ABSOLUTE = (0 shl D3DVS_ADDRESSMODE_SHIFT),
        D3DVS_ADDRMODE_RELATIVE = (1 shl D3DVS_ADDRESSMODE_SHIFT),
        D3DVS_ADDRMODE_FORCE_DWORD = $7fffffff// force 32-bit size enum
        );

    TD3DVS_ADDRESSMODE_TYPE = _D3DVS_ADDRESSMODE_TYPE;
    PD3DVS_ADDRESSMODE_TYPE = ^TD3DVS_ADDRESSMODE_TYPE;


    _D3DSHADER_ADDRESSMODE_TYPE = (
        D3DSHADER_ADDRMODE_ABSOLUTE = (0 shl D3DSHADER_ADDRESSMODE_SHIFT),
        D3DSHADER_ADDRMODE_RELATIVE = (1 shl D3DSHADER_ADDRESSMODE_SHIFT),
        D3DSHADER_ADDRMODE_FORCE_DWORD = $7fffffff// force 32-bit size enum
        );



    TD3DSHADER_ADDRESSMODE_TYPE = _D3DSHADER_ADDRESSMODE_TYPE;
    PD3DSHADER_ADDRESSMODE_TYPE = ^TD3DSHADER_ADDRESSMODE_TYPE;




    _D3DSHADER_PARAM_SRCMOD_TYPE = (
        D3DSPSM_NONE = 0 shl D3DSP_SRCMOD_SHIFT, // nop
        D3DSPSM_NEG = 1 shl D3DSP_SRCMOD_SHIFT, // negate
        D3DSPSM_BIAS = 2 shl D3DSP_SRCMOD_SHIFT, // bias
        D3DSPSM_BIASNEG = 3 shl D3DSP_SRCMOD_SHIFT, // bias and negate
        D3DSPSM_SIGN = 4 shl D3DSP_SRCMOD_SHIFT, // sign
        D3DSPSM_SIGNNEG = 5 shl D3DSP_SRCMOD_SHIFT, // sign and negate
        D3DSPSM_COMP = 6 shl D3DSP_SRCMOD_SHIFT, // complement
        D3DSPSM_X2 = 7 shl D3DSP_SRCMOD_SHIFT, // *2
        D3DSPSM_X2NEG = 8 shl D3DSP_SRCMOD_SHIFT, // *2 and negate
        D3DSPSM_DZ = 9 shl D3DSP_SRCMOD_SHIFT, // divide through by z component
        D3DSPSM_DW = 10 shl D3DSP_SRCMOD_SHIFT, // divide through by w component
        D3DSPSM_ABS = 11 shl D3DSP_SRCMOD_SHIFT, // abs()
        D3DSPSM_ABSNEG = 12 shl D3DSP_SRCMOD_SHIFT, // -abs()
        D3DSPSM_NOT = 13 shl D3DSP_SRCMOD_SHIFT, // for predicate register: "!p0"
        D3DSPSM_FORCE_DWORD = $7fffffff// force 32-bit size enum
        );



    TD3DSHADER_PARAM_SRCMOD_TYPE = _D3DSHADER_PARAM_SRCMOD_TYPE;
    PD3DSHADER_PARAM_SRCMOD_TYPE = ^TD3DSHADER_PARAM_SRCMOD_TYPE;


    _D3DSHADER_MIN_PRECISION = (
        D3DMP_DEFAULT = 0, // Default precision for the shader model
        D3DMP_16 = 1, // 16 bit per component
        D3DMP_2_8 = 2// 10 bits (2.8) per component
        );

    TD3DSHADER_MIN_PRECISION = _D3DSHADER_MIN_PRECISION;
    PD3DSHADER_MIN_PRECISION = ^TD3DSHADER_MIN_PRECISION;



    //---------------------------------------------------------------------
    // High order surfaces


    _D3DBASISTYPE = (
        D3DBASIS_BEZIER = 0,
        D3DBASIS_BSPLINE = 1,
        D3DBASIS_CATMULL_ROM = 2, (* In D3D8 this used to be D3DBASIS_INTERPOLATE *)
        D3DBASIS_FORCE_DWORD = $7fffffff);



    TD3DBASISTYPE = _D3DBASISTYPE;
    PD3DBASISTYPE = ^TD3DBASISTYPE;

    _D3DDEGREETYPE = (
        D3DDEGREE_LINEAR = 1,
        D3DDEGREE_QUADRATIC = 2,
        D3DDEGREE_CUBIC = 3,
        D3DDEGREE_QUINTIC = 5,
        D3DDEGREE_FORCE_DWORD = $7fffffff);

    TD3DDEGREETYPE = _D3DDEGREETYPE;
    PD3DDEGREETYPE = ^TD3DDEGREETYPE;

    _D3DPATCHEDGESTYLE = (
        D3DPATCHEDGE_DISCRETE = 0,
        D3DPATCHEDGE_CONTINUOUS = 1,
        D3DPATCHEDGE_FORCE_DWORD = $7fffffff);

    TD3DPATCHEDGESTYLE = _D3DPATCHEDGESTYLE;
    PD3DPATCHEDGESTYLE = ^TD3DPATCHEDGESTYLE;

    _D3DSTATEBLOCKTYPE = (
        D3DSBT_ALL = 1, // capture all state
        D3DSBT_PIXELSTATE = 2, // capture pixel state
        D3DSBT_VERTEXSTATE = 3, // capture vertex state
        D3DSBT_FORCE_DWORD = $7fffffff);



    TD3DSTATEBLOCKTYPE = _D3DSTATEBLOCKTYPE;
    PD3DSTATEBLOCKTYPE = ^TD3DSTATEBLOCKTYPE;

    // The D3DVERTEXBLENDFLAGS type is used with D3DRS_VERTEXBLEND state.

    _D3DVERTEXBLENDFLAGS = (
        D3DVBF_DISABLE = 0, // Disable vertex blending
        D3DVBF_1WEIGHTS = 1, // 2 matrix blending
        D3DVBF_2WEIGHTS = 2, // 3 matrix blending
        D3DVBF_3WEIGHTS = 3, // 4 matrix blending
        D3DVBF_TWEENING = 255, // blending using D3DRS_TWEENFACTOR
        D3DVBF_0WEIGHTS = 256, // one matrix is used with weight 1.0
        D3DVBF_FORCE_DWORD = $7fffffff// force 32-bit size enum
        );

    TD3DVERTEXBLENDFLAGS = _D3DVERTEXBLENDFLAGS;
    PD3DVERTEXBLENDFLAGS = ^TD3DVERTEXBLENDFLAGS;

    _D3DTEXTURETRANSFORMFLAGS = (
        D3DTTFF_DISABLE = 0, // texture coordinates are passed directly
        D3DTTFF_COUNT1 = 1, // rasterizer should expect 1-D texture coords
        D3DTTFF_COUNT2 = 2, // rasterizer should expect 2-D texture coords
        D3DTTFF_COUNT3 = 3, // rasterizer should expect 3-D texture coords
        D3DTTFF_COUNT4 = 4, // rasterizer should expect 4-D texture coords
        D3DTTFF_PROJECTED = 256, // texcoords to be divided by COUNTth element
        D3DTTFF_FORCE_DWORD = $7fffffff);



    TD3DTEXTURETRANSFORMFLAGS = _D3DTEXTURETRANSFORMFLAGS;
    PD3DTEXTURETRANSFORMFLAGS = ^TD3DTEXTURETRANSFORMFLAGS;



    //---------------------------------------------------------------------
    (* Direct3D9 Device types *)

    _D3DDEVTYPE = (
        D3DDEVTYPE_HAL = 1,
        D3DDEVTYPE_REF = 2,
        D3DDEVTYPE_SW = 3,
        D3DDEVTYPE_NULLREF = 4,
        D3DDEVTYPE_FORCE_DWORD = $7fffffff);

    TD3DDEVTYPE = _D3DDEVTYPE;
    PD3DDEVTYPE = ^TD3DDEVTYPE;

    (* Multi-Sample buffer types *)
    _D3DMULTISAMPLE_TYPE = (
        D3DMULTISAMPLE_NONE = 0,
        D3DMULTISAMPLE_NONMASKABLE = 1,
        D3DMULTISAMPLE_2_SAMPLES = 2,
        D3DMULTISAMPLE_3_SAMPLES = 3,
        D3DMULTISAMPLE_4_SAMPLES = 4,
        D3DMULTISAMPLE_5_SAMPLES = 5,
        D3DMULTISAMPLE_6_SAMPLES = 6,
        D3DMULTISAMPLE_7_SAMPLES = 7,
        D3DMULTISAMPLE_8_SAMPLES = 8,
        D3DMULTISAMPLE_9_SAMPLES = 9,
        D3DMULTISAMPLE_10_SAMPLES = 10,
        D3DMULTISAMPLE_11_SAMPLES = 11,
        D3DMULTISAMPLE_12_SAMPLES = 12,
        D3DMULTISAMPLE_13_SAMPLES = 13,
        D3DMULTISAMPLE_14_SAMPLES = 14,
        D3DMULTISAMPLE_15_SAMPLES = 15,
        D3DMULTISAMPLE_16_SAMPLES = 16,
        D3DMULTISAMPLE_FORCE_DWORD = $7fffffff);



    TD3DMULTISAMPLE_TYPE = _D3DMULTISAMPLE_TYPE;
    PD3DMULTISAMPLE_TYPE = ^TD3DMULTISAMPLE_TYPE;


    (* Formats
 * Most of these names have the following convention:
 *      A = Alpha
 *      R = Red
 *      G = Green
 *      B = Blue
 *      X = Unused Bits
 *      P = Palette
 *      L = Luminance
 *      U = dU coordinate for BumpMap
 *      V = dV coordinate for BumpMap
 *      S = Stencil
 *      D = Depth (e.g. Z or W buffer)
 *      C = Computed from other channels (typically on certain read operations)
 *
 *      Further, the order of the pieces are from MSB first; hence
 *      D3DFMT_A8L8 indicates that the high byte of this two byte
 *      format is alpha.
 *
 *      D3DFMT_D16_LOCKABLE indicates:
 *           - An integer 16-bit value.
 *           - An app-lockable surface.
 *
 *      D3DFMT_D32F_LOCKABLE indicates:
 *           - An IEEE 754 floating-point value.
 *           - An app-lockable surface.
 *
 *      All Depth/Stencil formats except D3DFMT_D16_LOCKABLE and D3DFMT_D32F_LOCKABLE indicate:
 *          - no particular bit ordering per pixel, and
 *          - are not app lockable, and
 *          - the driver is allowed to consume more than the indicated
 *            number of bits per Depth channel (but not Stencil channel).
 *)


    _D3DFORMAT = (
        D3DFMT_UNKNOWN = 0,
        D3DFMT_R8G8B8 = 20,
        D3DFMT_A8R8G8B8 = 21,
        D3DFMT_X8R8G8B8 = 22,
        D3DFMT_R5G6B5 = 23,
        D3DFMT_X1R5G5B5 = 24,
        D3DFMT_A1R5G5B5 = 25,
        D3DFMT_A4R4G4B4 = 26,
        D3DFMT_R3G3B2 = 27,
        D3DFMT_A8 = 28,
        D3DFMT_A8R3G3B2 = 29,
        D3DFMT_X4R4G4B4 = 30,
        D3DFMT_A2B10G10R10 = 31,
        D3DFMT_A8B8G8R8 = 32,
        D3DFMT_X8B8G8R8 = 33,
        D3DFMT_G16R16 = 34,
        D3DFMT_A2R10G10B10 = 35,
        D3DFMT_A16B16G16R16 = 36,
        D3DFMT_A8P8 = 40,
        D3DFMT_P8 = 41,
        D3DFMT_L8 = 50,
        D3DFMT_A8L8 = 51,
        D3DFMT_A4L4 = 52,
        D3DFMT_V8U8 = 60,
        D3DFMT_L6V5U5 = 61,
        D3DFMT_X8L8V8U8 = 62,
        D3DFMT_Q8W8V8U8 = 63,
        D3DFMT_V16U16 = 64,
        D3DFMT_A2W10V10U10 = 67,
        D3DFMT_UYVY = (Ord('U') or (Ord('Y') shl 8) or (Ord('V') shl 16) or (Ord('Y') shl 24)),
        D3DFMT_R8G8_B8G8 = (Ord('R') or (Ord('G') shl 8) or (Ord('B') shl 16) or (Ord('G') shl 24)),
        D3DFMT_YUY2 = (Ord('Y') or (Ord('U') shl 8) or (Ord('Y') shl 16) or (Ord('2') shl 24)),
        D3DFMT_G8R8_G8B8 = (Ord('G') or (Ord('R') shl 8) or (Ord('G') shl 16) or (Ord('B') shl 24)),
        D3DFMT_DXT1 = (Ord('D') or (Ord('X') shl 8) or (Ord('T') shl 16) or (Ord('1') shl 24)),
        D3DFMT_DXT2 = (Ord('D') or (Ord('X') shl 8) or (Ord('T') shl 16) or (Ord('2') shl 24)),
        D3DFMT_DXT3 = (Ord('D') or (Ord('X') shl 8) or (Ord('T') shl 16) or (Ord('3') shl 24)),
        D3DFMT_DXT4 = (Ord('D') or (Ord('X') shl 8) or (Ord('T') shl 16) or (Ord('4') shl 24)),
        D3DFMT_DXT5 = (Ord('D') or (Ord('X') shl 8) or (Ord('T') shl 16) or (Ord('5') shl 24)),
        D3DFMT_D16_LOCKABLE = 70,
        D3DFMT_D32 = 71,
        D3DFMT_D15S1 = 73,
        D3DFMT_D24S8 = 75,
        D3DFMT_D24X8 = 77,
        D3DFMT_D24X4S4 = 79,
        D3DFMT_D16 = 80,
        D3DFMT_D32F_LOCKABLE = 82,
        D3DFMT_D24FS8 = 83,
        (* D3D9Ex only -- *)
        (* Z-Stencil formats valid for CPU access *)
        D3DFMT_D32_LOCKABLE = 84,
        D3DFMT_S8_LOCKABLE = 85,
        (* -- D3D9Ex only *)
        D3DFMT_L16 = 81,
        D3DFMT_VERTEXDATA = 100,
        D3DFMT_INDEX16 = 101,
        D3DFMT_INDEX32 = 102,
        D3DFMT_Q16W16V16U16 = 110,
        D3DFMT_MULTI2_ARGB8 = (Ord('M') or (Ord('E') shl 8) or (Ord('T') shl 16) or (Ord('1') shl 24)),
        // Floating point surface formats
        // s10e5 formats (16-bits per channel)
        D3DFMT_R16F = 111,
        D3DFMT_G16R16F = 112,
        D3DFMT_A16B16G16R16F = 113,
        // IEEE s23e8 formats (32-bits per channel)
        D3DFMT_R32F = 114,
        D3DFMT_G32R32F = 115,
        D3DFMT_A32B32G32R32F = 116,
        D3DFMT_CxV8U8 = 117,
        (* D3D9Ex only -- *)
        // Monochrome 1 bit per pixel format
        D3DFMT_A1 = 118,
        // 2.8 biased fixed point
        D3DFMT_A2B10G10R10_XR_BIAS = 119,
        // Binary format indicating that the data has no inherent type
        D3DFMT_BINARYBUFFER = 199,
        (* -- D3D9Ex only *)
        D3DFMT_FORCE_DWORD = $7fffffff);



    TD3DFORMAT = _D3DFORMAT;
    PD3DFORMAT = ^TD3DFORMAT;




    (* Display Modes *)
    _D3DDISPLAYMODE = record
        Width: UINT;
        Height: UINT;
        RefreshRate: UINT;
        Format: TD3DFORMAT;
    end;


    TD3DDISPLAYMODE = _D3DDISPLAYMODE;
    PD3DDISPLAYMODE = ^TD3DDISPLAYMODE;

    (* Creation Parameters *)
    _D3DDEVICE_CREATION_PARAMETERS = record
        AdapterOrdinal: UINT;
        DeviceType: TD3DDEVTYPE;
        hFocusWindow: HWND;
        BehaviorFlags: DWORD;
    end;


    TD3DDEVICE_CREATION_PARAMETERS = _D3DDEVICE_CREATION_PARAMETERS;
    PD3DDEVICE_CREATION_PARAMETERS = ^TD3DDEVICE_CREATION_PARAMETERS;


    (* SwapEffects *)
    _D3DSWAPEFFECT = (
        D3DSWAPEFFECT_DISCARD = 1,
        D3DSWAPEFFECT_FLIP = 2,
        D3DSWAPEFFECT_COPY = 3,
        (* D3D9Ex only -- *)
        D3DSWAPEFFECT_OVERLAY = 4,
        D3DSWAPEFFECT_FLIPEX = 5,
        (* -- D3D9Ex only *)
        D3DSWAPEFFECT_FORCE_DWORD = $7fffffff);

    TD3DSWAPEFFECT = _D3DSWAPEFFECT;
    PD3DSWAPEFFECT = ^TD3DSWAPEFFECT;

    (* Pool types *)
    _D3DPOOL = (
        D3DPOOL_DEFAULT = 0,
        D3DPOOL_MANAGED = 1,
        D3DPOOL_SYSTEMMEM = 2,
        D3DPOOL_SCRATCH = 3,
        D3DPOOL_FORCE_DWORD = $7fffffff);



    TD3DPOOL = _D3DPOOL;
    PD3DPOOL = ^TD3DPOOL;



    (* Resize Optional Parameters *)
    _D3DPRESENT_PARAMETERS_ = record
        BackBufferWidth: uint32;
        BackBufferHeight: uint32;
        BackBufferFormat: TD3DFORMAT;
        BackBufferCount: uint32;
        MultiSampleType: TD3DMULTISAMPLE_TYPE;
        MultiSampleQuality: DWORD;
        SwapEffect: TD3DSWAPEFFECT;
        hDeviceWindow: HWND;
        Windowed: winbool;
        EnableAutoDepthStencil: winbool;
        AutoDepthStencilFormat: TD3DFORMAT;
        Flags: DWORD;
        (* FullScreen_RefreshRateInHz must be zero for Windowed mode *)
        FullScreen_RefreshRateInHz: uint32;
        PresentationInterval: uint32;
    end;


    TD3DPRESENT_PARAMETERS = _D3DPRESENT_PARAMETERS_;
    PD3DPRESENT_PARAMETERS = ^TD3DPRESENT_PARAMETERS;


    (* -- D3D9Ex only *)
    (* Gamma Ramp: Same as DX7 *)


    _D3DGAMMARAMP = record
        red: array [0..255] of word;
        green: array [0..255] of word;
        blue: array [0..255] of word;
    end;


    TD3DGAMMARAMP = _D3DGAMMARAMP;
    PD3DGAMMARAMP = ^TD3DGAMMARAMP;

    (* Back buffer types *)
    _D3DBACKBUFFER_TYPE = (
        D3DBACKBUFFER_TYPE_MONO = 0,
        D3DBACKBUFFER_TYPE_LEFT = 1,
        D3DBACKBUFFER_TYPE_RIGHT = 2,
        D3DBACKBUFFER_TYPE_FORCE_DWORD = $7fffffff);



    TD3DBACKBUFFER_TYPE = _D3DBACKBUFFER_TYPE;
    PD3DBACKBUFFER_TYPE = ^TD3DBACKBUFFER_TYPE;




    (* CubeMap Face identifiers *)
    _D3DCUBEMAP_FACES = (
        D3DCUBEMAP_FACE_POSITIVE_X = 0,
        D3DCUBEMAP_FACE_NEGATIVE_X = 1,
        D3DCUBEMAP_FACE_POSITIVE_Y = 2,
        D3DCUBEMAP_FACE_NEGATIVE_Y = 3,
        D3DCUBEMAP_FACE_POSITIVE_Z = 4,
        D3DCUBEMAP_FACE_NEGATIVE_Z = 5,
        D3DCUBEMAP_FACE_FORCE_DWORD = $7fffffff);

    TD3DCUBEMAP_FACES = _D3DCUBEMAP_FACES;
    PD3DCUBEMAP_FACES = ^TD3DCUBEMAP_FACES;




    (* Vertex Buffer Description *)
    _D3DVERTEXBUFFER_DESC = record
        Format: TD3DFORMAT;
        ResourceType: TD3DRESOURCETYPE;
        Usage: DWORD;
        Pool: TD3DPOOL;
        Size: UINT;
        FVF: DWORD;
    end;


    TD3DVERTEXBUFFER_DESC = _D3DVERTEXBUFFER_DESC;
    PD3DVERTEXBUFFER_DESC = ^TD3DVERTEXBUFFER_DESC;

    (* Index Buffer Description *)
    _D3DINDEXBUFFER_DESC = record
        Format: TD3DFORMAT;
        ResourceType: TD3DRESOURCETYPE;
        Usage: DWORD;
        Pool: TD3DPOOL;
        Size: UINT;
    end;

    TD3DINDEXBUFFER_DESC = _D3DINDEXBUFFER_DESC;
    PD3DINDEXBUFFER_DESC = ^TD3DINDEXBUFFER_DESC;


    (* Surface Description *)
    _D3DSURFACE_DESC = record
        Format: TD3DFORMAT;
        ResourceType: TD3DRESOURCETYPE;
        Usage: DWORD;
        Pool: TD3DPOOL;
        MultiSampleType: TD3DMULTISAMPLE_TYPE;
        MultiSampleQuality: DWORD;
        Width: UINT;
        Height: UINT;
    end;


    TD3DSURFACE_DESC = _D3DSURFACE_DESC;
    PD3DSURFACE_DESC = ^TD3DSURFACE_DESC;

    _D3DVOLUME_DESC = record
        Format: TD3DFORMAT;
        ResourceType: TD3DRESOURCETYPE;
        Usage: DWORD;
        Pool: TD3DPOOL;
        Width: UINT;
        Height: UINT;
        Depth: UINT;
    end;


    TD3DVOLUME_DESC = _D3DVOLUME_DESC;
    PD3DVOLUME_DESC = ^TD3DVOLUME_DESC;

    (* Structure for LockRect *)
    _D3DLOCKED_RECT = record
        Pitch: int32;
        pBits: Pvoid;
    end;


    TD3DLOCKED_RECT = _D3DLOCKED_RECT;
    PD3DLOCKED_RECT = ^TD3DLOCKED_RECT;

    (* Structures for LockBox *)
    _D3DBOX = record
        Left: UINT;
        Top: UINT;
        Right: UINT;
        Bottom: UINT;
        Front: UINT;
        Back: UINT;
    end;
    TD3DBOX = _D3DBOX;
    PD3DBOX = ^TD3DBOX;

    _D3DLOCKED_BOX = record
        RowPitch: int32;
        SlicePitch: int32;
        pBits: Pvoid;
    end;
    TD3DLOCKED_BOX = _D3DLOCKED_BOX;
    PD3DLOCKED_BOX = ^TD3DLOCKED_BOX;

    (* Structures for LockRange *)
    _D3DRANGE = record
        Offset: UINT;
        Size: UINT;
    end;

    TD3DRANGE = _D3DRANGE;
    PD3DRANGE = ^TD3DRANGE;

    (* Structures for high order primitives *)
    _D3DRECTPATCH_INFO = record
        StartVertexOffsetWidth: UINT;
        StartVertexOffsetHeight: UINT;
        Width: UINT;
        Height: UINT;
        Stride: UINT;
        Basis: TD3DBASISTYPE;
        Degree: TD3DDEGREETYPE;
    end;
    TD3DRECTPATCH_INFO = _D3DRECTPATCH_INFO;
    PD3DRECTPATCH_INFO = ^TD3DRECTPATCH_INFO;


    _D3DTRIPATCH_INFO = record
        StartVertexOffset: UINT;
        NumVertices: UINT;
        Basis: TD3DBASISTYPE;
        Degree: TD3DDEGREETYPE;
    end;

    TD3DTRIPATCH_INFO = _D3DTRIPATCH_INFO;
    PD3DTRIPATCH_INFO = ^TD3DTRIPATCH_INFO;



    (* Adapter Identifier *)

    _D3DADAPTER_IDENTIFIER9 = record
        Driver: array [0..MAX_DEVICE_IDENTIFIER_STRING - 1] of char;
        Description: array [0..MAX_DEVICE_IDENTIFIER_STRING - 1] of char;
        DeviceName: array [0..31] of char; (* Device name for GDI (ex. \\.\DISPLAY1) *)
        {$IFDEF _WIN32}
   DriverVersion : TLARGE_INTEGER; (* Defined for 32 bit components *)
        {$ELSE }
        DriverVersionLowPart: DWORD; (* Defined for 16 bit driver components *)
        DriverVersionHighPart: DWORD;
        {$ENDIF}

        VendorId: DWORD;
        DeviceId: DWORD;
        SubSysId: DWORD;
        Revision: DWORD;
        DeviceIdentifier: TGUID;
        WHQLLevel: DWORD;
    end;

    TD3DADAPTER_IDENTIFIER9 = _D3DADAPTER_IDENTIFIER9;
    PD3DADAPTER_IDENTIFIER9 = ^TD3DADAPTER_IDENTIFIER9;




    (* Raster Status structure returned by GetRasterStatus *)
    _D3DRASTER_STATUS = record
        InVBlank: boolean;
        ScanLine: UINT;
    end;

    TD3DRASTER_STATUS = _D3DRASTER_STATUS;
    PD3DRASTER_STATUS = ^TD3DRASTER_STATUS;



(* Debug monitor tokens (DEBUG only)

   Note that if D3DRS_DEBUGMONITORTOKEN is set, the call is treated as
   passing a token to the debug monitor.  For example, if, after passing
   D3DDMT_ENABLE/DISABLE to D3DRS_DEBUGMONITORTOKEN other token values
   are passed in, the enabled/disabled state of the debug
   monitor will still persist.

   The debug monitor defaults to enabled.

   Calling GetRenderState on D3DRS_DEBUGMONITORTOKEN is not of any use.
*)
    _D3DDEBUGMONITORTOKENS = (
        D3DDMT_ENABLE = 0, // enable debug monitor
        D3DDMT_DISABLE = 1, // disable debug monitor
        D3DDMT_FORCE_DWORD = $7fffffff);

    TD3DDEBUGMONITORTOKENS = _D3DDEBUGMONITORTOKENS;
    PD3DDEBUGMONITORTOKENS = ^TD3DDEBUGMONITORTOKENS;

    // Async feedback

    _D3DQUERYTYPE = (
        D3DQUERYTYPE_VCACHE = 4, (* D3DISSUE_END *)
        D3DQUERYTYPE_RESOURCEMANAGER = 5, (* D3DISSUE_END *)
        D3DQUERYTYPE_VERTEXSTATS = 6, (* D3DISSUE_END *)
        D3DQUERYTYPE_EVENT = 8, (* D3DISSUE_END *)
        D3DQUERYTYPE_OCCLUSION = 9, (* D3DISSUE_BEGIN, D3DISSUE_END *)
        D3DQUERYTYPE_TIMESTAMP = 10, (* D3DISSUE_END *)
        D3DQUERYTYPE_TIMESTAMPDISJOINT = 11, (* D3DISSUE_BEGIN, D3DISSUE_END *)
        D3DQUERYTYPE_TIMESTAMPFREQ = 12, (* D3DISSUE_END *)
        D3DQUERYTYPE_PIPELINETIMINGS = 13, (* D3DISSUE_BEGIN, D3DISSUE_END *)
        D3DQUERYTYPE_INTERFACETIMINGS = 14, (* D3DISSUE_BEGIN, D3DISSUE_END *)
        D3DQUERYTYPE_VERTEXTIMINGS = 15, (* D3DISSUE_BEGIN, D3DISSUE_END *)
        D3DQUERYTYPE_PIXELTIMINGS = 16, (* D3DISSUE_BEGIN, D3DISSUE_END *)
        D3DQUERYTYPE_BANDWIDTHTIMINGS = 17, (* D3DISSUE_BEGIN, D3DISSUE_END *)
        D3DQUERYTYPE_CACHEUTILIZATION = 18, (* D3DISSUE_BEGIN, D3DISSUE_END *)
        (* D3D9Ex only -- *)
        D3DQUERYTYPE_MEMORYPRESSURE = 19(* D3DISSUE_BEGIN, D3DISSUE_END *));

    TD3DQUERYTYPE = _D3DQUERYTYPE;
    PD3DQUERYTYPE = ^TD3DQUERYTYPE;


    _D3DRESOURCESTATS = record
        // Data collected since last Present()
        bThrashing: boolean;
        (* indicates if thrashing *)
        ApproxBytesDownloaded: DWORD;
        (* Approximate number of bytes downloaded by resource manager *)
        NumEvicts: DWORD;
        (* number of objects evicted *)
        NumVidCreates: DWORD;
        (* number of objects created in video memory *)
        LastPri: DWORD;
        (* priority of last object evicted *)
        NumUsed: DWORD;
        (* number of objects set to the device *)
        NumUsedInVidMem: DWORD;
        (* number of objects set to the device, which are already in video memory *)
        // Persistent data
        WorkingSet: DWORD;
        (* number of objects in video memory *)
        WorkingSetBytes: DWORD;
        (* number of bytes in video memory *)
        TotalManaged: DWORD;
        (* total number of managed objects *)
        TotalBytes: DWORD;
        (* total number of bytes of managed objects *)
    end;


    TD3DRESOURCESTATS = _D3DRESOURCESTATS;
    PD3DRESOURCESTATS = ^TD3DRESOURCESTATS;



    _D3DDEVINFO_RESOURCEMANAGER = record
        {$ifndef WOW64_ENUM_WORKAROUND}
        stats: array [0..D3DRTYPECOUNT - 1] of TD3DRESOURCESTATS;
        {$ELSE }
   stats : array [0..7] of TD3DRESOURCESTATS;
        {$ENDIF}

    end;

    TD3DDEVINFO_RESOURCEMANAGER = _D3DDEVINFO_RESOURCEMANAGER;
    PD3DDEVINFO_RESOURCEMANAGER = ^TD3DDEVINFO_RESOURCEMANAGER;
    LPD3DDEVINFO_RESOURCEMANAGER = ^TD3DDEVINFO_RESOURCEMANAGER;

    _D3DDEVINFO_D3DVERTEXSTATS = record
        NumRenderedTriangles: DWORD; (* total number of triangles that are not clipped in this frame *)
        NumExtraClippingTriangles: DWORD; (* Number of new triangles generated by clipping *)
    end;

    TD3DDEVINFO_D3DVERTEXSTATS = _D3DDEVINFO_D3DVERTEXSTATS;
    PD3DDEVINFO_D3DVERTEXSTATS = ^TD3DDEVINFO_D3DVERTEXSTATS;
    LPD3DDEVINFO_D3DVERTEXSTATS = ^TD3DDEVINFO_D3DVERTEXSTATS;


    _D3DDEVINFO_VCACHE = record
        Pattern: DWORD; (* bit pattern, return value must be FOUR_CC('C', 'A', 'C', 'H') *)
        OptMethod: DWORD; (* optimization method 0 means longest strips, 1 means vertex cache based *)
        CacheSize: DWORD; (* cache size to optimize for  (only required if type is 1) *)
        MagicNumber: DWORD; (* used to determine when to restart strips (only required if type is 1)*)
    end;

    TD3DDEVINFO_VCACHE = _D3DDEVINFO_VCACHE;
    PD3DDEVINFO_VCACHE = ^TD3DDEVINFO_VCACHE;
    LPD3DDEVINFO_VCACHE = ^TD3DDEVINFO_VCACHE;

    _D3DDEVINFO_D3D9PIPELINETIMINGS = record
        VertexProcessingTimePercent: single;
        PixelProcessingTimePercent: single;
        OtherGPUProcessingTimePercent: single;
        GPUIdleTimePercent: single;
    end;

    TD3DDEVINFO_D3D9PIPELINETIMINGS = _D3DDEVINFO_D3D9PIPELINETIMINGS;
    PD3DDEVINFO_D3D9PIPELINETIMINGS = ^TD3DDEVINFO_D3D9PIPELINETIMINGS;

    _D3DDEVINFO_D3D9INTERFACETIMINGS = record
        WaitingForGPUToUseApplicationResourceTimePercent: single;
        WaitingForGPUToAcceptMoreCommandsTimePercent: single;
        WaitingForGPUToStayWithinLatencyTimePercent: single;
        WaitingForGPUExclusiveResourceTimePercent: single;
        WaitingForGPUOtherTimePercent: single;
    end;

    TD3DDEVINFO_D3D9INTERFACETIMINGS = _D3DDEVINFO_D3D9INTERFACETIMINGS;
    PD3DDEVINFO_D3D9INTERFACETIMINGS = ^TD3DDEVINFO_D3D9INTERFACETIMINGS;

    _D3DDEVINFO_D3D9STAGETIMINGS = record
        MemoryProcessingPercent: single;
        ComputationProcessingPercent: single;
    end;

    TD3DDEVINFO_D3D9STAGETIMINGS = _D3DDEVINFO_D3D9STAGETIMINGS;
    PD3DDEVINFO_D3D9STAGETIMINGS = ^TD3DDEVINFO_D3D9STAGETIMINGS;

    _D3DDEVINFO_D3D9BANDWIDTHTIMINGS = record
        MaxBandwidthUtilized: single;
        FrontEndUploadMemoryUtilizedPercent: single;
        VertexRateUtilizedPercent: single;
        TriangleSetupRateUtilizedPercent: single;
        FillRateUtilizedPercent: single;
    end;

    TD3DDEVINFO_D3D9BANDWIDTHTIMINGS = _D3DDEVINFO_D3D9BANDWIDTHTIMINGS;
    PD3DDEVINFO_D3D9BANDWIDTHTIMINGS = ^TD3DDEVINFO_D3D9BANDWIDTHTIMINGS;

    _D3DDEVINFO_D3D9CACHEUTILIZATION = record
        TextureCacheHitRate: single; // Percentage of cache hits
        PostTransformVertexCacheHitRate: single;
    end;

    TD3DDEVINFO_D3D9CACHEUTILIZATION = _D3DDEVINFO_D3D9CACHEUTILIZATION;
    PD3DDEVINFO_D3D9CACHEUTILIZATION = ^TD3DDEVINFO_D3D9CACHEUTILIZATION;

    (* D3D9Ex only -- *)


    _D3DMEMORYPRESSURE = record
        BytesEvictedFromProcess: uint64;
        SizeOfInefficientAllocation: uint64;
        LevelOfEfficiency: DWORD;
    end;

    TD3DMEMORYPRESSURE = _D3DMEMORYPRESSURE;
    PD3DMEMORYPRESSURE = ^TD3DMEMORYPRESSURE;

    _D3DCOMPOSERECTSOP = (
        D3DCOMPOSERECTS_COPY = 1,
        D3DCOMPOSERECTS_OR = 2,
        D3DCOMPOSERECTS_AND = 3,
        D3DCOMPOSERECTS_NEG = 4,
        D3DCOMPOSERECTS_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));


    TD3DCOMPOSERECTSOP = _D3DCOMPOSERECTSOP;
    PD3DCOMPOSERECTSOP = ^TD3DCOMPOSERECTSOP;

    _D3DCOMPOSERECTDESC = record
        XY: USHORT; // Top-left coordinates of a rect in the source surface
        WidthHeight: USHORT; // Dimensions of the rect
    end;

    TD3DCOMPOSERECTDESC = _D3DCOMPOSERECTDESC;
    PD3DCOMPOSERECTDESC = ^TD3DCOMPOSERECTDESC;

    _D3DCOMPOSERECTDESTINATION = record
        SrcRectIndex: USHORT; // Index of D3DCOMPOSERECTDESC
        Reserved: USHORT; // For alignment
        XY: SHORT; // Top-left coordinates of the rect in the destination surface
    end;


    TD3DCOMPOSERECTDESTINATION = _D3DCOMPOSERECTDESTINATION;
    PD3DCOMPOSERECTDESTINATION = ^TD3DCOMPOSERECTDESTINATION;




    _D3DPRESENTSTATS = record
        PresentCount: UINT;
        PresentRefreshCount: UINT;
        SyncRefreshCount: UINT;
        SyncQPCTime: LARGE_INTEGER;
        SyncGPUTime: LARGE_INTEGER;
    end;
    TD3DPRESENTSTATS = _D3DPRESENTSTATS;
    PD3DPRESENTSTATS = ^TD3DPRESENTSTATS;



    TD3DSCANLINEORDERING = (
        D3DSCANLINEORDERING_UNKNOWN = 0,
        D3DSCANLINEORDERING_PROGRESSIVE = 1,
        D3DSCANLINEORDERING_INTERLACED = 2);

    PD3DSCANLINEORDERING = ^TD3DSCANLINEORDERING;



    TD3DDISPLAYMODEEX = record
        Size: UINT;
        Width: UINT;
        Height: UINT;
        RefreshRate: UINT;
        Format: TD3DFORMAT;
        ScanLineOrdering: TD3DSCANLINEORDERING;
    end;
    PD3DDISPLAYMODEEX = ^TD3DDISPLAYMODEEX;


    TD3DDISPLAYMODEFILTER = record
        Size: UINT;
        Format: TD3DFORMAT;
        ScanLineOrdering: TD3DSCANLINEORDERING;
    end;
    PD3DDISPLAYMODEFILTER = ^TD3DDISPLAYMODEFILTER;



    TD3DDISPLAYROTATION = (
        D3DDISPLAYROTATION_IDENTITY = 1, // No rotation.
        D3DDISPLAYROTATION_90 = 2, // Rotated 90 degrees.
        D3DDISPLAYROTATION_180 = 3, // Rotated 180 degrees.
        D3DDISPLAYROTATION_270 = 4// Rotated 270 degrees.
        );

    PD3DDISPLAYROTATION = ^TD3DDISPLAYROTATION;


    _D3D_OMAC = record
        Omac: array [0..D3D_OMAC_SIZE - 1] of TBYTE;
    end;

    TD3D_OMAC = _D3D_OMAC;
    PD3D_OMAC = ^TD3D_OMAC;

    _D3DAUTHENTICATEDCHANNELTYPE = (
        D3DAUTHENTICATEDCHANNEL_D3D9 = 1,
        D3DAUTHENTICATEDCHANNEL_DRIVER_SOFTWARE = 2,
        D3DAUTHENTICATEDCHANNEL_DRIVER_HARDWARE = 3);

    TD3DAUTHENTICATEDCHANNELTYPE = _D3DAUTHENTICATEDCHANNELTYPE;
    PD3DAUTHENTICATEDCHANNELTYPE = ^TD3DAUTHENTICATEDCHANNELTYPE;

    _D3DAUTHENTICATEDCHANNEL_QUERY_INPUT = record
        QueryType: TGUID;
        hChannel: HANDLE;
        SequenceNumber: UINT;
    end;

    TD3DAUTHENTICATEDCHANNEL_QUERY_INPUT = _D3DAUTHENTICATEDCHANNEL_QUERY_INPUT;
    PD3DAUTHENTICATEDCHANNEL_QUERY_INPUT = ^TD3DAUTHENTICATEDCHANNEL_QUERY_INPUT;

    _D3DAUTHENTICATEDCHANNEL_QUERY_OUTPUT = record
        omac: TD3D_OMAC;
        QueryType: TGUID;
        hChannel: HANDLE;
        SequenceNumber: UINT;
        ReturnCode: HRESULT;
    end;


    TD3DAUTHENTICATEDCHANNEL_QUERY_OUTPUT = _D3DAUTHENTICATEDCHANNEL_QUERY_OUTPUT;
    PD3DAUTHENTICATEDCHANNEL_QUERY_OUTPUT = ^TD3DAUTHENTICATEDCHANNEL_QUERY_OUTPUT;




    _D3DAUTHENTICATEDCHANNEL_PROTECTION_FLAGS = bitpacked record
        case integer of
            0: (
                ProtectionEnabled: 0..1;
                OverlayOrFullscreenRequired: 0..1;
                Reserved: 0..1073741823;
            );
            1: (
                Value: UINT;
            );
    end;

    TD3DAUTHENTICATEDCHANNEL_PROTECTION_FLAGS = _D3DAUTHENTICATEDCHANNEL_PROTECTION_FLAGS;
    PD3DAUTHENTICATEDCHANNEL_PROTECTION_FLAGS = ^TD3DAUTHENTICATEDCHANNEL_PROTECTION_FLAGS;



    _D3DAUTHENTICATEDCHANNEL_QUERYPROTECTION_OUTPUT = record
        Output: TD3DAUTHENTICATEDCHANNEL_QUERY_OUTPUT;
        ProtectionFlags: TD3DAUTHENTICATEDCHANNEL_PROTECTION_FLAGS;
    end;
    TD3DAUTHENTICATEDCHANNEL_QUERYPROTECTION_OUTPUT = _D3DAUTHENTICATEDCHANNEL_QUERYPROTECTION_OUTPUT;
    PD3DAUTHENTICATEDCHANNEL_QUERYPROTECTION_OUTPUT = ^TD3DAUTHENTICATEDCHANNEL_QUERYPROTECTION_OUTPUT;




    _D3DAUTHENTICATEDCHANNEL_QUERYCHANNELTYPE_OUTPUT = record
        Output: TD3DAUTHENTICATEDCHANNEL_QUERY_OUTPUT;
        ChannelType: TD3DAUTHENTICATEDCHANNELTYPE;
    end;
    TD3DAUTHENTICATEDCHANNEL_QUERYCHANNELTYPE_OUTPUT = _D3DAUTHENTICATEDCHANNEL_QUERYCHANNELTYPE_OUTPUT;
    PD3DAUTHENTICATEDCHANNEL_QUERYCHANNELTYPE_OUTPUT = ^TD3DAUTHENTICATEDCHANNEL_QUERYCHANNELTYPE_OUTPUT;




    _D3DAUTHENTICATEDCHANNEL_QUERYDEVICEHANDLE_OUTPUT = record
        Output: TD3DAUTHENTICATEDCHANNEL_QUERY_OUTPUT;
        DeviceHandle: HANDLE;
    end;
    TD3DAUTHENTICATEDCHANNEL_QUERYDEVICEHANDLE_OUTPUT = _D3DAUTHENTICATEDCHANNEL_QUERYDEVICEHANDLE_OUTPUT;
    PD3DAUTHENTICATEDCHANNEL_QUERYDEVICEHANDLE_OUTPUT = ^TD3DAUTHENTICATEDCHANNEL_QUERYDEVICEHANDLE_OUTPUT;




    _D3DAUTHENTICATEDCHANNEL_QUERYCRYPTOSESSION_INPUT = record
        Input: TD3DAUTHENTICATEDCHANNEL_QUERY_INPUT;
        DXVA2DecodeHandle: HANDLE;
    end;
    TD3DAUTHENTICATEDCHANNEL_QUERYCRYPTOSESSION_INPUT = _D3DAUTHENTICATEDCHANNEL_QUERYCRYPTOSESSION_INPUT;
    PD3DAUTHENTICATEDCHANNEL_QUERYCRYPTOSESSION_INPUT = ^TD3DAUTHENTICATEDCHANNEL_QUERYCRYPTOSESSION_INPUT;


    _D3DAUTHENTICATEDCHANNEL_QUERYCRYPTOSESSION_OUTPUT = record
        Output: TD3DAUTHENTICATEDCHANNEL_QUERY_OUTPUT;
        DXVA2DecodeHandle: HANDLE;
        CryptoSessionHandle: HANDLE;
        DeviceHandle: HANDLE;
    end;
    TD3DAUTHENTICATEDCHANNEL_QUERYCRYPTOSESSION_OUTPUT = _D3DAUTHENTICATEDCHANNEL_QUERYCRYPTOSESSION_OUTPUT;
    PD3DAUTHENTICATEDCHANNEL_QUERYCRYPTOSESSION_OUTPUT = ^TD3DAUTHENTICATEDCHANNEL_QUERYCRYPTOSESSION_OUTPUT;



    _D3DAUTHENTICATEDCHANNEL_QUERYRESTRICTEDSHAREDRESOURCEPROCESSCOUNT_OUTPUT = record
        Output: TD3DAUTHENTICATEDCHANNEL_QUERY_OUTPUT;
        NumRestrictedSharedResourceProcesses: UINT;
    end;
    TD3DAUTHENTICATEDCHANNEL_QUERYRESTRICTEDSHAREDRESOURCEPROCESSCOUNT_OUTPUT = _D3DAUTHENTICATEDCHANNEL_QUERYRESTRICTEDSHAREDRESOURCEPROCESSCOUNT_OUTPUT;
    PD3DAUTHENTICATEDCHANNEL_QUERYRESTRICTEDSHAREDRESOURCEPROCESSCOUNT_OUTPUT = ^TD3DAUTHENTICATEDCHANNEL_QUERYRESTRICTEDSHAREDRESOURCEPROCESSCOUNT_OUTPUT;




    _D3DAUTHENTICATEDCHANNEL_QUERYRESTRICTEDSHAREDRESOURCEPROCESS_INPUT = record
        Input: TD3DAUTHENTICATEDCHANNEL_QUERY_INPUT;
        ProcessIndex: UINT;
    end;
    TD3DAUTHENTICATEDCHANNEL_QUERYRESTRICTEDSHAREDRESOURCEPROCESS_INPUT = _D3DAUTHENTICATEDCHANNEL_QUERYRESTRICTEDSHAREDRESOURCEPROCESS_INPUT;
    PD3DAUTHENTICATEDCHANNEL_QUERYRESTRICTEDSHAREDRESOURCEPROCESS_INPUT = ^TD3DAUTHENTICATEDCHANNEL_QUERYRESTRICTEDSHAREDRESOURCEPROCESS_INPUT;



    T_D3DAUTHENTICATEDCHANNEL_PROCESSIDENTIFIERTYPE = (
        PROCESSIDTYPE_UNKNOWN = 0,
        PROCESSIDTYPE_DWM = 1,
        PROCESSIDTYPE_HANDLE = 2);

    P_D3DAUTHENTICATEDCHANNEL_PROCESSIDENTIFIERTYPE = ^T_D3DAUTHENTICATEDCHANNEL_PROCESSIDENTIFIERTYPE;

    TD3DAUTHENTICATEDCHANNEL_PROCESSIDENTIFIERTYPE = T_D3DAUTHENTICATEDCHANNEL_PROCESSIDENTIFIERTYPE;

    _D3DAUTHENTICATEDCHANNEL_QUERYRESTRICTEDSHAREDRESOURCEPROCESS_OUTPUT = record
        Output: TD3DAUTHENTICATEDCHANNEL_QUERY_OUTPUT;
        ProcessIndex: UINT;
        ProcessIdentifer: TD3DAUTHENTICATEDCHANNEL_PROCESSIDENTIFIERTYPE;
        ProcessHandle: HANDLE;
    end;
    TD3DAUTHENTICATEDCHANNEL_QUERYRESTRICTEDSHAREDRESOURCEPROCESS_OUTPUT = _D3DAUTHENTICATEDCHANNEL_QUERYRESTRICTEDSHAREDRESOURCEPROCESS_OUTPUT;
    PD3DAUTHENTICATEDCHANNEL_QUERYRESTRICTEDSHAREDRESOURCEPROCESS_OUTPUT = ^TD3DAUTHENTICATEDCHANNEL_QUERYRESTRICTEDSHAREDRESOURCEPROCESS_OUTPUT;



    _D3DAUTHENTICATEDCHANNEL_QUERYUNRESTRICTEDPROTECTEDSHAREDRESOURCECOUNT_OUTPUT = record
        Output: TD3DAUTHENTICATEDCHANNEL_QUERY_OUTPUT;
        NumUnrestrictedProtectedSharedResources: UINT;
    end;
    TD3DAUTHENTICATEDCHANNEL_QUERYUNRESTRICTEDPROTECTEDSHAREDRESOURCECOUNT_OUTPUT = _D3DAUTHENTICATEDCHANNEL_QUERYUNRESTRICTEDPROTECTEDSHAREDRESOURCECOUNT_OUTPUT;
    PD3DAUTHENTICATEDCHANNEL_QUERYUNRESTRICTEDPROTECTEDSHAREDRESOURCECOUNT_OUTPUT = ^TD3DAUTHENTICATEDCHANNEL_QUERYUNRESTRICTEDPROTECTEDSHAREDRESOURCECOUNT_OUTPUT;



    _D3DAUTHENTICATEDCHANNEL_QUERYOUTPUTIDCOUNT_INPUT = record
        Input: TD3DAUTHENTICATEDCHANNEL_QUERY_INPUT;
        DeviceHandle: HANDLE;
        CryptoSessionHandle: HANDLE;
    end;
    TD3DAUTHENTICATEDCHANNEL_QUERYOUTPUTIDCOUNT_INPUT = _D3DAUTHENTICATEDCHANNEL_QUERYOUTPUTIDCOUNT_INPUT;
    PD3DAUTHENTICATEDCHANNEL_QUERYOUTPUTIDCOUNT_INPUT = ^TD3DAUTHENTICATEDCHANNEL_QUERYOUTPUTIDCOUNT_INPUT;


    _D3DAUTHENTICATEDCHANNEL_QUERYOUTPUTIDCOUNT_OUTPUT = record
        Output: TD3DAUTHENTICATEDCHANNEL_QUERY_OUTPUT;
        DeviceHandle: HANDLE;
        CryptoSessionHandle: HANDLE;
        NumOutputIDs: UINT;
    end;
    TD3DAUTHENTICATEDCHANNEL_QUERYOUTPUTIDCOUNT_OUTPUT = _D3DAUTHENTICATEDCHANNEL_QUERYOUTPUTIDCOUNT_OUTPUT;
    PD3DAUTHENTICATEDCHANNEL_QUERYOUTPUTIDCOUNT_OUTPUT = ^TD3DAUTHENTICATEDCHANNEL_QUERYOUTPUTIDCOUNT_OUTPUT;



    _D3DAUTHENTICATEDCHANNEL_QUERYOUTPUTID_INPUT = record
        Input: TD3DAUTHENTICATEDCHANNEL_QUERY_INPUT;
        DeviceHandle: HANDLE;
        CryptoSessionHandle: HANDLE;
        OutputIDIndex: UINT;
    end;
    TD3DAUTHENTICATEDCHANNEL_QUERYOUTPUTID_INPUT = _D3DAUTHENTICATEDCHANNEL_QUERYOUTPUTID_INPUT;
    PD3DAUTHENTICATEDCHANNEL_QUERYOUTPUTID_INPUT = ^TD3DAUTHENTICATEDCHANNEL_QUERYOUTPUTID_INPUT;


    _D3DAUTHENTICATEDCHANNEL_QUERYOUTPUTID_OUTPUT = record
        Output: TD3DAUTHENTICATEDCHANNEL_QUERY_OUTPUT;
        DeviceHandle: HANDLE;
        CryptoSessionHandle: HANDLE;
        OutputIDIndex: UINT;
        OutputID: uint64;
    end;
    TD3DAUTHENTICATEDCHANNEL_QUERYOUTPUTID_OUTPUT = _D3DAUTHENTICATEDCHANNEL_QUERYOUTPUTID_OUTPUT;
    PD3DAUTHENTICATEDCHANNEL_QUERYOUTPUTID_OUTPUT = ^TD3DAUTHENTICATEDCHANNEL_QUERYOUTPUTID_OUTPUT;



    _D3DBUSTYPE = (
        D3DBUSTYPE_OTHER = $00000000,
        D3DBUSTYPE_PCI = $00000001,
        D3DBUSTYPE_PCIX = $00000002,
        D3DBUSTYPE_PCIEXPRESS = $00000003,
        D3DBUSTYPE_AGP = $00000004,
        D3DBUSIMPL_MODIFIER_INSIDE_OF_CHIPSET = $00010000,
        D3DBUSIMPL_MODIFIER_TRACKS_ON_MOTHER_BOARD_TO_CHIP = $00020000,
        D3DBUSIMPL_MODIFIER_TRACKS_ON_MOTHER_BOARD_TO_SOCKET = $00030000,
        D3DBUSIMPL_MODIFIER_DAUGHTER_BOARD_CONNECTOR = $00040000,
        D3DBUSIMPL_MODIFIER_DAUGHTER_BOARD_CONNECTOR_INSIDE_OF_NUAE = $00050000,
        D3DBUSIMPL_MODIFIER_NON_STANDARD = longint($80000000));



    TD3DBUSTYPE = _D3DBUSTYPE;
    PD3DBUSTYPE = ^TD3DBUSTYPE;

    _D3DAUTHENTICATEDCHANNEL_QUERYINFOBUSTYPE_OUTPUT = record
        Output: TD3DAUTHENTICATEDCHANNEL_QUERY_OUTPUT;
        BusType: TD3DBUSTYPE;
        bAccessibleInContiguousBlocks: boolean;
        bAccessibleInNonContiguousBlocks: boolean;
    end;
    TD3DAUTHENTICATEDCHANNEL_QUERYINFOBUSTYPE_OUTPUT = _D3DAUTHENTICATEDCHANNEL_QUERYINFOBUSTYPE_OUTPUT;
    PD3DAUTHENTICATEDCHANNEL_QUERYINFOBUSTYPE_OUTPUT = ^TD3DAUTHENTICATEDCHANNEL_QUERYINFOBUSTYPE_OUTPUT;




    _D3DAUTHENTICATEDCHANNEL_QUERYEVICTIONENCRYPTIONGUIDCOUNT_OUTPUT = record
        Output: TD3DAUTHENTICATEDCHANNEL_QUERY_OUTPUT;
        NumEncryptionGuids: UINT;
    end;
    TD3DAUTHENTICATEDCHANNEL_QUERYEVICTIONENCRYPTIONGUIDCOUNT_OUTPUT = _D3DAUTHENTICATEDCHANNEL_QUERYEVICTIONENCRYPTIONGUIDCOUNT_OUTPUT;
    PD3DAUTHENTICATEDCHANNEL_QUERYEVICTIONENCRYPTIONGUIDCOUNT_OUTPUT = ^TD3DAUTHENTICATEDCHANNEL_QUERYEVICTIONENCRYPTIONGUIDCOUNT_OUTPUT;



    _D3DAUTHENTICATEDCHANNEL_QUERYEVICTIONENCRYPTIONGUID_INPUT = record
        Input: TD3DAUTHENTICATEDCHANNEL_QUERY_INPUT;
        EncryptionGuidIndex: UINT;
    end;
    TD3DAUTHENTICATEDCHANNEL_QUERYEVICTIONENCRYPTIONGUID_INPUT = _D3DAUTHENTICATEDCHANNEL_QUERYEVICTIONENCRYPTIONGUID_INPUT;
    PD3DAUTHENTICATEDCHANNEL_QUERYEVICTIONENCRYPTIONGUID_INPUT = ^TD3DAUTHENTICATEDCHANNEL_QUERYEVICTIONENCRYPTIONGUID_INPUT;


    _D3DAUTHENTICATEDCHANNEL_QUERYEVICTIONENCRYPTIONGUID_OUTPUT = record
        Output: TD3DAUTHENTICATEDCHANNEL_QUERY_OUTPUT;
        EncryptionGuidIndex: UINT;
        EncryptionGuid: TGUID;
    end;
    TD3DAUTHENTICATEDCHANNEL_QUERYEVICTIONENCRYPTIONGUID_OUTPUT = _D3DAUTHENTICATEDCHANNEL_QUERYEVICTIONENCRYPTIONGUID_OUTPUT;
    PD3DAUTHENTICATEDCHANNEL_QUERYEVICTIONENCRYPTIONGUID_OUTPUT = ^TD3DAUTHENTICATEDCHANNEL_QUERYEVICTIONENCRYPTIONGUID_OUTPUT;




    _D3DAUTHENTICATEDCHANNEL_QUERYUNCOMPRESSEDENCRYPTIONLEVEL_OUTPUT = record
        Output: TD3DAUTHENTICATEDCHANNEL_QUERY_OUTPUT;
        EncryptionGuid: TGUID;
    end;
    TD3DAUTHENTICATEDCHANNEL_QUERYUNCOMPRESSEDENCRYPTIONLEVEL_OUTPUT = _D3DAUTHENTICATEDCHANNEL_QUERYUNCOMPRESSEDENCRYPTIONLEVEL_OUTPUT;
    PD3DAUTHENTICATEDCHANNEL_QUERYUNCOMPRESSEDENCRYPTIONLEVEL_OUTPUT = ^TD3DAUTHENTICATEDCHANNEL_QUERYUNCOMPRESSEDENCRYPTIONLEVEL_OUTPUT;



    _D3DAUTHENTICATEDCHANNEL_CONFIGURE_INPUT = record
        omac: TD3D_OMAC;
        ConfigureType: TGUID;
        hChannel: HANDLE;
        SequenceNumber: UINT;
    end;
    TD3DAUTHENTICATEDCHANNEL_CONFIGURE_INPUT = _D3DAUTHENTICATEDCHANNEL_CONFIGURE_INPUT;
    PD3DAUTHENTICATEDCHANNEL_CONFIGURE_INPUT = ^TD3DAUTHENTICATEDCHANNEL_CONFIGURE_INPUT;


    _D3DAUTHENTICATEDCHANNEL_CONFIGURE_OUTPUT = record
        omac: TD3D_OMAC;
        ConfigureType: TGUID;
        hChannel: HANDLE;
        SequenceNumber: UINT;
        ReturnCode: HRESULT;
    end;
    TD3DAUTHENTICATEDCHANNEL_CONFIGURE_OUTPUT = _D3DAUTHENTICATEDCHANNEL_CONFIGURE_OUTPUT;
    PD3DAUTHENTICATEDCHANNEL_CONFIGURE_OUTPUT = ^TD3DAUTHENTICATEDCHANNEL_CONFIGURE_OUTPUT;



    _D3DAUTHENTICATEDCHANNEL_CONFIGUREINITIALIZE = record
        Parameters: TD3DAUTHENTICATEDCHANNEL_CONFIGURE_INPUT;
        StartSequenceQuery: UINT;
        StartSequenceConfigure: UINT;
    end;
    TD3DAUTHENTICATEDCHANNEL_CONFIGUREINITIALIZE = _D3DAUTHENTICATEDCHANNEL_CONFIGUREINITIALIZE;
    PD3DAUTHENTICATEDCHANNEL_CONFIGUREINITIALIZE = ^TD3DAUTHENTICATEDCHANNEL_CONFIGUREINITIALIZE;


    _D3DAUTHENTICATEDCHANNEL_CONFIGUREPROTECTION = record
        Parameters: TD3DAUTHENTICATEDCHANNEL_CONFIGURE_INPUT;
        Protections: TD3DAUTHENTICATEDCHANNEL_PROTECTION_FLAGS;
    end;
    TD3DAUTHENTICATEDCHANNEL_CONFIGUREPROTECTION = _D3DAUTHENTICATEDCHANNEL_CONFIGUREPROTECTION;
    PD3DAUTHENTICATEDCHANNEL_CONFIGUREPROTECTION = ^TD3DAUTHENTICATEDCHANNEL_CONFIGUREPROTECTION;


    _D3DAUTHENTICATEDCHANNEL_CONFIGURECRYPTOSESSION = record
        Parameters: TD3DAUTHENTICATEDCHANNEL_CONFIGURE_INPUT;
        DXVA2DecodeHandle: HANDLE;
        CryptoSessionHandle: HANDLE;
        DeviceHandle: HANDLE;
    end;
    TD3DAUTHENTICATEDCHANNEL_CONFIGURECRYPTOSESSION = _D3DAUTHENTICATEDCHANNEL_CONFIGURECRYPTOSESSION;
    PD3DAUTHENTICATEDCHANNEL_CONFIGURECRYPTOSESSION = ^TD3DAUTHENTICATEDCHANNEL_CONFIGURECRYPTOSESSION;




    _D3DAUTHENTICATEDCHANNEL_CONFIGURESHAREDRESOURCE = record
        Parameters: TD3DAUTHENTICATEDCHANNEL_CONFIGURE_INPUT;
        ProcessIdentiferType: TD3DAUTHENTICATEDCHANNEL_PROCESSIDENTIFIERTYPE;
        ProcessHandle: HANDLE;
        AllowAccess: boolean;
    end;
    TD3DAUTHENTICATEDCHANNEL_CONFIGURESHAREDRESOURCE = _D3DAUTHENTICATEDCHANNEL_CONFIGURESHAREDRESOURCE;
    PD3DAUTHENTICATEDCHANNEL_CONFIGURESHAREDRESOURCE = ^TD3DAUTHENTICATEDCHANNEL_CONFIGURESHAREDRESOURCE;




    _D3DAUTHENTICATEDCHANNEL_CONFIGUREUNCOMPRESSEDENCRYPTION = record
        Parameters: TD3DAUTHENTICATEDCHANNEL_CONFIGURE_INPUT;
        EncryptionGuid: TGUID;
    end;
    TD3DAUTHENTICATEDCHANNEL_CONFIGUREUNCOMPRESSEDENCRYPTION = _D3DAUTHENTICATEDCHANNEL_CONFIGUREUNCOMPRESSEDENCRYPTION;
    PD3DAUTHENTICATEDCHANNEL_CONFIGUREUNCOMPRESSEDENCRYPTION = ^TD3DAUTHENTICATEDCHANNEL_CONFIGUREUNCOMPRESSEDENCRYPTION;


    _D3DENCRYPTED_BLOCK_INFO = record
        NumEncryptedBytesAtBeginning: UINT;
        NumBytesInSkipPattern: UINT;
        NumBytesInEncryptPattern: UINT;
    end;
    TD3DENCRYPTED_BLOCK_INFO = _D3DENCRYPTED_BLOCK_INFO;
    PD3DENCRYPTED_BLOCK_INFO = ^TD3DENCRYPTED_BLOCK_INFO;


    _D3DAES_CTR_IV = record
        IV: uint64; // Big-Endian IV
        Count: uint64; // Big-Endian Block Count
    end;
    TD3DAES_CTR_IV = _D3DAES_CTR_IV;
    PD3DAES_CTR_IV = ^TD3DAES_CTR_IV;




    (* -- D3D9Ex only *)




    {$PACKRECORDS DEFAULT}



const
    MAXD3DDECLUSAGE = D3DDECLUSAGE_SAMPLE;
    MAXD3DDECLMETHOD = D3DDECLMETHOD_LOOKUPPRESAMPLED;
    MAXD3DDECLTYPE = D3DDECLTYPE_UNUSED;


    D3DTS_WORLD = TD3DTRANSFORMSTATETYPE(0 + 256);
    D3DTS_WORLD1 = TD3DTRANSFORMSTATETYPE(1 + 256);
    D3DTS_WORLD2 = TD3DTRANSFORMSTATETYPE(2 + 256);
    D3DTS_WORLD3 = TD3DTRANSFORMSTATETYPE(3 + 256);

// maps unsigned 8 bits/channel to D3DCOLOR
function D3DCOLOR_ARGB(a, r, g, b: byte): TD3DCOLOR;
function D3DCOLOR_RGBA(r, g, b, a: byte): TD3DCOLOR;
function D3DCOLOR_XRGB(r, g, b: byte): TD3DCOLOR;
function D3DCOLOR_XYUV(y, u, v: byte): TD3DCOLOR;
function D3DCOLOR_AYUV(a, y, u, v: byte): TD3DCOLOR;

// maps floating point channels (0.f to 1.f range) to D3DCOLOR
function D3DCOLOR_COLORVALUE(r, g, b, a: single): TD3DCOLOR;

// pixel shader version token
function D3DPS_VERSION(_Major, _Minor: DWORD): DWORD;
// vertex shader version token
function D3DVS_VERSION(_Major, _Minor: DWORD): DWORD;


// extract major/minor from version cap
function D3DSHADER_VERSION_MAJOR(_Version: DWORD): byte;
function D3DSHADER_VERSION_MINOR(_Version: DWORD): byte;

function D3DFVF_TEXCOORDSIZE3(CoordIndex: DWORD): DWORD;
function D3DFVF_TEXCOORDSIZE2(CoordIndex: DWORD): DWORD;
function D3DFVF_TEXCOORDSIZE4(CoordIndex: DWORD): DWORD;
function D3DFVF_TEXCOORDSIZE1(CoordIndex: DWORD): DWORD;

function D3DSHADER_COMMENT(_DWordSize: DWORD): DWORD;

implementation

// maps floating point channels (0.f to 1.f range) to D3DCOLOR

function D3DCOLOR_COLORVALUE(r, g, b, a: single): TD3DCOLOR;
begin
    Result := D3DCOLOR_RGBA(trunc(r * 255.0), trunc(g * 255.0), trunc(b * 255.0), trunc(a * 255.0));
end;

// maps unsigned 8 bits/channel to D3DCOLOR

function D3DCOLOR_ARGB(a, r, g, b: byte): TD3DCOLOR;
begin
    Result := (((a and $ff) shl 24) or ((r and $ff) shl 16) or ((g and $ff) shl 8) or (b and $ff));
end;



function D3DCOLOR_RGBA(r, g, b, a: byte): TD3DCOLOR;
begin
    Result := D3DCOLOR_ARGB(a, r, g, b);
end;



function D3DCOLOR_XRGB(r, g, b: byte): TD3DCOLOR;
begin
    Result := D3DCOLOR_ARGB($ff, r, g, b);
end;



function D3DCOLOR_XYUV(y, u, v: byte): TD3DCOLOR;
begin
    Result := D3DCOLOR_ARGB($ff, y, u, v);
end;



function D3DCOLOR_AYUV(a, y, u, v: byte): TD3DCOLOR;
begin
    Result := D3DCOLOR_ARGB(a, y, u, v);
end;

// pixel shader version token

function D3DPS_VERSION(_Major, _Minor: DWORD): DWORD;
begin
    Result := ($FFFF0000 or (_Major shl 8) or (_Minor));
end;

// vertex shader version token

function D3DVS_VERSION(_Major, _Minor: DWORD): DWORD;
begin
    Result := ($FFFE0000 or (_Major shl 8) or (_Minor));
end;



// extract major/minor from version cap
function D3DSHADER_VERSION_MAJOR(_Version: DWORD): byte;
begin
    Result := ((_Version shr 8) and $FF);
end;



function D3DSHADER_VERSION_MINOR(_Version: DWORD): byte;
begin
    Result := ((_Version shr 0) and $FF);
end;



function D3DFVF_TEXCOORDSIZE3(CoordIndex: DWORD): DWORD;
begin
    Result := (D3DFVF_TEXTUREFORMAT3 shl (CoordIndex * 2 + 16));
end;



function D3DFVF_TEXCOORDSIZE2(CoordIndex: DWORD): DWORD;
begin
    Result := (D3DFVF_TEXTUREFORMAT2);
end;



function D3DFVF_TEXCOORDSIZE4(CoordIndex: DWORD): DWORD;
begin
    Result := (D3DFVF_TEXTUREFORMAT4 shl (CoordIndex * 2 + 16));
end;



function D3DFVF_TEXCOORDSIZE1(CoordIndex: DWORD): DWORD;
begin
    Result := (D3DFVF_TEXTUREFORMAT1 shl (CoordIndex * 2 + 16));
end;



function D3DSHADER_COMMENT(_DWordSize: DWORD): DWORD;
begin
    Result := (((_DWordSize shl D3DSI_COMMENTSIZE_SHIFT) and D3DSI_COMMENTSIZE_MASK) or Ord(D3DSIO_COMMENT));
end;


end.
