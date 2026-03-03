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
   Header version: 9.29.1962.1

  ************************************************************************** }

unit DX12.D3DX9Effect;

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


    //----------------------------------------------------------------------------
    // D3DXFX_DONOTSAVESTATE
    //   This flag is used as a parameter to ID3DXEffect::Begin().  When this flag
    //   is specified, device state is not saved or restored in Begin/End.
    // D3DXFX_DONOTSAVESHADERSTATE
    //   This flag is used as a parameter to ID3DXEffect::Begin().  When this flag
    //   is specified, shader device state is not saved or restored in Begin/End.
    //   This includes pixel/vertex shaders and shader constants
    // D3DXFX_DONOTSAVESAMPLERSTATE
    //   This flag is used as a parameter to ID3DXEffect::Begin(). When this flag
    //   is specified, sampler device state is not saved or restored in Begin/End.
    // D3DXFX_NOT_CLONEABLE
    //   This flag is used as a parameter to the D3DXCreateEffect family of APIs.
    //   When this flag is specified, the effect will be non-cloneable and will not
    //   contain any shader binary data.
    //   Furthermore, GetPassDesc will not return shader function pointers.
    //   Setting this flag reduces effect memory usage by about 50%.
    //----------------------------------------------------------------------------

    D3DXFX_DONOTSAVESTATE = (1 shl 0);
    D3DXFX_DONOTSAVESHADERSTATE = (1 shl 1);
    D3DXFX_DONOTSAVESAMPLERSTATE = (1 shl 2);

    D3DXFX_NOT_CLONEABLE = (1 shl 11);
    D3DXFX_LARGEADDRESSAWARE = (1 shl 17);

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


    // {9537AB04-3250-412e-8213-FCD2F8677933}
    IID_ID3DXEffectPool: TGUID = '{9537AB04-3250-412E-8213-FCD2F8677933}';


    // {017C18AC-103F-4417-8C51-6BF6EF1E56BE}
    IID_ID3DXBaseEffect: TGUID = '{017C18AC-103F-4417-8C51-6BF6EF1E56BE}';



    // {79AAB587-6DBC-4fa7-82DE-37FA1781C5CE}
    IID_ID3DXEffectStateManager: TGUID = '{79AAB587-6DBC-4FA7-82DE-37FA1781C5CE}';


    // {F6CEB4B3-4E4C-40dd-B883-8D8DE5EA0CD5}
    IID_ID3DXEffect: TGUID = '{F6CEB4B3-4E4C-40DD-B883-8D8DE5EA0CD5}';



    // {51B8A949-1A31-47e6-BEA0-4B30DB53F1E0}
    IID_ID3DXEffectCompiler: TGUID = '{51B8A949-1A31-47E6-BEA0-4B30DB53F1E0}';




