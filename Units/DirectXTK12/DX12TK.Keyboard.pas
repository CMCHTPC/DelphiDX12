//--------------------------------------------------------------------------------------
// File: Keyboard.h

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkId=248929
// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------

unit DX12TK.Keyboard;

{$mode delphi}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}

interface

uses
    Windows, Classes, SysUtils,
    DX12.GameInput;

const
    UINT64_MAX = $FFFFFFFFFFFFFFFF;

type

    {$DEFINE USING_GAMEINPUT}

    { TKeyboard }

    TKeyboard = class
    type
        TKeys = (
            tkNone = 0,
            tkBack = $8,
            tkTab = $9,
            tkEnter = $d,
            tkPause = $13,
            tkCapsLock = $14,
            tkKana = $15,
            tkImeOn = $16,
            tkKanji = $19,
            tkImeOff = $1a,
            tkEscape = $1b,
            tkImeConvert = $1c,
            tkImeNoConvert = $1d,
            tkSpace = $20,
            tkPageUp = $21,
            tkPageDown = $22,
            tkEnd = $23,
            tkHome = $24,
            tkLefTKeyboardt = $25,
            tkUp = $26,
            tkRight = $27,
            tkDown = $28,
            tkSelect = $29,
            tkPrint = $2a,
            tkExecute = $2b,
            tkPrintScreen = $2c,
            tkInsert = $2d,
            tkDelete = $2e,
            tkHelp = $2f,
            tkD0 = $30,
            tkD1 = $31,
            tkD2 = $32,
            tkD3 = $33,
            tkD4 = $34,
            tkD5 = $35,
            tkD6 = $36,
            tkD7 = $37,
            tkD8 = $38,
            tkD9 = $39,
            tkA = $41,
            tkB = $42,
            tkC = $43,
            tkD = $44,
            tkE = $45,
            tkF = $46,
            tkG = $47,
            tkH = $48,
            tkI = $49,
            tkJ = $4a,
            tkK = $4b,
            tkL = $4c,
            tkM = $4d,
            tkN = $4e,
            tkO = $4f,
            tkP = $50,
            tkQ = $51,
            tkR = $52,
            tkS = $53,
            tkT = $54,
            tkU = $55,
            tkV = $56,
            tkW = $57,
            tkX = $58,
            tkY = $59,
            tkZ = $5a,
            tkLeftWindows = $5b,
            tkRightWindows = $5c,
            tkApps = $5d,
            tkSleep = $5f,
            tkNumPad0 = $60,
            tkNumPad1 = $61,
            tkNumPad2 = $62,
            tkNumPad3 = $63,
            tkNumPad4 = $64,
            tkNumPad5 = $65,
            tkNumPad6 = $66,
            tkNumPad7 = $67,
            tkNumPad8 = $68,
            tkNumPad9 = $69,
            tkMultiply = $6a,
            tkAdd = $6b,
            tkSeparator = $6c,
            tkSubtract = $6d,
            tkDecimal = $6e,
            tkDivide = $6f,
            tkF1 = $70,
            tkF2 = $71,
            tkF3 = $72,
            tkF4 = $73,
            tkF5 = $74,
            tkF6 = $75,
            tkF7 = $76,
            tkF8 = $77,
            tkF9 = $78,
            tkF10 = $79,
            tkF11 = $7a,
            tkF12 = $7b,
            tkF13 = $7c,
            tkF14 = $7d,
            tkF15 = $7e,
            tkF16 = $7f,
            tkF17 = $80,
            tkF18 = $81,
            tkF19 = $82,
            tkF20 = $83,
            tkF21 = $84,
            tkF22 = $85,
            tkF23 = $86,
            tkF24 = $87,
            tkNumLock = $90,
            tkScroll = $91,
            tkLeftShift = $a0,
            tkRightShift = $a1,
            tkLeftControl = $a2,
            tkRightControl = $a3,
            tkLeftAlt = $a4,
            tkRightAlt = $a5,
            tkBrowserBack = $a6,
            tkBrowserForward = $a7,
            tkBrowserRefresh = $a8,
            tkBrowserStop = $a9,
            tkBrowserSearch = $aa,
            tkBrowserFavorites = $ab,
            tkBrowserHome = $ac,
            tkVolumeMute = $ad,
            tkVolumeDown = $ae,
            tkVolumeUp = $af,
            tkMediaNextTrack = $b0,
            tkMediaPreviousTrack = $b1,
            tkMediaStop = $b2,
            tkMediaPlayPause = $b3,
            tkLaunchMail = $b4,
            tkSelectMedia = $b5,
            tkLaunchApplication1 = $b6,
            tkLaunchApplication2 = $b7,
            tkOemSemicolon = $ba,
            tkOemPlus = $bb,
            tkOemComma = $bc,
            tkOemMinus = $bd,
            tkOemPeriod = $be,
            tkOemQuestion = $bf,
            tkOemTilde = $c0,
            tkOemOpenBrackets = $db,
            tkOemPipe = $dc,
            tkOemCloseBrackets = $dd,
            tkOemQuotes = $de,
            tkOem8 = $df,
            tkOemBackslash = $e2,
            tkProcessKey = $e5,
            tkOemCopy = $f2,
            tkOemAuto = $f3,
            tkOemEnlW = $f4,
            tkAttn = $f6,
            tkCrsel = $f7,
            tkExsel = $f8,
            tkEraseEof = $f9,
            tkPlay = $fa,
            tkZoom = $fb,
            tkPa1 = $fd,
            tkOemClear = $fe);

        PKeys = ^TKeys;

        { TState }

        TState = bitpacked record
            function IsKeyDown(key: TKeys): boolean;
            function IsKeyUp(key: TKeys): boolean;
            case integer of
                0: (
                    sReserved0: 0..255;
                    sBack: 0..1; // VK_BACK, 0x8
                    sTab: 0..1; // VK_TAB, 0x9
                    sReserved1: 0..7;
                    sEnter: 0..1; // VK_RETURN, 0xD
                    sReserved2: 0..3;
                    sReserved3: 0..7;
                    sPause: 0..1; // VK_PAUSE, 0x13
                    sCapsLock: 0..1; // VK_CAPITAL, 0x14
                    sKana: 0..1; // VK_KANA, 0x15
                    sImeOn: 0..1; // VK_IME_ON, 0x16
                    sReserved4: 0..1;
                    sReserved5: 0..1;
                    sKanji: 0..1; // VK_KANJI, 0x19
                    sImeOff: 0..1; // VK_IME_OFF, 0X1A
                    sEscape: 0..1; // VK_ESCAPE, 0x1B
                    sImeConvert: 0..1; // VK_CONVERT, 0x1C
                    sImeNoConvert: 0..1; // VK_NONCONVERT, 0x1D
                    sReserved7: 0..3;
                    sSpace: 0..1; // VK_SPACE, 0x20
                    sPageUp: 0..1; // VK_PRIOR, 0x21
                    sPageDown: 0..1; // VK_NEXT, 0x22
                    sEnd: 0..1; // VK_END, 0x23
                    sHome: 0..1; // VK_HOME, 0x24
                    sLeft: 0..1; // VK_LEFT, 0x25
                    sUp: 0..1; // VK_UP, 0x26
                    sRight: 0..1; // VK_RIGHT, 0x27
                    sDown: 0..1; // VK_DOWN, 0x28
                    sSelect: 0..1; // VK_SELECT, 0x29
                    sPrint: 0..1; // VK_PRINT, 0x2A
                    sExecute: 0..1; // VK_EXECUTE, 0x2B
                    sPrintScreen: 0..1; // VK_SNAPSHOT, 0x2C
                    sInsert: 0..1; // VK_INSERT, 0x2D
                    sDelete: 0..1; // VK_DELETE, 0x2E
                    sHelp: 0..1; // VK_HELP, 0x2F
                    sD0: 0..1; // 0x30
                    sD1: 0..1; // 0x31
                    sD2: 0..1; // 0x32
                    sD3: 0..1; // 0x33
                    sD4: 0..1; // 0x34
                    sD5: 0..1; // 0x35
                    sD6: 0..1; // 0x36
                    sD7: 0..1; // 0x37
                    sD8: 0..1; // 0x38
                    sD9: 0..1; // 0x39
                    sReserved8: 0..63;
                    sReserved9: 0..1;
                    sA: 0..1; // 0x41
                    sB: 0..1; // 0x42
                    sC: 0..1; // 0x43
                    sD: 0..1; // 0x44
                    sE: 0..1; // 0x45
                    sF: 0..1; // 0x46
                    sG: 0..1; // 0x47
                    sH: 0..1; // 0x48
                    sI: 0..1; // 0x49
                    sJ: 0..1; // 0x4A
                    sK: 0..1; // 0x4B
                    sL: 0..1; // 0x4C
                    sM: 0..1; // 0x4D
                    sN: 0..1; // 0x4E
                    sO: 0..1; // 0x4F
                    sP: 0..1; // 0x50
                    sQ: 0..1; // 0x51
                    sR: 0..1; // 0x52
                    sS: 0..1; // 0x53
                    sT: 0..1; // 0x54
                    sU: 0..1; // 0x55
                    sV: 0..1; // 0x56
                    sW: 0..1; // 0x57
                    sX: 0..1; // 0x58
                    sY: 0..1; // 0x59
                    sZ: 0..1; // 0x5A
                    sLeftWindows: 0..1; // VK_LWIN, 0x5B
                    sRightWindows: 0..1; // VK_RWIN, 0x5C
                    sApps: 0..1; // VK_APPS, 0x5D
                    sReserved10: 0..1;
                    sSleep: 0..1; // VK_SLEEP, 0x5F
                    sNumPad0: 0..1; // VK_NUMPAD0, 0x60
                    sNumPad1: 0..1; // VK_NUMPAD1, 0x61
                    sNumPad2: 0..1; // VK_NUMPAD2, 0x62
                    sNumPad3: 0..1; // VK_NUMPAD3, 0x63
                    sNumPad4: 0..1; // VK_NUMPAD4, 0x64
                    sNumPad5: 0..1; // VK_NUMPAD5, 0x65
                    sNumPad6: 0..1; // VK_NUMPAD6, 0x66
                    sNumPad7: 0..1; // VK_NUMPAD7, 0x67
                    sNumPad8: 0..1; // VK_NUMPAD8, 0x68
                    sNumPad9: 0..1; // VK_NUMPAD9, 0x69
                    sMultiply: 0..1; // VK_MULTIPLY, 0x6A
                    sAdd: 0..1; // VK_ADD, 0x6B
                    sSeparator: 0..1; // VK_SEPARATOR, 0x6C
                    sSubtract: 0..1; // VK_SUBTRACT, 0x6D
                    sDecimal: 0..1; // VK_DECIMANL, 0x6E
                    sDivide: 0..1; // VK_DIVIDE, 0x6F
                    sF1: 0..1; // VK_F1, 0x70
                    sF2: 0..1; // VK_F2, 0x71
                    sF3: 0..1; // VK_F3, 0x72
                    sF4: 0..1; // VK_F4, 0x73
                    sF5: 0..1; // VK_F5, 0x74
                    sF6: 0..1; // VK_F6, 0x75
                    sF7: 0..1; // VK_F7, 0x76
                    sF8: 0..1; // VK_F8, 0x77
                    sF9: 0..1; // VK_F9, 0x78
                    sF10: 0..1; // VK_F10, 0x79
                    sF11: 0..1; // VK_F11, 0x7A
                    sF12: 0..1; // VK_F12, 0x7B
                    sF13: 0..1; // VK_F13, 0x7C
                    sF14: 0..1; // VK_F14, 0x7D
                    sF15: 0..1; // VK_F15, 0x7E
                    sF16: 0..1; // VK_F16, 0x7F
                    sF17: 0..1; // VK_F17, 0x80
                    sF18: 0..1; // VK_F18, 0x81
                    sF19: 0..1; // VK_F19, 0x82
                    sF20: 0..1; // VK_F20, 0x83
                    sF21: 0..1; // VK_F21, 0x84
                    sF22: 0..1; // VK_F22, 0x85
                    sF23: 0..1; // VK_F23, 0x86
                    sF24: 0..1; // VK_F24, 0x87
                    sReserved11: 0..255;
                    sNumLock: 0..1; // VK_NUMLOCK, 0x90
                    sScroll: 0..1; // VK_SCROLL, 0x91
                    sReserved12: 0..63;
                    sReserved13: 0..255;
                    sLeftShift: 0..1; // VK_LSHIFT, 0xA0
                    sRightShift: 0..1; // VK_RSHIFT, 0xA1
                    sLeftControl: 0..1; // VK_LCONTROL, 0xA2
                    sRightControl: 0..1; // VK_RCONTROL, 0xA3
                    sLeftAlt: 0..1; // VK_LMENU, 0xA4
                    sRightAlt: 0..1; // VK_RMENU, 0xA5
                    sBrowserBack: 0..1; // VK_BROWSER_BACK, 0xA6
                    sBrowserForward: 0..1; // VK_BROWSER_FORWARD, 0xA7
                    sBrowserRefresh: 0..1; // VK_BROWSER_REFRESH, 0xA8
                    sBrowserStop: 0..1; // VK_BROWSER_STOP, 0xA9
                    sBrowserSearch: 0..1; // VK_BROWSER_SEARCH, 0xAA
                    sBrowserFavorites: 0..1; // VK_BROWSER_FAVORITES, 0xAB
                    sBrowserHome: 0..1; // VK_BROWSER_HOME, 0xAC
                    sVolumeMute: 0..1; // VK_VOLUME_MUTE, 0xAD
                    sVolumeDown: 0..1; // VK_VOLUME_DOWN, 0xAE
                    sVolumeUp: 0..1; // VK_VOLUME_UP, 0xAF
                    sMediaNextTrack: 0..1; // VK_MEDIA_NEXT_TRACK, 0xB0
                    sMediaPreviousTrack: 0..1; // VK_MEDIA_PREV_TRACK, 0xB1
                    sMediaStop: 0..1; // VK_MEDIA_STOP, 0xB2
                    sMediaPlayPause: 0..1; // VK_MEDIA_PLAY_PAUSE, 0xB3
                    sLaunchMail: 0..1; // VK_LAUNCH_MAIL, 0xB4
                    sSelectMedia: 0..1; // VK_LAUNCH_MEDIA_SELECT, 0xB5
                    sLaunchApplication1: 0..1; // VK_LAUNCH_APP1, 0xB6
                    sLaunchApplication2: 0..1; // VK_LAUNCH_APP2, 0xB7
                    sReserved14: 0..3;
                    sOemSemicolon: 0..1; // VK_OEM_1, 0xBA
                    sOemPlus: 0..1; // VK_OEM_PLUS, 0xBB
                    sOemComma: 0..1; // VK_OEM_COMMA, 0xBC
                    sOemMinus: 0..1; // VK_OEM_MINUS, 0xBD
                    sOemPeriod: 0..1; // VK_OEM_PERIOD, 0xBE
                    sOemQuestion: 0..1; // VK_OEM_2, 0xBF
                    sOemTilde: 0..1; // VK_OEM_3, 0xC0
                    sReserved15: 0..127;
                    sReserved16: 0..255;
                    sReserved17: 0..255;
                    sReserved18: 0..7;
                    sOemOpenBrackets: 0..1; // VK_OEM_4, 0xDB
                    sOemPipe: 0..1; // VK_OEM_5, 0xDC
                    sOemCloseBrackets: 0..1; // VK_OEM_6, 0xDD
                    sOemQuotes: 0..1; // VK_OEM_7, 0xDE
                    sOem8: 0..1; // VK_OEM_8, 0xDF
                    sReserved19: 0..3;
                    sOemBackslash: 0..1; // VK_OEM_102, 0xE2
                    sReserved20: 0..3;
                    sProcessKey: 0..1; // VK_PROCESSKEY, 0xE5
                    sReserved21: 0..3;
                    sReserved22: 0..255;
                    sReserved23: 0..3;
                    sOemCopy: 0..1; // 0XF2
                    sOemAuto: 0..1; // 0xF3
                    sOemEnlW: 0..1; // 0xF4
                    sReserved24: 0..1;
                    sAttn: 0..1; // VK_ATTN, 0xF6
                    sCrsel: 0..1; // VK_CRSEL, 0xF7
                    sExsel: 0..1; // VK_EXSEL, 0xF8
                    sEraseEof: 0..1; // VK_EREOF, 0xF9
                    sPlay: 0..1; // VK_PLAY, 0xFA
                    sZoom: 0..1; // VK_ZOOM, 0xFB
                    sReserved25: 0..1;
                    sPa1: 0..1; // VK_PA1, 0xFD
                    sOemClear: 0..1; // VK_OEM_CLEAR, 0xFE
                    sReserved26: 0..1;
                );
                1: (Value: array[0..7] of uint32);


        end;
        PState = ^TState;
        {$if sizeof(TState) <> 256 div 8}
        {$error Size mismatch for TState}
        {$endif}

        { TKeyboardStateTracker }

        TKeyboardStateTracker = record
            released: TState;
            pressed: TState;
            lastState: TState;
            procedure Update(state: PState);
            procedure Reset;
            function IsKeyPressed(key: TKeys): boolean;
            function IsKeyReleased(key: TKeys): boolean;
            function GetLastState(): TState;
        end;

    const
        c_MaxSimultaneousKeys = 16;










    protected
        s_Keyboard : TKeyboard; static;
        mConnected: uint32;
        mState: TState;
        mGameInput: IGameInput;
        mDeviceToken: TGameInputCallbackToken;
        mKeyState: array [0..c_MaxSimultaneousKeys - 1] of TGameInputKeyState;
    protected
        procedure KeyDown(key: integer; state: TKeyboard.PState); inline;
        procedure KeyUp(key: integer; state: TKeyboard.PState); inline;
    public
        constructor Create;
        destructor Destroy; override;
        // Retrieve the current state of the keyboard
        procedure GetState(state: PState);

        // Reset the keyboard state
        procedure Reset();

        // Feature detection
        function IsConnected(): boolean;

        procedure ProcessMessage(message: UINT; wParam: WPARAM; lParam: LPARAM); stdcall;


    end;


