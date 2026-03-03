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

   (********************************************************************************
   *                                                                               *
   * libloaderapi.h -- ApiSet Contract for api-ms-win-core-libraryloader-l1        *
   *                                                                               *
   * Copyright (c) Microsoft Corporation. All rights reserved.                     *
   *                                                                               *
   ********************************************************************************)

   This unit consists of the following header files
   File name: libloaderapi.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit Win32.LibLoaderAPI;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils;

    {$DEFINE NTDDI_WIN10_RS1}
    {$DEFINE NTDDI_WIN10_RS2}

const
    Kernel32_dll = 'Kernel32.dll';
    User32_dll = 'User32.dll';

    FIND_RESOURCE_DIRECTORY_TYPES = ($0100);
    FIND_RESOURCE_DIRECTORY_NAMES = ($0200);
    FIND_RESOURCE_DIRECTORY_LANGUAGES = ($0400);

    RESOURCE_ENUM_LN = ($0001);
    RESOURCE_ENUM_MUI = ($0002);
    RESOURCE_ENUM_MUI_SYSTEM = ($0004);
    RESOURCE_ENUM_VALIDATE = ($0008);
    RESOURCE_ENUM_MODULE_EXACT = ($0010);

    SUPPORT_LANG_NUMBER = 32;

    GET_MODULE_HANDLE_EX_FLAG_PIN = ($00000001);
    GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT = ($00000002);
    GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS = ($00000004);

    CURRENT_IMPORT_REDIRECTION_VERSION = 1;



    DONT_RESOLVE_DLL_REFERENCES = $00000001;
    LOAD_LIBRARY_AS_DATAFILE = $00000002;
    // reserved for internal LOAD_PACKAGED_LIBRARY: 0x00000004
    LOAD_WITH_ALTERED_SEARCH_PATH = $00000008;
    LOAD_IGNORE_CODE_AUTHZ_LEVEL = $00000010;
    LOAD_LIBRARY_AS_IMAGE_RESOURCE = $00000020;
    LOAD_LIBRARY_AS_DATAFILE_EXCLUSIVE = $00000040;
    LOAD_LIBRARY_REQUIRE_SIGNED_TARGET = $00000080;
    LOAD_LIBRARY_SEARCH_DLL_LOAD_DIR = $00000100;
    LOAD_LIBRARY_SEARCH_APPLICATION_DIR = $00000200;
    LOAD_LIBRARY_SEARCH_USER_DIRS = $00000400;
    LOAD_LIBRARY_SEARCH_SYSTEM32 = $00000800;
    LOAD_LIBRARY_SEARCH_DEFAULT_DIRS = $00001000;



    {$IFDEF NTDDI_WIN10_RS1}
    LOAD_LIBRARY_SAFE_CURRENT_DIRS = $00002000;
    LOAD_LIBRARY_SEARCH_SYSTEM32_NO_FORWARDER = $00004000;
    {$ELSE}
//
// For anything building for downlevel, set the flag to be the same as LOAD_LIBRARY_SEARCH_SYSTEM32
// such that they're treated the same when running on older version of OS.
//

    LOAD_LIBRARY_SEARCH_SYSTEM32_NO_FORWARDER = LOAD_LIBRARY_SEARCH_SYSTEM32;
    {$ENDIF}// (_APISET_LIBLOADER_VER >= 0x0202)

    {$IFDEF NTDDI_WIN10_RS2}
    LOAD_LIBRARY_OS_INTEGRITY_CONTINUITY = $00008000;
    {$ENDIF}



