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
   Content:    D3DX Shader APIs

   This unit consists of the following header files
   File name: d3dx9shader.h
   Header version: DX9 SDKv9

  ************************************************************************** }

unit DX12.D3DX9Shader9;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D9,
    DX12.D3DX9Core,
    DX12.D3DX9Math;

    {$Z4}

const
    D3DX9_42_DLL = 'd3dx9_42.dll';
    D3DX9_43_DLL = 'd3dx9_43.dll';
    D3DX9_41_DLL = 'd3dx9_41.dll';

const
    //----------------------------------------------------------------------------
    // D3DXSHADER flags:
    // -----------------
    // D3DXSHADER_DEBUG
    //   Insert debug file/line/type/symbol information.

    // D3DXSHADER_SKIPVALIDATION
    //   Do not validate the generated code against known capabilities and
    //   constraints.  This option is only recommended when compiling shaders
    //   you KNOW will work.  (ie. have compiled before without this option.)
    //   Shaders are always validated by D3D before they are set to the device.

    // D3DXSHADER_SKIPOPTIMIZATION (valid for D3DXCompileShader calls only)
    //   Instructs the compiler to skip optimization steps during code generation.
    //   Unless you are trying to isolate a problem in your code, and suspect the
    //   compiler, using this option is not recommended.

    // D3DXSHADER_PACKMATRIX_ROWMAJOR
    //   Unless explicitly specified, matrices will be packed in row-major order
    //   on input and output from the shader.

    // D3DXSHADER_PACKMATRIX_COLUMNMAJOR
    //   Unless explicitly specified, matrices will be packed in column-major
    //   order on input and output from the shader.  This is generally more
    //   efficient, since it allows vector-matrix multiplication to be performed
    //   using a series of dot-products.
    //----------------------------------------------------------------------------

    D3DXSHADER_DEBUG = (1 shl 0);
    D3DXSHADER_SKIPVALIDATION = (1 shl 2);
    D3DXSHADER_SKIPOPTIMIZATION = (1 shl 3);
    D3DXSHADER_PACKMATRIX_ROWMAJOR = (1 shl 4);
    D3DXSHADER_PACKMATRIX_COLUMNMAJOR = (1 shl 5);


    // {9DCA3190-38B9-4fc3-92E3-39C6DDFB358B}
    IID_ID3DXConstantTable: TGUID = '{9DCA3190-38B9-4FC3-92E3-39C6DDFB358B}';



    // {D59D3777-C973-4a3c-B4B0-2A62CD3D8B40}
    IID_ID3DXFragmentLinker: TGUID = '{D59D3777-C973-4A3C-B4B0-2A62CD3D8B40}';


