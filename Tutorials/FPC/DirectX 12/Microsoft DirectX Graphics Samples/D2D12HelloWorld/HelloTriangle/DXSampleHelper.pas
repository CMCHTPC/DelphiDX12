unit DXSampleHelper;

{$mode Delphi}

interface

uses
    Classes, SysUtils, Windows;

procedure GetAssetsPath(var path: WideString);
procedure ThrowIfFailed(hr: HRESULT);
function HRESULT_FROM_WIN32(x: uint32): HResult;

implementation



function HRESULT_FROM_WIN32(x: uint32): HResult;
begin
    if x <= 0 then
        Result := HRESULT(x)
    else
        Result := ((x and $0000FFFF) or (FACILITY_WIN32 shl 16) or $80000000);
end;



procedure GetAssetsPath(var path: WideString);
var
    lSize: dword;
begin
    SetLength(path, 512);
    lSize := GetModuleFileNameW(0, pwidechar(path), 512);
    path:=ExtractFileDir(path);
    path := IncludeTrailingBackslash(path);
end;



procedure ThrowIfFailed(hr: HRESULT);
begin
    if (FAILED(hr)) then
        raise  Exception(intToHex(hr,8));
end;

end.
