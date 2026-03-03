unit LightClass;

{$IFDEF FPC}
{$mode DelphiUnicode}{$H+}
{$ENDIF}

interface

uses
    Classes, SysUtils,
    {$IFDEF UseDirectXMath}
    DirectX.Math
    {$ELSE}
    DX12.D3DX10,
    MathTranslate
    {$ENDIF}
    ;

type

    { TLightClass }

    TLightClass = class(TObject)
    private
        m_diffuseColor: TXMFLOAT4;
        m_direction: TXMFLOAT3;
        m_ambientColor: TXMFLOAT4;
        m_position: TXMFLOAT4;
    public
        constructor Create;
        destructor Destroy; override;

        procedure SetAmbientColor(red, green, blue, alpha: single);
        procedure SetDiffuseColor(red, green, blue, alpha: single);
        procedure SetDirection(x, y, z: single);
        procedure SetPosition(x, y, z: single);
        function GetDiffuseColor(): TXMFLOAT4;
        function GetDirection(): TXMFLOAT3;
        function GetAmbientColor(): TXMFLOAT4;
        function GetPosition():TXMFLOAT4;
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

procedure TLightClass.SetPosition(x, y, z: single);
begin
    m_position := TXMFLOAT4.Create(x, y, z, 1.0);
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

function TLightClass.GetPosition(): TXMFLOAT4;
begin
    result:=m_position;
end;

end.
