//*********************************************************
//
// Copyright (c) Microsoft. All rights reserved.
// This code is licensed under the MIT License (MIT).
// THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
// IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
// PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
//
//*********************************************************

// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently.

unit stdafx;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils;

const

    SINGLETHREADED = FALSE;

    FrameCount = 3;

    NumContexts = 3;
    NumLights = 3;        // Keep this in sync with "shaders.hlsl".

    TitleThrottle = 200;    // Only update the titlebar every X number of frames.

    // Command list submissions from main thread.
    CommandListCount = 3;
    CommandListPre = 0;
    CommandListMid = 1;
    CommandListPost = 2;

implementation

end.
