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
  File name: D2D1_3.h

  Header version: 10.0.19041.0

  ************************************************************************** }
unit DX12.D2D1_3;

{$IFDEF FPC}
{$mode delphi}
{$modeswitch typehelpers}{$H+}{$I-}
{$ENDIF}

interface

{$Z4}

uses
    Windows, Classes, SysUtils, DX12.D2D1, DX12.WinCodec, DX12.DCommon, DX12.DXGI, DX12.DWrite, DX12.DWrite3,
    ActiveX, DX12.D2D1SVG;

const
    D2D1_DLL = 'D2D1.DLL';

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

type
    {$IFNDEF FPC}
    LONG = longint;
    SIZE_T = ULONG_PTR;
    HMONITOR = THANDLE;
    pUInt16 = PWord;
    pUInt32 = PDWord;
    pInt32 = PLongint;
    pUInt8 = pbyte;
    {$ENDIF}

    TD2D1_INK_NIB_SHAPE = (
        D2D1_INK_NIB_SHAPE_ROUND = 0,
        D2D1_INK_NIB_SHAPE_SQUARE = 1,
        D2D1_INK_NIB_SHAPE_FORCE_DWORD = $ffffffff);

    TD2D1_ORIENTATION = (
        D2D1_ORIENTATION_DEFAULT = 1,
        D2D1_ORIENTATION_FLIP_HORIZONTAL = 2,
        D2D1_ORIENTATION_ROTATE_CLOCKWISE180 = 3,
        D2D1_ORIENTATION_ROTATE_CLOCKWISE180_FLIP_HORIZONTAL = 4,
        D2D1_ORIENTATION_ROTATE_CLOCKWISE90_FLIP_HORIZONTAL = 5,
        D2D1_ORIENTATION_ROTATE_CLOCKWISE270 = 6,
        D2D1_ORIENTATION_ROTATE_CLOCKWISE270_FLIP_HORIZONTAL = 7,
        D2D1_ORIENTATION_ROTATE_CLOCKWISE90 = 8,
        D2D1_ORIENTATION_FORCE_DWORD = $ffffffff
        );


    TD2D1_IMAGE_SOURCE_LOADING_OPTIONS = (
        D2D1_IMAGE_SOURCE_LOADING_OPTIONS_NONE = 0,
        D2D1_IMAGE_SOURCE_LOADING_OPTIONS_RELEASE_SOURCE = 1,
        D2D1_IMAGE_SOURCE_LOADING_OPTIONS_CACHE_ON_DEMAND = 2,
        D2D1_IMAGE_SOURCE_LOADING_OPTIONS_FORCE_DWORD = $ffffffff
        );


    TD2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS = (
        D2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS_NONE = 0,
        D2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS_LOW_QUALITY_PRIMARY_CONVERSION = 1,
        D2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS_FORCE_DWORD = $ffffffff
        );


    TD2D1_TRANSFORMED_IMAGE_SOURCE_OPTIONS = (
        D2D1_TRANSFORMED_IMAGE_SOURCE_OPTIONS_NONE = 0,
        // Prevents the image source from being automatically scaled (by a ratio of the
        // context DPI divided by 96) while drawn.
        D2D1_TRANSFORMED_IMAGE_SOURCE_OPTIONS_DISABLE_DPI_SCALE = 1,
        D2D1_TRANSFORMED_IMAGE_SOURCE_OPTIONS_FORCE_DWORD = $ffffffff
        );

    // Properties of a transformed image source.
    TD2D1_TRANSFORMED_IMAGE_SOURCE_PROPERTIES = record
        // The orientation at which the image source is drawn.
        orientation: TD2D1_ORIENTATION;
        // The horizontal scale factor at which the image source is drawn.
        scaleX: single;
        // The vertical scale factor at which the image source is drawn.
        scaleY: single;
        // The interpolation mode used when the image source is drawn.  This is ignored if
        // the image source is drawn using the DrawImage method, or using an image brush.
        interpolationMode: TD2D1_INTERPOLATION_MODE;
        // Option flags.
        options: TD2D1_TRANSFORMED_IMAGE_SOURCE_OPTIONS;
    end;

    // Represents a point, radius pair that makes up part of a D2D1_INK_BEZIER_SEGMENT.
    TD2D1_INK_POINT = record
        x: single;
        y: single;
        radius: single;
    end;

    PD2D1_INK_POINT = ^TD2D1_INK_POINT;

    // Represents a Bezier segment to be used in the creation of an ID2D1Ink object.
    // This structure differs from D2D1_BEZIER_SEGMENT in that it is composed of
    // D2D1_INK_POINT s, which contain a radius in addition to x- and y-coordinates.
    TD2D1_INK_BEZIER_SEGMENT = record
        point1: TD2D1_INK_POINT;
        point2: TD2D1_INK_POINT;
        point3: TD2D1_INK_POINT;
    end;

    PD2D1_INK_BEZIER_SEGMENT = ^TD2D1_INK_BEZIER_SEGMENT;

    // Defines the general pen tip shape and the transform used in an ID2D1InkStyle
    // object.
    TD2D1_INK_STYLE_PROPERTIES = record
        // The general shape of the nib used to draw a given ink object.
        nibShape: TD2D1_INK_NIB_SHAPE;
        // The transform applied to shape of the nib. _31 and _32 are ignored.
        nibTransform: TD2D1_MATRIX_3X2_F;
    end;

    PD2D1_INK_STYLE_PROPERTIES = ^TD2D1_INK_STYLE_PROPERTIES;

    // Specifies how to render gradient mesh edges.
    TD2D1_PATCH_EDGE_MODE = (
        // Render this edge aliased.
        D2D1_PATCH_EDGE_MODE_ALIASED = 0,
        // Render this edge antialiased.
        D2D1_PATCH_EDGE_MODE_ANTIALIASED = 1,
        // Render this edge aliased and inflated out slightly.
        D2D1_PATCH_EDGE_MODE_ALIASED_INFLATED = 2,
        D2D1_PATCH_EDGE_MODE_FORCE_DWORD = $ffffffff
        );


    TD2D1_GRADIENT_MESH_PATCH = record
        point00: TD2D1_POINT_2F;
        point01: TD2D1_POINT_2F;
        point02: TD2D1_POINT_2F;
        point03: TD2D1_POINT_2F;
        point10: TD2D1_POINT_2F;
        point11: TD2D1_POINT_2F;
        point12: TD2D1_POINT_2F;
        point13: TD2D1_POINT_2F;
        point20: TD2D1_POINT_2F;
        point21: TD2D1_POINT_2F;
        point22: TD2D1_POINT_2F;
        point23: TD2D1_POINT_2F;
        point30: TD2D1_POINT_2F;
        point31: TD2D1_POINT_2F;
        point32: TD2D1_POINT_2F;
        point33: TD2D1_POINT_2F;
        color00: TD2D1_COLOR_F;
        color03: TD2D1_COLOR_F;
        color30: TD2D1_COLOR_F;
        color33: TD2D1_COLOR_F;
        topEdgeMode: TD2D1_PATCH_EDGE_MODE;
        leftEdgeMode: TD2D1_PATCH_EDGE_MODE;
        bottomEdgeMode: TD2D1_PATCH_EDGE_MODE;
        rightEdgeMode: TD2D1_PATCH_EDGE_MODE;
    end;

    TD2D1_SPRITE_OPTIONS = (
        D2D1_SPRITE_OPTIONS_NONE = 0,
        D2D1_SPRITE_OPTIONS_CLAMP_TO_SOURCE_RECTANGLE = 1,
        D2D1_SPRITE_OPTIONS_FORCE_DWORD = $ffffffff
        );

    PD2D1_GRADIENT_MESH_PATCH = ^TD2D1_GRADIENT_MESH_PATCH;


    TD2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION = (
        D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION_DEFAULT = 0,
        D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION_DISABLE = 1,
        D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION_FORCE_DWORD = $ffffffff
        );
    PD2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION = ^TD2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION;


    // This determines what gamma is used for interpolation/blending.
    TD2D1_GAMMA1 = (
        D2D1_GAMMA1_G22 = Ord(D2D1_GAMMA_2_2), // Colors are manipulated in 2.2 gamma color space.
        D2D1_GAMMA1_G10 = Ord(D2D1_GAMMA_1_0), // Colors are manipulated in 1.0 gamma color space.
        D2D1_GAMMA1_G2084 = 2,  // Colors are manipulated in ST.2084 PQ gamma color space.
        D2D1_GAMMA1_FORCE_DWORD = $ffffffff);


    // Simple description of a color space.
    TD2D1_SIMPLE_COLOR_PROFILE = record
        redPrimary: TD2D1_POINT_2F;   // The XY coordinates of the red primary in CIEXYZ space.
        greenPrimary: TD2D1_POINT_2F;// The XY coordinates of the green primary in CIEXYZ space.
        bluePrimary: TD2D1_POINT_2F;  // The XY coordinates of the blue primary in CIEXYZ space.
        whitePointXZ: TD2D1_POINT_2F; // The X/Z tristimulus values for the whitepoint, normalized for relative
        gamma: TD2D1_GAMMA1; // The gamma encoding to use for this color space.
    end;

    PD2D1_SIMPLE_COLOR_PROFILE = ^TD2D1_SIMPLE_COLOR_PROFILE;


    // Specifies which way a color profile is defined.
    TD2D1_COLOR_CONTEXT_TYPE = (
        D2D1_COLOR_CONTEXT_TYPE_ICC = 0,
        D2D1_COLOR_CONTEXT_TYPE_SIMPLE = 1,
        D2D1_COLOR_CONTEXT_TYPE_DXGI = 2,
        D2D1_COLOR_CONTEXT_TYPE_FORCE_DWORD = $ffffffff);



    ID2D1InkStyle = interface(ID2D1Resource)
        ['{bae8b344-23fc-4071-8cb5-d05d6f073848}']
        procedure SetNibTransform(const transform: PD2D1_MATRIX_3X2_F); stdcall;
        procedure GetNibTransform(out transform: TD2D1_MATRIX_3X2_F); stdcall;
        procedure SetNibShape(nibShape: TD2D1_INK_NIB_SHAPE); stdcall;
        function GetNibShape(): TD2D1_INK_NIB_SHAPE; stdcall;
    end;

    {$IFDEF FPC}
    { ID2D1InkStyleHelper }
    ID2D1InkStyleHelper = type helper for ID2D1InkStyle
        procedure SetNibTransform(const transform: TD2D1_MATRIX_3X2_F); stdcall; overload;
    end;
    {$ENDIF}

    ID2D1Ink = interface(ID2D1Resource)
        ['{b499923b-7029-478f-a8b3-432c7c5f5312}']
        // Resets the ink start point.
        procedure SetStartPoint(const startPoint: PD2D1_INK_POINT); stdcall;
        // Retrieve the start point with which the ink was initialized.
        function GetStartPoint(): TD2D1_INK_POINT; stdcall;
        // Add one or more segments to the end of the ink.
        function AddSegments(segments: PD2D1_INK_BEZIER_SEGMENT; segmentsCount: uint32): HResult; stdcall;
        // Remove one or more segments from the end of the ink.
        function RemoveSegmentsAtEnd(segmentsCount: uint32): HResult; stdcall;
        // Updates the specified segments with new control points.
        function SetSegments(startSegment: uint32; segments: PD2D1_INK_BEZIER_SEGMENT; segmentsCount: uint32): HResult; stdcall;
        // Update the last segment with new control points.
        function SetSegmentAtEnd(const segment: PD2D1_INK_BEZIER_SEGMENT): HResult; stdcall;
        // Returns the number of segments the ink is composed of.
        function GetSegmentCount(): uint32; stdcall;
        // Retrieve the segments stored in the ink.
        function GetSegments(startSegment: uint32; out segments: PD2D1_INK_BEZIER_SEGMENT; segmentsCount: uint32): HResult; stdcall;
        // Construct a geometric representation of the ink.
        function StreamAsGeometry(inkStyle: ID2D1InkStyle; const worldTransform: PD2D1_MATRIX_3X2_F;
            flatteningTolerance: single; geometrySink: ID2D1SimplifiedGeometrySink): HResult; stdcall;
        // Retrieve the bounds of the ink, with an optional applied transform.
        function GetBounds(inkStyle: ID2D1InkStyle; const worldTransform: TD2D1_MATRIX_3X2_F; out bounds: TD2D1_RECT_F): HResult; stdcall;
    end;

    {$IFDEF FPC}
    { ID2D1InkHelper }

    ID2D1InkHelper = type helper for ID2D1Ink
        procedure SetStartPoint(const startPoint: TD2D1_INK_POINT); stdcall; overload;
        function SetSegmentAtEnd(const segment: TD2D1_INK_BEZIER_SEGMENT): HResult;
            stdcall; overload;
        function StreamAsGeometry(inkStyle: ID2D1InkStyle; const worldTransform: TD2D1_MATRIX_3X2_F; flatteningTolerance: single;
            geometrySink: ID2D1SimplifiedGeometrySink): HResult;
            stdcall; overload;
        function StreamAsGeometry(inkStyle: ID2D1InkStyle; const worldTransform: TD2D1_MATRIX_3X2_F;
            geometrySink: ID2D1SimplifiedGeometrySink): HResult;
            stdcall; overload;
        function StreamAsGeometry(inkStyle: ID2D1InkStyle; const worldTransform: PD2D1_MATRIX_3X2_F;
            geometrySink: ID2D1SimplifiedGeometrySink): HResult;
            stdcall; overload;
    end;
    {$ENDIF}


    ID2D1GradientMesh = interface(ID2D1Resource)
        ['{f292e401-c050-4cde-83d7-04962d3b23c2}']
        // Returns the number of patches of the gradient mesh.
        function GetPatchCount(): uint32; stdcall;
        // Retrieve the patch data stored in the gradient mesh.
        function GetPatches(startIndex: uint32; out patches: PD2D1_GRADIENT_MESH_PATCH; patchesCount: uint32): HResult; stdcall;
    end;


    // Represents a producer of pixels that can fill an arbitrary 2D plane.
    ID2D1ImageSource = interface(ID2D1Image)
        ['{c9b664e5-74a1-4378-9ac2-eefc37a3f4d8}']
        function OfferResources(): HResult; stdcall;
        function TryReclaimResources(out resourcesDiscarded: boolean): HResult; stdcall;
    end;


    // Produces 2D pixel data that has been sourced from WIC.
    ID2D1ImageSourceFromWic = interface(ID2D1ImageSource)
        ['{77395441-1c8f-4555-8683-f50dab0fe792}']
        function EnsureCached(const rectangleToFill: PD2D1_RECT_U): HResult; stdcall;
        function TrimCache(const rectangleToPreserve: PD2D1_RECT_U): HResult; stdcall;
        procedure GetSource(out wicBitmapSource: IWICBitmapSource); stdcall;
    end;

    {$IFDEF FPC}
    { ID2D1ImageSourceFromWicHelper }
    ID2D1ImageSourceFromWicHelper = type helper for ID2D1ImageSourceFromWic
        function EnsureCached(const rectangleToFill: TD2D1_RECT_U): HResult;
            stdcall; overload;
        function TrimCache(const rectangleToPreserve: TD2D1_RECT_U): HResult;
            stdcall; overload;
    end;
    {$ENDIF}


    // Represents an image source which shares resources with an original image source.
    ID2D1TransformedImageSource = interface(ID2D1Image)
        ['{7f1f79e5-2796-416c-8f55-700f911445e5}']
        procedure GetSource(out imageSource: ID2D1ImageSource); stdcall;
        procedure GetProperties(out properties: TD2D1_TRANSFORMED_IMAGE_SOURCE_PROPERTIES); stdcall;
    end;



    // A container for 3D lookup table data that can be passed to the LookupTable3D
    // effect.
    ID2D1LookupTable3D = interface(ID2D1Resource)
        ['{53dd9855-a3b0-4d5b-82e1-26e25c5e5797}']
    end;


    ID2D1DeviceContext2 = interface(ID2D1DeviceContext1)
        ['{394ea6a3-0c34-4321-950b-6ca20f0be6c7}']
        function CreateInk(const startPoint: PD2D1_INK_POINT; out ink: ID2D1Ink): HResult; stdcall;
        // Creates a new ink style.
        function CreateInkStyle(const inkStyleProperties: PD2D1_INK_STYLE_PROPERTIES; out inkStyle: ID2D1InkStyle): HResult; stdcall;
        function CreateGradientMesh(patches: PD2D1_GRADIENT_MESH_PATCH; patchesCount: uint32;
            out gradientMesh: ID2D1GradientMesh): HResult; stdcall;
        function CreateImageSourceFromWic(wicBitmapSource: IWICBitmapSource; loadingOptions: TD2D1_IMAGE_SOURCE_LOADING_OPTIONS;
            alphaMode: TD2D1_ALPHA_MODE; out imageSource: ID2D1ImageSourceFromWic): HResult; stdcall;
        // Creates a 3D lookup table for mapping a 3-channel input to a 3-channel output.
        // The table data must be provided in 4-channel format.
        function CreateLookupTable3D(precision: TD2D1_BUFFER_PRECISION; extents: PUINT32; Data: pbyte;
            dataCount: uint32; strides: PUINT32; out lookupTable: ID2D1LookupTable3D): HResult; stdcall;
        function CreateImageSourceFromDxgi(surfaces: PIDXGISurface; surfaceCount: uint32; colorSpace: TDXGI_COLOR_SPACE_TYPE;
            options: TD2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS; out imageSource: ID2D1ImageSource): HResult; stdcall;
        // Retrieves the world-space bounds in DIPs of the gradient mesh using the device
        // context DPI.
        function GetGradientMeshWorldBounds(gradientMesh: ID2D1GradientMesh; out pBounds: TD2D1_RECT_F): HResult; stdcall;
        procedure DrawInk(ink: ID2D1Ink; brush: ID2D1Brush; inkStyle: ID2D1InkStyle); stdcall;
        procedure DrawGradientMesh(gradientMesh: ID2D1GradientMesh); stdcall;
        // Draw a metafile to the device context.
        procedure DrawGdiMetafile(gdiMetafile: ID2D1GdiMetafile; const destinationRectangle: PD2D1_RECT_F;
            sourceRectangle: PD2D1_RECT_F = nil); stdcall;
        // Creates an image source which shares resources with an original.
        function CreateTransformedImageSource(imageSource: ID2D1ImageSource; const properties: TD2D1_TRANSFORMED_IMAGE_SOURCE_PROPERTIES;
            out transformedImageSource: ID2D1TransformedImageSource): HResult; stdcall;
    end;

    {$IFDEF FPC}
    { ID2D1DeviceContext2Helper }

    ID2D1DeviceContext2Helper = type helper for ID2D1DeviceContext2
        function CreateInk(const startPoint: TD2D1_INK_POINT; out ink: ID2D1Ink): HResult;
            stdcall; overload;
        function CreateInkStyle(const inkStyleProperties: TD2D1_INK_STYLE_PROPERTIES; out inkStyle: ID2D1InkStyle): HResult;
            stdcall; overload;
        function CreateImageSourceFromWic(wicBitmapSource: IWICBitmapSource; loadingOptions: TD2D1_IMAGE_SOURCE_LOADING_OPTIONS;
            out imageSource: ID2D1ImageSourceFromWic): HResult;
            stdcall; overload;
        function CreateImageSourceFromWic(wicBitmapSource: IWICBitmapSource; out imageSource: ID2D1ImageSourceFromWic): HResult;
            stdcall; overload;
        procedure DrawGdiMetafile(gdiMetafile: ID2D1GdiMetafile; const destinationRectangle: TD2D1_RECT_F; const sourceRectangle: TD2D1_RECT_F);
            stdcall; overload;
        procedure DrawGdiMetafile(gdiMetafile: ID2D1GdiMetafile; const destinationRectangle: TD2D1_RECT_F;
            const sourceRectangle: PD2D1_RECT_F = nil); stdcall; overload;
    end;
    {$ENDIF}



    // Represents a resource domain whose objects and device contexts can be used
    // together. This interface performs all the same functions as the existing
    // ID2D1Device1 interface. It also enables the creation of ID2D1DeviceContext2
    // objects.
    ID2D1Device2 = interface(ID2D1Device1)
        ['{a44472e1-8dfb-4e60-8492-6e2861c9ca8b}']
        // Creates a new device context with no initially assigned target.
        function CreateDeviceContext(options: TD2D1_DEVICE_CONTEXT_OPTIONS; out deviceContext2: ID2D1DeviceContext2): HResult; stdcall;
        // Flush all device contexts that reference a given bitmap.
        procedure FlushDeviceContexts(bitmap: ID2D1Bitmap); stdcall;
        // Returns the DXGI device associated with this D2D device.
        function GetDxgiDevice(out dxgiDevice: IDXGIDevice): HResult; stdcall;
    end;



    // Creates Direct2D resources. This interface also enables the creation of
    // ID2D1Device2 objects.
    ID2D1Factory3 = interface(ID2D1Factory2)
        ['{0869759f-4f00-413f-b03e-2bda45404d0f}']
        // This creates a new Direct2D device from the given IDXGIDevice.
        function CreateDevice(dxgiDevice: IDXGIDevice; out d2dDevice2: ID2D1Device2): HResult; stdcall;
    end;



    // This interface performs all the same functions as the existing ID2D1CommandSink1
    // interface. It also enables access to ink rendering and gradient mesh rendering.
    ID2D1CommandSink2 = interface(ID2D1CommandSink1)
        ['{3bab440e-417e-47df-a2e2-bc0be6a00916}']
        function DrawInk(ink: ID2D1Ink; brush: ID2D1Brush; inkStyle: ID2D1InkStyle): HResult; stdcall;
        function DrawGradientMesh(gradientMesh: ID2D1GradientMesh): HResult; stdcall;
        function DrawGdiMetafile(gdiMetafile: ID2D1GdiMetafile; const destinationRectangle: TD2D1_RECT_F;
            const sourceRectangle: TD2D1_RECT_F): HResult; stdcall;
    end;


    // Interface encapsulating a GDI/GDI+ metafile.
    ID2D1GdiMetafile1 = interface(ID2D1GdiMetafile)
        ['{2e69f9e8-dd3f-4bf9-95ba-c04f49d788df}']
        // Returns the DPI reported by the metafile.
        function GetDpi(out dpiX: single; out dpiY: single): HResult; stdcall;
        // Gets the bounds (in DIPs) of the metafile (as specified by the frame rect
        // declared in the metafile).
        function GetSourceBounds(out bounds: TD2D1_RECT_F): HResult; stdcall;
    end;


    // User-implementable interface for introspecting on a metafile.
    ID2D1GdiMetafileSink1 = interface(ID2D1GdiMetafileSink)
        ['{fd0ecb6b-91e6-411e-8655-395e760f91b4}']
        function ProcessRecord(recordType: DWORD; recordData: pointer; recordDataSize: DWORD; flags: uint32): HResult; stdcall;
    end;


    ID2D1SpriteBatch = interface(ID2D1Resource)
        ['{4dc583bf-3a10-438a-8722-e9765224f1f1}']
        function AddSprites(spriteCount: uint32; destinationRectangles: PD2D1_RECT_F; sourceRectangles: PD2D1_RECT_U;
            colors: PD2D1_COLOR_F; transforms: PD2D1_MATRIX_3X2_F; destinationRectanglesStride: uint32;
            sourceRectanglesStride: uint32; colorsStride: uint32; transformsStride: uint32): HResult; stdcall;
        function SetSprites(startIndex: uint32; spriteCount: uint32; destinationRectangles: PD2D1_RECT_F;
            sourceRectangles: PD2D1_RECT_U; colors: PD2D1_COLOR_F; transforms: PD2D1_MATRIX_3X2_F;
            destinationRectanglesStride: uint32; sourceRectanglesStride: uint32; colorsStride: uint32;
            transformsStride: uint32): HResult; stdcall;
        function GetSprites(startIndex: uint32; spriteCount: uint32; out destinationRectangles: PD2D1_RECT_F;
            out sourceRectangles: PD2D1_RECT_U; out colors: PD2D1_COLOR_F; out transforms: PD2D1_MATRIX_3X2_F): HResult; stdcall;
        function GetSpriteCount: uint32; stdcall;
        procedure Clear; stdcall;
    end;


    ID2D1DeviceContext3 = interface(ID2D1DeviceContext2)
        ['{235a7496-8351-414c-bcd4-6672ab2d8e00}']
        // Creates a new sprite batch.
        function CreateSpriteBatch(out spriteBatch: ID2D1SpriteBatch): HResult; stdcall;
        // Draws sprites in a sprite batch.
        procedure DrawSpriteBatch(spriteBatch: ID2D1SpriteBatch; startIndex: uint32; spriteCount: uint32;
            bitmap: ID2D1Bitmap; interpolationMode: TD2D1_BITMAP_INTERPOLATION_MODE = D2D1_BITMAP_INTERPOLATION_MODE_LINEAR;
            spriteOptions: TD2D1_SPRITE_OPTIONS = D2D1_SPRITE_OPTIONS_NONE); stdcall;
    end;

    {$IFDEF FPC}
    { ID2D1DeviceContext3Helper }

    ID2D1DeviceContext3Helper = type helper for ID2D1DeviceContext3
        procedure DrawSpriteBatch(spriteBatch: ID2D1SpriteBatch; bitmap: ID2D1Bitmap;
            interpolationMode: TD2D1_BITMAP_INTERPOLATION_MODE = D2D1_BITMAP_INTERPOLATION_MODE_LINEAR;
            spriteOptions: TD2D1_SPRITE_OPTIONS = D2D1_SPRITE_OPTIONS_NONE); stdcall; overload;
    end;
    {$ENDIF}


    ID2D1Device3 = interface(ID2D1Device2)
        ['{852f2087-802c-4037-ab60-ff2e7ee6fc01}']
        function CreateDeviceContext(options: TD2D1_DEVICE_CONTEXT_OPTIONS; out deviceContext3: ID2D1DeviceContext3): HResult;
            stdcall;
    end;


    // Creates Direct2D resources. This interface also enables the creation of
    // ID2D1Device3 objects.
    ID2D1Factory4 = interface(ID2D1Factory3)
        ['{bd4ec2d2-0662-4bee-ba8e-6f29f032e096}']
        function CreateDevice(dxgiDevice: IDXGIDevice; out d2dDevice3: ID2D1Device3): HResult; stdcall;
    end;


    ID2D1CommandSink3 = interface(ID2D1CommandSink2)
        ['{18079135-4cf3-4868-bc8e-06067e6d242d}']
        function DrawSpriteBatch(spriteBatch: ID2D1SpriteBatch; startIndex: uint32; spriteCount: uint32;
            bitmap: ID2D1Bitmap; interpolationMode: TD2D1_BITMAP_INTERPOLATION_MODE;
            spriteOptions: TD2D1_SPRITE_OPTIONS): HResult; stdcall;
    end;


    // This object supplies the values for context-fill, context-stroke, and
    // context-value that are used when rendering SVG glyphs.
    ID2D1SvgGlyphStyle = interface(ID2D1Resource)
        ['{af671749-d241-4db8-8e41-dcc2e5c1a438}']
        function SetFill(brush: ID2D1Brush): HResult; stdcall;
        procedure GetFill(out brush: ID2D1Brush); stdcall;
        function SetStroke(brush: ID2D1Brush; strokeWidth: single = 1.0; dashes: PSingle = nil; dashesCount: uint32 = 0;
            dashOffset: single = 1.0): HResult; stdcall;
        function GetStrokeDashesCount(): uint32; stdcall;
        procedure GetStroke(out brush: ID2D1Brush; out strokeWidth: single; out dashes: Psingle; dashesCount: uint32;
            out dashOffset: single); stdcall;
    end;



    ID2D1DeviceContext4 = interface(ID2D1DeviceContext3)
        ['{8c427831-3d90-4476-b647-c4fae349e4db}']
        function CreateSvgGlyphStyle(out svgGlyphStyle: ID2D1SvgGlyphStyle): HResult; stdcall;
        procedure DrawText(Text: WideString; stringLength: uint32; textFormat: IDWriteTextFormat;
            const layoutRect: PD2D1_RECT_F; defaultFillBrush: ID2D1Brush; svgGlyphStyle: ID2D1SvgGlyphStyle;
            colorPaletteIndex: uint32; options: TD2D1_DRAW_TEXT_OPTIONS = D2D1_DRAW_TEXT_OPTIONS_ENABLE_COLOR_FONT;
            measuringMode: TDWRITE_MEASURING_MODE = DWRITE_MEASURING_MODE_NATURAL); stdcall;
        procedure DrawTextLayout(origin: TD2D1_POINT_2F; textLayout: IDWriteTextLayout; defaultFillBrush: ID2D1Brush;
            svgGlyphStyle: ID2D1SvgGlyphStyle; colorPaletteIndex: uint32;
            options: TD2D1_DRAW_TEXT_OPTIONS = D2D1_DRAW_TEXT_OPTIONS_ENABLE_COLOR_FONT); stdcall;
        procedure DrawColorBitmapGlyphRun(glyphImageFormat: TDWRITE_GLYPH_IMAGE_FORMATS; baselineOrigin: TD2D1_POINT_2F;
            const glyphRun: PDWRITE_GLYPH_RUN; measuringMode: TDWRITE_MEASURING_MODE = DWRITE_MEASURING_MODE_NATURAL;
            bitmapSnapOption: TD2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION = D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION_DEFAULT); stdcall;
        procedure DrawSvgGlyphRun(baselineOrigin: TD2D1_POINT_2F; const glyphRun: PDWRITE_GLYPH_RUN;
            defaultFillBrush: ID2D1Brush; svgGlyphStyle: ID2D1SvgGlyphStyle; colorPaletteIndex: uint32 = 0;
            measuringMode: TDWRITE_MEASURING_MODE = DWRITE_MEASURING_MODE_NATURAL); stdcall;
        function GetColorBitmapGlyphImage(glyphImageFormat: TDWRITE_GLYPH_IMAGE_FORMATS; glyphOrigin: TD2D1_POINT_2F;
            fontFace: IDWriteFontFace; fontEmSize: single; glyphIndex: uint16; isSideways: boolean;
            const worldTransform: TD2D1_MATRIX_3X2_F; dpiX: single; dpiY: single; out glyphTransform: TD2D1_MATRIX_3X2_F;
            out glyphImage: ID2D1Image): HResult; stdcall;
        function GetSvgGlyphImage(glyphOrigin: TD2D1_POINT_2F; fontFace: IDWriteFontFace; fontEmSize: single;
            glyphIndex: uint16; isSideways: boolean; const worldTransform: TD2D1_MATRIX_3X2_F; defaultFillBrush: ID2D1Brush;
            svgGlyphStyle: ID2D1SvgGlyphStyle; colorPaletteIndex: uint32; out glyphTransform: TD2D1_MATRIX_3X2_F;
            out glyphImage: ID2D1CommandList): HResult; stdcall;
    end;

    {$IFDEF FPC}
    { ID2D1DeviceContext4Helper }

    ID2D1DeviceContext4Helper = type helper for ID2D1DeviceContext4
    procedure DrawText(const Text: PWCHAR; stringLength: uint32; textFormat: IDWriteTextFormat;
        const layoutRect: TD2D1_RECT_F; defaultFillBrush: ID2D1Brush = nil; svgGlyphStyle: ID2D1SvgGlyphStyle = nil;
        colorPaletteIndex: uint32 = 0; options: TD2D1_DRAW_TEXT_OPTIONS = D2D1_DRAW_TEXT_OPTIONS_ENABLE_COLOR_FONT;
        measuringMode: TDWRITE_MEASURING_MODE = DWRITE_MEASURING_MODE_NATURAL); stdcall; overload;
    end;
    {$ENDIF}



    ID2D1Device4 = interface(ID2D1Device3)
        ['{d7bdb159-5683-4a46-bc9c-72dc720b858b}']
        function CreateDeviceContext(options: TD2D1_DEVICE_CONTEXT_OPTIONS; out deviceContext4: ID2D1DeviceContext4): HResult; stdcall;
        procedure SetMaximumColorGlyphCacheMemory(maximumInBytes: uint64); stdcall;
        function GetMaximumColorGlyphCacheMemory(): uint64; stdcall;
    end;


    // Creates Direct2D resources. This interface also enables the creation of
    // ID2D1Device4 objects.
    ID2D1Factory5 = interface(ID2D1Factory4)
        ['{c4349994-838e-4b0f-8cab-44997d9eeacc}']
        function CreateDevice(dxgiDevice: IDXGIDevice; out d2dDevice4: ID2D1Device4): HResult; stdcall;
    end;



    ID2D1CommandSink4 = interface(ID2D1CommandSink3)
        ['{c78a6519-40d6-4218-b2de-beeeb744bb3e}']
        function SetPrimitiveBlend2(primitiveBlend: TD2D1_PRIMITIVE_BLEND): HResult; stdcall;
    end;


    // Represents a color context to be used with the Color Management Effect.
    ID2D1ColorContext1 = interface(ID2D1ColorContext)
        ['{1ab42875-c57f-4be9-bd85-9cd78d6f55ee}']
        function GetColorContextType(): TD2D1_COLOR_CONTEXT_TYPE; stdcall;
        function GetDXGIColorSpace(): TDXGI_COLOR_SPACE_TYPE; stdcall;
        function GetSimpleColorProfile(out simpleProfile: TD2D1_SIMPLE_COLOR_PROFILE): HResult; stdcall;
    end;


    ID2D1DeviceContext5 = interface(ID2D1DeviceContext4)
        ['{7836d248-68cc-4df6-b9e8-de991bf62eb7}']
        // Creates an SVG document from a stream.
        function CreateSvgDocument(inputXmlStream: IStream; viewportSize: TD2D1_SIZE_F;
            out svgDocument: ID2D1SvgDocument): HResult; stdcall;
        procedure DrawSvgDocument(svgDocument: ID2D1SvgDocument); stdcall;
        function CreateColorContextFromDxgiColorSpace(colorSpace: TDXGI_COLOR_SPACE_TYPE;
            out colorContext: ID2D1ColorContext1): HResult; stdcall;
        function CreateColorContextFromSimpleColorProfile(const simpleProfile: PD2D1_SIMPLE_COLOR_PROFILE;
            out colorContext: ID2D1ColorContext1): HResult; stdcall;
    end;

    {$IFDEF FPC}
    { ID2D1DeviceContext5Helper }
    ID2D1DeviceContext5Helper = type helper for ID2D1DeviceContext5
        function CreateColorContextFromSimpleColorProfile(const simpleProfile: TD2D1_SIMPLE_COLOR_PROFILE;
            out colorContext: ID2D1ColorContext1): HResult;
            stdcall; overload;
    end;
    {$ENDIF}


    ID2D1Device5 = interface(ID2D1Device4)
        ['{d55ba0a4-6405-4694-aef5-08ee1a4358b4}']
        // Creates a new device context with no initially assigned target.
        function CreateDeviceContext(options: TD2D1_DEVICE_CONTEXT_OPTIONS; out deviceContext5: ID2D1DeviceContext5): HResult; stdcall;
    end;


    // Creates Direct2D resources. This interface also enables the creation of ID2D1Device5 objects.
    ID2D1Factory6 = interface(ID2D1Factory5)
        ['{f9976f46-f642-44c1-97ca-da32ea2a2635}']
        // This creates a new Direct2D device from the given IDXGIDevice.
        function CreateDevice(dxgiDevice: IDXGIDevice; out d2dDevice5: ID2D1Device5): HResult; stdcall;
    end;

    PID2D1Factory6 = ^ID2D1Factory6;


    ID2D1CommandSink5 = interface(ID2D1CommandSink4)
        ['{7047dd26-b1e7-44a7-959a-8349e2144fa8}']
        function BlendImage(image: ID2D1Image; blendMode: TD2D1_BLEND_MODE; targetOffset: PD2D1_POINT_2F;
            imageRectangle: PD2D1_RECT_F; interpolationMode: TD2D1_INTERPOLATION_MODE): HResult; stdcall;
    end; // interface ID2D1CommandSink5
    PID2D1CommandSink5 = ^ID2D1CommandSink5;


    ID2D1DeviceContext6 = interface(ID2D1DeviceContext5)
        ['{985f7e37-4ed0-4a19-98a3-15b0edfde306}']
        // Draw an image to the device context.
        procedure BlendImage(image: ID2D1Image; blendMode: TD2D1_BLEND_MODE; const targetOffset: PD2D1_POINT_2F = nil;
            const imageRectangle: PD2D1_RECT_F = nil; interpolationMode: TD2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR);
            stdcall;
    end; // interface ID2D1DeviceContext6
    PID2D1DeviceContext6 = ^ID2D1DeviceContext6;


    ID2D1Device6 = interface(ID2D1Device5)
        ['{7bfef914-2d75-4bad-be87-e18ddb077b6d}']
        // Creates a new device context with no initially assigned target.
        function CreateDeviceContext(options: TD2D1_DEVICE_CONTEXT_OPTIONS; out deviceContext6: ID2D1DeviceContext6): HResult; stdcall;
    end; // interface ID2D1Device6
    PID2D1Device6 = ^ID2D1Device6;


    // Creates Direct2D resources. This interface also enables the creation of ID2D1Device6 objects.
    ID2D1Factory7 = interface(ID2D1Factory6)
        ['{bdc2bdd3-b96c-4de6-bdf7-99d4745454de}']
        /// This creates a new Direct2D device from the given IDXGIDevice.
        function CreateDevice(dxgiDevice: IDXGIDevice; out d2dDevice6: ID2D1Device6): HResult; stdcall;
    end; // interface ID2D1Factory7

    PID2D1Factory7 = ^ID2D1Factory7;
