unit Win32.ProfileAPI;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils;

(********************************************************************************
*                                                                               *
* profileapi.h -- ApiSet Contract for api-ms-win-core-profile-l1                *
*                                                                               *
* Copyright (c) Microsoft Corporation. All rights reserved.                     *
*                                                                               *
********************************************************************************)

    // Performance counter API's



function QueryPerformanceCounter(
    {_Out_ } lpPerformanceCount: PLARGE_INTEGER): winbool; stdcall; external 'Kernel32.dll';




function QueryPerformanceFrequency(
    {_Out_ } lpFrequency: PLARGE_INTEGER): winbool; stdcall; external 'Kernel32.dll';




implementation

end.
