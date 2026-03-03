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
   File name:  wtypesbase.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

//+-------------------------------------------------------------------------

//  Microsoft Windows
//  Copyright (c) Microsoft Corporation. All rights reserved.

//--------------------------------------------------------------------------
unit Win32.WTypesBase;

{$mode ObjFPC}{$H+}



interface

uses
    Windows, Classes, SysUtils;

const

    ROTREGFLAGS_ALLOWANYCLIENT = $1;

    APPIDREGFLAGS_ACTIVATE_IUSERVER_INDESKTOP = $1;
    APPIDREGFLAGS_SECURE_SERVER_PROCESS_SD_AND_BIND = $2;
    APPIDREGFLAGS_ISSUE_ACTIVATION_RPC_AT_IDENTIFY = $4;
    APPIDREGFLAGS_IUSERVER_UNMODIFIED_LOGON_TOKEN = $8;
    APPIDREGFLAGS_IUSERVER_SELF_SID_IN_LAUNCH_PERMISSION = $10;
    APPIDREGFLAGS_IUSERVER_ACTIVATE_IN_CLIENT_SESSION_ONLY = $20;
    APPIDREGFLAGS_RESERVED1 = $40;
    APPIDREGFLAGS_RESERVED2 = $80;
    APPIDREGFLAGS_RESERVED3 = $100;
    APPIDREGFLAGS_RESERVED4 = $200;
    APPIDREGFLAGS_RESERVED5 = $400;
    APPIDREGFLAGS_AAA_NO_IMPLICIT_ACTIVATE_AS_IU = $800;
    APPIDREGFLAGS_RESERVED7 = $1000;
    APPIDREGFLAGS_RESERVED8 = $2000;
    APPIDREGFLAGS_RESERVED9 = $4000;
    APPIDREGFLAGS_RESERVED10 = $8000;


    DCOMSCM_ACTIVATION_USE_ALL_AUTHNSERVICES = $1;
    DCOMSCM_ACTIVATION_DISALLOW_UNSECURE_CALL = $2;
    DCOMSCM_RESOLVE_USE_ALL_AUTHNSERVICES = $4;
    DCOMSCM_RESOLVE_DISALLOW_UNSECURE_CALL = $8;
    DCOMSCM_PING_USE_MID_AUTHNSERVICE = $10;
    DCOMSCM_PING_DISALLOW_UNSECURE_CALL = $20;

