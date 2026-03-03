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
   File name:  pix3_win.h

   Header version: 1.0.240308001 for use with PIX up to 2601.15

   Download latest PIX from https://devblogs.microsoft.com/pix/download/

  ************************************************************************** }
unit DX12.PIX3_Win;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    Win32.ShlObj_Core,
    Win32.LibLoaderAPI,
    Win32.ProfileAPI,
    Win32.Knownfolders,
    DX12.D3D12,
    DX12.Pix3;

    {$DEFINE WINAPI_PARTITION_DESKTOP_SYSTEM_GAMES}

type
    TSetGlobalTargetWindowFn = procedure(Nameless1: HWND); stdcall;
    TCaptureNextFrameFn = function(Nameless1: PCWSTR; Nameless2: uint32): HRESULT; stdcall;
    TBeginProgrammaticGpuCaptureFn = function(Nameless1: PPIXCaptureParameters): HRESULT; stdcall;
    TBeginProgrammaticTimingCaptureFn = function(Nameless1: pointer; Nameless2: uint64): HRESULT; stdcall;
    TEndProgrammaticGpuCaptureFn = function(): HRESULT; stdcall;
    TEndProgrammaticTimingCaptureFn = function(Nameless1: winbool): HRESULT; stdcall;
    TForceD3D11On12Fn = function(): HRESULT; stdcall;
    TSetHUDOptionsFn = function(Nameless1: TPIXHUDOptions): HRESULT; stdcall;
    TGetIsAttachedToPixFn = function(): winbool; stdcall;



function PIXGetTimestampCounter(): uint64; inline;
function GetGpuCaptureFunctionPtr(fnName: LPCSTR): pointer; inline;



function PIXLoadLatestWinPixGpuCapturerLibrary(): HMODULE; inline;
function PIXLoadLatestWinPixTimingCapturerLibrary(): HMODULE; inline;
function PIXSetTargetWindow(hwnd: HWND): HRESULT; stdcall; inline;
function PIXGpuCaptureNextFrames(fileName: PCWSTR; numFrames: uint32): HRESULT; stdcall; inline;
function PIXBeginCapture2(captureFlags: DWORD; {_In_opt_} const captureParameters: PPIXCaptureParameters): HRESULT; stdcall; inline;
function PIXEndCapture(discard: winbool): HRESULT; stdcall; inline;
function PIXForceD3D11On12(): HRESULT; stdcall; inline;
function PIXSetHUDOptions(hudOptions: TPIXHUDOptions): HRESULT; stdcall; inline;
function PIXIsAttachedForGpuCapture(): boolean; stdcall; inline;
function PIXOpenCaptureInUI(fileName: PCWSTR): HINST; stdcall; inline;



procedure PIXInsertTimingMarkerOnContextForBeginEvent(
    {_In_ } commandList: ID3D12GraphicsCommandList; eventType: uint8;
    {_In_reads_bytes_(size) } Data: Pvoid; size: UINT);

procedure PIXInsertTimingMarkerOnContextForBeginEvent(
    {_In_ } constref commandQueue: ID3D12CommandQueue; eventType: uint8;
    {_In_reads_bytes_(size) } Data: Pvoid; size: UINT);

procedure PIXInsertTimingMarkerOnContextForSetMarker(
    {_In_ } commandList: ID3D12GraphicsCommandList; eventType: uint8;
    {_In_reads_bytes_(size) } Data: Pvoid; size: UINT);

procedure PIXInsertTimingMarkerOnContextForSetMarker(
    {_In_ } commandQueue: ID3D12CommandQueue; eventType: uint8;
    {_In_reads_bytes_(size) } Data: Pvoid; size: UINT);

procedure PIXInsertTimingMarkerOnContextForEndEvent(
    {_In_ } commandList: ID3D12GraphicsCommandList; eventType: uint8);

procedure PIXInsertTimingMarkerOnContextForEndEvent(
    {_In_ } commandQueue: ID3D12CommandQueue; eventType: uint8);

