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
   Content:    D3DX10 texturing APIs

   This unit consists of the following header files
   File name: d3dx10tex.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.D3DX10Tex;


{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.DXGIFormat,
    DX12.D3DCommon,
    DX12.D3D10;

    {$Z4}

const
    D3DX10_DLL = 'd3dx10_43.dll';

type
    ID3DX10ThreadPump = IUnknown;

    //----------------------------------------------------------------------------
    // D3DX10_FILTER flags:
    // ------------------

    // A valid filter must contain one of these values:

    //  D3DX10_FILTER_NONE
    //      No scaling or filtering will take place.  Pixels outside the bounds
    //      of the source image are assumed to be transparent black.
    //  D3DX10_FILTER_POINT
    //      Each destination pixel is computed by sampling the nearest pixel
    //      from the source image.
    //  D3DX10_FILTER_LINEAR
    //      Each destination pixel is computed by linearly interpolating between
    //      the nearest pixels in the source image.  This filter works best
    //      when the scale on each axis is less than 2.
    //  D3DX10_FILTER_TRIANGLE
    //      Every pixel in the source image contributes equally to the
    //      destination image.  This is the slowest of all the filters.
    //  D3DX10_FILTER_BOX
    //      Each pixel is computed by averaging a 2x2(x2) box pixels from
    //      the source image. Only works when the dimensions of the
    //      destination are half those of the source. (as with mip maps)

    // And can be OR'd with any of these optional flags:

    //  D3DX10_FILTER_MIRROR_U
    //      Indicates that pixels off the edge of the texture on the U-axis
    //      should be mirrored, not wraped.
    //  D3DX10_FILTER_MIRROR_V
    //      Indicates that pixels off the edge of the texture on the V-axis
    //      should be mirrored, not wraped.
    //  D3DX10_FILTER_MIRROR_W
    //      Indicates that pixels off the edge of the texture on the W-axis
    //      should be mirrored, not wraped.
    //  D3DX10_FILTER_MIRROR
    //      Same as specifying D3DX10_FILTER_MIRROR_U | D3DX10_FILTER_MIRROR_V |
    //      D3DX10_FILTER_MIRROR_V
    //  D3DX10_FILTER_DITHER
    //      Dithers the resulting image using a 4x4 order dither pattern.
    //  D3DX10_FILTER_SRGB_IN
    //      Denotes that the input data is in sRGB (gamma 2.2) colorspace.
    //  D3DX10_FILTER_SRGB_OUT
    //      Denotes that the output data is in sRGB (gamma 2.2) colorspace.
    //  D3DX10_FILTER_SRGB
    //      Same as specifying D3DX10_FILTER_SRGB_IN | D3DX10_FILTER_SRGB_OUT

    //----------------------------------------------------------------------------

    TD3DX10_FILTER_FLAG = (
        D3DX10_FILTER_NONE = (1 shl 0),
        D3DX10_FILTER_POINT = (2 shl 0),
        D3DX10_FILTER_LINEAR = (3 shl 0),
        D3DX10_FILTER_TRIANGLE = (4 shl 0),
        D3DX10_FILTER_BOX = (5 shl 0),
        D3DX10_FILTER_MIRROR_U = (1 shl 16),
        D3DX10_FILTER_MIRROR_V = (2 shl 16),
        D3DX10_FILTER_MIRROR_W = (4 shl 16),
        D3DX10_FILTER_MIRROR = (7 shl 16),
        D3DX10_FILTER_DITHER = (1 shl 19),
        D3DX10_FILTER_DITHER_DIFFUSION = (2 shl 19),
        D3DX10_FILTER_SRGB_IN = (1 shl 21),
        D3DX10_FILTER_SRGB_OUT = (2 shl 21),
        D3DX10_FILTER_SRGB = (3 shl 21));

    PD3DX10_FILTER_FLAG = ^TD3DX10_FILTER_FLAG;


    //----------------------------------------------------------------------------
    // D3DX10_NORMALMAP flags:
    // ---------------------
    // These flags are used to control how D3DX10ComputeNormalMap generates normal
    // maps.  Any number of these flags may be OR'd together in any combination.

    //  D3DX10_NORMALMAP_MIRROR_U
    //      Indicates that pixels off the edge of the texture on the U-axis
    //      should be mirrored, not wraped.
    //  D3DX10_NORMALMAP_MIRROR_V
    //      Indicates that pixels off the edge of the texture on the V-axis
    //      should be mirrored, not wraped.
    //  D3DX10_NORMALMAP_MIRROR
    //      Same as specifying D3DX10_NORMALMAP_MIRROR_U | D3DX10_NORMALMAP_MIRROR_V
    //  D3DX10_NORMALMAP_INVERTSIGN
    //      Inverts the direction of each normal
    //  D3DX10_NORMALMAP_COMPUTE_OCCLUSION
    //      Compute the per pixel Occlusion term and encodes it into the alpha.
    //      An Alpha of 1 means that the pixel is not obscured in anyway, and
    //      an alpha of 0 would mean that the pixel is completly obscured.

    //----------------------------------------------------------------------------

    TD3DX10_NORMALMAP_FLAG = (
        D3DX10_NORMALMAP_MIRROR_U = (1 shl 16),
        D3DX10_NORMALMAP_MIRROR_V = (2 shl 16),
        D3DX10_NORMALMAP_MIRROR = (3 shl 16),
        D3DX10_NORMALMAP_INVERTSIGN = (8 shl 16),
        D3DX10_NORMALMAP_COMPUTE_OCCLUSION = (16 shl 16));

    PD3DX10_NORMALMAP_FLAG = ^TD3DX10_NORMALMAP_FLAG;


    //----------------------------------------------------------------------------
    // D3DX10_CHANNEL flags:
    // -------------------
    // These flags are used by functions which operate on or more channels
    // in a texture.

    // D3DX10_CHANNEL_RED
    //     Indicates the red channel should be used
    // D3DX10_CHANNEL_BLUE
    //     Indicates the blue channel should be used
    // D3DX10_CHANNEL_GREEN
    //     Indicates the green channel should be used
    // D3DX10_CHANNEL_ALPHA
    //     Indicates the alpha channel should be used
    // D3DX10_CHANNEL_LUMINANCE
    //     Indicates the luminaces of the red green and blue channels should be
    //     used.

    //----------------------------------------------------------------------------

    TD3DX10_CHANNEL_FLAG = (
        D3DX10_CHANNEL_RED = (1 shl 0),
        D3DX10_CHANNEL_BLUE = (1 shl 1),
        D3DX10_CHANNEL_GREEN = (1 shl 2),
        D3DX10_CHANNEL_ALPHA = (1 shl 3),
        D3DX10_CHANNEL_LUMINANCE = (1 shl 4));

    PD3DX10_CHANNEL_FLAG = ^TD3DX10_CHANNEL_FLAG;


    //----------------------------------------------------------------------------
    // D3DX10_IMAGE_FILE_FORMAT:
    // ---------------------
    // This enum is used to describe supported image file formats.

    //----------------------------------------------------------------------------

    TD3DX10_IMAGE_FILE_FORMAT = (
        D3DX10_IFF_BMP = 0,
        D3DX10_IFF_JPG = 1,
        D3DX10_IFF_PNG = 3,
        D3DX10_IFF_DDS = 4,
        D3DX10_IFF_TIFF = 10,
        D3DX10_IFF_GIF = 11,
        D3DX10_IFF_WMP = 12,
        D3DX10_IFF_FORCE_DWORD = $7fffffff);

    PD3DX10_IMAGE_FILE_FORMAT = ^TD3DX10_IMAGE_FILE_FORMAT;


    //----------------------------------------------------------------------------
    // D3DX10_SAVE_TEXTURE_FLAG:
    // ---------------------
    // This enum is used to support texture saving options.

    //----------------------------------------------------------------------------

    TD3DX10_SAVE_TEXTURE_FLAG = (
        D3DX10_STF_USEINPUTBLOB = $0001);

    PD3DX10_SAVE_TEXTURE_FLAG = ^TD3DX10_SAVE_TEXTURE_FLAG;


    //----------------------------------------------------------------------------
    // D3DX10_IMAGE_INFO:
    // ---------------
    // This structure is used to return a rough description of what the
    // the original contents of an image file looked like.

    //  Width
    //      Width of original image in pixels
    //  Height
    //      Height of original image in pixels
    //  Depth
    //      Depth of original image in pixels
    //  ArraySize
    //      Array size in textures
    //  MipLevels
    //      Number of mip levels in original image
    //  MiscFlags
    //      Miscellaneous flags
    //  Format
    //      D3D format which most closely describes the data in original image
    //  ResourceDimension
    //      D3D10_RESOURCE_DIMENSION representing the dimension of texture stored in the file.
    //      D3D10_RESOURCE_DIMENSION_TEXTURE1D, 2D, 3D
    //  ImageFileFormat
    //      D3DX10_IMAGE_FILE_FORMAT representing the format of the image file.
    //----------------------------------------------------------------------------

    TD3DX10_IMAGE_INFO = record
        Width: UINT;
        Height: UINT;
        Depth: UINT;
        ArraySize: UINT;
        MipLevels: UINT;
        MiscFlags: UINT;
        Format: TDXGI_FORMAT;
        ResourceDimension: TD3D10_RESOURCE_DIMENSION;
        ImageFileFormat: TD3DX10_IMAGE_FILE_FORMAT;
    end;
    PD3DX10_IMAGE_INFO = ^TD3DX10_IMAGE_INFO;


    //////////////////////////////////////////////////////////////////////////////
    // Image File APIs ///////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    //----------------------------------------------------------------------------
    // D3DX10_IMAGE_LOAD_INFO:
    // ---------------
    // This structure can be optionally passed in to texture loader APIs to
    // control how textures get loaded. Pass in D3DX10_DEFAULT for any of these
    // to have D3DX automatically pick defaults based on the source file.

    //  Width
    //      Rescale texture to Width texels wide
    //  Height
    //      Rescale texture to Height texels high
    //  Depth
    //      Rescale texture to Depth texels deep
    //  FirstMipLevel
    //      First mip level to load
    //  MipLevels
    //      Number of mip levels to load after the first level
    //  Usage
    //      D3D10_USAGE flag for the new texture
    //  BindFlags
    //      D3D10 Bind flags for the new texture
    //  CpuAccessFlags
    //      D3D10 CPU Access flags for the new texture
    //  MiscFlags
    //      Reserved. Must be 0
    //  Format
    //      Resample texture to the specified format
    //  Filter
    //      Filter the texture using the specified filter (only when resampling)
    //  MipFilter
    //      Filter the texture mip levels using the specified filter (only if
    //      generating mips)
    //  pSrcInfo
    //      (optional) pointer to a D3DX10_IMAGE_INFO structure that will get
    //      populated with source image information
    //----------------------------------------------------------------------------


    { TD3DX10_IMAGE_LOAD_INFO }

    TD3DX10_IMAGE_LOAD_INFO = record
        Width: UINT;
        Height: UINT;
        Depth: UINT;
        FirstMipLevel: UINT;
        MipLevels: UINT;
        Usage: TD3D10_USAGE;
        BindFlags: UINT;
        CpuAccessFlags: UINT;
        MiscFlags: UINT;
        Format: TDXGI_FORMAT;
        Filter: UINT;
        MipFilter: UINT;
        pSrcInfo: PD3DX10_IMAGE_INFO;
        class operator Initialize(var aRec: TD3DX10_IMAGE_LOAD_INFO);
    end;
    PD3DX10_IMAGE_LOAD_INFO = ^TD3DX10_IMAGE_LOAD_INFO;


    //////////////////////////////////////////////////////////////////////////////
    // Misc Texture APIs /////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    //----------------------------------------------------------------------------
    // D3DX10_TEXTURE_LOAD_INFO:
    // ------------------------

    //----------------------------------------------------------------------------


    { _D3DX10_TEXTURE_LOAD_INFO }

    _D3DX10_TEXTURE_LOAD_INFO = record
        pSrcBox: PD3D10_BOX;
        pDstBox: PD3D10_BOX;
        SrcFirstMip: UINT;
        DstFirstMip: UINT;
        NumMips: UINT;
        SrcFirstElement: UINT;
        DstFirstElement: UINT;
        NumElements: UINT;
        Filter: UINT;
        MipFilter: UINT;
        class operator Initialize(var aRec: _D3DX10_TEXTURE_LOAD_INFO);
    end;
    TD3DX10_TEXTURE_LOAD_INFO = _D3DX10_TEXTURE_LOAD_INFO;
    PD3DX10_TEXTURE_LOAD_INFO = ^TD3DX10_TEXTURE_LOAD_INFO;


    //-------------------------------------------------------------------------------
    // GetImageInfoFromFile/Resource/Memory:
    // ------------------------------
    // Fills in a D3DX10_IMAGE_INFO struct with information about an image file.

    // Parameters:
    //  pSrcFile
    //      File name of the source image.
    //  pSrcModule
    //      Module where resource is located, or NULL for module associated
    //      with image the os used to create the current process.
    //  pSrcResource
    //      Resource name.
    //  pSrcData
    //      Pointer to file in memory.
    //  SrcDataSize
    //      Size in bytes of file in memory.
    //  pPump
    //      Optional pointer to a thread pump object to use.
    //  pSrcInfo
    //      Pointer to a D3DX10_IMAGE_INFO structure to be filled in with the
    //      description of the data in the source image file.
    //  pHResult
    //      Pointer to a memory location to receive the return value upon completion.
    //      Maybe NULL if not needed.
    //      If pPump != NULL, pHResult must be a valid memory location until the
    //      the asynchronous execution completes.
    //-------------------------------------------------------------------------------

function D3DX10GetImageInfoFromFileA(pSrcFile: LPCSTR; pPump: ID3DX10ThreadPump; pSrcInfo: PD3DX10_IMAGE_INFO; pHResult: PHRESULT): HRESULT; stdcall; external D3DX10_DLL;


function D3DX10GetImageInfoFromFileW(pSrcFile: LPCWSTR; pPump: ID3DX10ThreadPump; pSrcInfo: PD3DX10_IMAGE_INFO; pHResult: PHRESULT): HRESULT; stdcall; external D3DX10_DLL;


function D3DX10GetImageInfoFromResourceA(hSrcModule: HMODULE; pSrcResource: LPCSTR; pPump: ID3DX10ThreadPump; pSrcInfo: PD3DX10_IMAGE_INFO; pHResult: PHRESULT): HRESULT; stdcall; external D3DX10_DLL;


function D3DX10GetImageInfoFromResourceW(hSrcModule: HMODULE; pSrcResource: LPCWSTR; pPump: ID3DX10ThreadPump; pSrcInfo: PD3DX10_IMAGE_INFO; pHResult: PHRESULT): HRESULT; stdcall; external D3DX10_DLL;


function D3DX10GetImageInfoFromMemory(pSrcData: LPCVOID; SrcDataSize: SIZE_T; pPump: ID3DX10ThreadPump; pSrcInfo: PD3DX10_IMAGE_INFO; pHResult: PHRESULT): HRESULT; stdcall; external D3DX10_DLL;


//////////////////////////////////////////////////////////////////////////////
// Create/Save Texture APIs //////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//----------------------------------------------------------------------------
// D3DX10CreateTextureFromFile/Resource/Memory:
// D3DX10CreateShaderResourceViewFromFile/Resource/Memory:
// -----------------------------------
// Create a texture object from a file or resource.

// Parameters:

//  pDevice
//      The D3D device with which the texture is going to be used.
//  pSrcFile
//      File name.
//  hSrcModule
//      Module handle. if NULL, current module will be used.
//  pSrcResource
//      Resource name in module
//  pvSrcData
//      Pointer to file in memory.
//  SrcDataSize
//      Size in bytes of file in memory.
//  pLoadInfo
//      Optional pointer to a D3DX10_IMAGE_LOAD_INFO structure that
//      contains additional loader parameters.
//  pPump
//      Optional pointer to a thread pump object to use.
//  ppTexture
//      [out] Created texture object.
//  ppShaderResourceView
//      [out] Shader resource view object created.
//  pHResult
//      Pointer to a memory location to receive the return value upon completion.
//      Maybe NULL if not needed.
//      If pPump != NULL, pHResult must be a valid memory location until the
//      the asynchronous execution completes.

//----------------------------------------------------------------------------
// FromFile


function D3DX10CreateShaderResourceViewFromFileA(pDevice: ID3D10Device; pSrcFile: LPCSTR; pLoadInfo: PD3DX10_IMAGE_LOAD_INFO; pPump: ID3DX10ThreadPump; out ppShaderResourceView: ID3D10ShaderResourceView;
    pHResult: PHRESULT): HRESULT; stdcall; external D3DX10_DLL;


function D3DX10CreateShaderResourceViewFromFileW(pDevice: ID3D10Device; pSrcFile: LPCWSTR; pLoadInfo: PD3DX10_IMAGE_LOAD_INFO; pPump: ID3DX10ThreadPump; out ppShaderResourceView: ID3D10ShaderResourceView;
    pHResult: PHRESULT): HRESULT; stdcall; external D3DX10_DLL;


function D3DX10CreateTextureFromFileA(pDevice: ID3D10Device; pSrcFile: LPCSTR; pLoadInfo: PD3DX10_IMAGE_LOAD_INFO; pPump: ID3DX10ThreadPump; out ppTexture: ID3D10Resource; pHResult: PHRESULT): HRESULT; stdcall; external D3DX10_DLL;


function D3DX10CreateTextureFromFileW(pDevice: ID3D10Device; pSrcFile: LPCWSTR; pLoadInfo: PD3DX10_IMAGE_LOAD_INFO; pPump: ID3DX10ThreadPump; out ppTexture: ID3D10Resource; pHResult: PHRESULT): HRESULT; stdcall; external D3DX10_DLL;


// FromResource (resources in dll/exes)

function D3DX10CreateShaderResourceViewFromResourceA(pDevice: ID3D10Device; hSrcModule: HMODULE; pSrcResource: LPCSTR; pLoadInfo: PD3DX10_IMAGE_LOAD_INFO; pPump: ID3DX10ThreadPump;
    out ppShaderResourceView: ID3D10ShaderResourceView; pHResult: PHRESULT): HRESULT; stdcall; external D3DX10_DLL;


function D3DX10CreateShaderResourceViewFromResourceW(pDevice: ID3D10Device; hSrcModule: HMODULE; pSrcResource: LPCWSTR; pLoadInfo: PD3DX10_IMAGE_LOAD_INFO; pPump: ID3DX10ThreadPump;
    out ppShaderResourceView: ID3D10ShaderResourceView; pHResult: PHRESULT): HRESULT; stdcall; external D3DX10_DLL;


function D3DX10CreateTextureFromResourceA(pDevice: ID3D10Device; hSrcModule: HMODULE; pSrcResource: LPCSTR; pLoadInfo: PD3DX10_IMAGE_LOAD_INFO; pPump: ID3DX10ThreadPump; out ppTexture: ID3D10Resource;
    pHResult: PHRESULT): HRESULT; stdcall; external D3DX10_DLL;


function D3DX10CreateTextureFromResourceW(pDevice: ID3D10Device; hSrcModule: HMODULE; pSrcResource: LPCWSTR; pLoadInfo: PD3DX10_IMAGE_LOAD_INFO; pPump: ID3DX10ThreadPump; out ppTexture: ID3D10Resource;
    pHResult: PHRESULT): HRESULT; stdcall; external D3DX10_DLL;


// FromFileInMemory

function D3DX10CreateShaderResourceViewFromMemory(pDevice: ID3D10Device; pSrcData: LPCVOID; SrcDataSize: SIZE_T; pLoadInfo: PD3DX10_IMAGE_LOAD_INFO; pPump: ID3DX10ThreadPump;
    out ppShaderResourceView: ID3D10ShaderResourceView; pHResult: PHRESULT): HRESULT; stdcall; external D3DX10_DLL;


function D3DX10CreateTextureFromMemory(pDevice: ID3D10Device; pSrcData: LPCVOID; SrcDataSize: SIZE_T; pLoadInfo: PD3DX10_IMAGE_LOAD_INFO; pPump: ID3DX10ThreadPump; out ppTexture: ID3D10Resource;
    pHResult: PHRESULT): HRESULT; stdcall; external D3DX10_DLL;


//////////////////////////////////////////////////////////////////////////////
// Misc Texture APIs /////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//----------------------------------------------------------------------------
// D3DX10LoadTextureFromTexture:
// ----------------------------
// Load a texture from a texture.

// Parameters:

//----------------------------------------------------------------------------


function D3DX10LoadTextureFromTexture(pSrcTexture: ID3D10Resource; pLoadInfo: PD3DX10_TEXTURE_LOAD_INFO; pDstTexture: ID3D10Resource): HRESULT; stdcall; external D3DX10_DLL;


//----------------------------------------------------------------------------
// D3DX10FilterTexture:
// ------------------
// Filters mipmaps levels of a texture.

// Parameters:
//  pBaseTexture
//      The texture object to be filtered
//  SrcLevel
//      The level whose image is used to generate the subsequent levels.
//  MipFilter
//      D3DX10_FILTER flags controlling how each miplevel is filtered.
//      Or D3DX10_DEFAULT for D3DX10_FILTER_BOX,

//----------------------------------------------------------------------------

function D3DX10FilterTexture(pTexture: ID3D10Resource; SrcLevel: UINT; MipFilter: UINT): HRESULT; stdcall; external D3DX10_DLL;


//----------------------------------------------------------------------------
// D3DX10SaveTextureToFile:
// ----------------------
// Save a texture to a file.

// Parameters:
//  pDestFile
//      File name of the destination file
//  DestFormat
//      D3DX10_IMAGE_FILE_FORMAT specifying file format to use when saving.
//  pSrcTexture
//      Source texture, containing the image to be saved

//----------------------------------------------------------------------------

function D3DX10SaveTextureToFileA(pSrcTexture: ID3D10Resource; DestFormat: TD3DX10_IMAGE_FILE_FORMAT; pDestFile: LPCSTR): HRESULT; stdcall; external D3DX10_DLL;


function D3DX10SaveTextureToFileW(pSrcTexture: ID3D10Resource; DestFormat: TD3DX10_IMAGE_FILE_FORMAT; pDestFile: LPCWSTR): HRESULT; stdcall; external D3DX10_DLL;


//----------------------------------------------------------------------------
// D3DX10SaveTextureToMemory:
// ----------------------
// Save a texture to a blob.

// Parameters:
//  pSrcTexture
//      Source texture, containing the image to be saved
//  DestFormat
//      D3DX10_IMAGE_FILE_FORMAT specifying file format to use when saving.
//  ppDestBuf
//      address of a d3dxbuffer pointer to return the image data
//  Flags
//      optional flags
//----------------------------------------------------------------------------

function D3DX10SaveTextureToMemory(
    {_In_} pSrcTexture: ID3D10Resource;
    {_In_} DestFormat: TD3DX10_IMAGE_FILE_FORMAT;
    {_Out_} out ppDestBuf: ID3D10BLOB;
    {_In_} Flags: UINT): HRESULT; stdcall; external D3DX10_DLL;


//----------------------------------------------------------------------------
// D3DX10ComputeNormalMap:
// ---------------------
// Converts a height map into a normal map.  The (x,y,z) components of each
// normal are mapped to the (r,g,b) channels of the output texture.

// Parameters
//  pSrcTexture
//      Pointer to the source heightmap texture
//  Flags
//      D3DX10_NORMALMAP flags
//  Channel
//      D3DX10_CHANNEL specifying source of height information
//  Amplitude
//      The constant value which the height information is multiplied by.
//  pDestTexture
//      Pointer to the destination texture
//---------------------------------------------------------------------------

function D3DX10ComputeNormalMap(pSrcTexture: ID3D10Texture2D; Flags: UINT; Channel: UINT; Amplitude: single; pDestTexture: ID3D10Texture2D): HRESULT; stdcall; external D3DX10_DLL;


//----------------------------------------------------------------------------
// D3DX10SHProjectCubeMap:
// ----------------------
//  Projects a function represented in a cube map into spherical harmonics.

//  Parameters:
//   Order
//      Order of the SH evaluation, generates Order^2 coefs, degree is Order-1
//   pCubeMap
//      CubeMap that is going to be projected into spherical harmonics
//   pROut
//      Output SH vector for Red.
//   pGOut
//      Output SH vector for Green
//   pBOut
//      Output SH vector for Blue

//---------------------------------------------------------------------------

function D3DX10SHProjectCubeMap(
    {__in_range(2,6)} Order: UINT; pCubeMap: ID3D10Texture2D;
    {__out_ecount(Order*Order) } pROut: Psingle;
    {__out_ecount_opt(Order*Order) } pGOut: Psingle;
    {__out_ecount_opt(Order*Order) } pBOut: Psingle): HRESULT; stdcall; external D3DX10_DLL;


implementation

uses
    DX12.D3DX10;

    { TD3DX10_IMAGE_LOAD_INFO }

class operator TD3DX10_IMAGE_LOAD_INFO.Initialize(var aRec: TD3DX10_IMAGE_LOAD_INFO);
begin
    aRec.Width := D3DX10_DEFAULT;
    aRec.Height := D3DX10_DEFAULT;
    aRec.Depth := D3DX10_DEFAULT;
    aRec.FirstMipLevel := D3DX10_DEFAULT;
    aRec.MipLevels := D3DX10_DEFAULT;
    aRec.Usage := TD3D10_USAGE(D3DX10_DEFAULT);
    aRec.BindFlags := D3DX10_DEFAULT;
    aRec.CpuAccessFlags := D3DX10_DEFAULT;
    aRec.MiscFlags := D3DX10_DEFAULT;
    aRec.Format := DXGI_FORMAT_FROM_FILE;
    aRec.Filter := D3DX10_DEFAULT;
    aRec.MipFilter := D3DX10_DEFAULT;
    aRec.pSrcInfo := nil;
end;

{ _D3DX10_TEXTURE_LOAD_INFO }

class operator _D3DX10_TEXTURE_LOAD_INFO.Initialize(var aRec: _D3DX10_TEXTURE_LOAD_INFO);
begin
    aRec.pSrcBox := nil;
    aRec.pDstBox := nil;
    aRec.SrcFirstMip := 0;
    aRec.DstFirstMip := 0;
    aRec.NumMips := D3DX10_DEFAULT;
    aRec.SrcFirstElement := 0;
    aRec.DstFirstElement := 0;
    aRec.NumElements := D3DX10_DEFAULT;
    aRec.Filter := D3DX10_DEFAULT;
    aRec.MipFilter := D3DX10_DEFAULT;
end;

end.
