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

   Copyright (c) Microsoft Corporation.  All rights reserved.

   This unit consists of the following header files
   File name: d2d1_1.h
              d2d1effectauthor.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.D2D1_1;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    Win32.ObjIdl,
    DX12.DXGI,
    DX12.DXGIFormat,
    DX12.D2D1,
    DX12.DWrite,
    DX12.WinCodec,
    DX12.DCommon,
    DX12.D3DCommon,
    DX12.DocumentTarget;

    {$Z4}

const
    UINT_MAX = $ffffffff;
    D2D1_INVALID_PROPERTY_INDEX = UINT_MAX;


    // Set to alignedByteOffset within D2D1_INPUT_ELEMENT_DESC for elements that
    // immediately follow preceding elements in memory

    D2D1_APPEND_ALIGNED_ELEMENT = ($ffffffff);

    IID_ID2D1GdiMetafileSink: TGUID = '{82237326-8111-4f7c-bcf4-b5c1175564fe}';
    IID_ID2D1GdiMetafile: TGUID = '{2f543dc3-cfc1-4211-864f-cfd91c6f3395}';
    IID_ID2D1CommandSink: TGUID = '{54d7898a-a061-40a7-bec7-e465bcba2c4f}';
    IID_ID2D1CommandList: TGUID = '{b4f34a19-2383-4d76-94f6-ec343657c3dc}';
    IID_ID2D1PrintControl: TGUID = '{2c1d867d-c290-41c8-ae7e-34a98702e9a5}';
    IID_ID2D1ImageBrush: TGUID = '{fe9e984d-3f95-407c-b5db-cb94d4e8f87c}';
    IID_ID2D1BitmapBrush1: TGUID = '{41343a53-e41a-49a2-91cd-21793bbb62e5}';
    IID_ID2D1StrokeStyle1: TGUID = '{10a72a66-e91c-43f4-993f-ddf4b82b0b4a}';
    IID_ID2D1PathGeometry1: TGUID = '{62baa2d2-ab54-41b7-b872-787e0106a421}';
    IID_ID2D1Properties: TGUID = '{483473d7-cd46-4f9d-9d3a-3112aa80159d}';
    IID_ID2D1Effect: TGUID = '{28211a43-7d89-476f-8181-2d6159b220ad}';
    IID_ID2D1Bitmap1: TGUID = '{a898a84c-3873-4588-b08b-ebbf978df041}';
    IID_ID2D1ColorContext: TGUID = '{1c4820bb-5771-4518-a581-2fe4dd0ec657}';
    IID_ID2D1GradientStopCollection1: TGUID = '{ae1572f4-5dd0-4777-998b-9279472ae63b}';
    IID_ID2D1DrawingStateBlock1: TGUID = '{689f1f85-c72e-4e33-8f19-85754efd5ace}';
    IID_ID2D1DeviceContext: TGUID = '{e8f7fe7a-191c-466d-ad95-975678bda998}';
    IID_ID2D1Device: TGUID = '{47dd575d-ac05-4cdd-8049-9b02cd16f44c}';
    IID_ID2D1Factory1: TGUID = '{bb12d362-daee-4b9a-aa1d-14ba401cfa1f}';
    IID_ID2D1Multithread: TGUID = '{31e6e7bc-e0ff-4d46-8c64-a0a8c41c15d3}';


