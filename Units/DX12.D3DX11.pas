{ File: D3DX11.h }
{ File: D3DX11Async.h }
{ File: D3DX11Core.h }
{ File: D3DX11Tex.h }

unit DX12.D3DX11;

{$IFDEF FPC}
{$MODE delphi}{$H+}
{$ENDIF}


interface

{$Z4}

uses
    Windows, Classes, SysUtils, DX12.DXGI,
    DX12.D3D10, DX12.D3DCommon, DX12.D3D11;


{ Includs: D3DX11.h, D3DX11Async.h, D3DX11Core.h, D3DX11Tex.h}
const
    D3DX11_DLL = 'd3dx11_43.dll';

    D3DX11_SDK_VERSION = 43;

    D3DX11_DEFAULT = UINT(-1);
    D3DX11_FROM_FILE = UINT(-3);
    DXGI_FORMAT_FROM_FILE = TDXGI_FORMAT(-3);


    // Errors
    _FACDD = $876;
    _FACD3D = $876;

    MAKE_DDHRESULT = (1 shl 31) or _FACDD;

    D3DX11_ERR_CANNOT_MODIFY_INDEX_BUFFER = MAKE_DDHRESULT or 2900;
    D3DX11_ERR_INVALID_MESH = MAKE_DDHRESULT or 2901;
    D3DX11_ERR_CANNOT_ATTR_SORT = MAKE_DDHRESULT or 2902;
    D3DX11_ERR_SKINNING_NOT_SUPPORTED = MAKE_DDHRESULT or 2903;
    D3DX11_ERR_TOO_MANY_INFLUENCES = MAKE_DDHRESULT or 2904;
    D3DX11_ERR_INVALID_DATA = MAKE_DDHRESULT or 2905;
    D3DX11_ERR_LOADED_MESH_HAS_NO_DATA = MAKE_DDHRESULT or 2906;
    D3DX11_ERR_DUPLICATE_NAMED_FRAGMENT = MAKE_DDHRESULT or 2907;
    D3DX11_ERR_CANNOT_REMOVE_LAST_ITEM = MAKE_DDHRESULT or 2908;

    MAKE_D3DHRESULT = 1 shl 31 or _FACD3D;
    MAKE_D3DSTATUS = _FACD3D;
    D3DERR_INVALIDCALL = MAKE_D3DHRESULT or 2156;
    D3DERR_WASSTILLDRAWING = MAKE_D3DHRESULT or 540;

    IID_ID3DX11ThreadPump: TGUID = '{C93FECFA-6967-478a-ABBC-402D90621FCB}';

