//--------------------------------------------------------------------------------------
// File: WICTextureLoader.h

// Function for loading a WIC image and creating a Direct3D runtime texture for it
// (auto-generating mipmaps if possible)

// Note: Assumes application has already called CoInitializeEx

// Note these functions are useful for images created as simple 2D textures. For
// more complex resources, DDSTextureLoader is an excellent light-weight runtime loader.
// For a full-featured DDS file reader, writer, and texture processing pipeline see
// the 'Texconv' sample and the 'DirectXTex' library.

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------
unit DX12TK.WICTextureLoader;

{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}

interface

uses
    Windows, Classes, SysUtils,
    ActiveX,
    DX12.WinCodecD2D1,
    DX12.WinCodec,
    DX12.D3D12,
    DX12.DXGIFormat,
    DX12TK.ResourceUploadBatch,
    CStdUniquePtr;

const
    UINT32_MAX = $FFFFFFFF;

    ERROR_FILE_TOO_LARGE = $DF; // 223

type
    {$Z4}


    REFGUID = ^TGUID;


    TWIC_LOADER_FLAGS = (
        WIC_LOADER_DEFAULT = 0,
        WIC_LOADER_FORCE_SRGB = $1,
        WIC_LOADER_IGNORE_SRGB = $2,
        WIC_LOADER_SRGB_DEFAULT = $4,
        WIC_LOADER_MIP_AUTOGEN = $8,
        WIC_LOADER_MIP_RESERVE = $10,
        WIC_LOADER_FIT_POW2 = $20,
        WIC_LOADER_MAKE_SQUARE = $40,
        WIC_LOADER_FORCE_RGBA32 = $80);

    PWIC_LOADER_FLAGS = ^TWIC_LOADER_FLAGS;


    TCStdUniquePtr_UINT8 = specialize TCStdUniquePtr<uint8>;
    TCStdUniquePtrArray_UINT8 = specialize TCStdUniquePtrArray<uint8>;

    // Standard version

function LoadWICTextureFromMemory(
    {_In_ } device: ID3D12Device;
    {_In_reads_bytes_(wicDataSize) } wicData: Puint8; wicDataSize: size_t;
    {_Outptr_ }  out texture: ID3D12Resource; out decodedData: TCStdUniquePtrArray_UINT8; out subresource: TD3D12_SUBRESOURCE_DATA; maxsize: size_t = 0): HRESULT;

function LoadWICTextureFromFile(
    {_In_ } device: ID3D12Device;
    {_In_z_ } szFileName: pwidechar;
    {_Outptr_ }  out texture: ID3D12Resource; out decodedData: TCStdUniquePtrArray_UINT8; subresource: TD3D12_SUBRESOURCE_DATA; maxsize: size_t = 0): HRESULT;


// Standard version with resource upload

function CreateWICTextureFromMemory(
    {_In_ } device: ID3D12Device; resourceUpload: TResourceUploadBatch;
    {_In_reads_bytes_(wicDataSize) } wicData: pbyte; wicDataSize: size_t;
    {_Outptr_ }  out texture: ID3D12Resource; generateMips: boolean = False; maxsize: size_t = 0): HRESULT;



function CreateWICTextureFromFile(
    {_In_ } device: PID3D12Device; resourceUpload: TResourceUploadBatch;
    {_In_z_ } szFileName: pwidechar;
    {_Outptr_ }  out texture: ID3D12Resource; generateMips: boolean = False; maxsize: size_t = 0): HRESULT;



// Extended version

function LoadWICTextureFromMemoryEx(
    {_In_}  device: ID3D12Device;
    {_In_reads_bytes_(wicDataSize)} wicData: Puint8; wicDataSize: size_t; maxsize: size_t; resFlags: TD3D12_RESOURCE_FLAGS; loadFlags: TWIC_LOADER_FLAGS;
    {_Outptr_} out texture: ID3D12Resource; out decodedData: TCStdUniquePtrArray_UINT8; out subresource: TD3D12_SUBRESOURCE_DATA): HRESULT;



function LoadWICTextureFromFileEx(
    {_In_ } device: PID3D12Device;
    {_In_z_ } szFileName: pwidechar; maxsize: size_t; resFlags: TD3D12_RESOURCE_FLAGS; loadFlags: TWIC_LOADER_FLAGS;
    {_Outptr_ }  out texture: ID3D12Resource; out decodedData: TCStdUniquePtrArray_UINT8; subresource: TD3D12_SUBRESOURCE_DATA): HRESULT;




// Extended version with resource upload

function CreateWICTextureFromMemoryEx(
    {_In_ } device: ID3D12Device; resourceUpload: TResourceUploadBatch;
    {_In_reads_bytes_(wicDataSize) } wicData: Puint8; wicDataSize: size_t; maxsize: size_t; resFlags: TD3D12_RESOURCE_FLAGS; loadFlags: TWIC_LOADER_FLAGS;
    {_Outptr_ }  out texture: ID3D12Resource): HRESULT;

