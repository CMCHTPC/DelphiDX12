//--------------------------------------------------------------------------------------
// File: LoaderHelpers.h

// Helper functions for texture loaders and screen grabber

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkId=248929
// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------
unit DX12TK.LoaderHelpers;

{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}

interface

uses
    Windows, Classes, SysUtils,
    ActiveX,
    DX12TK.DDS,
    DX12.WinCodec,
    DX12.DXGIFormat,
    CStdUniquePtr;

type

    { TAutoDeleteFile }

    TAutoDeleteFile = record
    private
        m_handle: HANDLE;
    public
        procedure Clear();
        class operator Finalize(var aRec: TAutoDeleteFile);
        constructor Create(hFile: HANDLE);
    end;

    { TAutoDeleteFileWIC }

    TAutoDeleteFileWIC = record
    private
        m_filename: widestring;
        m_handle: IWICStream;
    public
        procedure Clear();
        class operator Finalize(var aRec: TAutoDeleteFileWIC);
        constructor Create(hFile: IWICStream; szFile: widestring);
    end;


    TCStdUniquePtr_UINT8 = specialize TCStdUniquePtr<uint8>;
    TCStdUniquePtrArray_UINT8 = specialize TCStdUniquePtrArray<uint8>;

// from PropIDL.h
procedure PropVariantInit({_Out_}  pvar: PPROPVARIANT); inline;

function BitsPerPixel({_In_}  fmt: TDXGI_FORMAT): size_t; inline;
function MakeSRGB({_In_}  format: TDXGI_FORMAT): TDXGI_FORMAT; inline;

function MakeLinear({_In_}  format: TDXGI_FORMAT): TDXGI_FORMAT; inline;
function IsCompressed({_In_}  fmt: TDXGI_FORMAT): boolean; inline;
function EnsureNotTypeless(fmt: TDXGI_FORMAT): TDXGI_FORMAT; inline;

function LoadTextureDataFromMemory({_In_reads_(ddsDataSize)}  ddsData: Puint8; ddsDataSize: size_t; out header: TDDS_HEADER; out bitData: Puint8; out bitSize: size_t): HRESULT; inline;
function LoadTextureDataFromFile({_In_z_ } fileName: pwidechar; ddsData: TCStdUniquePtrArray_UINT8; out header: PDDS_HEADER; out bitData: PUINT8; out bitSize: size_t): HRESULT; inline;

//--------------------------------------------------------------------------------------
// Get surface information for a particular format
//--------------------------------------------------------------------------------------
function GetSurfaceInfo(
    {_In_ } Width: size_t;
    {_In_ } Height: size_t;
    {_In_ } fmt: TDXGI_FORMAT;
    {_Out_opt_ } outNumBytes: Psize_t;
    {_Out_opt_ } outRowBytes: Psize_t;
    {_Out_opt_ } outNumRows: Psize_t): HRESULT;


function GetDXGIFormat(ddpf: TDDS_PIXELFORMAT): TDXGI_FORMAT; inline;
function GetAlphaMode({_In_}  header: PDDS_HEADER): TDDS_ALPHA_MODE; inline;
function CountMips(Width, Height: uint32): uint32; inline;
procedure FitPowerOf2(origx: UINT; origy: UINT; {_Inout_} var targetx: UINT; {_Inout_} var targety: UINT; maxsize: size_t); inline;
function PropVariantClear({_Inout_}  pvar: PPROPVARIANT): HRESULT; stdcall; external 'Ole32.dll';


implementation

uses
    Math,
    Windows.Macros,
    Win32.FileApi,
    Win32.WinBase,
    Win32.MinWinBase,
    DX12TK.PlatFormHelpers,
    DX12.D3DCommon;

const
    UINT32_MAX = $FFFFFFFF;



procedure PropVariantInit({_Out_}  pvar: PPROPVARIANT); inline;
begin
    FillByte(pvar^, sizeof(TPROPVARIANT), 0);
end;


