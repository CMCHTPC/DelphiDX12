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
   Content:    D3DX effect types and Shaders

   This unit consists of the following header files
   File name: d3dx9effect.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3DX9Effect9;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D9Types,
    DX12.D3D9,
    DX12.D3DX9Core,
    DX12.D3DX9Math,
    DX12.D3DX9Shader;

    {$Z4}

const
    D3DX9_DLL = 'D3DX9_43.dll';

const

    //----------------------------------------------------------------------------
    // D3DXFX_DONOTSAVESTATE
    //   This flag is used as a parameter to ID3DXEffect::Begin().  When this flag
    //   is specified, device state is not saved and restored in Begin/End.
    // D3DXFX_DONOTSAVESHADERSTATE
    //   This flag is used as a parameter to ID3DXEffect::Begin().  When this flag
    //   is specified, shader device state is not saved and restored in Begin/End.
    //   This includes pixel/vertex shaders and shader constants
    //----------------------------------------------------------------------------

    D3DXFX_DONOTSAVESTATE = (1 shl 0);
    D3DXFX_DONOTSAVESHADERSTATE = (1 shl 1);


    //----------------------------------------------------------------------------
    // D3DX_PARAMETER_SHARED
    //   Indicates that the value of a parameter will be shared with all effects
    //   which share the same namespace.  Changing the value in one effect will
    //   change it in all.

    // D3DX_PARAMETER_LITERAL
    //   Indicates that the value of this parameter can be treated as literal.
    //   Literal parameters can be marked when the effect is compiled, and their
    //   cannot be changed after the effect is compiled.  Shared parameters cannot
    //   be literal.
    //----------------------------------------------------------------------------

    D3DX_PARAMETER_SHARED = (1 shl 0);
    D3DX_PARAMETER_LITERAL = (1 shl 1);
    D3DX_PARAMETER_ANNOTATION = (1 shl 2);

    // {53CA7768-C0D0-4664-8E79-D156E4F5B7E0}
    IID_ID3DXEffectPool: TGUID = '{53CA7768-C0D0-4664-8E79-D156E4F5B7E0}';


    // {804EF574-CCC1-4bf6-B06A-B1404ABDEADE}
    IID_ID3DXBaseEffect: TGUID = '{804EF574-CCC1-4BF6-B06A-B1404ABDEADE}';


    // {B589B04A-293D-4516-AF0B-3D7DBCF5AC54}
    IID_ID3DXEffect: TGUID = '{B589B04A-293D-4516-AF0B-3D7DBCF5AC54}';


    // {F8EE90D3-FCC6-4f14-8AE8-6374AE968E33}
    IID_ID3DXEffectCompiler: TGUID = '{F8EE90D3-FCC6-4F14-8AE8-6374AE968E33}';




