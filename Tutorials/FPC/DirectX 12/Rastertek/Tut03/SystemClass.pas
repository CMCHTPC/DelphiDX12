unit SystemClass;

{$mode delphi}

interface

uses
    Windows, Classes, SysUtils,
    InputClass, GraphicsClass;

type
    { TSystemClass }

    TSystemClass = class(TObject)
    private
        FApplicationName: WideString;
        FHinstance: PtrUInt;
        Fhwnd: HWND;

        FInput: TInputClass;
        FGraphics: TGraphicsClass;
    private
        function Frame(): boolean;
        procedure InitializeWindows(screenHeight, screenWidth: integer);
        procedure ShutdownWindows();
    public
        constructor Create();
        // SystemClass(const SystemClass&);
        destructor Destroy; override;

        function Initialize(): boolean;
        procedure Shutdown();
        procedure Run();

        function MessageHandler(Handle: HWND; umsg: UINT; wparam: WPARAM; lparam: LPARAM): LRESULT; stdcall;
    end;

function WndProc(Handle: HWND; umessage: UINT; wparam: WPARAM; lparam: LPARAM): LRESULT; stdcall;

var
    ApplicationHandle: TSystemClass;

implementation



function WndProc(Handle: HWND; umessage: UINT; wparam: WPARAM; lparam: LPARAM): LRESULT; stdcall;
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
            Result := ApplicationHandle.MessageHandler(Handle, umessage, wparam, lparam);
        end;
    end;
end;

{ TSystemClass }

function TSystemClass.Frame(): boolean;
begin
    // Check if the user pressed escape and wants to exit the application.
    if (FInput.IsKeyDown(VK_ESCAPE)) then
    begin
        Result := False;
        Exit;
    end;

    // Do the frame processing for the graphics object.
    Result := FGraphics.Frame();
end;



procedure TSystemClass.InitializeWindows(screenHeight, screenWidth: integer);
var
    wc: TWNDCLASSEXW;
    dmScreenSettings: TDEVMODE;
    posX, posY: integer;
begin

    // Get an external pointer to this object.
    ApplicationHandle := self;

    // Get the instance of this application.
    Fhinstance := GetModuleHandle(0);

    // Give the application a name.
    FapplicationName := 'Engine';

    // Setup the windows class with default settings.
    wc.style := CS_HREDRAW or CS_VREDRAW or CS_OWNDC;
    wc.lpfnWndProc := @WndProc;
    wc.cbClsExtra := 0;
    wc.cbWndExtra := 0;
    wc.hInstance := Fhinstance;
    wc.hIcon := LoadIcon(0, IDI_WINLOGO);
    wc.hIconSm := wc.hIcon;
    wc.hCursor := LoadCursor(0, IDC_ARROW);
    wc.hbrBackground := GetStockObject(BLACK_BRUSH);
    wc.lpszMenuName := 0;
    wc.lpszClassName := PWideChar(FApplicationName);
    wc.cbSize := sizeof(TWNDCLASSEXW);

    // Register the window class.
    RegisterClassExW(wc);

    // Determine the resolution of the clients desktop screen.
    screenHeight := GetSystemMetrics(SM_CYSCREEN);
    screenWidth := GetSystemMetrics(SM_CXSCREEN);

    // Setup the screen settings depending on whether it is running in full screen or in windowed mode.
    if (FULL_SCREEN) then
    begin
        // If full screen set the screen to maximum size of the users desktop and 32bit.
        ZeroMemory(@dmScreenSettings, sizeof(dmScreenSettings));
        dmScreenSettings.dmSize := sizeof(dmScreenSettings);
        dmScreenSettings.dmPelsHeight := screenHeight;
        dmScreenSettings.dmPelsWidth := screenWidth;
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
    Fhwnd := CreateWindowExW(WS_EX_APPWINDOW, PWideChar(FapplicationName), PWideChar(FapplicationName), WS_CLIPSIBLINGS or
        WS_CLIPCHILDREN or WS_POPUP, posX, posY, screenWidth, screenHeight, 0, 0, Fhinstance, 0);

    // Bring the window up on the screen and set it as main focus.
    ShowWindow(Fhwnd, SW_SHOW);
    SetForegroundWindow(Fhwnd);
    SetFocus(Fhwnd);

    // Hide the mouse cursor.
    ShowCursor(False);

end;



procedure TSystemClass.ShutdownWindows();
begin
    // Show the mouse cursor.
    ShowCursor(True);

    // Fix the display settings if leaving full screen mode.
    if (FULL_SCREEN) then
    begin
        ChangeDisplaySettings(0, 0);
    end;

    // Remove the window.
    DestroyWindow(Fhwnd);
    Fhwnd := 0;

    // Remove the application instance.
    UnregisterClassW(PWideChar(FapplicationName), Fhinstance);
    FHinstance := 0;

    // Release the pointer to this class.
    ApplicationHandle := nil;
end;



constructor TSystemClass.Create();
begin

end;



destructor TSystemClass.Destroy;
begin
    inherited Destroy;
end;



function TSystemClass.Initialize(): boolean;
var
    screenHeight, screenWidth: integer;
begin
    // Initialize the width and height of the screen to zero before sending the variables into the function.
    screenHeight := 0;
    screenWidth := 0;
    Result := False;

    // Initialize the windows api.
    InitializeWindows(screenHeight, screenWidth);

    // Create the input object.  This object will be used to handle reading the keyboard input from the user.
    FInput := TInputClass.Create;
    if (FInput = nil) then
        Exit;


    // Initialize the input object.
    FInput.Initialize();

    // Create the graphics object.  This object will handle rendering all the graphics for this application.
    FGraphics := TGraphicsClass.Create;
    if (FGraphics = nil) then
        Exit;

    // Initialize the graphics object.
    Result := FGraphics.Initialize(screenHeight, screenWidth, Fhwnd);
end;



procedure TSystemClass.Shutdown();
begin
    // Release the graphics object.
    if (FGraphics <> nil) then
    begin
        FGraphics.Shutdown();
        FGraphics.Free;
        FGraphics := nil;
    end;


    // Release the input object.
    if (FInput <> nil) then
    begin
        FInput.Free;
        FInput := nil;
    end;

    // Shutdown the window.
    ShutdownWindows();
end;



procedure TSystemClass.Run();
var
    msg: TMSG;
    done, Result: boolean;
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
            Result := Frame();
            if (not Result) then
            begin
                done := True;
            end;
        end;

    end;
end;



function TSystemClass.MessageHandler(Handle: HWND; umsg: UINT; wparam: WPARAM; lparam: LPARAM): LRESULT; stdcall;
begin
    case (umsg) of

        // Check if a key has been pressed on the keyboard.
        WM_KEYDOWN:
        begin
            // If a key is pressed send it to the input object so it can record that state.
            FInput.KeyDown(wparam);
            Result := 0;
        end;

        // Check if a key has been released on the keyboard.
        WM_KEYUP:
        begin
            // If a key is released then send it to the input object so it can unset the state for that key.
            FInput.KeyUp(wparam);
            Result := 0;
        end;

            // Any other messages send to the default message handler as our application won't make use of them.
        else
            Result := DefWindowProc(Handle, umsg, wparam, lparam);
    end;
end;

end.
