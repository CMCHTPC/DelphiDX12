unit TerrainCellClass;

{$mode Delphi}

interface

uses
    Classes, SysUtils, Windows,
    DX12.D3D11,
    DX12.D3DCommon,
    DX12.DXGI,
    DirectX.Math;

type

    TModelType = record
        x, y, z: single;
        tu, tv: single;
        nx, ny, nz: single;
        tx, ty, tz: single;
        bx, by, bz: single;
        r, g, b: single;
        tu2, tv2: single;
    end;
    PModelType = ^TModelType;

    TVertexType = record
        position: TXMFLOAT3;
        texture: TXMFLOAT2;
        normal: TXMFLOAT3;
        tangent: TXMFLOAT3;
        binormal: TXMFLOAT3;
        color: TXMFLOAT3;
         texture2:TXMFLOAT2;
    end;

    TVectorType = record
        x, y, z: single;
    end;

    TColorVertexType = record
        position: TXMFLOAT3;
        color: TXMFLOAT4;
    end;

    { TTerrainCellClass }

    TTerrainCellClass = class(TObject)
    private
        m_vertexCount, m_indexCount, m_lineIndexCount: integer;
        m_vertexBuffer, m_indexBuffer, m_lineVertexBuffer, m_lineIndexBuffer: ID3D11Buffer;
        m_maxWidth, m_maxHeight, m_maxDepth, m_minWidth, m_minHeight, m_minDepth: single;
        m_positionX, m_positionY, m_positionZ: single;
    private
        function InitializeBuffers(device: ID3D11Device; nodeIndexX, nodeIndexY, cellHeight, cellWidth, terrainWidth: integer;
            terrainModelPtr: PModelType): HResult;
        procedure ShutdownBuffers();
        procedure RenderBuffers(deviceContext: ID3D11DeviceContext);

        procedure CalculateCellDimensions();
        function BuildLineBuffers(device: ID3D11Device): HResult;
        procedure ShutdownLineBuffers();
    public
        m_vertexList: array of TVectorType;
    public
        constructor Create;
        destructor Destroy; override;
        function Initialize(device: ID3D11Device; terrainModelPtr: PModelType;
            nodeIndexX, nodeIndexY, cellHeight, cellWidth, terrainWidth: integer): HResult;
        procedure Shutdown();
        function Render(deviceContext: ID3D11DeviceContext): HResult;
        procedure RenderLineBuffers(deviceContext: ID3D11DeviceContext);
        function GetIndexCount(): int32;
        function GetVertexCount(): int32;
        function GetLineBuffersIndexCount(): int32;
        procedure GetCellDimensions(out maxWidth, maxHeight, maxDepth, minWidth, minHeight, minDepth: single);
    end;

implementation

{ TTerrainCellClass }

function TTerrainCellClass.InitializeBuffers(device: ID3D11Device; nodeIndexX, nodeIndexY, cellHeight, cellWidth, terrainWidth: integer;
    terrainModelPtr: PModelType): HResult;
var
    vertices: array of TVertexType;
    indices: array of uint32;
    i, j, modelIndex, index: integer;
    vertexBufferDesc, indexBufferDesc: TD3D11_BUFFER_DESC;
    vertexData, indexData: TD3D11_SUBRESOURCE_DATA;
    terrainModel: array of TModelType absolute terrainModelPtr;