procedure PIXInsertGPUMarkerOnContextForBeginEvent(
    {_In_ } commandList: ID3D12GraphicsCommandList; eventType: uint8;
    {_In_reads_bytes_(size) } Data: Pvoid; size: UINT);

procedure PIXInsertGPUMarkerOnContextForBeginEvent(
    {_In_ } commandQueue: ID3D12CommandQueue; eventType: uint8;
    {_In_reads_bytes_(size) } Data: Pvoid; size: UINT);

procedure PIXInsertGPUMarkerOnContextForSetMarker(
    {_In_ } commandList: ID3D12GraphicsCommandList; eventType: uint8;
    {_In_reads_bytes_(size) } Data: Pvoid; size: UINT);

procedure PIXInsertGPUMarkerOnContextForSetMarker(
    {_In_ } commandQueue: ID3D12CommandQueue; eventType: uint8;
    {_In_reads_bytes_(size) } Data: Pvoid; size: UINT);

procedure PIXInsertGPUMarkerOnContextForEndEvent(
    {_In_ } commandList: ID3D12GraphicsCommandList; Nameless2: uint8; Nameless3: pointer; Nameless4: UINT);

procedure PIXInsertGPUMarkerOnContextForEndEvent(
    {_In_ } commandQueue: ID3D12CommandQueue; Nameless2: uint8; Nameless3: pointer; Nameless4: UINT);



implementation

uses
    Windows.Macros;

function PIXGetTimestampCounter(): uint64; inline;
var
    lTime: LARGE_INTEGER;
begin
    QueryPerformanceCounter(@lTime);
    Result := uint64(lTime.QuadPart);
end;


function GetGpuCaptureFunctionPtr(fnName: LPCSTR): pointer; inline;
var
    module: HMODULE;
    fn: pointer;
begin
    module := GetModuleHandleW('WinPixGpuCapturer.dll');
    if (module = 0) then
    begin
        Result := nil;
        Exit;
    end;

    fn := GetProcAddress(module, fnName);
    if (fn = nil) then
    begin
        Result := nil;
        Exit;
    end;

    Result := fn;
end;

function GetTimingCaptureFunctionPtr(fnName: LPCSTR): pointer; inline;
var
    module: HMODULE;
    fn: pointer;
begin
    module := GetModuleHandleW('WinPixTimingCapturer.dll');
    if (module = 0) then
    begin
        Result := nil;
        Exit;
    end;

    fn := GetProcAddress(module, fnName);
    if (fn = nil) then
    begin
        Result := nil;
        Exit;
    end;

    Result := fn;
end;


function PIXLoadLatestCapturerLibrary(const capturerDllName: widestring; flags: DWORD): HMODULE; inline;
var
    libHandle: HMODULE;
    programFilesPath: LPWSTR;
    pixSearchPath: array [0..MAX_PATH - 1] of widechar;
    findData: WIN32_FIND_DATAW;
    foundPixInstallation: boolean = False;
    newestVersionFound: array[0..MAX_PATH - 1] of widechar;
    output: array[0..MAX_PATH - 1] of widechar;
    possibleOutput: array[0..MAX_PATH - 1] of widechar;
    hFind: HANDLE;
    dwResult: DWORD;
