unit FPSClass;

interface

uses
    Classes, SysUtils, Windows, MMSystem;

type

    TFpsClass = class(TObject)
    private
        m_fps, m_count: integer;
        m_startTime: Ulong;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Initialize();
        procedure Frame();
        function GetFps(): integer;


    end;


implementation



constructor TFpsClass.Create;
begin
end;



destructor TFpsClass.Destroy;
begin
    inherited;
end;



procedure TFpsClass.Initialize();
begin
    // Initialize the counters and the start time.
    m_fps := 0;
    m_count := 0;
    m_startTime := timeGetTime();
end;



procedure TFpsClass.Frame();
begin
    Inc(m_count);

    // If one second has passed then update the frame per second speed.
    if (timeGetTime() >= (m_startTime + 1000)) then
    begin
        m_fps := m_count;
        m_count := 0;

        m_startTime := timeGetTime();
    end;
end;



function TFpsClass.GetFps(): integer;
begin
    Result := m_fps;
end;

end.
