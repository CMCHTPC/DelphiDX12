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
   Content:    Direct3D types include file

   This unit consists of the following header files
   File name: d3dtypes.h
              d3dvec.inl
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3DTypes;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.DDraw;

    {$Z4}

const

    (*
 * Flags for Enumerate functions
 *)
(*
 * Stop the enumeration
 *)

    D3DENUMRET_CANCEL = DDENUMRET_CANCEL;

(*
 * Continue the enumeration
 *)
    D3DENUMRET_OK = DDENUMRET_OK;


(*
 * Values for clip fields.
 *)
    // Max number of user clipping planes, supported in D3D.



    D3DMAXUSERCLIPPLANES = 32;

    // These bits could be ORed together to use with D3DRENDERSTATE_CLIPPLANEENABLE

    D3DCLIPPLANE0 = (1 shl 0);
    D3DCLIPPLANE1 = (1 shl 1);
    D3DCLIPPLANE2 = (1 shl 2);
    D3DCLIPPLANE3 = (1 shl 3);
    D3DCLIPPLANE4 = (1 shl 4);
    D3DCLIPPLANE5 = (1 shl 5);



    D3DCLIP_LEFT = $00000001;
    D3DCLIP_RIGHT = $00000002;
    D3DCLIP_TOP = $00000004;
    D3DCLIP_BOTTOM = $00000008;
    D3DCLIP_FRONT = $00000010;
    D3DCLIP_BACK = $00000020;
    D3DCLIP_GEN0 = $00000040;
    D3DCLIP_GEN1 = $00000080;
    D3DCLIP_GEN2 = $00000100;
    D3DCLIP_GEN3 = $00000200;
    D3DCLIP_GEN4 = $00000400;
    D3DCLIP_GEN5 = $00000800;

(*
 * Values for d3d status.
 *)
    D3DSTATUS_CLIPUNIONLEFT = D3DCLIP_LEFT;
    D3DSTATUS_CLIPUNIONRIGHT = D3DCLIP_RIGHT;
    D3DSTATUS_CLIPUNIONTOP = D3DCLIP_TOP;
    D3DSTATUS_CLIPUNIONBOTTOM = D3DCLIP_BOTTOM;
    D3DSTATUS_CLIPUNIONFRONT = D3DCLIP_FRONT;
    D3DSTATUS_CLIPUNIONBACK = D3DCLIP_BACK;
    D3DSTATUS_CLIPUNIONGEN0 = D3DCLIP_GEN0;
    D3DSTATUS_CLIPUNIONGEN1 = D3DCLIP_GEN1;
    D3DSTATUS_CLIPUNIONGEN2 = D3DCLIP_GEN2;
    D3DSTATUS_CLIPUNIONGEN3 = D3DCLIP_GEN3;
    D3DSTATUS_CLIPUNIONGEN4 = D3DCLIP_GEN4;
    D3DSTATUS_CLIPUNIONGEN5 = D3DCLIP_GEN5;

    D3DSTATUS_CLIPINTERSECTIONLEFT = $00001000;
    D3DSTATUS_CLIPINTERSECTIONRIGHT = $00002000;
    D3DSTATUS_CLIPINTERSECTIONTOP = $00004000;
    D3DSTATUS_CLIPINTERSECTIONBOTTOM = $00008000;
    D3DSTATUS_CLIPINTERSECTIONFRONT = $00010000;
    D3DSTATUS_CLIPINTERSECTIONBACK = $00020000;
    D3DSTATUS_CLIPINTERSECTIONGEN0 = $00040000;
    D3DSTATUS_CLIPINTERSECTIONGEN1 = $00080000;
    D3DSTATUS_CLIPINTERSECTIONGEN2 = $00100000;
    D3DSTATUS_CLIPINTERSECTIONGEN3 = $00200000;
    D3DSTATUS_CLIPINTERSECTIONGEN4 = $00400000;
    D3DSTATUS_CLIPINTERSECTIONGEN5 = $00800000;
    D3DSTATUS_ZNOTVISIBLE = $01000000;
    (* Do not use 0x80000000 for any status flags in future as it is reserved *)

    D3DSTATUS_CLIPUNIONALL = (D3DSTATUS_CLIPUNIONLEFT or D3DSTATUS_CLIPUNIONRIGHT or D3DSTATUS_CLIPUNIONTOP or D3DSTATUS_CLIPUNIONBOTTOM or D3DSTATUS_CLIPUNIONFRONT or D3DSTATUS_CLIPUNIONBACK or
        D3DSTATUS_CLIPUNIONGEN0 or D3DSTATUS_CLIPUNIONGEN1 or D3DSTATUS_CLIPUNIONGEN2 or D3DSTATUS_CLIPUNIONGEN3 or D3DSTATUS_CLIPUNIONGEN4 or D3DSTATUS_CLIPUNIONGEN5);




    D3DSTATUS_CLIPINTERSECTIONALL = (D3DSTATUS_CLIPINTERSECTIONLEFT or D3DSTATUS_CLIPINTERSECTIONRIGHT or D3DSTATUS_CLIPINTERSECTIONTOP or D3DSTATUS_CLIPINTERSECTIONBOTTOM or
        D3DSTATUS_CLIPINTERSECTIONFRONT or D3DSTATUS_CLIPINTERSECTIONBACK or D3DSTATUS_CLIPINTERSECTIONGEN0 or D3DSTATUS_CLIPINTERSECTIONGEN1 or D3DSTATUS_CLIPINTERSECTIONGEN2 or
        D3DSTATUS_CLIPINTERSECTIONGEN3 or D3DSTATUS_CLIPINTERSECTIONGEN4 or D3DSTATUS_CLIPINTERSECTIONGEN5);




    D3DSTATUS_DEFAULT = (D3DSTATUS_CLIPINTERSECTIONALL or D3DSTATUS_ZNOTVISIBLE);




(*
 * Options for direct transform calls
 *)
    D3DTRANSFORM_CLIPPED = $00000001;
    D3DTRANSFORM_UNCLIPPED = $00000002;




(*
 * Structure defining a light source and its properties.
 *)
    (* flags bits *)

    D3DLIGHT_ACTIVE = $00000001;
    D3DLIGHT_NO_SPECULAR = $00000002;
    D3DLIGHT_ALL = (D3DLIGHT_ACTIVE or D3DLIGHT_NO_SPECULAR);

    (* maximum valid light range *)
    FLT_MAX = 3.402823466e+38;
    D3DLIGHT_RANGE_MAX: single = sqrt(FLT_MAX);


(*
 * Before DX5, these values were in an enum called
 * D3DCOLORMODEL. This was not correct, since they are
 * bit flags. A driver can surface either or both flags
 * in the dcmColorModel member of D3DDEVICEDESC.
 *)
    D3DCOLOR_MONO = 1;
    D3DCOLOR_RGB = 2;
   (*
 * Options for clearing
 *)
    D3DCLEAR_TARGET = $00000001; (* Clear target surface *)
    D3DCLEAR_ZBUFFER = $00000002; (* Clear target z buffer *)
    D3DCLEAR_STENCIL = $00000004; (* Clear stencil planes *)


(*
 * Amount to add to a state to generate the override for that state.
 *)
    D3DSTATE_OVERRIDE_BIAS = 256;




    // Bias to apply to the texture coordinate set to apply a wrap to.
    D3DRENDERSTATE_WRAPBIAS = 128;

    (* Flags to construct the WRAP render states *)
    D3DWRAP_U = $00000001;
    D3DWRAP_V = $00000002;



    (* Flags to construct the WRAP render states for 1D thru 4D texture coordinates *)
    D3DWRAPCOORD_0 = $00000001; // same as D3DWRAP_U
    D3DWRAPCOORD_1 = $00000002; // same as D3DWRAP_V
    D3DWRAPCOORD_2 = $00000004;
    D3DWRAPCOORD_3 = $00000008;


    D3DPROCESSVERTICES_TRANSFORMLIGHT = $00000000;
    D3DPROCESSVERTICES_TRANSFORM = $00000001;
    D3DPROCESSVERTICES_COPY = $00000002;
    D3DPROCESSVERTICES_OPMASK = $00000007;

    D3DPROCESSVERTICES_UPDATEEXTENTS = $00000008;
    D3DPROCESSVERTICES_NOCOLOR = $00000010;



    // Values, used with D3DTSS_TEXCOORDINDEX, to specify that the vertex data(position
    // and normal in the camera space) should be taken as texture coordinates
    // Low 16 bits are used to specify texture coordinate index, to take the WRAP mode from

    D3DTSS_TCI_PASSTHRU = $00000000;
    D3DTSS_TCI_CAMERASPACENORMAL = $00010000;
    D3DTSS_TCI_CAMERASPACEPOSITION = $00020000;
    D3DTSS_TCI_CAMERASPACEREFLECTIONVECTOR = $00030000;


(*
 * Values for COLORARG1,2 and ALPHAARG1,2 texture blending operations
 * set in texture processing stage controls in D3DRENDERSTATE.
 *)
    D3DTA_SELECTMASK = $0000000f; // mask for arg selector
    D3DTA_DIFFUSE = $00000000; // select diffuse color
    D3DTA_CURRENT = $00000001; // select result of previous stage
    D3DTA_TEXTURE = $00000002; // select texture color
    D3DTA_TFACTOR = $00000003; // select RENDERSTATE_TEXTUREFACTOR

    D3DTA_SPECULAR = $00000004; // select specular color

    D3DTA_COMPLEMENT = $00000010; // take 1.0 - x
    D3DTA_ALPHAREPLICATE = $00000020; // replicate alpha to color components




(*
 * Triangle flags
 *)
(*
 * Tri strip and fan flags.
 * START loads all three vertices
 * EVEN and ODD load just v3 with even or odd culling
 * START_FLAT contains a count from 0 to 29 that allows the
 * whole strip or fan to be culled in one hit.
 * e.g. for a quad len = 1
 *)

    D3DTRIFLAG_START = $00000000;
    D3DTRIFLAG_ODD = $0000001e;
    D3DTRIFLAG_EVEN = $0000001f;

(*
 * Triangle edge flags
 * enable edges for wireframe or antialiasing
 *)
    D3DTRIFLAG_EDGEENABLE1 = $00000100; (* v0-v1 edge *)
    D3DTRIFLAG_EDGEENABLE2 = $00000200; (* v1-v2 edge *)
    D3DTRIFLAG_EDGEENABLE3 = $00000400; (* v2-v0 edge *)
    D3DTRIFLAG_EDGEENABLETRIANGLE = (D3DTRIFLAG_EDGEENABLE1 or D3DTRIFLAG_EDGEENABLE2 or D3DTRIFLAG_EDGEENABLE3);



    D3DSETSTATUS_STATUS = $00000001;
    D3DSETSTATUS_EXTENTS = $00000002;
    D3DSETSTATUS_ALL = (D3DSETSTATUS_STATUS or D3DSETSTATUS_EXTENTS);




    D3DCLIPSTATUS_STATUS = $00000001;
    D3DCLIPSTATUS_EXTENTS2 = $00000002;
    D3DCLIPSTATUS_EXTENTS3 = $00000004;




(*
 * Execute options.
 * When calling using D3DEXECUTE_UNCLIPPED all the primitives
 * inside the buffer must be contained within the viewport.
 *)
    D3DEXECUTE_CLIPPED = $00000001;
    D3DEXECUTE_UNCLIPPED = $00000002;


(*
 * Palette flags.
 * This are or'ed with the peFlags in the PALETTEENTRYs passed to DirectDraw.
 *)
    D3DPAL_FREE = $00; (* Renderer may use this entry freely *)
    D3DPAL_READONLY = $40; (* Renderer may not set this entry *)
    D3DPAL_RESERVED = $80; (* Renderer may not use this entry *)




    D3DVBCAPS_SYSTEMMEMORY = $00000800;
    D3DVBCAPS_WRITEONLY = $00010000;
    D3DVBCAPS_OPTIMIZED = $80000000;
    D3DVBCAPS_DONOTCLIP = $00000001;

    (* Vertex Operations for ProcessVertices *)
    D3DVOP_LIGHT = (1 shl 10);
    D3DVOP_TRANSFORM = (1 shl 0);
    D3DVOP_CLIP = (1 shl 2);
    D3DVOP_EXTENTS = (1 shl 3);




