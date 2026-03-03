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
  File name: D2D1.h
       D2D1_Helper.h
       D2D1_1.h
       D2D1_1Helper.h
       D2D1_2.h
       D2D1_2Helper.h
       D2D1_3Helper.h
       D2D1EffectAuthor.h
       D2D1Effects.h
       D2D1Effects_1.h
       D2DBaseTypes.h
       D2DErr.h

  Header version: 10.0.19041.0

  ************************************************************************** }

{$REGION 'Notes'}
{ **************************************************************************
  Use the DirectX libaries from CMC. They are NOT based on the JSB headers

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
  Also FPC supports BITPACKED RECORDS and INLINE functions in COM Interfaces.

  ************************************************************************** }
{$ENDREGION}

unit DX12.D2D1;

{$IFDEF FPC}
{$MODE delphi}{$H+}
//{$IF FPC_FULLVERSION >= 30101}
{$modeswitch typehelpers}{$H+}{$I-}
//{$ENDIF}
{$ENDIF}

interface

{$Z4}

uses
    Windows, Classes, SysUtils, DX12.DXGI, DX12.DCommon,
    DX12.D3DCommon, DX12.DWrite,
    DX12.WinCodec, ActiveX, DX12.DocumentTarget;

const
    D2D1_DLL = 'd2d1.dll';

  

const
  
    { D2D1_1.h }
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

    { D2D1EffectAuthor.h }
    IID_ID2D1VertexBuffer: TGUID = '{9b8b1336-00a5-4668-92b7-ced5d8bf9b7b}';
    IID_ID2D1ResourceTexture: TGUID = '{688d15c3-02b0-438d-b13a-d1b44c32c39a}';
    IID_ID2D1RenderInfo: TGUID = '{519ae1bd-d19a-420d-b849-364f594776b7}';
    IID_ID2D1DrawInfo: TGUID = '{693ce632-7f2f-45de-93fe-18d88b37aa21}';
    IID_ID2D1ComputeInfo: TGUID = '{5598b14b-9fd7-48b7-9bdb-8f0964eb38bc}';
    IID_ID2D1TransformNode: TGUID = '{b2efe1e7-729f-4102-949f-505fa21bf666}';
    IID_ID2D1TransformGraph: TGUID = '{13d29038-c3e6-4034-9081-13b53a417992}';
    IID_ID2D1Transform: TGUID = '{ef1a287d-342a-4f76-8fdb-da0d6ea9f92b}';
    IID_ID2D1DrawTransform: TGUID = '{36bfdcb6-9739-435d-a30d-a653beff6a6f}';
    IID_ID2D1ComputeTransform: TGUID = '{0d85573c-01e3-4f7d-bfd9-0d60608bf3c3}';
    IID_ID2D1AnalysisTransform: TGUID = '{0359dc30-95e6-4568-9055-27720d130e93}';
    IID_ID2D1SourceTransform: TGUID = '{db1800dd-0c34-4cf9-be90-31cc0a5653e1}';
    IID_ID2D1ConcreteTransform: TGUID = '{1a799d8a-69f7-4e4c-9fed-437ccc6684cc}';
    IID_ID2D1BlendTransform: TGUID = '{63ac0b32-ba44-450f-8806-7f4ca1ff2f1b}';
    IID_ID2D1BorderTransform: TGUID = '{4998735c-3a19-473c-9781-656847e3a347}';
    IID_ID2D1OffsetTransform: TGUID = '{3fe6adea-7643-4f53-bd14-a0ce63f24042}';
    IID_ID2D1BoundsAdjustmentTransform: TGUID = '{90f732e2-5092-4606-a819-8651970baccd}';
    IID_ID2D1EffectImpl: TGUID = '{a248fd3f-3e6c-4e63-9f03-7f68ecc91db9}';
    IID_ID2D1EffectContext: TGUID = '{3d9f916b-27dc-4ad7-b4f1-64945340f563}';

    { D2D1_2.h }
    IID_ID2D1GeometryRealization: TGUID = '{a16907d7-bc02-4801-99e8-8cf7f485f774}';
    IID_ID2D1DeviceContext1: TGUID = '{d37f57e4-6908-459f-a199-e72f24f79987}';
    IID_ID2D1Device1: TGUID = '{d21768e1-23a4-4823-a14b-7c3eba85d658}';
    IID_ID2D1Factory2: TGUID = '{94f81a73-9212-4376-9c58-b16a3a0d3992}';
    IID_ID2D1CommandSink1: TGUID = '{9eb767fd-4269-4467-b8c2-eb30cb305743}';


    { D2D1Effects.h }
    // Built in effect CLSIDs
    CLSID_D2D12DAffineTransform: TGUID = '{6AA97485-6354-4cfc-908C-E4A74F62C96C}';
    CLSID_D2D13DPerspectiveTransform: TGUID = '{C2844D0B-3D86-46e7-85BA-526C9240F3FB}';
    CLSID_D2D13DTransform: TGUID = '{e8467b04-ec61-4b8a-b5de-d4d73debea5a}';
    CLSID_D2D1ArithmeticComposite: TGUID = '{fc151437-049a-4784-a24a-f1c4daf20987}';
    CLSID_D2D1Atlas: TGUID = '{913e2be4-fdcf-4fe2-a5f0-2454f14ff408}';
    CLSID_D2D1BitmapSource: TGUID = '{5fb6c24d-c6dd-4231-9404-50f4d5c3252d}';
    CLSID_D2D1Blend: TGUID = '{81c5b77b-13f8-4cdd-ad20-c890547ac65d}';
    CLSID_D2D1Border: TGUID = '{2A2D49C0-4ACF-43c7-8C6A-7C4A27874D27}';
    CLSID_D2D1Brightness: TGUID = '{8cea8d1e-77b0-4986-b3b9-2f0c0eae7887}';
    CLSID_D2D1ColorManagement: TGUID = '{1A28524C-FDD6-4AA4-AE8F-837EB8267B37}';
    CLSID_D2D1ColorMatrix: TGUID = '{921F03D6-641C-47DF-852D-B4BB6153AE11}';
    CLSID_D2D1Composite: TGUID = '{48fc9f51-f6ac-48f1-8b58-3b28ac46f76d}';
    CLSID_D2D1ConvolveMatrix: TGUID = '{407f8c08-5533-4331-a341-23cc3877843e}';
    CLSID_D2D1Crop: TGUID = '{E23F7110-0E9A-4324-AF47-6A2C0C46F35B}';
    CLSID_D2D1DirectionalBlur: TGUID = '{174319a6-58e9-49b2-bb63-caf2c811a3db}';
    CLSID_D2D1DiscreteTransfer: TGUID = '{90866fcd-488e-454b-af06-e5041b66c36c}';
    CLSID_D2D1DisplacementMap: TGUID = '{edc48364-0417-4111-9450-43845fa9f890}';
    CLSID_D2D1DistantDiffuse: TGUID = '{3e7efd62-a32d-46d4-a83c-5278889ac954}';
    CLSID_D2D1DistantSpecular: TGUID = '{428c1ee5-77b8-4450-8ab5-72219c21abda}';
    CLSID_D2D1DpiCompensation: TGUID = '{6c26c5c7-34e0-46fc-9cfd-e5823706e228}';
    CLSID_D2D1Flood: TGUID = '{61c23c20-ae69-4d8e-94cf-50078df638f2}';
    CLSID_D2D1GammaTransfer: TGUID = '{409444c4-c419-41a0-b0c1-8cd0c0a18e42}';
    CLSID_D2D1GaussianBlur: TGUID = '{1feb6d69-2fe6-4ac9-8c58-1d7f93e7a6a5}';
    CLSID_D2D1Scale: TGUID = '{9daf9369-3846-4d0e-a44e-0c607934a5d7}';
    CLSID_D2D1Histogram: TGUID = '{881db7d0-f7ee-4d4d-a6d2-4697acc66ee8}';
    CLSID_D2D1HueRotation: TGUID = '{0f4458ec-4b32-491b-9e85-bd73f44d3eb6}';
    CLSID_D2D1LinearTransfer: TGUID = '{ad47c8fd-63ef-4acc-9b51-67979c036c06}';
    CLSID_D2D1LuminanceToAlpha: TGUID = '{41251ab7-0beb-46f8-9da7-59e93fcce5de}';
    CLSID_D2D1Morphology: TGUID = '{eae6c40d-626a-4c2d-bfcb-391001abe202}';
    CLSID_D2D1OpacityMetadata: TGUID = '{6c53006a-4450-4199-aa5b-ad1656fece5e}';
    CLSID_D2D1PointDiffuse: TGUID = '{b9e303c3-c08c-4f91-8b7b-38656bc48c20}';
    CLSID_D2D1PointSpecular: TGUID = '{09c3ca26-3ae2-4f09-9ebc-ed3865d53f22}';
    CLSID_D2D1Premultiply: TGUID = '{06eab419-deed-4018-80d2-3e1d471adeb2}';
    CLSID_D2D1Saturation: TGUID = '{5cb2d9cf-327d-459f-a0ce-40c0b2086bf7}';
    CLSID_D2D1Shadow: TGUID = '{C67EA361-1863-4e69-89DB-695D3E9A5B6B}';
    CLSID_D2D1SpotDiffuse: TGUID = '{818a1105-7932-44f4-aa86-08ae7b2f2c93}';
    CLSID_D2D1SpotSpecular: TGUID = '{edae421e-7654-4a37-9db8-71acc1beb3c1}';
    CLSID_D2D1TableTransfer: TGUID = '{5bf818c3-5e43-48cb-b631-868396d6a1d4}';
    CLSID_D2D1Tile: TGUID = '{B0784138-3B76-4bc5-B13B-0FA2AD02659F}';
    CLSID_D2D1Turbulence: TGUID = '{CF2BB6AE-889A-4ad7-BA29-A2FD732C9FC9}';
    CLSID_D2D1UnPremultiply: TGUID = '{fb9ac489-ad8d-41ed-9999-bb6347d110f7}';

    { D2D1Effects_1.h }
    // Built in effect CLSIDs
    CLSID_D2D1YCbCr: TGUID = '{99503cc1-66c7-45c9-a875-8ad8a7914401}';




    

type

    

    

    

  
   

  

   

    

    { TD2D_MATRIX_3X2_F }

    TD2D_MATRIX_3X2_F = record
        

       
        
        
      
       
             

   

   
type
      

      


    { D2D1.h }

   



    


function _D2D1CreateFactory(factoryType: TD2D1_FACTORY_TYPE; const riid: TGUID; out factory): HResult; stdcall; overload;
{$IFDEF FPC}
function _D2D1CreateFactory <TFactory>(factoryType: TD2D1_FACTORY_TYPE; out factory): HResult;
    stdcall; overload;


function _D2D1CreateFactory  <TFactory>(factoryType: TD2D1_FACTORY_TYPE; const factoryOptions: TD2D1_FACTORY_OPTIONS; out Factory): HResult;
    stdcall; overload;
{$ENDIF}

{ D2D1 Helper functions }




{ D2D1_1Helper.h }




implementation



function D2D1CreateDevice(dxgiDevice: IDXGIDevice; const creationProperties: TD2D1_CREATION_PROPERTIES;
    out d2dDevice: ID2D1Device): HResult; overload;
begin
    Result := D2D1CreateDevice(dxgiDevice, @creationProperties, d2dDevice);
end;



function D2D1CreateDeviceContext(dxgiSurface: IDXGISurface; const creationProperties: TD2D1_CREATION_PROPERTIES;
    out d2dDeviceContext: ID2D1DeviceContext): HResult; overload;
begin
    Result := D2D1CreateDeviceContext(dxgiSurface, @creationProperties, d2dDeviceContext);
end;



function _D2D1CreateFactory(factoryType: TD2D1_FACTORY_TYPE; const riid: TGUID; out factory): HResult; stdcall;
begin
    Result :=
        D2D1CreateFactory(factoryType, riid, nil, factory);
