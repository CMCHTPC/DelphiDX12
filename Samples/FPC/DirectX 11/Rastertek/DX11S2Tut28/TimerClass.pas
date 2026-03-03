unit TimerClass;

{$mode DelphiUnicode}{$H+}

interface

uses
    Classes, SysUtils, Windows;

type

    { TTimerClass }

    TTimerClass = class(TObject)
    private
        m_frequency: int64;
        m_ticksPerMs: single;
        m_startTime: int64;
        m_frameTime: single;
    public
        constructor Create;
        destructor Destroy; override;
        function Initialize(): HResult;
        procedure Frame();
        function GetTime(): single;
    end;

implementation

{ TTimerClass }

constructor TTimerClass.Create;
begin

end;



destructor TTimerClass.Destroy;
begin
    inherited Destroy;
end;



function TTimerClass.Initialize(): HResult;
begin
    // Check to see if this system supports high performance timers.
    QueryPerformanceFrequency(m_frequency);
    if (m_frequency = 0) then
    begin
        Result := E_FAIL;
        Exit;
    end;

    // Find out how many times the frequency counter ticks every millisecond.
    m_ticksPerMs := (m_frequency / 1000);

    QueryPerformanceCounter(m_startTime);

    Result := S_OK;
end;



procedure TTimerClass.Frame();
var
    currentTime: int64;
    timeDifference: single;
begin
    QueryPerformanceCounter(currentTime);
    timeDifference := (currentTime - m_startTime);
    m_frameTime := timeDifference / m_ticksPerMs;
    m_startTime := currentTime;
end;



function TTimerClass.GetTime(): single;
begin
    Result := m_frameTime;
end;

end.