//{$endif}



procedure D2D1GetGradientMeshInteriorPointsFromCoonsPatch(const pPoint0: TD2D1_POINT_2F; const pPoint1: TD2D1_POINT_2F;
    const pPoint2: TD2D1_POINT_2F; const pPoint3: TD2D1_POINT_2F; const pPoint4: TD2D1_POINT_2F; const pPoint5: TD2D1_POINT_2F;
    const pPoint6: TD2D1_POINT_2F; const pPoint7: TD2D1_POINT_2F; const pPoint8: TD2D1_POINT_2F; const pPoint9: TD2D1_POINT_2F;
    const pPoint10: TD2D1_POINT_2F; const pPoint11: TD2D1_POINT_2F; out pTensorPoint11: TD2D1_POINT_2F;
    out pTensorPoint12: TD2D1_POINT_2F; out pTensorPoint21: TD2D1_POINT_2F; out pTensorPoint22: TD2D1_POINT_2F);
    stdcall; external D2D1_DLL;


function GradientMeshPatch(point00: TD2D1_POINT_2F; point01: TD2D1_POINT_2F; point02: TD2D1_POINT_2F;
    point03: TD2D1_POINT_2F; point10: TD2D1_POINT_2F; point11: TD2D1_POINT_2F; point12: TD2D1_POINT_2F;
    point13: TD2D1_POINT_2F; point20: TD2D1_POINT_2F; point21: TD2D1_POINT_2F; point22: TD2D1_POINT_2F; point23: TD2D1_POINT_2F;
    point30: TD2D1_POINT_2F; point31: TD2D1_POINT_2F; point32: TD2D1_POINT_2F; point33: TD2D1_POINT_2F;
    color00: TD2D1_COLOR_F; color03: TD2D1_COLOR_F; color30: TD2D1_COLOR_F; color33: TD2D1_COLOR_F;
    topEdgeMode: TD2D1_PATCH_EDGE_MODE; leftEdgeMode: TD2D1_PATCH_EDGE_MODE; bottomEdgeMode: TD2D1_PATCH_EDGE_MODE;
    rightEdgeMode: TD2D1_PATCH_EDGE_MODE): TD2D1_GRADIENT_MESH_PATCH;


