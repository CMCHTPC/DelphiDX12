unit TextAnimation;


{$mode delphi}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D2D1, DX12.DWrite, DX12.DCommon, DX12.DXGI,
    RingBuffer;

const
    D2DERR_RECREATE_TARGET = $8899000C;

type
    TAnimationStyle = (
        None = 0,
        Translation = 1,
        Rotation = 2,
        Scaling = 4);

    TTextRenderingMethod = (
        Default,
        Outline,
        UseA8Target,
        NumValues
        );

type

    { TDemoApp }

    TDemoApp = class(TObject)
    private
        m_startTime: DWORD;
        m_overhangOffset: TD2D1_POINT_2F;
        m_hwnd: HWND;
        m_pD2DFactory: ID2D1Factory;
        m_pDWriteFactory: IDWriteFactory;
        m_pRT: ID2D1HwndRenderTarget;
        m_pTextFormat: IDWriteTextFormat;
        m_pTextLayout: IDWriteTextLayout;
        m_pBlackBrush: ID2D1SolidColorBrush;
        m_pOpacityRT: ID2D1BitmapRenderTarget;
        m_fRunning: boolean;
        FWndProcPointer: Pointer;
        msc_fontName: PWideChar;
        msc_fontSize: single;
        sc_helloWorld: PWideChar;
        stringLength: UINT;
        m_animationStyle: UINT32;
        m_renderingMethod: UINT32;
        sc_lastTimeStatusShown: LONGLONG;

        m_times: TRingBuffer;
        FInstance: THandle;

    private
        function CreateDeviceIndependentResources(): HResult;
        function CreateDeviceResources(): HResult;
        procedure DiscardDeviceResources();
        function OnRender(): HResult;
        procedure OnResize(Width: UINT; Height: UINT);
        function IsRunning: boolean;
        procedure UpdateWindowText();
        function ResetAnimation(resetClock: boolean): HRESULT;
        procedure CalculateTransform(var pTransform: TD2D1_MATRIX_3X2_F);
        function OnChar(key: char): HRESULT;
        procedure OnDestroy();
    protected
        function WndProc(Handle: HWND; umessage: UINT; wpara: wparam; lpara: lparam): LRESULT; stdcall;
    public
        constructor Create;
        destructor Destroy; override;
        function Initialize(): HResult;
        procedure RunMessageLoop();
    end;


function GetModuleHandleExW(dwFlags: DWORD; lpModuleName: LPCWSTR; var phModule: HMODULE): BOOL; stdcall;
    external kernel32 Name 'GetModuleHandleExW';

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

{ TDemoApp }

{/******************************************************************
*                                                                 *
*  DemoApp.CreateDeviceIndependentResources                      *
*                                                                 *
*  This method is used to create resources which are not bound    *
*  to any device. Their lifetime effectively extends for the      *
*  duration of the app. These resources include the D2D,          *
*  DWrite factories; and a DWrite Text Format object              *
*  (used for identifying particular font characteristics) and     *
*  a D2D geometry.                                                *
*                                                                 *
******************************************************************/}
function TDemoApp.CreateDeviceIndependentResources: HResult;
var
    pTypography: IDWriteTypography;
    hr: HRESULT;
    fontFeature: TDWRITE_FONT_FEATURE;
    textRange: TDWRITE_TEXT_RANGE;
    pFactoryOptions: TD2D1_FACTORY_OPTIONS;
    s: WideString;
