unit DX12.PIXEvents;

{$IFDEF FPC}
{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$POINTERMATH ON}
{$ENDIF}

{$IFOPT D+}
// Xbox does not support CPU events for retail scenarios
{$DEFINE PIX_CONTEXT_EMIT_CPU_EVENTS}
{$DEFINE PIX_USE_GPU_MARKERS_V2}
{$ENDIF}


interface

uses
    Windows, Classes, SysUtils,
    DX12.PIX3,
    DX12.PIX3_Win,
    DX12.PIXEventsCommon,
    DX12.PIXEventsLegacy;


function PIXEncodeEventInfo(timestamp: uint64; eventType: TPIXEventType): uint64;

generic procedure PIXBeginEvent<T>(context: T; color: uint64; formatString: widestring; args: array of const);

generic procedure PIXEndEvent<T>(context: T);

procedure PIXBeginEventOnContextCpu(eventDestination: PUINT64; eventSize: PUINT8; context: pointer; color: uint64; formatString: widestring; args: array of const);
generic function PIXEncodeStringIsAnsi<T>(): uint8; inline;
generic procedure PIXCopyEventArgument<T>({_Out_writes_to_ptr_(limit)} destination: PUINT64;{_In_} const limit: PUINT64; argument: T);
procedure PIXCopyStringArgumentsWithContext({_Out_writes_to_ptr_(limit)} destination: PUINT64; {_In_} const limit: PUINT64; context: pointer; arg: widestring; args: array of const);



implementation


procedure PIXBeginEventOnContextCpuAllocate(eventDestination: PUINT64; eventSize: PUINT8; threadInfo: PPIXEventsThreadInfo; context: Pointer; color: uint64; formatString: widestring; args: array of const);
begin
end;

procedure PIXBeginEventOnContextCpu(eventDestination: PUINT64; eventSize: PUINT8; context: pointer; color: uint64; formatString: widestring; args: array of const);
begin
end;

// Generic template version slower because of the additional clear write
generic procedure PIXCopyEventArgument<T>({_Out_writes_to_ptr_(limit)} destination: PUINT64;{_In_} const limit: PUINT64; argument: T);
begin
    if (destination < limit) then
    begin
        destination^ := 0;
        T(destination^) := argument;
        Inc(destination);
    end;
end;

procedure PIXCopyStringArgument({_Out_writes_to_ptr_(limit)} destination: PUINT64; {_In_} const limit: PUINT64; {_In_}  argument: PCSTR); inline;
begin
end;

procedure PIXCopyStringArgument({_Out_writes_to_ptr_(limit)} destination: PUINT64; {_In_} const limit: PUINT64; {_In_}  argument: PCWSTR); inline;
begin
end;

procedure PIXCopyEventArguments({_Out_writes_to_ptr_(limit)}  destination: PUINT64; {_In_} const limit: PUINT64; args: array of const); inline;
begin
    // nothing
end;

procedure PIXCopyStringArgumentsWithContext({_Out_writes_to_ptr_(limit)} destination: PUINT64; {_In_} const limit: PUINT64; context: pointer; arg: widestring; args: array of const);
begin
    specialize PIXCopyEventArgument<pointer>(destination, limit, context);
    PIXCopyStringArgument(destination, limit, pwidechar(arg));
    PIXCopyEventArguments(destination, limit, args);
end;



generic function PIXEncodeStringIsAnsi<T>(): uint8; inline;
begin
    Result := PIX_EVENT_METADATA_STRING_IS_ANSI;
end;


function PIXEncodeEventInfo(timestamp: uint64; eventType: TPIXEventType
  ): uint64;
begin

end;

generic procedure PIXBeginEvent<T>(context: T; color: uint64; formatString: widestring; args: array of const);
var
    destination: PUINT64 = nil;
    eventSize: uint8 = 0;
    buffer: array [0..PIXEventsGraphicsRecordSpaceQwords - 1] of uint64;
    limit: PUINT64;
    eventDestination: PUINT64;
    eventMetadata: uint8;
begin
    {$IFDEF PIX_CONTEXT_EMIT_CPU_EVENTS}
    PIXBeginEventOnContextCpu(destination, @eventSize, context, color, formatString, args);
    {$ENDIF}

    {$IFDEF PIX_USE_GPU_MARKERS_V2}
    if (destination <> nil) then
    begin
        PIXInsertTimingMarkerOnContextForBeginEvent(context, ord(PIXEvent_BeginEvent), pointer(destination), eventSize * sizeof(UINT64));
    end
    else
    {$ENDIF}
    begin
        {$IFDEF PIX_USE_GPU_MARKERS_V2}
        destination := buffer;
        limit := @buffer[0] + PIXEventsGraphicsRecordSpaceQwords - PIXEventsReservedTailSpaceQwords;

        destination:=destination+1;
        eventDestination := destination;
        destination:=destination+1;
        destination^ := color;

        PIXCopyStringArgumentsWithContext(destination, limit, context, formatString, args);
        destination^ := 0;

        eventSize :=UINT8(destination - @buffer[0]);
        eventMetadata := PIX_EVENT_METADATA_ON_CONTEXT or specialize PIXEncodeStringIsAnsi<widechar>() or PIX_EVENT_METADATA_HAS_COLOR;
        eventDestination^:= DX12.PIXEventsCommon.PIXEncodeEventInfo(0, PIXEvent_BeginEvent, eventSize, eventMetadata);
        PIXInsertGPUMarkerOnContextForBeginEvent(context,ord(PIXEvent_BeginEvent), pointer(@buffer[0]), UINT(PBYTE(destination) - PBYTE(@buffer[0])));
        {$ELSE}
        destination := EncodeBeginEventForContext(buffer, color, formatString, args);
        PIXBeginGPUEventOnContext(context, pointer(buffer), UINT(pbyte(destination) - pbyte(buffer)));
        {$ENDIF}

    end;
end;

generic procedure PIXEndEvent<T>(context: T);
begin

end;

end.
