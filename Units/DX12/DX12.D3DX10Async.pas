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
   Content:    D3DX10 Asynchronous Effect / Shader loaders / compilers

   This unit consists of the following header files
   File name: D3DX10Async.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.D3DX10Async;

{$mode ObjFPC}{$H+}

interface

uses
  Windows,Classes, SysUtils,
  DX12.D3D10,
  DX12.D3DCommon,
  DX12.D3D10Shader,
  DX12.D3DX10Core,
  DX12.D3D10Effect,
  DX12.D3DX10Tex;

  {$Z4}

const
    // Current name of the DLL shipped in the same SDK as this header.
    D3DX10_DLL = 'd3dx10_43.dll';



//----------------------------------------------------------------------------
// D3DX10Compile:
// ------------------
// Compiles an effect or shader.
//
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
 
function D3DX10CompileFromFileA(
pSrcFile : LPCSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10INCLUDE ;
pFunctionName : LPCSTR ;
pProfile : LPCSTR ;
Flags1 : UINT ;
Flags2 : UINT ;
pPump : ID3DX10ThreadPump ;
out ppShader :  ID3D10Blob;
out ppErrorMsgs : ID3D10Blob ;
pHResult : PHRESULT
    ) : HRESULT;stdcall; external D3DX10_DLL;


function D3DX10CompileFromFileW(
pSrcFile : LPCWSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10INCLUDE ;
pFunctionName : LPCSTR ;
pProfile : LPCSTR ;
Flags1 : UINT ;
Flags2 : UINT ;
pPump : ID3DX10ThreadPump ;
out ppShader : ID3D10Blob ;
out ppErrorMsgs :ID3D10Blob  ;
pHResult : PHRESULT
    ) : HRESULT;stdcall;external D3DX10_DLL;



function D3DX10CompileFromResourceA(
hSrcModule : HMODULE ;
pSrcResource : LPCSTR ;
pSrcFileName : LPCSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10INCLUDE ;
pFunctionName : LPCSTR ;
pProfile : LPCSTR ;
Flags1 : UINT ;
Flags2 : UINT ;
pPump : ID3DX10ThreadPump ;
out ppShader : ID3D10Blob ;
out ppErrorMsgs : ID3D10Blob ;
pHResult : PHRESULT
    ) : HRESULT;stdcall; external D3DX10_DLL;


function D3DX10CompileFromResourceW(
hSrcModule : HMODULE ;
pSrcResource : LPCWSTR ;
pSrcFileName : LPCWSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10INCLUDE ;
pFunctionName : LPCSTR ;
pProfile : LPCSTR ;
Flags1 : UINT ;
Flags2 : UINT ;
pPump : ID3DX10ThreadPump ;
out ppShader : ID3D10Blob ;
out ppErrorMsgs :ID3D10Blob ;
pHResult : PHRESULT
    ) : HRESULT;stdcall; external D3DX10_DLL;




function D3DX10CompileFromMemory(
pSrcData : LPCSTR ;
SrcDataLen : SIZE_T ;
pFileName : LPCSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10INCLUDE ;
pFunctionName : LPCSTR ;
pProfile : LPCSTR ;
Flags1 : UINT ;
Flags2 : UINT ;
pPump : ID3DX10ThreadPump ;
out ppShader : ID3D10Blob ;
out ppErrorMsgs : ID3D10Blob ;
pHResult : PHRESULT
    ) : HRESULT;stdcall; external D3DX10_DLL;


