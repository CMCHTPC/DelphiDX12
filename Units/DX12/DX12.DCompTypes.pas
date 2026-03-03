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

   Copyright (c) Microsoft Corporation.  All rights reserved.

   This unit consists of the following header files
   File name: dcomptypes.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.DCompTypes;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.DXGICommon,
    DX12.DXGIType,
    DX12.DXGI1_5;

    {$Z4}

const


    // Composition object specific access flags
    COMPOSITIONOBJECT_READ = $0001;
    COMPOSITIONOBJECT_WRITE = $0002;

    COMPOSITIONOBJECT_ALL_ACCESS = (COMPOSITIONOBJECT_READ or COMPOSITIONOBJECT_WRITE);


    // The maximum nubmer of objects we allow users to wait on the compositor clock
    DCOMPOSITION_MAX_WAITFORCOMPOSITORCLOCK_OBJECTS = 32;

    // Maximum number of targets kept per frame
    COMPOSITION_STATS_MAX_TARGETS = 256;


type
    _LUID = record
        case integer of
            0: (
                LowPart: DWORD;
                HighPart: LONG);
            1: (Value: ULONG64)
    end;
    TLUID = _LUID;
    PLUID = ^TLUID;

    // DirectComposition types


    TDCOMPOSITION_BITMAP_INTERPOLATION_MODE = (
        DCOMPOSITION_BITMAP_INTERPOLATION_MODE_NEAREST_NEIGHBOR = 0,
        DCOMPOSITION_BITMAP_INTERPOLATION_MODE_LINEAR = 1,
        DCOMPOSITION_BITMAP_INTERPOLATION_MODE_INHERIT = $ffffffff
        );

    PDCOMPOSITION_BITMAP_INTERPOLATION_MODE = ^TDCOMPOSITION_BITMAP_INTERPOLATION_MODE;


    TDCOMPOSITION_BORDER_MODE = (
        DCOMPOSITION_BORDER_MODE_SOFT = 0,
        DCOMPOSITION_BORDER_MODE_HARD = 1,
        DCOMPOSITION_BORDER_MODE_INHERIT = $ffffffff
        );

    PDCOMPOSITION_BORDER_MODE = ^TDCOMPOSITION_BORDER_MODE;


    TDCOMPOSITION_COMPOSITE_MODE = (
        DCOMPOSITION_COMPOSITE_MODE_SOURCE_OVER = 0,
        DCOMPOSITION_COMPOSITE_MODE_DESTINATION_INVERT = 1,
        DCOMPOSITION_COMPOSITE_MODE_MIN_BLEND = 2,
        DCOMPOSITION_COMPOSITE_MODE_INHERIT = $ffffffff
        );

    PDCOMPOSITION_COMPOSITE_MODE = ^TDCOMPOSITION_COMPOSITE_MODE;


    TDCOMPOSITION_BACKFACE_VISIBILITY = (
        DCOMPOSITION_BACKFACE_VISIBILITY_VISIBLE = 0,
        DCOMPOSITION_BACKFACE_VISIBILITY_HIDDEN = 1,
        DCOMPOSITION_BACKFACE_VISIBILITY_INHERIT = $ffffffff
        );

    PDCOMPOSITION_BACKFACE_VISIBILITY = ^TDCOMPOSITION_BACKFACE_VISIBILITY;


    TDCOMPOSITION_OPACITY_MODE = (
        DCOMPOSITION_OPACITY_MODE_LAYER = 0,
        DCOMPOSITION_OPACITY_MODE_MULTIPLY = 1,
        DCOMPOSITION_OPACITY_MODE_INHERIT = $ffffffff
        );

    PDCOMPOSITION_OPACITY_MODE = ^TDCOMPOSITION_OPACITY_MODE;


    TDCOMPOSITION_DEPTH_MODE = (
        DCOMPOSITION_DEPTH_MODE_TREE = 0,
        DCOMPOSITION_DEPTH_MODE_SPATIAL = 1,
        DCOMPOSITION_DEPTH_MODE_SORTED = 3,
        DCOMPOSITION_DEPTH_MODE_INHERIT = $ffffffff
        );

    PDCOMPOSITION_DEPTH_MODE = ^TDCOMPOSITION_DEPTH_MODE;


    TDCOMPOSITION_FRAME_STATISTICS = record
        lastFrameTime: LARGE_INTEGER;
        currentCompositionRate: TDXGI_RATIONAL;
        currentTime: LARGE_INTEGER;
        timeFrequency: LARGE_INTEGER;
        nextEstimatedFrameTime: LARGE_INTEGER;
    end;
    PDCOMPOSITION_FRAME_STATISTICS = ^TDCOMPOSITION_FRAME_STATISTICS;


    // Composition Stats


    TCOMPOSITION_FRAME_ID_TYPE = (
        COMPOSITION_FRAME_ID_CREATED = 0,
        COMPOSITION_FRAME_ID_CONFIRMED = 1,
        COMPOSITION_FRAME_ID_COMPLETED = 2);

    PCOMPOSITION_FRAME_ID_TYPE = ^TCOMPOSITION_FRAME_ID_TYPE;


    TCOMPOSITION_FRAME_ID = ULONG64;
    PCOMPOSITION_FRAME_ID = ^TCOMPOSITION_FRAME_ID;

    tagCOMPOSITION_FRAME_STATS = record
        startTime: uint64;
        targetTime: uint64;
        framePeriod: uint64;
    end;
    TCOMPOSITION_FRAME_STATS = tagCOMPOSITION_FRAME_STATS;
    PCOMPOSITION_FRAME_STATS = ^TCOMPOSITION_FRAME_STATS;


    { tagCOMPOSITION_TARGET_ID }

    tagCOMPOSITION_TARGET_ID = record
        displayAdapterLuid: TLUID;
        renderAdapterLuid: TLUID;
        vidPnSourceId: UINT;
        vidPnTargetId: UINT;
        uniqueId: UINT;
        class operator Equal(lhs: tagCOMPOSITION_TARGET_ID; rhs: tagCOMPOSITION_TARGET_ID): boolean;
        class operator  NotEqual(lhs: tagCOMPOSITION_TARGET_ID; rhs: tagCOMPOSITION_TARGET_ID): boolean;
    end;
    TCOMPOSITION_TARGET_ID = tagCOMPOSITION_TARGET_ID;
    PCOMPOSITION_TARGET_ID = ^TCOMPOSITION_TARGET_ID;


    tagCOMPOSITION_STATS = record
        presentCount: UINT;
        refreshCount: UINT;
        virtualRefreshCount: UINT;
        time: uint64;
    end;
    TCOMPOSITION_STATS = tagCOMPOSITION_STATS;
    PCOMPOSITION_STATS = ^TCOMPOSITION_STATS;


    tagCOMPOSITION_TARGET_STATS = record
        outstandingPresents: UINT;
        presentTime: uint64;
        vblankDuration: uint64;
        presentedStats: TCOMPOSITION_STATS;
        completedStats: TCOMPOSITION_STATS;
    end;
    TCOMPOSITION_TARGET_STATS = tagCOMPOSITION_TARGET_STATS;
    PCOMPOSITION_TARGET_STATS = ^TCOMPOSITION_TARGET_STATS;


implementation

{ tagCOMPOSITION_TARGET_ID }

class operator tagCOMPOSITION_TARGET_ID.Equal(lhs: tagCOMPOSITION_TARGET_ID; rhs: tagCOMPOSITION_TARGET_ID): boolean;
begin
    Result := ((lhs.displayAdapterLuid.LowPart = rhs.displayAdapterLuid.LowPart) and (lhs.displayAdapterLuid.HighPart = rhs.displayAdapterLuid.HighPart) and (lhs.renderAdapterLuid.LowPart =
        rhs.renderAdapterLuid.LowPart) and (lhs.renderAdapterLuid.HighPart = rhs.renderAdapterLuid.HighPart) and (lhs.vidPnSourceId = rhs.vidPnSourceId) and (lhs.vidPnTargetId = rhs.vidPnTargetId) and
        ((lhs.uniqueId = rhs.uniqueId) or (lhs.uniqueId = 0) or (rhs.uniqueId = 0)));
end;



class operator tagCOMPOSITION_TARGET_ID.NotEqual(lhs: tagCOMPOSITION_TARGET_ID; rhs: tagCOMPOSITION_TARGET_ID): boolean;
begin
    Result := not (lhs = rhs);
end;

end.
