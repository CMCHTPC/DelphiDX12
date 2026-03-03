unit DX12.D3DCompiler;

{$mode DelphiUnicode}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3DCommon,
    DX12.D3D10Effect,
    DX12.D3D11Shader;

{$Z4}
{$A4}

const

    // Current name of the DLL shipped in the same SDK as this header.
    D3DCOMPILER_DLL_W = 'd3dcompiler_47.dll';
    D3DCOMPILER_DLL_A = 'd3dcompiler_47.dll';
    D3DCOMPILER_DLL = 'd3dcompiler_47.dll';

    // Current HLSL compiler version.
    D3D_COMPILER_VERSION = 47;


    //----------------------------------------------------------------------------
    // D3DCOMPILE flags:
    // -----------------
    // D3DCOMPILE_DEBUG
    //   Insert debug file/line/type/symbol information.

    // D3DCOMPILE_SKIP_VALIDATION
    //   Do not validate the generated code against known capabilities and
    //   constraints.  This option is only recommended when compiling shaders
    //   you KNOW will work.  (ie. have compiled before without this option.)
    //   Shaders are always validated by D3D before they are set to the device.

    // D3DCOMPILE_SKIP_OPTIMIZATION
    //   Instructs the compiler to skip optimization steps during code generation.
    //   Unless you are trying to isolate a problem in your code using this option
    //   is not recommended.

    // D3DCOMPILE_PACK_MATRIX_ROW_MAJOR
    //   Unless explicitly specified, matrices will be packed in row-major order
    //   on input and output from the shader.

    // D3DCOMPILE_PACK_MATRIX_COLUMN_MAJOR
    //   Unless explicitly specified, matrices will be packed in column-major
    //   order on input and output from the shader.  This is generally more
    //   efficient, since it allows vector-matrix multiplication to be performed
    //   using a series of dot-products.

    // D3DCOMPILE_PARTIAL_PRECISION
    //   Force all computations in resulting shader to occur at partial precision.
    //   This may result in faster evaluation of shaders on some hardware.

    // D3DCOMPILE_FORCE_VS_SOFTWARE_NO_OPT
    //   Force compiler to compile against the next highest available software
    //   target for vertex shaders.  This flag also turns optimizations off,
    //   and debugging on.

    // D3DCOMPILE_FORCE_PS_SOFTWARE_NO_OPT
    //   Force compiler to compile against the next highest available software
    //   target for pixel shaders.  This flag also turns optimizations off,
    //   and debugging on.

    // D3DCOMPILE_NO_PRESHADER
    //   Disables Preshaders. Using this flag will cause the compiler to not
    //   pull out static expression for evaluation on the host cpu

    // D3DCOMPILE_AVOID_FLOW_CONTROL
    //   Hint compiler to avoid flow-control constructs where possible.

    // D3DCOMPILE_PREFER_FLOW_CONTROL
    //   Hint compiler to prefer flow-control constructs where possible.

    // D3DCOMPILE_ENABLE_STRICTNESS
    //   By default, the HLSL/Effect compilers are not strict on deprecated syntax.
    //   Specifying this flag enables the strict mode. Deprecated syntax may be
    //   removed in a future release, and enabling syntax is a good way to make
    //   sure your shaders comply to the latest spec.

    // D3DCOMPILE_ENABLE_BACKWARDS_COMPATIBILITY
    //   This enables older shaders to compile to 4_0 targets.

    // D3DCOMPILE_DEBUG_NAME_FOR_SOURCE
    //   This enables a debug name to be generated based on source information.
    //   It requires D3DCOMPILE_DEBUG to be set, and is exclusive with
    //   D3DCOMPILE_DEBUG_NAME_FOR_BINARY.

    // D3DCOMPILE_DEBUG_NAME_FOR_BINARY
    //   This enables a debug name to be generated based on compiled information.
    //   It requires D3DCOMPILE_DEBUG to be set, and is exclusive with
    //   D3DCOMPILE_DEBUG_NAME_FOR_SOURCE.

    //----------------------------------------------------------------------------

    D3DCOMPILE_DEBUG = (1 shl 0);
    D3DCOMPILE_SKIP_VALIDATION = (1 shl 1);
    D3DCOMPILE_SKIP_OPTIMIZATION = (1 shl 2);
    D3DCOMPILE_PACK_MATRIX_ROW_MAJOR = (1 shl 3);
    D3DCOMPILE_PACK_MATRIX_COLUMN_MAJOR = (1 shl 4);
    D3DCOMPILE_PARTIAL_PRECISION = (1 shl 5);
    D3DCOMPILE_FORCE_VS_SOFTWARE_NO_OPT = (1 shl 6);
    D3DCOMPILE_FORCE_PS_SOFTWARE_NO_OPT = (1 shl 7);
    D3DCOMPILE_NO_PRESHADER = (1 shl 8);
    D3DCOMPILE_AVOID_FLOW_CONTROL = (1 shl 9);
    D3DCOMPILE_PREFER_FLOW_CONTROL = (1 shl 10);
    D3DCOMPILE_ENABLE_STRICTNESS = (1 shl 11);
    D3DCOMPILE_ENABLE_BACKWARDS_COMPATIBILITY = (1 shl 12);
    D3DCOMPILE_IEEE_STRICTNESS = (1 shl 13);
    D3DCOMPILE_OPTIMIZATION_LEVEL0 = (1 shl 14);
    D3DCOMPILE_OPTIMIZATION_LEVEL1 = 0;
    D3DCOMPILE_OPTIMIZATION_LEVEL2 = ((1 shl 14) or (1 shl 15));
    D3DCOMPILE_OPTIMIZATION_LEVEL3 = (1 shl 15);
    D3DCOMPILE_RESERVED16 = (1 shl 16);
    D3DCOMPILE_RESERVED17 = (1 shl 17);
    D3DCOMPILE_WARNINGS_ARE_ERRORS = (1 shl 18);
    D3DCOMPILE_RESOURCES_MAY_ALIAS = (1 shl 19);
    D3DCOMPILE_ENABLE_UNBOUNDED_DESCRIPTOR_TABLES = (1 shl 20);
    D3DCOMPILE_ALL_RESOURCES_BOUND = (1 shl 21);
    D3DCOMPILE_DEBUG_NAME_FOR_SOURCE = (1 shl 22);
    D3DCOMPILE_DEBUG_NAME_FOR_BINARY = (1 shl 23);



    //----------------------------------------------------------------------------
    // D3DCOMPILE_EFFECT flags:
    // -------------------------------------
    // These flags are passed in when creating an effect, and affect
    // either compilation behavior or runtime effect behavior

    // D3DCOMPILE_EFFECT_CHILD_EFFECT
    //   Compile this .fx file to a child effect. Child effects have no
    //   initializers for any shared values as these are initialied in the
    //   master effect (pool).

    // D3DCOMPILE_EFFECT_ALLOW_SLOW_OPS
    //   By default, performance mode is enabled.  Performance mode
    //   disallows mutable state objects by preventing non-literal
    //   expressions from appearing in state object definitions.
    //   Specifying this flag will disable the mode and allow for mutable
    //   state objects.

    //----------------------------------------------------------------------------

    D3DCOMPILE_EFFECT_CHILD_EFFECT = (1 shl 0);
    D3DCOMPILE_EFFECT_ALLOW_SLOW_OPS = (1 shl 1);

    //----------------------------------------------------------------------------
    // D3DCOMPILE Flags2:
    // -----------------
    // Root signature flags. (passed in Flags2)
    D3DCOMPILE_FLAGS2_FORCE_ROOT_SIGNATURE_LATEST = 0;
    D3DCOMPILE_FLAGS2_FORCE_ROOT_SIGNATURE_1_0 = (1 shl 4);
    D3DCOMPILE_FLAGS2_FORCE_ROOT_SIGNATURE_1_1 = (1 shl 5);


    //----------------------------------------------------------------------------
    // D3DCompile:
    // ----------
    // Compile source text into bytecode appropriate for the given target.
    //----------------------------------------------------------------------------
    // D3D_COMPILE_STANDARD_FILE_INCLUDE can be passed for pInclude in any
    // API and indicates that a simple default include handler should be
    // used.  The include handler will include files relative to the
    // current directory and files relative to the directory of the initial source
    // file.  When used with APIs like D3DCompile pSourceName must be a
    // file name and the initial relative directory will be derived from it.

    D3D_COMPILE_STANDARD_FILE_INCLUDE = PID3DInclude(UINT_PTR(1));


    D3DCOMPILE_SECDATA_MERGE_UAV_SLOTS = $00000001;
    D3DCOMPILE_SECDATA_PRESERVE_TEMPLATE_SLOTS = $00000002;
    D3DCOMPILE_SECDATA_REQUIRE_TEMPLATE_MATCH = $00000004;


    //----------------------------------------------------------------------------
    // D3DDisassemble:
    // ----------------------
    // Takes a binary shader and returns a buffer containing text assembly.
    //----------------------------------------------------------------------------

    D3D_DISASM_ENABLE_COLOR_CODE = $00000001;
    D3D_DISASM_ENABLE_DEFAULT_VALUE_PRINTS = $00000002;
    D3D_DISASM_ENABLE_INSTRUCTION_NUMBERING = $00000004;
    D3D_DISASM_ENABLE_INSTRUCTION_CYCLE = $00000008;
    D3D_DISASM_DISABLE_DEBUG_INFO = $00000010;
    D3D_DISASM_ENABLE_INSTRUCTION_OFFSET = $00000020;
    D3D_DISASM_INSTRUCTION_ONLY = $00000040;
    D3D_DISASM_PRINT_HEX_LITERALS = $00000080;



    //----------------------------------------------------------------------------
    // D3DGetTraceInstructionOffsets:
    // -----------------------
    // Determines byte offsets for instructions within a shader blob.
    // This information is useful for going between trace instruction
    // indices and byte offsets that are used in debug information.
    //----------------------------------------------------------------------------


    D3D_GET_INST_OFFSETS_INCLUDE_NON_EXECUTABLE = $00000001;

    //----------------------------------------------------------------------------
    // D3DCompressShaders:
    // -----------------------
    // Compresses a set of shaders into a more compact form.
    //----------------------------------------------------------------------------
    D3D_COMPRESS_SHADER_KEEP_ALL_PARTS = $00000001;

