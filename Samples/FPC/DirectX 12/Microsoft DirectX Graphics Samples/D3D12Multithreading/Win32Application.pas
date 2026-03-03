//*********************************************************

// Copyright (c) Microsoft. All rights reserved.
// This code is licensed under the MIT License (MIT).
// THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
// IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
// PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.

//*********************************************************
unit Win32Application;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DXSample;

type

    { TWin32Application }

    TWin32Application = class(TObject)
    protected
        m_hwnd: HWND;
    public
        constructor Create;
        destructor Destroy; override;
        function Run(pSample: TDXSample; hInstance: HINST; nCmdShow: int32): int32;
        class function WindowProc(hWnd: HWND; message: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; static;
        function GetHwnd(): HWND;

    end;

var
    gWin32Application: TWin32Application;

implementation

{ TWin32Application }

constructor TWin32Application.Create;
begin
    m_hwnd := 0;
end;



destructor TWin32Application.Destroy;
begin
    inherited Destroy;
end;



function TWin32Application.Run(pSample: TDXSample; hInstance: HINST; nCmdShow: int32): int32;
var
    argc: integer;
    argv: LPWSTR;
    windowClass: TWNDCLASSEXW;
    windowRect: TRECT;
    msg: TMSG;
    er: dword;
begin
    // Parse the command line parameters

    // argv := CommandLineToArgv(GetCommandLineW(), &argc);
    // pSample.ParseCommandLineArgs(argv, argc);
    // LocalFree(argv);

    // Initialize the window class.
    ZeroMemory(@windowClass, SizeOf(windowClass));
    windowClass.cbSize := sizeof(TWNDCLASSEXW);
    windowClass.style := CS_HREDRAW or CS_VREDRAW;
    windowClass.lpfnWndProc := @WindowProc;
    windowClass.hInstance := hInstance;
    windowClass.hCursor := LoadCursor(0, IDC_ARROW);
    windowClass.lpszClassName := 'DXSampleClass';
    er:=RegisterClassExW(windowClass);

    windowRect.Create(0, 0, LONG(pSample.GetWidth()), LONG(pSample.GetHeight()));
    AdjustWindowRect(windowRect, WS_OVERLAPPEDWINDOW, False);

    // Create the window and store a handle to it.
    m_hwnd := CreateWindowW(windowClass.lpszClassName, pwidechar(pSample.GetTitle()), WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, windowRect.right -
        windowRect.left, windowRect.bottom - windowRect.top, 0,        // We have no parent window.
        0,        // We aren't using menus.
        hInstance, pSample);

    if m_hwnd = 0 then
       OutputDebugStringA(Pansichar(IntToStr(GetLastOSError)));
    ;
    // Initialize the sample. OnInit is defined in each child-implementation of DXSample.
    pSample.OnInit();

    ShowWindow(m_hwnd, SW_SHOW);

    // Main sample loop.
    while (msg.message <> WM_QUIT) do
    begin
        // Process any messages in the queue.
        if (PeekMessage(msg, 0, 0, 0, PM_REMOVE)) then
        begin
            TranslateMessage(msg);
            DispatchMessageW(msg);
        end;
    end;

    pSample.OnDestroy();

    // Return this part of the WM_QUIT message to Windows.
    Result := byte(msg.wParam);
end;


// Main message handler for the sample.
class function TWin32Application.WindowProc(hWnd: HWND; message: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; static;
var
    pSample: TDXSample;
    pCreateStruct: LPCREATESTRUCT;
begin
    pSample := TDXSample(GetWindowLongPtr(hWnd, GWLP_USERDATA));
    case (message) of

        WM_CREATE:
        begin

            // Save the DXSample* passed in to CreateWindow.
            pCreateStruct := LPCREATESTRUCT(lParam);
            SetWindowLongPtr(hWnd, GWLP_USERDATA, LONG_PTR(pCreateStruct^.lpCreateParams));

            Result := 0;
            Exit;
        end;

        WM_KEYDOWN:
        begin
            if (pSample <> nil) then
            begin
                pSample.OnKeyDown(uint8(wParam));
            end;
            Result := 0;
            Exit;
        end;

        WM_KEYUP:
        begin
            if (pSample <> nil) then
            begin
                pSample.OnKeyUp(uint8(wParam));
            end;
            Result := 0;
            Exit;
        end;

        WM_PAINT:
        begin
            if (pSample <> nil) then
            begin
                pSample.OnUpdate();
                pSample.OnRender();
            end;
            Result := 0;
            Exit;
        end;

        WM_DESTROY:
        begin
            PostQuitMessage(0);
            Result := 0;
            Exit;
        end;
    end;

    // Handle any messages the switch statement didn't.
    Result := DefWindowProcW(hWnd, message, wParam, lParam);

end;



function TWin32Application.GetHwnd(): HWND;
begin
    Result := m_hwnd;

end;

end.
