unit TextureClass;

{$IFDEF FPC}
{$mode DelphiUnicode}{$H+}
{$ENDIF}

interface

uses
    Classes, SysUtils, Windows,
    DX12.D3D11,
    {$IFDEF UseDirectXMath}
    DirectX.Math,
    DX12.D3DCompiler,
    {$ELSE}
    DX12.D3DX10,
    {$ENDIF}
    DX12.D3DX11,
    DX12.D3DCommon,
    DX12.DXGI;

type
    TTargaHeader = packed record
        lPictureID: byte; // 0
        lColorPaletteTyp: byte; // 1
        lPictureTyp: byte; // 2
        lPaletteStart: word; // 2 byte, 3,4
        lPaletteLength: word; // 2 byte 5,6
        lPaletteSize: byte;   // 7
        lXZeroPoint: word; // 2 byte  8,9
        lYZeroPoint: word; // 2 byte 10,11
        Width: word;
        Height: word;
        bpp: byte;
        lPictureAttribut: byte; //  12
    end;

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
    DirectXTK.DDS,
    {$ENDIF}
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
begin
    Result := CreateTGATextureFromFile(device, deviceContext, filename, ID3D11Resource(m_texture), m_textureView);
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
