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
    LightShaderClass;



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
        m_Light1: TLightClass;
        m_Light2: TLightClass;
        m_Light3: TLightClass;
        m_Light4: TLightClass;
        m_LightShader: TLightShaderClass;
    private
        FRotation: single;
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
        worldMatrix, viewMatrix, projectionMatrix :TXMMATRIX;
   	 diffuseColor: array [0..3] of TXMFLOAT4;
   	lightPosition: array [0..3] of TXMFLOAT4;
begin





   	// Create the diffuse color array from the four light colors.
   	diffuseColor[0] := m_Light1.GetDiffuseColor();
   	diffuseColor[1] := m_Light2.GetDiffuseColor();
   	diffuseColor[2] := m_Light3.GetDiffuseColor();
   	diffuseColor[3] := m_Light4.GetDiffuseColor();

   	// Create the light position array from the four light positions.
   	lightPosition[0] := m_Light1.GetPosition();
   	lightPosition[1] := m_Light2.GetPosition();
   	lightPosition[2] := m_Light3.GetPosition();
   	lightPosition[3] := m_Light4.GetPosition();

   	// Clear the buffers to begin the scene.
   	m_Direct3D.BeginScene(0.0, 0.0, 0.0, 1.0);

   	// Generate the view matrix based on the camera's position.
   	m_Camera.Render();

   	// Get the world, view, and projection matrices from the camera and d3d objects.
   worldMatrix:=	m_Direct3D.GetWorldMatrix();
   viewMatrix:=	m_Camera.GetViewMatrix();
   projectionMatrix:=	m_Direct3D.GetProjectionMatrix();

   	// Put the model vertex and index buffers on the graphics pipeline to prepare them for drawing.
   	m_Model.Render(m_Direct3D.GetDeviceContext());

   	// Render the model using the light shader and the light arrays.
   	result := m_LightShader.Render(m_Direct3D.GetDeviceContext(), m_Model.GetIndexCount(), worldMatrix, viewMatrix, projectionMatrix,
   								   m_Model.GetTexture(), diffuseColor, lightPosition);
   	if(result<>S_OK) then Exit;

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

    // Create the ground model object.
    m_Model := TModelClass.Create;


    // Initialize the model object.
    Result := m_Model.Initialize(m_Direct3D.GetDevice(), m_Direct3D.GetDeviceContext(), '.\data\plane01.txt', '.\data\stone01.dds');
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the model object.', 'Error', MB_OK);
        Exit;
    end;




    // Create the light shader object.
    m_LightShader := TLightShaderClass.Create;
    // Initialize the light shader object.
    Result := m_LightShader.Initialize(m_Direct3D.GetDevice(), hwnd);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the light shader object.', 'Error', MB_OK);
        Exit;
    end;

    // Create and Initialize the light object.
    m_Light1 := TLightClass.Create;
    m_Light1.SetAmbientColor(0.15, 0.15, 0.15, 1.0);
    m_Light1.SetDiffuseColor(1.0, 0.0, 0.0, 1.0);
    m_Light1.SetPosition(-3.0, 1.0, 3.0);
    m_Light1.SetDirection(0.0, -1.0, 0.5);

    m_Light2 := TLightClass.Create;
    m_Light2.SetAmbientColor(0.15, 0.15, 0.15, 1.0);
    m_Light2.SetDiffuseColor(0.0, 1.0, 0.0, 1.0);
    m_Light2.SetPosition(3.0, 1.0, 3.0);
    m_Light2.SetDirection(0.0, -1.0, 0.5);

    m_Light3 := TLightClass.Create;
    m_Light3.SetAmbientColor(0.15, 0.15, 0.15, 1.0);
    m_Light3.SetDiffuseColor(0.0, 0.0, 1.0, 1.0);
    m_Light3.SetPosition(-3.0, 1.0, -3.0);
    m_Light3.SetDirection(0.0, -1.0, 0.5);

    m_Light4 := TLightClass.Create;
    m_Light4.SetAmbientColor(0.15, 0.15, 0.15, 1.0);
    m_Light4.SetDiffuseColor(1.0, 1.0, 1.0, 1.0);
    m_Light4.SetPosition(3.0, 1.0, -3.0);
    m_Light4.SetDirection(0.0, -1.0, 0.5);

end;



procedure TGraphicsClass.Shutdown();
begin

    // Release the light object.

    if (m_Light1 <> nil) then
    begin
        m_Light1.Free;
        m_Light1 := nil;
    end;

    if (m_Light2 <> nil) then
    begin
        m_Light2.Free;
        m_Light2 := nil;
    end;



    if (m_Light3 <> nil) then
    begin
        m_Light3.Free;
        m_Light3 := nil;
    end;

    if (m_Light4 <> nil) then
    begin
        m_Light4.Free;
        m_Light4 := nil;
    end;

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
    // Set the position and rotation of the camera.
    m_Camera.SetPosition(0.0, 2.0, -12.0);
   // Render the scene.
   result := Render();

end;

end.
