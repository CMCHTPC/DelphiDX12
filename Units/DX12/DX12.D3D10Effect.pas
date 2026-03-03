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
   Content:    D3D10 Stateblock/Effect Types & APIs

   This unit consists of the following header files
   File name: D3D10Effect.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3D10Effect;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3DCommon,
    DX12.D3D10,
    DX12.D3D10Shader;

{$Z4}
{$A4}

    //////////////////////////////////////////////////////////////////////////////
    // File contents:
    // 1) Stateblock enums, structs, interfaces, flat APIs
    // 2) Effect enums, structs, interfaces, flat APIs
    //////////////////////////////////////////////////////////////////////////////

const
    D3D10_DLL = 'd3d10.dll';
    D3D10_1_DLL = 'd3d10_1.dll';


    IID_ID3D10EffectVectorVariable: TGUID = '{62B98C44-1F82-4C67-BCD0-72CF8F217E81}';


    IID_ID3D10EffectMatrixVariable: TGUID = '{50666C24-B82F-4EED-A172-5B6E7E8522E0}';


    IID_ID3D10EffectStringVariable: TGUID = '{71417501-8DF9-4E0A-A78A-255F9756BAFF}';


    IID_ID3D10EffectShaderResourceVariable: TGUID = '{C0A7157B-D872-4B1D-8073-EFC2ACD4B1FC}';


    IID_ID3D10EffectRenderTargetViewVariable: TGUID = '{28CA0CC3-C2C9-40BB-B57F-67B737122B17}';


    IID_ID3D10EffectDepthStencilViewVariable: TGUID = '{3E02C918-CC79-4985-B622-2D92AD701623}';


    IID_ID3D10EffectConstantBuffer: TGUID = '{56648F4D-CC8B-4444-A5AD-B5A3D76E91B3}';


    IID_ID3D10EffectShaderVariable: TGUID = '{80849279-C799-4797-8C33-0407A07D9E06}';


    IID_ID3D10EffectBlendVariable: TGUID = '{1FCD2294-DF6D-4EAE-86B3-0E9160CFB07B}';


    IID_ID3D10EffectDepthStencilVariable: TGUID = '{AF482368-330A-46A5-9A5C-01C71AF24C8D}';


    IID_ID3D10EffectRasterizerVariable: TGUID = '{21AF9F0E-4D94-4EA9-9785-2CB76B8C0B34}';


    IID_ID3D10EffectSamplerVariable: TGUID = '{6530D5C7-07E9-4271-A418-E7CE4BD1E480}';


    IID_ID3D10EffectPass: TGUID = '{5CFBEB89-1A06-46E0-B282-E3F9BFA36A54}';


    IID_ID3D10EffectTechnique: TGUID = '{DB122CE8-D1C9-4292-B237-24ED3DE8B175}';


    IID_ID3D10Effect: TGUID = '{51B0CA8B-EC0B-4519-870D-8EE1CB5017C7}';


    IID_ID3D10EffectPool: TGUID = '{9537AB04-3250-412E-8213-FCD2F8677933}';


const

    IID_ID3D10StateBlock: TGUID = '{0803425A-57F5-4DD6-9465-A87570834A08}';
    IID_ID3D10EffectType: TGUID = '{4E9E1DDC-CD9D-4772-A837-00180B9B88FD}';
    IID_ID3D10EffectVariable: TGUID = '{AE897105-00E6-45BF-BB8E-281DD6DB8E1B}';
    IID_ID3D10EffectScalarVariable: TGUID = '{00E48F7B-D2C8-49E8-A86C-022DEE53431F}';


    //----------------------------------------------------------------------------
    // D3D10_COMPILE & D3D10_EFFECT flags:
    // -------------------------------------

    // These flags are passed in when creating an effect, and affect
    // either compilation behavior or runtime effect behavior

    // D3D10_EFFECT_COMPILE_CHILD_EFFECT
    //   Compile this .fx file to a child effect. Child effects have no initializers
    //   for any shared values as these are initialied in the master effect (pool).

    // D3D10_EFFECT_COMPILE_ALLOW_SLOW_OPS
    //   By default, performance mode is enabled.  Performance mode disallows
    //   mutable state objects by preventing non-literal expressions from appearing in
    //   state object definitions.  Specifying this flag will disable the mode and allow
    //   for mutable state objects.

    // D3D10_EFFECT_SINGLE_THREADED
    //   Do not attempt to synchronize with other threads loading effects into the
    //   same pool.

    //----------------------------------------------------------------------------

    D3D10_EFFECT_COMPILE_CHILD_EFFECT = (1 shl 0);
    D3D10_EFFECT_COMPILE_ALLOW_SLOW_OPS = (1 shl 1);
    D3D10_EFFECT_SINGLE_THREADED = (1 shl 3);


    //----------------------------------------------------------------------------
    // D3D10_EFFECT_VARIABLE flags:
    // ----------------------------

    // These flags describe an effect variable (global or annotation),
    // and are returned in D3D10_EFFECT_VARIABLE_DESC::Flags.

    // D3D10_EFFECT_VARIABLE_POOLED
    //   Indicates that the this variable or constant buffer resides
    //   in an effect pool. If this flag is not set, then the variable resides
    //   in a standalone effect (if ID3D10Effect::GetPool returns NULL)
    //   or a child effect (if ID3D10Effect::GetPool returns non-NULL)

    // D3D10_EFFECT_VARIABLE_ANNOTATION
    //   Indicates that this is an annotation on a technique, pass, or global
    //   variable. Otherwise, this is a global variable. Annotations cannot
    //   be shared.

    // D3D10_EFFECT_VARIABLE_EXPLICIT_BIND_POINT
    //   Indicates that the variable has been explicitly bound using the
    //   register keyword.
    //----------------------------------------------------------------------------

    D3D10_EFFECT_VARIABLE_POOLED = (1 shl 0);
    D3D10_EFFECT_VARIABLE_ANNOTATION = (1 shl 1);
    D3D10_EFFECT_VARIABLE_EXPLICIT_BIND_POINT = (1 shl 2);


