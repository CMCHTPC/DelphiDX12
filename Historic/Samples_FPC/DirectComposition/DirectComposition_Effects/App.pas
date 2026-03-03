// THIS CODE AND INFORMATION IS PROVIDED 'AS IS' WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.

// Copyright (c) Microsoft Corporation. All rights reserved

// Translated to Pascal by Norbert Sonnleitner (c) 2018

unit App;

{$mode delphi}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D11,
    DX12.DXGI,
    DX12.DXGI1_2,
    DX12.D2D1,
    DX12.D3DCommon,
    DX12.DCommon,
    DX12.DCompAnimation,
    DX12.D3D9Types,
    DX12.DComp;

const
    IDS_FONT_TYPEFACE = 101;
    IDS_FONT_HEIGHT_LOGO = 102;
    IDS_FONT_HEIGHT_TITLE = 103;
    IDS_FONT_HEIGHT_DESCRIPTION = 104;

type

    TVIEW_STATE = (
        vsZOOMEDOUT = 0,
        vsZOOMEDIN
        );
    TACTION_TYPE = (
        atZOOMOUT = 0,
        atZOOMIN
        );


    { TApplication }

    TApplication = class
    public
        constructor Create;
        destructor Destroy; override;
        function Run(): integer;
    private
        function BeforeEnteringMessageLoop(): HRESULT;
        function EnterMessageLoop(): integer;
        procedure AfterLeavingMessageLoop();

        function CreateApplicationWindow(): HRESULT;
        function ShowApplicationWindow(): boolean;
        procedure DestroyApplicationWindow();

        function CreateD2D1Factory(): HRESULT;
        procedure DestroyD2D1Factory();

        function CreateD2D1Device(): HRESULT;
        procedure DestroyD2D1Device();

        function CreateD3D11Device(): HRESULT;
        procedure DestroyD3D11Device();

        function CreateDCompositionDevice(): HRESULT;
        procedure DestroyDCompositionVisualTree();

        function CreateDCompositionVisualTree(): HRESULT;
        procedure DestroyDCompositionDevice();

        function CreateSurface(size: integer; red: single; green: single; blue: single; out surface: IDCompositionSurface): HRESULT;

        function CreateTranslateTransform(offsetX: single; offsetY: single; offsetZ: single;
            out translateTransform: IDCompositionTranslateTransform3D): HRESULT; overload;
        function CreateTranslateTransform(beginOffsetX: single; beginOffsetY: single; beginOffsetZ: single; endOffsetX: single;
            endOffsetY: single; endOffsetZ: single; beginTime: single; endTime: single; out translateTransform: IDCompositionTranslateTransform3D): HRESULT;
            overload;

        function CreateScaleTransform(centerX: single; centerY: single; centerZ: single; scaleX: single; scaleY: single;
            scaleZ: single; out scaleTransform: IDCompositionScaleTransform3D): HRESULT; overload;
        function CreateScaleTransform(centerX: single; centerY: single; centerZ: single; beginScaleX: single; beginScaleY: single;
            beginScaleZ: single; endScaleX: single; endScaleY: single; endScaleZ: single; beginTime: single; endTime: single;
            out scaleTransform: IDCompositionScaleTransform3D): HRESULT; overload;

        function CreateRotateTransform(centerX: single; centerY: single; centerZ: single; axisX: single; axisY: single;
            axisZ: single; angle: single; out rotateTransform: IDCompositionRotateTransform3D): HRESULT; overload;
        function CreateRotateTransform(centerX: single; centerY: single; centerZ: single; axisX: single; axisY: single;
            axisZ: single; beginAngle: single; endAngle: single; beginTime: single; endTime: single;
            out rotateTransform: IDCompositionRotateTransform3D): HRESULT;
            overload;

        function CreatePerspectiveTransform(dx: single; dy: single; dz: single; out perspectiveTransform: IDCompositionMatrixTransform3D): HRESULT;

        function CreateLinearAnimation(beginValue: single; endValue: single; beginTime: single; endTime: single;
            out Animation: IDCompositionAnimation): HRESULT;

        function SetEffectOnVisuals(): HRESULT;
        function SetEffectOnVisualLeft(): HRESULT;
        function SetEffectOnVisualLeftChildren(): HRESULT;
        function SetEffectOnVisualRight(): HRESULT;

        function ZoomOut(): HRESULT;
        function ZoomIn(): HRESULT;

        function OnKeyDown(wParam: WPARAM): LRESULT;
        function OnLeftButton(): LRESULT;
        function OnClose(): LRESULT;
        function OnDestroy(): LRESULT;
        function OnPaint(): LRESULT;

        function UpdateVisuals(currentVisual: integer; nextVisual: integer): LRESULT;
    private
        _gridSize: integer;

        _fontTypeface: array[0..31] of WCHAR;
        _fontHeightLogo: integer;
        _fontHeightTitle: integer;
        _fontHeightDescription: integer;

        _hwnd: HWND;

        _tileSize: integer;

        _windowWidth: integer;
        _windowHeight: integer;

        _d3d11Device: ID3D11Device;
        _d3d11DeviceContext: ID3D11DeviceContext;

        _d2d1Factory: ID2D1Factory1;

        _d2d1Device: ID2D1Device;
        _d2d1DeviceContext: ID2D1DeviceContext;

        _device: IDCompositionDevice;
        _target: IDCompositionTarget;
        _visual: IDCompositionVisual;
        _visualLeft: IDCompositionVisual;
        _visualLeftChild: array[0..3] of IDCompositionVisual;
        _visualRight: IDCompositionVisual;

        _surfaceLeftChild: array[0..3] of IDCompositionSurface;

        _effectGroupLeft: IDCompositionEffectGroup;
        _effectGroupLeftChild: array[0..3] of IDCompositionEffectGroup;
        _effectGroupRight: IDCompositionEffectGroup;

        _currentVisual: integer;
        _state: TVIEW_STATE;
        _actionType: TACTION_TYPE;
    end;


