(***************************************************************************
*                                                                          *
*   XInput.h -- This module defines Xbox 360 Common Controller APIs        *
*               and constants for the Windows platform.                    *
*                                                                          *
*   Copyright (c) Microsoft Corp. All rights reserved.                     *
*                                                                          *
***************************************************************************)
unit DX12.XInput;

interface

uses
    Windows, Classes, SysUtils;

// Current name of the DLL shipped in the same SDK as this header.
// The name reflects the current version


const
  _WIN32_WINNT_WIN8 = 8;
  _WIN32_WINNT_WIN10 = 10;
  _WIN32_WINNT =  _WIN32_WINNT_WIN8;

{$IF _WIN32_WINNT >= _WIN32_WINNT_WIN8}
    XINPUT_DLL = 'xinput1_4.dll';
{$ELSE}
    XINPUT_DLL = 'xinput9_1_0.dll';
{$ENDIF}


const

    // Device types available in XINPUT_CAPABILITIES

    XINPUT_DEVTYPE_GAMEPAD = $01;

    // Device subtypes available in XINPUT_CAPABILITIES

    XINPUT_DEVSUBTYPE_GAMEPAD = $01;

{$IF (_WIN32_WINNT >= _WIN32_WINNT_WIN8)}
    XINPUT_DEVSUBTYPE_UNKNOWN = $00;
    XINPUT_DEVSUBTYPE_WHEEL = $02;
    XINPUT_DEVSUBTYPE_ARCADE_STICK = $03;
    XINPUT_DEVSUBTYPE_FLIGHT_STICK = $04;
    XINPUT_DEVSUBTYPE_DANCE_PAD = $05;
    XINPUT_DEVSUBTYPE_GUITAR = $06;
    XINPUT_DEVSUBTYPE_GUITAR_ALTERNATE = $07;
    XINPUT_DEVSUBTYPE_DRUM_KIT = $08;
    XINPUT_DEVSUBTYPE_GUITAR_BASS = $0B;
    XINPUT_DEVSUBTYPE_ARCADE_PAD = $13;
{$ENDIF}//(_WIN32_WINNT >= _WIN32_WINNT_WIN8)


    // Flags for XINPUT_CAPABILITIES

    XINPUT_CAPS_VOICE_SUPPORTED = $0004;

{$IF (_WIN32_WINNT >= _WIN32_WINNT_WIN8)}
    XINPUT_CAPS_FFB_SUPPORTED = $0001;
    XINPUT_CAPS_WIRELESS = $0002;
    XINPUT_CAPS_PMD_SUPPORTED = $0008;
    XINPUT_CAPS_NO_NAVIGATION = $0010;
{$ENDIF}//(_WIN32_WINNT >= _WIN32_WINNT_WIN8)


    // Constants for gamepad buttons
    XINPUT_GAMEPAD_DPAD_UP = $0001;
    XINPUT_GAMEPAD_DPAD_DOWN = $0002;
    XINPUT_GAMEPAD_DPAD_LEFT = $0004;
    XINPUT_GAMEPAD_DPAD_RIGHT = $0008;
    XINPUT_GAMEPAD_START = $0010;
    XINPUT_GAMEPAD_BACK = $0020;
    XINPUT_GAMEPAD_LEFT_THUMB = $0040;
    XINPUT_GAMEPAD_RIGHT_THUMB = $0080;
    XINPUT_GAMEPAD_LEFT_SHOULDER = $0100;
    XINPUT_GAMEPAD_RIGHT_SHOULDER = $0200;
    XINPUT_GAMEPAD_A = $1000;
    XINPUT_GAMEPAD_B = $2000;
    XINPUT_GAMEPAD_X = $4000;
    XINPUT_GAMEPAD_Y = $8000;

    // Gamepad thresholds
    XINPUT_GAMEPAD_LEFT_THUMB_DEADZONE = 7849;
    XINPUT_GAMEPAD_RIGHT_THUMB_DEADZONE = 8689;
    XINPUT_GAMEPAD_TRIGGER_THRESHOLD = 30;

    // Flags to pass to XInputGetCapabilities

    XINPUT_FLAG_GAMEPAD = $00000001;