type
  {$IFNDEF FPC}
  PHRESULT = ^HRESULT;
  {$ENDIF}

    TD3DX11_FILTER_FLAG = (
        D3DX11_FILTER_NONE = (1 shl 0),
        D3DX11_FILTER_POINT = (2 shl 0),
        D3DX11_FILTER_LINEAR = (3 shl 0),
        D3DX11_FILTER_TRIANGLE = (4 shl 0),
        D3DX11_FILTER_BOX = (5 shl 0),
        D3DX11_FILTER_MIRROR_U = (1 shl 16),
        D3DX11_FILTER_MIRROR_V = (2 shl 16),
        D3DX11_FILTER_MIRROR_W = (4 shl 16),
        D3DX11_FILTER_MIRROR = (7 shl 16),
        D3DX11_FILTER_DITHER = (1 shl 19),
        D3DX11_FILTER_DITHER_DIFFUSION = (2 shl 19),
        D3DX11_FILTER_SRGB_IN = (1 shl 21),
        D3DX11_FILTER_SRGB_OUT = (2 shl 21),
        D3DX11_FILTER_SRGB = (3 shl 21));


    TD3DX11_NORMALMAP_FLAG = (
        D3DX11_NORMALMAP_MIRROR_U = (1 shl 16),
        D3DX11_NORMALMAP_MIRROR_V = (2 shl 16),
        D3DX11_NORMALMAP_MIRROR = (3 shl 16),
        D3DX11_NORMALMAP_INVERTSIGN = (8 shl 16),
        D3DX11_NORMALMAP_COMPUTE_OCCLUSION = (16 shl 16));


    TD3DX11_CHANNEL_FLAG = (
        D3DX11_CHANNEL_RED = (1 shl 0),
        D3DX11_CHANNEL_BLUE = (1 shl 1),
        D3DX11_CHANNEL_GREEN = (1 shl 2),
        D3DX11_CHANNEL_ALPHA = (1 shl 3),
        D3DX11_CHANNEL_LUMINANCE = (1 shl 4));


    TD3DX11_IMAGE_FILE_FORMAT = (
        D3DX11_IFF_BMP = 0,
        D3DX11_IFF_JPG = 1,
        D3DX11_IFF_PNG = 3,
        D3DX11_IFF_DDS = 4,
        D3DX11_IFF_TIFF = 10,
        D3DX11_IFF_GIF = 11,
        D3DX11_IFF_WMP = 12,
        D3DX11_IFF_FORCE_DWORD = $7fffffff
        );


    TD3DX11_SAVE_TEXTURE_FLAG = (
        D3DX11_STF_USEINPUTBLOB = $0001);


    TD3DX11_IMAGE_INFO = record
        Width: UINT;
        Height: UINT;
        Depth: UINT;
        ArraySize: UINT;
        MipLevels: UINT;
        MiscFlags: UINT;
        Format: TDXGI_FORMAT;
        ResourceDimension: TD3D11_RESOURCE_DIMENSION;
        ImageFileFormat: TD3DX11_IMAGE_FILE_FORMAT;
    end;
    PD3DX11_IMAGE_INFO = ^TD3DX11_IMAGE_INFO;


    { TD3DX11_IMAGE_LOAD_INFO }

    TD3DX11_IMAGE_LOAD_INFO = record
        Width: UINT;
        Height: UINT;
        Depth: UINT;
        FirstMipLevel: UINT;
        MipLevels: UINT;
        Usage: TD3D11_USAGE;
        BindFlags: UINT;
        CpuAccessFlags: UINT;
        MiscFlags: UINT;
        Format: TDXGI_FORMAT;
        Filter: UINT;
        MipFilter: UINT;
        pSrcInfo: PD3DX11_IMAGE_INFO;
        procedure Init;
    end;

    PD3DX11_IMAGE_LOAD_INFO = ^TD3DX11_IMAGE_LOAD_INFO;

    { TD3DX11_TEXTURE_LOAD_INFO }

    TD3DX11_TEXTURE_LOAD_INFO = record

        pSrcBox: PD3D11_BOX;
        pDstBox: PD3D11_BOX;
        SrcFirstMip: UINT;
        DstFirstMip: UINT;
        NumMips: UINT;
        SrcFirstElement: UINT;
        DstFirstElement: UINT;
        NumElements: UINT;
        Filter: UINT;
        MipFilter: UINT;
        procedure Init;
    end;

    PD3DX11_TEXTURE_LOAD_INFO = ^TD3DX11_TEXTURE_LOAD_INFO;


{$IFDEF FPC}
{$interfaces corba}
    ID3DX11DataLoader = interface
        function Load(): HResult; stdcall;
        function Decompress(out ppData: Pointer; out pcBytes: SIZE_T): HResult; stdcall;
        function Destroy(): HResult; stdcall;
    end;

    ID3DX11DataProcessor = interface
        function Process(pData: pointer; cBytes: SIZE_T): HResult; stdcall;
        function CreateDeviceObject(out ppDataObject: Pointer): HResult; stdcall;
        function Destroy(): HResult; stdcall;
    end;

{$interfaces com}
{$ELSE}
    ID3DX11DataLoader = class // Cannot use 'interface'
        function Load(): HResult; virtual; stdcall; abstract;
        function Decompress(out ppData: Pointer; out pcBytes: SIZE_T): HResult; virtual; stdcall; abstract;
        function Destroy(): HResult; virtual; stdcall; abstract;
    end;

    ID3DX11DataProcessor = class // Cannot use 'interface'
        function Process(pData: pointer; cBytes: SIZE_T): HResult; virtual; stdcall; abstract;
        function CreateDeviceObject(out ppDataObject: Pointer): HResult; virtual; stdcall; abstract;
        function Destroy(): HResult; virtual; stdcall; abstract;
    end;

{$ENDIF}

    ID3DX11ThreadPump = interface(IUnknown)
        ['{C93FECFA-6967-478a-ABBC-402D90621FCB}']
        function AddWorkItem(pDataLoader: ID3DX11DataLoader; pDataProcessor: ID3DX11DataProcessor; out pHResult: HRESULT;
            out ppDeviceObject: pointer): HResult; stdcall;
        function GetWorkItemCount(): UINT; stdcall;
        function WaitForAllItems(): HResult; stdcall;
        function ProcessDeviceWorkItems(iWorkItemCount: UINT): HResult; stdcall;
        function PurgeAllItems(): HResult; stdcall;
        function GetQueueStatus(pIoQueue: PUINT; pProcessQueue: PUINT; pDeviceQueue: UINT): HResult; stdcall;
    end;


