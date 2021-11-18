//*********************************************************

// Copyright (c) Microsoft. All rights reserved.
// This code is licensed under the MIT License (MIT).
// THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
// IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
// PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.

//*********************************************************

program HelloTexture;

{$mode delphi}{$H+}

uses
    Classes,
    SysUtils,
    Windows,
    Win32Application,
    D3D12HelloTexture,
    DX12.D3D12;

{$R *.res}

var
    sample: TD3D12HelloTexture;
begin
    sample := TD3D12HelloTexture.Create(1280, 720, 'D3D12 Hello Texture');
    Win32App := TWin32Application.Create;
    Win32App.Run(sample, GetModuleHandle(nil));
end.
