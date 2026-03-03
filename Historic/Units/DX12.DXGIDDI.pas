{*==========================================================================;
 *
 *  Copyright (C) Microsoft Corporation.  All Rights Reserved.
 *
 *  Content: DXGI Basic Device Driver Interface Definitions
 *
 ***************************************************************************}

unit DX12.DXGIDDI;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils, DX12.DXGI,
    DX12.D3DCommon,
    DX12.D3DUKMDT;




//--------------------------------------------------------------------------------------------------------
// DXGI error codes
//--------------------------------------------------------------------------------------------------------
const
    _FACDXGI_DDI = $87b;
{#define MAKE_DXGI_DDI_HRESULT( code )  MAKE_HRESULT( 1, _FACDXGI_DDI, code )
#define MAKE_DXGI_DDI_STATUS( code )   MAKE_HRESULT( 0, _FACDXGI_DDI, code ) }

// DXGI DDI error codes have moved to winerror.h

// Bit indicates that UMD has the option to prevent this Resource from ever being a Primary
// UMD can prevent the actual flip (from optional primary to regular primary) and use a copy
// operation, during Present. Thus, it's possible the UMD can opt out of this Resource being
// actually used as a primary.
const
    DXGI_DDI_PRIMARY_OPTIONAL = $1;

    // Bit indicates that the Primary really represents the IDENTITY rotation, eventhough it will
    // be used with non-IDENTITY display modes, since the application will take on the burden of
    // honoring the output orientation by rotating, say the viewport and projection matrix.
    DXGI_DDI_PRIMARY_NONPREROTATED = $2;


    // Bit indicates that the primary is stereoscopic.
    DXGI_DDI_PRIMARY_STEREO = $4;

    // Bit indicates that this primary will be used for indirect presentation
    DXGI_DDI_PRIMARY_INDIRECT = $8;


    // Bit indicates that the driver cannot tolerate setting any subresource of the specified
    // resource as a primary. The UMD should set this bit at resource creation time if it
    // chooses to implement presentation from this surface via a copy operation. The DXGI
    // runtime will not employ flip-style presentation if this bit is set
    DXGI_DDI_PRIMARY_DRIVER_FLAG_NO_SCANOUT = $1;

const
    DXGI_DDI_MAX_MULTIPLANE_OVERLAY_ALLOCATIONS = 16;



//========================================================================================================
// This is the standard DDI that any DXGI-enabled user-mode driver should support


//--------------------------------------------------------------------------------------------------------
type
    TDXGI_DDI_HDEVICE = UINT_PTR;
    PDXGI_DDI_HDEVICE = ^TDXGI_DDI_HDEVICE;
    TDXGI_DDI_HRESOURCE = UINT_PTR;
    PDXGI_DDI_HRESOURCE = ^TDXGI_DDI_HRESOURCE;
    TD3DKMT_HANDLE = THANDLE; // ToDo

    //--------------------------------------------------------------------------------------------------------
    TDXGI_DDI_RESIDENCY = (
        DXGI_DDI_RESIDENCY_FULLY_RESIDENT = 1,
        DXGI_DDI_RESIDENCY_RESIDENT_IN_SHARED_MEMORY = 2,
        DXGI_DDI_RESIDENCY_EVICTED_TO_DISK = 3);
    PDXGI_DDI_RESIDENCY = ^TDXGI_DDI_RESIDENCY;

    //--------------------------------------------------------------------------------------------------------
    TDXGI_DDI_FLIP_INTERVAL_TYPE = (
        DXGI_DDI_FLIP_INTERVAL_IMMEDIATE = 0,
        DXGI_DDI_FLIP_INTERVAL_ONE = 1,
        DXGI_DDI_FLIP_INTERVAL_TWO = 2,
        DXGI_DDI_FLIP_INTERVAL_THREE = 3,
        DXGI_DDI_FLIP_INTERVAL_FOUR = 4,
        // For the sync interval override in the present callbacks, IMMEDIATE means the API
        // semantic of sync interval 0, where IMMEDIATE_ALLOW_TEARING is equivalent to the addition
        // of the ALLOW_TEARING API flags.
        DXGI_DDI_FLIP_INTERVAL_IMMEDIATE_ALLOW_TEARING = 5);
    PDXGI_DDI_FLIP_INTERVAL_TYPE = ^TDXGI_DDI_FLIP_INTERVAL_TYPE;

    //--------------------------------------------------------------------------------------------------------
    TDXGI_DDI_PRESENT_FLAGS = record
        case integer of
            0: (
                Blt: Unsigned_Bits1;        // $00000001
                Flip: Unsigned_Bits1;        // $00000002
                PreferRight: Unsigned_Bits1;        // $00000004
                TemporaryMono: Unsigned_Bits1;        // $00000008
                AllowTearing: Unsigned_Bits1;        // 0x00000010
                AllowFlexibleRefresh: Unsigned_Bits1;        // 0x00000020
                Reserved: Unsigned_Bits26;
            );
            1: (Value: UINT);

    end;
    PDXGI_DDI_PRESENT_FLAGS = ^TDXGI_DDI_PRESENT_FLAGS;

    //--------------------------------------------------------------------------------------------------------
    TDXGI_DDI_ARG_PRESENT = record
        hDevice: TDXGI_DDI_HDEVICE;             //in
        hSurfaceToPresent: TDXGI_DDI_HRESOURCE;   //in
        SrcSubResourceIndex: UINT; // Index of surface level
        hDstResource: TDXGI_DDI_HRESOURCE;        // if non-zero, it's the destination of the present
        DstSubResourceIndex: UINT; // Index of surface level
        pDXGIContext: pointer;        // opaque: Pass this to the Present callback
        Flags: TDXGI_DDI_PRESENT_FLAGS;               // Presentation flags.
        FlipInterval: TDXGI_DDI_FLIP_INTERVAL_TYPE;        // Presentation interval (flip only)
    end;
    PDXGI_DDI_ARG_PRESENT = ^TDXGI_DDI_ARG_PRESENT;

    //--------------------------------------------------------------------------------------------------------
    TDXGI_DDI_ARG_ROTATE_RESOURCE_IDENTITIES = record
        hDevice: TDXGI_DDI_HDEVICE; //in
        pResources: PDXGI_DDI_HRESOURCE; //in: Array of Resources to rotate identities; 0 <= 1, 1 <= 2, etc.
        Resources: UINT;
    end;
    PDXGI_DDI_ARG_ROTATE_RESOURCE_IDENTITIES = ^TDXGI_DDI_ARG_ROTATE_RESOURCE_IDENTITIES;

    TDXGI_DDI_ARG_GET_GAMMA_CONTROL_CAPS = record
        hDevice: TDXGI_DDI_HDEVICE;            //in
        pGammaCapabilities: PDXGI_GAMMA_CONTROL_CAPABILITIES; //in/out
    end;
    PDXGI_DDI_ARG_GET_GAMMA_CONTROL_CAPS = ^TDXGI_DDI_ARG_GET_GAMMA_CONTROL_CAPS;

    TDXGI_DDI_ARG_SET_GAMMA_CONTROL = record
        hDevice: TDXGI_DDI_HDEVICE;            //in
        GammaControl: TDXGI_GAMMA_CONTROL;       //in
    end;
    PDXGI_DDI_ARG_SET_GAMMA_CONTROL = ^TDXGI_DDI_ARG_SET_GAMMA_CONTROL;

    TDXGI_DDI_ARG_SETDISPLAYMODE = record
        hDevice: TDXGI_DDI_HDEVICE;                //in
        hResource: TDXGI_DDI_HRESOURCE;              // Source surface
        SubResourceIndex: UINT;       // Index of surface level
    end;
    PDXGI_DDI_ARG_SETDISPLAYMODE = ^TDXGI_DDI_ARG_SETDISPLAYMODE;

    TDXGI_DDI_ARG_SETRESOURCEPRIORITY = record
        hDevice: TDXGI_DDI_HDEVICE;                //in
        hResource: TDXGI_DDI_HRESOURCE;              //in
        Priority: UINT;               //in
    end;
    PDXGI_DDI_ARG_SETRESOURCEPRIORITY = ^TDXGI_DDI_ARG_SETRESOURCEPRIORITY;

    TDXGI_DDI_ARG_QUERYRESOURCERESIDENCY = record
        hDevice: TDXGI_DDI_HDEVICE;                //in
        pResources: PDXGI_DDI_HRESOURCE;             //in
        pStatus: PDXGI_DDI_RESIDENCY;                //out
        Resources: SIZE_T;              //in
    end;
    PDXGI_DDI_ARG_QUERYRESOURCERESIDENCY = ^TDXGI_DDI_ARG_QUERYRESOURCERESIDENCY;

    //--------------------------------------------------------------------------------------------------------
    // Remarks: Fractional value used to represent vertical and horizontal frequencies of a video mode
    //          (i.e. VSync and HSync). Vertical frequencies are stored in Hz. Horizontal frequencies
    //          are stored in KHz.
    //          The dynamic range of this encoding format, given 10^-7 resolution is {0..(2^32 - 1) / 10^7},
    //          which translates to {0..428.4967296} [Hz] for vertical frequencies and {0..428.4967296} [KHz]
    //          for horizontal frequencies. This sub-microseconds precision range should be acceptable even
    //          for a pro-video application (error in one microsecond for video signal synchronization would
    //          imply a time drift with a cycle of 10^7/(60*60*24) = 115.741 days.

    //          If rational number with a finite fractional sequence, use denominator of form 10^(length of fractional sequence).
    //          If rational number without a finite fractional sequence, or a sequence exceeding the precision allowed by the
    //          dynamic range of the denominator, or an irrational number, use an appropriate ratio of integers which best
    //          represents the value.

    TDXGI_DDI_RATIONAL = record
        Numerator: UINT;
        Denominator: UINT;
    end;
    PDXGI_DDI_RATIONAL = ^TDXGI_DDI_RATIONAL;

    //--------------------------------------------------------------------------------------------------------
    TDXGI_DDI_MODE_SCANLINE_ORDER = (
        DXGI_DDI_MODE_SCANLINE_ORDER_UNSPECIFIED = 0,
        DXGI_DDI_MODE_SCANLINE_ORDER_PROGRESSIVE = 1,
        DXGI_DDI_MODE_SCANLINE_ORDER_UPPER_FIELD_FIRST = 2,
        DXGI_DDI_MODE_SCANLINE_ORDER_LOWER_FIELD_FIRST = 3);
    PDXGI_DDI_MODE_SCANLINE_ORDER = ^TDXGI_DDI_MODE_SCANLINE_ORDER;

    TDXGI_DDI_MODE_SCALING = (
        DXGI_DDI_MODE_SCALING_UNSPECIFIED = 0,
        DXGI_DDI_MODE_SCALING_STRETCHED = 1,
        DXGI_DDI_MODE_SCALING_CENTERED = 2);
    PDXGI_DDI_MODE_SCALING = ^TDXGI_DDI_MODE_SCALING;

    TDXGI_DDI_MODE_ROTATION = (
        DXGI_DDI_MODE_ROTATION_UNSPECIFIED = 0,
        DXGI_DDI_MODE_ROTATION_IDENTITY = 1,
        DXGI_DDI_MODE_ROTATION_ROTATE90 = 2,
        DXGI_DDI_MODE_ROTATION_ROTATE180 = 3,
        DXGI_DDI_MODE_ROTATION_ROTATE270 = 4);
    PDXGI_DDI_MODE_ROTATION = ^TDXGI_DDI_MODE_ROTATION;

    TDXGI_DDI_MODE_DESC = record
        Width: UINT;
        Height: UINT;
        Format: TDXGI_FORMAT;
        RefreshRate: TDXGI_DDI_RATIONAL;
        ScanlineOrdering: TDXGI_DDI_MODE_SCANLINE_ORDER;
        Rotation: TDXGI_DDI_MODE_ROTATION;
        Scaling: TDXGI_DDI_MODE_SCALING;
    end;
    PDXGI_DDI_MODE_DESC = ^TDXGI_DDI_MODE_DESC;


    TDXGI_DDI_PRIMARY_DESC = record
        Flags: UINT;            // [in]
        VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID;    // [in]
        ModeDesc: TDXGI_DDI_MODE_DESC;        // [in]
        DriverFlags: UINT;        // [out] Filled by the driver
    end;
    PDXGI_DDI_PRIMARY_DESC = ^TDXGI_DDI_PRIMARY_DESC;


    TDXGI_DDI_ARG_BLT_FLAGS = record
        case integer of
            0: (Resolve: Unsigned_Bits1;     // $00000001
                Convert: Unsigned_Bits1;     // $00000002
                Stretch: Unsigned_Bits1;     // $00000004
                Present: Unsigned_Bits1;     // $00000008
                Reserved: Unsigned_Bits28;
            );
            1: (Value: UINT);
    end;
    PDXGI_DDI_ARG_BLT_FLAGS = ^TDXGI_DDI_ARG_BLT_FLAGS;




    TDXGI_DDI_ARG_BLT = record
        hDevice: TDXGI_DDI_HDEVICE;                //in
        hDstResource: TDXGI_DDI_HRESOURCE;           //in
        DstSubresource: UINT;         //in
        DstLeft: UINT;                //in
        DstTop: UINT;                 //in
        DstRight: UINT;               //in
        DstBottom: UINT;              //in
        hSrcResource: TDXGI_DDI_HRESOURCE;           //in
        SrcSubresource: UINT;         //in
        Flags: TDXGI_DDI_ARG_BLT_FLAGS;                  //in
        Rotate: TDXGI_DDI_MODE_ROTATION;                 //in
    end;
    PDXGI_DDI_ARG_BLT = ^TDXGI_DDI_ARG_BLT;

    TDXGI_DDI_ARG_RESOLVESHAREDRESOURCE = record
        hDevice: TDXGI_DDI_HDEVICE;                //in
        hResource: TDXGI_DDI_HRESOURCE;              //in
    end;
    PDXGI_DDI_ARG_RESOLVESHAREDRESOURCE = ^TDXGI_DDI_ARG_RESOLVESHAREDRESOURCE;

{$IF (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WIN8)}
    TDXGI_DDI_ARG_BLT1 = record
        hDevice: TDXGI_DDI_HDEVICE;                //in
        hDstResource: TDXGI_DDI_HRESOURCE;           //in
        DstSubresource: UINT;         //in
        DstLeft: UINT;                //in
        DstTop: UINT;                 //in
        DstRight: UINT;               //in
        DstBottom: UINT;              //in
        hSrcResource: TDXGI_DDI_HRESOURCE;           //in
        SrcSubresource: UINT;         //in
        SrcLeft: UINT;                //in
        SrcTop: UINT;                 //in
        SrcRight: UINT;               //in
        SrcBottom: UINT;              //in
        Flags: TDXGI_DDI_ARG_BLT_FLAGS;                  //in
        Rotate: TDXGI_DDI_MODE_ROTATION;                 //in
    end;
    PDXGI_DDI_ARG_BLT1 = ^TDXGI_DDI_ARG_BLT1;

    TDXGI_DDI_ARG_OFFERRESOURCES = record
        hDevice: TDXGI_DDI_HDEVICE;                           //in:  device that created the resources
        pResources: PDXGI_DDI_HRESOURCE;               //in:  array of resources to reset
        Resources: UINT;                                     //in:  number of elements in pResources
        Priority: TD3DDDI_OFFER_PRIORITY;                     //in:  priority with which to reset the resources
    end;
    PDXGI_DDI_ARG_OFFERRESOURCES = ^TDXGI_DDI_ARG_OFFERRESOURCES;

    TDXGI_DDI_ARG_RECLAIMRESOURCES = record
        hDevice: TDXGI_DDI_HDEVICE;                           //in:  device that created the resources
        pResources: PDXGI_DDI_HRESOURCE;               //in:  array of resources to reset
        pDiscarded: PBOOLean;                                   //out: optional array of booleans specifying whether each resource was discarded
        Resources: UINT;                                     //in:  number of elements in pResources and pDiscarded
    end;
    PDXGI_DDI_ARG_RECLAIMRESOURCES = ^TDXGI_DDI_ARG_RECLAIMRESOURCES;

    //-----------------------------------------------------------------------------------------------------------
    // Multi Plane Overlay DDI


    TDXGI_DDI_MULTIPLANE_OVERLAY_CAPS = record
        MaxPlanes: UINT;                  // Total number of planes supported (including the DWM's primary)
        NumCapabilityGroups: UINT;        // Number of plane types supported.
    end;
    PDXGI_DDI_MULTIPLANE_OVERLAY_CAPS = ^TDXGI_DDI_MULTIPLANE_OVERLAY_CAPS;


    TDXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS = (
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_ROTATION_WITHOUT_INDEPENDENT_FLIP = $1,
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_VERTICAL_FLIP = $2,
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_HORIZONTAL_FLIP = $4,
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_DEINTERLACE = $8,
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_STEREO = $10,    // D3D10 or above only.
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_RGB = $20,
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_YUV = $40,
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_BILINEAR_FILTER = $80,    // Can do bilinear stretching
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_HIGH_FILTER = $100,   // Can do better than bilinear stretching
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_ROTATION = $200,
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_FULLSCREEN_POST_COMPOSITION = $400,
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_RESERVED1 = $800,
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_SHARED = $1000,
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_IMMEDIATE = $2000,
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_PLANE0_FOR_VIRTUAL_MODE_ONLY = $4000);
    PDXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS = ^TDXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS;

    TDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_CAPS = (
        DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_CAPS_SEPARATE = $1,
        DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_CAPS_ROW_INTERLEAVED = $4,
        DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_CAPS_COLUMN_INTERLEAVED = $8,
        DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_CAPS_CHECKERBOARD = $10,
        DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_CAPS_FLIP_MODE = $20);
    PDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_CAPS = ^TDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_CAPS;

    TDXGI_DDI_MULTIPLANE_OVERLAY_GROUP_CAPS = record
        NumPlanes: UINT;
        MaxStretchFactor: single;
        MaxShrinkFactor: single;
        OverlayCaps: UINT;       // DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS
        StereoCaps: UINT;        // DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_CAPS
    end;
    PDXGI_DDI_MULTIPLANE_OVERLAY_GROUP_CAPS = ^TDXGI_DDI_MULTIPLANE_OVERLAY_GROUP_CAPS;

    TDXGI_DDI_MULTIPLANE_OVERLAY_FLAGS = (
        DXGI_DDI_MULTIPLANE_OVERLAY_FLAG_VERTICAL_FLIP = $1,
        DXGI_DDI_MULTIPLANE_OVERLAY_FLAG_HORIZONTAL_FLIP = $2,
        DXGI_DDI_MULTIPLANE_OVERLAY_FLAG_FULLSCREEN_POST_COMPOSITION = $4);
    PDXGI_DDI_MULTIPLANE_OVERLAY_FLAGS = ^TDXGI_DDI_MULTIPLANE_OVERLAY_FLAGS;

    TDXGI_DDI_MULTIPLANE_OVERLAY_BLEND = (
        DXGI_DDI_MULTIPLANE_OVERLAY_BLEND_OPAQUE = $0,
        DXGI_DDI_MULTIPLANE_OVERLAY_BLEND_ALPHABLEND = $1
        );
    PDXGI_DDI_MULTIPLANE_OVERLAY_BLEND = ^TDXGI_DDI_MULTIPLANE_OVERLAY_BLEND;

    TDXGI_DDI_MULTIPLANE_OVERLAY_VIDEO_FRAME_FORMAT = (
        DXGI_DDI_MULIIPLANE_OVERLAY_VIDEO_FRAME_FORMAT_PROGRESSIVE = 0,
        DXGI_DDI_MULTIPLANE_OVERLAY_VIDEO_FRAME_FORMAT_INTERLACED_TOP_FIELD_FIRST = 1,
        DXGI_DDI_MULTIPLANE_OVERLAY_VIDEO_FRAME_FORMAT_INTERLACED_BOTTOM_FIELD_FIRST = 2);
    PDXGI_DDI_MULTIPLANE_OVERLAY_VIDEO_FRAME_FORMAT = ^TDXGI_DDI_MULTIPLANE_OVERLAY_VIDEO_FRAME_FORMAT;

    TDXGI_DDI_MULTIPLANE_OVERLAY_YCbCr_FLAGS = (
        DXGI_DDI_MULTIPLANE_OVERLAY_YCbCr_FLAG_NOMINAL_RANGE = $1, // 16 - 235 vs. 0 - 255
        DXGI_DDI_MULTIPLANE_OVERLAY_YCbCr_FLAG_BT709 = $2, // BT.709 vs. BT.601
        DXGI_DDI_MULTIPLANE_OVERLAY_YCbCr_FLAG_xvYCC = $4 // xvYCC vs. conventional YCbCr
        );
    PDXGI_DDI_MULTIPLANE_OVERLAY_YCbCr_FLAGS = ^TDXGI_DDI_MULTIPLANE_OVERLAY_YCbCr_FLAGS;

    TDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT = (
        DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT_MONO = 0,
        DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT_HORIZONTAL = 1,
        DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT_VERTICAL = 2,
        DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT_SEPARATE = 3,
        DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT_MONO_OFFSET = 4,
        DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT_ROW_INTERLEAVED = 5,
        DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT_COLUMN_INTERLEAVED = 6,
        DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT_CHECKERBOARD = 7);
    PDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT = ^TDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT;

    TDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FLIP_MODE = (
        DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FLIP_NONE = 0,
        DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FLIP_FRAME0 = 1,
        DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FLIP_FRAME1 = 2
        );
    PDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FLIP_MODE = ^TDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FLIP_MODE;

    TDXGI_DDI_MULTIPLANE_OVERLAY_STRETCH_QUALITY = (
        DXGI_DDI_MULTIPLANE_OVERLAY_STRETCH_QUALITY_BILINEAR = $1,  // Bilinear
        DXGI_DDI_MULTIPLANE_OVERLAY_STRETCH_QUALITY_HIGH = $2  // Maximum
        );
    PDXGI_DDI_MULTIPLANE_OVERLAY_STRETCH_QUALITY = ^TDXGI_DDI_MULTIPLANE_OVERLAY_STRETCH_QUALITY;


    TDXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES = record
        Flags: UINT;      // DXGI_DDI_MULTIPLANE_OVERLAY_FLAGS
        SrcRect: TRECT;
        DstRect: TRECT;
{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM1_3)}// M1
        ClipRect: TRECT;
{$endif}
        Rotation: TDXGI_DDI_MODE_ROTATION;
        Blend: TDXGI_DDI_MULTIPLANE_OVERLAY_BLEND;
{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM1_3)}// MP
        DirtyRectCount: UINT;
        pDirtyRects: PRECT;
{$else}
        NumFilters: UINT;
        pFilters: pointer;
{$endif}
        VideoFrameFormat: TDXGI_DDI_MULTIPLANE_OVERLAY_VIDEO_FRAME_FORMAT;
        YCbCrFlags: UINT; // DXGI_DDI_MULTIPLANE_OVERLAY_YCbCr_FLAGS
        StereoFormat: TDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT;
        StereoLeftViewFrame0: longbool;
        StereoBaseViewFrame0: longbool;
        StereoFlipMode: TDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FLIP_MODE;
{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM1_3)}// M1
        StretchQuality: TDXGI_DDI_MULTIPLANE_OVERLAY_STRETCH_QUALITY;
{$endif}
    end;
    PDXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES = ^TDXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES;


    TDXGI_DDI_ARG_GETMULTIPLANEOVERLAYCAPS = record
        hDevice: TDXGI_DDI_HDEVICE;
        VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID;
        MultiplaneOverlayCaps: TDXGI_DDI_MULTIPLANE_OVERLAY_CAPS;
    end;
    PDXGI_DDI_ARG_GETMULTIPLANEOVERLAYCAPS = ^TDXGI_DDI_ARG_GETMULTIPLANEOVERLAYCAPS;

    TDXGI_DDI_ARG_GETMULTIPLANEOVERLAYGROUPCAPS = record
        hDevice: TDXGI_DDI_HDEVICE;
        VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID;
        GroupIndex: UINT;
        MultiplaneOverlayGroupCaps: TDXGI_DDI_MULTIPLANE_OVERLAY_GROUP_CAPS;
    end;
    PDXGI_DDI_ARG_GETMULTIPLANEOVERLAYGROUPCAPS = ^TDXGI_DDI_ARG_GETMULTIPLANEOVERLAYGROUPCAPS;

    TDXGI_DDI_CHECK_MULTIPLANEOVERLAYSUPPORT_PLANE_INFO = record
        hResource: TDXGI_DDI_HRESOURCE;
        SubResourceIndex: UINT;
        PlaneAttributes: TDXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES;
    end;
    PDXGI_DDI_CHECK_MULTIPLANE_OVERLAY_SUPPORT_PLANE_INFO = ^TDXGI_DDI_CHECK_MULTIPLANE_OVERLAY_SUPPORT_PLANE_INFO;

    TDXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYSUPPORT = record
        hDevice: TDXGI_DDI_HDEVICE;
        VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID;
        NumPlaneInfo: UINT;
        pPlaneInfo: PDXGI_DDI_CHECK_MULTIPLANE_OVERLAY_SUPPORT_PLANE_INFO;
        Supported: longbool; // out: driver to fill TRUE/FALSE
    end;
    PDXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYSUPPORT = ^TDXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYSUPPORT;

    TDXGI_DDI_PRESENT_MULTIPLANE_OVERLAY = record
        LayerIndex: UINT;
        Enabled: longbool;
        hResource: TDXGI_DDI_HRESOURCE;
        SubResourceIndex: UINT;
        PlaneAttributes: TDXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES;
    end;
    PDXGI_DDI_PRESENT_MULTIPLANE_OVERLAY = ^TDXGI_DDI_PRESENT_MULTIPLANE_OVERLAY;


    TDXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY = record
        hDevice: TDXGI_DDI_HDEVICE;
        pDXGIContext: pointer;

        VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID;
        Flags: TDXGI_DDI_PRESENT_FLAGS;
        FlipInterval: TDXGI_DDI_FLIP_INTERVAL_TYPE;

        PresentPlaneCount: UINT;
        pPresentPlanes: PDXGI_DDI_PRESENT_MULTIPLANE_OVERLAY;
    {$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM1_3)}// M1
        Reserved: UINT;
    {$endif}
    end;
    PDXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY = ^TDXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY;

    {$endif}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WIN8)

    {$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM1_3)}// M1

    TDXGI_DDI_ARG_CHECKPRESENTDURATIONSUPPORT = record
        hDevice: TDXGI_DDI_HDEVICE;
        VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID;
        DesiredPresentDuration: UINT;
        ClosestSmallerDuration: UINT;  // out
        ClosestLargerDuration: UINT;   //out
    end;
    PDXGI_DDI_ARG_CHECKPRESENTDURATIONSUPPORT = ^TDXGI_DDI_ARG_CHECKPRESENTDURATIONSUPPORT;

    TDXGI_DDI_ARG_PRESENTSURFACE = record
        hSurface: TDXGI_DDI_HRESOURCE;         // In
        SubResourceIndex: UINT; // Index of surface level
    end;
    PDXGI_DDI_ARG_PRESENTSURFACE = ^TDXGI_DDI_ARG_PRESENTSURFACE;

    TDXGI_DDI_ARG_PRESENT1 = record
        hDevice: TDXGI_DDI_HDEVICE;             //in
        phSurfacesToPresent: PDXGI_DDI_ARG_PRESENTSURFACE; //in
        SurfacesToPresent: UINT;   //in
        hDstResource: TDXGI_DDI_HRESOURCE;        // if non-zero, it's the destination of the present
        DstSubResourceIndex: UINT; // Index of surface level
        pDXGIContext: pointer;        // opaque: Pass this to the Present callback
        Flags: TDXGI_DDI_PRESENT_FLAGS;               // Presentation flags.
        FlipInterval: TDXGI_DDI_FLIP_INTERVAL_TYPE;        // Presentation interval (flip only)
        Reserved: UINT;
        pDirtyRects: PRECT;         // in: Array of dirty rects
        DirtyRects: UINT;          // in: Number of dirty rects

    {$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_0)}
        // out: for LDA only.
        // Only WDDM2.0 drivers should write this value
        // The number of physical back buffer per logical back buffer.
        BackBufferMultiplicity: UINT;
    {$endif}

    end;
    PDXGI_DDI_ARG_PRESENT1 = ^TDXGI_DDI_ARG_PRESENT1;

    {$endif}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM1_3) // M1

    {$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_0)}

    TDXGI_DDI_ARG_TRIMRESIDENCYSET = record
        hDevice: TDXGI_DDI_HDEVICE;
        TrimFlags: TD3DDDI_TRIMRESIDENCYSET_FLAGS;
        NumBytesToTrim: UINT64;
    end;
    PDXGI_DDI_ARG_TRIMRESIDENCYSET = ^TDXGI_DDI_ARG_TRIMRESIDENCYSET;

    TDXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYCOLORSPACESUPPORT = record
        hDevice: TDXGI_DDI_HDEVICE;
        VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID;
        Format: TDXGI_FORMAT;
        ColorSpace: TD3DDDI_COLOR_SPACE_TYPE;
        Supported: longbool;      // out
    end;
    PDXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYCOLORSPACESUPPORT = ^TDXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYCOLORSPACESUPPORT;

    TDXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES1 = record
        Flags: UINT;   // DXGI_DDI_MULTIPLANE_OVERLAY_FLAGS
        SrcRect: TRECT;
        DstRect: TRECT;
        ClipRect: TRECT;
        Rotation: TDXGI_DDI_MODE_ROTATION;
        Blend: TDXGI_DDI_MULTIPLANE_OVERLAY_BLEND;
        DirtyRectCount: UINT;
        pDirtyRects: PRECT;
        VideoFrameFormat: TDXGI_DDI_MULTIPLANE_OVERLAY_VIDEO_FRAME_FORMAT;
        ColorSpace: TD3DDDI_COLOR_SPACE_TYPE;
        StereoFormat: TDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT;
        StereoLeftViewFrame0: longbool;
        StereoBaseViewFrame0: longbool;
        StereoFlipMode: TDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FLIP_MODE;
        StretchQuality: TDXGI_DDI_MULTIPLANE_OVERLAY_STRETCH_QUALITY;
        ColorKey: UINT;
    end;
    PDXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES1 = ^TDXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES1;

    TDXGI_DDI_PRESENT_MULTIPLANE_OVERLAY1 = record
        LayerIndex: UINT;
        Enabled: longbool;
        hResource: TDXGI_DDI_HRESOURCE;
        SubResourceIndex: UINT;
        PlaneAttributes: TDXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES1;
    end;
    PDXGI_DDI_PRESENT_MULTIPLANE_OVERLAY1 = ^TDXGI_DDI_PRESENT_MULTIPLANE_OVERLAY1;

    TDXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY1 = record
        hDevice: TDXGI_DDI_HDEVICE;
        pDXGIContext: pointer;

        VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID;
        Flags: TDXGI_DDI_PRESENT_FLAGS;
        FlipInterval: TDXGI_DDI_FLIP_INTERVAL_TYPE;

        PresentPlaneCount: UINT;
        pPresentPlanes: PDXGI_DDI_PRESENT_MULTIPLANE_OVERLAY1;
    end;
    PDXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY1 = ^TDXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY1;

    {$endif}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_0)

    {$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_1_1)}

    TDXGI_DDI_ARG_OFFERRESOURCES1 = record
        hDevice: TDXGI_DDI_HDEVICE;                                 //in:  device that created the resources
        pResources: PDXGI_DDI_HRESOURCE;    //in:  array of resources to reset
        Resources: UINT;                                           //in:  number of elements in pResources
        Priority: TD3DDDI_OFFER_PRIORITY;                           //in:  priority with which to reset the resources
        Flags: TD3DDDI_OFFER_FLAGS;                                 //in:  flags specifying additional behaviors on offer
    end;
    PDXGI_DDI_ARG_OFFERRESOURCES1 = ^TDXGI_DDI_ARG_OFFERRESOURCES1;

    {$endif}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_1_1)

    {$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_1_2)}

    TDXGI_DDI_ARG_RECLAIMRESOURCES1 = record
        hDevice: TDXGI_DDI_HDEVICE;                           //in:  device that created the resources
        pResources: PDXGI_DDI_HRESOURCE;               //in:  array of resources to reset
        pResults: PD3DDDI_RECLAIM_RESULT;                    //out: array of results specifying whether each resource was
        //     successfully reclaimed, discarded, or has no commitment
        Resources: UINT;                                     //in:  number of elements in pResources and pDiscarded
    end;
    PDXGI_DDI_ARG_RECLAIMRESOURCES1 = ^TDXGI_DDI_ARG_RECLAIMRESOURCES1;

    {$endif}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_1_2)

    {$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_2_2)}

    TDXGI1_6_1_DDI_ARG_PRESENT = record
        hDevice: TDXGI_DDI_HDEVICE;             //in
        phSurfacesToPresent: PDXGI_DDI_ARG_PRESENTSURFACE; //in
        SurfacesToPresent: UINT;   //in
        hDstResource: TDXGI_DDI_HRESOURCE;        // if non-zero, it's the destination of the present
        DstSubResourceIndex: UINT; // Index of surface level
        pDXGIContext: pointer;        // opaque: Pass this to the Present callback
        Flags: TDXGI_DDI_PRESENT_FLAGS;               // Presentation flags.
        FlipInterval: TDXGI_DDI_FLIP_INTERVAL_TYPE;        // Presentation interval (flip only)
        RotationHint: TDXGI_DDI_MODE_ROTATION;        // in: Hint that the contents of the frame are rotated with respect to scanout.
        pDirtyRects: PRECT;         // in: Array of dirty rects
        DirtyRects: UINT;          // in: Number of dirty rects

        // out: for LDA only.
        // The number of physical back buffer per logical back buffer.
        BackBufferMultiplicity: UINT;
    end;
    PDXGI1_6_1_DDI_ARG_PRESENT = ^TDXGI1_6_1_DDI_ARG_PRESENT;

    TDXGI1_6_1_DDI_ARG_PRESENTMULTIPLANEOVERLAY = record
        hDevice: TDXGI_DDI_HDEVICE;
        pDXGIContext: pointer;

        VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID;
        Flags: TDXGI_DDI_PRESENT_FLAGS;
        FlipInterval: TDXGI_DDI_FLIP_INTERVAL_TYPE;

        PresentPlaneCount: UINT;
        pPresentPlanes: PDXGI_DDI_PRESENT_MULTIPLANE_OVERLAY1;
        pRotationHints: PDXGI_DDI_MODE_ROTATION;
    end;
    PDXGI1_6_1_DDI_ARG_PRESENTMULTIPLANEOVERLAY = ^TDXGI1_6_1_DDI_ARG_PRESENTMULTIPLANEOVERLAY;

