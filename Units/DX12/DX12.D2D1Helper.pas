unit DX12.D2D1Helper;


{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}


interface

uses
    Windows, Classes, SysUtils,
    DX12.DXGIFormat,
    DX12.D2D1DWrite,
    DX12.D2D1,
    DX12.DCommon;

    {$Z4}

const

    // Colors, this enum defines a set of predefined colors.
    AliceBlue = $F0F8FF;
    AntiqueWhite = $FAEBD7;
    Aqua = $00FFFF;
    Aquamarine = $7FFFD4;
    Azure = $F0FFFF;
    Beige = $F5F5DC;
    Bisque = $FFE4C4;
    Black = $000000;
    BlanchedAlmond = $FFEBCD;
    Blue = $0000FF;
    BlueViolet = $8A2BE2;
    Brown = $A52A2A;
    BurlyWood = $DEB887;
    CadetBlue = $5F9EA0;
    Chartreuse = $7FFF00;
    Chocolate = $D2691E;
    Coral = $FF7F50;
    CornflowerBlue = $6495ED;
    Cornsilk = $FFF8DC;
    Crimson = $DC143C;
    Cyan = $00FFFF;
    DarkBlue = $00008B;
    DarkCyan = $008B8B;
    DarkGoldenrod = $B8860B;
    DarkGray = $A9A9A9;
    DarkGreen = $006400;
    DarkKhaki = $BDB76B;
    DarkMagenta = $8B008B;
    DarkOliveGreen = $556B2F;
    DarkOrange = $FF8C00;
    DarkOrchid = $9932CC;
    DarkRed = $8B0000;
    DarkSalmon = $E9967A;
    DarkSeaGreen = $8FBC8F;
    DarkSlateBlue = $483D8B;
    DarkSlateGray = $2F4F4F;
    DarkTurquoise = $00CED1;
    DarkViolet = $9400D3;
    DeepPink = $FF1493;
    DeepSkyBlue = $00BFFF;
    DimGray = $696969;
    DodgerBlue = $1E90FF;
    Firebrick = $B22222;
    FloralWhite = $FFFAF0;
    ForestGreen = $228B22;
    Fuchsia = $FF00FF;
    Gainsboro = $DCDCDC;
    GhostWhite = $F8F8FF;
    Gold = $FFD700;
    Goldenrod = $DAA520;
    Gray = $808080;
    Green = $008000;
    GreenYellow = $ADFF2F;
    Honeydew = $F0FFF0;
    HotPink = $FF69B4;
    IndianRed = $CD5C5C;
    Indigo = $4B0082;
    Ivory = $FFFFF0;
    Khaki = $F0E68C;
    Lavender = $E6E6FA;
    LavenderBlush = $FFF0F5;
    LawnGreen = $7CFC00;
    LemonChiffon = $FFFACD;
    LightBlue = $ADD8E6;
    LightCoral = $F08080;
    LightCyan = $E0FFFF;
    LightGoldenrodYellow = $FAFAD2;
    LightGreen = $90EE90;
    LightGray = $D3D3D3;
    LightPink = $FFB6C1;
    LightSalmon = $FFA07A;
    LightSeaGreen = $20B2AA;
    LightSkyBlue = $87CEFA;
    LightSlateGray = $778899;
    LightSteelBlue = $B0C4DE;
    LightYellow = $FFFFE0;
    Lime = $00FF00;
    LimeGreen = $32CD32;
    Linen = $FAF0E6;
    Magenta = $FF00FF;
    Maroon = $800000;
    MediumAquamarine = $66CDAA;
    MediumBlue = $0000CD;
    MediumOrchid = $BA55D3;
    MediumPurple = $9370DB;
    MediumSeaGreen = $3CB371;
    MediumSlateBlue = $7B68EE;
    MediumSpringGreen = $00FA9A;
    MediumTurquoise = $48D1CC;
    MediumVioletRed = $C71585;
    MidnightBlue = $191970;
    MintCream = $F5FFFA;
    MistyRose = $FFE4E1;
    Moccasin = $FFE4B5;
    NavajoWhite = $FFDEAD;
    Navy = $000080;
    OldLace = $FDF5E6;
    Olive = $808000;
    OliveDrab = $6B8E23;
    Orange = $FFA500;
    OrangeRed = $FF4500;
    Orchid = $DA70D6;
    PaleGoldenrod = $EEE8AA;
    PaleGreen = $98FB98;
    PaleTurquoise = $AFEEEE;
    PaleVioletRed = $DB7093;
    PapayaWhip = $FFEFD5;
    PeachPuff = $FFDAB9;
    Peru = $CD853F;
    Pink = $FFC0CB;
    Plum = $DDA0DD;
    PowderBlue = $B0E0E6;
    Purple = $800080;
    Red = $FF0000;
    RosyBrown = $BC8F8F;
    RoyalBlue = $4169E1;
    SaddleBrown = $8B4513;
    Salmon = $FA8072;
    SandyBrown = $F4A460;
    SeaGreen = $2E8B57;
    SeaShell = $FFF5EE;
    Sienna = $A0522D;
    Silver = $C0C0C0;
    SkyBlue = $87CEEB;
    SlateBlue = $6A5ACD;
    SlateGray = $708090;
    Snow = $FFFAFA;
    SpringGreen = $00FF7F;
    SteelBlue = $4682B4;
    Tan = $D2B48C;
    Teal = $008080;
    Thistle = $D8BFD8;
    Tomato = $FF6347;
    Turquoise = $40E0D0;
    Violet = $EE82EE;
    Wheat = $F5DEB3;
    White = $FFFFFF;
    WhiteSmoke = $F5F5F5;
    Yellow = $FFFF00;
    YellowGreen = $9ACD32;


    sc_redShift = 16;
    sc_greenShift = 8;
    sc_blueShift = 0;

    sc_redMask: uint32 = ($ff shl sc_redShift);
    sc_greenMask: uint32 = ($ff shl sc_greenShift);
    sc_blueMask: uint32 = ($ff shl sc_blueShift);

