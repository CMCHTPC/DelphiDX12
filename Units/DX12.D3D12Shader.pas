
{$REGION 'Copyright (C) CMC Development Team'}
{ **************************************************************************
  Copyright (C) 2015 CMC Development Team

  CMC is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 2 of the License, or
  (at your option) any later version.

  CMC is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with CMC. If not, see <http://www.gnu.org/licenses/>.

  Commercial use of this header files is prohibited. Especially the
  use by Embarcadero.

  ************************************************************************** }

{ **************************************************************************
  Additional Copyright (C) for this modul:

  Copyright (c) Microsoft Corporation.  All rights reserved.
  File name:  D3D12Shader.h
  Content:    D3D12 Shader Types and APIs
  Hader Version: 10.0.10075.0

  ************************************************************************** }
{$ENDREGION}
{$REGION 'Notes'}
{ **************************************************************************
  Use the DirectX libaries from CMC. They are NOT based on the JSB headers !

  Version 0.9 2015.06.04 - First release
  ************************************************************************** }

unit DX12.D3D12Shader;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

{$Z4}

uses
    Windows, Classes, SysUtils, DX12.D3DCommon;

const
    IID_ID3D12ShaderReflectionType: TGUID = '{E913C351-783D-48CA-A1D1-4F306284AD56}';
    IID_ID3D12ShaderReflectionVariable: TGUID = '{8337A8A6-A216-444A-B2F4-314733A73AEA}';
    IID_ID3D12ShaderReflectionConstantBuffer: TGUID = '{C59598B4-48B3-4869-B9B1-B1618B14A8B7}';
    IID_ID3D12ShaderReflection: TGUID = '{5A58797D-A72C-478D-8BA2-EFC6B0EFE88E}';
    IID_ID3D12FunctionReflection: TGUID = '{1108795C-2772-4BA9-B2A8-D464DC7E2799}';
    IID_ID3D12LibraryReflection: TGUID = '{8E349D19-54DB-4A56-9DC9-119D87BDB804}';
    IID_ID3D12FunctionParameterReflection: TGUID = '{EC25F42D-7006-4F2B-B33E-02CC3375733F}';

const

    // Slot ID for library function return
    D3D_RETURN_PARAMETER_INDEX = -1;


    D3D_SHADER_REQUIRES_DOUBLES = $00000001;
    D3D_SHADER_REQUIRES_EARLY_DEPTH_STENCIL = $00000002;
    D3D_SHADER_REQUIRES_UAVS_AT_EVERY_STAGE = $00000004;
    D3D_SHADER_REQUIRES_64_UAVS = $00000008;
    D3D_SHADER_REQUIRES_MINIMUM_PRECISION = $00000010;
    D3D_SHADER_REQUIRES_11_1_DOUBLE_EXTENSIONS = $00000020;
    D3D_SHADER_REQUIRES_11_1_SHADER_EXTENSIONS = $00000040;
    D3D_SHADER_REQUIRES_LEVEL_9_COMPARISON_FILTERING = $00000080;
    D3D_SHADER_REQUIRES_TILED_RESOURCES = $00000100;
    D3D_SHADER_REQUIRES_STENCIL_REF = $00000200;
    D3D_SHADER_REQUIRES_INNER_COVERAGE = $00000400;
    D3D_SHADER_REQUIRES_TYPED_UAV_LOAD_ADDITIONAL_FORMATS = $00000800;
    D3D_SHADER_REQUIRES_ROVS = $00001000;
    D3D_SHADER_REQUIRES_VIEWPORT_AND_RT_ARRAY_INDEX_FROM_ANY_SHADER_FEEDING_RASTERIZER = $00002000;


