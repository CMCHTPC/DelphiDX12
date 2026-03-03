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

   Copyright (C) Microsoft Corporation.  All Rights Reserved.
   Content:    D3DX11 core types and functions

   This unit consists of the following header files
   File name: d3dx11core.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3DX11Core;

{$mode Delphi}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D11;

    {$Z4}

const
    // Current name of the DLL shipped in the same SDK as this header.
    {$IFOPT D+}
    D3DX11_DLL = 'd3dx11d_43.dll';
    {$ELSE}
    D3DX11_DLL = 'd3dx11_43.dll';
    {$ENDIF}
    D3DX11D_DLL = 'd3dx11d_43.dll';


    ///////////////////////////////////////////////////////////////////////////
    // D3DX11_SDK_VERSION:
    // -----------------
    // This identifier is passed to D3DX11CheckVersion in order to ensure that an
    // application was built against the correct header files and lib files.
    // This number is incremented whenever a header (or other) change would
    // require applications to be rebuilt. If the version doesn't match,
    // D3DX11CreateVersion will return FALSE. (The number itself has no meaning.)
    ///////////////////////////////////////////////////////////////////////////


    D3DX11_SDK_VERSION = 43;

    IID_ID3DX11ThreadPump: TGUID = '{C93FECFA-6967-478A-ABBC-402D90621FCB}';

    _FACD3D = $876;


    D3DERR_INVALIDCALL = ((1 shl 31) or (_FACD3D shl 16) or (2156));
    D3DERR_WASSTILLDRAWING = ((1 shl 31) or (_FACD3D shl 16) or (540));


type


    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11ThreadPump:
    //////////////////////////////////////////////////////////////////////////////

    {$interfaces corba}
    ID3DX11DataLoader = interface
        function Load(): HRESULT; stdcall;
        function Decompress({out} out ppData: pointer;{in} pcBytes: PSIZE_T): HRESULT; stdcall;
        function Destroy(): HRESULT; stdcall;
    end;

    ID3DX11DataProcessor = interface
        function Process({in} pData: Pvoid;{in} cBytes: SIZE_T): HRESULT; stdcall;
        function CreateDeviceObject({out} out ppDataObject: pointer): HRESULT; stdcall;
        function Destroy(): HRESULT; stdcall;
    end;

    {$interfaces COM}


    ID3DX11ThreadPump = interface(IUnknown)
        ['{C93FECFA-6967-478a-ABBC-402D90621FCB}']
        // ID3DX11ThreadPump
        function AddWorkItem({in} pDataLoader: ID3DX11DataLoader;{in} pDataProcessor: ID3DX11DataProcessor;{in} pHResult: PHRESULT;{out} out ppDeviceObject): HRESULT; stdcall;
        function GetWorkItemCount(): UINT; stdcall;
        function WaitForAllItems(): HRESULT; stdcall;
        function ProcessDeviceWorkItems(iWorkItemCount: UINT): HRESULT; stdcall;
        function PurgeAllItems(): HRESULT; stdcall;
        function GetQueueStatus(pIoQueue: PUINT; pProcessQueue: PUINT; pDeviceQueue: PUINT): HRESULT; stdcall;
    end;


function D3DX11DebugMute(Mute: boolean): boolean; stdcall; external D3DX11D_DLL;


function D3DX11CheckVersion(D3DSdkVersion: UINT; D3DX11SdkVersion: UINT): HRESULT; stdcall; external D3DX11_DLL;


function D3DX11CreateThreadPump({in} cIoThreads: UINT;{in} cProcThreads: UINT; {out} out ppThreadPump:ID3DX11ThreadPump  ): HRESULT; stdcall; external D3DX11_DLL;


function D3DX11UnsetAllDeviceObjects(pContext: ID3D11DeviceContext): HRESULT; stdcall; external D3DX11_DLL;


implementation

end.