function CreateWICTextureFromFileEx(
    {_In_ } device: ID3D12Device; resourceUpload: TResourceUploadBatch;
    {_In_z_ } szFileName: pwidechar; maxsize: size_t; resFlags: TD3D12_RESOURCE_FLAGS; loadFlags: TWIC_LOADER_FLAGS;
    {_Outptr_ }  out texture: ID3D12Resource): HRESULT;



function GetWIC(): IWICImagingFactory2;           // Also used by ScreenGrab

function CreateTextureFromWIC(
    {_In_ } device: ID3D12Device;
    {_In_ } frame: IWICBitmapFrameDecode; maxsize: size_t; resFlags: TD3D12_RESOURCE_FLAGS; loadFlags: TWIC_LOADER_FLAGS;
    {_Outptr_ }  out texture: ID3D12Resource; out decodedData: TCStdUniquePtrArray_UINT8; out subresource: TD3D12_SUBRESOURCE_DATA): HRESULT;


procedure SetDebugTextureInfo(
    {_In_z_ } fileName: pwidechar;
    {_In_ } texture: ID3D12Resource);

function GetPixelFormat(
    {_In_ } frame: IWICBitmapFrameDecode): TDXGI_FORMAT;

function CreateWICTextureFromMemory(device: ID3D12Device; resourceUpload: TResourceUploadBatch; wicData: Puint8; wicDataSize: size_t; out texture: ID3D12Resource; generateMips: winbool; maxsize: size_t): HRESULT;


implementation

uses
    Windows.Macros,
    Ole2,
    DX12.D3DX12_Core,
    DX12TK.DirectXHelpers,
    DX12TK.LoaderHelpers,
    Win32.SynchAPI;

    //--------------------------------------------------------------------------------------
    // File: WICTextureLoader.cpp

    // Function for loading a WIC image and creating a Direct3D runtime texture for it
    // (auto-generating mipmaps if possible)

    // Note: Assumes application has already called CoInitializeEx

    // Note these functions are useful for images created as simple 2D textures. For
    // more complex resources, DDSTextureLoader is an excellent light-weight runtime loader.
    // For a full-featured DDS file reader, writer, and texture processing pipeline see
    // the 'Texconv' sample and the 'DirectXTex' library.

    // Copyright (c) Microsoft Corporation.
    // Licensed under the MIT License.

    // http://go.microsoft.com/fwlink/?LinkID=615561
    //--------------------------------------------------------------------------------------

    // We could load multi-frame images (TIFF/GIF) into a texture array.
    // For now, we just load the first frame (note: DirectXTex supports multi-frame images)

type
    //-------------------------------------------------------------------------------------
    // WIC Pixel Format Translation Data
    //-------------------------------------------------------------------------------------

    { TWICTranslate }

    TWICTranslate = record
        wic: REFGUID;
        format: TDXGI_FORMAT;
        constructor Create(wg: REFGUID; fmt: TDXGI_FORMAT);
    end;

    //-------------------------------------------------------------------------------------
    // WIC Pixel Format nearest conversion table
    //-------------------------------------------------------------------------------------

    TWICConvert = record
        Source: REFGUID;
        target: REFGUID;
    end;

