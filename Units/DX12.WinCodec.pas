unit DX12.WinCodec;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

{$Z4}

uses
    Windows, Classes, SysUtils, DX12.DCommon, DX12.DXGI, ActiveX, DX12.OCIdl;

const
    WINCODEC_SDK_VERSION1 = $0236;
    WINCODEC_SDK_VERSION2 = $0237;
    WINCODEC_SDK_VERSION = WINCODEC_SDK_VERSION2;

    WINCODEC_DLL ='Windowscodecs.dll';

const
    FACILITY_WINCODEC_ERR = $898;
    WINCODEC_ERR_BASE = $2000;

    WINCODEC_ERR_GENERIC_ERROR = E_FAIL;
    WINCODEC_ERR_INVALIDPARAMETER = E_INVALIDARG;
    WINCODEC_ERR_OUTOFMEMORY = E_OUTOFMEMORY;
    WINCODEC_ERR_NOTIMPLEMENTED = E_NOTIMPL;
    WINCODEC_ERR_ABORTED = E_ABORT;
    WINCODEC_ERR_ACCESSDENIED = E_ACCESSDENIED;
//    WINCODEC_ERR_VALUEOVERFLOW = INTSAFE_E_ARITHMETIC_OVERFLOW;

const
    WICRawChangeNotification_ExposureCompensation = $00000001;
    WICRawChangeNotification_NamedWhitePoint = $00000002;
    WICRawChangeNotification_KelvinWhitePoint = $00000004;
    WICRawChangeNotification_RGBWhitePoint = $00000008;
    WICRawChangeNotification_Contrast = $00000010;
    WICRawChangeNotification_Gamma = $00000020;
    WICRawChangeNotification_Sharpness = $00000040;
    WICRawChangeNotification_Saturation = $00000080;
    WICRawChangeNotification_Tint = $00000100;
    WICRawChangeNotification_NoiseReduction = $00000200;
    WICRawChangeNotification_DestinationColorContext = $00000400;
    WICRawChangeNotification_ToneCurve = $00000800;
    WICRawChangeNotification_Rotation = $00001000;
    WICRawChangeNotification_RenderMode = $00002000;


const
    CLSID_WICImagingFactory: TGUID = '{cacaf262-9370-4615-a13b-9f5539da4c0a}';
    CLSID_WICImagingFactory1: TGUID = '{cacaf262-9370-4615-a13b-9f5539da4c0a}';
    CLSID_WICImagingFactory2: TGUID = '{317d06e8-5f24-433d-bdf7-79ce68d8abc2}';
    GUID_VendorMicrosoft: TGUID = '{f0e749ca-edef-4589-a73a-ee0e626a2a2b}';
    GUID_VendorMicrosoftBuiltIn: TGUID = '{257a30fd-06b6-462b-aea4-63f70b86e533}';
    CLSID_WICPngDecoder: TGUID = '{389ea17b-5078-4cde-b6ef-25c15175c751}';
    CLSID_WICPngDecoder1: TGUID = '{389ea17b-5078-4cde-b6ef-25c15175c751}';
    CLSID_WICPngDecoder2: TGUID = '{e018945b-aa86-4008-9bd4-6777a1e40c11}';
    CLSID_WICBmpDecoder: TGUID = '{6b462062-7cbf-400d-9fdb-813dd10f2778}';
    CLSID_WICIcoDecoder: TGUID = '{c61bfcdf-2e0f-4aad-a8d7-e06bafebcdfe}';
    CLSID_WICJpegDecoder: TGUID = '{9456a480-e88b-43ea-9e73-0b2d9b71b1ca}';
    CLSID_WICGifDecoder: TGUID = '{381dda3c-9ce9-4834-a23e-1f98f8fc52be}';
    CLSID_WICTiffDecoder: TGUID = '{b54e85d9-fe23-499f-8b88-6acea713752b}';
    CLSID_WICWmpDecoder: TGUID = '{a26cec36-234c-4950-ae16-e34aace71d0d}';
    CLSID_WICDdsDecoder: TGUID = '{9053699f-a341-429d-9e90-ee437cf80c73}';
    CLSID_WICBmpEncoder: TGUID = '{69be8bb4-d66d-47c8-865a-ed1589433782}';
    CLSID_WICPngEncoder: TGUID = '{27949969-876a-41d7-9447-568f6a35a4dc}';
    CLSID_WICJpegEncoder: TGUID = '{1a34f5c1-4a5a-46dc-b644-1f4567e7a676}';
    CLSID_WICGifEncoder: TGUID = '{114f5598-0b22-40a0-86a1-c83ea495adbd}';
    CLSID_WICTiffEncoder: TGUID = '{0131be10-2001-4c5f-a9b0-cc88fab64ce8}';
    CLSID_WICWmpEncoder: TGUID = '{ac4ce3cb-e1c1-44cd-8215-5a1665509ec2}';
    CLSID_WICDdsEncoder: TGUID = '{a61dde94-66ce-4ac1-881b-71680588895e}';
    GUID_ContainerFormatBmp: TGUID = '{0af1d87e-fcfe-4188-bdeb-a7906471cbe3}';
    GUID_ContainerFormatPng: TGUID = '{1b7cfaf4-713f-473c-bbcd-6137425faeaf}';
    GUID_ContainerFormatIco: TGUID = '{a3a860c4-338f-4c17-919a-fba4b5628f21}';
    GUID_ContainerFormatJpeg: TGUID = '{19e4a5aa-5662-4fc5-a0c0-1758028e1057}';
    GUID_ContainerFormatTiff: TGUID = '{163bcc30-e2e9-4f0b-961d-a3e9fdb788a3}';
    GUID_ContainerFormatGif: TGUID = '{1f8a5601-7d4d-4cbd-9c82-1bc8d4eeb9a5}';
    GUID_ContainerFormatWmp: TGUID = '{57a37caa-367a-4540-916b-f183c5093a4b}';
    GUID_ContainerFormatDds: TGUID = '{9967cb95-2e85-4ac8-8ca2-83d7ccd425c9}';
    CLSID_WICImagingCategories: TGUID = '{fae3d380-fea4-4623-8c75-c6b61110b681}';
    CATID_WICBitmapDecoders: TGUID = '{7ed96837-96f0-4812-b211-f13c24117ed3}';
    CATID_WICBitmapEncoders: TGUID = '{ac757296-3522-4e11-9862-c17be5a1767e}';
    CATID_WICPixelFormats: TGUID = '{2b46e70f-cda7-473e-89f6-dc9630a2390b}';
    CATID_WICFormatConverters: TGUID = '{7835eae8-bf14-49d1-93ce-533a407b2248}';
    CATID_WICMetadataReader: TGUID = '{05af94d8-7174-4cd2-be4a-4124b80ee4b8}';
    CATID_WICMetadataWriter: TGUID = '{abe3b9a4-257d-4b97-bd1a-294af496222e}';
    CLSID_WICDefaultFormatConverter: TGUID = '{1a3f11dc-b514-4b17-8c5f-2154513852f1}';
    CLSID_WICFormatConverterHighColor: TGUID = '{ac75d454-9f37-48f8-b972-4e19bc856011}';
    CLSID_WICFormatConverterNChannel: TGUID = '{c17cabb2-d4a3-47d7-a557-339b2efbd4f1}';
    CLSID_WICFormatConverterWMPhoto: TGUID = '{9cb5172b-d600-46ba-ab77-77bb7e3a00d9}';
    CLSID_WICPlanarFormatConverter: TGUID = '{184132b8-32f8-4784-9131-dd7224b23438}';
    GUID_WICPixelFormatDontCare: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc900}';
    GUID_WICPixelFormat1bppIndexed: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc901}';
    GUID_WICPixelFormat2bppIndexed: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc902}';
    GUID_WICPixelFormat4bppIndexed: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc903}';
    GUID_WICPixelFormat8bppIndexed: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc904}';
    GUID_WICPixelFormatBlackWhite: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc905}';
    GUID_WICPixelFormat2bppGray: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc906}';
    GUID_WICPixelFormat4bppGray: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc907}';
    GUID_WICPixelFormat8bppGray: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc908}';
    GUID_WICPixelFormat8bppAlpha: TGUID = '{e6cd0116-eeba-4161-aa85-27dd9fb3a895}';
    GUID_WICPixelFormat16bppBGR555: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc909}';
    GUID_WICPixelFormat16bppBGR565: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc90a}';
    GUID_WICPixelFormat16bppBGRA5551: TGUID = '{05ec7c2b-f1e6-4961-ad46-e1cc810a87d2}';
    GUID_WICPixelFormat16bppGray: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc90b}';
    GUID_WICPixelFormat24bppBGR: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc90c}';
    GUID_WICPixelFormat24bppRGB: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc90d}';
    GUID_WICPixelFormat32bppBGR: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc90e}';
    GUID_WICPixelFormat32bppBGRA: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc90f}';
    GUID_WICPixelFormat32bppPBGRA: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc910}';
    GUID_WICPixelFormat32bppGrayFloat: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc911}';
    GUID_WICPixelFormat32bppRGB: TGUID = '{d98c6b95-3efe-47d6-bb25-eb1748ab0cf1}';
    GUID_WICPixelFormat32bppRGBA: TGUID = '{f5c7ad2d-6a8d-43dd-a7a8-a29935261ae9}';
    GUID_WICPixelFormat32bppPRGBA: TGUID = '{3cc4a650-a527-4d37-a916-3142c7ebedba}';
    GUID_WICPixelFormat48bppRGB: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc915}';
    GUID_WICPixelFormat48bppBGR: TGUID = '{e605a384-b468-46ce-bb2e-36f180e64313}';
    GUID_WICPixelFormat64bppRGB: TGUID = '{a1182111-186d-4d42-bc6a-9c8303a8dff9}';
    GUID_WICPixelFormat64bppRGBA: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc916}';
    GUID_WICPixelFormat64bppBGRA: TGUID = '{1562ff7c-d352-46f9-979e-42976b792246}';
    GUID_WICPixelFormat64bppPRGBA: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc917}';
    GUID_WICPixelFormat64bppPBGRA: TGUID = '{8c518e8e-a4ec-468b-ae70-c9a35a9c5530}';
    GUID_WICPixelFormat16bppGrayFixedPoint: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc913}';
    GUID_WICPixelFormat32bppBGR101010: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc914}';
    GUID_WICPixelFormat48bppRGBFixedPoint: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc912}';
    GUID_WICPixelFormat48bppBGRFixedPoint: TGUID = '{49ca140e-cab6-493b-9ddf-60187c37532a}';
    GUID_WICPixelFormat96bppRGBFixedPoint: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc918}';
    GUID_WICPixelFormat96bppRGBFloat: TGUID = '{e3fed78f-e8db-4acf-84c1-e97f6136b327}';
    GUID_WICPixelFormat128bppRGBAFloat: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc919}';
    GUID_WICPixelFormat128bppPRGBAFloat: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc91a}';
    GUID_WICPixelFormat128bppRGBFloat: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc91b}';
    GUID_WICPixelFormat32bppCMYK: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc91c}';
    GUID_WICPixelFormat64bppRGBAFixedPoint: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc91d}';
    GUID_WICPixelFormat64bppBGRAFixedPoint: TGUID = '{356de33c-54d2-4a23-bb04-9b7bf9b1d42d}';
    GUID_WICPixelFormat64bppRGBFixedPoint: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc940}';
    GUID_WICPixelFormat128bppRGBAFixedPoint: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc91e}';
    GUID_WICPixelFormat128bppRGBFixedPoint: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc941}';
    GUID_WICPixelFormat64bppRGBAHalf: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc93a}';
    GUID_WICPixelFormat64bppPRGBAHalf: TGUID = '{58ad26c2-c623-4d9d-b320-387e49f8c442}';
    GUID_WICPixelFormat64bppRGBHalf: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc942}';
    GUID_WICPixelFormat48bppRGBHalf: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc93b}';
    GUID_WICPixelFormat32bppRGBE: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc93d}';
    GUID_WICPixelFormat16bppGrayHalf: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc93e}';
    GUID_WICPixelFormat32bppGrayFixedPoint: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc93f}';
    GUID_WICPixelFormat32bppRGBA1010102: TGUID = '{25238D72-FCF9-4522-b514-5578e5ad55e0}';
    GUID_WICPixelFormat32bppRGBA1010102XR: TGUID = '{00DE6B9A-C101-434b-b502-d0165ee1122c}';
    GUID_WICPixelFormat64bppCMYK: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc91f}';
    GUID_WICPixelFormat24bpp3Channels: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc920}';
    GUID_WICPixelFormat32bpp4Channels: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc921}';
    GUID_WICPixelFormat40bpp5Channels: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc922}';
    GUID_WICPixelFormat48bpp6Channels: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc923}';
    GUID_WICPixelFormat56bpp7Channels: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc924}';
    GUID_WICPixelFormat64bpp8Channels: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc925}';
    GUID_WICPixelFormat48bpp3Channels: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc926}';
    GUID_WICPixelFormat64bpp4Channels: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc927}';
    GUID_WICPixelFormat80bpp5Channels: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc928}';
    GUID_WICPixelFormat96bpp6Channels: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc929}';
    GUID_WICPixelFormat112bpp7Channels: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc92a}';
    GUID_WICPixelFormat128bpp8Channels: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc92b}';
    GUID_WICPixelFormat40bppCMYKAlpha: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc92c}';
    GUID_WICPixelFormat80bppCMYKAlpha: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc92d}';
    GUID_WICPixelFormat32bpp3ChannelsAlpha: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc92e}';
    GUID_WICPixelFormat40bpp4ChannelsAlpha: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc92f}';
    GUID_WICPixelFormat48bpp5ChannelsAlpha: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc930}';
    GUID_WICPixelFormat56bpp6ChannelsAlpha: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc931}';
    GUID_WICPixelFormat64bpp7ChannelsAlpha: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc932}';
    GUID_WICPixelFormat72bpp8ChannelsAlpha: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc933}';
    GUID_WICPixelFormat64bpp3ChannelsAlpha: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc934}';
    GUID_WICPixelFormat80bpp4ChannelsAlpha: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc935}';
    GUID_WICPixelFormat96bpp5ChannelsAlpha: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc936}';
    GUID_WICPixelFormat112bpp6ChannelsAlpha: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc937}';
    GUID_WICPixelFormat128bpp7ChannelsAlpha: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc938}';
    GUID_WICPixelFormat144bpp8ChannelsAlpha: TGUID = '{6fddc324-4e03-4bfe-b185-3d77768dc939}';
    GUID_WICPixelFormat8bppY: TGUID = '{91B4DB54-2DF9-42F0-B449-2909BB3DF88E}';
    GUID_WICPixelFormat8bppCb: TGUID = '{1339F224-6BFE-4C3E-9302-E4F3A6D0CA2A}';
    GUID_WICPixelFormat8bppCr: TGUID = '{B8145053-2116-49F0-8835-ED844B205C51}';
    GUID_WICPixelFormat16bppCbCr: TGUID = '{FF95BA6E-11E0-4263-BB45-01721F3460A4}';

