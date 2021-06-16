{ **************************************************************************
  FreePascal/Delphi DirectX 12 Header Files

  Copyright 2013-2021 Norbert Sonnleitner

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

  This unit consists of the following header files
  File name: D2D1Svg.h

  Header version: 10.0.19041.0

  ************************************************************************** }
unit DX12.D2D1SVG;

{$IFDEF FPC}
{$mode delphi}
{$modeswitch typehelpers}{$H+}{$I-}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils, DX12.D2D1, DX12.DXGI,
    ActiveX;

const
    IID_ID2D1SvgAttribute: TGUID = '{c9cdb0dd-f8c9-4e70-b7c2-301c80292c5e}';
    IID_ID2D1SvgPaint: TGUID = '{d59bab0a-68a2-455b-a5dc-9eb2854e2490}';
    IID_ID2D1SvgStrokeDashArray: TGUID = '{f1c0ca52-92a3-4f00-b4ce-f35691efd9d9}';
    IID_ID2D1SvgPointCollection: TGUID = '{9dbe4c0d-3572-4dd9-9825-5530813bb712}';
    IID_ID2D1SvgPathData: TGUID = '{c095e4f4-bb98-43d6-9745-4d1b84ec9888}';
    IID_ID2D1SvgElement: TGUID = '{ac7b67a6-183e-49c1-a823-0ebe40b0db29}';
    IID_ID2D1SvgDocument: TGUID = '{86b88e4d-afa4-4d7b-88e4-68a51c4a0aec}';