const
    g_WICFormats: array of TWICTranslate = (

        (wic: @GUID_WICPixelFormat128bppRGBAFloat; format: DXGI_FORMAT_R32G32B32A32_FLOAT),

        (wic: @GUID_WICPixelFormat64bppRGBAHalf; format: DXGI_FORMAT_R16G16B16A16_FLOAT),
        (wic: @GUID_WICPixelFormat64bppRGBA; format: DXGI_FORMAT_R16G16B16A16_UNORM),

        (wic: @GUID_WICPixelFormat32bppRGBA; format: DXGI_FORMAT_R8G8B8A8_UNORM),
        (wic: @GUID_WICPixelFormat32bppBGRA; format: DXGI_FORMAT_B8G8R8A8_UNORM),
        (wic: @GUID_WICPixelFormat32bppBGR; format: DXGI_FORMAT_B8G8R8X8_UNORM),

        (wic: @GUID_WICPixelFormat32bppRGBA1010102XR; format: DXGI_FORMAT_R10G10B10_XR_BIAS_A2_UNORM),
        (wic: @GUID_WICPixelFormat32bppRGBA1010102; format: DXGI_FORMAT_R10G10B10A2_UNORM),

        (wic: @GUID_WICPixelFormat16bppBGRA5551; format: DXGI_FORMAT_B5G5R5A1_UNORM),
        (wic: @GUID_WICPixelFormat16bppBGR565; format: DXGI_FORMAT_B5G6R5_UNORM),

        (wic: @GUID_WICPixelFormat32bppGrayFloat; format: DXGI_FORMAT_R32_FLOAT),
        (wic: @GUID_WICPixelFormat16bppGrayHalf; format: DXGI_FORMAT_R16_FLOAT),
        (wic: @GUID_WICPixelFormat16bppGray; format: DXGI_FORMAT_R16_UNORM),
        (wic: @GUID_WICPixelFormat8bppGray; format: DXGI_FORMAT_R8_UNORM),

        (wic: @GUID_WICPixelFormat8bppAlpha; format: DXGI_FORMAT_A8_UNORM),

        (wic: @GUID_WICPixelFormat96bppRGBFloat; format: DXGI_FORMAT_R32G32B32_FLOAT)
        );

    g_WICConvert: array of TWICConvert = (

        // Note target GUID in this conversion table must be one of those directly supported formats (above).

        (Source: @GUID_WICPixelFormatBlackWhite; target: @GUID_WICPixelFormat8bppGray), // DXGI_FORMAT_R8_UNORM

        (Source: @GUID_WICPixelFormat1bppIndexed; target: @GUID_WICPixelFormat32bppRGBA), // DXGI_FORMAT_R8G8B8A8_UNORM
        (Source: @GUID_WICPixelFormat2bppIndexed; target: @GUID_WICPixelFormat32bppRGBA), // DXGI_FORMAT_R8G8B8A8_UNORM
        (Source: @GUID_WICPixelFormat4bppIndexed; target: @GUID_WICPixelFormat32bppRGBA), // DXGI_FORMAT_R8G8B8A8_UNORM
        (Source: @GUID_WICPixelFormat8bppIndexed; target: @GUID_WICPixelFormat32bppRGBA), // DXGI_FORMAT_R8G8B8A8_UNORM

        (Source: @GUID_WICPixelFormat2bppGray; target: @GUID_WICPixelFormat8bppGray), // DXGI_FORMAT_R8_UNORM
        (Source: @GUID_WICPixelFormat4bppGray; target: @GUID_WICPixelFormat8bppGray), // DXGI_FORMAT_R8_UNORM

        (Source: @GUID_WICPixelFormat16bppGrayFixedPoint; target: @GUID_WICPixelFormat16bppGrayHalf), // DXGI_FORMAT_R16_FLOAT
        (Source: @GUID_WICPixelFormat32bppGrayFixedPoint; target: @GUID_WICPixelFormat32bppGrayFloat), // DXGI_FORMAT_R32_FLOAT

        (Source: @GUID_WICPixelFormat16bppBGR555; target: @GUID_WICPixelFormat16bppBGRA5551), // DXGI_FORMAT_B5G5R5A1_UNORM

        (Source: @GUID_WICPixelFormat32bppBGR101010; target: @GUID_WICPixelFormat32bppRGBA1010102), // DXGI_FORMAT_R10G10B10A2_UNORM

        (Source: @GUID_WICPixelFormat24bppBGR; target: @GUID_WICPixelFormat32bppRGBA), // DXGI_FORMAT_R8G8B8A8_UNORM
        (Source: @GUID_WICPixelFormat24bppRGB; target: @GUID_WICPixelFormat32bppRGBA), // DXGI_FORMAT_R8G8B8A8_UNORM
        (Source: @GUID_WICPixelFormat32bppPBGRA; target: @GUID_WICPixelFormat32bppRGBA), // DXGI_FORMAT_R8G8B8A8_UNORM
        (Source: @GUID_WICPixelFormat32bppPRGBA; target: @GUID_WICPixelFormat32bppRGBA), // DXGI_FORMAT_R8G8B8A8_UNORM

        (Source: @GUID_WICPixelFormat48bppRGB; target: @GUID_WICPixelFormat64bppRGBA), // DXGI_FORMAT_R16G16B16A16_UNORM
        (Source: @GUID_WICPixelFormat48bppBGR; target: @GUID_WICPixelFormat64bppRGBA), // DXGI_FORMAT_R16G16B16A16_UNORM
        (Source: @GUID_WICPixelFormat64bppBGRA; target: @GUID_WICPixelFormat64bppRGBA), // DXGI_FORMAT_R16G16B16A16_UNORM
        (Source: @GUID_WICPixelFormat64bppPRGBA; target: @GUID_WICPixelFormat64bppRGBA), // DXGI_FORMAT_R16G16B16A16_UNORM
        (Source: @GUID_WICPixelFormat64bppPBGRA; target: @GUID_WICPixelFormat64bppRGBA), // DXGI_FORMAT_R16G16B16A16_UNORM

        (Source: @GUID_WICPixelFormat48bppRGBFixedPoint; target: @GUID_WICPixelFormat64bppRGBAHalf), // DXGI_FORMAT_R16G16B16A16_FLOAT
        (Source: @GUID_WICPixelFormat48bppBGRFixedPoint; target: @GUID_WICPixelFormat64bppRGBAHalf), // DXGI_FORMAT_R16G16B16A16_FLOAT
        (Source: @GUID_WICPixelFormat64bppRGBAFixedPoint; target: @GUID_WICPixelFormat64bppRGBAHalf), // DXGI_FORMAT_R16G16B16A16_FLOAT
        (Source: @GUID_WICPixelFormat64bppBGRAFixedPoint; target: @GUID_WICPixelFormat64bppRGBAHalf), // DXGI_FORMAT_R16G16B16A16_FLOAT
        (Source: @GUID_WICPixelFormat64bppRGBFixedPoint; target: @GUID_WICPixelFormat64bppRGBAHalf), // DXGI_FORMAT_R16G16B16A16_FLOAT
        (Source: @GUID_WICPixelFormat64bppRGBHalf; target: @GUID_WICPixelFormat64bppRGBAHalf), // DXGI_FORMAT_R16G16B16A16_FLOAT
        (Source: @GUID_WICPixelFormat48bppRGBHalf; target: @GUID_WICPixelFormat64bppRGBAHalf), // DXGI_FORMAT_R16G16B16A16_FLOAT

        (Source: @GUID_WICPixelFormat128bppPRGBAFloat; target: @GUID_WICPixelFormat128bppRGBAFloat), // DXGI_FORMAT_R32G32B32A32_FLOAT
        (Source: @GUID_WICPixelFormat128bppRGBFloat; target: @GUID_WICPixelFormat128bppRGBAFloat), // DXGI_FORMAT_R32G32B32A32_FLOAT
        (Source: @GUID_WICPixelFormat128bppRGBAFixedPoint; target: @GUID_WICPixelFormat128bppRGBAFloat), // DXGI_FORMAT_R32G32B32A32_FLOAT
        (Source: @GUID_WICPixelFormat128bppRGBFixedPoint; target: @GUID_WICPixelFormat128bppRGBAFloat), // DXGI_FORMAT_R32G32B32A32_FLOAT
        (Source: @GUID_WICPixelFormat32bppRGBE; target: @GUID_WICPixelFormat128bppRGBAFloat), // DXGI_FORMAT_R32G32B32A32_FLOAT

        (Source: @GUID_WICPixelFormat32bppCMYK; target: @GUID_WICPixelFormat32bppRGBA), // DXGI_FORMAT_R8G8B8A8_UNORM
        (Source: @GUID_WICPixelFormat64bppCMYK; target: @GUID_WICPixelFormat64bppRGBA), // DXGI_FORMAT_R16G16B16A16_UNORM
        (Source: @GUID_WICPixelFormat40bppCMYKAlpha; target: @GUID_WICPixelFormat32bppRGBA), // DXGI_FORMAT_R8G8B8A8_UNORM
        (Source: @GUID_WICPixelFormat80bppCMYKAlpha; target: @GUID_WICPixelFormat64bppRGBA), // DXGI_FORMAT_R16G16B16A16_UNORM

        (Source: @GUID_WICPixelFormat32bppRGB; target: @GUID_WICPixelFormat32bppRGBA), // DXGI_FORMAT_R8G8B8A8_UNORM
        (Source: @GUID_WICPixelFormat64bppRGB; target: @GUID_WICPixelFormat64bppRGBA), // DXGI_FORMAT_R16G16B16A16_UNORM
        (Source: @GUID_WICPixelFormat64bppPRGBAHalf; target: @GUID_WICPixelFormat64bppRGBAHalf), // DXGI_FORMAT_R16G16B16A16_FLOAT

        (Source: @GUID_WICPixelFormat96bppRGBFixedPoint; target: @GUID_WICPixelFormat96bppRGBFloat) // DXGI_FORMAT_R32G32B32_FLOAT

        // We don't support n-channel formats
        );



