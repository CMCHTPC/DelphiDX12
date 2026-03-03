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
   File name: d3d10_1.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3D10_1;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3DCommon,
    DX12.DXGI,
    DX12.DXGIFormat,
    DX12.D3D10,
    DX12.D3D10Misc;

    {$Z4}

const
    D3D10_1_DLL = 'd3d10_1.dll';

    IID_ID3D10BlendState1: TGUID = '{EDAD8D99-8A35-4D6D-8566-2EA276CDE161}';
    IID_ID3D10ShaderResourceView1: TGUID = '{9B7E4C87-342C-4106-A19F-4F2704F689F0}';
    IID_ID3D10Device1: TGUID = '{9B7E4C8F-342C-4106-A19F-4F2704F689F0}';


    D3D10_1_DEFAULT_SAMPLE_MASK = ($ffffffff);

    D3D10_1_FLOAT16_FUSED_TOLERANCE_IN_ULP = (0.6);
    D3D10_1_FLOAT32_TO_INTEGER_TOLERANCE_IN_ULP = (0.6);
    D3D10_1_GS_INPUT_REGISTER_COUNT = (32);

    D3D10_1_IA_VERTEX_INPUT_RESOURCE_SLOT_COUNT = (32);

    D3D10_1_IA_VERTEX_INPUT_STRUCTURE_ELEMENTS_COMPONENTS = (128);

    D3D10_1_IA_VERTEX_INPUT_STRUCTURE_ELEMENT_COUNT = (32);

    D3D10_1_PS_OUTPUT_MASK_REGISTER_COMPONENTS = (1);

    D3D10_1_PS_OUTPUT_MASK_REGISTER_COMPONENT_BIT_COUNT = (32);

    D3D10_1_PS_OUTPUT_MASK_REGISTER_COUNT = (1);

    D3D10_1_SHADER_MAJOR_VERSION = (4);

    D3D10_1_SHADER_MINOR_VERSION = (1);

    D3D10_1_SO_BUFFER_MAX_STRIDE_IN_BYTES = (2048);

    D3D10_1_SO_BUFFER_MAX_WRITE_WINDOW_IN_BYTES = (256);

    D3D10_1_SO_BUFFER_SLOT_COUNT = (4);

    D3D10_1_SO_MULTIPLE_BUFFER_ELEMENTS_PER_BUFFER = (1);

    D3D10_1_SO_SINGLE_BUFFER_COMPONENT_LIMIT = (64);

    D3D10_1_STANDARD_VERTEX_ELEMENT_COUNT = (32);

    D3D10_1_SUBPIXEL_FRACTIONAL_BIT_COUNT = (8);

    D3D10_1_VS_INPUT_REGISTER_COUNT = (32);

    D3D10_1_VS_OUTPUT_REGISTER_COUNT = (32);

    D3D10_1_SDK_VERSION = ((0 + $20));

