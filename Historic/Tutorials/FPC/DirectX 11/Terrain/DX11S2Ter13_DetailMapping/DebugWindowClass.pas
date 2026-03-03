unit DebugWindowClass;

{$mode DelphiUnicode}{$H+}

interface

uses
    Classes, SysUtils,
    Windows,
    DX12.D3D11,
    DX12.DXGI,
    DX12.D3DCommon,
    DirectX.Math;

type
    TVertexType = record
        position: TXMFLOAT3;
        texture: TXMFLOAT2;
    end;

    { TDebugWindowClass }

    TDebugWindowClass = class(TObject)
    private
        m_vertexBuffer, m_indexBuffer: ID3D11Buffer;
        m_vertexCount, m_indexCount: integer;
        m_screenWidth, m_screenHeight: integer;
        m_bitmapWidth, m_bitmapHeight: integer;
        m_previousPosX, m_previousPosY: integer;
    public
        constructor Create;
        destructor Destroy; override;
        function Initialize(device: ID3D11Device; screenWidth, screenHeight, bitmapWidth, bitmapHeight: integer): HResult;
        procedure Shutdown();
        function Render(deviceContext: ID3D11DeviceContext; positionX, positionY: integer): HResult;
        function GetIndexCount(): integer;
    private
        function InitializeBuffers(device: ID3D11Device): HResult;
        procedure ShutdownBuffers();
        function UpdateBuffers(deviceContext: ID3D11DeviceContext; positionX, positionY: integer): HResult;
        procedure RenderBuffers(deviceContext: ID3D11DeviceContext);
    end;

implementation

{ TDebugWindowClass }

constructor TDebugWindowClass.Create;
begin

end;



destructor TDebugWindowClass.Destroy;
begin
    inherited Destroy;
end;



function TDebugWindowClass.Initialize(device: ID3D11Device; screenWidth, screenHeight, bitmapWidth, bitmapHeight: integer): HResult;
begin
    // Store the screen size.
    m_screenWidth := screenWidth;
    m_screenHeight := screenHeight;

    // Store the size in pixels that this bitmap should be rendered at.
    m_bitmapWidth := bitmapWidth;
    m_bitmapHeight := bitmapHeight;

    // Initialize the previous rendering position to negative one.
    m_previousPosX := -1;
    m_previousPosY := -1;

    // Initialize the vertex and index buffers.
    Result := InitializeBuffers(device);
end;



procedure TDebugWindowClass.Shutdown();
begin
    // Shutdown the vertex and index buffers.
    ShutdownBuffers();
end;



function TDebugWindowClass.Render(deviceContext: ID3D11DeviceContext; positionX, positionY: integer): HResult;
begin
    // Re-build the dynamic vertex buffer for rendering to possibly a different location on the screen.
    Result := UpdateBuffers(deviceContext, positionX, positionY);
    if (Result <> S_OK) then Exit;

    // Put the vertex and index buffers on the graphics pipeline to prepare them for drawing.
    RenderBuffers(deviceContext);
end;



function TDebugWindowClass.GetIndexCount(): integer;
begin
    Result := m_indexCount;
end;



function TDebugWindowClass.InitializeBuffers(device: ID3D11Device): HResult;
var
    vertices: array of TVertexType;
    indices: array of uint32;
    vertexBufferDesc, indexBufferDesc: TD3D11_BUFFER_DESC;
    vertexData, indexData: TD3D11_SUBRESOURCE_DATA;

    i: integer;
begin

    // Set the number of vertices in the vertex array.
    m_vertexCount := 6;

    // Set the number of indices in the index array.
    m_indexCount := m_vertexCount;

    // Create the vertex array.
    SetLength(vertices, m_vertexCount);

    // Create the index array.
    SetLength(indices, m_indexCount);

    // Initialize vertex array to zeros at first.
    ZeroMemory(@vertices[0], (sizeof(TVertexType) * m_vertexCount));

    // Load the index array with data.
    for i := 0 to m_indexCount - 1 do
    begin
        indices[i] := i;
    end;

    // Set up the description of the static vertex buffer.
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


    // Release the arrays now that the vertex and index buffers have been created and loaded.
    SetLength(vertices, 0);
    SetLength(indices, 0);

end;



procedure TDebugWindowClass.ShutdownBuffers();
begin
    // Release the index buffer.
    m_indexBuffer := nil;

    // Release the vertex buffer.
    m_vertexBuffer := nil;

end;



function TDebugWindowClass.UpdateBuffers(deviceContext: ID3D11DeviceContext; positionX, positionY: integer): HResult;
var
    left, right, top, bottom: single;
    vertices: array of TVertexType;
    mappedResource: TD3D11_MAPPED_SUBRESOURCE;
    verticesPtr: ^TVertexType;
begin
    Result:=S_OK;

    // If the position we are rendering this bitmap to has not changed then don't update the vertex buffer since it
    // currently has the correct parameters.
    if ((positionX = m_previousPosX) and (positionY = m_previousPosY)) then exit;
    // If it has changed then update the position it is being rendered to.
    m_previousPosX := positionX;
    m_previousPosY := positionY;

    // Calculate the screen coordinates of the left side of the bitmap.
    left := ((m_screenWidth / 2) * -1) + positionX;

    // Calculate the screen coordinates of the right side of the bitmap.
    right := left + m_bitmapWidth;

    // Calculate the screen coordinates of the top of the bitmap.
    top := (m_screenHeight / 2) - positionY;

    // Calculate the screen coordinates of the bottom of the bitmap.
    bottom := top - m_bitmapHeight;

    // Create the vertex array.
    SetLength(vertices, m_vertexCount);

    // Load the vertex array with data.
    // First triangle.
    vertices[0].position := TXMFLOAT3.Create(left, top, 0.0);  // Top left.
    vertices[0].texture := TXMFLOAT2.Create(0.0, 0.0);

    vertices[1].position := TXMFLOAT3.Create(right, bottom, 0.0);  // Bottom right.
    vertices[1].texture := TXMFLOAT2.Create(1.0, 1.0);

    vertices[2].position := TXMFLOAT3.Create(left, bottom, 0.0);  // Bottom left.
    vertices[2].texture := TXMFLOAT2.Create(0.0, 1.0);

    // Second triangle.
    vertices[3].position := TXMFLOAT3.Create(left, top, 0.0);  // Top left.
    vertices[3].texture := TXMFLOAT2.Create(0.0, 0.0);

    vertices[4].position := TXMFLOAT3.Create(right, top, 0.0);  // Top right.
    vertices[4].texture := TXMFLOAT2.Create(1.0, 0.0);

    vertices[5].position := TXMFLOAT3.Create(right, bottom, 0.0);  // Bottom right.
    vertices[5].texture := TXMFLOAT2.Create(1.0, 1.0);

    // Lock the vertex buffer so it can be written to.
    Result := deviceContext.Map(m_vertexBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);
    if (Result <> S_OK) then Exit;

    // Get a pointer to the data in the vertex buffer.
    verticesPtr := mappedResource.pData;

    // Copy the data into the vertex buffer.
    Move(vertices[0], verticesPtr^, (sizeof(TVertexType) * m_vertexCount));
    // Unlock the vertex buffer.
    deviceContext.Unmap(m_vertexBuffer, 0);
    // Release the vertex array as it is no longer needed.
    SetLength(vertices, 0);
end;



procedure TDebugWindowClass.RenderBuffers(deviceContext: ID3D11DeviceContext);
var
    stride: UINT;
    offset: UINT;
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

end.