type

    { TD2D1_COLOR_FHelper }

    TD2D1_COLOR_FHelper = record helper for TD2D1_COLOR_F
        // Construct a color, note that the alpha value from the "rgb" component
        // is never used.
        procedure ColorF(rgb: uint32; a: single = 1.0); overload;
        procedure ColorF(r, g, b: single; a: single = 1.0); overload;
    end;

    { TD2D_MATRIX_3X2_FHelper }

    TD2D_MATRIX_3X2_FHelper = record helper for TD2D_MATRIX_3X2_F
        procedure Translation(size: TD2D1_SIZE_F); overload;
        procedure Translation(x, y: single); overload;
        procedure Scale(size: TD2D1_SIZE_F; center: PD2D1_POINT_2F = nil); overload;
        procedure Scale(x, y: single; center: PD2D1_POINT_2F = nil); overload;
        //        procedure Scale(size: TD2D_SIZE_F); overload;
        //        procedure Scale(x, y: single); overload;
        procedure Rotation(angle: single; center: PD2D1_POINT_2F = nil); overload;
        procedure Rotation(angle: single; x, y: single); overload;
        procedure Rotation(angle: single); overload;
        procedure Skew(angleX, angleY: single; center: PD2D1_POINT_2F = nil); overload;
        procedure Skew(angleX, angleY: single); overload;
        function Determinant: single;
        function IsInvertible: boolean;
        function Invert: boolean;
        function IsIdentity: boolean;
        procedure SetProduct(a, b: TD2D_MATRIX_3X2_F);
        function TransformPoint(point: TD2D1_POINT_2F): TD2D1_POINT_2F;
    end;

// Forward declared IdentityMatrix function to allow matrix class to use
// these constructors.
function IdentityMatrix(): TD2D1_MATRIX_3X2_F;


function FloatMax: single;
function Point2(x, y: uint32): TD2D1_POINT_2U; overload;
function Point2(x, y: single): TD2D1_POINT_2F; overload;

function Size(Width, Height: uint32): TD2D1_SIZE_U; overload;
function Size(Width, Height: single): TD2D1_SIZE_F; overload;

function Rect(left, top, right, bottom: uint32): TD2D1_RECT_U; overload;
function Rect(left, top, right, bottom: single): TD2D1_RECT_F; overload;


function RectU(left: uint32 = 0; top: uint32 = 0; right: uint32 = 0; bottom: uint32 = 0): TD2D1_RECT_U;
function RectF(left: single = 0; top: single = 0; right: single = 0; bottom: single = 0): TD2D1_RECT_F;
function InfiniteRect: TD2D1_RECT_F;
function SizeU(Width: uint32 = 0; Height: uint32 = 0): TD2D1_SIZE_U;

// PixelFormat
function PixelFormat(
    {_In_ } AdxgiFormat: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN;
    {_In_ } AalphaMode: TD2D1_ALPHA_MODE = D2D1_ALPHA_MODE_UNKNOWN): TD2D1_PIXEL_FORMAT;

function ArcSegment(
    {_In_ } Apoint: TD2D1_POINT_2F;
    {_In_ } Asize: TD2D1_SIZE_F;
    {_In_ } rotationAngle: single;
    {_In_ } sweepDirection: TD2D1_SWEEP_DIRECTION;
    {_In_ } arcSize: TD2D1_ARC_SIZE): TD2D1_ARC_SEGMENT;

function BezierSegment(
    {_In_ } point1: TD2D1_POINT_2F;
    {_In_ } point2: TD2D1_POINT_2F;
    {_In_ } point3: TD2D1_POINT_2F): TD2D1_BEZIER_SEGMENT;


function Ellipse(
    {_In_ } center: TD2D1_POINT_2F; radiusX: single; radiusY: single): TD2D1_ELLIPSE;



function RoundedRect(
    {_In_ } rect: TD2D1_RECT_F; radiusX: single; radiusY: single): TD2D1_ROUNDED_RECT;


