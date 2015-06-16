unit DX12.DocumentTarget;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

{$Z4}

uses
    Windows, Classes, SysUtils,ActiveX;

const
    IID_IPrintDocumentPackageTarget: TGUID = '{1b8efec4-3019-4c27-964e-367202156906}';
    IID_IPrintDocumentPackageStatusEvent: TGUID = '{ed90c8ad-5c34-4d05-a1ec-0e8a9b3ad7af}';
    IID_IPrintDocumentPackageTargetFactory: TGUID = '{d2959bf7-b31b-4a3d-9600-712eb1335ba4}';

    ID_DOCUMENTPACKAGETARGET_MSXPS: TGUID = '{9cae40a8-ded1-41c9-a9fd-d735ef33aeda}';
    ID_DOCUMENTPACKAGETARGET_OPENXPS: TGUID = '{0056bb72-8c9c-4612-bd0f-93012a87099d}';
    ID_DOCUMENTPACKAGETARGET_OPENXPS_WITH_3D: TGUID = '{63dbd720-8b14-4577-b074-7bb11b596d28}';

type

    IPrintDocumentPackageTarget = interface(IUnknown)
        ['{1b8efec4-3019-4c27-964e-367202156906}']
        function GetPackageTargetTypes(out targetCount: UINT32; out targetTypes: PGUID): HResult; stdcall;
        function GetPackageTarget(guidTargetType: TGUID; riid: TGUID; out ppvTarget: Pointer): HResult; stdcall;
        function Cancel(): HResult; stdcall;
    end;


    TPrintDocumentPackageCompletion = (
        PrintDocumentPackageCompletion_InProgress = 0,
        PrintDocumentPackageCompletion_Completed = (PrintDocumentPackageCompletion_InProgress + 1),
        PrintDocumentPackageCompletion_Canceled = (PrintDocumentPackageCompletion_Completed + 1),
        PrintDocumentPackageCompletion_Failed = (PrintDocumentPackageCompletion_Canceled + 1)
        );

    TPrintDocumentPackageStatus = record
        JobId: UINT32;
        CurrentDocument: INT32;
        CurrentPage: INT32;
        CurrentPageTotal: INT32;
        Completion: TPrintDocumentPackageCompletion;
        PackageStatus: HRESULT;
    end;

    PPrintDocumentPackageStatus = ^TPrintDocumentPackageStatus;


    IPrintDocumentPackageStatusEvent = interface(IDispatch)
        ['{ed90c8ad-5c34-4d05-a1ec-0e8a9b3ad7af}']
        function PackageStatusUpdated(packageStatus: PPrintDocumentPackageStatus): HResult; stdcall;
    end;


    IPrintDocumentPackageTargetFactory = interface(IUnknown)
        ['{d2959bf7-b31b-4a3d-9600-712eb1335ba4}']
        function CreateDocumentPackageTargetForPrintJob(printerName: PWideChar; jobName: PWideChar;
            jobOutputStream: IStream; jobPrintTicketStream: IStream; out docPackageTarget: IPrintDocumentPackageTarget): HResult; stdcall;
    end;


implementation

end.