const
    IID_IWICPalette: TGUID = '{00000040-a8f2-4877-ba0a-fd2b6645fb94}';
    IID_IWICBitmapSource: TGUID = '{00000120-a8f2-4877-ba0a-fd2b6645fb94}';
    IID_IWICFormatConverter: TGUID = '{00000301-a8f2-4877-ba0a-fd2b6645fb94}';
    IID_IWICPlanarFormatConverter: TGUID = '{BEBEE9CB-83B0-4DCC-8132-B0AAA55EAC96}';
    IID_IWICBitmapScaler: TGUID = '{00000302-a8f2-4877-ba0a-fd2b6645fb94}';
    IID_IWICBitmapClipper: TGUID = '{E4FBCF03-223D-4e81-9333-D635556DD1B5}';
    IID_IWICBitmapFlipRotator: TGUID = '{5009834F-2D6A-41ce-9E1B-17C5AFF7A782}';
    IID_IWICBitmapLock: TGUID = '{00000123-a8f2-4877-ba0a-fd2b6645fb94}';
    IID_IWICBitmap: TGUID = '{00000121-a8f2-4877-ba0a-fd2b6645fb94}';
    IID_IWICColorContext: TGUID = '{3C613A02-34B2-44ea-9A7C-45AEA9C6FD6D}';
    IID_IWICColorTransform: TGUID = '{B66F034F-D0E2-40ab-B436-6DE39E321A94}';
    IID_IWICFastMetadataEncoder: TGUID = '{B84E2C09-78C9-4AC4-8BD3-524AE1663A2F}';
    IID_IWICStream: TGUID = '{135FF860-22B7-4ddf-B0F6-218F4F299A43}';
    IID_IWICEnumMetadataItem: TGUID = '{DC2BB46D-3F07-481E-8625-220C4AEDBB33}';
    IID_IWICMetadataQueryReader: TGUID = '{30989668-E1C9-4597-B395-458EEDB808DF}';
    IID_IWICMetadataQueryWriter: TGUID = '{A721791A-0DEF-4d06-BD91-2118BF1DB10B}';
    IID_IWICBitmapEncoder: TGUID = '{00000103-a8f2-4877-ba0a-fd2b6645fb94}';
    IID_IWICBitmapFrameEncode: TGUID = '{00000105-a8f2-4877-ba0a-fd2b6645fb94}';
    IID_IWICPlanarBitmapFrameEncode: TGUID = '{F928B7B8-2221-40C1-B72E-7E82F1974D1A}';
    IID_IWICImageEncoder: TGUID = '{04C75BF8-3CE1-473B-ACC5-3CC4F5E94999}';
    IID_IWICBitmapDecoder: TGUID = '{9EDDE9E7-8DEE-47ea-99DF-E6FAF2ED44BF}';

    IID_IWICBitmapSourceTransform: TGUID = '{3B16811B-6A43-4ec9-B713-3D5A0C13B940}';
    IID_IWICPlanarBitmapSourceTransform: TGUID = '{3AFF9CCE-BE95-4303-B927-E7D16FF4A613}';
    IID_IWICBitmapFrameDecode: TGUID = '{3B16811B-6A43-4ec9-A813-3D930C13B940}';
    IID_IWICProgressiveLevelControl: TGUID = '{DAAC296F-7AA5-4dbf-8D15-225C5976F891}';
    IID_IWICProgressCallback: TGUID = '{4776F9CD-9517-45FA-BF24-E89C5EC5C60C}';
    IID_IWICBitmapCodecProgressNotification: TGUID = '{64C1024E-C3CF-4462-8078-88C2B11C46D9}';

    IID_IWICComponentInfo: TGUID = '{23BC3F0A-698B-4357-886B-F24D50671334}';
    IID_IWICBitmapCodecInfo: TGUID = '{E87A44C4-B76E-4c47-8B09-298EB12A2714}';
    IID_IWICFormatConverterInfo: TGUID = '{9F34FB65-13F4-4f15-BC57-3726B5E53D9F}';
    IID_IWICBitmapEncoderInfo: TGUID = '{94C9B4EE-A09F-4f92-8A1E-4A9BCE7E76FB}';
    IID_IWICBitmapDecoderInfo: TGUID = '{D8CD007F-D08F-4191-9BFC-236EA7F0E4B5}';
    IID_IWICPixelFormatInfo: TGUID = '{E8EDA601-3D48-431a-AB44-69059BE88BBE}';
    IID_IWICPixelFormatInfo2: TGUID = '{A9DB33A2-AF5F-43C7-B679-74F5984B5AA4}';
    IID_IWICImagingFactory: TGUID = '{ec5ec8a9-c395-4314-9c77-54d7a935ff70}';

    IID_IWICImagingFactory2: TGUID = '{7B816B45-1996-4476-B132-DE9E247C8AF0}';
    IID_IWICDevelopRawNotificationCallback: TGUID = '{95c75a6e-3e8c-4ec2-85a8-aebcc551e59b}';
    IID_IWICDevelopRaw: TGUID = '{fbec5e44-f7be-4b65-b7f8-c0c81fef026d}';

    IID_IWICDdsDecoder: TGUID = '{409cd537-8532-40cb-9774-e2feb2df4e9c}';
    IID_IWICDdsEncoder: TGUID = '{5cacdb4c-407e-41b3-b936-d0f010cd6732}';
    IID_IWICDdsFrameDecode: TGUID = '{3d4c0c61-18a4-41e4-bd80-481a4fc9f464}';

