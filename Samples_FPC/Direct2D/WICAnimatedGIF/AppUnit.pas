unit AppUnit;

{$mode delphi}

interface

uses
    Windows, Classes, SysUtils, ActiveX,
    DX12.D2D1, DX12.WinCodec, CMC.COMBaseAPI;

const
    DEFAULT_DPI = 96.0;   // Default DPI that maps image resolution directly to screen resoltuion
    DELAY_TIMER_ID = UINT(1);    // Global ID for the timer, only one timer is used

type

    TDISPOSAL_METHODS = (
        DM_UNDEFINED = 0,
        DM_NONE = 1,
        DM_BACKGROUND = 2,
        DM_PREVIOUS = 3
        );


    { TDemoApp }

    TDemoApp = class(TObject)
    private
        { private declarations }
        m_hWnd: HWND;
        FWndProcPointer: pointer;
        m_pD2DFactory: ID2D1Factory;
        m_pHwndRT: ID2D1HwndRenderTarget;
        m_pFrameComposeRT: ID2D1BitmapRenderTarget;
        m_pRawFrame: ID2D1Bitmap;
        m_pSavedFrame: ID2D1Bitmap;          // The temporary bitmap used for disposal 3 method
        m_backgroundColor: TD2D1_COLOR_F;

        m_pIWICFactory: IWICImagingFactory;
        m_pDecoder: IWICBitmapDecoder;

        m_uNextFrameIndex: UINT;
        m_uTotalLoopCount: UINT;  // The number of loops for which the animation will be played
        m_uLoopNumber: UINT;      // The current animation loop number (e.g. 1 when the animation is first played)
        m_fHasLoop: boolean;         // Whether the gif has a loop
        m_cFrames: UINT;
        m_uFrameDisposal: TDISPOSAL_METHODS;
        m_uFrameDelay: UINT;
        m_cxGifImage: UINT;
        m_cyGifImage: UINT;
        m_cxGifImagePixel: UINT;  // Width of the displayed image in pixel calculated using pixel aspect ratio
        m_cyGifImagePixel: UINT;  // Height of the displayed image in pixel calculated using pixel aspect ratio
        m_framePosition: TD2D1_RECT_F;
    protected
        function WndProc(hWnd: HWND; umessage: UINT; wpara: wparam; lpara: lparam): LRESULT; stdcall;
    private
        function CreateDeviceResources: HResult;
        function CalculateDrawRectangle(out drawRect: TD2D1_RECT_F): HRESULT;
        function RestoreSavedFrame(): HRESULT;
        function ClearCurrentFrameArea(): HResult;
        function DisposeCurrentFrame(): HResult;
        function OverlayNextFrame(): HResult;

        function GetRawFrame(uFrameIndex: UINT): HRESULT;
        function SaveComposedFrame(): HResult;
        function ComposeNextFrame(): HResult;
        function IsLastFrame(): boolean;
        function EndOfAnimation: boolean;
        function RecoverDeviceResources: HResult;
        function GetGlobalMetadata(): HRESULT;

        function GetBackgroundColor(pMetadataQueryReader: IWICMetadataQueryReader): HResult;

        function SelectAndDisplayGif: HResult;
        procedure OnRender;

        function OnResize(uWidth: UINT; uHeight: UINT): HResult;


    public
        { public declarations }
        constructor Create;
        destructor Destroy; override;
        function Initialize(Instance: PtrUInt): HRESULT;
    end;


implementation



procedure SafeRelease(ppInterfaceToRelease: IUnknown);
begin
    if ppInterfaceToRelease <> nil then
        ppInterfaceToRelease := nil;
end;



procedure FreeProcInstance(ProcInstance: Pointer);
begin
    FreeMem(ProcInstance, 15);
end;



function MakeProcInstance(M: TMethod): Pointer;
begin
    GetMem(Result, 15);
    asm
               // MOV ECX,
               MOV     BYTE PTR [EAX], $B9
               MOV     ECX, M.Data
               MOV     DWORD PTR [EAX+$1], ECX
               // POP EDX (put old jump back adress to EDX)
               MOV     BYTE PTR [EAX+$5], $5A
               // PUSH ECX (add "self" as parameter 0)
               MOV     BYTE PTR [EAX+$6], $51
               // PUSH EDX (put jump back adress back on stack)
               MOV     BYTE PTR [EAX+$7], $52
               // MOV ECX, (move adress to ECX)
               MOV     BYTE PTR [EAX+$8], $B9
               MOV     ECX, M.Code
               MOV     DWORD PTR [EAX+$9], ECX
               // JMP ECX (jump to first put down command and call method)
               MOV     BYTE PTR [EAX+$D], $FF
               MOV     BYTE PTR [EAX+$E], $E1
               // No call here or there would be another jump back adress on the stack
    end;
end;



function RectWidth(rc: TRECT): longint; inline;
begin
    Result := rc.right - rc.left;
end;



function RectHeight(rc: TRECT): longint; inline;
begin
    Result := rc.bottom - rc.top;
end;


{ TDemoApp }

{******************************************************************
*                                                                 *
*  TDemoApp.DemoApp constructor                                   *
*                                                                 *
*  Initializes member data                                        *
*                                                                 *
******************************************************************}
constructor TDemoApp.Create;
var
    hr: HResult;
