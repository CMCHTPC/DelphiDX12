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

   Copyright (c) 2003 Microsoft Corporation.  All rights reserved.
   Content: Longhorn Display Driver Model (LDDM) user/kernel mode
            shared data type definitions.

   This unit consists of the following header files
   File name: d3dukmdt.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3DUKMDT;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils;

    {$Z4}

const


    // WDDM DDI Interface Version


    DXGKDDI_INTERFACE_VERSION_VISTA = $1052;
    DXGKDDI_INTERFACE_VERSION_VISTA_SP1 = $1053;
    DXGKDDI_INTERFACE_VERSION_WIN7 = $2005;
    DXGKDDI_INTERFACE_VERSION_WIN8 = $300E;
    DXGKDDI_INTERFACE_VERSION_WDDM1_3 = $4002;
    DXGKDDI_INTERFACE_VERSION_WDDM1_3_PATH_INDEPENDENT_ROTATION = $4003;
    DXGKDDI_INTERFACE_VERSION_WDDM2_0 = $5023;
    DXGKDDI_INTERFACE_VERSION_WDDM2_1 = $6003;
    DXGKDDI_INTERFACE_VERSION_WDDM2_1_5 = $6010; // Used in RS1.7 for GPU-P
    DXGKDDI_INTERFACE_VERSION_WDDM2_1_6 = $6011; // Used in RS1.8 for GPU-P
    DXGKDDI_INTERFACE_VERSION_WDDM2_2 = $700A;
    DXGKDDI_INTERFACE_VERSION_WDDM2_3 = $8001;
    DXGKDDI_INTERFACE_VERSION_WDDM2_4 = $9006;
    DXGKDDI_INTERFACE_VERSION_WDDM2_5 = $A00B;
    DXGKDDI_INTERFACE_VERSION_WDDM2_6 = $B004;
    DXGKDDI_INTERFACE_VERSION_WDDM2_7 = $C004;
    DXGKDDI_INTERFACE_VERSION_WDDM2_8 = $D001;
    DXGKDDI_INTERFACE_VERSION_WDDM2_9 = $E003;
    DXGKDDI_INTERFACE_VERSION_WDDM3_0 = $F003;
    DXGKDDI_INTERFACE_VERSION_WDDM3_1 = $10004;
    DXGKDDI_INTERFACE_VERSION_WDDM3_2 = $11007;


    DXGKDDI_INTERFACE_VERSION = DXGKDDI_INTERFACE_VERSION_WDDM3_2;


    D3D_UMD_INTERFACE_VERSION_VISTA = $000C;
    D3D_UMD_INTERFACE_VERSION_WIN7 = $2003;
    D3D_UMD_INTERFACE_VERSION_WIN8_M3 = $3001;
    D3D_UMD_INTERFACE_VERSION_WIN8_CP = $3002;
    D3D_UMD_INTERFACE_VERSION_WIN8_RC = $3003;
    D3D_UMD_INTERFACE_VERSION_WIN8 = $3004;
    D3D_UMD_INTERFACE_VERSION_WDDM1_3 = $4002;

    D3D_UMD_INTERFACE_VERSION_WDDM2_0_M1 = $5000;
    D3D_UMD_INTERFACE_VERSION_WDDM2_0_M1_3 = $5001;
    D3D_UMD_INTERFACE_VERSION_WDDM2_0_M2_2 = $5002;
    D3D_UMD_INTERFACE_VERSION_WDDM2_0 = $5002;

    D3D_UMD_INTERFACE_VERSION_WDDM2_1_1 = $6000;
    D3D_UMD_INTERFACE_VERSION_WDDM2_1_2 = $6001;
    D3D_UMD_INTERFACE_VERSION_WDDM2_1_3 = $6002;
    D3D_UMD_INTERFACE_VERSION_WDDM2_1_4 = $6003;
    D3D_UMD_INTERFACE_VERSION_WDDM2_1 = D3D_UMD_INTERFACE_VERSION_WDDM2_1_4;

    D3D_UMD_INTERFACE_VERSION_WDDM2_2_1 = $7000;
    D3D_UMD_INTERFACE_VERSION_WDDM2_2_2 = $7001;
    D3D_UMD_INTERFACE_VERSION_WDDM2_2 = D3D_UMD_INTERFACE_VERSION_WDDM2_2_2;

    D3D_UMD_INTERFACE_VERSION_WDDM2_3_1 = $8000;
    D3D_UMD_INTERFACE_VERSION_WDDM2_3_2 = $8001;
    D3D_UMD_INTERFACE_VERSION_WDDM2_3 = D3D_UMD_INTERFACE_VERSION_WDDM2_3_2;

    D3D_UMD_INTERFACE_VERSION_WDDM2_4_1 = $9000;
    D3D_UMD_INTERFACE_VERSION_WDDM2_4_2 = $9001;
    D3D_UMD_INTERFACE_VERSION_WDDM2_4 = D3D_UMD_INTERFACE_VERSION_WDDM2_4_2;

    D3D_UMD_INTERFACE_VERSION_WDDM2_5_1 = $A000;
    D3D_UMD_INTERFACE_VERSION_WDDM2_5_2 = $A001;
    D3D_UMD_INTERFACE_VERSION_WDDM2_5_3 = $A002;
    D3D_UMD_INTERFACE_VERSION_WDDM2_5 = D3D_UMD_INTERFACE_VERSION_WDDM2_5_3;

    D3D_UMD_INTERFACE_VERSION_WDDM2_6_1 = $B000;
    D3D_UMD_INTERFACE_VERSION_WDDM2_6_2 = $B001;
    D3D_UMD_INTERFACE_VERSION_WDDM2_6_3 = $B002;
    D3D_UMD_INTERFACE_VERSION_WDDM2_6_4 = $B003;
    D3D_UMD_INTERFACE_VERSION_WDDM2_6 = D3D_UMD_INTERFACE_VERSION_WDDM2_6_4;

    D3D_UMD_INTERFACE_VERSION_WDDM2_7_1 = $C000;
    D3D_UMD_INTERFACE_VERSION_WDDM2_7_2 = $C001;
    D3D_UMD_INTERFACE_VERSION_WDDM2_7 = D3D_UMD_INTERFACE_VERSION_WDDM2_7_2;

    D3D_UMD_INTERFACE_VERSION_WDDM2_8_1 = $D000;
    D3D_UMD_INTERFACE_VERSION_WDDM2_8 = D3D_UMD_INTERFACE_VERSION_WDDM2_8_1;

    D3D_UMD_INTERFACE_VERSION_WDDM2_9_1 = $E000;
    D3D_UMD_INTERFACE_VERSION_WDDM2_9 = D3D_UMD_INTERFACE_VERSION_WDDM2_9_1;

    D3D_UMD_INTERFACE_VERSION_WDDM3_0_1 = $F000;
    D3D_UMD_INTERFACE_VERSION_WDDM3_0 = D3D_UMD_INTERFACE_VERSION_WDDM3_0_1;

    D3D_UMD_INTERFACE_VERSION_WDDM3_1_1 = $10000;
    D3D_UMD_INTERFACE_VERSION_WDDM3_1 = D3D_UMD_INTERFACE_VERSION_WDDM3_1_1;

    D3D_UMD_INTERFACE_VERSION_WDDM3_2_1 = $11000;
    D3D_UMD_INTERFACE_VERSION_WDDM3_2 = D3D_UMD_INTERFACE_VERSION_WDDM3_2_1;

    // Components which depend on D3D_UMD_INTERFACE_VERSION need to be updated, static assert validation present.
    // Search for D3D_UMD_INTERFACE_VERSION across all depots to ensure all dependencies are updated.


    D3D_UMD_INTERFACE_VERSION = D3D_UMD_INTERFACE_VERSION_WDDM3_2;


    D3DGPU_UNIQUE_DRIVER_PROTECTION = $8000000000000000;

    DXGK_MAX_PAGE_TABLE_LEVEL_COUNT = 6;
    DXGK_MIN_PAGE_TABLE_LEVEL_COUNT = 2;
    DXGK_MAX_GPU_VA_BIT_COUNT = 63;


    D3DGPU_NULL = 0;
    D3DDDI_MAX_WRITTEN_PRIMARIES = 16;
    D3DDDI_MAX_MPO_PRESENT_DIRTY_RECTS = $FFF;


    // Used as a value for D3DDDI_VIDEO_PRESENT_SOURCE_ID and D3DDDI_VIDEO_PRESENT_TARGET_ID types to specify
    // that the respective video present source/target ID hasn't been initialized.
    D3DDDI_ID_UNINITIALIZED = not UINT(0);

    // TODO:[mmilirud] Define this as (UINT)(~1) to avoid collision with valid source ID equal to 0.

    // Used as a value for D3DDDI_VIDEO_PRESENT_SOURCE_ID and D3DDDI_VIDEO_PRESENT_TARGET_ID types to specify
    // that the respective video present source/target ID isn't applicable for the given execution context.
    D3DDDI_ID_NOTAPPLICABLE = UINT(0);

    // Indicates that a resource can be associated with "any" VidPn source, even none at all.
    D3DDDI_ID_ANY = not UINT(1);

    // Used as a value for D3DDDI_VIDEO_PRESENT_SOURCE_ID and D3DDDI_VIDEO_PRESENT_TARGET_ID types to specify
    // that the respective video present source/target ID describes every VidPN source/target in question.
    D3DDDI_ID_ALL = not UINT(2);


    // Hardcoded VidPnSource count

    D3DKMDT_MAX_VIDPN_SOURCES_BITCOUNT = 4;
    D3DKMDT_MAX_VIDPN_SOURCES = (1 shl D3DKMDT_MAX_VIDPN_SOURCES_BITCOUNT);


    D3DDDI_MAX_OBJECT_WAITED_ON = 32;
    D3DDDI_MAX_OBJECT_SIGNALED = 32;


    D3DDDI_SYNC_OBJECT_WAIT = $1;
    D3DDDI_SYNC_OBJECT_SIGNAL = $2;
    D3DDDI_SYNC_OBJECT_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED or SYNCHRONIZE or D3DDDI_SYNC_OBJECT_WAIT or D3DDDI_SYNC_OBJECT_SIGNAL);


    D3DDDI_NATIVE_FENCE_PDD_SIZE = 64;

    D3DDDI_DOORBELL_PRIVATEDATA_MAX_BYTES_WDDM3_1 = 16;


    // Defines the maximum number of context a particular command buffer can
    // be broadcast to.

    D3DDDI_MAX_BROADCAST_CONTEXT = 64;


    // Allocation priorities.

    D3DDDI_ALLOCATIONPRIORITY_MINIMUM = $28000000;
    D3DDDI_ALLOCATIONPRIORITY_LOW = $50000000;
    D3DDDI_ALLOCATIONPRIORITY_NORMAL = $78000000;
    D3DDDI_ALLOCATIONPRIORITY_HIGH = $a0000000;
    D3DDDI_ALLOCATIONPRIORITY_MAXIMUM = $c8000000;


    // Cross adapter resource pitch alignment in bytes.
    // Must be power of 2.

    D3DKMT_CROSS_ADAPTER_RESOURCE_PITCH_ALIGNMENT = 128;

    // Cross adapter resource height alignment in rows.

    D3DKMT_CROSS_ADAPTER_RESOURCE_HEIGHT_ALIGNMENT = 4;


    DXGK_FEATURE_ID_CATEGORY_BITS = 4;
    DXGK_FEATURE_ID_FEATURE_BITS = (32 - DXGK_FEATURE_ID_CATEGORY_BITS);
    DXGK_FEATURE_ID_CATEGORY_SHIFT = (32 - DXGK_FEATURE_ID_CATEGORY_BITS);
    DXGK_FEATURE_ID_MASK = ((1 shl DXGK_FEATURE_ID_CATEGORY_SHIFT) - 1);


    D3DDDI_MAXTESTBUFFERSIZE = 4096;
    D3DDDI_MAXTESTBUFFERPRIVATEDRIVERDATASIZE = 1024;


    // Define the method codes for how buffers are passed for I/O and FS controls


    METHOD_BUFFERED = 0;
    METHOD_IN_DIRECT = 1;
    METHOD_OUT_DIRECT = 2;
    METHOD_NEITHER = 3;

    FILE_ANY_ACCESS = 0;
    FILE_READ_ACCESS = ($0001); // file & pipe
    FILE_WRITE_ACCESS = ($0002); // file & pipe

    FILE_DEVICE_UNKNOWN = 34;


    // IOCTL_GPUP_DRIVER_ESCAPE - The user mode emulation DLL calls this IOCTL
    // to exchange information with the kernel mode driver.

    IOCTL_GPUP_DRIVER_ESCAPE = (FILE_DEVICE_UNKNOWN shl 16) or ((8 + $910) shl 2) or METHOD_BUFFERED or (FILE_READ_DATA shl 14);

