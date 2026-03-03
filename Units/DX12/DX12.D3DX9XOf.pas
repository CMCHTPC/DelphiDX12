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

   Copyright (C) Microsoft Corporation.  All Rights Reserved.
   Content:    D3DX .X File types and functions

   This unit consists of the following header files
   File name: d3dx9xof.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.D3DX9XOf;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils;

    {$Z4}


    // for different SDK versions
    {$I DX12.DX9SDKVersion.inc}

const


    //----------------------------------------------------------------------------
    // D3DXF_FILEFORMAT
    //   This flag is used to specify what file type to use when saving to disk.
    //   _BINARY, and _TEXT are mutually exclusive, while
    //   _COMPRESSED is an optional setting that works with all file types.
    //----------------------------------------------------------------------------


    D3DXF_FILEFORMAT_BINARY = 0;
    D3DXF_FILEFORMAT_TEXT = 1;
    D3DXF_FILEFORMAT_COMPRESSED = 2;

    //----------------------------------------------------------------------------
    // D3DXF_FILESAVEOPTIONS
    //   This flag is used to specify where to save the file to. Each flag is
    //   mutually exclusive, indicates the data location of the file, and also
    //   chooses which additional data will specify the location.
    //   _TOFILE is paired with a filename (LPCSTR)
    //   _TOWFILE is paired with a filename (LPWSTR)
    //----------------------------------------------------------------------------


    D3DXF_FILESAVE_TOFILE = $00;
    D3DXF_FILESAVE_TOWFILE = $01;

    //----------------------------------------------------------------------------
    // D3DXF_FILELOADOPTIONS
    //   This flag is used to specify where to load the file from. Each flag is
    //   mutually exclusive, indicates the data location of the file, and also
    //   chooses which additional data will specify the location.
    //   _FROMFILE is paired with a filename (LPCSTR)
    //   _FROMWFILE is paired with a filename (LPWSTR)
    //   _FROMRESOURCE is paired with a (D3DXF_FILELOADRESOUCE*) description.
    //   _FROMMEMORY is paired with a (D3DXF_FILELOADMEMORY*) description.
    //----------------------------------------------------------------------------


    D3DXF_FILELOAD_FROMFILE = $00;
    D3DXF_FILELOAD_FROMWFILE = $01;
    D3DXF_FILELOAD_FROMRESOURCE = $02;
    D3DXF_FILELOAD_FROMMEMORY = $03;




    // {cef08cf9-7b4f-4429-9624-2a690a933201}
    IID_ID3DXFile: TGUID = '{CEF08CF9-7B4F-4429-9624-2A690A933201}';


    // {cef08cfa-7b4f-4429-9624-2a690a933201}
    IID_ID3DXFileSaveObject: TGUID = '{CEF08CFA-7B4F-4429-9624-2A690A933201}';


    // {cef08cfb-7b4f-4429-9624-2a690a933201}
    IID_ID3DXFileSaveData: TGUID = '{CEF08CFB-7B4F-4429-9624-2A690A933201}';


    // {cef08cfc-7b4f-4429-9624-2a690a933201}
    IID_ID3DXFileEnumObject: TGUID = '{CEF08CFC-7B4F-4429-9624-2A690A933201}';


    // {cef08cfd-7b4f-4429-9624-2a690a933201}
    IID_ID3DXFileData: TGUID = '{CEF08CFD-7B4F-4429-9624-2A690A933201}';


    (*
 * DirectX File errors.
 *)

    _FACD3DXF = $876;

    D3DXFERR_BADOBJECT = ((1 shl 31) or (_FACD3DXF shl 16) or (900));
    D3DXFERR_BADVALUE = ((1 shl 31) or (_FACD3DXF shl 16) or (901));
    D3DXFERR_BADTYPE = ((1 shl 31) or (_FACD3DXF shl 16) or (902));
    D3DXFERR_NOTFOUND = ((1 shl 31) or (_FACD3DXF shl 16) or (903));
    D3DXFERR_NOTDONEYET = ((1 shl 31) or (_FACD3DXF shl 16) or (904));
    D3DXFERR_FILENOTFOUND = ((1 shl 31) or (_FACD3DXF shl 16) or (905));
    D3DXFERR_RESOURCENOTFOUND = ((1 shl 31) or (_FACD3DXF shl 16) or (906));
    D3DXFERR_BADRESOURCE = ((1 shl 31) or (_FACD3DXF shl 16) or (907));
    D3DXFERR_BADFILETYPE = ((1 shl 31) or (_FACD3DXF shl 16) or (908));
    D3DXFERR_BADFILEVERSION = ((1 shl 31) or (_FACD3DXF shl 16) or (909));
    D3DXFERR_BADFILEFLOATSIZE = ((1 shl 31) or (_FACD3DXF shl 16) or (910));
    D3DXFERR_BADFILE = ((1 shl 31) or (_FACD3DXF shl 16) or (911));
    D3DXFERR_PARSEERROR = ((1 shl 31) or (_FACD3DXF shl 16) or (912));
    D3DXFERR_BADARRAYSIZE = ((1 shl 31) or (_FACD3DXF shl 16) or (913));
    D3DXFERR_BADDATAREFERENCE = ((1 shl 31) or (_FACD3DXF shl 16) or (914));
    D3DXFERR_NOMOREOBJECTS = ((1 shl 31) or (_FACD3DXF shl 16) or (915));
    D3DXFERR_NOMOREDATA = ((1 shl 31) or (_FACD3DXF shl 16) or (916));
    D3DXFERR_BADCACHEFILE = ((1 shl 31) or (_FACD3DXF shl 16) or (917));


