unit TextClass;

{$mode DelphiUnicode}{$H+}

interface

uses
    Classes, SysUtils, Windows,
    FontClass,
    FontShaderClass,
    DX12.D3D11,
    DX12.D3DCommon,
    DX12.DXGI,
    Basetypes,
    DirectX.Math;

type

    TSentenceType = record
        vertexBuffer, indexBuffer: ID3D11Buffer;
        vertexCount, indexCount, maxLength: integer;
        red, green, blue: single;
    end;




    { TTextClass }

    TTextClass = class(TObject)
    private
        m_Font: TFontClass;
        m_FontShader: TFontShaderClass;
        m_screenWidth, m_screenHeight: integer;
        m_baseViewMatrix: TXMMATRIX;
        m_sentence1: TSentenceType;
        m_sentence2: TSentenceType;


    private
        function InitializeSentence(var sentence: TSentenceType; maxLength: integer; device: ID3D11Device): HResult;
        function UpdateSentence(var sentence: TSentenceType; Text: ansistring; positionX, positionY: integer;
            red, green, blue: single; deviceContext: ID3D11DeviceContext): HResult;
        procedure ReleaseSentence(var sentence: TSentenceType);
        function RenderSentence(deviceContext: ID3D11DeviceContext; sentence: TSentenceType;
            worldMatrix, orthoMatrix: TXMMATRIX): HResult;

    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(device: ID3D11Device; deviceContext: ID3D11DeviceContext; hwnd: HWND;
            screenWidth, screenHeight: integer; baseViewMatrix: TXMMATRIX): HResult;
        procedure Shutdown();
        function Render(deviceContext: ID3D11DeviceContext; worldMatrix, orthoMatrix: TXMMATRIX): HResult;

        function SetMousePosition(mouseX, mouseY: integer; deviceContext: ID3D11DeviceContext): HResult;
    end;

implementation

{ TTextClass }

function TTextClass.InitializeSentence(var sentence: TSentenceType; maxLength: integer; device: ID3D11Device): HResult;
var
    vertices: array of TVertexType;
    indices: array of uint32;
    vertexBufferDesc, indexBufferDesc: TD3D11_BUFFER_DESC;
    vertexData, indexData: TD3D11_SUBRESOURCE_DATA;
    i: integer;
begin
    // Create a new sentence object.

    // Initialize the sentence buffers to null.
    sentence.vertexBuffer := nil;
    sentence.indexBuffer := nil;

    // Set the maximum length of the sentence.
    sentence.maxLength := maxLength;

    // Set the number of vertices in the vertex array.
    sentence.vertexCount := 6 * maxLength;

    // Set the number of indexes in the index array.
    sentence.indexCount := sentence.vertexCount;

    // Create the vertex array.
    SetLength(vertices, sentence.vertexCount);

    // Create the index array.
    SetLength(indices, sentence.indexCount);

    // Initialize vertex array to zeros at first.
    ZeroMemory(@vertices[0], (sizeof(TVertexType) * sentence.vertexCount));

    // Initialize the index array.
    for i := 0 to sentence.indexCount - 1 do
    begin
        indices[i] := i;
    end;

    // Set up the description of the dynamic vertex buffer.
    vertexBufferDesc.Usage := D3D11_USAGE_DYNAMIC;
    vertexBufferDesc.ByteWidth := sizeof(TVertexType) * sentence.vertexCount;
    vertexBufferDesc.BindFlags := Ord(D3D11_BIND_VERTEX_BUFFER);
    vertexBufferDesc.CPUAccessFlags := Ord(D3D11_CPU_ACCESS_WRITE);
    vertexBufferDesc.MiscFlags := 0;
    vertexBufferDesc.StructureByteStride := 0;

    // Give the subresource structure a pointer to the vertex data.
    vertexData.pSysMem := vertices;
    vertexData.SysMemPitch := 0;
    vertexData.SysMemSlicePitch := 0;

    // Create the vertex buffer.
    Result := device.CreateBuffer(vertexBufferDesc, @vertexData, sentence.vertexBuffer);
    if (FAILED(Result)) then Exit;

    // Set up the description of the static index buffer.
    indexBufferDesc.Usage := D3D11_USAGE_DEFAULT;
    indexBufferDesc.ByteWidth := sizeof(uint32) * sentence.indexCount;
    indexBufferDesc.BindFlags := Ord(D3D11_BIND_INDEX_BUFFER);
    indexBufferDesc.CPUAccessFlags := 0;
    indexBufferDesc.MiscFlags := 0;
    indexBufferDesc.StructureByteStride := 0;

    // Give the subresource structure a pointer to the index data.
    indexData.pSysMem := indices;
    indexData.SysMemPitch := 0;
    indexData.SysMemSlicePitch := 0;

    // Create the index buffer.
    Result := device.CreateBuffer(indexBufferDesc, @indexData, sentence.indexBuffer);
    if (FAILED(Result)) then Exit;

    // Release the vertex array as it is no longer needed.
    SetLength(vertices, 0);

    // Release the index array as it is no longer needed.
    SetLength(indices, 0);
