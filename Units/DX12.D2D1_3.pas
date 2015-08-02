{$REGION 'Copyright (C) CMC Development Team'}
{ **************************************************************************
  Copyright (C) 2015 CMC Development Team

  CMC is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 2 of the License, or
  (at your option) any later version.

  CMC is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with CMC. If not, see <http://www.gnu.org/licenses/>.
  ************************************************************************** }

{ **************************************************************************
  Additional Copyright (C) for this modul:

  Copyright (c) Microsoft Corporation.  All rights reserved.

  This unit consists of the following header files
  File name: D2D1_3.h
  Header version: 10.0.10075.0

  ************************************************************************** }
{$ENDREGION}
{$REGION 'Notes'}
{ **************************************************************************
  Use the DirectX libaries from CMC. They are NOT based on the JSB headers

  Version 0.9 2015.06.04 - First release

  The HelperFiles are translated to be used with Delphi/FPC. Therefore there are
  more functions then in the original header file since Pascal syntax doesn't
  support default values of a function as a result of another function.

  But the use should be straight forward. Looks to the examples if any
  questions.

  WHEN you should use this headers: if you plan a new software release and
     you are not based on much older source code.
  WHEN you should NOT use this heades: when you have existing source code
    based on the JSB headers and don't want to change a LOT.

  You MUST use this if you work with FPC. The JSB Headers are buggy for FPC
  cause interfaces not based on IUnknown are solved with abstract classes
  in Delphi, which will not work on FPC. FPC has the CORBA Interface
  compiler switch.
  Also FPC supports BITPACKED RECORDS.

  The inline functions of the interfaces (which is a nice feature in C++ are
  not translated in the moment cause I don't know how.
  A INLINE directive would be a cool feature for FPC. We will look forward...

  ************************************************************************** }
{$ENDREGION}
unit DX12.D2D1_3;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

{$Z4}

uses
    Windows, Classes, SysUtils, DX12.D2D1, DX12.WinCodec, DX12.DCommon, DX12.DXGI;

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

type
    {$IFNDEF FPC}
    LONG = longint;
    SIZE_T = ULONG_PTR;
    HMONITOR = THANDLE;
    pUInt16 = PWord;
    pUInt32 = PDWord;
    pInt32 = PLongint;
    pUInt8 = PByte;
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


    TD2D1_INK_POINT = record
        x: single;
        y: single;
        radius: single;
    end;

    TD2D1_INK_BEZIER_SEGMENT = record
        point1: TD2D1_INK_POINT;
        point2: TD2D1_INK_POINT;
        point3: TD2D1_INK_POINT;
    end;

    PD2D1_INK_BEZIER_SEGMENT = ^TD2D1_INK_BEZIER_SEGMENT;

    TD2D1_INK_STYLE_PROPERTIES = record
        // The general shape of the nib used to draw a given ink object.
        nibShape: TD2D1_INK_NIB_SHAPE;
        // The transform applied to shape of the nib. _31 and _32 are ignored.
        nibTransform: TD2D1_MATRIX_3X2_F;
    end;


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

    PD2D1_GRADIENT_MESH_PATCH = ^TD2D1_GRADIENT_MESH_PATCH;


    ID2D1InkStyle = interface(ID2D1Resource)
        ['{bae8b344-23fc-4071-8cb5-d05d6f073848}']
        procedure SetNibTransform(const transform: TD2D1_MATRIX_3X2_F); stdcall;
        procedure GetNibTransform(out transform: TD2D1_MATRIX_3X2_F); stdcall;
        procedure SetNibShape(nibShape: TD2D1_INK_NIB_SHAPE); stdcall;
        function GetNibShape(): TD2D1_INK_NIB_SHAPE; stdcall;
    end;


    ID2D1Ink = interface(ID2D1Resource)
        ['{b499923b-7029-478f-a8b3-432c7c5f5312}']
        // Resets the ink start point.
        procedure SetStartPoint(const startPoint: TD2D1_INK_POINT); stdcall;
        // Retrieve the start point with which the ink was initialized.
        function GetStartPoint(): TD2D1_INK_POINT; stdcall;
        // Add one or more segments to the end of the ink.
        function AddSegments(segments: PD2D1_INK_BEZIER_SEGMENT; segmentsCount: UINT32): HResult; stdcall;
        // Remove one or more segments from the end of the ink.
        function RemoveSegmentsAtEnd(segmentsCount: UINT32): HResult; stdcall;
        // Updates the specified segments with new control points.
        function SetSegments(startSegment: UINT32; segments: PD2D1_INK_BEZIER_SEGMENT; segmentsCount: UINT32): HResult; stdcall;
        // Update the last segment with new control points.
        function SetSegmentAtEnd(const segment: TD2D1_INK_BEZIER_SEGMENT): HResult; stdcall;
        // Returns the number of segments the ink is composed of.
        function GetSegmentCount(): UINT32; stdcall;
        // Retrieve the segments stored in the ink.
        function GetSegments(startSegment: UINT32; out segments: PD2D1_INK_BEZIER_SEGMENT; segmentsCount: UINT32): HResult; stdcall;
        // Construct a geometric representation of the ink.
        function StreamAsGeometry(inkStyle: ID2D1InkStyle; const worldTransform: TD2D1_MATRIX_3X2_F;
            flatteningTolerance: single; geometrySink: ID2D1SimplifiedGeometrySink): HResult; stdcall;
        // Retrieve the bounds of the ink, with an optional applied transform.
        function GetBounds(inkStyle: ID2D1InkStyle; const worldTransform: TD2D1_MATRIX_3X2_F; out bounds: TD2D1_RECT_F): HResult; stdcall;
    end;


    ID2D1GradientMesh = interface(ID2D1Resource)
        ['{f292e401-c050-4cde-83d7-04962d3b23c2}']
        // Returns the number of patches of the gradient mesh.
        function GetPatchCount(): UINT32; stdcall;
        // Retrieve the patch data stored in the gradient mesh.
        function GetPatches(startIndex: UINT32; out patches: PD2D1_GRADIENT_MESH_PATCH; patchesCount: UINT32): HResult; stdcall;
    end;


    ID2D1ImageSource = interface(ID2D1Image)
        ['{c9b664e5-74a1-4378-9ac2-eefc37a3f4d8}']
        function OfferResources(): HResult; stdcall;
        function TryReclaimResources(out resourcesDiscarded: boolean): HResult; stdcall;
    end;


    ID2D1ImageSourceFromWic = interface(ID2D1ImageSource)
        ['{77395441-1c8f-4555-8683-f50dab0fe792}']
        function EnsureCached(const rectangleToFill: TD2D1_RECT_U): HResult; stdcall;
        function TrimCache(const rectangleToPreserve: TD2D1_RECT_U): HResult; stdcall;
        procedure GetSource(out wicBitmapSource: IWICBitmapSource); stdcall;
    end;


    ID2D1TransformedImageSource = interface(ID2D1Image)
        ['{7f1f79e5-2796-416c-8f55-700f911445e5}']
        procedure GetSource(out imageSource: ID2D1ImageSource); stdcall;
        procedure GetProperties(out properties: TD2D1_TRANSFORMED_IMAGE_SOURCE_PROPERTIES); stdcall;
    end;


    ID2D1LookupTable3D = interface(ID2D1Resource)
        ['{53dd9855-a3b0-4d5b-82e1-26e25c5e5797}']
    end;


    ID2D1DeviceContext2 = interface(ID2D1DeviceContext1)
        ['{394ea6a3-0c34-4321-950b-6ca20f0be6c7}']
        function CreateInk(const startPoint: TD2D1_INK_POINT; out ink: ID2D1Ink): HResult; stdcall;
        // Creates a new ink style.
        function CreateInkStyle(const inkStyleProperties: TD2D1_INK_STYLE_PROPERTIES; out inkStyle: ID2D1InkStyle): HResult; stdcall;
        function CreateGradientMesh(patches: PD2D1_GRADIENT_MESH_PATCH; patchesCount: UINT32;
            out gradientMesh: ID2D1GradientMesh): HResult; stdcall;
        function CreateImageSourceFromWic(wicBitmapSource: IWICBitmapSource; loadingOptions: TD2D1_IMAGE_SOURCE_LOADING_OPTIONS;
            alphaMode: TD2D1_ALPHA_MODE; out imageSource: ID2D1ImageSourceFromWic): HResult; stdcall;
        // Creates a 3D lookup table for mapping a 3-channel input to a 3-channel output.
        // The table data must be provided in 4-channel format.
        function CreateLookupTable3D(precision: TD2D1_BUFFER_PRECISION; extents: PUINT32; Data: PBYTE;
            dataCount: UINT32; strides: PUINT32; out lookupTable: ID2D1LookupTable3D): HResult; stdcall;
        function CreateImageSourceFromDxgi(surfaces: PIDXGISurface; surfaceCount: UINT32; colorSpace: TDXGI_COLOR_SPACE_TYPE;
            options: TD2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS; out imageSource: ID2D1ImageSource): HResult; stdcall;
        // Retrieves the world-space bounds in DIPs of the gradient mesh using the device
        // context DPI.
        function GetGradientMeshWorldBounds(gradientMesh: ID2D1GradientMesh; out pBounds: TD2D1_RECT_F): HResult; stdcall;
        procedure DrawInk(ink: ID2D1Ink; brush: ID2D1Brush; inkStyle: ID2D1InkStyle); stdcall;
        procedure DrawGradientMesh(gradientMesh: ID2D1GradientMesh); stdcall;
        // Draw a metafile to the device context.
        procedure DrawGdiMetafile(gdiMetafile: ID2D1GdiMetafile; const destinationRectangle: TD2D1_RECT_F;
            sourceRectangle: PD2D1_RECT_F = nil); stdcall;
        // Creates an image source which shares resources with an original.
        function CreateTransformedImageSource(imageSource: ID2D1ImageSource; const properties: TD2D1_TRANSFORMED_IMAGE_SOURCE_PROPERTIES;
            out transformedImageSource: ID2D1TransformedImageSource): HResult; stdcall;
    end;


    ID2D1Device2 = interface(ID2D1Device1)
        ['{a44472e1-8dfb-4e60-8492-6e2861c9ca8b}']
        // Creates a new device context with no initially assigned target.
        function CreateDeviceContext(options: TD2D1_DEVICE_CONTEXT_OPTIONS; out deviceContext2: ID2D1DeviceContext2): HResult; stdcall;
        // Flush all device contexts that reference a given bitmap.
        procedure FlushDeviceContexts(bitmap: ID2D1Bitmap); stdcall;
        // Returns the DXGI device associated with this D2D device.
        function GetDxgiDevice(out dxgiDevice: IDXGIDevice): HResult; stdcall;
    end;


    ID2D1Factory3 = interface(ID2D1Factory2)
        ['{0869759f-4f00-413f-b03e-2bda45404d0f}']
        // This creates a new Direct2D device from the given IDXGIDevice.
        function CreateDevice(dxgiDevice: IDXGIDevice; out d2dDevice2: ID2D1Device2): HResult; stdcall;
    end;

    ID2D1CommandSink2 = interface(ID2D1CommandSink1)
        ['{3bab440e-417e-47df-a2e2-bc0be6a00916}']
        function DrawInk(ink: ID2D1Ink; brush: ID2D1Brush; inkStyle: ID2D1InkStyle): HResult; stdcall;
        function DrawGradientMesh(gradientMesh: ID2D1GradientMesh): HResult; stdcall;
        function DrawGdiMetafile(gdiMetafile: ID2D1GdiMetafile; const destinationRectangle: TD2D1_RECT_F;
            const sourceRectangle: TD2D1_RECT_F): HResult; stdcall;
    end;

    ID2D1GdiMetafile1 = interface(ID2D1GdiMetafile)
        ['{2e69f9e8-dd3f-4bf9-95ba-c04f49d788df}']
        // Returns the DPI reported by the metafile.
        function GetDpi(out dpiX: single; out dpiY: single): HResult; stdcall;
        // Gets the bounds (in DIPs) of the metafile (as specified by the frame rect
        // declared in the metafile).
        function GetSourceBounds(out bounds: TD2D1_RECT_F): HResult; stdcall;
    end;

    ID2D1GdiMetafileSink1 = interface(ID2D1GdiMetafileSink)
        ['{fd0ecb6b-91e6-411e-8655-395e760f91b4}']
        function ProcessRecord(recordType: DWORD; recordData: pointer; recordDataSize: DWORD; flags: UINT32): HResult; stdcall;
    end;


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
    newPatch.color33 := color33
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

end.