type
    PLPCSTR = ^LPCSTR;

    //----------------------------------------------------------------------------
    // D3D10_DEVICE_STATE_TYPES:
    // Used in ID3D10StateBlockMask function calls
    //----------------------------------------------------------------------------


    _D3D10_DEVICE_STATE_TYPES = (
        D3D10_DST_SO_BUFFERS = 1, // Single-value state (atomical gets/sets)
        D3D10_DST_OM_RENDER_TARGETS, // Single-value state (atomical gets/sets)
        D3D10_DST_OM_DEPTH_STENCIL_STATE, // Single-value state
        D3D10_DST_OM_BLEND_STATE, // Single-value state
        D3D10_DST_VS, // Single-value state
        D3D10_DST_VS_SAMPLERS, // Count: D3D10_COMMONSHADER_SAMPLER_SLOT_COUNT
        D3D10_DST_VS_SHADER_RESOURCES, // Count: D3D10_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT
        D3D10_DST_VS_CONSTANT_BUFFERS, // Count:
        D3D10_DST_GS, // Single-value state
        D3D10_DST_GS_SAMPLERS, // Count: D3D10_COMMONSHADER_SAMPLER_SLOT_COUNT
        D3D10_DST_GS_SHADER_RESOURCES, // Count: D3D10_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT
        D3D10_DST_GS_CONSTANT_BUFFERS, // Count: D3D10_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT
        D3D10_DST_PS, // Single-value state
        D3D10_DST_PS_SAMPLERS, // Count: D3D10_COMMONSHADER_SAMPLER_SLOT_COUNT
        D3D10_DST_PS_SHADER_RESOURCES, // Count: D3D10_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT
        D3D10_DST_PS_CONSTANT_BUFFERS, // Count: D3D10_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT
        D3D10_DST_IA_VERTEX_BUFFERS, // Count: D3D10_IA_VERTEX_INPUT_RESOURCE_SLOT_COUNT
        D3D10_DST_IA_INDEX_BUFFER, // Single-value state
        D3D10_DST_IA_INPUT_LAYOUT, // Single-value state
        D3D10_DST_IA_PRIMITIVE_TOPOLOGY, // Single-value state
        D3D10_DST_RS_VIEWPORTS, // Single-value state (atomical gets/sets)
        D3D10_DST_RS_SCISSOR_RECTS, // Single-value state (atomical gets/sets)
        D3D10_DST_RS_RASTERIZER_STATE, // Single-value state
        D3D10_DST_PREDICATION// Single-value state
        );

    TD3D10_DEVICE_STATE_TYPES = _D3D10_DEVICE_STATE_TYPES;
    PD3D10_DEVICE_STATE_TYPES = ^TD3D10_DEVICE_STATE_TYPES;

    //----------------------------------------------------------------------------
    // D3D10_DEVICE_STATE_TYPES:
    // Used in ID3D10StateBlockMask function calls
    //----------------------------------------------------------------------------


    _D3D10_STATE_BLOCK_MASK = record
        VS: byte;
        VSSamplers: array [0..(((D3D10_COMMONSHADER_SAMPLER_SLOT_COUNT) + 7) div 8) - 1] of byte;
        VSShaderResources: array [0..(((D3D10_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT) + 7) div 8) - 1] of byte;
        VSConstantBuffers: array [0..(((D3D10_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT) + 7) div 8) - 1] of byte;
        GS: byte;
        GSSamplers: array [0..(((D3D10_COMMONSHADER_SAMPLER_SLOT_COUNT) + 7) div 8) - 1] of byte;
        GSShaderResources: array [0..(((D3D10_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT) + 7) div 8) - 1] of byte;
        GSConstantBuffers: array [0..(((D3D10_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT) + 7) div 8) - 1] of byte;
        PS: byte;
        PSSamplers: array [0..(((D3D10_COMMONSHADER_SAMPLER_SLOT_COUNT) + 7) div 8) - 1] of byte;
        PSShaderResources: array [0..(((D3D10_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT) + 7) div 8) - 1] of byte;
        PSConstantBuffers: array [0..(((D3D10_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT) + 7) div 8) - 1] of byte;
        IAVertexBuffers: array [0..(((D3D10_IA_VERTEX_INPUT_RESOURCE_SLOT_COUNT) + 7) div 8) - 1] of byte;
        IAIndexBuffer: byte;
        IAInputLayout: byte;
        IAPrimitiveTopology: byte;
        OMRenderTargets: byte;
        OMDepthStencilState: byte;
        OMBlendState: byte;
        RSViewports: byte;
        RSScissorRects: byte;
        RSRasterizerState: byte;
        SOBuffers: byte;
        Predication: byte;
    end;
    TD3D10_STATE_BLOCK_MASK = _D3D10_STATE_BLOCK_MASK;
    PD3D10_STATE_BLOCK_MASK = ^TD3D10_STATE_BLOCK_MASK;


    //////////////////////////////////////////////////////////////////////////////
    // ID3D10StateBlock //////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    ID3D10StateBlock = interface;
    LPD3D10STATEBLOCK = ^ID3D10StateBlock;

    ID3D10StateBlock = interface(IUnknown)
        ['{0803425A-57F5-4dd6-9465-A87570834A08}']
        function Capture(): HRESULT; stdcall;

        function Apply(): HRESULT; stdcall;

        function ReleaseAllDeviceObjects(): HRESULT; stdcall;

        function GetDevice(
        {_Out_  }  out ppDevice: ID3D10Device): HRESULT; stdcall;

    end;


    //----------------------------------------------------------------------------
    // D3D10_STATE_BLOCK_MASK and manipulation functions
    // -------------------------------------------------

    // These functions exist to facilitate working with the D3D10_STATE_BLOCK_MASK
    // structure.

    // D3D10_STATE_BLOCK_MASK *pResult or *pMask
    //   The state block mask to operate on

    // D3D10_STATE_BLOCK_MASK *pA, *pB
    //   The source state block masks for the binary union/intersect/difference
    //   operations.

    // D3D10_DEVICE_STATE_TYPES StateType
    //   The specific state type to enable/disable/query

    // UINT RangeStart, RangeLength, Entry
    //   The specific bit or range of bits for a given state type to operate on.
    //   Consult the comments for D3D10_DEVICE_STATE_TYPES and
    //   D3D10_STATE_BLOCK_MASK for information on the valid bit ranges for
    //   each state.

    //----------------------------------------------------------------------------

    //////////////////////////////////////////////////////////////////////////////
    // ID3D10EffectType //////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    //----------------------------------------------------------------------------
    // D3D10_EFFECT_TYPE_DESC:

    // Retrieved by ID3D10EffectType::GetDesc()
    //----------------------------------------------------------------------------


    _D3D10_EFFECT_TYPE_DESC = record
        TypeName: LPCSTR; // Name of the type
        EffectClass: TD3D10_SHADER_VARIABLE_CLASS; // (e.g. scalar, vector, object, etc.)
        EffectType: TD3D10_SHADER_VARIABLE_TYPE; // (e.g. float, texture, vertexshader, etc.)
        Elements: UINT; // Number of elements in this type
        Members: UINT; // Number of members
        Rows: UINT; // Number of rows in this type
        Columns: UINT; // Number of columns in this type
        PackedSize: UINT; // Number of bytes required to represent
        UnpackedSize: UINT; // Number of bytes occupied by this data
        Stride: UINT; // Number of bytes to seek between elements,
    end;
    TD3D10_EFFECT_TYPE_DESC = _D3D10_EFFECT_TYPE_DESC;
    PD3D10_EFFECT_TYPE_DESC = ^TD3D10_EFFECT_TYPE_DESC;


    {$interfaces corba}
    ID3D10EffectType = interface;
    LPD3D10EFFECTTYPE = ^ID3D10EffectType;

    ID3D10EffectType = interface
        ['{4E9E1DDC-CD9D-4772-A837-00180B9B88FD}']
        function IsValid(): boolean; stdcall;

        function GetDesc(pDesc: PD3D10_EFFECT_TYPE_DESC): HRESULT; stdcall;

        function GetMemberTypeByIndex(Index: UINT): ID3D10EffectType; stdcall;

        function GetMemberTypeByName(Name: LPCSTR): ID3D10EffectType; stdcall;

        function GetMemberTypeBySemantic(Semantic: LPCSTR): ID3D10EffectType; stdcall;

        function GetMemberName(Index: UINT): LPCSTR; stdcall;

        function GetMemberSemantic(Index: UINT): LPCSTR; stdcall;

    end;

    {$interfaces COM}


    //////////////////////////////////////////////////////////////////////////////
    // ID3D10EffectVariable //////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    //----------------------------------------------------------------------------
    // D3D10_EFFECT_VARIABLE_DESC:

    // Retrieved by ID3D10EffectVariable::GetDesc()
    //----------------------------------------------------------------------------


    _D3D10_EFFECT_VARIABLE_DESC = record
        Name: LPCSTR; // Name of this variable, annotation,
        Semantic: LPCSTR; // Semantic string of this variable
        // annotations or if not present)
        Flags: UINT; // D3D10_EFFECT_VARIABLE_* flags
        Annotations: UINT; // Number of annotations on this variable
        // (always 0 for annotations)
        BufferOffset: UINT; // Offset into containing cbuffer or tbuffer
        // (always 0 for annotations or variables
        // not in constant buffers)
        ExplicitBindPoint: UINT; // Used if the variable has been explicitly bound
        // using the register keyword. Check Flags for
        // D3D10_EFFECT_VARIABLE_EXPLICIT_BIND_POINT;
    end;
    TD3D10_EFFECT_VARIABLE_DESC = _D3D10_EFFECT_VARIABLE_DESC;
    PD3D10_EFFECT_VARIABLE_DESC = ^TD3D10_EFFECT_VARIABLE_DESC;


    {$interfaces corba}
    ID3D10EffectVariable = interface;
    LPD3D10EFFECTVARIABLE = ^ID3D10EffectVariable;

    // Forward defines
    ID3D10EffectScalarVariable = interface;
    PID3D10EffectScalarVariable = ^ID3D10EffectScalarVariable;
    LPID3D10EffectScalarVariable = ^ID3D10EffectScalarVariable;

    ID3D10EffectVectorVariable = interface;
    PID3D10EffectVectorVariable = ^ID3D10EffectVectorVariable;
    LPID3D10EffectVectorVariable = ^ID3D10EffectVectorVariable;

    ID3D10EffectMatrixVariable = interface;
    PID3D10EffectMatrixVariable = ^ID3D10EffectMatrixVariable;


    ID3D10EffectStringVariable = interface;
    PID3D10EffectStringVariable = ^ID3D10EffectStringVariable;
    LPID3D10EffectStringVariable = ^ID3D10EffectStringVariable;


    ID3D10EffectShaderResourceVariable = interface;
    PID3D10EffectShaderResourceVariable = ^ID3D10EffectShaderResourceVariable;
    LPID3D10EffectShaderResourceVariable = ^ID3D10EffectShaderResourceVariable;

    ID3D10EffectRenderTargetViewVariable = interface;
    PID3D10EffectRenderTargetViewVariable = ^ID3D10EffectRenderTargetViewVariable;
    LPID3D10EffectRenderTargetViewVariable = ^ID3D10EffectRenderTargetViewVariable;


    ID3D10EffectDepthStencilViewVariable = interface;
    PID3D10EffectDepthStencilViewVariable = ^ID3D10EffectDepthStencilViewVariable;
    LPID3D10EffectDepthStencilViewVariable = ^ID3D10EffectDepthStencilViewVariable;


    ID3D10EffectConstantBuffer = interface;
    PID3D10EffectConstantBuffer = ^ID3D10EffectConstantBuffer;
    LPID3D10EffectConstantBuffer = ^ID3D10EffectConstantBuffer;


    ID3D10EffectShaderVariable = interface;
    PID3D10EffectShaderVariable = ^ID3D10EffectShaderVariable;
    LPID3D10EffectShaderVariable = ^ID3D10EffectShaderVariable;

    ID3D10EffectBlendVariable = interface;
    PID3D10EffectBlendVariable = ^ID3D10EffectBlendVariable;
    LPID3D10EffectBlendVariable = ^ID3D10EffectBlendVariable;

    ID3D10EffectDepthStencilVariable = interface;
    PID3D10EffectDepthStencilVariable = ^ID3D10EffectDepthStencilVariable;
    LPID3D10EffectDepthStencilVariable = ^ID3D10EffectDepthStencilVariable;

    ID3D10EffectRasterizerVariable = interface;
    PID3D10EffectRasterizerVariable = ^ID3D10EffectRasterizerVariable;
    LPID3D10EffectRasterizerVariable = ^ID3D10EffectRasterizerVariable;

    ID3D10EffectSamplerVariable = interface;
    LPD3D10EFFECTSAMPLERVARIABLE = ^ID3D10EffectSamplerVariable;

    ID3D10EffectPass = interface;
    LPD3D10EFFECTPASS = ^ID3D10EffectPass;

    ID3D10EffectVariable = interface
        ['{AE897105-00E6-45bf-BB8E-281DD6DB8E1B}']
        function IsValid(): boolean; stdcall;

        function GetType(): ID3D10EffectType; stdcall;

        function GetDesc(
        {_Out_ } pDesc: PD3D10_EFFECT_VARIABLE_DESC): HRESULT; stdcall;

        function GetAnnotationByIndex(Index: UINT): ID3D10EffectVariable; stdcall;

        function GetAnnotationByName(Name: LPCSTR): ID3D10EffectVariable; stdcall;

        function GetMemberByIndex(Index: UINT): ID3D10EffectVariable; stdcall;

        function GetMemberByName(Name: LPCSTR): ID3D10EffectVariable; stdcall;

        function GetMemberBySemantic(Semantic: LPCSTR): ID3D10EffectVariable; stdcall;

        function GetElement(Index: UINT): ID3D10EffectVariable; stdcall;

        function GetParentConstantBuffer(): ID3D10EffectConstantBuffer; stdcall;

        function AsScalar(): ID3D10EffectScalarVariable; stdcall;

        function AsVector(): ID3D10EffectVectorVariable; stdcall;

        function AsMatrix(): ID3D10EffectMatrixVariable; stdcall;

        function AsString(): ID3D10EffectStringVariable; stdcall;

        function AsShaderResource(): ID3D10EffectShaderResourceVariable; stdcall;

        function AsRenderTargetView(): ID3D10EffectRenderTargetViewVariable; stdcall;

        function AsDepthStencilView(): ID3D10EffectDepthStencilViewVariable; stdcall;

        function AsConstantBuffer(): ID3D10EffectConstantBuffer; stdcall;

        function AsShader(): ID3D10EffectShaderVariable; stdcall;

        function AsBlend(): ID3D10EffectBlendVariable; stdcall;

        function AsDepthStencil(): ID3D10EffectDepthStencilVariable; stdcall;

        function AsRasterizer(): ID3D10EffectRasterizerVariable; stdcall;

        function AsSampler(): ID3D10EffectSamplerVariable; stdcall;

        function SetRawValue(
        {_In_reads_bytes_(ByteCount) } pData: Pvoid; Offset: UINT; ByteCount: UINT): HRESULT; stdcall;

        function GetRawValue(
        {_Out_writes_bytes_(ByteCount) } pData: Pvoid; Offset: UINT; ByteCount: UINT): HRESULT; stdcall;

    end;

    //////////////////////////////////////////////////////////////////////////////
    // ID3D10EffectScalarVariable ////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    ID3D10EffectScalarVariable = interface(ID3D10EffectVariable)
        ['{00E48F7B-D2C8-49e8-A86C-022DEE53431F}']
        function SetFloat(Value: single): HRESULT; stdcall;

        function GetFloat(
        {_Out_ } pValue: Psingle): HRESULT; stdcall;

        function SetFloatArray(
        {_In_reads_(Count) } pData: Psingle; Offset: UINT; Count: UINT): HRESULT; stdcall;

        function GetFloatArray(
        {_Out_writes_(Count) } pData: Psingle; Offset: UINT; Count: UINT): HRESULT; stdcall;

        function SetInt(Value: int32): HRESULT; stdcall;

        function GetInt(
        {_Out_ } pValue: PINT32): HRESULT; stdcall;

        function SetIntArray(
        {_In_reads_(Count) } pData: PINT32; Offset: UINT; Count: UINT): HRESULT; stdcall;

        function GetIntArray(
        {_Out_writes_(Count) } pData: PINT32; Offset: UINT; Count: UINT): HRESULT; stdcall;

        function SetBool(Value: boolean): HRESULT; stdcall;

        function GetBool(
        {_Out_ } pValue: Pboolean): HRESULT; stdcall;

        function SetBoolArray(
        {_In_reads_(Count) } pData: Pboolean; Offset: UINT; Count: UINT): HRESULT; stdcall;

        function GetBoolArray(
        {_Out_writes_(Count) } pData: Pboolean; Offset: UINT; Count: UINT): HRESULT; stdcall;

    end;

    //////////////////////////////////////////////////////////////////////////////
    // ID3D10EffectVectorVariable ////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    ID3D10EffectVectorVariable = interface(ID3D10EffectVariable)
        ['{62B98C44-1F82-4c67-BCD0-72CF8F217E81}']
        function SetBoolVector(pData: Pboolean): HRESULT; stdcall;

        function SetIntVector(pData: PINT32): HRESULT; stdcall;

        function SetFloatVector(pData: Psingle): HRESULT; stdcall;

        function GetBoolVector(pData: Pboolean): HRESULT; stdcall;

        function GetIntVector(pData: PINT32): HRESULT; stdcall;

        function GetFloatVector(pData: Psingle): HRESULT; stdcall;

        function SetBoolVectorArray(pData: Pboolean; Offset: UINT; Count: UINT): HRESULT; stdcall;

        function SetIntVectorArray(pData: PINT32; Offset: UINT; Count: UINT): HRESULT; stdcall;

        function SetFloatVectorArray(pData: Psingle; Offset: UINT; Count: UINT): HRESULT; stdcall;

        function GetBoolVectorArray(pData: Pboolean; Offset: UINT; Count: UINT): HRESULT; stdcall;

        function GetIntVectorArray(pData: PINT32; Offset: UINT; Count: UINT): HRESULT; stdcall;

        function GetFloatVectorArray(pData: Psingle; Offset: UINT; Count: UINT): HRESULT; stdcall;

    end;


    //////////////////////////////////////////////////////////////////////////////
    // ID3D10EffectMatrixVariable ////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////


    ID3D10EffectMatrixVariable = interface(ID3D10EffectVariable)
        ['{50666C24-B82F-4eed-A172-5B6E7E8522E0}']
        function SetMatrix(pData: Psingle): HRESULT; stdcall;

        function GetMatrix(pData: Psingle): HRESULT; stdcall;

        function SetMatrixArray(pData: Psingle; Offset: UINT; Count: UINT): HRESULT; stdcall;

        function GetMatrixArray(pData: Psingle; Offset: UINT; Count: UINT): HRESULT; stdcall;

        function SetMatrixTranspose(pData: Psingle): HRESULT; stdcall;

        function GetMatrixTranspose(pData: Psingle): HRESULT; stdcall;

        function SetMatrixTransposeArray(pData: Psingle; Offset: UINT; Count: UINT): HRESULT; stdcall;

        function GetMatrixTransposeArray(pData: Psingle; Offset: UINT; Count: UINT): HRESULT; stdcall;

    end;


    //////////////////////////////////////////////////////////////////////////////
    // ID3D10EffectStringVariable ////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////


    ID3D10EffectStringVariable = interface(ID3D10EffectVariable)
        ['{71417501-8DF9-4e0a-A78A-255F9756BAFF}']
        function GetString(
        {_Out_ } ppString: LPCSTR): HRESULT; stdcall;

        function GetStringArray(
        {_Out_writes_(Count) } ppStrings: PLPCSTR; Offset: UINT; Count: UINT): HRESULT; stdcall;

    end;


    //////////////////////////////////////////////////////////////////////////////
    // ID3D10EffectShaderResourceVariable ////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////


    ID3D10EffectShaderResourceVariable = interface(ID3D10EffectVariable)
        ['{C0A7157B-D872-4b1d-8073-EFC2ACD4B1FC}']
        function SetResource(
        {_In_opt_ } pResource: ID3D10ShaderResourceView): HRESULT; stdcall;

        function GetResource(
        {_Out_ }  out ppResource: ID3D10ShaderResourceView): HRESULT; stdcall;

        function SetResourceArray(
        {_In_reads_(Count) } ppResources: PID3D10ShaderResourceView; Offset: UINT; Count: UINT): HRESULT; stdcall;

        function GetResourceArray(
        {_Out_writes_(Count) }  out ppResources: PID3D10ShaderResourceView; Offset: UINT; Count: UINT): HRESULT; stdcall;

    end;


    //////////////////////////////////////////////////////////////////////////////
    // ID3D10EffectRenderTargetViewVariable //////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    ID3D10EffectRenderTargetViewVariable = interface(ID3D10EffectVariable)
        ['{28CA0CC3-C2C9-40bb-B57F-67B737122B17}']
        function SetRenderTarget(
        {_In_opt_ } pResource: ID3D10RenderTargetView): HRESULT; stdcall;

        function GetRenderTarget(
        {_Out_ }  out ppResource: ID3D10RenderTargetView): HRESULT; stdcall;

        function SetRenderTargetArray(
        {_In_reads_(Count) } ppResources: PID3D10RenderTargetView; Offset: UINT; Count: UINT): HRESULT; stdcall;

        function GetRenderTargetArray(
        {_Out_writes_(Count) }  out ppResources: PID3D10RenderTargetView; Offset: UINT; Count: UINT): HRESULT; stdcall;

    end;


    //////////////////////////////////////////////////////////////////////////////
    // ID3D10EffectDepthStencilViewVariable //////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    ID3D10EffectDepthStencilViewVariable = interface(ID3D10EffectVariable)
        ['{3E02C918-CC79-4985-B622-2D92AD701623}']
        function SetDepthStencil(
        {_In_opt_ } pResource: ID3D10DepthStencilView): HRESULT; stdcall;

        function GetDepthStencil(
        {_Out_ }  out ppResource: ID3D10DepthStencilView): HRESULT; stdcall;

        function SetDepthStencilArray(
        {_In_reads_(Count) } ppResources: PID3D10DepthStencilView; Offset: UINT; Count: UINT): HRESULT; stdcall;

        function GetDepthStencilArray(
        {_Out_writes_(Count) }  out ppResources: PID3D10DepthStencilView; Offset: UINT; Count: UINT): HRESULT; stdcall;

    end;


    //////////////////////////////////////////////////////////////////////////////
    // ID3D10EffectConstantBuffer ////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////


    ID3D10EffectConstantBuffer = interface(ID3D10EffectVariable)
        ['{56648F4D-CC8B-4444-A5AD-B5A3D76E91B3}']
        function SetConstantBuffer(
        {_In_opt_ } pConstantBuffer: ID3D10Buffer): HRESULT; stdcall;

        function GetConstantBuffer(
        {_Out_ }  out ppConstantBuffer: ID3D10Buffer): HRESULT; stdcall;

        function SetTextureBuffer(
        {_In_opt_ } pTextureBuffer: ID3D10ShaderResourceView): HRESULT; stdcall;

        function GetTextureBuffer(
        {_Out_ }  out ppTextureBuffer: ID3D10ShaderResourceView): HRESULT; stdcall;

    end;


    //////////////////////////////////////////////////////////////////////////////
    // ID3D10EffectShaderVariable ////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    //----------------------------------------------------------------------------
    // D3D10_EFFECT_SHADER_DESC:

    // Retrieved by ID3D10EffectShaderVariable::GetShaderDesc()
    //----------------------------------------------------------------------------


    _D3D10_EFFECT_SHADER_DESC = record
        pInputSignature: pbyte; // Passed into CreateInputLayout,
        IsInline: winbool; // Is this an anonymous shader variable
        // -- The following fields are not valid after Optimize() --
        pBytecode: pbyte; // Shader bytecode
        BytecodeLength: UINT;
        SODecl: LPCSTR; // Stream out declaration string (for GS with SO)
        NumInputSignatureEntries: UINT; // Number of entries in the input signature
        NumOutputSignatureEntries: UINT; // Number of entries in the output signature
    end;
    TD3D10_EFFECT_SHADER_DESC = _D3D10_EFFECT_SHADER_DESC;
    PD3D10_EFFECT_SHADER_DESC = ^TD3D10_EFFECT_SHADER_DESC;


    ID3D10EffectShaderVariable = interface(ID3D10EffectVariable)
        ['{80849279-C799-4797-8C33-0407A07D9E06}']
        function GetShaderDesc(ShaderIndex: UINT;
        {_Out_ } pDesc: PD3D10_EFFECT_SHADER_DESC): HRESULT; stdcall;

        function GetVertexShader(ShaderIndex: UINT;
        {_Out_ }  out ppVS: ID3D10VertexShader): HRESULT; stdcall;

        function GetGeometryShader(ShaderIndex: UINT;
        {_Out_ }  out ppGS: ID3D10GeometryShader): HRESULT; stdcall;

        function GetPixelShader(ShaderIndex: UINT;
        {_Out_ }  out ppPS: ID3D10PixelShader): HRESULT; stdcall;

        function GetInputSignatureElementDesc(ShaderIndex: UINT; Element: UINT;
        {_Out_ } pDesc: PD3D10_SIGNATURE_PARAMETER_DESC): HRESULT; stdcall;

        function GetOutputSignatureElementDesc(ShaderIndex: UINT; Element: UINT;
        {_Out_ } pDesc: PD3D10_SIGNATURE_PARAMETER_DESC): HRESULT; stdcall;

    end;


    //////////////////////////////////////////////////////////////////////////////
    // ID3D10EffectBlendVariable /////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////


    ID3D10EffectBlendVariable = interface(ID3D10EffectVariable)
        ['{1FCD2294-DF6D-4eae-86B3-0E9160CFB07B}']
        function GetBlendState(Index: UINT; out ppBlendState: ID3D10BlendState): HRESULT; stdcall;

        function GetBackingStore(Index: UINT; pBlendDesc: PD3D10_BLEND_DESC): HRESULT; stdcall;

    end;


    //////////////////////////////////////////////////////////////////////////////
    // ID3D10EffectDepthStencilVariable //////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////


    ID3D10EffectDepthStencilVariable = interface(ID3D10EffectVariable)
        ['{AF482368-330A-46a5-9A5C-01C71AF24C8D}']
        function GetDepthStencilState(Index: UINT;
        {_Out_ }  out ppDepthStencilState: ID3D10DepthStencilState): HRESULT; stdcall;

        function GetBackingStore(Index: UINT;
        {_Out_ } pDepthStencilDesc: PD3D10_DEPTH_STENCIL_DESC): HRESULT; stdcall;

    end;


    //////////////////////////////////////////////////////////////////////////////
    // ID3D10EffectRasterizerVariable ////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////


    ID3D10EffectRasterizerVariable = interface(ID3D10EffectVariable)
        ['{21AF9F0E-4D94-4ea9-9785-2CB76B8C0B34}']
        function GetRasterizerState(Index: UINT;
        {_Out_ }  out ppRasterizerState: ID3D10RasterizerState): HRESULT; stdcall;

        function GetBackingStore(Index: UINT;
        {_Out_ } pRasterizerDesc: PD3D10_RASTERIZER_DESC): HRESULT; stdcall;

    end;


    //////////////////////////////////////////////////////////////////////////////
    // ID3D10EffectSamplerVariable ///////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////


    ID3D10EffectSamplerVariable = interface(ID3D10EffectVariable)
        ['{6530D5C7-07E9-4271-A418-E7CE4BD1E480}']
        function GetSampler(Index: UINT;
        {_Out_ }  out ppSampler: ID3D10SamplerState): HRESULT; stdcall;

        function GetBackingStore(Index: UINT;
        {_Out_ } pSamplerDesc: PD3D10_SAMPLER_DESC): HRESULT; stdcall;

    end;


    //////////////////////////////////////////////////////////////////////////////
    // ID3D10EffectPass //////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    //----------------------------------------------------------------------------
    // D3D10_PASS_DESC:

    // Retrieved by ID3D10EffectPass::GetDesc()
    //----------------------------------------------------------------------------


    _D3D10_PASS_DESC = record
        Name: LPCSTR; // Name of this pass (NULL if not anonymous)
        Annotations: UINT; // Number of annotations on this pass
        pIAInputSignature: pbyte; // Signature from VS or GS (if there is no VS)
        IAInputSignatureSize: SIZE_T; // Singature size in bytes
        StencilRef: UINT; // Specified in SetDepthStencilState()
        SampleMask: UINT; // Specified in SetBlendState()
        BlendFactor: array [0..4 - 1] of single; // Specified in SetBlendState()
    end;
    TD3D10_PASS_DESC = _D3D10_PASS_DESC;
    PD3D10_PASS_DESC = ^TD3D10_PASS_DESC;


    //----------------------------------------------------------------------------
    // D3D10_PASS_SHADER_DESC:

    // Retrieved by ID3D10EffectPass::Get**ShaderDesc()
    //----------------------------------------------------------------------------

    _D3D10_PASS_SHADER_DESC = record
        pShaderVariable: PID3D10EffectShaderVariable; // The variable that this shader came from.
        //   the returned interface will be an
        //   anonymous shader variable, which is
        //   not retrievable any other way.  It's
        //   name in the variable description will
        //   be "$Anonymous".
        // If there is no assignment of this type in
        //   the pass block, pShaderVariable != NULL,
        //   but pShaderVariable->IsValid() == FALSE.
        ShaderIndex: UINT; // The element of pShaderVariable (if an array)
        // or 0 if not applicable
    end;
    TD3D10_PASS_SHADER_DESC = _D3D10_PASS_SHADER_DESC;
    PD3D10_PASS_SHADER_DESC = ^TD3D10_PASS_SHADER_DESC;


    ID3D10EffectPass = interface
        function IsValid(): boolean; stdcall;

        function GetDesc(pDesc: PD3D10_PASS_DESC): HRESULT; stdcall;

        function GetVertexShaderDesc(pDesc: PD3D10_PASS_SHADER_DESC): HRESULT; stdcall;

        function GetGeometryShaderDesc(pDesc: PD3D10_PASS_SHADER_DESC): HRESULT; stdcall;

        function GetPixelShaderDesc(pDesc: PD3D10_PASS_SHADER_DESC): HRESULT; stdcall;

        function GetAnnotationByIndex(Index: UINT): ID3D10EffectVariable; stdcall;

        function GetAnnotationByName(Name: LPCSTR): ID3D10EffectVariable; stdcall;

        function Apply(Flags: UINT): HRESULT; stdcall;

        function ComputeStateBlockMask(
        {_Out_ } pStateBlockMask: PD3D10_STATE_BLOCK_MASK): HRESULT; stdcall;

    end;


    //////////////////////////////////////////////////////////////////////////////
    // ID3D10EffectTechnique /////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    //----------------------------------------------------------------------------
    // D3D10_TECHNIQUE_DESC:

    // Retrieved by ID3D10EffectTechnique::GetDesc()
    //----------------------------------------------------------------------------


    _D3D10_TECHNIQUE_DESC = record
        Name: LPCSTR; // Name of this technique (NULL if not anonymous)
        Passes: UINT; // Number of passes contained within
        Annotations: UINT; // Number of annotations on this technique
    end;
    TD3D10_TECHNIQUE_DESC = _D3D10_TECHNIQUE_DESC;
    PD3D10_TECHNIQUE_DESC = ^TD3D10_TECHNIQUE_DESC;


    {$interfaces corba}
    ID3D10EffectTechnique = interface;
    LPD3D10EFFECTTECHNIQUE = ^ID3D10EffectTechnique;

    ID3D10EffectTechnique = interface
        function IsValid(): boolean; stdcall;

        function GetDesc(pDesc: PD3D10_TECHNIQUE_DESC): HRESULT; stdcall;

        function GetAnnotationByIndex(Index: UINT): ID3D10EffectVariable; stdcall;

        function GetAnnotationByName(Name: LPCSTR): ID3D10EffectVariable; stdcall;

        function GetPassByIndex(Index: UINT): ID3D10EffectPass; stdcall;

        function GetPassByName(Name: LPCSTR): ID3D10EffectPass; stdcall;

        function ComputeStateBlockMask(
        {_Out_ } pStateBlockMask: PD3D10_STATE_BLOCK_MASK): HRESULT; stdcall;

    end;

    {$interfaces COM}


    //////////////////////////////////////////////////////////////////////////////
    // ID3D10Effect //////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    //----------------------------------------------------------------------------
    // D3D10_EFFECT_DESC:

    // Retrieved by ID3D10Effect::GetDesc()
    //----------------------------------------------------------------------------


    _D3D10_EFFECT_DESC = record
        IsChildEffect: boolean; // TRUE if this is a child effect,
        ConstantBuffers: UINT; // Number of constant buffers in this effect,
        SharedConstantBuffers: UINT; // Number of constant buffers shared in this
        GlobalVariables: UINT; // Number of global variables in this effect,
        SharedGlobalVariables: UINT; // Number of global variables shared in this
        Techniques: UINT; // Number of techniques in this effect,
    end;
    TD3D10_EFFECT_DESC = _D3D10_EFFECT_DESC;
    PD3D10_EFFECT_DESC = ^TD3D10_EFFECT_DESC;


    ID3D10Effect = interface(IUnknown)
        ['{51B0CA8B-EC0B-4519-870D-8EE1CB5017C7}']
        function IsValid(): boolean; stdcall;

        function IsPool(): boolean; stdcall;

        // Managing D3D Device
        function GetDevice(
        {_Out_ }  out ppDevice: ID3D10Device): HRESULT; stdcall;

        // New Reflection APIs
        function GetDesc(
        {_Out_ } pDesc: PD3D10_EFFECT_DESC): HRESULT; stdcall;

        function GetConstantBufferByIndex(Index: UINT): ID3D10EffectConstantBuffer; stdcall;

        function GetConstantBufferByName(Name: LPCSTR): ID3D10EffectConstantBuffer; stdcall;

        function GetVariableByIndex(Index: UINT): ID3D10EffectVariable; stdcall;

        function GetVariableByName(Name: LPCSTR): ID3D10EffectVariable; stdcall;

        function GetVariableBySemantic(Semantic: LPCSTR): ID3D10EffectVariable; stdcall;

        function GetTechniqueByIndex(Index: UINT): ID3D10EffectTechnique; stdcall;

        function GetTechniqueByName(Name: LPCSTR): ID3D10EffectTechnique; stdcall;

        function Optimize(): HRESULT; stdcall;

        function IsOptimized(): boolean; stdcall;

    end;


    //////////////////////////////////////////////////////////////////////////////
    // ID3D10EffectPool //////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////


    ID3D10EffectPool = interface(IUnknown)
        ['{9537AB04-3250-412e-8213-FCD2F8677933}']
        function AsEffect(): ID3D10Effect; stdcall;
    end;


    //////////////////////////////////////////////////////////////////////////////
    // APIs //////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////