type
    REFIID = ^TGUID;


    //----------------------------------------------------------------------------
    // D3DStripShader:
    // -----------------------
    // Removes unwanted blobs from a compilation result
    //----------------------------------------------------------------------------

    TD3DCOMPILER_STRIP_FLAGS = (
        D3DCOMPILER_STRIP_REFLECTION_DATA = $00000001,
        D3DCOMPILER_STRIP_DEBUG_INFO = $00000002,
        D3DCOMPILER_STRIP_TEST_BLOBS = $00000004,
        D3DCOMPILER_STRIP_PRIVATE_DATA = $00000008,
        D3DCOMPILER_STRIP_ROOT_SIGNATURE = $00000010,
        D3DCOMPILER_STRIP_FORCE_DWORD = $7fffffff);

    PD3DCOMPILER_STRIP_FLAGS = ^TD3DCOMPILER_STRIP_FLAGS;



    //----------------------------------------------------------------------------
    // D3DGetBlobPart:
    // -----------------------
    // Extracts information from a compilation result.
    //----------------------------------------------------------------------------

    TD3D_BLOB_PART = (
        D3D_BLOB_INPUT_SIGNATURE_BLOB,
        D3D_BLOB_OUTPUT_SIGNATURE_BLOB,
        D3D_BLOB_INPUT_AND_OUTPUT_SIGNATURE_BLOB,
        D3D_BLOB_PATCH_CONSTANT_SIGNATURE_BLOB,
        D3D_BLOB_ALL_SIGNATURE_BLOB,
        D3D_BLOB_DEBUG_INFO,
        D3D_BLOB_LEGACY_SHADER,
        D3D_BLOB_XNA_PREPASS_SHADER,
        D3D_BLOB_XNA_SHADER,
        D3D_BLOB_PDB,
        D3D_BLOB_PRIVATE_DATA,
        D3D_BLOB_ROOT_SIGNATURE,
        D3D_BLOB_DEBUG_NAME,
        // Test parts are only produced by special compiler versions and so
        // are usually not present in shaders.
        D3D_BLOB_TEST_ALTERNATE_SHADER = $8000,
        D3D_BLOB_TEST_COMPILE_DETAILS,
        D3D_BLOB_TEST_COMPILE_PERF,
        D3D_BLOB_TEST_COMPILE_REPORT);

    PD3D_BLOB_PART = ^TD3D_BLOB_PART;

    //----------------------------------------------------------------------------
    // D3DCompressShaders:
    // -----------------------
    // Compresses a set of shaders into a more compact form.
    //----------------------------------------------------------------------------

    _D3D_SHADER_DATA = record
        pBytecode: LPCVOID;
        BytecodeLength: SIZE_T;
    end;
    TD3D_SHADER_DATA = _D3D_SHADER_DATA;
    PD3D_SHADER_DATA = ^TD3D_SHADER_DATA;




