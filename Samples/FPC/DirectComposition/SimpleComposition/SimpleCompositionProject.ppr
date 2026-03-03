program SimpleCompositionProject;

{$mode delphi}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
    cthreads, {$ENDIF} {$ENDIF}
    Interfaces, // this includes the adLCL widgetset
    Windows,
    ActiveX,
    SimpleCompositionApp,
    DX12.D3D11;

{$R *.res}
{$R logo.res}



begin
    // Ignore the return value because we want to run the program even in the
    // unlikely event that HeapSetInformation fails.
    //  HeapSetInformation(nil, HeapEnableTerminationOnCorruption, nil, 0);
    if (SUCCEEDED(CoInitialize(nil))) then
    begin
        app := TDemoApp.Create;
        if (SUCCEEDED(app.Initialize())) then
        begin
            app.RunMessageLoop();
        end;
        app.Free;
        CoUninitialize();
    end;
end.

