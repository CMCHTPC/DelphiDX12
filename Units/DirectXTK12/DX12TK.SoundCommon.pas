unit DX12TK.SoundCommon;

{$IFDEF FPC}
//{$mode delphi}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}


interface

uses
    Windows, Classes, SysUtils,
    DX12.XAudio2, Win32.MMReg,
    DX12.X3DAudio,
    DX12.XMA2Defs;

    {$I DX12TK.inc}
const
    MSADPCM_HEADER_LENGTH: int32 = 7;

    MSADPCM_FORMAT_EXTRA_BYTES: uint16 = 32;

    MSADPCM_BITS_PER_SAMPLE: uint16 = 4;
    MSADPCM_NUM_COEFFICIENTS: uint16 = 7;

    MSADPCM_MIN_SAMPLES_PER_BLOCK: uint16 = 4;
    MSADPCM_MAX_SAMPLES_PER_BLOCK: uint16 = 64000;

    // Microsoft ADPCM standard encoding coefficients
    g_pAdpcmCoefficients1: array [0..6] of short = (256, 512, 0, 192, 240, 460, 392);
    g_pAdpcmCoefficients2: array [0..6] of short = (0, -256, 0, 64, 0, -208, -232);

    s_wfexBase: TGUID = '{00000000-0000-0010-8000-00AA00389B71}';


    aCoef: array[0..6] of TADPCMCOEFSET = ((iCoef1: 256; iCoef2: 0), (iCoef1: 512; iCoef2: -256), (iCoef1: 0; iCoef2: 0), (iCoef1: 192; iCoef2: 64),
        (iCoef1: 240; iCoef2: 0),
        (iCoef1: 460; iCoef2: -208), (iCoef1: 392; iCoef2: -232));


    // **Note these constants came from xact3d3.h in the legacy DirectX SDK**

    // Supported speaker positions, represented as azimuth angles.

    // Here's a picture of the azimuth angles for the 8 cardinal points,
    // seen from above.  The emitter's base position is at the origin 0.

    //           FRONT
    //             | 0  <-- azimuth
    //             |
    //    7pi/4 \  |  / pi/4
    //           \ | /
    // LEFT       \|/      RIGHT
    // 3pi/2-------0-------pi/2
    //            /|\
    //           / | \
    //    5pi/4 /  |  \ 3pi/4
    //             |
    //             | pi
    //           BACK


    LEFT_AZIMUTH = 3 * X3DAUDIO_PI / 2;
    RIGHT_AZIMUTH = X3DAUDIO_PI / 2;
    FRONT_LEFT_AZIMUTH = 7 * X3DAUDIO_PI / 4;
    FRONT_RIGHT_AZIMUTH = X3DAUDIO_PI / 4;
    FRONT_CENTER_AZIMUTH = 0.0;
    LOW_FREQUENCY_AZIMUTH = X3DAUDIO_2PI;
    BACK_LEFT_AZIMUTH = 5 * X3DAUDIO_PI / 4;
    BACK_RIGHT_AZIMUTH = 3 * X3DAUDIO_PI / 4;
    BACK_CENTER_AZIMUTH = X3DAUDIO_PI;

    c_channelAzimuths: array [0..9 - 1, 0..8 - 1] of single =
        (
        (* 0 *)   (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (* 1 *)   (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (* 2 *)   (FRONT_LEFT_AZIMUTH, FRONT_RIGHT_AZIMUTH, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (* 2.1 *) (FRONT_LEFT_AZIMUTH, FRONT_RIGHT_AZIMUTH, LOW_FREQUENCY_AZIMUTH, 0.0, 0.0, 0.0, 0.0, 0.0),
        (* 4.0 *) (FRONT_LEFT_AZIMUTH, FRONT_RIGHT_AZIMUTH, BACK_LEFT_AZIMUTH, BACK_RIGHT_AZIMUTH, 0.0, 0.0, 0.0, 0.0),
        (* 4.1 *) (FRONT_LEFT_AZIMUTH, FRONT_RIGHT_AZIMUTH, LOW_FREQUENCY_AZIMUTH, BACK_LEFT_AZIMUTH, BACK_RIGHT_AZIMUTH, 0.0, 0.0, 0.0),
        (* 5.1 *) (FRONT_LEFT_AZIMUTH, FRONT_RIGHT_AZIMUTH, FRONT_CENTER_AZIMUTH, LOW_FREQUENCY_AZIMUTH, BACK_LEFT_AZIMUTH, BACK_RIGHT_AZIMUTH, 0.0, 0.0),
        (* 6.1 *) (FRONT_LEFT_AZIMUTH, FRONT_RIGHT_AZIMUTH, FRONT_CENTER_AZIMUTH, LOW_FREQUENCY_AZIMUTH, BACK_LEFT_AZIMUTH, BACK_RIGHT_AZIMUTH, BACK_CENTER_AZIMUTH, 0.0),
        (* 7.1 *) (FRONT_LEFT_AZIMUTH, FRONT_RIGHT_AZIMUTH, FRONT_CENTER_AZIMUTH, LOW_FREQUENCY_AZIMUTH, BACK_LEFT_AZIMUTH, BACK_RIGHT_AZIMUTH, LEFT_AZIMUTH, RIGHT_AZIMUTH));


    // **Note these match the defaults from xact3d3.h in the legacy DirectX SDK**
    c_defaultCurvePoints: array [0..1] of TX3DAUDIO_DISTANCE_CURVE_POINT = ((Distance: 0.0; DSPSetting: 1.0), (Distance: 1.0; DSPSetting: 1.0));
    c_defaultCurve: TX3DAUDIO_DISTANCE_CURVE = (pPoints: @c_defaultCurvePoints; PointCount: 2);

    // **Note these match X3DAudioDefault_LinearCurvePoints from x3daudio.h**
    c_linearCurvePoints: array [0..1] of TX3DAUDIO_DISTANCE_CURVE_POINT = ((Distance: 0.0; DSPSetting: 1.0), (Distance: 1.0; DSPSetting: 0.0));
    c_linearCurve: TX3DAUDIO_DISTANCE_CURVE = (pPoints: @c_linearCurvePoints; PointCount: 2);


type
    TWaveBankSeekData = record
        seekCount: uint32;
        seekTable: Puint32;
        tag: uint32;
    end;
    PWaveBankSeekData = ^TWaveBankSeekData;


function GetFormatTag(wfx: PWAVEFORMATEX): uint32;

// Helper for validating wave format structure
function IsValid({_In_} wfx: PWAVEFORMATEX): boolean;


// Helper for getting a default channel mask from channels
function GetDefaultChannelMask(channels: longint): uint32;


// Helpers for creating various wave format structures
procedure CreateIntegerPCM({_Out_} wfx: PWAVEFORMATEX; sampleRate, channels, sampleBits: longint);
procedure CreateFloatPCM({_Out_} wfx: PWAVEFORMATEX; sampleRate, channels: longint);
procedure CreateADPCM({_Out_writes_bytes_(wfxSize)}  wfx: PWAVEFORMATEX; wfxSize: size_t; sampleRate, channels, samplesPerBlock: longint);
{$IFDEF DIRECTX_ENABLE_XWMA}
procedure CreateXWMA({_Out_} wfx: PWAVEFORMATEX; sampleRate, channels, blockAlign, avgBytes: longint; wma3: boolean);
{$ENDIF}
{$IFDEF DIRECTX_ENABLE_XMA2}
procedure CreateXMA2({_Out_writes_bytes_(wfxSize)}  wfx: PWAVEFORMATEX; wfxSize: size_t; sampleRate, channels, bytesPerBlock, blockCount, samplesEncoded: longint);
{$ENDIF}


// Helper for computing pan volume matrix
function ComputePan(pan: single; channels: longint; {_Out_writes_(16)}  matrix: Psingle): boolean;


//======================================================================================
// AudioListener/Emitter helpers
//======================================================================================

implementation

uses
    Math;



function ChannelsSpecifiedInMask(x: longword): word;
var
    bitCount: word;
begin
    bitCount := 0;
    while (x <> 0) do
    begin
        Inc(bitCount);
        x := x and (x - 1);
    end;
    Result := bitCount;
end;

// Helper for getting a format tag from a WAVEFORMATEX

function GetFormatTag(wfx: PWAVEFORMATEX): uint32; inline;
var
    wfex: PWAVEFORMATEXTENSIBLE;
begin
    Result := 0;
    if (wfx^.wFormatTag = WAVE_FORMAT_EXTENSIBLE) then
    begin
        if (wfx^.cbSize < (sizeof(TWAVEFORMATEXTENSIBLE) - sizeof(TWAVEFORMATEX))) then
            Exit;


        wfex := PWAVEFORMATEXTENSIBLE(wfx);

        if (wfex^.Samples.SubFormat.Data2 = s_wfexBase.Data2) and (wfex^.Samples.SubFormat.Data3 = s_wfexBase.Data3) and (wfex^.Samples.SubFormat.Data4[0] = s_wfexBase.Data4[0]) and
            (wfex^.Samples.SubFormat.Data4[1] = s_wfexBase.Data4[1]) and (wfex^.Samples.SubFormat.Data4[2] = s_wfexBase.Data4[2]) and (wfex^.Samples.SubFormat.Data4[3] = s_wfexBase.Data4[3]) and
            (wfex^.Samples.SubFormat.Data4[4] = s_wfexBase.Data4[4]) and (wfex^.Samples.SubFormat.Data4[5] = s_wfexBase.Data4[5]) and (wfex^.Samples.SubFormat.Data4[6] = s_wfexBase.Data4[6]) and
            (wfex^.Samples.SubFormat.Data4[7] = s_wfexBase.Data4[7]) then

        begin
            Exit;
        end;

        Result := wfex^.SubFormat.Data1;
    end
    else
    begin
        Result := wfx^.wFormatTag;
    end;
end;


//======================================================================================
// Wave format utilities
//======================================================================================

function IsValid({_In_}  wfx: PWAVEFORMATEX): boolean;
var
    wfadpcm: PADPCMWAVEFORMAT;
    valid: boolean = True;
    j: size_t;
    nHeaderBytes, nBitsPerFrame, nPcmFramesPerBlock: integer;

    wfex: PWAVEFORMATEXTENSIBLE;
    channelBits: integer;
    {$IFDEF DIRECTX_ENABLE_XMA2}
    xmaFmt: PXMA2WAVEFORMATEX;
    {$ENDIF}
begin
    Result := False;
    if (wfx = nil) then
        Exit;

    if (wfx^.nChannels = 0) then
    begin
        // DebugTrace("ERROR: Wave format must have at least 1 channel\n");
        Exit;
    end;

    if (wfx^.nChannels > XAUDIO2_MAX_AUDIO_CHANNELS) then
    begin
        //  DebugTrace("ERROR: Wave format must have less than %u channels (%u)\n", XAUDIO2_MAX_AUDIO_CHANNELS, wfx.nChannels);
        Exit;
    end;

    if (wfx^.nSamplesPerSec = 0) then
    begin
        // DebugTrace("ERROR: Wave format cannot have a sample rate of 0\n");
        Exit;
    end;

    if ((wfx^.nSamplesPerSec < XAUDIO2_MIN_SAMPLE_RATE) or (wfx^.nSamplesPerSec > XAUDIO2_MAX_SAMPLE_RATE)) then
    begin
        // DebugTrace("ERROR: Wave format channel count must be in range %u..%u (%u)\n",
        //     XAUDIO2_MIN_SAMPLE_RATE, XAUDIO2_MAX_SAMPLE_RATE, wfx.nSamplesPerSec);
        Exit;
    end;

    case (wfx^.wFormatTag) of

        WAVE_FORMAT_PCM:
        begin
            case (wfx^.wBitsPerSample) of

                8, 16, 24, 32:
                begin
                end;

                else
                    //  DebugTrace("ERROR: Wave format integer PCM must have 8, 16, 24, or 32 bits per sample (%u)\n", wfx.wBitsPerSample);
                    Exit;
            end;

            if (wfx^.nBlockAlign <> (wfx^.nChannels * wfx^.wBitsPerSample / 8)) then
            begin
                //  DebugTrace("ERROR: Wave format integer PCM - nBlockAlign (%u) <> nChannels (%u) * wBitsPerSample (%u) / 8\n",
                //      wfx.nBlockAlign, wfx.nChannels, wfx.wBitsPerSample);
                Exit;
            end;

            if (wfx^.nAvgBytesPerSec <> (wfx^.nSamplesPerSec * wfx^.nBlockAlign)) then
            begin
                // DebugTrace("ERROR: Wave format integer PCM - nAvgBytesPerSec (%lu) <> nSamplesPerSec (%lu) * nBlockAlign (%u)\n",
                //     wfx.nAvgBytesPerSec, wfx.nSamplesPerSec, wfx.nBlockAlign);
                Exit;
            end;

            Result := True;
            Exit;
        end;
        WAVE_FORMAT_IEEE_FLOAT:
        begin
            if (wfx^.wBitsPerSample <> 32) then
            begin
                //  DebugTrace("ERROR: Wave format float PCM must have 32-bits per sample (%u)\n", wfx.wBitsPerSample);
                Exit;
            end;

            if (wfx^.nBlockAlign <> (wfx^.nChannels * wfx^.wBitsPerSample / 8)) then
            begin
                // DebugTrace("ERROR: Wave format float PCM - nBlockAlign (%u) <> nChannels (%u) * wBitsPerSample (%u) / 8\n",
                //     wfx.nBlockAlign, wfx.nChannels, wfx.wBitsPerSample);
                Exit;
            end;

            if (wfx^.nAvgBytesPerSec <> (wfx^.nSamplesPerSec * wfx^.nBlockAlign)) then
            begin
                //  DebugTrace("ERROR: Wave format float PCM - nAvgBytesPerSec (%lu) <> nSamplesPerSec (%lu) * nBlockAlign (%u)\n",
                //       wfx.nAvgBytesPerSec, wfx.nSamplesPerSec, wfx.nBlockAlign);
                Exit;
            end;

            Result := True;
            Exit;
        end;

        WAVE_FORMAT_ADPCM:
        begin
            if ((wfx^.nChannels <> 1) and (wfx^.nChannels <> 2)) then
            begin
                // DebugTrace("ERROR: Wave format ADPCM must have 1 or 2 channels (%u)\n", wfx.nChannels);
                Exit;
            end;

            if (wfx^.wBitsPerSample <> MSADPCM_BITS_PER_SAMPLE) then
            begin
                //  DebugTrace("ERROR: Wave format ADPCM must have 4 bits per sample (%u)\n", wfx.wBitsPerSample);
                Exit;
            end;

            if (wfx^.cbSize <> MSADPCM_FORMAT_EXTRA_BYTES) then
            begin
                //   DebugTrace("ERROR: Wave format ADPCM must have cbSize = 32 (%u)\n", wfx.cbSize);
                Exit;
            end
            else
            begin

                wfadpcm := PADPCMWAVEFORMAT(wfx);

                if (wfadpcm^.wNumCoef <> MSADPCM_NUM_COEFFICIENTS) then
                begin
                    // DebugTrace("ERROR: Wave format ADPCM must have 7 coefficients (%u)\n", wfadpcm.wNumCoef);
                    Exit;
                end;


                for  j := 0 to MSADPCM_NUM_COEFFICIENTS - 1 do
                begin

                    if ((wfadpcm^.aCoef[j].iCoef1 <> g_pAdpcmCoefficients1[j]) or (wfadpcm^.aCoef[j].iCoef2 <> g_pAdpcmCoefficients2[j])) then
                    begin
                        valid := False;
                    end;
                end;

                if (not valid) then
                begin
                    //  DebugTrace("ERROR: Wave formt ADPCM found non-standard coefficients\n");
                    Exit;
                end;

                if ((wfadpcm^.wSamplesPerBlock < MSADPCM_MIN_SAMPLES_PER_BLOCK) or (wfadpcm^.wSamplesPerBlock > MSADPCM_MAX_SAMPLES_PER_BLOCK)) then
                begin
                    //  DebugTrace("ERROR: Wave format ADPCM wSamplesPerBlock must be 4..64000 (%u)\n", wfadpcm.wSamplesPerBlock);
                    Exit;
                end;

                if (wfadpcm^.wfx.nChannels = 1) and ((wfadpcm^.wSamplesPerBlock mod 2) <> 0) then
                begin
                    //  DebugTrace("ERROR: Wave format ADPCM mono files must have even wSamplesPerBlock\n");
                    Exit;
                end;


                nHeaderBytes := MSADPCM_HEADER_LENGTH * wfx^.nChannels;
                nBitsPerFrame := MSADPCM_BITS_PER_SAMPLE * wfx^.nChannels;
                nPcmFramesPerBlock := (wfx^.nBlockAlign - nHeaderBytes) * 8 div nBitsPerFrame + 2;

                if (wfadpcm^.wSamplesPerBlock <> nPcmFramesPerBlock) then
                begin
                    //   DebugTrace("ERROR: Wave format ADPCM %u-channel with nBlockAlign = %u must have wSamplesPerBlock = %d (%u)\n",
                    //       wfx.nChannels, wfx.nBlockAlign, nPcmFramesPerBlock, wfadpcm.wSamplesPerBlock);
                    Exit;
                end;
            end;
            Result := True;
            Exit;
        end;

        WAVE_FORMAT_WMAUDIO2, WAVE_FORMAT_WMAUDIO3:
        begin
            {$ifdef DIRECTX_ENABLE_XWMA}

            if (wfx^.wBitsPerSample <> 16) then
            begin
                // DebugTrace("ERROR: Wave format xWMA only supports 16-bit data\n");
                Exit;
            end;

            if (wfx^.nBlockAlign = 0) then
            begin
                //  DebugTrace("ERROR: Wave format xWMA must have a non-zero nBlockAlign\n");
                Exit;
            end;

            if (wfx^.nAvgBytesPerSec = 0) then
            begin
                //  DebugTrace("ERROR: Wave format xWMA must have a non-zero nAvgBytesPerSec\n");
                Exit;
            end;

            Result := True;

            {$else}
            //  DebugTrace("ERROR: Wave format xWMA not supported by this version of DirectXTK for Audio\n");

            {$endif}
            exit;
        end;

        $166: (* WAVE_FORMAT_XMA2 *)
        begin

            {$ifdef DIRECTX_ENABLE_XMA2}

        assert(WAVE_FORMAT_XMA2 = $166, 'Unrecognized XMA2 tag');

        if (wfx.nBlockAlign <> wfx.nChannels * XMA_OUTPUT_SAMPLE_BYTES) then
        begin
          //  DebugTrace("ERROR: Wave format XMA2 - nBlockAlign (%u) <> nChannels(%u) * %u\n", wfx.nBlockAlign, wfx.nChannels, XMA_OUTPUT_SAMPLE_BYTES);
            Exit;
        end;

        if (wfx.wBitsPerSample <> XMA_OUTPUT_SAMPLE_BITS) then
        begin
          //  DebugTrace("ERROR: Wave format XMA2 wBitsPerSample (%u) should be %u\n", wfx.wBitsPerSample, XMA_OUTPUT_SAMPLE_BITS);
            Exit;
        end;

        if (wfx.cbSize <> (sizeof(XMA2WAVEFORMATEX) - sizeof(WAVEFORMATEX))) then
        begin
           // DebugTrace("ERROR: Wave format XMA2 - cbSize must be %zu (%u)\n", (sizeof(XMA2WAVEFORMATEX) - sizeof(WAVEFORMATEX)), wfx.cbSize);
             Exit;
        end
        else
        begin

             xmaFmt := PXMA2WAVEFORMATEX(wfx);

            if (xmaFmt.EncoderVersion < 3)  then
            begin
                DebugTrace("ERROR: Wave format XMA2 encoder version (%u) - 3 or higher is required\n", xmaFmt.EncoderVersion);
                return false;
            end;

            if (!xmaFmt.BlockCount)
            begin
                DebugTrace("ERROR: Wave format XMA2 BlockCount must be non-zero\n");
                return false;
            end;

            if (!xmaFmt.BytesPerBlock  OR  (xmaFmt.BytesPerBlock > XMA_READBUFFER_MAX_BYTES))
            begin
                DebugTrace("ERROR: Wave format XMA2 BytesPerBlock (%u) is invalid\n", xmaFmt.BytesPerBlock);
                return false;
            end;

            if (xmaFmt.ChannelMask)
            begin
                auto channelBits = ChannelsSpecifiedInMask(xmaFmt.ChannelMask);
                if (channelBits <> wfx.nChannels)
                begin
                    DebugTrace("ERROR: Wave format XMA2 - nChannels=%u but ChannelMask (%08X) has %u bits set\n",
                        xmaFmt.ChannelMask, wfx.nChannels, channelBits);
                    return false;
                end;
            end;

            if (xmaFmt.NumStreams <> ((wfx.nChannels + 1) / 2))
            begin
                DebugTrace("ERROR: Wave format XMA2 - NumStreams (%u) <> ( nChannels(%u) + 1 ) / 2\n",
                    xmaFmt.NumStreams, wfx.nChannels);
                return false;
            end;

            if ((xmaFmt.PlayBegin + xmaFmt.PlayLength) > xmaFmt.SamplesEncoded)
            begin
                DebugTrace("ERROR: Wave format XMA2 play region too large (%u + %u > %u)\n",
                    xmaFmt.PlayBegin, xmaFmt.PlayLength, xmaFmt.SamplesEncoded);
                return false;
            end;

            if ((xmaFmt.LoopBegin + xmaFmt.LoopLength) > xmaFmt.SamplesEncoded)
            begin
                DebugTrace("ERROR: Wave format XMA2 loop region too large (%u + %u > %u)\n",
                    xmaFmt.LoopBegin, xmaFmt.LoopLength, xmaFmt.SamplesEncoded);
                return false;
            end;
        end;
        return true;

            {$else}
            // DebugTrace("ERROR: Wave format XMA2 not supported by this version of DirectXTK for Audio\n");
            exit;
            {$endif}
        end;

        WAVE_FORMAT_EXTENSIBLE:
        begin
            if (wfx^.cbSize < (sizeof(TWAVEFORMATEXTENSIBLE) - sizeof(TWAVEFORMATEX))) then
            begin
                //  DebugTrace("ERROR: Wave format WAVE_FORMAT_EXTENSIBLE - cbSize must be %zu (%u)\n",
                //      (sizeof(WAVEFORMATEXTENSIBLE) - sizeof(WAVEFORMATEX)), wfx.cbSize);
                Exit;
            end
            else
            begin

                wfex := PWAVEFORMATEXTENSIBLE(wfx);

                if (wfex^.Samples.SubFormat.Data2 = s_wfexBase.Data2) and (wfex^.Samples.SubFormat.Data3 = s_wfexBase.Data3) and (wfex^.Samples.SubFormat.Data4[0] = s_wfexBase.Data4[0]) and
                    (wfex^.Samples.SubFormat.Data4[1] = s_wfexBase.Data4[1]) and (wfex^.Samples.SubFormat.Data4[2] = s_wfexBase.Data4[2]) and (wfex^.Samples.SubFormat.Data4[3] = s_wfexBase.Data4[3]) and
                    (wfex^.Samples.SubFormat.Data4[4] = s_wfexBase.Data4[4]) and (wfex^.Samples.SubFormat.Data4[5] = s_wfexBase.Data4[5]) and (wfex^.Samples.SubFormat.Data4[6] = s_wfexBase.Data4[6]) and
                    (wfex^.Samples.SubFormat.Data4[7] = s_wfexBase.Data4[7]) then
                    //            if (memcmp(reinterpret_cast<const BYTE*>(&wfex.SubFormat) + sizeof(DWORD),
                    //                reinterpret_cast<const BYTE*>(&s_wfexBase) + sizeof(DWORD), sizeof(GUID) - sizeof(DWORD)) <> 0) then
                begin
                    //  DebugTrace("ERROR: Wave format WAVEFORMATEXTENSIBLE encountered with unknown GUID ({%8.8lX-%4.4X-%4.4X-%2.2X%2.2X-%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X})\n",
                    //      wfex.SubFormat.Data1, wfex.SubFormat.Data2, wfex.SubFormat.Data3,
                    //     wfex.SubFormat.Data4[0], wfex.SubFormat.Data4[1], wfex.SubFormat.Data4[2], wfex.SubFormat.Data4[3],
                    //    wfex.SubFormat.Data4[4], wfex.SubFormat.Data4[5], wfex.SubFormat.Data4[6], wfex.SubFormat.Data4[7]);
                    Exit;
                end;

                case (wfex^.Samples.SubFormat.Data1) of

                    WAVE_FORMAT_PCM:
                    begin
                        case (wfx^.wBitsPerSample) of

                            8, 16, 24, 32:
                            begin
                            end;

                            else
                                //  DebugTrace("ERROR: Wave format integer PCM must have 8, 16, 24, or 32 bits per sample (%u)\n",
                                //      wfx.wBitsPerSample);
                                Exit;
                        end;

                        case (wfex^.Samples.wValidBitsPerSample) of

                            0, 8, 16, 20, 24, 32:
                            begin
                            end;

                            else
                                //  DebugTrace("ERROR: Wave format integer PCM must have 8, 16, 20, 24, or 32 valid bits per sample (%u)\n",
                                //      wfex.Samples.wValidBitsPerSample);
                                Exit;
                        end;

                        if ((wfex^.Samples.wValidBitsPerSample <> 0) and (wfex^.Samples.wValidBitsPerSample > wfx^.wBitsPerSample)) then
                        begin
                            //  DebugTrace("ERROR: Wave format ingter PCM wValidBitsPerSample (%u) is greater than wBitsPerSample (%u)\n",
                            //      wfex.Samples.wValidBitsPerSample, wfx.wBitsPerSample);
                            Exit;
                        end;

                        if (wfx^.nBlockAlign <> (wfx^.nChannels * wfx^.wBitsPerSample div 8)) then
                        begin
                            // DebugTrace("ERROR: Wave format integer PCM - nBlockAlign (%u) <> nChannels (%u) * wBitsPerSample (%u) / 8\n",
                            //      wfx.nBlockAlign, wfx.nChannels, wfx.wBitsPerSample);
                            Exit;
                        end;

                        if (wfx^.nAvgBytesPerSec <> (wfx^.nSamplesPerSec * wfx^.nBlockAlign)) then
                        begin
                            //   DebugTrace("ERROR: Wave format integer PCM - nAvgBytesPerSec (%lu) <> nSamplesPerSec (%lu) * nBlockAlign (%u)\n",
                            //      wfx.nAvgBytesPerSec, wfx.nSamplesPerSec, wfx.nBlockAlign);
                            Exit;
                        end;

                    end;

                    WAVE_FORMAT_IEEE_FLOAT:
                    begin
                        if (wfx^.wBitsPerSample <> 32) then
                        begin
                            //  DebugTrace("ERROR: Wave format float PCM must have 32-bits per sample (%u)\n", wfx.wBitsPerSample);
                            Exit;
                        end;

                        case (wfex^.Samples.wValidBitsPerSample) of

                            0, 32:
                            begin
                            end;

                            else
                                // DebugTrace("ERROR: Wave format float PCM must have 32 valid bits per sample (%u)\n",
                                //     wfex.Samples.wValidBitsPerSample);
                                Exit;
                        end;

                        if (wfx^.nBlockAlign <> (wfx^.nChannels * wfx^.wBitsPerSample / 8)) then
                        begin
                            //   DebugTrace("ERROR: Wave format float PCM - nBlockAlign (%u) <> nChannels (%u) * wBitsPerSample (%u) / 8\n",
                            //      wfx.nBlockAlign, wfx.nChannels, wfx.wBitsPerSample);
                            Exit;
                        end;

                        if (wfx^.nAvgBytesPerSec <> (wfx^.nSamplesPerSec * wfx^.nBlockAlign)) then
                        begin
                            //   DebugTrace("ERROR: Wave format float PCM - nAvgBytesPerSec (%lu) <> nSamplesPerSec (%lu) * nBlockAlign (%u)\n",
                            //      wfx.nAvgBytesPerSec, wfx.nSamplesPerSec, wfx.nBlockAlign);
                            Exit;
                        end;

                    end;

                    WAVE_FORMAT_ADPCM:
                    begin
                        //DebugTrace("ERROR: Wave format ADPCM is not supported as a WAVEFORMATEXTENSIBLE\n");
                        Exit;
                    end;

                    WAVE_FORMAT_WMAUDIO2, WAVE_FORMAT_WMAUDIO3:
                    begin
                        {$IFDEF  DIRECTX_ENABLE_XWMA}

                        if (wfx^.wBitsPerSample <> 16) then
                        begin
                            //  DebugTrace("ERROR: Wave format xWMA only supports 16-bit data\n");
                            Exit;
                        end;

                        if (wfx^.nBlockAlign = 0) then
                        begin
                            //  DebugTrace("ERROR: Wave format xWMA must have a non-zero nBlockAlign\n");
                            Exit;
                        end;

                        if (wfx^.nAvgBytesPerSec = 0) then
                        begin
                            //  DebugTrace("ERROR: Wave format xWMA must have a non-zero nAvgBytesPerSec\n");
                            Exit;
                        end;

                        {$ELSE}
                        // DebugTrace("ERROR: Wave format xWMA not supported by this version of DirectXTK for Audio\n");
                        Exit;
                        {$ENDIF}
                    end;
                    $166 (* WAVE_FORMAT_XMA2 *):
                    begin
                        // DebugTrace("ERROR: Wave format XMA2 is not supported as a WAVEFORMATEXTENSIBLE\n");
                        Exit;
                    end;
                    else
                    begin
                        // DebugTrace("ERROR: Unknown WAVEFORMATEXTENSIBLE format tag (%u)\n", wfex.SubFormat.Data1);
                        Exit;
                    end;
                end;

                if (wfex^.Samples.dwChannelMask <> 0) then
                begin
                    channelBits := ChannelsSpecifiedInMask(wfex^.Samples.dwChannelMask);
                    if (channelBits <> wfx^.nChannels) then
                    begin
                        // DebugTrace("ERROR: WAVEFORMATEXTENSIBLE: nChannels=%u but ChannelMask has %u bits set\n",
                        //     wfx.nChannels, channelBits);
                        Exit;
                    end;
                end;

                Result := True;
                Exit;
            end;
        end;
        else
            // DebugTrace("ERROR: Unknown WAVEFORMATEX format tag (%u)\n", wfx.wFormatTag);
            Exit;
    end;
end;



function GetDefaultChannelMask(channels: longint): uint32;
begin
    case (channels) of

        1: Result := SPEAKER_MONO;
        2: Result := SPEAKER_STEREO;
        3: Result := SPEAKER_2POINT1;
        4: Result := SPEAKER_QUAD;
        5: Result := SPEAKER_4POINT1;
        6: Result := SPEAKER_5POINT1;
        7: Result := SPEAKER_5POINT1 or SPEAKER_BACK_CENTER;
        8: Result := SPEAKER_7POINT1;
        else
            Result := 0;
    end;
end;



procedure CreateIntegerPCM(wfx: PWAVEFORMATEX; sampleRate, channels, sampleBits: longint);
var
    blockAlign: longint;
begin
    if (wfx = nil) then
        exit;

    blockAlign := channels * sampleBits div 8;

    wfx^.wFormatTag := WAVE_FORMAT_PCM;
    wfx^.nChannels := (channels);
    wfx^.nSamplesPerSec := sampleRate;
    wfx^.nAvgBytesPerSec := (blockAlign * sampleRate);
    wfx^.nBlockAlign := (blockAlign);
    wfx^.wBitsPerSample := (sampleBits);
    wfx^.cbSize := 0;

    {$IFOPT D+}
    assert(IsValid(wfx));
    {$ENDIF}
end;



procedure CreateFloatPCM(wfx: PWAVEFORMATEX; sampleRate, channels: longint);
var
    blockAlign: longint;
begin
    blockAlign := channels * 4;

    wfx^.wFormatTag := WAVE_FORMAT_IEEE_FLOAT;
    wfx^.nChannels := (channels);
    wfx^.nSamplesPerSec := (sampleRate);
    wfx^.nAvgBytesPerSec := (blockAlign * sampleRate);
    wfx^.nBlockAlign := (blockAlign);
    wfx^.wBitsPerSample := 32;
    wfx^.cbSize := 0;
    {$IFOPT D+}
    assert(IsValid(wfx));
    {$ENDIF}
end;



procedure CreateADPCM(wfx: PWAVEFORMATEX; wfxSize: size_t; sampleRate, channels, samplesPerBlock: longint);
var
    blockAlign: longint;
    adpcm: PADPCMWAVEFORMAT;
begin
    if (wfx = nil) then
        Exit;

    if (wfxSize < (sizeof(TWAVEFORMATEX) + MSADPCM_FORMAT_EXTRA_BYTES)) then
    begin
        //DebugTrace("CreateADPCM needs at least %zu bytes for the result\n",
        //    (sizeof(WAVEFORMATEX) + MSADPCM_FORMAT_EXTRA_BYTES));
        raise Exception.Create('ADPCMWAVEFORMAT');
    end;

    if (samplesPerBlock = 0) then
    begin
        //  DebugTrace("CreateADPCM needs a non-zero samples per block count\n");
        raise Exception.Create('ADPCMWAVEFORMAT');
    end;

    blockAlign := MSADPCM_HEADER_LENGTH * channels + (samplesPerBlock - 2) * MSADPCM_BITS_PER_SAMPLE * channels div 8;

    wfx^.wFormatTag := WAVE_FORMAT_ADPCM;
    wfx^.nChannels := (channels);
    wfx^.nSamplesPerSec := (sampleRate);
    wfx^.nAvgBytesPerSec := (blockAlign * sampleRate div samplesPerBlock);
    wfx^.nBlockAlign := (blockAlign);
    wfx^.wBitsPerSample := MSADPCM_BITS_PER_SAMPLE;
    wfx^.cbSize := MSADPCM_FORMAT_EXTRA_BYTES;


    adpcm := PADPCMWAVEFORMAT(wfx);
    adpcm^.wSamplesPerBlock := (samplesPerBlock);
    adpcm^.wNumCoef := MSADPCM_NUM_COEFFICIENTS;


    //   memcpy(&adpcm.aCoef, aCoef, sizeof(aCoef)); // CodeQL [SM01947] Code scanner doesn't understand the 0-length MSVC array extension. MSADPCM_FORMAT_EXTRA_BYTES includes this memory.
    adpcm^.aCoef := @aCoef[0];
    {$IFOPT D+}
    assert(IsValid(wfx));
    {$ENDIF}
end;



procedure CreateXWMA(wfx: PWAVEFORMATEX; sampleRate, channels, blockAlign, avgBytes: longint; wma3: boolean);
begin
    if (wfx = nil) then
        Exit;

    if (wma3) then
        wfx^.wFormatTag := WAVE_FORMAT_WMAUDIO3
    else
        wfx^.wFormatTag := WAVE_FORMAT_WMAUDIO2;
    wfx^.nChannels := (channels);
    wfx^.nSamplesPerSec := (sampleRate);
    wfx^.nAvgBytesPerSec := (avgBytes);
    wfx^.nBlockAlign := (blockAlign);
    wfx^.wBitsPerSample := 16;
    wfx^.cbSize := 0;

    {$IFOPT D+}
    assert(IsValid(wfx));
    {$ENDIF}
end;


{$IFDEF DIRECTX_ENABLE_XMA2}
procedure CreateXMA2(wfx: PWAVEFORMATEX; wfxSize: size_t; sampleRate, channels, bytesPerBlock, blockCount, samplesEncoded: longint);
var
    blockAlign: longint;
    xmaFmt: PXMA2WAVEFORMATEX;
begin
    if (wfxSize < sizeof(TXMA2WAVEFORMATEX)) then
    begin
        // DebugTrace("XMA2 needs at least %zu bytes for the result\n", sizeof(XMA2WAVEFORMATEX));
        raise Exception.Create('XMA2WAVEFORMATEX');
    end;

    if ((bytesPerBlock < 1) or (bytesPerBlock > int(XMA_READBUFFER_MAX_BYTES))) then
    begin
        // DebugTrace("XMA2 needs a valid bytes per block\n");
        raise Exception.Create('XMA2WAVEFORMATEX');
    end;

    blockAlign := ((channels) * XMA_OUTPUT_SAMPLE_BITS) div 8;

    wfx^.wFormatTag := WAVE_FORMAT_XMA2;
    wfx^.nChannels := (channels);
    wfx^.nSamplesPerSec := (sampleRate);
    wfx^.nAvgBytesPerSec := (blockAlign * sampleRate);
    wfx^.nBlockAlign := (blockAlign);
    wfx^.wBitsPerSample := XMA_OUTPUT_SAMPLE_BITS;
    wfx^.cbSize := sizeof(TXMA2WAVEFORMATEX) - sizeof(TWAVEFORMATEX);

    xmaFmt := PXMA2WAVEFORMATEX(wfx);

    xmaFmt^.NumStreams := ((channels + 1) div 2);

    xmaFmt^.ChannelMask := GetDefaultChannelMask(channels);

    xmaFmt^.SamplesEncoded := (samplesEncoded);
    xmaFmt^.BytesPerBlock := (bytesPerBlock);
    xmaFmt^.PlayBegin := 0;
    xmaFmt^.PlayLength := 0;
    xmaFmt^.LoopBegin := 0;
    xmaFmt^.LoopLength := 0;
    xmaFmt^.LoopCount := 0;
    xmaFmt^.EncoderVersion := 4 (* XMAENCODER_VERSION_XMA2 *);
    xmaFmt^.BlockCount := (blockCount);
    {$IFOPT D+}
    assert(IsValid(wfx));
    {$ENDIF}
end;
{$ENDIF}



function ComputePan(pan: single; channels: longint; matrix: Psingle): boolean;
var
    left, right: single;
begin
    Result := False;
    FillByte(matrix^, sizeof(float) * 16, 0);

    if (channels = 1) then
    begin
        // Mono panning
        left := 1.0 - pan;
        left := min(1.0, left);
        left := max(0.0, left);

        right := pan + 1.0;
        right := min(1.0, right);
        right := max(0.0, right);

        matrix[0] := left;
        matrix[1] := right;
    end
    else if (channels = 2) then
    begin
        // Stereo panning
        if (-1.0 <= pan) and (pan <= 0.0) then
        begin
            matrix[0] := 0.5 * pan + 1.0;    // .5 when pan is -1, 1 when pan is 0
            matrix[1] := 0.5 * -pan;         // .5 when pan is -1, 0 when pan is 0
            matrix[2] := 0.0;                //  0 when pan is -1, 0 when pan is 0
            matrix[3] := pan + 1.0;          //  0 when pan is -1, 1 when pan is 0
        end
        else
        begin
            matrix[0] := -pan + 1.0;         //  1 when pan is 0,   0 when pan is 1
            matrix[1] := 0.0;                //  0 when pan is 0,   0 when pan is 1
            matrix[2] := 0.5 * pan;          //  0 when pan is 0, .5f when pan is 1
            matrix[3] := 0.5 * -pan + 1.0;   //  1 when pan is 0. .5f when pan is 1
        end;
    end
    else
    begin
        if (pan <> 0.0) then
        begin
            // DebugTrace("WARNING: Only supports panning on mono or stereo source data, ignored\n");
        end;
        Exit;
    end;

    Result := True;
end;


//======================================================================================
// AudioListener/Emitter helpers
//======================================================================================
function IsValid(curve: PX3DAUDIO_DISTANCE_CURVE): boolean; inline;
var
    j: uint32;
begin
    Result := False;
    // These match the validation ranges in X3DAudio.
    if (curve^.pPoints = nil) then
        Exit;

    if (curve^.PointCount < 2) then
        Exit;


    if (curve^.pPoints[0].Distance <> 0.0) then
        Exit;


    if (curve^.pPoints[curve^.PointCount - 1].Distance <> 1.0) then
        Exit;


    for  j := 0 to curve^.PointCount - 1 do
    begin
        if (curve^.pPoints[j].Distance < 0.0) or (curve^.pPoints[j].Distance > 1.0) then
            Exit;


        if (IsInfinite(curve^.pPoints[j].DSPSetting)) then
            Exit;

    end;

    Result := True;
end;

end.
