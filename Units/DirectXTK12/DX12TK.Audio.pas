unit DX12TK.Audio;


{$IFDEF FPC}
//{$mode delphi}{$H+}
{$mode objfpc}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    gset,gvector,
    DX12.AudioSessionTypes,
    Win32.MMReg,
    DirectX.Math,
    DX12.X3DAudio,
    DX12.XAudio2,
    DX12TK.PlatformHelpers,
    DX12.XAudio2FX;

    // #if defined(USING_XAUDIO2_REDIST) || (_WIN32_WINNT >= 0x0A00 /*_WIN32_WINNT_WIN10*/) || defined(_XBOX_ONE)
    {$DEFINE USING_XAUDIO2_9}

const
    c_XAudio3DCalculateDefault = X3DAUDIO_CALCULATE_MATRIX or X3DAUDIO_CALCULATE_LPF_DIRECT;


    gReverbPresets: array [0..30] of PXAUDIO2FX_REVERB_I3DL2_PARAMETERS =
        (@XAUDIO2FX_I3DL2_PRESET_DEFAULT,             // Reverb_Off
        @XAUDIO2FX_I3DL2_PRESET_DEFAULT,             // Reverb_Default
        @XAUDIO2FX_I3DL2_PRESET_GENERIC,             // Reverb_Generic
        @XAUDIO2FX_I3DL2_PRESET_FOREST,              // Reverb_Forest
        @XAUDIO2FX_I3DL2_PRESET_PADDEDCELL,          // Reverb_PaddedCell
        @XAUDIO2FX_I3DL2_PRESET_ROOM,                // Reverb_Room
        @XAUDIO2FX_I3DL2_PRESET_BATHROOM,            // Reverb_Bathroom
        @XAUDIO2FX_I3DL2_PRESET_LIVINGROOM,          // Reverb_LivingRoom
        @XAUDIO2FX_I3DL2_PRESET_STONEROOM,           // Reverb_StoneRoom
        @XAUDIO2FX_I3DL2_PRESET_AUDITORIUM,          // Reverb_Auditorium
        @XAUDIO2FX_I3DL2_PRESET_CONCERTHALL,         // Reverb_ConcertHall
        @XAUDIO2FX_I3DL2_PRESET_CAVE,                // Reverb_Cave
        @XAUDIO2FX_I3DL2_PRESET_ARENA,               // Reverb_Arena
        @XAUDIO2FX_I3DL2_PRESET_HANGAR,              // Reverb_Hangar
        @XAUDIO2FX_I3DL2_PRESET_CARPETEDHALLWAY,     // Reverb_CarpetedHallway
        @XAUDIO2FX_I3DL2_PRESET_HALLWAY,             // Reverb_Hallway
        @XAUDIO2FX_I3DL2_PRESET_STONECORRIDOR,       // Reverb_StoneCorridor
        @XAUDIO2FX_I3DL2_PRESET_ALLEY,               // Reverb_Alley
        @XAUDIO2FX_I3DL2_PRESET_CITY,                // Reverb_City
        @XAUDIO2FX_I3DL2_PRESET_MOUNTAINS,           // Reverb_Mountains
        @XAUDIO2FX_I3DL2_PRESET_QUARRY,              // Reverb_Quarry
        @XAUDIO2FX_I3DL2_PRESET_PLAIN,               // Reverb_Plain
        @XAUDIO2FX_I3DL2_PRESET_PARKINGLOT,          // Reverb_ParkingLot
        @XAUDIO2FX_I3DL2_PRESET_SEWERPIPE,           // Reverb_SewerPipe
        @XAUDIO2FX_I3DL2_PRESET_UNDERWATER,          // Reverb_Underwater
        @XAUDIO2FX_I3DL2_PRESET_SMALLROOM,           // Reverb_SmallRoom
        @XAUDIO2FX_I3DL2_PRESET_MEDIUMROOM,          // Reverb_MediumRoom
        @XAUDIO2FX_I3DL2_PRESET_LARGEROOM,           // Reverb_LargeRoom
        @XAUDIO2FX_I3DL2_PRESET_MEDIUMHALL,          // Reverb_MediumHall
        @XAUDIO2FX_I3DL2_PRESET_LARGEHALL,           // Reverb_LargeHall
        @XAUDIO2FX_I3DL2_PRESET_PLATE               // Reverb_Plate
        );

