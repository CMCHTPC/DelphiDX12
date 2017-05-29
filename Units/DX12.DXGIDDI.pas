{*==========================================================================;
 *
 *  Copyright (C) Microsoft Corporation.  All Rights Reserved.
 *
 *  Content: DXGI Basic Device Driver Interface Definitions
 *
 ***************************************************************************}

unit DX12.DXGIDDI;

{$mode delphi}{$H+}

interface

uses
  Windows,Classes, SysUtils, DX12.DXGI;



//--------------------------------------------------------------------------------------------------------
// DXGI error codes
//--------------------------------------------------------------------------------------------------------
const
 _FACDXGI_DDI =  $87b;
{#define MAKE_DXGI_DDI_HRESULT( code )  MAKE_HRESULT( 1, _FACDXGI_DDI, code )
#define MAKE_DXGI_DDI_STATUS( code )   MAKE_HRESULT( 0, _FACDXGI_DDI, code ) }

// DXGI DDI error codes have moved to winerror.h

// Bit indicates that UMD has the option to prevent this Resource from ever being a Primary
// UMD can prevent the actual flip (from optional primary to regular primary) and use a copy
// operation, during Present. Thus, it's possible the UMD can opt out of this Resource being
// actually used as a primary.
const
 DXGI_DDI_PRIMARY_OPTIONAL  = $1 ;

// Bit indicates that the Primary really represents the IDENTITY rotation, eventhough it will
// be used with non-IDENTITY display modes, since the application will take on the burden of
// honoring the output orientation by rotating, say the viewport and projection matrix.
DXGI_DDI_PRIMARY_NONPREROTATED =$2 ;


// Bit indicates that the primary is stereoscopic.
 DXGI_DDI_PRIMARY_STEREO =$4  ;

// Bit indicates that this primary will be used for indirect presentation
DXGI_DDI_PRIMARY_INDIRECT =$8;


// Bit indicates that the driver cannot tolerate setting any subresource of the specified
// resource as a primary. The UMD should set this bit at resource creation time if it
// chooses to implement presentation from this surface via a copy operation. The DXGI
// runtime will not employ flip-style presentation if this bit is set
 DXGI_DDI_PRIMARY_DRIVER_FLAG_NO_SCANOUT= $1;

const
 DXGI_DDI_MAX_MULTIPLANE_OVERLAY_ALLOCATIONS  =   16;

//========================================================================================================
// This is the standard DDI that any DXGI-enabled user-mode driver should support
//

//--------------------------------------------------------------------------------------------------------
type
    	TDXGI_DDI_HDEVICE = UINT_PTR;
        PDXGI_DDI_HDEVICE = ^TDXGI_DDI_HDEVICE;
	TDXGI_DDI_HRESOURCE = UINT_PTR;
        PDXGI_DDI_HRESOURCE= ^TDXGI_DDI_HRESOURCE;

//--------------------------------------------------------------------------------------------------------
TDXGI_DDI_RESIDENCY=(
    DXGI_DDI_RESIDENCY_FULLY_RESIDENT = 1,
    DXGI_DDI_RESIDENCY_RESIDENT_IN_SHARED_MEMORY = 2,
    DXGI_DDI_RESIDENCY_EVICTED_TO_DISK = 3
);
PDXGI_DDI_RESIDENCY = ^TDXGI_DDI_RESIDENCY;

//--------------------------------------------------------------------------------------------------------
TDXGI_DDI_FLIP_INTERVAL_TYPE =(
    DXGI_DDI_FLIP_INTERVAL_IMMEDIATE = 0,
    DXGI_DDI_FLIP_INTERVAL_ONE       = 1,
    DXGI_DDI_FLIP_INTERVAL_TWO       = 2,
    DXGI_DDI_FLIP_INTERVAL_THREE     = 3,
    DXGI_DDI_FLIP_INTERVAL_FOUR      = 4
);
PDXGI_DDI_FLIP_INTERVAL_TYPE = ^TDXGI_DDI_FLIP_INTERVAL_TYPE;

//--------------------------------------------------------------------------------------------------------
TDXGI_DDI_PRESENT_FLAGS =record
    case Integer of
    0: (
    ValueToDo: UINT;
           { UINT    Blt                 : 1;        // $00000001
            UINT    Flip                : 1;        // $00000002
            UINT    PreferRight         : 1;        // $00000004
            UINT    TemporaryMono       : 1;        // $00000008
            UINT    Reserved            :28; }
        );
    1:(        Value:UINT);

end;
PDXGI_DDI_PRESENT_FLAGS = ^TDXGI_DDI_PRESENT_FLAGS;

//--------------------------------------------------------------------------------------------------------
TDXGI_DDI_ARG_PRESENT =record
                hDevice:TDXGI_DDI_HDEVICE;             //in
              hSurfaceToPresent:TDXGI_DDI_HRESOURCE;   //in
                            SrcSubResourceIndex:UINT; // Index of surface level
              hDstResource:TDXGI_DDI_HRESOURCE;        // if non-zero, it's the destination of the present
                            DstSubResourceIndex:UINT; // Index of surface level
                         pDXGIContext:pointer;        // opaque: Pass this to the Present callback
          Flags:TDXGI_DDI_PRESENT_FLAGS;               // Presentation flags.
     FlipInterval:TDXGI_DDI_FLIP_INTERVAL_TYPE;        // Presentation interval (flip only)
end;
PDXGI_DDI_ARG_PRESENT = ^TDXGI_DDI_ARG_PRESENT;

//--------------------------------------------------------------------------------------------------------
TDXGI_DDI_ARG_ROTATE_RESOURCE_IDENTITIES  =record
     hDevice:TDXGI_DDI_HDEVICE; //in
    pResources :PDXGI_DDI_HRESOURCE; //in: Array of Resources to rotate identities; 0 <= 1, 1 <= 2, etc.
     Resources:UINT;
end;
PDXGI_DDI_ARG_ROTATE_RESOURCE_IDENTITIES = ^TDXGI_DDI_ARG_ROTATE_RESOURCE_IDENTITIES;

TDXGI_DDI_ARG_GET_GAMMA_CONTROL_CAPS =record
    		            hDevice:TDXGI_DDI_HDEVICE;			//in
    pGammaCapabilities :PDXGI_GAMMA_CONTROL_CAPABILITIES; //in/out
end;
PDXGI_DDI_ARG_GET_GAMMA_CONTROL_CAPS = ^TDXGI_DDI_ARG_GET_GAMMA_CONTROL_CAPS;

tTDXGI_DDI_ARG_SET_GAMMA_CONTROL =record
    		            hDevice:TDXGI_DDI_HDEVICE;			//in
                      GammaControl:TDXGI_GAMMA_CONTROL;       //in
end;
PDXGI_DDI_ARG_SET_GAMMA_CONTROL = ^TDXGI_DDI_ARG_SET_GAMMA_CONTROL;

TDXGI_DDI_ARG_SETDISPLAYMODE =record
    		    hDevice:TDXGI_DDI_HDEVICE;			    //in
              hResource:TDXGI_DDI_HRESOURCE;              // Source surface
                            SubResourceIndex:UINT;       // Index of surface level
end;
PDXGI_DDI_ARG_SETDISPLAYMODE = ^TDXGI_DDI_ARG_SETDISPLAYMODE;

TDXGI_DDI_ARG_SETRESOURCEPRIORITY  =record
                hDevice:TDXGI_DDI_HDEVICE;                //in
              hResource:TDXGI_DDI_HRESOURCE;              //in
                            Priority:UINT;               //in
end;
PDXGI_DDI_ARG_SETRESOURCEPRIORITY = ^TDXGI_DDI_ARG_SETRESOURCEPRIORITY;

TDXGI_DDI_ARG_QUERYRESOURCERESIDENCY =record
                hDevice:TDXGI_DDI_HDEVICE;                //in
     pResources :PDXGI_DDI_HRESOURCE;             //in
     pStatus:PDXGI_DDI_RESIDENCY;                //out
                          Resources:SIZE_T;              //in
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
//
//          If rational number with a finite fractional sequence, use denominator of form 10^(length of fractional sequence).
//          If rational number without a finite fractional sequence, or a sequence exceeding the precision allowed by the
//          dynamic range of the denominator, or an irrational number, use an appropriate ratio of integers which best
//          represents the value.
//
TDXGI_DDI_RATIONAL =record
     Numerator:UINT;
     Denominator:UINT;
end;
PDXGI_DDI_RATIONAL = ^TDXGI_DDI_RATIONAL;

//--------------------------------------------------------------------------------------------------------
TDXGI_DDI_MODE_SCANLINE_ORDER =(
    DXGI_DDI_MODE_SCANLINE_ORDER_UNSPECIFIED = 0,
    DXGI_DDI_MODE_SCANLINE_ORDER_PROGRESSIVE = 1,
    DXGI_DDI_MODE_SCANLINE_ORDER_UPPER_FIELD_FIRST = 2,
    DXGI_DDI_MODE_SCANLINE_ORDER_LOWER_FIELD_FIRST = 3);
PDXGI_DDI_MODE_SCANLINE_ORDER = ^TDXGI_DDI_MODE_SCANLINE_ORDER;

TDXGI_DDI_MODE_SCALING=(
    DXGI_DDI_MODE_SCALING_UNSPECIFIED = 0,
    DXGI_DDI_MODE_SCALING_STRETCHED = 1,
    DXGI_DDI_MODE_SCALING_CENTERED = 2);
PDXGI_DDI_MODE_SCALING = ^TDXGI_DDI_MODE_SCALING;

TDXGI_DDI_MODE_ROTATION =(
    DXGI_DDI_MODE_ROTATION_UNSPECIFIED = 0,
    DXGI_DDI_MODE_ROTATION_IDENTITY = 1,
    DXGI_DDI_MODE_ROTATION_ROTATE90 = 2,
    DXGI_DDI_MODE_ROTATION_ROTATE180 = 3,
    DXGI_DDI_MODE_ROTATION_ROTATE270 = 4
);
PDXGI_DDI_MODE_ROTATION = ^TDXGI_DDI_MODE_ROTATION;

TDXGI_DDI_MODE_DESC  =record
     Width:UINT;
     Height:UINT;
     Format:TDXGI_FORMAT;
     RefreshRate:TDXGI_DDI_RATIONAL;
     ScanlineOrdering:TDXGI_DDI_MODE_SCANLINE_ORDER;
     Rotation:TDXGI_DDI_MODE_ROTATION;
     Scaling:TDXGI_DDI_MODE_SCALING;
end;
PDXGI_DDI_MODE_DESC = ^TDXGI_DDI_MODE_DESC;


TDXGI_DDI_PRIMARY_DESC = record
                               Flags:UINT;			// [in]
     VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID;	// [in]
                 ModeDesc:TDXGI_DDI_MODE_DESC;		// [in]
    						   DriverFlags:UINT;		// [out] Filled by the driver
end;
PDXGI_DDI_PRIMARY_DESC = ^TDXGI_DDI_PRIMARY_DESC;

TDXGI_DDI_ARG_BLT_FLAGS = record
    case integer of

    0:( {
        struct
        {
            UINT    Resolve                : 1;     // $00000001
            UINT    Convert                : 1;     // $00000002
            UINT    Stretch                : 1;     // $00000004
            UINT    Present                : 1;     // $00000008
            UINT    Reserved               :28;
        });
     1:(    Value: UINT);

end;
PDXGI_DDI_ARG_BLT_FLAGS = ^TDXGI_DDI_ARG_BLT_FLAGS;

TDXGI_DDI_ARG_BLT = record
                hDevice:DXGI_DDI_HDEVICE;                //in
              hDstResource:TDXGI_DDI_HRESOURCE;           //in
                            DstSubresource:UINT;         //in
                            DstLeft:UINT;                //in
                            DstTop:UINT;                 //in
                            DstRight:UINT;               //in
                            DstBottom:UINT;              //in
              hSrcResource:TDXGI_DDI_HRESOURCE;           //in
                            SrcSubresource:UINT;         //in
          Flags:TDXGI_DDI_ARG_BLT_FLAGS;                  //in
          Rotate:TDXGI_DDI_MODE_ROTATION;                 //in
end;
PDXGI_DDI_ARG_BLT = ^TDXGI_DDI_ARG_BLT;

TDXGI_DDI_ARG_RESOLVESHAREDRESOURCE= record
                hDevice:TDXGI_DDI_HDEVICE;                //in
              hResource:TDXGI_DDI_HRESOURCE;              //in
end;
PDXGI_DDI_ARG_RESOLVESHAREDRESOURCE = ^TDXGI_DDI_ARG_RESOLVESHAREDRESOURCE;

{$IF (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WIN8)}
TDXGI_DDI_ARG_BLT1 = record
                hDevice:TDXGI_DDI_HDEVICE;                //in
              hDstResource:TDXGI_DDI_HRESOURCE;           //in
                            DstSubresource:UINT;         //in
    UINT                        DstLeft;                //in
    UINT                        DstTop;                 //in
    UINT                        DstRight;               //in
    UINT                        DstBottom;              //in
    DXGI_DDI_HRESOURCE          hSrcResource;           //in
    UINT                        SrcSubresource;         //in
    UINT                        SrcLeft;                //in
    UINT                        SrcTop;                 //in
    UINT                        SrcRight;               //in
    UINT                        SrcBottom;              //in
    DXGI_DDI_ARG_BLT_FLAGS      Flags;                  //in
    DXGI_DDI_MODE_ROTATION      Rotate;                 //in
end;
DXGI_DDI_ARG_BLT1;

TDXGI_DDI_ARG_OFFERRESOURCES = record
     hDevice:TDXGI_DDI_HDEVICE;                           //in:  device that created the resources
    pResources :PDXGI_DDI_HRESOURCE;               //in:  array of resources to reset
     Resources:UINT;                                     //in:  number of elements in pResources
     Priority:TD3DDDI_OFFER_PRIORITY;                     //in:  priority with which to reset the resources
    end;
    PDXGI_DDI_ARG_OFFERRESOURCES = ^TDXGI_DDI_ARG_OFFERRESOURCES;

TDXGI_DDI_ARG_RECLAIMRESOURCES = record
     hDevice:TDXGI_DDI_HDEVICE;                           //in:  device that created the resources
     pResources :PDXGI_DDI_HRESOURCE;               //in:  array of resources to reset
     pDiscarded:PBOOLean;                                   //out: optional array of booleans specifying whether each resource was discarded
     Resources:UINT;                                     //in:  number of elements in pResources and pDiscarded
    end; PDXGI_DDI_ARG_RECLAIMRESOURCES = ^TDXGI_DDI_ARG_RECLAIMRESOURCES;

//-----------------------------------------------------------------------------------------------------------
// Multi Plane Overlay DDI
//



 type
TDXGI_DDI_MULTIPLANE_OVERLAY_CAPS = record
     MaxPlanes : UINT;                  // Total number of planes supported (including the DWM's primary)
     NumCapabilityGroups : UINT;        // Number of plane types supported.
    end;
    PDXGI_DDI_MULTIPLANE_OVERLAY_CAPS = ^TDXGI_DDI_MULTIPLANE_OVERLAY_CAPS;


TDXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS=(
    DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_ROTATION_WITHOUT_INDEPENDENT_FLIP = $1,
    DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_VERTICAL_FLIP                     = $2,
    DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_HORIZONTAL_FLIP                   = $4,
    DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_DEINTERLACE                       = $8,
    DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_STEREO                            = $10,    // D3D10 or above only.
    DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_RGB                               = $20,
    DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_YUV                               = $40,
    DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_BILINEAR_FILTER                   = $80,    // Can do bilinear stretching
    DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_HIGH_FILTER                       = $100,   // Can do better than bilinear stretching
    DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_ROTATION                          = $200,
    DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_FULLSCREEN_POST_COMPOSITION       = $400,
    DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_RESERVED1                              = $800,
    DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_SHARED                            = $1000,
    DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_IMMEDIATE                         = $2000,
    DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_PLANE0_FOR_VIRTUAL_MODE_ONLY      = $4000);
PDXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS = ^TDXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS;

TDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_CAPS=(
    DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_CAPS_SEPARATE           = $1,
    DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_CAPS_ROW_INTERLEAVED    = $4,
    DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_CAPS_COLUMN_INTERLEAVED = $8,
    DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_CAPS_CHECKERBOARD       = $10,
    DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_CAPS_FLIP_MODE          = $20);
    PDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_CAPS = ^TDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_CAPS;

TDXGI_DDI_MULTIPLANE_OVERLAY_GROUP_CAPS =record
      NumPlanes:UINT;
     MaxStretchFactor:single;
     MaxShrinkFactor:single;
      OverlayCaps:UINT;       // DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS
      StereoCaps:UINT;        // DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_CAPS
end;
PDXGI_DDI_MULTIPLANE_OVERLAY_GROUP_CAPS = ^TDXGI_DDI_MULTIPLANE_OVERLAY_GROUP_CAPS;

TDXGI_DDI_MULTIPLANE_OVERLAY_FLAGS=(
    DXGI_DDI_MULTIPLANE_OVERLAY_FLAG_VERTICAL_FLIP                 = $1,
    DXGI_DDI_MULTIPLANE_OVERLAY_FLAG_HORIZONTAL_FLIP               = $2,
    DXGI_DDI_MULTIPLANE_OVERLAY_FLAG_FULLSCREEN_POST_COMPOSITION   = $4
);
DXGI_DDI_MULTIPLANE_OVERLAY_FLAGS;

TDXGI_DDI_MULTIPLANE_OVERLAY_BLEND=(
    DXGI_DDI_MULTIPLANE_OVERLAY_BLEND_OPAQUE     = $0,
    DXGI_DDI_MULTIPLANE_OVERLAY_BLEND_ALPHABLEND = $1,
    );
DXGI_DDI_MULTIPLANE_OVERLAY_BLEND;

TDXGI_DDI_MULTIPLANE_OVERLAY_VIDEO_FRAME_FORMAT=(
    DXGI_DDI_MULIIPLANE_OVERLAY_VIDEO_FRAME_FORMAT_PROGRESSIVE                   = 0,
    DXGI_DDI_MULTIPLANE_OVERLAY_VIDEO_FRAME_FORMAT_INTERLACED_TOP_FIELD_FIRST    = 1,
    DXGI_DDI_MULTIPLANE_OVERLAY_VIDEO_FRAME_FORMAT_INTERLACED_BOTTOM_FIELD_FIRST = 2
);
DXGI_DDI_MULTIPLANE_OVERLAY_VIDEO_FRAME_FORMAT;

TDXGI_DDI_MULTIPLANE_OVERLAY_YCbCr_FLAGS=(
    DXGI_DDI_MULTIPLANE_OVERLAY_YCbCr_FLAG_NOMINAL_RANGE = $1, // 16 - 235 vs. 0 - 255
    DXGI_DDI_MULTIPLANE_OVERLAY_YCbCr_FLAG_BT709         = $2, // BT.709 vs. BT.601
    DXGI_DDI_MULTIPLANE_OVERLAY_YCbCr_FLAG_xvYCC         = $4 // xvYCC vs. conventional YCbCr
);
DXGI_DDI_MULTIPLANE_OVERLAY_YCbCr_FLAGS;

TDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT=(
    DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT_MONO               = 0,
    DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT_HORIZONTAL         = 1,
    DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT_VERTICAL           = 2,
    DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT_SEPARATE           = 3,
    DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT_MONO_OFFSET        = 4,
    DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT_ROW_INTERLEAVED    = 5,
    DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT_COLUMN_INTERLEAVED = 6,
    DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT_CHECKERBOARD       = 7
);
DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT;

TDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FLIP_MODE =(
    DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FLIP_NONE   = 0,
    DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FLIP_FRAME0 = 1,
    DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FLIP_FRAME1 = 2,
    );
    DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FLIP_MODE;

TDXGI_DDI_MULTIPLANE_OVERLAY_STRETCH_QUALITY=(
    DXGI_DDI_MULTIPLANE_OVERLAY_STRETCH_QUALITY_BILINEAR        = $1,  // Bilinear
    DXGI_DDI_MULTIPLANE_OVERLAY_STRETCH_QUALITY_HIGH            = $2,  // Maximum
    );
    DXGI_DDI_MULTIPLANE_OVERLAY_STRETCH_QUALITY;

TDXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES=record
    UINT                                           Flags;      // DXGI_DDI_MULTIPLANE_OVERLAY_FLAGS
    RECT                                           SrcRect;
    RECT                                           DstRect;
{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM1_3) // M1
    RECT                                           ClipRect;
{$endif}
    DXGI_DDI_MODE_ROTATION                         Rotation;
    DXGI_DDI_MULTIPLANE_OVERLAY_BLEND              Blend;
{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM1_3) // MP
    UINT                                           DirtyRectCount;
    RECT*                                          pDirtyRects;
{$else}
    UINT                                           NumFilters;
    void*                                          pFilters;
{$endif}
    DXGI_DDI_MULTIPLANE_OVERLAY_VIDEO_FRAME_FORMAT VideoFrameFormat;
    UINT                                           YCbCrFlags; // DXGI_DDI_MULTIPLANE_OVERLAY_YCbCr_FLAGS
    DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT      StereoFormat;
    BOOL                                           StereoLeftViewFrame0;
    BOOL                                           StereoBaseViewFrame0;
    DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FLIP_MODE   StereoFlipMode;
{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM1_3) // M1
    DXGI_DDI_MULTIPLANE_OVERLAY_STRETCH_QUALITY    StretchQuality;
{$endif}
end;
DXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES;


TDXGI_DDI_ARG_GETMULTIPLANEOVERLAYCAPS=record
    DXGI_DDI_HDEVICE                       hDevice;
    D3DDDI_VIDEO_PRESENT_SOURCE_ID         VidPnSourceId;
    DXGI_DDI_MULTIPLANE_OVERLAY_CAPS       MultiplaneOverlayCaps;
} DXGI_DDI_ARG_GETMULTIPLANEOVERLAYCAPS;

TDXGI_DDI_ARG_GETMULTIPLANEOVERLAYGROUPCAPS=record
    DXGI_DDI_HDEVICE                        hDevice;
    D3DDDI_VIDEO_PRESENT_SOURCE_ID          VidPnSourceId;
    UINT                                    GroupIndex;
    DXGI_DDI_MULTIPLANE_OVERLAY_GROUP_CAPS  MultiplaneOverlayGroupCaps;
} DXGI_DDI_ARG_GETMULTIPLANEOVERLAYGROUPCAPS;

