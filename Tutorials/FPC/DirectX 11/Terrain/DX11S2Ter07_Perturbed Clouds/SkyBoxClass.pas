unit SkyBoxClass;

{$mode Delphi}

interface

uses
    Classes, SysUtils, Windows,
    DX12.D3D11,
    DX12.D3DCompiler,
    DX12.D3DCommon,
    DX12.DXGI,
    DX12.D3DX11,
    DX12.D3D10,
    DirectX.Math;

type

    TMatrixBufferType = record
        WVP: TXMMATRIX;
    end;

    TVertex = record
        pos: TXMFLOAT3;
    end;

    { TSkyBoxClass }

    TSkyBoxClass = class(TObject)
    private
        FSphereVertBuffer: ID3D11Buffer;
        FSphereIndexBuffer: ID3D11Buffer;
        m_vertexCount, m_indexCount: integer;
        m_vertexBuffer, m_indexBuffer: ID3D11Buffer;

        m_vertexShader: ID3D11VertexShader;
        m_pixelShader: ID3D11PixelShader;
        m_layout: ID3D11InputLayout;
        m_matrixBuffer: ID3D11Buffer;

        smrv: ID3D11ShaderResourceView;
        CubesTexSamplerState: ID3D11SamplerState;

        FRSCullNone: ID3D11RasterizerState;
        FDSLessEqual: ID3D11DepthStencilState;

        function CreateSphere(LatLines, LongLines: integer; device: ID3D11Device): HResult;
        function InitializeBuffers(device: ID3D11Device): HResult;
        procedure ReleaseBuffers();
        procedure RenderBuffers(deviceContext: ID3D11DeviceContext);
    public
        constructor Create;
        destructor Destroy; override;
        function Initialize(device: ID3D11Device): HResult;
        procedure Shutdown();
        function Render(deviceContext: ID3D11DeviceContext; worldMatrix,viewMatrix, projectionMatrix: TXMMATRIX): HResult;
    end;

implementation

{ TSkyBoxClass }

function TSkyBoxClass.CreateSphere(LatLines, LongLines: integer; device: ID3D11Device): HResult;
var
    sphereYaw: single;
    spherePitch: single;
    NumSphereVertices, NumSphereFaces: integer;
    vertices: array of TVertex;
    currVertPos: TXMVECTOR;
    i, j, k, l: integer;
    Rotationx: TXMMATRIX;
    Rotationy: TXMMATRIX;
    Rotationz: TXMMATRIX;
    indices: array of uint32;
    vertexBufferDesc: TD3D11_BUFFER_DESC;
    vertexBufferData: TD3D11_SUBRESOURCE_DATA;

    indexBufferDesc: TD3D11_BUFFER_DESC;
    iinitData: TD3D11_SUBRESOURCE_DATA;
