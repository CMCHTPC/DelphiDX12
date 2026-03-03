//--------------------------------------------------------------------------------------
// File: DDSTextureLoader.cpp

// Functions for loading a DDS texture and creating a Direct3D runtime resource for it

// Note these functions are useful as a light-weight runtime loader for DDS files. For
// a full-featured DDS file reader, writer, and texture processing pipeline see
// the 'Texconv' sample and the 'DirectXTex' library.

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkId=248926
// http://go.microsoft.com/fwlink/?LinkId=248929
//--------------------------------------------------------------------------------------

unit DirectXTK11.DDSTextureLoader;

{$IFDEF FPC}
{$mode DelphiUnicode}{$H+}
{$ENDIF}

{$POINTERMATH ON}

interface

uses
    Classes, SysUtils, Windows,
    DirectXTK11.DDS,
    DX12.DXGI,
    DX12.D3D11;

function CreateTextureFromDDS(d3dDevice: ID3D11Device; d3dContext: ID3D11DeviceContext; const header: TDDS_HEADER; const bitData {bitSize}: pbyte; bitSize: size_t; maxsize: size_t;
    usage: TD3D11_USAGE; bindFlags: uint32; cpuAccessFlags: uint32; miscFlags: uint32; forceSRGB: boolean; out texture: ID3D11Resource; out textureView: ID3D11ShaderResourceView): HResult;

function CreateD3DResources(d3dDevice: ID3D11Device; resDim: TD3D11_RESOURCE_DIMENSION; Width: size_t; Height: size_t; depth: size_t; mipCount: size_t; arraySize: size_t; format: TDXGI_FORMAT;
    usage: TD3D11_USAGE; bindFlags: uint32; cpuAccessFlags: uint32; miscFlags: uint32; forceSRGB: boolean; isCubeMap: boolean; const initData{mipCount*arraySize}: PD3D11_SUBRESOURCE_DATA;
    out texture: ID3D11Resource; out textureView: ID3D11ShaderResourceView): HRESULT;

function FillInitData(Width: size_t; Height: size_t; depth: size_t; mipCount: size_t; arraySize: size_t; format: TDXGI_FORMAT; maxsize: size_t; bitSize: size_t; const bitData {bitSize}: pbyte;
    out twidth: size_t; out theight: size_t; out tdepth: size_t; out skipMip: size_t; {out} initData {mipCount*arraySize}: PD3D11_SUBRESOURCE_DATA): HRESULT;

function CreateDDSTextureFromMemory(d3dDevice: ID3D11Device; const ddsData: pbyte; ddsDataSize: size_t; out texture: ID3D11Resource; out textureView: ID3D11ShaderResourceView; maxsize: size_t; out alphaMode: TDDS_ALPHA_MODE): HRESULT;

function CreateDDSTextureFromMemoryEx(d3dDevice: ID3D11Device; const ddsData: pbyte; ddsDataSize: size_t; maxsize: size_t; usage: TD3D11_USAGE; bindFlags: UINT; cpuAccessFlags: UINT;
    miscFlags: UINT; forceSRGB: boolean; out texture: ID3D11Resource; out textureView: ID3D11ShaderResourceView; out alphaMode: TDDS_ALPHA_MODE): HRESULT;

function CreateDDSTextureFromFile(d3dDevice: ID3D11Device; const fileName: WideString; out texture: ID3D11Resource; out textureView: ID3D11ShaderResourceView; maxsize: size_t; out alphaMode: TDDS_ALPHA_MODE): HRESULT;

function CreateDDSTextureFromFileEx(d3dDevice: ID3D11Device; const fileName: WideString; maxsize: size_t; usage: TD3D11_USAGE; bindFlags: UINT; cpuAccessFlags: UINT; miscFlags: UINT;
    forceSRGB: boolean; out texture: ID3D11Resource; out textureView: ID3D11ShaderResourceView; out alphaMode: TDDS_ALPHA_MODE): HRESULT;

implementation

uses
    DirectXTK11.LoadHelpers,
    DX12.D3DCommon;



function FillInitData(Width: size_t; Height: size_t; depth: size_t; mipCount: size_t; arraySize: size_t; format: TDXGI_FORMAT; maxsize: size_t; bitSize: size_t; const bitData {bitSize}: pbyte;
    out twidth: size_t; out theight: size_t; out tdepth: size_t; out skipMip: size_t; {out} initData {mipCount*arraySize}: PD3D11_SUBRESOURCE_DATA): HRESULT;
var
    NumBytes: size_t;
    RowBytes: size_t;
    NumRows: size_t;
    pSrcBits: pbyte;
    pEndBits: pbyte;
    index: size_t;
    j, i: integer;
    w, h, d: size_t;
    lInitData: array of TD3D11_SUBRESOURCE_DATA absolute initData;
