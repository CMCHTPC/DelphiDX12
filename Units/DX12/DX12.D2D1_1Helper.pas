unit DX12.D2D1_1Helper;

{$IFDEF FPC}
//{$mode delphiunicode}{$H+}
{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

// D2D1_3Helper.h
// D2D1_2Helper.h

interface

uses
    Windows, Classes, SysUtils,
    DX12.D2D1,
    DX12.D2D1Helper,
    DX12.D2D1_1,
    DX12.D2D1_3,
    DX12.D2D1Effects,
    DX12.DCommon;

    {$Z4}

function ConvertColorSpace(sourceColorSpace: TD2D1_COLOR_SPACE; destinationColorSpace: TD2D1_COLOR_SPACE; color: TD2D1_COLOR_F): TD2D1_COLOR_F;

function DrawingStateDescription1(antialiasMode: TD2D1_ANTIALIAS_MODE = D2D1_ANTIALIAS_MODE_PER_PRIMITIVE; textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE = D2D1_TEXT_ANTIALIAS_MODE_DEFAULT; tag1: TD2D1_TAG = 0; tag2: TD2D1_TAG = 0;
    {_In_ } ATransform: PD2D1_MATRIX_3X2_F = nil; primitiveBlend: TD2D1_PRIMITIVE_BLEND = D2D1_PRIMITIVE_BLEND_SOURCE_OVER; unitMode: TD2D1_UNIT_MODE = D2D1_UNIT_MODE_DIPS): TD2D1_DRAWING_STATE_DESCRIPTION1; overload;

function DrawingStateDescription1(
    {_In_ } desc: TD2D1_DRAWING_STATE_DESCRIPTION; primitiveBlend: TD2D1_PRIMITIVE_BLEND = D2D1_PRIMITIVE_BLEND_SOURCE_OVER; unitMode: TD2D1_UNIT_MODE = D2D1_UNIT_MODE_DIPS): TD2D1_DRAWING_STATE_DESCRIPTION1; overload;


function DrawingStateDescription1(transform: TD2D1_MATRIX_3X2_F; antialiasMode: TD2D1_ANTIALIAS_MODE = D2D1_ANTIALIAS_MODE_PER_PRIMITIVE; textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE = D2D1_TEXT_ANTIALIAS_MODE_DEFAULT;
    tag1: TD2D1_TAG = 0; tag2: TD2D1_TAG = 0; primitiveBlend: TD2D1_PRIMITIVE_BLEND = D2D1_PRIMITIVE_BLEND_SOURCE_OVER; unitMode: TD2D1_UNIT_MODE = D2D1_UNIT_MODE_DIPS): TD2D1_DRAWING_STATE_DESCRIPTION1; overload;

function DrawingStateDescription1(antialiasMode: TD2D1_ANTIALIAS_MODE = D2D1_ANTIALIAS_MODE_PER_PRIMITIVE; textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE = D2D1_TEXT_ANTIALIAS_MODE_DEFAULT;
    tag1: TD2D1_TAG = 0; tag2: TD2D1_TAG = 0; primitiveBlend: TD2D1_PRIMITIVE_BLEND = D2D1_PRIMITIVE_BLEND_SOURCE_OVER; unitMode: TD2D1_UNIT_MODE = D2D1_UNIT_MODE_DIPS): TD2D1_DRAWING_STATE_DESCRIPTION1; overload;


function BitmapProperties1(bitmapOptions: TD2D1_BITMAP_OPTIONS = D2D1_BITMAP_OPTIONS_NONE;
    {_In_ } APixelFormat: PD2D1_PIXEL_FORMAT = nil; dpiX: single = 96.0; dpiY: single = 96.0;
    {_In_opt_ } colorContext: ID2D1ColorContext = nil): TD2D1_BITMAP_PROPERTIES1; overload;


function BitmapProperties1(pixelFormat: TD2D1_PIXEL_FORMAT; bitmapOptions: TD2D1_BITMAP_OPTIONS = D2D1_BITMAP_OPTIONS_NONE; dpiX: single = 96.0; dpiY: single = 96.0; colorContext: ID2D1ColorContext = nil): TD2D1_BITMAP_PROPERTIES1; overload;

function BitmapProperties1(bitmapOptions: TD2D1_BITMAP_OPTIONS = D2D1_BITMAP_OPTIONS_NONE; dpiX: single = 96.0; dpiY: single = 96.0; colorContext: ID2D1ColorContext = nil): TD2D1_BITMAP_PROPERTIES1; overload;



function LayerParameters1(
    {_In_ } contentBounds: PD2D1_RECT_F = nil;
    {_In_opt_ } geometricMask: ID2D1Geometry = nil; maskAntialiasMode: TD2D1_ANTIALIAS_MODE = D2D1_ANTIALIAS_MODE_PER_PRIMITIVE; maskTransform: PD2D1_MATRIX_3X2_F = nil; opacity: single = 1.0;
    {_In_opt_ } opacityBrush: ID2D1Brush = nil; layerOptions: TD2D1_LAYER_OPTIONS1 = D2D1_LAYER_OPTIONS1_NONE): TD2D1_LAYER_PARAMETERS1;

function LayerParameters1(contentBounds: TD2D1_RECT_F; maskTransform: TD2D1_MATRIX_3X2_F; geometricMask: ID2D1Geometry = nil; maskAntialiasMode: TD2D1_ANTIALIAS_MODE = D2D1_ANTIALIAS_MODE_PER_PRIMITIVE;
    opacity: single = 1.0; opacityBrush: ID2D1Brush = nil; layerOptions: TD2D1_LAYER_OPTIONS1 = D2D1_LAYER_OPTIONS1_NONE): TD2D1_LAYER_PARAMETERS1; overload;

function LayerParameters1(geometricMask: ID2D1Geometry = nil; maskAntialiasMode: TD2D1_ANTIALIAS_MODE = D2D1_ANTIALIAS_MODE_PER_PRIMITIVE; opacity: single = 1.0; opacityBrush: ID2D1Brush = nil;
    layerOptions: TD2D1_LAYER_OPTIONS1 = D2D1_LAYER_OPTIONS1_NONE): TD2D1_LAYER_PARAMETERS1; overload;


function StrokeStyleProperties1(startCap: TD2D1_CAP_STYLE = D2D1_CAP_STYLE_FLAT; endCap: TD2D1_CAP_STYLE = D2D1_CAP_STYLE_FLAT; dashCap: TD2D1_CAP_STYLE = D2D1_CAP_STYLE_FLAT;
    lineJoin: TD2D1_LINE_JOIN = D2D1_LINE_JOIN_MITER; miterLimit: single = 10.0; dashStyle: TD2D1_DASH_STYLE = D2D1_DASH_STYLE_SOLID; dashOffset: single = 0.0;
    transformType: TD2D1_STROKE_TRANSFORM_TYPE = D2D1_STROKE_TRANSFORM_TYPE_NORMAL): TD2D1_STROKE_STYLE_PROPERTIES1;


function ImageBrushProperties(sourceRectangle: TD2D1_RECT_F; extendModeX: TD2D1_EXTEND_MODE = D2D1_EXTEND_MODE_CLAMP; extendModeY: TD2D1_EXTEND_MODE = D2D1_EXTEND_MODE_CLAMP;
    interpolationMode: TD2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR): TD2D1_IMAGE_BRUSH_PROPERTIES;


function BitmapBrushProperties1(extendModeX: TD2D1_EXTEND_MODE = D2D1_EXTEND_MODE_CLAMP; extendModeY: TD2D1_EXTEND_MODE = D2D1_EXTEND_MODE_CLAMP;
    interpolationMode: TD2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR): TD2D1_BITMAP_BRUSH_PROPERTIES1;


function PrintControlProperties(fontSubsetMode: TD2D1_PRINT_FONT_SUBSET_MODE = D2D1_PRINT_FONT_SUBSET_MODE_DEFAULT; rasterDpi: single = 150.0; colorSpace: TD2D1_COLOR_SPACE = D2D1_COLOR_SPACE_SRGB): TD2D1_PRINT_CONTROL_PROPERTIES;


function RenderingControls(bufferPrecision: TD2D1_BUFFER_PRECISION; tileSize: TD2D1_SIZE_U): TD2D1_RENDERING_CONTROLS;


function EffectInputDescription(effect: ID2D1Effect; inputIndex: uint32; inputRectangle: TD2D1_RECT_F): TD2D1_EFFECT_INPUT_DESCRIPTION;


function CreationProperties(threadingMode: TD2D1_THREADING_MODE; debugLevel: TD2D1_DEBUG_LEVEL; options: TD2D1_DEVICE_CONTEXT_OPTIONS): TD2D1_CREATION_PROPERTIES;

// Sets a bitmap as an effect input, while inserting a DPI compensation effect
// to preserve visual appearance as the device context's DPI changes.
function SetDpiCompensatedEffectInput(
    {_In_ } deviceContext: ID2D1DeviceContext;
    {_In_ } effect: ID2D1Effect; inputIndex: uint32;
    {_In_opt_ } inputBitmap: ID2D1Bitmap = nil; interpolationMode: TD2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR; borderMode: TD2D1_BORDER_MODE = D2D1_BORDER_MODE_HARD): HRESULT;


function ComputeFlatteningTolerance(
    {_In_ } matrix: TD2D1_MATRIX_3X2_F; dpiX: single = 96.0; dpiY: single = 96.0; maxZoomFactor: single = 1.0): single;


function GradientMeshPatch(point00: TD2D1_POINT_2F; point01: TD2D1_POINT_2F; point02: TD2D1_POINT_2F; point03: TD2D1_POINT_2F; point10: TD2D1_POINT_2F; point11: TD2D1_POINT_2F;
    point12: TD2D1_POINT_2F; point13: TD2D1_POINT_2F; point20: TD2D1_POINT_2F; point21: TD2D1_POINT_2F; point22: TD2D1_POINT_2F; point23: TD2D1_POINT_2F; point30: TD2D1_POINT_2F;
    point31: TD2D1_POINT_2F; point32: TD2D1_POINT_2F; point33: TD2D1_POINT_2F; color00: TD2D1_COLOR_F; color03: TD2D1_COLOR_F; color30: TD2D1_COLOR_F; color33: TD2D1_COLOR_F;
    topEdgeMode: TD2D1_PATCH_EDGE_MODE; leftEdgeMode: TD2D1_PATCH_EDGE_MODE; bottomEdgeMode: TD2D1_PATCH_EDGE_MODE; rightEdgeMode: TD2D1_PATCH_EDGE_MODE): TD2D1_GRADIENT_MESH_PATCH;


function GradientMeshPatchFromCoonsPatch(point0: TD2D1_POINT_2F; point1: TD2D1_POINT_2F; point2: TD2D1_POINT_2F; point3: TD2D1_POINT_2F; point4: TD2D1_POINT_2F; point5: TD2D1_POINT_2F;
    point6: TD2D1_POINT_2F; point7: TD2D1_POINT_2F; point8: TD2D1_POINT_2F; point9: TD2D1_POINT_2F; point10: TD2D1_POINT_2F; point11: TD2D1_POINT_2F; color0: TD2D1_COLOR_F; color1: TD2D1_COLOR_F;
    color2: TD2D1_COLOR_F; color3: TD2D1_COLOR_F; topEdgeMode: TD2D1_PATCH_EDGE_MODE; leftEdgeMode: TD2D1_PATCH_EDGE_MODE; bottomEdgeMode: TD2D1_PATCH_EDGE_MODE; rightEdgeMode: TD2D1_PATCH_EDGE_MODE): TD2D1_GRADIENT_MESH_PATCH;


function InkPoint(point: TD2D1_POINT_2F; radius: single): TD2D1_INK_POINT;


function InkBezierSegment(point1: TD2D1_INK_POINT; point2: TD2D1_INK_POINT; point3: TD2D1_INK_POINT): TD2D1_INK_BEZIER_SEGMENT;


function InkStyleProperties(nibShape: TD2D1_INK_NIB_SHAPE; nibTransform: TD2D1_MATRIX_3X2_F): TD2D1_INK_STYLE_PROPERTIES;


function SimpleColorProfile(redPrimary: TD2D1_POINT_2F; greenPrimary: TD2D1_POINT_2F; bluePrimary: TD2D1_POINT_2F; gamma: TD2D1_GAMMA1; whitePointXZ: TD2D1_POINT_2F): TD2D1_SIMPLE_COLOR_PROFILE;


function Vector2F(x: single = 0.0; y: single = 0.0): TD2D1_VECTOR_2F;

function Vector3F(x: single = 0.0; y: single = 0.0; z: single = 0.0): TD2D1_VECTOR_3F;

function Vector4F(x: single = 0.0; y: single = 0.0; z: single = 0.0; w: single = 0.0): TD2D1_VECTOR_4F;

function Point2L(x: int32 = 0; y: int32 = 0): TD2D1_POINT_2L;

function RectL(left: int32 = 0; top: int32 = 0; right: int32 = 0; bottom: int32 = 0): TD2D1_RECT_L;

implementation

uses
    DX12.D2D1_2;

function ConvertColorSpace(sourceColorSpace: TD2D1_COLOR_SPACE; destinationColorSpace: TD2D1_COLOR_SPACE; color: TD2D1_COLOR_F): TD2D1_COLOR_F;
var
    a: TD2D1_COLOR_F;
begin
    a := D2D1ConvertColorSpace(sourceColorSpace, destinationColorSpace, @color)^;
    Result := a;
end;



function DrawingStateDescription1(antialiasMode: TD2D1_ANTIALIAS_MODE; textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE; tag1: TD2D1_TAG; tag2: TD2D1_TAG; ATransform: PD2D1_MATRIX_3X2_F;
    primitiveBlend: TD2D1_PRIMITIVE_BLEND; unitMode: TD2D1_UNIT_MODE): TD2D1_DRAWING_STATE_DESCRIPTION1;
var
    a: TD2D1_DRAWING_STATE_DESCRIPTION1;
begin

    a.antialiasMode := antialiasMode;
    a.textAntialiasMode := textAntialiasMode;
    a.tag1 := tag1;
    a.tag2 := tag2;
    if ATransform <> nil then
        a.transform := (ATransform)^
    else
        a.transform.Identity;
    a.primitiveBlend := primitiveBlend;
    a.unitMode := unitMode;
    Result := a;
end;



function DrawingStateDescription1(desc: TD2D1_DRAWING_STATE_DESCRIPTION; primitiveBlend: TD2D1_PRIMITIVE_BLEND; unitMode: TD2D1_UNIT_MODE): TD2D1_DRAWING_STATE_DESCRIPTION1;
var
    a: TD2D1_DRAWING_STATE_DESCRIPTION1;
begin
    a.antialiasMode := desc.antialiasMode;
    a.textAntialiasMode := desc.textAntialiasMode;
    a.tag1 := desc.tag1;
    a.tag2 := desc.tag2;
    a.transform := desc.transform;
    a.primitiveBlend := primitiveBlend;
    a.unitMode := unitMode;
    Result := a;
end;

function DrawingStateDescription1(transform: TD2D1_MATRIX_3X2_F; antialiasMode: TD2D1_ANTIALIAS_MODE; textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE; tag1: TD2D1_TAG; tag2: TD2D1_TAG;
    primitiveBlend: TD2D1_PRIMITIVE_BLEND; unitMode: TD2D1_UNIT_MODE): TD2D1_DRAWING_STATE_DESCRIPTION1;
var
    a: TD2D1_DRAWING_STATE_DESCRIPTION1;
begin
    a.antialiasMode := antialiasMode;
    a.textAntialiasMode := textAntialiasMode;
    a.tag1 := tag1;
    a.tag2 := tag2;
    a.transform := transform;
    a.primitiveBlend := primitiveBlend;
    a.unitMode := unitMode;
    Result := a;
end;

function DrawingStateDescription1(antialiasMode: TD2D1_ANTIALIAS_MODE; textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE; tag1: TD2D1_TAG; tag2: TD2D1_TAG; primitiveBlend: TD2D1_PRIMITIVE_BLEND;
    unitMode: TD2D1_UNIT_MODE): TD2D1_DRAWING_STATE_DESCRIPTION1;
var
    a: TD2D1_DRAWING_STATE_DESCRIPTION1;
begin
    a.antialiasMode := antialiasMode;
    a.textAntialiasMode := textAntialiasMode;
    a.tag1 := tag1;
    a.tag2 := tag2;
    a.transform := IdentityMatrix();
    a.primitiveBlend := primitiveBlend;
    a.unitMode := unitMode;
    Result := a;
end;



function BitmapProperties1(bitmapOptions: TD2D1_BITMAP_OPTIONS; APixelFormat: PD2D1_PIXEL_FORMAT; dpiX: single; dpiY: single; colorContext: ID2D1ColorContext): TD2D1_BITMAP_PROPERTIES1;
var
    a: TD2D1_BITMAP_PROPERTIES1;
begin
    ZeroMemory(@a, SizeOf(TD2D1_BITMAP_PROPERTIES1));
    if APixelFormat <> nil then
        a.pixelFormat := APixelFormat^
    else
        a.pixelFormat := DX12.D2D1Helper.PixelFormat;
    a.dpiX := dpiX;
    a.dpiY := dpiY;
    a.bitmapOptions := bitmapOptions;
    a.colorContext := colorContext;
    Result := a;
end;

function BitmapProperties1(pixelFormat: TD2D1_PIXEL_FORMAT; bitmapOptions: TD2D1_BITMAP_OPTIONS; dpiX: single; dpiY: single; colorContext: ID2D1ColorContext): TD2D1_BITMAP_PROPERTIES1;
var
    a: TD2D1_BITMAP_PROPERTIES1;
begin
    a.bitmapOptions := bitmapOptions;
    a.colorContext := colorContext;
    a.dpiX := dpiX;
    a.dpiY := dpiY;
    a.pixelFormat := pixelFormat;
    Result := a;
end;

function BitmapProperties1(bitmapOptions: TD2D1_BITMAP_OPTIONS; dpiX: single; dpiY: single; colorContext: ID2D1ColorContext): TD2D1_BITMAP_PROPERTIES1;
var
    a: TD2D1_BITMAP_PROPERTIES1;
begin
    a.bitmapOptions := bitmapOptions;
    a.colorContext := colorContext;
    a.dpiX := dpiX;
    a.dpiY := dpiY;
    a.pixelFormat := PixelFormat();
    Result := a;
end;



function LayerParameters1(contentBounds: PD2D1_RECT_F; geometricMask: ID2D1Geometry; maskAntialiasMode: TD2D1_ANTIALIAS_MODE; maskTransform: PD2D1_MATRIX_3X2_F; opacity: single;
    opacityBrush: ID2D1Brush; layerOptions: TD2D1_LAYER_OPTIONS1): TD2D1_LAYER_PARAMETERS1;
var
    a: TD2D1_LAYER_PARAMETERS1;
begin
    if contentBounds <> nil then
        a.contentBounds := contentBounds^
    else
        a.contentBounds.InfiniteRect;
    a.geometricMask := geometricMask;
    a.maskAntialiasMode := maskAntialiasMode;
    if maskTransform <> nil then
        a.maskTransform := maskTransform^
    else
        a.maskTransform.Identity;
    a.opacity := opacity;
    a.opacityBrush := opacityBrush;
    a.layerOptions := layerOptions;
    Result := a;
end;

function LayerParameters1(contentBounds: TD2D1_RECT_F; maskTransform: TD2D1_MATRIX_3X2_F; geometricMask: ID2D1Geometry; maskAntialiasMode: TD2D1_ANTIALIAS_MODE; opacity: single;
    opacityBrush: ID2D1Brush; layerOptions: TD2D1_LAYER_OPTIONS1): TD2D1_LAYER_PARAMETERS1;
var
    a: TD2D1_LAYER_PARAMETERS1;
begin
    a.contentBounds := contentBounds;
    a.geometricMask := geometricMask;
    a.maskAntialiasMode := maskAntialiasMode;
    a.maskTransform := maskTransform;
    a.opacity := opacity;
    a.opacityBrush := opacityBrush;
    a.layerOptions := layerOptions;
    Result := a;
end;

function LayerParameters1(geometricMask: ID2D1Geometry; maskAntialiasMode: TD2D1_ANTIALIAS_MODE; opacity: single; opacityBrush: ID2D1Brush; layerOptions: TD2D1_LAYER_OPTIONS1): TD2D1_LAYER_PARAMETERS1;
var
    a: TD2D1_LAYER_PARAMETERS1;
begin
    a.contentBounds := InfiniteRect();
    a.geometricMask := geometricMask;
    a.maskAntialiasMode := maskAntialiasMode;
    a.maskTransform := IdentityMatrix();
    a.opacity := opacity;
    a.opacityBrush := opacityBrush;
    a.layerOptions := layerOptions;
    Result := a;
end;



function StrokeStyleProperties1(startCap: TD2D1_CAP_STYLE; endCap: TD2D1_CAP_STYLE; dashCap: TD2D1_CAP_STYLE; lineJoin: TD2D1_LINE_JOIN; miterLimit: single; dashStyle: TD2D1_DASH_STYLE;
    dashOffset: single; transformType: TD2D1_STROKE_TRANSFORM_TYPE): TD2D1_STROKE_STYLE_PROPERTIES1;
var
    a: TD2D1_STROKE_STYLE_PROPERTIES1;
begin
    a.startCap := startCap;
    a.endCap := endCap;
    a.dashCap := dashCap;
    a.lineJoin := lineJoin;
    a.miterLimit := miterLimit;
    a.dashStyle := dashStyle;
    a.dashOffset := dashOffset;
    a.transformType := transformType;
    Result := a;
end;



function ImageBrushProperties(sourceRectangle: TD2D1_RECT_F; extendModeX: TD2D1_EXTEND_MODE; extendModeY: TD2D1_EXTEND_MODE; interpolationMode: TD2D1_INTERPOLATION_MODE): TD2D1_IMAGE_BRUSH_PROPERTIES;
var
    a: TD2D1_IMAGE_BRUSH_PROPERTIES;
begin
    a.extendModeX := extendModeX;
    a.extendModeY := extendModeY;
    a.interpolationMode := interpolationMode;
    a.sourceRectangle := sourceRectangle;
    Result := a;
end;



function BitmapBrushProperties1(extendModeX: TD2D1_EXTEND_MODE; extendModeY: TD2D1_EXTEND_MODE; interpolationMode: TD2D1_INTERPOLATION_MODE): TD2D1_BITMAP_BRUSH_PROPERTIES1;
var
    a: TD2D1_BITMAP_BRUSH_PROPERTIES1;
begin
    a.extendModeX := extendModeX;
    a.extendModeY := extendModeY;
    a.interpolationMode := interpolationMode;
    Result := a;

end;



function PrintControlProperties(fontSubsetMode: TD2D1_PRINT_FONT_SUBSET_MODE; rasterDpi: single; colorSpace: TD2D1_COLOR_SPACE): TD2D1_PRINT_CONTROL_PROPERTIES;
var
    a: TD2D1_PRINT_CONTROL_PROPERTIES;
begin
    a.fontSubset := fontSubsetMode;
    a.rasterDPI := rasterDpi;
    a.colorSpace := colorSpace;
    Result := a;
end;



function RenderingControls(bufferPrecision: TD2D1_BUFFER_PRECISION; tileSize: TD2D1_SIZE_U): TD2D1_RENDERING_CONTROLS;
var
    a: TD2D1_RENDERING_CONTROLS;
begin
    a.bufferPrecision := bufferPrecision;
    a.tileSize := tileSize;
    Result := a;
end;



function EffectInputDescription(effect: ID2D1Effect; inputIndex: uint32; inputRectangle: TD2D1_RECT_F): TD2D1_EFFECT_INPUT_DESCRIPTION;
var
    a: TD2D1_EFFECT_INPUT_DESCRIPTION;
begin
    a.effect := @effect;
    a.inputIndex := inputIndex;
    a.inputRectangle := inputRectangle;
    Result := a;
end;



function CreationProperties(threadingMode: TD2D1_THREADING_MODE; debugLevel: TD2D1_DEBUG_LEVEL; options: TD2D1_DEVICE_CONTEXT_OPTIONS): TD2D1_CREATION_PROPERTIES;
var
    a: TD2D1_CREATION_PROPERTIES;
begin
    a.threadingMode := threadingMode;
    a.debugLevel := debugLevel;
    a.options := options;
    Result := a;
end;



function SetDpiCompensatedEffectInput(deviceContext: ID2D1DeviceContext; effect: ID2D1Effect; inputIndex: uint32; inputBitmap: ID2D1Bitmap; interpolationMode: TD2D1_INTERPOLATION_MODE; borderMode: TD2D1_BORDER_MODE): HRESULT;
var
    dpiCompensationEffect: ID2D1Effect;
    bitmapDpi: TD2D1_POINT_2F;
begin
    Result := S_OK;
    if (inputBitmap = nil) then
    begin
        effect.SetInput(inputIndex, nil);
        Exit;
    end;

    Result := deviceContext.CreateEffect(@CLSID_D2D1DpiCompensation, dpiCompensationEffect);

    if (SUCCEEDED(Result)) then
    begin
        if (SUCCEEDED(Result)) then
        begin
            dpiCompensationEffect.SetInput(0, inputBitmap);
            inputBitmap.GetDpi(@bitmapDpi.x, @bitmapDpi.y);
            Result := dpiCompensationEffect.SetValue(Ord(D2D1_DPICOMPENSATION_PROP_INPUT_DPI), @bitmapDpi, SizeOf(TD2D1_POINT_2F));
        end;

        if (SUCCEEDED(Result)) then
        begin
            Result := dpiCompensationEffect.SetValue(Ord(D2D1_DPICOMPENSATION_PROP_INTERPOLATION_MODE), @interpolationMode, sizeOf(TD2D1_INTERPOLATION_MODE));
        end;

        if (SUCCEEDED(Result)) then
        begin
            Result := dpiCompensationEffect.SetValue(Ord(D2D1_DPICOMPENSATION_PROP_BORDER_MODE), @borderMode, SizeOf(TD2D1_BORDER_MODE));
        end;

        if (SUCCEEDED(Result)) then
        begin
            effect.SetInputEffect(inputIndex, dpiCompensationEffect);
        end;

        dpiCompensationEffect := nil;

    end;
end;



function ComputeFlatteningTolerance(matrix: TD2D1_MATRIX_3X2_F; dpiX: single; dpiY: single; maxZoomFactor: single): single;
var
    dpiDependentTransform: TD2D1_MATRIX_3X2_F;
    absMaxZoomFactor: single;
begin
    dpiDependentTransform.Scale(dpiX / 96.0, dpiY / 96.0, nil);
    if (maxZoomFactor > 0) then
        absMaxZoomFactor := maxZoomFactor
    else
        absMaxZoomFactor := -maxZoomFactor;

    Result := D2D1_DEFAULT_FLATTENING_TOLERANCE / (absMaxZoomFactor * D2D1ComputeMaximumScaleFactor(@dpiDependentTransform));
end;



function GradientMeshPatch(point00: TD2D1_POINT_2F; point01: TD2D1_POINT_2F; point02: TD2D1_POINT_2F; point03: TD2D1_POINT_2F; point10: TD2D1_POINT_2F; point11: TD2D1_POINT_2F; point12: TD2D1_POINT_2F;
    point13: TD2D1_POINT_2F; point20: TD2D1_POINT_2F; point21: TD2D1_POINT_2F; point22: TD2D1_POINT_2F; point23: TD2D1_POINT_2F; point30: TD2D1_POINT_2F; point31: TD2D1_POINT_2F; point32: TD2D1_POINT_2F;
    point33: TD2D1_POINT_2F; color00: TD2D1_COLOR_F; color03: TD2D1_COLOR_F; color30: TD2D1_COLOR_F; color33: TD2D1_COLOR_F; topEdgeMode: TD2D1_PATCH_EDGE_MODE; leftEdgeMode: TD2D1_PATCH_EDGE_MODE;
    bottomEdgeMode: TD2D1_PATCH_EDGE_MODE; rightEdgeMode: TD2D1_PATCH_EDGE_MODE): TD2D1_GRADIENT_MESH_PATCH;
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
    newPatch.color30 := color30;
    newPatch.color33 := color33;

    newPatch.topEdgeMode := topEdgeMode;
    newPatch.leftEdgeMode := leftEdgeMode;
    newPatch.bottomEdgeMode := bottomEdgeMode;
    newPatch.rightEdgeMode := rightEdgeMode;
    Result := newPatch;
end;



function GradientMeshPatchFromCoonsPatch(point0: TD2D1_POINT_2F; point1: TD2D1_POINT_2F; point2: TD2D1_POINT_2F; point3: TD2D1_POINT_2F; point4: TD2D1_POINT_2F; point5: TD2D1_POINT_2F;
    point6: TD2D1_POINT_2F; point7: TD2D1_POINT_2F; point8: TD2D1_POINT_2F; point9: TD2D1_POINT_2F; point10: TD2D1_POINT_2F; point11: TD2D1_POINT_2F; color0: TD2D1_COLOR_F; color1: TD2D1_COLOR_F;
    color2: TD2D1_COLOR_F; color3: TD2D1_COLOR_F; topEdgeMode: TD2D1_PATCH_EDGE_MODE; leftEdgeMode: TD2D1_PATCH_EDGE_MODE; bottomEdgeMode: TD2D1_PATCH_EDGE_MODE; rightEdgeMode: TD2D1_PATCH_EDGE_MODE): TD2D1_GRADIENT_MESH_PATCH;
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

    D2D1GetGradientMeshInteriorPointsFromCoonsPatch(@point0, @point1, @point2, @point3, @point4, @point5, @point6, @point7, @point8, @point9, @point10, @point11, @newPatch.point11, @newPatch.point12, @newPatch.point21, @newPatch.point22
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
    lInkPoint: TD2D1_INK_POINT;
begin
    lInkPoint.x := point.x;
    lInkPoint.y := point.y;
    lInkPoint.radius := radius;

    Result := lInkPoint;
end;



function InkBezierSegment(point1: TD2D1_INK_POINT; point2: TD2D1_INK_POINT; point3: TD2D1_INK_POINT): TD2D1_INK_BEZIER_SEGMENT;
var
    lInkBezierSegment: TD2D1_INK_BEZIER_SEGMENT;
begin

    lInkBezierSegment.point1 := point1;
    lInkBezierSegment.point2 := point2;
    lInkBezierSegment.point3 := point3;

    Result := lInkBezierSegment;
end;



function InkStyleProperties(nibShape: TD2D1_INK_NIB_SHAPE; nibTransform: TD2D1_MATRIX_3X2_F): TD2D1_INK_STYLE_PROPERTIES;
var
    lInkStyleProperties: TD2D1_INK_STYLE_PROPERTIES;
begin

    lInkStyleProperties.nibShape := nibShape;
    lInkStyleProperties.nibTransform := nibTransform;

    Result := lInkStyleProperties;
end;



function SimpleColorProfile(redPrimary: TD2D1_POINT_2F; greenPrimary: TD2D1_POINT_2F; bluePrimary: TD2D1_POINT_2F; gamma: TD2D1_GAMMA1; whitePointXZ: TD2D1_POINT_2F): TD2D1_SIMPLE_COLOR_PROFILE;
var
    lSimpleColorProfile: TD2D1_SIMPLE_COLOR_PROFILE;
begin

    lSimpleColorProfile.redPrimary := redPrimary;
    lSimpleColorProfile.greenPrimary := greenPrimary;
    lSimpleColorProfile.bluePrimary := bluePrimary;
    lSimpleColorProfile.gamma := gamma;
    lSimpleColorProfile.whitePointXZ := whitePointXZ;

    Result := lSimpleColorProfile;
end;

function Vector2F(x: single; y: single): TD2D1_VECTOR_2F;
var
    a: TD2D1_VECTOR_2F;
begin
    a.x := x;
    a.y := y;

    Result := a;
end;

function Vector3F(x: single; y: single; z: single): TD2D1_VECTOR_3F;
var
    a: TD2D1_VECTOR_3F;
begin
    a.x := x;
    a.y := y;
    a.z := z;
    Result := a;
end;

function Vector4F(x: single; y: single; z: single; w: single): TD2D1_VECTOR_4F;
var
    a: TD2D1_VECTOR_4F;
begin
    a.x := x;
    a.y := y;
    a.z := z;
    a.w := w;
    Result := a;
end;

function Point2L(x: int32; y: int32): TD2D1_POINT_2L;
var
    a: TD2D1_POINT_2L;
begin
    a.x := x;
    a.y := y;
    Result := a;
end;

function RectL(left: int32; top: int32; right: int32; bottom: int32): TD2D1_RECT_L;
var
    a: TD2D1_RECT_L;
begin
    a.Left := left;
    a.Top := top;
    a.right := right;
    a.bottom := bottom;
    Result := a;
end;


end.