begin

    m_pD2DFactory := nil;
    m_pHwndRT := nil;
    m_pFrameComposeRT := nil;
    m_pRawFrame := nil;
    m_pSavedFrame := nil;
    m_pIWICFactory := nil;
    m_pDecoder := nil;

    hr := S_OK;
    if (SUCCEEDED(hr)) then
    begin
        // Create D2D factory
        hr := D2D1CreateFactory(D2D1_FACTORY_TYPE_SINGLE_THREADED, ID2D1Factory1, nil, m_pD2DFactory);
    end;

    if (SUCCEEDED(hr)) then
    begin
        // Create WIC factory
        hr := CoCreateInstance(CLSID_WICImagingFactory, nil, CLSCTX_INPROC_SERVER, IWICImagingFactory, m_pIWICFactory);
    end;
end;


{******************************************************************
*                                                                 *
*  TDemoApp.~DemoApp destructor                                   *
*                                                                 *
*  Tears down resources                                           *
*                                                                 *
******************************************************************}
destructor TDemoApp.Destroy;
begin
    SafeRelease(m_pD2DFactory);
    SafeRelease(m_pHwndRT);
    SafeRelease(m_pFrameComposeRT);
    SafeRelease(m_pRawFrame);
    SafeRelease(m_pSavedFrame);
    SafeRelease(m_pIWICFactory);
    SafeRelease(m_pDecoder);
    inherited;
end;



function TDemoApp.Initialize(Instance: PtrUInt): HRESULT;
var
    wcex: TWNDCLASSEX;
    lMethod: TMethod;
begin
    lMethod.Code := @TDemoApp.WndProc;
    lMethod.Data := Self;
    FWndProcPointer := MakeProcInstance(lMethod);

    // Register window class

    wcex.cbSize := sizeof(WNDCLASSEX);
    wcex.style := CS_HREDRAW or CS_VREDRAW;
    wcex.lpfnWndProc := FWndProcPointer;
    wcex.cbClsExtra := 0;
    wcex.cbWndExtra := sizeof(LONG_PTR);
    wcex.hInstance := hInstance;
    wcex.hIcon := 0;
    wcex.hCursor := LoadCursor(0, IDC_ARROW);
    wcex.hbrBackground := 0;
    wcex.lpszMenuName := nil;// MAKEINTRESOURCE(IDR_WICANIMATEDGIF);
    wcex.lpszClassName := PAnsiChar('WICANIMATEDGIF');
    wcex.hIconSm := 0;

    if (RegisterClassEx(wcex) = 0) then
        Result := E_FAIL
    else
        Result := S_OK;


    if (SUCCEEDED(Result)) then
    begin
        // Create window
        m_hWnd := CreateWindow(PAnsiChar('WICANIMATEDGIF'), PAnsichar('WIC Animated Gif Sample'), WS_OVERLAPPEDWINDOW or
            WS_VISIBLE, 0, 0, 640, 480, 0, 0, hInstance, self);
        if m_hWnd = 0 then
            Result := E_FAIL
        else
            Result := S_OK;

    end;

    if (SUCCEEDED(Result)) then
    begin
        Result := SelectAndDisplayGif();
        if (FAILED(Result)) then
        begin
            DestroyWindow(m_hWnd);
        end;
    end;
end;


{******************************************************************
*                                                                 *
*  TDemoApp.OnRender                                              *
*                                                                 *
*  Called whenever the application needs to display the client    *
*  window.                                                        *
*                                                                 *
*  Renders the pre-composed frame by drawing it onto the hwnd     *
*  render target.                                                 *
*                                                                 *
*****************************************************************}


procedure TDemoApp.OnRender;
var
    pFrameToRender: ID2D1Bitmap;
    drawRect: TD2D1_RECT_F;
    hr: HResult;
    lState: TD2D1_WINDOW_STATE;
begin
    hr := S_OK;
    pFrameToRender := nil;

    // Check to see if the render targets are initialized
    if ((m_pHwndRT <> nil) and (m_pFrameComposeRT <> nil)) then
    begin
        if (SUCCEEDED(hr)) then
        begin
            // Only render when the window is not occluded
            lState := m_pHwndRT.CheckWindowState();
            if ((Ord(lState) and Ord(D2D1_WINDOW_STATE_OCCLUDED)) <> Ord(D2D1_WINDOW_STATE_OCCLUDED)) then
            begin
                hr := CalculateDrawRectangle(drawRect);

                if (SUCCEEDED(hr)) then
                begin
                    // Get the bitmap to draw on the hwnd render target
                    hr := m_pFrameComposeRT.GetBitmap(pFrameToRender);
                end;

                if (SUCCEEDED(hr)) then
                begin
                    // Draw the bitmap onto the calculated rectangle
                    m_pHwndRT.BeginDraw();

                    m_pHwndRT.Clear(DX12.D2D1.ColorF(DX12.D2D1.Black));
                    m_pHwndRT.DrawBitmap(pFrameToRender, @drawRect);

                    hr := m_pHwndRT.EndDraw();
                end;
            end;
        end;
    end;
    SafeRelease(pFrameToRender);
end;

{******************************************************************
*                                                                 *
*  TDemoApp.OnResize                                              *
*                                                                 *
*  If the application receives a WM_SIZE message, this method     *
*  will resize the render target appropriately.                   *
*                                                                 *
******************************************************************}