type
    // Specifies the paint type for an SVG fill or stroke.
    TD2D1_SVG_PAINT_TYPE = (
        D2D1_SVG_PAINT_TYPE_NONE = 0,
        D2D1_SVG_PAINT_TYPE_COLOR = 1,
        D2D1_SVG_PAINT_TYPE_CURRENT_COLOR = 2,
        D2D1_SVG_PAINT_TYPE_URI = 3,
        D2D1_SVG_PAINT_TYPE_URI_NONE = 4,
        D2D1_SVG_PAINT_TYPE_URI_COLOR = 5,
        D2D1_SVG_PAINT_TYPE_URI_CURRENT_COLOR = 6,
        D2D1_SVG_PAINT_TYPE_FORCE_DWORD = $ffffffff
        );

    PD2D1_SVG_PAINT_TYPE = ^TD2D1_SVG_PAINT_TYPE;

    // Specifies the units for an SVG length.
    TD2D1_SVG_LENGTH_UNITS = (
        D2D1_SVG_LENGTH_UNITS_NUMBER = 0,
        D2D1_SVG_LENGTH_UNITS_PERCENTAGE = 1,
        D2D1_SVG_LENGTH_UNITS_FORCE_DWORD = $ffffffff
        );
    PD2D1_SVG_LENGTH_UNITS = ^TD2D1_SVG_LENGTH_UNITS;


    // Specifies a value for the SVG display property.
    TD2D1_SVG_DISPLAY = (
        D2D1_SVG_DISPLAY_INLINE = 0,
        D2D1_SVG_DISPLAY_NONE = 1,
        D2D1_SVG_DISPLAY_FORCE_DWORD = $ffffffff
        );

    PD2D1_SVG_DISPLAY = ^TD2D1_SVG_DISPLAY;

    // Specifies a value for the SVG visibility property.
    TD2D1_SVG_VISIBILITY = (
        D2D1_SVG_VISIBILITY_VISIBLE = 0,
        D2D1_SVG_VISIBILITY_HIDDEN = 1,
        D2D1_SVG_VISIBILITY_FORCE_DWORD = $ffffffff
        );

    PD2D1_SVG_VISIBILITY = ^TD2D1_SVG_VISIBILITY;


    // Specifies a value for the SVG overflow property.
    TD2D1_SVG_OVERFLOW = (
        D2D1_SVG_OVERFLOW_VISIBLE = 0,
        D2D1_SVG_OVERFLOW_HIDDEN = 1,
        D2D1_SVG_OVERFLOW_FORCE_DWORD = $ffffffff
        );

    PD2D1_SVG_OVERFLOW = ^TD2D1_SVG_OVERFLOW;


    // Specifies a value for the SVG stroke-linecap property.
    TD2D1_SVG_LINE_CAP = (
        D2D1_SVG_LINE_CAP_BUTT = Ord(D2D1_CAP_STYLE_FLAT),
        D2D1_SVG_LINE_CAP_SQUARE = Ord(D2D1_CAP_STYLE_SQUARE),
        D2D1_SVG_LINE_CAP_ROUND = Ord(D2D1_CAP_STYLE_ROUND),
        D2D1_SVG_LINE_CAP_FORCE_DWORD = $ffffffff
        );

    PD2D1_SVG_LINE_CAP = ^TD2D1_SVG_LINE_CAP;


    // Specifies a value for the SVG stroke-linejoin property.
    TD2D1_SVG_LINE_JOIN = (
        D2D1_SVG_LINE_JOIN_BEVEL = Ord(D2D1_LINE_JOIN_BEVEL),
        D2D1_SVG_LINE_JOIN_MITER = Ord(D2D1_LINE_JOIN_MITER_OR_BEVEL),
        D2D1_SVG_LINE_JOIN_ROUND = Ord(D2D1_LINE_JOIN_ROUND),
        D2D1_SVG_LINE_JOIN_FORCE_DWORD = $ffffffff
        );

    PD2D1_SVG_LINE_JOIN = ^TD2D1_SVG_LINE_JOIN;


    // The alignment portion of the SVG preserveAspectRatio attribute.
    TD2D1_SVG_ASPECT_ALIGN = (
        D2D1_SVG_ASPECT_ALIGN_NONE = 0,
        D2D1_SVG_ASPECT_ALIGN_X_MIN_Y_MIN = 1,
        D2D1_SVG_ASPECT_ALIGN_X_MID_Y_MIN = 2,
        D2D1_SVG_ASPECT_ALIGN_X_MAX_Y_MIN = 3,
        D2D1_SVG_ASPECT_ALIGN_X_MIN_Y_MID = 4,
        D2D1_SVG_ASPECT_ALIGN_X_MID_Y_MID = 5,
        D2D1_SVG_ASPECT_ALIGN_X_MAX_Y_MID = 6,
        D2D1_SVG_ASPECT_ALIGN_X_MIN_Y_MAX = 7,
        D2D1_SVG_ASPECT_ALIGN_X_MID_Y_MAX = 8,
        D2D1_SVG_ASPECT_ALIGN_X_MAX_Y_MAX = 9,
        D2D1_SVG_ASPECT_ALIGN_FORCE_DWORD = $ffffffff
        );

    PD2D1_SVG_ASPECT_ALIGN = ^TD2D1_SVG_ASPECT_ALIGN;


    TD2D1_SVG_ASPECT_SCALING = (
        D2D1_SVG_ASPECT_SCALING_MEET = 0,
        D2D1_SVG_ASPECT_SCALING_SLICE = 1,
        D2D1_SVG_ASPECT_SCALING_FORCE_DWORD = $ffffffff
        );
    PD2D1_SVG_ASPECT_SCALING = ^TD2D1_SVG_ASPECT_SCALING;


    TD2D1_SVG_PATH_COMMAND = (
        D2D1_SVG_PATH_COMMAND_CLOSE_PATH = 0,
        D2D1_SVG_PATH_COMMAND_MOVE_ABSOLUTE = 1,
        D2D1_SVG_PATH_COMMAND_MOVE_RELATIVE = 2,
        D2D1_SVG_PATH_COMMAND_LINE_ABSOLUTE = 3,
        D2D1_SVG_PATH_COMMAND_LINE_RELATIVE = 4,
        D2D1_SVG_PATH_COMMAND_CUBIC_ABSOLUTE = 5,
        D2D1_SVG_PATH_COMMAND_CUBIC_RELATIVE = 6,
        D2D1_SVG_PATH_COMMAND_QUADRADIC_ABSOLUTE = 7,
        D2D1_SVG_PATH_COMMAND_QUADRADIC_RELATIVE = 8,
        D2D1_SVG_PATH_COMMAND_ARC_ABSOLUTE = 9,
        D2D1_SVG_PATH_COMMAND_ARC_RELATIVE = 10,
        D2D1_SVG_PATH_COMMAND_HORIZONTAL_ABSOLUTE = 11,
        D2D1_SVG_PATH_COMMAND_HORIZONTAL_RELATIVE = 12,
        D2D1_SVG_PATH_COMMAND_VERTICAL_ABSOLUTE = 13,
        D2D1_SVG_PATH_COMMAND_VERTICAL_RELATIVE = 14,
        D2D1_SVG_PATH_COMMAND_CUBIC_SMOOTH_ABSOLUTE = 15,
        D2D1_SVG_PATH_COMMAND_CUBIC_SMOOTH_RELATIVE = 16,
        D2D1_SVG_PATH_COMMAND_QUADRADIC_SMOOTH_ABSOLUTE = 17,
        D2D1_SVG_PATH_COMMAND_QUADRADIC_SMOOTH_RELATIVE = 18,
        D2D1_SVG_PATH_COMMAND_FORCE_DWORD = $ffffffff
        );

    PD2D1_SVG_PATH_COMMAND = ^TD2D1_SVG_PATH_COMMAND;


    TD2D1_SVG_UNIT_TYPE = (
        D2D1_SVG_UNIT_TYPE_USER_SPACE_ON_USE = 0,
        D2D1_SVG_UNIT_TYPE_OBJECT_BOUNDING_BOX = 1,
        D2D1_SVG_UNIT_TYPE_FORCE_DWORD = $ffffffff
        );

    PD2D1_SVG_UNIT_TYPE = ^TD2D1_SVG_UNIT_TYPE;


    TD2D1_SVG_ATTRIBUTE_STRING_TYPE = (
        D2D1_SVG_ATTRIBUTE_STRING_TYPE_SVG = 0,
        D2D1_SVG_ATTRIBUTE_STRING_TYPE_ID = 1,
        D2D1_SVG_ATTRIBUTE_STRING_TYPE_FORCE_DWORD = $ffffffff
        );

    PD2D1_SVG_ATTRIBUTE_STRING_TYPE = ^TD2D1_SVG_ATTRIBUTE_STRING_TYPE;


    TD2D1_SVG_ATTRIBUTE_POD_TYPE = (
        D2D1_SVG_ATTRIBUTE_POD_TYPE_FLOAT = 0,
        D2D1_SVG_ATTRIBUTE_POD_TYPE_COLOR = 1,
        D2D1_SVG_ATTRIBUTE_POD_TYPE_FILL_MODE = 2,
        D2D1_SVG_ATTRIBUTE_POD_TYPE_DISPLAY = 3,
        D2D1_SVG_ATTRIBUTE_POD_TYPE_OVERFLOW = 4,
        D2D1_SVG_ATTRIBUTE_POD_TYPE_LINE_CAP = 5,
        D2D1_SVG_ATTRIBUTE_POD_TYPE_LINE_JOIN = 6,
        D2D1_SVG_ATTRIBUTE_POD_TYPE_VISIBILITY = 7,
        D2D1_SVG_ATTRIBUTE_POD_TYPE_MATRIX = 8,
        D2D1_SVG_ATTRIBUTE_POD_TYPE_UNIT_TYPE = 9,
        D2D1_SVG_ATTRIBUTE_POD_TYPE_EXTEND_MODE = 10,
        D2D1_SVG_ATTRIBUTE_POD_TYPE_PRESERVE_ASPECT_RATIO = 11,
        D2D1_SVG_ATTRIBUTE_POD_TYPE_VIEWBOX = 12,
        D2D1_SVG_ATTRIBUTE_POD_TYPE_LENGTH = 13,
        D2D1_SVG_ATTRIBUTE_POD_TYPE_FORCE_DWORD = $ffffffff
        );

    PD2D1_SVG_ATTRIBUTE_POD_TYPE = ^TD2D1_SVG_ATTRIBUTE_POD_TYPE;


    TD2D1_SVG_LENGTH = record
        Value: single;
        units: TD2D1_SVG_LENGTH_UNITS;
    end;

    PD2D1_SVG_LENGTH = ^TD2D1_SVG_LENGTH;


    TD2D1_SVG_PRESERVE_ASPECT_RATIO = record
        defer: boolean;
        align: TD2D1_SVG_ASPECT_ALIGN;
        meetOrSlice: TD2D1_SVG_ASPECT_SCALING;
    end;

    PD2D1_SVG_PRESERVE_ASPECT_RATIO = ^TD2D1_SVG_PRESERVE_ASPECT_RATIO;

    // Represents an SVG viewBox.
    TD2D1_SVG_VIEWBOX = record
        x: single;
        y: single;
        Width: single;
        Height: single;
    end;
    PD2D1_SVG_VIEWBOX = ^TD2D1_SVG_VIEWBOX;


    ID2D1SvgElement = interface;
    ID2D1SvgDocument = interface;


    //{$IFDEF NTDDI_VERSION >= NTDDI_WIN10_RS2}

    ID2D1SvgAttribute = interface(ID2D1Resource)
        ['{c9cdb0dd-f8c9-4e70-b7c2-301c80292c5e}']
        procedure GetElement(out element: ID2D1SvgElement); stdcall;
        function Clone(out attribute: ID2D1SvgAttribute): HResult; stdcall;
    end;



    ID2D1SvgPaint = interface(ID2D1SvgAttribute)
        ['{d59bab0a-68a2-455b-a5dc-9eb2854e2490}']
        function SetPaintType(paintType: TD2D1_SVG_PAINT_TYPE): HResult; stdcall;
        function GetPaintType(): TD2D1_SVG_PAINT_TYPE; stdcall;
        function SetColor(const color: PD2D1_COLOR_F): HResult; stdcall;
        procedure GetColor(out color: TD2D1_COLOR_F); stdcall;
        function SetId(id: pwidechar): HResult; stdcall;
        function GetId(out id: pwidechar; idCount: uint32): HResult; stdcall;
        function GetIdLength(): uint32; stdcall;
    end;

    {$IFDEF FPC}
    { ID2D1SvgPaintHelper }
    ID2D1SvgPaintHelper = type helper for ID2D1SvgPaint
        function SetColor(const color: TD2D1_COLOR_F): HResult; stdcall; overload;
    end;
    {$ENDIF}


    ID2D1SvgStrokeDashArray = interface(ID2D1SvgAttribute)
        ['{f1c0ca52-92a3-4f00-b4ce-f35691efd9d9}']
        function RemoveDashesAtEnd(dashesCount: uint32): HResult; stdcall;
        function UpdateDashes(dashes: PSingle; dashesCount: uint32; startIndex: uint32 = 0): HResult; stdcall; overload;
        function UpdateDashes(dashes: PD2D1_SVG_LENGTH; dashesCount: uint32; startIndex: uint32 = 0): HResult;
            stdcall; overload;
        function GetDashes(out dashes: PSingle; dashesCount: uint32; startIndex: uint32 = 0): HResult; stdcall; overload;
        function GetDashes(out dashes: PD2D1_SVG_LENGTH; dashesCount: uint32; startIndex: uint32 = 0): HResult;
            stdcall; overload;
        function GetDashesCount(): uint32; stdcall;
    end;


    // Interface describing an SVG 'points' value in a 'polyline' or 'polygon' element.
    ID2D1SvgPointCollection = interface(ID2D1SvgAttribute)
        ['{9dbe4c0d-3572-4dd9-9825-5530813bb712}']
        function RemovePointsAtEnd(pointsCount: uint32): HResult; stdcall;
        function UpdatePoints(points: PD2D1_POINT_2F; pointsCount: uint32; startIndex: uint32 = 0): HResult; stdcall;
        function GetPoints(points: PD2D1_POINT_2F; pointsCount: uint32; startIndex: uint32 = 0): HResult; stdcall;
        function GetPointsCount(): uint32; stdcall;
    end;



    ID2D1SvgPathData = interface(ID2D1SvgAttribute)
        ['{c095e4f4-bb98-43d6-9745-4d1b84ec9888}']
        function RemoveSegmentDataAtEnd(dataCount: uint32): HResult; stdcall;
        function UpdateSegmentData(Data: PSingle; dataCount: uint32; startIndex: uint32 = 0): HResult; stdcall;
        function GetSegmentData(out Data: PSingle; dataCount: uint32; startIndex: uint32 = 0): HResult; stdcall;
        function GetSegmentDataCount(): uint32; stdcall;
        function RemoveCommandsAtEnd(commandsCount: uint32): HResult; stdcall;
        function UpdateCommands(commands: PD2D1_SVG_PATH_COMMAND; commandsCount: uint32; startIndex: uint32 = 0): HResult; stdcall;
        function GetCommands(out commands: PD2D1_SVG_PATH_COMMAND; commandsCount: uint32; startIndex: uint32 = 0): HResult; stdcall;
        function GetCommandsCount(): uint32; stdcall;
        function CreatePathGeometry(fillMode: TD2D1_FILL_MODE; out pathGeometry: ID2D1PathGeometry1): HResult; stdcall;
    end;


    // Interface for all SVG elements.
    ID2D1SvgElement = interface(ID2D1Resource)
        ['{ac7b67a6-183e-49c1-a823-0ebe40b0db29}']
        procedure GetDocument(out document: ID2D1SvgDocument); stdcall;
        function GetTagName(out Name: pwidechar; nameCount: uint32): HResult; stdcall;
        function GetTagNameLength(): uint32; stdcall;
        function IsTextContent(): boolean; stdcall;
        procedure GetParent(out parent: ID2D1SvgElement); stdcall;
        function HasChildren(): boolean; stdcall;
        procedure GetFirstChild(out child: ID2D1SvgElement); stdcall;
        procedure GetLastChild(out child: ID2D1SvgElement); stdcall;
        function GetPreviousChild(referenceChild: ID2D1SvgElement; out previousChild: ID2D1SvgElement): HResult; stdcall;
        function GetNextChild(referenceChild: ID2D1SvgElement; out nextChild: ID2D1SvgElement): HResult; stdcall;
        function InsertChildBefore(newChild: ID2D1SvgElement; referenceChild: ID2D1SvgElement = nil): HResult; stdcall;
        function AppendChild(newChild: ID2D1SvgElement): HResult; stdcall;
        function ReplaceChild(newChild: ID2D1SvgElement; oldChild: ID2D1SvgElement): HResult; stdcall;
        function RemoveChild(oldChild: ID2D1SvgElement): HResult; stdcall;
        function CreateChild(tagName: pwidechar; out newChild: ID2D1SvgElement): HResult; stdcall;
        function IsAttributeSpecified(Name: pwidechar; out AInherited: boolean): boolean; stdcall;
        function GetSpecifiedAttributeCount(): uint32; stdcall;
        function GetSpecifiedAttributeName(index: uint32; out Name: pwidechar; nameCount: uint32;
            out Ainherited: boolean): HResult; stdcall;
        function GetSpecifiedAttributeNameLength(index: uint32; out nameLength: uint32; out Ainherited: boolean): HResult; stdcall;
        function RemoveAttribute(Name: pwidechar): HResult; stdcall;
        function SetTextValue(Name: pwidechar; nameCount: uint32): HResult; stdcall;
        function GetTextValue(out Name: pwidechar; nameCount: uint32): HResult; stdcall;
        function GetTextValueLength(): uint32; stdcall;
        function SetAttributeValue(Name: pwidechar; AType: TD2D1_SVG_ATTRIBUTE_STRING_TYPE; Value: pwidechar): HResult;
            stdcall; overload;
        function GetAttributeValue(Name: pwidechar; AType: TD2D1_SVG_ATTRIBUTE_STRING_TYPE; out Value: pwidechar;
            valueCount: uint32): HResult; stdcall; overload;
        function GetAttributeValueLength(Name: pwidechar; AType: TD2D1_SVG_ATTRIBUTE_STRING_TYPE;
            out valueLength: uint32): HResult; stdcall;
        function SetAttributeValue(Name: pwidechar; AType: TD2D1_SVG_ATTRIBUTE_POD_TYPE; Value: pbyte; valueSizeInBytes: uint32): HResult;
            stdcall; overload;
        function GetAttributeValue(Name: pwidechar; AType: TD2D1_SVG_ATTRIBUTE_POD_TYPE; out Value: pbyte;
            valueSizeInBytes: uint32): HResult; stdcall; overload;
        function SetAttributeValue(Name: pwidechar; Value: ID2D1SvgAttribute): HResult; stdcall; overload;
        function GetAttributeValue(Name: pwidechar; const riid: TGUID; out Value): HResult; stdcall; overload;
    end;

    {$IFDEF FPC}
    { ID2D1SvgElementHelper }
    ID2D1SvgElementHelper = type helper for ID2D1SvgElement
        function SetAttributeValue(Name: PCWSTR; Value: single): HResult; stdcall; overload;
        function GetAttributeValue(Name: PCWSTR; out Value: single): HResult; stdcall; overload;
        function SetAttributeValue(Name: PCWSTR; const Value: TD2D1_COLOR_F): HResult; stdcall; overload;
        function GetAttributeValue(Name: PCWSTR; out Value: TD2D1_COLOR_F): HResult; stdcall; overload;
        function SetAttributeValue(Name: PCWSTR; Value: TD2D1_FILL_MODE): HResult; stdcall; overload;
        function GetAttributeValue(Name: PCWSTR; out Value: TD2D1_FILL_MODE): HResult; stdcall; overload;
        function SetAttributeValue(Name: PCWSTR; Value: TD2D1_SVG_DISPLAY): HResult; stdcall; overload;
        function GetAttributeValue(Name: PCWSTR; out Value: TD2D1_SVG_DISPLAY): HResult; stdcall; overload;
        function SetAttributeValue(Name: PCWSTR; Value: TD2D1_SVG_OVERFLOW): HResult; stdcall; overload;
        function GetAttributeValue(Name: PCWSTR; out Value: TD2D1_SVG_OVERFLOW): HResult; stdcall; overload;
        function SetAttributeValue(Name: PCWSTR; Value: TD2D1_SVG_LINE_JOIN): HResult; stdcall; overload;
        function GetAttributeValue(Name: PCWSTR; out Value: TD2D1_SVG_LINE_JOIN): HResult; stdcall; overload;
        function SetAttributeValue(Name: PCWSTR; Value: TD2D1_SVG_LINE_CAP): HResult; stdcall; overload;
        function GetAttributeValue(Name: PCWSTR; out Value: TD2D1_SVG_LINE_CAP): HResult; stdcall; overload;
        function SetAttributeValue(Name: PCWSTR; Value: TD2D1_SVG_VISIBILITY): HResult; stdcall; overload;
        function GetAttributeValue(Name: PCWSTR; out Value: TD2D1_SVG_VISIBILITY): HResult; stdcall; overload;
        function SetAttributeValue(Name: PCWSTR; const Value: TD2D1_MATRIX_3X2_F): HResult; stdcall; overload;
        function GetAttributeValue(Name: PCWSTR; out Value: TD2D1_MATRIX_3X2_F): HResult; stdcall; overload;
        function SetAttributeValue(Name: PCWSTR; Value: TD2D1_SVG_UNIT_TYPE): HResult; stdcall; overload;
        function GetAttributeValue(Name: PCWSTR; out Value: TD2D1_SVG_UNIT_TYPE): HResult; stdcall; overload;
        function SetAttributeValue(Name: PCWSTR; Value: TD2D1_EXTEND_MODE): HResult; stdcall; overload;
        function GetAttributeValue(Name: PCWSTR; out Value: TD2D1_EXTEND_MODE): HResult; stdcall; overload;
        function SetAttributeValue(Name: PCWSTR; const Value: TD2D1_SVG_PRESERVE_ASPECT_RATIO): HResult;
            stdcall; overload;
        function GetAttributeValue(Name: PCWSTR; out Value: TD2D1_SVG_PRESERVE_ASPECT_RATIO): HResult; stdcall; overload;
        function SetAttributeValue(Name: PCWSTR; const Value: TD2D1_SVG_LENGTH): HResult;
            stdcall; overload;
        function GetAttributeValue(Name: PCWSTR; out Value: TD2D1_SVG_LENGTH): HResult;
            stdcall; overload;
        function GetAttributeValue(Name: PCWSTR; out Value: ID2D1SvgAttribute): HResult;
            stdcall; overload;
        function GetAttributeValue(Name: PCWSTR; out Value: ID2D1SvgPaint): HResult;
            stdcall; overload;
        function GetAttributeValue(Name: PCWSTR; out Value: ID2D1SvgStrokeDashArray): HResult;
            stdcall; overload;
        function GetAttributeValue(Name: PCWSTR; out Value: ID2D1SvgPointCollection): HResult;
            stdcall; overload;
        function GetAttributeValue(Name: PCWSTR; out Value: ID2D1SvgPathData): HResult;
            stdcall; overload;
    end;
    {$ENDIF}


    ID2D1SvgDocument = interface(ID2D1Resource)
        ['{86b88e4d-afa4-4d7b-88e4-68a51c4a0aec}']
        function SetViewportSize(viewportSize: TD2D1_SIZE_F): HResult; stdcall;
        function GetViewportSize(): TD2D1_SIZE_F; stdcall;
        function SetRoot(root: ID2D1SvgElement): HResult; stdcall;
        procedure GetRoot(out root: ID2D1SvgElement); stdcall;
        function FindElementById(id: pwidechar; out svgElement: ID2D1SvgElement): HResult; stdcall;
        function Serialize(outputXmlStream: IStream; subtree: ID2D1SvgElement = nil): HResult; stdcall;
        function Deserialize(inputXmlStream: IStream; out subtree: ID2D1SvgElement): HResult; stdcall;
        function CreatePaint(paintType: TD2D1_SVG_PAINT_TYPE; const color: PD2D1_COLOR_F; id: pwidechar;
            out paint: ID2D1SvgPaint): HResult; stdcall;
        function CreateStrokeDashArray(dashes: PD2D1_SVG_LENGTH; dashesCount: uint32;
            out strokeDashArray: ID2D1SvgStrokeDashArray): HResult; stdcall;
        function CreatePointCollection(points: PD2D1_POINT_2F; pointsCount: uint32;
            out pointCollection: ID2D1SvgPointCollection): HResult; stdcall;
        function CreatePathData(segmentData: PSingle; segmentDataCount: uint32; commands: PD2D1_SVG_PATH_COMMAND;
            commandsCount: uint32; out pathData: ID2D1SvgPathData): HResult; stdcall;

    end;

    {$IFDEF FPC}
    { ID2D1SvgDocumentHelper }
    ID2D1SvgDocumentHelper = type helper for ID2D1SvgDocument
        function CreatePaint(paintType: TD2D1_SVG_PAINT_TYPE; color: TD2D1_COLOR_F; id: PCWSTR;
            out paint: ID2D1SvgPaint): HResult; stdcall; overload;
    end;
    {$ENDIF}