begin
    NumBytes := 0;
    RowBytes := 0;
    NumRows := 0;

    index := 0;
    Result := E_POINTER;
    if (bitData = nil) or (initData = nil) then
        Exit;

    skipMip := 0;
    twidth := 0;
    theight := 0;
    tdepth := 0;

    pSrcBits := bitData;
    pEndBits := bitData + bitSize;


    for  j := 0 to arraySize - 1 do
    begin
        w := Width;
        h := Height;
        d := depth;
        for  i := 0 to mipCount - 1 do
        begin
            Result := GetSurfaceInfo(w, h, format, NumBytes, RowBytes, NumRows);
            if (FAILED(Result)) then
                Exit;

            if (NumBytes > UINT32_MAX) or (RowBytes > UINT32_MAX) then
            begin
                Result := HRESULT_FROM_WIN32(ERROR_ARITHMETIC_OVERFLOW);
                exit;
            end;

            if ((mipCount <= 1) or (maxsize = 0) or ((w <= maxsize) and (h <= maxsize) and (d <= maxsize))) then
            begin
                if (twidth = 0) then
                begin
                    twidth := w;
                    theight := h;
                    tdepth := d;
                end;

                assert(index < mipCount * arraySize);
                //                   _Analysis_assume_(index < mipCount * arraySize);
                lInitData[index].pSysMem := pSrcBits;
                lInitData[index].SysMemPitch := (RowBytes);
                lInitData[index].SysMemSlicePitch := (NumBytes);
                Inc(index);
            end
            else if (j = 0) then
            begin
                // Count number of skipped mipmaps (first item only)
                Inc(skipMip);
            end;

            if (pSrcBits + (NumBytes * d) > pEndBits) then
            begin
                Result := HRESULT_FROM_WIN32(ERROR_HANDLE_EOF);
                Exit;
            end;

            pSrcBits := pSrcBits + NumBytes * d;

            w := w shr 1;
            h := h shr 1;
            d := d shr 1;
            if (w = 0) then
            begin
                w := 1;
            end;
            if (h = 0) then
            begin
                h := 1;
            end;
            if (d = 0) then
            begin
                d := 1;
            end;
        end;
    end;

    if (index > 0) then Result := S_OK
    else
        Result := E_FAIL;
end;



function CreateDDSTextureFromMemory(d3dDevice: ID3D11Device; const ddsData: pbyte; ddsDataSize: size_t; out texture: ID3D11Resource; out textureView: ID3D11ShaderResourceView; maxsize: size_t; out alphaMode: TDDS_ALPHA_MODE): HRESULT;
begin
    Result := CreateDDSTextureFromMemoryEx(d3dDevice, ddsData, ddsDataSize, maxsize, D3D11_USAGE_DEFAULT, Ord(D3D11_BIND_SHADER_RESOURCE), 0, 0, False, texture, textureView, alphaMode);
end;



function CreateDDSTextureFromMemoryEx(d3dDevice: ID3D11Device; const ddsData: pbyte; ddsDataSize: size_t; maxsize: size_t; usage: TD3D11_USAGE; bindFlags: UINT; cpuAccessFlags: UINT;
    miscFlags: UINT; forceSRGB: boolean; out texture: ID3D11Resource; out textureView: ID3D11ShaderResourceView; out alphaMode: TDDS_ALPHA_MODE): HRESULT;
var
    header: PDDS_HEADER;
    bitData: pbyte;
    bitSize: size_t;
begin
    header := nil;
    bitData := nil;
    bitSize := 0;
    if (texture <> nil) then
        texture := nil;
    if (textureView <> nil) then
        textureView := nil;


    alphaMode := DDS_ALPHA_MODE_UNKNOWN;

    Result := E_INVALIDARG;
    if (d3dDevice = nil) or (ddsData = nil) then
        Exit;

    Result := E_INVALIDARG;
    if ((bindFlags and Ord(D3D11_BIND_SHADER_RESOURCE)) <> Ord(D3D11_BIND_SHADER_RESOURCE)) then
        Exit;

    // Validate DDS file in memory
    Result := LoadTextureDataFromMemory(ddsData, ddsDataSize, header^, bitData, bitSize);
    if (FAILED(Result)) then Exit;

    Result := CreateTextureFromDDS(d3dDevice, nil, header^, bitData, bitSize, maxsize, usage, bindFlags, cpuAccessFlags, miscFlags, forceSRGB, texture, textureView);
    if (SUCCEEDED(Result)) then
    begin
        {if (texture && *texture)then
        begin
            SetDebugObjectName(*texture, "DDSTextureLoader");
        end;

        if (textureView && *textureView)then
        begin
            SetDebugObjectName(*textureView, "DDSTextureLoader");
        end;}


        alphaMode := GetAlphaMode(header);
    end;
