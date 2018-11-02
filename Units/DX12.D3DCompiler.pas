unit DX12.D3DCompiler;

{$IFDEF FPC}
{$MODE delphi}{$H+}
{$ENDIF}

interface

{$Z4}

uses
    Windows, Classes, SysUtils, DX12.D3DCommon, DX12.D3D11, DX12.D3D10;

const
    D3DCOMPILER_DLL = 'd3dcompiler_47.dll';
    D3D_COMPILER_VERSION = 47; // Current HLSL compiler version.

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
    D3DCOMPILE_OPTIMIZATION_LEVEL2 = (1 shl 14) or (1 shl 15);
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


    D3DCOMPILE_SECDATA_MERGE_UAV_SLOTS = $00000001;
    D3DCOMPILE_SECDATA_PRESERVE_TEMPLATE_SLOTS = $00000002;
    D3DCOMPILE_SECDATA_REQUIRE_TEMPLATE_MATCH = $00000004;

    D3D_DISASM_ENABLE_COLOR_CODE = $00000001;
    D3D_DISASM_ENABLE_DEFAULT_VALUE_PRINTS = $00000002;
    D3D_DISASM_ENABLE_INSTRUCTION_NUMBERING = $00000004;
    D3D_DISASM_ENABLE_INSTRUCTION_CYCLE = $00000008;
    D3D_DISASM_DISABLE_DEBUG_INFO = $00000010;
    D3D_DISASM_ENABLE_INSTRUCTION_OFFSET = $00000020;
    D3D_DISASM_INSTRUCTION_ONLY = $00000040;
    D3D_DISASM_PRINT_HEX_LITERALS = $00000080;


    D3D_COMPRESS_SHADER_KEEP_ALL_PARTS = $00000001;

    D3D_GET_INST_OFFSETS_INCLUDE_NON_EXECUTABLE = $00000001;

    // D3D_COMPILE_STANDARD_FILE_INCLUDE :  ID3DInclude = UINT_PTR(1);
    D3D_COMPILE_STANDARD_FILE_INCLUDE: UINT_PTR = UINT_PTR(1);

type

    PSIZE_T = ^SIZE_T;

    TD3DCOMPILER_STRIP_FLAGS = (
        D3DCOMPILER_STRIP_REFLECTION_DATA = 1,
        D3DCOMPILER_STRIP_DEBUG_INFO = 2,
        D3DCOMPILER_STRIP_TEST_BLOBS = 4,
        D3DCOMPILER_STRIP_PRIVATE_DATA = 8,
        D3DCOMPILER_STRIP_ROOT_SIGNATURE = $00000010,
        D3DCOMPILER_STRIP_FORCE_DWORD = $7fffffff);

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

    TD3D_SHADER_DATA = record
        pBytecode: pointer;
        BytecodeLength: SIZE_T;
    end;
    PD3D_SHADER_DATA = ^TD3D_SHADER_DATA;

//----------------------------------------------------------------------------
// D3DReadFileToBlob:
// -----------------
// Simple helper routine to read a file on disk into memory
// for passing to other routines in this API.
//----------------------------------------------------------------------------
function D3DReadFileToBlob(pFileName: PWideChar; out ppContents: ID3DBlob): HResult; stdcall; external D3DCOMPILER_DLL;

//----------------------------------------------------------------------------
// D3DWriteBlobToFile:
// ------------------
// Simple helper routine to write a memory blob to a file on disk.
//----------------------------------------------------------------------------
function D3DWriteBlobToFile(pBlob: ID3DBlob; pFileName: PWideChar; bOverwrite: boolean): HResult;
    stdcall; external D3DCOMPILER_DLL;


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

function D3DCompile(pSrcData: Pointer; SrcDataSize: SIZE_T; pSourceName: PAnsiChar; pDefines: PD3D_SHADER_MACRO;
    pInclude: ID3DInclude; pEntrypoint: PAnsiChar; pTarget: PAnsiChar; Flags1: UINT; Flags2: UINT; out ppCode: ID3DBlob;
    out ppErrorMsgs: ID3DBlob): HResult; stdcall; external D3DCOMPILER_DLL;


function D3DCompile2(pSrcData: Pointer; SrcDataSize: SIZE_T; pSourceName: PAnsiChar; pDefines: PD3D_SHADER_MACRO;
    pInclude: ID3DInclude; pEntrypoint: PAnsiChar; pTarget: PAnsiChar; Flags1: UINT; Flags2: UINT; SecondaryDataFlags: UINT;
    pSecondaryData: POinter; SecondaryDataSize: SIZE_T; out ppCode: ID3DBlob; out ppErrorMsgs: ID3DBlob): HResult;
    stdcall; external D3DCOMPILER_DLL;


function D3DCompileFromFile(pFileName: PWideChar; pDefines: PD3D_SHADER_MACRO; pInclude: ID3DInclude; pEntrypoint: PAnsiChar;
    pTarget: PAnsiChar; Flags1: UINT; Flags2: UINT; out ppCode: ID3DBlob; out ppErrorMsgs: ID3DBlob): HResult;
    stdcall; external D3DCOMPILER_DLL;


