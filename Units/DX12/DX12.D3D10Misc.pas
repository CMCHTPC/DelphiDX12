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

   Copyright (c) Microsoft Corporation.  All rights reserved.
   Content:    D3D10 Device Creation APIs

   This unit consists of the following header files
   File name: D3D10Misc.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.D3D10Misc;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.DXGI,
    DX12.D3DCommon,
    DX12.D3D10;

    {$Z4}


    // ID3D10Blob has been made version-neutral and moved to d3dcommon.h.

const
    D3D10_DLL = 'D3D10.dll';

    GUID_DeviceType: TGUID = '{D722FB4D-7A68-437A-B20C-5804EE2494A6}';


type

    ///////////////////////////////////////////////////////////////////////////
    // D3D10_DRIVER_TYPE
    // ----------------

    // This identifier is used to determine the implementation of Direct3D10
    // to be used.

    // Pass one of these values to D3D10CreateDevice

    ///////////////////////////////////////////////////////////////////////////

    TD3D10_DRIVER_TYPE = (
        D3D10_DRIVER_TYPE_HARDWARE = 0,
        D3D10_DRIVER_TYPE_REFERENCE = 1,
        D3D10_DRIVER_TYPE_NULL = 2,
        D3D10_DRIVER_TYPE_SOFTWARE = 3,
        D3D10_DRIVER_TYPE_WARP = 5);

    PD3D10_DRIVER_TYPE = ^TD3D10_DRIVER_TYPE;


    ///////////////////////////////////////////////////////////////////////////
    // D3D10CreateDevice
    // ------------------

    // pAdapter
    //      If NULL, D3D10CreateDevice will choose the primary adapter and
    //      create a new instance from a temporarily created IDXGIFactory.
    //      If non-NULL, D3D10CreateDevice will register the appropriate
    //      device, if necessary (via IDXGIAdapter::RegisterDrver), before
    //      creating the device.
    // DriverType
    //      Specifies the driver type to be created: hardware, reference or
    //      null.
    // Software
    //      HMODULE of a DLL implementing a software rasterizer. Must be NULL for
    //      non-Software driver types.
    // Flags
    //      Any of those documented for D3D10CreateDevice.
    // SDKVersion
    //      SDK version. Use the D3D10_SDK_VERSION macro.
    // ppDevice
    //      Pointer to returned interface.

    // Return Values
    //  Any of those documented for
    //          CreateDXGIFactory
    //          IDXGIFactory::EnumAdapters
    //          IDXGIAdapter::RegisterDriver
    //          D3D10CreateDevice

///////////////////////////////////////////////////////////////////////////
function D3D10CreateDevice(
    {_In_opt_ } pAdapter: IDXGIAdapter; DriverType: TD3D10_DRIVER_TYPE; Software: HMODULE; Flags: UINT; SDKVersion: UINT;
    {_Out_opt_ }  out ppDevice: ID3D10Device): HRESULT; stdcall; external D3D10_DLL;


///////////////////////////////////////////////////////////////////////////
// D3D10CreateDeviceAndSwapChain
// ------------------------------

// ppAdapter
//      If NULL, D3D10CreateDevice will choose the primary adapter and
//      create a new instance from a temporarily created IDXGIFactory.
//      If non-NULL, D3D10CreateDevice will register the appropriate
//      device, if necessary (via IDXGIAdapter::RegisterDrver), before
//      creating the device.
// DriverType
//      Specifies the driver type to be created: hardware, reference or
//      null.
// Software
//      HMODULE of a DLL implementing a software rasterizer. Must be NULL for
//      non-Software driver types.
// Flags
//      Any of those documented for D3D10CreateDevice.
// SDKVersion
//      SDK version. Use the D3D10_SDK_VERSION macro.
// pSwapChainDesc
//      Swap chain description, may be NULL.
// ppSwapChain
//      Pointer to returned interface. May be NULL.
// ppDevice
//      Pointer to returned interface.

// Return Values
//  Any of those documented for
//          CreateDXGIFactory
//          IDXGIFactory::EnumAdapters
//          IDXGIAdapter::RegisterDriver
//          D3D10CreateDevice
//          IDXGIFactory::CreateSwapChain

///////////////////////////////////////////////////////////////////////////
function D3D10CreateDeviceAndSwapChain(
    {_In_opt_ } pAdapter: IDXGIAdapter; DriverType: TD3D10_DRIVER_TYPE; Software: HMODULE; Flags: UINT; SDKVersion: UINT;
    {_In_opt_ } pSwapChainDesc: PDXGI_SWAP_CHAIN_DESC;
    {_Out_opt_ }  out ppSwapChain: IDXGISwapChain;
    {_Out_opt_ }  out ppDevice: ID3D10Device): HRESULT; stdcall; external D3D10_DLL;


///////////////////////////////////////////////////////////////////////////
// D3D10CreateBlob:
// -----------------
// Creates a Buffer of n Bytes
//////////////////////////////////////////////////////////////////////////
function D3D10CreateBlob(NumBytes: SIZE_T;
    {_Out_ } out ppBuffer: ID3D10Blob): HRESULT; stdcall;  external D3D10_DLL;


implementation

end.
