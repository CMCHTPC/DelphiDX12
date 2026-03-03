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

   Copyright (C) Microsoft Corporation.
   Licensed under the MIT license

   This unit consists of the following header files
   File name: d2d1svg.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.D2D1SVG;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}


interface

uses
    Windows, Classes, SysUtils,
    Win32.ObjIdl,
    DX12.D2D1,
    DX12.D2D1DWrite,
    DX12.D2D1_1,
    DX12.D2D1_2;

    {$Z4}

const
    IID_ID2D1SvgAttribute: TGUID = '{c9cdb0dd-f8c9-4e70-b7c2-301c80292c5e}';
    IID_ID2D1SvgPaint: TGUID = '{d59bab0a-68a2-455b-a5dc-9eb2854e2490}';
    IID_ID2D1SvgStrokeDashArray: TGUID = '{f1c0ca52-92a3-4f00-b4ce-f35691efd9d9}';
    IID_ID2D1SvgPointCollection: TGUID = '{9dbe4c0d-3572-4dd9-9825-5530813bb712}';
    IID_ID2D1SvgPathData: TGUID = '{c095e4f4-bb98-43d6-9745-4d1b84ec9888}';
    IID_ID2D1SvgElement: TGUID = '{ac7b67a6-183e-49c1-a823-0ebe40b0db29}';
    IID_ID2D1SvgDocument: TGUID = '{86b88e4d-afa4-4d7b-88e4-68a51c4a0aec}';