function GradientMeshPatchFromCoonsPatch(point0: TD2D1_POINT_2F; point1: TD2D1_POINT_2F; point2: TD2D1_POINT_2F;
    point3: TD2D1_POINT_2F; point4: TD2D1_POINT_2F; point5: TD2D1_POINT_2F; point6: TD2D1_POINT_2F; point7: TD2D1_POINT_2F;
    point8: TD2D1_POINT_2F; point9: TD2D1_POINT_2F; point10: TD2D1_POINT_2F; point11: TD2D1_POINT_2F; color0: TD2D1_COLOR_F;
    color1: TD2D1_COLOR_F; color2: TD2D1_COLOR_F; color3: TD2D1_COLOR_F; topEdgeMode: TD2D1_PATCH_EDGE_MODE;
    leftEdgeMode: TD2D1_PATCH_EDGE_MODE; bottomEdgeMode: TD2D1_PATCH_EDGE_MODE; rightEdgeMode: TD2D1_PATCH_EDGE_MODE): TD2D1_GRADIENT_MESH_PATCH;


function InkPoint(point: TD2D1_POINT_2F; radius: single): TD2D1_INK_POINT;

function InkBezierSegment(point1: TD2D1_INK_POINT; point2: TD2D1_INK_POINT; point3: TD2D1_INK_POINT): TD2D1_INK_BEZIER_SEGMENT;

