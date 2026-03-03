(********************************************************************************
*                                                                               *
* FileApi.h -- ApiSet Contract for api-ms-win-core-file-l1                      *
*                                                                               *
* Copyright (c) Microsoft Corporation. All rights reserved.                     *
*                                                                               *
********************************************************************************)
unit Win32.FileApi;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    Win32.MinWinBase;

    {$DEFINE NTDDI_WIN10_FE}
    {$DEFINE NTDDI_WIN10_RS5}
    {$DEFINE NTDDI_WIN11_GE}

const
    KERNEL32_DLL = 'Kernel32.dll';

    // Constants

    CREATE_NEW = 1;
    CREATE_ALWAYS = 2;
    OPEN_EXISTING = 3;
    OPEN_ALWAYS = 4;
    TRUNCATE_EXISTING = 5;

    INVALID_FILE_SIZE = DWORD($FFFFFFFF);
    INVALID_SET_FILE_POINTER = DWORD(-1);
    INVALID_FILE_ATTRIBUTES = DWORD(-1);

type

    PVOID64 = PUINT64;


    // Define segment buffer structure for scatter/gather read/write.


    TFILE_SEGMENT_ELEMENT = record
        case integer of
            0: (
                Buffer: PVOID64;);
            1: (
                Alignment: ULONGLONG;);
    end;

    PFILE_SEGMENT_ELEMENT = ^TFILE_SEGMENT_ELEMENT;

    //  The structure definition must be same as the one
    //  (FILE_FS_FULL_SIZE_INFORMATION_EX) defined in ntioapi_x.w


    TDISK_SPACE_INFORMATION = record

        //  AllocationUnits are actually file system clusters.
        //  AllocationUnits * SectorsPerAllocationUnit * BytesPerSector
        //  will get you the sizes in bytes.


        //  The Actual*AllocationUnits are volume sizes without considering Quota
        //  setting.
        //  ActualPoolUnavailableAllocationUnits is the unavailable space for the
        //  volume due to insufficient free pool space (PoolAvailableAllocationUnits).
        //  Be aware AllocationUnits are mesured in clusters, see comments at the beginning.

        //  ActualTotalAllocationUnits = ActualAvailableAllocationUnits +
        //                               ActualPoolUnavailableAllocationUnits +
        //                               UsedAllocationUnits +
        //                               TotalReservedAllocationUnits

        ActualTotalAllocationUnits: ULONGLONG;
        ActualAvailableAllocationUnits: ULONGLONG;
        ActualPoolUnavailableAllocationUnits: ULONGLONG;

        //  The Caller*AllocationUnits are limited by Quota setting.
        //  CallerPoolUnavailableAllocationUnits is the unavailable space for the
        //  volume due to insufficient free pool space (PoolAvailableAllocationUnits).
        //  Be aware AllocationUnits are mesured in clusters, see comments at the beginning.

        //  CallerTotalAllocationUnits = CallerAvailableAllocationUnits +
        //                               CallerPoolUnavailableAllocationUnits +
        //                               UsedAllocationUnits +
        //                               TotalReservedAllocationUnits

        CallerTotalAllocationUnits: ULONGLONG;
        CallerAvailableAllocationUnits: ULONGLONG;
        CallerPoolUnavailableAllocationUnits: ULONGLONG;

        //  The used space (in clusters) of the volume.

        UsedAllocationUnits: ULONGLONG;

        //  Total reserved space (in clusters).

        TotalReservedAllocationUnits: ULONGLONG;

        //  A special type of reserved space (in clusters) for per-volume storage
        //  reserve and this is included in the above TotalReservedAllocationUnits.

        VolumeStorageReserveAllocationUnits: ULONGLONG;

        //  This refers to the space (in clusters) that has been committed by
        //  storage pool but has not been allocated by file system.

        //  s1 = (ActualTotalAllocationUnits - UsedAllocationUnits - TotalReservedAllocationUnits)
        //  s2 = (AvailableCommittedAllocationUnits + PoolAvailableAllocationUnits)
        //  ActualAvailableAllocationUnits = min( s1, s2 )

        //  When s1 >= s2, ActualPoolUnavailableAllocationUnits = 0
        //  When s1 < s2, ActualPoolUnavailableAllocationUnits = s2 - s1.

        AvailableCommittedAllocationUnits: ULONGLONG;

        //  Available space (in clusters) in corresponding storage pool. If the volume
        //  is not a spaces volume, the PoolAvailableAllocationUnits is set to zero.

        PoolAvailableAllocationUnits: ULONGLONG;
        SectorsPerAllocationUnit: DWORD;
        BytesPerSector: DWORD;
    end;
    PDISK_SPACE_INFORMATION = ^TDISK_SPACE_INFORMATION;


    _WIN32_FILE_ATTRIBUTE_DATA = record
        dwFileAttributes: DWORD;
        ftCreationTime: TFILETIME;
        ftLastAccessTime: TFILETIME;
        ftLastWriteTime: TFILETIME;
        nFileSizeHigh: DWORD;
        nFileSizeLow: DWORD;
    end;
    TWIN32_FILE_ATTRIBUTE_DATA = _WIN32_FILE_ATTRIBUTE_DATA;
    PWIN32_FILE_ATTRIBUTE_DATA = ^TWIN32_FILE_ATTRIBUTE_DATA;

    LPWIN32_FILE_ATTRIBUTE_DATA = ^TWIN32_FILE_ATTRIBUTE_DATA;


    _BY_HANDLE_FILE_INFORMATION = record
        dwFileAttributes: DWORD;
        ftCreationTime: TFILETIME;
        ftLastAccessTime: TFILETIME;
        ftLastWriteTime: TFILETIME;
        dwVolumeSerialNumber: DWORD;
        nFileSizeHigh: DWORD;
        nFileSizeLow: DWORD;
        nNumberOfLinks: DWORD;
        nFileIndexHigh: DWORD;
        nFileIndexLow: DWORD;
    end;
    TBY_HANDLE_FILE_INFORMATION = _BY_HANDLE_FILE_INFORMATION;
    PBY_HANDLE_FILE_INFORMATION = ^TBY_HANDLE_FILE_INFORMATION;
    LPBY_HANDLE_FILE_INFORMATION = ^TBY_HANDLE_FILE_INFORMATION;


    _CREATEFILE2_EXTENDED_PARAMETERS = record
        dwSize: DWORD;
        dwFileAttributes: DWORD;
        dwFileFlags: DWORD;
        dwSecurityQosFlags: DWORD;
        lpSecurityAttributes: LPSECURITY_ATTRIBUTES;
        hTemplateFile: HANDLE;
    end;
    TCREATEFILE2_EXTENDED_PARAMETERS = _CREATEFILE2_EXTENDED_PARAMETERS;
    PCREATEFILE2_EXTENDED_PARAMETERS = ^TCREATEFILE2_EXTENDED_PARAMETERS;
    LPCREATEFILE2_EXTENDED_PARAMETERS = ^TCREATEFILE2_EXTENDED_PARAMETERS;


    _STREAM_INFO_LEVELS = (
        FindStreamInfoStandard,
        FindStreamInfoMaxInfoLevel);

    TSTREAM_INFO_LEVELS = _STREAM_INFO_LEVELS;
    PSTREAM_INFO_LEVELS = ^TSTREAM_INFO_LEVELS;


    _WIN32_FIND_STREAM_DATA = record
        StreamSize: LARGE_INTEGER;
        cStreamName: array [0..MAX_PATH + 36 - 1] of WCHAR;
    end;
    TWIN32_FIND_STREAM_DATA = _WIN32_FIND_STREAM_DATA;
    PWIN32_FIND_STREAM_DATA = ^TWIN32_FIND_STREAM_DATA;


    _CREATEFILE3_EXTENDED_PARAMETERS = record
        dwSize: DWORD;
        dwFileAttributes: DWORD;
        dwFileFlags: DWORD;
        dwSecurityQosFlags: DWORD;
        lpSecurityAttributes: LPSECURITY_ATTRIBUTES;
        hTemplateFile: HANDLE;
    end;
    TCREATEFILE3_EXTENDED_PARAMETERS = _CREATEFILE3_EXTENDED_PARAMETERS;
    PCREATEFILE3_EXTENDED_PARAMETERS = ^TCREATEFILE3_EXTENDED_PARAMETERS;
    LPCREATEFILE3_EXTENDED_PARAMETERS = ^TCREATEFILE3_EXTENDED_PARAMETERS;

    TDIRECTORY_FLAGS = (
        DIRECTORY_FLAGS_NONE = 0,
        DIRECTORY_FLAGS_DISALLOW_PATH_REDIRECTS = $000000001);

    PDIRECTORY_FLAGS = ^TDIRECTORY_FLAGS;