var
    s_gameInputModule: HMODULE = 0;
    s_gameInputCreate: TGameInputCreateFn = nil;

implementation

uses
    DX12TK.PlatformHelpers;



procedure OnGameInputDevice(
    {_In_ } callbackToken: TGameInputCallbackToken;
    {_In_ } context: Pvoid;
    {_In_ } device: IGameInputDevice;
    {_In_ } timestamp: uint64;
    {_In_ } currentStatus: TGameInputDeviceStatus;
    {_In_ } previousStatus: TGameInputDeviceStatus); stdcall;
var
    wasConnected, isConnected: boolean;
    impl: TKeyboard;
begin
    impl := TKeyboard(context);
    wasConnected := (Ord(previousStatus) and Ord(GameInputDeviceConnected)) <> 0;
    isConnected := (Ord(currentStatus) and Ord(GameInputDeviceConnected)) <> 0;

    if (isConnected and not wasConnected) then
    begin
        impl.mConnected := impl.mConnected + 1;
    end

    else if (not isConnected and wasConnected and (impl.mConnected > 0)) then
    begin
        impl.mConnected := impl.mConnected - 1;
    end;
end;

{ TKeyboard }

procedure TKeyboard.KeyDown(key: integer; state: TKeyboard.PState);
var
    bf: integer;
