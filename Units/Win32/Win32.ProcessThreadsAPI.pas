(***********************************************************************************
*                                                                                  *
* processthreadsapi.h -- ApiSet Contract for api-ms-win-core-processthreads-l1     *
*                                                                                  *
* Copyright (c) Microsoft Corporation. All rights reserved.                        *
*                                                                                  *
***********************************************************************************)
unit Win32.ProcessThreadsAPI;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    Win32.WinBase,
    Win32.WinNT;

const

    Kernel32_DLL = 'Kernel32.dll';

    TLS_OUT_OF_INDEXES = DWORD($FFFFFFFF);

    PROC_THREAD_ATTRIBUTE_REPLACE_VALUE = $00000001;

    PROCESS_AFFINITY_ENABLE_AUTO_UPDATE = $00000001;


    THREAD_POWER_THROTTLING_CURRENT_VERSION = 1;

    THREAD_POWER_THROTTLING_EXECUTION_SPEED = $1;

    THREAD_POWER_THROTTLING_VALID_FLAGS = (THREAD_POWER_THROTTLING_EXECUTION_SPEED);


    // Constants and structures needed to enable the fail fast on commit failure
    // feature.


    PME_CURRENT_VERSION = 1;
    PME_FAILFAST_ON_COMMIT_FAIL_DISABLE = $0;
    PME_FAILFAST_ON_COMMIT_FAIL_ENABLE = $1;

    PROCESS_POWER_THROTTLING_CURRENT_VERSION = 1;

    PROCESS_POWER_THROTTLING_EXECUTION_SPEED = $1;
    PROCESS_POWER_THROTTLING_IGNORE_TIMER_RESOLUTION = $4;

    PROCESS_POWER_THROTTLING_VALID_FLAGS = ((PROCESS_POWER_THROTTLING_EXECUTION_SPEED or PROCESS_POWER_THROTTLING_IGNORE_TIMER_RESOLUTION));


    PROCESS_LEAP_SECOND_INFO_FLAG_ENABLE_SIXTY_SECOND = $1;

    PROCESS_LEAP_SECOND_INFO_VALID_FLAGS = (PROCESS_LEAP_SECOND_INFO_FLAG_ENABLE_SIXTY_SECOND);

    // see http://www.rohitab.com/discuss/topic/38601-proc-thread-attribute-list-structure-documentation/

    // Flags to indicate if an attribute is present in the list.
    // I believe these are used so that Windows doesn't have to scan the complete list to see if an attribute is present.
    PARENT_PROCESS = (1 shl ord(ProcThreadAttributeParentProcess));
//    EXTENDED_FLAGS = (1 shl ord(ProcThreadAttributeExtendedFlags)); // ProcThreadAttributeExtendedFlags is not defined?
    HANDLE_LIST = (1 shl ord(ProcThreadAttributeHandleList));
    GROUP_AFFINITY = (1 shl ord(ProcThreadAttributeGroupAffinity));
    PREFERRED_NODE = (1 shl ord(ProcThreadAttributePreferredNode));
    IDEAL_PROCESSOR = (1 shl ord(ProcThreadAttributeIdealProcessor));
    UMS_THREAD = (1 shl ord(ProcThreadAttributeUmsThread));
    MITIGATION_POLICY = (1 shl ord(ProcThreadAttributeMitigationPolicy));

