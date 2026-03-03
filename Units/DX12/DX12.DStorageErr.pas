unit DX12.DStorageErr;

(*-------------------------------------------------------------------------------------
 *
 * Copyright (c) Microsoft Corporation
 * Licensed under the MIT license
 *
 *-------------------------------------------------------------------------------------*)



{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils;

(*++

 MessageId's 0x0000 - 0x00ff (inclusive) are reserved for DirectStorage.

--*)

const


    //  Values are 32 bit values laid out as follows:

    //   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
    //   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
    //  +---+-+-+-----------------------+-------------------------------+
    //  |Sev|C|R|     Facility          |               Code            |
    //  +---+-+-+-----------------------+-------------------------------+

    //  where

    //      Sev - is the severity code

    //          00 - Success
    //          01 - Informational
    //          10 - Warning
    //          11 - Error

    //      C - is the Customer code flag

    //      R - is a reserved bit

    //      Facility - is the facility code

    //      Code - is the facility's status code


    // Define the facility codes

    FACILITY_GAME = 2340;



    // Define the severity codes


    // MessageId: E_DSTORAGE_ALREADY_RUNNING

    // MessageText:

    // DStorage is already running exclusively.



    E_DSTORAGE_ALREADY_RUNNING = HRESULT($89240001);


    // MessageId: E_DSTORAGE_NOT_RUNNING

    // MessageText:

    // DStorage is not running.

    E_DSTORAGE_NOT_RUNNING = HRESULT($89240002);


    // MessageId: E_DSTORAGE_INVALID_QUEUE_CAPACITY

    // MessageText:

    // Invalid queue capacity parameter.

    E_DSTORAGE_INVALID_QUEUE_CAPACITY = HRESULT($89240003);


    // MessageId: E_DSTORAGE_XVD_DEVICE_NOT_SUPPORTED

    // MessageText:

    // The specified XVD is not on a supported NVMe device.
    // This error only applies to Xbox.

    E_DSTORAGE_XVD_DEVICE_NOT_SUPPORTED = HRESULT($89240004);


    // MessageId: E_DSTORAGE_UNSUPPORTED_VOLUME

    // MessageText:

    // The specified XVD is not on a supported volume.
    // This error only applies to Xbox.

    E_DSTORAGE_UNSUPPORTED_VOLUME = HRESULT($89240005);


    // MessageId: E_DSTORAGE_END_OF_FILE

    // MessageText:

    // The specified offset and length exceeds the size of the file.

    E_DSTORAGE_END_OF_FILE = HRESULT($89240007);


    // MessageId: E_DSTORAGE_REQUEST_TOO_LARGE

    // MessageText:

    // The IO request is too large.

    E_DSTORAGE_REQUEST_TOO_LARGE = HRESULT($89240008);


    // MessageId: E_DSTORAGE_ACCESS_VIOLATION

    // MessageText:

    // The destination buffer for the DStorage request is not accessible.

    E_DSTORAGE_ACCESS_VIOLATION = HRESULT($89240009);


    // MessageId: E_DSTORAGE_UNSUPPORTED_FILE

    // MessageText:

    // The file is not supported by DStorage. Possible reasons include the file is a
    // sparse file, or is compressed in NTFS.
    // This error only applies to Xbox.

    E_DSTORAGE_UNSUPPORTED_FILE = HRESULT($8924000A);


    // MessageId: E_DSTORAGE_FILE_NOT_OPEN

    // MessageText:

    // The file is not open.

    E_DSTORAGE_FILE_NOT_OPEN = HRESULT($8924000B);


    // MessageId: E_DSTORAGE_RESERVED_FIELDS

    // MessageText:

    // A reserved field is not set to 0.

    E_DSTORAGE_RESERVED_FIELDS = HRESULT($8924000C);


    // MessageId: E_DSTORAGE_INVALID_BCPACK_MODE

    // MessageText:

    // The request has invalid BCPack decompression mode.
    // This error only applies to Xbox.

    E_DSTORAGE_INVALID_BCPACK_MODE = HRESULT($8924000D);


    // MessageId: E_DSTORAGE_INVALID_SWIZZLE_MODE

    // MessageText:

    // The request has invalid swizzle mode.
    // This error only applies to Xbox.

    E_DSTORAGE_INVALID_SWIZZLE_MODE = HRESULT($8924000E);


    // MessageId: E_DSTORAGE_INVALID_DESTINATION_SIZE

    // MessageText:

    // The request's destination size is invalid. If no decompression is used, it must
    // be equal to the request's length; If decompression is used, it must be larger
    // than the request's length.

    E_DSTORAGE_INVALID_DESTINATION_SIZE = HRESULT($8924000F);


    // MessageId: E_DSTORAGE_QUEUE_CLOSED

    // MessageText:

    // The request targets a queue that is closed.

    E_DSTORAGE_QUEUE_CLOSED = HRESULT($89240010);


    // MessageId: E_DSTORAGE_INVALID_CLUSTER_SIZE

    // MessageText:

    // The volume is formatted with an unsupported cluster size.
    // This error only applies to Xbox.

    E_DSTORAGE_INVALID_CLUSTER_SIZE = HRESULT($89240011);


    // MessageId: E_DSTORAGE_TOO_MANY_QUEUES

    // MessageText:

    // The number of queues has reached the maximum limit.

    E_DSTORAGE_TOO_MANY_QUEUES = HRESULT($89240012);


    // MessageId: E_DSTORAGE_INVALID_QUEUE_PRIORITY

    // MessageText:

    // Invalid priority is specified for the queue.

    E_DSTORAGE_INVALID_QUEUE_PRIORITY = HRESULT($89240013);


    // MessageId: E_DSTORAGE_TOO_MANY_FILES

    // MessageText:

    // The number of files has reached the maximum limit.

    E_DSTORAGE_TOO_MANY_FILES = HRESULT($89240014);


    // MessageId: E_DSTORAGE_INDEX_BOUND

    // MessageText:

    // The index parameter is out of bound.

    E_DSTORAGE_INDEX_BOUND = HRESULT($89240015);


    // MessageId: E_DSTORAGE_IO_TIMEOUT

    // MessageText:

    // The IO operation has timed out.

    E_DSTORAGE_IO_TIMEOUT = HRESULT($89240016);


    // MessageId: E_DSTORAGE_INVALID_FILE_HANDLE

    // MessageText:

    // The specified file has not been opened.

    E_DSTORAGE_INVALID_FILE_HANDLE = HRESULT($89240017);


    // MessageId: E_DSTORAGE_DEPRECATED_PREVIEW_GDK

    // MessageText:

    // This GDK preview is deprecated. Update to a supported GDK version.
    // This error only applies to Xbox.

    E_DSTORAGE_DEPRECATED_PREVIEW_GDK = HRESULT($89240018);


    // MessageId: E_DSTORAGE_XVD_NOT_REGISTERED

    // MessageText:

    // The specified XVD is not registered or unmounted.
    // This error only applies to Xbox.

    E_DSTORAGE_XVD_NOT_REGISTERED = HRESULT($89240019);


    // MessageId: E_DSTORAGE_INVALID_FILE_OFFSET

    // MessageText:

    // The request has invalid file offset for the specified decompression mode.

    E_DSTORAGE_INVALID_FILE_OFFSET = HRESULT($8924001A);


    // MessageId: E_DSTORAGE_INVALID_SOURCE_TYPE

    // MessageText:

    // A memory source request was enqueued into a file source queue, or a file source
    // request was enqueued into a memory source queue.

    E_DSTORAGE_INVALID_SOURCE_TYPE = HRESULT($8924001B);


    // MessageId: E_DSTORAGE_INVALID_INTERMEDIATE_SIZE

    // MessageText:

    // The request has invalid intermediate size for the specified decompression modes.
    // This error only applies to Xbox.

    E_DSTORAGE_INVALID_INTERMEDIATE_SIZE = HRESULT($8924001C);


    // MessageId: E_DSTORAGE_SYSTEM_NOT_SUPPORTED

    // MessageText:

    // This console generation doesn't support DirectStorage.
    // This error only applies to Xbox.

    E_DSTORAGE_SYSTEM_NOT_SUPPORTED = HRESULT($8924001D);


    // MessageId: E_DSTORAGE_STAGING_BUFFER_LOCKED

    // MessageText:

    // Staging buffer size can only be changed when no queue is created and no file is
    // open.

    E_DSTORAGE_STAGING_BUFFER_LOCKED = HRESULT($8924001F);


    // MessageId: E_DSTORAGE_INVALID_STAGING_BUFFER_SIZE

    // MessageText:

    // The specified staging buffer size is not valid.

    E_DSTORAGE_INVALID_STAGING_BUFFER_SIZE = HRESULT($89240020);


    // MessageId: E_DSTORAGE_STAGING_BUFFER_TOO_SMALL

    // MessageText:

    // The staging buffer isn't large enough to perform this operation.

    E_DSTORAGE_STAGING_BUFFER_TOO_SMALL = HRESULT($89240021);


    // MessageId: E_DSTORAGE_INVALID_FENCE

    // MessageText:

    // The fence is not valid or has been released.

    E_DSTORAGE_INVALID_FENCE = HRESULT($89240022);


    // MessageId: E_DSTORAGE_INVALID_STATUS_ARRAY

    // MessageText:

    // The status array is not valid or has been released.

    E_DSTORAGE_INVALID_STATUS_ARRAY = HRESULT($89240023);


    // MessageId: E_DSTORAGE_INVALID_MEMORY_QUEUE_PRIORITY

    // MessageText:

    // Invalid priority is specified for the queue. Only DSTORAGE_PRIORITY_REALTIME
    // is a valid priority for a memory queue.

    E_DSTORAGE_INVALID_MEMORY_QUEUE_PRIORITY = HRESULT($89240024);


    // MessageId: E_DSTORAGE_DECOMPRESSION_ERROR

    // MessageText:

    // A generic error has happened during decompression.

    E_DSTORAGE_DECOMPRESSION_ERROR = HRESULT($89240030);


    // MessageId: E_DSTORAGE_ZLIB_BAD_HEADER

    // MessageText:

    // ZLIB header is corrupted.
    // This error only applies to Xbox.

    E_DSTORAGE_ZLIB_BAD_HEADER = HRESULT($89240031);


    // MessageId: E_DSTORAGE_ZLIB_BAD_DATA

    // MessageText:

    // ZLIB compressed data is corrupted/invalid.
    // This error only applies to Xbox.

    E_DSTORAGE_ZLIB_BAD_DATA = HRESULT($89240032);


    // MessageId: E_DSTORAGE_ZLIB_PARITY_FAIL

    // MessageText:

    // Block-level ADLER parity check failed during ZLIB decompression.
    // This error only applies to Xbox.

    E_DSTORAGE_ZLIB_PARITY_FAIL = HRESULT($89240033);


    // MessageId: E_DSTORAGE_BCPACK_BAD_HEADER

    // MessageText:

    // BCPack header is corrupted.
    // This error only applies to Xbox.

    E_DSTORAGE_BCPACK_BAD_HEADER = HRESULT($89240034);


    // MessageId: E_DSTORAGE_BCPACK_BAD_DATA

    // MessageText:

    // BCPack decoder has generated more data than expected, most likely due to
    // corrupted bitstream.
    // This error only applies to Xbox.

    E_DSTORAGE_BCPACK_BAD_DATA = HRESULT($89240035);


    // MessageId: E_DSTORAGE_DECRYPTION_ERROR

    // MessageText:

    // A generic error has happened during decryption.
    // This error only applies to Xbox.

    E_DSTORAGE_DECRYPTION_ERROR = HRESULT($89240036);


    // MessageId: E_DSTORAGE_PASSTHROUGH_ERROR

    // MessageText:

    // A generic error has happened during copy operation.
    // This error only applies to Xbox.

    E_DSTORAGE_PASSTHROUGH_ERROR = HRESULT($89240037);


    // MessageId: E_DSTORAGE_FILE_TOO_FRAGMENTED

    // MessageText:

    // The file is too fragmented to be accessed by DStorage. This error can only
    // happen with files overly fragmented on a writable volume.
    // This error only applies to Xbox.

    E_DSTORAGE_FILE_TOO_FRAGMENTED = HRESULT($89240038);


    // MessageId: E_DSTORAGE_COMPRESSED_DATA_TOO_LARGE

    // MessageText:

    // The size of the resulting compressed data is too large for
    // DirectStorage to decompress successfully on the GPU.

    E_DSTORAGE_COMPRESSED_DATA_TOO_LARGE = HRESULT($89240039);


    // MessageId: E_DSTORAGE_INVALID_DESTINATION_TYPE

    // MessageText:

    // A gpu memory destination request was enqueued into a queue that
    // was created without a D3D device or the destination type is
    // unknown.

    E_DSTORAGE_INVALID_DESTINATION_TYPE = HRESULT($89240040);


    // MessageId: E_DSTORAGE_FILEBUFFERING_REQUIRES_DISABLED_BYPASSIO

    // MessageText:

    // ForceFileBuffering was enabled without disabling BypassIO.

    E_DSTORAGE_FILEBUFFERING_REQUIRES_DISABLED_BYPASSIO = HRESULT($89240041);


implementation

end.
