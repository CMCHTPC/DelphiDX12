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
   Content:    D3D10 Shader Types and APIs

   This unit consists of the following header files
   File name: D3D10Shader.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3D10Shader;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D10,
    DX12.D3DCommon;

    {$Z4}

const
    D3D10_DLL = 'D3D10.dll';


    //----------------------------------------------------------------------------
    // D3D10SHADER flags:
    // -----------------
    // D3D10_SHADER_DEBUG
    //   Insert debug file/line/type/symbol information.

    // D3D10_SHADER_SKIP_VALIDATION
    //   Do not validate the generated code against known capabilities and
    //   constraints.  This option is only recommended when compiling shaders
    //   you KNOW will work.  (ie. have compiled before without this option.)
    //   Shaders are always validated by D3D before they are set to the device.

    // D3D10_SHADER_SKIP_OPTIMIZATION
    //   Instructs the compiler to skip optimization steps during code generation.
    //   Unless you are trying to isolate a problem in your code using this option
    //   is not recommended.

    // D3D10_SHADER_PACK_MATRIX_ROW_MAJOR
    //   Unless explicitly specified, matrices will be packed in row-major order
    //   on input and output from the shader.

    // D3D10_SHADER_PACK_MATRIX_COLUMN_MAJOR
    //   Unless explicitly specified, matrices will be packed in column-major
    //   order on input and output from the shader.  This is generally more
    //   efficient, since it allows vector-matrix multiplication to be performed
    //   using a series of dot-products.

    // D3D10_SHADER_PARTIAL_PRECISION
    //   Force all computations in resulting shader to occur at partial precision.
    //   This may result in faster evaluation of shaders on some hardware.

    // D3D10_SHADER_FORCE_VS_SOFTWARE_NO_OPT
    //   Force compiler to compile against the next highest available software
    //   target for vertex shaders.  This flag also turns optimizations off,
    //   and debugging on.

    // D3D10_SHADER_FORCE_PS_SOFTWARE_NO_OPT
    //   Force compiler to compile against the next highest available software
    //   target for pixel shaders.  This flag also turns optimizations off,
    //   and debugging on.

    // D3D10_SHADER_NO_PRESHADER
    //   Disables Preshaders. Using this flag will cause the compiler to not
    //   pull out static expression for evaluation on the host cpu

    // D3D10_SHADER_AVOID_FLOW_CONTROL
    //   Hint compiler to avoid flow-control constructs where possible.

    // D3D10_SHADER_PREFER_FLOW_CONTROL
    //   Hint compiler to prefer flow-control constructs where possible.

    // D3D10_SHADER_ENABLE_STRICTNESS
    //   By default, the HLSL/Effect compilers are not strict on deprecated syntax.
    //   Specifying this flag enables the strict mode. Deprecated syntax may be
    //   removed in a future release, and enabling syntax is a good way to make sure
    //   your shaders comply to the latest spec.

    // D3D10_SHADER_ENABLE_BACKWARDS_COMPATIBILITY
    //   This enables older shaders to compile to 4_0 targets.

    //----------------------------------------------------------------------------


    D3D10_SHADER_DEBUG = (1 shl 0);
    D3D10_SHADER_SKIP_VALIDATION = (1 shl 1);
    D3D10_SHADER_SKIP_OPTIMIZATION = (1 shl 2);
    D3D10_SHADER_PACK_MATRIX_ROW_MAJOR = (1 shl 3);
    D3D10_SHADER_PACK_MATRIX_COLUMN_MAJOR = (1 shl 4);
    D3D10_SHADER_PARTIAL_PRECISION = (1 shl 5);
    D3D10_SHADER_FORCE_VS_SOFTWARE_NO_OPT = (1 shl 6);
    D3D10_SHADER_FORCE_PS_SOFTWARE_NO_OPT = (1 shl 7);
    D3D10_SHADER_NO_PRESHADER = (1 shl 8);
    D3D10_SHADER_AVOID_FLOW_CONTROL = (1 shl 9);
    D3D10_SHADER_PREFER_FLOW_CONTROL = (1 shl 10);
    D3D10_SHADER_ENABLE_STRICTNESS = (1 shl 11);
    D3D10_SHADER_ENABLE_BACKWARDS_COMPATIBILITY = (1 shl 12);
    D3D10_SHADER_IEEE_STRICTNESS = (1 shl 13);
    D3D10_SHADER_WARNINGS_ARE_ERRORS = (1 shl 18);
    D3D10_SHADER_RESOURCES_MAY_ALIAS = (1 shl 19);
    D3D10_ENABLE_UNBOUNDED_DESCRIPTOR_TABLES = (1 shl 20);
    D3D10_ALL_RESOURCES_BOUND = (1 shl 21);
    D3D10_SHADER_DEBUG_NAME_FOR_SOURCE = (1 shl 22);
    D3D10_SHADER_DEBUG_NAME_FOR_BINARY = (1 shl 23);


    // optimization level flags
    D3D10_SHADER_OPTIMIZATION_LEVEL0 = (1 shl 14);
    D3D10_SHADER_OPTIMIZATION_LEVEL1 = 0;
    D3D10_SHADER_OPTIMIZATION_LEVEL2 = ((1 shl 14) or (1 shl 15));
    D3D10_SHADER_OPTIMIZATION_LEVEL3 = (1 shl 15);


    // Force root signature flags. (Passed in Flags2)
    D3D10_SHADER_FLAGS2_FORCE_ROOT_SIGNATURE_LATEST = 0;
    D3D10_SHADER_FLAGS2_FORCE_ROOT_SIGNATURE_1_0 = (1 shl 4);
    D3D10_SHADER_FLAGS2_FORCE_ROOT_SIGNATURE_1_1 = (1 shl 5);


    IID_ID3D10ShaderReflectionType: TGUID = '{C530AD7D-9B16-4395-A979-BA2ECFF83ADD}';
    IID_ID3D10ShaderReflectionVariable: TGUID = '{1BF63C95-2650-405D-99C1-3636BD1DA0A1}';
    IID_ID3D10ShaderReflectionConstantBuffer: TGUID = '{66C66A94-DDDD-4B62-A66A-F0DA33C2B4D0}';
    IID_ID3D10ShaderReflection: TGUID = '{D40E20B6-F8F7-42AD-AB20-4BAF8F15DFAA}';


