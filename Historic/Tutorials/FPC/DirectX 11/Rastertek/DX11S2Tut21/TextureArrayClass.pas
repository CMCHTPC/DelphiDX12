unit TextureArrayClass;

{$mode DelphiUnicode}{$H+}

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

    { TTextureArrayClass }

    TTextureArrayClass = class(TObject)
    private
        m_textureView: array[0..2] of ID3D11ShaderResourceView;
    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(device: ID3D11Device; deviceContext: ID3D11DeviceContext; filename1: WideString; filename2: WideString; filename3: WideString): HResult;
        procedure Shutdown();
        function GetTextureArray(): PID3D11ShaderResourceView;
    end;

implementation

{ TTextureArrayClass }

constructor TTextureArrayClass.Create;
begin

end;



destructor TTextureArrayClass.Destroy;
begin
    inherited Destroy;
end;



function TTextureArrayClass.Initialize(device: ID3D11Device; deviceContext: ID3D11DeviceContext; filename1: WideString;
    filename2: WideString;filename3: WideString): HResult;
begin
     Result := D3DX11CreateShaderResourceViewFromFileW(device, pwidechar(filename1), nil, nil, m_textureView[0], nil);
     if Result<>S_OK then exit;
     Result := D3DX11CreateShaderResourceViewFromFileW(device, pwidechar(filename2), nil, nil, m_textureView[1], nil);
     if Result<>S_OK then exit;
     Result := D3DX11CreateShaderResourceViewFromFileW(device, pwidechar(filename3), nil, nil, m_textureView[2], nil);

end;



procedure TTextureArrayClass.Shutdown();
begin
    // Release the texture view resource.
    m_textureView[1] := nil;
    // Release the texture.
    m_textureView[0] := nil;
end;



function TTextureArrayClass.GetTextureArray(): PID3D11ShaderResourceView;
begin
   result:=@m_textureView[0]
end;

end.
