{ **************************************************************************
    FreePascal/Delphi Win32 Header Files

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

   Microsoft Windows
   Copyright (c) Microsoft Corporation. All rights reserved.
   Contents:   Base Component Object Model defintions.

   This unit consists of the following header files
   File name: combaseapi.h
   Header version: 10.0.26100.6584

  ************************************************************************** }


unit Win32.COMBaseAPI;

{$mode Delphi}

interface

uses
    Windows, Classes, SysUtils,
    Win32.ObjIdl,
    ActiveX;

const
    OLE32_DLL = 'Ole32.dll';

    //TODO version number should be bumped when _APISET_TARGET_VERSION_WIN10_RS2 becomes available

    CLSCTX_INPROC = (CLSCTX_INPROC_SERVER or CLSCTX_INPROC_HANDLER);


    // With DCOM, CLSCTX_REMOTE_SERVER should be included
    // DCOM
    CLSCTX_ALL = (CLSCTX_INPROC_SERVER or CLSCTX_INPROC_HANDLER or CLSCTX_LOCAL_SERVER or CLSCTX_REMOTE_SERVER);
    CLSCTX_SERVER = (CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER or CLSCTX_REMOTE_SERVER);


    COM_RIGHTS_EXECUTE = 1;
    COM_RIGHTS_EXECUTE_LOCAL = 2;
    COM_RIGHTS_EXECUTE_REMOTE = 4;
    COM_RIGHTS_ACTIVATE_LOCAL = 8;
    COM_RIGHTS_ACTIVATE_REMOTE = 16;
    COM_RIGHTS_RESERVED1 = 32;
    COM_RIGHTS_RESERVED2 = 64;


    CWMO_MAX_HANDLES = 56;

type


    (****** Interface Declaration ***********************************************)
