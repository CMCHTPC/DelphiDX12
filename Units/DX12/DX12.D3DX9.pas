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
   Content:    D3DX utility library

   This unit consists of the following header files
   File name: d3dx9.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.D3DX9;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}



interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D9,
    DX12.D3D9Types
    {,
    DX12.D3DX9Math
    DX12.D3DX9Core,
    DX12.D3DX9Mesh,
    DX12.D3DX9Tex,
    DX12.D3DX9Shader,
    DX12.D3DX9Effect,
    DX12.D3DX9Shape,
    DX12.D3DX9Anim
    };

    {$Z4}

// for different SDK versions
{$I DX12.DX9SDKVersion.inc}

const

    FLT_MAX = single(3.402823466e+38);

    D3DX_DEFAULT = UINT(-1);
    D3DX_DEFAULT_NONPOW2 = UINT(-2);
    D3DX_DEFAULT_FLOAT = FLT_MAX;
    D3DX_FROM_FILE = UINT(-3);
    D3DFMT_FROM_FILE = TD3DFORMAT(-3);


    // Errors
    _FACDD = $876;


type
    _D3DXERR = (
        D3DXERR_CANNOTMODIFYINDEXBUFFER = ((1 shl 31) or (_FACDD shl 16) or (2900)),
        D3DXERR_INVALIDMESH = ((1 shl 31) or (_FACDD shl 16) or (2901)),
        D3DXERR_CANNOTATTRSORT = ((1 shl 31) or (_FACDD shl 16) or (2902)),
        D3DXERR_SKINNINGNOTSUPPORTED = ((1 shl 31) or (_FACDD shl 16) or (2903)),
        D3DXERR_TOOMANYINFLUENCES = ((1 shl 31) or (_FACDD shl 16) or (2904)),
        D3DXERR_INVALIDDATA = ((1 shl 31) or (_FACDD shl 16) or (2905)),
        D3DXERR_LOADEDMESHASNODATA = ((1 shl 31) or (_FACDD shl 16) or (2906)),
        D3DXERR_DUPLICATENAMEDFRAGMENT = ((1 shl 31) or (_FACDD shl 16) or (2907)),
        D3DXERR_CANNOTREMOVELASTITEM = ((1 shl 31) or (_FACDD shl 16) or (2908)));

    TD3DXERR = ^_D3DXERR;
    PD3DXERR = ^TD3DXERR;




implementation

end.