//----------------------------------------------------------------------------
// D3DX10CreateEffectFromXXXX:
// --------------------------
// Creates an effect from a binary effect or file
//
// Parameters:
//
// [in]
//
//
//  pFileName
//      Name of the ASCII (uncompiled) or binary (compiled) Effect file to load
//
//  hModule
//      Handle to the module containing the resource to compile from
//  pResourceName
//      Name of the resource within hModule to compile from
//
//  pData
//      Blob of effect data, either ASCII (uncompiled) or binary (compiled)
//  DataLength
//      Length of the data blob
//
//  pDefines
//      Optional NULL-terminated array of preprocessor macro definitions.
//  pInclude
//      Optional interface pointer to use for handling #include directives.
//      If this parameter is NULL, #includes will be honored when compiling
//      from file, and will error when compiling from resource or memory.
//  pProfile
//      Profile to use when compiling the effect.
//  HLSLFlags
//      Compilation flags pertaining to shaders and data types, honored by
//      the HLSL compiler
//  FXFlags
//      Compilation flags pertaining to Effect compilation, honored
//      by the Effect compiler
//  pDevice
//      Pointer to the D3D10 device on which to create Effect resources
//  pEffectPool
//      Pointer to an Effect pool to share variables with or NULL
//
// [out]
//
//  ppEffect
//      Address of the newly created Effect interface
//  ppEffectPool
//      Address of the newly created Effect pool interface
//  ppErrors
//      If non-NULL, address of a buffer with error messages that occurred
//      during parsing or compilation
//  pHResult
//      Pointer to a memory location to receive the return value upon completion.
//      Maybe NULL if not needed.
//      If pPump != NULL, pHResult must be a valid memory location until the
//      the asynchronous execution completes.
//----------------------------------------------------------------------------


function D3DX10CreateEffectFromFileA(
pFileName : LPCSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10Include ;
pProfile : LPCSTR ;
HLSLFlags : UINT ;
FXFlags : UINT ;
pDevice : ID3D10Device ;
pEffectPool : ID3D10EffectPool ;
pPump : ID3DX10ThreadPump ;
out ppEffect : ID3D10Effect ;
out ppErrors : ID3D10Blob ;
pHResult : PHRESULT
    ) : HRESULT;stdcall;  external D3DX10_DLL;


function D3DX10CreateEffectFromFileW(
pFileName : LPCWSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10Include ;
pProfile : LPCSTR ;
HLSLFlags : UINT ;
FXFlags : UINT ;
pDevice : ID3D10Device ;
pEffectPool : ID3D10EffectPool ;
pPump : ID3DX10ThreadPump ;
out ppEffect : ID3D10Effect;
out ppErrors : ID3D10Blob ;
pHResult : PHRESULT
    ) : HRESULT;stdcall;  external D3DX10_DLL;


function D3DX10CreateEffectFromMemory(
pData : LPCVOID ;
DataLength : SIZE_T ;
pSrcFileName : LPCSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10Include ;
pProfile : LPCSTR ;
HLSLFlags : UINT ;
FXFlags : UINT ;
pDevice : ID3D10Device ;
pEffectPool : ID3D10EffectPool ;
pPump : ID3DX10ThreadPump ;
out ppEffect :  ID3D10Effect;
out ppErrors : ID3D10Blob ;
pHResult : PHRESULT
    ) : HRESULT;stdcall;  external D3DX10_DLL;


function D3DX10CreateEffectFromResourceA(
hModule : HMODULE ;
pResourceName : LPCSTR ;
pSrcFileName : LPCSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10Include ;
pProfile : LPCSTR ;
HLSLFlags : UINT ;
FXFlags : UINT ;
pDevice : ID3D10Device ;
pEffectPool : ID3D10EffectPool ;
pPump : ID3DX10ThreadPump ;
out ppEffect :  ID3D10Effect;
out ppErrors : ID3D10Blob ;
pHResult : PHRESULT
    ) : HRESULT;stdcall;  external D3DX10_DLL;


function D3DX10CreateEffectFromResourceW(
hModule : HMODULE ;
pResourceName : LPCWSTR ;
pSrcFileName : LPCWSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10Include ;
pProfile : LPCSTR ;
HLSLFlags : UINT ;
FXFlags : UINT ;
pDevice : ID3D10Device ;
pEffectPool : ID3D10EffectPool ;
pPump : ID3DX10ThreadPump ;
out ppEffect : ID3D10Effect ;
out ppErrors : ID3D10Blob ;
pHResult : PHRESULT
    ) : HRESULT;stdcall;  external D3DX10_DLL;




function D3DX10CreateEffectPoolFromFileA(
pFileName : LPCSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10Include ;
pProfile : LPCSTR ;
HLSLFlags : UINT ;
FXFlags : UINT ;
pDevice : ID3D10Device ;
pPump : ID3DX10ThreadPump ;
out ppEffectPool : ID3D10EffectPool ;
out ppErrors : ID3D10Blob ;
pHResult : PHRESULT
    ) : HRESULT;stdcall;  external D3DX10_DLL;


