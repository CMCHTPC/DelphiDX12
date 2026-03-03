//--------------------------------------------------------------------------------------
// File: PlatformHelpers.h

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkId=248929
// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------
unit DX12TK.PlatformHelpers;

{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}

interface

uses
    Windows, Classes, SysUtils;

const
    UINT_MAX = $ffffffff;
    _UI64_MAX = $ffffffffffffffff;

    // See https://walbourn.github.io/modern-c++-bitmask-types/

    {$IFDEF WIN32}
    SIZE_MAX = UINT_MAX;
    {$ELSE}
    SIZE_MAX = uint64(_UI64_MAX);
    {$ENDIF}

type

    // Helper class for COM exceptions
    { ECOMException }

    ECOMException = class(Exception)
    private
        FResult: HResult;
    public
        constructor Create(hr: HResult);
        function get_result: HResult;
    end;

    // Helper smart-pointers

    { TScopedHandle }

    TScopedHandle = record
    private
        FHandle: Handle;
public
        class operator Finalize(var hdl: TScopedHandle);
        class operator := (a: TScopedHandle): Handle;
        class operator := (a: Handle): TScopedHandle;
        class operator = (a1: Handle; a2 : TScopedHandle) b : boolean;
     //   class operator = (a1: shortint; a2 : TScopedHandle) b : boolean;
     //   class operator = (a1: TScopedHandle; a2 : shortint) b : boolean;
         function get(): Handle;
         procedure reset(p: Handle);
    end;

// Helper utility converts D3D API failures into exceptions.
procedure ThrowIfFailed(hr: HRESULT); inline;
function com_exception(hr: HResult): ansistring; inline;

// Helper for output debug tracing
procedure DebugTrace({_In_z_ _Printf_format_string_} fmt: ansistring; const Args: array of const); inline;


// Helper smart-pointers
function safe_handle(h: HANDLE): HANDLE; inline;

implementation


// Helper utility converts D3D API failures into exceptions.
procedure ThrowIfFailed(hr: HRESULT); inline;
begin
    if (FAILED(hr)) then
    begin
        raise Exception.Create(com_exception(hr));
    end;
end;

// Helper class for COM exceptions

function com_exception(hr: HResult): ansistring; inline;
begin
    Result := format('Failure with HRESULT of %8x', [hr]);

end;

// Helper for output debug tracing

procedure DebugTrace(fmt: ansistring; const Args: array of const); inline;
var
    buff: ansistring;
begin
    {$IFOPT D+}
    buff:= format(fmt, args);
    OutputDebugStringA(PAnsiChar(buff));
    {$ENDIF}
end;



function safe_handle(h: HANDLE): HANDLE;
begin
    if (h = INVALID_HANDLE_VALUE) then
        Result := 0
    else
        Result := h;
end;

{ COM_Exception }

constructor ECOMException.Create(hr: HResult);
var
    s: string;
begin
    s := com_exception(hr);
    inherited Create(s);
    FResult := hr;
end;



function ECOMException.get_result: HResult;
begin
    Result := FResult;
end;

{ TScopedHandle }

class operator TScopedHandle.Finalize(var hdl: TScopedHandle);
begin
    if hdl.FHandle <> 0 then
        CloseHandle(hdl.FHandle);
end;



class operator TScopedHandle.:=(a: TScopedHandle): Handle;
begin
    Result := a.FHandle;
end;



class operator TScopedHandle.:=(a: Handle): TScopedHandle;
begin
    Result.FHandle := a;
end;

class operator TScopedHandle.=(a1: Handle; a2: TScopedHandle)b: boolean;
begin
    b := (a1 =a2.FHandle);

end;

function TScopedHandle.get(): Handle;
begin
  result:=FHandle;
end;

procedure TScopedHandle.reset(p: Handle);
begin
    if FHandle <> 0 then
        CloseHandle(FHandle);
   FHandle :=p;
end;

{
class operator TScopedHandle.=(a1: shortint; a2: TScopedHandle)b: boolean;
begin
    b := (a1 =a2.FHandle);
end;

class operator TScopedHandle.=(a1: TScopedHandle; a2: shortint)b: boolean;
begin
    b := (a2 =a1.FHandle);
end;
   }



end.