function D3D10StateBlockMaskUnion(
    {_In_ } pA: PD3D10_STATE_BLOCK_MASK;
    {_In_ } pB: PD3D10_STATE_BLOCK_MASK;
    {_Out_ } pResult: PD3D10_STATE_BLOCK_MASK): HRESULT; stdcall; external D3D10_DLL;

function D3D10StateBlockMaskIntersect(
    {_In_ } pA: PD3D10_STATE_BLOCK_MASK;
    {_In_ } pB: PD3D10_STATE_BLOCK_MASK;
    {_Out_ } pResult: PD3D10_STATE_BLOCK_MASK): HRESULT; stdcall; external D3D10_DLL;

function D3D10StateBlockMaskDifference(
    {_In_ } pA: PD3D10_STATE_BLOCK_MASK;
    {_In_ } pB: PD3D10_STATE_BLOCK_MASK;
    {_Out_ } pResult: PD3D10_STATE_BLOCK_MASK): HRESULT; stdcall; external D3D10_DLL;

function D3D10StateBlockMaskEnableCapture(
    {_Inout_ } pMask: PD3D10_STATE_BLOCK_MASK; StateType: TD3D10_DEVICE_STATE_TYPES; RangeStart: UINT; RangeLength: UINT): HRESULT; stdcall; external D3D10_DLL;