begin
    msc_fontName := 'Gabriola';
    msc_fontSize := 50.0;
    s := 'The quick brown fox jumped over the lazy dog!';
    sc_helloWorld := PWideChar(s);
    stringLength := length(s) - 1;

    pFactoryOptions.debugLevel := D2D1_DEBUG_LEVEL_ERROR;
    //create D2D factory
    hr := D2D1CreateFactory(D2D1_FACTORY_TYPE_SINGLE_THREADED, ID2D1Factory, @pFactoryOptions, m_pD2DFactory);
    if (SUCCEEDED(hr)) then
    begin
        //create DWrite factory
        hr := DWriteCreateFactory(DWRITE_FACTORY_TYPE_ISOLATED, //DWRITE_FACTORY_TYPE_SHARED
            IDWriteFactory, m_pDWriteFactory);
    end;

    if (SUCCEEDED(hr)) then
    begin
        //create DWrite text format object
        hr := m_pDWriteFactory.CreateTextFormat(msc_fontName, nil, DWRITE_FONT_WEIGHT_NORMAL, DWRITE_FONT_STYLE_NORMAL,
            DWRITE_FONT_STRETCH_NORMAL, msc_fontSize, '', //locale
            m_pTextFormat);
    end;
    if (SUCCEEDED(hr)) then
    begin
        //center the text horizontally
        m_pTextFormat.SetTextAlignment(DWRITE_TEXT_ALIGNMENT_CENTER);

        hr := m_pDWriteFactory.CreateTextLayout(sc_helloWorld, stringLength, m_pTextFormat, 300, // maxWidth
            1000, // maxHeight
            m_pTextLayout);
    end;
    if (SUCCEEDED(hr)) then
    begin

        // We use typographic features here to show how to account for the
        // overhangs that these features will produce. See the code in
        // ResetAnimation that calls GetOverhangMetrics(). Note that there are
        // fonts that can produce overhangs even without the use of typographic
        // features- this is just one example.

        pTypography := nil;
        hr := m_pDWriteFactory.CreateTypography(&pTypography);
        if (SUCCEEDED(hr)) then
        begin
            fontFeature.nameTag := DWRITE_FONT_FEATURE_TAG_STYLISTIC_SET_7;
            fontFeature.parameter := 1;
            hr := pTypography.AddFontFeature(fontFeature);
            if (SUCCEEDED(hr)) then
            begin
                textRange.startPosition := 0;
                textRange.length := stringLength;
                hr := m_pTextLayout.SetTypography(pTypography, textRange);
            end;
            pTypography := nil;
        end;
    end;
    Result := hr;
end;


{/******************************************************************
*                                                                 *
*  DemoApp.CreateDeviceResources                                 *
*                                                                 *
*  This method creates resources which are bound to a particular  *
*  D3D device. It's all centralized here, in case the resources   *
*  need to be recreated in case of D3D device loss (eg. display   *
*  change, remoting, removal of video card, etc).                 *
*                                                                 *
******************************************************************/}
function TDemoApp.CreateDeviceResources: HResult;
var
    hr: HResult;
    rc: TRECT;
    size: TD2D1_SIZE_U;
    ap: TD2D1_RENDER_TARGET_PROPERTIES;
    ap2: TD2D1_HWND_RENDER_TARGET_PROPERTIES;
    x, y: single;
begin
    hr := S_OK;
    if (m_pRT = nil) then
    begin
        GetClientRect(m_hwnd, rc);
        size := DX12.D2D1.SizeU(rc.right - rc.left, rc.bottom - rc.top);
        // Create a D2D render target

        // Note: we only use D2D1_PRESENT_OPTIONS_IMMEDIATELY so that we can
        // easily measure the framerate. Most apps should not use this
        // flag.
        ap := DX12.D2D1.RenderTargetProperties(DX12.D2D1.PixelFormat());
        ap.dpiX := 0;
        ap.dpiY := 0;
        ap2 := DX12.D2D1.HwndRenderTargetProperties(m_hwnd, size, D2D1_PRESENT_OPTIONS_IMMEDIATELY);
        m_pD2DFactory.GetDesktopDpi(x, y);
        hr := m_pD2DFactory.CreateHwndRenderTarget(ap, ap2, m_pRT);
        if (SUCCEEDED(hr)) then
        begin
            // Nothing in this sample requires antialiasing so we set the antialias
            // mode to aliased up front.
            m_pRT.SetAntialiasMode(D2D1_ANTIALIAS_MODE_ALIASED);
            //create a black brush
            hr := m_pRT.CreateSolidColorBrush(DX12.D2D1.ColorF(DX12.D2D1.Black), nil, m_pBlackBrush);
        end;
        if (SUCCEEDED(hr)) then
        begin
            hr := ResetAnimation(True // resetClock
                );
        end;
    end;
    Result := hr;
end;


{/******************************************************************
*                                                                 *
*  DemoApp.DiscardDeviceResources                                *
*                                                                 *
*  Discard device-specific resources which need to be recreated   *
*  when a D3D device is lost                                      *
*                                                                 *
******************************************************************/}
procedure TDemoApp.DiscardDeviceResources;
begin
    SafeRelease(m_pRT);
    SafeRelease(m_pBlackBrush);
    SafeRelease(m_pOpacityRT);
end;


