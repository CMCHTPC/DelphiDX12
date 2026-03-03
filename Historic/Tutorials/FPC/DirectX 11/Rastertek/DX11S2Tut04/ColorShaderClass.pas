unit ColorShaderClass;

{$mode delphiunicode}{$H+}

interface

uses
    Classes, SysUtils, Windows,
    DX12.D3D11, DX12.D3DCompiler,
    DX12.D3DCommon,
    DX12.DXGI,
    DX12.D3D10,
    DirectX.Math;

type
    TMatrixBufferType = record
        world: TXMMATRIX;
        view: TXMMATRIX;
        projection: TXMMATRIX;
    end;

    { TColorShaderClass }

    TColorShaderClass = class(TObject)
    private
        m_vertexShader: ID3D11VertexShader;
        m_pixelShader: ID3D11PixelShader;
        m_layout: ID3D11InputLayout;
        m_matrixBuffer: ID3D11Buffer;
    private
        function InitializeShader(device: ID3D11Device; hwnd: HWND; vsFilename, psFilename: WideString): HRESULT;
        procedure ShutdownShader();
        procedure OutputShaderErrorMessage(errorMessage: ID3D10Blob; hwnd: HWND; shaderFilename: WideString);
        function SetShaderParameters(deviceContext: ID3D11DeviceContext; worldMatrix: TXMMATRIX; viewMatrix: TXMMATRIX;
            projectionMatrix: TXMMATRIX): HRESULT;
        procedure RenderShader(deviceContext: ID3D11DeviceContext; indexCount: integer);
    public
        constructor Create;
        destructor Destroy; override;
        function Initialize(device: ID3D11Device; hwnd: HWND): HResult;
        procedure Shutdown();
        function Render(deviceContext: ID3D11DeviceContext; indexCount: integer; worldMatrix: TXMMATRIX;
            viewMatrix: TXMMATRIX; projectionMatrix: TXMMATRIX): HResult;
    end;

implementation

{ TColorShaderClass }

function TColorShaderClass.InitializeShader(device: ID3D11Device; hwnd: HWND; vsFilename, psFilename: WideString): HRESULT;
var
    errorMessage: ID3D10Blob;
    vertexShaderBuffer: ID3D10Blob;
    pixelShaderBuffer: ID3D10Blob;
    polygonLayout: array[0..1] of TD3D11_INPUT_ELEMENT_DESC;
    numElements: UINT;
    matrixBufferDesc: TD3D11_BUFFER_DESC;