end;


{$IFDEF FPC}
function _D2D1CreateFactory<TFactory>(factoryType: TD2D1_FACTORY_TYPE; out factory): HResult; stdcall;
var
    lGUID: TGUID;
begin
    lGUID := TFactory;
    Result :=
        _D2D1CreateFactory(factoryType, lGUID, factory);
end;



function _D2D1CreateFactory<TFactory>(factoryType: TD2D1_FACTORY_TYPE; const factoryOptions: TD2D1_FACTORY_OPTIONS; out Factory): HResult; stdcall;
var
    lGUID: TGUID;
begin
    lGUID := TFactory;
    Result :=
        D2D1CreateFactory(factoryType, lGUID, @factoryOptions, Factory);
end;
{$ENDIF}



function FloatMax: single;
begin
    Result := 3.402823466e+38;
end;





function PixelFormat(dxgiFormat: TDXGI_FORMAT; alphaMode: TD2D1_ALPHA_MODE): TD2D1_PIXEL_FORMAT;
begin
    Result.format := dxgiFormat;
    Result.alphaMode := alphaMode;
end;



function RenderTargetProperties(pixelFormat: TD2D1_PIXEL_FORMAT; _type: TD2D1_RENDER_TARGET_TYPE; dpiX: single;
    dpiY: single; usage: TD2D1_RENDER_TARGET_USAGE; minLevel: TD2D1_FEATURE_LEVEL): TD2D1_RENDER_TARGET_PROPERTIES;
begin
    
end;



function RenderTargetProperties(_type: TD2D1_RENDER_TARGET_TYPE; dpiX: single; dpiY: single; usage: TD2D1_RENDER_TARGET_USAGE;
    minLevel: TD2D1_FEATURE_LEVEL): TD2D1_RENDER_TARGET_PROPERTIES;
begin
    
end;



function HwndRenderTargetProperties(hwnd: HWND; pixelSize: TD2D1_SIZE_U; presentOptions: TD2D1_PRESENT_OPTIONS): TD2D1_HWND_RENDER_TARGET_PROPERTIES;
begin
    Result.hwnd := hwnd;
    Result.pixelSize := pixelSize;
    Result.presentOptions := presentOptions;
end;



function HwndRenderTargetProperties(hwnd: HWND; presentOptions: TD2D1_PRESENT_OPTIONS): TD2D1_HWND_RENDER_TARGET_PROPERTIES;
begin
    
end;



function ColorF(rgb: uint32; a: single): TD2D1_COLOR_F;
begin
    
end;



function ColorF(r, g, b: single; a: single): TD2D1_COLOR_F;
begin
   
end;



function SizeF(Width: single; Height: single): TD2D1_SIZE_F;
begin
    
end;



function Point2F(x: single; y: single): TD2D1_POINT_2F;
begin
    
end;



function Point2U(x: uint32; y: uint32): TD2D1_POINT_2U;
begin
    
end;



function ArcSegment(point: TD2D1_POINT_2F; size: TD2D1_SIZE_F; rotationAngle: single; sweepDirection: TD2D1_SWEEP_DIRECTION;
    arcSize: TD2D1_ARC_SIZE): TD2D1_ARC_SEGMENT;
begin
    Result.arcSize := arcSize;
    Result.point := point;
    Result.rotationAngle := rotationAngle;
    Result.sweepDirection := sweepDirection;
    Result.size := size;
end;



function BezierSegment(point1: TD2D1_POINT_2F; point2: TD2D1_POINT_2F; point3: TD2D1_POINT_2F): TD2D1_BEZIER_SEGMENT;
begin
    Result.point1 := point1;
    Result.point2 := point2;
    Result.point3 := point3;
end;



function Ellipse(center: TD2D1_POINT_2F; radiusX: single; radiusY: single): TD2D1_ELLIPSE;
begin
    Result.point := center;
    Result.radiusX := radiusX;
    Result.radiusY := radiusY;
end;



function RoundedRect(rect: TD2D1_RECT_F; radiusX: single; radiusY: single): TD2D1_ROUNDED_RECT;
begin
    Result.rect := rect;
    Result.radiusX := radiusX;
    Result.radiusY := radiusy;
end;



function BrushProperties(transform: TD2D1_MATRIX_3X2_F; opacity: single): TD2D1_BRUSH_PROPERTIES;
begin
    Result.opacity := opacity;
    Result.transform := transform;
end;



function BrushProperties(opacity: single): TD2D1_BRUSH_PROPERTIES;
begin
    Result.opacity := opacity;
    Result.transform := IdentityMatrix();
end;



function GradientStop(position: single; color: TD2D1_COLOR_F): TD2D1_GRADIENT_STOP;
begin
    Result.color := color;
    Result.position := position;
end;



function QuadraticBezierSegment(point1: TD2D1_POINT_2F; point2: TD2D1_POINT_2F): TD2D1_QUADRATIC_BEZIER_SEGMENT;
begin
    Result.point1 := point1;
    Result.point2 := point2;
end;



function StrokeStyleProperties(startCap: TD2D1_CAP_STYLE; endCap: TD2D1_CAP_STYLE; dashCap: TD2D1_CAP_STYLE;
    lineJoin: TD2D1_LINE_JOIN; miterLimit: single; dashStyle: TD2D1_DASH_STYLE; dashOffset: single): TD2D1_STROKE_STYLE_PROPERTIES;
begin
    Result.startCap := startCap;
    Result.endCap := endCap;
    Result.dashCap := dashCap;
    Result.lineJoin := lineJoin;
    Result.miterLimit := miterLimit;
    Result.dashStyle := dashStyle;
    Result.dashOffset := dashOffset;
end;



function BitmapBrushProperties(extendModeX: TD2D1_EXTEND_MODE; extendModeY: TD2D1_EXTEND_MODE;
    interpolationMode: TD2D1_BITMAP_INTERPOLATION_MODE): TD2D1_BITMAP_BRUSH_PROPERTIES;
begin
    Result.extendModeX := extendModeX;
    Result.extendModeY := extendModeY;
    Result.interpolationMode := interpolationMode;
end;



function LinearGradientBrushProperties(startPoint: TD2D1_POINT_2F; endPoint: TD2D1_POINT_2F): TD2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES;
begin
    Result.startPoint := startPoint;
    Result.endPoint := endPoint;
end;



function RadialGradientBrushProperties(center: TD2D1_POINT_2F; gradientOriginOffset: TD2D1_POINT_2F; radiusX: single;
    radiusY: single): TD2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES;
begin
    Result.center := center;
    Result.gradientOriginOffset := gradientOriginOffset;
    Result.radiusX := radiusX;
    Result.radiusY := radiusY;
end;



function BitmapProperties(pixelFormat: TD2D1_PIXEL_FORMAT; dpiX: single; dpiY: single): TD2D1_BITMAP_PROPERTIES;
begin
    Result.pixelFormat := pixelFormat;
    Result.dpiX := dpiX;
    Result.dpiY := dpiY;
end;



function BitmapProperties(dpiX: single; dpiY: single): TD2D1_BITMAP_PROPERTIES;
begin
    
end;



function LayerParameters(contentBounds: TD2D1_RECT_F; maskTransform: TD2D1_MATRIX_3X2_F; geometricMask: ID2D1Geometry;
    maskAntialiasMode: TD2D1_ANTIALIAS_MODE; opacity: single; opacityBrush: ID2D1Brush; layerOptions: TD2D1_LAYER_OPTIONS): TD2D1_LAYER_PARAMETERS;
begin
    Result.contentBounds := contentBounds;
    Result.geometricMask := geometricMask;
    Result.maskAntialiasMode := maskAntialiasMode;
    Result.maskTransform := maskTransform;
    Result.opacity := opacity;
    Result.opacityBrush := opacityBrush;
    Result.layerOptions := layerOptions;
end;



function LayerParameters(geometricMask: ID2D1Geometry; maskAntialiasMode: TD2D1_ANTIALIAS_MODE; opacity: single;
    opacityBrush: ID2D1Brush; layerOptions: TD2D1_LAYER_OPTIONS): TD2D1_LAYER_PARAMETERS;
begin
    
end;



function DrawingStateDescription(transform: TD2D1_MATRIX_3X2_F; antialiasMode: TD2D1_ANTIALIAS_MODE;
    textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE; tag1: TD2D1_TAG; tag2: TD2D1_TAG): TD2D1_DRAWING_STATE_DESCRIPTION;
begin
    
end;



function DrawingStateDescription(antialiasMode: TD2D1_ANTIALIAS_MODE; textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE;
    tag1: TD2D1_TAG; tag2: TD2D1_TAG): TD2D1_DRAWING_STATE_DESCRIPTION;
begin
    
end;



function Matrix3x2F_Rotation(angle: single; center: TD2D_POINT_2F): TD2D_MATRIX_3X2_F;
begin
   
end;



function Matrix3x2F_Rotation(angle: single; x, y: single): TD2D_MATRIX_3X2_F;
begin
   
end;



function Matrix3x2F_Scale(size: TD2D_SIZE_F; center: TD2D_POINT_2F): TD2D_MATRIX_3X2_F;
begin
    
end;



function Matrix3x2F_Scale(size: TD2D_SIZE_F): TD2D_MATRIX_3X2_F;
begin
    
end;



function Matrix3x2F_Scale(x, y: single; center: TD2D_POINT_2F): TD2D_MATRIX_3X2_F;
begin
    
end;



function Matrix3x2F_Scale(x, y: single): TD2D_MATRIX_3X2_F;
begin
    
end;



function Matrix3x2F_Translation(x, y: single): TD2D_MATRIX_3X2_F;
begin
    
end;



function IdentityMatrix: TD2D1_MATRIX_3X2_F;
begin
    Result.Identity;
end;



function ConvertColorSpace(sourceColorSpace: TD2D1_COLOR_SPACE; destinationColorSpace: TD2D1_COLOR_SPACE; color: TD2D1_COLOR_F): TD2D1_COLOR_F;
begin
    Result := D2D1ConvertColorSpace(sourceColorSpace, destinationColorSpace, @color);
end;



function DrawingStateDescription1(transform: TD2D1_MATRIX_3X2_F; antialiasMode: TD2D1_ANTIALIAS_MODE;
    textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE; tag1: TD2D1_TAG; tag2: TD2D1_TAG; primitiveBlend: TD2D1_PRIMITIVE_BLEND;
    unitMode: TD2D1_UNIT_MODE): TD2D1_DRAWING_STATE_DESCRIPTION1;
begin
    
end;



function DrawingStateDescription1(antialiasMode: TD2D1_ANTIALIAS_MODE; textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE;
    tag1: TD2D1_TAG; tag2: TD2D1_TAG; primitiveBlend: TD2D1_PRIMITIVE_BLEND; unitMode: TD2D1_UNIT_MODE): TD2D1_DRAWING_STATE_DESCRIPTION1;
begin
   
end;



function DrawingStateDescription1(desc: TD2D1_DRAWING_STATE_DESCRIPTION; primitiveBlend: TD2D1_PRIMITIVE_BLEND;
    unitMode: TD2D1_UNIT_MODE): TD2D1_DRAWING_STATE_DESCRIPTION1;
begin
    Result.antialiasMode := desc.antialiasMode;
    Result.textAntialiasMode := desc.textAntialiasMode;
    Result.tag1 := desc.tag1;
    Result.tag2 := desc.tag2;
    Result.transform := desc.transform;
    Result.primitiveBlend := primitiveBlend;
    Result.unitMode := unitMode;
end;



function BitmapProperties1(pixelFormat: TD2D1_PIXEL_FORMAT; bitmapOptions: TD2D1_BITMAP_OPTIONS = D2D1_BITMAP_OPTIONS_NONE;
    dpiX: single = 96.0; dpiY: single = 96.0; colorContext: ID2D1ColorContext = nil): TD2D1_BITMAP_PROPERTIES1;
{function BitmapProperties1(pixelFormat: TD2D1_PIXEL_FORMAT; bitmapOptions: TD2D1_BITMAP_OPTIONS; dpiX: single; dpiY: single;
    colorContext: ID2D1ColorContext = nil): TD2D1_BITMAP_PROPERTIES1; }
