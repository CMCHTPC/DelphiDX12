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
   File name: d3dx12_render_pass.h
   Header version: SDK 1.717.1-preview  2025 12 28

  ************************************************************************** }

unit DX12.D3DX12_Render_Pass;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D12;

    {$I DX12.DX12SDKVersion.inc}

{$IFDEF D3D12_SDK_VERSION_609}
operator =(a: TD3D12_RENDER_PASS_BEGINNING_ACCESS_PRESERVE_LOCAL_PARAMETERS; b: TD3D12_RENDER_PASS_ENDING_ACCESS_PRESERVE_LOCAL_PARAMETERS) c: boolean;

operator =(a: TD3D12_RENDER_PASS_BEGINNING_ACCESS_PRESERVE_LOCAL_PARAMETERS; b: TD3D12_RENDER_PASS_BEGINNING_ACCESS_PRESERVE_LOCAL_PARAMETERS) c: boolean;

operator =(a: TD3D12_RENDER_PASS_ENDING_ACCESS_PRESERVE_LOCAL_PARAMETERS; b: TD3D12_RENDER_PASS_ENDING_ACCESS_PRESERVE_LOCAL_PARAMETERS) c: boolean;
{$ENDIF}

operator =(a: TD3D12_RENDER_PASS_BEGINNING_ACCESS_CLEAR_PARAMETERS; b: TD3D12_RENDER_PASS_BEGINNING_ACCESS_CLEAR_PARAMETERS) c: boolean;

operator =(a: TD3D12_RENDER_PASS_ENDING_ACCESS_RESOLVE_PARAMETERS; b: TD3D12_RENDER_PASS_ENDING_ACCESS_RESOLVE_PARAMETERS) c: boolean;

operator =(a: TD3D12_RENDER_PASS_BEGINNING_ACCESS; b: TD3D12_RENDER_PASS_BEGINNING_ACCESS) c: boolean;

operator =(a: TD3D12_RENDER_PASS_ENDING_ACCESS; b: TD3D12_RENDER_PASS_ENDING_ACCESS) c: boolean;

operator =(a: TD3D12_RENDER_PASS_RENDER_TARGET_DESC; b: TD3D12_RENDER_PASS_RENDER_TARGET_DESC) c: boolean;

operator =(a: TD3D12_RENDER_PASS_DEPTH_STENCIL_DESC; b: TD3D12_RENDER_PASS_DEPTH_STENCIL_DESC) c: boolean;

implementation



operator =(a: TD3D12_RENDER_PASS_BEGINNING_ACCESS_PRESERVE_LOCAL_PARAMETERS; b: TD3D12_RENDER_PASS_ENDING_ACCESS_PRESERVE_LOCAL_PARAMETERS)c: boolean;
begin
    c := ((a.AdditionalWidth = b.AdditionalWidth) and (a.AdditionalHeight = b.AdditionalHeight));
end;



operator =(a: TD3D12_RENDER_PASS_BEGINNING_ACCESS_PRESERVE_LOCAL_PARAMETERS; b: TD3D12_RENDER_PASS_BEGINNING_ACCESS_PRESERVE_LOCAL_PARAMETERS)c: boolean;
begin
    c := ((a.AdditionalWidth = b.AdditionalWidth) and (a.AdditionalHeight = b.AdditionalHeight));
end;



operator =(a: TD3D12_RENDER_PASS_ENDING_ACCESS_PRESERVE_LOCAL_PARAMETERS; b: TD3D12_RENDER_PASS_ENDING_ACCESS_PRESERVE_LOCAL_PARAMETERS)c: boolean;
begin
    c := ((a.AdditionalWidth = b.AdditionalWidth) and (a.AdditionalHeight = b.AdditionalHeight));
end;



operator =(a: TD3D12_RENDER_PASS_BEGINNING_ACCESS_CLEAR_PARAMETERS; b: TD3D12_RENDER_PASS_BEGINNING_ACCESS_CLEAR_PARAMETERS)c: boolean;
begin
    c := (a.ClearValue = b.ClearValue);
end;