function WICToDXGI(guid: REFGUID): TDXGI_FORMAT;
var
    i: size_t;
    n: size_t;
begin
    n := Length(g_WICFormats);
    for  i := 0 to n - 1 do
    begin
        if CompareMem(g_WICFormats[i].wic, guid, SizeOf(TGUID)) then
        begin
            Result := g_WICFormats[i].format;
            Exit;
        end;
    end;
    Result := DXGI_FORMAT_UNKNOWN;
end;



function WICBitsPerPixel(targetGuid: REFGUID): size_t;
var
    pWIC: IWICImagingFactory2;
    cinfo: IWICComponentInfo;
    WICType: TWICComponentType;
    pfinfo: IWICPixelFormatInfo;
    bpp: UINT;
begin
    Result := 0;
    pWIC := GetWIC();
    if (pWIC = nil) then
        Exit;

    if (FAILED(pWIC.CreateComponentInfo(targetGuid, cinfo))) then
        Exit;

    if (FAILED(cinfo.GetComponentType(@WICType))) then
        Exit;

    if (WICType <> WICPixelFormat) then
        Exit;

    if (FAILED(cinfo.QueryInterface(IID_IWICPixelFormatInfo, pfinfo))) then
        Exit;

    if (FAILED(pfinfo.GetBitsPerPixel(@bpp))) then
        Exit;

    Result := bpp;
end;



