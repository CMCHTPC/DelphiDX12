unit DX12.D3D9Types;

(*==========================================================================;
 *
 *  Copyright (C) Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       d3d9types.h
 *  Content:    Direct3D capabilities include file
 *
 ***************************************************************************)


{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils;

const
    DIRECT3D_VERSION = $0900;


type
    TD3DMATRIX = record
        case integer of

            0: (
                _11, _12, _13, _14: single;
                _21, _22, _23, _24: single;
                _31, _32, _33, _34: single;
                _41, _42, _43, _44: single;

            );
            1: (m: array[0..3, 0..3] of single);
    end;

implementation

end.

