//-------------------------------------------------------------------------------------
// DirectXSHD3D12.cpp -- C++ Spherical Harmonics Math Library

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/p/?LinkId:=262885
//-------------------------------------------------------------------------------------

unit DirectX.SHD3D12;

{$mode Delphi}

interface

uses
    Classes, SysUtils, Windows,
    DirectX.Math,
    DX12.D3D12;

type
    TScopedAlignedArrayXMVECTOR = array of TXMVECTOR;


function SHProjectCubeMap(order: size_t; const desc: TD3D12_RESOURCE_DESC; const cubeMap: array of TD3D12_SUBRESOURCE_DATA;
    resultR: PSingle; resultG: PSingle; resultB: PSingle): HRESULT;

implementation

uses
    DirectX.SH,
    DirectX.PackedVector,
    DX12.DXGI;


// , XMLoadFloat3, g_XMIdentityR3);



function _LoadScanline(
    {var} pDestination: PXMVECTOR; Count: size_t; pSource: pbyte; size: size_t; format: TDXGI_FORMAT): boolean;
var
    dPtr, ePtr: PXMVECTOR;
    msize: size_t;
    sPtr: PSingle;
    icount: size_t;
    v: TXMVECTOR;
    sPtrH: PHALF;
begin
    assert((pDestination <> nil) and (Count > 0) and ((uintptr(pDestination) and $F) = 0));
    assert((pSource <> nil) and (size > 0));

    dPtr := pDestination;
    if (dPtr = nil) then
    begin
        Result := False;
        Exit;
    end;

    ePtr := pointer(pDestination) + Count;

    case (format) of

        DXGI_FORMAT_R32G32B32A32_FLOAT:
        begin
            if (size > (sizeof(TXMVECTOR) * Count)) then msize := (sizeof(TXMVECTOR) * Count)
            else
                msize := size;
            move(pSource^, dPtr^, msize);

            Result := True;

        end;

        DXGI_FORMAT_R32G32B32_FLOAT:
        begin
            // LOAD_SCANLINE3(XMFLOAT3, XMLoadFloat3, g_XMIdentityR3);

            if (size >= sizeof(TXMFLOAT3)) then
            begin
                sPtr := pSingle(pSource);
                icount := 0;
                while icount < (size - sizeof(TXMFLOAT3) + 1) do
                begin
                    v := XMLoadFloat3(PXMFLOAT3(sPtr)^);
                    Inc(sPtr);
                    if (dPtr >= ePtr) then  break;
                    dPtr^ := XMVectorSelect(g_XMIdentityR3, v, g_XMSelect1110);
                    Inc(dPtr);
                    icount := icount + sizeof(TXMFLOAT3);
                end;
                Result := True;
            end;
            Result := False;

        end;

        DXGI_FORMAT_R16G16B16A16_FLOAT:
        begin
            // LOAD_SCANLINE(XMHALF4, XMLoadHalf4);;
        end;

        DXGI_FORMAT_R32G32_FLOAT:
        begin
            // LOAD_SCANLINE2(XMFLOAT2, XMLoadFloat2, g_XMIdentityR3);
        end;

        DXGI_FORMAT_R11G11B10_FLOAT:
        begin
            // LOAD_SCANLINE3(XMFLOAT3PK, XMLoadFloat3PK, g_XMIdentityR3);
        end;

        DXGI_FORMAT_R16G16_FLOAT:
        begin
            // LOAD_SCANLINE2(XMHALF2, XMLoadHalf2, g_XMIdentityR3);
        end;

        DXGI_FORMAT_R32_FLOAT:
        begin
            if (size >= sizeof(single)) then
            begin
                sPtr := PSingle(pSource);
                icount := 0;
                while icount < size do
                begin
                    v := XMLoadFloat(sPtr);
                    Inc(sPtr);
                    if (dPtr >= ePtr) then break;
                    dPtr^ := XMVectorSelect(g_XMIdentityR3, v, g_XMSelect1000);
                    Inc(dPtr);
                    icount := icount + sizeof(single);
                end;
                Result := True;
                Exit;
            end;
            Result := False;

        end;

        DXGI_FORMAT_R16_FLOAT:
        begin
            if (size >= sizeof(THALF)) then
            begin
                sPtrH := PHALF(pSource);
                icount := 0;
                while icount < size do
                begin
                    if (dPtr >= ePtr) then break;
                    dPtr^ := XMVectorSet(XMConvertHalfToFloat(PHALF(sPtr)^), 0.0, 0.0, 1.0);
                    Inc(dPtr);
                    Inc(sPtr);
                    icount := icount + sizeof(THALF);
                end;
                Result := True;
                Exit;
            end;
            Result := False;
        end;
        else
            Result := False;
    end;