function CompareFileTime(
    {_In_ } lpFileTime1: PFILETIME;
    {_In_ } lpFileTime2: PFILETIME): LONG; stdcall; external KERNEL32_DLL;


function CreateDirectoryA(
    {_In_ } lpPathName: LPCSTR;
    {_In_opt_ } lpSecurityAttributes: LPSECURITY_ATTRIBUTES): winbool; stdcall; external KERNEL32_DLL;


function CreateDirectoryW(
    {_In_ } lpPathName: LPCWSTR;
    {_In_opt_ } lpSecurityAttributes: LPSECURITY_ATTRIBUTES): winbool; stdcall; external KERNEL32_DLL;


function CreateFileA(
    {_In_ } lpFileName: LPCSTR;
    {_In_ } dwDesiredAccess: DWORD;
    {_In_ } dwShareMode: DWORD;
    {_In_opt_ } lpSecurityAttributes: LPSECURITY_ATTRIBUTES;
    {_In_ } dwCreationDisposition: DWORD;
    {_In_ } dwFlagsAndAttributes: DWORD;
    {_In_opt_ } hTemplateFile: HANDLE): HANDLE; stdcall; external KERNEL32_DLL;


function CreateFileW(
    {_In_ } lpFileName: LPCWSTR;
    {_In_ } dwDesiredAccess: DWORD;
    {_In_ } dwShareMode: DWORD;
    {_In_opt_ } lpSecurityAttributes: LPSECURITY_ATTRIBUTES;
    {_In_ } dwCreationDisposition: DWORD;
    {_In_ } dwFlagsAndAttributes: DWORD;
    {_In_opt_ } hTemplateFile: HANDLE): HANDLE; stdcall; external KERNEL32_DLL;