//--------------------------------------------------------------------------------------
// Return the BPP for a particular format
//--------------------------------------------------------------------------------------
function BitsPerPixel({_In_}  fmt: TDXGI_FORMAT): size_t; inline;
begin
    case (fmt) of

        DXGI_FORMAT_R32G32B32A32_TYPELESS,
        DXGI_FORMAT_R32G32B32A32_FLOAT,
        DXGI_FORMAT_R32G32B32A32_UINT,
        DXGI_FORMAT_R32G32B32A32_SINT:
            Result := 128;

        DXGI_FORMAT_R32G32B32_TYPELESS,
        DXGI_FORMAT_R32G32B32_FLOAT,
        DXGI_FORMAT_R32G32B32_UINT,
        DXGI_FORMAT_R32G32B32_SINT:
            Result := 96;

        DXGI_FORMAT_R16G16B16A16_TYPELESS,
        DXGI_FORMAT_R16G16B16A16_FLOAT,
        DXGI_FORMAT_R16G16B16A16_UNORM,
        DXGI_FORMAT_R16G16B16A16_UINT,
        DXGI_FORMAT_R16G16B16A16_SNORM,
        DXGI_FORMAT_R16G16B16A16_SINT,
        DXGI_FORMAT_R32G32_TYPELESS,
        DXGI_FORMAT_R32G32_FLOAT,
        DXGI_FORMAT_R32G32_UINT,
        DXGI_FORMAT_R32G32_SINT,
        DXGI_FORMAT_R32G8X24_TYPELESS,
        DXGI_FORMAT_D32_FLOAT_S8X24_UINT,
        DXGI_FORMAT_R32_FLOAT_X8X24_TYPELESS,
        DXGI_FORMAT_X32_TYPELESS_G8X24_UINT,
        DXGI_FORMAT_Y416,
        DXGI_FORMAT_Y210,
        DXGI_FORMAT_Y216:
            Result := 64;

        DXGI_FORMAT_R10G10B10A2_TYPELESS,
        DXGI_FORMAT_R10G10B10A2_UNORM,
        DXGI_FORMAT_R10G10B10A2_UINT,
        DXGI_FORMAT_R11G11B10_FLOAT,
        DXGI_FORMAT_R8G8B8A8_TYPELESS,
        DXGI_FORMAT_R8G8B8A8_UNORM,
        DXGI_FORMAT_R8G8B8A8_UNORM_SRGB,
        DXGI_FORMAT_R8G8B8A8_UINT,
        DXGI_FORMAT_R8G8B8A8_SNORM,
        DXGI_FORMAT_R8G8B8A8_SINT,
        DXGI_FORMAT_R16G16_TYPELESS,
        DXGI_FORMAT_R16G16_FLOAT,
        DXGI_FORMAT_R16G16_UNORM,
        DXGI_FORMAT_R16G16_UINT,
        DXGI_FORMAT_R16G16_SNORM,
        DXGI_FORMAT_R16G16_SINT,
        DXGI_FORMAT_R32_TYPELESS,
        DXGI_FORMAT_D32_FLOAT,
        DXGI_FORMAT_R32_FLOAT,
        DXGI_FORMAT_R32_UINT,
        DXGI_FORMAT_R32_SINT,
        DXGI_FORMAT_R24G8_TYPELESS,
        DXGI_FORMAT_D24_UNORM_S8_UINT,
        DXGI_FORMAT_R24_UNORM_X8_TYPELESS,
        DXGI_FORMAT_X24_TYPELESS_G8_UINT,
        DXGI_FORMAT_R9G9B9E5_SHAREDEXP,
        DXGI_FORMAT_R8G8_B8G8_UNORM,
        DXGI_FORMAT_G8R8_G8B8_UNORM,
        DXGI_FORMAT_B8G8R8A8_UNORM,
        DXGI_FORMAT_B8G8R8X8_UNORM,
        DXGI_FORMAT_R10G10B10_XR_BIAS_A2_UNORM,
        DXGI_FORMAT_B8G8R8A8_TYPELESS,
        DXGI_FORMAT_B8G8R8A8_UNORM_SRGB,
        DXGI_FORMAT_B8G8R8X8_TYPELESS,
        DXGI_FORMAT_B8G8R8X8_UNORM_SRGB,
        DXGI_FORMAT_AYUV,
        DXGI_FORMAT_Y410,
        {$IFDEF XBOX}
        DXGI_FORMAT_R10G10B10_7E3_A2_FLOAT,
        DXGI_FORMAT_R10G10B10_6E4_A2_FLOAT,
        DXGI_FORMAT_R10G10B10_SNORM_A2_UNORM,
        {$ENDIF}
        DXGI_FORMAT_YUY2:
            Result := 32;

        DXGI_FORMAT_P010,
        DXGI_FORMAT_P016,
        {$IFDEF XBOX}
        DXGI_FORMAT_D16_UNORM_S8_UINT,
        DXGI_FORMAT_R16_UNORM_X8_TYPELESS,
        DXGI_FORMAT_X16_TYPELESS_G8_UINT,
        {$ENDIF}
        DXGI_FORMAT_V408:
            Result := 24;

        DXGI_FORMAT_R8G8_TYPELESS,
        DXGI_FORMAT_R8G8_UNORM,
        DXGI_FORMAT_R8G8_UINT,
        DXGI_FORMAT_R8G8_SNORM,
        DXGI_FORMAT_R8G8_SINT,
        DXGI_FORMAT_R16_TYPELESS,
        DXGI_FORMAT_R16_FLOAT,
        DXGI_FORMAT_D16_UNORM,
        DXGI_FORMAT_R16_UNORM,
        DXGI_FORMAT_R16_UINT,
        DXGI_FORMAT_R16_SNORM,
        DXGI_FORMAT_R16_SINT,
        DXGI_FORMAT_B5G6R5_UNORM,
        DXGI_FORMAT_B5G5R5A1_UNORM,
        DXGI_FORMAT_A8P8,
        DXGI_FORMAT_B4G4R4A4_UNORM,
        DXGI_FORMAT_P208,
        DXGI_FORMAT_V208:
            Result := 16;

        DXGI_FORMAT_NV12,
        DXGI_FORMAT_420_OPAQUE,
        DXGI_FORMAT_NV11:
            Result := 12;

        DXGI_FORMAT_R8_TYPELESS,
        DXGI_FORMAT_R8_UNORM,
        DXGI_FORMAT_R8_UINT,
        DXGI_FORMAT_R8_SNORM,
        DXGI_FORMAT_R8_SINT,
        DXGI_FORMAT_A8_UNORM,
        DXGI_FORMAT_BC2_TYPELESS,
        DXGI_FORMAT_BC2_UNORM,
        DXGI_FORMAT_BC2_UNORM_SRGB,
        DXGI_FORMAT_BC3_TYPELESS,
        DXGI_FORMAT_BC3_UNORM,
        DXGI_FORMAT_BC3_UNORM_SRGB,
        DXGI_FORMAT_BC5_TYPELESS,
        DXGI_FORMAT_BC5_UNORM,
        DXGI_FORMAT_BC5_SNORM,
        DXGI_FORMAT_BC6H_TYPELESS,
        DXGI_FORMAT_BC6H_UF16,
        DXGI_FORMAT_BC6H_SF16,
        DXGI_FORMAT_BC7_TYPELESS,
        DXGI_FORMAT_BC7_UNORM,
        DXGI_FORMAT_BC7_UNORM_SRGB,
        DXGI_FORMAT_AI44,
        DXGI_FORMAT_IA44,
        {$IFDEF XBOX}
        DXGI_FORMAT_R4G4_UNORM,
        {$ENDIF}
        DXGI_FORMAT_P8:
            Result := 8;

        DXGI_FORMAT_R1_UNORM:
            Result := 1;

        DXGI_FORMAT_BC1_TYPELESS,
        DXGI_FORMAT_BC1_UNORM,
        DXGI_FORMAT_BC1_UNORM_SRGB,
        DXGI_FORMAT_BC4_TYPELESS,
        DXGI_FORMAT_BC4_UNORM,
        DXGI_FORMAT_BC4_SNORM:
            Result := 4;

        DXGI_FORMAT_UNKNOWN,
        DXGI_FORMAT_FORCE_UINT:
            Result := 0;
        else
            Result := 0;
    end;
