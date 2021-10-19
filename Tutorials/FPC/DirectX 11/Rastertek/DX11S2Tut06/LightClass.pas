unit LightClass;

{$mode DelphiUnicode}{$H+}

interface

uses
    Classes, SysUtils,
    DirectX.Math;

type

    { TLightClass }

    TLightClass = class(TObject)
    private
        m_diffuseColor: TXMFLOAT4;
        m_direction: TXMFLOAT3;
    public
        constructor Create;
        destructor Destroy; override;

        procedure SetDiffuseColor(red, green, blue, alpha: single);
        procedure SetDirection(x, y, z: single);

        function GetDiffuseColor(): TXMFLOAT4;
        function GetDirection(): TXMFLOAT3;
    end;

implementation

{ TLightClass }

constructor TLightClass.Create;
begin

end;



destructor TLightClass.Destroy;
begin
    inherited Destroy;
end;



procedure TLightClass.SetDiffuseColor(red, green, blue, alpha: single);
begin
    m_diffuseColor := TXMFLOAT4.Create(red, green, blue, alpha);
end;



procedure TLightClass.SetDirection(x, y, z: single);
begin
    m_direction := TXMFLOAT3.Create(x, y, z);
end;



function TLightClass.GetDiffuseColor(): TXMFLOAT4;
begin
    Result := m_diffuseColor;
end;



function TLightClass.GetDirection(): TXMFLOAT3;
begin
    Result := m_direction;
end;

end.
