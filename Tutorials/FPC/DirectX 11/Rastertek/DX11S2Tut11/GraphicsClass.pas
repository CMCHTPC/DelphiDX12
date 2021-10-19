unit GraphicsClass;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$ENDIF}

interface

uses
    Classes, SysUtils, Windows,
    DirectX.Math,
    D3DClass, CameraClass,
    TextureShaderClass,
    BitmapClass;

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

        m_TextureShader: TTextureShaderClass;
        m_Bitmap: TBitmapClass;
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
    orthoMatrix: TXMMATRIX;
begin

    // Clear the buffers to begin the scene.
    m_Direct3D.BeginScene(0.1, 0.2, 0.4, 1.0);

    // Generate the view matrix based on the camera's position.
    m_Camera.Render();

    // Get the world, view, projection, and ortho matrices from the camera and d3d objects.
    worldMatrix := m_Direct3D.GetWorldMatrix;
    viewMatrix := m_Camera.GetViewMatrix;
    projectionMatrix := m_Direct3D.GetProjectionMatrix;
    orthoMatrix := m_Direct3D.GetOrthoMatrix();

    // Turn off the Z buffer to begin all 2D rendering.
    m_Direct3D.TurnZBufferOff();

    // Put the bitmap vertex and index buffers on the graphics pipeline to prepare them for drawing.
    Result := m_Bitmap.Render(m_Direct3D.GetDeviceContext(), 100, 100);
    if (Result <> S_OK) then Exit;

    // Render the bitmap with the texture shader.
    Result := m_TextureShader.Render(m_Direct3D.GetDeviceContext(), m_Bitmap.GetIndexCount(), worldMatrix, viewMatrix,
        orthoMatrix, m_Bitmap.GetTexture());
    if (Result <> S_OK) then Exit;

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

    // Create the texture shader object.
    m_TextureShader := TTextureShaderClass.Create;

    // Initialize the texture shader object.
    Result := m_TextureShader.Initialize(m_Direct3D.GetDevice(), hwnd);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the texture shader object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the bitmap object.
    m_Bitmap := TBitmapClass.Create;

    // Initialize the bitmap object.
    Result := m_Bitmap.Initialize(m_Direct3D.GetDevice(), m_Direct3D.GetDeviceContext(), screenWidth, screenHeight, 'stone01.tga', 256, 256);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the bitmap object.', 'Error', MB_OK);
        Exit;
    end;
end;



procedure TGraphicsClass.Shutdown();
begin
    // Release the bitmap object.
    if (m_Bitmap <> nil) then
    begin
        m_Bitmap.Shutdown();
        m_Bitmap.Free;
        m_Bitmap := nil;
    end;

    // Release the texture shader object.
    if (m_TextureShader <> nil) then
    begin
        m_TextureShader.Shutdown();
        m_TextureShader.Free;
        m_TextureShader := nil;
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