function InkStyleProperties(nibShape: TD2D1_INK_NIB_SHAPE; nibTransform: TD2D1_MATRIX_3X2_F): TD2D1_INK_STYLE_PROPERTIES;

function InfiniteRectU: TD2D1_RECT_U;

function SimpleColorProfile(const redPrimary: TD2D1_POINT_2F; const greenPrimary: TD2D1_POINT_2F; const bluePrimary: TD2D1_POINT_2F;
    const gamma: TD2D1_GAMMA1; const whitePointXZ: TD2D1_POINT_2F): TD2D1_SIMPLE_COLOR_PROFILE;

implementation



function GradientMeshPatch(point00: TD2D1_POINT_2F; point01: TD2D1_POINT_2F; point02: TD2D1_POINT_2F;
    point03: TD2D1_POINT_2F; point10: TD2D1_POINT_2F; point11: TD2D1_POINT_2F; point12: TD2D1_POINT_2F;
    point13: TD2D1_POINT_2F; point20: TD2D1_POINT_2F; point21: TD2D1_POINT_2F; point22: TD2D1_POINT_2F; point23: TD2D1_POINT_2F;
    point30: TD2D1_POINT_2F; point31: TD2D1_POINT_2F; point32: TD2D1_POINT_2F; point33: TD2D1_POINT_2F;
    color00: TD2D1_COLOR_F; color03: TD2D1_COLOR_F; color30: TD2D1_COLOR_F; color33: TD2D1_COLOR_F;
    topEdgeMode: TD2D1_PATCH_EDGE_MODE; leftEdgeMode: TD2D1_PATCH_EDGE_MODE; bottomEdgeMode: TD2D1_PATCH_EDGE_MODE;
    rightEdgeMode: TD2D1_PATCH_EDGE_MODE): TD2D1_GRADIENT_MESH_PATCH;