var
    DCompApp: TApplication;

function WindProc(hWnd: HWND; message: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;


implementation



constructor TApplication.Create;
begin
    _gridSize := 100;

    _hwnd := 0;
    _tileSize := 3 * _gridSize;
    _windowWidth := 9 * _gridSize;
    _windowHeight := 6 * _gridSize;
    _state := vsZOOMEDOUT;
    _actionType := atZOOMOUT;
    _currentVisual := 0;
end;



destructor TApplication.Destroy;
begin
    inherited Destroy;
end;

// Runs the application

function TApplication.Run(): integer;
begin
    Result := 0;

    if (SUCCEEDED(BeforeEnteringMessageLoop())) then
    begin
        Result := EnterMessageLoop();
    end
    else
    begin
        MessageBoxW(0, 'An error occuring when running the sample', 0, MB_OK);
    end;

    AfterLeavingMessageLoop();
end;

// Creates the application window, the d3d device and DirectComposition device and visual tree
// before entering the message loop.
function TApplication.BeforeEnteringMessageLoop(): HRESULT;
begin
    Result := CreateApplicationWindow();

    if (SUCCEEDED(Result)) then
    begin
        Result := CreateD3D11Device();
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := CreateD2D1Factory();
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := CreateD2D1Device();
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := CreateDCompositionDevice();
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := CreateDCompositionVisualTree();
    end;
end;

// Message loop

function TApplication.EnterMessageLoop(): integer;
var
    msg: TMsg;
begin
    Result := 0;

    if (ShowApplicationWindow()) then
    begin
        while (GetMessage(msg, 0, 0, 0)) do
        begin
            TranslateMessage(msg);
            DispatchMessage(msg);
        end;
        Result := (msg.wParam);
    end;
end;

// Destroys the application window, DirectComposition device and visual tree.

procedure TApplication.AfterLeavingMessageLoop();
begin
    DestroyDCompositionVisualTree();
    DestroyDCompositionDevice();
    DestroyD2D1Device();
    DestroyD2D1Factory();
    DestroyD3D11Device();
    DestroyApplicationWindow();
end;

(*---Code calling DirectComposition APIs------------------------------------------------------------*)

// Creates D2D Factory
function TApplication.CreateD2D1Factory(): HRESULT;
begin
    Result := D2D1CreateFactory(D2D1_FACTORY_TYPE_SINGLE_THREADED, ID2D1Factory1, 0, _d2d1Factory);
end;

// Creates D2D Device

function TApplication.CreateD2D1Device(): HRESULT;
var
    dxgiDevice: IDXGIDevice;
begin
    Result := E_UNEXPECTED;
    if ((_d3d11Device = nil) or (_d2d1Factory = nil)) then
        Exit;
    Result := S_OK;

    if (SUCCEEDED(Result)) then
    begin
        Result := _d3d11Device.QueryInterface(IID_IDXGIDevice, dxgiDevice);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _d2d1Factory.CreateDevice(dxgiDevice, _d2d1Device);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _d2d1Device.CreateDeviceContext(D2D1_DEVICE_CONTEXT_OPTIONS_NONE, _d2d1DeviceContext);
    end;
end;

// Creates D3D device

function TApplication.CreateD3D11Device(): HRESULT;
var
    driverTypes: array[0..1] of TD3D_DRIVER_TYPE = (D3D_DRIVER_TYPE_HARDWARE, D3D_DRIVER_TYPE_WARP);
    featureLevelSupported: TD3D_FEATURE_LEVEL;
    i: integer;
    d3d11Device: ID3D11Device;
    d3d11DeviceContext: ID3D11DeviceContext;
begin
    Result := S_OK;

    for i := 0 to Length(driverTypes) - 1 do
    begin
        Result := D3D11CreateDevice(nil, driverTypes[i], 0, Ord(D3D11_CREATE_DEVICE_BGRA_SUPPORT), 0, 0, D3D11_SDK_VERSION,
            d3d11Device, featureLevelSupported, @d3d11DeviceContext);

        if (SUCCEEDED(Result)) then
        begin
            _d3d11Device := d3d11Device;
            _d3d11DeviceContext := d3d11DeviceContext;
            break;
        end;
    end;
end;

// Initializes DirectComposition

function TApplication.CreateDCompositionDevice(): HRESULT;
var
    dxgiDevice: IDXGIDevice;
begin
    Result := E_UNEXPECTED;
    if (_d3d11Device = nil) then
        Exit;
    Result := S_OK;

    if (SUCCEEDED(Result)) then
    begin
        Result := _d3d11Device.QueryInterface(IID_IDXGIDevice, dxgiDevice);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := DCompositionCreateDevice(dxgiDevice, IID_IDCompositionDevice, _device);
    end;
end;

// Creates DirectComposition visual tree

function TApplication.CreateDCompositionVisualTree(): HRESULT;
var
    surfaceLeft: IDCompositionSurface;
    i: integer;
begin
    Result := E_UNEXPECTED;
    if ((_device = nil) or (_hwnd = 0)) then
        Exit;
    Result := S_OK;

    if (SUCCEEDED(Result)) then
    begin
        Result := _device.CreateVisual(_visual);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _device.CreateVisual(_visualLeft);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := CreateSurface(_tileSize, 1.0, 0.0, 0.0, surfaceLeft);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _visualLeft.SetContent(surfaceLeft);
    end;

    i := 0;
    while ((i < 4) and SUCCEEDED(Result)) do
    begin
        if (SUCCEEDED(Result)) then
        begin
            Result := _device.CreateVisual(_visualLeftChild[i]);
        end;

        if (i = 0) then
        begin
            if (SUCCEEDED(Result)) then
            begin
                Result := CreateSurface(_tileSize, 0.0, 1.0, 0.0, _surfaceLeftChild[i]);
            end;
        end
        else if (i = 1) then
        begin
            if (SUCCEEDED(Result)) then
            begin
                Result := CreateSurface(_tileSize, 0.5, 0.0, 0.5, _surfaceLeftChild[i]);
            end;
        end
        else if (i = 2) then
        begin
            if (SUCCEEDED(Result)) then
            begin
                Result := CreateSurface(_tileSize, 0.5, 0.5, 0.0, _surfaceLeftChild[i]);
            end;
        end
        else if (i = 3) then
        begin
            if (SUCCEEDED(Result)) then
            begin
                Result := CreateSurface(_tileSize, 0.0, 0.0, 1.0, _surfaceLeftChild[i]);
            end;
        end;

        if (SUCCEEDED(Result)) then
        begin
            Result := _visualLeftChild[i].SetContent(_surfaceLeftChild[i]);
        end;
        Inc(i);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _device.CreateVisual(_visualRight);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _visualRight.SetContent(_surfaceLeftChild[_currentVisual]);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _visual.AddVisual(_visualLeft, True, nil);
    end;

    if (SUCCEEDED(Result)) then
    begin
        i := 0;
        while (i < 4) and SUCCEEDED(Result) do
        begin
            Result := _visualLeft.AddVisual(_visualLeftChild[i], False, nil);
            Inc(i);
        end;
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _visual.AddVisual(_visualRight, True, _visualLeft);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := SetEffectOnVisuals();
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _device.CreateTargetForHwnd(_hwnd, True, _target);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _target.SetRoot(_visual);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _device.Commit();
    end;
end;

// Creates surface

function TApplication.CreateSurface(size: integer; red: single; green: single; blue: single; out surface: IDCompositionSurface): HRESULT;
var
    surfaceTile: IDCompositionSurface;
    d2d1Bitmap: ID2D1Bitmap1;
    dxgiSurface: IDXGISurface;
    offset: TPOINT;
    rect: TRECT;
    dpiX: single = 0.0;
    dpiY: single = 0.0;
    bitmapProperties: TD2D1_BITMAP_PROPERTIES1;
    d2d1Brush: ID2D1SolidColorBrush;
begin
    Result := s_OK;

    if (SUCCEEDED(Result)) then
    begin
        if ((_device = nil) or (_d2d1Factory = nil) or (_d2d1DeviceContext = nil)) then
            Result := E_UNEXPECTED;
        surface := nil;
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _device.CreateSurface(size, size, DXGI_FORMAT_R8G8B8A8_UNORM, DXGI_ALPHA_MODE_IGNORE, surfaceTile);
    end;

    if (SUCCEEDED(Result)) then
    begin
        rect.Create(0, 0, size, size);
        Result := surfaceTile.BeginDraw(@rect, IID_IDXGISurface, dxgiSurface, offset);
    end;

    if (SUCCEEDED(Result)) then
    begin
        _d2d1Factory.GetDesktopDpi(dpiX, dpiY);

        bitmapProperties := DX12.D2D1.BitmapProperties1(DX12.D2D1.PixelFormat(DXGI_FORMAT_R8G8B8A8_UNORM, D2D1_ALPHA_MODE_IGNORE),
            TD2D1_BITMAP_OPTIONS(Ord(D2D1_BITMAP_OPTIONS_TARGET) or Ord(D2D1_BITMAP_OPTIONS_CANNOT_DRAW)), dpiX, dpiY);

        Result := _d2d1DeviceContext.CreateBitmapFromDxgiSurface(dxgiSurface, bitmapProperties, d2d1Bitmap);

        if (SUCCEEDED(Result)) then
        begin
            _d2d1DeviceContext.SetTarget(d2d1Bitmap);
        end;

        if (SUCCEEDED(Result)) then
        begin
            Result := _d2d1DeviceContext.CreateSolidColorBrush(DX12.D2D1.ColorF(red, green, blue), d2d1Brush);
        end;

        if (SUCCEEDED(Result)) then
        begin
            _d2d1DeviceContext.BeginDraw();

            _d2d1DeviceContext.FillRectangle(
                DX12.D2D1.RectF(offset.x + 0.0, offset.y + 0.0, offset.x + size, offset.y + size),
                d2d1Brush);

            Result := _d2d1DeviceContext.EndDraw();
        end;
        surfaceTile.EndDraw();
    end;

    if (SUCCEEDED(Result)) then
    begin
        surface := surfaceTile;
    end;
end;

// Sets effects on both the left and the right visuals.

function TApplication.SetEffectOnVisuals(): HRESULT;
begin
    Result := SetEffectOnVisualLeft();

    if (SUCCEEDED(Result)) then
    begin
        Result := SetEffectOnVisualLeftChildren();
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := SetEffectOnVisualRight();
    end;
end;

// Sets effect on the left visual.

function TApplication.SetEffectOnVisualLeft(): HRESULT;
var
    beginOffsetX, endOffsetX, offsetY: single;
    beginAngle, endAngle: single;
    translateTransform: IDCompositionTranslateTransform3D;
    rotateTransform: IDCompositionRotateTransform3D;
    transforms: array [0..2] of IDCompositionTransform3D;
    perspectiveTransform: IDCompositionMatrixTransform3D;
    transformGroup: IDCompositionTransform3D;
begin
    Result := E_UNEXPECTED;
    if (_visualLeft = nil) then
        Exit;
    Result := S_OK;

    if (_actionType = atZOOMOUT) then
    begin
        beginOffsetX := 3.0;
        endOffsetX := 0.5;
        offsetY := 1.5;

        beginAngle := 0.0;
        endAngle := 30.0;
    end
    else
    begin
        beginOffsetX := 0.5;
        endOffsetX := 3.0;
        offsetY := 1.5;

        beginAngle := 30.0;
        endAngle := 0.0;
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := CreateTranslateTransform(beginOffsetX * _gridSize, offsetY * _gridSize, 0.0, endOffsetX * _gridSize,
            offsetY * _gridSize, 0.0, 0.25, 1.25, translateTransform);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := CreateRotateTransform(3.5 * _gridSize, 1.5 * _gridSize, 0.0 * _gridSize, 0.0, 1.0, 0.0, beginAngle,
            endAngle, 0.25, 1.25, rotateTransform);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := CreatePerspectiveTransform(0.0, 0.0, -1.0 / (9.0 * _gridSize), perspectiveTransform);
    end;

    transforms[0] := translateTransform;
    transforms[1] := rotateTransform;
    transforms[2] := perspectiveTransform;

    if (SUCCEEDED(Result)) then
    begin
        Result := _device.CreateTransform3DGroup(@transforms[0], sizeof(transforms) div sizeof(transforms[0]), transformGroup);
    end;

    if (SUCCEEDED(Result)) then
    begin
        _effectGroupLeft := nil;
        Result := _device.CreateEffectGroup(_effectGroupLeft);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _effectGroupLeft.SetTransform3D(transformGroup);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _visualLeft.SetEffect(_effectGroupLeft);
    end;
end;



function TApplication.SetEffectOnVisualLeftChildren(): HRESULT;
var
    i: integer;
    r, c: integer;
    scale: IDCompositionScaleTransform3D;
    translate: IDCompositionTranslateTransform3D;
    transformGroup: IDCompositionTransform3D;
    transforms: array [0..1] of IDCompositionTransform3D;
    opacityAnimation: IDCompositionAnimation;
    beginOpacity, endOpacity: single;
begin
    Result := S_OK;

    i := 0;
    while (i < 4) and SUCCEEDED(Result) do
    begin
        r := i div 2;
        c := i mod 2;

        if (SUCCEEDED(Result)) then
        begin
            Result := CreateScaleTransform(0.0, 0.0, 0.0, 1.0 / 3.0, 1.0 / 3.0, 1.0, scale);
        end;

        if (SUCCEEDED(Result)) then
        begin
            Result := CreateTranslateTransform((0.25 + c * 1.5) * _gridSize, (0.25 + r * 1.5) * _gridSize, 0.0, translate);
        end;

        transforms[0] := scale;
        transforms[1] := translate;

        if (SUCCEEDED(Result)) then
        begin
            Result := _device.CreateTransform3DGroup(@transforms[0], sizeof(transforms) div sizeof(transforms[0]), transformGroup);
        end;

        if (SUCCEEDED(Result)) then
        begin
            _effectGroupLeftChild[i] := nil;
            Result := _device.CreateEffectGroup(_effectGroupLeftChild[i]);
        end;

        if (SUCCEEDED(Result)) then
        begin
            Result := _effectGroupLeftChild[i].SetTransform3D(transformGroup);
        end;

        if (SUCCEEDED(Result) and (i = _currentVisual)) then
        begin
            if (_actionType = atZOOMOUT) then
            begin
                beginOpacity := 1.0;
                endOpacity := 0.0;
            end
            else
            begin
                beginOpacity := 0.0;
                endOpacity := 1.0;
            end;

            Result := CreateLinearAnimation(beginOpacity, endOpacity, 0.25, 1.25, opacityAnimation);

            if (SUCCEEDED(Result)) then
            begin
                Result := _effectGroupLeftChild[i].SetOpacity(opacityAnimation);
            end;
        end;

        if (SUCCEEDED(Result)) then
        begin
            Result := _visualLeftChild[i].SetEffect(_effectGroupLeftChild[i]);
        end;

        Inc(i);
    end;
end;

// Sets effect on the right visual

function TApplication.SetEffectOnVisualRight(): HRESULT;
var
    beginOffsetX: single;
    endOffsetX: single;
    offsetY: single;
    translateTransform: IDCompositionTranslateTransform3D;
    transforms: array [0..0] of IDCompositionTransform3D;
    transformGroup: IDCompositionTransform3D;
    opacityAnimation: IDCompositionAnimation;
    beginOpacity, endOpacity: single;
begin
    Result := E_UNEXPECTED;
    if (_visualRight = nil) then
        Exit;
    Result := S_OK;

    if (_actionType = atZOOMOUT) then
    begin
        beginOffsetX := 6.5;
        endOffsetX := 3.75;
    end
    else
    begin
        beginOffsetX := 3.75;
        endOffsetX := 6.5;
    end;
    offsetY := 1.5;

    if (SUCCEEDED(Result)) then
    begin
        Result := CreateTranslateTransform(beginOffsetX * _gridSize, offsetY * _gridSize, 0.0, endOffsetX * _gridSize,
            offsetY * _gridSize, 0.0, 0.25, 1.25, translateTransform);
    end;

    transforms[0] := translateTransform;

    if (SUCCEEDED(Result)) then
    begin
        Result := _device.CreateTransform3DGroup(@transforms[0], Length(transforms), transformGroup);
    end;

    if (SUCCEEDED(Result)) then
    begin
        _effectGroupRight := nil;
        Result := _device.CreateEffectGroup(_effectGroupRight);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _effectGroupRight.SetTransform3D(transformGroup);
    end;

    if (SUCCEEDED(Result)) then
    begin
        if (_actionType = atZOOMOUT) then
        begin
            beginOpacity := 0.0;
            endOpacity := 1.0;
        end
        else
        begin
            beginOpacity := 1.0;
            endOpacity := 0.0;
        end;

        Result := CreateLinearAnimation(beginOpacity, endOpacity, 0.25, 1.25, opacityAnimation);

        if (SUCCEEDED(Result)) then
        begin
            Result := _effectGroupRight.SetOpacity(opacityAnimation);
        end;
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _visualRight.SetEffect(_effectGroupRight);
    end;
end;

// Creates Translate transform without animation

function TApplication.CreateTranslateTransform(offsetX: single; offsetY: single; offsetZ: single;
    out translateTransform: IDCompositionTranslateTransform3D): HRESULT;
var
    transform: IDCompositionTranslateTransform3D;
begin
    Result := S_OK;

    if (SUCCEEDED(Result)) then
    begin
        translateTransform := nil;
        if (_device = nil) then
            Result := E_UNEXPECTED;
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _device.CreateTranslateTransform3D(transform);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetOffsetX(offsetX);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetOffsetY(offsetY);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetOffsetZ(offsetZ);
    end;

    if (SUCCEEDED(Result)) then
    begin
        translateTransform := transform;
    end;
end;

// Creates Translate transform with animation

function TApplication.CreateTranslateTransform(beginOffsetX: single; beginOffsetY: single; beginOffsetZ: single;
    endOffsetX: single; endOffsetY: single; endOffsetZ: single; beginTime: single; endTime: single;
    out translateTransform: IDCompositionTranslateTransform3D): HRESULT;
var
    transform: IDCompositionTranslateTransform3D;
    offsetXAnimation: IDCompositionAnimation;
    offsetYAnimation: IDCompositionAnimation;
    offsetZAnimation: IDCompositionAnimation;
begin
    Result := S_OK;

    if (SUCCEEDED(Result)) then
    begin
        translateTransform := nil;
        if (_device = nil) then
            Result := E_UNEXPECTED;
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _device.CreateTranslateTransform3D(transform);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := CreateLinearAnimation(beginOffsetX, endOffsetX, beginTime, endTime, offsetXAnimation);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetOffsetX(offsetXAnimation);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := CreateLinearAnimation(beginOffsetY, endOffsetY, beginTime, endTime, offsetYAnimation);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetOffsetY(offsetYAnimation);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := CreateLinearAnimation(beginOffsetZ, endOffsetZ, beginTime, endTime, offsetZAnimation);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetOffsetZ(offsetZAnimation);
    end;

    if (SUCCEEDED(Result)) then
    begin
        translateTransform := transform;
    end;
end;


// Creates scale transform without animation
function TApplication.CreateScaleTransform(centerX: single; centerY: single; centerZ: single; scaleX: single; scaleY: single;
    scaleZ: single; out scaleTransform: IDCompositionScaleTransform3D): HRESULT; overload;
var
    transform: IDCompositionScaleTransform3D;
begin
    Result := S_OK;

    if (SUCCEEDED(Result)) then
    begin
        scaleTransform := nil;
        if (_device = NULL) then
            Result := E_UNEXPECTED;
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _device.CreateScaleTransform3D(transform);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetCenterX(centerX);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetCenterY(centerY);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetCenterZ(centerZ);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetScaleX(scaleX);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetScaleY(scaleY);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetScaleZ(scaleZ);
    end;

    if (SUCCEEDED(Result)) then
    begin
        scaleTransform := transform;
    end;
end;

// Creates scale transform with animation

function TApplication.CreateScaleTransform(centerX: single; centerY: single; centerZ: single; beginScaleX: single;
    beginScaleY: single; beginScaleZ: single; endScaleX: single; endScaleY: single; endScaleZ: single; beginTime: single;
    endTime: single; out scaleTransform: IDCompositionScaleTransform3D): HRESULT;
var
    transform: IDCompositionScaleTransform3D;
    scaleXAnimation: IDCompositionAnimation;
    scaleYAnimation: IDCompositionAnimation;
    scaleZAnimation: IDCompositionAnimation;
begin
    Result := S_OK;

    if (SUCCEEDED(Result)) then
    begin
        scaleTransform := nil;
        if (_device = nil) then
            Result := E_UNEXPECTED;
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _device.CreateScaleTransform3D(transform);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetCenterX(centerX);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetCenterY(centerY);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetCenterZ(centerZ);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := CreateLinearAnimation(beginScaleX, endScaleX, beginTime, endTime, scaleXAnimation);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetScaleX(scaleXAnimation);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := CreateLinearAnimation(beginScaleY, endScaleY, beginTime, endTime, scaleYAnimation);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetScaleY(scaleYAnimation);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := CreateLinearAnimation(beginScaleZ, endScaleZ, beginTime, endTime, scaleZAnimation);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetScaleZ(scaleZAnimation);
    end;

    if (SUCCEEDED(Result)) then
    begin
        scaleTransform := transform;
    end;
end;

// Creates rotate transform without animation

function TApplication.CreateRotateTransform(centerX: single; centerY: single; centerZ: single; axisX: single; axisY: single;
    axisZ: single; angle: single; out rotateTransform: IDCompositionRotateTransform3D): HRESULT;
var
    transform: IDCompositionRotateTransform3D;
begin
    Result := S_OK;

    if (SUCCEEDED(Result)) then
    begin
        rotateTransform := nil;
        if (_device = nil) then
            Result := E_UNEXPECTED;
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _device.CreateRotateTransform3D(transform);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetCenterX(centerX);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetCenterY(centerY);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetCenterZ(centerZ);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetAxisX(axisX);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetAxisY(axisY);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetAxisZ(axisZ);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetAngle(angle);
    end;

    if (SUCCEEDED(Result)) then
    begin
        rotateTransform := transform;
    end;
end;

// Creates rotate transform with animation

function TApplication.CreateRotateTransform(centerX: single; centerY: single; centerZ: single; axisX: single; axisY: single;
    axisZ: single; beginAngle: single; endAngle: single; beginTime: single; endTime: single; out rotateTransform: IDCompositionRotateTransform3D): HRESULT;
var
    transform: IDCompositionRotateTransform3D;
    angleAnimation: IDCompositionAnimation;
begin
    Result := S_OK;

    if (SUCCEEDED(Result)) then
    begin
        rotateTransform := nil;
        if (_device = nil) then
            Result := E_UNEXPECTED;
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _device.CreateRotateTransform3D(transform);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetCenterX(centerX);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetCenterY(centerY);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetCenterZ(centerZ);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetAxisX(axisX);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetAxisY(axisY);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetAxisZ(axisZ);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := CreateLinearAnimation(beginAngle, endAngle, beginTime, endTime, angleAnimation);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetAngle(angleAnimation);
    end;

    if (SUCCEEDED(Result)) then
    begin
        rotateTransform := transform;
    end;
end;



function TApplication.CreateLinearAnimation(beginValue: single; endValue: single; beginTime: single; endTime: single;
    out Animation: IDCompositionAnimation): HRESULT;
begin
    Result := S_OK;

    if (SUCCEEDED(Result)) then
    begin
        animation := nil;
        if (_device = nil) then
            Result := E_UNEXPECTED;
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _device.CreateAnimation(animation);
    end;

    // Ensures animation start value takes effect immediately
    if (SUCCEEDED(Result)) then
    begin
        if (beginTime > 0.0) then
        begin
            Result := animation.AddCubic(0.0, beginValue, 0.0, 0.0, 0.0);
        end;
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := animation.AddCubic(beginTime, beginValue, (endValue - beginValue) / (endTime - beginTime), 0.0, 0.0);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := animation._End(endTime, endValue);
    end;
end;

// Creates perspective transform

function TApplication.CreatePerspectiveTransform(dx: single; dy: single; dz: single; out perspectiveTransform: IDCompositionMatrixTransform3D): HRESULT;
var
    matrix: TD3DMATRIX;
    transform: IDCompositionMatrixTransform3D;
begin
    Result := S_OK;

    if (SUCCEEDED(Result)) then
    begin
        perspectiveTransform := nil;
    end;

    matrix._11 := 1.0;
    matrix._12 := 0.0;
    matrix._13 := 0.0;
    matrix._14 := dx;
    matrix._21 := 0.0;
    matrix._22 := 1.0;
    matrix._23 := 0.0;
    matrix._24 := dy;
    matrix._31 := 0.0;
    matrix._32 := 0.0;
    matrix._33 := 1.0;
    matrix._34 := dz;
    matrix._41 := 0.0;
    matrix._42 := 0.0;
    matrix._43 := 0.0;
    matrix._44 := 1.0;

    if (SUCCEEDED(Result)) then
    begin
        Result := _device.CreateMatrixTransform3D(transform);
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := transform.SetMatrix(matrix);
    end;

    if (SUCCEEDED(Result)) then
    begin
        perspectiveTransform := transform;
    end;
end;

// The child visual associated with the pressed key disappears and the previously disappeared one appears again.

function TApplication.UpdateVisuals(currentVisual: integer; nextVisual: integer): LRESULT;
var
    hr: Hresult;
begin
    hr := _visualRight.SetContent(_surfaceLeftChild[nextVisual]);

    if (SUCCEEDED(hr)) then
    begin
        hr := _effectGroupLeftChild[currentVisual].SetOpacity(1.0);
    end;

    if (SUCCEEDED(hr)) then
    begin
        hr := _effectGroupLeftChild[nextVisual].SetOpacity(0.0);
    end;

    if (SUCCEEDED(hr)) then
    begin
        hr := _device.Commit();
    end;

    if SUCCEEDED(hr) then
        Result := 0
    else
        Result := 1;
end;

// Destroys D2D Device

procedure TApplication.DestroyD2D1Device();
begin
    _d2d1DeviceContext := nil;
    _d2d1Device := nil;
end;

// Destroys D3D device

procedure TApplication.DestroyD3D11Device();
begin
    _d3d11DeviceContext := nil;
    _d3d11Device := nil;
end;

// Destroy D2D Factory

procedure TApplication.DestroyD2D1Factory();
begin
    _d2d1Factory := nil;
end;

// Destroys DirectComposition Visual tree

procedure TApplication.DestroyDCompositionVisualTree();
var
    i: integer;
begin
    _effectGroupRight := nil;

    for i := 0 to 3 do
    begin
        _effectGroupLeftChild[i] := nil;
    end;

    _effectGroupLeft := nil;

    for i := 0 to 3 do
    begin
        _surfaceLeftChild[i] := nil;
    end;

    _visualRight := nil;

    for i := 0 to 3 do
    begin
        _visualLeftChild[i] := nil;
    end;

    _visualLeft := nil;
    _visual := nil;
    _target := nil;
end;

// Destroys DirectComposition device

procedure TApplication.DestroyDCompositionDevice();
begin
    _device := nil;
end;

(*---End of code calling DirectComposition APIs-------------------------------------------------------*)

// Main Window procedure
function WindProc(hWnd: HWND; message: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
    Result := 0;

    if (DCompApp <> nil) then
    begin
        case (message) of
            WM_LBUTTONUP:
            begin
                Result := DCompApp.OnLeftButton();
            end;

            WM_KEYDOWN:
            begin
                Result := DCompApp.OnKeyDown(wParam);
            end;

            WM_CLOSE:
            begin
                Result := DCompApp.OnClose();
            end;

            WM_DESTROY:
            begin
                Result := DCompApp.OnDestroy();
            end;

            WM_PAINT:
            begin
                Result := DCompApp.OnPaint();
            end;
            else
                Result := DefWindowProc(hwnd, message, wParam, lParam);
        end;
    end;

end;


// Creates the application window
function TApplication.CreateApplicationWindow(): HRESULT;
var
    wcex: WNDCLASSEXA;
    rect: TRECT;
    fontTypeface: array [0..31] of WCHAR;
    fontHeightLogo: array[0..31] of WCHAR;
    fontHeightTitle: array[0..31] of WCHAR;
    fontHeightDescription: array[0..31] of WCHAR;

begin
    Result := S_OK;

    wcex.cbSize := sizeof(wcex);
    wcex.style := CS_HREDRAW or CS_VREDRAW;
    wcex.lpfnWndProc := @WindProc;
    wcex.cbClsExtra := 0;
    wcex.cbWndExtra := 0;
    wcex.hInstance := hinstance;
    wcex.hIcon := LoadIcon(0, IDI_APPLICATION);
    wcex.hCursor := LoadCursor(0, IDC_ARROW);
    wcex.hbrBackground := HBRUSH(GetStockObject(WHITE_BRUSH));
    wcex.lpszMenuName := nil;
    wcex.lpszClassName := pAnsiChar('MainWindowClass');
    wcex.hIconSm := LoadIcon(0, IDI_APPLICATION);

    if RegisterClassExA(wcex) = 0 then
        Result := E_FAIL
    else
        Result := S_OK;

    if (SUCCEEDED(Result)) then
    begin
        rect.Create(0, 0, _windowWidth, _windowHeight);
        AdjustWindowRect(@rect, WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU or WS_MINIMIZEBOX, False);

        _hwnd := CreateWindowExA(0, pAnsiChar('MainWindowClass'), pAnsiChar('DirectComposition Effects Sample'), WS_OVERLAPPEDWINDOW {WS_OVERLAPPED or
            WS_CAPTION or WS_SYSMENU or WS_MINIMIZEBOX}, CW_USEDEFAULT, CW_USEDEFAULT, rect.right - rect.left, rect.bottom - rect.top, 0, 0, hinstance, nil);

        if (_hwnd = 0) then
        begin
            Result := E_UNEXPECTED;
        end;
    end;

    if (SUCCEEDED(Result)) then
    begin
        fontTypeface := pWideChar('Segoe UI Light');
        Move(fontTypeface, _fontTypeface, sizeOf(_fontTypeface));

        _fontHeightLogo := 0;
        _fontHeightTitle := 50;
        _fontHeightDescription := 22;

    end;
end;

// Shows the application window

function TApplication.ShowApplicationWindow(): boolean;
var
    bSucceeded: boolean;
begin
    bSucceeded := (_hwnd <> 0);

    if (bSucceeded) then
    begin
        ShowWindow(_hwnd, SW_SHOW);
        UpdateWindow(_hwnd);
    end;

    Result := bSucceeded;
end;

// Destroys the applicaiton window

procedure TApplication.DestroyApplicationWindow();
begin
    if (_hwnd <> 0) then
    begin
        DestroyWindow(_hwnd);
        _hwnd := 0;
    end;
end;

// Zoom out to have all the picture on sight.

function TApplication.ZoomOut(): HRESULT;
begin
    if (_state = vsZOOMEDOUT) then
        Result := E_UNEXPECTED
    else
        Result := S_OK;

    if (SUCCEEDED(Result)) then
    begin
        _actionType := atZOOMOUT;
        Result := SetEffectOnVisuals();
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _device.Commit();
    end;

    if (SUCCEEDED(Result)) then
    begin
        _state := vsZOOMEDOUT;
    end;
end;

// Zoom in to look more closely to the selected pictures

function TApplication.ZoomIn(): HRESULT;
begin
    if (_state = vsZOOMEDIN) then
        Result := E_UNEXPECTED
    else
        Result := S_OK;

    if (SUCCEEDED(Result)) then
    begin
        _actionType := atZOOMIN;
        Result := SetEffectOnVisuals();
    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := _device.Commit();
    end;

    if (SUCCEEDED(Result)) then
    begin
        _state := vsZOOMEDIN;
    end;
end;

// Handles the WM_LBUTTONUP message

function TApplication.OnLeftButton(): LRESULT;
var
    hr: HResult;
begin
    if (_state = vsZOOMEDOUT) then
        hr := ZoomIn()
    else
        hr := ZoomOut();

    if SUCCEEDED(hr) then
        Result := 0
    else
        Result := 1;
end;

// Handles the WM_KEYDOWN message

function TApplication.OnKeyDown(wParam: WPARAM): LRESULT;
begin
    Result := 0;

    if (_state = vsZOOMEDOUT) then
    begin
        if (wParam = Ord('1')) and (_currentVisual <> 0) then
        begin
            Result := UpdateVisuals(_currentVisual, 0);
            _currentVisual := 0;
        end

        else if (wParam = Ord('2')) and (_currentVisual <> 1) then
        begin
            Result := UpdateVisuals(_currentVisual, 1);
            _currentVisual := 1;
        end

        else if (wParam = Ord('3')) and (_currentVisual <> 2) then
        begin
            Result := UpdateVisuals(_currentVisual, 2);
            _currentVisual := 2;
        end

        else if (wParam = Ord('4')) and (_currentVisual <> 3) then
        begin
            Result := UpdateVisuals(_currentVisual, 3);
            _currentVisual := 3;
        end;
    end;
end;

// Handles the WM_CLOSE message

function TApplication.OnClose(): LRESULT;
begin
    if (_hwnd <> 0) then
    begin
        DestroyWindow(_hwnd);
        _hwnd := 0;
    end;
    Result := 0;
end;

// Handles the WM_DESTROY message

function TApplication.OnDestroy(): LRESULT;
begin
    PostQuitMessage(0);
    Result := 0;
end;

// Handles the WM_PAINT message

function TApplication.OnPaint(): LRESULT;
var
    rcClient: TRECT;
    ps: TPAINTSTRUCT;
    lhdc: HDC;
    hlogo: HFONT;
    hOldFont: HFONT;
    htitle: HFONT;
    hdescription: HFONT;
begin
    lhdc := BeginPaint(_hwnd, ps);

    // get the dimensions of the main window.
    GetClientRect(_hwnd, rcClient);

    // Logo
    hlogo := CreateFontW(_fontHeightLogo, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, _fontTypeface);    // Logo Font and Size
    if (hlogo <> 0) then
    begin
        hOldFont := (SelectObject(lhdc, hlogo));
        SetBkMode(lhdc, TRANSPARENT);

        rcClient.top := 10;
        rcClient.left := 50;

        DrawTextW(lhdc, 'Windows samples', -1, rcClient, DT_WORDBREAK);
        SelectObject(lhdc, hOldFont);
        DeleteObject(hlogo);
    end;

    // Title
    htitle := CreateFontW(_fontHeightTitle, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, _fontTypeface);    // Title Font and Size
    if (htitle <> 0) then
    begin
        hOldFont := (SelectObject(lhdc, htitle));

        SetTextColor(lhdc, GetSysColor(COLOR_WINDOWTEXT));

        rcClient.top := 25;
        rcClient.left := 50;

        DrawTextW(lhdc, 'DirectComposition Effects Sample', -1, rcClient, DT_WORDBREAK);
        SelectObject(lhdc, hOldFont);
        DeleteObject(htitle);
    end;

    // Description
    hdescription := CreateFontW(_fontHeightDescription, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, _fontTypeface);    // Description Font and Size
    if (hdescription <> 0) then
    begin
        hOldFont := (SelectObject(lhdc, hdescription));

        rcClient.top := 90;
        rcClient.left := 50;

        DrawTextW(lhdc, 'This sample explains how to use DirectComposition effects: rotation, scaling, perspective, translation and opacity.',
            -1, rcClient, DT_WORDBREAK);

        rcClient.top := 500;
        rcClient.left := 450;

        DrawTextW(lhdc, 'A) Left-click to toggle between single and multiple-panels view.' + Chr(13) + 'B) Use keys 1-4 to switch the color of the right-panel.',
            -1, rcClient, DT_WORDBREAK);

        SelectObject(lhdc, hOldFont);
        DeleteObject(hdescription);
    end;

    EndPaint(_hwnd, ps);

    Result := 0;
end;



end.