type


    TD3D10_SHADER_MACRO = TD3D_SHADER_MACRO;
    LPD3D10_SHADER_MACRO = ^TD3D10_SHADER_MACRO;
    PD3D10_SHADER_MACRO = ^TD3D10_SHADER_MACRO;


    TD3D10_SHADER_VARIABLE_CLASS = TD3D_SHADER_VARIABLE_CLASS;
    LPD3D10_SHADER_VARIABLE_CLASS = ^TD3D10_SHADER_VARIABLE_CLASS;
    PD3D10_SHADER_VARIABLE_CLASS = ^TD3D10_SHADER_VARIABLE_CLASS;

    TD3D10_SHADER_VARIABLE_FLAGS = TD3D_SHADER_VARIABLE_FLAGS;
    LPD3D10_SHADER_VARIABLE_FLAGS = ^TD3D10_SHADER_VARIABLE_FLAGS;
    PD3D10_SHADER_VARIABLE_FLAGS = ^TD3D10_SHADER_VARIABLE_FLAGS;

    TD3D10_SHADER_VARIABLE_TYPE = TD3D_SHADER_VARIABLE_TYPE;
    LPD3D10_SHADER_VARIABLE_TYPE = ^TD3D10_SHADER_VARIABLE_TYPE;
    PD3D10_SHADER_VARIABLE_TYPE = ^TD3D10_SHADER_VARIABLE_TYPE;

    TD3D10_SHADER_INPUT_FLAGS = TD3D_SHADER_INPUT_FLAGS;
    LPD3D10_SHADER_INPUT_FLAGS = ^TD3D10_SHADER_INPUT_FLAGS;
    PD3D10_SHADER_INPUT_FLAGS = ^TD3D10_SHADER_INPUT_FLAGS;

    TD3D10_SHADER_INPUT_TYPE = TD3D_SHADER_INPUT_TYPE;
    LPD3D10_SHADER_INPUT_TYPE = ^TD3D10_SHADER_INPUT_TYPE;
    PD3D10_SHADER_INPUT_TYPE = ^TD3D10_SHADER_INPUT_TYPE;

    TD3D10_SHADER_CBUFFER_FLAGS = TD3D_SHADER_CBUFFER_FLAGS;
    LPD3D10_SHADER_CBUFFER_FLAGS = ^TD3D10_SHADER_CBUFFER_FLAGS;
    PD3D10_SHADER_CBUFFER_FLAGS = ^TD3D10_SHADER_CBUFFER_FLAGS;

    TD3D10_CBUFFER_TYPE = TD3D_CBUFFER_TYPE;
    LPD3D10_CBUFFER_TYPE = ^TD3D10_CBUFFER_TYPE;
    PD3D10_CBUFFER_TYPE = ^TD3D10_CBUFFER_TYPE;

    TD3D10_NAME = TD3D_NAME;
    PD3D10_NAME = ^TD3D10_NAME;

    TD3D10_RESOURCE_RETURN_TYPE = TD3D_RESOURCE_RETURN_TYPE;
    PD3D10_RESOURCE_RETURN_TYPE = ^TD3D10_RESOURCE_RETURN_TYPE;

    TD3D10_REGISTER_COMPONENT_TYPE = TD3D_REGISTER_COMPONENT_TYPE;
    PD3D10_REGISTER_COMPONENT_TYPE = ^TD3D10_REGISTER_COMPONENT_TYPE;

    TD3D10_INCLUDE_TYPE = TD3D_INCLUDE_TYPE;
    PD3D10_INCLUDE_TYPE = ^TD3D10_INCLUDE_TYPE;


    //----------------------------------------------------------------------------
    // ID3D10ShaderReflection:
    //----------------------------------------------------------------------------

    // Structure definitions


    _D3D10_SHADER_DESC = record
        Version: UINT; // Shader version
        Creator: LPCSTR; // Creator string
        Flags: UINT; // Shader compilation/parse flags
        ConstantBuffers: UINT; // Number of constant buffers
        BoundResources: UINT; // Number of bound resources
        InputParameters: UINT; // Number of parameters in the input signature
        OutputParameters: UINT; // Number of parameters in the output signature
        InstructionCount: UINT; // Number of emitted instructions
        TempRegisterCount: UINT; // Number of temporary registers used
        TempArrayCount: UINT; // Number of temporary arrays used
        DefCount: UINT; // Number of constant defines
        DclCount: UINT; // Number of declarations (input + output)
        TextureNormalInstructions: UINT; // Number of non-categorized texture instructions
        TextureLoadInstructions: UINT; // Number of texture load instructions
        TextureCompInstructions: UINT; // Number of texture comparison instructions
        TextureBiasInstructions: UINT; // Number of texture bias instructions
        TextureGradientInstructions: UINT; // Number of texture gradient instructions
        FloatInstructionCount: UINT; // Number of floating point arithmetic instructions used
        IntInstructionCount: UINT; // Number of signed integer arithmetic instructions used
        UintInstructionCount: UINT; // Number of unsigned integer arithmetic instructions used
        StaticFlowControlCount: UINT; // Number of static flow control instructions used
        DynamicFlowControlCount: UINT; // Number of dynamic flow control instructions used
        MacroInstructionCount: UINT; // Number of macro instructions used
        ArrayInstructionCount: UINT; // Number of array instructions used
        CutInstructionCount: UINT; // Number of cut instructions used
        EmitInstructionCount: UINT; // Number of emit instructions used
        GSOutputTopology: TD3D10_PRIMITIVE_TOPOLOGY; // Geometry shader output topology
        GSMaxOutputVertexCount: UINT; // Geometry shader maximum output vertex count
    end;
    TD3D10_SHADER_DESC = _D3D10_SHADER_DESC;
    PD3D10_SHADER_DESC = ^TD3D10_SHADER_DESC;


    _D3D10_SHADER_BUFFER_DESC = record
        Name: LPCSTR; // Name of the constant buffer
        BufferType: TD3D10_CBUFFER_TYPE; // Indicates that this is a CBuffer or TBuffer
        Variables: UINT; // Number of member variables
        Size: UINT; // Size of CB (in bytes)
        uFlags: UINT; // Buffer description flags
    end;
    TD3D10_SHADER_BUFFER_DESC = _D3D10_SHADER_BUFFER_DESC;
    PD3D10_SHADER_BUFFER_DESC = ^TD3D10_SHADER_BUFFER_DESC;


    _D3D10_SHADER_VARIABLE_DESC = record
        Name: LPCSTR; // Name of the variable
        StartOffset: UINT; // Offset in constant buffer's backing store
        Size: UINT; // Size of variable (in bytes)
        uFlags: UINT; // Variable flags
        DefaultValue: LPVOID; // Raw pointer to default value
    end;
    TD3D10_SHADER_VARIABLE_DESC = _D3D10_SHADER_VARIABLE_DESC;
    PD3D10_SHADER_VARIABLE_DESC = ^TD3D10_SHADER_VARIABLE_DESC;


    _D3D10_SHADER_TYPE_DESC = record
        VariableClass: TD3D10_SHADER_VARIABLE_CLASS; // Variable class (e.g. object, matrix, etc.)
        VariableType: TD3D10_SHADER_VARIABLE_TYPE; // Variable type (e.g. float, sampler, etc.)
        Rows: UINT; // Number of rows (for matrices, 1 for other numeric, 0 if not applicable)
        Columns: UINT; // Number of columns (for vectors & matrices, 1 for other numeric, 0 if not applicable)
        Elements: UINT; // Number of elements (0 if not an array)
        Members: UINT; // Number of members (0 if not a structure)
        Offset: UINT; // Offset from the start of structure (0 if not a structure member)
    end;
    TD3D10_SHADER_TYPE_DESC = _D3D10_SHADER_TYPE_DESC;
    PD3D10_SHADER_TYPE_DESC = ^TD3D10_SHADER_TYPE_DESC;


    _D3D10_SHADER_INPUT_BIND_DESC = record
        Name: LPCSTR; // Name of the resource
        InputType: TD3D10_SHADER_INPUT_TYPE; // Type of resource (e.g. texture, cbuffer, etc.)
        BindPoint: UINT; // Starting bind point
        BindCount: UINT; // Number of contiguous bind points (for arrays)
        uFlags: UINT; // Input binding flags
        ReturnType: TD3D10_RESOURCE_RETURN_TYPE; // Return type (if texture)
        Dimension: TD3D10_SRV_DIMENSION; // Dimension (if texture)
        NumSamples: UINT; // Number of samples (0 if not MS texture)
    end;
    TD3D10_SHADER_INPUT_BIND_DESC = _D3D10_SHADER_INPUT_BIND_DESC;
    PD3D10_SHADER_INPUT_BIND_DESC = ^TD3D10_SHADER_INPUT_BIND_DESC;


    _D3D10_SIGNATURE_PARAMETER_DESC = record
        SemanticName: LPCSTR; // Name of the semantic
        SemanticIndex: UINT; // Index of the semantic
        Register: UINT; // Number of member variables
        SystemValueType: TD3D10_NAME; // A predefined system value, or D3D10_NAME_UNDEFINED if not applicable
        ComponentType: TD3D10_REGISTER_COMPONENT_TYPE; // Scalar type (e.g. uint, float, etc.)
        Mask: TBYTE; // Mask to indicate which components of the register
        ReadWriteMask: TBYTE; // Mask to indicate whether a given component is
        // always read (if this is an input signature).
        // (combination of D3D10_COMPONENT_MASK values)
    end;
    TD3D10_SIGNATURE_PARAMETER_DESC = _D3D10_SIGNATURE_PARAMETER_DESC;
    PD3D10_SIGNATURE_PARAMETER_DESC = ^TD3D10_SIGNATURE_PARAMETER_DESC;

    // ID3D10Include has been made version-neutral and moved to d3dcommon.h.
    ID3D10Include = ID3DInclude;
    LPD3D10INCLUDE = ^ID3D10Include;


    // Interface definitions


    {$interfaces corba}
    ID3D10ShaderReflectionType = interface;
    LPD3D10SHADERREFLECTIONTYPE = ^ID3D10ShaderReflectionType;

    ID3D10ShaderReflectionType = interface
        ['{C530AD7D-9B16-4395-A979-BA2ECFF83ADD}']
        function GetDesc(pDesc: PD3D10_SHADER_TYPE_DESC): HRESULT; stdcall;
        function GetMemberTypeByIndex(Index: UINT): ID3D10ShaderReflectionType; stdcall;
        function GetMemberTypeByName(Name: LPCSTR): ID3D10ShaderReflectionType; stdcall;
        function GetMemberTypeName(Index: UINT): LPCSTR; stdcall;
    end;

    {$interfaces COM}


    {$interfaces corba}
    ID3D10ShaderReflectionVariable = interface;
    LPD3D10SHADERREFLECTIONVARIABLE = ^ID3D10ShaderReflectionVariable;

    ID3D10ShaderReflectionVariable = interface
        ['{1BF63C95-2650-405d-99C1-3636BD1DA0A1}']
        function GetDesc(
        {_Out_ } pDesc: PD3D10_SHADER_VARIABLE_DESC): HRESULT; stdcall;

        function GetType(): ID3D10ShaderReflectionType; stdcall;

    end;

    {$interfaces COM}


    {$interfaces corba}
    ID3D10ShaderReflectionConstantBuffer = interface;
    LPD3D10SHADERREFLECTIONCONSTANTBUFFER = ^ID3D10ShaderReflectionConstantBuffer;

    ID3D10ShaderReflectionConstantBuffer = interface
        ['{66C66A94-DDDD-4b62-A66A-F0DA33C2B4D0}']
        function GetDesc(
        {_Out_ } pDesc: PD3D10_SHADER_BUFFER_DESC): HRESULT; stdcall;

        function GetVariableByIndex(Index: UINT): ID3D10ShaderReflectionVariable; stdcall;

        function GetVariableByName(Name: LPCSTR): ID3D10ShaderReflectionVariable; stdcall;

    end;

    {$interfaces COM}

    ID3D10ShaderReflection = interface;
    LPD3D10SHADERREFLECTION = ^ID3D10ShaderReflection;


    ID3D10ShaderReflection = interface(IUnknown)
        ['{D40E20B6-F8F7-42ad-AB20-4BAF8F15DFAA}']
        function GetDesc(
        {_Out_ } pDesc: PD3D10_SHADER_DESC): HRESULT; stdcall;

        function GetConstantBufferByIndex(Index: UINT): ID3D10ShaderReflectionConstantBuffer; stdcall;

        function GetConstantBufferByName(Name: LPCSTR): ID3D10ShaderReflectionConstantBuffer; stdcall;

        function GetResourceBindingDesc(ResourceIndex: UINT;
        {_Out_ } pDesc: PD3D10_SHADER_INPUT_BIND_DESC): HRESULT; stdcall;

        function GetInputParameterDesc(ParameterIndex: UINT;
        {_Out_ } pDesc: PD3D10_SIGNATURE_PARAMETER_DESC): HRESULT; stdcall;

        function GetOutputParameterDesc(ParameterIndex: UINT;
        {_Out_ } pDesc: PD3D10_SIGNATURE_PARAMETER_DESC): HRESULT; stdcall;

    end;


