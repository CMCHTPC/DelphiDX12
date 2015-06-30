program TextAnimationSample;

{
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (c) Microsoft Corporation. All rights reserved
}


{
  Based on the TextAnimationSample in the Windows 7.1  SDK
  Microsoft SDKs\Windows\v7.1\Samples\multimedia\Direct2D\TextAnimationSample

  Translated to Pascal by
  Sonnleitner Norbert
  (c) 2015

  fpc is working, Delphi is not tested

}


{$mode delphi}{$H+}


uses
    Interfaces, // this includes the LCL widgetset
    Windows,
    ActiveX,
    Classes,
    TextAnimation,
    RingBuffer;

{$R *.res}

var
    App: TDemoApp;

begin
    if CoInitialize(nil) = S_OK then
    begin
        App := TDemoApp.Create;
        if App.Initialize = S_OK then
        begin
            App.RunMessageLoop;
        end;
        App.Free;
        CoUninitialize();
    end;
end.
