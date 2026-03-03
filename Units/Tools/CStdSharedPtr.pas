unit CStdSharedPtr;


{$IFDEF FPC}
{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Classes, SysUtils;

type

    { TCStdSharedPtr }

    generic TCStdSharedPtr<T> = record
    private
        FData: T;
        FRefCount: ^integer;
        procedure Release;
    public
        class operator Initialize(var Dest: TCStdSharedPtr);
        class operator Finalize(var Dest: TCStdSharedPtr);
        class operator Copy(constref Src: TCStdSharedPtr; var Dest: TCStdSharedPtr);

        constructor Create(AValue: T);
        property Value: T read FData write FData;
    end;

implementation

{ TCStdSharedPtr }

procedure TCStdSharedPtr.Release;
begin
    if FRefCount <> nil then
    begin
        Dec(FRefCount^);
        if FRefCount^ = 0 then
        begin
            FData.Free;
            Dispose(FRefCount);
        end;
    end;
end;



class operator TCStdSharedPtr.Initialize(var Dest: TCStdSharedPtr);
begin
    Dest.FData := nil;
    Dest.FRefCount := nil;
end;



class operator TCStdSharedPtr.Finalize(var Dest: TCStdSharedPtr);
begin
    Dest.Release;
end;



class operator TCStdSharedPtr.Copy(constref Src: TCStdSharedPtr; var Dest: TCStdSharedPtr);
begin
    if Dest.FRefCount <> Src.FRefCount then
    begin
        Dest.Release;
        Dest.FData := Src.FData;
        Dest.FRefCount := Src.FRefCount;
        if Dest.FRefCount <> nil then
            Inc(Dest.FRefCount^);
    end;
end;



constructor TCStdSharedPtr.Create(AValue: T);
begin
    FData := AValue;
    New(FRefCount);
    FRefCount^ := 1;
end;

end.
