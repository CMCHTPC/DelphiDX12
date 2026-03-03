unit SkyPlaneClass;

{$mode Delphi}

interface

uses
    Classes, SysUtils, Windows,
    DX12.D3D11,
    DX12.D3DCommon,
    DX12.DXGI,
    DirectX.Math,
    TextureClass;

type

    TSkyPlaneType = record
        x, y, z: single;
        tu, tv: single;
    end;

    TVertexType = record
        position: TXMFLOAT3;
        texture: TXMFLOAT2;
    end;

    { TSkyPlaneClass }

    TSkyPlaneClass = class(TObject)
    private
        m_skyPlane: array of TSkyPlaneType;
        m_vertexCount, m_indexCount: integer;
        m_vertexBuffer, m_indexBuffer: ID3D11Buffer;
        m_CloudTexture1, m_CloudTexture2: TTextureClass;
        m_brightness: single;
        m_translationSpeed: array[0..3] of single;
        m_textureTranslation: array[0..3] of single;
    private
        function InitializeSkyPlane(skyPlaneResolution: integer; skyPlaneWidth, skyPlaneTop, skyPlaneBottom: single;
            textureRepeat: integer): HResult;
        procedure ShutdownSkyPlane();

        function InitializeBuffers(device: ID3D11Device; skyPlaneResolution: integer): HResult;
        procedure ShutdownBuffers();
        procedure RenderBuffers(deviceContext: ID3D11DeviceContext);

        function LoadTextures(device: ID3D11Device; deviceContext: ID3D11DeviceContext; textureFilename1, textureFilename2: WideString): HResult;
        procedure ReleaseTextures();

    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(device: ID3D11Device; deviceContext: ID3D11DeviceContext; textureFilename1, textureFilename2: WideString): HResult;
        procedure Shutdown();
        procedure Render(deviceContext: ID3D11DeviceContext);
        procedure Frame();

        function GetIndexCount(): integer;
        function GetCloudTexture1(): ID3D11ShaderResourceView;
        function GetCloudTexture2(): ID3D11ShaderResourceView;

        function GetBrightness(): single;
        function GetTranslation(index: integer): single;
    end;

implementation

{ TSkyPlaneClass }

function TSkyPlaneClass.InitializeSkyPlane(skyPlaneResolution: integer; skyPlaneWidth, skyPlaneTop, skyPlaneBottom: single;
    textureRepeat: integer): HResult;
var
    quadSize, radius, constant, textureDelta: single;
    i, j, index: integer;
    positionX, positionY, positionZ, tu, tv: single;
begin
    // Create the array to hold the sky plane coordinates.
    SetLength(m_skyPlane, (skyPlaneResolution + 1) * (skyPlaneResolution + 1));


    // Determine the size of each quad on the sky plane.
    quadSize := skyPlaneWidth / skyPlaneResolution;

    // Calculate the radius of the sky plane based on the width.
    radius := skyPlaneWidth / 2.0;

    // Calculate the height constant to increment by.
    constant := (skyPlaneTop - skyPlaneBottom) / (radius * radius);

    // Calculate the texture coordinate increment value.
    textureDelta := textureRepeat / skyPlaneResolution;

    // Loop through the sky plane and build the coordinates based on the increment values given.
    for j := 0 to skyPlaneResolution do
    begin
        for i := 0 to skyPlaneResolution do
        begin
            // Calculate the vertex coordinates.
            positionX := (-0.5 * skyPlaneWidth) + (i * quadSize);
            positionZ := (-0.5 * skyPlaneWidth) + (j * quadSize);
            positionY := skyPlaneTop - (constant * ((positionX * positionX) + (positionZ * positionZ)));

            // Calculate the texture coordinates.
            tu := i * textureDelta;
            tv := j * textureDelta;

            // Calculate the index into the sky plane array to add this coordinate.
            index := j * (skyPlaneResolution + 1) + i;

            // Add the coordinates to the sky plane array.
            m_skyPlane[index].x := positionX;
            m_skyPlane[index].y := positionY;
            m_skyPlane[index].z := positionZ;
            m_skyPlane[index].tu := tu;
            m_skyPlane[index].tv := tv;
        end;
    end;

    Result := S_OK;
end;



procedure TSkyPlaneClass.ShutdownSkyPlane();
begin
    // Release the sky plane array.
    SetLength(m_skyPlane, 0);
end;



function TSkyPlaneClass.InitializeBuffers(device: ID3D11Device; skyPlaneResolution: integer): HResult;
var
    vertices: array of TVertexType;
    indices: array of uint32;
    vertexBufferDesc, indexBufferDesc: TD3D11_BUFFER_DESC;
    vertexData, indexData: TD3D11_SUBRESOURCE_DATA;
    i, j, index, index1, index2, index3, index4: integer;