type


    // Available only for Vista (LONGHORN) and later and for
    // multiplatform tools such as debugger extensions


    // Available only for Vista (LONGHORN) and later and for
    // multiplatform tools such as debugger extensions

    TD3DGPU_VIRTUAL_ADDRESS = ULONGLONG;
    TD3DGPU_SIZE_T = ULONGLONG;


    // IOCTL_GPUP_DRIVER_ESCAPE - The user mode emulation DLL calls this IOCTL
    // to exchange information with the kernel mode driver.


    // IOCTL_GPUP_DRIVER_ESCAPE - The user mode emulation DLL calls this IOCTL
    // to exchange information with the kernel mode driver.


    _GPUP_DRIVER_ESCAPE_INPUT = record
        vfLUID: LUID; //LUID that was returned from SET_PARTITION_DETAILS
    end;
    TGPUP_DRIVER_ESCAPE_INPUT = _GPUP_DRIVER_ESCAPE_INPUT;
    PGPUP_DRIVER_ESCAPE_INPUT = ^TGPUP_DRIVER_ESCAPE_INPUT;


    _DXGKVGPU_ESCAPE_TYPE = (
        DXGKVGPU_ESCAPE_TYPE_READ_PCI_CONFIG = 0,
        DXGKVGPU_ESCAPE_TYPE_WRITE_PCI_CONFIG = 1,
        DXGKVGPU_ESCAPE_TYPE_INITIALIZE = 2,
        DXGKVGPU_ESCAPE_TYPE_RELEASE = 3,
        DXGKVGPU_ESCAPE_TYPE_GET_VGPU_TYPE = 4,
        DXGKVGPU_ESCAPE_TYPE_POWERTRANSITIONCOMPLETE = 5,
        DXGKVGPU_ESCAPE_TYPE_PAUSE = 6,
        DXGKVGPU_ESCAPE_TYPE_RESUME = 7);

    TDXGKVGPU_ESCAPE_TYPE = _DXGKVGPU_ESCAPE_TYPE;
    PDXGKVGPU_ESCAPE_TYPE = ^TDXGKVGPU_ESCAPE_TYPE;


    _DXGKVGPU_ESCAPE_HEAD = record
        Luid: TGPUP_DRIVER_ESCAPE_INPUT;
        EscapeType: TDXGKVGPU_ESCAPE_TYPE;
    end;
    TDXGKVGPU_ESCAPE_HEAD = _DXGKVGPU_ESCAPE_HEAD;
    PDXGKVGPU_ESCAPE_HEAD = ^TDXGKVGPU_ESCAPE_HEAD;


    _DXGKVGPU_ESCAPE_READ_PCI_CONFIG = record
        Header: TDXGKVGPU_ESCAPE_HEAD;
        Offset: UINT; // Offset in bytes in the PCI config space
        Size: UINT; // Size in bytes to read
    end;
    TDXGKVGPU_ESCAPE_READ_PCI_CONFIG = _DXGKVGPU_ESCAPE_READ_PCI_CONFIG;
    PDXGKVGPU_ESCAPE_READ_PCI_CONFIG = ^TDXGKVGPU_ESCAPE_READ_PCI_CONFIG;


    _DXGKVGPU_ESCAPE_WRITE_PCI_CONFIG = record
        Header: TDXGKVGPU_ESCAPE_HEAD;
        Offset: UINT; // Offset in bytes in the PCI config space
        Size: UINT; // Size in bytes to write
    end;
    TDXGKVGPU_ESCAPE_WRITE_PCI_CONFIG = _DXGKVGPU_ESCAPE_WRITE_PCI_CONFIG;
    PDXGKVGPU_ESCAPE_WRITE_PCI_CONFIG = ^TDXGKVGPU_ESCAPE_WRITE_PCI_CONFIG;


    _DXGKVGPU_ESCAPE_READ_VGPU_TYPE = record
        Header: TDXGKVGPU_ESCAPE_HEAD;
    end;
    TDXGKVGPU_ESCAPE_READ_VGPU_TYPE = _DXGKVGPU_ESCAPE_READ_VGPU_TYPE;
    PDXGKVGPU_ESCAPE_READ_VGPU_TYPE = ^TDXGKVGPU_ESCAPE_READ_VGPU_TYPE;


    _DXGKVGPU_ESCAPE_POWERTRANSITIONCOMPLETE = record
        Header: TDXGKVGPU_ESCAPE_HEAD;
        PowerState: UINT;
    end;
    TDXGKVGPU_ESCAPE_POWERTRANSITIONCOMPLETE = _DXGKVGPU_ESCAPE_POWERTRANSITIONCOMPLETE;
    PDXGKVGPU_ESCAPE_POWERTRANSITIONCOMPLETE = ^TDXGKVGPU_ESCAPE_POWERTRANSITIONCOMPLETE;


    _DXGKVGPU_ESCAPE_INITIALIZE = record
        Header: TDXGKVGPU_ESCAPE_HEAD;
        VmGuid: TGUID;
    end;
    TDXGKVGPU_ESCAPE_INITIALIZE = _DXGKVGPU_ESCAPE_INITIALIZE;
    PDXGKVGPU_ESCAPE_INITIALIZE = ^TDXGKVGPU_ESCAPE_INITIALIZE;


    _DXGKVGPU_ESCAPE_RELEASE = record
        Header: TDXGKVGPU_ESCAPE_HEAD;
    end;
    TDXGKVGPU_ESCAPE_RELEASE = _DXGKVGPU_ESCAPE_RELEASE;
    PDXGKVGPU_ESCAPE_RELEASE = ^TDXGKVGPU_ESCAPE_RELEASE;


    _DXGKVGPU_ESCAPE_PAUSE = bitpacked record
        Header: TDXGKVGPU_ESCAPE_HEAD;
        DeviceLuid: TLUID;
        case integer of
            0: (
                GuestVmRunning: 0..1;
            );
            1: (
                Flags: UINT;
            );
    end;
    TDXGKVGPU_ESCAPE_PAUSE = _DXGKVGPU_ESCAPE_PAUSE;
    PDXGKVGPU_ESCAPE_PAUSE = ^TDXGKVGPU_ESCAPE_PAUSE;


    _DXGKVGPU_ESCAPE_RESUME = record
        Header: TDXGKVGPU_ESCAPE_HEAD;
        DeviceLuid: TLUID;
        Flags: UINT; // enum GPUP_SAVE_RESTORE_PAUSE_STATE
    end;
    TDXGKVGPU_ESCAPE_RESUME = _DXGKVGPU_ESCAPE_RESUME;
    PDXGKVGPU_ESCAPE_RESUME = ^TDXGKVGPU_ESCAPE_RESUME;


    _DXGK_PTE_PAGE_SIZE = (
        DXGK_PTE_PAGE_TABLE_PAGE_4KB = 0,
        DXGK_PTE_PAGE_TABLE_PAGE_64KB = 1);

    TDXGK_PTE_PAGE_SIZE = _DXGK_PTE_PAGE_SIZE;
    PDXGK_PTE_PAGE_SIZE = ^TDXGK_PTE_PAGE_SIZE;


    //  Page Table Entry structure. Contains segment/physical address pointing to a page


    _DXGK_PTE = bitpacked record
        case integer of
            0: (
                Valid: 0..1;
                Zero: 0..1;
                CacheCoherent: 0..1;
                ReadOnly: 0..1;
                NoExecute: 0..1;
                Segment: 0..31;
                LargePage: 0..1;
                PhysicalAdapterIndex: 0..63;
                PageTablePageSize: 0..3; // DXGK_PTE_PAGE_SIZE
                SystemReserved0: 0..1;
                Reserved: 0..4095;

                case integer of
                    0: (
                    PageAddress: ULONGLONG; // High 52 bits of 64 bit physical address. Low 12 bits are zero.
                    );
                    1: (
                    PageTableAddress: ULONGLONG; // High 52 bits of 64 bit physical address. Low 12 bits are zero.
                    );

            );
            1: (
                Flags: ULONGLONG;
            );
    end;
    TDXGK_PTE = _DXGK_PTE;
    PDXGK_PTE = ^TDXGK_PTE;


    _D3DGPU_PHYSICAL_ADDRESS = record
        SegmentId: UINT;
        Padding: UINT;
        SegmentOffset: uint64;
    end;
    TD3DGPU_PHYSICAL_ADDRESS = _D3DGPU_PHYSICAL_ADDRESS;
    PD3DGPU_PHYSICAL_ADDRESS = ^TD3DGPU_PHYSICAL_ADDRESS;


    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Purpose: Video present source unique identification number descriptor type


    TD3DDDI_VIDEO_PRESENT_SOURCE_ID = UINT;

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Purpose: Video present source unique identification number descriptor type.

    TD3DDDI_VIDEO_PRESENT_TARGET_ID = UINT;


    // DDI level handle that represents a kernel mode object (allocation, device, etc)

    TD3DKMT_HANDLE = UINT;
    PD3DKMT_HANDLE = ^TD3DKMT_HANDLE;

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Purpose: Video present target mode fractional frequency descriptor type.

    // Remarks: Fractional value used to represent vertical and horizontal frequencies of a video mode
    //          (i.e. VSync and HSync). Vertical frequencies are stored in Hz. Horizontal frequencies
    //          are stored in Hz.
    //          The dynamic range of this encoding format, given 10^-7 resolution is {0..(2^32 - 1) / 10^7},
    //          which translates to {0..428.4967296} [Hz] for vertical frequencies and {0..428.4967296} [Hz]
    //          for horizontal frequencies. This sub-microseconds precision range should be acceptable even
    //          for a pro-video application (error in one microsecond for video signal synchronization would
    //          imply a time drift with a cycle of 10^7/(60*60*24) = 115.741 days.

    //          If rational number with a finite fractional sequence, use denominator of form 10^(length of fractional sequence).
    //          If rational number without a finite fractional sequence, or a sequence exceeding the precision allowed by the
    //          dynamic range of the denominator, or an irrational number, use an appropriate ratio of integers which best
    //          represents the value.

    _D3DDDI_RATIONAL = record
        Numerator: UINT;
        Denominator: UINT;
    end;
    TD3DDDI_RATIONAL = _D3DDDI_RATIONAL;
    PD3DDDI_RATIONAL = ^TD3DDDI_RATIONAL;


    // These macros are used to enable non-Windows 32-bit usermode to fill out a fixed-size
    // structure for D3DKMT structures, so that they can be sent to a 64-bit kernel
    // without a thunking layer for translation.

    // Note that a thunking layer is still used for wchar_t translation, where Windows uses
    // 16-bit characters and non-Windows uses 32-bit characters.

    // If brace initialization is used (e.g. D3DKMT_FOO foo = { a, b, c }), be aware that for
    // non-Windows, pointers will be unioned such that a 64-bit integer is the member that is
    // initialized. It is not possible to achieve both type safety and proper zero-initialization
    // of the high bits of pointers with brace initialization in this model. Use D3DKMT_PTR_INIT(ptr)
    // to appropriately cast to a 64-bit integer for non-Windows, or to pass the pointer unchanged for
    // Windows. To maintain type safety, manually assign the fields after zero-initializing the struct.


    {$ifdef WIN32}
    // For Windows, don't enforce any unnatural alignment or data sizes/types.
// The WOW64 thunking layer will handle translation.
  D3DKMT_SIZE_T = SIZE_T;
  D3DKMT_UINT_PTR = UINT_PTR;
  D3DKMT_ULONG_PTR = ULONG_PTR;
  D3DKMT_PTR_TYPE = HANDLE;
  TD3DKMT_PTR_VOID = HANDLE;
    {$else}
    // For other platforms, struct layout should be fixed-size, x64-compatible
    D3DKMT_SIZE_T = uint64;
    D3DKMT_UINT_PTR = uint64;
    D3DKMT_ULONG_PTR = uint64;
    _D3DKMT_PTR_TYPE = record
        case integer of
            0: (
                Ptr_Align: uint64);
            1: (Ptr: HANDLE);
    end align (8);
    TD3DKMT_PTR_TYPE = _D3DKMT_PTR_TYPE;

    TD3DKMT_PTR_VOID = record
        case integer of
            0: (ptr_Align: uint64);
            1: (Ptr: pointer);
    end align (8);
    {$endif}

    TD3DKMT_PT_UINTR = pointer; // ToDo


    _D3DDDI_ALLOCATIONINFO = record
        hAllocation: TD3DKMT_HANDLE; // out: Private driver data for allocation
        pSystemMem: TD3DKMT_PTR_VOID; // in: Pointer to pre-allocated sysmem
        pPrivateDriverData: TD3DKMT_PTR_VOID; // in(out optional): Private data for each allocation
        PrivateDriverDataSize: UINT; // in: Size of the private data
        VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID; // in: VidPN source ID if this is a primary
        case integer of
            0: (
                Flags: bitpacked record
                    Primary: 0..1; // 0x00000001
                    Stereo: 0..1; // 0x00000002
                    Reserved: 0..1073741823; // 0xFFFFFFFC
                    end;
            );
            1: (
                Value: UINT;
            );
    end;
    TD3DDDI_ALLOCATIONINFO = _D3DDDI_ALLOCATIONINFO;
    PD3DDDI_ALLOCATIONINFO = ^TD3DDDI_ALLOCATIONINFO;


    _D3DDDI_ALLOCATIONINFO2 = record
        hAllocation: TD3DKMT_HANDLE; // out: Private driver data for allocation
        case integer of
            0: (
                hSection: HANDLE; // in: Handle to valid section object

                pPrivateDriverData: TD3DKMT_PTR_VOID; // in(out optional): Private data for each allocation
                PrivateDriverDataSize: UINT; // in: Size of the private data
                VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID; // in: VidPN source ID if this is a primary

                case integer of
                    0: (
                    Flags: bitpacked record
                        Primary: 0..1; // 0x00000001
                        Stereo: 0..1; // 0x00000002
                        OverridePriority: 0..1; // 0x00000004
                        Reserved: 0..536870911; // 0xFFFFFFF8
                        end;

                    puVirtualAddress: TD3DGPU_VIRTUAL_ADDRESS;  // out: GPU Virtual address of the allocation created.

                    case integer of
                        0: (
                        Priority: UINT; // in: priority of allocation
                        Reserved: array [0..5 - 1] of ULONG_PTR; // Reserved
                        );
                        1: (
                        Unused: ULONG_PTR;
                        );
                    );

                    1: (
                    Value: UINT;
                    );


            );

            1: (
                pSystemMem: PVOID; // in: Pointer to pre-allocated sysmem
            );
    end {$IFDEF WIN64}align(8){$ELSE} align (4){$ENDIF};

    TD3DDDI_ALLOCATIONINFO2 = _D3DDDI_ALLOCATIONINFO2;
    PD3DDDI_ALLOCATIONINFO2 = ^TD3DDDI_ALLOCATIONINFO2;


    _D3DDDI_OPENALLOCATIONINFO = record
        hAllocation: TD3DKMT_HANDLE; // in: Handle for this allocation in this process
        pPrivateDriverData: TD3DKMT_PTR_VOID; // in: Ptr to driver private buffer for this allocations
        PrivateDriverDataSize: UINT; // in: Size in bytes of driver private buffer for this allocations
    end;
    TD3DDDI_OPENALLOCATIONINFO = _D3DDDI_OPENALLOCATIONINFO;
    PD3DDDI_OPENALLOCATIONINFO = ^TD3DDDI_OPENALLOCATIONINFO;


    _D3DDDI_OPENALLOCATIONINFO2 = record
        hAllocation: TD3DKMT_HANDLE; // in: Handle for this allocation in this process
        pPrivateDriverData: TD3DKMT_PTR_VOID; // in: Ptr to driver private buffer for this allocations
        PrivateDriverDataSize: UINT; // in: Size in bytes of driver private buffer for this allocations
        GpuVirtualAddress: TD3DGPU_VIRTUAL_ADDRESS; // out: GPU Virtual address of the allocation opened.
        Reserved: array [0..6 - 1] of ULONG_PTR; // Reserved
    end;
    TD3DDDI_OPENALLOCATIONINFO2 = _D3DDDI_OPENALLOCATIONINFO2;
    PD3DDDI_OPENALLOCATIONINFO2 = ^TD3DDDI_OPENALLOCATIONINFO2;


    _D3DDDI_OFFER_PRIORITY = (
        D3DDDI_OFFER_PRIORITY_NONE = 0, // Do not offer
        D3DDDI_OFFER_PRIORITY_LOW = 1, // Content is not useful
        D3DDDI_OFFER_PRIORITY_NORMAL, // Content is useful but easy to regenerate
        D3DDDI_OFFER_PRIORITY_HIGH, // Content is useful and difficult to regenerate
        D3DDDI_OFFER_PRIORITY_AUTO// Let VidMm decide offer priority based on eviction priority
        );

    TD3DDDI_OFFER_PRIORITY = _D3DDDI_OFFER_PRIORITY;
    PD3DDDI_OFFER_PRIORITY = ^TD3DDDI_OFFER_PRIORITY;


    _D3DDDI_ALLOCATIONLIST = bitpacked record
        hAllocation: TD3DKMT_HANDLE;
        case integer of
            0: (
                WriteOperation: 0..1; // 0x00000001
                DoNotRetireInstance: 0..1; // 0x00000002
                OfferPriority: 0..7; // 0x0000001C D3DDDI_OFFER_PRIORITY
                Reserved: 0..134217727; // 0xFFFFFFE0
            );
            1: (
                Value: UINT;
            );
    end;
    TD3DDDI_ALLOCATIONLIST = _D3DDDI_ALLOCATIONLIST;
    PD3DDDI_ALLOCATIONLIST = ^TD3DDDI_ALLOCATIONLIST;


    _D3DDDI_PATCHLOCATIONLIST = bitpacked record
        AllocationIndex: UINT;
        case integer of
            0: (
                SlotId: 0..16777215; // 0x00FFFFFF
                Reserved: 0..255; // 0xFF000000

                DriverId: UINT;
                AllocationOffset: UINT;
                PatchOffset: UINT;
                SplitOffset: UINT;
            );
            1: (
                Value: UINT;
            );
    end;
    TD3DDDI_PATCHLOCATIONLIST = _D3DDDI_PATCHLOCATIONLIST;
    PD3DDDI_PATCHLOCATIONLIST = ^TD3DDDI_PATCHLOCATIONLIST;


    _D3DDDICB_LOCKFLAGS = bitpacked record
        case integer of
            0: (
                ReadOnly: 0..1; // 0x00000001
                WriteOnly: 0..1; // 0x00000002
                DonotWait: 0..1; // 0x00000004
                IgnoreSync: 0..1; // 0x00000008
                LockEntire: 0..1; // 0x00000010
                DonotEvict: 0..1; // 0x00000020
                AcquireAperture: 0..1; // 0x00000040
                Discard: 0..1; // 0x00000080
                NoExistingReference: 0..1; // 0x00000100
                UseAlternateVA: 0..1; // 0x00000200
                IgnoreReadSync: 0..1; // 0x00000400
                Reserved: 0..2097151; // 0xFFFFF800
            );
            1: (
                Value: UINT;
            );
    end;
    TD3DDDICB_LOCKFLAGS = _D3DDDICB_LOCKFLAGS;
    PD3DDDICB_LOCKFLAGS = ^TD3DDDICB_LOCKFLAGS;


    _D3DDDICB_LOCK2FLAGS = bitpacked record
        case integer of
            0: (
                Reserved: 0..0; // 0xFFFFFFFF
            );
            1: (
                Value: UINT;
            );
    end;
    TD3DDDICB_LOCK2FLAGS = _D3DDDICB_LOCK2FLAGS;
    PD3DDDICB_LOCK2FLAGS = ^TD3DDDICB_LOCK2FLAGS;


    _D3DDDICB_DESTROYALLOCATION2FLAGS = record
        case integer of
            0: (
                AssumeNotInUse: 0..1; // 0x00000001
                SynchronousDestroy: 0..1; // 0x00000002
                Reserved: 0..536870911; // 0x7FFFFFFC
                SystemUseOnly: 0..1; // 0x80000000  // Should not be set by the UMD
            );
            1: (
                Value: UINT;
            );
    end;
    TD3DDDICB_DESTROYALLOCATION2FLAGS = _D3DDDICB_DESTROYALLOCATION2FLAGS;
    PD3DDDICB_DESTROYALLOCATION2FLAGS = ^TD3DDDICB_DESTROYALLOCATION2FLAGS;


    _D3DDDI_ESCAPEFLAGS = bitpacked record
        case integer of
            0: (
                HardwareAccess: 0..1; // 0x00000001
                DeviceStatusQuery: 0..1; // 0x00000002
                ChangeFrameLatency: 0..1; // 0x00000004
                NoAdapterSynchronization: 0..1; // 0x00000008
                Reserved: 0..1; // 0x00000010   Used internally by DisplayOnly present
                VirtualMachineData: 0..1; // 0x00000020   Cannot be set from user mode
                DriverKnownEscape: 0..1; // 0x00000040       // Driver private data points to a well known structure
                DriverCommonEscape: 0..1; // 0x00000080       // Private data points runtime defined structure
                Reserved2: 0..16777215; // 0xFFFFFF00

            );
            1: (
                Value: UINT;
            );
    end;
    TD3DDDI_ESCAPEFLAGS = _D3DDDI_ESCAPEFLAGS;
    PD3DDDI_ESCAPEFLAGS = ^TD3DDDI_ESCAPEFLAGS;


    _D3DDDI_DRIVERESCAPETYPE = (
        D3DDDI_DRIVERESCAPETYPE_TRANSLATEALLOCATIONHANDLE = 0,
        D3DDDI_DRIVERESCAPETYPE_TRANSLATERESOURCEHANDLE = 1,
        D3DDDI_DRIVERESCAPETYPE_CPUEVENTUSAGE = 2,
        D3DDDI_DRIVERESCAPETYPE_BUILDTESTCOMMANDBUFFER = 3,
        D3DDDI_DRIVERESCAPETYPE_MAX);

    TD3DDDI_DRIVERESCAPETYPE = _D3DDDI_DRIVERESCAPETYPE;
    PD3DDDI_DRIVERESCAPETYPE = ^TD3DDDI_DRIVERESCAPETYPE;


    _D3DDDI_DRIVERESCAPE_TRANSLATEALLOCATIONEHANDLE = record
        EscapeType: TD3DDDI_DRIVERESCAPETYPE;
        hAllocation: TD3DKMT_HANDLE;
    end;
    TD3DDDI_DRIVERESCAPE_TRANSLATEALLOCATIONEHANDLE = _D3DDDI_DRIVERESCAPE_TRANSLATEALLOCATIONEHANDLE;
    PD3DDDI_DRIVERESCAPE_TRANSLATEALLOCATIONEHANDLE = ^TD3DDDI_DRIVERESCAPE_TRANSLATEALLOCATIONEHANDLE;


    _D3DDDI_DRIVERESCAPE_TRANSLATERESOURCEHANDLE = record
        EscapeType: TD3DDDI_DRIVERESCAPETYPE;
        hResource: TD3DKMT_HANDLE;
    end;
    TD3DDDI_DRIVERESCAPE_TRANSLATERESOURCEHANDLE = _D3DDDI_DRIVERESCAPE_TRANSLATERESOURCEHANDLE;
    PD3DDDI_DRIVERESCAPE_TRANSLATERESOURCEHANDLE = ^TD3DDDI_DRIVERESCAPE_TRANSLATERESOURCEHANDLE;


    _D3DDDI_DRIVERESCAPE_CPUEVENTUSAGE = record
        EscapeType: TD3DDDI_DRIVERESCAPETYPE;
        hSyncObject: TD3DKMT_HANDLE;
        hKmdCpuEvent: uint64;
        Usage: array [0..8 - 1] of UINT;
    end;
    TD3DDDI_DRIVERESCAPE_CPUEVENTUSAGE = _D3DDDI_DRIVERESCAPE_CPUEVENTUSAGE;
    PD3DDDI_DRIVERESCAPE_CPUEVENTUSAGE = ^TD3DDDI_DRIVERESCAPE_CPUEVENTUSAGE;


    _D3DDDI_CREATECONTEXTFLAGS = bitpacked record
        case integer of
            0: (
                NullRendering: 0..1; // 0x00000001
                InitialData: 0..1; // 0x00000002
                DisableGpuTimeout: 0..1; // 0x00000004
                SynchronizationOnly: 0..1; // 0x00000008
                HwQueueSupported: 0..1; // 0x00000010
                NoKmdAccess: 0..1; // 0x00000020
                TestContext: 0..1; // 0x00000040
                Reserved: 0..33554431; // 0xFFFFFF80

            );
            1: (
                Value: UINT;
            );
    end;
    TD3DDDI_CREATECONTEXTFLAGS = _D3DDDI_CREATECONTEXTFLAGS;
    PD3DDDI_CREATECONTEXTFLAGS = ^TD3DDDI_CREATECONTEXTFLAGS;


    _D3DDDI_CREATEHWCONTEXTFLAGS = bitpacked record
        case integer of
            0: (
                Reserved: 0..0; // 0xFFFFFFFF
            );
            1: (
                Value: UINT;
            );
    end;
    TD3DDDI_CREATEHWCONTEXTFLAGS = _D3DDDI_CREATEHWCONTEXTFLAGS;
    PD3DDDI_CREATEHWCONTEXTFLAGS = ^TD3DDDI_CREATEHWCONTEXTFLAGS;


    _D3DDDI_CREATEHWQUEUEFLAGS = bitpacked record
        case integer of
            0: (
                DisableGpuTimeout: 0..1; // 0x00000001
                NoBroadcastSignal: 0..1; // 0x00000002
                NoBroadcastWait: 0..1; // 0x00000004
                NoKmdAccess: 0..1; // 0x00000008
                UserModeSubmission: 0..1; // 0x00000010
                NativeProgressFence: 0..1; // 0x00000020
                TestQueue: 0..1; // 0x00000040
                Reserved: 0..33554431; // 0xFFFFFF80
            );
            1: (
                Value: UINT;
            );
    end;
    TD3DDDI_CREATEHWQUEUEFLAGS = _D3DDDI_CREATEHWQUEUEFLAGS;
    PD3DDDI_CREATEHWQUEUEFLAGS = ^TD3DDDI_CREATEHWQUEUEFLAGS;


    _D3DDDI_SEGMENTPREFERENCE = bitpacked record
        case integer of
            0: (
                SegmentId0: 0..31; // 0x0000001F
                Direction0: 0..1; // 0x00000020
                SegmentId1: 0..31; // 0x000007C0
                Direction1: 0..1; // 0x00000800
                SegmentId2: 0..31; // 0x0001F000
                Direction2: 0..1; // 0x00020000
                SegmentId3: 0..31; // 0x007C0000
                Direction3: 0..1; // 0x00800000
                SegmentId4: 0..31; // 0x1F000000
                Direction4: 0..1; // 0x20000000
                Reserved: 0..3; // 0xC0000000

            );
            1: (
                Value: UINT;
            );

    end;
    TD3DDDI_SEGMENTPREFERENCE = _D3DDDI_SEGMENTPREFERENCE;
    PD3DDDI_SEGMENTPREFERENCE = ^TD3DDDI_SEGMENTPREFERENCE;