//---------------------------------------------------------------------------
// D3D10_TX_VERSION:
// --------------
// Version token used to create a procedural texture filler in effects
// Used by D3D10Fill[]TX functions
//---------------------------------------------------------------------------
function D3D10_TX_VERSION(_Major, _Minor: byte): uint32;


//////////////////////////////////////////////////////////////////////////////
// APIs //////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////


//----------------------------------------------------------------------------
// D3D10CompileShader:
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
//  SrcDataSize
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
//      Instruction set to be used when generating code.  The D3D10 entry
//      point currently supports only "vs_4_0", "ps_4_0", and "gs_4_0".
//  Flags
//      See D3D10_SHADER_xxx flags.
//  ppShader
//      Returns a buffer containing the created shader.  This buffer contains
//      the compiled shader code, as well as any embedded debug and symbol
//      table info.  (See D3D10GetShaderConstantTable)
//  ppErrorMsgs
//      Returns a buffer containing a listing of errors and warnings that were
//      encountered during the compile.  If you are running in a debugger,
//      these are the same messages you will see in your debug output.
//----------------------------------------------------------------------------


function D3D10CompileShader(
{_In_reads_bytes_(SrcDataSize) } pSrcData : LPCSTR ;
SrcDataSize : SIZE_T ;
{_In_opt_ } pFileName : LPCSTR ;
{_In_opt_ } pDefines : PD3D10_SHADER_MACRO ;
{_In_opt_ } pInclude : LPD3D10INCLUDE ;
pFunctionName : LPCSTR ;
pProfile : LPCSTR ;
Flags : UINT ;
{_Out_ }  out ppShader : ID3D10Blob  ;
{_Out_opt_ }  out ppErrorMsgs : ID3D10Blob
    ) : HRESULT;stdcall;  external D3D10_DLL;



