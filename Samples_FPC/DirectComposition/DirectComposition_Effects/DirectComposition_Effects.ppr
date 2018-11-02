program DirectComposition_Effects;

{$mode delphi}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
    cthreads, {$ENDIF} {$ENDIF}
    Interfaces, // this includes the adLCL widgetset
    Windows,
    ActiveX,
    App, DX12.D3D11;

{$R *.res}



begin
    // Ignore the return value because we want to run the program even in the
    // unlikely event that HeapSetInformation fails.
    //  HeapSetInformation(nil, HeapEnableTerminationOnCorruption, nil, 0);
    if (SUCCEEDED(CoInitialize(nil))) then
    begin
        DCompApp := TApplication.Create;
        DCompApp.Run;
        DCompApp.Free;
        CoUninitialize();
    end;
end.

