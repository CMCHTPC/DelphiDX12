unit InputClass;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$ENDIF}

interface

uses
    Classes, SysUtils, Windows,
    DirectInput;

type

    { TInputClass }

    TInputClass = class(TObject)
    private
        m_directInput: IDirectInput8;
        m_keyboard: IDirectInputDevice8;
        m_mouse: IDirectInputDevice8;

        m_keyboardState: array [0..255] of byte;
        m_mouseState: DIMOUSESTATE;

        m_screenWidth, m_screenHeight: integer;
        m_mouseX, m_mouseY: integer;
    private
        function ReadKeyboard(): Hresult;
        function ReadMouse(): Hresult;
        procedure ProcessInput();
    public
        constructor Create;
        destructor Destroy; override;
        function Initialize(hinstance: HINST; hwnd: HWND; screenWidth, screenHeight: integer): Hresult;
        procedure Shutdown();
        function Frame(): Hresult;
        function IsEscapePressed(): boolean;
        procedure GetMouseLocation(out mouseX, mouseY: integer);
        function IsLeftMouseButtonDown(): boolean;

    end;

implementation

{ TInputClass }

function TInputClass.ReadKeyboard(): Hresult;
begin

    // Read the keyboard device.
    Result := m_keyboard.GetDeviceState(sizeof(m_keyboardState), @m_keyboardState[0]);
    if (FAILED(Result)) then
    begin
        // If the keyboard lost focus or was not acquired then try to get control back.
        if ((Result = DIERR_INPUTLOST) or (Result = DIERR_NOTACQUIRED)) then
        begin
            Result := m_keyboard.Acquire();
        end;
    end;
    Result:=S_OK;
end;



function TInputClass.ReadMouse(): Hresult;
begin

    // Read the mouse device.
    Result := m_mouse.GetDeviceState(sizeof(DIMOUSESTATE), @m_mouseState);
    if (FAILED(Result)) then
    begin
        // If the mouse lost focus or was not acquired then try to get control back.
        if ((Result = DIERR_INPUTLOST) or (Result = DIERR_NOTACQUIRED)) then
        begin
            Result := m_mouse.Acquire();
        end;
    end;
    Result:=S_OK;
end;



procedure TInputClass.ProcessInput();
begin
    // Update the location of the mouse cursor based on the change of the mouse location during the frame.
    m_mouseX += m_mouseState.lX;
    m_mouseY += m_mouseState.lY;

    // Ensure the mouse location doesn't exceed the screen width or height.
    if (m_mouseX < 0) then
    begin
        m_mouseX := 0;
    end;
    if (m_mouseY < 0) then
    begin
        m_mouseY := 0;
    end;

    if (m_mouseX > m_screenWidth) then
    begin
        m_mouseX := m_screenWidth;
    end;
    if (m_mouseY > m_screenHeight) then
    begin
        m_mouseY := m_screenHeight;
    end;

end;



constructor TInputClass.Create;
begin

end;



destructor TInputClass.Destroy;
begin
    inherited Destroy;
end;



function TInputClass.Initialize(hinstance: HINST; hwnd: HWND; screenWidth, screenHeight: integer): Hresult;
var
    i: integer;
begin
    // Store the screen size which will be used for positioning the mouse cursor.
    m_screenWidth := screenWidth;
    m_screenHeight := screenHeight;

    // Initialize the location of the mouse on the screen.
    m_mouseX := 0;
    m_mouseY := 0;

    // Initialize the main direct input interface.
    Result := DirectInput8Create(hinstance, DIRECTINPUT_VERSION, IID_IDirectInput8, m_directInput, nil);
    if (FAILED(Result)) then Exit;


    // Initialize the direct input interface for the keyboard.
    Result := m_directInput.CreateDevice(GUID_SysKeyboard, m_keyboard, nil);
    if (FAILED(Result)) then Exit;

    // Set the data format.  In this case since it is a keyboard we can use the predefined data format.
    Result := m_keyboard.SetDataFormat(c_dfDIKeyboard);
    if (FAILED(Result)) then Exit;

    // Set the cooperative level of the keyboard to not share with other programs.
    Result := m_keyboard.SetCooperativeLevel(hwnd, DISCL_FOREGROUND or DISCL_NONEXCLUSIVE);
    if (FAILED(Result)) then Exit;

    // Now acquire the keyboard.
    Result := m_keyboard.Acquire();
    if (FAILED(Result)) then Exit;

    // Initialize the direct input interface for the mouse.
    Result := m_directInput.CreateDevice(GUID_SysMouse, m_mouse, nil);
    if (FAILED(Result)) then Exit;

    // Set the data format for the mouse using the pre-defined mouse data format.
    Result := m_mouse.SetDataFormat(c_dfDIMouse);
    if (FAILED(Result)) then Exit;

    // Set the cooperative level of the mouse to share with other programs.
    Result := m_mouse.SetCooperativeLevel(hwnd, DISCL_FOREGROUND or DISCL_NONEXCLUSIVE);
    if (FAILED(Result)) then Exit;

    // Acquire the mouse.
    Result := m_mouse.Acquire();

end;



procedure TInputClass.Shutdown();
begin
    // Release the mouse.
    if (m_mouse <> nil) then
    begin
        m_mouse.Unacquire();
        m_mouse := nil;
    end;

    // Release the keyboard.
    if (m_keyboard <> nil) then
    begin
        m_keyboard.Unacquire();
        m_keyboard := nil;
    end;

    // Release the main interface to direct input.
    m_directInput := nil;
end;



function TInputClass.Frame(): Hresult;
begin
    // Read the current state of the keyboard.
    Result := ReadKeyboard();
    if (Result <> S_OK) then Exit;

    // Read the current state of the mouse.
    Result := ReadMouse();
    if (Result <> S_OK) then Exit;

    // Process the changes in the mouse and keyboard.
    ProcessInput();

end;



function TInputClass.IsEscapePressed(): boolean;
begin
    // Do a bitwise and on the keyboard state to check if the escape key is currently being pressed.
    Result := (m_keyboardState[DIK_ESCAPE] and $80) <> 0;
end;



procedure TInputClass.GetMouseLocation(out mouseX, mouseY: integer);
begin
    mouseX := m_mouseX;
    mouseY := m_mouseY;
end;



function TInputClass.IsLeftMouseButtonDown(): boolean;
begin
    // Check if the left mouse button is currently pressed.
    Result := (m_mouseState.rgbButtons[0] and $80) <> 0;
end;



end.
