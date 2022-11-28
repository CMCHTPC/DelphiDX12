unit ApplicationClass;

{$mode DelphiUnicode}{$H+}

interface

uses
    Classes, SysUtils, Windows,
    DirectX.Math,
    DX12.D3DX11,
    InputClass, TextureShaderClass, TextClass,
    BitmapClass,
    D3DClass, CameraClass, ModelClass, LightShaderClass, LightClass;

const
    FULL_SCREEN: boolean = True;
    VSYNC_ENABLED: boolean = True;
    SCREEN_DEPTH: single = 1000.0;
    SCREEN_NEAR: single = 0.1;


type

    { TApplicationClass }

    TApplicationClass = class(TObject)
    private
        m_Input: TInputClass;
        m_Direct3D: TD3DClass;
        m_Camera: TCameraClass;
        m_Model: TModelClass;
        m_LightShader: TLightShaderClass;
        m_TextureShader: TTextureShaderClass;
        m_Light: TLightClass;
        m_Text: TTextClass;
        m_Bitmap: TBitmapClass;
        FRotation: single;
        m_screenWidth, m_screenHeight: integer;
        m_beginCheck: boolean;
    private
        function Render(): HResult;
        function HandleInput(): HResult;
        function TestIntersection(mouseX, mouseY: integer): HResult;
        function RaySphereIntersect(rayOrigin, rayDirection: TXMVECTOR; radius: single): boolean;
    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(hinstance: HINST; hwnd: HWND; screenWidth, screenHeight: integer): HResult;
        procedure Shutdown();
        function Frame(): HResult;
    end;

implementation

{ TApplicationClass }

function TApplicationClass.Render(): HResult;
var
    worldMatrix, viewMatrix, projectionMatrix, orthoMatrix, translateMatrix: TXMMATRIX;
    mouseX, mouseY: integer;
begin

    // Clear the buffers to begin the scene.
    m_Direct3D.BeginScene(0.1, 0.2, 0.4, 1.0);


    // Generate the view matrix based on the camera's position.
    m_Camera.Render();

    // Get the world, view, and projection matrices from the camera and d3d objects.
    worldMatrix := m_Direct3D.GetWorldMatrix;
    viewMatrix := m_Camera.GetViewMatrix;
    projectionMatrix := m_Direct3D.GetProjectionMatrix;
    orthoMatrix := m_Direct3D.GetOrthoMatrix;


    // Translate to the location of the sphere.
    translateMatrix := XMMatrixTranslation(-5.0, 1.0, 5.0);
    worldMatrix := worldMatrix * translateMatrix;

    // Render the model using the light shader.
    m_Model.Render(m_Direct3D.GetDeviceContext());
    Result := m_LightShader.Render(m_Direct3D.GetDeviceContext(), m_Model.GetIndexCount(), worldMatrix, viewMatrix,
        projectionMatrix, m_Model.GetTexture(), m_Light.GetDirection());
    if (Result <> S_OK) then Exit;

    // Reset the world matrix.
    worldMatrix := m_Direct3D.GetWorldMatrix();

    // Turn off the Z buffer to begin all 2D rendering.
    m_Direct3D.TurnZBufferOff();

    // Turn on alpha blending.
    m_Direct3D.TurnOnAlphaBlending();

    // Get the location of the mouse from the input object,
    m_Input.GetMouseLocation(mouseX, mouseY);

    // Render the mouse cursor with the texture shader.
    Result := m_Bitmap.Render(m_Direct3D.GetDeviceContext(), mouseX, mouseY);
    if (Result <> S_OK) then Exit;
    Result := m_TextureShader.Render(m_Direct3D.GetDeviceContext(), m_Bitmap.GetIndexCount(), worldMatrix, viewMatrix,
        orthoMatrix, m_Bitmap.GetTexture());

    // Render the text strings.
    Result := m_Text.Render(m_Direct3D.GetDeviceContext(), worldMatrix, orthoMatrix);
    if (Result <> S_OK) then Exit;

    // Turn of alpha blending.
    m_Direct3D.TurnOffAlphaBlending();

    // Turn the Z buffer back on now that all 2D rendering has completed.
    m_Direct3D.TurnZBufferOn();

    // Present the rendered scene to the screen.
    m_Direct3D.EndScene();


    // Put the model vertex and index buffers on the graphics pipeline to prepare them for drawing.
    m_Model.Render(m_Direct3D.GetDeviceContext());

