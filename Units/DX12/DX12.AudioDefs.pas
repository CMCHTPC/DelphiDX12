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
   Licensed under the MIT license

   This unit consists of the following header files
   File name:  audiodefs.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.AudioDefs;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils;

    {$Z4}

(***************************************************************************
 *  Content:  Basic constants and data types for audio work.
 *
 *  Remarks:  This header file defines all of the audio format constants and
 *            structures required for XAudio2 and XACT work.  Providing these
 *            in a single location avoids certain dependency problems in the
 *            legacy audio headers (mmreg.h, mmsystem.h, ksmedia.h).
 *
 *            NOTE: Including the legacy headers after this one may cause a
 *            compilation error, because they define some of the same types
 *            defined here without preprocessor guards to avoid multiple
 *            definitions.  If a source file needs one of the old headers,
 *            it must include it before including audiodefs.h.
 *
 ***************************************************************************)


const
    WAVE_FORMAT_PCM = $0001;
    WAVE_FORMAT_ADPCM = $0002;

    // Other frequently used format tags


    WAVE_FORMAT_UNKNOWN = $0000; // Unknown or invalid format tag


    WAVE_FORMAT_IEEE_FLOAT = $0003; // 32-bit floating-point


    WAVE_FORMAT_MPEGLAYER3 = $0055; // ISO/MPEG Layer3


    WAVE_FORMAT_DOLBY_AC3_SPDIF = $0092; // Dolby Audio Codec 3 over S/PDIF


    WAVE_FORMAT_WMAUDIO2 = $0161; // Windows Media Audio


    WAVE_FORMAT_WMAUDIO3 = $0162; // Windows Media Audio Pro


    WAVE_FORMAT_WMASPDIF = $0164; // Windows Media Audio over S/PDIF


    WAVE_FORMAT_EXTENSIBLE = $FFFE; // All WAVEFORMATEXTENSIBLE formats


    (**************************************************************************
 *
 *  Define the most common wave format GUIDs used in WAVEFORMATEXTENSIBLE
 *  formats.  Note that including the Windows ksmedia.h header after this
 *  one will cause build problems; this cannot be avoided, since ksmedia.h
 *  defines these macros without preprocessor guards.
 *
 ***************************************************************************)
    KSDATAFORMAT_SUBTYPE_PCM: TGUID = '{00000001-0000-0010-8000-00aa00389b71}';
    KSDATAFORMAT_SUBTYPE_ADPCM: TGUID = '{00000002-0000-0010-8000-00aa00389b71}';
    KSDATAFORMAT_SUBTYPE_IEEE_FLOAT: TGUID = '{00000003-0000-0010-8000-00aa00389b71}';


