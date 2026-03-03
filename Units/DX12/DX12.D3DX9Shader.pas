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
   Header version: 9.29.1962.1

  ************************************************************************** }
unit DX12.D3DX9Shader;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D9,
    DX12.D3DX9Core,
    DX12.D3DX9Math;

    {$Z4}

    // for different SDK versions
    {$I DX12.DX9SDKVersion.inc}

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

    // D3DXSHADER_SKIPOPTIMIZATION
    //   Instructs the compiler to skip optimization steps during code generation.
    //   Unless you are trying to isolate a problem in your code using this option
    //   is not recommended.

    // D3DXSHADER_PACKMATRIX_ROWMAJOR
    //   Unless explicitly specified, matrices will be packed in row-major order
    //   on input and output from the shader.

    // D3DXSHADER_PACKMATRIX_COLUMNMAJOR
    //   Unless explicitly specified, matrices will be packed in column-major
    //   order on input and output from the shader.  This is generally more
    //   efficient, since it allows vector-matrix multiplication to be performed
    //   using a series of dot-products.

    // D3DXSHADER_PARTIALPRECISION
    //   Force all computations in resulting shader to occur at partial precision.
    //   This may result in faster evaluation of shaders on some hardware.

    // D3DXSHADER_FORCE_VS_SOFTWARE_NOOPT
    //   Force compiler to compile against the next highest available software
    //   target for vertex shaders.  This flag also turns optimizations off,
    //   and debugging on.

    // D3DXSHADER_FORCE_PS_SOFTWARE_NOOPT
    //   Force compiler to compile against the next highest available software
    //   target for pixel shaders.  This flag also turns optimizations off,
    //   and debugging on.

    // D3DXSHADER_NO_PRESHADER
    //   Disables Preshaders. Using this flag will cause the compiler to not
    //   pull out static expression for evaluation on the host cpu

    // D3DXSHADER_AVOID_FLOW_CONTROL
    //   Hint compiler to avoid flow-control constructs where possible.

    // D3DXSHADER_PREFER_FLOW_CONTROL
    //   Hint compiler to prefer flow-control constructs where possible.

    //----------------------------------------------------------------------------

    D3DXSHADER_DEBUG = (1 shl 0);
    D3DXSHADER_SKIPVALIDATION = (1 shl 1);
    D3DXSHADER_SKIPOPTIMIZATION = (1 shl 2);
    D3DXSHADER_PACKMATRIX_ROWMAJOR = (1 shl 3);
    D3DXSHADER_PACKMATRIX_COLUMNMAJOR = (1 shl 4);
    D3DXSHADER_PARTIALPRECISION = (1 shl 5);
    D3DXSHADER_FORCE_VS_SOFTWARE_NOOPT = (1 shl 6);
    D3DXSHADER_FORCE_PS_SOFTWARE_NOOPT = (1 shl 7);
    D3DXSHADER_NO_PRESHADER = (1 shl 8);
    D3DXSHADER_AVOID_FLOW_CONTROL = (1 shl 9);
    D3DXSHADER_PREFER_FLOW_CONTROL = (1 shl 10);
    D3DXSHADER_ENABLE_BACKWARDS_COMPATIBILITY = (1 shl 12);
    D3DXSHADER_IEEE_STRICTNESS = (1 shl 13);
    D3DXSHADER_USE_LEGACY_D3DX9_31_DLL = (1 shl 16);


    // optimization level flags
    D3DXSHADER_OPTIMIZATION_LEVEL0 = (1 shl 14);
    D3DXSHADER_OPTIMIZATION_LEVEL1 = 0;
    D3DXSHADER_OPTIMIZATION_LEVEL2 = ((1 shl 14) or (1 shl 15));
    D3DXSHADER_OPTIMIZATION_LEVEL3 = (1 shl 15);



    //----------------------------------------------------------------------------
    // D3DXCONSTTABLE flags:
    // -------------------

    D3DXCONSTTABLE_LARGEADDRESSAWARE = (1 shl 17);

    // {AB3C758F-093E-4356-B762-4DB18F1B3A01}
    IID_ID3DXConstantTable: TGUID = '{AB3C758F-093E-4356-B762-4DB18F1B3A01}';


    // {3E3D67F8-AA7A-405d-A857-BA01D4758426}
    IID_ID3DXTextureShader: TGUID = '{3E3D67F8-AA7A-405D-A857-BA01D4758426}';