var
    newPatch: TD2D1_GRADIENT_MESH_PATCH;
begin

    newPatch.point00 := point00;
    newPatch.point01 := point01;
    newPatch.point02 := point02;
    newPatch.point03 := point03;
    newPatch.point10 := point10;
    newPatch.point11 := point11;
    newPatch.point12 := point12;
    newPatch.point13 := point13;
    newPatch.point20 := point20;
    newPatch.point21 := point21;
    newPatch.point22 := point22;
    newPatch.point23 := point23;
    newPatch.point30 := point30;
    newPatch.point31 := point31;
    newPatch.point32 := point32;
    newPatch.point33 := point33;

    newPatch.color00 := color00;
    newPatch.color03 := color03;
    newPatch.color33 := color33;
    newPatch.color30 := color30;

    newPatch.topEdgeMode := topEdgeMode;
    newPatch.leftEdgeMode := leftEdgeMode;
    newPatch.bottomEdgeMode := bottomEdgeMode;
    newPatch.rightEdgeMode := rightEdgeMode;

    Result := newPatch;
end;



function GradientMeshPatchFromCoonsPatch(point0: TD2D1_POINT_2F; point1: TD2D1_POINT_2F; point2: TD2D1_POINT_2F;
    point3: TD2D1_POINT_2F; point4: TD2D1_POINT_2F; point5: TD2D1_POINT_2F; point6: TD2D1_POINT_2F; point7: TD2D1_POINT_2F;
    point8: TD2D1_POINT_2F; point9: TD2D1_POINT_2F; point10: TD2D1_POINT_2F; point11: TD2D1_POINT_2F; color0: TD2D1_COLOR_F;
    color1: TD2D1_COLOR_F; color2: TD2D1_COLOR_F; color3: TD2D1_COLOR_F; topEdgeMode: TD2D1_PATCH_EDGE_MODE;
    leftEdgeMode: TD2D1_PATCH_EDGE_MODE; bottomEdgeMode: TD2D1_PATCH_EDGE_MODE; rightEdgeMode: TD2D1_PATCH_EDGE_MODE): TD2D1_GRADIENT_MESH_PATCH;