function DefineDosDeviceW(
    {_In_ } dwFlags: DWORD;
    {_In_ } lpDeviceName: LPCWSTR;
    {_In_opt_ } lpTargetPath: LPCWSTR): winbool; stdcall; external KERNEL32_DLL;


function DeleteFileA(
    {_In_ } lpFileName: LPCSTR): winbool; stdcall; external KERNEL32_DLL;


function DeleteFileW(
    {_In_ } lpFileName: LPCWSTR): winbool; stdcall; external KERNEL32_DLL;


function DeleteVolumeMountPointW(
    {_In_ } lpszVolumeMountPoint: LPCWSTR): winbool; stdcall; external KERNEL32_DLL;


function FileTimeToLocalFileTime(
    {_In_ } lpFileTime: PFILETIME;
    {_Out_ } lpLocalFileTime: LPFILETIME): winbool; stdcall; external KERNEL32_DLL;


function FindClose(
    {_Inout_ } hFindFile: HANDLE): winbool; stdcall; external KERNEL32_DLL;


function FindCloseChangeNotification(
    {_In_ } hChangeHandle: HANDLE): winbool; stdcall; external KERNEL32_DLL;


function FindFirstChangeNotificationA(
    {_In_ } lpPathName: LPCSTR;
    {_In_ } bWatchSubtree: winbool;
    {_In_ } dwNotifyFilter: DWORD): HANDLE; stdcall; external KERNEL32_DLL;


function FindFirstChangeNotificationW(
    {_In_ } lpPathName: LPCWSTR;
    {_In_ } bWatchSubtree: winbool;
    {_In_ } dwNotifyFilter: DWORD): HANDLE; stdcall; external KERNEL32_DLL;


function FindFirstFileA(
    {_In_ } lpFileName: LPCSTR;
    {_Out_ } lpFindFileData: LPWIN32_FIND_DATAA): HANDLE; stdcall; external KERNEL32_DLL;


function FindFirstFileW(
    {_In_ } lpFileName: LPCWSTR;
    {_Out_ } lpFindFileData: LPWIN32_FIND_DATAW): HANDLE; stdcall; external KERNEL32_DLL;


function FindFirstFileExA(
    {_In_ } lpFileName: LPCSTR;
    {_In_ } fInfoLevelId: TFINDEX_INFO_LEVELS;
    {_Out_writes_bytes_(sizeof(WIN32_FIND_DATAA)) } lpFindFileData: LPVOID;
    {_In_ } fSearchOp: TFINDEX_SEARCH_OPS;
    {_Reserved_ } lpSearchFilter: LPVOID;
    {_In_ } dwAdditionalFlags: DWORD): HANDLE; stdcall; external KERNEL32_DLL;


function FindFirstFileExW(
    {_In_ } lpFileName: LPCWSTR;
    {_In_ } fInfoLevelId: TFINDEX_INFO_LEVELS;
    {_Out_writes_bytes_(sizeof(WIN32_FIND_DATAW)) } lpFindFileData: LPVOID;
    {_In_ } fSearchOp: TFINDEX_SEARCH_OPS;
    {_Reserved_ } lpSearchFilter: LPVOID;
    {_In_ } dwAdditionalFlags: DWORD): HANDLE; stdcall; external KERNEL32_DLL;


function FindFirstVolumeW(
    {_Out_writes_(cchBufferLength) } lpszVolumeName: LPWSTR;
    {_In_ } cchBufferLength: DWORD): HANDLE; stdcall; external KERNEL32_DLL;


function FindNextChangeNotification(
    {_In_ } hChangeHandle: HANDLE): winbool; stdcall; external KERNEL32_DLL;


function FindNextFileA(
    {_In_ } hFindFile: HANDLE;
    {_Out_ } lpFindFileData: LPWIN32_FIND_DATAA): winbool; stdcall; external KERNEL32_DLL;


function FindNextFileW(
    {_In_ } hFindFile: HANDLE;
    {_Out_ } lpFindFileData: LPWIN32_FIND_DATAW): winbool; stdcall; external KERNEL32_DLL;


function FindNextVolumeW(
    {_Inout_ } hFindVolume: HANDLE;
    {_Out_writes_(cchBufferLength) } lpszVolumeName: LPWSTR;
    {_In_ } cchBufferLength: DWORD): winbool; stdcall; external KERNEL32_DLL;


function FindVolumeClose(
    {_In_ } hFindVolume: HANDLE): winbool; stdcall; external KERNEL32_DLL;


