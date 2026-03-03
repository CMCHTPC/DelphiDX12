unit ZoneClass;

interface

uses
    Classes, SysUtils, Windows,
    D3DClass,
    InputClass,
    ShaderManagerClass,
    TextureManagerClass,
    TimerClass,
    FrustumClass,
    LightClass,
    UserInterfaceClass,
    CameraClass,
    skydomeclass,
    PositionClass,
    TerrainClass;

type

    { TZoneClass }

    TZoneClass = class(TObject)
    private
        m_UserInterface: TUserInterfaceClass;
        m_Camera: TCameraClass;
        m_Position: TPositionClass;
        m_Light: TLightClass;
        m_Terrain: TTerrainClass;
        m_displayUI: boolean;
        m_wireFrame: boolean;
        m_cellLines: boolean;
        m_heightLocked: boolean;
        m_SkyDome: TSkyDomeClass;
        m_Frustum: TFrustumClass;
    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(Direct3D: TD3DClass; hwnd: hwnd; screenWidth, screenHeight: integer; screenDepth: single): HResult;
        procedure Shutdown();
        function Frame(Direct3D: TD3DClass; Input: TInputClass; ShaderManager: TShaderManagerClass;
            TextureManager: TTextureManagerClass; frameTime: single; fps: integer): HResult;

    private
        procedure HandleMovementInput(Input: TInputClass; frameTime: single);
        function Render(Direct3D: TD3DClass; ShaderManager: TShaderManagerClass; TextureManager: TTextureManagerClass): HResult;

    end;

implementation

uses
    DirectX.Math;



constructor TZoneClass.Create;
begin
    m_UserInterface := nil;
    m_Camera := nil;
    m_Position := nil;
    m_Terrain := nil;
end;



destructor TZoneClass.Destroy;
begin

end;



function TZoneClass.Initialize(Direct3D: TD3DClass; hwnd: hwnd; screenWidth, screenHeight: integer; screenDepth: single): HResult;
begin
    // Create the user interface object.
    m_UserInterface := TUserInterfaceClass.Create;

    // Initialize the user interface object.
    Result := m_UserInterface.Initialize(Direct3D, screenHeight, screenWidth);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the user interface object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the camera object.
    m_Camera := TCameraClass.Create;

    // Set the initial position of the camera and build the matrices needed for rendering.
    m_Camera.SetPosition(0.0, 0.0, -10.0);
    m_Camera.Render();
    m_Camera.RenderBaseViewMatrix();

    // Create the light object.
    m_Light := TLightClass.Create;

    // Initialize the light object.
    m_Light.SetDiffuseColor(1.0, 1.0, 1.0, 1.0);
    m_Light.SetDirection(-0.5, -1.0, -0.5);


    // Create the position object.
    m_Position := TPositionClass.Create;

    // Set the initial position and rotation.
    m_Position.SetPosition(512.5, 10.0, 10.0);
    m_Position.SetRotation(0.0, 0.0, 0.0);

    // Create the frustum object.
    m_Frustum := TFrustumClass.Create;
    // Initialize the frustum object.
    m_Frustum.Initialize(screenDepth);


    // Create the sky dome object.
    m_SkyDome := TSkyDomeClass.Create;

    // Initialize the sky dome object.
    Result := m_SkyDome.Initialize(Direct3D.GetDevice());
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the sky dome object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the terrain object.
    m_Terrain := TTerrainClass.Create;

    // Initialize the terrain object.
    Result := m_Terrain.Initialize(Direct3D.GetDevice(), '.\data\setup.txt');
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the terrain object.', 'Error', MB_OK);
        Exit;
    end;

    // Set the UI to display by default.
    m_displayUI := True;

    // Set wire frame rendering initially to enabled.
    m_wireFrame := False;

    // Set the rendering of cell lines initially to disabled.
    m_cellLines := False;

    // Set the user locked to the terrain height for movement.
    m_heightLocked := True;

    Result := S_OK;
end;



