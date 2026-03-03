unit SpecMapShaderClass;

{$mode DelphiUnicode}{$H+}

interface

uses
    Classes, SysUtils, Windows,
    DX12.D3D11, DX12.D3DCompiler,
    DX12.D3D10,
    DX12.DXGI,
    DX12.D3DCommon,
    DirectX.Math;

type

    TMatrixBufferType = record
        world: TXMMATRIX;
        view: TXMMATRIX;
        projection: TXMMATRIX;
    end;

    TLightBufferType = record
        diffuseColor: TXMFLOAT4;
        specularColor: TXMFLOAT4;
        specularPower: single;
        lightDirection: TXMFLOAT3;
    end;

    TCameraBufferType = record
        cameraPosition: TXMFLOAT3;
        padding: single;
    end;

    { TSpecMapShaderClass }

    TSpecMapShaderClass = class(TObject)
    private
        m_vertexShader: ID3D11VertexShader;
        m_pixelShader: ID3D11PixelShader;
        m_layout: ID3D11InputLayout;
        m_matrixBuffer: ID3D11Buffer;
        m_sampleState: ID3D11SamplerState;
        m_lightBuffer: ID3D11Buffer;
        m_cameraBuffer: ID3D11Buffer;
    private
        function InitializeShader(device: ID3D11Device; hwnd: HWND; vsFilename, psFilename: WideString): HResult;
        procedure ShutdownShader();
        procedure OutputShaderErrorMessage(errorMessage: ID3D10Blob; hwnd: HWND; shaderFilename: WideString);
        function SetShaderParameters(deviceContext: ID3D11DeviceContext; worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX;
            textureArray: PID3D11ShaderResourceView; lightDirection: TXMFLOAT3; diffuseColor: TXMFLOAT4;
            cameraPosition: TXMFLOAT3; specularColor: TXMFLOAT4; specularPower: single): HResult;
        procedure RenderShader(deviceContext: ID3D11DeviceContext; indexCount: integer);
    public
        constructor Create;
        destructor Destroy; override;
        function Initialize(device: ID3D11Device; hwnd: HWND): Hresult;
        procedure Shutdown();
        function Render(deviceContext: ID3D11DeviceContext; indexCount: integer; worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX;
            textureArray: PID3D11ShaderResourceView; lightDirection: TXMFLOAT3; diffuseColor: TXMFLOAT4;
            cameraPosition: TXMFLOAT3; specularColor: TXMFLOAT4; specularPower: single): HResult;

    end;

implementation

{ TSpecMapShaderClass }

function TSpecMapShaderClass.InitializeShader(device: ID3D11Device; hwnd: HWND; vsFilename, psFilename: WideString): HResult;
var
    errorMessage: ID3D10Blob;
    vertexShaderBuffer: ID3D10Blob;
    pixelShaderBuffer: ID3D10Blob;
    polygonLayout: array [0..4] of TD3D11_INPUT_ELEMENT_DESC;
    numElements: UINT;
    matrixBufferDesc: TD3D11_BUFFER_DESC;
    samplerDesc: TD3D11_SAMPLER_DESC;
    lightBufferDesc: TD3D11_BUFFER_DESC;
    cameraBufferDesc: TD3D11_BUFFER_DESC;