function FlushFileBuffers(
    {_In_ } hFile: HANDLE): winbool; stdcall; external KERNEL32_DLL;


function GetDiskFreeSpaceA(
    {_In_opt_ } lpRootPathName: LPCSTR;
    {_Out_opt_ } lpSectorsPerCluster: LPDWORD;
    {_Out_opt_ } lpBytesPerSector: LPDWORD;
    {_Out_opt_ } lpNumberOfFreeClusters: LPDWORD;
    {_Out_opt_ } lpTotalNumberOfClusters: LPDWORD): winbool; stdcall; external KERNEL32_DLL;


function GetDiskFreeSpaceW(
    {_In_opt_ } lpRootPathName: LPCWSTR;
    {_Out_opt_ } lpSectorsPerCluster: LPDWORD;
    {_Out_opt_ } lpBytesPerSector: LPDWORD;
    {_Out_opt_ } lpNumberOfFreeClusters: LPDWORD;
    {_Out_opt_ } lpTotalNumberOfClusters: LPDWORD): winbool; stdcall; external KERNEL32_DLL;


function GetDiskFreeSpaceExA(
    {_In_opt_ } lpDirectoryName: LPCSTR;
    {_Out_opt_ } lpFreeBytesAvailableToCaller: PULARGE_INTEGER;
    {_Out_opt_ } lpTotalNumberOfBytes: PULARGE_INTEGER;
    {_Out_opt_ } lpTotalNumberOfFreeBytes: PULARGE_INTEGER): winbool; stdcall; external KERNEL32_DLL;


function GetDiskFreeSpaceExW(
    {_In_opt_ } lpDirectoryName: LPCWSTR;
    {_Out_opt_ } lpFreeBytesAvailableToCaller: PULARGE_INTEGER;
    {_Out_opt_ } lpTotalNumberOfBytes: PULARGE_INTEGER;
    {_Out_opt_ } lpTotalNumberOfFreeBytes: PULARGE_INTEGER): winbool; stdcall; external KERNEL32_DLL;


function GetDiskSpaceInformationA(
    {_In_opt_ } rootPath: LPCSTR;
    {_Out_ } diskSpaceInfo: PDISK_SPACE_INFORMATION): HRESULT; stdcall; external KERNEL32_DLL;


function GetDiskSpaceInformationW(
    {_In_opt_ } rootPath: LPCWSTR;
    {_Out_ } diskSpaceInfo: PDISK_SPACE_INFORMATION): HRESULT; stdcall; external KERNEL32_DLL;


function GetDriveTypeA(
    {_In_opt_ } lpRootPathName: LPCSTR): UINT; stdcall; external KERNEL32_DLL;


function GetDriveTypeW(
    {_In_opt_ } lpRootPathName: LPCWSTR): UINT; stdcall; external KERNEL32_DLL;


function GetFileAttributesA(
    {_In_ } lpFileName: LPCSTR): DWORD; stdcall; external KERNEL32_DLL;


function GetFileAttributesW(
    {_In_ } lpFileName: LPCWSTR): DWORD; stdcall; external KERNEL32_DLL;


function GetFileAttributesExA(
    {_In_ } lpFileName: LPCSTR;
    {_In_ } fInfoLevelId: TGET_FILEEX_INFO_LEVELS;
    {_Out_writes_bytes_(sizeof(WIN32_FILE_ATTRIBUTE_DATA)) } lpFileInformation: LPVOID): winbool; stdcall; external KERNEL32_DLL;


function GetFileAttributesExW(
    {_In_ } lpFileName: LPCWSTR;
    {_In_ } fInfoLevelId: TGET_FILEEX_INFO_LEVELS;
    {_Out_writes_bytes_(sizeof(WIN32_FILE_ATTRIBUTE_DATA)) } lpFileInformation: LPVOID): winbool; stdcall; external KERNEL32_DLL;


function GetFileInformationByHandle(
    {_In_ } hFile: HANDLE;
    {_Out_ } lpFileInformation: LPBY_HANDLE_FILE_INFORMATION): winbool; stdcall; external KERNEL32_DLL;


function GetFileSize(
    {_In_ } hFile: HANDLE;
    {_Out_opt_ } lpFileSizeHigh: LPDWORD): DWORD; stdcall; external KERNEL32_DLL;


function GetFileSizeEx(
    {_In_ } hFile: HANDLE;
    {_Out_ } lpFileSize: PLARGE_INTEGER): winbool; stdcall; external KERNEL32_DLL;


function GetFileType(
    {_In_ } hFile: HANDLE): DWORD; stdcall; external KERNEL32_DLL;


function GetFinalPathNameByHandleA(
    {_In_ } hFile: HANDLE;
    {_Out_writes_(cchFilePath) } lpszFilePath: LPSTR;
    {_In_ } cchFilePath: DWORD;
    {_In_ } dwFlags: DWORD): DWORD; stdcall; external KERNEL32_DLL;