function D3D10StateBlockMaskDisableCapture(
    {_Inout_ } pMask: PD3D10_STATE_BLOCK_MASK; StateType: TD3D10_DEVICE_STATE_TYPES; RangeStart: UINT; RangeLength: UINT): HRESULT; stdcall; external D3D10_DLL;

function D3D10StateBlockMaskEnableAll(
    {_Out_ } pMask: PD3D10_STATE_BLOCK_MASK): HRESULT; stdcall; external D3D10_DLL;

function D3D10StateBlockMaskDisableAll(
    {_Out_ } pMask: PD3D10_STATE_BLOCK_MASK): HRESULT; stdcall; external D3D10_DLL;

function D3D10StateBlockMaskGetSetting(
    {_In_ } pMask: PD3D10_STATE_BLOCK_MASK; StateType: TD3D10_DEVICE_STATE_TYPES; Entry: UINT): boolean; stdcall; external D3D10_DLL;


//----------------------------------------------------------------------------
// D3D10CreateStateBlock
// ---------------------

// Creates a state block object based on the mask settings specified
//   in a D3D10_STATE_BLOCK_MASK structure.

// ID3D10Device *pDevice
//      The device interface to associate with this state block

// D3D10_STATE_BLOCK_MASK *pStateBlockMask
//      A bit mask whose settings are used to generate a state block
//      object.