(*
 *      These are macros for declaring interfaces.  They exist so that
 *      a single definition of the interface is simulataneously a proper
 *      declaration of the interface structures (C++ abstract classes)
 *      for both C and C++.
 *
 *      DECLARE_INTERFACE(iface) is used to declare an interface that does
 *      not derive from a base interface.
 *      DECLARE_INTERFACE_(iface, baseiface) is used to declare an interface
 *      that does derive from a base interface.
 *
 *      By default if the source file has a .c extension the C version of
 *      the interface declaratations will be expanded; if it has a .cpp
 *      extension the C++ version will be expanded. if you want to force
 *      the C version expansion even though the source file has a .cpp
 *      extension, then define the macro "CINTERFACE".
 *      eg.     cl -DCINTERFACE file.cpp
 *
 *      Example Interface declaration:
 *
 *          #undef  INTERFACE
 *          #define INTERFACE   IClassFactory
 *
 *          DECLARE_INTERFACE_(IClassFactory, IUnknown)
 *          {
 *              // *** IUnknown methods ***
 *              STDMETHOD(QueryInterface) (THIS_
 *                                        REFIID riid,
 *                                        LPVOID FAR* ppvObj) PURE;
 *              STDMETHOD_(ULONG,AddRef) (THIS) PURE;
 *              STDMETHOD_(ULONG,Release) (THIS) PURE;
 *
 *              // *** IClassFactory methods ***
 *              STDMETHOD(CreateInstance) (THIS_
 *                                        LPUNKNOWN pUnkOuter,
 *                                        REFIID riid,
 *                                        LPVOID FAR* ppvObject) PURE;
 *          };
 *
 *      Example C++ expansion:
 *
 *          struct FAR IClassFactory : public IUnknown
 *          {
 *              virtual HRESULT STDMETHODCALLTYPE QueryInterface(
 *                                                  IID FAR& riid,
 *                                                  LPVOID FAR* ppvObj) = 0;
 *              virtual HRESULT STDMETHODCALLTYPE AddRef(void) = 0;
 *              virtual HRESULT STDMETHODCALLTYPE Release(void) = 0;
 *              virtual HRESULT STDMETHODCALLTYPE CreateInstance(
 *                                              LPUNKNOWN pUnkOuter,
 *                                              IID FAR& riid,
 *                                              LPVOID FAR* ppvObject) = 0;
 *          };
 *
 *          NOTE: Our documentation says '#define interface class' but we use
 *          'struct' instead of 'class' to keep a lot of 'public:' lines
 *          out of the interfaces.  The 'FAR' forces the 'this' pointers to
 *          be far, which is what we need.
 *
 *      Example C expansion:
 *
 *          typedef struct IClassFactory
 *          {
 *              const struct IClassFactoryVtbl FAR* lpVtbl;
 *          } IClassFactory;
 *
 *          typedef struct IClassFactoryVtbl IClassFactoryVtbl;
 *
 *          struct IClassFactoryVtbl
 *          {
 *              HRESULT (STDMETHODCALLTYPE * QueryInterface) (
 *                                                  IClassFactory FAR* This,
 *                                                  IID FAR* riid,
 *                                                  LPVOID FAR* ppvObj) ;
 *              HRESULT (STDMETHODCALLTYPE * AddRef) (IClassFactory FAR* This) ;
 *              HRESULT (STDMETHODCALLTYPE * Release) (IClassFactory FAR* This) ;
 *              HRESULT (STDMETHODCALLTYPE * CreateInstance) (
 *                                                  IClassFactory FAR* This,
 *                                                  LPUNKNOWN pUnkOuter,
 *                                                  IID FAR* riid,
 *                                                  LPVOID FAR* ppvObject);
 *              HRESULT (STDMETHODCALLTYPE * LockServer) (
 *                                                  IClassFactory FAR* This,
 *                                                  BOOL fLock);
 *          };
 *)




    // class registration flags; passed to CoRegisterClassObject
    tagREGCLS = (
        REGCLS_SINGLEUSE = 0, // class object only generates one instance
        REGCLS_MULTIPLEUSE = 1, // same class object genereates multiple inst.
        // and local automatically goes into inproc tbl.
        REGCLS_MULTI_SEPARATE = 2, // multiple use, but separate control over each
        // context.
        REGCLS_SUSPENDED = 4, // register is as suspended, will be activated
        // when app calls CoResumeClassObjects
        REGCLS_SURROGATE = 8, // must be used when a surrogate process
        // is registering a class object that will be
        // loaded in the surrogate
        REGCLS_AGILE = $10// Class object aggregates the free-threaded marshaler
        // and will be made visible to all inproc apartments.
        // Can be used together with other flags - for example,
        // REGCLS_AGILE | REGCLS_MULTIPLEUSE to register a
        // class object that can be used multiple times from
        // different apartments. Without other flags, behavior
        // will retain REGCLS_SINGLEUSE semantics in that only
        // one instance can be generated.
        );

    TREGCLS = tagREGCLS;
    PREGCLS = ^TREGCLS;




    (* here is where we pull in the MIDL generated headers for the interfaces *)

    //    IRpcStubBuffer = interface;
    //    IRpcChannelBuffer = interface;


    // COM initialization flags; passed to CoInitialize.
    tagCOINITBASE = (
        // DCOM
        // These constants are only valid on Windows NT 4.0
        COINITBASE_MULTITHREADED = $0// OLE calls objects on any thread.
        );

    TCOINITBASE = tagCOINITBASE;
    PCOINITBASE = ^TCOINITBASE;


    {$PACKRECORDS 8}

    tagServerInformation = record
        dwServerPid: DWORD;
        dwServerTid: DWORD;
        ui64ServerAddress: uint64;
    end;
    TServerInformation = tagServerInformation;
    PServerInformation = ^TServerInformation;

    CO_MTA_USAGE_COOKIE = HANDLE;
    TCO_MTA_USAGE_COOKIE = CO_MTA_USAGE_COOKIE;
    PCO_MTA_USAGE_COOKIE = ^CO_MTA_USAGE_COOKIE;




    (* flags for CoGetStdMarshalEx *)
    tagSTDMSHLFLAGS = (
        SMEXF_SERVER = $01, // server side aggregated std marshaler
        SMEXF_HANDLER = $02// client side (handler) agg std marshaler
        );

    TSTDMSHLFLAGS = tagSTDMSHLFLAGS;
    PSTDMSHLFLAGS = ^TSTDMSHLFLAGS;



    (* Flags for Synchronization API and Classes *)

    tagCOWAIT_FLAGS = (
        COWAIT_DEFAULT = 0,
        COWAIT_WAITALL = 1,
        COWAIT_ALERTABLE = 2,
        COWAIT_INPUTAVAILABLE = 4,
        COWAIT_DISPATCH_CALLS = 8,
        COWAIT_DISPATCH_WINDOW_MESSAGES = $10);

    TCOWAIT_FLAGS = tagCOWAIT_FLAGS;
    PCOWAIT_FLAGS = ^TCOWAIT_FLAGS;




    TCWMO_FLAGS = (
        CWMO_DEFAULT = 0,
        CWMO_DISPATCH_CALLS = 1,
        CWMO_DISPATCH_WINDOW_MESSAGES = 2);

    PCWMO_FLAGS = ^TCWMO_FLAGS;

    //if (NTDDI_VERSION >= NTDDI_WINBLUE)

    TAgileReferenceOptions = (
        AGILEREFERENCE_DEFAULT = 0,
        AGILEREFERENCE_DELAYEDMARSHAL = 1);

    PAgileReferenceOptions = ^TAgileReferenceOptions;


