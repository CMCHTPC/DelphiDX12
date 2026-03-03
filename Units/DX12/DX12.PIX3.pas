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
   File name:  pix3.h
               pix3_win.h
   Header version: 1.0.240308001 for use with PIX up to 2601.15

   Download latest PIX from https://devblogs.microsoft.com/pix/download/

  ************************************************************************** }
unit DX12.PIX3;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils;

    //  {$DEFINE USEPIX}
const

    PIX3_DLL = 'WinPixEventRuntime_OneCore.dll';

    // These flags are used by both PIXBeginCapture and PIXGetCaptureState
    PIX_CAPTURE_TIMING = (1 shl 0);
    PIX_CAPTURE_GPU = (1 shl 1);
    PIX_CAPTURE_FUNCTION_SUMMARY = (1 shl 2);
    PIX_CAPTURE_FUNCTION_DETAILS = (1 shl 3);
    PIX_CAPTURE_CALLGRAPH = (1 shl 4);
    PIX_CAPTURE_INSTRUCTION_TRACE = (1 shl 5);
    PIX_CAPTURE_SYSTEM_MONITOR_COUNTERS = (1 shl 6);
    PIX_CAPTURE_VIDEO = (1 shl 7);
    PIX_CAPTURE_AUDIO = (1 shl 8);
    PIX_CAPTURE_GPU_TRACE = (1 shl 9);
    PIX_CAPTURE_RESERVED = (1 shl 15);

    PIX_COLOR_DEFAULT = uint8(0);

    // pix3_win.h

    // The following WINPIX_EVENT_* defines denote the different metadata values that have
    // been used by tools to denote how to parse pix marker event data. The first two values
    // are legacy values used by pix.h in the Windows SDK.
    WINPIX_EVENT_UNICODE_VERSION = 0;
    WINPIX_EVENT_ANSI_VERSION = 1;

    // These values denote PIX marker event data that was created by the WinPixEventRuntime.
    // In early 2023 we revised the PIX marker format and defined a new version number.
    WINPIX_EVENT_PIX3BLOB_VERSION = 2;
    WINPIX_EVENT_PIX3BLOB_V2 = 6345127; // A number that other applications are unlikely to have used before

    // For backcompat reasons, the WinPixEventRuntime uses the older PIX3BLOB format when it passes data
    // into the D3D12 runtime. It will be updated to use the V2 format in the future.
    D3D12_EVENT_METADATA = WINPIX_EVENT_PIX3BLOB_VERSION;

type
    TPIXCaptureStorage = (
        Memory = 0,
        MemoryCircular = 1, // Xbox only
        FileCircular = 2// PC only
        );

    PPIXCaptureStorage = ^TPIXCaptureStorage;

    TGpuCaptureParameters = record
        FileName: PCWSTR;
    end;
    PGpuCaptureParameters = ^TGpuCaptureParameters;


    TTimingCaptureParameters = record
        FileName: PCWSTR;
        MaximumToolingMemorySizeMb: uint32;
        CaptureStorage: TPIXCaptureStorage;
        CaptureGpuTiming: winbool;
        CaptureCallstacks: winbool;
        CaptureCpuSamples: winbool;
        CpuSamplesPerSecond: uint32;
        CaptureFileIO: winbool;
        CaptureVirtualAllocEvents: winbool;
        CaptureHeapAllocEvents: winbool;
        CaptureXMemEvents: winbool; // Xbox only
        CapturePixMemEvents: winbool;
        CapturePageFaultEvents: winbool;
        CaptureVideoFrames: winbool; // Xbox only
    end;
    PTimingCaptureParameters = ^TTimingCaptureParameters;




    TGpuTraceParameters = record
        FileName: PWSTR;
        MaximumToolingMemorySizeMb: uint32;
        CaptureGpuOccupancy: winbool;
    end;
    PGpuTraceParameters = ^TGpuTraceParameters;

    TPIXCaptureParameters = record
        case integer of
            0: (GpuCaptureParameters: TGpuCaptureParameters);
            1: (TimingCaptureParameters: TTimingCaptureParameters);
            2: (GpuTraceParameters: TGpuTraceParameters);
    end;

    PPIXCaptureParameters = ^TPIXCaptureParameters;


    // pix3_win.h

    TPIXHUDOptions = (
        PIX_HUD_SHOW_ON_ALL_WINDOWS = $1,
        PIX_HUD_SHOW_ON_TARGET_WINDOW_ONLY = $2,
        PIX_HUD_SHOW_ON_NO_WINDOWS = $4);

    PPIXHUDOptions = ^TPIXHUDOptions;

    // PIXEventsThreadInfo is defined in PIXEventsCommon.h
    PPIXEventsThreadInfo = pointer;

{$IFDEF USEPIX}
// Starts a programmatically controlled capture.
// captureFlags uses the PIX_CAPTURE_* family of flags to specify the type of capture to take
function PIXBeginCapture2(captureFlags: DWORD;
    {_In_opt_ } captureParameters: PPIXCaptureParameters): HRESULT; stdcall; external PIX3_DLL;

function PIXBeginCapture(captureFlags: DWORD;
    {_In_opt_ } captureParameters: PPIXCaptureParameters): HRESULT; inline;


// Stops a programmatically controlled capture
//  If discard == TRUE, the captured data is discarded
//  If discard == FALSE, the captured data is saved
//  discard parameter is not supported on Windows
function PIXEndCapture(discard: winbool): HRESULT; stdcall; external PIX3_DLL;



function PIXGetCaptureState(): DWORD; stdcall; external PIX3_DLL;


procedure PIXReportCounter(
    {_In_ } Name: PCWSTR; Value: single); stdcall; external PIX3_DLL;