pD3DCompile = function(
pSrcData : LPCVOID ;
SrcDataSize : SIZE_T ;
pFileName : LPCSTR ;
pDefines : PD3D_SHADER_MACRO ;
pInclude : ID3DInclude ;
pEntrypoint : LPCSTR ;
pTarget : LPCSTR ;
Flags1 : UINT ;
Flags2 : UINT ;
ppCode : PID3DBlob ;
ppErrorMsgs: PID3DBlob
    ) : HRESULT;stdcall;



pD3DPreprocess = function(
pSrcData : LPCVOID ;
SrcDataSize : SIZE_T ;
pFileName : LPCSTR ;
pDefines : PD3D_SHADER_MACRO ;
pInclude : ID3DInclude ;
ppCodeText : PID3DBlob ;
ppErrorMsgs : PID3DBlob
    ) : HRESULT;stdcall;



pD3DDisassemble = function(
{_In_reads_bytes_(SrcDataSize) } pSrcData : LPCVOID ;
{_In_ } SrcDataSize : SIZE_T ;
{_In_ } Flags : UINT ;
{_In_opt_ } szComments : LPCSTR ;
{_Out_ }  out ppDisassembly : ID3DBlob
    ) : HRESULT;stdcall;




    //////////////////////////////////////////////////////////////////////////////
    // APIs //////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    //----------------------------------------------------------------------------
    // D3DReadFileToBlob:
    // -----------------
    // Simple helper routine to read a file on disk into memory
    // for passing to other routines in this API.
    //----------------------------------------------------------------------------