{$IF (_WIN32_WINNT >= _WIN32_WINNT_WIN8)}
    // Devices that support batteries
    BATTERY_DEVTYPE_GAMEPAD = $00;
    BATTERY_DEVTYPE_HEADSET = $01;

    // Flags for battery status level
    BATTERY_TYPE_DISCONNECTED = $00;  // This device is not connected
    BATTERY_TYPE_WIRED = $01;  // Wired device, no battery
    BATTERY_TYPE_ALKALINE = $02;   // Alkaline battery source
    BATTERY_TYPE_NIMH = $03;   // Nickel Metal Hydride battery source
    BATTERY_TYPE_UNKNOWN = $FF;   // Cannot determine the battery type

    // These are only valid for wireless, connected devices, with known battery types
    // The amount of use time remaining depends on the type of device.
    BATTERY_LEVEL_EMPTY = $00;
    BATTERY_LEVEL_LOW = $01;
    BATTERY_LEVEL_MEDIUM = $02;
    BATTERY_LEVEL_FULL = $03;
{$ENDIF}//(_WIN32_WINNT >= _WIN32_WINNT_WIN8)

    // User index definitions
    XUSER_MAX_COUNT = 4;

    XUSER_INDEX_ANY = $000000FF;

{$IF (_WIN32_WINNT >= _WIN32_WINNT_WIN8)}


    // Codes returned for the gamepad keystroke
    VK_PAD_A = $5800;
    VK_PAD_B = $5801;
    VK_PAD_X = $5802;
    VK_PAD_Y = $5803;
    VK_PAD_RSHOULDER = $5804;
    VK_PAD_LSHOULDER = $5805;
    VK_PAD_LTRIGGER = $5806;
    VK_PAD_RTRIGGER = $5807;

    VK_PAD_DPAD_UP = $5810;
    VK_PAD_DPAD_DOWN = $5811;
    VK_PAD_DPAD_LEFT = $5812;
    VK_PAD_DPAD_RIGHT = $5813;
    VK_PAD_START = $5814;
    VK_PAD_BACK = $5815;
    VK_PAD_LTHUMB_PRESS = $5816;
    VK_PAD_RTHUMB_PRESS = $5817;

    VK_PAD_LTHUMB_UP = $5820;
    VK_PAD_LTHUMB_DOWN = $5821;
    VK_PAD_LTHUMB_RIGHT = $5822;
    VK_PAD_LTHUMB_LEFT = $5823;
    VK_PAD_LTHUMB_UPLEFT = $5824;
    VK_PAD_LTHUMB_UPRIGHT = $5825;
    VK_PAD_LTHUMB_DOWNRIGHT = $5826;
    VK_PAD_LTHUMB_DOWNLEFT = $5827;

    VK_PAD_RTHUMB_UP = $5830;
    VK_PAD_RTHUMB_DOWN = $5831;
    VK_PAD_RTHUMB_RIGHT = $5832;
    VK_PAD_RTHUMB_LEFT = $5833;
    VK_PAD_RTHUMB_UPLEFT = $5834;
    VK_PAD_RTHUMB_UPRIGHT = $5835;
    VK_PAD_RTHUMB_DOWNRIGHT = $5836;
    VK_PAD_RTHUMB_DOWNLEFT = $5837;

    // Flags used in XINPUT_KEYSTROKE

    XINPUT_KEYSTROKE_KEYDOWN = $0001;
    XINPUT_KEYSTROKE_KEYUP = $0002;
    XINPUT_KEYSTROKE_REPEAT = $0004;

{$ENDIF}//(_WIN32_WINNT >= _WIN32_WINNT_WIN8)

type

    // Structures used by XInput APIs

    TXINPUT_GAMEPAD = record
        wButtons: word;
        bLeftTrigger: byte;
        bRightTrigger: byte;
        sThumbLX: SHORT;
        sThumbLY: SHORT;
        sThumbRX: SHORT;
        sThumbRY: SHORT;
    end;
    PXINPUT_GAMEPAD = ^TXINPUT_GAMEPAD;

    TXINPUT_STATE = record
        dwPacketNumber: DWORD;
        Gamepad: TXINPUT_GAMEPAD;
    end;
    PXINPUT_STATE = ^TXINPUT_STATE;

    TXINPUT_VIBRATION = record
        wLeftMotorSpeed: word;
        wRightMotorSpeed: word;
    end;
    PXINPUT_VIBRATION = ^TXINPUT_VIBRATION;

    TXINPUT_CAPABILITIES = record
        _Type: byte;
        SubType: byte;
        Flags: word;
        Gamepad: TXINPUT_GAMEPAD;
        Vibration: TXINPUT_VIBRATION;
    end;
    PXINPUT_CAPABILITIES = ^TXINPUT_CAPABILITIES;

