unit DX12.DComp;
//---------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
//---------------------------------------------------------------------------

interface

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

{$Z4}

uses
    Windows, Classes, SysUtils,
    DX12.D2D1,
    DX12.DXGI,
    DX12.DXGI1_2,
    DX12.D3D9Types,
    DX12.DCompTypes,
    DX12.DCompAnimation;

const
    DComp_DLL = 'Dcomp.dll';

// {$IF  (NTDDI_VERSION >= NTDDI_WIN8) }

const
    IID_IDCompositionDevice: TGUID = '{C37EA93A-E7AA-450D-B16F-9746CB0407F3}';
    IID_IDCompositionTarget: TGUID = '{eacdd04c-117e-4e17-88f4-d1b12b0e3d89}';
    IID_IDCompositionVisual: TGUID = '{4d93059d-097b-4651-9a60-f0f25116e2f3}';
    IID_IDCompositionEffect: TGUID = '{EC81B08F-BFCB-4e8d-B193-A915587999E8}';
    IID_IDCompositionTransform3D: TGUID = '{71185722-246B-41f2-AAD1-0443F7F4BFC2}';
    IID_IDCompositionTransform: TGUID = '{FD55FAA7-37E0-4c20-95D2-9BE45BC33F55}';
    IID_IDCompositionTranslateTransform: TGUID = '{06791122-C6F0-417d-8323-269E987F5954}';
    IID_IDCompositionScaleTransform: TGUID = '{71FDE914-40EF-45ef-BD51-68B037C339F9}';
    IID_IDCompositionRotateTransform: TGUID = '{641ED83C-AE96-46c5-90DC-32774CC5C6D5}';
    IID_IDCompositionSkewTransform: TGUID = '{E57AA735-DCDB-4c72-9C61-0591F58889EE}';
    IID_IDCompositionMatrixTransform: TGUID = '{16CDFF07-C503-419c-83F2-0965C7AF1FA6}';
    IID_IDCompositionEffectGroup: TGUID = '{A7929A74-E6B2-4bd6-8B95-4040119CA34D}';
    IID_IDCompositionTranslateTransform3D: TGUID = '{91636D4B-9BA1-4532-AAF7-E3344994D788}';
    IID_IDCompositionScaleTransform3D: TGUID = '{2A9E9EAD-364B-4b15-A7C4-A1997F78B389}';
    IID_IDCompositionRotateTransform3D: TGUID = '{D8F5B23F-D429-4a91-B55A-D2F45FD75B18}';
    IID_IDCompositionMatrixTransform3D: TGUID = '{4B3363F0-643B-41b7-B6E0-CCF22D34467C}';
    IID_IDCompositionClip: TGUID = '{64AC3703-9D3F-45ec-A109-7CAC0E7A13A7}';
    IID_IDCompositionRectangleClip: TGUID = '{9842AD7D-D9CF-4908-AED7-48B51DA5E7C2}';
    IID_IDCompositionSurface: TGUID = '{BB8A4953-2C99-4F5A-96F5-4819027FA3AC}';
    IID_IDCompositionVirtualSurface: TGUID = '{AE471C51-5F53-4A24-8D3E-D0C39C30B3F0}';
    IID_IDCompositionDevice2: TGUID = '{75F6468D-1B8E-447C-9BC6-75FEA80B5B25}';
    IID_IDCompositionDesktopDevice: TGUID = '{5F4633FE-1E08-4CB8-8C75-CE24333F5602}';
    IID_IDCompositionDeviceDebug: TGUID = '{A1A3C64A-224F-4A81-9773-4F03A89D3C6C}';
    IID_IDCompositionDevice3: TGUID = '{0987CB06-F916-48BF-8D35-CE7641781BD9}';
    IID_IDCompositionFilterEffect: TGUID = '{30C421D5-8CB2-4E9F-B133-37BE270D4AC2}';
    IID_IDCompositionGaussianBlurEffect: TGUID = '{45D4D0B7-1BD4-454E-8894-2BFA68443033}';
    IID_IDCompositionBrightnessEffect: TGUID = '{6027496E-CB3A-49AB-934F-D798DA4F7DA6}';
    IID_IDCompositionSurfaceFactory: TGUID = '{E334BC12-3937-4E02-85EB-FCF4EB30D2C8}';
    IID_IDCompositionVisual2: TGUID = '{E8DE1639-4331-4B26-BC5F-6A321D347A85}';
    IID_IDCompositionVisual3: TGUID = '{2775F462-B6C1-4015-B0BE-B3E7D6A4976D}';
    IID_IDCompositionVisualDebug: TGUID = '{FED2B808-5EB4-43A0-AEA3-35F65280F91B}';
    IID_IDCompositionColorMatrixEffect: TGUID = '{C1170A22-3CE2-4966-90D4-55408BFC84C4}';
    IID_IDCompositionShadowEffect: TGUID = '{4AD18AC0-CFD2-4C2F-BB62-96E54FDB6879}';
    IID_IDCompositionHueRotationEffect: TGUID = '{6DB9F920-0770-4781-B0C6-381912F9D167}';
    IID_IDCompositionSaturationEffect: TGUID = '{A08DEBDA-3258-4FA4-9F16-9174D3FE93B1}';
    IID_IDCompositionTurbulenceEffect: TGUID = '{A6A55BDA-C09C-49F3-9193-A41922C89715}';
    IID_IDCompositionLinearTransferEffect: TGUID = '{4305EE5B-C4A0-4C88-9385-67124E017683}';
    IID_IDCompositionTableTransferEffect: TGUID = '{9B7E82E2-69C5-4EB4-A5F5-A7033F5132CD}';
    IID_IDCompositionCompositeEffect: TGUID = '{576616C0-A231-494D-A38D-00FD5EC4DB46}';
    IID_IDCompositionBlendEffect: TGUID = '{33ECDC0A-578A-4A11-9C14-0CB90517F9C5}';
    IID_IDCompositionArithmeticCompositeEffect: TGUID = '{3B67DFA8-E3DD-4E61-B640-46C2F3D739DC}';
    IID_IDCompositionAffineTransform2DEffect: TGUID = '{0B74B9E8-CDD6-492F-BBBC-5ED32157026D}';