(**************************************************************************
 *
 *  Speaker positions used in the WAVEFORMATEXTENSIBLE dwChannelMask field.
 *
 ***************************************************************************)


    SPEAKER_FRONT_LEFT = $00000001;
    SPEAKER_FRONT_RIGHT = $00000002;
    SPEAKER_FRONT_CENTER = $00000004;
    SPEAKER_LOW_FREQUENCY = $00000008;
    SPEAKER_BACK_LEFT = $00000010;
    SPEAKER_BACK_RIGHT = $00000020;
    SPEAKER_FRONT_LEFT_OF_CENTER = $00000040;
    SPEAKER_FRONT_RIGHT_OF_CENTER = $00000080;
    SPEAKER_BACK_CENTER = $00000100;
    SPEAKER_SIDE_LEFT = $00000200;
    SPEAKER_SIDE_RIGHT = $00000400;
    SPEAKER_TOP_CENTER = $00000800;
    SPEAKER_TOP_FRONT_LEFT = $00001000;
    SPEAKER_TOP_FRONT_CENTER = $00002000;
    SPEAKER_TOP_FRONT_RIGHT = $00004000;
    SPEAKER_TOP_BACK_LEFT = $00008000;
    SPEAKER_TOP_BACK_CENTER = $00010000;
    SPEAKER_TOP_BACK_RIGHT = $00020000;
    SPEAKER_RESERVED = $7FFC0000;
    SPEAKER_ALL = $80000000;

    SPEAKER_MONO = (SPEAKER_FRONT_CENTER);
    SPEAKER_STEREO = (SPEAKER_FRONT_LEFT or SPEAKER_FRONT_RIGHT);
    SPEAKER_2POINT1 = (SPEAKER_FRONT_LEFT or SPEAKER_FRONT_RIGHT or SPEAKER_LOW_FREQUENCY);
    SPEAKER_SURROUND = (SPEAKER_FRONT_LEFT or SPEAKER_FRONT_RIGHT or SPEAKER_FRONT_CENTER or SPEAKER_BACK_CENTER);
    SPEAKER_QUAD = (SPEAKER_FRONT_LEFT or SPEAKER_FRONT_RIGHT or SPEAKER_BACK_LEFT or SPEAKER_BACK_RIGHT);
    SPEAKER_4POINT1 = (SPEAKER_FRONT_LEFT or SPEAKER_FRONT_RIGHT or SPEAKER_LOW_FREQUENCY or SPEAKER_BACK_LEFT or SPEAKER_BACK_RIGHT);
    SPEAKER_5POINT1 = (SPEAKER_FRONT_LEFT or SPEAKER_FRONT_RIGHT or SPEAKER_FRONT_CENTER or SPEAKER_LOW_FREQUENCY or SPEAKER_BACK_LEFT or SPEAKER_BACK_RIGHT);
    SPEAKER_7POINT1 = (SPEAKER_FRONT_LEFT or SPEAKER_FRONT_RIGHT or SPEAKER_FRONT_CENTER or SPEAKER_LOW_FREQUENCY or SPEAKER_BACK_LEFT or SPEAKER_BACK_RIGHT or SPEAKER_FRONT_LEFT_OF_CENTER or SPEAKER_FRONT_RIGHT_OF_CENTER);
    SPEAKER_5POINT1_SURROUND = (SPEAKER_FRONT_LEFT or SPEAKER_FRONT_RIGHT or SPEAKER_FRONT_CENTER or SPEAKER_LOW_FREQUENCY or SPEAKER_SIDE_LEFT or SPEAKER_SIDE_RIGHT);
    SPEAKER_7POINT1_SURROUND = (SPEAKER_FRONT_LEFT or SPEAKER_FRONT_RIGHT or SPEAKER_FRONT_CENTER or SPEAKER_LOW_FREQUENCY or SPEAKER_BACK_LEFT or SPEAKER_BACK_RIGHT or SPEAKER_SIDE_LEFT or SPEAKER_SIDE_RIGHT);


type


(**************************************************************************
 *
 *  WAVEFORMATEX: Base structure for many audio formats.  Format-specific
 *  extensions can be defined for particular formats by using a non-zero
 *  cbSize value and adding extra fields to the end of this structure.
 *
 ***************************************************************************)


    TWAVEFORMATEX = packed record
        wFormatTag: word; // Integer identifier of the format
        nChannels: word; // Number of audio channels
        nSamplesPerSec: DWORD; // Audio sample rate
        nAvgBytesPerSec: DWORD; // Bytes per second (possibly approximate)
        nBlockAlign: word; // Size in bytes of a sample block (all channels)
        wBitsPerSample: word; // Size in bits of a single per-channel sample
        cbSize: word; // Bytes of extra data appended to this struct
    end;
    PWAVEFORMATEX = ^TWAVEFORMATEX;
    NPWAVEFORMATEX = ^TWAVEFORMATEX;
    LPWAVEFORMATEX = ^TWAVEFORMATEX;
    PCWAVEFORMATEX = ^TWAVEFORMATEX;
    LPCWAVEFORMATEX = ^TWAVEFORMATEX;


