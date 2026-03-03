unit RingBuffer;

{// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (c) Microsoft Corporation. All rights reserved}

{$IFDEF FPC}
{$MODE delphi}{$H+}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils;

type

    { TRingBuffer }

    TRingBuffer = class(TObject)
    private
        FStart: UINT;
        FCount: UINT;
        FElements: array of LONGLONG;
        FMaxElements: UINT;
    public
        constructor Create(MaxElements: UINT);
        destructor Destroy; override;
        procedure Add(Element: LONGLONG);
        function GetFirst: LONGLONG;
        function GetLast: LONGLONG;
        function GetCount: UINT;
        procedure Reset;
    end;

implementation

{ TRingBuffer }

constructor TRingBuffer.Create(MaxElements: UINT);
begin
    FStart := 0;
    FCount := 0;
    FMaxElements := MaxElements;
    SetLength(FElements, FMaxElements);
end;



destructor TRingBuffer.Destroy;
begin
    SetLength(FElements, 0);
    inherited Destroy;
end;



procedure TRingBuffer.Add(Element: LONGLONG);
var
    idx: integer;
begin
    idx := (FStart + FCount) mod FMaxElements;
    FElements[idx] := Element;
    if FCount < FMaxElements then
        Inc(FCount)
    else
        FStart := (FStart + 1) mod FMaxElements;
end;



function TRingBuffer.GetFirst: LONGLONG;
begin
    Result := FElements[FStart];
end;



function TRingBuffer.GetLast: LONGLONG;
begin
    Result := FElements[(FStart + FCount - 1) mod FMaxElements];
end;



function TRingBuffer.GetCount: UINT;
begin
    Result := FCount;
end;



procedure TRingBuffer.Reset;
begin
    FStart := 0;
    FCount := 0;
end;

end.
