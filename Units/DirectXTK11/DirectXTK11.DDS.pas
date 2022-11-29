//--------------------------------------------------------------------------------------
// DDS.h

// This header defines constants and structures that are useful when parsing
// DDS files.  DDS files were originally designed to use several structures
// and constants that are native to DirectDraw and are defined in ddraw.h,
// such as DDSURFACEDESC2 and DDSCAPS2.  This file defines similar
// (compatible) constants and structures so that one can use DDS files
// without needing to include ddraw.h.

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkId=248926
// http://go.microsoft.com/fwlink/?LinkId=248929
// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------

unit DirectXTK11.DDS;

{$IFDEF FPC}
{$mode DelphiUnicode}{$H+}
{$ENDIF}

{$Z4}

interface

uses
    Classes, SysUtils,
    DX12.DXGI,
    DX12.D3D11;

{$Z4}

const
    DDS_MAGIC: uint32 = $20534444; // 'DDS '

    DDS_FOURCC = $00000004;  // DDPF_FOURCC
    DDS_RGB = $00000040;  // DDPF_RGB
    DDS_RGBA = $00000041;  // DDPF_RGB | DDPF_ALPHAPIXELS
    DDS_LUMINANCE = $00020000;  // DDPF_LUMINANCE
    DDS_LUMINANCEA = $00020001;  // DDPF_LUMINANCE | DDPF_ALPHAPIXELS
    DDS_ALPHAPIXELS = $00000001;  // DDPF_ALPHAPIXELS
    DDS_ALPHA = $00000002;  // DDPF_ALPHA
    DDS_PAL8 = $00000020;  // DDPF_PALETTEINDEXED8
    DDS_PAL8A = $00000021;  // DDPF_PALETTEINDEXED8 | DDPF_ALPHAPIXELS
    DDS_BUMPDUDV = $00080000;  // DDPF_BUMPDUDV
    DDS_BUMPLUMINANCE = $00040000;



    DDS_HEADER_FLAGS_TEXTURE = $00001007;  // DDSD_CAPS | DDSD_HEIGHT | DDSD_WIDTH | DDSD_PIXELFORMAT
    DDS_HEADER_FLAGS_MIPMAP = $00020000;  // DDSD_MIPMAPCOUNT
    DDS_HEADER_FLAGS_VOLUME = $00800000;  // DDSD_DEPTH
    DDS_HEADER_FLAGS_PITCH = $00000008;  // DDSD_PITCH
    DDS_HEADER_FLAGS_LINEARSIZE = $00080000;  // DDSD_LINEARSIZE

    DDS_HEIGHT = $00000002; // DDSD_HEIGHT
    DDS_WIDTH = $00000004; // DDSD_WIDTH

    DDS_SURFACE_FLAGS_TEXTURE = $00001000; // DDSCAPS_TEXTURE
    DDS_SURFACE_FLAGS_MIPMAP = $00400008; // DDSCAPS_COMPLEX | DDSCAPS_MIPMAP
    DDS_SURFACE_FLAGS_CUBEMAP = $00000008; // DDSCAPS_COMPLEX

    DDS_CUBEMAP_POSITIVEX = $00000600; // DDSCAPS2_CUBEMAP | DDSCAPS2_CUBEMAP_POSITIVEX
    DDS_CUBEMAP_NEGATIVEX = $00000a00; // DDSCAPS2_CUBEMAP | DDSCAPS2_CUBEMAP_NEGATIVEX
    DDS_CUBEMAP_POSITIVEY = $00001200; // DDSCAPS2_CUBEMAP | DDSCAPS2_CUBEMAP_POSITIVEY
    DDS_CUBEMAP_NEGATIVEY = $00002200; // DDSCAPS2_CUBEMAP | DDSCAPS2_CUBEMAP_NEGATIVEY
    DDS_CUBEMAP_POSITIVEZ = $00004200; // DDSCAPS2_CUBEMAP | DDSCAPS2_CUBEMAP_POSITIVEZ
    DDS_CUBEMAP_NEGATIVEZ = $00008200; // DDSCAPS2_CUBEMAP | DDSCAPS2_CUBEMAP_NEGATIVEZ

    DDS_CUBEMAP_ALLFACES = (DDS_CUBEMAP_POSITIVEX or DDS_CUBEMAP_NEGATIVEX or DDS_CUBEMAP_POSITIVEY or DDS_CUBEMAP_NEGATIVEY or DDS_CUBEMAP_POSITIVEZ or DDS_CUBEMAP_NEGATIVEZ);

    DDS_CUBEMAP = $00000200; // DDSCAPS2_CUBEMAP

    DDS_FLAGS_VOLUME = $00200000; // DDSCAPS2_VOLUME