var
    newPatch: TD2D1_GRADIENT_MESH_PATCH;
begin

    newPatch.point00 := point0;
    newPatch.point01 := point1;
    newPatch.point02 := point2;
    newPatch.point03 := point3;
    newPatch.point13 := point4;
    newPatch.point23 := point5;
    newPatch.point33 := point6;
    newPatch.point32 := point7;
    newPatch.point31 := point8;
    newPatch.point30 := point9;
    newPatch.point20 := point10;
    newPatch.point10 := point11;

    D2D1GetGradientMeshInteriorPointsFromCoonsPatch(
        point0,
        point1,
        point2,
        point3,
        point4,
        point5,
        point6,
        point7,
        point8,
        point9,
        point10,
        point11,
        newPatch.point11,
        newPatch.point12,
        newPatch.point21,
        newPatch.point22
        );

    newPatch.color00 := color0;
    newPatch.color03 := color1;
    newPatch.color33 := color2;
    newPatch.color30 := color3;
    newPatch.topEdgeMode := topEdgeMode;
    newPatch.leftEdgeMode := leftEdgeMode;
    newPatch.bottomEdgeMode := bottomEdgeMode;
    newPatch.rightEdgeMode := rightEdgeMode;

    Result := newPatch;
end;



function InkPoint(point: TD2D1_POINT_2F; radius: single): TD2D1_INK_POINT;
var
    inkPoint: TD2D1_INK_POINT;
