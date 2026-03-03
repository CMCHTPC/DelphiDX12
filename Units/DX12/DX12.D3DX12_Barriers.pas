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

   Copyright (c) Microsoft Corporation
   Licensed under the MIT license
   DXCore Interface

   This unit consists of the following header files
   File name:
   Header version: SDK 1.717.1-preview  2025 12 28

  ************************************************************************** }
unit DX12.D3DX12_Barriers;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D12;

    {$I DX12.DX12SDKVersion.inc}

const
    ULLONG_MAX = QWORD($ffffffffffffffff);

type
    (* ====================================================
       The type helpers have the functions defined in the original header files and returns a pointer to a new variable
       The same function is defined as an Init function with the same parameters, but setting self.

       Also for each type helper a Init function without parameters is defined, which fills the default value.
       The Init function is called by the Initialize managment function (if possible) of the record
       ==================================================== *)




    //================================================================================================
    // D3DX12 Enhanced Barrier Helpers
    //================================================================================================

    { TD3DX12_BARRIER_SUBRESOURCE_RANGE }

    TD3DX12_BARRIER_SUBRESOURCE_RANGE = type helper for TD3D12_BARRIER_SUBRESOURCE_RANGE
        class function Create(o: PD3D12_BARRIER_SUBRESOURCE_RANGE = nil): PD3D12_BARRIER_SUBRESOURCE_RANGE; inline; overload; static;
        class function Create(Subresource: UINT): PD3D12_BARRIER_SUBRESOURCE_RANGE; inline; overload; static;
        class function Create(firstMipLevel: UINT; numMips: UINT; firstArraySlice: UINT; numArraySlices: UINT; firstPlane: UINT = 0; numPlanes: UINT = 1): PD3D12_BARRIER_SUBRESOURCE_RANGE; inline; overload; static;
        procedure Init(); inline; overload;
        procedure Init(Subresource: UINT); overload;
        procedure Init(firstMipLevel: UINT; numMips: UINT; firstArraySlice: UINT; numArraySlices: UINT; firstPlane: UINT = 0; numPlanes: UINT = 1); overload;
    end;

    { TD3DX12_GLOBAL_BARRIER }

    TD3DX12_GLOBAL_BARRIER = type helper for  TD3D12_GLOBAL_BARRIER
        class function Create(o: PD3D12_GLOBAL_BARRIER = nil): PD3D12_GLOBAL_BARRIER; inline; overload; static;
        class function Create(syncBefore: TD3D12_BARRIER_SYNC; syncAfter: TD3D12_BARRIER_SYNC; accessBefore: TD3D12_BARRIER_ACCESS; accessAfter: TD3D12_BARRIER_ACCESS): PD3D12_GLOBAL_BARRIER; inline; overload; static;
        procedure Init(); inline; overload;
        procedure Init(syncBefore: TD3D12_BARRIER_SYNC; syncAfter: TD3D12_BARRIER_SYNC; accessBefore: TD3D12_BARRIER_ACCESS; accessAfter: TD3D12_BARRIER_ACCESS);
    end;

    { TD3DX12_BUFFER_BARRIER }

    TD3DX12_BUFFER_BARRIER = type helper for  TD3D12_BUFFER_BARRIER
        class function Create(o: PD3D12_BUFFER_BARRIER = nil): PD3D12_BUFFER_BARRIER; inline; overload; static;
        class function Create(syncBefore: TD3D12_BARRIER_SYNC; syncAfter: TD3D12_BARRIER_SYNC; accessBefore: TD3D12_BARRIER_ACCESS; accessAfter: TD3D12_BARRIER_ACCESS; pRes: ID3D12Resource): PD3D12_BUFFER_BARRIER; inline; overload; static;
        procedure Init(); inline; overload;
        procedure Init(syncBefore: TD3D12_BARRIER_SYNC; syncAfter: TD3D12_BARRIER_SYNC; accessBefore: TD3D12_BARRIER_ACCESS; accessAfter: TD3D12_BARRIER_ACCESS; pRes: ID3D12Resource); overload;

    end;

    { TD3DX12_TEXTURE_BARRIER }

    TD3DX12_TEXTURE_BARRIER = type helper for  TD3D12_TEXTURE_BARRIER
        class function Create(o: PD3D12_TEXTURE_BARRIER = nil): PD3D12_TEXTURE_BARRIER; inline; overload; static;
        class function Create(syncBefore: TD3D12_BARRIER_SYNC; syncAfter: TD3D12_BARRIER_SYNC; accessBefore: TD3D12_BARRIER_ACCESS; accessAfter: TD3D12_BARRIER_ACCESS; layoutBefore: TD3D12_BARRIER_LAYOUT;
            layoutAfter: TD3D12_BARRIER_LAYOUT; pRes: ID3D12Resource; subresources: TD3D12_BARRIER_SUBRESOURCE_RANGE; flag: TD3D12_TEXTURE_BARRIER_FLAGS = D3D12_TEXTURE_BARRIER_FLAG_NONE): PD3D12_TEXTURE_BARRIER; inline; overload; static;
        procedure Init(); inline; overload;
        procedure Init(syncBefore: TD3D12_BARRIER_SYNC; syncAfter: TD3D12_BARRIER_SYNC; accessBefore: TD3D12_BARRIER_ACCESS; accessAfter: TD3D12_BARRIER_ACCESS; layoutBefore: TD3D12_BARRIER_LAYOUT;
            layoutAfter: TD3D12_BARRIER_LAYOUT; pRes: ID3D12Resource; subresources: TD3D12_BARRIER_SUBRESOURCE_RANGE; flag: TD3D12_TEXTURE_BARRIER_FLAGS = D3D12_TEXTURE_BARRIER_FLAG_NONE); overload;

    end;

    { TD3DX12_BARRIER_GROUP }

    TD3DX12_BARRIER_GROUP = type helper for  TD3D12_BARRIER_GROUP
        class function Create(o: PD3D12_BARRIER_GROUP = nil): PD3D12_BARRIER_GROUP; inline; overload; static;
        class function Create(numBarriers: uint32; pBarriers: PD3D12_BUFFER_BARRIER): PD3D12_BARRIER_GROUP; inline; overload; static;
        class function Create(numBarriers: uint32; pBarriers: PD3D12_TEXTURE_BARRIER): PD3D12_BARRIER_GROUP; inline; overload; static;
        class function Create(numBarriers: uint32; pBarriers: PD3D12_GLOBAL_BARRIER): PD3D12_BARRIER_GROUP; inline; overload; static;

        procedure Init(); overload;
        procedure InitBuffer(numBarriers: uint32; pBarriers: PD3D12_BUFFER_BARRIER); overload;
        procedure InitTexture(numBarriers: uint32; pBarriers: PD3D12_TEXTURE_BARRIER); overload;
        procedure InitGlobal(numBarriers: uint32; pBarriers: PD3D12_GLOBAL_BARRIER); overload;
    end;