(* the server dlls must define their DllGetClassObject and DllCanUnloadNow
 * to match these; the typedefs are located here to ensure all are changed at
 * the same time.
 *)
    LPFNGETCLASSOBJECT = function(
        {in} rclsid: REFCLSID;
        {in} riid: REFIID;
        {out} ppv: LPVOID): HRESULT; stdcall;

    LPFNCANUNLOADNOW = function(): HRESULT; stdcall;

    CO_DEVICE_CATALOG_COOKIE = HANDLE;
    TCO_DEVICE_CATALOG_COOKIE = CO_DEVICE_CATALOG_COOKIE;
    PCO_DEVICE_CATALOG_COOKIE = ^TCO_DEVICE_CATALOG_COOKIE;

    {$PACKRECORDS DEFAULT}

    (****** STD Object API Prototypes *****************************************)

    PLPMALLOC = ^IMalloc;
    PLPSTREAM = ^IStream;
    PHGLOBAL = ^HGLOBAL;
    PIMARSHAL = ^IMarshal;
    PIUNKNOWN = ^IUnknown;
    LPIID = ^IID;
    REFIID = ^TGUID;

    RPC_AUTH_IDENTITY_HANDLE = pointer;
    PRPC_AUTH_IDENTITY_HANDLE = ^RPC_AUTH_IDENTITY_HANDLE;

    RPC_AUTHZ_HANDLE = pointer;
    PRPC_AUTHZ_HANDLE = ^RPC_AUTHZ_HANDLE;

function CoGetMalloc(
    {_In_ } dwMemContext: DWORD;
    {_Outptr_ } ppMalloc: PLPMALLOC): HRESULT; stdcall; external OLE32_DLL;



function CreateStreamOnHGlobal(hGlobal: HGLOBAL;
    {_In_ } fDeleteOnRelease: boolean;
    {_Outptr_ } ppstm: PLPSTREAM): HRESULT; stdcall; external OLE32_DLL;


function GetHGlobalFromStream(
    {_In_ } pstm: ISTREAM;
    {_Out_ } phglobal: PHGLOBAL): HRESULT; stdcall; external OLE32_DLL;




procedure CoUninitialize(); stdcall; external OLE32_DLL;



function CoGetCurrentProcess(): DWORD; stdcall; external OLE32_DLL;


// DCOM

function CoInitializeEx(
    {_In_opt_ } pvReserved: LPVOID;
    {_In_ } dwCoInit: DWORD): HRESULT; stdcall; external OLE32_DLL;