operator =(a: TD3D12_RENDER_PASS_ENDING_ACCESS_RESOLVE_PARAMETERS; b: TD3D12_RENDER_PASS_ENDING_ACCESS_RESOLVE_PARAMETERS)c: boolean;
begin
    c := False;
    if (a.pSrcResource <> b.pSrcResource) then
        Exit;
    if (a.pDstResource <> b.pDstResource) then
        Exit;
    if (a.SubresourceCount <> b.SubresourceCount) then
        Exit;
    if (a.Format <> b.Format) then
        Exit;
    if (a.ResolveMode <> b.ResolveMode) then
        Exit;
    if (a.PreserveResolveSource <> b.PreserveResolveSource) then
        Exit;
    c := True;
end;



operator =(a: TD3D12_RENDER_PASS_BEGINNING_ACCESS; b: TD3D12_RENDER_PASS_BEGINNING_ACCESS)c: boolean;
begin
    c := False;
    if (a.AccessType <> b.AccessType) then
        Exit;
    case (a.AccessType) of
        D3D12_RENDER_PASS_BEGINNING_ACCESS_TYPE_CLEAR:
        begin
            if (not (a.Clear = b.Clear)) then
                Exit;
        end;
        {$IFDEF D3D12_SDK_VERSION_609}
        D3D12_RENDER_PASS_BEGINNING_ACCESS_TYPE_PRESERVE_LOCAL_RENDER,
        D3D12_RENDER_PASS_BEGINNING_ACCESS_TYPE_PRESERVE_LOCAL_SRV,
        D3D12_RENDER_PASS_BEGINNING_ACCESS_TYPE_PRESERVE_LOCAL_UAV:
        begin
            if (not (a.PreserveLocal = b.PreserveLocal)) then
                Exit;
        end;
        {$ENDIF}
    end;
    c := True;
end;



operator =(a: TD3D12_RENDER_PASS_ENDING_ACCESS; b: TD3D12_RENDER_PASS_ENDING_ACCESS)c: boolean;
begin
    c := False;
    if (a.AccessType <> b.AccessType) then
        Exit;
    case (a.AccessType) of

        D3D12_RENDER_PASS_ENDING_ACCESS_TYPE_RESOLVE:
        begin
            if (not (a.Resolve = b.Resolve)) then
                Exit;
        end;
        {$IFDEF D3D12_SDK_VERSION_609}
        D3D12_RENDER_PASS_ENDING_ACCESS_TYPE_PRESERVE_LOCAL_RENDER,
        D3D12_RENDER_PASS_ENDING_ACCESS_TYPE_PRESERVE_LOCAL_SRV,
        D3D12_RENDER_PASS_ENDING_ACCESS_TYPE_PRESERVE_LOCAL_UAV:
        begin
            if (not (a.PreserveLocal = b.PreserveLocal)) then
                Exit;
        end;
        {$ENDIF}
    end;
    c := True;
end;



operator =(a: TD3D12_RENDER_PASS_RENDER_TARGET_DESC; b: TD3D12_RENDER_PASS_RENDER_TARGET_DESC)c: boolean;
begin
    c := False;
    if (a.cpuDescriptor.ptr <> b.cpuDescriptor.ptr) then
        Exit;
    if (not (a.BeginningAccess = b.BeginningAccess)) then
        Exit;
    if (not (a.EndingAccess = b.EndingAccess)) then
        Exit;
    c := True;
end;



operator =(a: TD3D12_RENDER_PASS_DEPTH_STENCIL_DESC; b: TD3D12_RENDER_PASS_DEPTH_STENCIL_DESC)c: boolean;
begin
    c := False;
    if (a.cpuDescriptor.ptr <> b.cpuDescriptor.ptr) then
        Exit;
    if (not (a.DepthBeginningAccess = b.DepthBeginningAccess)) then
        Exit;
    if (not (a.StencilBeginningAccess = b.StencilBeginningAccess)) then
        Exit;
    if (not (a.DepthEndingAccess = b.DepthEndingAccess)) then
        Exit;
    if (not (a.StencilEndingAccess = b.StencilEndingAccess)) then
        Exit;
    c := True;
end;

end.
