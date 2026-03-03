
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

   Copyright (C) Microsoft Corporation.  All Rights Reserved.
   Content: DXGI Basic Device Driver Interface Definitions

   This unit consists of the following header files
   File name: dxgiddi.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.DXGIDDI;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

{$DEFINE D3D_UMD_INTERFACE_VERSION_WIN8}
{$DEFINE D3D_UMD_INTERFACE_VERSION_WDDM1_3}
{$DEFINE D3D_UMD_INTERFACE_VERSION_WDDM2_0}
{$DEFINE D3D_UMD_INTERFACE_VERSION_WDDM2_2}
{$DEFINE D3D_UMD_INTERFACE_VERSION_WDDM2_2_1}
{$DEFINE D3D_UMD_INTERFACE_VERSION_WDDM2_2_2}
{$DEFINE D3D_UMD_INTERFACE_VERSION_WDDM2_4_2}
{$DEFINE D3D_UMD_INTERFACE_VERSION_WDDM2_5_2}
{$DEFINE D3D_UMD_INTERFACE_VERSION_WDDM2_6_2}
{$DEFINE D3D_UMD_INTERFACE_VERSION_WDDM2_6_3}


uses
    Windows, Classes, SysUtils,
    DX12.DXGI, DX12.DXGIType,
    DX12.DXGIFormat,
    DX12.D3DUKMDT;

    {$Z4}

const
    //--------------------------------------------------------------------------------------------------------
    // DXGI error codes
    //--------------------------------------------------------------------------------------------------------
    _FACDXGI_DDI = $87b;

    // DXGI DDI error codes have moved to winerror.h


    // Bit indicates that UMD has the option to prevent this Resource from ever being a Primary
    // UMD can prevent the actual flip (from optional primary to regular primary) and use a copy
    // operation, during Present. Thus, it's possible the UMD can opt out of this Resource being
    // actually used as a primary.
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

    DXGI_DDI_MAX_MULTIPLANE_OVERLAY_ALLOCATIONS = 16;