type
    REFIID = ^TGUID;

    ID2D1SvgDocument = interface;


    ID2D1SvgElement = interface;

    /// Specifies the paint type for an SVG fill or stroke.
    TD2D1_SVG_PAINT_TYPE = (
        /// The fill or stroke is not rendered.
        D2D1_SVG_PAINT_TYPE_NONE = 0,
        /// A solid color is rendered.
        D2D1_SVG_PAINT_TYPE_COLOR = 1,
        /// The current color is rendered.
        D2D1_SVG_PAINT_TYPE_CURRENT_COLOR = 2,
        /// A paint server, defined by another element in the SVG document, is used.
        D2D1_SVG_PAINT_TYPE_URI = 3,
        /// A paint server, defined by another element in the SVG document, is used. If the
        /// paint server reference is invalid, fall back to D2D1_SVG_PAINT_TYPE_NONE.
        D2D1_SVG_PAINT_TYPE_URI_NONE = 4,
        /// A paint server, defined by another element in the SVG document, is used. If the
        /// paint server reference is invalid, fall back to D2D1_SVG_PAINT_TYPE_COLOR.
        D2D1_SVG_PAINT_TYPE_URI_COLOR = 5,
        /// A paint server, defined by another element in the SVG document, is used. If the
        /// paint server reference is invalid, fall back to
        /// D2D1_SVG_PAINT_TYPE_CURRENT_COLOR.
        D2D1_SVG_PAINT_TYPE_URI_CURRENT_COLOR = 6,
        D2D1_SVG_PAINT_TYPE_FORCE_DWORD = $ffffffff
        );

    PD2D1_SVG_PAINT_TYPE = ^TD2D1_SVG_PAINT_TYPE;

    /// Specifies the units for an SVG length.
    TD2D1_SVG_LENGTH_UNITS = (
        /// The length is unitless.
        D2D1_SVG_LENGTH_UNITS_NUMBER = 0,
        /// The length is a percentage value.
        D2D1_SVG_LENGTH_UNITS_PERCENTAGE = 1,
        D2D1_SVG_LENGTH_UNITS_FORCE_DWORD = $ffffffff
        );

    PD2D1_SVG_LENGTH_UNITS = ^TD2D1_SVG_LENGTH_UNITS;

    /// Specifies a value for the SVG display property.
    TD2D1_SVG_DISPLAY = (
        /// The element uses the default display behavior.
        D2D1_SVG_DISPLAY_INLINE = 0,
        /// The element and all children are not rendered directly.
        D2D1_SVG_DISPLAY_NONE = 1,
        D2D1_SVG_DISPLAY_FORCE_DWORD = $ffffffff
        );

    PD2D1_SVG_DISPLAY = ^TD2D1_SVG_DISPLAY;

    /// Specifies a value for the SVG visibility property.
    TD2D1_SVG_VISIBILITY = (
        /// The element is visible.
        D2D1_SVG_VISIBILITY_VISIBLE = 0,
        /// The element is invisible.
        D2D1_SVG_VISIBILITY_HIDDEN = 1,
        D2D1_SVG_VISIBILITY_FORCE_DWORD = $ffffffff
        );

    PD2D1_SVG_VISIBILITY = ^TD2D1_SVG_VISIBILITY;

    /// Specifies a value for the SVG overflow property.
    TD2D1_SVG_OVERFLOW = (
        /// The element is not clipped to its viewport.
        D2D1_SVG_OVERFLOW_VISIBLE = 0,
        /// The element is clipped to its viewport.
        D2D1_SVG_OVERFLOW_HIDDEN = 1,
        D2D1_SVG_OVERFLOW_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_SVG_OVERFLOW = ^TD2D1_SVG_OVERFLOW;

    /// Specifies a value for the SVG stroke-linecap property.
    TD2D1_SVG_LINE_CAP = (
        /// The property is set to SVG's 'butt' value.
        D2D1_SVG_LINE_CAP_BUTT = Ord(D2D1_CAP_STYLE_FLAT),
        /// The property is set to SVG's 'square' value.
        D2D1_SVG_LINE_CAP_SQUARE = Ord(D2D1_CAP_STYLE_SQUARE),
        /// The property is set to SVG's 'round' value.
        D2D1_SVG_LINE_CAP_ROUND = Ord(D2D1_CAP_STYLE_ROUND),
        D2D1_SVG_LINE_CAP_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_SVG_LINE_CAP = ^TD2D1_SVG_LINE_CAP;

    /// Specifies a value for the SVG stroke-linejoin property.
    TD2D1_SVG_LINE_JOIN = (
        /// The property is set to SVG's 'bevel' value.
        D2D1_SVG_LINE_JOIN_BEVEL = Ord(D2D1_LINE_JOIN_BEVEL),
        /// The property is set to SVG's 'miter' value. Note that this is equivalent to
        /// D2D1_LINE_JOIN_MITER_OR_BEVEL, not D2D1_LINE_JOIN_MITER.
        D2D1_SVG_LINE_JOIN_MITER = Ord(D2D1_LINE_JOIN_MITER_OR_BEVEL),
        /// \ The property is set to SVG's 'round' value.
        D2D1_SVG_LINE_JOIN_ROUND = Ord(D2D1_LINE_JOIN_ROUND),
        D2D1_SVG_LINE_JOIN_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_SVG_LINE_JOIN = ^TD2D1_SVG_LINE_JOIN;

    /// The alignment portion of the SVG preserveAspectRatio attribute.
    TD2D1_SVG_ASPECT_ALIGN = (
        /// The alignment is set to SVG's 'none' value.
        D2D1_SVG_ASPECT_ALIGN_NONE = 0,
        /// The alignment is set to SVG's 'xMinYMin' value.
        D2D1_SVG_ASPECT_ALIGN_X_MIN_Y_MIN = 1,
        /// The alignment is set to SVG's 'xMidYMin' value.
        D2D1_SVG_ASPECT_ALIGN_X_MID_Y_MIN = 2,
        /// The alignment is set to SVG's 'xMaxYMin' value.
        D2D1_SVG_ASPECT_ALIGN_X_MAX_Y_MIN = 3,
        /// The alignment is set to SVG's 'xMinYMid' value.
        D2D1_SVG_ASPECT_ALIGN_X_MIN_Y_MID = 4,
        /// The alignment is set to SVG's 'xMidYMid' value.
        D2D1_SVG_ASPECT_ALIGN_X_MID_Y_MID = 5,
        /// The alignment is set to SVG's 'xMaxYMid' value.
        D2D1_SVG_ASPECT_ALIGN_X_MAX_Y_MID = 6,
        /// The alignment is set to SVG's 'xMinYMax' value.
        D2D1_SVG_ASPECT_ALIGN_X_MIN_Y_MAX = 7,
        /// The alignment is set to SVG's 'xMidYMax' value.
        D2D1_SVG_ASPECT_ALIGN_X_MID_Y_MAX = 8,
        /// The alignment is set to SVG's 'xMaxYMax' value.
        D2D1_SVG_ASPECT_ALIGN_X_MAX_Y_MAX = 9,
        D2D1_SVG_ASPECT_ALIGN_FORCE_DWORD = longint($ffffffff)
        );

    PD2D1_SVG_ASPECT_ALIGN = ^TD2D1_SVG_ASPECT_ALIGN;

    /// The meetOrSlice portion of the SVG preserveAspectRatio attribute.
    TD2D1_SVG_ASPECT_SCALING = (
        /// Scale the viewBox up as much as possible such that the entire viewBox is visible
        /// within the viewport.
        D2D1_SVG_ASPECT_SCALING_MEET = 0,
        /// Scale the viewBox down as much as possible such that the entire viewport is
        /// covered by the viewBox.
        D2D1_SVG_ASPECT_SCALING_SLICE = 1,
        D2D1_SVG_ASPECT_SCALING_FORCE_DWORD = $ffffffff
        );

    PD2D1_SVG_ASPECT_SCALING = ^TD2D1_SVG_ASPECT_SCALING;

    /// Represents a path commmand. Each command may reference floats from the segment
    /// data. Commands ending in _ABSOLUTE interpret data as absolute coordinate.
    /// Commands ending in _RELATIVE interpret data as being relative to the previous
    /// point.
    TD2D1_SVG_PATH_COMMAND = (
        /// Closes the current subpath. Uses no segment data.
        D2D1_SVG_PATH_COMMAND_CLOSE_PATH = 0,
        /// Starts a new subpath at the coordinate (x y). Uses 2 floats of segment data.
        D2D1_SVG_PATH_COMMAND_MOVE_ABSOLUTE = 1,
        /// Starts a new subpath at the coordinate (x y). Uses 2 floats of segment data.
        D2D1_SVG_PATH_COMMAND_MOVE_RELATIVE = 2,
        /// Draws a line to the coordinate (x y). Uses 2 floats of segment data.
        D2D1_SVG_PATH_COMMAND_LINE_ABSOLUTE = 3,
        /// Draws a line to the coordinate (x y). Uses 2 floats of segment data.
        D2D1_SVG_PATH_COMMAND_LINE_RELATIVE = 4,
        /// Draws a cubic Bezier curve (x1 y1 x2 y2 x y). The curve ends at (x, y) and is
        /// defined by the two control points (x1, y1) and (x2, y2). Uses 6 floats of
        /// segment data.
        D2D1_SVG_PATH_COMMAND_CUBIC_ABSOLUTE = 5,
        /// Draws a cubic Bezier curve (x1 y1 x2 y2 x y). The curve ends at (x, y) and is
        /// defined by the two control points (x1, y1) and (x2, y2). Uses 6 floats of
        /// segment data.
        D2D1_SVG_PATH_COMMAND_CUBIC_RELATIVE = 6,
        /// Draws a quadratic Bezier curve (x1 y1 x y). The curve ends at (x, y) and is
        /// defined by the control point (x1 y1). Uses 4 floats of segment data.
        D2D1_SVG_PATH_COMMAND_QUADRADIC_ABSOLUTE = 7,
        /// Draws a quadratic Bezier curve (x1 y1 x y). The curve ends at (x, y) and is
        /// defined by the control point (x1 y1). Uses 4 floats of segment data.
        D2D1_SVG_PATH_COMMAND_QUADRADIC_RELATIVE = 8,
        /// Draws an elliptical arc (rx ry x-axis-rotation large-arc-flag sweep-flag x y).
        /// The curve ends at (x, y) and is defined by the arc parameters. The two flags are
        /// considered set if their values are non-zero. Uses 7 floats of segment data.
        D2D1_SVG_PATH_COMMAND_ARC_ABSOLUTE = 9,
        /// Draws an elliptical arc (rx ry x-axis-rotation large-arc-flag sweep-flag x y).
        /// The curve ends at (x, y) and is defined by the arc parameters. The two flags are
        /// considered set if their values are non-zero. Uses 7 floats of segment data.
        D2D1_SVG_PATH_COMMAND_ARC_RELATIVE = 10,
        /// Draws a horizontal line to the coordinate (x). Uses 1 float of segment data.
        D2D1_SVG_PATH_COMMAND_HORIZONTAL_ABSOLUTE = 11,
        /// Draws a horizontal line to the coordinate (x). Uses 1 float of segment data.
        D2D1_SVG_PATH_COMMAND_HORIZONTAL_RELATIVE = 12,
        /// Draws a vertical line to the coordinate (y). Uses 1 float of segment data.
        D2D1_SVG_PATH_COMMAND_VERTICAL_ABSOLUTE = 13,
        /// Draws a vertical line to the coordinate (y). Uses 1 float of segment data.
        D2D1_SVG_PATH_COMMAND_VERTICAL_RELATIVE = 14,
        /// Draws a smooth cubic Bezier curve (x2 y2 x y). The curve ends at (x, y) and is
        /// defined by the control point (x2, y2). Uses 4 floats of segment data.
        D2D1_SVG_PATH_COMMAND_CUBIC_SMOOTH_ABSOLUTE = 15,
        /// Draws a smooth cubic Bezier curve (x2 y2 x y). The curve ends at (x, y) and is
        /// defined by the control point (x2, y2). Uses 4 floats of segment data.
        D2D1_SVG_PATH_COMMAND_CUBIC_SMOOTH_RELATIVE = 16,
        /// Draws a smooth quadratic Bezier curve ending at (x, y). Uses 2 floats of segment
        /// data.
        D2D1_SVG_PATH_COMMAND_QUADRADIC_SMOOTH_ABSOLUTE = 17,
        /// Draws a smooth quadratic Bezier curve ending at (x, y). Uses 2 floats of segment
        /// data.
        D2D1_SVG_PATH_COMMAND_QUADRADIC_SMOOTH_RELATIVE = 18,
        D2D1_SVG_PATH_COMMAND_FORCE_DWORD = $ffffffff
        );

    PD2D1_SVG_PATH_COMMAND = ^TD2D1_SVG_PATH_COMMAND;

    /// Defines the coordinate system used for SVG gradient or clipPath elements.
    TD2D1_SVG_UNIT_TYPE = (
        /// The property is set to SVG's 'userSpaceOnUse' value.
        D2D1_SVG_UNIT_TYPE_USER_SPACE_ON_USE = 0,
        /// The property is set to SVG's 'objectBoundingBox' value.
        D2D1_SVG_UNIT_TYPE_OBJECT_BOUNDING_BOX = 1,
        D2D1_SVG_UNIT_TYPE_FORCE_DWORD = $ffffffff
        );

    PD2D1_SVG_UNIT_TYPE = ^TD2D1_SVG_UNIT_TYPE;

    /// Defines the type of SVG string attribute to set or get.
    TD2D1_SVG_ATTRIBUTE_STRING_TYPE = (
        /// The attribute is a string in the same form as it would appear in the SVG XML.
        ///
        /// Note that when getting values of this type, the value returned may not exactly
        /// match the value that was set. Instead, the output value is a normalized version
        /// of the value. For example, an input color of 'red' may be output as '#FF0000'.
        D2D1_SVG_ATTRIBUTE_STRING_TYPE_SVG = 0,
        /// The attribute is an element ID.
        D2D1_SVG_ATTRIBUTE_STRING_TYPE_ID = 1,
        D2D1_SVG_ATTRIBUTE_STRING_TYPE_FORCE_DWORD = $ffffffff
        );

    PD2D1_SVG_ATTRIBUTE_STRING_TYPE = ^TD2D1_SVG_ATTRIBUTE_STRING_TYPE;

    /// Defines the type of SVG POD attribute to set or get.
    TD2D1_SVG_ATTRIBUTE_POD_TYPE = (
        /// The attribute is a FLOAT.
        D2D1_SVG_ATTRIBUTE_POD_TYPE_FLOAT = 0,
        /// The attribute is a D2D1_COLOR_F.
        D2D1_SVG_ATTRIBUTE_POD_TYPE_COLOR = 1,
        /// The attribute is a D2D1_FILL_MODE.
        D2D1_SVG_ATTRIBUTE_POD_TYPE_FILL_MODE = 2,
        /// The attribute is a D2D1_SVG_DISPLAY.
        D2D1_SVG_ATTRIBUTE_POD_TYPE_DISPLAY = 3,
        /// The attribute is a D2D1_SVG_OVERFLOW.
        D2D1_SVG_ATTRIBUTE_POD_TYPE_OVERFLOW = 4,
        /// The attribute is a D2D1_SVG_LINE_CAP.
        D2D1_SVG_ATTRIBUTE_POD_TYPE_LINE_CAP = 5,
        /// The attribute is a D2D1_SVG_LINE_JOIN.
        D2D1_SVG_ATTRIBUTE_POD_TYPE_LINE_JOIN = 6,
        /// The attribute is a D2D1_SVG_VISIBILITY.
        D2D1_SVG_ATTRIBUTE_POD_TYPE_VISIBILITY = 7,
        /// The attribute is a D2D1_MATRIX_3X2_F.
        D2D1_SVG_ATTRIBUTE_POD_TYPE_MATRIX = 8,
        /// The attribute is a D2D1_SVG_UNIT_TYPE.
        D2D1_SVG_ATTRIBUTE_POD_TYPE_UNIT_TYPE = 9,
        /// The attribute is a D2D1_EXTEND_MODE.
        D2D1_SVG_ATTRIBUTE_POD_TYPE_EXTEND_MODE = 10,
        /// The attribute is a D2D1_SVG_PRESERVE_ASPECT_RATIO.
        D2D1_SVG_ATTRIBUTE_POD_TYPE_PRESERVE_ASPECT_RATIO = 11,
        /// The attribute is a D2D1_SVG_VIEWBOX.
        D2D1_SVG_ATTRIBUTE_POD_TYPE_VIEWBOX = 12,
        /// The attribute is a D2D1_SVG_LENGTH.
        D2D1_SVG_ATTRIBUTE_POD_TYPE_LENGTH = 13,
        D2D1_SVG_ATTRIBUTE_POD_TYPE_FORCE_DWORD = $ffffffff
        );

    PD2D1_SVG_ATTRIBUTE_POD_TYPE = ^TD2D1_SVG_ATTRIBUTE_POD_TYPE;

    /// Represents an SVG length.
    TD2D1_SVG_LENGTH = record
        Value: single;
        units: TD2D1_SVG_LENGTH_UNITS;
    end;
    PD2D1_SVG_LENGTH = ^TD2D1_SVG_LENGTH;

    /// Represents all SVG preserveAspectRatio settings.
    TD2D1_SVG_PRESERVE_ASPECT_RATIO = record
        /// Sets the 'defer' portion of the preserveAspectRatio settings. This field only
        /// has an effect on an 'image' element that references another SVG document. As
        /// this is not currently supported, the field has no impact on rendering.
        defer: boolean;
        /// Sets the align portion of the preserveAspectRatio settings.
        align: TD2D1_SVG_ASPECT_ALIGN;
        /// Sets the meetOrSlice portion of the preserveAspectRatio settings.
        meetOrSlice: TD2D1_SVG_ASPECT_SCALING;
    end;
    PD2D1_SVG_PRESERVE_ASPECT_RATIO = ^TD2D1_SVG_PRESERVE_ASPECT_RATIO;

    /// Represents an SVG viewBox.
    TD2D1_SVG_VIEWBOX = record
        x: single;
        y: single;
        Width: single;
        Height: single;
    end;
    PD2D1_SVG_VIEWBOX = ^TD2D1_SVG_VIEWBOX;


    /// Interface describing an SVG attribute.
    ID2D1SvgAttribute = interface(ID2D1Resource)
        ['{c9cdb0dd-f8c9-4e70-b7c2-301c80292c5e}']
        /// Returns the element on which this attribute is set. Returns null if the
        /// attribute is not set on any element.
        procedure GetElement(
        {_Outptr_result_maybenull_ }  out element: ID2D1SvgElement); stdcall;

        /// Creates a clone of this attribute value. On creation, the cloned attribute is
        /// not set on any element.
        function Clone(
        {_COM_Outptr_ }  out attribute: ID2D1SvgAttribute): HRESULT; stdcall;

    end;

    /// Interface describing an SVG 'fill' or 'stroke' value.
    ID2D1SvgPaint = interface(ID2D1SvgAttribute)
        ['{d59bab0a-68a2-455b-a5dc-9eb2854e2490}']
        /// Sets the paint type.
        function SetPaintType(paintType: TD2D1_SVG_PAINT_TYPE): HRESULT; stdcall;

        /// Gets the paint type.
        function GetPaintType(): TD2D1_SVG_PAINT_TYPE; stdcall;

        /// Sets the paint color that is used if the paint type is
        /// D2D1_SVG_PAINT_TYPE_COLOR.
        function SetColor(
        {_In_ } color: PD2D1_COLOR_F): HRESULT; stdcall;

        /// Gets the paint color that is used if the paint type is
        /// D2D1_SVG_PAINT_TYPE_COLOR.
        procedure GetColor(
        {_Out_ } color: PD2D1_COLOR_F); stdcall;

        /// Sets the element id which acts as the paint server. This id is used if the paint
        /// type is D2D1_SVG_PAINT_TYPE_URI.
        function SetId(
        {_In_ } id: PCWSTR): HRESULT; stdcall;

        /// Gets the element id which acts as the paint server. This id is used if the paint
        /// type is D2D1_SVG_PAINT_TYPE_URI.
        function GetId(
        {_Out_writes_(idCount) } id: PWSTR; idCount: uint32): HRESULT; stdcall;

        /// Gets the string length of the element id which acts as the paint server. This id
        /// is used if the paint type is D2D1_SVG_PAINT_TYPE_URI. The returned string length
        /// does not include room for the null terminator.
        function GetIdLength(): uint32; stdcall;

    end;

    ID2D1SvgPaintHelper = type helper for ID2D1SvgPaint
        /// Sets the paint color that is used if the paint type is
        /// D2D1_SVG_PAINT_TYPE_COLOR.
        function SetColor(color: TD2D1_COLOR_F): HRESULT; overload;

    end;

    /// Interface describing an SVG 'stroke-dasharray' value.
    ID2D1SvgStrokeDashArray = interface(ID2D1SvgAttribute)
        ['{f1c0ca52-92a3-4f00-b4ce-f35691efd9d9}']
        /// Removes dashes from the end of the array.
        /// <param name="dashesCount">Specifies how many dashes to remove.</param>
        function RemoveDashesAtEnd(dashesCount: uint32): HRESULT; stdcall;

        /// Updates the array. Existing dashes not updated by this method are preserved. The
        /// array is resized larger if necessary to accomodate the new dashes.
        /// <param name="dashes">The dashes array.</param>
        /// <param name="dashesCount">The number of dashes to update.</param>
        /// <param name="startIndex">The index at which to begin updating dashes. Must be
        /// less than or equal to the size of the array.</param>
        function UpdateDashes(
        {_In_reads_(dashesCount) } dashes: Psingle; dashesCount: uint32; startIndex: uint32 = 0): HRESULT; stdcall; overload;

        /// Updates the array. Existing dashes not updated by this method are preserved. The
        /// array is resized larger if necessary to accomodate the new dashes.
        /// <param name="dashes">The dashes array.</param>
        /// <param name="dashesCount">The number of dashes to update.</param>
        /// <param name="startIndex">The index at which to begin updating dashes. Must be
        /// less than or equal to the size of the array.</param>
        function UpdateDashes(
        {_In_reads_(dashesCount) } dashes: PD2D1_SVG_LENGTH; dashesCount: uint32; startIndex: uint32 = 0): HRESULT; stdcall; overload;

        /// Gets dashes from the array.
        /// <param name="dashes">Buffer to contain the dashes.</param>
        /// <param name="dashesCount">The element count of buffer.</param>
        /// <param name="startIndex">The index of the first dash to retrieve.</param>
        function GetDashes(
        {_Out_writes_(dashesCount) } dashes: Psingle; dashesCount: uint32; startIndex: uint32 = 0): HRESULT; stdcall; overload;

        /// Gets dashes from the array.
        /// <param name="dashes">Buffer to contain the dashes.</param>
        /// <param name="dashesCount">The element count of buffer.</param>
        /// <param name="startIndex">The index of the first dash to retrieve.</param>
        function GetDashes(
        {_Out_writes_(dashesCount) } dashes: PD2D1_SVG_LENGTH; dashesCount: uint32; startIndex: uint32 = 0): HRESULT; stdcall; overload;

        /// Gets the number of the dashes in the array.
        function GetDashesCount(): uint32; stdcall;

    end;

    /// Interface describing an SVG 'points' value in a 'polyline' or 'polygon' element.
    ID2D1SvgPointCollection = interface(ID2D1SvgAttribute)
        ['{9dbe4c0d-3572-4dd9-9825-5530813bb712}']
        /// Removes points from the end of the array.
        /// <param name="pointsCount">Specifies how many points to remove.</param>
        function RemovePointsAtEnd(pointsCount: uint32): HRESULT; stdcall;

        /// Updates the points array. Existing points not updated by this method are
        /// preserved. The array is resized larger if necessary to accomodate the new
        /// points.
        /// <param name="points">The points array.</param>
        /// <param name="pointsCount">The number of points to update.</param>
        /// <param name="startIndex">The index at which to begin updating points. Must be
        /// less than or equal to the size of the array.</param>
        function UpdatePoints(
        {_In_reads_(pointsCount) } points: PD2D1_POINT_2F; pointsCount: uint32; startIndex: uint32 = 0): HRESULT; stdcall;

        /// Gets points from the points array.
        /// <param name="points">Buffer to contain the points.</param>
        /// <param name="pointsCount">The element count of the buffer.</param>
        /// <param name="startIndex">The index of the first point to retrieve.</param>
        function GetPoints(
        {_Out_writes_(pointsCount) } points: PD2D1_POINT_2F; pointsCount: uint32; startIndex: uint32 = 0): HRESULT; stdcall;

        /// Gets the number of points in the array.
        function GetPointsCount(): uint32; stdcall;

    end;

    /// Interface describing SVG path data. Path data can be set as the 'd' attribute on
    /// a 'path' element.
    ///
    /// The path data set is factored into two arrays. The segment data array stores all
    /// numbers and the commands array stores the set of commands. Unlike the string
    /// data set in the d attribute, each command in this representation uses a fixed
    /// number of elements in the segment data array. Therefore, the path 'M 0,0 100,0
    /// 0,100 Z' is represented as: 'M0,0 L100,0 L0,100 Z'. This is split into two
    /// arrays, with the segment data containing '0,0 100,0 0,100', and the commands
    /// containing 'M L L Z'.
    ID2D1SvgPathData = interface(ID2D1SvgAttribute)
        ['{c095e4f4-bb98-43d6-9745-4d1b84ec9888}']
        /// Removes data from the end of the segment data array.
        /// <param name="dataCount">Specifies how much data to remove.</param>
        function RemoveSegmentDataAtEnd(dataCount: uint32): HRESULT; stdcall;

        /// Updates the segment data array. Existing segment data not updated by this method
        /// are preserved. The array is resized larger if necessary to accomodate the new
        /// segment data.
        /// <param name="data">The data array.</param>
        /// <param name="dataCount">The number of data to update.</param>
        /// <param name="startIndex">The index at which to begin updating segment data. Must
        /// be less than or equal to the size of the segment data array.</param>
        function UpdateSegmentData(
        {_In_reads_(dataCount) } Data: Psingle; dataCount: uint32; startIndex: uint32 = 0): HRESULT; stdcall;

        /// Gets data from the segment data array.
        /// <param name="data">Buffer to contain the segment data array.</param>
        /// <param name="dataCount">The element count of the buffer.</param>
        /// <param name="startIndex">The index of the first segment data to retrieve.
        /// </param>
        function GetSegmentData(
        {_Out_writes_(dataCount) } Data: Psingle; dataCount: uint32; startIndex: uint32 = 0): HRESULT; stdcall;

        /// Gets the size of the segment data array.
        function GetSegmentDataCount(): uint32; stdcall;

        /// Removes commands from the end of the commands array.
        /// <param name="commandsCount">Specifies how many commands to remove.</param>
        function RemoveCommandsAtEnd(commandsCount: uint32): HRESULT; stdcall;

        /// Updates the commands array. Existing commands not updated by this method are
        /// preserved. The array is resized larger if necessary to accomodate the new
        /// commands.
        /// <param name="commands">The commands array.</param>
        /// <param name="commandsCount">The number of commands to update.</param>
        /// <param name="startIndex">The index at which to begin updating commands. Must be
        /// less than or equal to the size of the commands array.</param>
        function UpdateCommands(
        {_In_reads_(commandsCount) } commands: PD2D1_SVG_PATH_COMMAND; commandsCount: uint32; startIndex: uint32 = 0): HRESULT; stdcall;

        /// Gets commands from the commands array.
        /// <param name="commands">Buffer to contain the commands</param>
        /// <param name="commandsCount">The element count of the buffer.</param>
        /// <param name="startIndex">The index of the first commands to retrieve.</param>
        function GetCommands(
        {_Out_writes_(commandsCount) } commands: PD2D1_SVG_PATH_COMMAND; commandsCount: uint32; startIndex: uint32 = 0): HRESULT; stdcall;

        /// Gets the size of the commands array.
        function GetCommandsCount(): uint32; stdcall;

        /// Creates a path geometry object representing the path data.
        function CreatePathGeometry(fillMode: TD2D1_FILL_MODE;
        {_COM_Outptr_ }  out pathGeometry: ID2D1PathGeometry1): HRESULT; stdcall;

    end;

    /// Interface for all SVG elements.
    ID2D1SvgElement = interface(ID2D1Resource)
        ['{ac7b67a6-183e-49c1-a823-0ebe40b0db29}']
        /// Gets the document that contains this element. Returns null if the element has
        /// been removed from the tree.
        procedure GetDocument(
        {_Outptr_result_maybenull_ }  out document: ID2D1SvgDocument); stdcall;

        /// Gets the tag name.
        function GetTagName(
        {_Out_writes_(nameCount) } Name: PWSTR; nameCount: uint32): HRESULT; stdcall;

        /// Gets the string length of the tag name. The returned string length does not
        /// include room for the null terminator.
        function GetTagNameLength(): uint32; stdcall;

        /// Returns TRUE if this element represents text content, e.g. the content of a
        /// 'title' or 'desc' element. Text content does not have a tag name.
        function IsTextContent(): boolean; stdcall;

        /// Gets the parent element.
        procedure GetParent(
        {_Outptr_result_maybenull_ }  out parent: ID2D1SvgElement); stdcall;

        /// Returns whether this element has children.
        function HasChildren(): boolean; stdcall;

        /// Gets the first child of this element.
        procedure GetFirstChild(
        {_Outptr_result_maybenull_ }  out child: ID2D1SvgElement); stdcall;

        /// Gets the last child of this element.
        procedure GetLastChild(
        {_Outptr_result_maybenull_ }  out child: ID2D1SvgElement); stdcall;

        /// Gets the previous sibling of the referenceChild element.
        /// <param name="referenceChild">The referenceChild must be an immediate child of
        /// this element.</param>
        /// <param name="previousChild">The output previousChild element will be non-null if
        /// the referenceChild has a previous sibling. If the referenceChild is the first
        /// child, the output is null.</param>
        function GetPreviousChild(
        {_In_ } referenceChild: ID2D1SvgElement;
        {_COM_Outptr_result_maybenull_ }  out previousChild: ID2D1SvgElement): HRESULT; stdcall;

        /// Gets the next sibling of the referenceChild element.
        /// <param name="referenceChild">The referenceChild must be an immediate child of
        /// this element.</param>
        /// <param name="nextChild">The output nextChild element will be non-null if the
        /// referenceChild has a next sibling. If the referenceChild is the last child, the
        /// output is null.</param>
        function GetNextChild(
        {_In_ } referenceChild: ID2D1SvgElement;
        {_COM_Outptr_result_maybenull_ }  out nextChild: ID2D1SvgElement): HRESULT; stdcall;

        /// Inserts newChild as a child of this element, before the referenceChild element.
        /// If the newChild element already has a parent, it is removed from this parent as
        /// part of the insertion. Returns an error if this element cannot accept children
        /// of the type of newChild. Returns an error if the newChild is an ancestor of this
        /// element.
        /// <param name="newChild">The element to be inserted.</param>
        /// <param name="referenceChild">The element that the child should be inserted
        /// before. If referenceChild is null, the newChild is placed as the last child. If
        /// referenceChild is non-null, it must be an immediate child of this element.
        /// </param>
        function InsertChildBefore(
        {_In_ } newChild: ID2D1SvgElement;
        {_In_opt_ } referenceChild: ID2D1SvgElement = nil): HRESULT; stdcall;

        /// Appends newChild to the list of children. If the newChild element already has a
        /// parent, it is removed from this parent as part of the append operation. Returns
        /// an error if this element cannot accept children of the type of newChild. Returns
        /// an error if the newChild is an ancestor of this element.
        /// <param name="newChild">The element to be appended.</param>
        function AppendChild(
        {_In_ } newChild: ID2D1SvgElement): HRESULT; stdcall;

        /// Replaces the oldChild element with the newChild. This operation removes the
        /// oldChild from the tree. If the newChild element already has a parent, it is
        /// removed from this parent as part of the replace operation. Returns an error if
        /// this element cannot accept children of the type of newChild. Returns an error if
        /// the newChild is an ancestor of this element.
        /// <param name="newChild">The element to be inserted.</param>
        /// <param name="oldChild">The child element to be replaced. The oldChild element
        /// must be an immediate child of this element.</param>
        function ReplaceChild(
        {_In_ } newChild: ID2D1SvgElement;
        {_In_ } oldChild: ID2D1SvgElement): HRESULT; stdcall;

        /// Removes the oldChild from the tree. Children of oldChild remain children of
        /// oldChild.
        /// <param name="oldChild">The child element to be removed. The oldChild element
        /// must be an immediate child of this element.</param>
        function RemoveChild(
        {_In_ } oldChild: ID2D1SvgElement): HRESULT; stdcall;

        /// Creates an element from a tag name. The element is appended to the list of
        /// children. Returns an error if this element cannot accept children of the
        /// specified type.
        /// <param name="tagName">The tag name of the new child. An empty string is
        /// interpreted to be a text content element.</param>
        /// <param name="newChild">The new child element.</param>
        function CreateChild(
        {_In_ } tagName: PCWSTR;
        {_COM_Outptr_ }  out newChild: ID2D1SvgElement): HRESULT; stdcall;

        /// Returns true if the attribute is explicitly set on the element or if it is
        /// present within an inline style. Returns FALSE if the attribute is not a valid
        /// attribute on this element.
        /// <param name="name">The name of the attribute.</param>
        /// <param name="inherited">Outputs whether the attribute is set to the 'inherit'
        /// value.</param>
        function IsAttributeSpecified(
        {_In_ } Name: PCWSTR;
        {_Out_opt_ } _inherited: Pboolean = nil): boolean; stdcall;

        /// Returns the number of specified attributes on this element. Attributes are only
        /// considered specified if they are explicitly set on the element or present within
        /// an inline style. Properties that receive their value through CSS inheritance are
        /// not considered specified. An attribute can become specified if it is set through
        /// a method call. It can become unspecified if it is removed via RemoveAttribute.
        function GetSpecifiedAttributeCount(): uint32; stdcall;

        /// Gets the name of the specified attribute at the given index.
        /// <param name="index">The specified index of the attribute.</param>
        /// <param name="name">Outputs the name of the attribute.</param>
        /// <param name="inherited">Outputs whether the attribute is set to the 'inherit'
        /// value.</param>
        function GetSpecifiedAttributeName(index: uint32;
        {_Out_writes_(nameCount) } Name: PWSTR; nameCount: uint32;
        {_Out_opt_ } _inherited: Pboolean = nil): HRESULT; stdcall;

        /// Gets the string length of the name of the specified attribute at the given
        /// index. The output string length does not include room for the null terminator.
        /// <param name="index">The specified index of the attribute.</param>
        /// <param name="nameLength">Outputs the string length of the name of the specified
        /// attribute.</param>
        /// <param name="inherited">Outputs whether the attribute is set to the 'inherit'
        /// value.</param>
        function GetSpecifiedAttributeNameLength(index: uint32;
        {_Out_ } nameLength: PUINT32;
        {_Out_opt_ } _inherited: Pboolean = nil): HRESULT; stdcall;

        /// Removes the attribute from this element. Also removes this attribute from within
        /// an inline style if present. Returns an error if the attribute name is not valid
        /// on this element.
        function RemoveAttribute(
        {_In_ } Name: PCWSTR): HRESULT; stdcall;

        /// Sets the value of a text content element.
        function SetTextValue(
        {_In_reads_(nameCount) } Name: PWCHAR; nameCount: uint32): HRESULT; stdcall;

        /// Gets the value of a text content element.
        function GetTextValue(
        {_Out_writes_(nameCount) } Name: PWSTR; nameCount: uint32): HRESULT; stdcall;

        /// Gets the length of the text content value. The returned string length does not
        /// include room for the null terminator.
        function GetTextValueLength(): uint32; stdcall;

        /// Sets an attribute of this element using a string. Returns an error if the
        /// attribute name is not valid on this element. Returns an error if the attribute
        /// cannot be expressed as the specified type.
        function SetAttributeValue(
        {_In_ } Name: PCWSTR; stringType: TD2D1_SVG_ATTRIBUTE_STRING_TYPE;
        {_In_ } Value: PCWSTR): HRESULT; stdcall; overload;

        /// Gets an attribute of this element as a string. Returns an error if the attribute
        /// is not specified. Returns an error if the attribute name is not valid on this
        /// element. Returns an error if the attribute cannot be expressed as the specified
        /// string type.
        function GetAttributeValue(
        {_In_ } Name: PCWSTR; stringType: TD2D1_SVG_ATTRIBUTE_STRING_TYPE;
        {_Out_writes_(valueCount) } Value: PWSTR; valueCount: uint32): HRESULT; stdcall; overload;

        /// Gets the string length of an attribute of this element. The returned string
        /// length does not include room for the null terminator. Returns an error if the
        /// attribute is not specified. Returns an error if the attribute name is not valid
        /// on this element. Returns an error if the attribute cannot be expressed as the
        /// specified string type.
        function GetAttributeValueLength(
        {_In_ } Name: PCWSTR; stringType: TD2D1_SVG_ATTRIBUTE_STRING_TYPE;
        {_Out_ } valueLength: PUINT32): HRESULT; stdcall;

        /// Sets an attribute of this element using a POD type. Returns an error if the
        /// attribute name is not valid on this element. Returns an error if the attribute
        /// cannot be expressed as the specified type.
        function SetAttributeValue(
        {_In_ } Name: PCWSTR; podType: TD2D1_SVG_ATTRIBUTE_POD_TYPE;
        {_In_reads_bytes_(valueSizeInBytes) } Value: pointer; valueSizeInBytes: uint32): HRESULT; stdcall; overload;

        /// Gets an attribute of this element as a POD type. Returns an error if the
        /// attribute is not specified. Returns an error if the attribute name is not valid
        /// on this element. Returns an error if the attribute cannot be expressed as the
        /// specified POD type.
        function GetAttributeValue(
        {_In_ } Name: PCWSTR; podType: TD2D1_SVG_ATTRIBUTE_POD_TYPE;
        {_Out_writes_bytes_(valueSizeInBytes) } out Value; valueSizeInBytes: uint32): HRESULT; stdcall; overload;

        /// Sets an attribute of this element using an interface. Returns an error if the
        /// attribute name is not valid on this element. Returns an error if the attribute
        /// cannot be expressed as the specified interface type. Returns an error if the
        /// attribute object is already set on an element. A given attribute object may only
        /// be set on one element in one attribute location at a time.
        function SetAttributeValue(
        {_In_ } Name: PCWSTR;
        {_In_ } Value: ID2D1SvgAttribute): HRESULT; stdcall; overload;

        /// Gets an attribute of this element as an interface type. Returns an error if the
        /// attribute is not specified. Returns an error if the attribute name is not valid
        /// on this element. Returns an error if the attribute cannot be expressed as the
        /// specified interface type.
        /// <param name="riid">The interface ID of the attribute value.</param>
        function GetAttributeValue(
        {_In_ } Name: PCWSTR;
        {_In_ } riid: REFIID;
        {_COM_Outptr_result_maybenull_ }  out Value): HRESULT; stdcall; overload;

    end;

    ID2D1SvgElementHelper = type helper for ID2D1SvgElement
        /// Sets an attribute of this element using a float.
        function SetAttributeValue(
        {_In_ } Name: PCWSTR; Value: single): HRESULT; overload;

        /// Gets an attribute of this element as a float.
        function GetAttributeValue(
        {_In_ } Name: PCWSTR;
        {_Out_ } Value: Psingle): HRESULT; overload;

        /// Sets an attribute of this element as a color.
        function SetAttributeValue(
        {_In_ } Name: PCWSTR; Value: TD2D1_COLOR_F): HRESULT; overload;

        /// Gets an attribute of this element as a color.
        function GetAttributeValue(
        {_In_ } Name: PCWSTR;
        {_Out_ } Value: PD2D1_COLOR_F): HRESULT; overload;

        /// Sets an attribute of this element as a fill mode. This method can be used to set
        /// the value of the 'fill-rule' or 'clip-rule' properties.
        function SetAttributeValue(
        {_In_ } Name: PCWSTR; Value: TD2D1_FILL_MODE): HRESULT; overload;

        /// Gets an attribute of this element as a fill mode. This method can be used to get
        /// the value of the 'fill-rule' or 'clip-rule' properties.
        function GetAttributeValue(
        {_In_ } Name: PCWSTR;
        {_Out_ } Value: PD2D1_FILL_MODE): HRESULT; overload;

        /// Sets an attribute of this element as a display value. This method can be used to
        /// set the value of the 'display' property.
        function SetAttributeValue(
        {_In_ } Name: PCWSTR; Value: TD2D1_SVG_DISPLAY): HRESULT; overload;

        /// Gets an attribute of this element as a display value. This method can be used to
        /// get the value of the 'display' property.
        function GetAttributeValue(
        {_In_ } Name: PCWSTR;
        {_Out_ } Value: PD2D1_SVG_DISPLAY): HRESULT; overload;

        /// Sets an attribute of this element as an overflow value. This method can be used
        /// to set the value of the 'overflow' property.
        function SetAttributeValue(
        {_In_ } Name: PCWSTR; Value: TD2D1_SVG_OVERFLOW): HRESULT; overload;

        /// Gets an attribute of this element as an overflow value. This method can be used
        /// to get the value of the 'overflow' property.
        function GetAttributeValue(
        {_In_ } Name: PCWSTR;
        {_Out_ } Value: PD2D1_SVG_OVERFLOW): HRESULT; overload;

        /// Sets an attribute of this element as a line join value. This method can be used
        /// to set the value of the 'stroke-linejoin' property.
        function SetAttributeValue(
        {_In_ } Name: PCWSTR; Value: TD2D1_SVG_LINE_JOIN): HRESULT; overload;

        /// Gets an attribute of this element as a line join value. This method can be used
        /// to get the value of the 'stroke-linejoin' property.
        function GetAttributeValue(
        {_In_ } Name: PCWSTR;
        {_Out_ } Value: PD2D1_SVG_LINE_JOIN): HRESULT; overload;

        /// Sets an attribute of this element as a line cap value. This method can be used
        /// to set the value of the 'stroke-linecap' property.
        function SetAttributeValue(
        {_In_ } Name: PCWSTR; Value: TD2D1_SVG_LINE_CAP): HRESULT; overload;

        /// Gets an attribute of this element as a line cap value. This method can be used
        /// to get the value of the 'stroke-linecap' property.
        function GetAttributeValue(
        {_In_ } Name: PCWSTR;
        {_Out_ } Value: PD2D1_SVG_LINE_CAP): HRESULT; overload;

        /// Sets an attribute of this element as a visibility value. This method can be used
        /// to set the value of the 'visibility' property.
        function SetAttributeValue(
        {_In_ } Name: PCWSTR; Value: TD2D1_SVG_VISIBILITY): HRESULT; overload;

        /// Gets an attribute of this element as a visibility value. This method can be used
        /// to get the value of the 'visibility' property.
        function GetAttributeValue(
        {_In_ } Name: PCWSTR;
        {_Out_ } Value: PD2D1_SVG_VISIBILITY): HRESULT; overload;

        /// Sets an attribute of this element as a matrix value. This method can be used to
        /// set the value of a 'transform' or 'gradientTransform' attribute.
        function SetAttributeValue(
        {_In_ } Name: PCWSTR; Value: TD2D1_MATRIX_3X2_F): HRESULT; overload;

        /// Gets an attribute of this element as a matrix value. This method can be used to
        /// get the value of a 'transform' or 'gradientTransform' attribute.
        function GetAttributeValue(
        {_In_ } Name: PCWSTR;
        {_Out_ } Value: PD2D1_MATRIX_3X2_F): HRESULT; overload;

        /// Sets an attribute of this element as a unit type value. This method can be used
        /// to set the value of a 'gradientUnits' or 'clipPathUnits' attribute.
        function SetAttributeValue(
        {_In_ } Name: PCWSTR; Value: TD2D1_SVG_UNIT_TYPE): HRESULT; overload;

        /// Gets an attribute of this element as a unit type value. This method can be used
        /// to get the value of a 'gradientUnits' or 'clipPathUnits' attribute.
        function GetAttributeValue(
        {_In_ } Name: PCWSTR;
        {_Out_ } Value: PD2D1_SVG_UNIT_TYPE): HRESULT; overload;

        /// Sets an attribute of this element as an extend mode value. This method can be
        /// used to set the value of a 'spreadMethod' attribute.
        function SetAttributeValue(
        {_In_ } Name: PCWSTR; Value: TD2D1_EXTEND_MODE): HRESULT; overload;

        /// Gets an attribute of this element as a extend mode value. This method can be
        /// used to get the value of a 'spreadMethod' attribute.
        function GetAttributeValue(
        {_In_ } Name: PCWSTR;
        {_Out_ } Value: PD2D1_EXTEND_MODE): HRESULT; overload;

        /// Sets an attribute of this element as a preserve aspect ratio value. This method
        /// can be used to set the value of a 'preserveAspectRatio' attribute.
        function SetAttributeValue(
        {_In_ } Name: PCWSTR; Value: TD2D1_SVG_PRESERVE_ASPECT_RATIO): HRESULT; overload;

        /// Gets an attribute of this element as a preserve aspect ratio value. This method
        /// can be used to get the value of a 'preserveAspectRatio' attribute.
        function GetAttributeValue(
        {_In_ } Name: PCWSTR;
        {_Out_ } Value: PD2D1_SVG_PRESERVE_ASPECT_RATIO): HRESULT; overload;

        /// Sets an attribute of this element as a length value.
        function SetAttributeValue(
        {_In_ } Name: PCWSTR; Value: TD2D1_SVG_LENGTH): HRESULT; overload;

        /// Gets an attribute of this element as length value.
        function GetAttributeValue(
        {_In_ } Name: PCWSTR;
        {_Out_ } Value: PD2D1_SVG_LENGTH): HRESULT; overload;

        /// Gets an attribute of this element.
        function GetAttributeValue(
        {_In_ } Name: PCWSTR;
        {_COM_Outptr_result_maybenull_ }  out Value: ID2D1SvgAttribute): HRESULT; overload;

        /// Gets an attribute of this element as a paint. This method can be used to get the
        /// value of the 'fill' or 'stroke' properties.
        function GetAttributeValue(
        {_In_ } Name: PCWSTR;
        {_COM_Outptr_result_maybenull_ }  out Value: ID2D1SvgPaint): HRESULT; overload;

        /// Gets an attribute of this element as a stroke dash array. This method can be
        /// used to get the value of the 'stroke-dasharray' property.
        function GetAttributeValue(
        {_In_ } Name: PCWSTR;
        {_COM_Outptr_result_maybenull_ }  out Value: ID2D1SvgStrokeDashArray): HRESULT; overload;

        /// Gets an attribute of this element as points. This method can be used to get the
        /// value of the 'points' attribute on a 'polygon' or 'polyline' element.
        function GetAttributeValue(
        {_In_ } Name: PCWSTR;
        {_COM_Outptr_result_maybenull_ }  out Value: ID2D1SvgPointCollection): HRESULT; overload;

        /// Gets an attribute of this element as path data. This method can be used to get
        /// the value of the 'd' attribute on a 'path' element.
        function GetAttributeValue(
        {_In_ } Name: PCWSTR;
        {_COM_Outptr_result_maybenull_ }  out Value: ID2D1SvgPathData): HRESULT; overload;

    end;

    ID2D1SvgDocument = interface(ID2D1Resource)
        ['{86b88e4d-afa4-4d7b-88e4-68a51c4a0aec}']
        /// Sets the size of the initial viewport.
        function SetViewportSize(viewportSize: TD2D1_SIZE_F): HRESULT; stdcall;

        /// Returns the size of the initial viewport.
        function GetViewportSize(): TD2D1_SIZE_F; stdcall;

        /// Sets the root element of the document. The root element must be an 'svg'
        /// element. If the element already exists within an svg tree, it is first removed.
        function SetRoot(
        {_In_opt_ } root: ID2D1SvgElement): HRESULT; stdcall;

        /// Gets the root element of the document.
        procedure GetRoot(
        {_Outptr_result_maybenull_ }  out root: ID2D1SvgElement); stdcall;

        /// Gets the SVG element with the specified ID. If the element cannot be found, the
        /// returned element will be null.
        function FindElementById(
        {_In_ } id: PCWSTR;
        {_COM_Outptr_result_maybenull_ }  out svgElement: ID2D1SvgElement): HRESULT; stdcall;

        /// Serializes an element and its subtree to XML. The output XML is encoded as
        /// UTF-8.
        /// <param name="outputXmlStream">An output stream to contain the SVG XML subtree.
        /// </param>
        /// <param name="subtree">The root of the subtree. If null, the entire document is
        /// serialized.</param>
        function Serialize(
        {_In_ } outputXmlStream: IStream;
        {_In_opt_ } subtree: ID2D1SvgElement = nil): HRESULT; stdcall;

        /// Deserializes a subtree from the stream. The stream must have only one root
        /// element, but that root element need not be an 'svg' element. The output element
        /// is not inserted into this document tree.
        /// <param name="inputXmlStream">An input stream containing the SVG XML subtree.
        /// </param>
        /// <param name="subtree">The root of the subtree.</param>
        function Deserialize(
        {_In_ } inputXmlStream: IStream;
        {_COM_Outptr_ }  out subtree: ID2D1SvgElement): HRESULT; stdcall;

        /// Creates a paint object which can be used to set the 'fill' or 'stroke'
        /// properties.
        /// <param name="color">The color used if the paintType is
        /// D2D1_SVG_PAINT_TYPE_COLOR.</param>
        /// <param name="id">The element id which acts as the paint server. This id is used
        /// if the paint type is D2D1_SVG_PAINT_TYPE_URI.</param>
        function CreatePaint(paintType: TD2D1_SVG_PAINT_TYPE;
        {_In_opt_ } color: PD2D1_COLOR_F;
        {_In_opt_ } id: PCWSTR;
        {_COM_Outptr_ }  out paint: ID2D1SvgPaint): HRESULT; stdcall;

        /// Creates a dash array object which can be used to set the 'stroke-dasharray'
        /// property.
        function CreateStrokeDashArray(
        {_In_reads_opt_(dashesCount) } dashes: PD2D1_SVG_LENGTH; dashesCount: uint32;
        {_COM_Outptr_ }  out strokeDashArray: ID2D1SvgStrokeDashArray): HRESULT; stdcall;

        /// Creates a points object which can be used to set a 'points' attribute on a
        /// 'polygon' or 'polyline' element.
        function CreatePointCollection(
        {_In_reads_opt_(pointsCount) } points: PD2D1_POINT_2F; pointsCount: uint32;
        {_COM_Outptr_ }  out pointCollection: ID2D1SvgPointCollection): HRESULT; stdcall;

        /// Creates a path data object which can be used to set a 'd' attribute on a 'path'
        /// element.
        function CreatePathData(
        {_In_reads_opt_(segmentDataCount) } segmentData: Psingle; segmentDataCount: uint32;
        {_In_reads_opt_(commandsCount) } commands: PD2D1_SVG_PATH_COMMAND; commandsCount: uint32;
        {_COM_Outptr_ }  out pathData: ID2D1SvgPathData): HRESULT; stdcall;

    end;

    ID2D1SvgDocumentHelper = type helper for ID2D1SvgDocument
        /// Creates a paint object which can be used to set the 'fill' or 'stroke'
        /// properties.
        /// <param name="color">The color used if the paintType is
        /// D2D1_SVG_PAINT_TYPE_COLOR.</param>
        /// <param name="id">The element id which acts as the paint server. This id is used
        /// if the paint type is D2D1_SVG_PAINT_TYPE_URI.</param>
        function CreatePaint(paintType: TD2D1_SVG_PAINT_TYPE; color: TD2D1_COLOR_F;
        {_In_opt_ } id: PCWSTR;
        {_COM_Outptr_ }  out paint: ID2D1SvgPaint): HRESULT; overload;

    end;




implementation




function ID2D1SvgPaintHelper.SetColor(color: TD2D1_COLOR_F): HRESULT;
begin

    Result := SetColor(@color);

end;



function ID2D1SvgElementHelper.SetAttributeValue(
    {_In_ } Name: PCWSTR; Value: single): HRESULT;
begin

    Result :=

        SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_FLOAT, @Value, sizeof(single));

end;



function ID2D1SvgElementHelper.GetAttributeValue(
    {_In_ } Name: PCWSTR;
    {_Out_ } Value: Psingle): HRESULT;
begin

    Result :=

        GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_FLOAT, Value, sizeof(Value^));

end;



function ID2D1SvgElementHelper.SetAttributeValue(
    {_In_ } Name: PCWSTR; Value: TD2D1_COLOR_F): HRESULT;
begin

    Result :=

        SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_COLOR, @Value, sizeof(Value));

