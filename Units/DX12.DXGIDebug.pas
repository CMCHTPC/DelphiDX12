unit DX12.DXGIDebug;


{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

{$Z4}
{$A4}

interface

uses
    Windows, Classes;


const
    DXGIDEBUG_DLL ='Dxgidebug.dll';

const
    IID_IDXGIInfoQueue: TGUID = '{D67441C7-672A-476f-9E82-CD55B44949CE}';
    IID_IDXGIDebug: TGUID = '{119E7452-DE9E-40fe-8806-88F90C12B441}';
    IID_IDXGIDebug1: TGUID = '{c5a05f0c-16f2-4adf-9f4d-a8c4d58ac550}';

    DXGI_DEBUG_ALL: TGUID = '{e48ae283-da80-490b-87e6-43e9a9cfda08}';
    DXGI_DEBUG_DX: TGUID = '{35cdd7fc-13b2-421d-a5d7-7e4451287d64}';
    DXGI_DEBUG_DXGI: TGUID = '{25cddaa4-b1c6-47e1-ac3e-98875b5a2e2a}';
    DXGI_DEBUG_APP: TGUID = '{06cd6e01-4219-4ebd-8709-27ed23360c62}';


const
    DXGI_DEBUG_BINARY_VERSION = 1;
    DXGI_INFO_QUEUE_MESSAGE_ID_STRING_FROM_APPLICATION = 0;
    DXGI_INFO_QUEUE_DEFAULT_MESSAGE_COUNT_LIMIT = 1024;

type
    TDXGI_DEBUG_RLO_FLAGS = (
        DXGI_DEBUG_RLO_SUMMARY = $1,
        DXGI_DEBUG_RLO_DETAIL = $2,
        DXGI_DEBUG_RLO_IGNORE_INTERNAL = $4,
        DXGI_DEBUG_RLO_ALL = $7
        );

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
        DXGI_INFO_QUEUE_MESSAGE_CATEGORY_SHADER = (DXGI_INFO_QUEUE_MESSAGE_CATEGORY_EXECUTION + 1)
        );

    PDXGI_INFO_QUEUE_MESSAGE_CATEGORY = ^TDXGI_INFO_QUEUE_MESSAGE_CATEGORY;

    TDXGI_INFO_QUEUE_MESSAGE_SEVERITY = (
        DXGI_INFO_QUEUE_MESSAGE_SEVERITY_CORRUPTION = 0,
        DXGI_INFO_QUEUE_MESSAGE_SEVERITY_ERROR = (DXGI_INFO_QUEUE_MESSAGE_SEVERITY_CORRUPTION + 1),
        DXGI_INFO_QUEUE_MESSAGE_SEVERITY_WARNING = (DXGI_INFO_QUEUE_MESSAGE_SEVERITY_ERROR + 1),
        DXGI_INFO_QUEUE_MESSAGE_SEVERITY_INFO = (DXGI_INFO_QUEUE_MESSAGE_SEVERITY_WARNING + 1),
        DXGI_INFO_QUEUE_MESSAGE_SEVERITY_MESSAGE = (DXGI_INFO_QUEUE_MESSAGE_SEVERITY_INFO + 1));

    PDXGI_INFO_QUEUE_MESSAGE_SEVERITY = ^TDXGI_INFO_QUEUE_MESSAGE_SEVERITY;

    TDXGI_INFO_QUEUE_MESSAGE_ID = integer;

    PDXGI_INFO_QUEUE_MESSAGE_ID = ^TDXGI_INFO_QUEUE_MESSAGE_ID;


    TDXGI_INFO_QUEUE_MESSAGE = record
        Producer: TDXGI_DEBUG_ID;
        Category: TDXGI_INFO_QUEUE_MESSAGE_CATEGORY;
        Severity: TDXGI_INFO_QUEUE_MESSAGE_SEVERITY;
        ID: TDXGI_INFO_QUEUE_MESSAGE_ID;
        pDescription: PChar;
        DescriptionByteLength: SIZE_T;
    end;
    PDXGI_INFO_QUEUE_MESSAGE = ^TDXGI_INFO_QUEUE_MESSAGE;

    TDXGI_INFO_QUEUE_FILTER_DESC = record
        NumCategories: UINT;
        pCategoryList: PDXGI_INFO_QUEUE_MESSAGE_CATEGORY;
        NumSeverities: UINT;
        pSeverityList: PDXGI_INFO_QUEUE_MESSAGE_SEVERITY;
        NumIDs: UINT;
        pIDList: PDXGI_INFO_QUEUE_MESSAGE_ID;
    end;
    PDXGI_INFO_QUEUE_FILTER_DESC = ^TDXGI_INFO_QUEUE_FILTER_DESC;

    TDXGI_INFO_QUEUE_FILTER = record
        AllowList: TDXGI_INFO_QUEUE_FILTER_DESC;
        DenyList: TDXGI_INFO_QUEUE_FILTER_DESC;
    end;
    PDXGI_INFO_QUEUE_FILTER = ^TDXGI_INFO_QUEUE_FILTER;



    IDXGIInfoQueue = interface(IUnknown)
        ['{D67441C7-672A-476f-9E82-CD55B44949CE}']
        function SetMessageCountLimit(Producer: TDXGI_DEBUG_ID; MessageCountLimit: UINT64): HResult; stdcall;
        procedure ClearStoredMessages(Producer: TDXGI_DEBUG_ID); stdcall;
        function GetMessage(Producer: TDXGI_DEBUG_ID; MessageIndex: UINT64; out pMessage: TDXGI_INFO_QUEUE_MESSAGE;
            var pMessageByteLength: SIZE_T): HResult; stdcall;
        function GetNumStoredMessagesAllowedByRetrievalFilters(Producer: TDXGI_DEBUG_ID): UINT64; stdcall;
        function GetNumStoredMessages(Producer: TDXGI_DEBUG_ID): UINT64; stdcall;
        function GetNumMessagesDiscardedByMessageCountLimit(Producer: TDXGI_DEBUG_ID): UINT64; stdcall;
        function GetMessageCountLimit(Producer: TDXGI_DEBUG_ID): UINT64; stdcall;
        function GetNumMessagesAllowedByStorageFilter(Producer: TDXGI_DEBUG_ID): UINT64; stdcall;
        function GetNumMessagesDeniedByStorageFilter(Producer: TDXGI_DEBUG_ID): UINT64; stdcall;
        function AddStorageFilterEntries(Producer: TDXGI_DEBUG_ID; pFilter: PDXGI_INFO_QUEUE_FILTER): HResult; stdcall;
        function GetStorageFilter(Producer: TDXGI_DEBUG_ID; out pFilter: TDXGI_INFO_QUEUE_FILTER;
            var pFilterByteLength: SIZE_T): HResult; stdcall;
        procedure ClearStorageFilter(Producer: TDXGI_DEBUG_ID); stdcall;
        function PushEmptyStorageFilter(Producer: TDXGI_DEBUG_ID): HResult; stdcall;
        function PushDenyAllStorageFilter(Producer: TDXGI_DEBUG_ID): HResult; stdcall;
        function PushCopyOfStorageFilter(Producer: TDXGI_DEBUG_ID): HResult; stdcall;
        function PushStorageFilter(Producer: TDXGI_DEBUG_ID; pFilter: PDXGI_INFO_QUEUE_FILTER): HResult; stdcall;
        procedure PopStorageFilter(Producer: TDXGI_DEBUG_ID); stdcall;
        function GetStorageFilterStackSize(Producer: TDXGI_DEBUG_ID): UINT; stdcall;
        function AddRetrievalFilterEntries(Producer: TDXGI_DEBUG_ID; pFilter: PDXGI_INFO_QUEUE_FILTER): HResult; stdcall;
        function GetRetrievalFilter(Producer: TDXGI_DEBUG_ID; out pFilter: TDXGI_INFO_QUEUE_FILTER;
            var pFilterByteLength: SIZE_T): HResult; stdcall;
        procedure ClearRetrievalFilter(Producer: TDXGI_DEBUG_ID); stdcall;
        function PushEmptyRetrievalFilter(Producer: TDXGI_DEBUG_ID): HResult; stdcall;
        function PushDenyAllRetrievalFilter(Producer: TDXGI_DEBUG_ID): HResult; stdcall;
        function PushCopyOfRetrievalFilter(Producer: TDXGI_DEBUG_ID): HResult; stdcall;
        function PushRetrievalFilter(Producer: TDXGI_DEBUG_ID; pFilter: PDXGI_INFO_QUEUE_FILTER): HResult; stdcall;
        procedure PopRetrievalFilter(Producer: TDXGI_DEBUG_ID); stdcall;
        function GetRetrievalFilterStackSize(Producer: TDXGI_DEBUG_ID): UINT; stdcall;
        function AddMessage(Producer: TDXGI_DEBUG_ID; Category: TDXGI_INFO_QUEUE_MESSAGE_CATEGORY;
            Severity: TDXGI_INFO_QUEUE_MESSAGE_SEVERITY; ID: TDXGI_INFO_QUEUE_MESSAGE_ID; pDescription: LPCSTR): HResult; stdcall;
        function AddApplicationMessage(Severity: TDXGI_INFO_QUEUE_MESSAGE_SEVERITY; pDescription: LPCSTR): HResult; stdcall;
        function SetBreakOnCategory(Producer: TDXGI_DEBUG_ID; Category: TDXGI_INFO_QUEUE_MESSAGE_CATEGORY;
            bEnable: boolean): HResult; stdcall;
        function SetBreakOnSeverity(Producer: TDXGI_DEBUG_ID; Severity: TDXGI_INFO_QUEUE_MESSAGE_SEVERITY;
            bEnable: boolean): HResult; stdcall;
        function SetBreakOnID(Producer: TDXGI_DEBUG_ID; ID: TDXGI_INFO_QUEUE_MESSAGE_ID; bEnable: boolean): HResult; stdcall;
        function GetBreakOnCategory(Producer: TDXGI_DEBUG_ID; Category: TDXGI_INFO_QUEUE_MESSAGE_CATEGORY): boolean; stdcall;
        function GetBreakOnSeverity(Producer: TDXGI_DEBUG_ID; Severity: TDXGI_INFO_QUEUE_MESSAGE_SEVERITY): boolean; stdcall;
        function GetBreakOnID(Producer: TDXGI_DEBUG_ID; ID: TDXGI_INFO_QUEUE_MESSAGE_ID): boolean; stdcall;
        procedure SetMuteDebugOutput(Producer: TDXGI_DEBUG_ID; bMute: boolean); stdcall;
        function GetMuteDebugOutput(Producer: TDXGI_DEBUG_ID): boolean; stdcall;
    end;




    IDXGIDebug = interface(IUnknown)
        ['{119E7452-DE9E-40fe-8806-88F90C12B441}']
        function ReportLiveObjects(apiid: TGUID; flags: TDXGI_DEBUG_RLO_FLAGS): HResult; stdcall;
    end;


    IDXGIDebug1 = interface(IDXGIDebug)
        ['{c5a05f0c-16f2-4adf-9f4d-a8c4d58ac550}']
        procedure EnableLeakTrackingForThread(); stdcall;
        procedure DisableLeakTrackingForThread(); stdcall;
        function IsLeakTrackingEnabledForThread(): boolean; stdcall;
    end;


function DXGIGetDebugInterface(const riid: TGUID; out ppDebug): HResult; stdcall; external DXGIDEBUG_DLL;


implementation

end.

