unit TerrainCellClass;

{$mode Delphi}

interface

uses
    Classes, SysUtils, Windows,
    TerrainShaderClass,
    TextureManagerClass,
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
        rIndex, gIndex, bIndex: int32;
    end;
    PModelType = ^TModelType;

    TVertexType = record
        position: TXMFLOAT3;
        texture: TXMFLOAT2;
        normal: TXMFLOAT3;
        tangent: TXMFLOAT3;
        binormal: TXMFLOAT3;
        color: TXMFLOAT3;
        texture2: TXMFLOAT2;
    end;

    TVectorType = record
        x, y, z: single;
    end;

    TColorVertexType = record
        position: TXMFLOAT3;
        color: TXMFLOAT4;
    end;

    TMaterialGroupType = record
        textureIndex1, textureIndex2, alphaIndex: int32;
        red, green, blue: int32;
        vertexBuffer, indexBuffer: ID3D11Buffer;
        vertexCount, indexCount: int32;
        vertices: array of TVertexType;
        indices: array of uint32;
    end;

    TMaterialGroupDef = record
        textureIndex1, textureIndex2, alphaIndex: int32;
        red, green, blue: int32;
    end;

     (*
       // Initialize the material group array.
    for i := 0 to m_MaterialCount - 1 do
    begin
        m_Materials[i].vertexBuffer := nil;
        m_Materials[i].indexBuffer := nil;
        m_Materials[i].vertices := nil;
        m_Materials[i].indices := nil;
    end;
     *)

    { TTerrainCellClass }

    TTerrainCellClass = class(TObject)
    private
        m_vertexCount, m_indexCount, m_lineIndexCount: integer;
        m_vertexBuffer, m_indexBuffer, m_lineVertexBuffer, m_lineIndexBuffer: ID3D11Buffer;
        m_maxWidth, m_maxHeight, m_maxDepth, m_minWidth, m_minHeight, m_minDepth: single;
        m_positionX, m_positionY, m_positionZ: single;

        m_MaterialsCount: integer;
        m_Materials: array of TMaterialGroupType;
    private
        function InitializeBuffers(device: ID3D11Device; nodeIndexX, nodeIndexY, cellHeight, cellWidth, terrainWidth: integer;
            terrainModelPtr: PModelType; MaterialDef: array of TMaterialGroupDef): HResult;
        procedure ShutdownBuffers();
        procedure RenderBuffers(deviceContext: ID3D11DeviceContext; TerrainShader: TTerrainShaderClass; TextureManager: TTextureManagerClass);

        procedure CalculateCellDimensions();
        function BuildLineBuffers(device: ID3D11Device): HResult;
        procedure ShutdownLineBuffers();
    public
        m_vertexList: array of TVectorType;
    public
        constructor Create;
        destructor Destroy; override;
        function Initialize(device: ID3D11Device; terrainModelPtr: PModelType;
            nodeIndexX, nodeIndexY, cellHeight, cellWidth, terrainWidth: integer; MaterialDef: array of TMaterialGroupDef): HResult;
        procedure Shutdown();
        function Render(deviceContext: ID3D11DeviceContext; TerrainShader: TTerrainShaderClass; TextureManager: TTextureManagerClass): HResult;
        procedure RenderLineBuffers(deviceContext: ID3D11DeviceContext);
        function GetIndexCount(): int32;
        function GetVertexCount(): int32;
        function GetLineBuffersIndexCount(): int32;
        procedure GetCellDimensions(out maxWidth, maxHeight, maxDepth, minWidth, minHeight, minDepth: single);
    end;

implementation

{ TTerrainCellClass }

function TTerrainCellClass.InitializeBuffers(device: ID3D11Device; nodeIndexX, nodeIndexY, cellHeight, cellWidth, terrainWidth: integer;
    terrainModelPtr: PModelType; MaterialDef: array of TMaterialGroupDef): HResult;