(* Formats
 * Most of these names have the following convention:
 *      A = Alpha
 *      R = Red
 *      G = Green
 *      B = Blue
 *      X = Unused Bits
 *      P = Palette
 *      L = Luminance
 *      U = dU coordinate for BumpMap
 *      V = dV coordinate for BumpMap
 *      S = Stencil
 *      D = Depth (e.g. Z or W buffer)
 *      C = Computed from other channels (typically on certain read operations)
 *
 *      Further, the order of the pieces are from MSB first; hence
 *      D3DFMT_A8L8 indicates that the high byte of this two byte
 *      format is alpha.
 *
 *      D16 indicates:
 *           - An integer 16-bit value.
 *           - An app-lockable surface.
 *
 *      All Depth/Stencil formats except D3DFMT_D16_LOCKABLE indicate:
 *          - no particular bit ordering per pixel, and
 *          - are not app lockable, and
 *          - the driver is allowed to consume more than the indicated
 *            number of bits per Depth channel (but not Stencil channel).
 *)

    _D3DDDIFORMAT = (
        D3DDDIFMT_UNKNOWN = 0,
        D3DDDIFMT_R8G8B8 = 20,
        D3DDDIFMT_A8R8G8B8 = 21,
        D3DDDIFMT_X8R8G8B8 = 22,
        D3DDDIFMT_R5G6B5 = 23,
        D3DDDIFMT_X1R5G5B5 = 24,
        D3DDDIFMT_A1R5G5B5 = 25,
        D3DDDIFMT_A4R4G4B4 = 26,
        D3DDDIFMT_R3G3B2 = 27,
        D3DDDIFMT_A8 = 28,
        D3DDDIFMT_A8R3G3B2 = 29,
        D3DDDIFMT_X4R4G4B4 = 30,
        D3DDDIFMT_A2B10G10R10 = 31,
        D3DDDIFMT_A8B8G8R8 = 32,
        D3DDDIFMT_X8B8G8R8 = 33,
        D3DDDIFMT_G16R16 = 34,
        D3DDDIFMT_A2R10G10B10 = 35,
        D3DDDIFMT_A16B16G16R16 = 36,
        D3DDDIFMT_A8P8 = 40,
        D3DDDIFMT_P8 = 41,
        D3DDDIFMT_L8 = 50,
        D3DDDIFMT_A8L8 = 51,
        D3DDDIFMT_A4L4 = 52,
        D3DDDIFMT_V8U8 = 60,
        D3DDDIFMT_L6V5U5 = 61,
        D3DDDIFMT_X8L8V8U8 = 62,
        D3DDDIFMT_Q8W8V8U8 = 63,
        D3DDDIFMT_V16U16 = 64,
        D3DDDIFMT_W11V11U10 = 65,
        D3DDDIFMT_A2W10V10U10 = 67,
        D3DDDIFMT_UYVY = (Ord('U') or (Ord('Y') shl 8) or (Ord('V') shl 16) or (Ord('Y') shl 24)),
        D3DDDIFMT_R8G8_B8G8 = (Ord('R') or (Ord('G') shl 8) or (Ord('B') shl 16) or (Ord('G') shl 24)),
        D3DDDIFMT_YUY2 = (Ord('Y') or (Ord('U') shl 8) or (Ord('Y') shl 16) or (Ord('2') shl 24)),
        D3DDDIFMT_G8R8_G8B8 = (Ord('G') or (Ord('R') shl 8) or (Ord('G') shl 16) or (Ord('B') shl 24)),
        D3DDDIFMT_DXT1 = (Ord('D') or (Ord('X') shl 8) or (Ord('T') shl 16) or (Ord('1') shl 24)),
        D3DDDIFMT_DXT2 = (Ord('D') or (Ord('X') shl 8) or (Ord('T') shl 16) or (Ord('2') shl 24)),
        D3DDDIFMT_DXT3 = (Ord('D') or (Ord('X') shl 8) or (Ord('T') shl 16) or (Ord('3') shl 24)),
        D3DDDIFMT_DXT4 = (Ord('D') or (Ord('X') shl 8) or (Ord('T') shl 16) or (Ord('4') shl 24)),
        D3DDDIFMT_DXT5 = (Ord('D') or (Ord('X') shl 8) or (Ord('T') shl 16) or (Ord('5') shl 24)),
        D3DDDIFMT_D16_LOCKABLE = 70,
        D3DDDIFMT_D32 = 71,
        D3DDDIFMT_D15S1 = 73,
        D3DDDIFMT_D24S8 = 75,
        D3DDDIFMT_D24X8 = 77,
        D3DDDIFMT_D24X4S4 = 79,
        D3DDDIFMT_D16 = 80,
        D3DDDIFMT_D32F_LOCKABLE = 82,
        D3DDDIFMT_D24FS8 = 83,
        D3DDDIFMT_D32_LOCKABLE = 84,
        D3DDDIFMT_S8_LOCKABLE = 85,
        D3DDDIFMT_S1D15 = 72,
        D3DDDIFMT_S8D24 = 74,
        D3DDDIFMT_X8D24 = 76,
        D3DDDIFMT_X4S4D24 = 78,
        D3DDDIFMT_L16 = 81,
        D3DDDIFMT_G8R8 = 91,
        D3DDDIFMT_R8 = 92,
        D3DDDIFMT_VERTEXDATA = 100,
        D3DDDIFMT_INDEX16 = 101,
        D3DDDIFMT_INDEX32 = 102,
        D3DDDIFMT_Q16W16V16U16 = 110,
        D3DDDIFMT_MULTI2_ARGB8 = (Ord('M') or (Ord('E') shl 8) or (Ord('T') shl 16) or (Ord('1') shl 24)),
        // Floating point surface formats
        // s10e5 formats (16-bits per channel)
        D3DDDIFMT_R16F = 111,
        D3DDDIFMT_G16R16F = 112,
        D3DDDIFMT_A16B16G16R16F = 113,
        // IEEE s23e8 formats (32-bits per channel)
        D3DDDIFMT_R32F = 114,
        D3DDDIFMT_G32R32F = 115,
        D3DDDIFMT_A32B32G32R32F = 116,
        D3DDDIFMT_CxV8U8 = 117,
        // Monochrome 1 bit per pixel format
        D3DDDIFMT_A1 = 118,
        // 2.8 biased fixed point
        D3DDDIFMT_A2B10G10R10_XR_BIAS = 119,
        // Decode compressed buffer formats
        D3DDDIFMT_DXVACOMPBUFFER_BASE = 150,
        D3DDDIFMT_PICTUREPARAMSDATA = D3DDDIFMT_DXVACOMPBUFFER_BASE + 0, // 150
        D3DDDIFMT_MACROBLOCKDATA = D3DDDIFMT_DXVACOMPBUFFER_BASE + 1, // 151
        D3DDDIFMT_RESIDUALDIFFERENCEDATA = D3DDDIFMT_DXVACOMPBUFFER_BASE + 2, // 152
        D3DDDIFMT_DEBLOCKINGDATA = D3DDDIFMT_DXVACOMPBUFFER_BASE + 3, // 153
        D3DDDIFMT_INVERSEQUANTIZATIONDATA = D3DDDIFMT_DXVACOMPBUFFER_BASE + 4, // 154
        D3DDDIFMT_SLICECONTROLDATA = D3DDDIFMT_DXVACOMPBUFFER_BASE + 5, // 155
        D3DDDIFMT_BITSTREAMDATA = D3DDDIFMT_DXVACOMPBUFFER_BASE + 6, // 156
        D3DDDIFMT_MOTIONVECTORBUFFER = D3DDDIFMT_DXVACOMPBUFFER_BASE + 7, // 157
        D3DDDIFMT_FILMGRAINBUFFER = D3DDDIFMT_DXVACOMPBUFFER_BASE + 8, // 158
        D3DDDIFMT_DXVA_RESERVED9 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 9, // 159
        D3DDDIFMT_DXVA_RESERVED10 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 10, // 160
        D3DDDIFMT_DXVA_RESERVED11 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 11, // 161
        D3DDDIFMT_DXVA_RESERVED12 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 12, // 162
        D3DDDIFMT_DXVA_RESERVED13 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 13, // 163
        D3DDDIFMT_DXVA_RESERVED14 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 14, // 164
        D3DDDIFMT_DXVA_RESERVED15 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 15, // 165
        D3DDDIFMT_DXVA_RESERVED16 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 16, // 166
        D3DDDIFMT_DXVA_RESERVED17 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 17, // 167
        D3DDDIFMT_DXVA_RESERVED18 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 18, // 168
        D3DDDIFMT_DXVA_RESERVED19 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 19, // 169
        D3DDDIFMT_DXVA_RESERVED20 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 20, // 170
        D3DDDIFMT_DXVA_RESERVED21 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 21, // 171
        D3DDDIFMT_DXVA_RESERVED22 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 22, // 172
        D3DDDIFMT_DXVA_RESERVED23 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 23, // 173
        D3DDDIFMT_DXVA_RESERVED24 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 24, // 174
        D3DDDIFMT_DXVA_RESERVED25 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 25, // 175
        D3DDDIFMT_DXVA_RESERVED26 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 26, // 176
        D3DDDIFMT_DXVA_RESERVED27 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 27, // 177
        D3DDDIFMT_DXVA_RESERVED28 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 28, // 178
        D3DDDIFMT_DXVA_RESERVED29 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 29, // 179
        D3DDDIFMT_DXVA_RESERVED30 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 30, // 180
        D3DDDIFMT_DXVA_RESERVED31 = D3DDDIFMT_DXVACOMPBUFFER_BASE + 31, // 181
        D3DDDIFMT_DXVACOMPBUFFER_MAX = D3DDDIFMT_DXVA_RESERVED31,
        D3DDDIFMT_BINARYBUFFER = 199,
        D3DDDIFMT_FORCE_UINT = $7fffffff);

    TD3DDDIFORMAT = _D3DDDIFORMAT;
    PD3DDDIFORMAT = ^TD3DDDIFORMAT;


    TD3DDDI_COLOR_SPACE_TYPE = (
        D3DDDI_COLOR_SPACE_RGB_FULL_G22_NONE_P709 = 0,
        D3DDDI_COLOR_SPACE_RGB_FULL_G10_NONE_P709 = 1,
        D3DDDI_COLOR_SPACE_RGB_STUDIO_G22_NONE_P709 = 2,
        D3DDDI_COLOR_SPACE_RGB_STUDIO_G22_NONE_P2020 = 3,
        D3DDDI_COLOR_SPACE_RESERVED = 4,
        D3DDDI_COLOR_SPACE_YCBCR_FULL_G22_NONE_P709_X601 = 5,
        D3DDDI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P601 = 6,
        D3DDDI_COLOR_SPACE_YCBCR_FULL_G22_LEFT_P601 = 7,
        D3DDDI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P709 = 8,
        D3DDDI_COLOR_SPACE_YCBCR_FULL_G22_LEFT_P709 = 9,
        D3DDDI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P2020 = 10,
        D3DDDI_COLOR_SPACE_YCBCR_FULL_G22_LEFT_P2020 = 11,
        D3DDDI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020 = 12,
        D3DDDI_COLOR_SPACE_YCBCR_STUDIO_G2084_LEFT_P2020 = 13,
        D3DDDI_COLOR_SPACE_RGB_STUDIO_G2084_NONE_P2020 = 14,
        D3DDDI_COLOR_SPACE_YCBCR_STUDIO_G22_TOPLEFT_P2020 = 15,
        D3DDDI_COLOR_SPACE_YCBCR_STUDIO_G2084_TOPLEFT_P2020 = 16,
        D3DDDI_COLOR_SPACE_RGB_FULL_G22_NONE_P2020 = 17,
        D3DDDI_COLOR_SPACE_YCBCR_STUDIO_GHLG_TOPLEFT_P2020 = 18,
        D3DDDI_COLOR_SPACE_YCBCR_FULL_GHLG_TOPLEFT_P2020 = 19,
        D3DDDI_COLOR_SPACE_RGB_STUDIO_G24_NONE_P709 = 20,
        D3DDDI_COLOR_SPACE_RGB_STUDIO_G24_NONE_P2020 = 21,
        D3DDDI_COLOR_SPACE_YCBCR_STUDIO_G24_LEFT_P709 = 22,
        D3DDDI_COLOR_SPACE_YCBCR_STUDIO_G24_LEFT_P2020 = 23,
        D3DDDI_COLOR_SPACE_YCBCR_STUDIO_G24_TOPLEFT_P2020 = 24,
        D3DDDI_COLOR_SPACE_CUSTOM = $FFFFFFFF);

    PD3DDDI_COLOR_SPACE_TYPE = ^TD3DDDI_COLOR_SPACE_TYPE;


    // Note: This enum is intended to specify the final wire signaling
    // colorspace values. Do not mix it with enum values defined in
    // D3DDDI_COLOR_SPACE_TYPE which are used to specify
    // input colorspace for MPOs and other surfaces.

    _D3DDDI_OUTPUT_WIRE_COLOR_SPACE_TYPE = (
        // We are using the same values for these first two enums for
        // backward compatibility to WDDM2.2 drivers which used
        // to get these 2 values from D3DDDI_COLOR_SPACE_TYPE
        D3DDDI_OUTPUT_WIRE_COLOR_SPACE_G22_P709 = 0,
        D3DDDI_OUTPUT_WIRE_COLOR_SPACE_RESERVED = 4,
        D3DDDI_OUTPUT_WIRE_COLOR_SPACE_G2084_P2020 = 12,
        // We are starting the new enum value at 30 just to make sure it
        // is not confused with the existing D3DDDI_COLOR_SPACE_TYPE
        // in the short term
        D3DDDI_OUTPUT_WIRE_COLOR_SPACE_G22_P709_WCG = 30,
        // OS only intend to use the _G22_P2020 value in future,
        // for now graphics drivers should not expect it.
        D3DDDI_OUTPUT_WIRE_COLOR_SPACE_G22_P2020 = 31,
        // OS only intend to use the _G2084_P2020_HDR10PLUS value in future,
        // for now graphics drivers should not expect it.
        D3DDDI_OUTPUT_WIRE_COLOR_SPACE_G2084_P2020_HDR10PLUS = 32,
        // OS only intend to use the _G2084_P2020_DVLL value in future,
        // for now graphics drivers should not expect it.
        D3DDDI_OUTPUT_WIRE_COLOR_SPACE_G2084_P2020_DVLL = 33);

    TD3DDDI_OUTPUT_WIRE_COLOR_SPACE_TYPE = _D3DDDI_OUTPUT_WIRE_COLOR_SPACE_TYPE;
    PD3DDDI_OUTPUT_WIRE_COLOR_SPACE_TYPE = ^TD3DDDI_OUTPUT_WIRE_COLOR_SPACE_TYPE;


    _D3DDDIRECT = record
        left: LONG;
        top: LONG;
        right: LONG;
        bottom: LONG;
    end;
    TD3DDDIRECT = _D3DDDIRECT;
    PD3DDDIRECT = ^TD3DDDIRECT;


    _D3DDDI_KERNELOVERLAYINFO = record
        hAllocation: TD3DKMT_HANDLE; // in: Allocation to be displayed
        DstRect: TD3DDDIRECT; // in: Dest rect
        SrcRect: TD3DDDIRECT; // in: Source rect
        pPrivateDriverData: TD3DKMT_PTR_VOID; // in: Private driver data
        PrivateDriverDataSize: UINT; // in: Size of private driver data
    end;
    TD3DDDI_KERNELOVERLAYINFO = _D3DDDI_KERNELOVERLAYINFO;
    PD3DDDI_KERNELOVERLAYINFO = ^TD3DDDI_KERNELOVERLAYINFO;


    _D3DDDI_GAMMARAMP_TYPE = (
        D3DDDI_GAMMARAMP_UNINITIALIZED = 0,
        D3DDDI_GAMMARAMP_DEFAULT = 1,
        D3DDDI_GAMMARAMP_RGB256x3x16 = 2,
        D3DDDI_GAMMARAMP_DXGI_1 = 3,
        D3DDDI_GAMMARAMP_MATRIX_3x4 = 4,
        D3DDDI_GAMMARAMP_MATRIX_V2 = 5);

    TD3DDDI_GAMMARAMP_TYPE = _D3DDDI_GAMMARAMP_TYPE;
    PD3DDDI_GAMMARAMP_TYPE = ^TD3DDDI_GAMMARAMP_TYPE;


    _D3DDDI_GAMMA_RAMP_RGB256x3x16 = record
        Red: array [0..256 - 1] of USHORT;
        Green: array [0..256 - 1] of USHORT;
        Blue: array [0..256 - 1] of USHORT;
    end;
    TD3DDDI_GAMMA_RAMP_RGB256x3x16 = _D3DDDI_GAMMA_RAMP_RGB256x3x16;
    PD3DDDI_GAMMA_RAMP_RGB256x3x16 = ^TD3DDDI_GAMMA_RAMP_RGB256x3x16;


    TD3DDDI_DXGI_RGB = record
        Red: single;
        Green: single;
        Blue: single;
    end;
    PD3DDDI_DXGI_RGB = ^TD3DDDI_DXGI_RGB;


    _D3DDDI_GAMMA_RAMP_DXGI_1 = record
        Scale: TD3DDDI_DXGI_RGB;
        Offset: TD3DDDI_DXGI_RGB;
        GammaCurve: array [0..1025 - 1] of TD3DDDI_DXGI_RGB;
    end;
    TD3DDDI_GAMMA_RAMP_DXGI_1 = _D3DDDI_GAMMA_RAMP_DXGI_1;
    PD3DDDI_GAMMA_RAMP_DXGI_1 = ^TD3DDDI_GAMMA_RAMP_DXGI_1;


    _D3DKMDT_3X4_COLORSPACE_TRANSFORM = record
        ColorMatrix3x4: array [0..34 - 1] of single;
        ScalarMultiplier: single;
        LookupTable1D: array [0..4096 - 1] of TD3DDDI_DXGI_RGB;
    end;
    TD3DKMDT_3X4_COLORSPACE_TRANSFORM = _D3DKMDT_3X4_COLORSPACE_TRANSFORM;
    PD3DKMDT_3X4_COLORSPACE_TRANSFORM = ^TD3DKMDT_3X4_COLORSPACE_TRANSFORM;

    PD3DDDI_3x4_COLORSPACE_TRANSFORM = ^TD3DKMDT_3X4_COLORSPACE_TRANSFORM;

    _D3DKMDT_COLORSPACE_TRANSFORM_STAGE_CONTROL = (
        D3DKMDT_COLORSPACE_TRANSFORM_STAGE_CONTROL_NO_CHANGE = 0,
        D3DKMDT_COLORSPACE_TRANSFORM_STAGE_CONTROL_ENABLE = 1,
        D3DKMDT_COLORSPACE_TRANSFORM_STAGE_CONTROL_BYPASS = 2);

    TD3DKMDT_COLORSPACE_TRANSFORM_STAGE_CONTROL = _D3DKMDT_COLORSPACE_TRANSFORM_STAGE_CONTROL;
    PD3DKMDT_COLORSPACE_TRANSFORM_STAGE_CONTROL = ^TD3DKMDT_COLORSPACE_TRANSFORM_STAGE_CONTROL;


    _D3DKMDT_COLORSPACE_TRANSFORM_MATRIX_V2 = record
        // stage of 1D Degamma.
        StageControlLookupTable1DDegamma: TD3DKMDT_COLORSPACE_TRANSFORM_STAGE_CONTROL;
        LookupTable1DDegamma: array [0..4096 - 1] of TD3DDDI_DXGI_RGB;
        // stage of 3x3 matrix
        StageControlColorMatrix3x3: TD3DKMDT_COLORSPACE_TRANSFORM_STAGE_CONTROL;
        ColorMatrix3x3: array [0..33 - 1] of single;
        // stage of 1D Regamma.
        StageControlLookupTable1DRegamma: TD3DKMDT_COLORSPACE_TRANSFORM_STAGE_CONTROL;
        LookupTable1DRegamma: array [0..4096 - 1] of TD3DDDI_DXGI_RGB;
    end;
    TD3DKMDT_COLORSPACE_TRANSFORM_MATRIX_V2 = _D3DKMDT_COLORSPACE_TRANSFORM_MATRIX_V2;
    PD3DKMDT_COLORSPACE_TRANSFORM_MATRIX_V2 = ^TD3DKMDT_COLORSPACE_TRANSFORM_MATRIX_V2;


    _D3DDDI_HDR_METADATA_TYPE = (
        D3DDDI_HDR_METADATA_TYPE_NONE = 0,
        D3DDDI_HDR_METADATA_TYPE_HDR10 = 1,
        D3DDDI_HDR_METADATA_TYPE_HDR10PLUS = 2);

    TD3DDDI_HDR_METADATA_TYPE = _D3DDDI_HDR_METADATA_TYPE;
    PD3DDDI_HDR_METADATA_TYPE = ^TD3DDDI_HDR_METADATA_TYPE;


    _D3DDDI_HDR_METADATA_HDR10 = record
        // Color gamut
        RedPrimary: array [0..2 - 1] of uint16;
        GreenPrimary: array [0..2 - 1] of uint16;
        BluePrimary: array [0..2 - 1] of uint16;
        WhitePoint: array [0..2 - 1] of uint16;
        // Luminance
        MaxMasteringLuminance: UINT;
        MinMasteringLuminance: UINT;
        MaxContentLightLevel: uint16;
        MaxFrameAverageLightLevel: uint16;
    end;
    TD3DDDI_HDR_METADATA_HDR10 = _D3DDDI_HDR_METADATA_HDR10;
    PD3DDDI_HDR_METADATA_HDR10 = ^TD3DDDI_HDR_METADATA_HDR10;


    TD3DDDI_HDR_METADATA_HDR10PLUS = record
        Data: array [0..72 - 1] of TBYTE;
    end;
    PD3DDDI_HDR_METADATA_HDR10PLUS = ^TD3DDDI_HDR_METADATA_HDR10PLUS;


    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Purpose: Multi-sampling method descriptor type.

    // Remarks: Driver is free to partition its quality levels for a given multi-sampling method into as many
    //          increments as it likes, with the condition that each incremental step does noticably improve
    //          quality of the presented image.

    _D3DDDI_MULTISAMPLINGMETHOD = record
        // Number of sub-pixels employed in this multi-sampling method (e.g. 2 for 2x and 8 for 8x multi-sampling)
        NumSamples: UINT;
        // Upper bound on the quality range supported for this multi-sampling method. The range starts from 0
        // and goes upto and including the reported maximum quality setting.
        NumQualityLevels: UINT;
    end;
    TD3DDDI_MULTISAMPLINGMETHOD = _D3DDDI_MULTISAMPLINGMETHOD;
    PD3DDDI_MULTISAMPLINGMETHOD = ^TD3DDDI_MULTISAMPLINGMETHOD;


    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Purpose: Video signal scan line ordering descriptor type.

    // Remarks: Scan-line ordering of the video mode, specifies whether each field contains the entire
    //          content of a frame, or only half of it (i.e. even/odd lines interchangeably).
    //          Note that while for standard interlaced modes, what field comes first can be inferred
    //          from the mode, specifying this characteristic explicitly with an enum both frees up the
    //          client from having to maintain mode-based look-up tables and is extensible for future
    //          standard modes not listed in the D3DKMDT_VIDEO_SIGNAL_STANDARD enum.

    _D3DDDI_VIDEO_SIGNAL_SCANLINE_ORDERING = (
        D3DDDI_VSSLO_UNINITIALIZED = 0,
        D3DDDI_VSSLO_PROGRESSIVE = 1,
        D3DDDI_VSSLO_INTERLACED_UPPERFIELDFIRST = 2,
        D3DDDI_VSSLO_INTERLACED_LOWERFIELDFIRST = 3,
        D3DDDI_VSSLO_OTHER = 255);

    TD3DDDI_VIDEO_SIGNAL_SCANLINE_ORDERING = _D3DDDI_VIDEO_SIGNAL_SCANLINE_ORDERING;
    PD3DDDI_VIDEO_SIGNAL_SCANLINE_ORDERING = ^TD3DDDI_VIDEO_SIGNAL_SCANLINE_ORDERING;


    TD3DDDI_FLIPINTERVAL_TYPE = (
        D3DDDI_FLIPINTERVAL_IMMEDIATE = 0,
        D3DDDI_FLIPINTERVAL_ONE = 1,
        D3DDDI_FLIPINTERVAL_TWO = 2,
        D3DDDI_FLIPINTERVAL_THREE = 3,
        D3DDDI_FLIPINTERVAL_FOUR = 4,
        // This value is only valid for the D3D9 runtime PresentCb SyncIntervalOverride field.
        // For this field, IMMEDIATE means the API semantic of sync interval 0, where
        // IMMEDIATE_ALLOW_TEARING is equivalent to the addition of the DXGI ALLOW_TEARING API flags.
        D3DDDI_FLIPINTERVAL_IMMEDIATE_ALLOW_TEARING = 5);

    PD3DDDI_FLIPINTERVAL_TYPE = ^TD3DDDI_FLIPINTERVAL_TYPE;


    _D3DDDI_POOL = (
        D3DDDIPOOL_SYSTEMMEM = 1,
        D3DDDIPOOL_VIDEOMEMORY = 2,
        D3DDDIPOOL_LOCALVIDMEM = 3,
        D3DDDIPOOL_NONLOCALVIDMEM = 4,
        D3DDDIPOOL_STAGINGMEM = 5);

    TD3DDDI_POOL = _D3DDDI_POOL;
    PD3DDDI_POOL = ^TD3DDDI_POOL;


    _D3DDDIMULTISAMPLE_TYPE = (
        D3DDDIMULTISAMPLE_NONE = 0,
        D3DDDIMULTISAMPLE_NONMASKABLE = 1,
        D3DDDIMULTISAMPLE_2_SAMPLES = 2,
        D3DDDIMULTISAMPLE_3_SAMPLES = 3,
        D3DDDIMULTISAMPLE_4_SAMPLES = 4,
        D3DDDIMULTISAMPLE_5_SAMPLES = 5,
        D3DDDIMULTISAMPLE_6_SAMPLES = 6,
        D3DDDIMULTISAMPLE_7_SAMPLES = 7,
        D3DDDIMULTISAMPLE_8_SAMPLES = 8,
        D3DDDIMULTISAMPLE_9_SAMPLES = 9,
        D3DDDIMULTISAMPLE_10_SAMPLES = 10,
        D3DDDIMULTISAMPLE_11_SAMPLES = 11,
        D3DDDIMULTISAMPLE_12_SAMPLES = 12,
        D3DDDIMULTISAMPLE_13_SAMPLES = 13,
        D3DDDIMULTISAMPLE_14_SAMPLES = 14,
        D3DDDIMULTISAMPLE_15_SAMPLES = 15,
        D3DDDIMULTISAMPLE_16_SAMPLES = 16,
        D3DDDIMULTISAMPLE_FORCE_UINT = $7fffffff);

    TD3DDDIMULTISAMPLE_TYPE = _D3DDDIMULTISAMPLE_TYPE;
    PD3DDDIMULTISAMPLE_TYPE = ^TD3DDDIMULTISAMPLE_TYPE;


    _D3DDDI_RESOURCEFLAGS = bitpacked record
        case integer of
            0: (
                RenderTarget: 0..1; // 0x00000001
                ZBuffer: 0..1; // 0x00000002
                Dynamic: 0..1; // 0x00000004
                HintStatic: 0..1; // 0x00000008
                AutogenMipmap: 0..1; // 0x00000010
                DMap: 0..1; // 0x00000020
                WriteOnly: 0..1; // 0x00000040
                NotLockable: 0..1; // 0x00000080
                Points: 0..1; // 0x00000100
                RtPatches: 0..1; // 0x00000200
                NPatches: 0..1; // 0x00000400
                SharedResource: 0..1; // 0x00000800
                DiscardRenderTarget: 0..1; // 0x00001000
                Video: 0..1; // 0x00002000
                CaptureBuffer: 0..1; // 0x00004000
                Primary: 0..1; // 0x00008000
                Texture: 0..1; // 0x00010000
                CubeMap: 0..1; // 0x00020000
                Volume: 0..1; // 0x00040000
                VertexBuffer: 0..1; // 0x00080000
                IndexBuffer: 0..1; // 0x00100000
                DecodeRenderTarget: 0..1; // 0x00200000
                DecodeCompressedBuffer: 0..1; // 0x00400000
                VideoProcessRenderTarget: 0..1; // 0x00800000
                CpuOptimized: 0..1; // 0x01000000
                MightDrawFromLocked: 0..1; // 0x02000000
                Overlay: 0..1; // 0x04000000
                MatchGdiPrimary: 0..1; // 0x08000000
                InterlacedRefresh: 0..1; // 0x10000000
                TextApi: 0..1; // 0x20000000
                RestrictedContent: 0..1; // 0x40000000
                RestrictSharedAccess: 0..1; // 0x80000000

            );
            1: (
                Value: UINT;
            );
    end;
    TD3DDDI_RESOURCEFLAGS = _D3DDDI_RESOURCEFLAGS;
    PD3DDDI_RESOURCEFLAGS = ^TD3DDDI_RESOURCEFLAGS;


    _D3DDDI_SURFACEINFO = record
        Width: UINT; // in: For linear, surface and volume
        Height: UINT; // in: For surface and volume
        Depth: UINT; // in: For volume
        pSysMem: PVOID;
        SysMemPitch: UINT;
        SysMemSlicePitch: UINT;
    end;
    TD3DDDI_SURFACEINFO = _D3DDDI_SURFACEINFO;
    PD3DDDI_SURFACEINFO = ^TD3DDDI_SURFACEINFO;


    _D3DDDI_ROTATION = (
        D3DDDI_ROTATION_IDENTITY = 1, // No rotation.
        D3DDDI_ROTATION_90 = 2, // Rotated 90 degrees.
        D3DDDI_ROTATION_180 = 3, // Rotated 180 degrees.
        D3DDDI_ROTATION_270 = 4// Rotated 270 degrees.
        );

    TD3DDDI_ROTATION = _D3DDDI_ROTATION;
    PD3DDDI_ROTATION = ^TD3DDDI_ROTATION;


    TD3DDDI_SCANLINEORDERING = (
        D3DDDI_SCANLINEORDERING_UNKNOWN = 0,
        D3DDDI_SCANLINEORDERING_PROGRESSIVE = 1,
        D3DDDI_SCANLINEORDERING_INTERLACED = 2);

    PD3DDDI_SCANLINEORDERING = ^TD3DDDI_SCANLINEORDERING;


    _D3DDDIARG_CREATERESOURCE = record
        Format: TD3DDDIFORMAT;
        Pool: TD3DDDI_POOL;
        MultisampleType: TD3DDDIMULTISAMPLE_TYPE;
        MultisampleQuality: UINT;
        pSurfList: PD3DDDI_SURFACEINFO; // in: List of sub resource objects to create
        SurfCount: UINT; // in: Number of sub resource objects
        MipLevels: UINT;
        Fvf: UINT; // in: FVF format for vertex buffers
        VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID; // in: VidPnSourceId on which the primary surface is created
        RefreshRate: TD3DDDI_RATIONAL; // in: RefreshRate that this primary surface is to be used with
        hResource: HANDLE; // in/out: D3D runtime handle/UM driver handle
        Flags: TD3DDDI_RESOURCEFLAGS;
        Rotation: TD3DDDI_ROTATION; // in: The orientation of the resource. (0, 90, 180, 270)
    end;
    TD3DDDIARG_CREATERESOURCE = _D3DDDIARG_CREATERESOURCE;
    PD3DDDIARG_CREATERESOURCE = ^TD3DDDIARG_CREATERESOURCE;


    _D3DDDI_RESOURCEFLAGS2 = bitpacked record
        case integer of
            0: (
                VideoEncoder: 0..1; // 0x00000001
                UserMemory: 0..1; // 0x00000002
                CrossAdapter: 0..1; // 0x00000004
                IsDisplayable: 0..1; // 0x00000008
                Reserved: 0..268435455;

            );
            1: (
                Value: UINT;
            );

    end;
    TD3DDDI_RESOURCEFLAGS2 = _D3DDDI_RESOURCEFLAGS2;
    PD3DDDI_RESOURCEFLAGS2 = ^TD3DDDI_RESOURCEFLAGS2;


    _D3DDDIARG_CREATERESOURCE2 = record
        Format: TD3DDDIFORMAT;
        Pool: TD3DDDI_POOL;
        MultisampleType: TD3DDDIMULTISAMPLE_TYPE;
        MultisampleQuality: UINT;
        pSurfList: PD3DDDI_SURFACEINFO; // in: List of sub resource objects to create
        SurfCount: UINT; // in: Number of sub resource objects
        MipLevels: UINT;
        Fvf: UINT; // in: FVF format for vertex buffers
        VidPnSourceId: TD3DDDI_VIDEO_PRESENT_SOURCE_ID; // in: VidPnSourceId on which the primary surface is created
        RefreshRate: TD3DDDI_RATIONAL; // in: RefreshRate that this primary surface is to be used with
        hResource: HANDLE; // in/out: D3D runtime handle/UM driver handle
        Flags: TD3DDDI_RESOURCEFLAGS;
        Rotation: TD3DDDI_ROTATION; // in: The orientation of the resource. (0, 90, 180, 270)
        Flags2: TD3DDDI_RESOURCEFLAGS2;
    end;
    TD3DDDIARG_CREATERESOURCE2 = _D3DDDIARG_CREATERESOURCE2;
    PD3DDDIARG_CREATERESOURCE2 = ^TD3DDDIARG_CREATERESOURCE2;


    _D3DDDICB_SIGNALFLAGS = bitpacked record
        case integer of
            0: (

                SignalAtSubmission: 0..1;
                EnqueueCpuEvent: 0..1;
                AllowFenceRewind: 0..1;
                Reserved: 0..268435455;
                DXGK_SIGNAL_FLAG_INTERNAL0: 0..1;

            );
            1: (
                Value: UINT;
            );

    end;
    TD3DDDICB_SIGNALFLAGS = _D3DDDICB_SIGNALFLAGS;
    PD3DDDICB_SIGNALFLAGS = ^TD3DDDICB_SIGNALFLAGS;


    _D3DDDI_SYNCHRONIZATIONOBJECT_TYPE = (
        D3DDDI_SYNCHRONIZATION_MUTEX = 1,
        D3DDDI_SEMAPHORE = 2,
        D3DDDI_FENCE = 3,
        D3DDDI_CPU_NOTIFICATION = 4,
        D3DDDI_MONITORED_FENCE = 5,
        D3DDDI_PERIODIC_MONITORED_FENCE = 6,
        D3DDDI_NATIVE_FENCE = 7,
        D3DDDI_SYNCHRONIZATION_TYPE_LIMIT);

    TD3DDDI_SYNCHRONIZATIONOBJECT_TYPE = _D3DDDI_SYNCHRONIZATIONOBJECT_TYPE;
    PD3DDDI_SYNCHRONIZATIONOBJECT_TYPE = ^TD3DDDI_SYNCHRONIZATIONOBJECT_TYPE;


    TDXGK_MIRACAST_CHUNK_ID = bitpacked record
        case integer of
            0: (
                FrameNumber: 0..255;
                PartNumber: 0..16777215;
            );
            1: (
                Value: uint64;);
    end;
    PDXGK_MIRACAST_CHUNK_ID = ^TDXGK_MIRACAST_CHUNK_ID;


    _DXGK_MIRACAST_CHUNK_TYPE = (
        DXGK_MIRACAST_CHUNK_TYPE_UNKNOWN = 0,
        DXGK_MIRACAST_CHUNK_TYPE_COLOR_CONVERT_COMPLETE = 1,
        DXGK_MIRACAST_CHUNK_TYPE_ENCODE_COMPLETE = 2,
        DXGK_MIRACAST_CHUNK_TYPE_FRAME_START = 3,
        DXGK_MIRACAST_CHUNK_TYPE_FRAME_DROPPED = 4,
        DXGK_MIRACAST_CHUNK_TYPE_ENCODE_DRIVER_DEFINED_1 = $80000000,
        DXGK_MIRACAST_CHUNK_TYPE_ENCODE_DRIVER_DEFINED_2 = $80000001);

    TDXGK_MIRACAST_CHUNK_TYPE = _DXGK_MIRACAST_CHUNK_TYPE;
    PDXGK_MIRACAST_CHUNK_TYPE = ^TDXGK_MIRACAST_CHUNK_TYPE;


    TDXGK_MIRACAST_CHUNK_INFO = record
        ChunkType: TDXGK_MIRACAST_CHUNK_TYPE; // Type of chunk info
        ChunkId: TDXGK_MIRACAST_CHUNK_ID; // Identifier for this chunk
        ProcessingTime: UINT; // Time the process took to complete in microsecond
        EncodeRate: UINT; // Encode bitrate driver reported for the chunk, kilobits per second
    end;
    PDXGK_MIRACAST_CHUNK_INFO = ^TDXGK_MIRACAST_CHUNK_INFO;


    TD3DDDI_PAGINGQUEUE_PRIORITY = (
        D3DDDI_PAGINGQUEUE_PRIORITY_BELOW_NORMAL = -1,
        D3DDDI_PAGINGQUEUE_PRIORITY_NORMAL = 0,
        D3DDDI_PAGINGQUEUE_PRIORITY_ABOVE_NORMAL = 1);

    PD3DDDI_PAGINGQUEUE_PRIORITY = ^TD3DDDI_PAGINGQUEUE_PRIORITY;


    TD3DDDI_MAKERESIDENT_FLAGS = bitpacked record
        case integer of
            0: (
                CantTrimFurther: 0..1; // When set, MakeResidentCb will succeed even if the request puts the application over the current budget.
                MustSucceed: 0..1; // When set, instructs MakeResidentCb to put the device in error if the resource cannot be made resident.
                Reserved: 0..1073741823;

            );
            1: (
                Value: UINT;
            );
    end;
    PD3DDDI_MAKERESIDENT_FLAGS = ^TD3DDDI_MAKERESIDENT_FLAGS;


    TD3DDDI_MAKERESIDENT = record
        hPagingQueue: TD3DKMT_HANDLE; // [in] Handle to the paging queue used to synchronize paging operations for this call.
        NumAllocations: UINT; // [in/out] On input, the number of allocation handles om the AllocationList array. On output,
        {_Field_size_NumAllocations} AllocationList: TD3DKMT_HANDLE; // [in] An array of NumAllocations allocation handles
        PriorityList: TD3DKMT_PT_UINTR; // [in] Residency priority array for each of the allocations in the resource or allocation list
        Flags: TD3DDDI_MAKERESIDENT_FLAGS; // [in] Residency flags
        PagingFenceValue: uint64; // [out] Paging fence value to synchronize on before submitting the command
        //      synchronization object associated with hPagingQueue.
        NumBytesToTrim: uint64; // [out] When MakeResident fails due to being over budget, this value
        //      indicates how much to trim in order for the call to succeed on a retry.
    end;
    PD3DDDI_MAKERESIDENT = ^TD3DDDI_MAKERESIDENT;


    TD3DDDI_EVICT_FLAGS = bitpacked record
        case integer of
            0: (
                EvictOnlyIfNecessary: 0..1;
                NotWrittenTo: 0..1;
                Reserved: 0..1073741823;

            );
            1: (
                Value: UINT;
            );
    end;
    PD3DDDI_EVICT_FLAGS = ^TD3DDDI_EVICT_FLAGS;


    TD3DDDI_TRIMRESIDENCYSET_FLAGS = bitpacked record
        case integer of
            0: (
                PeriodicTrim: 0..1; // When PeriodicTrim flag is set, the driver is required to performed the following operations:
                // by comparing the allocation last referenced fence with the last periodic trim context fence
                // b) Refresh the last periodic trim context fence with the last completed context fence.
                RestartPeriodicTrim: 0..1; // May not be set together with PeriodicTrim flag.
                // Reset the last periodic trim context fence to the last completed context fence.
                TrimToBudget: 0..1; // Indicates that the application usage is over the memory budget,
                // and NumBytesToTrim bytes should be trimmed to fit in the new memory budget.
                Reserved: 0..536870911;


            );
            1: (
                Value: UINT;
            );
    end;
    PD3DDDI_TRIMRESIDENCYSET_FLAGS = ^TD3DDDI_TRIMRESIDENCYSET_FLAGS;


    _D3DDDIGPUVIRTUALADDRESS_PROTECTION_TYPE = bitpacked record
        case integer of
            0: (
                Write: 0..1;
                Execute: 0..1;
                Zero: 0..1;
                NoAccess: 0..1;
                SystemUseOnly: 0..1; // Should not be set by the UMD
                Reserved: 0..134217727;
            );
            1: (
                Value: uint64;
            );
    end;
    TD3DDDIGPUVIRTUALADDRESS_PROTECTION_TYPE = _D3DDDIGPUVIRTUALADDRESS_PROTECTION_TYPE;
    PD3DDDIGPUVIRTUALADDRESS_PROTECTION_TYPE = ^TD3DDDIGPUVIRTUALADDRESS_PROTECTION_TYPE;


    _D3DDDI_UPDATEGPUVIRTUALADDRESS_OPERATION_TYPE = (
        D3DDDI_UPDATEGPUVIRTUALADDRESS_MAP = 0,
        D3DDDI_UPDATEGPUVIRTUALADDRESS_UNMAP = 1,
        D3DDDI_UPDATEGPUVIRTUALADDRESS_COPY = 2,
        D3DDDI_UPDATEGPUVIRTUALADDRESS_MAP_PROTECT = 3);

    TD3DDDI_UPDATEGPUVIRTUALADDRESS_OPERATION_TYPE = _D3DDDI_UPDATEGPUVIRTUALADDRESS_OPERATION_TYPE;
    PD3DDDI_UPDATEGPUVIRTUALADDRESS_OPERATION_TYPE = ^TD3DDDI_UPDATEGPUVIRTUALADDRESS_OPERATION_TYPE;


    _D3DDDI_UPDATEGPUVIRTUALADDRESS_OPERATION = record
        OperationType: TD3DDDI_UPDATEGPUVIRTUALADDRESS_OPERATION_TYPE;
        case integer of
            0: (
                TMap: record
                    BaseAddress: TD3DGPU_VIRTUAL_ADDRESS;
                    SizeInBytes: TD3DGPU_SIZE_T;
                    hAllocation: TD3DKMT_HANDLE;
                    AllocationOffsetInBytes: TD3DGPU_SIZE_T;
                    AllocationSizeInBytes: TD3DGPU_SIZE_T;
                    end;
            );
            1: (
                TMapProtect: record
                    BaseAddress: TD3DGPU_VIRTUAL_ADDRESS;
                    SizeInBytes: TD3DGPU_SIZE_T;
                    hAllocation: TD3DKMT_HANDLE;
                    AllocationOffsetInBytes: TD3DGPU_SIZE_T;
                    AllocationSizeInBytes: TD3DGPU_SIZE_T;
                    Protection: TD3DDDIGPUVIRTUALADDRESS_PROTECTION_TYPE;
                    DriverProtection: uint64;
                    end;
            );
            2: (
                TUnmap: record
                    BaseAddress: TD3DGPU_VIRTUAL_ADDRESS;
                    SizeInBytes: TD3DGPU_SIZE_T;
                    Protection: TD3DDDIGPUVIRTUALADDRESS_PROTECTION_TYPE;
                    end;
                // Used for UNMAP_NOACCESS as well = T;
            );
            3: (
                TCopy: record
                    SourceAddress: TD3DGPU_VIRTUAL_ADDRESS;
                    SizeInBytes: TD3DGPU_SIZE_T;
                    DestAddress: TD3DGPU_VIRTUAL_ADDRESS;
                    end;
            );
    end;
    TD3DDDI_UPDATEGPUVIRTUALADDRESS_OPERATION = _D3DDDI_UPDATEGPUVIRTUALADDRESS_OPERATION;
    PD3DDDI_UPDATEGPUVIRTUALADDRESS_OPERATION = ^TD3DDDI_UPDATEGPUVIRTUALADDRESS_OPERATION;


    _D3DDDIGPUVIRTUALADDRESS_RESERVATION_TYPE = (
        D3DDDIGPUVIRTUALADDRESS_RESERVE_NO_ACCESS = 0,
        D3DDDIGPUVIRTUALADDRESS_RESERVE_ZERO = 1,
        D3DDDIGPUVIRTUALADDRESS_RESERVE_NO_COMMIT = 2// Reserved for system use
        );

    TD3DDDIGPUVIRTUALADDRESS_RESERVATION_TYPE = _D3DDDIGPUVIRTUALADDRESS_RESERVATION_TYPE;
    PD3DDDIGPUVIRTUALADDRESS_RESERVATION_TYPE = ^TD3DDDIGPUVIRTUALADDRESS_RESERVATION_TYPE;


    TD3DDDI_MAPGPUVIRTUALADDRESS = record
        hPagingQueue: TD3DKMT_HANDLE; // in: Paging queue to synchronize the operation on.
        BaseAddress: TD3DGPU_VIRTUAL_ADDRESS; // in_opt: Base virtual address to map
        MinimumAddress: TD3DGPU_VIRTUAL_ADDRESS; // in_opt: Minimum virtual address
        MaximumAddress: TD3DGPU_VIRTUAL_ADDRESS; // in_opt: Maximum virtual address
        hAllocation: TD3DKMT_HANDLE; // in: Allocation handle to map
        OffsetInPages: TD3DGPU_SIZE_T; // in: Offset in 4 KB pages from the start of the allocation
        SizeInPages: TD3DGPU_SIZE_T; // in: Size in 4 KB pages to map
        Protection: TD3DDDIGPUVIRTUALADDRESS_PROTECTION_TYPE; // in: Virtual address protection
        DriverProtection: uint64; // in: Driver specific protection
        Reserved0: UINT; // in:
        Reserved1: uint64; // in:
        VirtualAddress: TD3DGPU_VIRTUAL_ADDRESS; // out: Virtual address
        PagingFenceValue: uint64; // out: Paging fence Id for synchronization
    end;
    PD3DDDI_MAPGPUVIRTUALADDRESS = ^TD3DDDI_MAPGPUVIRTUALADDRESS;


    TD3DDDI_RESERVEGPUVIRTUALADDRESS = record
        case integer of
            0: (
                hPagingQueue: TD3DKMT_HANDLE; // in: Paging queue to synchronize the operation on.
                BaseAddress: TD3DGPU_VIRTUAL_ADDRESS; // in_opt: Base virtual address to map
                MinimumAddress: TD3DGPU_VIRTUAL_ADDRESS; // in_opt: Minimum virtual address
                MaximumAddress: TD3DGPU_VIRTUAL_ADDRESS; // in_opt: Maximum virtual address
                Size: TD3DGPU_SIZE_T; // in: Size to reserve in bytes

                case integer of
                    0: (
                    ReservationType: TD3DDDIGPUVIRTUALADDRESS_RESERVATION_TYPE; // in: Reservation type
                    case integer of
                        0: (
                        DriverProtection: uint64; // in: Driver specific protection
                        VirtualAddress: TD3DGPU_VIRTUAL_ADDRESS; // out: Virtual address
                        case integer of
                            0: (
                            PagingFenceValue: uint64; // out: Paging fence Id for synchronization
                            );
                            1: (
                            Reserved2: uint64; // M2
                            );
                        );
                        1: (
                        Reserved1: uint64; // M2
                        );


                    );
                    1: (
                    Reserved0: UINT; // M2
                    );


            );
            1: (
                hAdapter: TD3DKMT_HANDLE; // in: DXG adapter handle. (M2)
            );


    end;
    PD3DDDI_RESERVEGPUVIRTUALADDRESS = ^TD3DDDI_RESERVEGPUVIRTUALADDRESS;


    _D3DDDI_GETRESOURCEPRESENTPRIVATEDRIVERDATA = record
        hResource: TD3DKMT_HANDLE;
        PrivateDriverDataSize: UINT;
        pPrivateDriverData: pointer; // ToDo TD3DKMT_PTR_PVOID;
    end;
    TD3DDDI_GETRESOURCEPRESENTPRIVATEDRIVERDATA = _D3DDDI_GETRESOURCEPRESENTPRIVATEDRIVERDATA;
    PD3DDDI_GETRESOURCEPRESENTPRIVATEDRIVERDATA = ^TD3DDDI_GETRESOURCEPRESENTPRIVATEDRIVERDATA;


    TD3DDDI_DESTROYPAGINGQUEUE = record
        hPagingQueue: TD3DKMT_HANDLE; // in: handle to the paging queue to destroy
    end;
    PD3DDDI_DESTROYPAGINGQUEUE = ^TD3DDDI_DESTROYPAGINGQUEUE;


    TD3DDDI_UPDATEALLOCPROPERTY_FLAGS = bitpacked record
        case integer of
            0: (
                AccessedPhysically: 0..1; // The new value for AccessedPhysically on an allocation
                Unmoveable: 0..1; // Indicates an allocation cannot be moved while pinned in a memory segment
                Reserved: 0..1073741823;

            );
            1: (
                Value: UINT;
            );
    end;
    PD3DDDI_UPDATEALLOCPROPERTY_FLAGS = ^TD3DDDI_UPDATEALLOCPROPERTY_FLAGS;


    TD3DDDI_UPDATEALLOCPROPERTY = bitpacked record
        hPagingQueue: TD3DKMT_HANDLE; // [in] Handle to the paging queue used to synchronize paging operations for this call.
        hAllocation: TD3DKMT_HANDLE; // [in] Handle to the allocation to be updated.
        SupportedSegmentSet: UINT; // [in] New supported segment set, ignored if the same.
        PreferredSegment: TD3DDDI_SEGMENTPREFERENCE; // [in] New preferred segment set, ignored if the same.
        Flags: TD3DDDI_UPDATEALLOCPROPERTY_FLAGS; // [in] Flags to set on the allocation, ignored if the same.
        PagingFenceValue: uint64; // [out] Paging fence value to synchronize on before using the above allocation.
            //       object associated with hPagingQueue.
        case integer of
            0: (
                SetAccessedPhysically: 0..1; // [in] When set to 1, will set AccessedPhysically to new value
                SetSupportedSegmentSet: 0..1; // [in] When set to 1, will set SupportedSegmentSet to new value
                SetPreferredSegment: 0..1; // [in] When set to 1, will set PreferredSegment to new value
                SetUnmoveable: 0..1; // [in] When set to 1, will set Unmoveable to new value
                Reserved: 0..268435455;

            );
            1: (
                PropertyMaskValue: UINT;
            );

    end;
    PD3DDDI_UPDATEALLOCPROPERTY = ^TD3DDDI_UPDATEALLOCPROPERTY;


    TD3DDDI_OFFER_FLAGS = bitpacked record
        case integer of
            0: (
                AllowDecommit: 0..1;
                Reserved: 0.. uint(-2147483649);
            );
            1: (
                Value: UINT;
            );
    end;
    PD3DDDI_OFFER_FLAGS = ^TD3DDDI_OFFER_FLAGS;


    _D3DDDI_RECLAIM_RESULT = (
        D3DDDI_RECLAIM_RESULT_OK = 0,
        D3DDDI_RECLAIM_RESULT_DISCARDED = 1,
        D3DDDI_RECLAIM_RESULT_NOT_COMMITTED = 2);

    TD3DDDI_RECLAIM_RESULT = _D3DDDI_RECLAIM_RESULT;
    PD3DDDI_RECLAIM_RESULT = ^TD3DDDI_RECLAIM_RESULT;


    _D3DDDI_SYNCHRONIZATIONOBJECTINFO = record
        ObjectType: TD3DDDI_SYNCHRONIZATIONOBJECT_TYPE; // in: Type of synchronization object to create.
        case integer of
            0: (
                TSynchronizationMutex: record
                    InitialState: boolean; // in: Initial state of a synchronization mutex.
                    end;

            );
            1: (
                TSemaphore: record
                    MaxCount: UINT; // in: Max count of the semaphore.
                    InitialCount: UINT; // in: Initial count of the semaphore.
                    end;
            );
            2: (
                TReserved: record
                    Reserved: array [0..16 - 1] of UINT; // Reserved for future use.
                    end;
            );
    end;
    TD3DDDI_SYNCHRONIZATIONOBJECTINFO = _D3DDDI_SYNCHRONIZATIONOBJECTINFO;
    PD3DDDI_SYNCHRONIZATIONOBJECTINFO = ^TD3DDDI_SYNCHRONIZATIONOBJECTINFO;


    _D3DDDI_SYNCHRONIZATIONOBJECT_FLAGS = bitpacked record
        case integer of
            0: (
                Shared: 0..1;
                NtSecuritySharing: 0..1;
                CrossAdapter: 0..1;
                // When set, the sync object is signaled as soon as the contents of command buffers preceding it
                // is entirely copied to the GPU pipeline, but not necessarily completed execution.
                // This flag can be set in order to start reusing command buffers as soon as possible.
                TopOfPipeline: 0..1;
                // When set, the device this sync object is created or opened on
                // can only submit wait commands for it.
                NoSignal: 0..1;
                // When set, the device this sync object is created or opened on
                // can only submit signal commands for it. This flag cannot be set
                // simultaneously with NoSignal.
                NoWait: 0..1;
                // When set, instructs the GPU scheduler to bypass signaling of the monitored fence
                // to the maximum value when the device is affected by the GPU reset.
                NoSignalMaxValueOnTdr: 0..1;
                // When set, the fence will not be mapped into the GPU virtual address space.
                // Only packet-based signal/wait operations are supported
                // When this is set, the fence is always stored as a 64-bit value (regardless of adapter caps)
                NoGPUAccess: 0..1;
                // When set, the fence can be signaled by KMD.
                // The flag can be used only with D3DDDI_CPU_NOTIFICATION objects.
                SignalByKmd: 0..1;
                Unused: 0..1;
                // When set, the waiters for a shared sync object on CPU will be unblocked
                // only when the shared sync object is finally destroyed. By default, CPU
                // waiters are unblocked when a local sync object is destroyed, but the main
                // shared sync object is still opened by another local sync object.
                UnwaitCpuWaitersOnlyOnDestroy: 0..1;
                Reserved: 0..1048575;
                D3DDDI_SYNCHRONIZATIONOBJECT_FLAGS_RESERVED0: 0..1;
            );
            1: (
                Value: UINT;
            );
    end;
    TD3DDDI_SYNCHRONIZATIONOBJECT_FLAGS = _D3DDDI_SYNCHRONIZATIONOBJECT_FLAGS;
    PD3DDDI_SYNCHRONIZATIONOBJECT_FLAGS = ^TD3DDDI_SYNCHRONIZATIONOBJECT_FLAGS;


    _D3DDDI_SYNCHRONIZATIONOBJECTINFO2 = record
        ObjectType: TD3DDDI_SYNCHRONIZATIONOBJECT_TYPE; // in: Type of synchronization object to create.
        Flags: TD3DDDI_SYNCHRONIZATIONOBJECT_FLAGS; // in: flags.
        case integer of
            0: (
                TSynchronizationMutex: record
                    InitialState: boolean; // in: Initial state of a synchronization mutex.
                    end;
            );
            1: (
                TSemaphore: record
                    MaxCount: UINT; // in: Max count of the semaphore.
                    InitialCount: UINT; // in: Initial count of the semaphore.
                    end;
            );
            2: (
                TFence: record
                    FenceValue: uint64; // in: inital fence value.
                    end;
            );
            3: (
                TCPUNotification: record
                    Event: HANDLE; // in: Handle to the event
                    end;
            );
            4: (
                TMonitoredFence: record
                    InitialFenceValue: uint64; // in: inital fence value.
                    FenceValueCPUVirtualAddress: TD3DKMT_PTR_VOID; // out: Read-only mapping of the fence value for the CPU
                    FenceValueGPUVirtualAddress: TD3DGPU_VIRTUAL_ADDRESS; // out: Read/write mapping of the fence value for the GPU
                    EngineAffinity: UINT; // in: Defines physical adapters where the GPU VA will be mapped
                    Padding: UINT;
                    end;
            );
            5: (
                TPeriodicMonitoredFence: record
                    hAdapter: TD3DKMT_HANDLE; // in: A handle to the adapter associated with VidPnTargetId
                    VidPnTargetId: TD3DDDI_VIDEO_PRESENT_TARGET_ID; // in: The output that the compositor wishes to receive notifications for
                    Time: uint64; // in: Represents an offset before the VSync.
                    FenceValueCPUVirtualAddress: TD3DKMT_PTR_VOID; // out: Read-only mapping of the fence value for the CPU
                    FenceValueGPUVirtualAddress: TD3DGPU_VIRTUAL_ADDRESS; // out: Read-only mapping of the fence value for the GPU
                    EngineAffinity: UINT; // in: Defines physical adapters where the GPU VA will be mapped
                    Padding: UINT;
                    end;
            );
            6: (
                TReserved: record
                    Reserved: array [0..8 - 1] of uint64; // Reserved for future use.
                    end;
                SharedHandle: TD3DKMT_HANDLE; // out: global shared handle (when requested to be shared)     s
            );

    end;
    TD3DDDI_SYNCHRONIZATIONOBJECTINFO2 = _D3DDDI_SYNCHRONIZATIONOBJECTINFO2;
    PD3DDDI_SYNCHRONIZATIONOBJECTINFO2 = ^TD3DDDI_SYNCHRONIZATIONOBJECTINFO2;


    _D3DDDI_NATIVEFENCE_TYPE = (
        D3DDDI_NATIVEFENCE_TYPE_DEFAULT = 0, // Full CPU and GPU interoperability.
        D3DDDI_NATIVEFENCE_TYPE_INTRA_GPU = 1// Special fence type for engine-engine synchronization, which
        // does not support any CPU access or CPU wait/signal operations
        );

    TD3DDDI_NATIVEFENCE_TYPE = _D3DDDI_NATIVEFENCE_TYPE;
    PD3DDDI_NATIVEFENCE_TYPE = ^TD3DDDI_NATIVEFENCE_TYPE;


    _D3DDDI_NATIVEFENCEMAPPING = record
        CurrentValueCpuVa: TD3DKMT_PTR_VOID; // Read-only mapping of the current value for the CPU
        CurrentValueGpuVa: TD3DGPU_VIRTUAL_ADDRESS; // Read/write mapping of the current value for the GPU in the current process address space
        xMonitoredValueGpuVa: TD3DGPU_VIRTUAL_ADDRESS; // Read/write mapping of the monitored value for the GPU in the current process address space
        Reserved: array [0..32 - 1] of pointer; // ToDo TD3DKMT_ALIGN64_BYTE;
    end;
    TD3DDDI_NATIVEFENCEMAPPING = _D3DDDI_NATIVEFENCEMAPPING;
    PD3DDDI_NATIVEFENCEMAPPING = ^TD3DDDI_NATIVEFENCEMAPPING;


    _D3DDDI_NATIVEFENCEINFO = record
        InitialFenceValue: uint64; // in: initial fence value.
        EngineAffinity: UINT; // in: Defines physical adapters where the GPU VA is mapped
        FenceType: TD3DDDI_NATIVEFENCE_TYPE; // in: Type of the fence
        Flags: TD3DDDI_SYNCHRONIZATIONOBJECT_FLAGS; // in: Flags.
        NativeFenceMapping: TD3DDDI_NATIVEFENCEMAPPING; // out: process mapping information for the native fence
        Reserved: array [0..28 - 1] of pointer; // TD3DKMT_ALIGN64_BYTE;
    end;
    TD3DDDI_NATIVEFENCEINFO = _D3DDDI_NATIVEFENCEINFO;
    PD3DDDI_NATIVEFENCEINFO = ^TD3DDDI_NATIVEFENCEINFO;


    _DXGK_NATIVE_FENCE_LOG_TYPE = (
        DXGK_NATIVE_FENCE_LOG_TYPE_WAITS = 1,
        DXGK_NATIVE_FENCE_LOG_TYPE_SIGNALS = 2);

    TDXGK_NATIVE_FENCE_LOG_TYPE = _DXGK_NATIVE_FENCE_LOG_TYPE;
    PDXGK_NATIVE_FENCE_LOG_TYPE = ^TDXGK_NATIVE_FENCE_LOG_TYPE;


    _DXGK_NATIVE_FENCE_LOG_HEADER = record
        case integer of
            0: (
                FirstFreeEntryIndex: uint32; // same as LowPart of AtomicWraparoundAndEntryIndex
                WraparoundCount: uint32; // same as HighPart of AtomicWraparoundAndEntryIndex

                FenceType: TDXGK_NATIVE_FENCE_LOG_TYPE;
                NumberOfEntries: uint64;
                Reserved: array [0..2 - 1] of uint64;

            );
            1: (
                AtomicWraparoundAndEntryIndex: ULARGE_INTEGER;
            );


    end;
    TDXGK_NATIVE_FENCE_LOG_HEADER = _DXGK_NATIVE_FENCE_LOG_HEADER;
    PDXGK_NATIVE_FENCE_LOG_HEADER = ^TDXGK_NATIVE_FENCE_LOG_HEADER;


    _DXGK_NATIVE_FENCE_LOG_OPERATION = (
        DXGK_NATIVE_FENCE_LOG_OPERATION_SIGNAL_EXECUTED = 0,
        DXGK_NATIVE_FENCE_LOG_OPERATION_WAIT_UNBLOCKED = 1);

    TDXGK_NATIVE_FENCE_LOG_OPERATION = _DXGK_NATIVE_FENCE_LOG_OPERATION;
    PDXGK_NATIVE_FENCE_LOG_OPERATION = ^TDXGK_NATIVE_FENCE_LOG_OPERATION;


    _DXGK_NATIVE_FENCE_LOG_ENTRY = record
        FenceValue: uint64; // UMD payload: Newly signaled/unblocked fence value
        hNativeFence: TD3DKMT_HANDLE; // UMD payload: user mode D3DKMT_HANDLE of native fence to which this operation belongs
        OperationType: UINT; // UMD payload: DXGK_FENCE_LOG_OPERATION type
        Reserved0: uint64; // Reserved for alignment
        FenceObservedGpuTimestamp: uint64; // GPU Payload: OPERATION_WAIT_UNBLOCKED only: GPU Time at which an unresolved wait command was seen by engine and stalled the HWQueue
        Reserved1: uint64; // Reserved for alignment
        FenceEndGpuTimestamp: uint64; // GPU Payload: GPU Time at which the fence operation completed on GPU
    end;
    TDXGK_NATIVE_FENCE_LOG_ENTRY = _DXGK_NATIVE_FENCE_LOG_ENTRY;
    PDXGK_NATIVE_FENCE_LOG_ENTRY = ^TDXGK_NATIVE_FENCE_LOG_ENTRY;


    _DXGK_NATIVE_FENCE_LOG_BUFFER = record
        Header: TDXGK_NATIVE_FENCE_LOG_HEADER;
        {_Field_size_(Header.NumberOfEntries)} Entries: array [0..1 - 1] of TDXGK_NATIVE_FENCE_LOG_ENTRY;
    end;
    TDXGK_NATIVE_FENCE_LOG_BUFFER = _DXGK_NATIVE_FENCE_LOG_BUFFER;
    PDXGK_NATIVE_FENCE_LOG_BUFFER = ^TDXGK_NATIVE_FENCE_LOG_BUFFER;


    _D3DDDI_DOORBELLSTATUS = (
        D3DDDI_DOORBELLSTATUS_CONNECTED = 0,
        D3DDDI_DOORBELLSTATUS_CONNECTED_NOTIFY_KMD = 1,
        D3DDDI_DOORBELLSTATUS_DISCONNECTED_RETRY = 2,
        D3DDDI_DOORBELLSTATUS_DISCONNECTED_ABORT = 3);

    TD3DDDI_DOORBELLSTATUS = _D3DDDI_DOORBELLSTATUS;
    PD3DDDI_DOORBELLSTATUS = ^TD3DDDI_DOORBELLSTATUS;


    _D3DDDI_WAITFORSYNCHRONIZATIONOBJECTFROMCPU_FLAGS = record
        case integer of
            0: (
                WaitAny: 0..1; // when waiting for multiple objects, signal the wait event if any
                Reserved: 0..uint(-2147483649);

            );
            1: (
                Value: UINT;
            );
    end;
    TD3DDDI_WAITFORSYNCHRONIZATIONOBJECTFROMCPU_FLAGS = _D3DDDI_WAITFORSYNCHRONIZATIONOBJECTFROMCPU_FLAGS;
    PD3DDDI_WAITFORSYNCHRONIZATIONOBJECTFROMCPU_FLAGS = ^TD3DDDI_WAITFORSYNCHRONIZATIONOBJECTFROMCPU_FLAGS;


    _D3DDDI_QUERYREGISTRY_FLAGS = bitpacked record
        case integer of
            0: (
                TranslatePath: 0..1;
                MutableValue: 0..1;
                Reserved: 0..1073741823;
            );
            1: (
                Value: UINT;
            );
    end;
    TD3DDDI_QUERYREGISTRY_FLAGS = _D3DDDI_QUERYREGISTRY_FLAGS;
    PD3DDDI_QUERYREGISTRY_FLAGS = ^TD3DDDI_QUERYREGISTRY_FLAGS;


    _D3DDDI_QUERYREGISTRY_TYPE = (
        D3DDDI_QUERYREGISTRY_SERVICEKEY = 0,
        D3DDDI_QUERYREGISTRY_ADAPTERKEY = 1,
        D3DDDI_QUERYREGISTRY_DRIVERSTOREPATH = 2,
        D3DDDI_QUERYREGISTRY_DRIVERIMAGEPATH = 3,
        D3DDDI_QUERYREGISTRY_MAX);

    TD3DDDI_QUERYREGISTRY_TYPE = _D3DDDI_QUERYREGISTRY_TYPE;
    PD3DDDI_QUERYREGISTRY_TYPE = ^TD3DDDI_QUERYREGISTRY_TYPE;


    _D3DDDI_QUERYREGISTRY_STATUS = (
        D3DDDI_QUERYREGISTRY_STATUS_SUCCESS = 0,
        D3DDDI_QUERYREGISTRY_STATUS_BUFFER_OVERFLOW = 1,
        D3DDDI_QUERYREGISTRY_STATUS_FAIL = 2,
        D3DDDI_QUERYREGISTRY_STATUS_MAX);

    TD3DDDI_QUERYREGISTRY_STATUS = _D3DDDI_QUERYREGISTRY_STATUS;
    PD3DDDI_QUERYREGISTRY_STATUS = ^TD3DDDI_QUERYREGISTRY_STATUS;


    // Output data value follows this structure.
    // PrivateDriverSize must be sizeof(D3DDDI_QUERYREGISTRY_INFO) + (size of the the key value in bytes)

    _D3DDDI_QUERYREGISTRY_INFO = record
        QueryType: TD3DDDI_QUERYREGISTRY_TYPE; // In
        QueryFlags: TD3DDDI_QUERYREGISTRY_FLAGS; // In
        ValueName: array [0..MAX_PATH - 1] of WCHAR; // In
        ValueType: ULONG; // In
        PhysicalAdapterIndex: ULONG; // In
        OutputValueSize: ULONG; // Out. Number of bytes written to the output value or required in case of D3DDDI_QUERYREGISTRY_STATUS_BUFFER_OVERFLOW.
        Status: TD3DDDI_QUERYREGISTRY_STATUS; // Out
        case integer of
            0: (
                OutputDword: DWORD; // Out
            );
            1: (
                OutputQword: uint64; // Out
            );
            2: (
                OutputString: PWCHAR; // Out. Dynamic array
            );
            3: (
                OutputBinary: pbyte; // Out. Dynamic array
            );

    end;
    TD3DDDI_QUERYREGISTRY_INFO = _D3DDDI_QUERYREGISTRY_INFO;
    PD3DDDI_QUERYREGISTRY_INFO = ^TD3DDDI_QUERYREGISTRY_INFO;


    _DXGK_FEATURE_CATEGORY = (
        DXGK_FEATURE_CATEGORY_DRIVER = 0,
        DXGK_FEATURE_CATEGORY_OS = 1,
        DXGK_FEATURE_CATEGORY_BUGFIX = 2,
        DXGK_FEATURE_CATEGORY_TEST = 3,
        DXGK_FEATURE_CATEGORY_RESERVED4 = 4,
        DXGK_FEATURE_CATEGORY_RESERVED5 = 5,
        DXGK_FEATURE_CATEGORY_RESERVED6 = 6,
        DXGK_FEATURE_CATEGORY_RESERVED7 = 7,
        DXGK_FEATURE_CATEGORY_RESERVED8 = 8,
        DXGK_FEATURE_CATEGORY_RESERVED9 = 9,
        DXGK_FEATURE_CATEGORY_RESERVED10 = 10,
        DXGK_FEATURE_CATEGORY_RESERVED11 = 11,
        DXGK_FEATURE_CATEGORY_RESERVED12 = 12,
        DXGK_FEATURE_CATEGORY_RESERVED13 = 13,
        DXGK_FEATURE_CATEGORY_RESERVED14 = 14,
        DXGK_FEATURE_CATEGORY_RESERVED15 = 15,
        DXGK_FEATURE_CATEGORY_MAX = 16);

    TDXGK_FEATURE_CATEGORY = _DXGK_FEATURE_CATEGORY;
    PDXGK_FEATURE_CATEGORY = ^TDXGK_FEATURE_CATEGORY;


    _DXGK_DRIVER_FEATURE = (
        DXGK_DRIVER_FEATURE_HWSCH = 0, // Hardware accelerated GPU scheduling
        DXGK_DRIVER_FEATURE_HWFLIPQUEUE = 1, // Hardware flip queue
        DXGK_DRIVER_FEATURE_LDA_GPUPV = 2, // Support for LDA in GPU-PV
        DXGK_DRIVER_FEATURE_KMD_SIGNAL_CPU_EVENT = 3, // Support for signaling CPU event by KMD
        DXGK_DRIVER_FEATURE_USER_MODE_SUBMISSION = 4,
        DXGK_DRIVER_FEATURE_SHARE_BACKING_STORE_WITH_KMD = 5,
        DXGK_DRIVER_FEATURE_RESERVED_1 = 6,
        DXGK_DRIVER_FEATURE_RESERVED_2 = 7,
        DXGK_DRIVER_FEATURE_RESERVED_3 = 8,
        DXGK_DRIVER_FEATURE_RESERVED_4 = 9,
        DXGK_DRIVER_FEATURE_RESERVED_5 = 10,
        DXGK_DRIVER_FEATURE_RESERVED_6 = 11,
        DXGK_DRIVER_FEATURE_RESERVED_7 = 12,
        DXGK_DRIVER_FEATURE_RESERVED_8 = 13,
        DXGK_DRIVER_FEATURE_RESERVED_9 = 14,
        DXGK_DRIVER_FEATURE_RESERVED_10 = 15,
        DXGK_DRIVER_FEATURE_RESERVED_11 = 16,
        DXGK_DRIVER_FEATURE_RESERVED_12 = 17,
        DXGK_DRIVER_FEATURE_RESERVED_13 = 18,
        DXGK_DRIVER_FEATURE_RESERVED_14 = 19,
        DXGK_DRIVER_FEATURE_RESERVED_15 = 20,
        DXGK_DRIVER_FEATURE_RESERVED_16 = 21,
        DXGK_DRIVER_FEATURE_RESERVED_17 = 22,
        DXGK_DRIVER_FEATURE_RESERVED_18 = 23,
        DXGK_DRIVER_FEATURE_RESERVED_19 = 24,
        DXGK_DRIVER_FEATURE_RESERVED_20 = 25,
        DXGK_DRIVER_FEATURE_RESERVED_21 = 26,
        DXGK_DRIVER_FEATURE_RESERVED_22 = 27,
        DXGK_DRIVER_FEATURE_RESERVED_23 = 28,
        DXGK_DRIVER_FEATURE_RESERVED_24 = 29,
        DXGK_DRIVER_FEATURE_RESERVED_25 = 30,
        DXGK_DRIVER_FEATURE_SAMPLE = 31,
        DXGK_DRIVER_FEATURE_PAGE_BASED_MEMORY_MANAGER = 32,
        DXGK_DRIVER_FEATURE_KERNEL_MODE_TESTING = 33,
        DXGK_DRIVER_FEATURE_64K_PT_DEMOTION_FIX = 34,
        DXGK_DRIVER_FEATURE_GPUPV_PRESENT_HWQUEUE = 35,
        DXGK_DRIVER_FEATURE_GPUVAIOMMU = 36,
        DXGK_DRIVER_FEATURE_NATIVE_FENCE = 37,
        DXGK_DRIVER_FEATURE_EXTENDED_SEGMENT_FLAGS = 38,
        DXGK_DRIVER_FEATURE_FAULT_AND_STALL = 39,
        DXGK_DRIVER_FEATURE_SINGLE_ADAPTER_HYBRID_MODE = 40,
        DXGK_DRIVER_FEATURE_SYNC_PRESENT_RENDER_HWQ_ONLY = 41, // Feature to avoid synchronizing present with other render queue
        //DXGK_DRIVER_FEATURE_UNIFIED_SCHEDULING_MODEL            = 42,
        //DXGK_DRIVER_FEATURE_NOTIFY_RESIDENCY2                   = 43,
        //DXGK_DRIVER_FEATURE_P2P_FENCE_SIGNAL                    = 44,
        //DXGK_DRIVER_FEATURE_PROCESS_DEBUG_BLOB_COLLECTION       = 45,
        DXGK_DRIVER_FEATURE_PANEL_BUFFER_CONTROL = 46,

        DXGK_DRIVER_FEATURE_MAX);

    TDXGK_DRIVER_FEATURE = _DXGK_DRIVER_FEATURE;
    PDXGK_DRIVER_FEATURE = ^TDXGK_DRIVER_FEATURE;

