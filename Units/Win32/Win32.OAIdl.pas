unit Win32.OAIdl;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    Win32.WTypes;

type

    PIUnknown = ^IUnknown;
    PIDispatch = ^IDispatch;

    tagSAFEARRAYBOUND = record
        cElements: ULONG;
        lLbound: LONG;
    end;
    TSAFEARRAYBOUND = tagSAFEARRAYBOUND;
    PSAFEARRAYBOUND = ^TSAFEARRAYBOUND;
    LPSAFEARRAYBOUND = ^TSAFEARRAYBOUND;


    tagSAFEARRAY = record
        cDims: USHORT;
        fFeatures: USHORT;
        cbElements: ULONG;
        cLocks: ULONG;
        pvData: PVOID;
        rgsabound: array [0..0] of TSAFEARRAYBOUND;
    end;
    TSAFEARRAY = tagSAFEARRAY;
    PSAFEARRAY = ^TSAFEARRAY;
    LPSAFEARRAY = ^TSAFEARRAY;

    ITypeInfo = interface(IUnknown)
        ['{00020401-0000-0000-C000-000000000046}']
        // ToDo
    end;


    IRecordInfo = interface(IUnknown)
        ['{0000002F-0000-0000-C000-000000000046}']
        function RecordInit(pvNew: PVOID): HRESULT; stdcall;

        function RecordClear(pvExisting: PVOID): HRESULT; stdcall;

        function RecordCopy(pvExisting: PVOID; pvNew: PVOID): HRESULT; stdcall;

        function GetGuid(pguid: PGUID): HRESULT; stdcall;

        function GetName(
        {__RPC__deref_out_opt  } pbstrName: PBSTR): HRESULT; stdcall;

        function GetSize(pcbSize: PULONG): HRESULT; stdcall;

        function GetTypeInfo(out ppTypeInfo: ITypeInfo): HRESULT; stdcall;

        function GetField(pvData: PVOID; szFieldName: LPCOLESTR; pvarField: PVARIANT): HRESULT; stdcall;

        function GetFieldNoCopy(pvData: PVOID; szFieldName: LPCOLESTR; pvarField: PVARIANT; out ppvDataCArray: PVOID): HRESULT; stdcall;

        function PutField(wFlags: ULONG; pvData: PVOID; szFieldName: LPCOLESTR; pvarField: PVARIANT): HRESULT; stdcall;

        function PutFieldNoCopy(wFlags: ULONG; pvData: PVOID; szFieldName: LPCOLESTR; pvarField: PVARIANT): HRESULT; stdcall;

        function GetFieldNames(pcNames: PULONG;
        {__RPC__out_ecount_part(*pcNames, *pcNames)  } rgBstrNames: PBSTR): HRESULT; stdcall;

        function IsMatchingType(pRecordInfo: IRecordInfo): winbool; stdcall;

        function RecordCreate(): PVOID; stdcall;

        function RecordCreateCopy(pvSource: PVOID; out ppvDest: PVOID): HRESULT; stdcall;

        function RecordDestroy(pvRecord: PVOID): HRESULT; stdcall;

    end;
     PIRecordInfo = ^IRecordInfo;

    tagVARIANT = record
        case integer of
            0: (
                vt: TVARTYPE;
                wReserved1: word;
                wReserved2: word;
                wReserved3: word;
                case integer of
                    0: (
                    llVal: LONGLONG;
                    );
                    1: (
                    lVal: LONG;
                    );
                    2: (
                    bVal: byte;
                    );
                    3: (
                    iVal: SHORT;
                    );
                    4: (
                    fltVal: single;
                    );
                    5: (
                    dblVal: double;
                    );
                    6: (
                    boolVal: TVARIANT_BOOL;
                    );
                    7: (
                    __OBSOLETE__VARIANT_BOOL: TVARIANT_BOOL;
                    );
                    8: (
                    scode: SCODE;
                    );
                    9: (
                    cyVal: TCY;
                    );
                    10: (
                    date: TDATE;
                    );
                    11: (
                    bstrVal: BSTR;
                    );
                    12: (
                    punkVal: PIUnknown;
                    );
                    13: (
                    pdispVal: PIDispatch;
                    );
                    14: (
                    parray: PSAFEARRAY;
                    );
                    15: (
                    pbVal: pbyte;
                    );
                    16: (
                    piVal: PSHORT;
                    );
                    17: (
                    plVal: PLONG;
                    );
                    18: (
                    pllVal: PLONGLONG;
                    );
                    19: (
                    pfltVal: Psingle;
                    );
                    20: (
                    pdblVal: Pdouble;
                    );
                    21: (
                    pboolVal: PVARIANT_BOOL;
                    );
                    22: (
                    __OBSOLETE__VARIANT_PBOOL: PVARIANT_BOOL;
                    );
                    23: (
                    pscode: PSCODE;
                    );
                    24: (
                    pcyVal: PCY;
                    );
                    25: (
                    pdate: PDATE;
                    );
                    26: (
                    pbstrVal: PBSTR;
                    );
                    27: (
                    ppunkVal: PIUnknown;
                    );
                    28: (
                    ppdispVal: PIDispatch;
                    );
                    29: (
                    pparray: PSAFEARRAY;
                    );
                    30: (
                    pvarVal: PVARIANT;
                    );
                    31: (
                    byref: PVOID;
                    );
                    32: (
                    cVal: char;
                    );
                    33: (
                    uiVal: USHORT;
                    );
                    34: (
                    ulVal: ULONG;
                    );
                    35: (
                    ullVal: ULONGLONG;
                    );
                    36: (
                    intVal: int32;
                    );
                    37: (
                    uintVal: UINT;
                    );
                    38: (
                    pdecVal: PDECIMAL;
                    );
                    39: (
                    pcVal: pchar;
                    );
                    40: (
                    puiVal: PUSHORT;
                    );
                    41: (
                    pulVal: PULONG;
                    );
                    42: (
                    pullVal: PULONGLONG;
                    );
                    43: (
                    pintVal: PINT32;
                    );
                    44: (
                    puintVal: PUINT;
                    );
                    45: (
                    TBRECORD: record
                        pvRecord: PVOID;
                        pRecInfo: PIRecordInfo;
                        end;
                    );
            );
            1: (
                decVal: TDECIMAL;
            );
    end;
    TVARIANT = tagVARIANT;
    PVARIANT = ^TVARIANT;
    LPVARIANT = ^TVARIANT;

    TVARIANTARG = TVARIANT;
    LPVARIANTARG = ^TVARIANT;

implementation

end.
