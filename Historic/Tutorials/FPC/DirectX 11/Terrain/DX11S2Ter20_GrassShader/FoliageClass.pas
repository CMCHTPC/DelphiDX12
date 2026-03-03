unit FoliageClass;

{$mode Delphi}

interface

uses
    Classes, SysUtils, Windows,
    TextureClass,
    DX12.D3D11,
    DX12.D3D10,
    DX12.D3DCommon,
    DX12.DXGI,
    DirectX.Math;

type
    TVertexType = record
        position: TXMFLOAT3;
        texture: TXMFLOAT2;
    end;

    TFoliageType = record
        x, z: single;
        r, g, b: single;
    end;

    TInstanceType = record
        matrix: TXMMATRIX;
        color: TXMFLOAT3;
    end;

    { TFoliageClass }

    TFoliageClass = class(TObject)
    private
        m_foliageCount: integer;
        m_foliageArray: array of TFoliageType;
        m_Instances: array of TInstanceType;
        m_vertexBuffer, m_instanceBuffer: ID3D11Buffer;
        m_vertexCount, m_instanceCount: integer;
        m_Texture: TTextureClass;
        m_windRotation: single;
        m_windDirection: integer;
    private
        function InitializeBuffers(device: ID3D11Device): HResult;
        procedure ShutdownBuffers();
        procedure RenderBuffers(deviceContext: ID3D11DeviceContext);

        function LoadTexture(device: ID3D11Device; deviceContext: ID3D11DeviceContext; filename: WideString): HResult;
        procedure ReleaseTexture();

        function GeneratePositions(): HResult;
    public
        constructor Create;
        destructor Destroy; override;
        function Initialize(device: ID3D11Device;deviceContext: ID3D11DeviceContext; textureFilename: WideString; fCount: integer): HResult;
        procedure Shutdown();
        procedure Render(deviceContext: ID3D11DeviceContext);
        function Frame(CameraPosition: TXMFLOAT3; deviceContext: ID3D11DeviceContext): HResult;
        function GetVertexCount(): integer;
        function GetInstanceCount(): integer;
        function GetTexture(): ID3D11ShaderResourceView;
    end;

implementation

uses
    Math;

{ TFoliageClass }

function TFoliageClass.InitializeBuffers(device: ID3D11Device): HResult;
var
    vertices: array of TVertexType;
    vertexBufferDesc, instanceBufferDesc: TD3D11_BUFFER_DESC;
    vertexData, instanceData: TD3D11_SUBRESOURCE_DATA;
    i: integer;
    matrix: TXMMATRIX;
begin
    // Set the number of vertices in the vertex array.
    m_vertexCount := 6;

    // Create the vertex array.
    SetLength(vertices, m_vertexCount);

    // Load the vertex array with data.
    vertices[0].position := TXMFLOAT3.Create(0.0, 0.0, 0.0);  // Bottom left.
    vertices[0].texture := TXMFLOAT2.Create(0.0, 1.0);

    vertices[1].position := TXMFLOAT3.Create(0.0, 1.0, 0.0);  // Top left.
    vertices[1].texture := TXMFLOAT2.Create(0.0, 0.0);

    vertices[2].position := TXMFLOAT3.Create(1.0, 0.0, 0.0);  // Bottom right.
    vertices[2].texture := TXMFLOAT2.Create(1.0, 1.0);

    vertices[3].position := TXMFLOAT3.Create(1.0, 0.0, 0.0);  // Bottom right.
    vertices[3].texture := TXMFLOAT2.Create(1.0, 1.0);

    vertices[4].position := TXMFLOAT3.Create(0.0, 1.0, 0.0);  // Top left.
    vertices[4].texture := TXMFLOAT2.Create(0.0, 0.0);

    vertices[5].position := TXMFLOAT3.Create(1.0, 1.0, 0.0);  // Top right.
    vertices[5].texture := TXMFLOAT2.Create(1.0, 0.0);

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

    // Release the array now that the vertex buffer has been created and loaded.
    SetLength(vertices, 0);

    // Set the number of instances in the array.
    m_instanceCount := m_foliageCount;

    // Create the instance array.
    SetLength(m_Instances, m_instanceCount);

    // Setup an initial matrix.
    matrix := XMMatrixIdentity();

    // Load the instance array with data.
    for i := 0 to m_instanceCount - 1 do
    begin
        m_Instances[i].matrix := matrix;
        m_Instances[i].color := TXMFLOAT3.Create(m_foliageArray[i].r, m_foliageArray[i].g, m_foliageArray[i].b);
    end;

    // Set up the description of the instance buffer.
    instanceBufferDesc.Usage := D3D11_USAGE_DYNAMIC;
    instanceBufferDesc.ByteWidth := sizeof(TInstanceType) * m_instanceCount;
    instanceBufferDesc.BindFlags := Ord(D3D11_BIND_VERTEX_BUFFER);
    instanceBufferDesc.CPUAccessFlags := Ord(D3D11_CPU_ACCESS_WRITE);
    instanceBufferDesc.MiscFlags := 0;
    instanceBufferDesc.StructureByteStride := 0;

    // Give the subresource structure a pointer to the instance data.
    instanceData.pSysMem := m_Instances;
    instanceData.SysMemPitch := 0;
    instanceData.SysMemSlicePitch := 0;

    // Create the instance buffer.
    Result := device.CreateBuffer(instanceBufferDesc, @instanceData, m_instanceBuffer);
