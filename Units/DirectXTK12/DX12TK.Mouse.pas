//--------------------------------------------------------------------------------------
// File: Mouse.h

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkId=248929
// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------
unit DX12TK.Mouse;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.GameInput;

const
    INT64_MAX = $7FFFFFFFFFFFFFFF;
    INT32_MAX = $7FFFFFFF;

    CURSOR_SHOWING = $00000001;
    CURSOR_SUPPRESSED = $00000002;

type


    { TButtonStateTracker }


    { TMouse }

    TMouse = class(TObject)
    type
        TMouseMode = (
            MODE_ABSOLUTE = 0,
            MODE_RELATIVE);
        PMouseMode = ^TMouseMode;

        TMouseState = record
            leftButton: boolean;
            middleButton: boolean;
            rightButton: boolean;
            xButton1: boolean;
            xButton2: boolean;
            x: longint;
            y: longint;
            scrollWheelValue: longint;
            positionMode: TMouseMode;
        end;
        PMouseState = ^TMouseState;

        TButtonStateTracker = class(TObject)
        type
            TMouseButtonState = (
                UP = 0, // Button is up
                HELD = 1, // Button is held down
                RELEASED = 2, // Button was just released
                PRESSED = 3// Buton was just pressed
            );

            PMouseButtonState = ^TMouseButtonState;



        protected
            FLastState: TMouseState;
        public
            leftButton: TMouseButtonState;
            middleButton: TMouseButtonState;
            rightButton: TMouseButtonState;
            xButton1: TMouseButtonState;
            xButton2: TMouseButtonState;
        public
            constructor Create;
            destructor Destroy; override;
            procedure Update(State: TMouseState);
            procedure Reset();
            function GetLastState(): TMouseState;
        end;



    protected
        s_mouse: TMouse; static;
        mState: TMouseState;

        mGameInput: IGameInput;
        mDeviceToken: TGameInputCallbackToken;

        mWindow: HWND;
        mMode: TMouseMode;


        mScrollWheelValue: Handle; // TScopedHandle;
        mRelativeRead: Handle;
        mAbsoluteMode: Handle;
        mRelativeMode: Handle;

        mLastX: longint;
        mLastY: longint;
        mRelativeX: longint;
        mRelativeY: longint;

        mAutoReset: boolean;
        mInFocus: boolean;


    protected
        procedure ClipToWindow();
    public
        constructor Create;
        destructor Destroy; override;
        // Retrieve the current state of the mouse
        function GetState(): TMouseState;

        // Resets the accumulated scroll wheel value
        procedure ResetScrollWheelValue();

        // Sets mouse mode (defaults to absolute)
        procedure SetMode(mode: TMouseMode);

        // Signals the end of frame (recommended, but optional)
        procedure EndOfInputFrame();

        // Feature detection
        function IsConnected(): boolean;

        // Cursor visibility
        function IsVisible(): boolean;
        procedure SetVisible(Visible: boolean);


        procedure SetWindow(window: HWND);
        procedure ProcessMessage(message: UINT; wParam: WPARAM; lParam: LPARAM);


    end;

implementation

//--------------------------------------------------------------------------------------
// File: Mouse.cpp

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkId=248929
// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------

uses
    Windows.Macros,
    Win32.SynchAPI,
    DX12TK.PlatformHelpers;


    //======================================================================================
    // ButtonStateTracker
    //======================================================================================

    { TButtonStateTracker }

constructor TMouse.TButtonStateTracker.Create;
begin
    Reset();
end;



destructor TMouse.TButtonStateTracker.Destroy;
begin
    inherited Destroy;
end;



procedure TMouse.TButtonStateTracker.Update(State: TMouseState);
begin
    leftButton := TMouseButtonState(byte(State.leftButton) or ((byte(State.leftButton) xor byte(FLastState.leftButton)) shl 1));
    middleButton := TMouseButtonState(byte(State.middleButton) or ((byte(State.middleButton) xor byte(FLastState.middleButton)) shl 1));
    rightButton := TMouseButtonState(byte(State.rightButton) or ((byte(State.rightButton) xor byte(FLastState.rightButton)) shl 1));
    xButton1 := TMouseButtonState(byte(State.xButton1) or ((byte(State.xButton1) xor byte(FLastState.xButton1)) shl 1));
    xButton2 := TMouseButtonState(byte(State.xButton2) or ((byte(State.xButton2) xor byte(FLastState.xButton2)) shl 1));

    FLastState := State;
end;