{$endif}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_2_2)


    //--------------------------------------------------------------------------------------------------------
    TpfnPresent = function(pPresentData: PDXGI_DDI_ARG_PRESENT): HResult; stdcall;
    TpfnGetGammaCaps = function(pGammaData: PDXGI_DDI_ARG_GET_GAMMA_CONTROL_CAPS): HResult; stdcall;
    TpfnSetDisplayMode = function(pDisplayMode: PDXGI_DDI_ARG_SETDISPLAYMODE): HResult; stdcall;
    TpfnSetResourcePriority = function(pPriorityData: PDXGI_DDI_ARG_SETRESOURCEPRIORITY): HResult; stdcall;
    TpfnQueryResourceResidency = function(pResidencyData: PDXGI_DDI_ARG_QUERYRESOURCERESIDENCY): HResult; stdcall;
    TpfnRotateResourceIdentities = function(pRotateData: PDXGI_DDI_ARG_ROTATE_RESOURCE_IDENTITIES): HResult; stdcall;
    TpfnBlt = function(pBltData: PDXGI_DDI_ARG_BLT): HResult; stdcall;

    TDXGI_DDI_BASE_FUNCTIONS = record
        pfnPresent: TpfnPresent;
        pfnGetGammaCaps: TpfnGetGammaCaps;
        pfnSetDisplayMode: TpfnSetDisplayMode;
        pfnSetResourcePriority: TpfnSetResourcePriority;
        pfnQueryResourceResidency: TpfnQueryResourceResidency;
        pfnRotateResourceIdentities: TpfnRotateResourceIdentities;
        pfnBlt: TpfnBlt;
    end;
    PDXGI_DDI_BASE_FUNCTIONS = ^TDXGI_DDI_BASE_FUNCTIONS;

    //--------------------------------------------------------------------------------------------------------
    TpfnResolveSharedResource = function(pResourceData: PDXGI_DDI_ARG_RESOLVESHAREDRESOURCE): HResult; stdcall;

    TDXGI1_1_DDI_BASE_FUNCTIONS = record
        pfnPresent: TpfnPresent;
        pfnGetGammaCaps: TpfnGetGammaCaps;
        pfnSetDisplayMode: TpfnSetDisplayMode;
        pfnSetResourcePriority: TpfnSetResourcePriority;
        pfnQueryResourceResidency: TpfnQueryResourceResidency;
        pfnRotateResourceIdentities: TpfnRotateResourceIdentities;
        pfnBlt: TpfnBlt;
        pfnResolveSharedResource: TpfnResolveSharedResource;
    end;
    PDXGI1_1_DDI_BASE_FUNCTIONS = ^TDXGI1_1_DDI_BASE_FUNCTIONS;

