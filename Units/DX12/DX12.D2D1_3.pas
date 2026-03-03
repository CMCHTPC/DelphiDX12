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
   File name: d2d1_3.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.D2D1_3;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    Win32.ObjIdl,
    DX12.D2D1,
    DX12.D2D1DWrite,
    DX12.D2D1_1,
    DX12.D2D1_2,
    DX12.WinCodec,
    DX12.WinCodecD2D1,
    DX12.DXGI,
    DX12.DXGICommon,
    DX12.DWrite,
    DX12.D2D1Effects,
    DX12.D2D1SVG,
    DX12.DCommon;

    {$Z4}

const

    IID_ID2D1InkStyle: TGUID = '{bae8b344-23fc-4071-8cb5-d05d6f073848}';
    IID_ID2D1Ink: TGUID = '{b499923b-7029-478f-a8b3-432c7c5f5312}';
    IID_ID2D1GradientMesh: TGUID = '{f292e401-c050-4cde-83d7-04962d3b23c2}';
    IID_ID2D1ImageSource: TGUID = '{c9b664e5-74a1-4378-9ac2-eefc37a3f4d8}';
    IID_ID2D1ImageSourceFromWic: TGUID = '{77395441-1c8f-4555-8683-f50dab0fe792}';
    IID_ID2D1TransformedImageSource: TGUID = '{7f1f79e5-2796-416c-8f55-700f911445e5}';
    IID_ID2D1LookupTable3D: TGUID = '{53dd9855-a3b0-4d5b-82e1-26e25c5e5797}';
    IID_ID2D1DeviceContext2: TGUID = '{394ea6a3-0c34-4321-950b-6ca20f0be6c7}';
    IID_ID2D1Device2: TGUID = '{a44472e1-8dfb-4e60-8492-6e2861c9ca8b}';
    IID_ID2D1Factory3: TGUID = '{0869759f-4f00-413f-b03e-2bda45404d0f}';
    IID_ID2D1CommandSink2: TGUID = '{3bab440e-417e-47df-a2e2-bc0be6a00916}';
    IID_ID2D1GdiMetafile1: TGUID = '{2e69f9e8-dd3f-4bf9-95ba-c04f49d788df}';
    IID_ID2D1GdiMetafileSink1: TGUID = '{fd0ecb6b-91e6-411e-8655-395e760f91b4}';
    IID_ID2D1SpriteBatch: TGUID = '{4dc583bf-3a10-438a-8722-e9765224f1f1}';
    IID_ID2D1DeviceContext3: TGUID = '{235a7496-8351-414c-bcd4-6672ab2d8e00}';
    IID_ID2D1Device3: TGUID = '{852f2087-802c-4037-ab60-ff2e7ee6fc01}';
    IID_ID2D1Factory4: TGUID = '{bd4ec2d2-0662-4bee-ba8e-6f29f032e096}';
    IID_ID2D1CommandSink3: TGUID = '{18079135-4cf3-4868-bc8e-06067e6d242d}';
    IID_ID2D1SvgGlyphStyle: TGUID = '{af671749-d241-4db8-8e41-dcc2e5c1a438}';
    IID_ID2D1DeviceContext4: TGUID = '{8c427831-3d90-4476-b647-c4fae349e4db}';
    IID_ID2D1Device4: TGUID = '{d7bdb159-5683-4a46-bc9c-72dc720b858b}';
    IID_ID2D1Factory5: TGUID = '{c4349994-838e-4b0f-8cab-44997d9eeacc}';
    IID_ID2D1CommandSink4: TGUID = '{c78a6519-40d6-4218-b2de-beeeb744bb3e}';
    IID_ID2D1ColorContext1: TGUID = '{1ab42875-c57f-4be9-bd85-9cd78d6f55ee}';
    IID_ID2D1DeviceContext5: TGUID = '{7836d248-68cc-4df6-b9e8-de991bf62eb7}';
    IID_ID2D1Device5: TGUID = '{d55ba0a4-6405-4694-aef5-08ee1a4358b4}';
    IID_ID2D1Factory6: TGUID = '{f9976f46-f642-44c1-97ca-da32ea2a2635}';
    IID_ID2D1CommandSink5: TGUID = '{7047dd26-b1e7-44a7-959a-8349e2144fa8}';
    IID_ID2D1DeviceContext6: TGUID = '{985f7e37-4ed0-4a19-98a3-15b0edfde306}';
    IID_ID2D1Device6: TGUID = '{7bfef914-2d75-4bad-be87-e18ddb077b6d}';
    IID_ID2D1Factory7: TGUID = '{bdc2bdd3-b96c-4de6-bdf7-99d4745454de}';
    IID_ID2D1DeviceContext7: TGUID = '{ec891cf7-9b69-4851-9def-4e0915771e62}';
    IID_ID2D1Device7: TGUID = '{f07c8968-dd4e-4ba6-9cbd-eb6d3752dcbb}';
    IID_ID2D1Factory8: TGUID = '{677c9311-f36d-4b1f-ae86-86d1223ffd3a}';

