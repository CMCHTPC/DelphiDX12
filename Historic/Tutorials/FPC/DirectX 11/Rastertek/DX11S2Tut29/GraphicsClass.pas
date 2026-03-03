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
    LightClass,
    RenderTextureClass,
    LightShaderClass,
    RefractionShaderClass,
    WaterShaderClass;

const
    FULL_SCREEN: boolean = True;
    VSYNC_ENABLED: boolean = True;
    SCREEN_DEPTH: single = 1000.0;
    SCREEN_NEAR: single = 0.1;



type

    { TGraphicsClass }

    TGraphicsClass = class(TObject)
    private
        m_Direct3D: TD3DClass;
        m_Camera: TCameraClass;
        m_GroundModel: TModelClass;
        m_WallModel: TModelClass;
        m_BathModel: TModelClass;
        m_WaterModel: TModelClass;
        m_Light: TLightClass;

        //        m_TextureShader: TTextureShaderClass;

        m_RefractionTexture, m_ReflectionTexture: TRenderTextureClass;
        m_LightShader: TLightShaderClass;
        m_RefractionShader: TRefractionShaderClass;
        m_WaterShader: TWaterShaderClass;
        m_waterHeight, m_waterTranslation: single;
    private
        FRotation: single;
        function RenderRefractionToTexture(): HResult;
        function RenderReflectionToTexture(): HResult;
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
begin

    // Render the refraction of the scene to a texture.
    Result := RenderRefractionToTexture();
    if Result <> S_OK then Exit;

    // Render the reflection of the scene to a texture.
    Result := RenderReflectionToTexture();
    if Result <> S_OK then Exit;

    // Render the scene as normal to the back buffer.
    Result := RenderScene();

end;



function TGraphicsClass.RenderRefractionToTexture(): HResult;
var
    worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX;
    clipPlane: TXMFLOAT4;
begin
    // Setup a clipping plane based on the height of the water to clip everything above it.
    clipPlane := TXMFLOAT4.Create(0.0, -1.0, 0.0, m_waterHeight + 0.1);

    // Set the render target to be the render to texture.
    m_RefractionTexture.SetRenderTarget(m_Direct3D.GetDeviceContext(), m_Direct3D.GetDepthStencilView());

    // Clear the render to texture.
    m_RefractionTexture.ClearRenderTarget(m_Direct3D.GetDeviceContext(), m_Direct3D.GetDepthStencilView(), 0.0, 0.0, 0.0, 1.0);

    // Generate the view matrix based on the camera's position.
    m_Camera.Render();


    // Get the world and projection matrices.
    worldMatrix := m_Direct3D.GetWorldMatrix();
    projectionMatrix := m_Direct3D.GetProjectionMatrix();
    viewMatrix := m_Camera.GetViewMatrix();

    // Translate to where the bath model will be rendered.
    worldMatrix := XMMatrixTranslation(0.0, 2.0, 0.0);

    // Put the bath model vertex and index buffers on the graphics pipeline to prepare them for drawing.
    m_BathModel.Render(m_Direct3D.GetDeviceContext());

    // Render the bath model using the light shader.
    Result := m_RefractionShader.Render(m_Direct3D.GetDeviceContext(), m_BathModel.GetIndexCount(), worldMatrix,
        viewMatrix, projectionMatrix, m_BathModel.GetTexture(), m_Light.GetDirection(), m_Light.GetAmbientColor(),
        m_Light.GetDiffuseColor(), clipPlane);

    // Reset the render target back to the original back buffer and not the render to texture anymore.
    m_Direct3D.SetBackBufferRenderTarget();
    Result := S_OK;
end;




function TGraphicsClass.RenderReflectionToTexture(): HResult;
var
    worldMatrix, viewMatrix, projectionMatrix, reflectionViewMatrix, orthoMatrix: TXMMATRIX;
