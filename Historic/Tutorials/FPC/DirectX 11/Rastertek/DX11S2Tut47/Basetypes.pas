unit Basetypes;

{$mode DelphiUnicode}{$H+}

interface

uses
    Classes, SysUtils,
    DX12.D3D11,
    DirectX.Math;

type
    TVertexType = record
        position: TXMFLOAT3;
        texture: TXMFLOAT2;
    end;


implementation

end.
