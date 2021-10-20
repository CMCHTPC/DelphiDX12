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
    SpecMapShaderClass;

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
        m_Model: TModelClass;
        m_SpecMapShader: TSpecMapShaderClass;
        m_Light: TLightClass;
        FRotation: single;
    private

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

    // Clear the buffers to begin the scene.
    m_Direct3D.BeginScene(0.0, 0.0, 0.0, 1.0);

    // Generate the view matrix based on the camera's position.
    m_Camera.Render();

    // Get the world, view, projection, and world matrices from the camera and d3d objects.
    worldMatrix := m_Direct3D.GetWorldMatrix;
    viewMatrix := m_Camera.GetViewMatrix;
    projectionMatrix := m_Direct3D.GetProjectionMatrix;
    orthoMatrix := m_Direct3D.GetOrthoMatrix();

    // Update the rotation variable each frame.
    FRotation := FRotation + XM_PI * 0.0025;
    if (FRotation > 360.0) then
        FRotation := FRotation - 360.0;

    // Rotate the world matrix by the rotation value.
    worldMatrix := XMMatrixRotationY(FRotation);

    // Put the model vertex and index buffers on the graphics pipeline to prepare them for drawing.
    m_Model.Render(m_Direct3D.GetDeviceContext());

    // Render the model using the bump map shader.
    m_SpecMapShader.Render(m_Direct3D.GetDeviceContext(), m_Model.GetIndexCount(),
    worldMatrix, viewMatrix, projectionMatrix,
        m_Model.GetTextureArray(), m_Light.GetDirection(), m_Light.GetDiffuseColor(),
        m_Camera.GetPosition(), m_Light.GetSpecularColor(), m_Light.GetSpecularPower());


    // Present the rendered scene to the screen.
    m_Direct3D.EndScene();

    Result := S_OK;
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
    Result := m_Model.Initialize(m_Direct3D.GetDevice(), m_Direct3D.GetDeviceContext(), 'cube.txt', 'stone02.dds', 'bump02.dds', 'spec02.dds');
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the model object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the bump map shader object.
    m_SpecMapShader := TSpecMapShaderClass.Create;

    // Initialize the bump map shader object.
    Result := m_SpecMapShader.Initialize(m_Direct3D.GetDevice(), hwnd);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the bump map shader object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the light object.
    m_Light := TLightClass.Create;
    // Initialize the light object.
    m_Light.SetDiffuseColor(1.0, 1.0, 1.0, 1.0);
    m_Light.SetDirection(0.0, 0.0, 1.0);
    m_Light.SetSpecularColor(1.0, 1.0, 1.0, 1.0);
    m_Light.SetSpecularPower(16.0);
end;



procedure TGraphicsClass.Shutdown();
begin
    // Release the light  object.
    if (m_Light <> nil) then
    begin
        m_Light.Free;
        m_Light := nil;
    end;
    // Release the light map shader object.
    if (m_SpecMapShader <> nil) then
    begin
        m_SpecMapShader.Shutdown();
        m_SpecMapShader.Free;
        m_SpecMapShader := nil;
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