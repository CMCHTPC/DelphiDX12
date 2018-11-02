unit DX12.DWrite3;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

{$Z4}

uses
    Windows, Classes, SysUtils, DX12.DWrite, DX12.DCommon, DX12.D2D1;

const
    IID_IDWriteRenderingParams3: TGUID = '{b7924baa-391b-412a-8c5c-e44cc2d867dc}';
    IID_IDWriteFactory3: TGUID = '{9a1b41c3-d3bb-466a-87fc-fe67556a3b65}';
    IID_IDWriteFontSet: TGUID = '{53585141-D9F8-4095-8321-D73CF6BD116B}';
    IID_IDWriteFontSetBuilder: TGUID = '{2F642AFE-9C68-4F40-B8BE-457401AFCB3D}';
    IID_IDWriteFontCollection1: TGUID = '{53585141-D9F8-4095-8321-D73CF6BD116C}';
    IID_IDWriteFontFamily1: TGUID = '{DA20D8EF-812A-4C43-9802-62EC4ABD7ADF}';
    IID_IDWriteFontList1: TGUID = '{DA20D8EF-812A-4C43-9802-62EC4ABD7ADE}';
    IID_IDWriteFontFaceReference: TGUID = '{5E7FA7CA-DDE3-424C-89F0-9FCD6FED58CD}';
    IID_IDWriteFont3: TGUID = '{29748ED6-8C9C-4A6A-BE0B-D912E8538944}';
    IID_IDWriteFontFace3: TGUID = '{D37D7598-09BE-4222-A236-2081341CC1F2}';
    IID_IDWriteStringList: TGUID = '{CFEE3140-1157-47CA-8B85-31BFCF3F2D0E}';
    IID_IDWriteFontDownloadListener: TGUID = '{B06FE5B9-43EC-4393-881B-DBE4DC72FDA7}';
    IID_IDWriteFontDownloadQueue: TGUID = '{B71E6052-5AEA-4FA3-832E-F60D431F7E91}';
    IID_IDWriteGdiInterop1: TGUID = '{4556BE70-3ABD-4F70-90BE-421780A6F515}';
    IID_IDWriteTextFormat2: TGUID = '{F67E0EDD-9E3D-4ECC-8C32-4183253DFE70}';
    IID_IDWriteTextLayout3: TGUID = '{07DDCD52-020E-4DE8-AC33-6C953D83F92D}';
    IID_IDWriteColorGlyphRunEnumerator1: TGUID = '{7C5F86DA-C7A1-4F05-B8E1-55A179FE5A35}';
    IID_IDWriteFontFace4: TGUID = '{27F2A904-4EB8-441D-9678-0563F53E3E2F}';
    IID_IDWriteFactory4: TGUID = '{4B0B5BD3-0797-4549-8AC5-FE915CC53856}';
    IID_IDWriteFontSetBuilder1: TGUID = '{3FF7715F-3CDC-4DC6-9B72-EC5621DCCAFD}';
    IID_IDWriteAsyncResult: TGUID = '{CE25F8FD-863B-4D13-9651-C1F88DC73FE2}';
    IID_IDWriteRemoteFontFileStream: TGUID = '{4DB3757A-2C72-4ED9-B2B6-1ABABE1AFF9C}';
    IID_IDWriteRemoteFontFileLoader: TGUID = '{68648C83-6EDE-46C0-AB46-20083A887FDE}';
    IID_IDWriteInMemoryFontFileLoader: TGUID = '{DC102F47-A12D-4B1C-822D-9E117E33043F}';
    IID_IDWriteFactory5: TGUID = '{958DB99A-BE2A-4F09-AF7D-65189803D1D3}';


    IID_IDWriteFactory6: TGUID = '{F3744D80-21F7-42EB-B35D-995BC72FC223}';
    IID_IDWriteFontFace5: TGUID = '{98EFF3A5-B667-479A-B145-E2FA5B9FDC29}';
    IID_IDWriteFontResource: TGUID = '{1F803A76-6871-48E8-987F-B975551C50F2}';

    IID_IDWriteFontFaceReference1: TGUID = '{C081FE77-2FD1-41AC-A5A3-34983C4BA61A}';
    IID_IDWriteFontSetBuilder2: TGUID = '{EE5BA612-B131-463C-8F4F-3189B9401E45}';
    IID_IDWriteFontSet1: TGUID = '{7E9FDA85-6C92-4053-BC47-7AE3530DB4D3}';
    IID_IDWriteFontFamily2: TGUID = '{3ED49E77-A398-4261-B9CF-C126C2131EF3}';

    IID_IDWriteFontCollection2: TGUID = '{514039C6-4617-4064-BF8B-92EA83E506E0}';
    IID_IDWriteTextLayout4: TGUID = '{05A9BF42-223F-4441-B5FB-8263685F55E9}';

    IID_IDWriteTextFormat3: TGUID = '{6D3B5641-E550-430D-A85B-B7BF48A93427}';
    IID_IDWriteFontFallback1: TGUID = '{2397599D-DD0D-4681-BD6A-F4F31EAADE77}';
    IID_IDWriteFontList2: TGUID = '{C0763A34-77AF-445A-B735-08C37B0A5BF5}';

    IID_IDWriteFontSet2: TGUID = '{DC7EAD19-E54C-43AF-B2DA-4E2B79BA3F7F}';
    IID_IDWriteFontCollection3: TGUID = '{A4D055A6-F9E3-4E25-93B7-9E309F3AF8E9}';
    IID_IDWriteFactory7: TGUID = '{35D0E0B3-9076-4D2E-A016-A91B568A06B4}';

const
    /// A font resource could not be accessed because it was remote. This can happen
    /// when calling CreateFontFace on a non-local font or trying to measure/draw
    /// glyphs that are not downloaded yet.
    DWRITE_E_REMOTEFONT = HRESULT($8898500D);
    /// The download was canceled, which happens if the application calls
    /// IDWriteFontDownloadQueue::CancelDownload before they finish.
    DWRITE_E_DOWNLOADCANCELLED = HRESULT($8898500E);
    /// The download failed to complete because the remote resource is missing
    /// or the network is down.
    DWRITE_E_DOWNLOADFAILED = HRESULT($8898500F);
    /// A download request was not added or a download failed because there
    /// are too many active downloads.
    DWRITE_E_TOOMANYDOWNLOADS = HRESULT($88985010);

