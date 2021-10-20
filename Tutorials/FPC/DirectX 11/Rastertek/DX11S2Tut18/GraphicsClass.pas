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
    LightMapShaderClass;

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
        m_LightMapShader: TLightMapShaderClass;
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
    m_Direct3D.BeginScene(0.1, 0.2, 0.4, 1.0);

    // Generate the view matrix based on the camera's position.
    m_Camera.Render();

    // Get the world, view, projection, and world matrices from the camera and d3d objects.
    worldMatrix := m_Direct3D.GetWorldMatrix;
    viewMatrix := m_Camera.GetViewMatrix;
    projectionMatrix := m_Direct3D.GetProjectionMatrix;
    orthoMatrix := m_Direct3D.GetOrthoMatrix();

    // Put the model vertex and index buffers on the graphics pipeline to prepare them for drawing.
    m_Model.Render(m_Direct3D.GetDeviceContext());

    // Render the model using the multitexture shader.
    m_LightMapShader.Render(m_Direct3D.GetDeviceContext(),
        m_Model.GetIndexCount(), worldMatrix, viewMatrix, projectionMatrix,
        m_Model.GetTextureArray());


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
    Result := m_Model.Initialize(m_Direct3D.GetDevice(), m_Direct3D.GetDeviceContext(), 'square.txt', 'stone01.dds', 'light01.dds');
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the model object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the multitexture shader object.
    m_LightMapShader := TLightMapShaderClass.Create;

    // Initialize the light map shader object.
    Result := m_LightMapShader.Initialize(m_Direct3D.GetDevice(), hwnd);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the light map shader object.', 'Error', MB_OK);
        Exit;
    end;

end;



procedure TGraphicsClass.Shutdown();
begin
    // Release the light map shader object.
    if (m_LightMapShader <> nil) then
    begin
        m_LightMapShader.Shutdown();
        m_LightMapShader.Free;
        m_LightMapShader := nil;
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

  (*  // Update the rotation variable each frame.
    FRotation := FRotation + XM_PI * 0.005;
    if (FRotation > 360.0) then
        FRotation := FRotation - 360.0;

    // Render the graphics scene.
    Result := Render(FRotation);   *)

    Result := S_OK;
end;


end.
