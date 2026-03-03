//--------------------------------------------------------------------------------------
// File: BinaryReader.h
//
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
//
// http://go.microsoft.com/fwlink/?LinkId=248929
// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------
unit DX12TK.BinaryReader;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12Tk.PlatformHelpers;

type
    // Helper for reading binary data, either from the filesystem a memory buffer.

    { TBinaryReader }

     TBinaryReader = class(TObject)
    private
        // The data currently being read.
        mPos: pbyte;
        mEnd: pbyte;
        mOwnedData: pbyte;
        // Lower level helper reads directly from the filesystem into memory.
        function ReadEntireFile(fileName: widestring; var Data: pbyte; out datasize: size_t): HResult;
    public
        // Constructor reads from the filesystem.
        constructor Create(fileName: widestring);
        // Constructor reads from an existing memory buffer.
        constructor Create({_In_reads_bytes_(dataSize) } dataBlob: pbyte; dataSize: size_t);
        generic function ReadArray<T>(elementCount: size_t):pointer;
        generic function Read<T>():T;
    end;


implementation

//--------------------------------------------------------------------------------------
// File: BinaryReader.cpp
//
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
//
// http://go.microsoft.com/fwlink/?LinkId=248929
// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------



uses
    Windows.Macros,
    Win32.WinBase,
    Win32.MinWinBase,
    Win32.FileAPI;

    { TBinaryReader }

// Reads from the filesystem into memory.
function TBinaryReader.ReadEntireFile(fileName: widestring; var Data: pbyte; out datasize: size_t): HResult;
var
    hFile: TScopedHandle;
    fileInfo: TFILE_STANDARD_INFO;
    bytesRead: DWORD = 0;
begin
    Result := E_INVALIDARG;
    if (fileName = '') then
        Exit;


    dataSize := 0;

    // Open the file.
    hFile := safe_handle(CreateFile2(pwidechar(fileName), GENERIC_READ, FILE_SHARE_READ, OPEN_EXISTING, nil));
    if (hFile = 0) then
    begin
        Result := HRESULT_FROM_WIN32(GetLastError());
        Exit;
    end;
    // Get the file size.

    if (not GetFileInformationByHandleEx(hFile.get(), FileStandardInfo, @fileInfo, sizeof(fileInfo))) then
    begin
        Result := HRESULT_FROM_WIN32(GetLastError());
        Exit;
    end;

    // File is too big for 32-bit allocation, so reject read.
    if (fileInfo.EndOfFile.HighPart > 0) then
    begin
        Result := E_FAIL;
        Exit;
    end;

    // Create enough space for the file data.
    Data := GetMem(fileInfo.EndOfFile.LowPart);

    if (Data = nil) then
    begin
        Result := E_OUTOFMEMORY;
        Exit;
    end;

    // Read the data in.


    if (not ReadFile(hFile.get(), Data, fileInfo.EndOfFile.LowPart, @bytesRead, nil)) then
    begin
        Result := HRESULT_FROM_WIN32(GetLastError());
        Exit;
    end;

    if (bytesRead < fileInfo.EndOfFile.LowPart) then
    begin
        Result := E_FAIL;
        Exit;
    end;
    dataSize := bytesRead;

    Result := S_OK;
end;

// Constructor reads from the filesystem.

constructor TBinaryReader.Create(fileName: widestring);
var
    dataSize: size_t;
    hr: HRESULT;
begin
    mPos := nil;
    mEnd := nil;


    hr := ReadEntireFile(fileName, mOwnedData, dataSize);
    if (FAILED(hr)) then
    begin
        DebugTrace('ERROR: BinaryReader failed (%08X) to load ''%ls''\n',
            [hr, fileName]);
        raise Exception.Create('BinaryReader');
    end;

    mPos := mOwnedData;
    mEnd := mOwnedData + dataSize;
end;

// Constructor reads from an existing memory buffer.

constructor TBinaryReader.Create(dataBlob: pbyte; dataSize: size_t);
begin
    mPos := dataBlob;
    mEnd := dataBlob + dataSize;
end;

generic function TBinaryReader.ReadArray<T>(elementCount: size_t): pointer; inline;
var
    newPos: PByte;
begin
     newPos := mPos + sizeof(T) * elementCount;

     if (newPos < mPos) then
        raise EOverflow.Create('ReadArray');

     if (newPos > mEnd) then
        raise Exception.Create('End of file');

     result:=mPos;
     mPos := newPos;
end;

generic function TBinaryReader.Read<T>(): T; inline;
begin
    result:= T((specialize ReadArray<T>(1))^);
end;

end.
