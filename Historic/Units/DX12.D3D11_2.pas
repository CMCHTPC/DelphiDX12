unit DX12.D3D11_2;

{$IFDEF FPC}
{$MODE delphi}{$H+}
{$ENDIF}

interface

{$Z4}

uses
    Windows, Classes, SysUtils,
    DX12.DXGI, DX12.D3D11, DX12.D3D11_1,
    DX12.D3DCommon;

const

    IID_ID3D11DeviceContext2: TGUID = '{420d5b32-b90c-4da4-bef0-359f6a24a83a}';
    IID_ID3D11Device2: TGUID = '{9d06dffa-d1e5-4d07-83a8-1bb123f2f841}';

    D3D11_PACKED_TILE = ($ffffffff);

type


    TD3D11_TILED_RESOURCE_COORDINATE = record
        X: UINT;
        Y: UINT;
        Z: UINT;
        Subresource: UINT;
    end;

    PD3D11_TILED_RESOURCE_COORDINATE = ^TD3D11_TILED_RESOURCE_COORDINATE;

    TD3D11_TILE_REGION_SIZE = record
        NumTiles: UINT;
        bUseBox: longbool;
        Width: UINT;
        Height: UINT16;
        Depth: UINT16;
    end;

    PD3D11_TILE_REGION_SIZE = ^TD3D11_TILE_REGION_SIZE;

    TD3D11_TILE_MAPPING_FLAG = (
        D3D11_TILE_MAPPING_NO_OVERWRITE = $1
        );

    TD3D11_TILE_RANGE_FLAG = (
        D3D11_TILE_RANGE_NULL = $1,
        D3D11_TILE_RANGE_SKIP = $2,
        D3D11_TILE_RANGE_REUSE_SINGLE_TILE = $4
        );

    TD3D11_SUBRESOURCE_TILING = record
        WidthInTiles: UINT;
        HeightInTiles: UINT16;
        DepthInTiles: UINT16;
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
        NumStandardMips: UINT8;
        NumPackedMips: UINT8;
        NumTilesForPackedMips: UINT;
        StartTileIndexInOverallResource: UINT;
    end;

    PD3D11_PACKED_MIP_DESC = ^TD3D11_PACKED_MIP_DESC;

    TD3D11_CHECK_MULTISAMPLE_QUALITY_LEVELS_FLAG = (
        D3D11_CHECK_MULTISAMPLE_QUALITY_LEVELS_TILED_RESOURCE = $1
        );


    TD3D11_TILE_COPY_FLAG = (
        D3D11_TILE_COPY_NO_OVERWRITE = $1,
        D3D11_TILE_COPY_LINEAR_BUFFER_TO_SWIZZLED_TILED_RESOURCE = $2,
        D3D11_TILE_COPY_SWIZZLED_TILED_RESOURCE_TO_LINEAR_BUFFER = $4
        );


    ID3D11DeviceContext2 = interface(ID3D11DeviceContext1)
        ['{420d5b32-b90c-4da4-bef0-359f6a24a83a}']
        function UpdateTileMappings(pTiledResource: ID3D11Resource; NumTiledResourceRegions: UINT;
            pTiledResourceRegionStartCoordinates: PD3D11_TILED_RESOURCE_COORDINATE; pTiledResourceRegionSizes: PD3D11_TILE_REGION_SIZE;
            pTilePool: ID3D11Buffer; NumRanges: UINT; pRangeFlags: PUINT; pTilePoolStartOffsets: PUINT;
            pRangeTileCounts: PUINT; Flags: UINT): HResult; stdcall;
        function CopyTileMappings(pDestTiledResource: ID3D11Resource; pDestRegionStartCoordinate: PD3D11_TILED_RESOURCE_COORDINATE;
            pSourceTiledResource: ID3D11Resource; pSourceRegionStartCoordinate: PD3D11_TILED_RESOURCE_COORDINATE;
            pTileRegionSize: PD3D11_TILE_REGION_SIZE; Flags: UINT): HResult; stdcall;
        procedure CopyTiles(pTiledResource: ID3D11Resource; pTileRegionStartCoordinate: PD3D11_TILED_RESOURCE_COORDINATE;
            pTileRegionSize: PD3D11_TILE_REGION_SIZE; pBuffer: ID3D11Buffer; BufferStartOffsetInBytes: UINT64; Flags: UINT); stdcall;
        procedure UpdateTiles(pDestTiledResource: ID3D11Resource; pDestTileRegionStartCoordinate: PD3D11_TILED_RESOURCE_COORDINATE;
            pDestTileRegionSize: PD3D11_TILE_REGION_SIZE; pSourceTileData: pointer; Flags: UINT); stdcall;
        function ResizeTilePool(pTilePool: ID3D11Buffer; NewSizeInBytes: UINT64): HResult; stdcall;
        procedure TiledResourceBarrier(pTiledResourceOrViewAccessBeforeBarrier: ID3D11DeviceChild;
            pTiledResourceOrViewAccessAfterBarrier: ID3D11DeviceChild); stdcall;
        function IsAnnotationEnabled(): longbool; stdcall;
        procedure SetMarkerInt(pLabel: PWideChar; Data: integer); stdcall;
        procedure BeginEventInt(pLabel: PWideChar; Data: integer); stdcall;
        procedure EndEvent(); stdcall;
    end;


    ID3D11Device2 = interface(ID3D11Device1)
        ['{9d06dffa-d1e5-4d07-83a8-1bb123f2f841}']
        procedure GetImmediateContext2(out ppImmediateContext: ID3D11DeviceContext2); stdcall;
        function CreateDeferredContext2(ContextFlags: UINT; out ppDeferredContext: ID3D11DeviceContext2): HResult;
            stdcall;
        procedure GetResourceTiling(pTiledResource: ID3D11Resource; out pNumTilesForEntireResource: UINT;
            out pPackedMipDesc: TD3D11_PACKED_MIP_DESC; out pStandardTileShapeForNonPackedMips: TD3D11_TILE_SHAPE;
            var pNumSubresourceTilings: UINT; FirstSubresourceTilingToGet: UINT;
            out pSubresourceTilingsForNonPackedMips: PD3D11_SUBRESOURCE_TILING); stdcall;
        function CheckMultisampleQualityLevels1(Format: TDXGI_FORMAT; SampleCount: UINT; Flags: UINT;
            out pNumQualityLevels: UINT): HResult; stdcall;
    end;

implementation

end.




