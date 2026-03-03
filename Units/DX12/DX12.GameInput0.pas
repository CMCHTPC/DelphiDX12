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

   Copyright (C) Microsoft Corporation.
   Licensed under the MIT license

   This unit consists of the following header files
   File name: GameInput.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.GameInput0;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils;

    {$Z4}
    {$A4}

const
    GameInput_DLL = 'GameInput.DLL';

    GAMEINPUT_API_VERSION = 0;

    APP_LOCAL_DEVICE_ID_SIZE = 32;

    GAMEINPUT_CURRENT_CALLBACK_TOKEN_VALUE = $FFFFFFFFFFFFFFFF;
    GAMEINPUT_INVALID_CALLBACK_TOKEN_VALUE = $0000000000000000;
    FACILITY_GAMEINPUT = 906;


    // MessageId: GAMEINPUT_E_DEVICE_DISCONNECTED
    // MessageText:
    // The device is not currently connected to the system.

    GAMEINPUT_E_DEVICE_DISCONNECTED = HRESULT($838A0001);


    // MessageId: GAMEINPUT_E_DEVICE_NOT_FOUND
    // MessageText:
    // The requested device could not be found.

    GAMEINPUT_E_DEVICE_NOT_FOUND = HRESULT($838A0002);


    // MessageId: GAMEINPUT_E_READING_NOT_FOUND
    // MessageText:
    // The requested reading could not be found.

    GAMEINPUT_E_READING_NOT_FOUND = HRESULT($838A0003);


    // MessageId: GAMEINPUT_E_REFERENCE_READING_TOO_OLD
    // MessageText:
    // The reference reading no longer exists in the reading history.

    GAMEINPUT_E_REFERENCE_READING_TOO_OLD = HRESULT($838A0004);


    // MessageId: GAMEINPUT_E_TIMESTAMP_OUT_OF_RANGE
    // MessageText:
    // The target timestamp for the temporal reading is too far in the past or future.

    GAMEINPUT_E_TIMESTAMP_OUT_OF_RANGE = HRESULT($838A0005);


    // MessageId: GAMEINPUT_E_INSUFFICIENT_FORCE_FEEDBACK_RESOURCES
    // MessageText:
    // The device does not have enough resources remaining to create the requested force feedback effect.

    GAMEINPUT_E_INSUFFICIENT_FORCE_FEEDBACK_RESOURCES = HRESULT($838A0006);


    IID_IGameInput: TGUID = '{11BE2A7E-4254-445A-9C09-FFC40F006918}';
    IID_IGameInputReading: TGUID = '{2156947A-E1FA-4DE0-A30B-D812931DBD8D}';
    IID_IGameInputDevice: TGUID = '{31DD86FB-4C1B-408A-868F-439B3CD47125}';
    IID_IGameInputDispatcher: TGUID = '{415EED2E-98CB-42C2-8F28-B94601074E31}';
    IID_IGameInputForceFeedbackEffect: TGUID = '{51BDA05E-F742-45D9-B085-9444AE48381D}';
    IID_IGameInputRawDeviceReport: TGUID = '{61F08CF1-1FFC-40CA-A2B8-E1AB8BC5B6DC}';


