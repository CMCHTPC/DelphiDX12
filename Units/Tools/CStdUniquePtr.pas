unit CStdUniquePtr;

{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}

interface

uses
    Classes, SysUtils;

type

    { CStdUniquePtr }

    { TCStdUniquePtr }

    generic TCStdUniquePtr<T> = record
    private
        FInstance: T;
    public
        class operator Initialize(var ASelf: TCStdUniquePtr);
        class operator Finalize(var ASelf: TCStdUniquePtr);

        constructor Create(AValue: T);
        property Value: T read FInstance;
    end;


    { TCStdUniquePtrArray }

    generic TCStdUniquePtrArray<T> = record
    private
        FArray: array of T;

    public
        class operator Initialize(var ASelf: TCStdUniquePtrArray);
        class operator Finalize(var ASelf: TCStdUniquePtrArray);
        procedure reset(Count: size_t = 0);
        function get(): pointer;
    end;

generic function make_uniqueObject<T>(): T;


implementation



generic function make_uniqueObject<T>: T;
begin
    Result := T.Create;
end;

{ CStdUniquePtr }

class operator TCStdUniquePtr.Initialize(var ASelf: TCStdUniquePtr);
begin

end;



class operator TCStdUniquePtr.Finalize(var ASelf: TCStdUniquePtr);
begin

end;



constructor TCStdUniquePtr.Create(AValue: T);
begin
    FInstance := AValue;
end;


{ TCStdUniquePtrArray }

class operator TCStdUniquePtrArray.Initialize(var ASelf: TCStdUniquePtrArray);
begin
    SetLength(ASelf.FArray, 0);
end;



class operator TCStdUniquePtrArray.Finalize(var ASelf: TCStdUniquePtrArray);
begin
    SetLength(ASelf.FArray, 0);
end;



procedure TCStdUniquePtrArray.reset(Count: size_t);
begin
    SetLength(FArray, Count);
end;



function TCStdUniquePtrArray.get(): pointer;
begin
    if Length(FArray) > 0 then
        Result := @FArray[0]
    else
        Result := nil;
end;

end.