implementation

{ ID2D1SvgDocumentHelper }

function ID2D1SvgDocumentHelper.CreatePaint(paintType: TD2D1_SVG_PAINT_TYPE; color: TD2D1_COLOR_F; id: PCWSTR;
    out paint: ID2D1SvgPaint): HResult; stdcall;
begin
    Result := CreatePaint(paintType, @color, id, paint);
end;

{ ID2D1SvgElementHelper }

function ID2D1SvgElementHelper.SetAttributeValue(Name: PCWSTR; Value: single): HResult; stdcall;
begin
    Result := SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_FLOAT, @Value, sizeof(Value));
end;



function ID2D1SvgElementHelper.GetAttributeValue(Name: PCWSTR; out Value: single): HResult; stdcall;
begin
    Result := GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_FLOAT, pbyte(Value), sizeof(Value));
end;



function ID2D1SvgElementHelper.SetAttributeValue(Name: PCWSTR; const Value: TD2D1_COLOR_F): HResult; stdcall;
begin
    Result := SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_COLOR, @Value, sizeof(Value));
end;



function ID2D1SvgElementHelper.GetAttributeValue(Name: PCWSTR; out Value: TD2D1_COLOR_F): HResult; stdcall;
var
    v: pbyte absolute Value;
begin
    Result := GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_COLOR, v, sizeof(Value));