begin
    inkPoint.x := point.x;
    inkPoint.y := point.y;
    inkPoint.radius := radius;
    Result := inkPoint;
end;



function InkBezierSegment(point1: TD2D1_INK_POINT; point2: TD2D1_INK_POINT; point3: TD2D1_INK_POINT): TD2D1_INK_BEZIER_SEGMENT;
var
    inkBezierSegment: TD2D1_INK_BEZIER_SEGMENT;
begin
    inkBezierSegment.point1 := point1;
    inkBezierSegment.point2 := point2;
    inkBezierSegment.point3 := point3;
    Result := inkBezierSegment;
end;



function InkStyleProperties(nibShape: TD2D1_INK_NIB_SHAPE; nibTransform: TD2D1_MATRIX_3X2_F): TD2D1_INK_STYLE_PROPERTIES;
var
    inkStyleProperties: TD2D1_INK_STYLE_PROPERTIES;
begin
    inkStyleProperties.nibShape := nibShape;
    inkStyleProperties.nibTransform := nibTransform;
    Result := inkStyleProperties;
end;



function InfiniteRectU: TD2D1_RECT_U;
begin
    Result.left := 0;
    Result.top := 0;
    Result.bottom := UINT_MAX;
    Result.right := UINT_MAX;
end;



function SimpleColorProfile(const redPrimary: TD2D1_POINT_2F; const greenPrimary: TD2D1_POINT_2F; const bluePrimary: TD2D1_POINT_2F;
    const gamma: TD2D1_GAMMA1; const whitePointXZ: TD2D1_POINT_2F): TD2D1_SIMPLE_COLOR_PROFILE;