{/******************************************************************
*                                                                 *
*  DemoApp.OnRender                                              *
*                                                                 *
*  Called whenever the application needs to display the client    *
*  window.                                                        *
*                                                                 *
*  Note that this function will not render anything if the window *
*  is occluded (e.g. when the screen is locked).                  *
*  Also, this function will automatically discard device-specific *
*  resources if the D3D device disappears during function         *
*  invocation, and will recreate the resources the next time it's *
*  invoked.                                                       *
*                                                                 *
******************************************************************/}
function TDemoApp.OnRender: HResult;
var
    time: TLargeInteger;
    transform: TD2D1_MATRIX_3X2_F;
    textMetrics: TDWRITE_TEXT_METRICS;
    opacityRTSize: TD2D1_SIZE_F;
    offset: TD2D1_POINT_2F;
    dpiX: single;
    dpiY: single;
    roundedOffset: TD2D1_POINT_2F;
    destinationRect: TD2D1_RECT_F;
    pBitmap: ID2D1Bitmap;
begin
    // We use a ring buffer to store the clock time for the last 10 frames.
    // This lets us eliminate a lot of noise when computing framerate.
    QueryPerformanceCounter(time);
    m_times.Add(time);
    Result := CreateDeviceResources();
    if (SUCCEEDED(Result) and not (Ord(m_pRT.CheckWindowState) and Ord(D2D1_WINDOW_STATE_OCCLUDED) = Ord(D2D1_WINDOW_STATE_OCCLUDED))) then
    begin
        CalculateTransform(transform);
        m_pRT.BeginDraw();
        m_pRT.Clear(DX12.D2D1.ColorF(DX12.D2D1.White));
        m_pRT.SetTransform(transform);
        m_pTextLayout.GetMetrics(textMetrics);
        if (m_renderingMethod = Ord(TTextRenderingMethod.UseA8Target)) then
        begin
            // Offset the destination rect such that the text will be centered
            // on the render target. Given that we have offset the text in the
            // A8 target by the overhang offset, we must factor that into the
            // destination rect now.
            opacityRTSize := m_pOpacityRT.GetSize;
            offset := DX12.D2D1.Point2F(-textMetrics.Width / 2.0 - m_overhangOffset.x, -textMetrics.Height / 2.0 - m_overhangOffset.y);
            // Round the offset to the nearest pixel. Note that the rounding
            // done here is unecessary, but it causes the text to be less
            // blurry.
            m_pRT.GetDpi(dpiX, dpiY);
            roundedOffset := DX12.D2D1.Point2F((offset.x * dpiX / 96.0 + 0.5) * 96.0 / dpiX, (offset.y * dpiY / 96.0 + 0.5) * 96.0 / dpiY);
            destinationRect := DX12.D2D1.RectF(roundedOffset.x, roundedOffset.y, roundedOffset.x + opacityRTSize.Width,
                roundedOffset.y + opacityRTSize.Height);
            pBitmap := nil;
            m_pOpacityRT.GetBitmap(pBitmap);
            pBitmap.GetDpi(dpiX, dpiY);
            // The antialias mode must be set to D2D1_ANTIALIAS_MODE_ALIASED
            // for this method to succeed. We've set this mode already though
            // so no need to do it again.
            m_pRT.FillOpacityMask(
                pBitmap,
                m_pBlackBrush,
                D2D1_OPACITY_MASK_CONTENT_TEXT_NATURAL, @destinationRect
                );
            pBitmap := nil;
        end
        else
        begin
            // Disable pixel snapping to get a smoother animation.
            m_pRT.DrawTextLayout(
                DX12.D2D1.Point2F(-textMetrics.Width / 2.0, -textMetrics.Height / 2.0),
                m_pTextLayout,
                m_pBlackBrush,
                D2D1_DRAW_TEXT_OPTIONS_NO_SNAP
                );
        end;
        Result := m_pRT.EndDraw();
        if (Result = D2DERR_RECREATE_TARGET) then
        begin
            Result := S_OK;
            DiscardDeviceResources();
        end;
        // To animate as quickly as possible, we request another WM_PAINT
        // immediately.
        InvalidateRect(m_hwnd, nil, False);
    end;
    UpdateWindowText();
end;


{/******************************************************************
*                                                                 *
*  DemoApp.OnResize                                              *
*                                                                 *
*  If the application receives a WM_SIZE message, this method     *
*  resizes the render target appropriately.                       *
*                                                                 *
******************************************************************/}

