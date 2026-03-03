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
   Content:    D3D11 Shader Types and APIs

   This unit consists of the following header files
   File name: D3D11Shader.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3D11Shader;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3DCommon;

    {$Z4}

const

    // {6E6FFA6A-9BAE-4613-A51E-91652D508C21}
    IID_ID3D11ShaderReflectionType: TGUID = '{6E6FFA6A-9BAE-4613-A51E-91652D508C21}';

    // {51F23923-F3E5-4BD1-91CB-606177D8DB4C}
    IID_ID3D11ShaderReflectionVariable: TGUID = '{51F23923-F3E5-4BD1-91CB-606177D8DB4C}';

    // {EB62D63D-93DD-4318-8AE8-C6F83AD371B8}
    IID_ID3D11ShaderReflectionConstantBuffer: TGUID = '{EB62D63D-93DD-4318-8AE8-C6F83AD371B8}';


    // The ID3D11ShaderReflection IID may change from SDK version to SDK version
    // if the reflection API changes.  This prevents new code with the new API
    // from working with an old binary.  Recompiling with the new header
    // will pick up the new IID.
    // 8d536ca1-0cca-4956-a837-786963755584

    IID_ID3D11ShaderReflection: TGUID = '{8D536CA1-0CCA-4956-A837-786963755584}';

    // {54384F1B-5B3E-4BB7-AE01-60BA3097CBB6}
    IID_ID3D11LibraryReflection: TGUID = '{54384F1B-5B3E-4BB7-AE01-60BA3097CBB6}';

    // {207BCECB-D683-4A06-A8A3-9B149B9F73A4}
    IID_ID3D11FunctionReflection: TGUID = '{207BCECB-D683-4A06-A8A3-9B149B9F73A4}';

    // {42757488-334F-47FE-982E-1A65D08CC462}
    IID_ID3D11FunctionParameterReflection: TGUID = '{42757488-334F-47FE-982E-1A65D08CC462}';

    // {469E07F7-045A-48D5-AA12-68A478CDF75D}
    IID_ID3D11ModuleInstance: TGUID = '{469E07F7-045A-48D5-AA12-68A478CDF75D}';

    // {CAC701EE-80FC-4122-8242-10B39C8CEC34}
    IID_ID3D11Module: TGUID = '{CAC701EE-80FC-4122-8242-10B39C8CEC34}';

    // {59A6CD0E-E10D-4C1F-88C0-63ABA1DAF30E}
    IID_ID3D11Linker: TGUID = '{59A6CD0E-E10D-4C1F-88C0-63ABA1DAF30E}';

    // {D80DD70C-8D2F-4751-94A1-03C79B3556DB}
    IID_ID3D11LinkingNode: TGUID = '{D80DD70C-8D2F-4751-94A1-03C79B3556DB}';

    // {54133220-1CE8-43D3-8236-9855C5CEECFF}
    IID_ID3D11FunctionLinkingGraph: TGUID = '{54133220-1CE8-43D3-8236-9855C5CEECFF}';


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