end;

//-------------------------------------------------------------------------------------
// Projects a function represented in a cube map into spherical harmonics.

// http://msdn.microsoft.com/en-us/library/windows/desktop/ff476300.aspx
//-------------------------------------------------------------------------------------

function SHProjectCubeMap(order: size_t; const desc: TD3D12_RESOURCE_DESC; const cubeMap: array of TD3D12_SUBRESOURCE_DATA;
    resultR: PSingle; resultG: PSingle; resultB: PSingle): HRESULT;

var
    fNormProj: single;
    fSize, fPicSize: single;
    fB, fS, fWt: single;
    shBuff: array[0..XM_SH_MAXORDER * XM_SH_MAXORDER - 1] of single;
    shBuffB: array[0..XM_SH_MAXORDER * XM_SH_MAXORDER - 1] of single;
    face: UINT;
    fDiffSolid: single;
    clr: TXMFLOAT3A;
    y, x: UINT;
    v: single;
    pixel: PXMVECTOR;
    u, ix, iy, iz: single;
    dir: TXMVECTOR;
    scanline: TScopedAlignedArrayXMVECTOR;
    pSrc: pbyte;
    ptr: PXMVECTOR;
begin
    Result := E_INVALIDARG;
    if (order < XM_SH_MINORDER) or (order > XM_SH_MAXORDER) then
        Exit;

    Result := E_FAIL;
    if (desc.Dimension <> D3D12_RESOURCE_DIMENSION_TEXTURE2D) or (desc.DepthOrArraySize <> 6) or
        (desc.Width <> desc.Height) or (desc.SampleDesc.Count > 1) then
        Exit;

    case (desc.Format) of

        DXGI_FORMAT_R32G32B32A32_FLOAT,
        DXGI_FORMAT_R32G32B32_FLOAT,
        DXGI_FORMAT_R16G16B16A16_FLOAT,
        DXGI_FORMAT_R32G32_FLOAT,
        DXGI_FORMAT_R11G11B10_FLOAT,
        DXGI_FORMAT_R16G16_FLOAT,
        DXGI_FORMAT_R32_FLOAT,
        DXGI_FORMAT_R16_FLOAT:
            // See _LoadScanline to support more pixel formats
        begin
        end;

        else
            Exit;
    end;



    //--- Setup for SH projection
    SetLength(scanline, desc.Width);

    assert(desc.Width > 0);
    fSize := (desc.Width);
    fPicSize := 1.0 / fSize;

    // index from [0,W-1], f(0) maps to -1 + 1/W, f(W-1) maps to 1 - 1/w
    // linear function x*S +B, 1st constraint means B is (-1+1/W), plug into
    // second and solve for S: S := 2*(1-1/W)/(W-1). The old code that did
    // this was incorrect - but only for computing the differential solid
    // angle, where the final value was 1.0 instead of 1-1/w...

    fB := -1.0 + 1.0 / fSize;
    if (desc.Width > 1) then fS := (2.0 * (1.0 - 1.0 / fSize) / (fSize - 1.0))
    else
        fS := 0.0;

    // clear out accumulation variables
    fWt := 0.0;

    if (resultR <> nil) then
        ZeroMemory(resultR, sizeof(single) * order * order);
    if (resultG <> nil) then
        ZeroMemory(resultG, sizeof(single) * order * order);
    if (resultB <> nil) then
        ZeroMemory(resultB, sizeof(single) * order * order);

    //--- Process each face of the cubemap
    for  face := 0 to 5 do
    begin
        if (cubeMap[face].pData = nil) then
        begin
            Result := E_POINTER;
            Exit;
        end;

        pSrc := pbyte(cubeMap[face].pData);
        for y := 0 to desc.Height - 1 do
        begin
            ptr := @scanline[0];
            if (not _LoadScanline(ptr, trunc(desc.Width), pSrc, trunc(cubeMap[face].RowPitch), desc.Format)) then
            begin
                Result := E_FAIL;
                Exit;
            end;

            v := (y) * fS + fB;

            pixel := ptr;
            for  x := 0 to desc.Width - 1 do
            begin
                Inc(pixel);
                u := (x) * fS + fB;
                case (face) of
                    0:                    // Positive X
                    begin

                        iz := 1.0 - (2.0 * (x) + 1.0) * fPicSize;
                        iy := 1.0 - (2.0 * (y) + 1.0) * fPicSize;
                        ix := 1.0;
                    end;

                    1: // Negative X
                    begin
                        iz := -1.0 + (2.0 * (x) + 1.0) * fPicSize;
                        iy := 1.0 - (2.0 * (y) + 1.0) * fPicSize;
                        ix := -1;
                    end;

                    2: // Positive Y
                    begin
                        iz := -1.0 + (2.0 * (y) + 1.0) * fPicSize;
                        iy := 1.0;
                        ix := -1.0 + (2.0 * (x) + 1.0) * fPicSize;
                    end;

                    3: // Negative Y
                    begin
                        iz := 1.0 - (2.0 * (y) + 1.0) * fPicSize;
                        iy := -1.0;
                        ix := -1.0 + (2.0 * (x) + 1.0) * fPicSize;
                    end;

                    4: // Positive Z
                    begin
                        iz := 1.0;
                        iy := 1.0 - (2.0 * (y) + 1.0) * fPicSize;
                        ix := -1.0 + (2.0 * (x) + 1.0) * fPicSize;
                    end;

                    5: // Negative Z
                    begin
                        iz := -1.0;
                        iy := 1.0 - (2.0 * (y) + 1.0) * fPicSize;
                        ix := 1.0 - (2.0 * (x) + 1.0) * fPicSize;
                    end;

                    else
                    begin
                        ix := 0.0;
                        iy := 0.0;
                        iz := 0.0;
                        assert(False);
                        break;
                    end;
                end;

                dir := XMVectorSet(ix, iy, iz, 0);
                dir := XMVector3Normalize(dir);

                fDiffSolid := 4.0 / ((1.0 + u * u + v * v) * sqrt(1.0 + u * u + v * v));
                fWt := fWt + fDiffSolid;

                XMSHEvalDirection(shBuff, order, dir);

                XMStoreFloat3A(clr, pixel^);

                if (resultR <> nil) then XMSHAdd(resultR, order, resultR, XMSHScale(shBuffB, order, shBuff, clr.x * fDiffSolid));
                if (resultG <> nil) then XMSHAdd(resultG, order, resultG, XMSHScale(shBuffB, order, shBuff, clr.y * fDiffSolid));
                if (resultB <> nil) then XMSHAdd(resultB, order, resultB, XMSHScale(shBuffB, order, shBuff, clr.z * fDiffSolid));
            end;

            pSrc := pSrc + cubeMap[face].RowPitch;
        end;
    end;

    fNormProj := (4.0 * XM_PI) / fWt;

    if (resultR <> nil) then XMSHScale(resultR, order, resultR, fNormProj);
    if (resultG <> nil) then XMSHScale(resultG, order, resultG, fNormProj);
    if (resultB <> nil) then XMSHScale(resultB, order, resultB, fNormProj);

    Result := S_OK;
end;

end.