begin

    // Calculate the number of vertices in this terrain cell.
    m_vertexCount := (cellHeight - 1) * (cellWidth - 1) * 6;

    // Set the index count to the same as the vertex count.
    m_indexCount := m_vertexCount;

    // Create the vertex array.
    SetLength(vertices, m_vertexCount);

    // Create the index array.
    SetLength(indices, m_indexCount);

    // Setup the indexes into the terrain model data and the local vertex/index array.
    modelIndex := ((nodeIndexX * (cellWidth - 1)) + (nodeIndexY * (cellHeight - 1) * (terrainWidth - 1))) * 6;
    index := 0;

    // Load the vertex array and index array with data.
    for j := 0 to cellHeight - 2 do
    begin
        for i := 0 to ((cellWidth - 1) * 6) - 1 do
        begin
            vertices[index].position := TXMFLOAT3.Create(terrainModel[modelIndex].x, terrainModel[modelIndex].y, terrainModel[modelIndex].z);
            vertices[index].texture := TXMFLOAT2.Create(terrainModel[modelIndex].tu, terrainModel[modelIndex].tv);
            vertices[index].normal := TXMFLOAT3.Create(terrainModel[modelIndex].nx, terrainModel[modelIndex].ny, terrainModel[modelIndex].nz);
            vertices[index].tangent := TXMFLOAT3.Create(terrainModel[modelIndex].tx, terrainModel[modelIndex].ty, terrainModel[modelIndex].tz);
            vertices[index].binormal := TXMFLOAT3.Create(terrainModel[modelIndex].bx, terrainModel[modelIndex].by, terrainModel[modelIndex].bz);
            vertices[index].color := TXMFLOAT3.Create(terrainModel[modelIndex].r, terrainModel[modelIndex].g, terrainModel[modelIndex].b);
            vertices[index].texture2 := TXMFLOAT2.Create(terrainModel[modelIndex].tu2, terrainModel[modelIndex].tv2);
            indices[index] := index;
            Inc(modelIndex);
            Inc(index);
        end;
        modelIndex := modelIndex + (terrainWidth * 6) - (cellWidth * 6);
    end;

    // Set up the description of the static vertex buffer.
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

    // Now create the vertex buffer.
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

    // Create a public vertex array that will be used for accessing vertex information about this cell.
    SetLength(m_vertexList, m_vertexCount);

    // Keep a local copy of the vertex position data for this cell.
    for i := 0 to m_vertexCount - 1 do
    begin
        m_vertexList[i].x := vertices[i].position.x;
        m_vertexList[i].y := vertices[i].position.y;
        m_vertexList[i].z := vertices[i].position.z;
    end;

    // Release the arrays now that the buffers have been created and loaded.

    SetLength(vertices, 0);
    SetLength(indices, 0);

    Result := S_OK;
end;



procedure TTerrainCellClass.ShutdownBuffers();
begin
    // Release the public vertex list.
    SetLength(m_vertexList, 0);

    // Release the index buffer.
    m_indexBuffer := nil;

    // Release the vertex buffer.
    m_vertexBuffer := nil;
end;



procedure TTerrainCellClass.RenderBuffers(deviceContext: ID3D11DeviceContext);
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



procedure TTerrainCellClass.CalculateCellDimensions();
var
    i: integer;
    Width, Height, depth: single;
begin

    // Initialize the dimensions of the node.
    m_maxWidth := -1000000.0;
    m_maxHeight := -1000000.0;
    m_maxDepth := -1000000.0;

    m_minWidth := 1000000.0;
    m_minHeight := 1000000.0;
    m_minDepth := 1000000.0;

    for i := 0 to m_vertexCount - 1 do
    begin
        Width := m_vertexList[i].x;
        Height := m_vertexList[i].y;
        depth := m_vertexList[i].z;

        // Check if the width exceeds the minimum or maximum.
        if (Width > m_maxWidth) then
        begin
            m_maxWidth := Width;
        end;
        if (Width < m_minWidth) then
        begin
            m_minWidth := Width;
        end;

        // Check if the height exceeds the minimum or maximum.
        if (Height > m_maxHeight) then
        begin
            m_maxHeight := Height;
        end;
        if (Height < m_minHeight) then
        begin
            m_minHeight := Height;
        end;

        // Check if the depth exceeds the minimum or maximum.
        if (depth > m_maxDepth) then
        begin
            m_maxDepth := depth;
        end;
        if (depth < m_minDepth) then
        begin
            m_minDepth := depth;
        end;
    end;

    // Calculate the center position of this cell.
    m_positionX := (m_maxWidth - m_minWidth) + m_minWidth;
    m_positionY := (m_maxHeight - m_minHeight) + m_minHeight;
    m_positionZ := (m_maxDepth - m_minDepth) + m_minDepth;
end;



function TTerrainCellClass.BuildLineBuffers(device: ID3D11Device): HResult;
var
    vertices: array of TColorVertexType;
    indices: array of uint32;
    vertexBufferDesc, indexBufferDesc: TD3D11_BUFFER_DESC;
    vertexData, indexData: TD3D11_SUBRESOURCE_DATA;

    lineColor: TXMFLOAT4;
    index, vertexCount, indexCount: integer;
