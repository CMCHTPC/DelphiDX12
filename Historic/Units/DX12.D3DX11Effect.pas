unit DX12.D3DX11Effect;

(* --------------------------------------------------------------------------------------
// File: D3DX11Effect.h
//
// Direct3D 11 Effect Types & APIs Header
//
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//
// http://go.microsoft.com/fwlink/p/?LinkId=271568
//--------------------------------------------------------------------------------------

//////////////////////////////////////////////////////////////////////////////
// File contents:
//
// 1) Stateblock enums, structs, interfaces, flat APIs
// 2) Effect enums, structs, interfaces, flat APIs
//////////////////////////////////////////////////////////////////////////////
*)

{$IFDEF FPC}
{$MODE delphi}{$H+}
{$ENDIF}


interface

{$Z4}

uses
    Windows, Classes, SysUtils,
    DX12.D3D11, DX12.D3DCommon, DX12.D3DX10;

const
    DLL_D3DX11Effects = 'd3dx11Effects.dll';

const
    IID_ID3DX11EffectType: TGUID = '{4250D721-D5E5-491F-B62B-587C43186285}';
    IID_ID3DX11EffectVariable: TGUID = '{036A777D-B56E-4B25-B313-CC3DDAB71873}';
    IID_ID3DX11EffectScalarVariable: TGUID = '{921EF2E5-A65D-4E92-9FC6-4E9CC09A4ADE}';
    IID_ID3DX11EffectVectorVariable: TGUID = '{5E785D4A-D87B-48D8-B6E6-0F8CA7E7467A}';
    IID_ID3DX11EffectMatrixVariable: TGUID = '{E1096CF4-C027-419A-8D86-D29173DC803E}';
    IID_ID3DX11EffectStringVariable: TGUID = '{F355C818-01BE-4653-A7CC-60FFFEDDC76D}';
    IID_ID3DX11EffectClassInstanceVariable: TGUID = '{926A8053-2A39-4DB4-9BDE-CF649ADEBDC1}';
    IID_ID3DX11EffectInterfaceVariable: TGUID = '{516C8CD8-1C80-40A4-B19B-0688792F11A5}';
    IID_ID3DX11EffectShaderResourceVariable: TGUID = '{350DB233-BBE0-485C-9BFE-C0026B844F89}';
    IID_ID3DX11EffectUnorderedAccessViewVariable: TGUID = '{79B4AC8C-870A-47D2-B05A-8BD5CC3EE6C9}';
    IID_ID3DX11EffectRenderTargetViewVariable: TGUID = '{D5066909-F40C-43F8-9DB5-057C2A208552}';
    IID_ID3DX11EffectDepthStencilViewVariable: TGUID = '{33C648AC-2E9E-4A2E-9CD6-DE31ACC5B347}';
    IID_ID3DX11EffectConstantBuffer: TGUID = '{2CB6C733-82D2-4000-B3DA-6219D9A99BF2}';
    IID_ID3DX11EffectShaderVariable: TGUID = '{7508B344-020A-4EC7-9118-62CDD36C88D7}';
    IID_ID3DX11EffectBlendVariable: TGUID = '{D664F4D7-3B81-4805-B277-C1DF58C39F53}';
    IID_ID3DX11EffectDepthStencilVariable: TGUID = '{69B5751B-61A5-48E5-BD41-D93988111563}';
    IID_ID3DX11EffectRasterizerVariable: TGUID = '{53A262F6-5F74-4151-A132-E3DD19A62C9D}';
    IID_ID3DX11EffectSamplerVariable: TGUID = '{C6402E55-1095-4D95-8931-F92660513DD9}';
    IID_ID3DX11EffectPass: TGUID = '{3437CEC4-4AC1-4D87-8916-F4BD5A41380C}';
    IID_ID3DX11EffectTechnique: TGUID = '{51198831-1F1D-4F47-BD76-41CB0835B1DE}';
    IID_ID3DX11EffectGroup: TGUID = '{03074acf-97de-485f-b201-cb775264afd6}';
    IID_ID3DX11Effect: TGUID = '{FA61CA24-E4BA-4262-9DB8-B132E8CAE319}';

const
    D3DERR_INVALIDCALL: HRESULT = (1 shl 31) or ($876 shl 16) or (2156);

type
    TBoolVector = array[0..3] of boolean;
    PBoolVector = ^TBoolVector;

    TIntVector = array[0..3] of integer;
    PIntVector = ^TIntVector;

    TFloatVector = array[0..3] of single;
    PFloatVector = ^TFloatVector;

  {  TFloatMatrix = array[0..15] of single;
    PFloatMatrix = ^TFloatMatrix; }

type
    TD3DX11_STATE_BLOCK_MASK = record
        VS: byte;
        VSSamplers: array [0..((D3D11_COMMONSHADER_SAMPLER_SLOT_COUNT + 7) div 8)] of byte;
        VSShaderResources: array [0..((D3D11_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT + 7) div 8)] of byte;
        VSConstantBuffers: array [0..((D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT + 7) div 8)] of byte;
        VSInterfaces: array [0..((D3D11_SHADER_MAX_INTERFACES + 7) div 8)] of byte;

        HS: byte;
        HSSamplers: array [0..((D3D11_COMMONSHADER_SAMPLER_SLOT_COUNT + 7) div 8)] of byte;
        HSShaderResources: array [0..((D3D11_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT + 7) div 8)] of byte;
        HSConstantBuffers: array [0..((D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT + 7) div 8)] of byte;
        HSInterfaces: array [0..((D3D11_SHADER_MAX_INTERFACES + 7) div 8)] of byte;

        DS: byte;
        DSSamplers: array [0..((D3D11_COMMONSHADER_SAMPLER_SLOT_COUNT + 7) div 8)] of byte;
        DSShaderResources: array [0..((D3D11_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT + 7) div 8)] of byte;
        DSConstantBuffers: array [0..((D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT + 7) div 8)] of byte;
        DSInterfaces: array [0..((D3D11_SHADER_MAX_INTERFACES + 7) div 8)] of byte;

        GS: byte;
        GSSamplers: array [0..((D3D11_COMMONSHADER_SAMPLER_SLOT_COUNT + 7) div 8)] of byte;
        GSShaderResources: array [0..((D3D11_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT + 7) div 8)] of byte;
        GSConstantBuffers: array [0..((D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT + 7) div 8)] of byte;
        GSInterfaces: array [0..((D3D11_SHADER_MAX_INTERFACES + 7) div 8)] of byte;

        PS: byte;
        PSSamplers: array [0..((D3D11_COMMONSHADER_SAMPLER_SLOT_COUNT + 7) div 8)] of byte;
        PSShaderResources: array [0..((D3D11_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT + 7) div 8)] of byte;
        PSConstantBuffers: array [0..((D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT + 7) div 8)] of byte;
        PSInterfaces: array [0..((D3D11_SHADER_MAX_INTERFACES + 7) div 8)] of byte;
        PSUnorderedAccessViews: byte;

        CS: byte;
        CSSamplers: array [0..((D3D11_COMMONSHADER_SAMPLER_SLOT_COUNT + 7) div 8)] of byte;
        CSShaderResources: array [0..((D3D11_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT + 7) div 8)] of byte;
        CSConstantBuffers: array [0..((D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT + 7) div 8)] of byte;
        CSInterfaces: array [0..((D3D11_SHADER_MAX_INTERFACES + 7) div 8)] of byte;
        CSUnorderedAccessViews: byte;

        IAVertexBuffers: array [0..((D3D11_IA_VERTEX_INPUT_RESOURCE_SLOT_COUNT + 7) div 8)] of byte;
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