begin
    sphereYaw := 0;
    spherePitch := 0;

    NumSphereVertices := ((LatLines - 2) * LongLines) + 2;
    NumSphereFaces := ((LatLines - 3) * (LongLines) * 2) + (LongLines * 2);

    m_indexCount :=NumSphereFaces*3;

    SetLength(vertices, NumSphereVertices);


    currVertPos := XMVectorSet(0.0, 0.0, 1.0, 0.0);

    vertices[0].pos.x := 0.0;
    vertices[0].pos.y := 0.0;
    vertices[0].pos.z := 1.0;

    for i := 0 to LatLines - 3 do
    begin
        spherePitch := (i + 1) * (3.14 / (LatLines - 1));
        Rotationx := XMMatrixRotationX(spherePitch);
        for  j := 0 to LongLines - 1 do
        begin
            sphereYaw := j * (6.28 / (LongLines));
            Rotationy := XMMatrixRotationZ(sphereYaw);
            currVertPos := XMVector3TransformNormal(XMVectorSet(0.0, 0.0, 1.0, 0.0), (Rotationx * Rotationy));
            currVertPos := XMVector3Normalize(currVertPos);
            vertices[i * LongLines + j + 1].pos.x := XMVectorGetX(currVertPos);
            vertices[i * LongLines + j + 1].pos.y := XMVectorGetY(currVertPos);
            vertices[i * LongLines + j + 1].pos.z := XMVectorGetZ(currVertPos);
        end;
    end;

    vertices[NumSphereVertices - 1].pos.x := 0.0;
    vertices[NumSphereVertices - 1].pos.y := 0.0;
    vertices[NumSphereVertices - 1].pos.z := -1.0;

    ZeroMemory(@vertexBufferDesc, sizeof(vertexBufferDesc));

    vertexBufferDesc.Usage := D3D11_USAGE_DEFAULT;
    vertexBufferDesc.ByteWidth := sizeof(TVertex) * NumSphereVertices;
    vertexBufferDesc.BindFlags := Ord(D3D11_BIND_VERTEX_BUFFER);
    vertexBufferDesc.CPUAccessFlags := 0;
    vertexBufferDesc.MiscFlags := 0;


    ZeroMemory(@vertexBufferData, sizeof(vertexBufferData));
    vertexBufferData.pSysMem := @vertices[0];
    Result := device.CreateBuffer(vertexBufferDesc, @vertexBufferData, FSphereVertBuffer);


    SetLength(indices, m_indexCount);


    k := 0;
    for l := 0 to LongLines - 2 do
    begin
        indices[k] := 0;
        indices[k + 1] := l + 1;
        indices[k + 2] := l + 2;
        k += 3;
    end;

    indices[k] := 0;
    indices[k + 1] := LongLines;
    indices[k + 2] := 1;
    k += 3;

    for i := 0 to LatLines - 4 do
    begin
        for j := 0 to LongLines - 2 do
        begin
            indices[k] := i * LongLines + j + 1;
            indices[k + 1] := i * LongLines + j + 2;
            indices[k + 2] := (i + 1) * LongLines + j + 1;

            indices[k + 3] := (i + 1) * LongLines + j + 1;
            indices[k + 4] := i * LongLines + j + 2;
            indices[k + 5] := (i + 1) * LongLines + j + 2;

            k += 6; // next quad
        end;

        indices[k] := (i * LongLines) + LongLines;
        indices[k + 1] := (i * LongLines) + 1;
        indices[k + 2] := ((i + 1) * LongLines) + LongLines;

        indices[k + 3] := ((i + 1) * LongLines) + LongLines;
        indices[k + 4] := (i * LongLines) + 1;
        indices[k + 5] := ((i + 1) * LongLines) + 1;

        k += 6;
    end;

    for l := 0 to LongLines - 2 do
    begin
        indices[k] := NumSphereVertices - 1;
        indices[k + 1] := (NumSphereVertices - 1) - (l + 1);
        indices[k + 2] := (NumSphereVertices - 1) - (l + 2);
        k += 3;
    end;

    indices[k] := NumSphereVertices - 1;
    indices[k + 1] := (NumSphereVertices - 1) - LongLines;
    indices[k + 2] := NumSphereVertices - 2;

    ZeroMemory(@indexBufferDesc, sizeof(indexBufferDesc));

    indexBufferDesc.Usage := D3D11_USAGE_DEFAULT;
    indexBufferDesc.ByteWidth := sizeof(DWORD) * NumSphereFaces * 3;
    indexBufferDesc.BindFlags := Ord(D3D11_BIND_INDEX_BUFFER);
    indexBufferDesc.CPUAccessFlags := 0;
    indexBufferDesc.MiscFlags := 0;

    iinitData.pSysMem := @indices[0];
    device.CreateBuffer(indexBufferDesc, @iinitData, FSphereIndexBuffer);

    SetLength(vertices, 0);
    SetLength(indices, 0);
end;



function TSkyBoxClass.InitializeBuffers(device: ID3D11Device): HResult;
begin
    CreateSphere(10, 10, device);
end;



procedure TSkyBoxClass.ReleaseBuffers();
begin

end;



procedure TSkyBoxClass.RenderBuffers(deviceContext: ID3D11DeviceContext);
begin

end;



constructor TSkyBoxClass.Create;
begin

end;



destructor TSkyBoxClass.Destroy;
begin
    inherited Destroy;
end;