end;



function MakeSRGB({_In_}  format: TDXGI_FORMAT): TDXGI_FORMAT; inline;
begin
    case (format) of

        DXGI_FORMAT_R8G8B8A8_UNORM:
            Result := DXGI_FORMAT_R8G8B8A8_UNORM_SRGB;

        DXGI_FORMAT_BC1_UNORM:
            Result := DXGI_FORMAT_BC1_UNORM_SRGB;

        DXGI_FORMAT_BC2_UNORM:
            Result := DXGI_FORMAT_BC2_UNORM_SRGB;

        DXGI_FORMAT_BC3_UNORM:
            Result := DXGI_FORMAT_BC3_UNORM_SRGB;

        DXGI_FORMAT_B8G8R8A8_UNORM:
            Result := DXGI_FORMAT_B8G8R8A8_UNORM_SRGB;

        DXGI_FORMAT_B8G8R8X8_UNORM:
            Result := DXGI_FORMAT_B8G8R8X8_UNORM_SRGB;

        DXGI_FORMAT_BC7_UNORM:
            Result := DXGI_FORMAT_BC7_UNORM_SRGB;

        else
            Result := format;
    end;
end;



function MakeLinear({_In_}  format: TDXGI_FORMAT): TDXGI_FORMAT; inline;
begin
    case (format) of
        DXGI_FORMAT_R8G8B8A8_UNORM_SRGB:
            Result := DXGI_FORMAT_R8G8B8A8_UNORM;

        DXGI_FORMAT_BC1_UNORM_SRGB:
            Result := DXGI_FORMAT_BC1_UNORM;

        DXGI_FORMAT_BC2_UNORM_SRGB:
            Result := DXGI_FORMAT_BC2_UNORM;

        DXGI_FORMAT_BC3_UNORM_SRGB:
            Result := DXGI_FORMAT_BC3_UNORM;

        DXGI_FORMAT_B8G8R8A8_UNORM_SRGB:
            Result := DXGI_FORMAT_B8G8R8A8_UNORM;

        DXGI_FORMAT_B8G8R8X8_UNORM_SRGB:
            Result := DXGI_FORMAT_B8G8R8X8_UNORM;

        DXGI_FORMAT_BC7_UNORM_SRGB:
            Result := DXGI_FORMAT_BC7_UNORM;

        else
            Result := format;
    end;
end;



function IsCompressed({_In_}  fmt: TDXGI_FORMAT): boolean; inline;
begin
    case (fmt) of
        DXGI_FORMAT_BC1_TYPELESS,
        DXGI_FORMAT_BC1_UNORM,
        DXGI_FORMAT_BC1_UNORM_SRGB,
        DXGI_FORMAT_BC2_TYPELESS,
        DXGI_FORMAT_BC2_UNORM,
        DXGI_FORMAT_BC2_UNORM_SRGB,
        DXGI_FORMAT_BC3_TYPELESS,
        DXGI_FORMAT_BC3_UNORM,
        DXGI_FORMAT_BC3_UNORM_SRGB,
        DXGI_FORMAT_BC4_TYPELESS,
        DXGI_FORMAT_BC4_UNORM,
        DXGI_FORMAT_BC4_SNORM,
        DXGI_FORMAT_BC5_TYPELESS,
        DXGI_FORMAT_BC5_UNORM,
        DXGI_FORMAT_BC5_SNORM,
        DXGI_FORMAT_BC6H_TYPELESS,
        DXGI_FORMAT_BC6H_UF16,
        DXGI_FORMAT_BC6H_SF16,
        DXGI_FORMAT_BC7_TYPELESS,
        DXGI_FORMAT_BC7_UNORM,
        DXGI_FORMAT_BC7_UNORM_SRGB:
            Result := True;
        else
            Result := False;
    end;
end;



function EnsureNotTypeless(fmt: TDXGI_FORMAT): TDXGI_FORMAT; inline;
begin
    // Assumes UNORM or FLOAT; doesn't use UINT or SINT
    case (fmt) of
        DXGI_FORMAT_R32G32B32A32_TYPELESS: Result := DXGI_FORMAT_R32G32B32A32_FLOAT;
        DXGI_FORMAT_R32G32B32_TYPELESS: Result := DXGI_FORMAT_R32G32B32_FLOAT;
        DXGI_FORMAT_R16G16B16A16_TYPELESS: Result := DXGI_FORMAT_R16G16B16A16_UNORM;
        DXGI_FORMAT_R32G32_TYPELESS: Result := DXGI_FORMAT_R32G32_FLOAT;
        DXGI_FORMAT_R10G10B10A2_TYPELESS: Result := DXGI_FORMAT_R10G10B10A2_UNORM;
        DXGI_FORMAT_R8G8B8A8_TYPELESS: Result := DXGI_FORMAT_R8G8B8A8_UNORM;
        DXGI_FORMAT_R16G16_TYPELESS: Result := DXGI_FORMAT_R16G16_UNORM;
        DXGI_FORMAT_R32_TYPELESS: Result := DXGI_FORMAT_R32_FLOAT;
        DXGI_FORMAT_R8G8_TYPELESS: Result := DXGI_FORMAT_R8G8_UNORM;
        DXGI_FORMAT_R16_TYPELESS: Result := DXGI_FORMAT_R16_UNORM;
        DXGI_FORMAT_R8_TYPELESS: Result := DXGI_FORMAT_R8_UNORM;
        DXGI_FORMAT_BC1_TYPELESS: Result := DXGI_FORMAT_BC1_UNORM;
        DXGI_FORMAT_BC2_TYPELESS: Result := DXGI_FORMAT_BC2_UNORM;
        DXGI_FORMAT_BC3_TYPELESS: Result := DXGI_FORMAT_BC3_UNORM;
        DXGI_FORMAT_BC4_TYPELESS: Result := DXGI_FORMAT_BC4_UNORM;
        DXGI_FORMAT_BC5_TYPELESS: Result := DXGI_FORMAT_BC5_UNORM;
        DXGI_FORMAT_B8G8R8A8_TYPELESS: Result := DXGI_FORMAT_B8G8R8A8_UNORM;
        DXGI_FORMAT_B8G8R8X8_TYPELESS: Result := DXGI_FORMAT_B8G8R8X8_UNORM;
        DXGI_FORMAT_BC7_TYPELESS: Result := DXGI_FORMAT_BC7_UNORM;
        else
            Result := fmt;
    end;
