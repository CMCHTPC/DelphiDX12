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
   Content:    D3DX texturing APIs

   This unit consists of the following header files
   File name: d3dx9tex.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3DX9Tex;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D9Types,
    DX12.D3DX9Core,
    DX12.D3D9,
    DX12.D3DX9Shader,
    DX12.D3DX9Math;

    {$Z4}

    // for different SDK versions
    {$I DX12.DX9SDKVersion.inc}

const


    //----------------------------------------------------------------------------
    // D3DX_FILTER flags:
    // ------------------

    // A valid filter must contain one of these values:

    //  D3DX_FILTER_NONE
    //      No scaling or filtering will take place.  Pixels outside the bounds
    //      of the source image are assumed to be transparent black.
    //  D3DX_FILTER_POINT
    //      Each destination pixel is computed by sampling the nearest pixel
    //      from the source image.
    //  D3DX_FILTER_LINEAR
    //      Each destination pixel is computed by linearly interpolating between
    //      the nearest pixels in the source image.  This filter works best
    //      when the scale on each axis is less than 2.
    //  D3DX_FILTER_TRIANGLE
    //      Every pixel in the source image contributes equally to the
    //      destination image.  This is the slowest of all the filters.
    //  D3DX_FILTER_BOX
    //      Each pixel is computed by averaging a 2x2(x2) box pixels from
    //      the source image. Only works when the dimensions of the
    //      destination are half those of the source. (as with mip maps)

    // And can be OR'd with any of these optional flags:

    //  D3DX_FILTER_MIRROR_U
    //      Indicates that pixels off the edge of the texture on the U-axis
    //      should be mirrored, not wraped.
    //  D3DX_FILTER_MIRROR_V
    //      Indicates that pixels off the edge of the texture on the V-axis
    //      should be mirrored, not wraped.
    //  D3DX_FILTER_MIRROR_W
    //      Indicates that pixels off the edge of the texture on the W-axis
    //      should be mirrored, not wraped.
    //  D3DX_FILTER_MIRROR
    //      Same as specifying D3DX_FILTER_MIRROR_U | D3DX_FILTER_MIRROR_V |
    //      D3DX_FILTER_MIRROR_V
    //  D3DX_FILTER_DITHER
    //      Dithers the resulting image using a 4x4 order dither pattern.
    //  D3DX_FILTER_SRGB_IN
    //      Denotes that the input data is in sRGB (gamma 2.2) colorspace.
    //  D3DX_FILTER_SRGB_OUT
    //      Denotes that the output data is in sRGB (gamma 2.2) colorspace.
    //  D3DX_FILTER_SRGB
    //      Same as specifying D3DX_FILTER_SRGB_IN | D3DX_FILTER_SRGB_OUT

    //----------------------------------------------------------------------------

    D3DX_FILTER_NONE = (1 shl 0);
    D3DX_FILTER_POINT = (2 shl 0);
    D3DX_FILTER_LINEAR = (3 shl 0);
    D3DX_FILTER_TRIANGLE = (4 shl 0);
    D3DX_FILTER_BOX = (5 shl 0);

    D3DX_FILTER_MIRROR_U = (1 shl 16);
    D3DX_FILTER_MIRROR_V = (2 shl 16);
    D3DX_FILTER_MIRROR_W = (4 shl 16);
    D3DX_FILTER_MIRROR = (7 shl 16);
    D3DX_FILTER_DITHER = (1 shl 19);

    {$IFDEF USESDK43 }
    D3DX_FILTER_DITHER_DIFFUSION = (2 shl 19);
    D3DX_FILTER_SRGB_IN = (1 shl 21);
    D3DX_FILTER_SRGB_OUT = (2 shl 21);
    D3DX_FILTER_SRGB = (3 shl 21);
    {$ELSE}
    D3DX_FILTER_SRGB_IN = (1 shl 20);
    D3DX_FILTER_SRGB_OUT = (2 shl 20);
    D3DX_FILTER_SRGB = (3 shl 20);
    {$ENDIF}

    D3DX_SKIP_DDS_MIP_LEVELS_MASK = $1F;
    D3DX_SKIP_DDS_MIP_LEVELS_SHIFT = 26;


    //----------------------------------------------------------------------------
    // D3DX_NORMALMAP flags:
    // ---------------------
    // These flags are used to control how D3DXComputeNormalMap generates normal
    // maps.  Any number of these flags may be OR'd together in any combination.

    //  D3DX_NORMALMAP_MIRROR_U
    //      Indicates that pixels off the edge of the texture on the U-axis
    //      should be mirrored, not wraped.
    //  D3DX_NORMALMAP_MIRROR_V
    //      Indicates that pixels off the edge of the texture on the V-axis
    //      should be mirrored, not wraped.
    //  D3DX_NORMALMAP_MIRROR
    //      Same as specifying D3DX_NORMALMAP_MIRROR_U | D3DX_NORMALMAP_MIRROR_V
    //  D3DX_NORMALMAP_INVERTSIGN
    //      Inverts the direction of each normal
    //  D3DX_NORMALMAP_COMPUTE_OCCLUSION
    //      Compute the per pixel Occlusion term and encodes it into the alpha.
    //      An Alpha of 1 means that the pixel is not obscured in anyway, and
    //      an alpha of 0 would mean that the pixel is completly obscured.

    //----------------------------------------------------------------------------
    //----------------------------------------------------------------------------


    D3DX_NORMALMAP_MIRROR_U = (1 shl 16);
    D3DX_NORMALMAP_MIRROR_V = (2 shl 16);
    D3DX_NORMALMAP_MIRROR = (3 shl 16);
    D3DX_NORMALMAP_INVERTSIGN = (8 shl 16);
    D3DX_NORMALMAP_COMPUTE_OCCLUSION = (16 shl 16);




    //----------------------------------------------------------------------------
    // D3DX_CHANNEL flags:
    // -------------------
    // These flags are used by functions which operate on or more channels
    // in a texture.

    // D3DX_CHANNEL_RED
    //     Indicates the red channel should be used
    // D3DX_CHANNEL_BLUE
    //     Indicates the blue channel should be used
    // D3DX_CHANNEL_GREEN
    //     Indicates the green channel should be used
    // D3DX_CHANNEL_ALPHA
    //     Indicates the alpha channel should be used
    // D3DX_CHANNEL_LUMINANCE
    //     Indicates the luminaces of the red green and blue channels should be
    //     used.

    //----------------------------------------------------------------------------

    D3DX_CHANNEL_RED = (1 shl 0);
    D3DX_CHANNEL_BLUE = (1 shl 1);
    D3DX_CHANNEL_GREEN = (1 shl 2);
    D3DX_CHANNEL_ALPHA = (1 shl 3);
    D3DX_CHANNEL_LUMINANCE = (1 shl 4);