type

    LPCGUID = ^TGUID;

    _PROCESS_INFORMATION = record
        hProcess: HANDLE;
        hThread: HANDLE;
        dwProcessId: DWORD;
        dwThreadId: DWORD;
    end;
    TPROCESS_INFORMATION = _PROCESS_INFORMATION;
    PPROCESS_INFORMATION = ^TPROCESS_INFORMATION;
    LPPROCESS_INFORMATION = ^TPROCESS_INFORMATION;

    _STARTUPINFOA = record
        cb: DWORD;
        lpReserved: LPSTR;
        lpDesktop: LPSTR;
        lpTitle: LPSTR;
        dwX: DWORD;
        dwY: DWORD;
        dwXSize: DWORD;
        dwYSize: DWORD;
        dwXCountChars: DWORD;
        dwYCountChars: DWORD;
        dwFillAttribute: DWORD;
        dwFlags: DWORD;
        wShowWindow: word;
        cbReserved2: word;
        lpReserved2: LPBYTE;
        hStdInput: HANDLE;
        hStdOutput: HANDLE;
        hStdError: HANDLE;
    end;
    TSTARTUPINFOA = _STARTUPINFOA;
    PSTARTUPINFOA = ^TSTARTUPINFOA;
    LPSTARTUPINFOA = ^TSTARTUPINFOA;

    _STARTUPINFOW = record
        cb: DWORD;
        lpReserved: LPWSTR;
        lpDesktop: LPWSTR;
        lpTitle: LPWSTR;
        dwX: DWORD;
        dwY: DWORD;
        dwXSize: DWORD;
        dwYSize: DWORD;
        dwXCountChars: DWORD;
        dwYCountChars: DWORD;
        dwFillAttribute: DWORD;
        dwFlags: DWORD;
        wShowWindow: word;
        cbReserved2: word;
        lpReserved2: LPBYTE;
        hStdInput: HANDLE;
        hStdOutput: HANDLE;
        hStdError: HANDLE;
    end;
    TSTARTUPINFOW = _STARTUPINFOW;
    PSTARTUPINFOW = ^TSTARTUPINFOW;
    LPSTARTUPINFOW = ^TSTARTUPINFOW;


    _QUEUE_USER_APC_FLAGS = (
        QUEUE_USER_APC_FLAGS_NONE = $00000000,
        QUEUE_USER_APC_FLAGS_SPECIAL_USER_APC = $00000001,

        // Used for requesting additional callback data.

        QUEUE_USER_APC_CALLBACK_DATA_CONTEXT = $00010000);

    TQUEUE_USER_APC_FLAGS = _QUEUE_USER_APC_FLAGS;
    PQUEUE_USER_APC_FLAGS = ^TQUEUE_USER_APC_FLAGS;


    _APC_CALLBACK_DATA = record
        Parameter: ULONG_PTR;
        ContextRecord: PCONTEXT;
        Reserved0: ULONG_PTR;
        Reserved1: ULONG_PTR;
    end;
    TAPC_CALLBACK_DATA = _APC_CALLBACK_DATA;
    PAPC_CALLBACK_DATA = ^TAPC_CALLBACK_DATA;


    // Thread information classes.


    _THREAD_INFORMATION_CLASS = (
        ThreadMemoryPriority,
        ThreadAbsoluteCpuPriority,
        ThreadDynamicCodePolicy,
        ThreadPowerThrottling,
        ThreadInformationClassMax);

    TTHREAD_INFORMATION_CLASS = _THREAD_INFORMATION_CLASS;
    PTHREAD_INFORMATION_CLASS = ^TTHREAD_INFORMATION_CLASS;


    _MEMORY_PRIORITY_INFORMATION = record
        MemoryPriority: ULONG;
    end;
    TMEMORY_PRIORITY_INFORMATION = _MEMORY_PRIORITY_INFORMATION;
    PMEMORY_PRIORITY_INFORMATION = ^TMEMORY_PRIORITY_INFORMATION;


    _THREAD_POWER_THROTTLING_STATE = record
        Version: ULONG;
        ControlMask: ULONG;
        StateMask: ULONG;
    end;
    TTHREAD_POWER_THROTTLING_STATE = _THREAD_POWER_THROTTLING_STATE;
    PTHREAD_POWER_THROTTLING_STATE = ^TTHREAD_POWER_THROTTLING_STATE;


    _PROCESS_INFORMATION_CLASS = (
        ProcessMemoryPriority, // MEMORY_PRIORITY_INFORMATION
        ProcessMemoryExhaustionInfo, // PROCESS_MEMORY_EXHAUSTION_INFO
        ProcessAppMemoryInfo, // APP_MEMORY_INFORMATION
        ProcessInPrivateInfo, // BOOLEAN
        ProcessPowerThrottling, // PROCESS_POWER_THROTTLING_STATE
        ProcessReservedValue1, // Used to be for ProcessActivityThrottlePolicyInfo
        ProcessTelemetryCoverageInfo, // TELEMETRY_COVERAGE_POINT
        ProcessProtectionLevelInfo, // PROCESS_PROTECTION_LEVEL_INFORMATION
        ProcessLeapSecondInfo, // PROCESS_LEAP_SECOND_INFO
        ProcessMachineTypeInfo, // PROCESS_MACHINE_INFORMATION
        ProcessOverrideSubsequentPrefetchParameter, // OVERRIDE_PREFETCH_PARAMETER
        ProcessMaxOverridePrefetchParameter, // OVERRIDE_PREFETCH_PARAMETER
        ProcessInformationClassMax);

    TPROCESS_INFORMATION_CLASS = _PROCESS_INFORMATION_CLASS;
    PPROCESS_INFORMATION_CLASS = ^TPROCESS_INFORMATION_CLASS;


    _APP_MEMORY_INFORMATION = record
        AvailableCommit: ULONG64;
        PrivateCommitUsage: ULONG64;
        PeakPrivateCommitUsage: ULONG64;
        TotalCommitUsage: ULONG64;
    end;
    TAPP_MEMORY_INFORMATION = _APP_MEMORY_INFORMATION;
    PAPP_MEMORY_INFORMATION = ^TAPP_MEMORY_INFORMATION;


    _MACHINE_ATTRIBUTES = (
        UserEnabled = $00000001,
        KernelEnabled = $00000002,
        Wow64Container = $00000004);

    TMACHINE_ATTRIBUTES = _MACHINE_ATTRIBUTES;
    PMACHINE_ATTRIBUTES = ^TMACHINE_ATTRIBUTES;


    _PROCESS_MACHINE_INFORMATION = record
        ProcessMachine: USHORT;
        Res0: USHORT;
        MachineAttributes: TMACHINE_ATTRIBUTES;
    end;
    TPROCESS_MACHINE_INFORMATION = _PROCESS_MACHINE_INFORMATION;
    PPROCESS_MACHINE_INFORMATION = ^TPROCESS_MACHINE_INFORMATION;


    TOVERRIDE_PREFETCH_PARAMETER = record
        Value: uint32;
    end;
    POVERRIDE_PREFETCH_PARAMETER = ^TOVERRIDE_PREFETCH_PARAMETER;


    // Constants and structures needed to enable the fail fast on commit failure
    // feature.


    _PROCESS_MEMORY_EXHAUSTION_TYPE = (
        PMETypeFailFastOnCommitFailure,
        PMETypeMax);

    TPROCESS_MEMORY_EXHAUSTION_TYPE = _PROCESS_MEMORY_EXHAUSTION_TYPE;
    PPROCESS_MEMORY_EXHAUSTION_TYPE = ^TPROCESS_MEMORY_EXHAUSTION_TYPE;


    _PROCESS_MEMORY_EXHAUSTION_INFO = record
        Version: USHORT;
        Reserved: USHORT;
        ExhaustionType: TPROCESS_MEMORY_EXHAUSTION_TYPE;
        Value: ULONG_PTR;
    end;
    TPROCESS_MEMORY_EXHAUSTION_INFO = _PROCESS_MEMORY_EXHAUSTION_INFO;
    PPROCESS_MEMORY_EXHAUSTION_INFO = ^TPROCESS_MEMORY_EXHAUSTION_INFO;


    _PROCESS_POWER_THROTTLING_STATE = record
        Version: ULONG;
        ControlMask: ULONG;
        StateMask: ULONG;
    end;
    TPROCESS_POWER_THROTTLING_STATE = _PROCESS_POWER_THROTTLING_STATE;
    PPROCESS_POWER_THROTTLING_STATE = ^TPROCESS_POWER_THROTTLING_STATE;

    TPROCESS_PROTECTION_LEVEL_INFORMATION = record
        ProtectionLevel: DWORD;
    end;
    PPROCESS_PROTECTION_LEVEL_INFORMATION = ^TPROCESS_PROTECTION_LEVEL_INFORMATION;


    _PROCESS_LEAP_SECOND_INFO = record
        Flags: ULONG;
        Reserved: ULONG;
    end;
    TPROCESS_LEAP_SECOND_INFO = _PROCESS_LEAP_SECOND_INFO;
    PPROCESS_LEAP_SECOND_INFO = ^TPROCESS_LEAP_SECOND_INFO;

    // _PROC_THREAD_ATTRIBUTE_ENTRY is reverse engineered
    // see http://www.rohitab.com/discuss/topic/38601-proc-thread-attribute-list-structure-documentation/

    // This structure stores the value for each attribute
    _PROC_THREAD_ATTRIBUTE_ENTRY = record
        Attribute: DWORD_PTR; // PROC_THREAD_ATTRIBUTE_xxx
        cbSize: SIZE_T;
        lpValue: PVOID;
    end;
    TPROC_THREAD_ATTRIBUTE_ENTRY = _PROC_THREAD_ATTRIBUTE_ENTRY;
    PPROC_THREAD_ATTRIBUTE_ENTRY = ^TPROC_THREAD_ATTRIBUTE_ENTRY;
    LPPROC_THREAD_ATTRIBUTE_ENTRY = ^TPROC_THREAD_ATTRIBUTE_ENTRY;

    // This structure contains a list of attributes that have been added using UpdateProcThreadAttribute
    _PROC_THREAD_ATTRIBUTE_LIST = record
        dwFlags: DWORD;
        Size: ULONG;
        Count: ULONG;
        Reserved: ULONG;
        Unknown: PULONG;
        Entries: array [0..0] of TPROC_THREAD_ATTRIBUTE_ENTRY;
    end;
    TPROC_THREAD_ATTRIBUTE_LIST = _PROC_THREAD_ATTRIBUTE_LIST;
    PPROC_THREAD_ATTRIBUTE_LIST = ^TPROC_THREAD_ATTRIBUTE_LIST;
    LPPROC_THREAD_ATTRIBUTE_LIST = ^TPROC_THREAD_ATTRIBUTE_LIST;

