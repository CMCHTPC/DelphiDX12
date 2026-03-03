unit FPSClass;

{$mode DelphiUnicode}{$H+}

interface

uses
    Classes, SysUtils, Windows, MMSystem;

type

    { TFPSClass }

    TFPSClass = class(TObject)
    private
        m_fps, m_count: integer;
        m_startTime: uint32;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Initialize();
        procedure Frame();
        function GetFps(): integer;
    end;

implementation

{ TFPSClass }

constructor TFPSClass.Create;
begin

end;



destructor TFPSClass.Destroy;
begin
    inherited Destroy;
end;



procedure TFPSClass.Initialize();
begin
    m_fps := 0;
    m_count := 0;
    m_startTime := timeGetTime();
end;



procedure TFPSClass.Frame();
begin
    Inc(m_count);

    if (timeGetTime() >= (m_startTime + 1000)) then
    begin
        m_fps := m_count;
        m_count := 0;
        m_startTime := timeGetTime();
    end;
end;



function TFPSClass.GetFps(): integer;
begin
    Result := m_fps;
end;

end.