function D3DX10CreateEffectPoolFromFileW(
pFileName : LPCWSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10Include ;
pProfile : LPCSTR ;
HLSLFlags : UINT ;
FXFlags : UINT ;
pDevice : ID3D10Device ;
pPump : ID3DX10ThreadPump ;
out ppEffectPool : ID3D10EffectPool ;
out ppErrors : ID3D10Blob ;
pHResult : PHRESULT
    ) : HRESULT;stdcall;  external D3DX10_DLL;


function D3DX10CreateEffectPoolFromMemory(
pData : LPCVOID ;
DataLength : SIZE_T ;
pSrcFileName : LPCSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10Include ;
pProfile : LPCSTR ;
HLSLFlags : UINT ;
FXFlags : UINT ;
pDevice : ID3D10Device ;
pPump : ID3DX10ThreadPump ;
out ppEffectPool : ID3D10EffectPool ;
out ppErrors : ID3D10Blob ;
pHResult : PHRESULT
    ) : HRESULT;stdcall;  external D3DX10_DLL;


function D3DX10CreateEffectPoolFromResourceA(
hModule : HMODULE ;
pResourceName : LPCSTR ;
pSrcFileName : LPCSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10Include ;
pProfile : LPCSTR ;
HLSLFlags : UINT ;
FXFlags : UINT ;
pDevice : ID3D10Device ;
pPump : ID3DX10ThreadPump ;
out ppEffectPool :ID3D10EffectPool  ;
out ppErrors : ID3D10Blob ;
pHResult : PHRESULT
    ) : HRESULT;stdcall;  external D3DX10_DLL;


function D3DX10CreateEffectPoolFromResourceW(
hModule : HMODULE ;
pResourceName : LPCWSTR ;
pSrcFileName : LPCWSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10Include ;
pProfile : LPCSTR ;
HLSLFlags : UINT ;
FXFlags : UINT ;
pDevice : ID3D10Device ;
pPump : ID3DX10ThreadPump ;
out ppEffectPool :ID3D10EffectPool  ;
out ppErrors : ID3D10Blob ;
pHResult : PHRESULT
    ) : HRESULT;stdcall;  external D3DX10_DLL;



function D3DX10PreprocessShaderFromFileA(
pFileName : LPCSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10Include ;
pPump : ID3DX10ThreadPump ;
out ppShaderText : ID3D10Blob ;
out ppErrorMsgs : ID3D10Blob ;
pHResult : PHRESULT
    ) : HRESULT;stdcall;  external D3DX10_DLL;


function D3DX10PreprocessShaderFromFileW(
pFileName : LPCWSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10Include ;
pPump : ID3DX10ThreadPump ;
out ppShaderText : ID3D10Blob ;
out ppErrorMsgs : ID3D10Blob ;
pHResult : PHRESULT
    ) : HRESULT;stdcall; external D3DX10_DLL;


function D3DX10PreprocessShaderFromMemory(
pSrcData : LPCSTR ;
SrcDataSize : SIZE_T ;
pFileName : LPCSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10Include ;
pPump : ID3DX10ThreadPump ;
out ppShaderText :ID3D10Blob  ;
out ppErrorMsgs :ID3D10Blob  ;
pHResult : PHRESULT
    ) : HRESULT;stdcall;  external D3DX10_DLL;


function D3DX10PreprocessShaderFromResourceA(
hModule : HMODULE ;
pResourceName : LPCSTR ;
pSrcFileName : LPCSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10INCLUDE ;
pPump : ID3DX10ThreadPump ;
out ppShaderText : ID3D10Blob ;
out ppErrorMsgs : ID3D10Blob ;
pHResult : PHRESULT
    ) : HRESULT;stdcall;   external D3DX10_DLL;


function D3DX10PreprocessShaderFromResourceW(
hModule : HMODULE ;
pResourceName : LPCWSTR ;
pSrcFileName : LPCWSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude :ID3D10INCLUDE ;
pPump : ID3DX10ThreadPump ;
out ppShaderText :ID3D10Blob  ;
out ppErrorMsgs : ID3D10Blob ;
pHResult : PHRESULT
    ) : HRESULT;stdcall;   external D3DX10_DLL;


 

