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

    TInstanceType = record
        position: TXMFLOAT3;
    end;

    { TModelClass }

    TModelClass = class(TObject)
    private
        m_vertexBuffer, m_indexBuffer: ID3D11Buffer;
        m_vertexCount: integer;
        m_instanceCount: integer;
        m_Texture: TTextureClass;
        m_instanceBuffer: ID3D11Buffer;
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

        function GetTexture(): ID3D11ShaderResourceView;
        function GetVertexCount(): integer;
        function GetInstanceCount(): integer;
    end;

implementation

{ TModelClass }

function TModelClass.InitializeBuffers(device: ID3D11Device): HRESULT;
var
    vertices: array of TVertexType;
    instances: array of TInstanceType;
    vertexBufferDesc, instanceBufferDesc: TD3D11_BUFFER_DESC;
    vertexData, instanceData: TD3D11_SUBRESOURCE_DATA;
begin

    // Set the number of vertices in the vertex array.
    m_vertexCount := 3;

    // Create the vertex array.
    SetLength(vertices, m_vertexCount);


    // Load the vertex array with data.
    vertices[0].position := TXMFLOAT3.Create(-1.0, -1.0, 0.0);  // Bottom left.
    vertices[0].texture := TXMFLOAT2.Create(0.0, 1.0);

    vertices[1].position := TXMFLOAT3.Create(0.0, 1.0, 0.0);  // Top middle.
    vertices[1].texture := TXMFLOAT2.Create(0.5, 0.0);

    vertices[2].position := TXMFLOAT3.Create(1.0, -1.0, 0.0);  // Bottom right.
    vertices[2].texture := TXMFLOAT2.Create(1.0, 1.0);


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

    // Release the arrays now that the vertex and index buffers have been created and loaded.
    SetLength(vertices, 0);


    // Set the number of instances in the array.
    m_instanceCount := 4;

    // Create the instance array.
    SetLength(instances, m_instanceCount);
    // Load the instance array with data.
    instances[0].position := TXMFLOAT3.Create(-1.5, -1.5, 5.0);
    instances[1].position := TXMFLOAT3.Create(-1.5, 1.5, 5.0);
    instances[2].position := TXMFLOAT3.Create(1.5, -1.5, 5.0);
    instances[3].position := TXMFLOAT3.Create(1.5, 1.5, 5.0);

    // Set up the description of the instance buffer.
    instanceBufferDesc.Usage := D3D11_USAGE_DEFAULT;
    instanceBufferDesc.ByteWidth := sizeof(TInstanceType) * m_instanceCount;
    instanceBufferDesc.BindFlags := Ord(D3D11_BIND_VERTEX_BUFFER);
    instanceBufferDesc.CPUAccessFlags := 0;
    instanceBufferDesc.MiscFlags := 0;
    instanceBufferDesc.StructureByteStride := 0;

    // Give the subresource structure a pointer to the instance data.
    instanceData.pSysMem := @instances[0];
    instanceData.SysMemPitch := 0;
    instanceData.SysMemSlicePitch := 0;

    // Create the instance buffer.
    Result := device.CreateBuffer(instanceBufferDesc, @instanceData, m_instanceBuffer);
    if (FAILED(Result)) then
        Exit;

    // Release the instance array now that the instance buffer has been created and loaded.
    SetLength(instances, 0);
end;



procedure TModelClass.ShutdownBuffers();
begin
    // Release the instance buffer.
    m_instanceBuffer := nil;

    // Release the vertex buffer.
    m_vertexBuffer := nil;
end;



procedure TModelClass.RenderBuffers(deviceContext: ID3D11DeviceContext);
var
    strides: array[0..1] of UINT;
    offsets: array[0..1] of UINT;
    bufferPointers: array[0..1] of ID3D11Buffer;

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

    // Set the vertex buffer to active in the input assembler so it can be rendered.
    deviceContext.IASetVertexBuffers(0, 2, @bufferPointers, @strides, offsets);

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




function TModelClass.GetTexture(): ID3D11ShaderResourceView;
begin
    Result := m_Texture.GetTexture();
end;



function TModelClass.GetVertexCount(): integer;
begin
    Result := m_vertexCount;
end;



function TModelClass.GetInstanceCount(): integer;
begin
    Result := m_instanceCount;
end;

end.