const
    DXGK_FEATURE_MAX = Ord(DXGK_DRIVER_FEATURE_MAX);

type

    _DXGK_OS_FEATURE = (
        DXGK_OS_FEATURE_QUERYSTATISTICS_EXTENSIONS = 0,
        DXGK_OS_FEATURE_RESERVE_GPUVA_ZERO_BASE_ADDRESS = 1,
        DXGK_OS_FEATURE_PER_PTE_PAGE_SIZE = 2,
        DXGK_OS_FEATURE_FENCE_SIGNAL_FROM_SWS_NODE = 3,
        DXGK_OS_FEATURE_SUPPRESSVSYNC_INTERRUPTS = 4,
        DXGK_OS_FEATURE_FEATURE_INTERFACE_EXTENSIONS = 5,
        DXGK_OS_FEATURE_READONLY_EXISTINGSYSMEM = 6,
        DXGK_OS_FEATURE_MAX);

    TDXGK_OS_FEATURE = _DXGK_OS_FEATURE;
    PDXGK_OS_FEATURE = ^TDXGK_OS_FEATURE;


    // For each feature in this enumeration, if the driver supports it,
    // it must invoke the OS QueryFeatureSupport callback
    // to report the level of support (experimental, stable, always on),
    // and only enable the feature if the OS returned Enabled=TRUE.
    // Drivers that don't support the feature don't have to call the OS to query its status.


    _DXGK_FEATURE_ID = (

        // Driver features

        DXGK_FEATURE_HWSCH = ((Ord(DXGK_FEATURE_CATEGORY_DRIVER) shl DXGK_FEATURE_ID_CATEGORY_SHIFT) or Ord(DXGK_DRIVER_FEATURE_HWSCH)),
        DXGK_FEATURE_HWFLIPQUEUE = ((Ord(DXGK_FEATURE_CATEGORY_DRIVER) shl DXGK_FEATURE_ID_CATEGORY_SHIFT) or Ord(DXGK_DRIVER_FEATURE_HWFLIPQUEUE)),
        DXGK_FEATURE_LDA_GPUPV = ((Ord(DXGK_FEATURE_CATEGORY_DRIVER) shl DXGK_FEATURE_ID_CATEGORY_SHIFT) or Ord(DXGK_DRIVER_FEATURE_LDA_GPUPV)),
        DXGK_FEATURE_KMD_SIGNAL_CPU_EVENT = ((Ord(DXGK_FEATURE_CATEGORY_DRIVER) shl DXGK_FEATURE_ID_CATEGORY_SHIFT) or Ord(DXGK_DRIVER_FEATURE_KMD_SIGNAL_CPU_EVENT)),
        DXGK_FEATURE_USER_MODE_SUBMISSION = ((Ord(DXGK_FEATURE_CATEGORY_DRIVER) shl DXGK_FEATURE_ID_CATEGORY_SHIFT) or Ord(DXGK_DRIVER_FEATURE_USER_MODE_SUBMISSION)),
        DXGK_FEATURE_SHARE_BACKING_STORE_WITH_KMD = ((Ord(DXGK_FEATURE_CATEGORY_DRIVER) shl DXGK_FEATURE_ID_CATEGORY_SHIFT) or Ord(DXGK_DRIVER_FEATURE_SHARE_BACKING_STORE_WITH_KMD)),
        DXGK_FEATURE_SAMPLE = ((Ord(DXGK_FEATURE_CATEGORY_DRIVER) shl DXGK_FEATURE_ID_CATEGORY_SHIFT) or Ord(DXGK_DRIVER_FEATURE_SAMPLE)),
        DXGK_FEATURE_PAGE_BASED_MEMORY_MANAGER = ((Ord(DXGK_FEATURE_CATEGORY_DRIVER) shl DXGK_FEATURE_ID_CATEGORY_SHIFT) or Ord(DXGK_DRIVER_FEATURE_PAGE_BASED_MEMORY_MANAGER)),
        DXGK_FEATURE_KERNEL_MODE_TESTING = ((Ord(DXGK_FEATURE_CATEGORY_DRIVER) shl DXGK_FEATURE_ID_CATEGORY_SHIFT) or Ord(DXGK_DRIVER_FEATURE_KERNEL_MODE_TESTING)),
        DXGK_FEATURE_64K_PT_DEMOTION_FIX = ((Ord(DXGK_FEATURE_CATEGORY_DRIVER) shl DXGK_FEATURE_ID_CATEGORY_SHIFT) or Ord(DXGK_DRIVER_FEATURE_64K_PT_DEMOTION_FIX)),
        DXGK_FEATURE_GPUPV_PRESENT_HWQUEUE = ((Ord(DXGK_FEATURE_CATEGORY_DRIVER) shl DXGK_FEATURE_ID_CATEGORY_SHIFT) or Ord(DXGK_DRIVER_FEATURE_GPUPV_PRESENT_HWQUEUE)),
        DXGK_FEATURE_GPUVAIOMMU = ((Ord(DXGK_FEATURE_CATEGORY_DRIVER) shl DXGK_FEATURE_ID_CATEGORY_SHIFT) or Ord(DXGK_DRIVER_FEATURE_GPUVAIOMMU)),
        DXGK_FEATURE_NATIVE_FENCE = ((Ord(DXGK_FEATURE_CATEGORY_DRIVER) shl DXGK_FEATURE_ID_CATEGORY_SHIFT) or Ord(DXGK_DRIVER_FEATURE_NATIVE_FENCE)),

        // OS features

        DXGK_FEATURE_QUERYSTATISTICS_EXTENSIONS = ((Ord(DXGK_FEATURE_CATEGORY_OS) shl DXGK_FEATURE_ID_CATEGORY_SHIFT) or Ord(DXGK_OS_FEATURE_QUERYSTATISTICS_EXTENSIONS)),
        DXGK_FEATURE_RESERVE_GPUVA_ZERO_BASE_ADDRESS = ((Ord(DXGK_FEATURE_CATEGORY_OS) shl DXGK_FEATURE_ID_CATEGORY_SHIFT) or Ord(DXGK_OS_FEATURE_RESERVE_GPUVA_ZERO_BASE_ADDRESS)),
        DXGK_FEATURE_PER_PTE_PAGE_SIZE = ((Ord(DXGK_FEATURE_CATEGORY_OS) shl DXGK_FEATURE_ID_CATEGORY_SHIFT) or Ord(DXGK_OS_FEATURE_PER_PTE_PAGE_SIZE)),
        DXGK_FEATURE_FENCE_SIGNAL_FROM_SWS_NODE = ((Ord(DXGK_FEATURE_CATEGORY_OS) shl DXGK_FEATURE_ID_CATEGORY_SHIFT) or Ord(DXGK_OS_FEATURE_FENCE_SIGNAL_FROM_SWS_NODE)),
        DXGK_FEATURE_SUPPRESSVSYNC_INTERRUPTS = ((Ord(DXGK_FEATURE_CATEGORY_OS) shl DXGK_FEATURE_ID_CATEGORY_SHIFT) or Ord(DXGK_OS_FEATURE_SUPPRESSVSYNC_INTERRUPTS)));

    TDXGK_FEATURE_ID = _DXGK_FEATURE_ID;
    PDXGK_FEATURE_ID = ^TDXGK_FEATURE_ID;


    TDXGK_FEATURE_VERSION = uint16;

    _DXGK_ISFEATUREENABLED_RESULT = bitpacked record
        Version: uint16;
        case integer of
            0: (
                Enabled: 0..1;
                KnownFeature: 0..1;
                SupportedByDriver: 0..1;
                SupportedOnCurrentConfig: 0..1;
                Reserved: 0..4095;
            );
            1: (
                Value: TDXGK_FEATURE_VERSION;
            );
    end;
    TDXGK_ISFEATUREENABLED_RESULT = _DXGK_ISFEATUREENABLED_RESULT;
    PDXGK_ISFEATUREENABLED_RESULT = ^TDXGK_ISFEATUREENABLED_RESULT;


    _D3DDDI_TESTCOMMANDBUFFEROP = (
        D3DDDI_TESTCOMMANDBUFFEROP_INVALID = 0,
        D3DDDI_TESTCOMMANDBUFFEROP_COPY = 1,
        D3DDDI_TESTCOMMANDBUFFEROP_FILL = 2,
        D3DDDI_TESTCOMMANDBUFFEROP_INFINITE_LOOP = 3,
        D3DDDI_TESTCOMMANDBUFFEROP_INFINITE_PREEMPTABLE_LOOP = 4,
        D3DDDI_TESTCOMMANDBUFFEROP_MAX);

    TD3DDDI_TESTCOMMANDBUFFEROP = _D3DDDI_TESTCOMMANDBUFFEROP;
    PD3DDDI_TESTCOMMANDBUFFEROP = ^TD3DDDI_TESTCOMMANDBUFFEROP;


    _D3DDDI_TESTCOMMANDBUFFER_COPY = record
        SrcAddress: TD3DGPU_VIRTUAL_ADDRESS;
        DstAddress: TD3DGPU_VIRTUAL_ADDRESS;
        NumBytes: UINT; // Multiple of 4 bytes
    end;
    TD3DDDI_TESTCOMMANDBUFFER_COPY = _D3DDDI_TESTCOMMANDBUFFER_COPY;
    PD3DDDI_TESTCOMMANDBUFFER_COPY = ^TD3DDDI_TESTCOMMANDBUFFER_COPY;


    _D3DDDI_TESTCOMMANDBUFFER_FILL = record
        DstAddress: TD3DGPU_VIRTUAL_ADDRESS;
        NumBytes: UINT; // Multiple of 4 bytes
        Pattern: UINT;
    end;
    TD3DDDI_TESTCOMMANDBUFFER_FILL = _D3DDDI_TESTCOMMANDBUFFER_FILL;
    PD3DDDI_TESTCOMMANDBUFFER_FILL = ^TD3DDDI_TESTCOMMANDBUFFER_FILL;


    _D3DDDI_TESTCOMMANDBUFFER = record
        case integer of
            0: (
                Copy: TD3DDDI_TESTCOMMANDBUFFER_COPY;

            );
            1: (
                Fill: TD3DDDI_TESTCOMMANDBUFFER_FILL;
            );
            2: (
                Reserved: array [0..64 - 1] of char; // Reserved for future extensions
                Operation: TD3DDDI_TESTCOMMANDBUFFEROP;
                Reserved1: UINT;
            );


    end;
    TD3DDDI_TESTCOMMANDBUFFER = _D3DDDI_TESTCOMMANDBUFFER;
    PD3DDDI_TESTCOMMANDBUFFER = ^TD3DDDI_TESTCOMMANDBUFFER;


    _D3DDDI_BUILDTESTCOMMANDBUFFERFLAGS = bitpacked record
        case integer of
            0: (

                HardwareQueue: 0..1;
                Reserved: 0..2147483647;


            );
            1: (
                Value: UINT;
            );
    end;
    TD3DDDI_BUILDTESTCOMMANDBUFFERFLAGS = _D3DDDI_BUILDTESTCOMMANDBUFFERFLAGS;
    PD3DDDI_BUILDTESTCOMMANDBUFFERFLAGS = ^TD3DDDI_BUILDTESTCOMMANDBUFFERFLAGS;


    _D3DDDI_DRIVERESCAPE_BUILDTESTCOMMANDBUFFER = record
        EscapeType: TD3DDDI_DRIVERESCAPETYPE;
        hDevice: TD3DKMT_HANDLE;
        hContext: TD3DKMT_HANDLE;
        Flags: TD3DDDI_BUILDTESTCOMMANDBUFFERFLAGS;
        Command: TD3DDDI_TESTCOMMANDBUFFER;
        {_Field_size_bytes_DmaBufferSize}pDmaBuffer: pointer; // toDo TD3DKMT_PTR_PVOID;
        {_Field_size_bytes_DmaBufferPrivateDataSize}pDmaBufferPrivateData: pointer; // TD3DKMT_PTR_PVOID;
        DmaBufferSize: UINT;
        DmaBufferPrivateDataSize: UINT;
    end;
    TD3DDDI_DRIVERESCAPE_BUILDTESTCOMMANDBUFFER = _D3DDDI_DRIVERESCAPE_BUILDTESTCOMMANDBUFFER;
    PD3DDDI_DRIVERESCAPE_BUILDTESTCOMMANDBUFFER = ^TD3DDDI_DRIVERESCAPE_BUILDTESTCOMMANDBUFFER;