function TSkyBoxClass.Initialize(device: ID3D11Device): HResult;
var
    errorMessage: ID3D10Blob;
    vertexShaderBuffer: ID3D10Blob;
    pixelShaderBuffer: ID3D10Blob;
    polygonLayout: array [0..0] of TD3D11_INPUT_ELEMENT_DESC;
    matrixBufferDesc: TD3D11_BUFFER_DESC;
    sampDesc: TD3D11_SAMPLER_DESC;
    loadSMInfo: TD3DX11_IMAGE_LOAD_INFO;
    SMTexture: ID3D11Texture2D;
    SMTextureDesc: TD3D11_TEXTURE2D_DESC;
    SMViewDesc: TD3D11_SHADER_RESOURCE_VIEW_DESC;
    dssDesc: TD3D11_DEPTH_STENCIL_DESC;
    cmdesc: TD3D11_RASTERIZER_DESC;
begin
    Result := InitializeBuffers(device);
    // Compile the vertex shader code.
    Result := D3DCompileFromFile(pwidechar('skybox.vs'), nil, nil, 'SkyBoxVertexShader', 'vs_5_0', D3D10_SHADER_ENABLE_STRICTNESS,
        0, vertexShaderBuffer, errorMessage);

    // Compile the pixel shader code.
    Result := D3DCompileFromFile(pwidechar('skybox.ps'), nil, nil, 'SkyBoxPixelShader', 'ps_5_0', D3D10_SHADER_ENABLE_STRICTNESS,
        0, pixelShaderBuffer, errorMessage);

    // Create the vertex shader from the buffer.
    Result := device.CreateVertexShader(vertexShaderBuffer.GetBufferPointer(), vertexShaderBuffer.GetBufferSize(), nil, m_vertexShader);
    if (FAILED(Result)) then Exit;

    // Create the pixel shader from the buffer.
    Result := device.CreatePixelShader(pixelShaderBuffer.GetBufferPointer(), pixelShaderBuffer.GetBufferSize(), nil, m_pixelShader);
    if (FAILED(Result)) then Exit;

    // Create the vertex input layout description.
    // This setup needs to match the VertexType stucture in the ModelClass and in the shader.
    polygonLayout[0].SemanticName := 'POSITION';
    polygonLayout[0].SemanticIndex := 0;
    polygonLayout[0].Format := DXGI_FORMAT_R32G32B32_FLOAT;
    polygonLayout[0].InputSlot := 0;
    polygonLayout[0].AlignedByteOffset := 0;
    polygonLayout[0].InputSlotClass := D3D11_INPUT_PER_VERTEX_DATA;
    polygonLayout[0].InstanceDataStepRate := 0;


    // Create the vertex input layout.
    Result := device.CreateInputLayout(@polygonLayout[0], Length(polygonLayout), vertexShaderBuffer.GetBufferPointer(),
        vertexShaderBuffer.GetBufferSize(), m_layout);
    if (FAILED(Result)) then Exit;

    // Release the vertex shader buffer and pixel shader buffer since they are no longer needed.
    vertexShaderBuffer := nil;
    pixelShaderBuffer := nil;

    // Setup the description of the dynamic matrix constant buffer that is in the vertex shader.
    matrixBufferDesc.Usage := D3D11_USAGE_DYNAMIC;
    matrixBufferDesc.ByteWidth := sizeof(TMatrixBufferType);
    matrixBufferDesc.BindFlags := Ord(D3D11_BIND_CONSTANT_BUFFER);
    matrixBufferDesc.CPUAccessFlags := Ord(D3D11_CPU_ACCESS_WRITE);
    matrixBufferDesc.MiscFlags := 0;
    matrixBufferDesc.StructureByteStride := 0;

    // Create the constant buffer pointer so we can access the vertex shader constant buffer from within this class.
    Result := device.CreateBuffer(matrixBufferDesc, nil, m_matrixBuffer);
    if (FAILED(Result)) then Exit;

    // Describe the Sample State

    ZeroMemory(@sampDesc, sizeof(sampDesc));
    sampDesc.Filter := D3D11_FILTER_MIN_MAG_MIP_LINEAR;
    sampDesc.AddressU := D3D11_TEXTURE_ADDRESS_WRAP;
    sampDesc.AddressV := D3D11_TEXTURE_ADDRESS_WRAP;
    sampDesc.AddressW := D3D11_TEXTURE_ADDRESS_WRAP;
    sampDesc.ComparisonFunc := D3D11_COMPARISON_NEVER;
    sampDesc.MinLOD := 0;
    sampDesc.MaxLOD := D3D11_FLOAT32_MAX;

    //Create the Sample State
    Result := device.CreateSamplerState(sampDesc, CubesTexSamplerState);


     ///////////////**************new**************////////////////////
    //Tell D3D we will be loading a cube texture
    loadSMInfo.Init;
    loadSMInfo.MiscFlags := ord(D3D11_RESOURCE_MISC_TEXTURECUBE);
    //Load the texture
    Result := D3DX11CreateTextureFromFileW(device, pWideChar('.\Data\Textures\skymap.dds'),
        @loadSMInfo, nil, ID3D11Resource(SMTexture), 0);
    //Create the textures description
    SMTexture.GetDesc(SMTextureDesc);
    //Tell D3D We have a cube texture, which is an array of 2D textures
    SMViewDesc.Format := SMTextureDesc.Format;
    SMViewDesc.ViewDimension := D3D11_SRV_DIMENSION_TEXTURECUBE;
    SMViewDesc.TextureCube.MipLevels := SMTextureDesc.MipLevels;
    SMViewDesc.TextureCube.MostDetailedMip := 0;

    //Create the Resource view
    Result := device.CreateShaderResourceView(SMTexture, @SMViewDesc, smrv);

    ZeroMemory(@cmdesc, sizeof(TD3D11_RASTERIZER_DESC));
    cmdesc.FillMode := D3D11_FILL_SOLID;
    cmdesc.FrontCounterClockwise := False;
    cmdesc.CullMode := D3D11_CULL_NONE;
    Result := device.CreateRasterizerState(cmdesc, FRSCullNone);


    ZeroMemory(@dssDesc, sizeof(TD3D11_DEPTH_STENCIL_DESC));
    dssDesc.DepthEnable := True;
    dssDesc.DepthWriteMask := D3D11_DEPTH_WRITE_MASK_ALL;
    dssDesc.DepthFunc := D3D11_COMPARISON_LESS_EQUAL;

    device.CreateDepthStencilState(dssDesc, FDSLessEqual);