function D3DX11CompileFromFileA(pSrcFile: PAnsiChar; pDefines: PD3D10_SHADER_MACRO; pInclude: PID3D10INCLUDE;
    pFunctionName: PAnsiChar; pProfile: PAnsiChar; Flags1: UINT; Flags2: UINT; pPump: ID3DX11ThreadPump;
    out ppShader: ID3D10Blob; out ppErrorMsgs: ID3D10Blob; pHResult: PHRESULT): HResult; stdcall; external D3DX11_DLL;

function D3DX11CompileFromFileW(pSrcFile: PWideChar; pDefines: PD3D10_SHADER_MACRO; pInclude: PID3D10INCLUDE;
    pFunctionName: PAnsiChar; pProfile: PAnsiChar; Flags1: UINT; Flags2: UINT; pPump: ID3DX11ThreadPump;
    out ppShader: ID3D10Blob; out ppErrorMsgs: ID3D10Blob; pHResult: PHRESULT): HResult; stdcall; external D3DX11_DLL;


function D3DX11CheckVersion(D3DSdkVersion: UINT; D3DX11SdkVersion: UINT): HResult; stdcall; external D3DX11_DLL;

function D3DX11CreateThreadPump(cIoThreads: UINT; cProcThreads: UINT; out ppThreadPump: ID3DX11ThreadPump): HResult; stdcall; external D3DX11_DLL;

function D3DX11UnsetAllDeviceObjects(pContext: ID3D11DeviceContext): HResult; stdcall; external D3DX11_DLL;


{ D3DX11Async.h }


function D3DX11CompileFromResourceA(hSrcModule: HModule; pSrcResource: PAnsiChar; pSrcFileName: PAnsiChar;
    pDefines: PD3D10_SHADER_MACRO; pInclude: PID3D10INCLUDE; pFunctionName: PAnsiChar; pProfile: PAnsiChar;
    Flags1: UINT; Flags2: UINT; pPump: ID3DX11ThreadPump; out ppShader: ID3D10Blob; out ppErrorMsgs: ID3D10Blob;
    pResult: PHRESULT = nil): HResult; stdcall; external D3DX11_DLL;

function D3DX11CompileFromResourceW(hSrcModule: HModule; pSrcResource: PWideChar; pSrcFileName: PWideChar;
    pDefines: PD3D10_SHADER_MACRO; pInclude: PID3D10INCLUDE; pFunctionName: PAnsiChar; pProfile: PAnsiChar;
    Flags1: UINT; Flags2: UINT; pPump: ID3DX11ThreadPump; out ppShader: ID3D10Blob; out ppErrorMsgs: ID3D10Blob;
    pHResult: PHRESULT = nil): HResult; stdcall; external D3DX11_DLL;


function D3DX11CompileFromMemory(pSrcData: PAnsiChar; SrcDataLen: SIZE_T; pFileName: PAnsiChar; pDefines: PD3D10_SHADER_MACRO;
    pInclude: PID3D10INCLUDE; pFunctionName: PAnsiChar; pProfile: PAnsiChar; Flags1: UINT; Flags2: UINT;
    pPump: ID3DX11ThreadPump; out ppShader: ID3D10Blob; out ppErrorMsgs: ID3D10Blob; pResult: PHRESULT = nil): HResult; stdcall; external D3DX11_DLL;

function D3DX11PreprocessShaderFromFileA(pFileName: PAnsiChar; pDefines: PD3D10_SHADER_MACRO; pInclude: PID3D10INCLUDE;
    pPump: ID3DX11ThreadPump; out ppShaderText: ID3D10Blob; out ppErrorMsgs: ID3D10Blob; pResult: PHRESULT = nil): HResult;
    stdcall; external D3DX11_DLL;

function D3DX11PreprocessShaderFromFileW(pFileName: PWideChar; pDefines: PD3D10_SHADER_MACRO; pInclude: PID3D10INCLUDE;
    pPump: ID3DX11ThreadPump; out ppShaderText: ID3D10Blob; out ppErrorMsgs: ID3D10Blob; pResult: PHRESULT = nil): HResult;
    stdcall; external D3DX11_DLL;