function CoGetCallerTID(
    {_Out_ } lpdwTID: LPDWORD): HRESULT; stdcall; external OLE32_DLL;



function CoGetCurrentLogicalThreadId(
    {_Out_ } pguid: PGUID): HRESULT; stdcall; external OLE32_DLL;



//#endif // DCOM


function CoGetContextToken(
    {_Out_ } pToken: PULONG_PTR): HRESULT; stdcall; external OLE32_DLL;



function CoGetDefaultContext(
    {_In_ } aptType: TAPTTYPE;
    {_In_ } riid: REFIID;
    {_Outptr_ }  out ppv): HRESULT; stdcall; external OLE32_DLL;



// definition for Win7 new APIs



function CoGetApartmentType(
    {_Out_ } pAptType: PAPTTYPE;
    {_Out_ } pAptQualifier: PAPTTYPEQUALIFIER): HRESULT; stdcall; external OLE32_DLL;



// definition for Win8 new APIs


function CoDecodeProxy(
    {_In_ } dwClientPid: DWORD;
    {_In_ } ui64ProxyAddress: uint64;
    {_Out_ } pServerInformation: PServerInformation): HRESULT; stdcall; external OLE32_DLL;




function CoIncrementMTAUsage(
    {_Out_ } pCookie: PCO_MTA_USAGE_COOKIE): HRESULT; stdcall; external OLE32_DLL;


function CoDecrementMTAUsage(
    {_In_ } Cookie: TCO_MTA_USAGE_COOKIE): HRESULT; stdcall; external OLE32_DLL;



function CoAllowUnmarshalerCLSID(
    {_In_ } clsid: REFCLSID): HRESULT; stdcall; external OLE32_DLL;



function CoGetObjectContext(
    {_In_ } riid: REFIID;
    {_Outptr_ } ppv: LPVOID): HRESULT; stdcall; external OLE32_DLL;




(* register/revoke/get class objects *)

function CoGetClassObject(
    {_In_ } rclsid: REFCLSID;
    {_In_ } dwClsContext: DWORD;
    {_In_opt_ } pvReserved: LPVOID;
    {_In_ } riid: REFIID;
    {_Outptr_ } ppv: LPVOID): HRESULT; stdcall; external OLE32_DLL;




function CoRegisterClassObject(
    {_In_ } rclsid: REFCLSID;
    {_In_ } pUnk: IUnknown;
    {_In_ } dwClsContext: DWORD;
    {_In_ } flags: DWORD;
    {_Out_ } lpdwRegister: LPDWORD): HRESULT; stdcall; external OLE32_DLL;


function CoRevokeClassObject(
    {_In_ } dwRegister: DWORD): HRESULT; stdcall; external OLE32_DLL;


function CoResumeClassObjects(): HRESULT; stdcall; external OLE32_DLL;


function CoSuspendClassObjects(): HRESULT; stdcall; external OLE32_DLL;



function CoAddRefServerProcess(): ULONG; stdcall; external OLE32_DLL;


function CoReleaseServerProcess(): ULONG; stdcall; external OLE32_DLL;


function CoGetPSClsid(
    {_In_ } riid: REFIID;
    {_Out_ } pClsid: PCLSID): HRESULT; stdcall; external OLE32_DLL;


function CoRegisterPSClsid(
    {_In_ } riid: REFIID;
    {_In_ } rclsid: REFCLSID): HRESULT; stdcall; external OLE32_DLL;


// Registering surrogate processes
function CoRegisterSurrogate(
    {_In_ } pSurrogate: LPSURROGATE): HRESULT; stdcall; external OLE32_DLL;



(* marshaling interface pointers *)

function CoGetMarshalSizeMax(
    {_Out_ } pulSize: PULONG;
    {_In_ } riid: REFIID;
    {_In_ } pUnk: IUnknown;
    {_In_ } dwDestContext: DWORD;
    {_In_opt_ } pvDestContext: LPVOID;
    {_In_ } mshlflags: DWORD): HRESULT; stdcall; external OLE32_DLL;


