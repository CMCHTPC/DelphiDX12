unit GraphicsClass;

{$mode delphi}

interface

uses
    Windows, Classes, SysUtils, D3DClass;

const
    FULL_SCREEN: boolean = False;
    VSYNC_ENABLED: boolean = True;
    SCREEN_DEPTH: single = 1000.0;
    SCREEN_NEAR: single = 0.1;

type

    { TGraphicsClass }

    TGraphicsClass = class(TObject)
    private
        FDirect3D: TD3DClass;
    private
        function Render(): boolean;
    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(screenHeight, screenWidth: integer; Handle: HWND): boolean;
        procedure Shutdown();
        function Frame(): boolean;
    end;

implementation

{ TGraphicsClass }

function TGraphicsClass.Render(): boolean;
begin
    // Use the Direct3D object to render the scene.
    Result := FDirect3D.Render();
end;



constructor TGraphicsClass.Create;
begin

end;



destructor TGraphicsClass.Destroy;
begin
    inherited Destroy;
end;



function TGraphicsClass.Initialize(screenHeight, screenWidth: integer; Handle: HWND): boolean;
begin

    Result := False;
    // Create the Direct3D object.
    FDirect3D := TD3DClass.Create;
    if (FDirect3D = nil) then
        Exit;

    // Initialize the Direct3D object.
    Result := FDirect3D.Initialize(screenHeight, screenWidth, Handle, VSYNC_ENABLED, FULL_SCREEN);
    if (not Result) then
        MessageBox(Handle, 'Could not initialize Direct3D.', 'Error', MB_OK);
end;



procedure TGraphicsClass.Shutdown();
begin
    // Release the Direct3D object.
    if (FDirect3D <> nil) then
    begin
        FDirect3D.Shutdown();
        FDirect3D.Free;
        FDirect3D := nil;
    end;

end;



function TGraphicsClass.Frame(): boolean;
begin
    // Render the graphics scene.
    Result := Render();
end;

end.