TDXGI_DDI_CHECK_MULTIPLANEOVERLAYSUPPORT_PLANE_INFO=record
    DXGI_DDI_HRESOURCE                     hResource;
    UINT                                   SubResourceIndex;
    DXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES PlaneAttributes;
} DXGI_DDI_CHECK_MULTIPLANE_OVERLAY_SUPPORT_PLANE_INFO;

TDXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYSUPPORT =record
    DXGI_DDI_HDEVICE                                      hDevice;
    D3DDDI_VIDEO_PRESENT_SOURCE_ID                        VidPnSourceId;
    UINT                                                  NumPlaneInfo;
    DXGI_DDI_CHECK_MULTIPLANE_OVERLAY_SUPPORT_PLANE_INFO* pPlaneInfo;
    BOOL                                                  Supported; // out: driver to fill TRUE/FALSE
end;
DXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYSUPPORT;

TDXGI_DDI_PRESENT_MULTIPLANE_OVERLAY =record
    UINT                                 LayerIndex;
    BOOL                                 Enabled;
    DXGI_DDI_HRESOURCE                   hResource;
    UINT                                 SubResourceIndex;
    DXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES PlaneAttributes;
    end;  DXGI_DDI_PRESENT_MULTIPLANE_OVERLAY;

TDXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY=record
    DXGI_DDI_HDEVICE                     hDevice;
    void *                               pDXGIContext;

    D3DDDI_VIDEO_PRESENT_SOURCE_ID       VidPnSourceId;
    DXGI_DDI_PRESENT_FLAGS               Flags;
    DXGI_DDI_FLIP_INTERVAL_TYPE          FlipInterval;

    UINT                                 PresentPlaneCount;
    DXGI_DDI_PRESENT_MULTIPLANE_OVERLAY* pPresentPlanes;
{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM1_3) // M1
    UINT                                 Reserved;
{$endif}
end;  DXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY;