function IS_OFFICIAL_DDI_INTERFACE_VERSION(version: DWORD): boolean;

implementation



function IS_OFFICIAL_DDI_INTERFACE_VERSION(version: DWORD): boolean; inline;
begin
    Result := ((version = DXGKDDI_INTERFACE_VERSION_VISTA) or ((version) = DXGKDDI_INTERFACE_VERSION_VISTA_SP1) or ((version) = DXGKDDI_INTERFACE_VERSION_WIN7) or ((version) = DXGKDDI_INTERFACE_VERSION_WIN8) or
        ((version) = DXGKDDI_INTERFACE_VERSION_WDDM1_3) or ((version) = DXGKDDI_INTERFACE_VERSION_WDDM1_3_PATH_INDEPENDENT_ROTATION) or ((version) = DXGKDDI_INTERFACE_VERSION_WDDM2_0) or
        ((version) = DXGKDDI_INTERFACE_VERSION_WDDM2_1) or ((version) = DXGKDDI_INTERFACE_VERSION_WDDM2_1_5) or ((version) = DXGKDDI_INTERFACE_VERSION_WDDM2_1_6) or ((version) = DXGKDDI_INTERFACE_VERSION_WDDM2_2) or
        ((version) = DXGKDDI_INTERFACE_VERSION_WDDM2_3) or ((version) = DXGKDDI_INTERFACE_VERSION_WDDM2_4) or ((version) = DXGKDDI_INTERFACE_VERSION_WDDM2_5) or ((version) = DXGKDDI_INTERFACE_VERSION_WDDM2_6) or
        ((version) = DXGKDDI_INTERFACE_VERSION_WDDM2_7) or ((version) = DXGKDDI_INTERFACE_VERSION_WDDM2_8) or ((version) = DXGKDDI_INTERFACE_VERSION_WDDM2_9) or ((version) = DXGKDDI_INTERFACE_VERSION_WDDM3_0) or
        ((version) = DXGKDDI_INTERFACE_VERSION_WDDM3_1) or ((version) = DXGKDDI_INTERFACE_VERSION_WDDM3_2));
end;


initialization
    assert(sizeof(TD3DDDI_TESTCOMMANDBUFFER) = 72, 'D3DDDI_TESTCOMMANDBUFFER must be 72 bytes');

end.
