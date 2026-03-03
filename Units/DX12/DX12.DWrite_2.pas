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
   File name: dwrite_2.h
   Header version: 10.0.26100.6584
   
  ************************************************************************** }
unit DX12.DWrite_2;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.DCommon,
    DX12.DWrite,
    DX12.DWrite_1;

    {$Z4}

const

    /// Reserved palette entry index that does not specify any palette entry.
    DWRITE_NO_PALETTE_INDEX = $FFFF;

    IID_IDWriteTextRenderer1: TGUID = '{D3E0E934-22A0-427E-AAE4-7D9574B59DB1}';
    IID_IDWriteTextFormat1: TGUID = '{5F174B49-0D8B-4CFB-8BCA-F1CCE9D06C67}';
    IID_IDWriteTextLayout2: TGUID = '{1093C18F-8D5E-43F0-B064-0917311B525E}';
    IID_IDWriteTextAnalyzer2: TGUID = '{553A9FF3-5693-4DF7-B52B-74806F7F2EB9}';
    IID_IDWriteFontFallback: TGUID = '{EFA008F9-F7A1-48BF-B05C-F224713CC0FF}';
    IID_IDWriteFontFallbackBuilder: TGUID = '{FD882D06-8ABA-4FB8-B849-8BE8B73E14DE}';
    IID_IDWriteFont2: TGUID = '{29748ed6-8c9c-4a6a-be0b-d912e8538944}';
    IID_IDWriteFontFace2: TGUID = '{d8b768ff-64bc-4e66-982b-ec8e87f693f7}';
    IID_IDWriteColorGlyphRunEnumerator: TGUID = '{d31fbe17-f157-41a2-8d24-cb779e0560e8}';
    IID_IDWriteRenderingParams2: TGUID = '{F9D711C3-9777-40AE-87E8-3E5AF9BF0948}';
    IID_IDWriteFactory2: TGUID = '{0439fc60-ca44-4994-8dee-3a9af7b732ec}';

