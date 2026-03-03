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
   File name:
   Header version: 10.0.26100.6584
   GameInput version: 3.1.26100.6879

  ************************************************************************** }


unit DX12.GameInput;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils;

    {$A4}
    {$z4}

const
    GameInput_DLL = 'GameInput.dll';
    GAMEINPUT_API_VERSION = 3;


    GAMEINPUT_HAPTIC_LOCATION_NONE: TGUID = '{00000000-0000-0000-0000-000000000000}';
    GAMEINPUT_HAPTIC_LOCATION_GRIP_LEFT: TGUID = '{08C707C2-66BB-406C-A84A-DFE085120A92}';
    GAMEINPUT_HAPTIC_LOCATION_GRIP_RIGHT: TGUID = '{155A0B77-8BB2-40DB-8690-B6D41126DFC1}';
    GAMEINPUT_HAPTIC_LOCATION_TRIGGER_LEFT: TGUID = '{8DE4D896-5559-4081-86E5-1724CC07C6BC}';
    GAMEINPUT_HAPTIC_LOCATION_TRIGGER_RIGHT: TGUID = '{FF0CB557-3AF5-406B-8B0F-555A2D92A220}';


    GAMEINPUT_HAPTIC_MAX_LOCATIONS = 8;
    GAMEINPUT_HAPTIC_MAX_AUDIO_ENDPOINT_ID_SIZE = 256;

    GAMEINPUT_MAX_SWITCH_STATES = 8;

    APP_LOCAL_DEVICE_ID_SIZE = 32;

    GAMEINPUT_FACILITY = $38A;

    GAMEINPUT_E_DEVICE_DISCONNECTED = HRESULT($838A0001);
    GAMEINPUT_E_DEVICE_NOT_FOUND = HRESULT($838A0002);
    GAMEINPUT_E_READING_NOT_FOUND = HRESULT($838A0003);
    GAMEINPUT_E_REFERENCE_READING_TOO_OLD = HRESULT($838A0004);
    GAMEINPUT_E_FEEDBACK_NOT_SUPPORTED = HRESULT($838A0007);
    GAMEINPUT_E_OBJECT_NO_LONGER_EXISTS = HRESULT($838A0008);
    GAMEINPUT_E_CALLBACK_NOT_FOUND = HRESULT($838A0009);
    GAMEINPUT_E_HAPTIC_INFO_NOT_FOUND = HRESULT($838A000A);
    GAMEINPUT_E_AGGREGATE_OPERATION_NOT_SUPPORTED = HRESULT($838A000B);
    GAMEINPUT_E_INPUT_KIND_NOT_PRESENT = HRESULT($838A000C);

    IID_IGameInput: TGUID = '{20EFC1C7-5D9A-43BA-B26F-B807FA48609C}';
    IID_IGameInputRawDeviceReport: TGUID = '{05A42D89-2CB6-45A3-874D-E635723587AB}';
    IID_IGameInputReading: TGUID = '{C81C4CDE-ED1A-4631-A30F-C556A6241A1F}';
    IID_IGameInputDevice: TGUID = '{63E2F38B-A399-4275-8AE7-D4C6E524D12A}';
    IID_IGameInputDispatcher: TGUID = '{415EED2E-98CB-42C2-8F28-B94601074E31}';
    IID_IGameInputForceFeedbackEffect: TGUID = '{FF61096A-3373-4093-A1DF-6D31846B3511}';
    IID_IGameInputMapper: TGUID = '{3C600700-F16C-49CE-9BE6-6A2EF752ED5E}';


