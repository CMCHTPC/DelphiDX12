unit FontShaderClass;

interface

uses
	Classes, SysUtils, Windows,
	DX12.D3D11,
    DX12.D3D10,
    DX12.D3DCommon,
    DX12.DXGI,
    DX12.D3DX11,
	DX12.D3DX10;



type
TConstantBufferType=record
		 world:TD3DXMATRIX;
		 view:TD3DXMATRIX;
		 projection:TD3DXMATRIX;
	end;

	TPixelBufferType=record
		 pixelColor:TD3DXVECTOR4;
	end;

 TFontShaderClass = class (TObject)

private
	 m_vertexShader:ID3D11VertexShader;
	 m_pixelShader:ID3D11PixelShader;
	 m_layout:ID3D11InputLayout;
	 m_constantBuffer:ID3D11Buffer;
	 m_sampleState:ID3D11SamplerState;
	 m_pixelBuffer:ID3D11Buffer;

public
	constructor Create;
        destructor Destroy; override;

	function Initialize(device:ID3D11Device;  hwnd:HWND):HResult;
	procedure Shutdown();
	function Render(deviceContext:ID3D11DeviceContext;  indexCount:integer;
  worldMatrix,  viewMatrix,
							  projectionMatrix:TD3DXMATRIX; texture: ID3D11ShaderResourceView;  pixelColor:TD3DXVECTOR4):HResult;

private
	function InitializeShader(device:ID3D11Device;  hwnd:HWND;  vsFilename,  psFilename:widestring):HResult;
	procedure ShutdownShader();
	procedure OutputShaderErrorMessage(errorMessage:ID3D10Blob;  hwnd:HWND;  shaderFilename: widestring);

	function SetShaderParameters(deviceContext:ID3D11DeviceContext;  worldMatrix,  viewMatrix,
										   projectionMatrix:TD3DXMATRIX;  texture:ID3D11ShaderResourceView;  pixelColor:TD3DXVECTOR4):HResult;
	procedure RenderShader(deviceContext:ID3D11DeviceContext;  indexCount:integer);


end;

implementation

constructor TFontShaderClass.Create;
begin
	m_vertexShader := nil;
	m_pixelShader := nil;
	m_layout := nil;
	m_constantBuffer := nil;
	m_sampleState := nil;
	m_pixelBuffer := nil;
end;



destructor TFontShaderClass.Destroy;
begin
	inherited;
end;


function TFontShaderClass.Initialize( device:ID3D11Device;  hwnd:HWND) :HResult;
begin
	// Initialize the vertex and pixel shaders.
	result := InitializeShader(device, hwnd, 'font.vs', 'font.ps');
end;


procedure TFontShaderClass.Shutdown();
begin
	// Shutdown the vertex and pixel shaders as well as the related objects.
	ShutdownShader();
end;


function TFontShaderClass.Render( deviceContext:ID3D11DeviceContext;  indexCount:integer;
  worldMatrix,  viewMatrix,
							  projectionMatrix:TD3DXMATRIX; texture: ID3D11ShaderResourceView;  pixelColor:TD3DXVECTOR4)  :HResult;
begin
	// Set the shader parameters that it will use for rendering.
	result := SetShaderParameters(deviceContext, worldMatrix, viewMatrix, projectionMatrix, texture, pixelColor);
	if(result<>S_OK) then Exit;
	// Now render the prepared buffers with the shader.
	RenderShader(deviceContext, indexCount);
end;


function TFontShaderClass.InitializeShader( device:ID3D11Device;  hwnd:HWND;  vsFilename,  psFilename:widestring) :HResult;
var

    errorMessage:ID3D10Blob;
	 vertexShaderBuffer:ID3D10Blob;
	 pixelShaderBuffer:ID3D10Blob;
	 polygonLayout: array [0..1] of TD3D11_INPUT_ELEMENT_DESC;
	numElements:UINT32;
	 constantBufferDesc:TD3D11_BUFFER_DESC;
     samplerDesc:TD3D11_SAMPLER_DESC;
	 pixelBufferDesc:TD3D11_BUFFER_DESC;