begin
    
end;



function BitmapProperties1(bitmapOptions: TD2D1_BITMAP_OPTIONS; dpiX: single; dpiY: single;
    colorContext: ID2D1ColorContext): TD2D1_BITMAP_PROPERTIES1;
begin
    
end;



function LayerParameters1(contentBounds: TD2D1_RECT_F; maskTransform: TD2D1_MATRIX_3X2_F; geometricMask: ID2D1Geometry;
    maskAntialiasMode: TD2D1_ANTIALIAS_MODE; opacity: single; opacityBrush: ID2D1Brush; layerOptions: TD2D1_LAYER_OPTIONS1): TD2D1_LAYER_PARAMETERS1;
begin
   
end;



function LayerParameters1(geometricMask: ID2D1Geometry; maskAntialiasMode: TD2D1_ANTIALIAS_MODE; opacity: single;
    opacityBrush: ID2D1Brush; layerOptions: TD2D1_LAYER_OPTIONS1): TD2D1_LAYER_PARAMETERS1;
begin
    
end;



function StrokeStyleProperties1(startCap: TD2D1_CAP_STYLE; endCap: TD2D1_CAP_STYLE; dashCap: TD2D1_CAP_STYLE;
    lineJoin: TD2D1_LINE_JOIN; miterLimit: single; dashStyle: TD2D1_DASH_STYLE; dashOffset: single;
    transformType: TD2D1_STROKE_TRANSFORM_TYPE): TD2D1_STROKE_STYLE_PROPERTIES1;
begin
    Result.startCap := startCap;
    Result.endCap := endCap;
    Result.dashCap := dashCap;
    Result.lineJoin := lineJoin;
    Result.miterLimit := miterLimit;
    Result.dashStyle := dashStyle;
    Result.dashOffset := dashOffset;
    Result.transformType := transformType;
end;



function ImageBrushProperties(sourceRectangle: TD2D1_RECT_F; extendModeX: TD2D1_EXTEND_MODE; extendModeY: TD2D1_EXTEND_MODE;
    interpolationMode: TD2D1_INTERPOLATION_MODE): TD2D1_IMAGE_BRUSH_PROPERTIES;
begin
    Result.extendModeX := extendModeX;
    Result.extendModeY := extendModeY;
    Result.interpolationMode := interpolationMode;
    Result.sourceRectangle := sourceRectangle;
end;



function BitmapBrushProperties1(extendModeX: TD2D1_EXTEND_MODE; extendModeY: TD2D1_EXTEND_MODE;
    interpolationMode: TD2D1_INTERPOLATION_MODE): TD2D1_BITMAP_BRUSH_PROPERTIES1;
begin
    Result.extendModeX := extendModeX;
    Result.extendModeY := extendModeY;
    Result.interpolationMode := interpolationMode;
end;



function PrintControlProperties(fontSubsetMode: TD2D1_PRINT_FONT_SUBSET_MODE; rasterDpi: single;
    colorSpace: TD2D1_COLOR_SPACE): TD2D1_PRINT_CONTROL_PROPERTIES;
begin
    Result.fontSubset := fontSubsetMode;
    Result.rasterDPI := rasterDpi;
    Result.colorSpace := colorSpace;
end;



function RenderingControls(bufferPrecision: TD2D1_BUFFER_PRECISION; tileSize: TD2D1_SIZE_U): TD2D1_RENDERING_CONTROLS;
begin
    Result.bufferPrecision := bufferPrecision;
    Result.tileSize := tileSize;
end;



function EffectInputDescription(effect: ID2D1Effect; inputIndex: uint32; inputRectangle: TD2D1_RECT_F): TD2D1_EFFECT_INPUT_DESCRIPTION;
begin
    Result.effect := effect;
    Result.inputIndex := inputIndex;
    Result.inputRectangle := inputRectangle;
end;



function CreationProperties(threadingMode: TD2D1_THREADING_MODE; debugLevel: TD2D1_DEBUG_LEVEL;
    options: TD2D1_DEVICE_CONTEXT_OPTIONS): TD2D1_CREATION_PROPERTIES;
begin
    Result.threadingMode := threadingMode;
    Result.debugLevel := debugLevel;
    Result.options := options;
end;



function Vector2F(x: single; y: single): TD2D1_VECTOR_2F;
begin
   
end;



function Vector3F(x: single; y: single; z: single): TD2D1_VECTOR_3F;
begin
    
end;



function Vector4F(x: single; y: single; z: single; w: single): TD2D1_VECTOR_4F;
begin
    
end;



function Point2L(x: int32; y: int32): TD2D1_POINT_2L;
begin
    
end;



function RectL(left: int32; top: int32; right: int32; bottom: int32): TD2D1_RECT_L;
begin
   
end;



function SetDpiCompensatedEffectInput(deviceContext: ID2D1DeviceContext; effect: ID2D1Effect; inputIndex: uint32;
    inputBitmap: ID2D1Bitmap; interpolationMode: TD2D1_INTERPOLATION_MODE; borderMode: TD2D1_BORDER_MODE): HRESULT;
var
    dpiCompensationEffect: ID2D1Effect;
    bitmapDpi: TD2D1_POINT_2F;



    procedure SetInputEffect(index: uint32; inputEffect: ID2D1Effect = nil; invalidate: longbool = True);
    var
        output: ID2D1Image;
    begin
        output := nil;
        if (inputEffect <> nil) then
        begin
            inputEffect.GetOutput(output);
        end;
        effect.SetInput(index, output, invalidate);
        if (output <> nil) then
            Output := nil;
    end;

begin
    Result := S_OK;
    dpiCompensationEffect := nil;

    if (inputBitmap = nil) then
    begin
        effect.SetInput(inputIndex, nil);
        exit;
    end;

    Result := deviceContext.CreateEffect(CLSID_D2D1DpiCompensation, dpiCompensationEffect);

    if (SUCCEEDED(Result)) then
    begin
        dpiCompensationEffect.SetInput(0, inputBitmap);
        inputBitmap.GetDpi(bitmapDpi.x, bitmapDpi.y);
        Result := dpiCompensationEffect.SetValue(Ord(D2D1_DPICOMPENSATION_PROP_INPUT_DPI), D2D1_PROPERTY_TYPE_UNKNOWN,
            @bitmapDpi, sizeOf(bitmapDpi));
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := dpiCompensationEffect.SetValue(Ord(D2D1_DPICOMPENSATION_PROP_INTERPOLATION_MODE), D2D1_PROPERTY_TYPE_UNKNOWN,
            @interpolationMode, sizeOf(interpolationMode));
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := dpiCompensationEffect.SetValue(Ord(D2D1_DPICOMPENSATION_PROP_BORDER_MODE), D2D1_PROPERTY_TYPE_UNKNOWN,
            @borderMode, sizeOf(borderMode));
    end;

    if (SUCCEEDED(Result)) then
    begin
        {effect.}SetInputEffect(inputIndex, dpiCompensationEffect);
    end;

    if (dpiCompensationEffect <> nil) then
    begin
        dpiCompensationEffect := nil;
    end;
end;



function ComputeFlatteningTolerance(matrix: TD2D1_MATRIX_3X2_F; dpiX: single; dpiY: single; maxZoomFactor: single): single;
var
    dpiDependentTransform: TD2D1_MATRIX_3X2_F;
    absMaxZoomFactor: single;
begin
    dpiDependentTransform :=
        matrix * DX12.D2D1.Matrix3x2F_Scale(dpiX / 96.0, dpiY / 96.0);
    if (maxZoomFactor > 0) then
        absMaxZoomFactor := maxZoomFactor
    else
        absMaxZoomFactor := -maxZoomFactor;
    Result := D2D1_DEFAULT_FLATTENING_TOLERANCE / (absMaxZoomFactor * D2D1ComputeMaximumScaleFactor(dpiDependentTransform));
end;

{ ID2D1Factory1Helper }

function ID2D1Factory1Helper.CreateStrokeStyle(const strokeStyleProperties: TD2D1_STROKE_STYLE_PROPERTIES1;
    const dashes: Psingle; dashesCount: uint32; out strokeStyle: ID2D1StrokeStyle1): HResult; stdcall;
begin
    Result := CreateStrokeStyle(@strokeStyleProperties, dashes, dashesCount, strokeStyle);
end;



function ID2D1Factory1Helper.CreateDrawingStateBlock(const drawingStateDescription: TD2D1_DRAWING_STATE_DESCRIPTION1;
    out drawingStateBlock: ID2D1DrawingStateBlock1): HResult; stdcall;
begin
    Result := CreateDrawingStateBlock(@drawingStateDescription, nil, drawingStateBlock);
end;



function ID2D1Factory1Helper.CreateDrawingStateBlock(out drawingStateBlock: ID2D1DrawingStateBlock1): HResult; stdcall;
begin
    Result := CreateDrawingStateBlock(nil, nil, drawingStateBlock);
end;

{ ID2D1DeviceHelper }

function ID2D1DeviceHelper.CreatePrintControl(wicFactory: IWICImagingFactory; documentTarget: IPrintDocumentPackageTarget;
    const printControlProperties: TD2D1_PRINT_CONTROL_PROPERTIES; out printControl: ID2D1PrintControl): HResult; stdcall;
begin
    Result := CreatePrintControl(wicFactory, documentTarget, @printControlProperties, printControl);
end;

{ ID2D1DeviceContextHelper }

function ID2D1DeviceContextHelper.CreateBitmap(size: TD2D1_SIZE_U; const sourceData: pointer; pitch: uint32;
    const bitmapProperties: TD2D1_BITMAP_PROPERTIES1; out bitmap: ID2D1Bitmap1): HResult; stdcall;
begin
    Result := CreateBitmap(size, sourceData, pitch, @bitmapProperties, bitmap);
end;



function ID2D1DeviceContextHelper.CreateBitmapFromWicBitmap(wicBitmapSource: IWICBitmapSource;
    const bitmapProperties: TD2D1_BITMAP_PROPERTIES1; out bitmap: ID2D1Bitmap1): HResult; stdcall;
begin
    Result := CreateBitmapFromWicBitmap(wicBitmapSource, @bitmapProperties, bitmap);
end;



function ID2D1DeviceContextHelper.CreateBitmapFromWicBitmap(wicBitmapSource: IWICBitmapSource; out bitmap: ID2D1Bitmap1): HResult;
    stdcall;
begin
    Result := CreateBitmapFromWicBitmap(wicBitmapSource, nil, bitmap);
end;



function ID2D1DeviceContextHelper.CreateBitmapFromDxgiSurface(surface: IDXGISurface; const bitmapProperties: TD2D1_BITMAP_PROPERTIES1;
    out bitmap: ID2D1Bitmap1): HResult; stdcall;
begin
    Result := CreateBitmapFromDxgiSurface(surface, @bitmapProperties, bitmap);
end;



function ID2D1DeviceContextHelper.CreateImageBrush(image: ID2D1Image; const imageBrushProperties: TD2D1_IMAGE_BRUSH_PROPERTIES;
    const brushProperties: TD2D1_BRUSH_PROPERTIES; out imageBrush: ID2D1ImageBrush): HResult; stdcall;
begin
    Result := CreateImageBrush(image, @imageBrushProperties, @brushProperties, imageBrush);
end;



function ID2D1DeviceContextHelper.CreateImageBrush(image: ID2D1Image; const imageBrushProperties: TD2D1_IMAGE_BRUSH_PROPERTIES;
    out imageBrush: ID2D1ImageBrush): HResult; stdcall;
begin
    Result := CreateImageBrush(image, @imageBrushProperties, nil, imageBrush);
end;



