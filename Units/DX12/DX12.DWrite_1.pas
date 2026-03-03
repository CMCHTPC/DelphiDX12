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
   File name: dwrite_1.h
   Header version: 10.0.26100.6584
   
  ************************************************************************** }
unit DX12.DWrite_1;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.DWrite,
    DX12.DCommon;

    {$Z4}

const
    IID_IDWriteFactory1: TGUID = '{30572f99-dac6-41db-a16e-0486307e606a}';
    IID_IDWriteFontFace1: TGUID = '{a71efdb4-9fdb-4838-ad90-cfc3be8c3daf}';
    IID_IDWriteFont1: TGUID = '{acd16696-8c14-4f5d-877e-fe3fc1d32738}';
    IID_IDWriteRenderingParams1: TGUID = '{94413cf4-a6fc-4248-8b50-6674348fcad3}';
    IID_IDWriteTextAnalyzer1: TGUID = '{80DAD800-E21F-4E83-96CE-BFCCE500DB7C}';
    IID_IDWriteTextAnalysisSource1: TGUID = '{639CFAD8-0FB4-4B21-A58A-067920120009}';
    IID_IDWriteTextAnalysisSink1: TGUID = '{B0D941A0-85E7-4D8B-9FD3-5CED9934482A}';
    IID_IDWriteTextLayout1: TGUID = '{9064D822-80A7-465C-A986-DF65F78B8FEB}';
    IID_IDWriteBitmapRenderTarget1: TGUID = '{791e8298-3ef3-4230-9880-c9bdecc42064}';