type
    //----------------------------------------------------------------------------
    // D3DXHANDLE:
    // -----------
    // Handle values used to efficiently reference shader and effect parameters.
    // Strings can be used as handles.  However, handles are not always strings.
    //----------------------------------------------------------------------------

    D3DXHANDLE = UINT_PTR;
    TD3DXHANDLE = D3DXHANDLE;
    PD3DXHANDLE = ^D3DXHANDLE;
    LPD3DXHANDLE = ^D3DXHANDLE;



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
        D3DXPT_UNSUPPORTED,
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
        ParamterClass: TD3DXPARAMETER_CLASS; // Class
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




    ID3DXConstantTable = interface(IUnknown)
        ['{AB3C758F-093E-4356-B762-4DB18F1B3A01}']
        // Buffer
        function GetBufferPointer(): LPVOID; stdcall;

        function GetBufferSize(): DWORD; stdcall;

        // Descs
        function GetDesc(pDesc: PD3DXCONSTANTTABLE_DESC): HRESULT; stdcall;

        function GetConstantDesc(hConstant: TD3DXHANDLE; pConstantDesc: PD3DXCONSTANT_DESC; pCount: PUINT): HRESULT; stdcall;

        function GetSamplerIndex(hConstant: TD3DXHANDLE): UINT; stdcall;

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
        {array} ppMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;

        function SetMatrixTranspose(pDevice: IDirect3DDevice9; hConstant: TD3DXHANDLE; pMatrix: PD3DXMATRIX): HRESULT; stdcall;

        function SetMatrixTransposeArray(pDevice: IDirect3DDevice9; hConstant: TD3DXHANDLE; pMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;

        function SetMatrixTransposePointerArray(pDevice: IDirect3DDevice9; hConstant: TD3DXHANDLE;
        {array} ppMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;

    end;


    //----------------------------------------------------------------------------
    // ID3DXTextureShader:
    //----------------------------------------------------------------------------

    ID3DXTextureShader = interface;
    LPD3DXTEXTURESHADER = ^ID3DXTextureShader;




    ID3DXTextureShader = interface(IUnknown)
        ['{3E3D67F8-AA7A-405D-A857-BA01D4758426}']
        // Gets
        function GetFunction(out ppFunction: ID3DXBUFFER): HRESULT; stdcall;

        function GetConstantBuffer(out ppConstantBuffer: ID3DXBuffer): HRESULT; stdcall;

        // Descs
        function GetDesc(pDesc: PD3DXCONSTANTTABLE_DESC): HRESULT; stdcall;

        function GetConstantDesc(hConstant: TD3DXHANDLE; pConstantDesc: PD3DXCONSTANT_DESC; pCount: PUINT): HRESULT; stdcall;

        // Handle operations
        function GetConstant(hConstant: TD3DXHANDLE; Index: UINT): TD3DXHANDLE; stdcall;

        function GetConstantByName(hConstant: TD3DXHANDLE; pName: LPCSTR): TD3DXHANDLE; stdcall;

        function GetConstantElement(hConstant: TD3DXHANDLE; Index: UINT): TD3DXHANDLE; stdcall;

        // Set Constants
        function SetDefaults(): HRESULT; stdcall;

        function SetValue(hConstant: TD3DXHANDLE; pData: LPCVOID; Bytes: UINT): HRESULT; stdcall;

        function SetBool(hConstant: TD3DXHANDLE; b: boolean): HRESULT; stdcall;

        function SetBoolArray(hConstant: TD3DXHANDLE; pb: Pboolean; Count: UINT): HRESULT; stdcall;

        function SetInt(hConstant: TD3DXHANDLE; n: int32): HRESULT; stdcall;

        function SetIntArray(hConstant: TD3DXHANDLE; pn: PINT32; Count: UINT): HRESULT; stdcall;

        function SetFloat(hConstant: TD3DXHANDLE; f: single): HRESULT; stdcall;

        function SetFloatArray(hConstant: TD3DXHANDLE; pf: Psingle; Count: UINT): HRESULT; stdcall;

        function SetVector(hConstant: TD3DXHANDLE; pVector: PD3DXVECTOR4): HRESULT; stdcall;

        function SetVectorArray(hConstant: TD3DXHANDLE; pVector: PD3DXVECTOR4; Count: UINT): HRESULT; stdcall;

        function SetMatrix(hConstant: TD3DXHANDLE; pMatrix: PD3DXMATRIX): HRESULT; stdcall;

        function SetMatrixArray(hConstant: TD3DXHANDLE; pMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;

        function SetMatrixPointerArray(hConstant: TD3DXHANDLE;
        {array} ppMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;

        function SetMatrixTranspose(hConstant: TD3DXHANDLE; pMatrix: PD3DXMATRIX): HRESULT; stdcall;

        function SetMatrixTransposeArray(hConstant: TD3DXHANDLE; pMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;

        function SetMatrixTransposePointerArray(hConstant: TD3DXHANDLE;
        {array} ppMatrix: PD3DXMATRIX; Count: UINT): HRESULT; stdcall;

    end;




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
    //    subsequently called.  The name of the file is encoded in UTF-8 format.
    // Close()
    //    Closes an include file.  If Open was successful, Close is guaranteed
    //    to be called before the API using this interface returns.
    //----------------------------------------------------------------------------

    {$interfaces corba}
    ID3DXInclude = interface;
    LPD3DXINCLUDE = ^ID3DXInclude;

    ID3DXInclude = interface
        function Open(IncludeType: TD3DXINCLUDE_TYPE; pFileName: LPCSTR; pParentData: LPCVOID; out ppData: LPCVOID; pBytes: PUINT): HRESULT; stdcall;

        function Close(pData: LPCVOID): HRESULT; stdcall;

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
        Flags: DWORD; // flags shader was compiled with
        Target: DWORD; // LPCSTR offset
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
    //  ppErrorMsgs
    //      Returns a buffer containing a listing of errors and warnings that were
    //      encountered during assembly.  If you are running in a debugger,
    //      these are the same messages you will see in your debug output.
    //----------------------------------------------------------------------------




function D3DXAssembleShaderFromFileA(pSrcFile: LPCSTR; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; Flags: DWORD; out ppShader: ID3DXBuffer; out ppErrorMsgs: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;


function D3DXAssembleShaderFromFileW(pSrcFile: LPCWSTR; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; Flags: DWORD; out ppShader: ID3DXBuffer; out ppErrorMsgs: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;




function D3DXAssembleShaderFromResourceA(hSrcModule: HMODULE; pSrcResource: LPCSTR; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; Flags: DWORD; out ppShader: ID3DXBuffer;
    out ppErrorMsgs: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;


function D3DXAssembleShaderFromResourceW(hSrcModule: HMODULE; pSrcResource: LPCWSTR; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; Flags: DWORD; out ppShader: ID3DXBuffer;
    out ppErrorMsgs: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;




function D3DXAssembleShader(pSrcData: LPCSTR; SrcDataLen: UINT; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; Flags: DWORD; out ppShader: ID3DXBuffer; out ppErrorMsgs: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;




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
//  pProfile
//      Instruction set to be used when generating code.  Currently supported
//      profiles are "vs_1_1", "vs_2_0", "vs_2_a", "vs_2_sw", "ps_1_1",
//      "ps_1_2", "ps_1_3", "ps_1_4", "ps_2_0", "ps_2_a", "ps_2_sw", "tx_1_0"
//  Flags
//      See D3DXSHADER_xxx flags.
//  ppShader
//      Returns a buffer containing the created shader.  This buffer contains
//      the compiled shader code, as well as any embedded debug and symbol
//      table info.  (See D3DXGetShaderConstantTable)
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

function D3DXCompileShaderFromFileA(pSrcFile: LPCSTR; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; pFunctionName: LPCSTR; pProfile: LPCSTR; Flags: DWORD; out ppShader: ID3DXBuffer;
    out ppErrorMsgs: ID3DXBuffer; out ppConstantTable: ID3DXConstantTable): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCompileShaderFromFileW(pSrcFile: LPCWSTR; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; pFunctionName: LPCSTR; pProfile: LPCSTR; Flags: DWORD; out ppShader: ID3DXBuffer;
    out ppErrorMsgs: ID3DXBuffer; out ppConstantTable: ID3DXConstantTable): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCompileShaderFromResourceA(hSrcModule: HMODULE; pSrcResource: LPCSTR; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; pFunctionName: LPCSTR; pProfile: LPCSTR; Flags: DWORD;
    out ppShader: ID3DXBuffer; out ppErrorMsgs: ID3DXBuffer; out ppConstantTable: ID3DXConstantTable): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCompileShaderFromResourceW(hSrcModule: HMODULE; pSrcResource: LPCWSTR; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; pFunctionName: LPCSTR; pProfile: LPCSTR; Flags: DWORD;
    out ppShader: ID3DXBuffer; out ppErrorMsgs: ID3DXBuffer; out ppConstantTable: ID3DXConstantTable): HRESULT; stdcall; external D3DX9_DLL;



function D3DXCompileShader(pSrcData: LPCSTR; SrcDataLen: UINT; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; pFunctionName: LPCSTR; pProfile: LPCSTR; Flags: DWORD; out ppShader: ID3DXBuffer;
    out ppErrorMsgs: ID3DXBuffer; out ppConstantTable: ID3DXConstantTable): HRESULT; stdcall; external D3DX9_DLL;



//----------------------------------------------------------------------------
// D3DXDisassembleShader:
// ----------------------
// Takes a binary shader, and returns a buffer containing text assembly.

// Parameters:
//  pShader
//      Pointer to the shader byte code.
//  ShaderSizeInBytes
//      Size of the shader byte code in bytes.
//  EnableColorCode
//      Emit HTML tags for color coding the output?
//  pComments
//      Pointer to a comment string to include at the top of the shader.
//  ppDisassembly
//      Returns a buffer containing the disassembled shader.
//----------------------------------------------------------------------------

function D3DXDisassembleShader(pShader: PDWORD; EnableColorCode: boolean; pComments: LPCSTR; ppDisassembly: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;



//----------------------------------------------------------------------------
// D3DXGetPixelShaderProfile/D3DXGetVertexShaderProfile:
// -----------------------------------------------------
// Returns the name of the HLSL profile best suited to a given device.

// Parameters:
//  pDevice
//      Pointer to the device in question
//----------------------------------------------------------------------------

function D3DXGetPixelShaderProfile(pDevice: IDirect3DDevice9): LPCSTR; stdcall; external D3DX9_DLL;


function D3DXGetVertexShaderProfile(pDevice: IDirect3DDevice9): LPCSTR; stdcall; external D3DX9_DLL;



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

function D3DXFindShaderComment(pFunction: PDWORD; FourCC: DWORD; out ppData: LPCVOID; pSizeInBytes: PUINT): HRESULT; stdcall; external D3DX9_DLL;



//----------------------------------------------------------------------------
// D3DXGetShaderSize:
// ------------------
// Returns the size of the shader byte-code, in bytes.

// Parameters:
//  pFunction
//      Pointer to the function DWORD stream
//----------------------------------------------------------------------------

function D3DXGetShaderSize(pFunction: PDWORD): UINT; stdcall; external D3DX9_DLL;



//----------------------------------------------------------------------------
// D3DXGetShaderVersion:
// -----------------------
// Returns the shader version of a given shader.  Returns zero if the shader
// function is NULL.

// Parameters:
//  pFunction
//      Pointer to the function DWORD stream
//----------------------------------------------------------------------------

function D3DXGetShaderVersion(pFunction: PDWORD): DWORD; stdcall; external D3DX9_DLL;


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

function D3DXGetShaderInputSemantics(pFunction: PDWORD; pSemantics: PD3DXSEMANTIC; pCount: PUINT): HRESULT; stdcall; external D3DX9_DLL;


function D3DXGetShaderOutputSemantics(pFunction: PDWORD; pSemantics: PD3DXSEMANTIC; pCount: PUINT): HRESULT; stdcall; external D3DX9_DLL;



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

function D3DXGetShaderSamplers(pFunction: PDWORD; out pSamplers: LPCSTR; pCount: PUINT): HRESULT; stdcall; external D3DX9_DLL;



//----------------------------------------------------------------------------
// D3DXGetShaderConstantTable:
// ---------------------------
// Gets shader constant table embedded inside shader.  A constant table is
// generated by D3DXAssembleShader and D3DXCompileShader, and is embedded in
// the body of the shader.

// Parameters:
//  pFunction
//      Pointer to the function DWORD stream
//  Flags
//      See D3DXCONSTTABLE_xxx
//  ppConstantTable
//      Returns a ID3DXConstantTable object which can be used to set
//      shader constants to the device.  Alternatively, an application can
//      parse the D3DXSHADER_CONSTANTTABLE block embedded as a comment within
//      the shader.
//----------------------------------------------------------------------------

function D3DXGetShaderConstantTable(pFunction: PDWORD; out ppConstantTable: ID3DXConstantTable): HRESULT; stdcall; external D3DX9_DLL;


function D3DXGetShaderConstantTableEx(pFunction: PDWORD; Flags: DWORD; out ppConstantTable: ID3DXConstantTable): HRESULT; stdcall; external D3DX9_DLL;




//----------------------------------------------------------------------------
// D3DXCreateTextureShader:
// ------------------------
// Creates a texture shader object, given the compiled shader.

// Parameters
//  pFunction
//      Pointer to the function DWORD stream
//  ppTextureShader
//      Returns a ID3DXTextureShader object which can be used to procedurally
//      fill the contents of a texture using the D3DXFillTextureTX functions.
//----------------------------------------------------------------------------

function D3DXCreateTextureShader(pFunction: PDWORD; out ppTextureShader: ID3DXTextureShader): HRESULT; stdcall; external D3DX9_DLL;



//----------------------------------------------------------------------------
// D3DXPreprocessShader:
// ---------------------
// Runs the preprocessor on the specified shader or effect, but does
// not actually compile it.  This is useful for evaluating the #includes
// and #defines in a shader and then emitting a reformatted token stream
// for debugging purposes or for generating a self-contained shader.

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
//  ppShaderText
//      Returns a buffer containing a single large string that represents
//      the resulting formatted token stream
//  ppErrorMsgs
//      Returns a buffer containing a listing of errors and warnings that were
//      encountered during assembly.  If you are running in a debugger,
//      these are the same messages you will see in your debug output.
//----------------------------------------------------------------------------

function D3DXPreprocessShaderFromFileA(pSrcFile: LPCSTR; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; out ppShaderText: ID3DXBuffer; out ppErrorMsgs: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;


function D3DXPreprocessShaderFromFileW(pSrcFile: LPCWSTR; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; out ppShaderText: ID3DXBuffer; out ppErrorMsgs: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;



function D3DXPreprocessShaderFromResourceA(hSrcModule: HMODULE; pSrcResource: LPCSTR; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; out ppShaderText: ID3DXBuffer; out ppErrorMsgs: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;


function D3DXPreprocessShaderFromResourceW(hSrcModule: HMODULE; pSrcResource: LPCWSTR; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; out ppShaderText: ID3DXBuffer; out ppErrorMsgs: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;



function D3DXPreprocessShader(pSrcData: LPCSTR; SrcDataSize: UINT; pDefines: PD3DXMACRO; pInclude: ID3DXInclude; out ppShaderText: ID3DXBuffer; out ppErrorMsgs: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;




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
