unit ModelClass;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$ENDIF}

interface

uses
    Classes, SysUtils, Windows,
    TextureArrayClass,
    DX12.D3D11,
    DX12.D3DCommon,
    DX12.DXGI,
    DirectX.Math;

type

    TVertexType = record
        position: TXMFLOAT3;
        texture: TXMFLOAT2;
    end;

    TModelType = record
        x, y, z: single;
        tu, tv: single;
        nx, ny, nz: single;
    end;

    { TModelClass }

    TModelClass = class(TObject)
    private
        m_vertexBuffer, m_indexBuffer: ID3D11Buffer;
        m_vertexCount, m_indexCount: integer;
        m_TextureArray: TTextureArrayClass;
        m_model: array of TModelType;
    private
        function InitializeBuffers(device: ID3D11Device): HRESULT;
        procedure ShutdownBuffers();
        procedure RenderBuffers(deviceContext: ID3D11DeviceContext);

        function LoadTextures(device: ID3D11Device; deviceContext: ID3D11DeviceContext; textureFilename1: WideString;
            textureFilename2: WideString;textureFilename3: WideString): HRESULT;
        procedure ReleaseTextures();
        function LoadModel(modelFilename: WideString): HResult;
        procedure ReleaseModel();

    public
        constructor Create;
        destructor Destroy; override;
        function Initialize(device: ID3D11Device; deviceContext: ID3D11DeviceContext; modelFilename: WideString;
            textureFilename1: WideString; textureFilename2: WideString; textureFilename3: WideString): HResult;
        procedure Shutdown();
        procedure Render(deviceContext: ID3D11DeviceContext);

        function GetIndexCount(): integer;
        function GetTextureArray(): PID3D11ShaderResourceView;
    end;

implementation


{ TModelClass }

function TModelClass.InitializeBuffers(device: ID3D11Device): HRESULT;
var
    vertices: array of TVertexType;
    indices: array of ULONG;
    vertexBufferDesc, indexBufferDesc: TD3D11_BUFFER_DESC;
    vertexData, indexData: TD3D11_SUBRESOURCE_DATA;
    i: integer;
begin
    // Create the vertex array.
    SetLength(vertices, m_vertexCount);

    // Create the index array.
    SetLength(indices, m_indexCount);


    // Load the vertex array and index array with data.
    for i := 0 to m_vertexCount - 1 do
    begin
        vertices[i].position := TXMFLOAT3.Create(m_model[i].x, m_model[i].y, m_model[i].z);
        vertices[i].texture := TXMFLOAT2.Create(m_model[i].tu, m_model[i].tv);
        //    vertices[i].normal := TXMFLOAT3.Create(m_model[i].nx, m_model[i].ny, m_model[i].nz);

        indices[i] := i;
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



function TModelClass.LoadTextures(device: ID3D11Device; deviceContext: ID3D11DeviceContext; textureFilename1: WideString;
    textureFilename2: WideString;textureFilename3: WideString): HRESULT;
begin
    // Create the texture  arrayobject.
    m_TextureArray := TTextureArrayClass.Create;


    // Initialize the texture object.
    Result := m_TextureArray.Initialize(device, deviceContext, textureFilename1, textureFilename2, textureFilename3);
end;



procedure TModelClass.ReleaseTextures();
begin
    // Release the texture array object.
    if (m_TextureArray <> nil) then
    begin
        m_TextureArray.Shutdown();
        m_TextureArray.Free;
        m_TextureArray := nil;
    end;

end;



function TModelClass.LoadModel(modelFilename: WideString): HResult;
var
    f: TextFile;
    i: integer;
    s: ansistring;
    input: char;
    iPos: integer;
    jPos: integer;
    temp: ansistring;
