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
    ClipPlaneShaderClass;

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
        m_ClipPlaneShader: TClipPlaneShaderClass;
    private
        FPlanePosZ: single;
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
begin
    // Setup a clipping plane.
    clipPlane := TXMFLOAT4.Create(0.0, 1, 0.0, FPlanePosZ);
    FPlanePosZ := FPlanePosZ + 0.01;
    if FPlanePosZ >= 1 then
        FPlanePosZ := -1;

    // Clear the buffers to begin the scene.
    m_Direct3D.BeginScene(0.1, 0.2, 0.4, 1.0);

    // Generate the view matrix based on the camera's position.
    m_Camera.Render();

    // Get the world, view, and projection matrices from the camera and d3d objects.
    worldMatrix := m_Direct3D.GetWorldMatrix;
    viewMatrix := m_Camera.GetViewMatrix;
    projectionMatrix := m_Direct3D.GetProjectionMatrix;

    // Put the model vertex and index buffers on the graphics pipeline to prepare them for drawing.
    m_Model.Render(m_Direct3D.GetDeviceContext());

    // Render the model using the color shader.
    Result := m_ClipPlaneShader.Render(m_Direct3D.GetDeviceContext(), m_Model.GetIndexCount(), worldMatrix,
        viewMatrix, projectionMatrix, m_Model.GetTexture(), clipPlane);
    if (Result <> S_OK) then
        Exit;

    // Present the rendered scene to the screen.
    m_Direct3D.EndScene();
end;



constructor TGraphicsClass.Create;
begin
    FPlanePosZ := -1.0;
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
    Result := m_Model.Initialize(m_Direct3D.GetDevice(), m_Direct3D.GetDeviceContext(), 'triangle.txt', 'seafloor.dds');
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the model object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the clip plane shader object.
    m_ClipPlaneShader := TClipPlaneShaderClass.Create;
    Result := m_ClipPlaneShader.Initialize(m_Direct3D.GetDevice(), hwnd);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the clip plane shader object.', 'Error', MB_OK);
        Exit;
    end;
end;



procedure TGraphicsClass.Shutdown();
begin
    // Release the color shader object.
    if (m_ClipPlaneShader <> nil) then
    begin
        m_ClipPlaneShader.Shutdown();
        m_ClipPlaneShader.Free;
        m_ClipPlaneShader := nil;
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
    // Set the initial position of the camera.
    m_Camera.SetPosition(0.0, 0.0, -5.0);
end;

end.
