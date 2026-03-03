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
   File name:  dxgidebug.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.DXGIDebug;


{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils;

    {$Z4}

const
    DXGIDebug_DLL = 'Dxgidebug.dll';

    IID_IDXGIInfoQueue: TGUID = '{D67441C7-672A-476F-9E82-CD55B44949CE}';
    IID_IDXGIDebug: TGUID = '{119E7452-DE9E-40FE-8806-88F90C12B441}';
    IID_IDXGIDebug1: TGUID = '{C5A05F0C-16F2-4ADF-9F4D-A8C4D58AC550}';

    DXGI_DEBUG_BINARY_VERSION = (1);

    DXGI_DEBUG_ALL: TGUID = '{E48AE283-DA80-490B-87E6-43E9A9CFDA08}';
    DXGI_DEBUG_DX: TGUID = '{35CDD7FC-13B2-421D-A5D7-7E4451287D64}';
    DXGI_DEBUG_DXGI: TGUID = '{25CDDAA4-B1C6-47E1-AC3E-98875B5A2E2A}';
    DXGI_DEBUG_APP: TGUID = '{06CD6E01-4219-4EBD-8709-27ED23360C62}';


    DXGI_INFO_QUEUE_MESSAGE_ID_STRING_FROM_APPLICATION = 0;

    DXGI_INFO_QUEUE_DEFAULT_MESSAGE_COUNT_LIMIT = 1024;


type
   REFIID = ^TGUID;

    (* Forward Declarations *)


    IDXGIInfoQueue = interface;


    IDXGIDebug = interface;


    IDXGIDebug1 = interface;


    TDXGI_DEBUG_RLO_FLAGS = (
        DXGI_DEBUG_RLO_SUMMARY = $1,
        DXGI_DEBUG_RLO_DETAIL = $2,
        DXGI_DEBUG_RLO_IGNORE_INTERNAL = $4,
        DXGI_DEBUG_RLO_ALL = $7);

    PDXGI_DEBUG_RLO_FLAGS = ^TDXGI_DEBUG_RLO_FLAGS;


    TDXGI_DEBUG_ID = TGUID;


    TDXGI_INFO_QUEUE_MESSAGE_CATEGORY = (
        DXGI_INFO_QUEUE_MESSAGE_CATEGORY_UNKNOWN = 0,
        DXGI_INFO_QUEUE_MESSAGE_CATEGORY_MISCELLANEOUS = (DXGI_INFO_QUEUE_MESSAGE_CATEGORY_UNKNOWN + 1),
        DXGI_INFO_QUEUE_MESSAGE_CATEGORY_INITIALIZATION = (DXGI_INFO_QUEUE_MESSAGE_CATEGORY_MISCELLANEOUS + 1),
        DXGI_INFO_QUEUE_MESSAGE_CATEGORY_CLEANUP = (DXGI_INFO_QUEUE_MESSAGE_CATEGORY_INITIALIZATION + 1),
        DXGI_INFO_QUEUE_MESSAGE_CATEGORY_COMPILATION = (DXGI_INFO_QUEUE_MESSAGE_CATEGORY_CLEANUP + 1),
        DXGI_INFO_QUEUE_MESSAGE_CATEGORY_STATE_CREATION = (DXGI_INFO_QUEUE_MESSAGE_CATEGORY_COMPILATION + 1),
        DXGI_INFO_QUEUE_MESSAGE_CATEGORY_STATE_SETTING = (DXGI_INFO_QUEUE_MESSAGE_CATEGORY_STATE_CREATION + 1),
        DXGI_INFO_QUEUE_MESSAGE_CATEGORY_STATE_GETTING = (DXGI_INFO_QUEUE_MESSAGE_CATEGORY_STATE_SETTING + 1),
        DXGI_INFO_QUEUE_MESSAGE_CATEGORY_RESOURCE_MANIPULATION = (DXGI_INFO_QUEUE_MESSAGE_CATEGORY_STATE_GETTING + 1),
        DXGI_INFO_QUEUE_MESSAGE_CATEGORY_EXECUTION = (DXGI_INFO_QUEUE_MESSAGE_CATEGORY_RESOURCE_MANIPULATION + 1),
        DXGI_INFO_QUEUE_MESSAGE_CATEGORY_SHADER = (DXGI_INFO_QUEUE_MESSAGE_CATEGORY_EXECUTION + 1));

    PDXGI_INFO_QUEUE_MESSAGE_CATEGORY = ^TDXGI_INFO_QUEUE_MESSAGE_CATEGORY;


    TDXGI_INFO_QUEUE_MESSAGE_SEVERITY = (
        DXGI_INFO_QUEUE_MESSAGE_SEVERITY_CORRUPTION = 0,
        DXGI_INFO_QUEUE_MESSAGE_SEVERITY_ERROR = (DXGI_INFO_QUEUE_MESSAGE_SEVERITY_CORRUPTION + 1),
        DXGI_INFO_QUEUE_MESSAGE_SEVERITY_WARNING = (DXGI_INFO_QUEUE_MESSAGE_SEVERITY_ERROR + 1),
        DXGI_INFO_QUEUE_MESSAGE_SEVERITY_INFO = (DXGI_INFO_QUEUE_MESSAGE_SEVERITY_WARNING + 1),
        DXGI_INFO_QUEUE_MESSAGE_SEVERITY_MESSAGE = (DXGI_INFO_QUEUE_MESSAGE_SEVERITY_INFO + 1));

    PDXGI_INFO_QUEUE_MESSAGE_SEVERITY = ^TDXGI_INFO_QUEUE_MESSAGE_SEVERITY;


    DXGI_INFO_QUEUE_MESSAGE_ID = int32;
    TDXGI_INFO_QUEUE_MESSAGE_ID = DXGI_INFO_QUEUE_MESSAGE_ID;
    PDXGI_INFO_QUEUE_MESSAGE_ID = ^TDXGI_INFO_QUEUE_MESSAGE_ID;


    TDXGI_INFO_QUEUE_MESSAGE = record
        Producer: TDXGI_DEBUG_ID;
        Category: TDXGI_INFO_QUEUE_MESSAGE_CATEGORY;
        Severity: TDXGI_INFO_QUEUE_MESSAGE_SEVERITY;
        ID: TDXGI_INFO_QUEUE_MESSAGE_ID; (* [annotation] *)
        {_Field_size_(DescriptionByteLength)  } pDescription: pchar;
        DescriptionByteLength: SIZE_T;
    end;
    PDXGI_INFO_QUEUE_MESSAGE = ^TDXGI_INFO_QUEUE_MESSAGE;


    TDXGI_INFO_QUEUE_FILTER_DESC = record
        NumCategories: UINT; (* [annotation] *)
        {_Field_size_(NumCategories)  } pCategoryList: PDXGI_INFO_QUEUE_MESSAGE_CATEGORY;
        NumSeverities: UINT; (* [annotation] *)
        {_Field_size_(NumSeverities)  } pSeverityList: PDXGI_INFO_QUEUE_MESSAGE_SEVERITY;
        NumIDs: UINT; (* [annotation] *)
        {_Field_size_(NumIDs)  } pIDList: PDXGI_INFO_QUEUE_MESSAGE_ID;
    end;
    PDXGI_INFO_QUEUE_FILTER_DESC = ^TDXGI_INFO_QUEUE_FILTER_DESC;


    TDXGI_INFO_QUEUE_FILTER = record
        AllowList: TDXGI_INFO_QUEUE_FILTER_DESC;
        DenyList: TDXGI_INFO_QUEUE_FILTER_DESC;
    end;
    PDXGI_INFO_QUEUE_FILTER = ^TDXGI_INFO_QUEUE_FILTER;


    IDXGIInfoQueue = interface(IUnknown)
        ['{D67441C7-672A-476f-9E82-CD55B44949CE}']
        function SetMessageCountLimit(
        {_In_  } Producer: TDXGI_DEBUG_ID;
        {_In_  } MessageCountLimit: uint64): HRESULT; stdcall;

        procedure ClearStoredMessages(
        {_In_  } Producer: TDXGI_DEBUG_ID); stdcall;

        function GetMessage(
        {_In_  } Producer: TDXGI_DEBUG_ID;
        {_In_  } MessageIndex: uint64;
        {_Out_writes_bytes_opt_(*pMessageByteLength)  } pMessage: PDXGI_INFO_QUEUE_MESSAGE;
        {_Inout_  } pMessageByteLength: PSIZE_T): HRESULT; stdcall;

        function GetNumStoredMessagesAllowedByRetrievalFilters(
        {_In_  } Producer: TDXGI_DEBUG_ID): uint64; stdcall;

        function GetNumStoredMessages(
        {_In_  } Producer: TDXGI_DEBUG_ID): uint64; stdcall;

        function GetNumMessagesDiscardedByMessageCountLimit(
        {_In_  } Producer: TDXGI_DEBUG_ID): uint64; stdcall;

        function GetMessageCountLimit(
        {_In_  } Producer: TDXGI_DEBUG_ID): uint64; stdcall;

        function GetNumMessagesAllowedByStorageFilter(
        {_In_  } Producer: TDXGI_DEBUG_ID): uint64; stdcall;

        function GetNumMessagesDeniedByStorageFilter(
        {_In_  } Producer: TDXGI_DEBUG_ID): uint64; stdcall;

        function AddStorageFilterEntries(
        {_In_  } Producer: TDXGI_DEBUG_ID;
        {_In_  } pFilter: PDXGI_INFO_QUEUE_FILTER): HRESULT; stdcall;

        function GetStorageFilter(
        {_In_  } Producer: TDXGI_DEBUG_ID;
        {_Out_writes_bytes_opt_(*pFilterByteLength)  } pFilter: PDXGI_INFO_QUEUE_FILTER;
        {_Inout_  } pFilterByteLength: PSIZE_T): HRESULT; stdcall;

        procedure ClearStorageFilter(
        {_In_  } Producer: TDXGI_DEBUG_ID); stdcall;

        function PushEmptyStorageFilter(
        {_In_  } Producer: TDXGI_DEBUG_ID): HRESULT; stdcall;

        function PushDenyAllStorageFilter(
        {_In_  } Producer: TDXGI_DEBUG_ID): HRESULT; stdcall;

        function PushCopyOfStorageFilter(
        {_In_  } Producer: TDXGI_DEBUG_ID): HRESULT; stdcall;

        function PushStorageFilter(
        {_In_  } Producer: TDXGI_DEBUG_ID;
        {_In_  } pFilter: PDXGI_INFO_QUEUE_FILTER): HRESULT; stdcall;

        procedure PopStorageFilter(
        {_In_  } Producer: TDXGI_DEBUG_ID); stdcall;

        function GetStorageFilterStackSize(
        {_In_  } Producer: TDXGI_DEBUG_ID): UINT; stdcall;

        function AddRetrievalFilterEntries(
        {_In_  } Producer: TDXGI_DEBUG_ID;
        {_In_  } pFilter: PDXGI_INFO_QUEUE_FILTER): HRESULT; stdcall;

        function GetRetrievalFilter(
        {_In_  } Producer: TDXGI_DEBUG_ID;
        {_Out_writes_bytes_opt_(*pFilterByteLength)  } pFilter: PDXGI_INFO_QUEUE_FILTER;
        {_Inout_  } pFilterByteLength: PSIZE_T): HRESULT; stdcall;

        procedure ClearRetrievalFilter(
        {_In_  } Producer: TDXGI_DEBUG_ID); stdcall;

        function PushEmptyRetrievalFilter(
        {_In_  } Producer: TDXGI_DEBUG_ID): HRESULT; stdcall;

        function PushDenyAllRetrievalFilter(
        {_In_  } Producer: TDXGI_DEBUG_ID): HRESULT; stdcall;

        function PushCopyOfRetrievalFilter(
        {_In_  } Producer: TDXGI_DEBUG_ID): HRESULT; stdcall;

        function PushRetrievalFilter(
        {_In_  } Producer: TDXGI_DEBUG_ID;
        {_In_  } pFilter: PDXGI_INFO_QUEUE_FILTER): HRESULT; stdcall;

        procedure PopRetrievalFilter(
        {_In_  } Producer: TDXGI_DEBUG_ID); stdcall;

        function GetRetrievalFilterStackSize(
        {_In_  } Producer: TDXGI_DEBUG_ID): UINT; stdcall;

        function AddMessage(
        {_In_  } Producer: TDXGI_DEBUG_ID;
        {_In_  } Category: TDXGI_INFO_QUEUE_MESSAGE_CATEGORY;
        {_In_  } Severity: TDXGI_INFO_QUEUE_MESSAGE_SEVERITY;
        {_In_  } ID: TDXGI_INFO_QUEUE_MESSAGE_ID;
        {_In_  } pDescription: LPCSTR): HRESULT; stdcall;

        function AddApplicationMessage(
        {_In_  } Severity: TDXGI_INFO_QUEUE_MESSAGE_SEVERITY;
        {_In_  } pDescription: LPCSTR): HRESULT; stdcall;

        function SetBreakOnCategory(
        {_In_  } Producer: TDXGI_DEBUG_ID;
        {_In_  } Category: TDXGI_INFO_QUEUE_MESSAGE_CATEGORY;
        {_In_  } bEnable: boolean): HRESULT; stdcall;

        function SetBreakOnSeverity(
        {_In_  } Producer: TDXGI_DEBUG_ID;
        {_In_  } Severity: TDXGI_INFO_QUEUE_MESSAGE_SEVERITY;
        {_In_  } bEnable: boolean): HRESULT; stdcall;

        function SetBreakOnID(
        {_In_  } Producer: TDXGI_DEBUG_ID;
        {_In_  } ID: TDXGI_INFO_QUEUE_MESSAGE_ID;
        {_In_  } bEnable: boolean): HRESULT; stdcall;

        function GetBreakOnCategory(
        {_In_  } Producer: TDXGI_DEBUG_ID;
        {_In_  } Category: TDXGI_INFO_QUEUE_MESSAGE_CATEGORY): boolean; stdcall;

        function GetBreakOnSeverity(
        {_In_  } Producer: TDXGI_DEBUG_ID;
        {_In_  } Severity: TDXGI_INFO_QUEUE_MESSAGE_SEVERITY): boolean; stdcall;

        function GetBreakOnID(
        {_In_  } Producer: TDXGI_DEBUG_ID;
        {_In_  } ID: TDXGI_INFO_QUEUE_MESSAGE_ID): boolean; stdcall;

        procedure SetMuteDebugOutput(
        {_In_  } Producer: TDXGI_DEBUG_ID;
        {_In_  } bMute: boolean); stdcall;

        function GetMuteDebugOutput(
        {_In_  } Producer: TDXGI_DEBUG_ID): boolean; stdcall;

    end;


    IDXGIDebug = interface(IUnknown)
        ['{119E7452-DE9E-40fe-8806-88F90C12B441}']
        function ReportLiveObjects(apiid: TGUID; flags: TDXGI_DEBUG_RLO_FLAGS): HRESULT; stdcall;

    end;


    IDXGIDebug1 = interface(IDXGIDebug)
        ['{c5a05f0c-16f2-4adf-9f4d-a8c4d58ac550}']
        procedure EnableLeakTrackingForThread(); stdcall;

        procedure DisableLeakTrackingForThread(); stdcall;

        function IsLeakTrackingEnabledForThread(): boolean; stdcall;

    end;


function DXGIGetDebugInterface(riid: REFIID; out ppDebug): HRESULT; stdcall; external DXGIDebug_DLL;


implementation

end.