type

    IDWriteFontFallback = interface;

    /// How to align glyphs to the margin.
    TDWRITE_OPTICAL_ALIGNMENT = (
        /// Align to the default metrics of the glyph.
        DWRITE_OPTICAL_ALIGNMENT_NONE,
        /// Align glyphs to the margins. Without this, some small whitespace
        /// may be present between the text and the margin from the glyph's side
        /// bearing values. Note that glyphs may still overhang outside the
        /// margin, such as flourishes or italic slants.
        DWRITE_OPTICAL_ALIGNMENT_NO_SIDE_BEARINGS
        );

    PDWRITE_OPTICAL_ALIGNMENT = ^TDWRITE_OPTICAL_ALIGNMENT;

    /// Whether to enable grid-fitting of glyph outlines (a.k.a. hinting).
    TDWRITE_GRID_FIT_MODE = (
        /// Choose grid fitting base on the font's gasp table information.
        DWRITE_GRID_FIT_MODE_DEFAULT,
        /// Always disable grid fitting, using the ideal glyph outlines.
        DWRITE_GRID_FIT_MODE_DISABLED,
        /// Enable grid fitting, adjusting glyph outlines for device pixel display.
        DWRITE_GRID_FIT_MODE_ENABLED
        );

    PDWRITE_GRID_FIT_MODE = ^TDWRITE_GRID_FIT_MODE;

    /// Overall metrics associated with text after layout.
    /// All coordinates are in device independent pixels (DIPs).
    TDWRITE_TEXT_METRICS1 = record
        /// The height of the formatted text taking into account the
        /// trailing whitespace at the end of each line, which will
        /// matter for vertical reading directions.
        heightIncludingTrailingWhitespace: single;
    end;
    PDWRITE_TEXT_METRICS1 = ^TDWRITE_TEXT_METRICS1;

    /// The text renderer interface represents a set of application-defined
    /// callbacks that perform rendering of text, inline objects, and decorations
    /// such as underlines.
    IDWriteTextRenderer1 = interface(IDWriteTextRenderer)
        ['{D3E0E934-22A0-427E-AAE4-7D9574B59DB1}']
        /// IDWriteTextLayout::Draw calls this function to instruct the client to
        /// render a run of glyphs.
        /// <param name="clientDrawingContext">The context passed to
        ///     IDWriteTextLayout::Draw.</param>
        /// <param name="baselineOriginX">X-coordinate of the baseline.</param>
        /// <param name="baselineOriginY">Y-coordinate of the baseline.</param>
        /// <param name="orientationAngle">Orientation of the glyph run.</param>
        /// <param name="measuringMode">Specifies measuring method for glyphs in
        ///     the run. Renderer implementations may choose different rendering
        ///     modes for given measuring methods, but best results are seen when
        ///     the rendering mode matches the corresponding measuring mode:
        ///     DWRITE_RENDERING_MODE_CLEARTYPE_NATURAL for DWRITE_MEASURING_MODE_NATURAL
        ///     DWRITE_RENDERING_MODE_CLEARTYPE_GDI_CLASSIC for DWRITE_MEASURING_MODE_GDI_CLASSIC
        ///     DWRITE_RENDERING_MODE_CLEARTYPE_GDI_NATURAL for DWRITE_MEASURING_MODE_GDI_NATURAL
        /// </param>
        /// <param name="glyphRun">The glyph run to draw.</param>
        /// <param name="glyphRunDescription">Properties of the characters
        ///     associated with this run.</param>
        /// <param name="clientDrawingEffect">The drawing effect set in
        ///     IDWriteTextLayout::SetDrawingEffect.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// If a non-identity orientation is passed, the glyph run should be
        /// rotated around the given baseline x and y coordinates. The function
        /// IDWriteAnalyzer2::GetGlyphOrientationTransform will return the
        /// necessary transform for you, which can be combined with any existing
        /// world transform on the drawing context.
        /// </remarks>
        function DrawGlyphRun(
        {_In_opt_} clientDrawingContext: Pvoid; baselineOriginX: single; baselineOriginY: single; orientationAngle: TDWRITE_GLYPH_ORIENTATION_ANGLE; measuringMode: TDWRITE_MEASURING_MODE;
        {_In_} glyphRun: PDWRITE_GLYPH_RUN;
        {_In_} glyphRunDescription: PDWRITE_GLYPH_RUN_DESCRIPTION;
        {_In_opt_} clientDrawingEffect: IUnknown): HRESULT; stdcall;

        /// IDWriteTextLayout::Draw calls this function to instruct the client to draw
        /// an underline.
        /// <param name="clientDrawingContext">The context passed to
        /// IDWriteTextLayout::Draw.</param>
        /// <param name="baselineOriginX">X-coordinate of the baseline.</param>
        /// <param name="baselineOriginY">Y-coordinate of the baseline.</param>
        /// <param name="orientationAngle">Orientation of the underline.</param>
        /// <param name="underline">Underline logical information.</param>
        /// <param name="clientDrawingEffect">The drawing effect set in
        ///     IDWriteTextLayout::SetDrawingEffect.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// A single underline can be broken into multiple calls, depending on
        /// how the formatting changes attributes. If font sizes/styles change
        /// within an underline, the thickness and offset will be averaged
        /// weighted according to characters.
        ///
        /// To get the correct top coordinate of the underline rect, add
        /// underline::offset to the baseline's Y. Otherwise the underline will
        /// be immediately under the text. The x coordinate will always be passed
        /// as the left side, regardless of text directionality. This simplifies
        /// drawing and reduces the problem of round-off that could potentially
        /// cause gaps or a double stamped alpha blend. To avoid alpha overlap,
        /// round the end points to the nearest device pixel.
        /// </remarks>
        function DrawUnderline(
        {_In_opt_} clientDrawingContext: Pvoid; baselineOriginX: single; baselineOriginY: single; orientationAngle: TDWRITE_GLYPH_ORIENTATION_ANGLE;
        {_In_} underline: PDWRITE_UNDERLINE;
        {_In_opt_} clientDrawingEffect: IUnknown): HRESULT; stdcall;

        /// IDWriteTextLayout::Draw calls this function to instruct the client to draw
        /// a strikethrough.
        /// <param name="clientDrawingContext">The context passed to
        /// IDWriteTextLayout::Draw.</param>
        /// <param name="baselineOriginX">X-coordinate of the baseline.</param>
        /// <param name="baselineOriginY">Y-coordinate of the baseline.</param>
        /// <param name="orientationAngle">Orientation of the strikethrough.</param>
        /// <param name="strikethrough">Strikethrough logical information.</param>
        /// <param name="clientDrawingEffect">The drawing effect set in
        ///     IDWriteTextLayout::SetDrawingEffect.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// A single strikethrough can be broken into multiple calls, depending on
        /// how the formatting changes attributes. Strikethrough is not averaged
        /// across font sizes/styles changes.
        /// To get the correct top coordinate of the strikethrough rect,
        /// add strikethrough::offset to the baseline's Y.
        /// Like underlines, the x coordinate will always be passed as the left side,
        /// regardless of text directionality.
        /// </remarks>
        function DrawStrikethrough(
        {_In_opt_} clientDrawingContext: Pvoid; baselineOriginX: single; baselineOriginY: single; orientationAngle: TDWRITE_GLYPH_ORIENTATION_ANGLE;
        {_In_} strikethrough: PDWRITE_STRIKETHROUGH;
        {_In_opt_} clientDrawingEffect: IUnknown): HRESULT; stdcall;

        /// IDWriteTextLayout::Draw calls this application callback when it needs to
        /// draw an inline object.
        /// <param name="clientDrawingContext">The context passed to
        ///     IDWriteTextLayout::Draw.</param>
        /// <param name="originX">X-coordinate at the top-left corner of the
        ///     inline object.</param>
        /// <param name="originY">Y-coordinate at the top-left corner of the
        ///     inline object.</param>
        /// <param name="orientationAngle">Orientation of the inline object.</param>
        /// <param name="inlineObject">The object set using IDWriteTextLayout::SetInlineObject.</param>
        /// <param name="isSideways">The object should be drawn on its side.</param>
        /// <param name="isRightToLeft">The object is in an right-to-left context
        ///     and should be drawn flipped.</param>
        /// <param name="clientDrawingEffect">The drawing effect set in
        ///     IDWriteTextLayout::SetDrawingEffect.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// The right-to-left flag is a hint to draw the appropriate visual for
        /// that reading direction. For example, it would look strange to draw an
        /// arrow pointing to the right to indicate a submenu. The sideways flag
        /// similarly hints that the object is drawn in a different orientation.
        /// If a non-identity orientation is passed, the top left of the inline
        /// object should be rotated around the given x and y coordinates.
        /// IDWriteAnalyzer2::GetGlyphOrientationTransform returns the necessary
        /// transform for this.
        /// </remarks>
        function DrawInlineObject(
        {_In_opt_} clientDrawingContext: Pvoid; originX: single; originY: single; orientationAngle: TDWRITE_GLYPH_ORIENTATION_ANGLE;
        {_In_} inlineObject: IDWriteInlineObject; isSideways: boolean; isRightToLeft: boolean;
        {_In_opt_} clientDrawingEffect: IUnknown): HRESULT; stdcall;

    end;

    /// The format of text used for text layout.
    /// <remarks>
    /// This object may not be thread-safe and it may carry the state of text format change.
    /// </remarks>
    IDWriteTextFormat1 = interface(IDWriteTextFormat)
        ['{5F174B49-0D8B-4CFB-8BCA-F1CCE9D06C67}']
        /// Set the preferred orientation of glyphs when using a vertical reading direction.
        /// <param name="glyphOrientation">Preferred glyph orientation.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function SetVerticalGlyphOrientation(glyphOrientation: TDWRITE_VERTICAL_GLYPH_ORIENTATION): HRESULT; stdcall;

        /// Get the preferred orientation of glyphs when using a vertical reading
        /// direction.
        function GetVerticalGlyphOrientation(): TDWRITE_VERTICAL_GLYPH_ORIENTATION; stdcall;

        /// Set whether or not the last word on the last line is wrapped.
        /// <param name="isLastLineWrappingEnabled">Line wrapping option.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function SetLastLineWrapping(isLastLineWrappingEnabled: boolean): HRESULT; stdcall;

        /// Get whether or not the last word on the last line is wrapped.
        function GetLastLineWrapping(): boolean; stdcall;

        /// Set how the glyphs align to the edges the margin. Default behavior is
        /// to align glyphs using their default glyphs metrics which include side
        /// bearings.
        /// <param name="opticalAlignment">Optical alignment option.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function SetOpticalAlignment(opticalAlignment: TDWRITE_OPTICAL_ALIGNMENT): HRESULT; stdcall;

        /// Get how the glyphs align to the edges the margin.
        function GetOpticalAlignment(): TDWRITE_OPTICAL_ALIGNMENT; stdcall;

        /// Apply a custom font fallback onto layout. If none is specified,
        /// layout uses the system fallback list.
        /// <param name="fontFallback">Custom font fallback created from
        ///     IDWriteFontFallbackBuilder::CreateFontFallback or from
        ///     IDWriteFactory2::GetSystemFontFallback.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function SetFontFallback(fontFallback: IDWriteFontFallback): HRESULT; stdcall;

        /// Get the current font fallback object.
        function GetFontFallback(
        {__out} out fontFallback: IDWriteFontFallback): HRESULT; stdcall;

    end;

    /// The text layout interface represents a block of text after it has
    /// been fully analyzed and formatted.
    ///
    /// All coordinates are in device independent pixels (DIPs).
    IDWriteTextLayout2 = interface(IDWriteTextLayout1)
        ['{1093C18F-8D5E-43F0-B064-0917311B525E}']
        /// GetMetrics retrieves overall metrics for the formatted string.
        /// <param name="textMetrics">The returned metrics.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// Drawing effects like underline and strikethrough do not contribute
        /// to the text size, which is essentially the sum of advance widths and
        /// line heights. Additionally, visible swashes and other graphic
        /// adornments may extend outside the returned width and height.
        /// </remarks>
        function GetMetrics(
        {_Out_} textMetrics: PDWRITE_TEXT_METRICS1): HRESULT; stdcall;

        /// Set the preferred orientation of glyphs when using a vertical reading direction.
        /// <param name="glyphOrientation">Preferred glyph orientation.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function SetVerticalGlyphOrientation(glyphOrientation: TDWRITE_VERTICAL_GLYPH_ORIENTATION): HRESULT; stdcall;

        /// Get the preferred orientation of glyphs when using a vertical reading
        /// direction.
        function GetVerticalGlyphOrientation(): TDWRITE_VERTICAL_GLYPH_ORIENTATION; stdcall;

        /// Set whether or not the last word on the last line is wrapped.
        /// <param name="isLastLineWrappingEnabled">Line wrapping option.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function SetLastLineWrapping(isLastLineWrappingEnabled: boolean): HRESULT; stdcall;

        /// Get whether or not the last word on the last line is wrapped.
        function GetLastLineWrapping(): boolean; stdcall;

        /// Set how the glyphs align to the edges the margin. Default behavior is
        /// to align glyphs using their default glyphs metrics which include side
        /// bearings.
        /// <param name="opticalAlignment">Optical alignment option.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function SetOpticalAlignment(opticalAlignment: TDWRITE_OPTICAL_ALIGNMENT): HRESULT; stdcall;

        /// Get how the glyphs align to the edges the margin.
        function GetOpticalAlignment(): TDWRITE_OPTICAL_ALIGNMENT; stdcall;

        /// Apply a custom font fallback onto layout. If none is specified,
        /// layout uses the system fallback list.
        /// <param name="fontFallback">Custom font fallback created from
        ///     IDWriteFontFallbackBuilder::CreateFontFallback or
        ///     IDWriteFactory2::GetSystemFontFallback.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function SetFontFallback(fontFallback: IDWriteFontFallback): HRESULT; stdcall;

        /// Get the current font fallback object.
        function GetFontFallback(
        {__out} out fontFallback: IDWriteFontFallback): HRESULT; stdcall;

    end;

    /// The text analyzer interface represents a set of application-defined
    /// callbacks that perform rendering of text, inline objects, and decorations
    /// such as underlines.
    IDWriteTextAnalyzer2 = interface(IDWriteTextAnalyzer1)
        ['{553A9FF3-5693-4DF7-B52B-74806F7F2EB9}']
        /// Returns 2x3 transform matrix for the respective angle to draw the
        /// glyph run or other object.
        /// <param name="glyphOrientationAngle">The angle reported to one of the application callbacks,
        ///     including IDWriteTextAnalysisSink1::SetGlyphOrientation and IDWriteTextRenderer1::Draw*.</param>
        /// <param name="isSideways">Whether the run's glyphs are sideways or not.</param>
        /// <param name="originX">X origin of the element, be it a glyph run or underline or other.</param>
        /// <param name="originY">Y origin of the element, be it a glyph run or underline or other.</param>
        /// <param name="transform">Returned transform.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// This rotates around the given origin x and y, returning a translation component
        /// such that the glyph run, text decoration, or inline object is drawn with the
        /// right orientation at the expected coordinate.
        /// </remarks>
        function GetGlyphOrientationTransform(glyphOrientationAngle: TDWRITE_GLYPH_ORIENTATION_ANGLE; isSideways: boolean; originX: single; originY: single;
        {_Out_} transform: PDWRITE_MATRIX): HRESULT; stdcall;

        /// Returns a list of typographic feature tags for the given script and language.
        /// <param name="fontFace">The font face to get features from.</param>
        /// <param name="scriptAnalysis">Script analysis result from AnalyzeScript.</param>
        /// <param name="localeName">The locale to use when selecting the feature,
        ///     such en-us or ja-jp.</param>
        /// <param name="maxTagCount">Maximum tag count.</param>
        /// <param name="actualTagCount">Actual tag count. If greater than
        ///     maxTagCount, E_NOT_SUFFICIENT_BUFFER is returned, and the call
        ///     should be retried with a larger buffer.</param>
        /// <param name="tags">Feature tag list.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetTypographicFeatures(fontFace: IDWriteFontFace; scriptAnalysis: TDWRITE_SCRIPT_ANALYSIS;
        {_In_opt_z_} localeName: PWCHAR; maxTagCount: uint32;
        {_Out_} actualTagCount: PUINT32;
        {_Out_writes_(maxTagCount)} tags: PDWRITE_FONT_FEATURE_TAG): HRESULT; stdcall;

        /// Returns an array of which glyphs are affected by a given feature.
        /// <param name="fontFace">The font face to read glyph information from.</param>
        /// <param name="scriptAnalysis">Script analysis result from AnalyzeScript.</param>
        /// <param name="localeName">The locale to use when selecting the feature,
        ///     such en-us or ja-jp.</param>
        /// <param name="featureTag">OpenType feature name to use, which may be one
        ///     of the DWRITE_FONT_FEATURE_TAG values or a custom feature using
        ///     DWRITE_MAKE_OPENTYPE_TAG.</param>
        /// <param name="glyphCount">Number of glyph indices to check.</param>
        /// <param name="glyphIndices">Glyph indices to check for feature application.</param>
        /// <param name="featureApplies">Output of which glyphs are affected by the
        ///     feature, where for each glyph affected, the respective array index
        ///     will be 1. The result is returned per-glyph without regard to
        ///     neighboring context of adjacent glyphs.</param>
        /// </remarks>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function CheckTypographicFeature(fontFace: IDWriteFontFace; scriptAnalysis: TDWRITE_SCRIPT_ANALYSIS;
        {_In_opt_z_} localeName: PWCHAR; featureTag: TDWRITE_FONT_FEATURE_TAG; glyphCount: uint32;
        {_In_reads_(glyphCount)} glyphIndices: PUINT16;
        {_Out_writes_(glyphCount)} featureApplies: PUINT8): HRESULT; stdcall;

    end;

    /// A font fallback definition used for mapping characters to fonts capable of
    /// supporting them.
    IDWriteFontFallback = interface(IUnknown)
        ['{EFA008F9-F7A1-48BF-B05C-F224713CC0FF}']
        /// Determines an appropriate font to use to render the range of text.
        /// <param name="source">The text source implementation holds the text and
        ///     locale.</param>
        /// <param name="textLength">Length of the text to analyze.</param>
        /// <param name="baseFontCollection">Default font collection to use.</param>
        /// <param name="baseFamilyName">Family name of the base font. If you pass
        ///     null, no matching will be done against the family.</param>
        /// <param name="baseWeight">Desired weight.</param>
        /// <param name="baseStyle">Desired style.</param>
        /// <param name="baseStretch">Desired stretch.</param>
        /// <param name="mappedLength">Length of text mapped to the mapped font.
        ///     This will always be less or equal to the input text length and
        ///     greater than zero (if the text length is non-zero) so that the
        ///     caller advances at least one character each call.</param>
        /// <param name="mappedFont">The font that should be used to render the
        ///     first mappedLength characters of the text. If it returns NULL,
        ///     then no known font can render the text, and mappedLength is the
        ///     number of unsupported characters to skip.</param>
        /// <param name="scale">Scale factor to multiply the em size of the
        ///     returned font by.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function MapCharacters(analysisSource: IDWriteTextAnalysisSource; textPosition: uint32; textLength: uint32;
        {_In_opt_} baseFontCollection: IDWriteFontCollection;
        {_In_opt_z_} baseFamilyName: pwidechar; baseWeight: TDWRITE_FONT_WEIGHT; baseStyle: TDWRITE_FONT_STYLE; baseStretch: TDWRITE_FONT_STRETCH;
        {_Out_range_(0, textLength)} mappedLength: PUINT32;
        {_COM_Outptr_result_maybenull_}  out mappedFont: IDWriteFont;
        {_Out_} scale: Psingle): HRESULT; stdcall;

    end;

    /// Builder used to create a font fallback definition by appending a series of
    /// fallback mappings, followed by a creation call.
    /// <remarks>
    /// This object may not be thread-safe.
    /// </remarks>
    IDWriteFontFallbackBuilder = interface(IUnknown)
        ['{FD882D06-8ABA-4FB8-B849-8BE8B73E14DE}']
        /// Appends a single mapping to the list. Call this once for each additional mapping.
        /// <param name="ranges">Unicode ranges that apply to this mapping.</param>
        /// <param name="rangesCount">Number of Unicode ranges.</param>
        /// <param name="localeName">Locale of the context (e.g. document locale).</param>
        /// <param name="baseFamilyName">Base family name to match against, if applicable.</param>
        /// <param name="fontCollection">Explicit font collection for this mapping (optional).</param>
        /// <param name="targetFamilyNames">List of target family name strings.</param>
        /// <param name="targetFamilyNamesCount">Number of target family names.</param>
        /// <param name="scale">Scale factor to multiply the result target font by.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function AddMapping(
        {_In_reads_(rangesCount)} ranges: PDWRITE_UNICODE_RANGE; rangesCount: uint32;
        {_In_reads_(targetFamilyNamesCount)} targetFamilyNames: PWCHAR; targetFamilyNamesCount: uint32;
        {_In_opt_} fontCollection: IDWriteFontCollection = nil;
        {_In_opt_z_} localeName: PWCHAR = nil;
        {_In_opt_z_} baseFamilyName: PWCHAR = nil; scale: single = 1.0): HRESULT; stdcall;

        /// Appends all the mappings from an existing font fallback object.
        /// <param name="fontFallback">Font fallback to read mappings from.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function AddMappings(fontFallback: IDWriteFontFallback): HRESULT; stdcall;

        /// Creates the finalized fallback object from the mappings added.
        /// <param name="fontFallback">Created fallback list.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function CreateFontFallback(
        {_COM_Outptr_}  out fontFallback: IDWriteFontFallback): HRESULT; stdcall;

    end;

    T_D3DCOLORVALUE = record
        case integer of
            0: (
                r: single;
                g: single;
                b: single;
                a: single;
            );
            1: (
                dvR: single;
                dvG: single;
                dvB: single;
                dvA: single;
            );
    end;
    P_D3DCOLORVALUE = ^T_D3DCOLORVALUE;

    TD3DCOLORVALUE = T_D3DCOLORVALUE;

    TDWRITE_COLOR_F = TD3DCOLORVALUE;
    PDWRITE_COLOR_F = ^TDWRITE_COLOR_F;

    /// The IDWriteFont interface represents a physical font in a font collection.
    IDWriteFont2 = interface(IDWriteFont1)
        ['{29748ed6-8c9c-4a6a-be0b-d912e8538944}']
        /// Returns TRUE if the font contains tables that can provide color information
        /// (including COLR, CPAL, SVG, CBDT, sbix  tables), or FALSE if not. Note that
        /// TRUE is returned even in the case when the font tables contain only grayscale
        /// images.
        function IsColorFont(): boolean; stdcall;

    end;

    /// The interface that represents an absolute reference to a font face.
    /// It contains font face type, appropriate file references and face identification data.
    /// Various font data such as metrics, names and glyph outlines is obtained from IDWriteFontFace.
    IDWriteFontFace2 = interface(IDWriteFontFace1)
        ['{d8b768ff-64bc-4e66-982b-ec8e87f693f7}']
        /// Returns TRUE if the font contains tables that can provide color information
        /// (including COLR, CPAL, SVG, CBDT, sbix  tables), or FALSE if not. Note that
        /// TRUE is returned even in the case when the font tables contain only grayscale
        /// images.
        function IsColorFont(): boolean; stdcall;

        /// Returns the number of color palettes defined by the font. The return
        /// value is zero if the font has no color information. Color fonts must
        /// have at least one palette, with palette index zero being the default.
        function GetColorPaletteCount(): uint32; stdcall;

        /// Returns the number of entries in each color palette. All color palettes
        /// in a font have the same number of palette entries. The return value is
        /// zero if the font has no color information.
        function GetPaletteEntryCount(): uint32; stdcall;

        /// Reads color values from the font's color palette.
        /// <param name="colorPaletteIndex">Zero-based index of the color palette. If the
        /// font does not have a palette with the specified index, the method returns
        /// DWRITE_E_NOCOLOR.<param>
        /// <param name="firstEntryIndex">Zero-based index of the first palette entry
        /// to read.</param>
        /// <param name="entryCount">Number of palette entries to read.</param>
        /// <param name="paletteEntries">Array that receives the color values.<param>
        /// <returns>
        /// Standard HRESULT error code.
        /// The return value is E_INVALIDARG if firstEntryIndex + entryCount is greater
        /// than the actual number of palette entries as returned by GetPaletteEntryCount.
        /// The return value is DWRITE_E_NOCOLOR if the font does not have a palette
        /// with the specified palette index.
        /// </returns>
        function GetPaletteEntries(colorPaletteIndex: uint32; firstEntryIndex: uint32; entryCount: uint32;
        {_Out_writes_(entryCount)} paletteEntries: PDWRITE_COLOR_F): HRESULT; stdcall;

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
        {_Out_} renderingMode: PDWRITE_RENDERING_MODE;
        {_Out_} gridFitMode: PDWRITE_GRID_FIT_MODE): HRESULT; stdcall;

    end;

    /// Represents a color glyph run. The IDWriteFactory2::TranslateColorGlyphRun
    /// method returns an ordered collection of color glyph runs, which can be
    /// layered on top of each other to produce a color representation of the
    /// given base glyph run.
    TDWRITE_COLOR_GLYPH_RUN = record
        /// Glyph run to render.
        glyphRun: TDWRITE_GLYPH_RUN;
        /// Optional glyph run description.
        {_Maybenull_} glyphRunDescription: PDWRITE_GLYPH_RUN_DESCRIPTION;
        /// Location at which to draw this glyph run.
        baselineOriginX: single;
        baselineOriginY: single;
        /// Color to use for this layer, if any. If the paletteIndex member is
        /// DWRITE_NO_PALETTE_INDEX (0xFFFF) then no color is specifed by the font,
        /// this member is set to { 0, 0, 0, 0 }, and the client should use the
        /// current foreground brush. Otherwise, this member is set to a color from
        /// the font's color palette, i.e., the same color that would be returned
        /// by IDWriteFontFace2::GetPaletteEntries for the current palette index.
        runColor: TDWRITE_COLOR_F;
        /// Zero-based index of this layer's color entry in the current color
        /// palette, or DWRITE_NO_PALETTE_INDEX (0xFFFF) if this layer
        /// is to be rendered using the current foreground brush.
        paletteIndex: uint16;
    end;
    PDWRITE_COLOR_GLYPH_RUN = ^TDWRITE_COLOR_GLYPH_RUN;

    /// Enumerator for an ordered collection of color glyph runs.
    IDWriteColorGlyphRunEnumerator = interface(IUnknown)
        ['{d31fbe17-f157-41a2-8d24-cb779e0560e8}']
        /// Advances to the first or next color run. The runs are enumerated
        /// in order from back to front.
        /// <param name="hasRun">Receives TRUE if there is a current run or
        /// FALSE if the end of the sequence has been reached.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function MoveNext(
        {_Out_} hasRun: Pboolean): HRESULT; stdcall;

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
        {_Outptr_}  out colorGlyphRun: PDWRITE_COLOR_GLYPH_RUN): HRESULT; stdcall;

    end;

    /// The interface that represents text rendering settings for glyph rasterization and filtering.
    IDWriteRenderingParams2 = interface(IDWriteRenderingParams1)
        ['{F9D711C3-9777-40AE-87E8-3E5AF9BF0948}']
        /// Gets the grid fitting mode.
        function GetGridFitMode(): TDWRITE_GRID_FIT_MODE; stdcall;

    end;

    /// The root factory interface for all DWrite objects.
    IDWriteFactory2 = interface(IDWriteFactory1)
        ['{0439fc60-ca44-4994-8dee-3a9af7b732ec}']
        /// Get the system-appropriate font fallback mapping list.
        /// <param name="fontFallback">The system fallback list.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetSystemFontFallback(
        {_COM_Outptr_}  out fontFallback: IDWriteFontFallback): HRESULT; stdcall;

        /// Create a custom font fallback builder.
        /// <param name="fontFallbackBuilder">Empty font fallback builder.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function CreateFontFallbackBuilder(
        {_COM_Outptr_}  out fontFallbackBuilder: IDWriteFontFallbackBuilder): HRESULT; stdcall;

        /// Translates a glyph run to a sequence of color glyph runs, which can be
        /// rendered to produce a color representation of the original "base" run.
        /// <param name="baselineOriginX">Horizontal origin of the base glyph run in
        /// pre-transform coordinates.</param>
        /// <param name="baselineOriginY">Vertical origin of the base glyph run in
        /// pre-transform coordinates.</param>
        /// <param name="glyphRun">Pointer to the original "base" glyph run.</param>
        /// <param name="glyphRunDescription">Optional glyph run description.</param>
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
        /// Returns DWRITE_E_NOCOLOR if the font has no color information, the base
        /// glyph run does not contain any color glyphs, or the specified color palette
        /// index is out of range. In this case, the client should render the base glyph
        /// run. Otherwise, returns a standard HRESULT error code.
        /// </returns>
        function TranslateColorGlyphRun(baselineOriginX: single; baselineOriginY: single;
        {_In_} glyphRun: PDWRITE_GLYPH_RUN;
        {_In_opt_} glyphRunDescription: PDWRITE_GLYPH_RUN_DESCRIPTION; measuringMode: TDWRITE_MEASURING_MODE;
        {_In_opt_} worldToDeviceTransform: PDWRITE_MATRIX; colorPaletteIndex: uint32;
        {_COM_Outptr_}  out colorLayers: IDWriteColorGlyphRunEnumerator): HRESULT; stdcall;

        /// Creates a rendering parameters object with the specified properties.
        /// <param name="gamma">The gamma value used for gamma correction, which must be greater than zero and cannot exceed 256.</param>
        /// <param name="enhancedContrast">The amount of contrast enhancement, zero or greater.</param>
        /// <param name="clearTypeLevel">The degree of ClearType level, from 0.0f (no ClearType) to 1.0f (full ClearType).</param>
        /// <param name="pixelGeometry">The geometry of a device pixel.</param>
        /// <param name="renderingMode">Method of rendering glyphs. In most cases, this should be DWRITE_RENDERING_MODE_DEFAULT to automatically use an appropriate mode.</param>
        /// <param name="gridFitMode">How to grid fit glyph outlines. In most cases, this should be DWRITE_GRID_FIT_DEFAULT to automatically choose an appropriate mode.</param>
        /// <param name="renderingParams">Holds the newly created rendering parameters object, or NULL in case of failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function CreateCustomRenderingParams(gamma: single; enhancedContrast: single; grayscaleEnhancedContrast: single; clearTypeLevel: single;
            pixelGeometry: TDWRITE_PIXEL_GEOMETRY; renderingMode: TDWRITE_RENDERING_MODE; gridFitMode: TDWRITE_GRID_FIT_MODE;
        {_COM_Outptr_}  out renderingParams: IDWriteRenderingParams2): HRESULT; stdcall;

        /// Creates a glyph run analysis object, which encapsulates information
        /// used to render a glyph run.
        /// <param name="glyphRun">Structure specifying the properties of the glyph run.</param>
        /// <param name="transform">Optional transform applied to the glyphs and their positions. This transform is applied after the
        /// scaling specified by the emSize and pixelsPerDip.</param>
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
        {_In_opt_} transform: PDWRITE_MATRIX; renderingMode: TDWRITE_RENDERING_MODE; measuringMode: TDWRITE_MEASURING_MODE; gridFitMode: TDWRITE_GRID_FIT_MODE;
            antialiasMode: TDWRITE_TEXT_ANTIALIAS_MODE; baselineOriginX: single; baselineOriginY: single;
        {_COM_Outptr_}  out glyphRunAnalysis: IDWriteGlyphRunAnalysis): HRESULT; stdcall;

    end;

implementation


end.
