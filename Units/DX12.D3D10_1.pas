unit DX12.D3D10_1;

{$IFDEF FPC}
{$MODE delphi}{$H+}
{$ENDIF}



interface

{$Z4}

uses
    Windows, Classes, SysUtils, DX12.D3D10, DX12.D3DCommon,
    DX12.DXGI;

const
    DLL_D3D10_1 = 'd3d10_1.dll';

    D3D10_1_DEFAULT_SAMPLE_MASK = ($ffffffff);

    D3D10_1_FLOAT16_FUSED_TOLERANCE_IN_ULP = (0.6);
    D3D10_1_FLOAT32_TO_INTEGER_TOLERANCE_IN_ULP = (0.6);
    D3D10_1_GS_INPUT_REGISTER_COUNT = (32);

    D3D10_1_IA_VERTEX_INPUT_RESOURCE_SLOT_COUNT = (32);

    D3D10_1_IA_VERTEX_INPUT_STRUCTURE_ELEMENTS_COMPONENTS = (128);
    D3D10_1_IA_VERTEX_INPUT_STRUCTURE_ELEMENT_COUNT = (32);
    D3D10_1_PS_OUTPUT_MASK_REGISTER_COMPONENTS = (1);
    D3D10_1_PS_OUTPUT_MASK_REGISTER_COMPONENT_BIT_COUNT = (32);
    D3D10_1_PS_OUTPUT_MASK_REGISTER_COUNT = (1);
    D3D10_1_SHADER_MAJOR_VERSION = (4);
    D3D10_1_SHADER_MINOR_VERSION = (1);
    D3D10_1_SO_BUFFER_MAX_STRIDE_IN_BYTES = (2048);
    D3D10_1_SO_BUFFER_MAX_WRITE_WINDOW_IN_BYTES = (256);
    D3D10_1_SO_BUFFER_SLOT_COUNT = (4);
    D3D10_1_SO_MULTIPLE_BUFFER_ELEMENTS_PER_BUFFER = (1);
    D3D10_1_SO_SINGLE_BUFFER_COMPONENT_LIMIT = (64);
    D3D10_1_STANDARD_VERTEX_ELEMENT_COUNT = (32);
    D3D10_1_SUBPIXEL_FRACTIONAL_BIT_COUNT = (8);
    D3D10_1_VS_INPUT_REGISTER_COUNT = (32);
    D3D10_1_VS_OUTPUT_REGISTER_COUNT = (32);

    D3D10_1_SDK_VERSION = (0 + $20);

    IID_ID3D10BlendState1: TGUID = '{EDAD8D99-8A35-4d6d-8566-2EA276CDE161}';
    IID_ID3D10ShaderResourceView1: TGUID = '{9B7E4C87-342C-4106-A19F-4F2704F689F0}';
    IID_ID3D10Device1: TGUID = '{9B7E4C8F-342C-4106-A19F-4F2704F689F0}';
    IID_ID3D10ShaderReflection1: TGUID = '{C3457783-A846-47CE-9520-CEA6F66E7447}';

