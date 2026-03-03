{ **************************************************************************
    FreePascal/Delphi Win32 Header Files

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

   Copyright (c) Microsoft Corporation. All rights reserved.
   Header file for the Performance Data Helper (PDH) DLL functions.

   This unit consists of the following header files
   File name: PDH.H
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit Win32.PDH;

{$mode Delphi}

interface

uses
    Windows, Classes, SysUtils;
    // system include files required for datatype and constant definitions
    // Win32.windows    // necessary for data types used in this file
    // Win32.winperf    // necessary for the Detail Level definitions

    {$DEFINE _WIN32_0x0600}

const
    PDH_DLL = 'Pdh.dll';

    // version info
    PDH_CVERSION_WIN40 = (DWORD($0400));
    PDH_CVERSION_WIN50 = (DWORD($0500));
    // v1.1 revision of PDH -- basic log functions
    // v1.2 of the PDH -- adds variable instance counters
    // v1.3 of the PDH -- adds log service control & stubs for NT5/PDH v2 fn's
    // v2.0 of the PDH -- is the NT v 5.0 B2 version
    PDH_VERSION = (DWORD((PDH_CVERSION_WIN50) + $0003));


    MAX_COUNTER_PATH = 256; // Maximum counter path length. This is an obsolute constance.


    PDH_MAX_COUNTER_NAME = 1024; // Maximum counter name length.
    PDH_MAX_INSTANCE_NAME = 1024; // Maximum counter instance name length.
    PDH_MAX_COUNTER_PATH = 2048; // Maximum full counter path length.
    PDH_MAX_DATASOURCE_PATH = 1024; // MAximum full counter log name length.


    PDH_OBJECT_HAS_INSTANCES = DWORD($00000001);

    INVALID_HANDLE_VALUE = HANDLE(LONG_PTR(-1));
    H_REALTIME_DATASOURCE = 0;  //NULL
    H_WBEM_DATASOURCE = INVALID_HANDLE_VALUE;


    //  Time value constants

    MAX_TIME_VALUE = LONGLONG($7FFFFFFFFFFFFFFF);
    MIN_TIME_VALUE = LONGLONG(0);

    // dwFormat flag values

    PDH_FMT_RAW = DWORD($00000010);
    PDH_FMT_ANSI = DWORD($00000020);
    PDH_FMT_UNICODE = DWORD($00000040);
    PDH_FMT_LONG = DWORD($00000100);
    PDH_FMT_DOUBLE = DWORD($00000200);
    PDH_FMT_LARGE = DWORD($00000400);
    PDH_FMT_NOSCALE = DWORD($00001000);
    PDH_FMT_1000 = DWORD($00002000);
    PDH_FMT_NODATA = DWORD($00004000);
    PDH_FMT_NOCAP100 = DWORD($00008000);
    PERF_DETAIL_COSTLY = DWORD($00010000);
    PERF_DETAIL_STANDARD = DWORD($0000FFFF);

    PDH_MAX_SCALE = (7);
    PDH_MIN_SCALE = (-7);

    PDH_PATH_WBEM_RESULT = DWORD($00000001);
    PDH_PATH_WBEM_INPUT = DWORD($00000002);

    PDH_NOEXPANDCOUNTERS = 1;
    PDH_NOEXPANDINSTANCES = 2;
    PDH_REFRESHCOUNTERS = 4;


    //   Logging Functions


    PDH_LOG_READ_ACCESS = DWORD($00010000);
    PDH_LOG_WRITE_ACCESS = DWORD($00020000);
    PDH_LOG_UPDATE_ACCESS = DWORD($00040000);
    PDH_LOG_ACCESS_MASK = DWORD($000F0000);

    PDH_LOG_CREATE_NEW = DWORD($00000001);
    PDH_LOG_CREATE_ALWAYS = DWORD($00000002);
    PDH_LOG_OPEN_ALWAYS = DWORD($00000003);
    PDH_LOG_OPEN_EXISTING = DWORD($00000004);
    PDH_LOG_CREATE_MASK = DWORD($0000000F);

    PDH_LOG_OPT_USER_STRING = DWORD($01000000);
    PDH_LOG_OPT_CIRCULAR = DWORD($02000000);
    PDH_LOG_OPT_MAX_IS_BYTES = DWORD($04000000);

    PDH_LOG_OPT_APPEND = DWORD($08000000);

    PDH_LOG_OPT_MASK = DWORD($0F000000);

    PDH_LOG_TYPE_UNDEFINED = 0;
    PDH_LOG_TYPE_CSV = 1;
    PDH_LOG_TYPE_TSV = 2;
    PDH_LOG_TYPE_RETIRED_BIN = 3; // Obsolete - not supported.
    PDH_LOG_TYPE_TRACE_KERNEL = 4;
    PDH_LOG_TYPE_TRACE_GENERIC = 5;
    PDH_LOG_TYPE_PERFMON = 6; // Obsolete - not supported.

    PDH_LOG_TYPE_SQL = 7;
    PDH_LOG_TYPE_BINARY = 8;

    PDH_FLAGS_CLOSE_QUERY = DWORD($00000001);

    //  Data source selection dialog

    PDH_FLAGS_FILE_BROWSER_ONLY = DWORD($00000001);


    DATA_SOURCE_REGISTRY = DWORD($00000001);
    DATA_SOURCE_LOGFILE = DWORD($00000002);
    DATA_SOURCE_WBEM = DWORD($00000004);

type
    PZZWSTR = pwidechar;
    PZZSTR = pansichar;


    TPDH_STATUS = LONG;
    PPDH_STATUS = ^TPDH_STATUS;

    // data type definitions

    TPDH_HCOUNTER = HANDLE;
    PPDH_HCOUNTER = ^TPDH_HCOUNTER;

    TPDH_HQUERY = HANDLE;
    PPDH_HQUERY = ^TPDH_HQUERY;

    TPDH_HLOG = HANDLE;
    PPDH_HLOG = ^TPDH_HLOG;

    THCOUNTER = TPDH_HCOUNTER;
    PHCOUNTER = ^THCOUNTER;

    THQUERY = TPDH_HQUERY;
    PHQUERY = ^THQUERY;

    THLOG = TPDH_HLOG;
    PHLOG = ^THLOG;


    _PDH_RAW_COUNTER = record
        CStatus: DWORD;
        TimeStamp: TFILETIME;
        FirstValue: LONGLONG;
        SecondValue: LONGLONG;
        MultiCount: DWORD;
    end;
    TPDH_RAW_COUNTER = _PDH_RAW_COUNTER;
    PPDH_RAW_COUNTER = ^TPDH_RAW_COUNTER;


    _PDH_RAW_COUNTER_ITEM_A = record
        szName: LPSTR;
        RawValue: TPDH_RAW_COUNTER;
    end;
    TPDH_RAW_COUNTER_ITEM_A = _PDH_RAW_COUNTER_ITEM_A;
    PPDH_RAW_COUNTER_ITEM_A = ^TPDH_RAW_COUNTER_ITEM_A;


    _PDH_RAW_COUNTER_ITEM_W = record
        szName: LPWSTR;
        RawValue: TPDH_RAW_COUNTER;
    end;
    TPDH_RAW_COUNTER_ITEM_W = _PDH_RAW_COUNTER_ITEM_W;
    PPDH_RAW_COUNTER_ITEM_W = ^TPDH_RAW_COUNTER_ITEM_W;

    _PDH_FMT_COUNTERVALUE = record
        CStatus: DWORD;
        case integer of
            0: (
                longValue: LONG;
            );
            1: (
                doubleValue: double;
            );
            2: (
                largeValue: LONGLONG;
            );
            3: (
                AnsiStringValue: LPCSTR;
            );
            4: (
                WideStringValue: LPCWSTR;
            );
    end;
    TPDH_FMT_COUNTERVALUE = _PDH_FMT_COUNTERVALUE;
    PPDH_FMT_COUNTERVALUE = ^TPDH_FMT_COUNTERVALUE;


    _PDH_FMT_COUNTERVALUE_ITEM_A = record
        szName: LPSTR;
        FmtValue: TPDH_FMT_COUNTERVALUE;
    end;
    TPDH_FMT_COUNTERVALUE_ITEM_A = _PDH_FMT_COUNTERVALUE_ITEM_A;
    PPDH_FMT_COUNTERVALUE_ITEM_A = ^TPDH_FMT_COUNTERVALUE_ITEM_A;


    _PDH_FMT_COUNTERVALUE_ITEM_W = record
        szName: LPWSTR;
        FmtValue: TPDH_FMT_COUNTERVALUE;
    end;
    TPDH_FMT_COUNTERVALUE_ITEM_W = _PDH_FMT_COUNTERVALUE_ITEM_W;
    PPDH_FMT_COUNTERVALUE_ITEM_W = ^TPDH_FMT_COUNTERVALUE_ITEM_W;


    _PDH_STATISTICS = record
        dwFormat: DWORD;
        Count: DWORD;
        min: TPDH_FMT_COUNTERVALUE;
        max: TPDH_FMT_COUNTERVALUE;
        mean: TPDH_FMT_COUNTERVALUE;
    end;
    TPDH_STATISTICS = _PDH_STATISTICS;
    PPDH_STATISTICS = ^TPDH_STATISTICS;


    _PDH_COUNTER_PATH_ELEMENTS_A = record
        szMachineName: LPSTR;
        szObjectName: LPSTR;
        szInstanceName: LPSTR;
        szParentInstance: LPSTR;
        dwInstanceIndex: DWORD;
        szCounterName: LPSTR;
    end;
    TPDH_COUNTER_PATH_ELEMENTS_A = _PDH_COUNTER_PATH_ELEMENTS_A;
    PPDH_COUNTER_PATH_ELEMENTS_A = ^TPDH_COUNTER_PATH_ELEMENTS_A;


    _PDH_COUNTER_PATH_ELEMENTS_W = record
        szMachineName: LPWSTR;
        szObjectName: LPWSTR;
        szInstanceName: LPWSTR;
        szParentInstance: LPWSTR;
        dwInstanceIndex: DWORD;
        szCounterName: LPWSTR;
    end;
    TPDH_COUNTER_PATH_ELEMENTS_W = _PDH_COUNTER_PATH_ELEMENTS_W;
    PPDH_COUNTER_PATH_ELEMENTS_W = ^TPDH_COUNTER_PATH_ELEMENTS_W;


    _PDH_DATA_ITEM_PATH_ELEMENTS_A = record
        szMachineName: LPSTR;
        ObjectGUID: TGUID;
        dwItemId: DWORD;
        szInstanceName: LPSTR;
    end;
    TPDH_DATA_ITEM_PATH_ELEMENTS_A = _PDH_DATA_ITEM_PATH_ELEMENTS_A;
    PPDH_DATA_ITEM_PATH_ELEMENTS_A = ^TPDH_DATA_ITEM_PATH_ELEMENTS_A;


    _PDH_DATA_ITEM_PATH_ELEMENTS_W = record
        szMachineName: LPWSTR;
        ObjectGUID: TGUID;
        dwItemId: DWORD;
        szInstanceName: LPWSTR;
    end;
    TPDH_DATA_ITEM_PATH_ELEMENTS_W = _PDH_DATA_ITEM_PATH_ELEMENTS_W;
    PPDH_DATA_ITEM_PATH_ELEMENTS_W = ^TPDH_DATA_ITEM_PATH_ELEMENTS_W;


    _PDH_COUNTER_INFO_A = record
        dwLength: DWORD;
        dwType: DWORD;
        CVersion: DWORD;
        CStatus: DWORD;
        lScale: LONG;
        lDefaultScale: LONG;
        dwUserData: DWORD_PTR;
        dwQueryUserData: DWORD_PTR;
        szFullPath: LPSTR;

        case integer of
            0: (
                DataItemPath: TPDH_DATA_ITEM_PATH_ELEMENTS_A;

                szExplainText: LPSTR;
                DataBuffer: PDWORD;
            );
            1: (
                CounterPath: TPDH_COUNTER_PATH_ELEMENTS_A;
            );
            2: (

                szMachineName: LPSTR;
                szObjectName: LPSTR;
                szInstanceName: LPSTR;
                szParentInstance: LPSTR;
                dwInstanceIndex: DWORD;
                szCounterName: LPSTR;
            );

    end;
    TPDH_COUNTER_INFO_A = _PDH_COUNTER_INFO_A;
    PPDH_COUNTER_INFO_A = ^TPDH_COUNTER_INFO_A;


    _PDH_COUNTER_INFO_W = record
        dwLength: DWORD;
        dwType: DWORD;
        CVersion: DWORD;
        CStatus: DWORD;
        lScale: LONG;
        lDefaultScale: LONG;
        dwUserData: DWORD_PTR;
        dwQueryUserData: DWORD_PTR;
        szFullPath: LPWSTR;
        case integer of
            0: (
                DataItemPath: TPDH_DATA_ITEM_PATH_ELEMENTS_W;
                szExplainText: LPWSTR;
                DataBuffer: PDWORD;
            );
            1: (
                CounterPath: TPDH_COUNTER_PATH_ELEMENTS_W;
            );
            2: (
                szMachineName: LPWSTR;
                szObjectName: LPWSTR;
                szInstanceName: LPWSTR;
                szParentInstance: LPWSTR;
                dwInstanceIndex: DWORD;
                szCounterName: LPWSTR;

            );

    end;
    TPDH_COUNTER_INFO_W = _PDH_COUNTER_INFO_W;
    PPDH_COUNTER_INFO_W = ^TPDH_COUNTER_INFO_W;


    _PDH_TIME_INFO = record
        StartTime: LONGLONG;
        EndTime: LONGLONG;
        SampleCount: DWORD;
    end;
    TPDH_TIME_INFO = _PDH_TIME_INFO;
    PPDH_TIME_INFO = ^TPDH_TIME_INFO;


    _PDH_RAW_LOG_RECORD = record
        dwStructureSize: DWORD;
        dwRecordType: DWORD;
        dwItems: DWORD;
        RawBytes: PUCHAR;
    end;
    TPDH_RAW_LOG_RECORD = _PDH_RAW_LOG_RECORD;
    PPDH_RAW_LOG_RECORD = ^TPDH_RAW_LOG_RECORD;


    _PDH_LOG_SERVICE_QUERY_INFO_A = record
        dwSize: DWORD;
        dwFlags: DWORD;
        dwLogQuota: DWORD;
        szLogFileCaption: LPSTR;
        szDefaultDir: LPSTR;
        szBaseFileName: LPSTR;
        dwFileType: DWORD;
        dwReserved: DWORD;

        case integer of
            0: (

                PdlAutoNameInterval: DWORD;
                PdlAutoNameUnits: DWORD;
                PdlCommandFilename: LPSTR;
                PdlCounterList: LPSTR;
                PdlAutoNameFormat: DWORD;
                PdlSampleInterval: DWORD;
                PdlLogStartTime: TFILETIME;
                PdlLogEndTime: TFILETIME;


            );
            1: (

                TlNumberOfBuffers: DWORD;
                TlMinimumBuffers: DWORD;
                TlMaximumBuffers: DWORD;
                TlFreeBuffers: DWORD;
                TlBufferSize: DWORD;
                TlEventsLost: DWORD;
                TlLoggerThreadId: DWORD;
                TlBuffersWritten: DWORD;
                TlLogHandle: DWORD;
                TlLogFileName: LPSTR;


            );

    end;
    TPDH_LOG_SERVICE_QUERY_INFO_A = _PDH_LOG_SERVICE_QUERY_INFO_A;
    PPDH_LOG_SERVICE_QUERY_INFO_A = ^TPDH_LOG_SERVICE_QUERY_INFO_A;


    _PDH_LOG_SERVICE_QUERY_INFO_W = record
        dwSize: DWORD;
        dwFlags: DWORD;
        dwLogQuota: DWORD;
        szLogFileCaption: LPWSTR;
        szDefaultDir: LPWSTR;
        szBaseFileName: LPWSTR;
        dwFileType: DWORD;
        dwReserved: DWORD;

        case integer of
            0: (

                PdlAutoNameInterval: DWORD;
                PdlAutoNameUnits: DWORD;
                PdlCommandFilename: LPWSTR;
                PdlCounterList: LPWSTR;
                PdlAutoNameFormat: DWORD;
                PdlSampleInterval: DWORD;
                PdlLogStartTime: TFILETIME;
                PdlLogEndTime: TFILETIME;

            );
            1: (

                TlNumberOfBuffers: DWORD;
                TlMinimumBuffers: DWORD;
                TlMaximumBuffers: DWORD;
                TlFreeBuffers: DWORD;
                TlBufferSize: DWORD;
                TlEventsLost: DWORD;
                TlLoggerThreadId: DWORD;
                TlBuffersWritten: DWORD;
                TlLogHandle: DWORD;
                TlLogFileName: LPWSTR;

            );

    end;
    TPDH_LOG_SERVICE_QUERY_INFO_W = _PDH_LOG_SERVICE_QUERY_INFO_W;
    PPDH_LOG_SERVICE_QUERY_INFO_W = ^TPDH_LOG_SERVICE_QUERY_INFO_W;


    TCounterPathCallBack = function(Nameless1: DWORD_PTR): TPDH_STATUS; stdcall;


    _BrowseDlgConfig_HW = bitpacked record
        case integer of
            0: (
                // Configuration flags
                bIncludeInstanceIndex: 0..1;
                bSingleCounterPerAdd: 0..1;
                bSingleCounterPerDialog: 0..1;
                bLocalCountersOnly: 0..1;
                bWildCardInstances: 0..1;
                bHideDetailBox: 0..1;
                bInitializePath: 0..1;
                bDisableMachineSelection: 0..1;
                bIncludeCostlyObjects: 0..1;
                bShowObjectBrowser: 0..1;
                bReserved: 0..4194303);
            1: (Flags: DWORD;
                hWndOwner: HWND;
                hDataSource: TPDH_HLOG;
                szReturnPathBuffer: LPWSTR;
                cchReturnPathLength: DWORD;
                pCallBack: TCounterPathCallBack;
                dwCallBackArg: DWORD_PTR;
                CallBackStatus: TPDH_STATUS;
                dwDefaultDetailLevel: DWORD;
                szDialogBoxCaption: LPWSTR);

    end;
    TPDH_BROWSE_DLG_CONFIG_HW = _BrowseDlgConfig_HW;
    PPDH_BROWSE_DLG_CONFIG_HW = ^TPDH_BROWSE_DLG_CONFIG_HW;


    _BrowseDlgConfig_HA = bitpacked record
        case integer of
            0: (
                // Configuration flags
                bIncludeInstanceIndex: 0..1;
                bSingleCounterPerAdd: 0..1;
                bSingleCounterPerDialog: 0..1;
                bLocalCountersOnlybWildCardInstances: 0..1;
                bHideDetailBox: 0..1;
                bInitializePath: 0..1;
                bDisableMachineSelection: 0..1;
                bIncludeCostlyObjects: 0..1;
                bShowObjectBrowser: 0..1;
                bReserved: 0..4194303);
            1: (Flag: DWORD;
                hWndOwner: HWND;
                hDataSource: TPDH_HLOG;
                szReturnPathBuffer: LPSTR;
                cchReturnPathLength: DWORD;
                pCallBack: TCounterPathCallBack;
                dwCallBackArg: DWORD_PTR;
                CallBackStatus: TPDH_STATUS;
                dwDefaultDetailLevel: DWORD;
                szDialogBoxCaption: LPSTR;);


    end;
    TPDH_BROWSE_DLG_CONFIG_HA = _BrowseDlgConfig_HA;
    PPDH_BROWSE_DLG_CONFIG_HA = ^TPDH_BROWSE_DLG_CONFIG_HA;


    _BrowseDlgConfig_W = bitpacked record
        case integer of
            0: (
                // Configuration flags
                bIncludeInstanceIndex: 0..1;
                bSingleCounterPerAdd: 0..1;
                bSingleCounterPerDialog: 0..1;
                bLocalCountersOnly: 0..1;
                bWildCardInstances: 0..1;
                bHideDetailBox: 0..1;
                bInitializePath: 0..1;
                bDisableMachineSelection: 0..1;
                bIncludeCostlyObjects: 0..1;
                bShowObjectBrowserbReserved: 0..4194303);
            1: (flags: DWORD;
                hWndOwner: HWND;
                szDataSource: LPWSTR;
                szReturnPathBuffer: LPWSTR;
                cchReturnPathLength: DWORD;
                pCallBack: TCounterPathCallBack;
                dwCallBackArg: DWORD_PTR;
                CallBackStatus: TPDH_STATUS;
                dwDefaultDetailLevel: DWORD;
                szDialogBoxCaption: LPWSTR);
    end;

    TPDH_BROWSE_DLG_CONFIG_W = _BrowseDlgConfig_W;
    PPDH_BROWSE_DLG_CONFIG_W = ^TPDH_BROWSE_DLG_CONFIG_W;


    _BrowseDlgConfig_A = bitpacked record
        case integer of
            0: (
                // Configuration flags
                bIncludeInstanceIndex: 0..1;
                bSingleCounterPerAdd: 0..1;
                bSingleCounterPerDialog: 0..1;
                bLocalCountersOnly: 0..1;
                bWildCardInstances: 0..1;
                bHideDetailBox: 0..1;
                bInitializePath: 0..1;
                bDisableMachineSelection: 0..1;
                bIncludeCostlyObjects: 0..1;
                bShowObjectBrowser: 0..1;
                bReserved: 0..4194303
            );
            1: (flags: DWORD;
                hWndOwner: HWND;
                szDataSource: LPSTR;
                {_Field_size_(cchReturnPathLength) } szReturnPathBuffer: LPSTR;
                cchReturnPathLength: DWORD;
                pCallBack: TCounterPathCallBack;
                dwCallBackArg: DWORD_PTR;
                CallBackStatus: TPDH_STATUS;
                dwDefaultDetailLevel: DWORD;
                szDialogBoxCaption: LPSTR);
    end;
    TPDH_BROWSE_DLG_CONFIG_A = _BrowseDlgConfig_A;
    PPDH_BROWSE_DLG_CONFIG_A = ^TPDH_BROWSE_DLG_CONFIG_A;


    // function definitions

function PdhGetDllVersion(
    {_Out_opt_ } lpdwVersion: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


//  Query Functions


function PdhOpenQueryW(
    {_In_opt_ } szDataSource: LPCWSTR;
    {_In_     } dwUserData: DWORD_PTR;
    {_Out_    } phQuery: PPDH_HQUERY): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhOpenQueryA(
    {_In_opt_ } szDataSource: LPCSTR;
    {_In_     } dwUserData: DWORD_PTR;
    {_Out_    } phQuery: PPDH_HQUERY): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhAddCounterW(
    {_In_  } hQuery: TPDH_HQUERY;
    {_In_  } szFullCounterPath: LPCWSTR;
    {_In_  } dwUserData: DWORD_PTR;
    {_Out_ } phCounter: PPDH_HCOUNTER): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhAddCounterA(
    {_In_  } hQuery: TPDH_HQUERY;
    {_In_  } szFullCounterPath: LPCSTR;
    {_In_  } dwUserData: DWORD_PTR;
    {_Out_ } phCounter: PPDH_HCOUNTER): TPDH_STATUS; stdcall; external PDH_DLL;

{$IFDEF  _WIN32_0x0600}

function PdhAddEnglishCounterW(
    {_In_  } hQuery: TPDH_HQUERY;
    {_In_  } szFullCounterPath: LPCWSTR;
    {_In_  } dwUserData: DWORD_PTR;
    {_Out_ } phCounter: PPDH_HCOUNTER): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhAddEnglishCounterA(
    {_In_  } hQuery: TPDH_HQUERY;
    {_In_  } szFullCounterPath: LPCSTR;
    {_In_  } dwUserData: DWORD_PTR;
    {_Out_ } phCounter: PPDH_HCOUNTER): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhCollectQueryDataWithTime(
    {_Inout_ } hQuery: TPDH_HQUERY;
    {_Out_   } pllTimeStamp: PLONGLONG): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhValidatePathExW(
    {_In_opt_ } hDataSource: TPDH_HLOG;
    {_In_     } szFullPathBuffer: LPCWSTR): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhValidatePathExA(
    {_In_opt_ } hDataSource: TPDH_HLOG;
    {_In_     } szFullPathBuffer: LPCSTR): TPDH_STATUS; stdcall; external PDH_DLL;

{$ENDIF}


function PdhRemoveCounter(
    {_In_ } hCounter: TPDH_HCOUNTER): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhCollectQueryData(
    {_Inout_ } hQuery: TPDH_HQUERY): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhCloseQuery(
    {_Inout_ } hQuery: TPDH_HQUERY): TPDH_STATUS; stdcall; external PDH_DLL;


//  Counter Functions


function PdhGetFormattedCounterValue(
    {_In_      } hCounter: TPDH_HCOUNTER;
    {_In_      } dwFormat: DWORD;
    {_Out_opt_ } lpdwType: LPDWORD;
    {_Out_     } pValue: PPDH_FMT_COUNTERVALUE): TPDH_STATUS; stdcall; external PDH_DLL;


{_Success_(return == ERROR_SUCCESS)}
function PdhGetFormattedCounterArrayA(
    {_In_    } hCounter: TPDH_HCOUNTER;
    {_In_    } dwFormat: DWORD;
    {_Inout_ } lpdwBufferSize: LPDWORD;
    {_Out_   } lpdwItemCount: LPDWORD;
    {_Out_writes_bytes_opt_(* lpdwBufferSize) } ItemBuffer: PPDH_FMT_COUNTERVALUE_ITEM_A): TPDH_STATUS; stdcall; external PDH_DLL;


{_Success_(return == ERROR_SUCCESS)}
function PdhGetFormattedCounterArrayW(
    {_In_    } hCounter: TPDH_HCOUNTER;
    {_In_    } dwFormat: DWORD;
    {_Inout_ } lpdwBufferSize: LPDWORD;
    {_Out_   } lpdwItemCount: LPDWORD;
    {_Out_writes_bytes_opt_(* lpdwBufferSize) } ItemBuffer: PPDH_FMT_COUNTERVALUE_ITEM_W): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhGetRawCounterValue(
    {_In_      } hCounter: TPDH_HCOUNTER;
    {_Out_opt_ } lpdwType: LPDWORD;
    {_Out_     } pValue: PPDH_RAW_COUNTER): TPDH_STATUS; stdcall; external PDH_DLL;


{_Success_(return == ERROR_SUCCESS)}
function PdhGetRawCounterArrayA(
    {_In_    } hCounter: TPDH_HCOUNTER;
    {_Inout_ } lpdwBufferSize: LPDWORD;
    {_Out_   } lpdwItemCount: LPDWORD;
    {_Out_writes_bytes_opt_(* lpdwBufferSize) } ItemBuffer: PPDH_RAW_COUNTER_ITEM_A): TPDH_STATUS; stdcall; external PDH_DLL;


{_Success_(return == ERROR_SUCCESS)}
function PdhGetRawCounterArrayW(
    {_In_    } hCounter: TPDH_HCOUNTER;
    {_Inout_ } lpdwBufferSize: LPDWORD;
    {_Out_   } lpdwItemCount: LPDWORD;
    {_Out_writes_bytes_opt_(* lpdwBufferSize) } ItemBuffer: PPDH_RAW_COUNTER_ITEM_W): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhCalculateCounterFromRawValue(
    {_In_  } hCounter: TPDH_HCOUNTER;
    {_In_  } dwFormat: DWORD;
    {_In_  } rawValue1: PPDH_RAW_COUNTER;
    {_In_  } rawValue2: PPDH_RAW_COUNTER;
    {_Out_ } fmtValue: PPDH_FMT_COUNTERVALUE): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhComputeCounterStatistics(
    {_In_  } hCounter: TPDH_HCOUNTER;
    {_In_  } dwFormat: DWORD;
    {_In_  } dwFirstEntry: DWORD;
    {_In_  } dwNumEntries: DWORD;
    {_In_  } lpRawValueArray: PPDH_RAW_COUNTER;
    {_Out_ } Data: PPDH_STATISTICS): TPDH_STATUS; stdcall; external PDH_DLL;


{_Success_(return == ERROR_SUCCESS)}
function PdhGetCounterInfoW(
    {_In_    } hCounter: TPDH_HCOUNTER;
    {_In_    } bRetrieveExplainText: winbool;
    {_Inout_ } pdwBufferSize: LPDWORD;
    {_Out_writes_bytes_opt_(* pdwBufferSize) } lpBuffer: PPDH_COUNTER_INFO_W): TPDH_STATUS; stdcall; external PDH_DLL;


{_Success_(return == ERROR_SUCCESS)}
function PdhGetCounterInfoA(
    {_In_    } hCounter: TPDH_HCOUNTER;
    {_In_    } bRetrieveExplainText: winbool;
    {_Inout_ } pdwBufferSize: LPDWORD;
    {_Out_writes_bytes_opt_(* pdwBufferSize) } lpBuffer: PPDH_COUNTER_INFO_A): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhSetCounterScaleFactor(
    {_Inout_ } hCounter: TPDH_HCOUNTER;
    {_In_    } lFactor: LONG): TPDH_STATUS; stdcall; external PDH_DLL;


//   Browsing and enumeration functions

function PdhConnectMachineW(
    {_In_opt_ } szMachineName: LPCWSTR): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhConnectMachineA(
    {_In_opt_ } szMachineName: LPCSTR): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhEnumMachinesW(
    {_In_opt_ } szDataSource: LPCWSTR;
    {_Out_writes_opt_(* pcchBufferSize) } mszMachineList: PZZWSTR;
    {_Inout_ } pcchBufferSize: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhEnumMachinesA(
    {_In_opt_ } szDataSource: LPCSTR;
    {_Out_writes_opt_(* pcchBufferSize) } mszMachineList: PZZSTR;
    {_Inout_ } pcchBufferSize: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhEnumObjectsW(
    {_In_opt_ } szDataSource: LPCWSTR;
    {_In_opt_ } szMachineName: LPCWSTR;
    {_Out_writes_opt_(* pcchBufferSize) } mszObjectList: PZZWSTR;
    {_Inout_  } pcchBufferSize: LPDWORD;
    {_In_     } dwDetailLevel: DWORD;
    {_In_     } bRefresh: boolean): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhEnumObjectsA(
    {_In_opt_ } szDataSource: LPCSTR;
    {_In_opt_ } szMachineName: LPCSTR;
    {_Out_writes_opt_(* pcchBufferSize) } mszObjectList: PZZSTR;
    {_Inout_  } pcchBufferSize: LPDWORD;
    {_In_     } dwDetailLevel: DWORD;
    {_In_     } bRefresh: boolean): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhEnumObjectItemsW(
    {_In_opt_ } szDataSource: LPCWSTR;
    {_In_opt_ } szMachineName: LPCWSTR;
    {_In_     } szObjectName: LPCWSTR;
    {_Out_writes_opt_(* pcchCounterListLength) } mszCounterList: PZZWSTR;
    {_Inout_  } pcchCounterListLength: LPDWORD;
    {_Out_writes_opt_(* pcchInstanceListLength) } mszInstanceList: PZZWSTR;
    {_Inout_  } pcchInstanceListLength: LPDWORD;
    {_In_     } dwDetailLevel: DWORD;
    {_In_     } dwFlags: DWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhEnumObjectItemsA(
    {_In_opt_ } szDataSource: LPCSTR;
    {_In_opt_ } szMachineName: LPCSTR;
    {_In_     } szObjectName: LPCSTR;
    {_Out_writes_opt_(* pcchCounterListLength) } mszCounterList: PZZSTR;
    {_Inout_  } pcchCounterListLength: LPDWORD;
    {_Out_writes_opt_(* pcchInstanceListLength) } mszInstanceList: PZZSTR;
    {_Inout_  } pcchInstanceListLength: LPDWORD;
    {_In_     } dwDetailLevel: DWORD;
    {_In_     } dwFlags: DWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhMakeCounterPathW(
    {_In_    } pCounterPathElements: PPDH_COUNTER_PATH_ELEMENTS_W;
    {_Out_writes_opt_(* pcchBufferSize)   } szFullPathBuffer: LPWSTR;
    {_Inout_ } pcchBufferSize: LPDWORD;
    {_In_    } dwFlags: DWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhMakeCounterPathA(
    {_In_    } pCounterPathElements: PPDH_COUNTER_PATH_ELEMENTS_A;
    {_Out_writes_opt_(* pcchBufferSize)   } szFullPathBuffer: LPSTR;
    {_Inout_ } pcchBufferSize: LPDWORD;
    {_In_    } dwFlags: DWORD): TPDH_STATUS; stdcall; external PDH_DLL;


{_Success_(return == ERROR_SUCCESS)}
function PdhParseCounterPathW(
    {_In_    } szFullPathBuffer: LPCWSTR;
    {_Out_writes_bytes_opt_(* pdwBufferSize) } pCounterPathElements: PPDH_COUNTER_PATH_ELEMENTS_W;
    {_Inout_ } pdwBufferSize: LPDWORD;
    {_In_    } dwFlags: DWORD): TPDH_STATUS; stdcall; external PDH_DLL;

{_Success_(return == ERROR_SUCCESS)}
function PdhParseCounterPathA(
    {_In_    } szFullPathBuffer: LPCSTR;
    {_Out_writes_bytes_opt_(* pdwBufferSize) } pCounterPathElements: PPDH_COUNTER_PATH_ELEMENTS_A;
    {_Inout_ } pdwBufferSize: LPDWORD;
    {_In_    } dwFlags: DWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhParseInstanceNameW(
    {_In_    } szInstanceString: LPCWSTR;
    {_Out_writes_opt_(* pcchInstanceNameLength) } szInstanceName: LPWSTR;
    {_Inout_ } pcchInstanceNameLength: LPDWORD;
    {_Out_writes_opt_(* pcchParentNameLength)   } szParentName: LPWSTR;
    {_Inout_ } pcchParentNameLength: LPDWORD;
    {_Out_   } lpIndex: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhParseInstanceNameA(
    {_In_    } szInstanceString: LPCSTR;
    {_Out_writes_opt_(* pcchInstanceNameLength) } szInstanceName: LPSTR;
    {_Inout_ } pcchInstanceNameLength: LPDWORD;
    {_Out_writes_opt_(* pcchParentNameLength)   } szParentName: LPSTR;
    {_Inout_ } pcchParentNameLength: LPDWORD;
    {_Out_   } lpIndex: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhValidatePathW(
    {_In_ } szFullPathBuffer: LPCWSTR): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhValidatePathA(
    {_In_ } szFullPathBuffer: LPCSTR): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhGetDefaultPerfObjectW(
    {_In_opt_ } szDataSource: LPCWSTR;
    {_In_opt_ } szMachineName: LPCWSTR;
    {_Out_writes_opt_(* pcchBufferSize) } szDefaultObjectName: LPWSTR;
    {_Inout_  } pcchBufferSize: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhGetDefaultPerfObjectA(
    {_In_opt_ } szDataSource: LPCSTR;
    {_In_opt_ } szMachineName: LPCSTR;
    {_Out_writes_opt_(* pcchBufferSize) } szDefaultObjectName: LPSTR;
    {_Inout_  } pcchBufferSize: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhGetDefaultPerfCounterW(
    {_In_opt_ } szDataSource: LPCWSTR;
    {_In_opt_ } szMachineName: LPCWSTR;
    {_In_     } szObjectName: LPCWSTR;
    {_Out_writes_opt_(* pcchBufferSize) } szDefaultCounterName: LPWSTR;
    {_Inout_  } pcchBufferSize: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhGetDefaultPerfCounterA(
    {_In_opt_ } szDataSource: LPCSTR;
    {_In_opt_ } szMachineName: LPCSTR;
    {_In_     } szObjectName: LPCSTR;
    {_Out_writes_opt_(* pcchBufferSize) } szDefaultCounterName: LPSTR;
    {_Inout_  } pcchBufferSize: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhBrowseCountersW(
    {_In_ } pBrowseDlgData: PPDH_BROWSE_DLG_CONFIG_W): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhBrowseCountersA(
    {_In_ } pBrowseDlgData: PPDH_BROWSE_DLG_CONFIG_A): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhExpandCounterPathW(
    {_In_    } szWildCardPath: LPCWSTR;
    {_Out_writes_opt_(* pcchPathListLength) } mszExpandedPathList: PZZWSTR;
    {_Inout_ } pcchPathListLength: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhExpandCounterPathA(
    {_In_    } szWildCardPath: LPCSTR;
    {_Out_writes_opt_(* pcchPathListLength) } mszExpandedPathList: PZZSTR;
    {_Inout_ } pcchPathListLength: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


//  v2.0 functions

function PdhLookupPerfNameByIndexW(
    {_In_opt_ } szMachineName: LPCWSTR;
    {_In_     } dwNameIndex: DWORD;
    {_Out_writes_opt_(* pcchNameBufferSize) } szNameBuffer: LPWSTR;
    {_Inout_  } pcchNameBufferSize: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhLookupPerfNameByIndexA(
    {_In_opt_ } szMachineName: LPCSTR;
    {_In_     } dwNameIndex: DWORD;
    {_Out_writes_opt_(* pcchNameBufferSize) } szNameBuffer: LPSTR;
    {_Inout_  } pcchNameBufferSize: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhLookupPerfIndexByNameW(
    {_In_opt_ } szMachineName: LPCWSTR;
    {_In_     } szNameBuffer: LPCWSTR;
    {_Out_    } pdwIndex: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhLookupPerfIndexByNameA(
    {_In_opt_ } szMachineName: LPCSTR;
    {_In_     } szNameBuffer: LPCSTR;
    {_Out_    } pdwIndex: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhExpandWildCardPathA(
    {_In_opt_ } szDataSource: LPCSTR;
    {_In_     } szWildCardPath: LPCSTR;
    {_Out_writes_opt_(* pcchPathListLength) } mszExpandedPathList: PZZSTR;
    {_Inout_  } pcchPathListLength: LPDWORD;
    {_In_     } dwFlags: DWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhExpandWildCardPathW(
    {_In_opt_ } szDataSource: LPCWSTR;
    {_In_     } szWildCardPath: LPCWSTR;
    {_Out_writes_opt_(* pcchPathListLength) } mszExpandedPathList: PZZWSTR;
    {_Inout_  } pcchPathListLength: LPDWORD;
    {_In_     } dwFlags: DWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhOpenLogW(
    {_In_     } szLogFileName: LPCWSTR;
    {_In_     } dwAccessFlags: DWORD;
    {_Inout_  } lpdwLogType: LPDWORD;
    {_In_opt_ } hQuery: TPDH_HQUERY;
    {_In_     } dwMaxSize: DWORD;
    {_In_opt_ } szUserCaption: LPCWSTR;
    {_Out_    } phLog: PPDH_HLOG): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhOpenLogA(
    {_In_     } szLogFileName: LPCSTR;
    {_In_     } dwAccessFlags: DWORD;
    {_Inout_  } lpdwLogType: LPDWORD;
    {_In_opt_ } hQuery: TPDH_HQUERY;
    {_In_     } dwMaxSize: DWORD;
    {_In_opt_ } szUserCaption: LPCSTR;
    {_Out_    } phLog: PPDH_HLOG): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhUpdateLogW(
    {_In_     } hLog: TPDH_HLOG;
    {_In_opt_ } szUserString: LPCWSTR): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhUpdateLogA(
    {_In_     } hLog: TPDH_HLOG;
    {_In_opt_ } szUserString: LPCSTR): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhUpdateLogFileCatalog(
    {_In_ } hLog: TPDH_HLOG): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhGetLogFileSize(
    {_In_  } hLog: TPDH_HLOG;
    {_Out_ } llSize: PLONGLONG): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhCloseLog(
    {_In_ } hLog: TPDH_HLOG;
    {_In_ } dwFlags: DWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhSelectDataSourceW(
    {_In_    } hWndOwner: HWND;
    {_In_    } dwFlags: DWORD;
    {_Inout_updates_(* pcchBufferLength) } szDataSource: LPWSTR;
    {_Inout_ } pcchBufferLength: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhSelectDataSourceA(
    {_In_    } hWndOwner: HWND;
    {_In_    } dwFlags: DWORD;
    {_Inout_updates_(* pcchBufferLength) } szDataSource: LPSTR;
    {_Inout_ } pcchBufferLength: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhIsRealTimeQuery(
    {_In_ } hQuery: TPDH_HQUERY): boolean; stdcall; external PDH_DLL;


function PdhSetQueryTimeRange(
    {_In_ } hQuery: TPDH_HQUERY;
    {_In_ } pInfo: PPDH_TIME_INFO): TPDH_STATUS; stdcall; external PDH_DLL;


{_Success_(return == ERROR_SUCCESS)}
function PdhGetDataSourceTimeRangeW(
    {_In_opt_ } szDataSource: LPCWSTR;
    {_Out_    } pdwNumEntries: LPDWORD;
    {_Out_writes_bytes_(* pdwBufferSize)    } pInfo: PPDH_TIME_INFO;
    {_Inout_  } pdwBufferSize: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


{_Success_(return == ERROR_SUCCESS)}
function PdhGetDataSourceTimeRangeA(
    {_In_opt_ } szDataSource: LPCSTR;
    {_Out_    } pdwNumEntries: LPDWORD;
    {_Out_writes_bytes_(* pdwBufferSize) } pInfo: PPDH_TIME_INFO;
    {_Inout_  } pdwBufferSize: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhCollectQueryDataEx(
    {_In_ } hQuery: TPDH_HQUERY;
    {_In_ } dwIntervalTime: DWORD;
    {_In_ } hNewDataEvent: HANDLE): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhFormatFromRawValue(
    {_In_  } dwCounterType: DWORD;
    {_In_  } dwFormat: DWORD;
    {_In_opt_ } pTimeBase: PLONGLONG;
    {_In_  } pRawValue1: PPDH_RAW_COUNTER;
    {_In_  } pRawValue2: PPDH_RAW_COUNTER;
    {_Out_ } pFmtValue: PPDH_FMT_COUNTERVALUE): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhGetCounterTimeBase(
    {_In_  } hCounter: TPDH_HCOUNTER;
    {_Out_ } pTimeBase: PLONGLONG): TPDH_STATUS; stdcall; external PDH_DLL;


{_Success_(return == ERROR_SUCCESS)}
function PdhReadRawLogRecord(
    {_In_    } hLog: TPDH_HLOG;
    {_In_    } ftRecord: TFILETIME;
    {_Out_writes_bytes_opt_(* pdwBufferLength) } pRawLogRecord: PPDH_RAW_LOG_RECORD;
    {_Inout_ } pdwBufferLength: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhSetDefaultRealTimeDataSource(
    {_In_ } dwDataSourceId: DWORD): TPDH_STATUS; stdcall; external PDH_DLL;


//{$IFDEF  (_WIN32_WINDOWS >= 0x0501 || _WIN32_WINNT >= 0x0501 || (defined(NTDDI_VERSION) && NTDDI_VERSION >= NTDDI_WINXP))
// Extended API for WMI event trace logfile format

function PdhBindInputDataSourceW(
    {_Out_    } phDataSource: PPDH_HLOG;
    {_In_opt_ } LogFileNameList: LPCWSTR): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhBindInputDataSourceA(
    {_Out_    } phDataSource: PPDH_HLOG;
    {_In_opt_ } LogFileNameList: LPCSTR): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhOpenQueryH(
    {_In_opt_  } hDataSource: TPDH_HLOG;
    {_In_      } dwUserData: DWORD_PTR;
    {_Out_     } phQuery: PPDH_HQUERY): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhEnumMachinesHW(
    {_In_opt_ } hDataSource: TPDH_HLOG;
    {_Out_writes_opt_(* pcchBufferSize) } mszMachineList: PZZWSTR;
    {_Inout_  } pcchBufferSize: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhEnumMachinesHA(
    {_In_opt_ } hDataSource: TPDH_HLOG;
    {_Out_writes_opt_(* pcchBufferSize) } mszMachineList: PZZSTR;
    {_Inout_  } pcchBufferSize: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhEnumObjectsHW(
    {_In_opt_ } hDataSource: TPDH_HLOG;
    {_In_opt_ } szMachineName: LPCWSTR;
    {_Out_writes_opt_(* pcchBufferSize) } mszObjectList: PZZWSTR;
    {_Inout_  } pcchBufferSize: LPDWORD;
    {_In_     } dwDetailLevel: DWORD;
    {_In_     } bRefresh: boolean): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhEnumObjectsHA(
    {_In_opt_ } hDataSource: TPDH_HLOG;
    {_In_opt_ } szMachineName: LPCSTR;
    {_Out_writes_opt_(* pcchBufferSize) } mszObjectList: PZZSTR;
    {_Inout_  } pcchBufferSize: LPDWORD;
    {_In_     } dwDetailLevel: DWORD;
    {_In_     } bRefresh: boolean): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhEnumObjectItemsHW(
    {_In_opt_ } hDataSource: TPDH_HLOG;
    {_In_opt_ } szMachineName: LPCWSTR;
    {_In_     } szObjectName: LPCWSTR;
    {_Out_writes_opt_(* pcchCounterListLength) } mszCounterList: PZZWSTR;
    {_Inout_  } pcchCounterListLength: LPDWORD;
    {_Out_writes_opt_(* pcchInstanceListLength) } mszInstanceList: PZZWSTR;
    {_Inout_  } pcchInstanceListLength: LPDWORD;
    {_In_     } dwDetailLevel: DWORD;
    {_In_     } dwFlags: DWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhEnumObjectItemsHA(
    {_In_opt_ } hDataSource: TPDH_HLOG;
    {_In_opt_ } szMachineName: LPCSTR;
    {_In_     } szObjectName: LPCSTR;
    {_Out_writes_opt_(* pcchCounterListLength) } mszCounterList: PZZSTR;
    {_Inout_  } pcchCounterListLength: LPDWORD;
    {_Out_writes_opt_(* pcchInstanceListLength) } mszInstanceList: PZZSTR;
    {_Inout_  } pcchInstanceListLength: LPDWORD;
    {_In_     } dwDetailLevel: DWORD;
    {_In_     } dwFlags: DWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhExpandWildCardPathHW(
    {_In_opt_ } hDataSource: TPDH_HLOG;
    {_In_     } szWildCardPath: LPCWSTR;
    {_Out_writes_opt_(* pcchPathListLength) } mszExpandedPathList: PZZWSTR;
    {_Inout_  } pcchPathListLength: LPDWORD;
    {_In_    } dwFlags: DWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhExpandWildCardPathHA(
    {_In_opt_ } hDataSource: TPDH_HLOG;
    {_In_     } szWildCardPath: LPCSTR;
    {_Out_writes_opt_(* pcchPathListLength) } mszExpandedPathList: PZZSTR;
    {_Inout_  } pcchPathListLength: LPDWORD;
    {_In_    } dwFlags: DWORD): TPDH_STATUS; stdcall; external PDH_DLL;


//{_Success_(return == ERROR_SUCCESS)}
function PdhGetDataSourceTimeRangeH(
    {_Inout_opt_ } hDataSource: TPDH_HLOG;
    {_Out_       } pdwNumEntries: LPDWORD;
    {_Out_writes_bytes_(* pdwBufferSize) } pInfo: PPDH_TIME_INFO;
    {_Inout_  } pdwBufferSize: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhGetDefaultPerfObjectHW(
    {_In_opt_ } hDataSource: TPDH_HLOG;
    {_In_opt_ } szMachineName: LPCWSTR;
    {_Out_writes_opt_(* pcchBufferSize) } szDefaultObjectName: LPWSTR;
    {_Inout_  } pcchBufferSize: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhGetDefaultPerfObjectHA(
    {_In_opt_ } hDataSource: TPDH_HLOG;
    {_In_opt_ } szMachineName: LPCSTR;
    {_Out_writes_opt_(* pcchBufferSize) } szDefaultObjectName: LPSTR;
    {_Inout_  } pcchBufferSize: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhGetDefaultPerfCounterHW(
    {_In_opt_ } hDataSource: TPDH_HLOG;
    {_In_opt_ } szMachineName: LPCWSTR;
    {_In_     } szObjectName: LPCWSTR;
    {_Out_writes_opt_(* pcchBufferSize) } szDefaultCounterName: LPWSTR;
    {_Inout_  } pcchBufferSize: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhGetDefaultPerfCounterHA(
    {_In_opt_ } hDataSource: TPDH_HLOG;
    {_In_opt_ } szMachineName: LPCSTR;
    {_In_     } szObjectName: LPCSTR;
    {_Out_writes_opt_(* pcchBufferSize) } szDefaultCounterName: LPSTR;
    {_Inout_  } pcchBufferSize: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhBrowseCountersHW(
    {_In_ } pBrowseDlgData: PPDH_BROWSE_DLG_CONFIG_HW): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhBrowseCountersHA(
    {_In_ } pBrowseDlgData: PPDH_BROWSE_DLG_CONFIG_HA): TPDH_STATUS; stdcall; external PDH_DLL;


//Check that a DSN points to a database that contains the correct Perfmon tables.
function PdhVerifySQLDBW(
    {_In_ } szDataSource: LPCWSTR): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhVerifySQLDBA(
    {_In_ } szDataSource: LPCSTR): TPDH_STATUS; stdcall; external PDH_DLL;


//Create the correct perfmon tables in the database pointed to by a DSN.
function PdhCreateSQLTablesW(
    {_In_ } szDataSource: LPCWSTR): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhCreateSQLTablesA(
    {_In_ } szDataSource: LPCSTR): TPDH_STATUS; stdcall; external PDH_DLL;


//Return the list of Log set names in the database pointed to by the DSN.
function PdhEnumLogSetNamesW(
    {_In_    } szDataSource: LPCWSTR;
    {_Out_writes_opt_(* pcchBufferLength) } mszDataSetNameList: PZZWSTR;
    {_Inout_ } pcchBufferLength: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


function PdhEnumLogSetNamesA(
    {_In_    } szDataSource: LPCSTR;
    {_Out_writes_opt_(* pcchBufferLength) } mszDataSetNameList: PZZSTR;
    {_Inout_ } pcchBufferLength: LPDWORD): TPDH_STATUS; stdcall; external PDH_DLL;


//Retrieve the GUID for an open Log Set
function PdhGetLogSetGUID(
    {_In_      } hLog: TPDH_HLOG;
    {_Out_opt_ } pGuid: PGUID;
    {_Out_opt_ } pRunId: PINT32): TPDH_STATUS; stdcall; external PDH_DLL;


//Set the RunID for an open Log Set
function PdhSetLogSetRunID(
    {_Inout_ } hLog: TPDH_HLOG;
    {_In_    } RunId: int32): TPDH_STATUS; stdcall; external PDH_DLL;


function PDH_PATH_LANG_FLAGS(LangId, Flags: DWORD): DWORD;

// define severity masks
function IsSuccessSeverity(ErrorCode: DWORD): boolean;
function IsInformationalSeverity(ErrorCode: DWORD): boolean;
function IsWarningSeverity(ErrorCode: DWORD): boolean;
function IsErrorSeverity(ErrorCode: DWORD): boolean;

implementation



function PDH_PATH_LANG_FLAGS(LangId, Flags: DWORD): DWORD;
begin
    Result := DWORD(((LangId and $0000FFFF) shl 16) or (Flags and $0000FFFF));
end;


// define severity masks
function IsSuccessSeverity(ErrorCode: DWORD): boolean;
begin
    Result := DWORD(ErrorCode and $C0000000) = $00000000;
end;



function IsInformationalSeverity(ErrorCode: DWORD): boolean;
begin
    Result := DWORD(ErrorCode and $C0000000) = $40000000;
end;



function IsWarningSeverity(ErrorCode: DWORD): boolean;
begin
    Result := DWORD(ErrorCode and $C0000000) = $80000000;
end;



function IsErrorSeverity(ErrorCode: DWORD): boolean;
begin
    Result := DWORD(ErrorCode and $C0000000) = $C0000000;
end;

end.