function TDemoApp.WndProc(hWnd: HWND; umessage: UINT; wpara: wparam; lpara: lparam): LRESULT; stdcall;
var
    uWidth, uHeight: UINT;
begin
    case (umessage) of
        WM_SIZE:
        begin
            uWidth := LOWORD(lpara);
            uHeight := HIWORD(lpara);
            OnResize(uWidth, uHeight);
            Result := 0;
        end;
        WM_PAINT:

        begin
            OnRender();
            ValidateRect(hWnd, nil);
            Result := 0;
        end;
        WM_DISPLAYCHANGE:
        begin

            InvalidateRect(hWnd, nil, False);
        end;
        WM_DESTROY:
        begin

            PostQuitMessage(0);
            Result := 1;
        end;
        WM_TIMER:
        begin
            // Timer expired, display the next frame and set a new timer
            // if needed
            ComposeNextFrame();
            InvalidateRect(hWnd, nil, False);
        end
        else
            Result := DefWindowProc(hWnd, umessage, wpara, lpara);
    end;
end;

{*****************************************************************
*                                                                 *
*  TDemoApp.CreateDeviceResources                                 *
*                                                                 *
*  Creates a D2D hwnd render target for displaying gif frames     *
*  to users and a D2D bitmap render for composing frames.         *
*                                                                 *
*****************************************************************}

function TDemoApp.CreateDeviceResources: HResult;
var
    rcClient: TRECT;
    renderTargetProperties: TD2D1_RENDER_TARGET_PROPERTIES;
    hwndRenderTragetproperties: TD2D1_HWND_RENDER_TARGET_PROPERTIES;
    size: TD2D1_SIZE_U;
begin
    Result := S_OK;
    GetClientRect(m_hWnd, rcClient);

    if (SUCCEEDED(Result)) then
    begin
        if (m_pHwndRT = nil) then
        begin
            // Create a D2D hwnd render target
            renderTargetProperties := DX12.D2D1.RenderTargetProperties();

            // Set the DPI to be the default system DPI to allow direct mapping
            // between image pixels and desktop pixels in different system DPI
            // settings
            renderTargetProperties.dpiX := DEFAULT_DPI;
            renderTargetProperties.dpiY := DEFAULT_DPI;

            hwndRenderTragetproperties :=
                DX12.D2D1.HwndRenderTargetProperties(m_hWnd, DX12.D2D1.SizeU(RectWidth(rcClient), RectHeight(rcClient)));

            Result := m_pD2DFactory.CreateHwndRenderTarget(renderTargetProperties, hwndRenderTragetproperties, m_pHwndRT);
        end
        else
        begin
            // We already have a hwnd render target, resize it to the window size

            size.Width := RectWidth(rcClient);
            size.Height := RectHeight(rcClient);
            Result := m_pHwndRT.Resize(@size);
        end;
    end;

    if (SUCCEEDED(Result)) then
    begin
        // Create a bitmap render target used to compose frames. Bitmap render
        // targets cannot be resized, so we always recreate it.
        SafeRelease(m_pFrameComposeRT);
        Result := m_pHwndRT.CreateCompatibleRenderTarget(DX12.D2D1.SizeF(m_cxGifImage, m_cyGifImage), nil, nil,
            D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS_NONE, m_pFrameComposeRT);

    end;
end;

{******************************************************************
*                                                                 *
*  TDemoApp.CalculateDrawRectangle()                              *
*                                                                 *
*  Calculates a specific rectangular area of the hwnd             *
*  render target to draw a bitmap containing the current          *
*  composed frame.                                                *
*                                                                 *
******************************************************************}

function TDemoApp.CalculateDrawRectangle(out drawRect: TD2D1_RECT_F): HRESULT;
var
    rcClient: TRECT;
    aspectRatio: single;
    newWidth, newHeight: single;
begin
    Result := S_OK;


    // Top and left of the client rectangle are both 0
    GetClientRect(m_hWnd, rcClient);

    if (SUCCEEDED(Result)) then
    begin
        // Calculate the area to display the image
        // Center the image if the client rectangle is larger
        drawRect.left := ((rcClient.right) - m_cxGifImagePixel) / 2.0;
        drawRect.top := ((rcClient.bottom) - m_cyGifImagePixel) / 2.0;
        drawRect.right := drawRect.left + m_cxGifImagePixel;
        drawRect.bottom := drawRect.top + m_cyGifImagePixel;

        // If the client area is resized to be smaller than the image size, scale
        // the image, and preserve the aspect ratio
        aspectRatio := (m_cxGifImagePixel) / (m_cyGifImagePixel);

        if (drawRect.left < 0) then
        begin
            newWidth := (rcClient.right);
            newHeight := newWidth / aspectRatio;
            drawRect.left := 0;
            drawRect.top := ((rcClient.bottom) - newHeight) / 2.0;
            drawRect.right := newWidth;
            drawRect.bottom := drawRect.top + newHeight;
        end;

        if (drawRect.top < 0) then
        begin
            newHeight := (rcClient.bottom);
            newWidth := newHeight * aspectRatio;
            drawRect.left := ((rcClient.right) - newWidth) / 2.0;
            drawRect.top := 0;
            drawRect.right := drawRect.left + newWidth;
            drawRect.bottom := newHeight;
        end;
    end;
end;

