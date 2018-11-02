unit SimpleCompositionApp;

{$mode delphi}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D11,
    DX12.DXGI,
    DX12.DXGI1_2,
    DX12.D3DCommon,
    DX12.DComp;

type

    { TDemoApp }

    TDemoApp = class(TObject)
    private
        Fhwnd: HWND;
        FhBitmap: HBITMAP;
        FpD3D11Device: ID3D11Device;
        FpDCompDevice: IDCompositionDevice;
        FpDCompTarget: IDCompositionTarget;
    private
        function InitializeDirectCompositionDevice(): HRESULT;
        function CreateResources(): HRESULT;
        procedure DiscardResources();
        function OnClientClick(): HRESULT;
        function LoadResourceGDIBitmap(resourceName: PCSTR; out hbmp: HBITMAP): HRESULT;
        function MyCreateGDIRenderedDCompSurface(hBitmap: HBITMAP; out ppSurface: IDCompositionSurface): HRESULT;

    public
        constructor Create;
        destructor Destroy; override;
        function Initialize(): Hresult;
        procedure RunMessageLoop();
    end;

    PDemoApp = ^TDemoApp;

var
    app: TDemoApp;

implementation



{ TDemoApp }

function TDemoApp.InitializeDirectCompositionDevice(): HRESULT;
var
    featureLevelSupported: TD3D_FEATURE_LEVEL;
    pDXGIDevice: IDXGIDevice;
begin
    // Create the D3D device object. The D3D11_CREATE_DEVICE_BGRA_SUPPORT
    // flag enables rendering on surfaces using Direct2D.
    Result := D3D11CreateDevice(nil, D3D_DRIVER_TYPE_HARDWARE, 0, Ord(D3D11_CREATE_DEVICE_BGRA_SUPPORT), nil, 0, D3D11_SDK_VERSION,
        FpD3D11Device, featureLevelSupported, nil);

    // Check the result of calling D3D11CreateDriver.
    if (SUCCEEDED(Result)) then
    begin
        // Create the DXGI device used to create bitmap surfaces.
        Result := FpD3D11Device.QueryInterface(IID_IDXGIDevice, pDXGIDevice);
    end;

    if (SUCCEEDED(Result)) then
    begin
        // Create the DirectComposition device object.
        Result := DCompositionCreateDevice(pDXGIDevice, IID_IDCompositionDevice, FpDCompDevice);
    end;

    if (SUCCEEDED(Result)) then
    begin
        // Create the composition target object based on the
        // specified application window.
        Result := FpDCompDevice.CreateTargetForHwnd(Fhwnd, True, FpDCompTarget);
    end;

    if pDXGIDevice <> nil then
        pDXGIDevice := nil;
end;



function TDemoApp.CreateResources(): HRESULT;
begin
    Result := LoadResourceGDIBitmap('Logo', FhBitmap);
end;



procedure TDemoApp.DiscardResources();
begin
    DeleteObject(FhBitmap);
end;



function TDemoApp.OnClientClick(): HRESULT;
var
    xOffset: single = 20; // horizonal position of visual
    yOffset: single = 20; // vertical position of visual
    pVisual: IDCompositionVisual;
    pSurface: IDCompositionSurface;

begin
    // Create a visual object.
    Result := FpDCompDevice.CreateVisual(pVisual);

    if (SUCCEEDED(Result)) then
    begin
        // Create a composition surface and render a GDI bitmap
        // to the surface.
        Result := MyCreateGDIRenderedDCompSurface(FhBitmap, pSurface);
    end;

    if (SUCCEEDED(Result)) then
    begin
        // Set the bitmap content of the visual.
        Result := pVisual.SetContent(pSurface);
    end;

    if (SUCCEEDED(Result)) then
    begin
        // Set the horizontal and vertical position of the visual relative
        // to the upper-left corner of the composition target window.
        Result := pVisual.SetOffsetX(xOffset);
        if (SUCCEEDED(Result)) then
        begin
            Result := pVisual.SetOffsetY(yOffset);
        end;
    end;

    if (SUCCEEDED(Result)) then
    begin
        // Set the visual to be the root of the visual tree.
        Result := FpDCompTarget.SetRoot(pVisual);
    end;

    if (SUCCEEDED(Result)) then
    begin
        // Commit the visual to be composed and displayed.
        Result := FpDCompDevice.Commit();
    end;

    // Free the visual.
    if pVisual <> nil then
        pVisual := nil;
end;



function TDemoApp.LoadResourceGDIBitmap(resourceName: PCSTR; out hbmp: HBITMAP): HRESULT;
begin
    hbmp := LoadBitmapA(HINSTANCE, 'LOGO');
    // hbmp := LoadImageA(HINSTANCE, resourceName, IMAGE_BITMAP, 0, 0, LR_DEFAULTCOLOR);
    if hbmp <> 0 then
        Result := S_OK
    else
        Result := E_FAIL;
end;



function TDemoApp.MyCreateGDIRenderedDCompSurface(hBitmap: HBITMAP; out ppSurface: IDCompositionSurface): HRESULT;
var
    bitmapWidth: integer = 0;
    bitmapHeight: integer = 0;
    bmpSize: integer = 0;
    bmp: TBITMAP;
    hBitmapOld: HBITMAP = 0;
    hSurfaceDC: HDC = 0;
    hBitmapDC: HDC = 0;
    pDXGISurface: IDXGISurface1;
    pointOffset: TPOINT;