//----------------------------------------------------------------------------
// Async processors
//----------------------------------------------------------------------------

function D3DX10CreateAsyncCompilerProcessor(
pFileName : LPCSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10Include ;
pFunctionName : LPCSTR ;
pProfile : LPCSTR ;
Flags1 : UINT ;
Flags2 : UINT ;
out ppCompiledShader : ID3D10Blob ;
out ppErrorBuffer : ID3D10Blob ;
out ppProcessor : ID3DX10DataProcessor
    ) : HRESULT;stdcall;  external D3DX10_DLL;


function D3DX10CreateAsyncEffectCreateProcessor(
pFileName : LPCSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10Include ;
pProfile : LPCSTR ;
Flags : UINT ;
FXFlags : UINT ;
pDevice : ID3D10Device ;
pPool : ID3D10EffectPool ;
out ppErrorBuffer :ID3D10Blob  ;
out ppProcessor :  ID3DX10DataProcessor
    ) : HRESULT;stdcall; external D3DX10_DLL;


function D3DX10CreateAsyncEffectPoolCreateProcessor(
pFileName : LPCSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10Include ;
pProfile : LPCSTR ;
Flags : UINT ;
FXFlags : UINT ;
pDevice : ID3D10Device ;
out ppErrorBuffer :ID3D10Blob  ;
out ppProcessor :  ID3DX10DataProcessor
    ) : HRESULT;stdcall;  external D3DX10_DLL;


function D3DX10CreateAsyncShaderPreprocessProcessor(
pFileName : LPCSTR ;
pDefines : PD3D10_SHADER_MACRO ;
pInclude : ID3D10Include ;
out ppShaderText :ID3D10Blob  ;
out ppErrorBuffer : ID3D10Blob ;
out ppProcessor :  ID3DX10DataProcessor
    ) : HRESULT;stdcall;  external D3DX10_DLL;




//----------------------------------------------------------------------------
// D3DX10 Asynchronous texture I/O (advanced mode)
//----------------------------------------------------------------------------

function D3DX10CreateAsyncFileLoaderW(
pFileName : LPCWSTR ;
ppDataLoader : ID3DX10DataLoader
    ) : HRESULT;stdcall;external D3DX10_DLL;

function D3DX10CreateAsyncFileLoaderA(
pFileName : LPCSTR ;
out ppDataLoader : ID3DX10DataLoader
    ) : HRESULT;stdcall; external D3DX10_DLL;

function D3DX10CreateAsyncMemoryLoader(
pData : LPCVOID ;
cbData : SIZE_T ;
out ppDataLoader :ID3DX10DataLoader
    ) : HRESULT;stdcall; external D3DX10_DLL;

function D3DX10CreateAsyncResourceLoaderW(
hSrcModule : HMODULE ;
pSrcResource : LPCWSTR ;
out ppDataLoader : ID3DX10DataLoader
    ) : HRESULT;stdcall; external D3DX10_DLL;

function D3DX10CreateAsyncResourceLoaderA(
hSrcModule : HMODULE ;
pSrcResource : LPCSTR ;
out ppDataLoader :  ID3DX10DataLoader
    ) : HRESULT;stdcall; external D3DX10_DLL;



function D3DX10CreateAsyncTextureProcessor(
pDevice : ID3D10Device ;
pLoadInfo : PD3DX10_IMAGE_LOAD_INFO ;
out ppDataProcessor :  ID3DX10DataProcessor
    ) : HRESULT;stdcall; external D3DX10_DLL;

function D3DX10CreateAsyncTextureInfoProcessor(
pImageInfo : PD3DX10_IMAGE_INFO ;
out ppDataProcessor :ID3DX10DataProcessor
    ) : HRESULT;stdcall; external D3DX10_DLL;

function D3DX10CreateAsyncShaderResourceViewProcessor(
pDevice : ID3D10Device ;
pLoadInfo : PD3DX10_IMAGE_LOAD_INFO ;
out ppDataProcessor :  ID3DX10DataProcessor
    ) : HRESULT;stdcall;external D3DX10_DLL;





implementation

end.