type
    PDDS_PIXELFORMAT = ^TDDS_PIXELFORMAT;

    TDDS_PIXELFORMAT = record
        size: uint32;
        flags: uint32;
        fourCC: uint32;
        RGBBitCount: uint32;
        RBitMask: uint32;
        GBitMask: uint32;
        BBitMask: uint32;
        ABitMask: uint32;
    end;

//  (Ord('D') or (Ord('X') shl 8) or (Ord('T') shl 16) or (Ord('1') shl 24);
const
    DDSPF_DXT1: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_FOURCC;
        fourCC: (Ord('D') or (Ord('X') shl 8) or (Ord('T') shl 16) or (Ord('1') shl 24));
        RGBBitCount: 0; RBitMask: 0; GBitMask: 0; BBitMask: 0; ABitMask: 0);

    DDSPF_DXT2: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_FOURCC;
        fourCC: (Ord('D') or (Ord('X') shl 8) or (Ord('T') shl 16) or (Ord('2') shl 24));
        RGBBitCount: 0; RBitMask: 0; GBitMask: 0; BBitMask: 0; ABitMask: 0);

    DDSPF_DXT3: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_FOURCC;
        fourCC: (Ord('D') or (Ord('X') shl 8) or (Ord('T') shl 16) or (Ord('3') shl 24));
        RGBBitCount: 0; RBitMask: 0; GBitMask: 0; BBitMask: 0; ABitMask: 0);

    DDSPF_DXT4: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_FOURCC;
        fourCC: (Ord('D') or (Ord('X') shl 8) or (Ord('T') shl 16) or (Ord('4') shl 24));
        RGBBitCount: 0; RBitMask: 0; GBitMask: 0; BBitMask: 0; ABitMask: 0);

    DDSPF_DXT5: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_FOURCC;
        fourCC: (Ord('D') or (Ord('X') shl 8) or (Ord('T') shl 16) or (Ord('5') shl 24));
        RGBBitCount: 0; RBitMask: 0; GBitMask: 0; BBitMask: 0; ABitMask: 0);

    DDSPF_BC4_UNORM: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_FOURCC;
        fourCC: (Ord('B') or (Ord('C') shl 8) or (Ord('4') shl 16) or (Ord('U') shl 24));
        RGBBitCount: 0; RBitMask: 0; GBitMask: 0; BBitMask: 0; ABitMask: 0);

    DDSPF_BC4_SNORM: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_FOURCC;
        fourCC: (Ord('B') or (Ord('C') shl 8) or (Ord('4') shl 16) or (Ord('S') shl 24));
        RGBBitCount: 0; RBitMask: 0; GBitMask: 0; BBitMask: 0; ABitMask: 0);

    DDSPF_BC5_UNORM: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_FOURCC;
        fourCC: (Ord('B') or (Ord('C') shl 8) or (Ord('5') shl 16) or (Ord('U') shl 24));
        RGBBitCount: 0; RBitMask: 0; GBitMask: 0; BBitMask: 0; ABitMask: 0);

    DDSPF_BC5_SNORM: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_FOURCC;
        fourCC: (Ord('B') or (Ord('C') shl 8) or (Ord('5') shl 16) or (Ord('S') shl 24));
        RGBBitCount: 0; RBitMask: 0; GBitMask: 0; BBitMask: 0; ABitMask: 0);

    DDSPF_R8G8_B8G8: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_FOURCC;
        fourCC: (Ord('R') or (Ord('G') shl 8) or (Ord('B') shl 16) or (Ord('G') shl 24));
        RGBBitCount: 0; RBitMask: 0; GBitMask: 0; BBitMask: 0; ABitMask: 0);

    DDSPF_G8R8_G8B8: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_FOURCC;
        fourCC: (Ord('G') or (Ord('R') shl 8) or (Ord('G') shl 16) or (Ord('B') shl 24));
        RGBBitCount: 0; RBitMask: 0; GBitMask: 0; BBitMask: 0; ABitMask: 0);

    DDSPF_YUY2: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_FOURCC;
        fourCC: (Ord('Y') or (Ord('U') shl 8) or (Ord('Y') shl 16) or (Ord('2') shl 24));
        RGBBitCount: 0; RBitMask: 0; GBitMask: 0; BBitMask: 0; ABitMask: 0);

    DDSPF_UYVY: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_FOURCC;
        fourCC: (Ord('U') or (Ord('Y') shl 8) or (Ord('V') shl 16) or (Ord('Y') shl 24));
        RGBBitCount: 0; RBitMask: 0; GBitMask: 0; BBitMask: 0; ABitMask: 0);

    DDSPF_A8R8G8B8: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_RGBA;
        fourCC: 0;
        RGBBitCount: 32; RBitMask: $00ff0000; GBitMask: $0000ff00; BBitMask: $000000ff; ABitMask: $ff000000);

    DDSPF_X8R8G8B8: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_RGB;
        fourCC: 0;
        RGBBitCount: 32; RBitMask: $00ff0000; GBitMask: $0000ff00; BBitMask: $000000ff; ABitMask: 0);

    DDSPF_A8B8G8R8: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_RGBA;
        fourCC: 0;
        RGBBitCount: 32; RBitMask: $000000ff; GBitMask: $0000ff00; BBitMask: $00ff0000; ABitMask: $ff000000);

    DDSPF_X8B8G8R8: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_RGB;
        fourCC: 0;
        RGBBitCount: 32; RBitMask: $000000ff; GBitMask: $0000ff00; BBitMask: $00ff0000; ABitMask: 0);

    DDSPF_G16R16: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_RGB;
        fourCC: 0;
        RGBBitCount: 32; RBitMask: $0000ffff; GBitMask: $ffff0000; BBitMask: 0; ABitMask: 0);

    DDSPF_R5G6B5: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_RGB;
        fourCC: 0;
        RGBBitCount: 16; RBitMask: $f800; GBitMask: $07e0; BBitMask: $001f; ABitMask: 0);

    DDSPF_A1R5G5B5: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_RGBA;
        fourCC: 0;
        RGBBitCount: 16; RBitMask: $7c00; GBitMask: $03e0; BBitMask: $001f; ABitMask: $8000);

    DDSPF_X1R5G5B5: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_RGB;
        fourCC: 0;
        RGBBitCount: 16; RBitMask: $7c00; GBitMask: $03e0; BBitMask: $001f; ABitMask: 0);

    DDSPF_A4R4G4B4: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_RGBA;
        fourCC: 0;
        RGBBitCount: 16; RBitMask: $0f00; GBitMask: $00f0; BBitMask: $000f; ABitMask: $f000);

    DDSPF_X4R4G4B4: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_RGB;
        fourCC: 0;
        RGBBitCount: 16; RBitMask: $0f00; GBitMask: $00f0; BBitMask: $000f; ABitMask: 0);

    DDSPF_R8G8B8: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_RGB;
        fourCC: 0;
        RGBBitCount: 24; RBitMask: $ff0000; GBitMask: $00ff00; BBitMask: $0000ff; ABitMask: 0);

    DDSPF_A8R3G3B2: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_RGBA;
        fourCC: 0;
        RGBBitCount: 16; RBitMask: $00e0; GBitMask: $001c; BBitMask: $0003; ABitMask: $ff00);

    DDSPF_R3G3B2: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_RGB;
        fourCC: 0;
        RGBBitCount: 8; RBitMask: $e0; GBitMask: $1c; BBitMask: $03; ABitMask: 0);

    DDSPF_A4L4: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_LUMINANCEA;
        fourCC: 0;
        RGBBitCount: 8; RBitMask: $0f; GBitMask: 0; BBitMask: 0; ABitMask: $f0);

    DDSPF_L8: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_LUMINANCE;
        fourCC: 0;
        RGBBitCount: 8; RBitMask: $ff; GBitMask: 0; BBitMask: 0; ABitMask: 0);

    DDSPF_L16: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_LUMINANCE;
        fourCC: 0;
        RGBBitCount: 16; RBitMask: $ffff; GBitMask: 0; BBitMask: 0; ABitMask: 0);

    DDSPF_A8L8: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_LUMINANCEA;
        fourCC: 0;
        RGBBitCount: 16; RBitMask: $00ff; GBitMask: 0; BBitMask: 0; ABitMask: $ff00);

    DDSPF_A8L8_ALT: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_LUMINANCEA;
        fourCC: 0;
        RGBBitCount: 8; RBitMask: $00ff; GBitMask: 0; BBitMask: 0; ABitMask: $ff00);

    DDSPF_L8_NVTT1: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_RGB;
        fourCC: 0;
        RGBBitCount: 8; RBitMask: $ff; GBitMask: 0; BBitMask: 0; ABitMask: 0);

    DDSPF_L16_NVTT1: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_RGB;
        fourCC: 0;
        RGBBitCount: 16; RBitMask: $ffff; GBitMask: 0; BBitMask: 0; ABitMask: 0);

    DDSPF_A8L8_NVTT1: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_RGBA;
        fourCC: 0;
        RGBBitCount: 16; RBitMask: $00ff; GBitMask: 0; BBitMask: 0; ABitMask: $ff00);

    DDSPF_A8: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_ALPHA;
        fourCC: 0;
        RGBBitCount: 8; RBitMask: 0; GBitMask: 0; BBitMask: 0; ABitMask: $ff);

    DDSPF_V8U8: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_BUMPDUDV;
        fourCC: 0;
        RGBBitCount: 16; RBitMask: $00ff; GBitMask: $ff00; BBitMask: 0; ABitMask: 0);

    DDSPF_Q8W8V8U8: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_BUMPDUDV;
        fourCC: 0;
        RGBBitCount: 32; RBitMask: $000000ff; GBitMask: $0000ff00; BBitMask: $00ff0000; ABitMask: $ff000000);

    DDSPF_V16U16: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_BUMPDUDV;
        fourCC: 0;
        RGBBitCount: 32; RBitMask: $0000ffff; GBitMask: $ffff0000; BBitMask: 0; ABitMask: 0);


    // D3DFMT_A2R10G10B10/D3DFMT_A2B10G10R10 should be written using DX10 extension to avoid D3DX 10:10:10:2 reversal issue
    DDSPF_A2R10G10B10: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_RGBA;
        fourCC: 0;
        RGBBitCount: 32; RBitMask: $000003ff; GBitMask: $000ffc00; BBitMask: $3ff00000; ABitMask: $c0000000);

    DDSPF_A2B10G10R10: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_RGBA;
        fourCC: 0;
        RGBBitCount: 32; RBitMask: $3ff00000; GBitMask: $000ffc00; BBitMask: $000003ff; ABitMask: $c0000000);


    // We do not support the following legacy Direct3D 9 formats:
    DDSPF_A2W10V10U10: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_BUMPDUDV;
        fourCC: 0;
        RGBBitCount: 32; RBitMask: $3ff00000; GBitMask: $000ffc00; BBitMask: $000003ff; ABitMask: $c0000000);

    DDSPF_L6V5U5: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_BUMPLUMINANCE;
        fourCC: 0;
        RGBBitCount: 16; RBitMask: $001f; GBitMask: $03e0; BBitMask: $fc00; ABitMask: 0);

    DDSPF_X8L8V8U8: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_BUMPLUMINANCE;
        fourCC: 0;
        RGBBitCount: 32; RBitMask: $000000ff; GBitMask: $0000ff00; BBitMask: $00ff0000; ABitMask: 0);

    // This indicates the DDS_HEADER_DXT10 extension is present (the format is in dxgiFormat)
    DDSPF_DX10: TDDS_PIXELFORMAT = (size: sizeof(TDDS_PIXELFORMAT); flags: DDS_FOURCC;
        fourCC: (Ord('D') or (Ord('X') shl 8) or (Ord('1') shl 16) or (Ord('0') shl 24));
        RGBBitCount: 0; RBitMask: 0; GBitMask: 0; BBitMask: 0; ABitMask: 0);