type

    TD3D11_SHADER_VERSION_TYPE = (
        D3D11_SHVER_PIXEL_SHADER = 0,
        D3D11_SHVER_VERTEX_SHADER = 1,
        D3D11_SHVER_GEOMETRY_SHADER = 2,
        // D3D11 Shaders
        D3D11_SHVER_HULL_SHADER = 3,
        D3D11_SHVER_DOMAIN_SHADER = 4,
        D3D11_SHVER_COMPUTE_SHADER = 5,
        D3D11_SHVER_RESERVED0 = $FFF0);

    PD3D11_SHADER_VERSION_TYPE = ^TD3D11_SHADER_VERSION_TYPE;


    TD3D11_RESOURCE_RETURN_TYPE = TD3D_RESOURCE_RETURN_TYPE;

    TD3D11_CBUFFER_TYPE = TD3D_CBUFFER_TYPE;


    _D3D11_SIGNATURE_PARAMETER_DESC = record
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
    TD3D11_SIGNATURE_PARAMETER_DESC = _D3D11_SIGNATURE_PARAMETER_DESC;
    PD3D11_SIGNATURE_PARAMETER_DESC = ^TD3D11_SIGNATURE_PARAMETER_DESC;


    _D3D11_SHADER_BUFFER_DESC = record
        Name: LPCSTR; // Name of the constant buffer
        BufferType: TD3D_CBUFFER_TYPE; // Indicates type of buffer content
        Variables: UINT; // Number of member variables
        Size: UINT; // Size of CB (in bytes)
        uFlags: UINT; // Buffer description flags
    end;
    TD3D11_SHADER_BUFFER_DESC = _D3D11_SHADER_BUFFER_DESC;
    PD3D11_SHADER_BUFFER_DESC = ^TD3D11_SHADER_BUFFER_DESC;


    _D3D11_SHADER_VARIABLE_DESC = record
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
    TD3D11_SHADER_VARIABLE_DESC = _D3D11_SHADER_VARIABLE_DESC;
    PD3D11_SHADER_VARIABLE_DESC = ^TD3D11_SHADER_VARIABLE_DESC;


    _D3D11_SHADER_TYPE_DESC = record
        ShaderVariableClass: TD3D_SHADER_VARIABLE_CLASS; // Variable class (e.g. object, matrix, etc.)
        ShaderVariableType: TD3D_SHADER_VARIABLE_TYPE; // Variable type (e.g. float, sampler, etc.)
        Rows: UINT; // Number of rows (for matrices, 1 for other numeric, 0 if not applicable)
        Columns: UINT; // Number of columns (for vectors & matrices, 1 for other numeric, 0 if not applicable)
        Elements: UINT; // Number of elements (0 if not an array)
        Members: UINT; // Number of members (0 if not a structure)
        Offset: UINT; // Offset from the start of structure (0 if not a structure member)
        Name: LPCSTR; // Name of type, can be NULL
    end;
    TD3D11_SHADER_TYPE_DESC = _D3D11_SHADER_TYPE_DESC;
    PD3D11_SHADER_TYPE_DESC = ^TD3D11_SHADER_TYPE_DESC;


    TD3D11_TESSELLATOR_DOMAIN = TD3D_TESSELLATOR_DOMAIN;

    TD3D11_TESSELLATOR_PARTITIONING = TD3D_TESSELLATOR_PARTITIONING;

    TD3D11_TESSELLATOR_OUTPUT_PRIMITIVE = TD3D_TESSELLATOR_OUTPUT_PRIMITIVE;

    _D3D11_SHADER_DESC = record
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
    TD3D11_SHADER_DESC = _D3D11_SHADER_DESC;
    PD3D11_SHADER_DESC = ^TD3D11_SHADER_DESC;


    _D3D11_SHADER_INPUT_BIND_DESC = record
        Name: LPCSTR; // Name of the resource
        ShaderInputType: TD3D_SHADER_INPUT_TYPE; // Type of resource (e.g. texture, cbuffer, etc.)
        BindPoint: UINT; // Starting bind point
        BindCount: UINT; // Number of contiguous bind points (for arrays)
        uFlags: UINT; // Input binding flags
        ReturnType: TD3D_RESOURCE_RETURN_TYPE; // Return type (if texture)
        Dimension: TD3D_SRV_DIMENSION; // Dimension (if texture)
        NumSamples: UINT; // Number of samples (0 if not MS texture)
    end;
    TD3D11_SHADER_INPUT_BIND_DESC = _D3D11_SHADER_INPUT_BIND_DESC;
    PD3D11_SHADER_INPUT_BIND_DESC = ^TD3D11_SHADER_INPUT_BIND_DESC;


    _D3D11_LIBRARY_DESC = record
        Creator: LPCSTR; // The name of the originator of the library.
        Flags: UINT; // Compilation flags.
        FunctionCount: UINT; // Number of functions exported from the library.
    end;
    TD3D11_LIBRARY_DESC = _D3D11_LIBRARY_DESC;
    PD3D11_LIBRARY_DESC = ^TD3D11_LIBRARY_DESC;


    _D3D11_FUNCTION_DESC = record
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
    TD3D11_FUNCTION_DESC = _D3D11_FUNCTION_DESC;
    PD3D11_FUNCTION_DESC = ^TD3D11_FUNCTION_DESC;


    _D3D11_PARAMETER_DESC = record
        Name: LPCSTR; // Parameter name.
        SemanticName: LPCSTR; // Parameter semantic name (+index).
        ShaderVariableType: TD3D_SHADER_VARIABLE_TYPE; // Element type.
        ShaderVariableClass: TD3D_SHADER_VARIABLE_CLASS; // Scalar/Vector/Matrix.
        Rows: UINT; // Rows are for matrix parameters.
        Columns: UINT; // Components or Columns in matrix.
        InterpolationMode: TD3D_INTERPOLATION_MODE; // Interpolation mode.
        Flags: TD3D_PARAMETER_FLAGS; // Parameter modifiers.
        FirstInRegister: UINT; // The first input register for this parameter.
        FirstInComponent: UINT; // The first input register component for this parameter.
        FirstOutRegister: UINT; // The first output register for this parameter.
        FirstOutComponent: UINT; // The first output register component for this parameter.
    end;
    TD3D11_PARAMETER_DESC = _D3D11_PARAMETER_DESC;
    PD3D11_PARAMETER_DESC = ^TD3D11_PARAMETER_DESC;

    {$interfaces corba}
    ID3D11ShaderReflectionType = interface;
    LPD3D11SHADERREFLECTIONTYPE = ^ID3D11ShaderReflectionType;


    ID3D11ShaderReflectionVariable = interface;
    LPD3D11SHADERREFLECTIONVARIABLE = ^ID3D11ShaderReflectionVariable;


    ID3D11ShaderReflectionConstantBuffer = interface;
    LPD3D11SHADERREFLECTIONCONSTANTBUFFER = ^ID3D11ShaderReflectionConstantBuffer;

    {$interfaces COM}

    ID3D11ShaderReflection = interface;
    LPD3D11SHADERREFLECTION = ^ID3D11ShaderReflection;


    ID3D11LibraryReflection = interface;
    LPD3D11LIBRARYREFLECTION = ^ID3D11LibraryReflection;

    {$interfaces corba}
    ID3D11FunctionReflection = interface;
    LPD3D11FUNCTIONREFLECTION = ^ID3D11FunctionReflection;

    ID3D11FunctionParameterReflection = interface;
    LPD3D11FUNCTIONPARAMETERREFLECTION = ^ID3D11FunctionParameterReflection;
    {$interfaces COM}


    {$interfaces corba}
    ID3D11ShaderReflectionType = interface
        ['{6E6FFA6A-9BAE-4613-A51E-91652D508C21}']
        function GetDesc(
        {_Out_ } pDesc: PD3D11_SHADER_TYPE_DESC): HRESULT; stdcall;

        function GetMemberTypeByIndex(
        {_In_ } Index: UINT): ID3D11ShaderReflectionType; stdcall;

        function GetMemberTypeByName(
        {_In_ } Name: LPCSTR): ID3D11ShaderReflectionType; stdcall;

        function GetMemberTypeName(
        {_In_ } Index: UINT): LPCSTR; stdcall;

        function IsEqual(
        {_In_ } pType: ID3D11ShaderReflectionType): HRESULT; stdcall;

        function GetSubType(): ID3D11ShaderReflectionType; stdcall;

        function GetBaseClass(): ID3D11ShaderReflectionType; stdcall;

        function GetNumInterfaces(): UINT; stdcall;

        function GetInterfaceByIndex(
        {_In_ } uIndex: UINT): ID3D11ShaderReflectionType; stdcall;

        function IsOfType(
        {_In_ } pType: ID3D11ShaderReflectionType): HRESULT; stdcall;

        function ImplementsInterface(
        {_In_ } pBase: ID3D11ShaderReflectionType): HRESULT; stdcall;

    end;


    ID3D11ShaderReflectionVariable = interface
        ['{51F23923-F3E5-4BD1-91CB-606177D8DB4C}']
        function GetDesc(
        {_Out_ } pDesc: PD3D11_SHADER_VARIABLE_DESC): HRESULT; stdcall;

        function GetType(): ID3D11ShaderReflectionType; stdcall;

        function GetBuffer(): ID3D11ShaderReflectionConstantBuffer; stdcall;

        function GetInterfaceSlot(
        {_In_ } uArrayIndex: UINT): UINT; stdcall;

    end;


    ID3D11ShaderReflectionConstantBuffer = interface
        ['{EB62D63D-93DD-4318-8AE8-C6F83AD371B8}']
        function GetDesc(pDesc: PD3D11_SHADER_BUFFER_DESC): HRESULT; stdcall;

        function GetVariableByIndex(
        {_In_ } Index: UINT): ID3D11ShaderReflectionVariable; stdcall;

        function GetVariableByName(
        {_In_ } Name: LPCSTR): ID3D11ShaderReflectionVariable; stdcall;

    end;


    {$interfaces COM}


    // The ID3D11ShaderReflection IID may change from SDK version to SDK version
    // if the reflection API changes.  This prevents new code with the new API
    // from working with an old binary.  Recompiling with the new header
    // will pick up the new IID.

    ID3D11ShaderReflection = interface(IUnknown)
        ['{8D536CA1-0CCA-4956-A837-786963755584}']
        function GetDesc(
        {_Out_ } pDesc: PD3D11_SHADER_DESC): HRESULT; stdcall;

        function GetConstantBufferByIndex(
        {_In_ } Index: UINT): ID3D11ShaderReflectionConstantBuffer; stdcall;

        function GetConstantBufferByName(
        {_In_ } Name: LPCSTR): ID3D11ShaderReflectionConstantBuffer; stdcall;

        function GetResourceBindingDesc(
        {_In_ } ResourceIndex: UINT;
        {_Out_ } pDesc: PD3D11_SHADER_INPUT_BIND_DESC): HRESULT; stdcall;

        function GetInputParameterDesc(
        {_In_ } ParameterIndex: UINT;
        {_Out_ } pDesc: PD3D11_SIGNATURE_PARAMETER_DESC): HRESULT; stdcall;

        function GetOutputParameterDesc(
        {_In_ } ParameterIndex: UINT;
        {_Out_ } pDesc: PD3D11_SIGNATURE_PARAMETER_DESC): HRESULT; stdcall;

        function GetPatchConstantParameterDesc(
        {_In_ } ParameterIndex: UINT;
        {_Out_ } pDesc: PD3D11_SIGNATURE_PARAMETER_DESC): HRESULT; stdcall;

        function GetVariableByName(
        {_In_ } Name: LPCSTR): ID3D11ShaderReflectionVariable; stdcall;

        function GetResourceBindingDescByName(
        {_In_ } Name: LPCSTR;
        {_Out_ } pDesc: PD3D11_SHADER_INPUT_BIND_DESC): HRESULT; stdcall;

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


    ID3D11LibraryReflection = interface(IUnknown)
        ['{54384F1B-5B3E-4BB7-AE01-60BA3097CBB6}']
        function GetDesc(
        {_Out_ } pDesc: PD3D11_LIBRARY_DESC): HRESULT; stdcall;

        function GetFunctionByIndex(
        {_In_ } FunctionIndex: int32): ID3D11FunctionReflection; stdcall;

    end;


    {$interfaces corba}
    ID3D11FunctionReflection = interface
        ['{207BCECB-D683-4A06-A8A3-9B149B9F73A4}']
        function GetDesc(
        {_Out_ } pDesc: PD3D11_FUNCTION_DESC): HRESULT; stdcall;

        function GetConstantBufferByIndex(
        {_In_ } BufferIndex: UINT): ID3D11ShaderReflectionConstantBuffer; stdcall;

        function GetConstantBufferByName(
        {_In_ } Name: LPCSTR): ID3D11ShaderReflectionConstantBuffer; stdcall;

        function GetResourceBindingDesc(
        {_In_ } ResourceIndex: UINT;
        {_Out_ } pDesc: PD3D11_SHADER_INPUT_BIND_DESC): HRESULT; stdcall;

        function GetVariableByName(
        {_In_ } Name: LPCSTR): ID3D11ShaderReflectionVariable; stdcall;

        function GetResourceBindingDescByName(
        {_In_ } Name: LPCSTR;
        {_Out_ } pDesc: PD3D11_SHADER_INPUT_BIND_DESC): HRESULT; stdcall;

        // Use D3D_RETURN_PARAMETER_INDEX to get description of the return value.
        function GetFunctionParameter(
        {_In_ } ParameterIndex: int32): ID3D11FunctionParameterReflection; stdcall;

    end;

    ID3D11FunctionParameterReflection = interface
        ['{42757488-334F-47FE-982E-1A65D08CC462}']
        function GetDesc(
        {_Out_ } pDesc: PD3D11_PARAMETER_DESC): HRESULT; stdcall;

    end;


    {$interfaces COM}


    ID3D11ModuleInstance = interface(IUnknown)
        ['{469E07F7-045A-48D5-AA12-68A478CDF75D}']

        // Resource binding API.

        function BindConstantBuffer(
        {_In_ } uSrcSlot: UINT;
        {_In_ } uDstSlot: UINT;
        {_In_ } cbDstOffset: UINT): HRESULT; stdcall;

        function BindConstantBufferByName(
        {_In_ } pName: LPCSTR;
        {_In_ } uDstSlot: UINT;
        {_In_ } cbDstOffset: UINT): HRESULT; stdcall;

        function BindResource(
        {_In_ } uSrcSlot: UINT;
        {_In_ } uDstSlot: UINT;
        {_In_ } uCount: UINT): HRESULT; stdcall;

        function BindResourceByName(
        {_In_ } pName: LPCSTR;
        {_In_ } uDstSlot: UINT;
        {_In_ } uCount: UINT): HRESULT; stdcall;

        function BindSampler(
        {_In_ } uSrcSlot: UINT;
        {_In_ } uDstSlot: UINT;
        {_In_ } uCount: UINT): HRESULT; stdcall;

        function BindSamplerByName(
        {_In_ } pName: LPCSTR;
        {_In_ } uDstSlot: UINT;
        {_In_ } uCount: UINT): HRESULT; stdcall;

        function BindUnorderedAccessView(
        {_In_ } uSrcSlot: UINT;
        {_In_ } uDstSlot: UINT;
        {_In_ } uCount: UINT): HRESULT; stdcall;

        function BindUnorderedAccessViewByName(
        {_In_ } pName: LPCSTR;
        {_In_ } uDstSlot: UINT;
        {_In_ } uCount: UINT): HRESULT; stdcall;

        function BindResourceAsUnorderedAccessView(
        {_In_ } uSrcSrvSlot: UINT;
        {_In_ } uDstUavSlot: UINT;
        {_In_ } uCount: UINT): HRESULT; stdcall;

        function BindResourceAsUnorderedAccessViewByName(
        {_In_ } pSrvName: LPCSTR;
        {_In_ } uDstUavSlot: UINT;
        {_In_ } uCount: UINT): HRESULT; stdcall;

    end;

    ID3D11Module = interface(IUnknown)
        ['{CAC701EE-80FC-4122-8242-10B39C8CEC34}']
        // Create an instance of a module for resource re-binding.
        function CreateInstance(
        {_In_opt_ } pNamespace: LPCSTR;
        {_COM_Outptr_ } out ppModuleInstance: ID3D11ModuleInstance): HRESULT; stdcall;

    end;


    ID3D11Linker = interface(IUnknown)
        ['{59A6CD0E-E10D-4C1F-88C0-63ABA1DAF30E}']
        // Link the shader and produce a shader blob suitable to D3D runtime.
        function Link(
        {_In_ } pEntry: ID3D11ModuleInstance;
        {_In_ } pEntryName: LPCSTR;
        {_In_ } pTargetName: LPCSTR;
        {_In_ } uFlags: UINT;
        {_COM_Outptr_ }  out ppShaderBlob: ID3DBlob;
        {_Outptr_opt_result_maybenull_} out ppErrorBuffer: ID3DBlob): HRESULT; stdcall;

        // Add an instance of a library module to be used for linking.
        function UseLibrary(
        {_In_ } pLibraryMI: ID3D11ModuleInstance): HRESULT; stdcall;

        // Add a clip plane with the plane coefficients taken from a cbuffer entry for 10L9 shaders.
        function AddClipPlaneFromCBuffer(
        {_In_ } uCBufferSlot: UINT;
        {_In_ } uCBufferEntry: UINT): HRESULT; stdcall;

    end;


    ID3D11LinkingNode = interface(IUnknown)
        ['{D80DD70C-8D2F-4751-94A1-03C79B3556DB}']
    end;


    ID3D11FunctionLinkingGraph = interface(IUnknown)
        ['{54133220-1CE8-43D3-8236-9855C5CEECFF}']

        // Create a shader module out of FLG description.
        function CreateModuleInstance(
        {_COM_Outptr_ }out ppModuleInstance: ID3D11ModuleInstance;
        {_Always_(_Outptr_opt_result_maybenull_) }  out ppErrorBuffer: ID3DBlob): HRESULT; stdcall;

        function SetInputSignature(
        {__in_ecount(cInputParameters) const}  pInputParameters: PD3D11_PARAMETER_DESC;
        {_In_ } cInputParameters: UINT;
        {_COM_Outptr_ } out ppInputNode: ID3D11LinkingNode): HRESULT; stdcall;

        function SetOutputSignature(
        {__in_ecount(cOutputParameters) const}  pOutputParameters: PD3D11_PARAMETER_DESC;
        {_In_ } cOutputParameters: UINT;
        {_COM_Outptr_ }out ppOutputNode: ID3D11LinkingNode): HRESULT; stdcall;

        function CallFunction(
        {_In_opt_ } pModuleInstanceNamespace: LPCSTR;
        {_In_ } pModuleWithFunctionPrototype: ID3D11Module;
        {_In_ } pFunctionName: LPCSTR;
        {_COM_Outptr_ } out ppCallNode: ID3D11LinkingNode): HRESULT; stdcall;

        function PassValue(
        {_In_ } pSrcNode: ID3D11LinkingNode;
        {_In_ } SrcParameterIndex: int32;
        {_In_ } pDstNode: ID3D11LinkingNode;
        {_In_ } DstParameterIndex: int32): HRESULT; stdcall;

        function PassValueWithSwizzle(
        {_In_ } pSrcNode: ID3D11LinkingNode;
        {_In_ } SrcParameterIndex: int32;
        {_In_ } pSrcSwizzle: LPCSTR;
        {_In_ }pDstNode: ID3D11LinkingNode;
        {_In_ } DstParameterIndex: int32;
        {_In_ } pDstSwizzle: LPCSTR): HRESULT; stdcall;

        function GetLastError(
        {_Always_(_Outptr_opt_result_maybenull_) }  out ppErrorBuffer: ID3DBlob): HRESULT; stdcall;

        function GenerateHlsl(
        // uFlags is reserved for future use.
        {_In_ } uFlags: UINT;
        {_COM_Outptr_ }  out ppBuffer: ID3DBlob): HRESULT; stdcall;

    end;


function D3D11_SHVER_GET_TYPE(_Version: word): word;
function D3D11_SHVER_GET_MAJOR(_Version: word): word;
function D3D11_SHVER_GET_MINOR(_Version: word): word;

implementation



function D3D11_SHVER_GET_TYPE(_Version: word): word;
begin
    Result := (_Version shr 16) and $ffff;
end;



function D3D11_SHVER_GET_MAJOR(_Version: word): word;
begin
    Result := (_Version shr 4) and $f;
end;



function D3D11_SHVER_GET_MINOR(_Version: word): word;
begin
    Result := (_Version shr 0) and $f;
end;


end.