type


    //----------------------------------------------------------------------------
    // D3DXIMAGE_FILEFORMAT:
    // ---------------------
    // This enum is used to describe supported image file formats.

    //----------------------------------------------------------------------------

    _D3DXIMAGE_FILEFORMAT = (
        D3DXIFF_BMP = 0,
        D3DXIFF_JPG = 1,
        D3DXIFF_TGA = 2,
        D3DXIFF_PNG = 3,
        D3DXIFF_DDS = 4,
        D3DXIFF_PPM = 5,
        D3DXIFF_DIB = 6,
        {$IFDEF USESDK43 }
        D3DXIFF_HDR = 7,       //high dynamic range formats
        D3DXIFF_PFM = 8,
        {$ENDIF}
        D3DXIFF_FORCE_DWORD = $7fffffff);

    TD3DXIMAGE_FILEFORMAT = _D3DXIMAGE_FILEFORMAT;
    PD3DXIMAGE_FILEFORMAT = ^TD3DXIMAGE_FILEFORMAT;



    //----------------------------------------------------------------------------
    // LPD3DXFILL2D and LPD3DXFILL3D:
    // ------------------------------
    // Function types used by the texture fill functions.

    // Parameters:
    //  pOut
    //      Pointer to a vector which the function uses to return its result.
    //      X,Y,Z,W will be mapped to R,G,B,A respectivly.
    //  pTexCoord
    //      Pointer to a vector containing the coordinates of the texel currently
    //      being evaluated.  Textures and VolumeTexture texcoord components
    //      range from 0 to 1. CubeTexture texcoord component range from -1 to 1.
    //  pTexelSize
    //      Pointer to a vector containing the dimensions of the current texel.
    //  pData
    //      Pointer to user data.

    //----------------------------------------------------------------------------


    LPD3DXFILL2D = procedure(pOut: PD3DXVECTOR4; pTexCoord: PD3DXVECTOR2; pTexelSize: PD3DXVECTOR2; pData: pointer); stdcall;

    LPD3DXFILL3D = procedure(pOut: PD3DXVECTOR4; pTexCoord: PD3DXVECTOR3; pTexelSize: PD3DXVECTOR3; pData: pointer); stdcall;



    //----------------------------------------------------------------------------
    // D3DXIMAGE_INFO:
    // ---------------
    // This structure is used to return a rough description of what the
    // the original contents of an image file looked like.

    //  Width
    //      Width of original image in pixels
    //  Height
    //      Height of original image in pixels
    //  Depth
    //      Depth of original image in pixels
    //  MipLevels
    //      Number of mip levels in original image
    //  Format
    //      D3D format which most closely describes the data in original image
    //  ResourceType
    //      D3DRESOURCETYPE representing the type of texture stored in the file.
    //      D3DRTYPE_TEXTURE, D3DRTYPE_VOLUMETEXTURE, or D3DRTYPE_CUBETEXTURE.
    //  ImageFileFormat
    //      D3DXIMAGE_FILEFORMAT representing the format of the image file.

    //----------------------------------------------------------------------------

    _D3DXIMAGE_INFO = record
        Width: UINT;
        Height: UINT;
        Depth: UINT;
        MipLevels: UINT;
        Format: TD3DFORMAT;
        ResourceType: TD3DRESOURCETYPE;
        ImageFileFormat: TD3DXIMAGE_FILEFORMAT;
    end;
    TD3DXIMAGE_INFO = _D3DXIMAGE_INFO;
    PD3DXIMAGE_INFO = ^TD3DXIMAGE_INFO;




    //////////////////////////////////////////////////////////////////////////////
    // Image File APIs ///////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    //----------------------------------------------------------------------------
    // GetImageInfoFromFile/Resource:
    // ------------------------------
    // Fills in a D3DXIMAGE_INFO struct with information about an image file.

    // Parameters:
    //  pSrcFile
    //      File name of the source image.
    //  pSrcModule
    //      Module where resource is located, or NULL for module associated
    //      with image the os used to create the current process.
    //  pSrcResource
    //      Resource name
    //  pSrcData
    //      Pointer to file in memory.
    //  SrcDataSize
    //      Size in bytes of file in memory.
    //  pSrcInfo
    //      Pointer to a D3DXIMAGE_INFO structure to be filled in with the
    //      description of the data in the source image file.

    //----------------------------------------------------------------------------

function D3DXGetImageInfoFromFileA(pSrcFile: LPCSTR; pSrcInfo: PD3DXIMAGE_INFO): HRESULT; stdcall; external D3DX9_DLL;


function D3DXGetImageInfoFromFileW(pSrcFile: LPCWSTR; pSrcInfo: PD3DXIMAGE_INFO): HRESULT; stdcall; external D3DX9_DLL;




function D3DXGetImageInfoFromResourceA(hSrcModule: HMODULE; pSrcResource: LPCSTR; pSrcInfo: PD3DXIMAGE_INFO): HRESULT; stdcall; external D3DX9_DLL;


function D3DXGetImageInfoFromResourceW(hSrcModule: HMODULE; pSrcResource: LPCWSTR; pSrcInfo: PD3DXIMAGE_INFO): HRESULT; stdcall; external D3DX9_DLL;




function D3DXGetImageInfoFromFileInMemory(pSrcData: LPCVOID; SrcDataSize: UINT; pSrcInfo: PD3DXIMAGE_INFO): HRESULT; stdcall; external D3DX9_DLL;




//////////////////////////////////////////////////////////////////////////////
// Load/Save Surface APIs ////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//----------------------------------------------------------------------------
// D3DXLoadSurfaceFromFile/Resource:
// ---------------------------------
// Load surface from a file or resource

// Parameters:
//  pDestSurface
//      Destination surface, which will receive the image.
//  pDestPalette
//      Destination palette of 256 colors, or NULL
//  pDestRect
//      Destination rectangle, or NULL for entire surface
//  pSrcFile
//      File name of the source image.
//  pSrcModule
//      Module where resource is located, or NULL for module associated
//      with image the os used to create the current process.
//  pSrcResource
//      Resource name
//  pSrcData
//      Pointer to file in memory.
//  SrcDataSize
//      Size in bytes of file in memory.
//  pSrcRect
//      Source rectangle, or NULL for entire image
//  Filter
//      D3DX_FILTER flags controlling how the image is filtered.
//      Or D3DX_DEFAULT for D3DX_FILTER_TRIANGLE.
//  ColorKey
//      Color to replace with transparent black, or 0 to disable colorkey.
//      This is always a 32-bit ARGB color, independent of the source image
//      format.  Alpha is significant, and should usually be set to FF for
//      opaque colorkeys.  (ex. Opaque black == 0xff000000)
//  pSrcInfo
//      Pointer to a D3DXIMAGE_INFO structure to be filled in with the
//      description of the data in the source image file, or NULL.

