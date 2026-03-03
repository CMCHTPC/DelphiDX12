unit TextClass;

interface

uses
    Classes, SysUtils, Windows,
    fontclass,
    fontshaderclass,
    DX12.D3DX11,
    DX12.D3DX10,
    DX12.DXGI,
    DX12.D3DCommon,
    DX12.D3D11;

type

    TSentenceType = record
        vertexBuffer, indexBuffer: ID3D11Buffer;
        vertexCount, indexCount, maxLength: integer;
        red, green, blue: single;
    end;

    TVertexType = record
        position: TD3DXVECTOR3;
        texture: TD3DXVECTOR2;
    end;

    TTextClass = class(TObject)
    private
        m_screenWidth, m_screenHeight: integer;
        m_baseViewMatrix: TD3DXMATRIX;
        m_Font: TFontClass;
        m_sentence1, m_sentence2, m_sentence3, m_sentence4, m_sentence5: TSentenceType;
        m_sentence6, m_sentence7, m_sentence8, m_sentence9, m_sentence10: TSentenceType;

    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(device: ID3D11Device; deviceContext: ID3D11DeviceContext; HWND: HWND; screenWidth, screenHeight: integer;
          baseViewMatrix: TD3DXMATRIX): HResult;
        procedure Shutdown();
        function Render(deviceContext: ID3D11DeviceContext; FontShader: Tfontshaderclass; worldMatrix, orthoMatrix: TD3DXMATRIX): HResult;

        function SetVideoCardInfo(videoCardName: ansistring; videoCardMemory: integer; deviceContext: ID3D11DeviceContext): HResult;
        function SetFps(fps: integer; deviceContext: ID3D11DeviceContext): HResult;
        function SetCpu(cpu: integer; deviceContext: ID3D11DeviceContext): HResult;
        function SetCameraPosition(posX, posY, posZ: single; deviceContext: ID3D11DeviceContext): HResult;
        function SetCameraRotation(rotX, rotY, rotZ: single; deviceContext: ID3D11DeviceContext): HResult;

    private
        function InitializeSentence(var sentence: TSentenceType; maxLength: integer; device: ID3D11Device): HResult;
        function UpdateSentence(var sentence: TSentenceType; text: ansistring; positionX, positionY: integer; red, green, blue: single;
          deviceContext: ID3D11DeviceContext): HResult;
        procedure ReleaseSentence(var sentence: TSentenceType);
        function RenderSentence(sentence: TSentenceType; deviceContext: ID3D11DeviceContext; FontShader: Tfontshaderclass;
          worldMatrix, orthoMatrix: TD3DXMATRIX): HResult;

    end;

implementation

constructor TTextClass.Create;
begin
    m_Font := nil;
end;

destructor TTextClass.Destroy;
begin
    inherited;
end;

function TTextClass.Initialize(device: ID3D11Device; deviceContext: ID3D11DeviceContext; HWND: HWND; screenWidth, screenHeight: integer;
  baseViewMatrix: TD3DXMATRIX): HResult;
begin

    // Store the screen width and height for calculating pixel location during the sentence updates.
    m_screenWidth := screenWidth;
    m_screenHeight := screenHeight;

    // Store the base view matrix for 2D text rendering.
    m_baseViewMatrix := baseViewMatrix;

    // Create the font object.
    m_Font := TFontClass.Create;

    // Initialize the font object.
    result := m_Font.Initialize(device, 'fontdata.txt', 'font.dds');
    if (result <> S_OK) then
    begin
        MessageBoxW(HWND, 'Could not initialize the font object.', 'Error', MB_OK);
        Exit;
    end;

    // Initialize the first sentence.
    result := InitializeSentence(m_sentence1, 150, device);
    if (result <> S_OK) then
        Exit;

    // Initialize the second sentence.
    result := InitializeSentence(m_sentence2, 32, device);
    if (result <> S_OK) then
        Exit;

    // Initialize the third sentence.
    result := InitializeSentence(m_sentence3, 16, device);
    if (result <> S_OK) then
        Exit;

    // Initialize the fourth sentence.
    result := InitializeSentence(m_sentence4, 16, device);
    if (result <> S_OK) then
        Exit;

    // Initialize the fifth sentence.
    result := InitializeSentence(m_sentence5, 16, device);
    if (result <> S_OK) then
        Exit;

    // Initialize the sixth sentence.
    result := InitializeSentence(m_sentence6, 16, device);
    if (result <> S_OK) then
        Exit;

    // Initialize the seventh sentence.
    result := InitializeSentence(m_sentence7, 16, device);
    if (result <> S_OK) then
        Exit;

    // Initialize the eighth sentence.
    result := InitializeSentence(m_sentence8, 16, device);
    if (result <> S_OK) then
        Exit;

    // Initialize the ninth sentence.
    result := InitializeSentence(m_sentence9, 16, device);
    if (result <> S_OK) then
        Exit;

    // Initialize the tenth sentence.
    result := InitializeSentence(m_sentence10, 16, device);