begin
    // Set the render target to be the reflection render to texture.
    m_ReflectionTexture.SetRenderTarget(m_Direct3D.GetDeviceContext(), m_Direct3D.GetDepthStencilView());

    // Clear the reflection render to texture.
    m_ReflectionTexture.ClearRenderTarget(m_Direct3D.GetDeviceContext(), m_Direct3D.GetDepthStencilView(), 0.0, 0.0, 0.0, 1.0);

    // Use the camera to render the reflection and create a reflection view matrix.
    m_Camera.RenderReflection(m_waterHeight);

    // Get the camera reflection view matrix instead of the normal view matrix.
    reflectionViewMatrix := m_Camera.GetReflectionViewMatrix();

    // Get the world and projection matrices from the d3d object.
    worldMatrix := m_Direct3D.GetWorldMatrix();
    projectionMatrix := m_Direct3D.GetProjectionMatrix();

    // Translate to where the wall model will be rendered.
    worldMatrix := XMMatrixTranslation(0.0, 6.0, 8.0);

    // Put the wall model vertex and index buffers on the graphics pipeline to prepare them for drawing.
    m_WallModel.Render(m_Direct3D.GetDeviceContext());

    // Render the wall model using the light shader and the reflection view matrix.
    Result := m_LightShader.Render(m_Direct3D.GetDeviceContext(), m_WallModel.GetIndexCount(), worldMatrix,
        reflectionViewMatrix, projectionMatrix, m_WallModel.GetTexture(), m_Light.GetDirection(), m_Light.GetAmbientColor(),
        m_Light.GetDiffuseColor());
    if (Result <> S_OK) then Exit;


    // Reset the render target back to the original back buffer and not the render to texture anymore.
    m_Direct3D.SetBackBufferRenderTarget();

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
    worldMatrix := m_Direct3D.GetWorldMatrix();
    viewMatrix := m_Camera.GetViewMatrix();
    projectionMatrix := m_Direct3D.GetProjectionMatrix();

    // Translate to where the ground model will be rendered.
    worldMatrix := XMMatrixTranslation(0.0, 1.0, 0.0);


    // Put the ground model vertex and index buffers on the graphics pipeline to prepare them for drawing.
    m_GroundModel.Render(m_Direct3D.GetDeviceContext());

    // Render the ground model using the light shader.
    Result := m_LightShader.Render(m_Direct3D.GetDeviceContext(), m_GroundModel.GetIndexCount(), worldMatrix,
        viewMatrix, projectionMatrix, m_GroundModel.GetTexture(), m_Light.GetDirection(), m_Light.GetAmbientColor(), m_Light.GetDiffuseColor());
    if (Result <> S_OK) then
        Exit;

    // Reset the world matrix.
    worldMatrix := m_Direct3D.GetWorldMatrix();

    // Translate to where the wall model will be rendered.
    worldMatrix := XMMatrixTranslation(0.0, 6.0, 8.0);


    // Put the wall model vertex and index buffers on the graphics pipeline to prepare them for drawing.
    m_WallModel.Render(m_Direct3D.GetDeviceContext());

    // Render the wall model using the light shader.
    Result := m_LightShader.Render(m_Direct3D.GetDeviceContext(), m_WallModel.GetIndexCount(), worldMatrix,
        viewMatrix, projectionMatrix, m_WallModel.GetTexture(), m_Light.GetDirection(), m_Light.GetAmbientColor(), m_Light.GetDiffuseColor());
    if (Result <> S_OK) then
        Exit;

    // Reset the world matrix.
    worldMatrix := m_Direct3D.GetWorldMatrix();

    // Translate to where the bath model will be rendered.
    worldMatrix := XMMatrixTranslation(0.0, 2.0, 0.0);


    // Put the bath model vertex and index buffers on the graphics pipeline to prepare them for drawing.
    m_BathModel.Render(m_Direct3D.GetDeviceContext());

    // Render the bath model using the light shader.
    Result := m_LightShader.Render(m_Direct3D.GetDeviceContext(), m_BathModel.GetIndexCount(), worldMatrix,
        viewMatrix, projectionMatrix, m_BathModel.GetTexture(), m_Light.GetDirection(), m_Light.GetAmbientColor(), m_Light.GetDiffuseColor());
    if (Result <> S_OK) then
        Exit;

    // Reset the world matrix.
    worldMatrix := m_Direct3D.GetWorldMatrix();

    // Get the camera reflection view matrix.
    reflectionMatrix := m_Camera.GetReflectionViewMatrix();

    // Translate to where the water model will be rendered.
    worldMatrix := XMMatrixTranslation(0.0, m_waterHeight, 0.0);

    // Put the water model vertex and index buffers on the graphics pipeline to prepare them for drawing.
    m_WaterModel.Render(m_Direct3D.GetDeviceContext());

    // Render the water model using the water shader.
    Result := m_WaterShader.Render(m_Direct3D.GetDeviceContext(), m_WaterModel.GetIndexCount(), worldMatrix, viewMatrix,
        projectionMatrix, reflectionMatrix, m_ReflectionTexture.GetShaderResourceView(), m_RefractionTexture.GetShaderResourceView(),
        m_WaterModel.GetTexture(), m_waterTranslation, 0.01);
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

    // Create the ground model object.
    m_GroundModel := TModelClass.Create;


    // Initialize the ground model object.
    Result := m_GroundModel.Initialize(m_Direct3D.GetDevice(), m_Direct3D.GetDeviceContext(), 'ground.txt', 'ground01.dds');
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the ground model object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the wall model object.
    m_WallModel := TModelClass.Create;

    // Initialize the wall model object.
    Result := m_WallModel.Initialize(m_Direct3D.GetDevice(), m_Direct3D.GetDeviceContext(), 'wall.txt', 'wall01.dds');
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the wall model object.', 'Error', MB_OK);
        Exit;
    end;


    // Create the bath model object.
    m_BathModel := TModelClass.Create;

    // Initialize the bath model object.
    Result := m_BathModel.Initialize(m_Direct3D.GetDevice(), m_Direct3D.GetDeviceContext(), 'bath.txt', 'marble01.dds');
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the bath model object.', 'Error', MB_OK);
        Exit;
    end;


    // Create the water model object.
    m_WaterModel := TModelClass.Create;
    // Initialize the water model object.
    Result := m_WaterModel.Initialize(m_Direct3D.GetDevice(), m_Direct3D.GetDeviceContext(), 'water.txt', 'water01.dds');
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the water model object.', 'Error', MB_OK);
        Exit;
    end;


    // Create the light object.
    m_Light := TLightClass.Create;

    // Initialize the light object.
    m_Light.SetAmbientColor(0.15, 0.15, 0.15, 1.0);
    m_Light.SetDiffuseColor(1.0, 1.0, 1.0, 1.0);
    m_Light.SetDirection(0.0, -1.0, 0.5);

    // Create the refraction render to texture object.
    m_RefractionTexture := TRenderTextureClass.Create;

    // Initialize the refraction render to texture object.
    Result := m_RefractionTexture.Initialize(m_Direct3D.GetDevice(), screenWidth, screenHeight);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the refraction render to texture object.', 'Error', MB_OK);
        Exit;
    end;


    // Create the reflection render to texture object.
    m_ReflectionTexture := TRenderTextureClass.Create;
    // Initialize the reflection render to texture object.
    Result := m_ReflectionTexture.Initialize(m_Direct3D.GetDevice(), screenWidth, screenHeight);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the reflection render to texture object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the light shader object.
    m_LightShader := TLightShaderClass.Create;
    // Initialize the light shader object.
    Result := m_LightShader.Initialize(m_Direct3D.GetDevice(), hwnd);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the light shader object.', 'Error', MB_OK);
        Exit;
    end;


    // Create the refraction shader object.
    m_RefractionShader := TRefractionShaderClass.Create;
    // Initialize the refraction shader object.
    Result := m_RefractionShader.Initialize(m_Direct3D.GetDevice(), hwnd);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the refraction shader object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the water shader object.
    m_WaterShader := TWaterShaderClass.Create;


    // Initialize the water shader object.
    Result := m_WaterShader.Initialize(m_Direct3D.GetDevice(), hwnd);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the water shader object.', 'Error', MB_OK);
        Exit;
    end;


    // Set the height of the water.
    m_waterHeight := 2.75;

    // Initialize the position of the water.
    m_waterTranslation := 0.0;