type
    REFGUID = ^TGUID;

    TD3DXF_FILEFORMAT = DWORD;
    TD3DXF_FILESAVEOPTIONS = DWORD;
    TD3DXF_FILELOADOPTIONS = DWORD;
    //----------------------------------------------------------------------------
    // D3DXF_FILELOADRESOURCE:
    //----------------------------------------------------------------------------

    _D3DXF_FILELOADRESOURCE = record
        hModule: HMODULE; // Desc
        lpName: LPCSTR; // Desc
        lpType: LPCSTR; // Desc
    end;
    TD3DXF_FILELOADRESOURCE = _D3DXF_FILELOADRESOURCE;
    PD3DXF_FILELOADRESOURCE = ^TD3DXF_FILELOADRESOURCE;



    //----------------------------------------------------------------------------
    // D3DXF_FILELOADMEMORY:
    //----------------------------------------------------------------------------

    _D3DXF_FILELOADMEMORY = record
        lpMemory: LPCVOID; // Desc
        dSize: SIZE_T; // Desc
    end;
    TD3DXF_FILELOADMEMORY = _D3DXF_FILELOADMEMORY;
    PD3DXF_FILELOADMEMORY = ^TD3DXF_FILELOADMEMORY;



    ID3DXFile = interface;


    ID3DXFileSaveObject = interface;


    ID3DXFileSaveData = interface;


    ID3DXFileEnumObject = interface;


    ID3DXFileData = interface;



    //////////////////////////////////////////////////////////////////////////////
    // ID3DXFile /////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////



    ID3DXFile = interface(IUnknown)
        ['{CEF08CF9-7B4F-4429-9624-2A690A933201}']
        function CreateEnumObject(
        {out} out pvSource: LPCVOID;
        {in} loadflags: TD3DXF_FILELOADOPTIONS;
        {out} out ppEnumObj: ID3DXFileEnumObject): HRESULT; stdcall;

        function CreateSaveObject(
        {in} pData: LPCVOID;
        {in} flags: TD3DXF_FILESAVEOPTIONS;
        {in} dwFileFormat: TD3DXF_FILEFORMAT;
        {out} out ppSaveObj: ID3DXFileSaveObject): HRESULT; stdcall;

        function RegisterTemplates(
        {in} pvData: LPCVOID;
        {in} cbSize: SIZE_T): HRESULT; stdcall;

        function RegisterEnumTemplates(
        {in} pEnum: ID3DXFileEnumObject): HRESULT; stdcall;

    end;


    //////////////////////////////////////////////////////////////////////////////
    // ID3DXFileSaveObject ///////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////


    ID3DXFileSaveObject = interface(IUnknown)
        ['{CEF08CFA-7B4F-4429-9624-2A690A933201}']
        function GetFile(
        {in}  ppFile: ID3DXFile): HRESULT; stdcall;

        function AddDataObject(
        {in}   rguidTemplate: REFGUID;
        {in}  szName: LPCSTR;
        {in}  pId: PGUID;
        {in}   cbSize: SIZE_T;
        {in}   pvData: LPCVOID;
        {in, retval} var ppObj: ID3DXFileSaveData): HRESULT; stdcall;

        function Save(): HRESULT; stdcall;

    end;


    //////////////////////////////////////////////////////////////////////////////
    // ID3DXFileSaveData /////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////


    ID3DXFileSaveData = interface(IUnknown)
        ['{CEF08CFB-7B4F-4429-9624-2A690A933201}']
        function GetSave(
        {out} out ppObj: ID3DXFileSaveObject): HRESULT; stdcall;

        function GetName(
        {in}  szName: LPSTR;
        {in_out}  puiSize: PSIZE_T): HRESULT; stdcall;

        function GetId(
        {out}  pId: LPGUID): HRESULT; stdcall;

        function GetType(
        {in} _type: PGUID): HRESULT; stdcall;

        function AddDataObject(
        {in} rguidTemplate: REFGUID;
        {in} szName: LPCSTR;
        {in} pId: PGUID;
        {in} cbSize: SIZE_T;
        {in} pvData: LPCVOID;
        {in, retval} var ppObj: ID3DXFileSaveData): HRESULT; stdcall;

        function AddDataReference(
        {in} szName: LPCSTR;
        {in} pId: PGUID): HRESULT; stdcall;

    end;


    //////////////////////////////////////////////////////////////////////////////
    // ID3DXFileEnumObject ///////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    ID3DXFileEnumObject = interface(IUnknown)
        ['{CEF08CFC-7B4F-4429-9624-2A690A933201}']
        function GetFile(
        {out} out ppFile: ID3DXFile): HRESULT; stdcall;

        function GetChildren(
        {in} puiChildren: PSIZE_T): HRESULT; stdcall;

        function GetChild(
        {in} id: SIZE_T;
        {out} out ppObj: ID3DXFileData): HRESULT; stdcall;

        function GetDataObjectById(
        {in} rguid: REFGUID;
        {out} out ppDataObj: ID3DXFILEDATA): HRESULT; stdcall;

        function GetDataObjectByName(
        {in} szName: LPCSTR;
        {out} out ppObj: ID3DXFileData): HRESULT; stdcall;

    end;


    //////////////////////////////////////////////////////////////////////////////
    // ID3DXFileData /////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    ID3DXFileData = interface(IUnknown)
        ['{CEF08CFD-7B4F-4429-9624-2A690A933201}']
        function GetEnum(
        {in **} out ppObj: ID3DXFileEnumObject): HRESULT; stdcall;

        function GetName(
        {in} szName: LPSTR;
        {in-out} puiSize: PSIZE_T): HRESULT; stdcall;

        function GetId(
        {out} pId: LPGUID): HRESULT; stdcall;

        function Lock(
        {in} pSize: PSIZE_T;
        {in} ppData: LPCVOID): HRESULT; stdcall;

        function Unlock(): HRESULT; stdcall;

        function GetType(
        {in} pType: PGUID): HRESULT; stdcall;

        function IsReference(): boolean; stdcall;

        function GetChildren(
        {in} puiChildren: PSIZE_T): HRESULT; stdcall;

        function GetChild(
        {in} uiChild: SIZE_T;
        {out} out ppChild: ID3DXFileData): HRESULT; stdcall;

    end;


function D3DXFileCreate(out lplpDirectXFile: ID3DXFile): HResult; stdcall; external D3DX9_DLL;




implementation

end.