begin
    if (key < 0) or (key > $fe) then
        Exit;

    bf := 1 shl (key and $1f);
    state^.Value[(key shr 5)] := state^.Value[(key shr 5)] or bf;
end;



procedure TKeyboard.KeyUp(key: integer; state: TKeyboard.PState);
var
    bf: integer;
begin
    if (key < 0) or (key > $fe) then
        Exit;

    bf := 1 shl (key and $1f);
    state^.Value[(key shr 5)] := state^.Value[(key shr 5)] and not bf;
end;



constructor TKeyboard.Create;
var
    hr: HResult;
begin
    if s_Keyboard<>nil then
    raise Exception.Create('DX12TK.TKeyboard is a singleton');
     s_Keyboard := self;

    {$IFDEF USING_GAMEINPUT}
    if (@s_gameInputCreate = nil) then
    begin
        s_gameInputModule := LoadLibraryExW('GameInput.dll', 0, LOAD_LIBRARY_SEARCH_SYSTEM32);
        if (s_gameInputModule <> 0) then
        begin
            s_gameInputCreate := TGameInputCreateFn(GetProcAddress(s_gameInputModule, 'GameInputCreate'));
        end;

        if (@s_gameInputCreate = nil) then
        begin
            DebugTrace('ERROR: GetProcAddress GameInputCreate failed\n', []);
            raise Exception.Create('GameInput.dll is not installed on this system');
        end;
    end;

    hr := s_gameInputCreate(mGameInput);

    if (SUCCEEDED(hr)) then
    begin
        ThrowIfFailed(mGameInput.RegisterDeviceCallback(nil, GameInputKindKeyboard, GameInputDeviceConnected, GameInputBlockingEnumeration, self, OnGameInputDevice, @mDeviceToken));
    end
    else
    begin
        DebugTrace('ERROR: GameInputCreate [keyboard] failed with %08X\n', [hr]);
        DebugTrace('\t**** Install the latest GameInputRedist package on this system.       ****\n' + '\t**** NOTE: All calls to GetState will be reported as ''not connected''. ****\n', []);
    end;
    {$ENDIF}
