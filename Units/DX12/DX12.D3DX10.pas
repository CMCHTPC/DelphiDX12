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
    Content:    D3DX10 utility library

   This unit consists of the following header files
   File name: d3dx10.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.D3DX10;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.DXGIFormat;

    {$Z4}

const

    D3DX10_DEFAULT = UINT(-1);
    D3DX10_FROM_FILE = UINT(-3);
    DXGI_FORMAT_FROM_FILE = TDXGI_FORMAT(-3);

    // Errors
    _FACDD = $876;

 type

    _D3DX10_ERR = (
        D3DX10_ERR_CANNOT_MODIFY_INDEX_BUFFER = longint((1 SHL 31) or (_FACDD SHL 16) or (2900)),
        D3DX10_ERR_INVALID_MESH = longint((1 SHL 31) or (_FACDD SHL 16) or (2901)),
        D3DX10_ERR_CANNOT_ATTR_SORT = longint((1 SHL 31) or (_FACDD SHL 16) or (2902)),
        D3DX10_ERR_SKINNING_NOT_SUPPORTED = longint((1 SHL 31) or (_FACDD SHL 16) or (2903)),
        D3DX10_ERR_TOO_MANY_INFLUENCES = longint((1 SHL 31) or (_FACDD SHL 16) or (2904)),
        D3DX10_ERR_INVALID_DATA = longint((1 SHL 31) or (_FACDD SHL 16) or (2905)),
        D3DX10_ERR_LOADED_MESH_HAS_NO_DATA = longint((1 SHL 31) or (_FACDD SHL 16) or (2906)),
        D3DX10_ERR_DUPLICATE_NAMED_FRAGMENT =longint ((1 SHL 31) or (_FACDD SHL 16) or (2907)),
        D3DX10_ERR_CANNOT_REMOVE_LAST_ITEM = longint((1 SHL 31) or (_FACDD SHL 16) or (2908))
    );

    TD3DX10_ERR = _D3DX10_ERR;
    PD3DX10_ERR = ^TD3DX10_ERR;

implementation

end.