function D3DReadFileToBlob(
    {_In_ } pFileName: LPCWSTR;
    {_Out_ }  out ppContents: ID3DBlob): HRESULT; stdcall; external D3DCOMPILER_DLL;


//----------------------------------------------------------------------------
// D3DWriteBlobToFile:
// ------------------
// Simple helper routine to write a memory blob to a file on disk.
//----------------------------------------------------------------------------

function D3DWriteBlobToFile(
    {_In_ } pBlob: ID3DBlob;
    {_In_ } pFileName: LPCWSTR;
    {_In_ } bOverwrite: boolean): HRESULT; stdcall; external D3DCOMPILER_DLL;




function D3DCompile(
    {_In_reads_bytes_(SrcDataSize) } pSrcData: LPCVOID;
    {_In_ } SrcDataSize: SIZE_T;
    {_In_opt_ } pSourceName: LPCSTR;
    {_In_reads_opt_(_Inexpressible_(pDefines->Name != NULL)) } pDefines: PD3D_SHADER_MACRO;
    {_In_opt_ } pInclude: ID3DInclude;
    {_In_opt_ } pEntrypoint: LPCSTR;
    {_In_ } pTarget: LPCSTR;
    {_In_ } Flags1: UINT;
    {_In_ } Flags2: UINT;
    {_Out_ }  out ppCode: ID3DBlob;
    {_Always_(_Outptr_opt_result_maybenull_) }  out ppErrorMsgs: ID3DBlob): HRESULT; stdcall; external D3DCOMPILER_DLL;