begin
    Result.redPrimary := redPrimary;
    Result.greenPrimary := greenPrimary;
    Result.bluePrimary := bluePrimary;
    Result.gamma := gamma;
    Result.whitePointXZ := whitePointXZ;
end;

{ ID2D1DeviceContext5Helper }

function ID2D1DeviceContext5Helper.CreateColorContextFromSimpleColorProfile(const simpleProfile: TD2D1_SIMPLE_COLOR_PROFILE;
    out colorContext: ID2D1ColorContext1): HResult; stdcall;
begin
    Result := CreateColorContextFromSimpleColorProfile(@simpleProfile, colorContext);
end;

{ ID2D1DeviceContext4Helper }

procedure ID2D1DeviceContext4Helper.DrawText(const Text: PWCHAR; stringLength: uint32; textFormat: IDWriteTextFormat;
    const layoutRect: TD2D1_RECT_F; defaultFillBrush: ID2D1Brush; svgGlyphStyle: ID2D1SvgGlyphStyle; colorPaletteIndex: uint32;
    options: TD2D1_DRAW_TEXT_OPTIONS; measuringMode: TDWRITE_MEASURING_MODE);
    stdcall;
begin
    DrawText(Text, stringLength, textFormat, @layoutRect, defaultFillBrush, svgGlyphStyle, colorPaletteIndex, options, measuringMode);
end;

{ ID2D1DeviceContext3Helper }

procedure ID2D1DeviceContext3Helper.DrawSpriteBatch(spriteBatch: ID2D1SpriteBatch; bitmap: ID2D1Bitmap;
    interpolationMode: TD2D1_BITMAP_INTERPOLATION_MODE; spriteOptions: TD2D1_SPRITE_OPTIONS); stdcall;
begin
    DrawSpriteBatch(spriteBatch, 0, spriteBatch.GetSpriteCount(), bitmap, interpolationMode, spriteOptions);
end;

{ ID2D1DeviceContext2Helper }

function ID2D1DeviceContext2Helper.CreateInk(const startPoint: TD2D1_INK_POINT; out ink: ID2D1Ink): HResult; stdcall;
begin
    Result := CreateInk(@startPoint, ink);
end;



function ID2D1DeviceContext2Helper.CreateInkStyle(const inkStyleProperties: TD2D1_INK_STYLE_PROPERTIES;
    out inkStyle: ID2D1InkStyle): HResult; stdcall;
begin
    Result := CreateInkStyle(@inkStyleProperties, inkStyle);
end;



function ID2D1DeviceContext2Helper.CreateImageSourceFromWic(wicBitmapSource: IWICBitmapSource;
    loadingOptions: TD2D1_IMAGE_SOURCE_LOADING_OPTIONS; out imageSource: ID2D1ImageSourceFromWic): HResult; stdcall;
begin
    Result := CreateImageSourceFromWic(wicBitmapSource, loadingOptions, D2D1_ALPHA_MODE_UNKNOWN, imageSource);
end;



function ID2D1DeviceContext2Helper.CreateImageSourceFromWic(wicBitmapSource: IWICBitmapSource;
    out imageSource: ID2D1ImageSourceFromWic): HResult; stdcall;
begin
    Result := CreateImageSourceFromWic(wicBitmapSource, D2D1_IMAGE_SOURCE_LOADING_OPTIONS_NONE, D2D1_ALPHA_MODE_UNKNOWN, imageSource);
end;



procedure ID2D1DeviceContext2Helper.DrawGdiMetafile(gdiMetafile: ID2D1GdiMetafile; const destinationRectangle: TD2D1_RECT_F;
    const sourceRectangle: TD2D1_RECT_F); stdcall;
begin
    DrawGdiMetafile(gdiMetafile, @destinationRectangle, @sourceRectangle);
end;



procedure ID2D1DeviceContext2Helper.DrawGdiMetafile(gdiMetafile: ID2D1GdiMetafile; const destinationRectangle: TD2D1_RECT_F;
    const sourceRectangle: PD2D1_RECT_F); stdcall;
begin
    DrawGdiMetafile(gdiMetafile, @destinationRectangle, sourceRectangle);
end;

{ ID2D1ImageSourceFromWicHelper }

function ID2D1ImageSourceFromWicHelper.EnsureCached(const rectangleToFill: TD2D1_RECT_U): HResult; stdcall;
begin
    Result := EnsureCached(@rectangleToFill);
end;



function ID2D1ImageSourceFromWicHelper.TrimCache(const rectangleToPreserve: TD2D1_RECT_U): HResult; stdcall;
begin
    Result := TrimCache(@rectangleToPreserve);
end;

{ ID2D1InkHelper }

procedure ID2D1InkHelper.SetStartPoint(const startPoint: TD2D1_INK_POINT);
    stdcall;
begin
    SetStartPoint(@startPoint);
end;



function ID2D1InkHelper.SetSegmentAtEnd(const segment: TD2D1_INK_BEZIER_SEGMENT): HResult; stdcall;
begin
    Result := SetSegmentAtEnd(@segment);
end;



function ID2D1InkHelper.StreamAsGeometry(inkStyle: ID2D1InkStyle; const worldTransform: TD2D1_MATRIX_3X2_F;
    flatteningTolerance: single; geometrySink: ID2D1SimplifiedGeometrySink): HResult; stdcall;
begin
    Result := StreamAsGeometry(inkStyle, @worldTransform, flatteningTolerance, geometrySink);
end;



function ID2D1InkHelper.StreamAsGeometry(inkStyle: ID2D1InkStyle; const worldTransform: TD2D1_MATRIX_3X2_F;
    geometrySink: ID2D1SimplifiedGeometrySink): HResult; stdcall;
begin
    Result := StreamAsGeometry(inkStyle, @worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, geometrySink);
end;



function ID2D1InkHelper.StreamAsGeometry(inkStyle: ID2D1InkStyle; const worldTransform: PD2D1_MATRIX_3X2_F;
    geometrySink: ID2D1SimplifiedGeometrySink): HResult; stdcall;
begin
    Result := StreamAsGeometry(inkStyle, worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, geometrySink);
end;

{ ID2D1InkStyleHelper }

procedure ID2D1InkStyleHelper.SetNibTransform(const transform: TD2D1_MATRIX_3X2_F); stdcall;
begin
    SetNibTransform(@transform);
end;


end.