{$endif} // (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WIN8)

{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM1_3)} // M1

TDXGI_DDI_ARG_CHECKPRESENTDURATIONSUPPORT=record
    DXGI_DDI_HDEVICE                hDevice;
    D3DDDI_VIDEO_PRESENT_SOURCE_ID  VidPnSourceId;
    UINT                            DesiredPresentDuration;
    UINT                            ClosestSmallerDuration;  // out
    UINT                            ClosestLargerDuration;   //out
    end;  DXGI_DDI_ARG_CHECKPRESENTDURATIONSUPPORT;

TDXGI_DDI_ARG_PRESENTSURFACE=record
    DXGI_DDI_HRESOURCE hSurface;         // In
    UINT               SubResourceIndex; // Index of surface level
    end;  DXGI_DDI_ARG_PRESENTSURFACE;

TDXGI_DDI_ARG_PRESENT1=record
    DXGI_DDI_HDEVICE                   hDevice;             //in
    CONST DXGI_DDI_ARG_PRESENTSURFACE* phSurfacesToPresent; //in
    UINT                               SurfacesToPresent;   //in
    DXGI_DDI_HRESOURCE                 hDstResource;        // if non-zero, it's the destination of the present
    UINT                               DstSubResourceIndex; // Index of surface level
    void *                             pDXGIContext;        // opaque: Pass this to the Present callback
    DXGI_DDI_PRESENT_FLAGS             Flags;               // Presentation flags.
    DXGI_DDI_FLIP_INTERVAL_TYPE        FlipInterval;        // Presentation interval (flip only)
    UINT                               Reserved;
    CONST RECT*                        pDirtyRects;         // in: Array of dirty rects
    UINT                               DirtyRects;          // in: Number of dirty rects