//----------------------------------------------------------------------------
// D3DX11_EFFECT flags:
// -------------------------------------

// These flags are passed in when creating an effect, and affect
// the runtime effect behavior:

// (Currently none)


// These flags are set by the effect runtime:

// D3DX11_EFFECT_OPTIMIZED
//   This effect has been optimized. Reflection functions that rely on
//   names/semantics/strings should fail. This is set when Optimize() is
//   called, but CEffect::IsOptimized() should be used to test for this.

// D3DX11_EFFECT_CLONE
//   This effect is a clone of another effect. Single CBs will never be
//   updated when internal variable values are changed.
//   This flag is not set when the D3DX11_EFFECT_CLONE_FORCE_NONSINGLE flag
//   is used in cloning.

//----------------------------------------------------------------------------

const
    D3DX11_EFFECT_OPTIMIZED = (1 shl 21);
    D3DX11_EFFECT_CLONE = (1 shl 22);

    // Mask of valid D3DCOMPILE_EFFECT flags for D3DX11CreateEffect*
    D3DX11_EFFECT_RUNTIME_VALID_FLAGS = (0);

    //----------------------------------------------------------------------------
    // D3DX11_EFFECT_VARIABLE flags:
    // ----------------------------

    // These flags describe an effect variable (global or annotation),
    // and are returned in D3DX11_EFFECT_VARIABLE_DESC::Flags.

    // D3DX11_EFFECT_VARIABLE_ANNOTATION
    //   Indicates that this is an annotation on a technique, pass, or global
    //   variable. Otherwise, this is a global variable. Annotations cannot
    //   be shared.

    // D3DX11_EFFECT_VARIABLE_EXPLICIT_BIND_POINT
    //   Indicates that the variable has been explicitly bound using the
    //   register keyword.
    //----------------------------------------------------------------------------

    D3DX11_EFFECT_VARIABLE_ANNOTATION = (1 shl 1);
    D3DX11_EFFECT_VARIABLE_EXPLICIT_BIND_POINT = (1 shl 2);

    //----------------------------------------------------------------------------
    // D3DX11_EFFECT_CLONE flags:
    // ----------------------------

    // These flags modify the effect cloning process and are passed into Clone.

    // D3DX11_EFFECT_CLONE_FORCE_NONSINGLE
    //   Ignore all "single" qualifiers on cbuffers.  All cbuffers will have their
    //   own ID3D11Buffer's created in the cloned effect.
    //----------------------------------------------------------------------------

    D3DX11_EFFECT_CLONE_FORCE_NONSINGLE = (1 shl 0);


//////////////////////////////////////////////////////////////////////////////
// ID3DX11EffectType //////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

//----------------------------------------------------------------------------
// D3DX11_EFFECT_TYPE_DESC:

// Retrieved by ID3DX11EffectType::GetDesc()
//----------------------------------------------------------------------------