type

    //----------------------------------------------------------------------------
    // D3DXHANDLE:
    // -----------
    // Handle values used to efficiently reference shader and effect parameters.
    // Strings can be used as handles.  However, handles are not always strings.
    //----------------------------------------------------------------------------

    TD3DXHANDLE = LPCSTR;
    PD3DXHANDLE = ^TD3DXHANDLE;
    LPD3DXHANDLE = ^TD3DXHANDLE;


    //----------------------------------------------------------------------------
    // D3DXMACRO:
    // ----------
    // Preprocessor macro definition.  The application pass in a NULL-terminated
    // array of this structure to various D3DX APIs.  This enables the application
    // to #define tokens at runtime, before the file is parsed.
    //----------------------------------------------------------------------------

    _D3DXMACRO = record
        Name: LPCSTR;
        Definition: LPCSTR;
    end;
    TD3DXMACRO = _D3DXMACRO;
    PD3DXMACRO = ^TD3DXMACRO;
    LPD3DXMACRO = ^TD3DXMACRO;


    //----------------------------------------------------------------------------
    // D3DXSEMANTIC:
    //----------------------------------------------------------------------------

    _D3DXSEMANTIC = record
        Usage: UINT;
        UsageIndex: UINT;
    end;
    TD3DXSEMANTIC = _D3DXSEMANTIC;
    PD3DXSEMANTIC = ^TD3DXSEMANTIC;
    LPD3DXSEMANTIC = ^TD3DXSEMANTIC;



    //----------------------------------------------------------------------------
    // D3DXFRAGMENT_DESC:
    //----------------------------------------------------------------------------

    _D3DXFRAGMENT_DESC = record
        Name: LPCSTR;
        Target: DWORD;
    end;
    TD3DXFRAGMENT_DESC = _D3DXFRAGMENT_DESC;
    PD3DXFRAGMENT_DESC = ^TD3DXFRAGMENT_DESC;
    LPD3DXFRAGMENT_DESC = ^TD3DXFRAGMENT_DESC;


    //----------------------------------------------------------------------------
    // D3DXREGISTER_SET:
    //----------------------------------------------------------------------------

    _D3DXREGISTER_SET = (
        D3DXRS_BOOL,
        D3DXRS_INT4,
        D3DXRS_FLOAT4,
        D3DXRS_SAMPLER,
        // force 32-bit size enum
        D3DXRS_FORCE_DWORD = $7fffffff);

    TD3DXREGISTER_SET = _D3DXREGISTER_SET;
    PD3DXREGISTER_SET = ^TD3DXREGISTER_SET;
    LPD3DXREGISTER_SET = ^TD3DXREGISTER_SET;


    //----------------------------------------------------------------------------
    // D3DXPARAMETER_CLASS:
    //----------------------------------------------------------------------------

    _D3DXPARAMETER_CLASS = (
        D3DXPC_SCALAR,
        D3DXPC_VECTOR,
        D3DXPC_MATRIX_ROWS,
        D3DXPC_MATRIX_COLUMNS,
        D3DXPC_OBJECT,
        D3DXPC_STRUCT,
        // force 32-bit size enum
        D3DXPC_FORCE_DWORD = $7fffffff);

    TD3DXPARAMETER_CLASS = _D3DXPARAMETER_CLASS;
    PD3DXPARAMETER_CLASS = ^TD3DXPARAMETER_CLASS;
    LPD3DXPARAMETER_CLASS = ^TD3DXPARAMETER_CLASS;


    //----------------------------------------------------------------------------
    // D3DXPARAMETER_TYPE:
    //----------------------------------------------------------------------------

    _D3DXPARAMETER_TYPE = (
        D3DXPT_VOID,
        D3DXPT_BOOL,
        D3DXPT_INT,
        D3DXPT_FLOAT,
        D3DXPT_STRING,
        D3DXPT_TEXTURE,
        D3DXPT_TEXTURE1D,
        D3DXPT_TEXTURE2D,
        D3DXPT_TEXTURE3D,
        D3DXPT_TEXTURECUBE,
        D3DXPT_SAMPLER,
        D3DXPT_SAMPLER1D,
        D3DXPT_SAMPLER2D,
        D3DXPT_SAMPLER3D,
        D3DXPT_SAMPLERCUBE,
        D3DXPT_PIXELSHADER,
        D3DXPT_VERTEXSHADER,
        D3DXPT_PIXELFRAGMENT,
        D3DXPT_VERTEXFRAGMENT,
        // force 32-bit size enum
        D3DXPT_FORCE_DWORD = $7fffffff);

    TD3DXPARAMETER_TYPE = _D3DXPARAMETER_TYPE;
    PD3DXPARAMETER_TYPE = ^TD3DXPARAMETER_TYPE;
    LPD3DXPARAMETER_TYPE = ^TD3DXPARAMETER_TYPE;


    //----------------------------------------------------------------------------
    // D3DXCONSTANTTABLE_DESC:
    //----------------------------------------------------------------------------

    _D3DXCONSTANTTABLE_DESC = record
        Creator: LPCSTR; // Creator string
        Version: DWORD; // Shader version
        Constants: UINT; // Number of constants
    end;
    TD3DXCONSTANTTABLE_DESC = _D3DXCONSTANTTABLE_DESC;
    PD3DXCONSTANTTABLE_DESC = ^TD3DXCONSTANTTABLE_DESC;
    LPD3DXCONSTANTTABLE_DESC = ^TD3DXCONSTANTTABLE_DESC;


    //----------------------------------------------------------------------------
    // D3DXCONSTANT_DESC:
    //----------------------------------------------------------------------------

    _D3DXCONSTANT_DESC = record
        Name: LPCSTR; // Constant name
        RegisterSet: TD3DXREGISTER_SET; // Register set
        RegisterIndex: UINT; // Register index
        RegisterCount: UINT; // Number of registers occupied
        ParameterClass: TD3DXPARAMETER_CLASS; // Class
        ParameterType: TD3DXPARAMETER_TYPE; // Component type
        Rows: UINT; // Number of rows
        Columns: UINT; // Number of columns
        Elements: UINT; // Number of array elements
        StructMembers: UINT; // Number of structure member sub-parameters
        Bytes: UINT; // Data size, in bytes
        DefaultValue: LPCVOID; // Pointer to default value
    end;
    TD3DXCONSTANT_DESC = _D3DXCONSTANT_DESC;
    PD3DXCONSTANT_DESC = ^TD3DXCONSTANT_DESC;
    LPD3DXCONSTANT_DESC = ^TD3DXCONSTANT_DESC;


    //----------------------------------------------------------------------------
    // ID3DXConstantTable:
    //----------------------------------------------------------------------------

    ID3DXConstantTable = interface;
    LPD3DXCONSTANTTABLE = ^ID3DXConstantTable;



    ID3DXConstantTable = interface(ID3DXBuffer)
        ['{9DCA3190-38B9-4fc3-92E3-39C6DDFB358B}']
        // Descs
        function GetDesc(pDesc: PD3DXCONSTANTTABLE_DESC): HRESULT; stdcall;
        function GetConstantDesc(hConstant: TD3DXHANDLE; pConstantDesc: PD3DXCONSTANT_DESC; pCount: PUINT): HRESULT; stdcall;
        // Handle operations
        function GetConstant(hConstant: TD3DXHANDLE; Index: UINT): TD3DXHANDLE; stdcall;
        function GetConstantByName(hConstant: TD3DXHANDLE; pName: LPCSTR): TD3DXHANDLE; stdcall;
        function GetConstantElement(hConstant: TD3DXHANDLE; Index: UINT): TD3DXHANDLE; stdcall;
        // Set Constants
        function SetDefaults(pDevice: IDirect3DDevice9): HRESULT; stdcall;
        function SetValue(pDevice: IDirect3DDevice9; hConstant: TD3DXHANDLE; pData: LPCVOID; Bytes: UINT): HRESULT; stdcall;
        function SetBool(pDevice: IDirect3DDevice9; hConstant: TD3DXHANDLE; b: boolean): HRESULT; stdcall;
        function SetBoolArray(pDevice: IDirect3DDevice9; hConstant: TD3DXHANDLE; pb: Pboolean; Count: UINT): HRESULT; stdcall;
        function SetInt(pDevice: IDirect3DDevice9; hConstant: TD3DXHANDLE; n: int32): HRESULT; stdcall;
        function SetIntArray(pDevice: IDirect3DDevice9; hConstant: TD3DXHANDLE; pn: PINT32; Count: UINT): HRESULT; stdcall;
        function SetFloat(pDevice: IDirect3DDevice9; hConstant: TD3DXHANDLE; f: single): HRESULT; stdcall;
        function SetFloatArray(pDevice: IDirect3DDevice9; hConstant: TD3DXHANDLE; pf: Psingle; Count: UINT): HRESULT; stdcall;
        function SetVector(pDevice: IDirect3DDevice9; hConstant: TD3DXHANDLE; pVector: PD3DXVECTOR4): HRESULT; stdcall;
        function SetVectorArray(pDevice: IDirect3DDevice9; hConstant: TD3DXHANDLE; pVector: PD3DXVECTOR4; Count: UINT): HRESULT; stdcall;
        function SetMatrix(pDevice: IDirect3DDevice9; hConstant: TD3DXHANDLE; pMatrix: PD3DXMATRIX): HRESULT; stdcall;
        function SetMatrixArray(pDevice: IDirect3DDevice9; hConstant: TD3DXHANDLE; pMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;
        function SetMatrixPointerArray(pDevice: IDirect3DDevice9; hConstant: TD3DXHANDLE;
        {in array} ppMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;

        function SetMatrixTranspose(pDevice: IDirect3DDevice9; hConstant: TD3DXHANDLE; pMatrix: PD3DXMATRIX): HRESULT; stdcall;
        function SetMatrixTransposeArray(pDevice: IDirect3DDevice9; hConstant: TD3DXHANDLE; pMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;
        function SetMatrixTransposePointerArray(pDevice: IDirect3DDevice9; hConstant: TD3DXHANDLE;
        {in array} ppMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;
    end;


    //----------------------------------------------------------------------------
    // ID3DXFragmentLinker
    //----------------------------------------------------------------------------


    ID3DXFragmentLinker = interface(IUnknown)
        ['{D59D3777-C973-4a3c-B4B0-2A62CD3D8B40}']
        // ID3DXFragmentLinker
        // fragment access and information retrieval functions
        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;

        function GetNumberOfFragments(): UINT; stdcall;

        function GetFragmentHandleByIndex(Index: UINT): TD3DXHANDLE; stdcall;

        function GetFragmentHandleByName(Name: LPCSTR): TD3DXHANDLE; stdcall;

        function GetFragmentDesc(Name: TD3DXHANDLE; FragDesc: LPD3DXFRAGMENT_DESC): HRESULT; stdcall;

        // add the fragments in the buffer to the linker
        function AddFragments(Fragments: PDWORD): HRESULT; stdcall;

        // Create a buffer containing the fragments.  Suitable for saving to disk
        function GetAllFragments(out ppBuffer: ID3DXBuffer): HRESULT; stdcall;

        function GetFragment(Name: TD3DXHANDLE; out ppBuffer: ID3DXBuffer): HRESULT; stdcall;

        function LinkShader(pTarget: LPCSTR; Flags: DWORD; rgFragmentHandles: LPD3DXHANDLE; cFragments: UINT; out ppBuffer: ID3DXBuffer; out ppErrorMsgs: ID3DXBuffer): HRESULT; stdcall;

        function LinkVertexShader(pTarget: LPCSTR; Flags: DWORD; rgFragmentHandles: LPD3DXHANDLE; cFragments: UINT; out pVShader: IDirect3DVertexShader9; out ppErrorMsgs: ID3DXBuffer): HRESULT; stdcall;

        function ClearCache(): HRESULT; stdcall;

    end;

    LPD3DXFRAGMENTLINKER = ^ID3DXFragmentLinker;

    //----------------------------------------------------------------------------
    // D3DXINCLUDE_TYPE:
    //----------------------------------------------------------------------------

    _D3DXINCLUDE_TYPE = (
        D3DXINC_LOCAL,
        D3DXINC_SYSTEM,
        // force 32-bit size enum
        D3DXINC_FORCE_DWORD = $7fffffff);

    TD3DXINCLUDE_TYPE = _D3DXINCLUDE_TYPE;
    PD3DXINCLUDE_TYPE = ^TD3DXINCLUDE_TYPE;
    LPD3DXINCLUDE_TYPE = ^TD3DXINCLUDE_TYPE;

    //----------------------------------------------------------------------------
    // ID3DXInclude:
    // -------------
    // This interface is intended to be implemented by the application, and can
    // be used by various D3DX APIs.  This enables application-specific handling
    // of #include directives in source files.

    // Open()
    //    Opens an include file.  If successful, it should fill in ppData and
    //    pBytes.  The data pointer returned must remain valid until Close is
    //    subsequently called.
    // Close()
    //    Closes an include file.  If Open was successful, Close is guaranteed
    //    to be called before the API using this interface returns.
    //----------------------------------------------------------------------------

    {$interfaces corba}
    ID3DXInclude = interface;
    LPD3DXINCLUDE = ^ID3DXInclude;

    ID3DXInclude = interface
        function Open(
        {in} IncludeType: TD3DXINCLUDE_TYPE;
        {in} pFileName: LPCSTR;
        {in} pParentData: LPCVOID;
        {out} out ppData: LPCVOID;
        {out}pBytes: PUINT): HRESULT; stdcall;

        function Close(
        {in} pData: LPCVOID): HRESULT; stdcall;

    end;

    {$interfaces COM}




    //////////////////////////////////////////////////////////////////////////////
    // Shader comment block layouts //////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    //----------------------------------------------------------------------------
    // D3DXSHADER_CONSTANTTABLE:
    // -------------------------
    // Shader constant information; included as an CTAB comment block inside
    // shaders.  All offsets are BYTE offsets from start of CONSTANTTABLE struct.
    // Entries in the table are sorted by Name in ascending order.
    //----------------------------------------------------------------------------


    _D3DXSHADER_CONSTANTTABLE = record
        Size: DWORD; // sizeof(D3DXSHADER_CONSTANTTABLE)
        Creator: DWORD; // LPCSTR offset
        Version: DWORD; // shader version
        Constants: DWORD; // number of constants
        ConstantInfo: DWORD; // D3DXSHADER_CONSTANTINFO[Constants] offset
    end;
    TD3DXSHADER_CONSTANTTABLE = _D3DXSHADER_CONSTANTTABLE;
    PD3DXSHADER_CONSTANTTABLE = ^TD3DXSHADER_CONSTANTTABLE;

    LPD3DXSHADER_CONSTANTTABLE = ^TD3DXSHADER_CONSTANTTABLE;


    _D3DXSHADER_CONSTANTINFO = record
        Name: DWORD; // LPCSTR offset
        RegisterSet: word; // D3DXREGISTER_SET
        RegisterIndex: word; // register number
        RegisterCount: word; // number of registers
        Reserved: word; // reserved
        TypeInfo: DWORD; // D3DXSHADER_TYPEINFO offset
        DefaultValue: DWORD; // offset of default value
    end;
    TD3DXSHADER_CONSTANTINFO = _D3DXSHADER_CONSTANTINFO;
    PD3DXSHADER_CONSTANTINFO = ^TD3DXSHADER_CONSTANTINFO;

    LPD3DXSHADER_CONSTANTINFO = ^TD3DXSHADER_CONSTANTINFO;


    _D3DXSHADER_TYPEINFO = record
        ParameterClass: word; // D3DXPARAMETER_CLASS
        ParameterType: word; // D3DXPARAMETER_TYPE
        Rows: word; // number of rows (matrices)
        Columns: word; // number of columns (vectors and matrices)
        Elements: word; // array dimension
        StructMembers: word; // number of struct members
        StructMemberInfo: DWORD; // D3DXSHADER_STRUCTMEMBERINFO[Members] offset
    end;
    TD3DXSHADER_TYPEINFO = _D3DXSHADER_TYPEINFO;
    PD3DXSHADER_TYPEINFO = ^TD3DXSHADER_TYPEINFO;

    LPD3DXSHADER_TYPEINFO = ^TD3DXSHADER_TYPEINFO;


    _D3DXSHADER_STRUCTMEMBERINFO = record
        Name: DWORD; // LPCSTR offset
        TypeInfo: DWORD; // D3DXSHADER_TYPEINFO offset
    end;
    TD3DXSHADER_STRUCTMEMBERINFO = _D3DXSHADER_STRUCTMEMBERINFO;
    PD3DXSHADER_STRUCTMEMBERINFO = ^TD3DXSHADER_STRUCTMEMBERINFO;

    LPD3DXSHADER_STRUCTMEMBERINFO = ^TD3DXSHADER_STRUCTMEMBERINFO;




    //////////////////////////////////////////////////////////////////////////////
    // APIs //////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    //----------------------------------------------------------------------------
    // D3DXAssembleShader:
    // -------------------
    // Assembles a shader.

    // Parameters:
    //  pSrcFile
    //      Source file name
    //  hSrcModule
    //      Module handle. if NULL, current module will be used
    //  pSrcResource
    //      Resource name in module
    //  pSrcData
    //      Pointer to source code
    //  SrcDataLen
    //      Size of source code, in bytes
    //  pDefines
    //      Optional NULL-terminated array of preprocessor macro definitions.
    //  pInclude
    //      Optional interface pointer to use for handling #include directives.
    //      If this parameter is NULL, #includes will be honored when assembling
    //      from file, and will error when assembling from resource or memory.
    //  Flags
    //      See D3DXSHADER_xxx flags
    //  ppShader
    //      Returns a buffer containing the created shader.  This buffer contains
    //      the assembled shader code, as well as any embedded debug info.
    //      (See D3DXGetShaderDebugInfo)
    //  ppErrorMsgs
    //      Returns a buffer containing a listing of errors and warnings that were
    //      encountered during assembly.  If you are running in a debugger,
    //      these are the same messages you will see in your debug output.
    //----------------------------------------------------------------------------




function D3DXAssembleShaderFromFileA(
    {in} pSrcFile: LPCSTR;
    {in} pDefines: PD3DXMACRO;
    {in} pInclude: ID3DXInclude;
    {in} Flags: DWORD;
    {out} out ppShader: ID3DXBuffer;
    {out} out ppErrorMsgs: ID3DXBUFFER): HRESULT; stdcall; external D3DX9_43_DLL;


function D3DXAssembleShaderFromFileW(
    {in} pSrcFile: LPCWSTR;
    {in} pDefines: PD3DXMACRO;
    {in} pInclude: ID3DXInclude;
    {in} Flags: DWORD;
    {out} out ppShader: ID3DXBuffer;
    {out} out ppErrorMsgs: ID3DXBuffer): HRESULT; stdcall; external D3DX9_43_DLL;



function D3DXAssembleShaderFromResourceA(
    {in} hSrcModule: HMODULE;
    {in} pSrcResource: LPCSTR;
    {in} pDefines: PD3DXMACRO;
    {in} pInclude: ID3DXInclude;
    {in} Flags: DWORD;
    {out} out ppShader: ID3DXBuffer;
    {out} out ppErrorMsgs: ID3DXBuffer): HRESULT; stdcall; external D3DX9_43_DLL;


function D3DXAssembleShaderFromResourceW(
    {in} hSrcModule: HMODULE;
    {in} pSrcResource: LPCWSTR;
    {in} pDefines: PD3DXMACRO;
    {in} pInclude: ID3DXInclude;
    {in} Flags: DWORD;
    {out} out ppShader: ID3DXBuffer;
    {out} out ppErrorMsgs: ID3DXBuffer): HRESULT; stdcall; external D3DX9_43_DLL;



function D3DXAssembleShader(
    {in} pSrcData: LPCSTR;
    {in} SrcDataLen: UINT;
    {in} pDefines: PD3DXMACRO;
    {in} pInclude: ID3DXInclude;
    {in} Flags: DWORD;
    {out} out ppShader: ID3DXBuffer;
    {out} out ppErrorMsgs: ID3DXBuffer): HRESULT; stdcall; external D3DX9_43_DLL;




//----------------------------------------------------------------------------
// D3DXCompileShader:
// ------------------
// Compiles a shader.

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
//  pTarget
//      Instruction set to be used when generating code.  Currently supported
//      targets are "vs_1_1", "vs_2_0", "vs_2_sw", "ps_1_1", "ps_1_2", "ps_1_3",
//      "ps_1_4", "ps_2_0", "ps_2_sw", "tx_1_0"
//  Flags
//      See D3DXSHADER_xxx flags.
//  ppShader
//      Returns a buffer containing the created shader.  This buffer contains
//      the compiled shader code, as well as any embedded debug and symbol
//      table info.  (See D3DXGetShaderDebugInfo, D3DXGetShaderConstantTable)
//  ppErrorMsgs
//      Returns a buffer containing a listing of errors and warnings that were
//      encountered during the compile.  If you are running in a debugger,
//      these are the same messages you will see in your debug output.
//  ppConstantTable
//      Returns a ID3DXConstantTable object which can be used to set
//      shader constants to the device.  Alternatively, an application can
//      parse the D3DXSHADER_CONSTANTTABLE block embedded as a comment within
//      the shader.
//----------------------------------------------------------------------------

function D3DXCompileShaderFromFileA(
    {in} pSrcFile: LPCSTR;
    {in} pDefines: PD3DXMACRO;
    {in} pInclude: ID3DXInclude;
    {in} pFunctionName: LPCSTR;
    {in} pTarget: LPCSTR;
    {in} Flags: DWORD;
    {out} out ppShader: ID3DXBuffer;
    {out} out ppErrorMsgs: ID3DXBuffer;
    {out} out ppConstantTable: ID3DXConstantTable): HRESULT; stdcall; external D3DX9_43_DLL;


function D3DXCompileShaderFromFileW(
    {in} pSrcFile: LPCWSTR;
    {in} pDefines: PD3DXMACRO;
    {in} pInclude: ID3DXInclude;
    {in} pFunctionName: LPCSTR;
    {in} pTarget: LPCSTR;
    {in} Flags: DWORD;
    {out} out ppShader: ID3DXBuffer;
    {out} out ppErrorMsgs: ID3DXBuffer;
    {out} out ppConstantTable: ID3DXConstantTable): HRESULT; stdcall; external D3DX9_43_DLL;


function D3DXCompileShaderFromResourceA(
    {in} hSrcModule: HMODULE;
    {in} pSrcResource: LPCSTR;
    {in} pDefines: PD3DXMACRO;
    {in} pInclude: ID3DXInclude;
    {in} pFunctionName: LPCSTR;
    {in} pTarget: LPCSTR;
    {in} Flags: DWORD;
    {out} out ppShader: ID3DXBuffer;
    {out} out ppErrorMsgs: ID3DXBuffer;
    {out} out ppConstantTable: ID3DXConstantTable): HRESULT; stdcall; external D3DX9_43_DLL;


function D3DXCompileShaderFromResourceW(
    {in} hSrcModule: HMODULE;
    {in} pSrcResource: LPCWSTR;
    {in} pDefines: PD3DXMACRO;
    {in} pInclude: ID3DXInclude;
    {in} pFunctionName: LPCSTR;
    {in} pTarget: LPCSTR;
    {in} Flags: DWORD;
    {out} out ppShader: ID3DXBuffer;
    {out} out ppErrorMsgs: ID3DXBuffer;
    {out} out ppConstantTable: ID3DXConstantTable): HRESULT; stdcall; external D3DX9_43_DLL;


function D3DXCompileShader(
    {in} pSrcData: LPCSTR;
    {in} SrcDataLen: UINT;
    {in} pDefines: PD3DXMACRO;
    {in} pInclude: ID3DXInclude;
    {in} pFunctionName: LPCSTR;
    {in} pTarget: LPCSTR;
    {in} Flags: DWORD;
    {out} out ppShader: ID3DXBuffer;
    {out} out ppErrorMsgs: ID3DXBuffer;
    {out} out ppConstantTable: ID3DXConstantTable): HRESULT; stdcall; external D3DX9_43_DLL;


//----------------------------------------------------------------------------
// D3DXFindShaderComment:
// ----------------------
// Searches through a shader for a particular comment, denoted by a FourCC in
// the first DWORD of the comment.  If the comment is not found, and no other
// error has occurred, S_FALSE is returned.

// Parameters:
//  pFunction
//      Pointer to the function DWORD stream
//  FourCC
//      FourCC used to identify the desired comment block.
//  ppData
//      Returns a pointer to the comment data (not including comment token
//      and FourCC).  Can be NULL.
//  pSizeInBytes
//      Returns the size of the comment data in bytes.  Can be NULL.
//----------------------------------------------------------------------------

function D3DXFindShaderComment(
    {in} pFunction: PDWORD;
    {in} FourCC: DWORD;
    {in_out} ppData: pointer = nil;
    {out}pSizeInBytes: PUINT = nil): HRESULT; stdcall; external D3DX9_43_DLL;



//----------------------------------------------------------------------------
// D3DXGetShaderSemantics:
// -----------------------
// Gets semantics for all input elements referenced inside a given shader.

// Parameters:
//  pFunction
//      Pointer to the function DWORD stream
//  pSemantics
//      Pointer to an array of D3DXSEMANTIC structures.  The function will
//      fill this array with the semantics for each input element referenced
//      inside the shader.  This array is assumed to contain at least
//      MAXD3DDECLLENGTH elements.
//  pCount
//      Returns the number of elements referenced by the shader
//----------------------------------------------------------------------------

function D3DXGetShaderInputSemantics(
    {in} pFunction: PDWORD;
    // pSemantics = NULL will return the number of elements needed for pCount
    {in} pSemantics: PD3DXSEMANTIC;
    {out} pCount: PUINT): HRESULT; stdcall; external D3DX9_43_DLL;


function D3DXGetShaderOutputSemantics(
    {in} pFunction: PDWORD;
    // pSemantics = NULL will return the number of elements needed for pCount
    {in} pSemantics: PD3DXSEMANTIC;
    {out} pCount: PUINT): HRESULT; stdcall; external D3DX9_43_DLL;



//----------------------------------------------------------------------------
// D3DXGetShaderSamplers:
// ----------------------
// Gets semantics for all input elements referenced inside a given shader.

// pFunction
//      Pointer to the function DWORD stream
// pSamplers
//      Pointer to an array of LPCSTRs.  The function will fill this array
//      with pointers to the sampler names contained within pFunction, for
//      each sampler referenced inside the shader.  This array is assumed to
//      contain at least 16 elements.
// pCount
//      Returns the number of samplers referenced by the shader
//----------------------------------------------------------------------------

function D3DXGetShaderSamplers(
    {in} pFunction: PDWORD;
    // to find the number of samplers used call with pSamplers = NULL.
    {in_out} pSamplers: LPCSTR;
    {out} pCount: PUINT): HRESULT; stdcall; external D3DX9_43_DLL;



//----------------------------------------------------------------------------
// D3DXGetShaderConstantTable:
// ---------------------------
// Gets shader constant table embedded inside shader.  A constant table is
// generated by D3DXAssembleShader and D3DXCompileShader, and is embedded in
// the body of the shader.

// Parameters:
//  pFunction
//      Pointer to the function DWORD stream
//  ppConstantTable
//      Returns a ID3DXConstantTable object which can be used to set
//      shader constants to the device.  Alternatively, an application can
//      parse the D3DXSHADER_CONSTANTTABLE block embedded as a comment within
//      the shader.
//----------------------------------------------------------------------------

function D3DXGetShaderConstantTable(
    {in} pFunction: PDWORD;
    {out} out ppConstantTable: ID3DXConstantTable): HRESULT; stdcall; external D3DX9_43_DLL;



//----------------------------------------------------------------------------
// D3DXGetShaderDebugInfo:
// -----------------------
// Gets shader debug info.  Debug info is generated D3DXAssembleShader and
// D3DXCompileShader and is embedded the body of the shader.

// Parameters:
//  pFunction
//      Pointer to the function DWORD stream
//  ppDebugInfo
//      Buffer used to return debug info.  For information about the layout
//      of this buffer, see definition of D3DXSHADER_DEBUGINFO above.
//----------------------------------------------------------------------------

function D3DXGetShaderDebugInfo(
    {in}pFunction: PDWORD;
    {out} out ppDebugInfo: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;




//----------------------------------------------------------------------------
// D3DXGatherFragments:
// -------------------
// Assembles shader fragments into a buffer to be passed to a fragment linker.
//   will generate shader fragments for all fragments in the file

// Parameters:
//  pSrcFile
//      Source file name
//  hSrcModule
//      Module handle. if NULL, current module will be used
//  pSrcResource
//      Resource name in module
//  pSrcData
//      Pointer to source code
//  SrcDataLen
//      Size of source code, in bytes
//  pDefines
//      Optional NULL-terminated array of preprocessor macro definitions.
//  pInclude
//      Optional interface pointer to use for handling #include directives.
//      If this parameter is NULL, #includes will be honored when assembling
//      from file, and will error when assembling from resource or memory.
//  Flags
//      See D3DXSHADER_xxx flags
//  ppShader
//      Returns a buffer containing the created shader fragments.  This buffer contains
//      the assembled shader code, as well as any embedded debug info.
//  ppErrorMsgs
//      Returns a buffer containing a listing of errors and warnings that were
//      encountered during assembly.  If you are running in a debugger,
//      these are the same messages you will see in your debug output.
//----------------------------------------------------------------------------


function D3DXGatherFragmentsFromFileA(
    {in} pSrcFile: LPCSTR;
    {in} Defines: PD3DXMACRO;
    {in} pInclude: ID3DXInclude;
    {in} Flags: DWORD;
    {out} out ppShader: ID3DXBuffer;
    {out} out ppErrorMsgs: ID3DXBuffer): HRESULT; stdcall; external D3DX9_42_DLL;


function D3DXGatherFragmentsFromFileW(
    {in} pSrcFile: LPCWSTR;
    {in} pDefines: PD3DXMACRO;
    {in} pInclude: ID3DXInclude;
    {in} Flags: DWORD;
    {out} out ppShader: ID3DXBuffer;
    {out} out ppErrorMsgs: ID3DXBuffer): HRESULT; stdcall; external D3DX9_42_DLL;



function D3DXGatherFragmentsFromResourceA(
    {in} hSrcModule: HMODULE;
    {in} pSrcResource: LPCSTR;
    {in} pDefines: PD3DXMACRO;
    {in} pInclude: ID3DXInclude;
    {in} Flags: DWORD;
    {out} out ppShader: ID3DXBuffer;
    {out} out ppErrorMsgs: ID3DXBuffer): HRESULT; stdcall; external D3DX9_42_DLL;


function D3DXGatherFragmentsFromResourceW(
    {in} hSrcModule: HMODULE;
    {in} pSrcResource: LPCWSTR;
    {in} pDefines: PD3DXMACRO;
    {in} pInclude: ID3DXInclude;
    {in} Flags: DWORD;
    {out} out ppShader: ID3DXBuffer;
    {out} out ppErrorMsgs: ID3DXBuffer): HRESULT; stdcall; external D3DX9_42_DLL;




function D3DXGatherFragments(
    {in} pSrcData: LPCSTR;
    {in} SrcDataLen: UINT;
    {in} pDefines: PD3DXMACRO;
    {in} pInclude: ID3DXInclude;
    {in} Flags: DWORD;
    {out} out ppShader: ID3DXBuffer;
    {out} out ppErrorMsgs: ID3DXBuffer): HRESULT; stdcall; external D3DX9_42_DLL;




//----------------------------------------------------------------------------
// D3DXCreateFragmentLinker:
// -------------------------
// Creates a fragment linker with a given cache size.  The interface returned
// can be used to link together shader fragments.  (both HLSL & ASM fragements)

// Parameters:
//  pDevice
//      Pointer of the device on which to create the effect
//  ShaderCacheSize
//      Size of the shader cache
//  ppFragmentLinker
//      pointer to a memory location to put the created interface pointer

//----------------------------------------------------------------------------

function D3DXCreateFragmentLinker(
    {in} pDevice: IDirect3DDevice9;
    {in} ShaderCacheSize: UINT;
    {out} out ppFragmentLinker: ID3DXFragmentLinker): HRESULT; stdcall; external D3DX9_41_DLL;


//---------------------------------------------------------------------------
// D3DXTX_VERSION:
// --------------
// Version token used to create a procedural texture filler in effects
// Used by D3DXFill[]TX functions
//---------------------------------------------------------------------------
function D3DXTX_VERSION(_Major, _Minor: byte): DWORD;

implementation



function D3DXTX_VERSION(_Major, _Minor: byte): DWORD;
begin
    Result := (Ord('T') shl 24) or (Ord('X') shl 16) or (_Major shl 8) or _Minor;
end;

end.