type
    IDWriteFont3 = interface;
    IDWriteFontFace3 = interface;
    IDWriteFontFaceReference = interface;
    IDWriteFontSet = interface;
    IDWriteFontSetBuilder = interface;
    IDWriteFontCollection1 = interface;
    IDWriteFontFamily1 = interface;
    IDWriteStringList = interface;
    IDWriteFontDownloadQueue = interface;


    /// The font property enumeration identifies a string in a font.
    TDWRITE_FONT_PROPERTY_ID = (
        // Unspecified font property identifier.
        DWRITE_FONT_PROPERTY_ID_NONE,
        /// Family name for the weight-width-slope model.
        DWRITE_FONT_PROPERTY_ID_FAMILY_NAME,
        /// Family name preferred by the designer. This enables font designers to group more than four fonts in a single family without losing compatibility with
        /// GDI. This name is typically only present if it differs from the GDI-compatible family name.
        DWRITE_FONT_PROPERTY_ID_PREFERRED_FAMILY_NAME,
        /// Face name of the (e.g., Regular or Bold).
        DWRITE_FONT_PROPERTY_ID_FACE_NAME,
        /// The full name of the font, e.g. "Arial Bold", from name id 4 in the name table.
        DWRITE_FONT_PROPERTY_ID_FULL_NAME,
        /// GDI-compatible family name. Because GDI allows a maximum of four fonts per family, fonts in the same family may have different GDI-compatible family names
        /// (e.g., "Arial", "Arial Narrow", "Arial Black").
        DWRITE_FONT_PROPERTY_ID_WIN32_FAMILY_NAME,
        /// The postscript name of the font, e.g. "GillSans-Bold" from name id 6 in the name table.
        DWRITE_FONT_PROPERTY_ID_POSTSCRIPT_NAME,
        /// Script/language tag to identify the scripts or languages that the font was
        /// primarily designed to support.
        ///
        /// This is meant to be understood from the perspective of users. For example,
        /// a font is considered designed for English if it is considered useful for
        /// English users. Note that this is different from what a font might be capable
        /// of supporting. For example, the Meiryo font was primarily designed for
        /// Japanese users. While it is capable of displaying English well, it was not
        /// meant to be offered for the benefit of non-Japanese-speaking English users.
        ///
        /// As another example, a font designed for Chinese may be capable of displaying
        /// Japanese text, but would likely look incorrect to Japanese users.
        ///
        /// The valid values for this property are "ScriptLangTag" values. These are adapted
        /// from the IETF BCP 47 specification, "Tags for Identifying Languages" (see
        /// http://tools.ietf.org/html/bcp47). In a BCP 47 language tag, a language subtag
        /// element is mandatory and other subtags are optional. In a ScriptLangTag, a
        /// script subtag is mandatory and other subtags are option. The following
        /// augmented BNF syntax, adapted from BCP 47, is used:
        ///
        ///     ScriptLangTag = [language "-"]
        ///                     script
        ///                     ["-" region]
        ///                     *("-" variant)
        ///                     *("-" extension)
        ///                     ["-" privateuse]
        ///
        /// The expansion of the elements and the intended semantics associated with each
        /// are as defined in BCP 47. Script subtags are taken from ISO 15924. At present,
        /// no extensions are defined, and any extension should be ignored. Private use
        /// subtags are defined by private agreement between the source and recipient and
        /// may be ignored.
        ///
        /// Subtags must be valid for use in BCP 47 and contained in the Language Subtag
        /// Registry maintained by IANA. (See
        /// http://www.iana.org/assignments/language-subtag-registry/language-subtag-registry
        /// and section 3 of BCP 47 for details.
        ///
        /// Any ScriptLangTag value not conforming to these specifications is ignored.
        ///
        /// Examples:
        ///   "Latn" denotes Latin script (and any language or writing system using Latin)
        ///   "Cyrl" denotes Cyrillic script
        ///   "sr-Cyrl" denotes Cyrillic script as used for writing the Serbian language;
        ///       a font that has this property value may not be suitable for displaying
        ///       text in Russian or other languages written using Cyrillic script
        ///   "Jpan" denotes Japanese writing (Han + Hiragana + Katakana)
        DWRITE_FONT_PROPERTY_ID_DESIGN_SCRIPT_LANGUAGE_TAG,
        /// Script/language tag to identify the scripts or languages that the font declares
        /// it is able to support.
        DWRITE_FONT_PROPERTY_ID_SUPPORTED_SCRIPT_LANGUAGE_TAG,
        /// Semantic tag to describe the font (e.g. Fancy, Decorative, Handmade, Sans-serif, Swiss, Pixel, Futuristic).
        DWRITE_FONT_PROPERTY_ID_SEMANTIC_TAG,
        /// Weight of the font represented as a decimal string in the range 1-999.
        DWRITE_FONT_PROPERTY_ID_WEIGHT,
        /// Stretch of the font represented as a decimal string in the range 1-9.
        DWRITE_FONT_PROPERTY_ID_STRETCH,
        /// Stretch of the font represented as a decimal string in the range 0-2.
        DWRITE_FONT_PROPERTY_ID_STYLE,
        /// Total number of properties.
        DWRITE_FONT_PROPERTY_ID_TOTAL);


    /// Font property used for filtering font sets and
    /// building a font set with explicit properties.

    TDWRITE_FONT_PROPERTY = record
        /// Specifies the requested font property, such as DWRITE_FONT_PROPERTY_ID_FAMILY_NAME.
        propertyId: TDWRITE_FONT_PROPERTY_ID;
        /// Specifies the value, such as "Segoe UI".
        propertyValue: PWideChar;
        /// Specifies the locale to use, such as "en-US". Simply leave this empty when used
        /// with the font set filtering functions, as they will find a match regardless of
        /// language. For passing to AddFontFaceReference, the localeName tells the language
        /// of the property value.
        localeName: PWideChar;
    end;

    PDWRITE_FONT_PROPERTY = ^TDWRITE_FONT_PROPERTY;


    /// Specifies the locality of a resource.

    TDWRITE_LOCALITY = (
        /// The resource is remote, and information is unknown yet, including the file size and date.
        /// Attempting to create a font or file stream will fail until locality becomes at least partial.
        DWRITE_LOCALITY_REMOTE,
        /// The resource is partially local, meaning you can query the size and date of the file
        /// stream, and you may be able to create a font face and retrieve the particular glyphs
        /// for metrics and drawing, but not all the glyphs will be present.
        DWRITE_LOCALITY_PARTIAL,
        /// The resource is completely local, and all font functions can be called
        /// without concern of missing data or errors related to network connectivity.
        DWRITE_LOCALITY_LOCAL);
    /// Represents a method of rendering glyphs.

    TDWRITE_RENDERING_MODE1 = (
        /// Specifies that the rendering mode is determined automatically based on the font and size.
        DWRITE_RENDERING_MODE1_DEFAULT = Ord(DWRITE_RENDERING_MODE_DEFAULT),
        /// Specifies that no antialiasing is performed. Each pixel is either set to the foreground
        /// color of the text or retains the color of the background.
        DWRITE_RENDERING_MODE1_ALIASED = Ord(DWRITE_RENDERING_MODE_ALIASED),
        /// Specifies that antialiasing is performed in the horizontal direction and the appearance
        /// of glyphs is layout-compatible with GDI using CLEARTYPE_QUALITY. Use DWRITE_MEASURING_MODE_GDI_CLASSIC
        /// to get glyph advances. The antialiasing may be either ClearType or grayscale depending on
        /// the text antialiasing mode.
        DWRITE_RENDERING_MODE1_GDI_CLASSIC = Ord(DWRITE_RENDERING_MODE_GDI_CLASSIC),
        /// Specifies that antialiasing is performed in the horizontal direction and the appearance
        /// of glyphs is layout-compatible with GDI using CLEARTYPE_NATURAL_QUALITY. Glyph advances
        /// are close to the font design advances, but are still rounded to whole pixels. Use
        /// DWRITE_MEASURING_MODE_GDI_NATURAL to get glyph advances. The antialiasing may be either
        /// ClearType or grayscale depending on the text antialiasing mode.
        DWRITE_RENDERING_MODE1_GDI_NATURAL = Ord(DWRITE_RENDERING_MODE_GDI_NATURAL),
        /// Specifies that antialiasing is performed in the horizontal direction. This rendering
        /// mode allows glyphs to be positioned with subpixel precision and is therefore suitable
        /// for natural (i.e., resolution-independent) layout. The antialiasing may be either
        /// ClearType or grayscale depending on the text antialiasing mode.
        DWRITE_RENDERING_MODE1_NATURAL = Ord(DWRITE_RENDERING_MODE_NATURAL),
        /// Similar to natural mode except that antialiasing is performed in both the horizontal
        /// and vertical directions. This is typically used at larger sizes to make curves and
        /// diagonal lines look smoother. The antialiasing may be either ClearType or grayscale
        /// depending on the text antialiasing mode.
        DWRITE_RENDERING_MODE1_NATURAL_SYMMETRIC = Ord(DWRITE_RENDERING_MODE_NATURAL_SYMMETRIC),
        /// Specifies that rendering should bypass the rasterizer and use the outlines directly.
        /// This is typically used at very large sizes.
        DWRITE_RENDERING_MODE1_OUTLINE = Ord(DWRITE_RENDERING_MODE_OUTLINE),
        /// Similar to natural symmetric mode except that when possible, text should be rasterized
        /// in a downsampled form.
        DWRITE_RENDERING_MODE1_NATURAL_SYMMETRIC_DOWNSAMPLED);


    /// The interface that represents text rendering settings for glyph rasterization and filtering.


    IDWriteRenderingParams3 = interface(IDWriteRenderingParams2)
        ['{b7924baa-391b-412a-8c5c-e44cc2d867dc}']
        function GetRenderingMode1(): TDWRITE_RENDERING_MODE1; stdcall;
    end;


    IDWriteFactory3 = interface(IDWriteFactory2)
        ['{9a1b41c3-d3bb-466a-87fc-fe67556a3b65}']
        function CreateGlyphRunAnalysis(const glyphRun: TDWRITE_GLYPH_RUN; const transform: TDWRITE_MATRIX;
            renderingMode: TDWRITE_RENDERING_MODE1; measuringMode: TDWRITE_MEASURING_MODE; gridFitMode: TDWRITE_GRID_FIT_MODE;
            antialiasMode: TDWRITE_TEXT_ANTIALIAS_MODE; baselineOriginX: single; baselineOriginY: single;
            out glyphRunAnalysis: IDWriteGlyphRunAnalysis): HResult; stdcall;
        function CreateCustomRenderingParams(gamma: single; enhancedContrast: single; grayscaleEnhancedContrast: single;
            clearTypeLevel: single; pixelGeometry: TDWRITE_PIXEL_GEOMETRY; renderingMode: TDWRITE_RENDERING_MODE1;
            gridFitMode: TDWRITE_GRID_FIT_MODE; out renderingParams: IDWriteRenderingParams3): HResult; stdcall;
        function CreateFontFaceReference(filePath: PWideChar; const lastWriteTime: TFILETIME; faceIndex: UINT32;
            fontSimulations: TDWRITE_FONT_SIMULATIONS; out fontFaceReference: IDWriteFontFaceReference): HResult; stdcall; overload;
        function CreateFontFaceReference(fontFile: IDWriteFontFile; faceIndex: UINT32; fontSimulations: TDWRITE_FONT_SIMULATIONS;
            out fontFaceReference: IDWriteFontFaceReference): HResult; stdcall; overload;
        function GetSystemFontSet(out fontSet: IDWriteFontSet): HResult; stdcall;
        function CreateFontSetBuilder(out fontSetBuilder: IDWriteFontSetBuilder): HResult; stdcall;
        function CreateFontCollectionFromFontSet(fontSet: IDWriteFontSet; out fontCollection: IDWriteFontCollection1): HResult; stdcall;
        function GetSystemFontCollection(includeDownloadableFonts: boolean; out fontCollection: IDWriteFontCollection1;
            checkForUpdates: boolean = False): HResult; stdcall;
        function GetFontDownloadQueue(out fontDownloadQueue: IDWriteFontDownloadQueue): HResult; stdcall;
    end;


    IDWriteFontSet = interface(IUnknown)
        ['{53585141-D9F8-4095-8321-D73CF6BD116B}']
        function GetFontCount(): UINT32; stdcall;
        function GetFontFaceReference(listIndex: UINT32; out fontFaceReference: IDWriteFontFaceReference): HResult; stdcall;
        function FindFontFaceReference(fontFaceReference: IDWriteFontFaceReference; out listIndex: UINT32;
            out exists: boolean): HResult; stdcall;
        function FindFontFace(fontFace: IDWriteFontFace; out listIndex: UINT32; out exists: boolean): HResult; stdcall;
        function GetPropertyValues(listIndex: UINT32; propertyId: TDWRITE_FONT_PROPERTY_ID; out exists: boolean;
            out values: IDWriteLocalizedStrings): HResult; stdcall; overload;
        function GetPropertyValues(propertyID: TDWRITE_FONT_PROPERTY_ID; preferredLocaleNames: PWideChar;
            out values: IDWriteStringList): HResult; stdcall; overload;
        function GetPropertyValues(propertyID: TDWRITE_FONT_PROPERTY_ID; out values: IDWriteStringList): HResult; stdcall; overload;
        function GetPropertyOccurrenceCount(const _property: TDWRITE_FONT_PROPERTY;
            out propertyOccurrenceCount: UINT32): HResult; stdcall;
        function GetMatchingFonts(properties: PDWRITE_FONT_PROPERTY; propertyCount: UINT32; out filteredSet: IDWriteFontSet): HResult;
            stdcall; overload;
        function GetMatchingFonts(familyName: PWideChar; fontWeight: TDWRITE_FONT_WEIGHT; fontStretch: TDWRITE_FONT_STRETCH;
            fontStyle: TDWRITE_FONT_STYLE; out filteredSet: IDWriteFontSet): HResult;
            stdcall; overload;
    end;


    IDWriteFontSetBuilder = interface(IUnknown)
        ['{2F642AFE-9C68-4F40-B8BE-457401AFCB3D}']
        function AddFontFaceReference(fontFaceReference: IDWriteFontFaceReference): HResult; stdcall; overload;
        function AddFontFaceReference(fontFaceReference: IDWriteFontFaceReference; properties: PDWRITE_FONT_PROPERTY;
            propertyCount: UINT32): HResult; stdcall; overload;
        function AddFontSet(fontSet: IDWriteFontSet): HResult; stdcall;
        function CreateFontSet(out fontSet: IDWriteFontSet): HResult; stdcall;
    end;


    IDWriteFontCollection1 = interface(IDWriteFontCollection)
        ['{53585141-D9F8-4095-8321-D73CF6BD116C}']
        function GetFontSet(out fontSet: IDWriteFontSet): HResult; stdcall;
        function GetFontFamily(index: UINT32; out fontFamily: IDWriteFontFamily1): HResult; stdcall;
    end;


    /// The IDWriteFontFamily interface represents a set of fonts that share the same design but are differentiated
    /// by weight, stretch, and style.


    IDWriteFontFamily1 = interface(IDWriteFontFamily)
        ['{DA20D8EF-812A-4C43-9802-62EC4ABD7ADF}']
        function GetFontLocality(listIndex: UINT32): TDWRITE_LOCALITY; stdcall;
        function GetFont(listIndex: UINT32; out font: IDWriteFont3): HResult; stdcall;
        function GetFontFaceReference(listIndex: UINT32; out fontFaceReference: IDWriteFontFaceReference): HResult; stdcall;
    end;


    /// The IDWriteFontList interface represents a list of fonts.

    IDWriteFontList1 = interface(IDWriteFontList)
        ['{DA20D8EF-812A-4C43-9802-62EC4ABD7ADE}']
        function GetFontLocality(listIndex: UINT32): TDWRITE_LOCALITY; stdcall;
        function GetFont(listIndex: UINT32; out font: IDWriteFont3): HResult; stdcall;
        function GetFontFaceReference(listIndex: UINT32; out fontFaceReference: IDWriteFontFaceReference): HResult; stdcall;
    end;


    /// A uniquely identifying reference to a font, from which you can create a font
    /// face to query font metrics and use for rendering. A font face reference
    /// consists of a font file, font face index, and font face simulation. The file
    /// data may or may not be physically present on the local machine yet.


    IDWriteFontFaceReference = interface(IUnknown)
        ['{5E7FA7CA-DDE3-424C-89F0-9FCD6FED58CD}']
        function CreateFontFace(out fontFace: IDWriteFontFace3): HResult; stdcall;
        function CreateFontFaceWithSimulations(fontFaceSimulationFlags: TDWRITE_FONT_SIMULATIONS;
            out fontFace: IDWriteFontFace3): HResult; stdcall;
        function Equals(fontFaceReference: IDWriteFontFaceReference): boolean; stdcall;
        function GetFontFaceIndex(): UINT32; stdcall;
        function GetSimulations(): TDWRITE_FONT_SIMULATIONS; stdcall;
        function GetFontFile(out fontFile: IDWriteFontFile): HResult; stdcall;
        function GetLocalFileSize(): UINT64; stdcall;
        function GetFileSize(): UINT64; stdcall;
        function GetFileTime(out lastWriteTime: TFILETIME): HResult; stdcall;
        function GetLocality(): TDWRITE_LOCALITY; stdcall;
        function EnqueueFontDownloadRequest(): HResult; stdcall;
        function EnqueueCharacterDownloadRequest(characters: PWideChar; characterCount: UINT32): HResult; stdcall;
        function EnqueueGlyphDownloadRequest(glyphIndices: PUINT16; glyphCount: UINT32): HResult; stdcall;
        function EnqueueFileFragmentDownloadRequest(fileOffset: UINT64; fragmentSize: UINT64): HResult; stdcall;
    end;


    /// The IDWriteFont interface represents a font in a font collection.


    IDWriteFont3 = interface(IDWriteFont2)
        ['{29748ED6-8C9C-4A6A-BE0B-D912E8538944}']
        function CreateFontFace(out fontFace: IDWriteFontFace3): HResult; stdcall;
        function Equals(font: IDWriteFont): boolean; stdcall;
        function GetFontFaceReference(out fontFaceReference: IDWriteFontFaceReference): HResult; stdcall;
        function HasCharacter(unicodeValue: UINT32): BOOL; stdcall;
        function GetLocality(): TDWRITE_LOCALITY; stdcall;
    end;


    /// The interface that represents an absolute reference to a font face.
    /// It contains font face type, appropriate file references and face identification data.
    /// Various font data such as metrics, names and glyph outlines is obtained from IDWriteFontFace.


    IDWriteFontFace3 = interface(IDWriteFontFace2)
        ['{D37D7598-09BE-4222-A236-2081341CC1F2}']
        function GetFontFaceReference(out fontFaceReference: IDWriteFontFaceReference): HResult; stdcall;
        procedure GetPanose(out panose: TDWRITE_PANOSE); stdcall;
        function GetWeight(): TDWRITE_FONT_WEIGHT; stdcall;
        function GetStretch(): TDWRITE_FONT_STRETCH; stdcall;
        function GetStyle(): TDWRITE_FONT_STYLE; stdcall;
        function GetFamilyNames(out names: IDWriteLocalizedStrings): HResult; stdcall;
        function GetFaceNames(out names: IDWriteLocalizedStrings): HResult; stdcall;
        function GetInformationalStrings(informationalStringID: TDWRITE_INFORMATIONAL_STRING_ID;
            out informationalStrings: IDWriteLocalizedStrings; out exists: boolean): HResult; stdcall;
        function HasCharacter(unicodeValue: UINT32): boolean; stdcall;
        function GetRecommendedRenderingMode(fontEmSize: single; dpiX: single; dpiY: single; const transform: TDWRITE_MATRIX;
            isSideways: boolean; outlineThreshold: TDWRITE_OUTLINE_THRESHOLD; measuringMode: TDWRITE_MEASURING_MODE;
            renderingParams: IDWriteRenderingParams; out renderingMode: TDWRITE_RENDERING_MODE1;
            out gridFitMode: TDWRITE_GRID_FIT_MODE): HResult; stdcall;
        function IsCharacterLocal(unicodeValue: UINT32): boolean; stdcall;
        function IsGlyphLocal(glyphId: UINT16): boolean; stdcall;
        function AreCharactersLocal(characters: PWideChar; characterCount: UINT32; enqueueIfNotLocal: boolean;
            out isLocal: boolean): HResult; stdcall;
        function AreGlyphsLocal(glyphIndices: PUINT16; glyphCount: UINT32; enqueueIfNotLocal: boolean;
            out isLocal: boolean): HResult; stdcall;
    end;


    /// Represents a collection of strings indexed by number.
    /// An IDWriteStringList is otherwise identical to IDWriteLocalizedStrings except
    /// for the semantics, where localized strings are indexed on language (each
    /// language has one string property) whereas a string list may contain multiple
    /// strings of the same language, such as a string list of family names from a
    /// font set. You can QueryInterface from an IDWriteLocalizedStrings to an
    /// IDWriteStringList.


    IDWriteStringList = interface(IUnknown)
        ['{CFEE3140-1157-47CA-8B85-31BFCF3F2D0E}']
        function GetCount(): UINT32; stdcall;
        function GetLocaleNameLength(listIndex: UINT32; out length: UINT32): HResult; stdcall;
        function GetLocaleName(listIndex: UINT32; localeName: PWideChar; size: UINT32): HResult; stdcall;
        function GetStringLength(listIndex: UINT32; out length: UINT32): HResult; stdcall;
        function GetString(listIndex: UINT32; out stringBuffer: PWideChar; stringBufferSize: UINT32): HResult; stdcall;
    end;


    /// Application-defined callback interface that receives notifications from the font
    /// download queue (IDWriteFontDownloadQueue interface). Callbacks will occur on the
    /// downloading thread, and objects must be prepared to handle calls on their methods
    /// from other threads at any time.


    IDWriteFontDownloadListener = interface(IUnknown)
        ['{B06FE5B9-43EC-4393-881B-DBE4DC72FDA7}']
        procedure DownloadCompleted(downloadQueue: IDWriteFontDownloadQueue; context: IUnknown; downloadResult: HRESULT); stdcall;
    end;


    /// Interface that enqueues download requests for remote fonts, characters, glyphs, and font fragments.
    /// Provides methods to asynchronously execute a download, cancel pending downloads, and be notified of
    /// download completion. Callbacks to listeners will occur on the downloading thread, and objects must
    /// be must be able to handle calls on their methods from other threads at any time.


    IDWriteFontDownloadQueue = interface(IUnknown)
        ['{B71E6052-5AEA-4FA3-832E-F60D431F7E91}']
        function AddListener(listener: IDWriteFontDownloadListener; out token: UINT32): HResult; stdcall;
        function RemoveListener(token: UINT32): HResult; stdcall;
        function IsEmpty(): boolean; stdcall;
        function BeginDownload(context: IUnknown = nil): HResult; stdcall;
        function CancelDownload(): HResult; stdcall;
        function GetGenerationCount(): UINT64; stdcall;
    end;


    /// The GDI interop interface provides interoperability with GDI.


    IDWriteGdiInterop1 = interface(IDWriteGdiInterop)
        ['{4556BE70-3ABD-4F70-90BE-421780A6F515}']
        function CreateFontFromLOGFONT(const logFont: TLOGFONTW; fontCollection: IDWriteFontCollection;
            out font: IDWriteFont): HResult; stdcall;
        function GetFontSignature(font: IDWriteFont; out fontSignature: TFONTSIGNATURE): HResult; stdcall; overload;
        function GetFontSignature(fontFace: IDWriteFontFace; out fontSignature: TFONTSIGNATURE): HResult; stdcall; overload;
        function GetMatchingFontsByLOGFONT(const logFont: TLOGFONT; fontSet: IDWriteFontSet;
            out filteredSet: IDWriteFontSet): HResult; stdcall;
    end;


    /// Information about a formatted line of text.

    TDWRITE_LINE_METRICS1 = record
        length: UINT32;
        trailingWhitespaceLength: UINT32;
        newlineLength: UINT32;
        Height: single;
        baseline: single;
        isTrimmed: longbool;
        leadingBefore: single;
        leadingAfter: single;
    end;

    PDWRITE_LINE_METRICS1 = ^TDWRITE_LINE_METRICS1;


    /// Specify whether DWRITE_FONT_METRICS::lineGap value should be part of the line metrics.

    TDWRITE_FONT_LINE_GAP_USAGE = (
        /// The usage of the font line gap depends on the method used for text layout.
        DWRITE_FONT_LINE_GAP_USAGE_DEFAULT,
        /// The font line gap is excluded from line spacing
        DWRITE_FONT_LINE_GAP_USAGE_DISABLED,
        /// The font line gap is included in line spacing
        DWRITE_FONT_LINE_GAP_USAGE_ENABLED);
    /// The DWRITE_LINE_SPACING structure specifies the parameters used to specify how to manage space between lines.

    TDWRITE_LINE_SPACING = record
        method: TDWRITE_LINE_SPACING_METHOD;
        Height: single;
        baseline: single;
        leadingBefore: single;
        fontLineGapUsage: TDWRITE_FONT_LINE_GAP_USAGE;
    end;


    IDWriteTextFormat2 = interface(IDWriteTextFormat1)
        ['{F67E0EDD-9E3D-4ECC-8C32-4183253DFE70}']
        function SetLineSpacing(const lineSpacingOptions: TDWRITE_LINE_SPACING): HResult; stdcall;
        function GetLineSpacing(out lineSpacingOptions: TDWRITE_LINE_SPACING): HResult; stdcall;
    end;


    IDWriteTextLayout3 = interface(IDWriteTextLayout2)
        ['{07DDCD52-020E-4DE8-AC33-6C953D83F92D}']
        function InvalidateLayout(): HResult; stdcall;
        function SetLineSpacing(const lineSpacingOptions: TDWRITE_LINE_SPACING): HResult; stdcall;
        function GetLineSpacing(out lineSpacingOptions: TDWRITE_LINE_SPACING): HResult; stdcall;
        function GetLineMetrics(out lineMetrics: PDWRITE_LINE_METRICS1; maxLineCount: UINT32;
            out actualLineCount: UINT32): HResult; stdcall;
    end;




    // if NTDDI_VERSION >= NTDDI_WIN10_RS1



    TDWRITE_GLYPH_IMAGE_FORMATS = (
        DWRITE_GLYPH_IMAGE_FORMATS_NONE = $00000000,
        DWRITE_GLYPH_IMAGE_FORMATS_TRUETYPE = $00000001,
        DWRITE_GLYPH_IMAGE_FORMATS_CFF = $00000002,
        DWRITE_GLYPH_IMAGE_FORMATS_COLR = $00000004,
        DWRITE_GLYPH_IMAGE_FORMATS_SVG = $00000008,
        DWRITE_GLYPH_IMAGE_FORMATS_PNG = $00000010,
        DWRITE_GLYPH_IMAGE_FORMATS_JPEG = $00000020,
        DWRITE_GLYPH_IMAGE_FORMATS_TIFF = $00000040,
        DWRITE_GLYPH_IMAGE_FORMATS_PREMULTIPLIED_B8G8R8A8 = $00000080);


    TDWRITE_COLOR_GLYPH_RUN1 = record
        glyphRun: TDWRITE_GLYPH_RUN;
        glyphRunDescription: PDWRITE_GLYPH_RUN_DESCRIPTION;
        baselineOriginX: single;
        baselineOriginY: single;
        runColor: TDWRITE_COLOR_F;
        paletteIndex: UINT16;
        glyphImageFormat: TDWRITE_GLYPH_IMAGE_FORMATS;
        measuringMode: TDWRITE_MEASURING_MODE;
    end;


    TDWRITE_GLYPH_IMAGE_DATA = record
        imageData: Pointer;
        imageDataSize: UINT32;
        uniqueDataId: UINT32;
        pixelsPerEm: UINT32;
        pixelSize: TD2D1_SIZE_U;
        horizontalLeftOrigin: TD2D1_POINT_2L;
        horizontalRightOrigin: TD2D1_POINT_2L;
        verticalTopOrigin: TD2D1_POINT_2L;
        verticalBottomOrigin: TD2D1_POINT_2L;
    end;




    IDWriteColorGlyphRunEnumerator1 = interface(IDWriteColorGlyphRunEnumerator)
        ['{7C5F86DA-C7A1-4F05-B8E1-55A179FE5A35}']
        function GetCurrentRun(out colorGlyphRun: TDWRITE_COLOR_GLYPH_RUN1): HResult; stdcall;
    end;


    IDWriteFontFace4 = interface(IDWriteFontFace3)
        ['{27F2A904-4EB8-441D-9678-0563F53E3E2F}']
        function GetGlyphImageFormats(glyphId: UINT16; pixelsPerEmFirst: UINT32; pixelsPerEmLast: UINT32;
            out glyphImageFormats: TDWRITE_GLYPH_IMAGE_FORMATS): HResult; stdcall;
        function GetGlyphImageData(glyphId: UINT16; pixelsPerEm: UINT32; glyphImageFormat: TDWRITE_GLYPH_IMAGE_FORMATS;
            out glyphData: TDWRITE_GLYPH_IMAGE_DATA; out glyphDataContext: pointer): HResult; stdcall;
        procedure ReleaseGlyphImageData(glyphDataContext: pointer); stdcall;
    end;


    IDWriteFactory4 = interface(IDWriteFactory3)
        ['{4B0B5BD3-0797-4549-8AC5-FE915CC53856}']
        function TranslateColorGlyphRun(baselineOrigin: TD2D1_POINT_2F; const glyphRun: TDWRITE_GLYPH_RUN;
            const glyphRunDescription: TDWRITE_GLYPH_RUN_DESCRIPTION; desiredGlyphImageFormats: TDWRITE_GLYPH_IMAGE_FORMATS;
            measuringMode: TDWRITE_MEASURING_MODE; const worldAndDpiTransform: TDWRITE_MATRIX; colorPaletteIndex: UINT32;
            out colorLayers: IDWriteColorGlyphRunEnumerator1): HResult; stdcall;
        function ComputeGlyphOrigins(const glyphRun: TDWRITE_GLYPH_RUN; measuringMode: TDWRITE_MEASURING_MODE;
            baselineOrigin: TD2D1_POINT_2F; const worldAndDpiTransform: TDWRITE_MATRIX;
            out glyphOrigins: PD2D1_POINT_2F): HResult; stdcall;
    end;


    //endif // NTDDI_VERSION >= NTDDI_WIN10_RS1



    //{$IFDEF NTDDI_VERSION >= NTDDI_WIN10_RS2}

    IDWriteFontSetBuilder1 = interface(IDWriteFontSetBuilder)
        ['{3FF7715F-3CDC-4DC6-9B72-EC5621DCCAFD}']
        function AddFontFile(fontFile: IDWriteFontFile): HResult; stdcall;
    end;


    IDWriteAsyncResult = interface(IUnknown)
        ['{CE25F8FD-863B-4D13-9651-C1F88DC73FE2}']
        function GetWaitHandle(): THANDLE; stdcall;
        function GetResult(): HResult; stdcall;
    end;


    TDWRITE_FILE_FRAGMENT = record
        fileOffset: UINT64;
        fragmentSize: UINT64;
    end;
    PDWRITE_FILE_FRAGMENT = ^TDWRITE_FILE_FRAGMENT;


    IDWriteRemoteFontFileStream = interface(IDWriteFontFileStream)
        ['{4DB3757A-2C72-4ED9-B2B6-1ABABE1AFF9C}']
        function GetLocalFileSize(out localFileSize: UINT64): HResult; stdcall;
        function GetFileFragmentLocality(fileOffset: UINT64; fragmentSize: UINT64; out isLocal: boolean;
            out partialSize: PUINT64): HResult; stdcall;
        function GetLocality(): TDWRITE_LOCALITY; stdcall;
        function BeginDownload(const downloadOperationID: TGUID; fileFragments: PDWRITE_FILE_FRAGMENT;
            fragmentCount: UINT32; out asyncResult: IDWriteAsyncResult): HResult; stdcall;
    end;



    TDWRITE_CONTAINER_TYPE = (
        DWRITE_CONTAINER_TYPE_UNKNOWN,
        DWRITE_CONTAINER_TYPE_WOFF,
        DWRITE_CONTAINER_TYPE_WOFF2);



    IDWriteRemoteFontFileLoader = interface(IDWriteFontFileLoader)
        ['{68648C83-6EDE-46C0-AB46-20083A887FDE}']
        function CreateRemoteStreamFromKey(fontFileReferenceKey: Pointer; fontFileReferenceKeySize: UINT32;
            out fontFileStream: IDWriteRemoteFontFileStream): HResult; stdcall;
        function GetLocalityFromKey(fontFileReferenceKey: Pointer; fontFileReferenceKeySize: UINT32;
            out locality: TDWRITE_LOCALITY): HResult; stdcall;
        function CreateFontFileReferenceFromUrl(factory: IDWriteFactory; baseUrl: PWCHAR; fontFileUrl: PWCHAR;
            out fontFile: IDWriteFontFile): HResult; stdcall;
    end;



    IDWriteInMemoryFontFileLoader = interface(IDWriteFontFileLoader)
        ['{DC102F47-A12D-4B1C-822D-9E117E33043F}']
        function CreateInMemoryFontFileReference(factory: IDWriteFactory; fontData: Pointer; fontDataSize: UINT32;
            ownerObject: IUnknown; out fontFile: IDWriteFontFile): HResult; stdcall;
        function GetFileCount(): UINT32; stdcall;
    end;



    IDWriteFactory5 = interface(IDWriteFactory4)
        ['{958DB99A-BE2A-4F09-AF7D-65189803D1D3}']
        function CreateFontSetBuilder(out fontSetBuilder: IDWriteFontSetBuilder1): HResult; stdcall;
        function CreateInMemoryFontFileLoader(out newLoader: IDWriteInMemoryFontFileLoader): HResult; stdcall;
        function CreateHttpFontFileLoader(referrerUrl: PWChar; extraHeaders: PWChar;
            out newLoader: IDWriteRemoteFontFileLoader): HResult; stdcall;
        function AnalyzeContainerType(fileData: Pointer; fileDataSize: UINT32): TDWRITE_CONTAINER_TYPE; stdcall;
        function UnpackFontFile(containerType: TDWRITE_CONTAINER_TYPE; fileData: Pointer; fileDataSize: UINT32;
            out unpackedFontStream: IDWriteFontFileStream): HResult; stdcall;
    end;

    //{$endif}// NTDDI_VERSION >= NTDDI_WIN10_RS2


    //{$if NTDDI_VERSION >= NTDDI_WIN10_RS3}


    IDWriteFontResource = interface;
    IDWriteFontFace5 = interface;
    IDWriteFontFaceReference1 = interface;
    IDWriteFontSet1 = interface;
    IDWriteFontCollection2 = interface;
    IDWriteTextFormat3 = interface;
    IDWriteFontSetBuilder2 = interface;



    TDWRITE_FONT_AXIS_TAG = (
        DWRITE_FONT_AXIS_TAG_WEIGHT = UINT32(Ord('w') or (Ord('g') shl 8) or (Ord('h') shl 16) or (Ord('t') shl 24)),
        DWRITE_FONT_AXIS_TAG_WIDTH = UINT32(Ord('w') or (Ord('d') shl 8) or (Ord('t') shl 16) or (Ord('h') shl 24)),
        DWRITE_FONT_AXIS_TAG_SLANT = UINT32(Ord('s') or (Ord('l') shl 8) or (Ord('n') shl 16) or (Ord('t') shl 24)),
        DWRITE_FONT_AXIS_TAG_OPTICAL_SIZE = UINT32(Ord('o') or (Ord('p') shl 8) or (Ord('s') shl 16) or (Ord('z') shl 24)),
        DWRITE_FONT_AXIS_TAG_ITALIC = UINT32(Ord('i') or (Ord('t') shl 8) or (Ord('a') shl 16) or (Ord('l') shl 24)));


    TDWRITE_FONT_AXIS_VALUE = record
        axisTag: TDWRITE_FONT_AXIS_TAG;
        Value: single;
    end;
    PDWRITE_FONT_AXIS_VALUE = ^TDWRITE_FONT_AXIS_VALUE;


    TDWRITE_FONT_AXIS_RANGE = record
        axisTag: TDWRITE_FONT_AXIS_TAG;
        MinValue: single;
        MaxValue: single;
    end;
    PDWRITE_FONT_AXIS_RANGE = ^TDWRITE_FONT_AXIS_RANGE;

    TDWRITE_FONT_FAMILY_MODEL = (
        DWRITE_FONT_FAMILY_MODEL_TYPOGRAPHIC,
        DWRITE_FONT_FAMILY_MODEL_WEIGHT_STRETCH_STYLE);
    PDWRITE_FONT_FAMILY_MODEL = ^TDWRITE_FONT_FAMILY_MODEL;

    TDWRITE_AUTOMATIC_FONT_AXES = (
        DWRITE_AUTOMATIC_FONT_AXES_NONE = $0000,
        DWRITE_AUTOMATIC_FONT_AXES_OPTICAL_SIZE = $0001);
    PDWRITE_AUTOMATIC_FONT_AXES = ^TDWRITE_AUTOMATIC_FONT_AXES;

    TDWRITE_FONT_AXIS_ATTRIBUTES = (
        DWRITE_FONT_AXIS_ATTRIBUTES_NONE = $0000,
        DWRITE_FONT_AXIS_ATTRIBUTES_VARIABLE = $0001,
        DWRITE_FONT_AXIS_ATTRIBUTES_HIDDEN = $0002);
    PDWRITE_FONT_AXIS_ATTRIBUTES = ^TDWRITE_FONT_AXIS_ATTRIBUTES;


    IDWriteFactory6 = interface(IDWriteFactory5)
        ['{F3744D80-21F7-42EB-B35D-995BC72FC223}']
        function CreateFontFaceReference(fontFile: IDWriteFontFile; faceIndex: UINT32; fontSimulations: TDWRITE_FONT_SIMULATIONS;
            const fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: UINT32;
            out fontFaceReference: IDWriteFontFaceReference1): HResult; stdcall;
        function CreateFontResource(fontFile: IDWriteFontFile; faceIndex: UINT32; out fontResource: IDWriteFontResource): HResult; stdcall;
        function GetSystemFontSet(includeDownloadableFonts: boolean; out fontSet: IDWriteFontSet1): HResult; stdcall;
        function GetSystemFontCollection(includeDownloadableFonts: boolean; fontFamilyModel: TDWRITE_FONT_FAMILY_MODEL;
            out fontCollection: IDWriteFontCollection2): HResult; stdcall;
        function CreateFontCollectionFromFontSet(fontSet: IDWriteFontSet; fontFamilyModel: TDWRITE_FONT_FAMILY_MODEL;
            out fontCollection: IDWriteFontCollection2): HResult; stdcall;
        function CreateFontSetBuilder(out fontSetBuilder: IDWriteFontSetBuilder2): HResult; stdcall;
        function CreateTextFormat(const fontFamilyName: PWideChar; fontCollection: IDWriteFontCollection;
            const fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: UINT32; fontSize: single;
            const localeName: PWideChar; out textFormat: IDWriteTextFormat3): HResult; stdcall;
    end;



    IDWriteFontFace5 = interface(IDWriteFontFace4)
        ['{98EFF3A5-B667-479A-B145-E2FA5B9FDC29}']
        function GetFontAxisValueCount(): UINT32; stdcall;
        function GetFontAxisValues(out fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: UINT32): HResult; stdcall;
        function HasVariations(): boolean; stdcall;
        function GetFontResource(out fontResource: IDWriteFontResource): HResult; stdcall;
        function Equals(fontFace: IDWriteFontFace): boolean; stdcall;
    end;


    IDWriteFontResource = interface(IUnknown)
        ['{1F803A76-6871-48E8-987F-B975551C50F2}']
        function GetFontFile(out fontFile: IDWriteFontFile): HResult; stdcall;
        function GetFontFaceIndex(): UINT32; stdcall;
        function GetFontAxisCount(): UINT32; stdcall;
        function GetDefaultFontAxisValues(out fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: UINT32): HResult; stdcall;
        function GetFontAxisRanges(out fontAxisRanges: PDWRITE_FONT_AXIS_RANGE; fontAxisRangeCount: UINT32): HResult; stdcall;
        function GetFontAxisAttributes(axisIndex: UINT32): TDWRITE_FONT_AXIS_ATTRIBUTES; stdcall;
        function GetAxisNames(axisIndex: UINT32; out names: IDWriteLocalizedStrings): HResult; stdcall;
        function GetAxisValueNameCount(axisIndex: UINT32): UINT32; stdcall;
        function GetAxisValueNames(axisIndex: UINT32; axisValueIndex: UINT32; out fontAxisRange: TDWRITE_FONT_AXIS_RANGE;
            out names: IDWriteLocalizedStrings): HResult; stdcall;
        function HasVariations(): boolean; stdcall;
        function CreateFontFace(fontSimulations: TDWRITE_FONT_SIMULATIONS; const fontAxisValues: PDWRITE_FONT_AXIS_VALUE;
            fontAxisValueCount: UINT32; out fontFace: IDWriteFontFace5): HResult; stdcall;
        function CreateFontFaceReference(fontSimulations: TDWRITE_FONT_SIMULATIONS; const fontAxisValues: PDWRITE_FONT_AXIS_VALUE;
            fontAxisValueCount: UINT32; out fontFaceReference: IDWriteFontFaceReference1): HResult; stdcall;
    end;



    IDWriteFontFaceReference1 = interface(IDWriteFontFaceReference)
        ['{C081FE77-2FD1-41AC-A5A3-34983C4BA61A}']
        function CreateFontFace(out fontFace: IDWriteFontFace5): HResult; stdcall;
        function GetFontAxisValueCount(): UINT32; stdcall;
        function GetFontAxisValues(out fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: UINT32): HResult; stdcall;
    end;


    IDWriteFontSetBuilder2 = interface(IDWriteFontSetBuilder1)
        ['{EE5BA612-B131-463C-8F4F-3189B9401E45}']
        function AddFont(fontFile: IDWriteFontFile; fontFaceIndex: UINT32; fontSimulations: TDWRITE_FONT_SIMULATIONS;
            const fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: UINT32; const fontAxisRanges: PDWRITE_FONT_AXIS_RANGE;
            fontAxisRangeCount: UINT32; const properties: PDWRITE_FONT_PROPERTY; propertyCount: UINT32): HResult; stdcall;
        function AddFontFile(const filePath: PWideChar): HResult; stdcall;
    end;


    IDWriteFontSet1 = interface(IDWriteFontSet)
        ['{7E9FDA85-6C92-4053-BC47-7AE3530DB4D3}']
        function GetMatchingFonts(const fontProperty: TDWRITE_FONT_PROPERTY; const fontAxisValues: PDWRITE_FONT_AXIS_VALUE;
            fontAxisValueCount: UINT32; out matchingFonts: IDWriteFontSet1): HResult; stdcall;
        function GetFirstFontResources(out filteredFontSet: IDWriteFontSet1): HResult; stdcall;
        function GetFilteredFonts(const properties: PDWRITE_FONT_PROPERTY; propertyCount: UINT32;
            selectAnyProperty: boolean; out filteredFontSet: IDWriteFontSet1): HResult; stdcall; overload;
        function GetFilteredFonts(const fontAxisRanges: PDWRITE_FONT_AXIS_RANGE; fontAxisRangeCount: UINT32;
            selectAnyRange: boolean; out filteredFontSet: IDWriteFontSet1): HResult; stdcall; overload;
        function GetFilteredFonts(const indices: PUINT32; indexCount: UINT32; out filteredFontSet: IDWriteFontSet1): HResult; stdcall; overload;
        function GetFilteredFontIndices(const properties: PDWRITE_FONT_PROPERTY; propertyCount: UINT32;
            selectAnyProperty: boolean; out indices: PUINT32; maxIndexCount: UINT32; out actualIndexCount: UINT32): HResult;
            stdcall; overload;
        function GetFilteredFontIndices(const fontAxisRanges: PDWRITE_FONT_AXIS_RANGE; fontAxisRangeCount: UINT32;
            selectAnyRange: boolean; out indices: PUINT32; maxIndexCount: UINT32; out actualIndexCount: UINT32): HResult;
            stdcall; overload;
        function GetFontAxisRanges(out fontAxisRanges: PDWRITE_FONT_AXIS_RANGE; maxFontAxisRangeCount: UINT32;
            out actualFontAxisRangeCount: UINT32): HResult; stdcall; overload;
        function GetFontAxisRanges(listIndex: UINT32; out fontAxisRanges: PDWRITE_FONT_AXIS_RANGE;
            maxFontAxisRangeCount: UINT32; out actualFontAxisRangeCount: UINT32): HResult; stdcall; overload;
        function GetFontFaceReference(listIndex: UINT32; out fontFaceReference: IDWriteFontFaceReference1): HResult; stdcall;
        function CreateFontResource(listIndex: UINT32; out fontResource: IDWriteFontResource): HResult; stdcall;
        function CreateFontFace(listIndex: UINT32; out fontFace: IDWriteFontFace5): HResult; stdcall;
        function GetFontLocality(listIndex: UINT32): TDWRITE_LOCALITY; stdcall;
    end;


    IDWriteFontList2 = interface(IDWriteFontList1)
        ['{C0763A34-77AF-445A-B735-08C37B0A5BF5}']
        function GetFontSet(out fontSet: IDWriteFontSet1): HResult; stdcall;
    end;


    IDWriteFontFamily2 = interface(IDWriteFontFamily1)
        ['{3ED49E77-A398-4261-B9CF-C126C2131EF3}']
        function GetMatchingFonts(const fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: UINT32;
            out matchingFonts: IDWriteFontList2): HResult; stdcall;
        function GetFontSet(out fontSet: IDWriteFontSet1): HResult; stdcall;
    end;


    IDWriteFontCollection2 = interface(IDWriteFontCollection1)
        ['{514039C6-4617-4064-BF8B-92EA83E506E0}']
        function GetFontFamily(index: UINT32; out fontFamily: IDWriteFontFamily2): HResult; stdcall;
        function GetMatchingFonts(const familyName: PWideChar; const fontAxisValues: PDWRITE_FONT_AXIS_VALUE;
            fontAxisValueCount: UINT32; out fontList: IDWriteFontList2): HResult; stdcall;
        function GetFontFamilyModel(): TDWRITE_FONT_FAMILY_MODEL; stdcall;
        function GetFontSet(out fontSet: IDWriteFontSet1): HResult; stdcall;
    end;


    IDWriteTextLayout4 = interface(IDWriteTextLayout3)
        ['{05A9BF42-223F-4441-B5FB-8263685F55E9}']
        function SetFontAxisValues(const fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: UINT32;
            textRange: TDWRITE_TEXT_RANGE): HResult; stdcall;
        function GetFontAxisValueCount(currentPosition: UINT32): UINT32; stdcall;
        function GetFontAxisValues(currentPosition: UINT32; out fontAxisValues: PDWRITE_FONT_AXIS_VALUE;
            fontAxisValueCount: UINT32; out textRange: TDWRITE_TEXT_RANGE): HResult; stdcall;
        function GetAutomaticFontAxes(): TDWRITE_AUTOMATIC_FONT_AXES; stdcall;
        function SetAutomaticFontAxes(automaticFontAxes: TDWRITE_AUTOMATIC_FONT_AXES): HResult; stdcall;
    end;


    IDWriteTextFormat3 = interface(IDWriteTextFormat2)
        ['{6D3B5641-E550-430D-A85B-B7BF48A93427}']
        function SetFontAxisValues(const fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: UINT32): HResult; stdcall;
        function GetFontAxisValueCount(): UINT32; stdcall;
        function GetFontAxisValues(out fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: UINT32): HResult; stdcall;
        function GetAutomaticFontAxes(): TDWRITE_AUTOMATIC_FONT_AXES; stdcall;
        function SetAutomaticFontAxes(automaticFontAxes: TDWRITE_AUTOMATIC_FONT_AXES): HResult; stdcall;
    end;


    IDWriteFontFallback1 = interface(IDWriteFontFallback)
        ['{2397599D-DD0D-4681-BD6A-F4F31EAADE77}']
        function MapCharacters(analysisSource: IDWriteTextAnalysisSource; textPosition: UINT32; textLength: UINT32;
            baseFontCollection: IDWriteFontCollection; const baseFamilyName: PWideChar; const fontAxisValues: PDWRITE_FONT_AXIS_VALUE;
            fontAxisValueCount: UINT32; out mappedLength: UINT32; out scale: single; out mappedFontFace: IDWriteFontFace5): HResult; stdcall;
    end;

    //{$endif} // NTDDI_VERSION >= NTDDI_WIN10_RS3

    //{$if NTDDI_VERSION >= NTDDI_WIN10_RS4}

    IDWriteFontSet2 = interface(IDWriteFontSet1)
        ['{DC7EAD19-E54C-43AF-B2DA-4E2B79BA3F7F}']
        function GetExpirationEvent(): THANDLE; stdcall;
    end;



    IDWriteFontCollection3 = interface(IDWriteFontCollection2)
        ['{A4D055A6-F9E3-4E25-93B7-9E309F3AF8E9}']
        function GetExpirationEvent(): THANDLE; stdcall;
    end;



    IDWriteFactory7 = interface(IDWriteFactory6)
        ['{35D0E0B3-9076-4D2E-A016-A91B568A06B4}']
        function GetSystemFontSet(includeDownloadableFonts: boolean; out fontSet: IDWriteFontSet2): HResult; stdcall;
        function GetSystemFontCollection(includeDownloadableFonts: boolean; fontFamilyModel: TDWRITE_FONT_FAMILY_MODEL;
            out fontCollection: IDWriteFontCollection3): HResult; stdcall;
    end;


//{$endif} // NTDDI_VERSION >= NTDDI_WIN10_RS4


implementation

end.