{******************************************************************
*                                                                 *
*  TDemoApp.RestoreSavedFrame()                                   *
*                                                                 *
*  Copys the saved frame to the frame in the bitmap render        *
*  target.                                                        *
*                                                                 *
******************************************************************}

function TDemoApp.RestoreSavedFrame: HRESULT;
var
    pFrameToCopyTo: ID2D1Bitmap;
begin
    pFrameToCopyTo := nil;

    if m_pSavedFrame <> nil then
        Result := s_OK
    else
        Result := E_FAIL;


    if (SUCCEEDED(Result)) then
    begin
        Result := m_pFrameComposeRT.GetBitmap(pFrameToCopyTo);
    end;

    if (SUCCEEDED(Result)) then
    begin
        // Copy the whole bitmap
        Result := pFrameToCopyTo.CopyFromBitmap(nil, m_pSavedFrame, nil);
    end;

    SafeRelease(pFrameToCopyTo);
end;

{******************************************************************
*                                                                 *
*  TDemoApp.ClearCurrentFrameArea()                               *
*                                                                 *
*  Clears a rectangular area equal to the area overlaid by the    *
*  current raw frame in the bitmap render target with background  *
*  color.                                                         *
*                                                                 *
******************************************************************}

function TDemoApp.ClearCurrentFrameArea: HResult;
begin
    m_pFrameComposeRT.BeginDraw();
    // Clip the render target to the size of the raw frame
    m_pFrameComposeRT.PushAxisAlignedClip(m_framePosition, D2D1_ANTIALIAS_MODE_PER_PRIMITIVE);
    m_pFrameComposeRT.Clear(m_backgroundColor);
    // Remove the clipping
    m_pFrameComposeRT.PopAxisAlignedClip();
    Result := m_pFrameComposeRT.EndDraw();
end;

{******************************************************************
*                                                                 *
*  TDemoApp.DisposeCurrentFrame()                                 *
*                                                                 *
*  At the end of each delay, disposes the current frame           *
*  based on the disposal method specified.                        *
*                                                                 *
******************************************************************}

function TDemoApp.DisposeCurrentFrame: HResult;
begin
    case (m_uFrameDisposal) of

        DM_UNDEFINED, DM_NONE:
        begin
            // We simply draw on the previous frames. Do nothing here.
        end;
        DM_BACKGROUND:
        begin
            // Dispose background
            // Clear the area covered by the current raw frame with background color
            Result := ClearCurrentFrameArea();
        end;
        DM_PREVIOUS:
        begin
            // Dispose previous
            // We restore the previous composed frame first
            Result := RestoreSavedFrame();
        end;
        else
            // Invalid disposal method
            Result := E_FAIL;
    end;
end;


{******************************************************************
*                                                                 *
*  TDemoApp.OverlayNextFrame()                                    *
*                                                                 *
*  Loads and draws the next raw frame into the composed frame     *
*  render target. This is called after the current frame is       *
*  disposed.                                                      *
*                                                                 *
******************************************************************}
function TDemoApp.OverlayNextFrame: HResult;
begin
    // Get Frame information
    Result := GetRawFrame(m_uNextFrameIndex);
    if (SUCCEEDED(Result)) then
    begin
        // For disposal 3 method, we would want to save a copy of the current
        // composed frame
        if (m_uFrameDisposal = DM_PREVIOUS) then
        begin
            Result := SaveComposedFrame();
        end;
    end;

    if (SUCCEEDED(Result)) then
    begin
        // Start producing the next bitmap
        m_pFrameComposeRT.BeginDraw();

        // If starting a new animation loop
        if (m_uNextFrameIndex = 0) then
        begin
            // Draw background and increase loop count
            m_pFrameComposeRT.Clear(m_backgroundColor);
            Inc(m_uLoopNumber);
        end;

        // Produce the next frame
        m_pFrameComposeRT.DrawBitmap(m_pRawFrame, @m_framePosition);

        Result := m_pFrameComposeRT.EndDraw();
    end;

    // To improve performance and avoid decoding/composing this frame in the
    // following animation loops, the composed frame can be cached here in system
    // or video memory.

    if (SUCCEEDED(Result)) then
    begin
        // Increase the frame index by 1
        Inc(m_uNextFrameIndex);
        m_uNextFrameIndex := m_uNextFrameIndex mod m_cFrames;
    end;
end;


{******************************************************************
*                                                                 *
*  TDemoApp.GetRawFrame()                                         *
*                                                                 *
*  Decodes the current raw frame, retrieves its timing            *
*  information, disposal method, and frame dimension for          *
*  rendering.  Raw frame is the frame read directly from the gif  *
*  file without composing.                                        *
*                                                                 *
******************************************************************}
function TDemoApp.GetRawFrame(uFrameIndex: UINT): HRESULT;
var
    pConverter: IWICFormatConverter;
    pWicFrame: IWICBitmapFrameDecode;
    pFrameMetadataQueryReader: IWICMetadataQueryReader;
    propValue: PROPVARIANT;
    hr: HResult;
