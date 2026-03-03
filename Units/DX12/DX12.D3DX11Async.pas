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
   Content:    D3DX11 Asynchronous Shader loaders / compilers

   This unit consists of the following header files
   File name: D3DX11Async.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3DX11Async;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D11, DX12.D3D10,
    DX12.D3DX11Core,
    DX12.D3DX11Tex,
    DX12.D3DCommon,
    DX12.D3D10Shader;

    {$Z4}

const
    // Current name of the DLL shipped in the same SDK as this header.
    {$IFOPT D+}
    D3DX11_DLL = 'd3dx11d_43.dll';
    {$ELSE}
    D3DX11_DLL = 'd3dx11_43.dll';
    {$ENDIF}
    D3DX11D_DLL = 'd3dx11d_43.dll';

    //----------------------------------------------------------------------------
    // D3DX11Compile:
    // ------------------
    // Compiles an effect or shader.

    // Parameters:
    //  pSrcFile
    //      Source file name.
    //  hSrcModule
    //      Module handle. if NULL, current module will be used.
    //  pSrcResource
    //      Resource name in module.
    //  pSrcData
    //      Pointer to source code.
    //  SrcDataLen
    //      Size of source code, in bytes.
    //  pDefines
    //      Optional NULL-terminated array of preprocessor macro definitions.
    //  pInclude
    //      Optional interface pointer to use for handling #include directives.
    //      If this parameter is NULL, #includes will be honored when compiling
    //      from file, and will error when compiling from resource or memory.
    //  pFunctionName
    //      Name of the entrypoint function where execution should begin.
    //  pProfile
    //      Instruction set to be used when generating code.  Currently supported
    //      profiles are "vs_1_1",  "vs_2_0", "vs_2_a", "vs_2_sw", "vs_3_0",
    //                   "vs_3_sw", "vs_4_0", "vs_4_1",
    //                   "ps_2_0",  "ps_2_a", "ps_2_b", "ps_2_sw", "ps_3_0",
    //                   "ps_3_sw", "ps_4_0", "ps_4_1",
    //                   "gs_4_0",  "gs_4_1",
    //                   "tx_1_0",
    //                   "fx_4_0",  "fx_4_1"
    //      Note that this entrypoint does not compile fx_2_0 targets, for that
    //      you need to use the D3DX9 function.
    //  Flags1
    //      See D3D10_SHADER_xxx flags.
    //  Flags2
    //      See D3D10_EFFECT_xxx flags.
    //  ppShader
    //      Returns a buffer containing the created shader.  This buffer contains
    //      the compiled shader code, as well as any embedded debug and symbol
    //      table info.  (See D3D10GetShaderConstantTable)
    //  ppErrorMsgs
    //      Returns a buffer containing a listing of errors and warnings that were
    //      encountered during the compile.  If you are running in a debugger,
    //      these are the same messages you will see in your debug output.
    //  pHResult
    //      Pointer to a memory location to receive the return value upon completion.
    //      Maybe NULL if not needed.
    //      If pPump != NULL, pHResult must be a valid memory location until the
    //      the asynchronous execution completes.
    //----------------------------------------------------------------------------

function D3DX11CompileFromFileA(
    {_In_} pSrcFile: LPCSTR;
    {_In_} pDefines: PD3D10_SHADER_MACRO;
    {_In_} pInclude: ID3D10INCLUDE;
    {_In_} pFunctionName: LPCSTR;
    {_In_} pProfile: LPCSTR;
    {_In_} Flags1: UINT;
    {_In_} Flags2: UINT;
    {_In_} pPump: ID3DX11ThreadPump;
    {_Out_} out ppShader: ID3D10Blob;
    {_Out_} out ppErrorMsgs: ID3D10Blob;
    {_Out_} pHResult: PHRESULT): HRESULT; stdcall; external D3DX11_DLL;


function D3DX11CompileFromFileW(
    {_In_} pSrcFile: LPCWSTR;
    {_In_} pDefines: PD3D10_SHADER_MACRO;
    {_In_} pInclude: ID3D10INCLUDE;
    {_In_} pFunctionName: LPCSTR;
    {_In_} pProfile: LPCSTR;
    {_In_} Flags1: UINT;
    {_In_} Flags2: UINT;
    {_In_} pPump: ID3DX11ThreadPump;
    {_Out_} out ppShader: ID3D10Blob;
    {_Out_} out ppErrorMsgs: ID3D10Blob;
    {_Out_} pHResult: PHRESULT): HRESULT; stdcall; external D3DX11_DLL;