procedure TDemoApp.OnResize(Width: UINT; Height: UINT);
var
    size: TD2D1_SIZE_U;
begin
    if (m_pRT <> nil) then
    begin
        size.Width := Width;
        size.Height := Height;
        // Note: This method can fail, but it's okay to ignore the
        // error here -- it will be repeated on the next call to
        // EndDraw.
        m_pRT.Resize(@size);
    end;
end;



function TDemoApp.IsRunning: boolean;
begin
    Result := m_fRunning;
end;


{/******************************************************************
*                                                                 *
*  DemoApp.UpdateWindowText                                      *
*                                                                 *
*  This method updates the window title bar with info about the   *
*  current animation style and rendering method. It also outputs  *
*  the framerate.                                                 *
*                                                                 *
******************************************************************/}
procedure TDemoApp.UpdateWindowText;
var
    frequency: TLargeInteger;
    fps: single;
    style: PWideChar;
    method: PWideChar;
    title: PChar;
    lCount: integer;
    lLast, lFirst: LOngLong;
    lDiff: LongLong;
begin
    // Update the window status no more than 10 times a second. Without this
    // check, the performance bottleneck could potentially be the time it takes
    // for Windows to update the title.
    if (m_times.GetCount() > 0) and (m_times.GetLast() > sc_lastTimeStatusShown + 1000000) then
    begin
        // Determine the frame rate by computing the difference in clock time
        // between this frame and the frame we rendered 10 frames ago.
        sc_lastTimeStatusShown := m_times.GetLast();
        QueryPerformanceFrequency(frequency);
        fps := 0.0;
        lCount := m_times.GetCount;
        if (lCount > 0) then
        begin
            lLast := m_times.GetLast;
            lFirst := m_times.GetFirst;
            lDiff := lLast - lFirst;
            if lDiff <> 0 then
                fps := (lCount - 1) * frequency / (lDiff);
        end;
        // Add other useful information to the window title.
        case (m_animationStyle) of
            Ord(TAnimationStyle.None):
                style := 'None';
            Ord(TAnimationStyle.Translation):
                style := 'Translation';
            Ord(TAnimationStyle.Rotation):
                style := 'Rotation';
            Ord(TAnimationStyle.Scaling):
                style := 'Scale';
        end;

        case (m_renderingMethod) of
            Ord(TTextRenderingMethod.Default):
                method := 'Default';
            Ord(TTextRenderingMethod.Outline):
                method := 'Outline';
            Ord(TTextRenderingMethod.UseA8Target):
                method := 'UseA8Target';
        end;

        title := PChar('AnimationStyle: ' + FloatToStrF(fps, ffNumber, 8, 1));
        {
        StringCchPrintf(
            title,
            ARRAYSIZE(title),
            'AnimationStyle: %s%s%s, Method: %s, %#.1f fps',
            (m_animationStyle & AnimationStyle.Translation) ? L'+t' : L'-t',
            (m_animationStyle & AnimationStyle.Rotation) ? L'+r' : L'-r',
            (m_animationStyle & AnimationStyle.Scaling) ? L'+s' : L'-s',
            method,
            fps
            );
        }

        SetWindowText(m_hwnd, title);
    end;
end;


{/******************************************************************
*                                                                 *
*  DemoApp.ResetAnimation                                        *
*                                                                 *
*  This method does the necessary work to change the current      *
*  animation style.                                               *
*                                                                 *
******************************************************************/}
function TDemoApp.ResetAnimation(resetClock: boolean): HRESULT;
var
    pDefaultParams: IDWriteRenderingParams;
    pRenderingParams: IDWriteRenderingParams;
    dpiX: single;
    dpiY: single;
    overhangMetrics: TDWRITE_OVERHANG_METRICS;
    padding: TD2D1_SIZE_F;
    maskSize: TD2D1_SIZE_F;

    maskPixelSize: TD2D1_SIZE_U;
    alphaOnlyFormat: TD2D1_PIXEL_FORMAT;
