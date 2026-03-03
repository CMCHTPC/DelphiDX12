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
   Content:    D3D10.1 Shader Types and APIs

   This unit consists of the following header files
   File name: D3D10_1Shader.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.D3D10_1Shader;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D10,
    DX12.D3D10Shader;

    {$Z4}

const
    IID_ID3D10ShaderReflection1: TGUID = '{C3457783-A846-47CE-9520-CEA6F66E7447}';

type


    //----------------------------------------------------------------------------
    // Shader debugging structures
    //----------------------------------------------------------------------------

    _D3D10_SHADER_DEBUG_REGTYPE = (
        D3D10_SHADER_DEBUG_REG_INPUT,
        D3D10_SHADER_DEBUG_REG_OUTPUT,
        D3D10_SHADER_DEBUG_REG_CBUFFER,
        D3D10_SHADER_DEBUG_REG_TBUFFER,
        D3D10_SHADER_DEBUG_REG_TEMP,
        D3D10_SHADER_DEBUG_REG_TEMPARRAY,
        D3D10_SHADER_DEBUG_REG_TEXTURE,
        D3D10_SHADER_DEBUG_REG_SAMPLER,
        D3D10_SHADER_DEBUG_REG_IMMEDIATECBUFFER,
        D3D10_SHADER_DEBUG_REG_LITERAL,
        D3D10_SHADER_DEBUG_REG_UNUSED,
        D3D11_SHADER_DEBUG_REG_INTERFACE_POINTERS,
        D3D11_SHADER_DEBUG_REG_UAV,
        D3D10_SHADER_DEBUG_REG_FORCE_DWORD = $7fffffff);

    TD3D10_SHADER_DEBUG_REGTYPE = _D3D10_SHADER_DEBUG_REGTYPE;
    PD3D10_SHADER_DEBUG_REGTYPE = ^TD3D10_SHADER_DEBUG_REGTYPE;


    _D3D10_SHADER_DEBUG_SCOPETYPE = (
        D3D10_SHADER_DEBUG_SCOPE_GLOBAL,
        D3D10_SHADER_DEBUG_SCOPE_BLOCK,
        D3D10_SHADER_DEBUG_SCOPE_FORLOOP,
        D3D10_SHADER_DEBUG_SCOPE_STRUCT,
        D3D10_SHADER_DEBUG_SCOPE_FUNC_PARAMS,
        D3D10_SHADER_DEBUG_SCOPE_STATEBLOCK,
        D3D10_SHADER_DEBUG_SCOPE_NAMESPACE,
        D3D10_SHADER_DEBUG_SCOPE_ANNOTATION,
        D3D10_SHADER_DEBUG_SCOPE_FORCE_DWORD = $7fffffff);

    TD3D10_SHADER_DEBUG_SCOPETYPE = _D3D10_SHADER_DEBUG_SCOPETYPE;
    PD3D10_SHADER_DEBUG_SCOPETYPE = ^TD3D10_SHADER_DEBUG_SCOPETYPE;


    _D3D10_SHADER_DEBUG_VARTYPE = (
        D3D10_SHADER_DEBUG_VAR_VARIABLE,
        D3D10_SHADER_DEBUG_VAR_FUNCTION,
        D3D10_SHADER_DEBUG_VAR_FORCE_DWORD = $7fffffff);

    TD3D10_SHADER_DEBUG_VARTYPE = _D3D10_SHADER_DEBUG_VARTYPE;
    PD3D10_SHADER_DEBUG_VARTYPE = ^TD3D10_SHADER_DEBUG_VARTYPE;


    /////////////////////////////////////////////////////////////////////
    // These are the serialized structures that get written to the file
    /////////////////////////////////////////////////////////////////////

    _D3D10_SHADER_DEBUG_TOKEN_INFO = record
        FileOffset: UINT; // offset into file list
        Line: UINT; // line #
        Column: UINT; // column #
        TokenLength: UINT;
        TokenId: UINT; // offset to LPCSTR of length TokenLength in string datastore
    end;
    TD3D10_SHADER_DEBUG_TOKEN_INFO = _D3D10_SHADER_DEBUG_TOKEN_INFO;
    PD3D10_SHADER_DEBUG_TOKEN_INFO = ^TD3D10_SHADER_DEBUG_TOKEN_INFO;


    // Variable list
    _D3D10_SHADER_DEBUG_VAR_INFO = record
        // Index into token list for declaring identifier
        TokenId: UINT;
        VariableType: TD3D10_SHADER_VARIABLE_TYPE;
        // register and component for this variable, only valid/necessary for arrays
        Register: UINT;
        Component: UINT;
        // gives the original variable that declared this variable
        ScopeVar: UINT;
        // this variable's offset in its ScopeVar
        ScopeVarOffset: UINT;
    end;
    TD3D10_SHADER_DEBUG_VAR_INFO = _D3D10_SHADER_DEBUG_VAR_INFO;
    PD3D10_SHADER_DEBUG_VAR_INFO = ^TD3D10_SHADER_DEBUG_VAR_INFO;


    _D3D10_SHADER_DEBUG_INPUT_INFO = record
        // index into array of variables of variable to initialize
        VarIndex: UINT;
        // input, cbuffer, tbuffer
        InitialRegisterSet: TD3D10_SHADER_DEBUG_REGTYPE;
        // set to cbuffer or tbuffer slot, geometry shader input primitive #,
        // identifying register for indexable temp, or -1
        InitialBank: UINT;
        // -1 if temp, otherwise gives register in register set
        InitialRegister: UINT;
        // -1 if temp, otherwise gives component
        InitialComponent: UINT;
        // initial value if literal
        InitialValue: UINT;
    end;
    TD3D10_SHADER_DEBUG_INPUT_INFO = _D3D10_SHADER_DEBUG_INPUT_INFO;
    PD3D10_SHADER_DEBUG_INPUT_INFO = ^TD3D10_SHADER_DEBUG_INPUT_INFO;


    _D3D10_SHADER_DEBUG_SCOPEVAR_INFO = record
        // Index into variable token
        TokenId: UINT;
        VarType: TD3D10_SHADER_DEBUG_VARTYPE; // variable or function (different namespaces)
        VariableClass: TD3D10_SHADER_VARIABLE_CLASS;
        Rows: UINT; // number of rows (matrices)
        Columns: UINT; // number of columns (vectors and matrices)
        // In an array of structures, one struct member scope is provided, and
        // you'll have to add the array stride times the index to the variable
        // index you find, then find that variable in this structure's list of
        // variables.
        // gives a scope to look up struct members. -1 if not a struct
        StructMemberScope: UINT;
        // number of array indices
        uArrayIndices: UINT; // a[3][2][1] has 3 indices
        // maximum array index for each index
        // offset to UINT[uArrayIndices] in UINT datastore
        ArrayElements: UINT; // a[3][2][1] has {3, 2, 1}
        // how many variables each array index moves
        // offset to UINT[uArrayIndices] in UINT datastore
        ArrayStrides: UINT; // a[3][2][1] has {2, 1, 1}
        uVariables: UINT; // index of the first variable, later variables are offsets from this one
        uFirstVariable: UINT;
    end;
    TD3D10_SHADER_DEBUG_SCOPEVAR_INFO = _D3D10_SHADER_DEBUG_SCOPEVAR_INFO;
    PD3D10_SHADER_DEBUG_SCOPEVAR_INFO = ^TD3D10_SHADER_DEBUG_SCOPEVAR_INFO;


    // scope data, this maps variable names to debug variables (useful for the watch window)
    _D3D10_SHADER_DEBUG_SCOPE_INFO = record
        ScopeType: TD3D10_SHADER_DEBUG_SCOPETYPE;
        Name: UINT; // offset to name of scope in strings list
        uNameLen: UINT; // length of name string
        uVariables: UINT;
        VariableData: UINT; // Offset to UINT[uVariables] indexing the Scope Variable list
    end;
    TD3D10_SHADER_DEBUG_SCOPE_INFO = _D3D10_SHADER_DEBUG_SCOPE_INFO;
    PD3D10_SHADER_DEBUG_SCOPE_INFO = ^TD3D10_SHADER_DEBUG_SCOPE_INFO;


    // instruction outputs
    _D3D10_SHADER_DEBUG_OUTPUTVAR = record
        // index variable being written to, if -1 it's not going to a variable
        VarIndex: UINT;
        // range data that the compiler expects to be true
        uValueMinuValueMax: UINT;
        iValueMiniValueMax: int32;
        fValueMinfValueMax: single;
        bNaNPossiblebInfPossible: boolean;
    end;
    TD3D10_SHADER_DEBUG_OUTPUTVAR = _D3D10_SHADER_DEBUG_OUTPUTVAR;
    PD3D10_SHADER_DEBUG_OUTPUTVAR = ^TD3D10_SHADER_DEBUG_OUTPUTVAR;


    _D3D10_SHADER_DEBUG_OUTPUTREG_INFO = record
        // Only temp, indexable temp, and output are valid here
        OutputRegisterSet: TD3D10_SHADER_DEBUG_REGTYPE;
        // -1 means no output
        OutputReg: UINT;
        // if a temp array, identifier for which one
        TempArrayReg: UINT;
        // -1 means masked out
        OutputComponents: array [0..4 - 1] of UINT;
        OutputVars: array [0..4 - 1] of TD3D10_SHADER_DEBUG_OUTPUTVAR;
        // when indexing the output, get the value of this register, then add
        // that to uOutputReg. If uIndexReg is -1, then there is no index.
        // find the variable whose register is the sum (by looking in the ScopeVar)
        // and component matches, then set it. This should only happen for indexable
        // temps and outputs.
        IndexReg: UINT;
        IndexComp: UINT;
    end;
    TD3D10_SHADER_DEBUG_OUTPUTREG_INFO = _D3D10_SHADER_DEBUG_OUTPUTREG_INFO;
    PD3D10_SHADER_DEBUG_OUTPUTREG_INFO = ^TD3D10_SHADER_DEBUG_OUTPUTREG_INFO;


    // per instruction data
    _D3D10_SHADER_DEBUG_INST_INFO = record
        Id: UINT; // Which instruction this is in the bytecode
        Opcode: UINT; // instruction type
        // 0, 1, or 2
        uOutputs: UINT;
        // up to two outputs per instruction
        pOutputs: array [0..2 - 1] of TD3D10_SHADER_DEBUG_OUTPUTREG_INFO;
        // index into the list of tokens for this instruction's token
        TokenId: UINT;
        // how many function calls deep this instruction is
        NestingLevel: UINT;
        // list of scopes from outer-most to inner-most
        // Number of scopes
        Scopes: UINT;
        ScopeInfo: UINT; // Offset to UINT[uScopes] specifying indices of the ScopeInfo Array
        // list of variables accessed by this instruction
        // Number of variables
        AccessedVars: UINT;
        AccessedVarsInfo: UINT; // Offset to UINT[AccessedVars] specifying indices of the ScopeVariableInfo Array
    end;
    TD3D10_SHADER_DEBUG_INST_INFO = _D3D10_SHADER_DEBUG_INST_INFO;
    PD3D10_SHADER_DEBUG_INST_INFO = ^TD3D10_SHADER_DEBUG_INST_INFO;


    _D3D10_SHADER_DEBUG_FILE_INFO = record
        FileName: UINT; // Offset to LPCSTR for file name
        FileNameLen: UINT; // Length of file name
        FileData: UINT; // Offset to LPCSTR of length FileLen
        FileLen: UINT; // Length of file
    end;
    TD3D10_SHADER_DEBUG_FILE_INFO = _D3D10_SHADER_DEBUG_FILE_INFO;
    PD3D10_SHADER_DEBUG_FILE_INFO = ^TD3D10_SHADER_DEBUG_FILE_INFO;


    _D3D10_SHADER_DEBUG_INFO = record
        Size: UINT; // sizeof(D3D10_SHADER_DEBUG_INFO)
        Creator: UINT; // Offset to LPCSTR for compiler version
        EntrypointName: UINT; // Offset to LPCSTR for Entry point name
        ShaderTarget: UINT; // Offset to LPCSTR for shader target
        CompileFlags: UINT; // flags used to compile
        Files: UINT; // number of included files
        FileInfo: UINT; // Offset to D3D10_SHADER_DEBUG_FILE_INFO[Files]
        Instructions: UINT; // number of instructions
        InstructionInfo: UINT; // Offset to D3D10_SHADER_DEBUG_INST_INFO[Instructions]
        Variables: UINT; // number of variables
        VariableInfo: UINT; // Offset to D3D10_SHADER_DEBUG_VAR_INFO[Variables]
        InputVariables: UINT; // number of variables to initialize before running
        InputVariableInfo: UINT; // Offset to D3D10_SHADER_DEBUG_INPUT_INFO[InputVariables]
        Tokens: UINT; // number of tokens to initialize
        TokenInfo: UINT; // Offset to D3D10_SHADER_DEBUG_TOKEN_INFO[Tokens]
        Scopes: UINT; // number of scopes
        ScopeInfo: UINT; // Offset to D3D10_SHADER_DEBUG_SCOPE_INFO[Scopes]
        ScopeVariables: UINT; // number of variables declared
        ScopeVariableInfo: UINT; // Offset to D3D10_SHADER_DEBUG_SCOPEVAR_INFO[Scopes]
        UintOffset: UINT; // Offset to the UINT datastore, all UINT offsets are from this offset
        StringOffset: UINT; // Offset to the string datastore, all string offsets are from this offset
    end;
    TD3D10_SHADER_DEBUG_INFO = _D3D10_SHADER_DEBUG_INFO;
    PD3D10_SHADER_DEBUG_INFO = ^TD3D10_SHADER_DEBUG_INFO;


    //----------------------------------------------------------------------------
    // ID3D10ShaderReflection1:
    //----------------------------------------------------------------------------

    // Interface definitions