end;



function LoadTextureDataFromMemory(ddsData: Puint8; ddsDataSize: size_t; out header: TDDS_HEADER; out bitData: Puint8; out bitSize: size_t): HRESULT;
var
    dwMagicNumber: uint32;
    hdr: PDDS_HEADER;
    bDXT10Header: boolean;
    offset: size_t;
begin
    bitSize := 0;

    if (ddsDataSize > UINT32_MAX) then
    begin
        Result := E_FAIL;
        Exit;
    end;

    if (ddsDataSize < DDS_MIN_HEADER_SIZE) then
    begin
        Result := E_FAIL;
        Exit;
    end;

    // DDS files always start with the same magic number ("DDS ")
    dwMagicNumber := uint32(ddsData^);
    if (dwMagicNumber <> DDS_MAGIC) then
    begin
        Result := E_FAIL;
        Exit;
    end;

    hdr := PDDS_HEADER(ddsData + sizeof(uint32));

    // Verify header to validate DDS file
    if (hdr^.size <> sizeof(TDDS_HEADER)) or (hdr^.ddspf.size <> sizeof(TDDS_PIXELFORMAT)) then
    begin
        Result := E_FAIL;
        Exit;
    end;

    // Check for DX10 extension
    bDXT10Header := False;
    if (((hdr^.ddspf.flags and DDS_FOURCC) = DDS_FOURCC) and (((Ord('D') or (Ord('X') shl 8) or (Ord('1') shl 16) or (Ord('0') shl 24))) = hdr^.ddspf.fourCC)) then
    begin
        // Must be long enough for both headers and magic value
        if (ddsDataSize < DDS_DX10_HEADER_SIZE) then
        begin
            Result := E_FAIL;
            Exit;
        end;

        bDXT10Header := True;
    end;

    // setup the pointers in the process request
    header := hdr^;
    offset := DDS_MIN_HEADER_SIZE;
    if bDXT10Header then
        offset := offset + sizeof(TDDS_HEADER_DXT10);
    bitData := ddsData + offset;
    bitSize := ddsDataSize - offset;

    Result := S_OK;
end;



function LoadTextureDataFromFile(fileName: pwidechar; ddsData: TCStdUniquePtrArray_UINT8; out header: PDDS_HEADER; out bitData: PUINT8; out bitSize: size_t): HRESULT;
var
    hFile: TScopedHandle;
    fileInfo: TFILE_STANDARD_INFO;
    bDXT10Header: boolean;
    bytesRead: DWORD;
    dwMagicNumber: uint32;
    hdr: PDDS_HEADER;
    offset: size_t;
begin
    bitSize := 0;

    // open the file
    hFile := safe_handle(CreateFile2(fileName, GENERIC_READ, FILE_SHARE_READ, OPEN_EXISTING, nil));
    if (hFile = 0) then
    begin
        Result := HRESULT_FROM_WIN32(GetLastError());
        Exit;
    end;

    // Get the file size

    if (not GetFileInformationByHandleEx(hFile.get(), FileStandardInfo, @fileInfo, sizeof(fileInfo))) then
    begin
        Result := HRESULT_FROM_WIN32(GetLastError());
        Exit;
    end;

    // File is too big for 32-bit allocation, so reject read
    if (fileInfo.EndOfFile.HighPart > 0) then
    begin
        Result := E_FAIL;
        Exit;
    end;

    // Need at least enough data to fill the header and magic number to be a valid DDS
    if (fileInfo.EndOfFile.LowPart < DDS_MIN_HEADER_SIZE) then
    begin
        Result := E_FAIL;
        Exit;
    end;

    // create enough space for the file data
    ddsData.reset(fileInfo.EndOfFile.LowPart);
    if (ddsData.get() = nil) then
    begin
        Result := E_OUTOFMEMORY;
        Exit;
    end;

    // read the data in
    bytesRead := 0;
    if (not ReadFile(hFile.get(), ddsData.get(), fileInfo.EndOfFile.LowPart, @bytesRead, nil)) then
    begin
        ddsData.reset(0);
        Result := HRESULT_FROM_WIN32(GetLastError());
        Exit;

    end;

    if (bytesRead < fileInfo.EndOfFile.LowPart) then
    begin
        ddsData.reset(0);
        Result := E_FAIL;
        Exit;
    end;

    // DDS files always start with the same magic number ("DDS ")
    dwMagicNumber := uint32(ddsData.get());
    if (dwMagicNumber <> DDS_MAGIC) then
    begin
        ddsData.reset();
        Result := E_FAIL;
        Exit;
    end;

    hdr := PDDS_HEADER(ddsData.get() + sizeof(uint32));

    // Verify header to validate DDS file
    if ((hdr^.size <> sizeof(TDDS_HEADER)) or (hdr^.ddspf.size <> sizeof(TDDS_PIXELFORMAT))) then
    begin
        ddsData.reset();
        Result := E_FAIL;
        Exit;
    end;

    // Check for DX10 extension
    bDXT10Header := False;
    if (((hdr^.ddspf.flags and DDS_FOURCC) = DDS_FOURCC) and ((Ord('D') or (Ord('X') shl 8) or (Ord('1') shl 16) or (Ord('0') shl 24)) = hdr^.ddspf.fourCC)) then
    begin
        // Must be long enough for both headers and magic value
        if (fileInfo.EndOfFile.LowPart < DDS_DX10_HEADER_SIZE) then
        begin
            ddsData.reset();
            Result := E_FAIL;
            Exit;
        end;

        bDXT10Header := True;
    end;

    // setup the pointers in the process request
    header := hdr;
    offset := DDS_MIN_HEADER_SIZE;
    if bDXT10Header then
        offset := offset + sizeof(TDDS_HEADER_DXT10);
    bitData := ddsData.get() + offset;
    bitSize := fileInfo.EndOfFile.LowPart - offset;

    Result := S_OK;
