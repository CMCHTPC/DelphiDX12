unit CStdFunctions;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils;

procedure memcpy(dest: pointer; Source: pointer; Count: size_t); inline;

function memcmp(ptr1, ptr2: Pointer; n: size_t): longint; inline;

implementation



procedure memcpy(dest: pointer; Source: pointer; Count: size_t); inline;
begin
    move(Source^, dest^, Count);
end;



function memcmp(ptr1, ptr2: Pointer; n: size_t): longint; inline;
begin
    Result := CompareByte(ptr1^, Ptr2^, n);
end;

end.
