(************************************************************************
*                                                                       *
*   minwinbase.h -- This module defines the 32-Bit Windows Base APIs    *
*                                                                       *
*   Copyright (c) Microsoft Corp. All rights reserved.                  *
*                                                                       *
************************************************************************)
unit Win32.MinWinBase;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    Win32.WinNT,
    Win32.NTStatus;

    {$Z4}

const
    FIND_FIRST_EX_CASE_SENSITIVE = $00000001;
    FIND_FIRST_EX_LARGE_FETCH = $00000002;
    FIND_FIRST_EX_ON_DISK_ENTRIES_ONLY = $00000004;

    LOCKFILE_FAIL_IMMEDIATELY = $00000001;
    LOCKFILE_EXCLUSIVE_LOCK = $00000002;


    PROCESS_HEAP_REGION = $0001;
    PROCESS_HEAP_UNCOMMITTED_RANGE = $0002;
    PROCESS_HEAP_ENTRY_BUSY = $0004;
    PROCESS_HEAP_SEG_ALLOC = $0008;
    PROCESS_HEAP_ENTRY_MOVEABLE = $0010;
    PROCESS_HEAP_ENTRY_DDESHARE = $0020;


    // Debug APIs

    EXCEPTION_DEBUG_EVENT = 1;
    CREATE_THREAD_DEBUG_EVENT = 2;
    CREATE_PROCESS_DEBUG_EVENT = 3;
    EXIT_THREAD_DEBUG_EVENT = 4;
    EXIT_PROCESS_DEBUG_EVENT = 5;
    LOAD_DLL_DEBUG_EVENT = 6;
    UNLOAD_DLL_DEBUG_EVENT = 7;
    OUTPUT_DEBUG_STRING_EVENT = 8;
    RIP_EVENT = 9;

    (* compatibility macros *)
    STILL_ACTIVE = STATUS_PENDING;
    EXCEPTION_ACCESS_VIOLATION = STATUS_ACCESS_VIOLATION;
    EXCEPTION_DATATYPE_MISALIGNMENT = STATUS_DATATYPE_MISALIGNMENT;
    EXCEPTION_BREAKPOINT = STATUS_BREAKPOINT;
    EXCEPTION_SINGLE_STEP = STATUS_SINGLE_STEP;
    EXCEPTION_ARRAY_BOUNDS_EXCEEDED = STATUS_ARRAY_BOUNDS_EXCEEDED;
    EXCEPTION_FLT_DENORMAL_OPERAND = STATUS_FLOAT_DENORMAL_OPERAND;
    EXCEPTION_FLT_DIVIDE_BY_ZERO = STATUS_FLOAT_DIVIDE_BY_ZERO;
    EXCEPTION_FLT_INEXACT_RESULT = STATUS_FLOAT_INEXACT_RESULT;
    EXCEPTION_FLT_INVALID_OPERATION = STATUS_FLOAT_INVALID_OPERATION;
    EXCEPTION_FLT_OVERFLOW = STATUS_FLOAT_OVERFLOW;
    EXCEPTION_FLT_STACK_CHECK = STATUS_FLOAT_STACK_CHECK;
    EXCEPTION_FLT_UNDERFLOW = STATUS_FLOAT_UNDERFLOW;
    EXCEPTION_INT_DIVIDE_BY_ZERO = STATUS_INTEGER_DIVIDE_BY_ZERO;
    EXCEPTION_INT_OVERFLOW = STATUS_INTEGER_OVERFLOW;
    EXCEPTION_PRIV_INSTRUCTION = STATUS_PRIVILEGED_INSTRUCTION;
    EXCEPTION_IN_PAGE_ERROR = STATUS_IN_PAGE_ERROR;
    EXCEPTION_ILLEGAL_INSTRUCTION = STATUS_ILLEGAL_INSTRUCTION;
    EXCEPTION_NONCONTINUABLE_EXCEPTION = STATUS_NONCONTINUABLE_EXCEPTION;
    EXCEPTION_STACK_OVERFLOW = STATUS_STACK_OVERFLOW;
    EXCEPTION_INVALID_DISPOSITION = STATUS_INVALID_DISPOSITION;
    EXCEPTION_GUARD_PAGE = STATUS_GUARD_PAGE_VIOLATION;
    EXCEPTION_INVALID_HANDLE = STATUS_INVALID_HANDLE;
    EXCEPTION_POSSIBLE_DEADLOCK = STATUS_POSSIBLE_DEADLOCK;
    CONTROL_C_EXIT = STATUS_CONTROL_C_EXIT;

    (* Local Memory Flags *)
    LMEM_FIXED = $0000;
    LMEM_MOVEABLE = $0002;
    LMEM_NOCOMPACT = $0010;
    LMEM_NODISCARD = $0020;
    LMEM_ZEROINIT = $0040;
    LMEM_MODIFY = $0080;
    LMEM_DISCARDABLE = $0F00;
    LMEM_VALID_FLAGS = $0F72;
    LMEM_INVALID_HANDLE = $8000;

    LHND = (LMEM_MOVEABLE or LMEM_ZEROINIT);
    LPTR = (LMEM_FIXED or LMEM_ZEROINIT);

    NONZEROLHND = (LMEM_MOVEABLE);
    NONZEROLPTR = (LMEM_FIXED);

    (* Flags returned by LocalFlags (in addition to LMEM_DISCARDABLE) *)
    LMEM_DISCARDED = $4000;
    LMEM_LOCKCOUNT = $00FF;


    // NUMA values


    NUMA_NO_PREFERRED_NODE = DWORD(-1);