function GetFinalPathNameByHandleW(
    {_In_ } hFile: HANDLE;
    {_Out_writes_(cchFilePath) } lpszFilePath: LPWSTR;
    {_In_ } cchFilePath: DWORD;
    {_In_ } dwFlags: DWORD): DWORD; stdcall; external KERNEL32_DLL;


function GetFileTime(
    {_In_ } hFile: HANDLE;
    {_Out_opt_ } lpCreationTime: LPFILETIME;
    {_Out_opt_ } lpLastAccessTime: LPFILETIME;
    {_Out_opt_ } lpLastWriteTime: LPFILETIME): winbool; stdcall; external KERNEL32_DLL;


function GetFullPathNameW(
    {_In_ } lpFileName: LPCWSTR;
    {_In_ } nBufferLength: DWORD;
    {_Out_writes_to_opt_(nBufferLength,return + 1) } lpBuffer: LPWSTR;
    {_Outptr_opt_ } lpFilePart: PLPWSTR): DWORD; stdcall; external KERNEL32_DLL;


function GetFullPathNameA(
    {_In_ } lpFileName: LPCSTR;
    {_In_ } nBufferLength: DWORD;
    {_Out_writes_to_opt_(nBufferLength,return + 1) } lpBuffer: LPSTR;
    {_Outptr_opt_ } lpFilePart: PLPSTR): DWORD; stdcall; external KERNEL32_DLL;


function GetLogicalDrives(): DWORD; stdcall; external KERNEL32_DLL;


function GetLogicalDriveStringsW(
    {_In_ } nBufferLength: DWORD;
    {_Out_writes_to_opt_(nBufferLength,return + 1) } lpBuffer: LPWSTR): DWORD; stdcall; external KERNEL32_DLL;


function GetLongPathNameA(
    {_In_ } lpszShortPath: LPCSTR;
    {_Out_writes_to_opt_(cchBuffer,return + 1) } lpszLongPath: LPSTR;
    {_In_ } cchBuffer: DWORD): DWORD; stdcall; external KERNEL32_DLL;


function GetLongPathNameW(
    {_In_ } lpszShortPath: LPCWSTR;
    {_Out_writes_to_opt_(cchBuffer,return + 1) } lpszLongPath: LPWSTR;
    {_In_ } cchBuffer: DWORD): DWORD; stdcall; external KERNEL32_DLL;


{$IFDEF NTDDI_WIN10_FE}


function AreShortNamesEnabled(
    {_In_ } Handle: HANDLE;
    {_Out_ } Enabled: PWinBool): winbool; stdcall; external KERNEL32_DLL;


{$ENDIF}// (NTDDI_VERSION >= NTDDI_WIN10_FE)


function GetShortPathNameW(
    {_In_ } lpszLongPath: LPCWSTR;
    {_Out_writes_to_opt_(cchBuffer,return + 1) } lpszShortPath: LPWSTR;
    {_In_ } cchBuffer: DWORD): DWORD; stdcall; external KERNEL32_DLL;


function GetTempFileNameW(
    {_In_ } lpPathName: LPCWSTR;
    {_In_ } lpPrefixString: LPCWSTR;
    {_In_ } uUnique: UINT;
    {_Out_writes_(MAX_PATH) } lpTempFileName: LPWSTR): UINT; stdcall; external KERNEL32_DLL;


function GetVolumeInformationByHandleW(
    {_In_ } hFile: HANDLE;
    {_Out_writes_opt_(nVolumeNameSize) } lpVolumeNameBuffer: LPWSTR;
    {_In_ } nVolumeNameSize: DWORD;
    {_Out_opt_ } lpVolumeSerialNumber: LPDWORD;
    {_Out_opt_ } lpMaximumComponentLength: LPDWORD;
    {_Out_opt_ } lpFileSystemFlags: LPDWORD;
    {_Out_writes_opt_(nFileSystemNameSize) } lpFileSystemNameBuffer: LPWSTR;
    {_In_ } nFileSystemNameSize: DWORD): winbool; stdcall; external KERNEL32_DLL;


function GetVolumeInformationW(
    {_In_opt_ } lpRootPathName: LPCWSTR;
    {_Out_writes_opt_(nVolumeNameSize) } lpVolumeNameBuffer: LPWSTR;
    {_In_ } nVolumeNameSize: DWORD;
    {_Out_opt_ } lpVolumeSerialNumber: LPDWORD;
    {_Out_opt_ } lpMaximumComponentLength: LPDWORD;
    {_Out_opt_ } lpFileSystemFlags: LPDWORD;
    {_Out_writes_opt_(nFileSystemNameSize) } lpFileSystemNameBuffer: LPWSTR;
    {_In_ } nFileSystemNameSize: DWORD): winbool; stdcall; external KERNEL32_DLL;


function GetVolumePathNameW(
    {_In_ } lpszFileName: LPCWSTR;
    {_Out_writes_(cchBufferLength) } lpszVolumePathName: LPWSTR;
    {_In_ } cchBufferLength: DWORD): winbool; stdcall; external KERNEL32_DLL;


