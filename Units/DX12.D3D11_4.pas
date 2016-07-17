{ **************************************************************************
  Copyright 2016 Norbert Sonnleitner

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

  This unit consists of the following header files
  File name: D3D11_4.h
  Header version: 10.0.10586

  ************************************************************************** }
unit DX12.D3D11_4;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

{$Z4}

uses
    Windows, Classes, SysUtils,  DX12.D3D11_3;

const
    IID_ID3D11Device4: TGUID = '{8992ab71-02e6-4b8d-ba48-b056dcda42c4}';

type
    ID3D11Device4 = interface(ID3D11Device3)
        ['{8992ab71-02e6-4b8d-ba48-b056dcda42c4}']
        function RegisterDeviceRemovedEvent(hEvent: HANDLE; out pdwCookie:DWORD): HResult; stdcall;
        procedure UnregisterDeviceRemoved(dwCookie: DWORD); stdcall;
    end;

implementation

end.



