function D3DX11PreprocessShaderFromMemory(pSrcData: PAnsiChar; SrcDataSize: SIZE_T; pFileName: PAnsiChar;
    pDefines: PD3D10_SHADER_MACRO; pInclude: PID3D10INCLUDE; pPump: ID3DX11ThreadPump; out ppShaderText: ID3D10Blob;
    out ppErrorMsgs: ID3D10Blob; pResult: PHRESULT = nil): HResult; stdcall; external D3DX11_DLL;

function D3DX11PreprocessShaderFromResourceA(HModule: HModule; pResourceName: PAnsiChar; pSrcFileName: PAnsiChar;
    pDefines: PD3D10_SHADER_MACRO; pInclude: PID3D10INCLUDE; pPump: ID3DX11ThreadPump; out ppShaderText: ID3D10Blob;
    out ppErrorMsgs: ID3D10Blob; pResult: PHRESULT = nil): HResult; stdcall; external D3DX11_DLL;

function D3DX11PreprocessShaderFromResourceW(HModule: HModule; pResourceName: PWideChar; pSrcFileName: PWideChar;
    pDefines: PD3D10_SHADER_MACRO; pInclude: PID3D10INCLUDE; pPump: ID3DX11ThreadPump; out ppShaderText: ID3D10Blob;
    out ppErrorMsgs: ID3D10Blob; pResult: PHRESULT = nil): HResult; stdcall; external D3DX11_DLL;


function D3DX11CreateAsyncCompilerProcessor(pFileName: PAnsiChar; pDefines: PD3D10_SHADER_MACRO; pInclude: PID3D10INCLUDE;
    pFunctionName: PAnsiChar; pProfile: PAnsiChar; Flags1: UINT; Flags2: UINT; out ppCompiledShader: ID3D10Blob;
    out ppErrorBuffer: ID3D10Blob; out ppProcessor: ID3DX11DataProcessor): HResult; stdcall; external D3DX11_DLL;

function D3DX11CreateAsyncShaderPreprocessProcessor(pFileName: PAnsiChar; pDefines: PD3D10_SHADER_MACRO;
    pInclude: PID3D10INCLUDE; out ppShaderText: ID3D10Blob; out ppErrorBuffer: ID3D10Blob; out ppProcessor: ID3DX11DataProcessor): HResult;
    stdcall; external D3DX11_DLL;


function D3DX11CreateAsyncFileLoaderW(pFileName: PWideChar; out ppDataLoader: ID3DX11DataLoader): HResult; stdcall; external D3DX11_DLL;
function D3DX11CreateAsyncFileLoaderA(pFileName: PAnsiChar; out ppDataLoader: ID3DX11DataLoader): HResult; stdcall; external D3DX11_DLL;
function D3DX11CreateAsyncMemoryLoader(pData: Pointer; cbData: SIZE_T; out ppDataLoader: ID3DX11DataLoader): HResult; stdcall; external D3DX11_DLL;
function D3DX11CreateAsyncResourceLoaderW(hSrcModule: HModule; pSrcResource: PWideChar; out ppDataLoader: ID3DX11DataLoader): HResult;
    stdcall; external D3DX11_DLL;
function D3DX11CreateAsyncResourceLoaderA(hSrcModule: HModule; pSrcResource: PAnsiChar; out ppDataLoader: ID3DX11DataLoader): HResult;
    stdcall; external D3DX11_DLL;


function D3DX11CreateAsyncTextureProcessor(pDevice: ID3D11Device; pLoadInfo: PD3DX11_IMAGE_LOAD_INFO;
    out ppDataProcessor: ID3DX11DataProcessor): HResult; stdcall; external D3DX11_DLL;
function D3DX11CreateAsyncTextureInfoProcessor(pImageInfo: PD3DX11_IMAGE_INFO; out ppDataProcessor: ID3DX11DataProcessor): HResult;
    stdcall; external D3DX11_DLL;
function D3DX11CreateAsyncShaderResourceViewProcessor(pDevice: ID3D11Device; pLoadInfo: PD3DX11_IMAGE_LOAD_INFO;
    out ppDataProcessor: ID3DX11DataProcessor): HResult; stdcall; external D3DX11_DLL;


{ D3DX11Tex.h }


{ D3DX11Tex.h }

function D3DX11GetImageInfoFromFileA(pSrcFile: PAnsiChar; pPump: ID3DX11ThreadPump; const pSrcInfo: TD3DX11_IMAGE_INFO;
    pResult: PHRESULT = nil): HResult; stdcall; external D3DX11_DLL;

