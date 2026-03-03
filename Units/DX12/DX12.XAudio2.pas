{ **************************************************************************
    FreePascal/Delphi DirectX 12 Header Files

    Copyright (C) 2013-2025 Norbert Sonnleitner

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
************************************************************************** }

{ **************************************************************************
   Additional Copyright (C) for this modul:

   Copyright (c) Microsoft Corporation.  All rights reserved.
   Content: Declarations for the XAudio2 game audio API.

   This unit consists of the following header files
   File name: xaudio2.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.XAudio2;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    Win32.MMReg,
    DX12.SDKDDKVer,
    DX12.AudioSessionTypes;

    {$Z4}

const
    XAUDIO2_DLL = 'XAudio2_9.dll';

const

    // Compiling with C++ for Windows 10 and later
    // XAudio 2.9
    IID_IXAudio2: TGUID = '{2B02E3CF-2E0B-4ec3-BE45-1B2A3FE7210D}';
    IID_IXAudio2Extension: TGUID = '{84ac29bb-d619-44d2-b197-e4acf7df3ed6}';
    // Compiling with C++ for Windows 8 or 8.1
    // XAudio 2.8
    IID_IXAudio2_v28: TGUID = '{60d8dac8-5aa1-4e8e-b597-2f5e2883d484}';

    M_PI = 3.14159265358979323846;

(**************************************************************************
 *
 * XAudio2 constants, flags and error codes.
 *
 **************************************************************************)
    // Numeric boundary values

    XAUDIO2_MAX_BUFFER_BYTES = $80000000; // Maximum bytes allowed in a source buffer
    XAUDIO2_MAX_QUEUED_BUFFERS = 64; // Maximum buffers allowed in a voice queue
    XAUDIO2_MAX_BUFFERS_SYSTEM = 2; // Maximum buffers allowed for system threads (Xbox 360 only)
    XAUDIO2_MAX_AUDIO_CHANNELS = 64; // Maximum channels in an audio stream
    XAUDIO2_MIN_SAMPLE_RATE = 1000; // Minimum audio sample rate supported
    XAUDIO2_MAX_SAMPLE_RATE = 200000; // Maximum audio sample rate supported
    XAUDIO2_MAX_VOLUME_LEVEL = 16777216.0; // Maximum acceptable volume level (2^24)
    XAUDIO2_MIN_FREQ_RATIO = (1 / 1024.0); // Minimum SetFrequencyRatio argument
    XAUDIO2_MAX_FREQ_RATIO = 1024.0; // Maximum MaxFrequencyRatio argument
    XAUDIO2_DEFAULT_FREQ_RATIO = 2.0; // Default MaxFrequencyRatio argument
    XAUDIO2_MAX_FILTER_ONEOVERQ = 1.5; // Maximum XAUDIO2_FILTER_PARAMETERS.OneOverQ
    XAUDIO2_MAX_FILTER_FREQUENCY = 1.0; // Maximum XAUDIO2_FILTER_PARAMETERS.Frequency
    XAUDIO2_MAX_LOOP_COUNT = 254; // Maximum non-infinite XAUDIO2_BUFFER.LoopCount
    XAUDIO2_MAX_INSTANCES = 8; // Maximum simultaneous XAudio2 objects on Xbox 360

    // For XMA voices on Xbox 360 there is an additional restriction on the MaxFrequencyRatio
    // argument and the voice's sample rate: the product of these numbers cannot exceed 600000
    // for one-channel voices or 300000 for voices with more than one channel.
    XAUDIO2_MAX_RATIO_TIMES_RATE_XMA_MONO = 600000;
    XAUDIO2_MAX_RATIO_TIMES_RATE_XMA_MULTICHANNEL = 300000;

    // Numeric values with special meanings
    XAUDIO2_COMMIT_NOW = 0; // Used as an OperationSet argument
    XAUDIO2_COMMIT_ALL = 0; // Used in IXAudio2::CommitChanges
    XAUDIO2_INVALID_OPSET = uint32(-1); // Not allowed for OperationSet arguments
    XAUDIO2_NO_LOOP_REGION = 0; // Used in XAUDIO2_BUFFER.LoopCount
    XAUDIO2_LOOP_INFINITE = 255; // Used in XAUDIO2_BUFFER.LoopCount
    XAUDIO2_DEFAULT_CHANNELS = 0; // Used in CreateMasteringVoice
    XAUDIO2_DEFAULT_SAMPLERATE = 0; // Used in CreateMasteringVoice

    // Flags
    XAUDIO2_DEBUG_ENGINE = $0001; // Used in XAudio2Create
    XAUDIO2_VOICE_NOPITCH = $0002; // Used in IXAudio2::CreateSourceVoice
    XAUDIO2_VOICE_NOSRC = $0004; // Used in IXAudio2::CreateSourceVoice
    XAUDIO2_VOICE_USEFILTER = $0008; // Used in IXAudio2::CreateSource/SubmixVoice
    XAUDIO2_PLAY_TAILS = $0020; // Used in IXAudio2SourceVoice::Stop
    XAUDIO2_END_OF_STREAM = $0040; // Used in XAUDIO2_BUFFER.Flags
    XAUDIO2_SEND_USEFILTER = $0080; // Used in XAUDIO2_SEND_DESCRIPTOR.Flags
    XAUDIO2_VOICE_NOSAMPLESPLAYED = $0100; // Used in IXAudio2SourceVoice::GetState
    XAUDIO2_STOP_ENGINE_WHEN_IDLE = $2000; // Used in XAudio2Create to force the engine to Stop when no source voices are Started, and Start when a voice is Started
    XAUDIO2_1024_QUANTUM = $8000; // Used in XAudio2Create to specify nondefault processing quantum of 21.33 ms (1024 samples at 48KHz)
    XAUDIO2_NO_VIRTUAL_AUDIO_CLIENT = $10000; // Used in CreateMasteringVoice to create a virtual audio client

    // Default parameters for the built-in filter
    // TODO XAUDIO2_DEFAULT_FILTER_TYPE = LowPassFilter;
    XAUDIO2_DEFAULT_FILTER_FREQUENCY = XAUDIO2_MAX_FILTER_FREQUENCY;
    XAUDIO2_DEFAULT_FILTER_ONEOVERQ = 1.0;

    // Internal XAudio2 constants
    // The audio frame quantum can be calculated by reducing the fraction:
    //     SamplesPerAudioFrame / SamplesPerSecond
    XAUDIO2_QUANTUM_NUMERATOR = 1; // On Windows, XAudio2 processes audio
    XAUDIO2_QUANTUM_DENOMINATOR = 100; //  in 10ms chunks (= 1/100 seconds)
    XAUDIO2_QUANTUM_MS = (1000.0 * XAUDIO2_QUANTUM_NUMERATOR / XAUDIO2_QUANTUM_DENOMINATOR);

    // XAudio2 error codes
    FACILITY_XAUDIO2 = $896;
    XAUDIO2_E_INVALID_CALL = HRESULT($88960001); // An API call or one of its arguments was illegal
    XAUDIO2_E_XMA_DECODER_ERROR = HRESULT($88960002); // The XMA hardware suffered an unrecoverable error
    XAUDIO2_E_XAPO_CREATION_FAILED = HRESULT($88960003); // XAudio2 failed to initialize an XAPO effect
    XAUDIO2_E_DEVICE_INVALIDATED = HRESULT($88960004); // An audio device became unusable (unplugged, etc)

    (**************************************************************************
 *
 * XAudio2 structures and enumerations.
 *
 **************************************************************************)

    Processor1 = $00000001;
    Processor2 = $00000002;
    Processor3 = $00000004;
    Processor4 = $00000008;
    Processor5 = $00000010;
    Processor6 = $00000020;
    Processor7 = $00000040;
    Processor8 = $00000080;
    Processor9 = $00000100;
    Processor10 = $00000200;
    Processor11 = $00000400;
    Processor12 = $00000800;
    Processor13 = $00001000;
    Processor14 = $00002000;
    Processor15 = $00004000;
    Processor16 = $00008000;
    Processor17 = $00010000;
    Processor18 = $00020000;
    Processor19 = $00040000;
    Processor20 = $00080000;
    Processor21 = $00100000;
    Processor22 = $00200000;
    Processor23 = $00400000;
    Processor24 = $00800000;
    Processor25 = $01000000;
    Processor26 = $02000000;
    Processor27 = $04000000;
    Processor28 = $08000000;
    Processor29 = $10000000;
    Processor30 = $20000000;
    Processor31 = $40000000;
    Processor32 = $80000000;
    XAUDIO2_ANY_PROCESSOR = $ffffffff;


    // This value indicates that XAudio2 will choose the default processor by itself. The actual value chosen
    // may vary depending on the hardware platform.
    XAUDIO2_USE_DEFAULT_PROCESSOR = $00000000;



    // This definition is included for backwards compatibilty. Implementations targeting Games and WIN10_19H1 and later, should use
    // XAUDIO2_USE_DEFAULT_PROCESSOR instead to let XAudio2 select the appropriate default processor for the hardware platform.
    XAUDIO2_DEFAULT_PROCESSOR = Processor1;



    // Values for the TraceMask and BreakMask bitmaps.  Only ERRORS and WARNINGS
    // are valid in BreakMask.  WARNINGS implies ERRORS, DETAIL implies INFO, and
    // FUNC_CALLS implies API_CALLS.  By default, TraceMask is ERRORS and WARNINGS
    // and all the other settings are zero.
    XAUDIO2_LOG_ERRORS = $0001; // For handled errors with serious effects.
    XAUDIO2_LOG_WARNINGS = $0002; // For handled errors that may be recoverable.
    XAUDIO2_LOG_INFO = $0004; // Informational chit-chat (e.g. state changes).
    XAUDIO2_LOG_DETAIL = $0008; // More detailed chit-chat.
    XAUDIO2_LOG_API_CALLS = $0010; // Public API function entries and exits.
    XAUDIO2_LOG_FUNC_CALLS = $0020; // Internal function entries and exits.
    XAUDIO2_LOG_TIMING = $0040; // Delays detected and other timing data.
    XAUDIO2_LOG_LOCKS = $0080; // Usage of critical sections and mutexes.
    XAUDIO2_LOG_MEMORY = $0100; // Memory heap usage information.
    XAUDIO2_LOG_STREAMING = $1000; // Audio streaming information.


type
    {$PACKRECORDS 1}
(**************************************************************************
 *
 * Forward declarations for the XAudio2 interfaces.
 *
 **************************************************************************)

    PIUnknown = ^IUnknown;
    IXAudio2 = interface;

    {$IFDEF FPC}
    {$interfaces corba}
    IXAudio2Voice = interface;
    PIXAudio2Voice = ^IXAudio2Voice;


    IXAudio2SourceVoice = interface;
    IXAudio2SubmixVoice = interface;
    IXAudio2MasteringVoice = interface;
    IXAudio2EngineCallback = interface;
    IXAudio2VoiceCallback = interface;

    {$interfaces COM}
    {$ENDIF}

    (**************************************************************************
 *
 * XAudio2 structures and enumerations.
 *
 **************************************************************************)

    // Used in XAudio2Create, specifies which CPU(s) to use.
    TXAUDIO2_PROCESSOR = uint32;
    PXAUDIO2_PROCESSOR = ^TXAUDIO2_PROCESSOR;



    // Returned by IXAudio2Voice::GetVoiceDetails
    TXAUDIO2_VOICE_DETAILS = record
        CreationFlags: uint32; // Flags the voice was created with.
        ActiveFlags: uint32; // Flags currently active.
        InputChannels: uint32; // Channels in the voice's input audio.
        InputSampleRate: uint32; // Sample rate of the voice's input audio.
    end;
    PXAUDIO2_VOICE_DETAILS = ^TXAUDIO2_VOICE_DETAILS;


    // Used in XAUDIO2_VOICE_SENDS below
    TXAUDIO2_SEND_DESCRIPTOR = record
        Flags: uint32; // Either 0 or XAUDIO2_SEND_USEFILTER.
        pOutputVoice: PIXAudio2Voice; // This send's destination voice.
    end;
    PXAUDIO2_SEND_DESCRIPTOR = ^TXAUDIO2_SEND_DESCRIPTOR;


    // Used in the voice creation functions and in IXAudio2Voice::SetOutputVoices
    TXAUDIO2_VOICE_SENDS = record
        SendCount: uint32; // Number of sends from this voice.
        pSends: PXAUDIO2_SEND_DESCRIPTOR; // Array of SendCount send descriptors.
    end;
    PXAUDIO2_VOICE_SENDS = ^TXAUDIO2_VOICE_SENDS;


    // Used in XAUDIO2_EFFECT_CHAIN below
    TXAUDIO2_EFFECT_DESCRIPTOR = record
        pEffect: PIUnknown; // Pointer to the effect object's IUnknown interface.
        InitialState: boolean; // TRUE if the effect should begin in the enabled state.
        OutputChannels: uint32; // How many output channels the effect should produce.
    end;
    PXAUDIO2_EFFECT_DESCRIPTOR = ^TXAUDIO2_EFFECT_DESCRIPTOR;


    // Used in the voice creation functions and in IXAudio2Voice::SetEffectChain
    TXAUDIO2_EFFECT_CHAIN = record
        EffectCount: uint32; // Number of effects in this voice's effect chain.
        pEffectDescriptors: PXAUDIO2_EFFECT_DESCRIPTOR; // Array of effect descriptors.
    end;
    PXAUDIO2_EFFECT_CHAIN = ^TXAUDIO2_EFFECT_CHAIN;


    // Used in XAUDIO2_FILTER_PARAMETERS below
    TXAUDIO2_FILTER_TYPE = (
        LowPassFilter, // Attenuates frequencies above the cutoff frequency (state-variable filter).
        BandPassFilter, // Attenuates frequencies outside a given range      (state-variable filter).
        HighPassFilter, // Attenuates frequencies below the cutoff frequency (state-variable filter).
        NotchFilter, // Attenuates frequencies inside a given range       (state-variable filter).
        LowPassOnePoleFilter, // Attenuates frequencies above the cutoff frequency (one-pole filter, XAUDIO2_FILTER_PARAMETERS.OneOverQ has no effect)
        HighPassOnePoleFilter// Attenuates frequencies below the cutoff frequency (one-pole filter, XAUDIO2_FILTER_PARAMETERS.OneOverQ has no effect)
        );

    PXAUDIO2_FILTER_TYPE = ^TXAUDIO2_FILTER_TYPE;


    // Used in IXAudio2Voice::Set/GetFilterParameters and Set/GetOutputFilterParameters
    TXAUDIO2_FILTER_PARAMETERS = record
        FilterType: TXAUDIO2_FILTER_TYPE; // Filter type.
        Frequency: single; // Filter coefficient.
        //  See XAudio2CutoffFrequencyToRadians() for state-variable filter types and
        //  XAudio2CutoffFrequencyToOnePoleCoefficient() for one-pole filter types.
        OneOverQ: single; // Reciprocal of the filter's quality factor Q;
        //  must be > 0 and <= XAUDIO2_MAX_FILTER_ONEOVERQ.
        //  Has no effect for one-pole filters.
    end;
    PXAUDIO2_FILTER_PARAMETERS = ^TXAUDIO2_FILTER_PARAMETERS;


    // Used in IXAudio2SourceVoice::SubmitSourceBuffer
    TXAUDIO2_BUFFER = record
        Flags: uint32; // Either 0 or XAUDIO2_END_OF_STREAM.
        AudioBytes: uint32; // Size of the audio data buffer in bytes.
        pAudioData: pbyte; // Pointer to the audio data buffer.
        PlayBegin: uint32; // First sample in this buffer to be played.
        PlayLength: uint32; // Length of the region to be played in samples,
        LoopBegin: uint32; // First sample of the region to be looped.
        LoopLength: uint32; // Length of the desired loop region in samples,
        LoopCount: uint32; // Number of times to repeat the loop region,
        pContext: pointer; // Context value to be passed back in callbacks.
    end;
    PXAUDIO2_BUFFER = ^TXAUDIO2_BUFFER;




    // Used in IXAudio2SourceVoice::SubmitSourceBuffer when submitting XWMA data.
    // NOTE: If an XWMA sound is submitted in more than one buffer, each buffer's
    // pDecodedPacketCumulativeBytes[PacketCount-1] value must be subtracted from
    // all the entries in the next buffer's pDecodedPacketCumulativeBytes array.
    // And whether a sound is submitted in more than one buffer or not, the final
    // buffer of the sound should use the XAUDIO2_END_OF_STREAM flag, or else the
    // client must call IXAudio2SourceVoice::Discontinuity after submitting it.
    TXAUDIO2_BUFFER_WMA = record
        pDecodedPacketCumulativeBytes: PUINT32; // Decoded packet's cumulative size array.
        //  when the corresponding XWMA packet is decoded in
        //  order.  The array must have PacketCount elements.
        PacketCount: uint32; // Number of XWMA packets submitted. Must be >= 1 and
        //  divide evenly into XAUDIO2_BUFFER.AudioBytes.
    end;
    PXAUDIO2_BUFFER_WMA = ^TXAUDIO2_BUFFER_WMA;


    // Returned by IXAudio2SourceVoice::GetState
    TXAUDIO2_VOICE_STATE = record
        pCurrentBufferContext: pointer; // The pContext value provided in the XAUDIO2_BUFFER
        //  there are no buffers in the queue.
        BuffersQueued: uint32; // Number of buffers currently queued on the voice
        //  (including the one that is being processed).
        SamplesPlayed: uint64; // Total number of samples produced by the voice since
        //  it began processing the current audio stream.
        //  If XAUDIO2_VOICE_NOSAMPLESPLAYED is specified
        //  in the call to IXAudio2SourceVoice::GetState,
        //  this member will not be calculated, saving CPU.
    end;
    PXAUDIO2_VOICE_STATE = ^TXAUDIO2_VOICE_STATE;


    // Returned by IXAudio2::GetPerformanceData
    TXAUDIO2_PERFORMANCE_DATA = record
        // CPU usage information
        AudioCyclesSinceLastQuery: uint64; // CPU cycles spent on audio processing since the
        //  last call to StartEngine or GetPerformanceData.
        TotalCyclesSinceLastQuery: uint64; // Total CPU cycles elapsed since the last call
        //  (only counts the CPU XAudio2 is running on).
        MinimumCyclesPerQuantum: uint32; // Fewest CPU cycles spent processing any one
        //  audio quantum since the last call.
        MaximumCyclesPerQuantum: uint32; // Most CPU cycles spent processing any one
        //  audio quantum since the last call.
        // Memory usage information
        MemoryUsageInBytes: uint32; // Total heap space currently in use.
        // Audio latency and glitching information
        CurrentLatencyInSamples: uint32; // Minimum delay from when a sample is read from a
        //  source buffer to when it reaches the speakers.
        GlitchesSinceEngineStarted: uint32; // Audio dropouts since the engine was started.
        // Data about XAudio2's current workload
        ActiveSourceVoiceCount: uint32; // Source voices currently playing.
        TotalSourceVoiceCount: uint32; // Source voices currently existing.
        ActiveSubmixVoiceCount: uint32; // Submix voices currently playing/existing.
        ActiveResamplerCount: uint32; // Resample xAPOs currently active.
        ActiveMatrixMixCount: uint32; // MatrixMix xAPOs currently active.
        // Usage of the hardware XMA decoder (Xbox 360 only)
        ActiveXmaSourceVoices: uint32; // Number of source voices decoding XMA data.
        ActiveXmaStreams: uint32; // A voice can use more than one XMA stream.
    end;
    PXAUDIO2_PERFORMANCE_DATA = ^TXAUDIO2_PERFORMANCE_DATA;




    // Used in IXAudio2::SetDebugConfiguration
    TXAUDIO2_DEBUG_CONFIGURATION = record
        TraceMask: uint32; // Bitmap of enabled debug message types.
        BreakMask: uint32; // Message types that will break into the debugger.
        LogThreadID: boolean; // Whether to log the thread ID with each message.
        LogFileline: boolean; // Whether to log the source file and line number.
        LogFunctionName: boolean; // Whether to log the function name.
        LogTiming: boolean; // Whether to log message timestamps.
    end;
    PXAUDIO2_DEBUG_CONFIGURATION = ^TXAUDIO2_DEBUG_CONFIGURATION;



   (**************************************************************************
 *
 * IXAudio2: Top-level XAudio2 COM interface.
 *
 **************************************************************************)



    IXAudio2 = interface(IUnknown)
        ['{2B02E3CF-2E0B-4ec3-BE45-1B2A3FE7210D}']
        // NAME: IXAudio2::QueryInterface
        // DESCRIPTION: Queries for a given COM interface on the XAudio2 object.
        //              Only IID_IUnknown, IID_IXAudio2 and IID_IXaudio2Extension are supported.

        // ARGUMENTS:
        //  riid - IID of the interface to be obtained.
        //  ppvInterface - Returns a pointer to the requested interface.


        // NAME: IXAudio2::RegisterForCallbacks
        // DESCRIPTION: Adds a new client to receive XAudio2's engine callbacks.

        // ARGUMENTS:
        //  pCallback - Callback interface to be called during each processing pass.

        function RegisterForCallbacks(
        {_In_ } pCallback: IXAudio2EngineCallback): HRESULT; stdcall;

        // NAME: IXAudio2::UnregisterForCallbacks
        // DESCRIPTION: Removes an existing receiver of XAudio2 engine callbacks.

        // ARGUMENTS:
        //  pCallback - Previously registered callback interface to be removed.

        procedure UnregisterForCallbacks(
        {_In_ } pCallback: IXAudio2EngineCallback); stdcall;

        // NAME: IXAudio2::CreateSourceVoice
        // DESCRIPTION: Creates and configures a source voice.

        // ARGUMENTS:
        //  ppSourceVoice - Returns the new object's IXAudio2SourceVoice interface.
        //  pSourceFormat - Format of the audio that will be fed to the voice.
        //  Flags - XAUDIO2_VOICE flags specifying the source voice's behavior.
        //  MaxFrequencyRatio - Maximum SetFrequencyRatio argument to be allowed.
        //  pCallback - Optional pointer to a client-provided callback interface.
        //  pSendList - Optional list of voices this voice should send audio to.
        //  pEffectChain - Optional list of effects to apply to the audio data.

        function CreateSourceVoice(
        {_Outptr_ }  out ppSourceVoice: IXAudio2SourceVoice;
        {_In_ } pSourceFormat: PWAVEFORMATEX; Flags: uint32 = 0; MaxFrequencyRatio: single = XAUDIO2_DEFAULT_FREQ_RATIO;
        {_In_opt_ } pCallback: IXAudio2VoiceCallback = nil;
        {_In_opt_ } pSendList: PXAUDIO2_VOICE_SENDS = nil;
        {_In_opt_ } pEffectChain: PXAUDIO2_EFFECT_CHAIN = nil): HRESULT; stdcall;

        // NAME: IXAudio2::CreateSubmixVoice
        // DESCRIPTION: Creates and configures a submix voice.

        // ARGUMENTS:
        //  ppSubmixVoice - Returns the new object's IXAudio2SubmixVoice interface.
        //  InputChannels - Number of channels in this voice's input audio data.
        //  InputSampleRate - Sample rate of this voice's input audio data.
        //  Flags - XAUDIO2_VOICE flags specifying the submix voice's behavior.
        //  ProcessingStage - Arbitrary number that determines the processing order.
        //  pSendList - Optional list of voices this voice should send audio to.
        //  pEffectChain - Optional list of effects to apply to the audio data.

        function CreateSubmixVoice(
        {_Outptr_ }  out ppSubmixVoice: IXAudio2SubmixVoice; InputChannels: uint32; InputSampleRate: uint32; Flags: uint32 = 0; ProcessingStage: uint32 = 0;
        {_In_opt_ } pSendList: PXAUDIO2_VOICE_SENDS = nil;
        {_In_opt_ } pEffectChain: PXAUDIO2_EFFECT_CHAIN = nil): HRESULT; stdcall;

        // NAME: IXAudio2::CreateMasteringVoice
        // DESCRIPTION: Creates and configures a mastering voice.

        // ARGUMENTS:
        //  ppMasteringVoice - Returns the new object's IXAudio2MasteringVoice interface.
        //  InputChannels - Number of channels in this voice's input audio data.
        //  InputSampleRate - Sample rate of this voice's input audio data.
        //  Flags - XAUDIO2_VOICE flags specifying the mastering voice's behavior.
        //  szDeviceId - Identifier of the device to receive the output audio.
        //  pEffectChain - Optional list of effects to apply to the audio data.
        //  StreamCategory - The audio stream category to use for this mastering voice

        function CreateMasteringVoice(
        {_Outptr_ }  out ppMasteringVoice: IXAudio2MasteringVoice; InputChannels: uint32 = XAUDIO2_DEFAULT_CHANNELS; InputSampleRate: uint32 = XAUDIO2_DEFAULT_SAMPLERATE; Flags: uint32 = 0;
        {_In_opt_z_ } szDeviceId: LPCWSTR = nil;
        {_In_opt_ } pEffectChain: PXAUDIO2_EFFECT_CHAIN = nil;
        {_In_ } StreamCategory: TAUDIO_STREAM_CATEGORY = AudioCategory_GameEffects): HRESULT; stdcall;

        // NAME: IXAudio2::StartEngine
        // DESCRIPTION: Creates and starts the audio processing thread.

        function StartEngine(): HRESULT; stdcall;

        // NAME: IXAudio2::StopEngine
        // DESCRIPTION: Stops and destroys the audio processing thread.

        procedure StopEngine(); stdcall;

        // NAME: IXAudio2::CommitChanges
        // DESCRIPTION: Atomically applies a set of operations previously tagged
        //              with a given identifier.

        // ARGUMENTS:
        //  OperationSet - Identifier of the set of operations to be applied.

        function CommitChanges(OperationSet: uint32): HRESULT; stdcall;

        // NAME: IXAudio2::GetPerformanceData
        // DESCRIPTION: Returns current resource usage details: memory, CPU, etc.

        // ARGUMENTS:
        //  pPerfData - Returns the performance data structure.

        procedure GetPerformanceData(
        {_Out_ } pPerfData: PXAUDIO2_PERFORMANCE_DATA); stdcall;

        // NAME: IXAudio2::SetDebugConfiguration
        // DESCRIPTION: Configures XAudio2's debug output (in debug builds only).

        // ARGUMENTS:
        //  pDebugConfiguration - Structure describing the debug output behavior.
        //  pReserved - Optional parameter; must be NULL.

        procedure SetDebugConfiguration(
        {_In_opt_ } pDebugConfiguration: PXAUDIO2_DEBUG_CONFIGURATION; pReserved: pointer = nil); stdcall;

    end;


    // This interface extends IXAudio2 with additional functionality.
    // Use IXAudio2::QueryInterface to obtain a pointer to this interface.

    IXAudio2Extension = interface(IUnknown)
        ['{84ac29bb-d619-44d2-b197-e4acf7df3ed6}']
        // NAME: IXAudio2Extension::QueryInterface
        // DESCRIPTION: Queries for a given COM interface on the XAudio2 object.
        //              Only IID_IUnknown, IID_IXAudio2 and IID_IXaudio2Extension are supported.

        // ARGUMENTS:
        //  riid - IID of the interface to be obtained.
        //  ppvInterface - Returns a pointer to the requested interface.



        // NAME: IXAudio2Extension::GetProcessingQuantum
        // DESCRIPTION: Returns the processing quantum
        //              quantumMilliseconds = (1000.0f * quantumNumerator / quantumDenominator)

        // ARGUMENTS:
        //  quantumNumerator - Quantum numerator
        //  quantumDenominator - Quantum denominator

        procedure GetProcessingQuantum(
        {_Out_ } quantumNumerator: PUINT32;
        {_Out_range_(!= , 0) } quantumDenominator: PUINT32); stdcall;

        // NAME: IXAudio2Extension::GetProcessor
        // DESCRIPTION: Returns the number of the processor used by XAudio2

        // ARGUMENTS:
        //  processor - Non-zero Processor number

        procedure GetProcessor(
        {_Out_range_(!= , 0) } processor: PXAUDIO2_PROCESSOR); stdcall;

    end;




(**************************************************************************
 *
 * IXAudio2Voice: Base voice management interface.
 *
 **************************************************************************)

{$IFDEF FPC}
    {$interfaces corba}
    IXAudio2Voice = interface



        // These methods are declared in a macro so that the same declarations
        // can be used in the derived voice types (IXAudio2SourceVoice, etc).
    (* NAME: IXAudio2Voice::GetVoiceDetails
    // DESCRIPTION: Returns the basic characteristics of this voice.
    //
    // ARGUMENTS:
    //  pVoiceDetails - Returns the voice's details.
    *)
        procedure GetVoiceDetails(
        {_Out_ } pVoiceDetails: PXAUDIO2_VOICE_DETAILS); stdcall;

    (* NAME: IXAudio2Voice::SetOutputVoices
    // DESCRIPTION: Replaces the set of submix/mastering voices that receive
    //              this voice's output.
    //
    // ARGUMENTS:
    //  pSendList - Optional list of voices this voice should send audio to.
    *)
        function SetOutputVoices(
        {_In_opt_ } pSendList: PXAUDIO2_VOICE_SENDS): HRESULT; stdcall;

    (* NAME: IXAudio2Voice::SetEffectChain
    // DESCRIPTION: Replaces this voice's current effect chain with a new one.
    //
    // ARGUMENTS:
    //  pEffectChain - Structure describing the new effect chain to be used.
    *)
        function SetEffectChain(
        {_In_opt_ } pEffectChain: PXAUDIO2_EFFECT_CHAIN): HRESULT; stdcall;

    (* NAME: IXAudio2Voice::EnableEffect
    // DESCRIPTION: Enables an effect in this voice's effect chain.
    //
    // ARGUMENTS:
    //  EffectIndex - Index of an effect within this voice's effect chain.
    //  OperationSet - Used to identify this call as part of a deferred batch.
    *)
        function EnableEffect(EffectIndex: uint32; OperationSet: uint32 = XAUDIO2_COMMIT_NOW): HRESULT; stdcall;

    (* NAME: IXAudio2Voice::DisableEffect
    // DESCRIPTION: Disables an effect in this voice's effect chain.
    //
    // ARGUMENTS:
    //  EffectIndex - Index of an effect within this voice's effect chain.
    //  OperationSet - Used to identify this call as part of a deferred batch.
    *)
        function DisableEffect(EffectIndex: uint32; OperationSet: uint32 = XAUDIO2_COMMIT_NOW): HRESULT; stdcall;

    (* NAME: IXAudio2Voice::GetEffectState
    // DESCRIPTION: Returns the running state of an effect.
    //
    // ARGUMENTS:
    //  EffectIndex - Index of an effect within this voice's effect chain.
    //  pEnabled - Returns the enabled/disabled state of the given effect.
    *)
        procedure GetEffectState(EffectIndex: uint32;
        {_Out_ } pEnabled: Pboolean); stdcall;

    (* NAME: IXAudio2Voice::SetEffectParameters
    // DESCRIPTION: Sets effect-specific parameters.
    //
    // REMARKS: Unlike IXAPOParameters::SetParameters, this method may
    //          be called from any thread.  XAudio2 implements
    //          appropriate synchronization to copy the parameters to the
    //          realtime audio processing thread.
    //
    // ARGUMENTS:
    //  EffectIndex - Index of an effect within this voice's effect chain.
    //  pParameters - Pointer to an effect-specific parameters block.
    //  ParametersByteSize - Size of the pParameters array  in bytes.
    //  OperationSet - Used to identify this call as part of a deferred batch.
    *)
        function SetEffectParameters(EffectIndex: uint32;
        {_In_reads_bytes_(ParametersByteSize) } pParameters: pointer; ParametersByteSize: uint32; OperationSet: uint32 = XAUDIO2_COMMIT_NOW): HRESULT; stdcall;

    (* NAME: IXAudio2Voice::GetEffectParameters
    // DESCRIPTION: Obtains the current effect-specific parameters.
    //
    // ARGUMENTS:
    //  EffectIndex - Index of an effect within this voice's effect chain.
    //  pParameters - Returns the current values of the effect-specific parameters.
    //  ParametersByteSize - Size of the pParameters array in bytes.
    *)
        function GetEffectParameters(EffectIndex: uint32;
        {_Out_writes_bytes_(ParametersByteSize) } pParameters: pointer; ParametersByteSize: uint32): HRESULT; stdcall;

    (* NAME: IXAudio2Voice::SetFilterParameters
    // DESCRIPTION: Sets this voice's filter parameters.
    //
    // ARGUMENTS:
    //  pParameters - Pointer to the filter's parameter structure.
    //  OperationSet - Used to identify this call as part of a deferred batch.
    *)
        function SetFilterParameters(
        {_In_ } pParameters: PXAUDIO2_FILTER_PARAMETERS; OperationSet: uint32 = XAUDIO2_COMMIT_NOW): HRESULT; stdcall;

    (* NAME: IXAudio2Voice::GetFilterParameters
    // DESCRIPTION: Returns this voice's current filter parameters.
    //
    // ARGUMENTS:
    //  pParameters - Returns the filter parameters.
    *)
        procedure GetFilterParameters(
        {_Out_ } pParameters: PXAUDIO2_FILTER_PARAMETERS); stdcall;

    (* NAME: IXAudio2Voice::SetOutputFilterParameters
    // DESCRIPTION: Sets the filter parameters on one of this voice's sends.
    //
    // ARGUMENTS:
    //  pDestinationVoice - Destination voice of the send whose filter parameters will be set.
    //  pParameters - Pointer to the filter's parameter structure.
    //  OperationSet - Used to identify this call as part of a deferred batch.
    *)
        function SetOutputFilterParameters(
        {_In_opt_ } pDestinationVoice: IXAudio2Voice;
        {_In_ } pParameters: PXAUDIO2_FILTER_PARAMETERS; OperationSet: uint32 = XAUDIO2_COMMIT_NOW): HRESULT; stdcall;

    (* NAME: IXAudio2Voice::GetOutputFilterParameters
    // DESCRIPTION: Returns the filter parameters from one of this voice's sends.
    //
    // ARGUMENTS:
    //  pDestinationVoice - Destination voice of the send whose filter parameters will be read.
    //  pParameters - Returns the filter parameters.
    *)
        procedure GetOutputFilterParameters(
        {_In_opt_ } pDestinationVoice: IXAudio2Voice;
        {_Out_ } pParameters: PXAUDIO2_FILTER_PARAMETERS); stdcall;

    (* NAME: IXAudio2Voice::SetVolume
    // DESCRIPTION: Sets this voice's overall volume level.
    //
    // ARGUMENTS:
    //  Volume - New overall volume level to be used, as an amplitude factor.
    //  OperationSet - Used to identify this call as part of a deferred batch.
    *)
        function SetVolume(Volume: single; OperationSet: uint32 = XAUDIO2_COMMIT_NOW): HRESULT; stdcall;

    (* NAME: IXAudio2Voice::GetVolume
    // DESCRIPTION: Obtains this voice's current overall volume level.
    //
    // ARGUMENTS:
    //  pVolume: Returns the voice's current overall volume level.
    *)
        procedure GetVolume(
        {_Out_ } pVolume: Psingle); stdcall;

    (* NAME: IXAudio2Voice::SetChannelVolumes
    // DESCRIPTION: Sets this voice's per-channel volume levels.
    //
    // ARGUMENTS:
    //  Channels - Used to confirm the voice's channel count.
    //  pVolumes - Array of per-channel volume levels to be used.
    //  OperationSet - Used to identify this call as part of a deferred batch.
    *)
        function SetChannelVolumes(Channels: uint32;
        {_In_reads_(Channels) } pVolumes: Psingle; OperationSet: uint32 = XAUDIO2_COMMIT_NOW): HRESULT; stdcall;

    (* NAME: IXAudio2Voice::GetChannelVolumes
    // DESCRIPTION: Returns this voice's current per-channel volume levels.
    //
    // ARGUMENTS:
    //  Channels - Used to confirm the voice's channel count.
    //  pVolumes - Returns an array of the current per-channel volume levels.
    *)
        procedure GetChannelVolumes(Channels: uint32;
        {_Out_writes_(Channels) } pVolumes: Psingle); stdcall;

    (* NAME: IXAudio2Voice::SetOutputMatrix
    // DESCRIPTION: Sets the volume levels used to mix from each channel of this
    //              voice's output audio to each channel of a given destination
    //              voice's input audio.
    //
    // ARGUMENTS:
    //  pDestinationVoice - The destination voice whose mix matrix to change.
    //  SourceChannels - Used to confirm this voice's output channel count
    //   (the number of channels produced by the last effect in the chain).
    //  DestinationChannels - Confirms the destination voice's input channels.
    //  pLevelMatrix - Array of [SourceChannels * DestinationChannels] send
    //   levels.  The level used to send from source channel S to destination
    //   channel D should be in pLevelMatrix[S + SourceChannels * D].
    //  OperationSet - Used to identify this call as part of a deferred batch.
    *)
        function SetOutputMatrix(
        {_In_opt_ } pDestinationVoice: IXAudio2Voice; SourceChannels: uint32; DestinationChannels: uint32;
        {_In_reads_(SourceChannels * DestinationChannels) } pLevelMatrix: Psingle; OperationSet: uint32 = XAUDIO2_COMMIT_NOW): HRESULT; stdcall;

    (* NAME: IXAudio2Voice::GetOutputMatrix
    // DESCRIPTION: Obtains the volume levels used to send each channel of this
    //              voice's output audio to each channel of a given destination
    //              voice's input audio.
    //
    // ARGUMENTS:
    //  pDestinationVoice - The destination voice whose mix matrix to obtain.
    //  SourceChannels - Used to confirm this voice's output channel count
    //   (the number of channels produced by the last effect in the chain).
    //  DestinationChannels - Confirms the destination voice's input channels.
    //  pLevelMatrix - Array of send levels, as above.
    *)
        procedure GetOutputMatrix(
        {_In_opt_ } pDestinationVoice: IXAudio2Voice; SourceChannels: uint32; DestinationChannels: uint32;
        {_Out_writes_(SourceChannels * DestinationChannels) } pLevelMatrix: Psingle); stdcall;

         (* NAME: IXAudio2Voice::DestroyVoice
    // DESCRIPTION: Destroys this voice, stopping it if necessary and removing
    //              it from the XAudio2 graph.
    *)
        procedure DestroyVoice(); stdcall;

    end;



(**************************************************************************
 *
 * IXAudio2SourceVoice: Source voice management interface.
 *
 **************************************************************************)

    IXAudio2SourceVoice = interface(IXAudio2Voice)
        // Methods from IXAudio2Voice base interface
        // Declare_IXAudio2Voice_Methods();

        // NAME: IXAudio2SourceVoice::Start
        // DESCRIPTION: Makes this voice start consuming and processing audio.

        // ARGUMENTS:
        //  Flags - Flags controlling how the voice should be started.
        //  OperationSet - Used to identify this call as part of a deferred batch.

        function Start(FlagsX2DEFAULT: uint32; OperationSet: uint32 = XAUDIO2_COMMIT_NOW): HRESULT; stdcall;

        // NAME: IXAudio2SourceVoice::Stop
        // DESCRIPTION: Makes this voice stop consuming audio.

        // ARGUMENTS:
        //  Flags - Flags controlling how the voice should be stopped.
        //  OperationSet - Used to identify this call as part of a deferred batch.

        function Stop(FlagsX2DEFAULT: uint32; OperationSet: uint32 = XAUDIO2_COMMIT_NOW): HRESULT; stdcall;

        // NAME: IXAudio2SourceVoice::SubmitSourceBuffer
        // DESCRIPTION: Adds a new audio buffer to this voice's input queue.

        // ARGUMENTS:
        //  pBuffer - Pointer to the buffer structure to be queued.
        //  pBufferWMA - Additional structure used only when submitting XWMA data.

        function SubmitSourceBuffer(
        {_In_ } pBuffer: PXAUDIO2_BUFFER;
        {_In_opt_ } pBufferWMA: PXAUDIO2_BUFFER_WMA = nil): HRESULT; stdcall;

        // NAME: IXAudio2SourceVoice::FlushSourceBuffers
        // DESCRIPTION: Removes all pending audio buffers from this voice's queue.

        function FlushSourceBuffers(): HRESULT; stdcall;

        // NAME: IXAudio2SourceVoice::Discontinuity
        // DESCRIPTION: Notifies the voice of an intentional break in the stream of
        //              audio buffers (e.g. the end of a sound), to prevent XAudio2
        //              from interpreting an empty buffer queue as a glitch.

        function Discontinuity(): HRESULT; stdcall;

        // NAME: IXAudio2SourceVoice::ExitLoop
        // DESCRIPTION: Breaks out of the current loop when its end is reached.

        // ARGUMENTS:
        //  OperationSet - Used to identify this call as part of a deferred batch.

        function ExitLoop(OperationSet: uint32 = XAUDIO2_COMMIT_NOW): HRESULT; stdcall;

        // NAME: IXAudio2SourceVoice::GetState
        // DESCRIPTION: Returns the number of buffers currently queued on this voice,
        //              the pContext value associated with the currently processing
        //              buffer (if any), and other voice state information.

        // ARGUMENTS:
        //  pVoiceState - Returns the state information.
        //  Flags - Flags controlling what voice state is returned.

        procedure GetState(
        {_Out_ } pVoiceState: PXAUDIO2_VOICE_STATE; Flags: uint32 = 0); stdcall;

        // NAME: IXAudio2SourceVoice::SetFrequencyRatio
        // DESCRIPTION: Sets this voice's frequency adjustment, i.e. its pitch.

        // ARGUMENTS:
        //  Ratio - Frequency change, expressed as source frequency / target frequency.
        //  OperationSet - Used to identify this call as part of a deferred batch.

        function SetFrequencyRatio(Ratio: single; OperationSet: uint32 = XAUDIO2_COMMIT_NOW): HRESULT; stdcall;

        // NAME: IXAudio2SourceVoice::GetFrequencyRatio
        // DESCRIPTION: Returns this voice's current frequency adjustment ratio.

        // ARGUMENTS:
        //  pRatio - Returns the frequency adjustment.

        procedure GetFrequencyRatio(
        {_Out_ } pRatio: Psingle); stdcall;

        // NAME: IXAudio2SourceVoice::SetSourceSampleRate
        // DESCRIPTION: Reconfigures this voice to treat its source data as being
        //              at a different sample rate than the original one specified
        //              in CreateSourceVoice's pSourceFormat argument.

        // ARGUMENTS:
        //  UINT32 - The intended sample rate of further submitted source data.

        function SetSourceSampleRate(NewSourceSampleRate: uint32): HRESULT; stdcall;

    end;


(**************************************************************************
 *
 * IXAudio2SubmixVoice: Submixing voice management interface.
 *
 **************************************************************************)


    IXAudio2SubmixVoice = interface(IXAudio2Voice)

        // Methods from IXAudio2Voice base interface
        // Declare_IXAudio2Voice_Methods();

        // There are currently no methods specific to submix voices.
    end;



(**************************************************************************
 *
 * IXAudio2MasteringVoice: Mastering voice management interface.
 *
 **************************************************************************)


    IXAudio2MasteringVoice = interface(IXAudio2Voice)
        // Methods from IXAudio2Voice base interface
        // Declare_IXAudio2Voice_Methods();

        // NAME: IXAudio2MasteringVoice::GetChannelMask
        // DESCRIPTION: Returns the channel mask for this voice

        // ARGUMENTS:
        //  pChannelMask - returns the channel mask for this voice.  This corresponds
        //                 to the dwChannelMask member of WAVEFORMATEXTENSIBLE.

        function GetChannelMask(
        {_Out_ } pChannelmask: PDWORD): HRESULT; stdcall;

    end;


(**************************************************************************
 *
 * IXAudio2EngineCallback: Client notification interface for engine events.
 *
 * REMARKS: Contains methods to notify the client when certain events happen
 *          in the XAudio2 engine.  This interface should be implemented by
 *          the client.  XAudio2 will call these methods via the interface
 *          pointer provided by the client when it calls
 *          IXAudio2::RegisterForCallbacks.
 *
 **************************************************************************)


    IXAudio2EngineCallback = interface
        // Called by XAudio2 just before an audio processing pass begins.
        procedure OnProcessingPassStart(); stdcall;

        // Called just after an audio processing pass ends.
        procedure OnProcessingPassEnd(); stdcall;

        // Called in the event of a critical system error which requires XAudio2
        // to be closed down and restarted.  The error code is given in Error.
        procedure OnCriticalError(Error: HRESULT); stdcall;

    end;




(**************************************************************************
 *
 * IXAudio2VoiceCallback: Client notification interface for voice events.
 *
 * REMARKS: Contains methods to notify the client when certain events happen
 *          in an XAudio2 voice.  This interface should be implemented by the
 *          client.  XAudio2 will call these methods via an interface pointer
 *          provided by the client in the IXAudio2::CreateSourceVoice call.
 *
 **************************************************************************)



    IXAudio2VoiceCallback = interface
        // Called just before this voice's processing pass begins.
        procedure OnVoiceProcessingPassStart(BytesRequired: uint32); stdcall;

        // Called just after this voice's processing pass ends.
        procedure OnVoiceProcessingPassEnd(); stdcall;

        // Called when this voice has just finished playing a buffer stream
        // (as marked with the XAUDIO2_END_OF_STREAM flag on the last buffer).
        procedure OnStreamEnd(); stdcall;

        // Called when this voice is about to start processing a new buffer.
        procedure OnBufferStart(pBufferContext: pointer); stdcall;

        // Called when this voice has just finished processing a buffer.
        // The buffer can now be reused or destroyed.
        procedure OnBufferEnd(pBufferContext: pointer); stdcall;

        // Called when this voice has just reached the end position of a loop.
        procedure OnLoopEnd(pBufferContext: pointer); stdcall;

        // Called in the event of a critical error during voice processing,
        // such as a failing xAPO or an error from the hardware XMA decoder.
        // The voice may have to be destroyed and re-created to recover from
        // the error.  The callback arguments report which buffer was being
        // processed when the error occurred, and its HRESULT code.
        procedure OnVoiceError(pBufferContext: pointer; Error: HRESULT); stdcall;

    end;




    {$interfaces COM}
{$ENDIF}// FPC
    // revert packing alignment
    {$PACKRECORDS DEFAULT}

 (**************************************************************************
 *
 * Utility functions used to convert from pitch in semitones and volume
 * in decibels to the frequency and amplitude ratio units used by XAudio2.
 * These are only defined if the client #defines XAUDIO2_HELPER_FUNCTIONS
 * prior to #including xaudio2.h.
 *
 **************************************************************************)

// Calculate the argument to SetVolume from a decibel value
function XAudio2DecibelsToAmplitudeRatio(Decibels: single): single;


// Recover a volume in decibels from an amplitude factor
function XAudio2AmplitudeRatioToDecibels(Volume: single): single;


// Calculate the argument to SetFrequencyRatio from a semitone value
function XAudio2SemitonesToFrequencyRatio(Semitones: single): single;


// Recover a pitch in semitones from a frequency ratio
function XAudio2FrequencyRatioToSemitones(FrequencyRatio: single): single;


// Convert from filter cutoff frequencies expressed in Hertz to the radian
// frequency values used in XAUDIO2_FILTER_PARAMETERS.Frequency, state-variable
// filter types only.  Use XAudio2CutoffFrequencyToOnePoleCoefficient() for one-pole filter types.
// Note that the highest CutoffFrequency supported is SampleRate/6.
// Higher values of CutoffFrequency will return XAUDIO2_MAX_FILTER_FREQUENCY.
function XAudio2CutoffFrequencyToRadians(CutoffFrequency: single; SampleRate: uint32): single;



// Convert from radian frequencies back to absolute frequencies in Hertz
function XAudio2RadiansToCutoffFrequency(Radians: single; SampleRate: single): single;



// Convert from filter cutoff frequencies expressed in Hertz to the filter
// coefficients used with XAUDIO2_FILTER_PARAMETERS.Frequency,
// LowPassOnePoleFilter and HighPassOnePoleFilter filter types only.
// Use XAudio2CutoffFrequencyToRadians() for state-variable filter types.
function XAudio2CutoffFrequencyToOnePoleCoefficient(CutoffFrequency: single; SampleRate: uint32): single;


(**************************************************************************
 *
 * XAudio2Create: Top-level function that creates an XAudio2 instance.
 *
 * ARGUMENTS:
 *
 *  Flags - Flags specifying the XAudio2 object's behavior.
 *
 *  XAudio2Processor - An XAUDIO2_PROCESSOR value that specifies the
 *          hardware threads (Xbox) or processors (Windows) that XAudio2
 *          will use.  Note that XAudio2 supports concurrent processing on
 *          multiple threads, using any combination of XAUDIO2_PROCESSOR
 *          flags.  The values are platform-specific; platform-independent
 *          code can use XAUDIO2_USE_DEFAULT_PROCESSOR to use the default on
 *          each platform.
 *
 **************************************************************************)

function XAudio2CreateWithVersionInfo(
    {_Outptr_ }  out ppXAudio2: IXAudio2; Flags: uint32 = 0; XAudio2Processor: TXAUDIO2_PROCESSOR = XAUDIO2_DEFAULT_PROCESSOR; ntddiVersion: DWORD = DX12.SDKDDKVer.NTDDI_WIN10_RS5): HRESULT; stdcall; external XAUDIO2_DLL;


// Definition of XAudio2Create for Non-Desktop apps on RS5 and older, and Desktop apps on RS4 and older
// use XAUDIO2_USE_DEFAULT_PROCESSOR for for Non-Desktop apps targeting an OS release greater than RS5
function XAudio2Create(
    {_Outptr_ }  out ppXAudio2: IXAudio2; Flags: uint32 = 0; XAudio2Processor: TXAUDIO2_PROCESSOR = XAUDIO2_DEFAULT_PROCESSOR  {XAUDIO2_USE_DEFAULT_PROCESSOR}
    ): HRESULT; stdcall; external XAUDIO2_DLL;

// Definition of XAudio2Create for Desktop apps targeting RS5 and newer
function XAudio2CreateRS5(
    {_Outptr_ }  out ppXAudio2: IXAudio2; Flags: uint32 = 0; XAudio2Processor: TXAUDIO2_PROCESSOR = XAUDIO2_DEFAULT_PROCESSOR): HRESULT; stdcall;


implementation

uses
    Math,
    Windows.Macros;



function XAudio2DecibelsToAmplitudeRatio(Decibels: single): single;
begin
    Result := power(10.0, Decibels / 20.0);
end;



function XAudio2AmplitudeRatioToDecibels(Volume: single): single;
begin
    if (Volume = 0) then
    begin
        Result := -3.402823466e+38; // Smallest float value (-FLT_MAX)
        Exit;
    end;
    Result := 20.0 * log10(Volume);
end;



function XAudio2SemitonesToFrequencyRatio(Semitones: single): single;
begin
    // FrequencyRatio = 2 ^ Octaves
    //                = 2 ^ (Semitones / 12)
    Result := power(2.0, Semitones / 12.0);
end;



function XAudio2FrequencyRatioToSemitones(FrequencyRatio: single): single;
begin
    // Semitones = 12 * log2(FrequencyRatio)
    //           = 12 * log2(10) * log10(FrequencyRatio)
    Result := 39.86313713864835 * log10(FrequencyRatio);
end;



function XAudio2CutoffFrequencyToRadians(CutoffFrequency: single; SampleRate: uint32): single;
begin
    if (trunc(CutoffFrequency * 6.0) >= SampleRate) then
    begin
        Result := XAUDIO2_MAX_FILTER_FREQUENCY;
        Exit;
    end;
    Result := 2.0 * sin(M_PI * CutoffFrequency / SampleRate);
end;



function XAudio2RadiansToCutoffFrequency(Radians: single; SampleRate: single): single;
begin
    Result := SampleRate * arcsin(Radians / 2.0) / M_PI;
end;



function XAudio2CutoffFrequencyToOnePoleCoefficient(CutoffFrequency: single; SampleRate: uint32): single;
begin
    if (trunc(CutoffFrequency) >= SampleRate) then
    begin
        Result := XAUDIO2_MAX_FILTER_FREQUENCY;
        Exit;
    end;
    Result := (1.0 - power(1.0 - 2.0 * CutoffFrequency / SampleRate, 2.0));
end;



function XAudio2CreateRS5(out ppXAudio2: IXAudio2; Flags: uint32; XAudio2Processor: TXAUDIO2_PROCESSOR): HRESULT; stdcall;
type
    PXAudio2CreateWithVersionInfoFunc = function({_Outptr_} out nameless1: IXAudio2; nameless2: uint32; nameless3: TXAUDIO2_PROCESSOR; nameless4: DWORD): HRESULT; stdcall;
    PXAudio2CreateInfoFunc = function({_Outptr_} out nameless1: IXAudio2; nameless2: uint32; nameless3: TXAUDIO2_PROCESSOR): HRESULT; stdcall;
var
    s_dllInstance: HMODULE = 0;
    s_pfnAudio2CreateWithVersion: PXAudio2CreateWithVersionInfoFunc = nil;
    s_pfnAudio2Create: PXAudio2CreateInfoFunc = nil;
begin
    // When compiled for RS5 or later, try to invoke XAudio2CreateWithVersionInfo.
    // Need to use LoadLibrary in case the app is running on an older OS.

    if (s_dllInstance = 0) then
    begin
        s_dllInstance := LoadLibraryEx(XAUDIO2_DLL, 0, LOAD_LIBRARY_SEARCH_SYSTEM32);
        if (s_dllInstance = 0) then
        begin
            Result := HRESULT_FROM_WIN32(GetLastError());
            Exit;
        end;

        s_pfnAudio2CreateWithVersion := PXAudio2CreateWithVersionInfoFunc(GetProcAddress(s_dllInstance, 'XAudio2CreateWithVersionInfo'));
        if (s_pfnAudio2CreateWithVersion = nil) then
        begin
            s_pfnAudio2Create := PXAudio2CreateInfoFunc(GetProcAddress(s_dllInstance, 'XAudio2Create'));
            if (s_pfnAudio2Create = nil) then
            begin
                Result := HRESULT_FROM_WIN32(GetLastError());
                Exit;
            end;
        end;
    end;

    if (s_pfnAudio2CreateWithVersion <> nil) then
    begin
        Result := s_pfnAudio2CreateWithVersion(ppXAudio2, Flags, XAudio2Processor, DX12.SDKDDKVer.NTDDI_WIN11_GE);
        Exit;
    end;
    Result := s_pfnAudio2Create(ppXAudio2, Flags, XAudio2Processor);
end;

end.