end;



function CreateDDSTextureFromFile(d3dDevice: ID3D11Device; const fileName: WideString; out texture: ID3D11Resource; out textureView: ID3D11ShaderResourceView; maxsize: size_t; out alphaMode: TDDS_ALPHA_MODE): HRESULT;
begin
    Result := CreateDDSTextureFromFileEx(d3dDevice, fileName, maxsize, D3D11_USAGE_DEFAULT, Ord(D3D11_BIND_SHADER_RESOURCE), 0, 0, False, texture, textureView, alphaMode);
end;



function CreateDDSTextureFromFileEx(d3dDevice: ID3D11Device; const fileName: WideString; maxsize: size_t; usage: TD3D11_USAGE; bindFlags: UINT; cpuAccessFlags: UINT; miscFlags: UINT;
    forceSRGB: boolean; out texture: ID3D11Resource; out textureView: ID3D11ShaderResourceView; out alphaMode: TDDS_ALPHA_MODE): HRESULT;
var
    header: TDDS_HEADER;
    bitData: pbyte;
    bitSize: size_t;
    ddsData: pbyte;
begin
    bitSize := 0;
    alphaMode := DDS_ALPHA_MODE_UNKNOWN;

    Result := E_INVALIDARG;
    if (d3dDevice = nil) or (fileName = '') then Exit;

    Result := E_INVALIDARG;
    if ((bindFlags and Ord(D3D11_BIND_SHADER_RESOURCE)) <> Ord(D3D11_BIND_SHADER_RESOURCE)) then Exit;




    Result := LoadTextureDataFromFile(fileName, ddsData, header, bitData, bitSize);
    if (FAILED(Result)) then Exit;

    Result := CreateTextureFromDDS(d3dDevice, nil, header, bitData, bitSize, maxsize, usage, bindFlags, cpuAccessFlags, miscFlags, forceSRGB, texture, textureView);

    if (SUCCEEDED(Result)) then
    begin
        // SetDebugTextureInfo(fileName, texture, textureView);
        alphaMode := GetAlphaMode(@header);
    end;
end;



function CreateTextureFromDDS(d3dDevice: ID3D11Device; d3dContext: ID3D11DeviceContext; const header: TDDS_HEADER; const bitData {bitSize}: pbyte; bitSize: size_t; maxsize: size_t;
    usage: TD3D11_USAGE; bindFlags: uint32; cpuAccessFlags: uint32; miscFlags: uint32; forceSRGB: boolean; out texture: ID3D11Resource; out textureView: ID3D11ShaderResourceView): HResult;

var

    Width: UINT;
    Height: UINT;

    depth: UINT;
    resDim: TD3D11_RESOURCE_DIMENSION;
    arraySize: UINT;
    format: TDXGI_FORMAT;
    isCubeMap: boolean;
    mipCount: size_t;

    d3d10ext: PDDS_HEADER_DXT10;
    autogen: boolean;

    fmtSupport: UINT;
    tex: ID3D11Resource;
    numBytes: size_t;
    rowBytes: size_t;
    NumRows: size_t;
    desc: TD3D11_SHADER_RESOURCE_VIEW_DESC;
    mipLevels: UINT;

    skipMip: size_t;
    twidth: size_t;
    theight: size_t;
    tdepth: size_t;

    pSrcBits: pbyte;
    pEndBits: pbyte;
    item: UINT;
    res: UINT;
    initData: array of TD3D11_SUBRESOURCE_DATA;
