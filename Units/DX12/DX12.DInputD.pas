{ **************************************************************************
    FreePascal/Delphi DirectX 12 Header Files

    Copyright (C) 2013-2025 Norbert Sonnleitner

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
************************************************************************** }

{ **************************************************************************
   Additional Copyright (C) for this modul:

   Copyright (C) 1995-2000 Microsoft Corporation.  All Rights Reserved.
   Content:    DirectInput include file for device driver implementors

   This unit consists of the following header files
   File name: dinputd.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.DInputD;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.DInput;

    {$Z4}

const

    DIRECTINPUT_VERSION = $0800;

(****************************************************************************
 *
 *      Interfaces
 *
 ****************************************************************************)


    IID_IDirectInputEffectDriver: TGUID = '{02538130-898F-11D0-9AD0-00A0C9A06E35}';
    IID_IDirectInputJoyConfig: TGUID = '{1DE12AB1-C9F5-11CF-BFC7-444553540000}';
    IID_IDirectInputPIDDriver: TGUID = '{EEC6993A-B3FD-11D2-A916-00C04FB98638}';

    IID_IDirectInputJoyConfig8: TGUID = '{EB0D7DFA-1990-4F27-B4D6-EDF2EEC4A44C}';




(****************************************************************************
 *
 *      IDirectInputJoyConfig
 *
 ****************************************************************************)
(****************************************************************************
 *
 *      Definitions copied from the DDK
 *
 ****************************************************************************)
(* pre-defined joystick types *)




JOY_HW_NONE = 0;
JOY_HW_CUSTOM = 1;
JOY_HW_2A_2B_GENERIC = 2;
JOY_HW_2A_4B_GENERIC = 3;
JOY_HW_2B_GAMEPAD = 4;
JOY_HW_2B_FLIGHTYOKE = 5;
JOY_HW_2B_FLIGHTYOKETHROTTLE = 6;
JOY_HW_3A_2B_GENERIC = 7;
JOY_HW_3A_4B_GENERIC = 8;
JOY_HW_4B_GAMEPAD = 9;
JOY_HW_4B_FLIGHTYOKE = 10;
JOY_HW_4B_FLIGHTYOKETHROTTLE = 11;
JOY_HW_TWO_2A_2B_WITH_Y = 12;
JOY_HW_LASTENTRY = 13;


(* calibration flags *)
JOY_ISCAL_XY = $00000001; (* XY are calibrated *)
JOY_ISCAL_Z = $00000002; (* Z is calibrated *)
JOY_ISCAL_R = $00000004; (* R is calibrated *)
JOY_ISCAL_U = $00000008; (* U is calibrated *)
JOY_ISCAL_V = $00000010; (* V is calibrated *)
JOY_ISCAL_POV = $00000020; (* POV is calibrated *)

(* point of view constants *)
JOY_POV_NUMDIRS = 4;
JOY_POVVAL_FORWARD = 0;
JOY_POVVAL_BACKWARD = 1;
JOY_POVVAL_LEFT = 2;
JOY_POVVAL_RIGHT = 3;

(* Specific settings for joystick hardware *)
JOY_HWS_HASZ = $00000001; (* has Z info? *)
JOY_HWS_HASPOV = $00000002; (* point of view hat present *)
JOY_HWS_POVISBUTTONCOMBOS = $00000004; (* pov done through combo of buttons *)
JOY_HWS_POVISPOLL = $00000008; (* pov done through polling *)
JOY_HWS_ISYOKE = $00000010; (* joystick is a flight yoke *)
JOY_HWS_ISGAMEPAD = $00000020; (* joystick is a game pad *)
JOY_HWS_ISCARCTRL = $00000040; (* joystick is a car controller *)
(* X defaults to J1 X axis *)
JOY_HWS_XISJ1Y = $00000080; (* X is on J1 Y axis *)
JOY_HWS_XISJ2X = $00000100; (* X is on J2 X axis *)
JOY_HWS_XISJ2Y = $00000200; (* X is on J2 Y axis *)
(* Y defaults to J1 Y axis *)
JOY_HWS_YISJ1X = $00000400; (* Y is on J1 X axis *)
JOY_HWS_YISJ2X = $00000800; (* Y is on J2 X axis *)
JOY_HWS_YISJ2Y = $00001000; (* Y is on J2 Y axis *)
(* Z defaults to J2 Y axis *)
JOY_HWS_ZISJ1X = $00002000; (* Z is on J1 X axis *)
JOY_HWS_ZISJ1Y = $00004000; (* Z is on J1 Y axis *)
JOY_HWS_ZISJ2X = $00008000; (* Z is on J2 X axis *)
(* POV defaults to J2 Y axis, if it is not button based *)
JOY_HWS_POVISJ1X = $00010000; (* pov done through J1 X axis *)
JOY_HWS_POVISJ1Y = $00020000; (* pov done through J1 Y axis *)
JOY_HWS_POVISJ2X = $00040000; (* pov done through J2 X axis *)
(* R defaults to J2 X axis *)
JOY_HWS_HASR = $00080000; (* has R (4th axis) info *)
JOY_HWS_RISJ1X = $00100000; (* R done through J1 X axis *)
JOY_HWS_RISJ1Y = $00200000; (* R done through J1 Y axis *)
JOY_HWS_RISJ2Y = $00400000; (* R done through J2 X axis *)
(* U & V for future hardware *)
JOY_HWS_HASU = $00800000; (* has U (5th axis) info *)
JOY_HWS_HASV = $01000000; (* has V (6th axis) info *)

(* Usage settings *)
JOY_US_HASRUDDER = $00000001; (* joystick configured with rudder *)
JOY_US_PRESENT = $00000002; (* is joystick actually present? *)
JOY_US_ISOEM = $00000004; (* joystick is an OEM defined type *)

(* reserved for future use -> as link to next possible dword *)
JOY_US_RESERVED = $80000000; (* reserved *)


(* Settings for TypeInfo Flags1 *)
JOYTYPE_ZEROGAMEENUMOEMDATA = $00000001; (* Zero GameEnum's OEM data field *)
JOYTYPE_NOAUTODETECTGAMEPORT = $00000002; (* Device does not support Autodetect gameport*)
JOYTYPE_NOHIDDIRECT = $00000004; (* Do not use HID directly for this device *)
JOYTYPE_ANALOGCOMPAT = $00000008; (* Expose the analog compatible ID *)
JOYTYPE_DEFAULTPROPSHEET = $80000000; (* CPL overrides custom property sheet *)

(* Settings for TypeInfo Flags2 *)
JOYTYPE_DEVICEHIDE = $00010000; (* Hide unclassified devices *)
JOYTYPE_MOUSEHIDE = $00020000; (* Hide mice *)
JOYTYPE_KEYBHIDE = $00040000; (* Hide keyboards *)
JOYTYPE_GAMEHIDE = $00080000; (* Hide game controllers *)
JOYTYPE_HIDEACTIVE = $00100000; (* Hide flags are active *)
JOYTYPE_INFOMASK = $00E00000; (* Mask for type specific info *)
JOYTYPE_INFODEFAULT = $00000000; (* Use default axis mappings *)
JOYTYPE_INFOYYPEDALS = $00200000; (* Use Y as a combined pedals axis *)
JOYTYPE_INFOZYPEDALS = $00400000; (* Use Z for accelerate, Y for brake *)
JOYTYPE_INFOYRPEDALS = $00600000; (* Use Y for accelerate, R for brake *)
JOYTYPE_INFOZRPEDALS = $00800000; (* Use Z for accelerate, R for brake *)
JOYTYPE_INFOZISSLIDER = $00200000; (* Use Z as a slider *)
JOYTYPE_INFOZISZ = $00400000; (* Use Z as Z axis *)
JOYTYPE_ENABLEINPUTREPORT = $01000000; (* Enable initial input reports *)


MAX_JOYSTRING = 256;

     DEV_STS_EFFECT_RUNNING  =  DIEGES_PLAYING;


MAX_JOYSTICKOEMVXDNAME = 260;


DITC_REGHWSETTINGS = $00000001;
DITC_CLSIDCONFIG = $00000002;
DITC_DISPLAYNAME = $00000004;
DITC_CALLOUT = $00000008;
DITC_HARDWAREID = $00000010;
DITC_FLAGS1 = $00000020;
DITC_FLAGS2 = $00000040;
DITC_MAPFILE = $00000080;




DIJC_GUIDINSTANCE = $00000001;
DIJC_REGHWCONFIGTYPE = $00000002;
DIJC_GAIN = $00000004;
DIJC_CALLOUT = $00000008;
DIJC_WDMGAMEPORT = $00000010;


DIJU_USERVALUES = $00000001;
DIJU_GLOBALDRIVER = $00000002;
DIJU_GAMEPORTEMULATOR = $00000004;


GUID_KeyboardClass : TGUID = '{4D36E96B-E325-11CE-BFC1-08002BE10318}';
GUID_MediaClass : TGUID = '{4D36E96C-E325-11CE-BFC1-08002BE10318}';
GUID_MouseClass : TGUID = '{4D36E96F-E325-11CE-BFC1-08002BE10318}';
GUID_HIDClass : TGUID = '{745A17A0-74D3-11D0-B6FE-00A0C90F57DA}';


(****************************************************************************
 *
 *  Notification Messages
 *
 ****************************************************************************)
(* RegisterWindowMessage with this to get DirectInput notification messages *)

DIRECTINPUT_NOTIFICATION_MSGSTRINGA = 'DIRECTINPUT_NOTIFICATION_MSGSTRING';
DIRECTINPUT_NOTIFICATION_MSGSTRINGW = 'DIRECTINPUT_NOTIFICATION_MSGSTRING';


DIMSGWP_NEWAPPSTART = $00000001;
DIMSGWP_DX8APPSTART = $00000002;
DIMSGWP_DX8MAPPERAPPSTART = $00000003;



DIAPPIDFLAG_NOTIME = $00000001;
DIAPPIDFLAG_NOSIZE = $00000002;

DIRECTINPUT_REGSTR_VAL_APPIDFLAGA = 'AppIdFlag';
DIRECTINPUT_REGSTR_KEY_LASTAPPA = 'MostRecentApplication';
DIRECTINPUT_REGSTR_KEY_LASTMAPAPPA = 'MostRecentMapperApplication';
DIRECTINPUT_REGSTR_VAL_VERSIONA = 'Version';
DIRECTINPUT_REGSTR_VAL_NAMEA = 'Name';
DIRECTINPUT_REGSTR_VAL_IDA = 'Id';
DIRECTINPUT_REGSTR_VAL_MAPPERA = 'UsesMapper';
DIRECTINPUT_REGSTR_VAL_LASTSTARTA = 'MostRecentStart';

DIRECTINPUT_REGSTR_VAL_APPIDFLAGW = 'AppIdFlag';
DIRECTINPUT_REGSTR_KEY_LASTAPPW = 'MostRecentApplication';
DIRECTINPUT_REGSTR_KEY_LASTMAPAPPW = 'MostRecentMapperApplication';
DIRECTINPUT_REGSTR_VAL_VERSIONW = 'Version';
DIRECTINPUT_REGSTR_VAL_NAMEW = 'Name';
DIRECTINPUT_REGSTR_VAL_IDW = 'Id';
DIRECTINPUT_REGSTR_VAL_MAPPERW = 'UsesMapper';
DIRECTINPUT_REGSTR_VAL_LASTSTARTW = 'MostRecentStart';



(****************************************************************************
 *
 *  Return Codes
 *
 ****************************************************************************)
(*
 *  Device driver-specific codes.
 *)

  DIERR_NOMOREITEMS = ((SEVERITY_ERROR SHL 31) or (FACILITY_WIN32 SHL 16) or (ERROR_NO_MORE_ITEMS));

DIERR_DRIVERFIRST = $80040300;
DIERR_DRIVERLAST = $800403FF;

(*
 *  Unless the specific driver has been precisely identified, no meaning
 *  should be attributed to these values other than that the driver
 *  originated the error.  However, to illustrate the types of error that
 *  may be causing the failure, the PID force feedback driver distributed
 *  with DirectX 7 could return the following errors:
 *
 *  DIERR_DRIVERFIRST + 1
 *      The requested usage was not found.
 *  DIERR_DRIVERFIRST + 2
 *      The parameter block couldn't be	downloaded to the device.
 *  DIERR_DRIVERFIRST + 3
 *      PID initialization failed.
 *  DIERR_DRIVERFIRST + 4
 *      The provided values couldn't be scaled.
 *)
(*
 *  Device installer errors.
 *)
(*
 *  Registry entry or DLL for class installer invalid
 *  or class installer not found.
 *)



DIERR_INVALIDCLASSINSTALLER = $80040400;

(*
 *  The user cancelled the install operation.
 *)
DIERR_CANCELLED = $80040401;

(*
 *  The INF file for the selected device could not be
 *  found or is invalid or is damaged.
 *)
DIERR_BADINF = $80040402;

(****************************************************************************
 *
 *  Map files
 *
 ****************************************************************************)
(*
 *  Delete particular data from default map file.
 *)

DIDIFT_DELETE = $01000000;





type


(****************************************************************************
 *
 *      IDirectInputEffectDriver
 *
 ****************************************************************************)

    TDIOBJECTATTRIBUTES = record
        dwFlags: DWORD;
        wUsagePage: word;
        wUsage: word;
    end;
    PDIOBJECTATTRIBUTES = ^TDIOBJECTATTRIBUTES;

    LPDIOBJECTATTRIBUTES = ^TDIOBJECTATTRIBUTES;
    PLPCDIOBJECTATTRIBUTES = ^TDIOBJECTATTRIBUTES;

    TDIFFOBJECTATTRIBUTES = record
        dwFFMaxForce: DWORD;
        dwFFForceResolution: DWORD;
    end;
    PDIFFOBJECTATTRIBUTES = ^TDIFFOBJECTATTRIBUTES;

    LPDIFFOBJECTATTRIBUTES = ^TDIFFOBJECTATTRIBUTES;
    PLPCDIFFOBJECTATTRIBUTES = ^TDIFFOBJECTATTRIBUTES;

    TDIOBJECTCALIBRATION = record
        lMin: LONG;
        lCenter: LONG;
        lMax: LONG;
    end;
    PDIOBJECTCALIBRATION = ^TDIOBJECTCALIBRATION;

    LPDIOBJECTCALIBRATION = ^TDIOBJECTCALIBRATION;
    PLPCDIOBJECTCALIBRATION = ^TDIOBJECTCALIBRATION;

    TDIPOVCALIBRATION = record
        lMin: array [0..5 - 1] of LONG;
        lMax: array [0..5 - 1] of LONG;
    end;
    PDIPOVCALIBRATION = ^TDIPOVCALIBRATION;

    LPDIPOVCALIBRATION = ^TDIPOVCALIBRATION;
    PLPCDIPOVCALIBRATION = ^TDIPOVCALIBRATION;

    TDIEFFECTATTRIBUTES = record
        dwEffectId: DWORD;
        dwEffType: DWORD;
        dwStaticParams: DWORD;
        dwDynamicParams: DWORD;
        dwCoords: DWORD;
    end;
    PDIEFFECTATTRIBUTES = ^TDIEFFECTATTRIBUTES;

    LPDIEFFECTATTRIBUTES = ^TDIEFFECTATTRIBUTES;
    PLPCDIEFFECTATTRIBUTES = ^TDIEFFECTATTRIBUTES;

    TDIFFDEVICEATTRIBUTES = record
        dwFlags: DWORD;
        dwFFSamplePeriod: DWORD;
        dwFFMinTimeResolution: DWORD;
    end;
    PDIFFDEVICEATTRIBUTES = ^TDIFFDEVICEATTRIBUTES;

    LPDIFFDEVICEATTRIBUTES = ^TDIFFDEVICEATTRIBUTES;
    PLPCDIFFDEVICEATTRIBUTES = ^TDIFFDEVICEATTRIBUTES;

    TDIDRIVERVERSIONS = record
        dwSize: DWORD;
        dwFirmwareRevision: DWORD;
        dwHardwareRevision: DWORD;
        dwFFDriverVersion: DWORD;
    end;
    PDIDRIVERVERSIONS = ^TDIDRIVERVERSIONS;

    LPDIDRIVERVERSIONS = ^TDIDRIVERVERSIONS;
    PLPCDIDRIVERVERSIONS = ^TDIDRIVERVERSIONS;

    TDIDEVICESTATE = record
        dwSize: DWORD;
        dwState: DWORD;
        dwLoad: DWORD;
    end;
    PDIDEVICESTATE = ^TDIDEVICESTATE;

    LPDIDEVICESTATE = ^TDIDEVICESTATE;


    TDIHIDFFINITINFO = record
        dwSize: DWORD;
        pwszDeviceInterface: LPWSTR;
        GuidInstance: TGUID;
    end;
    PDIHIDFFINITINFO = ^TDIHIDFFINITINFO;

    LPDIHIDFFINITINFO = ^TDIHIDFFINITINFO;


 LPDIJOYTYPECALLBACK = function(nameless1: LPCWSTR;nameless2:  LPVOID):longbool; stdcall;


IDirectInputEffectDriver = interface(IUnknown)
['{02538130-898F-11D0-9AD0-00A0C9A06E35}']
    (*** IDirectInputEffectDriver methods ***)
    function DeviceID(
    Nameless1 : DWORD ;
    Nameless2 : DWORD ;
    Nameless3 : DWORD ;
    Nameless4 : DWORD ;
    Nameless5 : LPVOID
        ) : HRESULT;stdcall;

    function GetVersions(
    Nameless1 : LPDIDRIVERVERSIONS
        ) : HRESULT;stdcall;

    function Escape(
    Nameless1 : DWORD ;
    Nameless2 : DWORD ;
    Nameless3 : LPDIEFFESCAPE
        ) : HRESULT;stdcall;

    function SetGain(
    Nameless1 : DWORD ;
    Nameless2 : DWORD
        ) : HRESULT;stdcall;

    function SendForceFeedbackCommand(
    Nameless1 : DWORD ;
    Nameless2 : DWORD
        ) : HRESULT;stdcall;

    function GetForceFeedbackState(
    Nameless1 : DWORD ;
    Nameless2 : LPDIDEVICESTATE
        ) : HRESULT;stdcall;

    function DownloadEffect(
    Nameless1 : DWORD ;
    Nameless2 : DWORD ;
    Nameless3 : LPDWORD ;
    Nameless4 : LPCDIEFFECT ;
    Nameless5 : DWORD
        ) : HRESULT;stdcall;

    function DestroyEffect(
    Nameless1 : DWORD ;
    Nameless2 : DWORD
        ) : HRESULT;stdcall;

    function StartEffect(
    Nameless1 : DWORD ;
    Nameless2 : DWORD ;
    Nameless3 : DWORD ;
    Nameless4 : DWORD
        ) : HRESULT;stdcall;

    function StopEffect(
    Nameless1 : DWORD ;
    Nameless2 : DWORD
        ) : HRESULT;stdcall;

    function GetEffectStatus(
    Nameless1 : DWORD ;
    Nameless2 : DWORD ;
    Nameless3 : LPDWORD
        ) : HRESULT;stdcall;

end;
 LPDIRECTINPUTEFFECTDRIVER = ^IDirectInputEffectDriver;




(* struct for storing x,y, z, and rudder values *)
Tjoypos_tag = record
   dwX : DWORD;
   dwY : DWORD;
   dwZ : DWORD;
   dwR : DWORD;
   dwU : DWORD;
   dwV : DWORD;
end;
Pjoypos_tag = ^Tjoypos_tag;

TJOYPOS = Tjoypos_tag;
LPJOYPOS = ^Tjoypos_tag;

(* struct for storing ranges *)
Tjoyrange_tag = record
   jpMin : TJOYPOS;
   jpMax : TJOYPOS;
   jpCenter : TJOYPOS;
end;
Pjoyrange_tag = ^Tjoyrange_tag;

TJOYRANGE = Tjoyrange_tag;
LPJOYRANGE = ^Tjoyrange_tag;

(*
 *  dwTimeout - value at which to timeout joystick polling
 *  jrvRanges - range of values app wants returned for axes
 *  jpDeadZone - area around center to be considered
 *               as "dead". specified as a percentage
 *               (0-100). Only X & Y handled by system driver
 *)
Tjoyreguservalues_tag = record
   dwTimeOut : DWORD;
   jrvRanges : TJOYRANGE;
   jpDeadZone : TJOYPOS;
end;
Pjoyreguservalues_tag = ^Tjoyreguservalues_tag;

TJOYREGUSERVALUES = Tjoyreguservalues_tag;
LPJOYREGUSERVALUES = ^Tjoyreguservalues_tag;

Tjoyreghwsettings_tag = record
   dwFlags : DWORD;
   dwNumButtons : DWORD;
end;
Pjoyreghwsettings_tag = ^Tjoyreghwsettings_tag;

TJOYREGHWSETTINGS = Tjoyreghwsettings_tag;
LPJOYHWSETTINGS = ^Tjoyreghwsettings_tag;

(* range of values returned by the hardware (filled in by calibration) *)
(*
 *  jrvHardware - values returned by hardware
 *  dwPOVValues - POV values returned by hardware
 *  dwCalFlags  - what has been calibrated
 *)
Tjoyreghwvalues_tag = record
   jrvHardware : TJOYRANGE;
   dwPOVValues : array [0..JOY_POV_NUMDIRS-1] of DWORD;
   dwCalFlags : DWORD;
end;
Pjoyreghwvalues_tag = ^Tjoyreghwvalues_tag;

TJOYREGHWVALUES = Tjoyreghwvalues_tag;
LPJOYREGHWVALUES = ^Tjoyreghwvalues_tag;

(* hardware configuration *)
(*
 *  hws             - hardware settings
 *  dwUsageSettings - usage settings
 *  hwv             - values returned by hardware
 *  dwType          - type of joystick
 *  dwReserved      - reserved for OEM drivers
 *)
Tjoyreghwconfig_tag = record
   hws : TJOYREGHWSETTINGS;
   dwUsageSettings : DWORD;
   hwv : TJOYREGHWVALUES;
   dwType : DWORD;
   dwReserved : DWORD;
end;
Pjoyreghwconfig_tag = ^Tjoyreghwconfig_tag;

TJOYREGHWCONFIG = Tjoyreghwconfig_tag;
LPJOYREGHWCONFIG = ^Tjoyreghwconfig_tag;

(* joystick calibration info structure *)
Tjoycalibrate_tag = record
   wXbase : UINT;
   wXdelta : UINT;
   wYbase : UINT;
   wYdelta : UINT;
   wZbase : UINT;
   wZdelta : UINT;
end;
Pjoycalibrate_tag = ^Tjoycalibrate_tag;

TJOYCALIBRATE = Tjoycalibrate_tag;
LPJOYCALIBRATE = ^TJOYCALIBRATE;


(* This structure is defined for DirectX 5.0 compatibility *)

TDIJOYTYPEINFO_DX5 = record
   dwSize : DWORD;
   hws : TJOYREGHWSETTINGS;
   clsidConfig : TCLSID;
   wszDisplayName : array [0..MAX_JOYSTRING-1] of WCHAR;
   wszCallout : array [0..MAX_JOYSTICKOEMVXDNAME-1] of WCHAR;
end;
PDIJOYTYPEINFO_DX5 = ^TDIJOYTYPEINFO_DX5;

LPDIJOYTYPEINFO_DX5 = ^TDIJOYTYPEINFO_DX5;
LPCDIJOYTYPEINFO_DX5 = ^TDIJOYTYPEINFO_DX5;

(* This structure is defined for DirectX 6.1 compatibility *)
TDIJOYTYPEINFO_DX6 = record
   dwSize : DWORD;
   hws : TJOYREGHWSETTINGS;
   clsidConfig : TCLSID;
   wszDisplayName : array [0..MAX_JOYSTRING-1] of WCHAR;
   wszCallout : array [0..MAX_JOYSTICKOEMVXDNAME-1] of WCHAR;
   wszHardwareId : array [0..MAX_JOYSTRING-1] of WCHAR;
   dwFlags1 : DWORD;
end;
PDIJOYTYPEINFO_DX6 = ^TDIJOYTYPEINFO_DX6;

LPDIJOYTYPEINFO_DX6 = ^TDIJOYTYPEINFO_DX6;
LPCDIJOYTYPEINFO_DX6 = ^TDIJOYTYPEINFO_DX6;

TDIJOYTYPEINFO = record
   dwSize : DWORD;
   hws : TJOYREGHWSETTINGS;
   clsidConfig : TCLSID;
   wszDisplayName : array [0..MAX_JOYSTRING-1] of WCHAR;
   wszCallout : array [0..MAX_JOYSTICKOEMVXDNAME-1] of WCHAR;
   wszHardwareId : array [0..MAX_JOYSTRING-1] of WCHAR;
   dwFlags1 : DWORD;
   dwFlags2 : DWORD;
   wszMapFile : array [0..MAX_JOYSTRING-1] of WCHAR;
end;
PDIJOYTYPEINFO = ^TDIJOYTYPEINFO;

LPDIJOYTYPEINFO = ^TDIJOYTYPEINFO;
LPCDIJOYTYPEINFO = ^TDIJOYTYPEINFO;



(* This structure is defined for DirectX 5.0 compatibility *)

TDIJOYCONFIG_DX5 = record
   dwSize : DWORD;
   guidInstance : TGUID;
   hwc : TJOYREGHWCONFIG;
   dwGain : DWORD;
   wszType : array [0..MAX_JOYSTRING-1] of WCHAR;
   wszCallout : array [0..MAX_JOYSTRING-1] of WCHAR;
end;
PDIJOYCONFIG_DX5 = ^TDIJOYCONFIG_DX5;

LPDIJOYCONFIG_DX5 = ^TDIJOYCONFIG_DX5;
LPCDIJOYCONFIG_DX5 = ^TDIJOYCONFIG_DX5;

TDIJOYCONFIG = record
   dwSize : DWORD;
   guidInstance : TGUID;
   hwc : TJOYREGHWCONFIG;
   dwGain : DWORD;
   wszType : array [0..MAX_JOYSTRING-1] of WCHAR;
   wszCallout : array [0..MAX_JOYSTRING-1] of WCHAR;
   guidGameport : TGUID;
end;
PDIJOYCONFIG = ^TDIJOYCONFIG;

LPDIJOYCONFIG = ^TDIJOYCONFIG;
LPCDIJOYCONFIG = ^TDIJOYCONFIG;


TDIJOYUSERVALUES = record
   dwSize : DWORD;
   ruv : TJOYREGUSERVALUES;
   wszGlobalDriver : array [0..MAX_JOYSTRING-1] of WCHAR;
   wszGameportEmulator : array [0..MAX_JOYSTRING-1] of WCHAR;
end;
PDIJOYUSERVALUES = ^TDIJOYUSERVALUES;

LPDIJOYUSERVALUES = ^TDIJOYUSERVALUES;
LPCDIJOYUSERVALUES = ^TDIJOYUSERVALUES;


IDirectInputJoyConfig = interface(IUnknown)
['{1DE12AB1-C9F5-11CF-BFC7-444553540000}']
    (*** IDirectInputJoyConfig methods ***)
    function Acquire(

        ) : HRESULT;stdcall;

    function Unacquire(

        ) : HRESULT;stdcall;

    function SetCooperativeLevel(
    Nameless1 : HWND ;
    Nameless2 : DWORD
        ) : HRESULT;stdcall;

    function SendNotify(

        ) : HRESULT;stdcall;

    function EnumTypes(
    Nameless1 : LPDIJOYTYPECALLBACK ;
    Nameless2 : LPVOID
        ) : HRESULT;stdcall;

    function GetTypeInfo(
    Nameless1 : LPCWSTR ;
    Nameless2 : LPDIJOYTYPEINFO ;
    Nameless3 : DWORD
        ) : HRESULT;stdcall;

    function SetTypeInfo(
    Nameless1 : LPCWSTR ;
    Nameless2 : LPCDIJOYTYPEINFO ;
    Nameless3 : DWORD
        ) : HRESULT;stdcall;

    function DeleteType(
    Nameless1 : LPCWSTR
        ) : HRESULT;stdcall;

    function GetConfig(
    Nameless1 : UINT ;
    Nameless2 : LPDIJOYCONFIG ;
    Nameless3 : DWORD
        ) : HRESULT;stdcall;

    function SetConfig(
    Nameless1 : UINT ;
    Nameless2 : LPCDIJOYCONFIG ;
    Nameless3 : DWORD
        ) : HRESULT;stdcall;

    function DeleteConfig(
    Nameless1 : UINT
        ) : HRESULT;stdcall;

    function GetUserValues(
    Nameless1 : LPDIJOYUSERVALUES ;
    Nameless2 : DWORD
        ) : HRESULT;stdcall;

    function SetUserValues(
    Nameless1 : LPCDIJOYUSERVALUES ;
    Nameless2 : DWORD
        ) : HRESULT;stdcall;

    function AddNewHardware(
    Nameless1 : HWND ;
    Nameless2 : REFGUID
        ) : HRESULT;stdcall;

    function OpenTypeKey(
    Nameless1 : LPCWSTR ;
    Nameless2 : DWORD ;
    Nameless3 : PHKEY
        ) : HRESULT;stdcall;

    function OpenConfigKey(
    Nameless1 : UINT ;
    Nameless2 : DWORD ;
    Nameless3 : PHKEY
        ) : HRESULT;stdcall;

end;

  LPDIRECTINPUTJOYCONFIG = ^IDirectInputJoyConfig;


IDirectInputJoyConfig8 = interface(IUnknown)
['{EB0D7DFA-1990-4F27-B4D6-EDF2EEC4A44C}']
    (*** IDirectInputJoyConfig8 methods ***)
    function Acquire(

        ) : HRESULT;stdcall;

    function Unacquire(

        ) : HRESULT;stdcall;

    function SetCooperativeLevel(
    Nameless1 : HWND ;
    Nameless2 : DWORD
        ) : HRESULT;stdcall;

    function SendNotify(

        ) : HRESULT;stdcall;

    function EnumTypes(
    Nameless1 : LPDIJOYTYPECALLBACK ;
    Nameless2 : LPVOID
        ) : HRESULT;stdcall;

    function GetTypeInfo(
    Nameless1 : LPCWSTR ;
    Nameless2 : LPDIJOYTYPEINFO ;
    Nameless3 : DWORD
        ) : HRESULT;stdcall;

    function SetTypeInfo(
    Nameless1 : LPCWSTR ;
    Nameless2 : LPCDIJOYTYPEINFO ;
    Nameless3 : DWORD ;
    Nameless4 : LPWSTR
        ) : HRESULT;stdcall;

    function DeleteType(
    Nameless1 : LPCWSTR
        ) : HRESULT;stdcall;

    function GetConfig(
    Nameless1 : UINT ;
    Nameless2 : LPDIJOYCONFIG ;
    Nameless3 : DWORD
        ) : HRESULT;stdcall;

    function SetConfig(
    Nameless1 : UINT ;
    Nameless2 : LPCDIJOYCONFIG ;
    Nameless3 : DWORD
        ) : HRESULT;stdcall;

    function DeleteConfig(
    Nameless1 : UINT
        ) : HRESULT;stdcall;

    function GetUserValues(
    Nameless1 : LPDIJOYUSERVALUES ;
    Nameless2 : DWORD
        ) : HRESULT;stdcall;

    function SetUserValues(
    Nameless1 : LPCDIJOYUSERVALUES ;
    Nameless2 : DWORD
        ) : HRESULT;stdcall;

    function AddNewHardware(
    Nameless1 : HWND ;
    Nameless2 : REFGUID
        ) : HRESULT;stdcall;

    function OpenTypeKey(
    Nameless1 : LPCWSTR ;
    Nameless2 : DWORD ;
    Nameless3 : PHKEY
        ) : HRESULT;stdcall;

    function OpenAppStatusKey(
    Nameless1 : PHKEY
        ) : HRESULT;stdcall;

end;

 LPDIRECTINPUTJOYCONFIG8 = ^IDirectInputJoyConfig8;



implementation

end.
