unit TerrainClass;

interface

uses
    Classes, SysUtils, Windows,
    DX12.D3D11,
    DirectX.Math;

type
    TVertexType = record
        position: TXMFLOAT3;
        color: TXMFLOAT4;
    end;

    TTerrainClass = class(TObject)
    private
        m_vertexBuffer, m_indexBuffer: ID3D11Buffer;
        m_vertexCount, m_indexCount: int32;
    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(device: ID3D11Device): HResult;
        procedure Shutdown();
        function Render(deviceContext: ID3D11DeviceContext): HResult;
        function GetIndexCount(): int32;
    private
        function InitializeBuffers(device: ID3D11Device): HResult;
        procedure ShutdownBuffers();
        procedure RenderBuffers(deviceContext: ID3D11DeviceContext);
    end;


implementation

uses
    DX12.DXGI,
    DX12.D3DCommon;



constructor TTerrainClass.Create;
begin
end;



destructor TTerrainClass.Destroy;
begin
    inherited;
end;



function TTerrainClass.Initialize(device: ID3D11Device): HResult;
begin

    // Load the rendering buffers with the terrain data.
    Result := InitializeBuffers(device);

end;



procedure TTerrainClass.Shutdown();
begin
    // Release the rendering buffers.
    ShutdownBuffers();
end;



function TTerrainClass.Render(deviceContext: ID3D11DeviceContext): HResult;
begin
    // Put the vertex and index buffers on the graphics pipeline to prepare them for drawing.
    RenderBuffers(deviceContext);
    Result := S_OK;
end;



function TTerrainClass.GetIndexCount(): int32;
begin
    Result := m_indexCount;
end;



function TTerrainClass.InitializeBuffers(device: ID3D11Device): HResult;
var
    vertices: array of TVertexType;
    indices: array of ULONG;
    vertexBufferDesc, indexBufferDesc: TD3D11_BUFFER_DESC;
    vertexData, indexData: TD3D11_SUBRESOURCE_DATA;

    i, j, terrainWidth, terrainHeight, index: integer;
    color: TXMFLOAT4;
    positionX, positionZ: single;
begin

    // Set the height and width of the terrain grid.
    terrainHeight := 256;
    terrainWidth := 256;

    // Set the color of the terrain grid.
    color := TXMFLOAT4.Create(1.0, 1.0, 1.0, 1.0);

    // Calculate the number of vertices in the terrain.
    m_vertexCount := (terrainWidth - 1) * (terrainHeight - 1) * 8;

    // Set the index count to the same as the vertex count.
    m_indexCount := m_vertexCount;

    // Create the vertex array.
    SetLength(vertices, m_vertexCount);

    // Create the index array.
    SetLength(indices, m_indexCount);

    // Initialize the index into the vertex and index arrays.
    index := 0;

    // Load the vertex array and index array with data.
    for j := 0 to terrainHeight - 2 do
    begin
        for i := 0 to terrainWidth - 2 do
        begin
            // Line 1 - Upper left.
            positionX := i;
            positionZ := (j + 1);

            vertices[index].position := TXMFLOAT3.Create(positionX, 0.0, positionZ);
            vertices[index].color := color;
            indices[index] := index;
            Inc(index);

            // Line 1 - Upper right.
            positionX := (i + 1);
            positionZ := (j + 1);

            vertices[index].position := TXMFLOAT3.Create(positionX, 0.0, positionZ);
            vertices[index].color := color;
            indices[index] := index;
            Inc(index);

            // Line 2 - Upper right
            positionX := (i + 1);
            positionZ := (j + 1);

            vertices[index].position := TXMFLOAT3.Create(positionX, 0.0, positionZ);
            vertices[index].color := color;
            indices[index] := index;
            Inc(index);

            // Line 2 - Bottom right.
            positionX := (i + 1);
            positionZ := j;

            vertices[index].position := TXMFLOAT3.Create(positionX, 0.0, positionZ);
            vertices[index].color := color;
            indices[index] := index;
            Inc(index);

            // Line 3 - Bottom right.
            positionX := (i + 1);
            positionZ := j;

            vertices[index].position := TXMFLOAT3.Create(positionX, 0.0, positionZ);
            vertices[index].color := color;
            indices[index] := index;
            Inc(index);

            // Line 3 - Bottom left.
            positionX := i;
            positionZ := j;

            vertices[index].position := TXMFLOAT3.Create(positionX, 0.0, positionZ);
            vertices[index].color := color;
            indices[index] := index;
            Inc(index);

            // Line 4 - Bottom left.
            positionX := i;
            positionZ := j;

            vertices[index].position := TXMFLOAT3.Create(positionX, 0.0, positionZ);
            vertices[index].color := color;
            indices[index] := index;
            Inc(index);

            // Line 4 - Upper left.
            positionX := i;
            positionZ := (j + 1);

            vertices[index].position := TXMFLOAT3.Create(positionX, 0.0, positionZ);
            vertices[index].color := color;
            indices[index] := index;
            Inc(index);
        end;
    end;

    // Set up the description of the static vertex buffer.
    vertexBufferDesc.Usage := D3D11_USAGE_DEFAULT;
    vertexBufferDesc.ByteWidth := sizeof(TVertexType) * m_vertexCount;
    vertexBufferDesc.BindFlags := ord(D3D11_BIND_VERTEX_BUFFER);
    vertexBufferDesc.CPUAccessFlags := 0;
    vertexBufferDesc.MiscFlags := 0;
    vertexBufferDesc.StructureByteStride := 0;

    // Give the subresource structure a pointer to the vertex data.
    vertexData.pSysMem := @vertices[0];
    vertexData.SysMemPitch := 0;
    vertexData.SysMemSlicePitch := 0;

    // Now create the vertex buffer.
    result := device.CreateBuffer(vertexBufferDesc, @vertexData, m_vertexBuffer);
    if (result <> S_OK) then
        Exit;

    // Set up the description of the static index buffer.
    indexBufferDesc.Usage := D3D11_USAGE_DEFAULT;
    indexBufferDesc.ByteWidth := sizeof(ULONG) * m_indexCount;
    indexBufferDesc.BindFlags := ord(D3D11_BIND_INDEX_BUFFER);
    indexBufferDesc.CPUAccessFlags := 0;
    indexBufferDesc.MiscFlags := 0;
    indexBufferDesc.StructureByteStride := 0;

    // Give the subresource structure a pointer to the index data.
    indexData.pSysMem := @indices[0];
    indexData.SysMemPitch := 0;
    indexData.SysMemSlicePitch := 0;

    // Create the index buffer.
    result := device.CreateBuffer(indexBufferDesc, @indexData, m_indexBuffer);
    if (result <> S_OK) then
		Exit;

    // Release the arrays now that the buffers have been created and loaded.
    SetLength(vertices, 0);
    SetLength(indices, 0);
end;



procedure TTerrainClass.ShutdownBuffers();
begin
    // Release the index buffer.
    m_indexBuffer := nil;

    // Release the vertex buffer.
    m_vertexBuffer := nil;
end;



procedure TTerrainClass.RenderBuffers(deviceContext: ID3D11DeviceContext);
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

    // Set the type of primitive that should be rendered from this vertex buffer, in this case lines.
    deviceContext.IASetPrimitiveTopology(D3D11_PRIMITIVE_TOPOLOGY_LINELIST);
end;


end.