function InitializeWICFactory({_Inout_ } InitOnce: PINIT_ONCE;  {_Inout_opt_ } Parameter: PVOID; {_Outptr_opt_result_maybenull_ }   ifactory: PVOID): winbool; stdcall;
begin
    if SUCCEEDED(CoCreateInstance(CLSID_WICImagingFactory2, nil, CLSCTX_INPROC_SERVER, IID_IWICImagingFactory2, ifactory)) then
        Result := True
    else
        Result := False;
end;



function CreateTextureFromWIC(
    {_In_ } device: ID3D12Device;
    {_In_ } frame: IWICBitmapFrameDecode; maxsize: size_t; resFlags: TD3D12_RESOURCE_FLAGS; loadFlags: TWIC_LOADER_FLAGS;
    {_Outptr_ }  out texture: ID3D12Resource; out decodedData: TCStdUniquePtrArray_UINT8; out subresource: TD3D12_SUBRESOURCE_DATA): HRESULT;
var
    Width, Height: UINT;
    twidth, theight: UINT;
    metareader: IWICMetadataQueryReader;
    containerFormat: TGUID;
    sRGB: boolean;
    Value: TPROPVARIANT;

    pWIC: IWICImagingFactory2;
    scaler: IWICBitmapScaler;
    pfScaler: TWICPixelFormatGUID;
    canConvert: winBOOL;
    FC: IWICFormatConverter;

    ar: single;
    pixelFormat: TWICPixelFormatGUID;
    convertGUID: TWICPixelFormatGUID;
    bpp: size_t;
    format: TDXGI_FORMAT;
    i: size_t;

    rowBytes: uint64;
    numBytes: uint64;
    rowPitch: size_t;
    imageSize: size_t;
    mipCount: uint32;
    desc: TD3D12_RESOURCE_DESC;

    defaultHeapProperties: TD3D12_HEAP_PROPERTIES;
    tex: ID3D12Resource = nil;