end;



destructor TKeyboard.Destroy;
begin
    {$IFDEF USING_GAMEINPUT}
    if (mDeviceToken <> 0) then
    begin
        if (mGameInput <> nil) then
        begin
            if (not mGameInput.UnregisterCallback(mDeviceToken {, UINT64_MAX})) then
            begin
                DebugTrace('ERROR: GameInput::UnregisterCallback [keyboard] failed', []);
            end;
        end;

        mDeviceToken := 0;
    end;
    {$ENDIF}
    s_Keyboard:=nil;
    inherited Destroy;
end;



procedure TKeyboard.GetState(state: PState);
var
    reading: IGameInputReading;
    readCount: uint32;
    J: size_t;
    vk: int32;
begin
    {$IFDEF USING_GAMEINPUT}
    if (mGameInput = nil) then
        exit;

    if (SUCCEEDED(mGameInput.GetCurrentReading(GameInputKindKeyboard, nil, reading))) then
    begin
        readCount := reading.GetKeyState(c_MaxSimultaneousKeys, mKeyState);
        for  j := 0 to readCount - 1 do
        begin
            vk := int32(mKeyState[j].virtualKey);
            // Workaround for known issues with VK_RSHIFT and VK_NUMLOCK
            if (vk = 0) then
            begin
                case (mKeyState[j].scanCode) of

                    $e036: vk := VK_RSHIFT;
                    $e045: vk := VK_NUMLOCK;

                end;
            end;

            KeyDown(vk, state);
        end;
    end;
    {$ELSE}
    Move(mState, state^ , sizeOf(TState));
    {$ENDIF}
