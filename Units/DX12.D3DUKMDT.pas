unit DX12.D3DUKMDT;

// currently only parts of D3DUKMDT

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils;

const


    // Defines the maximum number of context a particular command buffer can
    // be broadcast to.

    D3DDDI_MAX_BROADCAST_CONTEXT = 64;

type

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Purpose: Video present source unique identification number descriptor type


    TD3DDDI_VIDEO_PRESENT_SOURCE_ID = UINT;

implementation

end.