function QueueUserAPC(
    {_In_ } pfnAPC: PAPCFUNC;
    {_In_ } hThread: HANDLE;
    {_In_ } dwData: ULONG_PTR): DWORD; stdcall; external Kernel32_DLL;


function QueueUserAPC2(
    {_In_ } ApcRoutine: PAPCFUNC;
    {_In_ } Thread: HANDLE;
    {_In_ } Data: ULONG_PTR;
    {_In_ } Flags: TQUEUE_USER_APC_FLAGS): winbool; stdcall; external Kernel32_DLL;


function GetProcessTimes(
    {_In_ } hProcess: HANDLE;
    {_Out_ } lpCreationTime: LPFILETIME;
    {_Out_ } lpExitTime: LPFILETIME;
    {_Out_ } lpKernelTime: LPFILETIME;
    {_Out_ } lpUserTime: LPFILETIME): winbool; stdcall; external Kernel32_DLL;


function GetCurrentProcess(): HANDLE; stdcall; external Kernel32_DLL;


function GetCurrentProcessId(): DWORD; stdcall; external Kernel32_DLL;


procedure ExitProcess(
    {_In_ } uExitCode: UINT); stdcall; external Kernel32_DLL;


function TerminateProcess(
    {_In_ } hProcess: HANDLE;
    {_In_ } uExitCode: UINT): winbool; stdcall; external Kernel32_DLL;