procedure TMouse.TButtonStateTracker.Reset();
begin
    ZeroMemory(@FLastState, SizeOf(TMouseState));
    leftButton := UP;
    middleButton := UP;
    rightButton := UP;
    xButton1 := UP;
    xButton2 := UP;
end;



function TMouse.TButtonStateTracker.GetLastState(): TMouseState;
begin
    Result := FLastState;
end;


//======================================================================================
// Win32 desktop implementation
//======================================================================================
// For a Win32 desktop application, in your window setup be sure to call this method:
// m_mouse->SetWindow(hwnd);
// And call this static function from your Window Message Procedure
// LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
// {
//     switch (message)
//     {
//     case WM_ACTIVATE:
//     case WM_ACTIVATEAPP:
//     case WM_INPUT:
//     case WM_MOUSEMOVE:
//     case WM_LBUTTONDOWN:
//     case WM_LBUTTONUP:
//     case WM_RBUTTONDOWN:
//     case WM_RBUTTONUP:
//     case WM_MBUTTONDOWN:
//     case WM_MBUTTONUP:
//     case WM_MOUSEWHEEL:
//     case WM_XBUTTONDOWN:
//     case WM_XBUTTONUP:
//     case WM_MOUSEHOVER:
//         Mouse::ProcessMessage(message, wParam, lParam);
//         break;

//     }
// }


{ TMouse }

procedure TMouse.ClipToWindow();
var
    rect: TRECT;
    ul: TPOINT;
    lr: TPOINT;
begin
    assert(mWindow <> 0);
    GetClientRect(mWindow, @rect);

    ul.x := rect.left;
    ul.y := rect.top;

    lr.x := rect.right;
    lr.y := rect.bottom;

    MapWindowPoints(mWindow, 0, @ul, 1);
    MapWindowPoints(mWindow, 0, @lr, 1);

    rect.left := ul.x;
    rect.top := ul.y;

    rect.right := lr.x;
    rect.bottom := lr.y;

    ClipCursor(@rect);
end;



constructor TMouse.Create;
begin
    mWindow := 0;
    mMode := MODE_ABSOLUTE;
    mLastX := 0;
    mLastY := 0;
    mRelativeX := INT32_MAX;
    mRelativeY := INT32_MAX;
    mInFocus := True;
    mAutoReset := True;

    if (s_mouse <> nil) then
        raise Exception.Create('DX12TK.TMouse is a singleton');
    s_mouse := self;

    mScrollWheelValue := CreateEventExW(nil, nil, CREATE_EVENT_MANUAL_RESET, EVENT_MODIFY_STATE or SYNCHRONIZE);
    mRelativeRead := CreateEventExW(nil, nil, CREATE_EVENT_MANUAL_RESET, EVENT_MODIFY_STATE or SYNCHRONIZE);
    mAbsoluteMode := CreateEventExW(nil, nil, 0, EVENT_MODIFY_STATE or SYNCHRONIZE);
    mRelativeMode := CreateEventExW(nil, nil, 0, EVENT_MODIFY_STATE or SYNCHRONIZE);
    if ((mScrollWheelValue = 0) or (mRelativeRead = 0) or (mAbsoluteMode = 0) or (mRelativeMode = 0)) then
    begin
        raise Exception.Create('DX12TK.TMouse.Create CreateEventEx');
    end;

end;



destructor TMouse.Destroy;
begin
    s_mouse := nil;
    inherited Destroy;
end;



function TMouse.GetState(): TMouseState;
var
    lState: TMouseState;
    dw: dword;
    scrollDelta: longint;
begin
    lState := mState;
    lState.positionMode := mMode;
    dw := WaitForSingleObjectEx(mScrollWheelValue, 0, False);
    if (dw = WAIT_FAILED) then
        raise Exception.Create('WaitForSingleObjectEx');

    if (dw = WAIT_OBJECT_0) then
    begin
        lState.scrollWheelValue := 0;
    end;

    if (lState.positionMode = MODE_RELATIVE) then
    begin
        dw := WaitForSingleObjectEx(mRelativeRead, 0, False);

        if (dw = WAIT_FAILED) then
            raise Exception.Create('WaitForSingleObjectEx');

        if (dw = WAIT_OBJECT_0) then
        begin
            lState.x := 0;
            lState.y := 0;
        end
        else
        begin
            SetEvent(mRelativeRead);
        end;

        if (mAutoReset) then
        begin
            mState.x := 0;
            mState.y := 0;
        end;
    end;
end;



procedure TMouse.ResetScrollWheelValue();
begin
    SetEvent(mScrollWheelValue);
end;