type

    // Typedefs

    _SECURITY_ATTRIBUTES = record
        nLength: DWORD;
        lpSecurityDescriptor: LPVOID;
        bInheritHandle: boolean;
    end;
    TSECURITY_ATTRIBUTES = _SECURITY_ATTRIBUTES;
    PSECURITY_ATTRIBUTES = ^TSECURITY_ATTRIBUTES;


    _OVERLAPPED = record
        Internal: ULONG_PTR;
        InternalHigh: ULONG_PTR;
        case integer of
            0: (
                Offset: DWORD;
                OffsetHigh: DWORD;
                hEvent: HANDLE;

            );
            1: (
                Pointer: PVOID;
            );
    end;
    TOVERLAPPED = _OVERLAPPED;
    POVERLAPPED = ^TOVERLAPPED;

    LPOVERLAPPED = ^TOVERLAPPED;

    _OVERLAPPED_ENTRY = record
        lpCompletionKey: ULONG_PTR;
        lpOverlapped: LPOVERLAPPED;
        Internal: ULONG_PTR;
        dwNumberOfBytesTransferred: DWORD;
    end;
    TOVERLAPPED_ENTRY = _OVERLAPPED_ENTRY;
    POVERLAPPED_ENTRY = ^TOVERLAPPED_ENTRY;
    LPOVERLAPPED_ENTRY = ^TOVERLAPPED_ENTRY;


    //  File System time stamps are represented with the following structure:


    _FILETIME = record
        dwLowDateTime: DWORD;
        dwHighDateTime: DWORD;
    end;
    TFILETIME = _FILETIME;
    PFILETIME = ^TFILETIME;
    LPFILETIME = ^TFILETIME;


    // System time is represented with the following structure:


    _SYSTEMTIME = record
        wYear: word;
        wMonth: word;
        wDayOfWeek: word;
        wDay: word;
        wHour: word;
        wMinute: word;
        wSecond: word;
        wMilliseconds: word;
    end;
    TSYSTEMTIME = _SYSTEMTIME;
    PSYSTEMTIME = ^TSYSTEMTIME;
    LPSYSTEMTIME = ^TSYSTEMTIME;


    _WIN32_FIND_DATAA = record
        dwFileAttributes: DWORD;
        ftCreationTime: TFILETIME;
        ftLastAccessTime: TFILETIME;
        ftLastWriteTime: TFILETIME;
        nFileSizeHigh: DWORD;
        nFileSizeLow: DWORD;
        dwReserved0: DWORD;
        dwReserved1: DWORD;
        {_Field_z_ } cFileName: array [0..MAX_PATH - 1] of TCHAR;
        {_Field_z_ } cAlternateFileName: array [0..14 - 1] of TCHAR;
    end;
    TWIN32_FIND_DATAA = _WIN32_FIND_DATAA;
    PWIN32_FIND_DATAA = ^TWIN32_FIND_DATAA;
    LPWIN32_FIND_DATAA = ^TWIN32_FIND_DATAA;

    _WIN32_FIND_DATAW = record
        dwFileAttributes: DWORD;
        ftCreationTime: TFILETIME;
        ftLastAccessTime: TFILETIME;
        ftLastWriteTime: TFILETIME;
        nFileSizeHigh: DWORD;
        nFileSizeLow: DWORD;
        dwReserved0: DWORD;
        dwReserved1: DWORD;
        {_Field_z_ } cFileName: array [0..MAX_PATH - 1] of WCHAR;
        {_Field_z_ } cAlternateFileName: array [0..14 - 1] of WCHAR;
    end;
    TWIN32_FIND_DATAW = _WIN32_FIND_DATAW;
    PWIN32_FIND_DATAW = ^TWIN32_FIND_DATAW;
    LPWIN32_FIND_DATAW = ^TWIN32_FIND_DATAW;

    _FINDEX_INFO_LEVELS = (
        FindExInfoStandard,
        FindExInfoBasic,
        FindExInfoMaxInfoLevel);

    TFINDEX_INFO_LEVELS = _FINDEX_INFO_LEVELS;
    PFINDEX_INFO_LEVELS = ^TFINDEX_INFO_LEVELS;


    _FINDEX_SEARCH_OPS = (
        FindExSearchNameMatch,
        FindExSearchLimitToDirectories,
        FindExSearchLimitToDevices,
        FindExSearchMaxSearchOp);

    TFINDEX_SEARCH_OPS = _FINDEX_SEARCH_OPS;
    PFINDEX_SEARCH_OPS = ^TFINDEX_SEARCH_OPS;


    _READ_DIRECTORY_NOTIFY_INFORMATION_CLASS = (
        ReadDirectoryNotifyInformation = 1,
        ReadDirectoryNotifyExtendedInformation, // 2
        ReadDirectoryNotifyFullInformation, // 3
        // add new classes above
        ReadDirectoryNotifyMaximumInformation);

    TREAD_DIRECTORY_NOTIFY_INFORMATION_CLASS = _READ_DIRECTORY_NOTIFY_INFORMATION_CLASS;
    PREAD_DIRECTORY_NOTIFY_INFORMATION_CLASS = ^TREAD_DIRECTORY_NOTIFY_INFORMATION_CLASS;


    _GET_FILEEX_INFO_LEVELS = (
        GetFileExInfoStandard,
        GetFileExMaxInfoLevel);

    TGET_FILEEX_INFO_LEVELS = _GET_FILEEX_INFO_LEVELS;
    PGET_FILEEX_INFO_LEVELS = ^TGET_FILEEX_INFO_LEVELS;


    _FILE_INFO_BY_HANDLE_CLASS = (
        FileBasicInfo,
        FileStandardInfo,
        FileNameInfo,
        FileRenameInfo,
        FileDispositionInfo,
        FileAllocationInfo,
        FileEndOfFileInfo,
        FileStreamInfo,
        FileCompressionInfo,
        FileAttributeTagInfo,
        FileIdBothDirectoryInfo,
        FileIdBothDirectoryRestartInfo,
        FileIoPriorityHintInfo,
        FileRemoteProtocolInfo,
        FileFullDirectoryInfo,
        FileFullDirectoryRestartInfo,
        FileStorageInfo,
        FileAlignmentInfo,
        FileIdInfo,
        FileIdExtdDirectoryInfo,
        FileIdExtdDirectoryRestartInfo,
        FileDispositionInfoEx,
        FileRenameInfoEx,
        FileCaseSensitiveInfo,
        FileNormalizedNameInfo,
        MaximumFileInfoByHandleClass);

    TFILE_INFO_BY_HANDLE_CLASS = _FILE_INFO_BY_HANDLE_CLASS;
    PFILE_INFO_BY_HANDLE_CLASS = ^TFILE_INFO_BY_HANDLE_CLASS;


    _FILE_INFO_BY_NAME_CLASS = (
        FileStatByNameInfo,
        FileStatLxByNameInfo,
        FileCaseSensitiveByNameInfo,
        FileStatBasicByNameInfo,
        MaximumFileInfoByNameClass);

    TFILE_INFO_BY_NAME_CLASS = _FILE_INFO_BY_NAME_CLASS;
    PFILE_INFO_BY_NAME_CLASS = ^TFILE_INFO_BY_NAME_CLASS;


    TCRITICAL_SECTION = TRTL_CRITICAL_SECTION;
    PCRITICAL_SECTION = PRTL_CRITICAL_SECTION;
    LPCRITICAL_SECTION = PRTL_CRITICAL_SECTION;

    TCRITICAL_SECTION_DEBUG = TRTL_CRITICAL_SECTION_DEBUG;
    PCRITICAL_SECTION_DEBUG = PRTL_CRITICAL_SECTION_DEBUG;
    LPCRITICAL_SECTION_DEBUG = PRTL_CRITICAL_SECTION_DEBUG;


    LPOVERLAPPED_COMPLETION_ROUTINE = procedure(
        {_In_    } dwErrorCode: DWORD;
        {_In_    } dwNumberOfBytesTransfered: DWORD;
        {_Inout_ } lpOverlapped: LPOVERLAPPED); stdcall;


    _PROCESS_HEAP_ENTRY = record
        lpData: PVOID;
        cbData: DWORD;
        cbOverhead: byte;
        iRegionIndex: byte;
        wFlags: word;
        case integer of
            0: (Block: record
                    hMem: HANDLE;
                    dwReserved: array [0..3 - 1] of DWORD;
                    end;
            );
            1: (
                Region: record
                    dwCommittedSize: DWORD;
                    dwUnCommittedSize: DWORD;
                    lpFirstBlock: LPVOID;
                    lpLastBlock: LPVOID;
                    end;)
    end;
    TPROCESS_HEAP_ENTRY = _PROCESS_HEAP_ENTRY;
    PPROCESS_HEAP_ENTRY = ^TPROCESS_HEAP_ENTRY;
    LPPROCESS_HEAP_ENTRY = ^TPROCESS_HEAP_ENTRY;


    _REASON_CONTEXT = record
        Version: ULONG;
        Flags: DWORD;
        case integer of
            0: (
                Detailed: record
                    LocalizedReasonModule: HMODULE;
                    LocalizedReasonId: ULONG;
                    ReasonStringCount: ULONG;
                    ReasonStrings: PLPWSTR;
                    end;
            );
            1: (
                SimpleReasonString: LPWSTR;
            );
    end;
    TREASON_CONTEXT = _REASON_CONTEXT;
    PREASON_CONTEXT = ^TREASON_CONTEXT;


    PTHREAD_START_ROUTINE = function(lpThreadParameter: LPVOID): DWORD; stdcall;

    LPTHREAD_START_ROUTINE = PTHREAD_START_ROUTINE;

    PENCLAVE_ROUTINE = function(lpThreadParameter: LPVOID): LPVOID; stdcall;

    LPENCLAVE_ROUTINE = PENCLAVE_ROUTINE;

    _EXCEPTION_DEBUG_INFO = record
        ExceptionRecord: TEXCEPTION_RECORD;
        dwFirstChance: DWORD;
    end;
    TEXCEPTION_DEBUG_INFO = _EXCEPTION_DEBUG_INFO;
    PEXCEPTION_DEBUG_INFO = ^TEXCEPTION_DEBUG_INFO;

    LPEXCEPTION_DEBUG_INFO = ^TEXCEPTION_DEBUG_INFO;

    _CREATE_THREAD_DEBUG_INFO = record
        hThread: HANDLE;
        lpThreadLocalBase: LPVOID;
        lpStartAddress: LPTHREAD_START_ROUTINE;
    end;
    TCREATE_THREAD_DEBUG_INFO = _CREATE_THREAD_DEBUG_INFO;
    PCREATE_THREAD_DEBUG_INFO = ^TCREATE_THREAD_DEBUG_INFO;

    LPCREATE_THREAD_DEBUG_INFO = ^TCREATE_THREAD_DEBUG_INFO;

    _CREATE_PROCESS_DEBUG_INFO = record
        hFile: HANDLE;
        hProcess: HANDLE;
        hThread: HANDLE;
        lpBaseOfImage: LPVOID;
        dwDebugInfoFileOffset: DWORD;
        nDebugInfoSize: DWORD;
        lpThreadLocalBase: LPVOID;
        lpStartAddress: LPTHREAD_START_ROUTINE;
        lpImageName: LPVOID;
        fUnicode: word;
    end;
    TCREATE_PROCESS_DEBUG_INFO = _CREATE_PROCESS_DEBUG_INFO;
    PCREATE_PROCESS_DEBUG_INFO = ^TCREATE_PROCESS_DEBUG_INFO;

    LPCREATE_PROCESS_DEBUG_INFO = ^TCREATE_PROCESS_DEBUG_INFO;

    _EXIT_THREAD_DEBUG_INFO = record
        dwExitCode: DWORD;
    end;
    TEXIT_THREAD_DEBUG_INFO = _EXIT_THREAD_DEBUG_INFO;
    PEXIT_THREAD_DEBUG_INFO = ^TEXIT_THREAD_DEBUG_INFO;

    LPEXIT_THREAD_DEBUG_INFO = ^TEXIT_THREAD_DEBUG_INFO;

    _EXIT_PROCESS_DEBUG_INFO = record
        dwExitCode: DWORD;
    end;
    TEXIT_PROCESS_DEBUG_INFO = _EXIT_PROCESS_DEBUG_INFO;
    PEXIT_PROCESS_DEBUG_INFO = ^TEXIT_PROCESS_DEBUG_INFO;

    LPEXIT_PROCESS_DEBUG_INFO = ^TEXIT_PROCESS_DEBUG_INFO;

    _LOAD_DLL_DEBUG_INFO = record
        hFile: HANDLE;
        lpBaseOfDll: LPVOID;
        dwDebugInfoFileOffset: DWORD;
        nDebugInfoSize: DWORD;
        lpImageName: LPVOID;
        fUnicode: word;
    end;
    TLOAD_DLL_DEBUG_INFO = _LOAD_DLL_DEBUG_INFO;
    PLOAD_DLL_DEBUG_INFO = ^TLOAD_DLL_DEBUG_INFO;

    LPLOAD_DLL_DEBUG_INFO = ^TLOAD_DLL_DEBUG_INFO;

    _UNLOAD_DLL_DEBUG_INFO = record
        lpBaseOfDll: LPVOID;
    end;
    TUNLOAD_DLL_DEBUG_INFO = _UNLOAD_DLL_DEBUG_INFO;
    PUNLOAD_DLL_DEBUG_INFO = ^TUNLOAD_DLL_DEBUG_INFO;

    LPUNLOAD_DLL_DEBUG_INFO = ^TUNLOAD_DLL_DEBUG_INFO;

    _OUTPUT_DEBUG_STRING_INFO = record
        lpDebugStringData: LPSTR;
        fUnicode: word;
        nDebugStringLength: word;
    end;
    TOUTPUT_DEBUG_STRING_INFO = _OUTPUT_DEBUG_STRING_INFO;
    POUTPUT_DEBUG_STRING_INFO = ^TOUTPUT_DEBUG_STRING_INFO;

    LPOUTPUT_DEBUG_STRING_INFO = ^TOUTPUT_DEBUG_STRING_INFO;

    _RIP_INFO = record
        dwError: DWORD;
        dwType: DWORD;
    end;
    TRIP_INFO = _RIP_INFO;
    PRIP_INFO = ^TRIP_INFO;

    LPRIP_INFO = ^TRIP_INFO;


    _DEBUG_EVENT = record
        dwDebugEventCode: DWORD;
        dwProcessId: DWORD;
        dwThreadId: DWORD;
        case integer of
            0: (
                Exception: TEXCEPTION_DEBUG_INFO;
            );
            1: (
                CreateThread: TCREATE_THREAD_DEBUG_INFO;
            );
            2: (
                CreateProcessInfo: TCREATE_PROCESS_DEBUG_INFO;
            );
            3: (
                ExitThread: TEXIT_THREAD_DEBUG_INFO;
            );
            4: (
                ExitProcess: TEXIT_PROCESS_DEBUG_INFO;
            );
            5: (
                LoadDll: TLOAD_DLL_DEBUG_INFO;
            );
            6: (
                UnloadDll: TUNLOAD_DLL_DEBUG_INFO;
            );
            7: (
                DebugString: TOUTPUT_DEBUG_STRING_INFO;
            );
            8: (
                RipInfo: TRIP_INFO;
            );

    end;
    TDEBUG_EVENT = _DEBUG_EVENT;
    PDEBUG_EVENT = ^TDEBUG_EVENT;

    LPDEBUG_EVENT = ^TDEBUG_EVENT;

implementation

end.