type


    //----------------------------------------------------------------------------
    // D3DXEFFECT_DESC:
    //----------------------------------------------------------------------------

    _D3DXEFFECT_DESC = record
        Creator: LPCSTR; // Creator string
        Parameters: UINT; // Number of parameters
        Techniques: UINT; // Number of techniques
        Functions: UINT; // Number of function entrypoints
    end;
    TD3DXEFFECT_DESC = _D3DXEFFECT_DESC;
    PD3DXEFFECT_DESC = ^TD3DXEFFECT_DESC;



    //----------------------------------------------------------------------------
    // D3DXPARAMETER_DESC:
    //----------------------------------------------------------------------------

    _D3DXPARAMETER_DESC = record
        Name: LPCSTR; // Parameter name
        Semantic: LPCSTR; // Parameter semantic
        ParameterClass: TD3DXPARAMETER_CLASS; // Class
        ParameterType: TD3DXPARAMETER_TYPE; // Component type
        Rows: UINT; // Number of rows
        Columns: UINT; // Number of columns
        Elements: UINT; // Number of array elements
        Annotations: UINT; // Number of annotations
        StructMembers: UINT; // Number of structure member sub-parameters
        Flags: DWORD; // D3DX_PARAMETER_* flags
        Bytes: UINT; // Parameter size, in bytes
    end;
    TD3DXPARAMETER_DESC = _D3DXPARAMETER_DESC;
    PD3DXPARAMETER_DESC = ^TD3DXPARAMETER_DESC;



    //----------------------------------------------------------------------------
    // D3DXTECHNIQUE_DESC:
    //----------------------------------------------------------------------------

    _D3DXTECHNIQUE_DESC = record
        Name: LPCSTR; // Technique name
        Passes: UINT; // Number of passes
        Annotations: UINT; // Number of annotations
    end;
    TD3DXTECHNIQUE_DESC = _D3DXTECHNIQUE_DESC;
    PD3DXTECHNIQUE_DESC = ^TD3DXTECHNIQUE_DESC;



    //----------------------------------------------------------------------------
    // D3DXPASS_DESC:
    //----------------------------------------------------------------------------

    _D3DXPASS_DESC = record
        Name: LPCSTR; // Pass name
        Annotations: UINT; // Number of annotations
        VSVersion: DWORD; // Vertex shader version (0 in case of NULL shader)
        PSVersion: DWORD; // Pixel shader version (0 in case of NULL shader)
        VSSemanticsUsed: UINT;
        VSSemantics: array [0..MAXD3DDECLLENGTH - 1] of TD3DXSEMANTIC;
        PSSemanticsUsed: UINT;
        PSSemantics: array [0..MAXD3DDECLLENGTH - 1] of TD3DXSEMANTIC;
        PSSamplersUsed: UINT;
        PSSamplers: array [0..15] of LPCSTR;
    end;
    TD3DXPASS_DESC = _D3DXPASS_DESC;
    PD3DXPASS_DESC = ^TD3DXPASS_DESC;




    //----------------------------------------------------------------------------
    // D3DXFUNCTION_DESC:
    //----------------------------------------------------------------------------

    _D3DXFUNCTION_DESC = record
        Name: LPCSTR; // Function name
        Annotations: UINT; // Number of annotations
    end;
    TD3DXFUNCTION_DESC = _D3DXFUNCTION_DESC;
    PD3DXFUNCTION_DESC = ^TD3DXFUNCTION_DESC;


    //////////////////////////////////////////////////////////////////////////////
    // ID3DXEffectPool ///////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    ID3DXEffectPool = interface;
    LPD3DXEFFECTPOOL = ^ID3DXEffectPool;

    ID3DXEffectPool = interface(IUnknown)
        ['{53CA7768-C0D0-4664-8E79-D156E4F5B7E0}']
    end;


    //////////////////////////////////////////////////////////////////////////////
    // ID3DXBaseEffect ///////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    ID3DXBaseEffect = interface;
    LPD3DXBASEEFFECT = ^ID3DXBaseEffect;




    ID3DXBaseEffect = interface(IUnknown)
        ['{804EF574-CCC1-4BF6-B06A-B1404ABDEADE}']
        function Release(): ULONG; stdcall;

        // Descs
        function GetDesc(pDesc: PD3DXEFFECT_DESC): HRESULT; stdcall;

        function GetParameterDesc(hParameter: TD3DXHANDLE; pDesc: PD3DXPARAMETER_DESC): HRESULT; stdcall;

        function GetTechniqueDesc(hTechnique: TD3DXHANDLE; pDesc: PD3DXTECHNIQUE_DESC): HRESULT; stdcall;

        function GetPassDesc(hPass: TD3DXHANDLE; pDesc: PD3DXPASS_DESC): HRESULT; stdcall;

        function GetFunctionDesc(hShader: TD3DXHANDLE; pDesc: PD3DXFUNCTION_DESC): HRESULT; stdcall;

        // Handle operations
        function GetParameter(hParameter: TD3DXHANDLE; Index: UINT): TD3DXHANDLE; stdcall;

        function GetParameterByName(hParameter: TD3DXHANDLE; pName: LPCSTR): TD3DXHANDLE; stdcall;

        function GetParameterBySemantic(hParameter: TD3DXHANDLE; pSemantic: LPCSTR): TD3DXHANDLE; stdcall;

        function GetParameterElement(hParameter: TD3DXHANDLE; Index: UINT): TD3DXHANDLE; stdcall;

        function GetTechnique(Index: UINT): TD3DXHANDLE; stdcall;

        function GetTechniqueByName(pName: LPCSTR): TD3DXHANDLE; stdcall;

        function GetPass(hTechnique: TD3DXHANDLE; Index: UINT): TD3DXHANDLE; stdcall;

        function GetPassByName(hTechnique: TD3DXHANDLE; pName: LPCSTR): TD3DXHANDLE; stdcall;

        function GetFunction(Index: UINT): TD3DXHANDLE; stdcall;

        function GetFunctionByName(pName: LPCSTR): TD3DXHANDLE; stdcall;

        function GetAnnotation(hObject: TD3DXHANDLE; Index: UINT): TD3DXHANDLE; stdcall;

        function GetAnnotationByName(hObject: TD3DXHANDLE; pName: LPCSTR): TD3DXHANDLE; stdcall;

        // Get/Set Parameters
        function SetValue(hParameter: TD3DXHANDLE; pData: LPCVOID; Bytes: UINT): HRESULT; stdcall;

        function GetValue(hParameter: TD3DXHANDLE; pData: LPVOID; Bytes: UINT): HRESULT; stdcall;

        function SetBool(hParameter: TD3DXHANDLE; b: boolean): HRESULT; stdcall;

        function GetBool(hParameter: TD3DXHANDLE; pb: Pboolean): HRESULT; stdcall;

        function SetBoolArray(hParameter: TD3DXHANDLE; pb: Pboolean; Count: UINT): HRESULT; stdcall;

        function GetBoolArray(hParameter: TD3DXHANDLE; pb: Pboolean; Count: UINT): HRESULT; stdcall;

        function SetInt(hParameter: TD3DXHANDLE; n: int32): HRESULT; stdcall;

        function GetInt(hParameter: TD3DXHANDLE; pn: PINT32): HRESULT; stdcall;

        function SetIntArray(hParameter: TD3DXHANDLE; pn: PINT32; Count: UINT): HRESULT; stdcall;

        function GetIntArray(hParameter: TD3DXHANDLE; pn: PINT32; Count: UINT): HRESULT; stdcall;

        function SetFloat(hParameter: TD3DXHANDLE; f: single): HRESULT; stdcall;

        function GetFloat(hParameter: TD3DXHANDLE; pf: Psingle): HRESULT; stdcall;

        function SetFloatArray(hParameter: TD3DXHANDLE; pf: Psingle; Count: UINT): HRESULT; stdcall;

        function GetFloatArray(hParameter: TD3DXHANDLE; pf: Psingle; Count: UINT): HRESULT; stdcall;

        function SetVector(hParameter: TD3DXHANDLE; pVector: PD3DXVECTOR4): HRESULT; stdcall;

        function GetVector(hParameter: TD3DXHANDLE; pVector: PD3DXVECTOR4): HRESULT; stdcall;

        function SetVectorArray(hParameter: TD3DXHANDLE; pVector: PD3DXVECTOR4; Count: UINT): HRESULT; stdcall;

        function GetVectorArray(hParameter: TD3DXHANDLE; pVector: PD3DXVECTOR4; Count: UINT): HRESULT; stdcall;

        function SetMatrix(hParameter: TD3DXHANDLE; pMatrix: PD3DXMATRIX): HRESULT; stdcall;

        function GetMatrix(hParameter: TD3DXHANDLE; pMatrix: PD3DXMATRIX): HRESULT; stdcall;

        function SetMatrixArray(hParameter: TD3DXHANDLE; pMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;

        function GetMatrixArray(hParameter: TD3DXHANDLE; pMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;

        function SetMatrixPointerArray(hParameter: TD3DXHANDLE;
        {array} ppMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;

        function GetMatrixPointerArray(hParameter: TD3DXHANDLE;
        {array} ppMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;

        function SetMatrixTranspose(hParameter: TD3DXHANDLE; pMatrix: PD3DXMATRIX): HRESULT; stdcall;

        function GetMatrixTranspose(hParameter: TD3DXHANDLE; pMatrix: PD3DXMATRIX): HRESULT; stdcall;

        function SetMatrixTransposeArray(hParameter: TD3DXHANDLE; pMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;

        function GetMatrixTransposeArray(hParameter: TD3DXHANDLE; pMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;

        function SetMatrixTransposePointerArray(hParameter: TD3DXHANDLE;
        {array} ppMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;

        function GetMatrixTransposePointerArray(hParameter: TD3DXHANDLE;
        {array} ppMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;

        function SetString(hParameter: TD3DXHANDLE; pString: LPCSTR): HRESULT; stdcall;

        function GetString(hParameter: TD3DXHANDLE; out ppString: LPCSTR): HRESULT; stdcall;

        function SetTexture(hParameter: TD3DXHANDLE; pTexture: IDirect3DBaseTexture9): HRESULT; stdcall;

        function GetTexture(hParameter: TD3DXHANDLE; out ppTexture: IDirect3DBaseTexture9): HRESULT; stdcall;

        function SetPixelShader(hParameter: TD3DXHANDLE; pPShader: IDIRECT3DPIXELSHADER9): HRESULT; stdcall;

        function GetPixelShader(hParameter: TD3DXHANDLE; out ppPShader: IDirect3DPixelShader9): HRESULT; stdcall;

        function SetVertexShader(hParameter: TD3DXHANDLE; pVShader: IDirect3DVertexShader9): HRESULT; stdcall;

        function GetVertexShader(hParameter: TD3DXHANDLE; out ppVShader: IDirect3DVertexShader9): HRESULT; stdcall;

    end;

    //////////////////////////////////////////////////////////////////////////////
    // ID3DXEffect ///////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    ID3DXEffect = interface;
    LPD3DXEFFECT = ^ID3DXEffect;



    ID3DXEffect = interface(ID3DXBaseEffect)
        ['{B589B04A-293D-4516-AF0B-3D7DBCF5AC54}']
        // Pool
        function GetPool(out ppPool: ID3DXEffectPool): HRESULT; stdcall;

        // Selecting and setting a technique
        function SetTechnique(hTechnique: TD3DXHANDLE): HRESULT; stdcall;

        function GetCurrentTechnique(): TD3DXHANDLE; stdcall;

        function ValidateTechnique(hTechnique: TD3DXHANDLE): HRESULT; stdcall;

        function FindNextValidTechnique(hTechnique: TD3DXHANDLE; pTechnique: PD3DXHANDLE): HRESULT; stdcall;

        function IsParameterUsed(hParameter: TD3DXHANDLE; hTechnique: TD3DXHANDLE): boolean; stdcall;

        // Using current technique
        function _Begin(pPasses: PUINT; Flags: DWORD): HRESULT; stdcall;

        function Pass(Pass: UINT): HRESULT; stdcall;

        function _End(): HRESULT; stdcall;

        // Managing D3D Device
        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;

        function OnLostDevice(): HRESULT; stdcall;

        function OnResetDevice(): HRESULT; stdcall;

        // Cloning
        function CloneEffect(pDevice: IDirect3DDevice9; out ppEffect: ID3DXEffect): HRESULT; stdcall;

    end;

    //////////////////////////////////////////////////////////////////////////////
    // ID3DXEffectCompiler ///////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    ID3DXEffectCompiler = interface;
    LPD3DXEFFECTCOMPILER = ^ID3DXEffectCompiler;



    ID3DXEffectCompiler = interface(ID3DXBaseEffect)
        ['{F8EE90D3-FCC6-4F14-8AE8-6374AE968E33}']
        // Parameter sharing, specialization, and information
        function SetLiteral(hParameter: TD3DXHANDLE; Literal: boolean): HRESULT; stdcall;
        function GetLiteral(hParameter: TD3DXHANDLE; pLiteral: Pboolean): HRESULT; stdcall;
        // Compilation
        function CompileEffect(Flags: DWORD; out ppEffect: ID3DXBuffer; out ppErrorMsgs: ID3DXBuffer): HRESULT; stdcall;
        function CompileShader(hFunction: TD3DXHANDLE; pTarget: LPCSTR; Flags: DWORD; out ppShader: ID3DXBuffer; out ppErrorMsgs: ID3DXBuffer; out ppConstantTable: ID3DXConstantTable): HRESULT; stdcall;
    end;



    //////////////////////////////////////////////////////////////////////////////
    // APIs //////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    //----------------------------------------------------------------------------
    // D3DXCreateEffectPool:
    // ---------------------
    // Creates an effect pool.  Pools are used for sharing parameters between
    // multiple effects.  For all effects within a pool, shared parameters of the
    // same name all share the same value.

    // Parameters:
    //  ppPool
    //      Returns the created pool.
    //----------------------------------------------------------------------------



function D3DXCreateEffectPool(out ppPool: ID3DXEffectPool): HRESULT; stdcall; external D3DX9_DLL;



//----------------------------------------------------------------------------
// D3DXCreateEffect:
// -----------------
// Creates an effect from an ascii or binary effect description.

// Parameters:
//  pDevice
//      Pointer of the device on which to create the effect
//  pSrcFile
//      Name of the file containing the effect description
//  hSrcModule
//      Module handle. if NULL, current module will be used.
//  pSrcResource
//      Resource name in module
//  pSrcData
//      Pointer to effect description
//  SrcDataSize
//      Size of the effect description in bytes
//  pDefines
//      Optional NULL-terminated array of preprocessor macro definitions.
//  pInclude
//      Optional interface pointer to use for handling #include directives.
//      If this parameter is NULL, #includes will be honored when compiling
//      from file, and will error when compiling from resource or memory.
//  pPool
//      Pointer to ID3DXEffectPool object to use for shared parameters.
//      If NULL, no parameters will be shared.
//  ppEffect
//      Returns a buffer containing created effect.
//  ppCompilationErrors
//      Returns a buffer containing any error messages which occurred during
//      compile.  Or NULL if you do not care about the error messages.

//----------------------------------------------------------------------------

function D3DXCreateEffectFromFileA(pDevice: IDirect3DDevice9; pSrcFile: LPCSTR; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; Flags: DWORD; pPool: ID3DXEffectPool; out ppEffect: ID3DXEffect;
    out ppCompilationErrors: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateEffectFromFileW(pDevice: IDirect3DDevice9; pSrcFile: LPCWSTR; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; Flags: DWORD; pPool: ID3DXEffectPool; out ppEffect: ID3DXEffect;
    out ppCompilationErrors: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;



function D3DXCreateEffectFromResourceA(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: LPCSTR; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; Flags: DWORD; pPool: ID3DXEffectPool;
    out ppEffect: ID3DXEffect; out ppCompilationErrors: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateEffectFromResourceW(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: LPCWSTR; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; Flags: DWORD; pPool: ID3DXEffectPool;
    out ppEffect: ID3DXEffect; out ppCompilationErrors: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;



function D3DXCreateEffect(pDevice: IDirect3DDevice9; pSrcData: LPCVOID; SrcDataLen: UINT; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; Flags: DWORD; pPool: ID3DXEffectPool;
    out ppEffect: ID3DXEffect; out ppCompilationErrors: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;




//----------------------------------------------------------------------------
// D3DXCreateEffectCompiler:
// -------------------------
// Creates an effect from an ascii or binary effect description.

// Parameters:
//  pSrcFile
//      Name of the file containing the effect description
//  hSrcModule
//      Module handle. if NULL, current module will be used.
//  pSrcResource
//      Resource name in module
//  pSrcData
//      Pointer to effect description
//  SrcDataSize
//      Size of the effect description in bytes
//  pDefines
//      Optional NULL-terminated array of preprocessor macro definitions.
//  pInclude
//      Optional interface pointer to use for handling #include directives.
//      If this parameter is NULL, #includes will be honored when compiling
//      from file, and will error when compiling from resource or memory.
//  pPool
//      Pointer to ID3DXEffectPool object to use for shared parameters.
//      If NULL, no parameters will be shared.
//  ppCompiler
//      Returns a buffer containing created effect compiler.
//  ppParseErrors
//      Returns a buffer containing any error messages which occurred during
//      parse.  Or NULL if you do not care about the error messages.

//----------------------------------------------------------------------------

function D3DXCreateEffectCompilerFromFileA(pSrcFile: LPCSTR; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; Flags: DWORD; out ppCompiler: ID3DXEffectCompiler; out ppParseErrors: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateEffectCompilerFromFileW(pSrcFile: LPCWSTR; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; Flags: DWORD; out ppCompiler: ID3DXEffectCompiler; out ppParseErrors: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;




function D3DXCreateEffectCompilerFromResourceA(hSrcModule: HMODULE; pSrcResource: LPCSTR; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; Flags: DWORD; out ppCompiler: ID3DXEffectCompiler;
    out ppParseErrors: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateEffectCompilerFromResourceW(hSrcModule: HMODULE; pSrcResource: LPCWSTR; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; Flags: DWORD; out ppCompiler: ID3DXEffectCompiler;
    out ppParseErrors: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;




function D3DXCreateEffectCompiler(pSrcData: LPCSTR; SrcDataLen: UINT; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; Flags: DWORD; out ppCompiler: ID3DXEffectCompiler; out ppParseErrors: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;




implementation

end.