function D3DCompile2(
    {_In_reads_bytes_(SrcDataSize) } pSrcData: LPCVOID;
    {_In_ } SrcDataSize: SIZE_T;
    {_In_opt_ } pSourceName: LPCSTR;
    {_In_reads_opt_(_Inexpressible_(pDefines->Name != NULL)) } pDefines: PD3D_SHADER_MACRO;
    {_In_opt_ } pInclude: ID3DInclude;
    {_In_ } pEntrypoint: LPCSTR;
    {_In_ } pTarget: LPCSTR;
    {_In_ } Flags1: UINT;
    {_In_ } Flags2: UINT;
    {_In_ } SecondaryDataFlags: UINT;
    {_In_reads_bytes_opt_(SecondaryDataSize) } pSecondaryData: LPCVOID;
    {_In_ } SecondaryDataSize: SIZE_T;
    {_Out_ }  out ppCode: ID3DBlob;
    {_Always_(_Outptr_opt_result_maybenull_) }  out ppErrorMsgs: ID3DBlob): HRESULT; stdcall; external D3DCOMPILER_DLL;


function D3DCompileFromFile(
    {_In_ } pFileName: LPCWSTR;
    {_In_reads_opt_(_Inexpressible_(pDefines->Name != NULL)) } pDefines: PD3D_SHADER_MACRO;
    {_In_opt_ } pInclude: ID3DInclude;
    {_In_ } pEntrypoint: LPCSTR;
    {_In_ } pTarget: LPCSTR;
    {_In_ } Flags1: UINT;
    {_In_ } Flags2: UINT;
    {_Out_ }  out ppCode: ID3DBlob;
    {_Always_(_Outptr_opt_result_maybenull_) }  ppErrorMsgs: PID3DBlob=nil): HRESULT; stdcall; external D3DCOMPILER_DLL;


//----------------------------------------------------------------------------
// D3DPreprocess:
// -------------
// Process source text with the compiler's preprocessor and return
// the resulting text.
//----------------------------------------------------------------------------

function D3DPreprocess(
    {_In_reads_bytes_(SrcDataSize) } pSrcData: LPCVOID;
    {_In_ } SrcDataSize: SIZE_T;
    {_In_opt_ } pSourceName: LPCSTR;
    {_In_opt_ } pDefines: PD3D_SHADER_MACRO;
    {_In_opt_ } pInclude: ID3DInclude;
    {_Out_ }  out ppCodeText: ID3DBlob;
    {_Always_(_Outptr_opt_result_maybenull_) }  out ppErrorMsgs: ID3DBlob): HRESULT; stdcall; external D3DCOMPILER_DLL;



//----------------------------------------------------------------------------
// D3DGetDebugInfo:
// -----------------------
// Gets shader debug info.  Debug info is generated by D3DCompile and is
// embedded in the body of the shader.
//----------------------------------------------------------------------------

function D3DGetDebugInfo(
    {_In_reads_bytes_(SrcDataSize) } pSrcData: LPCVOID;
    {_In_ } SrcDataSize: SIZE_T;
    {_Out_ }  out ppDebugInfo: ID3DBlob): HRESULT; stdcall; external D3DCOMPILER_DLL;


//----------------------------------------------------------------------------
// D3DReflect:
// ----------
// Shader code contains metadata that can be inspected via the
// reflection APIs.
//----------------------------------------------------------------------------

function D3DReflect(
    {_In_reads_bytes_(SrcDataSize) } pSrcData: LPCVOID;
    {_In_ } SrcDataSize: SIZE_T;
    {_In_ } pInterface: REFIID;
    {_Out_ }  out ppReflector): HRESULT; stdcall; external D3DCOMPILER_DLL;


//----------------------------------------------------------------------------
// D3DReflectLibrary:
// ----------
// Library code contains metadata that can be inspected via the library
// reflection APIs.
//----------------------------------------------------------------------------

function D3DReflectLibrary(
    {__in_bcount(SrcDataSize)}  pSrcData: LPCVOID;
    { __in}  SrcDataSize: SIZE_T;
    {__in}  riid: REFIID;
    {__out } ppReflector: LPVOID): HRESULT; stdcall; external D3DCOMPILER_DLL;


//----------------------------------------------------------------------------
// D3DDisassemble:
// ----------------------
// Takes a binary shader and returns a buffer containing text assembly.
//----------------------------------------------------------------------------