end;



function ID2D1SvgElementHelper.GetAttributeValue(
    {_In_ } Name: PCWSTR;
    {_Out_ } Value: PD2D1_COLOR_F): HRESULT;
begin

    Result :=

        GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_COLOR, Value, sizeof(Value^));

end;



function ID2D1SvgElementHelper.SetAttributeValue(
    {_In_ } Name: PCWSTR; Value: TD2D1_FILL_MODE): HRESULT;
begin

    Result :=

        SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_FILL_MODE, @Value, sizeof(Value));

end;



function ID2D1SvgElementHelper.GetAttributeValue(
    {_In_ } Name: PCWSTR;
    {_Out_ } Value: PD2D1_FILL_MODE): HRESULT;
begin

    Result :=

        GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_FILL_MODE, Value, sizeof(Value^));

end;



function ID2D1SvgElementHelper.SetAttributeValue(
    {_In_ } Name: PCWSTR; Value: TD2D1_SVG_DISPLAY): HRESULT;
begin

    Result :=

        SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_DISPLAY, @Value, sizeof(Value));

end;



function ID2D1SvgElementHelper.GetAttributeValue(
    {_In_ } Name: PCWSTR;
    {_Out_ } Value: PD2D1_SVG_DISPLAY): HRESULT;
begin

    Result :=

        GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_DISPLAY, Value, sizeof(Value^));