function BrushProperties(
    {_In_ } opacity: single = 1.0;
    {_In_ } ATransform: PD2D1_MATRIX_3X2_F = nil): TD2D1_BRUSH_PROPERTIES; overload;


function BrushProperties(ATransform: TD2D1_MATRIX_3X2_F; opacity: single = 1.0): TD2D1_BRUSH_PROPERTIES; overload;

function BrushProperties(opacity: single = 1.0): TD2D1_BRUSH_PROPERTIES; overload;

function GradientStop(position: single;
    {_In_ } color: TD2D1_COLOR_F): TD2D1_GRADIENT_STOP;

function QuadraticBezierSegment(
    {_In_ } point1: TD2D1_POINT_2F;
    {_In_ } point2: TD2D1_POINT_2F): TD2D1_QUADRATIC_BEZIER_SEGMENT;



function StrokeStyleProperties(startCap: TD2D1_CAP_STYLE = D2D1_CAP_STYLE_FLAT; endCap: TD2D1_CAP_STYLE = D2D1_CAP_STYLE_FLAT; dashCap: TD2D1_CAP_STYLE = D2D1_CAP_STYLE_FLAT;
    lineJoin: TD2D1_LINE_JOIN = D2D1_LINE_JOIN_MITER; miterLimit: single = 10.0; dashStyle: TD2D1_DASH_STYLE = D2D1_DASH_STYLE_SOLID; dashOffset: single = 0.0): TD2D1_STROKE_STYLE_PROPERTIES;


function BitmapBrushProperties(extendModeX: TD2D1_EXTEND_MODE = D2D1_EXTEND_MODE_CLAMP; extendModeY: TD2D1_EXTEND_MODE = D2D1_EXTEND_MODE_CLAMP;
    interpolationMode: TD2D1_BITMAP_INTERPOLATION_MODE = D2D1_BITMAP_INTERPOLATION_MODE_LINEAR): TD2D1_BITMAP_BRUSH_PROPERTIES;


function LinearGradientBrushProperties(
    {_In_ } startPoint: TD2D1_POINT_2F;
    {_In_ } endPoint: TD2D1_POINT_2F): TD2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES;



function RadialGradientBrushProperties(
    {_In_ } center: TD2D1_POINT_2F;
    {_In_ } gradientOriginOffset: TD2D1_POINT_2F; radiusX: single; radiusY: single): TD2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES;


function BitmapProperties(APixelFormat: PD2D1_PIXEL_FORMAT = nil; dpiX: single = 96.0; dpiY: single = 96.0): TD2D1_BITMAP_PROPERTIES; overload;

function BitmapProperties(dpiX: single = 96.0; dpiY: single = 96.0): TD2D1_BITMAP_PROPERTIES; overload;


function RenderTargetProperties(targetType: TD2D1_RENDER_TARGET_TYPE = D2D1_RENDER_TARGET_TYPE_DEFAULT;
    {_In_ } APixelFormat: PD2D1_PIXEL_FORMAT = nil; dpiX: single = 0.0; dpiY: single = 0.0; usage: TD2D1_RENDER_TARGET_USAGE = D2D1_RENDER_TARGET_USAGE_NONE;
    minLevel: TD2D1_FEATURE_LEVEL = D2D1_FEATURE_LEVEL_DEFAULT): TD2D1_RENDER_TARGET_PROPERTIES; overload;

function RenderTargetProperties_(pixelFormat: TD2D1_PIXEL_FORMAT; targetType: TD2D1_RENDER_TARGET_TYPE = D2D1_RENDER_TARGET_TYPE_DEFAULT; dpiX: single = 0.0; dpiY: single = 0.0;
    usage: TD2D1_RENDER_TARGET_USAGE = D2D1_RENDER_TARGET_USAGE_NONE; minLevel: TD2D1_FEATURE_LEVEL = D2D1_FEATURE_LEVEL_DEFAULT): TD2D1_RENDER_TARGET_PROPERTIES; overload;


function HwndRenderTargetProperties(
    {_In_ } hwnd: HWND;
    {_In_ } pixelSize: TD2D1_SIZE_U;
    {_In_ } presentOptions: TD2D1_PRESENT_OPTIONS = D2D1_PRESENT_OPTIONS_NONE): TD2D1_HWND_RENDER_TARGET_PROPERTIES; overload;

function HwndRenderTargetProperties(hwnd: HWND; presentOptions: TD2D1_PRESENT_OPTIONS = D2D1_PRESENT_OPTIONS_NONE): TD2D1_HWND_RENDER_TARGET_PROPERTIES; overload;

function LayerParameters(
    {_In_ } contentBounds: PD2D1_RECT_F = nil;
    {_In_opt_ } geometricMask: ID2D1Geometry = nil; maskAntialiasMode: TD2D1_ANTIALIAS_MODE = D2D1_ANTIALIAS_MODE_PER_PRIMITIVE; maskTransform: PD2D1_MATRIX_3X2_F = nil; opacity: single = 1.0;
    {_In_opt_ } opacityBrush: ID2D1Brush = nil; layerOptions: TD2D1_LAYER_OPTIONS = D2D1_LAYER_OPTIONS_NONE): TD2D1_LAYER_PARAMETERS; overload;