type

    // Subset here matches D3D10_RESOURCE_DIMENSION and D3D11_RESOURCE_DIMENSION
    TDDS_RESOURCE_DIMENSION = (
        DDS_DIMENSION_TEXTURE1D = 2,
        DDS_DIMENSION_TEXTURE2D = 3,
        DDS_DIMENSION_TEXTURE3D = 4);

    // Subset here matches D3D10_RESOURCE_MISC_FLAG and D3D11_RESOURCE_MISC_FLAG
    TDDS_RESOURCE_MISC_FLAG = (
        DDS_RESOURCE_MISC_TEXTURECUBE = $4);

    TDDS_MISC_FLAGS2 = (
        DDS_MISC_FLAGS2_ALPHA_MODE_MASK = $7);

    TDDS_ALPHA_MODE = (
        DDS_ALPHA_MODE_UNKNOWN = 0,
        DDS_ALPHA_MODE_STRAIGHT = 1,
        DDS_ALPHA_MODE_PREMULTIPLIED = 2,
        DDS_ALPHA_MODE_OPAQUE = 3,
        DDS_ALPHA_MODE_CUSTOM = 4);


    PDDS_HEADER = ^TDDS_HEADER;

    TDDS_HEADER = record
        size: uint32;
        flags: uint32;
        Height: uint32;
        Width: uint32;
        pitchOrLinearSize: uint32;
        depth: uint32; // only if DDS_HEADER_FLAGS_VOLUME is set in flags
        mipMapCount: uint32;
        reserved1: array [0..10] of uint32;
        ddspf: TDDS_PIXELFORMAT;
        caps: uint32;
        caps2: uint32;
        caps3: uint32;
        caps4: uint32;
        reserved2: uint32;
    end;

    PDDS_HEADER_DXT10 = ^TDDS_HEADER_DXT10;

    TDDS_HEADER_DXT10 = record
        dxgiFormat: TDXGI_FORMAT;
        resourceDimension: TD3D11_RESOURCE_DIMENSION;
        miscFlag: uint32; // see D3D11_RESOURCE_MISC_FLAG
        arraySize: uint32;
        miscFlags2: uint32; // see DDS_MISC_FLAGS2
    end;


function MAKEFOURCC(ch0, ch1, ch2, ch3: char): uint32;

implementation



function MAKEFOURCC(ch0, ch1, ch2, ch3: char): uint32; inline;
begin
    Result := Ord(ch0) or (Ord(ch1) shl 8) or (Ord(ch2) shl 16) or (Ord(ch3) shl 24);
end;


initialization
    assert(sizeof(TDDS_HEADER) = 124, 'DDS Header size mismatch');
    assert(sizeof(TDDS_HEADER_DXT10) = 20, 'DDS DX10 Extended Header size mismatch');

end.
