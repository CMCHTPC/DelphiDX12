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
  File name: D2D1.h
  File name: D2D1_Helper.h
  File name: D2D1_1.h
  File name: D2D1_1Helper.h
  File name: D2D1_2.h
  File name: D2D1_2Helper.h
  File name: D2D1EffectAuthor.h
  File name: D2D1Effects.h
  File name: D2D1Effects_1.h
  File name: D2DBaseTypes.h

  ************************************************************************** }
{$ENDREGION}
{$REGION 'Notes'}
{ **************************************************************************
  Use the DirectX libaries from CMC. They are NOT based on the JSB headers

  Version 0.9 2015.02.18 - First release

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

unit DX12.D2D1;

{$IFDEF FPC}
{$MODE delphi}{$H+}
{$ENDIF}

interface

{$Z4}

uses
    Windows, Classes, SysUtils, DX12.DXGI, DX12.DCommon, DX12.D3DCommon, DX12.DWrite,
    DX12.WinCodec, ActiveX, DX12.DocumentTarget;

const
    D2D1_DLL = 'd2d1.dll';

const
     // defined in IntSafe.h
    UINT_MAX   = UINT($ffffffff);
    ULONGLONG_MAX  =UINT64($ffffffffffffffff);

    D2D1_INVALID_PROPERTY_INDEX = UINT_MAX;
    FACILITY_D2D = $899;

    MAKE_D2DHR_ERR = longword(1 shl 31) or longword(FACILITY_D2D shl 16);
    // D2D specific codes now live in winerror.h

const
    { D2D1.h }
    IID_ID2D1Resource: TGUID = '{2cd90691-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1Image: TGUID = '{65019f75-8da2-497c-b32c-dfa34e48ede6}';
    IID_ID2D1Bitmap: TGUID = '{a2296057-ea42-4099-983b-539fb6505426}';
    IID_ID2D1GradientStopCollection: TGUID = '{2cd906a7-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1Brush: TGUID = '{2cd906a8-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1BitmapBrush: TGUID = '{2cd906aa-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1SolidColorBrush: TGUID = '{2cd906a9-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1LinearGradientBrush: TGUID = '{2cd906ab-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1RadialGradientBrush: TGUID = '{2cd906ac-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1StrokeStyle: TGUID = '{2cd9069d-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1Geometry: TGUID = '{2cd906a1-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1RectangleGeometry: TGUID = '{2cd906a2-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1RoundedRectangleGeometry: TGUID = '{2cd906a3-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1EllipseGeometry: TGUID = '{2cd906a4-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1GeometryGroup: TGUID = '{2cd906a6-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1TransformedGeometry: TGUID = '{2cd906bb-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1SimplifiedGeometrySink: TGUID = '{2cd9069e-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1GeometrySink: TGUID = '{2cd9069f-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1TessellationSink: TGUID = '{2cd906c1-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1PathGeometry: TGUID = '{2cd906a5-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1Mesh: TGUID = '{2cd906c2-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1Layer: TGUID = '{2cd9069b-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1DrawingStateBlock: TGUID = '{28506e39-ebf6-46a1-bb47-fd85565ab957}';
    IID_ID2D1RenderTarget: TGUID = '{2cd90694-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1BitmapRenderTarget: TGUID = '{2cd90695-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1HwndRenderTarget: TGUID = '{2cd90698-12e2-11dc-9fed-001143a055f9}';
    IID_ID2D1GdiInteropRenderTarget: TGUID = '{e0db51c3-6f77-4bae-b3d5-e47509b35838}';
    IID_ID2D1DCRenderTarget: TGUID = '{1c51bc64-de61-46fd-9899-63a5d8f03950}';
    IID_ID2D1Factory: TGUID = '{06152247-6f50-465a-9245-118bfd3b6007}';

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

const
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

const
    D2D1_INVALID_TAG = ULONGLONG_MAX;
    D2D1_DEFAULT_FLATTENING_TOLERANCE = (0.25);

    D2D1_INTERPOLATION_MODE_DEFINITION_NEAREST_NEIGHBOR = 0;
    D2D1_INTERPOLATION_MODE_DEFINITION_LINEAR = 1;
    D2D1_INTERPOLATION_MODE_DEFINITION_CUBIC = 2;
    D2D1_INTERPOLATION_MODE_DEFINITION_MULTI_SAMPLE_LINEAR = 3;
    D2D1_INTERPOLATION_MODE_DEFINITION_ANISOTROPIC = 4;
    D2D1_INTERPOLATION_MODE_DEFINITION_HIGH_QUALITY_CUBIC = 5;
    D2D1_INTERPOLATION_MODE_DEFINITION_FANT = 6;
    D2D1_INTERPOLATION_MODE_DEFINITION_MIPMAP_LINEAR = 7;

type

    TD2D_POINT_2U = record
        x: UINT32;
        y: UINT32;
    end;

    TD2D_POINT_2F = record
        x: single;
        y: single;
    end;

    TD2D_POINT_2L = TPOINT;

    TD2D_VECTOR_2F = record
        x: single;
        y: single;
    end;

    TD2D_VECTOR_3F = record
        x: single;
        y: single;
        z: single;
    end;

    TD2D_VECTOR_4F = record
        x: single;
        y: single;
        z: single;
        w: single;
    end;

    { TD2D_RECT_F }

    TD2D_RECT_F = record
        left: single;
        top: single;
        right: single;
        bottom: single;
        procedure Init(ALeft: single = 0; ATop: single = 0; ARight: single = 0; ABottom: single = 0);
    end;

    { TD2D_RECT_U }

    TD2D_RECT_U = record
        left: UINT32;
        top: UINT32;
        right: UINT32;
        bottom: UINT32;
        class operator Equal(a, b: TD2D_RECT_U): longbool;
    end;

    TD2D_RECT_L = TRECT;

    TD2D_SIZE_F = record
        Width: single;
        Height: single;
    end;

    { TD2D_SIZE_U }

    TD2D_SIZE_U = record
        Width: UINT32;
        Height: UINT32;
        class operator Equal(a, b: TD2D_SIZE_U): longbool;
    end;

    TD2D_COLOR_F = TD3DCOLORVALUE;

    { TD2D_MATRIX_3X2_F }

    TD2D_MATRIX_3X2_F = record
        _11: single;
        _12: single;
        _21: single;
        _22: single;
        _31: single;
        _32: single;
        class operator Multiply(a: TD2D_MATRIX_3X2_F; b: TD2D_MATRIX_3X2_F): TD2D_MATRIX_3X2_F; overload;
        class operator Multiply(a: TD2D_POINT_2F; b: TD2D_MATRIX_3X2_F): TD2D_POINT_2F; overload;


        procedure Identity;
        procedure Translation(size: TD2D_SIZE_F); overload;
        procedure Translation(x, y: single); overload;
        procedure Rotation(angle: single; center: TD2D_POINT_2F); overload;
        procedure Rotation(angle: single); overload;
        procedure Skew(angleX, angleY: single; center: TD2D_POINT_2F); overload;
        procedure Skew(angleX, angleY: single); overload;
        procedure Scale(size: TD2D_SIZE_F; center: TD2D_POINT_2F); overload;
        procedure Scale(x, y: single; center: TD2D_POINT_2F); overload;
        procedure Scale(size: TD2D_SIZE_F); overload;
        procedure Scale(x, y: single); overload;
        function Determinant: single;
        function IsInvertible: longbool;
        function Invert: longbool;
        function IsIdentity: longbool;
        procedure SetProduct(a, b: TD2D_MATRIX_3X2_F);
        function TransformPoint(point: TD2D_POINT_2F): TD2D_POINT_2F;
    end;

    { TD2D_MATRIX_4X3_F }

    TD2D_MATRIX_4X3_F = record
        procedure Init; overload;
        procedure Init(m11, m12, m13, m21, m22, m23, m31, m32, m33, m41, m42, m43: single); overload;
        case integer of
            0: (_11, _12, _13: single;
                _21, _22, _23: single;
                _31, _32, _33: single;
                _41, _42, _43: single;);
            1: (m: array [0 .. 3, 0 .. 2] of single;);
    end;

    { TD2D_MATRIX_4X4_F }

    TD2D_MATRIX_4X4_F = record
        procedure Translation(x, y, z: single);
        procedure Scale(x, y, z: single);
        procedure RotationX(degreeX: single);
        procedure RotationY(degreeY: single);
        procedure RotationZ(degreeZ: single);
        procedure RotationArbitraryAxis(x, y, z, degree: single);
        procedure SkewX(degreeX: single);
        procedure SkewY(degreeY: single);
        procedure PerspectiveProjection(depth: single);
        procedure Init; overload;
        procedure Init(m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44: single); overload;
        function Determinant: single;
        function IsIdentity: longbool;
        procedure SetProduct(a, b: TD2D_MATRIX_4X4_F);
        class operator Multiply(a: TD2D_MATRIX_4X4_F; b: TD2D_MATRIX_4X4_F): TD2D_MATRIX_4X4_F;
        class operator Equal(a, b: TD2D_MATRIX_4X4_F): longbool;
        class operator NotEqual(a, b: TD2D_MATRIX_4X4_F): longbool;
        case integer of
            0: (_11, _12, _13, _14: single;
                _21, _22, _23, _24: single;
                _31, _32, _33, _34: single;
                _41, _42, _43, _44: single;);
            1: (m: array [0 .. 3, 0 .. 3] of single;);
    end;

    { TD2D_MATRIX_5X4_F }

    TD2D_MATRIX_5X4_F = record
        procedure Init; overload;
        procedure Init(m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44, m51, m52, m53, m54: single);
                overload;
        case integer of
            0: (_11, _12, _13, _14: single;
                _21, _22, _23, _24: single;
                _31, _32, _33, _34: single;
                _41, _42, _43, _44: single;
                _51, _52, _53, _54: single;);
            1: (m: array [0 .. 4, 0 .. 3] of single;);
    end;

type

    TD2D1_POINT_2U = TD2D_POINT_2U;
    PD2D1_POINT_2U = ^TD2D1_POINT_2U;

    TD2D1_POINT_2F = TD2D_POINT_2F;
    PD2D1_POINT_2F = ^TD2D1_POINT_2F;

    TD2D1_RECT_F = TD2D_RECT_F;
    PD2D1_RECT_F = ^TD2D1_RECT_F;

    TD2D1_RECT_U = TD2D_RECT_U;
    PD2D1_RECT_U = ^TD2D1_RECT_U;

    TD2D1_SIZE_F = TD2D_SIZE_F;
    PD2D1_SIZE_F = ^TD2D1_SIZE_F;

    TD2D1_SIZE_U = TD2D_SIZE_U;
    PD2D1_SIZE_U = ^TD2D1_SIZE_U;

    TD2D1_COLOR_F = TD2D_COLOR_F;
    PD2D1_COLOR_F = ^TD2D1_COLOR_F;

    TD2D1_MATRIX_3X2_F = TD2D_MATRIX_3X2_F;
    PD2D1_MATRIX_3X2_F = ^TD2D1_MATRIX_3X2_F;

    TD2D1_TAG = UINT64;
    PD2D1_TAG = ^TD2D1_TAG;

    TD2D1_GAMMA = (D2D1_GAMMA_2_2 = 0, D2D1_GAMMA_1_0 = 1, D2D1_GAMMA_FORCE_DWORD = $FFFFFFFF);

    TD2D1_OPACITY_MASK_CONTENT = (D2D1_OPACITY_MASK_CONTENT_GRAPHICS = 0, D2D1_OPACITY_MASK_CONTENT_TEXT_NATURAL = 1,
        D2D1_OPACITY_MASK_CONTENT_TEXT_GDI_COMPATIBLE = 2, D2D1_OPACITY_MASK_CONTENT_FORCE_DWORD = $FFFFFFFF);

    TD2D1_EXTEND_MODE = (D2D1_EXTEND_MODE_CLAMP = 0, D2D1_EXTEND_MODE_WRAP = 1, D2D1_EXTEND_MODE_MIRROR = 2,
        D2D1_EXTEND_MODE_FORCE_DWORD = $FFFFFFFF);

    PD2D1_EXTEND_MODE = ^TD2D1_EXTEND_MODE;

    TD2D1_ANTIALIAS_MODE = (D2D1_ANTIALIAS_MODE_PER_PRIMITIVE = 0, D2D1_ANTIALIAS_MODE_ALIASED = 1, D2D1_ANTIALIAS_MODE_FORCE_DWORD = $FFFFFFFF);

    TD2D1_TEXT_ANTIALIAS_MODE = (D2D1_TEXT_ANTIALIAS_MODE_DEFAULT = 0, D2D1_TEXT_ANTIALIAS_MODE_CLEARTYPE = 1,
        D2D1_TEXT_ANTIALIAS_MODE_GRAYSCALE = 2,
        D2D1_TEXT_ANTIALIAS_MODE_ALIASED = 3, D2D1_TEXT_ANTIALIAS_MODE_FORCE_DWORD = $FFFFFFFF);

    TD2D1_BITMAP_INTERPOLATION_MODE = (D2D1_BITMAP_INTERPOLATION_MODE_NEAREST_NEIGHBOR = D2D1_INTERPOLATION_MODE_DEFINITION_NEAREST_NEIGHBOR,
        D2D1_BITMAP_INTERPOLATION_MODE_LINEAR = D2D1_INTERPOLATION_MODE_DEFINITION_LINEAR, D2D1_BITMAP_INTERPOLATION_MODE_FORCE_DWORD = $FFFFFFFF);

    TD2D1_DRAW_TEXT_OPTIONS = (D2D1_DRAW_TEXT_OPTIONS_NO_SNAP = $00000001, D2D1_DRAW_TEXT_OPTIONS_CLIP = $00000002,
        D2D1_DRAW_TEXT_OPTIONS_ENABLE_COLOR_FONT = $00000004, D2D1_DRAW_TEXT_OPTIONS_NONE = $00000000,
        D2D1_DRAW_TEXT_OPTIONS_FORCE_DWORD = $FFFFFFFF);

    TD2D1_BITMAP_PROPERTIES = record
        pixelFormat: TD2D1_PIXEL_FORMAT;
        dpiX: single;
        dpiY: single;
    end;

    PD2D1_BITMAP_PROPERTIES = ^TD2D1_BITMAP_PROPERTIES;

    TD2D1_GRADIENT_STOP = record
        position: single;
        color: TD2D1_COLOR_F;
    end;

    PD2D1_GRADIENT_STOP = ^TD2D1_GRADIENT_STOP;

    TD2D1_BRUSH_PROPERTIES = record
        opacity: single;
        transform: TD2D1_MATRIX_3X2_F;
    end;

    PD2D1_BRUSH_PROPERTIES = ^TD2D1_BRUSH_PROPERTIES;

    TD2D1_BITMAP_BRUSH_PROPERTIES = record
        extendModeX: TD2D1_EXTEND_MODE;
        extendModeY: TD2D1_EXTEND_MODE;
        interpolationMode: TD2D1_BITMAP_INTERPOLATION_MODE;
    end;

    PD2D1_BITMAP_BRUSH_PROPERTIES = ^TD2D1_BITMAP_BRUSH_PROPERTIES;

    TD2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES = record
        startPoint: TD2D1_POINT_2F;
        endPoint: TD2D1_POINT_2F;
    end;

    PD2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES = ^TD2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES;

    TD2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES = record
        center: TD2D1_POINT_2F;
        gradientOriginOffset: TD2D1_POINT_2F;
        radiusX: single;
        radiusY: single;
    end;

    PD2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES = ^TD2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES;

    TD2D1_ARC_SIZE = (D2D1_ARC_SIZE_SMALL = 0, D2D1_ARC_SIZE_LARGE = 1, D2D1_ARC_SIZE_FORCE_DWORD = $FFFFFFFF);

    TD2D1_CAP_STYLE = (D2D1_CAP_STYLE_FLAT = 0, D2D1_CAP_STYLE_SQUARE = 1, D2D1_CAP_STYLE_ROUND = 2, D2D1_CAP_STYLE_TRIANGLE = 3,
        D2D1_CAP_STYLE_FORCE_DWORD = $FFFFFFFF);

    TD2D1_DASH_STYLE = (D2D1_DASH_STYLE_SOLID = 0, D2D1_DASH_STYLE_DASH = 1, D2D1_DASH_STYLE_DOT = 2, D2D1_DASH_STYLE_DASH_DOT = 3,
        D2D1_DASH_STYLE_DASH_DOT_DOT = 4, D2D1_DASH_STYLE_CUSTOM = 5, D2D1_DASH_STYLE_FORCE_DWORD = $FFFFFFFF);

    TD2D1_LINE_JOIN = (D2D1_LINE_JOIN_MITER = 0, D2D1_LINE_JOIN_BEVEL = 1, D2D1_LINE_JOIN_ROUND = 2, D2D1_LINE_JOIN_MITER_OR_BEVEL = 3,
        D2D1_LINE_JOIN_FORCE_DWORD = $FFFFFFFF);

    TD2D1_COMBINE_MODE = (D2D1_COMBINE_MODE_UNION = 0, D2D1_COMBINE_MODE_INTERSECT = 1, D2D1_COMBINE_MODE_XOR = 2, D2D1_COMBINE_MODE_EXCLUDE = 3,
        D2D1_COMBINE_MODE_FORCE_DWORD = $FFFFFFFF);

    TD2D1_GEOMETRY_RELATION = (D2D1_GEOMETRY_RELATION_UNKNOWN = 0, D2D1_GEOMETRY_RELATION_DISJOINT = 1, D2D1_GEOMETRY_RELATION_IS_CONTAINED = 2,
        D2D1_GEOMETRY_RELATION_CONTAINS = 3, D2D1_GEOMETRY_RELATION_OVERLAP = 4, D2D1_GEOMETRY_RELATION_FORCE_DWORD = $FFFFFFFF);

    TD2D1_GEOMETRY_SIMPLIFICATION_OPTION = (D2D1_GEOMETRY_SIMPLIFICATION_OPTION_CUBICS_AND_LINES = 0, D2D1_GEOMETRY_SIMPLIFICATION_OPTION_LINES = 1,
        D2D1_GEOMETRY_SIMPLIFICATION_OPTION_FORCE_DWORD = $FFFFFFFF);

    TD2D1_FIGURE_BEGIN = (D2D1_FIGURE_BEGIN_FILLED = 0, D2D1_FIGURE_BEGIN_HOLLOW = 1, D2D1_FIGURE_BEGIN_FORCE_DWORD = $FFFFFFFF);

    TD2D1_FIGURE_END = (D2D1_FIGURE_END_OPEN = 0, D2D1_FIGURE_END_CLOSED = 1, D2D1_FIGURE_END_FORCE_DWORD = $FFFFFFFF);

    TD2D1_BEZIER_SEGMENT = record
        point1: TD2D1_POINT_2F;
        point2: TD2D1_POINT_2F;
        point3: TD2D1_POINT_2F;
    end;

    PD2D1_BEZIER_SEGMENT = ^TD2D1_BEZIER_SEGMENT;

    TD2D1_TRIANGLE = record
        point1: TD2D1_POINT_2F;
        point2: TD2D1_POINT_2F;
        point3: TD2D1_POINT_2F;
    end;

    PD2D1_TRIANGLE = ^TD2D1_TRIANGLE;

    TD2D1_PATH_SEGMENT = (D2D1_PATH_SEGMENT_NONE = $00000000, D2D1_PATH_SEGMENT_FORCE_UNSTROKED = $00000001,
        D2D1_PATH_SEGMENT_FORCE_ROUND_LINE_JOIN = $00000002, D2D1_PATH_SEGMENT_FORCE_DWORD = $FFFFFFFF);

    TD2D1_SWEEP_DIRECTION = (D2D1_SWEEP_DIRECTION_COUNTER_CLOCKWISE = 0, D2D1_SWEEP_DIRECTION_CLOCKWISE = 1,
        D2D1_SWEEP_DIRECTION_FORCE_DWORD = $FFFFFFFF);

    TD2D1_FILL_MODE = (D2D1_FILL_MODE_ALTERNATE = 0, D2D1_FILL_MODE_WINDING = 1, D2D1_FILL_MODE_FORCE_DWORD = $FFFFFFFF);

    TD2D1_ARC_SEGMENT = record
        point: TD2D1_POINT_2F;
        size: TD2D1_SIZE_F;
        rotationAngle: single;
        sweepDirection: TD2D1_SWEEP_DIRECTION;
        arcSize: TD2D1_ARC_SIZE;
    end;

    PD2D1_ARC_SEGMENT = ^TD2D1_ARC_SEGMENT;

    TD2D1_QUADRATIC_BEZIER_SEGMENT = record
        point1: TD2D1_POINT_2F;
        point2: TD2D1_POINT_2F;
    end;

    PD2D1_QUADRATIC_BEZIER_SEGMENT = ^TD2D1_QUADRATIC_BEZIER_SEGMENT;

    TD2D1_ELLIPSE = record
        point: TD2D1_POINT_2F;
        radiusX: single;
        radiusY: single;
    end;

    PD2D1_ELLIPSE = ^TD2D1_ELLIPSE;

    TD2D1_ROUNDED_RECT = record
        rect: TD2D1_RECT_F;
        radiusX: single;
        radiusY: single;
    end;

    PD2D1_ROUNDED_RECT = ^TD2D1_ROUNDED_RECT;

    TD2D1_STROKE_STYLE_PROPERTIES = record
        startCap: TD2D1_CAP_STYLE;
        endCap: TD2D1_CAP_STYLE;
        dashCap: TD2D1_CAP_STYLE;
        lineJoin: TD2D1_LINE_JOIN;
        miterLimit: single;
        dashStyle: TD2D1_DASH_STYLE;
        dashOffset: single;
    end;

    PD2D1_STROKE_STYLE_PROPERTIES = ^TD2D1_STROKE_STYLE_PROPERTIES;

    TD2D1_LAYER_OPTIONS = (D2D1_LAYER_OPTIONS_NONE = $00000000, D2D1_LAYER_OPTIONS_INITIALIZE_FOR_CLEARTYPE = $00000001,
        D2D1_LAYER_OPTIONS_FORCE_DWORD = $FFFFFFFF);


    { D2D1Effects.h }

    TD2D1_BORDER_MODE = (
        D2D1_BORDER_MODE_SOFT = 0,
        D2D1_BORDER_MODE_HARD = 1,
        D2D1_BORDER_MODE_FORCE_DWORD = $ffffffff);

    TD2D1_CHANNEL_SELECTOR = (
        D2D1_CHANNEL_SELECTOR_R = 0,
        D2D1_CHANNEL_SELECTOR_G = 1,
        D2D1_CHANNEL_SELECTOR_B = 2,
        D2D1_CHANNEL_SELECTOR_A = 3,
        D2D1_CHANNEL_SELECTOR_FORCE_DWORD = $ffffffff
        );


    TD2D1_BITMAPSOURCE_ORIENTATION = (
        D2D1_BITMAPSOURCE_ORIENTATION_DEFAULT = 1,
        D2D1_BITMAPSOURCE_ORIENTATION_FLIP_HORIZONTAL = 2,
        D2D1_BITMAPSOURCE_ORIENTATION_ROTATE_CLOCKWISE180 = 3,
        D2D1_BITMAPSOURCE_ORIENTATION_ROTATE_CLOCKWISE180_FLIP_HORIZONTAL = 4,
        D2D1_BITMAPSOURCE_ORIENTATION_ROTATE_CLOCKWISE270_FLIP_HORIZONTAL = 5,
        D2D1_BITMAPSOURCE_ORIENTATION_ROTATE_CLOCKWISE90 = 6,
        D2D1_BITMAPSOURCE_ORIENTATION_ROTATE_CLOCKWISE90_FLIP_HORIZONTAL = 7,
        D2D1_BITMAPSOURCE_ORIENTATION_ROTATE_CLOCKWISE270 = 8,
        D2D1_BITMAPSOURCE_ORIENTATION_FORCE_DWORD = $ffffffff
        );

    TD2D1_GAUSSIANBLUR_PROP = (


        D2D1_GAUSSIANBLUR_PROP_STANDARD_DEVIATION = 0,
        D2D1_GAUSSIANBLUR_PROP_OPTIMIZATION = 1,
        D2D1_GAUSSIANBLUR_PROP_BORDER_MODE = 2,
        D2D1_GAUSSIANBLUR_PROP_FORCE_DWORD = $ffffffff
        );

    TD2D1_GAUSSIANBLUR_OPTIMIZATION = (
        D2D1_GAUSSIANBLUR_OPTIMIZATION_SPEED = 0,
        D2D1_GAUSSIANBLUR_OPTIMIZATION_BALANCED = 1,
        D2D1_GAUSSIANBLUR_OPTIMIZATION_QUALITY = 2,
        D2D1_GAUSSIANBLUR_OPTIMIZATION_FORCE_DWORD = $ffffffff
        );

    TD2D1_DIRECTIONALBLUR_PROP = (
        D2D1_DIRECTIONALBLUR_PROP_STANDARD_DEVIATION = 0,
        D2D1_DIRECTIONALBLUR_PROP_ANGLE = 1,
        D2D1_DIRECTIONALBLUR_PROP_OPTIMIZATION = 2,
        D2D1_DIRECTIONALBLUR_PROP_BORDER_MODE = 3,
        D2D1_DIRECTIONALBLUR_PROP_FORCE_DWORD = $ffffffff
        );

    TD2D1_DIRECTIONALBLUR_OPTIMIZATION = (
        D2D1_DIRECTIONALBLUR_OPTIMIZATION_SPEED = 0,
        D2D1_DIRECTIONALBLUR_OPTIMIZATION_BALANCED = 1,
        D2D1_DIRECTIONALBLUR_OPTIMIZATION_QUALITY = 2,
        D2D1_DIRECTIONALBLUR_OPTIMIZATION_FORCE_DWORD = $ffffffff

        );

    TD2D1_SHADOW_PROP = (
        D2D1_SHADOW_PROP_BLUR_STANDARD_DEVIATION = 0,
        D2D1_SHADOW_PROP_COLOR = 1,
        D2D1_SHADOW_PROP_OPTIMIZATION = 2,
        D2D1_SHADOW_PROP_FORCE_DWORD = $ffffffff
        );

    TD2D1_SHADOW_OPTIMIZATION = (
        D2D1_SHADOW_OPTIMIZATION_SPEED = 0,
        D2D1_SHADOW_OPTIMIZATION_BALANCED = 1,
        D2D1_SHADOW_OPTIMIZATION_QUALITY = 2,
        D2D1_SHADOW_OPTIMIZATION_FORCE_DWORD = $ffffffff
        );


    TD2D1_BLEND_PROP = (
        D2D1_BLEND_PROP_MODE = 0,
        D2D1_BLEND_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_BLEND_MODE = (
        D2D1_BLEND_MODE_MULTIPLY = 0,
        D2D1_BLEND_MODE_SCREEN = 1,
        D2D1_BLEND_MODE_DARKEN = 2,
        D2D1_BLEND_MODE_LIGHTEN = 3,
        D2D1_BLEND_MODE_DISSOLVE = 4,
        D2D1_BLEND_MODE_COLOR_BURN = 5,
        D2D1_BLEND_MODE_LINEAR_BURN = 6,
        D2D1_BLEND_MODE_DARKER_COLOR = 7,
        D2D1_BLEND_MODE_LIGHTER_COLOR = 8,
        D2D1_BLEND_MODE_COLOR_DODGE = 9,
        D2D1_BLEND_MODE_LINEAR_DODGE = 10,
        D2D1_BLEND_MODE_OVERLAY = 11,
        D2D1_BLEND_MODE_SOFT_LIGHT = 12,
        D2D1_BLEND_MODE_HARD_LIGHT = 13,
        D2D1_BLEND_MODE_VIVID_LIGHT = 14,
        D2D1_BLEND_MODE_LINEAR_LIGHT = 15,
        D2D1_BLEND_MODE_PIN_LIGHT = 16,
        D2D1_BLEND_MODE_HARD_MIX = 17,
        D2D1_BLEND_MODE_DIFFERENCE = 18,
        D2D1_BLEND_MODE_EXCLUSION = 19,
        D2D1_BLEND_MODE_HUE = 20,
        D2D1_BLEND_MODE_SATURATION = 21,
        D2D1_BLEND_MODE_COLOR = 22,
        D2D1_BLEND_MODE_LUMINOSITY = 23,
        D2D1_BLEND_MODE_SUBTRACT = 24,
        D2D1_BLEND_MODE_DIVISION = 25,
        D2D1_BLEND_MODE_FORCE_DWORD = $ffffffff
        );

    TD2D1_SATURATION_PROP = (
        D2D1_SATURATION_PROP_SATURATION = 0,
        D2D1_SATURATION_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_HUEROTATION_PROP = (
        D2D1_HUEROTATION_PROP_ANGLE = 0,
        D2D1_HUEROTATION_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_COLORMATRIX_PROP = (
        D2D1_COLORMATRIX_PROP_COLOR_MATRIX = 0,
        D2D1_COLORMATRIX_PROP_ALPHA_MODE = 1,
        D2D1_COLORMATRIX_PROP_CLAMP_OUTPUT = 2,
        D2D1_COLORMATRIX_PROP_FORCE_DWORD = $ffffffff
        );

    TD2D1_COLORMATRIX_ALPHA_MODE = (
        D2D1_COLORMATRIX_ALPHA_MODE_PREMULTIPLIED = 1,
        D2D1_COLORMATRIX_ALPHA_MODE_STRAIGHT = 2,
        D2D1_COLORMATRIX_ALPHA_MODE_FORCE_DWORD = $ffffffff
        );


    TD2D1_BITMAPSOURCE_PROP = (
        D2D1_BITMAPSOURCE_PROP_WIC_BITMAP_SOURCE = 0,
        D2D1_BITMAPSOURCE_PROP_SCALE = 1,
        D2D1_BITMAPSOURCE_PROP_INTERPOLATION_MODE = 2,
        D2D1_BITMAPSOURCE_PROP_ENABLE_DPI_CORRECTION = 3,
        D2D1_BITMAPSOURCE_PROP_ALPHA_MODE = 4,
        D2D1_BITMAPSOURCE_PROP_ORIENTATION = 5,
        D2D1_BITMAPSOURCE_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_BITMAPSOURCE_INTERPOLATION_MODE = (
        D2D1_BITMAPSOURCE_INTERPOLATION_MODE_NEAREST_NEIGHBOR = 0,
        D2D1_BITMAPSOURCE_INTERPOLATION_MODE_LINEAR = 1,
        D2D1_BITMAPSOURCE_INTERPOLATION_MODE_CUBIC = 2,
        D2D1_BITMAPSOURCE_INTERPOLATION_MODE_FANT = 6,
        D2D1_BITMAPSOURCE_INTERPOLATION_MODE_MIPMAP_LINEAR = 7,
        D2D1_BITMAPSOURCE_INTERPOLATION_MODE_FORCE_DWORD = $ffffffff
        );

    TD2D1_BITMAPSOURCE_ALPHA_MODE = (
        D2D1_BITMAPSOURCE_ALPHA_MODE_PREMULTIPLIED = 1,
        D2D1_BITMAPSOURCE_ALPHA_MODE_STRAIGHT = 2,
        D2D1_BITMAPSOURCE_ALPHA_MODE_FORCE_DWORD = $ffffffff
        );

    TD2D1_COMPOSITE_PROP = (
        D2D1_COMPOSITE_PROP_MODE = 0,
        D2D1_COMPOSITE_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_3DTRANSFORM_PROP = (
        D2D1_3DTRANSFORM_PROP_INTERPOLATION_MODE = 0,
        D2D1_3DTRANSFORM_PROP_BORDER_MODE = 1,
        D2D1_3DTRANSFORM_PROP_TRANSFORM_MATRIX = 2,
        D2D1_3DTRANSFORM_PROP_FORCE_DWORD = $ffffffff
        );

    TD2D1_3DTRANSFORM_INTERPOLATION_MODE = (
        D2D1_3DTRANSFORM_INTERPOLATION_MODE_NEAREST_NEIGHBOR = 0,
        D2D1_3DTRANSFORM_INTERPOLATION_MODE_LINEAR = 1,
        D2D1_3DTRANSFORM_INTERPOLATION_MODE_CUBIC = 2,
        D2D1_3DTRANSFORM_INTERPOLATION_MODE_MULTI_SAMPLE_LINEAR = 3,
        D2D1_3DTRANSFORM_INTERPOLATION_MODE_ANISOTROPIC = 4,
        D2D1_3DTRANSFORM_INTERPOLATION_MODE_FORCE_DWORD = $ffffffff
        );


    TD2D1_3DPERSPECTIVETRANSFORM_PROP = (
        D2D1_3DPERSPECTIVETRANSFORM_PROP_INTERPOLATION_MODE = 0,
        D2D1_3DPERSPECTIVETRANSFORM_PROP_BORDER_MODE = 1,
        D2D1_3DPERSPECTIVETRANSFORM_PROP_DEPTH = 2,
        D2D1_3DPERSPECTIVETRANSFORM_PROP_PERSPECTIVE_ORIGIN = 3,
        D2D1_3DPERSPECTIVETRANSFORM_PROP_LOCAL_OFFSET = 4,
        D2D1_3DPERSPECTIVETRANSFORM_PROP_GLOBAL_OFFSET = 5,
        D2D1_3DPERSPECTIVETRANSFORM_PROP_ROTATION_ORIGIN = 6,
        D2D1_3DPERSPECTIVETRANSFORM_PROP_ROTATION = 7,
        D2D1_3DPERSPECTIVETRANSFORM_PROP_FORCE_DWORD = $ffffffff
        );

    TD2D1_3DPERSPECTIVETRANSFORM_INTERPOLATION_MODE = (
        D2D1_3DPERSPECTIVETRANSFORM_INTERPOLATION_MODE_NEAREST_NEIGHBOR = 0,
        D2D1_3DPERSPECTIVETRANSFORM_INTERPOLATION_MODE_LINEAR = 1,
        D2D1_3DPERSPECTIVETRANSFORM_INTERPOLATION_MODE_CUBIC = 2,
        D2D1_3DPERSPECTIVETRANSFORM_INTERPOLATION_MODE_MULTI_SAMPLE_LINEAR = 3,
        D2D1_3DPERSPECTIVETRANSFORM_INTERPOLATION_MODE_ANISOTROPIC = 4,
        D2D1_3DPERSPECTIVETRANSFORM_INTERPOLATION_MODE_FORCE_DWORD = $ffffffff
        );

    TD2D1_2DAFFINETRANSFORM_PROP = (
        D2D1_2DAFFINETRANSFORM_PROP_INTERPOLATION_MODE = 0,
        D2D1_2DAFFINETRANSFORM_PROP_BORDER_MODE = 1,
        D2D1_2DAFFINETRANSFORM_PROP_TRANSFORM_MATRIX = 2,
        D2D1_2DAFFINETRANSFORM_PROP_SHARPNESS = 3,
        D2D1_2DAFFINETRANSFORM_PROP_FORCE_DWORD = $ffffffff
        );

    TD2D1_2DAFFINETRANSFORM_INTERPOLATION_MODE = (
        D2D1_2DAFFINETRANSFORM_INTERPOLATION_MODE_NEAREST_NEIGHBOR = 0,
        D2D1_2DAFFINETRANSFORM_INTERPOLATION_MODE_LINEAR = 1,
        D2D1_2DAFFINETRANSFORM_INTERPOLATION_MODE_CUBIC = 2,
        D2D1_2DAFFINETRANSFORM_INTERPOLATION_MODE_MULTI_SAMPLE_LINEAR = 3,
        D2D1_2DAFFINETRANSFORM_INTERPOLATION_MODE_ANISOTROPIC = 4,
        D2D1_2DAFFINETRANSFORM_INTERPOLATION_MODE_HIGH_QUALITY_CUBIC = 5,
        D2D1_2DAFFINETRANSFORM_INTERPOLATION_MODE_FORCE_DWORD = $ffffffff
        );


    TD2D1_DPICOMPENSATION_PROP = (
        D2D1_DPICOMPENSATION_PROP_INTERPOLATION_MODE = 0,
        D2D1_DPICOMPENSATION_PROP_BORDER_MODE = 1,
        D2D1_DPICOMPENSATION_PROP_INPUT_DPI = 2,
        D2D1_DPICOMPENSATION_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_DPICOMPENSATION_INTERPOLATION_MODE = (
        D2D1_DPICOMPENSATION_INTERPOLATION_MODE_NEAREST_NEIGHBOR = 0,
        D2D1_DPICOMPENSATION_INTERPOLATION_MODE_LINEAR = 1,
        D2D1_DPICOMPENSATION_INTERPOLATION_MODE_CUBIC = 2,
        D2D1_DPICOMPENSATION_INTERPOLATION_MODE_MULTI_SAMPLE_LINEAR = 3,
        D2D1_DPICOMPENSATION_INTERPOLATION_MODE_ANISOTROPIC = 4,
        D2D1_DPICOMPENSATION_INTERPOLATION_MODE_HIGH_QUALITY_CUBIC = 5,
        D2D1_DPICOMPENSATION_INTERPOLATION_MODE_FORCE_DWORD = $ffffffff
        );

    TD2D1_SCALE_PROP = (
        D2D1_SCALE_PROP_SCALE = 0,
        D2D1_SCALE_PROP_CENTER_POINT = 1,
        D2D1_SCALE_PROP_INTERPOLATION_MODE = 2,
        D2D1_SCALE_PROP_BORDER_MODE = 3,
        D2D1_SCALE_PROP_SHARPNESS = 4,
        D2D1_SCALE_PROP_FORCE_DWORD = $ffffffff
        );

    TD2D1_SCALE_INTERPOLATION_MODE = (
        D2D1_SCALE_INTERPOLATION_MODE_NEAREST_NEIGHBOR = 0,
        D2D1_SCALE_INTERPOLATION_MODE_LINEAR = 1,
        D2D1_SCALE_INTERPOLATION_MODE_CUBIC = 2,
        D2D1_SCALE_INTERPOLATION_MODE_MULTI_SAMPLE_LINEAR = 3,
        D2D1_SCALE_INTERPOLATION_MODE_ANISOTROPIC = 4,
        D2D1_SCALE_INTERPOLATION_MODE_HIGH_QUALITY_CUBIC = 5,
        D2D1_SCALE_INTERPOLATION_MODE_FORCE_DWORD = $ffffffff
        );

    TD2D1_TURBULENCE_PROP = (
        D2D1_TURBULENCE_PROP_OFFSET = 0,
        D2D1_TURBULENCE_PROP_SIZE = 1,
        D2D1_TURBULENCE_PROP_BASE_FREQUENCY = 2,
        D2D1_TURBULENCE_PROP_NUM_OCTAVES = 3,
        D2D1_TURBULENCE_PROP_SEED = 4,
        D2D1_TURBULENCE_PROP_NOISE = 5,
        D2D1_TURBULENCE_PROP_STITCHABLE = 6,
        D2D1_TURBULENCE_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_TURBULENCE_NOISE = (
        D2D1_TURBULENCE_NOISE_FRACTAL_SUM = 0,
        D2D1_TURBULENCE_NOISE_TURBULENCE = 1,
        D2D1_TURBULENCE_NOISE_FORCE_DWORD = $ffffffff
        );

    TD2D1_DISPLACEMENTMAP_PROP = (
        D2D1_DISPLACEMENTMAP_PROP_SCALE = 0,
        D2D1_DISPLACEMENTMAP_PROP_X_CHANNEL_SELECT = 1,
        D2D1_DISPLACEMENTMAP_PROP_Y_CHANNEL_SELECT = 2,
        D2D1_DISPLACEMENTMAP_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_COLORMANAGEMENT_PROP = (
        D2D1_COLORMANAGEMENT_PROP_SOURCE_COLOR_CONTEXT = 0,
        D2D1_COLORMANAGEMENT_PROP_SOURCE_RENDERING_INTENT = 1,
        D2D1_COLORMANAGEMENT_PROP_DESTINATION_COLOR_CONTEXT = 2,
        D2D1_COLORMANAGEMENT_PROP_DESTINATION_RENDERING_INTENT = 3,
        D2D1_COLORMANAGEMENT_PROP_ALPHA_MODE = 4,
        D2D1_COLORMANAGEMENT_PROP_QUALITY = 5,
        D2D1_COLORMANAGEMENT_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_COLORMANAGEMENT_ALPHA_MODE = (
        D2D1_COLORMANAGEMENT_ALPHA_MODE_PREMULTIPLIED = 1,
        D2D1_COLORMANAGEMENT_ALPHA_MODE_STRAIGHT = 2,
        D2D1_COLORMANAGEMENT_ALPHA_MODE_FORCE_DWORD = $ffffffff
        );


    TD2D1_COLORMANAGEMENT_QUALITY = (
        D2D1_COLORMANAGEMENT_QUALITY_PROOF = 0,
        D2D1_COLORMANAGEMENT_QUALITY_NORMAL = 1,
        D2D1_COLORMANAGEMENT_QUALITY_BEST = 2,
        D2D1_COLORMANAGEMENT_QUALITY_FORCE_DWORD = $ffffffff
        );


    TD2D1_COLORMANAGEMENT_RENDERING_INTENT = (
        D2D1_COLORMANAGEMENT_RENDERING_INTENT_PERCEPTUAL = 0,
        D2D1_COLORMANAGEMENT_RENDERING_INTENT_RELATIVE_COLORIMETRIC = 1,
        D2D1_COLORMANAGEMENT_RENDERING_INTENT_SATURATION = 2,
        D2D1_COLORMANAGEMENT_RENDERING_INTENT_ABSOLUTE_COLORIMETRIC = 3,
        D2D1_COLORMANAGEMENT_RENDERING_INTENT_FORCE_DWORD = $ffffffff
        );


    TD2D1_HISTOGRAM_PROP = (
        D2D1_HISTOGRAM_PROP_NUM_BINS = 0,
        D2D1_HISTOGRAM_PROP_CHANNEL_SELECT = 1,
        D2D1_HISTOGRAM_PROP_HISTOGRAM_OUTPUT = 2,
        D2D1_HISTOGRAM_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_POINTSPECULAR_PROP = (
        D2D1_POINTSPECULAR_PROP_LIGHT_POSITION = 0,
        D2D1_POINTSPECULAR_PROP_SPECULAR_EXPONENT = 1,
        D2D1_POINTSPECULAR_PROP_SPECULAR_CONSTANT = 2,
        D2D1_POINTSPECULAR_PROP_SURFACE_SCALE = 3,
        D2D1_POINTSPECULAR_PROP_COLOR = 4,
        D2D1_POINTSPECULAR_PROP_KERNEL_UNIT_LENGTH = 5,
        D2D1_POINTSPECULAR_PROP_SCALE_MODE = 6,
        D2D1_POINTSPECULAR_PROP_FORCE_DWORD = $ffffffff
        );

    TD2D1_POINTSPECULAR_SCALE_MODE = (
        D2D1_POINTSPECULAR_SCALE_MODE_NEAREST_NEIGHBOR = 0,
        D2D1_POINTSPECULAR_SCALE_MODE_LINEAR = 1,
        D2D1_POINTSPECULAR_SCALE_MODE_CUBIC = 2,
        D2D1_POINTSPECULAR_SCALE_MODE_MULTI_SAMPLE_LINEAR = 3,
        D2D1_POINTSPECULAR_SCALE_MODE_ANISOTROPIC = 4,
        D2D1_POINTSPECULAR_SCALE_MODE_HIGH_QUALITY_CUBIC = 5,
        D2D1_POINTSPECULAR_SCALE_MODE_FORCE_DWORD = $ffffffff
        );


    TD2D1_SPOTSPECULAR_PROP = (
        D2D1_SPOTSPECULAR_PROP_LIGHT_POSITION = 0,
        D2D1_SPOTSPECULAR_PROP_POINTS_AT = 1,
        D2D1_SPOTSPECULAR_PROP_FOCUS = 2,
        D2D1_SPOTSPECULAR_PROP_LIMITING_CONE_ANGLE = 3,
        D2D1_SPOTSPECULAR_PROP_SPECULAR_EXPONENT = 4,
        D2D1_SPOTSPECULAR_PROP_SPECULAR_CONSTANT = 5,
        D2D1_SPOTSPECULAR_PROP_SURFACE_SCALE = 6,
        D2D1_SPOTSPECULAR_PROP_COLOR = 7,
        D2D1_SPOTSPECULAR_PROP_KERNEL_UNIT_LENGTH = 8,
        D2D1_SPOTSPECULAR_PROP_SCALE_MODE = 9,
        D2D1_SPOTSPECULAR_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_SPOTSPECULAR_SCALE_MODE = (
        D2D1_SPOTSPECULAR_SCALE_MODE_NEAREST_NEIGHBOR = 0,
        D2D1_SPOTSPECULAR_SCALE_MODE_LINEAR = 1,
        D2D1_SPOTSPECULAR_SCALE_MODE_CUBIC = 2,
        D2D1_SPOTSPECULAR_SCALE_MODE_MULTI_SAMPLE_LINEAR = 3,
        D2D1_SPOTSPECULAR_SCALE_MODE_ANISOTROPIC = 4,
        D2D1_SPOTSPECULAR_SCALE_MODE_HIGH_QUALITY_CUBIC = 5,
        D2D1_SPOTSPECULAR_SCALE_MODE_FORCE_DWORD = $ffffffff
        );


    TD2D1_DISTANTSPECULAR_PROP = (
        D2D1_DISTANTSPECULAR_PROP_AZIMUTH = 0,
        D2D1_DISTANTSPECULAR_PROP_ELEVATION = 1,
        D2D1_DISTANTSPECULAR_PROP_SPECULAR_EXPONENT = 2,
        D2D1_DISTANTSPECULAR_PROP_SPECULAR_CONSTANT = 3,
        D2D1_DISTANTSPECULAR_PROP_SURFACE_SCALE = 4,
        D2D1_DISTANTSPECULAR_PROP_COLOR = 5,
        D2D1_DISTANTSPECULAR_PROP_KERNEL_UNIT_LENGTH = 6,
        D2D1_DISTANTSPECULAR_PROP_SCALE_MODE = 7,
        D2D1_DISTANTSPECULAR_PROP_FORCE_DWORD = $ffffffff
        );

    TD2D1_DISTANTSPECULAR_SCALE_MODE = (
        D2D1_DISTANTSPECULAR_SCALE_MODE_NEAREST_NEIGHBOR = 0,
        D2D1_DISTANTSPECULAR_SCALE_MODE_LINEAR = 1,
        D2D1_DISTANTSPECULAR_SCALE_MODE_CUBIC = 2,
        D2D1_DISTANTSPECULAR_SCALE_MODE_MULTI_SAMPLE_LINEAR = 3,
        D2D1_DISTANTSPECULAR_SCALE_MODE_ANISOTROPIC = 4,
        D2D1_DISTANTSPECULAR_SCALE_MODE_HIGH_QUALITY_CUBIC = 5,
        D2D1_DISTANTSPECULAR_SCALE_MODE_FORCE_DWORD = $ffffffff
        );


    TD2D1_POINTDIFFUSE_PROP = (
        D2D1_POINTDIFFUSE_PROP_LIGHT_POSITION = 0,
        D2D1_POINTDIFFUSE_PROP_DIFFUSE_CONSTANT = 1,
        D2D1_POINTDIFFUSE_PROP_SURFACE_SCALE = 2,
        D2D1_POINTDIFFUSE_PROP_COLOR = 3,
        D2D1_POINTDIFFUSE_PROP_KERNEL_UNIT_LENGTH = 4,
        D2D1_POINTDIFFUSE_PROP_SCALE_MODE = 5,
        D2D1_POINTDIFFUSE_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_POINTDIFFUSE_SCALE_MODE = (
        D2D1_POINTDIFFUSE_SCALE_MODE_NEAREST_NEIGHBOR = 0,
        D2D1_POINTDIFFUSE_SCALE_MODE_LINEAR = 1,
        D2D1_POINTDIFFUSE_SCALE_MODE_CUBIC = 2,
        D2D1_POINTDIFFUSE_SCALE_MODE_MULTI_SAMPLE_LINEAR = 3,
        D2D1_POINTDIFFUSE_SCALE_MODE_ANISOTROPIC = 4,
        D2D1_POINTDIFFUSE_SCALE_MODE_HIGH_QUALITY_CUBIC = 5,
        D2D1_POINTDIFFUSE_SCALE_MODE_FORCE_DWORD = $ffffffff
        );

    TD2D1_SPOTDIFFUSE_PROP = (
        D2D1_SPOTDIFFUSE_PROP_LIGHT_POSITION = 0,
        D2D1_SPOTDIFFUSE_PROP_POINTS_AT = 1,
        D2D1_SPOTDIFFUSE_PROP_FOCUS = 2,
        D2D1_SPOTDIFFUSE_PROP_LIMITING_CONE_ANGLE = 3,
        D2D1_SPOTDIFFUSE_PROP_DIFFUSE_CONSTANT = 4,
        D2D1_SPOTDIFFUSE_PROP_SURFACE_SCALE = 5,
        D2D1_SPOTDIFFUSE_PROP_COLOR = 6,
        D2D1_SPOTDIFFUSE_PROP_KERNEL_UNIT_LENGTH = 7,
        D2D1_SPOTDIFFUSE_PROP_SCALE_MODE = 8,
        D2D1_SPOTDIFFUSE_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_SPOTDIFFUSE_SCALE_MODE = (
        D2D1_SPOTDIFFUSE_SCALE_MODE_NEAREST_NEIGHBOR = 0,
        D2D1_SPOTDIFFUSE_SCALE_MODE_LINEAR = 1,
        D2D1_SPOTDIFFUSE_SCALE_MODE_CUBIC = 2,
        D2D1_SPOTDIFFUSE_SCALE_MODE_MULTI_SAMPLE_LINEAR = 3,
        D2D1_SPOTDIFFUSE_SCALE_MODE_ANISOTROPIC = 4,
        D2D1_SPOTDIFFUSE_SCALE_MODE_HIGH_QUALITY_CUBIC = 5,
        D2D1_SPOTDIFFUSE_SCALE_MODE_FORCE_DWORD = $ffffffff
        );


    TD2D1_DISTANTDIFFUSE_PROP = (
        D2D1_DISTANTDIFFUSE_PROP_AZIMUTH = 0,
        D2D1_DISTANTDIFFUSE_PROP_ELEVATION = 1,
        D2D1_DISTANTDIFFUSE_PROP_DIFFUSE_CONSTANT = 2,
        D2D1_DISTANTDIFFUSE_PROP_SURFACE_SCALE = 3,
        D2D1_DISTANTDIFFUSE_PROP_COLOR = 4,
        D2D1_DISTANTDIFFUSE_PROP_KERNEL_UNIT_LENGTH = 5,
        D2D1_DISTANTDIFFUSE_PROP_SCALE_MODE = 6,
        D2D1_DISTANTDIFFUSE_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_DISTANTDIFFUSE_SCALE_MODE = (
        D2D1_DISTANTDIFFUSE_SCALE_MODE_NEAREST_NEIGHBOR = 0,
        D2D1_DISTANTDIFFUSE_SCALE_MODE_LINEAR = 1,
        D2D1_DISTANTDIFFUSE_SCALE_MODE_CUBIC = 2,
        D2D1_DISTANTDIFFUSE_SCALE_MODE_MULTI_SAMPLE_LINEAR = 3,
        D2D1_DISTANTDIFFUSE_SCALE_MODE_ANISOTROPIC = 4,
        D2D1_DISTANTDIFFUSE_SCALE_MODE_HIGH_QUALITY_CUBIC = 5,
        D2D1_DISTANTDIFFUSE_SCALE_MODE_FORCE_DWORD = $ffffffff
        );


    TD2D1_FLOOD_PROP = (
        D2D1_FLOOD_PROP_COLOR = 0,
        D2D1_FLOOD_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_LINEARTRANSFER_PROP = (
        D2D1_LINEARTRANSFER_PROP_RED_Y_INTERCEPT = 0,
        D2D1_LINEARTRANSFER_PROP_RED_SLOPE = 1,
        D2D1_LINEARTRANSFER_PROP_RED_DISABLE = 2,
        D2D1_LINEARTRANSFER_PROP_GREEN_Y_INTERCEPT = 3,
        D2D1_LINEARTRANSFER_PROP_GREEN_SLOPE = 4,
        D2D1_LINEARTRANSFER_PROP_GREEN_DISABLE = 5,
        D2D1_LINEARTRANSFER_PROP_BLUE_Y_INTERCEPT = 6,
        D2D1_LINEARTRANSFER_PROP_BLUE_SLOPE = 7,
        D2D1_LINEARTRANSFER_PROP_BLUE_DISABLE = 8,
        D2D1_LINEARTRANSFER_PROP_ALPHA_Y_INTERCEPT = 9,
        D2D1_LINEARTRANSFER_PROP_ALPHA_SLOPE = 10,
        D2D1_LINEARTRANSFER_PROP_ALPHA_DISABLE = 11,
        D2D1_LINEARTRANSFER_PROP_CLAMP_OUTPUT = 12,
        D2D1_LINEARTRANSFER_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_GAMMATRANSFER_PROP = (
        D2D1_GAMMATRANSFER_PROP_RED_AMPLITUDE = 0,
        D2D1_GAMMATRANSFER_PROP_RED_EXPONENT = 1,
        D2D1_GAMMATRANSFER_PROP_RED_OFFSET = 2,
        D2D1_GAMMATRANSFER_PROP_RED_DISABLE = 3,
        D2D1_GAMMATRANSFER_PROP_GREEN_AMPLITUDE = 4,
        D2D1_GAMMATRANSFER_PROP_GREEN_EXPONENT = 5,
        D2D1_GAMMATRANSFER_PROP_GREEN_OFFSET = 6,
        D2D1_GAMMATRANSFER_PROP_GREEN_DISABLE = 7,
        D2D1_GAMMATRANSFER_PROP_BLUE_AMPLITUDE = 8,
        D2D1_GAMMATRANSFER_PROP_BLUE_EXPONENT = 9,
        D2D1_GAMMATRANSFER_PROP_BLUE_OFFSET = 10,
        D2D1_GAMMATRANSFER_PROP_BLUE_DISABLE = 11,
        D2D1_GAMMATRANSFER_PROP_ALPHA_AMPLITUDE = 12,
        D2D1_GAMMATRANSFER_PROP_ALPHA_EXPONENT = 13,
        D2D1_GAMMATRANSFER_PROP_ALPHA_OFFSET = 14,
        D2D1_GAMMATRANSFER_PROP_ALPHA_DISABLE = 15,
        D2D1_GAMMATRANSFER_PROP_CLAMP_OUTPUT = 16,
        D2D1_GAMMATRANSFER_PROP_FORCE_DWORD = $ffffffff
        );

    TD2D1_TABLETRANSFER_PROP = (
        D2D1_TABLETRANSFER_PROP_RED_TABLE = 0,
        D2D1_TABLETRANSFER_PROP_RED_DISABLE = 1,
        D2D1_TABLETRANSFER_PROP_GREEN_TABLE = 2,
        D2D1_TABLETRANSFER_PROP_GREEN_DISABLE = 3,
        D2D1_TABLETRANSFER_PROP_BLUE_TABLE = 4,
        D2D1_TABLETRANSFER_PROP_BLUE_DISABLE = 5,
        D2D1_TABLETRANSFER_PROP_ALPHA_TABLE = 6,
        D2D1_TABLETRANSFER_PROP_ALPHA_DISABLE = 7,
        D2D1_TABLETRANSFER_PROP_CLAMP_OUTPUT = 8,
        D2D1_TABLETRANSFER_PROP_FORCE_DWORD = $ffffffff
        );

    TD2D1_DISCRETETRANSFER_PROP = (
        D2D1_DISCRETETRANSFER_PROP_RED_TABLE = 0,
        D2D1_DISCRETETRANSFER_PROP_RED_DISABLE = 1,
        D2D1_DISCRETETRANSFER_PROP_GREEN_TABLE = 2,
        D2D1_DISCRETETRANSFER_PROP_GREEN_DISABLE = 3,
        D2D1_DISCRETETRANSFER_PROP_BLUE_TABLE = 4,
        D2D1_DISCRETETRANSFER_PROP_BLUE_DISABLE = 5,
        D2D1_DISCRETETRANSFER_PROP_ALPHA_TABLE = 6,
        D2D1_DISCRETETRANSFER_PROP_ALPHA_DISABLE = 7,
        D2D1_DISCRETETRANSFER_PROP_CLAMP_OUTPUT = 8,
        D2D1_DISCRETETRANSFER_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_CONVOLVEMATRIX_PROP = (
        D2D1_CONVOLVEMATRIX_PROP_KERNEL_UNIT_LENGTH = 0,
        D2D1_CONVOLVEMATRIX_PROP_SCALE_MODE = 1,
        D2D1_CONVOLVEMATRIX_PROP_KERNEL_SIZE_X = 2,
        D2D1_CONVOLVEMATRIX_PROP_KERNEL_SIZE_Y = 3,
        D2D1_CONVOLVEMATRIX_PROP_KERNEL_MATRIX = 4,
        D2D1_CONVOLVEMATRIX_PROP_DIVISOR = 5,
        D2D1_CONVOLVEMATRIX_PROP_BIAS = 6,
        D2D1_CONVOLVEMATRIX_PROP_KERNEL_OFFSET = 7,
        D2D1_CONVOLVEMATRIX_PROP_PRESERVE_ALPHA = 8,
        D2D1_CONVOLVEMATRIX_PROP_BORDER_MODE = 9,
        D2D1_CONVOLVEMATRIX_PROP_CLAMP_OUTPUT = 10,
        D2D1_CONVOLVEMATRIX_PROP_FORCE_DWORD = $ffffffff
        );

    TD2D1_CONVOLVEMATRIX_SCALE_MODE = (
        D2D1_CONVOLVEMATRIX_SCALE_MODE_NEAREST_NEIGHBOR = 0,
        D2D1_CONVOLVEMATRIX_SCALE_MODE_LINEAR = 1,
        D2D1_CONVOLVEMATRIX_SCALE_MODE_CUBIC = 2,
        D2D1_CONVOLVEMATRIX_SCALE_MODE_MULTI_SAMPLE_LINEAR = 3,
        D2D1_CONVOLVEMATRIX_SCALE_MODE_ANISOTROPIC = 4,
        D2D1_CONVOLVEMATRIX_SCALE_MODE_HIGH_QUALITY_CUBIC = 5,
        D2D1_CONVOLVEMATRIX_SCALE_MODE_FORCE_DWORD = $ffffffff
        );


    TD2D1_BRIGHTNESS_PROP = (
        D2D1_BRIGHTNESS_PROP_WHITE_POINT = 0,
        D2D1_BRIGHTNESS_PROP_BLACK_POINT = 1,
        D2D1_BRIGHTNESS_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_ARITHMETICCOMPOSITE_PROP = (
        D2D1_ARITHMETICCOMPOSITE_PROP_COEFFICIENTS = 0,
        D2D1_ARITHMETICCOMPOSITE_PROP_CLAMP_OUTPUT = 1,
        D2D1_ARITHMETICCOMPOSITE_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_CROP_PROP = (
        D2D1_CROP_PROP_RECT = 0,
        D2D1_CROP_PROP_BORDER_MODE = 1,
        D2D1_CROP_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_BORDER_PROP = (
        D2D1_BORDER_PROP_EDGE_MODE_X = 0,
        D2D1_BORDER_PROP_EDGE_MODE_Y = 1,
        D2D1_BORDER_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_BORDER_EDGE_MODE = (
        D2D1_BORDER_EDGE_MODE_CLAMP = 0,
        D2D1_BORDER_EDGE_MODE_WRAP = 1,
        D2D1_BORDER_EDGE_MODE_MIRROR = 2,
        D2D1_BORDER_EDGE_MODE_FORCE_DWORD = $ffffffff
        );


    TD2D1_MORPHOLOGY_PROP = (
        D2D1_MORPHOLOGY_PROP_MODE = 0,
        D2D1_MORPHOLOGY_PROP_WIDTH = 1,
        D2D1_MORPHOLOGY_PROP_HEIGHT = 2,
        D2D1_MORPHOLOGY_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_MORPHOLOGY_MODE = (
        D2D1_MORPHOLOGY_MODE_ERODE = 0,
        D2D1_MORPHOLOGY_MODE_DILATE = 1,
        D2D1_MORPHOLOGY_MODE_FORCE_DWORD = $ffffffff
        );


    TD2D1_TILE_PROP = (
        D2D1_TILE_PROP_RECT = 0,
        D2D1_TILE_PROP_FORCE_DWORD = $ffffffff
        );

    TD2D1_ATLAS_PROP = (
        D2D1_ATLAS_PROP_INPUT_RECT = 0,
        D2D1_ATLAS_PROP_INPUT_PADDING_RECT = 1,
        D2D1_ATLAS_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_OPACITYMETADATA_PROP = (
        D2D1_OPACITYMETADATA_PROP_INPUT_OPAQUE_RECT = 0,
        D2D1_OPACITYMETADATA_PROP_FORCE_DWORD = $ffffffff
        );

    TD2D1_DC_INITIALIZE_MODE = (D2D1_DC_INITIALIZE_MODE_COPY = 0, D2D1_DC_INITIALIZE_MODE_CLEAR = 1,
        D2D1_DC_INITIALIZE_MODE_FORCE_DWORD = $FFFFFFFF);

    TD2D1_DEBUG_LEVEL = (D2D1_DEBUG_LEVEL_NONE = 0, D2D1_DEBUG_LEVEL_ERROR = 1, D2D1_DEBUG_LEVEL_WARNING = 2, D2D1_DEBUG_LEVEL_INFORMATION = 3,
        D2D1_DEBUG_LEVEL_FORCE_DWORD = $FFFFFFFF);

    TD2D1_FACTORY_TYPE = (D2D1_FACTORY_TYPE_SINGLE_THREADED = 0, D2D1_FACTORY_TYPE_MULTI_THREADED = 1, D2D1_FACTORY_TYPE_FORCE_DWORD = $FFFFFFFF);

    { D2D1Effects_1.h }

    TD2D1_YCBCR_PROP = (
        D2D1_YCBCR_PROP_CHROMA_SUBSAMPLING = 0,
        D2D1_YCBCR_PROP_TRANSFORM_MATRIX = 1,
        D2D1_YCBCR_PROP_INTERPOLATION_MODE = 2,
        D2D1_YCBCR_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_YCBCR_CHROMA_SUBSAMPLING = (
        D2D1_YCBCR_CHROMA_SUBSAMPLING_AUTO = 0,
        D2D1_YCBCR_CHROMA_SUBSAMPLING_420 = 1,
        D2D1_YCBCR_CHROMA_SUBSAMPLING_422 = 2,
        D2D1_YCBCR_CHROMA_SUBSAMPLING_444 = 3,
        D2D1_YCBCR_CHROMA_SUBSAMPLING_440 = 4,
        D2D1_YCBCR_CHROMA_SUBSAMPLING_FORCE_DWORD = $ffffffff
        );


    TD2D1_YCBCR_INTERPOLATION_MODE = (
        D2D1_YCBCR_INTERPOLATION_MODE_NEAREST_NEIGHBOR = 0,
        D2D1_YCBCR_INTERPOLATION_MODE_LINEAR = 1,
        D2D1_YCBCR_INTERPOLATION_MODE_CUBIC = 2,
        D2D1_YCBCR_INTERPOLATION_MODE_MULTI_SAMPLE_LINEAR = 3,
        D2D1_YCBCR_INTERPOLATION_MODE_ANISOTROPIC = 4,
        D2D1_YCBCR_INTERPOLATION_MODE_HIGH_QUALITY_CUBIC = 5,
        D2D1_YCBCR_INTERPOLATION_MODE_FORCE_DWORD = $ffffffff
        );

    { D2D1EffectAuthor.h}
    TD2D1_CHANGE_TYPE = (
        D2D1_CHANGE_TYPE_NONE = 0,
        D2D1_CHANGE_TYPE_PROPERTIES = 1,
        D2D1_CHANGE_TYPE_CONTEXT = 2,
        D2D1_CHANGE_TYPE_GRAPH = 3,
        D2D1_CHANGE_TYPE_FORCE_DWORD = $ffffffff);

    TD2D1_PIXEL_OPTIONS = (
        D2D1_PIXEL_OPTIONS_NONE = 0,
        D2D1_PIXEL_OPTIONS_TRIVIAL_SAMPLING = 1,
        D2D1_PIXEL_OPTIONS_FORCE_DWORD = $ffffffff);

    TD2D1_VERTEX_OPTIONS = (
        D2D1_VERTEX_OPTIONS_NONE = 0,
        D2D1_VERTEX_OPTIONS_DO_NOT_CLEAR = 1,
        D2D1_VERTEX_OPTIONS_USE_DEPTH_BUFFER = 2,
        D2D1_VERTEX_OPTIONS_ASSUME_NO_OVERLAP = 4,
        D2D1_VERTEX_OPTIONS_FORCE_DWORD = $ffffffff);


    TD2D1_VERTEX_USAGE = (
        D2D1_VERTEX_USAGE_STATIC = 0,
        D2D1_VERTEX_USAGE_DYNAMIC = 1,
        D2D1_VERTEX_USAGE_FORCE_DWORD = $ffffffff);


    TD2D1_BLEND_OPERATION = (
        D2D1_BLEND_OPERATION_ADD = 1,
        D2D1_BLEND_OPERATION_SUBTRACT = 2,
        D2D1_BLEND_OPERATION_REV_SUBTRACT = 3,
        D2D1_BLEND_OPERATION_MIN = 4,
        D2D1_BLEND_OPERATION_MAX = 5,
        D2D1_BLEND_OPERATION_FORCE_DWORD = $ffffffff);


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
        D2D1_BLEND_FORCE_DWORD = $ffffffff);


    TD2D1_CHANNEL_DEPTH = (
        D2D1_CHANNEL_DEPTH_DEFAULT = 0,
        D2D1_CHANNEL_DEPTH_1 = 1,
        D2D1_CHANNEL_DEPTH_4 = 4,
        D2D1_CHANNEL_DEPTH_FORCE_DWORD = $ffffffff);


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
        D2D1_FILTER_FORCE_DWORD = $ffffffff);


    TD2D1_FEATURE = (
        D2D1_FEATURE_DOUBLES = 0,
        D2D1_FEATURE_D3D10_X_HARDWARE_OPTIONS = 1,
        D2D1_FEATURE_FORCE_DWORD = $ffffffff);


    { D2D1_1.h }
    TD2D1_RECT_L = TD2D_RECT_L;
    PD2D1_RECT_L = ^TD2D1_RECT_L;

    TD2D1_POINT_2L = TD2D_POINT_2L;
    PD2D1_POINT_2L = ^TD2D1_POINT_2L;

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
        D2D1_PROPERTY_TYPE_FORCE_DWORD = $ffffffff);

    TD2D1_PROPERTY = (
        D2D1_PROPERTY_CLSID = $80000000,
        D2D1_PROPERTY_DISPLAYNAME = $80000001,
        D2D1_PROPERTY_AUTHOR = $80000002,
        D2D1_PROPERTY_CATEGORY = $80000003,
        D2D1_PROPERTY_DESCRIPTION = $80000004,
        D2D1_PROPERTY_INPUTS = $80000005,
        D2D1_PROPERTY_CACHED = $80000006,
        D2D1_PROPERTY_PRECISION = $80000007,
        D2D1_PROPERTY_MIN_INPUTS = $80000008,
        D2D1_PROPERTY_MAX_INPUTS = $80000009,
        D2D1_PROPERTY_FORCE_DWORD = $ffffffff);

    TD2D1_SUBPROPERTY = (
        D2D1_SUBPROPERTY_DISPLAYNAME = $80000000,
        D2D1_SUBPROPERTY_ISREADONLY = $80000001,
        D2D1_SUBPROPERTY_MIN = $80000002,
        D2D1_SUBPROPERTY_MAX = $80000003,
        D2D1_SUBPROPERTY_DEFAULT = $80000004,
        D2D1_SUBPROPERTY_FIELDS = $80000005,
        D2D1_SUBPROPERTY_INDEX = $80000006,
        D2D1_SUBPROPERTY_FORCE_DWORD = $ffffffff);

    TD2D1_BITMAP_OPTIONS = (
        D2D1_BITMAP_OPTIONS_NONE = $00000000,
        D2D1_BITMAP_OPTIONS_TARGET = $00000001,
        D2D1_BITMAP_OPTIONS_CANNOT_DRAW = $00000002,
        D2D1_BITMAP_OPTIONS_CPU_READ = $00000004,
        D2D1_BITMAP_OPTIONS_GDI_COMPATIBLE = $00000008,
        D2D1_BITMAP_OPTIONS_FORCE_DWORD = $ffffffff);

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
        D2D1_COMPOSITE_MODE_FORCE_DWORD = $ffffffff);


    TD2D1_BUFFER_PRECISION = (
        D2D1_BUFFER_PRECISION_UNKNOWN = 0,
        D2D1_BUFFER_PRECISION_8BPC_UNORM = 1,
        D2D1_BUFFER_PRECISION_8BPC_UNORM_SRGB = 2,
        D2D1_BUFFER_PRECISION_16BPC_UNORM = 3,
        D2D1_BUFFER_PRECISION_16BPC_FLOAT = 4,
        D2D1_BUFFER_PRECISION_32BPC_FLOAT = 5,
        D2D1_BUFFER_PRECISION_FORCE_DWORD = $ffffffff);


    TD2D1_MAP_OPTIONS = (
        D2D1_MAP_OPTIONS_NONE = 0,
        D2D1_MAP_OPTIONS_READ = 1,
        D2D1_MAP_OPTIONS_WRITE = 2,
        D2D1_MAP_OPTIONS_DISCARD = 4,
        D2D1_MAP_OPTIONS_FORCE_DWORD = $ffffffff);

    TD2D1_INTERPOLATION_MODE = (
        D2D1_INTERPOLATION_MODE_NEAREST_NEIGHBOR = D2D1_INTERPOLATION_MODE_DEFINITION_NEAREST_NEIGHBOR,
        D2D1_INTERPOLATION_MODE_LINEAR = D2D1_INTERPOLATION_MODE_DEFINITION_LINEAR,
        D2D1_INTERPOLATION_MODE_CUBIC = D2D1_INTERPOLATION_MODE_DEFINITION_CUBIC,
        D2D1_INTERPOLATION_MODE_MULTI_SAMPLE_LINEAR = D2D1_INTERPOLATION_MODE_DEFINITION_MULTI_SAMPLE_LINEAR,
        D2D1_INTERPOLATION_MODE_ANISOTROPIC = D2D1_INTERPOLATION_MODE_DEFINITION_ANISOTROPIC,
        D2D1_INTERPOLATION_MODE_HIGH_QUALITY_CUBIC = D2D1_INTERPOLATION_MODE_DEFINITION_HIGH_QUALITY_CUBIC,
        D2D1_INTERPOLATION_MODE_FORCE_DWORD = $ffffffff);


    TD2D1_UNIT_MODE = (
        D2D1_UNIT_MODE_DIPS = 0,
        D2D1_UNIT_MODE_PIXELS = 1,
        D2D1_UNIT_MODE_FORCE_DWORD = $ffffffff);


    TD2D1_COLOR_SPACE = (
        D2D1_COLOR_SPACE_CUSTOM = 0,
        D2D1_COLOR_SPACE_SRGB = 1,
        D2D1_COLOR_SPACE_SCRGB = 2,
        D2D1_COLOR_SPACE_FORCE_DWORD = $ffffffff);


    TD2D1_DEVICE_CONTEXT_OPTIONS = (
        D2D1_DEVICE_CONTEXT_OPTIONS_NONE = 0,
        D2D1_DEVICE_CONTEXT_OPTIONS_ENABLE_MULTITHREADED_OPTIMIZATIONS = 1,
        D2D1_DEVICE_CONTEXT_OPTIONS_FORCE_DWORD = $ffffffff);


    TD2D1_STROKE_TRANSFORM_TYPE = (
        D2D1_STROKE_TRANSFORM_TYPE_NORMAL = 0,
        D2D1_STROKE_TRANSFORM_TYPE_FIXED = 1,
        D2D1_STROKE_TRANSFORM_TYPE_HAIRLINE = 2,
        D2D1_STROKE_TRANSFORM_TYPE_FORCE_DWORD = $ffffffff);


    TD2D1_PRIMITIVE_BLEND = (
        D2D1_PRIMITIVE_BLEND_SOURCE_OVER = 0,
        D2D1_PRIMITIVE_BLEND_COPY = 1,
        D2D1_PRIMITIVE_BLEND_MIN = 2,
        D2D1_PRIMITIVE_BLEND_ADD = 3,
        D2D1_PRIMITIVE_BLEND_FORCE_DWORD = $ffffffff);


    TD2D1_THREADING_MODE = (
        D2D1_THREADING_MODE_SINGLE_THREADED = Ord(D2D1_FACTORY_TYPE_SINGLE_THREADED),
        D2D1_THREADING_MODE_MULTI_THREADED = Ord(D2D1_FACTORY_TYPE_MULTI_THREADED),
        D2D1_THREADING_MODE_FORCE_DWORD = $ffffffff);

    TD2D1_COLOR_INTERPOLATION_MODE = (
        D2D1_COLOR_INTERPOLATION_MODE_STRAIGHT = 0,
        D2D1_COLOR_INTERPOLATION_MODE_PREMULTIPLIED = 1,
        D2D1_COLOR_INTERPOLATION_MODE_FORCE_DWORD = $ffffffff);


    ID2D1ColorContext = interface;

    TD2D1_BITMAP_PROPERTIES1 = record
        pixelFormat: TD2D1_PIXEL_FORMAT;
        dpiX: single;
        dpiY: single;
        bitmapOptions: TD2D1_BITMAP_OPTIONS;
        colorContext: ID2D1ColorContext;
    end;

    PD2D1_BITMAP_PROPERTIES1 = ^TD2D1_BITMAP_PROPERTIES1;


    TD2D1_MAPPED_RECT = record
        pitch: UINT32;
        bits: PBYTE;
    end;

    PD2D1_MAPPED_RECT = ^TD2D1_MAPPED_RECT;


    TD2D1_RENDERING_CONTROLS = record
        bufferPrecision: TD2D1_BUFFER_PRECISION;
        tileSize: TD2D1_SIZE_U;
    end;

    PD2D1_RENDERING_CONTROLS = ^TD2D1_RENDERING_CONTROLS;


    ID2D1Effect = interface;
    { D2D1.h }
    ID2D1Geometry = interface;
    PID2D1Geometry = ^ID2D1Geometry;
    ID2D1Brush = interface;
    ID2D1Factory = interface;
    ID2D1RenderTarget = interface;
    ID2D1SimplifiedGeometrySink = interface;
    ID2D1TessellationSink = interface;

    TD2D1_EFFECT_INPUT_DESCRIPTION = record
        effect: ID2D1Effect;
        inputIndex: UINT32;
        inputRectangle: TD2D1_RECT_F;
    end;

    PD2D1_EFFECT_INPUT_DESCRIPTION = ^TD2D1_EFFECT_INPUT_DESCRIPTION;


    TD2D1_VECTOR_2F = TD2D_VECTOR_2F;
    TD2D1_VECTOR_3F = TD2D_VECTOR_3F;
    TD2D1_VECTOR_4F = TD2D_VECTOR_4F;


    TD2D1_MATRIX_4X3_F = TD2D_MATRIX_4X3_F;
    PD2D1_MATRIX_4X3_F = ^TD2D1_MATRIX_4X3_F;

    TD2D1_MATRIX_4X4_F = TD2D_MATRIX_4X4_F;
    PD2D1_MATRIX_4X4_F = ^TD2D1_MATRIX_4X4_F;

    TD2D1_MATRIX_5X4_F = TD2D_MATRIX_5X4_F;
    PD2D1_MATRIX_5X4_F = ^TD2D1_MATRIX_5X4_F;


    TD2D1_POINT_DESCRIPTION = record
        point: TD2D1_POINT_2F;
        unitTangentVector: TD2D1_POINT_2F;
        endSegment: UINT32;
        endFigure: UINT32;
        lengthToEndSegment: single;
    end;

    PD2D1_POINT_DESCRIPTION = ^TD2D1_POINT_DESCRIPTION;


    TD2D1_IMAGE_BRUSH_PROPERTIES = record
        sourceRectangle: TD2D1_RECT_F;
        extendModeX: TD2D1_EXTEND_MODE;
        extendModeY: TD2D1_EXTEND_MODE;
        interpolationMode: TD2D1_INTERPOLATION_MODE;
    end;

    PD2D1_IMAGE_BRUSH_PROPERTIES = ^TD2D1_IMAGE_BRUSH_PROPERTIES;


    TD2D1_BITMAP_BRUSH_PROPERTIES1 = record
        extendModeX: TD2D1_EXTEND_MODE;
        extendModeY: TD2D1_EXTEND_MODE;
        interpolationMode: TD2D1_INTERPOLATION_MODE;
    end;

    PD2D1_BITMAP_BRUSH_PROPERTIES1 = ^TD2D1_BITMAP_BRUSH_PROPERTIES1;


    TD2D1_STROKE_STYLE_PROPERTIES1 = record
        startCap: TD2D1_CAP_STYLE;
        endCap: TD2D1_CAP_STYLE;
        dashCap: TD2D1_CAP_STYLE;
        lineJoin: TD2D1_LINE_JOIN;
        miterLimit: single;
        dashStyle: TD2D1_DASH_STYLE;
        dashOffset: single;
        transformType: TD2D1_STROKE_TRANSFORM_TYPE;
    end;

    PD2D1_STROKE_STYLE_PROPERTIES1 = ^TD2D1_STROKE_STYLE_PROPERTIES1;


    TD2D1_LAYER_OPTIONS1 = (
        D2D1_LAYER_OPTIONS1_NONE = 0,
        D2D1_LAYER_OPTIONS1_INITIALIZE_FROM_BACKGROUND = 1,
        D2D1_LAYER_OPTIONS1_IGNORE_ALPHA = 2,
        D2D1_LAYER_OPTIONS1_FORCE_DWORD = $ffffffff);


    TD2D1_LAYER_PARAMETERS1 = record
        contentBounds: TD2D1_RECT_F;
        geometricMask: ID2D1Geometry;
        maskAntialiasMode: TD2D1_ANTIALIAS_MODE;
        maskTransform: TD2D1_MATRIX_3X2_F;
        opacity: single;
        opacityBrush: ID2D1Brush;
        layerOptions: TD2D1_LAYER_OPTIONS1;
    end;

    PD2D1_LAYER_PARAMETERS1 = ^TD2D1_LAYER_PARAMETERS1;


    TD2D1_PRINT_FONT_SUBSET_MODE = (
        D2D1_PRINT_FONT_SUBSET_MODE_DEFAULT = 0,
        D2D1_PRINT_FONT_SUBSET_MODE_EACHPAGE = 1,
        D2D1_PRINT_FONT_SUBSET_MODE_NONE = 2,
        D2D1_PRINT_FONT_SUBSET_MODE_FORCE_DWORD = $ffffffff);


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

    TD2D1_PRINT_CONTROL_PROPERTIES = record
        fontSubset: TD2D1_PRINT_FONT_SUBSET_MODE;
        rasterDPI: single;
        colorSpace: TD2D1_COLOR_SPACE;
    end;
    PD2D1_PRINT_CONTROL_PROPERTIES = ^TD2D1_PRINT_CONTROL_PROPERTIES;


    TD2D1_CREATION_PROPERTIES = record
        threadingMode: TD2D1_THREADING_MODE;
        debugLevel: TD2D1_DEBUG_LEVEL;
        options: TD2D1_DEVICE_CONTEXT_OPTIONS;
    end;

    PD2D1_CREATION_PROPERTIES = ^TD2D1_CREATION_PROPERTIES;


    { D2D1EffectAuthor.h }

    PD2D1_PROPERTY_SET_FUNCTION = function(effect: IUnknown; Data: PBYTE; dataSize: UINT32): HResult; stdcall;

    PD2D1_PROPERTY_GET_FUNCTION = function(effect: IUnknown; out Data: PBYTE; dataSize: UINT32; out actualSize: UINT32): HResult; stdcall;


    TD2D1_PROPERTY_BINDING = record
        propertyName: PWideChar;
        setFunction: PD2D1_PROPERTY_SET_FUNCTION;
        getFunction: PD2D1_PROPERTY_GET_FUNCTION;
    end;
    PD2D1_PROPERTY_BINDING = ^TD2D1_PROPERTY_BINDING;


    TD2D1_RESOURCE_TEXTURE_PROPERTIES = record
        extents: PUINT32;
        dimensions: UINT32;
        bufferPrecision: TD2D1_BUFFER_PRECISION;
        channelDepth: TD2D1_CHANNEL_DEPTH;
        filter: TD2D1_FILTER;
        extendModes: PD2D1_EXTEND_MODE;
    end;

    PD2D1_RESOURCE_TEXTURE_PROPERTIES = ^TD2D1_RESOURCE_TEXTURE_PROPERTIES;


    TD2D1_INPUT_ELEMENT_DESC = record
        semanticName: PAnsiChar;
        semanticIndex: UINT32;
        format: TDXGI_FORMAT;
        inputSlot: UINT32;
        alignedByteOffset: UINT32;
    end;

    PD2D1_INPUT_ELEMENT_DESC = ^TD2D1_INPUT_ELEMENT_DESC;


    TD2D1_VERTEX_BUFFER_PROPERTIES = record
        inputCount: UINT32;
        usage: TD2D1_VERTEX_USAGE;
        Data: PByte;
        byteWidth: UINT32;
    end;

    PD2D1_VERTEX_BUFFER_PROPERTIES = ^TD2D1_VERTEX_BUFFER_PROPERTIES;


    TD2D1_CUSTOM_VERTEX_BUFFER_PROPERTIES = record
        shaderBufferWithInputSignature: PBYTE;
        shaderBufferSize: UINT32;
        inputElements: PD2D1_INPUT_ELEMENT_DESC;
        elementCount: UINT32;
        stride: UINT32;
    end;

    PD2D1_CUSTOM_VERTEX_BUFFER_PROPERTIES = ^TD2D1_CUSTOM_VERTEX_BUFFER_PROPERTIES;


    TD2D1_VERTEX_RANGE = record
        startVertex: UINT32;
        vertexCount: UINT32;
    end;

    PD2D1_VERTEX_RANGE = ^TD2D1_VERTEX_RANGE;


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


    TD2D1_INPUT_DESCRIPTION = record
        filter: TD2D1_FILTER;
        levelOfDetailCount: UINT32;
    end;

    PD2D1_INPUT_DESCRIPTION = ^TD2D1_INPUT_DESCRIPTION;


    TD2D1_FEATURE_DATA_DOUBLES = record
        doublePrecisionFloatShaderOps: longbool;
    end;


    TD2D1_FEATURE_DATA_D3D10_X_HARDWARE_OPTIONS = record
        computeShaders_Plus_RawAndStructuredBuffers_Via_Shader_4_x: longbool;
    end;


    { D2D1_2.h }


    TD2D1_RENDERING_PRIORITY = (
        D2D1_RENDERING_PRIORITY_NORMAL = 0,
        D2D1_RENDERING_PRIORITY_LOW = 1,
        D2D1_RENDERING_PRIORITY_FORCE_DWORD = $ffffffff);


    { D2D1.h }

    TD2D1_LAYER_PARAMETERS = record
        contentBounds: TD2D1_RECT_F;
        geometricMask: ID2D1Geometry;
        maskAntialiasMode: TD2D1_ANTIALIAS_MODE;
        maskTransform: TD2D1_MATRIX_3X2_F;
        opacity: single;
        opacityBrush: ID2D1Brush;
        layerOptions: TD2D1_LAYER_OPTIONS;
    end;

    PD2D1_LAYER_PARAMETERS = ^TD2D1_LAYER_PARAMETERS;

    TD2D1_WINDOW_STATE = (D2D1_WINDOW_STATE_NONE = $0000000, D2D1_WINDOW_STATE_OCCLUDED = $0000001, D2D1_WINDOW_STATE_FORCE_DWORD = $FFFFFFFF);

    TD2D1_RENDER_TARGET_TYPE = (D2D1_RENDER_TARGET_TYPE_DEFAULT = 0, D2D1_RENDER_TARGET_TYPE_SOFTWARE = 1, D2D1_RENDER_TARGET_TYPE_HARDWARE = 2,
        D2D1_RENDER_TARGET_TYPE_FORCE_DWORD = $FFFFFFFF);

    TD2D1_FEATURE_LEVEL = (D2D1_FEATURE_LEVEL_DEFAULT = 0, D2D1_FEATURE_LEVEL_9 = Ord(D3D_FEATURE_LEVEL_9_1),
        D2D1_FEATURE_LEVEL_10 = Ord(D3D_FEATURE_LEVEL_10_0), D2D1_FEATURE_LEVEL_FORCE_DWORD = $FFFFFFFF);

    TD2D1_RENDER_TARGET_USAGE = (D2D1_RENDER_TARGET_USAGE_NONE = $00000000, D2D1_RENDER_TARGET_USAGE_FORCE_BITMAP_REMOTING = $00000001,
        D2D1_RENDER_TARGET_USAGE_GDI_COMPATIBLE = $00000002, D2D1_RENDER_TARGET_USAGE_FORCE_DWORD = $FFFFFFFF);

    TD2D1_PRESENT_OPTIONS = (D2D1_PRESENT_OPTIONS_NONE = $00000000, D2D1_PRESENT_OPTIONS_RETAIN_CONTENTS = $00000001,
        D2D1_PRESENT_OPTIONS_IMMEDIATELY = $00000002, D2D1_PRESENT_OPTIONS_FORCE_DWORD = $FFFFFFFF);

    TD2D1_RENDER_TARGET_PROPERTIES = record
        _type: TD2D1_RENDER_TARGET_TYPE;
        pixelFormat: TD2D1_PIXEL_FORMAT;
        dpiX: single;
        dpiY: single;
        usage: TD2D1_RENDER_TARGET_USAGE;
        minLevel: TD2D1_FEATURE_LEVEL;
    end;

    PD2D1_RENDER_TARGET_PROPERTIES = ^TD2D1_RENDER_TARGET_PROPERTIES;

    TD2D1_HWND_RENDER_TARGET_PROPERTIES = record
        hwnd: hwnd;
        pixelSize: TD2D1_SIZE_U;
        presentOptions: TD2D1_PRESENT_OPTIONS;
    end;

    PD2D1_HWND_RENDER_TARGET_PROPERTIES = ^TD2D1_HWND_RENDER_TARGET_PROPERTIES;

    TD2D1_COMPATIBLE_RENDER_TARGET_OPTIONS = (D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS_NONE = $00000000,
        D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS_GDI_COMPATIBLE = $00000001, D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS_FORCE_DWORD = $FFFFFFFF);

    TD2D1_DRAWING_STATE_DESCRIPTION = record
        antialiasMode: TD2D1_ANTIALIAS_MODE;
        textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE;
        tag1: TD2D1_TAG;
        tag2: TD2D1_TAG;
        transform: TD2D1_MATRIX_3X2_F;
    end;

    PD2D1_DRAWING_STATE_DESCRIPTION = ^TD2D1_DRAWING_STATE_DESCRIPTION;


    TD2D1_FACTORY_OPTIONS = record
        debugLevel: TD2D1_DEBUG_LEVEL;
    end;

    PD2D1_FACTORY_OPTIONS = ^TD2D1_FACTORY_OPTIONS;


    { D2D1.h }

    ID2D1Resource = interface(IUnknown)
        ['{2cd90691-12e2-11dc-9fed-001143a055f9}']
        procedure GetFactory(out factory: ID2D1Factory); stdcall;
    end;

    ID2D1Image = interface(ID2D1Resource)
        ['{65019f75-8da2-497c-b32c-dfa34e48ede6}']
    end;

    ID2D1Bitmap = interface(ID2D1Image)
        ['{a2296057-ea42-4099-983b-539fb6505426}']
        function GetSize(): TD2D1_SIZE_F; stdcall;
        function GetPixelSize(): TD2D1_SIZE_U; stdcall;
        function GetPixelFormat(): TD2D1_PIXEL_FORMAT; stdcall;
        procedure GetDpi(out dpiX: single; out dpiY: single); stdcall;
//        function CopyFromBitmap( destPoint: PD2D1_POINT_2U; bitmap: ID2D1Bitmap;  srcRect: PD2D1_RECT_U): HResult; stdcall;  // <- funkt
        function CopyFromBitmap(const destPoint: PD2D1_POINT_2U; bitmap: ID2D1Bitmap; const srcRect: PD2D1_RECT_U): HResult; stdcall;// <- funkt
//        function CopyFromBitmap(const destPoint: TD2D1_POINT_2U; bitmap: ID2D1Bitmap; const srcRect: TD2D1_RECT_U): HResult; stdcall;// <- funkt
//        function CopyFromBitmap(destPoint: TD2D1_POINT_2U; bitmap: ID2D1Bitmap; srcRect: TD2D1_RECT_U): HResult; stdcall;  <- das crasht, weil ja kein Pointer übergeben wird
        function CopyFromRenderTarget(const destPoint: TD2D1_POINT_2U; renderTarget: ID2D1RenderTarget; const srcRect: TD2D1_RECT_U): HResult; stdcall;
        function CopyFromMemory(dstRect: PD2D1_RECT_U; srcData: Pointer; pitch: UINT32): HResult; stdcall;
    end;

    ID2D1GradientStopCollection = interface(ID2D1Resource)
        ['{2cd906a7-12e2-11dc-9fed-001143a055f9}']
        function GetGradientStopCount(): UINT32; stdcall;
        procedure GetGradientStops(out gradientStops: PD2D1_GRADIENT_STOP; gradientStopsCount: UINT32); stdcall;
        function GetColorInterpolationGamma(): TD2D1_GAMMA; stdcall;
        function GetExtendMode(): TD2D1_EXTEND_MODE; stdcall;
    end;

    ID2D1Brush = interface(ID2D1Resource)
        ['{2cd906a8-12e2-11dc-9fed-001143a055f9}']
        procedure SetOpacity(opacity: single); stdcall;
        procedure SetTransform(transform: PD2D1_MATRIX_3X2_F); stdcall;
        function GetOpacity(): single; stdcall;
        procedure GetTransform(out transform: TD2D1_MATRIX_3X2_F); stdcall;
    end;

    ID2D1BitmapBrush = interface(ID2D1Brush)
        ['{2cd906aa-12e2-11dc-9fed-001143a055f9}']
        procedure SetExtendModeX(extendModeX: TD2D1_EXTEND_MODE); stdcall;
        procedure SetExtendModeY(extendModeY: TD2D1_EXTEND_MODE); stdcall;
        procedure SetInterpolationMode(interpolationMode: TD2D1_BITMAP_INTERPOLATION_MODE); stdcall;
        procedure SetBitmap(bitmap: ID2D1Bitmap); stdcall;
        function GetExtendModeX(): TD2D1_EXTEND_MODE; stdcall;
        function GetExtendModeY(): TD2D1_EXTEND_MODE; stdcall;
        function GetInterpolationMode(): TD2D1_BITMAP_INTERPOLATION_MODE; stdcall;
        procedure GetBitmap(out bitmap: ID2D1Bitmap); stdcall;
    end;

    ID2D1SolidColorBrush = interface(ID2D1Brush)
        ['{2cd906a9-12e2-11dc-9fed-001143a055f9}']
        procedure SetColor(color: PD2D1_COLOR_F); stdcall;
        function GetColor(): TD2D1_COLOR_F; stdcall;
    end;

    ID2D1LinearGradientBrush = interface(ID2D1Brush)
        ['{2cd906ab-12e2-11dc-9fed-001143a055f9}']
        procedure SetStartPoint(startPoint: TD2D1_POINT_2F); stdcall;
        procedure SetEndPoint(endPoint: TD2D1_POINT_2F); stdcall;
        function GetStartPoint(): TD2D1_POINT_2F; stdcall;
        function GetEndPoint(): TD2D1_POINT_2F; stdcall;
        procedure GetGradientStopCollection(out gradientStopCollection: ID2D1GradientStopCollection); stdcall;
    end;

    ID2D1RadialGradientBrush = interface(ID2D1Brush)
        ['{2cd906ac-12e2-11dc-9fed-001143a055f9}']
        procedure SetCenter(center: TD2D1_POINT_2F); stdcall;
        procedure SetGradientOriginOffset(gradientOriginOffset: TD2D1_POINT_2F); stdcall;
        procedure SetRadiusX(radiusX: single); stdcall;
        procedure SetRadiusY(radiusY: single); stdcall;
        function GetCenter(): TD2D1_POINT_2F; stdcall;
        function GetGradientOriginOffset(): TD2D1_POINT_2F; stdcall;
        function GetRadiusX(): single; stdcall;
        function GetRadiusY(): single; stdcall;
        procedure GetGradientStopCollection(out gradientStopCollection: ID2D1GradientStopCollection); stdcall;
    end;

    ID2D1StrokeStyle = interface(ID2D1Resource)
        ['{2cd9069d-12e2-11dc-9fed-001143a055f9}']
        function GetStartCap(): TD2D1_CAP_STYLE; stdcall;
        function GetEndCap(): TD2D1_CAP_STYLE; stdcall;
        function GetDashCap(): TD2D1_CAP_STYLE; stdcall;
        function GetMiterLimit(): single; stdcall;
        function GetLineJoin(): TD2D1_LINE_JOIN; stdcall;
        function GetDashOffset(): single; stdcall;
        function GetDashStyle(): TD2D1_DASH_STYLE; stdcall;
        function GetDashesCount(): UINT32; stdcall;
        procedure GetDashes(out dashes: Psingle; dashesCount: UINT32); stdcall;
    end;

    ID2D1Geometry = interface(ID2D1Resource)
        ['{2cd906a1-12e2-11dc-9fed-001143a055f9}']
        function GetBounds(worldTransform: PD2D1_MATRIX_3X2_F; out bounds: TD2D1_RECT_F): HResult; stdcall;
        function GetWidenedBounds(strokeWidth: single; strokeStyle: ID2D1StrokeStyle; worldTransform: PD2D1_MATRIX_3X2_F;
            flatteningTolerance: single; out bounds: TD2D1_RECT_F): HResult; stdcall;
        function StrokeContainsPoint(point: TD2D1_POINT_2F; strokeWidth: single; strokeStyle: ID2D1StrokeStyle;
            worldTransform: PD2D1_MATRIX_3X2_F; flatteningTolerance: single; out contains: longbool): HResult; stdcall;
        function FillContainsPoint(point: TD2D1_POINT_2F; worldTransform: PD2D1_MATRIX_3X2_F; flatteningTolerance: single;
            out contains: longbool): HResult;
            stdcall;
        function CompareWithGeometry(inputGeometry: ID2D1Geometry; inputGeometryTransform: PD2D1_MATRIX_3X2_F;
            flatteningTolerance: single; out relation: TD2D1_GEOMETRY_RELATION): HResult; stdcall;
        function Simplify(simplificationOption: TD2D1_GEOMETRY_SIMPLIFICATION_OPTION; worldTransform: PD2D1_MATRIX_3X2_F;
            flatteningTolerance: single; geometrySink: ID2D1SimplifiedGeometrySink): HResult; stdcall;
        function Tessellate(worldTransform: PD2D1_MATRIX_3X2_F; flatteningTolerance: single;
            tessellationSink: ID2D1TessellationSink): HResult; stdcall;
        function CombineWithGeometry(inputGeometry: ID2D1Geometry; combineMode: TD2D1_COMBINE_MODE;
            inputGeometryTransform: PD2D1_MATRIX_3X2_F; flatteningTolerance: single; geometrySink: ID2D1SimplifiedGeometrySink): HResult; stdcall;
        function Outline(worldTransform: PD2D1_MATRIX_3X2_F; flatteningTolerance: single;
            geometrySink: ID2D1SimplifiedGeometrySink): HResult; stdcall;
        function ComputeArea(worldTransform: PD2D1_MATRIX_3X2_F; flatteningTolerance: single; out area: single): HResult; stdcall;
        function ComputeLength(worldTransform: PD2D1_MATRIX_3X2_F; flatteningTolerance: single; out length: single): HResult; stdcall;
        function ComputePointAtLength(length: single; worldTransform: PD2D1_MATRIX_3X2_F; flatteningTolerance: single;
            out point: TD2D1_POINT_2F; out unitTangentVector: TD2D1_POINT_2F): HResult; stdcall;
        function Widen(strokeWidth: single; strokeStyle: ID2D1StrokeStyle; worldTransform: PD2D1_MATRIX_3X2_F;
            flatteningTolerance: single; geometrySink: ID2D1SimplifiedGeometrySink): HResult; stdcall;
    end;

    ID2D1RectangleGeometry = interface(ID2D1Geometry)
        ['{2cd906a2-12e2-11dc-9fed-001143a055f9}']
        procedure GetRect(out rect: TD2D1_RECT_F); stdcall;
    end;

    ID2D1RoundedRectangleGeometry = interface(ID2D1Geometry)
        ['{2cd906a3-12e2-11dc-9fed-001143a055f9}']
        procedure GetRoundedRect(out roundedRect: TD2D1_ROUNDED_RECT); stdcall;
    end;

    ID2D1EllipseGeometry = interface(ID2D1Geometry)
        ['{2cd906a4-12e2-11dc-9fed-001143a055f9}']
        procedure GetEllipse(out ellipse: TD2D1_ELLIPSE); stdcall;
    end;

    ID2D1GeometryGroup = interface(ID2D1Geometry)
        ['{2cd906a6-12e2-11dc-9fed-001143a055f9}']
        function GetFillMode(): TD2D1_FILL_MODE; stdcall;
        function GetSourceGeometryCount(): UINT32; stdcall;
        procedure GetSourceGeometries(out geometries: PID2D1Geometry; geometriesCount: UINT32); stdcall;
    end;

    ID2D1TransformedGeometry = interface(ID2D1Geometry)
        ['{2cd906bb-12e2-11dc-9fed-001143a055f9}']
        procedure GetSourceGeometry(out sourceGeometry: ID2D1Geometry); stdcall;
        procedure GetTransform(out transform: TD2D1_MATRIX_3X2_F); stdcall;
    end;

    ID2D1SimplifiedGeometrySink = interface(IUnknown)
        ['{2cd9069e-12e2-11dc-9fed-001143a055f9}']
        procedure SetFillMode(fillMode: TD2D1_FILL_MODE); stdcall;
        procedure SetSegmentFlags(vertexFlags: TD2D1_PATH_SEGMENT); stdcall;
        procedure BeginFigure(startPoint: TD2D1_POINT_2F; figureBegin: TD2D1_FIGURE_BEGIN); stdcall;
        procedure AddLines(points: PD2D1_POINT_2F; pointsCount: UINT32); stdcall;
        procedure AddBeziers(beziers: PD2D1_BEZIER_SEGMENT; beziersCount: UINT32); stdcall;
        procedure EndFigure(figureEnd: TD2D1_FIGURE_END); stdcall;
        function Close(): HResult; stdcall;
    end;

    ID2D1GeometrySink = interface(ID2D1SimplifiedGeometrySink)
        ['{2cd9069f-12e2-11dc-9fed-001143a055f9}']
        procedure AddLine(point: TD2D1_POINT_2F); stdcall;
        procedure AddBezier(bezier: PD2D1_BEZIER_SEGMENT); stdcall;
        procedure AddQuadraticBezier(bezier: PD2D1_QUADRATIC_BEZIER_SEGMENT); stdcall;
        procedure AddQuadraticBeziers(beziers: PD2D1_QUADRATIC_BEZIER_SEGMENT; beziersCount: UINT32); stdcall;
        procedure AddArc(arc: PD2D1_ARC_SEGMENT); stdcall;

    end;

    ID2D1TessellationSink = interface(IUnknown)
        ['{2cd906c1-12e2-11dc-9fed-001143a055f9}']
        procedure AddTriangles(triangles: PD2D1_TRIANGLE; trianglesCount: UINT32); stdcall;
        function Close(): HResult; stdcall;
    end;

    ID2D1PathGeometry = interface(ID2D1Geometry)
        ['{2cd906a5-12e2-11dc-9fed-001143a055f9}']
        function Open(out geometrySink: ID2D1GeometrySink): HResult; stdcall;
        function Stream(geometrySink: ID2D1GeometrySink): HResult; stdcall;
        function GetSegmentCount(out Count: UINT32): HResult; stdcall;
        function GetFigureCount(out Count: UINT32): HResult; stdcall;
    end;

    ID2D1Mesh = interface(ID2D1Resource)
        ['{2cd906c2-12e2-11dc-9fed-001143a055f9}']
        function Open(out tessellationSink: ID2D1TessellationSink): HResult; stdcall;
    end;

    ID2D1Layer = interface(ID2D1Resource)
        ['{2cd9069b-12e2-11dc-9fed-001143a055f9}']
        function GetSize(): TD2D1_SIZE_F; stdcall;
    end;

    ID2D1DrawingStateBlock = interface(ID2D1Resource)
        ['{28506e39-ebf6-46a1-bb47-fd85565ab957}']
        procedure GetDescription(out stateDescription: TD2D1_DRAWING_STATE_DESCRIPTION); stdcall;
        procedure SetDescription(stateDescription: PD2D1_DRAWING_STATE_DESCRIPTION); stdcall;
        procedure SetTextRenderingParams(textRenderingParams: IDWriteRenderingParams = nil); stdcall;
        procedure GetTextRenderingParams(out textRenderingParams: IDWriteRenderingParams); stdcall;
    end;

    ID2D1BitmapRenderTarget = interface;

    ID2D1RenderTarget = interface(ID2D1Resource)
        ['{2cd90694-12e2-11dc-9fed-001143a055f9}']
        function CreateBitmap(size: TD2D1_SIZE_U; srcData: Pointer; pitch: UINT32; bitmapProperties: PD2D1_BITMAP_PROPERTIES;
            out bitmap: ID2D1Bitmap): HResult; stdcall;
        function CreateBitmapFromWicBitmap(wicBitmapSource: IWICBitmapSource; bitmapProperties: PD2D1_BITMAP_PROPERTIES;
            out bitmap: ID2D1Bitmap): HResult;
            stdcall;
        function CreateSharedBitmap(const riid: TGUID; Data : Pointer; const bitmapProperties: TD2D1_BITMAP_PROPERTIES;
            out bitmap: ID2D1Bitmap): HResult; stdcall;
        function CreateBitmapBrush(bitmap: ID2D1Bitmap; bitmapBrushProperties: PD2D1_BITMAP_BRUSH_PROPERTIES;
            brushProperties: PD2D1_BRUSH_PROPERTIES; out bitmapBrush: ID2D1BitmapBrush): HResult; stdcall;
        function CreateSolidColorBrush(const color: TD2D1_COLOR_F; brushProperties: PD2D1_BRUSH_PROPERTIES;
            out solidColorBrush: ID2D1SolidColorBrush): HResult;
            stdcall;
        function CreateGradientStopCollection(gradientStops: PD2D1_GRADIENT_STOP; gradientStopsCount: UINT32;
            colorInterpolationGamma: TD2D1_GAMMA; extendMode: TD2D1_EXTEND_MODE;
            out gradientStopCollection: ID2D1GradientStopCollection): HResult; stdcall;
        function CreateLinearGradientBrush(linearGradientBrushProperties: PD2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES;
            brushProperties: PD2D1_BRUSH_PROPERTIES; gradientStopCollection: ID2D1GradientStopCollection;
            out linearGradientBrush: ID2D1LinearGradientBrush): HResult; stdcall;
        function CreateRadialGradientBrush(radialGradientBrushProperties: PD2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES;
            brushProperties: PD2D1_BRUSH_PROPERTIES; gradientStopCollection: ID2D1GradientStopCollection;
            out radialGradientBrush: ID2D1RadialGradientBrush): HResult; stdcall;
        function CreateCompatibleRenderTarget(const desiredSize: TD2D1_SIZE_F; desiredPixelSize: PD2D1_SIZE_U;
            desiredFormat: PD2D1_PIXEL_FORMAT; options: TD2D1_COMPATIBLE_RENDER_TARGET_OPTIONS;
            out bitmapRenderTarget: ID2D1BitmapRenderTarget): HResult; stdcall;
        function CreateLayer(size: PD2D1_SIZE_F; out layer: ID2D1Layer): HResult; stdcall;
        function CreateMesh(out mesh: ID2D1Mesh): HResult; stdcall;
        procedure DrawLine(point0: TD2D1_POINT_2F; point1: TD2D1_POINT_2F; brush: ID2D1Brush; strokeWidth: single = 1.0;
            strokeStyle: ID2D1StrokeStyle = nil);
            stdcall;
        procedure DrawRectangle(const rect: TD2D1_RECT_F; brush: ID2D1Brush; strokeWidth: single = 1.0; strokeStyle: ID2D1StrokeStyle = nil); stdcall;
        procedure FillRectangle(const rect: TD2D1_RECT_F; brush: ID2D1Brush); stdcall;
        procedure DrawRoundedRectangle(const roundedRect: TD2D1_ROUNDED_RECT; brush: ID2D1Brush; strokeWidth: single = 1.0;
            strokeStyle: ID2D1StrokeStyle = nil);
            stdcall;
        procedure FillRoundedRectangle(const roundedRect: TD2D1_ROUNDED_RECT; brush: ID2D1Brush); stdcall;
        procedure DrawEllipse(ellipse: PD2D1_ELLIPSE; brush: ID2D1Brush; strokeWidth: single = 1.0; strokeStyle: ID2D1StrokeStyle = nil); stdcall;
        procedure FillEllipse(ellipse: PD2D1_ELLIPSE; brush: ID2D1Brush); stdcall;
        procedure DrawGeometry(geometry: ID2D1Geometry; brush: ID2D1Brush; strokeWidth: single = 1.0; strokeStyle: ID2D1StrokeStyle = nil); stdcall;
        procedure FillGeometry(geometry: ID2D1Geometry; brush: ID2D1Brush; opacityBrush: ID2D1Brush = nil); stdcall;
        procedure FillMesh(mesh: ID2D1Mesh; brush: ID2D1Brush); stdcall;
        procedure FillOpacityMask(opacityMask: ID2D1Bitmap; brush: ID2D1Brush; content: TD2D1_OPACITY_MASK_CONTENT;
            destinationRectangle: PD2D1_RECT_F = nil; sourceRectangle: PD2D1_RECT_F = nil); stdcall;
        procedure DrawBitmap(bitmap: ID2D1Bitmap; destinationRectangle: PD2D1_RECT_F = nil; opacity: single = 1.0;
            interpolationMode: TD2D1_BITMAP_INTERPOLATION_MODE = D2D1_BITMAP_INTERPOLATION_MODE_LINEAR;
            sourceRectangle: PD2D1_RECT_F = nil); stdcall;
        procedure DrawText(Text: PWideChar; stringLength: UINT32; textFormat: IDWriteTextFormat; layoutRect: PD2D1_RECT_F;
            defaultForegroundBrush: ID2D1Brush; options: TD2D1_DRAW_TEXT_OPTIONS = D2D1_DRAW_TEXT_OPTIONS_NONE;
            measuringMode: TDWRITE_MEASURING_MODE = DWRITE_MEASURING_MODE_NATURAL); stdcall;
        procedure DrawTextLayout(origin: TD2D1_POINT_2F; textLayout: IDWriteTextLayout; defaultForegroundBrush: ID2D1Brush;
            options: TD2D1_DRAW_TEXT_OPTIONS = D2D1_DRAW_TEXT_OPTIONS_NONE); stdcall;
        procedure DrawGlyphRun(baselineOrigin: TD2D1_POINT_2F; glyphRun: PDWRITE_GLYPH_RUN; foregroundBrush: ID2D1Brush;
            measuringMode: TDWRITE_MEASURING_MODE = DWRITE_MEASURING_MODE_NATURAL); stdcall;
        procedure SetTransform(const transform: TD2D1_MATRIX_3X2_F); stdcall;
        procedure GetTransform(out transform: TD2D1_MATRIX_3X2_F); stdcall;
        procedure SetAntialiasMode(antialiasMode: TD2D1_ANTIALIAS_MODE); stdcall;
        function GetAntialiasMode(): TD2D1_ANTIALIAS_MODE; stdcall;
        procedure SetTextAntialiasMode(textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE); stdcall;
        function GetTextAntialiasMode(): TD2D1_TEXT_ANTIALIAS_MODE; stdcall;
        procedure SetTextRenderingParams(textRenderingParams: IDWriteRenderingParams = nil); stdcall;
        procedure GetTextRenderingParams(out textRenderingParams: IDWriteRenderingParams); stdcall;
        procedure SetTags(tag1: TD2D1_TAG; tag2: TD2D1_TAG); stdcall;
        procedure GetTags(out tag1: TD2D1_TAG; out tag2: TD2D1_TAG); stdcall;
        procedure PushLayer(layerParameters: PD2D1_LAYER_PARAMETERS; layer: ID2D1Layer); stdcall;
        procedure PopLayer(); stdcall;
        function Flush(out tag1: TD2D1_TAG; out tag2: TD2D1_TAG): HResult; stdcall;
        procedure SaveDrawingState(var drawingStateBlock: ID2D1DrawingStateBlock); stdcall;
        procedure RestoreDrawingState(drawingStateBlock: ID2D1DrawingStateBlock); stdcall;
        procedure PushAxisAlignedClip(const clipRect: TD2D1_RECT_F; antialiasMode: TD2D1_ANTIALIAS_MODE); stdcall;
        procedure PopAxisAlignedClip(); stdcall;
        procedure Clear(const ClearColor: TD2D1_COLOR_F); stdcall;
        procedure BeginDraw(); stdcall;
        function EndDraw(tag1: PD2D1_TAG = nil; Tag2: PD2D1_TAG = nil): HResult; stdcall;
        function GetPixelFormat(): TD2D1_PIXEL_FORMAT; stdcall;
        procedure SetDpi(dpiX: single; dpiY: single); stdcall;
        procedure GetDpi(out dpiX: single; out dpiY: single); stdcall;
        function GetSize(): TD2D1_SIZE_F; stdcall;
        function GetPixelSize(): TD2D1_SIZE_U; stdcall;

        function GetMaximumBitmapSize(): UINT32; stdcall;
        function IsSupported(renderTargetProperties: PD2D1_RENDER_TARGET_PROPERTIES): longbool; stdcall;
    end;

    ID2D1BitmapRenderTarget = interface(ID2D1RenderTarget)
        ['{2cd90695-12e2-11dc-9fed-001143a055f9}']
        function GetBitmap(out bitmap: ID2D1Bitmap): HResult; stdcall;
    end;

    ID2D1HwndRenderTarget = interface(ID2D1RenderTarget)
        ['{2cd90698-12e2-11dc-9fed-001143a055f9}']
        function CheckWindowState(): TD2D1_WINDOW_STATE; stdcall;
        function Resize(pixelSize: PD2D1_SIZE_U): HResult; stdcall;
        function GetHwnd(): hwnd; stdcall;
    end;

    ID2D1GdiInteropRenderTarget = interface(IUnknown)
        ['{e0db51c3-6f77-4bae-b3d5-e47509b35838}']
        function GetDC(mode: TD2D1_DC_INITIALIZE_MODE; out hdc: hdc): HResult; stdcall;
        function ReleaseDC(update: PRECT): HResult; stdcall;
    end;

    ID2D1DCRenderTarget = interface(ID2D1RenderTarget)
        ['{1c51bc64-de61-46fd-9899-63a5d8f03950}']
        function BindDC(hdc: hdc; pSubRect: PRECT): HResult; stdcall;
    end;

    ID2D1Factory = interface(IUnknown)
        ['{06152247-6f50-465a-9245-118bfd3b6007}']
        function ReloadSystemMetrics(): HResult; stdcall;
        procedure GetDesktopDpi(out dpiX: single; out dpiY: single); stdcall;
        function CreateRectangleGeometry(const rectangle: PD2D1_RECT_F; out rectangleGeometry: ID2D1RectangleGeometry): HResult; stdcall;
        function CreateRoundedRectangleGeometry(roundedRectangle: PD2D1_ROUNDED_RECT;
            out roundedRectangleGeometry: ID2D1RoundedRectangleGeometry): HResult;
            stdcall;
        function CreateEllipseGeometry(ellipse: PD2D1_ELLIPSE; out ellipseGeometry: ID2D1EllipseGeometry): HResult; stdcall;
        function CreateGeometryGroup(fillMode: TD2D1_FILL_MODE; geometries: PID2D1Geometry; geometriesCount: UINT32;
            out geometryGroup: ID2D1GeometryGroup): HResult; stdcall;
        function CreateTransformedGeometry(sourceGeometry: ID2D1Geometry; transform: PD2D1_MATRIX_3X2_F;
            out transformedGeometry: ID2D1TransformedGeometry): HResult; stdcall;
        function CreatePathGeometry(out pathGeometry: ID2D1PathGeometry): HResult; stdcall;
        function CreateStrokeStyle(strokeStyleProperties: PD2D1_STROKE_STYLE_PROPERTIES; dashes: Psingle;
            dashesCount: UINT32; out strokeStyle: ID2D1StrokeStyle): HResult; stdcall;
        function CreateDrawingStateBlock(drawingStateDescription: PD2D1_DRAWING_STATE_DESCRIPTION;
            textRenderingParams: IDWriteRenderingParams; out drawingStateBlock: ID2D1DrawingStateBlock): HResult; stdcall;
        function CreateWicBitmapRenderTarget(target: IWICBitmap; renderTargetProperties: PD2D1_RENDER_TARGET_PROPERTIES;
            out renderTarget: ID2D1RenderTarget): HResult; stdcall;
        function CreateHwndRenderTarget(const renderTargetProperties: TD2D1_RENDER_TARGET_PROPERTIES;
            const hwndRenderTargetProperties: TD2D1_HWND_RENDER_TARGET_PROPERTIES; out hwndRenderTarget: ID2D1HwndRenderTarget): HResult; stdcall;
        function CreateDxgiSurfaceRenderTarget(dxgiSurface: IDXGISurface; renderTargetProperties: PD2D1_RENDER_TARGET_PROPERTIES;
            out renderTarget: ID2D1RenderTarget): HResult; stdcall;
        function CreateDCRenderTarget(renderTargetProperties: PD2D1_RENDER_TARGET_PROPERTIES;
            out dcRenderTarget: ID2D1DCRenderTarget): HResult; stdcall;
    end;


    { D2D1_1.h }
    ID2D1Device = interface;

    ID2D1GdiMetafileSink = interface(IUnknown)
        ['{82237326-8111-4f7c-bcf4-b5c1175564fe}']
        function ProcessRecord(recordType: DWORD; recordData: Pointer; recordDataSize: DWORD): HResult; stdcall;
    end;


    ID2D1GdiMetafile = interface(ID2D1Resource)
        ['{2f543dc3-cfc1-4211-864f-cfd91c6f3395}']
        function Stream(sink: ID2D1GdiMetafileSink): HResult; stdcall;
        function GetBounds(out bounds: TD2D1_RECT_F): HResult; stdcall;
    end;


    ID2D1CommandSink = interface(IUnknown)
        ['{54d7898a-a061-40a7-bec7-e465bcba2c4f}']
        function BeginDraw(): HResult; stdcall;
        function EndDraw(): HResult; stdcall;
        function SetAntialiasMode(antialiasMode: TD2D1_ANTIALIAS_MODE): HResult; stdcall;
        function SetTags(tag1: TD2D1_TAG; tag2: TD2D1_TAG): HResult; stdcall;
        function SetTextAntialiasMode(textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE): HResult; stdcall;
        function SetTextRenderingParams(textRenderingParams: IDWriteRenderingParams): HResult; stdcall;
        function SetTransform(transform: PD2D1_MATRIX_3X2_F): HResult; stdcall;
        function SetPrimitiveBlend(primitiveBlend: TD2D1_PRIMITIVE_BLEND): HResult; stdcall;
        function SetUnitMode(unitMode: TD2D1_UNIT_MODE): HResult; stdcall;
        function Clear(color: PD2D1_COLOR_F): HResult; stdcall;
        function DrawGlyphRun(baselineOrigin: TD2D1_POINT_2F; glyphRun: PDWRITE_GLYPH_RUN;
            glyphRunDescription: PDWRITE_GLYPH_RUN_DESCRIPTION; foregroundBrush: ID2D1Brush;
            measuringMode: TDWRITE_MEASURING_MODE): HResult; stdcall;
        function DrawLine(point0: TD2D1_POINT_2F; point1: TD2D1_POINT_2F; brush: ID2D1Brush; strokeWidth: single;
            strokeStyle: ID2D1StrokeStyle): HResult; stdcall;
        function DrawGeometry(geometry: ID2D1Geometry; brush: ID2D1Brush; strokeWidth: single;
            strokeStyle: ID2D1StrokeStyle): HResult; stdcall;
        function DrawRectangle(rect: PD2D1_RECT_F; brush: ID2D1Brush; strokeWidth: single;
            strokeStyle: ID2D1StrokeStyle): HResult; stdcall;
        function DrawBitmap(bitmap: ID2D1Bitmap; destinationRectangle: PD2D1_RECT_F; opacity: single;
            interpolationMode: TD2D1_INTERPOLATION_MODE; sourceRectangle: PD2D1_RECT_F;
            perspectiveTransform: PD2D1_MATRIX_4X4_F): HResult; stdcall;
        function DrawImage(image: ID2D1Image; targetOffset: PD2D1_POINT_2F; imageRectangle: PD2D1_RECT_F;
            interpolationMode: TD2D1_INTERPOLATION_MODE; compositeMode: TD2D1_COMPOSITE_MODE): HResult; stdcall;
        function DrawGdiMetafile(gdiMetafile: ID2D1GdiMetafile; targetOffset: PD2D1_POINT_2F): HResult; stdcall;
        function FillMesh(mesh: ID2D1Mesh; brush: ID2D1Brush): HResult; stdcall;
        function FillOpacityMask(opacityMask: ID2D1Bitmap; brush: ID2D1Brush; destinationRectangle: PD2D1_RECT_F;
            sourceRectangle: PD2D1_RECT_F): HResult; stdcall;
        function FillGeometry(geometry: ID2D1Geometry; brush: ID2D1Brush; opacityBrush: ID2D1Brush): HResult; stdcall;
        function FillRectangle(rect: PD2D1_RECT_F; brush: ID2D1Brush): HResult; stdcall;
        function PushAxisAlignedClip(clipRect: PD2D1_RECT_F; antialiasMode: TD2D1_ANTIALIAS_MODE): HResult; stdcall;
        function PushLayer(layerParameters1: PD2D1_LAYER_PARAMETERS1; layer: ID2D1Layer): HResult; stdcall;
        function PopAxisAlignedClip(): HResult; stdcall;
        function PopLayer(): HResult; stdcall;
    end;


    ID2D1CommandList = interface(ID2D1Image)
        ['{b4f34a19-2383-4d76-94f6-ec343657c3dc}']
        function Stream(sink: ID2D1CommandSink): HResult; stdcall;
        function Close(): HResult; stdcall;
    end;


    ID2D1PrintControl = interface(IUnknown)
        ['{2c1d867d-c290-41c8-ae7e-34a98702e9a5}']
        function AddPage(commandList: ID2D1CommandList; pageSize: TD2D_SIZE_F; pagePrintTicketStream: IStream;
            out tag1: TD2D1_TAG; out tag2: TD2D1_TAG): HResult; stdcall;
        function Close(): HResult; stdcall;
    end;


    ID2D1ImageBrush = interface(ID2D1Brush)
        ['{fe9e984d-3f95-407c-b5db-cb94d4e8f87c}']
        procedure SetImage(image: ID2D1Image); stdcall;
        procedure SetExtendModeX(extendModeX: TD2D1_EXTEND_MODE); stdcall;
        procedure SetExtendModeY(extendModeY: TD2D1_EXTEND_MODE); stdcall;
        procedure SetInterpolationMode(interpolationMode: TD2D1_INTERPOLATION_MODE); stdcall;
        procedure SetSourceRectangle(sourceRectangle: TD2D1_RECT_F); stdcall;
        procedure GetImage(out image: ID2D1Image); stdcall;
        function GetExtendModeX(): TD2D1_EXTEND_MODE; stdcall;
        function GetExtendModeY(): TD2D1_EXTEND_MODE; stdcall;
        function GetInterpolationMode(): TD2D1_INTERPOLATION_MODE; stdcall;
        procedure GetSourceRectangle(out sourceRectangle: TD2D1_RECT_F); stdcall;
    end;


    ID2D1BitmapBrush1 = interface(ID2D1BitmapBrush)
        ['{41343a53-e41a-49a2-91cd-21793bbb62e5}']
        procedure SetInterpolationMode1(interpolationMode: TD2D1_INTERPOLATION_MODE); stdcall;
        function GetInterpolationMode1(): TD2D1_INTERPOLATION_MODE; stdcall;
    end;


    ID2D1StrokeStyle1 = interface(ID2D1StrokeStyle)
        ['{10a72a66-e91c-43f4-993f-ddf4b82b0b4a}']
        function GetStrokeTransformType(): TD2D1_STROKE_TRANSFORM_TYPE; stdcall;
    end;


    ID2D1PathGeometry1 = interface(ID2D1PathGeometry)
        ['{62baa2d2-ab54-41b7-b872-787e0106a421}']
        function ComputePointAndSegmentAtLength(length: single; startSegment: UINT32; worldTransform: PD2D1_MATRIX_3X2_F;
            flatteningTolerance: single; out pointDescription: TD2D1_POINT_DESCRIPTION): HResult; stdcall;
    end;


    ID2D1Properties = interface(IUnknown)
        ['{483473d7-cd46-4f9d-9d3a-3112aa80159d}']
        function GetPropertyCount(): UINT32; stdcall;
        function GetPropertyName(index: UINT32; out Name: PWideChar; nameCount: UINT32): HResult; stdcall;
        function GetPropertyNameLength(index: UINT32): UINT32; stdcall;
        function GetType(index: UINT32): TD2D1_PROPERTY_TYPE; stdcall;
        function GetPropertyIndex(Name: PWideChar): UINT32; stdcall;
        function SetValueByName(Name: PWideChar; _type: TD2D1_PROPERTY_TYPE; Data: PBYTE; dataSize: UINT32): HResult; stdcall;
        function SetValue(index: UINT32; _type: TD2D1_PROPERTY_TYPE; Data: PBYTE; dataSize: UINT32): HResult; stdcall;
        function GetValueByName(Name: PWideChar; _type: TD2D1_PROPERTY_TYPE; out Data: PBYTE; dataSize: UINT32): HResult; stdcall;
        function GetValue(index: UINT32; _type: TD2D1_PROPERTY_TYPE; out Data: PBYTE; dataSize: UINT32): HResult; stdcall;
        function GetValueSize(index: UINT32): UINT32; stdcall;
        function GetSubProperties(index: UINT32; out subProperties: ID2D1Properties): HResult; stdcall;
    end;

    { ID2D1Effect }

    ID2D1Effect = interface(ID2D1Properties)
        ['{28211a43-7d89-476f-8181-2d6159b220ad}']
        procedure SetInput(index: UINT32; input: ID2D1Image; invalidate: longbool = True); stdcall;
        function SetInputCount(inputCount: UINT32): HResult; stdcall;
        procedure GetInput(index: UINT32; out input: ID2D1Image); stdcall;
        function GetInputCount(): UINT32; stdcall;
        procedure GetOutput(out outputImage: ID2D1Image); stdcall;
    end;


    ID2D1Bitmap1 = interface(ID2D1Bitmap)
        ['{a898a84c-3873-4588-b08b-ebbf978df041}']
        procedure GetColorContext(out colorContext: ID2D1ColorContext); stdcall;
        function GetOptions(): TD2D1_BITMAP_OPTIONS; stdcall;
        function GetSurface(out dxgiSurface: IDXGISurface): HResult; stdcall;
        function Map(options: TD2D1_MAP_OPTIONS; out mappedRect: TD2D1_MAPPED_RECT): HResult; stdcall;
        function Unmap(): HResult; stdcall;
    end;


    ID2D1ColorContext = interface(ID2D1Resource)
        ['{1c4820bb-5771-4518-a581-2fe4dd0ec657}']
        function GetColorSpace(): TD2D1_COLOR_SPACE; stdcall;
        function GetProfileSize(): UINT32; stdcall;
        function GetProfile(out profile: PBYTE; profileSize: UINT32): HResult; stdcall;
    end;


    ID2D1GradientStopCollection1 = interface(ID2D1GradientStopCollection)
        ['{ae1572f4-5dd0-4777-998b-9279472ae63b}']
        procedure GetGradientStops1(out gradientStops: PD2D1_GRADIENT_STOP; gradientStopsCount: UINT32); stdcall;
        function GetPreInterpolationSpace(): TD2D1_COLOR_SPACE; stdcall;
        function GetPostInterpolationSpace(): TD2D1_COLOR_SPACE; stdcall;
        function GetBufferPrecision(): TD2D1_BUFFER_PRECISION; stdcall;
        function GetColorInterpolationMode(): TD2D1_COLOR_INTERPOLATION_MODE; stdcall;
    end;


    ID2D1DrawingStateBlock1 = interface(ID2D1DrawingStateBlock)
        ['{689f1f85-c72e-4e33-8f19-85754efd5ace}']
        procedure GetDescription(out stateDescription: TD2D1_DRAWING_STATE_DESCRIPTION1); stdcall;
        procedure SetDescription(stateDescription: PD2D1_DRAWING_STATE_DESCRIPTION1); stdcall;
    end;


    ID2D1DeviceContext = interface(ID2D1RenderTarget)
        ['{e8f7fe7a-191c-466d-ad95-975678bda998}']
        function CreateBitmap(size: TD2D1_SIZE_U; sourceData: Pointer; pitch: UINT32; bitmapProperties: PD2D1_BITMAP_PROPERTIES1;
            out bitmap: ID2D1Bitmap1): HResult; stdcall;
        function CreateBitmapFromWicBitmap(wicBitmapSource: IWICBitmapSource; bitmapProperties: PD2D1_BITMAP_PROPERTIES1;
            out bitmap: ID2D1Bitmap1): HResult; stdcall;
        function CreateColorContext(space: TD2D1_COLOR_SPACE; profile: PBYTE; profileSize: UINT32;
            out colorContext: ID2D1ColorContext): HResult; stdcall;
        function CreateColorContextFromFilename(filename: PWideChar; out colorContext: ID2D1ColorContext): HResult; stdcall;
        function CreateColorContextFromWicColorContext(wicColorContext: IWICColorContext;
            out colorContext: ID2D1ColorContext): HResult; stdcall;
        function CreateBitmapFromDxgiSurface(surface: IDXGISurface; const bitmapProperties: TD2D1_BITMAP_PROPERTIES1;
            out bitmap: ID2D1Bitmap1): HResult; stdcall;
        function CreateEffect(effectId: TGUID; out effect: ID2D1Effect): HResult; stdcall;
        function CreateGradientStopCollection(straightAlphaGradientStops: PD2D1_GRADIENT_STOP;
            straightAlphaGradientStopsCount: UINT32; preInterpolationSpace: TD2D1_COLOR_SPACE;
            postInterpolationSpace: TD2D1_COLOR_SPACE; bufferPrecision: TD2D1_BUFFER_PRECISION; extendMode: TD2D1_EXTEND_MODE;
            colorInterpolationMode: TD2D1_COLOR_INTERPOLATION_MODE; out gradientStopCollection1: ID2D1GradientStopCollection1): HResult; stdcall;
        function CreateImageBrush(image: ID2D1Image; imageBrushProperties: PD2D1_IMAGE_BRUSH_PROPERTIES;
            brushProperties: PD2D1_BRUSH_PROPERTIES; out imageBrush: ID2D1ImageBrush): HResult; stdcall;
        function CreateBitmapBrush(bitmap: ID2D1Bitmap; bitmapBrushProperties: PD2D1_BITMAP_BRUSH_PROPERTIES1;
            brushProperties: PD2D1_BRUSH_PROPERTIES; out bitmapBrush: ID2D1BitmapBrush1): HResult; stdcall;
        function CreateCommandList(out commandList: ID2D1CommandList): HResult; stdcall;
        function IsDxgiFormatSupported(format: TDXGI_FORMAT): longbool; stdcall;
        function IsBufferPrecisionSupported(bufferPrecision: TD2D1_BUFFER_PRECISION): longbool; stdcall;
        function GetImageLocalBounds(image: ID2D1Image; out localBounds: TD2D1_RECT_F): HResult; stdcall;
        function GetImageWorldBounds(image: ID2D1Image; out worldBounds: TD2D1_RECT_F): HResult; stdcall;
        function GetGlyphRunWorldBounds(baselineOrigin: TD2D1_POINT_2F; glyphRun: PDWRITE_GLYPH_RUN;
            measuringMode: TDWRITE_MEASURING_MODE; out bounds: TD2D1_RECT_F): HResult; stdcall;
        procedure GetDevice(out device: ID2D1Device); stdcall;
        procedure SetTarget(image: ID2D1Image); stdcall;
        procedure GetTarget(out image: ID2D1Image); stdcall;
        procedure SetRenderingControls(renderingControls: PD2D1_RENDERING_CONTROLS); stdcall;
        procedure GetRenderingControls(out renderingControls: TD2D1_RENDERING_CONTROLS); stdcall;
        procedure SetPrimitiveBlend(primitiveBlend: TD2D1_PRIMITIVE_BLEND); stdcall;
        function GetPrimitiveBlend(): TD2D1_PRIMITIVE_BLEND; stdcall;
        procedure SetUnitMode(unitMode: TD2D1_UNIT_MODE); stdcall;
        function GetUnitMode(): TD2D1_UNIT_MODE; stdcall;
        procedure DrawGlyphRun(baselineOrigin: TD2D1_POINT_2F; glyphRun: PDWRITE_GLYPH_RUN;
            glyphRunDescription: PDWRITE_GLYPH_RUN_DESCRIPTION; foregroundBrush: ID2D1Brush;
            measuringMode: TDWRITE_MEASURING_MODE = DWRITE_MEASURING_MODE_NATURAL); stdcall;
        procedure DrawImage(image: ID2D1Image; targetOffset: PD2D1_POINT_2F = nil; imageRectangle: PD2D1_RECT_F = nil;
            interpolationMode: TD2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR;
            compositeMode: TD2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER); stdcall;
        procedure DrawGdiMetafile(gdiMetafile: ID2D1GdiMetafile; targetOffset: PD2D1_POINT_2F = nil); stdcall;
        procedure DrawBitmap(bitmap: ID2D1Bitmap; destinationRectangle: PD2D1_RECT_F; opacity: single;
            interpolationMode: TD2D1_INTERPOLATION_MODE; sourceRectangle: PD2D1_RECT_F = nil;
            perspectiveTransform: PD2D1_MATRIX_4X4_F = nil); stdcall;
        procedure PushLayer(layerParameters: PD2D1_LAYER_PARAMETERS1; layer: ID2D1Layer); stdcall;
        function InvalidateEffectInputRectangle(effect: ID2D1Effect; input: UINT32; inputRectangle: PD2D1_RECT_F): HResult; stdcall;
        function GetEffectInvalidRectangleCount(effect: ID2D1Effect; out rectangleCount: UINT32): HResult; stdcall;
        function GetEffectInvalidRectangles(effect: ID2D1Effect; out rectangles: PD2D1_RECT_F; rectanglesCount: UINT32): HResult; stdcall;
        function GetEffectRequiredInputRectangles(renderEffect: ID2D1Effect; renderImageRectangle: PD2D1_RECT_F;
            inputDescriptions: PD2D1_EFFECT_INPUT_DESCRIPTION; out requiredInputRects: PD2D1_RECT_F;
            inputCount: UINT32): HResult; stdcall;
        procedure FillOpacityMask(opacityMask: ID2D1Bitmap; brush: ID2D1Brush; destinationRectangle: PD2D1_RECT_F = nil;
            sourceRectangle: PD2D1_RECT_F = nil); stdcall;
    end;


    ID2D1Device = interface(ID2D1Resource)
        ['{47dd575d-ac05-4cdd-8049-9b02cd16f44c}']
        function CreateDeviceContext(options: TD2D1_DEVICE_CONTEXT_OPTIONS; out deviceContext: ID2D1DeviceContext): HResult; stdcall;
        function CreatePrintControl(wicFactory: IWICImagingFactory; documentTarget: IPrintDocumentPackageTarget;
            printControlProperties: PD2D1_PRINT_CONTROL_PROPERTIES; out printControl: ID2D1PrintControl): HResult; stdcall;
        procedure SetMaximumTextureMemory(maximumInBytes: UINT64); stdcall;
        function GetMaximumTextureMemory(): UINT64; stdcall;
        procedure ClearResources(millisecondsSinceUse: UINT32 = 0); stdcall;
    end;

    //+-----------------------------------------------------------------------------

    //  Function Pointer:
    //      PD2D1_EFFECT_FACTORY

    //  Synopsis:
    //      Function pointer to construct a new effect once registered.

    //------------------------------------------------------------------------------
    PD2D1_EFFECT_FACTORY = function(out effectImpl: IUnknown): HResult; stdcall; // callback


    ID2D1Factory1 = interface(ID2D1Factory)
        ['{bb12d362-daee-4b9a-aa1d-14ba401cfa1f}']
        function CreateDevice(dxgiDevice: IDXGIDevice; out d2dDevice: ID2D1Device): HResult; stdcall;
        function CreateStrokeStyle(strokeStyleProperties: PD2D1_STROKE_STYLE_PROPERTIES1; dashes: Psingle;
            dashesCount: UINT32; out strokeStyle: ID2D1StrokeStyle1): HResult; stdcall;
        function CreatePathGeometry(out pathGeometry: ID2D1PathGeometry1): HResult; stdcall;
        function CreateDrawingStateBlock(drawingStateDescription: PD2D1_DRAWING_STATE_DESCRIPTION1;
            textRenderingParams: IDWriteRenderingParams; out drawingStateBlock: ID2D1DrawingStateBlock1): HResult; stdcall;
        function CreateGdiMetafile(metafileStream: IStream; out metafile: ID2D1GdiMetafile): HResult; stdcall;
        function RegisterEffectFromStream(classId: TGUID; propertyXml: IStream; bindings: PD2D1_PROPERTY_BINDING;
            bindingsCount: UINT32; effectFactory: PD2D1_EFFECT_FACTORY): HResult; stdcall;
        function RegisterEffectFromString(classId: TGUID; propertyXml: PWideChar; bindings: PD2D1_PROPERTY_BINDING;
            bindingsCount: UINT32; effectFactory: PD2D1_EFFECT_FACTORY): HResult; stdcall;
        function UnregisterEffect(classId: TGUID): HResult; stdcall;
        function GetRegisteredEffects(out effects: PGUID; effectsCount: UINT32; out effectsReturned: UINT32;
            out effectsRegistered: UINT32): HResult; stdcall;
        function GetEffectProperties(effectId: TGUID; out properties: ID2D1Properties): HResult; stdcall;
    end;


    ID2D1Multithread = interface(IUnknown)
        ['{31e6e7bc-e0ff-4d46-8c64-a0a8c41c15d3}']
        function GetMultithreadProtected(): longbool; stdcall;
        procedure Enter(); stdcall;
        procedure Leave(); stdcall;
    end;

    { D2D1EffectAuthor.h }


    ID2D1VertexBuffer = interface(IUnknown)
        ['{9b8b1336-00a5-4668-92b7-ced5d8bf9b7b}']
        function Map(out Data: PBYTE; bufferSize: UINT32): HResult; stdcall;
        function Unmap(): HResult; stdcall;
    end;


    ID2D1ResourceTexture = interface(IUnknown)
        ['{688d15c3-02b0-438d-b13a-d1b44c32c39a}']
        function Update(minimumExtents: PUINT32; maximimumExtents: PUINT32; strides: PUINT32; dimensions: UINT32;
            Data: PBYTE; dataCount: UINT32): HResult; stdcall;
    end;


    ID2D1RenderInfo = interface(IUnknown)
        ['{519ae1bd-d19a-420d-b849-364f594776b7}']
        function SetInputDescription(inputIndex: UINT32; inputDescription: TD2D1_INPUT_DESCRIPTION): HResult; stdcall;
        function SetOutputBuffer(bufferPrecision: TD2D1_BUFFER_PRECISION; channelDepth: TD2D1_CHANNEL_DEPTH): HResult; stdcall;
        procedure SetCached(isCached: longbool); stdcall;
        procedure SetInstructionCountHint(instructionCount: UINT32); stdcall;
    end;


    ID2D1DrawInfo = interface(ID2D1RenderInfo)
        ['{693ce632-7f2f-45de-93fe-18d88b37aa21}']
        function SetPixelShaderConstantBuffer(buffer: PBYTE; bufferCount: UINT32): HResult; stdcall;
        function SetResourceTexture(textureIndex: UINT32; resourceTexture: ID2D1ResourceTexture): HResult; stdcall;
        function SetVertexShaderConstantBuffer(buffer: PBYTE; bufferCount: UINT32): HResult; stdcall;
        function SetPixelShader(shaderId: TGUID; pixelOptions: TD2D1_PIXEL_OPTIONS = D2D1_PIXEL_OPTIONS_NONE): HResult; stdcall;
        function SetVertexProcessing(vertexBuffer: ID2D1VertexBuffer; vertexOptions: TD2D1_VERTEX_OPTIONS;
            blendDescription: PD2D1_BLEND_DESCRIPTION = nil; vertexRange: PD2D1_VERTEX_RANGE = nil;
            vertexShader: PGUID = nil): HResult; stdcall;
    end;


    ID2D1ComputeInfo = interface(ID2D1RenderInfo)
        ['{5598b14b-9fd7-48b7-9bdb-8f0964eb38bc}']
        function SetComputeShaderConstantBuffer(buffer: PBYTE; bufferCount: UINT32): HResult; stdcall;
        function SetComputeShader(shaderId: TGUID): HResult; stdcall;
        function SetResourceTexture(textureIndex: UINT32; resourceTexture: ID2D1ResourceTexture): HResult; stdcall;
    end;


    ID2D1TransformNode = interface(IUnknown)
        ['{b2efe1e7-729f-4102-949f-505fa21bf666}']
        function GetInputCount(): UINT32; stdcall;
    end;


    ID2D1TransformGraph = interface(IUnknown)
        ['{13d29038-c3e6-4034-9081-13b53a417992}']
        function GetInputCount(): UINT32; stdcall;
        function SetSingleTransformNode(node: ID2D1TransformNode): HResult; stdcall;
        function AddNode(node: ID2D1TransformNode): HResult; stdcall;
        function RemoveNode(node: ID2D1TransformNode): HResult; stdcall;
        function SetOutputNode(node: ID2D1TransformNode): HResult; stdcall;
        function ConnectNode(fromNode: ID2D1TransformNode; toNode: ID2D1TransformNode; toNodeInputIndex: UINT32): HResult; stdcall;
        function ConnectToEffectInput(toEffectInputIndex: UINT32; node: ID2D1TransformNode; toNodeInputIndex: UINT32): HResult; stdcall;
        procedure Clear(); stdcall;
        function SetPassthroughGraph(effectInputIndex: UINT32): HResult; stdcall;
    end;


    ID2D1Transform = interface(ID2D1TransformNode)
        ['{ef1a287d-342a-4f76-8fdb-da0d6ea9f92b}']
        function MapOutputRectToInputRects(outputRect: PD2D1_RECT_L; out inputRects: PD2D1_RECT_L;
            inputRectsCount: UINT32): HResult; stdcall;
        function MapInputRectsToOutputRect(inputRects: PD2D1_RECT_L; inputOpaqueSubRects: PD2D1_RECT_L;
            inputRectCount: UINT32; out outputRect: TD2D1_RECT_L; out outputOpaqueSubRect: TD2D1_RECT_L): HResult; stdcall;
        function MapInvalidRect(inputIndex: UINT32; invalidInputRect: TD2D1_RECT_L;
            out invalidOutputRect: TD2D1_RECT_L): HResult; stdcall;
    end;


    ID2D1DrawTransform = interface(ID2D1Transform)
        ['{36bfdcb6-9739-435d-a30d-a653beff6a6f}']
        function SetDrawInfo(drawInfo: ID2D1DrawInfo): HResult; stdcall;
    end;


    ID2D1ComputeTransform = interface(ID2D1Transform)
        ['{0d85573c-01e3-4f7d-bfd9-0d60608bf3c3}']
        function SetComputeInfo(computeInfo: ID2D1ComputeInfo): HResult; stdcall;
        function CalculateThreadgroups(outputRect: PD2D1_RECT_L; out dimensionX: UINT32; out dimensionY: UINT32;
            out dimensionZ: UINT32): HResult; stdcall;
    end;


    ID2D1AnalysisTransform = interface(IUnknown)
        ['{0359dc30-95e6-4568-9055-27720d130e93}']
        function ProcessAnalysisResults(analysisData: PBYTE; analysisDataCount: UINT32): HResult; stdcall;
    end;


    ID2D1SourceTransform = interface(ID2D1Transform)
        ['{db1800dd-0c34-4cf9-be90-31cc0a5653e1}']
        function SetRenderInfo(renderInfo: ID2D1RenderInfo): HResult; stdcall;
        function Draw(target: ID2D1Bitmap1; drawRect: PD2D1_RECT_L; targetOrigin: TD2D1_POINT_2U): HResult; stdcall;
    end;


    ID2D1ConcreteTransform = interface(ID2D1TransformNode)
        ['{1a799d8a-69f7-4e4c-9fed-437ccc6684cc}']
        function SetOutputBuffer(bufferPrecision: TD2D1_BUFFER_PRECISION; channelDepth: TD2D1_CHANNEL_DEPTH): HResult; stdcall;
        procedure SetCached(isCached: longbool); stdcall;
    end;


    ID2D1BlendTransform = interface(ID2D1ConcreteTransform)
        ['{63ac0b32-ba44-450f-8806-7f4ca1ff2f1b}']
        procedure SetDescription(description: PD2D1_BLEND_DESCRIPTION); stdcall;
        procedure GetDescription(out description: TD2D1_BLEND_DESCRIPTION); stdcall;
    end;


    ID2D1BorderTransform = interface(ID2D1ConcreteTransform)
        ['{4998735c-3a19-473c-9781-656847e3a347}']
        procedure SetExtendModeX(extendMode: TD2D1_EXTEND_MODE); stdcall;
        procedure SetExtendModeY(extendMode: TD2D1_EXTEND_MODE); stdcall;
        function GetExtendModeX(): TD2D1_EXTEND_MODE; stdcall;
        function GetExtendModeY(): TD2D1_EXTEND_MODE; stdcall;
    end;


    ID2D1OffsetTransform = interface(ID2D1TransformNode)
        ['{3fe6adea-7643-4f53-bd14-a0ce63f24042}']
        procedure SetOffset(offset: TD2D1_POINT_2L); stdcall;
        function GetOffset(): TD2D1_POINT_2L; stdcall;
    end;


    ID2D1BoundsAdjustmentTransform = interface(ID2D1TransformNode)
        ['{90f732e2-5092-4606-a819-8651970baccd}']
        procedure SetOutputBounds(outputBounds: PD2D1_RECT_L); stdcall;
        procedure GetOutputBounds(out outputBounds: TD2D1_RECT_L); stdcall;
    end;

    ID2D1EffectContext = interface;

    ID2D1EffectImpl = interface(IUnknown)
        ['{a248fd3f-3e6c-4e63-9f03-7f68ecc91db9}']
        function Initialize(effectContext: ID2D1EffectContext; transformGraph: ID2D1TransformGraph): HResult; stdcall;
        function PrepareForRender(changeType: TD2D1_CHANGE_TYPE): HResult; stdcall;
        function SetGraph(transformGraph: ID2D1TransformGraph): HResult; stdcall;
    end;


    ID2D1EffectContext = interface(IUnknown)
        ['{3d9f916b-27dc-4ad7-b4f1-64945340f563}']
        procedure GetDpi(out dpiX: single; out dpiY: single); stdcall;
        function CreateEffect(effectId: TGUID; out effect: ID2D1Effect): HResult; stdcall;
        function GetMaximumSupportedFeatureLevel(featureLevels: PD3D_FEATURE_LEVEL; featureLevelsCount: UINT32;
            out maximumSupportedFeatureLevel: TD3D_FEATURE_LEVEL): HResult; stdcall;
        function CreateTransformNodeFromEffect(effect: ID2D1Effect; out transformNode: ID2D1TransformNode): HResult;
            stdcall;
        function CreateBlendTransform(numInputs: UINT32; blendDescription: PD2D1_BLEND_DESCRIPTION;
            out transform: ID2D1BlendTransform): HResult; stdcall;
        function CreateBorderTransform(extendModeX: TD2D1_EXTEND_MODE; extendModeY: TD2D1_EXTEND_MODE;
            out transform: ID2D1BorderTransform): HResult; stdcall;
        function CreateOffsetTransform(offset: TD2D1_POINT_2L; out transform: ID2D1OffsetTransform): HResult; stdcall;
        function CreateBoundsAdjustmentTransform(outputRectangle: PD2D1_RECT_L;
            out transform: ID2D1BoundsAdjustmentTransform): HResult; stdcall;
        function LoadPixelShader(shaderId: TGUID; shaderBuffer: PBYTE; shaderBufferCount: UINT32): HResult; stdcall;
        function LoadVertexShader(resourceId: TGUID; shaderBuffer: PBYTE; shaderBufferCount: UINT32): HResult; stdcall;
        function LoadComputeShader(resourceId: TGUID; shaderBuffer: PBYTE; shaderBufferCount: UINT32): HResult; stdcall;
        function IsShaderLoaded(shaderId: TGUID): longbool; stdcall;
        function CreateResourceTexture(resourceId: PGUID; resourceTextureProperties: PD2D1_RESOURCE_TEXTURE_PROPERTIES;
            Data: PBYTE; strides: PUINT32; dataSize: UINT32; out resourceTexture: ID2D1ResourceTexture): HResult;
            stdcall;
        function FindResourceTexture(resourceId: PGUID; out resourceTexture: ID2D1ResourceTexture): HResult; stdcall;
        function CreateVertexBuffer(vertexBufferProperties: PD2D1_VERTEX_BUFFER_PROPERTIES; resourceId: PGUID;
            customVertexBufferProperties: PD2D1_CUSTOM_VERTEX_BUFFER_PROPERTIES; out buffer: ID2D1VertexBuffer): HResult; stdcall;
        function FindVertexBuffer(resourceId: PGUID; out buffer: ID2D1VertexBuffer): HResult; stdcall;
        function CreateColorContext(space: TD2D1_COLOR_SPACE; profile: PBYTE; profileSize: UINT32;
            out colorContext: ID2D1ColorContext): HResult; stdcall;
        function CreateColorContextFromFilename(filename: PWideChar; out colorContext: ID2D1ColorContext): HResult;
            stdcall;
        function CreateColorContextFromWicColorContext(wicColorContext: IWICColorContext;
            out colorContext: ID2D1ColorContext): HResult; stdcall;
        function CheckFeatureSupport(feature: TD2D1_FEATURE; out featureSupportData: Pointer;
            featureSupportDataSize: UINT32): HResult; stdcall;
        function IsBufferPrecisionSupported(bufferPrecision: TD2D1_BUFFER_PRECISION): longbool; stdcall;
    end;


    { D2D1_2.h }

    ID2D1GeometryRealization = interface(ID2D1Resource)
        ['{a16907d7-bc02-4801-99e8-8cf7f485f774}']
    end;


    ID2D1DeviceContext1 = interface(ID2D1DeviceContext)
        ['{d37f57e4-6908-459f-a199-e72f24f79987}']
        function CreateFilledGeometryRealization(geometry: ID2D1Geometry; flatteningTolerance: single;
            out geometryRealization: ID2D1GeometryRealization): HResult; stdcall;
        function CreateStrokedGeometryRealization(geometry: ID2D1Geometry; flatteningTolerance: single;
            strokeWidth: single; strokeStyle: ID2D1StrokeStyle; out geometryRealization: ID2D1GeometryRealization): HResult;
            stdcall;
        procedure DrawGeometryRealization(geometryRealization: ID2D1GeometryRealization; brush: ID2D1Brush); stdcall;
    end;


    ID2D1Device1 = interface(ID2D1Device)
        ['{d21768e1-23a4-4823-a14b-7c3eba85d658}']
        function GetRenderingPriority(): TD2D1_RENDERING_PRIORITY; stdcall;
        procedure SetRenderingPriority(renderingPriority: TD2D1_RENDERING_PRIORITY); stdcall;
        function CreateDeviceContext(options: TD2D1_DEVICE_CONTEXT_OPTIONS; out deviceContext1: ID2D1DeviceContext1): HResult; stdcall;
    end;


    ID2D1Factory2 = interface(ID2D1Factory1)
        ['{94f81a73-9212-4376-9c58-b16a3a0d3992}']
        function CreateDevice(dxgiDevice: IDXGIDevice; out d2dDevice1: ID2D1Device1): HResult; stdcall;
    end;


    ID2D1CommandSink1 = interface(ID2D1CommandSink)
        ['{9eb767fd-4269-4467-b8c2-eb30cb305743}']
        function SetPrimitiveBlend1(primitiveBlend: TD2D1_PRIMITIVE_BLEND): HResult; stdcall;
    end;


    { part of WinCodec.h, but cross reference problem }

    IWICImageEncoder = interface(IUnknown)
        ['{04C75BF8-3CE1-473B-ACC5-3CC4F5E94999}']
        function WriteFrame(pImage: ID2D1Image; pFrameEncode: IWICBitmapFrameEncode;
            const pImageParameters: TWICImageParameters): HResult; stdcall;
        function WriteFrameThumbnail(pImage: ID2D1Image; pFrameEncode: IWICBitmapFrameEncode;
            const pImageParameters: TWICImageParameters): HResult; stdcall;
        function WriteThumbnail(pImage: ID2D1Image; pEncoder: IWICBitmapEncoder; const pImageParameters: TWICImageParameters): HResult; stdcall;
    end;

    { part of WinCodec.h, but cross reference problem }
    IWICImagingFactory2 = interface(IWICImagingFactory)
        ['{7B816B45-1996-4476-B132-DE9E247C8AF0}']
        function CreateImageEncoder(pD2DDevice: ID2D1Device; out ppWICImageEncoder: IWICImageEncoder): HResult; stdcall;
    end;


{ D2D1.h }
function D2D1CreateFactory(factoryType: TD2D1_FACTORY_TYPE; const riid: TGUID; pFactoryOptions: PD2D1_FACTORY_OPTIONS;
    out ppIFactory): HResult; stdcall;
    external D2D1_DLL;

procedure D2D1MakeRotateMatrix(angle: single; center: TD2D1_POINT_2F; out matrix: TD2D1_MATRIX_3X2_F); stdcall; external D2D1_DLL;

procedure D2D1MakeSkewMatrix(angleX: single; angleY: single; center: TD2D1_POINT_2F; out matrix: TD2D1_MATRIX_3X2_F); stdcall; external D2D1_DLL;

function D2D1IsMatrixInvertible(matrix: PD2D1_MATRIX_3X2_F): longbool; stdcall; external D2D1_DLL;

function D2D1InvertMatrix(var matrix: TD2D1_MATRIX_3X2_F): longbool; stdcall; external D2D1_DLL;

{ D2D1_1.h }
function D2D1CreateDevice(dxgiDevice: IDXGIDevice; creationProperties: PD2D1_CREATION_PROPERTIES; out d2dDevice: ID2D1Device): HResult;
    stdcall; external D2D1_DLL;

function D2D1CreateDeviceContext(dxgiSurface: IDXGISurface; creationProperties: PD2D1_CREATION_PROPERTIES;
    out d2dDeviceContext: ID2D1DeviceContext): HResult; stdcall; external D2D1_DLL;

function D2D1ConvertColorSpace(sourceColorSpace: TD2D1_COLOR_SPACE; destinationColorSpace: TD2D1_COLOR_SPACE; color: PD2D1_COLOR_F): TD2D1_COLOR_F;
    stdcall; external D2D1_DLL;

procedure D2D1SinCos(angle: single; out s: single; out c: single); stdcall; external D2D1_DLL;
function D2D1Tan(angle: single): single; stdcall; external D2D1_DLL;
function D2D1Vec3Length(x: single; y: single; z: single): single; stdcall; external D2D1_DLL;


{ D2D1_2.h }
function D2D1ComputeMaximumScaleFactor(const matrix: TD2D1_MATRIX_3X2_F): single; stdcall; external D2D1_DLL;


{ D2D1 Helper functions }

function FloatMax: single;
function Point2(x, y: UINT32): TD2D1_POINT_2U; overload;
function Point2(x, y: single): TD2D1_POINT_2F; overload;

function Size(Width, Height: UINT32): TD2D1_SIZE_U; overload;
function Size(Width, Height: single): TD2D1_SIZE_F; overload;

function Rect(left, top, right, bottom: UINT32): TD2D1_RECT_U; overload;
function Rect(left, top, right, bottom: single): TD2D1_RECT_F; overload;


function RectU(left: UINT32 = 0; top: UINT32 = 0; right: UINT32 = 0; bottom: UINT32 = 0): TD2D1_RECT_U;
function RectF(left: single = 0; top: single = 0; right: single = 0; bottom: single = 0): TD2D1_RECT_F;
function InfiniteRect: TD2D1_RECT_F;
function SizeU(Width: UINT32 = 0; Height: UINT32 = 0): TD2D1_SIZE_U;

function PixelFormat(dxgiFormat: TDXGI_FORMAT = DXGI_FORMAT_UNKNOWN; alphaMode: TD2D1_ALPHA_MODE = D2D1_ALPHA_MODE_UNKNOWN): TD2D1_PIXEL_FORMAT;

function RenderTargetProperties(pixelFormat: TD2D1_PIXEL_FORMAT; _type: TD2D1_RENDER_TARGET_TYPE = D2D1_RENDER_TARGET_TYPE_DEFAULT;
    dpiX: single = 0.0; dpiY: single = 0.0; usage: TD2D1_RENDER_TARGET_USAGE = D2D1_RENDER_TARGET_USAGE_NONE;
    minLevel: TD2D1_FEATURE_LEVEL = D2D1_FEATURE_LEVEL_DEFAULT): TD2D1_RENDER_TARGET_PROPERTIES; overload;
function RenderTargetProperties(_type: TD2D1_RENDER_TARGET_TYPE = D2D1_RENDER_TARGET_TYPE_DEFAULT; dpiX: single = 0.0;
    dpiY: single = 0.0; usage: TD2D1_RENDER_TARGET_USAGE = D2D1_RENDER_TARGET_USAGE_NONE;
    minLevel: TD2D1_FEATURE_LEVEL = D2D1_FEATURE_LEVEL_DEFAULT): TD2D1_RENDER_TARGET_PROPERTIES; overload;

function HwndRenderTargetProperties(hwnd: HWND; pixelSize: TD2D1_SIZE_U;
    presentOptions: TD2D1_PRESENT_OPTIONS = D2D1_PRESENT_OPTIONS_NONE): TD2D1_HWND_RENDER_TARGET_PROPERTIES; overload;
function HwndRenderTargetProperties(hwnd: HWND; presentOptions: TD2D1_PRESENT_OPTIONS = D2D1_PRESENT_OPTIONS_NONE):
    TD2D1_HWND_RENDER_TARGET_PROPERTIES; overload;

function ColorF(rgb: UINT32; a: single = 1.0): TD2D1_COLOR_F; overload;
function ColorF(r, g, b: single; a: single = 1.0): TD2D1_COLOR_F; overload;

function SizeF(Width: single = 0.0; Height: single = 0.0): TD2D1_SIZE_F;
function Point2F(x: single = 0.0; y: single = 0.0): TD2D1_POINT_2F;
function Point2U(x: UINT32 = 0; y: UINT32 = 0): TD2D1_POINT_2U;

function ArcSegment(point: TD2D1_POINT_2F; size: TD2D1_SIZE_F; rotationAngle: single; sweepDirection: TD2D1_SWEEP_DIRECTION;
    arcSize: TD2D1_ARC_SIZE): TD2D1_ARC_SEGMENT;
function BezierSegment(point1: TD2D1_POINT_2F; point2: TD2D1_POINT_2F; point3: TD2D1_POINT_2F): TD2D1_BEZIER_SEGMENT;
function Ellipse(center: TD2D1_POINT_2F; radiusX: single; radiusY: single): TD2D1_ELLIPSE;
function RoundedRect(rect: TD2D1_RECT_F; radiusX: single; radiusY: single): TD2D1_ROUNDED_RECT;
function BrushProperties(transform: TD2D1_MATRIX_3X2_F; opacity: single = 1.0): TD2D1_BRUSH_PROPERTIES; overload;
function BrushProperties(opacity: single = 1.0): TD2D1_BRUSH_PROPERTIES; overload;
function GradientStop(position: single; color: TD2D1_COLOR_F): TD2D1_GRADIENT_STOP;

function QuadraticBezierSegment(point1: TD2D1_POINT_2F; point2: TD2D1_POINT_2F): TD2D1_QUADRATIC_BEZIER_SEGMENT;

function StrokeStyleProperties(startCap: TD2D1_CAP_STYLE = D2D1_CAP_STYLE_FLAT; endCap: TD2D1_CAP_STYLE = D2D1_CAP_STYLE_FLAT;
    dashCap: TD2D1_CAP_STYLE = D2D1_CAP_STYLE_FLAT; lineJoin: TD2D1_LINE_JOIN = D2D1_LINE_JOIN_MITER; miterLimit: single = 10.0;
    dashStyle: TD2D1_DASH_STYLE = D2D1_DASH_STYLE_SOLID; dashOffset: single = 0.0): TD2D1_STROKE_STYLE_PROPERTIES;

function BitmapBrushProperties(extendModeX: TD2D1_EXTEND_MODE = D2D1_EXTEND_MODE_CLAMP; extendModeY: TD2D1_EXTEND_MODE = D2D1_EXTEND_MODE_CLAMP;
    interpolationMode: TD2D1_BITMAP_INTERPOLATION_MODE = D2D1_BITMAP_INTERPOLATION_MODE_LINEAR): TD2D1_BITMAP_BRUSH_PROPERTIES;

function LinearGradientBrushProperties(startPoint: TD2D1_POINT_2F; endPoint: TD2D1_POINT_2F): TD2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES;

function RadialGradientBrushProperties(center: TD2D1_POINT_2F; gradientOriginOffset: TD2D1_POINT_2F; radiusX: single;
    radiusY: single): TD2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES;
function BitmapProperties(pixelFormat: TD2D1_PIXEL_FORMAT; dpiX: single = 96.0; dpiY: single = 96.0): TD2D1_BITMAP_PROPERTIES; overload;
function BitmapProperties(dpiX: single = 96.0; dpiY: single = 96.0): TD2D1_BITMAP_PROPERTIES; overload;

function LayerParameters(contentBounds: TD2D1_RECT_F; maskTransform: TD2D1_MATRIX_3X2_F; geometricMask: ID2D1Geometry = nil;
    maskAntialiasMode: TD2D1_ANTIALIAS_MODE = D2D1_ANTIALIAS_MODE_PER_PRIMITIVE; opacity: single = 1.0;
    opacityBrush: ID2D1Brush = nil; layerOptions: TD2D1_LAYER_OPTIONS = D2D1_LAYER_OPTIONS_NONE): TD2D1_LAYER_PARAMETERS; overload;

function LayerParameters(geometricMask: ID2D1Geometry = nil; maskAntialiasMode: TD2D1_ANTIALIAS_MODE = D2D1_ANTIALIAS_MODE_PER_PRIMITIVE;
    opacity: single = 1.0; opacityBrush: ID2D1Brush = nil; layerOptions: TD2D1_LAYER_OPTIONS = D2D1_LAYER_OPTIONS_NONE): TD2D1_LAYER_PARAMETERS;
    overload;


function DrawingStateDescription(transform: TD2D1_MATRIX_3X2_F; antialiasMode: TD2D1_ANTIALIAS_MODE = D2D1_ANTIALIAS_MODE_PER_PRIMITIVE;
    textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE = D2D1_TEXT_ANTIALIAS_MODE_DEFAULT; tag1: TD2D1_TAG = 0;
    tag2: TD2D1_TAG = 0): TD2D1_DRAWING_STATE_DESCRIPTION; overload;
function DrawingStateDescription(antialiasMode: TD2D1_ANTIALIAS_MODE = D2D1_ANTIALIAS_MODE_PER_PRIMITIVE;
    textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE = D2D1_TEXT_ANTIALIAS_MODE_DEFAULT; tag1: TD2D1_TAG = 0;
    tag2: TD2D1_TAG = 0): TD2D1_DRAWING_STATE_DESCRIPTION; overload;

function Matrix3x2F_Rotation(angle: single; center: TD2D_POINT_2F): TD2D_MATRIX_3X2_F;
function Matrix3x2F_Scale(size: TD2D_SIZE_F; center: TD2D_POINT_2F): TD2D_MATRIX_3X2_F; overload;
function Matrix3x2F_Scale(size: TD2D_SIZE_F): TD2D_MATRIX_3X2_F; overload;
function Matrix3x2F_Scale(x, y: single; center: TD2D_POINT_2F): TD2D_MATRIX_3X2_F; overload;
function Matrix3x2F_Scale(x, y: single): TD2D_MATRIX_3X2_F; overload;

function Matrix3x2F_Translation(x, y: single): TD2D_MATRIX_3X2_F;
function IdentityMatrix: TD2D1_MATRIX_3X2_F;

{ D2D1_1Helper.h }
function ConvertColorSpace(sourceColorSpace: TD2D1_COLOR_SPACE; destinationColorSpace: TD2D1_COLOR_SPACE; color: TD2D1_COLOR_F): TD2D1_COLOR_F;
function DrawingStateDescription1(transform: TD2D1_MATRIX_3X2_F; antialiasMode: TD2D1_ANTIALIAS_MODE = D2D1_ANTIALIAS_MODE_PER_PRIMITIVE;
    textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE = D2D1_TEXT_ANTIALIAS_MODE_DEFAULT; tag1: TD2D1_TAG = 0;
    tag2: TD2D1_TAG = 0; primitiveBlend: TD2D1_PRIMITIVE_BLEND = D2D1_PRIMITIVE_BLEND_SOURCE_OVER;
    unitMode: TD2D1_UNIT_MODE = D2D1_UNIT_MODE_DIPS): TD2D1_DRAWING_STATE_DESCRIPTION1; overload;
function DrawingStateDescription1(antialiasMode: TD2D1_ANTIALIAS_MODE = D2D1_ANTIALIAS_MODE_PER_PRIMITIVE;
    textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE = D2D1_TEXT_ANTIALIAS_MODE_DEFAULT; tag1: TD2D1_TAG = 0;
    tag2: TD2D1_TAG = 0; primitiveBlend: TD2D1_PRIMITIVE_BLEND = D2D1_PRIMITIVE_BLEND_SOURCE_OVER;
    unitMode: TD2D1_UNIT_MODE = D2D1_UNIT_MODE_DIPS): TD2D1_DRAWING_STATE_DESCRIPTION1; overload;
function DrawingStateDescription1(desc: TD2D1_DRAWING_STATE_DESCRIPTION; primitiveBlend: TD2D1_PRIMITIVE_BLEND = D2D1_PRIMITIVE_BLEND_SOURCE_OVER;
    unitMode: TD2D1_UNIT_MODE = D2D1_UNIT_MODE_DIPS): TD2D1_DRAWING_STATE_DESCRIPTION1; overload;

function BitmapProperties1(pixelFormat: TD2D1_PIXEL_FORMAT; bitmapOptions: TD2D1_BITMAP_OPTIONS = D2D1_BITMAP_OPTIONS_NONE;
    dpiX: single = 96.0; dpiY: single = 96.0; colorContext: ID2D1ColorContext = nil): TD2D1_BITMAP_PROPERTIES1;
    overload;

function BitmapProperties1(bitmapOptions: TD2D1_BITMAP_OPTIONS = D2D1_BITMAP_OPTIONS_NONE; dpiX: single = 96.0;
    dpiY: single = 96.0; colorContext: ID2D1ColorContext = nil): TD2D1_BITMAP_PROPERTIES1;
    overload;
function LayerParameters1(contentBounds: TD2D1_RECT_F; maskTransform: TD2D1_MATRIX_3X2_F; geometricMask: ID2D1Geometry = nil;
    maskAntialiasMode: TD2D1_ANTIALIAS_MODE = D2D1_ANTIALIAS_MODE_PER_PRIMITIVE; opacity: single = 1.0;
    opacityBrush: ID2D1Brush = nil; layerOptions: TD2D1_LAYER_OPTIONS1 = D2D1_LAYER_OPTIONS1_NONE): TD2D1_LAYER_PARAMETERS1; overload;
function LayerParameters1(geometricMask: ID2D1Geometry = nil; maskAntialiasMode: TD2D1_ANTIALIAS_MODE = D2D1_ANTIALIAS_MODE_PER_PRIMITIVE;
    opacity: single = 1.0; opacityBrush: ID2D1Brush = nil; layerOptions: TD2D1_LAYER_OPTIONS1 = D2D1_LAYER_OPTIONS1_NONE): TD2D1_LAYER_PARAMETERS1;
    overload;
function StrokeStyleProperties1(startCap: TD2D1_CAP_STYLE = D2D1_CAP_STYLE_FLAT; endCap: TD2D1_CAP_STYLE = D2D1_CAP_STYLE_FLAT;
    dashCap: TD2D1_CAP_STYLE = D2D1_CAP_STYLE_FLAT; lineJoin: TD2D1_LINE_JOIN = D2D1_LINE_JOIN_MITER; miterLimit: single = 10.0;
    dashStyle: TD2D1_DASH_STYLE = D2D1_DASH_STYLE_SOLID; dashOffset: single = 0.0;
    transformType: TD2D1_STROKE_TRANSFORM_TYPE = D2D1_STROKE_TRANSFORM_TYPE_NORMAL): TD2D1_STROKE_STYLE_PROPERTIES1;
function ImageBrushProperties(sourceRectangle: TD2D1_RECT_F; extendModeX: TD2D1_EXTEND_MODE = D2D1_EXTEND_MODE_CLAMP;
    extendModeY: TD2D1_EXTEND_MODE = D2D1_EXTEND_MODE_CLAMP;
    interpolationMode: TD2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR): TD2D1_IMAGE_BRUSH_PROPERTIES;
function BitmapBrushProperties1(extendModeX: TD2D1_EXTEND_MODE = D2D1_EXTEND_MODE_CLAMP; extendModeY: TD2D1_EXTEND_MODE = D2D1_EXTEND_MODE_CLAMP;
    interpolationMode: TD2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR): TD2D1_BITMAP_BRUSH_PROPERTIES1;
function PrintControlProperties(fontSubsetMode: TD2D1_PRINT_FONT_SUBSET_MODE = D2D1_PRINT_FONT_SUBSET_MODE_DEFAULT;
    rasterDpi: single = 150.0; colorSpace: TD2D1_COLOR_SPACE = D2D1_COLOR_SPACE_SRGB): TD2D1_PRINT_CONTROL_PROPERTIES;
function RenderingControls(bufferPrecision: TD2D1_BUFFER_PRECISION; tileSize: TD2D1_SIZE_U): TD2D1_RENDERING_CONTROLS;
function EffectInputDescription(effect: ID2D1Effect; inputIndex: UINT32; inputRectangle: TD2D1_RECT_F): TD2D1_EFFECT_INPUT_DESCRIPTION;
function CreationProperties(threadingMode: TD2D1_THREADING_MODE; debugLevel: TD2D1_DEBUG_LEVEL;
    options: TD2D1_DEVICE_CONTEXT_OPTIONS): TD2D1_CREATION_PROPERTIES;
function Vector2F(x: single = 0.0; y: single = 0.0): TD2D1_VECTOR_2F;

function Vector3F(x: single = 0.0; y: single = 0.0; z: single = 0.0): TD2D1_VECTOR_3F;

function Vector4F(x: single = 0.0; y: single = 0.0; z: single = 0.0; w: single = 0.0): TD2D1_VECTOR_4F;

function Point2L(x: INT32 = 0; y: INT32 = 0): TD2D1_POINT_2L;

function RectL(left: INT32 = 0; top: INT32 = 0; right: INT32 = 0; bottom: INT32 = 0): TD2D1_RECT_L;

function SetDpiCompensatedEffectInput(deviceContext: ID2D1DeviceContext; effect: ID2D1Effect; inputIndex: UINT32;
    inputBitmap: ID2D1Bitmap = nil; interpolationMode: TD2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR;
    borderMode: TD2D1_BORDER_MODE = D2D1_BORDER_MODE_HARD): HRESULT;

{ D2D1_2Helper.h }
function ComputeFlatteningTolerance(matrix: TD2D1_MATRIX_3X2_F; dpiX: single = 96.0; dpiY: single = 96.0; maxZoomFactor: single = 1.0): single;


implementation



function FloatMax: single;
begin
    Result := 3.402823466e+38;
end;



function Point2(x, y: UINT32): TD2D1_POINT_2U;
begin
    Result.x := x;
    Result.y := y;
end;



function Point2(x, y: single): TD2D1_POINT_2F;
begin
    Result.x := x;
    Result.y := y;
end;



function Size(Width, Height: UINT32): TD2D1_SIZE_U;
begin
    Result.Width := Width;
    Result.Height := Height;
end;



function Size(Width, Height: single): TD2D1_SIZE_F;
begin
    Result.Width := Width;
    Result.Height := Height;
end;



function Rect(left, top, right, bottom: UINT32): TD2D1_RECT_U;
begin
    Result.left := left;
    Result.top := top;
    Result.right := right;
    Result.bottom := bottom;
end;



function Rect(left, top, right, bottom: single): TD2D1_RECT_F;
begin
    Result.left := left;
    Result.top := top;
    Result.right := right;
    Result.bottom := bottom;
end;



function RectU(left: UINT32; top: UINT32; right: UINT32; bottom: UINT32): TD2D1_RECT_U;
begin
    Result.left := left;
    Result.bottom := bottom;
    Result.top := top;
    Result.right := right;
end;



function RectF(left: single; top: single; right: single; bottom: single): TD2D1_RECT_F;
begin
    Result.left := left;
    Result.bottom := bottom;
    Result.top := top;
    Result.right := right;
end;



function InfiniteRect: TD2D1_RECT_F;
begin
    Result.left := -FloatMax;
    Result.top := -FloatMax;
    Result.right := FloatMax;
    Result.bottom := FloatMax;
end;



function SizeU(Width: UINT32; Height: UINT32): TD2D1_SIZE_U;
begin
    Result.Width := Width;
    Result.Height := Height;
end;



function PixelFormat(dxgiFormat: TDXGI_FORMAT; alphaMode: TD2D1_ALPHA_MODE): TD2D1_PIXEL_FORMAT;
begin
    Result.format := dxgiFormat;
    Result.alphaMode := alphaMode;
end;



function RenderTargetProperties(pixelFormat: TD2D1_PIXEL_FORMAT; _type: TD2D1_RENDER_TARGET_TYPE; dpiX: single;
    dpiY: single; usage: TD2D1_RENDER_TARGET_USAGE; minLevel: TD2D1_FEATURE_LEVEL): TD2D1_RENDER_TARGET_PROPERTIES;
begin
    Result._type := _type;
    Result.pixelFormat := pixelFormat;
    Result.dpiX := dpiX;
    Result.dpiY := dpiY;
    Result.usage := usage;
    Result.minLevel := minLevel;
end;



function RenderTargetProperties(_type: TD2D1_RENDER_TARGET_TYPE; dpiX: single; dpiY: single; usage: TD2D1_RENDER_TARGET_USAGE;
    minLevel: TD2D1_FEATURE_LEVEL): TD2D1_RENDER_TARGET_PROPERTIES;
begin
    Result._type := _type;
    Result.pixelFormat := PixelFormat();
    Result.dpiX := dpiX;
    Result.dpiY := dpiY;
    Result.usage := usage;
    Result.minLevel := minLevel;
end;



function HwndRenderTargetProperties(hwnd: HWND; pixelSize: TD2D1_SIZE_U;
    presentOptions: TD2D1_PRESENT_OPTIONS): TD2D1_HWND_RENDER_TARGET_PROPERTIES;
begin
    Result.hwnd := hwnd;
    Result.pixelSize := pixelSize;
    Result.presentOptions := presentOptions;
end;



function HwndRenderTargetProperties(hwnd: HWND; presentOptions: TD2D1_PRESENT_OPTIONS): TD2D1_HWND_RENDER_TARGET_PROPERTIES;
begin
    Result.hwnd := hwnd;
    Result.pixelSize := Size(UINT32(0), UINT32(0));
    Result.presentOptions := presentOptions;
end;



function ColorF(rgb: UINT32; a: single): TD2D1_COLOR_F;
begin
    Result.Init(rgb, a);
end;



function ColorF(r, g, b: single; a: single): TD2D1_COLOR_F;
begin
    Result.r := r;
    Result.g := g;
    Result.b := b;
    Result.a := a;
end;



function SizeF(Width: single; Height: single): TD2D1_SIZE_F;
begin
    Result.Width := Width;
    Result.Height := Height;
end;



function Point2F(x: single; y: single): TD2D1_POINT_2F;
begin
    Result.x := x;
    Result.y := y;
end;



function Point2U(x: UINT32; y: UINT32): TD2D1_POINT_2U;
begin
    Result.x := x;
    Result.y := y;
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
    Result.pixelFormat := PixelFormat();
    Result.dpiX := dpiX;
    Result.dpiY := dpiY;
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
    Result.contentBounds := InfiniteRect();
    Result.geometricMask := geometricMask;
    Result.maskAntialiasMode := maskAntialiasMode;
    Result.maskTransform := IdentityMatrix();
    Result.opacity := opacity;
    Result.opacityBrush := opacityBrush;
    Result.layerOptions := layerOptions;
end;



function DrawingStateDescription(transform: TD2D1_MATRIX_3X2_F; antialiasMode: TD2D1_ANTIALIAS_MODE;
    textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE; tag1: TD2D1_TAG; tag2: TD2D1_TAG): TD2D1_DRAWING_STATE_DESCRIPTION;
begin
    Result.antialiasMode := antialiasMode;
    Result.textAntialiasMode := textAntialiasMode;
    Result.tag1 := tag1;
    Result.tag2 := tag2;
    Result.transform := transform;
end;



function DrawingStateDescription(antialiasMode: TD2D1_ANTIALIAS_MODE; textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE;
    tag1: TD2D1_TAG; tag2: TD2D1_TAG): TD2D1_DRAWING_STATE_DESCRIPTION;
begin
    Result.antialiasMode := antialiasMode;
    Result.textAntialiasMode := textAntialiasMode;
    Result.tag1 := tag1;
    Result.tag2 := tag2;
    Result.transform := IdentityMatrix();
end;



function Matrix3x2F_Rotation(angle: single; center: TD2D_POINT_2F): TD2D_MATRIX_3X2_F;
begin
    Result.Rotation(angle, center);
end;



function Matrix3x2F_Scale(size: TD2D_SIZE_F; center: TD2D_POINT_2F): TD2D_MATRIX_3X2_F;
begin
    Result.Scale(size, center);
end;



function Matrix3x2F_Scale(size: TD2D_SIZE_F): TD2D_MATRIX_3X2_F;
begin
    Result.Scale(size, Point2F);
end;



function Matrix3x2F_Scale(x, y: single; center: TD2D_POINT_2F): TD2D_MATRIX_3X2_F;
begin
    Result.Scale(x, y, center);
end;



function Matrix3x2F_Scale(x, y: single): TD2D_MATRIX_3X2_F;
begin
    Result.Scale(x, y, Point2F);
end;



function Matrix3x2F_Translation(x, y: single): TD2D_MATRIX_3X2_F;
begin
    Result.Translation(x, y);
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
    Result.antialiasMode := antialiasMode;
    Result.textAntialiasMode := textAntialiasMode;
    Result.tag1 := tag1;
    Result.tag2 := tag2;
    Result.transform := transform;
    Result.primitiveBlend := primitiveBlend;
    Result.unitMode := unitMode;
end;



function DrawingStateDescription1(antialiasMode: TD2D1_ANTIALIAS_MODE; textAntialiasMode: TD2D1_TEXT_ANTIALIAS_MODE;
    tag1: TD2D1_TAG; tag2: TD2D1_TAG; primitiveBlend: TD2D1_PRIMITIVE_BLEND; unitMode: TD2D1_UNIT_MODE): TD2D1_DRAWING_STATE_DESCRIPTION1;
begin
    Result.antialiasMode := antialiasMode;
    Result.textAntialiasMode := textAntialiasMode;
    Result.tag1 := tag1;
    Result.tag2 := tag2;
    Result.transform := IdentityMatrix();
    Result.primitiveBlend := primitiveBlend;
    Result.unitMode := unitMode;
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



function BitmapProperties1(pixelFormat: TD2D1_PIXEL_FORMAT; bitmapOptions: TD2D1_BITMAP_OPTIONS; dpiX: single;
    dpiY: single; colorContext: ID2D1ColorContext): TD2D1_BITMAP_PROPERTIES1;
begin
    Result.bitmapOptions := bitmapOptions;
    Result.colorContext := colorContext;
    Result.dpiX := dpiX;
    Result.dpiY := dpiY;
    Result.pixelFormat := pixelFormat;
end;



function BitmapProperties1(bitmapOptions: TD2D1_BITMAP_OPTIONS; dpiX: single; dpiY: single;
    colorContext: ID2D1ColorContext): TD2D1_BITMAP_PROPERTIES1;
begin
    Result.bitmapOptions := bitmapOptions;
    Result.colorContext := colorContext;
    Result.dpiX := dpiX;
    Result.dpiY := dpiY;
    Result.pixelFormat := PixelFormat();
end;



function LayerParameters1(contentBounds: TD2D1_RECT_F; maskTransform: TD2D1_MATRIX_3X2_F; geometricMask: ID2D1Geometry;
    maskAntialiasMode: TD2D1_ANTIALIAS_MODE; opacity: single; opacityBrush: ID2D1Brush;
    layerOptions: TD2D1_LAYER_OPTIONS1): TD2D1_LAYER_PARAMETERS1;
begin
    Result.contentBounds := contentBounds;
    Result.geometricMask := geometricMask;
    Result.maskAntialiasMode := maskAntialiasMode;
    Result.maskTransform := maskTransform;
    Result.opacity := opacity;
    Result.opacityBrush := opacityBrush;
    Result.layerOptions := layerOptions;
end;



function LayerParameters1(geometricMask: ID2D1Geometry; maskAntialiasMode: TD2D1_ANTIALIAS_MODE; opacity: single;
    opacityBrush: ID2D1Brush; layerOptions: TD2D1_LAYER_OPTIONS1): TD2D1_LAYER_PARAMETERS1;
begin
    Result.contentBounds := InfiniteRect();
    Result.geometricMask := geometricMask;
    Result.maskAntialiasMode := maskAntialiasMode;
    Result.maskTransform := IdentityMatrix();
    Result.opacity := opacity;
    Result.opacityBrush := opacityBrush;
    Result.layerOptions := layerOptions;
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



function EffectInputDescription(effect: ID2D1Effect; inputIndex: UINT32; inputRectangle: TD2D1_RECT_F): TD2D1_EFFECT_INPUT_DESCRIPTION;
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
    Result.x := x;
    Result.y := y;
end;



function Vector3F(x: single; y: single; z: single): TD2D1_VECTOR_3F;
begin
    Result.x := x;
    Result.y := y;
    Result.z := z;
end;



function Vector4F(x: single; y: single; z: single; w: single): TD2D1_VECTOR_4F;
begin
    Result.x := x;
    Result.y := y;
    Result.z := z;
    Result.w := w;
end;



function Point2L(x: INT32; y: INT32): TD2D1_POINT_2L;
begin
    Result.x := x;
    Result.y := y;
end;



function RectL(left: INT32; top: INT32; right: INT32; bottom: INT32): TD2D1_RECT_L;
begin
    Result.Left := left;
    Result.Top := top;
    Result.right := right;
    Result.bottom := bottom;
end;



function SetDpiCompensatedEffectInput(deviceContext: ID2D1DeviceContext; effect: ID2D1Effect; inputIndex: UINT32;
    inputBitmap: ID2D1Bitmap; interpolationMode: TD2D1_INTERPOLATION_MODE; borderMode: TD2D1_BORDER_MODE): HRESULT;
var
    dpiCompensationEffect: ID2D1Effect;
    bitmapDpi: TD2D1_POINT_2F;



    procedure SetInputEffect(index: UINT32; inputEffect: ID2D1Effect = nil; invalidate: longbool = True);
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

{ TD2D_SIZE_U }

class operator TD2D_SIZE_U.Equal(a, b: TD2D_SIZE_U): longbool;
begin
    result:= (a.width = b.width) AND (a.height = b.height);
end;

{ TD2D_RECT_U }

class operator TD2D_RECT_U.Equal(a, b: TD2D_RECT_U): longbool;
begin
     result:= (a.left  = b.left)  AND (a.top     = b.top)  AND
           (a.right = b.right)  AND (a.bottom  = b.bottom);
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