implementation

{ TD3DX12_RESOURCE_BARRIER }




{ TD3DX12_BARRIER_SUBRESOURCE_RANGE }

class function TD3DX12_BARRIER_SUBRESOURCE_RANGE.Create(o: PD3D12_BARRIER_SUBRESOURCE_RANGE): PD3D12_BARRIER_SUBRESOURCE_RANGE;
begin
    New(Result);
    if o <> nil then
        Result^ := o^;
end;



class function TD3DX12_BARRIER_SUBRESOURCE_RANGE.Create(Subresource: UINT): PD3D12_BARRIER_SUBRESOURCE_RANGE;
begin
    New(Result);
    Result^.Init(Subresource, 0, 0, 0, 0, 0);
end;



class function TD3DX12_BARRIER_SUBRESOURCE_RANGE.Create(firstMipLevel: UINT; numMips: UINT; firstArraySlice: UINT; numArraySlices: UINT; firstPlane: UINT; numPlanes: UINT): PD3D12_BARRIER_SUBRESOURCE_RANGE;
begin
    New(Result);
    Result^.Init(firstMipLevel, numMips, firstArraySlice, numArraySlices, firstPlane, numPlanes);
end;



procedure TD3DX12_BARRIER_SUBRESOURCE_RANGE.Init();
begin
    self.Init(0, 0, 0, 0, 0, 0);
end;



