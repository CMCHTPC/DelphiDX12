unit TextureClass;

{$mode DelphiUnicode}{$H+}

interface

uses
    Classes, SysUtils, Windows,
    DX12.D3D11,
    DX12.D3DCompiler,
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
        m_targaData: array of byte;
        m_texture: ID3D11Texture2D;
        m_textureView: ID3D11ShaderResourceView;
    private
        function LoadTarga(filename: WideString; var Height, Width: integer): HResult;
    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(device: ID3D11Device; deviceContext: ID3D11DeviceContext; filename: WideString): HResult;
        procedure Shutdown();
        function GetTexture(): ID3D11ShaderResourceView;
    end;

implementation

{$DEFINE DDS}
    {$IFDEF DDS}
uses
    DirectXTK.DDSTextureLoader, DirectXTK.DDS;

    {$ENDIF}

{ TTextureClass }

function TTextureClass.LoadTarga(filename: WideString; var Height, Width: integer): HResult;
var
    error, bpp, imageSize, index, i, j, k: integer;
    Count: UINT;
    targaFileHeader: TTargaHeader;
    targaImage: array of byte;
    lFileStream: TFileStream;
    lFileSize: integer;
begin

    // Open the targa file for reading in binary.
    lFileStream := TFileStream.Create(filename, fmOpenRead);
    try
        lFileStream.Seek(0, soFromBeginning);
        // Read in the file header.
        lFileStream.ReadBuffer(targaFileHeader, sizeof(TTargaHeader));

        // Get the important information from the header.
        Height := targaFileHeader.Height;
        Width := targaFileHeader.Width;
        bpp := targaFileHeader.bpp;
        // Check that it is 32 bit and not 24 bit.
        if (bpp <> 32) then
        begin
            lFileStream.Free;
            Result := E_FAIL;
            Exit;
        end;
        // Calculate the size of the 32 bit image data.
        imageSize := Width * Height * 4;
        // Allocate memory for the targa image data.
        SetLength(targaImage, imageSize);

        lFileSize := lFileStream.Size;
        {if (lFileSize<>(imageSize+SizeOf(targaFileHeader))) then
        begin
            lFileStream.Free;
            Result := E_FAIL;
            Exit;
        end;}
        // Read in the targa image data.
        lFileStream.ReadBuffer(targaImage, imageSize);

{    if(count <> imageSize) then
    begin
        lFileStream.Free;
        Result:=E_FAIL;
                Exit;
    end;    }
        // Allocate memory for the targa destination data.
        SetLength(m_targaData, imageSize);

        // Initialize the index into the targa destination data array.
        index := 0;

        // Initialize the index into the targa image data.
        k := (Width * Height * 4) - (Width * 4);

        // Now copy the targa image data into the targa destination array in the correct order since the targa format is stored upside down.
        for j := 0 to Height - 1 do
        begin
            for i := 0 to Width - 1 do
            begin
                m_targaData[index + 0] := targaImage[k + 2];  // Red.
                m_targaData[index + 1] := targaImage[k + 1];  // Green.
                m_targaData[index + 2] := targaImage[k + 0];  // Blue
                m_targaData[index + 3] := targaImage[k + 3];  // Alpha

                // Increment the indexes into the targa data.
                Inc(k, 4);
                Inc(index, 4);
            end;

            // Set the targa image data index back to the preceding row at the beginning of the column since its reading it in upside down.
            k := k - (Width * 8);
        end;

        // Release the targa image data now that it was copied into the destination array.
        SetLength(targaImage, 0);
        Result := S_OK;

    finally
        lFileStream.Free;
    end;

end;



constructor TTextureClass.Create;
begin

end;



destructor TTextureClass.Destroy;
begin
    inherited Destroy;
end;



function TTextureClass.Initialize(device: ID3D11Device; deviceContext: ID3D11DeviceContext; filename: WideString): HResult;
var
    Height, Width: integer;
    textureDesc: TD3D11_TEXTURE2D_DESC;
    rowPitch: UINT;
    srvDesc: TD3D11_SHADER_RESOURCE_VIEW_DESC;
    maxsize: size_t;
    alphaMode: TDDS_ALPHA_MODE;
begin

    {$IFDEF DDS}
    Result := CreateDDSTextureFromFile(device, 'seafloor.dds', ID3D11Resource(m_texture), m_textureView, maxsize, alphaMode);
    {$ELSE}

    // Load the targa image data into memory.
    Result := LoadTarga(filename, Height, Width);
    if (Result <> S_OK) then
        Exit;

    // Setup the description of the texture.
    textureDesc.Height := Height;
    textureDesc.Width := Width;
    textureDesc.MipLevels := 0;
    textureDesc.ArraySize := 1;
    textureDesc.Format := DXGI_FORMAT_R8G8B8A8_UNORM;
    textureDesc.SampleDesc.Count := 1;
    textureDesc.SampleDesc.Quality := 0;
    textureDesc.Usage := D3D11_USAGE_DEFAULT;
    textureDesc.BindFlags := Ord(D3D11_BIND_SHADER_RESOURCE) or Ord(D3D11_BIND_RENDER_TARGET);
    textureDesc.CPUAccessFlags := 0;
    textureDesc.MiscFlags := Ord(D3D11_RESOURCE_MISC_GENERATE_MIPS);

    // Create the empty texture.
    Result := device.CreateTexture2D(textureDesc, nil, m_texture);
    if (FAILED(Result)) then
        Exit;

    // Set the row pitch of the targa image data.
    rowPitch := (Width * 4) * sizeof(byte);

    // Copy the targa image data into the texture.
    deviceContext.UpdateSubresource(m_texture, 0, nil, m_targaData, rowPitch, 0);

    // Setup the shader resource view description.
    srvDesc.Format := textureDesc.Format;
    srvDesc.ViewDimension := D3D11_SRV_DIMENSION_TEXTURE2D;
    srvDesc.Texture2D.MostDetailedMip := 0;
    srvDesc.Texture2D.MipLevels := -1;

    // Create the shader resource view for the texture.
    Result := device.CreateShaderResourceView(m_texture, @srvDesc, m_textureView);
    if (FAILED(Result)) then
        Exit;

    // Generate mipmaps for this texture.
    deviceContext.GenerateMips(m_textureView);

    // Release the targa image data now that the image data has been loaded into the texture.
    Setlength(m_targaData, 0);
    {$ENDIF}
end;



procedure TTextureClass.Shutdown();
begin
    // Release the texture view resource.
    m_textureView := nil;

    // Release the texture.
    m_texture := nil;

    // Release the targa data.
    Setlength(m_targaData, 0);
end;



function TTextureClass.GetTexture(): ID3D11ShaderResourceView;
begin
    Result := m_textureView;
end;

end.