function GetExitCodeProcess(
    {_In_ } hProcess: HANDLE;
    {_Out_ } lpExitCode: LPDWORD): winbool; stdcall; external Kernel32_DLL;


function SwitchToThread(): winbool; stdcall; external Kernel32_DLL;


function CreateThread(
    {_In_opt_ } lpThreadAttributes: LPSECURITY_ATTRIBUTES;
    {_In_ } dwStackSize: SIZE_T;
    {_In_ } lpStartAddress: LPTHREAD_START_ROUTINE;
    {_In_opt_ } lpParameter: LPVOID;
    {_In_ } dwCreationFlags: DWORD;
    {_Out_opt_ } lpThreadId: LPDWORD): HANDLE; stdcall; external Kernel32_DLL;


function CreateRemoteThread(
    {_In_ } hProcess: HANDLE;
    {_In_opt_ } lpThreadAttributes: LPSECURITY_ATTRIBUTES;
    {_In_ } dwStackSize: SIZE_T;
    {_In_ } lpStartAddress: LPTHREAD_START_ROUTINE;
    {_In_opt_ } lpParameter: LPVOID;
    {_In_ } dwCreationFlags: DWORD;
    {_Out_opt_ } lpThreadId: LPDWORD): HANDLE; stdcall; external Kernel32_DLL;


function GetCurrentThread(): HANDLE; stdcall; external Kernel32_DLL;


function GetCurrentThreadId(): DWORD; stdcall; external Kernel32_DLL;


function OpenThread(
    {_In_ } dwDesiredAccess: DWORD;
    {_In_ } bInheritHandle: winbool;
    {_In_ } dwThreadId: DWORD): HANDLE; stdcall; external Kernel32_DLL;


function SetThreadPriority(
    {_In_ } hThread: HANDLE;
    {_In_ } nPriority: int32): winbool; stdcall; external Kernel32_DLL;


function SetThreadPriorityBoost(
    {_In_ } hThread: HANDLE;
    {_In_ } bDisablePriorityBoost: winbool): winbool; stdcall; external Kernel32_DLL;


function GetThreadPriorityBoost(
    {_In_ } hThread: HANDLE;
    {_Out_ } pDisablePriorityBoost: PWinBOOL): winbool; stdcall; external Kernel32_DLL;


function GetThreadPriority(
    {_In_ } hThread: HANDLE): int32; stdcall; external Kernel32_DLL;


procedure ExitThread(
    {_In_ } dwExitCode: DWORD); stdcall; external Kernel32_DLL;


function TerminateThread(
    {_In_ } hThread: HANDLE;
    {_In_ } dwExitCode: DWORD): winbool; stdcall; external Kernel32_DLL;


function GetExitCodeThread(
    {_In_ } hThread: HANDLE;
    {_Out_ } lpExitCode: LPDWORD): winbool; stdcall; external Kernel32_DLL;


function SuspendThread(
    {_In_ } hThread: HANDLE): DWORD; stdcall; external Kernel32_DLL;


function ResumeThread(
    {_In_ } hThread: HANDLE): DWORD; stdcall; external Kernel32_DLL;


function TlsAlloc(): DWORD; stdcall; external Kernel32_DLL;


function TlsGetValue(
    {_In_ } dwTlsIndex: DWORD): LPVOID; stdcall; external Kernel32_DLL;


function TlsSetValue(
    {_In_ } dwTlsIndex: DWORD;
    {_In_opt_ } lpTlsValue: LPVOID): winbool; stdcall; external Kernel32_DLL;


function TlsFree(
    {_In_ } dwTlsIndex: DWORD): winbool; stdcall; external Kernel32_DLL;


function CreateProcessA(
    {_In_opt_ } lpApplicationName: LPCSTR;
    {_Inout_opt_ } lpCommandLine: LPSTR;
    {_In_opt_ } lpProcessAttributes: LPSECURITY_ATTRIBUTES;
    {_In_opt_ } lpThreadAttributes: LPSECURITY_ATTRIBUTES;
    {_In_ } bInheritHandles: winbool;
    {_In_ } dwCreationFlags: DWORD;
    {_In_opt_ } lpEnvironment: LPVOID;
    {_In_opt_ } lpCurrentDirectory: LPCSTR;
    {_In_ } lpStartupInfo: LPSTARTUPINFOA;
    {_Out_ } lpProcessInformation: LPPROCESS_INFORMATION): winbool; stdcall; external Kernel32_DLL;