type

    TD3D10_FEATURE_LEVEL1 = (
        D3D10_FEATURE_LEVEL_10_0 = $a000,
        D3D10_FEATURE_LEVEL_10_1 = $a100,
        D3D10_FEATURE_LEVEL_9_1 = $9100,
        D3D10_FEATURE_LEVEL_9_2 = $9200,
        D3D10_FEATURE_LEVEL_9_3 = $9300
        );

    TD3D10_RENDER_TARGET_BLEND_DESC1 = record

        BlendEnable: longbool;
        SrcBlend: TD3D10_BLEND;
        DestBlend: TD3D10_BLEND;
        BlendOp: TD3D10_BLEND_OP;
        SrcBlendAlpha: TD3D10_BLEND;
        DestBlendAlpha: TD3D10_BLEND;
        BlendOpAlpha: TD3D10_BLEND_OP;
        RenderTargetWriteMask: UINT8;
    end;

    TD3D10_BLEND_DESC1 = record
        AlphaToCoverageEnable: longbool;
        IndependentBlendEnable: longbool;
        RenderTarget: array[0..7] of TD3D10_RENDER_TARGET_BLEND_DESC1;
    end;

    PD3D10_BLEND_DESC1 = ^TD3D10_BLEND_DESC1;


    ID3D10BlendState1 = interface(ID3D10BlendState)
        ['{EDAD8D99-8A35-4d6d-8566-2EA276CDE161}']
        procedure GetDesc1(out pDesc: TD3D10_BLEND_DESC1); stdcall;
    end;

    TD3D10_TEXCUBE_ARRAY_SRV1 = record
        MostDetailedMip: UINT;
        MipLevels: UINT;
        First2DArrayFace: UINT;
        NumCubes: UINT;
    end;

    TD3D10_SRV_DIMENSION1 = TD3D_SRV_DIMENSION;

    TD3D10_SHADER_RESOURCE_VIEW_DESC1 = record

        Format: TDXGI_FORMAT;
        ViewDimension: TD3D10_SRV_DIMENSION1;
        case integer of

            0: (Buffer: TD3D10_BUFFER_SRV;);
            1: (Texture1D: TD3D10_TEX1D_SRV;);
            2: (Texture1DArray: TD3D10_TEX1D_ARRAY_SRV;);
            3: (Texture2D: TD3D10_TEX2D_SRV;);
            4: (Texture2DArray: TD3D10_TEX2D_ARRAY_SRV;);
            5: (Texture2DMS: TD3D10_TEX2DMS_SRV;);
            6: (Texture2DMSArray: TD3D10_TEX2DMS_ARRAY_SRV;);
            7: (Texture3D: TD3D10_TEX3D_SRV;);
            8: (TextureCube: TD3D10_TEXCUBE_SRV;);
            9: (TextureCubeArray: TD3D10_TEXCUBE_ARRAY_SRV1;);
    end;

    PD3D10_SHADER_RESOURCE_VIEW_DESC1 = ^TD3D10_SHADER_RESOURCE_VIEW_DESC1;


    ID3D10ShaderResourceView1 = interface(ID3D10ShaderResourceView)
        ['{9B7E4C87-342C-4106-A19F-4F2704F689F0}']
        procedure GetDesc1(out pDesc: TD3D10_SHADER_RESOURCE_VIEW_DESC1); stdcall;

    end;


    TD3D10_STANDARD_MULTISAMPLE_QUALITY_LEVELS = (
        D3D10_STANDARD_MULTISAMPLE_PATTERN = $ffffffff,
        D3D10_CENTER_MULTISAMPLE_PATTERN = $fffffffe
        );


    ID3D10Device1 = interface(ID3D10Device)
        ['{9B7E4C8F-342C-4106-A19F-4F2704F689F0}']
        function CreateShaderResourceView1(pResource: ID3D10Resource; pDesc: PD3D10_SHADER_RESOURCE_VIEW_DESC1;
            out ppSRView: ID3D10ShaderResourceView1): HResult; stdcall;
        function CreateBlendState1(pBlendStateDesc: PD3D10_BLEND_DESC1; out ppBlendState: ID3D10BlendState1): HResult; stdcall;
        function GetFeatureLevel(): TD3D10_FEATURE_LEVEL1; stdcall;

    end;


    TD3D10_SHADER_DEBUG_REGTYPE = (
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

    TD3D10_SHADER_DEBUG_SCOPETYPE = (
        D3D10_SHADER_DEBUG_SCOPE_GLOBAL,
        D3D10_SHADER_DEBUG_SCOPE_BLOCK,
        D3D10_SHADER_DEBUG_SCOPE_FORLOOP,
        D3D10_SHADER_DEBUG_SCOPE_STRUCT,
        D3D10_SHADER_DEBUG_SCOPE_FUNC_PARAMS,
        D3D10_SHADER_DEBUG_SCOPE_STATEBLOCK,
        D3D10_SHADER_DEBUG_SCOPE_NAMESPACE,
        D3D10_SHADER_DEBUG_SCOPE_ANNOTATION,
        D3D10_SHADER_DEBUG_SCOPE_FORCE_DWORD = $7fffffff);

    TD3D10_SHADER_DEBUG_VARTYPE = (
        D3D10_SHADER_DEBUG_VAR_VARIABLE,
        D3D10_SHADER_DEBUG_VAR_FUNCTION,
        D3D10_SHADER_DEBUG_VAR_FORCE_DWORD = $7fffffff);


    TD3D10_SHADER_DEBUG_TOKEN_INFO = record
        OffsetFile: UINT;    // offset into file list
        Line: UINT;    // line #
        Column: UINT;  // column #
        TokenLength: UINT;
        TokenId: UINT; // offset to LPCSTR of length TokenLength in string datastore
    end;

    // Variable list
    TD3D10_SHADER_DEBUG_VAR_INFO = record
        TokenId: UINT;
        _Type: TD3D10_SHADER_VARIABLE_TYPE;
        _Register: UINT;
        Component: UINT;
        ScopeVar: UINT;
        ScopeVarOffset: UINT;
    end;

    TD3D10_SHADER_DEBUG_INPUT_INFO = record
        VarIndex: UINT;
        InitialRegisterSet: TD3D10_SHADER_DEBUG_REGTYPE;
        InitialBank: UINT;
        InitialRegister: UINT;
        InitialComponent: UINT;
        InitialValue: UINT;
    end;

    TD3D10_SHADER_DEBUG_SCOPEVAR_INFO = record
        // Index into variable token
        TokenId: UINT;
        VarType: TD3D10_SHADER_DEBUG_VARTYPE; // variable or function (different namespaces)
        _Class: TD3D10_SHADER_VARIABLE_CLASS;
        Rows: UINT;          // number of rows (matrices)
        Columns: UINT;       // number of columns (vectors and matrices)
        StructMemberScope: UINT;
        uArrayIndices: UINT;    // a[3][2][1] has 3 indices
        ArrayElements: UINT; // a[3][2][1] has {3, 2, 1}
        ArrayStrides: UINT;  // a[3][2][1] has {2, 1, 1}
        uVariables: UINT;
        uFirstVariable: UINT;
    end;

    // scope data, this maps variable names to debug variables (useful for the watch window)
    TD3D10_SHADER_DEBUG_SCOPE_INFO = record
        ScopeType: TD3D10_SHADER_DEBUG_SCOPETYPE;
        Name: UINT;         // offset to name of scope in strings list
        uNameLen: UINT;     // length of name string
        uVariables: UINT;
        VariableData: UINT; // Offset to UINT[uVariables] indexing the Scope Variable list
    end;

    // instruction outputs
    TD3D10_SHADER_DEBUG_OUTPUTVAR = record
        VarIndex: UINT;
        uValueMin, uValueMax: UINT;
        iValueMin, iValueMax: integer;
        fValueMin, fValueMax: single;
        bNaNPossible, bInfPossible: longbool;
    end;

    TD3D10_SHADER_DEBUG_OUTPUTREG_INFO = record
        OutputRegisterSet: TD3D10_SHADER_DEBUG_REGTYPE;
        OutputReg: UINT;
        TempArrayReg: UINT;
        OutputComponents: array[0..3] of UINT;
        OutputVars: array [0..3] of TD3D10_SHADER_DEBUG_OUTPUTVAR;
        IndexReg: UINT;
        IndexComp: UINT;
    end;

    // per instruction data
    TD3D10_SHADER_DEBUG_INST_INFO = record
        Id: UINT; // Which instruction this is in the bytecode
        Opcode: UINT; // instruction type
        uOutputs: UINT;
        pOutputs: array [0..1] of TD3D10_SHADER_DEBUG_OUTPUTREG_INFO;
        TokenId: UINT;
        NestingLevel: UINT;
        Scopes: UINT;
        ScopeInfo: UINT; // Offset to UINT[uScopes] specifying indices of the ScopeInfo Array
        AccessedVars: UINT;
        AccessedVarsInfo: UINT; // Offset to UINT[AccessedVars] specifying indices of the ScopeVariableInfo Array
    end;

    TD3D10_SHADER_DEBUG_FILE_INFO = record
        FileName: UINT;    // Offset to LPCSTR for file name
        FileNameLen: UINT; // Length of file name
        FileData: UINT;    // Offset to LPCSTR of length FileLen
        FileLen: UINT;     // Length of file
    end;

    TD3D10_SHADER_DEBUG_INFO = record
        Size: UINT;                             // sizeof(D3D10_SHADER_DEBUG_INFO)
        Creator: UINT;                          // Offset to LPCSTR for compiler version
        EntrypointName: UINT;                   // Offset to LPCSTR for Entry point name
        ShaderTarget: UINT;                     // Offset to LPCSTR for shader target
        CompileFlags: UINT;                     // flags used to compile
        Files: UINT;                            // number of included files
        FileInfo: UINT;                         // Offset to D3D10_SHADER_DEBUG_FILE_INFO[Files]
        Instructions: UINT;                     // number of instructions
        InstructionInfo: UINT;                  // Offset to D3D10_SHADER_DEBUG_INST_INFO[Instructions]
        Variables: UINT;                        // number of variables
        VariableInfo: UINT;                     // Offset to D3D10_SHADER_DEBUG_VAR_INFO[Variables]
        InputVariables: UINT;                   // number of variables to initialize before running
        InputVariableInfo: UINT;                // Offset to D3D10_SHADER_DEBUG_INPUT_INFO[InputVariables]
        Tokens: UINT;                           // number of tokens to initialize
        TokenInfo: UINT;                        // Offset to D3D10_SHADER_DEBUG_TOKEN_INFO[Tokens]
        Scopes: UINT;                           // number of scopes
        ScopeInfo: UINT;                        // Offset to D3D10_SHADER_DEBUG_SCOPE_INFO[Scopes]
        ScopeVariables: UINT;                   // number of variables declared
        ScopeVariableInfo: UINT;                // Offset to D3D10_SHADER_DEBUG_SCOPEVAR_INFO[Scopes]
        UintOffset: UINT;                       // Offset to the UINT datastore, all UINT offsets are from this offset
        StringOffset: UINT;                     // Offset to the string datastore, all string offsets are from this offset
    end;


    ID3D10ShaderReflection1 = interface(IUnknown)
        ['{C3457783-A846-47CE-9520-CEA6F66E7447}']
        function GetDesc(out pDesc: TD3D10_SHADER_DESC): HResult; stdcall;
        function GetConstantBufferByIndex(Index: UINT): ID3D10ShaderReflectionConstantBuffer; stdcall;
        function GetConstantBufferByName(Name: PAnsiChar): ID3D10ShaderReflectionConstantBuffer; stdcall;
        function GetResourceBindingDesc(ResourceIndex: UINT; out pDesc: TD3D10_SHADER_INPUT_BIND_DESC): HResult; stdcall;
        function GetInputParameterDesc(ParameterIndex: UINT; out pDesc: TD3D10_SIGNATURE_PARAMETER_DESC): HResult; stdcall;
        function GetOutputParameterDesc(ParameterIndex: UINT; out pDesc: TD3D10_SIGNATURE_PARAMETER_DESC): HResult; stdcall;
        function GetVariableByName(Name: PAnsiChar): ID3D10ShaderReflectionVariable; stdcall;
        function GetResourceBindingDescByName(Name: PAnsiChar; out pDesc: TD3D10_SHADER_INPUT_BIND_DESC): HResult; stdcall;
        function GetMovInstructionCount(out pCount: UINT): HResult; stdcall;
        function GetMovcInstructionCount(out pCount: UINT): HResult; stdcall;
        function GetConversionInstructionCount(out pCount: UINT): HResult; stdcall;
        function GetBitwiseInstructionCount(out pCount: UINT): HResult; stdcall;
        function GetGSInputPrimitive(out pPrim: TD3D10_PRIMITIVE): HResult; stdcall;
        function IsLevel9Shader(out pbLevel9Shader: longbool): HResult; stdcall;
        function IsSampleFrequencyShader(out pbSampleFrequency: longbool): HResult; stdcall;
    end;


function D3D10CreateDevice1(pAdapter: IDXGIAdapter; DriverType: TD3D10_DRIVER_TYPE; Software: HMODULE; Flags: UINT;
    HardwareLevel: TD3D10_FEATURE_LEVEL1; SDKVersion: UINT; out ppDevice: ID3D10Device1): HResult; stdcall; external DLL_D3D10_1;


function D3D10CreateDeviceAndSwapChain1(pAdapter: IDXGIAdapter; DriverType: TD3D10_DRIVER_TYPE; Software: HMODULE;
    Flags: UINT; HardwareLevel: TD3D10_FEATURE_LEVEL1; SDKVersion: UINT; pSwapChainDesc: PDXGI_SWAP_CHAIN_DESC;
    out ppSwapChain: IDXGISwapChain; out ppDevice: ID3D10Device1): HResult; stdcall; external DLL_D3D10_1;


implementation

end.