//----------------------------------------------------------------------------


function D3DXLoadSurfaceFromFileA(pDestSurface: IDirect3DSurface9; pDestPalette: PPALETTEENTRY; pDestRect: PRECT; pSrcFile: LPCSTR; pSrcRect: PRECT; Filter: DWORD; ColorKey: TD3DCOLOR;
    pSrcInfo: PD3DXIMAGE_INFO): HRESULT; stdcall; external D3DX9_DLL;


function D3DXLoadSurfaceFromFileW(pDestSurface: IDirect3DSurface9; pDestPalette: PPALETTEENTRY; pDestRect: PRECT; pSrcFile: LPCWSTR; pSrcRect: PRECT; Filter: DWORD; ColorKey: TD3DCOLOR;
    pSrcInfo: PD3DXIMAGE_INFO): HRESULT; stdcall; external D3DX9_DLL;



function D3DXLoadSurfaceFromResourceA(pDestSurface: IDirect3DSurface9; pDestPalette: PPALETTEENTRY; pDestRect: PRECT; hSrcModule: HMODULE; pSrcResource: LPCSTR; pSrcRect: PRECT; Filter: DWORD;
    ColorKey: TD3DCOLOR; pSrcInfo: PD3DXIMAGE_INFO): HRESULT; stdcall; external D3DX9_DLL;


function D3DXLoadSurfaceFromResourceW(pDestSurface: IDirect3DSurface9; pDestPalette: PPALETTEENTRY; pDestRect: PRECT; hSrcModule: HMODULE; pSrcResource: LPCWSTR; pSrcRect: PRECT; Filter: DWORD;
    ColorKey: TD3DCOLOR; pSrcInfo: PD3DXIMAGE_INFO): HRESULT; stdcall; external D3DX9_DLL;




function D3DXLoadSurfaceFromFileInMemory(pDestSurface: IDirect3DSurface9; pDestPalette: PPALETTEENTRY; pDestRect: PRECT; pSrcData: LPCVOID; SrcDataSize: UINT; pSrcRect: PRECT; Filter: DWORD;
    ColorKey: TD3DCOLOR; pSrcInfo: PD3DXIMAGE_INFO): HRESULT; stdcall; external D3DX9_DLL;




//----------------------------------------------------------------------------
// D3DXLoadSurfaceFromSurface:
// ---------------------------
// Load surface from another surface (with color conversion)

// Parameters:
//  pDestSurface
//      Destination surface, which will receive the image.
//  pDestPalette
//      Destination palette of 256 colors, or NULL
//  pDestRect
//      Destination rectangle, or NULL for entire surface
//  pSrcSurface
//      Source surface
//  pSrcPalette
//      Source palette of 256 colors, or NULL
//  pSrcRect
//      Source rectangle, or NULL for entire surface
//  Filter
//      D3DX_FILTER flags controlling how the image is filtered.
//      Or D3DX_DEFAULT for D3DX_FILTER_TRIANGLE.
//  ColorKey
//      Color to replace with transparent black, or 0 to disable colorkey.
//      This is always a 32-bit ARGB color, independent of the source image
//      format.  Alpha is significant, and should usually be set to FF for
//      opaque colorkeys.  (ex. Opaque black == 0xff000000)

//----------------------------------------------------------------------------

function D3DXLoadSurfaceFromSurface(pDestSurface: IDirect3DSurface9; pDestPalette: PPALETTEENTRY; pDestRect: PRECT; pSrcSurface: IDirect3DSurface9; pSrcPalette: PPALETTEENTRY; pSrcRect: PRECT;
    Filter: DWORD; ColorKey: TD3DCOLOR): HRESULT; stdcall; external D3DX9_DLL;



//----------------------------------------------------------------------------
// D3DXLoadSurfaceFromMemory:
// --------------------------
// Load surface from memory.

// Parameters:
//  pDestSurface
//      Destination surface, which will receive the image.
//  pDestPalette
//      Destination palette of 256 colors, or NULL
//  pDestRect
//      Destination rectangle, or NULL for entire surface
//  pSrcMemory
//      Pointer to the top-left corner of the source image in memory
//  SrcFormat
//      Pixel format of the source image.
//  SrcPitch
//      Pitch of source image, in bytes.  For DXT formats, this number
//      should represent the width of one row of cells, in bytes.
//  pSrcPalette
//      Source palette of 256 colors, or NULL
//  pSrcRect
//      Source rectangle.
//  Filter
//      D3DX_FILTER flags controlling how the image is filtered.
//      Or D3DX_DEFAULT for D3DX_FILTER_TRIANGLE.
//  ColorKey
//      Color to replace with transparent black, or 0 to disable colorkey.
//      This is always a 32-bit ARGB color, independent of the source image
//      format.  Alpha is significant, and should usually be set to FF for
//      opaque colorkeys.  (ex. Opaque black == 0xff000000)

//----------------------------------------------------------------------------

function D3DXLoadSurfaceFromMemory(pDestSurface: IDirect3DSurface9; pDestPalette: PPALETTEENTRY; pDestRect: PRECT; pSrcMemory: LPCVOID; SrcFormat: TD3DFORMAT; SrcPitch: UINT; pSrcPalette: PPALETTEENTRY;
    pSrcRect: PRECT; Filter: DWORD; ColorKey: TD3DCOLOR): HRESULT; stdcall; external D3DX9_DLL;



//----------------------------------------------------------------------------
// D3DXSaveSurfaceToFile:
// ----------------------
// Save a surface to a image file.

// Parameters:
//  pDestFile
//      File name of the destination file
//  DestFormat
//      D3DXIMAGE_FILEFORMAT specifying file format to use when saving.
//  pSrcSurface
//      Source surface, containing the image to be saved
//  pSrcPalette
//      Source palette of 256 colors, or NULL
//  pSrcRect
//      Source rectangle, or NULL for the entire image

//----------------------------------------------------------------------------

function D3DXSaveSurfaceToFileA(pDestFile: LPCSTR; DestFormat: TD3DXIMAGE_FILEFORMAT; pSrcSurface: IDirect3DSurface9; pSrcPalette: PPALETTEENTRY; pSrcRect: PRECT): HRESULT; stdcall; external D3DX9_DLL;


function D3DXSaveSurfaceToFileW(pDestFile: LPCWSTR; DestFormat: TD3DXIMAGE_FILEFORMAT; pSrcSurface: IDirect3DSurface9; pSrcPalette: PPALETTEENTRY; pSrcRect: PRECT): HRESULT; stdcall; external D3DX9_DLL;

{$IFDEF USESDK43 }

//----------------------------------------------------------------------------
// D3DXSaveSurfaceToFileInMemory:
// ----------------------
// Save a surface to a image file.