function CreateProcessW(
    {_In_opt_ } lpApplicationName: LPCWSTR;
    {_Inout_opt_ } lpCommandLine: LPWSTR;
    {_In_opt_ } lpProcessAttributes: LPSECURITY_ATTRIBUTES;
    {_In_opt_ } lpThreadAttributes: LPSECURITY_ATTRIBUTES;
    {_In_ } bInheritHandles: winbool;
    {_In_ } dwCreationFlags: DWORD;
    {_In_opt_ } lpEnvironment: LPVOID;
    {_In_opt_ } lpCurrentDirectory: LPCWSTR;
    {_In_ } lpStartupInfo: LPSTARTUPINFOW;
    {_Out_ } lpProcessInformation: LPPROCESS_INFORMATION): winbool; stdcall; external Kernel32_DLL;


function SetProcessShutdownParameters(
    {_In_ } dwLevel: DWORD;
    {_In_ } dwFlags: DWORD): winbool; stdcall; external Kernel32_DLL;


function GetProcessVersion(
    {_In_ } ProcessId: DWORD): DWORD; stdcall; external Kernel32_DLL;


procedure GetStartupInfoW(
    {_Out_ } lpStartupInfo: LPSTARTUPINFOW); stdcall; external Kernel32_DLL;


function CreateProcessAsUserW(
    {_In_opt_ } hToken: HANDLE;
    {_In_opt_ } lpApplicationName: LPCWSTR;
    {_Inout_opt_ } lpCommandLine: LPWSTR;
    {_In_opt_ } lpProcessAttributes: LPSECURITY_ATTRIBUTES;
    {_In_opt_ } lpThreadAttributes: LPSECURITY_ATTRIBUTES;
    {_In_ } bInheritHandles: winbool;
    {_In_ } dwCreationFlags: DWORD;
    {_In_opt_ } lpEnvironment: LPVOID;
    {_In_opt_ } lpCurrentDirectory: LPCWSTR;
    {_In_ } lpStartupInfo: LPSTARTUPINFOW;
    {_Out_ } lpProcessInformation: LPPROCESS_INFORMATION): winbool; stdcall; external Kernel32_DLL;


// TODO: neerajsi-2013/12/08 - this should be moved to official documentation.

// These are shorthand ways of referring to the thread token, the process token,
// or the "effective token" (the thread token if it exists, otherwise the
// process token), respectively. These handles only have TOKEN_QUERY and
// TOKEN_QUERY_SOURCE access in Windows 8 (use TOKEN_ACCESS_PSEUDO_HANDLE to
// determine the granted access on the target version of Windows). These handles
// do not need to be closed.


function GetCurrentProcessToken(): HANDLE; inline;
function GetCurrentThreadToken(): HANDLE; inline;
function GetCurrentThreadEffectiveToken(): HANDLE; inline;


function SetThreadToken(
    {_In_opt_ } Thread: PHANDLE;
    {_In_opt_ } Token: HANDLE): winbool; stdcall; external Kernel32_DLL;


function OpenProcessToken(
    {_In_ } ProcessHandle: HANDLE;
    {_In_ } DesiredAccess: DWORD;
    {_Outptr_ } TokenHandle: PHANDLE): winbool; stdcall; external Kernel32_DLL;


function OpenThreadToken(
    {_In_ } ThreadHandle: HANDLE;
    {_In_ } DesiredAccess: DWORD;
    {_In_ } OpenAsSelf: winbool;
    {_Outptr_ } TokenHandle: PHANDLE): winbool; stdcall; external Kernel32_DLL;


function SetPriorityClass(
    {_In_ } hProcess: HANDLE;
    {_In_ } dwPriorityClass: DWORD): winbool; stdcall; external Kernel32_DLL;


function GetPriorityClass(
    {_In_ } hProcess: HANDLE): DWORD; stdcall; external Kernel32_DLL;


function SetThreadStackGuarantee(
    {_Inout_ } StackSizeInBytes: PULONG): winbool; stdcall; external Kernel32_DLL;


function ProcessIdToSessionId(
    {_In_ } dwProcessId: DWORD;
    {_Out_ } pSessionId: PDWORD): winbool; stdcall; external Kernel32_DLL;


function GetProcessId(
    {_In_ } Process: HANDLE): DWORD; stdcall; external Kernel32_DLL;


function GetThreadId(
    {_In_ } Thread: HANDLE): DWORD; stdcall; external Kernel32_DLL;


procedure FlushProcessWriteBuffers(); stdcall; external Kernel32_DLL;


function GetProcessIdOfThread(
    {_In_ } Thread: HANDLE): DWORD; stdcall; external Kernel32_DLL;