function LocalFileTimeToFileTime(
    {_In_ } lpLocalFileTime: PFILETIME;
    {_Out_ } lpFileTime: LPFILETIME): winbool; stdcall; external KERNEL32_DLL;


function LockFile(
    {_In_ } hFile: HANDLE;
    {_In_ } dwFileOffsetLow: DWORD;
    {_In_ } dwFileOffsetHigh: DWORD;
    {_In_ } nNumberOfBytesToLockLow: DWORD;
    {_In_ } nNumberOfBytesToLockHigh: DWORD): winbool; stdcall; external KERNEL32_DLL;


function LockFileEx(
    {_In_ } hFile: HANDLE;
    {_In_ } dwFlags: DWORD;
    {_Reserved_ } dwReserved: DWORD;
    {_In_ } nNumberOfBytesToLockLow: DWORD;
    {_In_ } nNumberOfBytesToLockHigh: DWORD;
    {_Inout_ } lpOverlapped: LPOVERLAPPED): winbool; stdcall; external KERNEL32_DLL;


function QueryDosDeviceW(
    {_In_opt_ } lpDeviceName: LPCWSTR;
    {_Out_writes_to_opt_(ucchMax,return) } lpTargetPath: LPWSTR;
    {_In_ } ucchMax: DWORD): DWORD; stdcall; external KERNEL32_DLL;


function ReadFile(
    {_In_ } hFile: HANDLE;
    {_Out_writes_bytes_to_opt_(nNumberOfBytesToRead, *lpNumberOfBytesRead) __out_data_source(FILE) } lpBuffer: LPVOID;
    {_In_ } nNumberOfBytesToRead: DWORD;
    {_Out_opt_ } lpNumberOfBytesRead: LPDWORD;
    {_Inout_opt_ } lpOverlapped: LPOVERLAPPED): winbool; stdcall; external KERNEL32_DLL;


function ReadFileEx(
    {_In_ } hFile: HANDLE;
    {_Out_writes_bytes_opt_(nNumberOfBytesToRead) __out_data_source(FILE) } lpBuffer: LPVOID;
    {_In_ } nNumberOfBytesToRead: DWORD;
    {_Inout_ } lpOverlapped: LPOVERLAPPED;
    {_In_ } lpCompletionRoutine: LPOVERLAPPED_COMPLETION_ROUTINE): winbool; stdcall; external KERNEL32_DLL;


function ReadFileScatter(
    {_In_ } hFile: HANDLE;
    {_In_ } aSegmentArray: PFILE_SEGMENT_ELEMENT;
    {_In_ } nNumberOfBytesToRead: DWORD;
    {_Reserved_ } lpReserved: LPDWORD;
    {_Inout_ } lpOverlapped: LPOVERLAPPED): winbool; stdcall; external KERNEL32_DLL;


function RemoveDirectoryA(
    {_In_ } lpPathName: LPCSTR): winbool; stdcall; external KERNEL32_DLL;


function RemoveDirectoryW(
    {_In_ } lpPathName: LPCWSTR): winbool; stdcall; external KERNEL32_DLL;


function SetEndOfFile(
    {_In_ } hFile: HANDLE): winbool; stdcall; external KERNEL32_DLL;


function SetFileAttributesA(
    {_In_ } lpFileName: LPCSTR;
    {_In_ } dwFileAttributes: DWORD): winbool; stdcall; external KERNEL32_DLL;


function SetFileAttributesW(
    {_In_ } lpFileName: LPCWSTR;
    {_In_ } dwFileAttributes: DWORD): winbool; stdcall; external KERNEL32_DLL;


function SetFileInformationByHandle(
    {_In_ } hFile: HANDLE;
    {_In_ } FileInformationClass: TFILE_INFO_BY_HANDLE_CLASS;
    {_In_reads_bytes_(dwBufferSize) } lpFileInformation: LPVOID;
    {_In_ } dwBufferSize: DWORD): winbool; stdcall; external KERNEL32_DLL;


function SetFilePointer(
    {_In_ } hFile: HANDLE;
    {_In_ } lDistanceToMove: LONG;
    {_Inout_opt_ } lpDistanceToMoveHigh: PLONG;
    {_In_ } dwMoveMethod: DWORD): DWORD; stdcall; external KERNEL32_DLL;


function SetFilePointerEx(
    {_In_ } hFile: HANDLE;
    {_In_ } liDistanceToMove: LARGE_INTEGER;
    {_Out_opt_ } lpNewFilePointer: PLARGE_INTEGER;
    {_In_ } dwMoveMethod: DWORD): winbool; stdcall; external KERNEL32_DLL;


function SetFileTime(
    {_In_ } hFile: HANDLE;
    {_In_opt_ } lpCreationTime: PFILETIME;
    {_In_opt_ } lpLastAccessTime: PFILETIME;
    {_In_opt_ } lpLastWriteTime: PFILETIME): winbool; stdcall; external KERNEL32_DLL;