var
    //   vertices: array of TVertexType;
    //    indices: array of uint32;
    i, j, k, modelIndex, index: integer;
    vertexBufferDesc, indexBufferDesc: TD3D11_BUFFER_DESC;
    vertexData, indexData: TD3D11_SUBRESOURCE_DATA;
    terrainModel: array of TModelType absolute terrainModelPtr;

    redIndex, greenIndex, blueIndex, lMaterialIndex: integer;
    lMaterialFound: boolean;
    lLocalVertexIndex: integer;
begin

    // Calculate the number of vertices in this terrain cell.
    m_vertexCount := (cellHeight - 1) * (cellWidth - 1) * 6;

    // Set the index count to the same as the vertex count.
    m_indexCount := m_vertexCount;

    m_MaterialsCount := Length(MaterialDef);
    SetLength(m_Materials, m_MaterialsCount);


    // Initialize vertex and index arrays for each material group to the maximum size.
    for i := 0 to m_MaterialsCount - 1 do
    begin
        m_Materials[i].alphaIndex:=MaterialDef[i].alphaIndex;
        m_Materials[i].textureIndex1:=MaterialDef[i].textureIndex1;
        m_Materials[i].textureIndex2:=MaterialDef[i].textureIndex2;
        m_Materials[i].blue:=MaterialDef[i].blue;
        m_Materials[i].green:=MaterialDef[i].green;
        m_Materials[i].red:=MaterialDef[i].red;

        // Create the vertex array.
        SetLength(m_Materials[i].vertices, m_vertexCount);
        m_Materials[i].vertexCount := 0;
        SetLength(m_Materials[i].indices, m_indexCount);
        m_Materials[i].indexCount := 0;
    end;

   { // Create the vertex array.
    SetLength(vertices, m_vertexCount);

    // Create the index array.
    SetLength(indices, m_indexCount); }

    // Create a public vertex array that will be used for accessing vertex information about this cell.
    SetLength(m_vertexList, m_vertexCount);

    // Setup the indexes into the terrain model data and the local vertex/index array.
    modelIndex := ((nodeIndexX * (cellWidth - 1)) + (nodeIndexY * (cellHeight - 1) * (terrainWidth - 1))) * 6;
    index := 0;
    lLocalVertexIndex := 0;

    // Load the vertex array and index array with data.
    for j := 0 to cellHeight - 2 do
    begin
        for i := 0 to cellWidth - 2 do
            //    for i := 0 to ((cellWidth - 1) * 6) - 1 do
        begin
            // Query the upper left corner vertex for the material index.
            redIndex := terrainModel[modelIndex+3].rIndex;
            greenIndex := terrainModel[modelIndex+3].gIndex;
            blueIndex := terrainModel[modelIndex+3].bIndex;
            // Find which material group this vertex belongs to.
            lMaterialIndex := 0;
            k:=0;
            lMaterialFound := False;
            while (not lMaterialFound) and (k<m_MaterialsCount) do
            begin
                if ((redIndex = m_Materials[k].red) and (greenIndex = m_Materials[k].green) and
                    (blueIndex = m_Materials[k].blue)) then
                begin
                    lMaterialFound := True ;
                    lMaterialIndex:=k;
		end
		else
                    Inc(k);
            end;

            // Set the index position in the vertex and index array to the count.
            index := m_Materials[lMaterialIndex].vertexCount;
            for k := 0 to 5 do
            begin
                m_Materials[lMaterialIndex].vertices[index].position :=
                    TXMFLOAT3.Create(terrainModel[modelIndex].x, terrainModel[modelIndex].y, terrainModel[modelIndex].z);
                m_Materials[lMaterialIndex].vertices[index].texture := TXMFLOAT2.Create(terrainModel[modelIndex].tu, terrainModel[modelIndex].tv);
                m_Materials[lMaterialIndex].vertices[index].normal :=
                    TXMFLOAT3.Create(terrainModel[modelIndex].nx, terrainModel[modelIndex].ny, terrainModel[modelIndex].nz);
                m_Materials[lMaterialIndex].vertices[index].tangent :=
                    TXMFLOAT3.Create(terrainModel[modelIndex].tx, terrainModel[modelIndex].ty, terrainModel[modelIndex].tz);
                m_Materials[lMaterialIndex].vertices[index].binormal :=
                    TXMFLOAT3.Create(terrainModel[modelIndex].bx, terrainModel[modelIndex].by, terrainModel[modelIndex].bz);
                m_Materials[lMaterialIndex].vertices[index].color :=
                    TXMFLOAT3.Create(terrainModel[modelIndex].r, terrainModel[modelIndex].g, terrainModel[modelIndex].b);
                m_Materials[lMaterialIndex].vertices[index].texture2 := TXMFLOAT2.Create(terrainModel[modelIndex].tu2, terrainModel[modelIndex].tv2);
                m_Materials[lMaterialIndex].indices[index] := index;

                // Keep a local copy of the vertex position data for this cell.
                m_vertexList[lLocalVertexIndex].x := terrainModel[modelIndex].x;
                m_vertexList[lLocalVertexIndex].y := terrainModel[modelIndex].y;
                m_vertexList[lLocalVertexIndex].z := terrainModel[modelIndex].z;


                Inc(modelIndex);
                Inc(index);
                Inc(lLocalVertexIndex);
            end;
            // Increment the vertex and index array counts.
            m_Materials[lMaterialIndex].vertexCount := m_Materials[lMaterialIndex].vertexCount + 6;
            m_Materials[lMaterialIndex].indexCount := m_Materials[lMaterialIndex].vertexCount + 6;

        end;
        modelIndex := modelIndex + (terrainWidth * 6) - (cellWidth * 6);
    end;

    // Now create the vertex and index buffers from the vertex and index arrays for each material group.
    for i := 0 to m_MaterialsCount - 1 do
    begin
        if m_Materials[i].vertexCount > 0 then
        begin
            if i>0 then
               k:=1;
            vertexBufferDesc.Usage := D3D11_USAGE_DEFAULT;
            vertexBufferDesc.ByteWidth := sizeof(TVertexType) * m_Materials[i].vertexCount;
            vertexBufferDesc.BindFlags := Ord(D3D11_BIND_VERTEX_BUFFER);
            vertexBufferDesc.CPUAccessFlags := 0;
            vertexBufferDesc.MiscFlags := 0;
            vertexBufferDesc.StructureByteStride := 0;

            // Give the subresource structure a pointer to the vertex data.
            vertexData.pSysMem := @m_Materials[i].vertices[0];
            vertexData.SysMemPitch := 0;
            vertexData.SysMemSlicePitch := 0;

            // Now create the vertex buffer.
            Result := device.CreateBuffer(vertexBufferDesc, @vertexData, m_Materials[i].vertexBuffer);
            if (Result <> S_OK) then Exit;

            // Set up the description of the static index buffer.
            indexBufferDesc.Usage := D3D11_USAGE_DEFAULT;
            indexBufferDesc.ByteWidth := sizeof(uint32) * m_Materials[i].indexCount;
            indexBufferDesc.BindFlags := Ord(D3D11_BIND_INDEX_BUFFER);
            indexBufferDesc.CPUAccessFlags := 0;
            indexBufferDesc.MiscFlags := 0;
            indexBufferDesc.StructureByteStride := 0;

            // Give the subresource structure a pointer to the index data.
            indexData.pSysMem := @m_Materials[i].indices[0];
            indexData.SysMemPitch := 0;
            indexData.SysMemSlicePitch := 0;

            // Create the index buffer.
            Result := device.CreateBuffer(indexBufferDesc, @indexData, m_Materials[i].indexBuffer);
        end;
        // Release the arrays now that the buffers have been created and loaded.
        SetLength(m_Materials[i].vertices, 0);
        SetLength(m_Materials[i].indices, 0);

        if (Result <> S_OK) then Exit;
    end;

    if k=0 then  Result := S_OK;
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