procedure TZoneClass.Shutdown();
begin

    if m_Frustum <> nil then
    begin
        m_Frustum.Free;
        m_Frustum := nil;
    end;

    // Release the terrain object.
    if (m_Terrain <> nil) then
    begin
        m_Terrain.Shutdown();
        m_Terrain.Free;
        m_Terrain := nil;
    end;

    // Release the sky dome object.
    if (m_SkyDome <> nil) then
    begin
        m_SkyDome.Shutdown();
        m_SkyDome.Free;
        m_SkyDome := nil;
    end;

    // Release the position object.
    if (m_Position <> nil) then
    begin
        m_Position.Free;
        m_Position := nil;
    end;

    // Release the light object.
    if (m_Light <> nil) then
    begin
        m_Light.Free;
        m_Light := nil;
    end;

    // Release the camera object.
    if (m_Camera <> nil) then
    begin
        m_Camera.Free;
        m_Camera := nil;
    end;

    // Release the user interface object.
    if (m_UserInterface <> nil) then
    begin
        m_UserInterface.Shutdown();
        m_UserInterface.Free;
        m_UserInterface := nil;
    end;
end;



function TZoneClass.Frame(Direct3D: TD3DClass; Input: TInputClass; ShaderManager: TShaderManagerClass;
    TextureManager: TTextureManagerClass; frameTime: single; fps: integer): HResult;
var
    posX, posY, posZ, rotX, rotY, rotZ, Height: single;
    foundHeight: boolean;
begin

    // Do the frame input processing.
    HandleMovementInput(Input, frameTime);

    // Get the view point position/rotation.
    m_Position.GetPosition(posX, posY, posZ);
    m_Position.GetRotation(rotX, rotY, rotZ);

    // Do the frame processing for the user interface.
    Result := m_UserInterface.Frame(Direct3D.GetDeviceContext(), fps, posX, posY, posZ, rotX, rotY, rotZ);
    if (Result <> S_OK) then
        Exit;

    // Do the terrain frame processing.
    m_Terrain.Frame();

    // If the height is locked to the terrain then position the camera on top of it.
    if (m_heightLocked) then
    begin
        // Get the height of the triangle that is directly underneath the given camera position.
        foundHeight := m_Terrain.GetHeightAtPosition(posX, posZ, Height);
        if (foundHeight) then
        begin
            // If there was a triangle under the camera then position the camera just above it by one meter.
            m_Position.SetPosition(posX, Height + 1.0, posZ);
            m_Camera.SetPosition(posX, Height + 1.0, posZ);
        end;
    end;


    // Render the graphics.
    Result := Render(Direct3D, ShaderManager, TextureManager);
end;



procedure TZoneClass.HandleMovementInput(Input: TInputClass; frameTime: single);
var
    keyDown: boolean;
    posX, posY, posZ, rotX, rotY, rotZ: single;
begin

    // Set the frame time for calculating the updated position.
    m_Position.SetFrameTime(frameTime);

    // Handle the input.
    keyDown := Input.IsLeftPressed();
    m_Position.TurnLeft(keyDown);

    keyDown := Input.IsRightPressed();
    m_Position.TurnRight(keyDown);

    keyDown := Input.IsUpPressed();
    m_Position.MoveForward(keyDown);

    keyDown := Input.IsDownPressed();
    m_Position.MoveBackward(keyDown);

    keyDown := Input.IsAPressed();
    m_Position.MoveUpward(keyDown);

    keyDown := Input.IsZPressed();
    m_Position.MoveDownward(keyDown);

    keyDown := Input.IsPgUpPressed();
    m_Position.LookUpward(keyDown);

    keyDown := Input.IsPgDownPressed();
    m_Position.LookDownward(keyDown);

    // Get the view point position/rotation.
    m_Position.GetPosition(posX, posY, posZ);
    m_Position.GetRotation(rotX, rotY, rotZ);

    // Set the position of the camera.
    m_Camera.SetPosition(posX, posY, posZ);
    m_Camera.SetRotation(rotX, rotY, rotZ);

    // Determine if the user interface should be displayed or not.
    if (Input.IsF1Toggled()) then
    begin
        m_displayUI := not m_displayUI;
    end;

    // Determine if the terrain should be rendered in wireframe or not.
    if (Input.IsF2Toggled()) then
        m_wireFrame := not m_wireFrame;

    // Determine if we should render the lines around each terrain cell.
    if (Input.IsF3Toggled()) then
        m_cellLines := not m_cellLines;


    // Determine if we should be locked to the terrain height when we move around or not.
    if (Input.IsF4Toggled()) then
        m_heightLocked := not m_heightLocked;

end;