procedure TMouse.SetMode(mode: TMouseMode);
var
    point: TPOINT;
    tme: TTRACKMOUSEEVENT;
begin
    if (mMode = mode) then
        Exit;

    if (mode = MODE_ABSOLUTE) then
        SetEvent(mAbsoluteMode)
    else
        SetEvent(mRelativeMode);

    assert(mWindow <> 0);

    // Send a WM_HOVER as a way to 'kick' the message processing even if the mouse is still.

    tme.cbSize := sizeof(tme);
    tme.dwFlags := TME_HOVER;
    tme.hwndTrack := mWindow;
    tme.dwHoverTime := 1;
    if (not TrackMouseEvent(tme)) then
    begin
        raise Exception.Create('TrackMouseEvent');
    end;
end;



procedure TMouse.EndOfInputFrame();
begin
    mAutoReset := False;

    if (mMode = MODE_RELATIVE) then
    begin
        mState.x := 0;
        mState.y := 0;
    end;
end;



function TMouse.IsConnected(): boolean;
begin
    Result := GetSystemMetrics(SM_MOUSEPRESENT) <> 0;
end;



function TMouse.IsVisible(): boolean;
var
    info: CURSORINFO;
begin
    Result := False;
    if (mMode = MODE_RELATIVE) then
        Exit;


    info.cbSize := sizeof(CURSORINFO);
    info.flags := 0;
    info.hCursor := 0;
    info.ptScreenPos := TPOINT(nil^);

    if (not GetCursorInfo(info)) then
        Exit;

    Result := (info.flags and CURSOR_SHOWING) <> 0;
end;



procedure TMouse.SetVisible(Visible: boolean);
var
    info: CURSORINFO;
    lIsVisible: boolean;
begin
    if (mMode = MODE_RELATIVE) then
        Exit;

    info.cbSize := sizeof(CURSORINFO);
    info.flags := 0;
    info.hCursor := 0;
    info.ptScreenPos := TPoint(nil^);

    if (not GetCursorInfo(info)) then
    begin
        raise Exception.Create('GetCursorInfo');
    end;

    lIsVisible := (info.flags and CURSOR_SHOWING) <> 0;
    if (lIsVisible <> Visible) then
    begin
        ShowCursor(Visible);
    end;
end;



procedure TMouse.SetWindow(window: HWND);
var
    Rid: RAWINPUTDEVICE;
begin
    if (mWindow = window) then
        Exit;

    assert(window <> 0);

    Rid.usUsagePage := $1 (* HID_USAGE_PAGE_GENERIC *);
    Rid.usUsage := $2 (* HID_USAGE_GENERIC_MOUSE *);
    Rid.dwFlags := RIDEV_INPUTSINK;
    Rid.hwndTarget := window;
    if (not RegisterRawInputDevices(@Rid, 1, sizeof(RAWINPUTDEVICE))) then
    begin
        raise Exception.Create('RegisterRawInputDevices');
    end;


    mWindow := window;
end;



procedure TMouse.ProcessMessage(message: UINT; wParam: WPARAM; lParam: LPARAM);
var
    events: array[0..1] of Handle;
    point: TPOINT;
    raw: RAWINPUT;
    rawSize: UINT;
    resultData: UINT;
    scrollWheel: integer;
    xPos, yPos: integer;
    Width, Height, x, y: longint;