procedure TD3DX12_BARRIER_SUBRESOURCE_RANGE.Init(Subresource: UINT);
begin
    self.Init(Subresource, 0, 0, 0, 0, 0);
end;



procedure TD3DX12_BARRIER_SUBRESOURCE_RANGE.Init(firstMipLevel: UINT; numMips: UINT; firstArraySlice: UINT; numArraySlices: UINT; firstPlane: UINT; numPlanes: UINT);
begin
    self.IndexOrFirstMipLevel := firstMipLevel;
    self.NumMipLevels := numMips;
    self.FirstArraySlice := firstArraySlice;
    self.NumArraySlices := numArraySlices;
    self.FirstPlane := firstPlane;
    self.NumPlanes := numPlanes;
end;

{ TD3DX12_GLOBAL_BARRIER }

class function TD3DX12_GLOBAL_BARRIER.Create(o: PD3D12_GLOBAL_BARRIER): PD3D12_GLOBAL_BARRIER;
begin
    New(Result);
    if o <> nil then
        Result^ := o^;
end;



class function TD3DX12_GLOBAL_BARRIER.Create(syncBefore: TD3D12_BARRIER_SYNC; syncAfter: TD3D12_BARRIER_SYNC; accessBefore: TD3D12_BARRIER_ACCESS; accessAfter: TD3D12_BARRIER_ACCESS): PD3D12_GLOBAL_BARRIER;
begin
    New(Result);
    Result^.Init(syncBefore, syncAfter, accessBefore, accessAfter);
end;



procedure TD3DX12_GLOBAL_BARRIER.Init();
begin
    ZeroMemory(@self, SizeOf(TD3D12_GLOBAL_BARRIER));
end;



procedure TD3DX12_GLOBAL_BARRIER.Init(syncBefore: TD3D12_BARRIER_SYNC; syncAfter: TD3D12_BARRIER_SYNC; accessBefore: TD3D12_BARRIER_ACCESS; accessAfter: TD3D12_BARRIER_ACCESS);
begin
    self.SyncBefore := syncBefore;
    self.SyncAfter := syncAfter;
    self.AccessBefore := accessBefore;
    self.AccessAfter := accessAfter;
end;

{ TD3DX12_BUFFER_BARRIER }

procedure TD3DX12_BUFFER_BARRIER.Init();
begin
    ZeroMemory(@self, SizeOf(TD3D12_BUFFER_BARRIER));
end;



procedure TD3DX12_BUFFER_BARRIER.Init(syncBefore: TD3D12_BARRIER_SYNC; syncAfter: TD3D12_BARRIER_SYNC; accessBefore: TD3D12_BARRIER_ACCESS; accessAfter: TD3D12_BARRIER_ACCESS; pRes: ID3D12Resource);
begin
    self.SyncBefore := syncBefore;
    self.SyncAfter := syncAfter;
    self.AccessBefore := accessBefore;
    self.AccessAfter := accessAfter;
    self.pResource := PID3D12Resource(pRes);
    self.Offset := 0;
    self.Size := ULLONG_MAX;
end;



class function TD3DX12_BUFFER_BARRIER.Create(o: PD3D12_BUFFER_BARRIER): PD3D12_BUFFER_BARRIER;
begin
    New(Result);
    if o <> nil then
        Result^ := o^;
end;



class function TD3DX12_BUFFER_BARRIER.Create(syncBefore: TD3D12_BARRIER_SYNC; syncAfter: TD3D12_BARRIER_SYNC; accessBefore: TD3D12_BARRIER_ACCESS; accessAfter: TD3D12_BARRIER_ACCESS; pRes: ID3D12Resource): PD3D12_BUFFER_BARRIER;
begin
    New(Result);
    Result^.Init(syncBefore, syncAfter, accessBefore, accessAfter, pRes);
end;


{ TD3DX12_TEXTURE_BARRIER }

class function TD3DX12_TEXTURE_BARRIER.Create(o: PD3D12_TEXTURE_BARRIER): PD3D12_TEXTURE_BARRIER;
begin
    New(Result);
    if o <> nil then
        Result^ := o^;
end;



