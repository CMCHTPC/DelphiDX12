unit Windows.Macros;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils;

function HRESULT_FROM_WIN32(x: longword): HRESULT;
function MAKE_HRESULT(sev, fac, code: longword): HRESULT;

function MAKELONG(a, b: word): DWORD;

function MAKEFOURCC(ch0, ch1, ch2, ch3: char): dword;

 function GET_WHEEL_DELTA_WPARAM(wParam:WPARAM): smallint;
 function GET_XBUTTON_WPARAM(wParam:WPARAM ): word;

implementation

function GET_XBUTTON_WPARAM(wParam:WPARAM ): word;
begin
    result:=HIWORD(wParam);
end;

function GET_WHEEL_DELTA_WPARAM(wParam:WPARAM): smallint;
begin
  result:=smallint(HIWORD(wParam));
end;

function MAKEFOURCC(ch0, ch1, ch2, ch3: char): dword;
begin
    Result := (DWORD(Ord(ch0)) or DWORD(Ord(ch1) shl 8) or DWORD(Ord(ch2) shl 16) or DWORD(Ord(ch3) shl 24));

end;



function HRESULT_FROM_WIN32(x: longword): HRESULT; inline;
begin
    if HRESULT(x) <= 0 then
        Result := HRESULT(x)
    else
        Result := HRESULT((x and $0000FFFF) or (FACILITY_WIN32 shl 16) or $80000000);
end;



function MAKE_HRESULT(sev, fac, code: longword): HRESULT; inline;
begin
    Result := HRESULT((sev shl 31) or (fac shl 16) or code);
end;



function MAKELONG(a, b: word): DWORD; inline;
begin
    Result := a or (b shl 16);
end;

end.