begin

    // Set the color of the lines to orange.
    lineColor := TXMFLOAT4.Create(1.0, 0.5, 0.0, 1.0);

    // Set the number of vertices in the vertex array.
    vertexCount := 24;

    // Set the number of indices in the index array.
    indexCount := vertexCount;

    // Create the vertex array.
    SetLength(vertices, vertexCount);

    // Create the index array.
    SetLength(indices, indexCount);

    // Set up the description of the vertex buffer.
    vertexBufferDesc.Usage := D3D11_USAGE_DEFAULT;
    vertexBufferDesc.ByteWidth := sizeof(TColorVertexType) * vertexCount;
    vertexBufferDesc.BindFlags := ord(D3D11_BIND_VERTEX_BUFFER);
    vertexBufferDesc.CPUAccessFlags := 0;
    vertexBufferDesc.MiscFlags := 0;
    vertexBufferDesc.StructureByteStride := 0;

    // Give the subresource structure a pointer to the vertex data.
    vertexData.pSysMem := vertices;
    vertexData.SysMemPitch := 0;
    vertexData.SysMemSlicePitch := 0;

    // Set up the description of the index buffer.
    indexBufferDesc.Usage := D3D11_USAGE_DEFAULT;
    indexBufferDesc.ByteWidth := sizeof(uint32) * indexCount;
    indexBufferDesc.BindFlags := ord(D3D11_BIND_INDEX_BUFFER);
    indexBufferDesc.CPUAccessFlags := 0;
    indexBufferDesc.MiscFlags := 0;
    indexBufferDesc.StructureByteStride := 0;

    // Give the subresource structure a pointer to the index data.
    indexData.pSysMem := indices;
    indexData.SysMemPitch := 0;
    indexData.SysMemSlicePitch := 0;

    // Load the vertex and index array with data.
    index := 0;

    // 8 Horizontal lines.
    vertices[index].position := TXMFLOAT3.Create(m_minWidth, m_minHeight, m_minDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    vertices[index].position := TXMFLOAT3.Create(m_maxWidth, m_minHeight, m_minDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    vertices[index].position := TXMFLOAT3.Create(m_minWidth, m_minHeight, m_maxDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    vertices[index].position := TXMFLOAT3.Create(m_maxWidth, m_minHeight, m_maxDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    vertices[index].position := TXMFLOAT3.Create(m_minWidth, m_minHeight, m_minDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    vertices[index].position := TXMFLOAT3.Create(m_minWidth, m_minHeight, m_maxDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    vertices[index].position := TXMFLOAT3.Create(m_maxWidth, m_minHeight, m_minDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    vertices[index].position := TXMFLOAT3.Create(m_maxWidth, m_minHeight, m_maxDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    vertices[index].position := TXMFLOAT3.Create(m_minWidth, m_maxHeight, m_minDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    vertices[index].position := TXMFLOAT3.Create(m_maxWidth, m_maxHeight, m_minDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    vertices[index].position := TXMFLOAT3.Create(m_minWidth, m_maxHeight, m_maxDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    vertices[index].position := TXMFLOAT3.Create(m_maxWidth, m_maxHeight, m_maxDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    vertices[index].position := TXMFLOAT3.Create(m_minWidth, m_maxHeight, m_minDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    vertices[index].position := TXMFLOAT3.Create(m_minWidth, m_maxHeight, m_maxDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    vertices[index].position := TXMFLOAT3.Create(m_maxWidth, m_maxHeight, m_minDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    vertices[index].position := TXMFLOAT3.Create(m_maxWidth, m_maxHeight, m_maxDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    // 4 Verticle lines.
    vertices[index].position := TXMFLOAT3.Create(m_maxWidth, m_maxHeight, m_maxDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    vertices[index].position := TXMFLOAT3.Create(m_maxWidth, m_minHeight, m_maxDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    vertices[index].position := TXMFLOAT3.Create(m_minWidth, m_maxHeight, m_maxDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    vertices[index].position := TXMFLOAT3.Create(m_minWidth, m_minHeight, m_maxDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    vertices[index].position := TXMFLOAT3.Create(m_maxWidth, m_maxHeight, m_minDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    vertices[index].position := TXMFLOAT3.Create(m_maxWidth, m_minHeight, m_minDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    vertices[index].position := TXMFLOAT3.Create(m_minWidth, m_maxHeight, m_minDepth);
    vertices[index].color := lineColor;
    indices[index] := index;
    Inc(index);

    vertices[index].position := TXMFLOAT3.Create(m_minWidth, m_minHeight, m_minDepth);
    vertices[index].color := lineColor;
    indices[index] := index;

    // Create the vertex buffer.
    Result := device.CreateBuffer(vertexBufferDesc, @vertexData, m_lineVertexBuffer);
    if (Result <> S_OK) then Exit;

    // Create the index buffer.
    Result := device.CreateBuffer(indexBufferDesc, @indexData, m_lineIndexBuffer);
    if (Result <> S_OK) then Exit;

    // Store the index count for rendering.
    m_lineIndexCount := indexCount;

    // Release the arrays now that the vertex and index buffers have been created and loaded.
    SetLength(vertices, 0);
    SetLength(indices, 0);

    Result := S_OK;
end;



procedure TTerrainCellClass.ShutdownLineBuffers();
begin
    // Release the index buffer.
    m_lineIndexBuffer:=nil;

    // Release the vertex buffer.
    m_lineVertexBuffer:=nil;
end;



constructor TTerrainCellClass.Create;
begin

end;



destructor TTerrainCellClass.Destroy;
begin
    inherited Destroy;
end;



function TTerrainCellClass.Initialize(device: ID3D11Device; terrainModelPtr: PModelType;
    nodeIndexX, nodeIndexY, cellHeight, cellWidth, terrainWidth: integer): HResult;

var
    terrainModel: array of TModelType absolute terrainModelPtr;
begin
    // Coerce the pointer to the terrain model into the model type.
//    terrainModel = (ModelType*)terrainModelPtr;
    // Load the rendering buffers with the terrain data for this cell index.
    Result := InitializeBuffers(device, nodeIndexX, nodeIndexY, cellHeight, cellWidth, terrainWidth, terrainModelPtr);
    if (Result <> S_OK) then Exit;

    // Calculuate the dimensions of this cell.
    CalculateCellDimensions();

    // Build the debug line buffers to produce the bounding box around this cell.
    Result := BuildLineBuffers(device);
end;



procedure TTerrainCellClass.Shutdown();
begin
    // Release the line rendering buffers.
    ShutdownLineBuffers();

    // Release the cell rendering buffers.
    ShutdownBuffers();
end;



function TTerrainCellClass.Render(deviceContext: ID3D11DeviceContext): HResult;
begin
    // Put the vertex and index buffers on the graphics pipeline to prepare them for drawing.
    RenderBuffers(deviceContext);
end;



procedure TTerrainCellClass.RenderLineBuffers(deviceContext: ID3D11DeviceContext);
var
    stride: uint32;
    offset: uint32;
begin

    // Set vertex buffer stride and offset.
    stride := sizeof(TColorVertexType);
    offset := 0;

    // Set the vertex buffer to active in the input assembler so it can be rendered.
    deviceContext.IASetVertexBuffers(0, 1, @m_lineVertexBuffer, @stride, @offset);

    // Set the index buffer to active in the input assembler so it can be rendered.
    deviceContext.IASetIndexBuffer(m_lineIndexBuffer, DXGI_FORMAT_R32_UINT, 0);

    // Set the type of primitive that should be rendered from this vertex buffer, in this case lines.
    deviceContext.IASetPrimitiveTopology(D3D11_PRIMITIVE_TOPOLOGY_LINELIST);

end;



function TTerrainCellClass.GetIndexCount(): int32;
begin
    Result := m_indexCount;
end;



function TTerrainCellClass.GetVertexCount(): int32;
begin
    Result := m_vertexCount;
end;



function TTerrainCellClass.GetLineBuffersIndexCount(): int32;
begin
    Result := m_lineIndexCount;
end;



procedure TTerrainCellClass.GetCellDimensions(out maxWidth, maxHeight, maxDepth, minWidth, minHeight, minDepth: single);
begin
    maxWidth := m_maxWidth;
    maxHeight := m_maxHeight;
    maxDepth := m_maxDepth;
    minWidth := m_minWidth;
    minHeight := m_minHeight;
    minDepth := m_minDepth;
end;

end.
