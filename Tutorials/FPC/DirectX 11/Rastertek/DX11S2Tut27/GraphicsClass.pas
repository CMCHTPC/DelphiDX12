unit GraphicsClass;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$ENDIF}

interface

uses
    Classes, SysUtils, Windows,
    DirectX.Math,
    D3DClass, CameraClass,
    ModelClass,
    TextureShaderClass,
    RenderTextureClass,
    ReflectionShaderClass;

const
    FULL_SCREEN: boolean = False;
    VSYNC_ENABLED: boolean = True;
    SCREEN_DEPTH: single = 1000.0;
    SCREEN_NEAR: single = 0.1;



type

    { TGraphicsClass }

    TGraphicsClass = class(TObject)
    private
        m_Direct3D: TD3DClass;
        m_Camera: TCameraClass;
        m_Model: TModelClass;
        m_FloorModel: TModelClass;
        m_TextureShader: TTextureShaderClass;
        m_RenderTexture: TRenderTextureClass;
        m_ReflectionShader: TReflectionShaderClass;
    private
        FRotation1: single;
        FRotation2: single;

        FTextureTranslation: single;
        function RenderToTexture(): HResult;
        function RenderScene(): HResult;
    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(screenWidth, screenHeight: integer; hwnd: HWND): HResult;
        procedure Shutdown();
        function Frame(): HResult;
        function Render(): HResult;
    end;

implementation

{ TGraphicsClass }

function TGraphicsClass.Render(): HResult;
var
    worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX;
    clipPlane: TXMFLOAT4;
    blendAmount: single;
begin
    // Render the entire scene as a reflection to the texture first.
    Result := RenderToTexture();
    if Result <> S_OK then Exit;

    // Render the scene as normal to the back buffer.
    Result := RenderScene();
end;



function TGraphicsClass.RenderToTexture(): HResult;
var
    worldMatrix, reflectionViewMatrix, projectionMatrix: TXMMATRIX;
begin
    // Set the render target to be the render to texture.
    m_RenderTexture.SetRenderTarget(m_Direct3D.GetDeviceContext(), m_Direct3D.GetDepthStencilView());

    // Clear the render to texture.
    m_RenderTexture.ClearRenderTarget(m_Direct3D.GetDeviceContext(), m_Direct3D.GetDepthStencilView(), 0.0, 0.0, 0.0, 1.0);

    // Use the camera to calculate the reflection matrix.
    m_Camera.RenderReflection(-1.5);

    // Get the camera reflection view matrix instead of the normal view matrix.
    reflectionViewMatrix := m_Camera.GetReflectionViewMatrix();

    // Get the world and projection matrices.
    worldMatrix := m_Direct3D.GetWorldMatrix();
    projectionMatrix := m_Direct3D.GetProjectionMatrix();

    // Update the rotation variable each frame.
    FRotation1 := FRotation1 + XM_PI * 0.005;
    if (FRotation1 > 360.0) then
        FRotation1 := FRotation1 - 360.0;

    worldMatrix := XMMatrixRotationY(FRotation1);

    // Put the model vertex and index buffers on the graphics pipeline to prepare them for drawing.
    m_Model.Render(m_Direct3D.GetDeviceContext());

    // Render the model using the texture shader and the reflection view matrix.
    m_TextureShader.Render(m_Direct3D.GetDeviceContext(), m_Model.GetIndexCount(), worldMatrix, reflectionViewMatrix,
        projectionMatrix, m_Model.GetTexture());

    // Reset the render target back to the original back buffer and not the render to texture anymore.
    m_Direct3D.SetBackBufferRenderTarget();
    Result := S_OK;
end;




function TGraphicsClass.RenderScene(): HResult;
var
    worldMatrix, viewMatrix, projectionMatrix, reflectionMatrix: TXMMATRIX;