type
    PLANGID = pointer;
    PHMODULE = ^HMODULE;

    tagENUMUILANG = record
        NumOfEnumUILang: ULONG; // Acutall number of enumerated languages
        SizeOfEnumUIBuffer: ULONG; // Buffer size of pMUIEnumUILanguages
        pEnumUIBuffer: PLANGID;
    end;
    TENUMUILANG = tagENUMUILANG;
    PENUMUILANG = ^TENUMUILANG;



    TENUMRESLANGPROCA = function(
        {_In_opt_ } hModule: HMODULE;
        {_In_ } lpType: LPCSTR;
        {_In_ } lpName: LPCSTR;
        {_In_ } wLanguage: word;
        {_In_ } lParam: LONG_PTR): winbool; stdcall;

    TENUMRESLANGPROCW = function(
        {_In_opt_ } hModule: HMODULE;
        {_In_ } lpType: LPCWSTR;
        {_In_ } lpName: LPCWSTR;
        {_In_ } wLanguage: word;
        {_In_ } lParam: LONG_PTR): winbool; stdcall;



    TENUMRESNAMEPROCA = function(
        {_In_opt_ } hModule: HMODULE;
        {_In_ } lpType: LPCSTR;
        {_In_ } lpName: LPSTR;
        {_In_ } lParam: LONG_PTR): winbool; stdcall;

    TENUMRESNAMEPROCW = function(
        {_In_opt_ } hModule: HMODULE;
        {_In_ } lpType: LPCWSTR;
        {_In_ } lpName: LPWSTR;
        {_In_ } lParam: LONG_PTR): winbool; stdcall;



    TENUMRESTYPEPROCA = function(
        {_In_opt_ } hModule: HMODULE;
        {_In_ } lpType: LPSTR;
        {_In_ } lParam: LONG_PTR): winbool; stdcall;

    TENUMRESTYPEPROCW = function(
        {_In_opt_ } hModule: HMODULE;
        {_In_ } lpType: LPWSTR;
        {_In_ } lParam: LONG_PTR): winbool; stdcall;



    PGET_MODULE_HANDLE_EXA = function(
        {_In_        } dwFlags: DWORD;
        {_In_opt_    } lpModuleName: LPCSTR;
        {_Outptr_ } phModule: PHMODULE): winbool; stdcall;


    PGET_MODULE_HANDLE_EXW = function(
        {_In_        } dwFlags: DWORD;
        {_In_opt_    } lpModuleName: LPCWSTR;
        {_Outptr_ } phModule: PHMODULE): winbool; stdcall;



    _REDIRECTION_FUNCTION_DESCRIPTOR = record
        DllName: PCSTR;
        FunctionName: PCSTR;
        RedirectionTarget: PVOID;
    end;
    TREDIRECTION_FUNCTION_DESCRIPTOR = _REDIRECTION_FUNCTION_DESCRIPTOR;
    PREDIRECTION_FUNCTION_DESCRIPTOR = ^TREDIRECTION_FUNCTION_DESCRIPTOR;
    PCREDIRECTION_FUNCTION_DESCRIPTOR = ^TREDIRECTION_FUNCTION_DESCRIPTOR;

    _REDIRECTION_DESCRIPTOR = record
        Version: ULONG;
        FunctionCount: ULONG;
        Redirections: PCREDIRECTION_FUNCTION_DESCRIPTOR;
    end;
    TREDIRECTION_DESCRIPTOR = _REDIRECTION_DESCRIPTOR;
    PREDIRECTION_DESCRIPTOR = ^TREDIRECTION_DESCRIPTOR;
    PCREDIRECTION_DESCRIPTOR = ^TREDIRECTION_DESCRIPTOR;

    TDLL_DIRECTORY_COOKIE = PVOID;
    PDLL_DIRECTORY_COOKIE = ^TDLL_DIRECTORY_COOKIE;



function DisableThreadLibraryCalls(
    {_In_ } hLibModule: HMODULE): winbool; stdcall; external Kernel32_dll;

function FindResourceExW(
    {_In_opt_ } hModule: HMODULE;
    {_In_ } lpType: LPCWSTR;
    {_In_ } lpName: LPCWSTR;
    {_In_ } wLanguage: word): HRSRC; stdcall; external Kernel32_dll;

