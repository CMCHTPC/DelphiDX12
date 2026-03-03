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
   File name: OCIdl.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit Win32.OCIdl;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    Win32.WTypes,
    Win32.ObjIdl,
    ActiveX;

const
    IID_IEnumConnections: TGUID = '{B196B287-BAB4-101A-B69C-00AA00341D07}';
    IID_IConnectionPoint: TGUID = '{B196B286-BAB4-101A-B69C-00AA00341D07}';
    IID_IEnumConnectionPoints: TGUID = '{B196B285-BAB4-101A-B69C-00AA00341D07}';
    IID_IConnectionPointContainer: TGUID = '{B196B284-BAB4-101A-B69C-00AA00341D07}';
    IID_IClassFactory2: TGUID = '{B196B28F-BAB4-101A-B69C-00AA00341D07}';
    IID_IProvideClassInfo: TGUID = '{B196B283-BAB4-101A-B69C-00AA00341D07}';
    IID_IProvideClassInfo2: TGUID = '{A6BC3AC0-DBAA-11CE-9DE3-00AA004BB851}';
    IID_IProvideMultipleClassInfo: TGUID = '{A7ABA9C1-8983-11cf-8F20-00805F2CD064}';
    IID_IOleControl: TGUID = '{B196B288-BAB4-101A-B69C-00AA00341D07}';
    IID_IOleControlSite: TGUID = '{B196B289-BAB4-101A-B69C-00AA00341D07}';
    IID_IPropertyPage: TGUID = '{B196B28D-BAB4-101A-B69C-00AA00341D07}';

    IID_IPropertyPage2: TGUID = '{01E44665-24AC-101B-84ED-08002B2EC713}';
    IID_IPropertyPageSite: TGUID = '{B196B28C-BAB4-101A-B69C-00AA00341D07}';

    IID_IPropertyNotifySink: TGUID = '{9BFBBC02-EFF1-101A-84ED-00AA00341D07}';
    IID_ISpecifyPropertyPages: TGUID = '{B196B28B-BAB4-101A-B69C-00AA00341D07}';
    IID_IPersistMemory: TGUID = '{BD1AE5E0-A6AE-11CE-BD37-504200C10000}';

    IID_IPersistStreamInit: TGUID = '{7FD52380-4E07-101B-AE2D-08002B2EC713}';

    IID_IPersistPropertyBag: TGUID = '{37D84F60-42CB-11CE-8135-00AA004BB851}';
    IID_ISimpleFrameSite: TGUID = '{742B0E01-14E6-101B-914E-00AA00300CAB}';
    IID_IFont: TGUID = '{BEF6E002-A874-101A-8BBA-00AA00300CAB}';

    IID_IPicture: TGUID = '{7BF80980-BF32-101A-8BBB-00AA00300CAB}';
    IID_IPicture2: TGUID = '{F5185DD8-2012-4b0b-AAD9-F052C6BD482B}';
    IID_IFontEventsDisp: TGUID = '{4EF6100A-AF88-11D0-9846-00C04FC29993}';
    IID_IFontDisp: TGUID = '{BEF6E003-A874-101A-8BBA-00AA00300CAB}';

    IID_IPictureDisp: TGUID = '{7BF80981-BF32-101A-8BBB-00AA00300CAB}';
    IID_IOleInPlaceObjectWindowless: TGUID = '{1C2056CC-5EF4-101B-8BC8-00AA003E3B29}';
    IID_IOleInPlaceSiteEx: TGUID = '{9C2CAD80-3424-11CF-B670-00AA004CD6D8}';
    IID_IOleInPlaceSiteWindowless: TGUID = '{922EADA0-3424-11CF-B670-00AA004CD6D8}';
    IID_IViewObjectEx: TGUID = '{3AF24292-0C96-11CE-A0CF-00AA00600AB8}';

    IID_IOleUndoUnit: TGUID = '{894AD3B0-EF97-11CE-9BC9-00AA00608E01}';
    IID_IOleParentUndoUnit: TGUID = '{A1FAF330-EF97-11CE-9BC9-00AA00608E01}';
    IID_IEnumOleUndoUnits: TGUID = '{B3E7C340-EF97-11CE-9BC9-00AA00608E01}';

    IID_IOleUndoManager: TGUID = '{D001F200-EF97-11CE-9BC9-00AA00608E01}';
    IID_IPointerInactive: TGUID = '{55980BA0-35AA-11CF-B671-00AA004CD6D8}';
    IID_IObjectWithSite: TGUID = '{FC4801A3-2BA9-11CF-A229-00AA003D7352}';

    IID_IPerPropertyBrowsing: TGUID = '{376BD3AA-3845-101B-84ED-08002B2EC713}';
    IID_IPropertyBag2: TGUID = '{22F55882-280B-11d0-A8A9-00A0C90C2004}';
    IID_IPersistPropertyBag2: TGUID = '{22F55881-280B-11d0-A8A9-00A0C90C2004}';

    IID_IAdviseSinkEx: TGUID = '{3AF24290-0C96-11CE-A0CF-00AA00600AB8}';
    IID_IQuickActivate: TGUID = '{CF51ED10-62FE-11CF-BF86-00A0C9034836}';


    MULTICLASSINFO_GETTYPEINFO = $00000001;
    MULTICLASSINFO_GETNUMRESERVEDDISPIDS = $00000002;
    MULTICLASSINFO_GETIIDPRIMARY = $00000004;
    MULTICLASSINFO_GETIIDSOURCE = $00000008;
    TIFLAGS_EXTENDDISPATCHONLY = $00000001;


