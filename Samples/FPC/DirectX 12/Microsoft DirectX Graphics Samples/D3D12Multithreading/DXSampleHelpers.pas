unit DXSampleHelpers;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D12;

type

    { EHrException }

    EHrException = class(Exception)
    private
        m_hr: Hresult;
    public
        constructor Create(const hr: HResult);

    end;


procedure ThrowIfFailed(hr: HRESULT); inline;


function ReadDataFromFile(filename: LPCWSTR; out Data: pbyte; out size: UINT): HRESULT; inline;

procedure GetAssetsPath(out path: widestring);// inline;

procedure NAME_D3D12_OBJECT_INDEXED(constref x: ID3D12Object; Name: widestring; n: UINT);
procedure NAME_D3D12_OBJECT(constref x: ID3D12Object; Name: widestring);
procedure SetNameIndexed(pObject: ID3D12Object; Name: LPCWSTR; index: UINT); inline;
procedure SetName(constref pObject: ID3D12Object; Name: LPCWSTR); inline;

implementation

uses
    Win32.FileAPI,
    Win32.MinWinBase,
    Win32.WinBase;



procedure SetNameIndexed(pObject: ID3D12Object; Name: LPCWSTR; index: UINT); inline;
begin

end;



procedure SetName(constref pObject: ID3D12Object; Name: LPCWSTR); inline;
begin
    pObject.SetName(name);
end;

// Naming helper for ComPtr<T>.
// Assigns the name of the variable as the name of the object.
// The indexed variant will include the index in the name of the object.
procedure NAME_D3D12_OBJECT(constref x: ID3D12Object; Name: widestring);
begin
    SetName(x, PWideChar(Name));
end;



procedure NAME_D3D12_OBJECT_INDEXED(constref x: ID3D12Object; Name: widestring; n: UINT);
begin
    SetName(x, pwidechar(Name+' '+IntToStr(n))); //L#x ???
end;



procedure ThrowIfFailed(hr: HRESULT); inline;
begin
    if (FAILED(hr)) then
    begin
        raise EHrException.Create(hr);
    end;
end;



function ReadDataFromFile(filename: LPCWSTR; out Data: pbyte; out size: UINT): HRESULT;
var
    extendedParams :TCREATEFILE2_EXTENDED_PARAMETERS;
    lFileHandle: Handle;
    fileInfo: TFILE_STANDARD_INFO;
begin
    extendedParams.dwSize := sizeof(TCREATEFILE2_EXTENDED_PARAMETERS);
    extendedParams.dwFileAttributes := FILE_ATTRIBUTE_NORMAL;
    extendedParams.dwFileFlags := FILE_FLAG_SEQUENTIAL_SCAN;
    extendedParams.dwSecurityQosFlags := SECURITY_ANONYMOUS;
    extendedParams.lpSecurityAttributes := nil;
    extendedParams.hTemplateFile := 0;


   lFileHandle:= CreateFile2(filename, GENERIC_READ, FILE_SHARE_READ, OPEN_EXISTING, @extendedParams);

   if (lFileHandle = INVALID_HANDLE_VALUE) then
    begin
        raise Exception.Create('Filehandle invalid');
    end;

    if (not GetFileInformationByHandleEx(lFileHandle, FileStandardInfo, @fileInfo, sizeof(fileInfo))) then
    begin
        raise Exception.Create('File information invalid');
    end;

    if (fileInfo.EndOfFile.HighPart <> 0) then
    begin
        raise Exception.Create('File to big for DX12');
    end;

    GetMem(data, fileInfo.EndOfFile.LowPart);
    size := fileInfo.EndOfFile.LowPart;

    if (not ReadFile(lFileHandle, data, fileInfo.EndOfFile.LowPart, nil, nil)) then
   begin
        raise Exception.Create('File not readable');
    end;

    result:= S_OK;
end;



procedure GetAssetsPath(out path: widestring);
var
    size: DWord;
    assetsPath: array[0..512 - 1] of widechar;
begin
    size := GetModuleFileNameW(0, @assetsPath[0], 512);
    path := ExtractFilePath(WideString(assetsPath)) + 'data\';
end;

{ EHrException }

constructor EHrException.Create(const hr: HResult);
var
    lMsg: string;
begin
    lMsg := Format('HRESULT of 0x%08X',[ UINT(hr)]);
    inherited Create(lMsg); // Basis-Constructor aufrufen
end;

end.