function D3DX11GetImageInfoFromFileW(pSrcFile: PWideChar; pPump: ID3DX11ThreadPump; const pSrcInfo: TD3DX11_IMAGE_INFO;
    pResult: PHRESULT = nil): HResult; stdcall; external D3DX11_DLL;


function D3DX11GetImageInfoFromResourceA(hSrcModule: HMODULE; pSrcResource: PAnsiChar; pPump: ID3DX11ThreadPump;
    const pSrcInfo: TD3DX11_IMAGE_INFO; pResult: PHRESULT = nil): HResult;
    stdcall; external D3DX11_DLL;

function D3DX11GetImageInfoFromResourceW(hSrcModule: HMODULE; pSrcResource: PWideChar; pPump: ID3DX11ThreadPump;
    const pSrcInfo: TD3DX11_IMAGE_INFO; pResult: PHRESULT = nil): HResult;
    stdcall; external D3DX11_DLL;


function D3DX11GetImageInfoFromMemory(pSrcData: pointer; SrcDataSize: SIZE_T; pPump: ID3DX11ThreadPump;
    const pSrcInfo: TD3DX11_IMAGE_INFO; pResult: PHRESULT = nil): HResult;
    stdcall; external D3DX11_DLL;


// FromFile

function D3DX11CreateShaderResourceViewFromFileA(pDevice: ID3D11Device; pSrcFile: PAnsiChar; pLoadInfo: PD3DX11_IMAGE_LOAD_INFO;
    pPump: ID3DX11ThreadPump; out ppShaderResourceView: ID3D11ShaderResourceView; pResult: PHRESULT = nil): HResult; stdcall; external D3DX11_DLL;

function D3DX11CreateShaderResourceViewFromFileW(pDevice: ID3D11Device; pSrcFile: PWideChar; pLoadInfo: PD3DX11_IMAGE_LOAD_INFO;
    pPump: ID3DX11ThreadPump; out ppShaderResourceView: ID3D11ShaderResourceView; pResult: PHRESULT = nil): HResult; stdcall; external D3DX11_DLL;


function D3DX11CreateTextureFromFileA(pDevice: ID3D11Device; pSrcFile: PAnsiChar; pLoadInfo: PD3DX11_IMAGE_LOAD_INFO;
    pPump: ID3DX11ThreadPump; out ppTexture: ID3D11Resource; pResult: PHRESULT = nil): HResult; stdcall; external D3DX11_DLL;

function D3DX11CreateTextureFromFileW(pDevice: ID3D11Device; pSrcFile: PWideChar; pLoadInfo: PD3DX11_IMAGE_LOAD_INFO;
    pPump: ID3DX11ThreadPump; out ppTexture: ID3D11Resource; pResult: PHRESULT = nil): HResult; stdcall; external D3DX11_DLL;


// FromResource (resources in dll/exes)

function D3DX11CreateShaderResourceViewFromResourceA(pDevice: ID3D11Device; hSrcModule: HMODULE; pSrcResource: PAnsiChar;
    pLoadInfo: PD3DX11_IMAGE_LOAD_INFO; pPump: ID3DX11ThreadPump; out ppShaderResourceView: ID3D11ShaderResourceView;
    pResult: PHRESULT = nil): HResult; stdcall; external D3DX11_DLL;

function D3DX11CreateShaderResourceViewFromResourceW(pDevice: ID3D11Device; hSrcModule: HMODULE; pSrcResource: PWideChar;
    pLoadInfo: PD3DX11_IMAGE_LOAD_INFO; pPump: ID3DX11ThreadPump; out ppShaderResourceView: ID3D11ShaderResourceView;
    pResult: PHRESULT = nil): HResult; stdcall; external D3DX11_DLL;


function D3DX11CreateTextureFromResourceA(pDevice: ID3D11Device; hSrcModule: HMODULE; pSrcResource: PAnsiChar;
    pLoadInfo: PD3DX11_IMAGE_LOAD_INFO; pPump: ID3DX11ThreadPump; out ppTexture: ID3D11Resource; pResult: PHRESULT = nil): HResult;
    stdcall; external D3DX11_DLL;

function D3DX11CreateTextureFromResourceW(pDevice: ID3D11Device; hSrcModule: HMODULE; pSrcResource: PWideChar;
    pLoadInfo: PD3DX11_IMAGE_LOAD_INFO; pPump: ID3DX11ThreadPump; out ppTexture: ID3D11Resource; pResult: PHRESULT = nil): HResult;
    stdcall; external D3DX11_DLL;


