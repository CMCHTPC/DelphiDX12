unit DX12.D2D1Effects2;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

{$Z4}

uses
    Windows, Classes, SysUtils;

const

    // Built in effect CLSIDs
    CLSID_D2D1Contrast: TGUID = '{b648a78a-0ed5-4f80-a94a-8e825aca6b77}';
    CLSID_D2D1RgbToHue: TGUID = '{23f3e5ec-91e8-4d3d-ad0a-afadc1004aa1}';
    CLSID_D2D1HueToRgb: TGUID = '{7b78a6bd-0141-4def-8a52-6356ee0cbdd5}';
    CLSID_D2D1ChromaKey: TGUID = '{74C01F5B-2A0D-408C-88E2-C7A3C7197742}';
    CLSID_D2D1Emboss: TGUID = '{b1c5eb2b-0348-43f0-8107-4957cacba2ae}';
    CLSID_D2D1Exposure: TGUID = '{b56c8cfa-f634-41ee-bee0-ffa617106004}';
    CLSID_D2D1Grayscale: TGUID = '{36DDE0EB-3725-42E0-836D-52FB20AEE644}';
    CLSID_D2D1Invert: TGUID = '{e0c3784d-cb39-4e84-b6fd-6b72f0810263}';
    CLSID_D2D1Posterize: TGUID = '{2188945e-33a3-4366-b7bc-086bd02d0884}';
    CLSID_D2D1Sepia: TGUID = '{3a1af410-5f1d-4dbe-84df-915da79b7153}';
    CLSID_D2D1Sharpen: TGUID = '{C9B887CB-C5FF-4DC5-9779-273DCF417C7D}';
    CLSID_D2D1Straighten: TGUID = '{4da47b12-79a3-4fb0-8237-bbc3b2a4de08}';
    CLSID_D2D1TemperatureTint: TGUID = '{89176087-8AF9-4A08-AEB1-895F38DB1766}';
    CLSID_D2D1Vignette: TGUID = '{c00c40be-5e67-4ca3-95b4-f4b02c115135}';
    CLSID_D2D1EdgeDetection: TGUID = '{EFF583CA-CB07-4AA9-AC5D-2CC44C76460F}';
    CLSID_D2D1HighlightsShadows: TGUID = '{CADC8384-323F-4C7E-A361-2E2B24DF6EE4}';
    CLSID_D2D1LookupTable3D: TGUID = '{349E0EDA-0088-4A79-9CA3-C7E300202020}';
    CLSID_D2D1Opacity: TGUID = '{811d79a4-de28-4454-8094-c64685f8bd4c}';
    CLSID_D2D1AlphaMask: TGUID = '{c80ecff0-3fd5-4f05-8328-c5d1724b4f0a}';
    CLSID_D2D1CrossFade: TGUID = '{12f575e8-4db1-485f-9a84-03a07dd3829f}';
    CLSID_D2D1Tint: TGUID = '{36312b17-f7dd-4014-915d-ffca768cf211}';

    // The number of nits that sRGB or scRGB color space uses for SDR white, or
    // floating point values of 1.0f. Note that this value is only constant when the
    // color space uses scene-referred luminance, which is true for HDR content. If
    // the color space uses display-referred luminance instead, then the SDR white
    // level should be queried from the display.
    D2D1_SCENE_REFERRED_SDR_WHITE_LEVEL = 80.0;

    //{$IF NTDDI_VERSION >= NTDDI_WIN10_RS5}

    CLSID_D2D1WhiteLevelAdjustment: TGUID = '{44a1cadb-6cdd-4818-8ff4-26c1cfe95bdb}';
    CLSID_D2D1HdrToneMap: TGUID = '{7b0b748d-4610-4486-a90c-999d9a2e2b11}';

//{$endif} // #if NTDDI_VERSION >= NTDDI_WIN10_RS5



