unit TextClass;

{$IFDEF FPC}
{$mode DelphiUnicode}{$H+}
{$ENDIF}

interface

uses
    Classes, SysUtils,
    Windows,
    DirectX.Math,
    DX12.D3D11,
    DX12.DXGI,
    DX12.D3DCommon,
    fontclass,
    BaseTypes,
    shadermanagerclass;

type

    { TTextClass }

    TTextClass = class(TObject)
    private


    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(device: ID3D11Device; deviceContext: ID3D11DeviceContext; screenWidth, screenHeight, maxLength: integer;
            shadow: boolean; Font: TFontClass; Text: ansistring; positionX, positionY: integer; red, green, blue: single): HResult;
        procedure Shutdown();
        procedure Render(deviceContext: ID3D11DeviceContext; ShaderManager: TShaderManagerClass;
            worldMatrix, viewMatrix, orthoMatrix: TXMMATRIX; fontTexture: ID3D11ShaderResourceView);

        function UpdateSentence(deviceContext: ID3D11DeviceContext; Font: TFontClass; Text: ansistring;
            positionX, positionY: integer; red, green, blue: single): HResult;

    private
        function InitializeSentence(device: ID3D11Device; deviceContext: ID3D11DeviceContext; Font: TFontClass;
            Text: ansistring; positionX, positionY: integer; red, green, blue: single): HResult;
        procedure RenderSentence(deviceContext: ID3D11DeviceContext; ShaderManager: TShaderManagerClass;
            worldMatrix, viewMatrix, orthoMatrix: TXMMATRIX; fontTexture: ID3D11ShaderResourceView);

    private
        m_vertexBuffer, m_indexBuffer, m_vertexBuffer2, m_indexBuffer2: ID3D11Buffer;
        m_screenWidth, m_screenHeight, m_maxLength, m_vertexCount, m_indexCount: integer;
        m_shadow: boolean;
        m_pixelColor: TXMFLOAT4;
    end;


implementation



constructor TTextClass.Create;
begin

end;



destructor TTextClass.Destroy;
begin
    inherited Destroy;
end;



function TTextClass.Initialize(device: ID3D11Device; deviceContext: ID3D11DeviceContext; screenWidth, screenHeight, maxLength: integer;
    shadow: boolean; Font: TFontClass; Text: ansistring; positionX, positionY: integer; red, green, blue: single): HResult;
begin

    // Store the screen width and height.
    m_screenWidth := screenWidth;
    m_screenHeight := screenHeight;

    // Store the maximum length of the sentence.
    m_maxLength := maxLength;

    // Store if this sentence is shadowed or not.
    m_shadow := shadow;

    // Initalize the sentence.
    Result := InitializeSentence(device, deviceContext, Font, Text, positionX, positionY, red, green, blue);
end;



procedure TTextClass.Shutdown();
begin
    // Release the buffers.
    m_vertexBuffer := nil;
    m_indexBuffer := nil;
    m_vertexBuffer2 := nil;
    m_indexBuffer2 := nil;
end;



procedure TTextClass.Render(deviceContext: ID3D11DeviceContext; ShaderManager: TShaderManagerClass;
    worldMatrix, viewMatrix, orthoMatrix: TXMMATRIX; fontTexture: ID3D11ShaderResourceView);
begin
    // Draw the sentence.
    RenderSentence(deviceContext, ShaderManager, worldMatrix, viewMatrix, orthoMatrix, fontTexture);

end;



function TTextClass.InitializeSentence(device: ID3D11Device; deviceContext: ID3D11DeviceContext; Font: TFontClass;
    Text: ansistring; positionX, positionY: integer; red, green, blue: single): HResult;
var
    vertices: array of TVertexType;
    indices: array of uint32;
    vertexBufferDesc, indexBufferDesc: TD3D11_BUFFER_DESC;
    vertexData, indexData: TD3D11_SUBRESOURCE_DATA;

    i: integer;
begin

    // Set the vertex and index count.
    m_vertexCount := 6 * m_maxLength;
    m_indexCount := 6 * m_maxLength;

    // Create the vertex array.
    SetLength(vertices, m_vertexCount);


    // Create the index array.
    SetLength(indices, m_indexCount);

    // Initialize vertex array to zeros at first.
    ZeroMemory(@vertices[0], (sizeof(TVertexType) * m_vertexCount));

    // Initialize the index array.
    for i := 0 to m_indexCount - 1 do
    begin
        indices[i] := i;
    end;

    // Set up the description of the dynamic vertex buffer.
    vertexBufferDesc.Usage := D3D11_USAGE_DYNAMIC;
    vertexBufferDesc.ByteWidth := sizeof(TVertexType) * m_vertexCount;
    vertexBufferDesc.BindFlags := Ord(D3D11_BIND_VERTEX_BUFFER);
    vertexBufferDesc.CPUAccessFlags := Ord(D3D11_CPU_ACCESS_WRITE);
    vertexBufferDesc.MiscFlags := 0;
    vertexBufferDesc.StructureByteStride := 0;

    // Give the subresource structure a pointer to the vertex data.
    vertexData.pSysMem := vertices;
    vertexData.SysMemPitch := 0;
    vertexData.SysMemSlicePitch := 0;

    // Create the vertex buffer.
    Result := device.CreateBuffer(vertexBufferDesc, @vertexData, m_vertexBuffer);
    if (Result <> S_OK) then Exit;


    // Set up the description of the static index buffer.
    indexBufferDesc.Usage := D3D11_USAGE_DEFAULT;
    indexBufferDesc.ByteWidth := sizeof(uint32) * m_indexCount;
    indexBufferDesc.BindFlags := Ord(D3D11_BIND_INDEX_BUFFER);
    indexBufferDesc.CPUAccessFlags := 0;
    indexBufferDesc.MiscFlags := 0;
    indexBufferDesc.StructureByteStride := 0;

    // Give the subresource structure a pointer to the index data.
    indexData.pSysMem := indices;
    indexData.SysMemPitch := 0;
    indexData.SysMemSlicePitch := 0;

    // Create the index buffer.
    Result := device.CreateBuffer(indexBufferDesc, @indexData, m_indexBuffer);
    if (Result <> S_OK) then Exit;

    // If shadowed create the second vertex and index buffer.
    if (m_shadow) then
    begin
        Result := device.CreateBuffer(vertexBufferDesc, @vertexData, m_vertexBuffer2);
        if (Result <> S_OK) then Exit;

        Result := device.CreateBuffer(indexBufferDesc, @indexData, m_indexBuffer2);
        if (Result <> S_OK) then Exit;
    end;

    // Release the vertex array as it is no longer needed.
    SetLength(vertices, 0);
    // Release the index array as it is no longer needed.
    SetLength(indices, 0);


    // Now add the text data to the sentence buffers.
    Result := UpdateSentence(deviceContext, Font, Text, positionX, positionY, red, green, blue);
