unit SkyDomeClass;

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
    end;

    TVertexType = record
        position: TXMFLOAT3;
    end;


    { TSkyDomeClass }

    TSkyDomeClass = class(TObject)
    private
        m_model: array of TModelType;
        m_vertexCount, m_indexCount: integer;
        m_vertexBuffer, m_indexBuffer: ID3D11Buffer;
        m_apexColor, m_centerColor: TXMFLOAT4;
    public
        constructor Create;
        destructor Destroy; override;
        function Initialize(device: ID3D11Device): HResult;
        procedure Shutdown();
        procedure Render(deviceContext: ID3D11DeviceContext);
        function GetIndexCount(): integer;
        function GetApexColor(): TXMFLOAT4;
        function GetCenterColor(): TXMFLOAT4;
    private
        function LoadSkyDomeModel(filename: WideString): HResult;
        procedure ReleaseSkyDomeModel();
        function InitializeBuffers(device: ID3D11Device): HResult;
        procedure ReleaseBuffers();
        procedure RenderBuffers(deviceContext: ID3D11DeviceContext);
    end;

implementation

{ TSkyDomeClass }

constructor TSkyDomeClass.Create;
begin

end;



destructor TSkyDomeClass.Destroy;
begin
    inherited Destroy;
end;



function TSkyDomeClass.Initialize(device: ID3D11Device): HResult;
begin
    // Load in the sky dome model.
    Result := LoadSkyDomeModel('.\data\skydome\skydome.txt');
    if (Result <> S_OK) then Exit;
    // Load the sky dome into a vertex and index buffer for rendering.
    Result := InitializeBuffers(device);
    if (Result <> S_OK) then Exit;

    // Set the color at the top of the sky dome.
    m_apexColor := TXMFLOAT4.Create(0.0, 0.05, 0.6, 1.0);

    // Set the color at the center of the sky dome.
    m_centerColor := TXMFLOAT4.Create(0.0, 0.5, 0.8, 1.0);
end;



procedure TSkyDomeClass.Shutdown();
begin
    // Release the vertex and index buffer that were used for rendering the sky dome.
    ReleaseBuffers();

    // Release the sky dome model.
    ReleaseSkyDomeModel();

end;



procedure TSkyDomeClass.Render(deviceContext: ID3D11DeviceContext);
begin
    // Render the sky dome.
    RenderBuffers(deviceContext);
end;



function TSkyDomeClass.GetIndexCount(): integer;
begin
    Result := m_indexCount;
end;



function TSkyDomeClass.GetApexColor(): TXMFLOAT4;
begin
    Result := m_apexColor;
end;



function TSkyDomeClass.GetCenterColor(): TXMFLOAT4;
begin
    Result := m_centerColor;
end;



function TSkyDomeClass.LoadSkyDomeModel(filename: WideString): HResult;
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
    AssignFile(f, filename);
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



procedure TSkyDomeClass.ReleaseSkyDomeModel();
begin
    SetLength(m_model, 0);
end;



function TSkyDomeClass.InitializeBuffers(device: ID3D11Device): HResult;
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
        //vertices[i].texture := TXMFLOAT2.Create(m_model[i].tu, m_model[i].tv);
        //vertices[i].normal := TXMFLOAT3.Create(m_model[i].nx, m_model[i].ny, m_model[i].nz);
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



procedure TSkyDomeClass.ReleaseBuffers();
begin
    // Release the index buffer.
    m_indexBuffer := nil;

    // Release the vertex buffer.
    m_vertexBuffer := nil;
end;



procedure TSkyDomeClass.RenderBuffers(deviceContext: ID3D11DeviceContext);
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