procedure TTerrainCellClass.RenderBuffers(deviceContext: ID3D11DeviceContext; TerrainShader: TTerrainShaderClass;
    TextureManager: TTextureManagerClass);
var
    stride: uint32;
    offset: uint32;
    i: integer;
begin

    // Set vertex buffer stride and offset.
    stride := sizeof(TVertexType);
    offset := 0;

    // Set the type of primitive that should be rendered from this vertex buffer, in this case triangles.
    deviceContext.IASetPrimitiveTopology(D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST);


    for i := 0 to m_MaterialsCount - 1 do
    begin
        if m_Materials[i].vertexCount > 0 then
        begin
            // Set the vertex buffer to active in the input assembler so it can be rendered.
            deviceContext.IASetVertexBuffers(0, 1, @m_Materials[i].vertexBuffer, @stride, @offset);

            // Set the index buffer to active in the input assembler so it can be rendered.
            deviceContext.IASetIndexBuffer(m_Materials[i].indexBuffer, DXGI_FORMAT_R32_UINT, 0);
            // If the material group has a valid second texture index then this is a blended terrain polygon.

            // Now render the prepared buffers with the shader.

            if m_Materials[i].textureIndex2<0 then
                TerrainShader.RenderExtern(deviceContext, m_Materials[i].indexCount, TextureManager.GetTexture(m_Materials[i].textureIndex1), TextureManager.GetTexture(m_Materials[i].textureIndex1),
                TextureManager.GetTexture(7), TextureManager.GetTexture(8))
            else
            TerrainShader.RenderExtern(deviceContext, m_Materials[i].indexCount, TextureManager.GetTexture(m_Materials[i].textureIndex1), TextureManager.GetTexture(m_Materials[i].textureIndex2),
                TextureManager.GetTexture(7), TextureManager.GetTexture(8));

            // Render the cell buffers using the terrain shader.