type

    TSoundEffectInstance = class;
    TSoundStreamInstance = class;

    //----------------------------------------------------------------------------------
    TAudioStatistics = record
        playingOneShots: size_t; // Number of one-shot sounds currently playing
        playingInstances: size_t; // Number of sound effect instances currently playing
        allocatedInstances: size_t; // Number of SoundEffectInstance allocated
        allocatedVoices: size_t; // Number of XAudio2 voices allocated (standard, 3D, one-shots, and idle one-shots)
        allocatedVoices3d: size_t; // Number of XAudio2 voices allocated for 3D
        allocatedVoicesOneShot: size_t; // Number of XAudio2 voices allocated for one-shot sounds
        allocatedVoicesIdle: size_t; // Number of XAudio2 voices allocated for one-shot sounds but not currently in use
        audioBytes: size_t; // Total wave data (in bytes) in SoundEffects and in-memory WaveBanks
        xmaAudioBytes: size_t; // Total wave data (in bytes) in SoundEffects and in-memory WaveBanks allocated with ApuAlloc
        streamingBytes: size_t; // Total size of streaming buffers (in bytes) in streaming WaveBanks
    end;
    PAudioStatistics = ^TAudioStatistics;


    //----------------------------------------------------------------------------------
    TAUDIO_ENGINE_FLAGS = (
        AudioEngine_Default = $0,
        AudioEngine_EnvironmentalReverb = $1,
        AudioEngine_ReverbUseFilters = $2,
        AudioEngine_UseMasteringLimiter = $4,
        AudioEngine_DisableLFERedirect = $8,
        AudioEngine_DisableDopplerEffect = $10,
        AudioEngine_ZeroCenter3D = $20,
        AudioEngine_Debug = $10000,
        AudioEngine_ThrowOnNoAudioHW = $20000,
        AudioEngine_DisableVoiceReuse = $40000);

    PAUDIO_ENGINE_FLAGS = ^TAUDIO_ENGINE_FLAGS;


    TSOUND_EFFECT_INSTANCE_FLAGS = (
        SoundEffectInstance_Default = $0,
        SoundEffectInstance_Use3D = $1,
        SoundEffectInstance_ReverbUseFilters = $2,
        SoundEffectInstance_NoSetPitch = $4,
        SoundEffectInstance_UseRedirectLFE = $8,
        SoundEffectInstance_ZeroCenter3D = $10);

    PSOUND_EFFECT_INSTANCE_FLAGS = ^TSOUND_EFFECT_INSTANCE_FLAGS;


    TAUDIO_ENGINE_REVERB = (
        Reverb_Off,
        Reverb_Default,
        Reverb_Generic,
        Reverb_Forest,
        Reverb_PaddedCell,
        Reverb_Room,
        Reverb_Bathroom,
        Reverb_LivingRoom,
        Reverb_StoneRoom,
        Reverb_Auditorium,
        Reverb_ConcertHall,
        Reverb_Cave,
        Reverb_Arena,
        Reverb_Hangar,
        Reverb_CarpetedHallway,
        Reverb_Hallway,
        Reverb_StoneCorridor,
        Reverb_Alley,
        Reverb_City,
        Reverb_Mountains,
        Reverb_Quarry,
        Reverb_Plain,
        Reverb_ParkingLot,
        Reverb_SewerPipe,
        Reverb_Underwater,
        Reverb_SmallRoom,
        Reverb_MediumRoom,
        Reverb_LargeRoom,
        Reverb_MediumHall,
        Reverb_LargeHall,
        Reverb_Plate,
        Reverb_MAX);

    PAUDIO_ENGINE_REVERB = ^TAUDIO_ENGINE_REVERB;


    TSoundState = (
        STOPPED = 0,
        PLAYING,
        PAUSED);

    PSoundState = ^TSoundState;


    // Static functions
    TRendererDetail = record

        deviceId: widestring;
        description: widestring;
    end;

    TRendererDetailArray = array of TRendererDetail;
    PRendererDetailArray = ^TRendererDetailArray;


    //----------------------------------------------------------------------------------

    { IVoiceNotify }

    IVoiceNotify = class(TObject)

        procedure OnBufferEnd(); virtual;
        // Notfication that a voice buffer has finished
        // Note this is called from XAudio2's worker thread, so it should perform very minimal and thread-safe operations

        procedure OnCriticalError(); virtual;
        // Notification that the audio engine encountered a critical error

        procedure OnReset(); virtual;
        // Notification of an audio engine reset

        procedure OnUpdate(); virtual;
        // Notification of an audio engine per-frame update (opt-in)

        procedure OnDestroyEngine(); virtual;
        // Notification that the audio engine is being destroyed

        procedure OnTrim(); virtual;
        // Notification of a request to trim the voice pool

        procedure GatherStatistics(stats: TAudioStatistics); virtual;
        // Contribute to statistics request

        procedure OnDestroyParent(); virtual;
        // Optional notification used by some objects

    end;


    { TEngineCallback }

    TEngineCallback = class(TInterfacedObject, IXAudio2EngineCallback)
    protected
        mCriticalError: TScopedHandle;
    public
        // Called by XAudio2 just before an audio processing pass begins.
        procedure OnProcessingPassStart(); stdcall;

        // Called just after an audio processing pass ends.
        procedure OnProcessingPassEnd(); stdcall;

        // Called in the event of a critical system error which requires XAudio2
        // to be closed down and restarted.  The error code is given in Error.
        procedure OnCriticalError(Error: HRESULT); stdcall;
    end;

    { TVoiceCallback }

    TVoiceCallback = class(TInterfacedObject, IXAudio2VoiceCallback)
    protected
        mBufferEnd: TScopedHandle;
    public
        constructor Create;
        destructor Destroy; override;
    public
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

    //----------------------------------------------------------------------------------

  // notifylist_t = specialize TSet<IVoiceNotify>;

    { TAudioEngine }

    TAudioEngine = class(TObject)
    protected
        xaudio2: IXAudio2;
        mMasterVoice: IXAudio2MasteringVoice;
        mReverbVoice: IXAudio2SubmixVoice;

        masterChannelMask: uint32;
        masterChannels: uint32;
        masterRate: uint32;

        defaultRate: int32;
        maxVoiceOneshots: size_t;
        maxVoiceInstances: size_t;
        mMasterVolume: single;

        mX3DAudio: TX3DAUDIO_HANDLE;
        mX3DCalcFlags: uint32;

        mCriticalError: boolean;
        mReverbEnabled: boolean;

        mEngineFlags: TAUDIO_ENGINE_FLAGS;
        mOutputFormat: TWAVEFORMATEX;
        mCategory: TAUDIO_STREAM_CATEGORY;
        mReverbEffect: IUnknown;
        mVolumeLimiter: IUnknown;
        mVoiceInstances: size_t;
        mVoiceCallback: TVoiceCallback;
        mEngineCallback: TEngineCallback;

    public
        constructor Create(flags: TAUDIO_ENGINE_FLAGS = AudioEngine_Default;
        {_In_opt_}  wfx: PWAVEFORMATEX = nil;
        {_In_opt_z_}   deviceId: pwidechar = nil; category: TAUDIO_STREAM_CATEGORY = AudioCategory_GameEffects);


        destructor Destroy; override;

        function Update(): bool;
        // Performs per-frame processing for the audio engine, returns false if in 'silent mode'

        function Reset(
        {_In_opt_} wfx: PWAVEFORMATEX = nil;
        {_In_opt_z_}  deviceId: pwidechar = nil): bool;
        // Reset audio engine from critical error/silent mode using a new device; can also 'migrate' the graph
        // Returns true if succesfully reset, false if in 'silent mode' due to no default device
        // Note: One shots are lost, all SoundEffectInstances are in the STOPPED state after successful reset

        procedure Suspend();
        procedure Resume();
        // Suspend/resumes audio processing (i.e. global pause/resume)

        function GetMasterVolume(): single;
        procedure SetMasterVolume(volume: single);
        // Master volume property for all sounds

        procedure SetReverb(reverb: TAUDIO_ENGINE_REVERB); overload;
        procedure SetReverb({_In_opt_} native: PXAUDIO2FX_REVERB_PARAMETERS); overload;
        // Sets environmental reverb for 3D positional audio (if active)

        procedure SetMasteringLimit(Release, loudness: integer);
        // Sets the mastering volume limiter properties (if active)

        function GetStatistics(): TAudioStatistics;
        // Gathers audio engine statistics

        function GetOutputFormat(): TWAVEFORMATEXTENSIBLE;
        // Returns the format of the audio output device associated with the mastering voice.

        function GetChannelMask(): uint32;
        // Returns the output channel mask

        function GetOutputSampleRate(): longint;
        // Returns the sample rate going into the mastering voice

        function GetOutputChannels(): uint;
        // Returns the number of channels going into the mastering voice

        function IsAudioDevicePresent(): bool;
        // Returns true if the audio graph is operating normally, false if in 'silent mode'

        function IsCriticalError(): bool;
        // Returns true if the audio graph is halted due to a critical error (which also places the engine into 'silent mode')

        // Voice pool management.
        procedure SetDefaultSampleRate(sampleRate: integer);
        // Sample rate for voices in the reuse pool (defaults to 44100)

        procedure SetMaxVoicePool(maxOneShots, maxInstances: size_t);
        // Maximum number of voices to allocate for one-shots and instances
        // Note: one-shots over this limit are ignored; too many instance voices throws an exception

        procedure TrimVoicePool();
        // Releases any currently unused voices

        // Internal-use functions
        procedure AllocateVoice({_In_}  wfx: PWAVEFORMATEX; flags: TSOUND_EFFECT_INSTANCE_FLAGS; oneshot: bool;
        {_Outptr_result_maybenull_} out voice: IXAudio2SourceVoice);

        procedure DestroyVoice({_In_}  voice: IXAudio2SourceVoice);
        // Should only be called for instance voices, not one-shots

        procedure RegisterNotify({_In_} notify: IVoiceNotify; usesUpdate: bool);
        procedure UnregisterNotify({_In_} notify: IVoiceNotify; usesOneShots: bool; usesUpdate: bool);

        // XAudio2 interface access
        function GetInterface(): IXAudio2;
        function GetMasterVoice(): IXAudio2MasteringVoice;
        function GetReverbVoice(): IXAudio2SubmixVoice;

        // X3DAudio interface access
        function Get3DHandle(): TX3DAUDIO_HANDLE;
        function Get3DCalculateFlags(): uint32;


        function GetRendererDetails(): TRendererDetailArray;// Returns a list of valid audio endpoint devices


    end;


    { TWaveBank }

    TWaveBank = class(TObject)
    public
        constructor Create({_In_ } engine: TAudioEngine;{_In_z_}  wbFileName: pwidechar);
        destructor Destroy; override;

        procedure Play(index: uint); overload;
        procedure Play(index: uint; volume, pitch, pan: single); overload;

        procedure Play({_In_z_} Name: pansichar); overload;
        procedure Play({_In_z_} Name: pansichar; volume, pitch, pan: single); overload;

        function CreateInstance(index: uint; flags: TSOUND_EFFECT_INSTANCE_FLAGS = SoundEffectInstance_Default): TSoundEffectInstance; overload;
        function CreateInstance({_In_z_} Name: pansichar; flags: TSOUND_EFFECT_INSTANCE_FLAGS = SoundEffectInstance_Default): TSoundEffectInstance; overload;

        function CreateStreamInstance(index: uint; flags: TSOUND_EFFECT_INSTANCE_FLAGS = SoundEffectInstance_Default): TSoundStreamInstance; overload;
        function CreateStreamInstance({_In_z_} Name: pansichar; flags: TSOUND_EFFECT_INSTANCE_FLAGS = SoundEffectInstance_Default): TSoundStreamInstance; overload;

        function IsPrepared(): boolean;
        function IsInUse(): boolean;
        function IsStreamingBank(): boolean;
        function IsAdvancedFormat(): boolean;

        function GetSampleSizeInBytes(index: uint): size_t;
        // Returns size of wave audio data

        function GetSampleDuration(index: uint): size_t;
        // Returns the duration in samples

        function GetSampleDurationMS(index: uint): size_t;
        // Returns the duration in milliseconds

        function GetFormat(index: uint;{_Out_writes_bytes_(maxsize)} wfx: PWAVEFORMATEX; maxsize: size_t): TWAVEFORMATEX;

        function Find({_In_z_} Name: pansichar): integer;

        {$IFDEF  USING_XAUDIO2_9}
        function FillSubmitBuffer(index: uint;
        {_Out_} out buffer: TXAUDIO2_BUFFER;
        {_Out_} out wmaBuffer: TXAUDIO2_BUFFER_WMA): boolean;
        {$ELSE}
        procedure FillSubmitBuffer(index: uint;
        {_Out_} out buffer: TXAUDIO2_BUFFER);
        {$ENDIF}
        procedure UnregisterInstance({_In_}  instance: IVoiceNotify);
        function GetAsyncHandle(): HANDLE;
        function GetPrivateData(index: uint;{_Out_writes_bytes_(datasize)} out Data: pointer; datasize: size_t): boolean;
    end;

    { TSoundEffect }

    TSoundEffect = class(TObject)
    public
        constructor Create(
        {_In_ } engine: TAudioEngine;
        {_In_z_ } waveFileName: pwidechar); overload;


        constructor Create(
        {_In_ } engine: TAudioEngine;
        {_Inout_ } wavData: pbyte;
        {_In_ } wfx: PWAVEFORMATEX;
        {_In_reads_bytes_(audioBytes) } startAudio: pbyte; audioBytes: size_t); overload;


        constructor Create(
        {_In_ } engine: TAudioEngine;
        {_Inout_ }  wavData: pbyte;
        {_In_ } wfx: PWAVEFORMATEX;
        {_In_reads_bytes_(audioBytes) } startAudio: pbyte; audioBytes: size_t; loopStart: uint32; loopLength: uint32); overload;

        {$IFDEF  USING_XAUDIO2_9}
        constructor Create(
        {_In_ } engine: TAudioEngine;
        {_Inout_ }  wavData: pbyte;
        {_In_ } wfx: PWAVEFORMATEX;
        {_In_reads_bytes_(audioBytes) } startAudio: pbyte; audioBytes: size_t;
        {_In_reads_(seekCount) } seekTable: Puint32; seekCount: size_t); overload;
        {$ENDIF}
        destructor Destroy; override;

        procedure Play(); overload;
        procedure Play(volume, pitch, pan: single); overload;

        function CreateInstance(flags: TSOUND_EFFECT_INSTANCE_FLAGS = SoundEffectInstance_Default): TSoundEffectInstance;

        function IsInUse(): boolean;

        function GetSampleSizeInBytes(): size_t;
        // Returns size of wave audio data

        function GetSampleDuration(): size_t;
        // Returns the duration in samples

        function GetSampleDurationMS(): size_t;
        // Returns the duration in milliseconds

        function GetFormat(): PWAVEFORMATEX;

        {$IFDEF  USING_XAUDIO2_9}
        function FillSubmitBuffer(
        {_Out_} out buffer: TXAUDIO2_BUFFER;
        {_Out_} out wmaBuffer: TXAUDIO2_BUFFER_WMA): boolean;
        {$ELSE}
        procedure  FillSubmitBuffer({_Out_} out buffer:TXAUDIO2_BUFFER) const;
        {$ENDIF}

        procedure UnregisterInstance({_In_}  instance: IVoiceNotify);


    end;


    { TAudioListener }

    TAudioListener = record helper for TX3DAUDIO_LISTENER
        procedure Init;
        procedure SetPosition(v: TXMVector); overload;
        procedure SetPosition(pos: TXMFLOAT3); overload;

        procedure SetVelocity(vel: TXMVector); overload;
        procedure SetVelocity(vel: TXMFLOAT3); overload;

        procedure SetOrientation(forward, up: TXMFLOAT3); overload;
        procedure SetOrientation(forward, up: TXMVECTOR); overload;

        procedure SetOrientationFromQuaternion(quat: TXMVECTOR);
        procedure Update(newPos: TXMVECTOR; upDir: TXMVECTOR; dt: single);// Updates velocity and orientation by tracking changes in position over time.
        procedure SetOmnidirectional();
        procedure SetCone(listenerCone: PX3DAUDIO_CONE);
        function IsValid(): boolean; overload;
        function IsValid(cone: PX3DAUDIO_CONE): boolean; overload;
    end;

    // Helper class for implementing SoundEffectInstance

    { TSoundEffectInstanceBase }

    TSoundEffectInstanceBase = class(TObject)
    protected
        voice: IXAudio2SourceVoice;
        state: TSoundState;
        engine: TAudioEngine;

        mVolume: single;
        mPitch: single;
        mFreqRatio: single;
        mPan: single;
        mFlags: TSOUND_EFFECT_INSTANCE_FLAGS;
        mX3DCalcFlags: uint32;
        mDirectVoice: IXAudio2Voice;
        mReverbVoice: IXAudio2Voice;
        mDSPSettings: TX3DAUDIO_DSP_SETTINGS;
        procedure UpdateCalculateFlags();

        procedure Initialize({_In_} eng: TAudioEngine; {_In_}  wfx: PWAVEFORMATEX; flags: TSOUND_EFFECT_INSTANCE_FLAGS);
        procedure AllocateVoice({_In_}  wfx: PWAVEFORMATEX);
        procedure DestroyVoice();
    public
        constructor Create;
        destructor Destroy; override;
        procedure OnCriticalError;
        procedure OnReset();
        procedure OnDestroy();
        procedure OnTrim();
        procedure GatherStatistics(stats: TAudioStatistics);
        function Play(): boolean; // Returns true if STOPPED . PLAYING
        procedure SetPan(pan: single);
    end;

    { TSoundEffectInstance }

    TSoundEffectInstance = class(IVoiceNotify)
    protected
        mBase: TSoundEffectInstanceBase;
        mEffect: TSoundEffect;
        mWaveBank: TWaveBank;
        mIndex: uint32;
        mLooped: boolean;
    public
        constructor Create;
        destructor Destroy; override;
        procedure Play(loop: bool = False);
        procedure Stop(immediate: bool = True);
        procedure Pause();
        procedure Resume();

        procedure SetVolume(volume: single);
        procedure SetPitch(pitch: single);
        procedure SetPan(pan: single);

        procedure Apply3D(listener: TX3DAUDIO_LISTENER; emitter: TX3DAUDIO_EMITTER; rhcoords: bool = True);

        function IsLooped(): bool;

        function GetState(): TSoundState;

        function GetChannelCount(): uint;

        function GetVoiceNotify(): IVoiceNotify;
        // TVoiceNotify
        procedure OnBufferEnd(); override;
        procedure OnCriticalError(); override;
        procedure OnReset(); override;
        procedure OnUpdate(); override;
        procedure OnDestroyEngine(); override;
        procedure OnTrim(); override;
        procedure GatherStatistics(stats: TAudioStatistics); override;
        procedure OnDestroyParent(); override;
    end;


    { TSoundStreamInstance }

    TSoundStreamInstance = class(TObject)
    protected
        // Private implementation.
        // Private constructors
        procedure SoundStreamInstance({_In_}  engine:TAudioEngine; {_In_}  effect:TWaveBank ; index: uint;  flags :TSOUND_EFFECT_INSTANCE_FLAGS);
    public
        constructor Create;
        destructor Destroy; override;

    end;


    { TDynamicSoundEffectInstance }

    TDynamicSoundEffectInstance = class(TObject)
    public
        constructor Create;
        destructor Destroy; override;

    end;