{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_0)
    // out: for LDA only.
    // Only WDDM2.0 drivers should write this value
    // The number of physical back buffer per logical back buffer.
    UINT                               BackBufferMultiplicity;
{$endif}

end;  DXGI_DDI_ARG_PRESENT1;

{$endif} // (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM1_3) // M1

{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_0)}

TDXGI_DDI_ARG_TRIMRESIDENCYSET=record
    DXGI_DDI_HDEVICE                hDevice;
    D3DDDI_TRIMRESIDENCYSET_FLAGS   TrimFlags;
    UINT64                          NumBytesToTrim;
    end;  DXGI_DDI_ARG_TRIMRESIDENCYSET;

TDXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYCOLORSPACESUPPORT=record
    DXGI_DDI_HDEVICE                hDevice;
    D3DDDI_VIDEO_PRESENT_SOURCE_ID  VidPnSourceId;
    DXGI_FORMAT                     Format;
    D3DDDI_COLOR_SPACE_TYPE         ColorSpace;
    BOOL                            Supported;      // out
    end; DXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYCOLORSPACESUPPORT;

typedef struct DXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES1=record
    UINT                                           Flags;   // DXGI_DDI_MULTIPLANE_OVERLAY_FLAGS
    RECT                                           SrcRect;
    RECT                                           DstRect;
    RECT                                           ClipRect;
    DXGI_DDI_MODE_ROTATION                         Rotation;
    DXGI_DDI_MULTIPLANE_OVERLAY_BLEND              Blend;
    UINT                                           DirtyRectCount;
    RECT*                                          pDirtyRects;
    DXGI_DDI_MULTIPLANE_OVERLAY_VIDEO_FRAME_FORMAT VideoFrameFormat;
    D3DDDI_COLOR_SPACE_TYPE                        ColorSpace;
    DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT      StereoFormat;
    BOOL                                           StereoLeftViewFrame0;
    BOOL                                           StereoBaseViewFrame0;
    DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FLIP_MODE   StereoFlipMode;
    DXGI_DDI_MULTIPLANE_OVERLAY_STRETCH_QUALITY    StretchQuality;
    UINT                                           ColorKey;
} DXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES1;