end;



function ID2D1SvgElementHelper.SetAttributeValue(Name: PCWSTR; Value: TD2D1_FILL_MODE): HResult; stdcall;
begin
    Result := SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_FILL_MODE, @Value, sizeof(Value));
end;



function ID2D1SvgElementHelper.GetAttributeValue(Name: PCWSTR; out Value: TD2D1_FILL_MODE): HResult; stdcall;
var
    v: pbyte absolute Value;
begin
    Result := GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_FILL_MODE, v, sizeof(Value));
end;



function ID2D1SvgElementHelper.SetAttributeValue(Name: PCWSTR; Value: TD2D1_SVG_DISPLAY): HResult; stdcall;
begin
    Result := SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_DISPLAY, @Value, sizeof(Value));
end;



function ID2D1SvgElementHelper.GetAttributeValue(Name: PCWSTR; out Value: TD2D1_SVG_DISPLAY): HResult; stdcall;
var
    v: pbyte absolute Value;
begin
    Result := GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_DISPLAY, v, sizeof(Value));
end;



function ID2D1SvgElementHelper.SetAttributeValue(Name: PCWSTR; Value: TD2D1_SVG_OVERFLOW): HResult; stdcall;
begin
    Result := SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_OVERFLOW, @Value, sizeof(Value));