function CoMarshalInterface(
    {_In_ } pStm: ISTREAM;
    {_In_ } riid: REFIID;
    {_In_ } pUnk: IUnknown;
    {_In_ } dwDestContext: DWORD;
    {_In_opt_ } pvDestContext: LPVOID;
    {_In_ } mshlflags: DWORD): HRESULT; stdcall; external OLE32_DLL;


function CoUnmarshalInterface(
    {_In_ } pStm: ISTREAM;
    {_In_ } riid: REFIID;
    {_COM_Outptr_ } ppv: LPVOID): HRESULT; stdcall; external OLE32_DLL;



function CoMarshalHresult(
    {_In_ } pstm: ISTREAM;
    {_In_ } hresult: HRESULT): HRESULT; stdcall; external OLE32_DLL;


function CoUnmarshalHresult(
    {_In_ } pstm: ISTREAM;
    {_Out_ } phresult: PHRESULT): HRESULT; stdcall; external OLE32_DLL;




function CoReleaseMarshalData(
    {_In_ } pStm: ISTREAM): HRESULT; stdcall; external OLE32_DLL;


function CoDisconnectObject(
    {_In_ } pUnk: IUnknown;
    {_In_ } dwReserved: DWORD): HRESULT; stdcall; external OLE32_DLL;




function CoLockObjectExternal(
    {_In_ } pUnk: IUnknown;
    {_In_ } fLock: boolean;
    {_In_ } fLastUnlockReleases: boolean): HRESULT; stdcall; external OLE32_DLL;




function CoGetStandardMarshal(
    {_In_ } riid: REFIID;
    {_In_opt_ } pUnk: IUnknown;
    {_In_ } dwDestContext: DWORD;
    {_In_opt_ } pvDestContext: LPVOID;
    {_In_ } mshlflags: DWORD;
    {_Outptr_ } ppMarshal: PIMARSHAL): HRESULT; stdcall; external OLE32_DLL;




function CoGetStdMarshalEx(
    {_In_ } pUnkOuter: IUnknown;
    {_In_ } smexflags: DWORD;
    {_Outptr_ } ppUnkInner: PIUNKNOWN): HRESULT; stdcall; external OLE32_DLL;




function CoIsHandlerConnected(
    {_In_ } pUnk: IUnknown): boolean; stdcall; external OLE32_DLL;




// Apartment model inter-thread interface passing helpers
function CoMarshalInterThreadInterfaceInStream(
    {_In_ } riid: REFIID;
    {_In_ } pUnk: IUnknown;
    {_Outptr_ } ppStm: PLPSTREAM): HRESULT; stdcall; external OLE32_DLL;


function CoGetInterfaceAndReleaseStream(
    {_In_ } pStm: ISTREAM;
    {_In_ } iid: REFIID;
    {_COM_Outptr_ } ppv: LPVOID): HRESULT; stdcall; external OLE32_DLL;




function CoCreateFreeThreadedMarshaler(
    {_In_opt_ } punkOuter: IUnknown;
    {_Outptr_ } ppunkMarshal: PIUnknown): HRESULT; stdcall; external OLE32_DLL;




procedure CoFreeUnusedLibraries(); stdcall; external OLE32_DLL;



procedure CoFreeUnusedLibrariesEx(
    {_In_ } dwUnloadDelay: DWORD;
    {_In_ } dwReserved: DWORD); stdcall; external OLE32_DLL;




function CoDisconnectContext(dwTimeout: DWORD): HRESULT; stdcall; external OLE32_DLL;




// DCOM
(* Call Security. *)



