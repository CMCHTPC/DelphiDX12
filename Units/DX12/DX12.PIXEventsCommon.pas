unit DX12.PIXEventsCommon;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils;

const
    // The PIXBeginEvent and PIXSetMarker functions have an optimized path for
    // copying strings that work by copying 128-bit or 64-bits at a time. In some
    // circumstances this may result in PIX logging the remaining memory after the
    // null terminator.

    // By default this optimization is enabled unless Address Sanitizer is enabled,
    // since this optimization can trigger a global-buffer-overflow when copying
    // string literals.

    // The PIX_ENABLE_BLOCK_ARGUMENT_COPY controls whether or not this optimization
    // is enabled. Applications may also explicitly set this macro to 0 to disable
    // the optimization if necessary.


    // Check for Address Sanitizer on either Clang or MSVC


    PIX_EVENT_METADATA_NONE = $0;
    PIX_EVENT_METADATA_ON_CONTEXT = $1;
    PIX_EVENT_METADATA_STRING_IS_ANSI = $2;
    PIX_EVENT_METADATA_HAS_COLOR = $F0;



    PIXEventsReservedRecordSpaceQwords = 64;
    //this is used to make sure SSE string copy always will end 16-byte write in the current block
    //this way only a check if destination < limit can be performed, instead of destination < limit - 1
    //since both these are UINT64* and SSE writes in 16 byte chunks, 8 bytes are kept in reserve
    //so even if SSE overwrites 8-15 extra bytes, those will still belong to the correct block
    //on next iteration check destination will be greater than limit
    //this is used as well for fixed size UMD events and PIXEndEvent since these require less space
    //than other variable length user events and do not need big reserved space
    PIXEventsReservedTailSpaceQwords = 2;
    PIXEventsSafeFastCopySpaceQwords = PIXEventsReservedRecordSpaceQwords - PIXEventsReservedTailSpaceQwords;
    PIXEventsGraphicsRecordSpaceQwords = 64;

    //Bits 7-19 (13 bits)
    PIXEventsBlockEndMarker = $00000000000FFF80;


    // V2 events

    // Bits 00..06 (7 bits) - Size in QWORDS
    PIXEventsSizeWriteMask = $000000000000007F;
    PIXEventsSizeBitShift = 0;
    PIXEventsSizeReadMask = PIXEventsSizeWriteMask shl PIXEventsSizeBitShift;
    PIXEventsSizeMax = (1 shl 7) - 1;

    // Bits 07..11 (5 bits) - Event Type
    PIXEventsTypeWriteMask = $000000000000001F;
    PIXEventsTypeBitShift = 7;
    PIXEventsTypeReadMask = PIXEventsTypeWriteMask shl PIXEventsTypeBitShift;

    // Bits 12..19 (8 bits) - Event Specific Metadata
    PIXEventsMetadataWriteMask = $00000000000000FF;
    PIXEventsMetadataBitShift = 12;
    PIXEventsMetadataReadMask = PIXEventsMetadataWriteMask shl PIXEventsMetadataBitShift;

    // Buts 20..63 (44 bits) - Timestamp
    PIXEventsTimestampWriteMask = $00000FFFFFFFFFFF;
    PIXEventsTimestampBitShift = 20;
    PIXEventsTimestampReadMask = PIXEventsTimestampWriteMask shl PIXEventsTimestampBitShift;


    //Bits 60-63 (4)
    PIXEventsStringAlignmentWriteMask = $000000000000000F;
    PIXEventsStringAlignmentReadMask = $F000000000000000;
    PIXEventsStringAlignmentBitShift = 60;

    //Bits 55-59 (5)
    PIXEventsStringCopyChunkSizeWriteMask = $000000000000001F;
    PIXEventsStringCopyChunkSizeReadMask = $0F80000000000000;
    PIXEventsStringCopyChunkSizeBitShift = 55;

    //Bit 54
    PIXEventsStringIsANSIWriteMask = $0000000000000001;
    PIXEventsStringIsANSIReadMask = $0040000000000000;
    PIXEventsStringIsANSIBitShift = 54;

    //Bit 53
    PIXEventsStringIsShortcutWriteMask = $0000000000000001;
    PIXEventsStringIsShortcutReadMask = $0020000000000000;
    PIXEventsStringIsShortcutBitShift = 53;


type

    PPIXEventsBlockInfo = pointer;

    TPIXEventsThreadInfo = record
        block: PPIXEventsBlockInfo;
        biasedLimit: PUINT64;
        destination: PUINT64;
    end;
    PPIXEventsThreadInfo = ^TPIXEventsThreadInfo;

    TPIXEventType = (
        PIXEvent_EndEvent = $00,
        PIXEvent_BeginEvent = $01,
        PIXEvent_SetMarker = $02);

    PPIXEventType = ^TPIXEventType;


function PIXEncodeEventInfo(timestamp: uint64; eventType: TPIXEventType; eventSize: uint8; eventMetadata: uint8): uint64; inline;

implementation


function PIXEncodeEventInfo(timestamp: uint64; eventType: TPIXEventType; eventSize: uint8; eventMetadata: uint8): uint64; inline;
begin
    Result :=
        ((timestamp and PIXEventsTimestampWriteMask) shl PIXEventsTimestampBitShift) or ((Ord(eventType) and PIXEventsTypeWriteMask) shl PIXEventsTypeBitShift) or
        ((eventMetadata and PIXEventsMetadataWriteMask) shl PIXEventsMetadataBitShift) or ((eventSize and PIXEventsSizeWriteMask) shl PIXEventsSizeBitShift);
end;


function PIXEncodeIndexColor(color: uint8): uint8; inline;
begin
    // There are 8 index colors, indexed 0 (default) to 7
    Result := (color and $7) shl 4;
end;

end.
