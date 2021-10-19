unit GraphicsClass;

{$mode delphiunicode}{$H+}

interface

uses
    Classes, SysUtils, Windows,
    DirectX.Math,
    D3DClass, CameraClass, ModelClass, ColorShaderClass;

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
        m_ColorShader: TColorShaderClass;
    private
        function Render(): HResult;
    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(screenWidth, screenHeight: integer; hwnd: HWND): HResult;
        procedure Shutdown();
        function Frame(): HResult;
    end;

implementation

{ TGraphicsClass }

function TGraphicsClass.Render(): HResult;
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

    // Put the model vertex and index buffers on the graphics pipeline to prepare them for drawing.
    m_Model.Render(m_Direct3D.GetDeviceContext());

    // Render the model using the color shader.
    Result := m_ColorShader.Render(m_Direct3D.GetDeviceContext(), m_Model.GetIndexCount(), worldMatrix, viewMatrix, projectionMatrix);
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
    // Set the initial position of the camera.
    m_Camera.SetPosition(0.0, 0.0, -5.0);

    // Create the model object.
    m_Model := TModelClass.Create;

    // Initialize the model object.
    Result := m_Model.Initialize(m_Direct3D.GetDevice());
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the model object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the color shader object.
    m_ColorShader := TColorShaderClass.Create;

    // Initialize the color shader object.
    Result := m_ColorShader.Initialize(m_Direct3D.GetDevice(), hwnd);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the color shader object.', 'Error', MB_OK);
        Exit;
    end;
end;



procedure TGraphicsClass.Shutdown();
begin
    // Release the color shader object.
    if (m_ColorShader <> nil) then
    begin
        m_ColorShader.Shutdown();
        m_ColorShader.Free;
        m_ColorShader := nil;
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
    // Render the graphics scene.
    Result := Render();
end;

end.
