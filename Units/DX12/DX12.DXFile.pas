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

   Copyright (C) 1998-1999 Microsoft Corporation.  All Rights Reserved.
   Content:    DirectX File public header file

   This unit consists of the following header files
   File name: dxfile.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.DXFile;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils;

    {$Z4}

const
    D3DXOF_DLL = 'D3dxof.dll';

const
    DXFILEFORMAT_BINARY = 0;
    DXFILEFORMAT_TEXT = 1;
    DXFILEFORMAT_COMPRESSED = 2;

    DXFILELOAD_FROMFILE = $00;
    DXFILELOAD_FROMRESOURCE = $01;
    DXFILELOAD_FROMMEMORY = $02;
    DXFILELOAD_FROMSTREAM = $04;
    DXFILELOAD_FROMURL = $08;


(*
 * DirectXFile Object Class Id (for CoCreateInstance())
 *)

    CLSID_CDirectXFile: TGUID = '{4516EC43-8F20-11D0-9B6D-0000C0781BC3}';

(*
 * DirectX File Interface GUIDs.
 *)

    IID_IDirectXFile: TGUID = '{3D82AB40-62DA-11CF-AB39-0020AF71E433}';
    IID_IDirectXFileEnumObject: TGUID = '{3D82AB41-62DA-11CF-AB39-0020AF71E433}';
    IID_IDirectXFileSaveObject: TGUID = '{3D82AB42-62DA-11CF-AB39-0020AF71E433}';
    IID_IDirectXFileObject: TGUID = '{3D82AB43-62DA-11CF-AB39-0020AF71E433}';
    IID_IDirectXFileData: TGUID = '{3D82AB44-62DA-11CF-AB39-0020AF71E433}';
    IID_IDirectXFileDataReference: TGUID = '{3D82AB45-62DA-11CF-AB39-0020AF71E433}';
    IID_IDirectXFileBinary: TGUID = '{3D82AB46-62DA-11CF-AB39-0020AF71E433}';

(*
 * DirectX File Header template's GUID.
 *)

    TID_DXFILEHeader: TGUID = '{3D82AB43-62DA-11CF-AB39-0020AF71E433}';


    (*
     * DirectX File errors.
     *)

    _FACDD = $876;


    DXFILE_OK = 0;

    DXFILEERR_BADOBJECT = ((1 shl 31) or (_FACDD shl 16) or (850));
    DXFILEERR_BADVALUE = ((1 shl 31) or (_FACDD shl 16) or (851));
    DXFILEERR_BADTYPE = ((1 shl 31) or (_FACDD shl 16) or (852));
    DXFILEERR_BADSTREAMHANDLE = ((1 shl 31) or (_FACDD shl 16) or (853));
    DXFILEERR_BADALLOC = ((1 shl 31) or (_FACDD shl 16) or (854));
    DXFILEERR_NOTFOUND = ((1 shl 31) or (_FACDD shl 16) or (855));
    DXFILEERR_NOTDONEYET = ((1 shl 31) or (_FACDD shl 16) or (856));
    DXFILEERR_FILENOTFOUND = ((1 shl 31) or (_FACDD shl 16) or (857));
    DXFILEERR_RESOURCENOTFOUND = ((1 shl 31) or (_FACDD shl 16) or (858));
    DXFILEERR_URLNOTFOUND = ((1 shl 31) or (_FACDD shl 16) or (859));
    DXFILEERR_BADRESOURCE = ((1 shl 31) or (_FACDD shl 16) or (860));
    DXFILEERR_BADFILETYPE = ((1 shl 31) or (_FACDD shl 16) or (861));
    DXFILEERR_BADFILEVERSION = ((1 shl 31) or (_FACDD shl 16) or (862));
    DXFILEERR_BADFILEFLOATSIZE = ((1 shl 31) or (_FACDD shl 16) or (863));
    DXFILEERR_BADFILECOMPRESSIONTYPE = ((1 shl 31) or (_FACDD shl 16) or (864));
    DXFILEERR_BADFILE = ((1 shl 31) or (_FACDD shl 16) or (865));
    DXFILEERR_PARSEERROR = ((1 shl 31) or (_FACDD shl 16) or (866));
    DXFILEERR_NOTEMPLATE = ((1 shl 31) or (_FACDD shl 16) or (867));
    DXFILEERR_BADARRAYSIZE = ((1 shl 31) or (_FACDD shl 16) or (868));
    DXFILEERR_BADDATAREFERENCE = ((1 shl 31) or (_FACDD shl 16) or (869));
    DXFILEERR_INTERNALERROR = ((1 shl 31) or (_FACDD shl 16) or (870));
    DXFILEERR_NOMOREOBJECTS = ((1 shl 31) or (_FACDD shl 16) or (871));
    DXFILEERR_BADINTRINSICS = ((1 shl 31) or (_FACDD shl 16) or (872));
    DXFILEERR_NOMORESTREAMHANDLES = ((1 shl 31) or (_FACDD shl 16) or (873));
    DXFILEERR_NOMOREDATA = ((1 shl 31) or (_FACDD shl 16) or (874));
    DXFILEERR_BADCACHEFILE = ((1 shl 31) or (_FACDD shl 16) or (875));
    DXFILEERR_NOINTERNET = ((1 shl 31) or (_FACDD shl 16) or (876));

type

    REFGUID = ^TGUID;