// Parameters:
//  ppDestBuf
//      address of pointer to d3dxbuffer for returning data bits
//  DestFormat
//      D3DXIMAGE_FILEFORMAT specifying file format to use when saving.
//  pSrcSurface
//      Source surface, containing the image to be saved
//  pSrcPalette
//      Source palette of 256 colors, or NULL
//  pSrcRect
//      Source rectangle, or NULL for the entire image

//----------------------------------------------------------------------------

function D3DXSaveSurfaceToFileInMemory(out ppDestBuf: ID3DXBuffer; DestFormat: TD3DXIMAGE_FILEFORMAT; pSrcSurface: IDirect3DSurface9; pSrcPalette: PPALETTEENTRY; pSrcRect: PRECT): HRESULT; stdcall; external D3DX9_DLL;
{$ENDIF}


//////////////////////////////////////////////////////////////////////////////
// Load/Save Volume APIs /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//----------------------------------------------------------------------------
// D3DXLoadVolumeFromFile/Resource:
// --------------------------------
// Load volume from a file or resource

// Parameters:
//  pDestVolume
//      Destination volume, which will receive the image.
//  pDestPalette
//      Destination palette of 256 colors, or NULL
//  pDestBox
//      Destination box, or NULL for entire volume
//  pSrcFile
//      File name of the source image.
//  pSrcModule
//      Module where resource is located, or NULL for module associated
//      with image the os used to create the current process.
//  pSrcResource
//      Resource name
//  pSrcData
//      Pointer to file in memory.
//  SrcDataSize
//      Size in bytes of file in memory.
//  pSrcBox
//      Source box, or NULL for entire image
//  Filter
//      D3DX_FILTER flags controlling how the image is filtered.
//      Or D3DX_DEFAULT for D3DX_FILTER_TRIANGLE.
//  ColorKey
//      Color to replace with transparent black, or 0 to disable colorkey.
//      This is always a 32-bit ARGB color, independent of the source image
//      format.  Alpha is significant, and should usually be set to FF for
//      opaque colorkeys.  (ex. Opaque black == 0xff000000)
//  pSrcInfo
//      Pointer to a D3DXIMAGE_INFO structure to be filled in with the
//      description of the data in the source image file, or NULL.

//----------------------------------------------------------------------------


function D3DXLoadVolumeFromFileA(pDestVolume: IDirect3DVolume9; pDestPalette: PPALETTEENTRY; pDestBox: PD3DBOX; pSrcFile: LPCSTR; pSrcBox: PD3DBOX; Filter: DWORD; ColorKey: TD3DCOLOR;
    pSrcInfo: PD3DXIMAGE_INFO): HRESULT; stdcall; external D3DX9_DLL;


function D3DXLoadVolumeFromFileW(pDestVolume: IDirect3DVolume9; pDestPalette: PPALETTEENTRY; pDestBox: PD3DBOX; pSrcFile: LPCWSTR; pSrcBox: PD3DBOX; Filter: DWORD; ColorKey: TD3DCOLOR;
    pSrcInfo: PD3DXIMAGE_INFO): HRESULT; stdcall; external D3DX9_DLL;



function D3DXLoadVolumeFromResourceA(pDestVolume: IDirect3DVolume9; pDestPalette: PPALETTEENTRY; pDestBox: PD3DBOX; hSrcModule: HMODULE; pSrcResource: LPCSTR; pSrcBox: PD3DBOX; Filter: DWORD;
    ColorKey: TD3DCOLOR; pSrcInfo: PD3DXIMAGE_INFO): HRESULT; stdcall; external D3DX9_DLL;


function D3DXLoadVolumeFromResourceW(pDestVolume: IDirect3DVolume9; pDestPalette: PPALETTEENTRY; pDestBox: PD3DBOX; hSrcModule: HMODULE; pSrcResource: LPCWSTR; pSrcBox: PD3DBOX; Filter: DWORD;
    ColorKey: TD3DCOLOR; pSrcInfo: PD3DXIMAGE_INFO): HRESULT; stdcall; external D3DX9_DLL;



function D3DXLoadVolumeFromFileInMemory(pDestVolume: IDirect3DVolume9; pDestPalette: PPALETTEENTRY; pDestBox: PD3DBOX; pSrcData: LPCVOID; SrcDataSize: UINT; pSrcBox: PD3DBOX; Filter: DWORD;
    ColorKey: TD3DCOLOR; pSrcInfo: PD3DXIMAGE_INFO): HRESULT; stdcall; external D3DX9_DLL;




//----------------------------------------------------------------------------
// D3DXLoadVolumeFromVolume:
// -------------------------
// Load volume from another volume (with color conversion)

// Parameters:
//  pDestVolume
//      Destination volume, which will receive the image.
//  pDestPalette
//      Destination palette of 256 colors, or NULL
//  pDestBox
//      Destination box, or NULL for entire volume
//  pSrcVolume
//      Source volume
//  pSrcPalette
//      Source palette of 256 colors, or NULL
//  pSrcBox
//      Source box, or NULL for entire volume
//  Filter
//      D3DX_FILTER flags controlling how the image is filtered.
//      Or D3DX_DEFAULT for D3DX_FILTER_TRIANGLE.
//  ColorKey
//      Color to replace with transparent black, or 0 to disable colorkey.
//      This is always a 32-bit ARGB color, independent of the source image
//      format.  Alpha is significant, and should usually be set to FF for
//      opaque colorkeys.  (ex. Opaque black == 0xff000000)

//----------------------------------------------------------------------------

function D3DXLoadVolumeFromVolume(pDestVolume: IDirect3DVolume9; pDestPalette: PPALETTEENTRY; pDestBox: PD3DBOX; pSrcVolume: IDirect3DVolume9; pSrcPalette: PPALETTEENTRY; pSrcBox: PD3DBOX;
    Filter: DWORD; ColorKey: TD3DCOLOR): HRESULT; stdcall; external D3DX9_DLL;




//----------------------------------------------------------------------------
// D3DXLoadVolumeFromMemory:
// -------------------------
// Load volume from memory.

// Parameters:
//  pDestVolume
//      Destination volume, which will receive the image.
//  pDestPalette
//      Destination palette of 256 colors, or NULL
//  pDestBox
//      Destination box, or NULL for entire volume
//  pSrcMemory
//      Pointer to the top-left corner of the source volume in memory
//  SrcFormat
//      Pixel format of the source volume.
//  SrcRowPitch
//      Pitch of source image, in bytes.  For DXT formats, this number
//      should represent the size of one row of cells, in bytes.
//  SrcSlicePitch
//      Pitch of source image, in bytes.  For DXT formats, this number
//      should represent the size of one slice of cells, in bytes.
//  pSrcPalette
//      Source palette of 256 colors, or NULL
//  pSrcBox
//      Source box.
//  Filter
//      D3DX_FILTER flags controlling how the image is filtered.
//      Or D3DX_DEFAULT for D3DX_FILTER_TRIANGLE.
//  ColorKey
//      Color to replace with transparent black, or 0 to disable colorkey.
//      This is always a 32-bit ARGB color, independent of the source image
//      format.  Alpha is significant, and should usually be set to FF for
//      opaque colorkeys.  (ex. Opaque black == 0xff000000)