function SetFileValidData(
    {_In_ } hFile: HANDLE;
    {_In_ } ValidDataLength: LONGLONG): winbool; stdcall; external KERNEL32_DLL;


function UnlockFile(
    {_In_ } hFile: HANDLE;
    {_In_ } dwFileOffsetLow: DWORD;
    {_In_ } dwFileOffsetHigh: DWORD;
    {_In_ } nNumberOfBytesToUnlockLow: DWORD;
    {_In_ } nNumberOfBytesToUnlockHigh: DWORD): winbool; stdcall; external KERNEL32_DLL;


function UnlockFileEx(
    {_In_ } hFile: HANDLE;
    {_Reserved_ } dwReserved: DWORD;
    {_In_ } nNumberOfBytesToUnlockLow: DWORD;
    {_In_ } nNumberOfBytesToUnlockHigh: DWORD;
    {_Inout_ } lpOverlapped: LPOVERLAPPED): winbool; stdcall; external KERNEL32_DLL;


function WriteFile(
    {_In_ } hFile: HANDLE;
    {_In_reads_bytes_opt_(nNumberOfBytesToWrite) } lpBuffer: LPCVOID;
    {_In_ } nNumberOfBytesToWrite: DWORD;
    {_Out_opt_ } lpNumberOfBytesWritten: LPDWORD;
    {_Inout_opt_ } lpOverlapped: LPOVERLAPPED): winbool; stdcall; external KERNEL32_DLL;


function WriteFileEx(
    {_In_ } hFile: HANDLE;
    {_In_reads_bytes_opt_(nNumberOfBytesToWrite) } lpBuffer: LPCVOID;
    {_In_ } nNumberOfBytesToWrite: DWORD;
    {_Inout_ } lpOverlapped: LPOVERLAPPED;
    {_In_ } lpCompletionRoutine: LPOVERLAPPED_COMPLETION_ROUTINE): winbool; stdcall; external KERNEL32_DLL;


function WriteFileGather(
    {_In_ } hFile: HANDLE;
    {_In_ } aSegmentArray: PFILE_SEGMENT_ELEMENT;
    {_In_ } nNumberOfBytesToWrite: DWORD;
    {_Reserved_ } lpReserved: LPDWORD;
    {_Inout_ } lpOverlapped: LPOVERLAPPED): winbool; stdcall; external KERNEL32_DLL;


function GetTempPathW(
    {_In_ } nBufferLength: DWORD;
    {_Out_writes_to_opt_(nBufferLength,return + 1) } lpBuffer: LPWSTR): DWORD; stdcall; external KERNEL32_DLL;


function GetVolumeNameForVolumeMountPointW(
    {_In_ } lpszVolumeMountPoint: LPCWSTR;
    {_Out_writes_(cchBufferLength) } lpszVolumeName: LPWSTR;
    {_In_ } cchBufferLength: DWORD): winbool; stdcall; external KERNEL32_DLL;


function GetVolumePathNamesForVolumeNameW(
    {_In_ } lpszVolumeName: LPCWSTR;
    {_Out_writes_to_opt_(cchBufferLength,*lpcchReturnLength)} lpszVolumePathNames: LPWCH;
    {_In_ } cchBufferLength: DWORD;
    {_Out_ } lpcchReturnLength: PDWORD): winbool; stdcall; external KERNEL32_DLL;


function CreateFile2(
    {_In_ } lpFileName: LPCWSTR;
    {_In_ } dwDesiredAccess: DWORD;
    {_In_ } dwShareMode: DWORD;
    {_In_ } dwCreationDisposition: DWORD;
    {_In_opt_ } pCreateExParams: LPCREATEFILE2_EXTENDED_PARAMETERS): HANDLE; stdcall; external KERNEL32_DLL;


function SetFileIoOverlappedRange(
    {_In_ } FileHandle: HANDLE;
    {_In_ } OverlappedRangeStart: PUCHAR;
    {_In_ } Length: ULONG): winbool; stdcall; external KERNEL32_DLL;


function GetCompressedFileSizeA(
    {_In_ } lpFileName: LPCSTR;
    {_Out_opt_ } lpFileSizeHigh: LPDWORD): DWORD; stdcall; external KERNEL32_DLL;


function GetCompressedFileSizeW(
    {_In_ } lpFileName: LPCWSTR;
    {_Out_opt_ } lpFileSizeHigh: LPDWORD): DWORD; stdcall; external KERNEL32_DLL;


function FindFirstStreamW(
    {_In_ } lpFileName: LPCWSTR;
    {_In_ } InfoLevel: TSTREAM_INFO_LEVELS;
    {_Out_writes_bytes_(sizeof(WIN32_FIND_STREAM_DATA)) } lpFindStreamData: LPVOID;
    {_Reserved_ } dwFlags: DWORD): HANDLE; stdcall; external KERNEL32_DLL;


function FindNextStreamW(
    {_In_ } hFindStream: HANDLE;
    {_Out_writes_bytes_(sizeof(WIN32_FIND_STREAM_DATA)) } lpFindStreamData: LPVOID): winbool stdcall; external KERNEL32_DLL;


