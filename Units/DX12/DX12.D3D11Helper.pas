unit DX12.D3D11Helper;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D11;

    {$Z4}

operator =(const L, R: TD3D11_RECT): boolean;
operator <>(const L, R: TD3D11_RECT): boolean;


implementation



operator =(const L, R: TD3D11_RECT): boolean;
begin
    Result := (l.left = r.left) and (l.top = r.top) and (l.right = r.right) and (l.bottom = r.bottom);
end;



operator <>(const L, R: TD3D11_RECT): boolean;
begin
    Result := not (l = r);
end;


end.