{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WIN8)}

    //--------------------------------------------------------------------------------------------------------

    TpfnBlt1 = function(pBlt1Data: PDXGI_DDI_ARG_BLT1): HResult; stdcall;
    TpfnOfferResources = function(pResources: PDXGI_DDI_ARG_OFFERRESOURCES): HResult; stdcall;
    TpfnReclaimResources = function(pResources: PDXGI_DDI_ARG_RECLAIMRESOURCES): HResult; stdcall;
    // Use IS_DXGI_MULTIPLANE_OVERLAY_FUNCTIONS macro to determine these functions fields are available
    TpfnGetMultiplaneOverlayCaps = function(pCaps: PDXGI_DDI_ARG_GETMULTIPLANEOVERLAYCAPS): HResult; stdcall;
    TpfnGetMultiplaneOverlayFilterRange = function(p: pointer): HResult; stdcall;
    TpfnCheckMultiplaneOverlaySupport = function(pSupport: PDXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYSUPPORT): HResult; stdcall;
    TpfnPresentMultiplaneOverlay = function(pPresentDXGI: PDXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY): HResult; stdcall;

    TDXGI1_2_DDI_BASE_FUNCTIONS = record
        pfnPresent: TpfnPresent;
        pfnGetGammaCaps: TpfnGetGammaCaps;
        pfnSetDisplayMode: TpfnSetDisplayMode;
        pfnSetResourcePriority: TpfnSetResourcePriority;
        pfnQueryResourceResidency: TpfnQueryResourceResidency;
        pfnRotateResourceIdentities: TpfnRotateResourceIdentities;
        pfnBlt: TpfnBlt;
        pfnResolveSharedResource: TpfnResolveSharedResource;
        pfnBlt1: TpfnBlt1;
        pfnOfferResources: TpfnOfferResources;
        pfnReclaimResources: TpfnReclaimResources;
        // Use IS_DXGI_MULTIPLANE_OVERLAY_FUNCTIONS macro to determine these functions fields are available
        pfnGetMultiplaneOverlayCaps: TpfnGetMultiplaneOverlayCaps;
        pfnGetMultiplaneOverlayFilterRange: TpfnGetMultiplaneOverlayFilterRange;
        pfnCheckMultiplaneOverlaySupport: TpfnCheckMultiplaneOverlaySupport;
        pfnPresentMultiplaneOverlay: TpfnPresentMultiplaneOverlay;
    end;
    PDXGI1_2_DDI_BASE_FUNCTIONS = ^TDXGI1_2_DDI_BASE_FUNCTIONS;