function TZoneClass.Render(Direct3D: TD3DClass; ShaderManager: TShaderManagerClass; TextureManager: TTextureManagerClass): HResult;
var
    worldMatrix, viewMatrix, projectionMatrix, baseViewMatrix, orthoMatrix: TXMMATRIX;
    cameraPosition: TXMFLOAT3;
    i: integer;
begin

    // Generate the view matrix based on the camera's position.
    m_Camera.Render();

    // Get the world, view, and projection matrices from the camera and d3d objects.
    Direct3D.GetWorldMatrix(worldMatrix);
    m_Camera.GetViewMatrix(viewMatrix);
    Direct3D.GetProjectionMatrix(projectionMatrix);
    m_Camera.GetBaseViewMatrix(baseViewMatrix);
    Direct3D.GetOrthoMatrix(orthoMatrix);

    // Get the position of the camera.
    cameraPosition := m_Camera.GetPosition();

    // Construct the frustum.
    m_Frustum.ConstructFrustum(projectionMatrix, viewMatrix);


    // Clear the buffers to begin the scene.
    Direct3D.BeginScene(0.0, 0.0, 0.0, 1.0);


    // Turn off back face culling and turn off the Z buffer.
    Direct3D.TurnOffCulling();
    Direct3D.TurnZBufferOff();

    // Translate the sky dome to be centered around the camera position.
    worldMatrix := XMMatrixTranslation(cameraPosition.x, cameraPosition.y, cameraPosition.z);

    // Render the sky dome using the sky dome shader.
    m_SkyDome.Render(Direct3D.GetDeviceContext());
    Result := ShaderManager.RenderSkyDomeShader(Direct3D.GetDeviceContext(), m_SkyDome.GetIndexCount(), worldMatrix,
        viewMatrix, projectionMatrix, m_SkyDome.GetApexColor(), m_SkyDome.GetCenterColor());
    if (Result <> S_OK) then
        Exit;

    // Reset the world matrix.
    Direct3D.GetWorldMatrix(worldMatrix);

    // Turn the Z buffer back and back face culling on.
    Direct3D.TurnZBufferOn();
    Direct3D.TurnOnCulling();

    // Turn on wire frame rendering of the terrain if needed.
    if (m_wireFrame) then
        Direct3D.EnableWireframe();

    // Render the terrain cells (and cell lines if needed).
    for i := 0 to m_Terrain.GetCellCount() - 1 do
    begin
        // Put the terrain cell buffers on the pipeline.
        Result := m_Terrain.RenderCell(Direct3D.GetDeviceContext(), i, m_Frustum);
        if (Result = S_OK) then
        begin

            // Render the cell buffers using the terrain shader.
            Result := ShaderManager.RenderTerrainShader(Direct3D.GetDeviceContext(), m_Terrain.GetCellIndexCount(i),
                worldMatrix, viewMatrix, projectionMatrix, TextureManager.GetTexture(0), TextureManager.GetTexture(1),
                TextureManager.GetTexture(2),TextureManager.GetTexture(3),m_Light.GetDirection(), m_Light.GetDiffuseColor());
            if (Result <> S_OK) then
                Exit;

            // If needed then render the bounding box around this terrain cell using the color shader.
            if (m_cellLines) then
            begin
                m_Terrain.RenderCellLines(Direct3D.GetDeviceContext(), i);
                ShaderManager.RenderColorShader(Direct3D.GetDeviceContext(), m_Terrain.GetCellLinesIndexCount(i),
                    worldMatrix, viewMatrix, projectionMatrix);
                if (Result <> S_OK) then
                    Exit;
            end;
        end;
    end;


    // Turn off wire frame rendering of the terrain if it was on.
    if (m_wireFrame) then
        Direct3D.DisableWireframe();

    // Update the render counts in the UI.
    Result := m_UserInterface.UpdateRenderCounts(Direct3D.GetDeviceContext(), m_Terrain.GetRenderCount(),
        m_Terrain.GetCellsDrawn(), m_Terrain.GetCellsCulled());
    if (Result <> S_OK) then
        Exit;

    // Render the user interface.
    if (m_displayUI) then
    begin
        Result := m_UserInterface.Render(Direct3D, ShaderManager, worldMatrix, baseViewMatrix, orthoMatrix);
        if (Result <> S_OK) then
            Exit;
    end;
    // Present the rendered scene to the screen.
    Direct3D.EndScene();
end;

end.
