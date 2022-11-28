unit ShaderManagerClass;

interface

{$DEFINE FontShader}

uses
    Classes, SysUtils, Windows,
    DX12.D3D11,
    DirectX.Math,
    ColorShaderClass,
{$IFDEF FontShader}
    FontShaderClass,
{$ENDIF}
    D3DClass;

type

    TShaderManagerClass = class(TObject)
    private
        m_ColorShader: TColorShaderClass;
{$IFDEF FontShader}
        m_FontShader: TFontShaderClass;
{$ENDIF}
    public
        constructor Create;
        destructor Destroy; override;
        function Initialize(device: ID3D11Device; hwnd: hwnd): HResult;
        procedure Shutdown();
        function RenderColorShader(deviceContext: ID3D11DeviceContext; indexCount: int32;
            worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX): HResult;
        function RenderFontShader(deviceContext: ID3D11DeviceContext; indexCount: int32; worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX;
            texture: ID3D11ShaderResourceView; color: TXMFLOAT4): HResult;
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

{$IFDEF FontShader}
    // Create the font shader object.
    m_FontShader := TFontShaderClass.Create;
    // Initialize the font shader object.
    Result := m_FontShader.Initialize(device, hwnd);
{$ENDIF}
end;



procedure TShaderManagerClass.Shutdown();
begin
{$IFDEF FontShader}
    // Release the font shader object.
    if (m_FontShader <> nil) then
    begin
        m_FontShader.Shutdown();
        m_FontShader.Free;
        m_FontShader := nil;
    end;
{$ENDIF}
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
{$IFDEF FontShader}
    Result := m_FontShader.Render(deviceContext, indexCount, worldMatrix, viewMatrix, projectionMatrix, texture, color);
{$ENDIF}
end;

end.