type

    WICInProcPointer = PByte;
    PWICInProcPointer = Pointer;

    TREFWICPixelFormatGUID = TGUID;
    //PREFWICPixelFormatGUID = ^TREFWICPixelFormatGUID;

    TWICPixelFormatGUID = TGUID;
    PWICPixelFormatGUID = ^TWICPixelFormatGUID;

    TWICColor = UINT32;
    PWICColor = ^TWICColor;

    TWICColorArray = array of TWICColor;
    PWICColorArray = ^TWICColorArray;

    TWICRect = record
        X: INT32;
        Y: INT32;
        Width: INT32;
        Height: INT32;
    end;
    PWICRect = ^TWICRect;

    TWICColorContextType = (
        WICColorContextUninitialized = 0,
        WICColorContextProfile = $1,
        WICColorContextExifColorSpace = $2
        );


    TWICBitmapCreateCacheOption = (
        WICBitmapNoCache = 0,
        WICBitmapCacheOnDemand = $1,
        WICBitmapCacheOnLoad = $2,
        WICBITMAPCREATECACHEOPTION_FORCE_DWORD = $7fffffff
        );


    TWICDecodeOptions = (
        WICDecodeMetadataCacheOnDemand = 0,
        WICDecodeMetadataCacheOnLoad = $1,
        WICMETADATACACHEOPTION_FORCE_DWORD = $7fffffff
        );


    TWICBitmapEncoderCacheOption = (
        WICBitmapEncoderCacheInMemory = 0,
        WICBitmapEncoderCacheTempFile = $1,
        WICBitmapEncoderNoCache = $2,
        WICBITMAPENCODERCACHEOPTION_FORCE_DWORD = $7fffffff
        );


    TWICComponentType = (
        WICDecoder = $1,
        WICEncoder = $2,
        WICPixelFormatConverter = $4,
        WICMetadataReader = $8,
        WICMetadataWriter = $10,
        WICPixelFormat = $20,
        WICAllComponents = $3f,
        WICCOMPONENTTYPE_FORCE_DWORD = $7fffffff);


    TWICComponentEnumerateOptions = (
        WICComponentEnumerateDefault = 0,
        WICComponentEnumerateRefresh = $1,
        WICComponentEnumerateDisabled = $80000000,
        WICComponentEnumerateUnsigned = $40000000,
        WICComponentEnumerateBuiltInOnly = $20000000,
        WICCOMPONENTENUMERATEOPTIONS_FORCE_DWORD = $7fffffff
        );


    TWICBitmapPattern = record
        Position: ULARGE_INTEGER;
        Length: ULONG;
        Pattern: PBYTE;
        Mask: PBYTE;
        EndOfStream: longbool;
    end;
    PWICBitmapPattern = ^TWICBitmapPattern;


    TWICBitmapInterpolationMode = (
        WICBitmapInterpolationModeNearestNeighbor = 0,
        WICBitmapInterpolationModeLinear = $1,
        WICBitmapInterpolationModeCubic = $2,
        WICBitmapInterpolationModeFant = $3,
        WICBITMAPINTERPOLATIONMODE_FORCE_DWORD = $7fffffff
        );


    TWICBitmapPaletteType = (
        WICBitmapPaletteTypeCustom = 0,
        WICBitmapPaletteTypeMedianCut = $1,
        WICBitmapPaletteTypeFixedBW = $2,
        WICBitmapPaletteTypeFixedHalftone8 = $3,
        WICBitmapPaletteTypeFixedHalftone27 = $4,
        WICBitmapPaletteTypeFixedHalftone64 = $5,
        WICBitmapPaletteTypeFixedHalftone125 = $6,
        WICBitmapPaletteTypeFixedHalftone216 = $7,
        WICBitmapPaletteTypeFixedWebPalette = WICBitmapPaletteTypeFixedHalftone216,
        WICBitmapPaletteTypeFixedHalftone252 = $8,
        WICBitmapPaletteTypeFixedHalftone256 = $9,
        WICBitmapPaletteTypeFixedGray4 = $a,
        WICBitmapPaletteTypeFixedGray16 = $b,
        WICBitmapPaletteTypeFixedGray256 = $c,
        WICBITMAPPALETTETYPE_FORCE_DWORD = $7fffffff
        );


    TWICBitmapDitherType = (
        WICBitmapDitherTypeNone = 0,
        WICBitmapDitherTypeSolid = 0,
        WICBitmapDitherTypeOrdered4x4 = $1,
        WICBitmapDitherTypeOrdered8x8 = $2,
        WICBitmapDitherTypeOrdered16x16 = $3,
        WICBitmapDitherTypeSpiral4x4 = $4,
        WICBitmapDitherTypeSpiral8x8 = $5,
        WICBitmapDitherTypeDualSpiral4x4 = $6,
        WICBitmapDitherTypeDualSpiral8x8 = $7,
        WICBitmapDitherTypeErrorDiffusion = $8,
        WICBITMAPDITHERTYPE_FORCE_DWORD = $7fffffff
        );


    TWICBitmapAlphaChannelOption = (
        WICBitmapUseAlpha = 0,
        WICBitmapUsePremultipliedAlpha = $1,
        WICBitmapIgnoreAlpha = $2,
        WICBITMAPALPHACHANNELOPTIONS_FORCE_DWORD = $7fffffff
        );


    TWICBitmapTransformOptions = (
        WICBitmapTransformRotate0 = 0,
        WICBitmapTransformRotate90 = $1,
        WICBitmapTransformRotate180 = $2,
        WICBitmapTransformRotate270 = $3,
        WICBitmapTransformFlipHorizontal = $8,
        WICBitmapTransformFlipVertical = $10,
        WICBITMAPTRANSFORMOPTIONS_FORCE_DWORD = $7fffffff
        );


    TWICBitmapLockFlags = (
        WICBitmapLockRead = $1,
        WICBitmapLockWrite = $2,
        WICBITMAPLOCKFLAGS_FORCE_DWORD = $7fffffff
        );


    TWICBitmapDecoderCapabilities = (
        WICBitmapDecoderCapabilitySameEncoder = $1,
        WICBitmapDecoderCapabilityCanDecodeAllImages = $2,
        WICBitmapDecoderCapabilityCanDecodeSomeImages = $4,
        WICBitmapDecoderCapabilityCanEnumerateMetadata = $8,
        WICBitmapDecoderCapabilityCanDecodeThumbnail = $10,
        WICBITMAPDECODERCAPABILITIES_FORCE_DWORD = $7fffffff
        );


    TWICProgressOperation = (
        WICProgressOperationCopyPixels = $1,
        WICProgressOperationWritePixels = $2,
        WICProgressOperationAll = $ffff,
        WICPROGRESSOPERATION_FORCE_DWORD = $7fffffff
        );


    TWICProgressNotification = (
        WICProgressNotificationBegin = $10000,
        WICProgressNotificationEnd = $20000,
        WICProgressNotificationFrequent = $40000,
        WICProgressNotificationAll = $ffff0000,
        WICPROGRESSNOTIFICATION_FORCE_DWORD = $7fffffff
        );


    TWICComponentSigning = (
        WICComponentSigned = $1,
        WICComponentUnsigned = $2,
        WICComponentSafe = $4,
        WICComponentDisabled = $80000000,
        WICCOMPONENTSIGNING_FORCE_DWORD = $7fffffff
        );


    TWICGifLogicalScreenDescriptorProperties = (
        WICGifLogicalScreenSignature = $1,
        WICGifLogicalScreenDescriptorWidth = $2,
        WICGifLogicalScreenDescriptorHeight = $3,
        WICGifLogicalScreenDescriptorGlobalColorTableFlag = $4,
        WICGifLogicalScreenDescriptorColorResolution = $5,
        WICGifLogicalScreenDescriptorSortFlag = $6,
        WICGifLogicalScreenDescriptorGlobalColorTableSize = $7,
        WICGifLogicalScreenDescriptorBackgroundColorIndex = $8,
        WICGifLogicalScreenDescriptorPixelAspectRatio = $9,
        WICGifLogicalScreenDescriptorProperties_FORCE_DWORD = $7fffffff
        );


    TWICGifImageDescriptorProperties = (
        WICGifImageDescriptorLeft = $1,
        WICGifImageDescriptorTop = $2,
        WICGifImageDescriptorWidth = $3,
        WICGifImageDescriptorHeight = $4,
        WICGifImageDescriptorLocalColorTableFlag = $5,
        WICGifImageDescriptorInterlaceFlag = $6,
        WICGifImageDescriptorSortFlag = $7,
        WICGifImageDescriptorLocalColorTableSize = $8,
        WICGifImageDescriptorProperties_FORCE_DWORD = $7fffffff
        );


    TWICGifGraphicControlExtensionProperties = (
        WICGifGraphicControlExtensionDisposal = $1,
        WICGifGraphicControlExtensionUserInputFlag = $2,
        WICGifGraphicControlExtensionTransparencyFlag = $3,
        WICGifGraphicControlExtensionDelay = $4,
        WICGifGraphicControlExtensionTransparentColorIndex = $5,
        WICGifGraphicControlExtensionProperties_FORCE_DWORD = $7fffffff
        );


    TWICGifApplicationExtensionProperties = (
        WICGifApplicationExtensionApplication = $1,
        WICGifApplicationExtensionData = $2,
        WICGifApplicationExtensionProperties_FORCE_DWORD = $7fffffff
        );


    TWICGifCommentExtensionProperties = (
        WICGifCommentExtensionText = $1,
        WICGifCommentExtensionProperties_FORCE_DWORD = $7fffffff
        );


    TWICJpegCommentProperties = (
        WICJpegCommentText = $1,
        WICJpegCommentProperties_FORCE_DWORD = $7fffffff
        );


    TWICJpegLuminanceProperties = (
        WICJpegLuminanceTable = $1,
        WICJpegLuminanceProperties_FORCE_DWORD = $7fffffff
        );


    TWICJpegChrominanceProperties = (
        WICJpegChrominanceTable = $1,
        WICJpegChrominanceProperties_FORCE_DWORD = $7fffffff
        );


    TWIC8BIMIptcProperties = (
        WIC8BIMIptcPString = 0,
        WIC8BIMIptcEmbeddedIPTC = $1,
        WIC8BIMIptcProperties_FORCE_DWORD = $7fffffff
        );


    TWIC8BIMResolutionInfoProperties = (
        WIC8BIMResolutionInfoPString = $1,
        WIC8BIMResolutionInfoHResolution = $2,
        WIC8BIMResolutionInfoHResolutionUnit = $3,
        WIC8BIMResolutionInfoWidthUnit = $4,
        WIC8BIMResolutionInfoVResolution = $5,
        WIC8BIMResolutionInfoVResolutionUnit = $6,
        WIC8BIMResolutionInfoHeightUnit = $7,
        WIC8BIMResolutionInfoProperties_FORCE_DWORD = $7fffffff
        );


    TWIC8BIMIptcDigestProperties = (
        WIC8BIMIptcDigestPString = $1,
        WIC8BIMIptcDigestIptcDigest = $2,
        WIC8BIMIptcDigestProperties_FORCE_DWORD = $7fffffff
        );


    TWICPngGamaProperties = (
        WICPngGamaGamma = $1,
        WICPngGamaProperties_FORCE_DWORD = $7fffffff
        );


    TWICPngBkgdProperties = (
        WICPngBkgdBackgroundColor = $1,
        WICPngBkgdProperties_FORCE_DWORD = $7fffffff
        );


    TWICPngItxtProperties = (
        WICPngItxtKeyword = $1,
        WICPngItxtCompressionFlag = $2,
        WICPngItxtLanguageTag = $3,
        WICPngItxtTranslatedKeyword = $4,
        WICPngItxtText = $5,
        WICPngItxtProperties_FORCE_DWORD = $7fffffff
        );


    TWICPngChrmProperties = (
        WICPngChrmWhitePointX = $1,
        WICPngChrmWhitePointY = $2,
        WICPngChrmRedX = $3,
        WICPngChrmRedY = $4,
        WICPngChrmGreenX = $5,
        WICPngChrmGreenY = $6,
        WICPngChrmBlueX = $7,
        WICPngChrmBlueY = $8,
        WICPngChrmProperties_FORCE_DWORD = $7fffffff
        );


    TWICPngHistProperties = (
        WICPngHistFrequencies = $1,
        WICPngHistProperties_FORCE_DWORD = $7fffffff
        );


    TWICPngIccpProperties = (
        WICPngIccpProfileName = $1,
        WICPngIccpProfileData = $2,
        WICPngIccpProperties_FORCE_DWORD = $7fffffff
        );


    TWICPngSrgbProperties = (
        WICPngSrgbRenderingIntent = $1,
        WICPngSrgbProperties_FORCE_DWORD = $7fffffff
        );


    TWICPngTimeProperties = (
        WICPngTimeYear = $1,
        WICPngTimeMonth = $2,
        WICPngTimeDay = $3,
        WICPngTimeHour = $4,
        WICPngTimeMinute = $5,
        WICPngTimeSecond = $6,
        WICPngTimeProperties_FORCE_DWORD = $7fffffff
        );


    TWICSectionAccessLevel = (
        WICSectionAccessLevelRead = $1,
        WICSectionAccessLevelReadWrite = $3,
        WICSectionAccessLevel_FORCE_DWORD = $7fffffff
        );


    TWICPixelFormatNumericRepresentation = (
        WICPixelFormatNumericRepresentationUnspecified = 0,
        WICPixelFormatNumericRepresentationIndexed = $1,
        WICPixelFormatNumericRepresentationUnsignedInteger = $2,
        WICPixelFormatNumericRepresentationSignedInteger = $3,
        WICPixelFormatNumericRepresentationFixed = $4,
        WICPixelFormatNumericRepresentationFloat = $5,
        WICPixelFormatNumericRepresentation_FORCE_DWORD = $7fffffff
        );


    TWICPlanarOptions = (
        WICPlanarOptionsDefault = 0,
        WICPlanarOptionsPreserveSubsampling = $1,
        WICPLANAROPTIONS_FORCE_DWORD = $7fffffff
        );


    TWICImageParameters = record
        PixelFormat: TD2D1_PIXEL_FORMAT;
        DpiX: single;
        DpiY: single;
        Top: single;
        Left: single;
        PixelWidth: UINT32;
        PixelHeight: UINT32;
    end;
    PWICImageParameters = ^TWICImageParameters;

    TWICBitmapPlaneDescription = record
        Format: TWICPixelFormatGUID;
        Width: UINT;
        Height: UINT;
    end;
    PWICBitmapPlaneDescription = ^TWICBitmapPlaneDescription;

    TWICBitmapPlane = record
        Format: TWICPixelFormatGUID;
        pbBuffer: PBYTE;
        cbStride: UINT;
        cbBufferSize: UINT;
    end;
    PWICBitmapPlane = ^TWICBitmapPlane;

    TWICTiffCompressionOption = (
        WICTiffCompressionDontCare = 0,
        WICTiffCompressionNone = $1,
        WICTiffCompressionCCITT3 = $2,
        WICTiffCompressionCCITT4 = $3,
        WICTiffCompressionLZW = $4,
        WICTiffCompressionRLE = $5,
        WICTiffCompressionZIP = $6,
        WICTiffCompressionLZWHDifferencing = $7,
        WICTIFFCOMPRESSIONOPTION_FORCE_DWORD = $7fffffff
        );


    TWICJpegYCrCbSubsamplingOption = (
        WICJpegYCrCbSubsamplingDefault = 0,
        WICJpegYCrCbSubsampling420 = $1,
        WICJpegYCrCbSubsampling422 = $2,
        WICJpegYCrCbSubsampling444 = $3,
        WICJpegYCrCbSubsampling440 = $4,
        WICJPEGYCRCBSUBSAMPLING_FORCE_DWORD = $7fffffff
        );


    TWICPngFilterOption = (
        WICPngFilterUnspecified = 0,
        WICPngFilterNone = $1,
        WICPngFilterSub = $2,
        WICPngFilterUp = $3,
        WICPngFilterAverage = $4,
        WICPngFilterPaeth = $5,
        WICPngFilterAdaptive = $6,
        WICPNGFILTEROPTION_FORCE_DWORD = $7fffffff
        );


    TWICNamedWhitePoint = (
        WICWhitePointDefault = $1,
        WICWhitePointDaylight = $2,
        WICWhitePointCloudy = $4,
        WICWhitePointShade = $8,
        WICWhitePointTungsten = $10,
        WICWhitePointFluorescent = $20,
        WICWhitePointFlash = $40,
        WICWhitePointUnderwater = $80,
        WICWhitePointCustom = $100,
        WICWhitePointAutoWhiteBalance = $200,
        WICWhitePointAsShot = WICWhitePointDefault,
        WICNAMEDWHITEPOINT_FORCE_DWORD = $7fffffff
        );


    TWICRawCapabilities = (
        WICRawCapabilityNotSupported = 0,
        WICRawCapabilityGetSupported = $1,
        WICRawCapabilityFullySupported = $2,
        WICRAWCAPABILITIES_FORCE_DWORD = $7fffffff
        );


    TWICRawRotationCapabilities = (
        WICRawRotationCapabilityNotSupported = 0,
        WICRawRotationCapabilityGetSupported = $1,
        WICRawRotationCapabilityNinetyDegreesSupported = $2,
        WICRawRotationCapabilityFullySupported = $3,
        WICRAWROTATIONCAPABILITIES_FORCE_DWORD = $7fffffff
        );


    TWICRawCapabilitiesInfo = record
        cbSize: UINT;
        CodecMajorVersion: UINT;
        CodecMinorVersion: UINT;
        ExposureCompensationSupport: TWICRawCapabilities;
        ContrastSupport: TWICRawCapabilities;
        RGBWhitePointSupport: TWICRawCapabilities;
        NamedWhitePointSupport: TWICRawCapabilities;
        NamedWhitePointSupportMask: UINT;
        KelvinWhitePointSupport: TWICRawCapabilities;
        GammaSupport: TWICRawCapabilities;
        TintSupport: TWICRawCapabilities;
        SaturationSupport: TWICRawCapabilities;
        SharpnessSupport: TWICRawCapabilities;
        NoiseReductionSupport: TWICRawCapabilities;
        DestinationColorProfileSupport: TWICRawCapabilities;
        ToneCurveSupport: TWICRawCapabilities;
        RotationSupport: TWICRawRotationCapabilities;
        RenderModeSupport: TWICRawCapabilities;
    end;

    PWICRawCapabilitiesInfo = ^TWICRawCapabilitiesInfo;

    TWICRawParameterSet = (
        WICAsShotParameterSet = $1,
        WICUserAdjustedParameterSet = $2,
        WICAutoAdjustedParameterSet = $3,
        WICRAWPARAMETERSET_FORCE_DWORD = $7fffffff
        );


    TWICRawRenderMode = (
        WICRawRenderModeDraft = $1,
        WICRawRenderModeNormal = $2,
        WICRawRenderModeBestQuality = $3,
        WICRAWRENDERMODE_FORCE_DWORD = $7fffffff
        );

    TWICRawToneCurvePoint = record
        Input: double;
        Output: double;
    end;
    PWICRawToneCurvePoint = ^TWICRawToneCurvePoint;

    TWICRawToneCurve = record
        cPoints: UINT;
        aPoints: array [0..0] of TWICRawToneCurvePoint;
    end;

    PWICRawToneCurve = ^TWICRawToneCurve;


    TWICDdsDimension = (
        WICDdsTexture1D = 0,
        WICDdsTexture2D = $1,
        WICDdsTexture3D = $2,
        WICDdsTextureCube = $3,
        WICDDSTEXTURE_FORCE_DWORD = $7fffffff
        );

    TWICDdsAlphaMode = (
        WICDdsAlphaModeUnknown = 0,
        WICDdsAlphaModeStraight = $1,
        WICDdsAlphaModePremultiplied = $2,
        WICDdsAlphaModeOpaque = $3,
        WICDdsAlphaModeCustom = $4,
        WICDDSALPHAMODE_FORCE_DWORD = $7fffffff
        );

    TWICDdsParameters = record
        Width: UINT;
        Height: UINT;
        Depth: UINT;
        MipLevels: UINT;
        ArraySize: UINT;
        DxgiFormat: TDXGI_FORMAT;
        Dimension: TWICDdsDimension;
        AlphaMode: TWICDdsAlphaMode;
    end;
    PWICDdsParameters = ^TWICDdsParameters;

    TWICDdsFormatInfo = record
        DxgiFormat: TDXGI_FORMAT;
        BytesPerBlock: UINT;
        BlockWidth: UINT;
        BlockHeight: UINT;
    end;

    PWICDdsFormatInfo = ^TWICDdsFormatInfo;

    IWICBitmapSource = interface;
    PIWICBitmapSource = ^IWICBitmapSource;


    IWICPalette = interface(IUnknown)
        ['{00000040-a8f2-4877-ba0a-fd2b6645fb94}']
        function InitializePredefined(ePaletteType: TWICBitmapPaletteType; fAddTransparentColor: longbool): HResult; stdcall;
        function InitializeCustom(pColors: PWICColor; cCount: UINT): HResult; stdcall;
        function InitializeFromBitmap(pISurface: IWICBitmapSource; cCount: UINT; fAddTransparentColor: longbool): HResult; stdcall;
        function InitializeFromPalette(pIPalette: IWICPalette): HResult; stdcall;
        function GetType(out pePaletteType: TWICBitmapPaletteType): HResult; stdcall;
        function GetColorCount(out pcCount: UINT): HResult; stdcall;
        function GetColors(cCount: UINT; var {out ??? } pColors: PWICColor; out pcActualColors: UINT): HResult; stdcall;
        function IsBlackWhite(out pfIsBlackWhite: longbool): HResult; stdcall;
        function IsGrayscale(out pfIsGrayscale: longbool): HResult; stdcall;
        function HasAlpha(out pfHasAlpha: longbool): HResult; stdcall;
    end;


    IWICBitmapSource = interface(IUnknown)
        ['{00000120-a8f2-4877-ba0a-fd2b6645fb94}']
        function GetSize(out puiWidth: UINT; out puiHeight: UINT): HResult; stdcall;
        function GetPixelFormat(out pPixelFormat: TWICPixelFormatGUID): HResult; stdcall;
        function GetResolution(out pDpiX: double; out pDpiY: double): HResult; stdcall;
        function CopyPalette(pIPalette: IWICPalette): HResult; stdcall;
        function CopyPixels(prc: PWICRect; cbStride: UINT; cbBufferSize: UINT; out pbBuffer: PBYTE): HResult; stdcall;
    end;


    IWICFormatConverter = interface(IWICBitmapSource)
        ['{00000301-a8f2-4877-ba0a-fd2b6645fb94}']
        function Initialize(pISource: IWICBitmapSource;const dstFormat: TREFWICPixelFormatGUID; dither: TWICBitmapDitherType;
            pIPalette: IWICPalette; alphaThresholdPercent: double; paletteTranslate: TWICBitmapPaletteType): HResult; stdcall;
        function CanConvert(const srcPixelFormat: TREFWICPixelFormatGUID; const dstPixelFormat: TREFWICPixelFormatGUID;
            out pfCanConvert: longbool): HResult; stdcall;
    end;


    IWICPlanarFormatConverter = interface(IWICBitmapSource)
        ['{BEBEE9CB-83B0-4DCC-8132-B0AAA55EAC96}']
        function Initialize(ppPlanes: PIWICBitmapSource; cPlanes: UINT; const dstFormat: TREFWICPixelFormatGUID;
            dither: TWICBitmapDitherType; pIPalette: IWICPalette; alphaThresholdPercent: double;
            paletteTranslate: TWICBitmapPaletteType): HResult; stdcall;
        function CanConvert(pSrcPixelFormats: PWICPixelFormatGUID; cSrcPlanes: UINT; const dstPixelFormat: TREFWICPixelFormatGUID;
            out pfCanConvert: longbool): HResult; stdcall;
    end;


    IWICBitmapScaler = interface(IWICBitmapSource)
        ['{00000302-a8f2-4877-ba0a-fd2b6645fb94}']
        function Initialize(pISource: IWICBitmapSource; uiWidth: UINT; uiHeight: UINT;
            mode: TWICBitmapInterpolationMode): HResult; stdcall;
    end;


    IWICBitmapClipper = interface(IWICBitmapSource)
        ['{E4FBCF03-223D-4e81-9333-D635556DD1B5}']
        function Initialize(pISource: IWICBitmapSource; prc: PWICRect): HResult; stdcall;
    end;


    IWICBitmapFlipRotator = interface(IWICBitmapSource)
        ['{5009834F-2D6A-41ce-9E1B-17C5AFF7A782}']
        function Initialize(pISource: IWICBitmapSource; options: TWICBitmapTransformOptions): HResult; stdcall;
    end;


    IWICBitmapLock = interface(IUnknown)
        ['{00000123-a8f2-4877-ba0a-fd2b6645fb94}']
        function GetSize(out puiWidth: UINT; out puiHeight: UINT): HResult; stdcall;
        function GetStride(out pcbStride: UINT): HResult; stdcall;
        function GetDataPointer(out pcbBufferSize: UINT; out ppbData: PWICInProcPointer): HResult; stdcall;
        function GetPixelFormat(out pPixelFormat: TWICPixelFormatGUID): HResult; stdcall;
    end;


    IWICBitmap = interface(IWICBitmapSource)
        ['{00000121-a8f2-4877-ba0a-fd2b6645fb94}']
        function Lock(prcLock: PWICRect; flags: DWORD; out ppILock: IWICBitmapLock): HResult; stdcall;
        function SetPalette(pIPalette: IWICPalette): HResult; stdcall;
        function SetResolution(dpiX: double; dpiY: double): HResult; stdcall;
    end;

    PIWICBitmap = ^IWICBitmap;


    IWICColorContext = interface(IUnknown)
        ['{3C613A02-34B2-44ea-9A7C-45AEA9C6FD6D}']
        function InitializeFromFilename(wzFilename: PWideChar): HResult; stdcall;
        function InitializeFromMemory(pbBuffer: PBYTE; cbBufferSize: UINT): HResult; stdcall;
        function InitializeFromExifColorSpace(Value: UINT): HResult; stdcall;
        function GetType(out pType: TWICColorContextType): HResult; stdcall;
        function GetProfileBytes(cbBuffer: UINT; var pbBuffer: PBYTE; out pcbActual: UINT): HResult; stdcall;
        function GetExifColorSpace(out pValue: UINT): HResult; stdcall;
    end;

    PIWICColorContext = ^IWICColorContext;

    IWICColorTransform = interface(IWICBitmapSource)
        ['{B66F034F-D0E2-40ab-B436-6DE39E321A94}']
        function Initialize(pIBitmapSource: IWICBitmapSource; pIContextSource: IWICColorContext;
            pIContextDest: IWICColorContext; const pixelFmtDest: TREFWICPixelFormatGUID): HResult; stdcall;
    end;

    IWICMetadataQueryWriter = interface;

    IWICFastMetadataEncoder = interface(IUnknown)
        ['{B84E2C09-78C9-4AC4-8BD3-524AE1663A2F}']
        function Commit(): HResult; stdcall;
        function GetMetadataQueryWriter(out ppIMetadataQueryWriter: IWICMetadataQueryWriter): HResult; stdcall;
    end;


    IWICStream = interface(IStream)
        ['{135FF860-22B7-4ddf-B0F6-218F4F299A43}']
        function InitializeFromIStream(pIStream: IStream): HResult; stdcall;
        function InitializeFromFilename(wzFileName: PWideChar; dwDesiredAccess: DWORD): HResult; stdcall;
        function InitializeFromMemory(pbBuffer: PWICInProcPointer; cbBufferSize: DWORD): HResult; stdcall;
        function InitializeFromIStreamRegion(pIStream: IStream; ulOffset: ULARGE_INTEGER; ulMaxSize: ULARGE_INTEGER): HResult; stdcall;
    end;


    IWICEnumMetadataItem = interface(IUnknown)
        ['{DC2BB46D-3F07-481E-8625-220C4AEDBB33}']
        function Next(celt: ULONG; var rgeltSchema: PPROPVARIANT; var rgeltId: PPROPVARIANT; var rgeltValue: PPROPVARIANT;
            out pceltFetched: ULONG): HResult; stdcall;
        function Skip(celt: ULONG): HResult; stdcall;
        function Reset(): HResult; stdcall;
        function Clone(out ppIEnumMetadataItem: IWICEnumMetadataItem): HResult; stdcall;
    end;


    IWICMetadataQueryReader = interface(IUnknown)
        ['{30989668-E1C9-4597-B395-458EEDB808DF}']
        function GetContainerFormat(out pguidContainerFormat: TGUID): HResult; stdcall;
        function GetLocation(cchMaxLength: UINT; var wzNamespace: PWideChar; out pcchActualLength: UINT): HResult; stdcall;
        function GetMetadataByName(wzName: PWideChar; var pvarValue: TPROPVARIANT): HResult; stdcall;
        function GetEnumerator(out ppIEnumString: IEnumString): HResult; stdcall;
    end;


    IWICMetadataQueryWriter = interface(IWICMetadataQueryReader)
        ['{A721791A-0DEF-4d06-BD91-2118BF1DB10B}']
        function SetMetadataByName(wzName: PWideChar; pvarValue: PPROPVARIANT): HResult; stdcall;
        function RemoveMetadataByName(wzName: PWideChar): HResult; stdcall;
    end;

    IWICBitmapFrameEncode = interface;
    IWICBitmapEncoderInfo = interface;

    IWICBitmapEncoder = interface(IUnknown)
        ['{00000103-a8f2-4877-ba0a-fd2b6645fb94}']
        function Initialize(pIStream: IStream; cacheOption: TWICBitmapEncoderCacheOption): HResult; stdcall;
        function GetContainerFormat(out pguidContainerFormat: TGUID): HResult; stdcall;
        function GetEncoderInfo(out ppIEncoderInfo: IWICBitmapEncoderInfo): HResult; stdcall;
        function SetColorContexts(cCount: UINT; ppIColorContext: PIWICColorContext): HResult; stdcall;
        function SetPalette(pIPalette: IWICPalette): HResult; stdcall;
        function SetThumbnail(pIThumbnail: IWICBitmapSource): HResult; stdcall;
        function SetPreview(pIPreview: IWICBitmapSource): HResult; stdcall;
        function CreateNewFrame(out ppIFrameEncode: IWICBitmapFrameEncode; var ppIEncoderOptions: IPropertyBag2): HResult; stdcall;
        function Commit(): HResult; stdcall;
        function GetMetadataQueryWriter(out ppIMetadataQueryWriter: IWICMetadataQueryWriter): HResult; stdcall;
    end;


    IWICBitmapFrameEncode = interface(IUnknown)
        ['{00000105-a8f2-4877-ba0a-fd2b6645fb94}']
        function Initialize(pIEncoderOptions: IPropertyBag2): HResult; stdcall;
        function SetSize(uiWidth: UINT; uiHeight: UINT): HResult; stdcall;
        function SetResolution(dpiX: double; dpiY: double): HResult; stdcall;
        function SetPixelFormat(var pPixelFormat: TWICPixelFormatGUID): HResult; stdcall;
        function SetColorContexts(cCount: UINT; ppIColorContext: PIWICColorContext): HResult; stdcall;
        function SetPalette(pIPalette: IWICPalette): HResult; stdcall;
        function SetThumbnail(pIThumbnail: IWICBitmapSource): HResult; stdcall;
        function WritePixels(lineCount: UINT; cbStride: UINT; cbBufferSize: UINT; pbPixels: PBYTE): HResult; stdcall;
        function WriteSource(pIBitmapSource: IWICBitmapSource; prc: PWICRect): HResult; stdcall;
        function Commit(): HResult; stdcall;
        function GetMetadataQueryWriter(out ppIMetadataQueryWriter: IWICMetadataQueryWriter): HResult; stdcall;
    end;


    IWICPlanarBitmapFrameEncode = interface(IUnknown)
        ['{F928B7B8-2221-40C1-B72E-7E82F1974D1A}']
        function WritePixels(lineCount: UINT; pPlanes: PWICBitmapPlane; cPlanes: UINT): HResult; stdcall;
        function WriteSource(ppPlanes: PIWICBitmapSource; cPlanes: UINT; prcSource: PWICRect): HResult; stdcall;
    end;

    IWICBitmapDecoderInfo = interface;
    IWICBitmapFrameDecode = interface;

    IWICBitmapDecoder = interface(IUnknown)
        ['{9EDDE9E7-8DEE-47ea-99DF-E6FAF2ED44BF}']
        function QueryCapability(pIStream: IStream; out pdwCapability: DWORD): HResult; stdcall;
        function Initialize(pIStream: IStream; cacheOptions: TWICDecodeOptions): HResult; stdcall;
        function GetContainerFormat(out pguidContainerFormat: TGUID): HResult; stdcall;
        function GetDecoderInfo(out pIDecoderInfo: IWICBitmapDecoderInfo): HResult; stdcall;
        function CopyPalette(pIPalette: IWICPalette): HResult; stdcall;
        function GetMetadataQueryReader(out ppIMetadataQueryReader: IWICMetadataQueryReader): HResult; stdcall;
        function GetPreview(out ppIBitmapSource: IWICBitmapSource): HResult; stdcall;
        function GetColorContexts(cCount: UINT; var ppIColorContexts: PIWICColorContext; out pcActualCount: UINT): HResult; stdcall;
        function GetThumbnail(out ppIThumbnail: IWICBitmapSource): HResult; stdcall;
        function GetFrameCount(out pCount: UINT): HResult; stdcall;
        function GetFrame(index: UINT; out ppIBitmapFrame: IWICBitmapFrameDecode): HResult; stdcall;
    end;


    IWICBitmapSourceTransform = interface(IUnknown)
        ['{3B16811B-6A43-4ec9-B713-3D5A0C13B940}']
        function CopyPixels(prc: PWICRect; uiWidth: UINT; uiHeight: UINT; pguidDstFormat: PWICPixelFormatGUID;
            dstTransform: TWICBitmapTransformOptions; nStride: UINT; cbBufferSize: UINT; out pbBuffer: PBYTE): HResult; stdcall;
        function GetClosestSize(var puiWidth: UINT; var puiHeight: UINT): HResult; stdcall;
        function GetClosestPixelFormat(var pguidDstFormat: TWICPixelFormatGUID): HResult; stdcall;
        function DoesSupportTransform(dstTransform: TWICBitmapTransformOptions; out pfIsSupported: longbool): HResult; stdcall;
    end;


    IWICPlanarBitmapSourceTransform = interface(IUnknown)
        ['{3AFF9CCE-BE95-4303-B927-E7D16FF4A613}']
        function DoesSupportTransform(var puiWidth: UINT; var puiHeight: UINT; dstTransform: TWICBitmapTransformOptions;
            dstPlanarOptions: TWICPlanarOptions; pguidDstFormats: PWICPixelFormatGUID; out pPlaneDescriptions: PWICBitmapPlaneDescription;
            cPlanes: UINT; out pfIsSupported: longbool): HResult; stdcall;
        function CopyPixels(prcSource: PWICRect; uiWidth: UINT; uiHeight: UINT; dstTransform: TWICBitmapTransformOptions;
            dstPlanarOptions: TWICPlanarOptions; pDstPlanes: PWICBitmapPlane; cPlanes: UINT): HResult; stdcall;
    end;


    IWICBitmapFrameDecode = interface(IWICBitmapSource)
        ['{3B16811B-6A43-4ec9-A813-3D930C13B940}']
        function GetMetadataQueryReader(out ppIMetadataQueryReader: IWICMetadataQueryReader): HResult; stdcall;
        function GetColorContexts(cCount: UINT; var ppIColorContexts: PIWICColorContext; out pcActualCount: UINT): HResult; stdcall;
        function GetThumbnail(out ppIThumbnail: IWICBitmapSource): HResult; stdcall;
    end;


    IWICProgressiveLevelControl = interface(IUnknown)
        ['{DAAC296F-7AA5-4dbf-8D15-225C5976F891}']
        function GetLevelCount(out pcLevels: UINT): HResult; stdcall;
        function GetCurrentLevel(out pnLevel: UINT): HResult; stdcall;
        function SetCurrentLevel(nLevel: UINT): HResult; stdcall;
    end;

    IWICProgressCallback = interface(IUnknown)
        ['{4776F9CD-9517-45FA-BF24-E89C5EC5C60C}']
        function Notify(uFrameNum: ULONG; operation: TWICProgressOperation; dblProgress: double): HResult; stdcall;
    end;


    PFNProgressNotification = function(pvData: Pointer; uFrameNum: ULONG; operation: TWICProgressOperation;
        dblProgress: double): HResult; stdcall;


    IWICBitmapCodecProgressNotification = interface(IUnknown)
        ['{64C1024E-C3CF-4462-8078-88C2B11C46D9}']
        function RegisterProgressNotification(pfnProgressNotification: PFNProgressNotification; pvData: Pointer;
            dwProgressFlags: DWORD): HResult; stdcall;
    end;


    IWICComponentInfo = interface(IUnknown)
        ['{23BC3F0A-698B-4357-886B-F24D50671334}']
        function GetComponentType(out pType: TWICComponentType): HResult; stdcall;
        function GetCLSID(out pclsid: TGUID): HResult; stdcall;
        function GetSigningStatus(out pStatus: DWORD): HResult; stdcall;
        function GetAuthor(cchAuthor: UINT; var wzAuthor: PWideChar; out pcchActual: UINT): HResult; stdcall;
        function GetVendorGUID(out pguidVendor: TGUID): HResult; stdcall;
        function GetVersion(cchVersion: UINT; var wzVersion: PWideChar; out pcchActual: UINT): HResult; stdcall;
        function GetSpecVersion(cchSpecVersion: UINT; var wzSpecVersion: PWideChar; out pcchActual: UINT): HResult; stdcall;
        function GetFriendlyName(cchFriendlyName: UINT; var wzFriendlyName: PWideChar; out pcchActual: UINT): HResult; stdcall;
    end;


    IWICFormatConverterInfo = interface(IWICComponentInfo)
        ['{9F34FB65-13F4-4f15-BC57-3726B5E53D9F}']
        function GetPixelFormats(cFormats: UINT; var pPixelFormatGUIDs: PWICPixelFormatGUID; out pcActual: UINT): HResult; stdcall;
        function CreateInstance(out ppIConverter: IWICFormatConverter): HResult; stdcall;
    end;


    IWICBitmapCodecInfo = interface(IWICComponentInfo)
        ['{E87A44C4-B76E-4c47-8B09-298EB12A2714}']
        function GetContainerFormat(out pguidContainerFormat: TGUID): HResult; stdcall;
        function GetPixelFormats(cFormats: UINT; var pguidPixelFormats: PGUID; out pcActual: UINT): HResult; stdcall;
        function GetColorManagementVersion(cchColorManagementVersion: UINT; var wzColorManagementVersion: PWideChar;
            out pcchActual: UINT): HResult; stdcall;
        function GetDeviceManufacturer(cchDeviceManufacturer: UINT; var wzDeviceManufacturer: PWideChar;
            out pcchActual: UINT): HResult; stdcall;
        function GetDeviceModels(cchDeviceModels: UINT; var wzDeviceModels: PWideChar; out pcchActual: UINT): HResult; stdcall;
        function GetMimeTypes(cchMimeTypes: UINT; var wzMimeTypes: PWideChar; out pcchActual: UINT): HResult; stdcall;
        function GetFileExtensions(cchFileExtensions: UINT; var wzFileExtensions: PWideChar; out pcchActual: UINT): HResult; stdcall;
        function DoesSupportAnimation(out pfSupportAnimation: longbool): HResult; stdcall;
        function DoesSupportChromakey(out pfSupportChromakey: longbool): HResult; stdcall;
        function DoesSupportLossless(out pfSupportLossless: longbool): HResult; stdcall;
        function DoesSupportMultiframe(out pfSupportMultiframe: longbool): HResult; stdcall;
        function MatchesMimeType(wzMimeType: PWideChar; out pfMatches: longbool): HResult; stdcall;
    end;


    IWICBitmapEncoderInfo = interface(IWICBitmapCodecInfo)
        ['{94C9B4EE-A09F-4f92-8A1E-4A9BCE7E76FB}']
        function CreateInstance(out ppIBitmapEncoder: IWICBitmapEncoder): HResult; stdcall;
    end;


    IWICBitmapDecoderInfo = interface(IWICBitmapCodecInfo)
        ['{D8CD007F-D08F-4191-9BFC-236EA7F0E4B5}']
        function GetPatterns(cbSizePatterns: UINT; out pPatterns: PWICBitmapPattern; var pcPatterns: UINT;
            var pcbPatternsActual: UINT): HResult; stdcall;
        function MatchesPattern(pIStream: IStream; out pfMatches: longbool): HResult; stdcall;
        function CreateInstance(out ppIBitmapDecoder: IWICBitmapDecoder): HResult; stdcall;
    end;


    IWICPixelFormatInfo = interface(IWICComponentInfo)
        ['{E8EDA601-3D48-431a-AB44-69059BE88BBE}']
        function GetFormatGUID(out pFormat: TGUID): HResult; stdcall;
        function GetColorContext(out ppIColorContext: IWICColorContext): HResult; stdcall;
        function GetBitsPerPixel(out puiBitsPerPixel: UINT): HResult; stdcall;
        function GetChannelCount(out puiChannelCount: UINT): HResult; stdcall;
        function GetChannelMask(uiChannelIndex: UINT; cbMaskBuffer: UINT; var pbMaskBuffer: PBYTE; out pcbActual: UINT): HResult; stdcall;
    end;


    IWICPixelFormatInfo2 = interface(IWICPixelFormatInfo)
        ['{A9DB33A2-AF5F-43C7-B679-74F5984B5AA4}']
        function SupportsTransparency(out pfSupportsTransparency: longbool): HResult; stdcall;
        function GetNumericRepresentation(out pNumericRepresentation: TWICPixelFormatNumericRepresentation): HResult; stdcall;
    end;


    IWICImagingFactory = interface(IUnknown)
        ['{ec5ec8a9-c395-4314-9c77-54d7a935ff70}']
        function CreateDecoderFromFilename(wzFilename: PWideChar; pguidVendor: PGUID; // const ?!?
            dwDesiredAccess: DWORD; metadataOptions: TWICDecodeOptions; out ppIDecoder: IWICBitmapDecoder): HResult; stdcall;
        function CreateDecoderFromStream(pIStream: IStream; pguidVendor: PGUID; metadataOptions: TWICDecodeOptions;
            out ppIDecoder: IWICBitmapDecoder): HResult; stdcall;
        function CreateDecoderFromFileHandle(hFile: Pointer; pguidVendor: PGUID; metadataOptions: TWICDecodeOptions;
            out ppIDecoder: IWICBitmapDecoder): HResult; stdcall;
        function CreateComponentInfo(clsidComponent: TGUID; out ppIInfo: IWICComponentInfo): HResult; stdcall;
        function CreateDecoder(guidContainerFormat: TGUID; pguidVendor: PGUID; out ppIDecoder: IWICBitmapDecoder): HResult; stdcall;
        function CreateEncoder(guidContainerFormat: TGUID; pguidVendor: PGUID; out ppIEncoder: IWICBitmapEncoder): HResult; stdcall;
        function CreatePalette(out ppIPalette: IWICPalette): HResult; stdcall;
        function CreateFormatConverter(out ppIFormatConverter: IWICFormatConverter): HResult; stdcall;
        function CreateBitmapScaler(out ppIBitmapScaler: IWICBitmapScaler): HResult; stdcall;
        function CreateBitmapClipper(out ppIBitmapClipper: IWICBitmapClipper): HResult; stdcall;
        function CreateBitmapFlipRotator(out ppIBitmapFlipRotator: IWICBitmapFlipRotator): HResult; stdcall;
        function CreateStream(out ppIWICStream: IWICStream): HResult; stdcall;
        function CreateColorContext(out ppIWICColorContext: IWICColorContext): HResult; stdcall;
        function CreateColorTransformer(out ppIWICColorTransform: IWICColorTransform): HResult; stdcall;
        function CreateBitmap(uiWidth: UINT; uiHeight: UINT;const pixelFormat: TREFWICPixelFormatGUID;
            option: TWICBitmapCreateCacheOption; out ppIBitmap: IWICBitmap): HResult; stdcall;
        function CreateBitmapFromSource(pIBitmapSource: IWICBitmapSource; option: TWICBitmapCreateCacheOption;
            out ppIBitmap: IWICBitmap): HResult; stdcall;
        function CreateBitmapFromSourceRect(pIBitmapSource: IWICBitmapSource; x: UINT; y: UINT; Width: UINT;
            Height: UINT; out ppIBitmap: IWICBitmap): HResult; stdcall;
        function CreateBitmapFromMemory(uiWidth: UINT; uiHeight: UINT;const pixelFormat: TREFWICPixelFormatGUID;
            cbStride: UINT; cbBufferSize: UINT; pbBuffer: PBYTE; out ppIBitmap: IWICBitmap): HResult; stdcall;
        function CreateBitmapFromHBITMAP(hBitmap: HBITMAP; hPalette: HPALETTE; options: TWICBitmapAlphaChannelOption;
            out ppIBitmap: IWICBitmap): HResult; stdcall;
        function CreateBitmapFromHICON(hIcon: HICON; out ppIBitmap: IWICBitmap): HResult; stdcall;
        function CreateComponentEnumerator(componentTypes: DWORD; options: DWORD; out ppIEnumUnknown: IEnumUnknown): HResult; stdcall;
        function CreateFastMetadataEncoderFromDecoder(pIDecoder: IWICBitmapDecoder;
            out ppIFastEncoder: IWICFastMetadataEncoder): HResult; stdcall;
        function CreateFastMetadataEncoderFromFrameDecode(pIFrameDecoder: IWICBitmapFrameDecode;
            out ppIFastEncoder: IWICFastMetadataEncoder): HResult; stdcall;
        function CreateQueryWriter(guidMetadataFormat: TGUID; pguidVendor: PGUID;
            out ppIQueryWriter: IWICMetadataQueryWriter): HResult; stdcall;
        function CreateQueryWriterFromReader(pIQueryReader: IWICMetadataQueryReader; pguidVendor: PGUID;
            out ppIQueryWriter: IWICMetadataQueryWriter): HResult; stdcall;
    end;


    IWICDevelopRawNotificationCallback = interface(IUnknown)
        ['{95c75a6e-3e8c-4ec2-85a8-aebcc551e59b}']
        function Notify(NotificationMask: UINT): HResult; stdcall;
    end;


    IWICDevelopRaw = interface(IWICBitmapFrameDecode)
        ['{fbec5e44-f7be-4b65-b7f8-c0c81fef026d}']
        function QueryRawCapabilitiesInfo(pInfo: PWICRawCapabilitiesInfo): HResult; stdcall;
        function LoadParameterSet(ParameterSet: TWICRawParameterSet): HResult; stdcall;
        function GetCurrentParameterSet(out ppCurrentParameterSet: IPropertyBag2): HResult; stdcall;
        function SetExposureCompensation(ev: double): HResult; stdcall;
        function GetExposureCompensation(out pEV: double): HResult; stdcall;
        function SetWhitePointRGB(Red: UINT; Green: UINT; Blue: UINT): HResult; stdcall;
        function GetWhitePointRGB(out pRed: UINT; out pGreen: UINT; out pBlue: UINT): HResult; stdcall;
        function SetNamedWhitePoint(WhitePoint: TWICNamedWhitePoint): HResult; stdcall;
        function GetNamedWhitePoint(out pWhitePoint: TWICNamedWhitePoint): HResult; stdcall;
        function SetWhitePointKelvin(WhitePointKelvin: UINT): HResult; stdcall;
        function GetWhitePointKelvin(out pWhitePointKelvin: UINT): HResult; stdcall;
        function GetKelvinRangeInfo(out pMinKelvinTemp: UINT; out pMaxKelvinTemp: UINT; out pKelvinTempStepValue: UINT): HResult; stdcall;
        function SetContrast(Contrast: double): HResult; stdcall;
        function GetContrast(out pContrast: double): HResult; stdcall;
        function SetGamma(Gamma: double): HResult; stdcall;
        function GetGamma(out pGamma: double): HResult; stdcall;
        function SetSharpness(Sharpness: double): HResult; stdcall;
        function GetSharpness(out pSharpness: double): HResult; stdcall;
        function SetSaturation(Saturation: double): HResult; stdcall;
        function GetSaturation(out pSaturation: double): HResult; stdcall;
        function SetTint(Tint: double): HResult; stdcall;
        function GetTint(out pTint: double): HResult; stdcall;
        function SetNoiseReduction(NoiseReduction: double): HResult; stdcall;
        function GetNoiseReduction(out pNoiseReduction: double): HResult; stdcall;
        function SetDestinationColorContext(pColorContext: IWICColorContext): HResult; stdcall;
        function SetToneCurve(cbToneCurveSize: UINT; pToneCurve: PWICRawToneCurve): HResult; stdcall;
        function GetToneCurve(cbToneCurveBufferSize: UINT; out pToneCurve: PWICRawToneCurve;
            var pcbActualToneCurveBufferSize: UINT): HResult; stdcall;
        function SetRotation(Rotation: double): HResult; stdcall;
        function GetRotation(out pRotation: double): HResult; stdcall;
        function SetRenderMode(RenderMode: TWICRawRenderMode): HResult; stdcall;
        function GetRenderMode(out pRenderMode: TWICRawRenderMode): HResult; stdcall;
        function SetNotificationCallback(pCallback: IWICDevelopRawNotificationCallback): HResult; stdcall;
    end;


    IWICDdsDecoder = interface(IUnknown)
        ['{409cd537-8532-40cb-9774-e2feb2df4e9c}']
        function GetParameters(out pParameters: TWICDdsParameters): HResult; stdcall;
        function GetFrame(arrayIndex: UINT; mipLevel: UINT; sliceIndex: UINT; out ppIBitmapFrame: IWICBitmapFrameDecode): HResult; stdcall;
    end;


    IWICDdsEncoder = interface(IUnknown)
        ['{5cacdb4c-407e-41b3-b936-d0f010cd6732}']
        function SetParameters(pParameters: TWICDdsParameters): HResult; stdcall;
        function GetParameters(out pParameters: TWICDdsParameters): HResult; stdcall;
        function CreateNewFrame(out ppIFrameEncode: IWICBitmapFrameEncode; out pArrayIndex: UINT; out pMipLevel: UINT;
            out pSliceIndex: UINT): HResult; stdcall;
    end;


    IWICDdsFrameDecode = interface(IUnknown)
        ['{3d4c0c61-18a4-41e4-bd80-481a4fc9f464}']
        function GetSizeInBlocks(out pWidthInBlocks: UINT; out pHeightInBlocks: UINT): HResult; stdcall;
        function GetFormatInfo(out pFormatInfo: TWICDdsFormatInfo): HResult; stdcall;
        function CopyBlocks(prcBoundsInBlocks: PWICRect; cbStride: UINT; cbBufferSize: UINT; out pbBuffer: PBYTE): HResult; stdcall;
    end;