end;



function TApplicationClass.HandleInput(): HResult;
var
    mouseX, mouseY: integer;
begin
    // Do the input frame processing.
    Result := m_Input.Frame();
    if (Result <> S_OK) then Exit;

    // Check if the user pressed escape and wants to exit the application.
    if (m_Input.IsEscapePressed()) then
    begin
        Result := E_FAIL;
        Exit;
    end;

    // Check if the left mouse button has been pressed.
    if (m_Input.IsLeftMouseButtonDown() = True) then
    begin
        // If they have clicked on the screen with the mouse then perform an intersection test.
        if (m_beginCheck = False) then
        begin
            m_beginCheck := True;
            m_Input.GetMouseLocation(mouseX, mouseY);
            TestIntersection(mouseX, mouseY);
        end;
    end;

    // Check if the left mouse button has been released.
    if (m_Input.IsLeftMouseButtonDown() = False) then
    begin
        m_beginCheck := False;
    end;

    Result := S_OK;
end;



function TApplicationClass.TestIntersection(mouseX, mouseY: integer): HResult;
var
    pointX, pointY: single;
    projectionMatrix, viewMatrix, inverseViewMatrix, worldMatrix, translateMatrix, inverseWorldMatrix: TXMMATRIX;
    intersect: boolean;
    direction, origin, rayOrigin, rayDirection: TXMVECTOR;
begin
    // Move the mouse cursor coordinates into the -1 to +1 range.
    pointX := ((2.0 * mouseX) / m_screenWidth) - 1.0;
    pointY := (((2.0 * mouseY) / m_screenHeight) - 1.0) * -1.0;

    // Adjust the points using the projection matrix to account for the aspect ratio of the viewport.
    projectionMatrix := m_Direct3D.GetProjectionMatrix();
    pointX := pointX / projectionMatrix._11;
    pointY := pointY / projectionMatrix._22;

    // Get the inverse of the view matrix.
    viewMatrix := m_Camera.GetViewMatrix();
    inverseViewMatrix := XMMatrixInverse(TXMVECTOR(nil^), viewMatrix);

    // Calculate the direction of the picking ray in view space.
    direction.x := (pointX * inverseViewMatrix._11) + (pointY * inverseViewMatrix._21) + inverseViewMatrix._31;
    direction.y := (pointX * inverseViewMatrix._12) + (pointY * inverseViewMatrix._22) + inverseViewMatrix._32;
    direction.z := (pointX * inverseViewMatrix._13) + (pointY * inverseViewMatrix._23) + inverseViewMatrix._33;

    // Get the origin of the picking ray which is the position of the camera.
    origin := XMLoadFloat3(m_Camera.GetPosition());

    // Get the world matrix and translate to the location of the sphere.
    worldMatrix := m_Direct3D.GetWorldMatrix();
    translateMatrix := XMMatrixTranslation(-5.0, 1.0, 5.0);
    worldMatrix := worldMatrix * translateMatrix;

    // Now get the inverse of the translated world matrix.
    inverseWorldMatrix := XMMatrixInverse(TXMVECTOR(nil^), worldMatrix);

    // Now transform the ray origin and the ray direction from view space to world space.
    rayOrigin := XMVector3TransformCoord(origin, inverseWorldMatrix);
    rayDirection := XMVector3TransformNormal(direction, inverseWorldMatrix);
    // Normalize the ray direction.
    rayDirection := XMVector3Normalize(rayDirection);

    // Now perform the ray-sphere intersection test.
    intersect := RaySphereIntersect(rayOrigin, rayDirection, 1.0);

    if (intersect) then
        // If it does intersect then set the intersection to "yes" in the text string that is displayed to the screen.
        Result := m_Text.SetIntersection(True, m_Direct3D.GetDeviceContext())

    else
        // If not then set the intersection to "No".
        Result := m_Text.SetIntersection(False, m_Direct3D.GetDeviceContext());