end;



procedure TFoliageClass.ShutdownBuffers();
begin
    // Release the instance buffer.
    m_instanceBuffer := nil;

    // Release the vertex buffer.
    m_vertexBuffer := nil;

    // Release the instance array.
    SetLength(m_Instances, 0);
end;



procedure TFoliageClass.RenderBuffers(deviceContext: ID3D11DeviceContext);
var
    strides: array [0..1] of uint32;
    offsets: array [0..1] of uint32;
    bufferPointers: array [0..1] of ID3D11Buffer;
begin

    // Set the buffer strides.
    strides[0] := sizeof(TVertexType);
    strides[1] := sizeof(TInstanceType);

    // Set the buffer offsets.
    offsets[0] := 0;
    offsets[1] := 0;

    // Set the array of pointers to the vertex and instance buffers.
    bufferPointers[0] := m_vertexBuffer;
    bufferPointers[1] := m_instanceBuffer;

    // Set the vertex and instance buffers to active in the input assembler so it can be rendered.
    deviceContext.IASetVertexBuffers(0, 2, @bufferPointers[0], @strides[0], @offsets[0]);

    // Set the type of primitive that should be rendered from this vertex buffer, in this case triangles.
    deviceContext.IASetPrimitiveTopology(D3D10_PRIMITIVE_TOPOLOGY_TRIANGLELIST);

end;



function TFoliageClass.LoadTexture(device: ID3D11Device;
				    deviceContext: ID3D11DeviceContext; filename: WideString): HResult;
begin
    // Create the texture object.
    m_Texture := TTextureClass.Create;
    // Initialize the texture object.
    Result := m_Texture.Initialize(device,deviceContext, filename);
end;



procedure TFoliageClass.ReleaseTexture();
begin
    // Release the texture object.
    if (m_Texture <> nil) then
    begin
        m_Texture.Shutdown();
        m_Texture.Free;
        m_Texture := nil;
    end;
end;



function TFoliageClass.GeneratePositions(): HResult;
var
    i: integer;
    red, green: single;
begin

    // Create an array to store all the foliage information.
    SetLength(m_foliageArray, m_foliageCount);
    // Seed the random generator.

    // Set random positions and random colors for each piece of foliage.
    for i := 0 to m_foliageCount - 1 do
    begin
        m_foliageArray[i].x := Random * 9.0 - 4.5;
        m_foliageArray[i].z := Random * 9.0 - 4.5;

        red := Random * 1.0;
        green := Random * 1.0;

        m_foliageArray[i].r := red + 1.0;
        m_foliageArray[i].g := green + 0.5;
        m_foliageArray[i].b := 0.0;
    end;

    Result := S_OK;
end;



constructor TFoliageClass.Create;
begin

end;



destructor TFoliageClass.Destroy;
begin
    inherited Destroy;
end;



function TFoliageClass.Initialize(device: ID3D11Device;
				    deviceContext: ID3D11DeviceContext; textureFilename: WideString;
				    fCount: integer): HResult;