type
    TD2D1_CONTRAST_PROP = (
        // Property Name: "Contrast"
        // Property Type: FLOAT
        D2D1_CONTRAST_PROP_CONTRAST = 0,
        // Property Name: "ClampInput"
        // Property Type: BOOL
        D2D1_CONTRAST_PROP_CLAMP_INPUT = 1,
        D2D1_CONTRAST_PROP_FORCE_DWORD = $ffffffff);

    TD2D1_RGBTOHUE_PROP = (
        // Property Name: "OutputColorSpace"
        // Property Type: D2D1_RGBTOHUE_OUTPUT_COLOR_SPACE
        D2D1_RGBTOHUE_PROP_OUTPUT_COLOR_SPACE = 0,
        D2D1_RGBTOHUE_PROP_FORCE_DWORD = $ffffffff);


    TD2D1_RGBTOHUE_OUTPUT_COLOR_SPACE = (
        D2D1_RGBTOHUE_OUTPUT_COLOR_SPACE_HUE_SATURATION_VALUE = 0,
        D2D1_RGBTOHUE_OUTPUT_COLOR_SPACE_HUE_SATURATION_LIGHTNESS = 1,
        D2D1_RGBTOHUE_OUTPUT_COLOR_SPACE_FORCE_DWORD = $ffffffff);


    TD2D1_HUETORGB_PROP = (

        // Property Name: "InputColorSpace"
        // Property Type: D2D1_HUETORGB_INPUT_COLOR_SPACE

        D2D1_HUETORGB_PROP_INPUT_COLOR_SPACE = 0,
        D2D1_HUETORGB_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_HUETORGB_INPUT_COLOR_SPACE = (
        D2D1_HUETORGB_INPUT_COLOR_SPACE_HUE_SATURATION_VALUE = 0,
        D2D1_HUETORGB_INPUT_COLOR_SPACE_HUE_SATURATION_LIGHTNESS = 1,
        D2D1_HUETORGB_INPUT_COLOR_SPACE_FORCE_DWORD = $ffffffff
        );


    TD2D1_CHROMAKEY_PROP = (

        // Property Name: "Color"
        // Property Type: D2D1_VECTOR_3F

        D2D1_CHROMAKEY_PROP_COLOR = 0,

        // Property Name: "Tolerance"
        // Property Type: FLOAT

        D2D1_CHROMAKEY_PROP_TOLERANCE = 1,

        // Property Name: "InvertAlpha"
        // Property Type: BOOL

        D2D1_CHROMAKEY_PROP_INVERT_ALPHA = 2,

        // Property Name: "Feather"
        // Property Type: BOOL

        D2D1_CHROMAKEY_PROP_FEATHER = 3,
        D2D1_CHROMAKEY_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_EMBOSS_PROP = (

        // Property Name: "Height"
        // Property Type: FLOAT

        D2D1_EMBOSS_PROP_HEIGHT = 0,

        // Property Name: "Direction"
        // Property Type: FLOAT

        D2D1_EMBOSS_PROP_DIRECTION = 1,
        D2D1_EMBOSS_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_EXPOSURE_PROP = (

        // Property Name: "ExposureValue"
        // Property Type: FLOAT

        D2D1_EXPOSURE_PROP_EXPOSURE_VALUE = 0,
        D2D1_EXPOSURE_PROP_FORCE_DWORD = $ffffffff
        );

    TD2D1_POSTERIZE_PROP = (

        // Property Name: "RedValueCount"
        // Property Type: UINT32

        D2D1_POSTERIZE_PROP_RED_VALUE_COUNT = 0,

        // Property Name: "GreenValueCount"
        // Property Type: UINT32

        D2D1_POSTERIZE_PROP_GREEN_VALUE_COUNT = 1,

        // Property Name: "BlueValueCount"
        // Property Type: UINT32

        D2D1_POSTERIZE_PROP_BLUE_VALUE_COUNT = 2,
        D2D1_POSTERIZE_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_SEPIA_PROP = (

        // Property Name: "Intensity"
        // Property Type: FLOAT

        D2D1_SEPIA_PROP_INTENSITY = 0,

        // Property Name: "AlphaMode"
        // Property Type: D2D1_ALPHA_MODE

        D2D1_SEPIA_PROP_ALPHA_MODE = 1,
        D2D1_SEPIA_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_SHARPEN_PROP = (

        // Property Name: "Sharpness"
        // Property Type: FLOAT

        D2D1_SHARPEN_PROP_SHARPNESS = 0,

        // Property Name: "Threshold"
        // Property Type: FLOAT

        D2D1_SHARPEN_PROP_THRESHOLD = 1,
        D2D1_SHARPEN_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_STRAIGHTEN_PROP = (

        // Property Name: "Angle"
        // Property Type: FLOAT

        D2D1_STRAIGHTEN_PROP_ANGLE = 0,

        // Property Name: "MaintainSize"
        // Property Type: BOOL

        D2D1_STRAIGHTEN_PROP_MAINTAIN_SIZE = 1,

        // Property Name: "ScaleMode"
        // Property Type: D2D1_STRAIGHTEN_SCALE_MODE

        D2D1_STRAIGHTEN_PROP_SCALE_MODE = 2,
        D2D1_STRAIGHTEN_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_STRAIGHTEN_SCALE_MODE = (
        D2D1_STRAIGHTEN_SCALE_MODE_NEAREST_NEIGHBOR = 0,
        D2D1_STRAIGHTEN_SCALE_MODE_LINEAR = 1,
        D2D1_STRAIGHTEN_SCALE_MODE_CUBIC = 2,
        D2D1_STRAIGHTEN_SCALE_MODE_MULTI_SAMPLE_LINEAR = 3,
        D2D1_STRAIGHTEN_SCALE_MODE_ANISOTROPIC = 4,
        D2D1_STRAIGHTEN_SCALE_MODE_FORCE_DWORD = $ffffffff
        );


    TD2D1_TEMPERATUREANDTINT_PROP = (

        // Property Name: "Temperature"
        // Property Type: FLOAT

        D2D1_TEMPERATUREANDTINT_PROP_TEMPERATURE = 0,

        // Property Name: "Tint"
        // Property Type: FLOAT

        D2D1_TEMPERATUREANDTINT_PROP_TINT = 1,
        D2D1_TEMPERATUREANDTINT_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_VIGNETTE_PROP = (

        // Property Name: "Color"
        // Property Type: D2D1_VECTOR_4F

        D2D1_VIGNETTE_PROP_COLOR = 0,

        // Property Name: "TransitionSize"
        // Property Type: FLOAT

        D2D1_VIGNETTE_PROP_TRANSITION_SIZE = 1,

        // Property Name: "Strength"
        // Property Type: FLOAT

        D2D1_VIGNETTE_PROP_STRENGTH = 2,
        D2D1_VIGNETTE_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_EDGEDETECTION_PROP = (

        // Property Name: "Strength"
        // Property Type: FLOAT

        D2D1_EDGEDETECTION_PROP_STRENGTH = 0,

        // Property Name: "BlurRadius"
        // Property Type: FLOAT

        D2D1_EDGEDETECTION_PROP_BLUR_RADIUS = 1,

        // Property Name: "Mode"
        // Property Type: D2D1_EDGEDETECTION_MODE

        D2D1_EDGEDETECTION_PROP_MODE = 2,

        // Property Name: "OverlayEdges"
        // Property Type: BOOL

        D2D1_EDGEDETECTION_PROP_OVERLAY_EDGES = 3,

        // Property Name: "AlphaMode"
        // Property Type: D2D1_ALPHA_MODE

        D2D1_EDGEDETECTION_PROP_ALPHA_MODE = 4,
        D2D1_EDGEDETECTION_PROP_FORCE_DWORD = $ffffffff
        );

    TD2D1_EDGEDETECTION_MODE = (
        D2D1_EDGEDETECTION_MODE_SOBEL = 0,
        D2D1_EDGEDETECTION_MODE_PREWITT = 1,
        D2D1_EDGEDETECTION_MODE_FORCE_DWORD = $ffffffff
        );


    TD2D1_HIGHLIGHTSANDSHADOWS_PROP = (

        // Property Name: "Highlights"
        // Property Type: FLOAT

        D2D1_HIGHLIGHTSANDSHADOWS_PROP_HIGHLIGHTS = 0,

        // Property Name: "Shadows"
        // Property Type: FLOAT

        D2D1_HIGHLIGHTSANDSHADOWS_PROP_SHADOWS = 1,

        // Property Name: "Clarity"
        // Property Type: FLOAT

        D2D1_HIGHLIGHTSANDSHADOWS_PROP_CLARITY = 2,

        // Property Name: "InputGamma"
        // Property Type: D2D1_HIGHLIGHTSANDSHADOWS_INPUT_GAMMA

        D2D1_HIGHLIGHTSANDSHADOWS_PROP_INPUT_GAMMA = 3,

        // Property Name: "MaskBlurRadius"
        // Property Type: FLOAT

        D2D1_HIGHLIGHTSANDSHADOWS_PROP_MASK_BLUR_RADIUS = 4,
        D2D1_HIGHLIGHTSANDSHADOWS_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_HIGHLIGHTSANDSHADOWS_INPUT_GAMMA = (
        D2D1_HIGHLIGHTSANDSHADOWS_INPUT_GAMMA_LINEAR = 0,
        D2D1_HIGHLIGHTSANDSHADOWS_INPUT_GAMMA_SRGB = 1,
        D2D1_HIGHLIGHTSANDSHADOWS_INPUT_GAMMA_FORCE_DWORD = $ffffffff
        );

    TD2D1_LOOKUPTABLE3D_PROP = (

        // Property Name: "Lut"
        // Property Type: IUnknown *

        D2D1_LOOKUPTABLE3D_PROP_LUT = 0,

        // Property Name: "AlphaMode"
        // Property Type: D2D1_ALPHA_MODE

        D2D1_LOOKUPTABLE3D_PROP_ALPHA_MODE = 1,
        D2D1_LOOKUPTABLE3D_PROP_FORCE_DWORD = $ffffffff);




    // if NTDDI_VERSION >= NTDDI_WIN10_RS1

    TD2D1_OPACITY_PROP = (
        D2D1_OPACITY_PROP_OPACITY = 0,
        D2D1_OPACITY_PROP_FORCE_DWORD = $ffffffff);



    TD2D1_CROSSFADE_PROP = (
        D2D1_CROSSFADE_PROP_WEIGHT = 0,
        D2D1_CROSSFADE_PROP_FORCE_DWORD = $ffffffff
        );


    TD2D1_TINT_PROP = (
        D2D1_TINT_PROP_COLOR = 0,
        D2D1_TINT_PROP_CLAMP_OUTPUT = 1,
        D2D1_TINT_PROP_FORCE_DWORD = $ffffffff
        );


// endif // #if NTDDI_VERSION >= NTDDI_WIN10_RS1


    //{$if NTDDI_VERSION >= NTDDI_WIN10_RS5}

    /// The enumeration of the White Level Adjustment effect's top level properties.
    /// Effect description: This effect adjusts the white level of the source image by
    /// multiplying the source image color by the ratio of the input and output white
    /// levels. Input and output white levels are specified in nits.
    TD2D1_WHITELEVELADJUSTMENT_PROP = (
        /// Property Name: "InputWhiteLevel"
        /// Property Type: FLOAT
        D2D1_WHITELEVELADJUSTMENT_PROP_INPUT_WHITE_LEVEL = 0,
        /// Property Name: "OutputWhiteLevel"
        /// Property Type: FLOAT
        D2D1_WHITELEVELADJUSTMENT_PROP_OUTPUT_WHITE_LEVEL = 1,
        D2D1_WHITELEVELADJUSTMENT_PROP_FORCE_DWORD = $ffffffff
        );
    PD2D1_WHITELEVELADJUSTMENT_PROP = ^TD2D1_WHITELEVELADJUSTMENT_PROP;


    /// The enumeration of the HDR Tone Map effect's top level properties.
    /// Effect description: Adjusts the maximum luminance of the source image to fit
    /// within the maximum output luminance supported. Input and output luminance values
    /// are specified in nits. Note that the color space of the image is assumed to be
    /// scRGB.
    TD2D1_HDRTONEMAP_PROP = (
        /// Property Name: "InputMaxLuminance"
        /// Property Type: FLOAT
        D2D1_HDRTONEMAP_PROP_INPUT_MAX_LUMINANCE = 0,
        /// Property Name: "OutputMaxLuminance"
        /// Property Type: FLOAT
        D2D1_HDRTONEMAP_PROP_OUTPUT_MAX_LUMINANCE = 1,
        /// Property Name: "DisplayMode"
        /// Property Type: D2D1_HDRTONEMAP_DISPLAY_MODE
        D2D1_HDRTONEMAP_PROP_DISPLAY_MODE = 2,
        D2D1_HDRTONEMAP_PROP_FORCE_DWORD = $ffffffff
        );
    PD2D1_HDRTONEMAP_PROP = ^TD2D1_HDRTONEMAP_PROP;

    TD2D1_HDRTONEMAP_DISPLAY_MODE = (
        D2D1_HDRTONEMAP_DISPLAY_MODE_SDR = 0,
        D2D1_HDRTONEMAP_DISPLAY_MODE_HDR = 1,
        D2D1_HDRTONEMAP_DISPLAY_MODE_FORCE_DWORD = $ffffffff
        );
    PD2D1_HDRTONEMAP_DISPLAY_MODE = ^TD2D1_HDRTONEMAP_DISPLAY_MODE;

//{$endif}

implementation

end.