begin
    // Calculate the number of vertices in the sky plane mesh.
    m_vertexCount := (skyPlaneResolution + 1) * (skyPlaneResolution + 1) * 6;

    // Set the index count to the same as the vertex count.
    m_indexCount := m_vertexCount;

    // Create the vertex array.
    SetLength(vertices, m_vertexCount);

    // Create the index array.
    SetLength(indices, m_indexCount);

    // Initialize the index into the vertex array.
    index := 0;

    // Load the vertex and index array with the sky plane array data.
    for j := 0 to skyPlaneResolution - 1 do
    begin
        for i := 0 to skyPlaneResolution - 1 do
        begin
            index1 := j * (skyPlaneResolution + 1) + i;
            index2 := j * (skyPlaneResolution + 1) + (i + 1);
            index3 := (j + 1) * (skyPlaneResolution + 1) + i;
            index4 := (j + 1) * (skyPlaneResolution + 1) + (i + 1);

            // Triangle 1 - Upper Left
            vertices[index].position := TXMFLOAT3.Create(m_skyPlane[index1].x, m_skyPlane[index1].y, m_skyPlane[index1].z);
            vertices[index].texture := TXMFLOAT2.Create(m_skyPlane[index1].tu, m_skyPlane[index1].tv);
            indices[index] := index;
            Inc(index);

            // Triangle 1 - Upper Right
            vertices[index].position := TXMFLOAT3.Create(m_skyPlane[index2].x, m_skyPlane[index2].y, m_skyPlane[index2].z);
            vertices[index].texture := TXMFLOAT2.Create(m_skyPlane[index2].tu, m_skyPlane[index2].tv);
            indices[index] := index;
            Inc(index);

            // Triangle 1 - Bottom Left
            vertices[index].position := TXMFLOAT3.Create(m_skyPlane[index3].x, m_skyPlane[index3].y, m_skyPlane[index3].z);
            vertices[index].texture := TXMFLOAT2.Create(m_skyPlane[index3].tu, m_skyPlane[index3].tv);
            indices[index] := index;
            Inc(index);

            // Triangle 2 - Bottom Left
            vertices[index].position := TXMFLOAT3.Create(m_skyPlane[index3].x, m_skyPlane[index3].y, m_skyPlane[index3].z);
            vertices[index].texture := TXMFLOAT2.Create(m_skyPlane[index3].tu, m_skyPlane[index3].tv);
            indices[index] := index;
            Inc(index);

            // Triangle 2 - Upper Right
            vertices[index].position := TXMFLOAT3.Create(m_skyPlane[index2].x, m_skyPlane[index2].y, m_skyPlane[index2].z);
            vertices[index].texture := TXMFLOAT2.Create(m_skyPlane[index2].tu, m_skyPlane[index2].tv);
            indices[index] := index;
            Inc(index);

            // Triangle 2 - Bottom Right
            vertices[index].position := TXMFLOAT3.Create(m_skyPlane[index4].x, m_skyPlane[index4].y, m_skyPlane[index4].z);
            vertices[index].texture := TXMFLOAT2.Create(m_skyPlane[index4].tu, m_skyPlane[index4].tv);
            indices[index] := index;
            Inc(index);
        end;
    end;

    // Set up the description of the vertex buffer.
    vertexBufferDesc.Usage := D3D11_USAGE_DEFAULT;
    vertexBufferDesc.ByteWidth := sizeof(TVertexType) * m_vertexCount;
    vertexBufferDesc.BindFlags := Ord(D3D11_BIND_VERTEX_BUFFER);
    vertexBufferDesc.CPUAccessFlags := 0;
    vertexBufferDesc.MiscFlags := 0;
    vertexBufferDesc.StructureByteStride := 0;

    // Give the subresource structure a pointer to the vertex data.
    vertexData.pSysMem := vertices;
    vertexData.SysMemPitch := 0;
    vertexData.SysMemSlicePitch := 0;

    // Now finally create the vertex buffer.
    Result := device.CreateBuffer(vertexBufferDesc, @vertexData, m_vertexBuffer);
    if (Result <> S_OK) then Exit;


    // Set up the description of the index buffer.
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

    // Release the arrays now that the vertex and index buffers have been created and loaded.
    SetLength(vertices, 0);
    SetLength(indices, 0);

end;



procedure TSkyPlaneClass.ShutdownBuffers();
begin
    // Release the index buffer.
    m_indexBuffer := nil;

    // Release the vertex buffer.
    m_vertexBuffer := nil;
end;



procedure TSkyPlaneClass.RenderBuffers(deviceContext: ID3D11DeviceContext);
var
    stride: uint32;
    offset: uint32;
