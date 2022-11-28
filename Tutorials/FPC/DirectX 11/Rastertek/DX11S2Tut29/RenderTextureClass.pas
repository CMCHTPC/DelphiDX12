unit RenderTextureClass;

{$mode DelphiUnicode}{$H+}

interface

uses
    Classes, SysUtils, Windows,
    DX12.D3D11,
    DX12.D3DCommon,
    DX12.DXGI;

type

    { TRenderTextureClass }

    TRenderTextureClass = class(TObject)
    private
        m_renderTargetTexture: ID3D11Texture2D;
        m_renderTargetView: ID3D11RenderTargetView;
        m_shaderResourceView: ID3D11ShaderResourceView;
    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(device: ID3D11Device; textureWidth, textureHeight: integer): HResult;
        procedure Shutdown();

        procedure SetRenderTarget(deviceContext: ID3D11DeviceContext; depthStencilView: ID3D11DepthStencilView);
        procedure ClearRenderTarget(deviceContext: ID3D11DeviceContext; depthStencilView: ID3D11DepthStencilView;
            red, green, blue, alpha: single);
        function GetShaderResourceView(): ID3D11ShaderResourceView;


    end;


implementation

{ TRenderTextureClass }

constructor TRenderTextureClass.Create;
begin

end;



destructor TRenderTextureClass.Destroy;
begin
    inherited Destroy;
end;



function TRenderTextureClass.Initialize(device: ID3D11Device; textureWidth, textureHeight: integer): HResult;
var
    textureDesc: TD3D11_TEXTURE2D_DESC;
    renderTargetViewDesc: TD3D11_RENDER_TARGET_VIEW_DESC;
    shaderResourceViewDesc: TD3D11_SHADER_RESOURCE_VIEW_DESC;
begin

    // Initialize the render target texture description.
    ZeroMemory(@textureDesc, sizeof(textureDesc));

    // Setup the render target texture description.
    textureDesc.Width := textureWidth;
    textureDesc.Height := textureHeight;
    textureDesc.MipLevels := 1;
    textureDesc.ArraySize := 1;
    textureDesc.Format := DXGI_FORMAT_R32G32B32A32_FLOAT;
    textureDesc.SampleDesc.Count := 1;
    textureDesc.Usage := D3D11_USAGE_DEFAULT;
    textureDesc.BindFlags := Ord(D3D11_BIND_RENDER_TARGET) or Ord(D3D11_BIND_SHADER_RESOURCE);
    textureDesc.CPUAccessFlags := 0;
    textureDesc.MiscFlags := 0;

    // Create the render target texture.
    Result := device.CreateTexture2D(textureDesc, nil, m_renderTargetTexture);
    if (FAILED(Result)) then Exit;


    // Setup the description of the render target view.
    renderTargetViewDesc.Format := textureDesc.Format;
    renderTargetViewDesc.ViewDimension := D3D11_RTV_DIMENSION_TEXTURE2D;
    renderTargetViewDesc.Texture2D.MipSlice := 0;

    // Create the render target view.
    Result := device.CreateRenderTargetView(m_renderTargetTexture, @renderTargetViewDesc, m_renderTargetView);
    if (FAILED(Result)) then Exit;

    // Setup the description of the shader resource view.
    shaderResourceViewDesc.Format := textureDesc.Format;
    shaderResourceViewDesc.ViewDimension := D3D11_SRV_DIMENSION_TEXTURE2D;
    shaderResourceViewDesc.Texture2D.MostDetailedMip := 0;
    shaderResourceViewDesc.Texture2D.MipLevels := 1;

    // Create the shader resource view.
    Result := device.CreateShaderResourceView(m_renderTargetTexture, @shaderResourceViewDesc, m_shaderResourceView);

end;



procedure TRenderTextureClass.Shutdown();
begin
    m_shaderResourceView := nil;
    m_renderTargetView := nil;
    m_renderTargetTexture := nil;
end;



procedure TRenderTextureClass.SetRenderTarget(deviceContext: ID3D11DeviceContext; depthStencilView: ID3D11DepthStencilView);
begin
    // Bind the render target view and depth stencil buffer to the output render pipeline.
    deviceContext.OMSetRenderTargets(1, @m_renderTargetView, depthStencilView);
end;



procedure TRenderTextureClass.ClearRenderTarget(deviceContext: ID3D11DeviceContext; depthStencilView: ID3D11DepthStencilView;
    red, green, blue, alpha: single);
var
    color: TFloatArray4;
begin

    // Setup the color to clear the buffer to.
    color[0] := red;
    color[1] := green;
    color[2] := blue;
    color[3] := alpha;

    // Clear the back buffer.
    deviceContext.ClearRenderTargetView(m_renderTargetView, color);

    // Clear the depth buffer.
    deviceContext.ClearDepthStencilView(depthStencilView, ord(D3D11_CLEAR_DEPTH), 1.0, 0);
end;



function TRenderTextureClass.GetShaderResourceView(): ID3D11ShaderResourceView;
begin
    Result := m_shaderResourceView;
end;

end.