end;

//--------------------------------------------------------------------------------------
// Get surface information for a particular format
//--------------------------------------------------------------------------------------
function GetSurfaceInfo(Width: size_t; Height: size_t; fmt: TDXGI_FORMAT; outNumBytes: Psize_t; outRowBytes: Psize_t; outNumRows: Psize_t): HRESULT;
var
    numBytes: uint64 = 0;
    rowBytes: uint64 = 0;
    numRows: uint64 = 0;

    bc: boolean = False;
    IsPacked: boolean = False;
    planar: boolean = False;
    bpe: size_t = 0;
    numBlocksWide: uint64;
    numBlocksHigh: uint64;
    bpp: size_t;
begin

    case (fmt) of

        DXGI_FORMAT_UNKNOWN:
        begin
            Result := E_INVALIDARG;
            Exit;
        end;

        DXGI_FORMAT_BC1_TYPELESS,
        DXGI_FORMAT_BC1_UNORM,
        DXGI_FORMAT_BC1_UNORM_SRGB,
        DXGI_FORMAT_BC4_TYPELESS,
        DXGI_FORMAT_BC4_UNORM,
        DXGI_FORMAT_BC4_SNORM:
        begin
            bc := True;
            bpe := 8;
        end;

        DXGI_FORMAT_BC2_TYPELESS,
        DXGI_FORMAT_BC2_UNORM,
        DXGI_FORMAT_BC2_UNORM_SRGB,
        DXGI_FORMAT_BC3_TYPELESS,
        DXGI_FORMAT_BC3_UNORM,
        DXGI_FORMAT_BC3_UNORM_SRGB,
        DXGI_FORMAT_BC5_TYPELESS,
        DXGI_FORMAT_BC5_UNORM,
        DXGI_FORMAT_BC5_SNORM,
        DXGI_FORMAT_BC6H_TYPELESS,
        DXGI_FORMAT_BC6H_UF16,
        DXGI_FORMAT_BC6H_SF16,
        DXGI_FORMAT_BC7_TYPELESS,
        DXGI_FORMAT_BC7_UNORM,
        DXGI_FORMAT_BC7_UNORM_SRGB:
        begin
            bc := True;
            bpe := 16;
        end;

        DXGI_FORMAT_R8G8_B8G8_UNORM,
        DXGI_FORMAT_G8R8_G8B8_UNORM,
        DXGI_FORMAT_YUY2:
        begin
            Ispacked := True;
            bpe := 4;
        end;

        DXGI_FORMAT_Y210,
        DXGI_FORMAT_Y216:
        begin
            Ispacked := True;
            bpe := 8;
        end;

        DXGI_FORMAT_NV12,
        DXGI_FORMAT_420_OPAQUE:
        begin
            if ((Height mod 2) <> 0) then
            begin
                // Requires a height alignment of 2.
                Result := E_INVALIDARG;
                Exit;
            end;
            planar := True;
            bpe := 2;
        end;


        DXGI_FORMAT_P208:
        begin
            planar := True;
            bpe := 2;
        end;

        DXGI_FORMAT_P010,
        DXGI_FORMAT_P016:
        begin
            if ((Height mod 2) <> 0) then
            begin
                // Requires a height alignment of 2.
                Result := E_INVALIDARG;
                Exit;
            end;
            planar := True;
            bpe := 4;
        end;

        {$IFDEF XBOX}

             DXGI_FORMAT_D16_UNORM_S8_UINT:
             DXGI_FORMAT_R16_UNORM_X8_TYPELESS:
             DXGI_FORMAT_X16_TYPELESS_G8_UINT:
begin
                planar := true;
                bpe := 4;
                end;

        {$ENDIF}
    end;

    if (bc) then
    begin
        numBlocksWide := 0;
        if (Width > 0) then
        begin
            numBlocksWide := max(1, (uint64(Width) + 3) div 4);
        end;
        numBlocksHigh := 0;
        if (Height > 0) then
        begin
            numBlocksHigh := max(1, (uint64(Height) + 3) div 4);
        end;
        rowBytes := numBlocksWide * bpe;
        numRows := numBlocksHigh;
        numBytes := rowBytes * numBlocksHigh;
    end
    else if (Ispacked) then
    begin
        rowBytes := ((uint64(Width) + 1) shr 1) * bpe;
        numRows := uint64(Height);
        numBytes := rowBytes * Height;
    end
    else if (fmt = DXGI_FORMAT_NV11) then
    begin
        rowBytes := ((uint64(Width) + 3) shr 2) * 4;
        numRows := uint64(Height) * 2; // Direct3D makes this simplifying assumption, although it is larger than the 4:1:1 data
        numBytes := rowBytes * numRows;
    end
    else if (planar) then
    begin
        rowBytes := ((uint64(Width) + 1) shr 1) * bpe;
        numBytes := (rowBytes * uint64(Height)) + ((rowBytes * uint64(Height) + 1) shr 1);
        numRows := Height + ((uint64(Height) + 1) shr 1);
    end
    else
    begin
        bpp := BitsPerPixel(fmt);
        if (bpp = 0) then
        begin
            Result := E_INVALIDARG;
            Exit;
        end;

        rowBytes := (uint64(Width) * bpp + 7) div 8; // round up to nearest byte
        numRows := uint64(Height);
        numBytes := rowBytes * Height;
    end;

    {$IFNDEF CPUX64}
    assert(sizeof(size_t) = 4, 'Not a 32-bit platform!');
    if (numBytes > UINT32_MAX) or (rowBytes > UINT32_MAX) or (numRows > UINT32_MAX) then
    begin
        Result := HRESULT_FROM_WIN32(ERROR_ARITHMETIC_OVERFLOW);
        Exit;
    end;
    {$ELSE}
            assert(sizeof(size_t) = 8, 'Not a 64-bit platform!');
    {$ENDIF}

    if (outNumBytes <> nil) then
    begin
        outNumBytes^ := size_t(numBytes);
    end;
    if (outRowBytes <> nil) then
    begin
        outRowBytes^ := size_t(rowBytes);
    end;
    if (outNumRows <> nil) then
    begin
        outNumRows^ := size_t(numRows);
    end;

    Result := S_OK;