TDXGI_DDI_PRESENT_MULTIPLANE_OVERLAY1=record
    UINT                                    LayerIndex;
    BOOL                                    Enabled;
    DXGI_DDI_HRESOURCE                      hResource;
    UINT                                    SubResourceIndex;
    DXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES1 PlaneAttributes;
} DXGI_DDI_PRESENT_MULTIPLANE_OVERLAY1;

TDXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY1 =record
    DXGI_DDI_HDEVICE                      hDevice;
    void *                                pDXGIContext;

    D3DDDI_VIDEO_PRESENT_SOURCE_ID        VidPnSourceId;
    DXGI_DDI_PRESENT_FLAGS                Flags;
    DXGI_DDI_FLIP_INTERVAL_TYPE           FlipInterval;

    UINT                                  PresentPlaneCount;
    DXGI_DDI_PRESENT_MULTIPLANE_OVERLAY1* pPresentPlanes;
end;  DXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY1;

{$endif} // (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_0)

{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_1_1)}

TDXGI_DDI_ARG_OFFERRESOURCES1=record
    _In_ DXGI_DDI_HDEVICE hDevice;                                 //in:  device that created the resources
    _In_reads_(Resources) const DXGI_DDI_HRESOURCE* pResources;    //in:  array of resources to reset
    _In_ UINT Resources;                                           //in:  number of elements in pResources
    _In_ D3DDDI_OFFER_PRIORITY Priority;                           //in:  priority with which to reset the resources
    _In_ D3DDDI_OFFER_FLAGS Flags;                                 //in:  flags specifying additional behaviors on offer