end;



procedure TKeyboard.Reset();
begin
    {$IFDEF USING_GAMEINPUT}
    {$ELSE}
    FillByte(mState, sizeOf(TState), 0);
    {$ENDIF}
end;



function TKeyboard.IsConnected(): boolean;
begin
    {$IFDEF USING_GAMEINPUT}
    Result := (mConnected > 0);
    {$ELSE}
    Result := True;
    {$ENDIF}
end;


//======================================================================================
// Win32 desktop implementation
//======================================================================================
// For a Win32 desktop application, call this function from your Window Message Procedure
// LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
// {
//     switch (message)
//     {
//     case WM_ACTIVATE:
//     case WM_ACTIVATEAPP:
//         Keyboard::ProcessMessage(message, wParam, lParam);
//         break;
//     case WM_KEYDOWN:
//     case WM_SYSKEYDOWN:
//     case WM_KEYUP:
//     case WM_SYSKEYUP:
//         Keyboard::ProcessMessage(message, wParam, lParam);
//         break;
//     }
// }

procedure TKeyboard.ProcessMessage(message: UINT; wParam: WPARAM; lParam: LPARAM); stdcall;
var
    down: boolean = False;
    vk: integer;
    isExtendedKey: boolean;
    scanCode: integer;
begin

    case (message) of

        WM_ACTIVATE,
        WM_ACTIVATEAPP:
        begin
            Reset();
            Exit;
        end;

        WM_KEYDOWN,
        WM_SYSKEYDOWN:
        begin
            down := True;
        end;

        WM_KEYUP,
        WM_SYSKEYUP:
        begin
        end

        else
            exit;
    end;

    vk := LOWORD(wParam);
    // We want to distinguish left and right shift/ctrl/alt keys
    case (vk) of

        VK_SHIFT,
        VK_CONTROL,
        VK_MENU:
        begin
            if ((vk = VK_SHIFT) and not down) then
            begin
                // Workaround to ensure left vs. right shift get cleared when both were pressed at same time
                KeyUp(VK_LSHIFT, @mState);
                KeyUp(VK_RSHIFT, @mState);
            end;

            isExtendedKey := (HIWORD(lParam) and KF_EXTENDED) = KF_EXTENDED;
            scanCode := LOBYTE(HIWORD(lParam));
            if isExtendedKey then
                scanCode := scanCode or $e000;
            vk := LOWORD(MapVirtualKeyW(UINT(scanCode), MAPVK_VSC_TO_VK_EX));

        end;

    end;

    if (down) then
    begin
        KeyDown(vk, @mState);
    end
    else
    begin
        KeyUp(vk, @mState);
    end;