type
    UINT = longword;
    INT = longint;
    WINBOOL = longint;
    LONG = longint;
    DWORD = longword;

    HANDLE = pointer;

    LPWORD = ^word;
    LPDWORD = ^DWORD;
    LPSTR = ^ansichar;
    LPCSTR = ^ansichar;

    WCHAR = widechar;
    TCHAR = widechar;

    LPWSTR = ^WCHAR;
    LPTSTR = ^TCHAR;
    LPCWSTR = ^WCHAR;
    LPCTSTR = ^TCHAR;

    LPHANDLE = ^HANDLE;

    {$IFNDEF OLE2ANSI}
    TOLECHAR = WCHAR;
    LPOLESTR = ^TOLECHAR;
    LPCOLESTR = ^TOLECHAR;
    {$ELSE}
    TOLECHAR = ansichar;
    LPOLESTR = LPSTR;
    LPCOLESTR = LPCSTR;
    {$ENDIF}

    PVOID = pointer;
    LPVOID = pointer;
    FLOAT = single;

    UCHAR = byte;
    SHORT = smallint;
    USHORT = word;

    ULONG = DWORD;

    DWORDLONG = uint64;
    PDWORDLONG = ^DWORDLONG;

    LONGLONG = int64;

    ULONGLONG = uint64;

    PLONGLONG = ^LONGLONG;
    PULONGLONG = ^ULONGLONG;

    hyper = int64;
    Phyper = ^hyper;


    _LARGE_INTEGER = record
        QuadPart: LONGLONG;
    end;
    TLARGE_INTEGER = _LARGE_INTEGER;
    PLARGE_INTEGER = ^TLARGE_INTEGER;


    PPLARGE_INTEGER = ^LARGE_INTEGER;

    _ULARGE_INTEGER = record
        QuadPart: ULONGLONG;
    end;
    TULARGE_INTEGER = _ULARGE_INTEGER;
    PULARGE_INTEGER = ^TULARGE_INTEGER;

    _FILETIME = record
        dwLowDateTime: DWORD;
        dwHighDateTime: DWORD;
    end;
    TFILETIME = _FILETIME;
    PFILETIME = ^TFILETIME;
    LPFILETIME = ^TFILETIME;



    _SYSTEMTIME = record
        wYear: word;
        wMonth: word;
        wDayOfWeek: word;
        wDay: word;
        wHour: word;
        wMinute: word;
        wSecond: word;
        wMilliseconds: word;
    end;
    TSYSTEMTIME = _SYSTEMTIME;
    PSYSTEMTIME = ^TSYSTEMTIME;
    LPSYSTEMTIME = ^TSYSTEMTIME;


    _SECURITY_ATTRIBUTES = record
        nLength: DWORD;
        lpSecurityDescriptor: LPVOID;
        bInheritHandle: winbool;
    end;
    TSECURITY_ATTRIBUTES = _SECURITY_ATTRIBUTES;
    PSECURITY_ATTRIBUTES = ^TSECURITY_ATTRIBUTES;
    LPSECURITY_ATTRIBUTES = ^TSECURITY_ATTRIBUTES;


    TSECURITY_DESCRIPTOR_CONTROL = USHORT;

    PPSECURITY_DESCRIPTOR_CONTROL = ^USHORT;

    TPSID = PVOID;

    _ACL = record
        AclRevision: UCHAR;
        Sbz1: UCHAR;
        AclSize: USHORT;
        AceCount: USHORT;
        Sbz2: USHORT;
    end;
    TACL = _ACL;
    PACL = ^TACL;


    _SECURITY_DESCRIPTOR = record
        Revision: UCHAR;
        Sbz1: UCHAR;
        Control: TSECURITY_DESCRIPTOR_CONTROL;
        Owner: TPSID;
        Group: TPSID;
        Sacl: PACL;
        Dacl: PACL;
    end;
    TSECURITY_DESCRIPTOR = _SECURITY_DESCRIPTOR;
    PSECURITY_DESCRIPTOR = ^TSECURITY_DESCRIPTOR;
    PISECURITY_DESCRIPTOR = ^TSECURITY_DESCRIPTOR;


    _COAUTHIDENTITY = record
        (* [size_is] *)
        User: PUSHORT;
        (* [range] *)
        UserLength: ULONG;
        (* [size_is] *)
        Domain: PUSHORT;
        (* [range] *)
        DomainLength: ULONG;
        (* [size_is] *)
        Password: PUSHORT;
        (* [range] *)
        PasswordLength: ULONG;
        Flags: ULONG;
    end;
    TCOAUTHIDENTITY = _COAUTHIDENTITY;
    PCOAUTHIDENTITY = ^TCOAUTHIDENTITY;


    _COAUTHINFO = record
        dwAuthnSvc: DWORD;
        dwAuthzSvc: DWORD;
        pwszServerPrincName: LPWSTR;
        dwAuthnLevel: DWORD;
        dwImpersonationLevel: DWORD;
        pAuthIdentityData: PCOAUTHIDENTITY;
        dwCapabilities: DWORD;
    end;
    TCOAUTHINFO = _COAUTHINFO;
    PCOAUTHINFO = ^TCOAUTHINFO;


    TSCODE = LONG;

    PPSCODE = ^TSCODE;


    THRESULT = LONG;



    _OBJECTID = record
        Lineage: TGUID;
        Uniquifier: ULONG;
    end;
    TOBJECTID = _OBJECTID;
    POBJECTID = ^TOBJECTID;



    REFGUID = ^TGUID;

    REFIID = ^TIID;

    REFCLSID = ^TCLSID;



    tagMEMCTX = (
        MEMCTX_TASK = 1,
        MEMCTX_SHARED = 2,
        MEMCTX_MACSYSTEM = 3,
        MEMCTX_UNKNOWN = -1,
        MEMCTX_SAME = -2);

    TMEMCTX = tagMEMCTX;
    PMEMCTX = ^TMEMCTX;



    tagCLSCTX = (
        CLSCTX_INPROC_SERVER = $1,
        CLSCTX_INPROC_HANDLER = $2,
        CLSCTX_LOCAL_SERVER = $4,
        CLSCTX_INPROC_SERVER16 = $8,
        CLSCTX_REMOTE_SERVER = $10,
        CLSCTX_INPROC_HANDLER16 = $20,
        CLSCTX_RESERVED1 = $40,
        CLSCTX_RESERVED2 = $80,
        CLSCTX_RESERVED3 = $100,
        CLSCTX_RESERVED4 = $200,
        CLSCTX_NO_CODE_DOWNLOAD = $400,
        CLSCTX_RESERVED5 = $800,
        CLSCTX_NO_CUSTOM_MARSHAL = $1000,
        CLSCTX_ENABLE_CODE_DOWNLOAD = $2000,
        CLSCTX_NO_FAILURE_LOG = $4000,
        CLSCTX_DISABLE_AAA = $8000,
        CLSCTX_ENABLE_AAA = $10000,
        CLSCTX_FROM_DEFAULT_CONTEXT = $20000,
        CLSCTX_ACTIVATE_X86_SERVER = $40000,
        CLSCTX_ACTIVATE_32_BIT_SERVER = CLSCTX_ACTIVATE_X86_SERVER,
        CLSCTX_ACTIVATE_64_BIT_SERVER = $80000,
        CLSCTX_ENABLE_CLOAKING = $100000,
        CLSCTX_APPCONTAINER = $400000,
        CLSCTX_ACTIVATE_AAA_AS_IU = $800000,
        CLSCTX_RESERVED6 = $1000000,
        CLSCTX_ACTIVATE_ARM32_SERVER = $2000000,
        CLSCTX_ALLOW_LOWER_TRUST_REGISTRATION = $4000000,
        CLSCTX_SERVER_MUST_BE_EQUAL_OR_GREATER_PRIVILEGE = $8000000,
        CLSCTX_DO_NOT_ELEVATE_SERVER = $10000000,
        CLSCTX_PS_DLL = longint($80000000));

    TCLSCTX = tagCLSCTX;
    PCLSCTX = ^TCLSCTX;



    tagMSHLFLAGS = (
        MSHLFLAGS_NORMAL = 0,
        MSHLFLAGS_TABLESTRONG = 1,
        MSHLFLAGS_TABLEWEAK = 2,
        MSHLFLAGS_NOPING = 4,
        MSHLFLAGS_RESERVED1 = 8,
        MSHLFLAGS_RESERVED2 = 16,
        MSHLFLAGS_RESERVED3 = 32,
        MSHLFLAGS_RESERVED4 = 64);

    TMSHLFLAGS = tagMSHLFLAGS;
    PMSHLFLAGS = ^TMSHLFLAGS;


    tagMSHCTX = (
        MSHCTX_LOCAL = 0,
        MSHCTX_NOSHAREDMEM = 1,
        MSHCTX_DIFFERENTMACHINE = 2,
        MSHCTX_INPROC = 3,
        MSHCTX_CROSSCTX = 4,
        MSHCTX_CONTAINER = 5);

    TMSHCTX = tagMSHCTX;
    PMSHCTX = ^TMSHCTX;


    _BYTE_BLOB = record
        clSize: ULONG; (* [size_is] *)
        abData: array [0..1 - 1] of byte;
    end;
    TBYTE_BLOB = _BYTE_BLOB;
    PBYTE_BLOB = ^TBYTE_BLOB;


    PUP_BYTE_BLOB = ^TBYTE_BLOB;

    _WORD_BLOB = record
        clSize: ULONG; (* [size_is] *)
        asData: array [0..0] of word;
    end;
    TWORD_BLOB = _WORD_BLOB;
    PWORD_BLOB = ^TWORD_BLOB;


    PUP_WORD_BLOB = ^TWORD_BLOB;

    _DWORD_BLOB = record
        clSize: ULONG; (* [size_is] *)
        alData: array [0..0] of ULONG;
    end;
    TDWORD_BLOB = _DWORD_BLOB;
    PDWORD_BLOB = ^TDWORD_BLOB;


    PUP_DWORD_BLOB = ^TDWORD_BLOB;

    _FLAGGED_BYTE_BLOB = record
        fFlags: ULONG;
        clSize: ULONG; (* [size_is] *)
        abData: array [0..0] of byte;
    end;
    TFLAGGED_BYTE_BLOB = _FLAGGED_BYTE_BLOB;
    PFLAGGED_BYTE_BLOB = ^TFLAGGED_BYTE_BLOB;


    PUP_FLAGGED_BYTE_BLOB = ^TFLAGGED_BYTE_BLOB;

    _FLAGGED_WORD_BLOB = record
        fFlags: ULONG;
        clSize: ULONG; (* [size_is] *)
        asData: array [0..0] of word;
    end;
    TFLAGGED_WORD_BLOB = _FLAGGED_WORD_BLOB;
    PFLAGGED_WORD_BLOB = ^TFLAGGED_WORD_BLOB;


    PUP_FLAGGED_WORD_BLOB = ^TFLAGGED_WORD_BLOB;

    _BYTE_SIZEDARR = record
        clSize: ULONG; (* [size_is] *)
        pData: pbyte;
    end;
    TBYTE_SIZEDARR = _BYTE_SIZEDARR;
    PBYTE_SIZEDARR = ^TBYTE_SIZEDARR;


    _SHORT_SIZEDARR = record
        clSize: ULONG; (* [size_is] *)
        pData: PWORD;
    end;
    TSHORT_SIZEDARR = _SHORT_SIZEDARR;
    PSHORT_SIZEDARR = ^TSHORT_SIZEDARR;

    TWORD_SIZEDARR = TSHORT_SIZEDARR;

    _LONG_SIZEDARR = record
        clSize: ULONG; (* [size_is] *)
        pData: PULONG;
    end;
    TLONG_SIZEDARR = _LONG_SIZEDARR;
    PLONG_SIZEDARR = ^TLONG_SIZEDARR;

    TDWORD_SIZEDARR = TLONG_SIZEDARR;

    _HYPER_SIZEDARR = record
        clSize: ULONG; (* [size_is] *)
        pData: Phyper;
    end;
    THYPER_SIZEDARR = _HYPER_SIZEDARR;
    PHYPER_SIZEDARR = ^THYPER_SIZEDARR;



    tagBLOB = record
        cbSize: ULONG; (* [size_is] *)
        pBlobData: pbyte;
    end;
    TBLOB = tagBLOB;
    PBLOB = ^TBLOB;
    LPBLOB = ^TBLOB;


    _SID_IDENTIFIER_AUTHORITY = record
        Value: array [0..6 - 1] of UCHAR;
    end;
    TSID_IDENTIFIER_AUTHORITY = _SID_IDENTIFIER_AUTHORITY;
    PSID_IDENTIFIER_AUTHORITY = ^TSID_IDENTIFIER_AUTHORITY;


    _SID = record
        Revision: TBYTE;
        SubAuthorityCount: TBYTE;
        IdentifierAuthority: TSID_IDENTIFIER_AUTHORITY; (* [size_is] *)
        SubAuthority: array [0..0] of ULONG;
    end;
    TSID = _SID;
    PSID = ^TSID;

    _SID_AND_ATTRIBUTES = record
        Sid: PSID;
        Attributes: DWORD;
    end;
    TSID_AND_ATTRIBUTES = _SID_AND_ATTRIBUTES;
    PSID_AND_ATTRIBUTES = ^TSID_AND_ATTRIBUTES;



