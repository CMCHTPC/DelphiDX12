unit TextureClass;

{$IFDEF FPC}
{$mode DelphiUnicode}{$H+}
{$ENDIF}

interface

uses
    Classes, SysUtils, Windows,
    DX12.D3D11,
    DX12.D3DX10,
    DX12.D3DX11,
    {$IFDEF UseDirectXMath}
    DirectX.Math,
    DX12.D3DCompiler,

    {$ELSE}

    {$ENDIF}
    DX12.D3DCommon,
    DX12.DXGI;

type
    { TTextureClass }

    TTextureClass = class(TObject)
    private
        m_texture: ID3D11Texture2D;
        m_textureView: ID3D11ShaderResourceView;
    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(device: ID3D11Device; deviceContext: ID3D11DeviceContext; filename: WideString): HResult;
        procedure Shutdown();
        function GetTexture(): ID3D11ShaderResourceView;
    end;

implementation


uses
    //    {$DEFINE DDS}
    {$IFDEF DDS}
    DirectXTK.DDSTextureLoader,
    {$ENDIF}
    DirectXTK.DDS,
    DirectXTK.Targa;

{ TTextureClass }

constructor TTextureClass.Create;
begin

end;



destructor TTextureClass.Destroy;
begin
    inherited Destroy;
end;



function TTextureClass.Initialize(device: ID3D11Device; deviceContext: ID3D11DeviceContext; filename: WideString): HResult;
var
    lExt: WideString;
begin
    lExt := ExtractFileExt(filename);
    if lExt = '.tga' then
        Result := CreateTGATextureFromFile(device, deviceContext, filename, ID3D11Resource(m_texture), m_textureView)
    else
        Result := D3DX11CreateShaderResourceViewFromFileW(device, pwidechar(filename), nil, nil, m_textureView, nil);

end;



procedure TTextureClass.Shutdown();
begin
    // Release the texture view resource.
    m_textureView := nil;

    // Release the texture.
    m_texture := nil;
end;



function TTextureClass.GetTexture(): ID3D11ShaderResourceView;
begin
    Result := m_textureView;
end;

end.