function InitializeProcThreadAttributeList(
    {_Out_writes_bytes_to_opt_(*lpSize,*lpSize) } lpAttributeList: LPPROC_THREAD_ATTRIBUTE_LIST;
    {_In_ } dwAttributeCount: DWORD;
    {_Reserved_ } dwFlags: DWORD; lpSize: PSIZE_T): winbool; stdcall; external Kernel32_DLL;


procedure DeleteProcThreadAttributeList(
    {_Inout_ } lpAttributeList: LPPROC_THREAD_ATTRIBUTE_LIST); stdcall; external Kernel32_DLL;


function UpdateProcThreadAttribute(
    {_Inout_ } lpAttributeList: LPPROC_THREAD_ATTRIBUTE_LIST;
    {_In_ } dwFlags: DWORD;
    {_In_ } Attribute: DWORD_PTR;
    {_In_reads_bytes_opt_(cbSize) } lpValue: PVOID;
    {_In_ } cbSize: SIZE_T;
    {_Out_writes_bytes_opt_(cbSize) } lpPreviousValue: PVOID;
    {_In_opt_ } lpReturnSize: PSIZE_T): winbool; stdcall; external Kernel32_DLL;


function SetProcessDynamicEHContinuationTargets(
    {_In_ } Process: HANDLE;
    {_In_ } NumberOfTargets: USHORT;
    {_Inout_updates_(NumberOfTargets) } Targets: PPROCESS_DYNAMIC_EH_CONTINUATION_TARGET): winbool; stdcall; external Kernel32_DLL;


function SetProcessDynamicEnforcedCetCompatibleRanges(
    {_In_ } Process: HANDLE;
    {_In_ } NumberOfRanges: USHORT;
    {_Inout_updates_(NumberOfRanges) } Ranges: PPROCESS_DYNAMIC_ENFORCED_ADDRESS_RANGE): winbool; stdcall; external Kernel32_DLL;


function SetProcessAffinityUpdateMode(
    {_In_ } hProcess: HANDLE;
    {_In_ } dwFlags: DWORD): winbool; stdcall; external Kernel32_DLL;


function QueryProcessAffinityUpdateMode(
    {_In_ } hProcess: HANDLE;
    {_Out_opt_ } lpdwFlags: LPDWORD): winbool; stdcall; external Kernel32_DLL;


function CreateRemoteThreadEx(
    {_In_ } hProcess: HANDLE;
    {_In_opt_ } lpThreadAttributes: LPSECURITY_ATTRIBUTES;
    {_In_ } dwStackSize: SIZE_T;
    {_In_ } lpStartAddress: LPTHREAD_START_ROUTINE;
    {_In_opt_ } lpParameter: LPVOID;
    {_In_ } dwCreationFlags: DWORD;
    {_In_opt_ } lpAttributeList: LPPROC_THREAD_ATTRIBUTE_LIST;
    {_Out_opt_ } lpThreadId: LPDWORD): HANDLE; stdcall; external Kernel32_DLL;


procedure GetCurrentThreadStackLimits(
    {_Out_ } LowLimit: PULONG_PTR;
    {_Out_ } HighLimit: PULONG_PTR); stdcall; external Kernel32_DLL;


function GetThreadContext(
    {_In_ } hThread: HANDLE;
    {_Inout_ } lpContext: LPCONTEXT): winbool; stdcall; external Kernel32_DLL;


function GetProcessMitigationPolicy(
    {_In_ } hProcess: HANDLE;
    {_In_ } MitigationPolicy: TPROCESS_MITIGATION_POLICY;
    {_Out_writes_bytes_(dwLength) } lpBuffer: PVOID;
    {_In_ } dwLength: SIZE_T): winbool; stdcall; external Kernel32_DLL;


function SetThreadContext(
    {_In_ } hThread: HANDLE;
    {_In_ } lpContext: PCONTEXT): winbool; stdcall; external Kernel32_DLL;


function SetProcessMitigationPolicy(
    {_In_ } MitigationPolicy: TPROCESS_MITIGATION_POLICY;
    {_In_reads_bytes_(dwLength) } lpBuffer: PVOID;
    {_In_ } dwLength: SIZE_T): winbool; stdcall; external Kernel32_DLL;


function FlushInstructionCache(
    {_In_ } hProcess: HANDLE;
    {_In_reads_bytes_opt_(dwSize) } lpBaseAddress: LPCVOID;
    {_In_ } dwSize: SIZE_T): winbool; stdcall; external Kernel32_DLL;


function GetThreadTimes(
    {_In_ } hThread: HANDLE;
    {_Out_ } lpCreationTime: LPFILETIME;
    {_Out_ } lpExitTime: LPFILETIME;
    {_Out_ } lpKernelTime: LPFILETIME;
    {_Out_ } lpUserTime: LPFILETIME): winbool; stdcall; external Kernel32_DLL;


function OpenProcess(
    {_In_ } dwDesiredAccess: DWORD;
    {_In_ } bInheritHandle: winbool;
    {_In_ } dwProcessId: DWORD): HANDLE; stdcall; external Kernel32_DLL;


