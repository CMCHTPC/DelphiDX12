unit GraphicsClass;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$ENDIF}

interface

uses
    Classes, SysUtils, Windows,
    DirectX.Math,
    D3DClass, CameraClass, ModelClass, LightShaderClass, LightClass;

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
        FRotation: single;
    private
        function Render(rotation: single): HResult;
    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(screenWidth, screenHeight: integer; hwnd: HWND): HResult;
        procedure Shutdown();
        function Frame(): HResult;
    end;

implementation

{ TGraphicsClass }

function TGraphicsClass.Render(rotation: single): HResult;
var
    worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX;
begin

    // Clear the buffers to begin the scene.
    m_Direct3D.BeginScene(0.1, 0.2, 0.4, 1.0);

    // Generate the view matrix based on the camera's position.
    m_Camera.Render();

    // Get the world, view, and projection matrices from the camera and d3d objects.
    worldMatrix := m_Direct3D.GetWorldMatrix;
    viewMatrix := m_Camera.GetViewMatrix;
    projectionMatrix := m_Direct3D.GetProjectionMatrix;

    // Rotate the world matrix by the rotation value so that the triangle will spin.
    worldMatrix := XMMatrixRotationY(rotation);

    // Put the model vertex and index buffers on the graphics pipeline to prepare them for drawing.
    m_Model.Render(m_Direct3D.GetDeviceContext());

    // Render the model using the light shader.
    Result := m_LightShader.Render(m_Direct3D.GetDeviceContext(), m_Model.GetIndexCount(), worldMatrix, viewMatrix,
        projectionMatrix, m_Model.GetTexture(), m_Light.GetDirection(), m_Light.GetAmbientColor(), m_Light.GetDiffuseColor(),
        	   m_Camera.GetPosition(), m_Light.GetSpecularColor(), m_Light.GetSpecularPower());
    if (Result <> S_OK) then
        Exit;

    // Present the rendered scene to the screen.
    m_Direct3D.EndScene();
end;



constructor TGraphicsClass.Create;
begin
    FRotation := 0.0;
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
    // Set the initial position of the camera.
    m_Camera.SetPosition(0.0, 0.0, -5.0);

    // Create the model object.
    m_Model := TModelClass.Create;

    // Initialize the model object.
    Result := m_Model.Initialize(m_Direct3D.GetDevice(), m_Direct3D.GetDeviceContext(), 'cube.txt', 'stone01.tga');
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the model object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the light shader object..
    m_LightShader := TLightShaderClass.Create;

    // Initialize the light shader object.
    Result := m_LightShader.Initialize(m_Direct3D.GetDevice(), hwnd);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the color shader object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the light object.
    m_Light := TLightClass.Create;
    // Initialize the light object.
    m_Light.SetAmbientColor(0.15, 0.15, 0.15, 1.0);
    m_Light.SetDiffuseColor(1.0, 1.0, 1.0, 1.0);
    m_Light.SetDirection(0.0, 0.0, 1.0);
    m_Light.SetSpecularColor(1.0, 1.0, 1.0, 1.0);
    m_Light.SetSpecularPower(32.0);

end;



procedure TGraphicsClass.Shutdown();
begin
    // Release the light object.
    if (m_Light <> nil) then
    begin
        m_Light.Free;
        m_Light := nil;
    end;

    // Release the light shader object.
    if (m_LightShader <> nil) then
    begin
        m_LightShader.Shutdown();
        m_LightShader.Free;
        m_LightShader := nil;
    end;

    // Release the model object.
    if (m_Model <> nil) then
    begin
        m_Model.Shutdown();
        m_Model.Free;
        m_Model := nil;
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
    // Update the rotation variable each frame.
    FRotation := FRotation + XM_PI * 0.005;
    if (FRotation > 360.0) then
        FRotation := FRotation - 360.0;


    // Render the graphics scene.
    Result := Render(FRotation);
end;

end.