function D3DX11CompileFromResourceA(
    {_In_} hSrcModule: HMODULE;
    {_In_} pSrcResource: LPCSTR;
    {_In_} pSrcFileName: LPCSTR;
    {_In_} pDefines: PD3D10_SHADER_MACRO;
    {_In_} pInclude: ID3D10INCLUDE;
    {_In_} pFunctionName: LPCSTR;
    {_In_} pProfile: LPCSTR;
    {_In_} Flags1: UINT;
    {_In_} Flags2: UINT;
    {_In_} pPump: ID3DX11ThreadPump;
    {_Out_}  out ppShader: ID3D10Blob;
    {_Out_}  out ppErrorMsgs: ID3D10Blob;
    {_Out_} pHResult: PHRESULT): HRESULT; stdcall; external D3DX11_DLL;


function D3DX11CompileFromResourceW(
    {_In_} hSrcModule: HMODULE;
    {_In_} pSrcResource: LPCWSTR;
    {_In_} pSrcFileName: LPCWSTR;
    {_In_} pDefines: PD3D10_SHADER_MACRO;
    {_In_} pInclude: ID3D10INCLUDE;
    {_In_} pFunctionName: LPCSTR;
    {_In_} pProfile: LPCSTR;
    {_In_} Flags1: UINT;
    {_In_} Flags2: UINT;
    {_In_} pPump: ID3DX11ThreadPump;
    {_Out_} out ppShader: ID3D10Blob;
    {_Out_} out ppErrorMsgs: ID3D10Blob;
    {_Out_} pHResult: PHRESULT): HRESULT; stdcall; external D3DX11_DLL;


function D3DX11CompileFromMemory(
    {_In_} pSrcData: LPCSTR;
    {_In_} SrcDataLen: SIZE_T;
    {_In_} pFileName: LPCSTR;
    {_In_} pDefines: PD3D10_SHADER_MACRO;
    {_In_} pInclude: ID3D10INCLUDE;
    {_In_} pFunctionName: LPCSTR;
    {_In_} pProfile: LPCSTR;
    {_In_} Flags1: UINT;
    {_In_} Flags2: UINT;
    {_In_} pPump: ID3DX11ThreadPump;
    {_Out_} out ppShader: ID3D10Blob;
    {_Out_} out ppErrorMsgs: ID3D10Blob;
    {_Out_} pHResult: PHRESULT): HRESULT; stdcall; external D3DX11_DLL;


function D3DX11PreprocessShaderFromFileA(
    {_In_} pFileName: LPCSTR;
    {_In_} pDefines: PD3D10_SHADER_MACRO;
    {_In_} pInclude: ID3D10INCLUDE;
    {_In_} vpPump: ID3DX11ThreadPump;
    {_Out_} out ppShaderText: ID3D10Blob;
    {_Out_} out ppErrorMsgs: ID3D10Blob;
    {_Out_} pHResult: PHRESULT): HRESULT; stdcall; external D3DX11_DLL;


function D3DX11PreprocessShaderFromFileW(
    {_In_} pFileName: LPCWSTR;
    {_In_} pDefines: PD3D10_SHADER_MACRO;
    {_In_} pInclude: ID3D10INCLUDE;
    {_In_} pPump: ID3DX11ThreadPump;
    {_Out_} out ppShaderText: ID3D10Blob;
    {_Out_} out ppErrorMsgs: ID3D10Blob;
    {_Out_} pHResult: PHRESULT): HRESULT; stdcall; external D3DX11_DLL;


function D3DX11PreprocessShaderFromMemory(
    {_In_} pSrcData: LPCSTR;
    {_In_} SrcDataSize: SIZE_T;
    {_In_} pFileName: LPCSTR;
    {_In_} pDefines: PD3D10_SHADER_MACRO;
    {_In_} pInclude: ID3D10INCLUDE;
    {_In_} pPump: ID3DX11ThreadPump;
    {_Out_} out ppShaderText: ID3D10Blob;
    {_Out_} out ppErrorMsgs: ID3D10Blob;
    {_Out_} pHResult: PHRESULT): HRESULT; stdcall; external D3DX11_DLL;


function D3DX11PreprocessShaderFromResourceA(
    {_In_} hModule: HMODULE;
    {_In_} pResourceName: LPCSTR;
    {_In_} pSrcFileName: LPCSTR;
    {_In_} pDefines: PD3D10_SHADER_MACRO;
    {_In_} pInclude: ID3D10INCLUDE;
    {_In_} pPump: ID3DX11ThreadPump;
    {_Out_}  out ppShaderText: ID3D10Blob;
    {_Out_}  out ppErrorMsgs: ID3D10Blob;
    {_Out_} pHResult: PHRESULT): HRESULT; stdcall; external D3DX11_DLL;