function LayerParameters(geometricMask: ID2D1Geometry = nil; maskAntialiasMode: TD2D1_ANTIALIAS_MODE = D2D1_ANTIALIAS_MODE_PER_PRIMITIVE; opacity: single = 1.0; opacityBrush: ID2D1Brush = nil;
    layerOptions: TD2D1_LAYER_OPTIONS = D2D1_LAYER_OPTIONS_NONE): TD2D1_LAYER_PARAMETERS; overload;

function DrawingStateDescription(antialiasMode: TD2D1_ANTIALIAS_MODE = D2D1_ANTIALIAS_MODE_PER_PRIMITIVE; textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE = D2D1_TEXT_ANTIALIAS_MODE_DEFAULT; tag1: TD2D1_TAG = 0; tag2: TD2D1_TAG = 0;
    {_In_ } transform: PD2D1_MATRIX_3X2_F = nil): TD2D1_DRAWING_STATE_DESCRIPTION; overload;


function DrawingStateDescription(transform: TD2D1_MATRIX_3X2_F; antialiasMode: TD2D1_ANTIALIAS_MODE = D2D1_ANTIALIAS_MODE_PER_PRIMITIVE; textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE = D2D1_TEXT_ANTIALIAS_MODE_DEFAULT;
    tag1: TD2D1_TAG = 0; tag2: TD2D1_TAG = 0): TD2D1_DRAWING_STATE_DESCRIPTION; overload;

function DrawingStateDescription(antialiasMode: TD2D1_ANTIALIAS_MODE = D2D1_ANTIALIAS_MODE_PER_PRIMITIVE; textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE = D2D1_TEXT_ANTIALIAS_MODE_DEFAULT;
    tag1: TD2D1_TAG = 0; tag2: TD2D1_TAG = 0): TD2D1_DRAWING_STATE_DESCRIPTION; overload;


function ColorF(rgb: uint32; a: single = 1.0): TD2D1_COLOR_F; overload;
function ColorF(r, g, b: single; a: single = 1.0): TD2D1_COLOR_F; overload;

function SizeF(Width: single = 0.0; Height: single = 0.0): TD2D1_SIZE_F;
function Point2F(x: single = 0.0; y: single = 0.0): TD2D1_POINT_2F;
function Point2U(x: uint32 = 0; y: uint32 = 0): TD2D1_POINT_2U;




function Matrix3x2F_Rotation(angle: single; center: TD2D_POINT_2F): TD2D_MATRIX_3X2_F; overload;
function Matrix3x2F_Rotation(angle: single; x, y: single): TD2D_MATRIX_3X2_F; overload;
function Matrix3x2F_Scale(size: TD2D_SIZE_F; center: TD2D_POINT_2F): TD2D_MATRIX_3X2_F; overload;
function Matrix3x2F_Scale(size: TD2D_SIZE_F): TD2D_MATRIX_3X2_F; overload;
function Matrix3x2F_Scale(x, y: single; center: TD2D_POINT_2F): TD2D_MATRIX_3X2_F; overload;
function Matrix3x2F_Scale(x, y: single): TD2D_MATRIX_3X2_F; overload;

function Matrix3x2F_Translation(x, y: single): TD2D_MATRIX_3X2_F;

implementation



function IdentityMatrix(): TD2D1_MATRIX_3X2_F;
var
    a: TD2D1_MATRIX_3X2_F;
begin
    a.Identity;
    Result := a;
end;



function FloatMax: single;
begin
    Result := 3.402823466e+38;
end;


function Point2(x, y: uint32): TD2D1_POINT_2U;
var
    a: TD2D1_POINT_2U;
begin
    a.x := x;
    a.y := y;
    Result := a;
end;



function Point2(x, y: single): TD2D1_POINT_2F;
var
    a: TD2D1_POINT_2F;
begin
    a.x := x;
    a.y := y;
    Result := a;
end;



function Size(Width, Height: uint32): TD2D1_SIZE_U;
var
    a: TD2D1_SIZE_U;
begin
    a.Width := Width;
    a.Height := Height;
    Result := a;
end;



function Size(Width, Height: single): TD2D1_SIZE_F;
var
    a: TD2D1_SIZE_F;
begin
    a.Width := Width;
    a.Height := Height;
    Result := a;
end;



function Rect(left, top, right, bottom: uint32): TD2D1_RECT_U;
var
    a: TD2D1_RECT_U;
begin
    a.left := left;
    a.top := top;
    a.right := right;
    a.bottom := bottom;
    Result := a;
end;



function Rect(left, top, right, bottom: single): TD2D1_RECT_F;
var
    a: TD2D1_RECT_F;
begin
    a.left := left;
    a.top := top;
    a.right := right;
    a.bottom := bottom;
    Result := a;
end;



