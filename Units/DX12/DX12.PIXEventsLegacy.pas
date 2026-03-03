

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// Don't include this file directly - use pix3.h
// This file encodes PIX events in the legacy PIX event format.
unit DX12.PIXEventsLegacy;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils;

const

    PIXEventsReservedRecordSpaceQwords = 64;
    PIXEventsReservedTailSpaceQwords = 2;
    PIXEventsSafeFastCopySpaceQwords = PIXEventsReservedRecordSpaceQwords - PIXEventsReservedTailSpaceQwords;
    PIXEventsGraphicsRecordSpaceQwords = 64;

    //Bits 7-19 (13 bits)
    PIXEventsBlockEndMarker = $00000000000FFF80;

    //Bits 10-19 (10 bits)
    PIXEventsTypeReadMask = $00000000000FFC00;
    PIXEventsTypeWriteMask = $00000000000003FF;
    PIXEventsTypeBitShift = 10;

    //Bits 20-63 (44 bits)
    PIXEventsTimestampReadMask = $FFFFFFFFFFF00000;
    PIXEventsTimestampWriteMask = $00000FFFFFFFFFFF;
    PIXEventsTimestampBitShift = 20;


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
    TPIXEventType = (
        PIXEvent_EndEvent = $000,
        PIXEvent_BeginEvent_VarArgs = $001,
        PIXEvent_BeginEvent_NoArgs = $002,
        PIXEvent_SetMarker_VarArgs = $007,
        PIXEvent_SetMarker_NoArgs = $008,
        PIXEvent_EndEvent_OnContext = $010,
        PIXEvent_BeginEvent_OnContext_VarArgs = $011,
        PIXEvent_BeginEvent_OnContext_NoArgs = $012,
        PIXEvent_SetMarker_OnContext_VarArgs = $017,
        PIXEvent_SetMarker_OnContext_NoArgs = $018);

    PPIXEventType = ^TPIXEventType;

implementation

end.
