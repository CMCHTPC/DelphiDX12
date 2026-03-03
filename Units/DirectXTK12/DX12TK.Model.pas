unit DX12TK.Model;

{$mode ObjFPC}{$H+}
{$MODESWITCH ADVANCEDRECORDS}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D12,
    DX12.DXGIFormat,
    DX12.D3DCommon,
    DX12TK.GraphicsMemory,
    DX12TK.Effects,
    DirectX.Math,
    CStdVector;

const
    c_Invalid = uint32(-1);


type
    //------------------------------------------------------------------------------
    // Model loading options
    TModelLoaderFlags = (
        ModelLoader_Default = $0,
        ModelLoader_MaterialColorsSRGB = $1,
        ModelLoader_AllowLargeModels = $2,
        ModelLoader_IncludeBones = $4,
        ModelLoader_DisableSkinning = $8);

    PModelLoaderFlags = ^TModelLoaderFlags;

    //------------------------------------------------------------------------------
    // Frame hierarchy for rigid body and skeletal animation

    { TModelBone }

    TModelBone = record
        parentIndex: uint32;
        childIndex: uint32;
        siblingIndex: uint32;
        Name: widestring;
        class function Create(): TModelBone; static; overload;
        class function Create(parent: uint32; child: uint32; sibling: uint32): TModelBone; static; overload;

    end;
    PModelBone = ^TModelBone;


    //------------------------------------------------------------------------------
    // Each mesh part is a submesh with a single effect



    { TModelMeshPart }

    TModelMeshPart = class(TObject)
    type
        TCollection = specialize TCStdVector<TModelMeshPart>;
        TDrawCallback = procedure({_In_}  commandList: ID3D12GraphicsCommandList; const part: TModelMeshPart);
        TInputLayoutCollection = specialize TCStdVector<TD3D12_INPUT_ELEMENT_DESC>;

    public
        partIndex: uint32; // Unique index assigned per-part in a model.
        materialIndex: uint32; // Index of the material spec to use
        indexCount: uint32;
        startIndex: uint32;
        vertexOffset: int32;
        vertexStride: uint32;
        vertexCount: uint32;
        indexBufferSize: uint32;
        vertexBufferSize: uint32;
        primitiveType: TD3D_PRIMITIVE_TOPOLOGY;
        indexFormat: TDXGI_FORMAT;
        indexBuffer: TSharedGraphicsResource;
        vertexBuffer: TSharedGraphicsResource;
        staticIndexBuffer: ID3D12Resource;
        staticVertexBuffer: ID3D12Resource;
        vbDecl: TInputLayoutCollection;
    public
        constructor Create(APartIndex: uint32);
        destructor Destroy; override;

        // Draw mesh part
        procedure Draw(
        {_In_ } commandList: ID3D12GraphicsCommandList);
        procedure DrawInstanced(
        {_In_ } commandList: ID3D12GraphicsCommandList; instanceCount: uint32; startInstance: uint32 = 0);

        // Utilities for drawing multiple mesh parts
        // Draw the mesh
        procedure DrawMeshParts(
        {_In_ } commandList: ID3D12GraphicsCommandList; meshParts: TCollection);


        // Draw the mesh with an effect
        procedure DrawMeshParts(
        {_In_ } commandList: ID3D12GraphicsCommandList; meshParts: TCollection;
        {_In_ } effect: IEffect);


        // Draw the mesh with a callback for each mesh part
        procedure DrawMeshParts(
        {_In_ } commandList: ID3D12GraphicsCommandList; meshParts: TCollection; callback: TDrawCallback);

    end;

    PModelMeshPart = ^TModelMeshPart;


implementation

{ TModelBone }

class function TModelBone.Create: TModelBone;
var
    lBone: TModelBone;
begin
    lBone.parentIndex := c_Invalid;
    lBone.childIndex := c_Invalid;
    lBone.siblingIndex := c_Invalid;
    Result := lBone;
end;

class function TModelBone.Create(parent: uint32; child: uint32; sibling: uint32): TModelBone;
var
    lBone: TModelBone;
begin
    lBone.parentIndex := parent;
    lBone.childIndex := child;
    lBone.siblingIndex := sibling;
    Result := lBone;
end;

{ TModelMeshPart }

constructor TModelMeshPart.Create(APartIndex: uint32);
begin

end;

destructor TModelMeshPart.Destroy;
begin
    inherited Destroy;
end;

procedure TModelMeshPart.Draw(commandList: ID3D12GraphicsCommandList);
begin

end;

procedure TModelMeshPart.DrawInstanced(commandList: ID3D12GraphicsCommandList; instanceCount: uint32; startInstance: uint32);
begin

end;

procedure TModelMeshPart.DrawMeshParts(commandList: ID3D12GraphicsCommandList; meshParts: TCollection);
begin

end;

procedure TModelMeshPart.DrawMeshParts(commandList: ID3D12GraphicsCommandList; meshParts: TCollection; effect: IEffect);
begin

end;

procedure TModelMeshPart.DrawMeshParts(commandList: ID3D12GraphicsCommandList; meshParts: TCollection; callback: TDrawCallback);
begin

end;

end.