function D3DDisassemble(
    {_In_reads_bytes_(SrcDataSize) } pSrcData: LPCVOID;
    {_In_ } SrcDataSize: SIZE_T;
    {_In_ } Flags: UINT;
    {_In_opt_ } szComments: LPCSTR;
    {_Out_ }  out ppDisassembly: ID3DBlob): HRESULT; stdcall; external D3DCOMPILER_DLL;




function D3DDisassembleRegion(
    {_In_reads_bytes_(SrcDataSize) } pSrcData: LPCVOID;
    {_In_ } SrcDataSize: SIZE_T;
    {_In_ } Flags: UINT;
    {_In_opt_ } szComments: LPCSTR;
    {_In_ } StartByteOffset: SIZE_T;
    {_In_ } NumInsts: SIZE_T;
    {_Out_opt_ } pFinishByteOffset: PSIZE_T;
    {_Out_ }  out ppDisassembly: ID3DBlob): HRESULT; stdcall; external D3DCOMPILER_DLL;


//----------------------------------------------------------------------------
// Shader linking and Function Linking Graph (FLG) APIs
//----------------------------------------------------------------------------
function D3DCreateLinker(
    {__out } out ppLinker: ID3D11Linker): HRESULT; stdcall; external D3DCOMPILER_DLL;


function D3DLoadModule(
    {_In_ } pSrcData: LPCVOID;
    {_In_ } cbSrcDataSize: SIZE_T;
    {_Out_ } out ppModule: ID3D11Module): HRESULT; stdcall; external D3DCOMPILER_DLL;


function D3DCreateFunctionLinkingGraph(
    {_In_ } uFlags: UINT;
    {_Out_ } out ppFunctionLinkingGraph: ID3D11FunctionLinkingGraph): HRESULT; stdcall; external D3DCOMPILER_DLL;


//----------------------------------------------------------------------------
// D3DGetTraceInstructionOffsets:
// -----------------------
// Determines byte offsets for instructions within a shader blob.
// This information is useful for going between trace instruction
// indices and byte offsets that are used in debug information.
//----------------------------------------------------------------------------



function D3DGetTraceInstructionOffsets(
    {_In_reads_bytes_(SrcDataSize) } pSrcData: LPCVOID;
    {_In_ } SrcDataSize: SIZE_T;
    {_In_ } Flags: UINT;
    {_In_ } StartInstIndex: SIZE_T;
    {_In_ } NumInsts: SIZE_T;
    {_Out_writes_to_opt_(NumInsts, min(NumInsts, *pTotalInsts)) } pOffsets: PSIZE_T;
    {_Out_opt_ } pTotalInsts: PSIZE_T): HRESULT; stdcall; external D3DCOMPILER_DLL;


//----------------------------------------------------------------------------
// D3DGetInputSignatureBlob:
// -----------------------
// Retrieve the input signature from a compilation result.
//----------------------------------------------------------------------------

function D3DGetInputSignatureBlob(
    {_In_reads_bytes_(SrcDataSize) } pSrcData: LPCVOID;
    {_In_ } SrcDataSize: SIZE_T;
    {_Out_ }  out ppSignatureBlob: ID3DBlob): HRESULT; stdcall; external D3DCOMPILER_DLL;


//----------------------------------------------------------------------------
// D3DGetOutputSignatureBlob:
// -----------------------
// Retrieve the output signature from a compilation result.
//----------------------------------------------------------------------------

function D3DGetOutputSignatureBlob(
    {_In_reads_bytes_(SrcDataSize) } pSrcData: LPCVOID;
    {_In_ } SrcDataSize: SIZE_T;
    {_Out_ }  out ppSignatureBlob: ID3DBlob): HRESULT; stdcall; external D3DCOMPILER_DLL;


//----------------------------------------------------------------------------
// D3DGetInputAndOutputSignatureBlob:
// -----------------------
// Retrieve the input and output signatures from a compilation result.
//----------------------------------------------------------------------------

function D3DGetInputAndOutputSignatureBlob(
    {_In_reads_bytes_(SrcDataSize) } pSrcData: LPCVOID;
    {_In_ } SrcDataSize: SIZE_T;
    {_Out_ }  out ppSignatureBlob: ID3DBlob): HRESULT; stdcall; external D3DCOMPILER_DLL;