{$endif}

{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM1_3)}// M1

    //--------------------------------------------------------------------------------------------------------


    TpfnGetMultiplaneOverlayGroupCaps = function(pGroupCaps: PDXGI_DDI_ARG_GETMULTIPLANEOVERLAYGROUPCAPS): HResult; stdcall;
    TpfnReserved1 = function(p: pointer): HResult; stdcall;
    TpfnPresentMultiplaneOverlay = function(pPresentDXGI: PDXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY): HResult; stdcall;
    TpfnReserved2 = function(p: pointer): HResult; stdcall;
    TpfnPresent1 = function(pPresentData: PDXGI_DDI_ARG_PRESENT1): HResult; stdcall;
    TpfnCheckPresentDurationSupport = function(pPresentDurationSupport: PDXGI_DDI_ARG_CHECKPRESENTDURATIONSUPPORT): HResult; stdcall;

    TDXGI1_3_DDI_BASE_FUNCTIONS = record
        pfnPresent: TpfnPresent;
        pfnGetGammaCaps: TpfnGetGammaCaps;
        pfnSetDisplayMode: TpfnSetDisplayMode;
        pfnSetResourcePriority: TpfnSetResourcePriority;
        pfnQueryResourceResidency: TpfnQueryResourceResidency;
        pfnRotateResourceIdentities: TpfnRotateResourceIdentities;
        pfnBlt: TpfnBlt;
        pfnResolveSharedResource: TpfnResolveSharedResource;
        pfnBlt1: TpfnBlt1;
        pfnOfferResources: TpfnOfferResources;
        pfnReclaimResources: TpfnReclaimResources;
        pfnGetMultiplaneOverlayCaps: TpfnGetMultiplaneOverlayCaps;
        pfnGetMultiplaneOverlayGroupCaps: TpfnGetMultiplaneOverlayGroupCaps;
        pfnReserved1: TpfnReserved1;
        pfnPresentMultiplaneOverlay: TpfnPresentMultiplaneOverlay;
        pfnReserved2: TpfnReserved2;
        pfnPresent1: TpfnPresent1;
        pfnCheckPresentDurationSupport: TpfnCheckPresentDurationSupport;
    end;
    PDXGI1_3_DDI_BASE_FUNCTIONS = ^TDXGI1_3_DDI_BASE_FUNCTIONS;