//----------------------------------------------------------------------------

function D3DXLoadVolumeFromMemory(pDestVolume: IDirect3DVolume9; pDestPalette: PPALETTEENTRY; pDestBox: PD3DBOX; pSrcMemory: LPCVOID; SrcFormat: TD3DFORMAT; SrcRowPitch: UINT; SrcSlicePitch: UINT;
    pSrcPalette: PPALETTEENTRY; pSrcBox: PD3DBOX; Filter: DWORD; ColorKey: TD3DCOLOR): HRESULT; stdcall; external D3DX9_DLL;




//----------------------------------------------------------------------------
// D3DXSaveVolumeToFile:
// ---------------------
// Save a volume to a image file.

// Parameters:
//  pDestFile
//      File name of the destination file
//  DestFormat
//      D3DXIMAGE_FILEFORMAT specifying file format to use when saving.
//  pSrcVolume
//      Source volume, containing the image to be saved
//  pSrcPalette
//      Source palette of 256 colors, or NULL
//  pSrcBox
//      Source box, or NULL for the entire volume

//----------------------------------------------------------------------------

function D3DXSaveVolumeToFileA(pDestFile: LPCSTR; DestFormat: TD3DXIMAGE_FILEFORMAT; pSrcVolume: IDirect3DVolume9; pSrcPalette: PPALETTEENTRY; pSrcBox: PD3DBOX): HRESULT; stdcall; external D3DX9_DLL;


function D3DXSaveVolumeToFileW(pDestFile: LPCWSTR; DestFormat: TD3DXIMAGE_FILEFORMAT; pSrcVolume: IDirect3DVolume9; pSrcPalette: PPALETTEENTRY; pSrcBox: PD3DBOX): HRESULT; stdcall; external D3DX9_DLL;

{$IFDEF USESDK43}

//----------------------------------------------------------------------------
// D3DXSaveVolumeToFileInMemory:
// ---------------------
// Save a volume to a image file.

// Parameters:
//  pDestFile
//      File name of the destination file
//  DestFormat
//      D3DXIMAGE_FILEFORMAT specifying file format to use when saving.
//  pSrcVolume
//      Source volume, containing the image to be saved
//  pSrcPalette
//      Source palette of 256 colors, or NULL
//  pSrcBox
//      Source box, or NULL for the entire volume

//----------------------------------------------------------------------------

function D3DXSaveVolumeToFileInMemory(out ppDestBuf: ID3DXBuffer; DestFormat: TD3DXIMAGE_FILEFORMAT; pSrcVolume: IDirect3DVolume9; pSrcPalette: PPALETTEENTRY; pSrcBox: PD3DBOX): HRESULT; stdcall; external D3DX9_DLL;
{$ENDIF}


//////////////////////////////////////////////////////////////////////////////
// Create/Save Texture APIs //////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//----------------------------------------------------------------------------
// D3DXCheckTextureRequirements:
// -----------------------------
// Checks texture creation parameters.  If parameters are invalid, this
// function returns corrected parameters.

// Parameters:

//  pDevice
//      The D3D device to be used
//  pWidth, pHeight, pDepth, pSize
//      Desired size in pixels, or NULL.  Returns corrected size.
//  pNumMipLevels
//      Number of desired mipmap levels, or NULL.  Returns corrected number.
//  Usage
//      Texture usage flags
//  pFormat
//      Desired pixel format, or NULL.  Returns corrected format.
//  Pool
//      Memory pool to be used to create texture

//----------------------------------------------------------------------------


function D3DXCheckTextureRequirements(pDevice: IDirect3DDevice9; pWidth: PUINT; pHeight: PUINT; pNumMipLevels: PUINT; Usage: DWORD; pFormat: PD3DFORMAT; Pool: TD3DPOOL): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCheckCubeTextureRequirements(pDevice: IDirect3DDevice9; pSize: PUINT; pNumMipLevels: PUINT; Usage: DWORD; pFormat: PD3DFORMAT; Pool: TD3DPOOL): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCheckVolumeTextureRequirements(pDevice: IDirect3DDevice9; pWidth: PUINT; pHeight: PUINT; pDepth: PUINT; pNumMipLevels: PUINT; Usage: DWORD; pFormat: PD3DFORMAT; Pool: TD3DPOOL): HRESULT; stdcall; external D3DX9_DLL;



//----------------------------------------------------------------------------
// D3DXCreateTexture:
// ------------------
// Create an empty texture

// Parameters:

//  pDevice
//      The D3D device with which the texture is going to be used.
//  Width, Height, Depth, Size
//      size in pixels. these must be non-zero
//  MipLevels
//      number of mip levels desired. if zero or D3DX_DEFAULT, a complete
//      mipmap chain will be created.
//  Usage
//      Texture usage flags
//  Format
//      Pixel format.
//  Pool
//      Memory pool to be used to create texture
//  ppTexture, ppCubeTexture, ppVolumeTexture
//      The texture object that will be created

//----------------------------------------------------------------------------

function D3DXCreateTexture(pDevice: IDirect3DDevice9; Width: UINT; Height: UINT; MipLevels: UINT; Usage: DWORD; Format: TD3DFORMAT; Pool: TD3DPOOL; out ppTexture: IDirect3DTexture9): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateCubeTexture(pDevice: IDirect3DDevice9; Size: UINT; MipLevels: UINT; Usage: DWORD; Format: TD3DFORMAT; Pool: TD3DPOOL; out ppCubeTexture: IDirect3DCubeTexture9): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateVolumeTexture(pDevice: IDirect3DDevice9; Width: UINT; Height: UINT; Depth: UINT; MipLevels: UINT; Usage: DWORD; Format: TD3DFORMAT; Pool: TD3DPOOL; out ppVolumeTexture: IDirect3DVolumeTexture9): HRESULT;
    stdcall; external D3DX9_DLL;




