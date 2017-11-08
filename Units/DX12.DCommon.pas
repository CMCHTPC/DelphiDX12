unit DX12.DCommon;

{$IFDEF FPC}
{$MODE delphi}{$H+}
{$ENDIF}

interface

{$Z4}

uses
    Windows, Classes, SysUtils, DX12.DXGI;

type
    TDWRITE_MEASURING_MODE = (DWRITE_MEASURING_MODE_NATURAL, DWRITE_MEASURING_MODE_GDI_CLASSIC, DWRITE_MEASURING_MODE_GDI_NATURAL);

    // {$IF NTDDI_VERSION >= NTDDI_WIN10_RS1 }


    // Fonts may contain multiple drawable data formats for glyphs. These flags specify which formats
    // are supported in the font, either at a font-wide level or per glyph, and the app may use them
    // to tell DWrite which formats to return when splitting a color glyph run.

    TDWRITE_GLYPH_IMAGE_FORMATS = (
        // Indicates no data is available for this glyph.
        DWRITE_GLYPH_IMAGE_FORMATS_NONE = $00000000,
        // The glyph has TrueType outlines.
        DWRITE_GLYPH_IMAGE_FORMATS_TRUETYPE = $00000001,
        // The glyph has CFF outlines.
        DWRITE_GLYPH_IMAGE_FORMATS_CFF = $00000002,
        // The glyph has multilayered COLR data.
        DWRITE_GLYPH_IMAGE_FORMATS_COLR = $00000004,
        // The glyph has SVG outlines as standard XML.
        // Fonts may store the content gzip'd rather than plain text,
        // indicated by the first two bytes as gzip header {0x1F 0x8B}.

        DWRITE_GLYPH_IMAGE_FORMATS_SVG = $00000008,
        // The glyph has PNG image data, with standard PNG IHDR.
        DWRITE_GLYPH_IMAGE_FORMATS_PNG = $00000010,
        // The glyph has JPEG image data, with standard JIFF SOI header.
        DWRITE_GLYPH_IMAGE_FORMATS_JPEG = $00000020,
        // The glyph has TIFF image data.
        DWRITE_GLYPH_IMAGE_FORMATS_TIFF = $00000040,
        // The glyph has raw 32-bit premultiplied BGRA data.
        DWRITE_GLYPH_IMAGE_FORMATS_PREMULTIPLIED_B8G8R8A8 = $00000080);
    //{$endif}




    TD2D1_ALPHA_MODE = (D2D1_ALPHA_MODE_UNKNOWN = 0, D2D1_ALPHA_MODE_PREMULTIPLIED = 1, D2D1_ALPHA_MODE_STRAIGHT = 2, D2D1_ALPHA_MODE_IGNORE = 3,
        D2D1_ALPHA_MODE_FORCE_DWORD = $FFFFFFFF);

    TD2D1_PIXEL_FORMAT = record
        format: TDXGI_FORMAT;
        alphaMode: TD2D1_ALPHA_MODE;
    end;

    PD2D1_PIXEL_FORMAT = ^TD2D1_PIXEL_FORMAT;

implementation

end.