implementation

uses
    Math,
    DX12TK.SoundCommon;

type
    TKeyGen = bitpacked record
        case integer of
            0: (pcm: record
                    tag: 0..511;
                    channels: 0..127;
                    bitsPerSample: 0..255;
                    end);
            1: (adpcm: record
                    tag: 0..511;
                    channels: 0..127;
                    samplesPerBlock: 0..65535;
                    end;
                key: uint32);
            2: (xma: record
                    tag: 0..511;
                    channels: 0..127;
                    encoderVersion: 0..255;
                    end);
    end;



function makeVoiceKey({_In_}  wfx: PWAVEFORMATEX): UINT; inline;
var
    tresult: TKeyGen;
    wfex: PWAVEFORMATEXTENSIBLE;
    tag: uint32;
    wfadpcm: PADPCMWAVEFORMAT;
begin

    {$IFOPT D+}
      assert(IsValid(wfx));
    {$ENDIF}

    if (wfx^.nChannels > $7F) then
    begin
        Result := 0;
        Exit;
    end;

    // This hash does not use nSamplesPerSec because voice reuse can change the source sample rate.

    // nAvgBytesPerSec and nBlockAlign are derived from other values in XAudio2 supported formats.


    assert(sizeof(TKeyGen) = sizeof(uint32), 'TKeyGen is invalid');

    tresult.key := 0;

    if (wfx^.wFormatTag = WAVE_FORMAT_EXTENSIBLE) then
    begin
        // We reuse EXTENSIBLE only if it is equivalent to the standard form

        wfex := PWAVEFORMATEXTENSIBLE(wfx);
        if ((wfex^.Samples.wValidBitsPerSample <> 0) and (wfex^.Samples.wValidBitsPerSample <> wfx^.wBitsPerSample)) then
        begin
            Result := 0;
            Exit;
        end;

        if ((wfex^.dwChannelMask <> 0) and (wfex^.dwChannelMask <> GetDefaultChannelMask(wfx^.nChannels))) then
        begin
            Result := 0;
            Exit;
        end;
    end;


    tag := GetFormatTag(wfx);
    case (tag) of

        WAVE_FORMAT_PCM:
        begin
            assert(WAVE_FORMAT_PCM < $1ff, 'KeyGen tag is too small');
            tresult.pcm.tag := WAVE_FORMAT_PCM;
            tresult.pcm.channels := wfx^.nChannels;
            tresult.pcm.bitsPerSample := wfx^.wBitsPerSample;
        end;

        WAVE_FORMAT_IEEE_FLOAT:
        begin
            Result := 0;
            assert(WAVE_FORMAT_IEEE_FLOAT < $1ff, 'KeyGen tag is too small');

            if (wfx^.wBitsPerSample <> 32) then
                exit;

            tresult.pcm.tag := WAVE_FORMAT_IEEE_FLOAT;
            tresult.pcm.channels := wfx^.nChannels;
            tresult.pcm.bitsPerSample := 32;
        end;

        WAVE_FORMAT_ADPCM:
        begin
            assert(WAVE_FORMAT_ADPCM < $1ff, 'KeyGen tag is too small');
            tresult.adpcm.tag := WAVE_FORMAT_ADPCM;
            tresult.adpcm.channels := wfx^.nChannels;


            wfadpcm := PADPCMWAVEFORMAT(wfx);
            tresult.adpcm.samplesPerBlock := wfadpcm^.wSamplesPerBlock;

        end;

            {$ifdef DIRECTX_ENABLE_XMA2}
       WAVE_FORMAT_XMA2:
      	 begin
      	 {$IFOPT D+}
          assert(WAVE_FORMAT_XMA2 < $1ff, 'KeyGen tag is too small');
      	  {$ENDIF}
          result.xma.tag := WAVE_FORMAT_XMA2;
          result.xma.channels := wfx.nChannels;

          begin
              auto xmaFmt = reinterpret_cast<const XMA2WAVEFORMATEX*>(wfx);

              if ((xmaFmt.LoopBegin > 0)
                  or (xmaFmt.PlayBegin > 0)) then
      			begin
                  result:= 0;
      				Exit;
      			end;
              result.xma.encoderVersion := xmaFmt.EncoderVersion;
          end;
          end;
            {$endif}

        else
        begin
            Result := 0;
            Exit;
        end;
            Result := tResult.key;
    end;
