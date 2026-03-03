program WICAnimatedGIF;

{$mode delphi}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
    cthreads, {$ENDIF} {$ENDIF}
    Interfaces, // this includes the LCL widgetset
    Windows,
    AppUnit,
    ActiveX;

{$R *.res}

var
    app: TDemoApp;
    hr: HResult;
    msg: TMSG;

begin
    hr := CoInitializeEx(nil, COINIT_APARTMENTTHREADED or COINIT_DISABLE_OLE1DDE);
    if (SUCCEEDED(hr)) then
    begin
        app := TDemoApp.Create;
        hr := app.Initialize(hInstance);
        if (SUCCEEDED(hr)) then
        begin
            // Main message loop:

            while (GetMessage(msg, 0, 0, 0)) do
            begin
                TranslateMessage(&msg);
                DispatchMessage(&msg);
            end;

        end;
    end;
    app.Free;
    CoUninitialize();
end.