end;



function ID2D1SvgElementHelper.SetAttributeValue(
    {_In_ } Name: PCWSTR; Value: TD2D1_SVG_OVERFLOW): HRESULT;
begin

    Result :=

        SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_OVERFLOW, @Value, sizeof(Value));

end;



function ID2D1SvgElementHelper.GetAttributeValue(
    {_In_ } Name: PCWSTR;
    {_Out_ } Value: PD2D1_SVG_OVERFLOW): HRESULT;
begin

    Result :=

        GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_OVERFLOW, Value, sizeof(Value^));

end;



function ID2D1SvgElementHelper.SetAttributeValue(
    {_In_ } Name: PCWSTR; Value: TD2D1_SVG_LINE_JOIN): HRESULT;
begin

    Result :=

        SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_LINE_JOIN, @Value, sizeof(Value));

end;



function ID2D1SvgElementHelper.GetAttributeValue(
    {_In_ } Name: PCWSTR;
    {_Out_ } Value: PD2D1_SVG_LINE_JOIN): HRESULT;
begin

    Result :=

        GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_LINE_JOIN, Value, sizeof(Value^));

end;



function ID2D1SvgElementHelper.SetAttributeValue(
    {_In_ } Name: PCWSTR; Value: TD2D1_SVG_LINE_CAP): HRESULT;