type


    //========================================================================================================
    // This is the standard DDI that any DXGI-enabled user-mode driver should support

    //--------------------------------------------------------------------------------------------------------

    TDXGI_DDI_HDEVICE = UINT_PTR;
    PDXGI_DDI_HDEVICE = ^TDXGI_DDI_HDEVICE;

    TDXGI_DDI_HRESOURCE = UINT_PTR;
    PDXGI_DDI_HRESOURCE = ^TDXGI_DDI_HRESOURCE;

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
    TDXGI_DDI_PRESENT_FLAGS = bitpacked record
        case integer of
            0: (
                Blt: 0..1; // 0x00000001
                Flip: 0..1; // 0x00000002
                PreferRight: 0..1; // 0x00000004
                TemporaryMono: 0..1; // 0x00000008
                AllowTearing: 0..1; // 0x00000010
                AllowFlexibleRefresh: 0..1; // 0x00000020
                NoScanoutTransform: 0..1; // 0x00000040
                Reserved: 0..33554431;

            );
            1: (
                Value: UINT;
            );
    end;
    PDXGI_DDI_PRESENT_FLAGS = ^TDXGI_DDI_PRESENT_FLAGS;


    //--------------------------------------------------------------------------------------------------------
    TDXGI_DDI_ARG_PRESENT = record
        hDevice: TDXGI_DDI_HDEVICE; //in
        hSurfaceToPresent: TDXGI_DDI_HRESOURCE; //in
        SrcSubResourceIndex: UINT; // Index of surface level
        hDstResource: TDXGI_DDI_HRESOURCE; // if non-zero, it's the destination of the present
        DstSubResourceIndex: UINT; // Index of surface level
        pDXGIContext: Pvoid; // opaque: Pass this to the Present callback
        Flags: TDXGI_DDI_PRESENT_FLAGS; // Presentation flags.
        FlipInterval: TDXGI_DDI_FLIP_INTERVAL_TYPE; // Presentation interval (flip only)
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
        hDevice: TDXGI_DDI_HDEVICE; //in
        pGammaCapabilities: PDXGI_GAMMA_CONTROL_CAPABILITIES; //in/out
    end;
    PDXGI_DDI_ARG_GET_GAMMA_CONTROL_CAPS = ^TDXGI_DDI_ARG_GET_GAMMA_CONTROL_CAPS;


    TDXGI_DDI_ARG_SET_GAMMA_CONTROL = record
        hDevice: TDXGI_DDI_HDEVICE; //in
        GammaControl: TDXGI_GAMMA_CONTROL; //in
    end;
    PDXGI_DDI_ARG_SET_GAMMA_CONTROL = ^TDXGI_DDI_ARG_SET_GAMMA_CONTROL;


    TDXGI_DDI_ARG_SETDISPLAYMODE = record
        hDevice: TDXGI_DDI_HDEVICE; //in
        hResource: TDXGI_DDI_HRESOURCE; // Source surface
        SubResourceIndex: UINT; // Index of surface level
    end;
    PDXGI_DDI_ARG_SETDISPLAYMODE = ^TDXGI_DDI_ARG_SETDISPLAYMODE;


    TDXGI_DDI_ARG_SETRESOURCEPRIORITY = record
        hDevice: TDXGI_DDI_HDEVICE; //in
        hResource: TDXGI_DDI_HRESOURCE; //in
        Priority: UINT; //in
    end;
    PDXGI_DDI_ARG_SETRESOURCEPRIORITY = ^TDXGI_DDI_ARG_SETRESOURCEPRIORITY;


    TDXGI_DDI_ARG_QUERYRESOURCERESIDENCY = record
        hDevice: TDXGI_DDI_HDEVICE; //in
        {_Field_size_( Resources ) } pResources: PDXGI_DDI_HRESOURCE; //in
        {_Field_size_( Resources ) } pStatus: PDXGI_DDI_RESIDENCY; //out
        Resources: SIZE_T; //in
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
        Flags: UINT; // [in]
        VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID; // [in]
        ModeDesc: TDXGI_DDI_MODE_DESC; // [in]
        DriverFlags: UINT; // [out] Filled by the driver
    end;
    PDXGI_DDI_PRIMARY_DESC = ^TDXGI_DDI_PRIMARY_DESC;


    TDXGI_DDI_ARG_BLT_FLAGS = bitpacked record
        case integer of
            0: (
                Resolve: 0..1; // 0x00000001
                Convert: 0..1; // 0x00000002
                Stretch: 0..1; // 0x00000004
                Present: 0..1; // 0x00000008
                Reserved: 0..268435455;

            );
            1: (
                Value: UINT;
            );
    end;
    PDXGI_DDI_ARG_BLT_FLAGS = ^TDXGI_DDI_ARG_BLT_FLAGS;


    TDXGI_DDI_ARG_BLT = record
        hDevice: TDXGI_DDI_HDEVICE; //in
        hDstResource: TDXGI_DDI_HRESOURCE; //in
        DstSubresource: UINT; //in
        DstLeft: UINT; //in
        DstTop: UINT; //in
        DstRight: UINT; //in
        DstBottom: UINT; //in
        hSrcResource: TDXGI_DDI_HRESOURCE; //in
        SrcSubresource: UINT; //in
        Flags: TDXGI_DDI_ARG_BLT_FLAGS; //in
        Rotate: TDXGI_DDI_MODE_ROTATION; //in
    end;
    PDXGI_DDI_ARG_BLT = ^TDXGI_DDI_ARG_BLT;


    TDXGI_DDI_ARG_RESOLVESHAREDRESOURCE = record
        hDevice: TDXGI_DDI_HDEVICE; //in
        hResource: TDXGI_DDI_HRESOURCE; //in
    end;
    PDXGI_DDI_ARG_RESOLVESHAREDRESOURCE = ^TDXGI_DDI_ARG_RESOLVESHAREDRESOURCE;


    //{$IF (D3D_UMD_INTERFACE_VERSION>=D3D_UMD_INTERFACE_VERSION_WIN8)}
    TDXGI_DDI_ARG_BLT1 = record
        hDevice: TDXGI_DDI_HDEVICE; //in
        hDstResource: TDXGI_DDI_HRESOURCE; //in
        DstSubresource: UINT; //in
        DstLeft: UINT; //in
        DstTop: UINT; //in
        DstRight: UINT; //in
        DstBottom: UINT; //in
        hSrcResource: TDXGI_DDI_HRESOURCE; //in
        SrcSubresource: UINT; //in
        SrcLeft: UINT; //in
        SrcTop: UINT; //in
        SrcRight: UINT; //in
        SrcBottom: UINT; //in
        Flags: TDXGI_DDI_ARG_BLT_FLAGS; //in
        Rotate: TDXGI_DDI_MODE_ROTATION; //in
    end;
    PDXGI_DDI_ARG_BLT1 = ^TDXGI_DDI_ARG_BLT1;


    _DXGI_DDI_ARG_OFFERRESOURCES = record
        hDevice: TDXGI_DDI_HDEVICE; //in:  device that created the resources
        pResources: PDXGI_DDI_HRESOURCE; //in:  array of resources to reset
        Resources: UINT; //in:  number of elements in pResources
        Priority: TD3DDDI_OFFER_PRIORITY; //in:  priority with which to reset the resources
    end;
    TDXGI_DDI_ARG_OFFERRESOURCES = _DXGI_DDI_ARG_OFFERRESOURCES;
    PDXGI_DDI_ARG_OFFERRESOURCES = ^TDXGI_DDI_ARG_OFFERRESOURCES;


    _DXGI_DDI_ARG_RECLAIMRESOURCES = record
        hDevice: TDXGI_DDI_HDEVICE; //in:  device that created the resources
        pResources: PDXGI_DDI_HRESOURCE; //in:  array of resources to reset
        pDiscarded: Pboolean; //out: optional array of booleans specifying whether each resource was discarded
        Resources: UINT; //in:  number of elements in pResources and pDiscarded
    end;
    TDXGI_DDI_ARG_RECLAIMRESOURCES = _DXGI_DDI_ARG_RECLAIMRESOURCES;
    PDXGI_DDI_ARG_RECLAIMRESOURCES = ^TDXGI_DDI_ARG_RECLAIMRESOURCES;


    //-----------------------------------------------------------------------------------------------------------
    // Multi Plane Overlay DDI


    TDXGI_DDI_MULTIPLANE_OVERLAY_CAPS = record
        MaxPlanes: UINT; // Total number of planes supported (including the DWM's primary)
        NumCapabilityGroups: UINT; // Number of plane types supported.
    end;
    PDXGI_DDI_MULTIPLANE_OVERLAY_CAPS = ^TDXGI_DDI_MULTIPLANE_OVERLAY_CAPS;


    TDXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS = (
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_ROTATION_WITHOUT_INDEPENDENT_FLIP = $1,
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_VERTICAL_FLIP = $2,
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_HORIZONTAL_FLIP = $4,
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_DEINTERLACE = $8,
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_STEREO = $10, // D3D10 or above only.
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_RGB = $20,
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_YUV = $40,
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_BILINEAR_FILTER = $80, // Can do bilinear stretching
        DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS_HIGH_FILTER = $100, // Can do better than bilinear stretching
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
        OverlayCaps: UINT; // DXGI_DDI_MULTIPLANE_OVERLAY_FEATURE_CAPS
        StereoCaps: UINT; // DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_CAPS
    end;
    PDXGI_DDI_MULTIPLANE_OVERLAY_GROUP_CAPS = ^TDXGI_DDI_MULTIPLANE_OVERLAY_GROUP_CAPS;


    TDXGI_DDI_MULTIPLANE_OVERLAY_FLAGS = (
        DXGI_DDI_MULTIPLANE_OVERLAY_FLAG_VERTICAL_FLIP = $1,
        DXGI_DDI_MULTIPLANE_OVERLAY_FLAG_HORIZONTAL_FLIP = $2,
        DXGI_DDI_MULTIPLANE_OVERLAY_FLAG_FULLSCREEN_POST_COMPOSITION = $4,
        DXGI_DDI_MULTIPLANE_OVERLAY_FLAG_NO_SCANOUT_TRANFORMATION = $8,
        DXGI_DDI_MULTIPLANE_OVERLAY_FLAG_NO_RENDER_PRESENT = $10);

    PDXGI_DDI_MULTIPLANE_OVERLAY_FLAGS = ^TDXGI_DDI_MULTIPLANE_OVERLAY_FLAGS;


    TDXGI_DDI_MULTIPLANE_OVERLAY_BLEND = (
        DXGI_DDI_MULTIPLANE_OVERLAY_BLEND_OPAQUE = $0,
        DXGI_DDI_MULTIPLANE_OVERLAY_BLEND_ALPHABLEND = $1);

    PDXGI_DDI_MULTIPLANE_OVERLAY_BLEND = ^TDXGI_DDI_MULTIPLANE_OVERLAY_BLEND;


    TDXGI_DDI_MULTIPLANE_OVERLAY_VIDEO_FRAME_FORMAT = (
        DXGI_DDI_MULIIPLANE_OVERLAY_VIDEO_FRAME_FORMAT_PROGRESSIVE = 0,
        DXGI_DDI_MULTIPLANE_OVERLAY_VIDEO_FRAME_FORMAT_INTERLACED_TOP_FIELD_FIRST = 1,
        DXGI_DDI_MULTIPLANE_OVERLAY_VIDEO_FRAME_FORMAT_INTERLACED_BOTTOM_FIELD_FIRST = 2);

    PDXGI_DDI_MULTIPLANE_OVERLAY_VIDEO_FRAME_FORMAT = ^TDXGI_DDI_MULTIPLANE_OVERLAY_VIDEO_FRAME_FORMAT;


    TDXGI_DDI_MULTIPLANE_OVERLAY_YCbCr_FLAGS = (
        DXGI_DDI_MULTIPLANE_OVERLAY_YCbCr_FLAG_NOMINAL_RANGE = $1, // 16 - 235 vs. 0 - 255
        DXGI_DDI_MULTIPLANE_OVERLAY_YCbCr_FLAG_BT709 = $2, // BT.709 vs. BT.601
        DXGI_DDI_MULTIPLANE_OVERLAY_YCbCr_FLAG_xvYCC = $4// xvYCC vs. conventional YCbCr
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
        DXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FLIP_FRAME1 = 2);

    PDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FLIP_MODE = ^TDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FLIP_MODE;


    TDXGI_DDI_MULTIPLANE_OVERLAY_STRETCH_QUALITY = (
        DXGI_DDI_MULTIPLANE_OVERLAY_STRETCH_QUALITY_BILINEAR = $1, // Bilinear
        DXGI_DDI_MULTIPLANE_OVERLAY_STRETCH_QUALITY_HIGH = $2// Maximum
        );

    PDXGI_DDI_MULTIPLANE_OVERLAY_STRETCH_QUALITY = ^TDXGI_DDI_MULTIPLANE_OVERLAY_STRETCH_QUALITY;


    TDXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES = record
        Flags: UINT; // DXGI_DDI_MULTIPLANE_OVERLAY_FLAGS
        SrcRect: TRECT;
        DstRect: TRECT;
        {$IFDEF D3D_UMD_INTERFACE_VERSION_WDDM1_3}// M1
        ClipRect: TRECT;
        {$ENDIF}

        Rotation: TDXGI_DDI_MODE_ROTATION;
        Blend: TDXGI_DDI_MULTIPLANE_OVERLAY_BLEND;
        {$IFDEF D3D_UMD_INTERFACE_VERSION_WDDM1_3}// MP
        DirtyRectCount: UINT;
        pDirtyRects: PRECT;
        {$ELSE }
   NumFilters : UINT;
   pFilters : Pvoid;
        {$ENDIF}

        VideoFrameFormat: TDXGI_DDI_MULTIPLANE_OVERLAY_VIDEO_FRAME_FORMAT;
        YCbCrFlags: UINT; // DXGI_DDI_MULTIPLANE_OVERLAY_YCbCr_FLAGS
        StereoFormat: TDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FORMAT;
        StereoLeftViewFrame0: boolean;
        StereoBaseViewFrame0: boolean;
        StereoFlipMode: TDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FLIP_MODE;
        {$IFDEF D3D_UMD_INTERFACE_VERSION_WDDM1_3}// M1
        StretchQuality: TDXGI_DDI_MULTIPLANE_OVERLAY_STRETCH_QUALITY;
        {$ENDIF}

    end;
    PDXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES = ^TDXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES;


    _DXGI_DDI_ARG_GETMULTIPLANEOVERLAYCAPS = record
        hDevice: TDXGI_DDI_HDEVICE;
        VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID;
        MultiplaneOverlayCaps: TDXGI_DDI_MULTIPLANE_OVERLAY_CAPS;
    end;
    TDXGI_DDI_ARG_GETMULTIPLANEOVERLAYCAPS = _DXGI_DDI_ARG_GETMULTIPLANEOVERLAYCAPS;
    PDXGI_DDI_ARG_GETMULTIPLANEOVERLAYCAPS = ^TDXGI_DDI_ARG_GETMULTIPLANEOVERLAYCAPS;


    _DXGI_DDI_ARG_GETMULTIPLANEOVERLAYGROUPCAPS = record
        hDevice: TDXGI_DDI_HDEVICE;
        VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID;
        GroupIndex: UINT;
        MultiplaneOverlayGroupCaps: TDXGI_DDI_MULTIPLANE_OVERLAY_GROUP_CAPS;
    end;
    TDXGI_DDI_ARG_GETMULTIPLANEOVERLAYGROUPCAPS = _DXGI_DDI_ARG_GETMULTIPLANEOVERLAYGROUPCAPS;
    PDXGI_DDI_ARG_GETMULTIPLANEOVERLAYGROUPCAPS = ^TDXGI_DDI_ARG_GETMULTIPLANEOVERLAYGROUPCAPS;


    TDXGI_DDI_CHECK_MULTIPLANEOVERLAYSUPPORT_PLANE_INFO = record
        hResource: TDXGI_DDI_HRESOURCE;
        SubResourceIndex: UINT;
        PlaneAttributes: TDXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES;
    end;
    PDXGI_DDI_CHECK_MULTIPLANEOVERLAYSUPPORT_PLANE_INFO = ^TDXGI_DDI_CHECK_MULTIPLANEOVERLAYSUPPORT_PLANE_INFO;

    TDXGI_DDI_CHECK_MULTIPLANE_OVERLAY_SUPPORT_PLANE_INFO = TDXGI_DDI_CHECK_MULTIPLANEOVERLAYSUPPORT_PLANE_INFO;
    PDXGI_DDI_CHECK_MULTIPLANE_OVERLAY_SUPPORT_PLANE_INFO = ^TDXGI_DDI_CHECK_MULTIPLANE_OVERLAY_SUPPORT_PLANE_INFO;

    _DXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYSUPPORT = record
        hDevice: TDXGI_DDI_HDEVICE;
        VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID;
        NumPlaneInfo: UINT;
        pPlaneInfo: PDXGI_DDI_CHECK_MULTIPLANE_OVERLAY_SUPPORT_PLANE_INFO;
        Supported: boolean; // out: driver to fill TRUE/FALSE
    end;
    TDXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYSUPPORT = _DXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYSUPPORT;
    PDXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYSUPPORT = ^TDXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYSUPPORT;


    _DXGI_DDI_PRESENT_MULTIPLANE_OVERLAY = record
        LayerIndex: UINT;
        Enabled: boolean;
        hResource: TDXGI_DDI_HRESOURCE;
        SubResourceIndex: UINT;
        PlaneAttributes: TDXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES;
    end;
    TDXGI_DDI_PRESENT_MULTIPLANE_OVERLAY = _DXGI_DDI_PRESENT_MULTIPLANE_OVERLAY;
    PDXGI_DDI_PRESENT_MULTIPLANE_OVERLAY = ^TDXGI_DDI_PRESENT_MULTIPLANE_OVERLAY;


    _DXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY = record
        hDevice: TDXGI_DDI_HDEVICE;
        pDXGIContext: Pvoid;
        VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID;
        Flags: TDXGI_DDI_PRESENT_FLAGS;
        FlipInterval: TDXGI_DDI_FLIP_INTERVAL_TYPE;
        PresentPlaneCount: UINT;
        pPresentPlanes: PDXGI_DDI_PRESENT_MULTIPLANE_OVERLAY;
        {$IFDEF D3D_UMD_INTERFACE_VERSION_WDDM1_3}// M1
        Reserved: UINT;
        {$ENDIF}

    end;
    TDXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY = _DXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY;
    PDXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY = ^TDXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY;


    _DXGI_DDI_ARG_CHECKPRESENTDURATIONSUPPORT = record
        hDevice: TDXGI_DDI_HDEVICE;
        VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID;
        DesiredPresentDuration: UINT;
        ClosestSmallerDuration: UINT; // out
        ClosestLargerDuration: UINT; //out
    end;
    TDXGI_DDI_ARG_CHECKPRESENTDURATIONSUPPORT = _DXGI_DDI_ARG_CHECKPRESENTDURATIONSUPPORT;
    PDXGI_DDI_ARG_CHECKPRESENTDURATIONSUPPORT = ^TDXGI_DDI_ARG_CHECKPRESENTDURATIONSUPPORT;


    TDXGI_DDI_ARG_PRESENTSURFACE = record
        hSurface: TDXGI_DDI_HRESOURCE; // In
        SubResourceIndex: UINT; // Index of surface level
    end;
    PDXGI_DDI_ARG_PRESENTSURFACE = ^TDXGI_DDI_ARG_PRESENTSURFACE;


    TDXGI_DDI_ARG_PRESENT1 = record
        hDevice: TDXGI_DDI_HDEVICE; //in
        phSurfacesToPresent: PDXGI_DDI_ARG_PRESENTSURFACE; //in
        SurfacesToPresent: UINT; //in
        hDstResource: TDXGI_DDI_HRESOURCE; // if non-zero, it's the destination of the present
        DstSubResourceIndex: UINT; // Index of surface level
        pDXGIContext: Pvoid; // opaque: Pass this to the Present callback
        Flags: TDXGI_DDI_PRESENT_FLAGS; // Presentation flags.
        FlipInterval: TDXGI_DDI_FLIP_INTERVAL_TYPE; // Presentation interval (flip only)
        Reserved: UINT;
        pDirtyRects: PRECT; // in: Array of dirty rects
        DirtyRects: UINT; // in: Number of dirty rects
        {$IFDEF D3D_UMD_INTERFACE_VERSION_WDDM2_0}
        // out: for LDA only.
        // Only WDDM2.0 drivers should write this value
        // The number of physical back buffer per logical back buffer.
        BackBufferMultiplicity: UINT;
        {$ENDIF}

    end;
    PDXGI_DDI_ARG_PRESENT1 = ^TDXGI_DDI_ARG_PRESENT1;


    _DXGI_DDI_ARG_TRIMRESIDENCYSET = record
        hDevice: TDXGI_DDI_HDEVICE;
        TrimFlags: TD3DDDI_TRIMRESIDENCYSET_FLAGS;
        NumBytesToTrim: uint64;
    end;
    TDXGI_DDI_ARG_TRIMRESIDENCYSET = _DXGI_DDI_ARG_TRIMRESIDENCYSET;
    PDXGI_DDI_ARG_TRIMRESIDENCYSET = ^TDXGI_DDI_ARG_TRIMRESIDENCYSET;


    _DXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYCOLORSPACESUPPORT = record
        hDevice: TDXGI_DDI_HDEVICE;
        VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID;
        Format: TDXGI_FORMAT;
        ColorSpace: TD3DDDI_COLOR_SPACE_TYPE;
        Supported: boolean; // out
    end;
    TDXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYCOLORSPACESUPPORT = _DXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYCOLORSPACESUPPORT;
    PDXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYCOLORSPACESUPPORT = ^TDXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYCOLORSPACESUPPORT;


    TDXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES1 = record
        Flags: UINT; // DXGI_DDI_MULTIPLANE_OVERLAY_FLAGS
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
        StereoLeftViewFrame0: boolean;
        StereoBaseViewFrame0: boolean;
        StereoFlipMode: TDXGI_DDI_MULTIPLANE_OVERLAY_STEREO_FLIP_MODE;
        StretchQuality: TDXGI_DDI_MULTIPLANE_OVERLAY_STRETCH_QUALITY;
        ColorKey: UINT;
    end;
    PDXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES1 = ^TDXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES1;


    _DXGI_DDI_PRESENT_MULTIPLANE_OVERLAY1 = record
        LayerIndex: UINT;
        Enabled: boolean;
        hResource: TDXGI_DDI_HRESOURCE;
        SubResourceIndex: UINT;
        PlaneAttributes: TDXGI_DDI_MULTIPLANE_OVERLAY_ATTRIBUTES1;
    end;
    TDXGI_DDI_PRESENT_MULTIPLANE_OVERLAY1 = _DXGI_DDI_PRESENT_MULTIPLANE_OVERLAY1;
    PDXGI_DDI_PRESENT_MULTIPLANE_OVERLAY1 = ^TDXGI_DDI_PRESENT_MULTIPLANE_OVERLAY1;


    _DXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY1 = record
        hDevice: TDXGI_DDI_HDEVICE;
        pDXGIContext: Pvoid;
        VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID;
        Flags: TDXGI_DDI_PRESENT_FLAGS;
        FlipInterval: TDXGI_DDI_FLIP_INTERVAL_TYPE;
        PresentPlaneCount: UINT;
        pPresentPlanes: PDXGI_DDI_PRESENT_MULTIPLANE_OVERLAY1;
    end;
    TDXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY1 = _DXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY1;
    PDXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY1 = ^TDXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY1;


    _DXGI_DDI_ARG_OFFERRESOURCES1 = record
        {_In_ } hDevice: TDXGI_DDI_HDEVICE; //in:  device that created the resources
        {_In_reads_(Resources) } pResources: PDXGI_DDI_HRESOURCE; //in:  array of resources to reset
        {_In_ } Resources: UINT; //in:  number of elements in pResources
        {_In_ } Priority: TD3DDDI_OFFER_PRIORITY; //in:  priority with which to reset the resources
        {_In_ } Flags: TD3DDDI_OFFER_FLAGS; //in:  flags specifying additional behaviors on offer
    end;
    TDXGI_DDI_ARG_OFFERRESOURCES1 = _DXGI_DDI_ARG_OFFERRESOURCES1;
    PDXGI_DDI_ARG_OFFERRESOURCES1 = ^TDXGI_DDI_ARG_OFFERRESOURCES1;


    _DXGI_DDI_ARG_RECLAIMRESOURCES1 = record
        hDevice: TDXGI_DDI_HDEVICE; //in:  device that created the resources
        pResources: PDXGI_DDI_HRESOURCE; //in:  array of resources to reset
        pResults: PD3DDDI_RECLAIM_RESULT; //out: array of results specifying whether each resource was
        Resources: UINT; //in:  number of elements in pResources and pDiscarded
    end;
    TDXGI_DDI_ARG_RECLAIMRESOURCES1 = _DXGI_DDI_ARG_RECLAIMRESOURCES1;
    PDXGI_DDI_ARG_RECLAIMRESOURCES1 = ^TDXGI_DDI_ARG_RECLAIMRESOURCES1;


    TDXGI1_6_1_DDI_ARG_PRESENT = record
        hDevice: TDXGI_DDI_HDEVICE; //in
        phSurfacesToPresent: PDXGI_DDI_ARG_PRESENTSURFACE; //in
        SurfacesToPresent: UINT; //in
        hDstResource: TDXGI_DDI_HRESOURCE; // if non-zero, it's the destination of the present
        DstSubResourceIndex: UINT; // Index of surface level
        pDXGIContext: Pvoid; // opaque: Pass this to the Present callback
        Flags: TDXGI_DDI_PRESENT_FLAGS; // Presentation flags.
        FlipInterval: TDXGI_DDI_FLIP_INTERVAL_TYPE; // Presentation interval (flip only)
        RotationHint: TDXGI_DDI_MODE_ROTATION; // in: Hint that the contents of the frame are rotated with respect to scanout.
        pDirtyRects: PRECT; // in: Array of dirty rects
        DirtyRects: UINT; // in: Number of dirty rects
        // out: for LDA only.
        // The number of physical back buffer per logical back buffer.
        BackBufferMultiplicity: UINT;
    end;
    PDXGI1_6_1_DDI_ARG_PRESENT = ^TDXGI1_6_1_DDI_ARG_PRESENT;


    TDXGI1_6_1_DDI_ARG_PRESENTMULTIPLANEOVERLAY = record
        hDevice: TDXGI_DDI_HDEVICE;
        pDXGIContext: Pvoid;
        VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID;
        Flags: TDXGI_DDI_PRESENT_FLAGS;
        FlipInterval: TDXGI_DDI_FLIP_INTERVAL_TYPE;
        PresentPlaneCount: UINT;
        pPresentPlanes: PDXGI_DDI_PRESENT_MULTIPLANE_OVERLAY1;
        pRotationHints: PDXGI_DDI_MODE_ROTATION;
    end;
    PDXGI1_6_1_DDI_ARG_PRESENTMULTIPLANEOVERLAY = ^TDXGI1_6_1_DDI_ARG_PRESENTMULTIPLANEOVERLAY;

    TfnPresent = function(pPresentData: PDXGI_DDI_ARG_PRESENT): HResult; stdcall;
    TfnGetGammaCaps = function(pGammaData: PDXGI_DDI_ARG_GET_GAMMA_CONTROL_CAPS): HResult; stdcall;
    TfnSetDisplayMode = function(pDisplayMode: PDXGI_DDI_ARG_SETDISPLAYMODE): HResult; stdcall;
    TfnSetResourcePriority = function(pPriorityData: PDXGI_DDI_ARG_SETRESOURCEPRIORITY): HResult; stdcall;
    TfnQueryResourceResidency = function(pResidencyData: PDXGI_DDI_ARG_QUERYRESOURCERESIDENCY): HResult; stdcall;
    TfnRotateResourceIdentities = function(pRotateData: PDXGI_DDI_ARG_ROTATE_RESOURCE_IDENTITIES): HResult; stdcall;
    TfnBlt = function(pBltData: PDXGI_DDI_ARG_BLT): HResult; stdcall;
    TfnResolveSharedResource = function(pSharedResource: PDXGI_DDI_ARG_RESOLVESHAREDRESOURCE): HResult; stdcall;

    TfnBlt1 = function(pBlt1: PDXGI_DDI_ARG_BLT1): HResult; stdcall;
    TfnOfferResources = function(pOfferResources: PDXGI_DDI_ARG_OFFERRESOURCES): HResult; stdcall;
    TfnReclaimResources = function(pReclaimResources: PDXGI_DDI_ARG_RECLAIMRESOURCES): HResult; stdcall;
    // Use IS_DXGI_MULTIPLANE_OVERLAY_FUNCTIONS macro to determine these functions fields are available
    TfnGetMultiplaneOverlayCaps = function(pGetMultiplaneOverlayCaps: PDXGI_DDI_ARG_GETMULTIPLANEOVERLAYCAPS): HResult; stdcall;
    TfnGetMultiplaneOverlayFilterRange = function(pGetMultiplaneOverlayFilterRange: pointer): HResult; stdcall;
    TfnCheckMultiplaneOverlaySupport = function(pCheckMultiplaneOverlaySupport: PDXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYSUPPORT): HResult; stdcall;
    TfnPresentMultiplaneOverlay = function(pPresentMultiplaneOverlay: PDXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY): HResult; stdcall;


    TfnGetMultiplaneOverlayGroupCaps = function(pGroupCaps: PDXGI_DDI_ARG_GETMULTIPLANEOVERLAYGROUPCAPS): HResult; stdcall;
    TfnReserved = function(ptr: pointer): HResult; stdcall;
    TfnPresent1 = function(pPresent1: PDXGI_DDI_ARG_PRESENT1): HResult; stdcall;
    TfnCheckPresentDurationSupport = function(pPresentDuration: PDXGI_DDI_ARG_CHECKPRESENTDURATIONSUPPORT): HResult; stdcall;


    TDXGI_DDI_BASE_FUNCTIONS = record
        pfnPresent: TfnPresent;
        pfnGetGammaCaps: TfnGetGammaCaps;
        pfnSetDisplayMode: TfnSetDisplayMode;
        pfnSetResourcePriority: TfnSetResourcePriority;
        pfnQueryResourceResidency: TfnQueryResourceResidency;
        pfnRotateResourceIdentities: TfnRotateResourceIdentities;
        pfnBlt: TfnBlt;
    end;
    PDXGI_DDI_BASE_FUNCTIONS = ^TDXGI_DDI_BASE_FUNCTIONS;


    TDXGI1_1_DDI_BASE_FUNCTIONS = record
        pfnPresent: TfnPresent;
        pfnGetGammaCaps: TfnGetGammaCaps;
        pfnSetDisplayMode: TfnSetDisplayMode;
        pfnSetResourcePriority: TfnSetResourcePriority;
        pfnQueryResourceResidency: TfnQueryResourceResidency;
        pfnRotateResourceIdentities: TfnRotateResourceIdentities;
        pfnBlt: TfnBlt;
        pfnResolveSharedResource: TfnResolveSharedResource;
    end;
    PDXGI1_1_DDI_BASE_FUNCTIONS = ^TDXGI1_1_DDI_BASE_FUNCTIONS;

    TDXGI1_2_DDI_BASE_FUNCTIONS = record
        pfnPresent: TfnPresent;
        pfnGetGammaCaps: TfnGetGammaCaps;
        pfnSetDisplayMode: TfnSetDisplayMode;
        pfnSetResourcePriority: TfnSetResourcePriority;
        pfnQueryResourceResidency: TfnQueryResourceResidency;
        pfnRotateResourceIdentities: TfnRotateResourceIdentities;
        pfnBlt: TfnBlt;
        pfnResolveSharedResource: TfnResolveSharedResource;


        pfnBlt1: TfnBlt1;
        pfnOfferResources: TfnOfferResources;
        pfnReclaimResources: TfnReclaimResources;
        // Use IS_DXGI_MULTIPLANE_OVERLAY_FUNCTIONS macro to determine these functions fields are available
        pfnGetMultiplaneOverlayCaps: TfnGetMultiplaneOverlayCaps;
        pfnGetMultiplaneOverlayFilterRange: TfnGetMultiplaneOverlayFilterRange;
        pfnCheckMultiplaneOverlaySupport: TfnCheckMultiplaneOverlaySupport;
        pfnPresentMultiplaneOverlay: TfnPresentMultiplaneOverlay;
    end;
    PDXGI1_2_DDI_BASE_FUNCTIONS = ^TDXGI1_2_DDI_BASE_FUNCTIONS;


    TDXGI1_3_DDI_BASE_FUNCTIONS = record
        pfnPresent: TfnPresent;
        pfnGetGammaCaps: TfnGetGammaCaps;
        pfnSetDisplayMode: TfnSetDisplayMode;
        pfnSetResourcePriority: TfnSetResourcePriority;
        pfnQueryResourceResidency: TfnQueryResourceResidency;
        pfnRotateResourceIdentities: TfnRotateResourceIdentities;
        pfnBlt: TfnBlt;
        pfnResolveSharedResource: TfnResolveSharedResource;


        pfnBlt1: TfnBlt1;
        pfnOfferResources: TfnOfferResources;
        pfnReclaimResources: TfnReclaimResources;
        // Use IS_DXGI_MULTIPLANE_OVERLAY_FUNCTIONS macro to determine these functions fields are available
        pfnGetMultiplaneOverlayCaps: TfnGetMultiplaneOverlayCaps;


        pfnGetMultiplaneOverlayGroupCaps: TfnGetMultiplaneOverlayGroupCaps;
        pfnReserved1: TfnReserved;
        pfnPresentMultiplaneOverlay: TfnPresentMultiplaneOverlay;
        pfnReserved2: TfnReserved;
        pfnPresent1: TfnPresent1;
        pfnCheckPresentDurationSupport: TfnCheckPresentDurationSupport;

    end;
    PDXGI1_3_DDI_BASE_FUNCTIONS = ^TDXGI1_3_DDI_BASE_FUNCTIONS;


    TfnTrimResidencySet = function(pSet: PDXGI_DDI_ARG_TRIMRESIDENCYSET): HResult; stdcall;
    TfnCheckMultiplaneOverlayColorSpaceSupport = function(pSpaceSupport: PDXGI_DDI_ARG_CHECKMULTIPLANEOVERLAYCOLORSPACESUPPORT): HResult; stdcall;
    TfnPresentMultiplaneOverlay1 = function(pOverlay1: PDXGI_DDI_ARG_PRESENTMULTIPLANEOVERLAY1): HResult; stdcall;

    TDXGI1_4_DDI_BASE_FUNCTIONS = record
        pfnPresent: TfnPresent;
        pfnGetGammaCaps: TfnGetGammaCaps;
        pfnSetDisplayMode: TfnSetDisplayMode;
        pfnSetResourcePriority: TfnSetResourcePriority;
        pfnQueryResourceResidency: TfnQueryResourceResidency;
        pfnRotateResourceIdentities: TfnRotateResourceIdentities;
        pfnBlt: TfnBlt;
        pfnResolveSharedResource: TfnResolveSharedResource;


        pfnBlt1: TfnBlt1;
        pfnOfferResources: TfnOfferResources;
        pfnReclaimResources: TfnReclaimResources;
        // Use IS_DXGI_MULTIPLANE_OVERLAY_FUNCTIONS macro to determine these functions fields are available
        pfnGetMultiplaneOverlayCaps: TfnGetMultiplaneOverlayCaps;


        pfnGetMultiplaneOverlayGroupCaps: TfnGetMultiplaneOverlayGroupCaps;
        pfnReserved1: TfnReserved;
        pfnPresentMultiplaneOverlay: TfnPresentMultiplaneOverlay;
        pfnReserved2: TfnReserved;
        pfnPresent1: TfnPresent1;
        pfnCheckPresentDurationSupport: TfnCheckPresentDurationSupport;

        pfnTrimResidencySet: TfnTrimResidencySet;
        pfnCheckMultiplaneOverlayColorSpaceSupport: TfnCheckMultiplaneOverlayColorSpaceSupport;
        pfnPresentMultiplaneOverlay1: TfnPresentMultiplaneOverlay1;
    end;
    PDXGI1_4_DDI_BASE_FUNCTIONS = ^TDXGI1_4_DDI_BASE_FUNCTIONS;


    TfnReclaimResources1 = function(pResources1: PDXGI_DDI_ARG_RECLAIMRESOURCES1): HResult; stdcall;

    TDXGI1_5_DDI_BASE_FUNCTIONS = record
        pfnPresent: TfnPresent;
        pfnGetGammaCaps: TfnGetGammaCaps;
        pfnSetDisplayMode: TfnSetDisplayMode;
        pfnSetResourcePriority: TfnSetResourcePriority;
        pfnQueryResourceResidency: TfnQueryResourceResidency;
        pfnRotateResourceIdentities: TfnRotateResourceIdentities;
        pfnBlt: TfnBlt;
        pfnResolveSharedResource: TfnResolveSharedResource;


        pfnBlt1: TfnBlt1;
        pfnOfferResources: TfnOfferResources;
        pfnReclaimResources: TfnReclaimResources;
        // Use IS_DXGI_MULTIPLANE_OVERLAY_FUNCTIONS macro to determine these functions fields are available
        pfnGetMultiplaneOverlayCaps: TfnGetMultiplaneOverlayCaps;


        pfnGetMultiplaneOverlayGroupCaps: TfnGetMultiplaneOverlayGroupCaps;
        pfnReserved1: TfnReserved;
        pfnPresentMultiplaneOverlay: TfnPresentMultiplaneOverlay;
        pfnReserved2: TfnReserved;
        pfnPresent1: TfnPresent1;
        pfnCheckPresentDurationSupport: TfnCheckPresentDurationSupport;

        pfnTrimResidencySet: TfnTrimResidencySet;
        pfnCheckMultiplaneOverlayColorSpaceSupport: TfnCheckMultiplaneOverlayColorSpaceSupport;
        pfnPresentMultiplaneOverlay1: TfnPresentMultiplaneOverlay1;
        pfnReclaimResources1: TfnReclaimResources1;
    end;
    PDXGI1_5_DDI_BASE_FUNCTIONS = ^TDXGI1_5_DDI_BASE_FUNCTIONS;

    TDXGI1_6_1_DDI_BASE_FUNCTIONS = record
        pfnPresent: TfnPresent;
        pfnGetGammaCaps: TfnGetGammaCaps;
        pfnSetDisplayMode: TfnSetDisplayMode;
        pfnSetResourcePriority: TfnSetResourcePriority;
        pfnQueryResourceResidency: TfnQueryResourceResidency;
        pfnRotateResourceIdentities: TfnRotateResourceIdentities;
        pfnBlt: TfnBlt;
        pfnResolveSharedResource: TfnResolveSharedResource;


        pfnBlt1: TfnBlt1;
        pfnOfferResources: TfnOfferResources;
        pfnReclaimResources: TfnReclaimResources;
        // Use IS_DXGI_MULTIPLANE_OVERLAY_FUNCTIONS macro to determine these functions fields are available
        pfnGetMultiplaneOverlayCaps: TfnGetMultiplaneOverlayCaps;


        pfnGetMultiplaneOverlayGroupCaps: TfnGetMultiplaneOverlayGroupCaps;
        pfnReserved1: TfnReserved;
        pfnPresentMultiplaneOverlay: TfnPresentMultiplaneOverlay;
        pfnReserved2: TfnReserved;
        pfnPresent1: TfnPresent1;
        pfnCheckPresentDurationSupport: TfnCheckPresentDurationSupport;

        pfnTrimResidencySet: TfnTrimResidencySet;
        pfnCheckMultiplaneOverlayColorSpaceSupport: TfnCheckMultiplaneOverlayColorSpaceSupport;
        pfnPresentMultiplaneOverlay1: TfnPresentMultiplaneOverlay1;
        pfnReclaimResources1: TfnReclaimResources1;
    end;
    PDXGI1_6_1_DDI_BASE_FUNCTIONS = ^TDXGI1_6_1_DDI_BASE_FUNCTIONS;


    //========================================================================================================
    // DXGI callback definitions.

    //--------------------------------------------------------------------------------------------------------


    TDXGIDDICB_PRESENT = record
        hSrcAllocation: TD3DKMT_HANDLE; // in: The allocation of which content will be presented
        hDstAllocation: TD3DKMT_HANDLE; // in: if non-zero, it's the destination allocation of the present
        pDXGIContext: Pvoid; // opaque: Fill this with the value in DXGI_DDI_ARG_PRESENT.pDXGIContext
        hContext: HANDLE; // in: Context being submitted to.
        BroadcastContextCount: UINT; // in: Specifies the number of context
        //     Only supported for flip operation.
        BroadcastContext: array [0..D3DDDI_MAX_BROADCAST_CONTEXT - 1] of HANDLE; // in: Specifies the handle of the context to
        //     broadcast to.
        {$IFDEF D3D_UMD_INTERFACE_VERSION_WDDM2_0}
        {_Field_size_(BroadcastContextCount)} BroadcastSrcAllocation: PD3DKMT_HANDLE; // in: LDA
        {_Field_size_opt_(BroadcastContextCount)} BroadcastDstAllocation: PD3DKMT_HANDLE; // in: LDA
        PrivateDriverDataSize: UINT; // in:
        {_Field_size_bytes_(PrivateDriverDataSize)} pPrivateDriverData: PVOID; // in: Private driver data to pass to DdiPresent and DdiSetVidPnSourceAddress
        bOptimizeForComposition: boolean; // out: DWM is involved in composition
        {$ENDIF}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_0)

        {$IFDEF D3D_UMD_INTERFACE_VERSION_WDDM2_2_2}
        SyncIntervalOverrideValid: boolean;
        SyncIntervalOverride: TDXGI_DDI_FLIP_INTERVAL_TYPE;
        {$ENDIF}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_2_2)

    end;
    PDXGIDDICB_PRESENT = ^TDXGIDDICB_PRESENT;


    TDXGIDDI_MULTIPLANE_OVERLAY_ALLOCATION_INFO = record
        PresentAllocation: TD3DKMT_HANDLE;
        SubResourceIndex: UINT;
    end;
    PDXGIDDI_MULTIPLANE_OVERLAY_ALLOCATION_INFO = ^TDXGIDDI_MULTIPLANE_OVERLAY_ALLOCATION_INFO;


    TDXGIDDICB_PRESENT_MULTIPLANE_OVERLAY = record
        pDXGIContext: Pvoid; // opaque: Fill this with the value in DXGI_DDI_ARG_PRESENT.pDXGIContext
        hContext: HANDLE;
        BroadcastContextCount: UINT;
        BroadcastContext: array [0..D3DDDI_MAX_BROADCAST_CONTEXT - 1] of HANDLE;
        AllocationInfoCount: DWORD;
        AllocationInfo: array [0..DXGI_DDI_MAX_MULTIPLANE_OVERLAY_ALLOCATIONS - 1] of TDXGIDDI_MULTIPLANE_OVERLAY_ALLOCATION_INFO;
    end;
    PDXGIDDICB_PRESENT_MULTIPLANE_OVERLAY = ^TDXGIDDICB_PRESENT_MULTIPLANE_OVERLAY;


    TDXGIDDI_MULTIPLANE_OVERLAY_PLANE_INFO = record
        ContextCount: UINT;
        {_Field_size_(ContextCount) } pContextList: PHANDLE;
        {_Field_size_(ContextCount) } pAllocationList: PD3DKMT_HANDLE;
        DriverPrivateDataSize: UINT;
        {_Field_size_bytes_(DriverPrivateDataSize)} pDriverPrivateData: PVOID;
        {$IFDEF D3D_UMD_INTERFACE_VERSION_WDDM2_2_2}
        SyncIntervalOverrideValid: boolean;
        SyncIntervalOverride: TDXGI_DDI_FLIP_INTERVAL_TYPE;
        {$ENDIF}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_2_2)

    end;
    PDXGIDDI_MULTIPLANE_OVERLAY_PLANE_INFO = ^TDXGIDDI_MULTIPLANE_OVERLAY_PLANE_INFO;


    TDXGIDDICB_PRESENT_MULTIPLANE_OVERLAY1 = record
        pDXGIContext: Pvoid; // opaque: Fill this with the value in DXGI_DDI_ARG_PRESENT.pDXGIContext
        PresentPlaneCount: DWORD;
        {_Field_size_(PresentPlaneCount) } ppPresentPlanes: PDXGIDDI_MULTIPLANE_OVERLAY_PLANE_INFO;
    end;
    PDXGIDDICB_PRESENT_MULTIPLANE_OVERLAY1 = ^TDXGIDDICB_PRESENT_MULTIPLANE_OVERLAY1;


    TDXGIDDICB_SUBMITPRESENTBLTTOHWQUEUE = record
        hSrcAllocation: TD3DKMT_HANDLE; // in: The allocation of which content will be presented
        hDstAllocation: TD3DKMT_HANDLE; // in: The destination allocation of the present
        pDXGIContext: Pvoid; // opaque: Fill this with the value in DXGI_DDI_ARG_PRESENT.pDXGIContext
        hHwQueue: HANDLE; // in: Hardware queue being submitted to.
        HwQueueProgressFenceId: uint64; // Hardware queue progress fence ID that will be signaled when the Present Blt is done on the GPU
        PrivateDriverDataSize: UINT;
        {_Field_size_bytes_(PrivateDriverDataSize)} pPrivateDriverData: PVOID; // in: Private driver data to pass to DdiPresent
    end;
    PDXGIDDICB_SUBMITPRESENTBLTTOHWQUEUE = ^TDXGIDDICB_SUBMITPRESENTBLTTOHWQUEUE;


    TDXGIDDICB_SUBMITPRESENTTOHWQUEUE = record
        pDXGIContext: Pvoid; // opaque: Fill this with the value in DXGI_DDI_ARG_PRESENT.pDXGIContext
        {_Field_size_(BroadcastHwQueueCount)} BroadcastSrcAllocations: PD3DKMT_HANDLE; // in: allocations which content will be presented
        {_Field_size_opt_(BroadcastHwQueueCount)} BroadcastDstAllocations: PD3DKMT_HANDLE; // in: if non-zero, it's the destination allocations of the present
        hHwQueues: PHANDLE; // in: hardware queues being submitted to.
        BroadcastHwQueueCount: UINT; // in: the number of broadcast hardware queues
        PrivateDriverDataSize: UINT; // in: private driver data size in bytes
        {_Field_size_bytes_(PrivateDriverDataSize)} pPrivateDriverData: PVOID; // in: private driver data to pass to DdiPresent
        {$IFDEF D3D_UMD_INTERFACE_VERSION_WDDM2_6_2}
        bOptimizeForComposition: boolean; // out: DWM is involved in composition
        {$ENDIF}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_6_2)

        {$IFDEF D3D_UMD_INTERFACE_VERSION_WDDM2_6_3}
        SyncIntervalOverrideValid: boolean;
        SyncIntervalOverride: TDXGI_DDI_FLIP_INTERVAL_TYPE;
        {$ENDIF}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_6_3)

    end;
    PDXGIDDICB_SUBMITPRESENTTOHWQUEUE = ^TDXGIDDICB_SUBMITPRESENTTOHWQUEUE;


    PFNDDXGIDDI_PRESENTCB = function(
        {_In_}  hDevice: HANDLE; {_In_} unnamedParam2: PDXGIDDICB_PRESENT): HResult; stdcall;


    PFNDDXGIDDI_PRESENT_MULTIPLANE_OVERLAYCB = function(
        {_In_ } hDevice: HANDLE;
        {_In_ } unnamedParam2: PDXGIDDICB_PRESENT_MULTIPLANE_OVERLAY): HResult; stdcall;


    PFNDDXGIDDI_PRESENT_MULTIPLANE_OVERLAY1CB = function(
        {_In_ } hDevice: HANDLE;
        {_In_ } unnamedParam2: PDXGIDDICB_PRESENT_MULTIPLANE_OVERLAY1): HResult; stdcall;


    PFNDDXGIDDI_SUBMITPRESENTBLTTOHWQUEUECB = function(
        {_In_ } hDevice: HANDLE;
        {_In_ } unnamedParam2: PDXGIDDICB_SUBMITPRESENTBLTTOHWQUEUE): HResult; stdcall;


    PFNDDXGIDDI_SUBMITPRESENTTOHWQUEUECB = function(
        {_In_ } hDevice: HANDLE;
        {_In_ } unnamedParam2: PDXGIDDICB_SUBMITPRESENTTOHWQUEUE): HResult; stdcall;


    //--------------------------------------------------------------------------------------------------------
    TDXGI_DDI_BASE_CALLBACKS = record
        pfnPresentCb: PFNDDXGIDDI_PRESENTCB; // Use IS_DXGI_MULTIPLANE_OVERLAY_FUNCTIONS macro to check if field is available.
        {$IFDEF D3D_UMD_INTERFACE_VERSION_WIN8}
        pfnPresentMultiplaneOverlayCb: PFNDDXGIDDI_PRESENT_MULTIPLANE_OVERLAYCB; // Use IS_DXGI1_6_BASE_FUNCTIONS macro to check if field is available.
        {$ENDIF}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WIN8)

        {$IFDEF D3D_UMD_INTERFACE_VERSION_WDDM2_2_1}
        pfnPresentMultiplaneOverlay1Cb: PFNDDXGIDDI_PRESENT_MULTIPLANE_OVERLAY1CB;
        {$ENDIF}// (D3D_UMD_INTERFACE_VERSION >=  D3D_UMD_INTERFACE_VERSION_WDDM2_2_1)

        {$IFDEF D3D_UMD_INTERFACE_VERSION_WDDM2_4_2}
        pfnSubmitPresentBltToHwQueueCb: PFNDDXGIDDI_SUBMITPRESENTBLTTOHWQUEUECB;
        {$ENDIF}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_4_2)

        {$IFDEF D3D_UMD_INTERFACE_VERSION_WDDM2_5_2}
        pfnSubmitPresentToHwQueueCb: PFNDDXGIDDI_SUBMITPRESENTTOHWQUEUECB;
        {$ENDIF}// (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM2_5_2)

    end;
    PDXGI_DDI_BASE_CALLBACKS = ^TDXGI_DDI_BASE_CALLBACKS;


    //========================================================================================================
    // DXGI basic DDI device creation arguments

    TDXGI_DDI_BASE_ARGS = record
        pDXGIBaseCallbacks: PDXGI_DDI_BASE_CALLBACKS; // in: The driver should record this pointer for later use
        case integer of
            {$IFDEF D3D_UMD_INTERFACE_VERSION_WDDM2_2_2)}
            0: (
                pDXGIDDIBaseFunctions6_1: PDXGI1_6_1_DDI_BASE_FUNCTIONS; // in/out: The driver should fill the denoted struct with DXGI base driver entry points
            );
            {$ENDIF}

            {$IFDEF D3D_UMD_INTERFACE_VERSION_WDDM2_1_1)}
            1: (
                pDXGIDDIBaseFunctions6: PDXGI1_5_DDI_BASE_FUNCTIONS; // in/out: The driver should fill the denoted struct with DXGI base driver entry points
            );
            {$ENDIF}

            {$IFDEF D3D_UMD_INTERFACE_VERSION_WDDM2_0)}
            2: (
                pDXGIDDIBaseFunctions5: PDXGI1_4_DDI_BASE_FUNCTIONS; // in/out: The driver should fill the denoted struct with DXGI base driver entry points
            );
            {$ENDIF}

            {$IFDEF D3D_UMD_INTERFACE_VERSION_WDDM1_3)}// M1
            3: (
                pDXGIDDIBaseFunctions4: PDXGI1_3_DDI_BASE_FUNCTIONS; // in/out: The driver should fill the denoted struct with DXGI base driver entry points
            );
            {$ENDIF}

            {$IFDEF D3D_UMD_INTERFACE_VERSION_WIN8)}
            4: (
                pDXGIDDIBaseFunctions3: PDXGI1_2_DDI_BASE_FUNCTIONS; // in/out: The driver should fill the denoted struct with DXGI base driver entry points
            );
            {$ENDIF}

            5: (
                pDXGIDDIBaseFunctions2: PDXGI1_1_DDI_BASE_FUNCTIONS; // in/out: The driver should fill the denoted struct with DXGI base driver entry points
            );
            6: (
                pDXGIDDIBaseFunctions: PDXGI_DDI_BASE_FUNCTIONS; // in/out: The driver should fill the denoted struct with DXGI base driver entry points
            );
    end;
    PDXGI_DDI_BASE_ARGS = ^TDXGI_DDI_BASE_ARGS;


function MAKE_DXGI_DDI_HRESULT(code: longword): longword;

function MAKE_DXGI_DDI_STATUS(code: longword): longword;

implementation

uses
    Windows.Macros;



function MAKE_DXGI_DDI_HRESULT(code: longword): longword;
begin
    Result := MAKE_HRESULT(1, _FACDXGI_DDI, code);

end;



function MAKE_DXGI_DDI_STATUS(code: longword): longword;
begin
    Result := MAKE_HRESULT(0, _FACDXGI_DDI, code);
end;


end.