type

    TD3D12_SHADER_VERSION_TYPE = (
        D3D12_SHVER_PIXEL_SHADER = 0,
        D3D12_SHVER_VERTEX_SHADER = 1,
        D3D12_SHVER_GEOMETRY_SHADER = 2,
        // D3D11 Shaders
        D3D12_SHVER_HULL_SHADER = 3,
        D3D12_SHVER_DOMAIN_SHADER = 4,
        D3D12_SHVER_COMPUTE_SHADER = 5,
        D3D12_SHVER_RESERVED0 = $FFF0);


    TD3D12_RESOURCE_RETURN_TYPE = TD3D_RESOURCE_RETURN_TYPE;
    TD3D12_CBUFFER_TYPE = TD3D_CBUFFER_TYPE;


    TD3D12_SIGNATURE_PARAMETER_DESC = record
        SemanticName: PAnsiChar;   // Name of the semantic
        SemanticIndex: UINT;  // Index of the semantic
        _Register: UINT;       // Number of member variables
        SystemValueType: TD3D_NAME;// A predefined system value, or D3D_NAME_UNDEFINED if not applicable
        ComponentType: TD3D_REGISTER_COMPONENT_TYPE;  // Scalar type (e.g. uint, float, etc.)
        Mask: byte;           // Mask to indicate which components of the register
        // are used (combination of D3D10_COMPONENT_MASK values)
        ReadWriteMask: byte;  // Mask to indicate whether a given component is
        // never written (if this is an output signature) or
        // always read (if this is an input signature).
        // (combination of D3D_MASK_* values)
        Stream: UINT;         // Stream index
        MinPrecision: TD3D_MIN_PRECISION;   // Minimum desired interpolation precision
    end;


    TD3D12_SHADER_BUFFER_DESC = record
        Name: PAnsiChar;           // Name of the constant buffer
        _Type: TD3D_CBUFFER_TYPE;           // Indicates type of buffer content
        Variables: UINT;      // Number of member variables
        Size: UINT;           // Size of CB (in bytes)
        uFlags: UINT;         // Buffer description flags
    end;

    TD3D12_SHADER_VARIABLE_DESC = record
        Name: PAnsiChar;           // Name of the variable
        StartOffset: UINT;    // Offset in constant buffer's backing store
        Size: UINT;           // Size of variable (in bytes)
        uFlags: UINT;         // Variable flags
        DefaultValue: Pointer;   // Raw pointer to default value
        StartTexture: UINT;   // First texture index (or -1 if no textures used)
        TextureSize: UINT;    // Number of texture slots possibly used.
        StartSampler: UINT;   // First sampler index (or -1 if no textures used)
        SamplerSize: UINT;    // Number of sampler slots possibly used.
    end;

    TD3D12_SHADER_TYPE_DESC = record
        _Class: TD3D_SHADER_VARIABLE_CLASS;          // Variable class (e.g. object, matrix, etc.)
        _Type: TD3D_SHADER_VARIABLE_TYPE;           // Variable type (e.g. float, sampler, etc.)
        Rows: UINT;           // Number of rows (for matrices, 1 for other numeric, 0 if not applicable)
        Columns: UINT;        // Number of columns (for vectors & matrices, 1 for other numeric, 0 if not applicable)
        Elements: UINT;       // Number of elements (0 if not an array)
        Members: UINT;        // Number of members (0 if not a structure)
        Offset: UINT;         // Offset from the start of structure (0 if not a structure member)
        Name: PAnsiChar;           // Name of type, can be NULL
    end;


    TD3D12_TESSELLATOR_DOMAIN = TD3D_TESSELLATOR_DOMAIN;

    TD3D12_TESSELLATOR_PARTITIONING = TD3D_TESSELLATOR_PARTITIONING;

    TD3D12_TESSELLATOR_OUTPUT_PRIMITIVE = TD3D_TESSELLATOR_OUTPUT_PRIMITIVE;


    TD3D12_SHADER_DESC = record
        Version: UINT;                     // Shader version
        Creator: PAnsiChar;                     // Creator string
        Flags: UINT;                       // Shader compilation/parse flags

        ConstantBuffers: UINT;             // Number of constant buffers
        BoundResources: UINT;              // Number of bound resources
        InputParameters: UINT;             // Number of parameters in the input signature
        OutputParameters: UINT;            // Number of parameters in the output signature

        InstructionCount: UINT;            // Number of emitted instructions
        TempRegisterCount: UINT;           // Number of temporary registers used
        TempArrayCount: UINT;              // Number of temporary arrays used
        DefCount: UINT;                    // Number of constant defines
        DclCount: UINT;                    // Number of declarations (input + output)
        TextureNormalInstructions: UINT;   // Number of non-categorized texture instructions
        TextureLoadInstructions: UINT;     // Number of texture load instructions
        TextureCompInstructions: UINT;     // Number of texture comparison instructions
        TextureBiasInstructions: UINT;     // Number of texture bias instructions
        TextureGradientInstructions: UINT; // Number of texture gradient instructions
        FloatInstructionCount: UINT;       // Number of floating point arithmetic instructions used
        IntInstructionCount: UINT;         // Number of signed integer arithmetic instructions used
        UintInstructionCount: UINT;        // Number of unsigned integer arithmetic instructions used
        StaticFlowControlCount: UINT;      // Number of static flow control instructions used
        DynamicFlowControlCount: UINT;     // Number of dynamic flow control instructions used
        MacroInstructionCount: UINT;       // Number of macro instructions used
        ArrayInstructionCount: UINT;       // Number of array instructions used
        CutInstructionCount: UINT;         // Number of cut instructions used
        EmitInstructionCount: UINT;        // Number of emit instructions used
        GSOutputTopology: TD3D_PRIMITIVE_TOPOLOGY;            // Geometry shader output topology
        GSMaxOutputVertexCount: UINT;      // Geometry shader maximum output vertex count
        InputPrimitive: TD3D_PRIMITIVE;              // GS/HS input primitive
        PatchConstantParameters: UINT;     // Number of parameters in the patch constant signature
        cGSInstanceCount: UINT;            // Number of Geometry shader instances
        cControlPoints: UINT;              // Number of control points in the HS->DS stage
        HSOutputPrimitive: TD3D_TESSELLATOR_OUTPUT_PRIMITIVE;  // Primitive output by the tessellator
        HSPartitioning: TD3D_TESSELLATOR_PARTITIONING;         // Partitioning mode of the tessellator
        TessellatorDomain: TD3D_TESSELLATOR_DOMAIN;           // Domain of the tessellator (quad, tri, isoline)
        // instruction counts
        cBarrierInstructions: UINT;                           // Number of barrier instructions in a compute shader
        cInterlockedInstructions: UINT;                       // Number of interlocked instructions
        cTextureStoreInstructions: UINT;                      // Number of texture writes
    end;

    TD3D12_SHADER_INPUT_BIND_DESC = record
        Name: PAnsiChar;           // Name of the resource
        _Type: TD3D_SHADER_INPUT_TYPE;           // Type of resource (e.g. texture, cbuffer, etc.)
        BindPoint: UINT;      // Starting bind point
        BindCount: UINT;      // Number of contiguous bind points (for arrays)

        uFlags: UINT;         // Input binding flags
        ReturnType: TD3D_RESOURCE_RETURN_TYPE;     // Return type (if texture)
        Dimension: TD3D_SRV_DIMENSION;      // Dimension (if texture)
        NumSamples: UINT;     // Number of samples (0 if not MS texture)
        Space: UINT;          // Register space
        uID: UINT;                                   // Range ID in the bytecode
    end;


    TD3D12_LIBRARY_DESC = record
        Creator: PAnsiChar;           // The name of the originator of the library.
        Flags: UINT;             // Compilation flags.
        FunctionCount: UINT;     // Number of functions exported from the library.
    end;

    TD3D12_FUNCTION_DESC = record
        Version: UINT;                     // Shader version
        Creator: PAnsiChar;                     // Creator string
        Flags: UINT;                       // Shader compilation/parse flags

        ConstantBuffers: UINT;             // Number of constant buffers
        BoundResources: UINT;              // Number of bound resources

        InstructionCount: UINT;            // Number of emitted instructions
        TempRegisterCount: UINT;           // Number of temporary registers used
        TempArrayCount: UINT;              // Number of temporary arrays used
        DefCount: UINT;                    // Number of constant defines
        DclCount: UINT;                    // Number of declarations (input + output)
        TextureNormalInstructions: UINT;   // Number of non-categorized texture instructions
        TextureLoadInstructions: UINT;     // Number of texture load instructions
        TextureCompInstructions: UINT;     // Number of texture comparison instructions
        TextureBiasInstructions: UINT;     // Number of texture bias instructions
        TextureGradientInstructions: UINT; // Number of texture gradient instructions
        FloatInstructionCount: UINT;       // Number of floating point arithmetic instructions used
        IntInstructionCount: UINT;         // Number of signed integer arithmetic instructions used
        UintInstructionCount: UINT;        // Number of unsigned integer arithmetic instructions used
        StaticFlowControlCount: UINT;      // Number of static flow control instructions used
        DynamicFlowControlCount: UINT;     // Number of dynamic flow control instructions used
        MacroInstructionCount: UINT;       // Number of macro instructions used
        ArrayInstructionCount: UINT;       // Number of array instructions used
        MovInstructionCount: UINT;         // Number of mov instructions used
        MovcInstructionCount: UINT;        // Number of movc instructions used
        ConversionInstructionCount: UINT;  // Number of type conversion instructions used
        BitwiseInstructionCount: UINT;     // Number of bitwise arithmetic instructions used
        MinFeatureLevel: TD3D_FEATURE_LEVEL;             // Min target of the function byte code
        RequiredFeatureFlags: UINT64;        // Required feature flags

        Name: PAnsiChar;                        // Function name
        FunctionParameterCount: INT32;      // Number of logical parameters in the function signature (not including return)
        HasReturn: boolean;                   // TRUE, if function returns a value, false - it is a subroutine
        Has10Level9VertexShader: boolean;     // TRUE, if there is a 10L9 VS blob
        Has10Level9PixelShader: boolean;      // TRUE, if there is a 10L9 PS blob
    end;

    TD3D12_PARAMETER_DESC = record
        Name: PAnsiChar;               // Parameter name.
        SemanticName: PAnsiChar;       // Parameter semantic name (+index).
        _Type: TD3D_SHADER_VARIABLE_TYPE;               // Element type.
        _Class: TD3D_SHADER_VARIABLE_CLASS;              // Scalar/Vector/Matrix.
        Rows: UINT;               // Rows are for matrix parameters.
        Columns: UINT;            // Components or Columns in matrix.
        InterpolationMode: TD3D_INTERPOLATION_MODE;  // Interpolation mode.
        Flags: TD3D_PARAMETER_FLAGS;              // Parameter modifiers.

        FirstInRegister: UINT;    // The first input register for this parameter.
        FirstInComponent: UINT;   // The first input register component for this parameter.
        FirstOutRegister: UINT;   // The first output register for this parameter.
        FirstOutComponent: UINT;  // The first output register component for this parameter.
    end;


    {$IFDEF FPC}
    {$interfaces corba}

    ID3D12ShaderReflectionConstantBuffer = interface;
    ID3D12ShaderReflectionVariable = interface;
    ID3D12FunctionParameterReflection = interface;

    ID3D12ShaderReflectionType = interface
        ['{E913C351-783D-48CA-A1D1-4F306284AD56}']
        function GetDesc(out pDesc: TD3D12_SHADER_TYPE_DESC): HResult; stdcall;
        function GetMemberTypeByIndex(Index: UINT): ID3D12ShaderReflectionType; stdcall;
        function GetMemberTypeByName(Name: PAnsiChar): ID3D12ShaderReflectionType; stdcall;
        function GetMemberTypeName(Index: UINT): PAnsiChar; stdcall;
        function IsEqual(pType: ID3D12ShaderReflectionType): HResult; stdcall;
        function GetSubType(): ID3D12ShaderReflectionType; stdcall;
        function GetBaseClass(): ID3D12ShaderReflectionType; stdcall;
        function GetNumInterfaces(): UINT; stdcall;
        function GetInterfaceByIndex(uIndex: UINT): ID3D12ShaderReflectionType; stdcall;
        function IsOfType(pType: ID3D12ShaderReflectionType): HResult; stdcall;
        function ImplementsInterface(pBase: ID3D12ShaderReflectionType): HResult; stdcall;
    end;


    ID3D12ShaderReflectionVariable = interface
        ['{8337A8A6-A216-444A-B2F4-314733A73AEA}']
        function GetDesc(out pDesc: TD3D12_SHADER_VARIABLE_DESC): HResult; stdcall;
        function GetType(): ID3D12ShaderReflectionType; stdcall;
        function GetBuffer(): ID3D12ShaderReflectionConstantBuffer; stdcall;
        function GetInterfaceSlot(uArrayIndex: UINT): UINT; stdcall;
    end;


    ID3D12ShaderReflectionConstantBuffer = interface
        ['{C59598B4-48B3-4869-B9B1-B1618B14A8B7}']
        function GetDesc(out pDesc: TD3D12_SHADER_BUFFER_DESC): HResult; stdcall;
        function GetVariableByIndex(Index: UINT): ID3D12ShaderReflectionVariable; stdcall;
        function GetVariableByName(Name: PAnsiChar): ID3D12ShaderReflectionVariable; stdcall;
    end;


    ID3D12FunctionReflection = interface
        ['{1108795C-2772-4BA9-B2A8-D464DC7E2799}']
        function GetDesc(out pDesc: TD3D12_FUNCTION_DESC): HResult; stdcall;
        function GetConstantBufferByIndex(BufferIndex: UINT): ID3D12ShaderReflectionConstantBuffer; stdcall;
        function GetConstantBufferByName(Name: PAnsiChar): ID3D12ShaderReflectionConstantBuffer; stdcall;
        function GetResourceBindingDesc(ResourceIndex: UINT; out pDesc: TD3D12_SHADER_INPUT_BIND_DESC): HResult;
            stdcall;
        function GetVariableByName(Name: PAnsiChar): ID3D12ShaderReflectionVariable; stdcall;
        function GetResourceBindingDescByName(Name: PAnsiChar; out pDesc: TD3D12_SHADER_INPUT_BIND_DESC): HResult; stdcall;
        // Use D3D_RETURN_PARAMETER_INDEX to get description of the return value.
        function GetFunctionParameter(ParameterIndex: INT32): ID3D12FunctionParameterReflection; stdcall;
    end;


    ID3D12FunctionParameterReflection = interface
        ['{EC25F42D-7006-4F2B-B33E-02CC3375733F}']
        function GetDesc(out pDesc: TD3D12_PARAMETER_DESC): HResult; stdcall;
    end;


    {$interfaces com}
    {$ELSE}


    ID3D12ShaderReflectionConstantBuffer = class;
    ID3D12ShaderReflectionVariable = class;
    ID3D12FunctionParameterReflection = class;

    ID3D12ShaderReflectionType = class // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
        function GetDesc(out pDesc: TD3D12_SHADER_TYPE_DESC): HResult; virtual; stdcall; abstract;
        function GetMemberTypeByIndex(Index: UINT): ID3D12ShaderReflectionType; virtual; stdcall; abstract;
        function GetMemberTypeByName(Name: PAnsiChar): ID3D12ShaderReflectionType; virtual; stdcall; abstract;
        function GetMemberTypeName(Index: UINT): PAnsiChar; virtual; stdcall; abstract;
        function IsEqual(pType: ID3D12ShaderReflectionType): HResult; virtual; stdcall; abstract;
        function GetSubType(): ID3D12ShaderReflectionType; virtual; stdcall; abstract;
        function GetBaseClass(): ID3D12ShaderReflectionType; virtual; stdcall; abstract;
        function GetNumInterfaces(): UINT; virtual; stdcall; abstract;
        function GetInterfaceByIndex(uIndex: UINT): ID3D12ShaderReflectionType; virtual; stdcall; abstract;
        function IsOfType(pType: ID3D12ShaderReflectionType): HResult; virtual; stdcall; abstract;
        function ImplementsInterface(pBase: ID3D12ShaderReflectionType): HResult; virtual; stdcall; abstract;
    end;


    ID3D12ShaderReflectionVariable = class // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
        function GetDesc(out pDesc: TD3D12_SHADER_VARIABLE_DESC): HResult; virtual; stdcall; abstract;
        function GetType(): ID3D12ShaderReflectionType; virtual; stdcall; abstract;
        function GetBuffer(): ID3D12ShaderReflectionConstantBuffer; virtual; stdcall; abstract;
        function GetInterfaceSlot(uArrayIndex: UINT): UINT; virtual; stdcall; abstract;
    end;


    ID3D12ShaderReflectionConstantBuffer = class // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
        function GetDesc(out pDesc: TD3D12_SHADER_BUFFER_DESC): HResult; virtual; stdcall; abstract;
        function GetVariableByIndex(Index: UINT): ID3D12ShaderReflectionVariable; virtual; stdcall; abstract;
        function GetVariableByName(Name: PAnsiChar): ID3D12ShaderReflectionVariable; virtual; stdcall; abstract;
    end;


    ID3D12FunctionReflection = class // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
        function GetDesc(out pDesc: TD3D12_FUNCTION_DESC): HResult; virtual; stdcall; abstract;
        function GetConstantBufferByIndex(BufferIndex: UINT): ID3D12ShaderReflectionConstantBuffer; virtual; stdcall; abstract;
        function GetConstantBufferByName(Name: PAnsiChar): ID3D12ShaderReflectionConstantBuffer; virtual; stdcall; abstract;
        function GetResourceBindingDesc(ResourceIndex: UINT; out pDesc: TD3D12_SHADER_INPUT_BIND_DESC): HResult;
            virtual; stdcall; abstract;
        function GetVariableByName(Name: PAnsiChar): ID3D12ShaderReflectionVariable; virtual; stdcall; abstract;
        function GetResourceBindingDescByName(Name: PAnsiChar; out pDesc: TD3D12_SHADER_INPUT_BIND_DESC): HResult; virtual; stdcall; abstract;
        // Use D3D_RETURN_PARAMETER_INDEX to get description of the return value.
        function GetFunctionParameter(ParameterIndex: INT32): ID3D12FunctionParameterReflection; virtual; stdcall; abstract;
    end;


    ID3D12FunctionParameterReflection = class // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
        function GetDesc(out pDesc: TD3D12_PARAMETER_DESC): HResult; virtual; stdcall; abstract;
    end;


    {$ENDIF}


    // The ID3D12ShaderReflection IID may change from SDK version to SDK version
    // if the reflection API changes.  This prevents new code with the new API
    // from working with an old binary.  Recompiling with the new header
    // will pick up the new IID.


    ID3D12ShaderReflection = interface(IUnknown)
        ['{5A58797D-A72C-478D-8BA2-EFC6B0EFE88E}']
        function GetDesc(out pDesc: TD3D12_SHADER_DESC): HResult; stdcall;
        function GetConstantBufferByIndex(Index: UINT): ID3D12ShaderReflectionConstantBuffer; stdcall;
        function GetConstantBufferByName(Name: PAnsiChar): ID3D12ShaderReflectionConstantBuffer; stdcall;
        function GetResourceBindingDesc(ResourceIndex: UINT; out pDesc: TD3D12_SHADER_INPUT_BIND_DESC): HResult;
            stdcall;
        function GetInputParameterDesc(ParameterIndex: UINT; out pDesc: TD3D12_SIGNATURE_PARAMETER_DESC): HResult;
            stdcall;
        function GetOutputParameterDesc(ParameterIndex: UINT; out pDesc: TD3D12_SIGNATURE_PARAMETER_DESC): HResult; stdcall;
        function GetPatchConstantParameterDesc(ParameterIndex: UINT; out pDesc: TD3D12_SIGNATURE_PARAMETER_DESC): HResult; stdcall;
        function GetVariableByName(Name: PAnsiChar): ID3D12ShaderReflectionVariable; stdcall;
        function GetResourceBindingDescByName(Name: PAnsiChar; out pDesc: TD3D12_SHADER_INPUT_BIND_DESC): HResult; stdcall;
        function GetMovInstructionCount(): UINT; stdcall;
        function GetMovcInstructionCount(): UINT; stdcall;
        function GetConversionInstructionCount(): UINT; stdcall;
        function GetBitwiseInstructionCount(): UINT; stdcall;
        function GetGSInputPrimitive(): TD3D_PRIMITIVE; stdcall;
        function IsSampleFrequencyShader(): boolean; stdcall;
        function GetNumInterfaceSlots(): UINT; stdcall;
        function GetMinFeatureLevel(out pLevel: TD3D_FEATURE_LEVEL): HResult; stdcall;
        function GetThreadGroupSize(out pSizeX: UINT; out pSizeY: UINT; out pSizeZ: UINT): UINT; stdcall;
        function GetRequiresFlags(): UINT64; stdcall;
    end;


    ID3D12LibraryReflection = interface(IUnknown)
        ['{8E349D19-54DB-4A56-9DC9-119D87BDB804}']
        function GetDesc(out pDesc: TD3D12_LIBRARY_DESC): HResult; stdcall;
        function GetFunctionByIndex(FunctionIndex: INT32): ID3D12FunctionReflection; stdcall;
    end;


function D3D12_SHVER_GET_TYPE(Version: DWORD): DWORD;
function D3D12_SHVER_GET_MAJOR(Version: DWORD): DWORD;
function D3D12_SHVER_GET_MINOR(Version: DWORD): DWORD;


implementation



function D3D12_SHVER_GET_TYPE(Version: DWORD): DWORD;
begin
    Result := ((Version) shr 16) and $ffff;
end;



function D3D12_SHVER_GET_MAJOR(Version: DWORD): DWORD;
begin
    Result := ((Version) shr 4) and $f;
end;



function D3D12_SHVER_GET_MINOR(Version: DWORD): DWORD;
begin
    Result := ((Version) shr 0) and $f;
end;

end.
























