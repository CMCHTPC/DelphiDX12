unit CPUClass;

interface

uses
    Classes, SysUtils, Windows,
    Win32.PDH;

type
    TCpuClass = class(TObject)

    public
        constructor Create;
        destructor Destroy; override;
        procedure Initialize();
        procedure Shutdown();
        procedure Frame();
        function GetCpuPercentage(): integer;

    private
        m_canReadCpu: boolean;
        m_queryHandle: HQUERY;
        m_counterHandle: HCOUNTER;
        m_lastSampleTime: ulong;
        m_cpuUsage: long;
    end;

implementation

constructor TCpuClass.Create;
begin
end;

destructor TCpuClass.Destroy;
begin
    inherited;
end;

procedure TCpuClass.Initialize();
var
    status: TPDH_STATUS;
    s: ansistring;
begin

    // Initialize the flag indicating whether this object can read the system cpu usage or not.
    m_canReadCpu := true;

    // Create a query object to poll cpu usage.
    status := PdhOpenQueryA(nil, 0, m_queryHandle);
    if (status <> ERROR_SUCCESS) then
    begin
        m_canReadCpu := false;
    end;
    s:='\\Processor(0)\\% Processor Time';
    // Set query object to poll all cpus in the system.
    status := PdhAddCounterA(m_queryHandle, LPCSTR(s), 0, m_counterHandle);
    if (status <> ERROR_SUCCESS) then
    begin
        m_canReadCpu := false;
    end;

    // Initialize the start time and cpu usage.
    m_lastSampleTime := GetTickCount();
    m_cpuUsage := 0;
end;

procedure TCpuClass.Shutdown();
begin
    if (m_canReadCpu) then
    begin
        PdhCloseQuery(m_queryHandle);
    end;
end;

procedure TCpuClass.Frame();
var
    value: TPDH_FMT_COUNTERVALUE;
    lType: Cardinal;
    status: TPDH_STATUS;
begin
    if (m_canReadCpu) then
    begin
        // If it has been 1 second then update the current cpu usage and reset the 1 second timer again.
        if ((m_lastSampleTime + 1000) < GetTickCount()) then
        begin
            m_lastSampleTime := GetTickCount();

            status:=PdhCollectQueryData(m_queryHandle);

            status:= PdhGetFormattedCounterValue(m_counterHandle, PDH_FMT_LONG, lType, value);

            m_cpuUsage := value.longValue;
        end;
    end;
end;

function TCpuClass.GetCpuPercentage(): integer;
begin

    // If the class can read the cpu from the operating system then return the current usage.  If not then return zero.
    if (m_canReadCpu) then
    begin
        result := m_cpuUsage;
    end
    else
    begin
        result := 0;
    end;
end;

end.
