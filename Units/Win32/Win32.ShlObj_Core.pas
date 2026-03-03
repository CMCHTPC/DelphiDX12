// not finshed
unit Win32.ShlObj_Core;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    Win32.SHTypes,
    Win32.ObjIdl;

    {$DEFINE NTDDI_WINXP}
    {$DEFINE NTDDI_VISTA}
    {$DEFINE NTDDI_WIN7}
    {$DEFINE NTDDI_WIN8}



const
    Shell32_dll = 'Shell32.dll';

    IID_IExtractIconA: TGUID = '{000214eb-0000-0000-c000-000000000046}';
    IID_IExtractIconW: TGUID = '{000214fa-0000-0000-c000-000000000046}';

    // GetIconLocation() input flags

    GIL_OPENICON = $0001; // allows containers to specify an "open" look
    GIL_FORSHELL = $0002; // icon is to be displayed in a ShellFolder
    GIL_ASYNC = $0020; // this is an async extract, return E_PENDING
    GIL_DEFAULTICON = $0040; // get the default icon location if the final one takes too long to get
    GIL_FORSHORTCUT = $0080; // the icon is for a shortcut to the object
    GIL_CHECKSHIELD = $0200; // return GIL_SHIELD or GIL_FORCENOSHIELD, don't block if GIL_ASYNC is set

    // GetIconLocation() return flags

    GIL_SIMULATEDOC = $0001; // simulate this document icon for this
    GIL_PERINSTANCE = $0002; // icons from this class are per instance (each file has its own)
    GIL_PERCLASS = $0004; // icons from this class per class (shared for all files of this type)
    GIL_NOTFILENAME = $0008; // location is not a filename, must call ::ExtractIcon
    GIL_DONTCACHE = $0010; // this icon should not be cached
    GIL_SHIELD = $0200; // icon should be "stamped" with the LUA shield
    GIL_FORCENOSHIELD = $0400; // icon must *not* be "stamped" with the LUA shield



    SIOM_OVERLAYINDEX = $1;
    SIOM_ICONINDEX = $2;
    SIOM_RESERVED_SHARED = 0;
    SIOM_RESERVED_LINK = 1;
    SIOM_RESERVED_SLOWFILE = 2;
    SIOM_RESERVED_DEFAULT = 3;


    OI_DEFAULT = $00000000;
    OI_ASYNC = $FFFFEEEE;

    IDO_SHGIOI_SHARE = $0FFFFFFF;
    IDO_SHGIOI_LINK = $0FFFFFFE;
    IDO_SHGIOI_SLOWFILE = $0FFFFFFFD;
    IDO_SHGIOI_DEFAULT = $0FFFFFFFC;


    NT_CONSOLE_PROPS_SIG = $A0000002;
    NT_FE_CONSOLE_PROPS_SIG = $A0000004;

    EXP_SPECIAL_FOLDER_SIG = $A0000005; // LPEXP_SPECIAL_FOLDER
    EXP_DARWIN_ID_SIG = $A0000006;

    EXP_SZ_LINK_SIG = $A0000001; // LPEXP_SZ_LINK (target)
    EXP_SZ_ICON_SIG = $A0000007; // LPEXP_SZ_LINK (icon)
    EXP_PROPERTYSTORAGE_SIG = $A0000009;


    //--------------------------------------------------------------------------

    // Command/menuitem IDs

    //  The explorer dispatches WM_COMMAND messages based on the range of
    // command/menuitem IDs. All the IDs of menuitems that the view (right
    // pane) inserts must be in FCIDM_SHVIEWFIRST/LAST (otherwise, the explorer
    // won't dispatch them). The view should not deal with any menuitems
    // in FCIDM_BROWSERFIRST/LAST (otherwise, it won't work with the future
    // version of the shell).

    //  FCIDM_SHVIEWFIRST/LAST      for the right pane (IShellView)
    //  FCIDM_BROWSERFIRST/LAST     for the explorer frame (IShellBrowser)
    //  FCIDM_GLOBAL/LAST           for the explorer's submenu IDs

    //--------------------------------------------------------------------------

    FCIDM_SHVIEWFIRST = $0000;
    FCIDM_SHVIEWLAST = $7fff;
    FCIDM_BROWSERFIRST = $a000;
    FCIDM_BROWSERLAST = $bf00;
    FCIDM_GLOBALFIRST = $8000;
    FCIDM_GLOBALLAST = $9fff;


    // Global submenu IDs and separator IDs

    FCIDM_MENU_FILE = (FCIDM_GLOBALFIRST + $0000);
    FCIDM_MENU_EDIT = (FCIDM_GLOBALFIRST + $0040);
    FCIDM_MENU_VIEW = (FCIDM_GLOBALFIRST + $0080);
    FCIDM_MENU_VIEW_SEP_OPTIONS = (FCIDM_GLOBALFIRST + $0081);
    FCIDM_MENU_TOOLS = (FCIDM_GLOBALFIRST + $00c0); // for Win9x compat
    FCIDM_MENU_TOOLS_SEP_GOTO = (FCIDM_GLOBALFIRST + $00c1); // for Win9x compat
    FCIDM_MENU_HELP = (FCIDM_GLOBALFIRST + $0100);
    FCIDM_MENU_FIND = (FCIDM_GLOBALFIRST + $0140);
    FCIDM_MENU_EXPLORE = (FCIDM_GLOBALFIRST + $0150);
    FCIDM_MENU_FAVORITES = (FCIDM_GLOBALFIRST + $0170);

    OFASI_EDIT = $0001;
    OFASI_OPENDESKTOP = $0002;



    // SHGetSpecialFolderLocation

    //  Caller should use SHGetMalloc to obtain an allocator that can free the pidl

    // registry entries for special paths are kept in :

    CSIDL_DESKTOP = $0000; // <desktop>
    CSIDL_INTERNET = $0001; // Internet Explorer (icon on desktop)
    CSIDL_PROGRAMS = $0002; // Start Menu\Programs
    CSIDL_CONTROLS = $0003; // My Computer\Control Panel
    CSIDL_PRINTERS = $0004; // My Computer\Printers
    CSIDL_PERSONAL = $0005; // My Documents
    CSIDL_FAVORITES = $0006; // <user name>\Favorites
    CSIDL_STARTUP = $0007; // Start Menu\Programs\Startup
    CSIDL_RECENT = $0008; // <user name>\Recent
    CSIDL_SENDTO = $0009; // <user name>\SendTo
    CSIDL_BITBUCKET = $000a; // <desktop>\Recycle Bin
    CSIDL_STARTMENU = $000b; // <user name>\Start Menu
    CSIDL_MYDOCUMENTS = CSIDL_PERSONAL; //  Personal was just a silly name for My Documents
    CSIDL_MYMUSIC = $000d; // "My Music" folder
    CSIDL_MYVIDEO = $000e; // "My Videos" folder
    CSIDL_DESKTOPDIRECTORY = $0010; // <user name>\Desktop
    CSIDL_DRIVES = $0011; // My Computer
    CSIDL_NETWORK = $0012; // Network Neighborhood (My Network Places)
    CSIDL_NETHOOD = $0013; // <user name>\nethood
    CSIDL_FONTS = $0014; // windows\fonts
    CSIDL_TEMPLATES = $0015;
    CSIDL_COMMON_STARTMENU = $0016; // All Users\Start Menu
    CSIDL_COMMON_PROGRAMS = $0017; // All Users\Start Menu\Programs
    CSIDL_COMMON_STARTUP = $0018; // All Users\Startup
    CSIDL_COMMON_DESKTOPDIRECTORY = $0019; // All Users\Desktop
    CSIDL_APPDATA = $001a; // <user name>\Application Data
    CSIDL_PRINTHOOD = $001b; // <user name>\PrintHood


    CSIDL_LOCAL_APPDATA = $001c; // <user name>\Local Settings\Applicaiton Data (non roaming)


    CSIDL_ALTSTARTUP = $001d; // non localized startup
    CSIDL_COMMON_ALTSTARTUP = $001e; // non localized common startup
    CSIDL_COMMON_FAVORITES = $001f;


    CSIDL_INTERNET_CACHE = $0020;
    CSIDL_COOKIES = $0021;
    CSIDL_HISTORY = $0022;
    CSIDL_COMMON_APPDATA = $0023; // All Users\Application Data
    CSIDL_WINDOWS = $0024; // GetWindowsDirectory()
    CSIDL_SYSTEM = $0025; // GetSystemDirectory()
    CSIDL_PROGRAM_FILES = $0026; // C:\Program Files
    CSIDL_MYPICTURES = $0027; // C:\Program Files\My Pictures


    CSIDL_PROFILE = $0028; // USERPROFILE
    CSIDL_SYSTEMX86 = $0029; // x86 system directory on RISC
    CSIDL_PROGRAM_FILESX86 = $002a; // x86 C:\Program Files on RISC


    CSIDL_PROGRAM_FILES_COMMON = $002b; // C:\Program Files\Common


    CSIDL_PROGRAM_FILES_COMMONX86 = $002c; // x86 Program Files\Common on RISC
    CSIDL_COMMON_TEMPLATES = $002d; // All Users\Templates


    CSIDL_COMMON_DOCUMENTS = $002e; // All Users\Documents
    CSIDL_COMMON_ADMINTOOLS = $002f; // All Users\Start Menu\Programs\Administrative Tools
    CSIDL_ADMINTOOLS = $0030; // <user name>\Start Menu\Programs\Administrative Tools


    CSIDL_CONNECTIONS = $0031; // Network and Dial-up Connections
    CSIDL_COMMON_MUSIC = $0035; // All Users\My Music
    CSIDL_COMMON_PICTURES = $0036; // All Users\My Pictures
    CSIDL_COMMON_VIDEO = $0037; // All Users\My Video
    CSIDL_RESOURCES = $0038; // Resource Direcotry


    CSIDL_RESOURCES_LOCALIZED = $0039; // Localized Resource Direcotry


    CSIDL_COMMON_OEM_LINKS = $003a; // Links to All Users OEM specific apps
    CSIDL_CDBURN_AREA = $003b; // USERPROFILE\Local Settings\Application Data\Microsoft\CD Burning
    // unused                               0x003c
    CSIDL_COMPUTERSNEARME = $003d; // Computers Near Me (computered from Workgroup membership)


    CSIDL_FLAG_CREATE = $8000; // combine with CSIDL_ value to force folder creation in SHGetFolderPath()


    CSIDL_FLAG_DONT_VERIFY = $4000; // combine with CSIDL_ value to return an unverified folder path
    CSIDL_FLAG_DONT_UNEXPAND = $2000; // combine with CSIDL_ value to avoid unexpanding environment variables

    CSIDL_FLAG_NO_ALIAS = $1000; // combine with CSIDL_ value to insure non-alias versions of the pidl
    CSIDL_FLAG_PER_USER_INIT = $0800; // combine with CSIDL_ value to indicate per-user init (eg. upgrade)

    CSIDL_FLAG_MASK = $FF00; // mask for all possible flag values



    KF_FLAG_DEFAULT = $00000000;