function RectU(left: uint32; top: uint32; right: uint32; bottom: uint32): TD2D1_RECT_U;
var
    a: TD2D1_RECT_U;
begin
    a.left := left;
    a.bottom := bottom;
    a.top := top;
    a.right := right;
    Result := a;
end;



function RectF(left: single; top: single; right: single; bottom: single): TD2D1_RECT_F;
var
    a: TD2D1_RECT_F;
begin
    a.left := left;
    a.bottom := bottom;
    a.top := top;
    a.right := right;
    Result := a;
end;



function InfiniteRect: TD2D1_RECT_F;
var
    a: TD2D1_RECT_F;
begin
    a.left := -FloatMax;
    a.top := -FloatMax;
    a.right := FloatMax;
    a.bottom := FloatMax;
    Result := a;
end;



function SizeU(Width: uint32; Height: uint32): TD2D1_SIZE_U;
var
    a: TD2D1_SIZE_U;
begin
    a.Width := Width;
    a.Height := Height;
    Result := a;
end;




function PixelFormat(AdxgiFormat: TDXGI_FORMAT; AalphaMode: TD2D1_ALPHA_MODE): TD2D1_PIXEL_FORMAT;
var
    a: TD2D1_PIXEL_FORMAT;
begin
    a.format := AdxgiFormat;
    a.alphaMode := AalphaMode;
    Result := a;
end;



function ArcSegment(Apoint: TD2D1_POINT_2F; Asize: TD2D1_SIZE_F; rotationAngle: single; sweepDirection: TD2D1_SWEEP_DIRECTION; arcSize: TD2D1_ARC_SIZE): TD2D1_ARC_SEGMENT;
var
    a: TD2D1_ARC_SEGMENT;
begin
    a.point := Apoint;
    a.size := Asize;
    a.rotationAngle := rotationAngle;
    a.sweepDirection := sweepDirection;
    a.arcSize := arcSize;
    Result := a;
end;



function BezierSegment(point1: TD2D1_POINT_2F; point2: TD2D1_POINT_2F; point3: TD2D1_POINT_2F): TD2D1_BEZIER_SEGMENT;
var
    a: TD2D1_BEZIER_SEGMENT;
begin
    a.point1 := Point1;
    a.point2 := Point2;
    a.point3 := Point3;
    Result := a;
end;



function Ellipse(center: TD2D1_POINT_2F; radiusX: single; radiusY: single): TD2D1_ELLIPSE;
var
    a: TD2D1_ELLIPSE;
begin
    a.point := center;
    a.radiusX := radiusX;
    a.radiusY := radiusY;
    Result := a;
end;



function RoundedRect(rect: TD2D1_RECT_F; radiusX: single; radiusY: single): TD2D1_ROUNDED_RECT;
var
    a: TD2D1_ROUNDED_RECT;
begin
    a.rect := rect;
    a.radiusX := radiusX;
    a.radiusY := radiusY;
    Result := a;
end;



function BrushProperties(opacity: single; ATransform: PD2D1_MATRIX_3X2_F): TD2D1_BRUSH_PROPERTIES;
var
    a: TD2D1_BRUSH_PROPERTIES;
begin
    a.opacity := opacity;
    if ATransform <> nil then
        a.transform := ATransform^
    else
        a.transform.Identity;
    Result := a;
end;


function BrushProperties(ATransform: TD2D1_MATRIX_3X2_F; opacity: single): TD2D1_BRUSH_PROPERTIES;
var
    a: TD2D1_BRUSH_PROPERTIES;
begin
    a.opacity := opacity;
    a.transform := ATransform;
    Result := a;
end;

function BrushProperties(opacity: single): TD2D1_BRUSH_PROPERTIES;
var
    a: TD2D1_BRUSH_PROPERTIES;
begin
    a.opacity := opacity;
    a.transform := IdentityMatrix();
    Result := a;
end;

function GradientStop(position: single; color: TD2D1_COLOR_F): TD2D1_GRADIENT_STOP;
var
    a: TD2D1_GRADIENT_STOP;
begin
    a.color := color;
    a.position := position;
    Result := a;
end;



function QuadraticBezierSegment(point1: TD2D1_POINT_2F; point2: TD2D1_POINT_2F): TD2D1_QUADRATIC_BEZIER_SEGMENT;
var
    a: TD2D1_QUADRATIC_BEZIER_SEGMENT;
begin
    a.point1 := point1;
    a.point2 := point2;
    Result := a;
end;



function StrokeStyleProperties(startCap: TD2D1_CAP_STYLE; endCap: TD2D1_CAP_STYLE; dashCap: TD2D1_CAP_STYLE; lineJoin: TD2D1_LINE_JOIN; miterLimit: single; dashStyle: TD2D1_DASH_STYLE; dashOffset: single): TD2D1_STROKE_STYLE_PROPERTIES;
var
    a: TD2D1_STROKE_STYLE_PROPERTIES;
begin
    a.startCap := startCap;
    a.endCap := endCap;
    a.dashCap := dashCap;
    a.lineJoin := lineJoin;
    a.miterLimit := miterLimit;
    a.dashStyle := dashStyle;
    a.dashOffset := dashOffset;
    Result := a;