begin
    // Open the model file.
    AssignFile(f, modelFilename);
    Reset(f);
    // Read up to the value of vertex count.
    Read(F, input);
    while (input <> ':') do
    begin
        Read(F, input);
    end;

    // Read in the vertex count.
    readln(F, s);
    m_vertexCount := StrToInt(s);

    // Set the number of indices to be the same as the vertex count.
    m_indexCount := m_vertexCount;

    // Create the model using the vertex count that was read in.
    SetLength(m_model, m_vertexCount);

    // Read up to the beginning of the data.
    Read(F, input);
    while (input <> ':') do
    begin
        Read(F, input);
    end;
    readln(F, s);
    readln(F, s);

    FormatSettings.DecimalSeparator := '.';

    // Read in the vertex data.
    for i := 0 to m_vertexCount - 1 do
    begin

        readln(F, s);

        jPos := 1;
        while s[jPos] = ' ' do Inc(jPos);
        iPos := jPos;
        while s[iPos] <> ' ' do Inc(iPos);
        temp := copy(s, jpos, ipos - jpos);
        m_model[i].x := StrToFloat(temp);

        jPos := ipos;
        while s[jPos] = ' ' do Inc(jPos);
        iPos := jPos;
        while s[iPos] <> ' ' do Inc(iPos);
        temp := copy(s, jpos, ipos - jpos);
        m_model[i].y := StrToFloat(temp);

        jPos := ipos;
        while s[jPos] = ' ' do Inc(jPos);
        iPos := jPos;
        while s[iPos] <> ' ' do Inc(iPos);
        temp := copy(s, jpos, ipos - jpos);
        m_model[i].z := StrToFloat(temp);

        jPos := ipos;
        while s[jPos] = ' ' do Inc(jPos);
        iPos := jPos;
        while s[iPos] <> ' ' do Inc(iPos);
        temp := copy(s, jpos, ipos - jpos);
        m_model[i].tu := StrToFloat(temp);

        jPos := ipos;
        while s[jPos] = ' ' do Inc(jPos);
        iPos := jPos;
        while s[iPos] <> ' ' do Inc(iPos);
        temp := copy(s, jpos, ipos - jpos);
        m_model[i].tv := StrToFloat(temp);

        jPos := ipos;
        while s[jPos] = ' ' do Inc(jPos);
        iPos := jPos;
        while s[iPos] <> ' ' do Inc(iPos);
        temp := copy(s, jpos, ipos - jpos);
        m_model[i].nx := StrToFloat(temp);

        jPos := ipos;
        while s[jPos] = ' ' do Inc(jPos);
        iPos := jPos;
        while s[iPos] <> ' ' do Inc(iPos);
        temp := copy(s, jpos, ipos - jpos);
        m_model[i].ny := StrToFloat(temp);

        jPos := ipos;
        while s[jPos] = ' ' do Inc(jPos);
        iPos := length(s);
        temp := copy(s, jpos, ipos - jpos + 1);
        m_model[i].nz := StrToFloat(temp);

    end;

    // Close the model file.
    CloseFile(F);

    Result := S_OK;
end;



procedure TModelClass.ReleaseModel();
begin
    SetLength(m_model, 0);
end;



constructor TModelClass.Create;
begin

end;



destructor TModelClass.Destroy;
begin
    inherited Destroy;
end;



function TModelClass.Initialize(device: ID3D11Device; deviceContext: ID3D11DeviceContext; modelFilename: WideString;
    textureFilename1: WideString; textureFilename2: WideString; textureFilename3: WideString): HResult;
begin
    // Load in the model data,
    Result := LoadModel(modelFilename);
    if (Result <> S_OK) then Exit;

    // Initialize the vertex and index buffers.
    Result := InitializeBuffers(device);

    // Load the texture for this model.
    Result := LoadTextures(device, deviceContext, textureFilename1, textureFilename2,textureFilename3);

end;



procedure TModelClass.Shutdown();
begin
    // Release the model textures.
    ReleaseTextures();
    // Shutdown the vertex and index buffers.
    ShutdownBuffers();

    // Release the model data.
    ReleaseModel();
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



function TModelClass.GetTextureArray(): PID3D11ShaderResourceView;
begin
    Result := m_TextureArray.GetTextureArray();
end;

end.
