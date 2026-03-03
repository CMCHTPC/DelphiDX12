unit InputClass;

interface

uses
	Classes, SysUtils, Windows,
    DirectInput;




type
TInputClass = class (TObject)
private
	 m_directInput:IDirectInput8;
	 m_keyboard:IDirectInputDevice8;
	 m_mouse:IDirectInputDevice8;

	m_keyboardState: array [0..255] of byte;
	 m_mouseState:TDIMOUSESTATE;

	 m_screenWidth, m_screenHeight:integer;
	 m_mouseX, m_mouseY:integer;
public
	 constructor Create;
        destructor Destroy; override;

	function Initialize( hinstance:HINST;  hwnd: HWND;  screenWidth, screenHeight:integer):HResult;
	procedure Shutdown();
	function Frame():HResult;

	procedure GetMouseLocation(out mouseX, mouseY:Integer);

	function IsEscapePressed():boolean;
	function IsLeftPressed():boolean;
	function IsRightPressed():boolean;
	function IsUpPressed():boolean;
	function IsDownPressed():boolean;
	function IsAPressed():boolean;
	function IsZPressed():boolean;
	function IsPgUpPressed():boolean;
	function IsPgDownPressed():boolean;

private
	function ReadKeyboard():HResult;
	function ReadMouse():HResult;
	procedure ProcessInput();


end;


implementation


constructor TInputClass.Create;
begin
	m_directInput := nil;
	m_keyboard := nil;
	m_mouse := nil;
end;



destructor TInputClass.Destroy;
begin
	inherited;
end;


function TInputClass.Initialize( hinstance:HINST;  hwnd:HWND;  screenWidth, screenHeight:integer):HResult;
begin
	


	// Store the screen size which will be used for positioning the mouse cursor.
	m_screenWidth := screenWidth;
	m_screenHeight := screenHeight;

	// Initialize the location of the mouse on the screen.
	m_mouseX := 0;
	m_mouseY := 0;

	// Initialize the main direct input interface.
	result := DirectInput8Create(hinstance, DIRECTINPUT_VERSION, IID_IDirectInput8, m_directInput, nil);
	if(result<>S_OK) then Exit;

	// Initialize the direct input interface for the keyboard.
	result := m_directInput.CreateDevice(GUID_SysKeyboard, m_keyboard, nil);
	if(result<>S_OK) then Exit;

	// Set the data format.  In this case since it is a keyboard we can use the predefined data format.
	result := m_keyboard.SetDataFormat(c_dfDIKeyboard);
	if(result<>S_OK) then Exit;

	// Set the cooperative level of the keyboard to not share with other programs.
	result := m_keyboard.SetCooperativeLevel(hwnd, DISCL_FOREGROUND or DISCL_EXCLUSIVE);
	if(result<>S_OK) then Exit;

	// Now acquire the keyboard.
	result := m_keyboard.Acquire();
	if(result<>S_OK) then Exit;

	// Initialize the direct input interface for the mouse.
	result := m_directInput.CreateDevice(GUID_SysMouse, m_mouse, nil);
	if(result<>S_OK) then Exit;

	// Set the data format for the mouse using the pre-defined mouse data format.
	result := m_mouse.SetDataFormat(c_dfDIMouse);
	if(result<>S_OK) then Exit;

	// Set the cooperative level of the mouse to share with other programs.
	result := m_mouse.SetCooperativeLevel(hwnd, DISCL_FOREGROUND or DISCL_NONEXCLUSIVE);
	if(result<>S_OK) then Exit;

	// Acquire the mouse.
	result := m_mouse.Acquire();
end;


procedure TInputClass.Shutdown();
begin
	// Release the mouse.
	if(m_mouse<>nil) then
	begin
		m_mouse.Unacquire();
		m_mouse := nil;
	end;

	// Release the keyboard.
	if(m_keyboard<>nil) then
	begin
		m_keyboard.Unacquire();
		m_keyboard := nil;
	end;

	// Release the main interface to direct input.
		m_directInput := nil;
end;


