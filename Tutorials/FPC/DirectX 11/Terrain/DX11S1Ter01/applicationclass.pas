unit ApplicationClass;

interface

uses
    Classes, SysUtils, Windows,
    inputclass,
    d3dclass,
    cameraclass,
    terrainclass,
    colorshaderclass,
    timerclass,
    positionclass,
    fpsclass,
    cpuclass,
    fontshaderclass,
    textclass;

const
    FULL_SCREEN: boolean = True;
    VSYNC_ENABLED: boolean = false;
    SCREEN_DEPTH: single = 1000.0;
    SCREEN_NEAR: single = 0.1;

type
    TApplicationClass = class(TObject)
    private
        m_Input: TInputClass;
        m_Direct3D: TD3DClass;
        m_Camera: TCameraClass;
        m_Terrain: TTerrainClass;
        m_ColorShader: TColorShaderClass;
        m_Timer: TTimerClass;
        m_Position: TPositionClass;
        m_Fps: TFpsClass;
        m_Cpu: TCpuClass;
        m_FontShader: TFontShaderClass;
        m_Text: TTextClass;
    private
        function HandleInput(frameTime: single): HResult;
        function RenderGraphics(): HResult;
    public
        constructor Create;
        destructor Destroy; override;
        function Initialize(hinstance: HINST; hwnd: hwnd; screenWidth, screenHeight: integer): HResult;
        procedure Shutdown();
        function Frame(): HResult;
    end;

implementation

uses
    DX12.D3DX10, DX12.D3DX11;



constructor TApplicationClass.Create;
begin
    m_Input := nil;
    m_Direct3D := nil;
    m_Camera := nil;
    m_Terrain := nil;
    m_ColorShader := nil;
    m_Timer := nil;
    m_Position := nil;
    m_Fps := nil;
    m_Cpu := nil;
    m_FontShader := nil;
    m_Text := nil;
end;



destructor TApplicationClass.Destroy;
begin
    inherited;
end;



function TApplicationClass.Initialize(hinstance: HINST; hwnd: hwnd; screenWidth, screenHeight: integer): HResult;
var
    cameraX, cameraY, cameraZ: single;
    baseViewMatrix: TD3DXMATRIX;
    videoMemory: integer;
    videoCard: ansistring;
begin
    // Create the input object.  The input object will be used to handle reading the keyboard and mouse input from the user.
    m_Input := TInputClass.Create;
    // Initialize the input object.
    Result := m_Input.Initialize(hinstance, hwnd, screenWidth, screenHeight);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the input object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the Direct3D object.
    m_Direct3D := TD3DClass.Create;

    // Initialize the Direct3D object.
    Result := m_Direct3D.Initialize(screenWidth, screenHeight, VSYNC_ENABLED, hwnd, FULL_SCREEN, SCREEN_DEPTH, SCREEN_NEAR);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize DirectX 11.', 'Error', MB_OK);
        Exit;
    end;

    // Create the camera object.
    m_Camera := TCameraClass.Create;

    // Initialize a base view matrix with the camera for 2D user interface rendering.
    m_Camera.SetPosition(0.0, 0.0, -1.0);
    m_Camera.Render();
    m_Camera.GetViewMatrix(baseViewMatrix);

    // Set the initial position of the camera.
    cameraX := 50.0;
    cameraY := 2.0;
    cameraZ := -7.0;

    m_Camera.SetPosition(cameraX, cameraY, cameraZ);

    // Create the terrain object.
    m_Terrain := TTerrainClass.Create;

    // Initialize the terrain object.
    Result := m_Terrain.Initialize(m_Direct3D.GetDevice());
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the terrain object.', 'Error', MB_OK);
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

    // Create the timer object.
    m_Timer := TTimerClass.Create;

    // Initialize the timer object.
    Result := m_Timer.Initialize();
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the timer object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the position object.
    m_Position := TPositionClass.Create;

    // Set the initial position of the viewer to the same as the initial camera position.
    m_Position.SetPosition(cameraX, cameraY, cameraZ);

    // Create the fps object.
    m_Fps := TFpsClass.Create;

    // Initialize the fps object.
    m_Fps.Initialize();

    // Create the cpu object.
    m_Cpu := TCpuClass.Create;

    // Initialize the cpu object.
    m_Cpu.Initialize();

    // Create the font shader object.
    m_FontShader := TFontShaderClass.Create;

    // Initialize the font shader object.
    Result := m_FontShader.Initialize(m_Direct3D.GetDevice(), hwnd);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the font shader object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the text object.
    m_Text := TTextClass.Create;

    // Initialize the text object.
    Result := m_Text.Initialize(m_Direct3D.GetDevice(), m_Direct3D.GetDeviceContext(), hwnd, screenWidth, screenHeight, baseViewMatrix);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the text object.', 'Error', MB_OK);
        Exit;
    end;

    // Retrieve the video card information.
    m_Direct3D.GetVideoCardInfo(videoCard, videoMemory);

    // Set the video card information in the text object.
    Result := m_Text.SetVideoCardInfo(videoCard, videoMemory, m_Direct3D.GetDeviceContext());
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not set video card info in the text object.', 'Error', MB_OK);
    end;
