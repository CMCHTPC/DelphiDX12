unit DirectXTK11.Targa;

{$IFDEF FPC}
{$mode DelphiUnicode}{$H+}
{$ENDIF}

interface

uses
    Classes, SysUtils, Windows,
    DX12.D3D11;

type
    TTargaHeader = packed record
        PictureID: byte;
        ColorPaletteTyp: byte;
        PictureType: byte;
        PaletteStart: word;
        PaletteLength: word;
        PaletteSize: byte;
        XCoordinate: word;
        YCoordinate: word;
        Width: word;
        Height: word;
        bpp: byte;
        PictureAttribute: byte;
    end;


function CreateTGATextureFromFile(d3dDevice: ID3D11Device; d3dContext: ID3D11DeviceContext; const szFileName: WideString; out texture: ID3D11Resource; out textureView: ID3D11ShaderResourceView): HResult;

implementation

uses
    DX12.DXGI, DX12.D3DCommon;



function CreateTGATextureFromFile(d3dDevice: ID3D11Device; d3dContext: ID3D11DeviceContext; const szFileName: WideString; out texture: ID3D11Resource; out textureView: ID3D11ShaderResourceView): HResult;
var
    lFileStream: TFileStream;
    lCount: integer;
    lTargaHeader: TTargaHeader;
    lHeight: integer;
    lWidth: integer;
    lBPP: integer;
    lImageSize: integer;
    lTargaImage: pbyte;
    lTargaData: array of byte;
    lIndex: integer;
    k: integer;
    i: integer;
    j: integer;
    lRowPitch: integer;

    lTextureDesc: TD3D11_TEXTURE2D_DESC;
    lSRVDesc: TD3D11_SHADER_RESOURCE_VIEW_DESC;
begin
    Result := E_FAIL;
    // Load the targa image data into memory.
    // Open the targa file for reading in binary.
    if not FileExists(szFileName) then Exit;
    lFileStream := TFileStream.Create(szFileName, fmOpenRead);
    try
        // Read in the file header.
        lCount := lFileStream.Read(lTargaHeader, SizeOf(TTargaHeader));
        if lCount = SizeOf(TTargaHeader) then
        begin
            // Get the important information from the header.
            lHeight := lTargaHeader.Height;
            lWidth := lTargaHeader.Width;
            lBPP := lTargaHeader.bpp;
            // Check that it is 32 bit and not 24 bit.
            if (lBPP = 32) then
            begin
                // Calculate the size of the 32 bit image data.
                lImageSize := lWidth * lHeight * 4;

                // Allocate memory for the targa image data.
                lTargaImage := GetMem(lImageSize);
                // Read in the targa image data.
                lCount := lFileStream.Read(lTargaImage^, lImageSize);
                if (lCount = lImageSize) then
                    Result := S_OK
                else
                begin
                    // free the allocated memory
                    Dispose(lTargaImage);
                    lTargaImage := nil;
                end;
            end;
        end
    finally
        // Close the file.
        lFileStream.Free;
    end;
    if Result = S_OK then
    begin
        // Allocate memory for the targa destination data.
        SetLength(lTargaData, lImageSize);
        // Initialize the index into the targa destination data array.
        lIndex := 0;

        // Initialize the index into the targa image data.
        k := (lWidth * lHeight * 4) - (lWidth * 4);

        // Now copy the targa image data into the targa destination array in the correct order since the targa format is stored upside down.
        for j := 0 to lHeight - 1 do
        begin
            for i := 0 to lWidth - 1 do
            begin
                lTargaData[lIndex + 0] := lTargaImage[k + 2];  // Red.
                lTargaData[lIndex + 1] := lTargaImage[k + 1];  // Green.
                lTargaData[lIndex + 2] := lTargaImage[k + 0];  // Blue
                lTargaData[lIndex + 3] := lTargaImage[k + 3];  // Alpha

                // Increment the indexes into the targa data.
                k := k + 4;
                lIndex := lIndex + 4;
            end;

            // Set the targa image data index back to the preceding row at the beginning of the column since its reading it in upside down.
            k := k - (lWidth * 8);
        end;

        // Release the targa image data now that it was copied into the destination array.
        if lTargaImage <> nil then
            Dispose(lTargaImage);

        // Setup the description of the texture.
        lTextureDesc.Height := lHeight;
        lTextureDesc.Width := lWidth;
        lTextureDesc.MipLevels := 0;
        lTextureDesc.ArraySize := 1;
        lTextureDesc.Format := DXGI_FORMAT_R8G8B8A8_UNORM;
        lTextureDesc.SampleDesc.Count := 1;
        lTextureDesc.SampleDesc.Quality := 0;
        lTextureDesc.Usage := D3D11_USAGE_DEFAULT;
        lTextureDesc.BindFlags := Ord(D3D11_BIND_SHADER_RESOURCE) or Ord(D3D11_BIND_RENDER_TARGET);
        lTextureDesc.CPUAccessFlags := 0;
        lTextureDesc.MiscFlags := Ord(D3D11_RESOURCE_MISC_GENERATE_MIPS);


        // Create the empty texture.
        Result := d3dDevice.CreateTexture2D(lTextureDesc, nil, ID3D11Texture2D(texture));
        if Result = S_OK then
        begin
            // Set the row pitch of the targa image data.
            lRowPitch := (lWidth * 4) * sizeof(byte);

            // Copy the targa image data into the texture.
            d3dContext.UpdateSubresource(texture, 0, nil, lTargaData, lRowPitch, 0);

            // Setup the shader resource view description.
            lSRVDesc.Format := lTextureDesc.Format;
            lSRVDesc.ViewDimension := D3D11_SRV_DIMENSION_TEXTURE2D;
            lSRVDesc.Texture2D.MostDetailedMip := 0;
            lSRVDesc.Texture2D.MipLevels := UINT(-1);

            // Create the shader resource view for the texture.
            Result := d3ddevice.CreateShaderResourceView(texture, @lSRVDesc, textureView);
            if (Result = S_OK) then
            begin
                // Generate mipmaps for this texture.
                d3dContext.GenerateMips(textureView);
            end;

        end;
        // Release the targa image data now that the image data has been loaded into the texture.
        SetLength(lTargaData, 0);
    end;
end;

end.