end;

procedure TTextClass.Shutdown();
begin
    // Release the font object.
    if (m_Font <> nil) then
    begin
        m_Font.Shutdown();
        m_Font.Free;
        m_Font := nil;
    end;

    // Release the sentences.
    ReleaseSentence(m_sentence1);
    ReleaseSentence(m_sentence2);
    ReleaseSentence(m_sentence3);
    ReleaseSentence(m_sentence4);
    ReleaseSentence(m_sentence5);
    ReleaseSentence(m_sentence6);
    ReleaseSentence(m_sentence7);
    ReleaseSentence(m_sentence8);
    ReleaseSentence(m_sentence9);
    ReleaseSentence(m_sentence10);
end;

function TTextClass.Render(deviceContext: ID3D11DeviceContext; FontShader: Tfontshaderclass; worldMatrix, orthoMatrix: TD3DXMATRIX): HResult;
begin

    // Draw the sentences.
    result := RenderSentence(m_sentence1, deviceContext, FontShader, worldMatrix, orthoMatrix);
    if (result <> S_OK) then
        Exit;

    result := RenderSentence(m_sentence2, deviceContext, FontShader, worldMatrix, orthoMatrix);
    if (result <> S_OK) then
        Exit;

    result := RenderSentence(m_sentence3, deviceContext, FontShader, worldMatrix, orthoMatrix);
    if (result <> S_OK) then
        Exit;

    result := RenderSentence(m_sentence4, deviceContext, FontShader, worldMatrix, orthoMatrix);
    if (result <> S_OK) then
        Exit;

    result := RenderSentence(m_sentence5, deviceContext, FontShader, worldMatrix, orthoMatrix);
    if (result <> S_OK) then
        Exit;

    result := RenderSentence(m_sentence6, deviceContext, FontShader, worldMatrix, orthoMatrix);
    if (result <> S_OK) then
        Exit;

    result := RenderSentence(m_sentence7, deviceContext, FontShader, worldMatrix, orthoMatrix);
    if (result <> S_OK) then
        Exit;

    result := RenderSentence(m_sentence8, deviceContext, FontShader, worldMatrix, orthoMatrix);
    if (result <> S_OK) then
        Exit;

    result := RenderSentence(m_sentence9, deviceContext, FontShader, worldMatrix, orthoMatrix);
    if (result <> S_OK) then
        Exit;

    result := RenderSentence(m_sentence10, deviceContext, FontShader, worldMatrix, orthoMatrix);

end;

function TTextClass.InitializeSentence(var sentence: TSentenceType; maxLength: integer; device: ID3D11Device): HResult;
var
    vertices: array of TVertexType;
    indices: array of UINT32;
    vertexBufferDesc, indexBufferDesc: TD3D11_BUFFER_DESC;
    vertexData, indexData: TD3D11_SUBRESOURCE_DATA;
    i: integer;