{$endif}

{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_0)}

    //--------------------------------------------------------------------------------------------------------

    pfnTrimResidencySet = function(pData: PDXGI_DDI_ARG_TRIMRESIDENCYSET): HResult; stdcall;
    pfnCheckMultiplaneOverlayColorSpaceSupport = function(pSpaceSupport: PDXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYCOLORSPACESUPPORT): HResult; stdcall;
    pfnPresentMultiplaneOverlay1 = function(pOverlay1: PDXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY1): HResult; stdcall;

    TDXGI1_4_DDI_BASE_FUNCTIONS = record
        pfnPresent: TpfnPresent;
        pfnGetGammaCaps: TpfnGetGammaCaps;
        pfnSetDisplayMode: TpfnSetDisplayMode;
        pfnSetResourcePriority: TpfnSetResourcePriority;
        pfnQueryResourceResidency: TpfnQueryResourceResidency;
        pfnRotateResourceIdentities: TpfnRotateResourceIdentities;
        pfnBlt: TpfnBlt;
        pfnResolveSharedResource: TpfnResolveSharedResource;
        pfnBlt1: TpfnBlt1;
        pfnOfferResources: TpfnOfferResources;
        pfnReclaimResources: TpfnReclaimResources;
        pfnGetMultiplaneOverlayCaps: TpfnGetMultiplaneOverlayCaps;
        pfnGetMultiplaneOverlayGroupCaps: TpfnGetMultiplaneOverlayGroupCaps;
        pfnReserved1: TpfnReserved1;
        pfnPresentMultiplaneOverlay: TpfnPresentMultiplaneOverlay;
        pfnReserved2: TpfnReserved2;
        pfnPresent1: TpfnPresent1;
        pfnCheckPresentDurationSupport: TpfnCheckPresentDurationSupport;
        pfnTrimResidencySet: TpfnTrimResidencySet;
        pfnCheckMultiplaneOverlayColorSpaceSupport: TpfnCheckMultiplaneOverlayColorSpaceSupport;
        pfnPresentMultiplaneOverlay1: TpfnPresentMultiplaneOverlay1;
    end;
    PDXGI1_4_DDI_BASE_FUNCTIONS = ^TDXGI1_4_DDI_BASE_FUNCTIONS;