type

    REFIID = ^TGUID;

    TGameInputKind = (
        GameInputKindUnknown = $00000000,
        GameInputKindRawDeviceReport = $00000001,
        GameInputKindControllerAxis = $00000002,
        GameInputKindControllerButton = $00000004,
        GameInputKindControllerSwitch = $00000008,
        GameInputKindController = $0000000E,
        GameInputKindKeyboard = $00000010,
        GameInputKindMouse = $00000020,
        GameInputKindSensors = $00000040,
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
        GameInputExclusiveForegroundShareButton = $00000020,
        GameInputEnableBackgroundInput = $00000040,
        GameInputEnableBackgroundGuideButton = $00000080,
        GameInputEnableBackgroundShareButton = $00000100);

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


    TGameInputMousePositions = (
        GameInputMouseNoPosition = $00000000,
        GameInputMouseAbsolutePosition = $00000001,
        GameInputMouseRelativePosition = $00000002);

    PGameInputMousePositions = ^TGameInputMousePositions;


    TGameInputSensorsKind = (
        GameInputSensorsNone = $00000000,
        GameInputSensorsAccelerometer = $00000001,
        GameInputSensorsGyrometer = $00000002,
        GameInputSensorsCompass = $00000004,
        GameInputSensorsOrientation = $00000008);

    PGameInputSensorsKind = ^TGameInputSensorsKind;


    TGameInputSensorAccuracy = (
        GameInputSensorAccuracyUnknown = $00000000,
        GameInputSensorAccuracyUnreliable = $00000001,
        GameInputSensorAccuracyApproximate = $00000002,
        GameInputSensorAccuracyHigh = $00000003);

    PGameInputSensorAccuracy = ^TGameInputSensorAccuracy;


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
        GameInputFlightStickFireSecondary = $00000008,
        GameInputFlightStickHatSwitchUp = $00000010,
        GameInputFlightStickHatSwitchDown = $00000020,
        GameInputFlightStickHatSwitchLeft = $00000040,
        GameInputFlightStickHatSwitchRight = $00000080,
        GameInputFlightStickA = $00000100,
        GameInputFlightStickB = $00000200,
        GameInputFlightStickX = $00000400,
        GameInputFlightStickY = $00000800,
        GameInputFlightStickLeftShoulder = $00001000,
        GameInputFlightStickRightShoulder = $00002000);

    PGameInputFlightStickButtons = ^TGameInputFlightStickButtons;


    TGameInputGamepadButtons = (
        GameInputGamepadNone = $00000000,
        GameInputGamepadMenu = $00000001,
        GameInputGamepadView = $00000002,
        GameInputGamepadA = $00000004,
        GameInputGamepadB = $00000008,
        GameInputGamepadC = $00004000,
        GameInputGamepadX = $00000010,
        GameInputGamepadY = $00000020,
        GameInputGamepadZ = $00008000,
        GameInputGamepadDPadUp = $00000040,
        GameInputGamepadDPadDown = $00000080,
        GameInputGamepadDPadLeft = $00000100,
        GameInputGamepadDPadRight = $00000200,
        GameInputGamepadLeftShoulder = $00000400,
        GameInputGamepadRightShoulder = $00000800,
        GameInputGamepadLeftTriggerButton = $00010000,
        GameInputGamepadRightTriggerButton = $00020000,
        GameInputGamepadLeftThumbstick = $00001000,
        GameInputGamepadRightThumbstick = $00002000,
        GameInputGamepadLeftThumbstickUp = $00040000,
        GameInputGamepadLeftThumbstickDown = $00080000,
        GameInputGamepadLeftThumbstickLeft = $00100000,
        GameInputGamepadLeftThumbstickRight = $00200000,
        GameInputGamepadRightThumbstickUp = $00400000,
        GameInputGamepadRightThumbstickDown = $00800000,
        GameInputGamepadRightThumbstickLeft = $01000000,
        GameInputGamepadRightThumbstickRight = $02000000,
        GameInputGamepadPaddleLeft1 = $04000000,
        GameInputGamepadPaddleLeft2 = $08000000,
        GameInputGamepadPaddleRight1 = $10000000,
        GameInputGamepadPaddleRight2 = $20000000,

        // Gamepad modules (Groupings of gamepad elements commonly found together)
        GameInputGamepadModuleSystemDuo =
        Ord(GameInputGamepadMenu) or Ord(GameInputGamepadView),

        GameInputGamepadModuleDpad =
        Ord(GameInputGamepadDPadUp) or Ord(GameInputGamepadDPadDown) or Ord(GameInputGamepadDPadLeft) or Ord(GameInputGamepadDPadRight),

        GameInputGamepadModuleShoulders =
        Ord(GameInputGamepadLeftShoulder) or Ord(GameInputGamepadRightShoulder),

        GameInputGamepadModuleTriggers =
        Ord(GameInputGamepadLeftTriggerButton) or Ord(GameInputGamepadRightTriggerButton),

        GameInputGamepadModuleThumbsticks =
        Ord(GameInputGamepadLeftThumbstickUp) or Ord(GameInputGamepadLeftThumbstickDown) or Ord(GameInputGamepadLeftThumbstickLeft) or Ord(GameInputGamepadLeftThumbstickRight) or
        Ord(GameInputGamepadRightThumbstickUp) or Ord(GameInputGamepadRightThumbstickDown) or Ord(GameInputGamepadRightThumbstickLeft) or Ord(GameInputGamepadRightThumbstickRight),

        GameInputGamepadModulePaddles2 =
        Ord(GameInputGamepadPaddleLeft1) or Ord(GameInputGamepadPaddleRight1),

        GameInputGamepadModulePaddles4 =
        Ord(GameInputGamepadPaddleLeft1) or Ord(GameInputGamepadPaddleLeft2) or Ord(GameInputGamepadPaddleRight1) or Ord(GameInputGamepadPaddleRight2),

        // Commonly found gamepad layouts. Custom layouts are possible and encouraged.
        GameInputGamepadLayoutBasic =
        Ord(GameInputGamepadModuleSystemDuo) or Ord(GameInputGamepadModuleDpad) or Ord(GameInputGamepadA) or Ord(GameInputGamepadB),

        GameInputGamepadLayoutButtons =
        Ord(GameInputGamepadLayoutBasic) or Ord(GameInputGamepadX) or Ord(GameInputGamepadY) or Ord(GameInputGamepadModuleShoulders),

        GameInputGamepadLayoutStandard =
        Ord(GameInputGamepadLayoutButtons) or Ord(GameInputGamepadModuleTriggers) or Ord(GameInputGamepadModuleThumbsticks) or Ord(GameInputGamepadLeftThumbstick) or Ord(GameInputGamepadRightThumbstick),

        GameInputGamepadLayoutElite =
        Ord(GameInputGamepadLayoutStandard) or Ord(GameInputGamepadModulePaddles4)
        );

    PGameInputGamepadButtons = ^TGameInputGamepadButtons;


    TGameInputRacingWheelButtons = (
        GameInputRacingWheelNone = $00000000,
        GameInputRacingWheelMenu = $00000001,
        GameInputRacingWheelView = $00000002,
        GameInputRacingWheelPreviousGear = $00000004,
        GameInputRacingWheelNextGear = $00000008,
        GameInputRacingWheelA = $00000100,
        GameInputRacingWheelB = $00000200,
        GameInputRacingWheelX = $00000400,
        GameInputRacingWheelY = $00000800,
        GameInputRacingWheelDpadUp = $00000010,
        GameInputRacingWheelDpadDown = $00000020,
        GameInputRacingWheelDpadLeft = $00000040,
        GameInputRacingWheelDpadRight = $00000080,
        GameInputRacingWheelLeftThumbstick = $00001000,
        GameInputRacingWheelRightThumbstick = $00002000);

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
        GameInputUiNavigationScrollRight = $00080000);

    PGameInputUiNavigationButtons = ^TGameInputUiNavigationButtons;


    TGameInputSystemButtons = (
        GameInputSystemButtonNone = $00000000,
        GameInputSystemButtonGuide = $00000001,
        GameInputSystemButtonShare = $00000002);

    PGameInputSystemButtons = ^TGameInputSystemButtons;


    TGameInputFlightStickAxes = (
        GameInputFlightStickAxesNone = $00000000,
        GameInputFlightStickRoll = $00000010,
        GameInputFlightStickPitch = $00000020,
        GameInputFlightStickYaw = $00000040,
        GameInputFlightStickThrottle = $00000080);

    PGameInputFlightStickAxes = ^TGameInputFlightStickAxes;


    TGameInputGamepadAxes = (
        GameInputGamepadAxesNone = $00000000,
        GameInputGamepadLeftTrigger = $00000001,
        GameInputGamepadRightTrigger = $00000002,
        GameInputGamepadLeftThumbstickX = $00000004,
        GameInputGamepadLeftThumbstickY = $00000008,
        GameInputGamepadRightThumbstickX = $00000010,
        GameInputGamepadRightThumbstickY = $00000020);

    PGameInputGamepadAxes = ^TGameInputGamepadAxes;


    TGameInputRacingWheelAxes = (
        GameInputRacingWheelAxesNone = $00000000,
        GameInputRacingWheelSteering = $00000100,
        GameInputRacingWheelThrottle = $00000200,
        GameInputRacingWheelBrake = $00000400,
        GameInputRacingWheelClutch = $00000800,
        GameInputRacingWheelHandbrake = $00001000,
        GameInputRacingWheelPatternShifter = $00002000);

    PGameInputRacingWheelAxes = ^TGameInputRacingWheelAxes;


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
        GameInputDeviceHapticInfoReady = $00200000,
        GameInputDeviceAnyStatus = longint($FFFFFFFF));

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
        GameInputFamilyUnknown = 0,
        GameInputFamilyXboxOne = 1,
        GameInputFamilyXbox360 = 2,
        GameInputFamilyHid = 3,
        GameInputFamilyI8042 = 4,
        GameInputFamilyAggregate = 5);

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
        GameInputLabelPaddleLeft1 = 121,
        GameInputLabelPaddleLeft2 = 122,
        GameInputLabelPaddleRight1 = 123,
        GameInputLabelPaddleRight2 = 124);

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

    IGameInputMapper = interface;
    TGameInputCallbackToken = uint64;
    PGameInputCallbackToken = ^TGameInputCallbackToken;


    TGameInputReadingCallback = procedure(
        {_In_ } callbackToken: TGameInputCallbackToken;
        {_In_ } context: Pvoid;
        {_In_ } reading: IGameInputReading); stdcall;


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
        positions: TGameInputMousePositions;
        positionX: int64;
        positionY: int64;
        absolutePositionX: int64;
        absolutePositionY: int64;
        wheelX: int64;
        wheelY: int64;
    end;
    PGameInputMouseState = ^TGameInputMouseState;


    TGameInputVersion = record
        major: uint16;
        minor: uint16;
        build: uint16;
        revision: uint16;
    end;
    PGameInputVersion = ^TGameInputVersion;


    TGameInputSensorsState = record
        // GameInputSensorsAccelerometer
        accelerationInGX: single;
        accelerationInGY: single;
        accelerationInGZ: single;
        // GameInputSensorsGyrometer
        angularVelocityInRadPerSecX: single;
        angularVelocityInRadPerSecY: single;
        angularVelocityInRadPerSecZ: single;
        // GameInputSensorsCompass
        headingInDegreesFromMagneticNorth: single;
        headingAccuracy: TGameInputSensorAccuracy;
        // GameInputSensorsOrientation
        orientationW: single;
        orientationX: single;
        orientationY: single;
        orientationZ: single;
    end;
    PGameInputSensorsState = ^TGameInputSensorsState;


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


    TGameInputUsage = record
        page: uint16;
        id: uint16;
    end;
    PGameInputUsage = ^TGameInputUsage;


    TGameInputControllerSwitchInfo = record
        labels: array [0..GAMEINPUT_MAX_SWITCH_STATES - 1] of TGameInputLabel;
        kind: TGameInputSwitchKind;
    end;
    PGameInputControllerSwitchInfo = ^TGameInputControllerSwitchInfo;


    TGameInputControllerInfo = record
        controllerAxisCount: uint32;
        {_Field_size_full_(controllerAxisCount) } controllerAxisLabels: PGameInputLabel;
        controllerButtonCount: uint32;
        {_Field_size_full_(controllerButtonCount) } controllerButtonLabels: PGameInputLabel;
        controllerSwitchCount: uint32;
        {_Field_size_full_(controllerSwitchCount) } controllerSwitchInfo: PGameInputControllerSwitchInfo;
    end;
    PGameInputControllerInfo = ^TGameInputControllerInfo;


    TGameInputKeyboardInfo = record
        kind: TGameInputKeyboardKind;
        layout: uint32;
        keyCount: uint32;
        functionKeyCount: uint32;
        maxSimultaneousKeys: uint32;
        platformType: uint32;
        platformSubtype: uint32;
    end;
    PGameInputKeyboardInfo = ^TGameInputKeyboardInfo;


    TGameInputMouseInfo = record
        supportedButtons: TGameInputMouseButtons;
        sampleRate: uint32;
        hasWheelX: boolean;
        hasWheelY: boolean;
    end;
    PGameInputMouseInfo = ^TGameInputMouseInfo;


    TGameInputSensorsInfo = record
        supportedSensors: TGameInputSensorsKind;
    end;
    PGameInputSensorsInfo = ^TGameInputSensorsInfo;


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
        extraButtonCount: uint32;
        extraAxisCount: uint32;
    end;
    PGameInputArcadeStickInfo = ^TGameInputArcadeStickInfo;


    TGameInputFlightStickInfo = record
        menuButtonLabel: TGameInputLabel;
        viewButtonLabel: TGameInputLabel;
        firePrimaryButtonLabel: TGameInputLabel;
        fireSecondaryButtonLabel: TGameInputLabel;
        hatSwitchUpLabel: TGameInputLabel;
        hatSwitchDownLabel: TGameInputLabel;
        hatSwitchLeftLabel: TGameInputLabel;
        hatSwitchRightLabel: TGameInputLabel;
        aButtonLabel: TGameInputLabel;
        bButtonLabel: TGameInputLabel;
        xButtonLabel: TGameInputLabel;
        yButtonLabel: TGameInputLabel;
        leftShoulderButtonLabel: TGameInputLabel;
        rightShoulderButtonLabel: TGameInputLabel;
        extraButtonCount: uint32;
        extraAxisCount: uint32;
    end;
    PGameInputFlightStickInfo = ^TGameInputFlightStickInfo;


    TGameInputGamepadInfo = record
        supportedLayout: TGameInputGamepadButtons;
        menuButtonLabel: TGameInputLabel;
        viewButtonLabel: TGameInputLabel;
        aButtonLabel: TGameInputLabel;
        bButtonLabel: TGameInputLabel;
        cButtonLabel: TGameInputLabel;
        xButtonLabel: TGameInputLabel;
        yButtonLabel: TGameInputLabel;
        zButtonLabel: TGameInputLabel;
        dpadUpLabel: TGameInputLabel;
        dpadDownLabel: TGameInputLabel;
        dpadLeftLabel: TGameInputLabel;
        dpadRightLabel: TGameInputLabel;
        leftShoulderButtonLabel: TGameInputLabel;
        rightShoulderButtonLabel: TGameInputLabel;
        leftThumbstickButtonLabel: TGameInputLabel;
        rightThumbstickButtonLabel: TGameInputLabel;
        extraButtonCount: uint32;
        extraAxisCount: uint32;
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
        aButtonLabel: TGameInputLabel;
        bButtonLabel: TGameInputLabel;
        xButtonLabel: TGameInputLabel;
        yButtonLabel: TGameInputLabel;
        leftThumbstickButtonLabel: TGameInputLabel;
        rightThumbstickButtonLabel: TGameInputLabel;
        hasClutch: boolean;
        hasHandbrake: boolean;
        hasPatternShifter: boolean;
        minPatternShifterGear: int32;
        maxPatternShifterGear: int32;
        maxWheelAngle: single;
        extraButtonCount: uint32;
        extraAxisCount: uint32;
    end;
    PGameInputRacingWheelInfo = ^TGameInputRacingWheelInfo;


    TGameInputForceFeedbackMotorInfo = record
        supportedAxes: TGameInputFeedbackAxes;
        isConstantEffectSupported: boolean;
        isRampEffectSupported: boolean;
        isSineWaveEffectSupported: boolean;
        isSquareWaveEffectSupported: boolean;
        isTriangleWaveEffectSupported: boolean;
        isSawtoothUpWaveEffectSupported: boolean;
        isSawtoothDownWaveEffectSupported: boolean;
        isSpringEffectSupported: boolean;
        isFrictionEffectSupported: boolean;
        isDamperEffectSupported: boolean;
        isInertiaEffectSupported: boolean;
    end;
    PGameInputForceFeedbackMotorInfo = ^TGameInputForceFeedbackMotorInfo;


    TGameInputRawDeviceReportInfo = record
        kind: TGameInputRawDeviceReportKind;
        id: uint32;
        size: uint32;
    end;
    PGameInputRawDeviceReportInfo = ^TGameInputRawDeviceReportInfo;


    TAPP_LOCAL_DEVICE_ID = record
        Value: array [0..APP_LOCAL_DEVICE_ID_SIZE - 1] of byte;
    end;
    PAPP_LOCAL_DEVICE_ID = ^TAPP_LOCAL_DEVICE_ID;

    TGameInputDeviceInfo = record
        vendorId: uint16;
        productId: uint16;
        revisionNumber: uint16;
        usage: TGameInputUsage;
        hardwareVersion: TGameInputVersion;
        firmwareVersion: TGameInputVersion;
        deviceId: TAPP_LOCAL_DEVICE_ID;
        deviceRootId: TAPP_LOCAL_DEVICE_ID;
        deviceFamily: TGameInputDeviceFamily;
        supportedInput: TGameInputKind;
        supportedRumbleMotors: TGameInputRumbleMotors;
        supportedSystemButtons: TGameInputSystemButtons;
        containerId: TGUID;
        displayName: pchar;
        pnpPath: pchar;
        {_Field_size_full_opt_(1) } keyboardInfo: PGameInputKeyboardInfo;
        {_Field_size_full_opt_(1) } mouseInfo: PGameInputMouseInfo;
        {_Field_size_full_opt_(1) } sensorsInfo: PGameInputSensorsInfo;
        {_Field_size_full_opt_(1) } controllerInfo: PGameInputControllerInfo;
        {_Field_size_full_opt_(1) } arcadeStickInfo: PGameInputArcadeStickInfo;
        {_Field_size_full_opt_(1) } flightStickInfo: PGameInputFlightStickInfo;
        {_Field_size_full_opt_(1) } gamepadInfo: PGameInputGamepadInfo;
        {_Field_size_full_opt_(1) } racingWheelInfo: PGameInputRacingWheelInfo;
        forceFeedbackMotorCount: uint32;
        {_Field_size_full_(forceFeedbackMotorCount) } forceFeedbackMotorInfo: PGameInputForceFeedbackMotorInfo;
        inputReportCount: uint32;
        {_Field_size_full_opt_(inputReportCount) } inputReportInfo: PGameInputRawDeviceReportInfo;
        outputReportCount: uint32;
        {_Field_size_full_opt_(outputReportCount) } outputReportInfo: PGameInputRawDeviceReportInfo;
    end;
    PGameInputDeviceInfo = ^TGameInputDeviceInfo;


    TGameInputHapticInfo = record
        {_Field_z_ } audioEndpointId: array [0..GAMEINPUT_HAPTIC_MAX_AUDIO_ENDPOINT_ID_SIZE - 1] of widechar;
        {_Field_range_(1, GAMEINPUT_HAPTIC_MAX_LOCATIONS) } locationCount: uint32;
        {_Field_size_full_(locationCount) } locations: array [0..GAMEINPUT_HAPTIC_MAX_LOCATIONS - 1] of TGUID;
    end;
    PGameInputHapticInfo = ^TGameInputHapticInfo;


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


    TGameInputRumbleParams = record
        lowFrequency: single;
        highFrequency: single;
        leftTrigger: single;
        rightTrigger: single;
    end;
    PGameInputRumbleParams = ^TGameInputRumbleParams;


    TGameInputElementKind = (
        GameInputElementKindNone = 0,
        GameInputElementKindAxis = 1,
        GameInputElementKindButton = 2,
        GameInputElementKindSwitch = 3);

    PGameInputElementKind = ^TGameInputElementKind;


    TGameInputAxisMapping = record
        controllerElementKind: TGameInputElementKind;
        controllerIndex: uint32;
        // When axis is mapped from a axis
        isInverted: winbool;
        // When the axis is mapped from a button
        fromTwoButtons: winbool;
        buttonMinIndexValue: uint32;
        // When the axis is mapped from a switch
        referenceDirection: TGameInputSwitchPosition;
    end;
    PGameInputAxisMapping = ^TGameInputAxisMapping;


    TGameInputButtonMapping = record
        controllerElementKind: TGameInputElementKind;
        controllerIndex: uint32;
        // When the button is mapped from an axis
        isInverted: winbool;
        // Button mapped from button only needs the index
        // When the button is mapped from a switch
        switchPosition: TGameInputSwitchPosition;
    end;
    PGameInputButtonMapping = ^TGameInputButtonMapping;


    IGameInput = interface(IUnknown)
        ['{20EFC1C7-5D9A-43BA-B26F-B807FA48609C}']
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

        function RegisterReadingCallback(
        {_In_opt_ } device: IGameInputDevice;
        {_In_ } inputKind: TGameInputKind;
        {_In_opt_ } context: Pvoid;
        {_In_ } callbackFunc: TGameInputReadingCallback;
        {_Out_opt_ _Result_zeroonfailure_} callbackToken: PGameInputCallbackToken): HRESULT; stdcall;

        function RegisterDeviceCallback(
        {_In_opt_ } device: IGameInputDevice;
        {_In_ } inputKind: TGameInputKind;
        {_In_ } statusFilter: TGameInputDeviceStatus;
        {_In_ } enumerationKind: TGameInputEnumerationKind;
        {_In_opt_ } context: Pvoid;
        {_In_ } callbackFunc: TGameInputDeviceCallback;
        {_Out_opt_ _Result_zeroonfailure_}callbackToken: PGameInputCallbackToken): HRESULT; stdcall;

        function RegisterSystemButtonCallback(
        {_In_opt_ } device: IGameInputDevice;
        {_In_ } buttonFilter: TGameInputSystemButtons;
        {_In_opt_ } context: Pvoid;
        {_In_ } callbackFunc: TGameInputSystemButtonCallback;
        {_Out_opt_ _Result_zeroonfailure_ } callbackToken: PGameInputCallbackToken): HRESULT; stdcall;

        function RegisterKeyboardLayoutCallback(
        {_In_opt_ } device: IGameInputDevice;
        {_In_opt_ } context: Pvoid;
        {_In_ } callbackFunc: TGameInputKeyboardLayoutCallback;
        {_Out_opt_ _Result_zeroonfailure_ } callbackToken: PGameInputCallbackToken): HRESULT; stdcall;

        procedure StopCallback(
        {_In_ } callbackToken: TGameInputCallbackToken); stdcall;

        function UnregisterCallback(
        {_In_ } callbackToken: TGameInputCallbackToken): winbool; stdcall;

        function CreateDispatcher(
        {_COM_Outptr_ }  out dispatcher: IGameInputDispatcher): HRESULT; stdcall;

        function FindDeviceFromId(
        {_In_ } Value: PAPP_LOCAL_DEVICE_ID;
        {_COM_Outptr_ }  out device: IGameInputDevice): HRESULT; stdcall;

        function FindDeviceFromPlatformString(
        {_In_ } Value: LPCWSTR;
        {_COM_Outptr_ }  out device: IGameInputDevice): HRESULT; stdcall;

        procedure SetFocusPolicy(
        {_In_ } policy: TGameInputFocusPolicy); stdcall;

        function CreateAggregateDevice(
        {_In_ } inputKind: TGameInputKind;
        {_Out_ } deviceId: PAPP_LOCAL_DEVICE_ID): HRESULT; stdcall;

        function DisableAggregateDevice(
        {_In_ } deviceId: PAPP_LOCAL_DEVICE_ID): HRESULT; stdcall;

    end;


    IGameInputRawDeviceReport = interface(IUnknown)
        ['{05A42D89-2CB6-45A3-874D-E635723587AB}']
        procedure GetDevice(
        {_Outptr_ }  out device: IGameInputDevice); stdcall;

        procedure GetReportInfo(
        {_Out_ } reportInfo: PGameInputRawDeviceReportInfo); stdcall;

        function GetRawDataSize(): size_t; stdcall;

        function GetRawData(
        {_In_ } bufferSize: size_t;
        {_Out_writes_(bufferSize) } buffer: Pvoid): size_t; stdcall;

        function SetRawData(
        {_In_ } bufferSize: size_t;
        {_In_reads_(bufferSize) } buffer: Pvoid): winbool; stdcall;

    end;


    IGameInputReading = interface(IUnknown)
        ['{C81C4CDE-ED1A-4631-A30F-C556A6241A1F}']
        function GetInputKind(): TGameInputKind; stdcall;

        function GetTimestamp(): uint64; stdcall;

        procedure GetDevice(
        {_Outptr_ }  out device: IGameInputDevice); stdcall;

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

        function GetSensorsState(
        {_Out_ } state: PGameInputSensorsState): winbool; stdcall;

        function GetArcadeStickState(
        {_Out_ } state: PGameInputArcadeStickState): winbool; stdcall;

        function GetFlightStickState(
        {_Out_ } state: PGameInputFlightStickState): winbool; stdcall;

        function GetGamepadState(
        {_Out_ } state: PGameInputGamepadState): winbool; stdcall;

        function GetRacingWheelState(
        {_Out_ } state: PGameInputRacingWheelState): winbool; stdcall;

        function GetRawReport(
        {_Outptr_result_maybenull_ }  out report: IGameInputRawDeviceReport): winbool; stdcall;

    end;


    IGameInputDevice = interface(IUnknown)
        ['{63E2F38B-A399-4275-8AE7-D4C6E524D12A}']
        function GetDeviceInfo(
        {_Outptr_ }  out info: PGameInputDeviceInfo): HRESULT; stdcall;

        function GetHapticInfo(
        {_Out_ } info: PGameInputHapticInfo): HRESULT; stdcall;

        function GetDeviceStatus(): TGameInputDeviceStatus; stdcall;

        function CreateForceFeedbackEffect(
        {_In_ } motorIndex: uint32;
        {_In_ } params: PGameInputForceFeedbackParams;
        {_COM_Outptr_ }  out effect: IGameInputForceFeedbackEffect): HRESULT; stdcall;

        function IsForceFeedbackMotorPoweredOn(
        {_In_ } motorIndex: uint32): winbool; stdcall;

        procedure SetForceFeedbackMotorGain(
        {_In_ } motorIndex: uint32;
        {_In_ } masterGain: single); stdcall;

        procedure SetRumbleState(
        {_In_opt_ } params: PGameInputRumbleParams); stdcall;

        function DirectInputEscape(
        {_In_ } command: uint32;
        {_In_reads_bytes_(bufferInSize) } bufferIn: Pvoid;
        {_In_ } bufferInSize: uint32;
        {_Out_writes_bytes_(bufferOutSize) } bufferOut: Pvoid;
        {_In_ } bufferOutSize: uint32;
        {_Out_opt_ } bufferOutSizeWritten: PUINT32): HRESULT; stdcall;

        function CreateInputMapper(
        {_COM_Outptr_ }  out inputMapper: IGameInputMapper): HRESULT; stdcall;

        function GetExtraAxisCount(
        {_In_ } inputKind: TGameInputKind;
        {_Out_ } extraAxisCount: PUINT32): HRESULT; stdcall;

        function GetExtraButtonCount(
        {_In_ } inputKind: TGameInputKind;
        {_Out_ } extraButtonCount: PUINT32): HRESULT; stdcall;

        function GetExtraAxisIndexes(
        {_In_ } inputKind: TGameInputKind;
        {_In_ } extraAxisCount: uint32;
        {_Out_writes_(extraAxisCount) } extraAxisIndexes: uint8): HRESULT; stdcall;

        function GetExtraButtonIndexes(
        {_In_ } inputKind: TGameInputKind;
        {_In_ } extraButtonCount: uint32;
        {_Out_writes_(extraButtonCount) } extraButtonIndexes: uint8): HRESULT; stdcall;

        function CreateRawDeviceReport(
        {_In_ } reportId: uint32;
        {_In_ } reportKind: TGameInputRawDeviceReportKind;
        {_COM_Outptr_ }  out report: IGameInputRawDeviceReport): HRESULT; stdcall;

        function SendRawDeviceOutput(
        {_In_ } report: IGameInputRawDeviceReport): HRESULT; stdcall;

    end;


    IGameInputDispatcher = interface(IUnknown)
        ['{415EED2E-98CB-42C2-8F28-B94601074E31}']
        function Dispatch(
        {_In_ } quotaInMicroseconds: uint64): winbool; stdcall;

        function OpenWaitHandle(
        {_Outptr_result_nullonfailure_ } waitHandle: PHANDLE): HRESULT; stdcall;

    end;


    IGameInputForceFeedbackEffect = interface(IUnknown)
        ['{FF61096A-3373-4093-A1DF-6D31846B3511}']
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


    IGameInputMapper = interface(IUnknown)
        ['{3C600700-F16C-49CE-9BE6-6A2EF752ED5E}']
        function GetArcadeStickButtonMappingInfo(
        {_In_ } buttonElement: TGameInputArcadeStickButtons;
        {_Out_ } mapping: PGameInputButtonMapping): winbool; stdcall;

        function GetFlightStickAxisMappingInfo(
        {_In_ } axisElement: TGameInputFlightStickAxes;
        {_Out_ } mapping: PGameInputAxisMapping): winbool; stdcall;

        function GetFlightStickButtonMappingInfo(
        {_In_ } buttonElement: TGameInputFlightStickButtons;
        {_Out_ } mapping: PGameInputButtonMapping): winbool; stdcall;

        function GetGamepadAxisMappingInfo(
        {_In_ } axisElement: TGameInputGamepadAxes;
        {_Out_ } mapping: PGameInputAxisMapping): winbool; stdcall;

        function GetGamepadButtonMappingInfo(
        {_In_ } buttonElement: TGameInputGamepadButtons;
        {_Out_ } mapping: PGameInputButtonMapping): winbool; stdcall;

        function GetRacingWheelAxisMappingInfo(
        {_In_ } axisElement: TGameInputRacingWheelAxes;
        {_Out_ } mapping: PGameInputAxisMapping): winbool; stdcall;

        function GetRacingWheelButtonMappingInfo(
        {_In_ } buttonElement: TGameInputRacingWheelButtons;
        {_Out_ } mapping: PGameInputButtonMapping): winbool; stdcall;

    end;


    TGameInputCreateFn = function({_COM_Outptr_} out gameInput: IGameInput): HRESULT;

function GameInputInitialize(
    {_In_}  riid: REFIID;
    {_COM_Outptr_} out ppv): HResult; stdcall; external GameInput_DLL;

function GameInputCreate({_COM_Outptr_} out gameInput: IGameInput): HRESULT; inline;

implementation



function GameInputCreate({_COM_Outptr_} out gameInput: IGameInput): HRESULT; inline;
begin
    Result := GameInputInitialize(@IID_IGameInput, gameInput);
end;


end.