begin
    // Initialize the pointers this function will use to null.


    // Compile the vertex shader code.
    Result := D3DCompileFromFile(pwidechar(vsFilename), nil, nil, 'SpecMapVertexShader', 'vs_5_0',
        D3D10_SHADER_ENABLE_STRICTNESS, 0, vertexShaderBuffer, errorMessage);
    if (FAILED(Result)) then
    begin
        // If the shader failed to compile it should have writen something to the error message.
        if (errorMessage <> nil) then
        begin
            OutputShaderErrorMessage(errorMessage, hwnd, vsFilename);
        end
        // If there was  nothing in the error message then it simply could not find the shader file itself.
        else
        begin
            MessageBoxW(hwnd, pwidechar(vsFilename), 'Missing Shader File', MB_OK);
        end;

        Exit;
    end;

    // Compile the pixel shader code.
    Result := D3DCompileFromFile(pwidechar(psFilename), nil, nil, 'SpecMapPixelShader', 'ps_5_0', D3D10_SHADER_ENABLE_STRICTNESS,
        0, pixelShaderBuffer, errorMessage);
    if (FAILED(Result)) then
    begin
        // If the shader failed to compile it should have writen something to the error message.
        if (errorMessage <> nil) then
        begin
            OutputShaderErrorMessage(errorMessage, hwnd, psFilename);
        end
        // If there was nothing in the error message then it simply could not find the file itself.
        else
        begin
            MessageBoxW(hwnd, pwidechar(psFilename), 'Missing Shader File', MB_OK);
        end;

        Exit;
    end;


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

    polygonLayout[1].SemanticName := 'TEXCOORD';
    polygonLayout[1].SemanticIndex := 0;
    polygonLayout[1].Format := DXGI_FORMAT_R32G32_FLOAT;
    polygonLayout[1].InputSlot := 0;
    polygonLayout[1].AlignedByteOffset := D3D11_APPEND_ALIGNED_ELEMENT;
    polygonLayout[1].InputSlotClass := D3D11_INPUT_PER_VERTEX_DATA;
    polygonLayout[1].InstanceDataStepRate := 0;

    polygonLayout[2].SemanticName := 'NORMAL';
    polygonLayout[2].SemanticIndex := 0;
    polygonLayout[2].Format := DXGI_FORMAT_R32G32B32_FLOAT;
    polygonLayout[2].InputSlot := 0;
    polygonLayout[2].AlignedByteOffset := D3D11_APPEND_ALIGNED_ELEMENT;
    polygonLayout[2].InputSlotClass := D3D11_INPUT_PER_VERTEX_DATA;
    polygonLayout[2].InstanceDataStepRate := 0;

    polygonLayout[3].SemanticName := 'TANGENT';
    polygonLayout[3].SemanticIndex := 0;
    polygonLayout[3].Format := DXGI_FORMAT_R32G32B32_FLOAT;
    polygonLayout[3].InputSlot := 0;
    polygonLayout[3].AlignedByteOffset := D3D11_APPEND_ALIGNED_ELEMENT;
    polygonLayout[3].InputSlotClass := D3D11_INPUT_PER_VERTEX_DATA;
    polygonLayout[3].InstanceDataStepRate := 0;

    polygonLayout[4].SemanticName := 'BINORMAL';
    polygonLayout[4].SemanticIndex := 0;
    polygonLayout[4].Format := DXGI_FORMAT_R32G32B32_FLOAT;
    polygonLayout[4].InputSlot := 0;
    polygonLayout[4].AlignedByteOffset := D3D11_APPEND_ALIGNED_ELEMENT;
    polygonLayout[4].InputSlotClass := D3D11_INPUT_PER_VERTEX_DATA;
    polygonLayout[4].InstanceDataStepRate := 0;

    // Get a count of the elements in the layout.
    numElements := sizeof(polygonLayout) div sizeof(polygonLayout[0]);

    // Create the vertex input layout.
    Result := device.CreateInputLayout(polygonLayout, numElements, vertexShaderBuffer.GetBufferPointer(),
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

    // Create a texture sampler state description.
    samplerDesc.Filter := D3D11_FILTER_MIN_MAG_MIP_LINEAR;
    samplerDesc.AddressU := D3D11_TEXTURE_ADDRESS_WRAP;
    samplerDesc.AddressV := D3D11_TEXTURE_ADDRESS_WRAP;
    samplerDesc.AddressW := D3D11_TEXTURE_ADDRESS_WRAP;
    samplerDesc.MipLODBias := 0.0;
    samplerDesc.MaxAnisotropy := 1;
    samplerDesc.ComparisonFunc := D3D11_COMPARISON_ALWAYS;
    samplerDesc.BorderColor[0] := 0;
    samplerDesc.BorderColor[1] := 0;
    samplerDesc.BorderColor[2] := 0;
    samplerDesc.BorderColor[3] := 0;
    samplerDesc.MinLOD := 0;
    samplerDesc.MaxLOD := D3D11_FLOAT32_MAX;

    // Create the texture sampler state.
    Result := device.CreateSamplerState(&samplerDesc, m_sampleState);


    // Setup the description of the light dynamic constant buffer that is in the pixel shader.
    lightBufferDesc.Usage := D3D11_USAGE_DYNAMIC;
    lightBufferDesc.ByteWidth := sizeof(TLightBufferType);
    lightBufferDesc.BindFlags := Ord(D3D11_BIND_CONSTANT_BUFFER);
    lightBufferDesc.CPUAccessFlags := Ord(D3D11_CPU_ACCESS_WRITE);
    lightBufferDesc.MiscFlags := 0;
    lightBufferDesc.StructureByteStride := 0;

    // Create the constant buffer pointer so we can access the vertex shader constant buffer from within this class.
    Result := device.CreateBuffer(lightBufferDesc, nil, m_lightBuffer);

    // Setup the description of the camera dynamic constant buffer that is in the vertex shader.
    cameraBufferDesc.Usage := D3D11_USAGE_DYNAMIC;
    cameraBufferDesc.ByteWidth := sizeof(TCameraBufferType);
    cameraBufferDesc.BindFlags := Ord(D3D11_BIND_CONSTANT_BUFFER);
    cameraBufferDesc.CPUAccessFlags := Ord(D3D11_CPU_ACCESS_WRITE);
    cameraBufferDesc.MiscFlags := 0;
    cameraBufferDesc.StructureByteStride := 0;

    // Create the camera constant buffer pointer so we can access the vertex shader constant buffer from within this class.
    Result := device.CreateBuffer(cameraBufferDesc, nil, m_cameraBuffer);

end;



procedure TSpecMapShaderClass.ShutdownShader();
begin
    m_cameraBuffer := nil;
    // Release the light constant buffer.
    m_lightBuffer := nil;
    // Release the sampler state.
    m_sampleState := nil;

    // Release the matrix constant buffer.
    m_matrixBuffer := nil;

    // Release the layout.
    m_layout := nil;

    // Release the pixel shader.
    m_pixelShader := nil;

    // Release the vertex shader.
    m_vertexShader := nil;
end;



procedure TSpecMapShaderClass.OutputShaderErrorMessage(errorMessage: ID3D10Blob; hwnd: HWND; shaderFilename: WideString);
var
    compileErrors: pansichar;
    lFileStream: TFileStream;
    bufferSize, i: uint64;
begin
    // Get a pointer to the error message text buffer.
    compileErrors := errorMessage.GetBufferPointer();

    // Get the length of the message.
    bufferSize := errorMessage.GetBufferSize();

    // Open a file to write the error message to.
    lFileStream := TFileStream.Create('shader-error.txt', fmCreate);
    try
        // Write out the error message.
        lFileStream.WriteBuffer(compileErrors, bufferSize);
    finally
        // Close the file.
        lFileStream.Free;
    end;
    // Release the error message.
    errorMessage := nil;

    // Pop a message up on the screen to notify the user to check the text file for compile errors.
    MessageBoxW(hwnd, 'Error compiling shader.  Check shader-error.txt for message.', pwidechar(shaderFilename), MB_OK);
end;



function TSpecMapShaderClass.SetShaderParameters(deviceContext: ID3D11DeviceContext;
    worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX; textureArray: PID3D11ShaderResourceView;
    lightDirection: TXMFLOAT3; diffuseColor: TXMFLOAT4; cameraPosition: TXMFLOAT3; specularColor: TXMFLOAT4;
    specularPower: single): HResult;
var
    mappedResource: TD3D11_MAPPED_SUBRESOURCE;
    dataPtr: ^TMatrixBufferType;
    bufferNumber: UINT;
    dataPtr2: ^TLightBufferType;
    dataPtr3: ^TCameraBufferType;
begin

    // Transpose the matrices to prepare them for the shader.
    worldMatrix := XMMatrixTranspose(worldMatrix);
    viewMatrix := XMMatrixTranspose(viewMatrix);
    projectionMatrix := XMMatrixTranspose(projectionMatrix);

    // Lock the constant buffer so it can be written to.
    Result := deviceContext.Map(m_matrixBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, mappedResource);
    if (FAILED(Result)) then Exit;

    // Get a pointer to the data in the constant buffer.
    dataPtr := mappedResource.pData;

    // Copy the matrices into the constant buffer.
    dataPtr.world := worldMatrix;
    dataPtr.view := viewMatrix;
    dataPtr.projection := projectionMatrix;

    // Unlock the constant buffer.
    deviceContext.Unmap(m_matrixBuffer, 0);

    // Set the position of the constant buffer in the vertex shader.
    bufferNumber := 0;

    // Finanly set the constant buffer in the vertex shader with the updated values.
    deviceContext.VSSetConstantBuffers(bufferNumber, 1, @m_matrixBuffer);

    // Set shader texture resource in the pixel shader.
    deviceContext.PSSetShaderResources(0, 3, textureArray);

    // Lock the light constant buffer so it can be written to.
    Result := deviceContext.Map(m_lightBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, mappedResource);
    if (FAILED(Result)) then Exit;

    // Get a pointer to the data in the constant buffer.
    dataPtr2 := mappedResource.pData;

    // Copy the lighting variables into the constant buffer.
    dataPtr2.diffuseColor := diffuseColor;
    dataPtr2.lightDirection := lightDirection;
    dataPtr2.specularColor := specularColor;
    dataPtr2.specularPower := specularPower;

    // Unlock the constant buffer.
    deviceContext.Unmap(m_lightBuffer, 0);

    // Set the position of the light constant buffer in the pixel shader.
    bufferNumber := 0;

    // Finally set the light constant buffer in the pixel shader with the updated values.
    deviceContext.PSSetConstantBuffers(bufferNumber, 1, @m_lightBuffer);


    // Lock the camera constant buffer so it can be written to.
    Result := deviceContext.Map(m_cameraBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);
    if (FAILED(Result)) then Exit;

    // Get a pointer to the data in the constant buffer.
    dataPtr3 := mappedResource.pData;

    // Copy the camera position into the constant buffer.
    dataPtr3.cameraPosition := cameraPosition;

    // Unlock the matrix constant buffer.
    deviceContext.Unmap(m_cameraBuffer, 0);

    // Set the position of the camera constant buffer in the vertex shader as the second buffer.
    bufferNumber := 1;

    // Now set the matrix constant buffer in the vertex shader with the updated values.
    deviceContext.VSSetConstantBuffers(bufferNumber, 1, @m_cameraBuffer);

    Result := S_OK;

end;



procedure TSpecMapShaderClass.RenderShader(deviceContext: ID3D11DeviceContext; indexCount: integer);
begin
    // Set the vertex input layout.
    deviceContext.IASetInputLayout(m_layout);

    // Set the vertex and pixel shaders that will be used to render this triangle.
    deviceContext.VSSetShader(m_vertexShader, nil, 0);
    deviceContext.PSSetShader(m_pixelShader, nil, 0);

    // Set the sampler state in the pixel shader.
    deviceContext.PSSetSamplers(0, 1, @m_sampleState);

    // Render the triangle.
    deviceContext.DrawIndexed(indexCount, 0, 0);
end;



constructor TSpecMapShaderClass.Create;
begin

end;



destructor TSpecMapShaderClass.Destroy;
begin
    inherited Destroy;
end;



function TSpecMapShaderClass.Initialize(device: ID3D11Device; hwnd: HWND): Hresult;
begin
    // Initialize the vertex and pixel shaders.
    Result := InitializeShader(device, hwnd, 'specmap.vs', 'specmap.ps');
end;



procedure TSpecMapShaderClass.Shutdown();
begin
    // Shutdown the vertex and pixel shaders as well as the related objects.
    ShutdownShader();
end;



function TSpecMapShaderClass.Render(deviceContext: ID3D11DeviceContext; indexCount: integer;
    worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX; textureArray: PID3D11ShaderResourceView; lightDirection: TXMFLOAT3;
    diffuseColor: TXMFLOAT4; cameraPosition: TXMFLOAT3; specularColor: TXMFLOAT4; specularPower: single): HResult;
begin
    // Set the shader parameters that it will use for rendering.
    Result := SetShaderParameters(deviceContext, worldMatrix, viewMatrix, projectionMatrix, textureArray, lightDirection,
        diffuseColor, cameraPosition, specularColor, specularPower);
    if (Result <> S_OK) then Exit;

    // Now render the prepared buffers with the shader.
    RenderShader(deviceContext, indexCount);
end;

end.