begin
    pConverter := nil;
    pWicFrame := nil;
    pFrameMetadataQueryReader := nil;

    ZeroMemory(@propValue, SizeOf(propValue)); //  PropVariantInit();

    // Retrieve the current frame
    hr := m_pDecoder.GetFrame(uFrameIndex, pWicFrame);
    if (SUCCEEDED(hr)) then
    begin
        // Format convert to 32bppPBGRA which D2D expects
        hr := m_pIWICFactory.CreateFormatConverter(pConverter);
    end;

    if (SUCCEEDED(hr)) then
    begin
        hr := pConverter.Initialize(pWicFrame, GUID_WICPixelFormat32bppPBGRA, WICBitmapDitherTypeNone, nil,
            0.0, WICBitmapPaletteTypeCustom);
    end;

    if (SUCCEEDED(hr)) then
    begin
        // Create a D2DBitmap from IWICBitmapSource
        SafeRelease(m_pRawFrame);
        hr := m_pHwndRT.CreateBitmapFromWicBitmap(pConverter, nil, m_pRawFrame);
    end;

    if (SUCCEEDED(hr)) then
    begin
        // Get Metadata Query Reader from the frame
        hr := pWicFrame.GetMetadataQueryReader(pFrameMetadataQueryReader);
    end;

    // Get the Metadata for the current frame
    if (SUCCEEDED(hr)) then
    begin
        hr := pFrameMetadataQueryReader.GetMetadataByName('/imgdesc/Left', propValue);
        if (SUCCEEDED(hr)) then
        begin
            if (propValue.vt = VT_UI2) then
                hr := S_OK
            else
                hr := E_FAIL;
            if (SUCCEEDED(hr)) then
            begin
                m_framePosition.left := (propValue.uiVal);
            end;
            PropVariantClear(propValue);
        end;
    end;

    if (SUCCEEDED(hr)) then
    begin
        hr := pFrameMetadataQueryReader.GetMetadataByName('/imgdesc/Top', &propValue);
        if (SUCCEEDED(hr)) then
        begin
            if (propValue.vt = VT_UI2) then
                hr := S_OK
            else
                hr := E_FAIL;
            if (SUCCEEDED(hr)) then
            begin
                m_framePosition.top := (propValue.uiVal);
            end;
            PropVariantClear(propValue);
        end;
    end;

    if (SUCCEEDED(hr)) then
    begin
        hr := pFrameMetadataQueryReader.GetMetadataByName('/imgdesc/Width', propValue);
        if (SUCCEEDED(hr)) then
        begin
            if (propValue.vt = VT_UI2) then
                hr := S_OK
            else
                hr := E_FAIL;
            if (SUCCEEDED(hr)) then
            begin
                m_framePosition.right := (propValue.uiVal) + m_framePosition.left;
            end;
            PropVariantClear(propValue);
        end;
    end;

    if (SUCCEEDED(hr)) then
    begin
        hr := pFrameMetadataQueryReader.GetMetadataByName('/imgdesc/Height', &propValue);
        if (SUCCEEDED(hr)) then
        begin
            if (propValue.vt = VT_UI2) then
                hr := S_OK
            else
                hr := E_FAIL;
            if (SUCCEEDED(hr)) then
            begin
                m_framePosition.bottom := (propValue.uiVal) + m_framePosition.top;
            end;
            PropVariantClear(propValue);
        end;
    end;

    if (SUCCEEDED(hr)) then
    begin
        // Get delay from the optional Graphic Control Extension
        if (SUCCEEDED(pFrameMetadataQueryReader.GetMetadataByName('/grctlext/Delay', propValue))) then
        begin
            if (propValue.vt = VT_UI2) then
                hr := S_OK
            else
                hr := E_FAIL;
            if (SUCCEEDED(hr)) then
            begin
                // Convert the delay retrieved in 10 ms units to a delay in 1 ms units
                //  hr := UIntMult(propValue.uiVal, 10, m_uFrameDelay);
                m_uFrameDelay := propValue.uiVal * 10;
            end;
            PropVariantClear(&propValue);
        end
        else
        begin
            // Failed to get delay from graphic control extension. Possibly a
            // single frame image (non-animated gif)
            m_uFrameDelay := 0;
        end;

        if (SUCCEEDED(hr)) then
        begin
            // Insert an artificial delay to ensure rendering for gif with very small
            // or 0 delay.  This delay number is picked to match with most browsers'
            // gif display speed.

            // This will defeat the purpose of using zero delay intermediate frames in
            // order to preserve compatibility. If this is removed, the zero delay
            // intermediate frames will not be visible.
            if (m_uFrameDelay < 90) then
            begin
                m_uFrameDelay := 90;
            end;
        end;
    end;

    if (SUCCEEDED(hr)) then
    begin
        if (SUCCEEDED(pFrameMetadataQueryReader.GetMetadataByName('/grctlext/Disposal', propValue))) then
        begin
            if (propValue.vt = VT_UI1) then
                hr := S_OK
            else
                hr := E_FAIL;
            if (SUCCEEDED(hr)) then
            begin
                m_uFrameDisposal := TDISPOSAL_METHODS(propValue.bVal);
            end;
        end
        else
        begin
            // Failed to get the disposal method, use default. Possibly a
            // non-animated gif.
            m_uFrameDisposal := DM_UNDEFINED;
        end;
    end;

    PropVariantClear(propValue);

    SafeRelease(pConverter);
    SafeRelease(pWicFrame);
    SafeRelease(pFrameMetadataQueryReader);

    Result := hr;
end;