end;



procedure TSkyBoxClass.Shutdown();
begin
    FSphereVertBuffer := nil;
    FSphereIndexBuffer := nil;
    m_vertexBuffer := nil;
    m_indexBuffer := nil;
    m_vertexShader := nil;
    m_pixelShader := nil;
    m_layout := nil;
    m_matrixBuffer := nil;
end;



function TSkyBoxClass.Render(deviceContext: ID3D11DeviceContext; worldMatrix,viewMatrix,
				    projectionMatrix: TXMMATRIX): HResult;
var
    mappedResource: TD3D11_MAPPED_SUBRESOURCE;
    dataPtr: ^TMatrixBufferType;
    bufferNumber: UINT;
    stride: UINT;
    offset: UINT;
    WVP: TXMMATRIX;
begin

    WVP:=worldMatrix*viewMatrix* projectionMatrix;

    Result := deviceContext.Map(m_matrixBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, mappedResource);
    if (FAILED(Result)) then Exit;

    dataPtr := mappedResource.pData;
    dataPtr.WVP := XMMatrixTranspose(WVP);
    deviceContext.Unmap(m_matrixBuffer, 0);

    bufferNumber := 0;
    deviceContext.VSSetConstantBuffers(bufferNumber, 1, @m_matrixBuffer);

    //Set the default blend state (no blending) for opaque objects
    deviceContext.OMSetBlendState(nil, TFloatArray4(nil^), $ffffffff);
    stride := sizeof(TVertex);
    offset := 0;
    deviceContext.IASetInputLayout(m_layout);
    deviceContext.IASetVertexBuffers(0, 1, @m_vertexBuffer, @stride, @offset);
    deviceContext.IASetIndexBuffer(m_indexBuffer, DXGI_FORMAT_R32_UINT, 0);
    deviceContext.IASetPrimitiveTopology(D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST);


    deviceContext.OMSetDepthStencilState(FDSLessEqual, 0);


    deviceContext.PSSetShaderResources(0, 1, @smrv);
    deviceContext.PSSetSamplers(0, 1, @CubesTexSamplerState);


    deviceContext.VSSetShader(m_vertexShader, nil, 0);
    deviceContext.PSSetShader(m_pixelShader, nil, 0);

    deviceContext.RSSetState(FRSCullNone);
    deviceContext.DrawIndexed(m_indexCount, 0, 0);
    deviceContext.OMSetDepthStencilState(nil, 0);
end;

end.