function D3DPreprocess(pSrcData: Pointer; SrcDataSize: SIZE_T; pSourceName: PAnsiChar; pDefines: PD3D_SHADER_MACRO;
    pInclude: ID3DInclude; out ppCodeText: ID3DBlob; out ppErrorMsgs: ID3DBlob): HResult; stdcall; external D3DCOMPILER_DLL;


function D3DGetDebugInfo(pSrcData: Pointer; SrcDataSize: SIZE_T; out ppDebugInfo: ID3DBlob): HResult;
    stdcall; external D3DCOMPILER_DLL;


function D3DReflect(pSrcData: Pointer; SrcDataSize: SIZE_T; pInterface: TGUID; out ppReflector: pointer): HResult;
    stdcall; external D3DCOMPILER_DLL;


function D3DReflectLibrary(pSrcData: pointer; SrcDataSize: SIZE_T; REFIID: TGUID; out ppReflector: Pointer): HResult;
    stdcall; external D3DCOMPILER_DLL;


function D3DDisassemble(pSrcData: Pointer; SrcDataSize: SIZE_T; Flags: UINT; szComments: PAnsiChar; out ppDisassembly: ID3DBlob): HResult;
    stdcall; external D3DCOMPILER_DLL;


function D3DDisassembleRegion(pSrcData: Pointer; SrcDataSize: SIZE_T; Flags: UINT; szComments: PAnsiChar;
    StartByteOffset: SIZE_T; NumInsts: SIZE_T; out pFinishByteOffset: SIZE_T; out ppDisassembly: ID3DBlob): HResult;
    stdcall; external D3DCOMPILER_DLL;


function D3DCreateLinker(out ppLinker: ID3D11Linker): HResult; stdcall; external D3DCOMPILER_DLL;

function D3DLoadModule(pSrcData: Pointer; cbSrcDataSize: SIZE_T; out ppModule: ID3D11Module): HResult;
    stdcall; external D3DCOMPILER_DLL;

function D3DCreateFunctionLinkingGraph(uFlags: UINT; out ppFunctionLinkingGraph: ID3D11FunctionLinkingGraph): HResult;
    stdcall; external D3DCOMPILER_DLL;

function D3DDisassemble10Effect(pEffect: ID3D10Effect; Flags: UINT; out ppDisassembly: ID3DBlob): HResult; stdcall; external D3DCOMPILER_DLL;

function D3DGetTraceInstructionOffsets(pSrcData: Pointer; SrcDataSize: SIZE_T; Flags: UINT; StartInstIndex: SIZE_T;
    NumInsts: SIZE_T; out pOffsets: PSIZE_T; out pTotalInsts: SIZE_T): HResult; stdcall; external D3DCOMPILER_DLL;

function D3DGetInputSignatureBlob(pSrcData: Pointer; SrcDataSize: SIZE_T; out ppSignatureBlob: ID3DBlob): HResult;
    stdcall; external D3DCOMPILER_DLL;


function D3DGetOutputSignatureBlob(pSrcData: Pointer; SrcDataSize: SIZE_T; out ppSignatureBlob: ID3DBlob): HResult;
    stdcall; external D3DCOMPILER_DLL;


function D3DGetInputAndOutputSignatureBlob(pSrcData: Pointer; SrcDataSize: SIZE_T; out ppSignatureBlob: ID3DBlob): HResult;
    stdcall; external D3DCOMPILER_DLL;


function D3DStripShader(pShaderBytecode: Pointer; BytecodeLength: SIZE_T; uStripFlags: UINT; out ppStrippedBlob: ID3DBlob): HResult;
    stdcall; external D3DCOMPILER_DLL;


function D3DGetBlobPart(pSrcData: Pointer; SrcDataSize: SIZE_T; Part: TD3D_BLOB_PART; Flags: UINT; out ppPart: ID3DBlob): HResult;
    stdcall; external D3DCOMPILER_DLL;


function D3DSetBlobPart(pSrcData: Pointer; SrcDataSize: SIZE_T; Part: TD3D_BLOB_PART; Flags: UINT; pPart: Pointer;
    PartSize: SIZE_T; out ppNewShader: ID3DBlob): HResult; stdcall; external D3DCOMPILER_DLL;


function D3DCreateBlob(Size: SIZE_T; out ppBlob: ID3DBlob): HResult; stdcall; external D3DCOMPILER_DLL;


function D3DCompressShaders(uNumShaders: UINT; pShaderData: PD3D_SHADER_DATA; uFlags: UINT; out ppCompressedData: ID3DBlob): HResult;
    stdcall; external D3DCOMPILER_DLL;


function D3DDecompressShaders(pSrcData: Pointer; SrcDataSize: SIZE_T; uNumShaders: UINT; uStartIndex: UINT;
    pIndices: PUINT; uFlags: UINT; out ppShaders: PID3DBlob; out pTotalShaders: UINT): HResult; stdcall; external D3DCOMPILER_DLL;




implementation

end.