end;



function TTextClass.UpdateSentence(var sentence: TSentenceType; Text: ansistring; positionX, positionY: integer;
    red, green, blue: single; deviceContext: ID3D11DeviceContext): HResult;
var
    numLetters: integer;
    vertices: array of TVertexType;
    drawX, drawY: single;
    mappedResource: TD3D11_MAPPED_SUBRESOURCE;
    verticesPtr: ^TVertexType;
begin
    // Store the color of the sentence.
    sentence.red := red;
    sentence.green := green;
    sentence.blue := blue;

    // Get the number of letters in the sentence.
    numLetters := length(Text);

    Result := E_FAIL;
    // Check for possible buffer overflow.
    if (numLetters > sentence.maxLength) then
        Exit;

    // Create the vertex array.
    SetLength(vertices, sentence.vertexCount);

    // Initialize vertex array to zeros at first.
    ZeroMemory(@vertices[0], (sizeof(TVertexType) * sentence.vertexCount));

    // Calculate the X and Y pixel position on the screen to start drawing to.
    drawX := (((m_screenWidth / 2) * -1) + positionX);
    drawY := ((m_screenHeight / 2) - positionY);

    // Use the font class to build the vertex array from the sentence text and sentence draw location.
    m_Font.BuildVertexArray(vertices, Text, drawX, drawY);

    // Lock the vertex buffer so it can be written to.
    Result := deviceContext.Map(sentence.vertexBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, mappedResource);
    if (FAILED(Result)) then Exit;

    // Get a pointer to the data in the vertex buffer.
    verticesPtr := mappedResource.pData;

    // Copy the data into the vertex buffer.
    Move(vertices[0], verticesPtr^, sizeof(TVertexType) * sentence.vertexCount);

    // Unlock the vertex buffer.
    deviceContext.Unmap(sentence.vertexBuffer, 0);

    // Release the vertex array as it is no longer needed.
    SetLength(vertices, 0);
end;



procedure TTextClass.ReleaseSentence(var sentence: TSentenceType);
begin
    begin
        // Release the sentence vertex buffer.
        sentence.vertexBuffer := nil;
        // Release the sentence index buffer.
        sentence.indexBuffer := nil;
        // Release the sentence.
    end;
end;



function TTextClass.RenderSentence(deviceContext: ID3D11DeviceContext; sentence: TSentenceType; worldMatrix, orthoMatrix: TXMMATRIX): HResult;
var
    stride, offset: uint32;
    pixelColor: TXMFLOAT4;
begin
    // Set vertex buffer stride and offset.
    stride := sizeof(TVertexType);
    offset := 0;

    // Set the vertex buffer to active in the input assembler so it can be rendered.
    deviceContext.IASetVertexBuffers(0, 1, @sentence.vertexBuffer, @stride, @offset);

    // Set the index buffer to active in the input assembler so it can be rendered.
    deviceContext.IASetIndexBuffer(sentence.indexBuffer, DXGI_FORMAT_R32_UINT, 0);

    // Set the type of primitive that should be rendered from this vertex buffer, in this case triangles.
    deviceContext.IASetPrimitiveTopology(D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST);

    // Create a pixel color vector with the input sentence color.
    pixelColor := TXMFLOAT4.Create(sentence.red, sentence.green, sentence.blue, 1.0);

    // Render the text using the font shader.
    Result := m_FontShader.Render(deviceContext, sentence.indexCount, worldMatrix, m_baseViewMatrix, orthoMatrix,
        m_Font.GetTexture(), pixelColor);
