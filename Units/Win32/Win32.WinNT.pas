// not ready !!!
unit Win32.WinNT;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils;

    {$Z4}

const
    RTL_CRITICAL_SECTION_FLAG_NO_DEBUG_INFO = $01000000;

    EXCEPTION_MAXIMUM_PARAMETERS = 15; // maximum number of exception parameters

type
    PIO_COUNTERS = pointer;

    _PROCESS_DYNAMIC_EH_CONTINUATION_TARGET = record
        TargetAddress: ULONG_PTR;
        Flags: ULONG_PTR;
    end;
    TPROCESS_DYNAMIC_EH_CONTINUATION_TARGET = _PROCESS_DYNAMIC_EH_CONTINUATION_TARGET;
    PPROCESS_DYNAMIC_EH_CONTINUATION_TARGET = ^TPROCESS_DYNAMIC_EH_CONTINUATION_TARGET;


    _PROCESS_DYNAMIC_EH_CONTINUATION_TARGETS_INFORMATION = record
        NumberOfTargets: word;
        Reserved: word;
        Reserved2: DWORD;
        Targets: PPROCESS_DYNAMIC_EH_CONTINUATION_TARGET;
    end;
    TPROCESS_DYNAMIC_EH_CONTINUATION_TARGETS_INFORMATION = _PROCESS_DYNAMIC_EH_CONTINUATION_TARGETS_INFORMATION;
    PPROCESS_DYNAMIC_EH_CONTINUATION_TARGETS_INFORMATION = ^TPROCESS_DYNAMIC_EH_CONTINUATION_TARGETS_INFORMATION;


_PROCESS_DYNAMIC_ENFORCED_ADDRESS_RANGE = record
   BaseAddress : ULONG_PTR;
   Size : SIZE_T;
   Flags : DWORD;
end;
TPROCESS_DYNAMIC_ENFORCED_ADDRESS_RANGE = _PROCESS_DYNAMIC_ENFORCED_ADDRESS_RANGE;
PPROCESS_DYNAMIC_ENFORCED_ADDRESS_RANGE = ^TPROCESS_DYNAMIC_ENFORCED_ADDRESS_RANGE;

_PROCESS_DYNAMIC_ENFORCED_ADDRESS_RANGES_INFORMATION = record
   NumberOfRanges : WORD;
   Reserved : WORD;
   Reserved2 : DWORD;
   Ranges : PPROCESS_DYNAMIC_ENFORCED_ADDRESS_RANGE;
end;
TPROCESS_DYNAMIC_ENFORCED_ADDRESS_RANGES_INFORMATION = _PROCESS_DYNAMIC_ENFORCED_ADDRESS_RANGES_INFORMATION;
PPROCESS_DYNAMIC_ENFORCED_ADDRESS_RANGES_INFORMATION = ^TPROCESS_DYNAMIC_ENFORCED_ADDRESS_RANGES_INFORMATION;


PSYSTEM_CPU_SET_INFORMATION = pointer;
PGROUP_AFFINITY = pointer;

_PROCESS_MITIGATION_POLICY = (
    ProcessDEPPolicy,
    ProcessASLRPolicy,
    ProcessDynamicCodePolicy,
    ProcessStrictHandleCheckPolicy,
    ProcessSystemCallDisablePolicy,
    ProcessMitigationOptionsMask,
    ProcessExtensionPointDisablePolicy,
    ProcessControlFlowGuardPolicy,
    ProcessSignaturePolicy,
    ProcessFontDisablePolicy,
    ProcessImageLoadPolicy,
    ProcessSystemCallFilterPolicy,
    ProcessPayloadRestrictionPolicy,
    ProcessChildProcessPolicy,
    ProcessSideChannelIsolationPolicy,
    ProcessUserShadowStackPolicy,
    ProcessRedirectionTrustPolicy,
    ProcessUserPointerAuthPolicy,
    ProcessSEHOPPolicy,
    MaxProcessMitigationPolicy
);

TPROCESS_MITIGATION_POLICY = _PROCESS_MITIGATION_POLICY;
PPROCESS_MITIGATION_POLICY = ^TPROCESS_MITIGATION_POLICY;


