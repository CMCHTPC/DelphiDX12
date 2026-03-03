// not finshed
unit Win32.WTypes;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils;

type
    _tagpropertykey = record
        fmtid: TGUID;
        pid: DWORD;
    end;
    Ttagpropertykey = _tagpropertykey;
    Ptagpropertykey = ^Ttagpropertykey;

    TPROPERTYKEY = Ttagpropertykey;
    PPROPERTYKEY = ^TPROPERTYKEY;

    (* real definition that makes the C++ compiler happy *)
    tagCY = record
        case integer of
            0: (
                Lo: ULONG;
                Hi: LONG;
            );
            1: (_int64: LONGLONG);
    end;
    TCY = tagCY;
    PCY = ^TCY;
    LPCY = ^TCY;

    (* 0 == FALSE, -1 == TRUE *)
    TVARIANT_BOOL = smallint;
    PVARIANT_BOOL = ^TVARIANT_BOOL;
    SCODE = longint;
    PSCODE = ^SCODE;

    OLECHAR = WCHAR;
    POLECHAR = ^OLECHAR;
    BSTR = ^OLECHAR;
    PBSTR = ^BSTR;


    VARTYPE = Ushort;
    (* real definition that makes the C++ compiler happy *)
    tagDEC = record
        wReserved: USHORT;
        case integer of
            0: (
                scale: byte;
                sign: byte;
                Hi32: ULONG;
                case integer of
                    0: (
                    Lo32: ULONG;
                    Mid32: ULONG;
                    );
                    1: (
                    Lo64: ULONGLONG;
                    );
            );
            1: (
                signscale: USHORT;
            );


    end;
    TDEC = tagDEC;
    PDEC = ^TDEC;
    TDECIMAL = TDEC;
    PDECIMAL = ^TDECIMAL;

    TPROPID = ULONG;
    PPROPID = ^TPROPID;



    (*
 * VARENUM usage key,
 *
 * * [V] - may appear in a VARIANT
 * * [T] - may appear in a TYPEDESC
 * * [P] - may appear in an OLE property set
 * * [S] - may appear in a Safe Array
 *
 *
 *  VT_EMPTY            [V]   [P]     nothing
 *  VT_NULL             [V]   [P]     SQL style Null
 *  VT_I2               [V][T][P][S]  2 byte signed int
 *  VT_I4               [V][T][P][S]  4 byte signed int
 *  VT_R4               [V][T][P][S]  4 byte real
 *  VT_R8               [V][T][P][S]  8 byte real
 *  VT_CY               [V][T][P][S]  currency
 *  VT_DATE             [V][T][P][S]  date
 *  VT_BSTR             [V][T][P][S]  OLE Automation string
 *  VT_DISPATCH         [V][T]   [S]  IDispatch *
 *  VT_ERROR            [V][T][P][S]  SCODE
 *  VT_BOOL             [V][T][P][S]  True=-1, False=0
 *  VT_VARIANT          [V][T][P][S]  VARIANT *
 *  VT_UNKNOWN          [V][T]   [S]  IUnknown *
 *  VT_DECIMAL          [V][T]   [S]  16 byte fixed point
 *  VT_RECORD           [V]   [P][S]  user defined type
 *  VT_I1               [V][T][P][s]  signed char
 *  VT_UI1              [V][T][P][S]  unsigned char
 *  VT_UI2              [V][T][P][S]  unsigned short
 *  VT_UI4              [V][T][P][S]  ULONG
 *  VT_I8                  [T][P]     signed 64-bit int
 *  VT_UI8                 [T][P]     unsigned 64-bit int
 *  VT_INT              [V][T][P][S]  signed machine int
 *  VT_UINT             [V][T]   [S]  unsigned machine int
 *  VT_INT_PTR             [T]        signed machine register size width
 *  VT_UINT_PTR            [T]        unsigned machine register size width
 *  VT_VOID                [T]        C style void
 *  VT_HRESULT             [T]        Standard return type
 *  VT_PTR                 [T]        pointer type
 *  VT_SAFEARRAY           [T]        (use VT_ARRAY in VARIANT)
 *  VT_CARRAY              [T]        C style array
 *  VT_USERDEFINED         [T]        user defined type
 *  VT_LPSTR               [T][P]     null terminated string
 *  VT_LPWSTR              [T][P]     wide null terminated string
 *  VT_FILETIME               [P]     FILETIME
 *  VT_BLOB                   [P]     Length prefixed bytes
 *  VT_STREAM                 [P]     Name of the stream follows
 *  VT_STORAGE                [P]     Name of the storage follows
 *  VT_STREAMED_OBJECT        [P]     Stream contains an object
 *  VT_STORED_OBJECT          [P]     Storage contains an object
 *  VT_VERSIONED_STREAM       [P]     Stream with a GUID version
 *  VT_BLOB_OBJECT            [P]     Blob contains an object
 *  VT_CF                     [P]     Clipboard format
 *  VT_CLSID                  [P]     A Class ID
 *  VT_VECTOR                 [P]     simple counted array
 *  VT_ARRAY            [V]           SAFEARRAY*
 *  VT_BYREF            [V]           void* for local use
 *  VT_BSTR_BLOB                      Reserved for system use
 *)

    TVARENUM = (
        VT_EMPTY = 0,
        VT_NULL = 1,
        VT_I2 = 2,
        VT_I4 = 3,
        VT_R4 = 4,
        VT_R8 = 5,
        VT_CY = 6,
        VT_DATE = 7,
        VT_BSTR = 8,
        VT_DISPATCH = 9,
        VT_ERROR = 10,
        VT_BOOL = 11,
        VT_VARIANT = 12,
        VT_UNKNOWN = 13,
        VT_DECIMAL = 14,
        VT_I1 = 16,
        VT_UI1 = 17,
        VT_UI2 = 18,
        VT_UI4 = 19,
        VT_I8 = 20,
        VT_UI8 = 21,
        VT_INT = 22,
        VT_UINT = 23,
        VT_VOID = 24,
        VT_HRESULT = 25,
        VT_PTR = 26,
        VT_SAFEARRAY = 27,
        VT_CARRAY = 28,
        VT_USERDEFINED = 29,
        VT_LPSTR = 30,
        VT_LPWSTR = 31,
        VT_RECORD = 36,
        VT_INT_PTR = 37,
        VT_UINT_PTR = 38,
        VT_FILETIME = 64,
        VT_BLOB = 65,
        VT_STREAM = 66,
        VT_STORAGE = 67,
        VT_STREAMED_OBJECT = 68,
        VT_STORED_OBJECT = 69,
        VT_BLOB_OBJECT = 70,
        VT_CF = 71,
        VT_CLSID = 72,
        VT_VERSIONED_STREAM = 73,
        VT_BSTR_BLOB = $fff,
        VT_VECTOR = $1000,
        VT_ARRAY = $2000,
        VT_BYREF = $4000,
        VT_RESERVED = $8000,
        VT_ILLEGAL = $ffff,
        VT_ILLEGALMASKED = $fff,
        VT_TYPEMASK = $fff);

    PVARENUM = ^TVARENUM;
    LPCOLESTR = ^pwidechar;

const
    VARIANT_TRUE = TVARIANT_BOOL(-1);
    VARIANT_FALSE = TVARIANT_BOOL(0);

implementation

end.