begin
    Result := S_OK;
    if (resetClock) then
    begin
        m_startTime := GetTickCount();
    end;
    // Release the opacity mask. We will regenerate it if the current animation
    // style demands it.
    SafeRelease(m_pOpacityRT);
    if (m_renderingMethod = Ord(TTextRenderingMethod.Outline)) then
    begin
        // Set the rendering mode to OUTLINE mode. To do this we first create
        // a default params object and then make a copy with the given modification.
        pDefaultParams := nil;
        Result := m_pDWriteFactory.CreateRenderingParams(pDefaultParams);
        if (SUCCEEDED(Result)) then
        begin
            pRenderingParams := nil;
            Result := m_pDWriteFactory.CreateCustomRenderingParams(pDefaultParams.GetGamma(),
                pDefaultParams.GetEnhancedContrast(), pDefaultParams.GetClearTypeLevel(), pDefaultParams.GetPixelGeometry(),
                DWRITE_RENDERING_MODE_OUTLINE, pRenderingParams);
            if (SUCCEEDED(Result)) then
            begin
                m_pRT.SetTextRenderingParams(pRenderingParams);
                pRenderingParams := nil;
            end;
            pDefaultParams := nil;
        end;
    end
    else
    begin
        // Reset the rendering mode to default.
        m_pRT.SetTextRenderingParams(nil);
    end;

    if (SUCCEEDED(Result) and (m_renderingMethod = Ord(TTextRenderingMethod.UseA8Target))) then
    begin
        // Create a compatible A8 Target to store the text as an opacity mask.
        // Note: To reduce sampling error in the scale animation, it might be
        //       preferable to create multiple masks for the text at different
        //       resolutions.
        m_pRT.GetDpi(dpiX, dpiY);
        // It is important to obtain the overhang metrics here in case the text
        // extends beyond the layout max-width and max-height.
        m_pTextLayout.GetOverhangMetrics(&overhangMetrics);
        // Because the overhang metrics can be off slightly given that these
        // metrics do not account for antialiasing, we add an extra pixel for
        // padding.
        padding := DX12.D2D1.SizeF(96.0 / dpiX, 96.0 / dpiY);
        m_overhangOffset := DX12.D2D1.Point2F(trunc(overhangMetrics.left + padding.Width), trunc(overhangMetrics.top + padding.Height));
        // The true width of the text is the max width + the overhang
        // metrics + padding in each direction.
        maskSize := DX12.D2D1.SizeF(overhangMetrics.right + padding.Width + m_overhangOffset.x + m_pTextLayout.GetMaxWidth(),
            overhangMetrics.bottom + padding.Height + m_overhangOffset.y + m_pTextLayout.GetMaxHeight());
        // Round up to the nearest pixel
        maskPixelSize := DX12.D2D1.SizeU(trunc(maskSize.Width * dpiX / 96.0), trunc(maskSize.Height * dpiY / 96.0));
        // Create the compatible render target using desiredPixelSize to avoid
        // blurriness issues caused by a fractional-pixel desiredSize.
        alphaOnlyFormat := DX12.D2D1.PixelFormat(DXGI_FORMAT_A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED);
        Result := m_pRT.CreateCompatibleRenderTarget(nil, @maskPixelSize, @alphaOnlyFormat,
            D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS_NONE, m_pOpacityRT);
        if (SUCCEEDED(Result)) then
        begin
            // Draw the text to the opacity mask. Note that we can use pixel
            // snapping now given that subpixel translation can now happen during
            // the FillOpacityMask method.
            m_pOpacityRT.BeginDraw();
            m_pOpacityRT.Clear(DX12.D2D1.ColorF(DX12.D2D1.Black, 0.0));
            m_pOpacityRT.DrawTextLayout(
                m_overhangOffset,
                m_pTextLayout,
                m_pBlackBrush,
                D2D1_DRAW_TEXT_OPTIONS_NO_SNAP
                );
            Result := m_pOpacityRT.EndDraw();
        end;
    end;
end;


{/******************************************************************
*                                                                 *
*  DemoApp.CalculateTransform                                    *
*                                                                 *
*  Calculates the transform based on the current time             *
*                                                                 *
******************************************************************/}
procedure TDemoApp.CalculateTransform(var pTransform: TD2D1_MATRIX_3X2_F);
var
    currentTime: DWORD;
    t: single;
    rotation: single;
    translationOffset: single;
    scaleMultiplier: single;
    size: TD2D1_SIZE_F;
