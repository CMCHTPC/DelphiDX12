unit ModelClass;

{$mode delphiunicode}{$H+}

interface

uses
    Classes, SysUtils, Windows,
    TextureClass,
    DX12.D3D11,
    DX12.D3DCommon,
    DX12.DXGI,
    DirectX.Math;

type

    TVertexType = record
        position: TXMFLOAT3;
        texture: TXMFLOAT2;
    end;

    { TModelClass }

    TModelClass = class(TObject)
    private
        m_vertexBuffer, m_indexBuffer: ID3D11Buffer;
        m_vertexCount, m_indexCount: integer;
        m_Texture: TTextureClass;
    private
        function InitializeBuffers(device: ID3D11Device): HRESULT;
        procedure ShutdownBuffers();
        procedure RenderBuffers(deviceContext: ID3D11DeviceContext);

        function LoadTexture(device: ID3D11Device; deviceContext: ID3D11DeviceContext; filename: WideString): HRESULT;
        procedure ReleaseTexture();
    public
        constructor Create;
        destructor Destroy; override;
        function Initialize(device: ID3D11Device; deviceContext: ID3D11DeviceContext; textureFilename: WideString): HResult;
        procedure Shutdown();
        procedure Render(deviceContext: ID3D11DeviceContext);

        function GetIndexCount(): integer;
        function GetTexture(): ID3D11ShaderResourceView;
    end;

implementation

{ TModelClass }

function TModelClass.InitializeBuffers(device: ID3D11Device): HRESULT;
var
    vertices: array of TVertexType;
    indices: array of ULONG;
    vertexBufferDesc, indexBufferDesc: TD3D11_BUFFER_DESC;
    vertexData, indexData: TD3D11_SUBRESOURCE_DATA;
begin

    // Set the number of vertices in the vertex array.
    m_vertexCount := 3;

    // Set the number of indices in the index array.
    m_indexCount := 3;

    // Create the vertex array.
    SetLength(vertices, m_vertexCount);

    // Create the index array.
    SetLength(indices, m_indexCount);


    // Load the vertex array with data.
    vertices[0].position := TXMFLOAT3.Create(-1.0, -1.0, 0.0);  // Bottom left.
    vertices[0].texture := TXMFLOAT2.Create(0.0, 1.0);

    vertices[1].position := TXMFLOAT3.Create(0.0, 1.0, 0.0);  // Top middle.
    vertices[1].texture := TXMFLOAT2.Create(0.5, 0.0);

    vertices[2].position := TXMFLOAT3.Create(1.0, -1.0, 0.0);  // Bottom right.
    vertices[2].texture := TXMFLOAT2.Create(1.0, 1.0);

    // Load the index array with data.
    indices[0] := 0;  // Bottom left.
    indices[1] := 1;  // Top middle.
    indices[2] := 2;  // Bottom right.

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
    if (FAILED(Result)) then
        Exit;

    // Set up the description of the static index buffer.
    indexBufferDesc.Usage := D3D11_USAGE_DEFAULT;
    indexBufferDesc.ByteWidth := sizeof(ulong) * m_indexCount;
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
    if (FAILED(Result)) then
        Exit;

    // Release the arrays now that the vertex and index buffers have been created and loaded.
    SetLength(vertices, 0);
    SetLength(indices, 0);

end;



procedure TModelClass.ShutdownBuffers();
begin
    // Release the index buffer.
    m_indexBuffer := nil;

    // Release the vertex buffer.
    m_vertexBuffer := nil;
end;



procedure TModelClass.RenderBuffers(deviceContext: ID3D11DeviceContext);
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



function TModelClass.LoadTexture(device: ID3D11Device; deviceContext: ID3D11DeviceContext; filename: WideString): HRESULT;
begin
    // Create the texture object.
    m_Texture := TTextureClass.Create;


    // Initialize the texture object.
    Result := m_Texture.Initialize(device, deviceContext, filename);
end;



procedure TModelClass.ReleaseTexture();
begin
    // Release the texture object.
    if (m_Texture <> nil) then
    begin
        m_Texture.Shutdown();
        m_Texture.Free;
        m_Texture := nil;
    end;

end;



constructor TModelClass.Create;
begin

end;



destructor TModelClass.Destroy;
begin
    inherited Destroy;
end;



function TModelClass.Initialize(device: ID3D11Device; deviceContext: ID3D11DeviceContext; textureFilename: WideString): HResult;
begin
    // Initialize the vertex and index buffers.
    Result := InitializeBuffers(device);

    // Load the texture for this model.
    Result := LoadTexture(device, deviceContext, textureFilename);

end;



procedure TModelClass.Shutdown();
begin
    // Release the model texture.
    ReleaseTexture();
    // Shutdown the vertex and index buffers.
    ShutdownBuffers();
end;



procedure TModelClass.Render(deviceContext: ID3D11DeviceContext);
begin
    // Put the vertex and index buffers on the graphics pipeline to prepare them for drawing.
    RenderBuffers(deviceContext);
end;



function TModelClass.GetIndexCount(): integer;
begin
    Result := m_indexCount;
end;



function TModelClass.GetTexture(): ID3D11ShaderResourceView;
begin
    Result := m_Texture.GetTexture();
end;

end.