end;
DXGI_DDI_ARG_OFFERRESOURCES1;

{$endif} // (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_1_1)

{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_1_2)}

TDXGI_DDI_ARG_RECLAIMRESOURCES1=record
    DXGI_DDI_HDEVICE hDevice;                           //in:  device that created the resources
    const DXGI_DDI_HRESOURCE *pResources;               //in:  array of resources to reset
    D3DDDI_RECLAIM_RESULT *pResults;                    //out: array of results specifying whether each resource was
                                                        //     successfully reclaimed, discarded, or has no commitment
    UINT Resources;                                     //in:  number of elements in pResources and pDiscarded
end;  DXGI_DDI_ARG_RECLAIMRESOURCES1;

{$endif} // (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_1_2)

//--------------------------------------------------------------------------------------------------------
typedef struct DXGI_DDI_BASE_FUNCTIONS =record
    HRESULT ( __stdcall /*APIENTRY*/ * pfnPresent )               (DXGI_DDI_ARG_PRESENT*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnGetGammaCaps )          (DXGI_DDI_ARG_GET_GAMMA_CONTROL_CAPS*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnSetDisplayMode )        (DXGI_DDI_ARG_SETDISPLAYMODE*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnSetResourcePriority )   (DXGI_DDI_ARG_SETRESOURCEPRIORITY*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnQueryResourceResidency )(DXGI_DDI_ARG_QUERYRESOURCERESIDENCY*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnRotateResourceIdentities )(DXGI_DDI_ARG_ROTATE_RESOURCE_IDENTITIES*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnBlt                    )(DXGI_DDI_ARG_BLT*);
end; DXGI_DDI_BASE_FUNCTIONS;

//--------------------------------------------------------------------------------------------------------
TDXGI1_1_DDI_BASE_FUNCTIONS=record
    HRESULT ( __stdcall /*APIENTRY*/ * pfnPresent )               (DXGI_DDI_ARG_PRESENT*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnGetGammaCaps )          (DXGI_DDI_ARG_GET_GAMMA_CONTROL_CAPS*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnSetDisplayMode )        (DXGI_DDI_ARG_SETDISPLAYMODE*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnSetResourcePriority )   (DXGI_DDI_ARG_SETRESOURCEPRIORITY*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnQueryResourceResidency )(DXGI_DDI_ARG_QUERYRESOURCERESIDENCY*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnRotateResourceIdentities )(DXGI_DDI_ARG_ROTATE_RESOURCE_IDENTITIES*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnBlt                    )(DXGI_DDI_ARG_BLT*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnResolveSharedResource ) (DXGI_DDI_ARG_RESOLVESHAREDRESOURCE*);
end; DXGI1_1_DDI_BASE_FUNCTIONS;

{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WIN8)}

//--------------------------------------------------------------------------------------------------------
TDXGI1_2_DDI_BASE_FUNCTIONS=record
    HRESULT ( __stdcall /*APIENTRY*/ * pfnPresent )               (DXGI_DDI_ARG_PRESENT*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnGetGammaCaps )          (DXGI_DDI_ARG_GET_GAMMA_CONTROL_CAPS*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnSetDisplayMode )        (DXGI_DDI_ARG_SETDISPLAYMODE*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnSetResourcePriority )   (DXGI_DDI_ARG_SETRESOURCEPRIORITY*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnQueryResourceResidency )(DXGI_DDI_ARG_QUERYRESOURCERESIDENCY*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnRotateResourceIdentities )(DXGI_DDI_ARG_ROTATE_RESOURCE_IDENTITIES*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnBlt                    )(DXGI_DDI_ARG_BLT*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnResolveSharedResource ) (DXGI_DDI_ARG_RESOLVESHAREDRESOURCE*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnBlt1 )	              (DXGI_DDI_ARG_BLT1*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnOfferResources )        (DXGI_DDI_ARG_OFFERRESOURCES*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnReclaimResources )      (DXGI_DDI_ARG_RECLAIMRESOURCES*);
    // Use IS_DXGI_MULTIPLANE_OVERLAY_FUNCTIONS macro to determine these functions fields are available
    HRESULT ( __stdcall /*APIENTRY*/ * pfnGetMultiplaneOverlayCaps )        (DXGI_DDI_ARG_GETMULTIPLANEOVERLAYCAPS*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnGetMultiplaneOverlayFilterRange ) (void*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnCheckMultiplaneOverlaySupport )   (DXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYSUPPORT*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnPresentMultiplaneOverlay )        (DXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY*);
end; DXGI1_2_DDI_BASE_FUNCTIONS;

{$endif}

{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM1_3)} // M1