begin
    // calculate a 't' value that will linearly interpolate from 0 to 1 and back every 20 seconds
    currentTime := GetTickCount();
    if (m_startTime = 0) then
    begin
        m_startTime := currentTime;
    end;
    t := 2 * ((currentTime - m_startTime) mod 20000) / 20000.0;
    if (t > 1.0) then
    begin
        t := 2 - t;
    end;
    // calculate animation parameters
    rotation := 0;
    translationOffset := 0;
    scaleMultiplier := 1.0;
    if (m_animationStyle and Ord(TAnimationStyle.Translation) = Ord(TAnimationStyle.Translation)) then
    begin
        // range from -100 to 100
        translationOffset := (t - 0.5) * 200;
    end;
    if (m_animationStyle and Ord(TAnimationStyle.Rotation) = Ord(TAnimationStyle.Rotation)) then
    begin
        // range from 0 to 360
        rotation := t * 360.0;
    end;
    if (m_animationStyle and Ord(TAnimationStyle.Scaling) = Ord(TAnimationStyle.Scaling)) then
    begin
        // range from 1/4 to 2x the normal size
        scaleMultiplier := t * 1.75 + 0.25;
    end;
    if m_pRT <> nil then
    begin
        size := m_pRT.GetSize;
    end;
    pTransform := DX12.D2D1.Matrix3x2F_Rotation(rotation, DX12.D2D1.Point2F(0, 0)) * DX12.D2D1.Matrix3x2F_Scale(scaleMultiplier,
        scaleMultiplier, DX12.D2D1.Point2F(0, 0)) * DX12.D2D1.Matrix3x2F_Translation(translationOffset + size.Width / 2.0,
        translationOffset + size.Height / 2.0);
end;


{/******************************************************************
*                                                                 *
*  DemoApp.OnChar                                                *
*                                                                 *
*  Responds to input from the user.                               *
*                                                                 *
******************************************************************/}
function TDemoApp.OnChar(key: char): HRESULT;
var
    lResetAnimation: boolean;
    resetClock: boolean;
begin
    Result := S_OK;

    lResetAnimation := True;
    resetClock := True;
    case Key of
        't':
        begin
            if (m_animationStyle and Ord(TAnimationStyle.Translation) = Ord(TAnimationStyle.Translation)) then
            begin
                m_animationStyle := m_animationStyle and not Ord(TAnimationStyle.Translation);
            end
            else
            begin
                m_animationStyle := m_animationStyle or Ord(TAnimationStyle.Translation);
            end;
        end;
        'r':
        begin
            if (m_animationStyle and Ord(TAnimationStyle.Rotation) = Ord(TAnimationStyle.Rotation)) then
            begin
                m_animationStyle := m_animationStyle and not Ord(TAnimationStyle.Rotation);
            end
            else
            begin
                m_animationStyle := m_animationStyle or Ord(TAnimationStyle.Rotation);
            end;
        end;

        's':
        begin
            if (m_animationStyle and Ord(TAnimationStyle.Scaling) = Ord(TAnimationStyle.Scaling)) then
            begin
                m_animationStyle := m_animationStyle and not Ord(TAnimationStyle.Scaling);
            end
            else
            begin
                m_animationStyle := m_animationStyle or Ord(TAnimationStyle.Scaling);
            end;
        end;
        '1':
        begin
            m_renderingMethod := Ord(TTextRenderingMethod.Default);
            resetClock := False;
        end;
        '2':
        begin
            m_renderingMethod := Ord(TTextRenderingMethod.Outline);
            resetClock := False;
        end;
        '3':
        begin
            m_renderingMethod := Ord(TTextRenderingMethod.UseA8Target);
            resetClock := False;
        end;
        else
            lResetAnimation := False;
            resetClock := False;
    end;
    if (lResetAnimation) then
    begin
        Result := ResetAnimation(resetClock);
    end;
end;


{/******************************************************************
*                                                                 *
*  DemoApp.OnDestroy                                             *
*                                                                 *
*  If the application receives a WM_MOVE message, this method     *
*  takes the appropriate action.                                  *
*                                                                 *
******************************************************************/}
procedure TDemoApp.OnDestroy;
begin
    m_fRunning := False;
end;



function TDemoApp.WndProc(Handle: HWND; umessage: UINT; wpara: wparam; lpara: lparam): LRESULT;
var
    Width: uint;
    Height: uint;
    ps: PAINTSTRUCT;