end;



procedure TApplicationClass.Shutdown();
begin
    // Release the text object.
    if (m_Text <> nil) then
    begin
        m_Text.Shutdown();
        m_Text.Free;
        m_Text := nil;
    end;

    // Release the font shader object.
    if (m_FontShader <> nil) then
    begin
        m_FontShader.Shutdown();
        m_FontShader.Free;
        m_FontShader := nil;
    end;

    // Release the cpu object.
    if (m_Cpu <> nil) then
    begin
        m_Cpu.Shutdown();
        m_Cpu.Free;
        m_Cpu := nil;
    end;

    // Release the fps object.
    if (m_Fps <> nil) then
    begin
        m_Fps.Free;
        m_Fps := nil;
    end;

    // Release the position object.
    if (m_Position <> nil) then
    begin
        m_Position.Free;
        m_Position := nil;
    end;

    // Release the timer object.
    if (m_Timer <> nil) then
    begin
        m_Timer.Free;
        m_Timer := nil;
    end;

    // Release the color shader object.
    if (m_ColorShader <> nil) then
    begin
        m_ColorShader.Shutdown();
        m_ColorShader.Free;
        m_ColorShader := nil;
    end;

    // Release the terrain object.
    if (m_Terrain <> nil) then
    begin
        m_Terrain.Shutdown();
        m_Terrain.Free;
        m_Terrain := nil;
    end;

    // Release the camera object.
    if (m_Camera <> nil) then
    begin
        m_Camera.Free;
        m_Camera := nil;
    end;

    // Release the Direct3D object.
    if (m_Direct3D <> nil) then
    begin
        m_Direct3D.Shutdown();
        m_Direct3D.Free;
        m_Direct3D := nil;
    end;

    // Release the input object.
    if (m_Input <> nil) then
    begin
        m_Input.Shutdown();
        m_Input.Free;
        m_Input := nil;
    end;
end;



function TApplicationClass.Frame(): HResult;
begin

    // Read the user input.
    Result := m_Input.Frame();
    if (Result <> S_OK) then
        Exit;

    // Check if the user pressed escape and wants to exit the application.
    if (m_Input.IsEscapePressed()) then
    begin
        Result := E_FAIL;
        Exit;
    end;

    // Update the system stats.
    m_Timer.Frame();
    m_Fps.Frame();
    m_Cpu.Frame();

    // Update the FPS value in the text object.
    Result := m_Text.SetFps(m_Fps.GetFps(), m_Direct3D.GetDeviceContext());
    if (Result <> S_OK) then
        Exit;

    // Update the CPU usage value in the text object.
    Result := m_Text.SetCpu(m_Cpu.GetCpuPercentage(), m_Direct3D.GetDeviceContext());
    if (Result <> S_OK) then
        Exit;

    // Do the frame input processing.
    Result := HandleInput(m_Timer.GetTime());
    if (Result <> S_OK) then
        Exit;

    // Render the graphics.
    Result := RenderGraphics();