begin
    arraySize := 1;
    format := DXGI_FORMAT_UNKNOWN;
    isCubeMap := False;
    skipMip := 0;
    twidth := 0;
    theight := 0;
    tdepth := 0;

    Result := S_OK;

    Width := header.Width;
    Height := header.Height;
    depth := header.depth;

    resDim := D3D11_RESOURCE_DIMENSION_UNKNOWN;

    mipCount := header.mipMapCount;
    if (0 = mipCount) then
    begin
        mipCount := 1;
    end;

    if ((header.ddspf.flags and DDS_FOURCC) = DDS_FOURCC) and ((MAKEFOURCC('D', 'X', '1', '0') = header.ddspf.fourCC)) then
    begin
        d3d10ext := PDDS_HEADER_DXT10(@header) + sizeof(TDDS_HEADER);

        arraySize := d3d10ext.arraySize;
        if (arraySize = 0) then
        begin
            Result := HRESULT_FROM_WIN32(ERROR_INVALID_DATA);
            Exit;
        end;

        case (d3d10ext.dxgiFormat) of

            DXGI_FORMAT_AI44,
            DXGI_FORMAT_IA44,
            DXGI_FORMAT_P8,
            DXGI_FORMAT_A8P8:
            begin
                // DebugTrace('ERROR: DDSTextureLoader does not support video textures. Consider using DirectXTex instead.\n');
                Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
                Exit;
            end;
            else
                if (BitsPerPixel(d3d10ext.dxgiFormat) = 0) then
                begin
                    //  DebugTrace('ERROR: Unknown DXGI format (%u)\n', uint32(d3d10ext.dxgiFormat));
                    Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
                    Exit;
                end;
        end;

        format := d3d10ext.dxgiFormat;

        case (d3d10ext.resourceDimension) of

            D3D11_RESOURCE_DIMENSION_TEXTURE1D:
            begin
                // D3DX writes 1D textures with a fixed Height of 1
                if (((header.flags and DDS_HEIGHT) = DDS_HEIGHT) and (Height <> 1)) then
                begin
                    Result := HRESULT_FROM_WIN32(ERROR_INVALID_DATA);
                    Exit;
                end;
                Height := 1;
                depth := 1;
            end;

            D3D11_RESOURCE_DIMENSION_TEXTURE2D:
            begin
                if (d3d10ext.miscFlag and Ord(D3D11_RESOURCE_MISC_TEXTURECUBE)) = Ord(D3D11_RESOURCE_MISC_TEXTURECUBE) then
                begin
                    arraySize := arraySize * 6;
                    isCubeMap := True;
                end;
                depth := 1;
            end;

            D3D11_RESOURCE_DIMENSION_TEXTURE3D:
            begin
                if ((header.flags and Ord(DDS_HEADER_FLAGS_VOLUME)) = 0) then
                begin
                    Result := HRESULT_FROM_WIN32(ERROR_INVALID_DATA);
                    exit;
                end;

                if (arraySize > 1) then
                begin
                    // DebugTrace(''ERROR: Volume textures are not texture arrays\n#);
                    Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
                    exit;
                end;
            end;

            D3D11_RESOURCE_DIMENSION_BUFFER:
            begin
                //   DebugTrace('ERROR: Resource dimension buffer type not supported for textures\n');
                Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
                exit;
            end;

                {case D3D11_RESOURCE_DIMENSION_UNKNOWN:}
            else
                // DebugTrace('ERROR: Unknown resource dimension (%u)\n', static_cast<uint32>(d3d10ext.resourceDimension));
                Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
                exit;
        end;

        resDim := d3d10ext.resourceDimension;
    end
    else
    begin
        format := GetDXGIFormat(header.ddspf);

        if (format = DXGI_FORMAT_UNKNOWN) then
        begin
            // DebugTrace('ERROR: DDSTextureLoader does not support all legacy DDS formats. Consider using DirectXTex.\n');
            Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
            exit;
        end;

        if (header.flags and DDS_HEADER_FLAGS_VOLUME) = DDS_HEADER_FLAGS_VOLUME then
        begin
            resDim := D3D11_RESOURCE_DIMENSION_TEXTURE3D;
        end
        else
        begin
            if (header.caps2 and DDS_CUBEMAP) = DDS_CUBEMAP then
            begin
                // We require all six faces to be defined
                if ((header.caps2 and DDS_CUBEMAP_ALLFACES) <> DDS_CUBEMAP_ALLFACES) then
                begin
                    //DebugTrace('ERROR: DirectX 11 does not support partial cubemaps\n');
                    Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
                    exit;
                end;

                arraySize := 6;
                isCubeMap := True;
            end;

            depth := 1;
            resDim := D3D11_RESOURCE_DIMENSION_TEXTURE2D;

            // Note there's no way for a legacy Direct3D 9 DDS to express a '1D' texture
        end;

        assert(BitsPerPixel(format) <> 0);
    end;

    if ((miscFlags and Ord(D3D11_RESOURCE_MISC_TEXTURECUBE)) = Ord(D3D11_RESOURCE_MISC_TEXTURECUBE)) and (resDim = D3D11_RESOURCE_DIMENSION_TEXTURE2D) and ((arraySize mod 6) = 0) then
    begin
        isCubeMap := True;
    end;

    // Bound sizes (for security purposes we don't trust DDS file metadata larger than the Direct3D hardware requirements)
    if (mipCount > D3D11_REQ_MIP_LEVELS) then
    begin
        // DebugTrace('ERROR: Too many mipmap levels defined for DirectX 11 (%zu).\n', mipCount);
        Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
        exit;
    end;

    case (resDim) of

        D3D11_RESOURCE_DIMENSION_TEXTURE1D:
        begin
            if ((arraySize > D3D11_REQ_TEXTURE1D_ARRAY_AXIS_DIMENSION) or (Width > D3D11_REQ_TEXTURE1D_U_DIMENSION)) then
            begin
                //   DebugTrace('ERROR: Resource dimensions too large for DirectX 11 (1D: array %u, size %u)\n', arraySize, width);
                Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
                exit;
            end;
        end;

        D3D11_RESOURCE_DIMENSION_TEXTURE2D:
        begin
            if (isCubeMap) then
            begin
                // This is the right bound because we set arraySize to (NumCubes*6) above
                if ((arraySize > D3D11_REQ_TEXTURE2D_ARRAY_AXIS_DIMENSION) or (Width > D3D11_REQ_TEXTURECUBE_DIMENSION) or (Height > D3D11_REQ_TEXTURECUBE_DIMENSION)) then
                begin
                    // DebugTrace('ERROR: Resource dimensions too large for DirectX 11 (2D cubemap: array %u, size %u by %u)\n', arraySize, width, height);
                    Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
                    exit;
                end;
            end
            else if ((arraySize > D3D11_REQ_TEXTURE2D_ARRAY_AXIS_DIMENSION) or (Width > D3D11_REQ_TEXTURE2D_U_OR_V_DIMENSION) or (Height > D3D11_REQ_TEXTURE2D_U_OR_V_DIMENSION)) then
            begin
                //  DebugTrace('ERROR: Resource dimensions too large for DirectX 11 (2D: array %u, size %u by %u)\n', arraySize, width, height);
                Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
                exit;
            end;
        end;

        D3D11_RESOURCE_DIMENSION_TEXTURE3D:
        begin
            if ((arraySize > 1) or (Width > D3D11_REQ_TEXTURE3D_U_V_OR_W_DIMENSION) or (Height > D3D11_REQ_TEXTURE3D_U_V_OR_W_DIMENSION) or (depth > D3D11_REQ_TEXTURE3D_U_V_OR_W_DIMENSION)) then
            begin
                // DebugTrace('ERROR: Resource dimensions too large for DirectX 11 (3D: array %u, size %u by %u by %u)\n', arraySize, width, height, depth);
                Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
                exit;
            end;
        end;

        D3D11_RESOURCE_DIMENSION_BUFFER:
        begin
            // DebugTrace('ERROR: Resource dimension buffer type not supported for textures\n');
            Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
            exit;
        end;

        else
        begin
            //   DebugTrace('ERROR: Unknown resource dimension (%u)\n', static_cast<uint32>(resDim));
            Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
            exit;
        end;
    end;

    autogen := False;
    if (mipCount = 1) and (d3dContext <> nil) and (textureView <> nil) then// Must have context and shader-view to auto generate mipmaps
    begin
        // See if format is supported for auto-gen mipmaps (varies by feature level)
        fmtSupport := 0;
        Result := d3dDevice.CheckFormatSupport(format, fmtSupport);
        if (SUCCEEDED(Result) and ((fmtSupport and Ord(D3D11_FORMAT_SUPPORT_MIP_AUTOGEN)) = Ord(D3D11_FORMAT_SUPPORT_MIP_AUTOGEN))) then
        begin
            // 10level9 feature levels do not support auto-gen mipgen for volume textures
            if ((resDim <> D3D11_RESOURCE_DIMENSION_TEXTURE3D) or (d3dDevice.GetFeatureLevel() >= D3D_FEATURE_LEVEL_10_0)) then
            begin
                autogen := True;
            end;
        end;
    end;

    if (autogen) then
    begin
        // Create texture with auto-generated mipmaps
        tex := nil;
        Result := CreateD3DResources(d3dDevice, resDim, Width, Height, depth, 0, arraySize, format, usage, bindFlags or Ord(D3D11_BIND_SHADER_RESOURCE) or Ord(D3D11_BIND_RENDER_TARGET),
            cpuAccessFlags, miscFlags or Ord(D3D11_RESOURCE_MISC_GENERATE_MIPS), forceSRGB, isCubeMap, nil, tex, textureView);
        if (SUCCEEDED(Result)) then
        begin

            numBytes := 0;
            rowBytes := 0;
            Result := GetSurfaceInfo(Width, Height, format, numBytes, rowBytes, NumRows);
            if (FAILED(Result)) then
                exit;

            if (numBytes > bitSize) then
            begin
                textureView := nil;
                Result := HRESULT_FROM_WIN32(ERROR_HANDLE_EOF);
                exit;
            end;

            if (numBytes > UINT32_MAX) or (rowBytes > UINT32_MAX) then
            begin
                Result := HRESULT_FROM_WIN32(ERROR_ARITHMETIC_OVERFLOW);
                exit;
            end;
            textureView.GetDesc(desc);

            mipLevels := 1;

            case (desc.ViewDimension) of

                D3D_SRV_DIMENSION_TEXTURE1D: begin
                    mipLevels := desc.Texture1D.MipLevels;
                end;
                D3D_SRV_DIMENSION_TEXTURE1DARRAY: begin
                    mipLevels := desc.Texture1DArray.MipLevels;
                end;
                D3D_SRV_DIMENSION_TEXTURE2D: begin
                    mipLevels := desc.Texture2D.MipLevels;
                end;
                D3D_SRV_DIMENSION_TEXTURE2DARRAY: begin
                    mipLevels := desc.Texture2DArray.MipLevels;
                end;
                D3D_SRV_DIMENSION_TEXTURECUBE: begin
                    mipLevels := desc.TextureCube.MipLevels;
                end;
                D3D_SRV_DIMENSION_TEXTURECUBEARRAY: begin
                    mipLevels := desc.TextureCubeArray.MipLevels;
                end;
                D3D_SRV_DIMENSION_TEXTURE3D: begin
                    mipLevels := desc.Texture3D.MipLevels;
                end;
                else
                    textureView := nil;
                    tex := nil;
                    Result := E_UNEXPECTED;
                    exit;
            end;

            if (arraySize > 1) then
            begin
                pSrcBits := bitData;
                pEndBits := bitData + bitSize;
                for  item := 0 to arraySize - 1 do
                begin
                    if ((pSrcBits + numBytes) > pEndBits) then
                    begin
                        textureView := nil;
                        tex := nil;
                        Result := HRESULT_FROM_WIN32(ERROR_HANDLE_EOF);
                        exit;
                    end;

                    res := D3D11CalcSubresource(0, item, mipLevels);
                    d3dContext.UpdateSubresource(tex, res, nil, pSrcBits, rowBytes, numBytes);
                    pSrcBits := pSrcBits + numBytes;
                end;
            end
            else
            begin
                d3dContext.UpdateSubresource(tex, 0, nil, bitData, rowBytes, numBytes);
            end;


            d3dContext.GenerateMips(textureView);

            texture := tex;
        end;
    end
    else
    begin
        // Create the texture

        SetLength(initData, mipCount * arraySize);

            {if (!initData) then
            begin
                result:= E_OUTOFMEMORY;
                Exit;
            end; }


        Result := FillInitData(Width, Height, depth, mipCount, arraySize, format, maxsize, bitSize, bitData, twidth, theight, tdepth, skipMip, @initData[0]);

        if (SUCCEEDED(Result)) then
        begin
            Result := CreateD3DResources(d3dDevice, resDim, twidth, theight, tdepth, mipCount - skipMip, arraySize, format, usage, bindFlags, cpuAccessFlags, miscFlags, forceSRGB, isCubeMap, @initData[0], texture, textureView);

            if (FAILED(Result) and (maxsize = 0) and (mipCount > 1)) then
            begin
                // Retry with a maxsize determined by feature level
                case (d3dDevice.GetFeatureLevel()) of

                    D3D_FEATURE_LEVEL_9_1,
                    D3D_FEATURE_LEVEL_9_2:
                    begin
                        if (isCubeMap) then
                        begin
                            maxsize := 512 { D3D_FL9_1_REQ_TEXTURECUBE_DIMENSION};
                        end
                        else
                        begin
                            if (resDim = D3D11_RESOURCE_DIMENSION_TEXTURE3D) then
                                maxsize :=
                                    256 {D3D_FL9_1_REQ_TEXTURE3D_U_V_OR_W_DIMENSION}
                            else
                                maxsize := 2048 {D3D_FL9_1_REQ_TEXTURE2D_U_OR_V_DIMENSION};
                        end;
                    end;

                    D3D_FEATURE_LEVEL_9_3:
                    begin
                        if (resDim = D3D11_RESOURCE_DIMENSION_TEXTURE3D) then
                            maxsize :=
                                256  {D3D_FL9_1_REQ_TEXTURE3D_U_V_OR_W_DIMENSION}
                        else
                            maxsize := 4096 {D3D_FL9_3_REQ_TEXTURE2D_U_OR_V_DIMENSION};
                    end;

                    else // D3D_FEATURE_LEVEL_10_0 & D3D_FEATURE_LEVEL_10_1
                    begin
                        if (resDim = D3D11_RESOURCE_DIMENSION_TEXTURE3D) then
                            maxsize :=
                                2048 {D3D10_REQ_TEXTURE3D_U_V_OR_W_DIMENSION}
                        else
                            maxsize := 8192 {D3D10_REQ_TEXTURE2D_U_OR_V_DIMENSION};
                    end;
                end;

                Result := FillInitData(Width, Height, depth, mipCount, arraySize, format, maxsize, bitSize, bitData, twidth, theight, tdepth, skipMip, @initData[0]);
                if (SUCCEEDED(Result)) then
                begin
                    Result := CreateD3DResources(d3dDevice, resDim, twidth, theight, tdepth, mipCount - skipMip, arraySize, format, usage, bindFlags, cpuAccessFlags, miscFlags,
                        forceSRGB, isCubeMap, @initData[0], texture, textureView);
                end;
            end;
        end;
    end;

