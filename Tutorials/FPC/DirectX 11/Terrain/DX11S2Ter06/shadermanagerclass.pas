unit ShaderManagerClass;

interface


uses
    Classes, SysUtils, Windows,
    DX12.D3D11,
    DirectX.Math,
    ColorShaderClass,
    textureshaderclass,
    lightshaderclass,
    terrainshaderclass,
    FontShaderClass,
    D3DClass;

type

    TShaderManagerClass = class(TObject)
    private
        m_ColorShader: TColorShaderClass;
        m_TextureShader: TTextureShaderClass;
        m_LightShader: TLightShaderClass;
        m_FontShader: TFontShaderClass;
        m_TerrainShader: TTerrainShaderClass;
    public
        constructor Create;
        destructor Destroy; override;
        function Initialize(device: ID3D11Device; hwnd: hwnd): HResult;
        procedure Shutdown();
        function RenderColorShader(deviceContext: ID3D11DeviceContext; indexCount: int32;
            worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX): HResult;
        function RenderFontShader(deviceContext: ID3D11DeviceContext; indexCount: int32; worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX;
            texture: ID3D11ShaderResourceView; color: TXMFLOAT4): HResult;
        function RenderTextureShader(deviceContext: ID3D11DeviceContext; indexCount: integer;
            worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX; texture: ID3D11ShaderResourceView): HResult;
        function RenderLightShader(deviceContext: ID3D11DeviceContext; indexCount: integer;
            worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX; texture: ID3D11ShaderResourceView; lightDirection: TXMFLOAT3;
            diffuseColor: TXMFLOAT4): HResult;
        function RenderTerrainShader(deviceContext: ID3D11DeviceContext; indexCount: integer;
            worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX;
            texture: ID3D11ShaderResourceView;
            normalMap:ID3D11ShaderResourceView;
            lightDirection: TXMFLOAT3;
            diffuseColor: TXMFLOAT4): HResult;
    end;

implementation



constructor TShaderManagerClass.Create;
begin
end;



destructor TShaderManagerClass.Destroy;
begin
    inherited;
end;



function TShaderManagerClass.Initialize(device: ID3D11Device; hwnd: hwnd): HResult;
begin
    // Create the color shader object.
    m_ColorShader := TColorShaderClass.Create;

    // Initialize the color shader object.
    Result := m_ColorShader.Initialize(device, hwnd);
    if (Result <> S_OK) then
        Exit;

    // Create the texture shader object.
    m_TextureShader := TTextureShaderClass.Create;
    if (Result <> S_OK) then
        Exit;

    // Create the light shader object.
    m_LightShader := TLightShaderClass.Create;
    // Initialize the light shader object.
    Result := m_LightShader.Initialize(device, hwnd);
    if (Result <> S_OK) then
        Exit;


    // Initialize the texture shader object.
    Result := m_TextureShader.Initialize(device, hwnd);
    if (Result <> S_OK) then
        Exit;

    // Create the font shader object.
    m_FontShader := TFontShaderClass.Create;
    // Initialize the font shader object.
    Result := m_FontShader.Initialize(device, hwnd);
    if (Result <> S_OK) then
        Exit;

    // Create the terrain shader object.
    m_TerrainShader := TTerrainShaderClass.Create;
    // Initialize the terrain shader object.
    Result := m_TerrainShader.Initialize(device, hwnd);

end;



procedure TShaderManagerClass.Shutdown();
begin
    // Release the terrain shader object.
    if (m_TerrainShader <> nil) then
    begin
        m_TerrainShader.Shutdown();
        m_TerrainShader.Free;
        m_TerrainShader := nil;
    end;



    // Release the font shader object.
    if (m_FontShader <> nil) then
    begin
        m_FontShader.Shutdown();
        m_FontShader.Free;
        m_FontShader := nil;
    end;

    // Release the texture shader object.
    if (m_TextureShader <> nil) then
    begin
        m_TextureShader.Shutdown();
        m_TextureShader.Free;
        m_TextureShader := nil;
    end;

    // Release the light shader object.
    if (m_LightShader <> nil) then
    begin
        m_LightShader.Shutdown();
        m_LightShader.Free;
        m_LightShader := nil;
    end;



    // Release the color shader object.
    if (m_ColorShader <> nil) then
    begin
        m_ColorShader.Shutdown();
        m_ColorShader.Free;
        m_ColorShader := nil;
    end;
end;



function TShaderManagerClass.RenderColorShader(deviceContext: ID3D11DeviceContext; indexCount: int32;
    worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX): HResult;
begin
    Result := m_ColorShader.Render(deviceContext, indexCount, worldMatrix, viewMatrix, projectionMatrix);
end;



function TShaderManagerClass.RenderFontShader(deviceContext: ID3D11DeviceContext; indexCount: int32;
    worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX; texture: ID3D11ShaderResourceView; color: TXMFLOAT4): HResult;
begin
    Result := m_FontShader.Render(deviceContext, indexCount, worldMatrix, viewMatrix, projectionMatrix, texture, color);
end;



function TShaderManagerClass.RenderTextureShader(deviceContext: ID3D11DeviceContext; indexCount: integer;
    worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX; texture: ID3D11ShaderResourceView): HResult;
begin
    Result := m_TextureShader.Render(deviceContext, indexCount, worldMatrix, viewMatrix, projectionMatrix, texture);
end;



function TShaderManagerClass.RenderLightShader(deviceContext: ID3D11DeviceContext; indexCount: integer;
    worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX; texture: ID3D11ShaderResourceView; lightDirection: TXMFLOAT3;
    diffuseColor: TXMFLOAT4): HResult;
begin
    Result := m_LightShader.Render(deviceContext, indexCount, worldMatrix, viewMatrix, projectionMatrix, texture, lightDirection, diffuseColor);
end;



function TShaderManagerClass.RenderTerrainShader(deviceContext: ID3D11DeviceContext; indexCount: integer;
    worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX; texture: ID3D11ShaderResourceView; normalMap:ID3D11ShaderResourceView; lightDirection: TXMFLOAT3;
    diffuseColor: TXMFLOAT4): HResult;
begin
    Result := m_TerrainShader.Render(deviceContext, indexCount, worldMatrix, viewMatrix, projectionMatrix, texture,normalMap, lightDirection, diffuseColor);
end;


end.