end;



function GetDXGIFormat(ddpf: TDDS_PIXELFORMAT): TDXGI_FORMAT;



    function ISBITMASK(r, g, b, a: uint32): boolean; inline;
    begin
        Result := (ddpf.RBitMask = r) and (ddpf.GBitMask = g) and (ddpf.BBitMask = b) and (ddpf.ABitMask = a);
    end;

begin
    if ((ddpf.flags and DDS_RGB) = DDS_RGB) then
    begin
        // Note that sRGB formats are written using the "DX10" extended header

        case (ddpf.RGBBitCount) of

            32:
            begin
                if (ISBITMASK($000000ff, $0000ff00, $00ff0000, $ff000000)) then
                begin
                    Result := DXGI_FORMAT_R8G8B8A8_UNORM;
                    Exit;
                end;

                if (ISBITMASK($00ff0000, $0000ff00, $000000ff, $ff000000)) then
                begin
                    Result := DXGI_FORMAT_B8G8R8A8_UNORM;
                    Exit;
                end;

                if (ISBITMASK($00ff0000, $0000ff00, $000000ff, 0)) then
                begin
                    Result := DXGI_FORMAT_B8G8R8X8_UNORM;
                    Exit;
                end;

                // No DXGI format maps to ISBITMASK($000000ff,$0000ff00,$00ff0000,0) aka D3DFMT_X8B8G8R8

                // Note that many common DDS reader/writers (including D3DX) swap the
                // the RED/BLUE masks for 10:10:10:2 formats. We assume
                // below that the 'backwards' header mask is being used since it is most
                // likely written by D3DX. The more robust solution is to use the 'DX10'
                // header extension and specify the DXGI_FORMAT_R10G10B10A2_UNORM format directly

                // For 'correct' writers, this should be $000003ff,$000ffc00,$3ff00000 for RGB data
                if (ISBITMASK($3ff00000, $000ffc00, $000003ff, $c0000000)) then
                begin
                    Result := DXGI_FORMAT_R10G10B10A2_UNORM;
                    Exit;
                end;

                // No DXGI format maps to ISBITMASK($000003ff,$000ffc00,$3ff00000,$c0000000) aka D3DFMT_A2R10G10B10

                if (ISBITMASK($0000ffff, $ffff0000, 0, 0)) then
                begin
                    Result := DXGI_FORMAT_R16G16_UNORM;
                    Exit;
                end;

                if (ISBITMASK($ffffffff, 0, 0, 0)) then
                begin
                    // Only 32-bit color channel format in D3D9 was R32F
                    Result := DXGI_FORMAT_R32_FLOAT; // D3DX writes this out as a FourCC of 114
                    Exit;
                end;
            end;

            24:
            begin
                // No 24bpp DXGI formats aka D3DFMT_R8G8B8
            end;

            16:
            begin
                if (ISBITMASK($7c00, $03e0, $001f, $8000)) then
                begin
                    Result := DXGI_FORMAT_B5G5R5A1_UNORM;
                    Exit;
                end;
                if (ISBITMASK($f800, $07e0, $001f, 0)) then
                begin
                    Result := DXGI_FORMAT_B5G6R5_UNORM;
                    Exit;
                end;

                // No DXGI format maps to ISBITMASK($7c00,$03e0,$001f,0) aka D3DFMT_X1R5G5B5

                if (ISBITMASK($0f00, $00f0, $000f, $f000)) then
                begin
                    Result := DXGI_FORMAT_B4G4R4A4_UNORM;
                    Exit;
                end;

                // NVTT versions 1.x wrote this as RGB instead of LUMINANCE
                if (ISBITMASK($00ff, 0, 0, $ff00)) then
                begin
                    Result := DXGI_FORMAT_R8G8_UNORM;
                    Exit;
                end;
                if (ISBITMASK($ffff, 0, 0, 0)) then
                begin
                    Result := DXGI_FORMAT_R16_UNORM;
                    Exit;
                end;

                // No DXGI format maps to ISBITMASK($0f00,$00f0,$000f,0) aka D3DFMT_X4R4G4B4

                // No 3:3:2:8 or paletted DXGI formats aka D3DFMT_A8R3G3B2, D3DFMT_A8P8, etc.
            end;

            8:
            begin
                // NVTT versions 1.x wrote this as RGB instead of LUMINANCE
                if (ISBITMASK($ff, 0, 0, 0)) then
                begin
                    Result := DXGI_FORMAT_R8_UNORM;
                    Exit;
                end;

                // No 3:3:2 or paletted DXGI formats aka D3DFMT_R3G3B2, D3DFMT_P8
            end;

            else
            begin
                Result := DXGI_FORMAT_UNKNOWN;
                Exit;
            end;
        end;
    end
    else if ((ddpf.flags and DDS_LUMINANCE) = DDS_LUMINANCE) then
    begin
        case (ddpf.RGBBitCount) of

            16:
            begin
                if (ISBITMASK($ffff, 0, 0, 0)) then
                begin
                    Result := DXGI_FORMAT_R16_UNORM; // D3DX10/11 writes this out as DX10 extension
                    Exit;
                end;
                if (ISBITMASK($00ff, 0, 0, $ff00)) then
                begin
                    Result := DXGI_FORMAT_R8G8_UNORM; // D3DX10/11 writes this out as DX10 extension
                    Exit;
                end;
            end;

            8:
            begin
                if (ISBITMASK($ff, 0, 0, 0)) then
                begin
                    Result := DXGI_FORMAT_R8_UNORM; // D3DX10/11 writes this out as DX10 extension
                    Exit;
                end;

                // No DXGI format maps to ISBITMASK($0f,0,0,$f0) aka D3DFMT_A4L4

                if (ISBITMASK($00ff, 0, 0, $ff00)) then
                begin
                    Result := DXGI_FORMAT_R8G8_UNORM; // Some DDS writers assume the bitcount should be 8 instead of 16
                    Exit;
                end;
            end;

            else
            begin
                Result := DXGI_FORMAT_UNKNOWN;
                Exit;
            end;
        end;
    end
    else if ((ddpf.flags and DDS_ALPHA) = DDS_ALPHA) then
    begin
        if (8 = ddpf.RGBBitCount) then
        begin
            Result := DXGI_FORMAT_A8_UNORM;
            Exit;
        end;
    end
    else if ((ddpf.flags and DDS_BUMPDUDV) = DDS_BUMPDUDV) then
    begin
        case (ddpf.RGBBitCount) of

            32:
            begin
                if (ISBITMASK($000000ff, $0000ff00, $00ff0000, $ff000000)) then
                begin
                    Result := DXGI_FORMAT_R8G8B8A8_SNORM; // D3DX10/11 writes this out as DX10 extension
                    Exit;
                end;
                if (ISBITMASK($0000ffff, $ffff0000, 0, 0)) then
                begin
                    Result := DXGI_FORMAT_R16G16_SNORM; // D3DX10/11 writes this out as DX10 extension
                    Exit;
                end;

                // No DXGI format maps to ISBITMASK($3ff00000, $000ffc00, $000003ff, $c0000000) aka D3DFMT_A2W10V10U10
            end;

            16:
            begin
                if (ISBITMASK($00ff, $ff00, 0, 0)) then
                begin
                    Result := DXGI_FORMAT_R8G8_SNORM; // D3DX10/11 writes this out as DX10 extension
                    Exit;
                end;
            end;

            else
            begin
                Result := DXGI_FORMAT_UNKNOWN;
                Exit;
            end;
        end;

        // No DXGI format maps to DDPF_BUMPLUMINANCE aka D3DFMT_L6V5U5, D3DFMT_X8L8V8U8
    end
    else if ((ddpf.flags and DDS_FOURCC) = DDS_FOURCC) then
    begin
        if (MAKEFOURCC('D', 'X', 'T', '1') = ddpf.fourCC) then
        begin
            Result := DXGI_FORMAT_BC1_UNORM;
            Exit;
        end;
        if (MAKEFOURCC('D', 'X', 'T', '3') = ddpf.fourCC) then
        begin
            Result := DXGI_FORMAT_BC2_UNORM;
            Exit;
        end;
        if (MAKEFOURCC('D', 'X', 'T', '5') = ddpf.fourCC) then
        begin
            Result := DXGI_FORMAT_BC3_UNORM;
            Exit;
        end;

        // While pre-multiplied alpha isn't directly supported by the DXGI formats,
        // they are basically the same as these BC formats so they can be mapped
        if (MAKEFOURCC('D', 'X', 'T', '2') = ddpf.fourCC) then
        begin
            Result := DXGI_FORMAT_BC2_UNORM;
            Exit;
        end;
        if (MAKEFOURCC('D', 'X', 'T', '4') = ddpf.fourCC) then
        begin
            Result := DXGI_FORMAT_BC3_UNORM;
            Exit;
        end;

        if (MAKEFOURCC('A', 'T', 'I', '1') = ddpf.fourCC) then
        begin
            Result := DXGI_FORMAT_BC4_UNORM;
            Exit;
        end;
        if (MAKEFOURCC('B', 'C', '4', 'U') = ddpf.fourCC) then
        begin
            Result := DXGI_FORMAT_BC4_UNORM;
            Exit;
        end;
        if (MAKEFOURCC('B', 'C', '4', 'S') = ddpf.fourCC) then
        begin
            Result := DXGI_FORMAT_BC4_SNORM;
            Exit;
        end;

        if (MAKEFOURCC('A', 'T', 'I', '2') = ddpf.fourCC) then
        begin
            Result := DXGI_FORMAT_BC5_UNORM;
            Exit;
        end;
        if (MAKEFOURCC('B', 'C', '5', 'U') = ddpf.fourCC) then
        begin
            Result := DXGI_FORMAT_BC5_UNORM;
            Exit;
        end;
        if (MAKEFOURCC('B', 'C', '5', 'S') = ddpf.fourCC) then
        begin
            Result := DXGI_FORMAT_BC5_SNORM;
            Exit;
        end;

        // BC6H and BC7 are written using the "DX10" extended header

        if (MAKEFOURCC('R', 'G', 'B', 'G') = ddpf.fourCC) then
        begin
            Result := DXGI_FORMAT_R8G8_B8G8_UNORM;
            Exit;
        end;
        if (MAKEFOURCC('G', 'R', 'G', 'B') = ddpf.fourCC) then
        begin
            Result := DXGI_FORMAT_G8R8_G8B8_UNORM;
            Exit;
        end;

        if (MAKEFOURCC('Y', 'U', 'Y', '2') = ddpf.fourCC) then
        begin
            Result := DXGI_FORMAT_YUY2;
            Exit;
        end;

        // Check for D3DFORMAT enums being set here
        case (ddpf.fourCC) of

            36: begin// D3DFMT_A16B16G16R16
                Result := DXGI_FORMAT_R16G16B16A16_UNORM;
                Exit;
            end;

            110: begin// D3DFMT_Q16W16V16U16
                Result := DXGI_FORMAT_R16G16B16A16_SNORM;
                Exit;
            end;

            111: begin // D3DFMT_R16F
                Result := DXGI_FORMAT_R16_FLOAT;
                Exit;
            end;

            112: begin // D3DFMT_G16R16F
                Result := DXGI_FORMAT_R16G16_FLOAT;
                Exit;
            end;

            113: begin// D3DFMT_A16B16G16R16F
                Result := DXGI_FORMAT_R16G16B16A16_FLOAT;
                Exit;
            end;

            114: begin// D3DFMT_R32F
                Result := DXGI_FORMAT_R32_FLOAT;
                Exit;
            end;

            115: begin // D3DFMT_G32R32F
                Result := DXGI_FORMAT_R32G32_FLOAT;
                Exit;
            end;

            116: begin// D3DFMT_A32B32G32R32F
                Result := DXGI_FORMAT_R32G32B32A32_FLOAT;
                Exit;
            end;

                // No DXGI format maps to D3DFMT_CxV8U8

            else
            begin
                Result := DXGI_FORMAT_UNKNOWN;
                Exit;
            end;
        end;
    end;
    Result := DXGI_FORMAT_UNKNOWN;
