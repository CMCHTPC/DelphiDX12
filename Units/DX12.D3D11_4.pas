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
  Header version: 10.0.14393,0

  ************************************************************************** }
unit DX12.D3D11_4;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

{$Z4}

uses
    Windows, Classes, SysUtils, DX12.D3D11_3, DX12.D3D11_1, DX12.D3D11, DX12.DXGI1_5;

const
    IID_ID3D11Device4: TGUID = '{8992ab71-02e6-4b8d-ba48-b056dcda42c4}';
    IID_ID3D11Device5: TGUID = '{8ffde202-a0e7-45df-9e01-e837801b5ea0}';
    IID_ID3D11Multithread: TGUID = '{9B7E4E00-342C-4106-A19F-4F2704F689F0}';
    IID_ID3D11VideoContext2: TGUID = '{C4E7374C-6243-4D1B-AE87-52B4F740E261}';


type
    ID3D11Device4 = interface(ID3D11Device3)
        ['{8992ab71-02e6-4b8d-ba48-b056dcda42c4}']
        function RegisterDeviceRemovedEvent(hEvent: HANDLE; out pdwCookie: DWORD): HResult; stdcall;
        procedure UnregisterDeviceRemoved(dwCookie: DWORD); stdcall;
    end;


    ID3D11Device5 = interface(ID3D11Device4)
        ['{8ffde202-a0e7-45df-9e01-e837801b5ea0}']
        function OpenSharedFence(hFence: HANDLE; const ReturnedInterface: TGUID; out ppFence): HResult; stdcall;
        function CreateFence(InitialValue: UINT64; Flags: TD3D11_FENCE_FLAG; const ReturnedInterface: TGUID;
            out ppFence): HResult; stdcall;
    end;


    ID3D11Multithread = interface(IUnknown)
        ['{9B7E4E00-342C-4106-A19F-4F2704F689F0}']
        procedure Enter(); stdcall;
        procedure Leave(); stdcall;
        function SetMultithreadProtected(bMTProtect: boolean): boolean; stdcall;
        function GetMultithreadProtected(): boolean; stdcall;
    end;


    ID3D11VideoContext2 = interface(ID3D11VideoContext1)
        ['{C4E7374C-6243-4D1B-AE87-52B4F740E261}']
        procedure VideoProcessorSetOutputHDRMetaData(pVideoProcessor: ID3D11VideoProcessor; AType: TDXGI_HDR_METADATA_TYPE;
            Size: UINT; pHDRMetaData: PByte); stdcall;
        procedure VideoProcessorGetOutputHDRMetaData(pVideoProcessor: ID3D11VideoProcessor; out pType: TDXGI_HDR_METADATA_TYPE;
            Size: UINT; out pMetaData: PByte); stdcall;
        procedure VideoProcessorSetStreamHDRMetaData(pVideoProcessor: ID3D11VideoProcessor; StreamIndex: UINT;
            AType: TDXGI_HDR_METADATA_TYPE; Size: UINT; pHDRMetaData: PByte); stdcall;
        procedure VideoProcessorGetStreamHDRMetaData(pVideoProcessor: ID3D11VideoProcessor; StreamIndex: UINT;
            out pType: TDXGI_HDR_METADATA_TYPE; Size: UINT; out pMetaData: PByte); stdcall;
    end;


    TD3D11_FEATURE_DATA_D3D11_OPTIONS4 = record
        ExtendedNV12SharedTextureSupported: boolean;
    end;



implementation

end.




