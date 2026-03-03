unit ApplicationClass;

{$IFDEF FPC}
{$mode DelphiUnicode}{$H+}
{$ENDIF}

interface

uses
    Classes, SysUtils, Windows,
    InputClass,
    D3DClass,
    ShaderManagerClass,
    texturemanagerclass,
    TimerClass,
    FPSClass,
    ZoneClass;

const

    FULL_SCREEN: boolean = False;
    VSYNC_ENABLED: boolean = True;
    SCREEN_DEPTH: single = 1000.0;
    SCREEN_NEAR: single = 0.1;

type

    { TApplicationClass }

    TApplicationClass = class(TObject)
    protected
        m_Input: TInputClass;
        m_Direct3D: TD3DClass;
        m_ShaderManager: TShaderManagerClass;
        m_TextureManager: TTextureManagerClass;
        m_Timer: TTimerClass;
        m_Fps: TFpsClass;
        m_Zone: TZoneClass;
    public
        constructor Create;
        destructor Destroy; override;
        procedure Shutdown;
        function Frame(): HResult;
        function Initialize(hinstance: HINST; hwnd: HWND; screenWidth, screenHeight: integer): HResult;
    end;

implementation

{ TApplicationClass }

constructor TApplicationClass.Create;
begin
    m_Input := nil;
    m_Direct3D := nil;
    m_Timer := nil;
    m_Fps := nil;
    m_ShaderManager := nil;
    m_Zone := nil;
end;



destructor TApplicationClass.Destroy;
begin
    inherited Destroy;
end;



function TApplicationClass.Initialize(hinstance: HINST; hwnd: HWND; screenWidth, screenHeight: integer): HResult;
begin

    // Create the input object.
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

    // Create the shader manager object.
    m_ShaderManager := TShaderManagerClass.Create;
    // Initialize the shader manager object.
    Result := m_ShaderManager.Initialize(m_Direct3D.GetDevice(), hwnd);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the shader manager object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the texture manager object.
    m_TextureManager := TTextureManagerClass.Create;

    // Initialize the texture manager object.
    Result := m_TextureManager.Initialize(10);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the texture manager object.', 'Error', MB_OK);
        Exit;
    end;

    // Load textures into the texture manager.
    Result := m_TextureManager.LoadTexture(m_Direct3D.GetDevice(), m_Direct3D.GetDeviceContext(), '.\data\textures\dirt01d.tga', 0);
    if (Result <> S_OK) then Exit;

    Result := m_TextureManager.LoadTexture(m_Direct3D.GetDevice(), m_Direct3D.GetDeviceContext(), '.\data\textures\dirt01n.tga', 1);
    if (Result <> S_OK) then Exit;

    // Create the timer object.
    m_Timer := TTimerClass.Create;

    // Initialize the timer object.
    Result := m_Timer.Initialize();
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the timer object.', 'Error', MB_OK);
        Exit;
    end;

    // Create the fps object.
    m_Fps := TFpsClass.Create;

    // Initialize the fps object.
    m_Fps.Initialize();

    // Create the zone object.
    m_Zone := TZoneClass.Create;

    // Initialize the zone object.
    Result := m_Zone.Initialize(m_Direct3D, hwnd, screenWidth, screenHeight, SCREEN_DEPTH);
    if (Result <> S_OK) then
    begin
        MessageBoxW(hwnd, 'Could not initialize the zone object.', 'Error', MB_OK);
        Exit;
    end;

end;



procedure TApplicationClass.Shutdown;
begin
    // Release the zone object.
    if (m_Zone <> nil) then
    begin
        m_Zone.Shutdown();
        m_Zone.Free;
        m_Zone := nil;
    end;

    // Release the fps object.
    if (m_Fps <> nil) then
    begin
        m_Fps.Free;
        m_Fps := nil;
    end;

    // Release the timer object.
    if (m_Timer <> nil) then
    begin
        m_Timer.Free;
        m_Timer := nil;
    end;

    // Release the shader manager object.
    if (m_ShaderManager <> nil) then
    begin
        m_ShaderManager.Shutdown();
        m_ShaderManager.Free;
        m_ShaderManager := nil;
    end;

    // Release the texture manager object.
    if (m_TextureManager<>nil) then
    begin
        m_TextureManager.Shutdown();
        m_TextureManager.Free;
        m_TextureManager := nil;
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
    // Update the system stats.
    m_Fps.Frame();
    m_Timer.Frame();

    // Do the input frame processing.
    Result := m_Input.Frame();
    if (Result <> S_OK) then Exit;
    // Check if the user pressed escape and wants to exit the application.
    if (m_Input.IsEscapePressed()) then
    begin
        Result := E_FAIL;
        Exit;
    end;

    // Do the zone frame processing.
    Result := m_Zone.Frame(m_Direct3D, m_Input, m_ShaderManager, m_TextureManager, m_Timer.GetTime(), m_Fps.GetFps());
end;



end.
