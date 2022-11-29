unit DirectXTK11.LoadHelpers;

(* Helper functions for texture loaders and screen grabber *)

{$IFDEF FPC}
{$mode DelphiUnicode}{$H+}
{$ENDIF}

{$POINTERMATH ON}

interface

uses
    Classes, SysUtils, Windows,
    DirectXTK11.DDS,
    DX12.DXGI;

const
    UINT32_MAX = $ffffffff;
    FLT_MAX = 3.402823466e+38;


type

    TFILE_INFO_BY_HANDLE_CLASS = (
        FileBasicInfo,
        FileStandardInfo,
        FileNameInfo,
        FileRenameInfo,
        FileDispositionInfo,
        FileAllocationInfo,
        FileEndOfFileInfo,
        FileStreamInfo,
        FileCompressionInfo,
        FileAttributeTagInfo,
        FileIdBothDirectoryInfo,
        FileIdBothDirectoryRestartInfo,
        FileIoPriorityHintInfo,
        FileRemoteProtocolInfo,
        FileFullDirectoryInfo,
        FileFullDirectoryRestartInfo,
        // (NTDDI_VERSION >= NTDDI_WIN8)
        FileStorageInfo,
        FileAlignmentInfo,
        FileIdInfo,
        FileIdExtdDirectoryInfo,
        FileIdExtdDirectoryRestartInfo,

        // (NTDDI_VERSION >= NTDDI_WIN10_RS1)
        FileDispositionInfoEx,
        FileRenameInfoEx,

        // (NTDDI_VERSION >= NTDDI_WIN10_19H1)
        FileCaseSensitiveInfo,
        FileNormalizedNameInfo,
        MaximumFileInfoByHandleClass);
    PFILE_INFO_BY_HANDLE_CLASS = ^TFILE_INFO_BY_HANDLE_CLASS;

function IsCompressed(fmt: TDXGI_FORMAT): boolean;
function EnsureNotTypeless(fmt: TDXGI_FORMAT): TDXGI_FORMAT;
function BitsPerPixel(fmt: TDXGI_FORMAT): size_t;
function GetDXGIFormat(const ddpf: TDDS_PIXELFORMAT): TDXGI_FORMAT;
function MakeSRGB(format: TDXGI_FORMAT): TDXGI_FORMAT;
function CountMips(Width, Height: uint32): uint32;
function LoadTextureDataFromFile(fileName: WideString; out ddsData: pbyte; out header: TDDS_HEADER; out bitData: pbyte; out bitSize: size_t): HRESULT;
function LoadTextureDataFromMemory(const DDSData{ddsDataSize}: pbyte; ddsDataSize: size_t; out header: TDDS_HEADER; out bitData: pbyte; out bitSize: size_t): HRESULT;
function GetAlphaMode(const header: PDDS_HEADER): TDDS_ALPHA_MODE;
function GetSurfaceInfo(Width: size_t; Height: size_t; fmt: TDXGI_FORMAT; out outNumBytes: size_t; out outRowBytes: size_t; out outNumRows: size_t): HRESULT;

function HRESULT_FROM_WIN32(x: uint32): HResult;

function GetFileInformationByHandleEx(hFile: THANDLE; FileInformationClass: TFILE_INFO_BY_HANDLE_CLASS; out {dwBufferSize}  lpFileInformation; dwBufferSize: DWORD): boolean; stdcall; external 'Kernel32.dll';

implementation

uses
    Math;

type
    // This is from WinBase.h

    TFILE_STANDARD_INFO = record
        AllocationSize: LARGE_INTEGER;
        EndOfFile: LARGE_INTEGER;
        NumberOfLinks: DWORD;
        DeletePending: boolean;
        Directory: boolean;
    end;
    PFILE_STANDARD_INFO = ^TFILE_STANDARD_INFO;



function HRESULT_FROM_WIN32(x: uint32): HResult;
begin
    if x <= 0 then
        Result := x
    else
        Result := (x and $0000FFFF) or (FACILITY_WIN32 shl 16) or $80000000;
end;



function IsCompressed(fmt: TDXGI_FORMAT): boolean; inline;
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