function CoInitializeSecurity(
    {_In_opt_ } pSecDesc: PSECURITY_DESCRIPTOR;
    {_In_ } cAuthSvc: LONG;
    {_In_reads_opt_(cAuthSvc) } asAuthSvc: PSOLE_AUTHENTICATION_SERVICE;
    {_In_opt_ } pReserved1: Pvoid;
    {_In_ } dwAuthnLevel: DWORD;
    {_In_ } dwImpLevel: DWORD;
    {_In_opt_ } pAuthList: Pvoid;
    {_In_ } dwCapabilities: DWORD;
    {_In_opt_ } pReserved3: Pvoid): HRESULT; stdcall; external OLE32_DLL;




function CoGetCallContext(
    {_In_ } riid: REFIID;
    {_Outptr_ }  out ppInterface): HRESULT; stdcall; external OLE32_DLL;


function CoQueryProxyBlanket(
    {_In_ } pProxy: IUnknown;
    {_Out_opt_ } pwAuthnSvc: PDWORD;
    {_Out_opt_ } pAuthzSvc: PDWORD;
    {_Outptr_opt_ } pServerPrincName: PLPOLESTR;
    {_Out_opt_ } pAuthnLevel: PDWORD;
    {_Out_opt_ } pImpLevel: PDWORD;
    {_Out_opt_ } pAuthInfo: PRPC_AUTH_IDENTITY_HANDLE;
    {_Out_opt_ } pCapabilites: PDWORD): HRESULT; stdcall; external OLE32_DLL;


function CoSetProxyBlanket(
    {_In_ } pProxy: IUnknown;
    {_In_ } dwAuthnSvc: DWORD;
    {_In_ } dwAuthzSvc: DWORD;
    {_In_opt_ } pServerPrincName: POLECHAR;
    {_In_ } dwAuthnLevel: DWORD;
    {_In_ } dwImpLevel: DWORD;
    {_In_opt_ } pAuthInfo: RPC_AUTH_IDENTITY_HANDLE;
    {_In_ } dwCapabilities: DWORD): HRESULT; stdcall; external OLE32_DLL;


function CoCopyProxy(
    {_In_ } pProxy: IUnknown;
    {_Outptr_ }  out ppCopy: IUnknown): HRESULT; stdcall; external OLE32_DLL;


function CoQueryClientBlanket(
    {_Out_opt_ } pAuthnSvc: PDWORD;
    {_Out_opt_ } pAuthzSvc: PDWORD;
    {_Outptr_opt_ } pServerPrincName: PLPOLESTR;
    {_Out_opt_ } pAuthnLevel: PDWORD;
    {_Out_opt_ } pImpLevel: PDWORD;
    {_Outptr_opt_result_buffer_(_Inexpressible_("depends on pAuthnSvc")) } pPrivs: PRPC_AUTHZ_HANDLE;
    {_Inout_opt_ } pCapabilities: PDWORD): HRESULT; stdcall; external OLE32_DLL;


function CoImpersonateClient(): HRESULT; stdcall; external OLE32_DLL;


function CoRevertToSelf(): HRESULT; stdcall; external OLE32_DLL;


function CoQueryAuthenticationServices(
    {_Out_ } pcAuthSvc: PDWORD;
    {_Outptr_result_buffer_(*pcAuthSvc) }  out asAuthSvc: PSOLE_AUTHENTICATION_SERVICE): HRESULT; stdcall; external OLE32_DLL;




function CoSwitchCallContext(
    {_In_opt_ } pNewObject: IUnknown;
    {_Outptr_ }  out ppOldObject: IUnknown): HRESULT; stdcall; external OLE32_DLL;


(* helper for creating instances *)

function CoCreateInstance(
    {_In_ } rclsid: REFCLSID;
    {_In_opt_ } pUnkOuter: IUnknown;
    {_In_ } dwClsContext: DWORD;
    {_In_ } riid: REFIID;
    {_COM_Outptr_ _At_(*ppv, _Post_readable_size_(_Inexpressible_(varies)))} out ppv): HRESULT; stdcall; external OLE32_DLL;




// DCOM