begin
    // Clear the buffers to begin the scene.
    m_Direct3D.BeginScene(0.0, 0.0, 0.0, 1.0);

    // Generate the view matrix based on the camera's position.
    m_Camera.Render();

    // Get the world, view, and projection matrices from the camera and d3d objects.
    worldMatrix := m_Direct3D.GetWorldMatrix;
    viewMatrix := m_Camera.GetViewMatrix;
    projectionMatrix := m_Direct3D.GetProjectionMatrix;

    // Update the rotation variable each frame.
    FRotation2 := FRotation2 + XM_PI * 0.005;
    if (FRotation2 > 360.0) then
        FRotation2 := FRotation2 - 360.0;

    // Multiply the world matrix by the rotation.
    worldMatrix := XMMatrixRotationY(FRotation2);


    // Put the model vertex and index buffers on the graphics pipeline to prepare them for drawing.
    m_Model.Render(m_Direct3D.GetDeviceContext());

    // Render the model with the texture shader.
    Result := m_TextureShader.Render(m_Direct3D.GetDeviceContext(), m_Model.GetIndexCount(), worldMatrix,
        viewMatrix, projectionMatrix, m_Model.GetTexture());
    if (Result <> S_OK) then
        Exit;

    // Get the world matrix again and translate down for the floor model to render underneath the cube.
    worldMatrix := XMMatrixTranslation(0.0, -1.5, 0.0);

    // Get the camera reflection view matrix.
    reflectionMatrix := m_Camera.GetReflectionViewMatrix();

    // Put the floor model vertex and index buffers on the graphics pipeline to prepare them for drawing.
    m_FloorModel.Render(m_Direct3D.GetDeviceContext());

    // Render the floor model using the reflection shader, reflection texture, and reflection view matrix.
    Result := m_ReflectionShader.Render(m_Direct3D.GetDeviceContext(), m_FloorModel.GetIndexCount(), worldMatrix,
        viewMatrix, projectionMatrix, m_FloorModel.GetTexture(), m_RenderTexture.GetShaderResourceView(), reflectionMatrix);
    if (Result <> S_OK) then
        Exit;

    // Present the rendered scene to the screen.
    m_Direct3D.EndScene();
end;



constructor TGraphicsClass.Create;
begin

end;



destructor TGraphicsClass.Destroy;
begin
    inherited Destroy;
end;



function TGraphicsClass.Initialize(screenWidth, screenHeight: integer; hwnd: HWND): HResult;
begin
    // Create the Direct3D object.
    m_Direct3D := TD3DClass.Create;

    // Initialize the Direct3D object.
    Result := m_Direct3D.Initialize(screenWidth, screenHeight, VSYNC_ENABLED, hwnd, FULL_SCREEN, SCREEN_DEPTH, SCREEN_NEAR);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize Direct3D.', 'Error', MB_OK);
        Exit;
    end;

    // Create the camera object.
    m_Camera := TCameraClass.Create;


    // Create the model object.
    m_Model := TModelClass.Create;

    // Initialize the model object.
    Result := m_Model.Initialize(m_Direct3D.GetDevice(), m_Direct3D.GetDeviceContext(), 'cube.txt', 'seafloor.dds');
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the model object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the texture shader object.
    m_TextureShader := TTextureShaderClass.Create;
    Result := m_TextureShader.Initialize(m_Direct3D.GetDevice(), hwnd);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the exture shader object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the render to texture object.
    m_RenderTexture := TRenderTextureClass.Create;
    // Initialize the render to texture object.
    Result := m_RenderTexture.Initialize(m_Direct3D.GetDevice(), screenWidth, screenHeight);
    if (Result <> S_OK) then Exit;

    // Create the floor model object.
    m_FloorModel := TModelClass.Create;
    Result := m_FloorModel.Initialize(m_Direct3D.GetDevice(), m_Direct3D.GetDeviceContext(), 'floor.txt', 'blue01.dds');
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the model object.', 'Error', MB_OK);
        Exit;
    end;



    // Create the reflection shader object.
    m_ReflectionShader := TReflectionShaderClass.Create;
    Result := m_ReflectionShader.Initialize(m_Direct3D.GetDevice(), hwnd);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the reflection shader object.', 'Error', MB_OK);
        Exit;
    end;
end;



procedure TGraphicsClass.Shutdown();
begin
    // Release the color shader object.
    if (m_ReflectionShader <> nil) then
    begin
        m_ReflectionShader.Shutdown();
        m_ReflectionShader.Free;
        m_ReflectionShader := nil;
    end;


    // Release the color shader object.
    if (m_RenderTexture <> nil) then
    begin
        m_RenderTexture.Shutdown();
        m_RenderTexture.Free;
        m_RenderTexture := nil;
    end;

    // Release the color shader object.
    if (m_TextureShader <> nil) then
    begin
        m_TextureShader.Shutdown();
        m_TextureShader.Free;
        m_TextureShader := nil;
    end;

    // Release the model object.
    if (m_Model <> nil) then
    begin
        m_Model.Shutdown();
        m_Model.Free;
        m_Model := nil;
    end;

    // Release the model object.
    if (m_FloorModel <> nil) then
    begin
        m_FloorModel.Shutdown();
        m_FloorModel.Free;
        m_FloorModel := nil;
    end;

    // Release the camera object.
    if (m_Camera <> nil) then
    begin
        m_Camera.Free;
        m_Camera := nil;
    end;

    // Release the D3D object.
    if (m_Direct3D <> nil) then
    begin
        m_Direct3D.Shutdown();
        m_Direct3D.Free;
        m_Direct3D := nil;
    end;
end;



function TGraphicsClass.Frame(): HResult;
begin
    // Set the initial position of the camera.
    m_Camera.SetPosition(0.0, 0.0, -10.0);
end;

end.