type

    /// Specifies the appearance of the ink nib (pen tip) as part of an
    /// D2D1_INK_STYLE_PROPERTIES structure.
    TD2D1_INK_NIB_SHAPE = (
        D2D1_INK_NIB_SHAPE_ROUND = 0,
        D2D1_INK_NIB_SHAPE_SQUARE = 1,
        D2D1_INK_NIB_SHAPE_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_INK_NIB_SHAPE = ^TD2D1_INK_NIB_SHAPE;

    /// Specifies the orientation of an image.
    TD2D1_ORIENTATION = (
        D2D1_ORIENTATION_DEFAULT = 1,
        D2D1_ORIENTATION_FLIP_HORIZONTAL = 2,
        D2D1_ORIENTATION_ROTATE_CLOCKWISE180 = 3,
        D2D1_ORIENTATION_ROTATE_CLOCKWISE180_FLIP_HORIZONTAL = 4,
        D2D1_ORIENTATION_ROTATE_CLOCKWISE90_FLIP_HORIZONTAL = 5,
        D2D1_ORIENTATION_ROTATE_CLOCKWISE270 = 6,
        D2D1_ORIENTATION_ROTATE_CLOCKWISE270_FLIP_HORIZONTAL = 7,
        D2D1_ORIENTATION_ROTATE_CLOCKWISE90 = 8,
        D2D1_ORIENTATION_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_ORIENTATION = ^TD2D1_ORIENTATION;

    /// Option flags controlling how images sources are loaded during
    /// CreateImageSourceFromWic.
    TD2D1_IMAGE_SOURCE_LOADING_OPTIONS = (
        D2D1_IMAGE_SOURCE_LOADING_OPTIONS_NONE = 0,
        D2D1_IMAGE_SOURCE_LOADING_OPTIONS_RELEASE_SOURCE = 1,
        D2D1_IMAGE_SOURCE_LOADING_OPTIONS_CACHE_ON_DEMAND = 2,
        D2D1_IMAGE_SOURCE_LOADING_OPTIONS_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_IMAGE_SOURCE_LOADING_OPTIONS = ^TD2D1_IMAGE_SOURCE_LOADING_OPTIONS;

    /// Option flags controlling primary conversion performed by
    /// CreateImageSourceFromDxgi, if any.
    TD2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS = (
        D2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS_NONE = 0,
        D2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS_LOW_QUALITY_PRIMARY_CONVERSION = 1,
        D2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS = ^TD2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS;

    /// Option flags for transformed image sources.
    TD2D1_TRANSFORMED_IMAGE_SOURCE_OPTIONS = (
        D2D1_TRANSFORMED_IMAGE_SOURCE_OPTIONS_NONE = 0,
        /// Prevents the image source from being automatically scaled (by a ratio of the
        /// context DPI divided by 96) while drawn.
        D2D1_TRANSFORMED_IMAGE_SOURCE_OPTIONS_DISABLE_DPI_SCALE = 1,
        D2D1_TRANSFORMED_IMAGE_SOURCE_OPTIONS_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_TRANSFORMED_IMAGE_SOURCE_OPTIONS = ^TD2D1_TRANSFORMED_IMAGE_SOURCE_OPTIONS;

    /// Properties of a transformed image source.
    TD2D1_TRANSFORMED_IMAGE_SOURCE_PROPERTIES = record
        /// The orientation at which the image source is drawn.
        orientation: TD2D1_ORIENTATION;
        /// The horizontal scale factor at which the image source is drawn.
        scaleX: single;
        /// The vertical scale factor at which the image source is drawn.
        scaleY: single;
        /// The interpolation mode used when the image source is drawn.  This is ignored if
        /// the image source is drawn using the DrawImage method, or using an image brush.
        interpolationMode: TD2D1_INTERPOLATION_MODE;
        /// Option flags.
        options: TD2D1_TRANSFORMED_IMAGE_SOURCE_OPTIONS;
    end;
    PD2D1_TRANSFORMED_IMAGE_SOURCE_PROPERTIES = ^TD2D1_TRANSFORMED_IMAGE_SOURCE_PROPERTIES;

    /// Represents a point, radius pair that makes up part of a D2D1_INK_BEZIER_SEGMENT.
    TD2D1_INK_POINT = record
        x: single;
        y: single;
        radius: single;
    end;
    PD2D1_INK_POINT = ^TD2D1_INK_POINT;

    /// Represents a Bezier segment to be used in the creation of an ID2D1Ink object.
    /// This structure differs from D2D1_BEZIER_SEGMENT in that it is composed of
    /// D2D1_INK_POINT s, which contain a radius in addition to x- and y-coordinates.
    TD2D1_INK_BEZIER_SEGMENT = record
        point1: TD2D1_INK_POINT;
        point2: TD2D1_INK_POINT;
        point3: TD2D1_INK_POINT;
    end;
    PD2D1_INK_BEZIER_SEGMENT = ^TD2D1_INK_BEZIER_SEGMENT;

    /// Defines the general pen tip shape and the transform used in an ID2D1InkStyle
    /// object.
    TD2D1_INK_STYLE_PROPERTIES = record
        /// The general shape of the nib used to draw a given ink object.
        nibShape: TD2D1_INK_NIB_SHAPE;
        /// The transform applied to shape of the nib. _31 and _32 are ignored.
        nibTransform: TD2D1_MATRIX_3X2_F;
    end;
    PD2D1_INK_STYLE_PROPERTIES = ^TD2D1_INK_STYLE_PROPERTIES;

    /// Specifies how to render gradient mesh edges.
    TD2D1_PATCH_EDGE_MODE = (
        /// Render this edge aliased.
        D2D1_PATCH_EDGE_MODE_ALIASED = 0,
        /// Render this edge antialiased.
        D2D1_PATCH_EDGE_MODE_ANTIALIASED = 1,
        /// Render this edge aliased and inflated out slightly.
        D2D1_PATCH_EDGE_MODE_ALIASED_INFLATED = 2,
        D2D1_PATCH_EDGE_MODE_FORCE_DWORD = $ffffffff
        );

    PD2D1_PATCH_EDGE_MODE = ^TD2D1_PATCH_EDGE_MODE;

    /// Represents a tensor patch with 16 control points, 4 corner colors, and boundary
    /// flags. An ID2D1GradientMesh is made up of 1 or more gradient mesh patches. Use
    /// the GradientMeshPatch function or the GradientMeshPatchFromCoonsPatch function
    /// to create one.
    TD2D1_GRADIENT_MESH_PATCH = record
        /// The gradient mesh patch control point at position 00.
        point00: TD2D1_POINT_2F;
        /// The gradient mesh patch control point at position 01.
        point01: TD2D1_POINT_2F;
        /// The gradient mesh patch control point at position 02.
        point02: TD2D1_POINT_2F;
        /// The gradient mesh patch control point at position 03.
        point03: TD2D1_POINT_2F;
        /// The gradient mesh patch control point at position 10.
        point10: TD2D1_POINT_2F;
        /// The gradient mesh patch control point at position 11.
        point11: TD2D1_POINT_2F;
        /// The gradient mesh patch control point at position 12.
        point12: TD2D1_POINT_2F;
        /// The gradient mesh patch control point at position 13.
        point13: TD2D1_POINT_2F;
        /// The gradient mesh patch control point at position 20.
        point20: TD2D1_POINT_2F;
        /// The gradient mesh patch control point at position 21.
        point21: TD2D1_POINT_2F;
        /// The gradient mesh patch control point at position 22.
        point22: TD2D1_POINT_2F;
        /// The gradient mesh patch control point at position 23.
        point23: TD2D1_POINT_2F;
        /// The gradient mesh patch control point at position 30.
        point30: TD2D1_POINT_2F;
        /// The gradient mesh patch control point at position 31.
        point31: TD2D1_POINT_2F;
        /// The gradient mesh patch control point at position 32.
        point32: TD2D1_POINT_2F;
        /// The gradient mesh patch control point at position 33.
        point33: TD2D1_POINT_2F;
        /// The color associated with control point at position 00.
        color00: TD2D1_COLOR_F;
        /// The color associated with control point at position 03.
        color03: TD2D1_COLOR_F;
        /// The color associated with control point at position 30.
        color30: TD2D1_COLOR_F;
        /// The color associated with control point at position 33.
        color33: TD2D1_COLOR_F;
        /// The edge mode for the top edge of the patch.
        topEdgeMode: TD2D1_PATCH_EDGE_MODE;
        /// The edge mode for the left edge of the patch.
        leftEdgeMode: TD2D1_PATCH_EDGE_MODE;
        /// The edge mode for the bottom edge of the patch.
        bottomEdgeMode: TD2D1_PATCH_EDGE_MODE;
        /// The edge mode for the right edge of the patch.
        rightEdgeMode: TD2D1_PATCH_EDGE_MODE;
    end;
    PD2D1_GRADIENT_MESH_PATCH = ^TD2D1_GRADIENT_MESH_PATCH;

    TD2D1_SPRITE_OPTIONS = (
        /// Use default sprite rendering behavior.
        D2D1_SPRITE_OPTIONS_NONE = 0,
        /// Bitmap interpolation will be clamped to the sprite's source rectangle.
        D2D1_SPRITE_OPTIONS_CLAMP_TO_SOURCE_RECTANGLE = 1,
        D2D1_SPRITE_OPTIONS_FORCE_DWORD = $ffffffff
        );

    PD2D1_SPRITE_OPTIONS = ^TD2D1_SPRITE_OPTIONS;

    /// Specifies the pixel snapping policy when rendering color bitmap glyphs.
    TD2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION = (
        /// Color bitmap glyph positions are snapped to the nearest pixel if the bitmap
        /// resolution matches that of the device context.
        D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION_DEFAULT = 0,
        /// Color bitmap glyph positions are not snapped.
        D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION_DISABLE = 1,
        D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION_FORCE_DWORD = $ffffffff
        );

    PD2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION = ^TD2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION;

    /// This determines what gamma is used for interpolation/blending.
    TD2D1_GAMMA1 = (
        /// Colors are manipulated in 2.2 gamma color space.
        D2D1_GAMMA1_G22 = Ord(D2D1_GAMMA_2_2),
        /// Colors are manipulated in 1.0 gamma color space.
        D2D1_GAMMA1_G10 = Ord(D2D1_GAMMA_1_0),
        /// Colors are manipulated in ST.2084 PQ gamma color space.
        D2D1_GAMMA1_G2084 = 2,
        D2D1_GAMMA1_FORCE_DWORD = $ffffffff
        );

    PD2D1_GAMMA1 = ^TD2D1_GAMMA1;

    /// Simple description of a color space.
    TD2D1_SIMPLE_COLOR_PROFILE = record
        /// The XY coordinates of the red primary in CIEXYZ space.
        redPrimary: TD2D1_POINT_2F;
        /// The XY coordinates of the green primary in CIEXYZ space.
        greenPrimary: TD2D1_POINT_2F;
        /// The XY coordinates of the blue primary in CIEXYZ space.
        bluePrimary: TD2D1_POINT_2F;
        /// The X/Z tristimulus values for the whitepoint, normalized for relative
        /// luminance.
        whitePointXZ: TD2D1_POINT_2F;
        /// The gamma encoding to use for this color space.
        gamma: TD2D1_GAMMA1;
    end;
    PD2D1_SIMPLE_COLOR_PROFILE = ^TD2D1_SIMPLE_COLOR_PROFILE;

    /// Specifies which way a color profile is defined.
    TD2D1_COLOR_CONTEXT_TYPE = (
        D2D1_COLOR_CONTEXT_TYPE_ICC = 0,
        D2D1_COLOR_CONTEXT_TYPE_SIMPLE = 1,
        D2D1_COLOR_CONTEXT_TYPE_DXGI = 2,
        D2D1_COLOR_CONTEXT_TYPE_FORCE_DWORD = $ffffffff
        );

    PD2D1_COLOR_CONTEXT_TYPE = ^TD2D1_COLOR_CONTEXT_TYPE;


    /// Represents a collection of style properties to be used by methods like
    /// ID2D1DeviceContext2::DrawInk when rendering ink. The ink style defines the nib
    /// (pen tip) shape and transform.
    ID2D1InkStyle = interface(ID2D1Resource)
        ['{bae8b344-23fc-4071-8cb5-d05d6f073848}']
        procedure SetNibTransform(
        {_In_ } transform: PD2D1_MATRIX_3X2_F); stdcall;

        procedure GetNibTransform(
        {_Out_ } transform: PD2D1_MATRIX_3X2_F); stdcall;

        procedure SetNibShape(nibShape: TD2D1_INK_NIB_SHAPE); stdcall;

        function GetNibShape(): TD2D1_INK_NIB_SHAPE; stdcall;

    end;

    ID2D1InkStyleHelper = type helper for ID2D1InkStyle
        procedure SetNibTransform(transform: TD2D1_MATRIX_3X2_F); overload;

    end;

    /// Represents a single continuous stroke of variable-width ink, as defined by a
    /// series of Bezier segments and widths.
    ID2D1Ink = interface(ID2D1Resource)
        ['{b499923b-7029-478f-a8b3-432c7c5f5312}']
        /// Resets the ink start point.
        procedure SetStartPoint(
        {_In_ } startPoint: PD2D1_INK_POINT); stdcall;

        /// Retrieve the start point with which the ink was initialized.
        function GetStartPoint(): TD2D1_INK_POINT; stdcall;

        /// Add one or more segments to the end of the ink.
        function AddSegments(
        {_In_reads_(segmentsCount) } segments: PD2D1_INK_BEZIER_SEGMENT; segmentsCount: uint32): HRESULT; stdcall;

        /// Remove one or more segments from the end of the ink.
        function RemoveSegmentsAtEnd(segmentsCount: uint32): HRESULT; stdcall;

        /// Updates the specified segments with new control points.
        function SetSegments(startSegment: uint32;
        {_In_reads_(segmentsCount) } segments: PD2D1_INK_BEZIER_SEGMENT; segmentsCount: uint32): HRESULT; stdcall;

        /// Update the last segment with new control points.
        function SetSegmentAtEnd(
        {_In_ } segment: PD2D1_INK_BEZIER_SEGMENT): HRESULT; stdcall;

        /// Returns the number of segments the ink is composed of.
        function GetSegmentCount(): uint32; stdcall;

        /// Retrieve the segments stored in the ink.
        function GetSegments(startSegment: uint32;
        {_Out_writes_(segmentsCount) } segments: PD2D1_INK_BEZIER_SEGMENT; segmentsCount: uint32): HRESULT; stdcall;

        /// Construct a geometric representation of the ink.
        function StreamAsGeometry(
        {_In_opt_ } inkStyle: ID2D1InkStyle;
        {_In_opt_ } worldTransform: PD2D1_MATRIX_3X2_F; flatteningTolerance: single;
        {_In_ } geometrySink: ID2D1SimplifiedGeometrySink): HRESULT; stdcall;

        /// Retrieve the bounds of the ink, with an optional applied transform.
        function GetBounds(
        {_In_opt_ } inkStyle: ID2D1InkStyle;
        {_In_opt_ } worldTransform: PD2D1_MATRIX_3X2_F;
        {_Out_ } bounds: PD2D1_RECT_F): HRESULT; stdcall;

    end;

    ID2D1InkHelper = type helper for ID2D1Ink
        /// Resets the ink start point.
        procedure SetStartPoint(startPoint: TD2D1_INK_POINT); overload;

        function SetSegmentAtEnd(segment: TD2D1_INK_BEZIER_SEGMENT): HRESULT; overload;

        /// Construct a geometric representation of the ink.
        function StreamAsGeometry(
        {_In_opt_ } inkStyle: ID2D1InkStyle; worldTransform: TD2D1_MATRIX_3X2_F; flatteningTolerance: single;
        {_In_ } geometrySink: ID2D1SimplifiedGeometrySink): HRESULT; overload;

        /// Construct a geometric representation of the ink.
        function StreamAsGeometry(
        {_In_opt_ } inkStyle: ID2D1InkStyle;
        {_In_opt_ } worldTransform: PD2D1_MATRIX_3X2_F;
        {_In_ } geometrySink: ID2D1SimplifiedGeometrySink): HRESULT; overload;

        /// Construct a geometric representation of the ink.
        function StreamAsGeometry(
        {_In_opt_ } inkStyle: ID2D1InkStyle; worldTransform: TD2D1_MATRIX_3X2_F;
        {_In_ } geometrySink: ID2D1SimplifiedGeometrySink): HRESULT; overload;

    end;

    /// Represents a device-dependent representation of a gradient mesh composed of
    /// patches. Use the ID2D1DeviceContext2::CreateGradientMesh method to create an
    /// instance of ID2D1GradientMesh.
    ID2D1GradientMesh = interface(ID2D1Resource)
        ['{f292e401-c050-4cde-83d7-04962d3b23c2}']
        /// Returns the number of patches of the gradient mesh.
        function GetPatchCount(): uint32; stdcall;

        /// Retrieve the patch data stored in the gradient mesh.
        function GetPatches(startIndex: uint32;
        {_Out_writes_(patchesCount) } patches: PD2D1_GRADIENT_MESH_PATCH; patchesCount: uint32): HRESULT; stdcall;

    end;

    /// Represents a producer of pixels that can fill an arbitrary 2D plane.
    ID2D1ImageSource = interface(ID2D1Image)
        ['{c9b664e5-74a1-4378-9ac2-eefc37a3f4d8}']
        function OfferResources(): HRESULT; stdcall;

        function TryReclaimResources(
        {_Out_ } resourcesDiscarded: Pboolean): HRESULT; stdcall;

    end;

    /// Produces 2D pixel data that has been sourced from WIC.
    ID2D1ImageSourceFromWic = interface(ID2D1ImageSource)
        ['{77395441-1c8f-4555-8683-f50dab0fe792}']
        function EnsureCached(
        {_In_opt_ } rectangleToFill: PD2D1_RECT_U): HRESULT; stdcall;

        function TrimCache(
        {_In_opt_ } rectangleToPreserve: PD2D1_RECT_U): HRESULT; stdcall;

        procedure GetSource(
        {_Outptr_result_maybenull_ }  out wicBitmapSource: IWICBitmapSource); stdcall;

    end;

    ID2D1ImageSourceFromWicHelper = type helper for ID2D1ImageSourceFromWic
        function EnsureCached(rectangleToFill: TD2D1_RECT_U): HRESULT; overload;

        function TrimCache(rectangleToPreserve: TD2D1_RECT_U): HRESULT; overload;

    end;

    /// Represents an image source which shares resources with an original image source.
    ID2D1TransformedImageSource = interface(ID2D1Image)
        ['{7f1f79e5-2796-416c-8f55-700f911445e5}']
        procedure GetSource(
        {_Outptr_result_maybenull_ }  out imageSource: ID2D1ImageSource); stdcall;

        procedure GetProperties(
        {_Out_ } properties: PD2D1_TRANSFORMED_IMAGE_SOURCE_PROPERTIES); stdcall;

    end;

    /// A container for 3D lookup table data that can be passed to the LookupTable3D
    /// effect.
    ID2D1LookupTable3D = interface(ID2D1Resource)
        ['{53dd9855-a3b0-4d5b-82e1-26e25c5e5797}']
    end;

    /// This interface performs all the same functions as the ID2D1DeviceContext1
    /// interface, plus it enables functionality such as ink rendering, gradient mesh
    /// rendering, and improved image loading.
    ID2D1DeviceContext2 = interface(ID2D1DeviceContext1)
        ['{394ea6a3-0c34-4321-950b-6ca20f0be6c7}']
        function CreateInk(
        {_In_ } startPoint: PD2D1_INK_POINT;
        {_COM_Outptr_ }  out ink: ID2D1Ink): HRESULT; stdcall;

        /// Creates a new ink style.
        function CreateInkStyle(
        {_In_opt_ } inkStyleProperties: PD2D1_INK_STYLE_PROPERTIES;
        {_COM_Outptr_ }  out inkStyle: ID2D1InkStyle): HRESULT; stdcall;

        function CreateGradientMesh(
        {_In_reads_(patchesCount) } patches: PD2D1_GRADIENT_MESH_PATCH; patchesCount: uint32;
        {_COM_Outptr_ }  out gradientMesh: ID2D1GradientMesh): HRESULT; stdcall;

        function CreateImageSourceFromWic(
        {_In_ } wicBitmapSource: IWICBitmapSource; loadingOptions: TD2D1_IMAGE_SOURCE_LOADING_OPTIONS; alphaMode: TD2D1_ALPHA_MODE;
        {_COM_Outptr_ }  out imageSource: ID2D1ImageSourceFromWic): HRESULT; stdcall;

        /// Creates a 3D lookup table for mapping a 3-channel input to a 3-channel output.
        /// The table data must be provided in 4-channel format.
        function CreateLookupTable3D(precision: TD2D1_BUFFER_PRECISION;
        {_In_reads_(3) } extents: PUINT32;
        {_In_reads_(dataCount) } Data: pbyte; dataCount: uint32;
        {_In_reads_(2) } strides: PUINT32;
        {_COM_Outptr_ }  out lookupTable: ID2D1LookupTable3D): HRESULT; stdcall;

        function CreateImageSourceFromDxgi(
        {_In_reads_(surfaceCount) } surfaces: PIDXGISurface; surfaceCount: uint32; colorSpace: TDXGI_COLOR_SPACE_TYPE; options: TD2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS;
        {_COM_Outptr_ }  out imageSource: ID2D1ImageSource): HRESULT; stdcall;

        /// Retrieves the world-space bounds in DIPs of the gradient mesh using the device
        /// context DPI.
        function GetGradientMeshWorldBounds(
        {_In_ } gradientMesh: ID2D1GradientMesh;
        {_Out_ } pBounds: PD2D1_RECT_F): HRESULT; stdcall;

        procedure DrawInk(
        {_In_ } ink: ID2D1Ink;
        {_In_ } brush: ID2D1Brush;
        {_In_opt_ } inkStyle: ID2D1InkStyle); stdcall;

        procedure DrawGradientMesh(
        {_In_ } gradientMesh: ID2D1GradientMesh); stdcall;

        /// Draw a metafile to the device context.
        procedure DrawGdiMetafile(
        {_In_ } gdiMetafile: ID2D1GdiMetafile;
        {_In_opt_ } destinationRectangle: PD2D1_RECT_F;
        {_In_opt_ } sourceRectangle: PD2D1_RECT_F = nil); stdcall;

        /// Creates an image source which shares resources with an original.
        function CreateTransformedImageSource(
        {_In_ } imageSource: ID2D1ImageSource;
        {_In_ } properties: PD2D1_TRANSFORMED_IMAGE_SOURCE_PROPERTIES;
        {_COM_Outptr_ }  out transformedImageSource: ID2D1TransformedImageSource): HRESULT; stdcall;

    end;

    ID2D1DeviceContext2Helper = type helper for ID2D1DeviceContext2
        function CreateInk(startPoint: TD2D1_INK_POINT;
        {_COM_Outptr_ }  out ink: ID2D1Ink): HRESULT; overload;

        /// Creates a new ink style.
        function CreateInkStyle(inkStyleProperties: TD2D1_INK_STYLE_PROPERTIES;
        {_COM_Outptr_ }  out inkStyle: ID2D1InkStyle): HRESULT; overload;

        function CreateImageSourceFromWic(
        {_In_ } wicBitmapSource: IWICBitmapSource; loadingOptions: TD2D1_IMAGE_SOURCE_LOADING_OPTIONS;
        {_COM_Outptr_ }  out imageSource: ID2D1ImageSourceFromWic): HRESULT; overload;

        function CreateImageSourceFromWic(
        {_In_ } wicBitmapSource: IWICBitmapSource;
        {_COM_Outptr_ }  out imageSource: ID2D1ImageSourceFromWic): HRESULT; overload;

        /// Draw a metafile to the device context.
        procedure DrawGdiMetafile(
        {_In_ } gdiMetafile: ID2D1GdiMetafile; destinationRectangle: TD2D1_RECT_F; sourceRectangle: TD2D1_RECT_F); overload;

        /// Draw a metafile to the device context.
        procedure DrawGdiMetafile(
        {_In_ } gdiMetafile: ID2D1GdiMetafile; destinationRectangle: TD2D1_RECT_F;
        {_In_ } sourceRectangle: PD2D1_RECT_F = nil); overload;

    end;

    /// Represents a resource domain whose objects and device contexts can be used
    /// together. This interface performs all the same functions as the existing
    /// ID2D1Device1 interface. It also enables the creation of ID2D1DeviceContext2
    /// objects.
    ID2D1Device2 = interface(ID2D1Device1)
        ['{a44472e1-8dfb-4e60-8492-6e2861c9ca8b}']
        /// Creates a new device context with no initially assigned target.
        function CreateDeviceContext(options: TD2D1_DEVICE_CONTEXT_OPTIONS;
        {_COM_Outptr_ }  out deviceContext2: ID2D1DeviceContext2): HRESULT; stdcall;

        /// Flush all device contexts that reference a given bitmap.
        procedure FlushDeviceContexts(
        {_In_ } bitmap: ID2D1Bitmap); stdcall;

        /// Returns the DXGI device associated with this D2D device.
        function GetDxgiDevice(
        {_COM_Outptr_ }  out dxgiDevice: IDXGIDevice): HRESULT; stdcall;

    end;

    /// Creates Direct2D resources. This interface also enables the creation of
    /// ID2D1Device2 objects.
    ID2D1Factory3 = interface(ID2D1Factory2)
        ['{0869759f-4f00-413f-b03e-2bda45404d0f}']
        /// This creates a new Direct2D device from the given IDXGIDevice.
        function CreateDevice(
        {_In_ } dxgiDevice: IDXGIDevice;
        {_COM_Outptr_ }  out d2dDevice2: ID2D1Device2): HRESULT; stdcall;

    end;

    /// This interface performs all the same functions as the existing ID2D1CommandSink1
    /// interface. It also enables access to ink rendering and gradient mesh rendering.
    ID2D1CommandSink2 = interface(ID2D1CommandSink1)
        ['{3bab440e-417e-47df-a2e2-bc0be6a00916}']
        function DrawInk(
        {_In_ } ink: ID2D1Ink;
        {_In_ } brush: ID2D1Brush;
        {_In_opt_ } inkStyle: ID2D1InkStyle): HRESULT; stdcall;

        function DrawGradientMesh(
        {_In_ } gradientMesh: ID2D1GradientMesh): HRESULT; stdcall;

        function DrawGdiMetafile(
        {_In_ } gdiMetafile: ID2D1GdiMetafile;
        {_In_opt_ } destinationRectangle: PD2D1_RECT_F;
        {_In_opt_ } sourceRectangle: PD2D1_RECT_F): HRESULT; stdcall;

    end;

    /// Interface encapsulating a GDI/GDI+ metafile.
    ID2D1GdiMetafile1 = interface(ID2D1GdiMetafile)
        ['{2e69f9e8-dd3f-4bf9-95ba-c04f49d788df}']
        /// Returns the DPI reported by the metafile.
        function GetDpi(
        {_Out_ } dpiX: Psingle;
        {_Out_ } dpiY: Psingle): HRESULT; stdcall;

        /// Gets the bounds (in DIPs) of the metafile (as specified by the frame rect
        /// declared in the metafile).
        function GetSourceBounds(
        {_Out_ } bounds: PD2D1_RECT_F): HRESULT; stdcall;

    end;

    /// User-implementable interface for introspecting on a metafile.
    ID2D1GdiMetafileSink1 = interface(ID2D1GdiMetafileSink)
        ['{fd0ecb6b-91e6-411e-8655-395e760f91b4}']
        /// Callback for examining a metafile record.
        function ProcessRecord(recordType: DWORD;
        {_In_opt_ } recordData: Pvoid; recordDataSize: DWORD; flags: uint32): HRESULT; stdcall;

    end;


    ID2D1SpriteBatch = interface(ID2D1Resource)
        ['{4dc583bf-3a10-438a-8722-e9765224f1f1}']
        /// Adds sprites to the end of the sprite batch.
        function AddSprites(spriteCount: uint32;
        {_In_reads_bytes_(sizeof(D2D1_RECT_F) + (spriteCount - 1) * destinationRectanglesStride) } destinationRectangles: PD2D1_RECT_F;
        {_In_reads_bytes_opt_(sizeof(D2D1_RECT_U) + (spriteCount - 1) * sourceRectanglesStride) } sourceRectangles: PD2D1_RECT_U = nil;
        {_In_reads_bytes_opt_(sizeof(D2D1_COLOR_F) + (spriteCount - 1) * colorsStride) } colors: PD2D1_COLOR_F = nil;
        {_In_reads_bytes_opt_(sizeof(D2D1_MATRIX_3X2_F) + (spriteCount - 1) * transformsStride) } transforms: PD2D1_MATRIX_3X2_F = nil; destinationRectanglesStride: uint32 = sizeof(TD2D1_RECT_F);
            sourceRectanglesStride: uint32 = sizeof(TD2D1_RECT_U); colorsStride: uint32 = sizeof(TD2D1_COLOR_F); transformsStride: uint32 = sizeof(TD2D1_MATRIX_3X2_F)): HRESULT; stdcall;

        /// Set properties for existing sprites. All properties not specified are
        /// unmodified.
        function SetSprites(startIndex: uint32; spriteCount: uint32;
        {_In_reads_bytes_opt_(sizeof(D2D1_RECT_F) + (spriteCount - 1) * destinationRectanglesStride) } destinationRectangles: PD2D1_RECT_F = nil;
        {_In_reads_bytes_opt_(sizeof(D2D1_RECT_U) + (spriteCount - 1) * sourceRectanglesStride) } sourceRectangles: PD2D1_RECT_U = nil;
        {_In_reads_bytes_opt_(sizeof(D2D1_COLOR_F) + (spriteCount - 1) * colorsStride) } colors: PD2D1_COLOR_F = nil;
        {_In_reads_bytes_opt_(sizeof(D2D1_MATRIX_3X2_F) + (spriteCount - 1) * transformsStride) } transforms: PD2D1_MATRIX_3X2_F = nil; destinationRectanglesStride: uint32 = sizeof(TD2D1_RECT_F);
            sourceRectanglesStride: uint32 = sizeof(TD2D1_RECT_U); colorsStride: uint32 = sizeof(TD2D1_COLOR_F); transformsStride: uint32 = sizeof(TD2D1_MATRIX_3X2_F)): HRESULT; stdcall;

        /// Retrieves sprite properties.
        function GetSprites(startIndex: uint32; spriteCount: uint32;
        {_Out_writes_opt_(spriteCount) } destinationRectangles: PD2D1_RECT_F = nil;
        {_Out_writes_opt_(spriteCount) } sourceRectangles: PD2D1_RECT_U = nil;
        {_Out_writes_opt_(spriteCount) } colors: PD2D1_COLOR_F = nil;
        {_Out_writes_opt_(spriteCount) } transforms: PD2D1_MATRIX_3X2_F = nil): HRESULT; stdcall;

        /// Retrieves the number of sprites in the sprite batch.
        function GetSpriteCount(): uint32; stdcall;

        /// Removes all sprites from the sprite batch.
        procedure Clear(); stdcall;

    end;

    ID2D1DeviceContext3 = interface(ID2D1DeviceContext2)
        ['{235a7496-8351-414c-bcd4-6672ab2d8e00}']
        /// Creates a new sprite batch.
        function CreateSpriteBatch(
        {_COM_Outptr_ }  out spriteBatch: ID2D1SpriteBatch): HRESULT; stdcall;

        /// Draws sprites in a sprite batch.
        procedure DrawSpriteBatch(
        {_In_ } spriteBatch: ID2D1SpriteBatch; startIndex: uint32; spriteCount: uint32;
        {_In_ } bitmap: ID2D1Bitmap; interpolationMode: TD2D1_BITMAP_INTERPOLATION_MODE = D2D1_BITMAP_INTERPOLATION_MODE_LINEAR; spriteOptions: TD2D1_SPRITE_OPTIONS = D2D1_SPRITE_OPTIONS_NONE); stdcall;

    end;

    ID2D1DeviceContext3Helper = type helper for ID2D1DeviceContext3
        /// Draws all sprites in a sprite batch.
        procedure DrawSpriteBatch(
        {_In_ } spriteBatch: ID2D1SpriteBatch;
        {_In_ } bitmap: ID2D1Bitmap; interpolationMode: TD2D1_BITMAP_INTERPOLATION_MODE = D2D1_BITMAP_INTERPOLATION_MODE_LINEAR; spriteOptions: TD2D1_SPRITE_OPTIONS = D2D1_SPRITE_OPTIONS_NONE); overload;

    end;

    ID2D1Device3 = interface(ID2D1Device2)
        ['{852f2087-802c-4037-ab60-ff2e7ee6fc01}']
        /// Creates a new device context with no initially assigned target.
        function CreateDeviceContext(options: TD2D1_DEVICE_CONTEXT_OPTIONS;
        {_COM_Outptr_ }  out deviceContext3: ID2D1DeviceContext3): HRESULT; stdcall;

    end;

    /// Creates Direct2D resources. This interface also enables the creation of
    /// ID2D1Device3 objects.
    ID2D1Factory4 = interface(ID2D1Factory3)
        ['{bd4ec2d2-0662-4bee-ba8e-6f29f032e096}']
        /// This creates a new Direct2D device from the given IDXGIDevice.
        function CreateDevice(
        {_In_ } dxgiDevice: IDXGIDevice;
        {_COM_Outptr_ }  out d2dDevice3: ID2D1Device3): HRESULT; stdcall;

    end;

    ID2D1CommandSink3 = interface(ID2D1CommandSink2)
        ['{18079135-4cf3-4868-bc8e-06067e6d242d}']
        function DrawSpriteBatch(
        {_In_ } spriteBatch: ID2D1SpriteBatch; startIndex: uint32; spriteCount: uint32;
        {_In_ } bitmap: ID2D1Bitmap; interpolationMode: TD2D1_BITMAP_INTERPOLATION_MODE; spriteOptions: TD2D1_SPRITE_OPTIONS): HRESULT; stdcall;

    end;


    /// This object supplies the values for context-fill, context-stroke, and
    /// context-value that are used when rendering SVG glyphs.
    ID2D1SvgGlyphStyle = interface(ID2D1Resource)
        ['{af671749-d241-4db8-8e41-dcc2e5c1a438}']
        /// Provides values to an SVG glyph for fill. The brush with opacity set to 1 is
        /// used as the 'context-fill'. The opacity of the brush is used as the
        /// 'context-fill-opacity' value.
        /// <param name="brush">A null brush will cause the context-fill value to come from
        /// the defaultFillBrush. If the defaultFillBrush is also null, the context-fill
        /// value will be 'none'.</param>
        function SetFill(
        {_In_opt_ } brush: ID2D1Brush): HRESULT; stdcall;

        /// Returns the requested fill parameters.
        procedure GetFill(
        {_Outptr_result_maybenull_ }  out brush: ID2D1Brush); stdcall;

        /// Provides values to an SVG glyph for stroke properties. The brush with opacity
        /// set to 1 is used as the 'context-stroke'. The opacity of the brush is used as
        /// the 'context-stroke-opacity' value.
        /// <param name="brush">A null brush will cause the context-stroke value to be
        /// 'none'.</param>
        /// <param name="strokeWidth">Specifies the 'context-value' for the 'stroke-width'
        /// property.</param>
        /// <param name="dashes">Specifies the 'context-value' for the 'stroke-dasharray'
        /// property. A null value will cause the stroke-dasharray to be set to 'none'.
        /// </param>
        /// <param name="dashOffset">Specifies the 'context-value' for the
        /// 'stroke-dashoffset' property.</param>
        function SetStroke(
        {_In_opt_ } brush: ID2D1Brush; strokeWidth: single = 1.0;
        {_In_reads_opt_(dashesCount) } dashes: Psingle = nil; dashesCount: uint32 = 0; dashOffset: single = 1.0): HRESULT; stdcall;

        /// Returns the number of dashes in the dash array.
        function GetStrokeDashesCount(): uint32; stdcall;

        /// Returns the requested stroke parameters.
        procedure GetStroke(
        {_Outptr_opt_result_maybenull_ }  out brush: ID2D1Brush;
        {_Out_opt_ } strokeWidth: Psingle = nil;
        {_Out_writes_opt_(dashesCount) } dashes: Psingle = nil; dashesCount: uint32 = 0;
        {_Out_opt_ } dashOffset: Psingle = nil); stdcall;

    end;

    ID2D1DeviceContext4 = interface(ID2D1DeviceContext3)
        ['{8c427831-3d90-4476-b647-c4fae349e4db}']
        /// Creates an SVG glyph style object.
        function CreateSvgGlyphStyle(
        {_COM_Outptr_ }  out svgGlyphStyle: ID2D1SvgGlyphStyle): HRESULT; stdcall;

        /// Draws the text within the given layout rectangle. By default, this method
        /// performs baseline snapping and renders color versions of glyphs in color fonts.
        /// <param name="svgGlyphStyle">Object used to style SVG glyphs.</param>
        /// <param name="colorPaletteIndex">The index used to select a color palette within
        /// a color font.</param>
        procedure DrawText(
        {_In_reads_(stringLength) } _string: PWCHAR; stringLength: uint32;
        {_In_ } textFormat: IDWriteTextFormat;
        {_In_ } layoutRect: PD2D1_RECT_F;
        {_In_opt_ } defaultFillBrush: ID2D1Brush;
        {_In_opt_ } svgGlyphStyle: ID2D1SvgGlyphStyle; colorPaletteIndex: uint32 = 0; options: TD2D1_DRAW_TEXT_OPTIONS = D2D1_DRAW_TEXT_OPTIONS_ENABLE_COLOR_FONT;
            measuringMode: TDWRITE_MEASURING_MODE = DWRITE_MEASURING_MODE_NATURAL); stdcall;

        /// Draw a text layout object. If the layout is not subsequently changed, this can
        /// be more efficient than DrawText when drawing the same layout repeatedly.
        /// <param name="svgGlyphStyle">Object used to style SVG glyphs.</param>
        /// <param name="colorPaletteIndex">The index used to select a color palette within
        /// a color font.</param>
        /// <param name="options">The specified text options. If D2D1_DRAW_TEXT_OPTIONS_CLIP
        /// is used, the text is clipped to the layout bounds. These bounds are derived from
        /// the origin and the layout bounds of the corresponding IDWriteTextLayout object.
        /// </param>
        procedure DrawTextLayout(origin: TD2D1_POINT_2F;
        {_In_ } textLayout: IDWriteTextLayout;
        {_In_opt_ } defaultFillBrush: ID2D1Brush;
        {_In_opt_ } svgGlyphStyle: ID2D1SvgGlyphStyle; colorPaletteIndex: uint32 = 0; options: TD2D1_DRAW_TEXT_OPTIONS = D2D1_DRAW_TEXT_OPTIONS_ENABLE_COLOR_FONT); stdcall;

        /// Draws a color glyph run using one (and only one) of the bitmap formats-
        /// DWRITE_GLYPH_IMAGE_FORMATS_PNG, DWRITE_GLYPH_IMAGE_FORMATS_JPEG,
        /// DWRITE_GLYPH_IMAGE_FORMATS_TIFF, or
        /// DWRITE_GLYPH_IMAGE_FORMATS_PREMULTIPLIED_B8G8R8A8.
        procedure DrawColorBitmapGlyphRun(glyphImageFormat: TDWRITE_GLYPH_IMAGE_FORMATS; baselineOrigin: TD2D1_POINT_2F;
        {_In_ } glyphRun: PDWRITE_GLYPH_RUN; measuringMode: TDWRITE_MEASURING_MODE = DWRITE_MEASURING_MODE_NATURAL; bitmapSnapOption: TD2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION = D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION_DEFAULT); stdcall;

        /// Draws a color glyph run that has the format of DWRITE_GLYPH_IMAGE_FORMATS_SVG.
        /// <param name="svgGlyphStyle">Object used to style SVG glyphs.</param>
        /// <param name="colorPaletteIndex">The index used to select a color palette within
        /// a color font. Note that this not the same as the paletteIndex in the
        /// DWRITE_COLOR_GLYPH_RUN struct, which is not relevant for SVG glyphs.</param>
        procedure DrawSvgGlyphRun(baselineOrigin: TD2D1_POINT_2F;
        {_In_ } glyphRun: PDWRITE_GLYPH_RUN;
        {_In_opt_ } defaultFillBrush: ID2D1Brush = nil;
        {_In_opt_ } svgGlyphStyle: ID2D1SvgGlyphStyle = nil; colorPaletteIndex: uint32 = 0; measuringMode: TDWRITE_MEASURING_MODE = DWRITE_MEASURING_MODE_NATURAL); stdcall;

        /// Retrieves an image of the color bitmap glyph from the color glyph cache. If the
        /// cache does not already contain the requested resource, it will be created. This
        /// method may be used to extend the lifetime of a glyph image even after it is
        /// evicted from the color glyph cache.
        /// <param name="fontEmSize">The specified font size affects the choice of which
        /// bitmap to use from the font. It also affects the output glyphTransform, causing
        /// it to properly scale the glyph.</param>
        /// <param name="glyphTransform">Output transform, which transforms from the glyph's
        /// space to the same output space as the worldTransform. This includes the input
        /// glyphOrigin, the glyph's offset from the glyphOrigin, and any other required
        /// transformations.</param>
        function GetColorBitmapGlyphImage(glyphImageFormat: TDWRITE_GLYPH_IMAGE_FORMATS; glyphOrigin: TD2D1_POINT_2F;
        {_In_ } fontFace: IDWriteFontFace; fontEmSize: single; glyphIndex: uint16; isSideways: boolean;
        {_In_opt_ } worldTransform: PD2D1_MATRIX_3X2_F; dpiX: single; dpiY: single;
        {_Out_ } glyphTransform: PD2D1_MATRIX_3X2_F;
        {_COM_Outptr_ }  out glyphImage: ID2D1Image): HRESULT; stdcall;

        /// Retrieves an image of the SVG glyph from the color glyph cache. If the cache
        /// does not already contain the requested resource, it will be created. This method
        /// may be used to extend the lifetime of a glyph image even after it is evicted
        /// from the color glyph cache.
        /// <param name="fontEmSize">The specified font size affects the output
        /// glyphTransform, causing it to properly scale the glyph.</param>
        /// <param name="svgGlyphStyle">Object used to style SVG glyphs.</param>
        /// <param name="colorPaletteIndex">The index used to select a color palette within
        /// a color font. Note that this not the same as the paletteIndex in the
        /// DWRITE_COLOR_GLYPH_RUN struct, which is not relevant for SVG glyphs.</param>
        /// <param name="glyphTransform">Output transform, which transforms from the glyph's
        /// space to the same output space as the worldTransform. This includes the input
        /// glyphOrigin, the glyph's offset from the glyphOrigin, and any other required
        /// transformations.</param>
        function GetSvgGlyphImage(glyphOrigin: TD2D1_POINT_2F;
        {_In_ } fontFace: IDWriteFontFace; fontEmSize: single; glyphIndex: uint16; isSideways: boolean;
        {_In_opt_ } worldTransform: PD2D1_MATRIX_3X2_F;
        {_In_opt_ } defaultFillBrush: ID2D1Brush;
        {_In_opt_ } svgGlyphStyle: ID2D1SvgGlyphStyle; colorPaletteIndex: uint32;
        {_Out_ } glyphTransform: PD2D1_MATRIX_3X2_F;
        {_COM_Outptr_ }  out glyphImage: ID2D1CommandList): HRESULT; stdcall;

    end;

    ID2D1DeviceContext4Helper = type helper for ID2D1DeviceContext4
        /// Draws the text within the given layout rectangle. By default, this method
        /// performs baseline snapping and renders color versions of glyphs in color fonts.
        /// <param name="svgGlyphStyle">Object used to style SVG glyphs.</param>
        /// <param name="colorPaletteIndex">The index used to select a color palette within
        /// a color font.</param>
        procedure DrawText(
        {_In_reads_(stringLength) } _string: PWCHAR; stringLength: uint32;
        {_In_ } textFormat: IDWriteTextFormat; layoutRect: TD2D1_RECT_F;
        {_In_opt_ } defaultFillBrush: ID2D1Brush;
        {_In_opt_ } svgGlyphStyle: ID2D1SvgGlyphStyle; colorPaletteIndex: uint32 = 0; options: TD2D1_DRAW_TEXT_OPTIONS = D2D1_DRAW_TEXT_OPTIONS_ENABLE_COLOR_FONT;
            measuringMode: TDWRITE_MEASURING_MODE = DWRITE_MEASURING_MODE_NATURAL); overload;

    end;

    ID2D1Device4 = interface(ID2D1Device3)
        ['{d7bdb159-5683-4a46-bc9c-72dc720b858b}']
        /// Creates a new device context with no initially assigned target.
        function CreateDeviceContext(options: TD2D1_DEVICE_CONTEXT_OPTIONS;
        {_COM_Outptr_ }  out deviceContext4: ID2D1DeviceContext4): HRESULT; stdcall;

        /// Sets the maximum capacity of the color glyph cache. This cache is used to store
        /// color bitmap glyphs and SVG glyphs, enabling faster performance if the same
        /// glyphs are needed again. If the application still references a glyph using
        /// GetColorBitmapGlyphImage or GetSvgGlyphImage after it has been evicted, this
        /// glyph does not count toward the cache capacity.
        procedure SetMaximumColorGlyphCacheMemory(maximumInBytes: uint64); stdcall;

        /// Gets the maximum capacity of the color glyph cache.
        function GetMaximumColorGlyphCacheMemory(): uint64; stdcall;

    end;

    /// Creates Direct2D resources. This interface also enables the creation of
    /// ID2D1Device4 objects.
    ID2D1Factory5 = interface(ID2D1Factory4)
        ['{c4349994-838e-4b0f-8cab-44997d9eeacc}']
        /// This creates a new Direct2D device from the given IDXGIDevice.
        function CreateDevice(
        {_In_ } dxgiDevice: IDXGIDevice;
        {_COM_Outptr_ }  out d2dDevice4: ID2D1Device4): HRESULT; stdcall;

    end;


    ID2D1CommandSink4 = interface(ID2D1CommandSink3)
        ['{c78a6519-40d6-4218-b2de-beeeb744bb3e}']
        /// A new function to set blend mode that respects the new MAX blend.
        ///
        /// Implementers of SetPrimitiveBlend2 should expect and handle blend mode:
        /// D2D1_PRIMITIVE_BLEND_MAX
        ///
        /// Implementers of SetPrimitiveBlend1 should expect and handle blend modes:
        /// D2D1_PRIMITIVE_BLEND_MIN and D2D1_PRIMITIVE_BLEND_ADD
        ///
        /// Implementers of SetPrimitiveBlend should expect and handle blend modes:
        /// D2D1_PRIMITIVE_BLEND_SOURCE_OVER and D2D1_PRIMITIVE_BLEND_COPY
        function SetPrimitiveBlend2(primitiveBlend: TD2D1_PRIMITIVE_BLEND): HRESULT; stdcall;

    end;

    /// Represents a color context to be used with the Color Management Effect.
    ID2D1ColorContext1 = interface(ID2D1ColorContext)
        ['{1ab42875-c57f-4be9-bd85-9cd78d6f55ee}']
        /// Retrieves the color context type.
        function GetColorContextType(): TD2D1_COLOR_CONTEXT_TYPE; stdcall;

        /// Retrieves the DXGI color space of this context. Returns DXGI_COLOR_SPACE_CUSTOM
        /// when color context type is ICC.
        function GetDXGIColorSpace(): TDXGI_COLOR_SPACE_TYPE; stdcall;

        /// Retrieves a set simple color profile.
        function GetSimpleColorProfile(
        {_Out_ } simpleProfile: PD2D1_SIMPLE_COLOR_PROFILE): HRESULT; stdcall;

    end;

    ID2D1DeviceContext5 = interface(ID2D1DeviceContext4)
        ['{7836d248-68cc-4df6-b9e8-de991bf62eb7}']
        /// Creates an SVG document from a stream.
        /// <param name="inputXmlStream">An input stream containing the SVG XML document. If
        /// null, an empty document is created.</param>
        /// <param name="viewportSize">Size of the initial viewport of the document.</param>
        /// <param name="svgDocument">When this method returns, contains a pointer to the
        /// SVG document.</param>
        function CreateSvgDocument(
        {_In_opt_ } inputXmlStream: IStream; viewportSize: TD2D1_SIZE_F;
        {_COM_Outptr_ }  out svgDocument: ID2D1SvgDocument): HRESULT; stdcall;

        /// Draw an SVG document.
        procedure DrawSvgDocument(
        {_In_ } svgDocument: ID2D1SvgDocument); stdcall;

        /// Creates a color context from a DXGI color space type. It is only valid to use
        /// this with the Color Management Effect in 'Best' mode.
        function CreateColorContextFromDxgiColorSpace(colorSpace: TDXGI_COLOR_SPACE_TYPE;
        {_COM_Outptr_ }  out colorContext: ID2D1ColorContext1): HRESULT; stdcall;

        /// Creates a color context from a simple color profile. It is only valid to use
        /// this with the Color Management Effect in 'Best' mode.
        function CreateColorContextFromSimpleColorProfile(
        {_In_ } simpleProfile: PD2D1_SIMPLE_COLOR_PROFILE;
        {_COM_Outptr_ }  out colorContext: ID2D1ColorContext1): HRESULT; stdcall;

    end;

    ID2D1DeviceContext5Helper = type helper for ID2D1DeviceContext5
        /// Creates a color context from a simple color profile.
        function CreateColorContextFromSimpleColorProfile(simpleProfile: TD2D1_SIMPLE_COLOR_PROFILE;
        {_COM_Outptr_ }  out colorContext: ID2D1ColorContext1): HRESULT; overload;

    end;

    ID2D1Device5 = interface(ID2D1Device4)
        ['{d55ba0a4-6405-4694-aef5-08ee1a4358b4}']
        /// Creates a new device context with no initially assigned target.
        function CreateDeviceContext(options: TD2D1_DEVICE_CONTEXT_OPTIONS;
        {_COM_Outptr_ }  out deviceContext5: ID2D1DeviceContext5): HRESULT; stdcall;

    end;

    /// Creates Direct2D resources. This interface also enables the creation of
    /// ID2D1Device5 objects.
    ID2D1Factory6 = interface(ID2D1Factory5)
        ['{f9976f46-f642-44c1-97ca-da32ea2a2635}']
        /// This creates a new Direct2D device from the given IDXGIDevice.
        function CreateDevice(
        {_In_ } dxgiDevice: IDXGIDevice;
        {_COM_Outptr_ }  out d2dDevice5: ID2D1Device5): HRESULT; stdcall;

    end;


    ID2D1CommandSink5 = interface(ID2D1CommandSink4)
        ['{7047dd26-b1e7-44a7-959a-8349e2144fa8}']
        function BlendImage(
        {_In_ } image: ID2D1Image; blendMode: TD2D1_BLEND_MODE;
        {_In_opt_ } targetOffset: PD2D1_POINT_2F;
        {_In_opt_ } imageRectangle: PD2D1_RECT_F; interpolationMode: TD2D1_INTERPOLATION_MODE): HRESULT; stdcall;

    end;

    ID2D1DeviceContext6 = interface(ID2D1DeviceContext5)
        ['{985f7e37-4ed0-4a19-98a3-15b0edfde306}']
        /// Draw an image to the device context.
        procedure BlendImage(
        {_In_ } image: ID2D1Image; blendMode: TD2D1_BLEND_MODE;
        {_In_opt_ } targetOffset: PD2D1_POINT_2F = nil;
        {_In_opt_ } imageRectangle: PD2D1_RECT_F = nil; interpolationMode: TD2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR); stdcall;

    end;

    ID2D1Device6 = interface(ID2D1Device5)
        ['{7bfef914-2d75-4bad-be87-e18ddb077b6d}']
        /// Creates a new device context with no initially assigned target.
        function CreateDeviceContext(options: TD2D1_DEVICE_CONTEXT_OPTIONS;
        {_COM_Outptr_ }  out deviceContext6: ID2D1DeviceContext6): HRESULT; stdcall;

    end;

    /// Creates Direct2D resources. This interface also enables the creation of
    /// ID2D1Device6 objects.
    ID2D1Factory7 = interface(ID2D1Factory6)
        ['{bdc2bdd3-b96c-4de6-bdf7-99d4745454de}']
        /// This creates a new Direct2D device from the given IDXGIDevice.
        function CreateDevice(
        {_In_ } dxgiDevice: IDXGIDevice;
        {_COM_Outptr_ }  out d2dDevice6: ID2D1Device6): HRESULT; stdcall;

    end;


    TDWRITE_PAINT_FEATURE_LEVEL = int32;


    PDWRITE_PAINT_FEATURE_LEVEL = ^TDWRITE_PAINT_FEATURE_LEVEL;

    ID2D1DeviceContext7 = interface(ID2D1DeviceContext6)
        ['{ec891cf7-9b69-4851-9def-4e0915771e62}']
        /// Get the maximum paint feature level supported by DrawPaintGlyphRun.
        function GetPaintFeatureLevel(): TDWRITE_PAINT_FEATURE_LEVEL; stdcall;

        /// Draws a color glyph run that has the format of
        /// DWRITE_GLYPH_IMAGE_FORMATS_COLR_PAINT_TREE.
        /// <param name="colorPaletteIndex">The index used to select a color palette within
        /// a color font. Note that this not the same as the paletteIndex in the
        /// DWRITE_COLOR_GLYPH_RUN struct, which is not relevant for paint glyphs.</param>
        procedure DrawPaintGlyphRun(baselineOrigin: TD2D1_POINT_2F;
        {_In_ } glyphRun: PDWRITE_GLYPH_RUN;
        {_In_opt_ } defaultFillBrush: ID2D1Brush = nil; colorPaletteIndex: uint32 = 0; measuringMode: TDWRITE_MEASURING_MODE = DWRITE_MEASURING_MODE_NATURAL); stdcall;

        /// Draws a glyph run, using color representations of glyphs if available.
        procedure DrawGlyphRunWithColorSupport(baselineOrigin: TD2D1_POINT_2F;
        {_In_ } glyphRun: PDWRITE_GLYPH_RUN;
        {_In_opt_ } glyphRunDescription: PDWRITE_GLYPH_RUN_DESCRIPTION;
        {_In_opt_ } foregroundBrush: ID2D1Brush;
        {_In_opt_ } svgGlyphStyle: ID2D1SvgGlyphStyle; colorPaletteIndex: uint32 = 0; measuringMode: TDWRITE_MEASURING_MODE = DWRITE_MEASURING_MODE_NATURAL;
            bitmapSnapOption: TD2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION = D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION_DEFAULT); stdcall;

    end;

    ID2D1Device7 = interface(ID2D1Device6)
        ['{f07c8968-dd4e-4ba6-9cbd-eb6d3752dcbb}']
        /// Creates a new device context with no initially assigned target.
        function CreateDeviceContext(options: TD2D1_DEVICE_CONTEXT_OPTIONS;
        {_COM_Outptr_ }  out deviceContext: ID2D1DeviceContext7): HRESULT; stdcall;

    end;

    /// Creates Direct2D resources. This interface also enables the creation of
    /// ID2D1Device7 objects.
    ID2D1Factory8 = interface(ID2D1Factory7)
        ['{677c9311-f36d-4b1f-ae86-86d1223ffd3a}']
        /// This creates a new Direct2D device from the given IDXGIDevice.
        function CreateDevice(
        {_In_ } dxgiDevice: IDXGIDevice;
        {_COM_Outptr_ }  out d2dDevice6: ID2D1Device7): HRESULT; stdcall;

    end;

procedure D2D1GetGradientMeshInteriorPointsFromCoonsPatch(
    {_In_ } pPoint0: PD2D1_POINT_2F;
    {_In_ } pPoint1: PD2D1_POINT_2F;
    {_In_ } pPoint2: PD2D1_POINT_2F;
    {_In_ } pPoint3: PD2D1_POINT_2F;
    {_In_ } pPoint4: PD2D1_POINT_2F;
    {_In_ } pPoint5: PD2D1_POINT_2F;
    {_In_ } pPoint6: PD2D1_POINT_2F;
    {_In_ } pPoint7: PD2D1_POINT_2F;
    {_In_ } pPoint8: PD2D1_POINT_2F;
    {_In_ } pPoint9: PD2D1_POINT_2F;
    {_In_ } pPoint10: PD2D1_POINT_2F;
    {_In_ } pPoint11: PD2D1_POINT_2F;
    {_Out_ } pTensorPoint11: PD2D1_POINT_2F;
    {_Out_ } pTensorPoint12: PD2D1_POINT_2F;
    {_Out_ } pTensorPoint21: PD2D1_POINT_2F;
    {_Out_ } pTensorPoint22: PD2D1_POINT_2F); stdcall; external 'D2d1.dll';



implementation




procedure ID2D1InkStyleHelper.SetNibTransform(transform: TD2D1_MATRIX_3X2_F);
begin

    SetNibTransform
    (@transform
        );

end;



procedure ID2D1InkHelper.SetStartPoint(startPoint: TD2D1_INK_POINT);
begin

    SetStartPoint
    (@startPoint
        );

end;



function ID2D1InkHelper.SetSegmentAtEnd(segment: TD2D1_INK_BEZIER_SEGMENT): HRESULT;
begin

    Result :=

        SetSegmentAtEnd(@segment);

end;



function ID2D1InkHelper.StreamAsGeometry(
    {_In_opt_ } inkStyle: ID2D1InkStyle; worldTransform: TD2D1_MATRIX_3X2_F; flatteningTolerance: single;
    {_In_ } geometrySink: ID2D1SimplifiedGeometrySink): HRESULT;
begin

    Result :=

        StreamAsGeometry(inkStyle, @worldTransform, flatteningTolerance, geometrySink);

end;



function ID2D1InkHelper.StreamAsGeometry(
    {_In_opt_ } inkStyle: ID2D1InkStyle;
    {_In_opt_ } worldTransform: PD2D1_MATRIX_3X2_F;
    {_In_ } geometrySink: ID2D1SimplifiedGeometrySink): HRESULT;
begin

    Result :=

        StreamAsGeometry(inkStyle, worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, geometrySink);

end;



function ID2D1InkHelper.StreamAsGeometry(
    {_In_opt_ } inkStyle: ID2D1InkStyle; worldTransform: TD2D1_MATRIX_3X2_F;
    {_In_ } geometrySink: ID2D1SimplifiedGeometrySink): HRESULT;
begin

    Result :=

        StreamAsGeometry(inkStyle, @worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, geometrySink);

end;



function ID2D1ImageSourceFromWicHelper.EnsureCached(rectangleToFill: TD2D1_RECT_U): HRESULT;
begin

    Result :=

        EnsureCached(@rectangleToFill);

end;



function ID2D1ImageSourceFromWicHelper.TrimCache(rectangleToPreserve: TD2D1_RECT_U): HRESULT;
begin

    Result :=

        TrimCache(@rectangleToPreserve);

end;



function ID2D1DeviceContext2Helper.CreateInk(startPoint: TD2D1_INK_POINT;
    {_COM_Outptr_ }  out ink: ID2D1Ink): HRESULT;
begin

    Result :=

        CreateInk(@startPoint, ink);

end;



function ID2D1DeviceContext2Helper.CreateInkStyle(inkStyleProperties: TD2D1_INK_STYLE_PROPERTIES;
    {_COM_Outptr_ }  out inkStyle: ID2D1InkStyle): HRESULT;
begin

    Result :=

        CreateInkStyle(@inkStyleProperties, inkStyle);

end;



function ID2D1DeviceContext2Helper.CreateImageSourceFromWic(
    {_In_ } wicBitmapSource: IWICBitmapSource; loadingOptions: TD2D1_IMAGE_SOURCE_LOADING_OPTIONS;
    {_COM_Outptr_ }  out imageSource: ID2D1ImageSourceFromWic): HRESULT;
begin

    Result :=

        CreateImageSourceFromWic(wicBitmapSource, loadingOptions, D2D1_ALPHA_MODE_UNKNOWN, imageSource);

end;



function ID2D1DeviceContext2Helper.CreateImageSourceFromWic(
    {_In_ } wicBitmapSource: IWICBitmapSource;
    {_COM_Outptr_ }  out imageSource: ID2D1ImageSourceFromWic): HRESULT;
begin

    Result :=

        CreateImageSourceFromWic(wicBitmapSource, D2D1_IMAGE_SOURCE_LOADING_OPTIONS_NONE, D2D1_ALPHA_MODE_UNKNOWN, imageSource);

end;



procedure ID2D1DeviceContext2Helper.DrawGdiMetafile(
    {_In_ } gdiMetafile: ID2D1GdiMetafile; destinationRectangle: TD2D1_RECT_F; sourceRectangle: TD2D1_RECT_F);
begin

    DrawGdiMetafile
    (
        gdiMetafile
        , @destinationRectangle
        , @sourceRectangle
        );

end;



procedure ID2D1DeviceContext2Helper.DrawGdiMetafile(
    {_In_ } gdiMetafile: ID2D1GdiMetafile; destinationRectangle: TD2D1_RECT_F;
    {_In_ } sourceRectangle: PD2D1_RECT_F = nil);
begin

    DrawGdiMetafile
    (
        gdiMetafile
        , @destinationRectangle
        ,

        sourceRectangle
        );

end;



procedure ID2D1DeviceContext3Helper.DrawSpriteBatch(
    {_In_ } spriteBatch: ID2D1SpriteBatch;
    {_In_ } bitmap: ID2D1Bitmap; interpolationMode: TD2D1_BITMAP_INTERPOLATION_MODE = D2D1_BITMAP_INTERPOLATION_MODE_LINEAR; spriteOptions: TD2D1_SPRITE_OPTIONS = D2D1_SPRITE_OPTIONS_NONE);
begin

    DrawSpriteBatch
    (
        spriteBatch
        ,

        0
        ,

        spriteBatch.GetSpriteCount()
        ,

        bitmap
        ,

        interpolationMode
        ,

        spriteOptions
        );

end;



procedure ID2D1DeviceContext4Helper.DrawText(
    {_In_reads_(stringLength) } _string: PWCHAR; stringLength: uint32;
    {_In_ } textFormat: IDWriteTextFormat; layoutRect: TD2D1_RECT_F;
    {_In_opt_ } defaultFillBrush: ID2D1Brush;
    {_In_opt_ } svgGlyphStyle: ID2D1SvgGlyphStyle; colorPaletteIndex: uint32 = 0; options: TD2D1_DRAW_TEXT_OPTIONS = D2D1_DRAW_TEXT_OPTIONS_ENABLE_COLOR_FONT; measuringMode: TDWRITE_MEASURING_MODE = DWRITE_MEASURING_MODE_NATURAL);
begin

    DrawText
    (
        _string
        ,

        stringLength
        ,

        textFormat
        , @layoutRect
        ,

        defaultFillBrush
        ,

        svgGlyphStyle
        ,

        colorPaletteIndex
        ,

        options
        ,

        measuringMode
        );

end;



function ID2D1DeviceContext5Helper.CreateColorContextFromSimpleColorProfile(simpleProfile: TD2D1_SIMPLE_COLOR_PROFILE;
    {_COM_Outptr_ }  out colorContext: ID2D1ColorContext1): HRESULT;
begin

    Result :=

        CreateColorContextFromSimpleColorProfile(@simpleProfile, colorContext);

end;


end.