end;



function BitmapBrushProperties(extendModeX: TD2D1_EXTEND_MODE; extendModeY: TD2D1_EXTEND_MODE; interpolationMode: TD2D1_BITMAP_INTERPOLATION_MODE): TD2D1_BITMAP_BRUSH_PROPERTIES;
var
    a: TD2D1_BITMAP_BRUSH_PROPERTIES;
begin
    a.extendModeX := extendModeX;
    a.extendModeY := extendModeY;
    a.interpolationMode := interpolationMode;
    Result := a;
end;



function LinearGradientBrushProperties(startPoint: TD2D1_POINT_2F; endPoint: TD2D1_POINT_2F): TD2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES;
var
    a: TD2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES;
begin
    a.startPoint := startPoint;
    a.endPoint := endPoint;
    Result := a;
end;



function RadialGradientBrushProperties(center: TD2D1_POINT_2F; gradientOriginOffset: TD2D1_POINT_2F; radiusX: single; radiusY: single): TD2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES;
var
    a: TD2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES;
begin
    a.center := center;
    a.gradientOriginOffset := gradientOriginOffset;
    a.radiusX := radiusX;
    a.radiusY := radiusY;
    Result := a;
end;



function BitmapProperties(APixelFormat: PD2D1_PIXEL_FORMAT; dpiX: single; dpiY: single): TD2D1_BITMAP_PROPERTIES;
var
    a: TD2D1_BITMAP_PROPERTIES;
begin
    if ApixelFormat <> nil then
        a.pixelFormat := ApixelFormat^
    else
        a.pixelFormat := PixelFormat;
    a.dpiX := dpiX;
    a.dpiY := dpiY;
    Result := a;
end;

function BitmapProperties(dpiX: single; dpiY: single): TD2D1_BITMAP_PROPERTIES;
var
    a: TD2D1_BITMAP_PROPERTIES;
begin
    a.pixelFormat := PixelFormat();
    a.dpiX := dpiX;
    a.dpiY := dpiY;
    Result := a;
end;



function RenderTargetProperties(targetType: TD2D1_RENDER_TARGET_TYPE; APixelFormat: PD2D1_PIXEL_FORMAT; dpiX: single; dpiY: single; usage: TD2D1_RENDER_TARGET_USAGE; minLevel: TD2D1_FEATURE_LEVEL): TD2D1_RENDER_TARGET_PROPERTIES;
var
    a: TD2D1_RENDER_TARGET_PROPERTIES;
    b: TD2D1_PIXEL_FORMAT;
begin
    a.targetType := targetType;
    if ApixelFormat <> nil then
        a.pixelFormat := ApixelFormat^
    else
    begin
        b := PixelFormat();
        a.pixelFormat.alphaMode := b.alphaMode;
        a.pixelFormat.format := b.format;
    end;
    a.dpiX := dpiX;
    a.dpiY := dpiY;
    a.usage := usage;
    a.minLevel := minLevel;
    Result := a;
end;

function RenderTargetProperties_(pixelFormat: TD2D1_PIXEL_FORMAT; targetType: TD2D1_RENDER_TARGET_TYPE; dpiX: single; dpiY: single; usage: TD2D1_RENDER_TARGET_USAGE; minLevel: TD2D1_FEATURE_LEVEL): TD2D1_RENDER_TARGET_PROPERTIES;
var
    a: TD2D1_RENDER_TARGET_PROPERTIES;
begin
    a.targetType := targetType;
    a.pixelFormat := pixelFormat;
    a.dpiX := dpiX;
    a.dpiY := dpiY;
    a.usage := usage;
    a.minLevel := minLevel;
    Result := a;
end;




function HwndRenderTargetProperties(hwnd: HWND; pixelSize: TD2D1_SIZE_U; presentOptions: TD2D1_PRESENT_OPTIONS): TD2D1_HWND_RENDER_TARGET_PROPERTIES;
var
    a: TD2D1_HWND_RENDER_TARGET_PROPERTIES;
begin
    a.hwnd := hwnd;
    a.pixelSize := pixelSize;
    a.presentOptions := presentOptions;
    Result := a;
end;


function HwndRenderTargetProperties(hwnd: HWND; presentOptions: TD2D1_PRESENT_OPTIONS): TD2D1_HWND_RENDER_TARGET_PROPERTIES;
var
    a: TD2D1_HWND_RENDER_TARGET_PROPERTIES;
begin
    a.hwnd := hwnd;
    a.pixelSize := Size(uint32(0), uint32(0));
    a.presentOptions := presentOptions;
    Result := a;
end;

function LayerParameters(contentBounds: PD2D1_RECT_F; geometricMask: ID2D1Geometry; maskAntialiasMode: TD2D1_ANTIALIAS_MODE; maskTransform: PD2D1_MATRIX_3X2_F; opacity: single;
    opacityBrush: ID2D1Brush; layerOptions: TD2D1_LAYER_OPTIONS): TD2D1_LAYER_PARAMETERS;