begin
    // Set the foliage count.
    m_foliageCount := fCount;

    // Generate the positions of the foliage.
    Result := GeneratePositions();
    if (Result <> S_OK) then Exit;

    // Initialize the vertex and instance buffer that hold the geometry for the foliage model.
    Result := InitializeBuffers(device);
    if (Result <> S_OK) then Exit;

    // Load the texture for this model.
    Result := LoadTexture(device, deviceContext,textureFilename);
    if (Result <> S_OK) then Exit;

    // Set the initial wind rotation and direction.
    m_windRotation := 0.0;
    m_windDirection := 1;

    Result := S_OK;
end;



procedure TFoliageClass.Shutdown();
begin
    // Release the model texture.
    ReleaseTexture();

    // Release the vertex and instance buffers.
    ShutdownBuffers();

    // Release the foliage array.
    SetLength(m_foliageArray, 0);
end;



procedure TFoliageClass.Render(deviceContext: ID3D11DeviceContext);
begin
    // Put the vertex and instance buffers on the graphics pipeline to prepare them for drawing.
    RenderBuffers(deviceContext);
end;



function TFoliageClass.Frame(CameraPosition: TXMFLOAT3; deviceContext: ID3D11DeviceContext): HResult;
var
    rotateMatrix, translationMatrix, rotateMatrix2, finalMatrix: TXMMATRIX;
    modelPosition: TXMFLOAT3;
    i: integer;
    angle: double;
    rotation, windRotation: single;
    mappedResource: TD3D11_MAPPED_SUBRESOURCE;
    instancesPtr: ^TInstanceType;
begin

    // Update the wind rotation.
    if (m_windDirection = 1) then
    begin
        m_windRotation := m_windRotation + 0.1;
        if (m_windRotation > 10.0) then
        begin
            m_windDirection := 2;
        end;
    end
    else
    begin
        m_windRotation := m_windRotation - 0.1;
        if (m_windRotation < -10.0) then
        begin
            m_windDirection := 1;
        end;
    end;

    // Load the instance buffer with the updated locations.
    for i := 0 to m_foliageCount - 1 do
    begin
        // Get the position of this piece of foliage.
        modelPosition.x := m_foliageArray[i].x;
        modelPosition.y := -0.1;
        modelPosition.z := m_foliageArray[i].z;

        // Calculate the rotation that needs to be applied to the billboard model to face the current camera position using the arc tangent function.
        angle := arctan2(modelPosition.x - cameraPosition.x, modelPosition.z - cameraPosition.z) * (180.0 / XM_PI);

        // Convert rotation into radians.
        rotation := angle * 0.0174532925;

        // Setup the X rotation of the billboard.
        rotateMatrix := XMMatrixRotationY(rotation);

        // Get the wind rotation for the foliage.
        windRotation := m_windRotation * 0.0174532925;

        // Setup the wind rotation.
        rotateMatrix2 := XMMatrixRotationY(windRotation);

        // Setup the translation matrix.
        translationMatrix := XMMatrixTranslation(modelPosition.x, modelPosition.y, modelPosition.z);

        // Create the final matrix and store it in the instances array.
        finalMatrix := XMMatrixMultiply(rotateMatrix, rotateMatrix2);
        m_Instances[i].matrix := XMMatrixMultiply(finalMatrix, translationMatrix);

    end;

    // Lock the instance buffer so it can be written to.
    Result := deviceContext.Map(m_instanceBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);
    if (Result <> S_OK) then Exit;

    // Get a pointer to the data in the instance buffer.
    instancesPtr := mappedResource.pData;

    // Copy the instances array into the instance buffer.
    Move(m_Instances[0], instancesPtr^, sizeof(TInstanceType) * m_foliageCount);

    // Unlock the instance buffer.
    deviceContext.Unmap(m_instanceBuffer, 0);

    Result := S_OK;
end;



function TFoliageClass.GetVertexCount(): integer;
begin
    Result := m_vertexCount;
end;



function TFoliageClass.GetInstanceCount(): integer;
begin
    Result := m_instanceCount;
end;



function TFoliageClass.GetTexture(): ID3D11ShaderResourceView;
begin
    Result := m_Texture.GetTexture();
end;

end.