begin
    // Set vertex buffer stride and offset.
    stride := sizeof(TVertexType);
    offset := 0;

    // Set the vertex buffer to active in the input assembler so it can be rendered.
    deviceContext.IASetVertexBuffers(0, 1, @m_vertexBuffer, @stride, @offset);

    // Set the index buffer to active in the input assembler so it can be rendered.
    deviceContext.IASetIndexBuffer(m_indexBuffer, DXGI_FORMAT_R32_UINT, 0);

    // Set the type of primitive that should be rendered from this vertex buffer, in this case triangles.
    deviceContext.IASetPrimitiveTopology(D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
end;



function TSkyPlaneClass.LoadTextures(device: ID3D11Device; deviceContext: ID3D11DeviceContext;
    textureFilename1, textureFilename2: WideString): HResult;
begin
    // Create the first cloud texture object.
    m_CloudTexture1 := TTextureClass.Create;

    // Initialize the first cloud texture object.
    Result := m_CloudTexture1.Initialize(device, deviceContext,textureFilename1);
    if (Result <> S_OK) then Exit;

    // Create the second cloud texture object.
    m_CloudTexture2 := TTextureClass.Create;

    // Initialize the second cloud texture object.
    Result := m_CloudTexture2.Initialize(device,deviceContext, textureFilename2);
end;



procedure TSkyPlaneClass.ReleaseTextures();
begin
    // Release the texture objects.
    if (m_CloudTexture1 <> nil) then
    begin
        m_CloudTexture1.Shutdown();
        m_CloudTexture1.Free;
        m_CloudTexture1 := nil;
    end;

    if (m_CloudTexture2 <> nil) then
    begin
        m_CloudTexture2.Shutdown();
        m_CloudTexture2.Free;
        m_CloudTexture2 := nil;
    end;
end;



constructor TSkyPlaneClass.Create;
begin

end;



destructor TSkyPlaneClass.Destroy;
begin
    inherited Destroy;
end;



function TSkyPlaneClass.Initialize(device: ID3D11Device; deviceContext: ID3D11DeviceContext;
    textureFilename1, textureFilename2: WideString): HResult;
var
    skyPlaneResolution, textureRepeat: integer;
    skyPlaneWidth, skyPlaneTop, skyPlaneBottom: single;
begin
    // Set the sky plane parameters.
    skyPlaneResolution := 10;
    skyPlaneWidth := 10.0;
    skyPlaneTop := 0.5;
    skyPlaneBottom := 0.0;
    textureRepeat := 4;

    // Set the brightness of the clouds.
    m_brightness := 0.65;

    // Setup the cloud translation speed increments.
    m_translationSpeed[0] := 0.0003;   // First texture X translation speed.
    m_translationSpeed[1] := 0.0;      // First texture Z translation speed.
    m_translationSpeed[2] := 0.00015;  // Second texture X translation speed.
    m_translationSpeed[3] := 0.0;      // Second texture Z translation speed.

    // Initialize the texture translation values.
    m_textureTranslation[0] := 0.0;
    m_textureTranslation[1] := 0.0;
    m_textureTranslation[2] := 0.0;
    m_textureTranslation[3] := 0.0;

    // Create the sky plane.
    Result := InitializeSkyPlane(skyPlaneResolution, skyPlaneWidth, skyPlaneTop, skyPlaneBottom, textureRepeat);
    if (Result <> S_OK) then Exit;


    // Create the vertex and index buffer for the sky plane.
    Result := InitializeBuffers(device, skyPlaneResolution);
    if (Result <> S_OK) then Exit;

    // Load the sky plane textures.
    Result := LoadTextures(device, deviceContext, textureFilename1, textureFilename2);
end;



procedure TSkyPlaneClass.Shutdown();
begin
    // Release the sky plane textures.
    ReleaseTextures();

    // Release the vertex and index buffer that were used for rendering the sky plane.
    ShutdownBuffers();

    // Release the sky plane array.
    ShutdownSkyPlane();
end;



procedure TSkyPlaneClass.Render(deviceContext: ID3D11DeviceContext);
begin
    // Render the sky plane.
    RenderBuffers(deviceContext);
end;



procedure TSkyPlaneClass.Frame();
begin
    // Increment the translation values to simulate the moving clouds.
    m_textureTranslation[0] := m_textureTranslation[0] + m_translationSpeed[0];
    m_textureTranslation[1] := m_textureTranslation[1] + m_translationSpeed[1];
    m_textureTranslation[2] := m_textureTranslation[2] + m_translationSpeed[2];
    m_textureTranslation[3] := m_textureTranslation[3] + m_translationSpeed[3];

    // Keep the values in the zero to one range.
    if (m_textureTranslation[0] > 1.0) then
        m_textureTranslation[0] := m_textureTranslation[0] - 1.0;

    if (m_textureTranslation[1] > 1.0) then
        m_textureTranslation[1] := m_textureTranslation[1] - 1.0;

    if (m_textureTranslation[2] > 1.0) then
        m_textureTranslation[2] := m_textureTranslation[2] - 1.0;

    if (m_textureTranslation[3] > 1.0) then
        m_textureTranslation[3] := m_textureTranslation[3] - 1.0;

end;



function TSkyPlaneClass.GetIndexCount(): integer;
begin
    Result := m_indexCount;
end;



function TSkyPlaneClass.GetCloudTexture1(): ID3D11ShaderResourceView;
begin
    Result := m_CloudTexture1.GetTexture();
end;



function TSkyPlaneClass.GetCloudTexture2(): ID3D11ShaderResourceView;
begin
    Result := m_CloudTexture2.GetTexture();
end;



function TSkyPlaneClass.GetBrightness(): single;
begin
    Result := m_brightness;
end;



function TSkyPlaneClass.GetTranslation(index: integer): single;
begin
    Result := m_textureTranslation[index];
end;

end.