type
    {$PACKRECORDS 1}(* Assume byte packing throughout *)

    PHICON = ^HICON;


    //===========================================================================
    // IExtractIcon interface
    //  This interface is used in two different places in the shell.
    // Case-1: Icons of sub-folders for the scope-pane of the explorer.
    //  It is used by the explorer to get the "icon location" of
    // sub-folders from each shell folders. When the user expands a folder
    // in the scope pane of the explorer, the explorer does following:
    //  (1) binds to the folder (gets IShellFolder),
    //  (2) enumerates its sub-folders by calling its EnumObjects member,
    //  (3) calls its GetUIObjectOf member to get IExtractIcon interface
    //     for each sub-folders.
    //  In this case, the explorer uses only IExtractIcon::GetIconLocation
    // member to get the location of the appropriate icon. An icon location
    // always consists of a file name (typically DLL or EXE) and either an icon
    // resource or an icon index.
    // Case-2: Extracting an icon image from a file
    //  It is used by the shell when it extracts an icon image
    // from a file. When the shell is extracting an icon from a file,
    // it does following:
    //  (1) creates the icon extraction handler object (by getting its CLSID
    //     under the {ProgID}\shell\ExtractIconHanler key and calling
    //     CoCreateInstance requesting for IExtractIcon interface).
    //  (2) Calls IExtractIcon::GetIconLocation.
    //  (3) Then, calls IExtractIcon::ExtractIcon with the location/index pair.
    //  (4) If (3) returns S_OK, it uses the returned icon.
    //  (5) Otherwise, it recursively calls this logic with new location
    //     assuming that the location string contains a fully qualified path name.
    //  From extension programmer's point of view, there are only two cases
    // where they provide implementations of IExtractIcon:
    //  Case-1) providing explorer extensions (i.e., IShellFolder).
    //  Case-2) providing per-instance icons for some types of files.
    // Because Case-1 is described above, we'll explain only Case-2 here.
    // When the shell is about display an icon for a file, it does following:
    //  (1) Finds its ProgID and ClassID.
    //  (2) If the file has a ClassID, it gets the icon location string from the
    //    "DefaultIcon" key under it. The string indicates either per-class
    //    icon (e.g., "EXAMPLE.DLL,2") or per-instance icon (e.g., "%1,1").
    //  (3) If a per-instance icon is specified, the shell creates an icon
    //    extraction handler object for it, and extracts the icon from it
    //    (which is described above).
    //  It is important to note that the shell calls IExtractIcon::GetIconLocation
    // first, then calls IExtractIcon::Extract. Most application programs
    // that support per-instance icons will probably store an icon location
    // (DLL/EXE name and index/id) rather than an icon image in each file.
    // In those cases, a programmer needs to implement only the GetIconLocation
    // member and it Extract member simply returns S_FALSE. They need to
    // implement Extract member only if they decided to store the icon images
    // within files themselved or some other database (which is very rare).
    // [Member functions]
    // IExtractIcon::GetIconLocation
    //  This function returns an icon location.
    //  Parameters:
    //   uFlags     [in]  -- Specifies if it is opened or not (GIL_OPENICON or 0)
    //   szIconFile [out] -- Specifies the string buffer buffer for a location name.
    //   cchMax     [in]  -- Specifies the size of szIconFile (almost always MAX_PATH)
    //   piIndex    [out] -- Sepcifies the address of UINT for the index.
    //   pwFlags    [out] -- Returns GIL_* flags
    //  Returns:
    //   S_OK, if it returns a valid location; S_FALSE, if the shell use a
    //   default icon.
    //  Notes: The location may or may not be a path to a file. The caller can
    //   not assume anything unless the subsequent Extract member call returns
    //   S_FALSE.
    //   if the returned location is not a path to a file, GIL_NOTFILENAME should
    //   be set in the returned flags.
    // IExtractIcon::Extract
    //  This function extracts an icon image from a specified file.
    //  Parameters:
    //   pszFile [in] -- Specifies the icon location (typically a path to a file).
    //   nIconIndex [in] -- Specifies the icon index.
    //   phiconLarge [out] -- Specifies the HICON variable for large icon.
    //   phiconSmall [out] -- Specifies the HICON variable for small icon.
    //   nIconSize [in] -- Specifies the size icon required (size of large icon)
    //                     LOWORD is the requested large icon size
    //                     HIWORD is the requested small icon size
    //  Returns:
    //   S_OK, if it extracted the from the file.
    //   S_FALSE, if the caller should extract from the file specified in the
    //           location.
    //===========================================================================



    IExtractIconA = interface(IUnknown)
        ['{000214eb-0000-0000-c000-000000000046}']
        function GetIconLocation(uFlags: UINT;
        {_Out_writes_(cchMax) } pszIconFile: PSTR; cchMax: UINT;
        {_Out_ } piIndex: PINT32;
        {_Out_ } pwFlags: PUINT): HRESULT; stdcall;

        function Extract(
        {_In_  } pszFile: PCSTR; nIconIndex: UINT;
        {_Out_opt_ } phiconLarge: PHICON;
        {_Out_opt_ } phiconSmall: PHICON; nIconSize: UINT): HRESULT; stdcall;

    end;

    LPEXTRACTICONA = ^IExtractIconA;



    IExtractIconW = interface(IUnknown)
        ['{000214fa-0000-0000-c000-000000000046}']
        function GetIconLocation(uFlags: UINT;
        {_Out_writes_(cchMax) } pszIconFile: PWSTR; cchMax: UINT;
        {_Out_ } piIndex: PINT32;
        {_Out_ } pwFlags: PUINT): HRESULT; stdcall;

        function Extract(
        {_In_ } pszFile: PCWSTR; nIconIndex: UINT;
        {_Out_opt_ } phiconLarge: PHICON;
        {_Out_opt_ } phiconSmall: PHICON; nIconSize: UINT): HRESULT; stdcall;

    end;

    LPEXTRACTICONW = ^IExtractIconW;



    //===========================================================================

    // IShellIconOverlayManager

    // Used to return the icon overlay information including OverlayIndex, Image Index or Priority for an IShellFolder object.

    // IShellIconOverlayManager:GetFileOverlayInfo(LPCWSTR pwszPath, DWORD dwAttrib, int * pIndex, DWORD dwflags)
    //      pwszPath        full path of the file
    //      dwAttrib        attribute of this file
    //      pIndex          pointer to the Icon Index in the system image list
    //      pOverlayIndex   pointer to the OverlayIndex in the system image list
    //      pPriority       pointer to the Priority of this overlay
    // IShellIconOverlayManager:GetReservedOverlayInfo(LPCWSTR pwszPath, DWORD dwAttrib, int * pIndex, DWORD dwflags, int iReservedID)
    //      iReservedID     reserved icon overlay id
    //  returns:
    //      S_OK,  if the index of an Overlay is found
    //      S_FALSE, if no Overlay exists for this file
    //      E_FAIL, if lpfd is bad
    // IShellIconOverlayManager:RefreshOverlayImages(DWORD dwFlags)
    //      This will refresh the overlay cache, depends on the dwFlags passed in
    //      It will reload the icons into the imagelist, when passed SIOM_ICONINDEX
    // IShellIconOverlayManager::LoadNonloadedOverlayIdentifiers()
    //      This method loads any registered overlay identifiers (handlers) that
    //      are not currently loaded.
    // IShellIconOverlayManager::OverlayIndexFromImageIndex(int iImage, int *piIndex, BOOL fAdd)
    //      iImage          existing shell image list index to look for
    //      piIndex         returned overlay index
    //      fAdd            Add image if not already present?
    //===========================================================================


    IShellIconOverlayManager = interface(IUnknown)
        ['{f10b5e34-dd3b-42a7-aa7d-2f4ec54bb09b}']
        function GetFileOverlayInfo(
        {_In_ } pwszPath: PCWSTR; dwAttrib: DWORD;
        {_Out_ } pIndex: PINT32; dwflags: DWORD): HRESULT; stdcall;

        function GetReservedOverlayInfo(
        {_In_opt_ } pwszPath: PCWSTR; dwAttrib: DWORD;
        {_Out_ } pIndex: PINT32; dwflags: DWORD; iReservedID: int32): HRESULT; stdcall;

        function RefreshOverlayImages(dwFlags: DWORD): HRESULT; stdcall;

        function LoadNonloadedOverlayIdentifiers(): HRESULT; stdcall;

        function OverlayIndexFromImageIndex(iImage: int32;
        {_Out_ } piIndex: PINT32; fAdd: winbool): HRESULT; stdcall;

    end;



    //===========================================================================

    // IShellIconOverlay

    // Used to return the icon overlay index or its icon index for an IShellFolder object,
    // this is always implemented with IShellFolder

    // IShellIconOverlay:GetOverlayIndex(LPCITEMIDLIST pidl, DWORD * pdwIndex)
    //      pidl            object to identify icon overlay for.
    //      pdwIndex        the Overlay Index in the system image list

    // IShellIconOverlay:GetOverlayIconIndex(LPCITEMIDLIST pidl, DWORD * pdwIndex)
    //      pdwIconIndex    the Overlay Icon index in the system image list
    // This method is only used for those who are interested in seeing the real bits
    // of the Overlay Icon

    //  returns:
    //      S_OK,  if the index of an Overlay is found
    //      S_FALSE, if no Overlay exists for this file
    //      E_FAIL, if pidl is bad

    //===========================================================================


    IShellIconOverlay = interface(IUnknown)
        ['{7d688a70-c613-11d0-999b-00c04fd655e1}']
        function GetOverlayIndex(
        {_In_ } pidl: PCUITEMID_CHILD;
        {_Inout_ } pIndex: PINT32): HRESULT; stdcall;

        function GetOverlayIconIndex(
        {_In_ } pidl: PCUITEMID_CHILD;
        {_Inout_ } pIconIndex: PINT32): HRESULT; stdcall;

    end;



    // IShellLinkDataList::GetFlags()/SetFlags()
    TSHELL_LINK_DATA_FLAGS = (
        SLDF_DEFAULT = $00000000,
        SLDF_HAS_ID_LIST = $00000001, // Shell link saved with ID list
        SLDF_HAS_LINK_INFO = $00000002, // Shell link saved with LinkInfo
        SLDF_HAS_NAME = $00000004,
        SLDF_HAS_RELPATH = $00000008,
        SLDF_HAS_WORKINGDIR = $00000010,
        SLDF_HAS_ARGS = $00000020,
        SLDF_HAS_ICONLOCATION = $00000040,
        SLDF_UNICODE = $00000080, // the strings are unicode
        SLDF_FORCE_NO_LINKINFO = $00000100, // disable LINKINFO tracking information (used to track network drives and compute UNC paths if one exists)
        SLDF_HAS_EXP_SZ = $00000200, // the link contains expandable env strings
        SLDF_RUN_IN_SEPARATE = $00000400, // Run the 16-bit target exe in a separate VDM/WOW
        SLDF_HAS_LOGO3ID = $00000800, // not used anymore
        SLDF_HAS_DARWINID = $00001000, // MSI (Darwin) link that can be installed on demand
        SLDF_RUNAS_USER = $00002000, // Run target as a different user
        SLDF_HAS_EXP_ICON_SZ = $00004000, // contains expandable env string for icon path
        {$IFDEF NTDDI_WINXP}
        SLDF_NO_PIDL_ALIAS = $00008000, // disable IDList alias mapping when parsing the IDList from the path
        SLDF_FORCE_UNCNAME = $00010000, // make GetPath() prefer the UNC name to the local name
        SLDF_RUN_WITH_SHIMLAYER = $00020000, // activate target of this link with shim layer active
        {$IFDEF NTDDI_VISTA}
        SLDF_FORCE_NO_LINKTRACK = $00040000, // disable ObjectID tracking information
        SLDF_ENABLE_TARGET_METADATA = $00080000, // enable caching of target metadata into link
        SLDF_DISABLE_LINK_PATH_TRACKING = $00100000, // disable EXP_SZ_LINK_SIG tracking
        SLDF_DISABLE_KNOWNFOLDER_RELATIVE_TRACKING = $00200000, // disable KnownFolder tracking information (EXP_KNOWN_FOLDER)
        {$IFDEF NTDDI_WIN7}
        SLDF_NO_KF_ALIAS = $00400000, // disable Known Folder alias mapping when loading the IDList during deserialization
        SLDF_ALLOW_LINK_TO_LINK = $00800000, // allows this link to point to another shell link - must only be used when it is not possible to create cycles
        SLDF_UNALIAS_ON_SAVE = $01000000, // unalias the IDList when saving
        SLDF_PREFER_ENVIRONMENT_PATH = $02000000, // the IDList is not persisted, instead it is recalculated from the path with environmental variables at load time
        // we don't hit the disk to recalculate the IDList (the result is a simple IDList).  also Resolve does nothing
        // if SetPath is called and the path does not have environmental variable in it, SLDF_PREFER_ENVIRONMENT_PATH is removed
        SLDF_KEEP_LOCAL_IDLIST_FOR_UNC_TARGET = $04000000, // if target is a UNC location on a local machine, keep the local target in addition to the remote one
        {$IFDEF NTDDI_WIN8}
        SLDF_PERSIST_VOLUME_ID_RELATIVE = $08000000, // persist target idlist in its volume ID-relative form to avoid dependency on drive letters
        SLDF_VALID = $0FFFF7FF, // bits that are valid for ::SetFlags()
        {$ELSE }
        SLDF_VALID = $07FFF7FF, // bits that are valid for ::SetFlags()
        {$ENDIF}
        {$ELSE}
        SLDF_VALID = $003FF7FF, // bits that are valid for ::SetFlags()
        {$ENDIF}
        {$ENDIF}
        SLDF_RESERVED = longint($80000000)// Reserved-- so we can use the low word as an index value in the future
        {$ENDIF}
        );

    PSHELL_LINK_DATA_FLAGS = ^TSHELL_LINK_DATA_FLAGS;



    //===========================================================================
    // Legacy exports that are no longer needed, call the COM API instead
    //===========================================================================

function SHGetMalloc({_Outptr_ }  out ppMalloc: IMalloc): HResult; stdcall; external Shell32_dll;

function SHAlloc(cb: SIZE_T): pointer; stdcall; external Shell32_dll;

procedure SHFree(
    {_In_opt_ } pv: Pvoid); stdcall; external Shell32_dll;



function SHGetSpecialFolderLocation(
    {_Reserved_ } hwnd: HWND;
    {_In_ } csidl: int32;
    {_Outptr_ } out ppidl: PIDLIST_ABSOLUTE): HRESULT; stdcall; external Shell32_dll;

function SHGetKnownFolderPath(
    {_In_ } rfid: REFKNOWNFOLDERID;
    (* KNOWN_FOLDER_FLAG *)
    {_In_ } dwFlags: DWORD;
    {_In_opt_ } hToken: HANDLE;
    {_Outptr_ } out ppszPath: PWSTR): HRESULT; stdcall; external Shell32_dll;



implementation

end.