{$IF (_WIN32_WINNT >= _WIN32_WINNT_WIN8)}

    TXINPUT_BATTERY_INFORMATION = record
        BatteryType: byte;
        BatteryLevel: byte;
    end;
    PXINPUT_BATTERY_INFORMATION = ^TXINPUT_BATTERY_INFORMATION;

    TXINPUT_KEYSTROKE = record
        VirtualKey: word;
        Unicode: WCHAR;
        Flags: word;
        UserIndex: byte;
        HidCode: byte;
    end;
    PXINPUT_KEYSTROKE = ^TXINPUT_KEYSTROKE;

{$ENDIF}//(_WIN32_WINNT >= _WIN32_WINNT_WIN8)


// XInput APIs

function XInputGetState(dwUserIndex: DWORD;  // Index of the gamer associated with the device
    out pState: TXINPUT_STATE       // Receives the current state
    ): DWORD; stdcall; external XINPUT_DLL;

function XInputSetState(dwUserIndex: DWORD;  // Index of the gamer associated with the device
    pVibration: TXINPUT_VIBRATION    // The vibration information to send to the controller
    ): DWORD; stdcall; external XINPUT_DLL;

function XInputGetCapabilities(dwUserIndex: DWORD;   // Index of the gamer associated with the device
    dwFlags: DWORD;       // Input flags that identify the device type
    out pCapabilities: TXINPUT_CAPABILITIES // Receives the capabilities
    ): DWORD; stdcall; external XINPUT_DLL;

{$IF (_WIN32_WINNT >= _WIN32_WINNT_WIN8)}

procedure XInputEnable(enable: boolean     // [in] Indicates whether xinput is enabled or disabled.
    ); stdcall; external XINPUT_DLL;

{$IF (_WIN32_WINNT >= _WIN32_WINNT_WIN10)}
//  deprecated(XInputEnable);
{$ENDIF}

function XInputGetAudioDeviceIds(dwUserIndex: DWORD;        // Index of the gamer associated with the device
    out pRenderDeviceId: LPWSTR;    // Windows Core Audio device ID string for render (speakers)
    var pRenderCount: UINT;       // Size of render device ID string buffer (in wide-chars)
    out pCaptureDeviceId: LPWSTR;   // Windows Core Audio device ID string for capture (microphone)
    var pCaptureCount: UINT      // Size of capture device ID string buffer (in wide-chars)
    ): DWORD; stdcall; external XINPUT_DLL;

function XInputGetBatteryInformation(dwUserIndex: DWORD;        // Index of the gamer associated with the device
    devType: byte;            // Which device on this user index
    out pBatteryInformation: TXINPUT_BATTERY_INFORMATION // Contains the level and types of batteries
    ): DWORD; stdcall; external XINPUT_DLL;

function XInputGetKeystroke(dwUserIndex: DWORD;              // Index of the gamer associated with the device
    dwReserved: DWORD;               // Reserved for future use
    out pKeystroke: PXINPUT_KEYSTROKE   // Pointer to an XINPUT_KEYSTROKE structure that receives an input event.
    ): DWORD; stdcall; external XINPUT_DLL;

{$ENDIF}//(_WIN32_WINNT >= _WIN32_WINNT_WIN8)


{$IF (_WIN32_WINNT < _WIN32_WINNT_WIN8)}

function XInputGetDSoundAudioDeviceGuids(dwUserIndex: DWORD;          // Index of the gamer associated with the device
    out pDSoundRenderGuid: TGUID;    // DSound device ID for render (speakers)
    out pDSoundCaptureGuid: TGUID    // DSound device ID for capture (microphone)
    ): DWORD; stdcall; external XINPUT_DLL;

{$ENDIF}//(_WIN32_WINNT < _WIN32_WINNT_WIN8)



implementation

end.