//----------------------------------------------------------------------------
// D3DXCreateTextureFromFile/Resource:
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
//  Width, Height, Depth, Size
//      Size in pixels.  If zero or D3DX_DEFAULT, the size will be taken from
//      the file and rounded up to a power of two.  If D3DX_DEFAULT_NONPOW2,
//      the size will be not be rounded, if the device supports NONPOW2 textures.
//  MipLevels
//      Number of mip levels.  If zero or D3DX_DEFAULT, a complete mipmap
//      chain will be created.
//  Usage
//      Texture usage flags
//  Format
//      Desired pixel format.  If D3DFMT_UNKNOWN, the format will be
//      taken from the file.
//  Pool
//      Memory pool to be used to create texture
//  Filter
//      D3DX_FILTER flags controlling how the image is filtered.
//      Or D3DX_DEFAULT for D3DX_FILTER_TRIANGLE.
//  MipFilter
//      D3DX_FILTER flags controlling how each miplevel is filtered.
//      Or D3DX_DEFAULT for D3DX_FILTER_BOX,
//  ColorKey
//      Color to replace with transparent black, or 0 to disable colorkey.
//      This is always a 32-bit ARGB color, independent of the source image
//      format.  Alpha is significant, and should usually be set to FF for
//      opaque colorkeys.  (ex. Opaque black == 0xff000000)
//  pSrcInfo
//      Pointer to a D3DXIMAGE_INFO structure to be filled in with the
//      description of the data in the source image file, or NULL.
//  pPalette
//      256 color palette to be filled in, or NULL
//  ppTexture, ppCubeTexture, ppVolumeTexture
//      The texture object that will be created

//----------------------------------------------------------------------------
// FromFile



function D3DXCreateTextureFromFileA(pDevice: IDirect3DDevice9; pSrcFile: LPCSTR; out ppTexture: IDirect3DTexture9): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateTextureFromFileW(pDevice: IDirect3DDevice9; pSrcFile: LPCWSTR; out ppTexture: IDirect3DTexture9): HRESULT; stdcall; external D3DX9_DLL;



function D3DXCreateCubeTextureFromFileA(pDevice: IDirect3DDevice9; pSrcFile: LPCSTR; out ppCubeTexture: IDirect3DCubeTexture9): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateCubeTextureFromFileW(pDevice: IDirect3DDevice9; pSrcFile: LPCWSTR; out ppCubeTexture: IDirect3DCubeTexture9): HRESULT; stdcall; external D3DX9_DLL;



function D3DXCreateVolumeTextureFromFileA(pDevice: IDirect3DDevice9; pSrcFile: LPCSTR; out ppVolumeTexture: IDirect3DVolumeTexture9): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateVolumeTextureFromFileW(pDevice: IDirect3DDevice9; pSrcFile: LPCWSTR; out ppVolumeTexture: IDirect3DVolumeTexture9): HRESULT; stdcall; external D3DX9_DLL;




// FromResource

function D3DXCreateTextureFromResourceA(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: LPCSTR; out ppTexture: IDirect3DTexture9): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateTextureFromResourceW(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: LPCWSTR; out ppTexture: IDirect3DTexture9): HRESULT; stdcall; external D3DX9_DLL;




function D3DXCreateCubeTextureFromResourceA(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: LPCSTR; out ppCubeTexture: IDirect3DCubeTexture9): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateCubeTextureFromResourceW(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: LPCWSTR; out ppCubeTexture: IDirect3DCubeTexture9): HRESULT; stdcall; external D3DX9_DLL;




function D3DXCreateVolumeTextureFromResourceA(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: LPCSTR; out ppVolumeTexture: IDirect3DVolumeTexture9): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateVolumeTextureFromResourceW(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: LPCWSTR; out ppVolumeTexture: IDirect3DVolumeTexture9): HRESULT; stdcall; external D3DX9_DLL;




// FromFileEx

function D3DXCreateTextureFromFileExA(pDevice: IDirect3DDevice9; pSrcFile: LPCSTR; Width: UINT; Height: UINT; MipLevels: UINT; Usage: DWORD; Format: TD3DFORMAT; Pool: TD3DPOOL; Filter: DWORD;
    MipFilter: DWORD; ColorKey: TD3DCOLOR; pSrcInfo: PD3DXIMAGE_INFO; pPalette: PPALETTEENTRY; out ppTexture: IDirect3DTexture9): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateTextureFromFileExW(pDevice: IDirect3DDevice9; pSrcFile: LPCWSTR; Width: UINT; Height: UINT; MipLevels: UINT; Usage: DWORD; Format: TD3DFORMAT; Pool: TD3DPOOL; Filter: DWORD;
    MipFilter: DWORD; ColorKey: TD3DCOLOR; pSrcInfo: PD3DXIMAGE_INFO; pPalette: PPALETTEENTRY; out ppTexture: IDirect3DTexture9): HRESULT; stdcall; external D3DX9_DLL;




function D3DXCreateCubeTextureFromFileExA(pDevice: IDirect3DDevice9; pSrcFile: LPCSTR; Size: UINT; MipLevels: UINT; Usage: DWORD; Format: TD3DFORMAT; Pool: TD3DPOOL; Filter: DWORD;
    MipFilter: DWORD; ColorKey: TD3DCOLOR; pSrcInfo: PD3DXIMAGE_INFO; pPalette: PPALETTEENTRY; out ppCubeTexture: IDirect3DCubeTexture9): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateCubeTextureFromFileExW(pDevice: IDirect3DDevice9; pSrcFile: LPCWSTR; Size: UINT; MipLevels: UINT; Usage: DWORD; Format: TD3DFORMAT; Pool: TD3DPOOL; Filter: DWORD;
    MipFilter: DWORD; ColorKey: TD3DCOLOR; pSrcInfo: PD3DXIMAGE_INFO; pPalette: PPALETTEENTRY; out ppCubeTexture: IDirect3DCubeTexture9): HRESULT; stdcall; external D3DX9_DLL;




function D3DXCreateVolumeTextureFromFileExA(pDevice: IDirect3DDevice9; pSrcFile: LPCSTR; Width: UINT; Height: UINT; Depth: UINT; MipLevels: UINT; Usage: DWORD; Format: TD3DFORMAT; Pool: TD3DPOOL;
    Filter: DWORD; MipFilter: DWORD; ColorKey: TD3DCOLOR; pSrcInfo: PD3DXIMAGE_INFO; pPalette: PPALETTEENTRY; out ppVolumeTexture: IDirect3DVolumeTexture9): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateVolumeTextureFromFileExW(pDevice: IDirect3DDevice9; pSrcFile: LPCWSTR; Width: UINT; Height: UINT; Depth: UINT; MipLevels: UINT; Usage: DWORD; Format: TD3DFORMAT;
    Pool: TD3DPOOL; Filter: DWORD; MipFilter: DWORD; ColorKey: TD3DCOLOR; pSrcInfo: PD3DXIMAGE_INFO; pPalette: PPALETTEENTRY; out ppVolumeTexture: IDirect3DVolumeTexture9): HRESULT; stdcall; external D3DX9_DLL;



// FromResourceEx