function TInputClass.Frame():HResult;
begin
	

	// Read the current state of the keyboard.
	result := ReadKeyboard();
	if(result<>S_OK) then Exit;

	// Read the current state of the mouse.
	result := ReadMouse();
	if(result<>S_OK) then Exit;

	// Process the changes in the mouse and keyboard.
	ProcessInput();
end;


function TInputClass.ReadKeyboard():HResult;
begin
	

	// Read the keyboard device.
	result := m_keyboard.GetDeviceState(sizeof(m_keyboardState), @m_keyboardState[0]);
	if(FAILED(result)) then
	begin
		// If the keyboard lost focus or was not acquired then try to get control back.
		if((result = DIERR_INPUTLOST) or (result = DIERR_NOTACQUIRED)) then
		begin
			m_keyboard.Acquire();
		end
		else
		begin
			Exit;
		end;
	end;
	Result:=S_OK;
end;


function TInputClass.ReadMouse():HResult;
begin
	

	// Read the mouse device.
	result := m_mouse.GetDeviceState(sizeof(DIMOUSESTATE), @m_mouseState);
	if(FAILED(result)) then
	begin
		// If the mouse lost focus or was not acquired then try to get control back.
		if((result = DIERR_INPUTLOST) or (result = DIERR_NOTACQUIRED)) then
		begin
			m_mouse.Acquire();
		end
		else
		begin
			Exit;
		end;
	end;

	Result:=S_OK;
end;


procedure TInputClass.ProcessInput();
begin
	// Update the location of the mouse cursor based on the change of the mouse location during the frame.
	m_mouseX:=m_mouseX + m_mouseState.lX;
	m_mouseY:=m_mouseY + m_mouseState.lY;

	// Ensure the mouse location doesn't exceed the screen width or height.
	if(m_mouseX < 0)  then begin m_mouseX := 0; end;
	if(m_mouseY < 0)then  begin m_mouseY := 0; end;
	
	if(m_mouseX > m_screenWidth) then begin m_mouseX := m_screenWidth; end;
	if(m_mouseY > m_screenHeight)then begin m_mouseY := m_screenHeight; end;

end;


procedure TInputClass.GetMouseLocation(out mouseX, mouseY:Integer);
begin
	mouseX := m_mouseX;
	mouseY := m_mouseY;
	end;


function TInputClass.IsEscapePressed():boolean;
begin
	// Do a bitwise and on the keyboard state to check if the escape key is currently being pressed.
	result:=(m_keyboardState[DIK_ESCAPE] AND $80)<>0;
end;


function TInputClass.IsLeftPressed():boolean;
begin
	// Do a bitwise and on the keyboard state to check if the key is currently being pressed.
	result:=(m_keyboardState[DIK_LEFT] AND $80)<>0;
end;


function TInputClass.IsRightPressed():boolean;
begin
	// Do a bitwise and on the keyboard state to check if the key is currently being pressed.
	result:=(m_keyboardState[DIK_RIGHT] AND $80)<>0;
end;


function TInputClass.IsUpPressed():boolean;
begin
	// Do a bitwise and on the keyboard state to check if the key is currently being pressed.
	result:=(m_keyboardState[DIK_UP] AND $80)<>0;
end;


function TInputClass.IsDownPressed():boolean;
begin
	// Do a bitwise and on the keyboard state to check if the key is currently being pressed.
	result:=(m_keyboardState[DIK_DOWN] AND $80)<>0;
end;


function TInputClass.IsAPressed():boolean;
begin
	// Do a bitwise and on the keyboard state to check if the key is currently being pressed.
	result:=(m_keyboardState[DIK_A] AND $80)<>0;
end;


function TInputClass.IsZPressed():boolean;
begin
	// Do a bitwise and on the keyboard state to check if the key is currently being pressed.
	result:=(m_keyboardState[DIK_Z] AND $80)<>0;
end;


function TInputClass.IsPgUpPressed():boolean;
begin
	// Do a bitwise and on the keyboard state to check if the key is currently being pressed.
	result:=(m_keyboardState[DIK_PGUP] AND $80)<>0;
end;


function TInputClass.IsPgDownPressed():boolean;
begin
	// Do a bitwise and on the keyboard state to check if the key is currently being pressed.
	result:=(m_keyboardState[DIK_PGDN] AND $80)<>0;
end;

end.