{ **************************************************************************
  FreePascal/Delphi DirectX 12 Header Files
  
  Copyright 2013-2021 Norbert Sonnleitner

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
  File name: d3d9on12.h
			 
  Header version: 10.0.19041.0

  ************************************************************************** }
unit DX12.D3D9On12;

interface


uses
  Windows, DX12.D3D9,
  DX12.D3D12;

const
  DLL = 'd3d9on12.dll';

const
  MAX_D3D9ON12_QUEUES = 2;

  IID_IDirect3DDevice9On12: TGUID = '{e7fda234-b589-4049-940d-8878977531c8}';

type

  TD3D9ON12_ARGS = record
    Enable9On12: longbool;
    pD3D12Device: IUnknown;
    ppD3D12Queues: array [0..MAX_D3D9ON12_QUEUES - 1] of IUnknown;
    NumQueues: UINT;
    NodeMask: UINT;
  end;
  PD3D9ON12_ARGS = ^TD3D9ON12_ARGS;




  IDirect3DDevice9On12 = interface(IUnknown)
    ['{e7fda234-b589-4049-940d-8878977531c8}']
    function GetD3D12Device(const riid: TGUID; out ppvDevice): HResult; stdcall;
    function UnwrapUnderlyingResource(pResource: IDirect3DResource9; pCommandQueue: ID3D12CommandQueue; const riid: TGUID;
      out ppvResource12): HResult; stdcall;
    function ReturnUnderlyingResource(pResource: IDirect3DResource9; NumSync: UINT; pSignalValues {NumSync}: PUINT64;
      ppFences {NumSync}: PID3D12Fence): HResult; stdcall;
  end;
  PDirect3DDevice9On12 = ^IDirect3DDevice9On12;

(* Entry point interfaces for creating a IDirect3D9 with 9On12 arguments *)

function Direct3DCreate9On12Ex(SDKVersion: UINT; pOverrideList: PD3D9ON12_ARGS; NumOverrideEntries: UINT;
  out ppOutputInterface: IDirect3D9Ex): HResult; stdcall; external DLL;


function Direct3DCreate9On12(SDKVersion: UINT; pOverrideList: PD3D9ON12_ARGS; NumOverrideEntries: UINT): IDirect3D9; stdcall; external DLL;



implementation

end.