begin

    Result := E_INVALIDARG;

    // Get information about the bitmap.
    bmpSize := GetObject(hBitmap, sizeof(BITMAP), @bmp);
    if bmpSize <> 0 then
        Result := S_OK
    else
        Result := E_FAIL;
    if (SUCCEEDED(Result)) then
    begin
        // Save the bitmap dimensions.
        bitmapWidth := bmp.bmWidth;
        bitmapHeight := bmp.bmHeight;

        // Create a DirectComposition-compatible surface that is the same size
        // as the bitmap. The DXGI_FORMAT_B8G8R8A8_UNORM flag is required for
        // rendering on the surface using GDI via GetDC.
        Result := FpDCompDevice.CreateSurface(bitmapWidth, bitmapHeight, DXGI_FORMAT_B8G8R8A8_UNORM, DXGI_ALPHA_MODE_IGNORE, ppSurface);
    end;

    if (SUCCEEDED(Result)) then
    begin
        // Begin rendering to the surface.
        Result := ppSurface.BeginDraw(nil, IID_IDXGISurface1, pDXGISurface, pointOffset);
    end;

    if (SUCCEEDED(Result)) then
    begin
        // Get the device context (DC) for the surface.
        Result := pDXGISurface.GetDC(False, hSurfaceDC);
    end;

    if (SUCCEEDED(Result)) then
    begin
        // Create a compatible DC and select the surface
        // into the DC.
        hBitmapDC := CreateCompatibleDC(hSurfaceDC);
        if (hBitmapDC <> 0) then
        begin
            hBitmapOld := SelectObject(hBitmapDC, hBitmap);
            BitBlt(hSurfaceDC, pointOffset.x, pointOffset.y,
                bitmapWidth, bitmapHeight, hBitmapDC, 0, 0, SRCCOPY);

            if (hBitmapOld <> 0) then
            begin
                SelectObject(hBitmapDC, hBitmapOld);
            end;
            DeleteDC(hBitmapDC);
        end;

        pDXGISurface.ReleaseDC(nil);
    end;

    // End the rendering.
    ppSurface.EndDraw();

    // Call an application-defined macro to free the surface pointer.
    if pDXGISurface <> nil then
        pDXGISurface := nil;
end;



function WndProc(hWnd: HWND; message: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
    wasHandled: boolean = False;
begin
    Result := 0;

    if (App <> nil) then
    begin
        case (message) of
            WM_LBUTTONDOWN:
            begin
                App.OnClientClick();
                wasHandled := True;
                Result := 0;
            end;

            WM_DISPLAYCHANGE:
            begin
                InvalidateRect(hwnd, nil, False);
                wasHandled := True;
                Result := 0;
            end;

            WM_DESTROY:
            begin
                PostQuitMessage(0);
                App.DiscardResources();
                wasHandled := True;
                Result := 1;
            end;
        end;
    end;
    if (not wasHandled) then
    begin
        Result := DefWindowProc(hwnd, message, wParam, lParam);
    end;
end;



constructor TDemoApp.Create;
begin

end;



destructor TDemoApp.Destroy;
begin
    if FpDCompDevice <> nil then
        FpDCompDevice := nil;
    if FpDCompTarget <> nil then
        FpDCompTarget := nil;
    if FpD3D11Device <> nil then
        FpD3D11Device := nil;
    inherited Destroy;
end;



function TDemoApp.Initialize(): Hresult;
var
    wcex: WNDCLASSEXA;
    dpiX: integer = 0;
    dpiY: integer = 0;
    lHDC: HDC;
begin
    // Register the window class.
    wcex.cbSize := sizeof(TWNDCLASSEXA);
    wcex.style := CS_HREDRAW or CS_VREDRAW;
    wcex.lpfnWndProc := @WndProc;
    wcex.cbClsExtra := 0;
    wcex.cbWndExtra := 0;
    wcex.hInstance := HINSTANCE;
    wcex.hIcon := LoadIcon(0, IDI_APPLICATION);
    wcex.hbrBackground := HBRUSH(COLOR_WINDOW + 1);
    wcex.lpszMenuName := nil;
    wcex.hCursor := LoadCursor(0, IDC_ARROW);
    wcex.lpszClassName := pAnsiChar('DirectCompDemoApp');
    wcex.hIconSm := LoadIcon(0, IDI_APPLICATION);

    if (RegisterClassExA(wcex) = 0) then
    begin
        MessageBox(0, 'Error registering class',
            'Error', MB_OK or MB_ICONERROR);
        Exit;
    end;
    // Create the application window.

    // Because the CreateWindow function takes its size in pixels, we
    // obtain the system DPI and use it to scale the window size.

    lHDC := GetDC(0);
    if (lHDC <> 0) then
    begin
        dpiX := GetDeviceCaps(lHDC, LOGPIXELSX);
        dpiY := GetDeviceCaps(lHDC, LOGPIXELSY);
        ReleaseDC(0, lHDC);
    end;

    Fhwnd := CreateWindowA(pAnsiChar('DirectCompDemoApp'), pAnsiChar('DirectComposition Demo Application'), WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT, trunc(640.0 * dpiX / 96.0), trunc(480.0 * dpiY / 96.0), 0, 0, HINSTANCE, nil);

    if Fhwnd <> 0 then
        Result := S_OK
    else
        Result := E_FAIL;
    if (SUCCEEDED(Result)) then
    begin
        ShowWindow(Fhwnd, SW_SHOWNORMAL);
        UpdateWindow(Fhwnd);

        // Initialize DirectComposition resources, such as the
        // device object and composition target object.
        Result := InitializeDirectCompositionDevice();
    end;

    if (SUCCEEDED(Result)) then
        Result := CreateResources();
end;



procedure TDemoApp.RunMessageLoop();
var
    msg: TMSG;
begin
    while (GetMessage(msg, 0, 0, 0)) do
    begin
        TranslateMessage(msg);
        DispatchMessage(msg);
    end;
end;

end.