begin

    Result :=

        SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_LINE_CAP, @Value, sizeof(Value));

end;



function ID2D1SvgElementHelper.GetAttributeValue(
    {_In_ } Name: PCWSTR;
    {_Out_ } Value: PD2D1_SVG_LINE_CAP): HRESULT;
begin

    Result :=

        GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_LINE_CAP, Value, sizeof(Value^));

end;



function ID2D1SvgElementHelper.SetAttributeValue(
    {_In_ } Name: PCWSTR; Value: TD2D1_SVG_VISIBILITY): HRESULT;
begin

    Result :=

        SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_VISIBILITY, @Value, sizeof(Value));

end;



function ID2D1SvgElementHelper.GetAttributeValue(
    {_In_ } Name: PCWSTR;
    {_Out_ } Value: PD2D1_SVG_VISIBILITY): HRESULT;
begin

    Result :=

        GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_VISIBILITY, Value, sizeof(Value^));

end;



function ID2D1SvgElementHelper.SetAttributeValue(
    {_In_ } Name: PCWSTR; Value: TD2D1_MATRIX_3X2_F): HRESULT;
begin

    Result :=

        SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_MATRIX, @Value, sizeof(Value));

end;



function ID2D1SvgElementHelper.GetAttributeValue(
    {_In_ } Name: PCWSTR;
    {_Out_ } Value: PD2D1_MATRIX_3X2_F): HRESULT;
