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

   Copyright (c) Microsoft Corporation.
   Licensed under the MIT license
   Content:    D3D12 Shader Types and APIs

   This unit consists of the following header files
   File name: D3D12Shader.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3D12Shader;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3DCommon;

    {$Z4}

const
    // Slot ID for library function return
    D3D_RETURN_PARAMETER_INDEX = (-1);


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
    D3D_SHADER_REQUIRES_WAVE_OPS = $00004000;
    D3D_SHADER_REQUIRES_INT64_OPS = $00008000;
    D3D_SHADER_REQUIRES_VIEW_ID = $00010000;
    D3D_SHADER_REQUIRES_BARYCENTRICS = $00020000;
    D3D_SHADER_REQUIRES_NATIVE_16BIT_OPS = $00040000;
    D3D_SHADER_REQUIRES_SHADING_RATE = $00080000;
    D3D_SHADER_REQUIRES_RAYTRACING_TIER_1_1 = $00100000;
    D3D_SHADER_REQUIRES_SAMPLER_FEEDBACK = $00200000;
    D3D_SHADER_REQUIRES_ATOMIC_INT64_ON_TYPED_RESOURCE = $00400000;
    D3D_SHADER_REQUIRES_ATOMIC_INT64_ON_GROUP_SHARED = $00800000;
    D3D_SHADER_REQUIRES_DERIVATIVES_IN_MESH_AND_AMPLIFICATION_SHADERS = $01000000;
    D3D_SHADER_REQUIRES_RESOURCE_DESCRIPTOR_HEAP_INDEXING = $02000000;
    D3D_SHADER_REQUIRES_SAMPLER_DESCRIPTOR_HEAP_INDEXING = $04000000;
    D3D_SHADER_REQUIRES_WAVE_MMA = $08000000;
    D3D_SHADER_REQUIRES_ATOMIC_INT64_ON_DESCRIPTOR_HEAP_RESOURCE = $10000000;
    D3D_SHADER_REQUIRES_ADVANCED_TEXTURE_OPS = $20000000;
    D3D_SHADER_REQUIRES_WRITEABLE_MSAA_TEXTURES = $40000000;
    D3D_SHADER_REQUIRES_SAMPLE_CMP_GRADIENT_OR_BIAS = $80000000;
    D3D_SHADER_REQUIRES_EXTENDED_COMMAND_INFO = $100000000;


    IID_ID3D12ShaderReflectionType: TGUID = '{E913C351-783D-48CA-A1D1-4F306284AD56}';
    IID_ID3D12ShaderReflectionVariable: TGUID = '{8337A8A6-A216-444A-B2F4-314733A73AEA}';
    IID_ID3D12ShaderReflectionConstantBuffer: TGUID = '{C59598B4-48B3-4869-B9B1-B1618B14A8B7}';
    IID_ID3D12ShaderReflection: TGUID = '{5A58797D-A72C-478D-8BA2-EFC6B0EFE88E}';
    IID_ID3D12LibraryReflection: TGUID = '{8E349D19-54DB-4A56-9DC9-119D87BDB804}';
    IID_ID3D12FunctionReflection: TGUID = '{1108795C-2772-4BA9-B2A8-D464DC7E2799}';
    IID_ID3D12FunctionParameterReflection: TGUID = '{EC25F42D-7006-4F2B-B33E-02CC3375733F}';