type

    TGameInputKind = (
        GameInputKindUnknown = $00000000,
        GameInputKindRawDeviceReport = $00000001,
        GameInputKindControllerAxis = $00000002,
        GameInputKindControllerButton = $00000004,
        GameInputKindControllerSwitch = $00000008,
        GameInputKindController = $0000000E,
        GameInputKindKeyboard = $00000010,
        GameInputKindMouse = $00000020,
        GameInputKindTouch = $00000100,
        GameInputKindMotion = $00001000,
        GameInputKindArcadeStick = $00010000,
        GameInputKindFlightStick = $00020000,
        GameInputKindGamepad = $00040000,
        GameInputKindRacingWheel = $00080000,
        GameInputKindUiNavigation = $01000000);

    PGameInputKind = ^TGameInputKind;


    TGameInputEnumerationKind = (
        GameInputNoEnumeration = 0,
        GameInputAsyncEnumeration = 1,
        GameInputBlockingEnumeration = 2);

    PGameInputEnumerationKind = ^TGameInputEnumerationKind;


    TGameInputFocusPolicy = (
        GameInputDefaultFocusPolicy = $00000000,
        GameInputDisableBackgroundInput = $00000001,
        GameInputExclusiveForegroundInput = $00000002,
        GameInputDisableBackgroundGuideButton = $00000004,
        GameInputExclusiveForegroundGuideButton = $00000008,
        GameInputDisableBackgroundShareButton = $00000010,
        GameInputExclusiveForegroundShareButton = $00000020);

    PGameInputFocusPolicy = ^TGameInputFocusPolicy;


    TGameInputSwitchKind = (
        GameInputUnknownSwitchKind = -1,
        GameInput2WaySwitch = 0,
        GameInput4WaySwitch = 1,
        GameInput8WaySwitch = 2);

    PGameInputSwitchKind = ^TGameInputSwitchKind;


    TGameInputSwitchPosition = (
        GameInputSwitchCenter = 0,
        GameInputSwitchUp = 1,
        GameInputSwitchUpRight = 2,
        GameInputSwitchRight = 3,
        GameInputSwitchDownRight = 4,
        GameInputSwitchDown = 5,
        GameInputSwitchDownLeft = 6,
        GameInputSwitchLeft = 7,
        GameInputSwitchUpLeft = 8);

    PGameInputSwitchPosition = ^TGameInputSwitchPosition;


    TGameInputKeyboardKind = (
        GameInputUnknownKeyboard = -1,
        GameInputAnsiKeyboard = 0,
        GameInputIsoKeyboard = 1,
        GameInputKsKeyboard = 2,
        GameInputAbntKeyboard = 3,
        GameInputJisKeyboard = 4);

    PGameInputKeyboardKind = ^TGameInputKeyboardKind;


    TGameInputMouseButtons = (
        GameInputMouseNone = $00000000,
        GameInputMouseLeftButton = $00000001,
        GameInputMouseRightButton = $00000002,
        GameInputMouseMiddleButton = $00000004,
        GameInputMouseButton4 = $00000008,
        GameInputMouseButton5 = $00000010,
        GameInputMouseWheelTiltLeft = $00000020,
        GameInputMouseWheelTiltRight = $00000040);

    PGameInputMouseButtons = ^TGameInputMouseButtons;


    TGameInputTouchShape = (
        GameInputTouchShapeUnknown = -1,
        GameInputTouchShapePoint = 0,
        GameInputTouchShape1DLinear = 1,
        GameInputTouchShape1DRadial = 2,
        GameInputTouchShape1DIrregular = 3,
        GameInputTouchShape2DRectangular = 4,
        GameInputTouchShape2DElliptical = 5,
        GameInputTouchShape2DIrregular = 6);

    PGameInputTouchShape = ^TGameInputTouchShape;


    TGameInputMotionAccuracy = (
        GameInputMotionAccuracyUnknown = -1,
        GameInputMotionUnavailable = 0,
        GameInputMotionUnreliable = 1,
        GameInputMotionApproximate = 2,
        GameInputMotionAccurate = 3);

    PGameInputMotionAccuracy = ^TGameInputMotionAccuracy;


    TGameInputArcadeStickButtons = (
        GameInputArcadeStickNone = $00000000,
        GameInputArcadeStickMenu = $00000001,
        GameInputArcadeStickView = $00000002,
        GameInputArcadeStickUp = $00000004,
        GameInputArcadeStickDown = $00000008,
        GameInputArcadeStickLeft = $00000010,
        GameInputArcadeStickRight = $00000020,
        GameInputArcadeStickAction1 = $00000040,
        GameInputArcadeStickAction2 = $00000080,
        GameInputArcadeStickAction3 = $00000100,
        GameInputArcadeStickAction4 = $00000200,
        GameInputArcadeStickAction5 = $00000400,
        GameInputArcadeStickAction6 = $00000800,
        GameInputArcadeStickSpecial1 = $00001000,
        GameInputArcadeStickSpecial2 = $00002000);

    PGameInputArcadeStickButtons = ^TGameInputArcadeStickButtons;


    TGameInputFlightStickButtons = (
        GameInputFlightStickNone = $00000000,
        GameInputFlightStickMenu = $00000001,
        GameInputFlightStickView = $00000002,
        GameInputFlightStickFirePrimary = $00000004,
        GameInputFlightStickFireSecondary = $00000008);

    PGameInputFlightStickButtons = ^TGameInputFlightStickButtons;


    TGameInputGamepadButtons = (
        GameInputGamepadNone = $00000000,
        GameInputGamepadMenu = $00000001,
        GameInputGamepadView = $00000002,
        GameInputGamepadA = $00000004,
        GameInputGamepadB = $00000008,
        GameInputGamepadX = $00000010,
        GameInputGamepadY = $00000020,
        GameInputGamepadDPadUp = $00000040,
        GameInputGamepadDPadDown = $00000080,
        GameInputGamepadDPadLeft = $00000100,
        GameInputGamepadDPadRight = $00000200,
        GameInputGamepadLeftShoulder = $00000400,
        GameInputGamepadRightShoulder = $00000800,
        GameInputGamepadLeftThumbstick = $00001000,
        GameInputGamepadRightThumbstick = $00002000);

    PGameInputGamepadButtons = ^TGameInputGamepadButtons;


    TGameInputRacingWheelButtons = (
        GameInputRacingWheelNone = $00000000,
        GameInputRacingWheelMenu = $00000001,
        GameInputRacingWheelView = $00000002,
        GameInputRacingWheelPreviousGear = $00000004,
        GameInputRacingWheelNextGear = $00000008,
        GameInputRacingWheelDpadUp = $00000010,
        GameInputRacingWheelDpadDown = $00000020,
        GameInputRacingWheelDpadLeft = $00000040,
        GameInputRacingWheelDpadRight = $00000080);

    PGameInputRacingWheelButtons = ^TGameInputRacingWheelButtons;


    TGameInputUiNavigationButtons = (
        GameInputUiNavigationNone = $00000000,
        GameInputUiNavigationMenu = $00000001,
        GameInputUiNavigationView = $00000002,
        GameInputUiNavigationAccept = $00000004,
        GameInputUiNavigationCancel = $00000008,
        GameInputUiNavigationUp = $00000010,
        GameInputUiNavigationDown = $00000020,
        GameInputUiNavigationLeft = $00000040,
        GameInputUiNavigationRight = $00000080,
        GameInputUiNavigationContext1 = $00000100,
        GameInputUiNavigationContext2 = $00000200,
        GameInputUiNavigationContext3 = $00000400,
        GameInputUiNavigationContext4 = $00000800,
        GameInputUiNavigationPageUp = $00001000,
        GameInputUiNavigationPageDown = $00002000,
        GameInputUiNavigationPageLeft = $00004000,
        GameInputUiNavigationPageRight = $00008000,
        GameInputUiNavigationScrollUp = $00010000,
        GameInputUiNavigationScrollDown = $00020000,
        GameInputUiNavigationScrollLeft = $00040000,
        GameInputUiNavigationScrollRight = $00080000
        );

    PGameInputUiNavigationButtons = ^TGameInputUiNavigationButtons;


    TGameInputSystemButtons = (
        GameInputSystemButtonNone = $00000000,
        GameInputSystemButtonGuide = $00000001,
        GameInputSystemButtonShare = $00000002);

    PGameInputSystemButtons = ^TGameInputSystemButtons;


    TGameInputDeviceStatus = (
        GameInputDeviceNoStatus = $00000000,
        GameInputDeviceConnected = $00000001,
        GameInputDeviceInputEnabled = $00000002,
        GameInputDeviceOutputEnabled = $00000004,
        GameInputDeviceRawIoEnabled = $00000008,
        GameInputDeviceAudioCapture = $00000010,
        GameInputDeviceAudioRender = $00000020,
        GameInputDeviceSynchronized = $00000040,
        GameInputDeviceWireless = $00000080,
        GameInputDeviceUserIdle = $00100000,
        GameInputDeviceAnyStatus = $00FFFFFF);

    PGameInputDeviceStatus = ^TGameInputDeviceStatus;


    TGameInputBatteryStatus = (
        GameInputBatteryUnknown = -1,
        GameInputBatteryNotPresent = 0,
        GameInputBatteryDischarging = 1,
        GameInputBatteryIdle = 2,
        GameInputBatteryCharging = 3);

    PGameInputBatteryStatus = ^TGameInputBatteryStatus;


    TGameInputDeviceFamily = (
        GameInputFamilyVirtual = -1,
        GameInputFamilyAggregate = 0,
        GameInputFamilyXboxOne = 1,
        GameInputFamilyXbox360 = 2,
        GameInputFamilyHid = 3,
        GameInputFamilyI8042 = 4);

    PGameInputDeviceFamily = ^TGameInputDeviceFamily;


    TGameInputDeviceCapabilities = (
        GameInputDeviceCapabilityNone = $00000000,
        GameInputDeviceCapabilityAudio = $00000001,
        GameInputDeviceCapabilityPluginModule = $00000002,
        GameInputDeviceCapabilityPowerOff = $00000004,
        GameInputDeviceCapabilitySynchronization = $00000008,
        GameInputDeviceCapabilityWireless = $00000010);

    PGameInputDeviceCapabilities = ^TGameInputDeviceCapabilities;


    TGameInputRawDeviceReportKind = (
        GameInputRawInputReport = 0,
        GameInputRawOutputReport = 1,
        GameInputRawFeatureReport = 2);

    PGameInputRawDeviceReportKind = ^TGameInputRawDeviceReportKind;


    TGameInputRawDeviceReportItemFlags = (
        GameInputDefaultItem = $00000000,
        GameInputConstantItem = $00000001,
        GameInputArrayItem = $00000002,
        GameInputRelativeItem = $00000004,
        GameInputWraparoundItem = $00000008,
        GameInputNonlinearItem = $00000010,
        GameInputStableItem = $00000020,
        GameInputNullableItem = $00000040,
        GameInputVolatileItem = $00000080,
        GameInputBufferedItem = $00000100);

    PGameInputRawDeviceReportItemFlags = ^TGameInputRawDeviceReportItemFlags;


    TGameInputRawDeviceItemCollectionKind = (
        GameInputUnknownItemCollection = -1,
        GameInputPhysicalItemCollection = 0,
        GameInputApplicationItemCollection = 1,
        GameInputLogicalItemCollection = 2,
        GameInputReportItemCollection = 3,
        GameInputNamedArrayItemCollection = 4,
        GameInputUsageSwitchItemCollection = 5,
        GameInputUsageModifierItemCollection = 6);

    PGameInputRawDeviceItemCollectionKind = ^TGameInputRawDeviceItemCollectionKind;


    TGameInputRawDevicePhysicalUnitKind = (
        GameInputPhysicalUnitUnknown = -1,
        GameInputPhysicalUnitNone = 0,
        GameInputPhysicalUnitTime = 1,
        GameInputPhysicalUnitFrequency = 2,
        GameInputPhysicalUnitLength = 3,
        GameInputPhysicalUnitVelocity = 4,
        GameInputPhysicalUnitAcceleration = 5,
        GameInputPhysicalUnitMass = 6,
        GameInputPhysicalUnitMomentum = 7,
        GameInputPhysicalUnitForce = 8,
        GameInputPhysicalUnitPressure = 9,
        GameInputPhysicalUnitAngle = 10,
        GameInputPhysicalUnitAngularVelocity = 11,
        GameInputPhysicalUnitAngularAcceleration = 12,
        GameInputPhysicalUnitAngularMass = 13,
        GameInputPhysicalUnitAngularMomentum = 14,
        GameInputPhysicalUnitAngularTorque = 15,
        GameInputPhysicalUnitElectricCurrent = 16,
        GameInputPhysicalUnitElectricCharge = 17,
        GameInputPhysicalUnitElectricPotential = 18,
        GameInputPhysicalUnitEnergy = 19,
        GameInputPhysicalUnitPower = 20,
        GameInputPhysicalUnitTemperature = 21,
        GameInputPhysicalUnitLuminousIntensity = 22,
        GameInputPhysicalUnitLuminousFlux = 23,
        GameInputPhysicalUnitIlluminance = 24);

    PGameInputRawDevicePhysicalUnitKind = ^TGameInputRawDevicePhysicalUnitKind;


    TGameInputLabel = (
        GameInputLabelUnknown = -1,
        GameInputLabelNone = 0,
        GameInputLabelXboxGuide = 1,
        GameInputLabelXboxBack = 2,
        GameInputLabelXboxStart = 3,
        GameInputLabelXboxMenu = 4,
        GameInputLabelXboxView = 5,
        GameInputLabelXboxA = 7,
        GameInputLabelXboxB = 8,
        GameInputLabelXboxX = 9,
        GameInputLabelXboxY = 10,
        GameInputLabelXboxDPadUp = 11,
        GameInputLabelXboxDPadDown = 12,
        GameInputLabelXboxDPadLeft = 13,
        GameInputLabelXboxDPadRight = 14,
        GameInputLabelXboxLeftShoulder = 15,
        GameInputLabelXboxLeftTrigger = 16,
        GameInputLabelXboxLeftStickButton = 17,
        GameInputLabelXboxRightShoulder = 18,
        GameInputLabelXboxRightTrigger = 19,
        GameInputLabelXboxRightStickButton = 20,
        GameInputLabelXboxPaddle1 = 21,
        GameInputLabelXboxPaddle2 = 22,
        GameInputLabelXboxPaddle3 = 23,
        GameInputLabelXboxPaddle4 = 24,
        GameInputLabelLetterA = 25,
        GameInputLabelLetterB = 26,
        GameInputLabelLetterC = 27,
        GameInputLabelLetterD = 28,
        GameInputLabelLetterE = 29,
        GameInputLabelLetterF = 30,
        GameInputLabelLetterG = 31,
        GameInputLabelLetterH = 32,
        GameInputLabelLetterI = 33,
        GameInputLabelLetterJ = 34,
        GameInputLabelLetterK = 35,
        GameInputLabelLetterL = 36,
        GameInputLabelLetterM = 37,
        GameInputLabelLetterN = 38,
        GameInputLabelLetterO = 39,
        GameInputLabelLetterP = 40,
        GameInputLabelLetterQ = 41,
        GameInputLabelLetterR = 42,
        GameInputLabelLetterS = 43,
        GameInputLabelLetterT = 44,
        GameInputLabelLetterU = 45,
        GameInputLabelLetterV = 46,
        GameInputLabelLetterW = 47,
        GameInputLabelLetterX = 48,
        GameInputLabelLetterY = 49,
        GameInputLabelLetterZ = 50,
        GameInputLabelNumber0 = 51,
        GameInputLabelNumber1 = 52,
        GameInputLabelNumber2 = 53,
        GameInputLabelNumber3 = 54,
        GameInputLabelNumber4 = 55,
        GameInputLabelNumber5 = 56,
        GameInputLabelNumber6 = 57,
        GameInputLabelNumber7 = 58,
        GameInputLabelNumber8 = 59,
        GameInputLabelNumber9 = 60,
        GameInputLabelArrowUp = 61,
        GameInputLabelArrowUpRight = 62,
        GameInputLabelArrowRight = 63,
        GameInputLabelArrowDownRight = 64,
        GameInputLabelArrowDown = 65,
        GameInputLabelArrowDownLLeft = 66,
        GameInputLabelArrowLeft = 67,
        GameInputLabelArrowUpLeft = 68,
        GameInputLabelArrowUpDown = 69,
        GameInputLabelArrowLeftRight = 70,
        GameInputLabelArrowUpDownLeftRight = 71,
        GameInputLabelArrowClockwise = 72,
        GameInputLabelArrowCounterClockwise = 73,
        GameInputLabelArrowReturn = 74,
        GameInputLabelIconBranding = 75,
        GameInputLabelIconHome = 76,
        GameInputLabelIconMenu = 77,
        GameInputLabelIconCross = 78,
        GameInputLabelIconCircle = 79,
        GameInputLabelIconSquare = 80,
        GameInputLabelIconTriangle = 81,
        GameInputLabelIconStar = 82,
        GameInputLabelIconDPadUp = 83,
        GameInputLabelIconDPadDown = 84,
        GameInputLabelIconDPadLeft = 85,
        GameInputLabelIconDPadRight = 86,
        GameInputLabelIconDialClockwise = 87,
        GameInputLabelIconDialCounterClockwise = 88,
        GameInputLabelIconSliderLeftRight = 89,
        GameInputLabelIconSliderUpDown = 90,
        GameInputLabelIconWheelUpDown = 91,
        GameInputLabelIconPlus = 92,
        GameInputLabelIconMinus = 93,
        GameInputLabelIconSuspension = 94,
        GameInputLabelHome = 95,
        GameInputLabelGuide = 96,
        GameInputLabelMode = 97,
        GameInputLabelSelect = 98,
        GameInputLabelMenu = 99,
        GameInputLabelView = 100,
        GameInputLabelBack = 101,
        GameInputLabelStart = 102,
        GameInputLabelOptions = 103,
        GameInputLabelShare = 104,
        GameInputLabelUp = 105,
        GameInputLabelDown = 106,
        GameInputLabelLeft = 107,
        GameInputLabelRight = 108,
        GameInputLabelLB = 109,
        GameInputLabelLT = 110,
        GameInputLabelLSB = 111,
        GameInputLabelL1 = 112,
        GameInputLabelL2 = 113,
        GameInputLabelL3 = 114,
        GameInputLabelRB = 115,
        GameInputLabelRT = 116,
        GameInputLabelRSB = 117,
        GameInputLabelR1 = 118,
        GameInputLabelR2 = 119,
        GameInputLabelR3 = 120,
        GameInputLabelP1 = 121,
        GameInputLabelP2 = 122,
        GameInputLabelP3 = 123,
        GameInputLabelP4 = 124);

    PGameInputLabel = ^TGameInputLabel;


    TGameInputLocation = (
        GameInputLocationUnknown = -1,
        GameInputLocationChassis = 0,
        GameInputLocationDisplay = 1,
        GameInputLocationAxis = 2,
        GameInputLocationButton = 3,
        GameInputLocationSwitch = 4,
        GameInputLocationKey = 5,
        GameInputLocationTouchPad = 6);

    PGameInputLocation = ^TGameInputLocation;


    TGameInputFeedbackAxes = (
        GameInputFeedbackAxisNone = $00000000,
        GameInputFeedbackAxisLinearX = $00000001,
        GameInputFeedbackAxisLinearY = $00000002,
        GameInputFeedbackAxisLinearZ = $00000004,
        GameInputFeedbackAxisAngularX = $00000008,
        GameInputFeedbackAxisAngularY = $00000010,
        GameInputFeedbackAxisAngularZ = $00000020,
        GameInputFeedbackAxisNormal = $00000040);

    PGameInputFeedbackAxes = ^TGameInputFeedbackAxes;


    TGameInputFeedbackEffectState = (
        GameInputFeedbackStopped = 0,
        GameInputFeedbackRunning = 1,
        GameInputFeedbackPaused = 2);

    PGameInputFeedbackEffectState = ^TGameInputFeedbackEffectState;


    TGameInputForceFeedbackEffectKind = (
        GameInputForceFeedbackConstant = 0,
        GameInputForceFeedbackRamp = 1,
        GameInputForceFeedbackSineWave = 2,
        GameInputForceFeedbackSquareWave = 3,
        GameInputForceFeedbackTriangleWave = 4,
        GameInputForceFeedbackSawtoothUpWave = 5,
        GameInputForceFeedbackSawtoothDownWave = 6,
        GameInputForceFeedbackSpring = 7,
        GameInputForceFeedbackFriction = 8,
        GameInputForceFeedbackDamper = 9,
        GameInputForceFeedbackInertia = 10);

    PGameInputForceFeedbackEffectKind = ^TGameInputForceFeedbackEffectKind;


    TGameInputRumbleMotors = (
        GameInputRumbleNone = $00000000,
        GameInputRumbleLowFrequency = $00000001,
        GameInputRumbleHighFrequency = $00000002,
        GameInputRumbleLeftTrigger = $00000004,
        GameInputRumbleRightTrigger = $00000008);

    PGameInputRumbleMotors = ^TGameInputRumbleMotors;


    IGameInput = interface;
    PIGameInput = ^IGameInput;


    IGameInputReading = interface;
    PIGameInputReading = ^IGameInputReading;


    IGameInputDevice = interface;
    PIGameInputDevice = ^IGameInputDevice;


    IGameInputDispatcher = interface;
    PIGameInputDispatcher = ^IGameInputDispatcher;


    IGameInputForceFeedbackEffect = interface;
    PIGameInputForceFeedbackEffect = ^IGameInputForceFeedbackEffect;


    IGameInputRawDeviceReport = interface;
    PIGameInputRawDeviceReport = ^IGameInputRawDeviceReport;


    TGameInputCallbackToken = uint64;


    TGameInputReadingCallback = procedure(
        {_In_ } callbackToken: TGameInputCallbackToken;
        {_In_ } context: Pvoid;
        {_In_ } reading: IGameInputReading;
        {_In_ } hasOverrunOccurred: winbool); stdcall;


    TGameInputDeviceCallback = procedure(
        {_In_ } callbackToken: TGameInputCallbackToken;
        {_In_ } context: Pvoid;
        {_In_ } device: IGameInputDevice;
        {_In_ } timestamp: uint64;
        {_In_ } currentStatus: TGameInputDeviceStatus;
        {_In_ } previousStatus: TGameInputDeviceStatus); stdcall;


    TGameInputSystemButtonCallback = procedure(
        {_In_ } callbackToken: TGameInputCallbackToken;
        {_In_ } context: Pvoid;
        {_In_ } device: IGameInputDevice;
        {_In_ } timestamp: uint64;
        {_In_ } currentButtons: TGameInputSystemButtons;
        {_In_ } previousButtons: TGameInputSystemButtons); stdcall;


    TGameInputKeyboardLayoutCallback = procedure(
        {_In_ } callbackToken: TGameInputCallbackToken;
        {_In_ } context: Pvoid;
        {_In_ } device: IGameInputDevice;
        {_In_ } timestamp: uint64;
        {_In_ } currentLayout: uint32;
        {_In_ } previousLayout: uint32); stdcall;


    TGameInputKeyState = record
        scanCode: uint32;
        codePoint: uint32;
        virtualKey: uint8;
        isDeadKey: winbool;
    end;
    PGameInputKeyState = ^TGameInputKeyState;


    TGameInputMouseState = record
        Buttons: TGameInputMouseButtons;
        positionX: int64;
        positionY: int64;
        wheelX: int64;
        wheelY: int64;
    end;
    PGameInputMouseState = ^TGameInputMouseState;


    TGameInputTouchState = record
        touchId: uint64;
        sensorIndex: uint32;
        positionX: single;
        positionY: single;
        pressure: single;
        proximity: single;
        contactRectTop: single;
        contactRectLeft: single;
        contactRectRight: single;
        contactRectBottom: single;
    end;
    PGameInputTouchState = ^TGameInputTouchState;


    TGameInputMotionState = record
        accelerationX: single;
        accelerationY: single;
        accelerationZ: single;
        angularVelocityX: single;
        angularVelocityY: single;
        angularVelocityZ: single;
        magneticFieldX: single;
        magneticFieldY: single;
        magneticFieldZ: single;
        orientationW: single;
        orientationX: single;
        orientationY: single;
        orientationZ: single;
        accelerometerAccuracy: TGameInputMotionAccuracy;
        gyroscopeAccuracy: TGameInputMotionAccuracy;
        magnetometerAccuracy: TGameInputMotionAccuracy;
        orientationAccuracy: TGameInputMotionAccuracy;
    end;
    PGameInputMotionState = ^TGameInputMotionState;


    TGameInputArcadeStickState = record
        Buttons: TGameInputArcadeStickButtons;
    end;
    PGameInputArcadeStickState = ^TGameInputArcadeStickState;


    TGameInputFlightStickState = record
        Buttons: TGameInputFlightStickButtons;
        hatSwitch: TGameInputSwitchPosition;
        roll: single;
        pitch: single;
        yaw: single;
        throttle: single;
    end;
    PGameInputFlightStickState = ^TGameInputFlightStickState;


    TGameInputGamepadState = record
        Buttons: TGameInputGamepadButtons;
        leftTrigger: single;
        rightTrigger: single;
        leftThumbstickX: single;
        leftThumbstickY: single;
        rightThumbstickX: single;
        rightThumbstickY: single;
    end;
    PGameInputGamepadState = ^TGameInputGamepadState;


    TGameInputRacingWheelState = record
        Buttons: TGameInputRacingWheelButtons;
        patternShifterGear: int32;
        wheel: single;
        throttle: single;
        brake: single;
        clutch: single;
        handbrake: single;
    end;
    PGameInputRacingWheelState = ^TGameInputRacingWheelState;


    TGameInputUiNavigationState = record
        Buttons: TGameInputUiNavigationButtons;
    end;
    PGameInputUiNavigationState = ^TGameInputUiNavigationState;


    TGameInputBatteryState = record
        chargeRate: single;
        maxChargeRate: single;
        remainingCapacity: single;
        fullChargeCapacity: single;
        status: TGameInputBatteryStatus;
    end;
    PGameInputBatteryState = ^TGameInputBatteryState;


    TGameInputString = record
        sizeInBytes: uint32;
        codePointCount: uint32;
        {_Field_z_ } Data: pchar;
    end;
    PGameInputString = ^TGameInputString;


    TGameInputUsage = record
        page: uint16;
        id: uint16;
    end;
    PGameInputUsage = ^TGameInputUsage;


    TGameInputVersion = record
        major: uint16;
        minor: uint16;
        build: uint16;
        revision: uint16;
    end;
    PGameInputVersion = ^TGameInputVersion;


    PGameInputRawDeviceItemCollectionInfo = ^TGameInputRawDeviceItemCollectionInfo;

    TGameInputRawDeviceItemCollectionInfo = record
        kind: TGameInputRawDeviceItemCollectionKind;
        childCount: uint32;
        siblingCount: uint32;
        usageCount: uint32;
        {_Field_size_full_(usageCount) } usages: PGameInputUsage;
        {_Field_size_full_opt_(1) } parent: PGameInputRawDeviceItemCollectionInfo;
        {_Field_size_full_opt_(1) } firstSibling: PGameInputRawDeviceItemCollectionInfo;
        {_Field_size_full_opt_(1) } previousSibling: PGameInputRawDeviceItemCollectionInfo;
        {_Field_size_full_opt_(1) } nextSibling: PGameInputRawDeviceItemCollectionInfo;
        {_Field_size_full_opt_(1) } lastSibling: PGameInputRawDeviceItemCollectionInfo;
        {_Field_size_full_opt_(1) } firstChild: PGameInputRawDeviceItemCollectionInfo;
        {_Field_size_full_opt_(1) } lastChild: PGameInputRawDeviceItemCollectionInfo;
    end;


    TGameInputRawDeviceReportItemInfo = record
        bitOffset: uint32;
        bitSize: uint32;
        logicalMin: int64;
        logicalMax: int64;
        physicalMin: double;
        physicalMax: double;
        physicalUnits: TGameInputRawDevicePhysicalUnitKind;
        rawPhysicalUnits: uint32;
        rawPhysicalUnitsExponent: int32;
        flags: TGameInputRawDeviceReportItemFlags;
        usageCount: uint32;
        {_Field_size_full_(usageCount) } usages: PGameInputUsage;
        {_Field_size_full_(1) } collection: PGameInputRawDeviceItemCollectionInfo;
        {_Field_size_full_opt_(1) } itemString: PGameInputString;
    end;
    PGameInputRawDeviceReportItemInfo = ^TGameInputRawDeviceReportItemInfo;


    TGameInputRawDeviceReportInfo = record
        kind: TGameInputRawDeviceReportKind;
        id: uint32;
        size: uint32;
        itemCount: uint32;
        {_Field_size_full_opt_(itemCount) } items: PGameInputRawDeviceReportItemInfo;
    end;
    PGameInputRawDeviceReportInfo = ^TGameInputRawDeviceReportInfo;


    TGameInputControllerAxisInfo = record
        mappedInputKinds: TGameInputKind;
        InputLabel: TGameInputLabel;
        isContinuous: winbool;
        isNonlinear: winbool;
        isQuantized: winbool;
        hasRestValue: winbool;
        restValue: single;
        resolution: uint64;
        legacyDInputIndex: uint16;
        legacyHidIndex: uint16;
        rawReportIndex: uint32;
        {_Field_size_full_(1) } inputReport: PGameInputRawDeviceReportInfo;
        {_Field_size_full_(1) } inputReportItem: PGameInputRawDeviceReportItemInfo;
    end;
    PGameInputControllerAxisInfo = ^TGameInputControllerAxisInfo;


    TGameInputControllerButtonInfo = record
        mappedInputKinds: TGameInputKind;
        Inputlabel: TGameInputLabel;
        legacyDInputIndex: uint16;
        legacyHidIndex: uint16;
        rawReportIndex: uint32;
        {_Field_size_full_(1) } inputReport: PGameInputRawDeviceReportInfo;
        {_Field_size_full_(1) } inputReportItem: PGameInputRawDeviceReportItemInfo;
    end;
    PGameInputControllerButtonInfo = ^TGameInputControllerButtonInfo;


    TGameInputControllerSwitchInfo = record
        mappedInputKinds: TGameInputKind;
        Inputlabel: TGameInputLabel;
        positionLabels: array [0..9 - 1] of TGameInputLabel;
        kind: TGameInputSwitchKind;
        legacyDInputIndex: uint16;
        legacyHidIndex: uint16;
        rawReportIndex: uint32;
        {_Field_size_full_(1) } inputReport: PGameInputRawDeviceReportInfo;
        {_Field_size_full_(1) } inputReportItem: PGameInputRawDeviceReportItemInfo;
    end;
    PGameInputControllerSwitchInfo = ^TGameInputControllerSwitchInfo;


    TGameInputKeyboardInfo = record
        kind: TGameInputKeyboardKind;
        layout: uint32;
        keyCount: uint32;
        functionKeyCount: uint32;
        maxSimultaneousKeys: uint32;
        platformType: uint32;
        platformSubtype: uint32;
        {_Field_size_full_opt_(1) } nativeLanguage: PGameInputString;
    end;
    PGameInputKeyboardInfo = ^TGameInputKeyboardInfo;


    TGameInputMouseInfo = record
        supportedButtons: TGameInputMouseButtons;
        sampleRate: uint32;
        sensorDpi: uint32;
        hasWheelX: winbool;
        hasWheelY: winbool;
    end;
    PGameInputMouseInfo = ^TGameInputMouseInfo;


    TGameInputTouchSensorInfo = record
        mappedInputKinds: TGameInputKind;
        Inputlabel: TGameInputLabel;
        location: TGameInputLocation;
        locationId: uint32;
        resolutionX: uint64;
        resolutionY: uint64;
        shape: TGameInputTouchShape;
        aspectRatio: single;
        orientation: single;
        physicalWidth: single;
        physicalHeight: single;
        maxPressure: single;
        maxProximity: single;
        maxTouchPoints: uint32;
    end;
    PGameInputTouchSensorInfo = ^TGameInputTouchSensorInfo;


    TGameInputMotionInfo = record
        maxAcceleration: single;
        maxAngularVelocity: single;
        maxMagneticFieldStrength: single;
    end;
    PGameInputMotionInfo = ^TGameInputMotionInfo;


    TGameInputArcadeStickInfo = record
        menuButtonLabel: TGameInputLabel;
        viewButtonLabel: TGameInputLabel;
        stickUpLabel: TGameInputLabel;
        stickDownLabel: TGameInputLabel;
        stickLeftLabel: TGameInputLabel;
        stickRightLabel: TGameInputLabel;
        actionButton1Label: TGameInputLabel;
        actionButton2Label: TGameInputLabel;
        actionButton3Label: TGameInputLabel;
        actionButton4Label: TGameInputLabel;
        actionButton5Label: TGameInputLabel;
        actionButton6Label: TGameInputLabel;
        specialButton1Label: TGameInputLabel;
        specialButton2Label: TGameInputLabel;
    end;
    PGameInputArcadeStickInfo = ^TGameInputArcadeStickInfo;


    TGameInputFlightStickInfo = record
        menuButtonLabel: TGameInputLabel;
        viewButtonLabel: TGameInputLabel;
        firePrimaryButtonLabel: TGameInputLabel;
        fireSecondaryButtonLabel: TGameInputLabel;
        hatSwitchKind: TGameInputSwitchKind;
    end;
    PGameInputFlightStickInfo = ^TGameInputFlightStickInfo;


    TGameInputGamepadInfo = record
        menuButtonLabel: TGameInputLabel;
        viewButtonLabel: TGameInputLabel;
        aButtonLabel: TGameInputLabel;
        bButtonLabel: TGameInputLabel;
        xButtonLabel: TGameInputLabel;
        yButtonLabel: TGameInputLabel;
        dpadUpLabel: TGameInputLabel;
        dpadDownLabel: TGameInputLabel;
        dpadLeftLabel: TGameInputLabel;
        dpadRightLabel: TGameInputLabel;
        leftShoulderButtonLabel: TGameInputLabel;
        rightShoulderButtonLabel: TGameInputLabel;
        leftThumbstickButtonLabel: TGameInputLabel;
        rightThumbstickButtonLabel: TGameInputLabel;
    end;
    PGameInputGamepadInfo = ^TGameInputGamepadInfo;


    TGameInputRacingWheelInfo = record
        menuButtonLabel: TGameInputLabel;
        viewButtonLabel: TGameInputLabel;
        previousGearButtonLabel: TGameInputLabel;
        nextGearButtonLabel: TGameInputLabel;
        dpadUpLabel: TGameInputLabel;
        dpadDownLabel: TGameInputLabel;
        dpadLeftLabel: TGameInputLabel;
        dpadRightLabel: TGameInputLabel;
        hasClutch: winbool;
        hasHandbrake: winbool;
        hasPatternShifter: winbool;
        minPatternShifterGear: int32;
        maxPatternShifterGear: int32;
        maxWheelAngle: single;
    end;
    PGameInputRacingWheelInfo = ^TGameInputRacingWheelInfo;


    TGameInputUiNavigationInfo = record
        menuButtonLabel: TGameInputLabel;
        viewButtonLabel: TGameInputLabel;
        acceptButtonLabel: TGameInputLabel;
        cancelButtonLabel: TGameInputLabel;
        upButtonLabel: TGameInputLabel;
        downButtonLabel: TGameInputLabel;
        leftButtonLabel: TGameInputLabel;
        rightButtonLabel: TGameInputLabel;
        contextButton1Label: TGameInputLabel;
        contextButton2Label: TGameInputLabel;
        contextButton3Label: TGameInputLabel;
        contextButton4Label: TGameInputLabel;
        pageUpButtonLabel: TGameInputLabel;
        pageDownButtonLabel: TGameInputLabel;
        pageLeftButtonLabel: TGameInputLabel;
        pageRightButtonLabel: TGameInputLabel;
        scrollUpButtonLabel: TGameInputLabel;
        scrollDownButtonLabel: TGameInputLabel;
        scrollLeftButtonLabel: TGameInputLabel;
        scrollRightButtonLabel: TGameInputLabel;
        guideButtonLabel: TGameInputLabel;
    end;
    PGameInputUiNavigationInfo = ^TGameInputUiNavigationInfo;


    TGameInputForceFeedbackMotorInfo = record
        supportedAxes: TGameInputFeedbackAxes;
        location: TGameInputLocation;
        locationId: uint32;
        maxSimultaneousEffects: uint32;
        isConstantEffectSupported: winbool;
        isRampEffectSupported: winbool;
        isSineWaveEffectSupported: winbool;
        isSquareWaveEffectSupported: winbool;
        isTriangleWaveEffectSupported: winbool;
        isSawtoothUpWaveEffectSupported: winbool;
        isSawtoothDownWaveEffectSupported: winbool;
        isSpringEffectSupported: winbool;
        isFrictionEffectSupported: winbool;
        isDamperEffectSupported: winbool;
        isInertiaEffectSupported: winbool;
    end;
    PGameInputForceFeedbackMotorInfo = ^TGameInputForceFeedbackMotorInfo;


    TGameInputHapticWaveformInfo = record
        usage: TGameInputUsage;
        isDurationSupported: winbool;
        isIntensitySupported: winbool;
        isRepeatSupported: winbool;
        isRepeatDelaySupported: winbool;
        defaultDuration: uint64;
    end;
    PGameInputHapticWaveformInfo = ^TGameInputHapticWaveformInfo;


    TGameInputHapticFeedbackMotorInfo = record
        mappedRumbleMotors: TGameInputRumbleMotors;
        location: TGameInputLocation;
        locationId: uint32;
        waveformCount: uint32;
        {_Field_size_full_(waveformCount) } waveformInfo: PGameInputHapticWaveformInfo;
    end;
    PGameInputHapticFeedbackMotorInfo = ^TGameInputHapticFeedbackMotorInfo;

    TAPP_LOCAL_DEVICE_ID = record
        Value: array [0..APP_LOCAL_DEVICE_ID_SIZE - 1] of byte;
    end;
    PAPP_LOCAL_DEVICE_ID = ^TAPP_LOCAL_DEVICE_ID;

    TGameInputDeviceInfo = record
        infoSize: uint32;
        vendorId: uint16;
        productId: uint16;
        revisionNumber: uint16;
        interfaceNumber: uint8;
        collectionNumber: uint8;
        usage: TGameInputUsage;
        hardwareVersion: TGameInputVersion;
        firmwareVersion: TGameInputVersion;
        deviceId: TAPP_LOCAL_DEVICE_ID;
        deviceRootId: TAPP_LOCAL_DEVICE_ID;
        deviceFamily: TGameInputDeviceFamily;
        capabilities: TGameInputDeviceCapabilities;
        supportedInput: TGameInputKind;
        supportedRumbleMotors: TGameInputRumbleMotors;
        inputReportCount: uint32;
        outputReportCount: uint32;
        featureReportCount: uint32;
        controllerAxisCount: uint32;
        controllerButtonCount: uint32;
        controllerSwitchCount: uint32;
        touchPointCount: uint32;
        touchSensorCount: uint32;
        forceFeedbackMotorCount: uint32;
        hapticFeedbackMotorCount: uint32;
        deviceStringCount: uint32;
        deviceDescriptorSize: uint32;
        {_Field_size_full_opt_(inputReportCount) } inputReportInfo: PGameInputRawDeviceReportInfo;
        {_Field_size_full_opt_(outputReportCount) } outputReportInfo: PGameInputRawDeviceReportInfo;
        {_Field_size_full_opt_(featureReportCount) } featureReportInfo: PGameInputRawDeviceReportInfo;
        {_Field_size_full_opt_(controllerAxisCount) } controllerAxisInfo: PGameInputControllerAxisInfo;
        {_Field_size_full_opt_(controllerButtonCount) } controllerButtonInfo: PGameInputControllerButtonInfo;
        {_Field_size_full_opt_(controllerSwitchCount) } controllerSwitchInfo: PGameInputControllerSwitchInfo;
        {_Field_size_full_opt_(1) } keyboardInfo: PGameInputKeyboardInfo;
        {_Field_size_full_opt_(1) } mouseInfo: PGameInputMouseInfo;
        {_Field_size_full_opt_(touchSensorCount) } touchSensorInfo: PGameInputTouchSensorInfo;
        {_Field_size_full_opt_(1) } motionInfo: PGameInputMotionInfo;
        {_Field_size_full_opt_(1) } arcadeStickInfo: PGameInputArcadeStickInfo;
        {_Field_size_full_opt_(1) } flightStickInfo: PGameInputFlightStickInfo;
        {_Field_size_full_opt_(1) } gamepadInfo: PGameInputGamepadInfo;
        {_Field_size_full_opt_(1) } racingWheelInfo: PGameInputRacingWheelInfo;
        {_Field_size_full_opt_(1) } uiNavigationInfo: PGameInputUiNavigationInfo;
        {_Field_size_full_opt_(forceFeedbackMotorCount) } forceFeedbackMotorInfo: PGameInputForceFeedbackMotorInfo;
        {_Field_size_full_opt_(hapticFeedbackMotorCount) } hapticFeedbackMotorInfo: PGameInputHapticFeedbackMotorInfo;
        {_Field_size_full_opt_(1) } displayName: PGameInputString;
        {_Field_size_full_opt_(deviceStringCount) } deviceStrings: PGameInputString;
        {_Field_size_bytes_full_opt_(deviceDescriptorSize) } deviceDescriptorData: Pvoid;
        supportedSystemButtons: TGameInputSystemButtons;
    end;
    PGameInputDeviceInfo = ^TGameInputDeviceInfo;


    TGameInputForceFeedbackEnvelope = record
        attackDuration: uint64;
        sustainDuration: uint64;
        releaseDuration: uint64;
        attackGain: single;
        sustainGain: single;
        releaseGain: single;
        playCount: uint32;
        repeatDelay: uint64;
    end;
    PGameInputForceFeedbackEnvelope = ^TGameInputForceFeedbackEnvelope;


    TGameInputForceFeedbackMagnitude = record
        linearX: single;
        linearY: single;
        linearZ: single;
        angularX: single;
        angularY: single;
        angularZ: single;
        normal: single;
    end;
    PGameInputForceFeedbackMagnitude = ^TGameInputForceFeedbackMagnitude;


    TGameInputForceFeedbackConditionParams = record
        magnitude: TGameInputForceFeedbackMagnitude;
        positiveCoefficient: single;
        negativeCoefficient: single;
        maxPositiveMagnitude: single;
        maxNegativeMagnitude: single;
        deadZone: single;
        bias: single;
    end;
    PGameInputForceFeedbackConditionParams = ^TGameInputForceFeedbackConditionParams;


    TGameInputForceFeedbackConstantParams = record
        envelope: TGameInputForceFeedbackEnvelope;
        magnitude: TGameInputForceFeedbackMagnitude;
    end;
    PGameInputForceFeedbackConstantParams = ^TGameInputForceFeedbackConstantParams;


    TGameInputForceFeedbackPeriodicParams = record
        envelope: TGameInputForceFeedbackEnvelope;
        magnitude: TGameInputForceFeedbackMagnitude;
        frequency: single;
        phase: single;
        bias: single;
    end;
    PGameInputForceFeedbackPeriodicParams = ^TGameInputForceFeedbackPeriodicParams;


    TGameInputForceFeedbackRampParams = record
        envelope: TGameInputForceFeedbackEnvelope;
        startMagnitude: TGameInputForceFeedbackMagnitude;
        endMagnitude: TGameInputForceFeedbackMagnitude;
    end;
    PGameInputForceFeedbackRampParams = ^TGameInputForceFeedbackRampParams;


    TGameInputForceFeedbackParams = record
        kind: TGameInputForceFeedbackEffectKind;
        case integer of
            0: (
                constant: TGameInputForceFeedbackConstantParams;
            );
            1: (
                ramp: TGameInputForceFeedbackRampParams;
            );
            2: (
                sineWave: TGameInputForceFeedbackPeriodicParams;
            );
            3: (
                squareWave: TGameInputForceFeedbackPeriodicParams;
            );
            4: (
                triangleWave: TGameInputForceFeedbackPeriodicParams;
            );
            5: (
                sawtoothUpWave: TGameInputForceFeedbackPeriodicParams;
            );
            6: (
                sawtoothDownWave: TGameInputForceFeedbackPeriodicParams;
            );
            7: (
                spring: TGameInputForceFeedbackConditionParams;
            );
            8: (
                friction: TGameInputForceFeedbackConditionParams;
            );
            9: (
                damper: TGameInputForceFeedbackConditionParams;
            );
            10: (
                inertia: TGameInputForceFeedbackConditionParams;
            );
    end;
    PGameInputForceFeedbackParams = ^TGameInputForceFeedbackParams;


    TGameInputHapticFeedbackParams = record
        waveformIndex: uint32;
        duration: uint64;
        intensity: single;
        playCount: uint32;
        repeatDelay: uint64;
    end;
    PGameInputHapticFeedbackParams = ^TGameInputHapticFeedbackParams;


    TGameInputRumbleParams = record
        lowFrequency: single;
        highFrequency: single;
        leftTrigger: single;
        rightTrigger: single;
    end;
    PGameInputRumbleParams = ^TGameInputRumbleParams;


    IGameInput = interface(IUnknown)
        ['{11BE2A7E-4254-445A-9C09-FFC40F006918}']
        function GetCurrentTimestamp(): uint64; stdcall;

        function GetCurrentReading(
        {_In_ } inputKind: TGameInputKind;
        {_In_opt_ } device: IGameInputDevice;
        {_COM_Outptr_ }  out reading: IGameInputReading): HRESULT; stdcall;

        function GetNextReading(
        {_In_ } referenceReading: IGameInputReading;
        {_In_ } inputKind: TGameInputKind;
        {_In_opt_ } device: IGameInputDevice;
        {_COM_Outptr_ }  out reading: IGameInputReading): HRESULT; stdcall;

        function GetPreviousReading(
        {_In_ } referenceReading: IGameInputReading;
        {_In_ } inputKind: TGameInputKind;
        {_In_opt_ } device: IGameInputDevice;
        {_COM_Outptr_ }  out reading: IGameInputReading): HRESULT; stdcall;

        function GetTemporalReading(
        {_In_ } timestamp: uint64;
        {_In_ } device: IGameInputDevice;
        {_COM_Outptr_ }  out reading: IGameInputReading): HRESULT; stdcall;

        function RegisterReadingCallback(
        {_In_opt_ } device: IGameInputDevice;
        {_In_ } inputKind: TGameInputKind;
        {_In_ } analogThreshold: single;
        {_In_opt_ } context: Pvoid;
        {_In_ } callbackFunc: TGameInputReadingCallback;
        {_Out_opt_ _Result_zeroonfailure_ } callbackToken: TGameInputCallbackToken): HRESULT; stdcall;

        function RegisterDeviceCallback(
        {_In_opt_ } device: IGameInputDevice;
        {_In_ } inputKind: TGameInputKind;
        {_In_ } statusFilter: TGameInputDeviceStatus;
        {_In_ } enumerationKind: TGameInputEnumerationKind;
        {_In_opt_ } context: Pvoid;
        {_In_ } callbackFunc: TGameInputDeviceCallback;
        {_Out_opt_ _Result_zeroonfailure_}callbackToken: TGameInputCallbackToken): HRESULT; stdcall;

        function RegisterSystemButtonCallback(
        {_In_opt_ } device: IGameInputDevice;
        {_In_ } buttonFilter: TGameInputSystemButtons;
        {_In_opt_ } context: Pvoid;
        {_In_ } callbackFunc: TGameInputSystemButtonCallback;
        {_Out_opt_ _Result_zeroonfailure_ } callbackToken: TGameInputCallbackToken): HRESULT; stdcall;

        function RegisterKeyboardLayoutCallback(
        {_In_opt_ } device: IGameInputDevice;
        {_In_opt_ } context: Pvoid;
        {_In_ } callbackFunc: TGameInputKeyboardLayoutCallback;
        {_Out_opt_ _Result_zeroonfailure_} callbackToken: TGameInputCallbackToken): HRESULT; stdcall;

        procedure StopCallback(
        {_In_ } callbackToken: TGameInputCallbackToken); stdcall;

        function UnregisterCallback(
        {_In_ } callbackToken: TGameInputCallbackToken;
        {_In_ } timeoutInMicroseconds: uint64): winbool; stdcall;

        function CreateDispatcher(
        {_COM_Outptr_ }  out dispatcher: IGameInputDispatcher): HRESULT; stdcall;

        function CreateAggregateDevice(
        {_In_ } inputKind: TGameInputKind;
        {_COM_Outptr_ }  out device: IGameInputDevice): HRESULT; stdcall;

        function FindDeviceFromId(
        {_In_ } Value: PAPP_LOCAL_DEVICE_ID;
        {_COM_Outptr_ }  out device: IGameInputDevice): HRESULT; stdcall;

        function FindDeviceFromObject(
        {_In_ } Value: IUnknown;
        {_COM_Outptr_ }  out device: IGameInputDevice): HRESULT; stdcall;

        function FindDeviceFromPlatformHandle(
        {_In_ } Value: HANDLE;
        {_COM_Outptr_ }  out device: IGameInputDevice): HRESULT; stdcall;

        function FindDeviceFromPlatformString(
        {_In_ } Value: LPCWSTR;
        {_COM_Outptr_ }  out device: IGameInputDevice): HRESULT; stdcall;

        function EnableOemDeviceSupport(
        {_In_ } vendorId: uint16;
        {_In_ } productId: uint16;
        {_In_ } interfaceNumber: uint8;
        {_In_ } collectionNumber: uint8): HRESULT; stdcall;

        procedure SetFocusPolicy(
        {_In_ } policy: TGameInputFocusPolicy); stdcall;

    end;

    IGameInputReading = interface(IUnknown)
        ['{2156947A-E1FA-4DE0-A30B-D812931DBD8D}']
        function GetInputKind(): TGameInputKind; stdcall;

        function GetSequenceNumber(
        {_In_ } inputKind: TGameInputKind): uint64; stdcall;

        function GetTimestamp(): uint64; stdcall;

        procedure GetDevice(
        {_Outptr_ }  out device: IGameInputDevice); stdcall;

        function GetRawReport(
        {_Outptr_result_maybenull_ }  out report: IGameInputRawDeviceReport): winbool; stdcall;

        function GetControllerAxisCount(): uint32; stdcall;

        function GetControllerAxisState(
        {_In_ } stateArrayCount: uint32;
        {_Out_writes_(stateArrayCount) } stateArray: Psingle): uint32; stdcall;

        function GetControllerButtonCount(): uint32; stdcall;

        function GetControllerButtonState(
        {_In_ } stateArrayCount: uint32;
        {_Out_writes_(stateArrayCount) } stateArray: Pboolean): uint32; stdcall;

        function GetControllerSwitchCount(): uint32; stdcall;

        function GetControllerSwitchState(
        {_In_ } stateArrayCount: uint32;
        {_Out_writes_(stateArrayCount) } stateArray: PGameInputSwitchPosition): uint32; stdcall;

        function GetKeyCount(): uint32; stdcall;

        function GetKeyState(
        {_In_ } stateArrayCount: uint32;
        {_Out_writes_(stateArrayCount) } stateArray: PGameInputKeyState): uint32; stdcall;

        function GetMouseState(
        {_Out_ } state: PGameInputMouseState): winbool; stdcall;

        function GetTouchCount(): uint32; stdcall;

        function GetTouchState(
        {_In_ } stateArrayCount: uint32;
        {_Out_writes_(stateArrayCount) } stateArray: PGameInputTouchState): uint32; stdcall;

        function GetMotionState(
        {_Out_ } state: PGameInputMotionState): winbool; stdcall;

        function GetArcadeStickState(
        {_Out_ } state: PGameInputArcadeStickState): winbool; stdcall;

        function GetFlightStickState(
        {_Out_ } state: PGameInputFlightStickState): winbool; stdcall;

        function GetGamepadState(
        {_Out_ } state: PGameInputGamepadState): winbool; stdcall;

        function GetRacingWheelState(
        {_Out_ } state: PGameInputRacingWheelState): winbool; stdcall;

        function GetUiNavigationState(
        {_Out_ } state: PGameInputUiNavigationState): winbool; stdcall;

    end;


    IGameInputDevice = interface(IUnknown)
        ['{31DD86FB-4C1B-408A-868F-439B3CD47125}']
        function GetDeviceInfo(): TGameInputDeviceInfo; stdcall;

        function GetDeviceStatus(): TGameInputDeviceStatus; stdcall;

        procedure GetBatteryState(
        {_Out_ } state: PGameInputBatteryState); stdcall;

        function CreateForceFeedbackEffect(
        {_In_ } motorIndex: uint32;
        {_In_ } params: PGameInputForceFeedbackParams;
        {_COM_Outptr_ }  out effect: IGameInputForceFeedbackEffect): HRESULT; stdcall;

        function IsForceFeedbackMotorPoweredOn(
        {_In_ } motorIndex: uint32): winbool; stdcall;

        procedure SetForceFeedbackMotorGain(
        {_In_ } motorIndex: uint32;
        {_In_ } masterGain: single); stdcall;

        function SetHapticMotorState(
        {_In_ } motorIndex: uint32;
        {_In_opt_ } params: PGameInputHapticFeedbackParams): HRESULT; stdcall;

        procedure SetRumbleState(
        {_In_opt_ } params: PGameInputRumbleParams); stdcall;

        procedure SetInputSynchronizationState(
        {_In_ } Enabled: winbool); stdcall;

        procedure SendInputSynchronizationHint(); stdcall;

        procedure PowerOff(); stdcall;

        function CreateRawDeviceReport(
        {_In_ } reportId: uint32;
        {_In_ } reportKind: TGameInputRawDeviceReportKind;
        {_COM_Outptr_ }  out report: IGameInputRawDeviceReport): HRESULT; stdcall;

        function GetRawDeviceFeature(
        {_In_ } reportId: uint32;
        {_COM_Outptr_ }  out report: IGameInputRawDeviceReport): HRESULT; stdcall;

        function SetRawDeviceFeature(
        {_In_ } report: IGameInputRawDeviceReport): HRESULT; stdcall;

        function SendRawDeviceOutput(
        {_In_ } report: IGameInputRawDeviceReport): HRESULT; stdcall;

        function SendRawDeviceOutputWithResponse(
        {_In_ } requestReport: IGameInputRawDeviceReport;
        {_COM_Outptr_ }  out responseReport: IGameInputRawDeviceReport): HRESULT; stdcall;

        function ExecuteRawDeviceIoControl(
        {_In_ } controlCode: uint32;
        {_In_ } inputBufferSize: size_t;
        {_In_reads_bytes_opt_(inputBufferSize) } inputBuffer: Pvoid;
        {_In_ } outputBufferSize: size_t;
        {_Out_writes_bytes_all_opt_(outputBufferSize) } outputBuffer: Pvoid;
        {_Out_opt_ _Result_zeroonfailure_ } outputSize: Psize_t): HRESULT; stdcall;

        function AcquireExclusiveRawDeviceAccess(
        {_In_ } timeoutInMicroseconds: uint64): winbool; stdcall;

        procedure ReleaseExclusiveRawDeviceAccess(); stdcall;

    end;


    IGameInputDispatcher = interface(IUnknown)
        ['{415EED2E-98CB-42C2-8F28-B94601074E31}']
        function Dispatch(
        {_In_ } quotaInMicroseconds: uint64): winbool; stdcall;

        function OpenWaitHandle(
        {_Outptr_result_nullonfailure_ } waitHandle: PHANDLE): HRESULT; stdcall;

    end;


    IGameInputForceFeedbackEffect = interface(IUnknown)
        ['{51BDA05E-F742-45D9-B085-9444AE48381D}']
        procedure GetDevice(
        {_Outptr_ }  out device: IGameInputDevice); stdcall;

        function GetMotorIndex(): uint32; stdcall;

        function GetGain(): single; stdcall;

        procedure SetGain(
        {_In_ } gain: single); stdcall;

        procedure GetParams(
        {_Out_ } params: PGameInputForceFeedbackParams); stdcall;

        function SetParams(
        {_In_ } params: PGameInputForceFeedbackParams): winbool; stdcall;

        function GetState(): TGameInputFeedbackEffectState; stdcall;

        procedure SetState(
        {_In_ } state: TGameInputFeedbackEffectState); stdcall;

    end;


    IGameInputRawDeviceReport = interface(IUnknown)
        ['{61F08CF1-1FFC-40CA-A2B8-E1AB8BC5B6DC}']
        procedure GetDevice(
        {_Outptr_ }  out device: IGameInputDevice); stdcall;

        function GetReportInfo(): TGameInputRawDeviceReportInfo; stdcall;

        function GetRawDataSize(): size_t; stdcall;

        function GetRawData(
        {_In_ } bufferSize: size_t;
        {_Out_writes_(bufferSize) } buffer: Pvoid): size_t; stdcall;

        function SetRawData(
        {_In_ } bufferSize: size_t;
        {_In_reads_(bufferSize) } buffer: Pvoid): winbool; stdcall;

        function GetItemValue(
        {_In_ } ItemIndex: uint32;
        {_Out_ } Value: Pint64): winbool; stdcall;

        function SetItemValue(
        {_In_ } ItemIndex: uint32;
        {_In_ } Value: int64): winbool; stdcall;

        function ResetItemValue(
        {_In_ } ItemIndex: uint32): winbool; stdcall;

        function ResetAllItems(): winbool; stdcall;

    end;

function GameInputCreate(
    {_COM_Outptr_ }  out gameInput: IGameInput): HRESULT; stdcall; external GameInput_DLL;

implementation

end.