//--------------------------------------------------------------------------------------
// Return the BPP for a particular format
//--------------------------------------------------------------------------------------
function BitsPerPixel(fmt: TDXGI_FORMAT): size_t; inline;
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
        DXGI_FORMAT_YUY2,
        //        DXGI_FORMAT_R10G10B10_SNORM_A2_UNORM,
        DXGI_FORMAT_R10G10B10_7E3_A2_FLOAT,
        DXGI_FORMAT_R10G10B10_6E4_A2_FLOAT:
            Result := 32;

        DXGI_FORMAT_P010,
        DXGI_FORMAT_P016,
        //        DXGI_FORMAT_D16_UNORM_S8_UINT,
        //        DXGI_FORMAT_R16_UNORM_X8_TYPELESS,
        //        DXGI_FORMAT_X16_TYPELESS_G8_UINT,
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
        //        DXGI_FORMAT_R4G4_UNORM,
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
        else
            Result := 0;
    end;
end;



function GetDXGIFormat(const ddpf: TDDS_PIXELFORMAT): TDXGI_FORMAT;
{$IFDEF FPC}
 inline;{$ENDIF}



    function ISBITMASK(r, g, b, a: uint32): boolean;
    begin
        Result := (ddpf.RBitMask = r) and (ddpf.GBitMask = g) and (ddpf.BBitMask = b) and (ddpf.ABitMask = a);
    end;

begin
    if (ddpf.flags and DDS_RGB) = DDS_RGB then
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
        end;
    end
    else if (ddpf.flags and DDS_LUMINANCE) = DDS_LUMINANCE then
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
        end;
    end
    else if (ddpf.flags and DDS_ALPHA) = DDS_ALPHA then
    begin
        if (8 = ddpf.RGBBitCount) then
        begin
            Result := DXGI_FORMAT_A8_UNORM;
            Exit;
        end;
    end
    else if (ddpf.flags and DDS_BUMPDUDV) = DDS_BUMPDUDV then
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
        end;

        // No DXGI format maps to DDPF_BUMPLUMINANCE aka D3DFMT_L6V5U5, D3DFMT_X8L8V8U8
    end
    else if (ddpf.flags and DDS_FOURCC) = DDS_FOURCC then
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

            36: // D3DFMT_A16B16G16R16
            begin
                Result := DXGI_FORMAT_R16G16B16A16_UNORM;
                Exit;
            end;

            110: // D3DFMT_Q16W16V16U16
            begin
                Result := DXGI_FORMAT_R16G16B16A16_SNORM;
                Exit;
            end;

            111: // D3DFMT_R16F
            begin
                Result := DXGI_FORMAT_R16_FLOAT;
                Exit;
            end;

            112: // D3DFMT_G16R16F
            begin
                Result := DXGI_FORMAT_R16G16_FLOAT;
                Exit;
            end;

            113: // D3DFMT_A16B16G16R16F
            begin
                Result := DXGI_FORMAT_R16G16B16A16_FLOAT;
                Exit;
            end;

            114: // D3DFMT_R32F
            begin
                Result := DXGI_FORMAT_R32_FLOAT;
                Exit;
            end;

            115: // D3DFMT_G32R32F
            begin
                Result := DXGI_FORMAT_R32G32_FLOAT;
                Exit;
            end;

            116: // D3DFMT_A32B32G32R32F
            begin
                Result := DXGI_FORMAT_R32G32B32A32_FLOAT;
                Exit;
            end;

            // No DXGI format maps to D3DFMT_CxV8U8
        end;
    end;

    Result := DXGI_FORMAT_UNKNOWN;
end;



function MakeSRGB(format: TDXGI_FORMAT): TDXGI_FORMAT; inline;
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



function LoadTextureDataFromMemory(const DDSData{ddsDataSize}: pbyte; ddsDataSize: size_t; out header: TDDS_HEADER; out bitData: pbyte; out bitSize: size_t): HRESULT; inline;
var
    dwMagicNumber: uint32;
    hdr: PDDS_HEADER;
    bDXT10Header: boolean;
    offset: uint32;