begin

    Result :=

        GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_MATRIX, Value, sizeof(Value^));

end;



function ID2D1SvgElementHelper.SetAttributeValue(
    {_In_ } Name: PCWSTR; Value: TD2D1_SVG_UNIT_TYPE): HRESULT;
begin

    Result :=

        SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_UNIT_TYPE, @Value, sizeof(Value));

end;



function ID2D1SvgElementHelper.GetAttributeValue(
    {_In_ } Name: PCWSTR;
    {_Out_ } Value: PD2D1_SVG_UNIT_TYPE): HRESULT;
begin

    Result :=

        GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_UNIT_TYPE, Value, sizeof(Value^));

end;



function ID2D1SvgElementHelper.SetAttributeValue(
    {_In_ } Name: PCWSTR; Value: TD2D1_EXTEND_MODE): HRESULT;
begin

    Result :=

        SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_EXTEND_MODE, @Value, sizeof(Value));

end;



function ID2D1SvgElementHelper.GetAttributeValue(
    {_In_ } Name: PCWSTR;
    {_Out_ } Value: PD2D1_EXTEND_MODE): HRESULT;
begin

    Result :=

        GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_EXTEND_MODE, Value, sizeof(Value^));

end;



function ID2D1SvgElementHelper.SetAttributeValue(
    {_In_ } Name: PCWSTR; Value: TD2D1_SVG_PRESERVE_ASPECT_RATIO): HRESULT;