{******************************************************************
*                                                                 *
*  TDemoApp.SaveComposedFrame()                                   *
*                                                                 *
*  Saves the current composed frame in the bitmap render target   *
*  into a temporary bitmap. Initializes the temporary bitmap if   *
*  needed.                                                        *
*                                                                 *
******************************************************************}
function TDemoApp.SaveComposedFrame: HResult;
var
    pFrameToBeSaved: ID2D1Bitmap;
    bitmapSize: TD2D1_SIZE_U;
    bitmapProp: TD2D1_BITMAP_PROPERTIES;
begin
    Result := S_OK;

    pFrameToBeSaved := nil;

    Result := m_pFrameComposeRT.GetBitmap(pFrameToBeSaved);
    if (SUCCEEDED(Result)) then
    begin
        // Create the temporary bitmap if it hasn't been created yet
        if (m_pSavedFrame = nil) then
        begin
            bitmapSize := pFrameToBeSaved.GetPixelSize();
            pFrameToBeSaved.GetDpi(bitmapProp.dpiX, bitmapProp.dpiY);
            bitmapProp.pixelFormat := pFrameToBeSaved.GetPixelFormat();

            Result := m_pFrameComposeRT.CreateBitmap(bitmapSize, nil, 0, @bitmapProp, m_pSavedFrame);
        end;
    end;

    if (SUCCEEDED(Result)) then
    begin
        // Copy the whole bitmap
        Result := m_pSavedFrame.CopyFromBitmap(nil, pFrameToBeSaved, nil);
    end;

    SafeRelease(pFrameToBeSaved);
end;

{******************************************************************
*                                                                 *
*  TDemoApp.ComposeNextFrame()                                    *
*                                                                 *
*  Composes the next frame by first disposing the current frame   *
*  and then overlaying the next frame. More than one frame may    *
*  be processed in order to produce the next frame to be          *
*  displayed due to the use of zero delay intermediate frames.    *
*  Also, sets a timer that is equal to the delay of the frame.    *
*                                                                 *
******************************************************************}

function TDemoApp.ComposeNextFrame: HResult;
begin
    Result := S_OK;

    // Check to see if the render targets are initialized
    if (m_pHwndRT <> nil) and (m_pFrameComposeRT <> nil) then
    begin
        // First, kill the timer since the delay is no longer valid
        KillTimer(m_hWnd, DELAY_TIMER_ID);

        // Compose one frame
        Result := DisposeCurrentFrame();
        if (SUCCEEDED(Result)) then
        begin
            Result := OverlayNextFrame();
        end;

        // Keep composing frames until we see a frame with delay greater than
        // 0 (0 delay frames are the invisible intermediate frames), or until
        // we have reached the very last frame.
        while (SUCCEEDED(Result) and (m_uFrameDelay = 0) and not IsLastFrame()) do
        begin
            Result := DisposeCurrentFrame();
            if (SUCCEEDED(Result)) then
            begin
                Result := OverlayNextFrame();
            end;
        end;

        // If we have more frames to play, set the timer according to the delay.
        // Set the timer regardless of whether we succeeded in composing a frame
        // to try our best to continue displaying the animation.
        if (not EndOfAnimation) and (m_cFrames > 1) then
        begin
            // Set the timer according to the delay
            SetTimer(m_hWnd, DELAY_TIMER_ID, m_uFrameDelay, nil);
        end;
    end;
end;



function TDemoApp.IsLastFrame: boolean;
begin
    Result := (m_uNextFrameIndex = 0);
end;



function TDemoApp.EndOfAnimation: boolean;
begin
    Result := m_fHasLoop and IsLastFrame() and (m_uLoopNumber = m_uTotalLoopCount + 1);
end;


{******************************************************************
*                                                                 *
*  TDemoApp.RecoverDeviceResources                                *
*                                                                 *
*  Discards device-specific resources and recreates them.         *
*  Also starts the animation from the beginning.                  *
*                                                                 *
******************************************************************}
function TDemoApp.RecoverDeviceResources: HResult;
begin
    SafeRelease(m_pHwndRT);
    SafeRelease(m_pFrameComposeRT);
    SafeRelease(m_pSavedFrame);

    m_uNextFrameIndex := 0;
    m_uFrameDisposal := DM_NONE;  // No previous frames. Use disposal none.
    m_uLoopNumber := 0;

    Result := CreateDeviceResources();
    if (SUCCEEDED(Result)) then
    begin
        if (m_cFrames > 0) then
        begin
            // Load the first frame
            Result := ComposeNextFrame();
            InvalidateRect(m_hWnd, nil, False);
        end;
    end;
end;

{******************************************************************
*                                                                 *
*  TDemoApp.GetGlobalMetadata()                                   *
*                                                                 *
*  Retrieves global metadata which pertains to the entire image.  *
*                                                                 *
******************************************************************}

function TDemoApp.GetGlobalMetadata: HRESULT;
var
    propValue: PROPVARIANT;
    pMetadataQueryReader: IWICMetadataQueryReader;
    uPixelAspRatio: UINT;
    pixelAspRatio: single;