{$endif}

{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_1_1)}

    //--------------------------------------------------------------------------------------------------------

    TpfnReclaimResources1 = function(pResources1: PDXGI_DDI_ARG_RECLAIMRESOURCES1): HResult; stdcall;

    TDXGI1_5_DDI_BASE_FUNCTIONS = record
        pfnPresent: TpfnPresent;
        pfnGetGammaCaps: TpfnGetGammaCaps;
        pfnSetDisplayMode: TpfnSetDisplayMode;
        pfnSetResourcePriority: TpfnSetResourcePriority;
        pfnQueryResourceResidency: TpfnQueryResourceResidency;
        pfnRotateResourceIdentities: TpfnRotateResourceIdentities;
        pfnBlt: TpfnBlt;
        pfnResolveSharedResource: TpfnResolveSharedResource;
        pfnBlt1: TpfnBlt1;
        pfnOfferResources: TpfnOfferResources;
        pfnReclaimResources: TpfnReclaimResources;
        pfnGetMultiplaneOverlayCaps: TpfnGetMultiplaneOverlayCaps;
        pfnGetMultiplaneOverlayGroupCaps: TpfnGetMultiplaneOverlayGroupCaps;
        pfnReserved1: TpfnReserved1;
        pfnPresentMultiplaneOverlay: TpfnPresentMultiplaneOverlay;
        pfnReserved2: TpfnReserved2;
        pfnPresent1: TpfnPresent1;
        pfnCheckPresentDurationSupport: TpfnCheckPresentDurationSupport;
        pfnTrimResidencySet: TpfnTrimResidencySet;
        pfnCheckMultiplaneOverlayColorSpaceSupport: TpfnCheckMultiplaneOverlayColorSpaceSupport;
        pfnPresentMultiplaneOverlay1: TpfnPresentMultiplaneOverlay1;
        pfnReclaimResources1: TpfnReclaimResources1;
    end;
    PDXGI1_5_DDI_BASE_FUNCTIONS = ^TDXGI1_5_DDI_BASE_FUNCTIONS;
{$endif}