function FindStringOrdinal(
    {_In_ } dwFindStringOrdinalFlags: DWORD;
    {_In_reads_(cchSource) } lpStringSource: LPCWSTR;
    {_In_ } cchSource: int32;
    {_In_reads_(cchValue) } lpStringValue: LPCWSTR;
    {_In_ } cchValue: int32;
    {_In_ } bIgnoreCase: winbool): int32; stdcall; external Kernel32_dll;

function FreeLibrary(
    {_In_ } hLibModule: HMODULE): winbool; stdcall; external Kernel32_dll;

procedure FreeLibraryAndExitThread(
    {_In_ } hLibModule: HMODULE;
    {_In_ } dwExitCode: DWORD); stdcall; external Kernel32_dll;

function FreeResource(
    {_In_ } hResData: HGLOBAL): winbool; stdcall; external Kernel32_dll;

function GetModuleFileNameA(
    {_In_opt_ } hModule: HMODULE;
    {_Out_writes_to_(nSize,((return < nSize) ? (return + 1) : nSize)) } lpFilename: LPSTR;
    {_In_ } nSize: DWORD): DWORD; stdcall; external Kernel32_dll;

function GetModuleFileNameW(
    {_In_opt_ } hModule: HMODULE;
    {_Out_writes_to_(nSize,((return < nSize) ? (return + 1) : nSize)) } lpFilename: LPWSTR;
    {_In_ } nSize: DWORD): DWORD; stdcall; external Kernel32_dll;

function GetModuleHandleA(
    {_In_opt_ } lpModuleName: LPCSTR): HMODULE; stdcall; external Kernel32_dll;

function GetModuleHandleW(
    {_In_opt_ } lpModuleName: LPCWSTR): HMODULE; stdcall; external Kernel32_dll;

function GetModuleHandleExA(
    {_In_ } dwFlags: DWORD;
    {_In_opt_ } lpModuleName: LPCSTR;
    {_Out_ } phModule: PHMODULE): winbool; stdcall; external Kernel32_dll;

function GetModuleHandleExW(
    {_In_ } dwFlags: DWORD;
    {_In_opt_ } lpModuleName: LPCWSTR;
    {_Out_ } phModule: PHMODULE): winbool; stdcall; external Kernel32_dll;

function GetProcAddress(
    {_In_ } hModule: HMODULE;
    {_In_ } lpProcName: LPCSTR): TFARPROC; stdcall; external Kernel32_dll;

function LoadLibraryExA(
    {_In_ } lpLibFileName: LPCSTR;
    {_Reserved_ } hFile: HANDLE;
    {_In_ } dwFlags: DWORD): HMODULE; stdcall; external Kernel32_dll;

function LoadLibraryExW(
    {_In_ } lpLibFileName: LPCWSTR;
    {_Reserved_ } hFile: HANDLE;
    {_In_ } dwFlags: DWORD): HMODULE; stdcall; external Kernel32_dll;

function LoadResource(
    {_In_opt_ } hModule: HMODULE;
    {_In_ } hResInfo: HRSRC): HGLOBAL; stdcall; external Kernel32_dll;

function LoadStringA(
    {_In_opt_ } hInstance: HINST;
    {_In_ } uID: UINT;
    {_Out_writes_to_(cchBufferMax,return + 1) } lpBuffer: LPSTR;
    {_In_ } cchBufferMax: int32): int32; stdcall; external User32_dll;

function LoadStringW(
    {_In_opt_ } hInstance: HINST;
    {_In_ } uID: UINT;
    {_Out_writes_to_(cchBufferMax,return + 1) } lpBuffer: LPWSTR;
    {_In_ } cchBufferMax: int32): int32; stdcall; external User32_dll;

function LockResource(
    {_In_ } hResData: HGLOBAL): LPVOID; stdcall; external Kernel32_dll;

function SizeofResource(
    {_In_opt_ } hModule: HMODULE;
    {_In_ } hResInfo: HRSRC): DWORD; stdcall; external Kernel32_dll;