end;

{ IVoiceNotify }

procedure IVoiceNotify.OnBufferEnd();
begin

end;



procedure IVoiceNotify.OnCriticalError();
begin

end;



procedure IVoiceNotify.OnReset();
begin

end;



procedure IVoiceNotify.OnUpdate();
begin

end;



procedure IVoiceNotify.OnDestroyEngine();
begin

end;



procedure IVoiceNotify.OnTrim();
begin

end;



procedure IVoiceNotify.GatherStatistics(stats: TAudioStatistics);
begin

end;



procedure IVoiceNotify.OnDestroyParent();
begin

end;

{ TEngineCallback }

procedure TEngineCallback.OnProcessingPassStart(); stdcall;
begin

end;



procedure TEngineCallback.OnProcessingPassEnd(); stdcall;
begin

end;



procedure TEngineCallback.OnCriticalError(Error: HRESULT); stdcall;
begin
    // DebugTrace("ERROR: AudioEngine encountered critical error (%08X)\n", static_cast<unsigned int>(error));
    SetEvent(mCriticalError);
end;

{ TVoiceCallback }

constructor TVoiceCallback.Create;
begin

end;



destructor TVoiceCallback.Destroy;
begin
    inherited Destroy;
end;



procedure TVoiceCallback.OnVoiceProcessingPassStart(BytesRequired: uint32); stdcall;
begin