begin
    ZeroMemory(@propValue, SizeOf(propValue)); // PropVariantInit(propValue);
    pMetadataQueryReader := nil;

    // Get the frame count
    Result := m_pDecoder.GetFrameCount(m_cFrames);
    if (SUCCEEDED(Result)) then
    begin
        // Create a MetadataQueryReader from the decoder
        Result := m_pDecoder.GetMetadataQueryReader(pMetadataQueryReader);
    end;

    if (SUCCEEDED(Result)) then
    begin
        // Get background color
        if (FAILED(GetBackgroundColor(pMetadataQueryReader))) then
        begin
            // Default to transparent if failed to get the color
            m_backgroundColor := DX12.D2D1.ColorF(0, 0.0);
        end;
    end;

    // Get global frame size
    if (SUCCEEDED(Result)) then
    begin
        // Get width
        Result := pMetadataQueryReader.GetMetadataByName('/logscrdesc/Width', propValue);
        if (SUCCEEDED(Result)) then
        begin
            if (propValue.vt = VT_UI2) then
                Result := S_OK
            else
                Result := E_FAIL;

            if (SUCCEEDED(Result)) then
            begin
                m_cxGifImage := propValue.uiVal;
            end;
            PropVariantClear(propValue);
        end;
    end;

    if (SUCCEEDED(Result)) then
    begin
        // Get height
        Result := pMetadataQueryReader.GetMetadataByName('/logscrdesc/Height', propValue);
        if (SUCCEEDED(Result)) then
        begin
            if (propValue.vt = VT_UI2) then
                Result := S_OK
            else
                Result := E_FAIL;

            if (SUCCEEDED(Result)) then
            begin
                m_cyGifImage := propValue.uiVal;
            end;
            PropVariantClear(propValue);
        end;
    end;

    if (SUCCEEDED(Result)) then
    begin
        // Get pixel aspect ratio
        Result := pMetadataQueryReader.GetMetadataByName('/logscrdesc/PixelAspectRatio', propValue);
        if (SUCCEEDED(Result)) then
        begin
            if (propValue.vt = VT_UI1) then
                Result := S_OK
            else
                Result := E_FAIL;

            if (SUCCEEDED(Result)) then
            begin
                uPixelAspRatio := propValue.bVal;


                if (uPixelAspRatio <> 0) then
                begin
                    // Need to calculate the ratio. The value in uPixelAspRatio
                    // allows specifying widest pixel 4:1 to the tallest pixel of
                    // 1:4 in increments of 1/64th
                    pixelAspRatio := (uPixelAspRatio + 15.0) / 64.0;

                    // Calculate the image width and height in pixel based on the
                    // pixel aspect ratio. Only shrink the image.
                    if (pixelAspRatio > 1.0) then
                    begin
                        m_cxGifImagePixel := m_cxGifImage;
                        m_cyGifImagePixel := Trunc(m_cyGifImage / pixelAspRatio);
                    end
                    else
                    begin
                        m_cxGifImagePixel := Trunc(m_cxGifImage * pixelAspRatio);
                        m_cyGifImagePixel := m_cyGifImage;
                    end;
                end
                else
                begin
                    // The value is 0, so its ratio is 1
                    m_cxGifImagePixel := m_cxGifImage;
                    m_cyGifImagePixel := m_cyGifImage;
                end;
            end;
            PropVariantClear(propValue);
        end;
    end;

    // Get looping information
    if (SUCCEEDED(Result)) then
    begin
        // First check to see if the application block in the Application Extension
        // contains "NETSCAPE2.0" and "ANIMEXTS1.0", which indicates the gif animation
        // has looping information associated with it.

        // If we fail to get the looping information, loop the animation infinitely.
        if (SUCCEEDED(pMetadataQueryReader.GetMetadataByName('/appext/application', propValue)) and
            (propValue.vt = (VT_UI1 or VT_VECTOR)) and (propValue.caub.cElems = 11) and  // Length of the application block
            (not CompareMem(propValue.caub.pElems, PAnsiChar('NETSCAPE2.0'), propValue.caub.cElems) or not
            CompareMem(propValue.caub.pElems, PAnsiChar('ANIMEXTS1.0'), propValue.caub.cElems))) then
        begin
            PropVariantClear(propValue);

            Result := pMetadataQueryReader.GetMetadataByName('/appext/data', propValue);
            if (SUCCEEDED(Result)) then
            begin
                //  The data is in the following format:
                //  byte 0: extsize (must be > 1)
                //  byte 1: loopType (1 = animated gif)
                //  byte 2: loop count (least significant byte)
                //  byte 3: loop count (most significant byte)
                //  byte 4: set to zero
                if ((propValue.vt = (VT_UI1 or VT_VECTOR)) and (propValue.caub.cElems >= 4) and
                    (propValue.caub.pElems[0] > 0) and (propValue.caub.pElems[1] = 1)) then
                begin
                    m_uTotalLoopCount := MAKEWORD(propValue.caub.pElems[2], propValue.caub.pElems[3]);

                    // If the total loop count is not zero, we then have a loop count
                    // If it is 0, then we repeat infinitely
                    if (m_uTotalLoopCount <> 0) then
                    begin
                        m_fHasLoop := True;
                    end;
                end;
            end;
        end;
    end;

    PropVariantClear(propValue);
    SafeRelease(pMetadataQueryReader);
end;


   {******************************************************************
*                                                                 *
*  TDemoApp.GetBackgroundColor()                                  *
*                                                                 *
*  Reads and stores the background color for gif.                 *
*                                                                 *
******************************************************************}
function TDemoApp.GetBackgroundColor(pMetadataQueryReader: IWICMetadataQueryReader): HResult;
var

    dwBGColor: DWORD;

    backgroundIndex: byte;
    rgColors: array [0..255] of TWICColor;
    p: PWICColor;

    cColorsCopied: UINT;
    lPropVariant: PROPVARIANT;
    pWicPalette: IWICPalette;
    alpha: single;
