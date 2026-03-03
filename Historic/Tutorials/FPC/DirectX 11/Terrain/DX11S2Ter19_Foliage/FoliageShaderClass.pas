unit FoliageShaderClass;

{$mode Delphi}

interface

uses
    Classes, SysUtils, Windows,
    DX12.D3D11,
    DX12.D3DCommon,
    DX12.D3DCompiler,
    DX12.D3D10,
    DX12.DXGI,
    DirectX.Math;

type
    TMatrixBufferType = record
        view: TXMMATRIX;
        projection: TXMMATRIX;
    end;

    { TFoliageShaderClass }

    TFoliageShaderClass = class(TObject)
    private
        m_vertexShader: ID3D11VertexShader;
        m_pixelShader: ID3D11PixelShader;
        m_layout: ID3D11InputLayout;
        m_matrixBuffer: ID3D11Buffer;
        m_sampleState: ID3D11SamplerState;
    private
        function InitializeShader(device: ID3D11Device; hwnd: HWND; vsFilename, psFilename: WideString): HResult;
        procedure ShutdownShader();
        procedure OutputShaderErrorMessage(errorMessage: ID3D10Blob; hwnd: HWND; shaderFilename: WideString);

        function SetShaderParameters(deviceContext: ID3D11DeviceContext; viewMatrix, projectionMatrix: TXMMATRIX;
            texture: ID3D11ShaderResourceView): HResult;
        procedure RenderShader(deviceContext: ID3D11DeviceContext; vertexCount, instanceCount: integer);
    public
        constructor Create;
        destructor Destroy; override;
        function Initialize(device: ID3D11Device; hwnd: HWND): HResult;
        procedure Shutdown();
        function Render(deviceContext: ID3D11DeviceContext; vertexCount, instanceCount: integer;
            viewMatrix, projectionMatrix: TXMMATRIX; texture: ID3D11ShaderResourceView): HResult;
    end;

implementation

{ TFoliageShaderClass }

function TFoliageShaderClass.InitializeShader(device: ID3D11Device; hwnd: HWND;
				    vsFilename, psFilename: WideString): HResult;
var
    errorMessage: ID3D10Blob;
    vertexShaderBuffer: ID3D10Blob;
    pixelShaderBuffer: ID3D10Blob;
    polygonLayout: array [0..6] of TD3D11_INPUT_ELEMENT_DESC;
    numElements: uint32;
    matrixBufferDesc: TD3D11_BUFFER_DESC;
    samplerDesc: TD3D11_SAMPLER_DESC;
