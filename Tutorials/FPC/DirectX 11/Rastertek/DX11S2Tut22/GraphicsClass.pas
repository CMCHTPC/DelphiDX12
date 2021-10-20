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
    LightClass, LightShaderClass,
    RenderTextureClass,
    TextureShaderclass,
    DebugWindowClass;

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
        m_LightShader: TLightShaderClass;
        m_Light: TLightClass;

        m_RenderTexture: TRenderTextureClass;
        m_DebugWindow: TDebugWindowClass;
        m_TextureShader: TTextureShaderClass;
        FRotation: single;
    private
        function RenderToTexture: HResult;
        function RenderScene: HResult;
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
    orthoMatrix: TXMMATRIX;
begin

    // Render the entire scene to the texture first.
    Result := RenderToTexture();
    if (Result <> S_OK) then Exit;

    // Clear the buffers to begin the scene.
    m_Direct3D.BeginScene(0.0, 0.0, 0.0, 1.0);

    // Render the scene as normal to the back buffer.
    Result := RenderScene();
    if (Result <> S_OK) then Exit;

    // Turn off the Z buffer to begin all 2D rendering.
    m_Direct3D.TurnZBufferOff();


    // Get the world, view, projection, and world matrices from the camera and d3d objects.
    worldMatrix := m_Direct3D.GetWorldMatrix;
    viewMatrix := m_Camera.GetViewMatrix;
    projectionMatrix := m_Direct3D.GetProjectionMatrix;
    orthoMatrix := m_Direct3D.GetOrthoMatrix();

    // Put the debug window vertex and index buffers on the graphics pipeline to prepare them for drawing.
    Result := m_DebugWindow.Render(m_Direct3D.GetDeviceContext(), 50, 50);
    if (Result <> S_OK) then Exit;

    // Render the debug window using the texture shader.
    Result := m_TextureShader.Render(m_Direct3D.GetDeviceContext(), m_DebugWindow.GetIndexCount(), worldMatrix,
        viewMatrix, orthoMatrix, m_RenderTexture.GetShaderResourceView());
    if (Result <> S_OK) then Exit;

    // Turn the Z buffer back on now that all 2D rendering has completed.
    m_Direct3D.TurnZBufferOn();

    // Present the rendered scene to the screen.
    m_Direct3D.EndScene();

    Result := S_OK;
end;



function TGraphicsClass.RenderToTexture: HResult;
begin
    // Set the render target to be the render to texture.
    m_RenderTexture.SetRenderTarget(m_Direct3D.GetDeviceContext(), m_Direct3D.GetDepthStencilView());

    // Clear the render to texture.
    m_RenderTexture.ClearRenderTarget(m_Direct3D.GetDeviceContext(), m_Direct3D.GetDepthStencilView(), 0.0, 0.0, 1.0, 1.0);

    // Render the scene now and it will draw to the render to texture instead of the back buffer.
    Result := RenderScene();
    if (Result <> S_OK) then Exit;

    // Reset the render target back to the original back buffer and not the render to texture anymore.
    m_Direct3D.SetBackBufferRenderTarget();
end;



function TGraphicsClass.RenderScene: HResult;
var
    worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX;
begin
    // Generate the view matrix based on the camera's position.
    m_Camera.Render();

    // Get the world, view, and projection matrices from the camera and d3d objects.
    worldMatrix := m_Direct3D.GetWorldMatrix;
    viewMatrix := m_Camera.GetViewMatrix;
    projectionMatrix := m_Direct3D.GetProjectionMatrix;

    // Update the rotation variable each frame.
    FRotation := FRotation + XM_PI * 0.0025;
    if (FRotation > 360.0) then
        FRotation := FRotation - 360.0;

    // Rotate the world matrix by the rotation value.
    worldMatrix := XMMatrixRotationY(FRotation);

   // worldMatrix := XMMatrixMultiply(worldMatrix, XMMatrixRotationX(FRotation));

    // Put the model vertex and index buffers on the graphics pipeline to prepare them for drawing.
    m_Model.Render(m_Direct3D.GetDeviceContext());

    // Render the model with the light shader.
    Result := m_LightShader.Render(m_Direct3D.GetDeviceContext(), m_Model.GetIndexCount(), worldMatrix, viewMatrix,
        projectionMatrix, m_Model.GetTexture(), m_Light.GetDirection(), m_Light.GetDiffuseColor());
end;



constructor TGraphicsClass.Create;
begin
    FRotation := 0;
end;



destructor TGraphicsClass.Destroy;
begin
    inherited Destroy;
end;



function TGraphicsClass.Initialize(screenWidth, screenHeight: integer; hwnd: HWND): HResult;
var
    baseViewMatrix: TXMMATRIX;
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

    // Initialize a base view matrix with the camera for 2D user interface rendering.
    m_Camera.SetPosition(0.0, 0.0, -1.0);
    m_Camera.Render();
    baseViewMatrix := m_Camera.GetViewMatrix();

    // Create the model object.
    m_Model := TModelClass.Create;
    // Initialize the model object.
    Result := m_Model.Initialize(m_Direct3D.GetDevice(), m_Direct3D.GetDeviceContext(), 'cube.txt', 'seafloor.dds');


    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the model object.', 'Error', MB_OK);
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

    // Create the light object.
    m_Light := TLightClass.Create;
    // Initialize the light object.
    m_Light.SetDiffuseColor(1.0, 1.0, 1.0, 1.0);
    m_Light.SetDirection(0.0, 0.0, 1.0);
    m_Light.SetSpecularColor(1.0, 1.0, 1.0, 1.0);
    m_Light.SetSpecularPower(16.0);


    // Create the render to texture object.
    m_RenderTexture := TRenderTextureClass.Create;

    // Initialize the render to texture object.
    Result := m_RenderTexture.Initialize(m_Direct3D.GetDevice(), screenWidth, screenHeight);
    if (Result <> S_OK) then Exit;

    // Create the debug window object.
    m_DebugWindow := TDebugWindowClass.Create;

    // Initialize the debug window object.
    Result := m_DebugWindow.Initialize(m_Direct3D.GetDevice(), screenWidth, screenHeight, 100, 100);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the debug window object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the texture shader object.
    m_TextureShader := TTextureShaderClass.Create;
    // Initialize the texture shader object.
    Result := m_TextureShader.Initialize(m_Direct3D.GetDevice(), hwnd);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the texture shader object.', 'Error', MB_OK);
        Exit;
    end;
end;



procedure TGraphicsClass.Shutdown();
begin
    // Release the texture shader object.
    if (m_TextureShader <> nil) then
    begin
        m_TextureShader.Shutdown();
        m_TextureShader.Free;
        m_TextureShader := nil;
    end;

    // Release the debug window object.
    if (m_DebugWindow <> nil) then
    begin
        m_DebugWindow.Shutdown();
        m_DebugWindow.Free;
        m_DebugWindow := nil;
    end;

    // Release the render to texture object.
    if (m_RenderTexture <> nil) then
    begin
        m_RenderTexture.Shutdown();
        m_RenderTexture.Free;
        m_RenderTexture := nil;
    end;

    // Release the light  object.
    if (m_Light <> nil) then
    begin
        m_Light.Free;
        m_Light := nil;
    end;
    // Release the light map shader object.
    if (m_LightShader <> nil) then
    begin
        m_LightShader.Shutdown();
        m_LightShader.Free;
        m_LightShader := nil;
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
    // Set the position of the camera.
    m_Camera.SetPosition(0.0, 0.0, -5.0);


    Result := S_OK;
end;


end.