//


    TLATENCY_TIME = (
        LT_DONT_CARE,
        LT_LOWEST_LATENCY);

    PLATENCY_TIME = ^TLATENCY_TIME;

    TEXECUTION_STATE = DWORD;
    PPEXECUTION_STATE = ^DWORD;

    _POWER_REQUEST_TYPE = (
        PowerRequestDisplayRequired,
        PowerRequestSystemRequired,
        PowerRequestAwayModeRequired,
        PowerRequestExecutionRequired);

    TPOWER_REQUEST_TYPE = _POWER_REQUEST_TYPE;
    PPOWER_REQUEST_TYPE = ^TPOWER_REQUEST_TYPE;


    PWOW64_LDT_ENTRY = pointer;


    _FIRMWARE_TYPE = (
        FirmwareTypeUnknown,
        FirmwareTypeBios,
        FirmwareTypeUefi,
        FirmwareTypeMax);

    TFIRMWARE_TYPE = _FIRMWARE_TYPE;
    PFIRMWARE_TYPE = ^TFIRMWARE_TYPE;


    _FILE_ID_128 = record
        Identifier: array [0..16 - 1] of byte;
    end;
    TFILE_ID_128 = _FILE_ID_128;
    PFILE_ID_128 = ^TFILE_ID_128;

    _AUDIT_EVENT_TYPE = (
        AuditEventObjectAccess,
        AuditEventDirectoryServiceAccess);

    TAUDIT_EVENT_TYPE = _AUDIT_EVENT_TYPE;
    PAUDIT_EVENT_TYPE = ^TAUDIT_EVENT_TYPE;


    _OBJECT_TYPE_LIST = record
        Level: word;
        Sbz: word;
        ObjectType: PGUID;
    end;
    TOBJECT_TYPE_LIST = _OBJECT_TYPE_LIST;
    POBJECT_TYPE_LIST = ^TOBJECT_TYPE_LIST;


    _QUOTA_LIMITS = record
        PagedPoolLimit: SIZE_T;
        NonPagedPoolLimit: SIZE_T;
        MinimumWorkingSetSize: SIZE_T;
        MaximumWorkingSetSize: SIZE_T;
        PagefileLimit: SIZE_T;
        TimeLimit: LARGE_INTEGER;
    end;
    TQUOTA_LIMITS = _QUOTA_LIMITS;
    PQUOTA_LIMITS = ^TQUOTA_LIMITS;

    // Exception record definition.


    PEXCEPTION_RECORD = ^TEXCEPTION_RECORD;


    _EXCEPTION_RECORD = record
        ExceptionCode: DWORD;
        ExceptionFlags: DWORD;
        ExceptionRecord: PEXCEPTION_RECORD;
        ExceptionAddress: PVOID;
        NumberParameters: DWORD;
        ExceptionInformation: array [0..EXCEPTION_MAXIMUM_PARAMETERS - 1] of ULONG_PTR;
    end;
    TEXCEPTION_RECORD = _EXCEPTION_RECORD;
    LPEXCEPTION_RECORD = PEXCEPTION_RECORD;

    PEXCEPTION_POINTERS = pointer;
    LPEXCEPTION_POINTERS = PEXCEPTION_POINTERS;

    _RTL_UMS_THREAD_INFO_CLASS = (
        UmsThreadInvalidInfoClass = 0,
        UmsThreadUserContext,
        UmsThreadPriority, // Reserved
        UmsThreadAffinity, // Reserved
        UmsThreadTeb,
        UmsThreadIsSuspended,
        UmsThreadIsTerminated,
        UmsThreadMaxInfoClass);

    TRTL_UMS_THREAD_INFO_CLASS = _RTL_UMS_THREAD_INFO_CLASS;
    PRTL_UMS_THREAD_INFO_CLASS = ^TRTL_UMS_THREAD_INFO_CLASS;

    _RTL_UMS_SCHEDULER_REASON = (
        UmsSchedulerStartup = 0,
        UmsSchedulerThreadBlocked,
        UmsSchedulerThreadYield);

    TRTL_UMS_SCHEDULER_REASON = _RTL_UMS_SCHEDULER_REASON;
    PRTL_UMS_SCHEDULER_REASON = ^TRTL_UMS_SCHEDULER_REASON;


    RTL_UMS_SCHEDULER_ENTRY_POINT = procedure(
        {_In_}  Reason: TRTL_UMS_SCHEDULER_REASON;
        {_In_}  ActivationPayload: ULONG_PTR;
        {_In_}  SchedulerParam: pointer); stdcall;

    PRTL_UMS_SCHEDULER_ENTRY_POINT = ^RTL_UMS_SCHEDULER_ENTRY_POINT;


    //  Doubly linked list structure.  Can be used as either a list head, or
    //  as link words.

    PLIST_ENTRY = ^TLIST_ENTRY;

    _LIST_ENTRY = record
        Flink: PLIST_ENTRY;
        Blink: PLIST_ENTRY;
    end;
    TLIST_ENTRY = _LIST_ENTRY;


    RESTRICTED_POINTERPRLIST_ENTRY = ^TLIST_ENTRY;

    PRTL_CRITICAL_SECTION = ^TRTL_CRITICAL_SECTION;

    _RTL_CRITICAL_SECTION_DEBUG = record
        DebugType: word;
        CreatorBackTraceIndex: word;
        CriticalSection: PRTL_CRITICAL_SECTION;

        ProcessLocksList: TLIST_ENTRY;
        EntryCount: DWORD;
        ContentionCount: DWORD;
        Flags: DWORD;
        CreatorBackTraceIndexHigh: word;
        Identifier: word;
    end;
    TRTL_CRITICAL_SECTION_DEBUG = _RTL_CRITICAL_SECTION_DEBUG;
    PRTL_CRITICAL_SECTION_DEBUG = ^TRTL_CRITICAL_SECTION_DEBUG;

    TRTL_RESOURCE_DEBUG = TRTL_CRITICAL_SECTION_DEBUG;
    PRTL_RESOURCE_DEBUG = ^TRTL_CRITICAL_SECTION_DEBUG;


    TWAITORTIMERCALLBACKFUNC = procedure(Nameless1: PVOID; Nameless2: winbool); stdcall;

    TWAITORTIMERCALLBACK = TWAITORTIMERCALLBACKFUNC;


    _OSVERSIONINFOEXA = record
        dwOSVersionInfoSize: DWORD;
        dwMajorVersion: DWORD;
        dwMinorVersion: DWORD;
        dwBuildNumber: DWORD;
        dwPlatformId: DWORD;
        szCSDVersion: array [0..128 - 1] of TCHAR; // Maintenance string for PSS usage
        wServicePackMajor: word;
        wServicePackMinor: word;
        wSuiteMask: word;
        wProductType: TBYTE;
        wReserved: TBYTE;
    end;
    TOSVERSIONINFOEXA = _OSVERSIONINFOEXA;
    POSVERSIONINFOEXA = ^TOSVERSIONINFOEXA;
    LPOSVERSIONINFOEXA = ^TOSVERSIONINFOEXA;

    _OSVERSIONINFOEXW = record
        dwOSVersionInfoSize: DWORD;
        dwMajorVersion: DWORD;
        dwMinorVersion: DWORD;
        dwBuildNumber: DWORD;
        dwPlatformId: DWORD;
        szCSDVersion: array [0..128 - 1] of WCHAR; // Maintenance string for PSS usage
        wServicePackMajor: word;
        wServicePackMinor: word;
        wSuiteMask: word;
        wProductType: TBYTE;
        wReserved: TBYTE;
    end;
    TOSVERSIONINFOEXW = _OSVERSIONINFOEXW;
    POSVERSIONINFOEXW = ^TOSVERSIONINFOEXW;

    LPOSVERSIONINFOEXW = ^TOSVERSIONINFOEXW;

    _JOB_SET_ARRAY = record
        JobHandle: HANDLE; // Handle to job object to insert
        MemberLevel: DWORD; // Level of this job in the set. Must be > 0. Can be sparse.
        Flags: DWORD; // Unused. Must be zero
    end;
    TJOB_SET_ARRAY = _JOB_SET_ARRAY;
    PJOB_SET_ARRAY = ^TJOB_SET_ARRAY;

    PSECURE_MEMORY_CACHE_CALLBACK = function(
        {_In_reads_bytes_(Range)}  Addr: PVOID;
        {_In_}  Range: SIZE_T): winbool; stdcall;

    PPERFORMANCE_DATA = pointer;
    PCUSTOM_SYSTEM_EVENT_TRIGGER_CONFIG = pointer;

    TRTL_OSVERSIONINFOEXW = TOSVERSIONINFOEXW;
    PRTL_OSVERSIONINFOEXW = ^TOSVERSIONINFOEXW;

    {$PACKRECORDS 8}

    _RTL_CRITICAL_SECTION = record
        DebugInfo: PRTL_CRITICAL_SECTION_DEBUG;

        //  The following three fields control entering and exiting the critical
        //  section for the resource

        LockCount: LONG;
        RecursionCount: LONG;
        OwningThread: HANDLE; // from the thread's ClientId->UniqueThread
        LockSemaphore: HANDLE;
        SpinCount: ULONG_PTR; // force size on 64-bit systems when packed
    end;
    TRTL_CRITICAL_SECTION = _RTL_CRITICAL_SECTION;


    {$PACKRECORDS DEFAULT}

    PAPCFUNC = procedure(
        {_In_}  Parameter: ULONG_PTR); stdcall;

implementation

end.
