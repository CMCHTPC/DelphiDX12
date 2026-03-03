unit TimerClass;

interface

uses
	Classes, SysUtils, Windows;
	
type

 TTimerClass = class(TObject)
private
	 m_frequency:INT64;
	 m_ticksPerMs:single;
	 m_startTime:INT64;
	 m_frameTime: single;
public
	constructor Create;
	destructor Destroy; override;

	function Initialize():HResult;
	procedure Frame();

	function GetTime():single;


end;


implementation



constructor TTimerClass.Create;
begin
end;




destructor TTimerClass.Destroy;
begin
inherited
end;


function TTimerClass.Initialize():HResult;
begin
	Result:=E_FAIL;
	// Check to see if this system supports high performance timers.
	QueryPerformanceFrequency(m_frequency);
	if(m_frequency = 0) then Exit;
	

	// Find out how many times the frequency counter ticks every millisecond.
	m_ticksPerMs := (m_frequency / 1000);

	QueryPerformanceCounter(m_startTime);

	Result:=S_OK;
end;


procedure TTimerClass.Frame();
var
	 currentTime:INT64;
	timeDifference: single;
begin

	// Query the current time.
	QueryPerformanceCounter(currentTime);

	// Calculate the difference in time since the last time we queried for the current time.
	timeDifference := (currentTime - m_startTime);

	// Calculate the frame time by the time difference over the timer speed resolution.
	m_frameTime := timeDifference / m_ticksPerMs;

	// Restart the timer.
	m_startTime := currentTime;
end;


function TTimerClass.GetTime():single;
begin
	result:= m_frameTime;
end;

end.