const

    CLSCTX_VALID_MASK =
        Ord(CLSCTX_INPROC_SERVER) or Ord(CLSCTX_INPROC_HANDLER) or Ord(CLSCTX_LOCAL_SERVER) or Ord(CLSCTX_INPROC_SERVER16) or Ord(CLSCTX_REMOTE_SERVER) or Ord(CLSCTX_NO_CODE_DOWNLOAD) or
        Ord(CLSCTX_NO_CUSTOM_MARSHAL) or Ord(CLSCTX_ENABLE_CODE_DOWNLOAD) or Ord(CLSCTX_NO_FAILURE_LOG) or Ord(CLSCTX_DISABLE_AAA) or Ord(CLSCTX_ENABLE_AAA) or Ord(CLSCTX_FROM_DEFAULT_CONTEXT) or
        Ord(CLSCTX_ACTIVATE_X86_SERVER) or Ord(CLSCTX_ACTIVATE_64_BIT_SERVER) or Ord(CLSCTX_ENABLE_CLOAKING) or Ord(CLSCTX_APPCONTAINER) or Ord(CLSCTX_ACTIVATE_AAA_AS_IU) or Ord(CLSCTX_RESERVED6) or
        Ord(CLSCTX_ACTIVATE_ARM32_SERVER) or Ord(CLSCTX_ALLOW_LOWER_TRUST_REGISTRATION) or Ord(CLSCTX_DO_NOT_ELEVATE_SERVER) or Ord(CLSCTX_SERVER_MUST_BE_EQUAL_OR_GREATER_PRIVILEGE) or Ord(CLSCTX_PS_DLL);



implementation

end.