type
    //----------------------------------------------------------------------------
    // D3DXEFFECT_DESC:
    //----------------------------------------------------------------------------

    TD3DXEFFECT_DESC = record
        Creator: LPCSTR; // Creator string
        Parameters: UINT; // Number of parameters
        Techniques: UINT; // Number of techniques
        Functions: UINT; // Number of function entrypoints
    end;
    PD3DXEFFECT_DESC = ^TD3DXEFFECT_DESC;



    //----------------------------------------------------------------------------
    // D3DXPARAMETER_DESC:
    //----------------------------------------------------------------------------

    TD3DXPARAMETER_DESC = record
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
    PD3DXPARAMETER_DESC = ^TD3DXPARAMETER_DESC;



    //----------------------------------------------------------------------------
    // D3DXTECHNIQUE_DESC:
    //----------------------------------------------------------------------------

    TD3DXTECHNIQUE_DESC = record
        Name: LPCSTR; // Technique name
        Passes: UINT; // Number of passes
        Annotations: UINT; // Number of annotations
    end;
    PD3DXTECHNIQUE_DESC = ^TD3DXTECHNIQUE_DESC;



    //----------------------------------------------------------------------------
    // D3DXPASS_DESC:
    //----------------------------------------------------------------------------

    TD3DXPASS_DESC = record
        Name: LPCSTR; // Pass name
        Annotations: UINT; // Number of annotations
        pVertexShaderFunction: PDWORD; // Vertex shader function
        pPixelShaderFunction: PDWORD; // Pixel shader function
    end;
    PD3DXPASS_DESC = ^TD3DXPASS_DESC;




    //----------------------------------------------------------------------------
    // D3DXFUNCTION_DESC:
    //----------------------------------------------------------------------------

    TD3DXFUNCTION_DESC = record
        Name: LPCSTR; // Function name
        Annotations: UINT; // Number of annotations
    end;
    PD3DXFUNCTION_DESC = ^TD3DXFUNCTION_DESC;


    ID3DXEffectPool = interface;
    LPD3DXEFFECTPOOL = ^ID3DXEffectPool;

    ID3DXBaseEffect = interface;
    LPD3DXBASEEFFECT = ^ID3DXBaseEffect;

    ID3DXEffectStateManager = interface;
    LPD3DXEFFECTSTATEMANAGER = ^ID3DXEffectStateManager;

    ID3DXEffect = interface;
    LPD3DXEFFECT = ^ID3DXEffect;

    //////////////////////////////////////////////////////////////////////////////
    // ID3DXEffectPool ///////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////


    ID3DXEffectPool = interface(IUnknown)
        ['{9537AB04-3250-412E-8213-FCD2F8677933}']
    end;






    ID3DXEffectCompiler = interface;
    LPD3DXEFFECTCOMPILER = ^ID3DXEffectCompiler;




    //////////////////////////////////////////////////////////////////////////////
    // ID3DXBaseEffect ///////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////



    ID3DXBaseEffect = interface(IUnknown)
        ['{017C18AC-103F-4417-8C51-6BF6EF1E56BE}']
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
        {in array} ppMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;

        function GetMatrixPointerArray(hParameter: TD3DXHANDLE; out {array} ppMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;

        function SetMatrixTranspose(hParameter: TD3DXHANDLE; pMatrix: PD3DXMATRIX): HRESULT; stdcall;

        function GetMatrixTranspose(hParameter: TD3DXHANDLE; pMatrix: PD3DXMATRIX): HRESULT; stdcall;

        function SetMatrixTransposeArray(hParameter: TD3DXHANDLE; pMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;

        function GetMatrixTransposeArray(hParameter: TD3DXHANDLE; pMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;

        function SetMatrixTransposePointerArray(hParameter: TD3DXHANDLE;
        {in array} ppMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;

        function GetMatrixTransposePointerArray(hParameter: TD3DXHANDLE; out {array} ppMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;

        function SetString(hParameter: TD3DXHANDLE; pString: LPCSTR): HRESULT; stdcall;

        function GetString(hParameter: TD3DXHANDLE; ppString: LPCSTR): HRESULT; stdcall;

        function SetTexture(hParameter: TD3DXHANDLE; pTexture: IDirect3DBaseTexture9): HRESULT; stdcall;

        function GetTexture(hParameter: TD3DXHANDLE; out ppTexture: IDirect3DBaseTexture9): HRESULT; stdcall;

        function GetPixelShader(hParameter: TD3DXHANDLE; out ppPShader: iDIRECT3DPIXELSHADER9): HRESULT; stdcall;

        function GetVertexShader(hParameter: TD3DXHANDLE; out ppVShader: iDIRECT3DVERTEXSHADER9): HRESULT; stdcall;

        //Set Range of an Array to pass to device
        //Useful for sending only a subrange of an array down to the device
        function SetArrayRange(hParameter: TD3DXHANDLE; uStart: UINT; uEnd: UINT): HRESULT; stdcall;

    end;

    //----------------------------------------------------------------------------
    // ID3DXEffectStateManager:
    // ------------------------
    // This is a user implemented interface that can be used to manage device
    // state changes made by an Effect.
    //----------------------------------------------------------------------------

    ID3DXEffectStateManager = interface(IUnknown)
        ['{79AAB587-6DBC-4FA7-82DE-37FA1781C5CE}']
        // The user must correctly implement QueryInterface, AddRef, and Release.
        // The following methods are called by the Effect when it wants to make
        // the corresponding device call.  Note that:
        // 1. Users manage the state and are therefore responsible for making the
        //    the corresponding device calls themselves inside their callbacks.
        // 2. Effects pay attention to the return values of the callbacks, and so
        //    users must pay attention to what they return in their callbacks.
        function SetTransform(State: TD3DTRANSFORMSTATETYPE; pMatrix: PD3DMATRIX): HRESULT; stdcall;

        function SetMaterial(pMaterial: PD3DMATERIAL9): HRESULT; stdcall;

        function SetLight(Index: DWORD; pLight: PD3DLIGHT9): HRESULT; stdcall;

        function LightEnable(Index: DWORD; Enable: boolean): HRESULT; stdcall;

        function SetRenderState(State: TD3DRENDERSTATETYPE; Value: DWORD): HRESULT; stdcall;

        function SetTexture(Stage: DWORD; pTexture: IDIRECT3DBASETEXTURE9): HRESULT; stdcall;

        function SetTextureStageState(Stage: DWORD; TextureType: TD3DTEXTURESTAGESTATETYPE; Value: DWORD): HRESULT; stdcall;

        function SetSamplerState(Sampler: DWORD; SamplerStateType: TD3DSAMPLERSTATETYPE; Value: DWORD): HRESULT; stdcall;

        function SetNPatchMode(NumSegments: single): HRESULT; stdcall;

        function SetFVF(FVF: DWORD): HRESULT; stdcall;

        function SetVertexShader(pShader: IDIRECT3DVERTEXSHADER9): HRESULT; stdcall;

        function SetVertexShaderConstantF(RegisterIndex: UINT; pConstantData: Psingle; RegisterCount: UINT): HRESULT; stdcall;

        function SetVertexShaderConstantI(RegisterIndex: UINT; pConstantData: PINT32; RegisterCount: UINT): HRESULT; stdcall;

        function SetVertexShaderConstantB(RegisterIndex: UINT; pConstantData: Pboolean; RegisterCount: UINT): HRESULT; stdcall;

        function SetPixelShader(pShader: IDIRECT3DPIXELSHADER9): HRESULT; stdcall;

        function SetPixelShaderConstantF(RegisterIndex: UINT; pConstantData: Psingle; RegisterCount: UINT): HRESULT; stdcall;

        function SetPixelShaderConstantI(RegisterIndex: UINT; pConstantData: PINT32; RegisterCount: UINT): HRESULT; stdcall;

        function SetPixelShaderConstantB(RegisterIndex: UINT; pConstantData: Pboolean; RegisterCount: UINT): HRESULT; stdcall;

    end;



    //////////////////////////////////////////////////////////////////////////////
    // ID3DXEffect ///////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////




    ID3DXEffect = interface(ID3DXBaseEffect)
        ['{F6CEB4B3-4E4C-40DD-B883-8D8DE5EA0CD5}']
        // Pool
        function GetPool(out ppPool: ID3DXEFFECTPOOL): HRESULT; stdcall;

        // Selecting and setting a technique
        function SetTechnique(hTechnique: TD3DXHANDLE): HRESULT; stdcall;

        function GetCurrentTechnique(): TD3DXHANDLE; stdcall;

        function ValidateTechnique(hTechnique: TD3DXHANDLE): HRESULT; stdcall;

        function FindNextValidTechnique(hTechnique: TD3DXHANDLE; pTechnique: PD3DXHANDLE): HRESULT; stdcall;

        function IsParameterUsed(hParameter: TD3DXHANDLE; hTechnique: TD3DXHANDLE): boolean; stdcall;

        // Using current technique
        // Begin           starts active technique
        // BeginPass       begins a pass
        // CommitChanges   updates changes to any set calls in the pass. This should be called before
        //                 any DrawPrimitive call to d3d
        // EndPass         ends a pass
        // End             ends active technique
        function _Begin(pPasses: PUINT; Flags: DWORD): HRESULT; stdcall;

        function BeginPass(Pass: UINT): HRESULT; stdcall;

        function CommitChanges(): HRESULT; stdcall;

        function EndPass(): HRESULT; stdcall;

        function _End(): HRESULT; stdcall;

        // Managing D3D Device
        function GetDevice(out ppDevice: IDIRECT3DDEVICE9): HRESULT; stdcall;

        function OnLostDevice(): HRESULT; stdcall;

        function OnResetDevice(): HRESULT; stdcall;

        // Logging device calls
        function SetStateManager(pManager: ID3DXEFFECTSTATEMANAGER): HRESULT; stdcall;

        function GetStateManager(out ppManager: ID3DXEFFECTSTATEMANAGER): HRESULT; stdcall;

        // Parameter blocks
        function BeginParameterBlock(): HRESULT; stdcall;

        function EndParameterBlock(): TD3DXHANDLE; stdcall;

        function ApplyParameterBlock(hParameterBlock: TD3DXHANDLE): HRESULT; stdcall;

        function DeleteParameterBlock(hParameterBlock: TD3DXHANDLE): HRESULT; stdcall;

        // Cloning
        function CloneEffect(pDevice: IDIRECT3DDEVICE9; out ppEffect: ID3DXEFFECT): HRESULT; stdcall;

        // Fast path for setting variables directly in ID3DXEffect
        function SetRawValue(hParameter: TD3DXHANDLE; pData: LPCVOID; ByteOffset: UINT; Bytes: UINT): HRESULT; stdcall;

    end;



    //////////////////////////////////////////////////////////////////////////////
    // ID3DXEffectCompiler ///////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////


    ID3DXEffectCompiler = interface(ID3DXBaseEffect)
        ['{51B8A949-1A31-47E6-BEA0-4B30DB53F1E0}']
        // Parameter sharing, specialization, and information
        function SetLiteral(hParameter: TD3DXHANDLE; Literal: boolean): HRESULT; stdcall;

        function GetLiteral(hParameter: TD3DXHANDLE; pLiteral: Pboolean): HRESULT; stdcall;

        // Compilation
        function CompileEffect(Flags: DWORD; out ppEffect: ID3DXBUFFER; out ppErrorMsgs: ID3DXBUFFER): HRESULT; stdcall;

        function CompileShader(hFunction: TD3DXHANDLE; pTarget: LPCSTR; Flags: DWORD; out ppShader: ID3DXBUFFER; out ppErrorMsgs: ID3DXBUFFER; out ppConstantTable: ID3DXCONSTANTTABLE): HRESULT; stdcall;

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



function D3DXCreateEffectPool(out ppPool: ID3DXEFFECTPOOL): HRESULT; stdcall; external D3DX9_DLL;



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
//  Flags
//      See D3DXSHADER_xxx flags.
//  pSkipConstants
//      A list of semi-colon delimited variable names.  The effect will
//      not set these variables to the device when they are referenced
//      by a shader.  NOTE: the variables specified here must be
//      register bound in the file and must not be used in expressions
//      in passes or samplers or the file will not load.
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

function D3DXCreateEffectFromFileA(pDevice: IDIRECT3DDEVICE9; pSrcFile: LPCSTR; pDefines: PD3DXMACRO; pInclude: ID3DXINCLUDE; Flags: DWORD; pPool: ID3DXEFFECTPOOL; out ppEffect: ID3DXEFFECT;
    out ppCompilationErrors: ID3DXBUFFER): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateEffectFromFileW(pDevice: IDIRECT3DDEVICE9; pSrcFile: LPCWSTR; pDefines: PD3DXMACRO; pInclude: ID3DXINCLUDE; Flags: DWORD; pPool: ID3DXEFFECTPOOL; out ppEffect: ID3DXEFFECT;
    out ppCompilationErrors: ID3DXBUFFER): HRESULT; stdcall; external D3DX9_DLL;




function D3DXCreateEffectFromResourceA(pDevice: IDIRECT3DDEVICE9; hSrcModule: HMODULE; pSrcResource: LPCSTR; pDefines: PD3DXMACRO; pInclude: ID3DXINCLUDE; Flags: DWORD; pPool: ID3DXEFFECTPOOL;
    out ppEffect: ID3DXEFFECT; out ppCompilationErrors: ID3DXBUFFER): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateEffectFromResourceW(pDevice: IDIRECT3DDEVICE9; hSrcModule: HMODULE; pSrcResource: LPCWSTR; pDefines: PD3DXMACRO; pInclude: ID3DXINCLUDE; Flags: DWORD; pPool: ID3DXEFFECTPOOL;
    out ppEffect: ID3DXEFFECT; out ppCompilationErrors: ID3DXBUFFER): HRESULT; stdcall; external D3DX9_DLL;




function D3DXCreateEffect(pDevice: IDIRECT3DDEVICE9; pSrcData: LPCVOID; SrcDataLen: UINT; pDefines: PD3DXMACRO; pInclude: ID3DXINCLUDE; Flags: DWORD; pPool: ID3DXEFFECTPOOL; out ppEffect: ID3DXEFFECT;
    out ppCompilationErrors: ID3DXBUFFER): HRESULT; stdcall; external D3DX9_DLL;



// Ex functions that accept pSkipConstants in addition to other parameters


function D3DXCreateEffectFromFileExA(pDevice: IDIRECT3DDEVICE9; pSrcFile: LPCSTR; pDefines: PD3DXMACRO; pInclude: ID3DXINCLUDE; pSkipConstants: LPCSTR; Flags: DWORD; pPool: ID3DXEFFECTPOOL;
    out ppEffect: ID3DXEFFECT; out ppCompilationErrors: ID3DXBUFFER): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateEffectFromFileExW(pDevice: IDIRECT3DDEVICE9; pSrcFile: LPCWSTR; pDefines: PD3DXMACRO; pInclude: ID3DXINCLUDE; pSkipConstants: LPCSTR; Flags: DWORD; pPool: ID3DXEFFECTPOOL;
    out ppEffect: ID3DXEFFECT; out ppCompilationErrors: ID3DXBUFFER): HRESULT; stdcall; external D3DX9_DLL;



function D3DXCreateEffectFromResourceExA(pDevice: IDIRECT3DDEVICE9; hSrcModule: HMODULE; pSrcResource: LPCSTR; pDefines: PD3DXMACRO; pInclude: ID3DXINCLUDE; pSkipConstants: LPCSTR;
    Flags: DWORD; pPool: ID3DXEFFECTPOOL; out ppEffect: ID3DXEFFECT; out ppCompilationErrors: ID3DXBUFFER): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateEffectFromResourceExW(pDevice: IDIRECT3DDEVICE9; hSrcModule: HMODULE; pSrcResource: LPCWSTR; pDefines: PD3DXMACRO; pInclude: ID3DXINCLUDE; pSkipConstants: LPCSTR;
    Flags: DWORD; pPool: ID3DXEFFECTPOOL; out ppEffect: ID3DXEFFECT; out ppCompilationErrors: ID3DXBUFFER): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateEffectEx(pDevice: IDIRECT3DDEVICE9; pSrcData: LPCVOID; SrcDataLen: UINT; pDefines: PD3DXMACRO; pInclude: ID3DXINCLUDE; pSkipConstants: LPCSTR; Flags: DWORD; pPool: ID3DXEFFECTPOOL;
    out ppEffect: ID3DXEFFECT; out ppCompilationErrors: ID3DXBUFFER): HRESULT; stdcall; external D3DX9_DLL;


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

function D3DXCreateEffectCompilerFromFileA(pSrcFile: LPCSTR; pDefines: PD3DXMACRO; pInclude: ID3DXINCLUDE; Flags: DWORD; out ppCompiler: ID3DXEFFECTCOMPILER; out ppParseErrors: ID3DXBUFFER): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateEffectCompilerFromFileW(pSrcFile: LPCWSTR; pDefines: PD3DXMACRO; pInclude: ID3DXINCLUDE; Flags: DWORD; out ppCompiler: ID3DXEFFECTCOMPILER; out ppParseErrors: ID3DXBUFFER): HRESULT; stdcall; external D3DX9_DLL;




function D3DXCreateEffectCompilerFromResourceA(hSrcModule: HMODULE; pSrcResource: LPCSTR; pDefines: PD3DXMACRO; pInclude: ID3DXINCLUDE; Flags: DWORD; out ppCompiler: ID3DXEFFECTCOMPILER;
    out ppParseErrors: ID3DXBUFFER): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateEffectCompilerFromResourceW(hSrcModule: HMODULE; pSrcResource: LPCWSTR; pDefines: PD3DXMACRO; pInclude: ID3DXINCLUDE; Flags: DWORD; out ppCompiler: ID3DXEFFECTCOMPILER;
    out ppParseErrors: ID3DXBUFFER): HRESULT; stdcall; external D3DX9_DLL;



function D3DXCreateEffectCompiler(pSrcData: LPCSTR; SrcDataLen: UINT; pDefines: PD3DXMACRO; pInclude: ID3DXINCLUDE; Flags: DWORD; out ppCompiler: ID3DXEFFECTCOMPILER; out ppParseErrors: ID3DXBUFFER): HRESULT; stdcall; external D3DX9_DLL;


//----------------------------------------------------------------------------
// D3DXDisassembleEffect:
// -----------------------

// Parameters:
//----------------------------------------------------------------------------

function D3DXDisassembleEffect(pEffect: ID3DXEFFECT; EnableColorCode: boolean; out ppDisassembly: ID3DXBUFFER): HRESULT; stdcall; external D3DX9_DLL;




implementation

end.
