{ **************************************************************************
    Win32 Header Files

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
   File name: ObjIdl.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit Win32.ObjIdl;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils;

const
    IID_IMarshal: TGUID = '{00000003-0000-0000-C000-000000000046}';
    IID_INoMarshal: TGUID = '{ecc8691b-c1db-4dc0-855e-65f6c551af49}';
    IID_IAgileObject: TGUID = '{94ea2b94-e9cc-49e0-c0ff-ee64ca8f5b90}';
    IID_IMalloc: TGUID = '{00000002-0000-0000-C000-000000000046}';
    IID_IInternalUnknown: TGUID = '{00000021-0000-0000-C000-000000000046}';
    IID_IActivationFilter: TGUID = '{00000017-0000-0000-C000-000000000046}';
    IID_IMarshal2: TGUID = '{000001cf-0000-0000-C000-000000000046}';
    IID_IStdMarshalInfo: TGUID = '{00000018-0000-0000-C000-000000000046}';
    IID_IExternalConnection: TGUID = '{00000019-0000-0000-C000-000000000046}';
    IID_IMultiQI: TGUID = '{00000020-0000-0000-C000-000000000046}';
    IID_AsyncIMultiQI: TGUID = '{000e0020-0000-0000-C000-000000000046}';
    IID_IEnumUnknown: TGUID = '{00000100-0000-0000-C000-000000000046}';
    IID_IEnumString: TGUID = '{00000101-0000-0000-C000-000000000046}';
    IID_ISequentialStream: TGUID = '{0c733a30-2a1c-11ce-ade5-00aa0044773d}';
    IID_IStream: TGUID = '{0000000c-0000-0000-C000-000000000046}';
    IID_IRpcChannelBuffer: TGUID = '{D5F56B60-593B-101A-B569-08002B2DBF7A}';
    IID_IRpcChannelBuffer2: TGUID = '{594f31d0-7f19-11d0-b194-00a0c90dc8bf}';
    IID_IAsyncRpcChannelBuffer: TGUID = '{a5029fb6-3c34-11d1-9c99-00c04fb998aa}';
    IID_IRpcChannelBuffer3: TGUID = '{25B15600-0115-11d0-BF0D-00AA00B8DFD2}';
    IID_IRpcSyntaxNegotiate: TGUID = '{58a08519-24c8-4935-b482-3fd823333a4f}';
    IID_IRpcProxyBuffer: TGUID = '{D5F56A34-593B-101A-B569-08002B2DBF7A}';
    IID_IRpcStubBuffer: TGUID = '{D5F56AFC-593B-101A-B569-08002B2DBF7A}';
    IID_IPSFactoryBuffer: TGUID = '{D5F569D0-593B-101A-B569-08002B2DBF7A}';
    IID_IChannelHook: TGUID = '{1008c4a0-7613-11cf-9af1-0020af6e72f4}';
    IID_IClientSecurity: TGUID = '{0000013D-0000-0000-C000-000000000046}';
    IID_IServerSecurity: TGUID = '{0000013E-0000-0000-C000-000000000046}';
    IID_IRpcOptions: TGUID = '{00000144-0000-0000-C000-000000000046}';
    IID_IGlobalOptions: TGUID = '{0000015B-0000-0000-C000-000000000046}';
    IID_ISurrogate: TGUID = '{00000022-0000-0000-C000-000000000046}';
    IID_IGlobalInterfaceTable: TGUID = '{00000146-0000-0000-C000-000000000046}';
    IID_ISynchronize: TGUID = '{00000030-0000-0000-C000-000000000046}';
    IID_ISynchronizeHandle: TGUID = '{00000031-0000-0000-C000-000000000046}';
    IID_ISynchronizeEvent: TGUID = '{00000032-0000-0000-C000-000000000046}';
    IID_ISynchronizeContainer: TGUID = '{00000033-0000-0000-C000-000000000046}';
    IID_ISynchronizeMutex: TGUID = '{00000025-0000-0000-C000-000000000046}';
    IID_ICancelMethodCalls: TGUID = '{00000029-0000-0000-C000-000000000046}';
    IID_IAsyncManager: TGUID = '{0000002A-0000-0000-C000-000000000046}';
    IID_ICallFactory: TGUID = '{1c733a30-2a1c-11ce-ade5-00aa0044773d}';
    IID_IRpcHelper: TGUID = '{00000149-0000-0000-C000-000000000046}';
    IID_IReleaseMarshalBuffers: TGUID = '{eb0cb9e8-7996-11d2-872e-0000f8080859}';
    IID_IWaitMultiple: TGUID = '{0000002B-0000-0000-C000-000000000046}';
    IID_IAddrTrackingControl: TGUID = '{00000147-0000-0000-C000-000000000046}';
    IID_IAddrExclusionControl: TGUID = '{00000148-0000-0000-C000-000000000046}';
    IID_IPipeByte: TGUID = '{DB2F3ACA-2F86-11d1-8E04-00C04FB9989A}';
    IID_AsyncIPipeByte: TGUID = '{DB2F3ACB-2F86-11d1-8E04-00C04FB9989A}';
    IID_IPipeLong: TGUID = '{DB2F3ACC-2F86-11d1-8E04-00C04FB9989A}';
    IID_AsyncIPipeLong: TGUID = '{DB2F3ACD-2F86-11d1-8E04-00C04FB9989A}';
    IID_IPipeDouble: TGUID = '{DB2F3ACE-2F86-11d1-8E04-00C04FB9989A}';
    IID_AsyncIPipeDouble: TGUID = '{DB2F3ACF-2F86-11d1-8E04-00C04FB9989A}';
    IID_IEnumContextProps: TGUID = '{000001c1-0000-0000-C000-000000000046}';
    IID_IContext: TGUID = '{000001c0-0000-0000-C000-000000000046}';
    IID_IObjContext: TGUID = '{000001c6-0000-0000-C000-000000000046}';
    IID_IComThreadingInfo: TGUID = '{000001ce-0000-0000-C000-000000000046}';
    IID_IProcessInitControl: TGUID = '{72380d55-8d2b-43a3-8513-2b6ef31434e9}';
    IID_IFastRundown: TGUID = '{00000040-0000-0000-C000-000000000046}';
    IID_IMarshalingStream: TGUID = '{D8F2F5E6-6102-4863-9F26-389A4676EFDE}';
    IID_IAgileReference: TGUID = '{C03F6A43-65A4-9818-987E-E0B810D2A6F2}';

    IID_IMachineGlobalObjectTable: TGUID = '{26d709ac-f70b-4421-a96f-d2878fafb00d}';
    IID_ISupportAllowLowerTrustActivation: TGUID = '{e9956ef2-3828-4b4b-8fa9-7db61dee4954}';
    IID_ISupportActivationFromPackage: TGUID = '{0a18aae5-5caa-48c5-a9f4-6e46dcd58ad5}';
    IID_ISupportCoAddComDependencyOnPackage: TGUID = '{c8059efc-4e98-4fd0-bfc6-44190b80b823}';
    IID_ISupportServerMustBeEqualOrGreaterPrivilegeActivation: TGUID = '{5bdb3ee2-46bc-4313-b5fb-801c360ba5f9}';
    IID_ISupportDoNotElevateServerActivation: TGUID = '{40aefe22-3ff6-43dc-8108-c8c402d57b5c}';
    IID_ISupportActivateAsActivatorPackaged: TGUID = '{765d1df2-f0af-4ef8-aa50-84789ca330ed}';
    IID_ISupportPackagedComRegistrationVisibility: TGUID = '{8dc3444e-c7ee-449a-9fb8-b9173988d66a}';


    IID_ISupportPackagedComElevationEnabledClasses: TGUID = '{b4219019-f712-4d4f-ade7-f468276af0b8}';
    IID_IPackagedComSyntaxSupport: TGUID = '{8f146474-b228-48fb-a58c-105ebb273abc}';
    IID_IMallocSpy: TGUID = '{0000001d-0000-0000-C000-000000000046}';
    IID_IBindCtx: TGUID = '{0000000e-0000-0000-C000-000000000046}';
    IID_IEnumMoniker: TGUID = '{00000102-0000-0000-C000-000000000046}';
    IID_IRunnableObject: TGUID = '{00000126-0000-0000-C000-000000000046}';
    IID_IRunningObjectTable: TGUID = '{00000010-0000-0000-C000-000000000046}';
    IID_IPersist: TGUID = '{0000010c-0000-0000-C000-000000000046}';
    IID_IPersistStream: TGUID = '{00000109-0000-0000-C000-000000000046}';
    IID_IMoniker: TGUID = '{0000000f-0000-0000-C000-000000000046}';
    IID_IROTData: TGUID = '{f29f6bc0-5021-11ce-aa15-00006901293f}';
    IID_IEnumSTATSTG: TGUID = '{0000000d-0000-0000-C000-000000000046}';
    IID_IStorage: TGUID = '{0000000b-0000-0000-C000-000000000046}';
    IID_IPersistFile: TGUID = '{0000010b-0000-0000-C000-000000000046}';
    IID_IPersistStorage: TGUID = '{0000010a-0000-0000-C000-000000000046}';
    IID_ILockBytes: TGUID = '{0000000a-0000-0000-C000-000000000046}';
    IID_IEnumFORMATETC: TGUID = '{00000103-0000-0000-C000-000000000046}';
    IID_IEnumSTATDATA: TGUID = '{00000105-0000-0000-C000-000000000046}';
    IID_IRootStorage: TGUID = '{00000012-0000-0000-C000-000000000046}';
    IID_IAdviseSink: TGUID = '{0000010f-0000-0000-C000-000000000046}';
    IID_AsyncIAdviseSink: TGUID = '{00000150-0000-0000-C000-000000000046}';
    IID_IAdviseSink2: TGUID = '{00000125-0000-0000-C000-000000000046}';
    IID_AsyncIAdviseSink2: TGUID = '{00000151-0000-0000-C000-000000000046}';
    IID_IDataObject: TGUID = '{0000010e-0000-0000-C000-000000000046}';
    IID_IDataAdviseHolder: TGUID = '{00000110-0000-0000-C000-000000000046}';
    IID_IMessageFilter: TGUID = '{00000016-0000-0000-C000-000000000046}';
    IID_IClassActivator: TGUID = '{00000140-0000-0000-C000-000000000046}';
    IID_IFillLockBytes: TGUID = '{99caf010-415e-11cf-8814-00aa00b569f5}';
    IID_IProgressNotify: TGUID = '{a9d758a0-4617-11cf-95fc-00aa00680db4}';
    IID_ILayoutStorage: TGUID = '{0e6d4d90-6738-11cf-9608-00aa00680db4}';
    IID_IBlockingLock: TGUID = '{30f3d47a-6447-11d1-8e3c-00c04fb9386d}';
    IID_ITimeAndNoticeControl: TGUID = '{bc0bf6ae-8878-11d1-83e9-00c04fc2c6d4}';
    IID_IOplockStorage: TGUID = '{8d19c834-8879-11d1-83e9-00c04fc2c6d4}';
    IID_IDirectWriterLock: TGUID = '{0e6d4d92-6738-11cf-9608-00aa00680db4}';
    IID_IUrlMon: TGUID = '{00000026-0000-0000-C000-000000000046}';
    IID_IForegroundTransfer: TGUID = '{00000145-0000-0000-C000-000000000046}';
    IID_IThumbnailExtractor: TGUID = '{969dc708-5c76-11d1-8d86-0000f804b057}';
    IID_IDummyHICONIncluder: TGUID = '{947990de-cc28-11d2-a0f7-00805f858fb1}';
    IID_IProcessLock: TGUID = '{000001d5-0000-0000-C000-000000000046}';
    IID_ISurrogateService: TGUID = '{000001d4-0000-0000-C000-000000000046}';
    IID_IInitializeSpy: TGUID = '{00000034-0000-0000-C000-000000000046}';
    IID_IApartmentShutdown: TGUID = '{A2F05A09-27A2-42B5-BC0E-AC163EF49D9B}';


    // ToDo
    (*


// Well-known Property Set Format IDs
extern const FMTID FMTID_SummaryInformation;

extern const FMTID FMTID_DocSummaryInformation;

extern const FMTID FMTID_UserDefinedProperties;

extern const FMTID FMTID_DiscardableInformation;

extern const FMTID FMTID_ImageSummaryInformation;

extern const FMTID FMTID_AudioSummaryInformation;

extern const FMTID FMTID_VideoSummaryInformation;

extern const FMTID FMTID_MediaFileSummaryInformation;
*)

type
    (* Forward Declarations *)


    IMarshal = interface;


    INoMarshal = interface;


    IAgileObject = interface;


    IActivationFilter = interface;


    IMarshal2 = interface;


    IMalloc = interface;


    IStdMarshalInfo = interface;


    IExternalConnection = interface;


    IMultiQI = interface;


    AsyncIMultiQI = interface;


    IInternalUnknown = interface;


    IEnumUnknown = interface;


    IEnumString = interface;


    ISequentialStream = interface;


    IStream = interface;


    IRpcChannelBuffer = interface;


    IRpcChannelBuffer2 = interface;


    IAsyncRpcChannelBuffer = interface;


    IRpcChannelBuffer3 = interface;


    IRpcSyntaxNegotiate = interface;


    IRpcProxyBuffer = interface;


    IRpcStubBuffer = interface;


    IPSFactoryBuffer = interface;


    IChannelHook = interface;


    IClientSecurity = interface;


    IServerSecurity = interface;


    IRpcOptions = interface;


    IGlobalOptions = interface;


    ISurrogate = interface;


    IGlobalInterfaceTable = interface;


    ISynchronize = interface;


    ISynchronizeHandle = interface;


    ISynchronizeEvent = interface;


    ISynchronizeContainer = interface;


    ISynchronizeMutex = interface;


    ICancelMethodCalls = interface;


    IAsyncManager = interface;


    ICallFactory = interface;


    IRpcHelper = interface;


    IReleaseMarshalBuffers = interface;


    IWaitMultiple = interface;


    IAddrTrackingControl = interface;


    IAddrExclusionControl = interface;


    IPipeByte = interface;


    AsyncIPipeByte = interface;


    IPipeLong = interface;


    AsyncIPipeLong = interface;


    IPipeDouble = interface;


    AsyncIPipeDouble = interface;


    IEnumContextProps = interface;


    IContext = interface;


    IObjContext = interface;


    IComThreadingInfo = interface;


    IProcessInitControl = interface;


    IFastRundown = interface;


    IMarshalingStream = interface;


    IAgileReference = interface;


    IMachineGlobalObjectTable = interface;


    ISupportAllowLowerTrustActivation = interface;


    ISupportActivationFromPackage = interface;


    ISupportCoAddComDependencyOnPackage = interface;


    ISupportServerMustBeEqualOrGreaterPrivilegeActivation = interface;


    ISupportDoNotElevateServerActivation = interface;


    ISupportActivateAsActivatorPackaged = interface;


    ISupportPackagedComRegistrationVisibility = interface;


    ISupportPackagedComElevationEnabledClasses = interface;


    IPackagedComSyntaxSupport = interface;


    IMallocSpy = interface;


    IBindCtx = interface;


    IEnumMoniker = interface;


    IRunnableObject = interface;


    IRunningObjectTable = interface;


    IPersist = interface;


    IPersistStream = interface;


    IMoniker = interface;


    IROTData = interface;


    IEnumSTATSTG = interface;


    IStorage = interface;


    IPersistFile = interface;


    IPersistStorage = interface;


    ILockBytes = interface;


    IEnumFORMATETC = interface;


    IEnumSTATDATA = interface;


    IRootStorage = interface;


    IAdviseSink = interface;


    AsyncIAdviseSink = interface;


    IAdviseSink2 = interface;


    AsyncIAdviseSink2 = interface;


    IDataObject = interface;


    IDataAdviseHolder = interface;


    IMessageFilter = interface;


    IClassActivator = interface;


    IFillLockBytes = interface;


    IProgressNotify = interface;


    ILayoutStorage = interface;


    IBlockingLock = interface;


    ITimeAndNoticeControl = interface;


    IOplockStorage = interface;


    IDirectWriterLock = interface;


    IUrlMon = interface;


    IForegroundTransfer = interface;


    IThumbnailExtractor = interface;


    IDummyHICONIncluder = interface;


    IProcessLock = interface;


    ISurrogateService = interface;


    IInitializeSpy = interface;


    IApartmentShutdown = interface;

    PIUnknown = ^IUnknown;

    IID = TGUID;
    REFGUID = ^TGUID;
    REFIID = ^TGUID;
    REFCLSID = ^TGUID;

    LPOLESTR = pointer; // ToDo
    PCOAUTHINFO = pointer; // ToDo
    POLECHAR = pointer; // ToDo
    LPCOLESTR = pointer; //ToDo
    PLPOLESTR = ^LPOLESTR;

    wireHBITMAP = pointer; // ^userHBITMAP;   // ToDo
    wireHPALETTE = pointer; // ^userHPALETTE;  // ToDo
    wireHGLOBAL = pointer; //^userHGLOBAL;  // ToDo


    wireHMETAFILEPICT = pointer; // ToDo
    wireHENHMETAFILE = pointer; // ToDo
    PBYTE_BLOB = pointer; // ToDo

    HMETAFILEPICT = handle; // ToDo

    PHBITMAP = ^HBITMAP;


    LPMARSHAL = ^IMarshal;
    LPMARSHAL2 = ^IMarshal2;
    LPMALLOC = ^IMalloc;
    LPSTDMARSHALINFO = ^IStdMarshalInfo;
    LPEXTERNALCONNECTION = ^IExternalConnection;
    LPMULTIQI = ^IMultiQI;
    LPENUMUNKNOWN = ^IEnumUnknown;
    LPENUMSTRING = ^IEnumString;
    LPSTREAM = ^IStream;

    LPSURROGATE = ^ISurrogate;
    LPGLOBALINTERFACETABLE = ^IGlobalInterfaceTable;
    LPCANCELMETHODCALLS = ^ICancelMethodCalls;
    LPADDRTRACKINGCONTROL = ^IAddrTrackingControl;
    LPADDREXCLUSIONCONTROL = ^IAddrExclusionControl;
    LPENUMCONTEXTPROPS = ^IEnumContextProps;
    LPMALLOCSPY = ^IMallocSpy;
    LPENUMMONIKER = ^IEnumMoniker;
    LPRUNNABLEOBJECT = ^IRunnableObject;
    LPRUNNINGOBJECTTABLE = ^IRunningObjectTable;
    LPPERSIST = ^IPersist;

    LPPERSISTSTREAM = ^IPersistStream;
    LPMONIKER = ^IMoniker;
    LPENUMSTATSTG = ^IEnumSTATSTG;

    LPSTORAGE = ^IStorage;
    LPPERSISTFILE = ^IPersistFile;
    LPPERSISTSTORAGE = ^IPersistStorage;
    PLPLOCKBYTES = ^ILockBytes;

    PLPENUMFORMATETC = ^IEnumFORMATETC;
    PLPENUMSTATDATA = ^IEnumSTATDATA;
    PLPROOTSTORAGE = ^IRootStorage;
    PLPADVISESINK = ^IAdviseSink;
    PLPADVISESINK2 = ^IAdviseSink2;
    PLPDATAOBJECT = ^IDataObject;
    PLPDATAADVISEHOLDER = ^IDataAdviseHolder;
    PLPMESSAGEFILTER = ^IMessageFilter;
    PLPINITIALIZESPY = ^IInitializeSpy;


    _COSERVERINFO = record
        dwReserved1: DWORD;
        pwszName: LPWSTR;
        pAuthInfo: PCOAUTHINFO;
        dwReserved2: DWORD;
    end;
    TCOSERVERINFO = _COSERVERINFO;
    PCOSERVERINFO = ^TCOSERVERINFO;


    IMarshal = interface(IUnknown)
        ['{00000003-0000-0000-C000-000000000046}']
        function GetUnmarshalClass(
        {_In_  } riid: REFIID;
        {_In_opt_  } pv: Pvoid;
        {_In_  } dwDestContext: DWORD;
        {_Reserved_  } pvDestContext: Pvoid;
        {_In_  } mshlflags: DWORD;
        {_Out_  } pCid: PCLSID): HRESULT; stdcall;

        function GetMarshalSizeMax(
        {_In_  } riid: REFIID;
        {_In_opt_  } pv: Pvoid;
        {_In_  } dwDestContext: DWORD;
        {_Reserved_  } pvDestContext: Pvoid;
        {_In_  } mshlflags: DWORD;
        {_Out_  } pSize: PDWORD): HRESULT; stdcall;

        function MarshalInterface(
        {_In_  } pStm: IStream;
        {_In_  } riid: REFIID;
        {_In_opt_  } pv: Pvoid;
        {_In_  } dwDestContext: DWORD;
        {_Reserved_  } pvDestContext: Pvoid;
        {_In_  } mshlflags: DWORD): HRESULT; stdcall;

        function UnmarshalInterface(
        {_In_  } pStm: IStream;
        {_In_  } riid: REFIID;
        {_Outptr_  }  out ppv): HRESULT; stdcall;

        function ReleaseMarshalData(
        {_In_  } pStm: IStream): HRESULT; stdcall;

        function DisconnectObject(
        {_In_  } dwReserved: DWORD): HRESULT; stdcall;

    end;


    INoMarshal = interface(IUnknown)
        ['{ecc8691b-c1db-4dc0-855e-65f6c551af49}']
    end;


    IAgileObject = interface(IUnknown)
        ['{94ea2b94-e9cc-49e0-c0ff-ee64ca8f5b90}']
    end;


    TtagACTIVATIONTYPE = (
        ACTIVATIONTYPE_UNCATEGORIZED = 0,
        ACTIVATIONTYPE_FROM_MONIKER = $1,
        ACTIVATIONTYPE_FROM_DATA = $2,
        ACTIVATIONTYPE_FROM_STORAGE = $4,
        ACTIVATIONTYPE_FROM_STREAM = $8,
        ACTIVATIONTYPE_FROM_FILE = $10);

    PtagACTIVATIONTYPE = ^TtagACTIVATIONTYPE;

    TACTIVATIONTYPE = TtagACTIVATIONTYPE;

    IActivationFilter = interface(IUnknown)
        ['{00000017-0000-0000-C000-000000000046}']
        function HandleActivation(dwActivationType: DWORD; rclsid: REFCLSID; pReplacementClsId: PCLSID): HRESULT; stdcall;

    end;


    IMarshal2 = interface(IMarshal)
        ['{000001cf-0000-0000-C000-000000000046}']
    end;


    IMalloc = interface(IUnknown)
        ['{00000002-0000-0000-C000-000000000046}']
        procedure Alloc(
        {_In_  } cb: SIZE_T); stdcall;

        procedure Realloc(
        {_In_opt_  } pv: Pvoid;
        {_In_  } cb: SIZE_T); stdcall;

        procedure Free(
        {_In_opt_  } pv: Pvoid); stdcall;

        function GetSize(
        {_In_opt_ _Post_writable_byte_size_(return)}  pv: pointer): SIZE_T; stdcall;

        function DidAlloc(
        {_In_opt_  } pv: Pvoid): int32; stdcall;

        procedure HeapMinimize(); stdcall;

    end;


    IStdMarshalInfo = interface(IUnknown)
        ['{00000018-0000-0000-C000-000000000046}']
        function GetClassForHandler(
        {_In_  } dwDestContext: DWORD;
        {_Reserved_  } pvDestContext: Pvoid;
        {_Out_  } pClsid: PCLSID): HRESULT; stdcall;

    end;


    tagEXTCONN = (
        EXTCONN_STRONG = $1,
        EXTCONN_WEAK = $2,
        EXTCONN_CALLABLE = $4);

    TEXTCONN = tagEXTCONN;
    PEXTCONN = ^TEXTCONN;


    IExternalConnection = interface(IUnknown)
        ['{00000019-0000-0000-C000-000000000046}']
        function AddConnection(
        {_In_  } extconn: DWORD;
        {_In_  } reserved: DWORD): DWORD; stdcall;

        function ReleaseConnection(
        {_In_  } extconn: DWORD;
        {_In_  } reserved: DWORD;
        {_In_  } fLastReleaseCloses: boolean): DWORD; stdcall;

    end;


    tagMULTI_QI = record
        pIID: IID;
        pItf: IUnknown;
        hr: HRESULT;
    end;

    TMULTI_QI = tagMULTI_QI;
    PMULTI_QI = ^TMULTI_QI;


    IMultiQI = interface(IUnknown)
        ['{00000020-0000-0000-C000-000000000046}']
        function QueryMultipleInterfaces(
        {_In_  } cMQIs: ULONG;
        {_Inout_updates_(cMQIs)  } pMQIs: PMULTI_QI): HRESULT; stdcall;

    end;


    AsyncIMultiQI = interface(IUnknown)
        ['{000e0020-0000-0000-C000-000000000046}']
        function Begin_QueryMultipleInterfaces(
        {_In_  } cMQIs: ULONG;
        {_Inout_updates_(cMQIs)  } pMQIs: PMULTI_QI): HRESULT; stdcall;

        function Finish_QueryMultipleInterfaces(
        {_Inout_updates_(cMQIs)  } pMQIs: PMULTI_QI): HRESULT; stdcall;

    end;


    IInternalUnknown = interface(IUnknown)
        ['{00000021-0000-0000-C000-000000000046}']
        function QueryInternalInterface(
        {_In_  } riid: REFIID;
        {_Outptr_  }  out ppv): HRESULT; stdcall;

    end;


    IEnumUnknown = interface(IUnknown)
        ['{00000100-0000-0000-C000-000000000046}']
        function Next(
        {_In_  } celt: ULONG;
        {_Out_writes_to_(celt,*pceltFetched)  }  out rgelt: IUnknown;
        {_Out_opt_  } pceltFetched: PULONG): HRESULT; stdcall;

        function Skip(celt: ULONG): HRESULT; stdcall;

        function Reset(): HRESULT; stdcall;

        function Clone(
        {__RPC__deref_out_opt }  out ppenum: IEnumUnknown): HRESULT; stdcall;

    end;


    IEnumString = interface(IUnknown)
        ['{00000101-0000-0000-C000-000000000046}']
        function Next(celt: ULONG;
        {_Out_writes_to_(celt,*pceltFetched)  } rgelt: LPOLESTR;
        {_Out_opt_  } pceltFetched: PULONG): HRESULT; stdcall;

        function Skip(celt: ULONG): HRESULT; stdcall;

        function Reset(): HRESULT; stdcall;

        function Clone(
        {__RPC__deref_out_opt }  out ppenum: IEnumString): HRESULT; stdcall;

    end;


    ISequentialStream = interface(IUnknown)
        ['{0c733a30-2a1c-11ce-ade5-00aa0044773d}']
        function Read(
        {_Out_writes_bytes_to_(cb, *pcbRead)  } pv: Pvoid;
        {_In_  } cb: ULONG;
        {_Out_opt_  } pcbRead: PULONG): HRESULT; stdcall;

        function Write(
        {_In_reads_bytes_(cb)  } pv: Pvoid;
        {_In_  } cb: ULONG;
        {_Out_opt_  } pcbWritten: PULONG): HRESULT; stdcall;

    end;


    tagSTATSTG = record
        pwcsName: LPOLESTR;
        StatStgType: DWORD;
        cbSize: ULARGE_INTEGER;
        mtime: TFILETIME;
        ctime: TFILETIME;
        atime: TFILETIME;
        grfMode: DWORD;
        grfLocksSupported: DWORD;
        clsid: TCLSID;
        grfStateBits: DWORD;
        reserved: DWORD;
    end;
    TSTATSTG = tagSTATSTG;
    PSTATSTG = ^TSTATSTG;

    TtagSTGTY = (
        STGTY_STORAGE = 1,
        STGTY_STREAM = 2,
        STGTY_LOCKBYTES = 3,
        STGTY_PROPERTY = 4);

    PtagSTGTY = ^TtagSTGTY;

    TSTGTY = TtagSTGTY;

    TtagSTREAM_SEEK = (
        STREAM_SEEK_SET = 0,
        STREAM_SEEK_CUR = 1,
        STREAM_SEEK_END = 2);

    PtagSTREAM_SEEK = ^TtagSTREAM_SEEK;

    TSTREAM_SEEK = TtagSTREAM_SEEK;

    tagLOCKTYPE = (
        LOCK_WRITE = 1,
        LOCK_EXCLUSIVE = 2,
        LOCK_ONLYONCE = 4);

    TLOCKTYPE = tagLOCKTYPE;
    PLOCKTYPE = ^TLOCKTYPE;


    IStream = interface(ISequentialStream)
        ['{0000000c-0000-0000-C000-000000000046}']
        function Seek(dlibMove: LARGE_INTEGER; dwOrigin: DWORD;
        {_Out_opt_  } plibNewPosition: PULARGE_INTEGER): HRESULT; stdcall;

        function SetSize(libNewSize: ULARGE_INTEGER): HRESULT; stdcall;

        function CopyTo(
        {_In_  } pstm: IStream; cb: ULARGE_INTEGER;
        {_Out_opt_  } pcbRead: PULARGE_INTEGER;
        {_Out_opt_  } pcbWritten: PULARGE_INTEGER): HRESULT; stdcall;

        function Commit(grfCommitFlags: DWORD): HRESULT; stdcall;

        function Revert(): HRESULT; stdcall;

        function LockRegion(libOffset: ULARGE_INTEGER; cb: ULARGE_INTEGER; dwLockType: DWORD): HRESULT; stdcall;

        function UnlockRegion(libOffset: ULARGE_INTEGER; cb: ULARGE_INTEGER; dwLockType: DWORD): HRESULT; stdcall;

        function Stat(
        {__RPC__out } pstatstg: PSTATSTG; grfStatFlag: DWORD): HRESULT; stdcall;

        function Clone(
        {__RPC__deref_out_opt }  out ppstm: IStream): HRESULT; stdcall;

    end;

    PIStream = ^IStream;


    TRPCOLEDATAREP = ULONG;

    tagRPCOLEMESSAGE = record
        reserved1: Pvoid;
        dataRepresentation: TRPCOLEDATAREP;
        Buffer: Pvoid;
        cbBuffer: ULONG;
        iMethod: ULONG;
        reserved2: array [0..4] of Pvoid;
        rpcFlags: ULONG;
    end;

    TRPCOLEMESSAGE = tagRPCOLEMESSAGE;
    PRPCOLEMESSAGE = ^TRPCOLEMESSAGE;


    IRpcChannelBuffer = interface(IUnknown)
        ['{D5F56B60-593B-101A-B569-08002B2DBF7A}']
        function GetBuffer(
        {_Inout_  } pMessage: PRPCOLEMESSAGE;
        {_In_  } riid: REFIID): HRESULT; stdcall;

        function SendReceive(
        {_Inout_  } pMessage: PRPCOLEMESSAGE;
        {_Out_opt_  } pStatus: PULONG): HRESULT; stdcall;

        function FreeBuffer(
        {_Inout_  } pMessage: PRPCOLEMESSAGE): HRESULT; stdcall;

        function GetDestCtx(
        {_Out_  } pdwDestContext: PDWORD;
        {_Outptr_result_maybenull_  }  out ppvDestContext): HRESULT; stdcall;

        function IsConnected(): HRESULT; stdcall;

    end;


    IRpcChannelBuffer2 = interface(IRpcChannelBuffer)
        ['{594f31d0-7f19-11d0-b194-00a0c90dc8bf}']
        function GetProtocolVersion(
        {_Out_  } pdwVersion: PDWORD): HRESULT; stdcall;

    end;


    IAsyncRpcChannelBuffer = interface(IRpcChannelBuffer2)
        ['{a5029fb6-3c34-11d1-9c99-00c04fb998aa}']
        function Send(
        {_Inout_  } pMsg: PRPCOLEMESSAGE;
        {_In_  } pSync: ISynchronize;
        {_Out_  } pulStatus: PULONG): HRESULT; stdcall;

        function Receive(
        {_Inout_  } pMsg: PRPCOLEMESSAGE;
        {_Out_  } pulStatus: PULONG): HRESULT; stdcall;

        function GetDestCtxEx(
        {_In_  } pMsg: PRPCOLEMESSAGE;
        {_Out_  } pdwDestContext: PDWORD;
        {_Outptr_opt_result_maybenull_  }  out ppvDestContext): HRESULT; stdcall;

    end;


    IRpcChannelBuffer3 = interface(IRpcChannelBuffer2)
        ['{25B15600-0115-11d0-BF0D-00AA00B8DFD2}']
        function Send(
        {_Inout_  } pMsg: PRPCOLEMESSAGE;
        {_Out_  } pulStatus: PULONG): HRESULT; stdcall;

        function Receive(
        {_Inout_  } pMsg: PRPCOLEMESSAGE;
        {_In_  } ulSize: ULONG;
        {_Out_  } pulStatus: PULONG): HRESULT; stdcall;

        function Cancel(
        {_Inout_  } pMsg: PRPCOLEMESSAGE): HRESULT; stdcall;

        function GetCallContext(
        {_In_  } pMsg: PRPCOLEMESSAGE;
        {_In_  } riid: REFIID;
        {_Outptr_  }  out pInterface): HRESULT; stdcall;

        function GetDestCtxEx(
        {_In_  } pMsg: PRPCOLEMESSAGE;
        {_Out_  } pdwDestContext: PDWORD;
        {_Outptr_opt_result_maybenull_  }  out ppvDestContext): HRESULT; stdcall;

        function GetState(
        {_In_  } pMsg: PRPCOLEMESSAGE;
        {_Out_  } pState: PDWORD): HRESULT; stdcall;

        function RegisterAsync(
        {_Inout_  } pMsg: PRPCOLEMESSAGE;
        {_In_  } pAsyncMgr: IAsyncManager): HRESULT; stdcall;

    end;


    IRpcSyntaxNegotiate = interface(IUnknown)
        ['{58a08519-24c8-4935-b482-3fd823333a4f}']
        function NegotiateSyntax(
        {_Inout_  } pMsg: PRPCOLEMESSAGE): HRESULT; stdcall;

    end;


    IRpcProxyBuffer = interface(IUnknown)
        ['{D5F56A34-593B-101A-B569-08002B2DBF7A}']
        function Connect(
        {_In_  } pRpcChannelBuffer: IRpcChannelBuffer): HRESULT; stdcall;

        procedure Disconnect(); stdcall;

    end;


    IRpcStubBuffer = interface(IUnknown)
        ['{D5F56AFC-593B-101A-B569-08002B2DBF7A}']
        function Connect(
        {_In_  } pUnkServer: IUnknown): HRESULT; stdcall;

        procedure Disconnect(); stdcall;

        function Invoke(
        {_Inout_  } _prpcmsg: PRPCOLEMESSAGE;
        {_In_  } _pRpcChannelBuffer: IRpcChannelBuffer): HRESULT; stdcall;

        function IsIIDSupported(
        {_In_  } riid: REFIID): IRpcStubBuffer; stdcall;

        function CountRefs(): ULONG; stdcall;

        function DebugServerQueryInterface(
        {_Outptr_  }  out ppv): HRESULT; stdcall;

        procedure DebugServerRelease(
        {_In_  } pv: Pvoid); stdcall;

    end;


    IPSFactoryBuffer = interface(IUnknown)
        ['{D5F569D0-593B-101A-B569-08002B2DBF7A}']
        function CreateProxy(
        {_In_  } pUnkOuter: IUnknown;
        {_In_  } riid: REFIID;
        {_Outptr_  }  out ppProxy: IRpcProxyBuffer;
        {_Outptr_  }  out ppv): HRESULT; stdcall;

        function CreateStub(
        {_In_  } riid: REFIID;
        {_In_opt_  } pUnkServer: IUnknown;
        {_Outptr_  }  out ppStub: IRpcStubBuffer): HRESULT; stdcall;
    end;

    //#if  (_WIN32_WINNT >= 0x0400 ) || defined(_WIN32_DCOM) // DCOM

    // This interface is only valid on Windows NT 4.0
    TSChannelHookCallInfo = record
        iid: TIID;
        cbSize: DWORD;
        uCausality: TGUID;
        dwServerPid: DWORD;
        iMethod: DWORD;
        pObject: Pvoid;
    end;
    PSChannelHookCallInfo = ^TSChannelHookCallInfo;

    IChannelHook = interface(IUnknown)
        ['{1008c4a0-7613-11cf-9af1-0020af6e72f4}']
        procedure ClientGetSize(
        {_In_  } uExtent: REFGUID;
        {_In_  } riid: REFIID;
        {_Out_  } pDataSize: PULONG); stdcall;

        procedure ClientFillBuffer(
        {_In_  } uExtent: REFGUID;
        {_In_  } riid: REFIID;
        {_Inout_  } pDataSize: PULONG;
        {_In_  } pDataBuffer: Pvoid); stdcall;

        procedure ClientNotify(
        {_In_  } uExtent: REFGUID;
        {_In_  } riid: REFIID;
        {_In_  } cbDataSize: ULONG;
        {_In_  } pDataBuffer: Pvoid;
        {_In_  } lDataRep: DWORD;
        {_In_  } hrFault: HRESULT); stdcall;

        procedure ServerNotify(
        {_In_  } uExtent: REFGUID;
        {_In_  } riid: REFIID;
        {_In_  } cbDataSize: ULONG;
        {_In_  } pDataBuffer: Pvoid;
        {_In_  } lDataRep: DWORD); stdcall;

        procedure ServerGetSize(
        {_In_  } uExtent: REFGUID;
        {_In_  } riid: REFIID;
        {_In_  } hrFault: HRESULT;
        {_Out_  } pDataSize: PULONG); stdcall;

        procedure ServerFillBuffer(
        {_In_  } uExtent: REFGUID;
        {_In_  } riid: REFIID;
        {_Inout_  } pDataSize: PULONG;
        {_In_  } pDataBuffer: Pvoid;
        {_In_  } hrFault: HRESULT); stdcall;

    end;


    tagSOLE_AUTHENTICATION_SERVICE = record
        dwAuthnSvc: DWORD;
        dwAuthzSvc: DWORD;
        pPrincipalName: POLECHAR;
        hr: HRESULT;
    end;

    TSOLE_AUTHENTICATION_SERVICE = tagSOLE_AUTHENTICATION_SERVICE;
    PSOLE_AUTHENTICATION_SERVICE = ^TSOLE_AUTHENTICATION_SERVICE;

    tagEOLE_AUTHENTICATION_CAPABILITIES = (
        EOAC_NONE = 0,
        EOAC_MUTUAL_AUTH = $1,
        EOAC_STATIC_CLOAKING = $20,
        EOAC_DYNAMIC_CLOAKING = $40,
        EOAC_ANY_AUTHORITY = $80,
        EOAC_MAKE_FULLSIC = $100,
        EOAC_DEFAULT = $800,
        EOAC_SECURE_REFS = $2,
        EOAC_ACCESS_CONTROL = $4,
        EOAC_APPID = $8,
        EOAC_DYNAMIC = $10,
        EOAC_REQUIRE_FULLSIC = $200,
        EOAC_AUTO_IMPERSONATE = $400,
        EOAC_DISABLE_AAA = $1000,
        EOAC_NO_CUSTOM_MARSHAL = $2000,
        EOAC_RESERVED1 = $4000
        );

    TEOLE_AUTHENTICATION_CAPABILITIES = tagEOLE_AUTHENTICATION_CAPABILITIES;
    PEOLE_AUTHENTICATION_CAPABILITIES = ^TEOLE_AUTHENTICATION_CAPABILITIES;


    tagSOLE_AUTHENTICATION_INFO = record
        dwAuthnSvc: DWORD;
        dwAuthzSvc: DWORD;
        pAuthInfo: Pvoid;
    end;
    TSOLE_AUTHENTICATION_INFO = tagSOLE_AUTHENTICATION_INFO;
    PSOLE_AUTHENTICATION_INFO = ^TSOLE_AUTHENTICATION_INFO;


    tagSOLE_AUTHENTICATION_LIST = record
        cAuthInfo: DWORD;
        aAuthInfo: PSOLE_AUTHENTICATION_INFO;
    end;
    TSOLE_AUTHENTICATION_LIST = tagSOLE_AUTHENTICATION_LIST;
    PSOLE_AUTHENTICATION_LIST = ^TSOLE_AUTHENTICATION_LIST;


    IClientSecurity = interface(IUnknown)
        ['{0000013D-0000-0000-C000-000000000046}']
        function QueryBlanket(
        {_In_  } pProxy: IUnknown;
        {_Out_  } pAuthnSvc: PDWORD;
        {_Out_opt_  } pAuthzSvc: PDWORD;
        {__RPC__deref_out_opt  }  out pServerPrincName: POLECHAR;
        {_Out_opt_  } pAuthnLevel: PDWORD;
        {_Out_opt_  } pImpLevel: PDWORD;
        {_Outptr_result_maybenull_  }  out pAuthInfo;
        {_Out_opt_  } pCapabilites: PDWORD): HRESULT; stdcall;

        function SetBlanket(
        {_In_  } pProxy: IUnknown;
        {_In_  } dwAuthnSvc: DWORD;
        {_In_  } dwAuthzSvc: DWORD;
        {__RPC__in_opt  } pServerPrincName: POLECHAR;
        {_In_  } dwAuthnLevel: DWORD;
        {_In_  } dwImpLevel: DWORD;
        {_In_opt_  } pAuthInfo: Pvoid;
        {_In_  } dwCapabilities: DWORD): HRESULT; stdcall;

        function CopyProxy(
        {_In_  } pProxy: IUnknown;
        {_Outptr_  }  out ppCopy: IUnknown): HRESULT; stdcall;

    end;


    IServerSecurity = interface(IUnknown)
        ['{0000013E-0000-0000-C000-000000000046}']
        function QueryBlanket(
        {_Out_opt_  } pAuthnSvc: PDWORD;
        {_Out_opt_  } pAuthzSvc: PDWORD;
        {__RPC__deref_out_opt  }  out pServerPrincName: POLECHAR;
        {_Out_opt_  } pAuthnLevel: PDWORD;
        {_Out_opt_  } pImpLevel: PDWORD;
        {_Outptr_result_maybenull_  }  out pPrivs;
        {_Inout_opt_  } pCapabilities: PDWORD): HRESULT; stdcall;

        function ImpersonateClient(): HRESULT; stdcall;

        function RevertToSelf(): HRESULT; stdcall;

        function IsImpersonating(): boolean; stdcall;

    end;


    tagRPCOPT_PROPERTIES = (
        COMBND_RPCTIMEOUT = $1,
        COMBND_SERVER_LOCALITY = $2,
        COMBND_RESERVED1 = $4,
        COMBND_RESERVED2 = $5,
        COMBND_RESERVED3 = $8,
        COMBND_RESERVED4 = $10);

    TRPCOPT_PROPERTIES = tagRPCOPT_PROPERTIES;
    PRPCOPT_PROPERTIES = ^TRPCOPT_PROPERTIES;


    tagRPCOPT_SERVER_LOCALITY_VALUES = (
        SERVER_LOCALITY_PROCESS_LOCAL = 0,
        SERVER_LOCALITY_MACHINE_LOCAL = 1,
        SERVER_LOCALITY_REMOTE = 2);

    TRPCOPT_SERVER_LOCALITY_VALUES = tagRPCOPT_SERVER_LOCALITY_VALUES;
    PRPCOPT_SERVER_LOCALITY_VALUES = ^TRPCOPT_SERVER_LOCALITY_VALUES;


    IRpcOptions = interface(IUnknown)
        ['{00000144-0000-0000-C000-000000000046}']
        function _Set(
        {_In_  } pPrx: IUnknown;
        {_In_  } dwProperty: TRPCOPT_PROPERTIES;
        {_In_  } dwValue: ULONG_PTR): HRESULT; stdcall;

        function Query(
        {_In_  } pPrx: IUnknown;
        {_In_  } dwProperty: TRPCOPT_PROPERTIES;
        {_Out_  } pdwValue: PULONG_PTR): HRESULT; stdcall;

    end;


    tagGLOBALOPT_PROPERTIES = (
        COMGLB_EXCEPTION_HANDLING = 1,
        COMGLB_APPID = 2,
        COMGLB_RPC_THREADPOOL_SETTING = 3,
        COMGLB_RO_SETTINGS = 4,
        COMGLB_UNMARSHALING_POLICY = 5,
        COMGLB_PROPERTIES_RESERVED1 = 6,
        COMGLB_PROPERTIES_RESERVED2 = 7,
        COMGLB_PROPERTIES_RESERVED3 = 8);

    TGLOBALOPT_PROPERTIES = tagGLOBALOPT_PROPERTIES;
    PGLOBALOPT_PROPERTIES = ^TGLOBALOPT_PROPERTIES;


    tagGLOBALOPT_EH_VALUES = (
        COMGLB_EXCEPTION_HANDLE = 0,
        COMGLB_EXCEPTION_DONOT_HANDLE_FATAL = 1,
        COMGLB_EXCEPTION_DONOT_HANDLE = COMGLB_EXCEPTION_DONOT_HANDLE_FATAL,
        COMGLB_EXCEPTION_DONOT_HANDLE_ANY = 2);

    TGLOBALOPT_EH_VALUES = tagGLOBALOPT_EH_VALUES;
    PGLOBALOPT_EH_VALUES = ^TGLOBALOPT_EH_VALUES;


    tagGLOBALOPT_RPCTP_VALUES = (
        COMGLB_RPC_THREADPOOL_SETTING_DEFAULT_POOL = 0,
        COMGLB_RPC_THREADPOOL_SETTING_PRIVATE_POOL = 1);

    TGLOBALOPT_RPCTP_VALUES = tagGLOBALOPT_RPCTP_VALUES;
    PGLOBALOPT_RPCTP_VALUES = ^TGLOBALOPT_RPCTP_VALUES;


    tagGLOBALOPT_RO_FLAGS = (
        COMGLB_STA_MODALLOOP_REMOVE_TOUCH_MESSAGES = $1,
        COMGLB_STA_MODALLOOP_SHARED_QUEUE_REMOVE_INPUT_MESSAGES = $2,
        COMGLB_STA_MODALLOOP_SHARED_QUEUE_DONOT_REMOVE_INPUT_MESSAGES = $4,
        COMGLB_FAST_RUNDOWN = $8,
        COMGLB_RESERVED1 = $10,
        COMGLB_RESERVED2 = $20,
        COMGLB_RESERVED3 = $40,
        COMGLB_STA_MODALLOOP_SHARED_QUEUE_REORDER_POINTER_MESSAGES = $80,
        COMGLB_RESERVED4 = $100,
        COMGLB_RESERVED5 = $200,
        COMGLB_RESERVED6 = $400);

    TGLOBALOPT_RO_FLAGS = tagGLOBALOPT_RO_FLAGS;
    PGLOBALOPT_RO_FLAGS = ^TGLOBALOPT_RO_FLAGS;


    tagGLOBALOPT_UNMARSHALING_POLICY_VALUES = (
        COMGLB_UNMARSHALING_POLICY_NORMAL = 0,
        COMGLB_UNMARSHALING_POLICY_STRONG = 1,
        COMGLB_UNMARSHALING_POLICY_HYBRID = 2);

    TGLOBALOPT_UNMARSHALING_POLICY_VALUES = tagGLOBALOPT_UNMARSHALING_POLICY_VALUES;
    PGLOBALOPT_UNMARSHALING_POLICY_VALUES = ^TGLOBALOPT_UNMARSHALING_POLICY_VALUES;


    IGlobalOptions = interface(IUnknown)
        ['{0000015B-0000-0000-C000-000000000046}']
        function _Set(
        {_In_  } dwProperty: TGLOBALOPT_PROPERTIES;
        {_In_  } dwValue: ULONG_PTR): HRESULT; stdcall;

        function Query(
        {_In_  } dwProperty: TGLOBALOPT_PROPERTIES;
        {_Out_  } pdwValue: PULONG_PTR): HRESULT; stdcall;

    end;

    //#endif //DCOM


    ISurrogate = interface(IUnknown)
        ['{00000022-0000-0000-C000-000000000046}']
        function LoadDllServer(
        {__RPC__in } Clsid: REFCLSID): HRESULT; stdcall;

        function FreeSurrogate(): HRESULT; stdcall;

    end;


    IGlobalInterfaceTable = interface(IUnknown)
        ['{00000146-0000-0000-C000-000000000046}']
        function RegisterInterfaceInGlobal(
        {_In_  } pUnk: IUnknown;
        {_In_  } riid: REFIID;
        {_Out_  } pdwCookie: PDWORD): HRESULT; stdcall;

        function RevokeInterfaceFromGlobal(
        {_In_  } dwCookie: DWORD): HRESULT; stdcall;

        function GetInterfaceFromGlobal(
        {_In_  } dwCookie: DWORD;
        {_In_  } riid: REFIID;
        {_Outptr_  }  out ppv): HRESULT; stdcall;

    end;


    ISynchronize = interface(IUnknown)
        ['{00000030-0000-0000-C000-000000000046}']
        function Wait(dwFlags: DWORD; dwMilliseconds: DWORD): HRESULT; stdcall;

        function Signal(): HRESULT; stdcall;

        function Reset(): HRESULT; stdcall;

    end;


    ISynchronizeHandle = interface(IUnknown)
        ['{00000031-0000-0000-C000-000000000046}']
        function GetHandle(
        {_Out_  } ph: PHANDLE): HRESULT; stdcall;

    end;


    ISynchronizeEvent = interface(ISynchronizeHandle)
        ['{00000032-0000-0000-C000-000000000046}']
        function SetEventHandle(
        {_In_  } ph: PHANDLE): HRESULT; stdcall;

    end;


    ISynchronizeContainer = interface(IUnknown)
        ['{00000033-0000-0000-C000-000000000046}']
        function AddSynchronize(
        {_In_  } pSync: ISynchronize): HRESULT; stdcall;

        function WaitMultiple(
        {_In_  } dwFlags: DWORD;
        {_In_  } dwTimeOut: DWORD;
        {_Outptr_  }  out ppSync: ISynchronize): HRESULT; stdcall;

    end;


    ISynchronizeMutex = interface(ISynchronize)
        ['{00000025-0000-0000-C000-000000000046}']
        function ReleaseMutex(): HRESULT; stdcall;

    end;


    ICancelMethodCalls = interface(IUnknown)
        ['{00000029-0000-0000-C000-000000000046}']
        function Cancel(
        {_In_  } ulSeconds: ULONG): HRESULT; stdcall;

        function TestCancel(): HRESULT; stdcall;

    end;


    tagDCOM_CALL_STATE = (
        DCOM_NONE = 0,
        DCOM_CALL_COMPLETE = $1,
        DCOM_CALL_CANCELED = $2
        );

    TDCOM_CALL_STATE = tagDCOM_CALL_STATE;
    PDCOM_CALL_STATE = ^TDCOM_CALL_STATE;


    IAsyncManager = interface(IUnknown)
        ['{0000002A-0000-0000-C000-000000000046}']
        function CompleteCall(
        {_In_  } Result: HRESULT): HRESULT; stdcall;

        function GetCallContext(
        {_In_  } riid: REFIID;
        {_Outptr_  }  out pInterface): HRESULT; stdcall;

        function GetState(
        {_Out_  } pulStateFlags: PULONG): HRESULT; stdcall;

    end;


    ICallFactory = interface(IUnknown)
        ['{1c733a30-2a1c-11ce-ade5-00aa0044773d}']
        function CreateCall(
        {_In_  } riid: REFIID;
        {_In_opt_  } pCtrlUnk: IUnknown;
        {_In_  } riid2: REFIID;
        {_Outptr_  }  out ppv: IUnknown): HRESULT; stdcall;

    end;


    IRpcHelper = interface(IUnknown)
        ['{00000149-0000-0000-C000-000000000046}']
        function GetDCOMProtocolVersion(
        {_Out_  } pComVersion: PDWORD): HRESULT; stdcall;

        function GetIIDFromOBJREF(
        {_In_  } pObjRef: Pvoid;
        {_Outptr_  }  out piid: IID): HRESULT; stdcall;

    end;


    IReleaseMarshalBuffers = interface(IUnknown)
        ['{eb0cb9e8-7996-11d2-872e-0000f8080859}']
        function ReleaseMarshalBuffer(
        {_Inout_  } pMsg: PRPCOLEMESSAGE;
        {_In_  } dwFlags: DWORD;
        {_In_opt_  } pChnl: IUnknown): HRESULT; stdcall;

    end;


    IWaitMultiple = interface(IUnknown)
        ['{0000002B-0000-0000-C000-000000000046}']
        function WaitMultiple(
        {_In_  } timeout: DWORD;
        {_Outptr_  }  out pSync: ISynchronize): HRESULT; stdcall;

        function AddSynchronize(
        {_In_  } pSync: ISynchronize): HRESULT; stdcall;

    end;


    IAddrTrackingControl = interface(IUnknown)
        ['{00000147-0000-0000-C000-000000000046}']
        function EnableCOMDynamicAddrTracking(): HRESULT; stdcall;

        function DisableCOMDynamicAddrTracking(): HRESULT; stdcall;

    end;


    IAddrExclusionControl = interface(IUnknown)
        ['{00000148-0000-0000-C000-000000000046}']
        function GetCurrentAddrExclusionList(
        {_In_  } riid: REFIID;
        {_Outptr_  }  out ppEnumerator): HRESULT; stdcall;

        function UpdateAddrExclusionList(
        {_In_  } pEnumerator: IUnknown): HRESULT; stdcall;

    end;


    IPipeByte = interface(IUnknown)
        ['{DB2F3ACA-2F86-11d1-8E04-00C04FB9989A}']
        function Pull(
        {__RPC__out_ecount_part(cRequest, *pcReturned) } buf: pbyte; cRequest: ULONG;
        {__RPC__out } pcReturned: PULONG): HRESULT; stdcall;

        function Push(
        {__RPC__in_ecount_full(cSent) } buf: pbyte; cSent: ULONG): HRESULT; stdcall;

    end;


    AsyncIPipeByte = interface(IUnknown)
        ['{DB2F3ACB-2F86-11d1-8E04-00C04FB9989A}']
        function Begin_Pull(cRequest: ULONG): HRESULT; stdcall;

        function Finish_Pull(
        {__RPC__out_xcount_part(cRequest, *pcReturned) } buf: pbyte;
        {__RPC__out } pcReturned: PULONG): HRESULT; stdcall;

        function Begin_Push(
        {__RPC__in_xcount_full(cSent) } buf: pbyte; cSent: ULONG): HRESULT; stdcall;

        function Finish_Push(): HRESULT; stdcall;

    end;


    IPipeLong = interface(IUnknown)
        ['{DB2F3ACC-2F86-11d1-8E04-00C04FB9989A}']
        function Pull(
        {__RPC__out_ecount_part(cRequest, *pcReturned) } buf: PLONG; cRequest: ULONG;
        {__RPC__out } pcReturned: PULONG): HRESULT; stdcall;

        function Push(
        {__RPC__in_ecount_full(cSent) } buf: PLONG; cSent: ULONG): HRESULT; stdcall;

    end;


    AsyncIPipeLong = interface(IUnknown)
        ['{DB2F3ACD-2F86-11d1-8E04-00C04FB9989A}']
        function Begin_Pull(cRequest: ULONG): HRESULT; stdcall;

        function Finish_Pull(
        {__RPC__out_xcount_part(cRequest, *pcReturned) } buf: PLONG;
        {__RPC__out } pcReturned: PULONG): HRESULT; stdcall;

        function Begin_Push(
        {__RPC__in_xcount_full(cSent) } buf: PLONG; cSent: ULONG): HRESULT; stdcall;

        function Finish_Push(): HRESULT; stdcall;

    end;


    IPipeDouble = interface(IUnknown)
        ['{DB2F3ACE-2F86-11d1-8E04-00C04FB9989A}']
        function Pull(
        {__RPC__out_ecount_part(cRequest, *pcReturned) } buf: Pdouble; cRequest: ULONG;
        {__RPC__out } pcReturned: PULONG): HRESULT; stdcall;

        function Push(
        {__RPC__in_ecount_full(cSent) } buf: Pdouble; cSent: ULONG): HRESULT; stdcall;

    end;


    AsyncIPipeDouble = interface(IUnknown)
        ['{DB2F3ACF-2F86-11d1-8E04-00C04FB9989A}']
        function Begin_Pull(cRequest: ULONG): HRESULT; stdcall;

        function Finish_Pull(
        {__RPC__out_xcount_part(cRequest, *pcReturned) } buf: Pdouble;
        {__RPC__out } pcReturned: PULONG): HRESULT; stdcall;

        function Begin_Push(
        {__RPC__in_xcount_full(cSent) } buf: Pdouble; cSent: ULONG): HRESULT; stdcall;

        function Finish_Push(): HRESULT; stdcall;

    end;


    TCPFLAGS = DWORD;
    PCPFLAGS = ^TCPFLAGS;

    tagContextProperty = record
        policyId: TGUID;
        flags: TCPFLAGS; (* [unique] *)
        pUnk: IUnknown;
    end;
    TContextProperty = tagContextProperty;
    PContextProperty = ^TContextProperty;


    IEnumContextProps = interface(IUnknown)
        ['{000001c1-0000-0000-C000-000000000046}']
        function Next(
        {_In_  } celt: ULONG;
        {_Out_writes_to_(celt, *pceltFetched)  } pContextProperties: PContextProperty;
        {_Out_  } pceltFetched: PULONG): HRESULT; stdcall;

        function Skip(
        {_In_  } celt: ULONG): HRESULT; stdcall;

        function Reset(): HRESULT; stdcall;

        function Clone(
        {_Outptr_  }  out ppEnumContextProps: IEnumContextProps): HRESULT; stdcall;

        function Count(
        {_Out_  } pcelt: PULONG): HRESULT; stdcall;

    end;


    IContext = interface(IUnknown)
        ['{000001c0-0000-0000-C000-000000000046}']
        function SetProperty(
        {_In_  } rpolicyId: REFGUID;
        {_In_  } flags: TCPFLAGS;
        {_In_  } pUnk: IUnknown): HRESULT; stdcall;

        function RemoveProperty(
        {_In_  } rPolicyId: REFGUID): HRESULT; stdcall;

        function GetProperty(
        {_In_  } rGuid: REFGUID;
        {_Out_  } pFlags: PCPFLAGS;
        {_Outptr_  }  out ppUnk: IUnknown): HRESULT; stdcall;

        function EnumContextProps(
        {_Outptr_  }  out ppEnumContextProps: IEnumContextProps): HRESULT; stdcall;

    end;


    IObjContext = interface(IContext)
        ['{000001c6-0000-0000-C000-000000000046}']
        procedure Reserved1(); stdcall;

        procedure Reserved2(); stdcall;

        procedure Reserved3(); stdcall;

        procedure Reserved4(); stdcall;

        procedure Reserved5(); stdcall;

        procedure Reserved6(); stdcall;

        procedure Reserved7(); stdcall;

    end;


    _APTTYPEQUALIFIER = (
        APTTYPEQUALIFIER_NONE = 0,
        APTTYPEQUALIFIER_IMPLICIT_MTA = 1,
        APTTYPEQUALIFIER_NA_ON_MTA = 2,
        APTTYPEQUALIFIER_NA_ON_STA = 3,
        APTTYPEQUALIFIER_NA_ON_IMPLICIT_MTA = 4,
        APTTYPEQUALIFIER_NA_ON_MAINSTA = 5,
        APTTYPEQUALIFIER_APPLICATION_STA = 6,
        APTTYPEQUALIFIER_RESERVED_1 = 7
        );

    TAPTTYPEQUALIFIER = _APTTYPEQUALIFIER;
    PAPTTYPEQUALIFIER = ^TAPTTYPEQUALIFIER;


    _APTTYPE = (
        APTTYPE_CURRENT = -1,
        APTTYPE_STA = 0,
        APTTYPE_MTA = 1,
        APTTYPE_NA = 2,
        APTTYPE_MAINSTA = 3
        );

    TAPTTYPE = _APTTYPE;
    PAPTTYPE = ^TAPTTYPE;


    _THDTYPE = (
        THDTYPE_BLOCKMESSAGES = 0,
        THDTYPE_PROCESSMESSAGES = 1
        );

    TTHDTYPE = _THDTYPE;
    PTHDTYPE = ^TTHDTYPE;


    TAPARTMENTID = DWORD;


    IComThreadingInfo = interface(IUnknown)
        ['{000001ce-0000-0000-C000-000000000046}']
        function GetCurrentApartmentType(
        {_Out_  } pAptType: PAPTTYPE): HRESULT; stdcall;

        function GetCurrentThreadType(
        {_Out_  } pThreadType: PTHDTYPE): HRESULT; stdcall;

        function GetCurrentLogicalThreadId(
        {_Out_  } pguidLogicalThreadId: PGUID): HRESULT; stdcall;

        function SetCurrentLogicalThreadId(
        {_In_  } rguid: REFGUID): HRESULT; stdcall;

    end;


    IProcessInitControl = interface(IUnknown)
        ['{72380d55-8d2b-43a3-8513-2b6ef31434e9}']
        function ResetInitializerTimeout(dwSecondsRemaining: DWORD): HRESULT; stdcall;

    end;


    IFastRundown = interface(IUnknown)
        ['{00000040-0000-0000-C000-000000000046}']
    end;


    TCO_MARSHALING_CONTEXT_ATTRIBUTES = (
        CO_MARSHALING_SOURCE_IS_APP_CONTAINER = 0,
        CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_1 = longint($80000000),
        CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_2 = longint($80000001),
        CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_3 = longint($80000002),
        CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_4 = longint($80000003),
        CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_5 = longint($80000004),
        CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_6 = longint($80000005),
        CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_7 = longint($80000006),
        CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_8 = longint($80000007),
        CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_9 = longint($80000008),
        CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_10 = longint($80000009),
        CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_11 = longint($8000000a),
        CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_12 = longint($8000000b),
        CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_13 = longint($8000000c),
        CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_14 = longint($8000000d),
        CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_15 = longint($8000000e),
        CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_16 = longint($8000000f),
        CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_17 = longint($80000010),
        CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_18 = longint($80000011));

    PCO_MARSHALING_CONTEXT_ATTRIBUTES = ^TCO_MARSHALING_CONTEXT_ATTRIBUTES;


    IMarshalingStream = interface(IStream)
        ['{D8F2F5E6-6102-4863-9F26-389A4676EFDE}']
        function GetMarshalingContextAttribute(attribute: TCO_MARSHALING_CONTEXT_ATTRIBUTES; pAttributeValue: PULONG_PTR): HRESULT; stdcall;

    end;


    IAgileReference = interface(IUnknown)
        ['{C03F6A43-65A4-9818-987E-E0B810D2A6F2}']
        function Resolve(riid: REFIID; out ppvObjectReference): HRESULT; stdcall;

    end;


    TMachineGlobalObjectTableRegistrationToken__ = record
        unused: int32;
    end;
    TMachineGlobalObjectTableRegistrationToken = TMachineGlobalObjectTableRegistrationToken__;
    PMachineGlobalObjectTableRegistrationToken = ^TMachineGlobalObjectTableRegistrationToken;


    IMachineGlobalObjectTable = interface(IUnknown)
        ['{26d709ac-f70b-4421-a96f-d2878fafb00d}']
        function RegisterObject(clsid: REFCLSID; identifier: LPCWSTR; _object: IUnknown; token: PMachineGlobalObjectTableRegistrationToken): HRESULT; stdcall;

        function GetObject(clsid: REFCLSID; identifier: LPCWSTR; riid: REFIID; out ppv): HRESULT; stdcall;

        function RevokeObject(token: TMachineGlobalObjectTableRegistrationToken): HRESULT; stdcall;

    end;


    ISupportAllowLowerTrustActivation = interface(IUnknown)
        ['{e9956ef2-3828-4b4b-8fa9-7db61dee4954}']
    end;


    ISupportActivationFromPackage = interface(IUnknown)
        ['{0a18aae5-5caa-48c5-a9f4-6e46dcd58ad5}']
    end;


    ISupportCoAddComDependencyOnPackage = interface(IUnknown)
        ['{c8059efc-4e98-4fd0-bfc6-44190b80b823}']
    end;


    ISupportServerMustBeEqualOrGreaterPrivilegeActivation = interface(IUnknown)
        ['{5bdb3ee2-46bc-4313-b5fb-801c360ba5f9}']
    end;


    ISupportDoNotElevateServerActivation = interface(IUnknown)
        ['{40aefe22-3ff6-43dc-8108-c8c402d57b5c}']
    end;


    ISupportActivateAsActivatorPackaged = interface(IUnknown)
        ['{765d1df2-f0af-4ef8-aa50-84789ca330ed}']
    end;


    ISupportPackagedComRegistrationVisibility = interface(IUnknown)
        ['{8dc3444e-c7ee-449a-9fb8-b9173988d66a}']
    end;


    ISupportPackagedComElevationEnabledClasses = interface(IUnknown)
        ['{b4219019-f712-4d4f-ade7-f468276af0b8}']
    end;


    IPackagedComSyntaxSupport = interface(IUnknown)
        ['{8f146474-b228-48fb-a58c-105ebb273abc}']
        function GetSupportedVersion(supportedVersion: PUINT32): HRESULT; stdcall;

    end;


    IMallocSpy = interface(IUnknown)
        ['{0000001d-0000-0000-C000-000000000046}']
        function PreAlloc(
        {_In_  } cbRequest: SIZE_T): SIZE_T; stdcall;

        procedure PostAlloc(
        {_In_  } pActual: Pvoid); stdcall;

        procedure PreFree(
        {_In_  } pRequest: Pvoid;
        {_In_  } fSpyed: boolean); stdcall;

        procedure PostFree(
        {_In_  } fSpyed: boolean); stdcall;

        function PreRealloc(
        {_In_  } pRequest: Pvoid;
        {_In_  } cbRequest: SIZE_T;
        {_Outptr_  }  out ppNewRequest;
        {_In_  } fSpyed: boolean): SIZE_T; stdcall;

        procedure PostRealloc(
        {_In_  } pActual: Pvoid;
        {_In_  } fSpyed: boolean); stdcall;

        procedure PreGetSize(
        {_In_  } pRequest: Pvoid;
        {_In_  } fSpyed: boolean); stdcall;

        function PostGetSize(
        {_In_  } cbActual: SIZE_T;
        {_In_  } fSpyed: boolean): SIZE_T; stdcall;

        procedure PreDidAlloc(
        {_In_  } pRequest: Pvoid;
        {_In_  } fSpyed: boolean); stdcall;

        function PostDidAlloc(
        {_In_  } pRequest: Pvoid;
        {_In_  } fSpyed: boolean;
        {_In_  } fActual: int32): int32; stdcall;

        procedure PreHeapMinimize(); stdcall;

        procedure PostHeapMinimize(); stdcall;

    end;


    tagBIND_OPTS = record
        cbStruct: DWORD;
        grfFlags: DWORD;
        grfMode: DWORD;
        dwTickCountDeadline: DWORD;
    end;
    TBIND_OPTS = tagBIND_OPTS;
    PBIND_OPTS = ^TBIND_OPTS;
    LPBIND_OPTS = ^TBIND_OPTS;


    tagBIND_OPTS2 = record
        cbStruct: DWORD;
        grfFlags: DWORD;
        grfMode: DWORD;
        dwTickCountDeadline: DWORD;
        dwTrackFlags: DWORD;
        dwClassContext: DWORD;
        locale: LCID;
        pServerInfo: PCOSERVERINFO;
    end;
    TBIND_OPTS2 = tagBIND_OPTS2;
    PBIND_OPTS2 = ^TBIND_OPTS2;
    LPBIND_OPTS2 = ^TBIND_OPTS2;

    tagBIND_OPTS3 = record
        cbStruct: DWORD;
        grfFlags: DWORD;
        grfMode: DWORD;
        dwTickCountDeadline: DWORD;
        dwTrackFlags: DWORD;
        dwClassContext: DWORD;
        locale: LCID;
        pServerInfo: PCOSERVERINFO;
        hwnd: HWND;
    end;
    TBIND_OPTS3 = tagBIND_OPTS3;
    PBIND_OPTS3 = ^TBIND_OPTS3;

    LPBIND_OPTS3 = ^TBIND_OPTS3;


    tagBIND_FLAGS = (
        BIND_MAYBOTHERUSER = 1,
        BIND_JUSTTESTEXISTENCE = 2);

    TBIND_FLAGS = tagBIND_FLAGS;
    PBIND_FLAGS = ^TBIND_FLAGS;

    IBindCtx = interface(IUnknown)
        ['{0000000e-0000-0000-C000-000000000046}']
        function RegisterObjectBound(
        {__RPC__in_opt } punk: IUnknown): HRESULT; stdcall;

        function RevokeObjectBound(
        {__RPC__in_opt } punk: IUnknown): HRESULT; stdcall;

        function ReleaseBoundObjects(): HRESULT; stdcall;

        function SetBindOptions(
        {_In_  } pbindopts: PBIND_OPTS): HRESULT; stdcall;

        function GetBindOptions(
        {_Inout_  } pbindopts: PBIND_OPTS): HRESULT; stdcall;

        function GetRunningObjectTable(
        {__RPC__deref_out_opt }  out pprot: IRunningObjectTable): HRESULT; stdcall;

        function RegisterObjectParam(
        {__RPC__in } pszKey: LPOLESTR;
        {__RPC__in_opt } punk: IUnknown): HRESULT; stdcall;

        function GetObjectParam(
        {__RPC__in } pszKey: LPOLESTR;
        {__RPC__deref_out_opt }  out ppunk: IUnknown): HRESULT; stdcall;

        function EnumObjectParam(
        {__RPC__deref_out_opt }  out ppenum: IEnumString): HRESULT; stdcall;

        function RevokeObjectParam(
        {__RPC__in } pszKey: LPOLESTR): HRESULT; stdcall;

    end;

    LPBC = ^IBindCtx;
    LPBINDCTX = ^IBindCtx;


    IEnumMoniker = interface(IUnknown)
        ['{00000102-0000-0000-C000-000000000046}']
        function Next(celt: ULONG;
        {_Out_writes_to_(celt,*pceltFetched)  }  out rgelt: IMoniker;
        {_Out_opt_  } pceltFetched: PULONG): HRESULT; stdcall;

        function Skip(celt: ULONG): HRESULT; stdcall;

        function Reset(): HRESULT; stdcall;

        function Clone(
        {__RPC__deref_out_opt }  out ppenum: IEnumMoniker): HRESULT; stdcall;

    end;


    IRunnableObject = interface(IUnknown)
        ['{00000126-0000-0000-C000-000000000046}']
        function GetRunningClass(
        {__RPC__out } lpClsid: LPCLSID): HRESULT; stdcall;

        function Run(
        {__RPC__in_opt } pbc: LPBINDCTX): HRESULT; stdcall;

        function IsRunning(): boolean; stdcall;

        function LockRunning(fLock: boolean; fLastUnlockCloses: boolean): HRESULT; stdcall;

        function SetContainedObject(fContained: boolean): HRESULT; stdcall;

    end;


    IRunningObjectTable = interface(IUnknown)
        ['{00000010-0000-0000-C000-000000000046}']
        function Register(grfFlags: DWORD;
        {__RPC__in_opt } punkObject: IUnknown;
        {__RPC__in_opt } pmkObjectName: IMoniker;
        {__RPC__out } pdwRegister: PDWORD): HRESULT; stdcall;

        function Revoke(dwRegister: DWORD): HRESULT; stdcall;

        function IsRunning(
        {__RPC__in_opt } pmkObjectName: IMoniker): HRESULT; stdcall;

        function GetObject(
        {__RPC__in_opt } pmkObjectName: IMoniker;
        {__RPC__deref_out_opt }  out ppunkObject: IUnknown): HRESULT; stdcall;

        function NoteChangeTime(dwRegister: DWORD;
        {__RPC__in } pfiletime: PFILETIME): HRESULT; stdcall;

        function GetTimeOfLastChange(
        {__RPC__in_opt } pmkObjectName: IMoniker;
        {__RPC__out } pfiletime: PFILETIME): HRESULT; stdcall;

        function EnumRunning(
        {__RPC__deref_out_opt }  out ppenumMoniker: IEnumMoniker): HRESULT; stdcall;

    end;


    IPersist = interface(IUnknown)
        ['{0000010c-0000-0000-C000-000000000046}']
        function GetClassID(
        {__RPC__out } pClassID: PCLSID): HRESULT; stdcall;

    end;


    IPersistStream = interface(IPersist)
        ['{00000109-0000-0000-C000-000000000046}']
        function IsDirty(): HRESULT; stdcall;

        function Load(
        {__RPC__in_opt } pStm: IStream): HRESULT; stdcall;

        function Save(
        {__RPC__in_opt } pStm: IStream; fClearDirty: boolean): HRESULT; stdcall;

        function GetSizeMax(
        {__RPC__out } pcbSize: PULARGE_INTEGER): HRESULT; stdcall;

    end;


    tagMKSYS = (
        MKSYS_NONE = 0,
        MKSYS_GENERICCOMPOSITE = 1,
        MKSYS_FILEMONIKER = 2,
        MKSYS_ANTIMONIKER = 3,
        MKSYS_ITEMMONIKER = 4,
        MKSYS_POINTERMONIKER = 5,
        MKSYS_CLASSMONIKER = 7,
        MKSYS_OBJREFMONIKER = 8,
        MKSYS_SESSIONMONIKER = 9,
        MKSYS_LUAMONIKER = 10);

    TMKSYS = tagMKSYS;
    PMKSYS = ^TMKSYS;


    tagMKREDUCE = (
        MKRREDUCE_ONE = (3 shl 16),
        MKRREDUCE_TOUSER = (2 shl 16),
        MKRREDUCE_THROUGHUSER = (1 shl 16),
        MKRREDUCE_ALL = 0);

    TMKREDUCE = tagMKREDUCE;
    PMKREDUCE = ^TMKREDUCE;

    TMKRREDUCE = TMKREDUCE;


    IMoniker = interface(IPersistStream)
        ['{0000000f-0000-0000-C000-000000000046}']
        function BindToObject(
        {_In_  } pbc: IBindCtx;
        {_In_opt_  } pmkToLeft: IMoniker;
        {_In_  } riidResult: REFIID;
        {_Outptr_  }  out ppvResult): HRESULT; stdcall;

        function BindToStorage(
        {_In_  } pbc: IBindCtx;
        {_In_opt_  } pmkToLeft: IMoniker;
        {_In_  } riid: REFIID;
        {_Outptr_  }  out ppvObj): HRESULT; stdcall;

        function Reduce(
        {__RPC__in_opt } pbc: IBindCtx; dwReduceHowFar: DWORD;
        {__RPC__deref_opt_inout_opt } var ppmkToLeft: IMoniker;
        {__RPC__deref_out_opt }  out ppmkReduced: IMoniker): HRESULT; stdcall;

        function ComposeWith(
        {__RPC__in_opt } pmkRight: IMoniker; fOnlyIfNotGeneric: boolean;
        {__RPC__deref_out_opt }  out ppmkComposite: IMoniker): HRESULT; stdcall;

        function Enum(fForward: boolean;
        {__RPC__deref_out_opt }  out ppenumMoniker: IEnumMoniker): HRESULT; stdcall;

        function IsEqual(
        {__RPC__in_opt } pmkOtherMoniker: IMoniker): HRESULT; stdcall;

        function Hash(
        {__RPC__out } pdwHash: PDWORD): HRESULT; stdcall;

        function IsRunning(
        {__RPC__in_opt } pbc: IBindCtx;
        {__RPC__in_opt } pmkToLeft: IMoniker;
        {__RPC__in_opt } pmkNewlyRunning: IMoniker): HRESULT; stdcall;

        function GetTimeOfLastChange(
        {__RPC__in_opt } pbc: IBindCtx;
        {__RPC__in_opt } pmkToLeft: IMoniker;
        {__RPC__out } pFileTime: PFILETIME): HRESULT; stdcall;

        function Inverse(
        {__RPC__deref_out_opt }  out ppmk: IMoniker): HRESULT; stdcall;

        function CommonPrefixWith(
        {__RPC__in_opt } pmkOther: IMoniker;
        {__RPC__deref_out_opt }  out ppmkPrefix: IMoniker): HRESULT; stdcall;

        function RelativePathTo(
        {__RPC__in_opt } pmkOther: IMoniker;
        {__RPC__deref_out_opt }  out ppmkRelPath: IMoniker): HRESULT; stdcall;

        function GetDisplayName(
        {__RPC__in_opt } pbc: IBindCtx;
        {__RPC__in_opt } pmkToLeft: IMoniker;
        {__RPC__deref_out_opt } ppszDisplayName: LPOLESTR): HRESULT; stdcall;

        function ParseDisplayName(
        {__RPC__in_opt } pbc: IBindCtx;
        {__RPC__in_opt } pmkToLeft: IMoniker;
        {__RPC__in } pszDisplayName: LPOLESTR;
        {__RPC__out } pchEaten: PULONG;
        {__RPC__deref_out_opt }  out ppmkOut: IMoniker): HRESULT; stdcall;

        function IsSystemMoniker(
        {__RPC__out } pdwMksys: PDWORD): HRESULT; stdcall;

    end;


    IROTData = interface(IUnknown)
        ['{f29f6bc0-5021-11ce-aa15-00006901293f}']
        function GetComparisonData(
        {__RPC__out_ecount_full(cbMax) } pbData: pbyte; cbMax: ULONG;
        {__RPC__out } pcbData: PULONG): HRESULT; stdcall;

    end;


    IEnumSTATSTG = interface(IUnknown)
        ['{0000000d-0000-0000-C000-000000000046}']
        function Next(celt: ULONG;
        {_Out_writes_to_(celt,*pceltFetched)  } rgelt: PSTATSTG;
        {_Out_opt_  } pceltFetched: PULONG): HRESULT; stdcall;

        function Skip(celt: ULONG): HRESULT; stdcall;

        function Reset(): HRESULT; stdcall;

        function Clone(
        {__RPC__deref_out_opt }  out ppenum: IEnumSTATSTG): HRESULT; stdcall;

    end;


    tagRemSNB = record
        ulCntStr: ULONG;
        ulCntChar: ULONG; (* [size_is] *)
        rgString: POLECHAR;
    end;
    TRemSNB = tagRemSNB;
    PRemSNB = ^TRemSNB;

    wireSNB = ^TRemSNB;
    SNB = ^LPOLESTR;
    TSNB = SNB;
    PSNB = ^TSNB;


    IStorage = interface(IUnknown)
        ['{0000000b-0000-0000-C000-000000000046}']
        function CreateStream(
        {__RPC__in_string } pwcsName: POLECHAR; grfMode: DWORD; reserved1: DWORD; reserved2: DWORD;
        {__RPC__deref_out_opt }  out ppstm: IStream): HRESULT; stdcall;

        function OpenStream(
        {_In_z_  } pwcsName: POLECHAR;
        {_Reserved_  } reserved1: Pvoid; grfMode: DWORD; reserved2: DWORD;
        {_Outptr_  }  out ppstm: IStream): HRESULT; stdcall;

        function CreateStorage(
        {__RPC__in_string } pwcsName: POLECHAR; grfMode: DWORD; reserved1: DWORD; reserved2: DWORD;
        {__RPC__deref_out_opt }  out ppstg: IStorage): HRESULT; stdcall;

        function OpenStorage(
        {__RPC__in_opt_string } pwcsName: POLECHAR;
        {__RPC__in_opt } pstgPriority: IStorage; grfMode: DWORD;
        {__RPC__deref_opt_in_opt } snbExclude: TSNB; reserved: DWORD;
        {__RPC__deref_out_opt }  out ppstg: IStorage): HRESULT; stdcall;

        function CopyTo(ciidExclude: DWORD;
        {_In_reads_opt_(ciidExclude)  } rgiidExclude: IID;
        {_In_opt_  } snbExclude: TSNB;
        {_In_  } pstgDest: IStorage): HRESULT; stdcall;

        function MoveElementTo(
        {__RPC__in_string } pwcsName: POLECHAR;
        {__RPC__in_opt } pstgDest: IStorage;
        {__RPC__in_string } pwcsNewName: POLECHAR; grfFlags: DWORD): HRESULT; stdcall;

        function Commit(grfCommitFlags: DWORD): HRESULT; stdcall;

        function Revert(): HRESULT; stdcall;

        function EnumElements(
        {_Reserved_  } reserved1: DWORD;
        {_Reserved_  } reserved2: Pvoid;
        {_Reserved_  } reserved3: DWORD;
        {_Outptr_  }  out ppenum: IEnumSTATSTG): HRESULT; stdcall;

        function DestroyElement(
        {__RPC__in_string } pwcsName: POLECHAR): HRESULT; stdcall;

        function RenameElement(
        {__RPC__in_string } pwcsOldName: POLECHAR;
        {__RPC__in_string } pwcsNewName: POLECHAR): HRESULT; stdcall;

        function SetElementTimes(
        {__RPC__in_opt_string } pwcsName: POLECHAR;
        {__RPC__in_opt } pctime: PFILETIME;
        {__RPC__in_opt } patime: PFILETIME;
        {__RPC__in_opt } pmtime: PFILETIME): HRESULT; stdcall;

        function SetClass(
        {__RPC__in } clsid: REFCLSID): HRESULT; stdcall;

        function SetStateBits(grfStateBits: DWORD; grfMask: DWORD): HRESULT; stdcall;

        function Stat(
        {__RPC__out } pstatstg: PSTATSTG; grfStatFlag: DWORD): HRESULT; stdcall;

    end;

    PIStorage = ^IStorage;


    IPersistFile = interface(IPersist)
        ['{0000010b-0000-0000-C000-000000000046}']
        function IsDirty(): HRESULT; stdcall;

        function Load(
        {__RPC__in } pszFileName: LPCOLESTR; dwMode: DWORD): HRESULT; stdcall;

        function Save(
        {__RPC__in_opt } pszFileName: LPCOLESTR; fRemember: boolean): HRESULT; stdcall;

        function SaveCompleted(
        {__RPC__in_opt } pszFileName: LPCOLESTR): HRESULT; stdcall;

        function GetCurFile(
        {__RPC__deref_out_opt } ppszFileName: PLPOLESTR): HRESULT; stdcall;

    end;


    IPersistStorage = interface(IPersist)
        ['{0000010a-0000-0000-C000-000000000046}']
        function IsDirty(): HRESULT; stdcall;

        function InitNew(
        {__RPC__in_opt } pStg: IStorage): HRESULT; stdcall;

        function Load(
        {__RPC__in_opt } pStg: IStorage): HRESULT; stdcall;

        function Save(
        {__RPC__in_opt } pStgSave: IStorage; fSameAsLoad: boolean): HRESULT; stdcall;

        function SaveCompleted(
        {__RPC__in_opt } pStgNew: IStorage): HRESULT; stdcall;

        function HandsOffStorage(): HRESULT; stdcall;

    end;


    ILockBytes = interface(IUnknown)
        ['{0000000a-0000-0000-C000-000000000046}']
        function ReadAt(ulOffset: ULARGE_INTEGER;
        {_Out_writes_bytes_to_(cb, *pcbRead)  } pv: Pvoid; cb: ULONG;
        {_Out_opt_  } pcbRead: PULONG): HRESULT; stdcall;

        function WriteAt(ulOffset: ULARGE_INTEGER;
        {_In_reads_bytes_(cb)  } pv: Pvoid; cb: ULONG;
        {_Out_opt_  } pcbWritten: PULONG): HRESULT; stdcall;

        function Flush(): HRESULT; stdcall;

        function SetSize(cb: ULARGE_INTEGER): HRESULT; stdcall;

        function LockRegion(libOffset: ULARGE_INTEGER; cb: ULARGE_INTEGER; dwLockType: DWORD): HRESULT; stdcall;

        function UnlockRegion(libOffset: ULARGE_INTEGER; cb: ULARGE_INTEGER; dwLockType: DWORD): HRESULT; stdcall;

        function Stat(
        {__RPC__out } pstatstg: PSTATSTG; grfStatFlag: DWORD): HRESULT; stdcall;

    end;


    tagDVTARGETDEVICE = record
        tdSize: DWORD;
        tdDriverNameOffset: word;
        tdDeviceNameOffset: word;
        tdPortNameOffset: word;
        tdExtDevmodeOffset: word; (* [size_is] *)
        tdData: pbyte;
    end;
    TDVTARGETDEVICE = tagDVTARGETDEVICE;
    PDVTARGETDEVICE = ^TDVTARGETDEVICE;


    TCLIPFORMAT = word;
    LPCLIPFORMAT = ^TCLIPFORMAT;

    tagFORMATETC = record
        cfFormat: TCLIPFORMAT; (* [unique] *)
        ptd: PDVTARGETDEVICE;
        dwAspect: DWORD;
        lindex: LONG;
        tymed: DWORD;
    end;
    TFORMATETC = tagFORMATETC;
    PFORMATETC = ^TFORMATETC;


    IEnumFORMATETC = interface(IUnknown)
        ['{00000103-0000-0000-C000-000000000046}']
        function Next(celt: ULONG;
        {_Out_writes_to_(celt,*pceltFetched)  } rgelt: PFORMATETC;
        {_Out_opt_  } pceltFetched: PULONG): HRESULT; stdcall;

        function Skip(celt: ULONG): HRESULT; stdcall;

        function Reset(): HRESULT; stdcall;

        function Clone(
        {__RPC__deref_out_opt }  out ppenum: IEnumFORMATETC): HRESULT; stdcall;

    end;


    tagADVF = (
        ADVF_NODATA = 1,
        ADVF_PRIMEFIRST = 2,
        ADVF_ONLYONCE = 4,
        ADVF_DATAONSTOP = 64,
        ADVFCACHE_NOHANDLER = 8,
        ADVFCACHE_FORCEBUILTIN = 16,
        ADVFCACHE_ONSAVE = 32);

    TADVF = tagADVF;
    PADVF = ^TADVF;


    tagSTATDATA = record
        formatetc: TFORMATETC;
        advf: DWORD; (* [unique] *)
        pAdvSink: IAdviseSink;
        dwConnection: DWORD;
    end;
    TSTATDATA = tagSTATDATA;
    PSTATDATA = ^TSTATDATA;


    PLPSTATDATA = ^TSTATDATA;


    IEnumSTATDATA = interface(IUnknown)
        ['{00000105-0000-0000-C000-000000000046}']
        function Next(celt: ULONG;
        {_Out_writes_to_(celt,*pceltFetched)  } rgelt: PSTATDATA;
        {_Out_opt_  } pceltFetched: PULONG): HRESULT; stdcall;

        function Skip(celt: ULONG): HRESULT; stdcall;

        function Reset(): HRESULT; stdcall;

        function Clone(
        {__RPC__deref_out_opt }  out ppenum: IEnumSTATDATA): HRESULT; stdcall;

    end;


    IRootStorage = interface(IUnknown)
        ['{00000012-0000-0000-C000-000000000046}']
        function SwitchToFile(
        {__RPC__in } pszFile: LPOLESTR): HRESULT; stdcall;

    end;


    tagTYMED = (
        TYMED_HGLOBAL = 1,
        TYMED_FILE = 2,
        TYMED_ISTREAM = 4,
        TYMED_ISTORAGE = 8,
        TYMED_GDI = 16,
        TYMED_MFPICT = 32,
        TYMED_ENHMF = 64,
        TYMED_NULL = 0);

    TTYMED = tagTYMED;
    PTYMED = ^TTYMED;


    tagRemSTGMEDIUM = record
        tymed: DWORD;
        dwHandleType: DWORD;
        pData: ULONG;
        pUnkForRelease: ULONG;
        cbData: ULONG; (* [size_is] *)
        Data: pbyte;
    end;
    TRemSTGMEDIUM = tagRemSTGMEDIUM;
    PRemSTGMEDIUM = ^TRemSTGMEDIUM;


    tagSTGMEDIUM = record
        tymed: DWORD;
        case integer of
            0: (
                hBitmap: HBITMAP;
                pUnkForRelease: PIUnknown;
            );
            1: (
                hMetaFilePict: HMETAFILEPICT;
            );
            2: (
                hEnhMetaFile: HENHMETAFILE;
            );
            3: (
                hGlobal: HGLOBAL;
            );
            4: (
                lpszFileName: LPOLESTR;
            );
            5: (
                pstm: PIStream;
            );
            6: (
                pstg: PIStorage;
            );

    end;
    TSTGMEDIUM = tagSTGMEDIUM;
    PSTGMEDIUM = ^TSTGMEDIUM;

    uSTGMEDIUM = TSTGMEDIUM;


    _GDI_OBJECT = record
        ObjectType: DWORD; (* [switch_type] *)
        case integer of
            (* [case()] *)
            0: (
                hBitmap: wireHBITMAP;
            );
            (* [case()] *)
            1: (
                hPalette: wireHPALETTE;
            );
            (* [default] *)
            2: (
                hGeneric: wireHGLOBAL;
            );

    end;
    TGDI_OBJECT = _GDI_OBJECT;
    PGDI_OBJECT = ^TGDI_OBJECT;


    _userSTGMEDIUM = record
        _STGMEDIUM_UNION: record
            tymed: DWORD; (* [switch_type] *)
            case integer of
                (* [case()] *)
                0: (
                    hMetaFilePict: wireHMETAFILEPICT;
                );
                (* [case()] *)
                1: (
                    hHEnhMetaFile: wireHENHMETAFILE;
                );
                (* [case()] *)
                2: (
                    hGdiHandle: PGDI_OBJECT;
                );
                (* [case()] *)
                3: (
                    hGlobal: wireHGLOBAL;
                );
                (* [case()] *)
                4: (
                    lpszFileName: LPOLESTR;
                );
                (* [case()] *)
                5: (
                    pstm: PBYTE_BLOB;
                );
                (* [case()] *)
                6: (
                    pstg: PBYTE_BLOB;
                );
            end;
        pUnkForRelease: PIUnknown;
    end;
    TuserSTGMEDIUM = _userSTGMEDIUM;
    PuserSTGMEDIUM = ^TuserSTGMEDIUM;

    wireSTGMEDIUM = ^TuserSTGMEDIUM;

    STGMEDIUM = uSTGMEDIUM;

    wireASYNC_STGMEDIUM = ^TuserSTGMEDIUM;

    ASYNC_STGMEDIUM = STGMEDIUM;

    LPSTGMEDIUM = ^STGMEDIUM;


    _userFLAG_STGMEDIUM = record
        ContextFlags: LONG;
        fPassOwnership: LONG;
        Stgmed: TuserSTGMEDIUM;
    end;
    TuserFLAG_STGMEDIUM = _userFLAG_STGMEDIUM;
    PuserFLAG_STGMEDIUM = ^TuserFLAG_STGMEDIUM;

    wireFLAG_STGMEDIUM = ^TuserFLAG_STGMEDIUM;

    _FLAG_STGMEDIUM = record
        ContextFlags: LONG;
        fPassOwnership: LONG;
        Stgmed: TSTGMEDIUM;
    end;
    TFLAG_STGMEDIUM = _FLAG_STGMEDIUM;
    PFLAG_STGMEDIUM = ^TFLAG_STGMEDIUM;


    IAdviseSink = interface(IUnknown)
        ['{0000010f-0000-0000-C000-000000000046}']
        procedure OnDataChange(
        {_In_  } pFormatetc: PFORMATETC;
        {_In_  } pStgmed: PSTGMEDIUM); stdcall;

        procedure OnViewChange(dwAspect: DWORD; lindex: LONG); stdcall;

        procedure OnRename(
        {_In_  } pmk: IMoniker); stdcall;

        procedure OnSave(); stdcall;

        procedure OnClose(); stdcall;

    end;


    AsyncIAdviseSink = interface(IUnknown)
        ['{00000150-0000-0000-C000-000000000046}']
        procedure Begin_OnDataChange(
        {_In_  } pFormatetc: PFORMATETC;
        {_In_  } pStgmed: PSTGMEDIUM); stdcall;

        procedure Finish_OnDataChange(); stdcall;

        procedure Begin_OnViewChange(dwAspect: DWORD; lindex: LONG); stdcall;

        procedure Finish_OnViewChange(); stdcall;

        procedure Begin_OnRename(
        {_In_  } pmk: IMoniker); stdcall;

        procedure Finish_OnRename(); stdcall;

        procedure Begin_OnSave(); stdcall;

        procedure Finish_OnSave(); stdcall;

        procedure Begin_OnClose(); stdcall;

        procedure Finish_OnClose(); stdcall;

    end;


    IAdviseSink2 = interface(IAdviseSink)
        ['{00000125-0000-0000-C000-000000000046}']
        procedure OnLinkSrcChange(
        {_In_  } pmk: IMoniker); stdcall;

    end;


    AsyncIAdviseSink2 = interface(AsyncIAdviseSink)
        ['{00000151-0000-0000-C000-000000000046}']
        procedure Begin_OnLinkSrcChange(
        {_In_  } pmk: IMoniker); stdcall;

        procedure Finish_OnLinkSrcChange(); stdcall;

    end;


    tagDATADIR = (
        DATADIR_GET = 1,
        DATADIR_SET = 2);

    TDATADIR = tagDATADIR;
    PDATADIR = ^TDATADIR;


    IDataObject = interface(IUnknown)
        ['{0000010e-0000-0000-C000-000000000046}']
        function GetData(
        {_In_  } pformatetcIn: PFORMATETC;
        {_Out_  } pmedium: PSTGMEDIUM): HRESULT; stdcall;

        function GetDataHere(
        {_In_  } pformatetc: PFORMATETC;
        {_Inout_  } pmedium: PSTGMEDIUM): HRESULT; stdcall;

        function QueryGetData(
        {__RPC__in_opt } pformatetc: PFORMATETC): HRESULT; stdcall;

        function GetCanonicalFormatEtc(
        {__RPC__in_opt } pformatectIn: PFORMATETC;
        {__RPC__out } pformatetcOut: PFORMATETC): HRESULT; stdcall;

        function SetData(
        {_In_  } pformatetc: PFORMATETC;
        {_In_  } pmedium: PSTGMEDIUM; fRelease: boolean): HRESULT; stdcall;

        function EnumFormatEtc(dwDirection: DWORD;
        {__RPC__deref_out_opt }  out ppenumFormatEtc: IEnumFORMATETC): HRESULT; stdcall;

        function DAdvise(
        {__RPC__in } pformatetc: PFORMATETC; advf: DWORD;
        {__RPC__in_opt } pAdvSink: IAdviseSink;
        {__RPC__out } pdwConnection: PDWORD): HRESULT; stdcall;

        function DUnadvise(dwConnection: DWORD): HRESULT; stdcall;

        function EnumDAdvise(
        {__RPC__deref_out_opt }  out ppenumAdvise: IEnumSTATDATA): HRESULT; stdcall;

    end;


    IDataAdviseHolder = interface(IUnknown)
        ['{00000110-0000-0000-C000-000000000046}']
        function Advise(
        {_In_opt_  } pDataObject: IDataObject;
        {_In_  } pFetc: PFORMATETC;
        {_In_  } advf: DWORD;
        {_In_  } pAdvise: IAdviseSink;
        {_Out_  } pdwConnection: PDWORD): HRESULT; stdcall;

        function Unadvise(
        {_In_  } dwConnection: DWORD): HRESULT; stdcall;

        function EnumAdvise(
        {_Outptr_  }  out ppenumAdvise: IEnumSTATDATA): HRESULT; stdcall;

        function SendOnDataChange(
        {_In_  } pDataObject: IDataObject;
        {_Reserved_  } dwReserved: DWORD;
        {_In_  } advf: DWORD): HRESULT; stdcall;

    end;


    tagCALLTYPE = (
        CALLTYPE_TOPLEVEL = 1,
        CALLTYPE_NESTED = 2,
        CALLTYPE_ASYNC = 3,
        CALLTYPE_TOPLEVEL_CALLPENDING = 4,
        CALLTYPE_ASYNC_CALLPENDING = 5);

    TCALLTYPE = tagCALLTYPE;
    PCALLTYPE = ^TCALLTYPE;


    tagSERVERCALL = (
        SERVERCALL_ISHANDLED = 0,
        SERVERCALL_REJECTED = 1,
        SERVERCALL_RETRYLATER = 2);

    TSERVERCALL = tagSERVERCALL;
    PSERVERCALL = ^TSERVERCALL;


    tagPENDINGTYPE = (
        PENDINGTYPE_TOPLEVEL = 1,
        PENDINGTYPE_NESTED = 2);

    TPENDINGTYPE = tagPENDINGTYPE;
    PPENDINGTYPE = ^TPENDINGTYPE;


    tagPENDINGMSG = (
        PENDINGMSG_CANCELCALL = 0,
        PENDINGMSG_WAITNOPROCESS = 1,
        PENDINGMSG_WAITDEFPROCESS = 2);

    TPENDINGMSG = tagPENDINGMSG;
    PPENDINGMSG = ^TPENDINGMSG;


    tagINTERFACEINFO = record
        pUnk: PIUnknown;
        iid: TIID;
        wMethod: word;
    end;
    TINTERFACEINFO = tagINTERFACEINFO;
    PINTERFACEINFO = ^TINTERFACEINFO;
    LPINTERFACEINFO = ^TINTERFACEINFO;


    IMessageFilter = interface(IUnknown)
        ['{00000016-0000-0000-C000-000000000046}']
        function HandleInComingCall(
        {_In_  } dwCallType: DWORD;
        {_In_  } htaskCaller: HTASK;
        {_In_  } dwTickCount: DWORD;
        {_In_opt_  } lpInterfaceInfo: LPINTERFACEINFO): DWORD; stdcall;

        function RetryRejectedCall(
        {_In_  } htaskCallee: HTASK;
        {_In_  } dwTickCount: DWORD;
        {_In_  } dwRejectType: DWORD): DWORD; stdcall;

        function MessagePending(
        {_In_  } htaskCallee: HTASK;
        {_In_  } dwTickCount: DWORD;
        {_In_  } dwPendingType: DWORD): DWORD; stdcall;

    end;


    IClassActivator = interface(IUnknown)
        ['{00000140-0000-0000-C000-000000000046}']
        function GetClassObject(
        {__RPC__in } rclsid: REFCLSID; dwClassContext: DWORD; locale: LCID;
        {__RPC__in } riid: REFIID;
        {__RPC__deref_out_opt }  out ppv): HRESULT; stdcall;

    end;


    IFillLockBytes = interface(IUnknown)
        ['{99caf010-415e-11cf-8814-00aa00b569f5}']
        function FillAppend(
        {_In_reads_bytes_(cb)  } pv: Pvoid;
        {_In_  } cb: ULONG;
        {_Out_  } pcbWritten: PULONG): HRESULT; stdcall;

        function FillAt(
        {_In_  } ulOffset: ULARGE_INTEGER;
        {_In_reads_bytes_(cb)  } pv: Pvoid;
        {_In_  } cb: ULONG;
        {_Out_  } pcbWritten: PULONG): HRESULT; stdcall;

        function SetFillSize(ulSize: ULARGE_INTEGER): HRESULT; stdcall;

        function Terminate(bCanceled: boolean): HRESULT; stdcall;

    end;


    IProgressNotify = interface(IUnknown)
        ['{a9d758a0-4617-11cf-95fc-00aa00680db4}']
        function OnProgress(dwProgressCurrent: DWORD; dwProgressMaximum: DWORD; fAccurate: boolean; fOwner: boolean): HRESULT; stdcall;

    end;


    tagStorageLayout = record
        LayoutType: DWORD;
        pwcsElementName: POLECHAR;
        cOffset: LARGE_INTEGER;
        cBytes: LARGE_INTEGER;
    end;
    TStorageLayout = tagStorageLayout;
    PStorageLayout = ^TStorageLayout;


    ILayoutStorage = interface(IUnknown)
        ['{0e6d4d90-6738-11cf-9608-00aa00680db4}']
        function LayoutScript(
        {_In_reads_(nEntries)  } pStorageLayout: PStorageLayout;
        {_In_  } nEntries: DWORD;
        {_Reserved_  } glfInterleavedFlag: DWORD): HRESULT; stdcall;

        function BeginMonitor(): HRESULT; stdcall;

        function EndMonitor(): HRESULT; stdcall;

        function ReLayoutDocfile(
        {__RPC__in  } pwcsNewDfName: POLECHAR): HRESULT; stdcall;

        function ReLayoutDocfileOnILockBytes(
        {_In_  } pILockBytes: ILockBytes): HRESULT; stdcall;

    end;


    IBlockingLock = interface(IUnknown)
        ['{30f3d47a-6447-11d1-8e3c-00c04fb9386d}']
        function Lock(dwTimeout: DWORD): HRESULT; stdcall;

        function Unlock(): HRESULT; stdcall;

    end;


    ITimeAndNoticeControl = interface(IUnknown)
        ['{bc0bf6ae-8878-11d1-83e9-00c04fc2c6d4}']
        function SuppressChanges(res1: DWORD; res2: DWORD): HRESULT; stdcall;

    end;


    IOplockStorage = interface(IUnknown)
        ['{8d19c834-8879-11d1-83e9-00c04fc2c6d4}']
        function CreateStorageEx(
        {__RPC__in } pwcsName: LPCWSTR; grfMode: DWORD; stgfmt: DWORD; grfAttrs: DWORD;
        {__RPC__in } riid: REFIID;
        {__RPC__deref_out_opt }  out ppstgOpen): HRESULT; stdcall;

        function OpenStorageEx(
        {__RPC__in } pwcsName: LPCWSTR; grfMode: DWORD; stgfmt: DWORD; grfAttrs: DWORD;
        {__RPC__in } riid: REFIID;
        {__RPC__deref_out_opt }  out ppstgOpen): HRESULT; stdcall;

    end;


    IDirectWriterLock = interface(IUnknown)
        ['{0e6d4d92-6738-11cf-9608-00aa00680db4}']
        function WaitForWriteAccess(dwTimeout: DWORD): HRESULT; stdcall;

        function ReleaseWriteAccess(): HRESULT; stdcall;

        function HaveWriteAccess(): HRESULT; stdcall;

    end;


    IUrlMon = interface(IUnknown)
        ['{00000026-0000-0000-C000-000000000046}']
        function AsyncGetClassBits(
        {__RPC__in } rclsid: REFCLSID;
        {__RPC__in_opt } pszTYPE: LPCWSTR;
        {__RPC__in_opt } pszExt: LPCWSTR; dwFileVersionMS: DWORD; dwFileVersionLS: DWORD;
        {__RPC__in_opt } pszCodeBase: LPCWSTR;
        {__RPC__in_opt } pbc: IBindCtx; dwClassContext: DWORD;
        {__RPC__in } riid: REFIID; flags: DWORD): HRESULT; stdcall;

    end;


    IForegroundTransfer = interface(IUnknown)
        ['{00000145-0000-0000-C000-000000000046}']
        function AllowForegroundTransfer(
        {_Reserved_  } lpvReserved: Pvoid): HRESULT; stdcall;

    end;


    IThumbnailExtractor = interface(IUnknown)
        ['{969dc708-5c76-11d1-8d86-0000f804b057}']
        function ExtractThumbnail(
        {__RPC__in_opt } pStg: IStorage; ulLength: ULONG; ulHeight: ULONG;
        {__RPC__out } pulOutputLength: PULONG;
        {__RPC__out } pulOutputHeight: PULONG;
        {__RPC__deref_out_opt } phOutputBitmap: PHBITMAP): HRESULT; stdcall;

        function OnFileUpdated(
        {__RPC__in_opt } pStg: IStorage): HRESULT; stdcall;

    end;


    IDummyHICONIncluder = interface(IUnknown)
        ['{947990de-cc28-11d2-a0f7-00805f858fb1}']
        function Dummy(
        {__RPC__in } h1: HICON;
        {__RPC__in } h2: HDC): HRESULT; stdcall;

    end;


    tagApplicationType = (
        ServerApplication = 0,
        LibraryApplication = Ord(ServerApplication) + 1);

    TApplicationType = tagApplicationType;
    PApplicationType = ^TApplicationType;


    tagShutdownType = (
        IdleShutdown = 0,
        ForcedShutdown = Ord(IdleShutdown) + 1);

    TShutdownType = tagShutdownType;
    PShutdownType = ^TShutdownType;


    IProcessLock = interface(IUnknown)
        ['{000001d5-0000-0000-C000-000000000046}']
        function AddRefOnProcess(): ULONG; stdcall;

        function ReleaseRefOnProcess(): ULONG; stdcall;

    end;


    ISurrogateService = interface(IUnknown)
        ['{000001d4-0000-0000-C000-000000000046}']
        function Init(
        {_In_  } rguidProcessID: REFGUID;
        {_In_  } pProcessLock: IProcessLock;
        {_Out_  } pfApplicationAware: Pboolean): HRESULT; stdcall;

        function ApplicationLaunch(
        {_In_  } rguidApplID: REFGUID;
        {_In_  } appType: TApplicationType): HRESULT; stdcall;

        function ApplicationFree(
        {_In_  } rguidApplID: REFGUID): HRESULT; stdcall;

        function CatalogRefresh(
        {_Reserved_  } ulReserved: ULONG): HRESULT; stdcall;

        function ProcessShutdown(
        {_In_  } shutdownType: TShutdownType): HRESULT; stdcall;

    end;


    IInitializeSpy = interface(IUnknown)
        ['{00000034-0000-0000-C000-000000000046}']
        function PreInitialize(
        {_In_  } dwCoInit: DWORD;
        {_In_  } dwCurThreadAptRefs: DWORD): HRESULT; stdcall;

        function PostInitialize(
        {_In_  } hrCoInit: HRESULT;
        {_In_  } dwCoInit: DWORD;
        {_In_  } dwNewThreadAptRefs: DWORD): HRESULT; stdcall;

        function PreUninitialize(
        {_In_  } dwCurThreadAptRefs: DWORD): HRESULT; stdcall;

        function PostUninitialize(
        {_In_  } dwNewThreadAptRefs: DWORD): HRESULT; stdcall;

    end;


    IApartmentShutdown = interface(IUnknown)
        ['{A2F05A09-27A2-42B5-BC0E-AC163EF49D9B}']
        procedure OnUninitialize(
        {_In_  } ui64ApartmentIdentifier: uint64); stdcall;

    end;


const
    COLE_DEFAULT_PRINCIPAL = POLECHAR(INT_PTR(-1));
    COLE_DEFAULT_AUTHINFO = pointer(INT_PTR(-1));


implementation

end.