function ID2D1DeviceContextHelper.CreateBitmapBrush(bitmap: ID2D1Bitmap; out bitmapBrush: ID2D1BitmapBrush1): HResult; stdcall;
begin
    Result := CreateBitmapBrush(bitmap, nil, nil, bitmapBrush);
end;



function ID2D1DeviceContextHelper.CreateBitmapBrush(bitmap: ID2D1Bitmap; const bitmapBrushProperties: TD2D1_BITMAP_BRUSH_PROPERTIES1;
    out bitmapBrush: ID2D1BitmapBrush1): HResult; stdcall;
begin
    Result := CreateBitmapBrush(bitmap, @bitmapBrushProperties, nil, bitmapBrush);
end;



function ID2D1DeviceContextHelper.CreateBitmapBrush(bitmap: ID2D1Bitmap; const bitmapBrushProperties: TD2D1_BITMAP_BRUSH_PROPERTIES1;
    const brushProperties: TD2D1_BRUSH_PROPERTIES; out bitmapBrush: ID2D1BitmapBrush1): HResult; stdcall;
begin
    Result := CreateBitmapBrush(bitmap, @bitmapBrushProperties, @brushProperties, bitmapBrush);
end;



procedure ID2D1DeviceContextHelper.DrawImage(effect: ID2D1Effect; const targetOffset: PD2D1_POINT_2F;
    const imageRectangle: PD2D1_RECT_F; interpolationMode: TD2D1_INTERPOLATION_MODE; compositeMode: TD2D1_COMPOSITE_MODE); stdcall;
var
    output: ID2D1Image;
begin

    effect.GetOutput(&output);
    DrawImage(output, targetOffset, imageRectangle, interpolationMode, compositeMode);
    output := nil;
end;



procedure ID2D1DeviceContextHelper.DrawImage(image: ID2D1Image; interpolationMode: TD2D1_INTERPOLATION_MODE;
    compositeMode: TD2D1_COMPOSITE_MODE); stdcall;
begin
    DrawImage(image, nil, nil, interpolationMode, compositeMode);
end;



procedure ID2D1DeviceContextHelper.DrawImage(effect: ID2D1Effect; interpolationMode: TD2D1_INTERPOLATION_MODE;
    compositeMode: TD2D1_COMPOSITE_MODE); stdcall;
begin
    DrawImage(effect, nil, nil, interpolationMode, compositeMode);
end;



procedure ID2D1DeviceContextHelper.DrawImage(image: ID2D1Image; targetOffset: TD2D1_POINT_2F;
    interpolationMode: TD2D1_INTERPOLATION_MODE; compositeMode: TD2D1_COMPOSITE_MODE); stdcall;
begin
    DrawImage(image, @targetOffset, nil, interpolationMode, compositeMode);
end;



procedure ID2D1DeviceContextHelper.DrawImage(effect: ID2D1Effect; targetOffset: TD2D1_POINT_2F;
    interpolationMode: TD2D1_INTERPOLATION_MODE; compositeMode: TD2D1_COMPOSITE_MODE); stdcall;
begin
    DrawImage(effect, @targetOffset, nil, interpolationMode, compositeMode);
end;



procedure ID2D1DeviceContextHelper.DrawImage(image: ID2D1Image; targetOffset: TD2D1_POINT_2F; const imageRectangle: TD2D1_RECT_F;
    interpolationMode: TD2D1_INTERPOLATION_MODE; compositeMode: TD2D1_COMPOSITE_MODE); stdcall;
begin
    DrawImage(image, @targetOffset, @imageRectangle, interpolationMode, compositeMode);
end;



procedure ID2D1DeviceContextHelper.DrawImage(effect: ID2D1Effect; targetOffset: TD2D1_POINT_2F; const imageRectangle: TD2D1_RECT_F;
    interpolationMode: TD2D1_INTERPOLATION_MODE; compositeMode: TD2D1_COMPOSITE_MODE); stdcall;
begin
    DrawImage(effect, @targetOffset, @imageRectangle, interpolationMode, compositeMode);
end;



procedure ID2D1DeviceContextHelper.PushLayer(const layerParameters: TD2D1_LAYER_PARAMETERS1; layer: ID2D1Layer); stdcall;
begin
    PushLayer(@layerParameters, layer);
end;



procedure ID2D1DeviceContextHelper.DrawGdiMetafile(gdiMetafile: ID2D1GdiMetafile; targetOffset: TD2D1_POINT_2F); stdcall;
begin
    DrawGdiMetafile(gdiMetafile, @targetOffset);
end;



procedure ID2D1DeviceContextHelper.DrawBitmap(bitmap: ID2D1Bitmap; const destinationRectangle: TD2D1_RECT_F;
    opacity: single; interpolationMode: TD2D1_INTERPOLATION_MODE; const sourceRectangle: PD2D1_RECT_F;
    const perspectiveTransform: PD2D1_MATRIX_4X4_F); stdcall;
begin
    DrawBitmap(bitmap, @destinationRectangle, opacity, interpolationMode, sourceRectangle, perspectiveTransform);
end;



procedure ID2D1DeviceContextHelper.DrawBitmap(bitmap: ID2D1Bitmap; const destinationRectangle: TD2D1_RECT_F;
    opacity: single; interpolationMode: TD2D1_INTERPOLATION_MODE; const sourceRectangle: TD2D1_RECT_F;
    const perspectiveTransform: PD2D1_MATRIX_4X4_F); stdcall;
begin
    DrawBitmap(bitmap, @destinationRectangle, opacity, interpolationMode, @sourceRectangle, perspectiveTransform);
end;



procedure ID2D1DeviceContextHelper.DrawBitmap(bitmap: ID2D1Bitmap; const destinationRectangle: TD2D1_RECT_F;
    opacity: single; interpolationMode: TD2D1_INTERPOLATION_MODE; const sourceRectangle: TD2D1_RECT_F;
    const perspectiveTransform: TD2D1_MATRIX_4X4_F); stdcall;
begin
    DrawBitmap(bitmap, @destinationRectangle, opacity, interpolationMode, @sourceRectangle, @perspectiveTransform);
end;



procedure ID2D1DeviceContextHelper.FillOpacityMask(opacityMask: ID2D1Bitmap; brush: ID2D1Brush;
    const destinationRectangle: TD2D1_RECT_F; const sourceRectangle: PD2D1_RECT_F); stdcall;
begin
    FillOpacityMask(opacityMask, brush, @destinationRectangle, sourceRectangle);
end;



procedure ID2D1DeviceContextHelper.FillOpacityMask(opacityMask: ID2D1Bitmap; brush: ID2D1Brush;
    const destinationRectangle: TD2D1_RECT_F; const sourceRectangle: TD2D1_RECT_F); stdcall;
begin
    FillOpacityMask(opacityMask, brush, @destinationRectangle, @sourceRectangle);
end;



procedure ID2D1DeviceContextHelper.SetRenderingControls(const renderingControls: TD2D1_RENDERING_CONTROLS); stdcall;
begin
    SetRenderingControls(@renderingControls);
end;

{ ID2D1EffectHelper }

procedure ID2D1EffectHelper.SetInputEffect(index: uint32; inputEffect: ID2D1Effect; invalidate: longbool); stdcall;
var
    output: ID2D1Image;
begin
    if (inputEffect <> nil) then
    begin
        inputEffect.GetOutput(output);
    end;
    SetInput(index, output, invalidate);
    output := nil;
end;

{ ID2D1PropertiesHelper }

function ID2D1PropertiesHelper.SetValueByName(Name: PCWSTR; const Data: pbyte; dataSize: uint32): HResult; stdcall;
begin
    Result := SetValueByName(Name, D2D1_PROPERTY_TYPE_UNKNOWN, Data, dataSize);
end;



function ID2D1PropertiesHelper.SetValue(index: uint32; const Data: pbyte; dataSize: uint32): HResult; stdcall;
begin
    Result := SetValue(index, D2D1_PROPERTY_TYPE_UNKNOWN, Data, dataSize);
end;



function ID2D1PropertiesHelper.GetValueByName(Name: PCWSTR; out Data: pbyte; dataSize: uint32): HResult; stdcall;
begin
    Result := GetValueByName(Name, D2D1_PROPERTY_TYPE_UNKNOWN, Data, dataSize);
end;



function ID2D1PropertiesHelper.GetValue(index: uint32; out Data: pbyte; dataSize: uint32): HResult; stdcall;
begin
    Result := GetValue(index, D2D1_PROPERTY_TYPE_UNKNOWN, Data, dataSize);
end;



{ ID2D1PathGeometry1Helper }

function ID2D1PathGeometry1Helper.ComputePointAndSegmentAtLength(length: single; startSegment: uint32;
    const worldTransform: TD2D1_MATRIX_3X2_F; flatteningTolerance: single; out pointDescription: TD2D1_POINT_DESCRIPTION): HResult; stdcall;
begin
    Result := ComputePointAndSegmentAtLength(length, startSegment, worldTransform, flatteningTolerance, pointDescription);
end;

{$IFDEF FPC}
{ ID2D1FactoryHelper }

function ID2D1FactoryHelper.CreateRectangleGeometry(const rectangle: TD2D1_RECT_F; out rectangleGeometry: ID2D1RectangleGeometry): HResult; stdcall;
begin
    Result := CreateRectangleGeometry(@rectangle, rectangleGeometry);
end;



function ID2D1FactoryHelper.CreateRoundedRectangleGeometry(const roundedRectangle: TD2D1_ROUNDED_RECT;
    out roundedRectangleGeometry: ID2D1RoundedRectangleGeometry): HResult;
    stdcall;
begin
    Result := CreateRoundedRectangleGeometry(@roundedRectangle, roundedRectangleGeometry);
end;



function ID2D1FactoryHelper.CreateEllipseGeometry(const ellipse: TD2D1_ELLIPSE; out ellipseGeometry: ID2D1EllipseGeometry): HResult; stdcall;
begin
    Result := CreateEllipseGeometry(@ellipse, ellipseGeometry);
end;



function ID2D1FactoryHelper.CreateTransformedGeometry(sourceGeometry: ID2D1Geometry; const transform: TD2D1_MATRIX_3X2_F;
    out transformedGeometry: ID2D1TransformedGeometry): HResult; stdcall;
begin
    Result := CreateTransformedGeometry(sourceGeometry, @transform, transformedGeometry);
end;



function ID2D1FactoryHelper.CreateStrokeStyle(const strokeStyleProperties: TD2D1_STROKE_STYLE_PROPERTIES; const dashes: Psingle;
    dashesCount: UINT32; out strokeStyle: ID2D1StrokeStyle): HResult; stdcall;
begin
    Result := CreateStrokeStyle(@strokeStyleProperties, dashes, dashesCount, strokeStyle);
end;



function ID2D1FactoryHelper.CreateDrawingStateBlock(const drawingStateDescription: TD2D1_DRAWING_STATE_DESCRIPTION;
    out drawingStateBlock: ID2D1DrawingStateBlock): HResult; stdcall;
begin
    Result := CreateDrawingStateBlock(@drawingStateDescription, nil, drawingStateBlock);
end;



function ID2D1FactoryHelper.CreateDrawingStateBlock(out drawingStateBlock: ID2D1DrawingStateBlock): HResult; stdcall;
begin
    Result := CreateDrawingStateBlock(nil, nil, drawingStateBlock);
end;



function ID2D1FactoryHelper.CreateWicBitmapRenderTarget(target: IWICBitmap; const renderTargetProperties: TD2D1_RENDER_TARGET_PROPERTIES;
    out renderTarget: ID2D1RenderTarget): HResult; stdcall;
begin
    Result := CreateWicBitmapRenderTarget(target, @renderTargetProperties, renderTarget);
end;



function ID2D1FactoryHelper.CreateHwndRenderTarget(const renderTargetProperties: TD2D1_RENDER_TARGET_PROPERTIES;
    const hwndRenderTargetProperties: TD2D1_HWND_RENDER_TARGET_PROPERTIES; out hwndRenderTarget: ID2D1HwndRenderTarget): HResult; stdcall;