begin
    // Create a new sentence object.
    // Initialize the sentence buffers to nil.
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
    vertexBufferDesc.BindFlags := ord(D3D11_BIND_VERTEX_BUFFER);
    vertexBufferDesc.CPUAccessFlags := ord(D3D11_CPU_ACCESS_WRITE);
    vertexBufferDesc.MiscFlags := 0;
    vertexBufferDesc.StructureByteStride := 0;

    // Give the subresource structure a pointer to the vertex data.
    vertexData.pSysMem := vertices;
    vertexData.SysMemPitch := 0;
    vertexData.SysMemSlicePitch := 0;

    // Create the vertex buffer.
    result := device.CreateBuffer(vertexBufferDesc, @vertexData, sentence.vertexBuffer);
    if (result <> S_OK) then
        Exit;

    // Set up the description of the static index buffer.
    indexBufferDesc.Usage := D3D11_USAGE_DEFAULT;
    indexBufferDesc.ByteWidth := sizeof(UINT32) * sentence.indexCount;
    indexBufferDesc.BindFlags := ord(D3D11_BIND_INDEX_BUFFER);
    indexBufferDesc.CPUAccessFlags := 0;
    indexBufferDesc.MiscFlags := 0;
    indexBufferDesc.StructureByteStride := 0;

    // Give the subresource structure a pointer to the index data.
    indexData.pSysMem := indices;
    indexData.SysMemPitch := 0;
    indexData.SysMemSlicePitch := 0;

    // Create the index buffer.
    result := device.CreateBuffer(indexBufferDesc, @indexData, sentence.indexBuffer);
    if (result <> S_OK) then
        Exit;

    // Release the vertex array as it is no longer needed.
    SetLength(vertices, 0);

    // Release the index array as it is no longer needed.
    SetLength(indices, 0);
end;

function TTextClass.UpdateSentence(var sentence: TSentenceType; text: ansistring; positionX, positionY: integer; red, green, blue: single;
  deviceContext: ID3D11DeviceContext): HResult;
var
    numLetters: integer;
    vertices: array of TVertexType;
    drawX, drawY: single;

    mappedResource: TD3D11_MAPPED_SUBRESOURCE;
    verticesPtr: ^TVertexType;
begin
    result := E_FAIL;
    // Store the color of the sentence.
    sentence.red := red;
    sentence.green := green;
    sentence.blue := blue;

    // Get the number of letters in the sentence.
    numLetters := Length(text);

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
    m_Font.BuildVertexArray(@vertices[0], text, drawX, drawY);

    // Lock the vertex buffer so it can be written to.
    result := deviceContext.Map(sentence.vertexBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, mappedResource);
    if (result <> S_OK) then
        Exit;

    // Get a pointer to the data in the vertex buffer.
    verticesPtr := mappedResource.pData;

    // Copy the data into the vertex buffer.
    Move(vertices[0], verticesPtr^, (sizeof(TVertexType) * sentence.vertexCount));

    // Unlock the vertex buffer.
    deviceContext.Unmap(sentence.vertexBuffer, 0);

    // Release the vertex array as it is no longer needed.
    SetLength(vertices, 0);

    result := S_OK;
end;

procedure TTextClass.ReleaseSentence(var sentence: TSentenceType);
begin
    // Release the sentence vertex buffer.
    sentence.vertexBuffer := nil;
    // Release the sentence index buffer.
    sentence.indexBuffer := nil;
end;

function TTextClass.RenderSentence(sentence: TSentenceType; deviceContext: ID3D11DeviceContext; FontShader: Tfontshaderclass;
  worldMatrix, orthoMatrix: TD3DXMATRIX): HResult;

var
    stride, offset: UINT32;
    pixelColor: TD3DXVECTOR4;
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
    pixelColor := TD3DXVECTOR4.Create(sentence.red, sentence.green, sentence.blue, 1.0);

    // Render the text using the font shader.
    result := FontShader.Render(deviceContext, sentence.indexCount, worldMatrix, m_baseViewMatrix, orthoMatrix, m_Font.GetTexture(), pixelColor);
end;

function TTextClass.SetVideoCardInfo(videoCardName: ansistring; videoCardMemory: integer; deviceContext: ID3D11DeviceContext): HResult;
var
    dataString: ansistring;
    memoryString: ansistring;
begin
    // Setup the video card name string.
    dataString := 'Video Card: '+videoCardName;

    // Update the sentence vertex buffer with the new string information.
    result := UpdateSentence(m_sentence1, dataString, 10, 10, 1.0, 1.0, 1.0, deviceContext);
    if (result <> S_OK) then
        Exit;

    // Truncate the memory value to prevent buffer over flow.
    if (videoCardMemory > 9999999) then
    begin
        videoCardMemory := 9999999;
    end;

    // Convert the video memory integer value to a string format.
    memoryString := 'Video Memory: ' + IntToStr(videoCardMemory) + 'MB';

    // Update the sentence vertex buffer with the new string information.
    result := UpdateSentence(m_sentence2, memoryString, 10, 30, 1.0, 1.0, 1.0, deviceContext);