begin

    Result := frame.GetSize(@Width, @Height);
    if (FAILED(Result)) then
        Exit;

    assert((Width > 0) and (Height > 0));

    if (maxsize > UINT32_MAX) then
    begin
        Result := E_INVALIDARG;
        Exit;
    end;

    if (maxsize = 0) then
    begin
        maxsize := size_t(D3D12_REQ_TEXTURE2D_U_OR_V_DIMENSION);
    end;

    twidth := Width;
    theight := Height;
    if ((Ord(loadFlags) and Ord(WIC_LOADER_FIT_POW2)) = Ord(WIC_LOADER_FIT_POW2)) then
    begin
        DX12TK.LoaderHelpers.FitPowerOf2(Width, Height, twidth, theight, maxsize);
    end
    else if (Width > maxsize) or (Height > maxsize) then
    begin

        ar := Height / Width;
        if (Width > Height) then
        begin
            twidth := maxsize;
            theight := max(1, UINT(maxsize * ar));
        end
        else
        begin
            theight := UINT(maxsize);
            twidth := max(1, UINT(maxsize / ar));
        end;
        assert((twidth <= maxsize) and (theight <= maxsize));
    end;

    if ((Ord(loadFlags) and Ord(WIC_LOADER_MAKE_SQUARE)) = Ord(WIC_LOADER_MAKE_SQUARE)) then
    begin
        twidth := max(twidth, theight);
        theight := twidth;
    end;

    // Determine format


    Result := frame.GetPixelFormat(@pixelFormat);
    if (FAILED(Result)) then
        Exit;

    Move(pixelFormat, convertGUID, sizeof(TWICPixelFormatGUID));
    bpp := 0;

    format := WICToDXGI(@pixelFormat);
    if (format = DXGI_FORMAT_UNKNOWN) then
    begin
        for  i := 0 to length(g_WICConvert) - 1 do
        begin
            if (CompareMem(@g_WICConvert[i].Source, @pixelFormat, sizeof(TWICPixelFormatGUID))) then
            begin
                Move(g_WICConvert[i].target, convertGUID, sizeof(TWICPixelFormatGUID));

                format := WICToDXGI(g_WICConvert[i].target);
                assert(format <> DXGI_FORMAT_UNKNOWN);
                bpp := WICBitsPerPixel(@convertGUID);
                break;
            end;
        end;

        if (format = DXGI_FORMAT_UNKNOWN) then
        begin
             (*   DebugTrace('ERROR: WICTextureLoader does not support all DXGI formats (WIC GUID {%8.8lX-%4.4X-%4.4X-%2.2X%2.2X-%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X}). Consider using DirectXTex.\n',
                    pixelFormat.Data1, pixelFormat.Data2, pixelFormat.Data3,
                    pixelFormat.Data4[0], pixelFormat.Data4[1], pixelFormat.Data4[2], pixelFormat.Data4[3],
                    pixelFormat.Data4[4], pixelFormat.Data4[5], pixelFormat.Data4[6], pixelFormat.Data4[7]);*)
            Result := HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED);
            Exit;
        end;
    end
    else
    begin
        bpp := WICBitsPerPixel(@pixelFormat);
    end;

    if ((Ord(loadFlags) and Ord(WIC_LOADER_FORCE_RGBA32)) = Ord(WIC_LOADER_FORCE_RGBA32)) then
    begin
        move(GUID_WICPixelFormat32bppRGBA, convertGUID, sizeof(TWICPixelFormatGUID));
        format := DXGI_FORMAT_R8G8B8A8_UNORM;
        bpp := 32;
    end;

    if (bpp = 0) then
    begin
        Result := E_FAIL;
        Exit;
    end;

    // Handle sRGB formats
    if ((Ord(loadFlags) and Ord(WIC_LOADER_FORCE_SRGB)) = Ord(WIC_LOADER_FORCE_SRGB)) then
    begin
        format := DX12TK.LoaderHelpers.MakeSRGB(format);
    end
    else if (not ((Ord(loadFlags) and Ord(WIC_LOADER_IGNORE_SRGB)) = Ord(WIC_LOADER_IGNORE_SRGB))) then
    begin

        if (SUCCEEDED(frame.GetMetadataQueryReader(metareader))) then
        begin

            if (SUCCEEDED(metareader.GetContainerFormat(@containerFormat))) then
            begin
                sRGB := False;


                PropVariantInit(@Value);

                // Check for colorspace chunks
                if (CompareMem(@containerFormat, @GUID_ContainerFormatPng, sizeof(TGUID))) then
                begin
                    // Check for sRGB chunk
                    if (SUCCEEDED(metareader.GetMetadataByName('/sRGB/RenderingIntent', @Value)) and (Value.vt = VT_UI1)) then
                    begin
                        sRGB := True;
                    end
                    else if (SUCCEEDED(metareader.GetMetadataByName('/gAMA/ImageGamma', @Value)) and (Value.vt = VT_UI4)) then
                    begin
                        sRGB := (Value.uintVal = 45455);
                    end
                    else
                    begin
                        sRGB := (Ord(loadFlags) and Ord(WIC_LOADER_SRGB_DEFAULT)) <> 0;
                    end;
                end


                else if (SUCCEEDED(metareader.GetMetadataByName('System.Image.ColorSpace', @Value)) and (Value.vt = VT_UI2)) then
                begin
                    sRGB := (Value.uiVal = 1);
                end
                else
                begin
                    sRGB := (Ord(loadFlags) and Ord(WIC_LOADER_SRGB_DEFAULT)) <> 0;
                end;


                DX12TK.LoaderHelpers.PropVariantClear(@Value);

                if (sRGB) then
                    format := DX12TK.LoaderHelpers.MakeSRGB(format);
            end;
        end;
    end;

    // Allocate memory for decoded image
    rowBytes := (twidth * bpp + 7) div 8;
    numBytes := rowBytes * theight;

    if (rowBytes > UINT32_MAX) or (numBytes > UINT32_MAX) then
    begin
        Result := HRESULT_FROM_WIN32(ERROR_ARITHMETIC_OVERFLOW);
        Exit;
    end;


    rowPitch := size_t(rowBytes);
    imageSize := size_t(numBytes);

    decodedData.reset(imageSize);
    if (decodedData.get() = nil) then
    begin
        Result := E_OUTOFMEMORY;
        exit;
    end;

    // Load image data
    if (CompareMem(@convertGUID, @pixelFormat, sizeof(TGUID)) and (twidth = Width) and (theight = Height)) then
    begin
        // No format conversion or resize needed
        Result := frame.CopyPixels(nil, UINT(rowPitch), UINT(imageSize), decodedData.get());
        if (FAILED(Result)) then
            exit;
    end
    else if (twidth <> Width) or (theight <> Height) then
    begin
        // Resize
        pWIC := GetWIC();
        if (pWIC = nil) then
        begin
            Result := E_NOINTERFACE;
            Exit;
        end;


        Result := pWIC.CreateBitmapScaler(scaler);
        if (FAILED(Result)) then
            exit;

        Result := scaler.Initialize(frame, twidth, theight, WICBitmapInterpolationModeFant);
        if (FAILED(Result)) then
            exit;


        Result := scaler.GetPixelFormat(@pfScaler);
        if (FAILED(Result)) then
            exit;

        if (CompareMem(@convertGUID, @pfScaler, sizeof(TGUID))) then
        begin
            // No format conversion needed
            Result := scaler.CopyPixels(nil, UINT(rowPitch), UINT(imageSize), decodedData.get());
            if (FAILED(Result)) then
                exit;
        end
        else
        begin

            Result := pWIC.CreateFormatConverter(FC);
            if (FAILED(Result)) then
                exit;

            canConvert := False;
            Result := FC.CanConvert(@pfScaler, @convertGUID, @canConvert);
            if (FAILED(Result) or not canConvert) then
            begin
                Result := E_UNEXPECTED;
                Exit;
            end;

            Result := FC.Initialize(scaler, @convertGUID, WICBitmapDitherTypeErrorDiffusion, nil, 0, WICBitmapPaletteTypeMedianCut);
            if (FAILED(Result)) then
                exit;

            Result := FC.CopyPixels(nil, UINT(rowPitch), UINT(imageSize), decodedData.get());
            if (FAILED(Result)) then
                exit;
        end;
    end
    else
    begin
        // Format conversion but no resize
        pWIC := GetWIC();
        if (pWIC = nil) then
        begin
            Result := E_NOINTERFACE;
            Exit;
        end;


        Result := pWIC.CreateFormatConverter(FC);
        if (FAILED(Result)) then
            exit;

        canConvert := False;
        Result := FC.CanConvert(@pixelFormat, @convertGUID, @canConvert);
        if (FAILED(Result) or not canConvert) then
        begin
            Result := E_UNEXPECTED;
            exit;
        end;

        Result := FC.Initialize(frame, @convertGUID, WICBitmapDitherTypeErrorDiffusion, nil, 0, WICBitmapPaletteTypeMedianCut);
        if (FAILED(Result)) then
            exit;

        Result := FC.CopyPixels(nil, UINT(rowPitch), UINT(imageSize), decodedData.get());
        if (FAILED(Result)) then
            exit;
    end;

    // Count the number of mips

    if (Ord(loadFlags) and (Ord(WIC_LOADER_MIP_AUTOGEN) or Ord(WIC_LOADER_MIP_RESERVE))) <> 0 then
        mipCount := DX12TK.LoaderHelpers.CountMips(twidth, theight)
    else
        mipCount := 1;

    // Create texture

    desc.Width := twidth;
    desc.Height := theight;
    desc.MipLevels := uint16(mipCount);
    desc.DepthOrArraySize := 1;
    desc.Format := format;
    desc.SampleDesc.Count := 1;
    desc.SampleDesc.Quality := 0;
    desc.Flags := resFlags;
    desc.Dimension := D3D12_RESOURCE_DIMENSION_TEXTURE2D;

    defaultHeapProperties.Init(D3D12_HEAP_TYPE_DEFAULT);

    Result := device.CreateCommittedResource(@defaultHeapProperties, D3D12_HEAP_FLAG_NONE, @desc, c_initialCopyTargetState, nil, @IID_ID3D12Resource, tex);

    if (FAILED(Result)) then
        exit;

    //s  _Analysis_assume_(tex != nullptr);

    subresource.pData := decodedData.get();
    subresource.RowPitch := LONG(rowPitch);
    subresource.SlicePitch := LONG(imageSize);

    texture := tex;