begin

	// Initialize the pointers this function will use to nil.
	errorMessage := nil;
	vertexShaderBuffer := nil;
	pixelShaderBuffer := nil;

    // Compile the vertex shader code.
	result := D3DX11CompileFromFileW(PWideChar(vsFilename), nil, nil, 'FontVertexShader', 'vs_5_0', D3D10_SHADER_ENABLE_STRICTNESS, 0, nil,
								   &vertexShaderBuffer, errorMessage, nil);
	if(FAILED(result)) then
	begin
		// If the shader failed to compile it should have writen something to the error message.
		if(errorMessage<>nil) then
		begin
			OutputShaderErrorMessage(errorMessage, hwnd, vsFilename);
		end
		// If there was  nothing in the error message then it simply could not find the shader file itself.
		else
		begin
			MessageBoxW(hwnd, PWideChar(vsFilename), 'Missing Shader File', MB_OK);
		end;
        Exit;
	end;

    // Compile the pixel shader code.
	result := D3DX11CompileFromFileW(PWideChar(psFilename), nil, nil, 'FontPixelShader', 'ps_5_0', D3D10_SHADER_ENABLE_STRICTNESS, 0, nil,
								   pixelShaderBuffer, &errorMessage, nil);
	if(FAILED(result)) then
	begin
		// If the shader failed to compile it should have writen something to the error message.
		if(errorMessage<>nil) then
		begin
			OutputShaderErrorMessage(errorMessage, hwnd, psFilename);
		end
		// If there was  nothing in the error message then it simply could not find the file itself.
		else
		begin
			MessageBoxW(hwnd,PWideChar( psFilename), 'Missing Shader File', MB_OK);
		end;

	Exit;
	end;

    // Create the vertex shader from the buffer.
    result := device.CreateVertexShader(vertexShaderBuffer.GetBufferPointer(), vertexShaderBuffer.GetBufferSize(), nil, 
										m_vertexShader);
	if(FAILED(result)) then Exit;

    // Create the vertex shader from the buffer.
    result := device.CreatePixelShader(pixelShaderBuffer.GetBufferPointer(), pixelShaderBuffer.GetBufferSize(), nil, 
									   m_pixelShader);
	if(FAILED(result)) then Exit;

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

	// Get a count of the elements in the layout.
    numElements := Length(polygonLayout);

	// Create the vertex input layout.
	result := device.CreateInputLayout(@polygonLayout[0], numElements, vertexShaderBuffer.GetBufferPointer(),
									   vertexShaderBuffer.GetBufferSize(), m_layout);
		if(FAILED(result)) then Exit;

	// Release the vertex shader buffer and pixel shader buffer since they are no longer needed.
	vertexShaderBuffer := nil;
	pixelShaderBuffer := nil;

    // Setup the description of the dynamic constant buffer that is in the vertex shader.
    constantBufferDesc.Usage := D3D11_USAGE_DYNAMIC;
	constantBufferDesc.ByteWidth := sizeof(TConstantBufferType);
    constantBufferDesc.BindFlags := ord(D3D11_BIND_CONSTANT_BUFFER);
    constantBufferDesc.CPUAccessFlags := ord( D3D11_CPU_ACCESS_WRITE);
    constantBufferDesc.MiscFlags := 0;
	constantBufferDesc.StructureByteStride := 0;

	// Create the constant buffer pointer so we can access the vertex shader constant buffer from within this class.
	result := device.CreateBuffer(&constantBufferDesc, nil, &m_constantBuffer);
	if(FAILED(result)) then Exit;

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
    result := device.CreateSamplerState(samplerDesc, m_sampleState);
	if(FAILED(result)) then Exit;

    // Setup the description of the dynamic pixel constant buffer that is in the pixel shader.
    pixelBufferDesc.Usage := D3D11_USAGE_DYNAMIC;
	pixelBufferDesc.ByteWidth := sizeof(TPixelBufferType);
    pixelBufferDesc.BindFlags := ord(D3D11_BIND_CONSTANT_BUFFER);
    pixelBufferDesc.CPUAccessFlags := ord(D3D11_CPU_ACCESS_WRITE);
    pixelBufferDesc.MiscFlags := 0;
	pixelBufferDesc.StructureByteStride := 0;

	// Create the pixel constant buffer pointer so we can access the pixel shader constant buffer from within this class.
	result := device.CreateBuffer(pixelBufferDesc, nil, m_pixelBuffer);
end;