function D3DXCreateTextureFromResourceExA(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: LPCSTR; Width: UINT; Height: UINT; MipLevels: UINT; Usage: DWORD; Format: TD3DFORMAT;
    Pool: TD3DPOOL; Filter: DWORD; MipFilter: DWORD; ColorKey: TD3DCOLOR; pSrcInfo: PD3DXIMAGE_INFO; pPalette: PPALETTEENTRY; out ppTexture: IDirect3DTexture9): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateTextureFromResourceExW(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: LPCWSTR; Width: UINT; Height: UINT; MipLevels: UINT; Usage: DWORD; Format: TD3DFORMAT;
    Pool: TD3DPOOL; Filter: DWORD; MipFilter: DWORD; ColorKey: TD3DCOLOR; pSrcInfo: PD3DXIMAGE_INFO; pPalette: PPALETTEENTRY; out ppTexture: IDirect3DTexture9): HRESULT; stdcall; external D3DX9_DLL;



function D3DXCreateCubeTextureFromResourceExA(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: LPCSTR; Size: UINT; MipLevels: UINT; Usage: DWORD; Format: TD3DFORMAT; Pool: TD3DPOOL;
    Filter: DWORD; MipFilter: DWORD; ColorKey: TD3DCOLOR; pSrcInfo: PD3DXIMAGE_INFO; pPalette: PPALETTEENTRY; out ppCubeTexture: IDirect3DCubeTexture9): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateCubeTextureFromResourceExW(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: LPCWSTR; Size: UINT; MipLevels: UINT; Usage: DWORD; Format: TD3DFORMAT; Pool: TD3DPOOL;
    Filter: DWORD; MipFilter: DWORD; ColorKey: TD3DCOLOR; pSrcInfo: PD3DXIMAGE_INFO; pPalette: PPALETTEENTRY; out ppCubeTexture: IDirect3DCubeTexture9): HRESULT; stdcall; external D3DX9_DLL;




function D3DXCreateVolumeTextureFromResourceExA(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: LPCSTR; Width: UINT; Height: UINT; Depth: UINT; MipLevels: UINT; Usage: DWORD;
    Format: TD3DFORMAT; Pool: TD3DPOOL; Filter: DWORD; MipFilter: DWORD; ColorKey: TD3DCOLOR; pSrcInfo: PD3DXIMAGE_INFO; pPalette: PPALETTEENTRY; out ppVolumeTexture: IDirect3DVolumeTexture9): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateVolumeTextureFromResourceExW(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: LPCWSTR; Width: UINT; Height: UINT; Depth: UINT; MipLevels: UINT; Usage: DWORD;
    Format: TD3DFORMAT; Pool: TD3DPOOL; Filter: DWORD; MipFilter: DWORD; ColorKey: TD3DCOLOR; pSrcInfo: PD3DXIMAGE_INFO; pPalette: PPALETTEENTRY; out ppVolumeTexture: IDirect3DVolumeTexture9): HRESULT; stdcall; external D3DX9_DLL;




// FromFileInMemory

function D3DXCreateTextureFromFileInMemory(pDevice: IDirect3DDevice9; pSrcData: LPCVOID; SrcDataSize: UINT; out ppTexture: IDirect3DTexture9): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateCubeTextureFromFileInMemory(pDevice: IDirect3DDevice9; pSrcData: LPCVOID; SrcDataSize: UINT; out ppCubeTexture: IDirect3DCubeTexture9): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateVolumeTextureFromFileInMemory(pDevice: IDirect3DDevice9; pSrcData: LPCVOID; SrcDataSize: UINT; out ppVolumeTexture: IDirect3DVolumeTexture9): HRESULT; stdcall; external D3DX9_DLL;



// FromFileInMemoryEx

function D3DXCreateTextureFromFileInMemoryEx(pDevice: IDirect3DDevice9; pSrcData: LPCVOID; SrcDataSize: UINT; Width: UINT; Height: UINT; MipLevels: UINT; Usage: DWORD; Format: TD3DFORMAT;
    Pool: TD3DPOOL; Filter: DWORD; MipFilter: DWORD; ColorKey: TD3DCOLOR; pSrcInfo: PD3DXIMAGE_INFO; pPalette: PPALETTEENTRY; out ppTexture: IDirect3DTexture9): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateCubeTextureFromFileInMemoryEx(pDevice: IDirect3DDevice9; pSrcData: LPCVOID; SrcDataSize: UINT; Size: UINT; MipLevels: UINT; Usage: DWORD; Format: TD3DFORMAT; Pool: TD3DPOOL;
    Filter: DWORD; MipFilter: DWORD; ColorKey: TD3DCOLOR; pSrcInfo: PD3DXIMAGE_INFO; pPalette: PPALETTEENTRY; out ppCubeTexture: IDirect3DCubeTexture9): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateVolumeTextureFromFileInMemoryEx(pDevice: IDirect3DDevice9; pSrcData: LPCVOID; SrcDataSize: UINT; Width: UINT; Height: UINT; Depth: UINT; MipLevels: UINT; Usage: DWORD;
    Format: TD3DFORMAT; Pool: TD3DPOOL; Filter: DWORD; MipFilter: DWORD; ColorKey: TD3DCOLOR; pSrcInfo: PD3DXIMAGE_INFO; pPalette: PPALETTEENTRY; out ppVolumeTexture: IDirect3DVolumeTexture9): HRESULT; stdcall; external D3DX9_DLL;




//----------------------------------------------------------------------------
// D3DXSaveTextureToFile:
// ----------------------
// Save a texture to a file.

// Parameters:
//  pDestFile
//      File name of the destination file
//  DestFormat
//      D3DXIMAGE_FILEFORMAT specifying file format to use when saving.
//  pSrcTexture
//      Source texture, containing the image to be saved
//  pSrcPalette
//      Source palette of 256 colors, or NULL

//----------------------------------------------------------------------------


function D3DXSaveTextureToFileA(pDestFile: LPCSTR; DestFormat: TD3DXIMAGE_FILEFORMAT; pSrcTexture: IDirect3DBaseTexture9; pSrcPalette: PPALETTEENTRY): HRESULT; stdcall; external D3DX9_DLL;


function D3DXSaveTextureToFileW(pDestFile: LPCWSTR; DestFormat: TD3DXIMAGE_FILEFORMAT; pSrcTexture: IDirect3DBaseTexture9; pSrcPalette: PPALETTEENTRY): HRESULT; stdcall; external D3DX9_DLL;

{$IFDEF USESDK43}

//----------------------------------------------------------------------------
// D3DXSaveTextureToFileInMemory:
// ----------------------
// Save a texture to a file.

// Parameters:
//  ppDestBuf
//      address of a d3dxbuffer pointer to return the image data
//  DestFormat
//      D3DXIMAGE_FILEFORMAT specifying file format to use when saving.
//  pSrcTexture
//      Source texture, containing the image to be saved
//  pSrcPalette
//      Source palette of 256 colors, or NULL

//----------------------------------------------------------------------------