(* The maximum number of vertices user can pass to any d3d
   drawing function or to create vertex buffer with
*)
    D3DMAXNUMVERTICES = ((1 shl 16) - 1);
(* The maximum number of primitives user can pass to any d3d
   drawing function.
*)
    D3DMAXNUMPRIMITIVES = ((1 shl 16) - 1);



    (* Bits for dwFlags in ProcessVertices call *)
    D3DPV_DONOTCOPYDATA = (1 shl 0);




    //-------------------------------------------------------------------
    // Flexible vertex format bits




    D3DFVF_RESERVED0 = $001;
    D3DFVF_POSITION_MASK = $00E;
    D3DFVF_XYZ = $002;
    D3DFVF_XYZRHW = $004;

    D3DFVF_XYZB1 = $006;
    D3DFVF_XYZB2 = $008;
    D3DFVF_XYZB3 = $00a;
    D3DFVF_XYZB4 = $00c;
    D3DFVF_XYZB5 = $00e;


    D3DFVF_NORMAL = $010;
    D3DFVF_RESERVED1 = $020;
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

    D3DFVF_RESERVED2 = $f000; // 4 reserved bits



    D3DFVF_VERTEX = (D3DFVF_XYZ or D3DFVF_NORMAL or D3DFVF_TEX1);
    D3DFVF_LVERTEX = (D3DFVF_XYZ or D3DFVF_RESERVED1 or D3DFVF_DIFFUSE or D3DFVF_SPECULAR or D3DFVF_TEX1);

    D3DFVF_TLVERTEX = (D3DFVF_XYZRHW or D3DFVF_DIFFUSE or D3DFVF_SPECULAR or D3DFVF_TEX1);




    D3DDP_MAXTEXCOORD = 8;

    //---------------------------------------------------------------------
    // ComputeSphereVisibility return values

    D3DVIS_INSIDE_FRUSTUM = 0;
    D3DVIS_INTERSECT_FRUSTUM = 1;
    D3DVIS_OUTSIDE_FRUSTUM = 2;
    D3DVIS_INSIDE_LEFT = 0;
    D3DVIS_INTERSECT_LEFT = (1 shl 2);
    D3DVIS_OUTSIDE_LEFT = (2 shl 2);
    D3DVIS_INSIDE_RIGHT = 0;
    D3DVIS_INTERSECT_RIGHT = (1 shl 4);
    D3DVIS_OUTSIDE_RIGHT = (2 shl 4);
    D3DVIS_INSIDE_TOP = 0;
    D3DVIS_INTERSECT_TOP = (1 shl 6);
    D3DVIS_OUTSIDE_TOP = (2 shl 6);
    D3DVIS_INSIDE_BOTTOM = 0;
    D3DVIS_INTERSECT_BOTTOM = (1 shl 8);
    D3DVIS_OUTSIDE_BOTTOM = (2 shl 8);
    D3DVIS_INSIDE_NEAR = 0;
    D3DVIS_INTERSECT_NEAR = (1 shl 10);
    D3DVIS_OUTSIDE_NEAR = (2 shl 10);
    D3DVIS_INSIDE_FAR = 0;
    D3DVIS_INTERSECT_FAR = (1 shl 12);
    D3DVIS_OUTSIDE_FAR = (2 shl 12);

    D3DVIS_MASK_FRUSTUM = (3 shl 0);
    D3DVIS_MASK_LEFT = (3 shl 2);
    D3DVIS_MASK_RIGHT = (3 shl 4);
    D3DVIS_MASK_TOP = (3 shl 6);
    D3DVIS_MASK_BOTTOM = (3 shl 8);
    D3DVIS_MASK_NEAR = (3 shl 10);
    D3DVIS_MASK_FAR = (3 shl 12);




    // To be used with GetInfo()
    D3DDEVINFOID_TEXTUREMANAGER = 1;
    D3DDEVINFOID_D3DTEXTUREMANAGER = 2;
    D3DDEVINFOID_TEXTURING = 3;


    // Macros to set texture coordinate format bits in the FVF id

    D3DFVF_TEXTUREFORMAT2 = 0; // Two floating point values
    D3DFVF_TEXTUREFORMAT1 = 3; // One floating point value
    D3DFVF_TEXTUREFORMAT3 = 1; // Three floating point values
    D3DFVF_TEXTUREFORMAT4 = 2; // Four floating point values




type
    //    {$PACKRECORDS 4}

    (*
 * This definition is shared with other DirectX components whose header files
 * might already have defined it. Therefore, we don't define this type if
 * someone else already has (as indicated by the definition of
 * DX_SHARED_DEFINES). We don't set DX_SHARED_DEFINES here as there are
 * other types in this header that are also shared. The last of these
 * shared defines in this file will set DX_SHARED_DEFINES.
 *)

    (* D3DVALUE is the fundamental Direct3D fractional data type *)
    TD3DVALUE = single;
    PD3DVALUE = ^TD3DVALUE;
    LPD3DVALUE = ^single;
    D3DFIXED = LONG;

    LPD3DVALIDATECALLBACK = function(lpUserArg: LPVOID; dwOffset: DWORD): HRESULT; stdcall;

    LPD3DENUMTEXTUREFORMATSCALLBACK = function(lpDdsd: LPDDSURFACEDESC; lpContext: LPVOID): HRESULT; stdcall;

    LPD3DENUMPIXELFORMATSCALLBACK = function(lpDDPixFmt: LPDDPIXELFORMAT; lpContext: LPVOID): HRESULT; stdcall;

    (*
 * This definition is shared with other DirectX components whose header files
 * might already have defined it. Therefore, we don't define this type if
 * someone else already has (as indicated by the definition of
 * DX_SHARED_DEFINES). We don't set DX_SHARED_DEFINES here as there are
 * other types in this header that are also shared. The last of these
 * shared defines in this file will set DX_SHARED_DEFINES.
 *)
    TD3DCOLOR = DWORD;
    LPD3DCOLOR = ^DWORD;


    TD3DMATERIALHANDLE = DWORD;
    LPD3DMATERIALHANDLE = ^DWORD;
    TD3DTEXTUREHANDLE = DWORD;
    LPD3DTEXTUREHANDLE = ^DWORD;
    TD3DMATRIXHANDLE = DWORD;
    LPD3DMATRIXHANDLE = ^TD3DMATRIXHANDLE;

    _D3DCOLORVALUE = record
        case integer of
            0: (r: TD3DVALUE;
                g: TD3DVALUE;
                b: TD3DVALUE;
                a: TD3DVALUE;);
            1: (dvR: TD3DVALUE;
                dvG: TD3DVALUE;
                dvB: TD3DVALUE;
                dvA: TD3DVALUE;);
    end;
    TD3DCOLORVALUE = _D3DCOLORVALUE;
    PD3DCOLORVALUE = ^TD3DCOLORVALUE;
    LPD3DCOLORVALUE = ^TD3DCOLORVALUE;

    _D3DRECT = record
        case integer of
            0: (x1: LONG;
                y1: LONG;
                x2: LONG;
                y2: LONG;);
            1: (lX1: LONG;
                lY1: LONG;
                lX2: LONG;
                lY2: LONG;);
    end;
    TD3DRECT = _D3DRECT;
    PD3DRECT = ^TD3DRECT;
    LPD3DRECT = ^TD3DRECT;

    { _D3DVECTOR }

    _D3DVECTOR = record
    private
        function GetElement(index: integer): single;
        procedure SetElement(index: integer; AValue: single);
    public
        // Constructors
        procedure Init(f: _D3DVECTOR); overload;
        procedure Init(x, y, z: TD3DVALUE); overload;
        procedure Init(f: array of TD3DVALUE); overload;
        procedure Init(f: TD3DVALUE); overload;
        // Access grants
        property Element[index: integer]: single read GetElement write SetElement;
        class operator  Add(a: _D3DVECTOR; b: _D3DVECTOR): _D3DVECTOR;
        class operator Subtract(a: _D3DVECTOR; b: _D3DVECTOR): _D3DVECTOR;
        class operator Multiply(a: _D3DVECTOR; b: _D3DVECTOR): _D3DVECTOR;
        class operator Divide(a: _D3DVECTOR; b: _D3DVECTOR): _D3DVECTOR;
        class operator Multiply(a: _D3DVECTOR; b: TD3DVALUE): _D3DVECTOR;
        class operator Divide(a: _D3DVECTOR; b: TD3DVALUE): _D3DVECTOR;
        class operator Negative(a: _D3DVECTOR): _D3DVECTOR;
        class operator Positive(a: _D3DVECTOR): _D3DVECTOR;

        class operator LessThan(a: _D3DVECTOR; b: _D3DVECTOR): boolean;
        class operator GreaterThan(a: _D3DVECTOR; b: _D3DVECTOR): boolean;
        class operator GreaterThanOrEqual(a: _D3DVECTOR; b: _D3DVECTOR): boolean;
        class operator LessThanOrEqual(a: _D3DVECTOR; b: _D3DVECTOR): boolean;

        class operator Equal(a: _D3DVECTOR; b: _D3DVECTOR): boolean;

        // Length-related functions
        function SquareMagnitude(v: _D3DVECTOR): TD3DVALUE;
        function Magnitude(v: _D3DVECTOR): TD3DVALUE;

        // Returns vector with same direction and unit length
        function Normalize(v: _D3DVECTOR): _D3DVECTOR;

        // Return min/max component of the input vector
        function Min(v: _D3DVECTOR): TD3DVALUE;
        function Max(v: _D3DVECTOR): TD3DVALUE;

        // Return memberwise min/max of input vectors
        function Minimize(v1: _D3DVECTOR; v2: _D3DVECTOR): _D3DVECTOR;
        function Maximize(v1: _D3DVECTOR; v2: _D3DVECTOR): _D3DVECTOR;

        // Dot and cross product
        function DotProduct(v1: _D3DVECTOR; v2: _D3DVECTOR): TD3DVALUE;
        function CrossProduct(v1: _D3DVECTOR; v2: _D3DVECTOR): _D3DVECTOR;
        case integer of
            0: (x: TD3DVALUE;
                y: TD3DVALUE;
                z: TD3DVALUE;);
            1: (dvX: TD3DVALUE;
                dvY: TD3DVALUE;
                dvZ: TD3DVALUE;);
            2: (f: array [0..2] of TD3DVALUE);
    end;

    TD3DVECTOR = ^_D3DVECTOR;
    LPD3DVECTOR = ^TD3DVECTOR;


    (*
 * Vertex data types supported in an ExecuteBuffer.
 *)