(**************************************************************************
 *
 *  WAVEFORMATEXTENSIBLE: Extended version of WAVEFORMATEX that should be
 *  used as a basis for all new audio formats.  The format tag is replaced
 *  with a GUID, allowing new formats to be defined without registering a
 *  format tag with Microsoft.  There are also new fields that can be used
 *  to specify the spatial positions for each channel and the bit packing
 *  used for wide samples (e.g. 24-bit PCM samples in 32-bit containers).
 *
 ***************************************************************************)


    TWAVEFORMATEXTENSIBLE = packed record
        Format: TWAVEFORMATEX; // Base WAVEFORMATEX data
        case integer of
            0: (
                wValidBitsPerSample: word; // Valid bits in each sample container
                dwChannelMask: DWORD; // Positions of the audio channels
                SubFormat: TGUID; // Format identifier GUID
            );
            1: (
                wSamplesPerBlock: word; // Samples per block of audio data; valid
            );
            2: (
                wReserved: word; // Zero if neither case above applies.
            );
    end;
    PTWAVEFORMATEXTENSIBLE = ^TWAVEFORMATEXTENSIBLE;


    LPWAVEFORMATEXTENSIBLE = ^TWAVEFORMATEXTENSIBLE;
    PCWAVEFORMATEXTENSIBLE = ^TWAVEFORMATEXTENSIBLE;
    LPCWAVEFORMATEXTENSIBLE = ^TWAVEFORMATEXTENSIBLE;


(**************************************************************************
 *
 *  Define the most common wave format tags used in WAVEFORMATEX formats.
 *
 ***************************************************************************)
    // Pulse Code Modulation
    // If WAVE_FORMAT_PCM is not defined, we need to define some legacy types
    // for compatibility with the Windows mmreg.h / mmsystem.h header files.
    // Old general format structure (information common to all formats)


    Twaveformat_tag = packed  record
        wFormatTag: word;
        nChannels: word;
        nSamplesPerSec: DWORD;
        nAvgBytesPerSec: DWORD;
        nBlockAlign: word;
    end;
    Pwaveformat_tag = ^Twaveformat_tag;

    TWAVEFORMAT = Twaveformat_tag;
    PWAVEFORMAT = ^Twaveformat_tag;
    NEARNPWAVEFORMAT = ^Twaveformat_tag;
    FARLPWAVEFORMAT = ^Twaveformat_tag;

    // Specific format structure for PCM data
    Tpcmwaveformat_tag = packed  record
        wf: TWAVEFORMAT;
        wBitsPerSample: word;
    end;
    Ppcmwaveformat_tag = ^Tpcmwaveformat_tag;

    TPCMWAVEFORMAT = Tpcmwaveformat_tag;
    PPCMWAVEFORMAT = ^Tpcmwaveformat_tag;
    NPPCMWAVEFORMAT = ^Tpcmwaveformat_tag;
    LPPCMWAVEFORMAT = ^Tpcmwaveformat_tag;


    // Microsoft Adaptive Differental PCM
    // Replicate the Microsoft ADPCM type definitions from mmreg.h.


    Tadpcmcoef_tag = packed  record
        iCoef1: short;
        iCoef2: short;
    end;
    Padpcmcoef_tag = ^Tadpcmcoef_tag;

    TADPCMCOEFSET = Tadpcmcoef_tag;


    Tadpcmwaveformat_tag = packed record
        wfx: TWAVEFORMATEX;
        wSamplesPerBlock: word;
        wNumCoef: word;
        aCoef: TADPCMCOEFSET; // Always 7 coefficient pairs for MS ADPCM
    end;
    Padpcmwaveformat_tag = ^Tadpcmwaveformat_tag;

    TADPCMWAVEFORMAT = Tadpcmwaveformat_tag;
    PADPCMWAVEFORMAT = ^TADPCMWAVEFORMAT;


implementation

end.