end;



function ID2D1SvgElementHelper.GetAttributeValue(Name: PCWSTR; out Value: TD2D1_SVG_OVERFLOW): HResult; stdcall;
var
    v: pbyte absolute Value;
begin
    Result := GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_OVERFLOW, v, sizeof(Value));
end;



function ID2D1SvgElementHelper.SetAttributeValue(Name: PCWSTR; Value: TD2D1_SVG_LINE_JOIN): HResult; stdcall;
begin
    Result := SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_LINE_JOIN, @Value, sizeof(Value));
end;



function ID2D1SvgElementHelper.GetAttributeValue(Name: PCWSTR; out Value: TD2D1_SVG_LINE_JOIN): HResult; stdcall;
var
    v: pbyte absolute Value;
begin
    Result := GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_LINE_JOIN, v, sizeof(Value));
end;



function ID2D1SvgElementHelper.SetAttributeValue(Name: PCWSTR; Value: TD2D1_SVG_LINE_CAP): HResult; stdcall;
begin
    Result := SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_LINE_CAP, @Value, sizeof(Value));
end;



function ID2D1SvgElementHelper.GetAttributeValue(Name: PCWSTR; out Value: TD2D1_SVG_LINE_CAP): HResult; stdcall;
var
    v: pbyte absolute Value;