function CoCreateInstanceEx(
    {_In_ } Clsid: REFCLSID;
    {_In_opt_ } punkOuter: IUnknown;
    {_In_ } dwClsCtx: DWORD;
    {_In_opt_ } pServerInfo: PCOSERVERINFO;
    {_In_ } dwCount: DWORD;
    {_Inout_updates_(dwCount) } pResults: PMULTI_QI): HRESULT; stdcall; external OLE32_DLL;


//#endif // DCOM



function CoCreateInstanceFromApp(
    {_In_ } Clsid: REFCLSID;
    {_In_opt_ } punkOuter: IUnknown;
    {_In_ } dwClsCtx: DWORD;
    {_In_opt_ } reserved: PVOID;
    {_In_ } dwCount: DWORD;
    {_Inout_updates_(dwCount) } pResults: PMULTI_QI): HRESULT; stdcall; external OLE32_DLL;




function CoRegisterActivationFilter(
    {_In_ } pActivationFilter: IActivationFilter): HRESULT; stdcall; external OLE32_DLL;




(* Call related APIs *)
// DCOM



function CoGetCancelObject(
    {_In_ } dwThreadId: DWORD;
    {_In_ } iid: REFIID;
    {_Outptr_ }  out ppUnk): HRESULT; stdcall; external OLE32_DLL;


function CoSetCancelObject(
    {_In_opt_ } pUnk: IUnknown): HRESULT; stdcall; external OLE32_DLL;


function CoCancelCall(
    {_In_ } dwThreadId: DWORD;
    {_In_ } ulTimeout: ULONG): HRESULT; stdcall; external OLE32_DLL;


function CoTestCancel(): HRESULT; stdcall; external OLE32_DLL;


function CoEnableCallCancellation(
    {_In_opt_ } pReserved: LPVOID): HRESULT; stdcall; external OLE32_DLL;


function CoDisableCallCancellation(
    {_In_opt_ } pReserved: LPVOID): HRESULT; stdcall; external OLE32_DLL;



(* other helpers *)

function StringFromCLSID(
    {_In_ } rclsid: REFCLSID;
    {_Outptr_ } lplpsz: PLPOLESTR): HRESULT; stdcall; external OLE32_DLL;


function CLSIDFromString(
    {_In_ } lpsz: LPCOLESTR;
    {_Out_ } pclsid: LPCLSID): HRESULT; stdcall; external OLE32_DLL;


function StringFromIID(
    {_In_ } rclsid: REFIID;
    {_Outptr_ } lplpsz: PLPOLESTR): HRESULT; stdcall; external OLE32_DLL;


function IIDFromString(
    {_In_ } lpsz: LPCOLESTR;
    {_Out_ } lpiid: LPIID): HRESULT; stdcall; external OLE32_DLL;




function ProgIDFromCLSID(
    {_In_ } clsid: REFCLSID;
    {_Outptr_ } lplpszProgID: PLPOLESTR): HRESULT; stdcall; external OLE32_DLL;


function CLSIDFromProgID(
    {_In_ } lpszProgID: LPCOLESTR;
    {_Out_ } lpclsid: LPCLSID): HRESULT; stdcall; external OLE32_DLL;




function StringFromGUID2(
    {_In_ } rguid: REFGUID;
    {_Out_writes_to_(cchMax, return) } lpsz: LPOLESTR;
    {_In_ } cchMax: int32): int32; stdcall; external OLE32_DLL;


function CoCreateGuid(
    {_Out_ } pguid: PGUID): HRESULT; stdcall; external OLE32_DLL;

(* Prop variant support *)



function PropVariantCopy(
    {_Out_ } pvarDest: PPROPVARIANT;
    {_In_ } pvarSrc: PPROPVARIANT): HRESULT; stdcall; external OLE32_DLL;



function PropVariantClear(
    {_Inout_ } pvar: PPROPVARIANT): HRESULT; stdcall; external OLE32_DLL;


function FreePropVariantArray(
    {_In_ } cVariants: ULONG;
    {_Inout_updates_(cVariants) } rgvars: PPROPVARIANT): HRESULT; stdcall; external OLE32_DLL;