type

    (* Forward Declarations *)
    ID3D10BlendState1 = interface;
    ID3D10ShaderResourceView1 = interface;
    ID3D10Device1 = interface;


    TD3D10_FEATURE_LEVEL1 = (
        D3D10_FEATURE_LEVEL_10_0 = $a000,
        D3D10_FEATURE_LEVEL_10_1 = $a100,
        D3D10_FEATURE_LEVEL_9_1 = $9100,
        D3D10_FEATURE_LEVEL_9_2 = $9200,
        D3D10_FEATURE_LEVEL_9_3 = $9300);

    PD3D10_FEATURE_LEVEL1 = ^TD3D10_FEATURE_LEVEL1;


    TD3D10_RENDER_TARGET_BLEND_DESC1 = record
        BlendEnable: boolean;
        SrcBlend: TD3D10_BLEND;
        DestBlend: TD3D10_BLEND;
        BlendOp: TD3D10_BLEND_OP;
        SrcBlendAlpha: TD3D10_BLEND;
        DestBlendAlpha: TD3D10_BLEND;
        BlendOpAlpha: TD3D10_BLEND_OP;
        RenderTargetWriteMask: uint8;
    end;
    PD3D10_RENDER_TARGET_BLEND_DESC1 = ^TD3D10_RENDER_TARGET_BLEND_DESC1;


    TD3D10_BLEND_DESC1 = record
        AlphaToCoverageEnable: boolean;
        IndependentBlendEnable: boolean;
        RenderTarget: array [0..8 - 1] of TD3D10_RENDER_TARGET_BLEND_DESC1;
    end;
    PD3D10_BLEND_DESC1 = ^TD3D10_BLEND_DESC1;


    ID3D10BlendState1 = interface(ID3D10BlendState)
        ['{EDAD8D99-8A35-4d6d-8566-2EA276CDE161}']
        procedure GetDesc1(
        {_Out_  } pDesc: PD3D10_BLEND_DESC1); stdcall;

    end;


    TD3D10_TEXCUBE_ARRAY_SRV1 = record
        MostDetailedMip: UINT;
        MipLevels: UINT;
        First2DArrayFace: UINT;
        NumCubes: UINT;
    end;
    PD3D10_TEXCUBE_ARRAY_SRV1 = ^TD3D10_TEXCUBE_ARRAY_SRV1;


    TD3D10_SRV_DIMENSION1 = TD3D_SRV_DIMENSION;

    TD3D10_SHADER_RESOURCE_VIEW_DESC1 = record
        Format: TDXGI_FORMAT;
        ViewDimension: TD3D10_SRV_DIMENSION1;
        case integer of
            0: (
                Buffer: TD3D10_BUFFER_SRV;
            );
            1: (
                Texture1D: TD3D10_TEX1D_SRV;
            );
            2: (
                Texture1DArray: TD3D10_TEX1D_ARRAY_SRV;
            );
            3: (
                Texture2D: TD3D10_TEX2D_SRV;
            );
            4: (
                Texture2DArray: TD3D10_TEX2D_ARRAY_SRV;
            );
            5: (
                Texture2DMS: TD3D10_TEX2DMS_SRV;
            );
            6: (
                Texture2DMSArray: TD3D10_TEX2DMS_ARRAY_SRV;
            );
            7: (
                Texture3D: TD3D10_TEX3D_SRV;
            );
            8: (
                TextureCube: TD3D10_TEXCUBE_SRV;
            );
            9: (
                TextureCubeArray: TD3D10_TEXCUBE_ARRAY_SRV1;
            );

    end;
    PD3D10_SHADER_RESOURCE_VIEW_DESC1 = ^TD3D10_SHADER_RESOURCE_VIEW_DESC1;


    ID3D10ShaderResourceView1 = interface(ID3D10ShaderResourceView)
        ['{9B7E4C87-342C-4106-A19F-4F2704F689F0}']
        procedure GetDesc1(
        {_Out_  } pDesc: PD3D10_SHADER_RESOURCE_VIEW_DESC1); stdcall;

    end;


    TD3D10_STANDARD_MULTISAMPLE_QUALITY_LEVELS = (
        D3D10_STANDARD_MULTISAMPLE_PATTERN = longint($ffffffff),
        D3D10_CENTER_MULTISAMPLE_PATTERN = longint($fffffffe));

    PD3D10_STANDARD_MULTISAMPLE_QUALITY_LEVELS = ^TD3D10_STANDARD_MULTISAMPLE_QUALITY_LEVELS;


    ID3D10Device1 = interface(ID3D10Device)
        ['{9B7E4C8F-342C-4106-A19F-4F2704F689F0}']
        function CreateShaderResourceView1(
        {_In_  } pResource: ID3D10Resource;
        {_In_opt_  } pDesc: PD3D10_SHADER_RESOURCE_VIEW_DESC1;
        {_Out_opt_  }  out ppSRView: ID3D10ShaderResourceView1): HRESULT; stdcall;

        function CreateBlendState1(
        {_In_  } pBlendStateDesc: PD3D10_BLEND_DESC1;
        {_Out_opt_  }  out ppBlendState: ID3D10BlendState1): HRESULT; stdcall;

        function GetFeatureLevel(): TD3D10_FEATURE_LEVEL1; stdcall;

    end;

    PFN_D3D10_CREATE_DEVICE1 = function(IDXGIAdapter: IDXGIAdapter; DriverType: TD3D10_DRIVER_TYPE; Software: HMODULE; Flags: UINT; HardwareLevel: TD3D10_FEATURE_LEVEL1; SDKVersion: UINT; out ppDevice: ID3D10Device1): HRESULT; stdcall;


    PFN_D3D10_CREATE_DEVICE_AND_SWAP_CHAIN1 = function(IDXGIAdapter: IDXGIAdapter; DriverType: TD3D10_DRIVER_TYPE; Software: HMODULE; Flags: UINT; HardwareLevel: TD3D10_FEATURE_LEVEL1; SDKVersion: UINT; pSwapChainDesc: PDXGI_SWAP_CHAIN_DESC;
        out ppSwapChain: IDXGISwapChain; out ppDevice: ID3D10Device1): HRESULT; stdcall;