begin
    Result := GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_LINE_CAP, v, sizeof(Value));
end;



function ID2D1SvgElementHelper.SetAttributeValue(Name: PCWSTR; Value: TD2D1_SVG_VISIBILITY): HResult; stdcall;
begin
    Result := SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_VISIBILITY, @Value, sizeof(Value));
end;



function ID2D1SvgElementHelper.GetAttributeValue(Name: PCWSTR; out Value: TD2D1_SVG_VISIBILITY): HResult; stdcall;
var
    v: pbyte absolute Value;
begin
    Result := GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_VISIBILITY, v, sizeof(Value));
end;



function ID2D1SvgElementHelper.SetAttributeValue(Name: PCWSTR; const Value: TD2D1_MATRIX_3X2_F): HResult; stdcall;
begin
    Result := SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_MATRIX, @Value, sizeof(Value));
end;



function ID2D1SvgElementHelper.GetAttributeValue(Name: PCWSTR; out Value: TD2D1_MATRIX_3X2_F): HResult; stdcall;
var
    v: pbyte absolute Value;
begin
    Result := GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_MATRIX, v, sizeof(Value));
end;



function ID2D1SvgElementHelper.SetAttributeValue(Name: PCWSTR; Value: TD2D1_SVG_UNIT_TYPE): HResult; stdcall;
begin
    Result := SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_UNIT_TYPE, @Value, sizeof(Value));