// DCOM
(* Synchronization API *)




function CoWaitForMultipleHandles(
    {_In_ } dwFlags: DWORD;
    {_In_ } dwTimeout: DWORD;
    {_In_ } cHandles: ULONG;
    {_In_reads_(cHandles) } pHandles: LPHANDLE;
    {_Out_ } lpdwindex: LPDWORD): HRESULT; stdcall; external OLE32_DLL;




function CoWaitForMultipleObjects(
    {_In_ } dwFlags: DWORD;
    {_In_ } dwTimeout: DWORD;
    {_In_ } cHandles: ULONG;
    {_In_reads_(cHandles) } pHandles: PHANDLE;
    {_Out_ } lpdwindex: LPDWORD): HRESULT; stdcall; external OLE32_DLL;




function CoGetTreatAsClass(
    {_In_ } clsidOld: REFCLSID;
    {_Out_ } pClsidNew: LPCLSID): HRESULT; stdcall; external OLE32_DLL;



(* for flushing OLESCM remote binding handles *)



function CoInvalidateRemoteMachineBindings(
    {_In_ } pszMachineName: LPOLESTR): HRESULT; stdcall; external OLE32_DLL;



//if (NTDDI_VERSION >= NTDDI_WINBLUE)

function RoGetAgileReference(
    {_In_ } options: TAgileReferenceOptions;
    {_In_ } riid: REFIID;
    {_In_ } pUnk: IUnknown;
    {_COM_Outptr_ }  out ppAgileReference: IAgileReference): HRESULT; stdcall; external OLE32_DLL;



(* OLE does not provide this function.
DLLs that support the OLE Component Object Model (COM) must implement DllGetClassObject in OLE object handlers or DLL applications.
*)
(*
function DllGetClassObject(
{_In_ } rclsid : REFCLSID ;
{_In_ } riid : REFIID ;
{_Outptr_ } ppv : LPVOID
    ) : HRESULT;stdcall;

function DllCanUnloadNow() : HRESULT;stdcall;
*)


(****** Default Memory Allocation ******************************************)
function CoTaskMemAlloc(
    {_In_ } cb: SIZE_T): LPVOID; stdcall; external OLE32_DLL;


function CoTaskMemRealloc(
    {_Pre_maybenull_ __drv_freesMem(Mem) _Post_invalid_ } pv: LPVOID;
    {_In_ } cb: SIZE_T): LPVOID; stdcall; external OLE32_DLL;


procedure CoTaskMemFree(
    {_Frees_ptr_opt_}  pv: LPVOID); stdcall; external OLE32_DLL;




function CoFileTimeNow(
    {_Out_ } lpFileTime: PFILETIME): HRESULT; stdcall; external OLE32_DLL;


function CLSIDFromProgIDEx(
    {_In_ } lpszProgID: LPCOLESTR;
    {_Out_ } lpclsid: LPCLSID): HRESULT; stdcall; external OLE32_DLL;




function CoRegisterDeviceCatalog(
    {_In_ } deviceInstanceId: PCWSTR;
    {_Out_ } cookie: PCO_DEVICE_CATALOG_COOKIE): HRESULT; stdcall; external OLE32_DLL;



function CoRevokeDeviceCatalog(
    {_In_ } cookie: TCO_DEVICE_CATALOG_COOKIE): HRESULT; stdcall; external OLE32_DLL;

procedure LISet32(var li: ULARGE_INTEGER; v: long);
procedure ULISet32(var li: ULARGE_INTEGER; v: ULONG);

implementation


procedure LISet32(var li: ULARGE_INTEGER; v: LONG); inline;
begin
    if (v) < 0 then
        li.HighPart := -1
    else
        li.HighPart := 0;
    li.LowPart := v;
end;

procedure ULISet32(var li : ULARGE_INTEGER; v: ULONG); inline;
begin
    li.HighPart := 0;
    li.LowPart := v;
end;

end.