begin
    case (umessage) of
        WM_SIZE:
        begin
            Width := LOWORD(lpara);
            Height := HIWORD(lpara);
            OnResize(Width, Height);
            Result := 0;
        end;
        WM_CHAR:
        begin
            OnChar(chr(wpara));
            Result := 0;
        end;
        WM_PAINT,
        WM_DISPLAYCHANGE:
        begin
            BeginPaint(Handle, ps);
            OnRender();
            EndPaint(Handle, ps);
            Result := 0;
        end;
        WM_DESTROY:
        begin
            OnDestroy();
            PostQuitMessage(0);
            Result := 1;
        end;
        else
            Result := DefWindowProc(Handle, umessage, wpara, lpara);
    end;
end;



constructor TDemoApp.Create;
begin
    inherited;
    m_hwnd := 0;
    m_pD2DFactory := nil;
    m_pDWriteFactory := nil;
    m_pRT := nil;
    m_pTextFormat := nil;
    m_pTextLayout := nil;
    m_pBlackBrush := nil;
    m_pOpacityRT := nil;
    m_startTime := 0;
    m_animationStyle := Ord(TAnimationStyle.Translation);
    m_renderingMethod := Ord(TTextRenderingMethod.Default);
    sc_lastTimeStatusShown := 0;
    m_times := TRingBuffer.Create(10);
end;



destructor TDemoApp.Destroy;
begin
    m_times.Free;
    SafeRelease(m_pD2DFactory);
    SafeRelease(m_pDWriteFactory);
    SafeRelease(m_pRT);
    SafeRelease(m_pTextFormat);
    SafeRelease(m_pTextLayout);
    SafeRelease(m_pBlackBrush);
    SafeRelease(m_pOpacityRT);
    inherited Destroy;
end;


{/******************************************************************
*                                                                 *
*  DemoApp.Initialize                                            *
*                                                                 *
*  Create application window and device-independent resources     *
*                                                                 *
******************************************************************/}
function TDemoApp.Initialize: HResult;
var
    hr: HResult;
    wcex: TWndClassEx;
    dpiX: single;
    dpiY: single;
    lMethod: TMethod;
    a: word;
begin
    m_fRunning := False;
    GetModuleHandleExW(0, 'TextAnimationSample', FInstance);

    FInstance := HInstance;

    hr := CreateDeviceIndependentResources();
    if (SUCCEEDED(hr)) then
    begin
        lMethod.Code := @TDemoApp.WndProc;
        lMethod.Data := Self;
        FWndProcPointer := MakeProcInstance(lMethod);

        //register window class
        wcex.cbSize := SizeOf(wcex);
        wcex.style := CS_HREDRAW or CS_VREDRAW;
        wcex.lpfnWndProc := FWndProcPointer;
        wcex.cbClsExtra := 0;
        wcex.cbWndExtra := 0;
        wcex.hInstance := FInstance;
        wcex.hIcon := 0;
        wcex.hCursor := LoadCursor(0, IDC_ARROW);
        wcex.hbrBackground := HBRUSH(GetStockObject(BLACK_BRUSH));
        wcex.lpszMenuName := nil;
        wcex.lpszClassName := 'D2DDemoAppWindow';
        wcex.hIconSm := 0;
        if RegisterClassEx(wcex) = 0 then
            Exit;

        // Create the application window.

        // Because the CreateWindow function takes its size in pixels, we
        // obtain the system DPI and use it to scale the window size.
        m_pD2DFactory.GetDesktopDpi(dpiX, dpiY);

        m_hwnd := CreateWindowEx(0, 'D2DDemoAppWindow', 'D2D Demo App', {WS_EX_TOPMOST or WS_POPUP} WS_OVERLAPPEDWINDOW,
            0, 0, trunc(640.0 * dpiX / 96.0), trunc(480.0 * dpiY / 96.0), 0, 0, FInstance, nil);
        if m_hwnd <> 0 then
            hr := S_OK
        else
            hr := E_FAIL;

        if (SUCCEEDED(hr)) then
        begin
            m_fRunning := True;
            ShowWindow(m_hwnd, SW_SHOWNORMAL);
            UpdateWindow(m_hwnd);
        end;
    end;
    Result := hr;
end;


{/******************************************************************
*                                                                 *
*  DemoApp.RunMessageLoop                                        *
*                                                                 *
*  Main window message loop                                       *
*                                                                 *
******************************************************************/}
procedure TDemoApp.RunMessageLoop;
var
    msg: TMsg;
begin
    while (self.IsRunning()) do
    begin
        if (PeekMessage(msg, 0, 0, 0, PM_REMOVE)) then
        begin
            TranslateMessage(msg);
            DispatchMessage(msg);
        end;
    end;
end;

end.