// ID3D10StateBlock **ppStateBlock
//      The resulting state block object.  This object will save/restore
//      only those pieces of state that were set in the state block
//      bit mask
//----------------------------------------------------------------------------

function D3D10CreateStateBlock(
    {_In_ } pDevice: ID3D10Device;
    {_In_ } pStateBlockMask: PD3D10_STATE_BLOCK_MASK;
    {_Out_ }  out ppStateBlock: ID3D10StateBlock): HRESULT; stdcall; external D3D10_DLL;


//----------------------------------------------------------------------------
// D3D10CreateEffectFromXXXX:
// --------------------------
// Creates an effect from a binary effect or file

// Parameters:

// [in]


//  pData
//      Blob of effect data, either ASCII (uncompiled, for D3D10CompileEffectFromMemory) or binary (compiled, for D3D10CreateEffect*)
//  DataLength
//      Length of the data blob

//  pSrcFileName
//      Name of the ASCII Effect file pData was obtained from

//  pDefines
//      Optional NULL-terminated array of preprocessor macro definitions.
//  pInclude
//      Optional interface pointer to use for handling #include directives.
//      If this parameter is NULL, #includes will be honored when compiling
//      from file, and will error when compiling from resource or memory.
//  HLSLFlags
//      Compilation flags pertaining to shaders and data types, honored by
//      the HLSL compiler
//  FXFlags
//      Compilation flags pertaining to Effect compilation, honored
//      by the Effect compiler
//  pDevice
//      Pointer to the D3D10 device on which to create Effect resources
//  pEffectPool
//      Pointer to an Effect pool to share variables with or NULL