end;



constructor TTextClass.Create;
begin

end;



destructor TTextClass.Destroy;
begin
    inherited Destroy;
end;



function TTextClass.Initialize(device: ID3D11Device; deviceContext: ID3D11DeviceContext; hwnd: HWND;
    screenWidth, screenHeight: integer; baseViewMatrix: TXMMATRIX): HResult;
begin
    // Store the screen width and height.
    m_screenWidth := screenWidth;
    m_screenHeight := screenHeight;

    // Store the base view matrix.
    m_baseViewMatrix := baseViewMatrix;

    // Create the font object.
    m_Font := TFontClass.Create;
    // Initialize the font object.
    Result := m_Font.Initialize(device, deviceContext, 'fontdata.txt', 'font.dds');
    if (Result <> S_OK) then
    begin
        MessageBox(hwnd, 'Could not initialize the font object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the font shader object.
    m_FontShader := TFontShaderClass.Create;
    // Initialize the font shader object.
    Result := m_FontShader.Initialize(device, hwnd);
    if (Result <> S_OK) then
    begin
        MessageBox(hwnd, 'Could not initialize the font shader object.', 'Error', MB_OK);
        Exit;
    end;

    // Initialize the first sentence.
    Result := InitializeSentence(m_sentence1, 16, device);
    if (Result <> S_OK) then  Exit;

    // Now update the sentence vertex buffer with the new string information.
    Result := UpdateSentence(m_sentence1, 'Hello', 100, 100, 1.0, 1.0, 1.0, deviceContext);
    if (Result <> S_OK) then  Exit;

    // Initialize the first sentence.
    Result := InitializeSentence(m_sentence2, 16, device);
    if (Result <> S_OK) then  Exit;

    // Now update the sentence vertex buffer with the new string information.
    Result := UpdateSentence(m_sentence2, 'Goodbye', 100, 200, 1.0, 1.0, 0.0, deviceContext);

end;



procedure TTextClass.Shutdown();
begin
    // Release the first sentence.
    ReleaseSentence(m_sentence1);

    // Release the second sentence.
    ReleaseSentence(m_sentence2);

    // Release the font shader object.
    if (m_FontShader <> nil) then
    begin
        m_FontShader.Shutdown();
        m_FontShader.Free;
        m_FontShader := nil;
    end;

    // Release the font object.
    if (m_Font <> nil) then
    begin
        m_Font.Shutdown();
        m_Font.Free;
        m_Font := nil;
    end;
end;



function TTextClass.Render(deviceContext: ID3D11DeviceContext; worldMatrix, orthoMatrix: TXMMATRIX): HResult;
begin
    // Draw the first sentence.
    Result := RenderSentence(deviceContext, m_sentence1, worldMatrix, orthoMatrix);
    if (Result <> S_OK) then Exit;

    // Draw the second sentence.
    Result := RenderSentence(deviceContext, m_sentence2, worldMatrix, orthoMatrix);
end;



function TTextClass.SetMousePosition(mouseX, mouseY: integer; deviceContext: ID3D11DeviceContext): HResult;
var
    mouseString: ansistring;
begin
    // Convert the mouseX integer to string format.
    // Setup the mouseX string.
    mouseString := 'Mouse X: ' + IntToStr(MouseX);



    // Update the sentence vertex buffer with the new string information.
    Result := UpdateSentence(m_sentence1, mouseString, 20, 20, 1.0, 1.0, 1.0, deviceContext);
    if (Result <> S_OK) then Exit;

    // Convert the mouseY integer to string format.
    // Setup the mouseY string.
    mouseString := 'Mouse Y: ' + IntToStr(MouseY);

    // Update the sentence vertex buffer with the new string information.
    Result := UpdateSentence(m_sentence2, mouseString, 20, 40, 1.0, 1.0, 1.0, deviceContext);

end;

end.
