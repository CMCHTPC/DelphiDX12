unit SystemClass;

interface

uses
    Classes, SysUtils, Windows,
    ApplicationClass;

type
    TSystemClass = class(TObject)
    private
        m_applicationName: LPCWSTR;
        m_hinstance: HINST;
        m_hwnd: HWND;
        m_Application: TApplicationClass;
    private
        function Frame(): HResult;
        procedure InitializeWindows(var screenWidth, screenHeight: integer);
        procedure ShutdownWindows();
    public
        constructor Create;
        destructor Destroy; override;
        function Initialize(): HResult;
        procedure Shutdown();
        procedure Run();
        function MessageHandler(HWND: HWND; umsg: UINT; WPARAM: WPARAM; LPARAM: LPARAM): LRESULT;
    end;

var
    ApplicationHandle: TSystemClass = nil;

implementation

uses
    Messages;



function WndProc(HWND: HWND; umessage: UINT; WPARAM: WPARAM; LPARAM: LPARAM): LRESULT; stdcall;
begin
    case (umessage) of

        // Check if the window is being destroyed.
        WM_DESTROY:
        begin
            PostQuitMessage(0);
            Result := 0;
        end;

        // Check if the window is being closed.
        WM_CLOSE:
        begin
            PostQuitMessage(0);
            Result := 0;
        end;

            // All other messages pass to the message handler in the system class.
        else
        begin
            Result := ApplicationHandle.MessageHandler(HWND, umessage, WPARAM, LPARAM);
        end;
    end;
end;



constructor TSystemClass.Create;
begin
    m_Application := nil;
end;



destructor TSystemClass.Destroy;
begin
    inherited;
end;



function TSystemClass.Initialize(): HResult;
var
    screenWidth, screenHeight: integer;
begin

    // Initialize the width and height of the screen to zero before sending the variables into the function.
    screenWidth := 0;
    screenHeight := 0;

    // Initialize the windows api.
    InitializeWindows(screenWidth, screenHeight);

    // Create the application wrapper object.
    m_Application := TApplicationClass.Create;

    // Initialize the application wrapper object.
    Result := m_Application.Initialize(m_hinstance, m_hwnd, screenWidth, screenHeight);
end;



procedure TSystemClass.Shutdown();
begin
    // Release the application wrapper object.
    if (m_Application <> nil) then
    begin
        m_Application.Shutdown();
        m_Application.Free;
        m_Application := nil;
    end;

    // Shutdown the window.
    ShutdownWindows();
end;



procedure TSystemClass.Run();
var
    msg: TMSG;
    done: boolean;
    hr: HResult;
begin
    // Initialize the message structure.
    ZeroMemory(@msg, sizeof(TMSG));

    // Loop until there is a quit message from the window or the user.
    done := False;
    while (not done) do
    begin
        // Handle the windows messages.
        if (PeekMessage(msg, 0, 0, 0, PM_REMOVE)) then
        begin
            TranslateMessage(msg);
            DispatchMessage(msg);
        end;

        // If windows signals to end the application then exit out.
        if (msg.message = WM_QUIT) then
        begin
            done := True;
        end
        else
        begin
            // Otherwise do the frame processing.
            hr := Frame();
            if (hr <> S_OK) then
            begin
                done := True;
            end;
        end;

    end;
end;



function TSystemClass.Frame(): HResult;
begin
    // Do the frame processing for the application object.
    Result := m_Application.Frame();
end;



function TSystemClass.MessageHandler(HWND: HWND; umsg: UINT; WPARAM: WPARAM; LPARAM: LPARAM): LRESULT;
begin
    Result := DefWindowProc(HWND, umsg, WPARAM, LPARAM);
end;



procedure TSystemClass.InitializeWindows(var screenWidth, screenHeight: integer);
var
    wc: TWNDCLASSEXW;
    dmScreenSettings: TDEVMODE;
    posX, posY: integer;
begin

    // Get an external pointer to this object.
    ApplicationHandle := self;

    // Get the instance of this application.
    m_hinstance := GetModuleHandle(nil);

    // Give the application a name.
    m_applicationName := 'Engine';

    // Setup the windows class with default settings.
    wc.style := CS_HREDRAW or CS_VREDRAW or CS_OWNDC;
    wc.lpfnWndProc := @WndProc;
    wc.cbClsExtra := 0;
    wc.cbWndExtra := 0;
    wc.hInstance := m_hinstance;
    wc.hIcon := LoadIcon(0, IDI_WINLOGO);
    wc.hIconSm := wc.hIcon;
    wc.hCursor := LoadCursor(0, IDC_ARROW);
    wc.hbrBackground := GetStockObject(BLACK_BRUSH);
    wc.lpszMenuName := nil;
    wc.lpszClassName := m_applicationName;
    wc.cbSize := sizeof(TWNDCLASSEXW);

    // Register the window class.
    RegisterClassExW(wc);

    // Determine the resolution of the clients desktop screen.
    screenWidth := GetSystemMetrics(SM_CXSCREEN);
    screenHeight := GetSystemMetrics(SM_CYSCREEN);

    // Setup the screen settings depending on whether it is running in full screen or in windowed mode.
    if (FULL_SCREEN) then
    begin
        // If full screen set the screen to maximum size of the users desktop and 32bit.
        ZeroMemory(@dmScreenSettings, sizeof(dmScreenSettings));
        dmScreenSettings.dmSize := sizeof(dmScreenSettings);
        dmScreenSettings.dmPelsWidth := screenWidth;
        dmScreenSettings.dmPelsHeight := screenHeight;
        dmScreenSettings.dmBitsPerPel := 32;
        dmScreenSettings.dmFields := DM_BITSPERPEL or DM_PELSWIDTH or DM_PELSHEIGHT;

        // Change the display settings to full screen.
        ChangeDisplaySettings(dmScreenSettings, CDS_FULLSCREEN);

        // Set the position of the window to the top left corner.
        posX := 0;
        posY := 0;
    end
    else
    begin
        // If windowed then set it to 800x600 resolution.
        screenWidth := 800;
        screenHeight := 600;

        // Place the window in the middle of the screen.
        posX := (GetSystemMetrics(SM_CXSCREEN) - screenWidth) div 2;
        posY := (GetSystemMetrics(SM_CYSCREEN) - screenHeight) div 2;
    end;

    // Create the window with the screen settings and get the handle to it.
    m_hwnd := CreateWindowExW(WS_EX_APPWINDOW, m_applicationName, m_applicationName, WS_CLIPSIBLINGS or WS_CLIPCHILDREN or
        WS_POPUP, posX, posY, screenWidth, screenHeight, 0, 0, m_hinstance, nil);

    // Bring the window up on the screen and set it as main focus.
    ShowWindow(m_hwnd, SW_SHOW);
    SetForegroundWindow(m_hwnd);
    SetFocus(m_hwnd);

    // Hide the mouse cursor.
    ShowCursor(False);
end;



procedure TSystemClass.ShutdownWindows();
var
    lpDevMode: TDeviceModeW;
begin
    // Show the mouse cursor.
    ShowCursor(True);

    // Fix the display settings if leaving full screen mode.
    if (FULL_SCREEN) then
    begin
        ChangeDisplaySettingsW(lpDevMode, 0);
    end;

    // Remove the window.
    DestroyWindow(m_hwnd);
    m_hwnd := 0;

    // Remove the application instance.
    UnregisterClassW(m_applicationName, m_hinstance);
    m_hinstance := 0;

    // Release the pointer to this class.
    ApplicationHandle := nil;
end;

end.