//----------------------------------------------------------------------------
// D3DStripShader:
// -----------------------
// Removes unwanted blobs from a compilation result
//----------------------------------------------------------------------------


function D3DStripShader(
{_In_reads_bytes_(BytecodeLength) } pShaderBytecode : LPCVOID ;
{_In_ } BytecodeLength : SIZE_T ;
{_In_ } uStripFlags : UINT ;
{_Out_ }  out ppStrippedBlob : ID3DBlob
    ) : HRESULT;stdcall;  external D3DCOMPILER_DLL;


//----------------------------------------------------------------------------
// D3DGetBlobPart:
// -----------------------
// Extracts information from a compilation result.
//----------------------------------------------------------------------------


function D3DGetBlobPart(
{_In_reads_bytes_(SrcDataSize) } pSrcData : LPCVOID ;
{_In_ } SrcDataSize : SIZE_T ;
{_In_ } Part : TD3D_BLOB_PART ;
{_In_ } Flags : UINT ;
{_Out_ }  out ppPart : ID3DBlob
    ) : HRESULT;stdcall; external D3DCOMPILER_DLL;


//----------------------------------------------------------------------------
// D3DSetBlobPart:
// -----------------------
// Update information in a compilation result.
//----------------------------------------------------------------------------

function D3DSetBlobPart(
{_In_reads_bytes_(SrcDataSize) } pSrcData : LPCVOID ;
{_In_ } SrcDataSize : SIZE_T ;
{_In_ } Part : TD3D_BLOB_PART ;
{_In_ } Flags : UINT ;
{_In_reads_bytes_(PartSize) } pPart : LPCVOID ;
{_In_ } PartSize : SIZE_T ;
{_Out_ }  out ppNewShader : ID3DBlob
    ) : HRESULT;stdcall; external D3DCOMPILER_DLL;


//----------------------------------------------------------------------------
// D3DCreateBlob:
// -----------------------
// Create an ID3DBlob instance.
//----------------------------------------------------------------------------

function D3DCreateBlob(
{_In_ } Size : SIZE_T ;
{_Out_ }  out ppBlob : ID3DBlob
    ) : HRESULT;stdcall; external D3DCOMPILER_DLL;


//----------------------------------------------------------------------------
// D3DCompressShaders:
// -----------------------
// Compresses a set of shaders into a more compact form.
//----------------------------------------------------------------------------


function D3DCompressShaders(
{_In_ } uNumShaders : UINT ;
{_In_reads_(uNumShaders) } pShaderData : PD3D_SHADER_DATA ;
{_In_ } uFlags : UINT ;
{_Out_ }  out ppCompressedData : ID3DBlob
    ) : HRESULT;stdcall; external D3DCOMPILER_DLL;


//----------------------------------------------------------------------------
// D3DDecompressShaders:
// -----------------------
// Decompresses one or more shaders from a compressed set.
//----------------------------------------------------------------------------

function D3DDecompressShaders(
{_In_reads_bytes_(SrcDataSize) } pSrcData : LPCVOID ;
{_In_ } SrcDataSize : SIZE_T ;
{_In_ } uNumShaders : UINT ;
{_In_ } uStartIndex : UINT ;
{_In_reads_opt_(uNumShaders) } pIndices : PUINT ;
{_In_ } uFlags : UINT ;
{_Out_writes_(uNumShaders) }  out ppShaders : ID3DBlob  ;
{_Out_opt_ } pTotalShaders : PUINT
    ) : HRESULT;stdcall; external D3DCOMPILER_DLL;




//----------------------------------------------------------------------------
// D3DDisassemble10Effect:
// -----------------------
// Takes a D3D10 effect interface and returns a
// buffer containing text assembly.
//----------------------------------------------------------------------------

function D3DDisassemble10Effect(
{_In_ } pEffect : ID3D10Effect ;
{_In_ } Flags : UINT ;
{_Out_ }  out ppDisassembly : ID3DBlob
    ) : HRESULT;stdcall;external D3DCOMPILER_DLL;





implementation

end.