begin
    bitSize := 0;
    Result := E_FAIL;
    if (ddsDataSize > UINT32_MAX) then
        Exit;

    if (ddsDataSize < (sizeof(uint32) + sizeof(TDDS_HEADER))) then
        Exit;

    // DDS files always start with the same magic number ("DDS ")
    dwMagicNumber := ddsData[0];
    if (dwMagicNumber <> DDS_MAGIC) then
        Exit;

    hdr := PDDS_HEADER(ddsData + sizeof(uint32));

    // Verify header to validate DDS file
    if (hdr.size <> sizeof(TDDS_HEADER)) or (hdr.ddspf.size <> sizeof(TDDS_PIXELFORMAT)) then
        Exit;

    // Check for DX10 extension

    bDXT10Header := False;
    if (((hdr.ddspf.flags and DDS_FOURCC) = DDS_FOURCC) and (MAKEFOURCC('D', 'X', '1', '0') = hdr.ddspf.fourCC)) then
    begin
        // Must be long enough for both headers and magic value
        if (ddsDataSize < (sizeof(uint32) + sizeof(TDDS_HEADER) + sizeof(TDDS_HEADER_DXT10))) then
            Exit;

        bDXT10Header := True;
    end;

    // setup the pointers in the process request
    header := hdr^;
    offset := sizeof(uint32) + sizeof(TDDS_HEADER);
    if bDXT10Header then
        offset := offset + sizeof(TDDS_HEADER_DXT10);
    bitData := ddsData + offset;
    bitSize := ddsDataSize - offset;

    Result := S_OK;
end;



function LoadTextureDataFromFile(fileName: WideString; out ddsData: pbyte; out header: TDDS_HEADER; out bitData: pbyte; out bitSize: size_t): HRESULT;  {inline}
var
    hFile: THandle;
    fileInfo: TFILE_STANDARD_INFO;
    bytesRead: DWORD;
    dwMagicNumber: puint32;
    bDXT10Header: boolean;
    hdr: TDDS_HEADER;
    offset: uint32;
    dw: dword;
    lFileMem: array of byte;
    lFileStream: TFileStream;