function D3DX11PreprocessShaderFromResourceW(
    {_In_} hModule: HMODULE;
    {_In_} pResourceName: LPCWSTR;
    {_In_} pSrcFileName: LPCWSTR;
    {_In_} pDefines: PD3D10_SHADER_MACRO;
    {_In_} pInclude: ID3D10INCLUDE;
    {_In_} pPump: ID3DX11ThreadPump;
    {_Out_} out ppShaderText: ID3D10Blob;
    {_Out_} out ppErrorMsgs: ID3D10Blob;
    {_Out_} pHResult: PHRESULT): HRESULT; stdcall; external D3DX11_DLL;


//----------------------------------------------------------------------------
// Async processors
//----------------------------------------------------------------------------

function D3DX11CreateAsyncCompilerProcessor(
    {_In_} pFileName: LPCSTR;
    {_In_} pDefines: PD3D10_SHADER_MACRO;
    {_In_} pInclude: ID3D10INCLUDE;
    {_In_} pFunctionName: LPCSTR;
    {_In_} pProfile: LPCSTR;
    {_In_} Flags1: UINT;
    {_In_} Flags2: UINT;
    {_Out_} out ppCompiledShader: ID3D10Blob;
    {_Out_} out ppErrorBuffer: ID3D10Blob;
    {_Out_} out ppProcessor: ID3DX11DataProcessor): HRESULT; stdcall; external D3DX11_DLL;


function D3DX11CreateAsyncShaderPreprocessProcessor(
    {_In_} pFileName: LPCSTR;
    {_In_} pDefines: PD3D10_SHADER_MACRO;
    {_In_} pInclude: ID3D10INCLUDE;
    {_Out_} out ppShaderText: ID3D10Blob;
    {_Out_} out ppErrorBuffer: ID3D10Blob;
    {_Out_} out ppProcessor: ID3DX11DataProcessor): HRESULT; stdcall; external D3DX11_DLL;


//----------------------------------------------------------------------------
// D3DX11 Asynchronous texture I/O (advanced mode)
//----------------------------------------------------------------------------

function D3DX11CreateAsyncFileLoaderW(
    {_In_} pFileName: LPCWSTR;
    {_Out_} out ppDataLoader: ID3DX11DataLoader): HRESULT; stdcall; external D3DX11_DLL;

function D3DX11CreateAsyncFileLoaderA(
    {_In_} pFileName: LPCSTR;
    {_Out_} out ppDataLoader: ID3DX11DataLoader): HRESULT; stdcall; external D3DX11_DLL;

function D3DX11CreateAsyncMemoryLoader(
    {_In_} pData: LPCVOID;
    {_In_} cbData: SIZE_T;
    {_Out_} out ppDataLoader: ID3DX11DataLoader): HRESULT; stdcall; external D3DX11_DLL;

function D3DX11CreateAsyncResourceLoaderW(
    {_In_} hSrcModule: HMODULE;
    {_In_} pSrcResource: LPCWSTR;
    {_Out_} out ppDataLoader: ID3DX11DataLoader): HRESULT; stdcall; external D3DX11_DLL;

function D3DX11CreateAsyncResourceLoaderA(
    {_In_} hSrcModule: HMODULE;
    {_In_} pSrcResource: LPCSTR;
    {_Out_} out ppDataLoader: ID3DX11DataLoader): HRESULT; stdcall; external D3DX11_DLL;


function D3DX11CreateAsyncTextureProcessor(
    {_In_} pDevice: ID3D11Device;
    {_In_} pLoadInfo: PD3DX11_IMAGE_LOAD_INFO;
    {_Out_} out ppDataProcessor: ID3DX11DataProcessor): HRESULT; stdcall; external D3DX11_DLL;

function D3DX11CreateAsyncTextureInfoProcessor(
    {_In_} pImageInfo: PD3DX11_IMAGE_INFO;
    {_Out_} out ppDataProcessor: ID3DX11DataProcessor): HRESULT; stdcall;  external D3DX11_DLL;

function D3DX11CreateAsyncShaderResourceViewProcessor(
    {_In_} pDevice: ID3D11Device;
    {_In_} pLoadInfo: PD3DX11_IMAGE_LOAD_INFO;
    {_Out_} out ppDataProcessor: ID3DX11DataProcessor): HRESULT; stdcall; external D3DX11_DLL;


implementation

end.
