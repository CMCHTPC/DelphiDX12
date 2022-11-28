unit SoundClass;

{$mode DelphiUnicode}{$H+}

interface

uses
    Classes, SysUtils, Windows,
    mmsystem,
    DirectSound;

type

    TWaveHeaderType = packed record
        chunkId: array [0..3] of ansichar;
        chunkSize: uint32;
        format: array[0..3] of ansichar;
        subChunkId: array[0..3] of ansichar;
        subChunkSize: uint32;
        audioFormat: uint16;
        numChannels: uint16;
        sampleRate: uint32;
        bytesPerSecond: uint32;
        blockAlign: uint16;
        bitsPerSample: uint16;
        dataChunkId: array[0..3] of ansichar;
        dataSize: uint32;
    end;

    { TSoundClass }

    TSoundClass = class(TObject)
    private
        m_DirectSound: IDirectSound8;
        m_primaryBuffer: IDirectSoundBuffer;
        m_secondaryBuffer1: IDirectSoundBuffer8;
    private
        function InitializeDirectSound(hwnd: HWND): HResult;
        procedure ShutdownDirectSound();

        function LoadWaveFile(filename: WideString; var secondaryBuffer: IDirectSoundBuffer8): HResult;
        procedure ShutdownWaveFile(var secondaryBuffer: IDirectSoundBuffer8);

        function PlayWaveFile(): HResult;
    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(HWND: hwnd): HResult;
        procedure Shutdown();
    end;

implementation

{ TSoundClass }

function TSoundClass.InitializeDirectSound(HWND: hwnd): HResult;
var
    bufferDesc: TDSBUFFERDESC;
    waveFormat: TWAVEFORMATEX;
begin
    // Initialize the direct sound interface pointer for the default sound device.
    Result := DirectSoundCreate8(nil, m_DirectSound, nil);
    if (Result <> S_OK) then Exit;

    // Set the cooperative level to priority so the format of the primary sound buffer can be modified.
    Result := m_DirectSound.SetCooperativeLevel(hwnd, DSSCL_PRIORITY);
    if (Result <> S_OK) then Exit;

    // Setup the primary buffer description.
    bufferDesc.dwSize := sizeof(DSBUFFERDESC);
    bufferDesc.dwFlags := DSBCAPS_PRIMARYBUFFER or DSBCAPS_CTRLVOLUME;
    bufferDesc.dwBufferBytes := 0;
    bufferDesc.dwReserved := 0;
    bufferDesc.lpwfxFormat := nil;
    bufferDesc.guid3DAlgorithm := GUID_NULL;

    // Get control of the primary sound buffer on the default sound device.
    Result := m_DirectSound.CreateSoundBuffer(bufferDesc, m_primaryBuffer, nil);
    if (Result <> S_OK) then Exit;

    // Setup the format of the primary sound bufffer.
    // In this case it is a .WAV file recorded at 44,100 samples per second in 16-bit stereo (cd audio format).
    waveFormat.wFormatTag := WAVE_FORMAT_PCM;
    waveFormat.nSamplesPerSec := 44100;
    waveFormat.wBitsPerSample := 16;
    waveFormat.nChannels := 2;
    waveFormat.nBlockAlign := (waveFormat.wBitsPerSample div 8) * waveFormat.nChannels;
    waveFormat.nAvgBytesPerSec := waveFormat.nSamplesPerSec * waveFormat.nBlockAlign;
    waveFormat.cbSize := 0;

    // Set the primary buffer to be the wave format specified.
    Result := m_primaryBuffer.SetFormat(@waveFormat);

end;



procedure TSoundClass.ShutdownDirectSound();
begin
    // Release the primary sound buffer pointer.
    m_primaryBuffer := nil;

    // Release the direct sound interface pointer.
    m_DirectSound := nil;
end;



function TSoundClass.LoadWaveFile(filename: WideString; var secondaryBuffer: IDirectSoundBuffer8): HResult;
var
    error: integer;
    filePtr: TFileStream;
    Count: uint32;
    waveFileHeader: TWaveHeaderType;
    waveFormat: TWAVEFORMATEX;
    bufferDesc: TDSBUFFERDESC;

    tempBuffer: IDirectSoundBuffer;
    waveData: array of byte;
    bufferPtr: pbyte;
    bufferSize: uint32;
