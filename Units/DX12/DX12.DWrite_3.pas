{ **************************************************************************
    FreePascal/Delphi DirectX 12 Header Files

    Copyright (C) 2013-2025 Norbert Sonnleitner

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
 
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
************************************************************************** }

{ **************************************************************************
   Additional Copyright (C) for this modul:
   
  Copyright (c) Microsoft Corporation.  All rights reserved.
  Abstract:
      DirectX Typography Services public API definitions.        
      
   This unit consists of the following header files
   File name: dwrite_3.h
   Header version: 10.0.26100.6584
   
  ************************************************************************** }
unit DX12.DWrite_3;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch typehelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D2D1,
    DX12.DCommon,
    DX12.DWrite,
    DX12.DWrite_1,
    DX12.DWrite_2;

    {$Z4}

const
    DWRITE_E_REMOTEFONT = HRESULT($8898500D);
    DWRITE_E_DOWNLOADCANCELLED = HRESULT ($8898500E);
    DWRITE_E_DOWNLOADFAILED= HRESULT  ($8898500F);
    DWRITE_E_TOOMANYDOWNLOADS= HRESULT($88985010);

    DWRITE_STANDARD_FONT_AXIS_COUNT = 5;

type

    TUUID = TGUID;
    PUUID = ^TUUID;

    IDWriteFontFaceReference = interface;
    IDWriteFont3 = interface;


    IDWriteFontFace3 = interface;


    IDWriteFontSet = interface;


    IDWriteFontSetBuilder = interface;


    IDWriteFontCollection1 = interface;


    IDWriteFontFamily1 = interface;


    IDWriteStringList = interface;


    IDWriteFontDownloadQueue = interface;

    /// The font property enumeration identifies a string in a font.
    TDWRITE_FONT_PROPERTY_ID = (
        /// Unspecified font property identifier.
        DWRITE_FONT_PROPERTY_ID_NONE,
        /// Family name for the weight-stretch-style model.
        DWRITE_FONT_PROPERTY_ID_WEIGHT_STRETCH_STYLE_FAMILY_NAME,
        /// Family name preferred by the designer. This enables font designers to group more than four fonts in a single family without losing compatibility with
        /// GDI. This name is typically only present if it differs from the GDI-compatible family name.
        DWRITE_FONT_PROPERTY_ID_TYPOGRAPHIC_FAMILY_NAME,
        /// Face name of the for the weight-stretch-style (e.g., Regular or Bold).
        DWRITE_FONT_PROPERTY_ID_WEIGHT_STRETCH_STYLE_FACE_NAME,
        /// The full name of the font, e.g. "Arial Bold", from name id 4 in the name table.
        DWRITE_FONT_PROPERTY_ID_FULL_NAME,
        /// GDI-compatible family name. Because GDI allows a maximum of four fonts per family, fonts in the same family may have different GDI-compatible family names
        /// (e.g., "Arial", "Arial Narrow", "Arial Black").
        DWRITE_FONT_PROPERTY_ID_WIN32_FAMILY_NAME,
        /// The postscript name of the font, e.g. "GillSans-Bold" from name id 6 in the name table.
        DWRITE_FONT_PROPERTY_ID_POSTSCRIPT_NAME,
        /// Script/language tag to identify the scripts or languages that the font was
        /// primarily designed to support.
        /// <remarks>
        /// The design script/language tag is meant to be understood from the perspective of
        /// users. For example, a font is considered designed for English if it is considered
        /// useful for English users. Note that this is different from what a font might be
        /// capable of supporting. For example, the Meiryo font was primarily designed for
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
        ///
        /// When passing this property to GetPropertyValues, use the overload which does
        /// not take a language parameter, since this property has no specific language.
        /// </remarks>
        DWRITE_FONT_PROPERTY_ID_DESIGN_SCRIPT_LANGUAGE_TAG,
        /// Script/language tag to identify the scripts or languages that the font declares
        /// it is able to support.
        DWRITE_FONT_PROPERTY_ID_SUPPORTED_SCRIPT_LANGUAGE_TAG,
        /// Semantic tag to describe the font (e.g. Fancy, Decorative, Handmade, Sans-serif, Swiss, Pixel, Futuristic).
        DWRITE_FONT_PROPERTY_ID_SEMANTIC_TAG,
        /// Weight of the font represented as a decimal string in the range 1-999.
        /// <remark>
        /// This enum is discouraged for use with IDWriteFontSetBuilder2 in favor of the more generic font axis
        /// DWRITE_FONT_AXIS_TAG_WEIGHT which supports higher precision and range.
        /// </remark>
        DWRITE_FONT_PROPERTY_ID_WEIGHT,
        /// Stretch of the font represented as a decimal string in the range 1-9.
        /// <remark>
        /// This enum is discouraged for use with IDWriteFontSetBuilder2 in favor of the more generic font axis
        /// DWRITE_FONT_AXIS_TAG_WIDTH which supports higher precision and range.
        /// </remark>
        DWRITE_FONT_PROPERTY_ID_STRETCH,
        /// Style of the font represented as a decimal string in the range 0-2.
        /// <remark>
        /// This enum is discouraged for use with IDWriteFontSetBuilder2 in favor of the more generic font axes
        /// DWRITE_FONT_AXIS_TAG_SLANT and DWRITE_FONT_AXIS_TAG_ITAL.
        /// </remark>
        DWRITE_FONT_PROPERTY_ID_STYLE,
        /// Face name preferred by the designer. This enables font designers to group more than four fonts in a single
        /// family without losing compatibility with GDI.
        DWRITE_FONT_PROPERTY_ID_TYPOGRAPHIC_FACE_NAME,
        /// Total number of properties for NTDDI_WIN10 (IDWriteFontSet).
        /// <remarks>
        /// DWRITE_FONT_PROPERTY_ID_TOTAL cannot be used as a property ID.
        /// </remarks>
        DWRITE_FONT_PROPERTY_ID_TOTAL = DWRITE_FONT_PROPERTY_ID_STYLE + 1,
        /// Total number of properties for NTDDI_WIN10_RS3 (IDWriteFontSet1).
        DWRITE_FONT_PROPERTY_ID_TOTAL_RS3 = DWRITE_FONT_PROPERTY_ID_TYPOGRAPHIC_FACE_NAME + 1,
        // Obsolete aliases kept to avoid breaking existing code.
        DWRITE_FONT_PROPERTY_ID_PREFERRED_FAMILY_NAME = DWRITE_FONT_PROPERTY_ID_TYPOGRAPHIC_FAMILY_NAME,
        DWRITE_FONT_PROPERTY_ID_FAMILY_NAME = DWRITE_FONT_PROPERTY_ID_WEIGHT_STRETCH_STYLE_FAMILY_NAME,
        DWRITE_FONT_PROPERTY_ID_FACE_NAME = DWRITE_FONT_PROPERTY_ID_WEIGHT_STRETCH_STYLE_FACE_NAME
        );

    PDWRITE_FONT_PROPERTY_ID = ^TDWRITE_FONT_PROPERTY_ID;

    /// Font property used for filtering font sets and
    /// building a font set with explicit properties.
    TDWRITE_FONT_PROPERTY = record
        /// Specifies the requested font property, such as DWRITE_FONT_PROPERTY_ID_FAMILY_NAME.
        propertyId: TDWRITE_FONT_PROPERTY_ID;
        /// Specifies the property value, such as "Segoe UI".
        {_Field_z_} propertyValue: PWCHAR;
        /// Specifies the language / locale to use, such as "en-US".
        /// <remarks>
        /// When passing property information to AddFontFaceReference, localeName indicates
        /// the language of the property value. BCP 47 language tags should be used. If a
        /// property value is inherently non-linguistic, this can be left empty.
        ///
        /// When used for font set filtering, leave this empty: a match will be found
        /// regardless of language associated with property values.
        /// </remarks>
        {_Field_z_ _Maybenull_}  localeName: PWCHAR;
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
        DWRITE_LOCALITY_LOCAL
        );

    PDWRITE_LOCALITY = ^TDWRITE_LOCALITY;

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
        DWRITE_RENDERING_MODE1_NATURAL_SYMMETRIC_DOWNSAMPLED
        );

    PDWRITE_RENDERING_MODE1 = ^TDWRITE_RENDERING_MODE1;

    /// The interface that represents text rendering settings for glyph rasterization and filtering.
    IDWriteRenderingParams3 = interface(IDWriteRenderingParams2)
        ['{B7924BAA-391B-412A-8C5C-E44CC2D867DC}']
        /// Gets the rendering mode.
        function GetRenderingMode1(): TDWRITE_RENDERING_MODE1; stdcall;

    end;

    /// The root factory interface for all DWrite objects.
    IDWriteFactory3 = interface(IDWriteFactory2)
        ['{9A1B41C3-D3BB-466A-87FC-FE67556A3B65}']
        /// Creates a glyph run analysis object, which encapsulates information
        /// used to render a glyph run.
        /// <param name="glyphRun">Structure specifying the properties of the glyph run.</param>
        /// <param name="transform">Optional transform applied to the glyphs and their positions. This transform is applied after the
        /// scaling specified by the emSize.</param>
        /// <param name="renderingMode">Specifies the rendering mode, which must be one of the raster rendering modes (i.e., not default
        /// and not outline).</param>
        /// <param name="measuringMode">Specifies the method to measure glyphs.</param>
        /// <param name="gridFitMode">How to grid-fit glyph outlines. This must be non-default.</param>
        /// <param name="baselineOriginX">Horizontal position of the baseline origin, in DIPs.</param>
        /// <param name="baselineOriginY">Vertical position of the baseline origin, in DIPs.</param>
        /// <param name="glyphRunAnalysis">Receives a pointer to the newly created object.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function CreateGlyphRunAnalysis(
        {_In_} glyphRun: PDWRITE_GLYPH_RUN;
        {_In_opt_} transform: PDWRITE_MATRIX; renderingMode: TDWRITE_RENDERING_MODE1; measuringMode: TDWRITE_MEASURING_MODE; gridFitMode: TDWRITE_GRID_FIT_MODE; antialiasMode: TDWRITE_TEXT_ANTIALIAS_MODE;
            baselineOriginX: single; baselineOriginY: single;
        {_COM_Outptr_}  out glyphRunAnalysis: IDWriteGlyphRunAnalysis): HRESULT; stdcall;

        /// Creates a rendering parameters object with the specified properties.
        /// <param name="gamma">The gamma value used for gamma correction, which must be greater than zero and cannot exceed 256.</param>
        /// <param name="enhancedContrast">The amount of contrast enhancement, zero or greater.</param>
        /// <param name="grayscaleEnhancedContrast">The amount of contrast enhancement to use for grayscale antialiasing, zero or greater.</param>
        /// <param name="clearTypeLevel">The degree of ClearType level, from 0.0f (no ClearType) to 1.0f (full ClearType).</param>
        /// <param name="pixelGeometry">The geometry of a device pixel.</param>
        /// <param name="renderingMode">Method of rendering glyphs. In most cases, this should be DWRITE_RENDERING_MODE_DEFAULT to automatically use an appropriate mode.</param>
        /// <param name="gridFitMode">How to grid fit glyph outlines. In most cases, this should be DWRITE_GRID_FIT_DEFAULT to automatically choose an appropriate mode.</param>
        /// <param name="renderingParams">Receives a pointer to the newly created rendering parameters object, or NULL in case of failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function CreateCustomRenderingParams(gamma: single; enhancedContrast: single; grayscaleEnhancedContrast: single; clearTypeLevel: single; pixelGeometry: TDWRITE_PIXEL_GEOMETRY;
            renderingMode: TDWRITE_RENDERING_MODE1; gridFitMode: TDWRITE_GRID_FIT_MODE;
        {_COM_Outptr_}  out renderingParams: IDWriteRenderingParams3): HRESULT; stdcall;

        /// Creates a reference to a font given a full path.
        /// <param name="filePath">Absolute file path. Subsequent operations on the constructed object may fail
        ///     if the user provided filePath doesn't correspond to a valid file on the disk.</param>
        /// <param name="lastWriteTime">Last modified time of the input file path. If the parameter is omitted,
        ///     the function will access the font file to obtain its last write time, so the clients are encouraged to specify this value
        ///     to avoid extra disk access. Subsequent operations on the constructed object may fail
        ///     if the user provided lastWriteTime doesn't match the file on the disk.</param>
        /// <param name="faceIndex">The zero based index of a font face in cases when the font files contain a collection of font faces.
        ///     If the font files contain a single face, this value should be zero.</param>
        /// <param name="fontSimulations">Font face simulation flags for algorithmic emboldening and italicization.</param>
        /// <param name="fontFaceReference">Receives a pointer to the newly created font face reference object, or nullptr in case of failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function CreateFontFaceReference(
        {_In_z_} filePath: PWCHAR;
        {_In_opt_} lastWriteTime: PFILETIME; faceIndex: uint32; fontSimulations: TDWRITE_FONT_SIMULATIONS;
        {_COM_Outptr_}  out fontFaceReference: IDWriteFontFaceReference): HRESULT; stdcall; overload;

        /// Creates a reference to a font given a file.
        /// <param name="fontFile">User provided font file representing the font face.</param>
        /// <param name="faceIndex">The zero based index of a font face in cases when the font files contain a collection of font faces.
        ///     If the font files contain a single face, this value should be zero.</param>
        /// <param name="fontSimulations">Font face simulation flags for algorithmic emboldening and italicization.</param>
        /// <param name="fontFaceReference">Receives a pointer to the newly created font face reference object, or nullptr in case of failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function CreateFontFaceReference(
        {_In_} fontFile: IDWriteFontFile; faceIndex: uint32; fontSimulations: TDWRITE_FONT_SIMULATIONS;
        {_COM_Outptr_}  out fontFaceReference: IDWriteFontFaceReference): HRESULT; stdcall; overload;

        /// Retrieves the list of system fonts.
        /// <param name="fontSet">Receives a pointer to the font set object, or nullptr in case of failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetSystemFontSet(
        {_COM_Outptr_}  out fontSet: IDWriteFontSet): HRESULT; stdcall;

        /// Creates an empty font set builder to add font face references
        /// and create a custom font set.
        /// <param name="fontSetBuilder">Receives a pointer to the newly created font set builder object, or nullptr in case of failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function CreateFontSetBuilder(
        {_COM_Outptr_}  out fontSetBuilder: IDWriteFontSetBuilder): HRESULT; stdcall;

        /// Create a weight-stretch-style based collection of families (DWRITE_FONT_FAMILY_MODEL_WEIGHT_STRETCH_STYLE)
        /// from a set of fonts.
        /// <param name="fontSet">A set of fonts to use to build the collection.</param>
        /// <param name="fontCollection">Receives a pointer to the newly created font collection object, or nullptr in case of failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function CreateFontCollectionFromFontSet(fontSet: IDWriteFontSet;
        {_COM_Outptr_}  out fontCollection: IDWriteFontCollection1): HRESULT; stdcall;

        /// Retrieves a weight-stretch-style based collection of font families.
        /// <param name="includeDownloadableFonts">Include downloadable fonts or only locally installed ones.</param>
        /// <param name="fontCollection">Receives a pointer to the newly created font collection object, or nullptr in
        ///     case of failure.</param>
        /// <param name="checkForUpdates">If this parameter is nonzero, the function performs an immediate check for changes
        ///     to the set of system fonts. If this parameter is FALSE, the function will still detect changes if the font
        ///     cache service is running, but there may be some latency. For example, an application might specify TRUE if
        ///     it has itself just installed a font and wants to be sure the font collection contains that font.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetSystemFontCollection(includeDownloadableFonts: boolean;
        {_COM_Outptr_}  out fontCollection: IDWriteFontCollection1; checkForUpdates: boolean = False): HRESULT; stdcall;

        /// Gets the font download queue associated with this factory object.
        /// <param name="IDWriteFontDownloadQueue">Receives a pointer to the font download queue interface.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFontDownloadQueue(
        {_COM_Outptr_}  out fontDownloadQueue: IDWriteFontDownloadQueue): HRESULT; stdcall;

    end;

    /// Set of fonts used for creating font faces, selecting nearest matching fonts, and filtering.
    /// Unlike IDWriteFontFamily and IDWriteFontList, which are part of the IDWriteFontCollection heirarchy, font sets
    /// are unordered flat lists.
    IDWriteFontSet = interface(IUnknown)
        ['{53585141-D9F8-4095-8321-D73CF6BD116B}']
        /// Get the number of total fonts in the set.
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFontCount(): uint32; stdcall;

        /// Get a reference to the font at this index, which may be local or remote.
        /// <param name="listIndex">Zero-based index of the font.</param>
        /// <param name="fontFaceReference">Receives a pointer the font face reference object, or nullptr on failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFontFaceReference(listIndex: uint32;
        {_COM_Outptr_}  out fontFaceReference: IDWriteFontFaceReference): HRESULT; stdcall;

        /// Gets the index of the matching font face reference in the font set, with the same file, face index, and simulations.
        /// <param name="fontFaceReference">Font face reference object that specifies the physical font.</param>
        /// <param name="listIndex">Receives the zero-based index of the matching font if the font was found, or UINT_MAX otherwise.</param>
        /// <param name="exists">Receives TRUE if the font exists or FALSE otherwise.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function FindFontFaceReference(fontFaceReference: IDWriteFontFaceReference;
        {_Out_} listIndex: PUINT32;
        {_Out_} exists: Pboolean): HRESULT; stdcall;

        /// Gets the index of the matching font face reference in the font set, with the same file, face index, and simulations.
        /// <param name="fontFaceReference">Font face object that specifies the physical font.</param>
        /// <param name="listIndex">Receives the zero-based index of the matching font if the font was found, or UINT_MAX otherwise.</param>
        /// <param name="exists">Receives TRUE if the font exists or FALSE otherwise.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function FindFontFace(fontFace: IDWriteFontFace;
        {_Out_} listIndex: PUINT32;
        {_Out_} exists: Pboolean): HRESULT; stdcall;

        /// Returns the property values of a specific font item index.
        /// <param name="listIndex">Zero-based index of the font.</param>
        /// <param name="propertyID">Font property of interest.</param>
        /// <param name="exists">Receives the value TRUE if the font contains the specified property identifier or FALSE if not.</param>
        /// <param name="strings">Receives a pointer to the newly created localized strings object, or nullptr on failure or non-existent property.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetPropertyValues(listIndex: uint32; propertyId: TDWRITE_FONT_PROPERTY_ID;
        {_Out_} exists: Pboolean;
        {_COM_Outptr_result_maybenull_}  out values: IDWriteLocalizedStrings): HRESULT; stdcall; overload;

        /// Returns all unique property values in the set, which can be used
        /// for purposes such as displaying a family list or tag cloud. Values are
        /// returned in priority order according to the language list, such that if
        /// a font contains more than one localized name, the preferred one will be
        /// returned.
        /// <param name="propertyID">Font property of interest.</param>
        /// <param name="preferredLocaleNames">List of semicolon delimited language names in preferred
        ///     order. When a particular string like font family has more than one localized name,
        ///     the first match is returned.</param>
        /// <param name="stringsList">Receives a pointer to the newly created strings list.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// For example, suppose the font set includes the Meiryo family, which has both Japanese and English family names.
        /// The returned list of distinct family names would include either the Japanese name (if "ja-jp" was specified as
        /// a preferred locale) or the English name (in all other cases).
        /// </remarks>
        function GetPropertyValues(propertyID: TDWRITE_FONT_PROPERTY_ID;
        {_In_z_} preferredLocaleNames: PWCHAR;
        {_COM_Outptr_}  out values: IDWriteStringList): HRESULT; stdcall; overload;

        /// Returns all unique property values in the set, which can be used
        /// for purposes such as displaying a family list or tag cloud. All values
        /// are returned regardless of language, including all localized names.
        /// <param name="propertyID">Font property of interest.</param>
        /// <param name="stringsList">Receives a pointer to the newly created strings list.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// For example, suppose the font set includes the Meiryo family, which has both Japanese and English family names.
        /// The returned list of distinct family names would include both the Japanese and English names.
        /// </remarks>
        function GetPropertyValues(propertyID: TDWRITE_FONT_PROPERTY_ID;
        {_COM_Outptr_}  out values: IDWriteStringList): HRESULT; stdcall; overload;

        /// Returns how many times a given property value occurs in the set.
        /// <param name="property">Font property of interest.</param>
        /// <param name="propertyOccurrenceCount">How many times that property occurs.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// For example, the family name "Segoe UI" may return a count of 12,
        /// whereas Harrington only has 1.
        /// </remarks>
        function GetPropertyOccurrenceCount(
        {_In_} _property: PDWRITE_FONT_PROPERTY;
        {_Out_} propertyOccurrenceCount: PUINT32): HRESULT; stdcall;

        /// Returns a subset of fonts filtered by the given properties.
        /// <param name="properties">List of properties to filter using.</param>
        /// <param name="propertyCount">How many properties to filter.</param>
        /// <param name="filteredSet">Subset of fonts that match the properties,
        ///     or nullptr on failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// If no fonts matched the filter, the subset will be empty (GetFontCount
        /// returns 0), but the function does not return an error. The subset will
        /// always be equal to or less than the original set.
        /// </remarks>
        function GetMatchingFonts(
        {_In_reads_(propertyCount)} properties: PDWRITE_FONT_PROPERTY; propertyCount: uint32;
        {_COM_Outptr_}  out filteredSet: IDWriteFontSet): HRESULT; stdcall; overload;

        /// Returns a list of fonts within the given WWS family prioritized by
        /// WWS distance.
        /// <param name="familyName">Neutral or localized family name of font.</param>
        /// <param name="fontWeight">Weight of font.</param>
        /// <param name="fontStretch">Stretch of font.</param>
        /// <param name="fontStyle">Slope of font.</param>
        /// <param name="filteredSet">Subset of fonts that match the properties,
        ///     or nullptr on failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// The returned list can include simulated bold and oblique variants,
        /// which would be useful for font fallback selection.
        /// </remarks>
        function GetMatchingFonts(
        {_In_z_} familyName: PWCHAR; fontWeight: TDWRITE_FONT_WEIGHT; fontStretch: TDWRITE_FONT_STRETCH; fontStyle: TDWRITE_FONT_STYLE;
        {_COM_Outptr_}  out filteredSet: IDWriteFontSet): HRESULT; stdcall; overload;

    end;

    /// Builder interface to add font face references and create a font set.
    IDWriteFontSetBuilder = interface(IUnknown)
        ['{2F642AFE-9C68-4F40-B8BE-457401AFCB3D}']
        /// Adds a reference to a font to the set being built. The necessary
        /// metadata will automatically be extracted from the font upon calling
        /// CreateFontSet.
        /// <param name="fontFaceReference">Font face reference object to add to the set.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function AddFontFaceReference(
        {_In_} fontFaceReference: IDWriteFontFaceReference): HRESULT; stdcall; overload;

        /// Adds a reference to a font to the set being built. The caller
        /// supplies enough information to search on, avoiding the need to open
        /// the potentially non-local font. Any properties not supplied by the
        /// caller will be missing, and those properties will not be available as
        /// filters in GetMatchingFonts. GetPropertyValues for missing properties
        /// will return an empty string list. The properties passed should generally
        /// be consistent with the actual font contents, but they need not be. You
        /// could, for example, alias a font using a different name or unique
        /// identifier, or you could set custom tags not present in the actual
        /// font.
        /// <param name="fontFaceReference">Reference to the font.</param>
        /// <param name="properties">List of properties to associate with the reference.</param>
        /// <param name="propertyCount">How many properties are defined.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function AddFontFaceReference(
        {_In_} fontFaceReference: IDWriteFontFaceReference;
        {_In_reads_(propertyCount)} properties: PDWRITE_FONT_PROPERTY; propertyCount: uint32): HRESULT; stdcall; overload;

        /// Appends an existing font set to the one being built, allowing
        /// one to aggregate two sets or to essentially extend an existing one.
        /// <param name="fontSet">Font set to append font face references from.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function AddFontSet(
        {_In_} fontSet: IDWriteFontSet): HRESULT; stdcall;

        /// Creates a font set from all the font face references added so
        /// far via AddFontFaceReference.
        /// <param name="fontSet">Receives a pointer to the newly created font set object, or nullptr in case of failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// Creating a font set takes less time if the references were added
        /// with metadata rather than needing to extract the metadata from the
        /// font file.
        /// </remarks>
        function CreateFontSet(
        {_COM_Outptr_}  out fontSet: IDWriteFontSet): HRESULT; stdcall;

    end;

    IDWriteFontCollection1 = interface(IDWriteFontCollection)
        ['{53585141-D9F8-4095-8321-D73CF6BD116C}']
        /// Get the underlying font set used by this collection.
        /// <param name="fontSet">Contains font set used by the collection.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFontSet(
        {_COM_Outptr_}  out fontSet: IDWriteFontSet): HRESULT; stdcall;

        /// Creates a font family object given a zero-based font family index.
        /// <param name="index">Zero-based index of the font family.</param>
        /// <param name="fontFamily">Receives a pointer the newly created font family object.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFontFamily(index: uint32;
        {_COM_Outptr_}  out fontFamily: IDWriteFontFamily1): HRESULT; stdcall;

    end;

    /// The IDWriteFontFamily interface represents a set of fonts that share the same design but are differentiated
    /// by weight, stretch, and style.
    IDWriteFontFamily1 = interface(IDWriteFontFamily)
        ['{DA20D8EF-812A-4C43-9802-62EC4ABD7ADF}']
        /// Gets the current locality of a font given its zero-based index.
        /// <param name="listIndex">Zero-based index of the font in the font list.</param>
        /// <remarks>
        /// The locality enumeration. For fully local files, the result will always
        /// be DWRITE_LOCALITY_LOCAL. For downloadable files, the result depends on how
        /// much of the file has been downloaded, and GetFont() fails if the locality
        /// is REMOTE and potentially fails if PARTIAL. The application can explicitly
        /// ask for the font to be enqueued for download via EnqueueFontDownloadRequest
        /// followed by BeginDownload().
        /// </remarks>
        /// <returns>
        /// The locality enumeration.
        /// </returns>
        function GetFontLocality(listIndex: uint32): TDWRITE_LOCALITY; stdcall;

        /// Gets a font given its zero-based index.
        /// <param name="listIndex">Zero-based index of the font in the font list.</param>
        /// <param name="font">Receives a pointer to the newly created font object.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFont(listIndex: uint32;
        {_COM_Outptr_}  out font: IDWriteFont3): HRESULT; stdcall;

        /// Gets a font face reference given its zero-based index.
        /// <param name="listIndex">Zero-based index of the font in the font list.</param>
        /// <param name="fontFaceReference">Receives a pointer to the newly created font face reference object.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFontFaceReference(listIndex: uint32;
        {_COM_Outptr_}  out fontFaceReference: IDWriteFontFaceReference): HRESULT; stdcall;

    end;

    /// The IDWriteFontList interface represents a list of fonts.
    IDWriteFontList1 = interface(IDWriteFontList)
        ['{DA20D8EF-812A-4C43-9802-62EC4ABD7ADE}']
        /// Gets the current locality of a font given its zero-based index.
        /// <param name="listIndex">Zero-based index of the font in the font list.</param>
        /// <remarks>
        /// The locality enumeration. For fully local files, the result will always
        /// be DWRITE_LOCALITY_LOCAL. For downloadable files, the result depends on how
        /// much of the file has been downloaded, and GetFont() fails if the locality
        /// is REMOTE and potentially fails if PARTIAL. The application can explicitly
        /// ask for the font to be enqueued for download via EnqueueFontDownloadRequest
        /// followed by BeginDownload().
        /// </remarks>
        /// <returns>
        /// The locality enumeration.
        /// </returns>
        function GetFontLocality(listIndex: uint32): TDWRITE_LOCALITY; stdcall;

        /// Gets a font given its zero-based index.
        /// <param name="listIndex">Zero-based index of the font in the font list.</param>
        /// <param name="font">Receives a pointer to the newly created font object.</param>
        /// <returns>
        /// Standard HRESULT error code. The function returns DWRITE_E_REMOTEFONT if it could not construct a remote font.
        /// </returns>
        function GetFont(listIndex: uint32;
        {_COM_Outptr_}  out font: IDWriteFont3): HRESULT; stdcall;

        /// Gets a font face reference given its zero-based index.
        /// <param name="listIndex">Zero-based index of the font in the font list.</param>
        /// <param name="fontFaceReference">Receives a pointer to the newly created font face reference object.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFontFaceReference(listIndex: uint32;
        {_COM_Outptr_}  out fontFaceReference: IDWriteFontFaceReference): HRESULT; stdcall;

    end;

    /// A uniquely identifying reference to a font, from which you can create a font
    /// face to query font metrics and use for rendering. A font face reference
    /// consists of a font file, font face index, and font face simulation. The file
    /// data may or may not be physically present on the local machine yet.
    IDWriteFontFaceReference = interface(IUnknown)
        ['{5E7FA7CA-DDE3-424C-89F0-9FCD6FED58CD}']
        /// Creates a font face from the reference for use with layout,
        /// shaping, or rendering.
        /// <param name="fontFace">Newly created font face object, or nullptr in the case of failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// This function can fail with DWRITE_E_REMOTEFONT if the font is not local.
        /// </remarks>
        function CreateFontFace(
        {_COM_Outptr_}  out fontFace: IDWriteFontFace3): HRESULT; stdcall;

        /// Creates a font face with alternate font simulations, for example, to
        /// explicitly simulate a bold font face out of a regular variant.
        /// <param name="fontFaceSimulationFlags">Font face simulation flags for algorithmic emboldening and italicization.</param>
        /// <param name="fontFace">Newly created font face object, or nullptr in the case of failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// This function can fail with DWRITE_E_REMOTEFONT if the font is not local.
        /// </remarks>
        function CreateFontFaceWithSimulations(fontFaceSimulationFlags: TDWRITE_FONT_SIMULATIONS;
        {_COM_Outptr_}  out fontFace: IDWriteFontFace3): HRESULT; stdcall;

        /// Compares two instances of a font face references for equality.
        function Equals(fontFaceReference: IDWriteFontFaceReference): boolean; stdcall;

        /// Obtains the zero-based index of the font face in its font file. If the font files contain a single face,
        /// the return value is zero.
        function GetFontFaceIndex(): uint32; stdcall;

        /// Obtains the algorithmic style simulation flags of a font face.
        function GetSimulations(): TDWRITE_FONT_SIMULATIONS; stdcall;

        /// Obtains the font file representing a font face.
        function GetFontFile(
        {_COM_Outptr_}  out fontFile: IDWriteFontFile): HRESULT; stdcall;

        /// Get the local size of the font face in bytes.
        /// <remarks>
        /// The value returned by GetLocalFileSize will always be less than or
        /// equal to the value returned by GetFullSize. If the locality is remote,
        /// the GetLocalFileSize value is zero. If the locality is local, this
        /// value will equal the value returned by GetFileSize. If the locality is
        /// partial, this value will equal the size of the portions of the font
        /// data that have been downloaded, which will be greater than zero and
        /// less than or equal to the GetFileSize value.
        /// </remarks>
        function GetLocalFileSize(): uint64; stdcall;

        /// Get the total size of the font face in bytes.
        /// <remarks>
        /// If the locality is remote, this value is unknown and will be zero.
        /// If the locality is partial or local, the value is the full size of
        /// the font face.
        /// </remarks>
        function GetFileSize(): uint64; stdcall;

        /// Get the last modified date.
        /// <remarks>
        /// The time may be zero if the font file loader does not expose file time.
        /// </remarks>
        function GetFileTime(
        {_Out_} lastWriteTime: PFILETIME): HRESULT; stdcall;

        /// Get the locality of this font face reference. You can always successfully
        /// create a font face from a fully local font. Attempting to create a font
        /// face on a remote or partially local font may fail with DWRITE_E_REMOTEFONT.
        /// This function may change between calls depending on background downloads
        /// and whether cached data expires.
        function GetLocality(): TDWRITE_LOCALITY; stdcall;

        /// Adds a request to the font download queue (IDWriteFontDownloadQueue).
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function EnqueueFontDownloadRequest(): HRESULT; stdcall;

        /// Adds a request to the font download queue (IDWriteFontDownloadQueue).
        /// <param name="characters">Array of characters to download.</param>
        /// <param name="characterCount">The number of elements in the character array.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// Downloading a character involves downloading every glyph it depends on
        /// directly or indirectly, via font tables (cmap, GSUB, COLR, glyf).
        /// </remarks>
        function EnqueueCharacterDownloadRequest(
        {_In_reads_(characterCount)} characters: PWCHAR; characterCount: uint32): HRESULT; stdcall;

        /// Adds a request to the font download queue (IDWriteFontDownloadQueue).
        /// <param name="glyphIndices">Array of glyph indices to download.</param>
        /// <param name="glyphCount">The number of elements in the glyph index array.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// Downloading a glyph involves downloading any other glyphs it depends on
        /// from the font tables (GSUB, COLR, glyf).
        /// </remarks>
        function EnqueueGlyphDownloadRequest(
        {_In_reads_(glyphCount)} glyphIndices: PUINT16; glyphCount: uint32): HRESULT; stdcall;

        /// Adds a request to the font download queue (IDWriteFontDownloadQueue).
        /// <param name="fileOffset">Offset of the fragment from the beginning of the font file.</param>
        /// <param name="fragmentSize">Size of the fragment in bytes.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function EnqueueFileFragmentDownloadRequest(fileOffset: uint64; fragmentSize: uint64): HRESULT; stdcall;

    end;

    /// The IDWriteFont interface represents a font in a font collection.
    IDWriteFont3 = interface(IDWriteFont2)
        ['{29748ED6-8C9C-4A6A-BE0B-D912E8538944}']
        /// Creates a font face object for the font.
        /// <param name="fontFace">Receives a pointer to the newly created font face object.</param>
        /// <returns>
        /// Standard HRESULT error code. The function returns DWRITE_E_REMOTEFONT if it could not construct a remote font.
        /// </returns>
        function CreateFontFace(
        {_COM_Outptr_}  out fontFace: IDWriteFontFace3): HRESULT; stdcall;

        /// Compares two instances of a font references for equality.
        function Equals(font: IDWriteFont): boolean; stdcall;

        /// Return a font face reference identifying this font.
        /// <param name="fontFaceReference">A uniquely identifying reference to a font face.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFontFaceReference(
        {_COM_Outptr_}  out fontFaceReference: IDWriteFontFaceReference): HRESULT; stdcall;

        /// Determines whether the font supports the specified character.
        /// <param name="unicodeValue">Unicode (UCS-4) character value.</param>
        /// <returns>
        /// Returns TRUE if the font has the specified character, FALSE if not.
        /// </returns>
        function HasCharacter(unicodeValue: uint32): boolean; stdcall;

        /// Gets the current locality of the font.
        /// <remarks>
        /// The locality enumeration. For fully local files, the result will always
        /// be DWRITE_LOCALITY_LOCAL. A downloadable file may be any of the states,
        /// and this function may change between calls.
        /// </remarks>
        /// <returns>
        /// The locality enumeration.
        /// </returns>
        function GetLocality(): TDWRITE_LOCALITY; stdcall;

    end;

    /// The interface that represents an absolute reference to a font face.
    /// It contains font face type, appropriate file references and face identification data.
    /// Various font data such as metrics, names and glyph outlines is obtained from IDWriteFontFace.
    IDWriteFontFace3 = interface(IDWriteFontFace2)
        ['{D37D7598-09BE-4222-A236-2081341CC1F2}']
        /// Return a font face reference identifying this font.
        /// <param name="fontFaceReference">A uniquely identifying reference to a font face.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFontFaceReference(
        {_COM_Outptr_}  out fontFaceReference: IDWriteFontFaceReference): HRESULT; stdcall;

        /// Gets the PANOSE values from the font, used for font selection and
        /// matching.
        /// <param name="panose">PANOSE structure to fill in.</param>
        /// <remarks>
        /// The function does not simulate these, such as substituting a weight or
        /// proportion inferred on other values. If the font does not specify them,
        /// they are all set to 'any' (0).
        /// </remarks>
        procedure GetPanose(
        {_Out_} panose: PDWRITE_PANOSE); stdcall;

        /// Gets the weight of the specified font.
        function GetWeight(): TDWRITE_FONT_WEIGHT; stdcall;

        /// Gets the stretch (aka. width) of the specified font.
        function GetStretch(): TDWRITE_FONT_STRETCH; stdcall;

        /// Gets the style (aka. slope) of the specified font.
        function GetStyle(): TDWRITE_FONT_STYLE; stdcall;

        /// Creates an localized strings object that contains the weight-stretch-style family names for the font family, indexed by locale name.
        /// <param name="names">Receives a pointer to the newly created localized strings object.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFamilyNames(
        {_COM_Outptr_}  out names: IDWriteLocalizedStrings): HRESULT; stdcall;

        /// Gets a localized strings collection containing the weight-stretch-style face names for the font (e.g., Regular or Bold), indexed by locale name.
        /// <param name="names">Receives a pointer to the newly created localized strings object.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFaceNames(
        {_COM_Outptr_}  out names: IDWriteLocalizedStrings): HRESULT; stdcall;

        /// Gets a localized strings collection containing the specified informational strings, indexed by locale name.
        /// <param name="informationalStringID">Identifies the string to get.</param>
        /// <param name="informationalStrings">Receives a pointer to the newly created localized strings object.</param>
        /// <param name="exists">Receives the value TRUE if the font contains the specified string ID or FALSE if not.</param>
        /// <returns>
        /// Standard HRESULT error code. If the font does not contain the specified string, the return value is S_OK but
        /// informationalStrings receives a NULL pointer and exists receives the value FALSE.
        /// </returns>
        function GetInformationalStrings(informationalStringID: TDWRITE_INFORMATIONAL_STRING_ID;
        {_COM_Outptr_result_maybenull_}  out informationalStrings: IDWriteLocalizedStrings;
        {_Out_} exists: Pboolean): HRESULT; stdcall;

        /// Determines whether the font supports the specified character.
        /// <param name="unicodeValue">Unicode (UCS-4) character value.</param>
        /// <returns>
        /// Returns TRUE if the font has the specified character, FALSE if not.
        /// </returns>
        function HasCharacter(unicodeValue: uint32): boolean; stdcall;

        /// Determines the recommended text rendering and grid-fit mode to be used based on the
        /// font, size, world transform, and measuring mode.
        /// <param name="fontEmSize">Logical font size in DIPs.</param>
        /// <param name="dpiX">Number of pixels per logical inch in the horizontal direction.</param>
        /// <param name="dpiY">Number of pixels per logical inch in the vertical direction.</param>
        /// <param name="transform">Specifies the world transform.</param>
        /// <param name="outlineThreshold">Specifies the quality of the graphics system's outline rendering,
        /// affects the size threshold above which outline rendering is used.</param>
        /// <param name="measuringMode">Specifies the method used to measure during text layout. For proper
        /// glyph spacing, the function returns a rendering mode that is compatible with the specified
        /// measuring mode.</param>
        /// <param name="renderingParams">Rendering parameters object. This parameter is necessary in case the rendering parameters
        /// object overrides the rendering mode.</param>
        /// <param name="renderingMode">Receives the recommended rendering mode.</param>
        /// <param name="gridFitMode">Receives the recommended grid-fit mode.</param>
        /// <remarks>
        /// This method should be used to determine the actual rendering mode in cases where the rendering
        /// mode of the rendering params object is DWRITE_RENDERING_MODE_DEFAULT, and the actual grid-fit
        /// mode when the rendering params object is DWRITE_GRID_FIT_MODE_DEFAULT.
        /// </remarks>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetRecommendedRenderingMode(fontEmSize: single; dpiX: single; dpiY: single;
        {_In_opt_} transform: PDWRITE_MATRIX; isSideways: boolean; outlineThreshold: TDWRITE_OUTLINE_THRESHOLD; measuringMode: TDWRITE_MEASURING_MODE;
        {_In_opt_} renderingParams: IDWriteRenderingParams;
        {_Out_} renderingMode: PDWRITE_RENDERING_MODE1;
        {_Out_} gridFitMode: PDWRITE_GRID_FIT_MODE): HRESULT; stdcall;

        /// Determines whether the character is locally downloaded from the font.
        /// <param name="unicodeValue">Unicode (UCS-4) character value.</param>
        /// <returns>
        /// Returns TRUE if the font has the specified character locally available,
        /// FALSE if not or if the font does not support that character.
        /// </returns>
        function IsCharacterLocal(unicodeValue: uint32): boolean; stdcall;

        /// Determines whether the glyph is locally downloaded from the font.
        /// <param name="glyphId">Glyph identifier.</param>
        /// <returns>
        /// Returns TRUE if the font has the specified glyph locally available.
        /// </returns>
        function IsGlyphLocal(glyphId: uint16): boolean; stdcall;

        /// Determines whether the specified characters are local.
        /// <param name="characters">Array of characters.</param>
        /// <param name="characterCount">The number of elements in the character array.</param>
        /// <param name="enqueueIfNotLocal">Specifies whether to enqueue a download request
        /// if any of the specified characters are not local.</param>
        /// <param name="isLocal">Receives TRUE if all of the specified characters are local,
        /// FALSE if any of the specified characters are remote.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function AreCharactersLocal(
        {_In_reads_(characterCount)} characters: PWCHAR; characterCount: uint32; enqueueIfNotLocal: boolean;
        {_Out_} isLocal: Pboolean): HRESULT; stdcall;

        /// Determines whether the specified glyphs are local.
        /// <param name="glyphIndices">Array of glyph indices.</param>
        /// <param name="glyphCount">The number of elements in the glyph index array.</param>
        /// <param name="enqueueIfNotLocal">Specifies whether to enqueue a download request
        /// if any of the specified glyphs are not local.</param>
        /// <param name="isLocal">Receives TRUE if all of the specified glyphs are local,
        /// FALSE if any of the specified glyphs are remote.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function AreGlyphsLocal(
        {_In_reads_(glyphCount)} glyphIndices: PUINT16; glyphCount: uint32; enqueueIfNotLocal: boolean;
        {_Out_} isLocal: Pboolean): HRESULT; stdcall;

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
        /// Gets the number of strings.
        function GetCount(): uint32; stdcall;

        /// Gets the length in characters (not including the null terminator) of the locale name with the specified index.
        /// <param name="listIndex">Zero-based index of the locale name.</param>
        /// <param name="length">Receives the length in characters, not including the null terminator.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetLocaleNameLength(listIndex: uint32;
        {_Out_} length: PUINT32): HRESULT; stdcall;

        /// Copies the locale name with the specified index to the specified array.
        /// <param name="listIndex">Zero-based index of the locale name.</param>
        /// <param name="localeName">Character array that receives the locale name.</param>
        /// <param name="size">Size of the array in characters. The size must include space for the terminating
        /// null character.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetLocaleName(listIndex: uint32;
        {_Out_writes_z_(size)} localeName: PWCHAR; size: uint32): HRESULT; stdcall;

        /// Gets the length in characters (not including the null terminator) of the string with the specified index.
        /// <param name="listIndex">Zero-based index of the string.</param>
        /// <param name="length">Receives the length in characters, not including the null terminator.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetStringLength(listIndex: uint32;
        {_Out_} length: PUINT32): HRESULT; stdcall;

        /// Copies the string with the specified index to the specified array.
        /// <param name="listIndex">Zero-based index of the string.</param>
        /// <param name="stringBuffer">Character array that receives the string.</param>
        /// <param name="size">Size of the array in characters. The size must include space for the terminating
        ///     null character.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetString(listIndex: uint32;
        {_Out_writes_z_(stringBufferSize)} stringBuffer: PWCHAR; stringBufferSize: uint32): HRESULT; stdcall;

    end;

    /// Application-defined callback interface that receives notifications from the font
    /// download queue (IDWriteFontDownloadQueue interface). Callbacks will occur on the
    /// downloading thread, and objects must be prepared to handle calls on their methods
    /// from other threads at any time.
    IDWriteFontDownloadListener = interface(IUnknown)
        ['{B06FE5B9-43EC-4393-881B-DBE4DC72FDA7}']
        /// The DownloadCompleted method is called back on an arbitrary thread when a
        /// download operation ends.
        /// <param name="downloadQueue">Pointer to the download queue interface on which
        /// the BeginDownload method was called.</param>
        /// <param name="context">Optional context object that was passed to BeginDownload.
        /// AddRef is called on the context object by BeginDownload and Release is called
        /// after the DownloadCompleted method returns.</param>
        /// <param name="downloadResult">Result of the download operation.</param>
        procedure DownloadCompleted(
        {_In_} downloadQueue: IDWriteFontDownloadQueue;
        {_In_opt_} context: IUnknown; downloadResult: HRESULT); stdcall;

    end;

    /// Interface that enqueues download requests for remote fonts, characters, glyphs, and font fragments.
    /// Provides methods to asynchronously execute a download, cancel pending downloads, and be notified of
    /// download completion. Callbacks to listeners will occur on the downloading thread, and objects must
    /// be must be able to handle calls on their methods from other threads at any time.
    IDWriteFontDownloadQueue = interface(IUnknown)
        ['{B71E6052-5AEA-4FA3-832E-F60D431F7E91}']
        /// Registers a client-defined listener object that receives download notifications.
        /// All registered listener's DownloadCompleted will be called after BeginDownload
        /// completes.
        /// <param name="listener">Listener object to add.</param>
        /// <param name="token">Receives a token value, which the caller must subsequently
        /// pass to RemoveListener.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// An IDWriteFontDownloadListener can also be passed to BeginDownload via the
        /// context parameter, rather than globally registered to the queue.
        /// </remarks>
        function AddListener(listener: IDWriteFontDownloadListener;
        {_Out_} token: PUINT32): HRESULT; stdcall;

        /// Unregisters a notification handler that was previously registered using
        /// AddListener.
        /// <param name="token">Token value previously returned by AddListener.</param>
        /// <returns>
        /// Returns S_OK if successful or E_INVALIDARG if the specified token does not
        /// correspond to a registered listener.
        /// </returns>
        function RemoveListener(token: uint32): HRESULT; stdcall;

        /// Determines whether the download queue is empty. Note that the queue does not
        /// include requests that are already being downloaded. In other words, BeginDownload
        /// clears the queue.
        /// <returns>
        /// TRUE if the queue is empty, FALSE if there are requests pending for BeginDownload.
        /// </returns>
        function IsEmpty(): boolean; stdcall;

        /// Begins an asynchronous download operation. The download operation executes
        /// in the background until it completes or is cancelled by a CancelDownload call.
        /// <param name="context">Optional context object that is passed back to the
        /// download notification handler's DownloadCompleted method. If the context object
        /// implements IDWriteFontDownloadListener, its DownloadCompleted will be called
        /// when done.</param>
        /// <returns>
        /// Returns S_OK if a download was successfully begun, S_FALSE if the queue was
        /// empty, or a standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// BeginDownload removes all download requests from the queue, transferring them
        /// to a background download operation. If any previous downloads are still ongoing
        /// when BeginDownload is called again, the new download does not complete until
        /// the previous downloads have finished. If the queue is empty and no active
        /// downloads are pending, the DownloadCompleted callback is called immediately with
        /// DWRITE_DOWNLOAD_RESULT_NONE.
        /// </remarks>
        function BeginDownload(
        {_In_opt_} context: IUnknown = nil): HRESULT; stdcall;

        /// Removes all download requests from the queue and cancels any active download
        /// operations. This calls DownloadCompleted with DWRITE_E_DOWNLOADCANCELLED.
        /// Applications should call this when shutting down if they started any
        /// downloads that have not finished yet with a call to DownloadCompleted.
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function CancelDownload(): HRESULT; stdcall;

        /// Get the current generation number of the download queue, which is incremented
        /// every time after a download completes, whether failed or successful. This cookie
        /// comparison value may be used to compared against cached data to know when it is
        /// stale.
        /// <returns>
        /// The number of download queue generations.
        /// </returns>
        function GetGenerationCount(): uint64; stdcall;

    end;

    /// The GDI interop interface provides interoperability with GDI.
    IDWriteGdiInterop1 = interface(IDWriteGdiInterop)
        ['{4556BE70-3ABD-4F70-90BE-421780A6F515}']
        /// Creates a font object that matches the properties specified by the LOGFONT structure.
        /// <param name="logFont">Structure containing a GDI-compatible font description.</param>
        /// <param name="fontCollection">The font collection to search. If NULL, the local system font collection is used.</param>
        /// <param name="font">Receives a newly created font object if successful, or NULL in case of error.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// The only fields that matter include: lfFaceName, lfCharSet, lfWeight, lfItalic.
        /// Font size and rendering mode are a rendering time property, not a font property,
        /// and text decorations like underline are drawn separately from the text. If no
        /// font matches the given weight, slope, and character set, the best match within
        /// the given GDI family name will be returned. DWRITE_E_NOFONT is returned if there
        /// is no matching font name using either the GDI family name (e.g. Arial) or the
        /// full font name (e.g. Arial Bold Italic).
        /// </remarks>
        function CreateFontFromLOGFONT(
        {_In_} logFont: PLOGFONTW;
        {_In_opt_} fontCollection: IDWriteFontCollection;
        {_COM_Outptr_}  out font: IDWriteFont): HRESULT; stdcall;

        /// Reads the font signature from the given font.
        /// <param name="font">Font to read font signature from.</param>
        /// <param name="fontSignature">Font signature from the OS/2 table, ulUnicodeRange and ulCodePageRange.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFontSignature(
        {_In_} font: IDWriteFont;
        {_Out_} fontSignature: PFONTSIGNATURE): HRESULT; stdcall; overload;

        /// Reads the font signature from the given font.
        /// <param name="font">Font to read font signature from.</param>
        /// <param name="fontSignature">Font signature from the OS/2 table, ulUnicodeRange and ulCodePageRange.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFontSignature(
        {_In_} fontFace: IDWriteFontFace;
        {_Out_} fontSignature: PFONTSIGNATURE): HRESULT; stdcall; overload;

        /// Get a list of matching fonts based on the LOGFONT values. Only fonts
        /// of that family name will be returned.
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetMatchingFontsByLOGFONT(
        {_In_} logFont: PLOGFONT;
        {_In_} fontSet: IDWriteFontSet;
        {_COM_Outptr_}  out filteredSet: IDWriteFontSet): HRESULT; stdcall;

    end;

    /// Information about a formatted line of text.
    TDWRITE_LINE_METRICS1 = record
        /// White space before the content of the line. This is included in the line height and baseline distances.
        /// If the line is formatted horizontally either with a uniform line spacing or with proportional
        /// line spacing, this value represents the extra space above the content.
        leadingBefore: single;
        /// White space after the content of the line. This is included in the height of the line.
        /// If the line is formatted horizontally either with a uniform line spacing or with proportional
        /// line spacing, this value represents the extra space below the content.
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
        DWRITE_FONT_LINE_GAP_USAGE_ENABLED
        );

    PDWRITE_FONT_LINE_GAP_USAGE = ^TDWRITE_FONT_LINE_GAP_USAGE;

    /// The DWRITE_LINE_SPACING structure specifies the parameters used to specify how to manage space between lines.
    TDWRITE_LINE_SPACING = record
        /// Method used to determine line spacing.
        method: TDWRITE_LINE_SPACING_METHOD;
        /// Spacing between lines.
        /// The interpretation of this parameter depends upon the line spacing method, as follows:
        /// - default line spacing: ignored
        /// - uniform line spacing: explicit distance in DIPs between lines
        /// - proportional line spacing: a scaling factor to be applied to the computed line height;
        ///   for each line, the height of the line is computed as for default line spacing, and the scaling factor is applied to that value.
        Height: single;
        /// Distance from top of line to baseline.
        /// The interpretation of this parameter depends upon the line spacing method, as follows:
        /// - default line spacing: ignored
        /// - uniform line spacing: explicit distance in DIPs from the top of the line to the baseline
        /// - proportional line spacing: a scaling factor applied to the computed baseline; for each line,
        ///   the baseline distance is computed as for default line spacing, and the scaling factor is applied to that value.
        baseline: single;
        /// Proportion of the entire leading distributed before the line. The allowed value is between 0 and 1.0. The remaining
        /// leading is distributed after the line. It is ignored for the default and uniform line spacing methods.
        /// The leading that is available to distribute before or after the line depends on the values of the height and
        /// baseline parameters.
        leadingBefore: single;
        /// Specify whether DWRITE_FONT_METRICS::lineGap value should be part of the line metrics.
        fontLineGapUsage: TDWRITE_FONT_LINE_GAP_USAGE;
    end;
    PDWRITE_LINE_SPACING = ^TDWRITE_LINE_SPACING;

    IDWriteTextFormat2 = interface(IDWriteTextFormat1)
        ['{F67E0EDD-9E3D-4ECC-8C32-4183253DFE70}']
        /// Set line spacing.
        /// <param name="lineSpacing">How to manage space between lines.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function SetLineSpacing(
        {_In_} lineSpacingOptions: PDWRITE_LINE_SPACING): HRESULT; stdcall;

        /// Get line spacing.
        /// <param name="lineSpacing">How to manage space between lines.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetLineSpacing(
        {_Out_} lineSpacingOptions: PDWRITE_LINE_SPACING): HRESULT; stdcall;

    end;

    IDWriteTextLayout3 = interface(IDWriteTextLayout2)
        ['{07DDCD52-020E-4DE8-AC33-6C953D83F92D}']
        /// Invalidates the layout, forcing layout to remeasure before calling the
        /// metrics or drawing functions. This is useful if the locality of a font
        /// changes, and layout should be redrawn, or if the size of a client
        /// implemented IDWriteInlineObject changes.
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function InvalidateLayout(): HRESULT; stdcall;

        /// Set line spacing.
        /// <param name="lineSpacing">How to manage space between lines.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function SetLineSpacing(
        {_In_} lineSpacingOptions: PDWRITE_LINE_SPACING): HRESULT; stdcall;

        /// Get line spacing.
        /// <param name="lineSpacing">How to manage space between lines.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetLineSpacing(
        {_Out_} lineSpacingOptions: PDWRITE_LINE_SPACING): HRESULT; stdcall;

        /// GetLineMetrics returns properties of each line.
        /// <param name="lineMetrics">The array to fill with line information.</param>
        /// <param name="maxLineCount">The maximum size of the lineMetrics array.</param>
        /// <param name="actualLineCount">The actual size of the lineMetrics
        /// array that is needed.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// If maxLineCount is not large enough E_NOT_SUFFICIENT_BUFFER,
        /// which is equivalent to HRESULT_FROM_WIN32(ERROR_INSUFFICIENT_BUFFER),
        /// is returned and *actualLineCount is set to the number of lines
        /// needed.
        /// </remarks>
        function GetLineMetrics(
        {_Out_writes_to_opt_(maxLineCount, *actualLineCount)} lineMetrics: PDWRITE_LINE_METRICS1; maxLineCount: uint32;
        {_Out_} actualLineCount: PUINT32): HRESULT; stdcall;

    end;


    /// Represents a color glyph run. The IDWriteFactory4::TranslateColorGlyphRun
    /// method returns an ordered collection of color glyph runs of varying types
    /// depending on what the font supports.
    /// For runs without any specific color, such as PNG data, the runColor field will be zero.
    TDWRITE_COLOR_GLYPH_RUN1 = record
        /// Type of glyph image format for this color run. Exactly one type will be set since
        /// TranslateColorGlyphRun has already broken down the run into separate parts.
        glyphImageFormat: TDWRITE_GLYPH_IMAGE_FORMATS;
        /// Measuring mode to use for this glyph run.
        measuringMode: TDWRITE_MEASURING_MODE;
    end;
    PDWRITE_COLOR_GLYPH_RUN1 = ^TDWRITE_COLOR_GLYPH_RUN1;

    /// Data for a single glyph from GetGlyphImageData.
    TDWRITE_GLYPH_IMAGE_DATA = record
        /// Pointer to the glyph data, be it SVG, PNG, JPEG, TIFF.
        {_Field_size_bytes_(imageDataSize)} imageData: Pvoid;
        /// Size of glyph data in bytes.
        imageDataSize: uint32;
        /// Unique identifier for the glyph data. Clients may use this to cache a parsed/decompressed
        /// version and tell whether a repeated call to the same font returns the same data.
        uniqueDataId: uint32;
        /// Pixels per em of the returned data. For non-scalable raster data (PNG/TIFF/JPG), this can be larger
        /// or smaller than requested from GetGlyphImageData when there isn't an exact match.
        /// For scaling intermediate sizes, use: desired pixels per em * font em size / actual pixels per em.
        pixelsPerEm: uint32;
        /// Size of image when the format is pixel data.
        pixelSize: TD2D1_SIZE_U;
        /// Left origin along the horizontal Roman baseline.
        horizontalLeftOrigin: TD2D1_POINT_2L;
        /// Right origin along the horizontal Roman baseline.
        horizontalRightOrigin: TD2D1_POINT_2L;
        /// Top origin along the vertical central baseline.
        verticalTopOrigin: TD2D1_POINT_2L;
        /// Bottom origin along vertical central baseline.
        verticalBottomOrigin: TD2D1_POINT_2L;
    end;
    PDWRITE_GLYPH_IMAGE_DATA = ^TDWRITE_GLYPH_IMAGE_DATA;

    /// Enumerator for an ordered collection of color glyph runs.
    IDWriteColorGlyphRunEnumerator1 = interface(IDWriteColorGlyphRunEnumerator)
        ['{7C5F86DA-C7A1-4F05-B8E1-55A179FE5A35}']
        /// Gets the current color glyph run.
        /// <param name="colorGlyphRun">Receives a pointer to the color
        /// glyph run. The pointer remains valid until the next call to
        /// MoveNext or until the interface is released.</param>
        /// <returns>
        /// Standard HRESULT error code. An error is returned if there is
        /// no current glyph run, i.e., if MoveNext has not yet been called
        /// or if the end of the sequence has been reached.
        /// </returns>
        function GetCurrentRun(
        {_Outptr_}  out colorGlyphRun: PDWRITE_COLOR_GLYPH_RUN1): HRESULT; stdcall;

    end;

    /// The interface that represents an absolute reference to a font face.
    /// It contains font face type, appropriate file references and face identification data.
    /// Various font data such as metrics, names and glyph outlines is obtained from IDWriteFontFace.
    IDWriteFontFace4 = interface(IDWriteFontFace3)
        ['{27F2A904-4EB8-441D-9678-0563F53E3E2F}']
        /// Gets all the glyph image formats supported by the entire font (SVG, PNG, JPEG, ...).
        function GetGlyphImageFormats(): TDWRITE_GLYPH_IMAGE_FORMATS; stdcall; overload;

        /// Gets the available image formats of a specific glyph and ppem. Glyphs often have at least TrueType
        /// or CFF outlines, but they may also have SVG outlines, or they may have only bitmaps
        /// with no TrueType/CFF outlines. Some image formats, notably the PNG/JPEG ones, are size
        /// specific and will return no match when there isn't an entry in that size range.
        /// <remarks>
        /// Glyph ids beyond the glyph count return DWRITE_GLYPH_IMAGE_FORMATS_NONE.
        /// </remarks>
        function GetGlyphImageFormats(glyphId: uint16; pixelsPerEmFirst: uint32; pixelsPerEmLast: uint32;
        {_Out_} glyphImageFormats: PDWRITE_GLYPH_IMAGE_FORMATS): HRESULT; stdcall; overload;

        /// Gets a pointer to the glyph data based on the desired image format.
        /// <remarks>
        /// The glyphDataContext must be released via ReleaseGlyphImageData when done if the data is not empty,
        /// similar to IDWriteFontFileStream::ReadFileFragment and IDWriteFontFileStream::ReleaseFileFragment.
        /// The data pointer is valid so long as the IDWriteFontFace exists and ReleaseGlyphImageData has not
        /// been called.
        /// </remarks>
        /// <remarks>
        /// The DWRITE_GLYPH_IMAGE_DATA::uniqueDataId is valuable for caching purposes so that if the same
        /// resource is returned more than once, an existing resource can be quickly retrieved rather than
        /// needing to reparse or decompress the data.
        /// </remarks>
        /// <remarks>
        /// The function only returns SVG or raster data - requesting TrueType/CFF/COLR data returns
        /// DWRITE_E_INVALIDARG. Those must be drawn via DrawGlyphRun or queried using GetGlyphOutline instead.
        /// Exactly one format may be requested or else the function returns DWRITE_E_INVALIDARG.
        /// If the glyph does not have that format, the call is not an error, but the function returns empty data.
        /// </remarks>
        function GetGlyphImageData(
        {_In_} glyphId: uint16; pixelsPerEm: uint32; glyphImageFormat: TDWRITE_GLYPH_IMAGE_FORMATS;
        {_Out_} glyphData: PDWRITE_GLYPH_IMAGE_DATA;
        {_Outptr_result_maybenull_}  out glyphDataContext): HRESULT; stdcall;

        /// Releases the table data obtained earlier from ReadGlyphData.
        /// <param name="glyphDataContext">Opaque context from ReadGlyphData.</param>
        procedure ReleaseGlyphImageData(glyphDataContext: Pvoid); stdcall;

    end;

    IDWriteFactory4 = interface(IDWriteFactory3)
        ['{4B0B5BD3-0797-4549-8AC5-FE915CC53856}']
        /// Translates a glyph run to a sequence of color glyph runs, which can be
        /// rendered to produce a color representation of the original "base" run.
        /// <param name="baselineOriginX">Horizontal and vertical origin of the base glyph run in
        /// pre-transform coordinates.</param>
        /// <param name="glyphRun">Pointer to the original "base" glyph run.</param>
        /// <param name="glyphRunDescription">Optional glyph run description.</param>
        /// <param name="desiredGlyphImageFormats">Which data formats TranslateColorGlyphRun
        /// should split the runs into.</param>
        /// <param name="measuringMode">Measuring mode, needed to compute the origins
        /// of each glyph.</param>
        /// <param name="worldToDeviceTransform">Matrix converting from the client's
        /// coordinate space to device coordinates (pixels), i.e., the world transform
        /// multiplied by any DPI scaling.</param>
        /// <param name="colorPaletteIndex">Zero-based index of the color palette to use.
        /// Valid indices are less than the number of palettes in the font, as returned
        /// by IDWriteFontFace2::GetColorPaletteCount.</param>
        /// <param name="colorLayers">If the function succeeds, receives a pointer
        /// to an enumerator object that can be used to obtain the color glyph runs.
        /// If the base run has no color glyphs, then the output pointer is NULL
        /// and the method returns DWRITE_E_NOCOLOR.</param>
        /// <returns>
        /// Returns DWRITE_E_NOCOLOR if the font has no color information, the glyph run
        /// does not contain any color glyphs, or the specified color palette index
        /// is out of range. In this case, the client should render the original glyph
        /// run. Otherwise, returns a standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// The old IDWriteFactory2::TranslateColorGlyphRun is equivalent to passing
        /// DWRITE_GLYPH_IMAGE_FORMATS_TRUETYPE|CFF|COLR.
        /// </remarks>
        function TranslateColorGlyphRun(baselineOrigin: TD2D1_POINT_2F;
        {_In_} glyphRun: PDWRITE_GLYPH_RUN;
        {_In_opt_} glyphRunDescription: PDWRITE_GLYPH_RUN_DESCRIPTION; desiredGlyphImageFormats: TDWRITE_GLYPH_IMAGE_FORMATS; measuringMode: TDWRITE_MEASURING_MODE;
        {_In_opt_} worldAndDpiTransform: PDWRITE_MATRIX; colorPaletteIndex: uint32;
        {_COM_Outptr_}  out colorLayers: IDWriteColorGlyphRunEnumerator1): HRESULT; stdcall;

        /// Converts glyph run placements to glyph origins.
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// The transform and DPI have no affect on the origin scaling.
        /// They are solely used to compute glyph advances when not supplied
        /// and align glyphs in pixel aligned measuring modes.
        /// </remarks>
        function ComputeGlyphOrigins(glyphRun: PDWRITE_GLYPH_RUN; measuringMode: TDWRITE_MEASURING_MODE; baselineOrigin: TD2D1_POINT_2F;
        {_In_opt_} worldAndDpiTransform: PDWRITE_MATRIX;
        {_Out_writes_(glyphRun->glyphCount)} glyphOrigins: PD2D1_POINT_2F): HRESULT; stdcall; overload;

        /// Converts glyph run placements to glyph origins. This overload is for natural metrics, which
        /// includes SVG, TrueType natural modes, and bitmap placement.
        function ComputeGlyphOrigins(glyphRun: PDWRITE_GLYPH_RUN; baselineOrigin: TD2D1_POINT_2F;
        {_Out_writes_(glyphRun->glyphCount)} glyphOrigins: PD2D1_POINT_2F): HRESULT; stdcall; overload;

    end;


    IDWriteFontSetBuilder1 = interface(IDWriteFontSetBuilder)
        ['{3FF7715F-3CDC-4DC6-9B72-EC5621DCCAFD}']
        /// Adds references to all the fonts in the specified font file. The method
        /// parses the font file to determine the fonts and their properties.
        /// <param name="fontFile">Font file reference object to add to the set.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function AddFontFile(
        {_In_} fontFile: IDWriteFontFile): HRESULT; stdcall;

    end;

    /// The IDWriteAsyncResult interface represents the result of an asynchronous
    /// operation. A client can use the interface to wait for the operation to
    /// complete and to get the result.
    IDWriteAsyncResult = interface(IUnknown)
        ['{CE25F8FD-863B-4D13-9651-C1F88DC73FE2}']
        /// The GetWaitHandleMethod method returns a handle that can be used to wait
        /// for the asynchronous operation to complete. The handle remains valid
        /// until the interface is released.
        function GetWaitHandle(): HANDLE; stdcall;

        /// The GetResult method returns the result of the asynchronous operation.
        /// The return value is E_PENDING if the operation has not yet completed.
        function GetResult(): HRESULT; stdcall;

    end;

    /// DWRITE_FILE_FRAGMENT represents a range of bytes in a font file.
    TDWRITE_FILE_FRAGMENT = record
        /// Starting offset of the fragment from the beginning of the file.
        fileOffset: uint64;
        /// Size of the file fragment, in bytes.
        fragmentSize: uint64;
    end;
    PDWRITE_FILE_FRAGMENT = ^TDWRITE_FILE_FRAGMENT;

    /// IDWriteRemoteFontFileStream represents a font file stream parts of which may be
    /// non-local. Non-local data must be downloaded before it can be accessed using
    /// ReadFragment. The interface exposes methods to download font data and query the
    /// locality of font data.
    /// <remarks>
    /// For more information, see the description of IDWriteRemoteFontFileLoader.
    /// </remarks>
    IDWriteRemoteFontFileStream = interface(IDWriteFontFileStream)
        ['{4DB3757A-2C72-4ED9-B2B6-1ABABE1AFF9C}']
        /// GetLocalFileSize returns the number of bytes of the font file that are
        /// currently local, which should always be less than or equal to the full
        /// file size returned by GetFileSize. If the locality is remote, the return
        /// value is zero. If the file is fully local, the return value must be the
        /// same as GetFileSize.
        /// <param name="localFileSize">Receives the local size of the file.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetLocalFileSize(
        {_Out_} localFileSize: PUINT64): HRESULT; stdcall;

        /// GetFileFragmentLocality returns information about the locality of a byte range (i.e.,
        /// font fragment) within the font file stream.
        /// <param name="fileOffset">Offset of the fragment from the beginning of the font file.</param>
        /// <param name="fragmentSize">Size of the fragment in bytes.</param>
        /// <param name="isLocal">Receives TRUE if the first byte of the fragment is local, FALSE if not.</param>
        /// <param name="partialSize">Receives the number of contiguous bytes from the start of the
        /// fragment that have the same locality as the first byte.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFileFragmentLocality(fileOffset: uint64; fragmentSize: uint64;
        {_Out_} isLocal: Pboolean;
        {_Out_range_(0, fragmentSize)} partialSize: PUINT64): HRESULT; stdcall;

        /// Gets the current locality of the file.
        /// <returns>
        /// Returns the locality enumeration (i.e., remote, partial, or local).
        /// </returns>
        function GetLocality(): TDWRITE_LOCALITY; stdcall;

        /// BeginDownload begins downloading all or part of the font file.
        /// <param name="fileFragments">Array of structures, each specifying a byte
        /// range to download.</param>
        /// <param name="fragmentCount">Number of elements in the fileFragments array.
        /// This can be zero to just download file information, such as the size.</param>
        /// <param name="asyncResult">Receives an object that can be used to wait for
        /// the asynchronous download to complete and to get the download result upon
        /// completion. The result may be NULL if the download completes synchronously.
        /// For example, this can happen if method determines that the requested data
        /// is already local.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function BeginDownload(
        {_In_} downloadOperationID: PUUID;
        {_In_reads_(fragmentCount)} fileFragments: PDWRITE_FILE_FRAGMENT; fragmentCount: uint32;
        {_COM_Outptr_result_maybenull_}  out asyncResult: IDWriteAsyncResult): HRESULT; stdcall;

    end;

    /// Specifies the container format of a font resource. A container format is distinct from
    /// a font file format (DWRITE_FONT_FILE_TYPE) because the container describes the container
    /// in which the underlying font file is packaged.
    TDWRITE_CONTAINER_TYPE = (
        DWRITE_CONTAINER_TYPE_UNKNOWN,
        DWRITE_CONTAINER_TYPE_WOFF,
        DWRITE_CONTAINER_TYPE_WOFF2
        );

    PDWRITE_CONTAINER_TYPE = ^TDWRITE_CONTAINER_TYPE;

    /// The IDWriteRemoteFontFileLoader interface represents a font file loader that can access
    /// remote (i.e., downloadable) fonts. The IDWriteFactory5::CreateHttpFontFileLoader method
    /// returns an instance of this interface, or a client can create its own implementation.
    /// <remarks>
    /// Calls to a remote file loader or stream should never block waiting for network operations.
    /// Any call that cannot succeeded immediately using local (e.g., cached) must should return
    /// DWRITE_E_REMOTEFONT. This error signifies to DWrite that it should add requests to the
    /// font download queue.
    /// </remarks>
    IDWriteRemoteFontFileLoader = interface(IDWriteFontFileLoader)
        ['{68648C83-6EDE-46C0-AB46-20083A887FDE}']
        /// Creates a remote font file stream object that encapsulates an open file resource
        /// and can be used to download remote file data.
        /// <param name="fontFileReferenceKey">Font file reference key that uniquely identifies the font file resource
        /// within the scope of the font loader being used.</param>
        /// <param name="fontFileReferenceKeySize">Size of font file reference key in bytes.</param>
        /// <param name="fontFileStream">Pointer to the newly created font file stream.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// Unlike CreateStreamFromKey, this method can be used to create a stream for a remote file. If the file is
        /// remote, the returned stream's BeginDownload method can be used to download all or part of the font file.
        /// However, the stream cannot be used to get the file size or access font data unless the file is at least
        /// partially local.
        /// </remarks>
        function CreateRemoteStreamFromKey(
        {_In_reads_bytes_(fontFileReferenceKeySize)} fontFileReferenceKey: Pvoid; fontFileReferenceKeySize: uint32;
        {_COM_Outptr_}  out fontFileStream: IDWriteRemoteFontFileStream): HRESULT; stdcall;

        /// Gets the locality of the file resource identified by the unique key.
        /// <param name="fontFileReferenceKey">Font file reference key that uniquely identifies the font file resource
        /// within the scope of the font loader being used.</param>
        /// <param name="fontFileReferenceKeySize">Size of font file reference key in bytes.</param>
        /// <param name="locality">Locality of the file.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetLocalityFromKey(
        {_In_reads_bytes_(fontFileReferenceKeySize)} fontFileReferenceKey: Pvoid; fontFileReferenceKeySize: uint32;
        {_Out_} locality: PDWRITE_LOCALITY): HRESULT; stdcall;

        /// Creates a font file reference from a URL if the loader supports this capability.
        /// <param name="factory">Factory used to create the font file reference.</param>
        /// <param name="baseUrl">Optional base URL. The base URL is used to resolve the fontFileUrl
        /// if it is relative. For example, the baseUrl might be the URL of the referring document
        /// that contained the fontFileUrl.</param>
        /// <param name="fontFileUrl">URL of the font resource.</param>
        /// <param name="fontFile">Receives a pointer to the newly created font file reference.</param>
        /// <returns>
        /// Standard HRESULT error code, or E_NOTIMPL if the loader does not implement this method.
        /// </returns>
        function CreateFontFileReferenceFromUrl(factory: IDWriteFactory;
        {_In_opt_z_} baseUrl: PWCHAR;
        {_In_z_} fontFileUrl: PWCHAR;
        {_COM_Outptr_}  out fontFile: IDWriteFontFile): HRESULT; stdcall;

    end;

    /// The IDWriteInMemoryFontFileLoader interface enables clients to reference
    /// in-memory fonts without having to implement a custom loader. The
    /// IDWriteFactory5::CreateInMemoryFontFileLoader method returns an instance
    /// of this interface, which the client is responsible for registering and
    /// unregistering using IDWriteFactory::RegisterFontFileLoader and
    /// IDWriteFactory::UnregisterFontFileLoader.
    IDWriteInMemoryFontFileLoader = interface(IDWriteFontFileLoader)
        ['{DC102F47-A12D-4B1C-822D-9E117E33043F}']
        /// The CreateInMemoryFontFileReference method creates a font file reference
        /// (IDWriteFontFile object) from an array of bytes. The font file reference
        /// is bound to the IDWriteInMemoryFontFileLoader instance with which it was
        /// created and remains valid for as long as that loader is registered with
        /// the factory.
        /// <param name="factory">Factory object used to create the font file reference.</param>
        /// <param name="fontData">Pointer to a memory block containing the font data.</param>
        /// <param name="fontDataSize">Size of the font data.</param>
        /// <param name="ownerObject">Optional object that owns the memory specified by
        /// the fontData parameter. If this parameter is not NULL, the method stores a
        /// pointer to the font data and adds a reference to the owner object. The
        /// fontData pointer must remain valid until the owner object is released. If
        /// this parameter is NULL, the method makes a copy of the font data.</param>
        /// <param name="fontFile">Receives a pointer to the newly-created font file
        /// reference.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function CreateInMemoryFontFileReference(factory: IDWriteFactory;
        {_In_reads_bytes_(fontDataSize)} fontData: Pvoid; fontDataSize: uint32;
        {_In_opt_} ownerObject: IUnknown;
        {_COM_Outptr_}  out fontFile: IDWriteFontFile): HRESULT; stdcall;

        /// The GetFileCount method returns the number of font file references that
        /// have been created using this loader instance.
        function GetFileCount(): uint32; stdcall;

    end;

    /// The root factory interface for all DWrite objects.
    IDWriteFactory5 = interface(IDWriteFactory4)
        ['{958DB99A-BE2A-4F09-AF7D-65189803D1D3}']
        /// Creates an empty font set builder to add font face references
        /// and create a custom font set.
        /// <param name="fontSetBuilder">Receives a pointer to the newly created font set builder object, or nullptr in case of failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function CreateFontSetBuilder(
        {_COM_Outptr_}  out fontSetBuilder: IDWriteFontSetBuilder1): HRESULT; stdcall;

        /// The CreateInMemoryFontFileLoader method creates a loader object that can
        /// be used to create font file references to in-memory fonts. The caller is
        /// responsible for registering and unregistering the loader.
        /// <param name="newLoader">Receives a pointer to the newly-created loader object.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function CreateInMemoryFontFileLoader(
        {_COM_Outptr_}  out newLoader: IDWriteInMemoryFontFileLoader): HRESULT; stdcall;

        /// The CreateHttpFontFileLoader function creates a remote font file loader
        /// that can create font file references from HTTP or HTTPS URLs. The caller
        /// is responsible for registering and unregistering the loader.
        /// <param name="referrerUrl">Optional referrer URL for HTTP requests.</param>
        /// <param name="extraHeaders">Optional additional header fields to include
        /// in HTTP requests. Each header field consists of a name followed by a colon
        /// (":") and the field value, as specified by RFC 2616. Multiple header fields
        /// may be separated by newlines.</param>
        /// <param name="newLoader">Receives a pointer to the newly-created loader object.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function CreateHttpFontFileLoader(
        {_In_opt_z_} referrerUrl: pwidechar;
        {_In_opt_z_} extraHeaders: pwidechar;
        {_COM_Outptr_}  out newLoader: IDWriteRemoteFontFileLoader): HRESULT; stdcall;

        /// The AnalyzeContainerType method analyzes the specified file data to determine
        /// whether it is a known font container format (e.g., WOFF or WOFF2).
        /// <returns>
        /// Returns the container type if recognized. DWRITE_CONTAINER_TYPE_UNKOWNN is
        /// returned for all other files, including uncompressed font files.
        /// </returns>
        function AnalyzeContainerType(
        {_In_reads_bytes_(fileDataSize)} fileData: Pvoid; fileDataSize: uint32): TDWRITE_CONTAINER_TYPE; stdcall;

        /// The UnpackFontFile method unpacks font data from a container file (WOFF or
        /// WOFF2) and returns the unpacked font data in the form of a font file stream.
        /// <param name="containerType">Container type returned by AnalyzeContainerType.</param>
        /// <param name="fileData">Pointer to the compressed data.</param>
        /// <param name="fileDataSize">Size of the compressed data, in bytes.</param>
        /// <param name="unpackedFontStream">Receives a pointer to a newly created font
        /// file stream containing the uncompressed data.</param>
        /// <returns>
        /// Standard HRESULT error code. The return value is E_INVALIDARG if the container
        /// type is DWRITE_CONTAINER_TYPE_UNKNOWN.
        /// </returns>
        function UnpackFontFile(containerType: TDWRITE_CONTAINER_TYPE;
        {_In_reads_bytes_(fileDataSize)} fileData: Pvoid; fileDataSize: uint32;
        {_COM_Outptr_}  out unpackedFontStream: IDWriteFontFileStream): HRESULT; stdcall;

    end;



    IDWriteFontResource = interface;


    IDWriteFontFace5 = interface;


    IDWriteFontFaceReference1 = interface;


    IDWriteFontSet1 = interface;


    IDWriteFontCollection2 = interface;


    IDWriteTextFormat3 = interface;


    IDWriteFontSetBuilder2 = interface;

    /// Four character identifier for a font axis.
    /// <remarks>
    /// Use DWRITE_MAKE_FONT_AXIS_TAG() to create a custom one.
    /// <remarks>

    TDWRITE_FONT_AXIS_TAG = (
        DWRITE_FONT_AXIS_TAG_WEIGHT = ((Ord('t') shl 24) or (Ord('h') shl 16) or (Ord('g') shl 8) or Ord('w')),
        DWRITE_FONT_AXIS_TAG_WIDTH = ((Ord('h') shl 24) or (Ord('t') shl 16) or (Ord('d') shl 8) or Ord('w')),
        DWRITE_FONT_AXIS_TAG_SLANT = ((Ord('t') shl 24) or (Ord('n') shl 16) or (Ord('l') shl 8) or Ord('s')),
        DWRITE_FONT_AXIS_TAG_OPTICAL_SIZE = ((Ord('z') shl 24) or (Ord('s') shl 16) or (Ord('p') shl 8) or Ord('o')),
        DWRITE_FONT_AXIS_TAG_ITALIC = ((Ord('l') shl 24) or (Ord('a') shl 16) or (Ord('t') shl 8) or Ord('i'))
        );


    PDWRITE_FONT_AXIS_TAG = ^TDWRITE_FONT_AXIS_TAG;

    /// Value for a font axis, used when querying and creating font instances.
    TDWRITE_FONT_AXIS_VALUE = record
        /// Four character identifier of the font axis (weight, width, slant, italic...).
        axisTag: TDWRITE_FONT_AXIS_TAG;
        /// Value for the given axis, with the meaning and range depending on the axis semantics.
        /// Certain well known axes have standard ranges and defaults, such as weight (1..1000, default=400),
        /// width (>0, default=100), slant (-90..90, default=-20), and italic (0 or 1).
        Value: single;
    end;
    PDWRITE_FONT_AXIS_VALUE = ^TDWRITE_FONT_AXIS_VALUE;

    /// Minimum and maximum range of a font axis.
    TDWRITE_FONT_AXIS_RANGE = record
        /// Four character identifier of the font axis (weight, width, slant, italic...).
        axisTag: TDWRITE_FONT_AXIS_TAG;
        /// Minimum value supported by this axis.
        MinValue: single;
        /// Maximum value supported by this axis. The maximum can equal the minimum.
        MaxValue: single;
    end;
    PDWRITE_FONT_AXIS_RANGE = ^TDWRITE_FONT_AXIS_RANGE;

    /// How font families are grouped together, used by IDWriteFontCollection.
    TDWRITE_FONT_FAMILY_MODEL = (
        /// Families are grouped by the typographic family name preferred by the font author. The family can contain as
        /// many face as the font author wants.
        /// This corresponds to the DWRITE_FONT_PROPERTY_ID_TYPOGRAPHIC_FAMILY_NAME.
        DWRITE_FONT_FAMILY_MODEL_TYPOGRAPHIC,
        /// Families are grouped by the weight-stretch-style family name, where all faces that differ only by those three
        /// axes are grouped into the same family, but any other axes go into a distinct family. For example, the Sitka
        /// family with six different optical sizes yields six separate families (Sitka Caption, Display, Text, Subheading,
        /// Heading, Banner...). This corresponds to the DWRITE_FONT_PROPERTY_ID_WEIGHT_STRETCH_STYLE_FAMILY_NAME.
        DWRITE_FONT_FAMILY_MODEL_WEIGHT_STRETCH_STYLE
        );

    PDWRITE_FONT_FAMILY_MODEL = ^TDWRITE_FONT_FAMILY_MODEL;

    /// Apply certain axes automatically in layout during font selection.
    TDWRITE_AUTOMATIC_FONT_AXES = (
        /// No axes are automatically applied.
        DWRITE_AUTOMATIC_FONT_AXES_NONE = $0000,
        /// Automatically pick an appropriate optical value based on the font size (via SetFontSize) when no value is
        /// specified via DWRITE_FONT_AXIS_TAG_OPTICAL_SIZE. Callers can still explicitly apply the 'opsz' value over
        /// text ranges via SetFontAxisValues, which take priority.
        DWRITE_AUTOMATIC_FONT_AXES_OPTICAL_SIZE = $0001
        );

    PDWRITE_AUTOMATIC_FONT_AXES = ^TDWRITE_AUTOMATIC_FONT_AXES;

    /// Attributes for a font axis.
    TDWRITE_FONT_AXIS_ATTRIBUTES = (
        /// No attributes.
        DWRITE_FONT_AXIS_ATTRIBUTES_NONE = $0000,
        /// This axis is implemented as a variation axis in a variable font, with a continuous range of
        /// values, such as a range of weights from 100..900. Otherwise it is either a static axis that
        /// holds a single point, or it has a range but doesn't vary, such as optical size in the Skia
        /// Heading font which covers a range of points but doesn't interpolate any new glyph outlines.
        DWRITE_FONT_AXIS_ATTRIBUTES_VARIABLE = $0001,
        /// This axis is recommended to be remain hidden in user interfaces. The font developer may
        /// recommend this if an axis is intended to be accessed only programmatically, or is meant for
        /// font-internal or font-developer use only. The axis may be exposed in lower-level font
        /// inspection utilities, but should not be exposed in common or even advanced-mode user
        /// interfaces in content-authoring apps.
        DWRITE_FONT_AXIS_ATTRIBUTES_HIDDEN = $0002
        );

    PDWRITE_FONT_AXIS_ATTRIBUTES = ^TDWRITE_FONT_AXIS_ATTRIBUTES;

    IDWriteFactory6 = interface(IDWriteFactory5)
        ['{F3744D80-21F7-42EB-B35D-995BC72FC223}']
        /// Creates a reference to a specific font instance within a file.
        /// <param name="fontFile">User provided font file representing the font face.</param>
        /// <param name="faceIndex">The zero based index of a font face in cases when the font files contain a collection of font faces.
        /// If the font files contain a single face, this value should be zero.</param>
        /// <param name="fontSimulations">Font face simulation flags for algorithmic emboldening and italicization.</param>
        /// <param name="fontAxisValues">List of font axis values.</param>
        /// <param name="fontAxisValueCount">Number of font axis values.</param>
        /// <param name="fontFaceReference">Receives a pointer to the newly created font face reference object, or nullptr in case of failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function CreateFontFaceReference(
        {_In_} fontFile: IDWriteFontFile; faceIndex: uint32; fontSimulations: TDWRITE_FONT_SIMULATIONS;
        {_In_reads_(fontAxisValueCount)} fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: uint32;
        {_COM_Outptr_}  out fontFaceReference: IDWriteFontFaceReference1): HRESULT; stdcall;

        /// Creates a font resource given a font file and face index.
        /// <param name="fontFile">User provided font file representing the font face.</param>
        /// <param name="faceIndex">The zero based index of a font face in cases when the font files contain a collection of font faces.
        /// If the font files contain a single face, this value should be zero.</param>
        /// <param name="fontResource">Receives a pointer to the newly created font resource object, or nullptr in case of failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function CreateFontResource(
        {_In_} fontFile: IDWriteFontFile; faceIndex: uint32;
        {_COM_Outptr_}  out fontResource: IDWriteFontResource): HRESULT; stdcall;

        /// Retrieves the set of system fonts.
        /// <param name="includeDownloadableFonts">Include downloadable fonts or only locally installed ones.</param>
        /// <param name="fontSet">Receives a pointer to the font set object, or nullptr in case of failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetSystemFontSet(includeDownloadableFonts: boolean;
        {_COM_Outptr_}  out fontSet: IDWriteFontSet1): HRESULT; stdcall;

        /// Retrieves a collection of fonts grouped into families.
        /// <param name="includeDownloadableFonts">Include downloadable fonts or only locally installed ones.</param>
        /// <param name="fontFamilyModel">How to group families in the collection.</param>
        /// <param name="fontCollection">Receives a pointer to the font collection object, or nullptr in case of failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetSystemFontCollection(includeDownloadableFonts: boolean; fontFamilyModel: TDWRITE_FONT_FAMILY_MODEL;
        {_COM_Outptr_}  out fontCollection: IDWriteFontCollection2): HRESULT; stdcall;

        /// Create a collection of fonts grouped into families from a font set.
        /// <param name="fontSet">A set of fonts to use to build the collection.</param>
        /// <param name="fontFamilyModel">How to group families in the collection.</param>
        /// <param name="fontCollection">Receives a pointer to the newly created font collection object, or nullptr in case of failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function CreateFontCollectionFromFontSet(fontSet: IDWriteFontSet; fontFamilyModel: TDWRITE_FONT_FAMILY_MODEL;
        {_COM_Outptr_}  out fontCollection: IDWriteFontCollection2): HRESULT; stdcall;

        /// Creates an empty font set builder to add font instances and create a custom font set.
        /// <param name="fontSetBuilder">Receives a pointer to the newly created font set builder object, or nullptr in case of failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function CreateFontSetBuilder(
        {_COM_Outptr_}  out fontSetBuilder: IDWriteFontSetBuilder2): HRESULT; stdcall;

        /// Create a text format object used for text layout.
        /// <param name="fontFamilyName">Name of the font family from the collection.</param>
        /// <param name="fontCollection">Font collection, with nullptr indicating the system font collection.</param>
        /// <param name="fontAxisValues">List of font axis values.</param>
        /// <param name="fontAxisValueCount">Number of font axis values.</param>
        /// <param name="fontSize">Logical size of the font in DIP units.</param>
        /// <param name="localeName">Locale name (e.g. "ja-JP", "en-US", "ar-EG").</param>
        /// <param name="textFormat">Receives a pointer to the newly created text format object, or nullptr in case of failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// If fontCollection is nullptr, the system font collection is used, grouped by typographic family name
        /// (DWRITE_FONT_FAMILY_MODEL_TYPOGRAPHIC) without downloadable fonts.
        /// </remarks>
        function CreateTextFormat(
        {_In_z_} fontFamilyName: PWCHAR;
        {_In_opt_} fontCollection: IDWriteFontCollection;
        {_In_reads_(fontAxisValueCount)} fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: uint32; fontSize: single;
        {_In_z_} localeName: PWCHAR;
        {_COM_Outptr_}  out textFormat: IDWriteTextFormat3): HRESULT; stdcall;

    end;

    IDWriteFontFace5 = interface(IDWriteFontFace4)
        ['{98EFF3A5-B667-479A-B145-E2FA5B9FDC29}']
        /// Get the number of axes defined by the font. This includes both static and variable axes.
        function GetFontAxisValueCount(): uint32; stdcall;

        /// Get the list of axis values used by the font.
        /// <param name="fontAxisValues">List of font axis values.</param>
        /// <param name="fontAxisValueCount">Maximum number of font axis values to write.</param>
        /// <returns>
        /// Standard HRESULT error code, or E_INVALIDARG if fontAxisValueCount doesn't match GetFontAxisValueCount.
        /// </returns>
        /// <remarks>
        /// The values are returned in the canonical order defined by the font, clamped to the actual range supported,
        /// not specifically the same axis value array passed to CreateFontFace.
        /// </remarks>
        function GetFontAxisValues(
        {_Out_writes_(fontAxisValueCount)} fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: uint32): HRESULT; stdcall;

        /// Whether this font's resource supports any variable axes. When true, at least one DWRITE_FONT_AXIS_RANGE
        /// in the font resource has a non-empty range (maximum > minimum).
        function HasVariations(): boolean; stdcall;

        /// Get the underlying font resource for this font face. A caller can use that to query information on the resource
        /// or recreate a new font face instance with different axis values.
        /// <param name="fontResource">Newly created font resource object.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFontResource(
        {_COM_Outptr_}  out fontResource: IDWriteFontResource): HRESULT; stdcall;

        /// Compares two instances of a font face for equality.
        function Equals(fontFace: IDWriteFontFace): boolean; stdcall;

    end;

    /// Interface to return axis information for a font resource and create specific font face instances.
    IDWriteFontResource = interface(IUnknown)
        ['{1F803A76-6871-48E8-987F-B975551C50F2}']
        /// Get the font file of the resource.
        /// <param name="fontFile">Receives a pointer to the font file.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFontFile(
        {_COM_Outptr_}  out fontFile: IDWriteFontFile): HRESULT; stdcall;

        /// Obtains the zero-based index of the font face in its font file. If the font files contain a single face,
        /// the return value is zero.
        function GetFontFaceIndex(): uint32; stdcall;

        /// Get the number of axes supported by the font resource. This includes both static and variable axes.
        function GetFontAxisCount(): uint32; stdcall;

        /// Get the default values for all axes supported by the font resource.
        /// <param name="fontAxisValues">List of font axis values.</param>
        /// <param name="fontAxisValueCount">Maximum number of font axis values to write.</param>
        /// <remarks>
        /// Different font resources may have different defaults.
        /// For OpenType 1.8 fonts, these values come from the STAT and fvar tables.
        /// For older fonts without a STAT table, weight-width-slant-italic are read from the OS/2 table.
        /// </remarks>
        /// <returns>
        /// Standard HRESULT error code, or E_INVALIDARG if fontAxisValueCount doesn't match GetFontAxisCount.
        /// </returns>
        function GetDefaultFontAxisValues(
        {_Out_writes_(fontAxisValueCount)} fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: uint32): HRESULT; stdcall;

        /// Get ranges of each axis.
        /// <param name="fontAxisRanges"></param>
        /// <param name="fontAxisRangeCount">Total number of axis ranges</param>
        /// <returns>
        /// Standard HRESULT error code, or E_INVALIDARG if fontAxisRangeCount doesn't match GetFontAxisCount.
        /// </returns>
        /// <remarks>
        /// Non-varying axes will have empty ranges (minimum==maximum).
        /// </remarks>
        function GetFontAxisRanges(
        {_Out_writes_(fontAxisRangeCount)} fontAxisRanges: PDWRITE_FONT_AXIS_RANGE; fontAxisRangeCount: uint32): HRESULT; stdcall;

        /// Gets attributes about the given axis, such as whether the font author recommends to hide the axis
        /// in user interfaces.
        /// <param name="axisIndex">Font axis, from 0 to GetFontAxisValueCount - 1.</param>
        /// <param name="axisAttributes">Receives the attributes for the given axis.</param>
        /// <returns>
        /// Attributes for a font axis, or NONE if axisIndex is beyond the font count.
        /// </returns>
        function GetFontAxisAttributes(axisIndex: uint32): TDWRITE_FONT_AXIS_ATTRIBUTES; stdcall;

        /// Gets the localized names of a font axis.
        /// <param name="axisIndex">Font axis, from 0 to GetFontAxisCount - 1.</param>
        /// <param name="names">Receives a pointer to the newly created localized strings object.</param>
        /// <remarks>
        /// The font author may not have supplied names for some font axes. The localized strings
        /// will be empty in that case.
        /// </remarks>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetAxisNames(axisIndex: uint32;
        {_COM_Outptr_}  out names: IDWriteLocalizedStrings): HRESULT; stdcall;

        /// Get the number of named values for a specific axis.
        /// <param name="axisIndex">Font axis, from 0 to GetFontAxisCount - 1.</param>
        /// <returns>
        /// Number of named values.
        /// </returns>
        function GetAxisValueNameCount(axisIndex: uint32): uint32; stdcall;

        /// Gets the localized names of specific values for a font axis.
        /// <param name="axisIndex">Font axis, from 0 to GetFontAxisCount - 1.</param>
        /// <param name="axisValueIndex">Value index, from 0 to GetAxisValueNameCount - 1.</param>
        /// <param name="fontAxisRange">Range of the named value.</param>
        /// <param name="names">Receives a pointer to the newly created localized strings object.</param>
        /// <remarks>
        /// The font author may not have supplied names for some font axis values. The localized strings
        /// will be empty in that case. The range may be a single point, where minimum == maximum.
        /// All ranges are in ascending order by axisValueIndex.
        /// </remarks>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetAxisValueNames(axisIndex: uint32; axisValueIndex: uint32;
        {_Out_} fontAxisRange: PDWRITE_FONT_AXIS_RANGE;
        {_COM_Outptr_}  out names: IDWriteLocalizedStrings): HRESULT; stdcall;

        /// Whether this font's resource supports any variable axes. When true, at least one DWRITE_FONT_AXIS_RANGE
        /// in the font resource has a non-empty range (maximum > minimum).
        function HasVariations(): boolean; stdcall;

        /// Creates a font face instance with specific axis values.
        /// <param name="fontSimulations">Font face simulation flags for algorithmic emboldening and italicization.</param>
        /// <param name="fontAxisValues">List of font axis values.</param>
        /// <param name="fontAxisValueCount">Number of font axis values.</param>
        /// <param name="fontFace">Receives a pointer to the newly created font face object, or nullptr on failure.</param>
        /// <remarks>
        /// The passed input axis values are permitted to be a subset or superset of all the ones actually supported by
        /// the font. Any unspecified axes use their default values, values beyond the ranges are clamped, and any
        /// non-varying axes have no effect.
        /// </remarks>
        /// <returns>
        /// Standard HRESULT error code, or DWRITE_E_REMOTEFONT if the face is not local.
        /// </returns>
        function CreateFontFace(fontSimulations: TDWRITE_FONT_SIMULATIONS;
        {_In_reads_(fontAxisValueCount)} fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: uint32;
        {_COM_Outptr_}  out fontFace: IDWriteFontFace5): HRESULT; stdcall;

        /// Creates a font face reference with specific axis values.
        /// <param name="fontSimulations">Font face simulation flags for algorithmic emboldening and italicization.</param>
        /// <param name="fontAxisValues">List of font axis values.</param>
        /// <param name="fontAxisValueCount">Number of font axis values.</param>
        /// <param name="fontFaceReference">Receives a pointer to the newly created font face reference object, or nullptr on failure.</param>
        /// <remarks>
        /// The passed input axis values are permitted to be a subset or superset of all the ones actually supported by
        /// the font. Any unspecified axes use their default values, values beyond the ranges are clamped, and any
        /// non-varying axes have no effect.
        /// </remarks>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function CreateFontFaceReference(fontSimulations: TDWRITE_FONT_SIMULATIONS;
        {_In_reads_(fontAxisValueCount)} fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: uint32;
        {_COM_Outptr_}  out fontFaceReference: IDWriteFontFaceReference1): HRESULT; stdcall;

    end;

    IDWriteFontFaceReference1 = interface(IDWriteFontFaceReference)
        ['{C081FE77-2FD1-41AC-A5A3-34983C4BA61A}']
        /// Creates a font face from the reference for use with layout, shaping, or rendering.
        /// <param name="fontFace">Newly created font face object, or nullptr in the case of failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// This function can fail with DWRITE_E_REMOTEFONT if the font is not local.
        /// </remarks>
        function CreateFontFace(
        {_COM_Outptr_}  out fontFace: IDWriteFontFace5): HRESULT; stdcall;

        /// Get the number of axes specified by the reference.
        function GetFontAxisValueCount(): uint32; stdcall;

        /// Get the list of font axis values specified by the reference.
        /// <param name="fontAxisValues">List of font axis values.</param>
        /// <param name="fontAxisValueCount">Number of font axis values.</param>
        /// <returns>
        /// Standard HRESULT error code, or E_INVALIDARG if fontAxisValueCount doesn't match GetFontAxisValueCount.
        /// </returns>
        function GetFontAxisValues(
        {_Out_writes_(fontAxisValueCount)} fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: uint32): HRESULT; stdcall;

    end;

    IDWriteFontSetBuilder2 = interface(IDWriteFontSetBuilder1)
        ['{EE5BA612-B131-463C-8F4F-3189B9401E45}']
        /// Adds a font to the set being built, with the caller supplying enough information to search on
        /// and determine axis ranges, avoiding the need to open the potentially non-local font.
        /// <param name="fontFile">Font file reference object to add to the set.</param>
        /// <param name="faceIndex">The zero based index of a font face in a collection.</param>
        /// <param name="fontSimulations">Font face simulation flags for algorithmic emboldening and italicization.</param>
        /// <param name="fontAxisValues">List of font axis values.</param>
        /// <param name="fontAxisValueCount">Number of font axis values.</param>
        /// <param name="fontAxisRanges">List of axis ranges.</param>
        /// <param name="fontAxisRangeCount">Number of axis ranges.</param>
        /// <param name="properties">List of properties to associate with the reference.</param>
        /// <param name="propertyCount">How many properties are defined.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// The font properties should include at least a family (typographic or weight/style/stretch).
        /// Otherwise the font would be accessible in the IDWriteFontSet only by index, not name.
        /// </returns>
        function AddFont(
        {_In_} fontFile: IDWriteFontFile; fontFaceIndex: uint32; fontSimulations: TDWRITE_FONT_SIMULATIONS;
        {_In_reads_(fontAxisValueCount)} fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: uint32;
        {_In_reads_(fontAxisRangeCount)} fontAxisRanges: PDWRITE_FONT_AXIS_RANGE; fontAxisRangeCount: uint32;
        {_In_reads_(propertyCount)} properties: PDWRITE_FONT_PROPERTY; propertyCount: uint32): HRESULT; stdcall;

        /// Adds references to all the fonts in the specified font file. The method
        /// parses the font file to determine the fonts and their properties.
        /// <param name="filePath">Absolute file path to add to the font set.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function AddFontFile(
        {_In_z_} filePath: PWCHAR): HRESULT; stdcall;

    end;

    IDWriteFontSet1 = interface(IDWriteFontSet)
        ['{7E9FDA85-6C92-4053-BC47-7AE3530DB4D3}']
        /// Generates a matching font set based on the requested inputs, ordered so that nearer matches are earlier.
        /// <param name="property">Font property of interest, such as typographic family or weight/stretch/style family.</param>
        /// <param name="fontAxisValues">List of font axis values.</param>
        /// <param name="fontAxisValueCount">Number of font axis values.</param>
        /// <param name="matchingSet">Prioritized list of fonts that match the properties, or nullptr on failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// This can yield distinct items that were not in the original font set, including items with simulation flags
        /// (if they would be a closer match to the request) and instances that were not named by the font author.
        /// Items from the same font resources are collapsed into one, the closest possible match.
        /// </remarks>
        function GetMatchingFonts(
        {_In_opt_} fontProperty: PDWRITE_FONT_PROPERTY;
        {_In_reads_(fontAxisValueCount)} fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: uint32;
        {_COM_Outptr_}  out matchingFonts: IDWriteFontSet1): HRESULT; stdcall;

        /// Returns a font set that contains only the first occurrence of each font resource in the given set.
        /// <param name="fontSet">New font set consisting of single default instances from font resources.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFirstFontResources(
        {_COM_Outptr_}  out filteredFontSet: IDWriteFontSet1): HRESULT; stdcall;

        /// Returns a subset of fonts filtered by the given properties.
        /// <param name="properties">List of properties to filter using.</param>
        /// <param name="propertyCount">How many properties to filter.</param>
        /// <param name="selectAnyProperty">Select any property rather rather than the intersection of them all.</param>
        /// <param name="filteredSet">Subset of fonts that match the properties, or nullptr on failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// If no fonts matched the filter, the returned subset will be empty (GetFontCount returns 0).
        /// The subset will always be equal to or less than the original set.
        /// </remarks>
        function GetFilteredFonts(
        {_In_reads_opt_(propertyCount)} properties: PDWRITE_FONT_PROPERTY; propertyCount: uint32; selectAnyProperty: boolean;
        {_COM_Outptr_}  out filteredFontSet: IDWriteFontSet1): HRESULT; stdcall; overload;

        /// Returns a subset of fonts filtered by the given ranges, endpoint-inclusive.
        /// <param name="fontAxisRanges">List of axis ranges.</param>
        /// <param name="fontAxisRangeCount">Number of axis ranges.</param>
        /// <param name="selectAnyRange">Select any range rather rather than the intersection of them all.</param>
        /// <param name="filteredSet">Subset of fonts that fall within the ranges, or nullptr on failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// If no fonts matched the filter, the subset will be empty (GetFontCount returns 0), but the function does not
        /// return an error. The subset will always be equal to or less than the original set.
        /// </remarks>
        function GetFilteredFonts(
        {_In_reads_(fontAxisRangeCount)} fontAxisRanges: PDWRITE_FONT_AXIS_RANGE; fontAxisRangeCount: uint32; selectAnyRange: boolean;
        {_COM_Outptr_}  out filteredFontSet: IDWriteFontSet1): HRESULT; stdcall; overload;

        /// Returns a subset of fonts filtered by the given indices.
        /// <param name="indices">Array of indices, each index from [0..GetFontCount() - 1].</param>
        /// <param name="indexCount">Number of indices.</param>
        /// <param name="filteredSet">Subset of fonts that come from the given indices, or nullptr on failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// The indices can come in any order, meaning this function can produce a new set with items removed, duplicated,
        /// or reordered from the original. If zero indices were passed, an empty font set is returned.
        /// </remarks>
        function GetFilteredFonts(
        {_In_reads_(indexCount)} indices: PUINT32; indexCount: uint32;
        {_COM_Outptr_}  out filteredFontSet: IDWriteFontSet1): HRESULT; stdcall;

        /// Get all the item indices filtered by the given properties.
        /// <param name="properties">List of properties to filter using.</param>
        /// <param name="propertyCount">How many properties to filter.</param>
        /// <param name="selectAnyProperty">Select any property rather rather than the intersection of them all.</param>
        /// <param name="indices">Ascending array of indices [0..GetFontCount() - 1].</param>
        /// <param name="indexCount">Number of indices.</param>
        /// <param name="actualIndexCount">Actual number of indices written or needed [0..GetFontCount()-1].</param>
        /// <returns>
        /// E_NOT_SUFFICIENT_BUFFER if the buffer is too small, with actualIndexCount set to the needed size.
        /// The actualIndexCount will always be <= IDwriteFontSet::GetFontCount.
        /// </returns>
        function GetFilteredFontIndices(
        {_In_reads_(propertyCount)} properties: PDWRITE_FONT_PROPERTY; propertyCount: uint32; selectAnyProperty: boolean;
        {_Out_writes_(maxIndexCount)} indices: PUINT32; maxIndexCount: uint32;
        {_Out_} actualIndexCount: PUINT32): HRESULT; stdcall; overload;

        /// Get all the item indices filtered by the given ranges.
        /// <param name="fontAxisRanges">List of axis ranges.</param>
        /// <param name="fontAxisRangeCount">Number of axis ranges.</param>
        /// <param name="selectAnyRange">Select any property rather rather than the intersection of them all.</param>
        /// <param name="indices">Ascending array of indices [0..GetFontCount() - 1].</param>
        /// <param name="indexCount">Number of indices.</param>
        /// <param name="actualIndexCount">Actual number of indices written or needed [0..GetFontCount()-1].</param>
        /// <returns>
        /// E_NOT_SUFFICIENT_BUFFER if the buffer is too small, with actualIndexCount set to the needed size.
        /// </returns>
        function GetFilteredFontIndices(
        {_In_reads_(fontAxisRangeCount)} fontAxisRanges: PDWRITE_FONT_AXIS_RANGE; fontAxisRangeCount: uint32; selectAnyRange: boolean;
        {_Out_writes_(maxIndexCount)} indices: PUINT32; maxIndexCount: uint32;
        {_Out_} actualIndexCount: PUINT32): HRESULT; stdcall; overload;

        /// Gets all axis ranges in the font set, the union of all contained items.
        /// <param name="fontAxisRanges">List of axis ranges.</param>
        /// <param name="fontAxisRangeCount">Number of axis ranges.</param>
        /// <param name="actualFontAxisRangeCount">Actual number of axis ranges written or needed.</param>
        /// <returns>
        /// E_NOT_SUFFICIENT_BUFFER if the buffer is too small, with actualFontAxisRangeCount set to the needed size.
        /// </returns>
        function GetFontAxisRanges(
        {_Out_writes_(maxFontAxisRangeCount)} fontAxisRanges: PDWRITE_FONT_AXIS_RANGE; maxFontAxisRangeCount: uint32;
        {_Out_} actualFontAxisRangeCount: PUINT32): HRESULT; stdcall; overload;

        /// Get the axis ranges of a single item.
        /// <param name="listIndex">Zero-based index of the font in the set.</param>
        /// <param name="fontAxisRanges">List of axis ranges.</param>
        /// <param name="fontAxisRangeCount">Number of axis ranges.</param>
        /// <param name="actualFontAxisRangeCount">Actual number of axis ranges written or needed.</param>
        /// <returns>
        /// E_NOT_SUFFICIENT_BUFFER if the buffer is too small, with actualFontAxisRangeCount set to the needed size.
        /// </returns>
        function GetFontAxisRanges(listIndex: uint32;
        {_Out_writes_(maxFontAxisRangeCount)} fontAxisRanges: PDWRITE_FONT_AXIS_RANGE; maxFontAxisRangeCount: uint32;
        {_Out_} actualFontAxisRangeCount: PUINT32): HRESULT; stdcall; overload;

        /// Get the font face reference of a single item.
        /// <param name="listIndex">Zero-based index of the font item in the set.</param>
        /// <param name="fontFaceReference">Receives a pointer to the font face reference.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFontFaceReference(listIndex: uint32;
        {_COM_Outptr_}  out fontFaceReference: IDWriteFontFaceReference1): HRESULT; stdcall;

        /// Create the font resource of a single item.
        /// <param name="listIndex">Zero-based index of the font item in the set.</param>
        /// <param name="fontResource">Receives a pointer to the font resource.</param>
        /// <returns>
        /// Standard HRESULT error code, or DWRITE_E_REMOTEFONT if the file is not local.
        /// </returns>
        function CreateFontResource(listIndex: uint32;
        {_COM_Outptr_}  out fontResource: IDWriteFontResource): HRESULT; stdcall;

        /// Create a font face for a single item (rather than going through the font face reference).
        /// <param name="listIndex">Zero-based index of the font item in the set.</param>
        /// <param name="fontFile">Receives a pointer to the font face.</param>
        /// <returns>
        /// Standard HRESULT error code, or DWRITE_E_REMOTEFONT if the file is not local.
        /// </returns>
        function CreateFontFace(listIndex: uint32;
        {_COM_Outptr_}  out fontFace: IDWriteFontFace5): HRESULT; stdcall;

        /// Return the locality of a single item.
        /// <param name="listIndex">Zero-based index of the font item in the set.</param>
        /// <remarks>
        /// The locality enumeration. For fully local files, the result will always
        /// be DWRITE_LOCALITY_LOCAL. For downloadable files, the result depends on how
        /// much of the file has been downloaded.
        /// </remarks>
        /// <returns>
        /// The locality enumeration.
        /// </returns>
        function GetFontLocality(listIndex: uint32): TDWRITE_LOCALITY; stdcall;

    end;

    IDWriteFontList2 = interface(IDWriteFontList1)
        ['{C0763A34-77AF-445A-B735-08C37B0A5BF5}']
        /// Get the underlying font set used by this list.
        /// <param name="fontSet">Contains font set used by the list.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFontSet(
        {_COM_Outptr_}  out fontSet: IDWriteFontSet1): HRESULT; stdcall;

    end;

    IDWriteFontFamily2 = interface(IDWriteFontFamily1)
        ['{3ED49E77-A398-4261-B9CF-C126C2131EF3}']
        /// Gets a list of fonts in the font family ranked in order of how well they match the specified axis values.
        /// <param name="fontAxisValues">List of font axis values.</param>
        /// <param name="fontAxisValueCount">Number of font axis values.</param>
        /// <param name="matchingFonts">Receives a pointer to the newly created font list object.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetMatchingFonts(
        {_In_reads_(fontAxisValueCount)} fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: uint32;
        {_COM_Outptr_}  out matchingFonts: IDWriteFontList2): HRESULT; stdcall;

        /// Get the underlying font set used by this family.
        /// <param name="fontSet">Contains font set used by the family.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFontSet(
        {_COM_Outptr_}  out fontSet: IDWriteFontSet1): HRESULT; stdcall;

    end;

    IDWriteFontCollection2 = interface(IDWriteFontCollection1)
        ['{514039C6-4617-4064-BF8B-92EA83E506E0}']
        /// Creates a font family object given a zero-based font family index.
        /// <param name="index">Zero-based index of the font family.</param>
        /// <param name="fontFamily">Receives a pointer the newly created font family object.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFontFamily(index: uint32;
        {_COM_Outptr_}  out fontFamily: IDWriteFontFamily2): HRESULT; stdcall;

        /// Gets a list of fonts in the specified font family ranked in order of how well they match the specified axis values.
        /// <param name="familyName">Name of the font family. The name is not case-sensitive but must otherwise exactly match a family name in the collection.</param>
        /// <param name="fontAxisValues">List of font axis values.</param>
        /// <param name="fontAxisValueCount">Number of font axis values.</param>
        /// <param name="matchingFonts">Receives a pointer to the newly created font list object.</param>
        /// <remarks>
        /// If no fonts matched, the list will be empty (GetFontCount returns 0),
        /// but the function does not return an error.
        /// </remarks>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetMatchingFonts(
        {_In_z_} familyName: PWCHAR;
        {_In_reads_(fontAxisValueCount)} fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: uint32;
        {_COM_Outptr_}  out fontList: IDWriteFontList2): HRESULT; stdcall;

        /// Get the font family model used by the font collection to group families.
        /// <returns>
        /// Family model enumeration.
        /// </returns>
        function GetFontFamilyModel(): TDWRITE_FONT_FAMILY_MODEL; stdcall;

        /// Get the underlying font set used by this collection.
        /// <param name="fontSet">Contains font set used by the collection.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFontSet(
        {_COM_Outptr_}  out fontSet: IDWriteFontSet1): HRESULT; stdcall;

    end;

    IDWriteTextLayout4 = interface(IDWriteTextLayout3)
        ['{05A9BF42-223F-4441-B5FB-8263685F55E9}']
        /// Set values for font axes over a range of text.
        /// <param name="fontAxisValues">List of font axis values.</param>
        /// <param name="fontAxisValueCount">Number of font axis values.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function SetFontAxisValues(
        {_In_reads_(fontAxisValueCount)} fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: uint32; textRange: TDWRITE_TEXT_RANGE): HRESULT; stdcall;

        /// Get the number of axes set on the text position.
        function GetFontAxisValueCount(currentPosition: uint32): uint32; stdcall;

        /// Get the list of font axis values on the text position.
        /// <param name="fontAxisValues">List of font axis values.</param>
        /// <param name="fontAxisValueCount">Maximum number of font axis values to write.</param>
        /// <returns>
        /// Standard HRESULT error code, or E_INVALIDARG if fontAxisValueCount doesn't match GetFontAxisValueCount.
        /// </returns>
        function GetFontAxisValues(currentPosition: uint32;
        {_Out_writes_(fontAxisValueCount)} fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: uint32;
        {_Out_opt_} textRange: PDWRITE_TEXT_RANGE = nil): HRESULT; stdcall;

        /// Get the automatic axis options.
        /// <returns>
        /// Automatic axis options.
        /// </returns>
        function GetAutomaticFontAxes(): TDWRITE_AUTOMATIC_FONT_AXES; stdcall;

        /// Sets the automatic font axis options.
        /// <param name="automaticFontAxes">Automatic font axis options.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function SetAutomaticFontAxes(automaticFontAxes: TDWRITE_AUTOMATIC_FONT_AXES): HRESULT; stdcall;

    end;

    IDWriteTextFormat3 = interface(IDWriteTextFormat2)
        ['{6D3B5641-E550-430D-A85B-B7BF48A93427}']
        /// Set values for font axes of the format.
        /// <param name="fontAxisValues">List of font axis values.</param>
        /// <param name="fontAxisValueCount">Number of font axis values.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function SetFontAxisValues(
        {_In_reads_(fontAxisValueCount)} fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: uint32): HRESULT; stdcall;

        /// Get the number of axes set on the format.
        function GetFontAxisValueCount(): uint32; stdcall;

        /// Get the list of font axis values on the format.
        /// <param name="fontAxisValues">List of font axis values.</param>
        /// <param name="fontAxisValueCount">Maximum number of font axis values to write.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFontAxisValues(
        {_Out_writes_(fontAxisValueCount)} fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: uint32): HRESULT; stdcall;

        /// Get the automatic axis options.
        /// <returns>
        /// Automatic axis options.
        /// </returns>
        function GetAutomaticFontAxes(): TDWRITE_AUTOMATIC_FONT_AXES; stdcall;

        /// Sets the automatic font axis options.
        /// <param name="automaticFontAxes">Automatic font axis options.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function SetAutomaticFontAxes(automaticFontAxes: TDWRITE_AUTOMATIC_FONT_AXES): HRESULT; stdcall;

    end;

    IDWriteFontFallback1 = interface(IDWriteFontFallback)
        ['{2397599D-DD0D-4681-BD6A-F4F31EAADE77}']
        /// Determines an appropriate font to use to render the range of text.
        /// <param name="source">The text source implementation holds the text and locale.</param>
        /// <param name="textLength">Length of the text to analyze.</param>
        /// <param name="baseFontCollection">Default font collection to use.</param>
        /// <param name="baseFamilyName">Family name of the base font. If you pass nullptr, no matching will be done against
        /// the base family.</param>
        /// <param name="fontAxisValues">List of font axis values.</param>
        /// <param name="fontAxisValueCount">Number of font axis values.</param>
        /// <param name="mappedLength">Length of text mapped to the mapped font. This will always be less or equal to the
        /// input text length and greater than zero (if the text length is non-zero) so that the caller advances at
        /// least one character each call.</param>
        /// <param name="mappedFontFace">The font face that should be used to render the first mappedLength characters of the text.
        /// If it returns null, then no known font can render the text, and mappedLength is the number of unsupported
        /// characters to skip.</param>
        /// <param name="scale">Scale factor to multiply the em size of the returned font by.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function MapCharacters(analysisSource: IDWriteTextAnalysisSource; textPosition: uint32; textLength: uint32;
        {_In_opt_} baseFontCollection: IDWriteFontCollection;
        {_In_opt_z_} baseFamilyName: PWCHAR;
        {_In_reads_(fontAxisValueCount)} fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: uint32;
        {_Deref_out_range_(0, textLength)}  mappedLength: PUINT32;
        {_Out_} scale: Psingle;
        {_COM_Outptr_}  out mappedFontFace: IDWriteFontFace5): HRESULT; stdcall;

    end;


    IDWriteFontSet2 = interface(IDWriteFontSet1)
        ['{DC7EAD19-E54C-43AF-B2DA-4E2B79BA3F7F}']
        /// Gets the expiration event for the font set, if any. The expiration event is set on a system font set object if
        /// it is out of date due to fonts being installed, uninstalled, or updated. The client should handle the event by
        /// getting a new system font set.
        /// <returns>
        /// Returns an event handle if called on the system font set, or nullptr if called on a custom font set.
        /// </returns>
        /// <remarks>
        /// The client must not call CloseHandle on the returned event handle. The handle is owned by the font set
        /// object, and remains valid as long as the client holds a reference to the font set. The client can wait
        /// on the returned event or use RegisterWaitForSingleObject to request a callback when the event is set.
        /// </remarks>
        function GetExpirationEvent(): HANDLE; stdcall;

    end;

    IDWriteFontCollection3 = interface(IDWriteFontCollection2)
        ['{A4D055A6-F9E3-4E25-93B7-9E309F3AF8E9}']
        /// Gets the expiration event for the font collection, if any. The expiration event is set on a system font
        /// collection object if it is out of date due to fonts being installed, uninstalled, or updated. The client
        /// should handle the event by getting a new system font collection.
        /// <returns>
        /// Returns an event handle if called on the system font collection, or nullptr if called on a custom font
        /// collection.
        /// </returns>
        /// <remarks>
        /// The client must not call CloseHandle on the returned event handle. The handle is owned by the font collection
        /// object, and remains valid as long as the client holds a reference to the font collection. The client can wait
        /// on the returned event or use RegisterWaitForSingleObject to request a callback when the event is set.
        /// </remarks>
        function GetExpirationEvent(): HANDLE; stdcall;

    end;

    IDWriteFactory7 = interface(IDWriteFactory6)
        ['{35D0E0B3-9076-4D2E-A016-A91B568A06B4}']
        /// Retrieves the set of system fonts.
        /// <param name="includeDownloadableFonts">Include downloadable fonts or only locally installed ones.</param>
        /// <param name="fontSet">Receives a pointer to the font set object, or nullptr in case of failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetSystemFontSet(includeDownloadableFonts: boolean;
        {_COM_Outptr_}  out fontSet: IDWriteFontSet2): HRESULT; stdcall;

        /// Retrieves a collection of fonts grouped into families.
        /// <param name="includeDownloadableFonts">Include downloadable fonts or only locally installed ones.</param>
        /// <param name="fontFamilyModel">How to group families in the collection.</param>
        /// <param name="fontCollection">Receives a pointer to the font collection object, or nullptr in case of failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetSystemFontCollection(includeDownloadableFonts: boolean; fontFamilyModel: TDWRITE_FONT_FAMILY_MODEL;
        {_COM_Outptr_}  out fontCollection: IDWriteFontCollection3): HRESULT; stdcall;

    end;


    /// The font source type identifies the mechanism by which a font came to be included in a font set.
    TDWRITE_FONT_SOURCE_TYPE = (
        /// The font source is unknown or is not any of the other defined font source types.
        DWRITE_FONT_SOURCE_TYPE_UNKNOWN,
        /// The font source is a font file, which is installed for all users on the device.
        DWRITE_FONT_SOURCE_TYPE_PER_MACHINE,
        /// The font source is a font file, which is installed for the current user.
        DWRITE_FONT_SOURCE_TYPE_PER_USER,
        /// The font source is an APPX package, which includes one or more font files.
        /// The font source name is the full name of the package.
        DWRITE_FONT_SOURCE_TYPE_APPX_PACKAGE,
        /// The font source is a font provider for downloadable fonts.
        DWRITE_FONT_SOURCE_TYPE_REMOTE_FONT_PROVIDER
        );

    PDWRITE_FONT_SOURCE_TYPE = ^TDWRITE_FONT_SOURCE_TYPE;

    IDWriteFontSet3 = interface(IDWriteFontSet2)
        ['{7C073EF2-A7F4-4045-8C32-8AB8AE640F90}']
        /// Gets the font source type of the specified font.
        /// <param name="listIndex">Zero-based index of the font.</param>
        function GetFontSourceType(fontIndex: uint32): TDWRITE_FONT_SOURCE_TYPE; stdcall;

        /// Gets the length of the font source name for the specified font.
        /// <param name="listIndex">Zero-based index of the font.</param>
        function GetFontSourceNameLength(listIndex: uint32): uint32; stdcall;

        /// Copies the font source name for the specified font to an output array.
        /// <param name="listIndex">Zero-based index of the font.</param>
        /// <param name="stringBuffer">Character array that receives the string.</param>
        /// <param name="stringBufferSize">Size of the array in characters. The size must include space for the terminating
        /// null character.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFontSourceName(listIndex: uint32;
        {_Out_writes_z_(stringBufferSize)} stringBuffer: PWCHAR; stringBufferSize: uint32): HRESULT; stdcall;

    end;


    IDWriteFontFace6 = interface(IDWriteFontFace5)
        ['{C4B1FE1B-6E84-47D5-B54C-A597981B06AD}']
        /// Creates a localized strings object that contains the family names for the font, indexed by locale name.
        /// <param name="fontFamilyModel">Specifies how fonts are grouped into families, which affects the family name property.</param>
        /// <param name="names">Receives a pointer to an object to contains the font family names, indexed by locale.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFamilyNames(fontFamilyModel: TDWRITE_FONT_FAMILY_MODEL;
        {_COM_Outptr_}  out names: IDWriteLocalizedStrings): HRESULT; stdcall;

        /// Creates a localized strings object that contains the face names for the font, indexed by locale name.
        /// <param name="fontFamilyModel">Specifies how fonts are grouped into families, which affects the face name property.</param>
        /// <param name="names">Receives a pointer to an object to contains the font face names, indexed by locale.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetFaceNames(fontFamilyModel: TDWRITE_FONT_FAMILY_MODEL;
        {_COM_Outptr_}  out names: IDWriteLocalizedStrings): HRESULT; stdcall;

    end;


    IDWriteFontSet4 = interface(IDWriteFontSet3)
        ['{EEC175FC-BEA9-4C86-8B53-CCBDD7DF0C82}']
        /// Computes derived font axis values from the specified font weight, stretch, style, and size.
        /// <param name="inputAxisValues">Pointer to an optional array of input axis values. Axes present
        /// in this array are excluded from the output. This is so explicit axis values take precedence over
        /// derived axis values.</param>
        /// <param name="inputAxisCount">Size of the array of input axis values.</param>
        /// <param name="fontWeight">Font weight, used to compute "wght" axis value.</param>
        /// <param name="fontStretch">Font stretch, used to compute "wdth" axis value.</param>
        /// <param name="fontStyle">Font style, used to compute "slnt" and "ital" axis values.</param>
        /// <param name="fontSize">Font size in DIPs, used to compute "opsz" axis value. If this parameter is zero,
        /// no "opsz" axis value is added to the output array.</param>
        /// <param name="outputAxisValues">Pointer to an output array to which derived axis values are written.
        /// The size of this array must be at least DWRITE_STANDARD_FONT_AXIS_COUNT (5). The return value is
        /// the actual number of axis values written to this array.</param>
        /// <returns>Returns the actual number of derived axis values written to the output array.</returns>
        /// <remarks>The caller should concatenate the output axis values to the input axis values (if any),
        /// and pass the combined axis values to the GetMatchingFonts method. This does not result in duplicates
        /// because the output does not include any axes present in the inputAxisValues array.
        /// </remarks>
        function ConvertWeightStretchStyleToFontAxisValues(
        {_In_reads_opt_(inputAxisCount)} inputAxisValues: PDWRITE_FONT_AXIS_VALUE; inputAxisCount: uint32; fontWeight: TDWRITE_FONT_WEIGHT; fontStretch: TDWRITE_FONT_STRETCH; fontStyle: TDWRITE_FONT_STYLE; fontSize: single;
        {_Out_writes_to_(DWRITE_STANDARD_FONT_AXIS_COUNT, return)} outputAxisValues: PDWRITE_FONT_AXIS_VALUE): uint32; stdcall;

        /// Generates a matching font set based on the requested inputs, ordered so that nearer matches are earlier.
        /// <param name="familyName">Font family name. This can be a typographic family name, weight/stretch/style
        /// family name, GDI (RBIZ) family name, or full name.</param>
        /// <param name="fontAxisValues">Array of font axis values.</param>
        /// <param name="fontAxisValueCount">Number of font axis values.</param>
        /// <param name="allowedSimulations">Specifies which simulations (i.e., algorithmic emboldening and/or slant)
        /// may be applied to matching fonts to better match the specified axis values. No simulations are applied if
        /// this parameter is DWRITE_FONT_SIMULATIONS_NONE (0).</param>
        /// <param name="matchingFonts">Receives a pointer to a newly-created font set, which contains a prioritized
        /// list of fonts that match the specified inputs.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// This can yield distinct items that were not in the original font set, including items with simulation flags
        /// (if they would be a closer match to the request) and instances that were not named by the font author.
        /// Items from the same font resources are collapsed into one, the closest possible match.
        /// </remarks>
        function GetMatchingFonts(
        {_In_z_} familyName: PWCHAR;
        {_In_reads_(fontAxisValueCount)} fontAxisValues: PDWRITE_FONT_AXIS_VALUE; fontAxisValueCount: uint32; allowedSimulations: TDWRITE_FONT_SIMULATIONS;
        {_COM_Outptr_}  out matchingFonts: IDWriteFontSet4): HRESULT; stdcall;

    end;


    /// Contains information about a bitmap associated with an IDWriteBitmapRenderTarget.
    /// The bitmap is top-down with 32-bits per pixel and no padding between scan lines.
    TDWRITE_BITMAP_DATA_BGRA32 = record
        Width: uint32;
        Height: uint32;
        {_Field_size_(width * height)} pixels: PUINT32;
    end;
    PDWRITE_BITMAP_DATA_BGRA32 = ^TDWRITE_BITMAP_DATA_BGRA32;

    /// Encapsulates a bitmap which can be used for rendering glyphs.
    IDWriteBitmapRenderTarget2 = interface(IDWriteBitmapRenderTarget1)
        ['{C553A742-FC01-44DA-A66E-B8B9ED6C3995}']
        /// Gets the demensions and a pointer to the system memory bitmap encapsulated by this
        /// bitmap render target object. The pointer is owned by the render target object, and
        /// remains valid as long as the object exists.
        function GetBitmapData(
        {_Out_} bitmapData: PDWRITE_BITMAP_DATA_BGRA32): HRESULT; stdcall;

    end;

    /// Defines known feature level for use with the IDWritePaintReader interface and
    /// related APIs. A feature level represents a level of functionality. For example, it
    /// determines what DWRITE_PAINT_TYPE values might be returned.
    /// <remarks>
    /// See the DWRITE_PAINT_TYPE enumeration for which paint types are required for each
    /// feature level.
    /// </remarks>
    TDWRITE_PAINT_FEATURE_LEVEL = (
        /// No paint API support.
        DWRITE_PAINT_FEATURE_LEVEL_NONE = 0,
        /// Specifies a level of functionality corresponding to OpenType COLR version 0.
        DWRITE_PAINT_FEATURE_LEVEL_COLR_V0 = 1,
        /// Specifies a level of functionality corresponding to OpenType COLR version 1.
        DWRITE_PAINT_FEATURE_LEVEL_COLR_V1 = 2
        );

    PDWRITE_PAINT_FEATURE_LEVEL = ^TDWRITE_PAINT_FEATURE_LEVEL;

    /// Combination of flags specifying attributes of a color glyph or of specific color values in
    /// a color glyph.
    TDWRITE_PAINT_ATTRIBUTES = (
        DWRITE_PAINT_ATTRIBUTES_NONE = 0,
        /// Specifies that the color value (or any color value in the glyph) comes from the font's
        /// color palette. This means the appearance may depend on the current palette index, which
        /// may be important to clients that cache color glyphs.
        DWRITE_PAINT_ATTRIBUTES_USES_PALETTE = $01,
        /// Specifies that the color value (or any color value in the glyph) comes from the client-specified
        /// text color. This means the appearance may depend on the text color, which may be important to
        /// clients that cache color glyphs.
        DWRITE_PAINT_ATTRIBUTES_USES_TEXT_COLOR = $02
        );

    PDWRITE_PAINT_ATTRIBUTES = ^TDWRITE_PAINT_ATTRIBUTES;

    /// Represents a color in a color glyph.


    TDWRITE_PAINT_COLOR = record
        /// Color value (not premultiplied). See the colorAttributes member for information about how
        /// the color is determined.
        Value: TDWRITE_COLOR_F;
        /// If the colorAttributes member is DWRITE_PAINT_ATTRIBUTES_USES_PALETTE, this member is
        /// the index of a palette entry in the selected color palette. Otherwise, this member is
        /// DWRITE_NO_PALETTE_INDEX (0xFFFF).
        paletteEntryIndex: uint16;
        /// Specifies an alpha value multiplier in the range 0 to 1 that was used to compute the color
        /// value. Color glyph descriptions may include alpha values to be multiplied with the alpha
        /// values of palette entries.
        alphaMultiplier: single;
        /// Specifies how the color value is determined. If this member is
        /// DWRITE_PAINT_ATTRIBUTES_USES_PALETTE, the color value is determined by getting the color at
        /// paletteEntryIndex in the current color palette. The color's alpha value is then multiplied
        /// by alphaMultiplier. If a font has multiple color palettes, a client can set the current color
        /// palette using the IDWritePaintReader::SetColorPaletteIndex method. A client that uses a custom
        /// palette can use the paletteEntryIndex and alphaMultiplier methods to compute the color. If this
        /// member is DWRITE_PAINT_ATTRIBUTES_USES_TEXT_COLOR, the color value is equal to the text
        /// foreground color, which can be set using the IDWritePaintReader::SetTextColor method.
        colorAttributes: TDWRITE_PAINT_ATTRIBUTES;
    end;
    PDWRITE_PAINT_COLOR = ^TDWRITE_PAINT_COLOR;


    /// Specifies a composite mode for combining source and destination paint elements in a
    /// color glyph. These are taken from the W3C Compositing and Blending Level 1 specification.
    TDWRITE_COLOR_COMPOSITE_MODE = (
        // Porter-Duff modes.
        DWRITE_COLOR_COMPOSITE_CLEAR,
        DWRITE_COLOR_COMPOSITE_SRC,
        DWRITE_COLOR_COMPOSITE_DEST,
        DWRITE_COLOR_COMPOSITE_SRC_OVER,
        DWRITE_COLOR_COMPOSITE_DEST_OVER,
        DWRITE_COLOR_COMPOSITE_SRC_IN,
        DWRITE_COLOR_COMPOSITE_DEST_IN,
        DWRITE_COLOR_COMPOSITE_SRC_OUT,
        DWRITE_COLOR_COMPOSITE_DEST_OUT,
        DWRITE_COLOR_COMPOSITE_SRC_ATOP,
        DWRITE_COLOR_COMPOSITE_DEST_ATOP,
        DWRITE_COLOR_COMPOSITE_XOR,
        DWRITE_COLOR_COMPOSITE_PLUS,
        // Separable color blend modes.
        DWRITE_COLOR_COMPOSITE_SCREEN,
        DWRITE_COLOR_COMPOSITE_OVERLAY,
        DWRITE_COLOR_COMPOSITE_DARKEN,
        DWRITE_COLOR_COMPOSITE_LIGHTEN,
        DWRITE_COLOR_COMPOSITE_COLOR_DODGE,
        DWRITE_COLOR_COMPOSITE_COLOR_BURN,
        DWRITE_COLOR_COMPOSITE_HARD_LIGHT,
        DWRITE_COLOR_COMPOSITE_SOFT_LIGHT,
        DWRITE_COLOR_COMPOSITE_DIFFERENCE,
        DWRITE_COLOR_COMPOSITE_EXCLUSION,
        DWRITE_COLOR_COMPOSITE_MULTIPLY,
        // Non-separable color blend modes.
        DWRITE_COLOR_COMPOSITE_HSL_HUE,
        DWRITE_COLOR_COMPOSITE_HSL_SATURATION,
        DWRITE_COLOR_COMPOSITE_HSL_COLOR,
        DWRITE_COLOR_COMPOSITE_HSL_LUMINOSITY
        );

    PDWRITE_COLOR_COMPOSITE_MODE = ^TDWRITE_COLOR_COMPOSITE_MODE;

    /// Identifies a type of paint element in a color glyph. A color glyph's visual representation
    /// is defined by a tree of paint elements. A paint element's properties are specified by a
    /// DWRITE_PAINT_ELEMENT structure, which combines a paint type an a union.
    /// <remarks>
    /// For more information about each paint type, see DWRITE_PAINT_ELEMENT.
    /// </remarks>
    TDWRITE_PAINT_TYPE = (
        // The following paint types may be returned for color feature levels greater than
        // or equal to DWRITE_PAINT_FEATURE_LEVEL_COLR_V0.
        DWRITE_PAINT_TYPE_NONE,
        DWRITE_PAINT_TYPE_LAYERS,
        DWRITE_PAINT_TYPE_SOLID_GLYPH,
        // The following paint types may be returned for color feature levels greater than
        // or equal to DWRITE_PAINT_FEATURE_LEVEL_COLR_V1.
        DWRITE_PAINT_TYPE_SOLID,
        DWRITE_PAINT_TYPE_LINEAR_GRADIENT,
        DWRITE_PAINT_TYPE_RADIAL_GRADIENT,
        DWRITE_PAINT_TYPE_SWEEP_GRADIENT,
        DWRITE_PAINT_TYPE_GLYPH,
        DWRITE_PAINT_TYPE_COLOR_GLYPH,
        DWRITE_PAINT_TYPE_TRANSFORM,
        DWRITE_PAINT_TYPE_COMPOSITE
        );

    PDWRITE_PAINT_TYPE = ^TDWRITE_PAINT_TYPE;

    /// Specifies properties of a paint element, which is one node in a visual tree associated
    /// with a color glyph. This is passed as an output parameter to various IDWritePaintReader
    /// methods.
    /// <remarks>
    /// For a detailed description of how paint elements should be rendered, see the OpenType COLR
    /// table specification. Comments below reference the COLR paint record formats associated with
    /// each paint type.
    ///
    /// Note that this structure (and its size) may differ for different versions of the API, as
    /// newer versions may have additional union members for new paint types. For this reason,
    /// IDWritePaintReader methods that take a DWRITE_PAINT_ELEMENT output parameter also take a
    /// structSize parameter, for which the caller should specify actual size of the structure
    /// allocated by the caller, i.e., sizeof(DWRITE_PAINT_ELEMENT). Clients should use caution
    /// when passing DWRITE_PAINT_ELEMENT objects between components that may have been compiled
    /// against different versions of this header file.
    /// </remarks>
    TDWRITE_PAINT_ELEMENT = record
        /// Specifies the paint type, and thus which member of the union is valid.
        paintType: TDWRITE_PAINT_TYPE;
            /// Specifies type-specific properties of the paint element.

        case integer of
            /// Valid for paint elements of type DWRITE_PAINT_TYPE_LAYERS.
            /// Contains one or more child paint elements to be drawn in bottom-up order.
            /// <remarks>
            /// This corresponds to a PaintColrLayers record in the OpenType COLR table.
            /// Or it may correspond to a BaseGlyph record defined by COLR version 0.
            /// </remarks>
            0: (
                layers: record
                    /// Number of child paint elements in bottom-up order. Use the IDWritePaintReader
                    /// interface's MoveFirstChild and MoveNextSibling methods to retrieve the child paint
                    /// elements. Use the MoveParent method to return to the parent element.
                    childCount: uint32;
                    end;
            );
            /// Valid for paint elements of type DWRITE_PAINT_TYPE_SOLID_GLYPH.
            /// Specifies a glyph with a solid color fill.
            /// This paint element has no child elements.
            /// <remarks>
            /// This corresponds to a combination of two paint records in the OpenType COLR table:
            /// a PaintGlyph record, which references either a PaintSolid or PaintVarSolid record.
            /// Or it may correspond to a Layer record defined by COLR version 0.
            /// </remarks>
            1: (
                solidGlyph: record
                    /// Glyph index defining the shape to be filled.
                    glyphIndex: uint32;
                    /// Glyph color used to fill the glyph shape.
                    color: TDWRITE_PAINT_COLOR;
                    end;
            );
            /// Valid for paint elements of type DWRITE_PAINT_TYPE_SOLID.
            /// Specifies a solid color used to fill the current shape or clip.
            /// This paint element has no child elements.
            /// <remarks>
            /// This corresponds to a PaintSolid or PaintVarSolid record in the OpenType COLR table.
            /// </remarks>
            2: (
                solid: TDWRITE_PAINT_COLOR;
            );
            /// Valid for paint elements of type DWRITE_PAINT_TYPE_LINEAR_GRADIENT.
            /// Specifies a linear gradient used to fill the current shape or clip.
            /// This paint element has no child elements.
            /// <remarks>
            /// This corresponds to a PaintLinearGradient or PaintVarLinearGradient record in the OpenType
            /// COLR table.
            /// </remarks>
            3: (
                linearGradient: record
                    /// D2D1_EXTEND_MODE value speciying how colors outside the interval are defined.
                    extendMode: uint32;
                    /// Number of gradient stops. Use the IDWritePaintReader::GetGradientStops method to
                    /// get the gradient stops.
                    gradientStopCount: uint32;
                    /// X coordinate of the start point of the color line.
                    x0: single;
                    /// Y coordinate of the start point of the color line.
                    y0: single;
                    /// X coordinate of the end point of the color line.
                    x1: single;
                    /// Y coordinate of the end point of the color line.
                    y1: single;
                    /// X coordinate of the rotation point of the color line.
                    x2: single;
                    /// Y coordinate of the rotation point of the color line.
                    y2: single;
                    end;
            );
            /// Valid for paint elements of type DWRITE_PAINT_TYPE_RADIAL_GRADIENT.
            /// Specifies a radial gradient used to fill the current shape or clip.
            /// This paint element has no child elements.
            /// <remarks>
            /// This corresponds to a PaintRadialGradient or PaintVarRadialGradient record in the OpenType
            /// COLR table.
            /// </remarks>
            4: (
                radialGradient: record
                    /// D2D1_EXTEND_MODE value speciying how colors outside the interval are defined.
                    extendMode: uint32;
                    /// Number of gradient stops. Use the IDWritePaintReader::GetGradientStops method to
                    /// get the gradient stops.
                    gradientStopCount: uint32;
                    /// Center X coordinate of the start circle.
                    x0: single;
                    /// Center Y coordinate of the start circle.
                    y0: single;
                    /// Radius of the start circle.
                    radius0: single;
                    /// Center X coordinate of the end circle.
                    x1: single;
                    /// Center Y coordinate of the end circle.
                    y1: single;
                    /// Radius of the end circle.
                    radius1: single;
                    end;
            );

            /// Valid for paint elements of type DWRITE_PAINT_TYPE_SWEEP_GRADIENT.
            /// Specifies a sweep gradient used to fill the current shape or clip.
            /// This paint element has no child elements.
            /// <remarks>
            /// This corresponds to a PaintSweepGradient or PaintVarSweepGradient record in the OpenType
            /// COLR table.
            /// </remarks>

            5: (
                sweepGradient: record
                    /// D2D1_EXTEND_MODE value speciying how colors outside the interval are defined.
                    extendMode: uint32;
                    /// Number of gradient stops. Use the IDWritePaintReader::GetGradientStops method to
                    /// get the gradient stops.
                    gradientStopCount: uint32;
                    /// Center X coordinate.
                    centerX: single;
                    /// Center Y coordinate.
                    centerY: single;
                    /// Start of the angular range of the gradient, measured in counter-clockwise degrees
                    /// from the direction of the positive x axis.
                    startAngle: single;
                    /// End of the angular range of the gradient, measured in counter-clockwise degrees
                    /// from the direction of the positive x axis.
                    endAngle: single;
                    end;
            );
            /// Valid for paint elements of type DWRITE_PAINT_TYPE_GLYPH.
            /// Specifies a glyph shape to be filled or, equivalently, a clip region.
            /// This paint element has one child element.
            /// <remarks>
            /// The child paint element defines how the glyph shape is filled. The child element can be a single paint
            /// element, such as a linear gradient. Or the child element can be the root of a visual tree to be rendered
            /// with the glyph shape as a clip region.
            /// This corresponds to a PaintGlyph record in the OpenType COLR table.
            /// </remarks>

            6: (
                glyph: record
                    /// Glyph index of the glyph that defines the shape to be filled.
                    glyphIndex: uint32;
                    end;
            );
            /// Valid for paint elements of type DWRITE_PAINT_TYPE_COLOR_GLYPH.
            /// Specifies another color glyph, used as a reusable component.
            /// This paint element has one child element, which is the root paint element of the specified color glyph.
            /// <remarks>
            /// This corresponds to a PaintColorGlyph record in the OpenType COLR table.
            /// </remarks>
            7: (
                TPAINT_COLOR_GLYPH: record
                    /// Glyph index of the referenced color glyph.
                    glyphIndex: uint32;
                    /// Clip box of the referenced color glyph, in ems. This is an empty rectangle of the color glyph does
                    /// not specify a clip box. If it is not an empty rect, the client is required to clip the child content
                    /// to this box.
                    clipBox: TD2D_RECT_F;
                    end;
            );
            /// Valid for paint elements of type DWRITE_PAINT_TYPE_TRANSFORM.
            /// Specifies an affine transform to be applied to child content.
            /// This paint element has one child element, which is the transformed content.
            /// <remarks>
            /// This corresponds to paint formats 12 through 31 in the OpenType COLR table.
            /// </remarks>

            8: (
                transform: TDWRITE_MATRIX;
            );
            /// Valid for paint elements of type DWRITE_PAINT_TYPE_COMPOSITE.
            /// Combines the two child paint elements using the specified compositing or blending mode.
            /// This paint element has two child elements. The first child is the paint source. The
            /// second child is the paint destination (or backdrop).
            /// <remarks>
            /// This corresponds to a PaintComposite record in the OpenType COLR table.
            /// </remarks>
            9: (
                composite: record
                    /// Specifies the compositing or blending mode.
                    mode: TDWRITE_COLOR_COMPOSITE_MODE;
                    end;
            );
    end;
    PDWRITE_PAINT_ELEMENT = ^TDWRITE_PAINT_ELEMENT;



    /// Interface used to read color glyph data for a specific font. A color glyph is
    /// represented as a visual tree of paint elements.
    IDWritePaintReader = interface(IUnknown)
        ['{8128E912-3B97-42A5-AB6C-24AAD3A86E54}']
        /// Sets the current glyph and positions the reader on the root paint element of the
        /// selected glyph's visual tree.
        /// <param name="glyphIndex">Glyph index to get the color glyph representation for.</param>
        /// <param name="paintElement">Receives information about the root paint element of the
        /// glyph's visual tree.</param>
        /// <param name="structSize">Size of the DWRITE_PAINT_ELEMENT structure, in bytes.</param>
        /// <param name="clipBox">Receives a precomputed glyph box (in ems) for the specified glyph,
        /// if one is specified by the font. Otherwise, the glyph box is set to an empty rectangle
        /// (all zeros). If a non-empty clip box is specified, the client must clip the color
        /// glyph's representation to the specified box.</param>
        /// <param name="glyphAttributes">Receives optional paint attributes for the glyph.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// If the specified glyph index is not a color glyph, the method succeeds, but the paintType
        /// member of the DWRITE_PAINT_ELEMENT structure is set to DWRITE_PAINT_TYPE_NONE. In this
        /// case, the application should draw the input glyph as a non-color glyph.
        /// </remarks>
        function SetCurrentGlyph(glyphIndex: uint32;
        {_Out_writes_bytes_(structSize)} paintElement: PDWRITE_PAINT_ELEMENT; structSize: uint32;
        {_Out_} clipBox: PD2D_RECT_F;
        {_Out_opt_} glyphAttributes: PDWRITE_PAINT_ATTRIBUTES = nil): HRESULT; stdcall;

        /// Sets the client-defined text color. The default value is transparent black. Changing the text color
        /// can affect the appearance of a glyph if its definition uses the current text color. If this is the
        /// case, the SetCurrentGlyph method returns the DWRITE_PAINT_ATTRIBUTES_USES_TEXT_COLOR flag via the
        /// glyphAttributes output parameter.
        /// <param name="textColor">Specifies the text color.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function SetTextColor(textColor: TDWRITE_COLOR_F): HRESULT; stdcall;

        /// Sets the current color palette index. The default value is zero. Changing the palette index can affect
        /// the appearance of a glyph if its definition references colors in the color palette. If this is the case,
        /// the SetCurrentGlyph method returns the DWRITE_PAINT_ATTRIBUTES_USES_PALETTE flag via the glyphAttributes
        /// output parameter.
        /// <param name="textColor">Specifies the color palette index.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function SetColorPaletteIndex(colorPaletteIndex: uint32): HRESULT; stdcall;

        /// Sets a custom color palette with client-defined palette entries instead of using a font-defined color
        /// palette. Changing the color palette can affect the appearance of a glyph if its definition references
        /// colors in the color palette. If this is the case, the SetCurrentGlyph method returns the
        /// DWRITE_PAINT_ATTRIBUTES_USES_PALETTE flag via the glyphAttributes output parameter.
        /// <param name="paletteEntries">Array of palette entries for the client-defined color palette.</param>
        /// <param name="paletteEntryCount">Size of the paletteEntries array. This must equal the font's palette
        /// entry count as returned by IDWriteFontFace2::GetPaletteEntryCount.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function SetCustomColorPalette(
        {_In_reads_(paletteEntryCount)} paletteEntries: PDWRITE_COLOR_F; paletteEntryCount: uint32): HRESULT; stdcall;

        /// Sets the current position in the visual tree to the first child of the current paint element, and returns
        /// the newly-selected element's properties via the paintElement output parameter.
        /// <param name="paintElement">Receives the properties of the newly-selected element.</param>
        /// <param name="structSize">Size of the DWRITE_PAINT_ELEMENT structure, in bytes.</param>
        /// <returns>
        /// Standard HRESULT error code. The return value is E_INVALIDARG if the current paint element doesn't have
        /// any children.
        /// </returns>
        /// <remarks>
        /// Whether a paint element has children (and how many) can be determined a priori from its paint type and
        /// properties. For more information, see DWRITE_PAINT_ELEMENT.
        /// </remarks>
        function MoveToFirstChild(
        {_Out_writes_bytes_(structSize)} paintElement: PDWRITE_PAINT_ELEMENT; structSize: uint32 = sizeof(TDWRITE_PAINT_ELEMENT)): HRESULT; stdcall;

        /// Sets the current position in the visual tree to the next sibling of the current paint element, and returns
        /// the newly-selected element's properties via the paintElement output parameter.
        /// <param name="paintElement">Receives the properties of the newly-selected element.</param>
        /// <param name="structSize">Size of the DWRITE_PAINT_ELEMENT structure, in bytes.</param>
        /// <returns>
        /// Standard HRESULT error code. The return value is E_INVALIDARG if the current paint element doesn't have
        /// a next sibling.
        /// </returns>
        /// <remarks>
        /// Whether a paint element has children (and how many) can be determined a priori from its paint type and
        /// properties. For more information, see DWRITE_PAINT_ELEMENT.
        /// </remarks>
        function MoveToNextSibling(
        {_Out_writes_bytes_(structSize)} paintElement: PDWRITE_PAINT_ELEMENT; structSize: uint32 = sizeof(TDWRITE_PAINT_ELEMENT)): HRESULT; stdcall;

        /// Sets the current position in the visual tree to the parent of the current paint element.
        /// <returns>
        /// Standard HRESULT error code. The return value is E_INVALIDARG if the current paint element is the root
        /// element of the visual tree.
        /// </returns>
        function MoveToParent(): HRESULT; stdcall;

        /// Returns gradient stops of the current paint element.
        /// <param name="firstGradientStopIndex">Index of the first gradient stop to get.</param>
        /// <param name="gradientStopCount">Number of gradient stops to get.</param>
        /// <param name="gradientStops">Receives the gradient stops.</param>
        /// <returns>Standard HRESULT error code.</returns>
        /// <remarks>Gradient stops are guaranteed to be in ascending order by position.</remarks>
        function GetGradientStops(firstGradientStopIndex: uint32; gradientStopCount: uint32;
        {_Out_writes_(gradientStopCount)} gradientStops: PD2D1_GRADIENT_STOP): HRESULT; stdcall;

        /// Returns color information about each gradient stop, such as palette indices.
        /// <param name="firstGradientStopIndex">Index of the first gradient stop to get.</param>
        /// <param name="gradientStopCount">Number of gradient stops to get.</param>
        /// <param name="gradientStopColors">Receives the gradient stop colors.</param>
        /// <returns>Standard HRESULT error code.</returns>
        function GetGradientStopColors(firstGradientStopIndex: uint32; gradientStopCount: uint32;
        {_Out_writes_(gradientStopCount)} gradientStopColors: PDWRITE_PAINT_COLOR): HRESULT; stdcall;

    end;

    { IDWritePaintReaderHelper }

    IDWritePaintReaderHelper = type helper for IDWritePaintReader
        // Inline overload of SetCurrentGlyph, in which structSize is implied.
        function SetCurrentGlyph(glyphIndex: uint32;
        {_Out_} paintElement: PDWRITE_PAINT_ELEMENT;
        {_Out_} clipBox: PD2D_RECT_F;
        {_Out_opt_} glyphAttributes: PDWRITE_PAINT_ATTRIBUTES = nil): HRESULT; stdcall; overload;
    end;

    IDWriteFontFace7 = interface(IDWriteFontFace6)
        ['{3945B85B-BC95-40F7-B72C-8B73BFC7E13B}']
        /// Returns the maximum paint feature level supported for the specified glyph image format.
        /// Possible values are specified by the DWRITE_PAINT_FEATURE_LEVEL enumeration,
        /// but additional feature levels may be added over time.
        /// <param name="glyphImageFormat">Glyph image format to get the paint feature level for.
        /// The return value is zero if the image format is not supported by the IDWritePaintReader API,
        /// or if the font doesn't contain image data in that format.</param>
        function GetPaintFeatureLevel(glyphImageFormat: TDWRITE_GLYPH_IMAGE_FORMATS): TDWRITE_PAINT_FEATURE_LEVEL; stdcall;

        /// Creates a paint reader object, which can be used to retrieve vector graphic information
        /// for color glyphs in the font.
        /// <param name="glyphImageFormat">Specifies the type of glyph data the reader will obtain. The only
        /// glyph image format currently supported by this method is DWRITE_GLYPH_IMAGE_FORMATS_COLR_PAINT_TREE.</param>
        /// <param name="paintFeatureLevel">Specifies the maximum paint feature level supported by the client.
        /// This affects the types of paint elements that may be returned by the paint reader.</param>
        /// <param name="paintReader">Receives a pointer to the newly-created object.</param>
        /// <returns>Standard HRESULT error code.</returns>
        function CreatePaintReader(glyphImageFormat: TDWRITE_GLYPH_IMAGE_FORMATS; paintFeatureLevel: TDWRITE_PAINT_FEATURE_LEVEL;
        {_COM_Outptr_}  out paintReader: IDWritePaintReader): HRESULT; stdcall;

    end;

    IDWriteFactory8 = interface(IDWriteFactory7)
        ['{EE0A7FB5-DEF4-4C23-A454-C9C7DC878398}']
        /// Translates a glyph run to a sequence of color glyph runs, which can be
        /// rendered to produce a color representation of the original "base" run.
        /// <param name="baselineOriginX">Horizontal and vertical origin of the base glyph run in
        /// pre-transform coordinates.</param>
        /// <param name="glyphRun">Pointer to the original "base" glyph run.</param>
        /// <param name="glyphRunDescription">Optional glyph run description.</param>
        /// <param name="desiredGlyphImageFormats">Which data formats TranslateColorGlyphRun
        /// should split the runs into.</param>
        /// <param name="paintFeatureLevel">Paint feature level supported by the caller. Used
        /// when desiredGlyphImageFormats includes DWRITE_GLYPH_IMAGE_FORMATS_COLR_PAINT_TREE. See
        /// DWRITE_PAINT_FEATURE_LEVEL for more information.</param>
        /// <param name="measuringMode">Measuring mode, needed to compute the origins
        /// of each glyph.</param>
        /// <param name="worldToDeviceTransform">Matrix converting from the client's
        /// coordinate space to device coordinates (pixels), i.e., the world transform
        /// multiplied by any DPI scaling.</param>
        /// <param name="colorPaletteIndex">Zero-based index of the color palette to use.
        /// Valid indices are less than the number of palettes in the font, as returned
        /// by IDWriteFontFace2::GetColorPaletteCount.</param>
        /// <param name="colorEnumerator">If the function succeeds, receives a pointer
        /// to an enumerator object that can be used to obtain the color glyph runs.
        /// If the base run has no color glyphs, then the output pointer is NULL
        /// and the method returns DWRITE_E_NOCOLOR.</param>
        /// <returns>
        /// Returns DWRITE_E_NOCOLOR if the font has no color information, the glyph run
        /// does not contain any color glyphs, or the specified color palette index
        /// is out of range. In this case, the client should render the original glyph
        /// run. Otherwise, returns a standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// The old IDWriteFactory2::TranslateColorGlyphRun is equivalent to passing
        /// DWRITE_GLYPH_IMAGE_FORMATS_TRUETYPE|CFF|COLR.
        /// </remarks>
        function TranslateColorGlyphRun(baselineOrigin: TD2D1_POINT_2F;
        {_In_} glyphRun: PDWRITE_GLYPH_RUN;
        {_In_opt_} glyphRunDescription: PDWRITE_GLYPH_RUN_DESCRIPTION; desiredGlyphImageFormats: TDWRITE_GLYPH_IMAGE_FORMATS; paintFeatureLevel: TDWRITE_PAINT_FEATURE_LEVEL; measuringMode: TDWRITE_MEASURING_MODE;
        {_In_opt_} worldAndDpiTransform: PDWRITE_MATRIX; colorPaletteIndex: uint32;
        {_COM_Outptr_}  out colorEnumerator: IDWriteColorGlyphRunEnumerator1): HRESULT; stdcall;

    end;

    /// Encapsulates a bitmap which can be used for rendering glyphs.
    IDWriteBitmapRenderTarget3 = interface(IDWriteBitmapRenderTarget2)
        ['{AEEC37DB-C337-40F1-8E2A-9A41B167B238}']
        /// Returns the paint feature level supported by this render target.
        /// A client can pass the return value of this method to IDWriteFactory8::TranslateColorGlyphRun.
        function GetPaintFeatureLevel(): TDWRITE_PAINT_FEATURE_LEVEL; stdcall;

        /// Draws a glyph run in a "paint" image format returned by IDWriteColorGlyphRunEnumerator1.
        /// <param name="baselineOriginX">X-coordinate of the baseline.</param>
        /// <param name="baselineOriginY">Y-coordinate of the baseline.</param>
        /// <param name="measuringMode">Specifies measuring mode for positioning glyphs in the run.</param>
        /// <param name="glyphRun">The glyph run to draw.</param>
        /// <param name="glyphImageFormat">The image format of the color glyph run, as returned by
        /// IDWriteColorGlyphRunEnumerator1. This must be one of the "paint" image formats.</param>
        /// <param name="textColor">Foreground color of the text, used in cases where a color glyph
        /// uses the text color.</param>
        /// <param name="colorPaletteIndex">Zero-based index of the font-defined color palette to use.</param>
        /// <param name="blackBoxRect">Optional rectangle that receives the bounding box (in pixels not DIPs) of all the pixels affected by
        /// drawing the glyph run. The black box rectangle may extend beyond the dimensions of the bitmap.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function DrawPaintGlyphRun(baselineOriginX: single; baselineOriginY: single; measuringMode: TDWRITE_MEASURING_MODE;
        {_In_} glyphRun: PDWRITE_GLYPH_RUN; glyphImageFormat: TDWRITE_GLYPH_IMAGE_FORMATS; textColor: TCOLORREF; colorPaletteIndex: uint32 = 0;
        {_Out_opt_} blackBoxRect: PRECT = nil): HRESULT; stdcall;

        /// Draws a glyph run, using color representations of glyphs if available in the font.
        /// <param name="baselineOriginX">X-coordinate of the baseline.</param>
        /// <param name="baselineOriginY">Y-coordinate of the baseline.</param>
        /// <param name="measuringMode">Specifies measuring mode for positioning glyphs in the run.</param>
        /// <param name="glyphRun">The glyph run to draw.</param>
        /// <param name="renderingParams">Object that controls rendering behavior.</param>
        /// <param name="textColor">Foreground color of the text.</param>
        /// <param name="colorPaletteIndex">Zero-based index of the font-defined color palette to use.</param>
        /// <param name="blackBoxRect">Optional rectangle that receives the bounding box (in pixels not DIPs) of all the pixels affected by
        /// drawing the glyph run. The black box rectangle may extend beyond the dimensions of the bitmap.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// This method internally calls TranslateColorGlyphRun and then automatically calls the appropriate
        /// lower-level methods to render monochrome or color glyph runs.
        /// </remarks>
        function DrawGlyphRunWithColorSupport(baselineOriginX: single; baselineOriginY: single; measuringMode: TDWRITE_MEASURING_MODE;
        {_In_} glyphRun: PDWRITE_GLYPH_RUN;
        {_In_} renderingParams: IDWriteRenderingParams; textColor: TCOLORREF; colorPaletteIndex: uint32 = 0;
        {_Out_opt_} blackBoxRect: PRECT = nil): HRESULT; stdcall;

    end;

implementation


{ IDWritePaintReaderHelper }

function IDWritePaintReaderHelper.SetCurrentGlyph(glyphIndex: uint32; paintElement: PDWRITE_PAINT_ELEMENT; clipBox: PD2D_RECT_F; glyphAttributes: PDWRITE_PAINT_ATTRIBUTES): HRESULT; stdcall;
begin
    Result := SetCurrentGlyph(glyphIndex, paintElement, sizeof(TDWRITE_PAINT_ELEMENT), clipBox, glyphAttributes);
end;

end.