///////////////////////////////////////////////////////////////////////////
// D3D10CreateDevice1
// ------------------
//
// pAdapter
//      If NULL, D3D10CreateDevice1 will choose the primary adapter and
//      create a new instance from a temporarily created IDXGIFactory.
//      If non-NULL, D3D10CreateDevice1 will register the appropriate
//      device, if necessary (via IDXGIAdapter::RegisterDrver), before
//      creating the device.
// DriverType
//      Specifies the driver type to be created: hardware, reference or
//      null.
// Software
//      HMODULE of a DLL implementing a software rasterizer. Must be NULL for
//      non-Software driver types.
// Flags
//      Any of those documented for D3D10CreateDeviceAndSwapChain1.
// HardwareLevel
//      Any of those documented for D3D10CreateDeviceAndSwapChain1.
// SDKVersion
//      SDK version. Use the D3D10_1_SDK_VERSION macro.
// ppDevice
//      Pointer to returned interface.
//
// Return Values
//  Any of those documented for
//          CreateDXGIFactory
//          IDXGIFactory::EnumAdapters
//          IDXGIAdapter::RegisterDriver
//          D3D10CreateDevice1
//
///////////////////////////////////////////////////////////////////////////

function D3D10CreateDevice1(
{_In_opt_ } pAdapter : IDXGIAdapter ;
DriverType : TD3D10_DRIVER_TYPE ;
Software : HMODULE ;
Flags : UINT ;
HardwareLevel : TD3D10_FEATURE_LEVEL1 ;
SDKVersion : UINT ;
{_Out_opt_ }  out ppDevice : ID3D10Device1
    ) : HRESULT;stdcall; external D3D10_1_DLL;


///////////////////////////////////////////////////////////////////////////
// D3D10CreateDeviceAndSwapChain1
// ------------------------------
//
// ppAdapter
//      If NULL, D3D10CreateDevice1 will choose the primary adapter and
//      create a new instance from a temporarily created IDXGIFactory.
//      If non-NULL, D3D10CreateDevice1 will register the appropriate
//      device, if necessary (via IDXGIAdapter::RegisterDrver), before
//      creating the device.
// DriverType
//      Specifies the driver type to be created: hardware, reference or
//      null.
// Software
//      HMODULE of a DLL implementing a software rasterizer. Must be NULL for
//      non-Software driver types.
// Flags
//      Any of those documented for D3D10CreateDevice1.
// HardwareLevel
//      Any of:
//          D3D10_CREATE_LEVEL_10_0
//          D3D10_CREATE_LEVEL_10_1
// SDKVersion
//      SDK version. Use the D3D10_1_SDK_VERSION macro.
// pSwapChainDesc
//      Swap chain description, may be NULL.
// ppSwapChain
//      Pointer to returned interface. May be NULL.
// ppDevice
//      Pointer to returned interface.
//
// Return Values
//  Any of those documented for
//          CreateDXGIFactory
//          IDXGIFactory::EnumAdapters
//          IDXGIAdapter::RegisterDriver
//          D3D10CreateDevice1
//          IDXGIFactory::CreateSwapChain
//
///////////////////////////////////////////////////////////////////////////

function D3D10CreateDeviceAndSwapChain1(
{_In_opt_ } pAdapter : IDXGIAdapter ;
DriverType : TD3D10_DRIVER_TYPE ;
Software : HMODULE ;
Flags : UINT ;
HardwareLevel : TD3D10_FEATURE_LEVEL1 ;
SDKVersion : UINT ;
{_In_opt_ } pSwapChainDesc : PDXGI_SWAP_CHAIN_DESC ;
{_Out_opt_ }  out ppSwapChain : IDXGISwapChain  ;
{_Out_opt_ }  out ppDevice : ID3D10Device1
    ) : HRESULT;stdcall; external D3D10_1_DLL;







implementation

end.