begin
    Result := CreateHwndRenderTarget(@renderTargetProperties, @hwndRenderTargetProperties, hwndRenderTarget);
end;



function ID2D1FactoryHelper.CreateDxgiSurfaceRenderTarget(dxgiSurface: IDXGISurface; const renderTargetProperties: TD2D1_RENDER_TARGET_PROPERTIES;
    out renderTarget: ID2D1RenderTarget): HResult; stdcall;
begin
    Result := CreateDxgiSurfaceRenderTarget(dxgiSurface, @renderTargetProperties, renderTarget);
end;


{ ID2D1HwndRenderTargetHelper }

function ID2D1HwndRenderTargetHelper.Resize(const pixelSize: TD2D1_SIZE_U): HResult; stdcall;
begin
    Result := Resize(@pixelSize);
end;

{ ID2D1DrawingStateBlockHelper }

procedure ID2D1DrawingStateBlockHelper.SetDescription(const stateDescription: TD2D1_DRAWING_STATE_DESCRIPTION); stdcall;
begin
    SetDescription(@stateDescription);
end;

{ ID2D1GeometrySinkHelper }

procedure ID2D1GeometrySinkHelper.AddBezier(const bezier: TD2D1_BEZIER_SEGMENT);
    stdcall;
begin
    AddBezier(@bezier);
end;



procedure ID2D1GeometrySinkHelper.AddQuadraticBezier(const bezier: TD2D1_QUADRATIC_BEZIER_SEGMENT); stdcall;
begin
    AddQuadraticBezier(@bezier);
end;



procedure ID2D1GeometrySinkHelper.AddArc(const arc: TD2D1_ARC_SEGMENT); stdcall;
begin
    AddArc(@arc);
end;

{ ID2D1GeometryHelper }

function ID2D1GeometryHelper.GetBounds(worldTransform: TD2D1_MATRIX_3X2_F; out bounds: TD2D1_RECT_F): HRESULT; stdcall;
begin
    Result := GetBounds(@worldTransform, bounds);
end;



function ID2D1GeometryHelper.GetBounds(out bounds: TD2D1_RECT_F): HRESULT;
    stdcall;
begin
    Result := GetBounds(nil, bounds);
end;



function ID2D1GeometryHelper.GetWidenedBounds(strokeWidth: single; strokeStyle: ID2D1StrokeStyle; const worldTransform: TD2D1_MATRIX_3X2_F;
    flatteningTolerance: single; out bounds: TD2D1_RECT_F): HRESULT; stdcall;
begin
    Result := GetWidenedBounds(strokeWidth, strokeStyle, @worldTransform, flatteningTolerance, bounds);
end;



function ID2D1GeometryHelper.GetWidenedBounds(strokeWidth: single; strokeStyle: ID2D1StrokeStyle; const worldTransform: PD2D1_MATRIX_3X2_F;
    out bounds: TD2D1_RECT_F): HRESULT; stdcall;
begin
    Result := GetWidenedBounds(strokeWidth, strokeStyle, worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, bounds);
end;



function ID2D1GeometryHelper.GetWidenedBounds(strokeWidth: single; strokeStyle: ID2D1StrokeStyle; const worldTransform: TD2D1_MATRIX_3X2_F;
    out bounds: TD2D1_RECT_F): HRESULT; stdcall;
begin
    Result := GetWidenedBounds(strokeWidth, strokeStyle, @worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, bounds);
end;



function ID2D1GeometryHelper.StrokeContainsPoint(point: TD2D1_POINT_2F; strokeWidth: single; strokeStyle: ID2D1StrokeStyle;
    const worldTransform: TD2D1_MATRIX_3X2_F; flatteningTolerance: single; out contains: longbool): HRESULT; stdcall;
begin
    Result := StrokeContainsPoint(point, strokeWidth, strokeStyle, @worldTransform, flatteningTolerance, contains);
end;



function ID2D1GeometryHelper.StrokeContainsPoint(point: TD2D1_POINT_2F; strokeWidth: single; strokeStyle: ID2D1StrokeStyle;
    const worldTransform: PD2D1_MATRIX_3X2_F; out contains: longbool): HRESULT;
    stdcall;
begin
    Result := StrokeContainsPoint(point, strokeWidth, strokeStyle, worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, contains);
end;



function ID2D1GeometryHelper.StrokeContainsPoint(point: TD2D1_POINT_2F; strokeWidth: single; strokeStyle: ID2D1StrokeStyle;
    const worldTransform: TD2D1_MATRIX_3X2_F; out contains: longbool): HRESULT;
    stdcall;
begin
    Result := StrokeContainsPoint(point, strokeWidth, strokeStyle, @worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, contains);
end;



function ID2D1GeometryHelper.FillContainsPoint(point: TD2D1_POINT_2F; const worldTransform: TD2D1_MATRIX_3X2_F;
    flatteningTolerance: single; out contains: longbool): HRESULT; stdcall;
begin
    Result := FillContainsPoint(point, @worldTransform, flatteningTolerance, contains);
end;



function ID2D1GeometryHelper.FillContainsPoint(point: TD2D1_POINT_2F; const worldTransform: PD2D1_MATRIX_3X2_F; out contains: longbool): HRESULT;
    stdcall;
begin
    Result := FillContainsPoint(point, worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, contains);
end;



function ID2D1GeometryHelper.FillContainsPoint(point: TD2D1_POINT_2F; const worldTransform: TD2D1_MATRIX_3X2_F; out contains: longbool): HRESULT;
    stdcall;
begin
    Result := FillContainsPoint(point, @worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, contains);
end;



function ID2D1GeometryHelper.CompareWithGeometry(inputGeometry: ID2D1Geometry; const inputGeometryTransform: TD2D1_MATRIX_3X2_F;
    flatteningTolerance: single; out relation: TD2D1_GEOMETRY_RELATION): HRESULT;
    stdcall;
begin
    Result := CompareWithGeometry(inputGeometry, @inputGeometryTransform, flatteningTolerance, relation);
end;



function ID2D1GeometryHelper.CompareWithGeometry(inputGeometry: ID2D1Geometry; const inputGeometryTransform: PD2D1_MATRIX_3X2_F;
    out relation: TD2D1_GEOMETRY_RELATION): HRESULT; stdcall;
begin
    Result := CompareWithGeometry(inputGeometry, inputGeometryTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, relation);
end;



function ID2D1GeometryHelper.CompareWithGeometry(inputGeometry: ID2D1Geometry; const inputGeometryTransform: TD2D1_MATRIX_3X2_F;
    out relation: TD2D1_GEOMETRY_RELATION): HRESULT; stdcall;
begin
    Result := CompareWithGeometry(inputGeometry, @inputGeometryTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, relation);
end;



function ID2D1GeometryHelper.Simplify(simplificationOption: TD2D1_GEOMETRY_SIMPLIFICATION_OPTION; const worldTransform: TD2D1_MATRIX_3X2_F;
    flatteningTolerance: single; geometrySink: ID2D1SimplifiedGeometrySink): HRESULT; stdcall;
begin
    Result := Simplify(simplificationOption, @worldTransform, flatteningTolerance, geometrySink);
end;



function ID2D1GeometryHelper.Simplify(simplificationOption: TD2D1_GEOMETRY_SIMPLIFICATION_OPTION; const worldTransform: PD2D1_MATRIX_3X2_F;
    geometrySink: ID2D1SimplifiedGeometrySink): HRESULT; stdcall;
begin
    Result := Simplify(simplificationOption, worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, geometrySink);
end;



function ID2D1GeometryHelper.Simplify(simplificationOption: TD2D1_GEOMETRY_SIMPLIFICATION_OPTION; const worldTransform: TD2D1_MATRIX_3X2_F;
    geometrySink: ID2D1SimplifiedGeometrySink): HRESULT; stdcall;
begin
    Result := Simplify(simplificationOption, @worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, geometrySink);
end;



function ID2D1GeometryHelper.Tessellate(const worldTransform: TD2D1_MATRIX_3X2_F; flatteningTolerance: single;
    tessellationSink: ID2D1TessellationSink): HRESULT; stdcall;
begin
    Result := Tessellate(@worldTransform, flatteningTolerance, tessellationSink);
end;



function ID2D1GeometryHelper.Tessellate(const worldTransform: PD2D1_MATRIX_3X2_F; tessellationSink: ID2D1TessellationSink): HRESULT; stdcall;
begin
    Result := Tessellate(worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, tessellationSink);
end;



function ID2D1GeometryHelper.Tessellate(const worldTransform: TD2D1_MATRIX_3X2_F; tessellationSink: ID2D1TessellationSink): HRESULT; stdcall;
begin
    Result := Tessellate(@worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, tessellationSink);
end;



function ID2D1GeometryHelper.CombineWithGeometry(inputGeometry: ID2D1Geometry; combineMode: TD2D1_COMBINE_MODE;
    const inputGeometryTransform: TD2D1_MATRIX_3X2_F; flatteningTolerance: single; geometrySink: ID2D1SimplifiedGeometrySink): HRESULT; stdcall;
begin
    Result := CombineWithGeometry(inputGeometry, combineMode, @inputGeometryTransform, flatteningTolerance, geometrySink);
end;



function ID2D1GeometryHelper.CombineWithGeometry(inputGeometry: ID2D1Geometry; combineMode: TD2D1_COMBINE_MODE;
    inputGeometryTransform: PD2D1_MATRIX_3X2_F; geometrySink: ID2D1SimplifiedGeometrySink): HRESULT; stdcall;
begin
    Result := CombineWithGeometry(inputGeometry, combineMode, inputGeometryTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, geometrySink);
end;



function ID2D1GeometryHelper.CombineWithGeometry(inputGeometry: ID2D1Geometry; combineMode: TD2D1_COMBINE_MODE;
    const inputGeometryTransform: TD2D1_MATRIX_3X2_F; geometrySink: ID2D1SimplifiedGeometrySink): HRESULT; stdcall;
begin
    Result := CombineWithGeometry(inputGeometry, combineMode, @inputGeometryTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, geometrySink);
end;



function ID2D1GeometryHelper.Outline(const worldTransform: TD2D1_MATRIX_3X2_F; flatteningTolerance: single;
    geometrySink: ID2D1SimplifiedGeometrySink): HRESULT; stdcall;
begin
    Result := Outline(@worldTransform, flatteningTolerance, geometrySink);
end;



function ID2D1GeometryHelper.Outline(const worldTransform: PD2D1_MATRIX_3X2_F; geometrySink: ID2D1SimplifiedGeometrySink): HRESULT; stdcall;
begin
    Result := Outline(worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, geometrySink);
end;



function ID2D1GeometryHelper.Outline(const worldTransform: TD2D1_MATRIX_3X2_F; geometrySink: ID2D1SimplifiedGeometrySink): HRESULT; stdcall;
begin
    Result := Outline(@worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, geometrySink);
end;



function ID2D1GeometryHelper.ComputeArea(const worldTransform: TD2D1_MATRIX_3X2_F; flatteningTolerance: single; out area: single): HRESULT; stdcall;
begin
    Result := ComputeArea(@worldTransform, flatteningTolerance, area);
end;



function ID2D1GeometryHelper.ComputeArea(const worldTransform: PD2D1_MATRIX_3X2_F; out area: single): HRESULT;
    stdcall;
begin
    Result := ComputeArea(worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, area);
end;



function ID2D1GeometryHelper.ComputeArea(const worldTransform: TD2D1_MATRIX_3X2_F; out area: single): HRESULT;
    stdcall;
begin
    Result := ComputeArea(@worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, area);
end;



function ID2D1GeometryHelper.ComputeLength(const worldTransform: TD2D1_MATRIX_3X2_F; flatteningTolerance: single; out length: single): HRESULT; stdcall;
begin
    Result := ComputeLength(@worldTransform, flatteningTolerance, length);
end;