end;



function GetAlphaMode(header: PDDS_HEADER): TDDS_ALPHA_MODE;
var
    mode: TDDS_ALPHA_MODE;
    d3d10ext: PDDS_HEADER_DXT10;
begin
    if ((header^.ddspf.flags and DDS_FOURCC) = DDS_FOURCC) then
    begin
        if (MAKEFOURCC('D', 'X', '1', '0') = header^.ddspf.fourCC) then
        begin
            d3d10ext := PDDS_HEADER_DXT10(Puint8(header) + sizeof(TDDS_HEADER));
            mode := TDDS_ALPHA_MODE(d3d10ext^.miscFlags2 and Ord(DDS_MISC_FLAGS2_ALPHA_MODE_MASK));
            case (mode) of

                DDS_ALPHA_MODE_STRAIGHT,
                DDS_ALPHA_MODE_PREMULTIPLIED,
                DDS_ALPHA_MODE_OPAQUE,
                DDS_ALPHA_MODE_CUSTOM:
                begin
                    Result := mode;
                    Exit;
                end;
            end;
        end
        else if ((MAKEFOURCC('D', 'X', 'T', '2') = header^.ddspf.fourCC) or (MAKEFOURCC('D', 'X', 'T', '4') = header^.ddspf.fourCC)) then
        begin
            Result := DDS_ALPHA_MODE_PREMULTIPLIED;
            Exit;
        end;
    end;

    Result := DDS_ALPHA_MODE_UNKNOWN;
