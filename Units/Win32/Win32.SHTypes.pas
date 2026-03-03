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
   File name: shtypes.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit Win32.SHTypes;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    Win32.WTypesBase,
    Win32.WTypes;


    {$DEFINE NTDDI_VISTA}
const
    PERCEIVEDFLAG_UNDEFINED = $0000;
    PERCEIVEDFLAG_SOFTCODED = $0001;
    PERCEIVEDFLAG_HARDCODED = $0002;
    PERCEIVEDFLAG_NATIVESUPPORT = $0004;
    PERCEIVEDFLAG_GDIPLUS = $0010;
    PERCEIVEDFLAG_WMSDK = $0020;
    PERCEIVEDFLAG_ZIPFOLDER = $0040;

type

    //===========================================================================
    // Object identifiers in the explorer's name space (ItemID and IDList)
    //  All the items that the user can browse with the explorer (such as files,
    // directories, servers, work-groups, etc.) has an identifier which is unique
    // among items within the parent folder. Those identifiers are called item
    // IDs (SHITEMID). Since all its parent folders have their own item IDs,
    // any items can be uniquely identified by a list of item IDs, which is called
    // an ID list (ITEMIDLIST).

    //  ID lists are almost always allocated by the task allocator (see some
    // description below as well as OLE 2.0 SDK) and may be passed across
    // some of shell interfaces (such as IShellFolder). Each item ID in an ID list
    // is only meaningful to its parent folder (which has generated it), and all
    // the clients must treat it as an opaque binary data except the first two
    // bytes, which indicates the size of the item ID.

    //  When a shell extension -- which implements the IShellFolder interace --
    // generates an item ID, it may put any information in it, not only the data
    // with that it needs to identifies the item, but also some additional
    // information, which would help implementing some other functions efficiently.
    // For example, the shell's IShellFolder implementation of file system items
    // stores the primary (long) name of a file or a directory as the item
    // identifier, but it also stores its alternative (short) name, size and date
    // etc.

    //  When an ID list is passed to one of shell APIs (such as SHGetPathFromIDList),
    // it is always an absolute path -- relative from the root of the name space,
    // which is the desktop folder. When an ID list is passed to one of IShellFolder
    // member function, it is always a relative path from the folder (unless it
    // is explicitly specified).
    //===========================================================================
    // SHITEMID -- Item ID  (mkid)
    //     USHORT      cb;             // Size of the ID (including cb itself)
    //     BYTE        abID[];         // The item ID (variable length)

    {$PACKRECORDS 1}
    _SHITEMID = record
        cb: USHORT;
        abID: pbyte;
    end;
    TSHITEMID = _SHITEMID;
    PSHITEMID = ^TSHITEMID;

    LPSHITEMID = ^TSHITEMID;
    LPCSHITEMID = ^TSHITEMID;


    {$PACKRECORDS DEFAULT}


    // ITEMIDLIST -- List if item IDs (combined with 0-terminator)


    {$PACKRECORDS 1}

    _ITEMIDLIST = record
        mkid: TSHITEMID;
    end;
    TITEMIDLIST = _ITEMIDLIST;
    PITEMIDLIST = ^TITEMIDLIST;

    TITEMIDLIST_RELATIVE = TITEMIDLIST;
    TITEMID_CHILD = TITEMIDLIST;
    TITEMIDLIST_ABSOLUTE = TITEMIDLIST;

    {$PACKRECORDS DEFAULT}

    wirePIDL = ^TBYTE_BLOB;
    LPITEMIDLIST = ^TITEMIDLIST;
    LPCITEMIDLIST = ^TITEMIDLIST;

    PIDLIST_ABSOLUTE = ^TITEMIDLIST_ABSOLUTE;

    PCIDLIST_ABSOLUTE = ^TITEMIDLIST_ABSOLUTE;

    PCUIDLIST_ABSOLUTE = ^TITEMIDLIST_ABSOLUTE;

    PIDLIST_RELATIVE = ^TITEMIDLIST_RELATIVE;

    PCIDLIST_RELATIVE = ^TITEMIDLIST_RELATIVE;

    PUIDLIST_RELATIVE = ^TITEMIDLIST_RELATIVE;

    PCUIDLIST_RELATIVE = ^TITEMIDLIST_RELATIVE;

    PITEMID_CHILD = ^TITEMID_CHILD;

    PCITEMID_CHILD = ^TITEMID_CHILD;

    PUITEMID_CHILD = ^TITEMID_CHILD;

    PCUITEMID_CHILD = ^TITEMID_CHILD;

    PCUITEMID_CHILD_ARRAY = ^PCUITEMID_CHILD;

    PCUIDLIST_RELATIVE_ARRAY = ^PCUIDLIST_RELATIVE;

    PCIDLIST_ABSOLUTE_ARRAY = ^PCIDLIST_ABSOLUTE;

    PCUIDLIST_ABSOLUTE_ARRAY = ^PCUIDLIST_ABSOLUTE;



    _WIN32_FIND_DATAA = record
        dwFileAttributes: DWORD;
        ftCreationTime: TFILETIME;
        ftLastAccessTime: TFILETIME;
        ftLastWriteTime: TFILETIME;
        nFileSizeHigh: DWORD;
        nFileSizeLow: DWORD;
        dwReserved0: DWORD;
        dwReserved1: DWORD;
        cFileName: array [0..260 - 1] of ansichar;
        cAlternateFileName: array [0..14 - 1] of ansichar;
    end;
    TWIN32_FIND_DATAA = _WIN32_FIND_DATAA;
    PWIN32_FIND_DATAA = ^TWIN32_FIND_DATAA;
    LPWIN32_FIND_DATAA = ^TWIN32_FIND_DATAA;



    _WIN32_FIND_DATAW = record
        dwFileAttributes: DWORD;
        ftCreationTime: TFILETIME;
        ftLastAccessTime: TFILETIME;
        ftLastWriteTime: TFILETIME;
        nFileSizeHigh: DWORD;
        nFileSizeLow: DWORD;
        dwReserved0: DWORD;
        dwReserved1: DWORD;
        cFileName: array [0..260 - 1] of WCHAR;
        cAlternateFileName: array [0..14 - 1] of WCHAR;
    end;
    TWIN32_FIND_DATAW = _WIN32_FIND_DATAW;
    PWIN32_FIND_DATAW = ^TWIN32_FIND_DATAW;
    LPWIN32_FIND_DATAW = ^TWIN32_FIND_DATAW;

    //-------------------------------------------------------------------------

    // struct STRRET

    // structure for returning strings from IShellFolder member functions

    //-------------------------------------------------------------------------

    //  uType indicate which union member to use
    //    STRRET_WSTR    Use STRRET.pOleStr     must be freed by caller of GetDisplayNameOf
    //    STRRET_OFFSET  Use STRRET.uOffset     Offset into SHITEMID for ANSI string
    //    STRRET_CSTR    Use STRRET.cStr        ANSI Buffer

    tagSTRRET_TYPE = (
        STRRET_WSTR = 0,
        STRRET_OFFSET = $1,
        STRRET_CSTR = $2);

    TSTRRET_TYPE = tagSTRRET_TYPE;
    PSTRRET_TYPE = ^TSTRRET_TYPE;

    {$PACKRECORDS 8}
    TSTRRET = record
        uType: UINT; (* [switch_is][switch_type] *)
        case integer of
            (* [case()][string] *)
            0: (
                pOleStr: LPWSTR;
            );
            (* [case()] *)
            1: (
                uOffset: UINT;
            );
            (* [case()] *)
            2: (
                cStr: array [0..260 - 1] of char;
            );
    end;
    PSTRRET = ^TSTRRET;


    {$PACKRECORDS DEFAULT}

    PLPSTRRET = ^TSTRRET;



    //-------------------------------------------------------------------------

    // struct SHELLDETAILS

    // structure for returning strings from IShellDetails

    //-------------------------------------------------------------------------

    //  fmt;            // LVCFMT_* value (header only)
    //  cxChar;         // Number of 'average' characters (header only)
    //  str;            // String information

    {$PACKRECORDS 1}
    _SHELLDETAILS = record
        fmt: int32;
        cxChar: int32;
        str: TSTRRET;
    end;
    TSHELLDETAILS = _SHELLDETAILS;
    PSHELLDETAILS = ^TSHELLDETAILS;
    LPSHELLDETAILS = ^TSHELLDETAILS;


    {$PACKRECORDS DEFAULT}


    tagPERCEIVED = (
        PERCEIVED_TYPE_FIRST = -3,
        PERCEIVED_TYPE_CUSTOM = -3,
        PERCEIVED_TYPE_UNSPECIFIED = -2,
        PERCEIVED_TYPE_FOLDER = -1,
        PERCEIVED_TYPE_UNKNOWN = 0,
        PERCEIVED_TYPE_TEXT = 1,
        PERCEIVED_TYPE_IMAGE = 2,
        PERCEIVED_TYPE_AUDIO = 3,
        PERCEIVED_TYPE_VIDEO = 4,
        PERCEIVED_TYPE_COMPRESSED = 5,
        PERCEIVED_TYPE_DOCUMENT = 6,
        PERCEIVED_TYPE_SYSTEM = 7,
        PERCEIVED_TYPE_APPLICATION = 8,
        PERCEIVED_TYPE_GAMEMEDIA = 9,
        PERCEIVED_TYPE_CONTACTS = 10,
        PERCEIVED_TYPE_LAST = 10);

    TPERCEIVED = tagPERCEIVED;
    PPERCEIVED = ^TPERCEIVED;



    TPERCEIVEDFLAG = DWORD;

    {$IFDEF NTDDI_VISTA}
    _COMDLG_FILTERSPEC = record
        (* [string] *)
        pszName: LPCWSTR;
        (* [string] *)
        pszSpec: LPCWSTR;
    end;
    TCOMDLG_FILTERSPEC = _COMDLG_FILTERSPEC;
    PCOMDLG_FILTERSPEC = ^TCOMDLG_FILTERSPEC;
    {$ENDIF}// NTDDI_VISTA


    KNOWNFOLDERID = TGUID;
    REFKNOWNFOLDERID = ^KNOWNFOLDERID;

    TKF_REDIRECT_FLAGS = DWORD;
    TFOLDERTYPEID = TGUID;

    PREFFOLDERTYPEID = ^TFOLDERTYPEID;
    TTASKOWNERID = TGUID;

    PREFTASKOWNERID = ^TTASKOWNERID;
    TELEMENTID = TGUID;

    PREFELEMENTID = ^TELEMENTID;



    tagLOGFONTA = record
        lfHeight: LONG;
        lfWidth: LONG;
        lfEscapement: LONG;
        lfOrientation: LONG;
        lfWeight: LONG;
        lfItalic: byte;
        lfUnderline: byte;
        lfStrikeOut: byte;
        lfCharSet: byte;
        lfOutPrecision: byte;
        lfClipPrecision: byte;
        lfQuality: byte;
        lfPitchAndFamily: byte;
        lfFaceName: array [0..32 - 1] of ansichar;
    end;
    TLOGFONTA = tagLOGFONTA;
    PLOGFONTA = ^TLOGFONTA;


    tagLOGFONTW = record
        lfHeight: LONG;
        lfWidth: LONG;
        lfEscapement: LONG;
        lfOrientation: LONG;
        lfWeight: LONG;
        lfItalic: byte;
        lfUnderline: byte;
        lfStrikeOut: byte;
        lfCharSet: byte;
        lfOutPrecision: byte;
        lfClipPrecision: byte;
        lfQuality: byte;
        lfPitchAndFamily: byte;
        lfFaceName: array [0..32 - 1] of WCHAR;
    end;
    TLOGFONTW = tagLOGFONTW;
    PLOGFONTW = ^TLOGFONTW;


    TLOGFONT = TLOGFONTW;


    tagSHCOLSTATE = (
        SHCOLSTATE_DEFAULT = 0,
        SHCOLSTATE_TYPE_STR = $1,
        SHCOLSTATE_TYPE_INT = $2,
        SHCOLSTATE_TYPE_DATE = $3,
        SHCOLSTATE_TYPEMASK = $f,
        SHCOLSTATE_ONBYDEFAULT = $10,
        SHCOLSTATE_SLOW = $20,
        SHCOLSTATE_EXTENDED = $40,
        SHCOLSTATE_SECONDARYUI = $80,
        SHCOLSTATE_HIDDEN = $100,
        SHCOLSTATE_PREFER_VARCMP = $200,
        SHCOLSTATE_PREFER_FMTCMP = $400,
        SHCOLSTATE_NOSORTBYFOLDERNESS = $800,
        SHCOLSTATE_VIEWONLY = $10000,
        SHCOLSTATE_BATCHREAD = $20000,
        SHCOLSTATE_NO_GROUPBY = $40000,
        SHCOLSTATE_FIXED_WIDTH = $1000,
        SHCOLSTATE_NODPISCALE = $2000,
        SHCOLSTATE_FIXED_RATIO = $4000,
        SHCOLSTATE_DISPLAYMASK = $f000);

    TSHCOLSTATE = tagSHCOLSTATE;
    PSHCOLSTATE = ^TSHCOLSTATE;


    TSHCOLSTATEF = DWORD;

    TSHCOLUMNID = TPROPERTYKEY;



    PLPCSHCOLUMNID = ^TSHCOLUMNID;

    TDEVICE_SCALE_FACTOR = (
        DEVICE_SCALE_FACTOR_INVALID = 0,
        SCALE_100_PERCENT = 100,
        SCALE_120_PERCENT = 120,
        SCALE_125_PERCENT = 125,
        SCALE_140_PERCENT = 140,
        SCALE_150_PERCENT = 150,
        SCALE_160_PERCENT = 160,
        SCALE_175_PERCENT = 175,
        SCALE_180_PERCENT = 180,
        SCALE_200_PERCENT = 200,
        SCALE_225_PERCENT = 225,
        SCALE_250_PERCENT = 250,
        SCALE_300_PERCENT = 300,
        SCALE_350_PERCENT = 350,
        SCALE_400_PERCENT = 400,
        SCALE_450_PERCENT = 450,
        SCALE_500_PERCENT = 500);

    PDEVICE_SCALE_FACTOR = ^TDEVICE_SCALE_FACTOR;



implementation

end.