end;



procedure SetDebugTextureInfo(fileName: pwidechar; texture: ID3D12Resource);
var
    pstrName: widestring;
begin
    {$IFOPT D+}
    pstrName := ExtractFileName(Widestring(fileName));
    texture.SetName(pwidechar(pstrName));
    {$ENDIF}
end;



function GetPixelFormat(frame: IWICBitmapFrameDecode): TDXGI_FORMAT;
var
    pixelFormat: TWICPixelFormatGUID;
    format: TDXGI_FORMAT;
    i: size_t;
begin

    if (FAILED(frame.GetPixelFormat(@pixelFormat))) then
    begin
        Result := DXGI_FORMAT_UNKNOWN;
        Exit;
    end;

    format := WICToDXGI(@pixelFormat);
    if (format = DXGI_FORMAT_UNKNOWN) then
    begin
        for  i := 0 to length(g_WICConvert) - 1 do
        begin
            if (CompareMem(@g_WICConvert[i].Source, @pixelFormat, sizeof(TWICPixelFormatGUID))) then
            begin
                Result := WICToDXGI(g_WICConvert[i].target);
                Exit;
            end;
        end;
    end;

    Result := format;
end;



function CreateWICTextureFromMemory(device: ID3D12Device; resourceUpload: TResourceUploadBatch; wicData: Puint8; wicDataSize: size_t; out texture: ID3D12Resource; generateMips: winbool; maxsize: size_t): HRESULT;
begin
    if (generateMips) then
        Result := CreateWICTextureFromMemoryEx(device, resourceUpload, wicData, wicDataSize, maxsize, D3D12_RESOURCE_FLAG_NONE, WIC_LOADER_MIP_AUTOGEN, texture)
    else
        Result := CreateWICTextureFromMemoryEx(device, resourceUpload, wicData, wicDataSize, maxsize, D3D12_RESOURCE_FLAG_NONE, WIC_LOADER_DEFAULT, texture);
end;