end;

function TTextClass.SetFps(fps: integer; deviceContext: ID3D11DeviceContext): HResult;
var
    fpsString: ansistring;
begin
    // Truncate the fps to prevent a buffer over flow.
    if (fps > 9999) then
    begin
        fps := 9999;
    end;

    // Setup the fps string.
    fpsString := 'Fps: ' + IntToStr(fps);

    // Update the sentence vertex buffer with the new string information.
    result := UpdateSentence(m_sentence3, fpsString, 10, 70, 0.0, 1.0, 0.0, deviceContext);
end;

function TTextClass.SetCpu(cpu: integer; deviceContext: ID3D11DeviceContext): HResult;
var
    cpuString: ansistring;
begin
    // Setup the cpu string.
    cpuString := 'Cpu: ' + IntToStr(cpu) + '%';
    // Update the sentence vertex buffer with the new string information.
    result := UpdateSentence(m_sentence4, cpuString, 10, 90, 0.0, 1.0, 0.0, deviceContext);
end;

function TTextClass.SetCameraPosition(posX, posY, posZ: single; deviceContext: ID3D11DeviceContext): HResult;
var
    positionX, positionY, positionZ: integer;
    dataString: ansistring;
begin
    // Convert the position from floating point to integer.
    positionX := trunc(posX);
    positionY := trunc(posY);
    positionZ := trunc(posZ);

    // Truncate the position if it exceeds either 9999 or -9999.
    if (positionX > 9999) then
    begin
        positionX := 9999;
    end;
    if (positionY > 9999) then
    begin
        positionY := 9999;
    end;
    if (positionZ > 9999) then
    begin
        positionZ := 9999;
    end;

    if (positionX < -9999) then
    begin
        positionX := -9999;
    end;
    if (positionY < -9999) then
    begin
        positionY := -9999;
    end;
    if (positionZ < -9999) then
    begin
        positionZ := -9999;
    end;

    // Setup the X position string.
    dataString := 'X: ' + IntToStr(positionX);
    result := UpdateSentence(m_sentence5, dataString, 10, 130, 0.0, 1.0, 0.0, deviceContext);
    if (result <> S_OK) then
        Exit;

    // Setup the Y position string.
    dataString := 'Y: ' + IntToStr(positionY);
    result := UpdateSentence(m_sentence6, dataString, 10, 150, 0.0, 1.0, 0.0, deviceContext);
    if (result <> S_OK) then
        Exit;

    // Setup the Z position string.
    dataString := 'Z: ' + IntToStr(positionZ);
    result := UpdateSentence(m_sentence7, dataString, 10, 170, 0.0, 1.0, 0.0, deviceContext);

end;

function TTextClass.SetCameraRotation(rotX, rotY, rotZ: single; deviceContext: ID3D11DeviceContext): HResult;
var
    rotationX, rotationY, rotationZ: integer;
    dataString: ansistring;

begin
    // Convert the rotation from floating point to integer.
    rotationX := trunc(rotX);
    rotationY := trunc(rotY);
    rotationZ := trunc(rotZ);

    // Setup the X rotation string.
    dataString := 'rX: ' + IntToStr(rotationX);
    result := UpdateSentence(m_sentence8, dataString, 10, 210, 0.0, 1.0, 0.0, deviceContext);
    if (result <> S_OK) then
        Exit;

    // Setup the Y rotation string.
    dataString := 'rY: ' + IntToStr(rotationY);
    result := UpdateSentence(m_sentence9, dataString, 10, 230, 0.0, 1.0, 0.0, deviceContext);
    if (result <> S_OK) then
        Exit;

    // Setup the Z rotation string.
    dataString := 'rZ: ' + IntToStr(rotationZ);
    result := UpdateSentence(m_sentence10, dataString, 10, 250, 0.0, 1.0, 0.0, deviceContext);
end;

end.