//----------------------------------------------------------------------------
// D3D10DisassembleShader:
// ----------------------
// Takes a binary shader, and returns a buffer containing text assembly.
//
// Parameters:
//  pShader
//      Pointer to the shader byte code.
//  BytecodeLength
//      Size of the shader byte code in bytes.
//  EnableColorCode
//      Emit HTML tags for color coding the output?
//  pComments
//      Pointer to a comment string to include at the top of the shader.
//  ppDisassembly
//      Returns a buffer containing the disassembled shader.
//----------------------------------------------------------------------------

 function D3D10DisassembleShader(
{_In_reads_bytes_(BytecodeLength) } pShader : Pvoid ;
BytecodeLength : SIZE_T ;
EnableColorCode : boolean ;
{_In_opt_ } pComments : LPCSTR ;
{_Out_ }  out ppDisassembly : ID3D10Blob
    ) : HRESULT;stdcall; external D3D10_DLL;





//----------------------------------------------------------------------------
// D3D10GetPixelShaderProfile/D3D10GetVertexShaderProfile/D3D10GetGeometryShaderProfile:
// -----------------------------------------------------
// Returns the name of the HLSL profile best suited to a given device.
//
// Parameters:
//  pDevice
//      Pointer to the device in question
//----------------------------------------------------------------------------