type

    LPCRECT = ^TRECT; // TODO
    LPRECTL = ^TRECTL; // TODO
    LPCOLESTR = pointer; // TODO
    PLCID = ^LCID;
    PHDC = ^HDC;
    PHFONT = ^HFONT;
    PIOleClientSite = pointer; // ToDo
    PIBindHost = pointer; // ToDo
    PIServiceProvider = pointer; // ToDo


    (* Forward Declarations *)


    IEnumConnections = interface;


    IConnectionPoint = interface;


    IEnumConnectionPoints = interface;


    IConnectionPointContainer = interface;


    IClassFactory2 = interface;


    IProvideClassInfo = interface;


    IProvideClassInfo2 = interface;


    IProvideMultipleClassInfo = interface;


    IOleControl = interface;


    IOleControlSite = interface;


    IPropertyPage = interface;


    IPropertyPage2 = interface;


    IPropertyPageSite = interface;


    IPropertyNotifySink = interface;


    ISpecifyPropertyPages = interface;


    IPersistMemory = interface;


    IPersistStreamInit = interface;


    IPersistPropertyBag = interface;


    ISimpleFrameSite = interface;


    IFont = interface;


    IPicture = interface;


    IPicture2 = interface;


    IFontEventsDisp = interface;


    IFontDisp = interface;


    IPictureDisp = interface;


    IOleInPlaceObjectWindowless = interface;


    IOleInPlaceSiteEx = interface;


    IOleInPlaceSiteWindowless = interface;


    IViewObjectEx = interface;


    IOleUndoUnit = interface;


    IOleParentUndoUnit = interface;


    IEnumOleUndoUnits = interface;


    IOleUndoManager = interface;


    IPointerInactive = interface;


    IObjectWithSite = interface;


    IPerPropertyBrowsing = interface;


    IPropertyBag2 = interface;


    IPersistPropertyBag2 = interface;


    IAdviseSinkEx = interface;


    IQuickActivate = interface;


    PENUMCONNECTIONS = ^IEnumConnections;
    LPENUMCONNECTIONS = ^IEnumConnections;

    PCONNECTIONPOINT = ^IConnectionPoint;
    LPCONNECTIONPOINT = ^IConnectionPoint;
    PENUMCONNECTIONPOINTS = ^IEnumConnectionPoints;
    LPENUMCONNECTIONPOINTS = ^IEnumConnectionPoints;
    PCONNECTIONPOINTCONTAINER = ^IConnectionPointContainer;
    LPCONNECTIONPOINTCONTAINER = ^IConnectionPointContainer;
    LPCLASSFACTORY2 = ^IClassFactory2;

    LPPROVIDECLASSINFO = ^IProvideClassInfo;
    LPPROVIDECLASSINFO2 = ^IProvideClassInfo2;
    LPPROVIDEMULTIPLECLASSINFO = ^IProvideMultipleClassInfo;
    LPOLECONTROL = ^IOleControl;
    LPCONTROLINFO = ^tagCONTROLINFO;
    LPOLECONTROLSITE = ^IOleControlSite;
    LPPROPERTYPAGE = ^IPropertyPage;
    LPPROPERTYPAGE2 = ^IPropertyPage2;
    LPPROPERTYPAGESITE = ^IPropertyPageSite;

    LPPROPERTYNOTIFYSINK = ^IPropertyNotifySink;
    LPSPECIFYPROPERTYPAGES = ^ISpecifyPropertyPages;
    LPPERSISTMEMORY = ^IPersistMemory;

    LPPERSISTSTREAMINIT = ^IPersistStreamInit;
    LPPERSISTPROPERTYBAG = ^IPersistPropertyBag;
    LPSIMPLEFRAMESITE = ^ISimpleFrameSite;

    LPFONT = ^IFont;
    LPPICTURE = ^IPicture;
    LPPICTURE2 = ^IPicture2;
    LPFONTEVENTS = ^IFontEventsDisp;

    LPFONTDISP = ^IFontDisp;
    LPPICTUREDISP = ^IPictureDisp;
    LPOLEINPLACEOBJECTWINDOWLESS = ^IOleInPlaceObjectWindowless;

    LPOLEINPLACESITEEX = ^IOleInPlaceSiteEx;
    LPOLEINPLACESITEWINDOWLESS = ^IOleInPlaceSiteWindowless;
    LPVIEWOBJECTEX = ^IViewObjectEx;

    LPOLEUNDOUNIT = ^IOleUndoUnit;
    LPOLEPARENTUNDOUNIT = ^IOleParentUndoUnit;


    LPENUMOLEUNDOUNITS = ^IEnumOleUndoUnits;
    LPOLEUNDOMANAGER = ^IOleUndoManager;
    LPPOINTERINACTIVE = ^IPointerInactive;

    LPOBJECTWITHSITE = ^IObjectWithSite;
    LPPERPROPERTYBROWSING = ^IPerPropertyBrowsing;
    LPPROPERTYBAG2 = ^IPropertyBag2;

    LPPERSISTPROPERTYBAG2 = ^IPersistPropertyBag2;
    LPADVISESINKEX = ^IAdviseSinkEx;
    LPQUICKACTIVATE = ^IQuickActivate;


    PIUnknown = ^IUnknown;
    IID = TGUID;
    REFIID = ^TGUID;


    (* interface IOleControlTypes *)


    tagUASFLAGS = (
        UAS_NORMAL = 0,
        UAS_BLOCKED = $1,
        UAS_NOPARENTENABLE = $2,
        UAS_MASK = $3);

    TUASFLAGS = tagUASFLAGS;
    PUASFLAGS = ^TUASFLAGS;


    (* State values for the DISPID_READYSTATE property *)
    tagREADYSTATE = (
        READYSTATE_UNINITIALIZED = 0,
        READYSTATE_LOADING = 1,
        READYSTATE_LOADED = 2,
        READYSTATE_INTERACTIVE = 3,
        READYSTATE_COMPLETE = 4);

    TREADYSTATE = tagREADYSTATE;
    PREADYSTATE = ^TREADYSTATE;


    tagCONNECTDATA = record
        pUnk: PIUnknown;
        dwCookie: DWORD;
    end;
    TCONNECTDATA = tagCONNECTDATA;
    PCONNECTDATA = ^TCONNECTDATA;
    LPCONNECTDATA = ^TCONNECTDATA;


    IEnumConnections = interface(IUnknown)
        ['{B196B287-BAB4-101A-B69C-00AA00341D07}']
        function Next(cConnections: ULONG; rgcd: LPCONNECTDATA; pcFetched: PULONG): HRESULT; stdcall;

        function Skip(cConnections: ULONG): HRESULT; stdcall;

        function Reset(): HRESULT; stdcall;

        function Clone(
        {__RPC__deref_out_opt }  out ppEnum: IEnumConnections): HRESULT; stdcall;

    end;


    IConnectionPoint = interface(IUnknown)
        ['{B196B286-BAB4-101A-B69C-00AA00341D07}']
        function GetConnectionInterface(
        {__RPC__out } pIID: IID): HRESULT; stdcall;

        function GetConnectionPointContainer(
        {__RPC__deref_out_opt }  out ppCPC: IConnectionPointContainer): HRESULT; stdcall;

        function Advise(
        {__RPC__in_opt } pUnkSink: IUnknown;
        {__RPC__out } pdwCookie: PDWORD): HRESULT; stdcall;

        function Unadvise(dwCookie: DWORD): HRESULT; stdcall;

        function EnumConnections(
        {__RPC__deref_out_opt }  out ppEnum: IEnumConnections): HRESULT; stdcall;

    end;

    PIConnectionPoint = ^IConnectionPoint;


    IEnumConnectionPoints = interface(IUnknown)
        ['{B196B285-BAB4-101A-B69C-00AA00341D07}']
        function Next(
        {in} cConnections: ULONG;
        {out} out ppCP: PIConnectionPoint;
        {out} pcFetched: PULONG): HRESULT; stdcall;

        function Skip(cConnections: ULONG): HRESULT; stdcall;

        function Reset(): HRESULT; stdcall;

        function Clone(
        {__RPC__deref_out_opt }  out ppEnum: IEnumConnectionPoints): HRESULT; stdcall;

    end;


    IConnectionPointContainer = interface(IUnknown)
        ['{B196B284-BAB4-101A-B69C-00AA00341D07}']
        function EnumConnectionPoints(
        {__RPC__deref_out_opt }  out ppEnum: IEnumConnectionPoints): HRESULT; stdcall;

        function FindConnectionPoint(
        {__RPC__in } riid: REFIID;
        {__RPC__deref_out_opt }  out ppCP: IConnectionPoint): HRESULT; stdcall;

    end;


    tagLICINFO = record
        cbLicInfo: LONG;
        fRuntimeKeyAvail: boolean;
        fLicVerified: boolean;
    end;
    TLICINFO = tagLICINFO;
    PLICINFO = ^TLICINFO;

    LPLICINFO = ^TLICINFO;


    IClassFactory2 = interface(IClassFactory)
        ['{B196B28F-BAB4-101A-B69C-00AA00341D07}']
        function GetLicInfo(
        {__RPC__inout } pLicInfo: PLICINFO): HRESULT; stdcall;

        function RequestLicKey(dwReserved: DWORD;
        {__RPC__deref_out_opt } pBstrKey: PBSTR): HRESULT; stdcall;

        function CreateInstanceLic(
        {_In_opt_  } pUnkOuter: IUnknown;
        {_Reserved_  } pUnkReserved: IUnknown;
        {__RPC__in  } riid: REFIID;
        {__RPC__in  } bstrKey: TBSTR;
        {__RPC__deref_out_opt  } ppvObj: PVOID): HRESULT; stdcall;

    end;


    IProvideClassInfo = interface(IUnknown)
        ['{B196B283-BAB4-101A-B69C-00AA00341D07}']
        function GetClassInfo(
        {__RPC__deref_out_opt }  out ppTI: ITypeInfo): HRESULT; stdcall;

    end;


    tagGUIDKIND = (
        GUIDKIND_DEFAULT_SOURCE_DISP_IID = 1);

    TGUIDKIND = tagGUIDKIND;
    PGUIDKIND = ^TGUIDKIND;


    IProvideClassInfo2 = interface(IProvideClassInfo)
        ['{A6BC3AC0-DBAA-11CE-9DE3-00AA004BB851}']
        function GetGUID(dwGuidKind: DWORD;
        {__RPC__out } pGUID: PGUID): HRESULT; stdcall;

    end;


    IProvideMultipleClassInfo = interface(IProvideClassInfo2)
        ['{A7ABA9C1-8983-11cf-8F20-00805F2CD064}']
        function GetMultiTypeInfoCount(
        {__RPC__out } pcti: PULONG): HRESULT; stdcall;

        function GetInfoOfIndex(iti: ULONG; dwFlags: DWORD;
        {__RPC__deref_out_opt }  out pptiCoClass: ITypeInfo;
        {__RPC__out } pdwTIFlags: PDWORD;
        {__RPC__out } pcdispidReserved: PULONG;
        {__RPC__out } piidPrimary: IID;
        {__RPC__out } piidSource: IID): HRESULT; stdcall;

    end;


    tagCONTROLINFO = record
        cb: ULONG;
        hAccel: HACCEL;
        cAccel: USHORT;
        dwFlags: DWORD;
    end;
    TCONTROLINFO = tagCONTROLINFO;
    PCONTROLINFO = ^TCONTROLINFO;


    tagCTRLINFO = (
        CTRLINFO_EATS_RETURN = 1,
        CTRLINFO_EATS_ESCAPE = 2);

    TCTRLINFO = tagCTRLINFO;
    PCTRLINFO = ^TCTRLINFO;


    IOleControl = interface(IUnknown)
        ['{B196B288-BAB4-101A-B69C-00AA00341D07}']
        function GetControlInfo(
        {__RPC__inout } pCI: PCONTROLINFO): HRESULT; stdcall;

        function OnMnemonic(
        {__RPC__in } pMsg: PMSG): HRESULT; stdcall;

        function OnAmbientPropertyChange(dispID: TDISPID): HRESULT; stdcall;

        function FreezeEvents(bFreeze: boolean): HRESULT; stdcall;

    end;


    tagPOINTF = record
        x: single;
        y: single;
    end;
    TPOINTF = tagPOINTF;
    PPOINTF = ^TPOINTF;

    LPPOINTF = ^TPOINTF;

    tagXFORMCOORDS = (
        XFORMCOORDS_POSITION = $1,
        XFORMCOORDS_SIZE = $2,
        XFORMCOORDS_HIMETRICTOCONTAINER = $4,
        XFORMCOORDS_CONTAINERTOHIMETRIC = $8,
        XFORMCOORDS_EVENTCOMPAT = $10);

    TXFORMCOORDS = tagXFORMCOORDS;
    PXFORMCOORDS = ^TXFORMCOORDS;


    IOleControlSite = interface(IUnknown)
        ['{B196B289-BAB4-101A-B69C-00AA00341D07}']
        function OnControlInfoChanged(): HRESULT; stdcall;

        function LockInPlaceActive(fLock: boolean): HRESULT; stdcall;

        function GetExtendedControl(
        {__RPC__deref_out_opt }  out ppDisp: IDispatch): HRESULT; stdcall;

        function TransformCoords(
        {__RPC__inout } pPtlHimetric: PPOINTL;
        {__RPC__inout } pPtfContainer: PPOINTF; dwFlags: DWORD): HRESULT; stdcall;

        function TranslateAccelerator(
        {__RPC__in } pMsg: PMSG; grfModifiers: DWORD): HRESULT; stdcall;

        function OnFocus(fGotFocus: boolean): HRESULT; stdcall;

        function ShowPropertyFrame(): HRESULT; stdcall;

    end;

    PIOleControlSite = ^IOleControlSite;


    tagPROPPAGEINFO = record
        cb: ULONG;
        pszTitle: LPOLESTR;
        size: TSIZE;
        pszDocString: LPOLESTR;
        pszHelpFile: LPOLESTR;
        dwHelpContext: DWORD;
    end;
    TPROPPAGEINFO = tagPROPPAGEINFO;
    PPROPPAGEINFO = ^TPROPPAGEINFO;

    LPPROPPAGEINFO = ^TPROPPAGEINFO;


    IPropertyPage = interface(IUnknown)
        ['{B196B28D-BAB4-101A-B69C-00AA00341D07}']
        function SetPageSite(
        {__RPC__in_opt } pPageSite: IPropertyPageSite): HRESULT; stdcall;

        function Activate(
        {__RPC__in } hWndParent: HWND;
        {__RPC__in } pRect: LPCRECT; bModal: boolean): HRESULT; stdcall;

        function Deactivate(): HRESULT; stdcall;

        function GetPageInfo(
        {__RPC__out } pPageInfo: PPROPPAGEINFO): HRESULT; stdcall;

        function SetObjects(cObjects: ULONG;
        {__RPC__in_ecount_full(cObjects) } ppUnk: PIUnknown): HRESULT; stdcall;

        function Show(nCmdShow: UINT): HRESULT; stdcall;

        function Move(
        {__RPC__in } pRect: LPCRECT): HRESULT; stdcall;

        function IsPageDirty(): HRESULT; stdcall;

        function Apply(): HRESULT; stdcall;

        function Help(
        {__RPC__in } pszHelpDir: LPCOLESTR): HRESULT; stdcall;

        function TranslateAccelerator(
        {__RPC__in } pMsg: PMSG): HRESULT; stdcall;

    end;

    PIPropertyPage = ^IPropertyPage;


    IPropertyPage2 = interface(IPropertyPage)
        ['{01E44665-24AC-101B-84ED-08002B2EC713}']
        function EditProperty(dispID: TDISPID): HRESULT; stdcall;

    end;

    PIPropertyPage2 = ^IPropertyPage2;


    tagPROPPAGESTATUS = (
        PROPPAGESTATUS_DIRTY = $1,
        PROPPAGESTATUS_VALIDATE = $2,
        PROPPAGESTATUS_CLEAN = $4);

    TPROPPAGESTATUS = tagPROPPAGESTATUS;
    PPROPPAGESTATUS = ^TPROPPAGESTATUS;


    IPropertyPageSite = interface(IUnknown)
        ['{B196B28C-BAB4-101A-B69C-00AA00341D07}']
        function OnStatusChange(dwFlags: DWORD): HRESULT; stdcall;

        function GetLocaleID(
        {__RPC__out } pLocaleID: PLCID): HRESULT; stdcall;

        function GetPageContainer(
        {__RPC__deref_out_opt }  out ppUnk: IUnknown): HRESULT; stdcall;

        function TranslateAccelerator(
        {__RPC__in } pMsg: PMSG): HRESULT; stdcall;

    end;


    IPropertyNotifySink = interface(IUnknown)
        ['{9BFBBC02-EFF1-101A-84ED-00AA00341D07}']
        function OnChanged(dispID: TDISPID): HRESULT; stdcall;

        function OnRequestEdit(dispID: TDISPID): HRESULT; stdcall;

    end;

    PIPropertyNotifySink = ^IPropertyNotifySink;


    tagCAUUID = record
        cElems: ULONG; (* [size_is] *)
        pElems: PGUID;
    end;
    TCAUUID = tagCAUUID;
    PCAUUID = ^TCAUUID;

    LPCAUUID = ^TCAUUID;


    ISpecifyPropertyPages = interface(IUnknown)
        ['{B196B28B-BAB4-101A-B69C-00AA00341D07}']
        function GetPages(
        {__RPC__out } pPages: PCAUUID): HRESULT; stdcall;

    end;


    IPersistMemory = interface(IPersist)
        ['{BD1AE5E0-A6AE-11CE-BD37-504200C10000}']
        function IsDirty(): HRESULT; stdcall;

        function Load(pMem: LPVOID; cbSize: ULONG): HRESULT; stdcall;

        function Save(pMem: LPVOID; fClearDirty: boolean; cbSize: ULONG): HRESULT; stdcall;

        function GetSizeMax(
        {__RPC__out } pCbSize: PULONG): HRESULT; stdcall;

        function InitNew(): HRESULT; stdcall;

    end;


    IPersistStreamInit = interface(IPersist)
        ['{7FD52380-4E07-101B-AE2D-08002B2EC713}']
        function IsDirty(): HRESULT; stdcall;

        function Load(
        {__RPC__in_opt } pStm: IStream): HRESULT; stdcall;

        function Save(
        {__RPC__in_opt } pStm: IStream; fClearDirty: boolean): HRESULT; stdcall;

        function GetSizeMax(
        {__RPC__out } pCbSize: PULARGE_INTEGER): HRESULT; stdcall;

        function InitNew(): HRESULT; stdcall;

    end;


    IPersistPropertyBag = interface(IPersist)
        ['{37D84F60-42CB-11CE-8135-00AA004BB851}']
        function InitNew(): HRESULT; stdcall;

        function Load(
        {__RPC__in_opt } pPropBag: IPropertyBag;
        {__RPC__in_opt } pErrorLog: IErrorLog): HRESULT; stdcall;

        function Save(
        {__RPC__in_opt } pPropBag: IPropertyBag; fClearDirty: boolean; fSaveAllProperties: boolean): HRESULT; stdcall;

    end;


    ISimpleFrameSite = interface(IUnknown)
        ['{742B0E01-14E6-101B-914E-00AA00300CAB}']
        function PreMessageFilter(
        {__RPC__in } hWnd: HWND; msg: UINT; wp: WPARAM; lp: LPARAM;
        {__RPC__out } plResult: PLRESULT;
        {__RPC__out } pdwCookie: PDWORD): HRESULT; stdcall;

        function PostMessageFilter(
        {__RPC__in } hWnd: HWND; msg: UINT; wp: WPARAM; lp: LPARAM;
        {__RPC__out } plResult: PLRESULT; dwCookie: DWORD): HRESULT; stdcall;

    end;


    TEXTMETRICOLE = TEXTMETRICW;
    PTEXTMETRICOLE = ^TEXTMETRICOLE;
    LPTEXTMETRICOLE = ^TEXTMETRICOLE;


    IFont = interface(IUnknown)
        ['{BEF6E002-A874-101A-8BBA-00AA00300CAB}']
        function get_Name(
        {__RPC__deref_out_opt } pName: PBSTR): HRESULT; stdcall;

        function put_Name(
        {__RPC__in } Name: TBSTR): HRESULT; stdcall;

        function get_Size(
        {__RPC__out } pSize: LPCY): HRESULT; stdcall;

        function put_Size(size: TCY): HRESULT; stdcall;

        function get_Bold(
        {__RPC__out } pBold: Pboolean): HRESULT; stdcall;

        function put_Bold(bold: boolean): HRESULT; stdcall;

        function get_Italic(
        {__RPC__out } pItalic: Pboolean): HRESULT; stdcall;

        function put_Italic(italic: boolean): HRESULT; stdcall;

        function get_Underline(
        {__RPC__out } pUnderline: Pboolean): HRESULT; stdcall;

        function put_Underline(underline: boolean): HRESULT; stdcall;

        function get_Strikethrough(
        {__RPC__out } pStrikethrough: Pboolean): HRESULT; stdcall;

        function put_Strikethrough(strikethrough: boolean): HRESULT; stdcall;

        function get_Weight(
        {__RPC__out } pWeight: PSHORT): HRESULT; stdcall;

        function put_Weight(weight: SHORT): HRESULT; stdcall;

        function get_Charset(
        {__RPC__out } pCharset: PSHORT): HRESULT; stdcall;

        function put_Charset(charset: SHORT): HRESULT; stdcall;

        function get_hFont(
        {__RPC__deref_out_opt } phFont: PHFONT): HRESULT; stdcall;

        function Clone(
        {__RPC__deref_out_opt }  out ppFont: IFont): HRESULT; stdcall;

        function IsEqual(
        {__RPC__in_opt } pFontOther: IFont): HRESULT; stdcall;

        function SetRatio(cyLogical: LONG; cyHimetric: LONG): HRESULT; stdcall;

        function QueryTextMetrics(
        {__RPC__out } pTM: PTEXTMETRICOLE): HRESULT; stdcall;

        function AddRefHfont(
        {__RPC__in } hFont: HFONT): HRESULT; stdcall;

        function ReleaseHfont(
        {__RPC__in } hFont: HFONT): HRESULT; stdcall;

        function SetHdc(
        {__RPC__in } hDC: HDC): HRESULT; stdcall;

    end;

    PIFont = ^IFont;


    tagPictureAttributes = (
        PICTURE_SCALABLE = $1,
        PICTURE_TRANSPARENT = $2);

    TPictureAttributes = tagPictureAttributes;
    PPictureAttributes = ^TPictureAttributes;

    OLE_HANDLE = UINT; // DECLSPEC_UUID("66504313-BE0F-101A-8BBB-00AA00300CAB")
    POLE_HANDLE = ^OLE_HANDLE;

    OLE_XPOS_HIMETRIC = LONG; // DECLSPEC_UUID("66504306-BE0F-101A-8BBB-00AA00300CAB")
    POLE_XPOS_HIMETRIC = ^OLE_XPOS_HIMETRIC;

    OLE_YPOS_HIMETRIC = LONG; // DECLSPEC_UUID("66504307-BE0F-101A-8BBB-00AA00300CAB")
    POLE_YPOS_HIMETRIC = ^OLE_YPOS_HIMETRIC;

    OLE_XSIZE_HIMETRIC = LONG; // DECLSPEC_UUID("66504308-BE0F-101A-8BBB-00AA00300CAB")
    POLE_XSIZE_HIMETRIC = ^OLE_XSIZE_HIMETRIC;

    OLE_YSIZE_HIMETRIC = LONG; // DECLSPEC_UUID("66504309-BE0F-101A-8BBB-00AA00300CAB")
    POLE_YSIZE_HIMETRIC = ^OLE_YSIZE_HIMETRIC;

    IPicture = interface(IUnknown)
        ['{7BF80980-BF32-101A-8BBB-00AA00300CAB}']
        function get_Handle(
        {__RPC__out } pHandle: POLE_HANDLE): HRESULT; stdcall;

        function get_hPal(
        {__RPC__out } phPal: POLE_HANDLE): HRESULT; stdcall;

        function get_Type(
        {__RPC__out } pType: PSHORT): HRESULT; stdcall;

        function get_Width(
        {__RPC__out } pWidth: POLE_XSIZE_HIMETRIC): HRESULT; stdcall;

        function get_Height(
        {__RPC__out } pHeight: POLE_YSIZE_HIMETRIC): HRESULT; stdcall;

        function Render(
        {__RPC__in } hDC: HDC; x: LONG; y: LONG; cx: LONG; cy: LONG; xSrc: OLE_XPOS_HIMETRIC; ySrc: OLE_YPOS_HIMETRIC; cxSrc: OLE_XSIZE_HIMETRIC; cySrc: OLE_YSIZE_HIMETRIC;
        {__RPC__in } pRcWBounds: LPCRECT): HRESULT; stdcall;

        function set_hPal(hPal: OLE_HANDLE): HRESULT; stdcall;

        function get_CurDC(
        {__RPC__deref_out_opt } phDC: PHDC): HRESULT; stdcall;

        function SelectPicture(
        {__RPC__in } hDCIn: HDC;
        {__RPC__deref_out_opt } phDCOut: PHDC;
        {__RPC__out } phBmpOut: POLE_HANDLE): HRESULT; stdcall;

        function get_KeepOriginalFormat(
        {__RPC__out } pKeep: Pboolean): HRESULT; stdcall;

        function put_KeepOriginalFormat(keep: boolean): HRESULT; stdcall;

        function PictureChanged(): HRESULT; stdcall;

        function SaveAsFile(
        {__RPC__in_opt } pStream: IStream; fSaveMemCopy: boolean;
        {__RPC__out } pCbSize: PLONG): HRESULT; stdcall;

        function get_Attributes(
        {__RPC__out } pDwAttr: PDWORD): HRESULT; stdcall;

    end;


    HHANDLE = UINT_PTR;
    PHHANDLE = ^HHANDLE;


    IPicture2 = interface(IUnknown)
        ['{F5185DD8-2012-4b0b-AAD9-F052C6BD482B}']
        function get_Handle(
        {__RPC__out } pHandle: PHHANDLE): HRESULT; stdcall;

        function get_hPal(
        {__RPC__out } phPal: PHHANDLE): HRESULT; stdcall;

        function get_Type(
        {__RPC__out } pType: PSHORT): HRESULT; stdcall;

        function get_Width(
        {__RPC__out } pWidth: POLE_XSIZE_HIMETRIC): HRESULT; stdcall;

        function get_Height(
        {__RPC__out } pHeight: POLE_YSIZE_HIMETRIC): HRESULT; stdcall;

        function Render(
        {__RPC__in } hDC: HDC; x: LONG; y: LONG; cx: LONG; cy: LONG; xSrc: OLE_XPOS_HIMETRIC; ySrc: OLE_YPOS_HIMETRIC; cxSrc: OLE_XSIZE_HIMETRIC; cySrc: OLE_YSIZE_HIMETRIC;
        {__RPC__in } pRcWBounds: LPCRECT): HRESULT; stdcall;

        function set_hPal(hPal: HHANDLE): HRESULT; stdcall;

        function get_CurDC(
        {__RPC__deref_out_opt } phDC: PHDC): HRESULT; stdcall;

        function SelectPicture(
        {__RPC__in } hDCIn: HDC;
        {__RPC__deref_out_opt } phDCOut: PHDC;
        {__RPC__out } phBmpOut: PHHANDLE): HRESULT; stdcall;

        function get_KeepOriginalFormat(
        {__RPC__out } pKeep: Pboolean): HRESULT; stdcall;

        function put_KeepOriginalFormat(keep: boolean): HRESULT; stdcall;

        function PictureChanged(): HRESULT; stdcall;

        function SaveAsFile(
        {__RPC__in_opt } pStream: IStream; fSaveMemCopy: boolean;
        {__RPC__out } pCbSize: PLONG): HRESULT; stdcall;

        function get_Attributes(
        {__RPC__out } pDwAttr: PDWORD): HRESULT; stdcall;

    end;


    IFontEventsDisp = interface(IDispatch)
        ['{4EF6100A-AF88-11D0-9846-00C04FC29993}']
    end;


    IFontDisp = interface(IDispatch)
        ['{BEF6E003-A874-101A-8BBA-00AA00300CAB}']
    end;


    IPictureDisp = interface(IDispatch)
        ['{7BF80981-BF32-101A-8BBB-00AA00300CAB}']
    end;


    IOleInPlaceObjectWindowless = interface(IOleInPlaceObject)
        ['{1C2056CC-5EF4-101B-8BC8-00AA003E3B29}']
        function OnWindowMessage(msg: UINT; wParam: WPARAM; lParam: LPARAM;
        {__RPC__out } plResult: PLRESULT): HRESULT; stdcall;

        function GetDropTarget(
        {__RPC__deref_out_opt }  out ppDropTarget: IDropTarget): HRESULT; stdcall;

    end;


    tagACTIVATEFLAGS = (
        ACTIVATE_WINDOWLESS = 1);

    TACTIVATEFLAGS = tagACTIVATEFLAGS;
    PACTIVATEFLAGS = ^TACTIVATEFLAGS;


    IOleInPlaceSiteEx = interface(IOleInPlaceSite)
        ['{9C2CAD80-3424-11CF-B670-00AA004CD6D8}']
        function OnInPlaceActivateEx(
        {__RPC__out } pfNoRedraw: Pboolean; dwFlags: DWORD): HRESULT; stdcall;

        function OnInPlaceDeactivateEx(fNoRedraw: boolean): HRESULT; stdcall;

        function RequestUIActivate(): HRESULT; stdcall;

    end;


    tagOLEDCFLAGS = (
        OLEDC_NODRAW = $1,
        OLEDC_PAINTBKGND = $2,
        OLEDC_OFFSCREEN = $4);

    TOLEDCFLAGS = tagOLEDCFLAGS;
    POLEDCFLAGS = ^TOLEDCFLAGS;


    IOleInPlaceSiteWindowless = interface(IOleInPlaceSiteEx)
        ['{922EADA0-3424-11CF-B670-00AA004CD6D8}']
        function CanWindowlessActivate(): HRESULT; stdcall;

        function GetCapture(): HRESULT; stdcall;

        function SetCapture(fCapture: boolean): HRESULT; stdcall;

        function GetFocus(): HRESULT; stdcall;

        function SetFocus(fFocus: boolean): HRESULT; stdcall;

        function GetDC(
        {__RPC__in_opt } pRect: LPCRECT; grfFlags: DWORD;
        {__RPC__deref_out_opt } phDC: PHDC): HRESULT; stdcall;

        function ReleaseDC(
        {__RPC__in } hDC: HDC): HRESULT; stdcall;

        function InvalidateRect(
        {__RPC__in_opt } pRect: LPCRECT; fErase: boolean): HRESULT; stdcall;

        function InvalidateRgn(
        {__RPC__in } hRGN: HRGN; fErase: boolean): HRESULT; stdcall;

        function ScrollRect(dx: int32; dy: int32;
        {__RPC__in } pRectScroll: LPCRECT;
        {__RPC__in } pRectClip: LPCRECT): HRESULT; stdcall;

        function AdjustRect(
        {__RPC__inout } prc: LPRECT): HRESULT; stdcall;

        function OnDefWindowMessage(
        {_In_  } msg: UINT;
        {_In_  } wParam: WPARAM;
        {_In_  } lParam: LPARAM;
        {__RPC__out } plResult: PLRESULT): HRESULT; stdcall;

    end;


    tagVIEWSTATUS = (
        VIEWSTATUS_OPAQUE = 1,
        VIEWSTATUS_SOLIDBKGND = 2,
        VIEWSTATUS_DVASPECTOPAQUE = 4,
        VIEWSTATUS_DVASPECTTRANSPARENT = 8,
        VIEWSTATUS_SURFACE = 16,
        VIEWSTATUS_3DSURFACE = 32);

    TVIEWSTATUS = tagVIEWSTATUS;
    PVIEWSTATUS = ^TVIEWSTATUS;


    tagHITRESULT = (
        HITRESULT_OUTSIDE = 0,
        HITRESULT_TRANSPARENT = 1,
        HITRESULT_CLOSE = 2,
        HITRESULT_HIT = 3);

    THITRESULT = tagHITRESULT;
    PHITRESULT = ^THITRESULT;


    tagDVASPECT2 = (
        DVASPECT_OPAQUE = 16,
        DVASPECT_TRANSPARENT = 32);

    TDVASPECT2 = tagDVASPECT2;
    PDVASPECT2 = ^TDVASPECT2;


    tagExtentInfo = record
        cb: ULONG;
        dwExtentMode: DWORD;
        sizelProposed: TSIZEL;
    end;
    TExtentInfo = tagExtentInfo;
    PExtentInfo = ^TExtentInfo;

    TDVEXTENTINFO = TExtentInfo;
    PDVEXTENTINFO = ^TDVEXTENTINFO;

    tagExtentMode = (
        DVEXTENT_CONTENT = 0,
        DVEXTENT_INTEGRAL = Ord(DVEXTENT_CONTENT) + 1);

    TExtentMode = tagExtentMode;
    PExtentMode = ^TExtentMode;

    TDVEXTENTMODE = TExtentMode;

    tagAspectInfoFlag = (
        DVASPECTINFOFLAG_CANOPTIMIZE = 1);

    TAspectInfoFlag = tagAspectInfoFlag;
    PAspectInfoFlag = ^TAspectInfoFlag;

    TDVASPECTINFOFLAG = TAspectInfoFlag;

    tagAspectInfo = record
        cb: ULONG;
        dwFlags: DWORD;
    end;
    TAspectInfo = tagAspectInfo;
    PAspectInfo = ^TAspectInfo;

    TDVASPECTINFO = TAspectInfo;


    IViewObjectEx = interface(IViewObject2)
        ['{3AF24292-0C96-11CE-A0CF-00AA00600AB8}']
        function GetRect(dwAspect: DWORD;
        {__RPC__out } pRect: LPRECTL): HRESULT; stdcall;

        function GetViewStatus(
        {__RPC__out } pdwStatus: PDWORD): HRESULT; stdcall;

        function QueryHitPoint(dwAspect: DWORD;
        {__RPC__in } pRectBounds: LPCRECT; ptlLoc: TPOINT; lCloseHint: LONG;
        {__RPC__out } pHitResult: PDWORD): HRESULT; stdcall;

        function QueryHitRect(dwAspect: DWORD;
        {__RPC__in } pRectBounds: LPCRECT;
        {__RPC__in } pRectLoc: LPCRECT; lCloseHint: LONG;
        {__RPC__out } pHitResult: PDWORD): HRESULT; stdcall;

        function GetNaturalExtent(dwAspect: DWORD; lindex: LONG;
        {__RPC__in } ptd: PDVTARGETDEVICE;
        {__RPC__in } hicTargetDev: HDC;
        {__RPC__in } pExtentInfo: PDVEXTENTINFO;
        {__RPC__out } pSizel: LPSIZEL): HRESULT; stdcall;

    end;


    IOleUndoUnit = interface(IUnknown)
        ['{894AD3B0-EF97-11CE-9BC9-00AA00608E01}']
        function _Do(
        {__RPC__in_opt } pUndoManager: IOleUndoManager): HRESULT; stdcall;

        function GetDescription(
        {__RPC__deref_out_opt } pBstr: PBSTR): HRESULT; stdcall;

        function GetUnitType(
        {__RPC__out } pClsid: PCLSID;
        {__RPC__out } plID: PLONG): HRESULT; stdcall;

        function OnNextAdd(): HRESULT; stdcall;

    end;

    PIOleUndoUnit = ^IOleUndoUnit;


    IOleParentUndoUnit = interface(IOleUndoUnit)
        ['{A1FAF330-EF97-11CE-9BC9-00AA00608E01}']
        function Open(
        {__RPC__in_opt } pPUU: IOleParentUndoUnit): HRESULT; stdcall;

        function Close(
        {__RPC__in_opt } pPUU: IOleParentUndoUnit; fCommit: boolean): HRESULT; stdcall;

        function Add(
        {__RPC__in_opt } pUU: IOleUndoUnit): HRESULT; stdcall;

        function FindUnit(
        {__RPC__in_opt } pUU: IOleUndoUnit): HRESULT; stdcall;

        function GetParentState(
        {__RPC__out } pdwState: PDWORD): HRESULT; stdcall;

    end;

    PIOleParentUndoUnit = ^IOleParentUndoUnit;


    IEnumOleUndoUnits = interface(IUnknown)
        ['{B3E7C340-EF97-11CE-9BC9-00AA00608E01}']
        function Next(cElt: ULONG; out rgElt: PIOleUndoUnit; pcEltFetched: PULONG): HRESULT; stdcall;

        function Skip(cElt: ULONG): HRESULT; stdcall;

        function Reset(): HRESULT; stdcall;

        function Clone(
        {__RPC__deref_out_opt }  out ppEnum: IEnumOleUndoUnits): HRESULT; stdcall;

    end;


    IOleUndoManager = interface(IUnknown)
        ['{D001F200-EF97-11CE-9BC9-00AA00608E01}']
        function Open(
        {__RPC__in_opt } pPUU: IOleParentUndoUnit): HRESULT; stdcall;

        function Close(
        {__RPC__in_opt } pPUU: IOleParentUndoUnit; fCommit: boolean): HRESULT; stdcall;

        function Add(
        {__RPC__in_opt } pUU: IOleUndoUnit): HRESULT; stdcall;

        function GetOpenParentState(
        {__RPC__out } pdwState: PDWORD): HRESULT; stdcall;

        function DiscardFrom(
        {__RPC__in_opt } pUU: IOleUndoUnit): HRESULT; stdcall;

        function UndoTo(
        {__RPC__in_opt } pUU: IOleUndoUnit): HRESULT; stdcall;

        function RedoTo(
        {__RPC__in_opt } pUU: IOleUndoUnit): HRESULT; stdcall;

        function EnumUndoable(
        {__RPC__deref_out_opt }  out ppEnum: IEnumOleUndoUnits): HRESULT; stdcall;

        function EnumRedoable(
        {__RPC__deref_out_opt }  out ppEnum: IEnumOleUndoUnits): HRESULT; stdcall;

        function GetLastUndoDescription(
        {__RPC__deref_out_opt } pBstr: PBSTR): HRESULT; stdcall;

        function GetLastRedoDescription(
        {__RPC__deref_out_opt } pBstr: PBSTR): HRESULT; stdcall;

        function Enable(fEnable: boolean): HRESULT; stdcall;

    end;

    PIOleUndoManager = ^IOleUndoManager;


    tagPOINTERINACTIVE = (
        POINTERINACTIVE_ACTIVATEONENTRY = 1,
        POINTERINACTIVE_DEACTIVATEONLEAVE = 2,
        POINTERINACTIVE_ACTIVATEONDRAG = 4);

    TPOINTERINACTIVE = tagPOINTERINACTIVE;
    PPOINTERINACTIVE = ^TPOINTERINACTIVE;


    IPointerInactive = interface(IUnknown)
        ['{55980BA0-35AA-11CF-B671-00AA004CD6D8}']
        function GetActivationPolicy(
        {__RPC__out } pdwPolicy: PDWORD): HRESULT; stdcall;

        function OnInactiveMouseMove(
        {__RPC__in } pRectBounds: LPCRECT; x: LONG; y: LONG; grfKeyState: DWORD): HRESULT; stdcall;

        function OnInactiveSetCursor(
        {__RPC__in } pRectBounds: LPCRECT; x: LONG; y: LONG; dwMouseMsg: DWORD; fSetAlways: boolean): HRESULT; stdcall;

    end;


    IObjectWithSite = interface(IUnknown)
        ['{FC4801A3-2BA9-11CF-A229-00AA003D7352}']
        function SetSite(
        {__RPC__in_opt } pUnkSite: IUnknown): HRESULT; stdcall;

        function GetSite(
        {__RPC__in } riid: REFIID;
        {__RPC__deref_out_opt }  out ppvSite): HRESULT; stdcall;

    end;


    tagCALPOLESTR = record
        cElems: ULONG; (* [size_is] *)
        pElems: PLPOLESTR;
    end;
    TCALPOLESTR = tagCALPOLESTR;
    PCALPOLESTR = ^TCALPOLESTR;

    LPCALPOLESTR = ^TCALPOLESTR;


    tagCADWORD = record
        cElems: ULONG; (* [size_is] *)
        pElems: PDWORD;
    end;
    TCADWORD = tagCADWORD;
    PCADWORD = ^TCADWORD;

    LPCADWORD = ^TCADWORD;


    IPerPropertyBrowsing = interface(IUnknown)
        ['{376BD3AA-3845-101B-84ED-08002B2EC713}']
        function GetDisplayString(dispID: TDISPID;
        {__RPC__deref_out_opt } pBstr: PBSTR): HRESULT; stdcall;

        function MapPropertyToPage(dispID: TDISPID;
        {__RPC__out } pClsid: PCLSID): HRESULT; stdcall;

        function GetPredefinedStrings(dispID: TDISPID;
        {__RPC__out } pCaStringsOut: PCALPOLESTR;
        {__RPC__out } pCaCookiesOut: PCADWORD): HRESULT; stdcall;

        function GetPredefinedValue(dispID: TDISPID; dwCookie: DWORD;
        {__RPC__out } pVarOut: PVARIANT): HRESULT; stdcall;

    end;


    tagPROPBAG2_TYPE = (
        PROPBAG2_TYPE_UNDEFINED = 0,
        PROPBAG2_TYPE_DATA = 1,
        PROPBAG2_TYPE_URL = 2,
        PROPBAG2_TYPE_OBJECT = 3,
        PROPBAG2_TYPE_STREAM = 4,
        PROPBAG2_TYPE_STORAGE = 5,
        PROPBAG2_TYPE_MONIKER = 6);

    TPROPBAG2_TYPE = tagPROPBAG2_TYPE;
    PPROPBAG2_TYPE = ^TPROPBAG2_TYPE;


    tagPROPBAG2 = record
        dwType: DWORD;
        vt: TVARTYPE;
        cfType: TCLIPFORMAT;
        dwHint: DWORD;
        pstrName: LPOLESTR;
        clsid: TCLSID;
    end;
    TPROPBAG2 = tagPROPBAG2;
    PPROPBAG2 = ^TPROPBAG2;


    IPropertyBag2 = interface(IUnknown)
        ['{22F55882-280B-11d0-A8A9-00A0C90C2004}']
        function Read(cProperties: ULONG;
        {__RPC__in_ecount_full(cProperties) } pPropBag: PPROPBAG2;
        {__RPC__in_opt } pErrLog: IErrorLog;
        {__RPC__out_ecount_full(cProperties) } pvarValue: PVARIANT;
        {__RPC__inout_ecount_full_opt(cProperties) } phrError: PHRESULT): HRESULT; stdcall;

        function Write(cProperties: ULONG;
        {__RPC__in_ecount_full(cProperties) } pPropBag: PPROPBAG2;
        {__RPC__in_ecount_full(cProperties) } pvarValue: PVARIANT): HRESULT; stdcall;

        function CountProperties(
        {__RPC__out } pcProperties: PULONG): HRESULT; stdcall;

        function GetPropertyInfo(iProperty: ULONG; cProperties: ULONG;
        {__RPC__out_ecount_full(cProperties) } pPropBag: PPROPBAG2;
        {__RPC__out } pcProperties: PULONG): HRESULT; stdcall;

        function LoadObject(
        {__RPC__in } pstrName: LPCOLESTR; dwHint: DWORD;
        {__RPC__in_opt } pUnkObject: IUnknown;
        {__RPC__in_opt } pErrLog: IErrorLog): HRESULT; stdcall;

    end;

    PIPropertyBag2 = ^IPropertyBag2;


    IPersistPropertyBag2 = interface(IPersist)
        ['{22F55881-280B-11d0-A8A9-00A0C90C2004}']
        function InitNew(): HRESULT; stdcall;

        function Load(
        {__RPC__in_opt } pPropBag: IPropertyBag2;
        {__RPC__in_opt } pErrLog: IErrorLog): HRESULT; stdcall;

        function Save(
        {__RPC__in_opt } pPropBag: IPropertyBag2; fClearDirty: boolean; fSaveAllProperties: boolean): HRESULT; stdcall;

        function IsDirty(): HRESULT; stdcall;

    end;

    PIPersistPropertyBag2 = ^IPersistPropertyBag2;


    IAdviseSinkEx = interface(IAdviseSink)
        ['{3AF24290-0C96-11CE-A0CF-00AA00600AB8}']
        procedure OnViewStatusChange(dwViewStatus: DWORD); stdcall;

    end;

    PIAdviseSinkEx = ^IAdviseSinkEx;


    tagQACONTAINERFLAGS = (
        QACONTAINER_SHOWHATCHING = $1,
        QACONTAINER_SHOWGRABHANDLES = $2,
        QACONTAINER_USERMODE = $4,
        QACONTAINER_DISPLAYASDEFAULT = $8,
        QACONTAINER_UIDEAD = $10,
        QACONTAINER_AUTOCLIP = $20,
        QACONTAINER_MESSAGEREFLECT = $40,
        QACONTAINER_SUPPORTSMNEMONICS = $80);

    TQACONTAINERFLAGS = tagQACONTAINERFLAGS;
    PQACONTAINERFLAGS = ^TQACONTAINERFLAGS;

    OLE_COLOR = DWORD; // DECLSPEC_UUID("66504301-BE0F-101A-8BBB-00AA00300CAB")
    POLE_COLOR = ^OLE_COLOR;

    tagQACONTAINER = record
        cbSize: ULONG;
        pClientSite: PIOleClientSite;
        pAdviseSink: PIAdviseSinkEx;
        pPropertyNotifySink: PIPropertyNotifySink;
        pUnkEventSink: PIUnknown;
        dwAmbientFlags: DWORD;
        colorFore: OLE_COLOR;
        colorBack: OLE_COLOR;
        pFont: PIFont;
        pUndoMgr: PIOleUndoManager;
        dwAppearance: DWORD;
        lcid: LONG;
        hpal: HPALETTE;
        pBindHost: PIBindHost;
        pOleControlSite: PIOleControlSite;
        pServiceProvider: PIServiceProvider;
    end;
    TQACONTAINER = tagQACONTAINER;
    PQACONTAINER = ^TQACONTAINER;


    tagQACONTROL = record
        cbSize: ULONG;
        dwMiscStatus: DWORD;
        dwViewStatus: DWORD;
        dwEventCookie: DWORD;
        dwPropNotifyCookie: DWORD;
        dwPointerActivationPolicy: DWORD;
    end;
    TQACONTROL = tagQACONTROL;
    PQACONTROL = ^TQACONTROL;


    IQuickActivate = interface(IUnknown)
        ['{CF51ED10-62FE-11CF-BF86-00A0C9034836}']
        function QuickActivate(pQaContainer: PQACONTAINER; pQaControl: PQACONTROL): HRESULT; stdcall;

        function SetContentExtent(
        {__RPC__in } pSizel: LPSIZEL): HRESULT; stdcall;

        function GetContentExtent(
        {__RPC__out } pSizel: LPSIZEL): HRESULT; stdcall;

    end;


implementation

end.
