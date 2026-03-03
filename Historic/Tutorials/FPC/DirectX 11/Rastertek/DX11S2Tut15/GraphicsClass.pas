unit GraphicsClass;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$ENDIF}

interface

uses
    Classes, SysUtils, Windows,
    DirectX.Math,
    D3DClass, CameraClass,
    TextClass;

const
    FULL_SCREEN: boolean = True;
    VSYNC_ENABLED: boolean = False;
    SCREEN_DEPTH: single = 1000.0;
    SCREEN_NEAR: single = 0.1;



type

    { TGraphicsClass }

    TGraphicsClass = class(TObject)
    private
        m_Direct3D: TD3DClass;
        m_Camera: TCameraClass;
        m_Text: TTextClass;
        FRotation: single;
    private

    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(screenWidth, screenHeight: integer; hwnd: HWND): HResult;
        procedure Shutdown();
        function Frame(fps, cpu: integer; frameTime: single): HResult;
        function Render(rotation: single): HResult;
    end;

implementation

{ TGraphicsClass }

function TGraphicsClass.Render(rotation: single): HResult;
var
    worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX;
    orthoMatrix: TXMMATRIX;
begin

    // Clear the buffers to begin the scene.
    m_Direct3D.BeginScene(0.1, 0.2, 0.4, 1.0);

    // Generate the view matrix based on the camera's position.
    m_Camera.Render();

    // Get the world, view, projection, and world matrices from the camera and d3d objects.
    worldMatrix := m_Direct3D.GetWorldMatrix;
    viewMatrix := m_Camera.GetViewMatrix;
    projectionMatrix := m_Direct3D.GetProjectionMatrix;
    orthoMatrix := m_Direct3D.GetOrthoMatrix();

    // Turn off the Z buffer to begin all 2D rendering.
    m_Direct3D.TurnZBufferOff();

    // Turn on the alpha blending before rendering the text.
    m_Direct3D.TurnOnAlphaBlending();

    // Render the text strings.
    Result := m_Text.Render(m_Direct3D.GetDeviceContext(), worldMatrix, orthoMatrix);
    if (Result <> S_OK) then Exit;

    // Turn off alpha blending after rendering the text.
    m_Direct3D.TurnOffAlphaBlending();


    // Turn the Z buffer back on now that all 2D rendering has completed.
    m_Direct3D.TurnZBufferOn();

    // Present the rendered scene to the screen.
    m_Direct3D.EndScene();
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

    // Create the text object.
    m_Text := TTextClass.Create;

    // Initialize the text object.
    Result := m_Text.Initialize(m_Direct3D.GetDevice(), m_Direct3D.GetDeviceContext(), hwnd, screenWidth, screenHeight, baseViewMatrix);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the text object.', 'Error', MB_OK);
        Exit;
    end;
end;



procedure TGraphicsClass.Shutdown();
begin
    // Release the text object.
    if (m_Text <> nil) then
    begin
        m_Text.Shutdown();
        m_Text.Free;
        m_Text := nil;
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



function TGraphicsClass.Frame(fps, cpu: integer; frameTime: single): HResult;
begin
    // Set the frames per second.
    Result := m_Text.SetFps(fps, m_Direct3D.GetDeviceContext());
    if (Result <> S_OK) then Exit;

    // Set the cpu usage.
    Result := m_Text.SetCpu(cpu, m_Direct3D.GetDeviceContext());
    if (Result <> S_OK) then Exit;


    // Set the position of the camera.
    m_Camera.SetPosition(0.0, 0.0, -10.0);

  (*  // Update the rotation variable each frame.
    FRotation := FRotation + XM_PI * 0.005;
    if (FRotation > 360.0) then
        FRotation := FRotation - 360.0;

    // Render the graphics scene.
    Result := Render(FRotation);   *)
end;


end.