type
    TD3DX11_EFFECT_TYPE_DESC = record
        TypeName: PAnsiChar;               // Name of the type e.g. "float4" or "MyStruct")
        AClass: TD3D_SHADER_VARIABLE_CLASS;  // (e.g. scalar, vector, object, etc.)
        AType: TD3D_SHADER_VARIABLE_TYPE;   // (e.g.  single , texture, vertexshader, etc.)
        Elements: UINT32;           // Number of elements in this type, (0 if not an array)
        Members: UINT32;            // Number of members, (0 if not a structure)
        Rows: UINT32;               // Number of rows in this type, (0 if not a numeric primitive)
        Columns: UINT32;            // Number of columns in this type, (0 if not a numeric primitive)
        PackedSize: UINT32;         // Number of bytes required to represent this data type, when tightly packed
        UnpackedSize: UINT32;       // Number of bytes occupied by this data type, when laid out in a constant buffer
        Stride: UINT32;             // Number of bytes to seek between elements, when laid out in a constant buffer
    end;


    // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11EffectType = interface
        ['{4250D721-D5E5-491F-B62B-587C43186285}']
        // IUnknown
        // ID3DX11EffectType
        function IsValid(): boolean; stdcall;
        function GetDesc(out pDesc: TD3DX11_EFFECT_TYPE_DESC): HResult; stdcall;
        function GetMemberTypeByIndex(Index: UINT32): ID3DX11EffectType; stdcall;
        function GetMemberTypeByName(Name: LPCSTR): ID3DX11EffectType; stdcall;
        function GetMemberTypeBySemantic(Semantic: LPCSTR): ID3DX11EffectType; stdcall;
        function GetMemberName(Index: UINT32): LPCSTR; stdcall;
        function GetMemberSemantic(Index: UINT32): LPCSTR; stdcall;
    end;
    {$interfaces com}
    {$ELSE}
    ID3DX11EffectType = class

    end;
    {$ENDIF}

    PID3DX11EffectType = ^ID3DX11EffectType;



    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11EffectVariable //////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    //----------------------------------------------------------------------------
    // D3DX11_EFFECT_VARIABLE_DESC:

    // Retrieved by ID3DX11EffectVariable::GetDesc()
    //----------------------------------------------------------------------------

    TD3DX11_EFFECT_VARIABLE_DESC = record
        Name: PAnsiChar;               // Name of this variable, annotation,  or structure member
        Semantic: PAnsiChar;           // Semantic string of this variable or structure member (nullptr for  annotations or if not present)
        Flags: UINT32;              // D3DX11_EFFECT_VARIABLE_* flags
        Annotations: UINT32;        // Number of annotations on this variable (always 0 for annotations)
        BufferOffset: UINT32;       // Offset into containing cbuffer or tbuffer (always 0 for annotations or variables not in constant buffers)
        ExplicitBindPoint: UINT32;
        // Used if the variable has been explicitly bound using the register keyword. Check Flags D3DX11_EFFECT_VARIABLE_EXPLICIT_BIND_POINT;
    end;




    // Forward defines
    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11EffectScalarVariable = interface;
    ID3DX11EffectVectorVariable = interface;
    ID3DX11EffectMatrixVariable = interface;
    ID3DX11EffectStringVariable = interface;
    ID3DX11EffectClassInstanceVariable = interface;
    ID3DX11EffectInterfaceVariable = interface;
    ID3DX11EffectShaderResourceVariable = interface;
    ID3DX11EffectUnorderedAccessViewVariable = interface;
    ID3DX11EffectRenderTargetViewVariable = interface;
    ID3DX11EffectDepthStencilViewVariable = interface;
    ID3DX11EffectConstantBuffer = interface;
    ID3DX11EffectShaderVariable = interface;
    ID3DX11EffectBlendVariable = interface;
    ID3DX11EffectDepthStencilVariable = interface;
    ID3DX11EffectRasterizerVariable = interface;
    ID3DX11EffectSamplerVariable = interface;
    {$interfaces com}
    {$ELSE}
    ID3DX11EffectScalarVariable = class;
    ID3DX11EffectVectorVariable = class;
    ID3DX11EffectMatrixVariable = class;
    ID3DX11EffectStringVariable = class;
    ID3DX11EffectClassInstanceVariable = class;
    ID3DX11EffectInterfaceVariable = class;
    ID3DX11EffectShaderResourceVariable = class;
    ID3DX11EffectUnorderedAccessViewVariable = class;
    ID3DX11EffectRenderTargetViewVariable = class;
    ID3DX11EffectDepthStencilViewVariable = class;
    ID3DX11EffectConstantBuffer = class;
    ID3DX11EffectShaderVariable = class;
    ID3DX11EffectBlendVariable = class;
    ID3DX11EffectDepthStencilVariable = class;
    ID3DX11EffectRasterizerVariable = class;
    ID3DX11EffectSamplerVariable = class;
    {$ENDIF}

    // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11EffectVariable = interface
        ['{036A777D-B56E-4B25-B313-CC3DDAB71873}']
        // IUnknown

        // ID3DX11EffectVariable
        function IsValid(): boolean; stdcall;
        function GetType(): ID3DX11EffectType; stdcall;
        function GetDesc(out pDesc: TD3DX11_EFFECT_VARIABLE_DESC): HResult; stdcall;
        function GetAnnotationByIndex(Index: UINT32): ID3DX11EffectVariable; stdcall;
        function GetAnnotationByName(Name: LPCSTR): ID3DX11EffectVariable; stdcall;
        function GetMemberByIndex(Index: UINT32): ID3DX11EffectVariable; stdcall;
        function GetMemberByName(Name: LPCSTR): ID3DX11EffectVariable; stdcall;
        function GetMemberBySemantic(Semantic: LPCSTR): ID3DX11EffectVariable; stdcall;
        function GetElement(Index: UINT32): ID3DX11EffectVariable; stdcall;
        function GetParentConstantBuffer(): ID3DX11EffectConstantBuffer; stdcall;
        function AsScalar(): ID3DX11EffectScalarVariable; stdcall;
        function AsVector(): ID3DX11EffectVectorVariable; stdcall;
        function AsMatrix(): ID3DX11EffectMatrixVariable; stdcall;
        function AsString(): ID3DX11EffectStringVariable; stdcall;
        function AsClassInstance(): ID3DX11EffectClassInstanceVariable; stdcall;
        function AsInterface(): ID3DX11EffectInterfaceVariable; stdcall;
        function AsShaderResource(): ID3DX11EffectShaderResourceVariable; stdcall;
        function AsUnorderedAccessView(): ID3DX11EffectUnorderedAccessViewVariable; stdcall;
        function AsRenderTargetView(): ID3DX11EffectRenderTargetViewVariable; stdcall;
        function AsDepthStencilView(): ID3DX11EffectDepthStencilViewVariable; stdcall;
        function AsConstantBuffer(): ID3DX11EffectConstantBuffer; stdcall;
        function AsShader(): ID3DX11EffectShaderVariable; stdcall;
        function AsBlend(): ID3DX11EffectBlendVariable; stdcall;
        function AsDepthStencil(): ID3DX11EffectDepthStencilVariable; stdcall;
        function AsRasterizer(): ID3DX11EffectRasterizerVariable; stdcall;
        function AsSampler(): ID3DX11EffectSamplerVariable; stdcall;
        function SetRawValue(pData: Pointer; ByteOffset: UINT32; ByteCount: UINT32): HResult; stdcall;
        function GetRawValue(out pData: Pointer; ByteOffset: UINT32; ByteCount: UINT32): HResult; stdcall;
    end;
    {$interfaces com}
    {$ELSE}
    ID3DX11EffectVariable = class

    end;
    {$ENDIF}




    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11EffectScalarVariable ////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11EffectScalarVariable = interface(ID3DX11EffectVariable)
        ['{921EF2E5-A65D-4E92-9FC6-4E9CC09A4ADE}']
        // IUnknown
        // ID3DX11EffectVariable

        // ID3DX11EffectScalarVariable
        function SetFloat(Value: single): HResult; stdcall;
        function GetFloat(out pValue: single): HResult; stdcall;
        function SetFloatArray(pData: PSingle; Offset: UINT32; Count: UINT32): HResult; stdcall;
        function GetFloatArray(out pData: PSingle; Offset: UINT32; Count: UINT32): HResult; stdcall;
        function SetInt(Value: integer): HResult; stdcall;
        function GetInt(out pValue: integer): HResult; stdcall;
        function SetIntArray(pData: PInteger; Offset: UINT32; Count: UINT32): HResult; stdcall;
        function GetIntArray(out pData: PInteger; Offset: UINT32; Count: UINT32): HResult; stdcall;
        function SetBool(const Value: boolean): HResult; stdcall;
        function GetBool(out pValue: boolean): HResult; stdcall;
        function SetBoolArray(pData: PBoolean; Offset: UINT32; Count: UINT32): HResult; stdcall;
        function GetBoolArray(out pData: PBoolean; Offset: UINT32; Count: UINT32): HResult; stdcall;
    end;
    {$interfaces com}
    {$ELSE}
    ID3DX11EffectScalarVariable = class(ID3DX11EffectVariable)

    end;
    {$ENDIF}

    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11EffectVectorVariable ////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11EffectVectorVariable = interface(ID3DX11EffectVariable)
        ['{5E785D4A-D87B-48D8-B6E6-0F8CA7E7467A}']
        // IUnknown
        // ID3DX11EffectVariable

        // ID3DX11EffectVectorVariable
        function SetBoolVector(const pData: TBoolVector): HResult; stdcall;
        function SetIntVector(const pData: TIntVector): HResult; stdcall;
        function SetFloatVector(const pData: TFloatVector): HResult; stdcall;

        function GetBoolVector(out pData: TBoolVector): HResult; stdcall;
        function GetIntVector(out pData: TIntVector): HResult; stdcall;
        function GetFloatVector(out pData: TFloatVector): HResult; stdcall;

        function SetBoolVectorArray(pData: PBoolVector; Offset: UINT32; Count: UINT32): HResult; stdcall;
        function SetIntVectorArray(pData: PIntVector; Offset: UINT32; Count: UINT32): HResult; stdcall;
        function SetFloatVectorArray(pData: PFloatVector; Offset: UINT32; Count: UINT32): HResult; stdcall;

        function GetBoolVectorArray(out pData: PBoolVector; Offset: UINT32; Count: UINT32): HResult; stdcall;
        function GetIntVectorArray(out pData: PIntVector; Offset: UINT32; Count: UINT32): HResult; stdcall;
        function GetFloatVectorArray(out pData: PFloatVector; Offset: UINT32; Count: UINT32): HResult; stdcall;
    end;
    {$interfaces com}
    {$ELSE}
    ID3DX11EffectVectorVariable = class(ID3DX11EffectVariable)

    end;
    {$ENDIF}

    PID3DX11EffectVectorVariable = ^ID3DX11EffectVectorVariable;

    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11EffectMatrixVariable ////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11EffectMatrixVariable = interface(ID3DX11EffectVariable)
        ['{E1096CF4-C027-419A-8D86-D29173DC803E}']
        // IUnknown
        // ID3DX11EffectVariable

        // ID3DX11EffectMatrixVariable
        function SetMatrix(const pData: TD3DXMATRIX): HResult; stdcall;
        function GetMatrix(out pData: TD3DXMATRIX): HResult; stdcall;

        function SetMatrixArray(pData: PD3DXMATRIX; Offset: UINT32; Count: UINT32): HResult; stdcall;
        function GetMatrixArray(out pData: PD3DXMATRIX; Offset: UINT32; Count: UINT32): HResult; stdcall;

        function SetMatrixPointerArray(ppData: PSingle; Offset: UINT32; Count: UINT32): HResult; stdcall;
        function GetMatrixPointerArray(out ppData: Psingle; Offset: UINT32; Count: UINT32): HResult; stdcall;

        function SetMatrixTranspose(const pData: TD3DXMATRIX): HResult; stdcall;
        function GetMatrixTranspose(out pData: TD3DXMATRIX): HResult; stdcall;

        function SetMatrixTransposeArray(pData: PD3DXMATRIX; Offset: UINT32; Count: UINT32): HResult; stdcall;
        function GetMatrixTransposeArray(out pData: PD3DXMATRIX; Offset: UINT32; Count: UINT32): HResult; stdcall;

        function SetMatrixTransposePointerArray(ppData: PSingle; Offset: UINT32; Count: UINT32): HResult; stdcall;
        function GetMatrixTransposePointerArray(out ppData: Psingle; Offset: UINT32; Count: UINT32): HResult; stdcall;
    end;
    {$interfaces com}
    {$ELSE}
    ID3DX11EffectMatrixVariable = class(ID3DX11EffectVariable)

    end;
    {$ENDIF}

    PID3DX11EffectMatrixVariable = ^ID3DX11EffectMatrixVariable;


    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11EffectStringVariable ////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11EffectStringVariable = interface(ID3DX11EffectVariable)
        ['{F355C818-01BE-4653-A7CC-60FFFEDDC76D}']
        // IUnknown
        // ID3DX11EffectVariable

        // ID3DX11EffectStringVariable
        function GetString(out ppString: PAnsiChar): HResult; stdcall;
        function GetStringArray(out ppStrings: PAnsiChar; Offset: UINT32; Count: UINT32): HResult; stdcall;
    end;
    {$interfaces com}
    {$ELSE}
    ID3DX11EffectStringVariable = class(ID3DX11EffectVariable)

    end;
    {$ENDIF}

    PID3DX11EffectStringVariable = ^ID3DX11EffectStringVariable;

    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11EffectClassInstanceVariable ////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11EffectClassInstanceVariable = interface(ID3DX11EffectVariable)
        ['{926A8053-2A39-4DB4-9BDE-CF649ADEBDC1}']
        // IUnknown
        // ID3DX11EffectVariable

        // ID3DX11EffectClassInstanceVariable
        function GetClassInstance(out ppClassInstance: ID3D11ClassInstance): HResult; stdcall;
    end;
    {$interfaces com}
    {$ELSE}
    ID3DX11EffectClassInstanceVariable = class(ID3DX11EffectVariable)

    end;
    {$ENDIF}

    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11EffectInterfaceVariable ////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11EffectInterfaceVariable = interface(ID3DX11EffectVariable)
        ['{516C8CD8-1C80-40A4-B19B-0688792F11A5}']
        // IUnknown
        // ID3DX11EffectVariable

        // ID3DX11EffectInterfaceVariable
        function SetClassInstance(pEffectClassInstance: ID3DX11EffectClassInstanceVariable): HResult; stdcall;
        function GetClassInstance(out ppEffectClassInstance: ID3DX11EffectClassInstanceVariable): HResult; stdcall;
    end;
    {$interfaces com}
    {$ELSE}
    ID3DX11EffectInterfaceVariable = class(ID3DX11EffectVariable)

    end;
    {$ENDIF}



    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11EffectShaderResourceVariable ////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11EffectShaderResourceVariable = interface(ID3DX11EffectVariable)
        ['{350DB233-BBE0-485C-9BFE-C0026B844F89}']
        // IUnknown
        // ID3DX11EffectVariable

        // ID3DX11EffectShaderResourceVariable
        function SetResource(pResource: ID3D11ShaderResourceView): HResult; stdcall;
        function GetResource(out ppResource: ID3D11ShaderResourceView): HResult; stdcall;

        function SetResourceArray(ppResources: PID3D11ShaderResourceView; Offset: UINT32; Count: UINT32): HResult; stdcall;
        function GetResourceArray(out ppResources: PID3D11ShaderResourceView; Offset: UINT32; Count: UINT32): HResult; stdcall;
    end;
    {$interfaces com}
    {$ELSE}
    ID3DX11EffectShaderResourceVariable = class(ID3DX11EffectVariable)

    end;
    {$ENDIF}

    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11EffectUnorderedAccessViewVariable ////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11EffectUnorderedAccessViewVariable = interface(ID3DX11EffectVariable)
        ['{79B4AC8C-870A-47D2-B05A-8BD5CC3EE6C9}']
        // IUnknown
        // ID3DX11EffectVariable

        // ID3DX11EffectUnorderedAccessViewVariable
        function SetUnorderedAccessView(pResource: ID3D11UnorderedAccessView): HResult; stdcall;
        function GetUnorderedAccessView(out ppResource: ID3D11UnorderedAccessView): HResult; stdcall;

        function SetUnorderedAccessViewArray(ppResources: PID3D11UnorderedAccessView; Offset: UINT32; Count: UINT32): HResult; stdcall;
        function GetUnorderedAccessViewArray(out ppResources: ID3D11UnorderedAccessView; Offset: UINT32; Count: UINT32): HResult; stdcall;
    end;
    {$interfaces com}
    {$ELSE}
    ID3DX11EffectUnorderedAccessViewVariable = class(ID3DX11EffectVariable)

    end;
    {$ENDIF}

    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11EffectRenderTargetViewVariable //////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////



    // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11EffectRenderTargetViewVariable = interface(ID3DX11EffectVariable)
        ['{D5066909-F40C-43F8-9DB5-057C2A208552}']
        // IUnknown
        // ID3DX11EffectVariable

        // ID3DX11EffectRenderTargetViewVariable
        function SetRenderTarget(pResource: ID3D11RenderTargetView): HResult; stdcall;
        function GetRenderTarget(out ppResource: ID3D11RenderTargetView): HResult; stdcall;

        function SetRenderTargetArray(ppResources: PID3D11RenderTargetView; Offset: UINT32; Count: UINT32): HResult; stdcall;
        function GetRenderTargetArray(out ppResources: PID3D11RenderTargetView; Offset: UINT32; Count: UINT32): HResult; stdcall;
    end;
    {$interfaces com}
    {$ELSE}
    ID3DX11EffectRenderTargetViewVariable = class(ID3DX11EffectVariable)

    end;
    {$ENDIF}

    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11EffectDepthStencilViewVariable //////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11EffectDepthStencilViewVariable = interface(ID3DX11EffectVariable)
        ['{33C648AC-2E9E-4A2E-9CD6-DE31ACC5B347}']
        // IUnknown
        // ID3DX11EffectVariable

        // ID3DX11EffectDepthStencilViewVariable
        function SetDepthStencil(pResource: ID3D11DepthStencilView): HResult; stdcall;
        function GetDepthStencil(out ppResource: ID3D11DepthStencilView): HResult; stdcall;

        function SetDepthStencilArray(ppResources: PID3D11DepthStencilView; Offset: UINT32; Count: UINT32): HResult; stdcall;
        function GetDepthStencilArray(out ppResources: PID3D11DepthStencilView; Offset: UINT32; Count: UINT32): HResult; stdcall;
    end;
    {$interfaces com}
    {$ELSE}
    ID3DX11EffectDepthStencilViewVariable = class(ID3DX11EffectVariable)

    end;
    {$ENDIF}

    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11EffectConstantBuffer ////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////


    // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11EffectConstantBuffer = interface(ID3DX11EffectVariable)
        ['{2CB6C733-82D2-4000-B3DA-6219D9A99BF2}']
        // IUnknown
        // ID3DX11EffectVariable

        // ID3DX11EffectConstantBuffer
        function SetConstantBuffer(pConstantBuffer: ID3D11Buffer): HResult; stdcall;
        function UndoSetConstantBuffer(): HResult; stdcall;
        function GetConstantBuffer(out ppConstantBuffer: ID3D11Buffer): HResult; stdcall;

        function SetTextureBuffer(pTextureBuffer: ID3D11ShaderResourceView): HResult; stdcall;
        function UndoSetTextureBuffer(): HResult; stdcall;
        function GetTextureBuffer(out ppTextureBuffer: ID3D11ShaderResourceView): HResult; stdcall;
    end;
    {$interfaces com}
    {$ELSE}
    ID3DX11EffectConstantBuffer = class(ID3DX11EffectVariable)

    end;
    {$ENDIF}

    PID3DX11EffectConstantBuffer = ^ID3DX11EffectConstantBuffer;


    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11EffectShaderVariable ////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    //----------------------------------------------------------------------------
    // D3DX11_EFFECT_SHADER_DESC:

    // Retrieved by ID3DX11EffectShaderVariable::GetShaderDesc()
    //----------------------------------------------------------------------------

    TD3DX11_EFFECT_SHADER_DESC = record
        pInputSignature: PByte;         // Passed into CreateInputLayout, valid on VS and GS only
        IsInline: boolean;                          // Is this an anonymous shader variable resulting from an inline shader assignment?
        // -- The following fields are not valid after Optimize() --
        pBytecode: PByte;                // Shader bytecode
        BytecodeLength: UINT32;
        SODecls: array [0..D3D11_SO_STREAM_COUNT - 1] of LPCSTR;  // Stream out declaration string (for GS with SO)
        RasterizedStream: UINT32;
        NumInputSignatureEntries: UINT32;          // Number of entries in the input signature
        NumOutputSignatureEntries: UINT32;         // Number of entries in the output signature
        NumPatchConstantSignatureEntries: UINT32;  // Number of entries in the patch constant signature
    end;



    // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11EffectShaderVariable = interface(ID3DX11EffectVariable)
        ['{7508B344-020A-4EC7-9118-62CDD36C88D7}']
        // IUnknown
        // ID3DX11EffectVariable

        // ID3DX11EffectShaderVariable
        function GetShaderDesc(ShaderIndex: UINT32; out pDesc: TD3DX11_EFFECT_SHADER_DESC): HResult; stdcall;

        function GetVertexShader(ShaderIndex: UINT32; out ppVS: ID3D11VertexShader): HResult; stdcall;
        function GetGeometryShader(ShaderIndex: UINT32; out ppGS: ID3D11GeometryShader): HResult; stdcall;
        function GetPixelShader(ShaderIndex: UINT32; out ppPS: ID3D11PixelShader): HResult; stdcall;
        function GetHullShader(ShaderIndex: UINT32; out ppHS: ID3D11HullShader): HResult; stdcall;
        function GetDomainShader(ShaderIndex: UINT32; out ppDS: ID3D11DomainShader): HResult; stdcall;
        function GetComputeShader(ShaderIndex: UINT32; out ppCS: ID3D11ComputeShader): HResult; stdcall;

        function GetInputSignatureElementDesc(ShaderIndex: UINT32; Element: UINT32; out pDesc: TD3D11_SIGNATURE_PARAMETER_DESC): HResult; stdcall;
        function GetOutputSignatureElementDesc(ShaderIndex: UINT32; Element: UINT32; out pDesc: TD3D11_SIGNATURE_PARAMETER_DESC): HResult; stdcall;
        function GetPatchConstantSignatureElementDesc(ShaderIndex: UINT32; Element: UINT32;
            out pDesc: TD3D11_SIGNATURE_PARAMETER_DESC): HResult; stdcall;
    end;
    {$interfaces com}
    {$ELSE}
    ID3DX11EffectShaderVariable = class(ID3DX11EffectVariable)

    end;
    {$ENDIF}

    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11EffectBlendVariable /////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11EffectBlendVariable = interface(ID3DX11EffectVariable)
        ['{D664F4D7-3B81-4805-B277-C1DF58C39F53}']
        // IUnknown
        // ID3DX11EffectVariable

        // ID3DX11EffectBlendVariable
        function GetBlendState(Index: UINT32; out ppState: ID3D11BlendState): HResult; stdcall;
        function SetBlendState(Index: UINT32; pState: ID3D11BlendState): HResult; stdcall;
        function UndoSetBlendState(Index: UINT32): HResult; stdcall;
        function GetBackingStore(Index: UINT32; out pDesc: TD3D11_BLEND_DESC): HResult; stdcall;
    end;
    {$interfaces com}
    {$ELSE}
    ID3DX11EffectBlendVariable = class(ID3DX11EffectVariable)

    end;
    {$ENDIF}

    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11EffectDepthStencilVariable //////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11EffectDepthStencilVariable = interface(ID3DX11EffectVariable)
        ['{69B5751B-61A5-48E5-BD41-D93988111563}']
        // IUnknown
        // ID3DX11EffectVariable

        // ID3DX11EffectDepthStencilVariable
        function GetDepthStencilState(Index: UINT32; out ppState: ID3D11DepthStencilState): HResult; stdcall;
        function SetDepthStencilState(Index: UINT32; pState: ID3D11DepthStencilState): HResult; stdcall;
        function UndoSetDepthStencilState(Index: UINT32): HResult; stdcall;
        function GetBackingStore(Index: UINT32; out pDesc: TD3D11_DEPTH_STENCIL_DESC): HResult; stdcall;
    end;
    {$interfaces com}
    {$ELSE}
    ID3DX11EffectDepthStencilVariable = class(ID3DX11EffectVariable)

    end;
    {$ENDIF}


    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11EffectRasterizerVariable ////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11EffectRasterizerVariable = interface(ID3DX11EffectVariable)
        ['{53A262F6-5F74-4151-A132-E3DD19A62C9D}']
        // IUnknown
        // ID3DX11EffectVariable

        // ID3DX11EffectRasterizerVariable
        function GetRasterizerState(Index: UINT32; out ppState: ID3D11RasterizerState): HResult; stdcall;
        function SetRasterizerState(Index: UINT32; pState: ID3D11RasterizerState): HResult; stdcall;
        function UndoSetRasterizerState(Index: UINT32): HResult; stdcall;
        function GetBackingStore(Index: UINT32; out pDesc: TD3D11_RASTERIZER_DESC): HResult; stdcall;
    end;
    {$interfaces com}
    {$ELSE}
    ID3DX11EffectRasterizerVariable = class(ID3DX11EffectVariable)

    end;
    {$ENDIF}

    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11EffectSamplerVariable ///////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11EffectSamplerVariable = interface(ID3DX11EffectVariable)
        ['{C6402E55-1095-4D95-8931-F92660513DD9}']
        // IUnknown
        // ID3DX11EffectVariable

        // ID3DX11EffectSamplerVariable
        function GetSampler(Index: UINT32; out ppSampler: ID3D11SamplerState): HResult; stdcall;
        function SetSampler(Index: UINT32; pSampler: ID3D11SamplerState): HResult; stdcall;
        function UndoSetSampler(Index: UINT32): HResult; stdcall;
        function GetBackingStore(Index: UINT32; out pDesc: TD3D11_SAMPLER_DESC): HResult; stdcall;
    end;
    {$interfaces com}
    {$ELSE}
    ID3DX11EffectSamplerVariable = class(ID3DX11EffectVariable)

    end;
    {$ENDIF}



    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11EffectPass //////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    //----------------------------------------------------------------------------
    // D3DX11_PASS_DESC:

    // Retrieved by ID3DX11EffectPass::GetDesc()
    //----------------------------------------------------------------------------

    TD3DX11_PASS_DESC = record
        Name: LPCSTR;                    // Name of this pass (nullptr if not anonymous)
        Annotations: UINT32;           // Number of annotations on this pass

        pIAInputSignature: PByte;     // Signature from VS or GS (if there is no VS)
        // or nullptr if neither exists
        IAInputSignatureSize: size_t;    // Singature size in bytes

        StencilRef: UINT32;            // Specified in SetDepthStencilState()
        SampleMask: UINT32;            // Specified in SetBlendState()
        BlendFactor: array [0..3] of single;           // Specified in SetBlendState()
    end;

    //----------------------------------------------------------------------------
    // D3DX11_PASS_SHADER_DESC:

    // Retrieved by ID3DX11EffectPass::Get**ShaderDesc()
    //----------------------------------------------------------------------------

    TD3DX11_PASS_SHADER_DESC = record
        pShaderVariable: ID3DX11EffectShaderVariable;   // The variable that this shader came from.
        // If this is an inline shader assignment,
        //   the returned interface will be an
        //   anonymous shader variable, which is
        //   not retrievable any other way.  It's
        //   name in the variable description will
        //   be "$Anonymous".
        // If there is no assignment of this type in
        //   the pass block, pShaderVariable != nullptr,
        //   but pShaderVariable->IsValid() == false.

        ShaderIndex: UINT32;        // The element of pShaderVariable (if an array)
        // or 0 if not applicable
    end;



    // Cannot use 'interface' as the QueryInterface, AddRef and Release methods are missing.
    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11EffectPass = interface {(IUnknown)}
        ['{3437CEC4-4AC1-4D87-8916-F4BD5A41380C}']
        // IUnknown

        // ID3DX11EffectPass
        function IsValid(): boolean; stdcall;
        function GetDesc(out pDesc: TD3DX11_PASS_DESC): HResult; stdcall;

        function GetVertexShaderDesc(out pDesc: TD3DX11_PASS_SHADER_DESC): HResult; stdcall;
        function GetGeometryShaderDesc(out pDesc: TD3DX11_PASS_SHADER_DESC): HResult; stdcall;
        function GetPixelShaderDesc(out pDesc: TD3DX11_PASS_SHADER_DESC): HResult; stdcall;
        function GetHullShaderDesc(out pDesc: TD3DX11_PASS_SHADER_DESC): HResult; stdcall;
        function GetDomainShaderDesc(out pDesc: TD3DX11_PASS_SHADER_DESC): HResult; stdcall;
        function GetComputeShaderDesc(out pDesc: TD3DX11_PASS_SHADER_DESC): HResult; stdcall;

        function GetAnnotationByIndex(Index: UINT32): ID3DX11EffectVariable; stdcall;
        function GetAnnotationByName(Name: LPCSTR): ID3DX11EffectVariable; stdcall;

        function Apply(Flags: UINT32; pContext: ID3D11DeviceContext): HResult; stdcall;

        function ComputeStateBlockMask(var pStateBlockMask: TD3DX11_STATE_BLOCK_MASK): HResult; stdcall;
    end;
    {$interfaces com}
    {$ELSE}
    ID3DX11EffectPass = class

    end;
    {$ENDIF}


    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11EffectTechnique /////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    //----------------------------------------------------------------------------
    // D3DX11_TECHNIQUE_DESC:

    // Retrieved by ID3DX11EffectTechnique::GetDesc()
    //----------------------------------------------------------------------------

    TD3DX11_TECHNIQUE_DESC = record
        Name: LPCSTR;                   // Name of this technique (nullptr if not anonymous)
        Passes: UINT32;             // Number of passes contained within
        Annotations: UINT32;        // Number of annotations on this technique
    end;


    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11EffectTechnique = interface(IUnknown)
        ['{51198831-1F1D-4F47-BD76-41CB0835B1DE}']
        // IUnknown

        // ID3DX11EffectTechnique
        function IsValid(): boolean; stdcall;
        function GetDesc(out pDesc: TD3DX11_TECHNIQUE_DESC): HResult; stdcall;

        function GetAnnotationByIndex(Index: UINT32): ID3DX11EffectVariable; stdcall;
        function GetAnnotationByName(Name: LPCSTR): ID3DX11EffectVariable; stdcall;

        function GetPassByIndex(Index: UINT32): ID3DX11EffectPass; stdcall;
        function GetPassByName(Name: LPCSTR): ID3DX11EffectPass; stdcall;

        function ComputeStateBlockMask(var pStateBlockMask: TD3DX11_STATE_BLOCK_MASK): HResult; stdcall;
    end;
    {$interfaces com}
    {$ELSE}
    ID3DX11EffectTechnique = class

    end;
    {$ENDIF}


    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11EffectTechnique /////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    //----------------------------------------------------------------------------
    // D3DX11_GROUP_DESC:

    // Retrieved by ID3DX11EffectTechnique::GetDesc()
    //----------------------------------------------------------------------------

    TD3DX11_GROUP_DESC = record
        Name: LPCSTR;                   // Name of this group (only nullptr if global)
        Techniques: UINT32;         // Number of techniques contained within
        Annotations: UINT32;        // Number of annotations on this group
    end;


    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11EffectGroup = interface(IUnknown)
        ['{03074acf-97de-485f-b201-cb775264afd6}']
        // IUnknown

        // ID3DX11EffectGroup
        function IsValid(): boolean; stdcall;
        function GetDesc(out pDesc: TD3DX11_GROUP_DESC): HResult; stdcall;

        function GetAnnotationByIndex(Index: UINT32): ID3DX11EffectVariable; stdcall;
        function GetAnnotationByName(Name: LPCSTR): ID3DX11EffectVariable; stdcall;

        function GetTechniqueByIndex(Index: UINT32): ID3DX11EffectTechnique; stdcall;
        function GetTechniqueByName(Name: LPCSTR): ID3DX11EffectTechnique; stdcall;
    end;
    {$interfaces com}
    {$ELSE}
    ID3DX11EffectGroup = class

    end;
    {$ENDIF}

    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11Effect //////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    //----------------------------------------------------------------------------
    // D3DX11_EFFECT_DESC:

    // Retrieved by ID3DX11Effect::GetDesc()
    //----------------------------------------------------------------------------

    TD3DX11_EFFECT_DESC = record
        ConstantBuffers: UINT32;        // Number of constant buffers in this effect
        GlobalVariables: UINT32;        // Number of global variables in this effect
        InterfaceVariables: UINT32;     // Number of global interfaces in this effect
        Techniques: UINT32;             // Number of techniques in this effect
        Groups: UINT32;                 // Number of groups in this effect
    end;




    {$IFDEF FPC}
    {$interfaces corba}
    ID3DX11Effect = interface
        ['{FA61CA24-E4BA-4262-9DB8-B132E8CAE319}']
        // IUnknown

        // ID3DX11Effect
        function IsValid(): boolean; stdcall;
        function GetDevice(out ppDevice: ID3D11Device): HResult; stdcall;
        function GetDesc(out pDesc: TD3DX11_EFFECT_DESC): HResult; stdcall;
        function GetConstantBufferByIndex(Index: UINT32): ID3DX11EffectConstantBuffer; stdcall;
        function GetConstantBufferByName(Name: LPCSTR): ID3DX11EffectConstantBuffer; stdcall;
        function GetVariableByIndex(Index: UINT32): ID3DX11EffectVariable; stdcall;
        function GetVariableByName(Name: LPCSTR): ID3DX11EffectVariable; stdcall;
        function GetVariableBySemantic(Semantic: LPCSTR): ID3DX11EffectVariable; stdcall;
        function GetGroupByIndex(Index: UINT32): ID3DX11EffectGroup; stdcall;
        function GetGroupByName(Name: LPCSTR): ID3DX11EffectGroup; stdcall;
        function GetTechniqueByIndex(Index: UINT32): ID3DX11EffectTechnique; stdcall;
        function GetTechniqueByName(Name: LPCSTR): ID3DX11EffectTechnique; stdcall;
        function GetClassLinkage(): ID3D11ClassLinkage; stdcall;
        function CloneEffect(Flags: UINT32; out ppClonedEffect: ID3DX11Effect): HResult; stdcall;
        function Optimize(): HResult; stdcall;
        function IsOptimized(): boolean; stdcall;
    end;
    {$interfaces com}
    {$ELSE}
     ID3DX11Effect  = class // Cannot use 'interface'
        // IUnknown

        // ID3DX11Effect
        function IsValid(): boolean;  virtual; stdcall; abstract;
        function GetDevice(out ppDevice: ID3D11Device): HResult;  virtual; stdcall; abstract;
        function GetDesc(out pDesc: TD3DX11_EFFECT_DESC): HResult;  virtual; stdcall; abstract;
        function GetConstantBufferByIndex(Index: UINT32): ID3DX11EffectConstantBuffer;  virtual; stdcall; abstract;
        function GetConstantBufferByName(Name: LPCSTR): ID3DX11EffectConstantBuffer;  virtual; stdcall; abstract;
        function GetVariableByIndex(Index: UINT32): ID3DX11EffectVariable; virtual; stdcall; abstract;
        function GetVariableByName(Name: LPCSTR): ID3DX11EffectVariable; virtual; stdcall; abstract;
        function GetVariableBySemantic(Semantic: LPCSTR): ID3DX11EffectVariable; virtual; stdcall; abstract;
        function GetGroupByIndex(Index: UINT32): ID3DX11EffectGroup; virtual; stdcall; abstract;
        function GetGroupByName(Name: LPCSTR): ID3DX11EffectGroup; virtual; stdcall; abstract;
        function GetTechniqueByIndex(Index: UINT32): ID3DX11EffectTechnique; virtual; stdcall; abstract;
        function GetTechniqueByName(Name: LPCSTR): ID3DX11EffectTechnique; virtual; stdcall; abstract;
        function GetClassLinkage(): ID3D11ClassLinkage; virtual; stdcall; abstract;
        function CloneEffect(Flags: UINT32; out ppClonedEffect: ID3DX11Effect): HResult; virtual; stdcall; abstract;
        function Optimize(): HResult; virtual; stdcall; abstract;
        function IsOptimized(): boolean; virtual; stdcall; abstract;
    end;
    {$ENDIF}