begin

    backgroundIndex := 0;

    cColorsCopied := 0;

    ZeroMemory(@lPropVariant, SizeOf(lPropVariant));     //    PropVariantInit(&propVariant);
    pWicPalette := nil;

    // If we have a global palette, get the palette and background color
    Result := pMetadataQueryReader.GetMetadataByName('/logscrdesc/GlobalColorTableFlag', lPropVariant);
    if (SUCCEEDED(Result)) then
    begin
        if (lPropVariant.vt <> VT_BOOL) or not (lPropVariant.boolVal) then
            Result := E_FAIL
        else
            Result := S_OK;
        PropVariantClear(lPropVariant);
    end;

    if (SUCCEEDED(Result)) then
    begin
        // Background color index
        Result := pMetadataQueryReader.GetMetadataByName('/logscrdesc/BackgroundColorIndex', lPropVariant);
        if (SUCCEEDED(Result)) then
        begin
            if (lPropVariant.vt <> VT_UI1) then
                Result := E_FAIL
            else
                Result := S_OK;
            if (SUCCEEDED(Result)) then
            begin
                backgroundIndex := lPropVariant.bVal;
            end;
            PropVariantClear(lPropVariant);
        end;
    end;

    // Get the color from the palette
    if (SUCCEEDED(Result)) then
    begin
        Result := m_pIWICFactory.CreatePalette(pWicPalette);
    end;

    if (SUCCEEDED(Result)) then
    begin
        // Get the global palette
        Result := m_pDecoder.CopyPalette(pWicPalette);
    end;

    if (SUCCEEDED(Result)) then
    begin
        P := @rgColors[0];
        Result := pWicPalette.GetColors(Length(rgColors), p, cColorsCopied);
    end;

    if (SUCCEEDED(Result)) then
    begin
        // Check whether background color is outside range
        if (backgroundIndex >= cColorsCopied) then
            Result := E_FAIL
        else
            Result := S_OK;
    end;

    if (SUCCEEDED(Result)) then
    begin
        // Get the color in ARGB format
        dwBGColor := rgColors[backgroundIndex];

        // The background color is in ARGB format, and we want to
        // extract the alpha value and convert it in FLOAT
        alpha := (dwBGColor shr 24) / 255.0;
        m_backgroundColor := DX12.D2D1.ColorF(dwBGColor, alpha);
    end;

    SafeRelease(pWicPalette);
end;


{******************************************************************
*                                                                 *
*  TDemoApp.SelectAndDisplayGif()                                 *
*                                                                 *
*  Opens a dialog and displays a selected image.                  *
*                                                                 *
******************************************************************}
function TDemoApp.SelectAndDisplayGif: HResult;
var
    rcClient, rcWindow: TRECT;
    szFileName: WideString;
begin
    Result := S_OK;
    // If the user cancels selection, then nothing happens
    if {OpenDialog1.Execute} True then
    begin
        // szFileName:=OpenDialog1.FileName;
        szFileName := 'sample.gif';
        // Reset the states
        m_uNextFrameIndex := 0;
        m_uFrameDisposal := DM_NONE;  // No previous frame, use disposal none
        m_uLoopNumber := 0;
        m_fHasLoop := False;
        SafeRelease(m_pSavedFrame);

        // Create a decoder for the gif file
        SafeRelease(m_pDecoder);
        Result := m_pIWICFactory.CreateDecoderFromFilename(pWideChar(szFileName), nil, GENERIC_READ,
            WICDecodeMetadataCacheOnLoad, m_pDecoder);
        if (SUCCEEDED(Result)) then
        begin
            Result := GetGlobalMetadata();
        end;

        if (SUCCEEDED(Result)) then
        begin
            rcClient.right := m_cxGifImagePixel;
            rcClient.bottom := m_cyGifImagePixel;

            if (not AdjustWindowRect(rcClient, WS_OVERLAPPEDWINDOW, True)) then
            begin
                // result := HRESULT_FROM_WIN32(GetLastError());
            end;
        end;

        if (SUCCEEDED(Result)) then
        begin
            // Get the upper left corner of the current window
            GetWindowRect(m_hWnd, rcWindow);
        end;

        if (SUCCEEDED(Result)) then
        begin
            // Resize the window to fit the gif
            MoveWindow(
                m_hWnd,
                rcWindow.left,
                rcWindow.top,
                RectWidth(rcClient),
                RectHeight(rcClient),
                True);

            Result := CreateDeviceResources();
        end;

        if (SUCCEEDED(Result)) then
        begin
            // If we have at least one frame, start playing
            // the animation from the first frame
            if (m_cFrames > 0) then
            begin
                Result := ComposeNextFrame();
                InvalidateRect(m_hWnd, nil, False);
            end;
        end;
    end;
end;



function TDemoApp.OnResize(uWidth: UINT; uHeight: UINT): HResult;
var
    size: TD2D1_SIZE_U;
begin
    if (m_pHwndRT <> nil) then
    begin
        size.Width := uWidth;
        size.Height := uHeight;
        m_pHwndRT.Resize(@size);
    end;
end;


end.

















