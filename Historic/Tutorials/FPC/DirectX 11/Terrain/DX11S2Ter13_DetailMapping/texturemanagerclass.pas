unit TextureManagerClass;

interface

uses
    Classes, SysUtils, Windows,
    DX12.D3D11,
    TextureClass;

type

    { TTextureManagerClass }

    TTextureManagerClass = class(TObject)
    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(Count: integer): HResult;
        procedure Shutdown();

        function LoadTexture(device: ID3D11Device; deviceContext: ID3D11DeviceContext; filename: WideString; location: integer): HResult;

        function GetTexture(id: integer): ID3D11ShaderResourceView;

    private
        m_TextureArray: array of TTextureClass;
        m_textureCount: integer;
    end;

implementation



constructor TTextureManagerClass.Create;
begin

end;



destructor TTextureManagerClass.Destroy;
begin
    inherited Destroy;
end;



function TTextureManagerClass.Initialize(Count: integer): HResult;
var
    i: integer;
begin
    m_textureCount := Count;

    // Create the color texture object.
    SetLength(m_TextureArray, m_textureCount);
    for i := 0 to m_textureCount - 1 do
    begin
        m_TextureArray[i] := TTextureClass.Create;
    end;
    Result := S_OK;
end;



procedure TTextureManagerClass.Shutdown();
var
    i: integer;
begin
    // Release the texture objects.

    for i := 0 to m_textureCount - 1 do
    begin
        m_TextureArray[i].Shutdown();
        m_TextureArray[i].Free;
        m_TextureArray[i] := nil;
    end;
    SetLength(m_TextureArray, 0);
end;



function TTextureManagerClass.LoadTexture(device: ID3D11Device; deviceContext: ID3D11DeviceContext; filename: WideString;
    location: integer): HResult;
begin
    // Initialize the color texture object.
    Result := m_TextureArray[location].Initialize(device, deviceContext, filename);
end;



function TTextureManagerClass.GetTexture(id: integer): ID3D11ShaderResourceView;
begin
    Result := m_TextureArray[id].GetTexture();
end;

end.