end;



procedure TVoiceCallback.OnVoiceProcessingPassEnd(); stdcall;
begin

end;



procedure TVoiceCallback.OnStreamEnd(); stdcall;
begin

end;



procedure TVoiceCallback.OnBufferStart(pBufferContext: pointer); stdcall;
begin

end;



procedure TVoiceCallback.OnBufferEnd(pBufferContext: pointer); stdcall;
var
   iNotify:  IVoiceNotify;
begin
    if (pBufferContext<>nil) then
            begin
                iNotify := IVoiceNotify(pBufferContext);
                iNotify.OnBufferEnd();
                SetEvent(mBufferEnd);
            end;
end;



procedure TVoiceCallback.OnLoopEnd(pBufferContext: pointer); stdcall;
begin

end;



procedure TVoiceCallback.OnVoiceError(pBufferContext: pointer; Error: HRESULT); stdcall;
begin

end;

{ TAudioEngine }

constructor TAudioEngine.Create(flags: TAUDIO_ENGINE_FLAGS; wfx: PWAVEFORMATEX; deviceId: pwidechar; category: TAUDIO_STREAM_CATEGORY);
begin
    mMasterVoice := nil;
    mReverbVoice := nil;
    masterChannelMask := 0;
    masterChannels := 0;
    masterRate := 0;
    defaultRate := 44100;
    maxVoiceOneshots := SIZE_MAX;
    maxVoiceInstances := SIZE_MAX;
    mMasterVolume := 1.0;
    //        mX3DAudio{},
    mX3DCalcFlags := c_XAudio3DCalculateDefault;
    mCriticalError := False;
    mReverbEnabled := False;
    mEngineFlags := AudioEngine_Default;
    //        mOutputFormat{},
    mCategory := AudioCategory_GameEffects;
    mVoiceInstances := 0;
end;



destructor TAudioEngine.Destroy;
begin
    inherited Destroy;
end;



function TAudioEngine.Update(): bool;
begin

end;



function TAudioEngine.Reset(wfx: PWAVEFORMATEX; deviceId: pwidechar): bool;
begin

end;



procedure TAudioEngine.Suspend();
begin

end;



procedure TAudioEngine.Resume();
begin

end;



function TAudioEngine.GetMasterVolume(): single;
begin

end;



procedure TAudioEngine.SetMasterVolume(volume: single);
begin

end;



procedure TAudioEngine.SetReverb(reverb: TAUDIO_ENGINE_REVERB);
begin

end;



procedure TAudioEngine.SetReverb(native: PXAUDIO2FX_REVERB_PARAMETERS);
begin

end;



procedure TAudioEngine.SetMasteringLimit(Release, loudness: integer);
begin

end;



function TAudioEngine.GetStatistics(): TAudioStatistics;
begin

end;



function TAudioEngine.GetOutputFormat(): TWAVEFORMATEXTENSIBLE;
begin

end;



function TAudioEngine.GetChannelMask(): uint32;
begin

end;



function TAudioEngine.GetOutputSampleRate(): longint;
begin

end;



function TAudioEngine.GetOutputChannels(): uint;
begin

end;



function TAudioEngine.IsAudioDevicePresent(): bool;
begin

end;



function TAudioEngine.IsCriticalError(): bool;
begin

end;



procedure TAudioEngine.SetDefaultSampleRate(sampleRate: integer);
begin

end;



procedure TAudioEngine.SetMaxVoicePool(maxOneShots, maxInstances: size_t);
begin

end;



procedure TAudioEngine.TrimVoicePool();
begin

end;



procedure TAudioEngine.AllocateVoice(wfx: PWAVEFORMATEX; flags: TSOUND_EFFECT_INSTANCE_FLAGS; oneshot: bool; out voice: IXAudio2SourceVoice);
begin

end;



procedure TAudioEngine.DestroyVoice(voice: IXAudio2SourceVoice);
begin

end;



procedure TAudioEngine.RegisterNotify(notify: IVoiceNotify; usesUpdate: bool);
begin

end;



