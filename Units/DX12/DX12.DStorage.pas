unit DX12.DStorage;
(*-------------------------------------------------------------------------------------
 *
 * Copyright (c) Microsoft Corporation
 * Licensed under the MIT license
 *
 *-------------------------------------------------------------------------------------*)




{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D12,
    DX12.DStorageErr,
    Win32.FileApi;

const

    DStorage_DLL = 'dstorage.dll';

    DSTORAGE_SDK_VERSION = 300;

    /// The minimum valid queue capacity.
    DSTORAGE_MIN_QUEUE_CAPACITY = $80;

    /// The maximum valid queue capacity.
    DSTORAGE_MAX_QUEUE_CAPACITY = $2000;


    /// The maximum number of characters that will be stored for a request's name.
    DSTORAGE_REQUEST_MAX_NAME = 64;


    /// Disables built-in decompression.
    ///
    /// Set NumBuiltInCpuDecompressionThreads in DSTORAGE_CONFIGURATION to
    /// this value to disable built-in decompression. No decompression threads
    /// will be created and the title is fully responsible for checking
    /// the custom decompression queue and pulling off ALL entries to decompress.


    DSTORAGE_DISABLE_BUILTIN_CPU_DECOMPRESSION = -1;




    IID_IDStorageFile: TGUID = '{5de95e7b-955a-4868-a73c-243b29f4b8da}';
    IID_IDStorageCustomDecompressionQueue: TGUID = '{97179b2f-2c21-49ca-8291-4e1bf4a160df}';
    IID_IDStorageCustomDecompressionQueue1: TGUID = '{0D47C6C9-E61A-4706-93B4-68BFE3F4AA4A}';
    IID_IDStorageFactory: TGUID = '{6924ea0c-c3cd-4826-b10a-f64f4ed927c1}';
    IID_IDStorageStatusArray: TGUID = '{82397587-7cd5-453b-a02e-31379bd64656}';
    IID_IDStorageQueue: TGUID = '{cfdbd83f-9e06-4fda-8ea5-69042137f49b}';
    IID_IDStorageQueue1: TGUID = '{dd2f482c-5eff-41e8-9c9e-d2374b278128}';
    IID_IDStorageQueue2: TGUID = '{b1c9d643-3a49-44a2-b46f-653649470d18}';
    IID_IDStorageQueue3: TGUID = '{deb54c52-eca8-46b3-82a7-031b72262653}';
    IID_IDStorageCompressionCodec: TGUID = '{84ef5121-9b43-4d03-b5c1-cc34606b262d}';

type
    IDStorageStatusArray  = interface;
    PIDStorageStatusArray = ^IDStorageStatusArray;

    /// The priority of a DirectStorage queue.
    TDSTORAGE_PRIORITY = (
        DSTORAGE_PRIORITY_LOW = -1,
        DSTORAGE_PRIORITY_NORMAL = 0,
        DSTORAGE_PRIORITY_HIGH = 1,
        DSTORAGE_PRIORITY_REALTIME = 2,
        /// The following values can be used for iterating over all priority levels.
        DSTORAGE_PRIORITY_FIRST = DSTORAGE_PRIORITY_LOW,
        DSTORAGE_PRIORITY_LAST = DSTORAGE_PRIORITY_REALTIME,
        DSTORAGE_PRIORITY_COUNT = 4);

    PDSTORAGE_PRIORITY = ^TDSTORAGE_PRIORITY;




    /// The source type of a DirectStorage request.


    {$Z8}
    TDSTORAGE_REQUEST_SOURCE_TYPE = (
        /// The source of the DirectStorage request is a file.
        DSTORAGE_REQUEST_SOURCE_FILE = 0,
        /// The source of the DirectStorage request is a block of memory.
        DSTORAGE_REQUEST_SOURCE_MEMORY = 1);

    PDSTORAGE_REQUEST_SOURCE_TYPE = ^TDSTORAGE_REQUEST_SOURCE_TYPE;

    {$PACKENUM 4}

    /// The destination type of a DirectStorage request.

    {$Z8}
    TDSTORAGE_REQUEST_DESTINATION_TYPE = (
        /// The destination of the DirectStorage request is a block of memory.
        DSTORAGE_REQUEST_DESTINATION_MEMORY = 0,
        /// The destination of the DirectStorage request is an ID3D12Resource
        /// that is a buffer.
        DSTORAGE_REQUEST_DESTINATION_BUFFER = 1,
        /// The destination of the DirectStorage request is an ID3D12Resource
        /// that is a texture.
        DSTORAGE_REQUEST_DESTINATION_TEXTURE_REGION = 2,
        /// The destination of the DirectStorage request is an ID3D12Resource
        /// that is a texture that will receive all subresources in a
        /// single request.
        DSTORAGE_REQUEST_DESTINATION_MULTIPLE_SUBRESOURCES = 3,
        /// The destination of the DirectStorage request is an ID3D12Resource
        /// that is tiled.
        DSTORAGE_REQUEST_DESTINATION_TILES = 4,
        /// The destination of the DirectStorage request is an ID3D12Resource
        /// that is a texture that will receive the number of subresources
        /// specified in a single request.
        DSTORAGE_REQUEST_DESTINATION_MULTIPLE_SUBRESOURCES_RANGE = 5);

    PDSTORAGE_REQUEST_DESTINATION_TYPE = ^TDSTORAGE_REQUEST_DESTINATION_TYPE;

    {$PACKENUM 4}


    /// The DSTORAGE_QUEUE_DESC structure contains the properties of a DirectStorage
    /// queue for the queue's creation.

    TDSTORAGE_QUEUE_DESC = record
        /// The source type of requests that this DirectStorage queue can accept.
        SourceType: TDSTORAGE_REQUEST_SOURCE_TYPE;
        /// The maximum number of requests that the queue can hold.
        Capacity: uint16;
        /// The priority of the requests in this queue.
        Priority: TDSTORAGE_PRIORITY;
        /// Optional name of the queue. Used for debugging.
        {_In_opt_z_ } Name: pchar;
        /// Optional device to use for writing to destination resources and
        /// performing GPU decompression. The destination resource's device
        /// must match this device.
        ///
        /// This member may be null. If you specify a null device, then the
        /// destination type must be DSTORAGE_REQUEST_DESTINATION_MEMORY.
        Device: PID3D12Device;
    end;
    PDSTORAGE_QUEUE_DESC = ^TDSTORAGE_QUEUE_DESC;


    /// The DSTORAGE_QUEUE_INFO structure contains the properties and current state
    /// of a DirectStorage queue.

    TDSTORAGE_QUEUE_INFO = record
        /// The DSTORAGE_QUEUE_DESC structure used for the queue's creation.
        Desc: TDSTORAGE_QUEUE_DESC;
        /// The number of available empty slots. If a queue is empty, then the number
        /// of empty slots equals capacity - 1. The reserved slot is used to
        /// distinguish between empty and full cases.
        EmptySlotCount: uint16;
        /// The number of entries that would need to be enqueued in order to trigger
        /// automatic submission.
        RequestCountUntilAutoSubmit: uint16;
    end;
    PDSTORAGE_QUEUE_INFO = ^TDSTORAGE_QUEUE_INFO;


    /// The type of compression format used at the decompression stage.
    /// Your application can implement custom decompressors, starting from
    /// DSTORAGE_CUSTOM_COMPRESSION_0.

    {$PACKENUM 1}
    TDSTORAGE_COMPRESSION_FORMAT = (
        /// The data is uncompressed.
        DSTORAGE_COMPRESSION_FORMAT_NONE = 0,
        /// The data is compressed using the built-in GDEFLATE format.
        DSTORAGE_COMPRESSION_FORMAT_GDEFLATE = 1,
        /// The data is stored in an application-defined custom format. The
        /// application must use IDStorageCustomDecompressionQueue to implement
        /// custom decompression.  Additional custom compression formats can be
        /// used, for example `(DSTORAGE_CUSTOM_COMPRESSION_0 + 1)`.
        DSTORAGE_CUSTOM_COMPRESSION_0 = $80);

    PDSTORAGE_COMPRESSION_FORMAT = ^TDSTORAGE_COMPRESSION_FORMAT;
    {$PACKENUM 4}


    /// Options for a DirectStorage request.


    TDSTORAGE_REQUEST_OPTIONS = bitpacked record
        /// DSTORAGE_COMPRESSION_FORMAT indicating how the data is compressed.
        CompressionFormat: 0..255;
        /// Reserved fields. Must be 0.
        Reserved1: array [0..7 - 1] of uint8;
        /// DSTORAGE_REQUEST_SOURCE_TYPE enum value indicating whether the
        /// source of the request is a file or a block of memory.
        SourceType: 0..1;
        /// DSTORAGE_REQUEST_DESTINATION_TYPE enum value indicating the
        /// destination of the request. Block of memory, resource.
        DestinationType: 0..127;
        /// Reserved fields. Must be 0.
        Reserved: 0..65535;
    end;
    PDSTORAGE_REQUEST_OPTIONS = ^TDSTORAGE_REQUEST_OPTIONS;


    /// Flags controlling DirectStorage debug layer.
    TDSTORAGE_DEBUG = (
        /// DirectStorage debug layer is disabled.
        DSTORAGE_DEBUG_NONE = $00,
        /// Print error information to a debugger.
        DSTORAGE_DEBUG_SHOW_ERRORS = $01,
        /// Trigger a debug break each time an error is detected.
        DSTORAGE_DEBUG_BREAK_ON_ERROR = $02,
        /// Include object names in ETW events.
        DSTORAGE_DEBUG_RECORD_OBJECT_NAMES = $04);

    PDSTORAGE_DEBUG = ^TDSTORAGE_DEBUG;




    /// Represents a file to be accessed by DirectStorage.




    IDStorageFile = interface(IUnknown)
        ['{5de95e7b-955a-4868-a73c-243b29f4b8da}']
        /// Closes the file, regardless of the reference count on this object.
        ///
        /// After an IDStorageFile object is closed, it can no longer be used in
        /// DirectStorage requests.  This does not modify the reference count on this
        /// object; Release() must be called as usual.
        procedure Close(); stdcall;

        /// Retrieves file information for an opened file.
        /// <param name="info">Receives the file information.</param>
        /// <returns>Standard HRESULT error code.</returns>
        function GetFileInformation(
        {_Out_ } info: PBY_HANDLE_FILE_INFORMATION): HRESULT; stdcall;

    end;

    PIDStorageFile = ^IDStorageFile;

    /// Describes a source for a request with SourceType
    /// DSTORAGE_REQUEST_SOURCE_FILE.


    TDSTORAGE_SOURCE_FILE = record
        /// The file to perform this read request from.
        Source: PIDStorageFile;
        /// The offset, in bytes, in the file to start the read request at.
        Offset: uint64;
        /// Number of bytes to read from the file.
        Size: uint32;
    end;
    PDSTORAGE_SOURCE_FILE = ^TDSTORAGE_SOURCE_FILE;




    /// Describes the source for a request with SourceType
    /// DSTORAGE_REQUEST_SOURCE_MEMORY.


    TDSTORAGE_SOURCE_MEMORY = record
        /// Address of the source buffer to be read from.
        Source: Pvoid;
        /// Number of bytes to read from the source buffer.
        Size: uint32;
    end;
    PDSTORAGE_SOURCE_MEMORY = ^TDSTORAGE_SOURCE_MEMORY;




    /// Describes the destination for a request with DestinationType
    /// DSTORAGE_REQUEST_DESTINATION_MEMORY.


    TDSTORAGE_DESTINATION_MEMORY = record
        /// Address of the buffer to receive the final result of this request.
        Buffer: Pvoid;
        /// Number of bytes to write to the destination buffer.
        Size: uint32;
    end;
    PDSTORAGE_DESTINATION_MEMORY = ^TDSTORAGE_DESTINATION_MEMORY;




    /// Describes the destination for a request with DestinationType
    /// DSTORAGE_REQUEST_DESTINATION_BUFFER.


    TDSTORAGE_DESTINATION_BUFFER = record
        /// Address of the resource to receive the final result of this request.
        Resource: PID3D12Resource;
        /// The offset, in bytes, in the buffer resource to write into.
        Offset: uint64;
        /// Number of bytes to write to the destination buffer.
        Size: uint32;
    end;
    PDSTORAGE_DESTINATION_BUFFER = ^TDSTORAGE_DESTINATION_BUFFER;




    /// Describes the destination for a request with DestinationType
    /// DSTORAGE_REQUEST_DESTINATION_TEXTURE_REGION.


    TDSTORAGE_DESTINATION_TEXTURE_REGION = record
        /// Address of the resource to receive the final result of this request.
        Resource: PID3D12Resource;
        /// Describes the destination texture copy location. The subresource
        /// referred to must be in the D3D12_RESOURCE_STATE_COMMON state.
        SubresourceIndex: UINT;
        /// Coordinates and size of the destination region to copy, in pixels.
        Region: TD3D12_BOX;
    end;
    PDSTORAGE_DESTINATION_TEXTURE_REGION = ^TDSTORAGE_DESTINATION_TEXTURE_REGION;




    /// Describes the destination for a request with DestinationType
    /// DSTORAGE_REQUEST_DESTINATION_MULTIPLE_SUBRESOURCES.


    TDSTORAGE_DESTINATION_MULTIPLE_SUBRESOURCES = record
        /// Address of the resource to receive the final result of this request. The
        /// source is expected to contain full data for all subresources, starting
        /// from FirstSubresource.
        Resource: PID3D12Resource;
        /// Describes the first subresource of the destination texture copy
        /// location. The subresource referred to must be in the
        /// D3D12_RESOURCE_STATE_COMMON state.
        FirstSubresource: UINT;
    end;
    PDSTORAGE_DESTINATION_MULTIPLE_SUBRESOURCES = ^TDSTORAGE_DESTINATION_MULTIPLE_SUBRESOURCES;




    /// Describes the destination for a request with DestinationType
    /// DSTORAGE_REQUEST_DESTINATION_MULTIPLE_SUBRESOURCES_RANGE.


    TDSTORAGE_DESTINATION_MULTIPLE_SUBRESOURCES_RANGE = record
        /// Address of the resource to receive the final result of this request. The
        /// source is expected to contain full data for all subresources, starting
        /// from FirstSubresource.
        Resource: PID3D12Resource;
        /// Describes the first subresource of the destination texture copy
        /// location. The subresource referred to must be in the
        /// D3D12_RESOURCE_STATE_COMMON state.
        FirstSubresource: UINT;
        /// Describes the number of subresources to copy to the destination
        /// resource starting from the FirstSubresource specified.
        NumSubresources: UINT;
    end;
    PDSTORAGE_DESTINATION_MULTIPLE_SUBRESOURCES_RANGE = ^TDSTORAGE_DESTINATION_MULTIPLE_SUBRESOURCES_RANGE;




    /// Describes the destination for a request with DestinationType
    /// DSTORAGE_REQUEST_DESTINATION_TILES.


    TDSTORAGE_DESTINATION_TILES = record
        /// Address of the resource to receive the final result of this request. The
        /// source buffer is expected to contain data arranged as if it were the
        /// source to a CopyTiles call with these parameters.
        Resource: PID3D12Resource;
        /// The starting coordinates of the tiled region.
        TiledRegionStartCoordinate: TD3D12_TILED_RESOURCE_COORDINATE;
        /// The size of the tiled region.
        TileRegionSize: TD3D12_TILE_REGION_SIZE;
    end;
    PDSTORAGE_DESTINATION_TILES = ^TDSTORAGE_DESTINATION_TILES;




    /// <summary>
    /// Describes the source specified for a DirectStorage request. For a request,
    /// the value of `request.Options.SourceType` determines which of these union
    /// fields is active.
    /// </summary>
    TDSTORAGE_SOURCE = record
        case integer of
            0: (Memory: TDSTORAGE_SOURCE_MEMORY);
            1: (SourceFile: TDSTORAGE_SOURCE_FILE);
    end;

    /// <summary>
    /// Describes the destination for a DirectStorage request.  For a request, the
    /// value of `request.Options.DestinationType` determines which of these union
    /// fields is active.
    /// </summary>
    TDSTORAGE_DESTINATION = record
        case integer of
            0: (Memory: TDSTORAGE_DESTINATION_MEMORY);
            1: (Buffer: TDSTORAGE_DESTINATION_BUFFER);
            2: (Texture: TDSTORAGE_DESTINATION_TEXTURE_REGION);
            3: (MultipleSubresources: TDSTORAGE_DESTINATION_MULTIPLE_SUBRESOURCES);
            4: (Tiles: TDSTORAGE_DESTINATION_TILES);
            5: (MultipleSubresourcesRange: TDSTORAGE_DESTINATION_MULTIPLE_SUBRESOURCES_RANGE);
    end;




    /// Represents a DirectStorage request.


    TDSTORAGE_REQUEST = record
        /// Combination of decompression and other options for this request.
        Options: TDSTORAGE_REQUEST_OPTIONS;
        /// The source for this request.
        Source: TDSTORAGE_SOURCE;
        /// The destination for this request.
        Destination: TDSTORAGE_DESTINATION;
        /// The uncompressed size in bytes for the destination for this request.
        /// If the request is not compressed, then this can be left as 0.
        ///
        /// For compressed data, if the destination is memory, then the uncompressed size must
        /// exactly equal the destination size. For other destination types, the uncompressed
        /// size may be greater than the destination size.
        ///
        /// If the destination is to memory or buffer, then the destination size should
        /// be specified in the corresponding struct (for example, DSTORAGE_DESTINATION_MEMORY).
        /// For textures, it's the value of pTotalBytes returned by GetCopyableFootprints.
        /// For tiles, it's 64k * number of tiles.
        UncompressedSize: uint32;
        /// An arbitrary UINT64 number used for cancellation matching.
        CancellationTag: uint64;
        /// Optional name of the request. Used for debugging. If specified, the
        /// string should be accessible until the request completes.
        {_In_opt_z_ } Name: pchar;
    end;
    PDSTORAGE_REQUEST = ^TDSTORAGE_REQUEST;




    /// Flags controlling the behavior of requests enqueued using EnqueueRequests.


    TDSTORAGE_ENQUEUE_REQUEST_FLAGS = (
        /// Requests wait on the ID3D12Fence before writing to the destination.
        /// All processing required for the requests before the write can be
        /// completed asynchronously once submitted. This is the default behavior.
        DSTORAGE_ENQUEUE_REQUEST_FLAG_NONE = 0,
        /// Requests wait on the ID3D12Fence before utilizing the GPU for any of
        /// the requests and before writing to the destination. All processing
        /// required for the requests, except GPU work or writing to the
        /// destination, can be completed asynchronously once submitted.
        DSTORAGE_ENQUEUE_REQUEST_FLAG_FENCE_WAIT_BEFORE_GPU_WORK = 1,
        /// Requests wait on the ID3D12Fence before reading from the source. No
        /// processing occurs until the ID3D12Fence is set.
        DSTORAGE_ENQUEUE_REQUEST_FLAG_FENCE_WAIT_BEFORE_SOURCE_ACCESS = 2);

    PDSTORAGE_ENQUEUE_REQUEST_FLAGS = ^TDSTORAGE_ENQUEUE_REQUEST_FLAGS;




    /// The type of command that failed, as reported by
    /// DSTORAGE_ERROR_FIRST_FAILURE.


    TDSTORAGE_COMMAND_TYPE = (
        DSTORAGE_COMMAND_TYPE_NONE = -1,
        DSTORAGE_COMMAND_TYPE_REQUEST = 0,
        DSTORAGE_COMMAND_TYPE_STATUS = 1,
        DSTORAGE_COMMAND_TYPE_SIGNAL = 2,
        DSTORAGE_COMMAND_TYPE_EVENT = 3);

    PDSTORAGE_COMMAND_TYPE = ^TDSTORAGE_COMMAND_TYPE;


    /// The parameters passed to the EnqueueRequest call, and optional
    /// filename if the request is for a file source.


    TDSTORAGE_ERROR_PARAMETERS_REQUEST = record
        /// For a file source request, the name of the file the request was
        /// targeted to.
        Filename: array [0..MAX_PATH - 1] of WCHAR;
        /// The name of the request if one was specified.
        RequestName: array [0..DSTORAGE_REQUEST_MAX_NAME - 1] of char;
        /// The parameters passed to the EnqueueRequest call.
        Request: TDSTORAGE_REQUEST;
    end;
    PDSTORAGE_ERROR_PARAMETERS_REQUEST = ^TDSTORAGE_ERROR_PARAMETERS_REQUEST;




    /// The parameters passed to the EnqueueStatus call.


    TDSTORAGE_ERROR_PARAMETERS_STATUS = record
        StatusArray: PIDStorageStatusArray;
        Index: uint32;
    end;
    PDSTORAGE_ERROR_PARAMETERS_STATUS = ^TDSTORAGE_ERROR_PARAMETERS_STATUS;


    /// The parameters passed to the EnqueueSignal call.


    TDSTORAGE_ERROR_PARAMETERS_SIGNAL = record
        Fence: PID3D12Fence;
        Value: uint64;
    end;
    PDSTORAGE_ERROR_PARAMETERS_SIGNAL = ^TDSTORAGE_ERROR_PARAMETERS_SIGNAL;


    /// The parameters passed to the EnqueueSetEvent call.


    TDSTORAGE_ERROR_PARAMETERS_EVENT = record
        Handle: HANDLE;
    end;
    PDSTORAGE_ERROR_PARAMETERS_EVENT = ^TDSTORAGE_ERROR_PARAMETERS_EVENT;




    /// Structure to receive the detailed record of the first failed DirectStorage
    /// request.


    TDSTORAGE_ERROR_FIRST_FAILURE = record
        /// The HRESULT code of the failure.
        HResult: HRESULT;
        /// Type of the Enqueue command that caused the failure.
        CommandType: TDSTORAGE_COMMAND_TYPE;
            /// The parameters passed to the Enqueue call.
        case integer of
            0: (
                Request: TDSTORAGE_ERROR_PARAMETERS_REQUEST;
            );
            1: (
                Status: TDSTORAGE_ERROR_PARAMETERS_STATUS;
            );
            2: (
                Signal: TDSTORAGE_ERROR_PARAMETERS_SIGNAL;
            );
            3: (
                Event: TDSTORAGE_ERROR_PARAMETERS_EVENT;
            );
    end;
    PDSTORAGE_ERROR_FIRST_FAILURE = ^TDSTORAGE_ERROR_FIRST_FAILURE;




    /// Structure to receive the detailed record of a failed DirectStorage request.


    TDSTORAGE_ERROR_RECORD = record
        /// The number of failed requests in the queue since the last
        /// RetrieveErrorRecord call.
        FailureCount: uint32;
        /// Detailed record about the first failed command in the enqueue order.
        FirstFailure: TDSTORAGE_ERROR_FIRST_FAILURE;
    end;
    PDSTORAGE_ERROR_RECORD = ^TDSTORAGE_ERROR_RECORD;




    /// Defines common staging buffer sizes.


    TDSTORAGE_STAGING_BUFFER_SIZE = (
        /// There is no staging buffer.  Use this value to force DirectStorage to
        /// deallocate any memory it has allocated for staging buffers.
        DSTORAGE_STAGING_BUFFER_SIZE_0 = 0,
        /// The default staging buffer size of 32MB.
        DSTORAGE_STAGING_BUFFER_SIZE_32MB = 32 * 1048576);

    PDSTORAGE_STAGING_BUFFER_SIZE = ^TDSTORAGE_STAGING_BUFFER_SIZE;




    /// Flags used with GetRequests1 when requesting
    /// items from the custom decompression queue.


    TDSTORAGE_GET_REQUEST_FLAGS = (
        /// Request entries that use custom decompression formats
        /// >= DSTORAGE_CUSTOM_COMPRESSION_0.
        DSTORAGE_GET_REQUEST_FLAG_SELECT_CUSTOM = $01,
        /// Request entries that use built in compression formats
        /// that DirectStorage understands.
        DSTORAGE_GET_REQUEST_FLAG_SELECT_BUILTIN = $02,
        /// Request all entries. This includes custom decompression and
        /// built-in compressed formats.
        DSTORAGE_GET_REQUEST_FLAG_SELECT_ALL = Ord(DSTORAGE_GET_REQUEST_FLAG_SELECT_CUSTOM) or Ord(DSTORAGE_GET_REQUEST_FLAG_SELECT_BUILTIN));

    PDSTORAGE_GET_REQUEST_FLAGS = ^TDSTORAGE_GET_REQUEST_FLAGS;




    /// Specifies information about a custom decompression request.


    TDSTORAGE_CUSTOM_DECOMPRESSION_FLAGS = (
        /// No additional information.
        DSTORAGE_CUSTOM_DECOMPRESSION_FLAG_NONE = $00,
        /// The uncompressed destination buffer is located in an
        /// upload heap, and is marked as WRITE_COMBINED.
        DSTORAGE_CUSTOM_DECOMPRESSION_FLAG_DEST_IN_UPLOAD_HEAP = $01);

    PDSTORAGE_CUSTOM_DECOMPRESSION_FLAGS = ^TDSTORAGE_CUSTOM_DECOMPRESSION_FLAGS;




    /// A custom decompression request. Use IDStorageCustomDecompressionQueue to
    /// retrieve these requests.


    TDSTORAGE_CUSTOM_DECOMPRESSION_REQUEST = record
        /// An identifier provided by DirectStorage. This should be used to
        /// identify the request in DSTORAGE_CUSTOM_DECOMPRESSION_RESULT. This
        /// identifier is unique among uncompleted requests, but may be reused after
        /// a request has completed.
        Id: uint64;
        /// The compression format.  This will be >= DSTORAGE_CUSTOM_COMPRESSION_0
        /// if DSTORAGE_CUSTOM_DECOMPRESSION_CUSTOMONLY is used to retrieve requests.
        CompressionFormat: TDSTORAGE_COMPRESSION_FORMAT;
        /// Reserved for future use.
        Reserved: array [0..3 - 1] of uint8;
        /// Flags containing additional details about the decompression request.
        Flags: TDSTORAGE_CUSTOM_DECOMPRESSION_FLAGS;
        /// The size of SrcBuffer in bytes.
        SrcSize: uint64;
        /// The compressed source buffer.
        SrcBuffer: Pvoid;
        /// The size of DstBuffer in bytes.
        DstSize: uint64;
        /// The uncompressed destination buffer. SrcBuffer should be decompressed to
        /// DstBuffer.
        DstBuffer: Pvoid;
    end;
    PDSTORAGE_CUSTOM_DECOMPRESSION_REQUEST = ^TDSTORAGE_CUSTOM_DECOMPRESSION_REQUEST;




    /// The result of a custom decompression operation. If the request failed, then
    /// the Result code is passed back through the standard DirectStorage
    /// status/error reporting mechanism.


    TDSTORAGE_CUSTOM_DECOMPRESSION_RESULT = record
        /// The identifier for the request, from DSTORAGE_CUSTOM_DECOMPRESSION_REQUEST.
        Id: uint64;
        /// The result of this decompression. S_OK indicates success.
        Result: HRESULT;
    end;
    PDSTORAGE_CUSTOM_DECOMPRESSION_RESULT = ^TDSTORAGE_CUSTOM_DECOMPRESSION_RESULT;




    /// A queue of decompression requests. This can be obtained using QueryInterface
    /// against the factory. Your application must take requests from this queue,
    /// decompress them, and report that decompression is complete. That allows an
    /// application to provide its own custom decompression.



    IDStorageCustomDecompressionQueue = interface(IUnknown)
        ['{97179b2f-2c21-49ca-8291-4e1bf4a160df}']
        /// Obtains an event to wait on. This event is set when there are pending
        /// decompression requests.
        function GetEvent(): HANDLE; stdcall;

        /// Populates the given array of request structs with new pending requests.
        /// Your application must arrange to fulfill all these requests, and then
        /// call SetRequestResults to indicate completion.
        function GetRequests(
        {_In_ } maxRequests: uint32;
        {_Out_writes_to_(maxRequests, *numRequests) } requests: PDSTORAGE_CUSTOM_DECOMPRESSION_REQUEST;
        {_Out_ } numRequests: PUINT32): HRESULT; stdcall;

        /// Your application calls this to indicate that requests have been
        /// completed.
        /// <param name="numResults">The number of results in `results`.</param>
        /// <param name="results">An array of results, the size is specified by
        /// `numResults.`</param>
        /// <returns>Standard HRESULT error code.</returns>
        function SetRequestResults(
        {_In_ } numResults: uint32;
        {_In_reads_(numResults) } results: PDSTORAGE_CUSTOM_DECOMPRESSION_RESULT): HRESULT; stdcall;

    end;



    /// An extension of IDStorageCustomDecompressionQueue that allows an
    /// application to retrieve specific types of custom decompression
    /// requests from the decompression queue.



    IDStorageCustomDecompressionQueue1 = interface(IDStorageCustomDecompressionQueue)
        ['{0D47C6C9-E61A-4706-93B4-68BFE3F4AA4A}']
        /// Populates the given array of request structs with new pending requests
        /// based on the specified custom decompression request type.
        /// The application must arrange to fulfill all these requests, and then
        /// call SetRequestResults to indicate completion.
        function GetRequests1(
        {_In_ } flags: TDSTORAGE_GET_REQUEST_FLAGS;
        {_In_ } maxRequests: uint32;
        {_Out_writes_to_(maxRequests, *numRequests) } requests: PDSTORAGE_CUSTOM_DECOMPRESSION_REQUEST;
        {_Out_ } numRequests: PUINT32): HRESULT; stdcall;

    end;


    /// Represents the static DirectStorage object used to create DirectStorage
    /// queues, open files for DirectStorage access, and other global operations.


    IDStorageFactory = interface(IUnknown)
        ['{6924ea0c-c3cd-4826-b10a-f64f4ed927c1}']
        /// Creates a DirectStorage queue object.
        /// <param name="desc">Descriptor to specify the properties of the queue.</param>
        /// <param name="riid">Specifies the DirectStorage queue interface, such as
        /// __uuidof(IDStorageQueue).</param>
        /// <param name="ppv">Receives the new queue created.</param>
        /// <returns>Standard HRESULT error code.</returns>
        function CreateQueue(desc: PDSTORAGE_QUEUE_DESC; riid: REFIID;
        {_COM_Outptr_ }  out ppv): HRESULT; stdcall;

        /// Opens a file for DirectStorage access.
        /// <param name="path">Path of the file to be opened.</param>
        /// <param name="riid">Specifies the DirectStorage file interface, such as
        /// __uuidof(IDStorageFile).</param>
        /// <param name="ppv">Receives the new file opened.</param>
        /// <returns>Standard HRESULT error code.</returns>
        function OpenFile(
        {_In_z_ } path: PWCHAR; riid: REFIID;
        {_COM_Outptr_ }  out ppv): HRESULT; stdcall;

        /// Creates a DirectStorage status array object.
        /// <param name="capacity">Specifies the number of statuses that the array can
        /// hold.</param>
        /// <param name="name">Specifies object's name that will appear in
        //  the ETW events if enabled through the debug layer. This is an optional
        //  parameter.</param>
        /// <param name="riid">Specifies the DirectStorage status interface, such as
        /// __uuidof(IDStorageStatusArray).</param>
        /// <param name="ppv">Receives the new status array object created.</param>
        /// <returns>Standard HRESULT error code.</returns>
        function CreateStatusArray(capacity: uint32;
        {_In_opt_ } Name: PCSTR; riid: REFIID;
        {_COM_Outptr_ }  out ppv): HRESULT; stdcall;

        /// Sets flags used to control the debug layer.
        /// <param name="flags">A set of flags controlling the debug layer.</param>
        procedure SetDebugFlags(flags: uint32); stdcall;

        /// Sets the size of staging buffer(s) used to temporarily store content loaded
        /// from the storage device before they are decompressed. If only uncompressed
        /// memory sourced queues writing to cpu memory destinations are used, then the
        /// staging buffer may be 0-sized.
        /// <param name="size">Size, in bytes, of each staging buffer used
        /// to complete a request.</param>
        ///
        /// <remarks>
        /// The default staging buffer is DSTORAGE_STAGING_BUFFER_SIZE_32MB.
        /// If multiple staging buffers are necessary to complete a request, then each
        /// separate staging buffer is allocated to this staging buffer size.
        ///
        /// If the destination is a GPU resource, then some but not all of the staging
        /// buffers will be allocated from VRAM.
        ///
        /// Requests that exceed the specified size to SetStagingBufferSize will fail.
        /// </remarks>
        function SetStagingBufferSize(size: uint32): HRESULT; stdcall;

    end;


    /// Represents an array of status entries to receive completion results for the
    /// read requests before them.
    /// <remarks>
    /// A status entry receives completion status for all the requests in the
    /// DStorageQueue between where it is enqueued and the previously enqueued
    /// status entry. Only when all requests enqueued before the status entry
    /// complete (that is, IsComplete for the entry returns true), the status entry
    /// can be enqueued again.
    /// </remarks>


    IDStorageStatusArray = interface(IUnknown)
        ['{82397587-7cd5-453b-a02e-31379bd64656}']
        /// Returns a Boolean value indicating that all requests enqueued prior to the
        /// specified status entry have completed.
        /// <param name="index">Specifies the index of the status entry to retrieve.</param>
        /// <returns>Boolean value indicating completion.</returns>
        /// <remarks>This is equivalent to `GetHResult(index) != E_PENDING`.</remarks>
        function IsComplete(index: uint32): boolean; stdcall;

        /// Returns the HRESULT code of all requests between the specified status
        /// entry and the status entry enqueued before it.
        /// <param name="index">Specifies the index of the status entry to retrieve.</param>
        /// <returns>HRESULT code of the requests.</returns>
        /// <remarks>
        /// <list type="bullet">
        /// <item><description>
        /// If any requests have not completed yet, the return value is E_PENDING.
        /// </description></item>
        /// <item><description>
        /// If all requests have completed, and there were failure(s), then the return
        /// value stores the failure code of the first failed request in the enqueue
        /// order.
        /// </description></item>
        /// <item><description>
        /// If all requests have completed successfully, then the return value is S_OK.
        /// </description></item>
        /// </list>
        /// </remarks>
        function GetHResult(index: uint32): HRESULT; stdcall;

    end;




    /// Represents a DirectStorage queue to perform read operations.


    IDStorageQueue = interface(IUnknown)
        ['{cfdbd83f-9e06-4fda-8ea5-69042137f49b}']
        /// Enqueues a read request to the queue. The request remains in the queue
        /// until Submit is called, or until the queue is half full.
        /// If there are no free entries in the queue, then the enqueue operation
        /// blocks until one becomes available.
        /// <param name="request">The read request to be queued.</param>
        procedure EnqueueRequest(request: PDSTORAGE_REQUEST); stdcall;

        /// Enqueues a status write. The status write happens when all requests
        /// before the status write entry complete. If there were failure(s)
        /// since the previous status write entry, then the HResult of the enqueued
        /// status entry stores the failure code of the first failed request in the
        /// enqueue order.
        /// If there are no free entries in the queue, then the enqueue operation
        /// blocks until one becomes available.
        /// <param name="statusArray">IDStorageStatusArray object.</param>
        /// <param name="index">Index of the status entry in the
        /// IDStorageStatusArray object to receive the status.</param>
        procedure EnqueueStatus(statusArray: PIDStorageStatusArray; index: uint32); stdcall;

        /// Enqueues fence write. The fence write happens when all requests before
        /// the fence entry complete.
        /// If there are no free entries in the queue, then the enqueue operation will
        /// block until one becomes available.
        /// <param name="fence">An ID3D12Fence to be written.</param>
        /// <param name="value">The value to write to the fence.</param>
        procedure EnqueueSignal(fence: PID3D12Fence; Value: uint64); stdcall;

        /// Submits all requests enqueued so far to DirectStorage to be executed.
        procedure Submit(); stdcall;

        /// Attempts to cancel a group of previously enqueued read requests. All
        /// previously enqueued requests whose CancellationTag matches the formula
        /// (CancellationTag & mask) == value will be cancelled.
        /// A cancelled request might or might not complete its original read request.
        /// A cancelled request is not counted as a failure in either
        /// IDStorageStatus or DSTORAGE_ERROR_RECORD.
        /// <param name="mask">The mask for the cancellation formula.</param>
        /// <param name="value">The value for the cancellation formula.</param>
        procedure CancelRequestsWithTag(mask: uint64; Value: uint64); stdcall;

        /// Closes the DirectStorage queue, regardless of the reference count on this
        /// object.
        ///
        /// After the Close function returns, the queue will no longer complete any
        /// more requests, even if some are submitted. This does not modify the
        /// reference count on this object; Release() must be called as usual.
        procedure Close(); stdcall;

        /// Obtains an event to wait on. When there is any error happening for read
        /// requests in this queue, the event will be signaled, and you may call
        /// RetrieveErrorRecord to retrieve diagnostic information.
        /// <returns>HANDLE to an event.</returns>
        function GetErrorEvent(): HANDLE; stdcall;

        /// When the error event is signaled, this function can be called to
        /// retrieve a DSTORAGE_ERROR_RECORD. Once the error record is retrieved,
        /// this function should not be called until the next time the error event
        /// is signaled.
        /// <param name="record">Receives the error record.</param>
        procedure RetrieveErrorRecord(
        {_Out_ } ErrorRecord: PDSTORAGE_ERROR_RECORD); stdcall;

        /// Obtains information about the queue. It includes the DSTORAGE_QUEUE_DESC
        /// structure used for the queue's creation as well as the number of empty slots
        /// and number of entries that need to be enqueued to trigger automatic
        /// submission.
        /// <param name="info">Receives the queue information.</param>
        procedure Query(
        {_Out_ } info: PDSTORAGE_QUEUE_INFO); stdcall;

    end;


    /// Represents a DirectStorage queue to perform read operations.


    IDStorageQueue1 = interface(IDStorageQueue)
        ['{dd2f482c-5eff-41e8-9c9e-d2374b278128}']
        /// Enqueues an operation to set the specified event object to a signaled state.
        /// The event object is set when all requests before it complete.
        /// If there are no free entries in the queue the enqueue operation will
        /// block until one becomes available.
        /// <param name="handle">A handle to an event object.</param>
        procedure EnqueueSetEvent(handle: HANDLE); stdcall;

    end;


    /// Flags returned with GetCompressionSupport that describe the features
    /// used by the runtime to decompress content.


    TDSTORAGE_COMPRESSION_SUPPORT = (
        /// None
        DSTORAGE_COMPRESSION_SUPPORT_NONE = $0,
        /// Optimized driver support for GPU decompression will be used.
        DSTORAGE_COMPRESSION_SUPPORT_GPU_OPTIMIZED = $01,
        /// Built-in GPU decompression fallback shader will be used.  This can occur if
        /// optimized driver support is not available and the D3D12 device used for this
        /// DirectStorage queue supports the required capabilities.
        DSTORAGE_COMPRESSION_SUPPORT_GPU_FALLBACK = $02,
        /// CPU fallback implementation will be used.
        /// This can occur if:
        /// * Optimized driver support and built-in GPU decompression is not available.
        /// * GPU decompression support has been explicitly disabled using
        ///   DSTORAGE_CONFIGURATION.
        /// * DirectStorage runtime encounters a failure during initialization of its
        ///   GPU decompression system.
        DSTORAGE_COMPRESSION_SUPPORT_CPU_FALLBACK = $04,
        /// Executes work on a compute queue.
        DSTORAGE_COMPRESSION_SUPPORT_USES_COMPUTE_QUEUE = $08,
        /// Executes work on a copy queue.
        DSTORAGE_COMPRESSION_SUPPORT_USES_COPY_QUEUE = $010);

    PDSTORAGE_COMPRESSION_SUPPORT = ^TDSTORAGE_COMPRESSION_SUPPORT;




    /// Represents a DirectStorage queue to perform read operations.


    IDStorageQueue2 = interface(IDStorageQueue1)
        ['{b1c9d643-3a49-44a2-b46f-653649470d18}']
        /// Obtains support information about the queue for a specified compression format.
        /// It includes the chosen path that the DirectStorage runtime will use for decompression.
        /// <param name="format">Specifies the compression format to retrieve information
        /// about.</param>
        function GetCompressionSupport(format: TDSTORAGE_COMPRESSION_FORMAT): TDSTORAGE_COMPRESSION_SUPPORT; stdcall;

    end;


    /// Represents a DirectStorage queue to perform read operations.


    IDStorageQueue3 = interface(IDStorageQueue2)
        ['{deb54c52-eca8-46b3-82a7-031b72262653}']
        /// Enqueues an array of requests to the queue. The requests will be synchronized
        /// with the specified `ID3D12Fence` and processed after the synchronization point.
        /// <param name="requests">A pointer to an array of requests that will be synchronized
        /// with the `ID3D12Fence`.</param>
        /// <param name="numRequests">The number of requests in the array pointed to by
        /// `requests`.</param>
        /// <param name="fence">A pointer to an `ID3D12Fence` that will be used to synchronize
        /// the processing of the requests pointed to by `requests`.</param>
        /// <param name="value">The value the `fence` will wait for. Once the `fence` reaches
        /// the specified `value`, the `requests` will start processing past the
        /// synchronization point.</param>
        /// <param name="flag">A flag that specifies the synchronization point for the
        /// `requests`.</param>
        procedure EnqueueRequests(
        {_In_reads_(numRequests) } requests: PDSTORAGE_REQUEST; numRequests: UINT;
        {_In_opt_ } fence: PID3D12Fence; Value: uint64; flag: TDSTORAGE_ENQUEUE_REQUEST_FLAGS); stdcall;

    end;




    /// DirectStorage Configuration. Zero initializing this will result in the default values.


    TDSTORAGE_CONFIGURATION = record
        /// Sets the number of threads to use for submitting IO operations.
        /// Specifying 0 means use the system's best guess at a good value.
        /// Default == 0.
        NumSubmitThreads: uint32;
        /// Sets the number of threads to be used by the DirectStorage runtime to
        /// decompress data using the CPU for built-in compressed formats
        /// that cannot be decompressed using the GPU.
        ///
        /// Specifying 0 means to use the system's best guess at a good value.
        ///
        /// Specifying DSTORAGE_DISABLE_BUILTIN_CPU_DECOMPRESSION means no decompression
        /// threads will be created and the title is fully responsible for checking
        /// the custom decompression queue and pulling off ALL entries to decompress.
        ///
        /// Default == 0.
        NumBuiltInCpuDecompressionThreads: int32;
        /// Forces the use of the IO mapping layer, even when running on an
        /// operation system that doesn't require it.  This may be useful during
        /// development, but should be set to the FALSE for release. Default=FALSE.
        ForceMappingLayer: winbool;
        /// Disables the use of the bypass IO optimization, even if it is available.
        /// This might be useful during development, but should be set to FALSE
        /// for release unless ForceFileBuffering is set to TRUE.
        /// Default == FALSE.
        DisableBypassIO: winbool;
        /// Disables the reporting of telemetry data when set to TRUE.
        /// Telemetry data is enabled by default in the DirectStorage runtime.
        /// Default == FALSE.
        DisableTelemetry: winbool;
        /// Disables the use of a decompression metacommand, even if one
        /// is available. This will force the runtime to use the built-in GPU decompression
        /// fallback shader.
        /// This may be useful during development, but should be set to the FALSE
        /// for release. Default == FALSE.
        DisableGpuDecompressionMetacommand: winbool;
        /// Disables the use of GPU based decompression, even if it is available.
        /// This will force the runtime to use the CPU. Default=FALSE.
        DisableGpuDecompression: winbool;
    end;
    PDSTORAGE_CONFIGURATION = ^TDSTORAGE_CONFIGURATION;




    /// DirectStorage Configuration. Zero initializing this will result in the default values.


    TDSTORAGE_CONFIGURATION1 = record
        /// Sets the number of threads to use for submitting IO operations.
        /// Specifying 0 means use the system's best guess at a good value.
        /// Default == 0.
        NumSubmitThreads: uint32;
        /// Sets the number of threads to be used by the DirectStorage runtime to
        /// decompress data using the CPU for built-in compressed formats
        /// that cannot be decompressed using the GPU.
        ///
        /// Specifying 0 means to use the system's best guess at a good value.
        ///
        /// Specifying DSTORAGE_DISABLE_BUILTIN_CPU_DECOMPRESSION means no decompression
        /// threads will be created and the title is fully responsible for checking
        /// the custom decompression queue and pulling off ALL entries to decompress.
        ///
        /// Default == 0.
        NumBuiltInCpuDecompressionThreads: int32;
        /// Forces the use of the IO mapping layer, even when running on an
        /// operation system that doesn't require it.  This may be useful during
        /// development, but should be set to the FALSE for release. Default=FALSE.
        ForceMappingLayer: winbool;
        /// Disables the use of the bypass IO optimization, even if it is available.
        /// This might be useful during development, but should be set to FALSE
        /// for release unless ForceFileBuffering is set to TRUE.
        /// Default == FALSE.
        DisableBypassIO: winbool;
        /// Disables the reporting of telemetry data when set to TRUE.
        /// Telemetry data is enabled by default in the DirectStorage runtime.
        /// Default == FALSE.
        DisableTelemetry: winbool;
        /// Disables the use of a decompression metacommand, even if one
        /// is available. This will force the runtime to use the built-in GPU decompression
        /// fallback shader.
        /// This may be useful during development, but should be set to the FALSE
        /// for release. Default == FALSE.
        DisableGpuDecompressionMetacommand: winbool;
        /// Disables the use of GPU based decompression, even if it is available.
        /// This will force the runtime to use the CPU. Default=FALSE.
        DisableGpuDecompression: winbool;
        /// Forces the use of the built-in file caching behaviors supported
        /// within the Windows operating system by not setting
        /// FILE_FLAG_NO_BUFFERING when opening files.
        ///
        /// DisableBypassIO must be set to TRUE when using this option or
        /// E_DSTORAGE_FILEBUFFERING_REQUIRES_DISABLED_BYPASSIO will be returned.
        ///
        /// It is the title's responsibility to know when to use this setting.
        /// This feature should ONLY be enabled for slower HDD drives that will
        /// benefit from the OS file buffering features.
        ///
        /// WARNING: Enabling file buffering on high speed drives may reduce
        /// overall performance when reading from that drive because BypassIO
        /// is also disabled. Default=FALSE.
        ForceFileBuffering: winbool;
    end;
    PDSTORAGE_CONFIGURATION1 = ^TDSTORAGE_CONFIGURATION1;




    /// Settings controlling DirectStorage compression codec behavior.


    TDSTORAGE_COMPRESSION = (
        /// Compress data at a fast rate which may not yield the best
        /// compression ratio.
        DSTORAGE_COMPRESSION_FASTEST = -1,
        /// Compress data at an average rate with a good compression ratio.
        DSTORAGE_COMPRESSION_DEFAULT = 0,
        /// Compress data at slow rate with the best compression ratio.
        DSTORAGE_COMPRESSION_BEST_RATIO = 1);

    PDSTORAGE_COMPRESSION = ^TDSTORAGE_COMPRESSION;




    /// Represents the DirectStorage object for compressing and decompressing the buffers.
    ///
    /// Use DStorageCreateCompressionCodec to get an instance of this.
    ///


    IDStorageCompressionCodec = interface(IUnknown)
        ['{84ef5121-9b43-4d03-b5c1-cc34606b262d}']
        /// Compresses a buffer of data using a known compression format at the specifed
        /// compression level.
        /// <param name="uncompressedData">Points to a buffer containing uncompressed data.</param>
        /// <param name="uncompressedDataSize">Size, in bytes, of the uncompressed data buffer.</param>
        /// <param name="compressionSetting">Specifies the compression settings to use.</param>
        /// <param name="compressedBuffer">Points to a buffer where compressed data will be
        /// written.</param>
        /// <param name="compressedBufferSize">Size, in bytes, of the buffer which will receive
        /// the compressed data</param>
        /// <param name="compressedDataSize">Size, in bytes, of the actual size written to compressedBuffer</param>
        /// <returns>Standard HRESULT error code.</returns>
        function CompressBuffer(uncompressedData: Pvoid; uncompressedDataSize: size_t; compressionSetting: TDSTORAGE_COMPRESSION; compressedBuffer: Pvoid; compressedBufferSize: size_t; compressedDataSize: Psize_t): HRESULT; stdcall;

        /// Decompresses data previously compressed using CompressBuffer.
        /// <param name="compressedData">Points to a buffer containing compressed data.</param>
        /// <param name="compressedDataSize">Size, in bytes, of the compressed data buffer.</param>
        /// <param name="uncompressedBuffer">Points to a buffer where uncompressed data will be
        /// written.</param>
        /// <param name="uncompressedBufferSize">Size, in bytes, of the buffer which will receive
        /// the uncompressed data</param>
        /// <param name="uncompressedDataSize">Size, in bytes, of the actual size written to uncompressedBuffer</param>
        /// <returns>Standard HRESULT error code.</returns>
        function DecompressBuffer(compressedData: Pvoid; compressedDataSize: size_t; uncompressedBuffer: Pvoid; uncompressedBufferSize: size_t; uncompressedDataSize: Psize_t): HRESULT; stdcall;

        /// Returns an upper bound estimated size in bytes required to compress the specified data size.
        /// <param name="uncompressedDataSize">Size, in bytes, of the data to be compressed</param>
        function CompressBufferBound(uncompressedDataSize: size_t): size_t; stdcall;

    end;




    /// Configures DirectStorage. This must be called before the first call to
    /// DStorageGetFactory. If this is not called, then default values are used.
    /// <param name="configuration">Specifies the configuration.</param>
    /// <returns>Standard HRESULT error code.  The configuration can only be changed
    /// when no queue is created and no files are open,
    /// E_DSTORAGE_STAGING_BUFFER_LOCKED is returned if this is not the case.</returns>


function DStorageSetConfiguration(configuration: PDSTORAGE_CONFIGURATION): HRESULT; stdcall; external DStorage_DLL;

 /// Configures DirectStorage. This must be called before the first call to
 /// DStorageGetFactory. If this is not called, then default values are used.
 /// <param name="configuration">Specifies the configuration.</param>
 /// <returns>Standard HRESULT error code.  The configuration can only be changed
 /// when no queue is created and no files are open,
 /// E_DSTORAGE_STAGING_BUFFER_LOCKED is returned if this is not the case.</returns>


function DStorageSetConfiguration1(configuration: PDSTORAGE_CONFIGURATION1): HRESULT; stdcall; external DStorage_DLL;


 /// Returns the static DirectStorage factory object used to create DirectStorage queues,
 /// open files for DirectStorage access, and other global operations.
 /// <param name="riid">Specifies the DirectStorage factory interface, such as
 /// __uuidof(IDStorageFactory)</param>
 /// <param name="ppv">Receives the DirectStorage factory object.</param>
 /// <returns>Standard HRESULT error code.</returns>


function DStorageGetFactory(riid: REFIID;
    {_COM_Outptr_ }  out ppv): HRESULT; stdcall; external DStorage_DLL;


 /// Returns an object used to compress/decompress content.
 /// Compression codecs are not thread safe so multiple
 /// instances are required if the codecs need to be used
 /// by multiple threads.
 /// <param name="format">Specifies how the data is compressed.</param>
 /// <param name="numThreads">Specifies maximum number of threads this codec
 /// will use. Specifying 0 means to use the system's best guess at a good value.</param>
 /// <param name="riid">Specifies the DirectStorage compressor/decompressor interface, such as
 /// __uuidof(IDStorageCompressionCodec)</param>
 /// <param name="ppv">Receives the DirectStorage object.</param>
 /// <returns>Standard HRESULT error code.</returns>


function DStorageCreateCompressionCodec(format: TDSTORAGE_COMPRESSION_FORMAT; numThreads: uint32; riid: REFIID;
    {_COM_Outptr_ }  out ppv): HRESULT; stdcall; external DStorage_DLL;



implementation

end.