begin

    Result :=

        SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_PRESERVE_ASPECT_RATIO, @Value, sizeof(Value));

end;



function ID2D1SvgElementHelper.GetAttributeValue(
    {_In_ } Name: PCWSTR;
    {_Out_ } Value: PD2D1_SVG_PRESERVE_ASPECT_RATIO): HRESULT;
begin

    Result :=

        GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_PRESERVE_ASPECT_RATIO, Value, sizeof(Value^));

end;



function ID2D1SvgElementHelper.SetAttributeValue(
    {_In_ } Name: PCWSTR; Value: TD2D1_SVG_LENGTH): HRESULT;
begin

    Result :=

        SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_LENGTH, @Value, sizeof(Value));

end;



function ID2D1SvgElementHelper.GetAttributeValue(
    {_In_ } Name: PCWSTR;
    {_Out_ } Value: PD2D1_SVG_LENGTH): HRESULT;
begin

    Result :=

        GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_LENGTH, Value, sizeof(Value^));

end;



function ID2D1SvgElementHelper.GetAttributeValue(
    {_In_ } Name: PCWSTR;
    {_COM_Outptr_result_maybenull_ }  out Value: ID2D1SvgAttribute): HRESULT;
begin

    Result :=

        GetAttributeValue(Name, @IID_ID2D1SvgAttribute, (Value));