begin
    Result := E_FAIL;
    // Open the wave file in binary.
    filePtr := TFileStream.Create(filename, fmOpenRead);
    try



        // Read in the wave file header.
        Count := filePtr.Read(waveFileHeader, sizeof(waveFileHeader));
        if (Count <> sizeof(waveFileHeader)) then Exit;

        // Check that the chunk ID is the RIFF format.
        if ((waveFileHeader.chunkId[0] <> 'R') or (waveFileHeader.chunkId[1] <> 'I') or (waveFileHeader.chunkId[2] <> 'F') or
            (waveFileHeader.chunkId[3] <> 'F')) then Exit;

        // Check that the file format is the WAVE format.
        if ((waveFileHeader.format[0] <> 'W') or (waveFileHeader.format[1] <> 'A') or (waveFileHeader.format[2] <> 'V') or
            (waveFileHeader.format[3] <> 'E')) then Exit;

        // Check that the sub chunk ID is the fmt format.
        if ((waveFileHeader.subChunkId[0] <> 'f') or (waveFileHeader.subChunkId[1] <> 'm') or (waveFileHeader.subChunkId[2] <> 't') or
            (waveFileHeader.subChunkId[3] <> ' ')) then Exit;

        // Check that the audio format is WAVE_FORMAT_PCM.
        if (waveFileHeader.audioFormat <> WAVE_FORMAT_PCM) then Exit;

        // Check that the wave file was recorded in stereo format.
        if (waveFileHeader.numChannels <> 2) then Exit;

        // Check that the wave file was recorded at a sample rate of 44.1 KHz.
        if (waveFileHeader.sampleRate <> 44100) then Exit;

        // Ensure that the wave file was recorded in 16 bit format.
        if (waveFileHeader.bitsPerSample <> 16) then Exit;

        // Check for the data chunk header.
        if ((waveFileHeader.dataChunkId[0] <> 'd') or (waveFileHeader.dataChunkId[1] <> 'a') or (waveFileHeader.dataChunkId[2] <> 't') or
            (waveFileHeader.dataChunkId[3] <> 'a')) then Exit;

        // Set the wave format of secondary buffer that this wave file will be loaded onto.
        waveFormat.wFormatTag := WAVE_FORMAT_PCM;
        waveFormat.nSamplesPerSec := 44100;
        waveFormat.wBitsPerSample := 16;
        waveFormat.nChannels := 2;
        waveFormat.nBlockAlign := (waveFormat.wBitsPerSample div 8) * waveFormat.nChannels;
        waveFormat.nAvgBytesPerSec := waveFormat.nSamplesPerSec * waveFormat.nBlockAlign;
        waveFormat.cbSize := 0;

        // Set the buffer description of the secondary sound buffer that the wave file will be loaded onto.
        bufferDesc.dwSize := sizeof(DSBUFFERDESC);
        bufferDesc.dwFlags := DSBCAPS_CTRLVOLUME;
        bufferDesc.dwBufferBytes := waveFileHeader.dataSize;
        bufferDesc.dwReserved := 0;
        bufferDesc.lpwfxFormat := @waveFormat;
        bufferDesc.guid3DAlgorithm := GUID_NULL;

        // Create a temporary sound buffer with the specific buffer settings.
        Result := m_DirectSound.CreateSoundBuffer(bufferDesc, tempBuffer, nil);
        if (Result <> S_OK) then Exit;

        // Test the buffer format against the direct sound 8 interface and create the secondary buffer.
        Result := tempBuffer.QueryInterface(IID_IDirectSoundBuffer8, secondaryBuffer);
        if (Result <> S_OK) then Exit;

        // Release the temporary buffer.
        tempBuffer := nil;

        // Move to the beginning of the wave data which starts at the end of the data chunk header.
        filePtr.Seek(sizeof(TWaveHeaderType), soFromBeginning);

        // Create a temporary buffer to hold the wave file data.
        SetLength(waveData, waveFileHeader.dataSize);

        // Read in the wave file data into the newly created buffer.
        Count := filePtr.Read(waveData[0], waveFileHeader.dataSize);
        if (Count <> waveFileHeader.dataSize) then
        begin
            Result := E_FAIL;
            Exit;
        end;

        // Close the file once done reading.
    finally
        filePtr.Free;
    end;
    // Lock the secondary buffer to write wave data into it.
    Result := secondaryBuffer.Lock(0, waveFileHeader.dataSize, @bufferPtr, @bufferSize, nil, 0, 0);
    if (Result <> S_OK) then Exit;

    // Copy the wave data into the buffer.
    move(waveData[0], bufferPtr^, waveFileHeader.dataSize);

    // Unlock the secondary buffer after the data has been written to it.
    Result := secondaryBuffer.Unlock(bufferPtr, bufferSize, nil, 0);
    if (Result <> S_OK) then Exit;

    // Release the wave data since it was copied into the secondary buffer.
    SetLength(waveData, 0);

    Result := S_OK;
end;



procedure TSoundClass.ShutdownWaveFile(var secondaryBuffer: IDirectSoundBuffer8);
begin
    // Release the secondary sound buffer.
    if (secondaryBuffer <> nil) then
    begin
        secondaryBuffer := nil;
    end;
end;



function TSoundClass.PlayWaveFile(): HResult;
begin
    // Set position at the beginning of the sound buffer.
    Result := m_secondaryBuffer1.SetCurrentPosition(0);
    if (Result <> S_OK) then Exit;

    // Set volume of the buffer to 100%.
    Result := m_secondaryBuffer1.SetVolume(DSBVOLUME_MAX);
    if (Result <> S_OK) then Exit;

    // Play the contents of the secondary sound buffer.
    Result := m_secondaryBuffer1.Play(0, 0, DSBPLAY_LOOPING);

end;



constructor TSoundClass.Create;
begin

end;



destructor TSoundClass.Destroy;
begin
    inherited Destroy;
end;



function TSoundClass.Initialize(HWND: hwnd): HResult;
begin
    // Initialize direct sound and the primary sound buffer.
    Result := InitializeDirectSound(hwnd);
    if (Result <> S_OK) then Exit;

    // Load a wave audio file onto a secondary buffer.
    Result := LoadWaveFile('sound01.wav', m_secondaryBuffer1);
    if (Result <> S_OK) then Exit;

    // Play the wave file now that it has been loaded.

    Result := PlayWaveFile();
end;



procedure TSoundClass.Shutdown();
begin
    // Release the secondary buffer.
    ShutdownWaveFile(m_secondaryBuffer1);

    // Shutdown the Direct Sound API.
    ShutdownDirectSound();

end;

end.
