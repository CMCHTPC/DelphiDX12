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
   File:       dxmini.h
   Content:    Miniport support for DirectDraw DXAPI.  This file is
               analagous to Win95's ddkmmini.h.

   This unit consists of the following header files
   File name: dxmini.h
   Header version: 10.0.26100.6584
   
  ************************************************************************** }
unit DX12.DXMini;

{$IFDEF FPC}
{$mode ObjFPC}{$H+}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils;

    {$Z4}

const


    GUID_DxApi: TGUID = '{8A79BEF0-B915-11D0-9144-080036D2EF02}';

    MDL_SYSTEM_VA = 1; { #todo : WDM.h }

    MDL_MAPPED_TO_SYSTEM_VA = $0001;
    MDL_PAGES_LOCKED = $0002;
    MDL_SOURCE_IS_NONPAGED_POOL = $0004;
    MDL_ALLOCATED_FIXED_SIZE = $0008;
    MDL_PARTIAL = $0010;
    MDL_PARTIAL_HAS_BEEN_MAPPED = $0020;
    MDL_IO_PAGE_READ = $0040;
    MDL_WRITE_OPERATION = $0080;
    MDL_PARENT_MAPPED_SYSTEM_VA = $0100;
    MDL_LOCK_HELD = $0200;
    MDL_SCATTER_GATHER_VA = $0400;
    MDL_IO_SPACE = $0800;
    MDL_NETWORK_HEADER = $1000;
    MDL_MAPPING_CAN_FAIL = $2000;
    MDL_ALLOCATED_MUST_SUCCEED = $4000;
    MDL_64_BIT_VA = $8000;
    MDL_MAPPING_FLAGS = (MDL_MAPPED_TO_SYSTEM_VA or MDL_PAGES_LOCKED or MDL_SOURCE_IS_NONPAGED_POOL or MDL_PARTIAL_HAS_BEEN_MAPPED or MDL_PARENT_MAPPED_SYSTEM_VA or MDL_LOCK_HELD or MDL_SYSTEM_VA or MDL_IO_SPACE);


(*============================================================================
 *
 * Error values that may be returned by the miniport
 *
 *==========================================================================*)

    DX_OK = $0;
    DXERR_UNSUPPORTED = $80004001;
    DXERR_GENERIC = $80004005;
    DXERR_OUTOFCAPS = $88760168;

(*============================================================================
 *
 * Structures maintained by DirectDraw
 *
 *==========================================================================*)

    DDOVER_AUTOFLIP = $00100000;
    DDOVER_BOB = $00200000;
    DDOVER_OVERRIDEBOBWEAVE = $00400000;
    DDOVER_INTERLEAVED = $00800000;

(*============================================================================
 *
 * Structures used to communicate with the Miniport
 *
 *==========================================================================*)

    DDIRQ_DISPLAY_VSYNC = $00000001;
    DDIRQ_BUSMASTER = $00000002;
    DDIRQ_VPORT0_VSYNC = $00000004;
    DDIRQ_VPORT0_LINE = $00000008;
    DDIRQ_VPORT1_VSYNC = $00000010;
    DDIRQ_VPORT1_LINE = $00000020;
    DDIRQ_VPORT2_VSYNC = $00000040;
    DDIRQ_VPORT2_LINE = $00000080;
    DDIRQ_VPORT3_VSYNC = $00000100;
    DDIRQ_VPORT3_LINE = $00000200;
    DDIRQ_VPORT4_VSYNC = $00000400;
    DDIRQ_VPORT4_LINE = $00000800;
    DDIRQ_VPORT5_VSYNC = $00001000;
    DDIRQ_VPORT5_LINE = $00002000;
    DDIRQ_VPORT6_VSYNC = $00004000;
    DDIRQ_VPORT6_LINE = $00008000;
    DDIRQ_VPORT7_VSYNC = $00010000;
    DDIRQ_VPORT7_LINE = $00020000;
    DDIRQ_VPORT8_VSYNC = $00040000;
    DDIRQ_VPORT8_LINE = $00080000;
    DDIRQ_VPORT9_VSYNC = $00010000;
    DDIRQ_VPORT9_LINE = $00020000;
    IRQINFO_HANDLED = $01;
    IRQINFO_NOTHANDLED = $02;
    DDSKIP_SKIPNEXT = 1;
    DDSKIP_ENABLENEXT = 2;
    DDVPFLIP_VIDEO = $00000001;
    DDVPFLIP_VBI = $00000002;
    DDTRANSFER_SYSTEMMEMORY = $00000001;
    DDTRANSFER_NONLOCALVIDMEM = $00000002;
    DDTRANSFER_INVERT = $00000004;
    DDTRANSFER_CANCEL = $00000080;
    DDTRANSFER_HALFLINES = $00000100;
    DXAPI_HALVERSION = $0001;


type
    P_EPROCESS = pointer; { #todo : WDM.H  }

    PMDL = ^TMDL;

    TMDL = record
        MdlNext: PMDL;
        MdlSize: smallint;
        MdlFlags: smallint;
        Process: P_EPROCESS;
        lpMappedSystemVa: PULONG;
        lpStartVa: PULONG;
        ByteCount: ULONG;
        ByteOffset: ULONG;
    end;




    // Data for every DXAPI surface


    TDDSURFACEDATA = record
        // Ring 3 creation caps
        ddsCaps: DWORD;
        // Offset in frame buffer of surface
        dwSurfaceOffset: DWORD;
        // Surface lock ptr
        fpLockPtr: ULONG_PTR;
        // Surface width
        dwWidth: DWORD;
        // Surface height
        dwHeight: DWORD;
        // Surface pitch
        lPitch: LONG;
        // DDOVER_XX flags
        dwOverlayFlags: DWORD;
        // Offset in frame buffer of overlay
        dwOverlayOffset: DWORD;
        // Src width of overlay
        dwOverlaySrcWidth: DWORD;
        // Src height of overlay
        dwOverlaySrcHeight: DWORD;
        // Dest width of overlay
        dwOverlayDestWidth: DWORD;
        // Dest height of overlay
        dwOverlayDestHeight: DWORD;
        // ID of video port (-1 if not connected to a video port)
        dwVideoPortId: DWORD;
        dwFormatFlags: DWORD;
        dwFormatFourCC: DWORD;
        dwFormatBitCount: DWORD;
        dwRBitMask: DWORD;
        dwGBitMask: DWORD;
        dwBBitMask: DWORD;
        // Reserved for the HAL/Miniport
        dwDriverReserved1: ULONG;
        // Reserved for the HAL/Miniport
        dwDriverReserved2: ULONG;
        // Reserved for the HAL/Miniport
        dwDriverReserved3: ULONG;
        // Reserved for the HAL/Miniport
        dwDriverReserved4: ULONG;
    end;

    PDDSURFACEDATA = ^TDDSURFACEDATA;


    // Data for every DXAPI video port


    TDDVIDEOPORTDATA = record
        // ID of video port (0 - MaxVideoPorts-1)
        dwVideoPortId: DWORD;
        // Video port DDVP_ option flags
        dwVPFlags: DWORD;
        // Start address relative to surface
        dwOriginOffset: DWORD;
        // Height of total video region (per field)
        dwHeight: DWORD;
        // Height of VBI region (per field)
        dwVBIHeight: DWORD;
        // Reserved for the HAL/Miniport
        dwDriverReserved1: ULONG;
        // Reserved for the HAL/Miniport
        dwDriverReserved2: ULONG;
        // Reserved for the HAL/Miniport
        dwDriverReserved3: ULONG;
    end;

    PDDVIDEOPORTDATA = ^TDDVIDEOPORTDATA;

(*============================================================================
 *
 * Structures used to communicate with the Miniport
 *
 *==========================================================================*)

    TDX_IRQDATA = record
        // DDIRQ_ flags ORed in by miniport
        dwIrqFlags: DWORD;
    end;
    PDX_IRQDATA = ^TDX_IRQDATA;

    PDX_IRQCALLBACK = procedure(pIrqData: PDX_IRQDATA); cdecl;

    // output from DxGetIrqInfo
    TDDGETIRQINFO = record
        dwFlags: DWORD;
    end;
    PDDGETIRQINFO = ^TDDGETIRQINFO;

    // input to DxEnableIrq
    TDDENABLEIRQINFO = record
        dwIRQSources: DWORD;
        // Line for DDIRQ_VPORTx_LINE interrupt
        dwLine: DWORD;
        // Miniport calls this when IRQ happens
        IRQCallback: PDX_IRQCALLBACK;
        // Parameter to be passed to IRQCallback
        lpIRQData: PDX_IRQDATA;
    end;
    PDDENABLEIRQINFO = ^TDDENABLEIRQINFO;

    // input to DxSkipNextField
    TDDSKIPNEXTFIELDINFO = record
        lpVideoPortData: PDDVIDEOPORTDATA;
        dwSkipFlags: DWORD;
    end;
    PDDSKIPNEXTFIELDINFO = ^TDDSKIPNEXTFIELDINFO;

    // intput to DxBobNextField
    TDDBOBNEXTFIELDINFO = record
        lpSurface: PDDSURFACEDATA;
    end;
    PDDBOBNEXTFIELDINFO = ^TDDBOBNEXTFIELDINFO;

    // intput to DxSetState
    TDDSETSTATEININFO = record
        lpSurfaceData: PDDSURFACEDATA;
        lpVideoPortData: PDDVIDEOPORTDATA;
    end;
    PDDSETSTATEININFO = ^TDDSETSTATEININFO;

    // output from DxSetState
    TDDSETSTATEOUTINFO = record
        bSoftwareAutoflip: boolean;
        dwSurfaceIndex: DWORD;
        dwVBISurfaceIndex: DWORD;
    end;
    PDDSETSTATEOUTINFO = ^TDDSETSTATEOUTINFO;

    // input to DxLock
    TDDLOCKININFO = record
        lpSurfaceData: PDDSURFACEDATA;
    end;
    PDDLOCKININFO = ^TDDLOCKININFO;

    // output from DxLock
    TDDLOCKOUTINFO = record
        dwSurfacePtr: ULONG_PTR;
    end;
    PDDLOCKOUTINFO = ^TDDLOCKOUTINFO;

    // input to DxFlipOverlay
    TDDFLIPOVERLAYINFO = record
        lpCurrentSurface: PDDSURFACEDATA;
        lpTargetSurface: PDDSURFACEDATA;
        dwFlags: DWORD;
    end;

    PDDFLIPOVERLAYINFO = ^TDDFLIPOVERLAYINFO;

    // intput to DxFlipVideoPort
    TDDFLIPVIDEOPORTINFO = record
        lpVideoPortData: PDDVIDEOPORTDATA;
        lpCurrentSurface: PDDSURFACEDATA;
        lpTargetSurface: PDDSURFACEDATA;
        dwFlipVPFlags: DWORD;
    end;
    PDDFLIPVIDEOPORTINFO = ^TDDFLIPVIDEOPORTINFO;

    // input to DxGetPolarity
    TDDGETPOLARITYININFO = record
        lpVideoPortData: PDDVIDEOPORTDATA;
    end;
    PDDGETPOLARITYININFO = ^TDDGETPOLARITYININFO;

    // output from DxGetPolarity
    TDDGETPOLARITYOUTINFO = record
        bPolarity: DWORD;
    end;
    PDDGETPOLARITYOUTINFO = ^TDDGETPOLARITYOUTINFO;

    // input to DxGetCurrentAutoflipSurface
    TDDGETCURRENTAUTOFLIPININFO = record
        lpVideoPortData: PDDVIDEOPORTDATA;
    end;
    PDDGETCURRENTAUTOFLIPININFO = ^TDDGETCURRENTAUTOFLIPININFO;

    // output from DxGetCurrentAutoflipSurface
    TDDGETCURRENTAUTOFLIPOUTINFO = record
        dwSurfaceIndex: DWORD;
        dwVBISurfaceIndex: DWORD;
    end;
    PDDGETCURRENTAUTOFLIPOUTINFO = ^TDDGETCURRENTAUTOFLIPOUTINFO;

    // input to DxGetPreviousAutoflipSurface
    TDDGETPREVIOUSAUTOFLIPININFO = record
        lpVideoPortData: PDDVIDEOPORTDATA;
    end;
    PDDGETPREVIOUSAUTOFLIPININFO = ^TDDGETPREVIOUSAUTOFLIPININFO;

    // output from DxGetPreviousAutoflipSurface
    TDDGETPREVIOUSAUTOFLIPOUTINFO = record
        dwSurfaceIndex: DWORD;
        dwVBISurfaceIndex: DWORD;
    end;
    PDDGETPREVIOUSAUTOFLIPOUTINFO = ^TDDGETPREVIOUSAUTOFLIPOUTINFO;

    // intput to DxTransfer
    TDDTRANSFERININFO = record
        lpSurfaceData: PDDSURFACEDATA;
        dwStartLine: DWORD;
        dwEndLine: DWORD;
        dwTransferID: ULONG_PTR;
        dwTransferFlags: DWORD;
        lpDestMDL: PMDL;
    end;

    PDDTRANSFERININFO = ^TDDTRANSFERININFO;

    // output from DxTransfer
    TDDTRANSFEROUTINFO = record
        dwBufferPolarity: DWORD;
    end;

    PDDTRANSFEROUTINFO = ^TDDTRANSFEROUTINFO;

    // output from DxGetTransferStatus
    TDDGETTRANSFERSTATUSOUTINFO = record
        dwTransferID: DWORD_PTR;
    end;
    PDDGETTRANSFEROUTINFO = ^TDDGETTRANSFERSTATUSOUTINFO;

(*============================================================================
 *
 * DXAPI function prototypes
 *
 *==========================================================================*)

    PDX_GETIRQINFO = function(nameless1: pointer; nameless2: pointer; nameless3: PDDGETIRQINFO): DWORD; cdecl;
    PDX_ENABLEIRQ = function(nameless1: pointer; nameless2: PDDENABLEIRQINFO; nameless3: pointer): DWORD; cdecl;
    PDX_SKIPNEXTFIELD = function(nameless1: pointer; nameless2: PDDSKIPNEXTFIELDINFO; nameless3: pointer): DWORD; cdecl;
    PDX_BOBNEXTFIELD = function(nameless1: pointer; nameless2: PDDBOBNEXTFIELDINFO; nameless3: pointer): DWORD; cdecl;
    PDX_SETSTATE = function(nameless1: pointer; nameless2: PDDSETSTATEININFO; nameless3: PDDSETSTATEOUTINFO): DWORD; cdecl;
    PDX_LOCK = function(nameless1: pointer; nameless2: PDDLOCKININFO; nameless3: PDDLOCKOUTINFO): DWORD; cdecl;
    PDX_FLIPOVERLAY = function(nameless1: pointer; nameless2: PDDFLIPOVERLAYINFO; nameless3: pointer): DWORD; cdecl;
    PDX_FLIPVIDEOPORT = function(nameless1: pointer; nameless2: PDDFLIPVIDEOPORTINFO; nameless3: pointer): DWORD; cdecl;
    PDX_GETPOLARITY = function(nameless1: pointer; nameless2: PDDGETPOLARITYININFO; nameless3: PDDGETPOLARITYOUTINFO): DWORD; cdecl;
    PDX_GETCURRENTAUTOFLIP = function(nameless1: pointer; nameless2: PDDGETCURRENTAUTOFLIPININFO; nameless3: PDDGETCURRENTAUTOFLIPOUTINFO): DWORD; cdecl;
    PDX_GETPREVIOUSAUTOFLIP = function(nameless1: pointer; nameless2: PDDGETPREVIOUSAUTOFLIPININFO; nameless3: PDDGETPREVIOUSAUTOFLIPOUTINFO): DWORD; cdecl;
    PDX_TRANSFER = function(nameless1: pointer; nameless2: PDDTRANSFERININFO; nameless3: PDDTRANSFEROUTINFO): DWORD; cdecl;
    PDX_GETTRANSFERSTATUS = function(nameless1: pointer; nameless2: pointer; nameless3: PDDGETTRANSFEROUTINFO): DWORD; cdecl;

(*============================================================================
 *
 * HAL table filled in by the miniport and called by DirectDraw
 *
 *==========================================================================*)

    TDXAPI_INTERFACE = record
        Size: USHORT;
        Version: USHORT;
        Context: pointer;
        InterfaceReference: pointer;
        InterfaceDereference: pointer;
        DxGetIrqInfo: PDX_GETIRQINFO;
        DxEnableIrq: PDX_ENABLEIRQ;
        DxSkipNextField: PDX_SKIPNEXTFIELD;
        DxBobNextField: PDX_BOBNEXTFIELD;
        DxSetState: PDX_SETSTATE;
        DxLock: PDX_LOCK;
        DxFlipOverlay: PDX_FLIPOVERLAY;
        DxFlipVideoPort: PDX_FLIPVIDEOPORT;
        DxGetPolarity: PDX_GETPOLARITY;
        DxGetCurrentAutoflip: PDX_GETCURRENTAUTOFLIP;
        DxGetPreviousAutoflip: PDX_GETPREVIOUSAUTOFLIP;
        DxTransfer: PDX_TRANSFER;
        DxGetTransferStatus: PDX_GETTRANSFERSTATUS;
    end;

    PDXAPI_INTERFACE = ^TDXAPI_INTERFACE;


implementation


end.