begin
    Result := E_POINTER;
    bytesRead := 0;
    bDXT10Header := False;
    //    if (bitData = nil) then Exit;

    bitSize := 0;

    // open the file
    lFileStream := TFileStream.Create(fileName, fmOpenRead);
    try
        // create enough space for the file data
        bitSize := lFileStream.Size;
        SetLength(lFileMem, bitSize);

        lFileStream.Read(lFileMem, bitSize);
        ddsData := @lFileMem[0];
    finally
        lFileStream.Free;
    end;

    (*

    {$ifdef WIN32_WINNT >= _WIN32_WINNT_WIN8}
    hFile := CreateFile2(fileName, GENERIC_READ, FILE_SHARE_READ,
        OPEN_EXISTING, nil);
    {$else}
    finally
    end;
    hFile := CreateFileW(pwidechar(fileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    {$endif}

    if (hFile = 0) then
    begin
        Result := HRESULT_FROM_WIN32(GetLastError());
        Exit;
    end;


    // Get the file size

    if (not GetFileInformationByHandleEx(hFile, FileStandardInfo, fileInfo, sizeof(fileInfo))) then
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
    if (fileInfo.EndOfFile.LowPart < (sizeof(uint32) + sizeof(TDDS_HEADER))) then
    begin
        Result := E_FAIL;
        Exit;
    end;

    // create enough space for the file data
    SetLength(lFileMem,fileInfo.EndOfFile.LowPart);
    ddsData:=@lFileMem[0];
//    ddsData := GetMem(fileInfo.EndOfFile.LowPart);
    if (ddsData = nil) then
    begin
        Result := E_OUTOFMEMORY;
        Exit;
    end;

    // read the data in

    if not ReadFile(hFile, lFileMem, fileInfo.EndOfFile.LowPart, bytesRead, nil) then
    begin
        Dispose(ddsData);
        dw :=GetLastError();
        Result := HRESULT_FROM_WIN32(dw);
        Exit;
    end;

    if (bytesRead < fileInfo.EndOfFile.LowPart) then
    begin
        Dispose(ddsData);
        Result := E_FAIL;
        Exit;
    end;
    *)

    // DDS files always start with the same magic number ('DDS ')

    dwMagicNumber := PUINT32(ddsData);
    if (dwMagicNumber^ <> DDS_MAGIC) then
    begin
        Dispose(ddsData);
        Result := E_FAIL;
        Exit;
    end;

    Move(lFileMem[4], hdr, SizeOf(TDDS_Header));
    header := hdr;
    //   hdr := PDDS_Header(ddsData + 4);

    // Verify header to validate DDS file
    if ((header.size <> sizeof(TDDS_HEADER)) or (header.ddspf.size <> sizeof(TDDS_PIXELFORMAT))) then
    begin
        Dispose(ddsData);
        Result := E_FAIL;
        Exit;
    end;


    // Check for DX10 extension

    if ((header.ddspf.flags and DDS_FOURCC = DDS_FOURCC) and (MAKEFOURCC('D', 'X', '1', '0') = header.ddspf.fourCC)) then
    begin
        // Must be long enough for both headers and magic value
        if (fileInfo.EndOfFile.LowPart < (sizeof(uint32) + sizeof(TDDS_HEADER) + sizeof(TDDS_HEADER_DXT10))) then
        begin
            Dispose(ddsData);
            Result := E_FAIL;
            exit;
        end;

        bDXT10Header := True;
    end;

    // setup the pointers in the process request
    //    header := hdr;
    offset := sizeof(uint32) + sizeof(TDDS_HEADER);
    if bDXT10Header then
        offset := offset + sizeof(TDDS_HEADER_DXT10);

    bitData := ddsData + offset;
    bitSize := bitSize - offset;

    Result := S_OK;
end;


//--------------------------------------------------------------------------------------
// Get surface information for a particular format
//--------------------------------------------------------------------------------------
function GetSurfaceInfo(Width: size_t; Height: size_t; fmt: TDXGI_FORMAT; out outNumBytes: size_t; out outRowBytes: size_t; out outNumRows: size_t): HRESULT; inline;
var
    numBytes: uint64;
    rowBytes: uint64;
    numRows: uint64;
    bc: boolean;
    _packed: boolean;
    planar: boolean;
    bpe: size_t;
    numBlocksWide: uint64;
    numBlocksHigh: uint64;
    bpp: size_t;
begin
    numBytes := 0;
    rowBytes := 0;
    numRows := 0;
    bc := False;
    _packed := False;
    planar := False;
    bpe := 0;

    case (fmt) of
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
            _packed := True;
            bpe := 4;
        end;

        DXGI_FORMAT_Y210,
        DXGI_FORMAT_Y216:
        begin
            _packed := True;
            bpe := 8;
        end;

        DXGI_FORMAT_NV12,
        DXGI_FORMAT_420_OPAQUE,
        DXGI_FORMAT_P208:
        begin
            planar := True;
            bpe := 2;
        end;

        DXGI_FORMAT_P010,
        DXGI_FORMAT_P016:
        begin
            planar := True;
            bpe := 4;
        end;
        {$IFDEF XBOX}
        DXGI_FORMAT_D16_UNORM_S8_UINT,
        DXGI_FORMAT_R16_UNORM_X8_TYPELESS,
        DXGI_FORMAT_X16_TYPELESS_G8_UINT:
        begin
            planar := True;
            bpe := 4;
        end;
        {$ENDIF}

    end;

    if (bc) then
    begin
        numBlocksWide := 0;
        if (Width > 0) then
        begin
            numBlocksWide := max(1, (Width + 3) div 4);
        end;
        numBlocksHigh := 0;
        if (Height > 0) then
        begin
            numBlocksHigh := max(1, (Height + 3) div 4);
        end;
        rowBytes := numBlocksWide * bpe;
        numRows := numBlocksHigh;
        numBytes := rowBytes * numBlocksHigh;
    end
    else if (_packed) then
    begin
        rowBytes := ((Width + 1) shr 1) * bpe;
        numRows := Height;
        numBytes := rowBytes * Height;
    end
    else if (fmt = DXGI_FORMAT_NV11) then
    begin
        rowBytes := ((Width + 3) shr 2) * 4;
        numRows := Height * 2; // Direct3D makes this simplifying assumption, although it is larger than the 4:1:1 data
        numBytes := rowBytes * numRows;
    end
    else if (planar) then
    begin
        rowBytes := ((Width + 1) shr 1) * bpe;
        numBytes := (rowBytes * Height) + ((rowBytes * Height + 1) shr 1);
        numRows := Height + ((Height + 1) shr 1);
    end
    else
    begin

        bpp := BitsPerPixel(fmt);
        if bpp = 0 then
        begin
            Result := E_INVALIDARG;
            exit;
        end;
        rowBytes := (Width * bpp + 7) div 8; // round up to nearest byte
        numRows := Height;
        numBytes := rowBytes * Height;
    end;

       {$ifdef CPU32}
       assert(sizeof(size_t) = 4, 'Not a 32-bit platform!');
       if (numBytes > UINT32_MAX) or (rowBytes > UINT32_MAX) or (numRows > UINT32_MAX) then
       begin
            Result := HRESULT_FROM_WIN32(ERROR_ARITHMETIC_OVERFLOW);
            exit;
       end;
       {$else}
    assert(sizeof(size_t) = 8, 'Not a 64-bit platform!');
       {$endif}

    outNumBytes := numBytes;
    outRowBytes := rowBytes;
    outNumRows := numRows;

    Result := S_OK;
end;



function GetAlphaMode(const header: PDDS_HEADER): TDDS_ALPHA_MODE; inline;
var
    d3d10ext: PDDS_HEADER_DXT10;
    mode: TDDS_ALPHA_MODE;
begin
    Result := DDS_ALPHA_MODE_UNKNOWN;
    if (header.ddspf.flags and DDS_FOURCC) = DDS_FOURCC then
    begin
        if (MAKEFOURCC('D', 'X', '1', '0') = header.ddspf.fourCC) then
        begin
            d3d10ext := PDDS_HEADER_DXT10(header + sizeof(TDDS_HEADER));
            mode := TDDS_ALPHA_MODE(d3d10ext.miscFlags2 and Ord(DDS_MISC_FLAGS2_ALPHA_MODE_MASK));
            case (mode) of
                DDS_ALPHA_MODE_STRAIGHT,
                DDS_ALPHA_MODE_PREMULTIPLIED,
                DDS_ALPHA_MODE_OPAQUE,
                DDS_ALPHA_MODE_CUSTOM:
                    Result := mode;
            end;
        end
        else if ((MAKEFOURCC('D', 'X', 'T', '2') = header.ddspf.fourCC) or (MAKEFOURCC('D', 'X', 'T', '4') = header.ddspf.fourCC)) then
        begin
            Result := DDS_ALPHA_MODE_PREMULTIPLIED;
        end;
    end;
end;



function CountMips(Width, Height: uint32): uint32; inline;
var
    Count: uint32;
begin
    Result := 0;
    Count := 1;
    if (Width = 0) or (Height = 0) then Exit;

    while (Width > 1) or (Height > 1) do
    begin
        Width := Width shr 1;
        Height := Height shr 1;
        Inc(Count);
    end;
    Result := Count;
end;



procedure FitPowerOf2(origx: UINT; origy: UINT; var targetx: UINT; var targety: UINT; maxsize: size_t); inline;
var
    origAR: single;
    x: size_t;
    bestScore: single;
    y: size_t;
    score: single;
begin
    origAR := origx / origy;

    if (origx > origy) then
    begin
        x := maxsize;
        while (x > 1) do
        begin
            x := x shr 1;
            if (x <= targetx) then
                break;
        end;

        targetx := UINT(x);

        bestScore := FLT_MAX;
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
        while y > 1 do
        begin
            if (y <= targety) then break;
            y := y shr 1;
        end;

        targety := UINT(y);

        bestScore := FLT_MAX;
        x := maxsize;
        while x > 0 do
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


end.