function D3DXSaveTextureToFileInMemory(out ppDestBuf: ID3DXBuffer; DestFormat: TD3DXIMAGE_FILEFORMAT; pSrcTexture: IDirect3DBaseTexture9; pSrcPalette: PPALETTEENTRY): HRESULT; stdcall; external D3DX9_DLL;
{$ENDIF}


//////////////////////////////////////////////////////////////////////////////
// Misc Texture APIs /////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//----------------------------------------------------------------------------
// D3DXFilterTexture:
// ------------------
// Filters mipmaps levels of a texture.

// Parameters:
//  pBaseTexture
//      The texture object to be filtered
//  pPalette
//      256 color palette to be used, or NULL for non-palettized formats
//  SrcLevel
//      The level whose image is used to generate the subsequent levels.
//  Filter
//      D3DX_FILTER flags controlling how each miplevel is filtered.
//      Or D3DX_DEFAULT for D3DX_FILTER_BOX,

//----------------------------------------------------------------------------


function D3DXFilterTexture(pBaseTexture: IDirect3DBaseTexture9; pPalette: PPALETTEENTRY; SrcLevel: UINT; Filter: DWORD): HRESULT; stdcall; external D3DX9_DLL;




//----------------------------------------------------------------------------
// D3DXFillTexture:
// ----------------
// Uses a user provided function to fill each texel of each mip level of a
// given texture.

// Paramters:
//  pTexture, pCubeTexture, pVolumeTexture
//      Pointer to the texture to be filled.
//  pFunction
//      Pointer to user provided evalutor function which will be used to
//      compute the value of each texel.
//  pData
//      Pointer to an arbitrary block of user defined data.  This pointer
//      will be passed to the function provided in pFunction
//-----------------------------------------------------------------------------

function D3DXFillTexture(pTexture: IDirect3DTexture9; pFunction: LPD3DXFILL2D; pData: LPVOID): HRESULT; stdcall; external D3DX9_DLL;


function D3DXFillCubeTexture(pCubeTexture: IDirect3DCubeTexture9; pFunction: LPD3DXFILL3D; pData: LPVOID): HRESULT; stdcall; external D3DX9_DLL;


function D3DXFillVolumeTexture(pVolumeTexture: IDirect3DVolumeTexture9; pFunction: LPD3DXFILL3D; pData: LPVOID): HRESULT; stdcall; external D3DX9_DLL;


{$IFDEF USESDK43 }
 //---------------------------------------------------------------------------
// D3DXFillTextureTX:
// ------------------
// Uses a TX Shader target to function to fill each texel of each mip level
// of a given texture. The TX Shader target should be a compiled function
// taking 2 paramters and returning a float4 color.
//
// Paramters:
//  pTexture, pCubeTexture, pVolumeTexture
//      Pointer to the texture to be filled.
//  pTextureShader
//      Pointer to the texture shader to be used to fill in the texture
//----------------------------------------------------------------------------

function D3DXFillTextureTX(
pTexture : IDirect3DTexture9 ;
pTextureShader : ID3DXTextureShader
    ) : HRESULT;stdcall; external D3DX9_DLL;



function D3DXFillCubeTextureTX(
pCubeTexture : IDirect3DCubeTexture9 ;
pTextureShader : ID3DXTextureShader
    ) : HRESULT;stdcall; external D3DX9_DLL;



function D3DXFillVolumeTextureTX(
pVolumeTexture : IDirect3DVolumeTexture9 ;
pTextureShader : ID3DXTextureShader
    ) : HRESULT;stdcall; external D3DX9_DLL;


{$ELSE}
//----------------------------------------------------------------------------
// D3DXFillTextureTX:
// ----------------
// Uses a TX Shader target to function to fill each texel of each mip level of a
// given texture. The TX Shader target should be a compiled function taking 2
// 2 paramters and returning a float4 color.

// Paramters:
//  pTexture, pCubeTexture, pVolumeTexture
//      Pointer to the texture to be filled.
//  pFunction:
//      Pointer to the compiled function returned by D3DX
//  pConstants
//      Constants used by program. Should be filled by user by parsing constant
//      Table information
//  Constants
//      Number of Constants
//-----------------------------------------------------------------------------

function D3DXFillTextureTX(pTexture: IDirect3DTexture9; pFunction: PDWORD; pConstants: PD3DXVECTOR4; Constants: UINT): HRESULT; stdcall; external D3DX9_DLL;
function D3DXFillCubeTextureTX(pCubeTexture: IDirect3DCubeTexture9; pFunction: PDWORD; pConstants: PD3DXVECTOR4; Constants: UINT): HRESULT; stdcall; external D3DX9_DLL;
function D3DXFillVolumeTextureTX(pVolumeTexture: IDirect3DVolumeTexture9; pFunction: PDWORD; pConstants: PD3DXVECTOR4; Constants: UINT): HRESULT; stdcall; external D3DX9_DLL;
{$ENDIF}


//----------------------------------------------------------------------------
// D3DXComputeNormalMap:
// ---------------------
// Converts a height map into a normal map.  The (x,y,z) components of each
// normal are mapped to the (r,g,b) channels of the output texture.

// Parameters
//  pTexture
//      Pointer to the destination texture
//  pSrcTexture
//      Pointer to the source heightmap texture
//  pSrcPalette
//      Source palette of 256 colors, or NULL
//  Flags
//      D3DX_NORMALMAP flags
//  Channel
//      D3DX_CHANNEL specifying source of height information
//  Amplitude
//      The constant value which the height information is multiplied by.
//---------------------------------------------------------------------------

function D3DXComputeNormalMap(pTexture: IDirect3DTexture9; pSrcTexture: IDirect3DTexture9; pSrcPalette: PPALETTEENTRY; Flags: DWORD; Channel: DWORD; Amplitude: single): HRESULT; stdcall; external D3DX9_DLL;




function D3DXFilterCubeTexture(pBaseTexture: IDirect3DBaseTexture9; pPalette: PPALETTEENTRY; SrcLevel: UINT; Filter: DWORD): HRESULT; stdcall;


function D3DXFilterVolumeTexture(pBaseTexture: IDirect3DBaseTexture9; pPalette: PPALETTEENTRY; SrcLevel: UINT; Filter: DWORD): HRESULT; stdcall;




implementation



function D3DXFilterCubeTexture(pBaseTexture: IDirect3DBaseTexture9; pPalette: PPALETTEENTRY; SrcLevel: UINT; Filter: DWORD): HRESULT; stdcall;
begin
    Result := D3DXFilterTexture(pBaseTexture, pPalette, SrcLevel, Filter);
end;



function D3DXFilterVolumeTexture(pBaseTexture: IDirect3DBaseTexture9; pPalette: PPALETTEENTRY; SrcLevel: UINT; Filter: DWORD): HRESULT; stdcall;
begin
    Result := D3DXFilterTexture(pBaseTexture, pPalette, SrcLevel, Filter);
end;

end.