// FromFileInMemory

function D3DX11CreateShaderResourceViewFromMemory(pDevice: ID3D11Device; pSrcData: pointer; SrcDataSize: SIZE_T;
    pLoadInfo: PD3DX11_IMAGE_LOAD_INFO; pPump: ID3DX11ThreadPump; out ppShaderResourceView: ID3D11ShaderResourceView;
    pResult: PHRESULT = nil): HResult; stdcall; external D3DX11_DLL;

function D3DX11CreateTextureFromMemory(pDevice: ID3D11Device; pSrcData: pointer; SrcDataSize: SIZE_T;
    pLoadInfo: PD3DX11_IMAGE_LOAD_INFO; pPump: ID3DX11ThreadPump; out ppTexture: ID3D11Resource; pResult: PHRESULT = nil): HResult;
    stdcall; external D3DX11_DLL;

function D3DX11LoadTextureFromTexture(pContext: ID3D11DeviceContext; pSrcTexture: ID3D11Resource;
    pLoadInfo: PD3DX11_TEXTURE_LOAD_INFO; pDstTexture: ID3D11Resource): HResult; stdcall; external D3DX11_DLL;

function D3DX11FilterTexture(pContext: ID3D11DeviceContext; pTexture: ID3D11Resource; SrcLevel: UINT; MipFilter: UINT): HResult;
    stdcall; external D3DX11_DLL;

function D3DX11SaveTextureToFileA(pContext: ID3D11DeviceContext; pSrcTexture: ID3D11Resource; DestFormat: TD3DX11_IMAGE_FILE_FORMAT;
    pDestFile: PAnsiChar): HResult; stdcall; external D3DX11_DLL;

function D3DX11SaveTextureToFileW(pContext: ID3D11DeviceContext; pSrcTexture: ID3D11Resource; DestFormat: TD3DX11_IMAGE_FILE_FORMAT;
    pDestFile: PWideChar): HResult; stdcall; external D3DX11_DLL;

function D3DX11SaveTextureToMemory(pContext: ID3D11DeviceContext; pSrcTexture: ID3D11Resource; DestFormat: TD3DX11_IMAGE_FILE_FORMAT;
    out ppDestBuf: ID3D10Blob; Flags: UINT): HResult; stdcall; external D3DX11_DLL;

function D3DX11ComputeNormalMap(pContext: ID3D11DeviceContext; pSrcTexture: ID3D11Texture2D; Flags: UINT; Channel: UINT;
    Amplitude: single; pDestTexture: ID3D11Texture2D): HResult; stdcall; external D3DX11_DLL;

function D3DX11SHProjectCubeMap(pContext: ID3D11DeviceContext; Order: UINT; pCubeMap: ID3D11Texture2D; pROut: PSingle;
    pGOut: PSingle; pBOut: PSingle): HResult; stdcall; external D3DX11_DLL;


implementation

{ TD3DX11_TEXTURE_LOAD_INFO }

procedure TD3DX11_TEXTURE_LOAD_INFO.Init;
begin
    pSrcBox := nil;
    pDstBox := nil;
    SrcFirstMip := 0;
    DstFirstMip := 0;
    NumMips := D3DX11_DEFAULT;
    SrcFirstElement := 0;
    DstFirstElement := 0;
    NumElements := D3DX11_DEFAULT;
    Filter := D3DX11_DEFAULT;
    MipFilter := D3DX11_DEFAULT;
end;

{ TD3DX11_IMAGE_LOAD_INFO }

procedure TD3DX11_IMAGE_LOAD_INFO.Init;
begin
    Width := D3DX11_DEFAULT;
    Height := D3DX11_DEFAULT;
    Depth := D3DX11_DEFAULT;
    FirstMipLevel := D3DX11_DEFAULT;
    MipLevels := D3DX11_DEFAULT;
    Usage := TD3D11_USAGE(D3DX11_DEFAULT);
    BindFlags := D3DX11_DEFAULT;
    CpuAccessFlags := D3DX11_DEFAULT;
    MiscFlags := D3DX11_DEFAULT;
    Format := DXGI_FORMAT_FROM_FILE;
    Filter := D3DX11_DEFAULT;
    MipFilter := D3DX11_DEFAULT;
    pSrcInfo := nil;
end;

end.

