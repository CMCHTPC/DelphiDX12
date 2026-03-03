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

   Copyright (c) Microsoft Corporation.  All rights reserved.
   This ALWAYS GENERATED file contains the definitions for the interfaces

   This unit consists of the following header files
   File name: documenttarget.h

   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.DocumentTarget;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    Win32.ObjIdl;

    {$Z4}

const
    ID_DOCUMENTPACKAGETARGET_MSXPS: TGUID = '{9CAE40A8-DED1-41C9-A9FD-D735EF33AEDA}';
    ID_DOCUMENTPACKAGETARGET_OPENXPS: TGUID = '{0056BB72-8C9C-4612-BD0F-93012A87099D}';
    ID_DOCUMENTPACKAGETARGET_OPENXPS_WITH_3D: TGUID = '{63DBD720-8B14-4577-B074-7BB11B596D28}';

    IID_IPrintDocumentPackageTarget: TGUID = '{1b8efec4-3019-4c27-964e-367202156906}';
    IID_IPrintDocumentPackageTarget2: TGUID = '{c560298a-535c-48f9-866a-632540660cb4}';

    IID_IPrintDocumentPackageStatusEvent: TGUID = '{ed90c8ad-5c34-4d05-a1ec-0e8a9b3ad7af}';
    IID_IPrintDocumentPackageTargetFactory: TGUID = '{d2959bf7-b31b-4a3d-9600-712eb1335ba4}';

    UUID_PrintDocumentPackageTarget: TGUID = '{4842669e-9947-46ea-8ba2-d8cce432c2ca}';
    UUID_PrintDocumentPackageTargetFactory: TGUID = '{348ef17d-6c81-4982-92b4-ee188a43867a}';

    //  LIBID_PrintDocumentTargetLib
    // CLSID_PrintDocumentPackageTarget
    // CLSID_PrintDocumentPackageTargetFactory

type

    REFGUID = ^TGUID;
    REFIID = ^TGUID;

    (* Forward Declarations *)
    IPrintDocumentPackageTarget = interface;
    IPrintDocumentPackageTarget2 = interface;
    IPrintDocumentPackageStatusEvent = interface;
    IPrintDocumentPackageTargetFactory = interface;

    IPrintDocumentPackageTarget = interface(IUnknown)
        ['{1b8efec4-3019-4c27-964e-367202156906}']
        function GetPackageTargetTypes(
        {__RPC__out } targetCount: PUINT32;
        {__RPC__deref_out_ecount_full_opt(*targetCount) }  out targetTypes: PGUID): HRESULT; stdcall;

        function GetPackageTarget(
        {__RPC__in } guidTargetType: REFGUID;
        {__RPC__in } riid: REFIID;
        {__RPC__deref_out_opt }  out ppvTarget): HRESULT; stdcall;

        function Cancel(): HRESULT; stdcall;

    end;

    IPrintDocumentPackageTarget2 = interface(IUnknown)
        ['{c560298a-535c-48f9-866a-632540660cb4}']
        function GetIsTargetIppPrinter(
        {__RPC__out } isIppPrinter: Pboolean): HRESULT; stdcall;

        function GetTargetIppPrintDevice(
        {__RPC__in } riid: REFIID;
        {__RPC__deref_out_opt }  out ppvTarget): HRESULT; stdcall;

    end;

    TPrintDocumentPackageCompletion = (
        PrintDocumentPackageCompletion_InProgress = 0,
        PrintDocumentPackageCompletion_Completed = (PrintDocumentPackageCompletion_InProgress + 1),
        PrintDocumentPackageCompletion_Canceled = (PrintDocumentPackageCompletion_Completed + 1),
        PrintDocumentPackageCompletion_Failed = (PrintDocumentPackageCompletion_Canceled + 1));

    PPrintDocumentPackageCompletion = ^TPrintDocumentPackageCompletion;


    TPrintDocumentPackageStatus = record
        JobId: uint32;
        CurrentDocument: int32;
        CurrentPage: int32;
        CurrentPageTotal: int32;
        Completion: TPrintDocumentPackageCompletion;
        PackageStatus: HRESULT;
    end;
    PPrintDocumentPackageStatus = ^TPrintDocumentPackageStatus;




    IPrintDocumentPackageStatusEvent = interface(IDispatch)
        ['{ed90c8ad-5c34-4d05-a1ec-0e8a9b3ad7af}']
        function PackageStatusUpdated(
        {__RPC__in } packageStatus: PPrintDocumentPackageStatus): HRESULT; stdcall;

    end;




    IPrintDocumentPackageTargetFactory = interface(IUnknown)
        ['{d2959bf7-b31b-4a3d-9600-712eb1335ba4}']
        function CreateDocumentPackageTargetForPrintJob(
        {__RPC__in_string } printerName: LPCWSTR;
        {__RPC__in_string } jobName: LPCWSTR;
        {__RPC__in_opt } jobOutputStream: IStream;
        {__RPC__in_opt } jobPrintTicketStream: IStream;
        {__RPC__deref_out_opt }  out docPackageTarget: IPrintDocumentPackageTarget): HRESULT; stdcall;

    end;

implementation

end.