begin
    // First handle any pending scroll wheel reset event.
    case (WaitForSingleObjectEx(mScrollWheelValue, 0, False)) of

        WAIT_OBJECT_0:
        begin
            mState.scrollWheelValue := 0;
            ResetEvent(mScrollWheelValue);
        end;

        WAIT_FAILED:
            raise Exception.Create('WaitForMultipleObjectsEx');
    end;

    // Next handle mode change events.
    events[0] := mAbsoluteMode;
    events[1] := mRelativeMode;
    case (WaitForMultipleObjectsEx(Length(events), @events[0], False, 0, False)) of

        WAIT_OBJECT_0:
        begin
            mMode := MODE_ABSOLUTE;
            ClipCursor(nil);


            point.x := mLastX;
            point.y := mLastY;

            // We show the cursor before moving it to support Remote Desktop
            ShowCursor(True);

            if (MapWindowPoints(mWindow, 0, @point, 1) <> 0) then
            begin
                SetCursorPos(point.x, point.y);
            end;
            mState.x := mLastX;
            mState.y := mLastY;
        end;


        (WAIT_OBJECT_0 + 1):
        begin
            ResetEvent(mRelativeRead);

            mMode := MODE_RELATIVE;
            mState.x := 0;
            mState.y := 0;
            mRelativeX := INT32_MAX;
            mRelativeY := INT32_MAX;

            ShowCursor(False);

            ClipToWindow();
        end;


        WAIT_FAILED:
            raise Exception.Create('WaitForMultipleObjectsEx');
    end;

    case (message) of

        WM_ACTIVATE,
        WM_ACTIVATEAPP:
        begin
            if (wParam <> 0) then
            begin
                mInFocus := True;

                if (mMode = MODE_RELATIVE) then
                begin
                    mState.x := 0;
                    mState.y := 0;

                    ShowCursor(False);

                    ClipToWindow();
                end;
            end
            else
            begin

                scrollWheel := mState.scrollWheelValue;
                FillByte(mState, sizeof(TMouseState), 0);
                mState.scrollWheelValue := scrollWheel;

                if (mMode = MODE_RELATIVE) then
                begin
                    ClipCursor(nil);
                end;

                mInFocus := False;
            end;
            Exit;
        end;

        WM_INPUT:
        begin
            if (mInFocus and (mMode = MODE_RELATIVE)) then
            begin

                rawSize := sizeof(raw);

                resultData := GetRawInputData(HRAWINPUT(lParam), RID_INPUT, @raw, @rawSize, sizeof(RAWINPUTHEADER));
                if (resultData = UINT(-1)) then
                begin
                    raise Exception.Create('GetRawInputData');
                end;

                if (raw.header.dwType = RIM_TYPEMOUSE) then
                begin
                    if ((raw.Data.mouse.usFlags and MOUSE_MOVE_ABSOLUTE) <> MOUSE_MOVE_ABSOLUTE) then
                    begin
                        mState.x := mState.x + raw.Data.mouse.lLastX;
                        mState.y := mState.y + raw.Data.mouse.lLastY;

                        ResetEvent(mRelativeRead);
                    end
                    else if ((raw.Data.mouse.usFlags and MOUSE_VIRTUAL_DESKTOP) = MOUSE_VIRTUAL_DESKTOP) then
                    begin

                        // This is used to make Remote Desktop sessons work
                        Width := GetSystemMetrics(SM_CXVIRTUALSCREEN);
                        Height := GetSystemMetrics(SM_CYVIRTUALSCREEN);

                        x := trunc((single(raw.Data.mouse.lLastX) / 65535.0) * Width);
                        y := trunc((single(raw.Data.mouse.lLastY) / 65535.0) * Height);

                        if (mRelativeX = INT32_MAX) then
                        begin
                            mState.x := 0;
                            mState.y := 0;
                        end
                        else
                        begin
                            mState.x := x - mRelativeX;
                            mState.y := y - mRelativeY;
                        end;

                        mRelativeX := x;
                        mRelativeY := y;

                        ResetEvent(mRelativeRead);
                    end;
                end;
            end;
            exit;
        end;
        WM_MOUSEMOVE:
        begin

        end;

        WM_LBUTTONDOWN:

            mState.leftButton := True;


        WM_LBUTTONUP:

            mState.leftButton := False;


        WM_RBUTTONDOWN:
            mState.rightButton := True;


        WM_RBUTTONUP:

            mState.rightButton := False;


        WM_MBUTTONDOWN:

            mState.middleButton := True;


        WM_MBUTTONUP:
        begin
            mState.middleButton := False;
        end;

        WM_MOUSEWHEEL:
        begin
            mState.scrollWheelValue := mState.scrollWheelValue + GET_WHEEL_DELTA_WPARAM(wParam);
        end;

        WM_XBUTTONDOWN:
        begin
            case (GET_XBUTTON_WPARAM(wParam)) of

                XBUTTON1:
                    mState.xButton1 := True;

                XBUTTON2:
                    mState.xButton2 := True;
            end;
        end;

        WM_XBUTTONUP:
        begin

            case (GET_XBUTTON_WPARAM(wParam)) of
                XBUTTON1:
                    mState.xButton1 := False;


                XBUTTON2:
                    mState.xButton2 := False;

            end;
        end;

        WM_MOUSEHOVER:
        begin

        end;

        else
            // Not a mouse message, so exit
            exit;
    end;

    if (mMode = MODE_ABSOLUTE) then
    begin

        // All mouse messages provide a new pointer position
        xPos := (LOWORD(lParam)); // GET_X_LPARAM(lParam);
        yPos := (HIWORD(lParam)); // GET_Y_LPARAM(lParam);

        mLastX := xPos;
        mLastY := yPos;
        mState.x := xPos;
        mState.y := yPos;
    end;
end;

end.
