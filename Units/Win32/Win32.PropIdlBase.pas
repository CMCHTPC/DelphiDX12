//+-------------------------------------------------------------------------

//  Microsoft Windows
//  Copyright (c) Microsoft Corporation. All rights reserved.

//--------------------------------------------------------------------------

unit Win32.PropIdlBase;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    Win32.WTypes,
    Win32.OAIdl,
    Win32.ObjIdl;

const


    // Flags for IPropertySetStorage::Create
    PROPSETFLAG_DEFAULT = (0);

    PROPSETFLAG_NONSIMPLE = (1);

    PROPSETFLAG_ANSI = (2);

    //   (This flag is only supported on StgCreatePropStg & StgOpenPropStg
    PROPSETFLAG_UNBUFFERED = (4);

    //   (This flag causes a version-1 property set to be created
    PROPSETFLAG_CASE_SENSITIVE = (8);


    // Flags for the reserved PID_BEHAVIOR property
    PROPSET_BEHAVIOR_CASE_SENSITIVE = (1);


    // Reserved global Property IDs
    PID_DICTIONARY = (0);

    PID_CODEPAGE = ($1);

    PID_FIRST_USABLE = ($2);

    PID_FIRST_NAME_DEFAULT = ($fff);

    PID_LOCALE = ($80000000);

    PID_MODIFY_TIME = ($80000001);

    PID_SECURITY = ($80000002);

    PID_BEHAVIOR = ($80000003);

    PID_ILLEGAL = ($ffffffff);

    // Range which is read-only to downlevel implementations
    PID_MIN_READONLY = ($80000000);

    PID_MAX_READONLY = ($bfffffff);

    PRSPEC_INVALID = ($ffffffff);

    PRSPEC_LPWSTR = (0);

    PRSPEC_PROPID = (1);


    PROPSETHDR_OSVERSION_UNKNOWN = $FFFFFFFF;


    IID_IPropertyStorage: TGUID = '{00000138-0000-0000-C000-000000000046}';
    IID_IPropertySetStorage: TGUID = '{0000013A-0000-0000-C000-000000000046}';
    IID_IEnumSTATPROPSTG: TGUID = '{00000139-0000-0000-C000-000000000046}';
    IID_IEnumSTATPROPSETSTG: TGUID = '{0000013B-0000-0000-C000-000000000046}';


