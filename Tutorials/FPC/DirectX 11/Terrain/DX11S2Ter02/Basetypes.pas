unit Basetypes;

{$IFDEF FPC}
{$mode DelphiUnicode}{$H+}
{$ENDIF}

interface

uses
    Classes, SysUtils,
    DX12.D3D11,
    DirectX.Math;

type
    TVertexType = packed record
        position: TXMFLOAT3;
        texture: TXMFLOAT2;
    end;


implementation

end.