type

    TD3D12_SHADER_VERSION_TYPE = (
        D3D12_SHVER_PIXEL_SHADER = 0,
        D3D12_SHVER_VERTEX_SHADER = 1,
        D3D12_SHVER_GEOMETRY_SHADER = 2,
        // D3D11 Shaders
        D3D12_SHVER_HULL_SHADER = 3,
        D3D12_SHVER_DOMAIN_SHADER = 4,
        D3D12_SHVER_COMPUTE_SHADER = 5,
        // D3D12 Shaders
        D3D12_SHVER_LIBRARY = 6,
        D3D12_SHVER_RAY_GENERATION_SHADER = 7,
        D3D12_SHVER_INTERSECTION_SHADER = 8,
        D3D12_SHVER_ANY_HIT_SHADER = 9,
        D3D12_SHVER_CLOSEST_HIT_SHADER = 10,
        D3D12_SHVER_MISS_SHADER = 11,
        D3D12_SHVER_CALLABLE_SHADER = 12,
        D3D12_SHVER_MESH_SHADER = 13,
        D3D12_SHVER_AMPLIFICATION_SHADER = 14,
        D3D12_SHVER_NODE_SHADER = 15,
        D3D12_SHVER_RESERVED0 = $FFF0);

    PD3D12_SHADER_VERSION_TYPE = ^TD3D12_SHADER_VERSION_TYPE;


    TD3D12_RESOURCE_RETURN_TYPE = TD3D_RESOURCE_RETURN_TYPE;

    TD3D12_CBUFFER_TYPE = TD3D_CBUFFER_TYPE;


    _D3D12_SIGNATURE_PARAMETER_DESC = record
        SemanticName: LPCSTR; // Name of the semantic
        SemanticIndex: UINT; // Index of the semantic
        Register: UINT; // Number of member variables
        SystemValueType: TD3D_NAME; // A predefined system value, or D3D_NAME_UNDEFINED if not applicable
        ComponentType: TD3D_REGISTER_COMPONENT_TYPE; // Scalar type (e.g. uint, float, etc.)
        Mask: TBYTE; // Mask to indicate which components of the register
        ReadWriteMask: TBYTE; // Mask to indicate whether a given component is
        // always read (if this is an input signature).
        // (combination of D3D_MASK_* values)
        Stream: UINT; // Stream index
        MinPrecision: TD3D_MIN_PRECISION; // Minimum desired interpolation precision
    end;
    TD3D12_SIGNATURE_PARAMETER_DESC = _D3D12_SIGNATURE_PARAMETER_DESC;
    PD3D12_SIGNATURE_PARAMETER_DESC = ^TD3D12_SIGNATURE_PARAMETER_DESC;


    _D3D12_SHADER_BUFFER_DESC = record
        Name: LPCSTR; // Name of the constant buffer
        BufferType: TD3D_CBUFFER_TYPE; // Indicates type of buffer content
        Variables: UINT; // Number of member variables
        Size: UINT; // Size of CB (in bytes)
        uFlags: UINT; // Buffer description flags
    end;
    TD3D12_SHADER_BUFFER_DESC = _D3D12_SHADER_BUFFER_DESC;
    PD3D12_SHADER_BUFFER_DESC = ^TD3D12_SHADER_BUFFER_DESC;


    _D3D12_SHADER_VARIABLE_DESC = record
        Name: LPCSTR; // Name of the variable
        StartOffset: UINT; // Offset in constant buffer's backing store
        Size: UINT; // Size of variable (in bytes)
        uFlags: UINT; // Variable flags
        DefaultValue: LPVOID; // Raw pointer to default value
        StartTexture: UINT; // First texture index (or -1 if no textures used)
        TextureSize: UINT; // Number of texture slots possibly used.
        StartSampler: UINT; // First sampler index (or -1 if no textures used)
        SamplerSize: UINT; // Number of sampler slots possibly used.
    end;
    TD3D12_SHADER_VARIABLE_DESC = _D3D12_SHADER_VARIABLE_DESC;
    PD3D12_SHADER_VARIABLE_DESC = ^TD3D12_SHADER_VARIABLE_DESC;


    _D3D12_SHADER_TYPE_DESC = record
        VariableClass: TD3D_SHADER_VARIABLE_CLASS; // Variable class (e.g. object, matrix, etc.)
        VariableType: TD3D_SHADER_VARIABLE_TYPE; // Variable type (e.g. float, sampler, etc.)
        Rows: UINT; // Number of rows (for matrices, 1 for other numeric, 0 if not applicable)
        Columns: UINT; // Number of columns (for vectors & matrices, 1 for other numeric, 0 if not applicable)
        Elements: UINT; // Number of elements (0 if not an array)
        Members: UINT; // Number of members (0 if not a structure)
        Offset: UINT; // Offset from the start of structure (0 if not a structure member)
        Name: LPCSTR; // Name of type, can be NULL
    end;
    TD3D12_SHADER_TYPE_DESC = _D3D12_SHADER_TYPE_DESC;
    PD3D12_SHADER_TYPE_DESC = ^TD3D12_SHADER_TYPE_DESC;


    TD3D12_TESSELLATOR_DOMAIN = TD3D_TESSELLATOR_DOMAIN;

    TD3D12_TESSELLATOR_PARTITIONING = TD3D_TESSELLATOR_PARTITIONING;

    TD3D12_TESSELLATOR_OUTPUT_PRIMITIVE = TD3D_TESSELLATOR_OUTPUT_PRIMITIVE;

    _D3D12_SHADER_DESC = record
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
        GSOutputTopology: TD3D_PRIMITIVE_TOPOLOGY; // Geometry shader output topology
        GSMaxOutputVertexCount: UINT; // Geometry shader maximum output vertex count
        InputPrimitive: TD3D_PRIMITIVE; // GS/HS input primitive
        PatchConstantParameters: UINT; // Number of parameters in the patch constant signature
        cGSInstanceCount: UINT; // Number of Geometry shader instances
        cControlPoints: UINT; // Number of control points in the HS->DS stage
        HSOutputPrimitive: TD3D_TESSELLATOR_OUTPUT_PRIMITIVE; // Primitive output by the tessellator
        HSPartitioning: TD3D_TESSELLATOR_PARTITIONING; // Partitioning mode of the tessellator
        TessellatorDomain: TD3D_TESSELLATOR_DOMAIN; // Domain of the tessellator (quad, tri, isoline)
        cBarrierInstructions: UINT; // Number of barrier instructions in a compute shader
        cInterlockedInstructions: UINT; // Number of interlocked instructions
        cTextureStoreInstructions: UINT; // Number of texture writes
    end;
    TD3D12_SHADER_DESC = _D3D12_SHADER_DESC;
    PD3D12_SHADER_DESC = ^TD3D12_SHADER_DESC;


    _D3D12_SHADER_INPUT_BIND_DESC = record
        Name: LPCSTR; // Name of the resource
        InputType: TD3D_SHADER_INPUT_TYPE; // Type of resource (e.g. texture, cbuffer, etc.)
        BindPoint: UINT; // Starting bind point
        BindCount: UINT; // Number of contiguous bind points (for arrays)
        uFlags: UINT; // Input binding flags
        ReturnType: TD3D_RESOURCE_RETURN_TYPE; // Return type (if texture)
        Dimension: TD3D_SRV_DIMENSION; // Dimension (if texture)
        NumSamples: UINT; // Number of samples (0 if not MS texture)
        Space: UINT; // Register space
        uID: UINT; // Range ID in the bytecode
    end;
    TD3D12_SHADER_INPUT_BIND_DESC = _D3D12_SHADER_INPUT_BIND_DESC;
    PD3D12_SHADER_INPUT_BIND_DESC = ^TD3D12_SHADER_INPUT_BIND_DESC;


    _D3D12_LIBRARY_DESC = record
        Creator: LPCSTR; // The name of the originator of the library.
        Flags: UINT; // Compilation flags.
        FunctionCount: UINT; // Number of functions exported from the library.
    end;
    TD3D12_LIBRARY_DESC = _D3D12_LIBRARY_DESC;
    PD3D12_LIBRARY_DESC = ^TD3D12_LIBRARY_DESC;


    _D3D12_FUNCTION_DESC = record
        Version: UINT; // Shader version
        Creator: LPCSTR; // Creator string
        Flags: UINT; // Shader compilation/parse flags
        ConstantBuffers: UINT; // Number of constant buffers
        BoundResources: UINT; // Number of bound resources
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
        MovInstructionCount: UINT; // Number of mov instructions used
        MovcInstructionCount: UINT; // Number of movc instructions used
        ConversionInstructionCount: UINT; // Number of type conversion instructions used
        BitwiseInstructionCount: UINT; // Number of bitwise arithmetic instructions used
        MinFeatureLevel: TD3D_FEATURE_LEVEL; // Min target of the function byte code
        RequiredFeatureFlags: uint64; // Required feature flags
        Name: LPCSTR; // Function name
        FunctionParameterCount: int32; // Number of logical parameters in the function signature (not including return)
        HasReturn: boolean; // TRUE, if function returns a value, false - it is a subroutine
        Has10Level9VertexShader: boolean; // TRUE, if there is a 10L9 VS blob
        Has10Level9PixelShader: boolean; // TRUE, if there is a 10L9 PS blob
    end;
    TD3D12_FUNCTION_DESC = _D3D12_FUNCTION_DESC;
    PD3D12_FUNCTION_DESC = ^TD3D12_FUNCTION_DESC;


    _D3D12_PARAMETER_DESC = record
        Name: LPCSTR; // Parameter name.
        SemanticName: LPCSTR; // Parameter semantic name (+index).
        VariableType: TD3D_SHADER_VARIABLE_TYPE; // Element type.
        VariableClass: TD3D_SHADER_VARIABLE_CLASS; // Scalar/Vector/Matrix.
        Rows: UINT; // Rows are for matrix parameters.
        Columns: UINT; // Components or Columns in matrix.
        InterpolationMode: TD3D_INTERPOLATION_MODE; // Interpolation mode.
        Flags: TD3D_PARAMETER_FLAGS; // Parameter modifiers.
        FirstInRegister: UINT; // The first input register for this parameter.
        FirstInComponent: UINT; // The first input register component for this parameter.
        FirstOutRegister: UINT; // The first output register for this parameter.
        FirstOutComponent: UINT; // The first output register component for this parameter.
    end;
    TD3D12_PARAMETER_DESC = _D3D12_PARAMETER_DESC;
    PD3D12_PARAMETER_DESC = ^TD3D12_PARAMETER_DESC;


    //////////////////////////////////////////////////////////////////////////////
    // Interfaces ////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    {$interfaces corba}
    ID3D12ShaderReflectionType = interface;
    PID3D12ShaderReflectionType = ^ID3D12ShaderReflectionType;


    ID3D12ShaderReflectionVariable = interface;
    PID3D12ShaderReflectionVariable = ^ID3D12ShaderReflectionVariable;


    ID3D12ShaderReflectionConstantBuffer = interface;
    PID3D12ShaderReflectionConstantBuffer = ^ID3D12ShaderReflectionConstantBuffer;

    ID3D12FunctionReflection = interface;
    PID3D12FunctionReflection = ^ID3D12FunctionReflection;


    ID3D12FunctionParameterReflection = interface;
    PID3D12FunctionParameterReflection = ^ID3D12FunctionParameterReflection;

    {$interfaces COM}

    ID3D12ShaderReflection = interface;
    PID3D12ShaderReflection = ^ID3D12ShaderReflection;


    ID3D12LibraryReflection = interface;
    PID3D12LibraryReflection = ^ID3D12LibraryReflection;


    {$interfaces corba}
    ID3D12ShaderReflectionType = interface
        ['{E913C351-783D-48CA-A1D1-4F306284AD56}']
        function GetDesc(
        {_Out_ } pDesc: PD3D12_SHADER_TYPE_DESC): HRESULT; stdcall;

        function GetMemberTypeByIndex(
        {_In_ } Index: UINT): ID3D12ShaderReflectionType; stdcall;

        function GetMemberTypeByName(
        {_In_ } Name: LPCSTR): ID3D12ShaderReflectionType; stdcall;

        function GetMemberTypeName(
        {_In_ } Index: UINT): LPCSTR; stdcall;

        function IsEqual(
        {_In_ } pType: ID3D12ShaderReflectionType): HRESULT; stdcall;

        function GetSubType(): ID3D12ShaderReflectionType; stdcall;

        function GetBaseClass(): ID3D12ShaderReflectionType; stdcall;

        function GetNumInterfaces(): UINT; stdcall;

        function GetInterfaceByIndex(
        {_In_ } uIndex: UINT): ID3D12ShaderReflectionType; stdcall;

        function IsOfType(
        {_In_ } pType: ID3D12ShaderReflectionType): HRESULT; stdcall;

        function ImplementsInterface(
        {_In_ } pBase: ID3D12ShaderReflectionType): HRESULT; stdcall;

    end;

    ID3D12ShaderReflectionVariable = interface
        ['{8337A8A6-A216-444A-B2F4-314733A73AEA}']
        function GetDesc(
        {_Out_ } pDesc: PD3D12_SHADER_VARIABLE_DESC): HRESULT; stdcall;

        function GetType(): ID3D12ShaderReflectionType; stdcall;

        function GetBuffer(): ID3D12ShaderReflectionConstantBuffer; stdcall;

        function GetInterfaceSlot(
        {_In_ } uArrayIndex: UINT): UINT; stdcall;

    end;

    ID3D12ShaderReflectionConstantBuffer = interface
        ['{C59598B4-48B3-4869-B9B1-B1618B14A8B7}']
        function GetDesc(pDesc: PD3D12_SHADER_BUFFER_DESC): HRESULT; stdcall;

        function GetVariableByIndex(
        {_In_ } Index: UINT): ID3D12ShaderReflectionVariable; stdcall;

        function GetVariableByName(
        {_In_ } Name: LPCSTR): ID3D12ShaderReflectionVariable; stdcall;

    end;

    {$interfaces COM}


    // The ID3D12ShaderReflection IID may change from SDK version to SDK version
    // if the reflection API changes.  This prevents new code with the new API
    // from working with an old binary.  Recompiling with the new header
    // will pick up the new IID.


    ID3D12ShaderReflection = interface(IUnknown)
        ['{5A58797D-A72C-478D-8BA2-EFC6B0EFE88E}']
        function GetDesc(
        {_Out_ } pDesc: PD3D12_SHADER_DESC): HRESULT; stdcall;

        function GetConstantBufferByIndex(
        {_In_ } Index: UINT): ID3D12ShaderReflectionConstantBuffer; stdcall;

        function GetConstantBufferByName(
        {_In_ } Name: LPCSTR): ID3D12ShaderReflectionConstantBuffer; stdcall;

        function GetResourceBindingDesc(
        {_In_ } ResourceIndex: UINT;
        {_Out_ } pDesc: PD3D12_SHADER_INPUT_BIND_DESC): HRESULT; stdcall;

        function GetInputParameterDesc(
        {_In_ } ParameterIndex: UINT;
        {_Out_ } pDesc: PD3D12_SIGNATURE_PARAMETER_DESC): HRESULT; stdcall;

        function GetOutputParameterDesc(
        {_In_ } ParameterIndex: UINT;
        {_Out_ } pDesc: PD3D12_SIGNATURE_PARAMETER_DESC): HRESULT; stdcall;

        function GetPatchConstantParameterDesc(
        {_In_ } ParameterIndex: UINT;
        {_Out_ } pDesc: PD3D12_SIGNATURE_PARAMETER_DESC): HRESULT; stdcall;

        function GetVariableByName(
        {_In_ } Name: LPCSTR): ID3D12ShaderReflectionVariable; stdcall;

        function GetResourceBindingDescByName(
        {_In_ } Name: LPCSTR;
        {_Out_ } pDesc: PD3D12_SHADER_INPUT_BIND_DESC): HRESULT; stdcall;

        function GetMovInstructionCount(): UINT; stdcall;

        function GetMovcInstructionCount(): UINT; stdcall;

        function GetConversionInstructionCount(): UINT; stdcall;

        function GetBitwiseInstructionCount(): UINT; stdcall;

        function GetGSInputPrimitive(): TD3D_PRIMITIVE; stdcall;

        function IsSampleFrequencyShader(): boolean; stdcall;

        function GetNumInterfaceSlots(): UINT; stdcall;

        function GetMinFeatureLevel(
        {_Out_ } pLevel: PD3D_FEATURE_LEVEL): HRESULT; stdcall;

        function GetThreadGroupSize(
        {_Out_opt_ } pSizeX: PUINT;
        {_Out_opt_ } pSizeY: PUINT;
        {_Out_opt_ } pSizeZ: PUINT): UINT; stdcall;

        function GetRequiresFlags(): uint64; stdcall;

    end;


    ID3D12LibraryReflection = interface(IUnknown)
        ['{8E349D19-54DB-4A56-9DC9-119D87BDB804}']
        function GetDesc(
        {_Out_ } pDesc: PD3D12_LIBRARY_DESC): HRESULT; stdcall;

        function GetFunctionByIndex(
        {_In_ } FunctionIndex: int32): ID3D12FunctionReflection; stdcall;

    end;


    {$interfaces corba}
    ID3D12FunctionReflection = interface
        ['{1108795C-2772-4BA9-B2A8-D464DC7E2799}']
        function GetDesc(
        {_Out_ } pDesc: PD3D12_FUNCTION_DESC): HRESULT; stdcall;

        function GetConstantBufferByIndex(
        {_In_ } BufferIndex: UINT): ID3D12ShaderReflectionConstantBuffer; stdcall;

        function GetConstantBufferByName(
        {_In_ } Name: LPCSTR): ID3D12ShaderReflectionConstantBuffer; stdcall;

        function GetResourceBindingDesc(
        {_In_ } ResourceIndex: UINT;
        {_Out_ } pDesc: PD3D12_SHADER_INPUT_BIND_DESC): HRESULT; stdcall;

        function GetVariableByName(
        {_In_ } Name: LPCSTR): ID3D12ShaderReflectionVariable; stdcall;

        function GetResourceBindingDescByName(
        {_In_ } Name: LPCSTR;
        {_Out_ } pDesc: PD3D12_SHADER_INPUT_BIND_DESC): HRESULT; stdcall;

        // Use D3D_RETURN_PARAMETER_INDEX to get description of the return value.
        function GetFunctionParameter(
        {_In_ } ParameterIndex: int32): ID3D12FunctionParameterReflection; stdcall;

    end;


    ID3D12FunctionParameterReflection = interface
        ['{EC25F42D-7006-4F2B-B33E-02CC3375733F}']
        function GetDesc(
        {_Out_ } pDesc: PD3D12_PARAMETER_DESC): HRESULT; stdcall;

    end;

    {$interfaces COM}


function D3D12_SHVER_GET_TYPE(_Version: longword): longword;
function D3D12_SHVER_GET_MAJOR(_Version: longword): longword;
function D3D12_SHVER_GET_MINOR(_Version: longword): longword;


implementation



function D3D12_SHVER_GET_TYPE(_Version: longword): longword;
begin
    Result := (((_Version) shr 16) and $ffff);
end;



function D3D12_SHVER_GET_MAJOR(_Version: longword): longword;
begin
    Result := (((_Version) shr 4) and $f);
end;



function D3D12_SHVER_GET_MINOR(_Version: longword): longword;
begin
    Result := (((_Version) shr 0) and $f);
end;

end.