(*
 * Homogeneous vertices
 *)

    _D3DHVERTEX = record
        dwFlags: DWORD;        (* Homogeneous clipping flags *)

        case integer of
            0: (hx: TD3DVALUE;
                hy: TD3DVALUE;
                hz: TD3DVALUE;);
            1: (dvHX: TD3DVALUE;
                dvHY: TD3DVALUE;
                dvHZ: TD3DVALUE;);
    end;
    TD3DHVERTEX = _D3DHVERTEX;
    PD3DHVERTEX = ^TD3DHVERTEX;
    LPD3DHVERTEX = ^TD3DHVERTEX;

     (*
 * Transformed/lit vertices
 *)

    { _D3DTLVERTEX }

    _D3DTLVERTEX = record
        procedure Init(v: TD3DVECTOR; _rhw: single; _color: TD3DCOLOR; _specular: TD3DCOLOR; _tu, _tv: single);
        case integer of
            0: (
                sx: TD3DVALUE;             (* Screen coordinates *)
                sy: TD3DVALUE;
                sz: TD3DVALUE;
                rhw: TD3DVALUE;        (* Reciprocal of homogeneous w *)
                color: TD3DVALUE;          (* Vertex color *)
                specular: TD3DVALUE;       (* Specular component of vertex *)
                tu: TD3DVALUE;             (* Texture coordinates *)
                tv: TD3DVALUE;);
            1: (
                dvSX: TD3DVALUE;
                dvSY: TD3DVALUE;
                dvSZ: TD3DVALUE;
                dvRHW: TD3DVALUE;
                dcColor: TD3DVALUE;
                dcSpecular: TD3DVALUE;
                dvTU: TD3DVALUE;
                dvTV: TD3DVALUE;);
    end;
    TD3DTLVERTEX = _D3DTLVERTEX;
    PD3DTLVERTEX = ^TD3DTLVERTEX;
    LPD3DTLVERTEX = ^TD3DTLVERTEX;


    (*
 * Untransformed/lit vertices
 *)

    { _D3DLVERTEX }

    _D3DLVERTEX = record
        procedure Init(v: TD3DVECTOR; _color: TD3DCOLOR; _specular: TD3DCOLOR; _tu, _tv: single);
        case integer of
            0: (x: TD3DVALUE;             (* Homogeneous coordinates *)
                y: TD3DVALUE;
                z: TD3DVALUE;
                dwReserved: DWORD;
                case byte of
                    0: (
                    color: TD3DVALUE;         (* Vertex color *)
                    specular: TD3DVALUE;      (* Specular component of vertex*)
                    tu: TD3DVALUE;            (* Texture coordinates *)
                    tv: TD3DVALUE;);
                    1: (dcColor: TD3DVALUE;
                    dcSpecular: TD3DVALUE;
                    dvTU: TD3DVALUE;
                    dvTV: TD3DVALUE;);

            );
            1: (dvX: TD3DVALUE;
                dvY: TD3DVALUE;
                dvZ: TD3DVALUE;)
    end;
    TD3DLVERTEX = _D3DLVERTEX;
    PD3DLVERTEX = ^TD3DLVERTEX;
    LPD3DLVERTEX = ^TD3DLVERTEX;

(*
 * Untransformed/unlit vertices
 *)

    { _D3DVERTEX }

    _D3DVERTEX = record
        procedure Init(v, n: TD3DVECTOR; _tu, _tv: single);
        case integer of
            0: (
                x: TD3DVALUE;             (* Homogeneous coordinates *)
                y: TD3DVALUE;
                z: TD3DVALUE;
                nx: TD3DVALUE;        (* Normal *)
                ny: TD3DVALUE;
                nz: TD3DVALUE;
                tu: TD3DVALUE;             (* Texture coordinates *)
                tv: TD3DVALUE;);
            1: (
                dvX: TD3DVALUE;
                dvY: TD3DVALUE;
                dvZ: TD3DVALUE;
                dvNX: TD3DVALUE;
                dvNY: TD3DVALUE;
                dvNZ: TD3DVALUE;
                dvTU: TD3DVALUE;
                dvTV: TD3DVALUE;);
    end;
    TD3DVERTEX = _D3DVERTEX;
    PD3DVERTEX = ^TD3DVERTEX;
    LPD3DVERTEX = ^TD3DVERTEX;


(*
 * Matrix, viewport, and tranformation structures and definitions.
 *)

    { _D3DMATRIX }

    _D3DMATRIX = record
        procedure Init(_m00, _m01, _m02, _m03, _m10, _m11, _m12, _m13, _m20, _m21, _m22, _m23, _m30, _m31, _m32, _m33: TD3DVALUE);
        function Element(iRow, iColumn: integer): TD3DVALUE;
        class operator Multiply(a: _D3DMATRIX; b: _D3DMATRIX): _D3DMATRIX;
        case integer of
            0: (
                _11, _12, _13, _14: TD3DVALUE;
                _21, _22, _23, _24: TD3DVALUE;
                _31, _32, _33, _34: TD3DVALUE;
                _41, _42, _43, _44: TD3DVALUE;
            );
            1: (m: array [0..3, 0..3] of TD3DVALUE;);
    end;
    TD3DMATRIX = _D3DMATRIX;
    PD3DMATRIX = ^TD3DMATRIX;
    LPD3DMATRIX = ^TD3DMATRIX;



    T_D3DVIEWPORT = record
        dwSize: DWORD;
        dwX: DWORD;
        dwY: DWORD; (* Top left *)
        dwWidth: DWORD;
        dwHeight: DWORD; (* Dimensions *)
        dvScaleX: TD3DVALUE; (* Scale homogeneous to screen *)
        dvScaleY: TD3DVALUE; (* Scale homogeneous to screen *)
        dvMaxX: TD3DVALUE; (* Min/max homogeneous x coord *)
        dvMaxY: TD3DVALUE; (* Min/max homogeneous y coord *)
        dvMinZ: TD3DVALUE;
        dvMaxZ: TD3DVALUE; (* Min/max homogeneous z coord *)
    end;
    P_D3DVIEWPORT = ^T_D3DVIEWPORT;

    TD3DVIEWPORT = T_D3DVIEWPORT;
    LPD3DVIEWPORT = ^T_D3DVIEWPORT;


    T_D3DVIEWPORT2 = record
        dwSize: DWORD;
        dwX: DWORD;
        dwY: DWORD; (* Viewport Top left *)
        dwWidth: DWORD;
        dwHeight: DWORD; (* Viewport Dimensions *)
        dvClipX: TD3DVALUE; (* Top left of clip volume *)
        dvClipY: TD3DVALUE;
        dvClipWidth: TD3DVALUE; (* Clip Volume Dimensions *)
        dvClipHeight: TD3DVALUE;
        dvMinZ: TD3DVALUE; (* Min/max of clip Volume *)
        dvMaxZ: TD3DVALUE;
    end;
    P_D3DVIEWPORT2 = ^T_D3DVIEWPORT2;

    TD3DVIEWPORT2 = T_D3DVIEWPORT2;
    LPD3DVIEWPORT2 = ^T_D3DVIEWPORT2;



    T_D3DVIEWPORT7 = record
        dwX: DWORD;
        dwY: DWORD; (* Viewport Top left *)
        dwWidth: DWORD;
        dwHeight: DWORD; (* Viewport Dimensions *)
        dvMinZ: TD3DVALUE; (* Min/max of clip Volume *)
        dvMaxZ: TD3DVALUE;
    end;
    P_D3DVIEWPORT7 = ^T_D3DVIEWPORT7;

    TD3DVIEWPORT7 = T_D3DVIEWPORT7;
    LPD3DVIEWPORT7 = ^T_D3DVIEWPORT7;




    T_D3DTRANSFORMDATA = record
        dwSize: DWORD;
        lpIn: LPVOID; (* Input vertices *)
        dwInSize: DWORD; (* Stride of input vertices *)
        lpOut: LPVOID; (* Output vertices *)
        dwOutSize: DWORD; (* Stride of output vertices *)
        lpHOut: LPD3DHVERTEX; (* Output homogeneous vertices *)
        dwClip: DWORD; (* Clipping hint *)
        dwClipIntersection: DWORD;
        dwClipUnion: DWORD; (* Union of all clip flags *)
        drExtent: TD3DRECT; (* Extent of transformed vertices *)
    end;
    P_D3DTRANSFORMDATA = ^T_D3DTRANSFORMDATA;

    TD3DTRANSFORMDATA = T_D3DTRANSFORMDATA;
    LPD3DTRANSFORMDATA = ^T_D3DTRANSFORMDATA;

(*
 * Structure defining position and direction properties for lighting.
 *)
    T_D3DLIGHTINGELEMENT = record
        dvPosition: TD3DVECTOR; (* Lightable point in model space *)
        dvNormal: TD3DVECTOR; (* Normalised unit vector *)
    end;
    P_D3DLIGHTINGELEMENT = ^T_D3DLIGHTINGELEMENT;

    TD3DLIGHTINGELEMENT = T_D3DLIGHTINGELEMENT;
    LPD3DLIGHTINGELEMENT = ^T_D3DLIGHTINGELEMENT;




    // juhu