class function TD3DX12_TEXTURE_BARRIER.Create(syncBefore: TD3D12_BARRIER_SYNC; syncAfter: TD3D12_BARRIER_SYNC; accessBefore: TD3D12_BARRIER_ACCESS; accessAfter: TD3D12_BARRIER_ACCESS;
    layoutBefore: TD3D12_BARRIER_LAYOUT; layoutAfter: TD3D12_BARRIER_LAYOUT; pRes: ID3D12Resource; subresources: TD3D12_BARRIER_SUBRESOURCE_RANGE; flag: TD3D12_TEXTURE_BARRIER_FLAGS): PD3D12_TEXTURE_BARRIER;
begin
    New(Result);
    Result^.Init(syncBefore, syncAfter, accessBefore, accessAfter,
        layoutBefore, layoutAfter, pRes, subresources, flag);
end;



procedure TD3DX12_TEXTURE_BARRIER.Init();
begin
    ZeroMemory(@self, SizeOf(TD3D12_BUFFER_BARRIER));
end;



procedure TD3DX12_TEXTURE_BARRIER.Init(syncBefore: TD3D12_BARRIER_SYNC; syncAfter: TD3D12_BARRIER_SYNC; accessBefore: TD3D12_BARRIER_ACCESS; accessAfter: TD3D12_BARRIER_ACCESS;
    layoutBefore: TD3D12_BARRIER_LAYOUT; layoutAfter: TD3D12_BARRIER_LAYOUT; pRes: ID3D12Resource; subresources: TD3D12_BARRIER_SUBRESOURCE_RANGE; flag: TD3D12_TEXTURE_BARRIER_FLAGS);
begin
    self.SyncBefore := syncBefore;
    self.SyncAfter := syncAfter;
    self.AccessBefore := accessBefore;
    self.AccessAfter := accessAfter;
    self.LayoutBefore := layoutBefore;
    self.LayoutAfter := layoutAfter;
    self.pResource := PID3D12Resource(pRes);
    self.Subresources := subresources;
    self.Flags := flag;
end;

{ TD3DX12_BARRIER_GROUP }

class function TD3DX12_BARRIER_GROUP.Create(o: PD3D12_BARRIER_GROUP): PD3D12_BARRIER_GROUP;
begin
    New(Result);
    if o <> nil then
        Result^ := o^;
end;



class function TD3DX12_BARRIER_GROUP.Create(numBarriers: uint32; pBarriers: PD3D12_BUFFER_BARRIER): PD3D12_BARRIER_GROUP;
begin
    New(Result);
    Result^.InitBuffer(numBarriers, pBarriers);
end;



class function TD3DX12_BARRIER_GROUP.Create(numBarriers: uint32; pBarriers: PD3D12_TEXTURE_BARRIER): PD3D12_BARRIER_GROUP;
begin
    New(Result);
    Result^.InitTexture(numBarriers, pBarriers);
end;



class function TD3DX12_BARRIER_GROUP.Create(numBarriers: uint32; pBarriers: PD3D12_GLOBAL_BARRIER): PD3D12_BARRIER_GROUP;
begin
    New(Result);
    Result^.InitGlobal(numBarriers, pBarriers);
end;



procedure TD3DX12_BARRIER_GROUP.Init();
begin
    ZeroMemory(@self, SizeOf(TD3D12_BARRIER_GROUP));
end;



procedure TD3DX12_BARRIER_GROUP.InitBuffer(numBarriers: uint32; pBarriers: PD3D12_BUFFER_BARRIER);
begin
    self.BarrierType := D3D12_BARRIER_TYPE_BUFFER;
    self.NumBarriers := numBarriers;
    self.pBufferBarriers := pBarriers;
end;



procedure TD3DX12_BARRIER_GROUP.InitTexture(numBarriers: uint32; pBarriers: PD3D12_TEXTURE_BARRIER);
begin
    self.BarrierType := D3D12_BARRIER_TYPE_TEXTURE;
    self.NumBarriers := numBarriers;
    self.pTextureBarriers := pBarriers;
end;



procedure TD3DX12_BARRIER_GROUP.InitGlobal(numBarriers: uint32; pBarriers: PD3D12_GLOBAL_BARRIER);
begin
    self.BarrierType := D3D12_BARRIER_TYPE_GLOBAL;
    self.NumBarriers := numBarriers;
    self.pGlobalBarriers := pBarriers;
end;

end.