procedure TAudioEngine.UnregisterNotify(notify: IVoiceNotify; usesOneShots: bool; usesUpdate: bool);
var
setevent :boolean= false;
state :TXAUDIO2_VOICE_STATE;
begin
(*   assert(notify <> nil);
   mNotifyObjects.erase(notify);

    // Check for any pending one-shots for this notification object
    if (usesOneShots) then
    begin


        for (auto& it : mOneShots) do
        begin
            assert(it.second <> nil);


            it.second.GetState(state, XAUDIO2_VOICE_NOSAMPLESPLAYED);

            if (state.pCurrentBufferContext = notify) then
            begin
                it.second.Stop(0);
                it.second.FlushSourceBuffers();
                setevent := true;
            end;
        end;

        if (setevent) then
        begin
            // Trigger scan on next call to Update...
            SetEvent(mVoiceCallback.mBufferEnd);
        end;
    end;

    if (usesUpdate) then
    begin
        mNotifyUpdates.erase(notify);
    end;
    *)
end;



function TAudioEngine.GetInterface(): IXAudio2;
begin
    result:=xaudio2;
end;



function TAudioEngine.GetMasterVoice(): IXAudio2MasteringVoice;
begin
    result:=mMasterVoice;
end;



function TAudioEngine.GetReverbVoice(): IXAudio2SubmixVoice;
begin
   result:=mReverbVoice;
end;



function TAudioEngine.Get3DHandle(): TX3DAUDIO_HANDLE;
begin
   result:=mX3DAudio;
end;



function TAudioEngine.Get3DCalculateFlags(): uint32;
begin
    result:= mX3DCalcFlags;
end;



function TAudioEngine.GetRendererDetails(): TRendererDetailArray;
begin

end;

{ TWaveBank }

constructor TWaveBank.Create(engine: TAudioEngine; wbFileName: pwidechar);
begin

end;



destructor TWaveBank.Destroy;
begin
    inherited Destroy;
end;



procedure TWaveBank.Play(index: uint);
begin

end;



procedure TWaveBank.Play(index: uint; volume, pitch, pan: single);
begin

end;



procedure TWaveBank.Play(Name: pansichar);
begin

end;



procedure TWaveBank.Play(Name: pansichar; volume, pitch, pan: single);
begin

end;



function TWaveBank.CreateInstance(index: uint; flags: TSOUND_EFFECT_INSTANCE_FLAGS): TSoundEffectInstance;
begin

end;



function TWaveBank.CreateInstance(Name: pansichar; flags: TSOUND_EFFECT_INSTANCE_FLAGS): TSoundEffectInstance;
begin

end;



function TWaveBank.CreateStreamInstance(index: uint; flags: TSOUND_EFFECT_INSTANCE_FLAGS): TSoundStreamInstance;
begin

end;



function TWaveBank.CreateStreamInstance(Name: pansichar; flags: TSOUND_EFFECT_INSTANCE_FLAGS): TSoundStreamInstance;
begin

end;



function TWaveBank.IsPrepared(): boolean;
begin

end;



function TWaveBank.IsInUse(): boolean;
begin

end;



function TWaveBank.IsStreamingBank(): boolean;
begin

end;



function TWaveBank.IsAdvancedFormat(): boolean;
begin

end;



function TWaveBank.GetSampleSizeInBytes(index: uint): size_t;
begin

end;



function TWaveBank.GetSampleDuration(index: uint): size_t;
begin

end;



function TWaveBank.GetSampleDurationMS(index: uint): size_t;
begin

end;



function TWaveBank.GetFormat(index: uint; wfx: PWAVEFORMATEX; maxsize: size_t): TWAVEFORMATEX;
begin

end;



function TWaveBank.Find(Name: pansichar): integer;
begin

end;


{$IFDEF  USING_XAUDIO2_9}
function TWaveBank.FillSubmitBuffer(index: uint; out buffer: TXAUDIO2_BUFFER; out wmaBuffer: TXAUDIO2_BUFFER_WMA): boolean;
begin

end;
{$ELSE}
procedure TWaveBank.FillSubmitBuffer(index: uint; out buffer: TXAUDIO2_BUFFER);
begin

end;
{$ENDIF}



procedure TWaveBank.UnregisterInstance(instance: IVoiceNotify);
begin

end;



function TWaveBank.GetAsyncHandle(): HANDLE;
begin

end;



function TWaveBank.GetPrivateData(index: uint; out Data: pointer; datasize: size_t): boolean;
begin

end;

{ TSoundEffect }

constructor TSoundEffect.Create(engine: TAudioEngine; waveFileName: pwidechar);
begin

end;



constructor TSoundEffect.Create(engine: TAudioEngine; wavData: pbyte; wfx: PWAVEFORMATEX; startAudio: pbyte; audioBytes: size_t);
begin

end;



constructor TSoundEffect.Create(engine: TAudioEngine; wavData: pbyte; wfx: PWAVEFORMATEX; startAudio: pbyte; audioBytes: size_t; loopStart: uint32; loopLength: uint32);
begin

end;



constructor TSoundEffect.Create(engine: TAudioEngine; wavData: pbyte; wfx: PWAVEFORMATEX; startAudio: pbyte; audioBytes: size_t; seekTable: Puint32; seekCount: size_t);
begin

end;



destructor TSoundEffect.Destroy;
begin
    inherited Destroy;
end;



procedure TSoundEffect.Play();
begin

end;



procedure TSoundEffect.Play(volume, pitch, pan: single);
begin

end;



function TSoundEffect.CreateInstance(flags: TSOUND_EFFECT_INSTANCE_FLAGS): TSoundEffectInstance;
begin

end;



function TSoundEffect.IsInUse(): boolean;
begin

end;



function TSoundEffect.GetSampleSizeInBytes(): size_t;
begin

end;



function TSoundEffect.GetSampleDuration(): size_t;
begin

end;



function TSoundEffect.GetSampleDurationMS(): size_t;
begin

end;



function TSoundEffect.GetFormat(): PWAVEFORMATEX;
begin

end;



function TSoundEffect.FillSubmitBuffer(out buffer: TXAUDIO2_BUFFER; out wmaBuffer: TXAUDIO2_BUFFER_WMA): boolean;
begin

end;



procedure TSoundEffect.UnregisterInstance(instance: IVoiceNotify);
begin

end;

{ TAudioListener }