var
    a: TD2D1_LAYER_PARAMETERS;
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


function LayerParameters(geometricMask: ID2D1Geometry; maskAntialiasMode: TD2D1_ANTIALIAS_MODE; opacity: single; opacityBrush: ID2D1Brush; layerOptions: TD2D1_LAYER_OPTIONS): TD2D1_LAYER_PARAMETERS;
var
    a: TD2D1_LAYER_PARAMETERS;
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

function DrawingStateDescription(antialiasMode: TD2D1_ANTIALIAS_MODE; textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE; tag1: TD2D1_TAG; tag2: TD2D1_TAG; transform: PD2D1_MATRIX_3X2_F): TD2D1_DRAWING_STATE_DESCRIPTION;
var
    a: TD2D1_DRAWING_STATE_DESCRIPTION;
begin
    a.antialiasMode := antialiasMode;
    a.textAntialiasMode := textAntialiasMode;
    a.tag1 := tag1;
    a.tag2 := tag2;
    if transform <> nil then
        a.transform := transform^
    else
        a.transform.Identity;
    Result := a;
end;

function DrawingStateDescription(transform: TD2D1_MATRIX_3X2_F; antialiasMode: TD2D1_ANTIALIAS_MODE; textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE; tag1: TD2D1_TAG; tag2: TD2D1_TAG): TD2D1_DRAWING_STATE_DESCRIPTION;
var
    a: TD2D1_DRAWING_STATE_DESCRIPTION;
begin
    a.antialiasMode := antialiasMode;
    a.textAntialiasMode := textAntialiasMode;
    a.tag1 := tag1;
    a.tag2 := tag2;
    a.transform := transform;
    Result := a;
end;

function DrawingStateDescription(antialiasMode: TD2D1_ANTIALIAS_MODE; textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE; tag1: TD2D1_TAG; tag2: TD2D1_TAG): TD2D1_DRAWING_STATE_DESCRIPTION;
var
    a: TD2D1_DRAWING_STATE_DESCRIPTION;
begin
    a.antialiasMode := antialiasMode;
    a.textAntialiasMode := textAntialiasMode;
    a.tag1 := tag1;
    a.tag2 := tag2;
    a.transform := IdentityMatrix();
    Result := a;
end;

function ColorF(rgb: uint32; a: single): TD2D1_COLOR_F;
var
    c: TD2D1_COLOR_F;
begin
    c.Init(rgb, a);
    Result := c;
end;

function ColorF(r, g, b: single; a: single): TD2D1_COLOR_F;
var
    c: TD2D1_COLOR_F;
begin
    c.r := r;
    c.g := g;
    c.b := b;
    c.a := a;
    Result := c;
end;

function SizeF(Width: single; Height: single): TD2D1_SIZE_F;
var
    a: TD2D1_SIZE_F;
begin
    a.Width := Width;
    a.Height := Height;
    Result := a;
end;



function Point2F(x: single; y: single): TD2D1_POINT_2F;
var
    a: TD2D1_POINT_2F;
begin
    a.x := x;
    a.y := y;
    Result := a;
end;

function Point2U(x: uint32; y: uint32): TD2D1_POINT_2U;
var
    a: TD2D1_POINT_2U;
begin
    a.x := x;
    a.y := y;
    Result := a;
end;

function Matrix3x2F_Rotation(angle: single; center: TD2D_POINT_2F): TD2D_MATRIX_3X2_F;
var
    a: TD2D_MATRIX_3X2_F;
begin
    a.Rotation(angle, @center);
    Result := a;
end;

function Matrix3x2F_Rotation(angle: single; x, y: single): TD2D_MATRIX_3X2_F;
var
    a: TD2D_MATRIX_3X2_F;
begin
    a.Rotation(angle, x, y);
    Result := a;
end;

function Matrix3x2F_Scale(size: TD2D_SIZE_F; center: TD2D_POINT_2F): TD2D_MATRIX_3X2_F;
var
    a: TD2D_MATRIX_3X2_F;
begin
    a.Scale(size, @center);
    Result := a;
end;

function Matrix3x2F_Scale(size: TD2D_SIZE_F): TD2D_MATRIX_3X2_F;
var
    a: TD2D_MATRIX_3X2_F;
begin
    a.Scale(size, @Point2F);
    Result := a;
end;

function Matrix3x2F_Scale(x, y: single; center: TD2D_POINT_2F): TD2D_MATRIX_3X2_F;
var
    a: TD2D_MATRIX_3X2_F;
begin
    a.Scale(x, y, @center);
    Result := a;
end;

function Matrix3x2F_Scale(x, y: single): TD2D_MATRIX_3X2_F;
var
    a: TD2D_MATRIX_3X2_F;
begin
    a.Scale(x, y, @Point2F);
    Result := a;
end;

function Matrix3x2F_Translation(x, y: single): TD2D_MATRIX_3X2_F;
var
    a: TD2D_MATRIX_3X2_F;