function WICConvertBitmapSource(const dstFormat: TREFWICPixelFormatGUID; pISrc: IWICBitmapSource; ppIDst: IWICBitmapSource): HResult;
    stdcall; external WINCODEC_DLL;

function WICCreateBitmapFromSection(Width: UINT; Height: UINT;const pixelFormat: TREFWICPixelFormatGUID; hSection: THANDLE;
    stride: UINT; offset: UINT; out ppIBitmap: IWICBitmap): HResult; stdcall; external WINCODEC_DLL;

function WICCreateBitmapFromSectionEx(Width: UINT; Height: UINT; const pixelFormat: TREFWICPixelFormatGUID; hSection: THANDLE;
    stride: UINT; offset: UINT; desiredAccessLevel: TWICSectionAccessLevel; out ppIBitmap: IWICBitmap): HResult; stdcall; external WINCODEC_DLL;

function WICMapGuidToShortName(guid: TGUID; cchName: UINT; var wzName: PWideChar; out pcchActual: UINT): HResult;
    stdcall; external WINCODEC_DLL;

function WICMapShortNameToGuid(wzName: PWideChar; out pguid: TGUID): HResult; stdcall; external WINCODEC_DLL;

function WICMapSchemaToName(guidMetadataFormat: TGUID; pwzSchema: PWideChar; cchName: UINT; var wzName: PWideChar;
    out pcchActual: UINT): HResult; stdcall; external WINCODEC_DLL;





implementation

end.