end;



function TApplicationClass.RaySphereIntersect(rayOrigin, rayDirection: TXMVECTOR; radius: single): boolean;
var
    a, b, c, discriminant: single;
begin

    // Calculate the a, b, and c coefficients.
    a := (rayDirection.x * rayDirection.x) + (rayDirection.y * rayDirection.y) + (rayDirection.z * rayDirection.z);
    b := ((rayDirection.x * rayOrigin.x) + (rayDirection.y * rayOrigin.y) + (rayDirection.z * rayOrigin.z)) * 2.0;
    c := ((rayOrigin.x * rayOrigin.x) + (rayOrigin.y * rayOrigin.y) + (rayOrigin.z * rayOrigin.z)) - (radius * radius);

    // Find the discriminant.
    discriminant := (b * b) - (4 * a * c);

    // if discriminant is negative the picking ray missed the sphere, otherwise it intersected the sphere.
    Result := (discriminant >= 0.0);
end;



constructor TApplicationClass.Create;
begin

end;



destructor TApplicationClass.Destroy;
begin
    inherited Destroy;
end;



function TApplicationClass.Initialize(hinstance: HINST; hwnd: HWND; screenWidth, screenHeight: integer): HResult;
var
    baseViewMatrix: TXMMATRIX;
begin
    // Store the screen width and height.
    m_screenWidth := screenWidth;
    m_screenHeight := screenHeight;

    // Create the input object.  This object will be used to handle reading the keyboard input from the user.
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
        MessageBoxW(hwnd, 'Could not initialize Direct3D.', 'Error', MB_OK);
        Exit;
    end;

    // Create the camera object.
    m_Camera := TCameraClass.Create;
    // Set the initial position of the camera.
    m_Camera.SetPosition(0.0, 0.0, -10.0);
    m_Camera.Render();
    baseViewMatrix := m_Camera.GetViewMatrix();

    // Create the model object.
    m_Model := TModelClass.Create;

    // Initialize the model object.
    Result := m_Model.Initialize(m_Direct3D.GetDevice(), m_Direct3D.GetDeviceContext(), 'sphere.txt', 'blue.dds');
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the model object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the texture shader object.
    m_TextureShader := TTextureShaderClass.Create;
    // Initialize the texture shader object.
    Result := m_TextureShader.Initialize(m_Direct3D.GetDevice(), hwnd);
    if (Result <> S_OK) then
    begin
        MessageBox(hwnd, 'Could not initialize the texture shader object.', 'Error', MB_OK);
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
    m_Light.SetDirection(0.0, 0.0, 1.0);

    // Create the text object.
    m_Text := TTextClass.Create;

    // Initialize the text object.
    Result := m_Text.Initialize(m_Direct3D.GetDevice(), m_Direct3D.GetDeviceContext(), hwnd, screenWidth, screenHeight, baseViewMatrix);
    if (Result <> S_OK) then
    begin
        MessageBox(hwnd, 'Could not initialize the text object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the bitmap object.
    m_Bitmap := TBitmapClass.Create;

    // Initialize the bitmap object.
    Result := m_Bitmap.Initialize(m_Direct3D.GetDevice(), m_Direct3D.GetDeviceContext(), screenWidth, screenHeight, 'mouse.dds', 32, 32);
    if (Result <> S_OK) then
    begin
        MessageBox(hwnd, 'Could not initialize the bitmap object.', 'Error', MB_OK);
        Exit;
    end;

    // Initialize that the user has not clicked on the screen to try an intersection test yet.
    m_beginCheck := False;

    Result := S_OK;

end;



procedure TApplicationClass.Shutdown();
begin
    if (m_Input <> nil) then
    begin
        m_Input.Shutdown();
        m_Input.Free;
        m_Input := nil;
    end;

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



function TApplicationClass.Frame(): HResult;
begin
    // Handle the input processing.
    Result := HandleInput();
    if (Result <> S_OK) then Exit;

    // Render the graphics scene.
    Result := Render();
end;

end.