(*       Result := ShaderManager.RenderTerrainShader(Direct3D.GetDeviceContext(), m_Terrain.GetCellIndexCount(i),
                worldMatrix, viewMatrix, projectionMatrix, TextureManager.GetTexture(0), TextureManager.GetTexture(1),
                TextureManager.GetTexture(2),TextureManager.GetTexture(3),m_Light.GetDirection(), m_Light.GetDiffuseColor());
            if (Result <> S_OK) then
                Exit;          *)

(*            Result := m_TerrainShader.Render(deviceContext, indexCount, worldMatrix, viewMatrix, projectionMatrix,
        texture, normalMap,normalMap2,normalMap3, lightDirection, diffuseColor); *)

        end;
    end;
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
    vertexBufferDesc.BindFlags := Ord(D3D11_BIND_VERTEX_BUFFER);
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
    indexBufferDesc.BindFlags := Ord(D3D11_BIND_INDEX_BUFFER);
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
    m_lineIndexBuffer := nil;

    // Release the vertex buffer.
    m_lineVertexBuffer := nil;
end;



constructor TTerrainCellClass.Create;
begin

end;



destructor TTerrainCellClass.Destroy;
begin
    inherited Destroy;
end;



function TTerrainCellClass.Initialize(device: ID3D11Device; terrainModelPtr: PModelType;
    nodeIndexX, nodeIndexY, cellHeight, cellWidth, terrainWidth: integer; MaterialDef: array of TMaterialGroupDef): HResult;

var
    terrainModel: array of TModelType absolute terrainModelPtr;
begin
    // Coerce the pointer to the terrain model into the model type.
    //    terrainModel = (ModelType*)terrainModelPtr;
    // Load the rendering buffers with the terrain data for this cell index.
    Result := InitializeBuffers(device, nodeIndexX, nodeIndexY, cellHeight, cellWidth, terrainWidth, terrainModelPtr, MaterialDef);
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



function TTerrainCellClass.Render(deviceContext: ID3D11DeviceContext; TerrainShader: TTerrainShaderClass;
    TextureManager: TTextureManagerClass): HResult;
begin
    // Put the vertex and index buffers on the graphics pipeline to prepare them for drawing.
    RenderBuffers(deviceContext, TerrainShader, TextureManager);
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