function ID2D1GeometryHelper.ComputeLength(const worldTransform: PD2D1_MATRIX_3X2_F; out length: single): HRESULT;
    stdcall;
begin
    Result := ComputeLength(worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, length);
end;



function ID2D1GeometryHelper.ComputeLength(const worldTransform: TD2D1_MATRIX_3X2_F; out length: single): HRESULT;
    stdcall;
begin
    Result := ComputeLength(@worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, length);
end;



function ID2D1GeometryHelper.ComputePointAtLength(length: single; const worldTransform: TD2D1_MATRIX_3X2_F;
    flatteningTolerance: single; point: PD2D1_POINT_2F; unitTangentVector: PD2D1_POINT_2F): HRESULT;
    stdcall;
begin
    Result := ComputePointAtLength(length, @worldTransform, flatteningTolerance, point, unitTangentVector);
end;



function ID2D1GeometryHelper.ComputePointAtLength(length: single; const worldTransform: PD2D1_MATRIX_3X2_F; point: PD2D1_POINT_2F;
    unitTangentVector: PD2D1_POINT_2F): HRESULT; stdcall;
begin
    Result := ComputePointAtLength(length, worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, point, unitTangentVector);
end;



function ID2D1GeometryHelper.ComputePointAtLength(length: single; const worldTransform: TD2D1_MATRIX_3X2_F; point: PD2D1_POINT_2F;
    unitTangentVector: PD2D1_POINT_2F): HRESULT; stdcall;
begin
    Result := ComputePointAtLength(length, @worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, point, unitTangentVector);
end;



function ID2D1GeometryHelper.Widen(strokeWidth: single; strokeStyle: ID2D1StrokeStyle; const worldTransform: TD2D1_MATRIX_3X2_F;
    flatteningTolerance: single; geometrySink: ID2D1SimplifiedGeometrySink): HRESULT; stdcall;
begin
    Result := Widen(strokeWidth, strokeStyle, @worldTransform, flatteningTolerance, geometrySink);
end;



function ID2D1GeometryHelper.Widen(strokeWidth: single; strokeStyle: ID2D1StrokeStyle; const worldTransform: PD2D1_MATRIX_3X2_F;
    geometrySink: ID2D1SimplifiedGeometrySink): HRESULT; stdcall;
begin
    Result := Widen(strokeWidth, strokeStyle, worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, geometrySink);
end;



function ID2D1GeometryHelper.Widen(strokeWidth: single; strokeStyle: ID2D1StrokeStyle; const worldTransform: TD2D1_MATRIX_3X2_F;
    geometrySink: ID2D1SimplifiedGeometrySink): HRESULT; stdcall;
begin
    Result := Widen(strokeWidth, strokeStyle, @worldTransform, D2D1_DEFAULT_FLATTENING_TOLERANCE, geometrySink);
end;



function ID2D1GeometryHelper.ComputePointAtLength(length: single; const worldTransform: TD2D1_MATRIX_3X2_F;
    flatteningTolerance: single; out point: TD2D1_POINT_2F; out unitTangentVector: TD2D1_POINT_2F): HResult;
    stdcall;
begin
    Result := ComputePointAtLength(length, @worldTransform, flatteningTolerance, @point, @unitTangentVector);
end;

{ ID2D1SolidColorBrushHelper }

procedure ID2D1SolidColorBrushHelper.SetColor(color: TD2D1_COLOR_F); stdcall;
begin
    SetColor(@Color);
end;

{ ID2D1BitmapHelper }


{ ID2D1BrushHelper }

procedure ID2D1BrushHelper.SetTransform(const transform: TD2D1_MATRIX_3X2_F);
    stdcall;
begin
    SetTransform(@transform);
end;

{$IFDEF FPC}
{ ID2D1RenderTargetHelper }
// {$IF FPC_FULLVERSION >= 30101}

function ID2D1RenderTargetHelper.CreateBitmap(size: TD2D1_SIZE_U; const srcData: pointer; pitch: UINT32;
    const bitmapProperties: TD2D1_BITMAP_PROPERTIES; out bitmap: ID2D1Bitmap): HResult; stdcall;
begin
    Result := CreateBitmap(size, srcData, pitch, @bitmapProperties, bitmap);
end;



function ID2D1RenderTargetHelper.CreateBitmap(size: TD2D1_SIZE_U; const bitmapProperties: TD2D1_BITMAP_PROPERTIES;
    out bitmap: ID2D1Bitmap): HResult; stdcall;
begin
    Result := CreateBitmap(size, nil, 0, @bitmapProperties, bitmap);
end;



function ID2D1RenderTargetHelper.CreateBitmapFromWicBitmap(wicBitmapSource: IWICBitmapSource; const bitmapProperties: TD2D1_BITMAP_PROPERTIES;
    out bitmap: ID2D1Bitmap): HResult; stdcall;
begin
    Result := CreateBitmapFromWicBitmap(wicBitmapSource, @bitmapProperties, bitmap);
end;



function ID2D1RenderTargetHelper.CreateBitmapFromWicBitmap(wicBitmapSource: IWICBitmapSource; out bitmap: ID2D1Bitmap): HResult;
    stdcall;
begin
    Result := CreateBitmapFromWicBitmap(wicBitmapSource, nil, bitmap);
end;



function ID2D1RenderTargetHelper.CreateBitmapBrush(bitmap: ID2D1Bitmap; out bitmapBrush: ID2D1BitmapBrush): HResult; stdcall;
begin
    Result := CreateBitmapBrush(bitmap, nil, nil, bitmapBrush);
end;



function ID2D1RenderTargetHelper.CreateBitmapBrush(bitmap: ID2D1Bitmap; const bitmapBrushProperties: TD2D1_BITMAP_BRUSH_PROPERTIES;
    out bitmapBrush: ID2D1BitmapBrush): HResult; stdcall;
begin
    Result := CreateBitmapBrush(bitmap, @bitmapBrushProperties, nil, bitmapBrush);
end;



function ID2D1RenderTargetHelper.CreateBitmapBrush(bitmap: ID2D1Bitmap; const bitmapBrushProperties: TD2D1_BITMAP_BRUSH_PROPERTIES;
    const brushProperties: TD2D1_BRUSH_PROPERTIES; out bitmapBrush: ID2D1BitmapBrush): HResult; stdcall;
begin
    Result := CreateBitmapBrush(bitmap, @bitmapBrushProperties, @brushProperties, bitmapBrush);
end;



function ID2D1RenderTargetHelper.CreateSolidColorBrush(const color: TD2D1_COLOR_F; out solidColorBrush: ID2D1SolidColorBrush): HRESULT; stdcall;
begin
    Result := CreateSolidColorBrush(@color, nil, solidColorBrush);
end;



function ID2D1RenderTargetHelper.CreateSolidColorBrush(const color: TD2D1_COLOR_F; const brushProperties: TD2D1_BRUSH_PROPERTIES;
    out solidColorBrush: ID2D1SolidColorBrush): HResult; stdcall;
begin
    Result := CreateSolidColorBrush(@color, @brushProperties, solidColorBrush);
end;



function ID2D1RenderTargetHelper.CreateGradientStopCollection(const gradientStops: PD2D1_GRADIENT_STOP; gradientStopsCount: UINT32;
    out gradientStopCollection: ID2D1GradientStopCollection): HResult; stdcall;
begin
    Result := CreateGradientStopCollection(gradientStops, gradientStopsCount, D2D1_GAMMA_2_2, D2D1_EXTEND_MODE_CLAMP, gradientStopCollection);
end;



function ID2D1RenderTargetHelper.CreateLinearGradientBrush(const linearGradientBrushProperties: TD2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES;
    gradientStopCollection: ID2D1GradientStopCollection; out linearGradientBrush: ID2D1LinearGradientBrush): HResult; stdcall;
begin
    Result := CreateLinearGradientBrush(@linearGradientBrushProperties, nil, gradientStopCollection, linearGradientBrush);
end;



function ID2D1RenderTargetHelper.CreateLinearGradientBrush(const linearGradientBrushProperties: TD2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES;
    const brushProperties: TD2D1_BRUSH_PROPERTIES; gradientStopCollection: ID2D1GradientStopCollection;
    out linearGradientBrush: ID2D1LinearGradientBrush): HResult; stdcall;
begin
    Result := CreateLinearGradientBrush(@linearGradientBrushProperties, @brushProperties, gradientStopCollection, linearGradientBrush);
end;



function ID2D1RenderTargetHelper.CreateRadialGradientBrush(const radialGradientBrushProperties: TD2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES;
    gradientStopCollection: ID2D1GradientStopCollection; out radialGradientBrush: ID2D1RadialGradientBrush): HResult; stdcall;
begin
    Result := CreateRadialGradientBrush(@radialGradientBrushProperties, nil, gradientStopCollection, radialGradientBrush);
end;



function ID2D1RenderTargetHelper.CreateRadialGradientBrush(const radialGradientBrushProperties: TD2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES;
    const brushProperties: TD2D1_BRUSH_PROPERTIES; gradientStopCollection: ID2D1GradientStopCollection;
    out radialGradientBrush: ID2D1RadialGradientBrush): HResult; stdcall;
begin
    Result := CreateRadialGradientBrush(@radialGradientBrushProperties, @brushProperties, gradientStopCollection, radialGradientBrush);
end;



function ID2D1RenderTargetHelper.CreateCompatibleRenderTarget(out bitmapRenderTarget: ID2D1BitmapRenderTarget): HResult; stdcall;
begin
    Result := CreateCompatibleRenderTarget(nil, nil, nil, D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS_NONE, bitmapRenderTarget);
end;



function ID2D1RenderTargetHelper.CreateCompatibleRenderTarget(desiredSize: TD2D1_SIZE_F; out bitmapRenderTarget: ID2D1BitmapRenderTarget): HResult; stdcall;
begin
    Result := CreateCompatibleRenderTarget(@desiredSize, nil, nil, D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS_NONE, bitmapRenderTarget);
end;



function ID2D1RenderTargetHelper.CreateCompatibleRenderTarget(desiredSize: TD2D1_SIZE_F; desiredPixelSize: TD2D1_SIZE_U;
    out bitmapRenderTarget: ID2D1BitmapRenderTarget): HResult; stdcall;
begin
    Result := CreateCompatibleRenderTarget(@desiredSize, @desiredPixelSize, nil, D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS_NONE, bitmapRenderTarget);
end;



function ID2D1RenderTargetHelper.CreateCompatibleRenderTarget(desiredSize: TD2D1_SIZE_F; desiredPixelSize: TD2D1_SIZE_U;
    desiredFormat: TD2D1_PIXEL_FORMAT; out bitmapRenderTarget: ID2D1BitmapRenderTarget): HResult; stdcall;
begin
    Result := CreateCompatibleRenderTarget(@desiredSize, @desiredPixelSize, @desiredFormat, D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS_NONE,
        bitmapRenderTarget);
end;



function ID2D1RenderTargetHelper.CreateCompatibleRenderTarget(desiredSize: TD2D1_SIZE_F; desiredPixelSize: TD2D1_SIZE_U;
    desiredFormat: TD2D1_PIXEL_FORMAT; options: TD2D1_COMPATIBLE_RENDER_TARGET_OPTIONS; out bitmapRenderTarget: ID2D1BitmapRenderTarget): HResult; stdcall;
begin
    Result := CreateCompatibleRenderTarget(@desiredSize, @desiredPixelSize, @desiredFormat, options, bitmapRenderTarget);
end;



function ID2D1RenderTargetHelper.CreateLayer(size: TD2D1_SIZE_F; out layer: ID2D1Layer): HResult; stdcall;
begin
    Result := CreateLayer(@size, layer);
end;



function ID2D1RenderTargetHelper.CreateLayer(out layer: ID2D1Layer): HResult;
    stdcall;
begin
    Result := CreateLayer(nil, layer);
end;



