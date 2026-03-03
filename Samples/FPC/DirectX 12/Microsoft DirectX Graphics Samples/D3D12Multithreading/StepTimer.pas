//*********************************************************

// Copyright (c) Microsoft. All rights reserved.
// This code is licensed under the MIT License (MIT).
// THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
// IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
// PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.

//*********************************************************
unit StepTimer;

{$mode ObjFPC}{$H+}

interface

uses
    Windows,Classes, SysUtils;

type

    TLPUPDATEFUNC = procedure;
    // Helper class for animation and simulation timing.

    { TStepTimer }

    TStepTimer = class(TObject)
    const
        // Integer format represents time using 10,000,000 ticks per second.
        TicksPerSecond = uint64(10000000);

    protected
        // Source timing data uses QPC units.
        m_qpcFrequency: LARGE_INTEGER;
        m_qpcLastTime: LARGE_INTEGER;
        m_qpcMaxDelta: uint64;
        // Derived timing data uses a canonical tick format.
        m_elapsedTicks: uint64;
        m_totalTicks: uint64;
        m_leftOverTicks: uint64;
        // Members for tracking the framerate.
        m_frameCount: uint32;
        m_framesPerSecond: uint32;
        m_framesThisSecond: uint32;
        m_qpcSecondCounter: uint64;
        // Members for configuring fixed timestep mode.
        m_isFixedTimeStep: winbool;
        m_targetElapsedTicks: uint64;
    public
        constructor Create;
        destructor Destroy; override;

        // Get elapsed time since the previous Update call.
        function GetElapsedTicks(): uint64;
        function GetElapsedSeconds(): double;
        // Get total time since the start of the program.
        function GetTotalTicks(): uint64;
        function GetTotalSeconds(): double;
        // Get total number of updates since start of the program.
        function GetFrameCount(): uint32;
       // Get the current framerate.
        function GetFramesPerSecond(): uint32;
       // Set whether to use fixed or variable timestep mode.
        procedure SetFixedTimeStep(isFixedTimestep: winbool);
        // Set how often to call Update when in fixed timestep mode.
        procedure SetTargetElapsedTicks(targetElapsed: uint64);
        procedure SetTargetElapsedSeconds(targetElapsed: double);
        function TicksToSeconds(ticks: uint64): double;
        function SecondsToTicks(seconds: double): uint64;


        // After an intentional timing discontinuity (for instance a blocking IO operation)
        // call this to avoid having the fixed timestep logic attempt a set of catch-up
        // Update calls.

        procedure ResetElapsedTime();


        procedure Tick(update: TLPUPDATEFUNC = nil);

    end;

implementation

{ TStepTimer }

constructor TStepTimer.Create;
begin
   m_elapsedTicks:=0;
        m_totalTicks:=0;
        m_leftOverTicks:=0;
        m_frameCount:=0;
        m_framesPerSecond:=0;
        m_framesThisSecond:=0;
        m_qpcSecondCounter:=0;
        m_isFixedTimeStep:=false;
        m_targetElapsedTicks:=TicksPerSecond div 60;

        QueryPerformanceFrequency(@m_qpcFrequency);
        QueryPerformanceCounter(@m_qpcLastTime);

        // Initialize max delta to 1/10 of a second.
        m_qpcMaxDelta := m_qpcFrequency.QuadPart div 10;
end;



destructor TStepTimer.Destroy;
begin
    inherited Destroy;
end;

// Get elapsed time since the previous Update call.
function TStepTimer.GetElapsedTicks(): uint64;
begin
   result:= m_elapsedTicks;
end;

function TStepTimer.GetElapsedSeconds(): double;
begin
   result:= TicksToSeconds(m_elapsedTicks);
end;


// Get total time since the start of the program.
function TStepTimer.GetTotalTicks(): uint64;
begin
   result:= m_totalTicks;
end;

function TStepTimer.GetTotalSeconds(): double;
begin
   result:= TicksToSeconds(m_totalTicks);
end;


// Get total number of updates since start of the program.
function TStepTimer.GetFrameCount(): uint32;
begin
  result:= m_frameCount;
end;

// Get the current framerate.
function TStepTimer.GetFramesPerSecond(): uint32;
begin
    result:= m_framesPerSecond;
end;