end;



function TTextClass.UpdateSentence(deviceContext: ID3D11DeviceContext; Font: TFontClass; Text: ansistring;
    positionX, positionY: integer; red, green, blue: single): HResult;
var
    numLetters: integer;
    vertices: array of TVertexType;
    drawX, drawY: single;
    mappedResource: TD3D11_MAPPED_SUBRESOURCE;
    verticesPtr: pointer;

begin

    // Store the color of the sentence.
    m_pixelColor := TXMFLOAT4.Create(red, green, blue, 1.0);

    // Get the number of letters in the sentence.
    numLetters := Length(Text);

    // Check for possible buffer overflow.
    if (numLetters > m_maxLength) then
    begin
        Result := E_FAIL;
        Exit;
    end;

    // Create the vertex array.
    SetLength(vertices, m_vertexCount);

    // Initialize vertex array to zeros at first.
    ZeroMemory(@vertices[0], (sizeof(TVertexType) * m_vertexCount));

    // Calculate the X and Y pixel position on the screen to start drawing to.
    drawX := (((m_screenWidth / 2) * -1) + positionX);
    drawY := ((m_screenHeight / 2) - positionY);

    // Use the font class to build the vertex array from the sentence text and sentence draw location.
    Font.BuildVertexArray(vertices, Text, drawX, drawY);

    // Lock the vertex buffer.
    Result := deviceContext.Map(m_vertexBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, mappedResource);
    if (Result <> S_OK) then Exit;


    // Get a pointer to the mapped resource data pointer.
    verticesPtr := mappedResource.pData;

    // Copy the vertex array into the vertex buffer.
    Move(vertices[0], verticesPtr^, sizeof(TVertexType) * m_vertexCount);


    // Unlock the vertex buffer.
    deviceContext.Unmap(m_vertexBuffer, 0);

    // If shadowed then do the same for the second vertex buffer but offset by two pixels on both axis.
    if (m_shadow) then
    begin
        ZeroMemory(@vertices[0], sizeof(TVertexType) * m_vertexCount);


        drawX := ((((m_screenWidth / 2) * -1) + positionX) + 2);
        drawY := (((m_screenHeight / 2) - positionY) - 2);
        Font.BuildVertexArray(vertices, Text, drawX, drawY);

        Result := deviceContext.Map(m_vertexBuffer2, 0, D3D11_MAP_WRITE_DISCARD, 0, mappedResource);
        if (Result <> S_OK) then Exit;
        verticesPtr := mappedResource.pData;
        Move(vertices[0], verticesPtr^, sizeof(TVertexType) * m_vertexCount);
        deviceContext.Unmap(m_vertexBuffer2, 0);
    end;

    // Release the vertex array as it is no longer needed.
    SetLength(vertices, 0);

end;



procedure TTextClass.RenderSentence(deviceContext: ID3D11DeviceContext; ShaderManager: TShaderManagerClass;
    worldMatrix, viewMatrix, orthoMatrix: TXMMATRIX; fontTexture: ID3D11ShaderResourceView);
var
    stride, offset: uint32;
    shadowColor: TXMFLOAT4;
begin

    // Set vertex buffer stride and offset.
    stride := sizeof(TVertexType);
    offset := 0;

    // If shadowed then render the shadow text first.
    if (m_shadow) then
    begin
        shadowColor := TXMFLOAT4.Create(0.0, 0.0, 0.0, 1.0);

        deviceContext.IASetVertexBuffers(0, 1, @m_vertexBuffer2, @stride, @offset);
        deviceContext.IASetIndexBuffer(m_indexBuffer2, DXGI_FORMAT_R32_UINT, 0);
        deviceContext.IASetPrimitiveTopology(D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST);

        ShaderManager.RenderFontShader(deviceContext, m_indexCount, worldMatrix, viewMatrix, orthoMatrix, fontTexture, shadowColor);
    end;

    // Render the text buffers.
    deviceContext.IASetVertexBuffers(0, 1, @m_vertexBuffer, @stride, @offset);
    deviceContext.IASetIndexBuffer(m_indexBuffer, DXGI_FORMAT_R32_UINT, 0);
    deviceContext.IASetPrimitiveTopology(D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST);

    ShaderManager.RenderFontShader(deviceContext, m_indexCount, worldMatrix, viewMatrix, orthoMatrix, fontTexture, m_pixelColor);

end;

end.