end;



function ID2D1SvgElementHelper.GetAttributeValue(Name: PCWSTR; out Value: TD2D1_SVG_UNIT_TYPE): HResult; stdcall;
var
    v: pbyte absolute Value;
begin
    Result := GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_UNIT_TYPE, v, sizeof(Value));
end;



function ID2D1SvgElementHelper.SetAttributeValue(Name: PCWSTR; Value: TD2D1_EXTEND_MODE): HResult; stdcall;
begin
    Result := SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_EXTEND_MODE, @Value, sizeof(Value));
end;



function ID2D1SvgElementHelper.GetAttributeValue(Name: PCWSTR; out Value: TD2D1_EXTEND_MODE): HResult; stdcall;
var
    v: pbyte absolute Value;
begin
    Result := GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_EXTEND_MODE, v, sizeof(Value));
end;



function ID2D1SvgElementHelper.SetAttributeValue(Name: PCWSTR; const Value: TD2D1_SVG_PRESERVE_ASPECT_RATIO): HResult; stdcall;
begin
    Result := SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_PRESERVE_ASPECT_RATIO, @Value, sizeof(Value));
end;



function ID2D1SvgElementHelper.GetAttributeValue(Name: PCWSTR; out Value: TD2D1_SVG_PRESERVE_ASPECT_RATIO): HResult; stdcall;
var
    v: pbyte absolute Value;