function TAudioListener.IsValid(cone: PX3DAUDIO_CONE): boolean;
begin
    Result := False;
    // These match the validation ranges in X3DAudio.
    if (cone^.InnerAngle < 0.0) or (cone^.InnerAngle > X3DAUDIO_2PI) then
        Exit;

    if (cone^.OuterAngle < 0.0) or (cone^.OuterAngle > X3DAUDIO_2PI) then
        Exit;

    if (cone^.InnerAngle > cone^.OuterAngle) then
        Exit;

    if (cone^.InnerVolume < 0.0) or (cone^.InnerVolume > 2.0) then
        Exit;

    if (cone^.OuterVolume < 0.0) or (cone^.OuterVolume > 2.0) then
        Exit;

    if (cone^.InnerLPF < 0.0) or (cone^.InnerLPF > 1.0) then
        Exit;

    if (cone^.OuterLPF < 0.0) or (cone^.OuterLPF > 1.0) then
        Exit;

    if (cone^.InnerReverb < 0.0) or (cone^.InnerReverb > 2.0) then
        Exit;

    if (cone^.OuterReverb < 0.0) or (cone^.OuterReverb > 2.0) then
        Exit;

    Result := True;
end;



procedure TAudioListener.Init;
begin
    ZeroMemory(@Self, SizeOf(TAudioListener));
    pCone := nil;
    OrientFront.z := -1.0;
    OrientTop.y := 1.0;
end;



procedure TAudioListener.SetPosition(v: TXMVector);
begin
    XMStoreFloat3(@Position, v);
end;



procedure TAudioListener.SetPosition(pos: TXMFLOAT3);
begin
    Position.x := pos.x;
    Position.y := pos.y;
    Position.z := pos.z;
end;



procedure TAudioListener.SetVelocity(vel: TXMVector);
begin
    XMStoreFloat3(@Velocity, vel);
end;



procedure TAudioListener.SetVelocity(vel: TXMFLOAT3);
begin
    Velocity.x := vel.x;
    Velocity.y := vel.y;
    Velocity.z := vel.z;
end;



procedure TAudioListener.SetOrientation(forward, up: TXMFLOAT3);
begin
    OrientFront.x := forward.x;
    OrientTop.x := up.x;
    OrientFront.y := forward.y;
    OrientTop.y := up.y;
    OrientFront.z := forward.z;
    OrientTop.z := up.z;
end;



procedure TAudioListener.SetOrientation(forward, up: TXMVECTOR);
begin
    XMStoreFloat3(@OrientFront, forward);
    XMStoreFloat3(@OrientTop, up);
end;



procedure TAudioListener.SetOrientationFromQuaternion(quat: TXMVECTOR);
var
    forward: TXMVECTOR;
    up: TXMVECTOR;
begin
    forward := XMVector3Rotate(g_XMIdentityR2, quat);
    XMStoreFloat3(@OrientFront, forward);

    up := XMVector3Rotate(g_XMIdentityR1, quat);
    XMStoreFloat3(@OrientTop, up);
end;
// Updates velocity and orientation by tracking changes in position over time.


procedure TAudioListener.Update(newPos: TXMVECTOR; upDir: TXMVECTOR; dt: single);
var
    lastPos: TXMVECTOR;
    vDelta: TXMVECTOR;
    vt: TXMVECTOR;
    v: TXMVECTOR;
begin
    if (dt > 0.0) then
    begin
        lastPos := XMLoadFloat3(TXMFLOAT3(Position));

        vDelta := XMVectorSubtract(newPos, lastPos);
        vt := XMVectorReplicate(dt);
        v := XMVectorDivide(vDelta, vt);
        XMStoreFloat3(@Velocity, v);

        vDelta := XMVector3Normalize(vDelta);
        XMStoreFloat3(@OrientFront, vDelta);

        v := XMVector3Cross(upDir, vDelta);
        v := XMVector3Normalize(v);

        v := XMVector3Cross(vDelta, v);
        v := XMVector3Normalize(v);
        XMStoreFloat3(@OrientTop, v);

        XMStoreFloat3(@Position, newPos);
    end;
end;



procedure TAudioListener.SetOmnidirectional();
begin
    pCone := nil;
end;



procedure TAudioListener.SetCone(listenerCone: PX3DAUDIO_CONE);
begin
    if (not self.IsValid(listenerCone)) then
        raise Exception.Create('X3DAUDIO_CONE values out of range');

    pCone := listenerCone;
end;



function TAudioListener.IsValid: boolean;
begin
    Result := False;
    if (IsInfinite(OrientFront.x)) then
        Exit;
    if (IsInfinite(OrientFront.y)) then
        Exit;
    if (IsInfinite(OrientFront.z)) then
        Exit;

    if (IsInfinite(OrientTop.x)) then
        Exit;
    if (IsInfinite(OrientTop.y)) then
        Exit;
    if (IsInfinite(OrientTop.z)) then
        Exit;

    if (IsInfinite(Position.x)) then
        Exit;
    if (IsInfinite(Position.y)) then
        Exit;
    if (IsInfinite(Position.z)) then
        Exit;

    if (IsInfinite(Velocity.x)) then
        Exit;
    if (IsInfinite(Velocity.y)) then
        Exit;
    if (IsInfinite(Velocity.z)) then
        Exit;

    if (pCone <> nil) then
    begin
        if (not Self.IsValid(pCone)) then
            Exit;
    end;

    Result := True;
end;

{ TSoundEffectInstanceBase }

procedure TSoundEffectInstanceBase.UpdateCalculateFlags();
begin
    {$IFOPT D+}
    assert(engine <> nil);
    {$ENDIF}
    mX3DCalcFlags := engine.Get3DCalculateFlags();
    if (((engine.GetChannelMask() and SPEAKER_LOW_FREQUENCY) = SPEAKER_LOW_FREQUENCY) and ((Ord(mFlags) and Ord(SoundEffectInstance_UseRedirectLFE)) = Ord(SoundEffectInstance_UseRedirectLFE))) then
    begin
        mX3DCalcFlags := mX3DCalcFlags or X3DAUDIO_CALCULATE_REDIRECT_TO_LFE;
    end;

    if ((Ord(mFlags) and Ord(SoundEffectInstance_ZeroCenter3D)) = Ord(SoundEffectInstance_ZeroCenter3D)) then
    begin
        mX3DCalcFlags := mX3DCalcFlags or X3DAUDIO_CALCULATE_ZEROCENTER;
    end;
end;



procedure TSoundEffectInstanceBase.Initialize(eng: TAudioEngine; wfx: PWAVEFORMATEX; flags: TSOUND_EFFECT_INSTANCE_FLAGS);
begin
    {$IFOPT D+}
  assert(eng <> nil);
    {$ENDIF}
    engine := eng;
    mFlags := flags;

    UpdateCalculateFlags();

    mDirectVoice := eng.GetMasterVoice();
    mReverbVoice := eng.GetReverbVoice();

    ZeroMemory(@mDSPSettings, sizeof(TX3DAUDIO_DSP_SETTINGS));
    {$IFOPT D+}
    assert(wfx <> nil);
    {$ENDIF}

    mDSPSettings.SrcChannelCount := wfx^.nChannels;
    mDSPSettings.DstChannelCount := eng.GetOutputChannels();