function IsProcessorFeaturePresent(
    {_In_ } ProcessorFeature: DWORD): winbool; stdcall; external Kernel32_DLL;


function GetProcessHandleCount(
    {_In_ } hProcess: HANDLE;
    {_Out_ } pdwHandleCount: PDWORD): winbool; stdcall; external Kernel32_DLL;


function GetCurrentProcessorNumber(): DWORD; stdcall; external Kernel32_DLL;


function SetThreadIdealProcessorEx(
    {_In_ } hThread: HANDLE;
    {_In_ } lpIdealProcessor: PPROCESSOR_NUMBER;
    {_Out_opt_ } lpPreviousIdealProcessor: PPROCESSOR_NUMBER): winbool; stdcall; external Kernel32_DLL;


function GetThreadIdealProcessorEx(
    {_In_ } hThread: HANDLE;
    {_Out_ } lpIdealProcessor: PPROCESSOR_NUMBER): winbool; stdcall; external Kernel32_DLL;


procedure GetCurrentProcessorNumberEx(
    {_Out_ } ProcNumber: PPROCESSOR_NUMBER); stdcall; external Kernel32_DLL;


function GetProcessPriorityBoost(
    {_In_ } hProcess: HANDLE;
    {_Out_ } pDisablePriorityBoost: PWinBOOL): winbool; stdcall; external Kernel32_DLL;


function SetProcessPriorityBoost(
    {_In_ } hProcess: HANDLE;
    {_In_ } bDisablePriorityBoost: winbool): winbool; stdcall; external Kernel32_DLL;


function GetThreadIOPendingFlag(
    {_In_ } hThread: HANDLE;
    {_Out_ } lpIOIsPending: PwinBOOL): winbool; stdcall; external Kernel32_DLL;


function GetSystemTimes(
    {_Out_opt_ } lpIdleTime: PFILETIME;
    {_Out_opt_ } lpKernelTime: PFILETIME;
    {_Out_opt_ } lpUserTime: PFILETIME): winbool; stdcall; external Kernel32_DLL;


function GetThreadInformation(
    {_In_ } hThread: HANDLE;
    {_In_ } ThreadInformationClass: TTHREAD_INFORMATION_CLASS;
    {_Out_writes_bytes_(ThreadInformationSize) } ThreadInformation: LPVOID;
    {_In_ } ThreadInformationSize: DWORD): winbool; stdcall; external Kernel32_DLL;


function SetThreadInformation(
    {_In_ } hThread: HANDLE;
    {_In_ } ThreadInformationClass: TTHREAD_INFORMATION_CLASS;
    {_In_reads_bytes_(ThreadInformationSize) } ThreadInformation: LPVOID;
    {_In_ } ThreadInformationSize: DWORD): winbool; stdcall; external Kernel32_DLL;


function IsProcessCritical(
    {_In_ } hProcess: HANDLE;
    {_Out_ } Critical: PWinBOOL): winbool; stdcall; external Kernel32_DLL;


function SetProtectedPolicy(
    {_In_ } PolicyGuid: LPCGUID;
    {_In_ } PolicyValue: ULONG_PTR;
    {_Out_opt_ } OldPolicyValue: PULONG_PTR): winbool; stdcall; external Kernel32_DLL;


function QueryProtectedPolicy(
    {_In_ } PolicyGuid: LPCGUID;
    {_Out_ } PolicyValue: PULONG_PTR): winbool; stdcall; external Kernel32_DLL;


function SetThreadIdealProcessor(
    {_In_ } hThread: HANDLE;
    {_In_ } dwIdealProcessor: DWORD): DWORD; stdcall; external Kernel32_DLL;


function SetProcessInformation(
    {_In_ } hProcess: HANDLE;
    {_In_ } ProcessInformationClass: TPROCESS_INFORMATION_CLASS;
    {_In_reads_bytes_(ProcessInformationSize) } ProcessInformation: LPVOID;
    {_In_ } ProcessInformationSize: DWORD): winbool; stdcall; external Kernel32_DLL;


function GetProcessInformation(
    {_In_ } hProcess: HANDLE;
    {_In_ } ProcessInformationClass: TPROCESS_INFORMATION_CLASS;
    {_Out_writes_bytes_(ProcessInformationSize) } ProcessInformation: LPVOID;
    {_In_ } ProcessInformationSize: DWORD): winbool; stdcall; external Kernel32_DLL;


function GetSystemCpuSetInformation(
    {_Out_writes_bytes_to_opt_(BufferLength,*ReturnedLength) } Information: PSYSTEM_CPU_SET_INFORMATION;
    {_In_ } BufferLength: ULONG;
    {_Always_(_Out_) } ReturnedLength: PULONG;
    {_In_opt_ } Process: HANDLE;
    {_Reserved_ } Flags: ULONG): winbool; stdcall; external Kernel32_DLL;