type
    REFGUID = ^TGUID;
    REFCLSID = ^CLSID;

    ID2D1ColorContext = interface;

    /// Function pointer to construct a new effect once registered.
    PD2D1_EFFECT_FACTORY = function({_Outptr_ }  out effectImpl: IUnknown): HRESULT; stdcall;


    ID2D1Device = interface;


    ID2D1Effect = interface;
    PID2D1Effect = ^ID2D1Effect;

    // TD2D1_RECT_L = TD2D_RECT_L; in DX12.DCommon
    TD2D1_POINT_2L = TD2D_POINT_2L;
    PD2D1_POINT_2L = ^TD2D1_POINT_2L;

    /// This defines the valid property types that can be used in an effect property
    /// interface.
    TD2D1_PROPERTY_TYPE = (
        D2D1_PROPERTY_TYPE_UNKNOWN = 0,
        D2D1_PROPERTY_TYPE_STRING = 1,
        D2D1_PROPERTY_TYPE_BOOL = 2,
        D2D1_PROPERTY_TYPE_UINT32 = 3,
        D2D1_PROPERTY_TYPE_INT32 = 4,
        D2D1_PROPERTY_TYPE_FLOAT = 5,
        D2D1_PROPERTY_TYPE_VECTOR2 = 6,
        D2D1_PROPERTY_TYPE_VECTOR3 = 7,
        D2D1_PROPERTY_TYPE_VECTOR4 = 8,
        D2D1_PROPERTY_TYPE_BLOB = 9,
        D2D1_PROPERTY_TYPE_IUNKNOWN = 10,
        D2D1_PROPERTY_TYPE_ENUM = 11,
        D2D1_PROPERTY_TYPE_ARRAY = 12,
        D2D1_PROPERTY_TYPE_CLSID = 13,
        D2D1_PROPERTY_TYPE_MATRIX_3X2 = 14,
        D2D1_PROPERTY_TYPE_MATRIX_4X3 = 15,
        D2D1_PROPERTY_TYPE_MATRIX_4X4 = 16,
        D2D1_PROPERTY_TYPE_MATRIX_5X4 = 17,
        D2D1_PROPERTY_TYPE_COLOR_CONTEXT = 18,
        D2D1_PROPERTY_TYPE_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_PROPERTY_TYPE = ^TD2D1_PROPERTY_TYPE;

    /// This defines the list of system properties present on the root effect property
    /// interface.
    TD2D1_PROPERTY = (
        D2D1_PROPERTY_CLSID = longint($80000000),
        D2D1_PROPERTY_DISPLAYNAME = longint($80000001),
        D2D1_PROPERTY_AUTHOR = longint($80000002),
        D2D1_PROPERTY_CATEGORY = longint($80000003),
        D2D1_PROPERTY_DESCRIPTION = longint($80000004),
        D2D1_PROPERTY_INPUTS = longint($80000005),
        D2D1_PROPERTY_CACHED = longint($80000006),
        D2D1_PROPERTY_PRECISION = longint($80000007),
        D2D1_PROPERTY_MIN_INPUTS = longint($80000008),
        D2D1_PROPERTY_MAX_INPUTS = longint($80000009),
        D2D1_PROPERTY_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_PROPERTY = ^TD2D1_PROPERTY;

    /// This defines the indices of sub-properties that may be present on any parent
    /// property.
    TD2D1_SUBPROPERTY = (
        D2D1_SUBPROPERTY_DISPLAYNAME = longint($80000000),
        D2D1_SUBPROPERTY_ISREADONLY = longint($80000001),
        D2D1_SUBPROPERTY_MIN = longint($80000002),
        D2D1_SUBPROPERTY_MAX = longint($80000003),
        D2D1_SUBPROPERTY_DEFAULT = longint($80000004),
        D2D1_SUBPROPERTY_FIELDS = longint($80000005),
        D2D1_SUBPROPERTY_INDEX = longint($80000006),
        D2D1_SUBPROPERTY_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_SUBPROPERTY = ^TD2D1_SUBPROPERTY;

    /// Specifies how the bitmap can be used.
    TD2D1_BITMAP_OPTIONS = (
        /// The bitmap is created with default properties.
        D2D1_BITMAP_OPTIONS_NONE = $00000000,
        /// The bitmap can be specified as a target in ID2D1DeviceContext::SetTarget
        D2D1_BITMAP_OPTIONS_TARGET = $00000001,
        /// The bitmap cannot be used as an input to DrawBitmap, DrawImage, in a bitmap
        /// brush or as an input to an effect.
        D2D1_BITMAP_OPTIONS_CANNOT_DRAW = $00000002,
        /// The bitmap can be read from the CPU.
        D2D1_BITMAP_OPTIONS_CPU_READ = $00000004,
        /// The bitmap works with the ID2D1GdiInteropRenderTarget::GetDC API.
        D2D1_BITMAP_OPTIONS_GDI_COMPATIBLE = $00000008,
        D2D1_BITMAP_OPTIONS_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_BITMAP_OPTIONS = ^TD2D1_BITMAP_OPTIONS;

    /// Specifies the composite mode that will be applied.
    TD2D1_COMPOSITE_MODE = (
        D2D1_COMPOSITE_MODE_SOURCE_OVER = 0,
        D2D1_COMPOSITE_MODE_DESTINATION_OVER = 1,
        D2D1_COMPOSITE_MODE_SOURCE_IN = 2,
        D2D1_COMPOSITE_MODE_DESTINATION_IN = 3,
        D2D1_COMPOSITE_MODE_SOURCE_OUT = 4,
        D2D1_COMPOSITE_MODE_DESTINATION_OUT = 5,
        D2D1_COMPOSITE_MODE_SOURCE_ATOP = 6,
        D2D1_COMPOSITE_MODE_DESTINATION_ATOP = 7,
        D2D1_COMPOSITE_MODE_XOR = 8,
        D2D1_COMPOSITE_MODE_PLUS = 9,
        D2D1_COMPOSITE_MODE_SOURCE_COPY = 10,
        D2D1_COMPOSITE_MODE_BOUNDED_SOURCE_COPY = 11,
        D2D1_COMPOSITE_MODE_MASK_INVERT = 12,
        D2D1_COMPOSITE_MODE_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_COMPOSITE_MODE = ^TD2D1_COMPOSITE_MODE;


    /// This specifies the precision that should be used in buffers allocated by D2D.
    TD2D1_BUFFER_PRECISION = (
        D2D1_BUFFER_PRECISION_UNKNOWN = 0,
        D2D1_BUFFER_PRECISION_8BPC_UNORM = 1,
        D2D1_BUFFER_PRECISION_8BPC_UNORM_SRGB = 2,
        D2D1_BUFFER_PRECISION_16BPC_UNORM = 3,
        D2D1_BUFFER_PRECISION_16BPC_FLOAT = 4,
        D2D1_BUFFER_PRECISION_32BPC_FLOAT = 5,
        D2D1_BUFFER_PRECISION_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_BUFFER_PRECISION = ^TD2D1_BUFFER_PRECISION;

    /// This describes how the individual mapping operation should be performed.
    TD2D1_MAP_OPTIONS = (
        /// The mapped pointer has undefined behavior.
        D2D1_MAP_OPTIONS_NONE = 0,
        /// The mapped pointer can be read from.
        D2D1_MAP_OPTIONS_READ = 1,
        /// The mapped pointer can be written to.
        D2D1_MAP_OPTIONS_WRITE = 2,
        /// The previous contents of the bitmap are discarded when it is mapped.
        D2D1_MAP_OPTIONS_DISCARD = 4,
        D2D1_MAP_OPTIONS_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_MAP_OPTIONS = ^TD2D1_MAP_OPTIONS;

    /// This is used to specify the quality of image scaling with
    /// ID2D1DeviceContext::DrawImage and with the 2D Affine Transform Effect.
    TD2D1_INTERPOLATION_MODE = (
        D2D1_INTERPOLATION_MODE_NEAREST_NEIGHBOR = D2D1_INTERPOLATION_MODE_DEFINITION_NEAREST_NEIGHBOR,
        D2D1_INTERPOLATION_MODE_LINEAR = D2D1_INTERPOLATION_MODE_DEFINITION_LINEAR,
        D2D1_INTERPOLATION_MODE_CUBIC = D2D1_INTERPOLATION_MODE_DEFINITION_CUBIC,
        D2D1_INTERPOLATION_MODE_MULTI_SAMPLE_LINEAR = D2D1_INTERPOLATION_MODE_DEFINITION_MULTI_SAMPLE_LINEAR,
        D2D1_INTERPOLATION_MODE_ANISOTROPIC = D2D1_INTERPOLATION_MODE_DEFINITION_ANISOTROPIC,
        D2D1_INTERPOLATION_MODE_HIGH_QUALITY_CUBIC = D2D1_INTERPOLATION_MODE_DEFINITION_HIGH_QUALITY_CUBIC,
        D2D1_INTERPOLATION_MODE_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_INTERPOLATION_MODE = ^TD2D1_INTERPOLATION_MODE;


    /// This specifies what units should be accepted by the D2D API.
    TD2D1_UNIT_MODE = (
        D2D1_UNIT_MODE_DIPS = 0,
        D2D1_UNIT_MODE_PIXELS = 1,
        D2D1_UNIT_MODE_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_UNIT_MODE = ^TD2D1_UNIT_MODE;

    /// Defines a color space.
    TD2D1_COLOR_SPACE = (
        /// The color space is described by accompanying data, such as a color profile.
        D2D1_COLOR_SPACE_CUSTOM = 0,
        /// The sRGB color space.
        D2D1_COLOR_SPACE_SRGB = 1,
        /// The scRGB color space.
        D2D1_COLOR_SPACE_SCRGB = 2,
        D2D1_COLOR_SPACE_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_COLOR_SPACE = ^TD2D1_COLOR_SPACE;

    /// This specifies options that apply to the device context for its lifetime.
    TD2D1_DEVICE_CONTEXT_OPTIONS = (
        D2D1_DEVICE_CONTEXT_OPTIONS_NONE = 0,
        /// Geometry rendering will be performed on many threads in parallel, a single
        /// thread is the default.
        D2D1_DEVICE_CONTEXT_OPTIONS_ENABLE_MULTITHREADED_OPTIMIZATIONS = 1,
        D2D1_DEVICE_CONTEXT_OPTIONS_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_DEVICE_CONTEXT_OPTIONS = ^TD2D1_DEVICE_CONTEXT_OPTIONS;

    /// Defines how the world transform, dots per inch (dpi), and stroke width affect
    /// the shape of the pen used to stroke a primitive.
    TD2D1_STROKE_TRANSFORM_TYPE = (
        /// The stroke respects the world transform, the DPI, and the stroke width.
        D2D1_STROKE_TRANSFORM_TYPE_NORMAL = 0,
        /// The stroke does not respect the world transform, but it does respect the DPI and
        /// the stroke width.
        D2D1_STROKE_TRANSFORM_TYPE_FIXED = 1,
        /// The stroke is forced to one pixel wide.
        D2D1_STROKE_TRANSFORM_TYPE_HAIRLINE = 2,
        D2D1_STROKE_TRANSFORM_TYPE_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_STROKE_TRANSFORM_TYPE = ^TD2D1_STROKE_TRANSFORM_TYPE;

    /// A blend mode that applies to all primitives drawn on the context.
    TD2D1_PRIMITIVE_BLEND = (
        D2D1_PRIMITIVE_BLEND_SOURCE_OVER = 0,
        D2D1_PRIMITIVE_BLEND_COPY = 1,
        D2D1_PRIMITIVE_BLEND_MIN = 2,
        D2D1_PRIMITIVE_BLEND_ADD = 3,
        D2D1_PRIMITIVE_BLEND_MAX = 4,
        D2D1_PRIMITIVE_BLEND_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_PRIMITIVE_BLEND = ^TD2D1_PRIMITIVE_BLEND;

    /// This specifies the threading mode used while simultaneously creating the device,
    /// factory, and device context.
    TD2D1_THREADING_MODE = (
        /// Resources may only be invoked serially.  Reference counts on resources are
        /// interlocked, however, resource and render target state is not protected from
        /// multi-threaded access
        D2D1_THREADING_MODE_SINGLE_THREADED = Ord(D2D1_FACTORY_TYPE_SINGLE_THREADED),
        /// Resources may be invoked from multiple threads. Resources use interlocked
        /// reference counting and their state is protected.
        D2D1_THREADING_MODE_MULTI_THREADED = Ord(D2D1_FACTORY_TYPE_MULTI_THREADED),
        D2D1_THREADING_MODE_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_THREADING_MODE = ^TD2D1_THREADING_MODE;

    /// This specifies how colors are interpolated.
    TD2D1_COLOR_INTERPOLATION_MODE = (
        /// Colors will be interpolated in straight alpha space.
        D2D1_COLOR_INTERPOLATION_MODE_STRAIGHT = 0,
        /// Colors will be interpolated in premultiplied alpha space.
        D2D1_COLOR_INTERPOLATION_MODE_PREMULTIPLIED = 1,
        D2D1_COLOR_INTERPOLATION_MODE_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_COLOR_INTERPOLATION_MODE = ^TD2D1_COLOR_INTERPOLATION_MODE;


    TD2D1_VECTOR_2F = TD2D_VECTOR_2F;
    TD2D1_VECTOR_3F = TD2D_VECTOR_3F;
    TD2D1_VECTOR_4F = TD2D_VECTOR_4F;


    /// Extended bitmap properties.
    TD2D1_BITMAP_PROPERTIES1 = record
        pixelFormat: TD2D1_PIXEL_FORMAT;
        dpiX: single;
        dpiY: single;
        /// Specifies how the bitmap can be used.
        bitmapOptions: TD2D1_BITMAP_OPTIONS;
        {_Field_size_opt_(1) } colorContext: ID2D1ColorContext;
    end;
    PD2D1_BITMAP_PROPERTIES1 = ^TD2D1_BITMAP_PROPERTIES1;


    /// Describes mapped memory from the ID2D1Bitmap1::Map API.
    TD2D1_MAPPED_RECT = record
        pitch: uint32;
        bits: pbyte;
    end;
    PD2D1_MAPPED_RECT = ^TD2D1_MAPPED_RECT;


    /// This controls advanced settings of the Direct2D imaging pipeline.
    TD2D1_RENDERING_CONTROLS = record
        /// The default buffer precision, used if the precision isn't otherwise specified.
        bufferPrecision: TD2D1_BUFFER_PRECISION;
        /// The size of allocated tiles used to render imaging effects.
        tileSize: TD2D1_SIZE_U;
    end;
    PD2D1_RENDERING_CONTROLS = ^TD2D1_RENDERING_CONTROLS;


    /// This identifies a certain input connection of a certain effect.
    TD2D1_EFFECT_INPUT_DESCRIPTION = record
        /// The effect whose input connection is being specified.
        effect: PID2D1Effect;
        /// The index of the input connection into the specified effect.
        inputIndex: uint32;
        /// The rectangle which would be available on the specified input connection during
        /// render operations.
        inputRectangle: TD2D1_RECT_F;
    end;
    PD2D1_EFFECT_INPUT_DESCRIPTION = ^TD2D1_EFFECT_INPUT_DESCRIPTION;

    TD2D1_MATRIX_4X3_F = TD2D_MATRIX_4X3_F;
    PD2D1_MATRIX_4X3_F = ^TD2D1_MATRIX_4X3_F;

    TD2D1_MATRIX_4X4_F = TD2D_MATRIX_4X4_F;
    PD2D1_MATRIX_4X4_F = ^TD2D1_MATRIX_4X4_F;

    TD2D1_MATRIX_5X4_F = TD2D_MATRIX_5X4_F;
    PD2D1_MATRIX_5X4_F = ^TD2D1_MATRIX_5X4_F;

    /// Describes a point along a path.
    TD2D1_POINT_DESCRIPTION = record
        point: TD2D1_POINT_2F;
        unitTangentVector: TD2D1_POINT_2F;
        endSegment: uint32;
        endFigure: uint32;
        lengthToEndSegment: single;
    end;
    PD2D1_POINT_DESCRIPTION = ^TD2D1_POINT_DESCRIPTION;

    /// Creation properties for an image brush.
    TD2D1_IMAGE_BRUSH_PROPERTIES = record
        sourceRectangle: TD2D1_RECT_F;
        extendModeX: TD2D1_EXTEND_MODE;
        extendModeY: TD2D1_EXTEND_MODE;
        interpolationMode: TD2D1_INTERPOLATION_MODE;
    end;
    PD2D1_IMAGE_BRUSH_PROPERTIES = ^TD2D1_IMAGE_BRUSH_PROPERTIES;

    /// Describes the extend modes and the interpolation mode of an ID2D1BitmapBrush.
    TD2D1_BITMAP_BRUSH_PROPERTIES1 = record
        extendModeX: TD2D1_EXTEND_MODE;
        extendModeY: TD2D1_EXTEND_MODE;
        interpolationMode: TD2D1_INTERPOLATION_MODE;
    end;
    PD2D1_BITMAP_BRUSH_PROPERTIES1 = ^TD2D1_BITMAP_BRUSH_PROPERTIES1;

    /// This defines how geometries should be drawn and widened.
    TD2D1_STROKE_STYLE_PROPERTIES1 = record
        startCap: TD2D1_CAP_STYLE;
        endCap: TD2D1_CAP_STYLE;
        dashCap: TD2D1_CAP_STYLE;
        lineJoin: TD2D1_LINE_JOIN;
        miterLimit: single;
        dashStyle: TD2D1_DASH_STYLE;
        dashOffset: single;
        /// How the nib of the stroke is influenced by the context properties.
        transformType: TD2D1_STROKE_TRANSFORM_TYPE;
    end;
    PD2D1_STROKE_STYLE_PROPERTIES1 = ^TD2D1_STROKE_STYLE_PROPERTIES1;

    /// Specifies how the layer contents should be prepared.
    TD2D1_LAYER_OPTIONS1 = (
        D2D1_LAYER_OPTIONS1_NONE = 0,
        D2D1_LAYER_OPTIONS1_INITIALIZE_FROM_BACKGROUND = 1,
        D2D1_LAYER_OPTIONS1_IGNORE_ALPHA = 2,
        D2D1_LAYER_OPTIONS1_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_LAYER_OPTIONS1 = ^TD2D1_LAYER_OPTIONS1;

    /// All parameters related to pushing a layer.
    TD2D1_LAYER_PARAMETERS1 = record
        contentBounds: TD2D1_RECT_F;
        {_Field_size_opt_(1) } geometricMask: ID2D1Geometry;
        maskAntialiasMode: TD2D1_ANTIALIAS_MODE;
        maskTransform: TD2D1_MATRIX_3X2_F;
        opacity: single;
        {_Field_size_opt_(1) } opacityBrush: ID2D1Brush;
        layerOptions: TD2D1_LAYER_OPTIONS1;
    end;
    PD2D1_LAYER_PARAMETERS1 = ^TD2D1_LAYER_PARAMETERS1;

    /// Defines when font resources should be subset during printing.
    TD2D1_PRINT_FONT_SUBSET_MODE = (
        /// Subset for used glyphs, send and discard font resource after every five pages
        D2D1_PRINT_FONT_SUBSET_MODE_DEFAULT = 0,
        /// Subset for used glyphs, send and discard font resource after each page
        D2D1_PRINT_FONT_SUBSET_MODE_EACHPAGE = 1,
        /// Do not subset, reuse font for all pages, send it after first page
        D2D1_PRINT_FONT_SUBSET_MODE_NONE = 2,
        D2D1_PRINT_FONT_SUBSET_MODE_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_PRINT_FONT_SUBSET_MODE = ^TD2D1_PRINT_FONT_SUBSET_MODE;

    /// This describes the drawing state.
    TD2D1_DRAWING_STATE_DESCRIPTION1 = record
        antialiasMode: TD2D1_ANTIALIAS_MODE;
        textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE;
        tag1: TD2D1_TAG;
        tag2: TD2D1_TAG;
        transform: TD2D1_MATRIX_3X2_F;
        primitiveBlend: TD2D1_PRIMITIVE_BLEND;
        unitMode: TD2D1_UNIT_MODE;
    end;
    PD2D1_DRAWING_STATE_DESCRIPTION1 = ^TD2D1_DRAWING_STATE_DESCRIPTION1;

    /// The creation properties for a ID2D1PrintControl object.
    TD2D1_PRINT_CONTROL_PROPERTIES = record
        fontSubset: TD2D1_PRINT_FONT_SUBSET_MODE;
        /// DPI for rasterization of all unsupported D2D commands or options, defaults to
        /// 150.0
        rasterDPI: single;
        /// Color space for vector graphics in XPS package
        colorSpace: TD2D1_COLOR_SPACE;
    end;
    PD2D1_PRINT_CONTROL_PROPERTIES = ^TD2D1_PRINT_CONTROL_PROPERTIES;

    /// This specifies the options while simultaneously creating the device, factory,
    /// and device context.
    TD2D1_CREATION_PROPERTIES = record
        /// Describes locking behavior of D2D resources
        threadingMode: TD2D1_THREADING_MODE;
        debugLevel: TD2D1_DEBUG_LEVEL;
        options: TD2D1_DEVICE_CONTEXT_OPTIONS;
    end;
    PD2D1_CREATION_PROPERTIES = ^TD2D1_CREATION_PROPERTIES;


    /// User-implementable interface for introspecting on a metafile.
    ID2D1GdiMetafileSink = interface(IUnknown)
        ['{82237326-8111-4f7c-bcf4-b5c1175564fe}']
        /// Callback for examining a metafile record.
        function ProcessRecord(recordType: DWORD;
        {_In_opt_ } recordData: Pvoid; recordDataSize: DWORD): HRESULT; stdcall;

    end;

    /// Interface encapsulating a GDI/GDI+ metafile.
    ID2D1GdiMetafile = interface(ID2D1Resource)
        ['{2f543dc3-cfc1-4211-864f-cfd91c6f3395}']
        /// Play the metafile into a caller-supplied sink interface.
        function Stream(
        {_In_ } sink: ID2D1GdiMetafileSink): HRESULT; stdcall;

        /// Gets the bounds of the metafile.
        function GetBounds(
        {_Out_ } bounds: PD2D1_RECT_F): HRESULT; stdcall;

    end;

    /// Caller-supplied implementation of an interface to receive the recorded command
    /// list.
    ID2D1CommandSink = interface(IUnknown)
        ['{54d7898a-a061-40a7-bec7-e465bcba2c4f}']
        function BeginDraw(): HRESULT; stdcall;

        function EndDraw(): HRESULT; stdcall;

        function SetAntialiasMode(antialiasMode: TD2D1_ANTIALIAS_MODE): HRESULT; stdcall;

        function SetTags(tag1: TD2D1_TAG; tag2: TD2D1_TAG): HRESULT; stdcall;

        function SetTextAntialiasMode(textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE): HRESULT; stdcall;

        function SetTextRenderingParams(
        {_In_opt_ } textRenderingParams: IDWriteRenderingParams): HRESULT; stdcall;

        function SetTransform(
        {_In_ } transform: PD2D1_MATRIX_3X2_F): HRESULT; stdcall;

        function SetPrimitiveBlend(primitiveBlend: TD2D1_PRIMITIVE_BLEND): HRESULT; stdcall;

        function SetUnitMode(unitMode: TD2D1_UNIT_MODE): HRESULT; stdcall;

        function Clear(
        {_In_opt_ } color: PD2D1_COLOR_F): HRESULT; stdcall;

        function DrawGlyphRun(baselineOrigin: TD2D1_POINT_2F;
        {_In_ } glyphRun: PDWRITE_GLYPH_RUN;
        {_In_opt_ } glyphRunDescription: PDWRITE_GLYPH_RUN_DESCRIPTION;
        {_In_ } foregroundBrush: ID2D1Brush; measuringMode: TDWRITE_MEASURING_MODE): HRESULT; stdcall;

        function DrawLine(point0: TD2D1_POINT_2F; point1: TD2D1_POINT_2F;
        {_In_ } brush: ID2D1Brush; strokeWidth: single;
        {_In_opt_ } strokeStyle: ID2D1StrokeStyle): HRESULT; stdcall;

        function DrawGeometry(
        {_In_ } geometry: ID2D1Geometry;
        {_In_ } brush: ID2D1Brush; strokeWidth: single;
        {_In_opt_ } strokeStyle: ID2D1StrokeStyle): HRESULT; stdcall;

        function DrawRectangle(
        {_In_ } rect: PD2D1_RECT_F;
        {_In_ } brush: ID2D1Brush; strokeWidth: single;
        {_In_opt_ } strokeStyle: ID2D1StrokeStyle): HRESULT; stdcall;

        function DrawBitmap(
        {_In_ } bitmap: ID2D1Bitmap;
        {_In_opt_ } destinationRectangle: PD2D1_RECT_F; opacity: single; interpolationMode: TD2D1_INTERPOLATION_MODE;
        {_In_opt_ } sourceRectangle: PD2D1_RECT_F;
        {_In_opt_ } perspectiveTransform: PD2D1_MATRIX_4X4_F): HRESULT; stdcall;

        function DrawImage(
        {_In_ } image: ID2D1Image;
        {_In_opt_ } targetOffset: PD2D1_POINT_2F;
        {_In_opt_ } imageRectangle: PD2D1_RECT_F; interpolationMode: TD2D1_INTERPOLATION_MODE; compositeMode: TD2D1_COMPOSITE_MODE): HRESULT; stdcall;

        function DrawGdiMetafile(
        {_In_ } gdiMetafile: ID2D1GdiMetafile;
        {_In_opt_ } targetOffset: PD2D1_POINT_2F): HRESULT; stdcall;

        function FillMesh(
        {_In_ } mesh: ID2D1Mesh;
        {_In_ } brush: ID2D1Brush): HRESULT; stdcall;

        function FillOpacityMask(
        {_In_ } opacityMask: ID2D1Bitmap;
        {_In_ } brush: ID2D1Brush;
        {_In_opt_ } destinationRectangle: PD2D1_RECT_F;
        {_In_opt_ } sourceRectangle: PD2D1_RECT_F): HRESULT; stdcall;

        function FillGeometry(
        {_In_ } geometry: ID2D1Geometry;
        {_In_ } brush: ID2D1Brush;
        {_In_opt_ } opacityBrush: ID2D1Brush): HRESULT; stdcall;

        function FillRectangle(
        {_In_ } rect: PD2D1_RECT_F;
        {_In_ } brush: ID2D1Brush): HRESULT; stdcall;

        function PushAxisAlignedClip(
        {_In_ } clipRect: PD2D1_RECT_F; antialiasMode: TD2D1_ANTIALIAS_MODE): HRESULT; stdcall;

        function PushLayer(
        {_In_ } layerParameters1: PD2D1_LAYER_PARAMETERS1;
        {_In_opt_ } layer: ID2D1Layer): HRESULT; stdcall;

        function PopAxisAlignedClip(): HRESULT; stdcall;

        function PopLayer(): HRESULT; stdcall;

    end;

    /// The commandList interface.
    ID2D1CommandList = interface(ID2D1Image)
        ['{b4f34a19-2383-4d76-94f6-ec343657c3dc}']
        /// Play the command list into a caller-supplied sink interface.
        function Stream(
        {_In_ } sink: ID2D1CommandSink): HRESULT; stdcall;

        /// Marks the command list as ready for use.
        function Close(): HRESULT; stdcall;

    end;

    /// Converts Direct2D primitives stored in an ID2D1CommandList into a fixed page
    /// representation. The print sub-system then consumes the primitives.
    ID2D1PrintControl = interface(IUnknown)
        ['{2c1d867d-c290-41c8-ae7e-34a98702e9a5}']
        function AddPage(
        {_In_ } commandList: ID2D1CommandList; pageSize: TD2D_SIZE_F;
        {_In_opt_ } pagePrintTicketStream: IStream;
        {_Out_opt_ } tag1: PD2D1_TAG = nil;
        {_Out_opt_ } tag2: PD2D1_TAG = nil): HRESULT; stdcall;

        function Close(): HRESULT; stdcall;

    end;

    /// Provides a brush that can take any effect, command list or bitmap and use it to
    /// fill a 2D shape.
    ID2D1ImageBrush = interface(ID2D1Brush)
        ['{fe9e984d-3f95-407c-b5db-cb94d4e8f87c}']
        procedure SetImage(
        {_In_opt_ } image: ID2D1Image); stdcall;

        procedure SetExtendModeX(extendModeX: TD2D1_EXTEND_MODE); stdcall;

        procedure SetExtendModeY(extendModeY: TD2D1_EXTEND_MODE); stdcall;

        procedure SetInterpolationMode(interpolationMode: TD2D1_INTERPOLATION_MODE); stdcall;

        procedure SetSourceRectangle(
        {_In_ } sourceRectangle: PD2D1_RECT_F); stdcall;

        procedure GetImage(
        {_Outptr_result_maybenull_ }  out image: ID2D1Image); stdcall;

        function GetExtendModeX(): TD2D1_EXTEND_MODE; stdcall;

        function GetExtendModeY(): TD2D1_EXTEND_MODE; stdcall;

        function GetInterpolationMode(): TD2D1_INTERPOLATION_MODE; stdcall;

        procedure GetSourceRectangle(
        {_Out_ } sourceRectangle: PD2D1_RECT_F); stdcall;

    end;

    /// A bitmap brush allows a bitmap to be used to fill a geometry.  Interpolation
    /// mode is specified with D2D1_INTERPOLATION_MODE
    ID2D1BitmapBrush1 = interface(ID2D1BitmapBrush)
        ['{41343a53-e41a-49a2-91cd-21793bbb62e5}']
        /// Sets the interpolation mode used when this brush is used.
        procedure SetInterpolationMode1(interpolationMode: TD2D1_INTERPOLATION_MODE); stdcall;

        function GetInterpolationMode1(): TD2D1_INTERPOLATION_MODE; stdcall;

    end;

    /// Extends a stroke style to allow nominal width strokes.
    ID2D1StrokeStyle1 = interface(ID2D1StrokeStyle)
        ['{10a72a66-e91c-43f4-993f-ddf4b82b0b4a}']
        function GetStrokeTransformType(): TD2D1_STROKE_TRANSFORM_TYPE; stdcall;

    end;

    /// The ID2D1PathGeometry1 interface adds functionality to ID2D1PathGeometry. In
    /// particular, it provides the path geometry-specific
    /// ComputePointAndSegmentAtLength method.
    ID2D1PathGeometry1 = interface(ID2D1PathGeometry)
        ['{62baa2d2-ab54-41b7-b872-787e0106a421}']
        function ComputePointAndSegmentAtLength(length: single; startSegment: uint32;
        {_In_opt_ } worldTransform: PD2D1_MATRIX_3X2_F; flatteningTolerance: single;
        {_Out_ } pointDescription: PD2D1_POINT_DESCRIPTION): HRESULT; stdcall;

    end;

    ID2D1PathGeometry1Helper = type helper for ID2D1PathGeometry1
        function ComputePointAndSegmentAtLength(length: single; startSegment: uint32; worldTransform: TD2D1_MATRIX_3X2_F; flatteningTolerance: single;
        {_Out_ } pointDescription: PD2D1_POINT_DESCRIPTION): HRESULT; overload;

        function ComputePointAndSegmentAtLength(length: single; startSegment: uint32;
        {_In_opt_ } worldTransform: PD2D1_MATRIX_3X2_F;
        {_Out_ } pointDescription: PD2D1_POINT_DESCRIPTION): HRESULT; overload;

        function ComputePointAndSegmentAtLength(length: single; startSegment: uint32; worldTransform: TD2D1_MATRIX_3X2_F;
        {_Out_ } pointDescription: PD2D1_POINT_DESCRIPTION): HRESULT; overload;

    end;

    /// Represents a set of run-time bindable and discoverable properties that allow a
    /// data-driven application to modify the state of a Direct2D effect.
    ID2D1Properties = interface(IUnknown)
        ['{483473d7-cd46-4f9d-9d3a-3112aa80159d}']
        /// Returns the total number of custom properties in this interface.
        function GetPropertyCount(): uint32; stdcall;

        /// Retrieves the property name from the given property index.
        function GetPropertyName(index: uint32;
        {_Out_writes_(nameCount) } Name: PWSTR; nameCount: uint32): HRESULT; stdcall;

        /// Returns the length of the property name from the given index.
        function GetPropertyNameLength(index: uint32): uint32; stdcall;

        /// Retrieves the type of the given property.
        function GetType(index: uint32): TD2D1_PROPERTY_TYPE; stdcall;

        /// Retrieves the property index for the given property name.
        function GetPropertyIndex(
        {_In_ } Name: PCWSTR): uint32; stdcall;

        /// Sets the value of the given property using its name.
        function SetValueByName(
        {_In_ } Name: PCWSTR; _type: TD2D1_PROPERTY_TYPE;
        {_In_reads_(dataSize) } Data: pbyte; dataSize: uint32): HRESULT; stdcall;

        /// Sets the given value using the property index.
        function SetValue(index: uint32; _type: TD2D1_PROPERTY_TYPE;
        {_In_reads_(dataSize) } Data: pbyte; dataSize: uint32): HRESULT; stdcall;

        /// Retrieves the given property or sub-property by name. '.' is the delimiter for
        /// sub-properties.
        function GetValueByName(
        {_In_ } Name: PCWSTR; _type: TD2D1_PROPERTY_TYPE;
        {_Out_writes_(dataSize) } Data: pbyte; dataSize: uint32): HRESULT; stdcall;

        /// Retrieves the given value by index.
        function GetValue(index: uint32; _type: TD2D1_PROPERTY_TYPE;
        {_Out_writes_(dataSize) } Data: pbyte; dataSize: uint32): HRESULT; stdcall;

        /// Returns the value size for the given property index.
        function GetValueSize(index: uint32): uint32; stdcall;

        /// Retrieves the sub-properties of the given property by index.
        function GetSubProperties(index: uint32;
        {_COM_Outptr_result_maybenull_ }  out subProperties: ID2D1Properties): HRESULT; stdcall;

    end;

    { ID2D1PropertiesHelper }

    ID2D1PropertiesHelper = type helper for ID2D1Properties
        function SetValueByName(
        {_In_ } Name: PCWSTR;
        {_In_reads_(dataSize) } Data: pbyte; dataSize: uint32): HRESULT; overload;

        function SetValue(index: uint32;
        {_In_reads_(dataSize) } Data: pbyte; dataSize: uint32): HRESULT; overload;

        function GetValueByName(
        {_In_ } Name: PCWSTR;
        {_Out_writes_(dataSize) } Data: pbyte; dataSize: uint32): HRESULT; overload;

        function GetValue(index: uint32;
        {_Out_writes_(dataSize) } Data: pbyte; dataSize: uint32): HRESULT; overload;
        // Templatized helper functions:
        function GetValueByName<T>(propertyName: PCWSTR; out Value: T): HResult; overload;
        function GetValueByName<T>(propertyName: PCWSTR): T; overload;
        function SetValueByName<T>(propertyName: PCWSTR; const Value: T): HResult;
        function GetValue<U>(index: U; out Data: pbyte; dataSize: uint32): HResult;
        function GetValue<T, U>(index: U; out Value: T): HResult; overload;
        function GetValue<T, U>(index: U): T; overload;
        function SetValue<U>(Index: U; const Data: pbyte; dataSize: uint32): Hresult; overload;
        function SetValue<T, U>(index: U; const Value: T): Hresult; overload;
        function GetPropertyName<U>(index: U; out Name: PWSTR; nameCount: uint32): Hresult; overload;
        function GetPropertyNameLength<U>(index: U): uint32; overload;
        function GetType<U>(index: U): TD2D1_PROPERTY_TYPE; overload;
        function GetValueSize<U>(index: U): uint32; overload;
        function GetSubProperties<U>(index: U; out subProperties: ID2D1Properties): Hresult; overload;
    end;


    /// The effect interface. Properties control how the effect is rendered. The effect
    /// is Drawn with the DrawImage call.
    ID2D1Effect = interface(ID2D1Properties)
        ['{28211a43-7d89-476f-8181-2d6159b220ad}']
        /// Sets the input to the given effect. The input can be a concrete bitmap or the
        /// output of another effect.
        procedure SetInput(index: uint32;
        {_In_opt_ } input: ID2D1Image; invalidate: boolean = True); stdcall;

        /// If the effect supports a variable number of inputs, this sets the number of
        /// input that are currently active on the effect.
        function SetInputCount(inputCount: uint32): HRESULT; stdcall;

        /// Returns the input image to the effect. The input could be another effect or a
        /// bitmap.
        procedure GetInput(index: uint32;
        {_Outptr_result_maybenull_ }  out input: ID2D1Image); stdcall;

        /// This returns the number of input that are bound into this effect.
        function GetInputCount(): uint32; stdcall;

        /// Returns the output image of the given effect. This can be set as the input to
        /// another effect or can be drawn with DrawImage.
        procedure GetOutput(
        {_Outptr_ }  out outputImage: ID2D1Image); stdcall;

    end;

    ID2D1EffectHelper = type helper for ID2D1Effect
        procedure SetInputEffect(index: uint32;
        {_In_opt_ } inputEffect: ID2D1Effect; invalidate: boolean = True); overload;

    end;

    /// Represents a bitmap that can be used as a surface for an ID2D1DeviceContext or
    /// mapped into system memory, and can contain additional color context information.
    ID2D1Bitmap1 = interface(ID2D1Bitmap)
        ['{a898a84c-3873-4588-b08b-ebbf978df041}']
        /// Retrieves the color context information associated with the bitmap.
        procedure GetColorContext(
        {_Outptr_result_maybenull_ }  out colorContext: ID2D1ColorContext); stdcall;

        /// Retrieves the bitmap options used when creating the API.
        function GetOptions(): TD2D1_BITMAP_OPTIONS; stdcall;

        /// Retrieves the DXGI surface from the corresponding bitmap, if the bitmap was
        /// created from a device derived from a D3D device.
        function GetSurface(
        {_COM_Outptr_result_maybenull_ }  out dxgiSurface: IDXGISurface): HRESULT; stdcall;

        /// Maps the given bitmap into memory. The bitmap must have been created with the
        /// D2D1_BITMAP_OPTIONS_CPU_READ flag.
        function Map(options: TD2D1_MAP_OPTIONS;
        {_Out_ } mappedRect: PD2D1_MAPPED_RECT): HRESULT; stdcall;

        /// Unmaps the given bitmap from memory.
        function Unmap(): HRESULT; stdcall;

    end;

    /// Represents a color context that can be used with an ID2D1Bitmap1 object.
    ID2D1ColorContext = interface(ID2D1Resource)
        ['{1c4820bb-5771-4518-a581-2fe4dd0ec657}']
        /// Retrieves the color space of the color context.
        function GetColorSpace(): TD2D1_COLOR_SPACE; stdcall;

        /// Retrieves the size of the color profile, in bytes.
        function GetProfileSize(): uint32; stdcall;

        /// Retrieves the color profile bytes.
        function GetProfile(
        {_Out_writes_(profileSize) } profile: pbyte; profileSize: uint32): HRESULT; stdcall;

    end;

    /// Represents an collection of gradient stops that can then be the source resource
    /// for either a linear or radial gradient brush.
    ID2D1GradientStopCollection1 = interface(ID2D1GradientStopCollection)
        ['{ae1572f4-5dd0-4777-998b-9279472ae63b}']
        /// Copies the gradient stops from the collection into the caller's memory. If this
        /// object was created using ID2D1DeviceContext::CreateGradientStopCollection, this
        /// method returns the same values as were specified in the creation method. If this
        /// object was created using ID2D1RenderTarget::CreateGradientStopCollection, the
        /// stops returned here will first be transformed into the gamma space specified by
        /// the colorInterpolationGamma parameter.
        procedure GetGradientStops1(
        {_Out_writes_to_(gradientStopsCount, _Inexpressible_("Retrieved through GetGradientStopCount()") ) } gradientStops: PD2D1_GRADIENT_STOP; gradientStopsCount: uint32); stdcall;

        /// Returns the color space in which interpolation occurs. If this object was
        /// created using ID2D1RenderTarget::CreateGradientStopCollection, this method
        /// returns the color space related to the color interpolation gamma.
        function GetPreInterpolationSpace(): TD2D1_COLOR_SPACE; stdcall;

        /// Returns the color space colors will be converted to after interpolation occurs.
        /// If this object was created using
        /// ID2D1RenderTarget::CreateGradientStopCollection, this method returns
        /// D2D1_COLOR_SPACE_SRGB.
        function GetPostInterpolationSpace(): TD2D1_COLOR_SPACE; stdcall;

        /// Returns the buffer precision of this gradient. If this object was created using
        /// ID2D1RenderTarget::CreateGradientStopCollection, this method returns
        /// D2D1_BUFFER_PRECISION_8BPC_UNORM.
        function GetBufferPrecision(): TD2D1_BUFFER_PRECISION; stdcall;

        /// Returns the interpolation mode used to interpolate colors in the gradient.
        function GetColorInterpolationMode(): TD2D1_COLOR_INTERPOLATION_MODE; stdcall;

    end;


    /// Represents drawing state.


    ID2D1DrawingStateBlock1 = interface(ID2D1DrawingStateBlock)
        ['{689f1f85-c72e-4e33-8f19-85754efd5ace}']
        /// Retrieves the state currently contained within this state block resource.
        procedure GetDescription(
        {_Out_ } stateDescription: PD2D1_DRAWING_STATE_DESCRIPTION1); stdcall;

        /// Sets the state description of this state block resource.
        procedure SetDescription(
        {_In_ } stateDescription: PD2D1_DRAWING_STATE_DESCRIPTION1); stdcall;

    end;

    /// The device context represents a set of state and a command buffer that is used
    /// to render to a target bitmap.
    ID2D1DeviceContext = interface(ID2D1RenderTarget)
        ['{e8f7fe7a-191c-466d-ad95-975678bda998}']
        /// Creates a bitmap with extended bitmap properties, potentially from a block of
        /// memory.
        function CreateBitmap(size: TD2D1_SIZE_U;
        {_In_opt_ } sourceData: Pvoid; pitch: uint32;
        {_In_ } bitmapProperties: PD2D1_BITMAP_PROPERTIES1;
        {_COM_Outptr_ }  out bitmap: ID2D1Bitmap1): HRESULT; stdcall;

        /// Create a D2D bitmap by copying a WIC bitmap.
        function CreateBitmapFromWicBitmap(
        {_In_ } wicBitmapSource: IWICBitmapSource;
        {_In_opt_ } bitmapProperties: PD2D1_BITMAP_PROPERTIES1;
        {_COM_Outptr_ }  out bitmap: ID2D1Bitmap1): HRESULT; stdcall;

        /// Creates a color context from a color space.  If the space is Custom, the context
        /// is initialized from the profile/profileSize arguments.  Otherwise the context is
        /// initialized with the profile bytes associated with the space and
        /// profile/profileSize are ignored.
        function CreateColorContext(space: TD2D1_COLOR_SPACE;
        {_In_reads_opt_(profileSize) } profile: pbyte; profileSize: uint32;
        {_COM_Outptr_ }  out colorContext: ID2D1ColorContext): HRESULT; stdcall;

        function CreateColorContextFromFilename(
        {_In_ } filename: PCWSTR;
        {_COM_Outptr_ }  out colorContext: ID2D1ColorContext): HRESULT; stdcall;

        function CreateColorContextFromWicColorContext(
        {_In_ } wicColorContext: IWICColorContext;
        {_COM_Outptr_ }  out colorContext: ID2D1ColorContext): HRESULT; stdcall;

        /// Creates a bitmap from a DXGI surface with a set of extended properties.
        function CreateBitmapFromDxgiSurface(
        {_In_ } surface: IDXGISurface;
        {_In_opt_ } bitmapProperties: PD2D1_BITMAP_PROPERTIES1;
        {_COM_Outptr_ }  out bitmap: ID2D1Bitmap1): HRESULT; stdcall;

        /// Create a new effect, the effect must either be built in or previously registered
        /// through ID2D1Factory1::RegisterEffectFromStream or
        /// ID2D1Factory1::RegisterEffectFromString.
        function CreateEffect(
        {_In_ } effectId: REFCLSID;
        {_COM_Outptr_ }  out effect: ID2D1Effect): HRESULT; stdcall;

        /// A gradient stop collection represents a set of stops in an ideal unit length.
        /// This is the source resource for a linear gradient and radial gradient brush.
        /// <param name="preInterpolationSpace">Specifies both the input color space and the
        /// space in which the color interpolation occurs.</param>
        /// <param name="postInterpolationSpace">Specifies the color space colors will be
        /// converted to after interpolation occurs.</param>
        /// <param name="bufferPrecision">Specifies the precision in which the gradient
        /// buffer will be held.</param>
        /// <param name="extendMode">Specifies how the gradient will be extended outside of
        /// the unit length.</param>
        /// <param name="colorInterpolationMode">Determines if colors will be interpolated
        /// in straight alpha or premultiplied alpha space.</param>
        function CreateGradientStopCollection(
        {_In_reads_(straightAlphaGradientStopsCount) } straightAlphaGradientStops: PD2D1_GRADIENT_STOP;
        {_In_range_(>=,1) } straightAlphaGradientStopsCount: uint32; preInterpolationSpace: TD2D1_COLOR_SPACE; postInterpolationSpace: TD2D1_COLOR_SPACE; bufferPrecision: TD2D1_BUFFER_PRECISION;
            extendMode: TD2D1_EXTEND_MODE; colorInterpolationMode: TD2D1_COLOR_INTERPOLATION_MODE;
        {_COM_Outptr_ }  out gradientStopCollection1: ID2D1GradientStopCollection1): HRESULT; stdcall;

        /// Creates an image brush, the input image can be any type of image, including a
        /// bitmap, effect and a command list.
        function CreateImageBrush(
        {_In_opt_ } image: ID2D1Image;
        {_In_ } imageBrushProperties: PD2D1_IMAGE_BRUSH_PROPERTIES;
        {_In_opt_ } brushProperties: PD2D1_BRUSH_PROPERTIES;
        {_COM_Outptr_ }  out imageBrush: ID2D1ImageBrush): HRESULT; stdcall;

        function CreateBitmapBrush(
        {_In_opt_ } bitmap: ID2D1Bitmap;
        {_In_opt_ } bitmapBrushProperties: PD2D1_BITMAP_BRUSH_PROPERTIES1;
        {_In_opt_ } brushProperties: PD2D1_BRUSH_PROPERTIES;
        {_COM_Outptr_ }  out bitmapBrush: ID2D1BitmapBrush1): HRESULT; stdcall;

        /// Creates a new command list.
        function CreateCommandList(
        {_COM_Outptr_ }  out commandList: ID2D1CommandList): HRESULT; stdcall;

        /// Indicates whether the format is supported by D2D.
        function IsDxgiFormatSupported(format: TDXGI_FORMAT): boolean; stdcall;

        /// Indicates whether the buffer precision is supported by D2D.
        function IsBufferPrecisionSupported(bufferPrecision: TD2D1_BUFFER_PRECISION): boolean; stdcall;

        /// This retrieves the local-space bounds in DIPs of the current image using the
        /// device context DPI.
        function GetImageLocalBounds(
        {_In_ } image: ID2D1Image;
        {_Out_ } localBounds: PD2D1_RECT_F): HRESULT; stdcall;

        /// This retrieves the world-space bounds in DIPs of the current image using the
        /// device context DPI.
        function GetImageWorldBounds(
        {_In_ } image: ID2D1Image;
        {_Out_ } worldBounds: PD2D1_RECT_F): HRESULT; stdcall;

        /// Retrieves the world-space bounds in DIPs of the glyph run using the device
        /// context DPI.
        function GetGlyphRunWorldBounds(baselineOrigin: TD2D1_POINT_2F;
        {_In_ } glyphRun: PDWRITE_GLYPH_RUN; measuringMode: TDWRITE_MEASURING_MODE;
        {_Out_ } bounds: PD2D1_RECT_F): HRESULT; stdcall;

        /// Retrieves the device associated with this device context.
        procedure GetDevice(
        {_Outptr_ }  out device: ID2D1Device); stdcall;

        /// Sets the target for this device context to point to the given image. The image
        /// can be a command list or a bitmap created with the D2D1_BITMAP_OPTIONS_TARGET
        /// flag.
        procedure SetTarget(
        {_In_opt_ } image: ID2D1Image); stdcall;

        /// Gets the target that this device context is currently pointing to.
        procedure GetTarget(
        {_Outptr_result_maybenull_ }  out image: ID2D1Image); stdcall;

        /// Sets tuning parameters for internal rendering inside the device context.
        procedure SetRenderingControls(
        {_In_ } renderingControls: PD2D1_RENDERING_CONTROLS); stdcall;

        /// This retrieves the rendering controls currently selected into the device
        /// context.
        procedure GetRenderingControls(
        {_Out_ } renderingControls: PD2D1_RENDERING_CONTROLS); stdcall;

        /// Changes the primitive blending mode for all of the rendering operations.
        procedure SetPrimitiveBlend(primitiveBlend: TD2D1_PRIMITIVE_BLEND); stdcall;

        /// Returns the primitive blend currently selected into the device context.
        function GetPrimitiveBlend(): TD2D1_PRIMITIVE_BLEND; stdcall;

        /// Changes the units used for all of the rendering operations.
        procedure SetUnitMode(unitMode: TD2D1_UNIT_MODE); stdcall;

        /// Returns the unit mode currently set on the device context.
        function GetUnitMode(): TD2D1_UNIT_MODE; stdcall;

        /// Draws the glyph run with an extended description to describe the glyphs.
        procedure DrawGlyphRun(baselineOrigin: TD2D1_POINT_2F;
        {_In_ } glyphRun: PDWRITE_GLYPH_RUN;
        {_In_opt_ } glyphRunDescription: PDWRITE_GLYPH_RUN_DESCRIPTION;
        {_In_ } foregroundBrush: ID2D1Brush; measuringMode: TDWRITE_MEASURING_MODE = DWRITE_MEASURING_MODE_NATURAL); stdcall;

        /// Draw an image to the device context. The image represents either a concrete
        /// bitmap or the output of an effect graph.
        procedure DrawImage(
        {_In_ } image: ID2D1Image;
        {_In_opt_ } targetOffset: PD2D1_POINT_2F = nil;
        {_In_opt_ } imageRectangle: PD2D1_RECT_F = nil; interpolationMode: TD2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR; compositeMode: TD2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER); stdcall;

        /// Draw a metafile to the device context.
        procedure DrawGdiMetafile(
        {_In_ } gdiMetafile: ID2D1GdiMetafile;
        {_In_opt_ } targetOffset: PD2D1_POINT_2F = nil); stdcall;

        procedure DrawBitmap(
        {_In_ } bitmap: ID2D1Bitmap;
        {_In_opt_ } destinationRectangle: PD2D1_RECT_F; opacity: single; interpolationMode: TD2D1_INTERPOLATION_MODE;
        {_In_opt_ } sourceRectangle: PD2D1_RECT_F = nil;
        {_In_opt_ } perspectiveTransform: PD2D1_MATRIX_4X4_F = nil); stdcall;

        /// Push a layer on the device context.
        procedure PushLayer(
        {_In_ } layerParameters: PD2D1_LAYER_PARAMETERS1;
        {_In_opt_ } layer: ID2D1Layer); stdcall;

        /// This indicates that a portion of an effect's input is invalid. This method can
        /// be called many times.
        function InvalidateEffectInputRectangle(
        {_In_ } effect: ID2D1Effect; input: uint32;
        {_In_ } inputRectangle: PD2D1_RECT_F): HRESULT; stdcall;

        /// Gets the number of invalid ouptut rectangles that have accumulated at the
        /// effect.
        function GetEffectInvalidRectangleCount(
        {_In_ } effect: ID2D1Effect;
        {_Out_ } rectangleCount: PUINT32): HRESULT; stdcall;

        /// Gets the invalid rectangles that are at the output of the effect.
        function GetEffectInvalidRectangles(
        {_In_ } effect: ID2D1Effect;
        {_Out_writes_(rectanglesCount) } rectangles: PD2D1_RECT_F; rectanglesCount: uint32): HRESULT; stdcall;

        /// Gets the maximum region of each specified input which would be used during a
        /// subsequent rendering operation
        function GetEffectRequiredInputRectangles(
        {_In_ } renderEffect: ID2D1Effect;
        {_In_opt_ } renderImageRectangle: PD2D1_RECT_F;
        {_In_reads_(inputCount) } inputDescriptions: PD2D1_EFFECT_INPUT_DESCRIPTION;
        {_Out_writes_(inputCount) } requiredInputRects: PD2D1_RECT_F; inputCount: uint32): HRESULT; stdcall;

        /// Fill using the alpha channel of the supplied opacity mask bitmap. The brush
        /// opacity will be modulated by the mask. The render target antialiasing mode must
        /// be set to aliased.
        procedure FillOpacityMask(
        {_In_ } opacityMask: ID2D1Bitmap;
        {_In_ } brush: ID2D1Brush;
        {_In_opt_ } destinationRectangle: PD2D1_RECT_F = nil;
        {_In_opt_ } sourceRectangle: PD2D1_RECT_F = nil); stdcall;

    end;

    ID2D1DeviceContextHelper = type helper for ID2D1DeviceContext
        function CreateBitmap(size: TD2D1_SIZE_U;
        {_In_opt_ } sourceData: Pvoid; pitch: uint32; bitmapProperties: TD2D1_BITMAP_PROPERTIES1;
        {_COM_Outptr_ }  out bitmap: ID2D1Bitmap1): HRESULT; overload;

        /// Create a D2D bitmap by copying a WIC bitmap.
        function CreateBitmapFromWicBitmap(
        {_In_ } wicBitmapSource: IWICBitmapSource; bitmapProperties: TD2D1_BITMAP_PROPERTIES1;
        {_COM_Outptr_ }  out bitmap: ID2D1Bitmap1): HRESULT; overload;

        /// Create a D2D bitmap by copying a WIC bitmap.
        function CreateBitmapFromWicBitmap(
        {_In_ } wicBitmapSource: IWICBitmapSource;
        {_COM_Outptr_ }  out bitmap: ID2D1Bitmap1): HRESULT; overload;

        function CreateBitmapFromDxgiSurface(
        {_In_ } surface: IDXGISurface; bitmapProperties: TD2D1_BITMAP_PROPERTIES1;
        {_COM_Outptr_ }  out bitmap: ID2D1Bitmap1): HRESULT; overload;

        function CreateImageBrush(
        {_In_opt_ } image: ID2D1Image; imageBrushProperties: TD2D1_IMAGE_BRUSH_PROPERTIES; brushProperties: TD2D1_BRUSH_PROPERTIES;
        {_COM_Outptr_ }  out imageBrush: ID2D1ImageBrush): HRESULT; overload;

        function CreateImageBrush(
        {_In_opt_ } image: ID2D1Image; imageBrushProperties: TD2D1_IMAGE_BRUSH_PROPERTIES;
        {_COM_Outptr_ }  out imageBrush: ID2D1ImageBrush): HRESULT; overload;

        function CreateBitmapBrush(
        {_In_opt_ } bitmap: ID2D1Bitmap;
        {_COM_Outptr_ }  out bitmapBrush: ID2D1BitmapBrush1): HRESULT; overload;

        function CreateBitmapBrush(
        {_In_opt_ } bitmap: ID2D1Bitmap; bitmapBrushProperties: TD2D1_BITMAP_BRUSH_PROPERTIES1;
        {_COM_Outptr_ }  out bitmapBrush: ID2D1BitmapBrush1): HRESULT; overload;

        function CreateBitmapBrush(
        {_In_opt_ } bitmap: ID2D1Bitmap; bitmapBrushProperties: TD2D1_BITMAP_BRUSH_PROPERTIES1; brushProperties: TD2D1_BRUSH_PROPERTIES;
        {_COM_Outptr_ }  out bitmapBrush: ID2D1BitmapBrush1): HRESULT; overload;

        /// Draws the output of the effect as an image.
        procedure DrawImage(
        {_In_ } effect: ID2D1Effect;
        {_In_opt_ } targetOffset: PD2D1_POINT_2F = nil;
        {_In_opt_ } imageRectangle: PD2D1_RECT_F = nil; interpolationMode: TD2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR; compositeMode: TD2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER); overload;

        procedure DrawImage(
        {_In_ } image: ID2D1Image; interpolationMode: TD2D1_INTERPOLATION_MODE; compositeMode: TD2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER); overload;

        procedure DrawImage(
        {_In_ } effect: ID2D1Effect; interpolationMode: TD2D1_INTERPOLATION_MODE; compositeMode: TD2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER); overload;

        procedure DrawImage(
        {_In_ } image: ID2D1Image; targetOffset: TD2D1_POINT_2F; interpolationMode: TD2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR; compositeMode: TD2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER); overload;

        procedure DrawImage(
        {_In_ } effect: ID2D1Effect; targetOffset: TD2D1_POINT_2F; interpolationMode: TD2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR; compositeMode: TD2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER); overload;

        procedure DrawImage(
        {_In_ } image: ID2D1Image; targetOffset: TD2D1_POINT_2F; imageRectangle: TD2D1_RECT_F; interpolationMode: TD2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR;
            compositeMode: TD2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER); overload;

        procedure DrawImage(
        {_In_ } effect: ID2D1Effect; targetOffset: TD2D1_POINT_2F; imageRectangle: TD2D1_RECT_F; interpolationMode: TD2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR;
            compositeMode: TD2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER); overload;

        procedure PushLayer(layerParameters: TD2D1_LAYER_PARAMETERS1;
        {_In_opt_ } layer: ID2D1Layer); overload;

        procedure DrawGdiMetafile(
        {_In_ } gdiMetafile: ID2D1GdiMetafile; targetOffset: TD2D1_POINT_2F); overload;

        procedure DrawBitmap(
        {_In_ } bitmap: ID2D1Bitmap; destinationRectangle: TD2D1_RECT_F; opacity: single; interpolationMode: TD2D1_INTERPOLATION_MODE;
        {_In_opt_ } sourceRectangle: PD2D1_RECT_F = nil;
        {_In_opt_ } perspectiveTransform: PD2D1_MATRIX_4X4_F = nil); overload;

        procedure DrawBitmap(
        {_In_ } bitmap: ID2D1Bitmap; destinationRectangle: TD2D1_RECT_F; opacity: single; interpolationMode: TD2D1_INTERPOLATION_MODE; sourceRectangle: TD2D1_RECT_F;
        {_In_opt_ } perspectiveTransform: PD2D1_MATRIX_4X4_F = nil); overload;

        procedure DrawBitmap(
        {_In_ } bitmap: ID2D1Bitmap; destinationRectangle: TD2D1_RECT_F; opacity: single; interpolationMode: TD2D1_INTERPOLATION_MODE; sourceRectangle: TD2D1_RECT_F; perspectiveTransform: TD2D1_MATRIX_4X4_F); overload;

        procedure FillOpacityMask(
        {_In_ } opacityMask: ID2D1Bitmap;
        {_In_ } brush: ID2D1Brush; destinationRectangle: TD2D1_RECT_F;
        {_In_opt_ } sourceRectangle: PD2D1_RECT_F = nil); overload;

        procedure FillOpacityMask(
        {_In_ } opacityMask: ID2D1Bitmap;
        {_In_ } brush: ID2D1Brush; destinationRectangle: TD2D1_RECT_F; sourceRectangle: TD2D1_RECT_F); overload;

        /// Sets tuning parameters for internal rendering inside the device context.
        procedure SetRenderingControls(renderingControls: TD2D1_RENDERING_CONTROLS); overload;

    end;


    /// The device defines a resource domain whose objects and device contexts can be
    /// used together.
    ID2D1Device = interface(ID2D1Resource)
        ['{47dd575d-ac05-4cdd-8049-9b02cd16f44c}']
        /// Creates a new device context with no initially assigned target.
        function CreateDeviceContext(options: TD2D1_DEVICE_CONTEXT_OPTIONS;
        {_COM_Outptr_ }  out deviceContext: ID2D1DeviceContext): HRESULT; stdcall;

        /// Creates a D2D print control.
        function CreatePrintControl(
        {_In_ } wicFactory: IWICImagingFactory;
        {_In_ } documentTarget: IPrintDocumentPackageTarget;
        {_In_opt_ } printControlProperties: PD2D1_PRINT_CONTROL_PROPERTIES;
        {_COM_Outptr_ }  out printControl: ID2D1PrintControl): HRESULT; stdcall;

        /// Sets the maximum amount of texture memory to maintain before evicting caches.
        procedure SetMaximumTextureMemory(maximumInBytes: uint64); stdcall;

        /// Gets the maximum amount of texture memory to maintain before evicting caches.
        function GetMaximumTextureMemory(): uint64; stdcall;

        /// Clears all resources that are cached but not held in use by the application
        /// through an interface reference.
        procedure ClearResources(millisecondsSinceUse: uint32 = 0); stdcall;

    end;

    ID2D1DeviceHelper = type helper for ID2D1Device
        function CreatePrintControl(
        {_In_ } wicFactory: IWICImagingFactory;
        {_In_ } documentTarget: IPrintDocumentPackageTarget; printControlProperties: TD2D1_PRINT_CONTROL_PROPERTIES;
        {_COM_Outptr_ }  out printControl: ID2D1PrintControl): HRESULT; overload;

    end;


    PD2D1_PROPERTY_BINDING = ^TD2D1_PROPERTY_BINDING;

    /// Creates Direct2D resources.
    ID2D1Factory1 = interface(ID2D1Factory)
        ['{bb12d362-daee-4b9a-aa1d-14ba401cfa1f}']
        /// This creates a new Direct2D device from the given IDXGIDevice.
        function CreateDevice(
        {_In_ } dxgiDevice: IDXGIDevice;
        {_COM_Outptr_ }  out d2dDevice: ID2D1Device): HRESULT; stdcall;

        /// This creates a stroke style with the ability to preserve stroke width in various
        /// ways.
        function CreateStrokeStyle(
        {_In_ } strokeStyleProperties: PD2D1_STROKE_STYLE_PROPERTIES1;
        {_In_reads_opt_(dashesCount) } dashes: Psingle; dashesCount: uint32;
        {_COM_Outptr_ }  out strokeStyle: ID2D1StrokeStyle1): HRESULT; stdcall;

        /// Creates a path geometry with new operational methods.
        function CreatePathGeometry(
        {_COM_Outptr_ }  out pathGeometry: ID2D1PathGeometry1): HRESULT; stdcall;

        /// Creates a new drawing state block, this can be used in subsequent
        /// SaveDrawingState and RestoreDrawingState operations on the render target.
        function CreateDrawingStateBlock(
        {_In_opt_ } drawingStateDescription: PD2D1_DRAWING_STATE_DESCRIPTION1;
        {_In_opt_ } textRenderingParams: IDWriteRenderingParams;
        {_COM_Outptr_ }  out drawingStateBlock: ID2D1DrawingStateBlock1): HRESULT; stdcall;

        /// Creates a new GDI metafile.
        function CreateGdiMetafile(
        {_In_ } metafileStream: IStream;
        {_COM_Outptr_ }  out metafile: ID2D1GdiMetafile): HRESULT; stdcall;

        /// This globally registers the given effect. The effect can later be instantiated
        /// by using the registered class id. The effect registration is reference counted.
        function RegisterEffectFromStream(
        {_In_ } classId: REFCLSID;
        {_In_ } propertyXml: IStream;
        {_In_reads_opt_(bindingsCount) } bindings: PD2D1_PROPERTY_BINDING; bindingsCount: uint32;
        {_In_ } effectFactory: PD2D1_EFFECT_FACTORY): HRESULT; stdcall;

        /// This globally registers the given effect. The effect can later be instantiated
        /// by using the registered class id. The effect registration is reference counted.
        function RegisterEffectFromString(
        {_In_ } classId: REFCLSID;
        {_In_ } propertyXml: PCWSTR;
        {_In_reads_opt_(bindingsCount) } bindings: PD2D1_PROPERTY_BINDING; bindingsCount: uint32;
        {_In_ } effectFactory: PD2D1_EFFECT_FACTORY): HRESULT; stdcall;

        /// This unregisters the given effect by its class id, you need to call
        /// UnregisterEffect for every call to ID2D1Factory1::RegisterEffectFromStream and
        /// ID2D1Factory1::RegisterEffectFromString to completely unregister it.
        function UnregisterEffect(
        {_In_ } classId: REFCLSID): HRESULT; stdcall;

        /// This returns all of the registered effects in the process, including any
        /// built-in effects.
        /// <param name="effectsReturned">The number of effects returned into the passed in
        /// effects array.</param>
        /// <param name="effectsRegistered">The number of effects currently registered in
        /// the system.</param>
        function GetRegisteredEffects(
        {_Out_writes_to_opt_(effectsCount, *effectsReturned) } effects: PCLSID; effectsCount: uint32;
        {_Out_opt_ } effectsReturned: PUINT32;
        {_Out_opt_ } effectsRegistered: PUINT32): HRESULT; stdcall;

        /// This retrieves the effect properties for the given effect, all of the effect
        /// properties will be set to a default value since an effect is not instantiated to
        /// implement the returned property interface.
        function GetEffectProperties(
        {_In_ } effectId: REFCLSID;
        {_COM_Outptr_ }  out properties: ID2D1Properties): HRESULT; stdcall;

    end;

    ID2D1Factory1Helper = type helper for ID2D1Factory1
        function CreateStrokeStyle(strokeStyleProperties: TD2D1_STROKE_STYLE_PROPERTIES1;
        {_In_reads_opt_(dashesCount) } dashes: Psingle; dashesCount: uint32;
        {_COM_Outptr_ }  out strokeStyle: ID2D1StrokeStyle1): HRESULT; overload;

        function CreateDrawingStateBlock(drawingStateDescription: TD2D1_DRAWING_STATE_DESCRIPTION1;
        {_COM_Outptr_ }  out drawingStateBlock: ID2D1DrawingStateBlock1): HRESULT; overload;

        function CreateDrawingStateBlock(
        {_COM_Outptr_ }  out drawingStateBlock: ID2D1DrawingStateBlock1): HRESULT; overload;

    end;

    /// A locking mechanism from a Direct2D factory that Direct2D uses to control
    /// exclusive resource access in an app that is uses multiple threads.
    ID2D1Multithread = interface(IUnknown)
        ['{31e6e7bc-e0ff-4d46-8c64-a0a8c41c15d3}']
        /// Returns whether the D2D factory was created with
        /// D2D1_FACTORY_TYPE_MULTI_THREADED.
        function GetMultithreadProtected(): boolean; stdcall;

        /// Enters the D2D API critical section, if it exists.
        procedure Enter(); stdcall;

        /// Leaves the D2D API critical section, if it exists.
        procedure Leave(); stdcall;

    end;


    //  D2D1EffectAuthor

    /// Function pointer that sets a property on an effect.
    PD2D1_PROPERTY_SET_FUNCTION = function(
        {_In_ } effect: IUnknown;
        {_In_reads_(dataSize) } Data: pbyte; dataSize: uint32): HRESULT; stdcall;


    /// Function pointer that gets a property from an effect.
    PD2D1_PROPERTY_GET_FUNCTION = function(
        {_In_ } effect: IUnknown;
        {_Out_writes_opt_(dataSize) } Data: pbyte; dataSize: uint32;
        {_Out_opt_ } actualSize: PUINT32): HRESULT; stdcall;


    ID2D1EffectContext = interface;
    ID2D1TransformNode = interface;


    /// Indicates what has changed since the last time the effect was asked to prepare
    /// to render.
    TD2D1_CHANGE_TYPE = (
        /// Nothing has changed.
        D2D1_CHANGE_TYPE_NONE = 0,
        /// The effect's properties have changed.
        D2D1_CHANGE_TYPE_PROPERTIES = 1,
        /// The internal context has changed and should be inspected.
        D2D1_CHANGE_TYPE_CONTEXT = 2,
        /// A new graph has been set due to a change in the input count.
        D2D1_CHANGE_TYPE_GRAPH = 3,
        D2D1_CHANGE_TYPE_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_CHANGE_TYPE = ^TD2D1_CHANGE_TYPE;

    /// Indicates options for drawing using a pixel shader.
    TD2D1_PIXEL_OPTIONS = (
        /// Default pixel processing.
        D2D1_PIXEL_OPTIONS_NONE = 0,
        /// Indicates that the shader samples its inputs only at exactly the same scene
        /// coordinate as the output pixel, and that it returns transparent black whenever
        /// the input pixels are also transparent black.
        D2D1_PIXEL_OPTIONS_TRIVIAL_SAMPLING = 1,
        D2D1_PIXEL_OPTIONS_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_PIXEL_OPTIONS = ^TD2D1_PIXEL_OPTIONS;

    /// Indicates options for drawing custom vertices set by transforms.
    TD2D1_VERTEX_OPTIONS = (
        /// Default vertex processing.
        D2D1_VERTEX_OPTIONS_NONE = 0,
        /// Indicates that the output rectangle does not need to be cleared before drawing
        /// custom vertices. This must only be used by transforms whose custom vertices
        /// completely cover their output rectangle.
        D2D1_VERTEX_OPTIONS_DO_NOT_CLEAR = 1,
        /// Causes a depth buffer to be used while drawing custom vertices. This impacts
        /// drawing behavior when primitives overlap one another.
        D2D1_VERTEX_OPTIONS_USE_DEPTH_BUFFER = 2,
        /// Indicates that custom vertices do not form primitives which overlap one another.
        D2D1_VERTEX_OPTIONS_ASSUME_NO_OVERLAP = 4,
        D2D1_VERTEX_OPTIONS_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_VERTEX_OPTIONS = ^TD2D1_VERTEX_OPTIONS;

    /// Describes how a vertex buffer is to be managed.
    TD2D1_VERTEX_USAGE = (
        /// The vertex buffer content do not change frequently from frame to frame.
        D2D1_VERTEX_USAGE_STATIC = 0,
        /// The vertex buffer is intended to be updated frequently.
        D2D1_VERTEX_USAGE_DYNAMIC = 1,
        D2D1_VERTEX_USAGE_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_VERTEX_USAGE = ^TD2D1_VERTEX_USAGE;

    /// Describes a particular blend in the D2D1_BLEND_DESCRIPTION structure.
    TD2D1_BLEND_OPERATION = (
        D2D1_BLEND_OPERATION_ADD = 1,
        D2D1_BLEND_OPERATION_SUBTRACT = 2,
        D2D1_BLEND_OPERATION_REV_SUBTRACT = 3,
        D2D1_BLEND_OPERATION_MIN = 4,
        D2D1_BLEND_OPERATION_MAX = 5,
        D2D1_BLEND_OPERATION_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_BLEND_OPERATION = ^TD2D1_BLEND_OPERATION;

    /// Describes a particular blend in the D2D1_BLEND_DESCRIPTION structure.
    TD2D1_BLEND = (
        D2D1_BLEND_ZERO = 1,
        D2D1_BLEND_ONE = 2,
        D2D1_BLEND_SRC_COLOR = 3,
        D2D1_BLEND_INV_SRC_COLOR = 4,
        D2D1_BLEND_SRC_ALPHA = 5,
        D2D1_BLEND_INV_SRC_ALPHA = 6,
        D2D1_BLEND_DEST_ALPHA = 7,
        D2D1_BLEND_INV_DEST_ALPHA = 8,
        D2D1_BLEND_DEST_COLOR = 9,
        D2D1_BLEND_INV_DEST_COLOR = 10,
        D2D1_BLEND_SRC_ALPHA_SAT = 11,
        D2D1_BLEND_BLEND_FACTOR = 14,
        D2D1_BLEND_INV_BLEND_FACTOR = 15,
        D2D1_BLEND_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_BLEND = ^TD2D1_BLEND;

    /// Allows a caller to control the channel depth of a stage in the rendering
    /// pipeline.
    TD2D1_CHANNEL_DEPTH = (
        D2D1_CHANNEL_DEPTH_DEFAULT = 0,
        D2D1_CHANNEL_DEPTH_1 = 1,
        D2D1_CHANNEL_DEPTH_4 = 4,
        D2D1_CHANNEL_DEPTH_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_CHANNEL_DEPTH = ^TD2D1_CHANNEL_DEPTH;

    /// Represents filtering modes transforms may select to use on their input textures.
    TD2D1_FILTER = (
        D2D1_FILTER_MIN_MAG_MIP_POINT = $00,
        D2D1_FILTER_MIN_MAG_POINT_MIP_LINEAR = $01,
        D2D1_FILTER_MIN_POINT_MAG_LINEAR_MIP_POINT = $04,
        D2D1_FILTER_MIN_POINT_MAG_MIP_LINEAR = $05,
        D2D1_FILTER_MIN_LINEAR_MAG_MIP_POINT = $10,
        D2D1_FILTER_MIN_LINEAR_MAG_POINT_MIP_LINEAR = $11,
        D2D1_FILTER_MIN_MAG_LINEAR_MIP_POINT = $14,
        D2D1_FILTER_MIN_MAG_MIP_LINEAR = $15,
        D2D1_FILTER_ANISOTROPIC = $55,
        D2D1_FILTER_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_FILTER = ^TD2D1_FILTER;

    /// Defines capabilities of the underlying D3D device which may be queried using
    /// CheckFeatureSupport.
    TD2D1_FEATURE = (
        D2D1_FEATURE_DOUBLES = 0,
        D2D1_FEATURE_D3D10_X_HARDWARE_OPTIONS = 1,
        D2D1_FEATURE_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_FEATURE = ^TD2D1_FEATURE;

    /// Defines a property binding to a function. The name must match the property
    /// defined in the registration schema.
    TD2D1_PROPERTY_BINDING = record
        /// The name of the property.
        propertyName: PCWSTR;
        /// The function that will receive the data to set.
        setFunction: PD2D1_PROPERTY_SET_FUNCTION;
        /// The function that will be asked to write the output data.
        getFunction: PD2D1_PROPERTY_GET_FUNCTION;
    end;


    /// This is used to define a resource texture when that resource texture is created.
    TD2D1_RESOURCE_TEXTURE_PROPERTIES = record
        {_Field_size_(dimensions) } extents: PUINT32;
        dimensions: uint32;
        bufferPrecision: TD2D1_BUFFER_PRECISION;
        channelDepth: TD2D1_CHANNEL_DEPTH;
        filter: TD2D1_FILTER;
        {_Field_size_(dimensions) } extendModes: PD2D1_EXTEND_MODE;
    end;
    PD2D1_RESOURCE_TEXTURE_PROPERTIES = ^TD2D1_RESOURCE_TEXTURE_PROPERTIES;

    /// This defines a single element of the vertex layout.
    TD2D1_INPUT_ELEMENT_DESC = record
        semanticName: PCSTR;
        semanticIndex: uint32;
        format: TDXGI_FORMAT;
        inputSlot: uint32;
        alignedByteOffset: uint32;
    end;
    PD2D1_INPUT_ELEMENT_DESC = ^TD2D1_INPUT_ELEMENT_DESC;

    /// This defines the properties of a vertex buffer which uses the default vertex
    /// layout.
    TD2D1_VERTEX_BUFFER_PROPERTIES = record
        inputCount: uint32;
        usage: TD2D1_VERTEX_USAGE;
        {_Field_size_opt_(byteWidth) } Data: pbyte;
        byteWidth: uint32;
    end;
    PD2D1_VERTEX_BUFFER_PROPERTIES = ^TD2D1_VERTEX_BUFFER_PROPERTIES;

    /// This defines the input layout of vertices and the vertex shader which processes
    /// them.
    TD2D1_CUSTOM_VERTEX_BUFFER_PROPERTIES = record
        {_Field_size_(shaderBufferSize) } shaderBufferWithInputSignature: pbyte;
        shaderBufferSize: uint32;
        {_Field_size_opt_(elementCount) } inputElements: PD2D1_INPUT_ELEMENT_DESC;
        elementCount: uint32;
        stride: uint32;
    end;
    PD2D1_CUSTOM_VERTEX_BUFFER_PROPERTIES = ^TD2D1_CUSTOM_VERTEX_BUFFER_PROPERTIES;

    /// This defines the range of vertices from a vertex buffer to draw.
    TD2D1_VERTEX_RANGE = record
        startVertex: uint32;
        vertexCount: uint32;
    end;
    PD2D1_VERTEX_RANGE = ^TD2D1_VERTEX_RANGE;

    /// Blend description which configures a blend transform object.
    TD2D1_BLEND_DESCRIPTION = record
        sourceBlend: TD2D1_BLEND;
        destinationBlend: TD2D1_BLEND;
        blendOperation: TD2D1_BLEND_OPERATION;
        sourceBlendAlpha: TD2D1_BLEND;
        destinationBlendAlpha: TD2D1_BLEND;
        blendOperationAlpha: TD2D1_BLEND_OPERATION;
        blendFactor: array [0..3] of single;
    end;
    PD2D1_BLEND_DESCRIPTION = ^TD2D1_BLEND_DESCRIPTION;

    /// Describes options transforms may select to use on their input textures.
    TD2D1_INPUT_DESCRIPTION = record
        filter: TD2D1_FILTER;
        levelOfDetailCount: uint32;
    end;
    PD2D1_INPUT_DESCRIPTION = ^TD2D1_INPUT_DESCRIPTION;

    /// Indicates whether shader support for doubles is present on the underlying
    /// hardware.  This may be populated using CheckFeatureSupport.
    TD2D1_FEATURE_DATA_DOUBLES = record
        doublePrecisionFloatShaderOps: boolean;
    end;
    PD2D1_FEATURE_DATA_DOUBLES = ^TD2D1_FEATURE_DATA_DOUBLES;

    /// Indicates support for features which are optional on D3D10 feature levels.  This
    /// may be populated using CheckFeatureSupport.
    TD2D1_FEATURE_DATA_D3D10_X_HARDWARE_OPTIONS = record
        computeShaders_Plus_RawAndStructuredBuffers_Via_Shader_4_x: boolean;
    end;
    PD2D1_FEATURE_DATA_D3D10_X_HARDWARE_OPTIONS = ^TD2D1_FEATURE_DATA_D3D10_X_HARDWARE_OPTIONS;


    /// A transform uses this interface to write new vertices to a vertex buffer.
    ID2D1VertexBuffer = interface(IUnknown)
        ['{9b8b1336-00a5-4668-92b7-ced5d8bf9b7b}']
        function Map(
        {_Outptr_result_bytebuffer_(bufferSize) }  out Data: pbyte; bufferSize: uint32): HRESULT; stdcall;

        function Unmap(): HRESULT; stdcall;

    end;

    ID2D1ResourceTexture = interface(IUnknown)
        ['{688d15c3-02b0-438d-b13a-d1b44c32c39a}']
        /// Update the vertex text.
        function Update(
        {_In_reads_opt_(dimensions) } minimumExtents: PUINT32;
        {_In_reads_opt_(dimensions) } maximimumExtents: PUINT32;
        {_In_reads_opt_(dimensions - 1) } strides: PUINT32; dimensions: uint32;
        {_In_reads_(dataCount) } Data: pbyte; dataCount: uint32): HRESULT; stdcall;

    end;

    /// A transform uses this interface to specify how to render a particular pass in
    /// D2D.
    ID2D1RenderInfo = interface(IUnknown)
        ['{519ae1bd-d19a-420d-b849-364f594776b7}']
        /// Sets options for sampling the specified image input
        function SetInputDescription(inputIndex: uint32; inputDescription: TD2D1_INPUT_DESCRIPTION): HRESULT; stdcall;

        /// Controls the output precision and channel-depth for the associated transform.
        function SetOutputBuffer(bufferPrecision: TD2D1_BUFFER_PRECISION; channelDepth: TD2D1_CHANNEL_DEPTH): HRESULT; stdcall;

        /// Controls whether the output of the associated transform is cached.
        procedure SetCached(isCached: boolean); stdcall;

        /// Provides a hint of the approximate shader instruction count per pixel.  If
        /// provided, it may improve performance when processing large images.  Instructions
        /// should be counted multiple times if occurring within loops.
        procedure SetInstructionCountHint(instructionCount: uint32); stdcall;

    end;

    /// A transform uses this interface to specify how to render a particular pass using
    /// pixel and vertex shaders.
    ID2D1DrawInfo = interface(ID2D1RenderInfo)
        ['{693ce632-7f2f-45de-93fe-18d88b37aa21}']
        /// Set the constant buffer for this transform's pixel shader.
        function SetPixelShaderConstantBuffer(
        {_In_reads_(bufferCount) } buffer: pbyte; bufferCount: uint32): HRESULT; stdcall;

        /// Sets the resource texture corresponding to the given shader texture index.
        function SetResourceTexture(textureIndex: uint32;
        {_In_ } resourceTexture: ID2D1ResourceTexture): HRESULT; stdcall;

        /// Set the constant buffer for this transform's vertex shader.
        function SetVertexShaderConstantBuffer(
        {_In_reads_(bufferCount) } buffer: pbyte; bufferCount: uint32): HRESULT; stdcall;

        /// Set the shader instructions for this transform.
        function SetPixelShader(
        {_In_ } shaderId: REFGUID; pixelOptions: TD2D1_PIXEL_OPTIONS = D2D1_PIXEL_OPTIONS_NONE): HRESULT; stdcall;

        /// Set custom vertices for the associated transform.  A blend mode if
        /// foreground-over will be used if blendDescription is NULL.
        function SetVertexProcessing(
        {_In_opt_ } vertexBuffer: ID2D1VertexBuffer; vertexOptions: TD2D1_VERTEX_OPTIONS;
        {_In_opt_ } blendDescription: PD2D1_BLEND_DESCRIPTION = nil;
        {_In_opt_ } vertexRange: PD2D1_VERTEX_RANGE = nil;
        {_In_opt_ } vertexShader: PGUID = nil): HRESULT; stdcall;

    end;

    /// A transform uses this interface to specify how to render a particular pass using
    /// compute shader.
    ID2D1ComputeInfo = interface(ID2D1RenderInfo)
        ['{5598b14b-9fd7-48b7-9bdb-8f0964eb38bc}']
        /// Set the constant buffer for this transform.
        function SetComputeShaderConstantBuffer(
        {_In_reads_(bufferCount) } buffer: pbyte; bufferCount: uint32): HRESULT; stdcall;

        /// Set the shader instructions for this transform.
        function SetComputeShader(
        {_In_ } shaderId: REFGUID): HRESULT; stdcall;

        /// Sets the resource texture corresponding to the given shader texture index.
        function SetResourceTexture(textureIndex: uint32;
        {_In_ } resourceTexture: ID2D1ResourceTexture): HRESULT; stdcall;

    end;

    /// A base object which can be inserted into a transform graph.
    ID2D1TransformNode = interface(IUnknown)
        ['{b2efe1e7-729f-4102-949f-505fa21bf666}']
        /// Return the number of input this node has.
        function GetInputCount(): uint32; stdcall;

    end;

    /// The implementation of the actual graph.
    ID2D1TransformGraph = interface(IUnknown)
        ['{13d29038-c3e6-4034-9081-13b53a417992}']
        /// Return the number of input this graph has.
        function GetInputCount(): uint32; stdcall;

        /// Sets the graph to contain a single transform whose inputs map 1:1 with effect
        /// inputs.
        function SetSingleTransformNode(
        {_In_ } node: ID2D1TransformNode): HRESULT; stdcall;

        /// Adds the given transform node to the graph.
        function AddNode(
        {_In_ } node: ID2D1TransformNode): HRESULT; stdcall;

        /// Removes the given transform node from the graph.
        function RemoveNode(
        {_In_ } node: ID2D1TransformNode): HRESULT; stdcall;

        /// Indicates that the given transform node should be considered to be the output
        /// node of the graph.
        function SetOutputNode(
        {_In_ } node: ID2D1TransformNode): HRESULT; stdcall;

        /// Connects one node to another node inside the graph.
        function ConnectNode(
        {_In_ } fromNode: ID2D1TransformNode;
        {_In_ } toNode: ID2D1TransformNode; toNodeInputIndex: uint32): HRESULT; stdcall;

        /// Connects a transform node inside the graph to the corresponding input of the
        /// encapsulating effect.
        function ConnectToEffectInput(toEffectInputIndex: uint32;
        {_In_ } node: ID2D1TransformNode; toNodeInputIndex: uint32): HRESULT; stdcall;

        /// Clears all nodes and connections from the transform graph.
        procedure Clear(); stdcall;

        /// Uses the specified input as the effect output.
        function SetPassthroughGraph(effectInputIndex: uint32): HRESULT; stdcall;

    end;

    /// The interface implemented by a transform author.
    ID2D1Transform = interface(ID2D1TransformNode)
        ['{ef1a287d-342a-4f76-8fdb-da0d6ea9f92b}']
        function MapOutputRectToInputRects(
        {_In_ } outputRect: PD2D1_RECT_L;
        {_Out_writes_(inputRectsCount) } inputRects: PD2D1_RECT_L; inputRectsCount: uint32): HRESULT; stdcall;

        function MapInputRectsToOutputRect(
        {_In_reads_(inputRectCount) } inputRects: PD2D1_RECT_L;
        {_In_reads_(inputRectCount) } inputOpaqueSubRects: PD2D1_RECT_L; inputRectCount: uint32;
        {_Out_ } outputRect: PD2D1_RECT_L;
        {_Out_ } outputOpaqueSubRect: PD2D1_RECT_L): HRESULT; stdcall;

        function MapInvalidRect(inputIndex: uint32; invalidInputRect: TD2D1_RECT_L;
        {_Out_ } invalidOutputRect: PD2D1_RECT_L): HRESULT; stdcall;

    end;

    /// The interface implemented by a transform author to provide a GPU-based effect.
    ID2D1DrawTransform = interface(ID2D1Transform)
        ['{36bfdcb6-9739-435d-a30d-a653beff6a6f}']
        function SetDrawInfo(
        {_In_ } drawInfo: ID2D1DrawInfo): HRESULT; stdcall;

    end;

    /// The interface implemented by a transform author to provide a Compute Shader
    /// based effect.
    ID2D1ComputeTransform = interface(ID2D1Transform)
        ['{0d85573c-01e3-4f7d-bfd9-0d60608bf3c3}']
        function SetComputeInfo(
        {_In_ } computeInfo: ID2D1ComputeInfo): HRESULT; stdcall;

        function CalculateThreadgroups(
        {_In_ } outputRect: PD2D1_RECT_L;
        {_Out_ } dimensionX: PUINT32;
        {_Out_ } dimensionY: PUINT32;
        {_Out_ } dimensionZ: PUINT32): HRESULT; stdcall;

    end;

    /// The interface implemented by a transform author to indicate that it should
    /// receive an analysis result callback.
    ID2D1AnalysisTransform = interface(IUnknown)
        ['{0359dc30-95e6-4568-9055-27720d130e93}']
        function ProcessAnalysisResults(
        {_In_reads_(analysisDataCount) } analysisData: pbyte; analysisDataCount: uint32): HRESULT; stdcall;
    end;

    /// The interface implemented by a transform author to provide a CPU based source
    /// effect.
    ID2D1SourceTransform = interface(ID2D1Transform)
        ['{db1800dd-0c34-4cf9-be90-31cc0a5653e1}']
        function SetRenderInfo(
        {_In_ } renderInfo: ID2D1RenderInfo): HRESULT; stdcall;

        function Draw(
        {_In_ } target: ID2D1Bitmap1;
        {_In_ } drawRect: PD2D1_RECT_L; targetOrigin: TD2D1_POINT_2U): HRESULT; stdcall;

    end;

    /// Base interface for built-in transforms on which precision and caching may be
    /// controlled.
    ID2D1ConcreteTransform = interface(ID2D1TransformNode)
        ['{1a799d8a-69f7-4e4c-9fed-437ccc6684cc}']
        /// Controls the output precision and channel-depth for this transform.
        function SetOutputBuffer(bufferPrecision: TD2D1_BUFFER_PRECISION; channelDepth: TD2D1_CHANNEL_DEPTH): HRESULT; stdcall;

        /// Controls whether the output of this transform is cached.
        procedure SetCached(isCached: boolean); stdcall;

    end;

    /// An effect uses this interface to configure a blending operation.
    ID2D1BlendTransform = interface(ID2D1ConcreteTransform)
        ['{63ac0b32-ba44-450f-8806-7f4ca1ff2f1b}']
        procedure SetDescription(
        {_In_ } description: PD2D1_BLEND_DESCRIPTION); stdcall;

        procedure GetDescription(
        {_Out_ } description: PD2D1_BLEND_DESCRIPTION); stdcall;

    end;

    /// An effect uses this interface to configure border generation.
    ID2D1BorderTransform = interface(ID2D1ConcreteTransform)
        ['{4998735c-3a19-473c-9781-656847e3a347}']
        procedure SetExtendModeX(extendMode: TD2D1_EXTEND_MODE); stdcall;

        procedure SetExtendModeY(extendMode: TD2D1_EXTEND_MODE); stdcall;

        function GetExtendModeX(): TD2D1_EXTEND_MODE; stdcall;

        function GetExtendModeY(): TD2D1_EXTEND_MODE; stdcall;

    end;

    /// An effect uses this interface to offset an image without inserting a rendering
    /// pass.
    ID2D1OffsetTransform = interface(ID2D1TransformNode)
        ['{3fe6adea-7643-4f53-bd14-a0ce63f24042}']
        procedure SetOffset(offset: TD2D1_POINT_2L); stdcall;

        function GetOffset(): TD2D1_POINT_2L; stdcall;

    end;

    /// An effect uses this interface to alter the image rectangle of its input.
    ID2D1BoundsAdjustmentTransform = interface(ID2D1TransformNode)
        ['{90f732e2-5092-4606-a819-8651970baccd}']
        procedure SetOutputBounds(
        {_In_ } outputBounds: PD2D1_RECT_L); stdcall;

        procedure GetOutputBounds(
        {_Out_ } outputBounds: PD2D1_RECT_L); stdcall;

    end;

    /// This is the interface implemented by an effect author, along with the
    /// constructor and registration information.
    ID2D1EffectImpl = interface(IUnknown)
        ['{a248fd3f-3e6c-4e63-9f03-7f68ecc91db9}']
        /// Initialize the effect with a context and a transform graph. The effect must
        /// populate the transform graph with a topology and can update it later.
        function Initialize(
        {_In_ } effectContext: ID2D1EffectContext;
        {_In_ } transformGraph: ID2D1TransformGraph): HRESULT; stdcall;

        /// Initialize the effect with a context and a transform graph. The effect must
        /// populate the transform graph with a topology and can update it later.
        function PrepareForRender(changeType: TD2D1_CHANGE_TYPE): HRESULT; stdcall;

        /// Sets a new transform graph to the effect.  This happens when the number of
        /// inputs to the effect changes, if the effect support a variable number of inputs.
        function SetGraph(
        {_In_ } transformGraph: ID2D1TransformGraph): HRESULT; stdcall;

    end;

    /// The internal context handed to effect authors to create transforms from effects
    /// and any other operation tied to context which is not useful to the application
    /// facing API.
    ID2D1EffectContext = interface(IUnknown)
        ['{3d9f916b-27dc-4ad7-b4f1-64945340f563}']
        procedure GetDpi(
        {_Out_ } dpiX: Psingle;
        {_Out_ } dpiY: Psingle); stdcall;

        /// Create a new effect, the effect must either be built in or previously registered
        /// through ID2D1Factory1::RegisterEffect.
        function CreateEffect(
        {_In_ } effectId: REFCLSID;
        {_COM_Outptr_ }  out effect: ID2D1Effect): HRESULT; stdcall;

        function GetMaximumSupportedFeatureLevel(
        {_In_reads_(featureLevelsCount) } featureLevels: PD3D_FEATURE_LEVEL; featureLevelsCount: uint32;
        {_Out_ } maximumSupportedFeatureLevel: PD3D_FEATURE_LEVEL): HRESULT; stdcall;

        /// Create a transform node from the passed in effect.
        function CreateTransformNodeFromEffect(
        {_In_ } effect: ID2D1Effect;
        {_COM_Outptr_ }  out transformNode: ID2D1TransformNode): HRESULT; stdcall;

        function CreateBlendTransform(numInputs: uint32;
        {_In_ } blendDescription: PD2D1_BLEND_DESCRIPTION;
        {_COM_Outptr_ }  out transform: ID2D1BlendTransform): HRESULT; stdcall;

        function CreateBorderTransform(extendModeX: TD2D1_EXTEND_MODE; extendModeY: TD2D1_EXTEND_MODE;
        {_COM_Outptr_ }  out transform: ID2D1BorderTransform): HRESULT; stdcall;

        function CreateOffsetTransform(offset: TD2D1_POINT_2L;
        {_COM_Outptr_ }  out transform: ID2D1OffsetTransform): HRESULT; stdcall;

        function CreateBoundsAdjustmentTransform(
        {_In_ } outputRectangle: PD2D1_RECT_L;
        {_COM_Outptr_ }  out transform: ID2D1BoundsAdjustmentTransform): HRESULT; stdcall;

        function LoadPixelShader(shaderId: REFGUID;
        {_In_reads_(shaderBufferCount) } shaderBuffer: pbyte; shaderBufferCount: uint32): HRESULT; stdcall;

        function LoadVertexShader(resourceId: REFGUID;
        {_In_reads_(shaderBufferCount) } shaderBuffer: pbyte; shaderBufferCount: uint32): HRESULT; stdcall;

        function LoadComputeShader(resourceId: REFGUID;
        {_In_reads_(shaderBufferCount) } shaderBuffer: pbyte; shaderBufferCount: uint32): HRESULT; stdcall;

        function IsShaderLoaded(shaderId: REFGUID): boolean; stdcall;

        function CreateResourceTexture(
        {_In_opt_ } resourceId: PGUID;
        {_In_ } resourceTextureProperties: PD2D1_RESOURCE_TEXTURE_PROPERTIES;
        {_In_reads_opt_(dataSize) } Data: pbyte;
        {_In_reads_opt_(resourceTextureProperties->dimensions - 1) } strides: PUINT32; dataSize: uint32;
        {_COM_Outptr_ }  out resourceTexture: ID2D1ResourceTexture): HRESULT; stdcall;

        function FindResourceTexture(
        {_In_ } resourceId: PGUID;
        {_COM_Outptr_ }  out resourceTexture: ID2D1ResourceTexture): HRESULT; stdcall;

        function CreateVertexBuffer(
        {_In_ } vertexBufferProperties: PD2D1_VERTEX_BUFFER_PROPERTIES;
        {_In_opt_ } resourceId: PGUID;
        {_In_opt_ } customVertexBufferProperties: PD2D1_CUSTOM_VERTEX_BUFFER_PROPERTIES;
        {_COM_Outptr_ }  out buffer: ID2D1VertexBuffer): HRESULT; stdcall;

        function FindVertexBuffer(
        {_In_ } resourceId: PGUID;
        {_COM_Outptr_ }  out buffer: ID2D1VertexBuffer): HRESULT; stdcall;

        /// Creates a color context from a color space.  If the space is Custom, the context
        /// is initialized from the profile/profileSize arguments.  Otherwise the context is
        /// initialized with the profile bytes associated with the space and
        /// profile/profileSize are ignored.
        function CreateColorContext(space: TD2D1_COLOR_SPACE;
        {_In_reads_opt_(profileSize) } profile: pbyte; profileSize: uint32;
        {_COM_Outptr_ }  out colorContext: ID2D1ColorContext): HRESULT; stdcall;

        function CreateColorContextFromFilename(
        {_In_ } filename: PCWSTR;
        {_COM_Outptr_ }  out colorContext: ID2D1ColorContext): HRESULT; stdcall;

        function CreateColorContextFromWicColorContext(
        {_In_ } wicColorContext: IWICColorContext;
        {_COM_Outptr_ }  out colorContext: ID2D1ColorContext): HRESULT; stdcall;

        function CheckFeatureSupport(feature: TD2D1_FEATURE;
        {_Out_writes_bytes_(featureSupportDataSize) } featureSupportData: Pvoid; featureSupportDataSize: uint32): HRESULT; stdcall;

        /// Indicates whether the buffer precision is supported by D2D.
        function IsBufferPrecisionSupported(bufferPrecision: TD2D1_BUFFER_PRECISION): boolean; stdcall;

    end;


function D2D1CreateDevice(
    {_In_ } dxgiDevice: IDXGIDevice;
    {_In_opt_ } creationProperties: PD2D1_CREATION_PROPERTIES;
    {_Outptr_ }  out d2dDevice: ID2D1Device): HRESULT; stdcall; external D2D1_DLL; overload;


function D2D1CreateDeviceContext(
    {_In_ } dxgiSurface: IDXGISurface;
    {_In_opt_ } creationProperties: PD2D1_CREATION_PROPERTIES;
    {_Outptr_ }  out d2dDeviceContext: ID2D1DeviceContext): HRESULT; stdcall; external D2D1_DLL; overload;


function D2D1ConvertColorSpace(sourceColorSpace: TD2D1_COLOR_SPACE; destinationColorSpace: TD2D1_COLOR_SPACE;
    {_In_ } color: PD2D1_COLOR_F): PD2D1_COLOR_F; stdcall; external D2D1_DLL;


procedure D2D1SinCos(
    {_In_ } angle: single;
    {_Out_ } s: Psingle;
    {_Out_ } c: Psingle); stdcall; external D2D1_DLL;


function D2D1Tan(
    {_In_ } angle: single): single; stdcall; external D2D1_DLL;


function D2D1Vec3Length(
    {_In_ } x: single;
    {_In_ } y: single;
    {_In_ } z: single): single; stdcall; external D2D1_DLL;


function D2D1CreateDevice(
    {_In_ } dxgiDevice: IDXGIDevice;
    {_In_ } creationProperties: TD2D1_CREATION_PROPERTIES;
    {_Outptr_ }  out d2dDevice: ID2D1Device): HRESULT; overload;


function D2D1CreateDeviceContext(
    {_In_ } dxgiSurface: IDXGISurface;
    {_In_ } creationProperties: TD2D1_CREATION_PROPERTIES;
    {_Outptr_ }  out d2dDeviceContext: ID2D1DeviceContext): HRESULT; overload;


implementation



function D2D1CreateDevice(dxgiDevice: IDXGIDevice; creationProperties: TD2D1_CREATION_PROPERTIES; out d2dDevice: ID2D1Device): HRESULT; overload;
begin
    Result :=
        D2D1CreateDevice(dxgiDevice, @creationProperties, d2dDevice);
end;



function D2D1CreateDeviceContext(dxgiSurface: IDXGISurface; creationProperties: TD2D1_CREATION_PROPERTIES; out d2dDeviceContext: ID2D1DeviceContext): HRESULT; overload;
begin
    Result :=
        D2D1CreateDeviceContext(dxgiSurface, @creationProperties, d2dDeviceContext);
end;



function ID2D1PathGeometry1Helper.ComputePointAndSegmentAtLength(length: single; startSegment: uint32; worldTransform: TD2D1_MATRIX_3X2_F; flatteningTolerance: single;
    {_Out_ } pointDescription: PD2D1_POINT_DESCRIPTION): HRESULT;
begin

    Result :=

        ComputePointAndSegmentAtLength(length, startSegment, @worldTransform, flatteningTolerance, pointDescription);

end;



function ID2D1PathGeometry1Helper.ComputePointAndSegmentAtLength(length: single; startSegment: uint32;
    {_In_opt_ } worldTransform: PD2D1_MATRIX_3X2_F;
    {_Out_ } pointDescription: PD2D1_POINT_DESCRIPTION): HRESULT;
begin

    Result :=

        ComputePointAndSegmentAtLength(length, startSegment, worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, pointDescription);

end;



function ID2D1PathGeometry1Helper.ComputePointAndSegmentAtLength(length: single; startSegment: uint32; worldTransform: TD2D1_MATRIX_3X2_F;
    {_Out_ } pointDescription: PD2D1_POINT_DESCRIPTION): HRESULT;
begin

    Result :=

        ComputePointAndSegmentAtLength(length, startSegment, @worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, pointDescription);

end;



function ID2D1PropertiesHelper.SetValueByName(
    {_In_ } Name: PCWSTR;
    {_In_reads_(dataSize) } Data: pbyte; dataSize: uint32): HRESULT;
begin

    Result :=

        SetValueByName(Name, D2D1_PROPERTY_TYPE_UNKNOWN, Data, dataSize);

end;



function ID2D1PropertiesHelper.SetValue(index: uint32;
    {_In_reads_(dataSize) } Data: pbyte; dataSize: uint32): HRESULT;
begin

    Result :=

        SetValue(index, D2D1_PROPERTY_TYPE_UNKNOWN, Data, dataSize);

end;



function ID2D1PropertiesHelper.GetValueByName(
    {_In_ } Name: PCWSTR;
    {_Out_writes_(dataSize) } Data: pbyte; dataSize: uint32): HRESULT;
begin

    Result :=

        GetValueByName(Name, D2D1_PROPERTY_TYPE_UNKNOWN, Data, dataSize);

end;



function ID2D1PropertiesHelper.GetValue(index: uint32;
    {_Out_writes_(dataSize) } Data: pbyte; dataSize: uint32): HRESULT;
begin

    Result :=

        GetValue(index, D2D1_PROPERTY_TYPE_UNKNOWN, Data, dataSize);

end;



function ID2D1PropertiesHelper.GetValueByName<T>(propertyName: PCWSTR; out Value: T): HResult;
begin
    Result := GetValueByName(propertyName, pbyte(Value), sizeof(Value));
end;



function ID2D1PropertiesHelper.GetValueByName<T>(propertyName: PCWSTR): T;
var
    ignoreHr: HRESULT;
    Value: T;
begin
    ignoreHr := GetValueByName(propertyName, pbyte(Value), sizeof(Value));
    Result := Value;
end;



function ID2D1PropertiesHelper.SetValueByName<T>(propertyName: PCWSTR; const Value: T): HResult;
begin
    Result := SetValueByName(propertyName, pbyte(Value), sizeof(Value));
end;



function ID2D1PropertiesHelper.GetValue<U>(index: U; out Data: pbyte; dataSize: uint32): HResult;
begin
    Result := GetValue(uint32(index), Data, dataSize);
end;



function ID2D1PropertiesHelper.GetValue<T, U>(index: U; out Value: T): HResult;
begin
    Result := GetValue(uint32(index), pbyte(Value), sizeof(Value));
end;



function ID2D1PropertiesHelper.GetValue<T, U>(index: U): T;
var
    Value: T;
    ignoreHr: HRESULT;
begin
    ignoreHr := GetValue(uint32(index), pbyte(Value), sizeof(Value));
    Result := Value;
end;



function ID2D1PropertiesHelper.SetValue<U>(Index: U; const Data: pbyte; dataSize: uint32): Hresult;
begin
    Result := SetValue(uint32(index), Data, dataSize);
end;



function ID2D1PropertiesHelper.SetValue<T, U>(index: U; const Value: T): Hresult;
begin
    Result := SetValue(uint32(index), pbyte(Value), sizeof(Value));
end;



function ID2D1PropertiesHelper.GetPropertyName<U>(index: U; out Name: PWSTR; nameCount: uint32): Hresult;
begin
    Result := GetPropertyName(uint32(index), Name, nameCount);
end;



function ID2D1PropertiesHelper.GetPropertyNameLength<U>(index: U): uint32;
begin
    Result := GetPropertyNameLength(uint32(index));
end;



function ID2D1PropertiesHelper.GetType<U>(index: U): TD2D1_PROPERTY_TYPE;
begin
    Result := GetType(uint32(index));
end;



function ID2D1PropertiesHelper.GetValueSize<U>(index: U): uint32;
begin
    Result := GetValueSize(uint32(index));
end;



function ID2D1PropertiesHelper.GetSubProperties<U>(index: U; out subProperties: ID2D1Properties): Hresult;
begin
    Result := GetSubProperties(uint32(index), subProperties);
end;



procedure ID2D1EffectHelper.SetInputEffect(index: uint32;
    {_In_opt_ } inputEffect: ID2D1Effect; invalidate: boolean = True);
var
    output: ID2D1Image;
begin

    if (inputEffect <> nil) then

    begin

        inputEffect.GetOutput(output);

    end;


    SetInput(
        index,

        output,

        invalidate);


    output := nil;

end;



function ID2D1DeviceContextHelper.CreateBitmap(size: TD2D1_SIZE_U;
    {_In_opt_ } sourceData: Pvoid; pitch: uint32; bitmapProperties: TD2D1_BITMAP_PROPERTIES1;
    {_COM_Outptr_ }  out bitmap: ID2D1Bitmap1): HRESULT;
begin

    Result :=

        CreateBitmap(size, sourceData, pitch, @bitmapProperties, bitmap);

end;



function ID2D1DeviceContextHelper.CreateBitmapFromWicBitmap(
    {_In_ } wicBitmapSource: IWICBitmapSource; bitmapProperties: TD2D1_BITMAP_PROPERTIES1;
    {_COM_Outptr_ }  out bitmap: ID2D1Bitmap1): HRESULT;
begin

    Result :=

        CreateBitmapFromWicBitmap(wicBitmapSource, @bitmapProperties, bitmap);

end;



function ID2D1DeviceContextHelper.CreateBitmapFromWicBitmap(
    {_In_ } wicBitmapSource: IWICBitmapSource;
    {_COM_Outptr_ }  out bitmap: ID2D1Bitmap1): HRESULT;
begin

    Result :=

        CreateBitmapFromWicBitmap(wicBitmapSource, nil, bitmap);

end;



function ID2D1DeviceContextHelper.CreateBitmapFromDxgiSurface(
    {_In_ } surface: IDXGISurface; bitmapProperties: TD2D1_BITMAP_PROPERTIES1;
    {_COM_Outptr_ }  out bitmap: ID2D1Bitmap1): HRESULT;
begin

    Result :=

        CreateBitmapFromDxgiSurface(surface, @bitmapProperties, bitmap);

end;



function ID2D1DeviceContextHelper.CreateImageBrush(
    {_In_opt_ } image: ID2D1Image; imageBrushProperties: TD2D1_IMAGE_BRUSH_PROPERTIES; brushProperties: TD2D1_BRUSH_PROPERTIES;
    {_COM_Outptr_ }  out imageBrush: ID2D1ImageBrush): HRESULT;
begin

    Result :=

        CreateImageBrush(image, @imageBrushProperties, @brushProperties, imageBrush);

end;



function ID2D1DeviceContextHelper.CreateImageBrush(
    {_In_opt_ } image: ID2D1Image; imageBrushProperties: TD2D1_IMAGE_BRUSH_PROPERTIES;
    {_COM_Outptr_ }  out imageBrush: ID2D1ImageBrush): HRESULT;
begin

    Result :=

        CreateImageBrush(image, @imageBrushProperties, nil, imageBrush);

end;



function ID2D1DeviceContextHelper.CreateBitmapBrush(
    {_In_opt_ } bitmap: ID2D1Bitmap;
    {_COM_Outptr_ }  out bitmapBrush: ID2D1BitmapBrush1): HRESULT;
begin

    Result :=

        CreateBitmapBrush(bitmap, nil, nil, bitmapBrush);

end;



function ID2D1DeviceContextHelper.CreateBitmapBrush(
    {_In_opt_ } bitmap: ID2D1Bitmap; bitmapBrushProperties: TD2D1_BITMAP_BRUSH_PROPERTIES1;
    {_COM_Outptr_ }  out bitmapBrush: ID2D1BitmapBrush1): HRESULT;
begin

    Result :=

        CreateBitmapBrush(bitmap, @bitmapBrushProperties, nil, bitmapBrush);

end;



function ID2D1DeviceContextHelper.CreateBitmapBrush(
    {_In_opt_ } bitmap: ID2D1Bitmap; bitmapBrushProperties: TD2D1_BITMAP_BRUSH_PROPERTIES1; brushProperties: TD2D1_BRUSH_PROPERTIES;
    {_COM_Outptr_ }  out bitmapBrush: ID2D1BitmapBrush1): HRESULT;
begin

    Result :=

        CreateBitmapBrush(bitmap, @bitmapBrushProperties, @brushProperties, bitmapBrush);

end;



procedure ID2D1DeviceContextHelper.DrawImage(
    {_In_ } effect: ID2D1Effect;
    {_In_opt_ } targetOffset: PD2D1_POINT_2F = nil;
    {_In_opt_ } imageRectangle: PD2D1_RECT_F = nil; interpolationMode: TD2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR; compositeMode: TD2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER);
var
    output: ID2D1Image;
begin

    effect.GetOutput(

        output);


    DrawImage(
        output,

        targetOffset,

        imageRectangle,

        interpolationMode,

        compositeMode);


    output := nil;

end;



procedure ID2D1DeviceContextHelper.DrawImage(
    {_In_ } image: ID2D1Image; interpolationMode: TD2D1_INTERPOLATION_MODE; compositeMode: TD2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER);
begin

    DrawImage(
        image,

        nil,

        nil,

        interpolationMode,

        compositeMode);

end;



procedure ID2D1DeviceContextHelper.DrawImage(
    {_In_ } effect: ID2D1Effect; interpolationMode: TD2D1_INTERPOLATION_MODE; compositeMode: TD2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER);
begin

    DrawImage(
        effect,

        nil,

        nil,

        interpolationMode,

        compositeMode);

end;



procedure ID2D1DeviceContextHelper.DrawImage(
    {_In_ } image: ID2D1Image; targetOffset: TD2D1_POINT_2F; interpolationMode: TD2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR; compositeMode: TD2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER);
begin

    DrawImage(
        image, @targetOffset,

        nil,

        interpolationMode,

        compositeMode);

end;



procedure ID2D1DeviceContextHelper.DrawImage(
    {_In_ } effect: ID2D1Effect; targetOffset: TD2D1_POINT_2F; interpolationMode: TD2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR; compositeMode: TD2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER);
begin

    DrawImage(
        effect, @targetOffset,

        nil,

        interpolationMode,

        compositeMode);

end;



procedure ID2D1DeviceContextHelper.DrawImage(
    {_In_ } image: ID2D1Image; targetOffset: TD2D1_POINT_2F; imageRectangle: TD2D1_RECT_F; interpolationMode: TD2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR; compositeMode: TD2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER);
begin

    DrawImage(
        image, @targetOffset, @imageRectangle,

        interpolationMode,

        compositeMode);

end;



procedure ID2D1DeviceContextHelper.DrawImage(
    {_In_ } effect: ID2D1Effect; targetOffset: TD2D1_POINT_2F; imageRectangle: TD2D1_RECT_F; interpolationMode: TD2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR; compositeMode: TD2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER);
begin

    DrawImage(
        effect, @targetOffset, @imageRectangle,

        interpolationMode,

        compositeMode);

end;



procedure ID2D1DeviceContextHelper.PushLayer(layerParameters: TD2D1_LAYER_PARAMETERS1;
    {_In_opt_ } layer: ID2D1Layer);
begin

    PushLayer(@layerParameters,

        layer);

end;



procedure ID2D1DeviceContextHelper.DrawGdiMetafile(
    {_In_ } gdiMetafile: ID2D1GdiMetafile; targetOffset: TD2D1_POINT_2F);
begin

    DrawGdiMetafile(
        gdiMetafile, @targetOffset);

end;



procedure ID2D1DeviceContextHelper.DrawBitmap(
    {_In_ } bitmap: ID2D1Bitmap; destinationRectangle: TD2D1_RECT_F; opacity: single; interpolationMode: TD2D1_INTERPOLATION_MODE;
    {_In_opt_ } sourceRectangle: PD2D1_RECT_F = nil;
    {_In_opt_ } perspectiveTransform: PD2D1_MATRIX_4X4_F = nil);
begin

    DrawBitmap(
        bitmap, @destinationRectangle,

        opacity,

        interpolationMode,

        sourceRectangle,

        perspectiveTransform);

end;



procedure ID2D1DeviceContextHelper.DrawBitmap(
    {_In_ } bitmap: ID2D1Bitmap; destinationRectangle: TD2D1_RECT_F; opacity: single; interpolationMode: TD2D1_INTERPOLATION_MODE; sourceRectangle: TD2D1_RECT_F;
    {_In_opt_ } perspectiveTransform: PD2D1_MATRIX_4X4_F = nil);
begin

    DrawBitmap(
        bitmap, @destinationRectangle,

        opacity,

        interpolationMode, @sourceRectangle,

        perspectiveTransform);

end;



procedure ID2D1DeviceContextHelper.DrawBitmap(
    {_In_ } bitmap: ID2D1Bitmap; destinationRectangle: TD2D1_RECT_F; opacity: single; interpolationMode: TD2D1_INTERPOLATION_MODE; sourceRectangle: TD2D1_RECT_F; perspectiveTransform: TD2D1_MATRIX_4X4_F);
begin

    DrawBitmap(
        bitmap, @destinationRectangle,

        opacity,

        interpolationMode, @sourceRectangle, @perspectiveTransform);

end;



procedure ID2D1DeviceContextHelper.FillOpacityMask(
    {_In_ } opacityMask: ID2D1Bitmap;
    {_In_ } brush: ID2D1Brush; destinationRectangle: TD2D1_RECT_F;
    {_In_opt_ } sourceRectangle: PD2D1_RECT_F = nil);
begin

    FillOpacityMask(
        opacityMask,

        brush, @destinationRectangle,

        sourceRectangle);

end;



procedure ID2D1DeviceContextHelper.FillOpacityMask(
    {_In_ } opacityMask: ID2D1Bitmap;
    {_In_ } brush: ID2D1Brush; destinationRectangle: TD2D1_RECT_F; sourceRectangle: TD2D1_RECT_F);
begin

    FillOpacityMask(
        opacityMask,

        brush, @destinationRectangle, @sourceRectangle);

end;



procedure ID2D1DeviceContextHelper.SetRenderingControls(renderingControls: TD2D1_RENDERING_CONTROLS);
begin

    SetRenderingControls(@renderingControls);

end;



function ID2D1DeviceHelper.CreatePrintControl(
    {_In_ } wicFactory: IWICImagingFactory;
    {_In_ } documentTarget: IPrintDocumentPackageTarget; printControlProperties: TD2D1_PRINT_CONTROL_PROPERTIES;
    {_COM_Outptr_ }  out printControl: ID2D1PrintControl): HRESULT;
begin

    Result :=

        CreatePrintControl(wicFactory, documentTarget, @printControlProperties, printControl);

end;



function ID2D1Factory1Helper.CreateStrokeStyle(strokeStyleProperties: TD2D1_STROKE_STYLE_PROPERTIES1;
    {_In_reads_opt_(dashesCount) } dashes: Psingle; dashesCount: uint32;
    {_COM_Outptr_ }  out strokeStyle: ID2D1StrokeStyle1): HRESULT;
begin

    Result :=

        CreateStrokeStyle(@strokeStyleProperties, dashes, dashesCount, strokeStyle);

end;



function ID2D1Factory1Helper.CreateDrawingStateBlock(drawingStateDescription: TD2D1_DRAWING_STATE_DESCRIPTION1;
    {_COM_Outptr_ }  out drawingStateBlock: ID2D1DrawingStateBlock1): HRESULT;
begin

    Result :=

        CreateDrawingStateBlock(@drawingStateDescription, nil, drawingStateBlock);

end;



function ID2D1Factory1Helper.CreateDrawingStateBlock(
    {_COM_Outptr_ }  out drawingStateBlock: ID2D1DrawingStateBlock1): HRESULT;
begin

    Result :=

        CreateDrawingStateBlock(nil, nil, drawingStateBlock);

end;


end.
