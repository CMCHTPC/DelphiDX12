unit CPUClass;

{$mode DelphiUnicode}{$H+}

interface

uses
    Classes, SysUtils, Windows, Win32.Pdh;

type

    { TCPUClass }

    TCPUClass = class(TObject)
    private
        m_canReadCpu: boolean;
        m_queryHandle: HQUERY;
        m_counterHandle: HCOUNTER;
        m_lastSampleTime: uint32;
        m_cpuUsage: int32;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Initialize();
        procedure Shutdown();
        procedure Frame();
        function GetCpuPercentage(): integer;
    end;

implementation

{ TCPUClass }

constructor TCPUClass.Create;
begin

end;



destructor TCPUClass.Destroy;
begin
    inherited Destroy;
end;



procedure TCPUClass.Initialize();
var
    status: PDH_STATUS;
    sTemp: widestring;
begin
    // Initialize the flag indicating whether this object can read the system cpu usage or not.
    m_canReadCpu := True;

    // Create a query object to poll cpu usage.
    status := PdhOpenQueryW(nil, 0, m_queryHandle);
    if (status <> ERROR_SUCCESS) then
    begin
        m_canReadCpu := False;
    end;

    // Set query object to poll all cpus in the system.
    sTemp:=UTF8Decode('\\Processor(_Total)\\% processor time');
    status := PdhAddCounterW(m_queryHandle, pWideChar(sTemp), 0, m_counterHandle);
    if (status <> ERROR_SUCCESS) then
    begin
        m_canReadCpu := False;
    end;

    m_lastSampleTime := GetTickCount();

    m_cpuUsage := 0;
end;



procedure TCPUClass.Shutdown();
begin
    if (m_canReadCpu) then
    begin
        PdhCloseQuery(m_queryHandle);
    end;
end;



procedure TCPUClass.Frame();
var
    Value: TPDH_FMT_COUNTERVALUE;
    lType: DWord;
    status: PDH_STATUS;
begin
    if (m_canReadCpu) then
    begin
        if ((m_lastSampleTime + 1000) < GetTickCount()) then
        begin
            m_lastSampleTime := GetTickCount();
            status := PdhCollectQueryData(m_queryHandle);
            status := PdhGetFormattedCounterValue(m_counterHandle, PDH_FMT_LONG, lType, Value);
            m_cpuUsage := Value.longValue;
        end;
    end;
end;



function TCPUClass.GetCpuPercentage(): integer;
begin
    if (m_canReadCpu) then
    begin
        Result := m_cpuUsage;
    end
    else
    begin
        Result := 0;
    end;
end;

end.
