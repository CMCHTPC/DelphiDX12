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
   this ALWAYS GENERATED file contains the definitions for the interfaces

   This unit consists of the following header files
   File name: d3d11_2.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3D11_2;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}


interface

uses
    Windows, Classes, SysUtils,
    DX12.DXGI,
    DX12.DXGIFormat,
    DX12.D3D11,
    DX12.D3D11_1;

    {$Z4}

const

    D3D11_PACKED_TILE = ($ffffffff);


    IID_ID3D11DeviceContext2: TGUID = '{420D5B32-B90C-4DA4-BEF0-359F6A24A83A}';
    IID_ID3D11Device2: TGUID = '{9D06DFFA-D1E5-4D07-83A8-1BB123F2F841}';


type

    (* Forward Declarations *)


    ID3D11DeviceContext2 = interface;


    ID3D11Device2 = interface;


    TD3D11_TILED_RESOURCE_COORDINATE = record
        X: UINT;
        Y: UINT;
        Z: UINT;
        Subresource: UINT;
    end;
    PD3D11_TILED_RESOURCE_COORDINATE = ^TD3D11_TILED_RESOURCE_COORDINATE;


    TD3D11_TILE_REGION_SIZE = record
        NumTiles: UINT;
        bUseBox: boolean;
        Width: UINT;
        Height: uint16;
        Depth: uint16;
    end;
    PD3D11_TILE_REGION_SIZE = ^TD3D11_TILE_REGION_SIZE;


    TD3D11_TILE_MAPPING_FLAG = (
        D3D11_TILE_MAPPING_NO_OVERWRITE = $1);

    PD3D11_TILE_MAPPING_FLAG = ^TD3D11_TILE_MAPPING_FLAG;


    TD3D11_TILE_RANGE_FLAG = (
        D3D11_TILE_RANGE_NULL = $1,
        D3D11_TILE_RANGE_SKIP = $2,
        D3D11_TILE_RANGE_REUSE_SINGLE_TILE = $4);

    PD3D11_TILE_RANGE_FLAG = ^TD3D11_TILE_RANGE_FLAG;


    TD3D11_SUBRESOURCE_TILING = record
        WidthInTiles: UINT;
        HeightInTiles: uint16;
        DepthInTiles: uint16;
        StartTileIndexInOverallResource: UINT;
    end;
    PD3D11_SUBRESOURCE_TILING = ^TD3D11_SUBRESOURCE_TILING;


    TD3D11_TILE_SHAPE = record
        WidthInTexels: UINT;
        HeightInTexels: UINT;
        DepthInTexels: UINT;
    end;
    PD3D11_TILE_SHAPE = ^TD3D11_TILE_SHAPE;


    TD3D11_PACKED_MIP_DESC = record
        NumStandardMips: uint8;
        NumPackedMips: uint8;
        NumTilesForPackedMips: UINT;
        StartTileIndexInOverallResource: UINT;
    end;
    PD3D11_PACKED_MIP_DESC = ^TD3D11_PACKED_MIP_DESC;


    TD3D11_CHECK_MULTISAMPLE_QUALITY_LEVELS_FLAG = (
        D3D11_CHECK_MULTISAMPLE_QUALITY_LEVELS_TILED_RESOURCE = $1);

    PD3D11_CHECK_MULTISAMPLE_QUALITY_LEVELS_FLAG = ^TD3D11_CHECK_MULTISAMPLE_QUALITY_LEVELS_FLAG;


    TD3D11_TILE_COPY_FLAG = (
        D3D11_TILE_COPY_NO_OVERWRITE = $1,
        D3D11_TILE_COPY_LINEAR_BUFFER_TO_SWIZZLED_TILED_RESOURCE = $2,
        D3D11_TILE_COPY_SWIZZLED_TILED_RESOURCE_TO_LINEAR_BUFFER = $4);

    PD3D11_TILE_COPY_FLAG = ^TD3D11_TILE_COPY_FLAG;


    ID3D11DeviceContext2 = interface(ID3D11DeviceContext1)
        ['{420d5b32-b90c-4da4-bef0-359f6a24a83a}']
        function UpdateTileMappings(
        {_In_  } pTiledResource: ID3D11Resource;
        {_In_  } NumTiledResourceRegions: UINT;
        {_In_reads_opt_(NumTiledResourceRegions)  } pTiledResourceRegionStartCoordinates: PD3D11_TILED_RESOURCE_COORDINATE;
        {_In_reads_opt_(NumTiledResourceRegions)  } pTiledResourceRegionSizes: PD3D11_TILE_REGION_SIZE;
        {_In_opt_  } pTilePool: ID3D11Buffer;
        {_In_  } NumRanges: UINT;
        {_In_reads_opt_(NumRanges)  } pRangeFlags: PUINT;
        {_In_reads_opt_(NumRanges)  } pTilePoolStartOffsets: PUINT;
        {_In_reads_opt_(NumRanges)  } pRangeTileCounts: PUINT;
        {_In_  } Flags: UINT): HRESULT; stdcall;

        function CopyTileMappings(
        {_In_  } pDestTiledResource: ID3D11Resource;
        {_In_  } pDestRegionStartCoordinate: PD3D11_TILED_RESOURCE_COORDINATE;
        {_In_  } pSourceTiledResource: ID3D11Resource;
        {_In_  } pSourceRegionStartCoordinate: PD3D11_TILED_RESOURCE_COORDINATE;
        {_In_  } pTileRegionSize: PD3D11_TILE_REGION_SIZE;
        {_In_  } Flags: UINT): HRESULT; stdcall;

        procedure CopyTiles(
        {_In_  } pTiledResource: ID3D11Resource;
        {_In_  } pTileRegionStartCoordinate: PD3D11_TILED_RESOURCE_COORDINATE;
        {_In_  } pTileRegionSize: PD3D11_TILE_REGION_SIZE;
        {_In_  } pBuffer: ID3D11Buffer;
        {_In_  } BufferStartOffsetInBytes: uint64;
        {_In_  } Flags: UINT); stdcall;

        procedure UpdateTiles(
        {_In_  } pDestTiledResource: ID3D11Resource;
        {_In_  } pDestTileRegionStartCoordinate: PD3D11_TILED_RESOURCE_COORDINATE;
        {_In_  } pDestTileRegionSize: PD3D11_TILE_REGION_SIZE;
        {_In_  } pSourceTileData: Pvoid;
        {_In_  } Flags: UINT); stdcall;

        function ResizeTilePool(
        {_In_  } pTilePool: ID3D11Buffer;
        {_In_  } NewSizeInBytes: uint64): HRESULT; stdcall;

        procedure TiledResourceBarrier(
        {_In_opt_  } pTiledResourceOrViewAccessBeforeBarrier: ID3D11DeviceChild;
        {_In_opt_  } pTiledResourceOrViewAccessAfterBarrier: ID3D11DeviceChild); stdcall;

        function IsAnnotationEnabled(): boolean; stdcall;

        procedure SetMarkerInt(
        {_In_  } pLabel: LPCWSTR; Data: int32); stdcall;

        procedure BeginEventInt(
        {_In_  } pLabel: LPCWSTR; Data: int32); stdcall;

        procedure EndEvent(); stdcall;

    end;


    ID3D11Device2 = interface(ID3D11Device1)
        ['{9d06dffa-d1e5-4d07-83a8-1bb123f2f841}']
        procedure GetImmediateContext2(
        {_Outptr_  }  out ppImmediateContext: ID3D11DeviceContext2); stdcall;

        function CreateDeferredContext2(ContextFlags: UINT;
        {_COM_Outptr_opt_  }  out ppDeferredContext: ID3D11DeviceContext2): HRESULT; stdcall;

        procedure GetResourceTiling(
        {_In_  } pTiledResource: ID3D11Resource;
        {_Out_opt_  } pNumTilesForEntireResource: PUINT;
        {_Out_opt_  } pPackedMipDesc: PD3D11_PACKED_MIP_DESC;
        {_Out_opt_  } pStandardTileShapeForNonPackedMips: PD3D11_TILE_SHAPE;
        {_Inout_opt_  } pNumSubresourceTilings: PUINT;
        {_In_  } FirstSubresourceTilingToGet: UINT;
        {_Out_writes_(*pNumSubresourceTilings)  } pSubresourceTilingsForNonPackedMips: PD3D11_SUBRESOURCE_TILING); stdcall;

        function CheckMultisampleQualityLevels1(
        {_In_  } Format: TDXGI_FORMAT;
        {_In_  } SampleCount: UINT;
        {_In_  } Flags: UINT;
        {_Out_  } pNumQualityLevels: PUINT): HRESULT; stdcall;

    end;


implementation

end.