function D3D10GetPixelShaderProfile(
{_In_ } pDevice : ID3D10Device
    ) : LPCSTR;stdcall; external D3D10_DLL;


function D3D10GetVertexShaderProfile(
{_In_ } pDevice : ID3D10Device
    ) : LPCSTR;stdcall; external D3D10_DLL;


function D3D10GetGeometryShaderProfile(
{_In_ } pDevice : ID3D10Device
    ) : LPCSTR;stdcall; external D3D10_DLL;


//----------------------------------------------------------------------------
// D3D10ReflectShader:
// ------------------
// Creates a shader reflection object that can be used to retrieve information
// about a compiled shader
//
// Parameters:
//  pShaderBytecode
//      Pointer to a compiled shader (same pointer that is passed into
//      ID3D10Device::CreateShader)
//  BytecodeLength
//      Length of the shader bytecode buffer
//  ppReflector
//      [out] Returns a ID3D10ShaderReflection object that can be used to
//      retrieve shader resource and constant buffer information
//
//----------------------------------------------------------------------------

function D3D10ReflectShader(
{_In_reads_bytes_(BytecodeLength) } pShaderBytecode : Pvoid ;
BytecodeLength : SIZE_T ;
{_Out_ }  out ppReflector : ID3D10ShaderReflection
    ) : HRESULT;stdcall;external D3D10_DLL;