end;



function CreateD3DResources(d3dDevice: ID3D11Device; resDim: TD3D11_RESOURCE_DIMENSION; Width: size_t; Height: size_t; depth: size_t; mipCount: size_t; arraySize: size_t; format: TDXGI_FORMAT;
    usage: TD3D11_USAGE; bindFlags: uint32; cpuAccessFlags: uint32; miscFlags: uint32; forceSRGB: boolean; isCubeMap: boolean; const initData: PD3D11_SUBRESOURCE_DATA; out texture: ID3D11Resource;
    out textureView: ID3D11ShaderResourceView): HRESULT;

var
    desc: TD3D11_TEXTURE1D_DESC;
    tex: ID3D11Texture1D;
    SRVDesc: TD3D11_SHADER_RESOURCE_VIEW_DESC;

    desc2: TD3D11_TEXTURE2D_DESC;
    tex2: ID3D11Texture2D;

    desc3: TD3D11_TEXTURE3D_DESC;
    tex3: ID3D11Texture3D;

    ltextureView: ID3D11ShaderResourceView;
begin
    Result := E_POINTER;
    if (d3dDevice = nil) then Exit;
    Result := E_FAIL;

    if (forceSRGB) then
    begin
        format := MakeSRGB(format);
    end;

    case (resDim) of

        D3D11_RESOURCE_DIMENSION_TEXTURE1D:
        begin
            desc.Width := (Width);
            desc.MipLevels := (mipCount);
            desc.ArraySize := (arraySize);
            desc.Format := format;
            desc.Usage := usage;
            desc.BindFlags := bindFlags;
            desc.CPUAccessFlags := cpuAccessFlags;
            desc.MiscFlags := miscFlags and not Ord(D3D11_RESOURCE_MISC_TEXTURECUBE);


            Result := d3dDevice.CreateTexture1D(@desc, initData, tex);
            if (SUCCEEDED(Result) and (tex <> nil)) then
            begin
                if (textureView <> nil) then
                begin
                    SRVDesc.Format := format;

                    if (arraySize > 1) then
                    begin
                        SRVDesc.ViewDimension := D3D11_SRV_DIMENSION_TEXTURE1DARRAY;
                        if mipCount = 0 then
                            SRVDesc.Texture1DArray.MipLevels := UINT(-1)
                        else
                            SRVDesc.Texture1DArray.MipLevels := desc.MipLevels;
                        SRVDesc.Texture1DArray.ArraySize := arraySize;
                    end
                    else
                    begin
                        SRVDesc.ViewDimension := D3D11_SRV_DIMENSION_TEXTURE1D;
                        if mipCount = 0 then
                            SRVDesc.Texture1D.MipLevels := UINT(-1)
                        else
                            SRVDesc.Texture1D.MipLevels := desc.MipLevels;
                    end;

                    Result := d3dDevice.CreateShaderResourceView(tex, @SRVDesc, textureView);
                    if (FAILED(Result)) then
                    begin
                        tex := nil;
                        Exit;
                    end;
                end;

                if (texture <> nil) then
                begin
                    texture := tex;
                end
                else
                begin
                    // ToDo SetDebugObjectName(tex, 'DDSTextureLoader');
                    tex := nil;
                end;
            end;

        end;

        D3D11_RESOURCE_DIMENSION_TEXTURE2D:
        begin
            desc2.Width := (Width);
            desc2.Height := (Height);
            desc2.MipLevels := (mipCount);
            desc2.ArraySize := (arraySize);
            desc2.Format := format;
            desc2.SampleDesc.Count := 1;
            desc2.SampleDesc.Quality := 0;
            desc2.Usage := usage;
            desc2.BindFlags := bindFlags or Ord(D3D11_BIND_SHADER_RESOURCE) or Ord(D3D11_BIND_RENDER_TARGET);
            desc2.CPUAccessFlags := cpuAccessFlags;
            if (isCubeMap) then
            begin
                desc2.MiscFlags := miscFlags or Ord(D3D11_RESOURCE_MISC_TEXTURECUBE);
            end
            else
            begin
                desc2.MiscFlags := miscFlags and not Ord(D3D11_RESOURCE_MISC_TEXTURECUBE); //} Ord(D3D11_RESOURCE_MISC_GENERATE_MIPS);
            end;

            tex2 := nil;
            Result := d3dDevice.CreateTexture2D(desc2, initData, tex2);
            if (SUCCEEDED(Result) and (tex2 <> nil)) then
            begin
                //   if (textureView <> nil) then
                begin
                    ZeroMemory(@SRVDesc, SizeOf(SRVDesc));
                    SRVDesc.Format := format;

                    if (isCubeMap) then
                    begin
                        if (arraySize > 6) then
                        begin
                            SRVDesc.ViewDimension := D3D11_SRV_DIMENSION_TEXTURECUBEARRAY;
                            if mipCount = 0 then
                                SRVDesc.TextureCubeArray.MipLevels := UINT(-1)
                            else
                                SRVDesc.TextureCubeArray.MipLevels := desc.MipLevels;

                            // Earlier we set arraySize to (NumCubes * 6)
                            SRVDesc.TextureCubeArray.NumCubes := arraySize div 6;
                        end
                        else
                        begin
                            SRVDesc.ViewDimension := D3D11_SRV_DIMENSION_TEXTURECUBE;
                            if mipCount = 0 then
                                SRVDesc.TextureCube.MipLevels := UINT(-1)
                            else
                                SRVDesc.TextureCube.MipLevels := desc.MipLevels;
                        end;
                    end
                    else if (arraySize > 1) then
                    begin
                        SRVDesc.ViewDimension := D3D11_SRV_DIMENSION_TEXTURE2DARRAY;
                        if mipCount = 0 then
                            SRVDesc.Texture2DArray.MipLevels := UINT(-1)
                        else
                            SRVDesc.Texture2DArray.MipLevels := desc.MipLevels;
                        SRVDesc.Texture2DArray.ArraySize := arraySize;
                    end
                    else
                    begin
                        SRVDesc.ViewDimension := D3D11_SRV_DIMENSION_TEXTURE2D;
                        if mipCount = 0 then
                            SRVDesc.Texture2D.MipLevels := UINT(-1)
                        else
                            SRVDesc.Texture2D.MipLevels := desc.MipLevels;
                    end;

                    // Setup the shader resource view description.
                    //    SRVDesc.Format := textureDesc.Format;
                    SRVDesc.ViewDimension := D3D11_SRV_DIMENSION_TEXTURE2D;
                    SRVDesc.Texture2D.MostDetailedMip := 0;
                    SRVDesc.Texture2D.MipLevels := UINT(-1);

                    Result := d3dDevice.CreateShaderResourceView(tex2, @SRVDesc, ltextureView);
                    if (FAILED(Result)) then
                    begin
                        tex2 := nil;
                        Exit;
                    end;
                end;

                texture := tex2;
                textureView := ltextureView;
                {
                if (texture <> nil) then
                begin
                    texture := tex2;
                end
                else
                begin
                    // SetDebugObjectName(tex, 'DDSTextureLoader');
                    tex2 := nil;
                end;   }
            end;
        end;

        D3D11_RESOURCE_DIMENSION_TEXTURE3D:
        begin

            desc3.Width := (Width);
            desc3.Height := (Height);
            desc3.Depth := (depth);
            desc3.MipLevels := (mipCount);
            desc3.Format := format;
            desc3.Usage := usage;
            desc3.BindFlags := bindFlags;
            desc3.CPUAccessFlags := cpuAccessFlags;
            desc3.MiscFlags := miscFlags and not Ord(D3D11_RESOURCE_MISC_TEXTURECUBE);

            tex3 := nil;
            Result := d3dDevice.CreateTexture3D(@desc3, initData, tex3);
            if (SUCCEEDED(Result) and (tex3 <> nil)) then
            begin
                // if (textureView <> nil) then
                begin
                    SRVDesc.Format := format;

                    SRVDesc.ViewDimension := D3D11_SRV_DIMENSION_TEXTURE3D;
                    if mipCount = 0 then
                        SRVDesc.Texture3D.MipLevels := UINT(-1)
                    else
                        SRVDesc.Texture3D.MipLevels := desc.MipLevels;

                    Result := d3dDevice.CreateShaderResourceView(tex3, @SRVDesc, textureView);
                    if (FAILED(Result)) then
                    begin
                        tex3 := nil;
                        Exit;
                    end;
                end;

                if (texture <> nil) then
                begin
                    texture := tex3;
                end
                else
                begin
                    //SetDebugObjectName(tex3, 'DDSTextureLoader');
                    tex3 := nil;
                end;
            end;
        end;
    end;
end;




end.