end;



function CountMips(Width, Height: uint32): uint32; inline;
var
    Count: uint32 = 1;
begin
    if (Width = 0) or (Height = 0) then
    begin
        Result := 0;
        Exit;
    end;


    while ((Width > 1) or (Height > 1)) do
    begin
        Width := Width shr 1;
        Height := Height shr 1;
        Inc(Count);
    end;

    Result := Count;

end;



procedure FitPowerOf2(origx: UINT; origy: UINT; {_Inout_} var targetx: UINT; {_Inout_} var targety: UINT; maxsize: size_t); inline;
var
    origAR: single;
    bestScore: single;
    score: single;
    x, y: size_t;
begin
    origAR := origx / origy;

    if (origx > origy) then
    begin
        x := maxsize;
        while x > 1 do
        begin
            if (x <= targetx) then
                break;
            x := x shr 1;
        end;
        targetx := UINT(x);

        bestScore := MaxFloat;
        y := maxsize;
        while y > 0 do
        begin
            score := abs((x / y) - origAR);
            if (score < bestScore) then
            begin
                bestScore := score;
                targety := UINT(y);
            end;
            y := y shr 1;
        end;
    end
    else
    begin
        y := maxsize;
        while (y > 1) do
        begin
            if (y <= targety) then
                break;
            y := y shr 1;
        end;
        targety := UINT(y);

        bestScore := MaxFloat;
        x := maxsize;
        while (x > 0) do
        begin
            score := abs((x / y) - origAR);
            if (score < bestScore) then
            begin
                bestScore := score;
                targetx := UINT(x);
            end;
            x := x shr 1;
        end;
    end;
end;

{ TAutoDeleteFile }

procedure TAutoDeleteFile.Clear();
begin
    self.m_handle := 0;
end;



class operator TAutoDeleteFile.Finalize(var aRec: TAutoDeleteFile);
var
    info: TFILE_DISPOSITION_INFO;
begin
    if (aRec.m_handle <> 0) then
    begin
        info.DeleteFile := True;
        SetFileInformationByHandle(aRec.m_handle, FileDispositionInfo, @info, sizeof(info));
    end;
end;



constructor TAutoDeleteFile.Create(hFile: HANDLE);
begin
    self.m_handle := hFile;
end;

{ TAutoDeleteFileWIC }

procedure TAutoDeleteFileWIC.Clear();
begin
    m_filename := '';
end;



class operator TAutoDeleteFileWIC.Finalize(var aRec: TAutoDeleteFileWIC);
begin
    if (aRec.m_filename <> '') then
    begin
        aRec.m_handle := nil;
        DeleteFileW(pWideChar(aRec.m_filename));
    end;
end;



constructor TAutoDeleteFileWIC.Create(hFile: IWICStream; szFile: widestring);
begin
    m_filename := szFile;
    m_handle := hFile;
end;


end.