function GetProcessDefaultCpuSets(
    {_In_ } Process: HANDLE;
    {_Out_writes_to_opt_(CpuSetIdCount,*RequiredIdCount) } CpuSetIds: PULONG;
    {_In_ } CpuSetIdCount: ULONG;
    {_Always_(_Out_) } RequiredIdCount: PULONG): winbool; stdcall; external Kernel32_DLL;


function SetProcessDefaultCpuSets(
    {_In_ } Process: HANDLE;
    {_In_reads_opt_(CpuSetIdCount) } CpuSetIds: PULONG;
    {_In_ } CpuSetIdCount: ULONG): winbool; stdcall; external Kernel32_DLL;


function GetThreadSelectedCpuSets(
    {_In_ } Thread: HANDLE;
    {_Out_writes_to_opt_(CpuSetIdCount,*RequiredIdCount) } CpuSetIds: PULONG;
    {_In_ } CpuSetIdCount: ULONG;
    {_Always_(_Out_) } RequiredIdCount: PULONG): winbool; stdcall; external Kernel32_DLL;


function SetThreadSelectedCpuSets(
    {_In_ } Thread: HANDLE;
    {_In_reads_(CpuSetIdCount) } CpuSetIds: PULONG;
    {_In_ } CpuSetIdCount: ULONG): winbool; stdcall; external Kernel32_DLL;


function CreateProcessAsUserA(
    {_In_opt_ } hToken: HANDLE;
    {_In_opt_ } lpApplicationName: LPCSTR;
    {_Inout_opt_ } lpCommandLine: LPSTR;
    {_In_opt_ } lpProcessAttributes: LPSECURITY_ATTRIBUTES;
    {_In_opt_ } lpThreadAttributes: LPSECURITY_ATTRIBUTES;
    {_In_ } bInheritHandles: winbool;
    {_In_ } dwCreationFlags: DWORD;
    {_In_opt_ } lpEnvironment: LPVOID;
    {_In_opt_ } lpCurrentDirectory: LPCSTR;
    {_In_ } lpStartupInfo: LPSTARTUPINFOA;
    {_Out_ } lpProcessInformation: LPPROCESS_INFORMATION): winbool; stdcall; external Kernel32_DLL;


function GetProcessShutdownParameters(
    {_Out_ } lpdwLevel: LPDWORD;
    {_Out_ } lpdwFlags: LPDWORD): winbool; stdcall; external Kernel32_DLL;


function GetProcessDefaultCpuSetMasks(
    {_In_ } Process: HANDLE;
    {_Out_writes_to_opt_(CpuSetMaskCount, *RequiredMaskCount) } CpuSetMasks: PGROUP_AFFINITY;
    {_In_ } CpuSetMaskCount: USHORT;
    {_Out_ } RequiredMaskCount: PUSHORT): winbool; stdcall; external Kernel32_DLL;


function SetProcessDefaultCpuSetMasks(
    {_In_ } Process: HANDLE;
    {_In_reads_opt_(CpuSetMaskCount) } CpuSetMasks: PGROUP_AFFINITY;
    {_In_ } CpuSetMaskCount: USHORT): winbool; stdcall; external Kernel32_DLL;


function GetThreadSelectedCpuSetMasks(
    {_In_ } Thread: HANDLE;
    {_Out_writes_to_opt_(CpuSetMaskCount, *RequiredMaskCount) } CpuSetMasks: PGROUP_AFFINITY;
    {_In_ } CpuSetMaskCount: USHORT;
    {_Out_ } RequiredMaskCount: PUSHORT): winbool; stdcall; external Kernel32_DLL;


function SetThreadSelectedCpuSetMasks(
    {_In_ } Thread: HANDLE;
    {_In_reads_opt_(CpuSetMaskCount) } CpuSetMasks: PGROUP_AFFINITY;
    {_In_ } CpuSetMaskCount: USHORT): winbool; stdcall; external Kernel32_DLL;


function GetMachineTypeAttributes(
    {_In_ } Machine: USHORT;
    {_Out_ } MachineTypeAttributes: PMACHINE_ATTRIBUTES): HRESULT; stdcall; external Kernel32_DLL;


function SetThreadDescription(
    {_In_ } hThread: HANDLE;
    {_In_ } lpThreadDescription: PCWSTR): HRESULT; stdcall; external Kernel32_DLL;


function GetThreadDescription(
    {_In_ } hThread: HANDLE;
    {_Outptr_result_z_ } out ppszThreadDescription: PWSTR): HRESULT; stdcall; external Kernel32_DLL;


function TlsGetValue2(
    {_In_ } dwTlsIndex: DWORD): LPVOID; stdcall; external Kernel32_DLL;


implementation



function GetCurrentProcessToken(): HANDLE;
begin
    Result := HANDLE(LONG_PTR(-4));
end;



function GetCurrentThreadToken(): HANDLE;
begin
    Result := HANDLE(LONG_PTR(-5));
end;



function GetCurrentThreadEffectiveToken(): HANDLE;
begin
    Result := HANDLE(LONG_PTR(-6));
end;


end.