end;


//--------------------------------------------------------------------------------------
// File: Keyboard.cpp

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkId=248929
// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------

{ TKeyboard.TState }

function TKeyboard.TState.IsKeyDown(key: TKeys): boolean;
var
    bf: integer;
begin
    Result := False;
    if (Ord(key) <= $fe) then
    begin
        bf := 1 shl (Ord(key) and $1f);
        Result := (Value[(Ord(key) shr 5)] and bf) <> 0;
    end;

end;



function TKeyboard.TState.IsKeyUp(key: TKeys): boolean;
var
    bf: integer;
begin
    Result := False;
    if (Ord(key) <= $fe) then
    begin
        bf := 1 shl (Ord(key) and $1f);
        Result := (Value[(Ord(key) shr 5)] and bf) = 0;
    end;
end;


//======================================================================================
// KeyboardStateTracker
//======================================================================================
{ TKeyboard.TKeyboardStateTracker }

procedure TKeyboard.TKeyboardStateTracker.Update(state: PState);
var
    j: size_t;
begin
    for j := 0 to (256 div 32) - 1 do
    begin
        pressed.Value[j] := state^.Value[j] and not lastState.Value[j];
        released.Value[j] := not state^.Value[j] and lastState.Value[j];
    end;
    lastState := state^;
end;



procedure TKeyboard.TKeyboardStateTracker.Reset;
begin
    FillByte(self, sizeof(TKeyboardStateTracker), 0);
end;



function TKeyboard.TKeyboardStateTracker.IsKeyPressed(key: TKeys): boolean;
begin
    Result := pressed.IsKeyDown(key);
end;



function TKeyboard.TKeyboardStateTracker.IsKeyReleased(key: TKeys): boolean;
begin
    Result := released.IsKeyDown(key);
end;



function TKeyboard.TKeyboardStateTracker.GetLastState(): TState;
begin
    Result := lastState;
end;

end.