type
    FMTID = TGUID;
    REFFMTID = ^FMTID;
    PIDispatch = ^IDispatch;
    (* Forward Declarations *)


    IPropertyStorage = interface;
    PIPropertyStorage = ^IPropertyStorage;


    IPropertySetStorage = interface;
    PIPropertySetStorage = ^IPropertySetStorage;


    IEnumSTATPROPSTG = interface;
    PIEnumSTATPROPSTG = ^IEnumSTATPROPSTG;


    IEnumSTATPROPSETSTG = interface;
    PIEnumSTATPROPSETSTG = ^IEnumSTATPROPSETSTG;


    tagVersionedStream = record
        guidVersion: TGUID;
        pStream: PIStream;
    end;
    TVersionedStream = tagVersionedStream;
    PVersionedStream = ^TVersionedStream;
    LPVERSIONEDSTREAM = ^TVersionedStream;


    tagCAC = record
        cElems: ULONG; (* [size_is] *)
        pElems: pchar;
    end;
    TCAC = tagCAC;
    PCAC = ^TCAC;


    tagCAUB = record
        cElems: ULONG; (* [size_is] *)
        pElems: PUCHAR;
    end;
    TCAUB = tagCAUB;
    PCAUB = ^TCAUB;


    tagCAI = record
        cElems: ULONG; (* [size_is] *)
        pElems: PSHORT;
    end;
    TCAI = tagCAI;
    PCAI = ^TCAI;


    tagCAUI = record
        cElems: ULONG; (* [size_is] *)
        pElems: PUSHORT;
    end;
    TCAUI = tagCAUI;
    PCAUI = ^TCAUI;


    tagCAL = record
        cElems: ULONG; (* [size_is] *)
        pElems: PLONG;
    end;
    TCAL = tagCAL;
    PCAL = ^TCAL;


    tagCAUL = record
        cElems: ULONG; (* [size_is] *)
        pElems: PULONG;
    end;
    TCAUL = tagCAUL;
    PCAUL = ^TCAUL;


    tagCAFLT = record
        cElems: ULONG; (* [size_is] *)
        pElems: Psingle;
    end;
    TCAFLT = tagCAFLT;
    PCAFLT = ^TCAFLT;


    tagCADBL = record
        cElems: ULONG; (* [size_is] *)
        pElems: Pdouble;
    end;
    TCADBL = tagCADBL;
    PCADBL = ^TCADBL;


    tagCACY = record
        cElems: ULONG; (* [size_is] *)
        pElems: PCY;
    end;
    TCACY = tagCACY;
    PCACY = ^TCACY;


    tagCADATE = record
        cElems: ULONG; (* [size_is] *)
        pElems: PDATE;
    end;
    TCADATE = tagCADATE;
    PCADATE = ^TCADATE;


    tagCABSTR = record
        cElems: ULONG; (* [size_is] *)
        pElems: PBSTR;
    end;
    TCABSTR = tagCABSTR;
    PCABSTR = ^TCABSTR;


    tagCABSTRBLOB = record
        cElems: ULONG; (* [size_is] *)
        pElems: PBSTRBLOB;
    end;
    TCABSTRBLOB = tagCABSTRBLOB;
    PCABSTRBLOB = ^TCABSTRBLOB;


    tagCABOOL = record
        cElems: ULONG; (* [size_is] *)
        pElems: PVARIANT_BOOL;
    end;
    TCABOOL = tagCABOOL;
    PCABOOL = ^TCABOOL;


    tagCASCODE = record
        cElems: ULONG; (* [size_is] *)
        pElems: PSCODE;
    end;
    TCASCODE = tagCASCODE;
    PCASCODE = ^TCASCODE;


    PPROPVARIANT = ^TPROPVARIANT;

    tagCAPROPVARIANT = record
        cElems: ULONG; (* [size_is] *)
        pElems: PPROPVARIANT;
    end;
    TCAPROPVARIANT = tagCAPROPVARIANT;
    PCAPROPVARIANT = ^TCAPROPVARIANT;


    tagCAH = record
        cElems: ULONG; (* [size_is] *)
        pElems: PLARGE_INTEGER;
    end;
    TCAH = tagCAH;
    PCAH = ^TCAH;


    tagCAUH = record
        cElems: ULONG; (* [size_is] *)
        pElems: PULARGE_INTEGER;
    end;
    TCAUH = tagCAUH;
    PCAUH = ^TCAUH;


    tagCALPSTR = record
        cElems: ULONG; (* [size_is] *)
        pElems: PLPSTR;
    end;
    TCALPSTR = tagCALPSTR;
    PCALPSTR = ^TCALPSTR;


    tagCALPWSTR = record
        cElems: ULONG; (* [size_is] *)
        pElems: PLPWSTR;
    end;
    TCALPWSTR = tagCALPWSTR;
    PCALPWSTR = ^TCALPWSTR;


    tagCAFILETIME = record
        cElems: ULONG; (* [size_is] *)
        pElems: PFILETIME;
    end;
    TCAFILETIME = tagCAFILETIME;
    PCAFILETIME = ^TCAFILETIME;


    tagCACLIPDATA = record
        cElems: ULONG; (* [size_is] *)
        pElems: PCLIPDATA;
    end;
    TCACLIPDATA = tagCACLIPDATA;
    PCACLIPDATA = ^TCACLIPDATA;


    tagCACLSID = record
        cElems: ULONG; (* [size_is] *)
        pElems: PCLSID;
    end;
    TCACLSID = tagCACLSID;
    PCACLSID = ^TCACLSID;


    // This is the standard C layout of the structure.
    TPROPVAR_PAD1 = word;
    TPROPVAR_PAD2 = word;
    TPROPVAR_PAD3 = word;

    tagPROPVARIANT = record
        case integer of
            0: (
                vt: VARTYPE;
                wReserved1: TPROPVAR_PAD1;
                wReserved2: TPROPVAR_PAD2;
                wReserved3: TPROPVAR_PAD3;
                    (* [switch_is] *)(* [switch_type] *)
                case integer of
                    (* [case()] *)(* Empty union arm *)

                    0: (
                    cVal: ansichar;
                    );

                    1: (
                    bVal: UCHAR;
                    );

                    2: (
                    iVal: SHORT;
                    );

                    3: (
                    uiVal: USHORT;
                    );

                    4: (
                    lVal: LONG;
                    );

                    5: (
                    ulVal: ULONG;
                    );

                    6: (
                    intVal: int32;
                    );

                    7: (
                    uintVal: UINT;
                    );

                    8: (
                    hVal: LARGE_INTEGER;
                    );

                    9: (
                    uhVal: ULARGE_INTEGER;
                    );

                    10: (
                    fltVal: single;
                    );

                    11: (
                    dblVal: double;
                    );

                    12: (
                    boolVal: TVARIANT_BOOL;
                    );

                    13: (
                    __OBSOLETE__VARIANT_BOOL: TVARIANT_BOOL;
                    );

                    14: (
                    scode: SCODE;
                    );

                    15: (
                    cyVal: TCY;
                    );

                    16: (
                    date: TDATE;
                    );

                    17: (
                    filetime: TFILETIME;
                    );

                    18: (
                    puuid: PCLSID;
                    );

                    19: (
                    pclipdata: PCLIPDATA;
                    );

                    20: (
                    bstrVal: BSTR;
                    );

                    21: (
                    bstrblobVal: BSTRBLOB;
                    );

                    22: (
                    blob: TBLOB;
                    );

                    23: (
                    pszVal: LPSTR;
                    );

                    24: (
                    pwszVal: LPWSTR;
                    );

                    25: (
                    punkVal: PIUnknown;
                    );

                    26: (
                    pdispVal: PIDispatch;
                    );

                    27: (
                    pStream: PIStream;
                    );

                    28: (
                    pStorage: PIStorage;
                    );

                    29: (
                    pVersionedStream: LPVERSIONEDSTREAM;
                    );

                    30: (
                    parray: LPSAFEARRAY;
                    );

                    31: (
                    cac: TCAC;
                    );

                    32: (
                    caub: TCAUB;
                    );

                    33: (
                    cai: TCAI;
                    );

                    34: (
                    caui: TCAUI;
                    );

                    35: (
                    cal: TCAL;
                    );

                    36: (
                    caul: TCAUL;
                    );

                    37: (
                    cah: TCAH;
                    );

                    38: (
                    cauh: TCAUH;
                    );

                    39: (
                    caflt: TCAFLT;
                    );

                    40: (
                    cadbl: TCADBL;
                    );

                    41: (
                    cabool: TCABOOL;
                    );

                    42: (
                    cascode: TCASCODE;
                    );

                    43: (
                    cacy: TCACY;
                    );

                    44: (
                    cadate: TCADATE;
                    );

                    45: (
                    cafiletime: TCAFILETIME;
                    );

                    46: (
                    cauuid: TCACLSID;
                    );

                    47: (
                    caclipdata: TCACLIPDATA;
                    );

                    48: (
                    cabstr: TCABSTR;
                    );

                    49: (
                    cabstrblob: TCABSTRBLOB;
                    );

                    50: (
                    calpstr: TCALPSTR;
                    );

                    51: (
                    calpwstr: TCALPWSTR;
                    );

                    52: (
                    capropvar: TCAPROPVARIANT;
                    );

                    53: (
                    pcVal: pchar;
                    );

                    54: (
                    pbVal: PUCHAR;
                    );

                    55: (
                    piVal: PSHORT;
                    );

                    56: (
                    puiVal: PUSHORT;
                    );

                    57: (
                    plVal: PLONG;
                    );

                    58: (
                    pulVal: PULONG;
                    );

                    59: (
                    pintVal: PINT32;
                    );

                    60: (
                    puintVal: PUINT;
                    );

                    61: (
                    pfltVal: Psingle;
                    );

                    62: (
                    pdblVal: Pdouble;
                    );

                    63: (
                    pboolVal: PVARIANT_BOOL;
                    );

                    64: (
                    pdecVal: PDECIMAL;
                    );

                    65: (
                    pscode: PSCODE;
                    );

                    66: (
                    pcyVal: PCY;
                    );

                    67: (
                    pdate: PDATE;
                    );

                    68: (
                    pbstrVal: PBSTR;
                    );

                    69: (
                    ppunkVal: PIUnknown;
                    );

                    70: (
                    ppdispVal: PIDispatch;
                    );

                    71: (
                    pparray: LPSAFEARRAY;
                    );

                    72: (
                    pvarVal: PPROPVARIANT;
                    );
            );
            1: (decVal: TDECIMAL);
    end;
    // This is the standard C layout of the PROPVARIANT.
    TPROPVARIANT = tagPROPVARIANT;
    LPPROPVARIANT = ^TPROPVARIANT;
    REFPROPVARIANT = ^TPROPVARIANT;


    tagPROPSPEC = record
        ulKind: ULONG; (* [switch_type] *)
        case integer of
            0: (
                propid: TPROPID;
            );
            1: (
                lpwstr: LPOLESTR;
            );
    end;
    TPROPSPEC = tagPROPSPEC;
    PPROPSPEC = ^TPROPSPEC;


    tagSTATPROPSTG = record
        lpwstrName: LPOLESTR;
        propid: TPROPID;
        vt: VARTYPE;
    end;
    TSTATPROPSTG = tagSTATPROPSTG;
    PSTATPROPSTG = ^TSTATPROPSTG;


    tagSTATPROPSETSTG = record
        fmtid: FMTID;
        clsid: CLSID;
        grfFlags: DWORD;
        mtime: TFILETIME;
        ctime: TFILETIME;
        atime: TFILETIME;
        dwOSVersion: DWORD;
    end;
    TSTATPROPSETSTG = tagSTATPROPSETSTG;
    PSTATPROPSETSTG = ^TSTATPROPSETSTG;


    IPropertyStorage = interface(IUnknown)
        ['{00000138-0000-0000-C000-000000000046}']
        function ReadMultiple(cpspec: ULONG;
        {__RPC__in_ecount_full(cpspec) } rgpspec: PPROPSPEC;
        {__RPC__out_ecount_full(cpspec) } rgpropvar: PPROPVARIANT): HRESULT; stdcall;

        function WriteMultiple(cpspec: ULONG;
        {__RPC__in_ecount_full(cpspec) } rgpspec: PPROPSPEC;
        {__RPC__in_ecount_full(cpspec) } rgpropvar: PPROPVARIANT; propidNameFirst: TPROPID): HRESULT; stdcall;

        function DeleteMultiple(cpspec: ULONG;
        {__RPC__in_ecount_full(cpspec) } rgpspec: PPROPSPEC): HRESULT; stdcall;

        function ReadPropertyNames(cpropid: ULONG;
        {__RPC__in_ecount_full(cpropid) } rgpropid: PPROPID;
        {__RPC__out_ecount_full(cpropid) } rglpwstrName: PLPOLESTR): HRESULT; stdcall;

        function WritePropertyNames(cpropid: ULONG;
        {__RPC__in_ecount_full(cpropid) } rgpropid: PPROPID;
        {__RPC__in_ecount_full(cpropid) } rglpwstrName: PLPOLESTR): HRESULT; stdcall;

        function DeletePropertyNames(cpropid: ULONG;
        {__RPC__in_ecount_full(cpropid) } rgpropid: PPROPID): HRESULT; stdcall;

        function Commit(grfCommitFlags: DWORD): HRESULT; stdcall;

        function Revert(): HRESULT; stdcall;

        function Enum(
        {__RPC__deref_out_opt }  out ppenum: IEnumSTATPROPSTG): HRESULT; stdcall;

        function SetTimes(
        {__RPC__in } pctime: PFILETIME;
        {__RPC__in } patime: PFILETIME;
        {__RPC__in } pmtime: PFILETIME): HRESULT; stdcall;

        function SetClass(
        {__RPC__in } clsid: REFCLSID): HRESULT; stdcall;

        function Stat(
        {__RPC__out } pstatpsstg: PSTATPROPSETSTG): HRESULT; stdcall;

    end;

    LPPROPERTYSETSTORAGE = ^IPropertySetStorage;


    IPropertySetStorage = interface(IUnknown)
        ['{0000013A-0000-0000-C000-000000000046}']
        function Create(
        {__RPC__in } rfmtid: REFFMTID;
        {__RPC__in_opt } pclsid: PCLSID; grfFlags: DWORD; grfMode: DWORD;
        {__RPC__deref_out_opt }  ppprstg: PIPropertyStorage = nil): HRESULT; stdcall;

        function Open(
        {__RPC__in } rfmtid: REFFMTID; grfMode: DWORD;
        {__RPC__deref_out_opt }  ppprstg: PIPropertyStorage = nil): HRESULT; stdcall;

        function Delete(
        {__RPC__in } rfmtid: REFFMTID): HRESULT; stdcall;

        function Enum(
        {__RPC__deref_out_opt }  ppenum: PIEnumSTATPROPSETSTG = nil): HRESULT; stdcall;

    end;

    LPENUMSTATPROPSTG = ^IEnumSTATPROPSTG;


    IEnumSTATPROPSTG = interface(IUnknown)
        ['{00000139-0000-0000-C000-000000000046}']
        function Next(celt: ULONG;
        {_Out_writes_to_(celt, *pceltFetched)  } rgelt: PSTATPROPSTG;
        {_Out_opt_ _Deref_out_range_(0, celt)  } pceltFetched: PULONG): HRESULT; stdcall;
        function Skip(celt: ULONG): HRESULT; stdcall;
        function Reset(): HRESULT; stdcall;
        function Clone(
        {__RPC__deref_out_opt }  ppenum: PIEnumSTATPROPSTG = nil): HRESULT; stdcall;
    end;

    LPENUMSTATPROPSETSTG = ^IEnumSTATPROPSETSTG;


    IEnumSTATPROPSETSTG = interface(IUnknown)
        ['{0000013B-0000-0000-C000-000000000046}']
        function Next(celt: ULONG;
        {_Out_writes_to_(celt, *pceltFetched)  } rgelt: PSTATPROPSETSTG;
        {_Out_opt_ _Deref_out_range_(0, celt)  } pceltFetched: PULONG): HRESULT; stdcall;

        function Skip(celt: ULONG): HRESULT; stdcall;

        function Reset(): HRESULT; stdcall;

        function Clone(
        {__RPC__deref_out_opt }  ppenum: PIEnumSTATPROPSETSTG): HRESULT; stdcall;

    end;

    LPPROPERTYSTORAGE = ^IPropertyStorage;

// Macros for parsing the OS Version of the Property Set Header
function PROPSETHDR_OSVER_KIND(dwOSVer: dword): word; inline;
function PROPSETHDR_OSVER_MAJOR(dwOSVer: dword): byte; inline;
function PROPSETHDR_OSVER_MINOR(dwOSVer: dword): byte; inline;

implementation



function PROPSETHDR_OSVER_KIND(dwOSVer: dword): word; inline;
begin
    Result := HIWORD((dwOSVer));
end;



function PROPSETHDR_OSVER_MAJOR(dwOSVer: dword): byte; inline;
begin
    Result := LOBYTE(LOWORD((dwOSVer)));
end;



function PROPSETHDR_OSVER_MINOR(dwOSVer: dword): byte; inline;
begin
    Result := HIBYTE(LOWORD((dwOSVer)));
end;

end.