function AreFileApisANSI(): winbool; stdcall; external KERNEL32_DLL;


function GetTempPathA(
    {_In_ } nBufferLength: DWORD;
    {_Out_writes_to_opt_(nBufferLength,return + 1) } lpBuffer: LPSTR): DWORD; stdcall; external KERNEL32_DLL;


function FindFirstFileNameW(
    {_In_ } lpFileName: LPCWSTR;
    {_In_ } dwFlags: DWORD;
    {_Inout_ } StringLength: LPDWORD;
    {_Out_writes_(*StringLength) } LinkName: PWSTR): HANDLE; stdcall; external KERNEL32_DLL;


function FindNextFileNameW(
    {_In_ } hFindStream: HANDLE;
    {_Inout_ } StringLength: LPDWORD;
    {_Out_writes_(*StringLength) } LinkName: PWSTR): winbool; stdcall; external KERNEL32_DLL;


function GetVolumeInformationA(
    {_In_opt_ } lpRootPathName: LPCSTR;
    {_Out_writes_opt_(nVolumeNameSize) } lpVolumeNameBuffer: LPSTR;
    {_In_ } nVolumeNameSize: DWORD;
    {_Out_opt_ } lpVolumeSerialNumber: LPDWORD;
    {_Out_opt_ } lpMaximumComponentLength: LPDWORD;
    {_Out_opt_ } lpFileSystemFlags: LPDWORD;
    {_Out_writes_opt_(nFileSystemNameSize) } lpFileSystemNameBuffer: LPSTR;
    {_In_ } nFileSystemNameSize: DWORD): winbool; stdcall; external KERNEL32_DLL;


function GetTempFileNameA(
    {_In_ } lpPathName: LPCSTR;
    {_In_ } lpPrefixString: LPCSTR;
    {_In_ } uUnique: UINT;
    {_Out_writes_(MAX_PATH) } lpTempFileName: LPSTR): UINT; stdcall; external KERNEL32_DLL;


procedure SetFileApisToOEM(); stdcall; external KERNEL32_DLL;


procedure SetFileApisToANSI(); stdcall; external KERNEL32_DLL;


{$IFDEF NTDDI_WIN10_RS5}


function GetTempPath2W(
    {_In_ } BufferLength: DWORD;
    {_Out_writes_to_opt_(BufferLength,return + 1) } Buffer: LPWSTR): DWORD; stdcall; external KERNEL32_DLL;


function GetTempPath2A(
    {_In_ } BufferLength: DWORD;
    {_Out_writes_to_opt_(BufferLength,return + 1) } Buffer: LPSTR): DWORD; stdcall; external KERNEL32_DLL;


{$ENDIF}// (NTDDI_VERSION >= NTDDI_WIN10_RS5)


{$IFDEF NTDDI_WIN11_GE}


function CreateFile3(
    {_In_z_ } lpFileName: LPCWSTR;
    {_In_ } dwDesiredAccess: DWORD;
    {_In_ } dwShareMode: DWORD;
    {_In_ } dwCreationDisposition: DWORD;
    {_In_opt_ } pCreateExParams: LPCREATEFILE3_EXTENDED_PARAMETERS): HANDLE; stdcall; external KERNEL32_DLL;


function CreateDirectory2A(
    {_In_z_ } lpPathName: LPCSTR;
    {_In_ } dwDesiredAccess: DWORD;
    {_In_ } dwShareMode: DWORD;
    {_In_ } DirectoryFlags: TDIRECTORY_FLAGS;
    {_In_opt_ } lpSecurityAttributes: LPSECURITY_ATTRIBUTES): HANDLE; stdcall; external KERNEL32_DLL;


function CreateDirectory2W(
    {_In_z_ } lpPathName: LPCWSTR;
    {_In_ } dwDesiredAccess: DWORD;
    {_In_ } dwShareMode: DWORD;
    {_In_ } DirectoryFlags: TDIRECTORY_FLAGS;
    {_In_opt_ } lpSecurityAttributes: LPSECURITY_ATTRIBUTES): HANDLE; stdcall; external KERNEL32_DLL;


function RemoveDirectory2A(
    {_In_z_ } lpPathName: LPCSTR;
    {_In_ } DirectoryFlags: TDIRECTORY_FLAGS): winbool; stdcall; external KERNEL32_DLL;


function RemoveDirectory2W(
    {_In_z_ } lpPathName: LPCWSTR;
    {_In_ } DirectoryFlags: TDIRECTORY_FLAGS): winbool; stdcall; external KERNEL32_DLL;


function DeleteFile2A(
    {_In_z_ } lpFileName: LPCSTR;
    {_In_ } Flags: DWORD): winbool; stdcall; external KERNEL32_DLL;


function DeleteFile2W(
    {_In_z_ } lpFileName: LPCWSTR;
    {_In_ } Flags: DWORD): winbool; stdcall; external KERNEL32_DLL;


{$ENDIF}

implementation

end.