//----------------------------------------------------------------------------
// D3D10PreprocessShader
// ---------------------
// Creates a shader reflection object that can be used to retrieve information
// about a compiled shader
//
// Parameters:
//  pSrcData
//      Pointer to source code
//  SrcDataSize
//      Size of source code, in bytes
//  pFileName
//      Source file name (used for error output)
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

function D3D10PreprocessShader(
{_In_reads_bytes_(SrcDataSize) } pSrcData : LPCSTR ;
SrcDataSize : SIZE_T ;
{_In_opt_ } pFileName : LPCSTR ;
{_In_opt_ } pDefines : PD3D10_SHADER_MACRO ;
{_In_opt_ } pInclude : LPD3D10INCLUDE ;
{_Out_ }  out ppShaderText : ID3D10Blob  ;
{_Out_opt_ }  out ppErrorMsgs : ID3D10Blob
    ) : HRESULT;stdcall; external D3D10_DLL;


//////////////////////////////////////////////////////////////////////////
//
// Shader blob manipulation routines
// ---------------------------------
//
// void *pShaderBytecode - a buffer containing the result of an HLSL
//  compilation.  Typically this opaque buffer contains several
//  discrete sections including the shader executable code, the input
//  signature, and the output signature.  This can typically be retrieved
//  by calling ID3D10Blob::GetBufferPointer() on the returned blob
//  from HLSL's compile APIs.
//
// UINT BytecodeLength - the length of pShaderBytecode.  This can
//  typically be retrieved by calling ID3D10Blob::GetBufferSize()
//  on the returned blob from HLSL's compile APIs.
//
// ID3D10Blob **ppSignatureBlob(s) - a newly created buffer that
//  contains only the signature portions of the original bytecode.
//  This is a copy; the original bytecode is not modified.  You may
//  specify NULL for this parameter to have the bytecode validated
//  for the presence of the corresponding signatures without actually
//  copying them and creating a new blob.
//
// Returns E_INVALIDARG if any required parameters are NULL
// Returns E_FAIL is the bytecode is corrupt or missing signatures
// Returns S_OK on success
//
//////////////////////////////////////////////////////////////////////////