{$IF (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_2_2)}
    TpfnOfferResources1 = function(Resources1: PDXGI_DDI_ARG_OFFERRESOURCES1): HResult; stdcall;
    TpfnPresent6 = function(pPresentData: PDXGI_DDI_ARG_PRESENT6): HResult; stdcall;
    TpfnPresentMultiplaneOverlay6 = function(pOverlay1: PDXGI1_6_1_DDI_ARG_PRESENTMULTIPLANEOVERLAY): HResult; stdcall;

    TDXGI1_6_1_DDI_BASE_FUNCTIONS = record
        pfnPresent: TpfnPresent;
        pfnGetGammaCaps: TpfnGetGammaCaps;
        pfnSetDisplayMode: TpfnSetDisplayMode;
        pfnSetResourcePriority: TpfnSetResourcePriority;
        pfnQueryResourceResidency: TpfnQueryResourceResidency;
        pfnRotateResourceIdentities: TpfnRotateResourceIdentities;
        pfnBlt: TpfnBlt;
        pfnResolveSharedResource: TpfnResolveSharedResource;
        pfnBlt1: TpfnBlt1;
        pfnOfferResources1: TpfnOfferResources1;
        pfnReclaimResources: TpfnReclaimResources;
        pfnGetMultiplaneOverlayCaps: TpfnGetMultiplaneOverlayCaps;
        pfnGetMultiplaneOverlayGroupCaps: TpfnGetMultiplaneOverlayGroupCaps;
        pfnReserved1: TpfnReserved1;
        pfnPresentMultiplaneOverlay: TpfnPresentMultiplaneOverlay;
        pfnReserved2: TpfnReserved2;
        pfnPresent1: TpfnPresent6;
        pfnCheckPresentDurationSupport: TpfnCheckPresentDurationSupport;
        pfnTrimResidencySet: TpfnTrimResidencySet;
        pfnCheckMultiplaneOverlayColorSpaceSupport: TpfnCheckMultiplaneOverlayColorSpaceSupport;
        pfnPresentMultiplaneOverlay1: TpfnPresentMultiplaneOverlay6;
        pfnReclaimResources1: TpfnReclaimResources1;
    end;
    PDXGI1_6_1_DDI_BASE_FUNCTIONS = ^TDXGI1_6_1_DDI_BASE_FUNCTIONS;

{$ENDIF}



    //========================================================================================================
    // DXGI callback definitions.



    //--------------------------------------------------------------------------------------------------------
    TDXGIDDICB_PRESENT = record
        hSrcAllocation: TD3DKMT_HANDLE;             // in: The allocation of which content will be presented
        hDstAllocation: TD3DKMT_HANDLE;             // in: if non-zero, it's the destination allocation of the present
        pDXGIContext: pointer;               // opaque: Fill this with the value in DXGI_DDI_ARG_PRESENT.pDXGIContext
        hContext: THANDLE;                   // in: Context being submitted to.
        BroadcastContextCount: UINT;      // in: Specifies the number of context
        //     to broadcast this present operation to.
        //     Only supported for flip operation.
        BroadcastContext: array [0..D3DDDI_MAX_BROADCAST_CONTEXT - 1] of THANDLE; // in: Specifies the handle of the context to
        //     broadcast to.
{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_0)}
        BroadcastSrcAllocation{BroadcastContextCount}: PD3DKMT_HANDLE;                         // in: LDA
        BroadcastDstAllocation {BroadcastContextCount}: PD3DKMT_HANDLE;                         // in: LDA
        PrivateDriverDataSize: UINT;                          // in:
        pPrivateDriverData {PrivateDriverDataSize}: Pointer;
        // in: Private driver data to pass to DdiPresent and DdiSetVidPnSourceAddress
        bOptimizeForComposition: boolean;                        // out: DWM is involved in composition
{$endif}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_0)

{$IF  (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_2_2)}
        SyncIntervalOverrideValid: longbool;
        SyncIntervalOverride: TDXGI_DDI_FLIP_INTERVAL_TYPE;
{$ENDIF}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_2_2)
    end;
    PDXGIDDICB_PRESENT = ^TDXGIDDICB_PRESENT;

{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WIN8)}
    TDXGIDDI_MULTIPLANE_OVERLAY_ALLOCATION_INFO = record
        PresentAllocation: TD3DKMT_HANDLE;
        SubResourceIndex: UINT;
    end;
    PDXGIDDI_MULTIPLANE_OVERLAY_ALLOCATION_INFO = ^TDXGIDDI_MULTIPLANE_OVERLAY_ALLOCATION_INFO;

    TDXGIDDICB_PRESENT_MULTIPLANE_OVERLAY = record
        pDXGIContext: pointer;               // opaque: Fill this with the value in DXGI_DDI_ARG_PRESENT.pDXGIContext
        hContext: THANDLE;

        BroadcastContextCount: UINT;
        BroadcastContext: array [0..D3DDDI_MAX_BROADCAST_CONTEXT - 1] of THANDLE;

        AllocationInfoCount: DWORD;
        AllocationInfo: array [0..DXGI_DDI_MAX_MULTIPLANE_OVERLAY_ALLOCATIONS - 1] of TDXGIDDI_MULTIPLANE_OVERLAY_ALLOCATION_INFO;
    end;
    PDXGIDDICB_PRESENT_MULTIPLANE_OVERLAY = ^TDXGIDDICB_PRESENT_MULTIPLANE_OVERLAY;
{$endif}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WIN8)


{$IF  (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_2_1)}
    TDXGIDDI_MULTIPLANE_OVERLAY_PLANE_INFO = record
        ContextCount: UINT;

        pContextList {ContextCount}: PHANDLE;

        pAllocationList {ContextCount}: PD3DKMT_HANDLE;

        DriverPrivateDataSize: UINT;
        pDriverPrivateData {DriverPrivateDataSize}: pointer;

{$IF  (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_2_2)}
        SyncIntervalOverrideValid: longbool;
        SyncIntervalOverride: TDXGI_DDI_FLIP_INTERVAL_TYPE;
{$ENDIF}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_2_2)
    end;
    PDXGIDDI_MULTIPLANE_OVERLAY_PLANE_INFO = ^TDXGIDDI_MULTIPLANE_OVERLAY_PLANE_INFO;

    TDXGIDDICB_PRESENT_MULTIPLANE_OVERLAY1 = record

        pDXGIContext: pointer;               // opaque: Fill this with the value in DXGI_DDI_ARG_PRESENT.pDXGIContext
        PresentPlaneCount: DWORD;

        ppPresentPlanes {PresentPlaneCount}: PDXGIDDI_MULTIPLANE_OVERLAY_PLANE_INFO;
    end;
    PDXGIDDICB_PRESENT_MULTIPLANE_OVERLAY1 = ^TDXGIDDICB_PRESENT_MULTIPLANE_OVERLAY1;
{$ENDIF}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_2_1)

