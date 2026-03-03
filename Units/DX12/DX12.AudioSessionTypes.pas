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

   Copyright Microsoft Corporation, All Rights Reserved.
   Description: Type definitions used by the audio session manager RPC/COM interfaces

   This unit consists of the following header files
   File name: AudioSessionTypes.h

   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.AudioSessionTypes;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils;

    {$Z4}

const


    //-------------------------------------------------------------------------
    // Description: AudioClient stream flags

    // Can be a combination of AUDCLNT_STREAMFLAGS and AUDCLNT_SYSFXFLAGS:

    // AUDCLNT_STREAMFLAGS (this group of flags uses the high word,
    // w/exception of high-bit which is reserved, 0x7FFF0000):


    //     AUDCLNT_STREAMFLAGS_CROSSPROCESS -             Audio policy control for this stream will be shared with
    //                                                    with other process sessions that use the same audio session
    //                                                    GUID.

    //     AUDCLNT_STREAMFLAGS_LOOPBACK -                 Initializes a renderer endpoint for a loopback audio application.
    //                                                    In this mode, a capture stream will be opened on the specified
    //                                                    renderer endpoint. Shared mode and a renderer endpoint is required.
    //                                                    Otherwise the IAudioClient::Initialize call will fail. If the
    //                                                    initialize is successful, a capture stream will be available
    //                                                    from the IAudioClient object.

    //     AUDCLNT_STREAMFLAGS_EVENTCALLBACK -            An exclusive mode client will supply an event handle that will be
    //                                                    signaled when an IRP completes (or a waveRT buffer completes) telling
    //                                                    it to fill the next buffer

    //     AUDCLNT_STREAMFLAGS_NOPERSIST -                Session state will not be persisted

    //     AUDCLNT_STREAMFLAGS_RATEADJUST -               The sample rate of the stream is adjusted to a rate specified by an application.

    //     AUDCLNT_STREAMFLAGS_SRC_DEFAULT_QUALITY -      When used with AUDCLNT_STREAMFLAGS_AUTOCONVERTPCM, a sample rate
    //                                                    converter with better quality than the default conversion but with a
    //                                                    higher performance cost is used. This should be used if the audio is
    //                                                    ultimately intended to be heard by humans as opposed to other
    //                                                    scenarios such as pumping silence or populating a meter.

    //     AUDCLNT_STREAMFLAGS_AUTOCONVERTPCM -           A channel matrixer and a sample rate converter are inserted as necessary
    //                                                    to convert between the uncompressed format supplied to
    //                                                    IAudioClient::Initialize and the audio engine mix format.

    //     AUDCLNT_SESSIONFLAGS_EXPIREWHENUNOWNED -       Session expires when there are no streams and no owning
    //                                                    session controls.

    //     AUDCLNT_SESSIONFLAGS_DISPLAY_HIDE -            Don't show volume control in the Volume Mixer.

    //     AUDCLNT_SESSIONFLAGS_DISPLAY_HIDEWHENEXPIRED - Don't show volume control in the Volume Mixer after the
    //                                                    session expires.


    // AUDCLNT_SYSFXFLAGS (these flags use low word 0x0000FFFF):

    //     none defined currently

    AUDCLNT_STREAMFLAGS_CROSSPROCESS = $00010000;
    AUDCLNT_STREAMFLAGS_LOOPBACK = $00020000;
    AUDCLNT_STREAMFLAGS_EVENTCALLBACK = $00040000;
    AUDCLNT_STREAMFLAGS_NOPERSIST = $00080000;
    AUDCLNT_STREAMFLAGS_RATEADJUST = $00100000;
    AUDCLNT_STREAMFLAGS_SRC_DEFAULT_QUALITY = $08000000;
    AUDCLNT_STREAMFLAGS_AUTOCONVERTPCM = $80000000;
    AUDCLNT_SESSIONFLAGS_EXPIREWHENUNOWNED = $10000000;
    AUDCLNT_SESSIONFLAGS_DISPLAY_HIDE = $20000000;
    AUDCLNT_SESSIONFLAGS_DISPLAY_HIDEWHENEXPIRED = $40000000;

type

    //-------------------------------------------------------------------------
    // Description: AudioClient share mode

    //     AUDCLNT_SHAREMODE_SHARED -    The device will be opened in shared mode and use the
    //                                   WAS format.
    //     AUDCLNT_SHAREMODE_EXCLUSIVE - The device will be opened in exclusive mode and use the
    //                                   application specified format.

    T_AUDCLNT_SHAREMODE = (
        AUDCLNT_SHAREMODE_SHARED,
        AUDCLNT_SHAREMODE_EXCLUSIVE);

    TAUDCLNT_SHAREMODE = T_AUDCLNT_SHAREMODE;
    PAUDCLNT_SHAREMODE = ^TAUDCLNT_SHAREMODE;

    P_AUDCLNT_SHAREMODE = ^T_AUDCLNT_SHAREMODE;


    //-------------------------------------------------------------------------
    // Description: Audio stream categories

    // ForegroundOnlyMedia     - (deprecated for Win10) Music, Streaming audio
    // BackgroundCapableMedia  - (deprecated for Win10) Video with audio
    // Communications          - VOIP, chat, phone call
    // Alerts                  - Alarm, Ring tones
    // SoundEffects            - Sound effects, clicks, dings
    // GameEffects             - Game sound effects
    // GameMedia               - Background audio for games
    // GameChat                - In game player chat
    // Speech                  - Speech recognition
    // Media                   - Music, Streaming audio
    // Movie                   - Video with audio
    // FarFieldSpeech          - Capture of far field speech
    // UniformSpeech           - Uniform, device agnostic speech processing
    // VoiceTyping             - Dictation, typing by voice
    // Other                   - All other streams (default)

    T_AUDIO_STREAM_CATEGORY = (
        AudioCategory_Other = 0,
        AudioCategory_ForegroundOnlyMedia = 1,
        AudioCategory_BackgroundCapableMedia = 2,
        AudioCategory_Communications = 3,
        AudioCategory_Alerts = 4,
        AudioCategory_SoundEffects = 5,
        AudioCategory_GameEffects = 6,
        AudioCategory_GameMedia = 7,
        AudioCategory_GameChat = 8,
        AudioCategory_Speech = 9,
        AudioCategory_Movie = 10,
        AudioCategory_Media = 11,

        AudioCategory_FarFieldSpeech = 12,
        AudioCategory_UniformSpeech = 13,
        AudioCategory_VoiceTyping = 14


        );

    P_AUDIO_STREAM_CATEGORY = ^T_AUDIO_STREAM_CATEGORY;
    TAUDIO_STREAM_CATEGORY = T_AUDIO_STREAM_CATEGORY;
    PTAUDIO_STREAM_CATEGORY = ^TAUDIO_STREAM_CATEGORY;


    //-------------------------------------------------------------------------
    // Description: AudioSession State.

    //      AudioSessionStateInactive - The session has no active audio streams.
    //      AudioSessionStateActive - The session has active audio streams.
    //      AudioSessionStateExpired - The session is dormant.
    T_AudioSessionState = (
        AudioSessionStateInactive = 0,
        AudioSessionStateActive = 1,
        AudioSessionStateExpired = 2);

    P_AudioSessionState = ^T_AudioSessionState;
    TAudioSessionState = T_AudioSessionState;
    PAudioSessionState = ^TAudioSessionState;


implementation

end.