begin

    if (GetModuleHandleExW(0, pwidechar(capturerDllName), @libHandle)) then
    begin
        Result := libHandle;
        Exit;
    end;
    (*
    programFilesPath := nil;
    if (FAILED(SHGetKnownFolderPath(@FOLDERID_ProgramFiles, KF_FLAG_DEFAULT, 0, programFilesPath))) then
    begin
        CoTaskMemFree(programFilesPath);
        Result := nil;
        Exit;
    end;



    if (FAILED(StringCchCopyW(pixSearchPath, MAX_PATH, programFilesPath))) then
    begin
        CoTaskMemFree(programFilesPath);
        Result := nil;
        Exit;
    end;
    CoTaskMemFree(programFilesPath);

    PIXERRORCHECK(StringCchCatW(pixSearchPath, MAX_PATH, '\\Microsoft PIX\\*'));



    hFind := FindFirstFileW(pixSearchPath, @findData);
    if (hFind <> INVALID_HANDLE_VALUE) then
    begin
        repeat
            begin
                if (((findData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = FILE_ATTRIBUTE_DIRECTORY) and (findData.cFileName[0] <> '.')) then
                begin
                    if (not foundPixInstallation or wcscmp(newestVersionFound, findData.cFileName) <= 0) then
                    begin
                        // length - 1 to get rid of the wildcard character in the search path
                        PIXERRORCHECK(StringCchCopyNW(possibleOutput, MAX_PATH, pixSearchPath, wcslen(pixSearchPath) - 1));
                        PIXERRORCHECK(StringCchCatW(possibleOutput, MAX_PATH, findData.cFileName));
                        PIXERRORCHECK(StringCchCatW(possibleOutput, MAX_PATH, '\\'));
                        PIXERRORCHECK(StringCchCatW(possibleOutput, MAX_PATH, capturerDllName));

                        dwResult := GetFileAttributesW(possibleOutput);

                        if (dwResult <> INVALID_FILE_ATTRIBUTES) and not ((dwResult and FILE_ATTRIBUTE_DIRECTORY) = FILE_ATTRIBUTE_DIRECTORY) then
                        begin
                            foundPixInstallation := True;
                            PIXERRORCHECK(StringCchCopyW(newestVersionFound, Length(newestVersionFound), findData.cFileName));
                            PIXERRORCHECK(StringCchCopyW(output, Length(possibleOutput), possibleOutput));
                        end;
                    end;
                end;
            end;
        until (FindNextFileW(hFind, @findData) = 0);
    end;

    FindClose(hFind);

    if (not foundPixInstallation) then
    begin
        SetLastError(ERROR_FILE_NOT_FOUND);
        Result := nil;
        Exit;
    end;

    Result := LoadLibraryExW(output, flags);
    *)
end;

{$IFDEF WINAPI_PARTITION_DESKTOP_SYSTEM_GAMES}
function PIXLoadLatestWinPixGpuCapturerLibrary(): HMODULE; inline;
begin
    Result := PIXLoadLatestCapturerLibrary('WinPixGpuCapturer.dll', LOAD_LIBRARY_SEARCH_DEFAULT_DIRS);
end;


function PIXLoadLatestWinPixTimingCapturerLibrary(): HMODULE; inline;
begin
    Result := PIXLoadLatestCapturerLibrary('WinPixTimingCapturer.dll', LOAD_LIBRARY_SEARCH_DEFAULT_DIRS or LOAD_LIBRARY_SEARCH_DLL_LOAD_DIR);
end;

function PIXSetTargetWindow(hwnd: HWND): HRESULT; stdcall; inline;
var
    fn: TSetGlobalTargetWindowFn;
begin
    fn := TSetGlobalTargetWindowFn(GetGpuCaptureFunctionPtr('SetGlobalTargetWindow'));
    if (fn = nil) then
    begin
        Result := HRESULT_FROM_WIN32(GetLastError());
        Exit;
    end;

    fn(hwnd);
    Result := S_OK;
end;

function PIXGpuCaptureNextFrames(fileName: PCWSTR; numFrames: uint32): HRESULT; stdcall; inline;
var
    fn: TCaptureNextFrameFn;
begin
    fn := TCaptureNextFrameFn(GetGpuCaptureFunctionPtr('CaptureNextFrame'));
    if (fn = nil) then
    begin
        Result := HRESULT_FROM_WIN32(GetLastError());
        Exit;
    end;

    Result := fn(fileName, numFrames);
end;



function PIXBeginCapture2(captureFlags: DWORD; {_In_opt_} const captureParameters: PPIXCaptureParameters): HRESULT; stdcall; inline;
var
    fn: TBeginProgrammaticGpuCaptureFn;
    fn2: TBeginProgrammaticTimingCaptureFn;
begin
    if (captureFlags = PIX_CAPTURE_GPU) then
    begin
        fn := TBeginProgrammaticGpuCaptureFn(GetGpuCaptureFunctionPtr('BeginProgrammaticGpuCapture'));
        if (fn = nil) then
        begin
            Result := HRESULT_FROM_WIN32(GetLastError());
            Exit;
        end;

        Result := fn(captureParameters);
        Exit;
    end
    else if (captureFlags = PIX_CAPTURE_TIMING) then
    begin

        fn2 := TBeginProgrammaticTimingCaptureFn(GetTimingCaptureFunctionPtr('BeginProgrammaticTimingCapture'));
        if (fn2 = nil) then
        begin
            Result := HRESULT_FROM_WIN32(GetLastError());
            Exit;
        end;

        Result := fn2(@captureParameters^.TimingCaptureParameters, sizeof(captureParameters^.TimingCaptureParameters));
        Exit;
    end
    else
    begin
        Result := E_NOTIMPL;
    end;
end;

function PIXEndCapture(discard: winbool): HRESULT; stdcall; inline;
var
    gpuFn: TEndProgrammaticGpuCaptureFn;
    timingFn: TEndProgrammaticTimingCaptureFn;
begin
    // We can't tell if the user wants to end a GPU Capture or a Timing Capture.
    // The user shouldn't have both WinPixGpuCapturer and WinPixTimingCapturer loaded in the process though,
    // so we can just look for one of them and call it.

    gpuFn := TEndProgrammaticGpuCaptureFn(GetGpuCaptureFunctionPtr('EndProgrammaticGpuCapture'));
    if (gpuFn <> nil) then
    begin
        Result := gpuFn();
        Exit;
    end;


    timingFn := TEndProgrammaticTimingCaptureFn(GetTimingCaptureFunctionPtr('EndProgrammaticTimingCapture'));
    if (timingFn <> nil) then
    begin
        Result := timingFn(discard);
        Exit;
    end;

    Result := HRESULT_FROM_WIN32(GetLastError());
end;

function PIXForceD3D11On12(): HRESULT; stdcall; inline;
var
    fn: TForceD3D11On12Fn;
begin

    fn := TForceD3D11On12Fn(GetGpuCaptureFunctionPtr('ForceD3D11On12'));
    if (fn = nil) then
    begin
        Result := HRESULT_FROM_WIN32(GetLastError());
        Exit;
    end;

    Result := fn();
end;


function PIXSetHUDOptions(hudOptions: TPIXHUDOptions): HRESULT; stdcall; inline;
var
    fn: TSetHUDOptionsFn;
begin

    fn := TSetHUDOptionsFn(GetGpuCaptureFunctionPtr('SetHUDOptions'));
    if (fn = nil) then
    begin
        Result := HRESULT_FROM_WIN32(GetLastError());
        Exit;
    end;

    Result := fn(hudOptions);
end;

function PIXIsAttachedForGpuCapture(): boolean; stdcall; inline;
var
    fn: TGetIsAttachedToPixFn;
begin

    fn := TGetIsAttachedToPixFn(GetGpuCaptureFunctionPtr('GetIsAttachedToPix'));
    if (fn = nil) then
    begin
        OutputDebugStringW('WinPixEventRuntime error: Mismatched header/dll. Please ensure that pix3.h and WinPixGpuCapturer.dll match');
        Result := False;
        Exit;
    end;

    Result := fn();
end;

function PIXOpenCaptureInUI(fileName: PCWSTR): HINST; stdcall; inline;
begin
    Result := ShellExecuteW(0, nil, fileName, nil, nil, SW_SHOW);
end;



{$ELSE}

function PIXLoadLatestWinPixGpuCapturerLibrary(): HMODULE;  inline;
begin
    Result := 0;
    Exit;
end;

function PIXLoadLatestWinPixTimingCapturerLibrary(): HMODULE;  inline;
begin
    Result := 0;
    Exit;
end;

function PIXSetTargetWindow(hwnd: HWND): HRESULT; stdcall; inline;
begin
    Result := E_NOTIMPL;
end;

function PIXGpuCaptureNextFrames(fileName: PCWSTR; numFrames: uint32): HRESULT; stdcall; inline;
begin
    Result := E_NOTIMPL;
end;

function PIXBeginCapture2(captureFlags: DWORD; {_In_opt_} const captureParameters: PPIXCaptureParameters): HRESULT; stdcall; inline;
begin
    Result := E_NOTIMPL;
end;

function PIXEndCapture(discard: winbool): HRESULT; stdcall; inline;
begin
    Result := E_NOTIMPL;
end;

function PIXForceD3D11On12(): HRESULT; stdcall; inline;
begin
    Result := E_NOTIMPL;
end;

function PIXSetHUDOptions(hudOptions: TPIXHUDOptions): HRESULT; stdcall; inline;
begin
    Result := E_NOTIMPL;
end;

function PIXIsAttachedForGpuCapture(): boolean; stdcall; inline;
begin
    Result := False;
end;

function PIXOpenCaptureInUI(fileName: PCWSTR): HINST; stdcall; inline;
begin
    Result := 0;
end;
{$ENDIF}


procedure PIXInsertTimingMarkerOnContextForBeginEvent(commandList: ID3D12GraphicsCommandList; eventType: uint8; Data: Pvoid; size: UINT);
begin
    commandList.BeginEvent(WINPIX_EVENT_PIX3BLOB_V2, Data, size);
end;

procedure PIXInsertTimingMarkerOnContextForBeginEvent(constref commandQueue: ID3D12CommandQueue; eventType: uint8; Data: Pvoid; size: UINT);
begin
    commandQueue.BeginEvent(WINPIX_EVENT_PIX3BLOB_V2, Data, size);
end;

procedure PIXInsertTimingMarkerOnContextForSetMarker(commandList: ID3D12GraphicsCommandList; eventType: uint8; Data: Pvoid; size: UINT);
begin
    commandList.SetMarker(WINPIX_EVENT_PIX3BLOB_V2, Data, size);
end;

procedure PIXInsertTimingMarkerOnContextForSetMarker(commandQueue: ID3D12CommandQueue; eventType: uint8; Data: Pvoid; size: UINT);
begin
    commandQueue.SetMarker(WINPIX_EVENT_PIX3BLOB_V2, Data, size);
end;

procedure PIXInsertTimingMarkerOnContextForEndEvent(commandList: ID3D12GraphicsCommandList; eventType: uint8);
begin
    commandList.EndEvent();
end;

procedure PIXInsertTimingMarkerOnContextForEndEvent(commandQueue: ID3D12CommandQueue; eventType: uint8);
begin
    commandQueue.EndEvent();
end;

procedure PIXInsertGPUMarkerOnContextForBeginEvent(commandList: ID3D12GraphicsCommandList; eventType: uint8; Data: Pvoid; size: UINT);
begin
    commandList.BeginEvent(WINPIX_EVENT_PIX3BLOB_V2, Data, size);
end;

procedure PIXInsertGPUMarkerOnContextForBeginEvent(commandQueue: ID3D12CommandQueue; eventType: uint8; Data: Pvoid; size: UINT);
begin
    commandQueue.BeginEvent(WINPIX_EVENT_PIX3BLOB_V2, Data, size);
end;

procedure PIXInsertGPUMarkerOnContextForSetMarker(commandList: ID3D12GraphicsCommandList; eventType: uint8; Data: Pvoid; size: UINT);
begin
    commandList.SetMarker(WINPIX_EVENT_PIX3BLOB_V2, Data, size);
end;

procedure PIXInsertGPUMarkerOnContextForSetMarker(commandQueue: ID3D12CommandQueue; eventType: uint8; Data: Pvoid; size: UINT);
begin
    commandQueue.SetMarker(WINPIX_EVENT_PIX3BLOB_V2, Data, size);
end;

procedure PIXInsertGPUMarkerOnContextForEndEvent(commandList: ID3D12GraphicsCommandList; Nameless2: uint8; Nameless3: pointer; Nameless4: UINT);
begin
    commandList.EndEvent();
end;

procedure PIXInsertGPUMarkerOnContextForEndEvent(commandQueue: ID3D12CommandQueue; Nameless2: uint8; Nameless3: pointer; Nameless4: UINT);
begin
    commandQueue.EndEvent();
end;

end.