procedure ID2D1RenderTargetHelper.DrawRectangle(const rect: TD2D1_RECT_F; brush: ID2D1Brush; strokeWidth: single; strokeStyle: ID2D1StrokeStyle);
    stdcall;
begin
    DrawRectangle(@rect, brush, strokeWidth, strokeStyle);
end;



procedure ID2D1RenderTargetHelper.FillRectangle(const rect: TD2D1_RECT_F; brush: ID2D1Brush); stdcall;
begin
    FillRectangle(@rect, brush);
end;



procedure ID2D1RenderTargetHelper.DrawRoundedRectangle(const roundedRect: TD2D1_ROUNDED_RECT; brush: ID2D1Brush;
    strokeWidth: single; strokeStyle: ID2D1StrokeStyle); stdcall;
begin
    DrawRoundedRectangle(@roundedRect, brush, strokeWidth, strokeStyle);
end;



procedure ID2D1RenderTargetHelper.FillRoundedRectangle(const roundedRect: TD2D1_ROUNDED_RECT; brush: ID2D1Brush); stdcall;
begin
    FillRoundedRectangle(@roundedRect, brush);
end;



procedure ID2D1RenderTargetHelper.DrawEllipse(const ellipse: TD2D1_ELLIPSE; brush: ID2D1Brush; strokeWidth: single; strokeStyle: ID2D1StrokeStyle);
    stdcall;
begin
    DrawEllipse(@ellipse, brush, strokeWidth, strokeStyle);
end;



procedure ID2D1RenderTargetHelper.FillEllipse(const ellipse: TD2D1_ELLIPSE; brush: ID2D1Brush); stdcall;
begin
    FillEllipse(@ellipse, brush);
end;



procedure ID2D1RenderTargetHelper.FillOpacityMask(opacityMask: ID2D1Bitmap; brush: ID2D1Brush; content: TD2D1_OPACITY_MASK_CONTENT;
    const destinationRectangle: TD2D1_RECT_F; const sourceRectangle: TD2D1_RECT_F); stdcall;
begin
    FillOpacityMask(opacityMask, brush, content, @destinationRectangle, @sourceRectangle);
end;



procedure ID2D1RenderTargetHelper.DrawBitmap(bitmap: ID2D1Bitmap; const destinationRectangle: TD2D1_RECT_F; opacity: single;
    interpolationMode: TD2D1_BITMAP_INTERPOLATION_MODE; const sourceRectangle: PD2D1_RECT_F); stdcall;
begin
    DrawBitmap(bitmap, @destinationRectangle, opacity,
        interpolationMode, sourceRectangle);
end;



procedure ID2D1RenderTargetHelper.DrawBitmap(bitmap: ID2D1Bitmap; const destinationRectangle: TD2D1_RECT_F; opacity: single;
    interpolationMode: TD2D1_BITMAP_INTERPOLATION_MODE; const sourceRectangle: TD2D1_RECT_F); stdcall;
begin
    DrawBitmap(bitmap, @destinationRectangle, opacity,
        interpolationMode, @sourceRectangle);
end;



procedure ID2D1RenderTargetHelper.SetTransform(const transform: TD2D1_MATRIX_3X2_F); stdcall;
begin
    SetTransform(@transform);
end;



procedure ID2D1RenderTargetHelper.PushLayer(const layerParameters: TD2D1_LAYER_PARAMETERS; layer: ID2D1Layer); stdcall;
begin
    PushLayer(@layerParameters, layer);
end;



procedure ID2D1RenderTargetHelper.PushAxisAlignedClip(const clipRect: TD2D1_RECT_F; antialiasMode: TD2D1_ANTIALIAS_MODE);
    stdcall;
begin
    PushAxisAlignedClip(@clipRect, antialiasMode);
end;



procedure ID2D1RenderTargetHelper.Clear(const clearColor: TD2D1_COLOR_F);
    stdcall;
begin
    Clear(@clearColor);
end;



procedure ID2D1RenderTargetHelper.DrawText(const Astring: PWideChar; stringLength: UINT32; textFormat: IDWriteTextFormat;
    const layoutRect: TD2D1_RECT_F; defaultFillBrush: ID2D1Brush; options: TD2D1_DRAW_TEXT_OPTIONS; measuringMode: TDWRITE_MEASURING_MODE);
    stdcall;
begin
    DrawText(Astring, stringLength, textFormat, @layoutRect,
        defaultFillBrush, options, measuringMode);
end;



function ID2D1RenderTargetHelper.IsSupported(const renderTargetProperties: TD2D1_RENDER_TARGET_PROPERTIES): longbool;
    stdcall;
begin
    Result := IsSupported(@renderTargetProperties);
end;

{$ENDIF}
{$ENDIF}

{ TD2D_SIZE_U }

class operator TD2D_SIZE_U.Equal(a, b: TD2D_SIZE_U): longbool;
begin
    Result := (a.Width = b.Width) and (a.Height = b.Height);
end;

{ TD2D_RECT_U }

class operator TD2D_RECT_U.Equal(a, b: TD2D_RECT_U): longbool;
begin
    Result := (a.left = b.left) and (a.top = b.top) and (a.right = b.right) and (a.bottom = b.bottom);
end;

{ TD2D_MATRIX_5X4_F }

procedure TD2D_MATRIX_5X4_F.Init;
begin
    _11 := 1;
    _12 := 0;
    _13 := 0;
    _14 := 0;

    _21 := 0;
    _22 := 1;
    _23 := 0;
    _24 := 0;

    _31 := 0;
    _32 := 0;
    _33 := 1;
    _34 := 0;

    _41 := 0;
    _42 := 0;
    _43 := 0;
    _44 := 1;

    _51 := 0;
    _52 := 0;
    _53 := 0;
    _54 := 0;
end;



procedure TD2D_MATRIX_5X4_F.Init(m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44, m51, m52, m53, m54: single);
begin
    _11 := m11;
    _12 := m12;
    _13 := m13;
    _14 := m14;

    _21 := m21;
    _22 := m22;
    _23 := m23;
    _24 := m24;

    _31 := m31;
    _32 := m32;
    _33 := m33;
    _34 := m34;

    _41 := m41;
    _42 := m42;
    _43 := m43;
    _44 := m44;

    _51 := m51;
    _52 := m52;
    _53 := m53;
    _54 := m54;
end;

{ TD2D_MATRIX_4X3_F }

procedure TD2D_MATRIX_4X3_F.Init;
begin
    _11 := 1;
    _12 := 0;
    _13 := 0;

    _21 := 0;
    _22 := 1;
    _23 := 0;

    _31 := 0;
    _32 := 0;
    _33 := 1;

    _41 := 0;
    _42 := 0;
    _43 := 0;
end;



procedure TD2D_MATRIX_4X3_F.Init(m11, m12, m13, m21, m22, m23, m31, m32, m33, m41, m42, m43: single);
begin
    _11 := m11;
    _12 := m12;
    _13 := m13;

    _21 := m21;
    _22 := m22;
    _23 := m23;

    _31 := m31;
    _32 := m32;
    _33 := m33;

    _41 := m41;
    _42 := m42;
    _43 := m43;
end;

{ TD2D_MATRIX_4X4_F }

procedure TD2D_MATRIX_4X4_F.Translation(x, y, z: single);
begin
    _11 := 1.0;
    _12 := 0.0;
    _13 := 0.0;
    _14 := 0.0;
    _21 := 0.0;
    _22 := 1.0;
    _23 := 0.0;
    _24 := 0.0;
    _31 := 0.0;
    _32 := 0.0;
    _33 := 1.0;
    _34 := 0.0;
    _41 := x;
    _42 := y;
    _43 := z;
    _44 := 1.0;
end;



procedure TD2D_MATRIX_4X4_F.Scale(x, y, z: single);
begin
    _11 := x;
    _12 := 0.0;
    _13 := 0.0;
    _14 := 0.0;
    _21 := 0.0;
    _22 := y;
    _23 := 0.0;
    _24 := 0.0;
    _31 := 0.0;
    _32 := 0.0;
    _33 := z;
    _34 := 0.0;
    _41 := 0.0;
    _42 := 0.0;
    _43 := 0.0;
    _44 := 1.0;
end;



procedure TD2D_MATRIX_4X4_F.RotationX(degreeX: single);
var
    angleInRadian: single;
    sinAngle: single;
    cosAngle: single;
begin
    angleInRadian := degreeX * (3.141592654 / 180.0);

    sinAngle := 0.0;
    cosAngle := 0.0;
    D2D1SinCos(angleInRadian, sinAngle, cosAngle);

    Init(
        1, 0, 0, 0,
        0, cosAngle, sinAngle, 0,
        0, -sinAngle, cosAngle, 0,
        0, 0, 0, 1
        );
end;



procedure TD2D_MATRIX_4X4_F.RotationY(degreeY: single);
var
    angleInRadian: single;
    sinAngle: single;
    cosAngle: single;
begin
    angleInRadian := degreeY * (3.141592654 / 180.0);

    sinAngle := 0.0;
    cosAngle := 0.0;
    D2D1SinCos(angleInRadian, sinAngle, cosAngle);

    Init(
        cosAngle, 0, -sinAngle, 0,
        0, 1, 0, 0,
        sinAngle, 0, cosAngle, 0,
        0, 0, 0, 1
        );
end;



procedure TD2D_MATRIX_4X4_F.RotationZ(degreeZ: single);
var
    angleInRadian: single;
    sinAngle: single;
    cosAngle: single;
begin
    angleInRadian := degreeZ * (3.141592654 / 180.0);

    sinAngle := 0.0;
    cosAngle := 0.0;
    D2D1SinCos(angleInRadian, sinAngle, cosAngle);

    Init(
        cosAngle, sinAngle, 0, 0, -sinAngle, cosAngle, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
        );
end;


// 3D Rotation matrix for an arbitrary axis specified by x, y and z
procedure TD2D_MATRIX_4X4_F.RotationArbitraryAxis(x, y, z, degree: single);
var
    magnitude: single;
    angleInRadian: single;
    sinAngle: single;
    cosAngle: single;
    oneMinusCosAngle: single;
begin
    // Normalize the vector represented by x, y, and z
    magnitude := D2D1Vec3Length(x, y, z);
    x := x / magnitude;
    y := y / magnitude;
    z := z / magnitude;

    angleInRadian := degree * (3.141592654 / 180.0);

    sinAngle := 0.0;
    cosAngle := 0.0;
    D2D1SinCos(angleInRadian, sinAngle, cosAngle);

    oneMinusCosAngle := 1 - cosAngle;

    Init(
        1 + oneMinusCosAngle * (x * x - 1),
        z * sinAngle + oneMinusCosAngle * x * y, -y * sinAngle + oneMinusCosAngle * x * z,
        0, -z * sinAngle + oneMinusCosAngle * y * x,
        1 + oneMinusCosAngle * (y * y - 1),
        x * sinAngle + oneMinusCosAngle * y * z,
        0,

        y * sinAngle + oneMinusCosAngle * z * x, -x * sinAngle + oneMinusCosAngle * z * y,
        1 + oneMinusCosAngle * (z * z - 1),
        0,

        0, 0, 0, 1
        );
end;



procedure TD2D_MATRIX_4X4_F.SkewX(degreeX: single);
var
    angleInRadian: single;
    tanAngle: single;
begin
    angleInRadian := degreeX * (3.141592654 / 180.0);

    tanAngle := D2D1Tan(angleInRadian);

    Init(
        1, 0, 0, 0,
        tanAngle, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
        );
end;



procedure TD2D_MATRIX_4X4_F.SkewY(degreeY: single);
var
    angleInRadian: single;
    tanAngle: single;
begin
    angleInRadian := degreeY * (3.141592654 / 180.0);

    tanAngle := D2D1Tan(angleInRadian);

    Init(
        1, tanAngle, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
        );

end;



procedure TD2D_MATRIX_4X4_F.PerspectiveProjection(depth: single);
var
    proj: single;