type

    /// The overall kind of family.
    TDWRITE_PANOSE_FAMILY = (
        DWRITE_PANOSE_FAMILY_ANY = 0,
        DWRITE_PANOSE_FAMILY_NO_FIT = 1,
        DWRITE_PANOSE_FAMILY_TEXT_DISPLAY = 2,
        DWRITE_PANOSE_FAMILY_SCRIPT = 3, // or hand written
        DWRITE_PANOSE_FAMILY_DECORATIVE = 4,
        DWRITE_PANOSE_FAMILY_SYMBOL = 5,  // or symbol
        DWRITE_PANOSE_FAMILY_PICTORIAL = DWRITE_PANOSE_FAMILY_SYMBOL
        );

    PDWRITE_PANOSE_FAMILY = ^TDWRITE_PANOSE_FAMILY;

    /// Appearance of the serifs.
    /// Present for families: 2-text
    TDWRITE_PANOSE_SERIF_STYLE = (
        DWRITE_PANOSE_SERIF_STYLE_ANY = 0,
        DWRITE_PANOSE_SERIF_STYLE_NO_FIT = 1,
        DWRITE_PANOSE_SERIF_STYLE_COVE = 2,
        DWRITE_PANOSE_SERIF_STYLE_OBTUSE_COVE = 3,
        DWRITE_PANOSE_SERIF_STYLE_SQUARE_COVE = 4,
        DWRITE_PANOSE_SERIF_STYLE_OBTUSE_SQUARE_COVE = 5,
        DWRITE_PANOSE_SERIF_STYLE_SQUARE = 6,
        DWRITE_PANOSE_SERIF_STYLE_THIN = 7,
        DWRITE_PANOSE_SERIF_STYLE_OVAL = 8,
        DWRITE_PANOSE_SERIF_STYLE_EXAGGERATED = 9,
        DWRITE_PANOSE_SERIF_STYLE_TRIANGLE = 10,
        DWRITE_PANOSE_SERIF_STYLE_NORMAL_SANS = 11,
        DWRITE_PANOSE_SERIF_STYLE_OBTUSE_SANS = 12,
        DWRITE_PANOSE_SERIF_STYLE_PERPENDICULAR_SANS = 13,
        DWRITE_PANOSE_SERIF_STYLE_FLARED = 14,
        DWRITE_PANOSE_SERIF_STYLE_ROUNDED = 15,
        DWRITE_PANOSE_SERIF_STYLE_SCRIPT = 16,
        DWRITE_PANOSE_SERIF_STYLE_PERP_SANS = DWRITE_PANOSE_SERIF_STYLE_PERPENDICULAR_SANS,
        DWRITE_PANOSE_SERIF_STYLE_BONE = DWRITE_PANOSE_SERIF_STYLE_OVAL
        );

    PDWRITE_PANOSE_SERIF_STYLE = ^TDWRITE_PANOSE_SERIF_STYLE;

    /// PANOSE font weights. These roughly correspond to the DWRITE_FONT_WEIGHT's
    /// using (panose_weight - 2) * 100.
    /// Present for families: 2-text, 3-script, 4-decorative, 5-symbol
    TDWRITE_PANOSE_WEIGHT = (
        DWRITE_PANOSE_WEIGHT_ANY = 0,
        DWRITE_PANOSE_WEIGHT_NO_FIT = 1,
        DWRITE_PANOSE_WEIGHT_VERY_LIGHT = 2,
        DWRITE_PANOSE_WEIGHT_LIGHT = 3,
        DWRITE_PANOSE_WEIGHT_THIN = 4,
        DWRITE_PANOSE_WEIGHT_BOOK = 5,
        DWRITE_PANOSE_WEIGHT_MEDIUM = 6,
        DWRITE_PANOSE_WEIGHT_DEMI = 7,
        DWRITE_PANOSE_WEIGHT_BOLD = 8,
        DWRITE_PANOSE_WEIGHT_HEAVY = 9,
        DWRITE_PANOSE_WEIGHT_BLACK = 10,
        DWRITE_PANOSE_WEIGHT_EXTRA_BLACK = 11,
        DWRITE_PANOSE_WEIGHT_NORD = DWRITE_PANOSE_WEIGHT_EXTRA_BLACK
        );

    PDWRITE_PANOSE_WEIGHT = ^TDWRITE_PANOSE_WEIGHT;

    /// Proportion of the glyph shape considering additional detail to standard
    /// characters.
    /// Present for families: 2-text
    TDWRITE_PANOSE_PROPORTION = (
        DWRITE_PANOSE_PROPORTION_ANY = 0,
        DWRITE_PANOSE_PROPORTION_NO_FIT = 1,
        DWRITE_PANOSE_PROPORTION_OLD_STYLE = 2,
        DWRITE_PANOSE_PROPORTION_MODERN = 3,
        DWRITE_PANOSE_PROPORTION_EVEN_WIDTH = 4,
        DWRITE_PANOSE_PROPORTION_EXPANDED = 5,
        DWRITE_PANOSE_PROPORTION_CONDENSED = 6,
        DWRITE_PANOSE_PROPORTION_VERY_EXPANDED = 7,
        DWRITE_PANOSE_PROPORTION_VERY_CONDENSED = 8,
        DWRITE_PANOSE_PROPORTION_MONOSPACED = 9
        );

    PDWRITE_PANOSE_PROPORTION = ^TDWRITE_PANOSE_PROPORTION;

    /// Ratio between thickest and thinnest point of the stroke for a letter such
    /// as uppercase 'O'.
    /// Present for families: 2-text, 3-script, 4-decorative
    TDWRITE_PANOSE_CONTRAST = (
        DWRITE_PANOSE_CONTRAST_ANY = 0,
        DWRITE_PANOSE_CONTRAST_NO_FIT = 1,
        DWRITE_PANOSE_CONTRAST_NONE = 2,
        DWRITE_PANOSE_CONTRAST_VERY_LOW = 3,
        DWRITE_PANOSE_CONTRAST_LOW = 4,
        DWRITE_PANOSE_CONTRAST_MEDIUM_LOW = 5,
        DWRITE_PANOSE_CONTRAST_MEDIUM = 6,
        DWRITE_PANOSE_CONTRAST_MEDIUM_HIGH = 7,
        DWRITE_PANOSE_CONTRAST_HIGH = 8,
        DWRITE_PANOSE_CONTRAST_VERY_HIGH = 9,
        DWRITE_PANOSE_CONTRAST_HORIZONTAL_LOW = 10,
        DWRITE_PANOSE_CONTRAST_HORIZONTAL_MEDIUM = 11,
        DWRITE_PANOSE_CONTRAST_HORIZONTAL_HIGH = 12,
        DWRITE_PANOSE_CONTRAST_BROKEN = 13
        );

    PDWRITE_PANOSE_CONTRAST = ^TDWRITE_PANOSE_CONTRAST;

    /// Relationship between thin and thick stems.
    /// Present for families: 2-text
    TDWRITE_PANOSE_STROKE_VARIATION = (
        DWRITE_PANOSE_STROKE_VARIATION_ANY = 0,
        DWRITE_PANOSE_STROKE_VARIATION_NO_FIT = 1,
        DWRITE_PANOSE_STROKE_VARIATION_NO_VARIATION = 2,
        DWRITE_PANOSE_STROKE_VARIATION_GRADUAL_DIAGONAL = 3,
        DWRITE_PANOSE_STROKE_VARIATION_GRADUAL_TRANSITIONAL = 4,
        DWRITE_PANOSE_STROKE_VARIATION_GRADUAL_VERTICAL = 5,
        DWRITE_PANOSE_STROKE_VARIATION_GRADUAL_HORIZONTAL = 6,
        DWRITE_PANOSE_STROKE_VARIATION_RAPID_VERTICAL = 7,
        DWRITE_PANOSE_STROKE_VARIATION_RAPID_HORIZONTAL = 8,
        DWRITE_PANOSE_STROKE_VARIATION_INSTANT_VERTICAL = 9,
        DWRITE_PANOSE_STROKE_VARIATION_INSTANT_HORIZONTAL = 10
        );

    PDWRITE_PANOSE_STROKE_VARIATION = ^TDWRITE_PANOSE_STROKE_VARIATION;

    /// Style of termination of stems and rounded letterforms.
    /// Present for families: 2-text
    TDWRITE_PANOSE_ARM_STYLE = (
        DWRITE_PANOSE_ARM_STYLE_ANY = 0,
        DWRITE_PANOSE_ARM_STYLE_NO_FIT = 1,
        DWRITE_PANOSE_ARM_STYLE_STRAIGHT_ARMS_HORIZONTAL = 2,
        DWRITE_PANOSE_ARM_STYLE_STRAIGHT_ARMS_WEDGE = 3,
        DWRITE_PANOSE_ARM_STYLE_STRAIGHT_ARMS_VERTICAL = 4,
        DWRITE_PANOSE_ARM_STYLE_STRAIGHT_ARMS_SINGLE_SERIF = 5,
        DWRITE_PANOSE_ARM_STYLE_STRAIGHT_ARMS_DOUBLE_SERIF = 6,
        DWRITE_PANOSE_ARM_STYLE_NONSTRAIGHT_ARMS_HORIZONTAL = 7,
        DWRITE_PANOSE_ARM_STYLE_NONSTRAIGHT_ARMS_WEDGE = 8,
        DWRITE_PANOSE_ARM_STYLE_NONSTRAIGHT_ARMS_VERTICAL = 9,
        DWRITE_PANOSE_ARM_STYLE_NONSTRAIGHT_ARMS_SINGLE_SERIF = 10,
        DWRITE_PANOSE_ARM_STYLE_NONSTRAIGHT_ARMS_DOUBLE_SERIF = 11,
        DWRITE_PANOSE_ARM_STYLE_STRAIGHT_ARMS_HORZ = DWRITE_PANOSE_ARM_STYLE_STRAIGHT_ARMS_HORIZONTAL,
        DWRITE_PANOSE_ARM_STYLE_STRAIGHT_ARMS_VERT = DWRITE_PANOSE_ARM_STYLE_STRAIGHT_ARMS_VERTICAL,
        DWRITE_PANOSE_ARM_STYLE_BENT_ARMS_HORZ = DWRITE_PANOSE_ARM_STYLE_NONSTRAIGHT_ARMS_HORIZONTAL,
        DWRITE_PANOSE_ARM_STYLE_BENT_ARMS_WEDGE = DWRITE_PANOSE_ARM_STYLE_NONSTRAIGHT_ARMS_WEDGE,
        DWRITE_PANOSE_ARM_STYLE_BENT_ARMS_VERT = DWRITE_PANOSE_ARM_STYLE_NONSTRAIGHT_ARMS_VERTICAL,
        DWRITE_PANOSE_ARM_STYLE_BENT_ARMS_SINGLE_SERIF = DWRITE_PANOSE_ARM_STYLE_NONSTRAIGHT_ARMS_SINGLE_SERIF,
        DWRITE_PANOSE_ARM_STYLE_BENT_ARMS_DOUBLE_SERIF = DWRITE_PANOSE_ARM_STYLE_NONSTRAIGHT_ARMS_DOUBLE_SERIF
        );

    PDWRITE_PANOSE_ARM_STYLE = ^TDWRITE_PANOSE_ARM_STYLE;

    /// Roundness of letterform.
    /// Present for families: 2-text
    TDWRITE_PANOSE_LETTERFORM = (
        DWRITE_PANOSE_LETTERFORM_ANY = 0,
        DWRITE_PANOSE_LETTERFORM_NO_FIT = 1,
        DWRITE_PANOSE_LETTERFORM_NORMAL_CONTACT = 2,
        DWRITE_PANOSE_LETTERFORM_NORMAL_WEIGHTED = 3,
        DWRITE_PANOSE_LETTERFORM_NORMAL_BOXED = 4,
        DWRITE_PANOSE_LETTERFORM_NORMAL_FLATTENED = 5,
        DWRITE_PANOSE_LETTERFORM_NORMAL_ROUNDED = 6,
        DWRITE_PANOSE_LETTERFORM_NORMAL_OFF_CENTER = 7,
        DWRITE_PANOSE_LETTERFORM_NORMAL_SQUARE = 8,
        DWRITE_PANOSE_LETTERFORM_OBLIQUE_CONTACT = 9,
        DWRITE_PANOSE_LETTERFORM_OBLIQUE_WEIGHTED = 10,
        DWRITE_PANOSE_LETTERFORM_OBLIQUE_BOXED = 11,
        DWRITE_PANOSE_LETTERFORM_OBLIQUE_FLATTENED = 12,
        DWRITE_PANOSE_LETTERFORM_OBLIQUE_ROUNDED = 13,
        DWRITE_PANOSE_LETTERFORM_OBLIQUE_OFF_CENTER = 14,
        DWRITE_PANOSE_LETTERFORM_OBLIQUE_SQUARE = 15
        );

    PDWRITE_PANOSE_LETTERFORM = ^TDWRITE_PANOSE_LETTERFORM;

    /// Placement of midline across uppercase characters and treatment of diagonal
    /// stem apexes.
    /// Present for families: 2-text
    TDWRITE_PANOSE_MIDLINE = (
        DWRITE_PANOSE_MIDLINE_ANY = 0,
        DWRITE_PANOSE_MIDLINE_NO_FIT = 1,
        DWRITE_PANOSE_MIDLINE_STANDARD_TRIMMED = 2,
        DWRITE_PANOSE_MIDLINE_STANDARD_POINTED = 3,
        DWRITE_PANOSE_MIDLINE_STANDARD_SERIFED = 4,
        DWRITE_PANOSE_MIDLINE_HIGH_TRIMMED = 5,
        DWRITE_PANOSE_MIDLINE_HIGH_POINTED = 6,
        DWRITE_PANOSE_MIDLINE_HIGH_SERIFED = 7,
        DWRITE_PANOSE_MIDLINE_CONSTANT_TRIMMED = 8,
        DWRITE_PANOSE_MIDLINE_CONSTANT_POINTED = 9,
        DWRITE_PANOSE_MIDLINE_CONSTANT_SERIFED = 10,
        DWRITE_PANOSE_MIDLINE_LOW_TRIMMED = 11,
        DWRITE_PANOSE_MIDLINE_LOW_POINTED = 12,
        DWRITE_PANOSE_MIDLINE_LOW_SERIFED = 13
        );

    PDWRITE_PANOSE_MIDLINE = ^TDWRITE_PANOSE_MIDLINE;

    /// Relative size of lowercase letters and treament of diacritic marks
    /// and uppercase glyphs.
    /// Present for families: 2-text
    TDWRITE_PANOSE_XHEIGHT = (
        DWRITE_PANOSE_XHEIGHT_ANY = 0,
        DWRITE_PANOSE_XHEIGHT_NO_FIT = 1,
        DWRITE_PANOSE_XHEIGHT_CONSTANT_SMALL = 2,
        DWRITE_PANOSE_XHEIGHT_CONSTANT_STANDARD = 3,
        DWRITE_PANOSE_XHEIGHT_CONSTANT_LARGE = 4,
        DWRITE_PANOSE_XHEIGHT_DUCKING_SMALL = 5,
        DWRITE_PANOSE_XHEIGHT_DUCKING_STANDARD = 6,
        DWRITE_PANOSE_XHEIGHT_DUCKING_LARGE = 7,
        DWRITE_PANOSE_XHEIGHT_CONSTANT_STD = DWRITE_PANOSE_XHEIGHT_CONSTANT_STANDARD,
        DWRITE_PANOSE_XHEIGHT_DUCKING_STD = DWRITE_PANOSE_XHEIGHT_DUCKING_STANDARD
        );

    PDWRITE_PANOSE_XHEIGHT = ^TDWRITE_PANOSE_XHEIGHT;

    /// Kind of tool used to create character forms.
    /// Present for families: 3-script
    TDWRITE_PANOSE_TOOL_KIND = (
        DWRITE_PANOSE_TOOL_KIND_ANY = 0,
        DWRITE_PANOSE_TOOL_KIND_NO_FIT = 1,
        DWRITE_PANOSE_TOOL_KIND_FLAT_NIB = 2,
        DWRITE_PANOSE_TOOL_KIND_PRESSURE_POINT = 3,
        DWRITE_PANOSE_TOOL_KIND_ENGRAVED = 4,
        DWRITE_PANOSE_TOOL_KIND_BALL = 5,
        DWRITE_PANOSE_TOOL_KIND_BRUSH = 6,
        DWRITE_PANOSE_TOOL_KIND_ROUGH = 7,
        DWRITE_PANOSE_TOOL_KIND_FELT_PEN_BRUSH_TIP = 8,
        DWRITE_PANOSE_TOOL_KIND_WILD_BRUSH = 9
        );

    PDWRITE_PANOSE_TOOL_KIND = ^TDWRITE_PANOSE_TOOL_KIND;

    /// Monospace vs proportional.
    /// Present for families: 3-script, 5-symbol
    TDWRITE_PANOSE_SPACING = (
        DWRITE_PANOSE_SPACING_ANY = 0,
        DWRITE_PANOSE_SPACING_NO_FIT = 1,
        DWRITE_PANOSE_SPACING_PROPORTIONAL_SPACED = 2,
        DWRITE_PANOSE_SPACING_MONOSPACED = 3
        );

    PDWRITE_PANOSE_SPACING = ^TDWRITE_PANOSE_SPACING;

    /// Ratio between width and height of the face.
    /// Present for families: 3-script
    TDWRITE_PANOSE_ASPECT_RATIO = (
        DWRITE_PANOSE_ASPECT_RATIO_ANY = 0,
        DWRITE_PANOSE_ASPECT_RATIO_NO_FIT = 1,
        DWRITE_PANOSE_ASPECT_RATIO_VERY_CONDENSED = 2,
        DWRITE_PANOSE_ASPECT_RATIO_CONDENSED = 3,
        DWRITE_PANOSE_ASPECT_RATIO_NORMAL = 4,
        DWRITE_PANOSE_ASPECT_RATIO_EXPANDED = 5,
        DWRITE_PANOSE_ASPECT_RATIO_VERY_EXPANDED = 6
        );

    PDWRITE_PANOSE_ASPECT_RATIO = ^TDWRITE_PANOSE_ASPECT_RATIO;

    /// Topology of letterforms.
    /// Present for families: 3-script
    TDWRITE_PANOSE_SCRIPT_TOPOLOGY = (
        DWRITE_PANOSE_SCRIPT_TOPOLOGY_ANY = 0,
        DWRITE_PANOSE_SCRIPT_TOPOLOGY_NO_FIT = 1,
        DWRITE_PANOSE_SCRIPT_TOPOLOGY_ROMAN_DISCONNECTED = 2,
        DWRITE_PANOSE_SCRIPT_TOPOLOGY_ROMAN_TRAILING = 3,
        DWRITE_PANOSE_SCRIPT_TOPOLOGY_ROMAN_CONNECTED = 4,
        DWRITE_PANOSE_SCRIPT_TOPOLOGY_CURSIVE_DISCONNECTED = 5,
        DWRITE_PANOSE_SCRIPT_TOPOLOGY_CURSIVE_TRAILING = 6,
        DWRITE_PANOSE_SCRIPT_TOPOLOGY_CURSIVE_CONNECTED = 7,
        DWRITE_PANOSE_SCRIPT_TOPOLOGY_BLACKLETTER_DISCONNECTED = 8,
        DWRITE_PANOSE_SCRIPT_TOPOLOGY_BLACKLETTER_TRAILING = 9,
        DWRITE_PANOSE_SCRIPT_TOPOLOGY_BLACKLETTER_CONNECTED = 10
        );

    PDWRITE_PANOSE_SCRIPT_TOPOLOGY = ^TDWRITE_PANOSE_SCRIPT_TOPOLOGY;

    /// General look of the face, considering slope and tails.
    /// Present for families: 3-script
    TDWRITE_PANOSE_SCRIPT_FORM = (
        DWRITE_PANOSE_SCRIPT_FORM_ANY = 0,
        DWRITE_PANOSE_SCRIPT_FORM_NO_FIT = 1,
        DWRITE_PANOSE_SCRIPT_FORM_UPRIGHT_NO_WRAPPING = 2,
        DWRITE_PANOSE_SCRIPT_FORM_UPRIGHT_SOME_WRAPPING = 3,
        DWRITE_PANOSE_SCRIPT_FORM_UPRIGHT_MORE_WRAPPING = 4,
        DWRITE_PANOSE_SCRIPT_FORM_UPRIGHT_EXTREME_WRAPPING = 5,
        DWRITE_PANOSE_SCRIPT_FORM_OBLIQUE_NO_WRAPPING = 6,
        DWRITE_PANOSE_SCRIPT_FORM_OBLIQUE_SOME_WRAPPING = 7,
        DWRITE_PANOSE_SCRIPT_FORM_OBLIQUE_MORE_WRAPPING = 8,
        DWRITE_PANOSE_SCRIPT_FORM_OBLIQUE_EXTREME_WRAPPING = 9,
        DWRITE_PANOSE_SCRIPT_FORM_EXAGGERATED_NO_WRAPPING = 10,
        DWRITE_PANOSE_SCRIPT_FORM_EXAGGERATED_SOME_WRAPPING = 11,
        DWRITE_PANOSE_SCRIPT_FORM_EXAGGERATED_MORE_WRAPPING = 12,
        DWRITE_PANOSE_SCRIPT_FORM_EXAGGERATED_EXTREME_WRAPPING = 13
        );

    PDWRITE_PANOSE_SCRIPT_FORM = ^TDWRITE_PANOSE_SCRIPT_FORM;

    /// How character ends and miniscule ascenders are treated.
    /// Present for families: 3-script
    TDWRITE_PANOSE_FINIALS = (
        DWRITE_PANOSE_FINIALS_ANY = 0,
        DWRITE_PANOSE_FINIALS_NO_FIT = 1,
        DWRITE_PANOSE_FINIALS_NONE_NO_LOOPS = 2,
        DWRITE_PANOSE_FINIALS_NONE_CLOSED_LOOPS = 3,
        DWRITE_PANOSE_FINIALS_NONE_OPEN_LOOPS = 4,
        DWRITE_PANOSE_FINIALS_SHARP_NO_LOOPS = 5,
        DWRITE_PANOSE_FINIALS_SHARP_CLOSED_LOOPS = 6,
        DWRITE_PANOSE_FINIALS_SHARP_OPEN_LOOPS = 7,
        DWRITE_PANOSE_FINIALS_TAPERED_NO_LOOPS = 8,
        DWRITE_PANOSE_FINIALS_TAPERED_CLOSED_LOOPS = 9,
        DWRITE_PANOSE_FINIALS_TAPERED_OPEN_LOOPS = 10,
        DWRITE_PANOSE_FINIALS_ROUND_NO_LOOPS = 11,
        DWRITE_PANOSE_FINIALS_ROUND_CLOSED_LOOPS = 12,
        DWRITE_PANOSE_FINIALS_ROUND_OPEN_LOOPS = 13
        );

    PDWRITE_PANOSE_FINIALS = ^TDWRITE_PANOSE_FINIALS;

    /// Relative size of the lowercase letters.
    /// Present for families: 3-script
    TDWRITE_PANOSE_XASCENT = (
        DWRITE_PANOSE_XASCENT_ANY = 0,
        DWRITE_PANOSE_XASCENT_NO_FIT = 1,
        DWRITE_PANOSE_XASCENT_VERY_LOW = 2,
        DWRITE_PANOSE_XASCENT_LOW = 3,
        DWRITE_PANOSE_XASCENT_MEDIUM = 4,
        DWRITE_PANOSE_XASCENT_HIGH = 5,
        DWRITE_PANOSE_XASCENT_VERY_HIGH = 6
        );

    PDWRITE_PANOSE_XASCENT = ^TDWRITE_PANOSE_XASCENT;

    /// General look of the face.
    /// Present for families: 4-decorative
    TDWRITE_PANOSE_DECORATIVE_CLASS = (
        DWRITE_PANOSE_DECORATIVE_CLASS_ANY = 0,
        DWRITE_PANOSE_DECORATIVE_CLASS_NO_FIT = 1,
        DWRITE_PANOSE_DECORATIVE_CLASS_DERIVATIVE = 2,
        DWRITE_PANOSE_DECORATIVE_CLASS_NONSTANDARD_TOPOLOGY = 3,
        DWRITE_PANOSE_DECORATIVE_CLASS_NONSTANDARD_ELEMENTS = 4,
        DWRITE_PANOSE_DECORATIVE_CLASS_NONSTANDARD_ASPECT = 5,
        DWRITE_PANOSE_DECORATIVE_CLASS_INITIALS = 6,
        DWRITE_PANOSE_DECORATIVE_CLASS_CARTOON = 7,
        DWRITE_PANOSE_DECORATIVE_CLASS_PICTURE_STEMS = 8,
        DWRITE_PANOSE_DECORATIVE_CLASS_ORNAMENTED = 9,
        DWRITE_PANOSE_DECORATIVE_CLASS_TEXT_AND_BACKGROUND = 10,
        DWRITE_PANOSE_DECORATIVE_CLASS_COLLAGE = 11,
        DWRITE_PANOSE_DECORATIVE_CLASS_MONTAGE = 12
        );

    PDWRITE_PANOSE_DECORATIVE_CLASS = ^TDWRITE_PANOSE_DECORATIVE_CLASS;

    /// Ratio between the width and height of the face.
    /// Present for families: 4-decorative
    TDWRITE_PANOSE_ASPECT = (
        DWRITE_PANOSE_ASPECT_ANY = 0,
        DWRITE_PANOSE_ASPECT_NO_FIT = 1,
        DWRITE_PANOSE_ASPECT_SUPER_CONDENSED = 2,
        DWRITE_PANOSE_ASPECT_VERY_CONDENSED = 3,
        DWRITE_PANOSE_ASPECT_CONDENSED = 4,
        DWRITE_PANOSE_ASPECT_NORMAL = 5,
        DWRITE_PANOSE_ASPECT_EXTENDED = 6,
        DWRITE_PANOSE_ASPECT_VERY_EXTENDED = 7,
        DWRITE_PANOSE_ASPECT_SUPER_EXTENDED = 8,
        DWRITE_PANOSE_ASPECT_MONOSPACED = 9
        );

    PDWRITE_PANOSE_ASPECT = ^TDWRITE_PANOSE_ASPECT;

    /// Type of fill/line (treatment).
    /// Present for families: 4-decorative
    TDWRITE_PANOSE_FILL = (
        DWRITE_PANOSE_FILL_ANY = 0,
        DWRITE_PANOSE_FILL_NO_FIT = 1,
        DWRITE_PANOSE_FILL_STANDARD_SOLID_FILL = 2,
        DWRITE_PANOSE_FILL_NO_FILL = 3,
        DWRITE_PANOSE_FILL_PATTERNED_FILL = 4,
        DWRITE_PANOSE_FILL_COMPLEX_FILL = 5,
        DWRITE_PANOSE_FILL_SHAPED_FILL = 6,
        DWRITE_PANOSE_FILL_DRAWN_DISTRESSED = 7
        );

    PDWRITE_PANOSE_FILL = ^TDWRITE_PANOSE_FILL;

    /// Outline handling.
    /// Present for families: 4-decorative
    TDWRITE_PANOSE_LINING = (
        DWRITE_PANOSE_LINING_ANY = 0,
        DWRITE_PANOSE_LINING_NO_FIT = 1,
        DWRITE_PANOSE_LINING_NONE = 2,
        DWRITE_PANOSE_LINING_INLINE = 3,
        DWRITE_PANOSE_LINING_OUTLINE = 4,
        DWRITE_PANOSE_LINING_ENGRAVED = 5,
        DWRITE_PANOSE_LINING_SHADOW = 6,
        DWRITE_PANOSE_LINING_RELIEF = 7,
        DWRITE_PANOSE_LINING_BACKDROP = 8
        );

    PDWRITE_PANOSE_LINING = ^TDWRITE_PANOSE_LINING;

    /// Overall shape characteristics of the font.
    /// Present for families: 4-decorative
    TDWRITE_PANOSE_DECORATIVE_TOPOLOGY = (
        DWRITE_PANOSE_DECORATIVE_TOPOLOGY_ANY = 0,
        DWRITE_PANOSE_DECORATIVE_TOPOLOGY_NO_FIT = 1,
        DWRITE_PANOSE_DECORATIVE_TOPOLOGY_STANDARD = 2,
        DWRITE_PANOSE_DECORATIVE_TOPOLOGY_SQUARE = 3,
        DWRITE_PANOSE_DECORATIVE_TOPOLOGY_MULTIPLE_SEGMENT = 4,
        DWRITE_PANOSE_DECORATIVE_TOPOLOGY_ART_DECO = 5,
        DWRITE_PANOSE_DECORATIVE_TOPOLOGY_UNEVEN_WEIGHTING = 6,
        DWRITE_PANOSE_DECORATIVE_TOPOLOGY_DIVERSE_ARMS = 7,
        DWRITE_PANOSE_DECORATIVE_TOPOLOGY_DIVERSE_FORMS = 8,
        DWRITE_PANOSE_DECORATIVE_TOPOLOGY_LOMBARDIC_FORMS = 9,
        DWRITE_PANOSE_DECORATIVE_TOPOLOGY_UPPER_CASE_IN_LOWER_CASE = 10,
        DWRITE_PANOSE_DECORATIVE_TOPOLOGY_IMPLIED_TOPOLOGY = 11,
        DWRITE_PANOSE_DECORATIVE_TOPOLOGY_HORSESHOE_E_AND_A = 12,
        DWRITE_PANOSE_DECORATIVE_TOPOLOGY_CURSIVE = 13,
        DWRITE_PANOSE_DECORATIVE_TOPOLOGY_BLACKLETTER = 14,
        DWRITE_PANOSE_DECORATIVE_TOPOLOGY_SWASH_VARIANCE = 15
        );

    PDWRITE_PANOSE_DECORATIVE_TOPOLOGY = ^TDWRITE_PANOSE_DECORATIVE_TOPOLOGY;

    /// Type of characters available in the font.
    /// Present for families: 4-decorative
    TDWRITE_PANOSE_CHARACTER_RANGES = (
        DWRITE_PANOSE_CHARACTER_RANGES_ANY = 0,
        DWRITE_PANOSE_CHARACTER_RANGES_NO_FIT = 1,
        DWRITE_PANOSE_CHARACTER_RANGES_EXTENDED_COLLECTION = 2,
        DWRITE_PANOSE_CHARACTER_RANGES_LITERALS = 3,
        DWRITE_PANOSE_CHARACTER_RANGES_NO_LOWER_CASE = 4,
        DWRITE_PANOSE_CHARACTER_RANGES_SMALL_CAPS = 5
        );

    PDWRITE_PANOSE_CHARACTER_RANGES = ^TDWRITE_PANOSE_CHARACTER_RANGES;

    /// Kind of symbol set.
    /// Present for families: 5-symbol
    TDWRITE_PANOSE_SYMBOL_KIND = (
        DWRITE_PANOSE_SYMBOL_KIND_ANY = 0,
        DWRITE_PANOSE_SYMBOL_KIND_NO_FIT = 1,
        DWRITE_PANOSE_SYMBOL_KIND_MONTAGES = 2,
        DWRITE_PANOSE_SYMBOL_KIND_PICTURES = 3,
        DWRITE_PANOSE_SYMBOL_KIND_SHAPES = 4,
        DWRITE_PANOSE_SYMBOL_KIND_SCIENTIFIC = 5,
        DWRITE_PANOSE_SYMBOL_KIND_MUSIC = 6,
        DWRITE_PANOSE_SYMBOL_KIND_EXPERT = 7,
        DWRITE_PANOSE_SYMBOL_KIND_PATTERNS = 8,
        DWRITE_PANOSE_SYMBOL_KIND_BOARDERS = 9,
        DWRITE_PANOSE_SYMBOL_KIND_ICONS = 10,
        DWRITE_PANOSE_SYMBOL_KIND_LOGOS = 11,
        DWRITE_PANOSE_SYMBOL_KIND_INDUSTRY_SPECIFIC = 12
        );

    PDWRITE_PANOSE_SYMBOL_KIND = ^TDWRITE_PANOSE_SYMBOL_KIND;

    /// Aspect ratio of symbolic characters.
    /// Present for families: 5-symbol
    TDWRITE_PANOSE_SYMBOL_ASPECT_RATIO = (
        DWRITE_PANOSE_SYMBOL_ASPECT_RATIO_ANY = 0,
        DWRITE_PANOSE_SYMBOL_ASPECT_RATIO_NO_FIT = 1,
        DWRITE_PANOSE_SYMBOL_ASPECT_RATIO_NO_WIDTH = 2,
        DWRITE_PANOSE_SYMBOL_ASPECT_RATIO_EXCEPTIONALLY_WIDE = 3,
        DWRITE_PANOSE_SYMBOL_ASPECT_RATIO_SUPER_WIDE = 4,
        DWRITE_PANOSE_SYMBOL_ASPECT_RATIO_VERY_WIDE = 5,
        DWRITE_PANOSE_SYMBOL_ASPECT_RATIO_WIDE = 6,
        DWRITE_PANOSE_SYMBOL_ASPECT_RATIO_NORMAL = 7,
        DWRITE_PANOSE_SYMBOL_ASPECT_RATIO_NARROW = 8,
        DWRITE_PANOSE_SYMBOL_ASPECT_RATIO_VERY_NARROW = 9
        );

    PDWRITE_PANOSE_SYMBOL_ASPECT_RATIO = ^TDWRITE_PANOSE_SYMBOL_ASPECT_RATIO;

    /// Specifies the policy used by GetRecommendedRenderingMode to determine whether to
    /// render glyphs in outline mode. Glyphs are rendered in outline mode by default at
    /// large sizes for performance reasons, but how large (i.e., the outline threshold)
    /// depends on the quality of outline rendering. If the graphics system renders anti-
    /// aliased outlines then a relatively low threshold is used, but if the graphics
    /// system renders aliased outlines then a much higher threshold is used.
    TDWRITE_OUTLINE_THRESHOLD = (
        DWRITE_OUTLINE_THRESHOLD_ANTIALIASED,
        DWRITE_OUTLINE_THRESHOLD_ALIASED
        );

    PDWRITE_OUTLINE_THRESHOLD = ^TDWRITE_OUTLINE_THRESHOLD;

    /// Baseline for text alignment.
    TDWRITE_BASELINE = (
        /// The Roman baseline for horizontal, Central baseline for vertical.
        DWRITE_BASELINE_DEFAULT,
        /// The baseline used by alphabetic scripts such as Latin, Greek, Cyrillic.
        DWRITE_BASELINE_ROMAN,
        /// Central baseline, generally used for vertical text.
        DWRITE_BASELINE_CENTRAL,
        /// Mathematical baseline which math characters are centered on.
        DWRITE_BASELINE_MATH,
        /// Hanging baseline, used in scripts like Devanagari.
        DWRITE_BASELINE_HANGING,
        /// Ideographic bottom baseline for CJK, left in vertical.
        DWRITE_BASELINE_IDEOGRAPHIC_BOTTOM,
        /// Ideographic top baseline for CJK, right in vertical.
        DWRITE_BASELINE_IDEOGRAPHIC_TOP,
        /// The bottom-most extent in horizontal, left-most in vertical.
        DWRITE_BASELINE_MINIMUM,
        /// The top-most extent in horizontal, right-most in vertical.
        DWRITE_BASELINE_MAXIMUM
        );

    PDWRITE_BASELINE = ^TDWRITE_BASELINE;

    /// The desired kind of glyph orientation for the text. The client specifies
    /// this to the analyzer as the desired orientation, but note this is the
    /// client preference, and the constraints of the script will determine the
    /// final presentation.
    TDWRITE_VERTICAL_GLYPH_ORIENTATION = (
        /// In vertical layout, naturally horizontal scripts (Latin, Thai, Arabic,
        /// Devanagari) rotate 90 degrees clockwise, while ideographic scripts
        /// (Chinese, Japanese, Korean) remain upright, 0 degrees.
        DWRITE_VERTICAL_GLYPH_ORIENTATION_DEFAULT,
        /// Ideographic scripts and scripts that permit stacking
        /// (Latin, Hebrew) are stacked in vertical reading layout.
        /// Connected scripts (Arabic, Syriac, 'Phags-pa, Ogham),
        /// which would otherwise look broken if glyphs were kept
        /// at 0 degrees, remain connected and rotate.
        DWRITE_VERTICAL_GLYPH_ORIENTATION_STACKED
        );

    PDWRITE_VERTICAL_GLYPH_ORIENTATION = ^TDWRITE_VERTICAL_GLYPH_ORIENTATION;

    /// How the glyph is oriented to the x-axis. This is an output from the text
    /// analyzer, dependent on the desired orientation, bidi level, and character
    /// properties.
    TDWRITE_GLYPH_ORIENTATION_ANGLE = (
        /// Glyph orientation is upright.
        DWRITE_GLYPH_ORIENTATION_ANGLE_0_DEGREES,
        /// Glyph orientation is rotated 90 clockwise.
        DWRITE_GLYPH_ORIENTATION_ANGLE_90_DEGREES,
        /// Glyph orientation is upside-down.
        DWRITE_GLYPH_ORIENTATION_ANGLE_180_DEGREES,
        /// Glyph orientation is rotated 270 clockwise.
        DWRITE_GLYPH_ORIENTATION_ANGLE_270_DEGREES
        );

    PDWRITE_GLYPH_ORIENTATION_ANGLE = ^TDWRITE_GLYPH_ORIENTATION_ANGLE;

    TDWRITE_FONT_METRICS1 = record
        /// Left edge of accumulated bounding blackbox of all glyphs in the font.
        glyphBoxLeft: int16;
        /// Top edge of accumulated bounding blackbox of all glyphs in the font.
        glyphBoxTop: int16;
        /// Right edge of accumulated bounding blackbox of all glyphs in the font.
        glyphBoxRight: int16;
        /// Bottom edge of accumulated bounding blackbox of all glyphs in the font.
        glyphBoxBottom: int16;
        /// Horizontal position of the subscript relative to the baseline origin.
        /// This is typically negative (to the left) in italic/oblique fonts, and
        /// zero in regular fonts.
        subscriptPositionX: int16;
        /// Vertical position of the subscript relative to the baseline.
        /// This is typically negative.
        subscriptPositionY: int16;
        /// Horizontal size of the subscript em box in design units, used to
        /// scale the simulated subscript relative to the full em box size.
        /// This the numerator of the scaling ratio where denominator is the
        /// design units per em. If this member is zero, the font does not specify
        /// a scale factor, and the client should use its own policy.
        subscriptSizeX: int16;
        /// Vertical size of the subscript em box in design units, used to
        /// scale the simulated subscript relative to the full em box size.
        /// This the numerator of the scaling ratio where denominator is the
        /// design units per em. If this member is zero, the font does not specify
        /// a scale factor, and the client should use its own policy.
        subscriptSizeY: int16;
        /// Horizontal position of the superscript relative to the baseline origin.
        /// This is typically positive (to the right) in italic/oblique fonts, and
        /// zero in regular fonts.
        superscriptPositionX: int16;
        /// Vertical position of the superscript relative to the baseline.
        /// This is typically positive.
        superscriptPositionY: int16;
        /// Horizontal size of the superscript em box in design units, used to
        /// scale the simulated superscript relative to the full em box size.
        /// This the numerator of the scaling ratio where denominator is the
        /// design units per em. If this member is zero, the font does not specify
        /// a scale factor, and the client should use its own policy.
        superscriptSizeX: int16;
        /// Vertical size of the superscript em box in design units, used to
        /// scale the simulated superscript relative to the full em box size.
        /// This the numerator of the scaling ratio where denominator is the
        /// design units per em. If this member is zero, the font does not specify
        /// a scale factor, and the client should use its own policy.
        superscriptSizeY: int16;
        /// Indicates that the ascent, descent, and lineGap are based on newer
        /// 'typographic' values in the font, rather than legacy values.
        hasTypographicMetrics: boolean;
    end;
    PDWRITE_FONT_METRICS1 = ^TDWRITE_FONT_METRICS1;

    /// Metrics for caret placement in a font.
    TDWRITE_CARET_METRICS = record
        /// Vertical rise of the caret. Rise / Run yields the caret angle.
        /// Rise = 1 for perfectly upright fonts (non-italic).
        slopeRise: int16;
        /// Horizontal run of th caret. Rise / Run yields the caret angle.
        /// Run = 0 for perfectly upright fonts (non-italic).
        slopeRun: int16;
        /// Horizontal offset of the caret along the baseline for good appearance.
        /// Offset = 0 for perfectly upright fonts (non-italic).
        offset: int16;
    end;
    PDWRITE_CARET_METRICS = ^TDWRITE_CARET_METRICS;

    /// <summary>
    /// Typeface classification values, used for font selection and matching.
    /// </summary>
    /// <remarks>
    /// Note the family type (index 0) is the only stable entry in the 10-byte
    /// array, as all the following entries can change dynamically depending on
    /// context of the first field.
    /// </remarks>
    TDWRITE_PANOSE = record
    end;
    PDWRITE_PANOSE = ^TDWRITE_PANOSE;

    /// Range of Unicode codepoints.
    TDWRITE_UNICODE_RANGE = record
        /// The first codepoint in the Unicode range.
        First: uint32;
        /// The last codepoint in the Unicode range.
        last: uint32;
    end;
    PDWRITE_UNICODE_RANGE = ^TDWRITE_UNICODE_RANGE;

    /// Script-specific properties for caret navigation and justification.
    TDWRITE_SCRIPT_PROPERTIES = bitpacked record
        /// The standardized four character code for the given script.
        /// Note these only include the general Unicode scripts, not any
        /// additional ISO 15924 scripts for bibliographic distinction
        /// (for example, Fraktur Latin vs Gaelic Latin).
        /// http://unicode.org/iso15924/iso15924-codes.html
        isoScriptCode: uint32;
        /// The standardized numeric code, ranging 0-999.
        /// http://unicode.org/iso15924/iso15924-codes.html
        isoScriptNumber: uint32;
        /// Number of characters to estimate look-ahead for complex scripts.
        /// Latin and all Kana are generally 1. Indic scripts are up to 15,
        /// and most others are 8. Note that combining marks and variation
        /// selectors can produce clusters longer than these look-aheads,
        /// so this estimate is considered typical language use. Diacritics
        /// must be tested explicitly separately.
        clusterLookahead: uint32;
        /// Appropriate character to elongate the given script for justification.
        ///
        /// Examples:
        ///   Arabic    - U+0640 Tatweel
        ///   Ogham     - U+1680 Ogham Space Mark
        justificationCharacter: uint32;
        /// Restrict the caret to whole clusters, like Thai and Devanagari. Scripts
        /// such as Arabic by default allow navigation between clusters. Others
        /// like Thai always navigate across whole clusters.
        restrictCaretToClusters: 0..1;
        /// The language uses dividers between words, such as spaces between Latin
        /// or the Ethiopic wordspace.
        ///
        /// Examples: Latin, Greek, Devanagari, Ethiopic
        /// Excludes: Chinese, Korean, Thai.
        usesWordDividers: 0..1;
        /// The characters are discrete units from each other. This includes both
        /// block scripts and clustered scripts.
        ///
        /// Examples: Latin, Greek, Cyrillic, Hebrew, Chinese, Thai
        isDiscreteWriting: 0..1;
        /// The language is a block script, expanding between characters.
        ///
        /// Examples: Chinese, Japanese, Korean, Bopomofo.
        isBlockWriting: 0..1;
        /// The language is justified within glyph clusters, not just between glyph
        /// clusters. One such as the character sequence is Thai Lu and Sara Am
        /// (U+E026, U+E033) which form a single cluster but still expand between
        /// them.
        ///
        /// Examples: Thai, Lao, Khmer
        isDistributedWithinCluster: 0..1;
        /// The script's clusters are connected to each other (such as the
        /// baseline-linked Devanagari), and no separation should be added
        /// between characters. Note that cursively linked scripts like Arabic
        /// are also connected (but not all connected scripts are
        /// cursive).
        ///
        /// Examples: Devanagari, Arabic, Syriac, Bengali, Gurmukhi, Ogham
        /// Excludes: Latin, Chinese, Thaana
        isConnectedWriting: 0..1;
        /// The script is naturally cursive (Arabic/Syriac), meaning it uses other
        /// justification methods like kashida extension rather than intercharacter
        /// spacing. Note that although other scripts like Latin and Japanese may
        /// actually support handwritten cursive forms, they are not considered
        /// cursive scripts.
        ///
        /// Examples: Arabic, Syriac, Mongolian
        /// Excludes: Thaana, Devanagari, Latin, Chinese
        isCursiveWriting: 0..1;
        reserved: 0..33554431;
    end;
    PDWRITE_SCRIPT_PROPERTIES = ^TDWRITE_SCRIPT_PROPERTIES;

    /// Justification information per glyph.
    TDWRITE_JUSTIFICATION_OPPORTUNITY = bitpacked record
        /// Minimum amount of expansion to apply to the side of the glyph.
        /// This may vary from 0 to infinity, typically being zero except
        /// for kashida.
        expansionMinimum: single;
        /// Maximum amount of expansion to apply to the side of the glyph.
        /// This may vary from 0 to infinity, being zero for fixed-size characters
        /// and connected scripts, and non-zero for discrete scripts, and non-zero
        /// for cursive scripts at expansion points.
        expansionMaximum: single;
        /// Maximum amount of compression to apply to the side of the glyph.
        /// This may vary from 0 up to the glyph cluster size.
        compressionMaximum: single;
        /// Priority of this expansion point. Larger priorities are applied later,
        /// while priority zero does nothing.
        expansionPriority: 0..255;
        /// Priority of this compression point. Larger priorities are applied later,
        /// while priority zero does nothing.
        compressionPriority: 0..255;
        /// Allow this expansion point to use up any remaining slack space even
        /// after all expansion priorities have been used up.
        allowResidualExpansion: 0..1;
        /// Allow this compression point to use up any remaining space even after
        /// all compression priorities have been used up.
        allowResidualCompression: 0..1;
        /// Apply expansion/compression to the leading edge of the glyph. This will
        /// be false for connected scripts, fixed-size characters, and diacritics.
        /// It is generally false within a multi-glyph cluster, unless the script
        /// allows expansion of glyphs within a cluster, like Thai.
        applyToLeadingEdge: 0..1;
        /// Apply expansion/compression to the trailing edge of the glyph. This will
        /// be false for connected scripts, fixed-size characters, and diacritics.
        /// It is generally false within a multi-glyph cluster, unless the script
        /// allows expansion of glyphs within a cluster, like Thai.
        applyToTrailingEdge: 0..1;
        reserved: 0..4095;
    end;
    PDWRITE_JUSTIFICATION_OPPORTUNITY = ^TDWRITE_JUSTIFICATION_OPPORTUNITY;


    IDWriteTextAnalysisSource1 = interface;


    IDWriteTextAnalysisSink1 = interface;


    IDWriteRenderingParams1 = interface;

    /// The root factory interface for all DWrite objects.
    IDWriteFactory1 = interface(IDWriteFactory)
        ['{30572f99-dac6-41db-a16e-0486307e606a}']
        /// Gets a font collection representing the set of end-user defined
        /// custom fonts.
        /// <param name="fontCollection">Receives a pointer to the EUDC font
        ///     collection object, or NULL in case of failure.</param>
        /// <param name="checkForUpdates">If this parameter is nonzero, the
        ///     function performs an immediate check for changes to the set of
        ///     EUDC fonts. If this parameter is FALSE, the function will still
        ///     detect changes, but there may be some latency. For example, an
        ///     application might specify TRUE if it has itself just modified a
        ///     font and wants to be sure the font collection contains that font.
        ///     </param>
        /// <returns>
        /// Standard HRESULT error code. Note that if no EUDC is set on the system,
        /// the returned collection will be empty, meaning it will return success
        /// but GetFontFamilyCount will be zero.
        /// </returns>
        /// <remarks>
        /// Querying via IDWriteFontCollection::FindFamilyName for a specific
        /// family (like MS Gothic) will return the matching family-specific EUDC
        /// font if one exists. Querying for "" will return the global EUDC font.
        /// For example, if you were matching an EUDC character within a run of
        /// the base font PMingLiu, you would retrieve the corresponding EUDC font
        /// face using GetEudcFontCollection, then FindFamilyName with "PMingLiu",
        /// followed by GetFontFamily and CreateFontFace.
        ///
        /// Be aware that eudcedit.exe can create placeholder empty glyphs that
        /// have zero advance width and no glyph outline. Although they are present
        /// in the font (HasCharacter returns true), you are best to ignore
        /// these and continue on with font fallback in your layout if the metrics
        /// for the glyph are zero.
        /// </remarks>
        function GetEudcFontCollection(
        {_COM_Outptr_}  out fontCollection: IDWriteFontCollection; checkForUpdates: boolean = False): HRESULT; stdcall;

        /// Creates a rendering parameters object with the specified properties.
        /// <param name="gamma">The gamma value used for gamma correction, which must be greater than zero and cannot exceed 256.</param>
        /// <param name="enhancedContrast">The amount of contrast enhancement, zero or greater.</param>
        /// <param name="enhancedContrastGrayscale">The amount of contrast enhancement to use for grayscale antialiasing, zero or greater.</param>
        /// <param name="clearTypeLevel">The degree of ClearType level, from 0.0f (no ClearType) to 1.0f (full ClearType).</param>
        /// <param name="pixelGeometry">The geometry of a device pixel.</param>
        /// <param name="renderingMode">Method of rendering glyphs. In most cases, this should be DWRITE_RENDERING_MODE_DEFAULT to automatically use an appropriate mode.</param>
        /// <param name="renderingParams">Holds the newly created rendering parameters object, or NULL in case of failure.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function CreateCustomRenderingParams(gamma: single; enhancedContrast: single; enhancedContrastGrayscale: single; clearTypeLevel: single;
            pixelGeometry: TDWRITE_PIXEL_GEOMETRY; renderingMode: TDWRITE_RENDERING_MODE;
        {_COM_Outptr_}  out renderingParams: IDWriteRenderingParams1): HRESULT; stdcall;

    end;

    /// The interface that represents an absolute reference to a font face.
    /// It contains font face type, appropriate file references and face identification data.
    /// Various font data such as metrics, names and glyph outlines is obtained from IDWriteFontFace.
    IDWriteFontFace1 = interface(IDWriteFontFace)
        ['{a71efdb4-9fdb-4838-ad90-cfc3be8c3daf}']
        /// Gets common metrics for the font in design units.
        /// These metrics are applicable to all the glyphs within a font,
        /// and are used by applications for layout calculations.
        /// <param name="fontMetrics">Metrics structure to fill in.</param>
        procedure GetMetrics(
        {_Out_} fontMetrics: PDWRITE_FONT_METRICS1); stdcall;

        /// Gets common metrics for the font in design units.
        /// These metrics are applicable to all the glyphs within a font,
        /// and are used by applications for layout calculations.
        /// <param name="emSize">Logical size of the font in DIP units. A DIP
        ///     ("device-independent pixel") equals 1/96 inch.</param>
        /// <param name="pixelsPerDip">Number of physical pixels per DIP. For
        ///     example, if the DPI of the rendering surface is 96 this value is
        ///     1.0f. If the DPI is 120, this value is 120.0f/96.</param>
        /// <param name="transform">Optional transform applied to the glyphs and
        ///     their positions. This transform is applied after the scaling
        ///     specified by the font size and pixelsPerDip.</param>
        /// <param name="fontMetrics">Font metrics structure to fill in.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetGdiCompatibleMetrics(emSize: single; pixelsPerDip: single;
        {_In_opt_} transform: PDWRITE_MATRIX;
        {_Out_} fontMetrics: PDWRITE_FONT_METRICS1): HRESULT; stdcall;

        /// Gets caret metrics for the font in design units. These are used by
        /// text editors for drawing the correct caret placement/slant.
        /// <param name="caretMetrics">Metrics structure to fill in.</param>
        procedure GetCaretMetrics(
        {_Out_} caretMetrics: PDWRITE_CARET_METRICS); stdcall;

        /// Returns the list of character ranges supported by the font, which is
        /// useful for scenarios like character picking, glyph display, and
        /// efficient font selection lookup. This is similar to GDI's
        /// GetFontUnicodeRanges, except that it returns the full Unicode range,
        /// not just 16-bit UCS-2.
        /// <param name="maxRangeCount">Maximum number of character ranges passed
        ///     in from the client.</param>
        /// <param name="unicodeRanges">Array of character ranges.</param>
        /// <param name="actualRangeCount">Actual number of character ranges,
        ///     regardless of the maximum count.</param>
        /// <remarks>
        /// These ranges are from the cmap, not the OS/2::ulCodePageRange1.
        /// </remarks>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetUnicodeRanges(maxRangeCount: uint32;
        {_Out_writes_to_opt_(maxRangeCount, *actualRangeCount)} unicodeRanges: PDWRITE_UNICODE_RANGE;
        {_Out_} actualRangeCount: PUINT32): HRESULT; stdcall;

        /// Returns true if the font is monospaced, meaning its characters are the
        /// same fixed-pitch width (non-proportional).
        function IsMonospacedFont(): boolean; stdcall;

        /// Returns the advances in design units for a sequences of glyphs.
        /// <param name="glyphCount">Number of glyphs to retrieve advances for.</param>
        /// <param name="glyphIndices">Array of glyph id's to retrieve advances for.</param>
        /// <param name="glyphAdvances">Returned advances in font design units for
        ///     each glyph.</param>
        /// <param name="isSideways">Retrieve the glyph's vertical advance height
        ///     rather than horizontal advance widths.</param>
        /// <remarks>
        /// This is equivalent to calling GetGlyphMetrics and using only the
        /// advance width/height.
        /// </remarks>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetDesignGlyphAdvances(glyphCount: uint32;
        {_In_reads_(glyphCount)} glyphIndices: PUINT16;
        {_Out_writes_(glyphCount)} glyphAdvances: PINT32; isSideways: boolean = False): HRESULT; stdcall;

        /// Returns the pixel-aligned advances for a sequences of glyphs, the same
        /// as GetGdiCompatibleGlyphMetrics would return.
        /// <param name="emSize">Logical size of the font in DIP units. A DIP
        ///     ("device-independent pixel") equals 1/96 inch.</param>
        /// <param name="pixelsPerDip">Number of physical pixels per DIP. For
        ///     example, if the DPI of the rendering surface is 96 this value is
        ///     1.0f. If the DPI is 120, this value is 120.0f/96.</param>
        /// <param name="transform">Optional transform applied to the glyphs and
        ///     their positions. This transform is applied after the scaling
        ///     specified by the font size and pixelsPerDip.</param>
        /// <param name="useGdiNatural">When FALSE, the metrics are the same as
        ///     GDI aliased text (DWRITE_MEASURING_MODE_GDI_CLASSIC). When TRUE,
        ///     the metrics are the same as those measured by GDI using a font
        ///     using CLEARTYPE_NATURAL_QUALITY (DWRITE_MEASURING_MODE_GDI_NATURAL).</param>
        /// <param name="isSideways">Retrieve the glyph's vertical advances rather
        ///     than horizontal advances.</param>
        /// <param name="glyphCount">Total glyphs to retrieve adjustments for.</param>
        /// <param name="glyphIndices">Array of glyph id's to retrieve advances.</param>
        /// <param name="glyphAdvances">Returned advances in font design units for
        ///     each glyph.</param>
        /// <remarks>
        /// This is equivalent to calling GetGdiCompatibleGlyphMetrics and using only
        /// the advance width/height. Like GetGdiCompatibleGlyphMetrics, these are in
        /// design units, meaning they must be scaled down by
        /// DWRITE_FONT_METRICS::designUnitsPerEm.
        /// </remarks>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetGdiCompatibleGlyphAdvances(emSize: single; pixelsPerDip: single;
        {_In_opt_} transform: PDWRITE_MATRIX; useGdiNatural: boolean; isSideways: boolean; glyphCount: uint32;
        {_In_reads_(glyphCount)} glyphIndices: PUINT16;
        {_Out_writes_(glyphCount)} glyphAdvances: PINT32): HRESULT; stdcall;

        /// Retrieves the kerning pair adjustments from the font's kern table.
        /// <param name="glyphCount">Number of glyphs to retrieve adjustments for.</param>
        /// <param name="glyphIndices">Array of glyph id's to retrieve adjustments
        ///     for.</param>
        /// <param name="glyphAdvanceAdjustments">Returned advances in font design units for
        ///     each glyph. The last glyph adjustment is zero.</param>
        /// <remarks>
        /// This is not a direct replacement for GDI's character based
        /// GetKerningPairs, but it serves the same role, without the client
        /// needing to cache them locally. It also uses glyph id's directly
        /// rather than UCS-2 characters (how the kern table actually stores
        /// them) which avoids glyph collapse and ambiguity, such as the dash
        /// and hyphen, or space and non-breaking space.
        /// </remarks>
        /// <remarks>
        /// Newer fonts may have only GPOS kerning instead of the legacy pair
        /// table kerning. Such fonts, like Gabriola, will only return 0's for
        /// adjustments. This function does not virtualize and flatten these
        /// GPOS entries into kerning pairs.
        /// </remarks>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetKerningPairAdjustments(glyphCount: uint32;
        {_In_reads_(glyphCount)} glyphIndices: PUINT16;
        {_Out_writes_(glyphCount)} glyphAdvanceAdjustments: PINT32): HRESULT; stdcall;

        /// Returns whether or not the font supports pair-kerning.
        /// <remarks>
        /// If the font does not support pair table kerning, there is no need to
        /// call GetKerningPairAdjustments (it would be all zeroes).
        /// </remarks>
        /// <returns>
        /// Whether the font supports kerning pairs.
        /// </returns>
        function HasKerningPairs(): boolean; stdcall;

        /// Determines the recommended text rendering mode to be used based on the
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
        /// <param name="renderingMode">Receives the recommended rendering mode.</param>
        /// <remarks>
        /// This method should be used to determine the actual rendering mode in cases where the rendering
        /// mode of the rendering params object is DWRITE_RENDERING_MODE_DEFAULT.
        /// </remarks>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetRecommendedRenderingMode(fontEmSize: single; dpiX: single; dpiY: single;
        {_In_opt_} transform: PDWRITE_MATRIX; isSideways: boolean; outlineThreshold: TDWRITE_OUTLINE_THRESHOLD; measuringMode: TDWRITE_MEASURING_MODE;
        {_Out_} renderingMode: PDWRITE_RENDERING_MODE): HRESULT; stdcall;

        /// Retrieves the vertical forms of the nominal glyphs retrieved from
        /// GetGlyphIndices, using the font's 'vert' table. This is used in
        /// CJK vertical layout so the correct characters are shown.
        /// <param name="glyphCount">Number of glyphs to retrieve.</param>
        /// <param name="nominalGlyphIndices">Original glyph indices from cmap.</param>
        /// <param name="verticalGlyphIndices">The vertical form of glyph indices.</param>
        /// <remarks>
        /// Call GetGlyphIndices to get the nominal glyph indices, followed by
        /// calling this to remap the to the substituted forms, when the run
        /// is sideways, and the font has vertical glyph variants.
        /// </remarks>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetVerticalGlyphVariants(glyphCount: uint32;
        {_In_reads_(glyphCount)} nominalGlyphIndices: PUINT16;
        {_Out_writes_(glyphCount)} verticalGlyphIndices: PUINT16): HRESULT; stdcall;

        /// Returns whether or not the font has any vertical glyph variants.
        /// <remarks>
        /// For OpenType fonts, this will return true if the font contains a 'vert'
        /// feature.
        /// </remarks>
        /// <returns>
        /// True if the font contains vertical glyph variants.
        /// </returns>
        function HasVerticalGlyphVariants(): boolean; stdcall;

    end;

    /// The IDWriteFont interface represents a physical font in a font collection.
    IDWriteFont1 = interface(IDWriteFont)
        ['{acd16696-8c14-4f5d-877e-fe3fc1d32738}']
        /// Gets common metrics for the font in design units.
        /// These metrics are applicable to all the glyphs within a font,
        /// and are used by applications for layout calculations.
        /// <param name="fontMetrics">Metrics structure to fill in.</param>
        procedure GetMetrics(
        {_Out_} fontMetrics: PDWRITE_FONT_METRICS1); stdcall;

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

        /// Returns the list of character ranges supported by the font, which is
        /// useful for scenarios like character picking, glyph display, and
        /// efficient font selection lookup. This is similar to GDI's
        /// GetFontUnicodeRanges, except that it returns the full Unicode range,
        /// not just 16-bit UCS-2.
        /// <param name="maxRangeCount">Maximum number of character ranges passed
        ///     in from the client.</param>
        /// <param name="unicodeRanges">Array of character ranges.</param>
        /// <param name="actualRangeCount">Actual number of character ranges,
        ///     regardless of the maximum count.</param>
        /// <remarks>
        /// These ranges are from the cmap, not the OS/2::ulCodePageRange1.
        /// </remarks>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetUnicodeRanges(maxRangeCount: uint32;
        {_Out_writes_to_opt_(maxRangeCount,*actualRangeCount)} unicodeRanges: PDWRITE_UNICODE_RANGE;
        {_Out_} actualRangeCount: PUINT32): HRESULT; stdcall;

        /// Returns true if the font is monospaced, meaning its characters are the
        /// same fixed-pitch width (non-proportional).
        function IsMonospacedFont(): boolean; stdcall;

    end;

    /// The interface that represents text rendering settings for glyph rasterization and filtering.
    IDWriteRenderingParams1 = interface(IDWriteRenderingParams)
        ['{94413cf4-a6fc-4248-8b50-6674348fcad3}']
        /// Gets the amount of contrast enhancement to use for grayscale antialiasing.
        /// Valid values are greater than or equal to zero.
        function GetGrayscaleEnhancedContrast(): single; stdcall;

    end;

    /// Analyzes various text properties for complex script processing.
    IDWriteTextAnalyzer1 = interface(IDWriteTextAnalyzer)
        ['{80DAD800-E21F-4E83-96CE-BFCCE500DB7C}']
        /// Applies spacing between characters, properly adjusting glyph clusters
        /// and diacritics.
        /// <param name="leadingSpacing">The spacing before each character, in reading order.</param>
        /// <param name="trailingSpacing">The spacing after each character, in reading order.</param>
        /// <param name="minimumAdvanceWidth">The minimum advance of each character,
        ///     to prevent characters from becoming too thin or zero-width. This
        ///     must be zero or greater.</param>
        /// <param name="textLength">The length of the clustermap and original text.</param>
        /// <param name="glyphCount">The number of glyphs.</param>
        /// <param name="clusterMap">Mapping from character ranges to glyph ranges.</param>
        /// <param name="glyphAdvances">The advance width of each glyph.</param>
        /// <param name="glyphOffsets">The offset of the origin of each glyph.</param>
        /// <param name="glyphProperties">Properties of each glyph, from GetGlyphs.</param>
        /// <param name="modifiedGlyphAdvances">The new advance width of each glyph.</param>
        /// <param name="modifiedGlyphOffsets">The new offset of the origin of each glyph.</param>
        /// <remarks>
        /// The input and output advances/offsets are allowed to alias the same array.
        /// </remarks>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function ApplyCharacterSpacing(leadingSpacing: single; trailingSpacing: single; minimumAdvanceWidth: single; textLength: uint32; glyphCount: uint32;
        {_In_reads_(textLength)} clusterMap: PUINT16;
        {_In_reads_(glyphCount)} glyphAdvances: Psingle;
        {_In_reads_(glyphCount)} glyphOffsets: PDWRITE_GLYPH_OFFSET;
        {_In_reads_(glyphCount)} glyphProperties: PDWRITE_SHAPING_GLYPH_PROPERTIES;
        {_Out_writes_(glyphCount)} modifiedGlyphAdvances: Psingle;
        {_Out_writes_(glyphCount)} modifiedGlyphOffsets: PDWRITE_GLYPH_OFFSET): HRESULT; stdcall;

        /// Retrieves the given baseline from the font.
        /// <param name="fontFace">The font face to read.</param>
        /// <param name="baseline">The baseline of interest.</param>
        /// <param name="isVertical">Whether the baseline is vertical or horizontal.</param>
        /// <param name="isSimulationAllowed">Simulate the baseline if it is missing in the font.</param>
        /// <param name="scriptAnalysis">Script analysis result from AnalyzeScript.</param>
        /// <param name="localeName">The language of the run.</param>
        /// <param name="baselineCoordinate">The baseline coordinate value in design units.</param>
        /// <param name="exists">Whether the returned baseline exists in the font.</param>
        /// <remarks>
        /// If the baseline does not exist in the font, it is not considered an
        /// error, but the function will return exists = false. You may then use
        /// heuristics to calculate the missing base, or, if the flag
        /// simulationAllowed is true, the function will compute a reasonable
        /// approximation for you.
        /// </remarks>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetBaseline(
        {_In_} fontFace: IDWriteFontFace; baseline: TDWRITE_BASELINE; isVertical: boolean; isSimulationAllowed: boolean; scriptAnalysis: TDWRITE_SCRIPT_ANALYSIS;
        {_In_opt_z_} localeName: PWCHAR;
        {_Out_} baselineCoordinate: PINT32;
        {_Out_} exists: Pboolean): HRESULT; stdcall;

        /// Analyzes a text range for script orientation, reading text and
        /// attributes from the source and reporting results to the sink.
        /// <param name="analysisSource">Source object to analyze.</param>
        /// <param name="textPosition">Starting position within the source object.</param>
        /// <param name="textLength">Length to analyze.</param>
        /// <param name="analysisSink">Callback object.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// All bidi analysis should be resolved before calling this.
        /// </remarks>
        function AnalyzeVerticalGlyphOrientation(
        {_In_} analysisSource: IDWriteTextAnalysisSource1; textPosition: uint32; textLength: uint32;
        {_In_} analysisSink: IDWriteTextAnalysisSink1): HRESULT; stdcall;

        /// Returns 2x3 transform matrix for the respective angle to draw the
        /// glyph run.
        /// <param name="glyphOrientationAngle">The angle reported into
        ///     SetGlyphOrientation.</param>
        /// <param name="isSideways">Whether the run's glyphs are sideways or not.</param>
        /// <param name="transform">Returned transform.</param>
        /// </remarks>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        /// <remarks>
        /// The returned displacement is zero.
        /// </remarks>
        function GetGlyphOrientationTransform(glyphOrientationAngle: TDWRITE_GLYPH_ORIENTATION_ANGLE; isSideways: boolean;
        {_Out_} transform: PDWRITE_MATRIX): HRESULT; stdcall;

        /// Returns the properties for a given script.
        /// <param name="scriptAnalysis">The script for a run of text returned
        ///     from IDWriteTextAnalyzer::AnalyzeScript.</param>
        /// <param name="scriptProperties">Information for the script.</param>
        /// <returns>
        /// Returns properties for the given script. If the script is invalid,
        /// it returns generic properties for the unknown script and E_INVALIDARG.
        /// </returns>
        function GetScriptProperties(scriptAnalysis: TDWRITE_SCRIPT_ANALYSIS;
        {_Out_} scriptProperties: PDWRITE_SCRIPT_PROPERTIES): HRESULT; stdcall;

        /// Determines the complexity of text, and whether or not full script
        /// shaping needs to be called (GetGlyphs).
        /// <param name="fontFace">The font face to read.</param>
        /// <param name="textLength">Length of the text to check.</param>
        /// <param name="textString">The text to check for complexity. This string
        ///     may be UTF-16, but any supplementary characters will be considered
        ///     complex.</param>
        /// <param name="isTextSimple">If true, the text is simple, and the
        ///     glyphIndices array will already have the nominal glyphs for you.
        ///     Otherwise you need to call GetGlyphs to properly shape complex
        ///     scripts and OpenType features.
        ///     </param>
        /// <param name="textLengthRead">The length read of the text run with the
        ///     same complexity, simple or complex. You may call again from that
        ///     point onward.</param>
        /// <param name="glyphIndices">Optional glyph indices for the text. If the
        ///     function returned that the text was simple, you already have the
        ///     glyphs you need. Otherwise the glyph indices are not meaningful,
        ///     and you should call shaping instead.</param>
        /// <remarks>
        /// Text is not simple if the characters are part of a script that has
        /// complex shaping requirements, require bidi analysis, combine with
        /// other characters, reside in the supplementary planes, or have glyphs
        /// which participate in standard OpenType features. The length returned
        /// will not split combining marks from their base characters.
        /// </remarks>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetTextComplexity(
        {_In_reads_(textLength)} textString: PWCHAR; textLength: uint32;
        {_In_} fontFace: IDWriteFontFace;
        {_Out_} isTextSimple: Pboolean;
        {_Out_range_(0, textLength)} textLengthRead: PUINT32;
        {_Out_writes_to_opt_(textLength, *textLengthRead)}  glyphIndices: PUINT16): HRESULT; stdcall;

        /// Retrieves justification opportunity information for each of the glyphs
        /// given the text and shaping glyph properties.
        /// <param name="fontFace">Font face that was used for shaping. This is
        ///     mainly important for returning correct results of the kashida
        ///     width.</param>
        /// <param name="fontEmSize">Font em size used for the glyph run.</param>
        /// <param name="scriptAnalysis">Script of the text from the itemizer.</param>
        /// <param name="textLength">Length of the text.</param>
        /// <param name="glyphCount">Number of glyphs.</param>
        /// <param name="textString">Characters used to produce the glyphs.</param>
        /// <param name="clusterMap">Clustermap produced from shaping.</param>
        /// <param name="glyphProperties">Glyph properties produced from shaping.</param>
        /// <param name="justificationOpportunities">Receives information for the
        ///     allowed justification expansion/compression for each glyph.</param>
        /// <remarks>
        /// This function is called per-run, after shaping is done via GetGlyphs().
        /// Note this function only supports natural metrics (DWRITE_MEASURING_MODE_NATURAL).
        /// </remarks>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetJustificationOpportunities(
        {_In_opt_} fontFace: IDWriteFontFace; fontEmSize: single; scriptAnalysis: TDWRITE_SCRIPT_ANALYSIS; textLength: uint32; glyphCount: uint32;
        {_In_reads_(textLength)} textString: PWCHAR;
        {_In_reads_(textLength)} clusterMap: PUINT16;
        {_In_reads_(glyphCount)} glyphProperties: PDWRITE_SHAPING_GLYPH_PROPERTIES;
        {_Out_writes_(glyphCount)} justificationOpportunities: PDWRITE_JUSTIFICATION_OPPORTUNITY): HRESULT; stdcall;

        /// Justifies an array of glyph advances to fit the line width.
        /// <param name="lineWidth">Width of the line.</param>
        /// <param name="glyphCount">Number of glyphs.</param>
        /// <param name="justificationOpportunities">Opportunities per glyph. Call
        ///     GetJustificationOpportunities() to get suitable opportunities
        ///     according to script.</param>
        /// <param name="glyphAdvances">Original glyph advances from shaping.</param>
        /// <param name="glyphOffsets">Original glyph offsets from shaping.</param>
        /// <param name="justifiedGlyphAdvances">Justified glyph advances.</param>
        /// <param name="justifiedGlyphOffsets">Justified glyph offsets.</param>
        /// <remarks>
        /// This is called after all the opportunities have been collected, and it
        /// spans across the entire line. The input and output arrays are allowed
        /// to alias each other, permitting in-place update.
        /// </remarks>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function JustifyGlyphAdvances(lineWidth: single; glyphCount: uint32;
        {_In_reads_(glyphCount)} justificationOpportunities: PDWRITE_JUSTIFICATION_OPPORTUNITY;
        {_In_reads_(glyphCount)} glyphAdvances: Psingle;
        {_In_reads_(glyphCount)} glyphOffsets: PDWRITE_GLYPH_OFFSET;
        {_Out_writes_(glyphCount)} justifiedGlyphAdvances: Psingle;
        {_Out_writes_opt_(glyphCount)} justifiedGlyphOffsets: PDWRITE_GLYPH_OFFSET): HRESULT; stdcall;

        /// Fills in new glyphs for complex scripts where justification increased
        /// the advances of glyphs, such as Arabic with kashida.
        /// <param name="fontFace">Font face used for shaping.</param>
        /// <param name="fontEmSize">Font em size used for the glyph run.</param>
        /// <param name="scriptAnalysis">Script of the text from the itemizer.</param>
        /// <param name="textLength">Length of the text.</param>
        /// <param name="glyphCount">Number of glyphs.</param>
        /// <param name="maxGlyphCount">Maximum number of output glyphs allocated
        ///     by caller.</param>
        /// <param name="clusterMap">Clustermap produced from shaping.</param>
        /// <param name="glyphIndices">Original glyphs produced from shaping.</param>
        /// <param name="glyphAdvances">Original glyph advances produced from shaping.</param>
        /// <param name="justifiedGlyphAdvances">Justified glyph advances from
        ///     JustifyGlyphAdvances().</param>
        /// <param name="justifiedGlyphOffsets">Justified glyph offsets from
        ///     JustifyGlyphAdvances().</param>
        /// <param name="glyphProperties">Properties of each glyph, from GetGlyphs.</param>
        /// <param name="actualGlyphCount">The new glyph count written to the
        ///     modified arrays, or the needed glyph count if the size is not
        ///     large enough.</param>
        /// <param name="modifiedClusterMap">Updated clustermap.</param>
        /// <param name="modifiedGlyphIndices">Updated glyphs with new glyphs
        ///     inserted where needed.</param>
        /// <param name="modifiedGlyphAdvances">Updated glyph advances.</param>
        /// <param name="modifiedGlyphOffsets">Updated glyph offsets.</param>
        /// <remarks>
        /// This is called after the line has been justified, and it is per-run.
        /// It only needs to be called if the script has a specific justification
        /// character via GetScriptProperties, and it is mainly for cursive scripts
        /// like Arabic. If maxGlyphCount is not large enough, the error
        /// E_NOT_SUFFICIENT_BUFFER will be returned, with actualGlyphCount holding
        /// the final/needed glyph count.
        /// </remarks>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetJustifiedGlyphs(
        {_In_opt_} fontFace: IDWriteFontFace; fontEmSize: single; scriptAnalysis: TDWRITE_SCRIPT_ANALYSIS; textLength: uint32; glyphCount: uint32; maxGlyphCount: uint32;
        {_In_reads_opt_(textLength)} clusterMap: PUINT16;
        {_In_reads_(glyphCount)} glyphIndices: PUINT16;
        {_In_reads_(glyphCount)} glyphAdvances: Psingle;
        {_In_reads_(glyphCount)} justifiedGlyphAdvances: Psingle;
        {_In_reads_(glyphCount)} justifiedGlyphOffsets: PDWRITE_GLYPH_OFFSET;
        {_In_reads_(glyphCount)} glyphProperties: PDWRITE_SHAPING_GLYPH_PROPERTIES;
        {_Out_range_(glyphCount, maxGlyphCount)}  actualGlyphCount: PUINT32;
        {_Out_writes_opt_(textLength)} modifiedClusterMap: PUINT16;
        {_Out_writes_to_(maxGlyphCount, *actualGlyphCount)}  modifiedGlyphIndices: PUINT16;
        {_Out_writes_to_(maxGlyphCount, *actualGlyphCount)}  modifiedGlyphAdvances: PSingle;
        {_Out_writes_to_(maxGlyphCount, *actualGlyphCount)}  modifiedGlyphOffsets: PDWRITE_GLYPH_OFFSET): HRESULT; stdcall;

    end;

    /// The interface implemented by the client to provide needed information to
    /// the text analyzer, such as the text and associated text properties.
    /// If any of these callbacks returns an error, the analysis functions will
    /// stop prematurely and return a callback error.
    IDWriteTextAnalysisSource1 = interface(IDWriteTextAnalysisSource)
        ['{639CFAD8-0FB4-4B21-A58A-067920120009}']
        /// The text analyzer calls back to this to get the desired glyph
        /// orientation and resolved bidi level, which it uses along with the
        /// script properties of the text to determine the actual orientation of
        /// each character, which it reports back to the client via the sink
        /// SetGlyphOrientation method.
        /// <param name="textPosition">First position of the piece to obtain. All
        ///     positions are in UTF-16 code-units, not whole characters, which
        ///     matters when supplementary characters are used.</param>
        /// <param name="textLength">Number of UTF-16 units of the retrieved chunk.
        ///     The returned length is not the length of the block, but the length
        ///     remaining in the block, from the given position until its end.
        ///     So querying for a position that is 75 positions into a 100
        ///     postition block would return 25.</param>
        /// <param name="glyphOrientation">The type of glyph orientation the
        ///     client wants for this range, up to the returned text length.</param>
        /// <param name="bidiLevel">The bidi level for this range up to
        ///     the returned text length, which comes from an earlier
        ///     bidirectional analysis.</param>
        /// <returns>
        /// Standard HRESULT error code. Returning an error will abort the
        /// analysis.
        /// </returns>
        function GetVerticalGlyphOrientation(textPosition: uint32;
        {_Out_} textLength: PUINT32;
        {_Out_} glyphOrientation: PDWRITE_VERTICAL_GLYPH_ORIENTATION;
        {_Out_} bidiLevel: PUINT8): HRESULT; stdcall;

    end;

    /// The interface implemented by the client to receive the
    /// output of the text analyzers.
    IDWriteTextAnalysisSink1 = interface(IDWriteTextAnalysisSink)
        ['{B0D941A0-85E7-4D8B-9FD3-5CED9934482A}']
        /// The text analyzer calls back to this to report the actual orientation
        /// of each character for shaping and drawing.
        /// <param name="textPosition">Starting position to report from.</param>
        /// <param name="textLength">Number of UTF-16 units of the reported range.</param>
        /// <param name="glyphOrientationAngle">Angle of the glyphs within the text
        ///     range (pass to GetGlyphOrientationTransform to get the world
        ///     relative transform).</param>
        /// <param name="adjustedBidiLevel">The adjusted bidi level to be used by
        ///     the client layout for reordering runs. This will differ from the
        ///     resolved bidi level retrieved from the source for cases such as
        ///     Arabic stacked top-to-bottom, where the glyphs are still shaped
        ///     as RTL, but the runs are TTB along with any CJK or Latin.</param>
        /// <param name="isSideways">Whether the glyphs are rotated on their side,
        ///     which is the default case for CJK and the case stacked Latin</param>
        /// <param name="isRightToLeft">Whether the script should be shaped as
        ///     right-to-left. For Arabic stacked top-to-bottom, even when the
        ///     adjusted bidi level is coerced to an even level, this will still
        ///     be true.</param>
        /// <returns>
        /// A successful code or error code to abort analysis.
        /// </returns>
        function SetGlyphOrientation(textPosition: uint32; textLength: uint32; glyphOrientationAngle: TDWRITE_GLYPH_ORIENTATION_ANGLE; adjustedBidiLevel: uint8;
            isSideways: boolean; isRightToLeft: boolean): HRESULT; stdcall;

    end;

    /// The IDWriteTextLayout1 interface represents a block of text after it has
    /// been fully analyzed and formatted.
    ///
    /// All coordinates are in device independent pixels (DIPs).
    IDWriteTextLayout1 = interface(IDWriteTextLayout)
        ['{9064D822-80A7-465C-A986-DF65F78B8FEB}']
        /// Enables/disables pair-kerning on the given range.
        /// <param name="isPairKerningEnabled">The Boolean flag indicates whether text is pair-kerned.</param>
        /// <param name="textRange">Text range to which this change applies.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function SetPairKerning(isPairKerningEnabled: boolean; textRange: TDWRITE_TEXT_RANGE): HRESULT; stdcall;

        /// Get whether or not pair-kerning is enabled at given position.
        /// <param name="currentPosition">The current text position.</param>
        /// <param name="isPairKerningEnabled">The Boolean flag indicates whether text is pair-kerned.</param>
        /// <param name="textRange">The position range of the current format.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetPairKerning(currentPosition: uint32;
        {_Out_} isPairKerningEnabled: Pboolean;
        {_Out_opt_} textRange: PDWRITE_TEXT_RANGE = nil): HRESULT; stdcall;

        /// Sets the spacing between characters.
        /// <param name="leadingSpacing">The spacing before each character, in reading order.</param>
        /// <param name="trailingSpacing">The spacing after each character, in reading order.</param>
        /// <param name="minimumAdvanceWidth">The minimum advance of each character,
        ///     to prevent characters from becoming too thin or zero-width. This
        ///     must be zero or greater.</param>
        /// <param name="textRange">Text range to which this change applies.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function SetCharacterSpacing(leadingSpacing: single; trailingSpacing: single; minimumAdvanceWidth: single; textRange: TDWRITE_TEXT_RANGE): HRESULT; stdcall;

        /// Gets the spacing between characters.
        /// <param name="currentPosition">The current text position.</param>
        /// <param name="leadingSpacing">The spacing before each character, in reading order.</param>
        /// <param name="trailingSpacing">The spacing after each character, in reading order.</param>
        /// <param name="minimumAdvanceWidth">The minimum advance of each character,
        ///     to prevent characters from becoming too thin or zero-width. This
        ///     must be zero or greater.</param>
        /// <param name="textRange">The position range of the current format.</param>
        /// <returns>
        /// Standard HRESULT error code.
        /// </returns>
        function GetCharacterSpacing(currentPosition: uint32;
        {_Out_} leadingSpacing: Psingle;
        {_Out_} trailingSpacing: Psingle;
        {_Out_} minimumAdvanceWidth: Psingle;
        {_Out_opt_} textRange: PDWRITE_TEXT_RANGE = nil): HRESULT; stdcall;

    end;

    /// Represents the type of antialiasing to use for text when the rendering mode calls for
    /// antialiasing.
    TDWRITE_TEXT_ANTIALIAS_MODE = (
        /// ClearType antialiasing computes coverage independently for the red, green, and blue
        /// color elements of each pixel. This allows for more detail than conventional antialiasing.
        /// However, because there is no one alpha value for each pixel, ClearType is not suitable
        /// rendering text onto a transparent intermediate bitmap.
        DWRITE_TEXT_ANTIALIAS_MODE_CLEARTYPE,
        /// Grayscale antialiasing computes one coverage value for each pixel. Because the alpha
        /// value of each pixel is well-defined, text can be rendered onto a transparent bitmap,
        /// which can then be composited with other content. Note that grayscale rendering with
        /// IDWriteBitmapRenderTarget1 uses premultiplied alpha.
        DWRITE_TEXT_ANTIALIAS_MODE_GRAYSCALE
        );

    PDWRITE_TEXT_ANTIALIAS_MODE = ^TDWRITE_TEXT_ANTIALIAS_MODE;

    /// Encapsulates a 32-bit device independent bitmap and device context, which can be used for rendering glyphs.
    IDWriteBitmapRenderTarget1 = interface(IDWriteBitmapRenderTarget)
        ['{791e8298-3ef3-4230-9880-c9bdecc42064}']
        /// Gets the current text antialiasing mode of the bitmap render target.
        /// <returns>
        /// Returns the antialiasing mode.
        /// </returns>
        function GetTextAntialiasMode(): TDWRITE_TEXT_ANTIALIAS_MODE; stdcall;

        /// Sets the current text antialiasing mode of the bitmap render target.
        /// <returns>
        /// Returns S_OK if successful, or E_INVALIDARG if the argument is not valid.
        /// </returns>
        /// <remarks>
        /// The antialiasing mode of a newly-created bitmap render target defaults to
        /// DWRITE_TEXT_ANTIALIAS_MODE_CLEARTYPE. An application can change the antialiasing
        /// mode by calling SetTextAntialiasMode. For example, an application might specify
        /// grayscale antialiasing when rendering text onto a transparent bitmap.
        /// </remarks>
        function SetTextAntialiasMode(antialiasMode: TDWRITE_TEXT_ANTIALIAS_MODE): HRESULT; stdcall;

    end;

implementation


end.