function D3D10GetInputSignatureBlob(
{_In_reads_bytes_(BytecodeLength) } pShaderBytecode : Pvoid ;
BytecodeLength : SIZE_T ;
{_Out_ }  out ppSignatureBlob : ID3D10Blob
    ) : HRESULT;stdcall; external D3D10_DLL;

function D3D10GetOutputSignatureBlob(
{_In_reads_bytes_(BytecodeLength) } pShaderBytecode : Pvoid ;
BytecodeLength : SIZE_T ;
{_Out_ }  out ppSignatureBlob : ID3D10Blob
    ) : HRESULT;stdcall; external D3D10_DLL;

function D3D10GetInputAndOutputSignatureBlob
(
{_In_reads_bytes_(BytecodeLength) } pShaderBytecode : Pvoid ;
BytecodeLength : SIZE_T ;
{_Out_ }  out ppSignatureBlob : ID3D10Blob
    ) : HRESULT;stdcall; external D3D10_DLL;


//----------------------------------------------------------------------------
// D3D10GetShaderDebugInfo:
// -----------------------
// Gets shader debug info.  Debug info is generated by D3D10CompileShader and is
// embedded in the body of the shader.
//
// Parameters:
//  pShaderBytecode
//      Pointer to the function bytecode
//  BytecodeLength
//      Length of the shader bytecode buffer
//  ppDebugInfo
//      Buffer used to return debug info.  For information about the layout
//      of this buffer, see definition of D3D10_SHADER_DEBUG_INFO above.
//----------------------------------------------------------------------------

function D3D10GetShaderDebugInfo(
{_In_reads_bytes_(BytecodeLength) } pShaderBytecode : Pvoid ;
BytecodeLength : SIZE_T ;
{_Out_ }  out ppDebugInfo : ID3D10Blob
    ) : HRESULT;stdcall; external D3D10_DLL;







implementation



function D3D10_TX_VERSION(_Major, _Minor: byte): uint32;
begin
    Result := (Ord('T') shl 24) or (Ord('X') shl 16) or (_Major shl 8) or _Minor;
end;

end.