(*
 * Structure defining material properties for lighting.
 *)
    _D3DMATERIAL = record
        dwSize: DWORD;
        case integer of
            0: (
                diffuse: TD3DCOLORVALUE; (* Diffuse color RGBA *)
                ambient: TD3DCOLORVALUE; (* Ambient color RGB *)
                specular: TD3DCOLORVALUE; (* Specular 'shininess' *)
                emissive: TD3DCOLORVALUE; (* Emissive color RGB *)
                power: TD3DVALUE; (* Sharpness if specular highlight *)
                hTexture: TD3DTEXTUREHANDLE; (* Handle to texture map *)
                dwRampSize: DWORD;
            );
            1: (
                dcvDiffuse: TD3DCOLORVALUE;
                dcvAmbient: TD3DCOLORVALUE;
                dcvSpecular: TD3DCOLORVALUE;
                dcvEmissive: TD3DCOLORVALUE;
                dvPower: TD3DVALUE;
            );


    end;

    TD3DMATERIAL = _D3DMATERIAL;
    LPD3DMATERIAL = ^TD3DMATERIAL;
    PD3DMATERIAL = ^TD3DMATERIAL;



    _D3DMATERIAL7 = record
        case integer of
            0: (
                diffuse: TD3DCOLORVALUE; (* Diffuse color RGBA *)
                ambient: TD3DCOLORVALUE; (* Ambient color RGB *)
                specular: TD3DCOLORVALUE; (* Specular 'shininess' *)
                emissive: TD3DCOLORVALUE; (* Emissive color RGB *)
                power: TD3DVALUE; (* Sharpness if specular highlight *)
            );
            1: (
                dcvDiffuse: TD3DCOLORVALUE;
                dcvAmbient: TD3DCOLORVALUE;
                dcvSpecular: TD3DCOLORVALUE;
                dcvEmissive: TD3DCOLORVALUE;
                dvPower: TD3DVALUE;
            );
    end;

    TD3DMATERIAL7 = _D3DMATERIAL7;
    LPD3DMATERIAL7 = ^TD3DMATERIAL7;
    PD3DMATERIAL7 = ^TD3DMATERIAL7;



    _D3DLIGHTTYPE = (
        D3DLIGHT_POINT = 1,
        D3DLIGHT_SPOT = 2,
        D3DLIGHT_DIRECTIONAL = 3,
        // Note: The following light type (D3DLIGHT_PARALLELPOINT)
        // is no longer supported from D3D for DX7 onwards.
        D3DLIGHT_PARALLELPOINT = 4,
        D3DLIGHT_GLSPOT = 5,
        D3DLIGHT_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    TD3DLIGHTTYPE = _D3DLIGHTTYPE;
    PD3DLIGHTTYPE = ^TD3DLIGHTTYPE;


(*
 * Structure defining a light source and its properties.
 *)
    _D3DLIGHT = record
        dwSize: DWORD;
        dltType: TD3DLIGHTTYPE; (* Type of light source *)
        dcvColor: TD3DCOLORVALUE; (* Color of light *)
        dvPosition: TD3DVECTOR; (* Position in world space *)
        dvDirection: TD3DVECTOR; (* Direction in world space *)
        dvRange: TD3DVALUE; (* Cutoff range *)
        dvFalloff: TD3DVALUE; (* Falloff *)
        dvAttenuation0: TD3DVALUE; (* Constant attenuation *)
        dvAttenuation1: TD3DVALUE; (* Linear attenuation *)
        dvAttenuation2: TD3DVALUE; (* Quadratic attenuation *)
        dvTheta: TD3DVALUE; (* Inner angle of spotlight cone *)
        dvPhi: TD3DVALUE; (* Outer angle of spotlight cone *)
    end;


    TD3DLIGHT = _D3DLIGHT;
    LPD3DLIGHT = ^TD3DLIGHT;
    PD3DLIGHT = ^TD3DLIGHT;



    _D3DLIGHT7 = record
        dltType: TD3DLIGHTTYPE; (* Type of light source *)
        dcvDiffuse: TD3DCOLORVALUE; (* Diffuse color of light *)
        dcvSpecular: TD3DCOLORVALUE; (* Specular color of light *)
        dcvAmbient: TD3DCOLORVALUE; (* Ambient color of light *)
        dvPosition: TD3DVECTOR; (* Position in world space *)
        dvDirection: TD3DVECTOR; (* Direction in world space *)
        dvRange: TD3DVALUE; (* Cutoff range *)
        dvFalloff: TD3DVALUE; (* Falloff *)
        dvAttenuation0: TD3DVALUE; (* Constant attenuation *)
        dvAttenuation1: TD3DVALUE; (* Linear attenuation *)
        dvAttenuation2: TD3DVALUE; (* Quadratic attenuation *)
        dvTheta: TD3DVALUE; (* Inner angle of spotlight cone *)
        dvPhi: TD3DVALUE; (* Outer angle of spotlight cone *)
    end;


    TD3DLIGHT7 = _D3DLIGHT7;
    LPD3DLIGHT7 = ^TD3DLIGHT7;
    PD3DLIGHT7 = ^TD3DLIGHT7;



    T_D3DLIGHT2 = record
        dwSize: DWORD;
        dltType: TD3DLIGHTTYPE; (* Type of light source *)
        dcvColor: TD3DCOLORVALUE; (* Color of light *)
        dvPosition: TD3DVECTOR; (* Position in world space *)
        dvDirection: TD3DVECTOR; (* Direction in world space *)
        dvRange: TD3DVALUE; (* Cutoff range *)
        dvFalloff: TD3DVALUE; (* Falloff *)
        dvAttenuation0: TD3DVALUE; (* Constant attenuation *)
        dvAttenuation1: TD3DVALUE; (* Linear attenuation *)
        dvAttenuation2: TD3DVALUE; (* Quadratic attenuation *)
        dvTheta: TD3DVALUE; (* Inner angle of spotlight cone *)
        dvPhi: TD3DVALUE; (* Outer angle of spotlight cone *)
        dwFlags: DWORD;
    end;
    P_D3DLIGHT2 = ^T_D3DLIGHT2;

    TD3DLIGHT2 = T_D3DLIGHT2;
    LPD3DLIGHT2 = ^T_D3DLIGHT2;

    T_D3DLIGHTDATA = record
        dwSize: DWORD;
        lpIn: LPD3DLIGHTINGELEMENT; (* Input positions and normals *)
        dwInSize: DWORD; (* Stride of input elements *)
        lpOut: LPD3DTLVERTEX; (* Output colors *)
        dwOutSize: DWORD; (* Stride of output colors *)
    end;
    P_D3DLIGHTDATA = ^T_D3DLIGHTDATA;

    TD3DLIGHTDATA = T_D3DLIGHTDATA;
    LPD3DLIGHTDATA = ^T_D3DLIGHTDATA;
    TD3DCOLORMODEL = DWORD;
  (*
* Execute buffers are allocated via Direct3D.  These buffers may then
* be filled by the application with instructions to execute along with
* vertex data.
*)
  (*
* Supported op codes for execute instructions.
*)
    T_D3DOPCODE = (
        D3DOP_POINT = 1,
        D3DOP_LINE = 2,
        D3DOP_TRIANGLE = 3,
        D3DOP_MATRIXLOAD = 4,
        D3DOP_MATRIXMULTIPLY = 5,
        D3DOP_STATETRANSFORM = 6,
        D3DOP_STATELIGHT = 7,
        D3DOP_STATERENDER = 8,
        D3DOP_PROCESSVERTICES = 9,
        D3DOP_TEXTURELOAD = 10,
        D3DOP_EXIT = 11,
        D3DOP_BRANCHFORWARD = 12,
        D3DOP_SPAN = 13,
        D3DOP_SETSTATUS = 14,
        D3DOP_FORCE_DWORD = $7fffffff(* force 32-bit size enum *)
        );

    P_D3DOPCODE = ^T_D3DOPCODE;

    TD3DOPCODE = T_D3DOPCODE;

    T_D3DINSTRUCTION = record
        bOpcode: byte; (* Instruction opcode *)
        bSize: byte; (* Size of each instruction data unit *)
        wCount: word; (* Count of instruction data units to follow *)
    end;
    P_D3DINSTRUCTION = ^T_D3DINSTRUCTION;

    TD3DINSTRUCTION = T_D3DINSTRUCTION;
    LPD3DINSTRUCTION = ^T_D3DINSTRUCTION;
  (*
* Structure for texture loads
*)
    T_D3DTEXTURELOAD = record
        hDestTexture: TD3DTEXTUREHANDLE;
        hSrcTexture: TD3DTEXTUREHANDLE;
    end;
    P_D3DTEXTURELOAD = ^T_D3DTEXTURELOAD;

    TD3DTEXTURELOAD = T_D3DTEXTURELOAD;
    LPD3DTEXTURELOAD = ^T_D3DTEXTURELOAD;
  (*
* Structure for picking
*)
    T_D3DPICKRECORD = record
        bOpcode: byte;
        bPad: byte;
        dwOffset: DWORD;
        dvZ: TD3DVALUE;
    end;
    P_D3DPICKRECORD = ^T_D3DPICKRECORD;

    TD3DPICKRECORD = T_D3DPICKRECORD;
    LPD3DPICKRECORD = ^T_D3DPICKRECORD;

    T_D3DSHADEMODE = (
        D3DSHADE_FLAT = 1,
        D3DSHADE_GOURAUD = 2,
        D3DSHADE_PHONG = 3,
        D3DSHADE_FORCE_DWORD = $7fffffff(* force 32-bit size enum *)
        );

    P_D3DSHADEMODE = ^T_D3DSHADEMODE;

    TD3DSHADEMODE = T_D3DSHADEMODE;
    T_D3DFILLMODE = (
        D3DFILL_POINT = 1,
        D3DFILL_WIREFRAME = 2,
        D3DFILL_SOLID = 3,
        D3DFILL_FORCE_DWORD = $7fffffff(* force 32-bit size enum *)
        );

    P_D3DFILLMODE = ^T_D3DFILLMODE;

    TD3DFILLMODE = T_D3DFILLMODE;

    T_D3DLINEPATTERN = record
        wRepeatFactor: word;
        wLinePattern: word;
    end;
    P_D3DLINEPATTERN = ^T_D3DLINEPATTERN;

    TD3DLINEPATTERN = T_D3DLINEPATTERN;
    T_D3DTEXTUREFILTER = (
        D3DFILTER_NEAREST = 1,
        D3DFILTER_LINEAR = 2,
        D3DFILTER_MIPNEAREST = 3,
        D3DFILTER_MIPLINEAR = 4,
        D3DFILTER_LINEARMIPNEAREST = 5,
        D3DFILTER_LINEARMIPLINEAR = 6,
        D3DFILTER_FORCE_DWORD = $7fffffff(* force 32-bit size enum *)
        );

    P_D3DTEXTUREFILTER = ^T_D3DTEXTUREFILTER;

    TD3DTEXTUREFILTER = T_D3DTEXTUREFILTER;
    T_D3DBLEND = (
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
        D3DBLEND_FORCE_DWORD = $7fffffff(* force 32-bit size enum *)
        );

    P_D3DBLEND = ^T_D3DBLEND;

    TD3DBLEND = T_D3DBLEND;
    T_D3DTEXTUREBLEND = (
        D3DTBLEND_DECAL = 1,
        D3DTBLEND_MODULATE = 2,
        D3DTBLEND_DECALALPHA = 3,
        D3DTBLEND_MODULATEALPHA = 4,
        D3DTBLEND_DECALMASK = 5,
        D3DTBLEND_MODULATEMASK = 6,
        D3DTBLEND_COPY = 7,

        D3DTBLEND_ADD = 8,
        D3DTBLEND_FORCE_DWORD = $7fffffff(* force 32-bit size enum *)


        );

    P_D3DTEXTUREBLEND = ^T_D3DTEXTUREBLEND;

    TD3DTEXTUREBLEND = T_D3DTEXTUREBLEND;

    T_D3DTEXTUREADDRESS = (
        D3DTADDRESS_WRAP = 1,
        D3DTADDRESS_MIRROR = 2,
        D3DTADDRESS_CLAMP = 3,

        D3DTADDRESS_BORDER = 4,
        D3DTADDRESS_FORCE_DWORD = $7fffffff(* force 32-bit size enum *)

        );

    P_D3DTEXTUREADDRESS = ^T_D3DTEXTUREADDRESS;

    TD3DTEXTUREADDRESS = T_D3DTEXTUREADDRESS;
    T_D3DCULL = (
        D3DCULL_NONE = 1,
        D3DCULL_CW = 2,
        D3DCULL_CCW = 3,
        D3DCULL_FORCE_DWORD = $7fffffff(* force 32-bit size enum *)

        );

    P_D3DCULL = ^T_D3DCULL;

    TD3DCULL = T_D3DCULL;
    T_D3DCMPFUNC = (
        D3DCMP_NEVER = 1,
        D3DCMP_LESS = 2,
        D3DCMP_EQUAL = 3,
        D3DCMP_LESSEQUAL = 4,
        D3DCMP_GREATER = 5,
        D3DCMP_NOTEQUAL = 6,
        D3DCMP_GREATEREQUAL = 7,
        D3DCMP_ALWAYS = 8,
        D3DCMP_FORCE_DWORD = $7fffffff(* force 32-bit size enum *)


        );

    P_D3DCMPFUNC = ^T_D3DCMPFUNC;

    TD3DCMPFUNC = T_D3DCMPFUNC;

    T_D3DSTENCILOP = (
        D3DSTENCILOP_KEEP = 1,
        D3DSTENCILOP_ZERO = 2,
        D3DSTENCILOP_REPLACE = 3,
        D3DSTENCILOP_INCRSAT = 4,
        D3DSTENCILOP_DECRSAT = 5,
        D3DSTENCILOP_INVERT = 6,
        D3DSTENCILOP_INCR = 7,
        D3DSTENCILOP_DECR = 8,
        D3DSTENCILOP_FORCE_DWORD = $7fffffff(* force 32-bit size enum *)
        );

    P_D3DSTENCILOP = ^T_D3DSTENCILOP;

    TD3DSTENCILOP = T_D3DSTENCILOP;
    T_D3DFOGMODE = (
        D3DFOG_NONE = 0,
        D3DFOG_EXP = 1,
        D3DFOG_EXP2 = 2,
        D3DFOG_LINEAR = 3,
        D3DFOG_FORCE_DWORD = $7fffffff(* force 32-bit size enum *)

        );

    P_D3DFOGMODE = ^T_D3DFOGMODE;

    TD3DFOGMODE = T_D3DFOGMODE;

    T_D3DZBUFFERTYPE = (
        D3DZB_FALSE = 0,
        D3DZB_TRUE = 1, // Z buffering
        D3DZB_USEW = 2, // W buffering
        D3DZB_FORCE_DWORD = $7fffffff(* force 32-bit size enum *)
        );

    P_D3DZBUFFERTYPE = ^T_D3DZBUFFERTYPE;

    TD3DZBUFFERTYPE = T_D3DZBUFFERTYPE;

    T_D3DANTIALIASMODE = (
        D3DANTIALIAS_NONE = 0,
        D3DANTIALIAS_SORTDEPENDENT = 1,
        D3DANTIALIAS_SORTINDEPENDENT = 2,
        D3DANTIALIAS_FORCE_DWORD = $7fffffff(* force 32-bit size enum *)
        );

    P_D3DANTIALIASMODE = ^T_D3DANTIALIASMODE;

    TD3DANTIALIASMODE = T_D3DANTIALIASMODE;
    // Vertex types supported by Direct3D
    T_D3DVERTEXTYPE = (
        D3DVT_VERTEX = 1,
        D3DVT_LVERTEX = 2,
        D3DVT_TLVERTEX = 3,
        D3DVT_FORCE_DWORD = $7fffffff(* force 32-bit size enum *)
        );

    P_D3DVERTEXTYPE = ^T_D3DVERTEXTYPE;

    TD3DVERTEXTYPE = T_D3DVERTEXTYPE;

    // Primitives supported by draw-primitive API
    T_D3DPRIMITIVETYPE = (
        D3DPT_POINTLIST = 1,
        D3DPT_LINELIST = 2,
        D3DPT_LINESTRIP = 3,
        D3DPT_TRIANGLELIST = 4,
        D3DPT_TRIANGLESTRIP = 5,
        D3DPT_TRIANGLEFAN = 6,
        D3DPT_FORCE_DWORD = $7fffffff(* force 32-bit size enum *)
        );

    P_D3DPRIMITIVETYPE = ^T_D3DPRIMITIVETYPE;

    TD3DPRIMITIVETYPE = T_D3DPRIMITIVETYPE;




    T_D3DTRANSFORMSTATETYPE = (
        D3DTRANSFORMSTATE_WORLD = 1,
        D3DTRANSFORMSTATE_VIEW = 2,
        D3DTRANSFORMSTATE_PROJECTION = 3,
        D3DTRANSFORMSTATE_WORLD1 = 4, // 2nd matrix to blend
        D3DTRANSFORMSTATE_WORLD2 = 5, // 3rd matrix to blend
        D3DTRANSFORMSTATE_WORLD3 = 6, // 4th matrix to blend
        D3DTRANSFORMSTATE_TEXTURE0 = 16,
        D3DTRANSFORMSTATE_TEXTURE1 = 17,
        D3DTRANSFORMSTATE_TEXTURE2 = 18,
        D3DTRANSFORMSTATE_TEXTURE3 = 19,
        D3DTRANSFORMSTATE_TEXTURE4 = 20,
        D3DTRANSFORMSTATE_TEXTURE5 = 21,
        D3DTRANSFORMSTATE_TEXTURE6 = 22,
        D3DTRANSFORMSTATE_TEXTURE7 = 23,
        D3DTRANSFORMSTATE_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    P_D3DTRANSFORMSTATETYPE = ^T_D3DTRANSFORMSTATETYPE;

    TD3DTRANSFORMSTATETYPE = T_D3DTRANSFORMSTATETYPE;


    T_D3DLIGHTSTATETYPE = (
        D3DLIGHTSTATE_MATERIAL = 1,
        D3DLIGHTSTATE_AMBIENT = 2,
        D3DLIGHTSTATE_COLORMODEL = 3,
        D3DLIGHTSTATE_FOGMODE = 4,
        D3DLIGHTSTATE_FOGSTART = 5,
        D3DLIGHTSTATE_FOGEND = 6,
        D3DLIGHTSTATE_FOGDENSITY = 7,
        D3DLIGHTSTATE_COLORVERTEX = 8,
        D3DLIGHTSTATE_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    P_D3DLIGHTSTATETYPE = ^T_D3DLIGHTSTATETYPE;

    TD3DLIGHTSTATETYPE = T_D3DLIGHTSTATETYPE;



    _D3DRENDERSTATETYPE = (
        D3DRENDERSTATE_ANTIALIAS = 2, (* D3DANTIALIASMODE *)
        D3DRENDERSTATE_TEXTUREPERSPECTIVE = 4, (* TRUE for perspective correction *)
        D3DRENDERSTATE_ZENABLE = 7, (* D3DZBUFFERTYPE (or TRUE/FALSE for legacy) *)
        D3DRENDERSTATE_FILLMODE = 8, (* D3DFILL_MODE        *)
        D3DRENDERSTATE_SHADEMODE = 9, (* D3DSHADEMODE *)
        D3DRENDERSTATE_LINEPATTERN = 10, (* D3DLINEPATTERN *)
        D3DRENDERSTATE_ZWRITEENABLE = 14, (* TRUE to enable z writes *)
        D3DRENDERSTATE_ALPHATESTENABLE = 15, (* TRUE to enable alpha tests *)
        D3DRENDERSTATE_LASTPIXEL = 16, (* TRUE for last-pixel on lines *)
        D3DRENDERSTATE_SRCBLEND = 19, (* D3DBLEND *)
        D3DRENDERSTATE_DESTBLEND = 20, (* D3DBLEND *)
        D3DRENDERSTATE_CULLMODE = 22, (* D3DCULL *)
        D3DRENDERSTATE_ZFUNC = 23, (* D3DCMPFUNC *)
        D3DRENDERSTATE_ALPHAREF = 24, (* D3DFIXED *)
        D3DRENDERSTATE_ALPHAFUNC = 25, (* D3DCMPFUNC *)
        D3DRENDERSTATE_DITHERENABLE = 26, (* TRUE to enable dithering *)
        D3DRENDERSTATE_ALPHABLENDENABLE = 27, (* TRUE to enable alpha blending *)
        D3DRENDERSTATE_FOGENABLE = 28, (* TRUE to enable fog blending *)
        D3DRENDERSTATE_SPECULARENABLE = 29, (* TRUE to enable specular *)
        D3DRENDERSTATE_ZVISIBLE = 30, (* TRUE to enable z checking *)
        D3DRENDERSTATE_STIPPLEDALPHA = 33, (* TRUE to enable stippled alpha (RGB device only) *)
        D3DRENDERSTATE_FOGCOLOR = 34, (* D3DCOLOR *)
        D3DRENDERSTATE_FOGTABLEMODE = 35, (* D3DFOGMODE *)
        D3DRENDERSTATE_FOGSTART = 36, (* Fog start (for both vertex and pixel fog) *)
        D3DRENDERSTATE_FOGEND = 37, (* Fog end      *)
        D3DRENDERSTATE_FOGDENSITY = 38, (* Fog density  *)
        D3DRENDERSTATE_EDGEANTIALIAS = 40, (* TRUE to enable edge antialiasing *)
        D3DRENDERSTATE_COLORKEYENABLE = 41, (* TRUE to enable source colorkeyed textures *)
        D3DRENDERSTATE_ZBIAS = 47, (* LONG Z bias *)
        D3DRENDERSTATE_RANGEFOGENABLE = 48, (* Enables range-based fog *)
        D3DRENDERSTATE_STENCILENABLE = 52, (* BOOL enable/disable stenciling *)
        D3DRENDERSTATE_STENCILFAIL = 53, (* D3DSTENCILOP to do if stencil test fails *)
        D3DRENDERSTATE_STENCILZFAIL = 54, (* D3DSTENCILOP to do if stencil test passes and Z test fails *)
        D3DRENDERSTATE_STENCILPASS = 55, (* D3DSTENCILOP to do if both stencil and Z tests pass *)
        D3DRENDERSTATE_STENCILFUNC = 56, (* D3DCMPFUNC fn.  Stencil Test passes if ((ref & mask) stencilfn (stencil & mask)) is true *)
        D3DRENDERSTATE_STENCILREF = 57, (* Reference value used in stencil test *)
        D3DRENDERSTATE_STENCILMASK = 58, (* Mask value used in stencil test *)
        D3DRENDERSTATE_STENCILWRITEMASK = 59, (* Write mask applied to values written to stencil buffer *)
        D3DRENDERSTATE_TEXTUREFACTOR = 60, (* D3DCOLOR used for multi-texture blend *)
    (*
     * 128 values [128, 255] are reserved for texture coordinate wrap flags.
     * These are constructed with the D3DWRAP_U and D3DWRAP_V macros. Using
     * a flags word preserves forward compatibility with texture coordinates
     * that are >2D.
     *)
        D3DRENDERSTATE_WRAP0 = 128, (* wrap for 1st texture coord. set *)
        D3DRENDERSTATE_WRAP1 = 129, (* wrap for 2nd texture coord. set *)
        D3DRENDERSTATE_WRAP2 = 130, (* wrap for 3rd texture coord. set *)
        D3DRENDERSTATE_WRAP3 = 131, (* wrap for 4th texture coord. set *)
        D3DRENDERSTATE_WRAP4 = 132, (* wrap for 5th texture coord. set *)
        D3DRENDERSTATE_WRAP5 = 133, (* wrap for 6th texture coord. set *)
        D3DRENDERSTATE_WRAP6 = 134, (* wrap for 7th texture coord. set *)
        D3DRENDERSTATE_WRAP7 = 135, (* wrap for 8th texture coord. set *)
        D3DRENDERSTATE_CLIPPING = 136,
        D3DRENDERSTATE_LIGHTING = 137,
        D3DRENDERSTATE_EXTENTS = 138,
        D3DRENDERSTATE_AMBIENT = 139,
        D3DRENDERSTATE_FOGVERTEXMODE = 140,
        D3DRENDERSTATE_COLORVERTEX = 141,
        D3DRENDERSTATE_LOCALVIEWER = 142,
        D3DRENDERSTATE_NORMALIZENORMALS = 143,
        D3DRENDERSTATE_COLORKEYBLENDENABLE = 144,
        D3DRENDERSTATE_DIFFUSEMATERIALSOURCE = 145,
        D3DRENDERSTATE_SPECULARMATERIALSOURCE = 146,
        D3DRENDERSTATE_AMBIENTMATERIALSOURCE = 147,
        D3DRENDERSTATE_EMISSIVEMATERIALSOURCE = 148,
        D3DRENDERSTATE_VERTEXBLEND = 151,
        D3DRENDERSTATE_CLIPPLANEENABLE = 152,

        // retired renderstates - not supported for DX7 interfaces

        D3DRENDERSTATE_TEXTUREHANDLE = 1, (* Texture handle for legacy interfaces (Texture,Texture2) *)
        D3DRENDERSTATE_TEXTUREADDRESS = 3, (* D3DTEXTUREADDRESS  *)
        D3DRENDERSTATE_WRAPU = 5, (* TRUE for wrapping in u *)
        D3DRENDERSTATE_WRAPV = 6, (* TRUE for wrapping in v *)
        D3DRENDERSTATE_MONOENABLE = 11, (* TRUE to enable mono rasterization *)
        D3DRENDERSTATE_ROP2 = 12, (* ROP2 *)
        D3DRENDERSTATE_PLANEMASK = 13, (* DWORD physical plane mask *)
        D3DRENDERSTATE_TEXTUREMAG = 17, (* D3DTEXTUREFILTER *)
        D3DRENDERSTATE_TEXTUREMIN = 18, (* D3DTEXTUREFILTER *)
        D3DRENDERSTATE_TEXTUREMAPBLEND = 21, (* D3DTEXTUREBLEND *)
        D3DRENDERSTATE_SUBPIXEL = 31, (* TRUE to enable subpixel correction *)
        D3DRENDERSTATE_SUBPIXELX = 32, (* TRUE to enable correction in X only *)
        D3DRENDERSTATE_STIPPLEENABLE = 39, (* TRUE to enable stippling *)
        D3DRENDERSTATE_BORDERCOLOR = 43, (* Border color for texturing w/border *)
        D3DRENDERSTATE_TEXTUREADDRESSU = 44, (* Texture addressing mode for U coordinate *)
        D3DRENDERSTATE_TEXTUREADDRESSV = 45, (* Texture addressing mode for V coordinate *)
        D3DRENDERSTATE_MIPMAPLODBIAS = 46, (* D3DVALUE Mipmap LOD bias *)
        D3DRENDERSTATE_ANISOTROPY = 49, (* Max. anisotropy. 1 = no anisotropy *)
        D3DRENDERSTATE_FLUSHBATCH = 50, (* Explicit flush for DP batching (DX5 Only) *)
        D3DRENDERSTATE_TRANSLUCENTSORTINDEPENDENT = 51, (* BOOL enable sort-independent transparency *)
        D3DRENDERSTATE_STIPPLEPATTERN00 = 64, (* Stipple pattern 01...  *)
        D3DRENDERSTATE_STIPPLEPATTERN01 = 65,
        D3DRENDERSTATE_STIPPLEPATTERN02 = 66,
        D3DRENDERSTATE_STIPPLEPATTERN03 = 67,
        D3DRENDERSTATE_STIPPLEPATTERN04 = 68,
        D3DRENDERSTATE_STIPPLEPATTERN05 = 69,
        D3DRENDERSTATE_STIPPLEPATTERN06 = 70,
        D3DRENDERSTATE_STIPPLEPATTERN07 = 71,
        D3DRENDERSTATE_STIPPLEPATTERN08 = 72,
        D3DRENDERSTATE_STIPPLEPATTERN09 = 73,
        D3DRENDERSTATE_STIPPLEPATTERN10 = 74,
        D3DRENDERSTATE_STIPPLEPATTERN11 = 75,
        D3DRENDERSTATE_STIPPLEPATTERN12 = 76,
        D3DRENDERSTATE_STIPPLEPATTERN13 = 77,
        D3DRENDERSTATE_STIPPLEPATTERN14 = 78,
        D3DRENDERSTATE_STIPPLEPATTERN15 = 79,
        D3DRENDERSTATE_STIPPLEPATTERN16 = 80,
        D3DRENDERSTATE_STIPPLEPATTERN17 = 81,
        D3DRENDERSTATE_STIPPLEPATTERN18 = 82,
        D3DRENDERSTATE_STIPPLEPATTERN19 = 83,
        D3DRENDERSTATE_STIPPLEPATTERN20 = 84,
        D3DRENDERSTATE_STIPPLEPATTERN21 = 85,
        D3DRENDERSTATE_STIPPLEPATTERN22 = 86,
        D3DRENDERSTATE_STIPPLEPATTERN23 = 87,
        D3DRENDERSTATE_STIPPLEPATTERN24 = 88,
        D3DRENDERSTATE_STIPPLEPATTERN25 = 89,
        D3DRENDERSTATE_STIPPLEPATTERN26 = 90,
        D3DRENDERSTATE_STIPPLEPATTERN27 = 91,
        D3DRENDERSTATE_STIPPLEPATTERN28 = 92,
        D3DRENDERSTATE_STIPPLEPATTERN29 = 93,
        D3DRENDERSTATE_STIPPLEPATTERN30 = 94,
        D3DRENDERSTATE_STIPPLEPATTERN31 = 95,

        // retired renderstate names - the values are still used under new naming conventions

        D3DRENDERSTATE_FOGTABLESTART = 36, (* Fog table start    *)
        D3DRENDERSTATE_FOGTABLEEND = 37, (* Fog table end      *)
        D3DRENDERSTATE_FOGTABLEDENSITY = 38, (* Fog table density  *)
        D3DRENDERSTATE_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));



    TD3DRENDERSTATETYPE = _D3DRENDERSTATETYPE;
    PD3DRENDERSTATETYPE = ^TD3DRENDERSTATETYPE;




    // Values for material source
    T_D3DMATERIALCOLORSOURCE = (
        D3DMCS_MATERIAL = 0, // Color from material is used
        D3DMCS_COLOR1 = 1, // Diffuse vertex color is used
        D3DMCS_COLOR2 = 2, // Specular vertex color is used
        D3DMCS_FORCE_DWORD = $7fffffff// force 32-bit size enum
        );

    P_D3DMATERIALCOLORSOURCE = ^T_D3DMATERIALCOLORSOURCE;

    TD3DMATERIALCOLORSOURCE = T_D3DMATERIALCOLORSOURCE;



    T_D3DSTATE = record
        case integer of
            0: (
                dtstTransformStateType: TD3DTRANSFORMSTATETYPE;
                case integer of
                    0: (
                    dwArg: PDWORD;
                    );
                    1: (
                    dvArg: PD3DVALUE;
                    );
            );
            1: (
                dlstLightStateType: TD3DLIGHTSTATETYPE;
            );
            2: (
                drstRenderStateType: TD3DRENDERSTATETYPE;
            );



    end;
    P_D3DSTATE = ^T_D3DSTATE;

    TD3DSTATE = T_D3DSTATE;
    LPD3DSTATE = ^T_D3DSTATE;


(*
 * Operation used to load matrices
 * hDstMat = hSrcMat
 *)
    T_D3DMATRIXLOAD = record
        hDestMatrix: TD3DMATRIXHANDLE; (* Destination matrix *)
        hSrcMatrix: TD3DMATRIXHANDLE; (* Source matrix *)
    end;
    P_D3DMATRIXLOAD = ^T_D3DMATRIXLOAD;

    TD3DMATRIXLOAD = T_D3DMATRIXLOAD;
    LPD3DMATRIXLOAD = ^T_D3DMATRIXLOAD;

(*
 * Operation used to multiply matrices
 * hDstMat = hSrcMat1 * hSrcMat2
 *)
    T_D3DMATRIXMULTIPLY = record
        hDestMatrix: TD3DMATRIXHANDLE; (* Destination matrix *)
        hSrcMatrix1: TD3DMATRIXHANDLE; (* First source matrix *)
        hSrcMatrix2: TD3DMATRIXHANDLE; (* Second source matrix *)
    end;
    P_D3DMATRIXMULTIPLY = ^T_D3DMATRIXMULTIPLY;

    TD3DMATRIXMULTIPLY = T_D3DMATRIXMULTIPLY;
    LPD3DMATRIXMULTIPLY = ^T_D3DMATRIXMULTIPLY;

(*
 * Operation used to transform and light vertices.
 *)
    T_D3DPROCESSVERTICES = record
        dwFlags: DWORD; (* Do we transform or light or just copy? *)
        wStart: word; (* Index to first vertex in source *)
        wDest: word; (* Index to first vertex in local buffer *)
        dwCount: DWORD; (* Number of vertices to be processed *)
        dwReserved: DWORD; (* Must be zero *)
    end;
    P_D3DPROCESSVERTICES = ^T_D3DPROCESSVERTICES;

    TD3DPROCESSVERTICES = T_D3DPROCESSVERTICES;
    LPD3DPROCESSVERTICES = ^T_D3DPROCESSVERTICES;



(*
 * State enumerants for per-stage texture processing.
 *)
    T_D3DTEXTURESTAGESTATETYPE = (
        D3DTSS_COLOROP = 1, (* D3DTEXTUREOP - per-stage blending controls for color channels *)
        D3DTSS_COLORARG1 = 2, (* D3DTA_* (texture arg) *)
        D3DTSS_COLORARG2 = 3, (* D3DTA_* (texture arg) *)
        D3DTSS_ALPHAOP = 4, (* D3DTEXTUREOP - per-stage blending controls for alpha channel *)
        D3DTSS_ALPHAARG1 = 5, (* D3DTA_* (texture arg) *)
        D3DTSS_ALPHAARG2 = 6, (* D3DTA_* (texture arg) *)
        D3DTSS_BUMPENVMAT00 = 7, (* D3DVALUE (bump mapping matrix) *)
        D3DTSS_BUMPENVMAT01 = 8, (* D3DVALUE (bump mapping matrix) *)
        D3DTSS_BUMPENVMAT10 = 9, (* D3DVALUE (bump mapping matrix) *)
        D3DTSS_BUMPENVMAT11 = 10, (* D3DVALUE (bump mapping matrix) *)
        D3DTSS_TEXCOORDINDEX = 11, (* identifies which set of texture coordinates index this texture *)
        D3DTSS_ADDRESS = 12, (* D3DTEXTUREADDRESS for both coordinates *)
        D3DTSS_ADDRESSU = 13, (* D3DTEXTUREADDRESS for U coordinate *)
        D3DTSS_ADDRESSV = 14, (* D3DTEXTUREADDRESS for V coordinate *)
        D3DTSS_BORDERCOLOR = 15, (* D3DCOLOR *)
        D3DTSS_MAGFILTER = 16, (* D3DTEXTUREMAGFILTER filter to use for magnification *)
        D3DTSS_MINFILTER = 17, (* D3DTEXTUREMINFILTER filter to use for minification *)
        D3DTSS_MIPFILTER = 18, (* D3DTEXTUREMIPFILTER filter to use between mipmaps during minification *)
        D3DTSS_MIPMAPLODBIAS = 19, (* D3DVALUE Mipmap LOD bias *)
        D3DTSS_MAXMIPLEVEL = 20, (* DWORD 0..(n-1) LOD index of largest map to use (0 == largest) *)
        D3DTSS_MAXANISOTROPY = 21, (* DWORD maximum anisotropy *)
        D3DTSS_BUMPENVLSCALE = 22, (* D3DVALUE scale for bump map luminance *)
        D3DTSS_BUMPENVLOFFSET = 23, (* D3DVALUE offset for bump map luminance *)
        D3DTSS_TEXTURETRANSFORMFLAGS = 24, (* D3DTEXTURETRANSFORMFLAGS controls texture transform *)
        D3DTSS_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    P_D3DTEXTURESTAGESTATETYPE = ^T_D3DTEXTURESTAGESTATETYPE;

    TD3DTEXTURESTAGESTATETYPE = T_D3DTEXTURESTAGESTATETYPE;



(*
 * Enumerations for COLOROP and ALPHAOP texture blending operations set in
 * texture processing stage controls in D3DRENDERSTATE.
 *)
    T_D3DTEXTUREOP = (
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
        D3DTOP_BLENDFACTORALPHA = 14, // alpha from D3DRENDERSTATE_TEXTUREFACTOR
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
        D3DTOP_FORCE_DWORD = $7fffffff);

    P_D3DTEXTUREOP = ^T_D3DTEXTUREOP;

    TD3DTEXTUREOP = T_D3DTEXTUREOP;




(*
 *  IDirect3DTexture2 State Filter Types
 *)
    T_D3DTEXTUREMAGFILTER = (
        D3DTFG_POINT = 1, // nearest
        D3DTFG_LINEAR = 2, // linear interpolation
        D3DTFG_FLATCUBIC = 3, // cubic
        D3DTFG_GAUSSIANCUBIC = 4, // different cubic kernel
        D3DTFG_ANISOTROPIC = 5,
        D3DTFG_FORCE_DWORD = $7fffffff// force 32-bit size enum
        );

    P_D3DTEXTUREMAGFILTER = ^T_D3DTEXTUREMAGFILTER;

    TD3DTEXTUREMAGFILTER = T_D3DTEXTUREMAGFILTER;

    T_D3DTEXTUREMINFILTER = (
        D3DTFN_POINT = 1, // nearest
        D3DTFN_LINEAR = 2, // linear interpolation
        D3DTFN_ANISOTROPIC = 3,
        D3DTFN_FORCE_DWORD = $7fffffff// force 32-bit size enum
        );

    P_D3DTEXTUREMINFILTER = ^T_D3DTEXTUREMINFILTER;

    TD3DTEXTUREMINFILTER = T_D3DTEXTUREMINFILTER;

    T_D3DTEXTUREMIPFILTER = (
        D3DTFP_NONE = 1, // mipmapping disabled (use MAG filter)
        D3DTFP_POINT = 2, // nearest
        D3DTFP_LINEAR = 3, // linear interpolation
        D3DTFP_FORCE_DWORD = $7fffffff// force 32-bit size enum
        );

    P_D3DTEXTUREMIPFILTER = ^T_D3DTEXTUREMIPFILTER;

    TD3DTEXTUREMIPFILTER = T_D3DTEXTUREMIPFILTER;



(*
 * Primitive structures and related defines.  Vertex offsets are to types
 * D3DVERTEX, D3DLVERTEX, or D3DTLVERTEX.
 *)
(*
 * Triangle list primitive structure
 *)

    _D3DTRIANGLE = record
        case integer of
            0: (
                v1: word; (* Vertex indices *)
                v2: word;
                v3: word;
                wFlags: word; (* Edge (and other) flags *)
            );
            1: (
                wV1: word;
                wV2: word;
                wV3: word;
            );

    end;

    TD3DTRIANGLE = _D3DTRIANGLE;
    PD3DTRIANGLE = ^TD3DTRIANGLE;
    LPD3DTRIANGLE = ^TD3DTRIANGLE;

(*
 * Line list structure.
 * The instruction count defines the number of line segments.
 *)
    _D3DLINE = record
        case integer of
            0: (
                v1: word; (* Vertex indices *)
                v2: word;
            );
            1: (
                wV1: word;
                wV2: word;
            );

    end;


    TD3DLINE = _D3DLINE;
    PD3DLINE = ^TD3DLINE;
    LPD3DLINE = ^TD3DLINE;

(*
 * Span structure
 * Spans join a list of points with the same y value.
 * If the y value changes, a new span is started.
 *)
    _D3DSPAN = record
        wCount: word; (* Number of spans *)
        wFirst: word; (* Index to first vertex *)
    end;


    TD3DSPAN = _D3DSPAN;
    PD3DSPAN = ^TD3DSPAN;
    LPD3DSPAN = ^TD3DSPAN;

(*
 * Point structure
 *)
    _D3DPOINT = record
        wCount: word; (* number of points     *)
        wFirst: word; (* index to first vertex    *)
    end;


    TD3DPOINT = _D3DPOINT;
    PD3DPOINT = ^TD3DPOINT;
    LPD3DPOINT = ^TD3DPOINT;


(*
 * Forward branch structure.
 * Mask is logically anded with the driver status mask
 * if the result equals 'value', the branch is taken.
 *)
    _D3DBRANCH = record
        dwMask: DWORD; (* Bitmask against D3D status *)
        dwValue: DWORD;
        bNegate: boolean; (* TRUE to negate comparison *)
        dwOffset: DWORD; (* How far to branch forward (0 for exit)*)
    end;


    TD3DBRANCH = _D3DBRANCH;
    PD3DBRANCH = ^TD3DBRANCH;
    LPD3DBRANCH = ^TD3DBRANCH;

(*
 * Status used for set status instruction.
 * The D3D status is initialised on device creation
 * and is modified by all execute calls.
 *)
    _D3DSTATUS = record
        dwFlags: DWORD; (* Do we set extents or status *)
        dwStatus: DWORD; (* D3D status *)
        drExtent: TD3DRECT;
    end;


    TD3DSTATUS = _D3DSTATUS;
    PD3DSTATUS = ^TD3DSTATUS;
    LPD3DSTATUS = ^TD3DSTATUS;


    _D3DCLIPSTATUS = record
        dwFlags: DWORD; (* Do we set 2d extents, 3D extents or status *)
        dwStatus: DWORD; (* Clip status *)
        minxmaxx: single; (* X extents *)
        minymaxy: single; (* Y extents *)
        minzmaxz: single; (* Z extents *)
    end;


    TD3DCLIPSTATUS = _D3DCLIPSTATUS;
    PD3DCLIPSTATUS = ^TD3DCLIPSTATUS;
    LPD3DCLIPSTATUS = ^TD3DCLIPSTATUS;

(*
 * Statistics structure
 *)
    _D3DSTATS = record
        dwSize: DWORD;
        dwTrianglesDrawn: DWORD;
        dwLinesDrawn: DWORD;
        dwPointsDrawn: DWORD;
        dwSpansDrawn: DWORD;
        dwVerticesProcessed: DWORD;
    end;


    TD3DSTATS = _D3DSTATS;
    PD3DSTATS = ^TD3DSTATS;
    LPD3DSTATS = ^TD3DSTATS;


    _D3DEXECUTEDATA = record
        dwSize: DWORD;
        dwVertexOffset: DWORD;
        dwVertexCount: DWORD;
        dwInstructionOffset: DWORD;
        dwInstructionLength: DWORD;
        dwHVertexOffset: DWORD;
        dsStatus: TD3DSTATUS; (* Status after execute *)
    end;


    TD3DEXECUTEDATA = _D3DEXECUTEDATA;
    PD3DEXECUTEDATA = ^TD3DEXECUTEDATA;
    LPD3DEXECUTEDATA = ^TD3DEXECUTEDATA;


    _D3DVERTEXBUFFERDESC = record
        dwSize: DWORD;
        dwCaps: DWORD;
        dwFVF: DWORD;
        dwNumVertices: DWORD;
    end;


    TD3DVERTEXBUFFERDESC = _D3DVERTEXBUFFERDESC;
    PD3DVERTEXBUFFERDESC = ^TD3DVERTEXBUFFERDESC;
    LPD3DVERTEXBUFFERDESC = ^TD3DVERTEXBUFFERDESC;


    _D3DDP_PTRSTRIDE = record
        lpvData: LPVOID;
        dwStride: DWORD;
    end;
    TD3DDP_PTRSTRIDE = _D3DDP_PTRSTRIDE;
    PD3DDP_PTRSTRIDE = ^TD3DDP_PTRSTRIDE;


    _D3DDRAWPRIMITIVESTRIDEDDATA = record
        position: TD3DDP_PTRSTRIDE;
        normal: TD3DDP_PTRSTRIDE;
        diffuse: TD3DDP_PTRSTRIDE;
        specular: TD3DDP_PTRSTRIDE;
        textureCoords: array [0..D3DDP_MAXTEXCOORD - 1] of TD3DDP_PTRSTRIDE;
    end;


    TD3DDRAWPRIMITIVESTRIDEDDATA = _D3DDRAWPRIMITIVESTRIDEDDATA;
    PD3DDRAWPRIMITIVESTRIDEDDATA = ^TD3DDRAWPRIMITIVESTRIDEDDATA;
    LPD3DDRAWPRIMITIVESTRIDEDDATA = ^TD3DDRAWPRIMITIVESTRIDEDDATA;



    _D3DSTATEBLOCKTYPE = (
        D3DSBT_ALL = 1, // capture all state
        D3DSBT_PIXELSTATE = 2, // capture pixel state
        D3DSBT_VERTEXSTATE = 3, // capture vertex state
        D3DSBT_FORCE_DWORD = $ffffffff);

    TD3DSTATEBLOCKTYPE = _D3DSTATEBLOCKTYPE;
    PD3DSTATEBLOCKTYPE = ^TD3DSTATEBLOCKTYPE;

    // The D3DVERTEXBLENDFLAGS type is used with D3DRENDERSTATE_VERTEXBLEND state.

    _D3DVERTEXBLENDFLAGS = (
        D3DVBLEND_DISABLE = 0, // Disable vertex blending
        D3DVBLEND_1WEIGHT = 1, // blend between 2 matrices
        D3DVBLEND_2WEIGHTS = 2, // blend between 3 matrices
        D3DVBLEND_3WEIGHTS = 3// blend between 4 matrices
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

const
    // For back-compatibility with legacy compilations
    D3DRENDERSTATE_BLENDENABLE = D3DRENDERSTATE_ALPHABLENDENABLE;


    (*
     * Format of CI colors is
     *  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
     *  |    alpha      |         color index           |   fraction    |
     *  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
     *)

function CI_GETALPHA(ci: DWORD): DWORD;
function CI_GETINDEX(ci: DWORD): DWORD;
function CI_GETFRACTION(ci: DWORD): DWORD;
function CI_ROUNDINDEX(ci: DWORD): DWORD;
function CI_MASKALPHA(ci: DWORD): DWORD;
function CI_MAKE(a, i, f: DWORD): DWORD;


    (*
     * Format of RGBA colors is
     *  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
     *  |    alpha      |      red      |     green     |     blue      |
     *  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
     *)

function RGBA_GETALPHA(rgb: DWORD): DWORD;
function RGBA_GETRED(rgb: DWORD): DWORD;
function RGBA_GETGREEN(rgb: DWORD): DWORD;
function RGBA_GETBLUE(rgb: DWORD): DWORD;
function RGBA_MAKE(r, g, b, a: DWORD): TD3DCOLOR;

    (* D3DRGB and D3DRGBA may be used as initialisers for D3DCOLORs
     * The float values must be in the range 0..1
     *)

function D3DRGB(r, g, b: single): DWORD;


    (*
     * Format of RGB colors is
     *  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
     *  |    ignored    |      red      |     green     |     blue      |
     *  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
     *)

function RGB_GETRED(rgb: DWORD): DWORD;
function RGB_GETGREEN(rgb: DWORD): DWORD;
function RGB_GETBLUE(rgb: DWORD): DWORD;
function RGBA_SETALPHA(rgba, x: DWORD): DWORD;
function RGB_MAKE(r, g, b: DWORD): TD3DCOLOR;
function RGBA_TORGB(rgba: DWORD): TD3DCOLOR;
function RGB_TORGBA(rgb: DWORD): TD3DCOLOR;




(*
 * A state which sets the override flag for the specified state type.
 *)
function D3DSTATE_OVERRIDE(Atype :DWORD):TD3DRENDERSTATETYPE;

function D3DRENDERSTATE_STIPPLEPATTERN(y: dword): TD3DRENDERSTATETYPE;


function D3DFVF_TEXCOORDSIZE3(CoordIndex: DWORD):DWORD;
function D3DFVF_TEXCOORDSIZE2(CoordIndex: DWORD):DWORD;
function D3DFVF_TEXCOORDSIZE4(CoordIndex: DWORD):DWORD;
function D3DFVF_TEXCOORDSIZE1(CoordIndex: DWORD):DWORD;

implementation

{ _D3DVECTOR }

function _D3DVECTOR.GetElement(index: integer): single;
begin
    Result := f[index];
end;



procedure _D3DVECTOR.SetElement(index: integer; AValue: single);
begin
    f[index] := AValue;
end;



procedure _D3DVECTOR.Init(f: _D3DVECTOR);
begin
    x := f.x;
    y := f.y;
    y := f.y;

end;



procedure _D3DVECTOR.Init(x, y, z: TD3DVALUE);
begin
    self.x := x;
    self.y := y;
    self.z := z;
end;



procedure _D3DVECTOR.Init(f: array of TD3DVALUE);
begin
    self.x := f[0];
    self.y := f[1];
    self.z := f[2];
end;



procedure _D3DVECTOR.Init(f: TD3DVALUE);
begin
    self.x := f;
    self.y := f;
    self.z := f;
end;



class operator _D3DVECTOR.Add(a: _D3DVECTOR; b: _D3DVECTOR): _D3DVECTOR;
begin
    Result.x := a.x + b.x;
    Result.y := a.y + b.y;
    Result.z := a.z + b.z;
end;



class operator _D3DVECTOR.Subtract(a: _D3DVECTOR; b: _D3DVECTOR): _D3DVECTOR;
begin
    Result.x := a.x - b.x;
    Result.y := a.y - b.y;
    Result.z := a.z - b.z;
end;



class operator _D3DVECTOR.Multiply(a: _D3DVECTOR; b: _D3DVECTOR): _D3DVECTOR;
begin
    Result.x := a.x * b.x;
    Result.y := a.y * b.y;
    Result.z := a.z * b.z;
end;



class operator _D3DVECTOR.Divide(a: _D3DVECTOR; b: _D3DVECTOR): _D3DVECTOR;
begin
    Result.x := a.x / b.x;
    Result.y := a.y / b.y;
    Result.z := a.z / b.z;
end;



class operator _D3DVECTOR.Multiply(a: _D3DVECTOR; b: TD3DVALUE): _D3DVECTOR;
begin
    Result.x := a.x * b;
    Result.y := a.y * b;
    Result.z := a.z * b;
end;



class operator _D3DVECTOR.Divide(a: _D3DVECTOR; b: TD3DVALUE): _D3DVECTOR;
begin
    Result.x := a.x / b;
    Result.y := a.y / b;
    Result.z := a.z / b;
end;



class operator _D3DVECTOR.Negative(a: _D3DVECTOR): _D3DVECTOR;
begin
    Result.x := -a.x;
    Result.y := -a.y;
    Result.z := -a.z;

end;



class operator _D3DVECTOR.Positive(a: _D3DVECTOR): _D3DVECTOR;
begin
    Result := a;
end;



class operator _D3DVECTOR.LessThan(a: _D3DVECTOR; b: _D3DVECTOR): boolean;
begin
    // a<b
    Result := (a.f[0] < b.f[0]) and (a.f[1] < b.f[1]) and (a.f[2] < b.f[2]);
end;



class operator _D3DVECTOR.GreaterThan(a: _D3DVECTOR; b: _D3DVECTOR): boolean;
begin
    // a>b
    Result := (a.f[0] > b.f[0]) and (a.f[1] > b.f[1]) and (a.f[2] > b.f[2]);
end;



class operator _D3DVECTOR.GreaterThanOrEqual(a: _D3DVECTOR; b: _D3DVECTOR): boolean;
begin
    // a>=b
    Result := (a.f[0] >= b.f[0]) and (a.f[1] >= b.f[1]) and (a.f[2] >= b.f[2]);
end;



class operator _D3DVECTOR.LessThanOrEqual(a: _D3DVECTOR; b: _D3DVECTOR): boolean;
begin
    // a<=b
    Result := (a.f[0] <= b.f[0]) and (a.f[1] <= b.f[1]) and (a.f[2] <= b.f[2]);
end;



class operator _D3DVECTOR.Equal(a: _D3DVECTOR; b: _D3DVECTOR): boolean;
begin
    Result := (a.f[0] = b.f[0]) and (a.f[1] = b.f[1]) and (a.f[2] = b.f[2]);
end;



function _D3DVECTOR.SquareMagnitude(v: _D3DVECTOR): TD3DVALUE;
begin
    Result := v.x * v.x + v.y * v.y + v.z * v.z;
end;



function _D3DVECTOR.Magnitude(v: _D3DVECTOR): TD3DVALUE;
begin
    Result := sqrt(SquareMagnitude(v));
end;



function _D3DVECTOR.Normalize(v: _D3DVECTOR): _D3DVECTOR;
begin
    Result := v / Magnitude(v);
end;



function _D3DVECTOR.Min(v: _D3DVECTOR): TD3DVALUE;
var
    ret: TD3DVALUE;
begin
    ret := v.x;
    if (v.y < ret) then ret := v.y;
    if (v.z < ret) then  ret := v.z;
    Result := ret;
end;



function _D3DVECTOR.Max(v: _D3DVECTOR): TD3DVALUE;
var
    ret: TD3DVALUE;
begin
    ret := v.x;
    if (ret < v.y) then ret := v.y;
    if (ret < v.z) then ret := v.z;
    Result := ret;
end;



function _D3DVECTOR.Minimize(v1: _D3DVECTOR; v2: _D3DVECTOR): _D3DVECTOR;
begin
    if (v1.f[0] < v2.f[0]) then
        Result.x := v1.f[0]
    else
        Result.x := v2.f[0];

    if (v1.f[1] < v2.f[1]) then
        Result.x := v1.f[1]
    else
        Result.x := v2.f[1];
    if (v1.f[2] < v2.f[2]) then
        Result.x := v1.f[2]
    else
        Result.x := v2.f[2];
end;



function _D3DVECTOR.Maximize(v1: _D3DVECTOR; v2: _D3DVECTOR): _D3DVECTOR;
begin
    if (v1.f[0] > v2.f[0]) then
        Result.x := v1.f[0]
    else
        Result.x := v2.f[0];

    if (v1.f[1] > v2.f[1]) then
        Result.x := v1.f[1]
    else
        Result.x := v2.f[1];
    if (v1.f[2] > v2.f[2]) then
        Result.x := v1.f[2]
    else
        Result.x := v2.f[2];
end;



function _D3DVECTOR.DotProduct(v1: _D3DVECTOR; v2: _D3DVECTOR): TD3DVALUE;
begin
    Result := v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
end;



function _D3DVECTOR.CrossProduct(v1: _D3DVECTOR; v2: _D3DVECTOR): _D3DVECTOR;
begin
    Result.f[0] := v1.f[1] * v2.f[2] - v1.f[2] * v2.f[1];
    Result.f[1] := v1.f[2] * v2.f[0] - v1.f[0] * v2.f[2];
    Result.f[2] := v1.f[0] * v2.f[1] - v1.f[1] * v2.f[0];

end;

{ _D3DTLVERTEX }

procedure _D3DTLVERTEX.Init(v: TD3DVECTOR; _rhw: single; _color: TD3DCOLOR; _specular: TD3DCOLOR; _tu, _tv: single);
begin
    sx := v.x;
    sy := v.y;
    sz := v.z;
    rhw := _rhw;
    color := _color;
    specular := _specular;
    tu := _tu;
    tv := _tv;
end;

{ _D3DLVERTEX }

procedure _D3DLVERTEX.Init(v: TD3DVECTOR; _color: TD3DCOLOR; _specular: TD3DCOLOR; _tu, _tv: single);
begin
    x := v.x;
    y := v.y;
    z := v.z;
    dwReserved := 0;
    color := _color;
    specular := _specular;
    tu := _tu;
    tv := _tv;
end;

{ _D3DVERTEX }

procedure _D3DVERTEX.Init(v, n: TD3DVECTOR; _tu, _tv: single);
begin
    x := v.x;
    y := v.y;
    z := v.z;
    nx := n.x;
    ny := n.y;
    nz := n.z;
    tu := _tu;
    tv := _tv;
end;

{ _D3DMATRIX }

procedure _D3DMATRIX.Init(_m00, _m01, _m02, _m03, _m10, _m11, _m12, _m13, _m20, _m21, _m22, _m23, _m30, _m31, _m32, _m33: TD3DVALUE);
begin
    m[0][0] := _m00;
    m[0][1] := _m01;
    m[0][2] := _m02;
    m[0][3] := _m03;
    m[1][0] := _m10;
    m[1][1] := _m11;
    m[1][2] := _m12;
    m[1][3] := _m13;
    m[2][0] := _m20;
    m[2][1] := _m21;
    m[2][2] := _m22;
    m[2][3] := _m23;
    m[3][0] := _m30;
    m[3][1] := _m31;
    m[3][2] := _m32;
    m[3][3] := _m33;
end;



function _D3DMATRIX.Element(iRow, iColumn: integer): TD3DVALUE;
begin
    Result := m[iRow][iColumn];
end;



class operator _D3DMATRIX.Multiply(a: _D3DMATRIX; b: _D3DMATRIX): _D3DMATRIX;
var
    ret: _D3DMATRIX;
    i, j, k: integer;
begin

    for i := 0 to 3 do
    begin
        for j := 0 to 3 do
        begin
            ret.m[i, j] := 0.0;
            for k := 0 to 3 do
            begin
                ret.m[i, j] := ret.m[i, j] + a.m[i, k] * b.m[k, j];
            end;
        end;
    end;
    Result := ret;
end;



function D3DDivide(a, b: TD3DVALUE): TD3DVALUE;
begin
    Result := (a / b);
end;



function D3DMultiply(a, b: TD3DVALUE): TD3DVALUE;
begin
    Result := (a * b);
end;

(*
 * Format of CI colors is
 *  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *  |    alpha      |         color index           |   fraction    |
 *  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *)

function CI_GETALPHA(ci: DWORD): DWORD;
begin
    Result := (ci shr 24);
end;



function CI_GETINDEX(ci: DWORD): DWORD;
begin
    Result := ((ci shr 8) and $ffff);
end;



function CI_GETFRACTION(ci: DWORD): DWORD;
begin
    Result := (ci and $ff);
end;



function CI_ROUNDINDEX(ci: DWORD): DWORD;
begin
    Result := CI_GETINDEX(ci + $80);
end;



function CI_MASKALPHA(ci: DWORD): DWORD;
begin
    Result := (ci and $ffffff);
end;



function CI_MAKE(a, i, f: DWORD): DWORD;
begin
    Result := ((a shl 24) or (i shl 8) or f);
end;

(*
 * Format of RGBA colors is
 *  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *  |    alpha      |      red      |     green     |     blue      |
 *  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *)

function RGBA_GETALPHA(rgb: DWORD): DWORD;
begin
    Result := (rgb shr 24);
end;



function RGBA_GETRED(rgb: DWORD): DWORD;
begin
    Result := ((rgb shr 16) and $ff);
end;



function RGBA_GETGREEN(rgb: DWORD): DWORD;
begin
    Result := ((rgb shr 8) and $ff);
end;



function RGBA_GETBLUE(rgb: DWORD): DWORD;
begin
    Result := (rgb and $ff);
end;



function RGBA_MAKE(r, g, b, a: DWORD): TD3DCOLOR;
begin
    Result := ((a shl 24) or (r shl 16) or (g shl 8) or b);
end;

(* D3DRGB and D3DRGBA may be used as initialisers for D3DCOLORs
 * The float values must be in the range 0..1
 *)

function D3DRGB(r, g, b: single): DWORD;
begin
    Result :=
        ($ff000000 or (trunc(r * 255) shl 16) or (trunc(g * 255) shl 8) or trunc(b * 255));
end;



function D3DRGBA(r, g, b, a: single): DWORD;
begin
    Result :=
        ((trunc(a * 255) shl 24) or (trunc(r * 255) shl 16) or (trunc(g * 255) shl 8) or trunc(b * 255));
end;

(*
 * Format of RGB colors is
 *  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *  |    ignored    |      red      |     green     |     blue      |
 *  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *)

function RGB_GETRED(rgb: DWORD): DWORD;
begin
    Result := ((rgb shr 16) and $ff);
end;



function RGB_GETGREEN(rgb: DWORD): DWORD;
begin
    Result := ((rgb shr 8) and $ff);
end;



function RGB_GETBLUE(rgb: DWORD): DWORD;
begin
    Result := (rgb and $ff);
end;



function RGBA_SETALPHA(rgba, x: DWORD): DWORD;
begin
    Result := ((x shl 24) or (rgba and $00ffffff));
end;



function RGB_MAKE(r, g, b: DWORD): TD3DCOLOR;
begin
    Result := ((r shl 16) or (g shl 8) or b);
end;



function RGBA_TORGB(rgba: DWORD): TD3DCOLOR;
begin
    Result := (rgba and $ffffff);
end;



function RGB_TORGBA(rgb: DWORD): TD3DCOLOR;
begin
    Result := (rgb or $ff000000);
end;

function D3DSTATE_OVERRIDE(Atype: DWORD): TD3DRENDERSTATETYPE;
begin
  result:=TD3DRENDERSTATETYPE(Atype + D3DSTATE_OVERRIDE_BIAS);
end;

function D3DRENDERSTATE_STIPPLEPATTERN(y: dword): TD3DRENDERSTATETYPE;
begin
  result:=TD3DRENDERSTATETYPE(ord(D3DRENDERSTATE_STIPPLEPATTERN00) + y);
end;

function D3DFVF_TEXCOORDSIZE3(CoordIndex: DWORD): DWORD;
begin
  result:= (D3DFVF_TEXTUREFORMAT3  SHL  (CoordIndex*2 + 16));
end;

function D3DFVF_TEXCOORDSIZE2(CoordIndex: DWORD): DWORD;
begin
  result:=  (D3DFVF_TEXTUREFORMAT2);
end;

function D3DFVF_TEXCOORDSIZE4(CoordIndex: DWORD): DWORD;
begin
  result:= (D3DFVF_TEXTUREFORMAT4  SHL  (CoordIndex*2 + 16));
end;

function D3DFVF_TEXCOORDSIZE1(CoordIndex: DWORD): DWORD;
begin
   result:=  (D3DFVF_TEXTUREFORMAT1  SHL  (CoordIndex*2 + 16));

end;




end.