function LoadWICTextureFromMemory(device: ID3D12Device; wicData: Puint8; wicDataSize: size_t; out texture: ID3D12Resource; out decodedData: TCStdUniquePtrArray_UINT8; out subresource: TD3D12_SUBRESOURCE_DATA; maxsize: size_t): HRESULT;
begin
    Result := LoadWICTextureFromMemoryEx(device, wicData, wicDataSize, maxsize, D3D12_RESOURCE_FLAG_NONE, WIC_LOADER_DEFAULT, texture, decodedData, subresource);
end;



function LoadWICTextureFromFile(device: ID3D12Device; szFileName: pwidechar; out texture: ID3D12Resource; out decodedData: TCStdUniquePtrArray_UINT8; subresource: TD3D12_SUBRESOURCE_DATA; maxsize: size_t): HRESULT;
begin

end;



function CreateWICTextureFromMemory(device: ID3D12Device; resourceUpload: TResourceUploadBatch; wicData: pbyte; wicDataSize: size_t; out texture: ID3D12Resource; generateMips: boolean; maxsize: size_t): HRESULT;
begin

end;



function CreateWICTextureFromFile(device: PID3D12Device; resourceUpload: TResourceUploadBatch; szFileName: pwidechar; out texture: ID3D12Resource; generateMips: boolean; maxsize: size_t): HRESULT;
begin

end;



function LoadWICTextureFromMemoryEx(device: ID3D12Device; wicData: Puint8; wicDataSize: size_t; maxsize: size_t; resFlags: TD3D12_RESOURCE_FLAGS; loadFlags: TWIC_LOADER_FLAGS;
    out texture: ID3D12Resource; out decodedData: TCStdUniquePtrArray_UINT8; out subresource: TD3D12_SUBRESOURCE_DATA): HRESULT;
var
    pWIC: IWICImagingFactory2;
    stream: IWICStream;
    decoder: IWICBitmapDecoder;
    frame: IWICBitmapFrameDecode;
begin

    if (device = nil) or (wicData = nil) or (texture = nil) then
    begin
        Result := E_INVALIDARG;
        Exit;
    end;

    if (wicDataSize = 0) then
    begin
        Result := E_FAIL;
        Exit;
    end;

    if (wicDataSize > UINT32_MAX) then
    begin
        Result := HRESULT_FROM_WIN32(ERROR_FILE_TOO_LARGE);
        Exit;
    end;

    pWIC := GetWIC();
    if (pWIC = nil) then
    begin
        Result := E_NOINTERFACE;
        Exit;
    end;

    // Create input stream for memory
    Result := pWIC.CreateStream(stream);
    if (FAILED(Result)) then
        Exit;


    Result := stream.InitializeFromMemory(Puint8(wicData), DWORD(wicDataSize));
    if (FAILED(Result)) then
        Exit;

    // Initialize WIC

    Result := pWIC.CreateDecoderFromStream(stream, nil, WICDecodeMetadataCacheOnDemand, decoder);
    if (FAILED(Result)) then
        Exit;


    Result := decoder.GetFrame(0, frame);
    if (FAILED(Result)) then
        Exit;

    Result := CreateTextureFromWIC(device, frame, maxsize, resFlags, loadFlags, texture, decodedData, subresource);
    if (FAILED(Result)) then
        Exit;

    //    _Analysis_assume_(*texture != nullptr);
    SetDebugObjectName(texture, 'WICTextureLoader');
end;



function LoadWICTextureFromFileEx(device: PID3D12Device; szFileName: pwidechar; maxsize: size_t; resFlags: TD3D12_RESOURCE_FLAGS; loadFlags: TWIC_LOADER_FLAGS; out texture: ID3D12Resource;
    out decodedData: TCStdUniquePtrArray_UINT8; subresource: TD3D12_SUBRESOURCE_DATA): HRESULT;
begin

end;



function CreateWICTextureFromMemoryEx(device: ID3D12Device; resourceUpload: TResourceUploadBatch; wicData: Puint8; wicDataSize: size_t; maxsize: size_t; resFlags: TD3D12_RESOURCE_FLAGS;
    loadFlags: TWIC_LOADER_FLAGS; out texture: ID3D12Resource): HRESULT;
begin

end;



function CreateWICTextureFromFileEx(device: ID3D12Device;
  resourceUpload: TResourceUploadBatch; szFileName: pwidechar; maxsize: size_t;
  resFlags: TD3D12_RESOURCE_FLAGS; loadFlags: TWIC_LOADER_FLAGS; out
  texture: ID3D12Resource): HRESULT;
begin

end;



function GetWIC(): IWICImagingFactory2;
var
    s_initOnce: TINIT_ONCE;
    factory: IWICImagingFactory2 = nil;
begin
    s_initOnce.Ptr := PVoid(INIT_ONCE_STATIC_INIT);
    if (not InitOnceExecuteOnce(@s_initOnce, @InitializeWICFactory, nil, @factory)) then
        Result := nil
    else
        Result := factory;
end;

{ TWICTranslate }

constructor TWICTranslate.Create(wg: REFGUID; fmt: TDXGI_FORMAT);
begin
    wic := wg;
    format := fmt;
end;

end.