end;



function TApplicationClass.HandleInput(frameTime: single): HResult;
var
    keyDown: boolean;
    posX, posY, posZ, rotX, rotY, rotZ: single;
begin

    // Set the frame time for calculating the updated position.
    m_Position.SetFrameTime(frameTime);

    // Handle the input.
    keyDown := m_Input.IsLeftPressed();
    m_Position.TurnLeft(keyDown);

    keyDown := m_Input.IsRightPressed();
    m_Position.TurnRight(keyDown);

    keyDown := m_Input.IsUpPressed();
    m_Position.MoveForward(keyDown);

    keyDown := m_Input.IsDownPressed();
    m_Position.MoveBackward(keyDown);

    keyDown := m_Input.IsAPressed();
    m_Position.MoveUpward(keyDown);

    keyDown := m_Input.IsZPressed();
    m_Position.MoveDownward(keyDown);

    keyDown := m_Input.IsPgUpPressed();
    m_Position.LookUpward(keyDown);

    keyDown := m_Input.IsPgDownPressed();
    m_Position.LookDownward(keyDown);

    // Get the view point position/rotation.
    m_Position.GetPosition(posX, posY, posZ);
    m_Position.GetRotation(rotX, rotY, rotZ);

    // Set the position of the camera.
    m_Camera.SetPosition(posX, posY, posZ);
    m_Camera.SetRotation(rotX, rotY, rotZ);

    // Update the position values in the text object.
    Result := m_Text.SetCameraPosition(posX, posY, posZ, m_Direct3D.GetDeviceContext());
    if (Result <> S_OK) then
        Exit;

    // Update the rotation values in the text object.
    Result := m_Text.SetCameraRotation(rotX, rotY, rotZ, m_Direct3D.GetDeviceContext());
end;



function TApplicationClass.RenderGraphics(): HResult;
var
    worldMatrix, viewMatrix, projectionMatrix, orthoMatrix: TD3DXMATRIX;
begin

    // Clear the scene.
    m_Direct3D.BeginScene(0.0, 0.0, 0.0, 1.0);

    // Generate the view matrix based on the camera's position.
    m_Camera.Render();

    // Get the world, view, projection, and ortho matrices from the camera and Direct3D objects.
    m_Direct3D.GetWorldMatrix(worldMatrix);
    m_Camera.GetViewMatrix(viewMatrix);
    m_Direct3D.GetProjectionMatrix(projectionMatrix);
    m_Direct3D.GetOrthoMatrix(orthoMatrix);

    // Render the terrain buffers.
    m_Terrain.Render(m_Direct3D.GetDeviceContext());

    // Render the model using the color shader.
    Result := m_ColorShader.Render(m_Direct3D.GetDeviceContext(), m_Terrain.GetIndexCount(), worldMatrix, viewMatrix, projectionMatrix);
    if (Result <> S_OK) then
        Exit;

    // Turn off the Z buffer to begin all 2D rendering.
    m_Direct3D.TurnZBufferOff();

    // Turn on the alpha blending before rendering the text.
    m_Direct3D.TurnOnAlphaBlending();

    // Render the text user interface elements.
    Result := m_Text.Render(m_Direct3D.GetDeviceContext(), m_FontShader, worldMatrix, orthoMatrix);
    if (Result <> S_OK) then
        Exit;

    // Turn off alpha blending after rendering the text.
    m_Direct3D.TurnOffAlphaBlending();

    // Turn the Z buffer back on now that all 2D rendering has completed.
    m_Direct3D.TurnZBufferOn();

    // Present the rendered scene to the screen.
    m_Direct3D.EndScene();
end;

end.