//--------------------------------------------------------------------------------------------------------
TDXGI1_3_DDI_BASE_FUNCTIONS=record
    HRESULT ( __stdcall /*APIENTRY*/ * pfnPresent )               (DXGI_DDI_ARG_PRESENT*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnGetGammaCaps )          (DXGI_DDI_ARG_GET_GAMMA_CONTROL_CAPS*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnSetDisplayMode )        (DXGI_DDI_ARG_SETDISPLAYMODE*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnSetResourcePriority )   (DXGI_DDI_ARG_SETRESOURCEPRIORITY*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnQueryResourceResidency )(DXGI_DDI_ARG_QUERYRESOURCERESIDENCY*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnRotateResourceIdentities )(DXGI_DDI_ARG_ROTATE_RESOURCE_IDENTITIES*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnBlt                    )(DXGI_DDI_ARG_BLT*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnResolveSharedResource ) (DXGI_DDI_ARG_RESOLVESHAREDRESOURCE*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnBlt1 )                  (DXGI_DDI_ARG_BLT1*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnOfferResources )        (DXGI_DDI_ARG_OFFERRESOURCES*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnReclaimResources )      (DXGI_DDI_ARG_RECLAIMRESOURCES*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnGetMultiplaneOverlayCaps )        (DXGI_DDI_ARG_GETMULTIPLANEOVERLAYCAPS*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnGetMultiplaneOverlayGroupCaps )   (DXGI_DDI_ARG_GETMULTIPLANEOVERLAYGROUPCAPS*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnReserved1 )                       (void*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnPresentMultiplaneOverlay )        (DXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnReserved2 )                       (void*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnPresent1 )                        (DXGI_DDI_ARG_PRESENT1*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnCheckPresentDurationSupport )     (DXGI_DDI_ARG_CHECKPRESENTDURATIONSUPPORT*);
end; DXGI1_3_DDI_BASE_FUNCTIONS;

{$endif}

{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_0)}

//--------------------------------------------------------------------------------------------------------
typedef struct DXGI1_4_DDI_BASE_FUNCTIONS=record
    HRESULT ( __stdcall /*APIENTRY*/ * pfnPresent )               (DXGI_DDI_ARG_PRESENT*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnGetGammaCaps )          (DXGI_DDI_ARG_GET_GAMMA_CONTROL_CAPS*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnSetDisplayMode )        (DXGI_DDI_ARG_SETDISPLAYMODE*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnSetResourcePriority )   (DXGI_DDI_ARG_SETRESOURCEPRIORITY*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnQueryResourceResidency )(DXGI_DDI_ARG_QUERYRESOURCERESIDENCY*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnRotateResourceIdentities )(DXGI_DDI_ARG_ROTATE_RESOURCE_IDENTITIES*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnBlt                    )(DXGI_DDI_ARG_BLT*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnResolveSharedResource ) (DXGI_DDI_ARG_RESOLVESHAREDRESOURCE*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnBlt1 )                  (DXGI_DDI_ARG_BLT1*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnOfferResources )        (DXGI_DDI_ARG_OFFERRESOURCES*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnReclaimResources )      (DXGI_DDI_ARG_RECLAIMRESOURCES*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnGetMultiplaneOverlayCaps )        (DXGI_DDI_ARG_GETMULTIPLANEOVERLAYCAPS*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnGetMultiplaneOverlayGroupCaps )   (DXGI_DDI_ARG_GETMULTIPLANEOVERLAYGROUPCAPS*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnReserved1 )                       (void*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnPresentMultiplaneOverlay )        (DXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnReserved2 )                       (void*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnPresent1 )                        (DXGI_DDI_ARG_PRESENT1*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnCheckPresentDurationSupport )     (DXGI_DDI_ARG_CHECKPRESENTDURATIONSUPPORT*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnTrimResidencySet )                (DXGI_DDI_ARG_TRIMRESIDENCYSET*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnCheckMultiplaneOverlayColorSpaceSupport )     (DXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYCOLORSPACESUPPORT*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnPresentMultiplaneOverlay1 )        (DXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY1*);
    end; DXGI1_4_DDI_BASE_FUNCTIONS;

{$endif}

{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_1_1)}

//--------------------------------------------------------------------------------------------------------
TDXGI1_5_DDI_BASE_FUNCTIONS=record
    HRESULT ( __stdcall /*APIENTRY*/ * pfnPresent )               (DXGI_DDI_ARG_PRESENT*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnGetGammaCaps )          (DXGI_DDI_ARG_GET_GAMMA_CONTROL_CAPS*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnSetDisplayMode )        (DXGI_DDI_ARG_SETDISPLAYMODE*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnSetResourcePriority )   (DXGI_DDI_ARG_SETRESOURCEPRIORITY*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnQueryResourceResidency )(DXGI_DDI_ARG_QUERYRESOURCERESIDENCY*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnRotateResourceIdentities )(DXGI_DDI_ARG_ROTATE_RESOURCE_IDENTITIES*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnBlt                    )(DXGI_DDI_ARG_BLT*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnResolveSharedResource ) (DXGI_DDI_ARG_RESOLVESHAREDRESOURCE*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnBlt1 )                  (DXGI_DDI_ARG_BLT1*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnOfferResources1 )       (DXGI_DDI_ARG_OFFERRESOURCES1*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnReclaimResources )      (DXGI_DDI_ARG_RECLAIMRESOURCES*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnGetMultiplaneOverlayCaps )        (DXGI_DDI_ARG_GETMULTIPLANEOVERLAYCAPS*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnGetMultiplaneOverlayGroupCaps )   (DXGI_DDI_ARG_GETMULTIPLANEOVERLAYGROUPCAPS*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnReserved1 )                       (void*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnPresentMultiplaneOverlay )        (DXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnReserved2 )                       (void*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnPresent1 )                        (DXGI_DDI_ARG_PRESENT1*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnCheckPresentDurationSupport )     (DXGI_DDI_ARG_CHECKPRESENTDURATIONSUPPORT*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnTrimResidencySet )                (DXGI_DDI_ARG_TRIMRESIDENCYSET*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnCheckMultiplaneOverlayColorSpaceSupport )     (DXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYCOLORSPACESUPPORT*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnPresentMultiplaneOverlay1 )        (DXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY1*);
    HRESULT ( __stdcall /*APIENTRY*/ * pfnReclaimResources1 )      (DXGI_DDI_ARG_RECLAIMRESOURCES1*);
    end; DXGI1_5_DDI_BASE_FUNCTIONS;