begin
    // Initialize the pointers this function will use to null.

    // Compile the vertex shader code.
    Result := D3DCompileFromFile(pWideChar(vsFilename), nil, nil, 'ColorVertexShader', 'vs_5_0', D3D10_SHADER_ENABLE_STRICTNESS,
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
            MessageBoxW(hwnd, pWideChar(vsFilename), 'Missing Shader File', MB_OK);
        end;

        Exit;
    end;

    // Compile the pixel shader code.
    Result := D3DCompileFromFile(pWideChar(psFilename), nil, nil, 'ColorPixelShader', 'ps_5_0', D3D10_SHADER_ENABLE_STRICTNESS,
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
            MessageBoxW(hwnd, pWideChar(psFilename), 'Missing Shader File', MB_OK);
        end;

        Exit;
    end;

    // Create the vertex shader from the buffer.
    Result := device.CreateVertexShader(vertexShaderBuffer.GetBufferPointer(), vertexShaderBuffer.GetBufferSize(), nil, m_vertexShader);
    if (FAILED(Result)) then
        Exit;

    // Create the pixel shader from the buffer.
    Result := device.CreatePixelShader(pixelShaderBuffer.GetBufferPointer(), pixelShaderBuffer.GetBufferSize(), nil, m_pixelShader);
    if (FAILED(Result)) then
        Exit;

    // Create the vertex input layout description.
    // This setup needs to match the VertexType stucture in the ModelClass and in the shader.
    polygonLayout[0].SemanticName := 'POSITION';
    polygonLayout[0].SemanticIndex := 0;
    polygonLayout[0].Format := DXGI_FORMAT_R32G32B32_FLOAT;
    polygonLayout[0].InputSlot := 0;
    polygonLayout[0].AlignedByteOffset := 0;
    polygonLayout[0].InputSlotClass := D3D11_INPUT_PER_VERTEX_DATA;
    polygonLayout[0].InstanceDataStepRate := 0;

    polygonLayout[1].SemanticName := 'COLOR';
    polygonLayout[1].SemanticIndex := 0;
    polygonLayout[1].Format := DXGI_FORMAT_R32G32B32A32_FLOAT;
    polygonLayout[1].InputSlot := 0;
    polygonLayout[1].AlignedByteOffset := D3D11_APPEND_ALIGNED_ELEMENT;
    polygonLayout[1].InputSlotClass := D3D11_INPUT_PER_VERTEX_DATA;
    polygonLayout[1].InstanceDataStepRate := 0;

    // Get a count of the elements in the layout.
    numElements := sizeof(polygonLayout) div sizeof(polygonLayout[0]);

    // Create the vertex input layout.
    Result := device.CreateInputLayout(polygonLayout, numElements, vertexShaderBuffer.GetBufferPointer(),
        vertexShaderBuffer.GetBufferSize(), m_layout);
    if (FAILED(Result)) then
        Exit;

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
end;



procedure TColorShaderClass.ShutdownShader();
begin
    // Release the matrix constant buffer.
    m_matrixBuffer := nil;

    // Release the layout.
    m_layout := nil;

    // Release the pixel shader.
    m_pixelShader := nil;

    // Release the vertex shader.
    m_vertexShader := nil;
end;



procedure TColorShaderClass.OutputShaderErrorMessage(errorMessage: ID3D10Blob; hwnd: HWND; shaderFilename: WideString);
var
    compileErrors: PAnsiChar;
    lFileStream: TFileStream;
    bufferSize, i: UINT64;
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
    MessageBoxW(hwnd, 'Error compiling shader.  Check shader-error.txt for message.', pWideChar(shaderFilename), MB_OK);
end;



function TColorShaderClass.SetShaderParameters(deviceContext: ID3D11DeviceContext; worldMatrix: TXMMATRIX;
    viewMatrix: TXMMATRIX; projectionMatrix: TXMMATRIX): HRESULT;
var
    mappedResource: TD3D11_MAPPED_SUBRESOURCE;
    dataPtr: ^TMatrixBufferType;
    bufferNumber: UINT;
begin

    // Transpose the matrices to prepare them for the shader.
    worldMatrix := XMMatrixTranspose(worldMatrix);
    viewMatrix := XMMatrixTranspose(viewMatrix);
    projectionMatrix := XMMatrixTranspose(projectionMatrix);

    // Lock the constant buffer so it can be written to.
    Result := deviceContext.Map(m_matrixBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, mappedResource);
    if (FAILED(Result)) then
        Exit;

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
end;



procedure TColorShaderClass.RenderShader(deviceContext: ID3D11DeviceContext; indexCount: integer);
begin
    // Set the vertex input layout.
    deviceContext.IASetInputLayout(m_layout);

    // Set the vertex and pixel shaders that will be used to render this triangle.
    deviceContext.VSSetShader(m_vertexShader, nil, 0);
    deviceContext.PSSetShader(m_pixelShader, nil, 0);

    // Render the triangle.
    deviceContext.DrawIndexed(indexCount, 0, 0);
end;



constructor TColorShaderClass.Create;
begin

end;



destructor TColorShaderClass.Destroy;
begin
    inherited Destroy;
end;



function TColorShaderClass.Initialize(device: ID3D11Device; hwnd: HWND): HResult;
begin
    // Initialize the vertex and pixel shaders.
    Result := InitializeShader(device, hwnd, 'color.vs', 'color.ps');
end;



procedure TColorShaderClass.Shutdown();
begin
    // Shutdown the vertex and pixel shaders as well as the related objects.
    ShutdownShader();
end;



function TColorShaderClass.Render(deviceContext: ID3D11DeviceContext; indexCount: integer; worldMatrix: TXMMATRIX;
    viewMatrix: TXMMATRIX; projectionMatrix: TXMMATRIX): HResult;
begin
    // Set the shader parameters that it will use for rendering.
    Result := SetShaderParameters(deviceContext, worldMatrix, viewMatrix, projectionMatrix);
    if (Result <> S_OK) then
        Exit;

    // Now render the prepared buffers with the shader.
    RenderShader(deviceContext, indexCount);

    Result := s_OK;
end;

end.
