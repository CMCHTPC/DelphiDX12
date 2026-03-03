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
    TextureShaderClass,
    RenderTextureClass,
    BitmapClass,
    FadeShaderClass;

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
        m_FloorModel: TModelClass;
        m_TextureShader: TTextureShaderClass;
        m_RenderTexture: TRenderTextureClass;
        m_Bitmap: TBitmapClass;
        m_fadeInTime, m_accumulatedTime, m_fadePercentage: single;
        m_fadeDone: boolean;
        m_FadeShader: TFadeShaderClass;
    private
        FRotation: single;

        FTextureTranslation: single;
        function RenderToTexture(rotation: single): HResult;
        function RenderFadingScene(): HResult;
        function RenderNormalScene(rotation: single): HResult;
    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(screenWidth, screenHeight: integer; hwnd: HWND): HResult;
        procedure Shutdown();
        function Frame(frameTime: single): HResult;
        function Render(): HResult;
    end;

implementation

{ TGraphicsClass }

function TGraphicsClass.Render(): HResult;
var
    worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX;
    clipPlane: TXMFLOAT4;
    blendAmount: single;
begin
    // Update the rotation variable each frame.
    FRotation := FRotation + XM_PI * 0.005;
    if (FRotation > 360.0) then
        FRotation := FRotation - 360.0;

    if (m_fadeDone) then
    begin
        // If fading in is complete then render the scene normally using the back buffer.
        Result := RenderNormalScene(FRotation);
    end
    else
    begin
        // If fading in is not complete then render the scene to a texture and fade that texture in.
        Result := RenderToTexture(FRotation);
        if Result <> S_OK then Exit;
        Result := RenderFadingScene();
    end;
end;



function TGraphicsClass.RenderToTexture(rotation: single): HResult;
var
    worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX;
begin
    // Set the render target to be the render to texture.
    m_RenderTexture.SetRenderTarget(m_Direct3D.GetDeviceContext(), m_Direct3D.GetDepthStencilView());

    // Clear the render to texture.
    m_RenderTexture.ClearRenderTarget(m_Direct3D.GetDeviceContext(), m_Direct3D.GetDepthStencilView(), 0.0, 0.0, 0.0, 1.0);

    // Generate the view matrix based on the camera's position.
    m_Camera.Render();


    // Get the world and projection matrices.
    worldMatrix := m_Direct3D.GetWorldMatrix();
    projectionMatrix := m_Direct3D.GetProjectionMatrix();
    viewMatrix := m_Camera.GetViewMatrix();

    // Multiply the world matrix by the rotation.
    worldMatrix := XMMatrixRotationY(rotation);

    // Put the model vertex and index buffers on the graphics pipeline to prepare them for drawing.
    m_Model.Render(m_Direct3D.GetDeviceContext());

    // Render the model using the texture shader and the reflection view matrix.
    m_TextureShader.Render(m_Direct3D.GetDeviceContext(), m_Model.GetIndexCount(), worldMatrix, viewMatrix,
        projectionMatrix, m_Model.GetTexture());

    // Reset the render target back to the original back buffer and not the render to texture anymore.
    m_Direct3D.SetBackBufferRenderTarget();
    Result := S_OK;
end;




function TGraphicsClass.RenderFadingScene(): HResult;
var
    worldMatrix, viewMatrix, projectionMatrix, reflectionMatrix, orthoMatrix: TXMMATRIX;
begin
    // Clear the buffers to begin the scene.
    m_Direct3D.BeginScene(0.0, 0.0, 0.0, 1.0);

    // Generate the view matrix based on the camera's position.
    m_Camera.Render();

    // Get the world, view, and ortho matrices from the camera and d3d objects.
    worldMatrix := m_Direct3D.GetWorldMatrix;
    viewMatrix := m_Camera.GetViewMatrix;
    orthoMatrix := m_Direct3D.GetOrthoMatrix;

    // Turn off the Z buffer to begin all 2D rendering.
    m_Direct3D.TurnZBufferOff();

    // Put the bitmap vertex and index buffers on the graphics pipeline to prepare them for drawing.
    Result := m_Bitmap.Render(m_Direct3D.GetDeviceContext(), 0, 0);
    if (Result <> S_OK) then Exit;


    // Render the bitmap using the fade shader.
    Result := m_FadeShader.Render(m_Direct3D.GetDeviceContext(), m_Bitmap.GetIndexCount(), worldMatrix, viewMatrix,
        orthoMatrix, m_RenderTexture.GetShaderResourceView(), m_fadePercentage);
    if (Result <> S_OK) then Exit;

    // Turn the Z buffer back on now that all 2D rendering has completed.
    m_Direct3D.TurnZBufferOn();


    // Present the rendered scene to the screen.
    m_Direct3D.EndScene();