{$IF  (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_4_2)}

    TDXGIDDICB_SUBMITPRESENTBLTTOHWQUEUE = record
        hSrcAllocation: TD3DKMT_HANDLE;             // in: The allocation of which content will be presented
        hDstAllocation: TD3DKMT_HANDLE;             // in: The destination allocation of the present
        pDXGIContext: pointer;               // opaque: Fill this with the value in DXGI_DDI_ARG_PRESENT.pDXGIContext
        hHwQueue: THANDLE;                   // in: Hardware queue being submitted to.
        HwQueueProgressFenceId: UINT64;
        // Hardware queue progress fence ID that will be signaled when the Present Blt is done on the GPU

        PrivateDriverDataSize: UINT;

        pPrivateDriverData {PrivateDriverDataSize}: pointer;         // in: Private driver data to pass to DdiPresent
    end;
    PDXGIDDICB_SUBMITPRESENTBLTTOHWQUEUE = ^TDXGIDDICB_SUBMITPRESENTBLTTOHWQUEUE;

{$ENDIF}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_4_2)




    {$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_5_2)}

    TDXGIDDICB_SUBMITPRESENTTOHWQUEUE = record
        pDXGIContext: pointer;               // opaque: Fill this with the value in DXGI_DDI_ARG_PRESENT.pDXGIContext
        BroadcastSrcAllocations {BroadcastHwQueueCount}: PD3DKMT_HANDLE;    // in: allocations which content will be presented
        BroadcastDstAllocations {BroadcastHwQueueCount}: PD3DKMT_HANDLE;    // in: if non-zero, it's the destination allocations of the present
        hHwQueues: PHANDLE;                  // in: hardware queues being submitted to.
        BroadcastHwQueueCount: UINT;      // in: the number of broadcast hardware queues
        PrivateDriverDataSize: UINT;      // in: private driver data size in bytes
        pPrivateDriverData {PrivateDriverDataSize}: pointer;         // in: private driver data to pass to DdiPresent
    end;
    PDXGIDDICB_SUBMITPRESENTTOHWQUEUE = ^TDXGIDDICB_SUBMITPRESENTTOHWQUEUE;

{$endif}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_5_2)


    PFNDDXGIDDI_PRESENTCB = function(hDevice: THANDLE;{in} x: PDXGIDDICB_PRESENT): HRESULT; stdcall;

{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WIN8)}
    PFNDDXGIDDI_PRESENT_MULTIPLANE_OVERLAYCB = function(hDevice: THANDLE;
        {_In_} const x: PDXGIDDICB_PRESENT_MULTIPLANE_OVERLAY): HRESULT; stdcall;
{$endif}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WIN8)



{$IF  (D3D_UMD_INTERFACE_VERSION >=  D3D_UMD_INTERFACE_VERSION_WDDM2_2_1)}
    PFNDDXGIDDI_PRESENT_MULTIPLANE_OVERLAY1CB = function(hDevice: THANDLE;
        {_In_}  const P: PDXGIDDICB_PRESENT_MULTIPLANE_OVERLAY1): HResult; stdcall;
{$ENDIF}// (D3D_UMD_INTERFACE_VERSION >=  D3D_UMD_INTERFACE_VERSION_WDDM2_2_1)

{$IF  (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_4_2)}

    PFNDDXGIDDI_SUBMITPRESENTBLTTOHWQUEUECB = function(hDevice: THANDLE; { _In_ } p: PDXGIDDICB_SUBMITPRESENTBLTTOHWQUEUE): HRESULT; stdcall;

{$ENDIF}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_4_2)

{$IF  (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_5_2)}

    PFNDDXGIDDI_SUBMITPRESENTTOHWQUEUECB = function(hDevice: THANDLE; { _In_ } p: PDXGIDDICB_SUBMITPRESENTTOHWQUEUE): HRESULT; stdcall;

{$ENDIF}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_5_2)


    //--------------------------------------------------------------------------------------------------------
    TDXGI_DDI_BASE_CALLBACKS = record
        pfnPresentCb: PFNDDXGIDDI_PRESENTCB;
{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WIN8)}
        // Use IS_DXGI_MULTIPLANE_OVERLAY_FUNCTIONS macro to check if field is available.
        pfnPresentMultiplaneOverlayCb: PFNDDXGIDDI_PRESENT_MULTIPLANE_OVERLAYCB;
{$endif}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WIN8)
            {$IF  (D3D_UMD_INTERFACE_VERSION >=  D3D_UMD_INTERFACE_VERSION_WDDM2_2_1)}
        // Use IS_DXGI1_6_BASE_FUNCTIONS macro to check if field is available.
        pfnPresentMultiplaneOverlay1Cb: PFNDDXGIDDI_PRESENT_MULTIPLANE_OVERLAY1CB;
{$ENDIF}// (D3D_UMD_INTERFACE_VERSION >=  D3D_UMD_INTERFACE_VERSION_WDDM2_2_1)

{$IF  (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_4_2)}
        pfnSubmitPresentBltToHwQueueCb: PFNDDXGIDDI_SUBMITPRESENTBLTTOHWQUEUECB;
{$ENDIF}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_4_2)

{$IF  (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_5_2)}
        pfnSubmitPresentToHwQueueCb: PFNDDXGIDDI_SUBMITPRESENTTOHWQUEUECB;
{$ENDIF}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_5_2)
    end;
    PDXGI_DDI_BASE_CALLBACKS = ^TDXGI_DDI_BASE_CALLBACKS;

    //========================================================================================================
    // DXGI basic DDI device creation arguments

    TDXGI_DDI_BASE_ARGS = record
        pDXGIBaseCallbacks: PDXGI_DDI_BASE_CALLBACKS;            // in: The driver should record this pointer for later use
        case integer of
        {$IF  (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_2_2)}
            6: (pDXGIDDIBaseFunctions6_1: PDXGI1_6_1_DDI_BASE_FUNCTIONS);
            // in/out: The driver should fill the denoted struct with DXGI base driver entry points
        {$ENDIF}
        {$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_1_1)}
            5: (pDXGIDDIBaseFunctions6: PDXGI1_5_DDI_BASE_FUNCTIONS);
            // in/out: The driver should fill the denoted struct with DXGI base driver entry points
        {$endif}
        {$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_0)}
            4: (pDXGIDDIBaseFunctions5: PDXGI1_4_DDI_BASE_FUNCTIONS);
            // in/out: The driver should fill the denoted struct with DXGI base driver entry points
        {$endif}
        {$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM1_3)}// M1
            3: (pDXGIDDIBaseFunctions4: PDXGI1_3_DDI_BASE_FUNCTIONS);
            // in/out: The driver should fill the denoted struct with DXGI base driver entry points
        {$endif}
        {$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WIN8)}
            2: (pDXGIDDIBaseFunctions3: PDXGI1_2_DDI_BASE_FUNCTIONS);
            // in/out: The driver should fill the denoted struct with DXGI base driver entry points
        {$endif}
            1: (pDXGIDDIBaseFunctions2: PDXGI1_1_DDI_BASE_FUNCTIONS);
            // in/out: The driver should fill the denoted struct with DXGI base driver entry points
            0: (pDXGIDDIBaseFunctions: PDXGI_DDI_BASE_FUNCTIONS);
        // in/out: The driver should fill the denoted struct with DXGI base driver entry points

    end;
    PDXGI_DDI_BASE_ARGS = ^TDXGI_DDI_BASE_ARGS;



implementation

end.