begin
    proj := 0;

    if (depth > 0) then
    begin
        proj := -1 / depth;
    end;

    Init(
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, proj,
        0, 0, 0, 1
        );
end;



procedure TD2D_MATRIX_4X4_F.Init;
begin
    _11 := 1;
    _12 := 0;
    _13 := 0;
    _14 := 0;

    _21 := 0;
    _22 := 1;
    _23 := 0;
    _24 := 0;

    _31 := 0;
    _32 := 0;
    _33 := 1;
    _34 := 0;

    _41 := 0;
    _42 := 0;
    _43 := 0;
    _44 := 1;
end;



procedure TD2D_MATRIX_4X4_F.Init(m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44: single);
begin
    _11 := m11;
    _12 := m12;
    _13 := m13;
    _14 := m14;

    _21 := m21;
    _22 := m22;
    _23 := m23;
    _24 := m24;

    _31 := m31;
    _32 := m32;
    _33 := m33;
    _34 := m34;

    _41 := m41;
    _42 := m42;
    _43 := m43;
    _44 := m44;
end;



function TD2D_MATRIX_4X4_F.Determinant: single;
var
    minor1: single;
    minor2: single;
    minor3: single;
    minor4: single;
begin
    minor1 := _41 * (_12 * (_23 * _34 - _33 * _24) - _13 * (_22 * _34 - _24 * _32) + _14 * (_22 * _33 - _23 * _32));
    minor2 := _42 * (_11 * (_21 * _34 - _31 * _24) - _13 * (_21 * _34 - _24 * _31) + _14 * (_21 * _33 - _23 * _31));
    minor3 := _43 * (_11 * (_22 * _34 - _32 * _24) - _12 * (_21 * _34 - _24 * _31) + _14 * (_21 * _32 - _22 * _31));
    minor4 := _44 * (_11 * (_22 * _33 - _32 * _23) - _12 * (_21 * _33 - _23 * _31) + _13 * (_21 * _32 - _22 * _31));

    Result := minor1 - minor2 + minor3 - minor4;
end;



function TD2D_MATRIX_4X4_F.IsIdentity: longbool;
begin
    Result := (_11 = 1.0) and (_12 = 0.0) and (_13 = 0.0) and (_14 = 0.0) and (_21 = 0.0) and (_22 = 1.0) and
        (_23 = 0.0) and (_24 = 0.0) and (_31 = 0.0) and (_32 = 0.0) and (_33 = 1.0) and (_34 = 0.0) and (_41 = 0.0) and
        (_42 = 0.0) and (_43 = 0.0) and (_44 = 1.0);
end;



procedure TD2D_MATRIX_4X4_F.SetProduct(a, b: TD2D_MATRIX_4X4_F);
begin
    _11 := a._11 * b._11 + a._12 * b._21 + a._13 * b._31 + a._14 * b._41;
    _12 := a._11 * b._12 + a._12 * b._22 + a._13 * b._32 + a._14 * b._42;
    _13 := a._11 * b._13 + a._12 * b._23 + a._13 * b._33 + a._14 * b._43;
    _14 := a._11 * b._14 + a._12 * b._24 + a._13 * b._34 + a._14 * b._44;

    _21 := a._21 * b._11 + a._22 * b._21 + a._23 * b._31 + a._24 * b._41;
    _22 := a._21 * b._12 + a._22 * b._22 + a._23 * b._32 + a._24 * b._42;
    _23 := a._21 * b._13 + a._22 * b._23 + a._23 * b._33 + a._24 * b._43;
    _24 := a._21 * b._14 + a._22 * b._24 + a._23 * b._34 + a._24 * b._44;

    _31 := a._31 * b._11 + a._32 * b._21 + a._33 * b._31 + a._34 * b._41;
    _32 := a._31 * b._12 + a._32 * b._22 + a._33 * b._32 + a._34 * b._42;
    _33 := a._31 * b._13 + a._32 * b._23 + a._33 * b._33 + a._34 * b._43;
    _34 := a._31 * b._14 + a._32 * b._24 + a._33 * b._34 + a._34 * b._44;

    _41 := a._41 * b._11 + a._42 * b._21 + a._43 * b._31 + a._44 * b._41;
    _42 := a._41 * b._12 + a._42 * b._22 + a._43 * b._32 + a._44 * b._42;
    _43 := a._41 * b._13 + a._42 * b._23 + a._43 * b._33 + a._44 * b._43;
    _44 := a._41 * b._14 + a._42 * b._24 + a._43 * b._34 + a._44 * b._44;
end;



class operator TD2D_MATRIX_4X4_F.Multiply(a: TD2D_MATRIX_4X4_F; b: TD2D_MATRIX_4X4_F): TD2D_MATRIX_4X4_F;
var
    c: TD2D_MATRIX_4X4_F;
begin
    c.SetProduct(a, b);
    Result := c;
end;



class operator TD2D_MATRIX_4X4_F.Equal(a, b: TD2D_MATRIX_4X4_F): longbool;
begin
    Result := (a._11 = b._11) and (a._12 = b._12) and (a._13 = b._13) and (a._14 = b._14) and (a._21 = b._21) and
        (a._22 = b._22) and (a._23 = b._23) and (a._24 = b._24) and (a._31 = b._31) and (a._32 = b._32) and
        (a._33 = b._33) and (a._34 = b._34) and (a._41 = b._41) and (a._42 = b._42) and (a._43 = b._43) and (a._44 = b._44);
end;



class operator TD2D_MATRIX_4X4_F.NotEqual(a, b: TD2D_MATRIX_4X4_F): longbool;
begin
    Result := (a._11 <> b._11) or (a._12 <> b._12) or (a._13 <> b._13) or (a._14 <> b._14) or (a._21 <> b._21) or
        (a._22 <> b._22) or (a._23 <> b._23) or (a._24 <> b._24) or (a._31 <> b._31) or (a._32 <> b._32) or
        (a._33 <> b._33) or (a._34 <> b._34) or (a._41 <> b._41) or (a._42 <> b._42) or (a._43 <> b._43) or (a._44 <> b._44);
end;


{ TD2D_RECT_F }

procedure TD2D_RECT_F.Init(ALeft: single; ATop: single; ARight: single; ABottom: single);
begin
    Left := ALeft;
    Top := ATop;
    Right := ARight;
    Bottom := ABottom;
end;

{ TD2D_MATRIX_3X2_F }

class operator TD2D_MATRIX_3X2_F.Multiply(a: TD2D_MATRIX_3X2_F; b: TD2D_MATRIX_3X2_F): TD2D_MATRIX_3X2_F;
var
    c: TD2D_MATRIX_3X2_F;
begin
    c.SetProduct(a, b);
    Result := c;
end;



class operator TD2D_MATRIX_3X2_F.Multiply(a: TD2D_POINT_2F; b: TD2D_MATRIX_3X2_F): TD2D_POINT_2F;
begin
    Result := b.TransformPoint(a);
end;



procedure TD2D_MATRIX_3X2_F.Identity;
begin
    _11 := 1.0;
    _12 := 0.0;
    _21 := 0.0;
    _22 := 1.0;
    _31 := 0.0;
    _32 := 0.0;
end;



procedure TD2D_MATRIX_3X2_F.Translation(size: TD2D_SIZE_F);
begin
    _11 := 1.0;
    _12 := 0.0;
    _21 := 0.0;
    _22 := 1.0;
    _31 := size.Width;
    _32 := size.Height;
end;



procedure TD2D_MATRIX_3X2_F.Translation(x, y: single);
begin
    _11 := 1.0;
    _12 := 0.0;
    _21 := 0.0;
    _22 := 1.0;
    _31 := x;
    _32 := y;
end;



procedure TD2D_MATRIX_3X2_F.Rotation(angle: single; center: TD2D_POINT_2F);
var
    rotation: TD2D_MATRIX_3X2_F;
begin
    D2D1MakeRotateMatrix(angle, center, rotation);
    _11 := Rotation._11;
    _12 := Rotation._12;
    _21 := Rotation._21;
    _22 := Rotation._22;
    _31 := Rotation._31;
    _32 := Rotation._32;
end;



procedure TD2D_MATRIX_3X2_F.Rotation(angle: single; x, y: single);
var
    center: TD2D_POINT_2F;
    rotation: TD2D_MATRIX_3X2_F;
begin
    center := Point2F(x, y);
    D2D1MakeRotateMatrix(angle, center, rotation);

    _11 := Rotation._11;
    _12 := Rotation._12;
    _21 := Rotation._21;
    _22 := Rotation._22;
    _31 := Rotation._31;
    _32 := Rotation._32;
end;



procedure TD2D_MATRIX_3X2_F.Rotation(angle: single);
var
    center: TD2D_POINT_2F;
begin
    center := Point2F();
    Rotation(angle, center);
end;



procedure TD2D_MATRIX_3X2_F.Skew(angleX, angleY: single; center: TD2D_POINT_2F);
var
    skew: TD2D_MATRIX_3X2_F;
begin
    D2D1MakeSkewMatrix(angleX, angleY, center, skew);
    _11 := skew._11;
    _12 := skew._12;
    _21 := skew._21;
    _22 := skew._22;
    _31 := skew._31;
    _32 := skew._32;
end;



procedure TD2D_MATRIX_3X2_F.Skew(angleX, angleY: single);
var
    center: TD2D_POINT_2F;
begin
    center := Point2F();
    Skew(angleX, angleY, center);
end;



procedure TD2D_MATRIX_3X2_F.Scale(size: TD2D_SIZE_F; center: TD2D_POINT_2F);
begin
    _11 := size.Width;
    _12 := 0.0;
    _21 := 0.0;
    _22 := size.Height;
    _31 := center.x - size.Width * center.x;
    _32 := center.y - size.Height * center.y;
end;



procedure TD2D_MATRIX_3X2_F.Scale(x, y: single; center: TD2D_POINT_2F);
begin
    _11 := x;
    _12 := 0.0;
    _21 := 0.0;
    _22 := y;
    _31 := center.x - x * center.x;
    _32 := center.y - y * center.y;
end;



procedure TD2D_MATRIX_3X2_F.Scale(size: TD2D_SIZE_F);
begin
    _11 := size.Width;
    _12 := 0.0;
    _21 := 0.0;
    _22 := size.Height;
    _31 := 0;
    _32 := 0;
end;



procedure TD2D_MATRIX_3X2_F.Scale(x, y: single);
begin
    _11 := x;
    _12 := 0.0;
    _21 := 0.0;
    _22 := y;
    _31 := 0;
    _32 := 0;
end;



function TD2D_MATRIX_3X2_F.Determinant: single;
begin
    Result := (_11 * _22) - (_12 * _21);
end;



function TD2D_MATRIX_3X2_F.IsInvertible: longbool;
begin
    Result := D2D1IsMatrixInvertible(@self);
end;



function TD2D_MATRIX_3X2_F.Invert: longbool;
begin
    Result := D2D1InvertMatrix(self);
end;



function TD2D_MATRIX_3X2_F.IsIdentity: longbool;
begin
    Result := (_11 = 1.0) and (_12 = 0.0) and (_21 = 0.0) and (_22 = 1.0) and (_31 = 0.0) and (_32 = 0.0);
end;



procedure TD2D_MATRIX_3X2_F.SetProduct(a, b: TD2D_MATRIX_3X2_F);
begin
    _11 := a._11 * b._11 + a._12 * b._21;
    _12 := a._11 * b._12 + a._12 * b._22;
    _21 := a._21 * b._11 + a._22 * b._21;
    _22 := a._21 * b._12 + a._22 * b._22;
    _31 := a._31 * b._11 + a._32 * b._21 + b._31;
    _32 := a._31 * b._12 + a._32 * b._22 + b._32;
end;



function TD2D_MATRIX_3X2_F.TransformPoint(point: TD2D_POINT_2F): TD2D_POINT_2F;
begin
    Result.x := point.x * _11 + point.y * _21 + _31;
    Result.y := point.x * _12 + point.y * _22 + _32;
end;


end.