ID3D10ShaderReflection1 = interface(IUnknown)
['{C3457783-A846-47CE-9520-CEA6F66E7447}']

    function GetDesc(
    {_Out_ } pDesc : PD3D10_SHADER_DESC
        ) : HRESULT;stdcall;

    function GetConstantBufferByIndex(
    Index : UINT
        ) : ID3D10ShaderReflectionConstantBuffer;stdcall;

    function GetConstantBufferByName(
    Name : LPCSTR
        ) : ID3D10ShaderReflectionConstantBuffer;stdcall;

    function GetResourceBindingDesc(
    ResourceIndex : UINT ;
    {_Out_ } pDesc : PD3D10_SHADER_INPUT_BIND_DESC
        ) : HRESULT;stdcall;

    function GetInputParameterDesc(
    ParameterIndex : UINT ;
    {_Out_ } pDesc : PD3D10_SIGNATURE_PARAMETER_DESC
        ) : HRESULT;stdcall;

    function GetOutputParameterDesc(
    ParameterIndex : UINT ;
    {_Out_ } pDesc : PD3D10_SIGNATURE_PARAMETER_DESC
        ) : HRESULT;stdcall;

    function GetVariableByName(
    Name : LPCSTR
        ) : ID3D10ShaderReflectionVariable;stdcall;

    function GetResourceBindingDescByName(
    Name : LPCSTR ;
    {_Out_ } pDesc : PD3D10_SHADER_INPUT_BIND_DESC
        ) : HRESULT;stdcall;

    function GetMovInstructionCount(
    {_Out_ } pCount : PUINT
        ) : HRESULT;stdcall;

    function GetMovcInstructionCount(
    {_Out_ } pCount : PUINT
        ) : HRESULT;stdcall;

    function GetConversionInstructionCount(
    {_Out_ } pCount : PUINT
        ) : HRESULT;stdcall;

    function GetBitwiseInstructionCount(
    {_Out_ } pCount : PUINT
        ) : HRESULT;stdcall;

    function GetGSInputPrimitive(
    {_Out_ } pPrim : PD3D10_PRIMITIVE
        ) : HRESULT;stdcall;

    function IsLevel9Shader(
    {_Out_ } pbLevel9Shader : Pboolean
        ) : HRESULT;stdcall;

    function IsSampleFrequencyShader(
    {_Out_ } pbSampleFrequency : Pboolean
        ) : HRESULT;stdcall;

end;

PD3D10SHADERREFLECTION1 = ^ID3D10ShaderReflection1;
LPD3D10SHADERREFLECTION1 = ^ID3D10ShaderReflection1;


implementation

end.