// [out]

//  ppEffect
//      Address of the newly created Effect interface
//  ppEffectPool
//      Address of the newly created Effect pool interface
//  ppErrors
//      If non-NULL, address of a buffer with error messages that occurred
//      during parsing or compilation

//----------------------------------------------------------------------------

function D3D10CompileEffectFromMemory(
    {_In_reads_bytes_(DataLength) } pData: Pvoid; DataLength: SIZE_T; pSrcFileName: LPCSTR;
    {_In_opt_ } pDefines: PD3D10_SHADER_MACRO;
    {_In_opt_ } pInclude: ID3D10Include; HLSLFlags: UINT; FXFlags: UINT;
    {_Out_ }  out ppCompiledEffect: ID3D10Blob;
    {_Out_opt_ }  out ppErrors: ID3D10Blob): HRESULT; stdcall; external D3D10_DLL;


function D3D10CreateEffectFromMemory(
    {_In_reads_bytes_(DataLength) } pData: Pvoid; DataLength: SIZE_T; FXFlags: UINT;
    {_In_ } pDevice: ID3D10Device;
    {_In_opt_ } pEffectPool: ID3D10EffectPool;
    {_Out_ }  out ppEffect: ID3D10Effect): HRESULT; stdcall; external D3D10_DLL;


function D3D10CreateEffectPoolFromMemory(
    {_In_reads_bytes_(DataLength) } pData: Pvoid; DataLength: SIZE_T; FXFlags: UINT;
    {_In_ } pDevice: ID3D10Device;
    {_Out_ }  out ppEffectPool: ID3D10EffectPool): HRESULT; stdcall; external D3D10_DLL;


//----------------------------------------------------------------------------
// D3D10DisassembleEffect:
// -----------------------
// Takes an effect interface, and returns a buffer containing text assembly.

// Parameters:
//  pEffect
//      Pointer to the runtime effect interface.
//  EnableColorCode
//      Emit HTML tags for color coding the output?
//  ppDisassembly
//      Returns a buffer containing the disassembled effect.
//----------------------------------------------------------------------------

function D3D10DisassembleEffect(
    {_In_ } pEffect: ID3D10Effect; EnableColorCode: boolean;
    {_Out_ }  out ppDisassembly: ID3D10Blob): HRESULT; stdcall; external D3D10_DLL;


implementation

end.