function PIXGetThreadInfo(): PPIXEventsThreadInfo; external PIX3_DLL;



// Notifies PIX that an event handle was set as a result of a D3D12 fence being signaled.
// The event specified must have the same handle value as the handle
// used in ID3D12Fence::SetEventOnCompletion.
procedure PIXNotifyWakeFromFenceSignal(
    {_In_ } event: HANDLE); stdcall;external PIX3_DLL;


// Notifies PIX that a block of memory was allocated
procedure PIXRecordMemoryAllocationEvent(allocatorId: USHORT; baseAddress: Pvoid; size: size_t; metadata: uint64); stdcall; external PIX3_DLL;

// Notifies PIX that a block of memory was freed
procedure PIXRecordMemoryFreeEvent(allocatorId: USHORT; baseAddress: Pvoid; size: size_t; metadata: uint64); stdcall; external PIX3_DLL;




{$ELSE}

// Eliminate these APIs when not using PIX
function PIXBeginCapture2(captureFlags: DWORD;
    {_In_opt_ } captureParameters: PPIXCaptureParameters): HRESULT;

function PIXBeginCapture(captureFlags: DWORD;
    {_In_opt_ } captureParameters: PPIXCaptureParameters): HRESULT;

function PIXEndCapture(discard: winbool): HRESULT;

function PIXGpuCaptureNextFrames(Nameless1: PCWSTR; Nameless2: uint32): HRESULT;

function PIXSetTargetWindow(Nameless1: HWND): HRESULT;

function PIXForceD3D11On12(): HRESULT;

function PIXSetHUDOptions(Nameless1: TPIXHUDOptions): HRESULT; stdcall;

function PIXIsAttachedForGpuCapture(): winbool; stdcall;

function PIXOpenCaptureInUI(Nameless1: PCWSTR): HINST; stdcall;

function PIXLoadLatestWinPixGpuCapturerLibrary(): HMODULE;

function PIXLoadLatestWinPixTimingCapturerLibrary(): HMODULE;

function PIXGetCaptureState(): DWORD;

procedure PIXReportCounter({_In_ } Name: PCWSTR; Value: single);

procedure PIXNotifyWakeFromFenceSignal({_In_ } Nameless1: HANDLE);


// Eliminate these APIs when not using PIX
procedure PIXRecordMemoryAllocationEvent(allocatorId: USHORT; baseAddress: Pvoid; size: size_t; metadata: uint64); stdcall;
procedure PIXRecordMemoryFreeEvent(allocatorId: USHORT; baseAddress: Pvoid; size: size_t; metadata: uint64); stdcall;

{$ENDIF}

// Use these functions to specify colors to pass as metadata to a PIX event/marker API.
// Use PIX_COLOR() to specify a particular color for an event.
// Or, use PIX_COLOR_INDEX() to specify a set of unique event categories, and let PIX choose
// the colors to represent each category.
function PIX_COLOR(r: uint8; g: uint8; b: uint8): uint32;
function PIX_COLOR_INDEX(i: uint8): uint8;




implementation



function PIX_COLOR(r: uint8; g: uint8; b: uint8): uint32;
begin
    Result := $ff000000 or (r shl 16) or (g shl 8) or b;
end;

function PIX_COLOR_INDEX(i: uint8): uint8;
begin
    Result := i;
end;

{$IFDEF USEPIX}
function PIXBeginCapture(captureFlags: DWORD; captureParameters: PPIXCaptureParameters): HRESULT;
begin
    Result := PIXBeginCapture2(captureFlags, captureParameters);
end;
{$ELSE}

function PIXBeginCapture2(captureFlags: DWORD; captureParameters: PPIXCaptureParameters): HRESULT;
begin
    Result := S_OK;
end;

function PIXBeginCapture(captureFlags: DWORD; captureParameters: PPIXCaptureParameters): HRESULT;
begin
    Result := S_OK;
end;

function PIXEndCapture(discard: winbool): HRESULT;
begin
    Result := S_OK;
end;

function PIXGpuCaptureNextFrames(Nameless1: PCWSTR; Nameless2: uint32): HRESULT;
begin
    Result := S_OK;
end;

function PIXSetTargetWindow(Nameless1: HWND): HRESULT;
begin
    Result := S_OK;
end;

function PIXForceD3D11On12(): HRESULT;
begin
    Result := S_OK;
end;

function PIXSetHUDOptions(Nameless1: TPIXHUDOptions): HRESULT; stdcall;
begin
    Result := S_OK;
end;

function PIXIsAttachedForGpuCapture(): winbool; stdcall;
begin
    Result := False;
end;

function PIXOpenCaptureInUI(Nameless1: PCWSTR): HINST; stdcall;
begin
    Result := 0;
end;

function PIXLoadLatestWinPixGpuCapturerLibrary(): HMODULE;
begin
    Result := 0;
end;

function PIXLoadLatestWinPixTimingCapturerLibrary(): HMODULE;
begin
    Result := 0;
end;

function PIXGetCaptureState(): DWORD;
begin
    Result := 0;
end;

procedure PIXReportCounter(Name: PCWSTR; Value: single);
begin
    // nothing to do ;)
end;

procedure PIXNotifyWakeFromFenceSignal(Nameless1: HANDLE);
begin
    // nothing to do ;)
end;


procedure PIXRecordMemoryAllocationEvent(allocatorId: USHORT; baseAddress: Pvoid; size: size_t; metadata: uint64); stdcall;
begin
    // nothing to do ;)
end;

procedure PIXRecordMemoryFreeEvent(allocatorId: USHORT; baseAddress: Pvoid; size: size_t; metadata: uint64); stdcall;
begin
    // nothing to do ;)
end;

{$ENDIF}



end.
