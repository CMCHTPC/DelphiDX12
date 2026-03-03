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

   Copyright (C) Microsoft Corporation.

   This unit consists of the following header files
   File name:  audiomediatype.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit Win32.AudioMediatype;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils;

    {$Z4}
    {$A4}

const

    IID_IAudioMediaType: TGUID = '{4E997F73-B71F-4798-873B-ED7DFCF15B4D}';

    AUDIOMEDIATYPE_EQUAL_FORMAT_TYPES = $00000002;
    AUDIOMEDIATYPE_EQUAL_FORMAT_DATA = $00000004;
    AUDIOMEDIATYPE_EQUAL_FORMAT_USER_DATA = $00000008;

type
    (* Forward Declarations *)
    IAudioMediaType = interface;


    _UNCOMPRESSEDAUDIOFORMAT = record
        guidFormatType: TGUID;
        dwSamplesPerFrame: DWORD;
        dwBytesPerSampleContainer: DWORD;
        dwValidBitsPerSample: DWORD;
        fFramesPerSecond: single;
        dwChannelMask: DWORD;
    end;
    TUNCOMPRESSEDAUDIOFORMAT = _UNCOMPRESSEDAUDIOFORMAT;
    PUNCOMPRESSEDAUDIOFORMAT = ^TUNCOMPRESSEDAUDIOFORMAT;


    IAudioMediaType = interface(IUnknown)
        ['{4E997F73-B71F-4798-873B-ED7DFCF15B4D}']
        function IsCompressedFormat(
        {_Out_  } pfCompressed: Pboolean): HRESULT; stdcall;

        function IsEqual(
        {_In_  } pIAudioType: IAudioMediaType;
        {_Out_  } pdwFlags: PDWORD): HRESULT; stdcall;

        function GetAudioFormat(): TWAVEFORMATEX; stdcall;

        function GetUncompressedAudioFormat(
        {_Out_  } pUncompressedAudioFormat: PUNCOMPRESSEDAUDIOFORMAT): HRESULT; stdcall;

    end;

    PIAudioMediaType = ^IAudioMediaType;


    // CreateAudioMediaType

function CreateAudioMediaType(pAudioFormat: PWAVEFORMATEX; cbAudioFormatSize: uint32;
    {out} ppIAudioMediaType: PIAudioMediaType): HRESULT; stdcall; external;


// CreateAudioMediaTypeFromUncompressedAudioFormat

function CreateAudioMediaTypeFromUncompressedAudioFormat(pUncompressedAudioFormat: PUNCOMPRESSEDAUDIOFORMAT;
    {out} ppIAudioMediaType: PIAudioMediaType): HRESULT; stdcall; external;


implementation

end.