procedure TFontShaderClass.ShutdownShader();
begin
	// Release the pixel constant buffer.
		m_pixelBuffer := nil;

	// Release the sampler state.
		m_sampleState := nil;

	// Release the constant buffer.
		m_constantBuffer := nil;

	// Release the layout.
		m_layout := nil;

	// Release the pixel shader.
		m_pixelShader := nil;

	// Release the vertex shader.
		m_vertexShader := nil;
end;


procedure TFontShaderClass.OutputShaderErrorMessage(errorMessage:ID3D10Blob;  hwnd:HWND;  shaderFilename: widestring) ;
begin
(*
	char* compileErrors;
	unsigned long bufferSize, i;
	ofstream fout;


	// Get a pointer to the error message text buffer.
	compileErrors := (char* )(errorMessage.GetBufferPointer());

	// Get the length of the message.
	bufferSize := errorMessage.GetBufferSize();

	// Open a file to write the error message to.
	fout.open('shader-error.txt');

	// Write out the error message.
	for(i:=0; i<bufferSize; i++)
	begin
		fout << compileErrors[i];
	end;

	// Close the file.
	fout.close();

	// Release the error message.
	errorMessage.Release();
	errorMessage := 0;

	// Pop a message up on the screen to notify the user to check the text file for compile errors.
	MessageBox(hwnd, 'Error compiling shader.  Check shader-error.txt for message.', shaderFilename, MB_OK);

	return;  *)
end;


function TFontShaderClass.SetShaderParameters( deviceContext:ID3D11DeviceContext;  worldMatrix,  viewMatrix,
										   projectionMatrix:TD3DXMATRIX;  texture:ID3D11ShaderResourceView;  pixelColor:TD3DXVECTOR4) :HResult;
var
     mappedResource:TD3D11_MAPPED_SUBRESOURCE;
	 dataPtr:^TConstantBufferType;
	 bufferNumber:UINT32;
	dataPtr2 :^TPixelBufferType;

 begin
	// Lock the constant buffer so it can be written to.
	result := deviceContext.Map(m_constantBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);
	if(FAILED(result))  then Exit;
	// Get a pointer to the data in the constant buffer.
	dataPtr := mappedResource.pData;

	// Transpose the matrices to prepare them for the shader.
	D3DXMatrixTranspose(@worldMatrix, @worldMatrix);
	D3DXMatrixTranspose(@viewMatrix, @viewMatrix);
	D3DXMatrixTranspose(@projectionMatrix, @projectionMatrix);

	// Copy the matrices into the constant buffer.
	dataPtr.world := worldMatrix;
	dataPtr.view := viewMatrix;
	dataPtr.projection := projectionMatrix;

	// Unlock the constant buffer.
    deviceContext.Unmap(m_constantBuffer, 0);

	// Set the position of the constant buffer in the vertex shader.
	bufferNumber := 0;

	// Now set the constant buffer in the vertex shader with the updated values.
    deviceContext.VSSetConstantBuffers(bufferNumber, 1, @m_constantBuffer);

	// Set shader texture resource in the pixel shader.
	deviceContext.PSSetShaderResources(0, 1, @texture);

	// Lock the pixel constant buffer so it can be written to.
	result := deviceContext.Map(m_pixelBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);
	if(FAILED(result)) then Exit;

	// Get a pointer to the data in the pixel constant buffer.
	dataPtr2 := mappedResource.pData;

	// Copy the pixel color into the pixel constant buffer.
	dataPtr2.pixelColor := pixelColor;

	// Unlock the pixel constant buffer.
    deviceContext.Unmap(m_pixelBuffer, 0);

	// Set the position of the pixel constant buffer in the pixel shader.
	bufferNumber := 0;

	// Now set the pixel constant buffer in the pixel shader with the updated value.
    deviceContext.PSSetConstantBuffers(bufferNumber, 1, @m_pixelBuffer);

	Result:=S_OK;
end;


procedure TFontShaderClass.RenderShader(deviceContext:ID3D11DeviceContext;  indexCount:integer) ;
begin
	// Set the vertex input layout.
	deviceContext.IASetInputLayout(m_layout);

    // Set the vertex and pixel shaders that will be used to render the triangles.
    deviceContext.VSSetShader(m_vertexShader, nil, 0);
    deviceContext.PSSetShader(m_pixelShader, nil, 0);

	// Set the sampler state in the pixel shader.
	deviceContext.PSSetSamplers(0, 1, @m_sampleState);

	// Render the triangles.
	deviceContext.DrawIndexed(indexCount, 0, 0);
end;


end.