(*
 * DirectX File object types.
 *)

    IDirectXFile = interface;
    IDirectXFileEnumObject = interface;
    IDirectXFileSaveObject = interface;
    IDirectXFileObject = interface;
    IDirectXFileData = interface;
    IDirectXFileDataReference = interface;
    IDirectXFileBinary = interface;

    TDXFILEFORMAT = DWORD;


    TDXFILELOADOPTIONS = DWORD;



    _DXFILELOADRESOURCE = record
        hModule: HMODULE;
        lpName: LPCTSTR;
        lpType: LPCTSTR;
    end;
    TDXFILELOADRESOURCE = _DXFILELOADRESOURCE;
    PDXFILELOADRESOURCE = ^TDXFILELOADRESOURCE;

    LPDXFILELOADRESOURCE = ^TDXFILELOADRESOURCE;

    _DXFILELOADMEMORY = record
        lpMemory: LPVOID;
        dSize: DWORD;
    end;
    TDXFILELOADMEMORY = _DXFILELOADMEMORY;
    PDXFILELOADMEMORY = ^TDXFILELOADMEMORY;

    LPDXFILELOADMEMORY = ^TDXFILELOADMEMORY;


    (*
 * DirectX File interfaces.
 *)


    IDirectXFile = interface(IUnknown)
        ['{3D82AB40-62DA-11CF-AB39-0020AF71E433}']
        function CreateEnumObject({in} pvSource: LPVOID; {in} dwLoadOptions: TDXFILELOADOPTIONS; {out} out ppEnumObj: IDirectXFileEnumObject): HRESULT; stdcall;
        function CreateSaveObject({in} szFileName: LPCSTR; {in} dwFileFormat: TDXFILEFORMAT; {out} out ppSaveObj: IDirectXFileSaveObject): HRESULT; stdcall;
        function RegisterTemplates({in} pvData: LPVOID; {in} cbSize: DWORD): HRESULT; stdcall;
    end;



    IDirectXFileEnumObject = interface(IUnknown)
        ['{3D82AB41-62DA-11CF-AB39-0020AF71E433}']
        function GetNextDataObject(
        {out} out ppDataObj: IDirectXFileData): HRESULT; stdcall;
        function GetDataObjectById(
        {in} rguid: REFGUID;
        {out} out ppDataObj: IDirectXFileData): HRESULT; stdcall;
        function GetDataObjectByName(
        {in} szName: LPCSTR;
        {out} out ppDataObj: IDirectXFileData): HRESULT; stdcall;
    end;



    IDirectXFileSaveObject = interface(IUnknown)
        ['{3D82AB42-62DA-11CF-AB39-0020AF71E433}']
        function SaveTemplates({in} cTemplates: DWORD; {in array} ppguidTemplates: PGUID): HRESULT; stdcall;
        function CreateDataObject({in} rguidTemplate: REFGUID; {in} szName: LPCSTR; {in} pguid: PGUID;
        {in} cbSize: DWORD; {in} pvData: LPVOID; {out} out ppDataObj: IDIRECTXFILEDATA): HRESULT; stdcall;
        function SaveData({in} pDataObj: IDirectXFileData): HRESULT; stdcall;
    end;

    IDirectXFileObject = interface(IUnknown)
        ['{3D82AB43-62DA-11CF-AB39-0020AF71E433}']
        function GetName({out} pstrNameBuf: LPSTR; {in_out} pdwBufLen: LPDWORD): HRESULT; stdcall;
        function GetId({out} pGuid: LPGUID): HRESULT; stdcall;
    end;



    IDirectXFileData = interface(IDirectXFileObject)
        ['{3D82AB44-62DA-11CF-AB39-0020AF71E433}']
        function GetData({in} szMember: LPCSTR; {out} pcbSize: PDWORD; {out} out ppvData): HRESULT; stdcall;
        function GetType({out} out ppguid: PGUID): HRESULT; stdcall;
        function GetNextObject({out} out ppChildObj: IDirectXFileObject): HRESULT; stdcall;
        function AddDataObject({in} pDataObj: IDirectXFileData): HRESULT; stdcall;
        function AddDataReference({in} szRef: LPCSTR; {in} pguidRef: PGUID): HRESULT; stdcall;
        function AddBinaryObject({in} szName: LPCSTR; {in} pguid: PGUID; {in} szMimeType: LPCSTR; {in} pvData: LPVOID;  {in} cbSize: DWORD): HRESULT; stdcall;
    end;



    IDirectXFileDataReference = interface(IDirectXFileObject)
        ['{3D82AB45-62DA-11CF-AB39-0020AF71E433}']
        function Resolve({out} out ppDataObj: IDirectXFileData): HRESULT; stdcall;
    end;



    IDirectXFileBinary = interface(IDirectXFileObject)
        ['{3D82AB46-62DA-11CF-AB39-0020AF71E433}']
        function GetSize({out} pcbSize: PDWORD): HRESULT; stdcall;
        function GetMimeType({out} out pszMimeType: LPCSTR): HRESULT; stdcall;
        function Read({out} pvData: LPVOID;{out} cbSize: DWORD;{out} pcbRead: LPDWORD): HRESULT; stdcall;
    end;




    (*
     * API for creating IDirectXFile interface.
     *)

function DirectXFileCreate(out lplpDirectXFile: IDIRECTXFILE): HResult; stdcall; external D3DXOF_DLL;


implementation

end.
