unit LightClass;

{$IFDEF FPC}
{$mode DelphiUnicode}{$H+}
{$ENDIF}

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
        m_ambientColor: TXMFLOAT4;
        m_specularColor: TXMFLOAT4;
        m_specularPower: single;
    public
        constructor Create;
        destructor Destroy; override;

        procedure SetAmbientColor(red, green, blue, alpha: single);
        procedure SetDiffuseColor(red, green, blue, alpha: single);
        procedure SetDirection(x, y, z: single);
        procedure SetSpecularColor(red, green, blue, alpha: single);
        procedure SetSpecularPower(power: single);

        function GetDiffuseColor(): TXMFLOAT4;
        function GetDirection(): TXMFLOAT3;
        function GetAmbientColor(): TXMFLOAT4;
        function GetSpecularColor(): TXMFLOAT4;
        function GetSpecularPower(): single;
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



procedure TLightClass.SetAmbientColor(red, green, blue, alpha: single);
begin
    m_ambientColor := TXMFLOAT4.Create(red, green, blue, alpha);
end;



procedure TLightClass.SetDiffuseColor(red, green, blue, alpha: single);
begin
    m_diffuseColor := TXMFLOAT4.Create(red, green, blue, alpha);
end;



procedure TLightClass.SetDirection(x, y, z: single);
begin
    m_direction := TXMFLOAT3.Create(x, y, z);
end;



procedure TLightClass.SetSpecularColor(red, green, blue, alpha: single);
begin
    m_specularColor := TXMFLOAT4.Create(red, green, blue, alpha);
end;



procedure TLightClass.SetSpecularPower(power: single);
begin
    m_specularPower := power;
end;



function TLightClass.GetDiffuseColor(): TXMFLOAT4;
begin
    Result := m_diffuseColor;
end;



function TLightClass.GetDirection(): TXMFLOAT3;
begin
    Result := m_direction;
end;



function TLightClass.GetAmbientColor(): TXMFLOAT4;
begin
    Result := m_ambientColor;
end;



function TLightClass.GetSpecularColor(): TXMFLOAT4;
begin
    Result := m_specularColor;
end;



function TLightClass.GetSpecularPower(): single;
begin
    Result := m_specularPower;
end;

end.