function AddDllDirectory(
    {_In_ } NewDirectory: PCWSTR): TDLL_DIRECTORY_COOKIE; stdcall; external Kernel32_dll;

function RemoveDllDirectory(
    {_In_ } Cookie: TDLL_DIRECTORY_COOKIE): winbool; stdcall; external Kernel32_dll;

function SetDefaultDllDirectories(
    {_In_ } DirectoryFlags: DWORD): winbool; stdcall; external Kernel32_dll;

function EnumResourceLanguagesExA(
    {_In_opt_ } hModule: HMODULE;
    {_In_ } lpType: LPCSTR;
    {_In_ } lpName: LPCSTR;
    {_In_ } lpEnumFunc: TENUMRESLANGPROCA;
    {_In_opt_ } lParam: LONG_PTR; dwFlags: DWORD; LangId: LANGID): winbool; stdcall; external Kernel32_dll;

function EnumResourceLanguagesExW(
    {_In_opt_ } hModule: HMODULE;
    {_In_ } lpType: LPCWSTR;
    {_In_ } lpName: LPCWSTR;
    {_In_ } lpEnumFunc: TENUMRESLANGPROCW;
    {_In_opt_ } lParam: LONG_PTR; dwFlags: DWORD; LangId: LANGID): winbool; stdcall; external Kernel32_dll;

function EnumResourceNamesExA(
    {_In_opt_ } hModule: HMODULE;
    {_In_ } lpType: LPCSTR;
    {_In_ } lpEnumFunc: TENUMRESNAMEPROCA;
    {_In_ } lParam: LONG_PTR; dwFlags: DWORD; LangId: LANGID): winbool; stdcall; external Kernel32_dll;

function EnumResourceNamesExW(
    {_In_opt_ } hModule: HMODULE;
    {_In_ } lpType: LPCWSTR;
    {_In_ } lpEnumFunc: TENUMRESNAMEPROCW;
    {_In_ } lParam: LONG_PTR; dwFlags: DWORD; LangId: LANGID): winbool; stdcall; external Kernel32_dll;

function EnumResourceTypesExA(
    {_In_opt_ } hModule: HMODULE;
    {_In_ } lpEnumFunc: TENUMRESTYPEPROCA;
    {_In_ } lParam: LONG_PTR; dwFlags: DWORD; LangId: LANGID): winbool; stdcall; external Kernel32_dll;

function EnumResourceTypesExW(
    {_In_opt_ } hModule: HMODULE;
    {_In_ } lpEnumFunc: TENUMRESTYPEPROCW;
    {_In_ } lParam: LONG_PTR; dwFlags: DWORD; LangId: LANGID): winbool; stdcall; external Kernel32_dll;

function FindResourceW(
    {_In_opt_ } hModule: HMODULE;
    {_In_ } lpName: LPCWSTR;
    {_In_ } lpType: LPCWSTR): HRSRC; stdcall; external Kernel32_dll;

function LoadLibraryA(
    {_In_ } lpLibFileName: LPCSTR): HMODULE; stdcall; external Kernel32_dll;

function LoadLibraryW(
    {_In_ } lpLibFileName: LPCWSTR): HMODULE; stdcall; external Kernel32_dll;

function EnumResourceNamesW(
    {_In_opt_ } hModule: HMODULE;
    {_In_ } lpType: LPCWSTR;
    {_In_ } lpEnumFunc: TENUMRESNAMEPROCW;
    {_In_ } lParam: LONG_PTR): winbool; stdcall; external Kernel32_dll;

function EnumResourceNamesA(
    {_In_opt_ } hModule: HMODULE;
    {_In_ } lpType: LPCSTR;
    {_In_ } lpEnumFunc: TENUMRESNAMEPROCA;
    {_In_ } lParam: LONG_PTR): winbool; stdcall; external Kernel32_dll;



implementation

end.