type
    IDCompositionDevice = interface;
    IDCompositionTarget = interface;
    IDCompositionVisual = interface;

    IDCompositionTransform = interface;
    IDCompositionTransform3D = interface;
    IDCompositionTranslateTransform = interface;
    IDCompositionTranslateTransform3D = interface;
    IDCompositionScaleTransform = interface;
    IDCompositionScaleTransform3D = interface;
    IDCompositionRotateTransform = interface;
    IDCompositionRotateTransform3D = interface;
    IDCompositionSkewTransform = interface;
    IDCompositionMatrixTransform = interface;
    IDCompositionMatrixTransform3D = interface;
    IDCompositionEffect = interface;
    IDCompositionEffectGroup = interface;
    IDCompositionClip = interface;
    IDCompositionRectangleClip = interface;

    IDCompositionSurface = interface;
    IDCompositionVirtualSurface = interface;
    IDCompositionFilterEffect = interface;
    IDCompositionGaussianBlurEffect = interface;
    IDCompositionBrightnessEffect = interface;
    IDCompositionColorMatrixEffect = interface;
    IDCompositionShadowEffect = interface;
    IDCompositionHueRotationEffect = interface;
    IDCompositionSaturationEffect = interface;
    IDCompositionTurbulenceEffect = interface;
    IDCompositionLinearTransferEffect = interface;
    IDCompositionTableTransferEffect = interface;
    IDCompositionCompositeEffect = interface;
    IDCompositionBlendEffect = interface;
    IDCompositionArithmeticCompositeEffect = interface;
    IDCompositionAffineTransform2DEffect = interface;

    PIDCompositionTransform = ^IDCompositionTransform;
    PIDCompositionTransform3D = ^IDCompositionTransform3D;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionDevice
    // Synopsis:
    // Serves as the root factory for all other DirectComposition objects and
    // controls transactional composition.
    //------------------------------------------------------------------------------

    IDCompositionDevice = interface(IUnknown)
        ['{C37EA93A-E7AA-450D-B16F-9746CB0407F3}']
        // Commits all DirectComposition commands pending on this device.
        function Commit(): HResult; stdcall;
        // Waits for the last Commit to be processed by the composition engine
        function WaitForCommitCompletion(): HResult; stdcall;
        // Gets timing information about the composition engine.
        function GetFrameStatistics(out statistics: TDCOMPOSITION_FRAME_STATISTICS): HResult; stdcall;
        // Creates a composition target bound to a window represented by an HWND.
        function CreateTargetForHwnd(hwnd: HWND; topmost: boolean; out target: IDCompositionTarget): HResult; stdcall;
        // Creates a new visual object.
        function CreateVisual(out visual: IDCompositionVisual): HResult; stdcall;
        // Creates a DirectComposition surface object
        function CreateSurface(Width: UINT; Height: UINT; pixelFormat: TDXGI_FORMAT; alphaMode: TDXGI_ALPHA_MODE;
            out surface: IDCompositionSurface): HResult; stdcall;
        // Creates a DirectComposition virtual surface object
        function CreateVirtualSurface(initialWidth: UINT; initialHeight: UINT; pixelFormat: TDXGI_FORMAT; alphaMode: TDXGI_ALPHA_MODE;
            out virtualSurface: IDCompositionVirtualSurface): HResult; stdcall;
        // Creates a surface wrapper around a pre-existing surface that can be associated with one or more visuals for composition.
        function CreateSurfaceFromHandle(handle: THANDLE; out surface: IUnknown): HResult; stdcall;
        // Creates a wrapper object that represents the rasterization of a layered window and which can be associated with a visual for composition.
        function CreateSurfaceFromHwnd(hwnd: HWND; out surface: IUnknown): HResult; stdcall;
        // Creates a 2D translation transform object.
        function CreateTranslateTransform(out translateTransform: IDCompositionTranslateTransform): HResult; stdcall;
        // Creates a 2D scale transform object.
        function CreateScaleTransform(out scaleTransform: IDCompositionScaleTransform): HResult; stdcall;
        // Creates a 2D rotation transform object.
        function CreateRotateTransform(out rotateTransform: IDCompositionRotateTransform): HResult; stdcall;
        // Creates a 2D skew transform object.
        function CreateSkewTransform(out skewTransform: IDCompositionSkewTransform): HResult; stdcall;
        // Creates a 2D 3x2 matrix transform object.
        function CreateMatrixTransform(out matrixTransform: IDCompositionMatrixTransform): HResult; stdcall;
        // Creates a 2D transform object that holds an array of 2D transform objects.
        function CreateTransformGroup(transforms: PIDCompositionTransform{ array of elements}; elements: UINT;
            out transformGroup: IDCompositionTransform): HResult; stdcall;
        // Creates a 3D translation transform object.
        function CreateTranslateTransform3D(out translateTransform3D: IDCompositionTranslateTransform3D): HResult; stdcall;
        // Creates a 3D scale transform object.
        function CreateScaleTransform3D(out scaleTransform3D: IDCompositionScaleTransform3D): HResult; stdcall;
        // Creates a 3D rotation transform object.
        function CreateRotateTransform3D(out rotateTransform3D: IDCompositionRotateTransform3D): HResult; stdcall;
        // Creates a 3D 4x4 matrix transform object.
        function CreateMatrixTransform3D(out matrixTransform3D: IDCompositionMatrixTransform3D): HResult; stdcall;
        // Creates a 3D transform object that holds an array of 3D transform objects.
        function CreateTransform3DGroup(transforms3D: {array size elements} IDCompositionTransform3D; elements: UINT;
            out transform3DGroup: IDCompositionTransform3D): HResult; stdcall;
        // Creates an effect group
        function CreateEffectGroup(out effectGroup: IDCompositionEffectGroup): HResult; stdcall;
        // Creates a clip object that can be used to clip the contents of a visual subtree.
        function CreateRectangleClip(out clip: IDCompositionRectangleClip): HResult; stdcall;
        // Creates an animation object
        function CreateAnimation(out animation: IDCompositionAnimation): HResult; stdcall;
        // Returns the states of the app's DX device and DWM's dx devices
        function CheckDeviceState(out pfValid: boolean): HResult; stdcall;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionTarget
    // Synopsis:
    // An IDCompositionTarget interface represents a binding between a
    // DirectComposition visual tree and a destination on top of which the
    // visual tree should be composed.
    //------------------------------------------------------------------------------
    IDCompositionTarget = interface(IUnknown)
        ['{eacdd04c-117e-4e17-88f4-d1b12b0e3d89}']
        // Sets the root visual
        function SetRoot(visual: IDCompositionVisual): HResult; stdcall;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionVisual
    // Synopsis:
    // An IDCompositionVisual interface represents a visual that participates in
    // a visual tree.
    //------------------------------------------------------------------------------

    IDCompositionVisual = interface(IUnknown)
        ['{4d93059d-097b-4651-9a60-f0f25116e2f3}']
        // Animates the value of the OffsetX property.
        function SetOffsetX(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of OffsetX property
        function SetOffsetX(offsetX: single): HResult; stdcall; overload;
        // Animates the value of the OffsetY property.
        function SetOffsetY(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of OffsetY property
        function SetOffsetY(offsetY: single): HResult; stdcall; overload;


        // Sets the matrix that modifies the coordinate system of this visual.
        function SetTransform(const matrix: TD2D_MATRIX_3X2_F): HResult; stdcall;
        // Sets the transformation object that modifies the coordinate system of this visual.
        function _SetTransform(transform: IDCompositionTransform): HResult; stdcall;
        // Sets the visual that should act as this visual's parent for the
        // purpose of establishing a base coordinate system.
        function SetTransformParent(visual: IDCompositionVisual): HResult; stdcall;
        // Sets the effect object that is applied during the rendering of this visual
        function SetEffect(effect: IDCompositionEffect): HResult; stdcall;
        // Sets the mode to use when interpolating pixels from bitmaps drawn not
        // exactly at scale and axis-aligned.
        function SetBitmapInterpolationMode(interpolationMode: TDCOMPOSITION_BITMAP_INTERPOLATION_MODE): HResult; stdcall;
        // Sets the mode to use when drawing the edge of bitmaps that are not
        // exactly axis-aligned and at precise pixel boundaries.
        function SetBorderMode(borderMode: TDCOMPOSITION_BORDER_MODE): HResult; stdcall;
        // Sets the clip object that restricts the rendering of this visual to a D2D rectangle.
        function SetClip(const rect: TD2D_RECT_F): HResult; stdcall;
        // Sets the clip object that restricts the rendering of this visual to a rectangle.
        function _SetClip(clip: IDCompositionClip): HResult; stdcall;
        // Associates a bitmap with a visual
        function SetContent(content: IUnknown): HResult; stdcall;
        // Adds a visual to the children list of another visual.
        function AddVisual(visual: IDCompositionVisual; insertAbove: boolean; referenceVisual: IDCompositionVisual): HResult; stdcall;
        // Removes a visual from the children list of another visual.
        function RemoveVisual(visual: IDCompositionVisual): HResult; stdcall;
        // Removes all visuals from the children list of another visual.
        function RemoveAllVisuals(): HResult; stdcall;
        // Sets the mode to use when composing the bitmap against the render target.
        function SetCompositeMode(compositeMode: TDCOMPOSITION_COMPOSITE_MODE): HResult; stdcall;
    end;


    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionEffect
    // Synopsis:
    // An IDCompositionEffect interface represents an effect
    //------------------------------------------------------------------------------

    IDCompositionEffect = interface(IUnknown)
        ['{EC81B08F-BFCB-4e8d-B193-A915587999E8}']
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionTransform3D
    // Synopsis:
    // An IDCompositionTransform3D interface represents a 3D transformation.
    //------------------------------------------------------------------------------

    IDCompositionTransform3D = interface(IDCompositionEffect)
        ['{71185722-246B-41f2-AAD1-0443F7F4BFC2}']
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionTransform
    // Synopsis:
    // An IDCompositionTransform interface represents a 2D transformation that
    // can be used to modify the coordinate space of a visual subtree.
    //------------------------------------------------------------------------------

    IDCompositionTransform = interface(IDCompositionTransform3D)
        ['{FD55FAA7-37E0-4c20-95D2-9BE45BC33F55}']
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionTranslateTransform
    // Synopsis:
    // An IDCompositionTranslateTransform interface represents a 2D transformation
    // that affects only the offset of a visual along the x and y axes.
    //------------------------------------------------------------------------------

    IDCompositionTranslateTransform = interface(IDCompositionTransform)
        ['{06791122-C6F0-417d-8323-269E987F5954}']
        // Animates the value of the OffsetX property.
        function SetOffsetX(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the OffsetX property.
        function SetOffsetX(offsetX: single): HResult; stdcall; overload;

        // Animates the value of the OffsetY property.
        function SetOffsetY(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the OffsetY property.
        function SetOffsetY(offsetY: single): HResult; stdcall; overload;

    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionScaleTransform
    // Synopsis:
    // An IDCompositionScaleTransform interface represents a 2D transformation that
    // affects the scale of a visual along the x and y axes. The coordinate system
    // is scaled from the specified center point.
    //------------------------------------------------------------------------------

    IDCompositionScaleTransform = interface(IDCompositionTransform)
        ['{71FDE914-40EF-45ef-BD51-68B037C339F9}']
        // Animates the value of the ScaleX property.
        function SetScaleX(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the ScaleX property.
        function SetScaleX(scaleX: single): HResult; stdcall;
            overload;

        // Animates the value of the ScaleY property.
        function SetScaleY(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the ScaleY property.
        function SetScaleY(scaleY: single): HResult; stdcall; overload;

        // Animates the value of the CenterX property.
        function SetCenterX(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the CenterX property.
        function SetCenterX(centerX: single): HResult; stdcall; overload;

        // Animates the value of the CenterY property.
        function SetCenterY(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the CenterY property.
        function SetCenterY(centerY: single): HResult; stdcall; overload;

    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionRotateTransform
    // Synopsis:
    // An IDCompositionRotateTransform interface represents a 2D transformation
    // that affects the rotation of a visual along the z axis. The coordinate system
    // is rotated around the specified center point.
    //------------------------------------------------------------------------------
    IDCompositionRotateTransform = interface(IDCompositionTransform)
        ['{641ED83C-AE96-46c5-90DC-32774CC5C6D5}']
        // Animates the value of the Angle property.
        function SetAngle(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the Angle property.
        function SetAngle(angle: single): HResult; stdcall; overload;

        // Animates the value of the CenterX property.
        function SetCenterX(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the CenterX property.
        function SetCenterX(centerX: single): HResult; stdcall; overload;

        // Animates the value of the CenterY property.
        function SetCenterY(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the CenterY property.
        function SetCenterY(centerY: single): HResult; stdcall; overload;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionSkewTransform
    // Synopsis:
    // An IDCompositionSkewTransform interface represents a 2D transformation that
    // affects the skew of a visual along the x and y axes. The coordinate system
    // is skewed around the specified center point.
    //------------------------------------------------------------------------------

    IDCompositionSkewTransform = interface(IDCompositionTransform)
        ['{E57AA735-DCDB-4c72-9C61-0591F58889EE}']
        // Animates the value of the AngleX property.
        function SetAngleX(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the AngleX property.
        function SetAngleX(angleX: single): HResult; stdcall; overload;

        // Animates the value of the AngleY property.
        function SetAngleY(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the AngleY property.
        function SetAngleY(angleY: single): HResult; stdcall; overload;

        // Animates the value of the CenterX property.
        function SetCenterX(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the CenterX property.
        function SetCenterX(centerX: single): HResult; stdcall; overload;

        // Animates the value of the CenterY property.
        function SetCenterY(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the CenterY property.
        function SetCenterY(centerY: single): HResult; stdcall; overload;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionMatrixTransform
    // Synopsis:
    // An IDCompositionMatrixTransform interface represents an arbitrary affine
    // 2D transformation defined by a 3x2 matrix.
    //------------------------------------------------------------------------------

    IDCompositionMatrixTransform = interface(IDCompositionTransform)
        ['{16CDFF07-C503-419c-83F2-0965C7AF1FA6}']
        // Changes all values of the matrix of this transform.
        function SetMatrix(const matrix: TD2D_MATRIX_3X2_F): HResult; stdcall;

        // Animates a single element of the matrix of this transform.
        function SetMatrixElement(row: integer; column: integer; animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes a single element of the matrix of this transform.
        function SetMatrixElement(row: integer; column: integer; Value: single): HResult; stdcall; overload;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionEffectGroup
    // Synopsis:
    // An IDCompositionEffectGroup holds effects; inluding 3D transforms that can
    // be applied to a visual.
    //------------------------------------------------------------------------------

    IDCompositionEffectGroup = interface(IDCompositionEffect)
        ['{A7929A74-E6B2-4bd6-8B95-4040119CA34D}']
        // Animates the opacity property
        function SetOpacity(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the opacity property.
        function SetOpacity(opacity: single): HResult; stdcall; overload;
        // Sets the 3D transform
        function SetTransform3D(transform3D: IDCompositionTransform3D): HResult; stdcall;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionTranslateTransform3D
    // Synopsis:
    // An IDCompositionTranslateTransform3D interface represents a 3D transformation
    // that affects the offset of a visual along the x;y and z axes.

    //------------------------------------------------------------------------------

    IDCompositionTranslateTransform3D = interface(IDCompositionTransform3D)
        ['{91636D4B-9BA1-4532-AAF7-E3344994D788}']
        // Animates the value of the OffsetX property.
        function SetOffsetX(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the OffsetX property.
        function SetOffsetX(offsetX: single): HResult; stdcall; overload;

        // Animates the value of the OffsetY property.
        function SetOffsetY(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the OffsetY property.
        function SetOffsetY(offsetY: single): HResult; stdcall; overload;

        // Animates the value of the OffsetZ property.
        function SetOffsetZ(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the OffsetZ property.
        function SetOffsetZ(offsetZ: single): HResult; stdcall; overload;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionScaleTransform3D
    // Synopsis:
    // An IDCompositionScaleTransform3D interface represents a 3D transformation that
    // affects the scale of a visual along the x; y and z axes. The coordinate system
    // is scaled from the specified center point.
    //------------------------------------------------------------------------------

    IDCompositionScaleTransform3D = interface(IDCompositionTransform3D)
        ['{2A9E9EAD-364B-4b15-A7C4-A1997F78B389}']
        // Animates the value of the ScaleX property.
        function SetScaleX(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the ScaleX property.
        function SetScaleX(scaleX: single): HResult; stdcall; overload;

        // Animates the value of the ScaleY property.
        function SetScaleY(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the ScaleY property.
        function SetScaleY(scaleY: single): HResult; stdcall; overload;

        // Animates the value of the ScaleZ property.
        function SetScaleZ(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the ScaleZ property.
        function SetScaleZ(scaleZ: single): HResult; stdcall; overload;


        // Animates the value of the CenterX property.
        function SetCenterX(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the CenterX property.
        function SetCenterX(centerX: single): HResult; stdcall; overload;

        // Animates the value of the CenterY property.
        function SetCenterY(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the CenterY property.
        function SetCenterY(centerY: single): HResult; stdcall; overload;

        // Animates the value of the CenterZ property.
        function SetCenterZ(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the CenterZ property.
        function SetCenterZ(centerZ: single): HResult; stdcall; overload;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionRotateTransform3D
    // Synopsis:
    // An IDCompositionRotateTransform3D interface represents a 3D transformation
    // that affects the rotation of a visual along the specified axis at the
    // specified center point.
    //------------------------------------------------------------------------------


    IDCompositionRotateTransform3D = interface(IDCompositionTransform3D)
        ['{D8F5B23F-D429-4a91-B55A-D2F45FD75B18}']
        // Animates the value of the Angle property.
        function SetAngle(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the Angle property.
        function SetAngle(angle: single): HResult; stdcall; overload;

        // Animates the value of the AxisX property.
        function SetAxisX(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the AxisX property.
        function SetAxisX(axisX: single): HResult; stdcall; overload;

        // Animates the value of the AxisY property.
        function SetAxisY(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the AxisY property.
        function SetAxisY(axisY: single): HResult; stdcall; overload;

        // Animates the value of the AxisZ property.
        function SetAxisZ(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the AxisZ property.
        function SetAxisZ(axisZ: single): HResult; stdcall; overload;

        // Animates the value of the CenterX property.
        function SetCenterX(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the CenterX property.
        function SetCenterX(centerX: single): HResult; stdcall; overload;

        // Animates the value of the CenterY property.
        function SetCenterY(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the CenterY property.
        function SetCenterY(centerY: single): HResult; stdcall; overload;

        // Animates the value of the CenterZ property.
        function SetCenterZ(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the CenterZ property.
        function SetCenterZ(centerZ: single): HResult; stdcall; overload;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionMatrixTransform3D
    // Synopsis:
    // An IDCompositionMatrixTransform3D interface represents an arbitrary
    // 3D transformation defined by a 4x4 matrix.
    //------------------------------------------------------------------------------


    IDCompositionMatrixTransform3D = interface(IDCompositionTransform3D)
        ['{4B3363F0-643B-41b7-B6E0-CCF22D34467C}']
        // Changes all values of the matrix of this transform.
        function SetMatrix(const matrix: TD3DMATRIX): HResult; stdcall;

        // Animates a single element of the matrix of this transform.
        function SetMatrixElement(row: integer; column: integer; animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes a single element of the matrix of this transform.
        function SetMatrixElement(row: integer; column: integer; Value: single): HResult; stdcall; overload;
    end;


    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionClip
    // Synopsis:
    // An IDCompositionClip interface represents a rectangle that restricts the
    // rasterization of a visual subtree.
    //------------------------------------------------------------------------------

    IDCompositionClip = interface(IUnknown)
        ['{64AC3703-9D3F-45ec-A109-7CAC0E7A13A7}']
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionRectangleClip
    // Synopsis:
    // An IDCompositionRectangleClip interface represents a rectangle that restricts
    // the rasterization of a visual subtree.
    //------------------------------------------------------------------------------


    IDCompositionRectangleClip = interface(IDCompositionClip)
        ['{9842AD7D-D9CF-4908-AED7-48B51DA5E7C2}']
        // Animates the value of the Left property.
        function SetLeft(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the Left property.
        function SetLeft(left: single): HResult; stdcall; overload;

        // Animates the value of the Top property.
        function SetTop(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the Top property.
        function SetTop(top: single): HResult; stdcall; overload;

        // Animates the value of the Right property.
        function SetRight(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the Right property.
        function SetRight(right: single): HResult; stdcall; overload;

        // Animates the value of the Bottom property.
        function SetBottom(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the Bottom property.
        function SetBottom(bottom: single): HResult; stdcall; overload;

        // Animates the value of the x radius of the ellipse that rounds the
        // top-left corner of the clip.
        function SetTopLeftRadiusX(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the x radius of the ellipse that rounds the
        // top-left corner of the clip.
        function SetTopLeftRadiusX(radius: single): HResult; stdcall; overload;

        // Animates the value of the y radius of the ellipse that rounds the
        // top-left corner of the clip.
        function SetTopLeftRadiusY(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the y radius of the ellipse that rounds the
        // top-left corner of the clip.
        function SetTopLeftRadiusY(radius: single): HResult; stdcall; overload;

        // Animates the value of the x radius of the ellipse that rounds the
        // top-right corner of the clip.
        function SetTopRightRadiusX(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the x radius of the ellipse that rounds the
        // top-right corner of the clip.
        function SetTopRightRadiusX(radius: single): HResult; stdcall; overload;

        // Animates the value of the y radius of the ellipse that rounds the
        // top-right corner of the clip.
        function SetTopRightRadiusY(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the y radius of the ellipse that rounds the
        // top-right corner of the clip.
        function SetTopRightRadiusY(radius: single): HResult; stdcall; overload;

        // Animates the value of the x radius of the ellipse that rounds the
        // bottom-left corner of the clip.
        function SetBottomLeftRadiusX(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the x radius of the ellipse that rounds the
        // bottom-left corner of the clip.
        function SetBottomLeftRadiusX(radius: single): HResult; stdcall; overload;

        // Animates the value of the y radius of the ellipse that rounds the
        // bottom-left corner of the clip.
        function SetBottomLeftRadiusY(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the y radius of the ellipse that rounds the
        // bottom-left corner of the clip.
        function SetBottomLeftRadiusY(radius: single): HResult; stdcall; overload;

        // Animates the value of the x radius of the ellipse that rounds the
        // bottom-right corner of the clip.
        function SetBottomRightRadiusX(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the x radius of the ellipse that rounds the
        // bottom-right corner of the clip.
        function SetBottomRightRadiusX(radius: single): HResult; stdcall; overload;

        // Animates the value of the y radius of the ellipse that rounds the
        // bottom-right corner of the clip.
        function SetBottomRightRadiusY(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the y radius of the ellipse that rounds the
        // bottom-right corner of the clip.
        function SetBottomRightRadiusY(radius: single): HResult; stdcall; overload;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionSurface
    // Synopsis:
    // An IDCompositionSurface interface represents a wrapper around a DirectX
    // object; or a sub-rectangle of one of those objects.
    //------------------------------------------------------------------------------

    PIDCompositionSurface = ^IDCompositionSurface;

    IDCompositionSurface = interface(IUnknown)
        ['{BB8A4953-2C99-4F5A-96F5-4819027FA3AC}']
        function BeginDraw(const updateRect: PRECT; const iid: TGUID; out updateObject; out updateOffset: TPOINT): HResult; stdcall;
        function EndDraw(): HResult; stdcall;
        function SuspendDraw(): HResult; stdcall;
        function ResumeDraw(): HResult; stdcall;
        function Scroll(const scrollRect: PRECT; const clipRect: PRECT; offsetX: integer; offsetY: integer): HResult; stdcall;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionVirtualSurface
    // Synopsis:
    // An IDCompositionVirtualSurface interface represents a sparsely
    // allocated surface.
    //------------------------------------------------------------------------------

    IDCompositionVirtualSurface = interface(IDCompositionSurface)
        ['{AE471C51-5F53-4A24-8D3E-D0C39C30B3F0}']
        function Resize(Width: UINT; Height: UINT): HResult; stdcall;
        function Trim(const rectangles: PRECT; Count: UINT): HResult; stdcall;
    end;

    // {$IF  (_WIN32_WINNT >= _WIN32_WINNT_WINBLUE) }
    IDCompositionDevice2 = interface;
    IDCompositionDeviceDebug = interface;
    IDCompositionDesktopDevice = interface;
    IDCompositionVisual2 = interface;
    IDCompositionVisualDebug = interface;
    IDCompositionSurfaceFactory = interface;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionDevice2
    // Synopsis:
    // Serves as the root factory for all other DirectComposition2 objects and
    // controls transactional composition.
    //------------------------------------------------------------------------------

    IDCompositionDevice2 = interface(IUnknown)
        ['{75F6468D-1B8E-447C-9BC6-75FEA80B5B25}']
        // Commits all DirectComposition commands pending on this device.
        function Commit(): HResult; stdcall;
        // Waits for the last Commit to be processed by the composition engine
        function WaitForCommitCompletion(): HResult; stdcall;
        // Gets timing information about the composition engine.
        function GetFrameStatistics(out statistics: TDCOMPOSITION_FRAME_STATISTICS): HResult; stdcall;
        // Creates a new visual object.
        function CreateVisual(out visual: IDCompositionVisual2): HResult; stdcall;
        // Creates a factory for surface objects
        function CreateSurfaceFactory(renderingDevice: IUnknown; out surfaceFactory: IDCompositionSurfaceFactory): HResult; stdcall;
        // Creates a DirectComposition surface object
        function CreateSurface(Width: UINT; Height: UINT; pixelFormat: TDXGI_FORMAT; alphaMode: TDXGI_ALPHA_MODE;
            out surface: IDCompositionSurface): HResult; stdcall;
        // Creates a DirectComposition virtual surface object
        function CreateVirtualSurface(initialWidth: UINT; initialHeight: UINT; pixelFormat: TDXGI_FORMAT; alphaMode: TDXGI_ALPHA_MODE;
            out virtualSurface: IDCompositionVirtualSurface): HResult; stdcall;
        // Creates a 2D translation transform object.
        function CreateTranslateTransform(out translateTransform: IDCompositionTranslateTransform): HResult; stdcall;
        // Creates a 2D scale transform object.
        function CreateScaleTransform(out scaleTransform: IDCompositionScaleTransform): HResult; stdcall;
        // Creates a 2D rotation transform object.
        function CreateRotateTransform(out rotateTransform: IDCompositionRotateTransform): HResult; stdcall;
        // Creates a 2D skew transform object.
        function CreateSkewTransform(out skewTransform: IDCompositionSkewTransform): HResult; stdcall;
        // Creates a 2D 3x2 matrix transform object.
        function CreateMatrixTransform(out matrixTransform: IDCompositionMatrixTransform): HResult; stdcall;
        // Creates a 2D transform object that holds an array of 2D transform objects.
        function CreateTransformGroup(transforms: PIDCompositionTransform; elements: UINT; out transformGroup: IDCompositionTransform): HResult; stdcall;
        // Creates a 3D translation transform object.
        function CreateTranslateTransform3D(out translateTransform3D: IDCompositionTranslateTransform3D): HResult; stdcall;
        // Creates a 3D scale transform object.
        function CreateScaleTransform3D(out scaleTransform3D: IDCompositionScaleTransform3D): HResult; stdcall;
        // Creates a 3D rotation transform object.
        function CreateRotateTransform3D(out rotateTransform3D: IDCompositionRotateTransform3D): HResult; stdcall;
        // Creates a 3D 4x4 matrix transform object.
        function CreateMatrixTransform3D(out matrixTransform3D: IDCompositionMatrixTransform3D): HResult; stdcall;
        // Creates a 3D transform object that holds an array of 3D transform objects.
        function CreateTransform3DGroup(transforms3D: PIDCompositionTransform3D; elements: UINT;
            out transform3DGroup: IDCompositionTransform3D): HResult; stdcall;
        // Creates an effect group
        function CreateEffectGroup(out effectGroup: IDCompositionEffectGroup): HResult; stdcall;
        // Creates a clip object that can be used to clip the contents of a visual subtree.
        function CreateRectangleClip(out clip: IDCompositionRectangleClip): HResult; stdcall;
        // Creates an animation object
        function CreateAnimation(out animation: IDCompositionAnimation): HResult; stdcall;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionDesktopDevice
    // Synopsis:
    // Serves as the root factory for all other desktop DirectComposition
    // objects.
    //------------------------------------------------------------------------------

    IDCompositionDesktopDevice = interface(IDCompositionDevice2)
        ['{5F4633FE-1E08-4CB8-8C75-CE24333F5602}']
        function CreateTargetForHwnd(hwnd: HWND; topmost: boolean; out target: IDCompositionTarget): HResult; stdcall;
        // Creates a surface wrapper around a pre-existing surface that can be associated with one or more visuals for composition.
        function CreateSurfaceFromHandle(handle: THANDLE; out surface: IUnknown): HResult; stdcall;
        // Creates a wrapper object that represents the rasterization of a layered window and which can be associated with a visual for composition.
        function CreateSurfaceFromHwnd(hwnd: HWND; out surface: IUnknown): HResult; stdcall;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionDeviceDebug
    // Synopsis:
    // IDCompositionDeviceDebug serves as a debug interface
    //------------------------------------------------------------------------------

    IDCompositionDeviceDebug = interface(IUnknown)
        ['{A1A3C64A-224F-4A81-9773-4F03A89D3C6C}']
        // Enables debug counters
        function EnableDebugCounters(): HResult; stdcall;
        // Enables debug counters
        function DisableDebugCounters(): HResult; stdcall;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionSurfaceFactory
    // Synopsis:
    // An IDCompositionSurfaceFactory interface represents an object that can
    // create surfaces suitable for composition.
    //------------------------------------------------------------------------------


    IDCompositionSurfaceFactory = interface(IUnknown)
        ['{E334BC12-3937-4E02-85EB-FCF4EB30D2C8}']
        // Creates a DirectComposition surface object
        function CreateSurface(Width: UINT; Height: UINT; pixelFormat: TDXGI_FORMAT; alphaMode: TDXGI_ALPHA_MODE;
            out surface: IDCompositionSurface): HResult; stdcall;
        // Creates a DirectComposition virtual surface object
        function CreateVirtualSurface(initialWidth: UINT; initialHeight: UINT; pixelFormat: TDXGI_FORMAT; alphaMode: TDXGI_ALPHA_MODE;
            out virtualSurface: IDCompositionVirtualSurface): HResult; stdcall;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionVisual2
    // Synopsis:
    // An IDCompositionVisual2 interface represents a visual that participates in
    // a visual tree.
    //------------------------------------------------------------------------------


    IDCompositionVisual2 = interface(IDCompositionVisual)
        ['{E8DE1639-4331-4B26-BC5F-6A321D347A85}']
        // Changes the interpretation of the opacity property of an effect group
        // associated with this visual
        function SetOpacityMode(mode: TDCOMPOSITION_OPACITY_MODE): HResult; stdcall;
        // Sets back face visibility
        function SetBackFaceVisibility(visibility: TDCOMPOSITION_BACKFACE_VISIBILITY): HResult; stdcall;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionVisualDebug
    // Synopsis:
    // An IDCompositionVisualDebug interface represents a debug visual
    //------------------------------------------------------------------------------


    IDCompositionVisualDebug = interface(IDCompositionVisual2)
        ['{FED2B808-5EB4-43A0-AEA3-35F65280F91B}']
        // Enable heat map
        function EnableHeatMap(const color: TD2D1_COLOR_F): HResult; stdcall;
        // Disable heat map
        function DisableHeatMap(): HResult; stdcall;
        // Enable redraw regions
        function EnableRedrawRegions(): HResult; stdcall;
        // Disable redraw regions
        function DisableRedrawRegions(): HResult; stdcall;
    end;
    // {$ENDIF}  // (_WIN32_WINNT >= _WIN32_WINNT_WINBLUE)

    // {$IF  (_WIN32_WINNT >= _WIN32_WINNT_WINTHRESHOLD) }
    IDCompositionDevice3 = interface;
    IDCompositionVisual3 = interface;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionVisual3
    // Synopsis:
    // An IDCompositionVisual3 interface represents a visual that participates in
    // a visual tree.
    //------------------------------------------------------------------------------

    IDCompositionVisual3 = interface(IDCompositionVisualDebug)
        ['{2775F462-B6C1-4015-B0BE-B3E7D6A4976D}']
        // Sets depth mode property associated with this visual
        function SetDepthMode(mode: TDCOMPOSITION_DEPTH_MODE): HResult; stdcall;
        // Animates the value of the OffsetZ property.
        function SetOffsetZ(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of OffsetZ property.
        function SetOffsetZ(offsetZ: single): HResult; stdcall; overload;

        // Animates the value of the Opacity property.
        function SetOpacity(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the value of the Opacity property.
        function SetOpacity(opacity: single): HResult; stdcall; overload;

        // Sets the transformation object that modifies the coordinate system of this visual.
        function SetTransform(transform: IDCompositionTransform3D): HResult; stdcall; overload;
        // Sets the matrix that modifies the coordinate system of this visual.
        function SetTransform(const matrix: TD2D_MATRIX_4X4_F): HResult; stdcall; overload;

        // Changes the value of the Visible property
        function SetVisible(Visible: boolean): HResult; stdcall;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionDevice3
    // Synopsis:
    // Serves as the root factory for all other DirectComposition3 objects and
    // controls transactional composition.
    //------------------------------------------------------------------------------

    IDCompositionDevice3 = interface(IDCompositionDevice2)
        ['{0987CB06-F916-48BF-8D35-CE7641781BD9}']
        // Effect creation calls; each creates an interface around a D2D1Effect
        function CreateGaussianBlurEffect(out gaussianBlurEffect: IDCompositionGaussianBlurEffect): HResult; stdcall;
        function CreateBrightnessEffect(out brightnessEffect: IDCompositionBrightnessEffect): HResult; stdcall;
        function CreateColorMatrixEffect(out colorMatrixEffect: IDCompositionColorMatrixEffect): HResult; stdcall;
        function CreateShadowEffect(out shadowEffect: IDCompositionShadowEffect): HResult; stdcall;
        function CreateHueRotationEffect(out hueRotationEffect: IDCompositionHueRotationEffect): HResult; stdcall;
        function CreateSaturationEffect(out saturationEffect: IDCompositionSaturationEffect): HResult; stdcall;
        function CreateTurbulenceEffect(out turbulenceEffect: IDCompositionTurbulenceEffect): HResult; stdcall;
        function CreateLinearTransferEffect(out linearTransferEffect: IDCompositionLinearTransferEffect): HResult; stdcall;
        function CreateTableTransferEffect(out tableTransferEffect: IDCompositionTableTransferEffect): HResult; stdcall;
        function CreateCompositeEffect(out compositeEffect: IDCompositionCompositeEffect): HResult; stdcall;
        function CreateBlendEffect(out blendEffect: IDCompositionBlendEffect): HResult; stdcall;
        function CreateArithmeticCompositeEffect(out arithmeticCompositeEffect: IDCompositionArithmeticCompositeEffect): HResult; stdcall;
        function CreateAffineTransform2DEffect(out affineTransform2dEffect: IDCompositionAffineTransform2DEffect): HResult; stdcall;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionFilterEffect
    // Synopsis:
    // An IDCompositionFilterEffect interface represents a filter effect
    //------------------------------------------------------------------------------

    IDCompositionFilterEffect = interface(IDCompositionEffect)
        ['{30C421D5-8CB2-4E9F-B133-37BE270D4AC2}']
        // Sets the input at the given index to the filterEffect (NULL will use source visual; unless flagged otherwise)
        function SetInput(index: UINT; input: IUnknown; flags: UINT): HResult; stdcall;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionGaussianBlurEffect
    // Synopsis:
    // An IDCompositionGaussianBlurEffect interface represents a gaussian blur filter effect
    //------------------------------------------------------------------------------

    IDCompositionGaussianBlurEffect = interface(IDCompositionFilterEffect)
        ['{45D4D0B7-1BD4-454E-8894-2BFA68443033}']
        // Changes the amount of blur to be applied.
        function SetStandardDeviation(animation: IDCompositionAnimation): HResult; stdcall; overload;

        function SetStandardDeviation(amount: single): HResult; stdcall; overload;
        // Changes border mode (see D2D1_GAUSSIANBLUR)
        function SetBorderMode(mode: TD2D1_BORDER_MODE): HResult; stdcall;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionBrightnessEffect
    // Synopsis:
    // An IDCompositionBrightnessEffect interface represents a brightness filter effect
    //------------------------------------------------------------------------------

    IDCompositionBrightnessEffect = interface(IDCompositionFilterEffect)
        ['{6027496E-CB3A-49AB-934F-D798DA4F7DA6}']
        // Changes the value of white point property.
        function SetWhitePoint(const whitePoint: TD2D1_VECTOR_2F): HResult; stdcall;
        // Changes the value of black point property
        function SetBlackPoint(const blackPoint: TD2D1_VECTOR_2F): HResult; stdcall;
        // Changes the X value of the white point property.
        function SetWhitePointX(whitePointX: single): HResult; stdcall; overload;
        function SetWhitePointX(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the Y value of the white point property.
        function SetWhitePointY(whitePointY: single): HResult; stdcall; overload;
        function SetWhitePointY(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the X value of the black point property.
        function SetBlackPointX(blackPointX: single): HResult; stdcall; overload;
        function SetBlackPointX(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the Y value of the black point property.
        function SetBlackPointY(blackPointY: single): HResult; stdcall; overload;
        function SetBlackPointY(animation: IDCompositionAnimation): HResult; stdcall; overload;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionColorMatrixEffect
    // Synopsis:
    // An IDCompositionColorMatrixEffect interface represents a color matrix filter effect
    //------------------------------------------------------------------------------

    IDCompositionColorMatrixEffect = interface(IDCompositionFilterEffect)
        ['{C1170A22-3CE2-4966-90D4-55408BFC84C4}']
        // Changes all values of the matrix for a color transform
        function SetMatrix(const matrix: TD2D1_MATRIX_5X4_F): HResult; stdcall;
        // Changes a single element of the matrix of this color transform.
        function SetMatrixElement(row: integer; column: integer; Value: single): HResult; stdcall; overload;
        // Animates a single element of the matrix of this color transform.
        function SetMatrixElement(row: integer; column: integer; animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes the alpha mode
        function SetAlphaMode(mode: TD2D1_COLORMATRIX_ALPHA_MODE): HResult; stdcall;
        // Sets the clamp output property
        function SetClampOutput(clamp: boolean): HResult; stdcall;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionShadowEffect
    // Synopsis:
    // An IDCompositionShadowEffect interface represents a shadow filter effect
    //------------------------------------------------------------------------------

    IDCompositionShadowEffect = interface(IDCompositionFilterEffect)
        ['{4AD18AC0-CFD2-4C2F-BB62-96E54FDB6879}']
        // Changes the amount of blur to be applied.
        function SetStandardDeviation(amount: single): HResult; stdcall; overload;
        function SetStandardDeviation(animation: IDCompositionAnimation): HResult; stdcall; overload;
        // Changes shadow color
        function SetColor(const color: TD2D1_VECTOR_4F): HResult; stdcall;
        function SetRed(amount: single): HResult; stdcall; overload;
        function SetRed(animation: IDCompositionAnimation): HResult; stdcall; overload;
        function SetGreen(amount: single): HResult; stdcall; overload;
        function SetGreen(animation: IDCompositionAnimation): HResult; stdcall; overload;
        function SetBlue(amount: single): HResult; stdcall; overload;
        function SetBlue(animation: IDCompositionAnimation): HResult; stdcall; overload;
        function SetAlpha(amount: single): HResult; stdcall; overload;
        function SetAlpha(animation: IDCompositionAnimation): HResult; stdcall; overload;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionHueRotationEffect
    // Synopsis:
    // An IDCompositionHueRotationEffect interface represents a hue rotation filter effect
    //------------------------------------------------------------------------------

    IDCompositionHueRotationEffect = interface(IDCompositionFilterEffect)
        ['{6DB9F920-0770-4781-B0C6-381912F9D167}']
        // Changes the angle of rotation
        function SetAngle(amountDegrees: single): HResult; stdcall; overload;
        function SetAngle(animation: IDCompositionAnimation): HResult; stdcall; overload;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionSaturationEffect
    // Synopsis:
    // An IDCompositionSaturationEffect interface represents a saturation filter effect
    //------------------------------------------------------------------------------

    IDCompositionSaturationEffect = interface(IDCompositionFilterEffect)
        ['{A08DEBDA-3258-4FA4-9F16-9174D3FE93B1}']
        // Changes the amount of saturation to be applied.
        function SetSaturation(ratio: single): HResult; stdcall; overload;
        function SetSaturation(animation: IDCompositionAnimation): HResult; stdcall; overload;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionTurbulenceEffect
    // Synopsis:
    // An IDCompositionTurbulenceEffect interface represents a turbulence filter effect
    //------------------------------------------------------------------------------

    IDCompositionTurbulenceEffect = interface(IDCompositionFilterEffect)
        ['{A6A55BDA-C09C-49F3-9193-A41922C89715}']
        // Changes the starting offset of the turbulence
        function SetOffset(const offset: TD2D1_VECTOR_2F): HResult; stdcall;
        // Changes the base frequency of the turbulence
        function SetBaseFrequency(const frequency: TD2D1_VECTOR_2F): HResult; stdcall;
        // Changes the output size of the turbulence
        function SetSize(const size: TD2D1_VECTOR_2F): HResult; stdcall;
        // Sets the number of octaves
        function SetNumOctaves(numOctaves: UINT): HResult; stdcall;
        // Set the random number seed
        function SetSeed(seed: UINT): HResult; stdcall;
        // Set the noise mode
        function SetNoise(noise: TD2D1_TURBULENCE_NOISE): HResult; stdcall;
        // Set stitchable
        function SetStitchable(stitchable: boolean): HResult; stdcall;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionLinearTransferEffect
    // Synopsis:
    // An IDCompositionLinearTransferEffect interface represents a linear transfer filter effect
    //------------------------------------------------------------------------------

    IDCompositionLinearTransferEffect = interface(IDCompositionFilterEffect)
        ['{4305EE5B-C4A0-4C88-9385-67124E017683}']
        function SetRedYIntercept(redYIntercept: single): HResult; stdcall; overload;
        function SetRedYIntercept(animation: IDCompositionAnimation): HResult; stdcall; overload;
        function SetRedSlope(redSlope: single): HResult; stdcall; overload;
        function SetRedSlope(animation: IDCompositionAnimation): HResult; stdcall; overload;
        function SetRedDisable(redDisable: boolean): HResult; stdcall;
        function SetGreenYIntercept(greenYIntercept: single): HResult; stdcall; overload;
        function SetGreenYIntercept(animation: IDCompositionAnimation): HResult; stdcall; overload;
        function SetGreenSlope(greenSlope: single): HResult; stdcall; overload;
        function SetGreenSlope(animation: IDCompositionAnimation): HResult; stdcall; overload;
        function SetGreenDisable(greenDisable: boolean): HResult; stdcall;
        function SetBlueYIntercept(blueYIntercept: single): HResult; stdcall; overload;
        function SetBlueYIntercept(animation: IDCompositionAnimation): HResult; stdcall; overload;
        function SetBlueSlope(blueSlope: single): HResult; stdcall; overload;
        function SetBlueSlope(animation: IDCompositionAnimation): HResult; stdcall; overload;
        function SetBlueDisable(blueDisable: boolean): HResult; stdcall;
        function SetAlphaYIntercept(alphaYIntercept: single): HResult; stdcall; overload;
        function SetAlphaYIntercept(animation: IDCompositionAnimation): HResult; stdcall; overload;
        function SetAlphaSlope(alphaSlope: single): HResult; stdcall; overload;
        function SetAlphaSlope(animation: IDCompositionAnimation): HResult; stdcall; overload;
        function SetAlphaDisable(alphaDisable: boolean): HResult; stdcall;
        function SetClampOutput(clampOutput: boolean): HResult; stdcall;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionTableTransferEffect
    // Synopsis:
    // An IDCompositionTableTransferEffect interface represents a Table transfer filter effect
    //------------------------------------------------------------------------------


    IDCompositionTableTransferEffect = interface(IDCompositionFilterEffect)
        ['{9B7E82E2-69C5-4EB4-A5F5-A7033F5132CD}']
        function SetRedTable(const tableValues{count}: Psingle; Count: UINT): HResult; stdcall;
        function SetGreenTable(const tableValues{count}: Psingle; Count: UINT): HResult; stdcall;
        function SetBlueTable(const tableValues{count}: Psingle; Count: UINT): HResult; stdcall;
        function SetAlphaTable(const tableValues{count}: Psingle; Count: UINT): HResult; stdcall;
        function SetRedDisable(redDisable: boolean): HResult; stdcall;
        function SetGreenDisable(greenDisable: boolean): HResult; stdcall;
        function SetBlueDisable(blueDisable: boolean): HResult; stdcall;
        function SetAlphaDisable(alphaDisable: boolean): HResult; stdcall;
        function SetClampOutput(clampOutput: boolean): HResult; stdcall;
        // Note: To set individual values; the table must have already been initialized
        // with a buffer of values of the appropriate size; or these calls will fail
        function SetRedTableValue(index: UINT; Value: single): HResult; stdcall; overload;
        function SetRedTableValue(index: UINT; animation: IDCompositionAnimation): HResult; stdcall; overload;
        function SetGreenTableValue(index: UINT; Value: single): HResult; stdcall; overload;
        function SetGreenTableValue(index: UINT; animation: IDCompositionAnimation): HResult; stdcall; overload;
        function SetBlueTableValue(index: UINT; Value: single): HResult; stdcall; overload;
        function SetBlueTableValue(index: UINT; animation: IDCompositionAnimation): HResult; stdcall; overload;
        function SetAlphaTableValue(index: UINT; Value: single): HResult; stdcall; overload;
        function SetAlphaTableValue(index: UINT; animation: IDCompositionAnimation): HResult; stdcall; overload;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionCompositeEffect
    // Synopsis:
    // An IDCompositionCompositeEffect interface represents a composite filter effect
    //------------------------------------------------------------------------------

    IDCompositionCompositeEffect = interface(IDCompositionFilterEffect)
        ['{576616C0-A231-494D-A38D-00FD5EC4DB46}']
        // Changes the composite mode.
        function SetMode(mode: TD2D1_COMPOSITE_MODE): HResult; stdcall;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionBlendEffect
    // Synopsis:
    // An IDCompositionBlendEffect interface represents a blend filter effect
    //------------------------------------------------------------------------------


    IDCompositionBlendEffect = interface(IDCompositionFilterEffect)
        ['{33ECDC0A-578A-4A11-9C14-0CB90517F9C5}']
        function SetMode(mode: TD2D1_BLEND_MODE): HResult; stdcall;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionArithmeticCompositeEffect
    // Synopsis:
    // An IDCompositionArithmeticCompositeEffect interface represents an arithmetic composite filter effect
    //------------------------------------------------------------------------------
    IDCompositionArithmeticCompositeEffect = interface(IDCompositionFilterEffect)
        ['{3B67DFA8-E3DD-4E61-B640-46C2F3D739DC}']
        function SetCoefficients(const coefficients: TD2D1_VECTOR_4F): HResult; stdcall;
        function SetClampOutput(clampoutput: boolean): HResult; stdcall;
        function SetCoefficient1(Coeffcient1: single): HResult; stdcall; overload;
        function SetCoefficient1(animation: IDCompositionAnimation): HResult; stdcall; overload;
        function SetCoefficient2(Coefficient2: single): HResult; stdcall; overload;
        function SetCoefficient2(animation: IDCompositionAnimation): HResult; stdcall; overload;
        function SetCoefficient3(Coefficient3: single): HResult; stdcall; overload;
        function SetCoefficient3(animation: IDCompositionAnimation): HResult; stdcall; overload;
        function SetCoefficient4(Coefficient4: single): HResult; stdcall; overload;
        function SetCoefficient4(animation: IDCompositionAnimation): HResult; stdcall; overload;
    end;

    //+-----------------------------------------------------------------------------
    // Interface:
    // IDCompositionAffineTransform2DEffect
    // Synopsis:
    // An IDCompositionAffineTransform2DEffect interface represents a affine transform 2D filter effect
    //------------------------------------------------------------------------------

    IDCompositionAffineTransform2DEffect = interface(IDCompositionFilterEffect)
        ['{0B74B9E8-CDD6-492F-BBBC-5ED32157026D}']
        function SetInterpolationMode(interpolationMode: TD2D1_2DAFFINETRANSFORM_INTERPOLATION_MODE): HResult; stdcall;
        function SetBorderMode(borderMode: TD2D1_BORDER_MODE): HResult; stdcall;
        function SetTransformMatrix(const transformMatrix: TD2D1_MATRIX_3X2_F): HResult; stdcall;
        function SetTransformMatrixElement(row: integer; column: integer; Value: single): HResult; stdcall; overload;
        function SetTransformMatrixElement(row: integer; column: integer; animation: IDCompositionAnimation): HResult; stdcall; overload;
        function SetSharpness(sharpness: single): HResult; stdcall; overload;
        function SetSharpness(animation: IDCompositionAnimation): HResult; stdcall; overload;
    end;

// {$ENDIF}  // (_WIN32_WINNT >= _WIN32_WINNT_WINTHRESHOLD)


//+-----------------------------------------------------------------------------
// Function:
// DCompositionCreateDevice
// Synopsis:
// Creates a new DirectComposition device object; which can be used to create
// other DirectComposition objects.
//------------------------------------------------------------------------------
function DCompositionCreateDevice(dxgiDevice: IDXGIDevice; const iid: TGUID; out dcompositionDevice): HResult; stdcall; external DComp_DLL;

// {$IF  (_WIN32_WINNT >= _WIN32_WINNT_WINBLUE) }
//+-----------------------------------------------------------------------------
// Function:
// DCompositionCreateDevice2
// Synopsis:
// Creates a new DirectComposition device object; which can be used to create
// other DirectComposition objects.
//------------------------------------------------------------------------------
function DCompositionCreateDevice2(renderingDevice: IUnknown; const iid: TGUID; out dcompositionDevice): HResult; stdcall; external DComp_DLL;
// {$ENDIF}// (_WIN32_WINNT >= _WIN32_WINNT_WINBLUE)

// {$IF  (_WIN32_WINNT >= _WIN32_WINNT_WINTHRESHOLD) }
//+-----------------------------------------------------------------------------
// Function:
// DCompositionCreateDevice3
// Synopsis:
// Creates a new DirectComposition device object; which can be used to create
// other DirectComposition objects.
//------------------------------------------------------------------------------
function DCompositionCreateDevice3(renderingDevice: IUnknown; const iid: TGUID; out dcompositionDevice): HResult; stdcall; external DComp_DLL;

// {$ENDIF}// (_WIN32_WINNT >= _WIN32_WINNT_WINTHRESHOLD)

//+-----------------------------------------------------------------------------
// Function:
// DCompositionCreateSurfaceHandle
// Synopsis:
// Creates a new composition surface object; which can be bound to a
// DirectX swap chain or swap buffer or to a GDI bitmap and associated
// with a visual.
//------------------------------------------------------------------------------
function DCompositionCreateSurfaceHandle(desiredAccess: DWORD; securityAttributes: PSECURITY_ATTRIBUTES; out surfaceHandle: THANDLE): HResult;
    stdcall; external DComp_DLL;

//+-----------------------------------------------------------------------------
// Function:
// DCompositionAttachMouseWheelToHwnd
// Synopsis:
// Creates an Interaction/InputSink to route mouse wheel messages to the
// given HWND. After calling this API; the device owning the visual must
// be committed.
//------------------------------------------------------------------------------
function DCompositionAttachMouseWheelToHwnd(visual: IDCompositionVisual; hwnd: HWND; enable: boolean): HResult; stdcall; external DComp_DLL;

//+-----------------------------------------------------------------------------
// Function:
// DCompositionAttachMouseDragToHwnd
// Synopsis:
// Creates an Interaction/InputSink to route mouse button down and any
// subsequent move and up events to the given HWND. There is no move
// thresholding; when enabled; all events including and following the down
// are unconditionally redirected to the specified window. After calling this
// API; the device owning the visual must be committed.
//------------------------------------------------------------------------------
function DCompositionAttachMouseDragToHwnd(visual: IDCompositionVisual; hwnd: HWND; enable: boolean): HResult; stdcall; external DComp_DLL;

// {$ENDIF} // NTDDI_WIN8

implementation

end.
 
