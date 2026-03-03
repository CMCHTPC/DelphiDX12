unit TimerClass;

{$IFDEF FPC}
{$mode DelphiUnicode}{$H+}
{$ENDIF}

interface

uses
    Classes, SysUtils, Windows;

type

    { TTimerClass }

    TTimerClass = class(TObject)
    private
        m_beginTime: int64;
        m_frequency: int64;
        m_ticksPerMs: single;
        m_startTime: int64;
        m_frameTime: single;
        m_endTime: int64;
    public
        constructor Create;
        destructor Destroy; override;
        function Initialize(): HResult;
        procedure Frame();
        function GetTime(): single;

        procedure StartTimer;
        procedure StopTimer;
        function GetTiming: integer;
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
    elapsedTicks: single;
begin
    QueryPerformanceCounter(currentTime);
    elapsedTicks := (currentTime - m_startTime);
    m_frameTime := elapsedTicks / m_frequency;

    // Restart the timer.
    m_startTime := currentTime;
end;



function TTimerClass.GetTime(): single;
begin
    Result := m_frameTime;
end;



procedure TTimerClass.StartTimer;
begin
    QueryPerformanceCounter(m_beginTime);
end;



procedure TTimerClass.StopTimer;
begin
    QueryPerformanceCounter(m_endTime);
end;



function TTimerClass.GetTiming: integer;
var
    elapsedTicks: single;
    frequency: int64;
    milliseconds: single;
begin

    // Get the elapsed ticks between the two times.
    elapsedTicks := m_endTime - m_beginTime;

    // Get the ticks per second speed of the timer.
    QueryPerformanceFrequency(frequency);

    // Calculate the elapsed time in milliseconds.
    milliseconds := (elapsedTicks / frequency) * 1000.0;

    Result := trunc(milliseconds);
end;

end.