end;



procedure TSoundEffectInstanceBase.AllocateVoice(wfx: PWAVEFORMATEX);
begin
    if (voice <> nil) then
        Exit;
    {$IFOPT D+}
            assert(engine <> nil);
    {$ENDIF}
    engine.AllocateVoice(wfx, mFlags, False, voice);
end;



procedure TSoundEffectInstanceBase.DestroyVoice();
begin
    if (voice <> nil) then
    begin
        {$IFOPT D+}
        assert(engine <> nil);
        {$ENDIF}
        engine.DestroyVoice(voice);
        voice := nil;
    end;
end;



constructor TSoundEffectInstanceBase.Create;
begin
    voice := nil;
    state := STOPPED;
    engine := nil;
    mVolume := 1.0;
    mPitch := 0.0;
    mFreqRatio := 1.0;
    mPan := 0.0;
    mFlags := SoundEffectInstance_Default;
    mX3DCalcFlags := 0;
    mDirectVoice := nil;
    mReverbVoice := nil;
    ZeroMemory(@mDSPSettings, sizeof(TX3DAUDIO_DSP_SETTINGS));
end;



destructor TSoundEffectInstanceBase.Destroy;
begin
    {$IFOPT D+}
    assert(voice = nil);
    {$ENDIF}
    inherited Destroy;
end;



procedure TSoundEffectInstanceBase.OnCriticalError;
begin

end;



procedure TSoundEffectInstanceBase.OnReset();
begin
    {$IFOPT D+}
    assert(engine <> nil);
    {$ENDIF}
    mDirectVoice := engine.GetMasterVoice();
    mReverbVoice := engine.GetReverbVoice();

    UpdateCalculateFlags();

    mDSPSettings.DstChannelCount := engine.GetOutputChannels();
end;



procedure TSoundEffectInstanceBase.OnDestroy();
begin
    if (voice <> nil) then
    begin
        voice.Stop(0);
        voice.FlushSourceBuffers();
        voice.DestroyVoice();
        voice := nil;
    end;

    state := STOPPED;
    engine := nil;
    mDirectVoice := nil;
    mReverbVoice := nil;
end;



procedure TSoundEffectInstanceBase.OnTrim();
begin
    if ((voice <> nil) and (state = STOPPED)) then
    begin
        engine.DestroyVoice(voice);
        voice := nil;
    end;
end;



procedure TSoundEffectInstanceBase.GatherStatistics(stats: TAudioStatistics);
begin
    Inc(stats.allocatedInstances);
    if (voice <> nil) then
    begin
        Inc(stats.allocatedVoices);

        if ((Ord(mFlags) and Ord(SoundEffectInstance_Use3D)) = Ord(SoundEffectInstance_Use3D)) then
            Inc(stats.allocatedVoices3d);

        if (state = PLAYING) then
            Inc(stats.playingInstances);
    end;
end;

// Returns true if STOPPED :: PLAYING

function TSoundEffectInstanceBase.Play(): boolean;
var
    hr: HResult;
begin

    if (voice <> nil) then
    begin
        if (state = PAUSED) then
        begin
            hr := voice.Start(0);
            ThrowIfFailed(hr);
            state := PLAYING;
        end
        else if (state <> PLAYING) then
        begin
            if (mVolume <> 1.0) then
            begin
                hr := voice.SetVolume(mVolume);
                ThrowIfFailed(hr);
            end;

            if (mPitch <> 0.0) then
            begin
                mFreqRatio := XAudio2SemitonesToFrequencyRatio(mPitch * 12.0);

                hr := voice.SetFrequencyRatio(mFreqRatio);
                ThrowIfFailed(hr);
            end;

            if (mPan <> 0.0) then
            begin
                SetPan(mPan);
            end;

            hr := voice.Start(0);
            ThrowIfFailed(hr);
            state := PLAYING;
            Result := True;
            Exit;
        end;
    end;
    Result := False;
end;



procedure TSoundEffectInstanceBase.SetPan(pan: single);
begin

end;

{ TSoundEffectInstance }

constructor TSoundEffectInstance.Create;
begin

end;



destructor TSoundEffectInstance.Destroy;
begin
    inherited Destroy;
end;



procedure TSoundEffectInstance.Play(loop: bool);
begin

end;



procedure TSoundEffectInstance.Stop(immediate: bool);
begin

end;



procedure TSoundEffectInstance.Pause();
begin

end;



procedure TSoundEffectInstance.Resume();
begin

end;



procedure TSoundEffectInstance.SetVolume(volume: single);
begin

end;



procedure TSoundEffectInstance.SetPitch(pitch: single);
begin

end;



procedure TSoundEffectInstance.SetPan(pan: single);
begin

end;



procedure TSoundEffectInstance.Apply3D(listener: TX3DAUDIO_LISTENER; emitter: TX3DAUDIO_EMITTER; rhcoords: bool);
begin

end;



function TSoundEffectInstance.IsLooped(): bool;
begin

end;



function TSoundEffectInstance.GetState(): TSoundState;
begin

end;



function TSoundEffectInstance.GetChannelCount(): uint;
begin

end;



function TSoundEffectInstance.GetVoiceNotify(): IVoiceNotify;
begin

end;



procedure TSoundEffectInstance.OnBufferEnd();
begin
    // We don't register for this notification for SoundEffectInstances, so this should not be invoked
    assert(False);
end;



procedure TSoundEffectInstance.OnCriticalError();
begin
    mBase.OnCriticalError();
end;



procedure TSoundEffectInstance.OnReset();
begin
    mBase.OnReset();
end;



procedure TSoundEffectInstance.OnUpdate();
begin
    // We do not register for update notification
    assert(False);
end;



procedure TSoundEffectInstance.OnDestroyEngine();
begin
    mBase.OnDestroy();
end;



procedure TSoundEffectInstance.OnTrim();
begin
    mBase.OnTrim();
end;



procedure TSoundEffectInstance.GatherStatistics(stats: TAudioStatistics);
begin
    mBase.GatherStatistics(stats);
end;



procedure TSoundEffectInstance.OnDestroyParent();
begin
    inherited OnDestroyParent();
end;

{ TSoundStreamInstance }

procedure TSoundStreamInstance.SoundStreamInstance(engine: TAudioEngine;
  effect: TWaveBank; index: uint; flags: TSOUND_EFFECT_INSTANCE_FLAGS);
begin

end;

constructor TSoundStreamInstance.Create;
begin

end;



destructor TSoundStreamInstance.Destroy;
begin
    inherited Destroy;
end;

{ TDynamicSoundEffectInstance }

constructor TDynamicSoundEffectInstance.Create;
begin

end;



destructor TDynamicSoundEffectInstance.Destroy;
begin
    inherited Destroy;
end;

end.