end;



function TGraphicsClass.RenderNormalScene(rotation: single): HResult;
var
    worldMatrix, viewMatrix, projectionMatrix: TXMMATRIX;
begin
    // Clear the buffers to begin the scene.
    m_Direct3D.BeginScene(0.0, 0.0, 0.0, 1.0);

    // Generate the view matrix based on the camera's position.
    m_Camera.Render();

    // Get the world, view, and projection matrices from the camera and d3d objects.
    worldMatrix := m_Direct3D.GetWorldMatrix;
    viewMatrix := m_Camera.GetViewMatrix;
    projectionMatrix := m_Direct3D.GetProjectionMatrix;

    // Multiply the world matrix by the rotation.
    worldMatrix := XMMatrixRotationY(rotation);


    // Put the model vertex and index buffers on the graphics pipeline to prepare them for drawing.
    m_Model.Render(m_Direct3D.GetDeviceContext());

    // Render the model with the texture shader.
    Result := m_TextureShader.Render(m_Direct3D.GetDeviceContext(), m_Model.GetIndexCount(), worldMatrix,
        viewMatrix, projectionMatrix, m_Model.GetTexture());
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


    // Create the model object.
    m_Model := TModelClass.Create;

    // Initialize the model object.
    Result := m_Model.Initialize(m_Direct3D.GetDevice(), m_Direct3D.GetDeviceContext(), 'cube.txt', 'seafloor.dds');
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the model object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the texture shader object.
    m_TextureShader := TTextureShaderClass.Create;
    Result := m_TextureShader.Initialize(m_Direct3D.GetDevice(), hwnd);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the exture shader object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the render to texture object.
    m_RenderTexture := TRenderTextureClass.Create;
    // Initialize the render to texture object.
    Result := m_RenderTexture.Initialize(m_Direct3D.GetDevice(), screenWidth, screenHeight);
    if (Result <> S_OK) then Exit;



    // Create the bitmap object.
    m_Bitmap := TBitmapClass.Create;
    Result := m_Bitmap.Initialize(m_Direct3D.GetDevice(), m_Direct3D.GetDeviceContext(), screenWidth, screenHeight, '', screenWidth, screenHeight);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the bitmap object.', 'Error', MB_OK);
        Exit;
    end;

    // Set the fade in time to 3000 milliseconds.
    m_fadeInTime := 3000.0;

    // Initialize the accumulated time to zero milliseconds.
    m_accumulatedTime := 0;

    // Initialize the fade percentage to zero at first so the scene is black.
    m_fadePercentage := 0;

    // Set the fading in effect to not done.
    m_fadeDone := False;



    // Create the fade shader object.
    m_FadeShader := TFadeShaderClass.Create;
    Result := m_FadeShader.Initialize(m_Direct3D.GetDevice(), hwnd);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the fade shader object.', 'Error', MB_OK);
        Exit;
    end;
end;



procedure TGraphicsClass.Shutdown();
begin
    // Release the fade shader object.
    if (m_FadeShader <> nil) then
    begin
        m_FadeShader.Shutdown();
        m_FadeShader.Free;
        m_FadeShader := nil;
    end;


    // Release the bitmap object.
    if (m_Bitmap <> nil) then
    begin
        m_Bitmap.Shutdown();
        m_Bitmap.Free;
        m_Bitmap := nil;
    end;

    // Release the color shader object.
    if (m_TextureShader <> nil) then
    begin
        m_TextureShader.Shutdown();
        m_TextureShader.Free;
        m_TextureShader := nil;
    end;

    // Release the model object.
    if (m_Model <> nil) then
    begin
        m_Model.Shutdown();
        m_Model.Free;
        m_Model := nil;
    end;

    // Release the model object.
    if (m_FloorModel <> nil) then
    begin
        m_FloorModel.Shutdown();
        m_FloorModel.Free;
        m_FloorModel := nil;
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



function TGraphicsClass.Frame(frameTime: single): HResult;
begin
    if (not m_fadeDone) then
    begin
        // Update the accumulated time with the extra frame time addition.
        m_accumulatedTime := m_accumulatedTime + frameTime;

        // While the time goes on increase the fade in amount by the time that is passing each frame.
        if (m_accumulatedTime < m_fadeInTime) then
        begin
            // Calculate the percentage that the screen should be faded in based on the accumulated time.
            m_fadePercentage := m_accumulatedTime / m_fadeInTime;
        end
        else
        begin
            // If the fade in time is complete then turn off the fade effect and render the scene normally.
            m_fadeDone := True;

            // Set the percentage to 100%.
            m_fadePercentage := 1.0;
        end;
    end;
    // Set the initial position of the camera.
    m_Camera.SetPosition(0.0, 0.0, -10.0);
end;

end.