begin
    a.Translation(x, y);
    Result := a;
end;

{ TD2D1_COLOR_FHelper }

procedure TD2D1_COLOR_FHelper.ColorF(rgb: uint32; a: single);
begin
    Init(rgb, a);
end;



procedure TD2D1_COLOR_FHelper.ColorF(r, g, b: single; a: single);
begin
    self.r := r;
    self.g := g;
    self.b := b;
    self.a := a;
end;

{ TD2D_MATRIX_3X2_FHelper }


procedure TD2D_MATRIX_3X2_FHelper.Translation(size: TD2D1_SIZE_F);
begin
    self._11 := 1.0;
    self._12 := 0.0;
    self._21 := 0.0;
    self._22 := 1.0;
    self._31 := size.Width;
    self._32 := size.Height;
end;



procedure TD2D_MATRIX_3X2_FHelper.Translation(x, y: single);
begin
    self._11 := 1.0;
    self._12 := 0.0;
    self._21 := 0.0;
    self._22 := 1.0;
    self._31 := x;
    self._32 := y;
end;



procedure TD2D_MATRIX_3X2_FHelper.Scale(size: TD2D1_SIZE_F; center: PD2D1_POINT_2F);
var
    lCenter: TD2D1_POINT_2F;
begin
    if center <> nil then
        lCenter := center^;
    _11 := size.Width;
    _12 := 0.0;
    _21 := 0.0;
    _22 := size.Height;
    _31 := lCenter.x - size.Width * lCenter.x;
    _32 := lCenter.y - size.Height * lCenter.y;
end;



procedure TD2D_MATRIX_3X2_FHelper.Scale(x, y: single; center: PD2D1_POINT_2F);
var
    lCenter: TD2D1_POINT_2F;
begin
    if center <> nil then
        lCenter := center^;

    _11 := x;
    _12 := 0.0;
    _21 := 0.0;
    _22 := y;
    _31 := lCenter.x - x * lCenter.x;
    _32 := lCenter.y - y * lCenter.y;
end;


procedure TD2D_MATRIX_3X2_FHelper.Rotation(angle: single; center: PD2D1_POINT_2F);
var
    lCenter: TD2D1_POINT_2F;
begin
    if center <> nil then
        lCenter := center^;
    D2D1MakeRotateMatrix(angle, lCenter, @Self);
end;

procedure TD2D_MATRIX_3X2_FHelper.Rotation(angle: single; x, y: single);
var
    lCenter: TD2D1_POINT_2F;
begin
    lCenter.x := x;
    lCenter.y := y;
    D2D1MakeRotateMatrix(angle, lCenter, @Self);
end;

procedure TD2D_MATRIX_3X2_FHelper.Rotation(angle: single);
var
    lCenter: TD2D1_POINT_2F;
begin
    D2D1MakeRotateMatrix(angle, lCenter, @Self);
end;



procedure TD2D_MATRIX_3X2_FHelper.Skew(angleX, angleY: single; center: PD2D1_POINT_2F);
var
    lCenter: TD2D1_POINT_2F;
begin
    if center <> nil then
        lCenter := center^;
    D2D1MakeSkewMatrix(angleX, angleY, lCenter, @self);
end;

procedure TD2D_MATRIX_3X2_FHelper.Skew(angleX, angleY: single);
var
    lCenter: TD2D1_POINT_2F;
begin
    D2D1MakeSkewMatrix(angleX, angleY, lCenter, @self);
end;



function TD2D_MATRIX_3X2_FHelper.Determinant: single;
begin
    Result := (_11 * _22) - (_12 * _21);
end;



function TD2D_MATRIX_3X2_FHelper.IsInvertible: boolean;
begin
    Result := D2D1IsMatrixInvertible(@self);
end;



function TD2D_MATRIX_3X2_FHelper.Invert: boolean;
begin
    Result := D2D1InvertMatrix(@self);
end;



function TD2D_MATRIX_3X2_FHelper.IsIdentity: boolean;
begin
    Result := (_11 = 1.0) and (_12 = 0.0) and (_21 = 0.0) and (_22 = 1.0) and (_31 = 0.0) and (_32 = 0.0);
end;



procedure TD2D_MATRIX_3X2_FHelper.SetProduct(a, b: TD2D_MATRIX_3X2_F);
begin
    _11 := a._11 * b._11 + a._12 * b._21;
    _12 := a._11 * b._12 + a._12 * b._22;
    _21 := a._21 * b._11 + a._22 * b._21;
    _22 := a._21 * b._12 + a._22 * b._22;
    _31 := a._31 * b._11 + a._32 * b._21 + b._31;
    _32 := a._31 * b._12 + a._32 * b._22 + b._32;
end;



function TD2D_MATRIX_3X2_FHelper.TransformPoint(point: TD2D1_POINT_2F): TD2D1_POINT_2F;
begin
    Result.x := point.x * _11 + point.y * _21 + _31;
    Result.y := point.x * _12 + point.y * _22 + _32;
end;

end.