end;



function ID2D1SvgElementHelper.GetAttributeValue(
    {_In_ } Name: PCWSTR;
    {_COM_Outptr_result_maybenull_ }  out Value: ID2D1SvgPaint): HRESULT;
begin

    Result :=

        GetAttributeValue(Name, @IID_ID2D1SvgPaint, (Value));

end;



function ID2D1SvgElementHelper.GetAttributeValue(
    {_In_ } Name: PCWSTR;
    {_COM_Outptr_result_maybenull_ }  out Value: ID2D1SvgStrokeDashArray): HRESULT;
begin

    Result :=

        GetAttributeValue(Name, @IID_ID2D1SvgStrokeDashArray, (Value));

end;



function ID2D1SvgElementHelper.GetAttributeValue(
    {_In_ } Name: PCWSTR;
    {_COM_Outptr_result_maybenull_ }  out Value: ID2D1SvgPointCollection): HRESULT;
begin

    Result :=

        GetAttributeValue(Name, @IID_ID2D1SvgPointCollection, (Value));

end;



function ID2D1SvgElementHelper.GetAttributeValue(
    {_In_ } Name: PCWSTR;
    {_COM_Outptr_result_maybenull_ }  out Value: ID2D1SvgPathData): HRESULT;
begin

    Result :=

        GetAttributeValue(Name, @IID_ID2D1SvgPathData, (Value));

end;



function ID2D1SvgDocumentHelper.CreatePaint(paintType: TD2D1_SVG_PAINT_TYPE; color: TD2D1_COLOR_F;
    {_In_opt_ } id: PCWSTR;
    {_COM_Outptr_ }  out paint: ID2D1SvgPaint): HRESULT;
begin

    Result :=

        CreatePaint(paintType, @color, id, paint);

end;



end.
