//*********************************************************

// Copyright (c) Microsoft. All rights reserved.
// This code is licensed under the MIT License (MIT).
// THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
// IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
// PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.

//*********************************************************
unit Win32Application;

{$mode Delphi}

interface

uses
    Classes, SysUtils, Windows,
    DXSample;

type

    TCREATESTRUCTW = record
        lpCreateParams: pointer;
        hInstance: HINST;
        hMenu: HMENU;
        hwndParent: HWND;
        cy: int32;
        cx: int32;
        y: int32;
        x: int32;
        style: LONG;
        lpszName: LPCWSTR;
        lpszClass: LPCWSTR;
        dwExStyle: DWORD;
    end;
    PCREATESTRUCTW = ^TCREATESTRUCTW;

    { TWin32Application }

    TWin32Application = class(TObject)
    private
        m_hwnd: HWND;
    protected
        class function WindowProc(hWnd: HWND; message: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; static;
    public
        function Run(pSample: TDXSample; hInstance: HINST): integer;
        function GetHwnd(): HWND;
    end;

var
    Win32App: TWin32Application;


implementation

{ TWin32Application }

// Main message handler for the sample.
class function TWin32Application.WindowProc(hWnd: HWND; message: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
    pSample: TDXSample;
    pCreateStruct: PCREATESTRUCTW;
begin
    pSample := TDXSample(GetWindowLongPtr(hWnd, GWLP_USERDATA));
    case message of
        WM_CREATE:
        begin
            // Save the DXSample* passed in to CreateWindow.
            pCreateStruct := PCREATESTRUCTW(lParam);
            SetWindowLongPtr(hWnd, GWLP_USERDATA, LONG_PTR(pCreateStruct.lpCreateParams));
            Result := 0;
        end;
        WM_KEYDOWN:
        begin
            if pSample <> nil then
                pSample.OnKeyDown(wParam);
            Result := 0;
        end;
        WM_KEYUP:
        begin
            if pSample <> nil then
                pSample.OnKeyUp(wParam);
            Result := 0;
        end;
        WM_PAINT:
        begin
            if pSample <> nil then
            begin
                pSample.OnUpdate();
                pSample.OnRender();
            end;
            Result := 0;
        end;
        WM_DESTROY:
        begin
            PostQuitMessage(0);
            Result := 0;
        end;
        else
            // Handle any messages the switch statement didn't.
            Result := DefWindowProcW(hWnd, message, wParam, lParam);
    end;
end;



function TWin32Application.Run(pSample: TDXSample; hInstance: HINST): integer;
var
    windowClass: WNDCLASSEXW;
    windowRect: TRect;
    msg: TMsg;
begin
    // Parse the command line parameters

    // Initialize the window class.
    ZeroMemory(@windowClass, SizeOf(windowClass));
    windowClass.cbSize := sizeof(WNDCLASSEXW);
    windowClass.style := CS_HREDRAW or CS_VREDRAW;
    windowClass.lpfnWndProc := WindowProc;
    windowClass.hInstance := hInstance;
    windowClass.hCursor := LoadCursor(0, IDC_ARROW);
    windowClass.lpszClassName := 'DXSampleClass';
    RegisterClassExW(windowClass);

    windowRect := TRect.Create(0, 0, pSample.GetWidth(), pSample.GetHeight());
    AdjustWindowRect(@windowRect, WS_OVERLAPPEDWINDOW, False);

    // Create the window and store a handle to it.

    m_hwnd := CreateWindowW(windowClass.lpszClassName, pwidechar(pSample.GetTitle()), WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT, windowRect.right - windowRect.left, windowRect.bottom - windowRect.top, 0,        // We have no parent window.
        0,        // We aren't using menus.
        hInstance, pSample);

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
            DispatchMessage(msg);
        end;
    end;

    pSample.OnDestroy();

    // Return this part of the WM_QUIT message to Windows.
    Result := (msg.wParam);

end;



function TWin32Application.GetHwnd: HWND;
begin
    Result := m_hwnd;
end;

end.