end;



procedure TGraphicsClass.Shutdown();
begin
    // Release the water shader object.
    if (m_WaterShader <> nil) then
    begin
        m_WaterShader.Shutdown();
        m_WaterShader.Free;
        m_WaterShader := nil;
    end;

    // Release the refraction shader object.
    if (m_RefractionShader <> nil) then
    begin
        m_RefractionShader.Shutdown();
        m_RefractionShader.Free;
        m_RefractionShader := nil;
    end;

    // Release the light shader object.
    if (m_LightShader <> nil) then
    begin
        m_LightShader.Shutdown();
        m_LightShader.Free;
        m_LightShader := nil;
    end;

    // Release the reflection render to texture object.
    if (m_ReflectionTexture <> nil) then
    begin
        m_ReflectionTexture.Shutdown();
        m_ReflectionTexture.Free;
        m_ReflectionTexture := nil;
    end;

    // Release the refraction render to texture object.
    if (m_RefractionTexture <> nil) then
    begin
        m_RefractionTexture.Shutdown();
        m_RefractionTexture.Free;
        m_RefractionTexture := nil;
    end;

    // Release the light object.
    m_Light := nil;


    // Release the water model object.
    if (m_WaterModel <> nil) then
    begin
        m_WaterModel.Shutdown();
        m_WaterModel.Free;
        m_WaterModel := nil;
    end;

    // Release the bath model object.
    if (m_BathModel <> nil) then
    begin
        m_BathModel.Shutdown();
        m_BathModel.Free;
        m_BathModel := nil;
    end;

    // Release the wall model object.
    if (m_WallModel <> nil) then
    begin
        m_WallModel.Shutdown();
        m_WallModel.Free;
        m_WallModel := nil;
    end;

    // Release the ground model object.
    if (m_GroundModel <> nil) then
    begin
        m_GroundModel.Shutdown();
        m_GroundModel.Free;
        m_GroundModel := nil;
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
    // Update the position of the water to simulate motion.
    m_waterTranslation := m_waterTranslation + 0.001;
    if (m_waterTranslation > 1.0) then
    begin
        m_waterTranslation := m_waterTranslation - 1.0;
    end;

    // Set the position and rotation of the camera.
    m_Camera.SetPosition(-10.0, 6.0, -10.0);
    m_Camera.SetRotation(0.0, 45.0, 0.0);

end;

end.