// Set whether to use fixed or variable timestep mode.
procedure TStepTimer.SetFixedTimeStep(isFixedTimestep: winbool);
begin
   m_isFixedTimeStep := isFixedTimestep;
end;

// Set how often to call Update when in fixed timestep mode.
procedure TStepTimer.SetTargetElapsedTicks(targetElapsed: uint64);
begin
    m_targetElapsedTicks := targetElapsed;
end;

procedure TStepTimer.SetTargetElapsedSeconds(targetElapsed: double);
begin
    m_targetElapsedTicks := SecondsToTicks(targetElapsed);
end;

function TStepTimer.TicksToSeconds(ticks: uint64): double;
begin
   result:= double(ticks) / TicksPerSecond;
end;

function TStepTimer.SecondsToTicks(seconds: double): uint64;
begin
     result:= UINT64(seconds * TicksPerSecond);
end;

// After an intentional timing discontinuity (for instance a blocking IO operation)
    // call this to avoid having the fixed timestep logic attempt a set of catch-up
    // Update calls.
procedure TStepTimer.ResetElapsedTime();
begin
    QueryPerformanceCounter(@m_qpcLastTime);

        m_leftOverTicks := 0;
        m_framesPerSecond := 0;
        m_framesThisSecond := 0;
        m_qpcSecondCounter := 0;
end;

// Update timer state, calling the specified Update function the appropriate number of times.
procedure TStepTimer.Tick(update: TLPUPDATEFUNC);
var
  currentTime :LARGE_INTEGER;
		 timeDelta:UINT64;
		 lastFrameCount:UINT32;
begin
  // Query the current time.


        QueryPerformanceCounter(@currentTime);

         timeDelta := currentTime.QuadPart - m_qpcLastTime.QuadPart;

        m_qpcLastTime := currentTime;
        m_qpcSecondCounter :=m_qpcSecondCounter+ timeDelta;

        // Clamp excessively large time deltas (e.g. after paused in the debugger).
        if (timeDelta > m_qpcMaxDelta) then
        begin
            timeDelta := m_qpcMaxDelta;
        end;

        // Convert QPC units into a canonical tick format. This cannot overflow due to the previous clamp.
        timeDelta :=timeDelta* TicksPerSecond;
        timeDelta :=timeDelta div m_qpcFrequency.QuadPart;

         lastFrameCount := m_frameCount;

        if (m_isFixedTimeStep) then
        begin
            // Fixed timestep update logic

            // If the app is running very close to the target elapsed time (within 1/4 of a millisecond) just clamp
            // the clock to exactly match the target value. This prevents tiny and irrelevant errors
            // from accumulating over time. Without this clamping, a game that requested a 60 fps
            // fixed update, running with vsync enabled on a 59.94 NTSC display, would eventually
            // accumulate enough tiny errors that it would drop a frame. It is better to just round
            // small deviations down to zero to leave things running smoothly.

            if (abs(int32(timeDelta - m_targetElapsedTicks)) < TicksPerSecond div 4000) then
            begin
                timeDelta := m_targetElapsedTicks;
            end;

            m_leftOverTicks :=m_leftOverTicks+ timeDelta;

            while (m_leftOverTicks >= m_targetElapsedTicks) do
            begin
                m_elapsedTicks := m_targetElapsedTicks;
                m_totalTicks:=m_totalTicks + m_targetElapsedTicks;
                m_leftOverTicks :=m_leftOverTicks- m_targetElapsedTicks;
                inc(m_frameCount);

                if (update<>nil) then
                begin
                    update();
                end;
            end;
        end
        else
        begin
            // Variable timestep update logic.
            m_elapsedTicks := timeDelta;
            m_totalTicks :=m_totalTicks+ timeDelta;
            m_leftOverTicks := 0;
           inc( m_frameCount);

            if (update<>nil) then
            begin
                update();
            end;
        end;

        // Track the current framerate.
        if (m_frameCount <> lastFrameCount)then
        begin
            inc(m_framesThisSecond);
        end;

        if (m_qpcSecondCounter >= UINT64(m_qpcFrequency.QuadPart)) then
        begin
            m_framesPerSecond := m_framesThisSecond;
            m_framesThisSecond := 0;
            m_qpcSecondCounter :=m_qpcSecondCounter mod m_qpcFrequency.QuadPart;
        end;
end;

end.