{$endif}


//========================================================================================================
// DXGI callback definitions.
//


//--------------------------------------------------------------------------------------------------------
TDXGIDDICB_PRESENT =record
    D3DKMT_HANDLE   hSrcAllocation;             // in: The allocation of which content will be presented
    D3DKMT_HANDLE   hDstAllocation;             // in: if non-zero, it's the destination allocation of the present
    void *          pDXGIContext;               // opaque: Fill this with the value in DXGI_DDI_ARG_PRESENT.pDXGIContext
    HANDLE          hContext;                   // in: Context being submitted to.
    UINT            BroadcastContextCount;      // in: Specifies the number of context
                                                //     to broadcast this present operation to.
                                                //     Only supported for flip operation.
    HANDLE          BroadcastContext[D3DDDI_MAX_BROADCAST_CONTEXT]; // in: Specifies the handle of the context to
                                                                    //     broadcast to.
{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_0)
    _Field_size_(BroadcastContextCount)
    D3DKMT_HANDLE*              BroadcastSrcAllocation;                         // in: LDA
    _Field_size_opt_(BroadcastContextCount)
    D3DKMT_HANDLE*              BroadcastDstAllocation;                         // in: LDA
    UINT                        PrivateDriverDataSize;                          // in:
    _Field_size_bytes_(PrivateDriverDataSize)
    PVOID                       pPrivateDriverData;                             // in: Private driver data to pass to DdiPresent and DdiSetVidPnSourceAddress
    BOOLEAN                     bOptimizeForComposition;                        // out: DWM is involved in composition
{$endif} // (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_0)

end;  DXGIDDICB_PRESENT;

{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WIN8)}
TDXGIDDI_MULTIPLANE_OVERLAY_ALLOCATION_INFO =record
    D3DKMT_HANDLE PresentAllocation;
    UINT SubResourceIndex;
    end;  DXGIDDI_MULTIPLANE_OVERLAY_ALLOCATION_INFO;

TDXGIDDICB_PRESENT_MULTIPLANE_OVERLAY=record
    void *          pDXGIContext;               // opaque: Fill this with the value in DXGI_DDI_ARG_PRESENT.pDXGIContext
    HANDLE          hContext;

    UINT            BroadcastContextCount;
    HANDLE          BroadcastContext[D3DDDI_MAX_BROADCAST_CONTEXT];

    DWORD           AllocationInfoCount;
    DXGIDDI_MULTIPLANE_OVERLAY_ALLOCATION_INFO AllocationInfo[DXGI_DDI_MAX_MULTIPLANE_OVERLAY_ALLOCATIONS];
    end;  DXGIDDICB_PRESENT_MULTIPLANE_OVERLAY;
{$endif} // (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WIN8)


typedef _Check_return_ HRESULT (APIENTRY CALLBACK *PFNDDXGIDDI_PRESENTCB)(
        _In_ HANDLE hDevice, _In_ DXGIDDICB_PRESENT*);

{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WIN8)}
typedef _Check_return_ HRESULT (APIENTRY CALLBACK *PFNDDXGIDDI_PRESENT_MULTIPLANE_OVERLAYCB)(
        _In_ HANDLE hDevice, _In_ CONST DXGIDDICB_PRESENT_MULTIPLANE_OVERLAY*);
{$endif} // (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WIN8)

//--------------------------------------------------------------------------------------------------------
TDXGI_DDI_BASE_CALLBACKS=record
    PFNDDXGIDDI_PRESENTCB                pfnPresentCb;
{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WIN8)
    // Use IS_DXGI_MULTIPLANE_OVERLAY_FUNCTIONS macro to check if field is available.
    PFNDDXGIDDI_PRESENT_MULTIPLANE_OVERLAYCB pfnPresentMultiplaneOverlayCb;
{$endif} // (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WIN8)
end;  DXGI_DDI_BASE_CALLBACKS;

//========================================================================================================
// DXGI basic DDI device creation arguments

TDXGI_DDI_BASE_ARGS= record
    DXGI_DDI_BASE_CALLBACKS *pDXGIBaseCallbacks;            // in: The driver should record this pointer for later use
    case integer Of
{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_1_1)}
        DXGI1_5_DDI_BASE_FUNCTIONS *pDXGIDDIBaseFunctions6; // in/out: The driver should fill the denoted struct with DXGI base driver entry points
{$endif}
{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_0)}
        DXGI1_4_DDI_BASE_FUNCTIONS *pDXGIDDIBaseFunctions5; // in/out: The driver should fill the denoted struct with DXGI base driver entry points
{$endif}
{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM1_3)} // M1
        DXGI1_3_DDI_BASE_FUNCTIONS *pDXGIDDIBaseFunctions4; // in/out: The driver should fill the denoted struct with DXGI base driver entry points
{$endif}
{$if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WIN8)}
        DXGI1_2_DDI_BASE_FUNCTIONS *pDXGIDDIBaseFunctions3; // in/out: The driver should fill the denoted struct with DXGI base driver entry points
{$endif}
        DXGI1_1_DDI_BASE_FUNCTIONS *pDXGIDDIBaseFunctions2; // in/out: The driver should fill the denoted struct with DXGI base driver entry points
        DXGI_DDI_BASE_FUNCTIONS *pDXGIDDIBaseFunctions;     // in/out: The driver should fill the denoted struct with DXGI base driver entry points
    };
end;
PDXGI_DDI_BASE_ARGS =^TDXGI_DDI_BASE_ARGS;




implementation

end.