//////////////////////////////////////////////////////////////////////////////
// APIs //////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////


//----------------------------------------------------------------------------
// D3DX11CreateEffectFromMemory

// Creates an effect instance from a compiled effect in memory

// Parameters:

// [in]

//  pData
//      Blob of compiled effect data
//  DataLength
//      Length of the data blob
//  FXFlags
//      Flags pertaining to Effect creation
//  pDevice
//      Pointer to the D3D11 device on which to create Effect resources
//  srcName [optional]
//      ASCII string to use for debug object naming

// [out]

//  ppEffect
//      Address of the newly created Effect interface




//----------------------------------------------------------------------------

function D3DX11CreateEffectFromMemory(pData: Pointer; DataLength: SIZE_T; FXFlags: UINT; pDevice: ID3D11Device;
    out ppEffect: ID3DX11Effect; srcName: LPCSTR = nil): HResult; stdcall; external DLL_D3DX11Effects;


{$IFDEF USE_DX11Effect_DLL}
//----------------------------------------------------------------------------
// D3DX11CreateEffectFromFile

// Creates an effect instance from a compiled effect data file

// Parameters:

// [in]

//  pFileName
//      Compiled effect file
//  FXFlags
//      Flags pertaining to Effect creation
//  pDevice
//      Pointer to the D3D11 device on which to create Effect resources