begin
    Result := GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_PRESERVE_ASPECT_RATIO, v, sizeof(Value));
end;



function ID2D1SvgElementHelper.SetAttributeValue(Name: PCWSTR; const Value: TD2D1_SVG_LENGTH): HResult; stdcall;
begin
    Result := SetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_LENGTH, @Value, sizeof(Value));
end;



function ID2D1SvgElementHelper.GetAttributeValue(Name: PCWSTR; out Value: TD2D1_SVG_LENGTH): HResult; stdcall;
var
    v: pbyte absolute Value;
begin
    Result := GetAttributeValue(Name, D2D1_SVG_ATTRIBUTE_POD_TYPE_LENGTH, v, sizeof(Value));
end;



function ID2D1SvgElementHelper.GetAttributeValue(Name: PCWSTR; out Value: ID2D1SvgAttribute): HResult; stdcall;
begin
    Result := GetAttributeValue(Name, IID_ID2D1SvgAttribute, Value);
end;



function ID2D1SvgElementHelper.GetAttributeValue(Name: PCWSTR; out Value: ID2D1SvgPaint): HResult; stdcall;
begin
    Result := GetAttributeValue(Name, IID_ID2D1SvgPaint, Value);
end;



function ID2D1SvgElementHelper.GetAttributeValue(Name: PCWSTR; out Value: ID2D1SvgStrokeDashArray): HResult; stdcall;
begin
    Result := GetAttributeValue(Name, IID_ID2D1SvgStrokeDashArray, Value);
end;



function ID2D1SvgElementHelper.GetAttributeValue(Name: PCWSTR; out Value: ID2D1SvgPointCollection): HResult; stdcall;
begin
    Result := GetAttributeValue(Name, IID_ID2D1SvgPointCollection, Value);
end;



function ID2D1SvgElementHelper.GetAttributeValue(Name: PCWSTR; out Value: ID2D1SvgPathData): HResult; stdcall;
begin
    Result := GetAttributeValue(Name, IID_ID2D1SvgPathData, Value);
end;


{ ID2D1SvgPaintHelper }

function ID2D1SvgPaintHelper.SetColor(const color: TD2D1_COLOR_F): HResult;
    stdcall;
begin
    Result := SetColor(@color);
end;

end.