begin
    // Compile the vertex shader code.
    Result := D3DCompileFromFile(pwidechar(vsFilename), nil, nil, 'FoliageVertexShader', 'vs_5_0', D3D10_SHADER_ENABLE_STRICTNESS,
        0, vertexShaderBuffer, errorMessage);
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
    Result := D3DCompileFromFile(pwidechar(psFilename), nil, nil, 'FoliagePixelShader', 'ps_5_0', D3D10_SHADER_ENABLE_STRICTNESS,
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

    polygonLayout[2].SemanticName := 'WORLD';
    polygonLayout[2].SemanticIndex := 0;
    polygonLayout[2].Format := DXGI_FORMAT_R32G32B32A32_FLOAT;
    polygonLayout[2].InputSlot := 1;
    polygonLayout[2].AlignedByteOffset := 0;
    polygonLayout[2].InputSlotClass := D3D11_INPUT_PER_INSTANCE_DATA;
    polygonLayout[2].InstanceDataStepRate := 1;

    polygonLayout[3].SemanticName := 'WORLD';
    polygonLayout[3].SemanticIndex := 1;
    polygonLayout[3].Format := DXGI_FORMAT_R32G32B32A32_FLOAT;
    polygonLayout[3].InputSlot := 1;
    polygonLayout[3].AlignedByteOffset := D3D11_APPEND_ALIGNED_ELEMENT;
    polygonLayout[3].InputSlotClass := D3D11_INPUT_PER_INSTANCE_DATA;
    polygonLayout[3].InstanceDataStepRate := 1;

    polygonLayout[4].SemanticName := 'WORLD';
    polygonLayout[4].SemanticIndex := 2;
    polygonLayout[4].Format := DXGI_FORMAT_R32G32B32A32_FLOAT;
    polygonLayout[4].InputSlot := 1;
    polygonLayout[4].AlignedByteOffset := D3D11_APPEND_ALIGNED_ELEMENT;
    polygonLayout[4].InputSlotClass := D3D11_INPUT_PER_INSTANCE_DATA;
    polygonLayout[4].InstanceDataStepRate := 1;

    polygonLayout[5].SemanticName := 'WORLD';
    polygonLayout[5].SemanticIndex := 3;
    polygonLayout[5].Format := DXGI_FORMAT_R32G32B32A32_FLOAT;
    polygonLayout[5].InputSlot := 1;
    polygonLayout[5].AlignedByteOffset := D3D11_APPEND_ALIGNED_ELEMENT;
    polygonLayout[5].InputSlotClass := D3D11_INPUT_PER_INSTANCE_DATA;
    polygonLayout[5].InstanceDataStepRate := 1;

    polygonLayout[6].SemanticName := 'TEXCOORD';
    polygonLayout[6].SemanticIndex := 1;
    polygonLayout[6].Format := DXGI_FORMAT_R32G32B32_FLOAT;
    polygonLayout[6].InputSlot := 1;
    polygonLayout[6].AlignedByteOffset := D3D11_APPEND_ALIGNED_ELEMENT;
    polygonLayout[6].InputSlotClass := D3D11_INPUT_PER_INSTANCE_DATA;
    polygonLayout[6].InstanceDataStepRate := 1;

    // Get a count of the elements in the layout.
    numElements := Length(polygonLayout);

    // Create the vertex input layout.
    Result := device.CreateInputLayout(@polygonLayout[0], numElements, vertexShaderBuffer.GetBufferPointer(),
        vertexShaderBuffer.GetBufferSize(), m_layout);
    if (FAILED(Result)) then Exit;

    // Release the vertex shader buffer and pixel shader buffer since they are no longer needed.
    vertexShaderBuffer := nil;
    pixelShaderBuffer := nil;

    // Setup the description of the dynamic matrix buffer that is in the vertex shader.
    matrixBufferDesc.Usage := D3D11_USAGE_DYNAMIC;
    matrixBufferDesc.ByteWidth := sizeof(TMatrixBufferType);
    matrixBufferDesc.BindFlags := Ord(D3D11_BIND_CONSTANT_BUFFER);
    matrixBufferDesc.CPUAccessFlags := Ord(D3D11_CPU_ACCESS_WRITE);
    matrixBufferDesc.MiscFlags := 0;
    matrixBufferDesc.StructureByteStride := 0;

    // Create the matrix buffer pointer so we can access the vertex shader constant buffer from within this class.
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
    Result := device.CreateSamplerState(samplerDesc, m_sampleState);
end;



procedure TFoliageShaderClass.ShutdownShader();
begin
    // Release the sampler state.
    m_sampleState := nil;

    // Release the constant buffer.
    m_matrixBuffer := nil;

    // Release the layout.
    m_layout := nil;

    // Release the pixel shader.
    m_pixelShader := nil;

    // Release the vertex shader.
    m_vertexShader := nil;
end;



procedure TFoliageShaderClass.OutputShaderErrorMessage(errorMessage: ID3D10Blob; hwnd: HWND; shaderFilename: WideString);
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



function TFoliageShaderClass.SetShaderParameters(
				    deviceContext: ID3D11DeviceContext; viewMatrix,
				    projectionMatrix: TXMMATRIX; texture: ID3D11ShaderResourceView
				    ): HResult;
var
    mappedResource: TD3D11_MAPPED_SUBRESOURCE;
    dataPtr: ^TMatrixBufferType;
    bufferNumber: uint32;
begin
    // Transpose the matrices to prepare them for the shader.
    viewMatrix := XMMatrixTranspose(viewMatrix);
    projectionMatrix := XMMatrixTranspose(projectionMatrix);

    // Lock the constant buffer so it can be written to.
    Result := deviceContext.Map(m_matrixBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, mappedResource);
    if (Result <> S_OK) then Exit;

    // Get a pointer to the data in the constant buffer.
    dataPtr := mappedResource.pData;

    // Copy the matrices into the constant buffer.
    dataPtr.view := viewMatrix;
    dataPtr.projection := projectionMatrix;

    // Unlock the constant buffer.
    deviceContext.Unmap(m_matrixBuffer, 0);

    // Set the position of the constant buffer in the vertex shader.
    bufferNumber := 0;

    // Now set the constant buffer in the vertex shader with the updated values.
    deviceContext.VSSetConstantBuffers(bufferNumber, 1, @m_matrixBuffer);

    // Set shader texture resource in the pixel shader.
    deviceContext.PSSetShaderResources(0, 1, @texture);

    Result := S_OK;
end;



procedure TFoliageShaderClass.RenderShader(deviceContext: ID3D11DeviceContext; vertexCount, instanceCount: integer);
begin
    // Set the vertex input layout.
    deviceContext.IASetInputLayout(m_layout);

    // Set the vertex and pixel shaders that will be used to render the geometry.
    deviceContext.VSSetShader(m_vertexShader, nil, 0);
    deviceContext.PSSetShader(m_pixelShader, nil, 0);

    // Set the sampler state in the pixel shader.
    deviceContext.PSSetSamplers(0, 1, @m_sampleState);

    // Render the geometry.
    deviceContext.DrawInstanced(vertexCount, instanceCount, 0, 0);
end;



constructor TFoliageShaderClass.Create;
begin

end;



destructor TFoliageShaderClass.Destroy;
begin
    inherited Destroy;
end;



function TFoliageShaderClass.Initialize(device: ID3D11Device; hwnd: HWND
				    ): HResult;
begin
    // Initialize the vertex and pixel shaders.
    Result := InitializeShader(device, hwnd, '.\foliage.vs', '.\foliage.ps');
end;



procedure TFoliageShaderClass.Shutdown();
begin
    // Shutdown the vertex and pixel shaders as well as the related objects.
    ShutdownShader();
end;



function TFoliageShaderClass.Render(deviceContext: ID3D11DeviceContext;
				    vertexCount, instanceCount: integer; viewMatrix,
				    projectionMatrix: TXMMATRIX; texture: ID3D11ShaderResourceView
				    ): HResult;
begin
    // Set the shader parameters that it will use for rendering.
    Result := SetShaderParameters(deviceContext, viewMatrix, projectionMatrix, texture);
    if (Result <> S_OK) then Exit;
    // Now render the prepared buffers with the shader.
    RenderShader(deviceContext, vertexCount, instanceCount);
end;

end.