// [out]

//  ppEffect
//      Address of the newly created Effect interface

//----------------------------------------------------------------------------

function D3DX11CreateEffectFromFile(pFileName: LPCWSTR; FXFlags: UINT; pDevice: ID3D11Device; out ppEffect: ID3DX11Effect): HResult;
    stdcall; external DLL_D3DX11Effects;

//----------------------------------------------------------------------------
// D3DX11CompileEffectFromMemory

// Complies an effect shader source file in memory and then creates an effect instance

// Parameters:

// [in]

//  pData
//      Pointer to FX shader as an ASCII string
//  DataLength
//      Length of the FX shader ASCII string
//  srcName [optional]
//      ASCII string to use for debug object naming
//  pDefines [optional]
//      A NULL-terminated array of shader macros
//  pInclude [optional]
//      A pointer to an include interface
//  HLSLFlags
//     HLSL compile options (see D3DCOMPILE flags)
//  FXFlags
//      Flags pertaining to Effect compilation (see D3DCOMPILE_EFFECT flags)
//  pDevice
//      Pointer to the D3D11 device on which to create Effect resources

// [out]

//  ppEffect
//      Address of the newly created Effect interface

//----------------------------------------------------------------------------

function D3DX11CompileEffectFromMemory(pData: Pointer; DataLength: SIZE_T; srcName: LPCSTR; const pDefines: TD3D_SHADER_MACRO;
    pInclude: ID3DInclude; HLSLFlags: UINT; FXFlags: UINT; pDevice: ID3D11Device; out ppEffect: ID3DX11Effect; out ppErrors: ID3DBlob): HResult;
    stdcall; external DLL_D3DX11Effects;

//----------------------------------------------------------------------------
// D3DX11CompileEffectFromFile

// Complies an effect shader source file and then creates an effect instance

// Parameters:

// [in]

//  pFileName
//      FX shader source file
//  pDefines [optional]
//      A NULL-terminated array of shader macros
//  pInclude [optional]
//      A pointer to an include interface
//  HLSLFlags
//     HLSL compile options (see D3DCOMPILE flags)
//  FXFlags
//      Flags pertaining to Effect compilation (see D3DCOMPILE_EFFECT flags)
//  pDevice
//      Pointer to the D3D11 device on which to create Effect resources

// [out]

//  ppEffect
//      Address of the newly created Effect interface

//----------------------------------------------------------------------------

function D3DX11CompileEffectFromFile(pFileName: LPCWSTR; const pDefines: TD3D_SHADER_MACRO; pInclude: ID3DInclude;
    HLSLFlags: UINT; FXFlags: UINT; pDevice: ID3D11Device; out ppEffect: ID3DX11Effect; out ppErrors: ID3DBlob): HResult;
    stdcall; external DLL_D3DX11Effects;

{$ENDIF}

implementation

end.
