//--------------------------------------------------------------------------------------
// File: VertexTypes.h

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------
unit DX12TK.VertexTypes;

{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}

interface

uses
    Windows, Classes, SysUtils,
    DirectX.Math,
    DX12.DXGIFormat,
    DX12.D3D12;

type


    { TVertexPosition }

    // Vertex struct holding position information.
    TVertexPosition = record
    const
        InputElementCount = 1;
        InputElements: array [0..InputElementCount - 1] of TD3D12_INPUT_ELEMENT_DESC = (
            (SemanticName: 'SV_Position'; SemanticIndex: 0; Format: DXGI_FORMAT_R32G32B32_FLOAT;
            InputSlot: 0; AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT; InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA; InstanceDataStepRate: 0));
        InputLayout: TD3D12_INPUT_LAYOUT_DESC = (pInputElementDescs: @InputElements; NumElements: InputElementCount);
    public
        position: TXMFLOAT3;
        procedure Init(iposition: TFXMVECTOR);
        procedure Init(iposition: PXMFLOAT3);
    end;

    {$if sizeof(TVertexPosition) <> 12}
    {$error Vertex struct/layout mismatch}
    {$endif}


    { TVertexPositionColor }
    // Vertex struct holding position and color information.
    TVertexPositionColor = record
    const
        InputElementCount = 2;
        InputElements: array [0..InputElementCount - 1] of TD3D12_INPUT_ELEMENT_DESC = (
            (SemanticName: 'SV_Position';
            SemanticIndex: 0;
            Format: DXGI_FORMAT_R32G32B32_FLOAT;
            InputSlot: 0;
            AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA;
            InstanceDataStepRate: 0),
            (SemanticName: 'COLOR';
            SemanticIndex: 0;
            Format: DXGI_FORMAT_R32G32B32A32_FLOAT;
            InputSlot: 0;
            AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA;
            InstanceDataStepRate: 0)
            );
        InputLayout: TD3D12_INPUT_LAYOUT_DESC = (pInputElementDescs: @InputElements; NumElements: InputElementCount);
    public
        position: TXMFLOAT3;
        color: TXMFLOAT4;
        procedure Init(iposition: PXMFLOAT3; icolor: PXMFLOAT4); overload;
        procedure Init(iposition: TFXMVECTOR; icolor: TFXMVECTOR); overload;
    end;

    {$if sizeof(TVertexPositionColor) <> 28}
    {$error Vertex struct/layout mismatch}
    {$endif}

    // Vertex struct holding position and texture mapping information.

    { TVertexPositionTexture }

    TVertexPositionTexture = record
    const
        InputElementCount = 2;
        InputElements: array [0..InputElementCount - 1] of TD3D12_INPUT_ELEMENT_DESC = ((
            SemanticName: 'SV_Position';
            SemanticIndex: 0;
            Format: DXGI_FORMAT_R32G32B32_FLOAT;
            InputSlot: 0;
            AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA;
            InstanceDataStepRate: 0
            ), (
            SemanticName: 'TEXCOORD';
            SemanticIndex: 0;
            Format: DXGI_FORMAT_R32G32_FLOAT;
            InputSlot: 0;
            AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA;
            InstanceDataStepRate: 0
            ));
        InputLayout: TD3D12_INPUT_LAYOUT_DESC = (pInputElementDescs: @InputElements; NumElements: InputElementCount);
    public
        position: TXMFLOAT3;
        textureCoordinate: TXMFLOAT2;
        procedure Init(iposition: PXMFLOAT3; itextureCoordinate: PXMFLOAT2); overload;
        procedure Init(iposition: TFXMVECTOR; itextureCoordinate: TFXMVECTOR); overload;
    end;

    {$if sizeof(TVertexPositionTexture) <> 20}
    {$error Vertex struct/layout mismatch}
    {$endif}


    // Vertex struct holding position and dual texture mapping information.

    { TVertexPositionDualTexture }

    TVertexPositionDualTexture = record
    const
        InputElementCount = 3;
        InputElements: array [0..InputElementCount - 1] of TD3D12_INPUT_ELEMENT_DESC = (
            (SemanticName: 'SV_Position';
            SemanticIndex: 0;
            Format: DXGI_FORMAT_R32G32B32_FLOAT;
            InputSlot: 0;
            AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA;
            InstanceDataStepRate: 0),
            (SemanticName: 'TEXCOORD';
            SemanticIndex: 0;
            Format: DXGI_FORMAT_R32G32_FLOAT;
            InputSlot: 0;
            AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA;
            InstanceDataStepRate: 0),
            (SemanticName: 'TEXCOORD';
            SemanticIndex: 1;
            Format: DXGI_FORMAT_R32G32_FLOAT;
            InputSlot: 0;
            AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA;
            InstanceDataStepRate: 0));
        InputLayout: TD3D12_INPUT_LAYOUT_DESC = (pInputElementDescs: @InputElements; NumElements: InputElementCount);
    public
        position: TXMFLOAT3;
        textureCoordinate0: TXMFLOAT2;
        textureCoordinate1: TXMFLOAT2;
        procedure Init(iposition: PXMFLOAT3; itextureCoordinate0: PXMFLOAT2; itextureCoordinate1: PXMFLOAT2); overload;
        procedure Init(iposition: TFXMVECTOR; itextureCoordinate0: TFXMVECTOR; itextureCoordinate1: TFXMVECTOR); overload;

    end;

    {$if sizeof(TVertexPositionDualTexture) <> 28}
    {$error Vertex struct/layout mismatch}
    {$endif}

    // Vertex struct holding position and normal vector.

    { TVertexPositionNormal }

    TVertexPositionNormal = record
    const
        InputElementCount = 2;
        InputElements: array [0..InputElementCount - 1] of TD3D12_INPUT_ELEMENT_DESC = (
            (SemanticName: 'SV_Position';
            SemanticIndex: 0;
            Format: DXGI_FORMAT_R32G32B32_FLOAT;
            InputSlot: 0;
            AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA;
            InstanceDataStepRate: 0;
            ), (
            SemanticName: 'NORMAL';
            SemanticIndex: 0;
            Format: DXGI_FORMAT_R32G32B32_FLOAT;
            InputSlot: 0;
            AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA;
            InstanceDataStepRate: 0;
            ));
        InputLayout: TD3D12_INPUT_LAYOUT_DESC = (pInputElementDescs: @InputElements; NumElements: InputElementCount);
    public
        position: TXMFLOAT3;
        normal: TXMFLOAT3;
        procedure Init(iposition: PXMFLOAT3; inormal: PXMFLOAT3); overload;
        procedure Init(iposition: TFXMVECTOR; inormal: TFXMVECTOR); overload;
    end;

    {$if sizeof(TVertexPositionNormal) <> 24}
    {$error Vertex struct/layout mismatch}
    {$endif}

    // Vertex struct holding position, color, and texture mapping information.

    { TVertexPositionColorTexture }

    TVertexPositionColorTexture = record
    const
        InputElementCount = 3;
        InputElements: array [0..InputElementCount - 1] of TD3D12_INPUT_ELEMENT_DESC = ((
            SemanticName: 'SV_Position';
            SemanticIndex: 0;
            Format: DXGI_FORMAT_R32G32B32_FLOAT;
            InputSlot: 0;
            AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA;
            InstanceDataStepRate: 0
            ), (
            SemanticName: 'COLOR';
            SemanticIndex: 0;
            Format: DXGI_FORMAT_R32G32B32A32_FLOAT;
            InputSlot: 0;
            AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA;
            InstanceDataStepRate: 0
            ), (
            SemanticName: 'TEXCOORD';
            SemanticIndex: 0;
            Format: DXGI_FORMAT_R32G32_FLOAT;
            InputSlot: 0;
            AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA;
            InstanceDataStepRate: 0;
            ));
        InputLayout: TD3D12_INPUT_LAYOUT_DESC = (pInputElementDescs: @InputElements; NumElements: InputElementCount);
    public
        position: TXMFLOAT3;
        color: TXMFLOAT4;
        textureCoordinate: TXMFLOAT2;
        procedure Init(iposition: PXMFLOAT3; icolor: PXMFLOAT4; itextureCoordinate: PXMFLOAT2); overload;
        procedure Init(iposition: TFXMVECTOR; icolor: TFXMVECTOR; itextureCoordinate: TFXMVECTOR); overload;

    end;

    {$if sizeof(TVertexPositionColorTexture) <> 36}
    {$error Vertex struct/layout mismatch}
    {$endif}

    // Vertex struct holding position, normal vector, and color information.

    { TVertexPositionNormalColor }

    TVertexPositionNormalColor = record
    const
        InputElementCount = 3;
        InputElements: array [0..InputElementCount - 1] of TD3D12_INPUT_ELEMENT_DESC = ((
            SemanticName: 'SV_Position';
            SemanticIndex: 0;
            Format: DXGI_FORMAT_R32G32B32_FLOAT;
            InputSlot: 0;
            AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA;
            InstanceDataStepRate: 0; ),
            (
            SemanticName: 'NORMAL';
            SemanticIndex: 0;
            Format: DXGI_FORMAT_R32G32B32_FLOAT;
            InputSlot: 0;
            AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA;
            InstanceDataStepRate: 0;
            ), (
            SemanticName: 'COLOR';
            SemanticIndex: 0;
            Format: DXGI_FORMAT_R32G32B32A32_FLOAT;
            InputSlot: 0;
            AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA;
            InstanceDataStepRate: 0;
            ));
        InputLayout: TD3D12_INPUT_LAYOUT_DESC = (pInputElementDescs: @InputElements; NumElements: InputElementCount);
    public
        position: TXMFLOAT3;
        normal: TXMFLOAT3;
        color: TXMFLOAT4;
        procedure Init(iposition: PXMFLOAT3; inormal: PXMFLOAT3; icolor: PXMFLOAT4); overload;
        procedure Init(iposition: TFXMVECTOR; inormal: TFXMVECTOR; icolor: TFXMVECTOR); overload;
    end;

    {$if sizeof(TVertexPositionNormalColor) <> 40}
    {$error Vertex struct/layout mismatch}
    {$endif}

    // Vertex struct holding position, normal vector, and texture mapping information.

    { TVertexPositionNormalTexture }

    TVertexPositionNormalTexture = record
    const
        InputElementCount = 3;
        InputElements: array [0..InputElementCount - 1] of TD3D12_INPUT_ELEMENT_DESC = (
            (
            SemanticName: 'SV_Position';
            SemanticIndex: 0;
            Format: DXGI_FORMAT_R32G32B32_FLOAT;
            InputSlot: 0;
            AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA;
            InstanceDataStepRate: 0;
            ), (
            SemanticName: 'NORMAL';
            SemanticIndex: 0;
            Format: DXGI_FORMAT_R32G32B32_FLOAT;
            InputSlot: 0;
            AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA;
            InstanceDataStepRate: 0;
            ), (
            SemanticName: 'TEXCOORD';
            SemanticIndex: 0;
            Format: DXGI_FORMAT_R32G32_FLOAT;
            InputSlot: 0;
            AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA;
            InstanceDataStepRate: 0;
            ));
        InputLayout: TD3D12_INPUT_LAYOUT_DESC = (pInputElementDescs: @InputElements; NumElements: InputElementCount);
    public
        position: TXMFLOAT3;
        normal: TXMFLOAT3;
        textureCoordinate: TXMFLOAT2;
        procedure Init(iposition: PXMFLOAT3; inormal: PXMFLOAT3; itextureCoordinate: PXMFLOAT2); overload;
        procedure Init(iposition: TFXMVECTOR; inormal: TFXMVECTOR; itextureCoordinate: TFXMVECTOR); overload;
        constructor Create(iposition: TFXMVECTOR; inormal: TFXMVECTOR; itextureCoordinate: TFXMVECTOR); overload;
    end;

    {$if sizeof(TVertexPositionNormalTexture) <> 32}
    {$error Vertex struct/layout mismatch}
    {$endif}

    // Vertex struct holding position, normal vector, color, and texture mapping information.

    { TVertexPositionNormalColorTexture }

    TVertexPositionNormalColorTexture = record
    const
        InputElementCount = 4;
        InputElements: array [0..InputElementCount - 1] of TD3D12_INPUT_ELEMENT_DESC = ((
            SemanticName: 'SV_Position';
            SemanticIndex: 0;
            Format: DXGI_FORMAT_R32G32B32_FLOAT;
            InputSlot: 0;
            AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA;
            InstanceDataStepRate: 0;
            ), (
            SemanticName: 'NORMAL';
            SemanticIndex: 0;
            Format: DXGI_FORMAT_R32G32B32_FLOAT;
            InputSlot: 0;
            AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA;
            InstanceDataStepRate: 0;
            ), (
            SemanticName: 'COLOR';
            SemanticIndex: 0;
            Format: DXGI_FORMAT_R32G32B32A32_FLOAT;
            InputSlot: 0;
            AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA;
            InstanceDataStepRate: 0;
            ), (
            SemanticName: 'TEXCOORD';
            SemanticIndex: 0;
            Format: DXGI_FORMAT_R32G32_FLOAT;
            InputSlot: 0;
            AlignedByteOffset: D3D12_APPEND_ALIGNED_ELEMENT;
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA;
            InstanceDataStepRate: 0;
            ));
        InputLayout: TD3D12_INPUT_LAYOUT_DESC = (pInputElementDescs: @InputElements; NumElements: InputElementCount);
    public
        position: TXMFLOAT3;
        normal: TXMFLOAT3;
        color: TXMFLOAT4;
        textureCoordinate: TXMFLOAT2;
        procedure Init(iposition: PXMFLOAT3; inormal: PXMFLOAT3; icolor: PXMFLOAT4; itextureCoordinate: PXMFLOAT2); overload;
        procedure Init(iposition: TFXMVECTOR; inormal: TFXMVECTOR; icolor: TFXMVECTOR; itextureCoordinate: TCXMVECTOR); overload;
    end;

    {$if sizeof(TVertexPositionNormalColorTexture) <> 48}
    {$error Vertex struct/layout mismatch}
    {$endif}

    //--------------------------------------------------------------------------------------
    // VertexPositionNormalTangentColorTexture, VertexPositionNormalTangentColorTextureSkinning are not
    // supported for DirectX 12 since they were only present for DGSL


implementation

//--------------------------------------------------------------------------------------
// File: VertexTypes.cpp

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------

{ TVertexPosition }

procedure TVertexPosition.Init(iposition: TFXMVECTOR);
begin
    XMStoreFloat3(@self.position, iposition);
end;



procedure TVertexPosition.Init(iposition: PXMFLOAT3);
begin
    position := iposition^;
end;

{ TVertexPositionColor }

procedure TVertexPositionColor.Init(iposition: PXMFLOAT3; icolor: PXMFLOAT4);
begin
    position := iposition^;
    color := icolor^;
end;



procedure TVertexPositionColor.Init(iposition: TFXMVECTOR; icolor: TFXMVECTOR);
begin
    XMStoreFloat3(@self.position, iposition);
    XMStoreFloat4(@self.color, icolor);
end;

{ TVertexPositionTexture }

procedure TVertexPositionTexture.Init(iposition: PXMFLOAT3; itextureCoordinate: PXMFLOAT2);
begin
    position := iposition^;
    textureCoordinate := itextureCoordinate^;
end;



procedure TVertexPositionTexture.Init(iposition: TFXMVECTOR; itextureCoordinate: TFXMVECTOR);
begin
    XMStoreFloat3(@self.position, iposition);
    XMStoreFloat2(@textureCoordinate, itextureCoordinate);
end;

{ TVertexPositionDualTexture }

procedure TVertexPositionDualTexture.Init(iposition: PXMFLOAT3; itextureCoordinate0: PXMFLOAT2; itextureCoordinate1: PXMFLOAT2);
begin
    position := iposition^;
    textureCoordinate0 := itextureCoordinate0^;
    textureCoordinate1 := itextureCoordinate1^;
end;



procedure TVertexPositionDualTexture.Init(iposition: TFXMVECTOR; itextureCoordinate0: TFXMVECTOR; itextureCoordinate1: TFXMVECTOR);
begin
    XMStoreFloat3(@self.position, iposition);
    XMStoreFloat2(@self.textureCoordinate0, itextureCoordinate0);
    XMStoreFloat2(@self.textureCoordinate1, itextureCoordinate1);
end;

{ TVertexPositionNormal }

procedure TVertexPositionNormal.Init(iposition: PXMFLOAT3; inormal: PXMFLOAT3);
begin
    position := iposition^;
    normal := inormal^;
end;



procedure TVertexPositionNormal.Init(iposition: TFXMVECTOR; inormal: TFXMVECTOR);
begin
    XMStoreFloat3(@self.position, iposition);
    XMStoreFloat3(@self.normal, inormal);

end;

{ TVertexPositionColorTexture }

procedure TVertexPositionColorTexture.Init(iposition: PXMFLOAT3; icolor: PXMFLOAT4; itextureCoordinate: PXMFLOAT2);
begin
    position := iposition^;
    color := icolor^;
    textureCoordinate := itextureCoordinate^;
end;



procedure TVertexPositionColorTexture.Init(iposition: TFXMVECTOR; icolor: TFXMVECTOR; itextureCoordinate: TFXMVECTOR);
begin
    XMStoreFloat3(@self.position, iposition);
    XMStoreFloat4(@self.color, icolor);
    XMStoreFloat2(@self.textureCoordinate, itextureCoordinate);
end;

{ TVertexPositionNormalColor }

procedure TVertexPositionNormalColor.Init(iposition: PXMFLOAT3; inormal: PXMFLOAT3; icolor: PXMFLOAT4);
begin
    position := iposition^;
    normal := inormal^;
    color := icolor^;
end;



procedure TVertexPositionNormalColor.Init(iposition: TFXMVECTOR; inormal: TFXMVECTOR; icolor: TFXMVECTOR);
begin
    XMStoreFloat3(@self.position, iposition);
    XMStoreFloat3(@self.normal, inormal);
    XMStoreFloat4(@self.color, icolor);
end;

{ TVertexPositionNormalTexture }

procedure TVertexPositionNormalTexture.Init(iposition: PXMFLOAT3; inormal: PXMFLOAT3; itextureCoordinate: PXMFLOAT2);
begin
    position := iposition^;
    normal := inormal^;
    textureCoordinate := itextureCoordinate^;
end;



procedure TVertexPositionNormalTexture.Init(iposition: TFXMVECTOR; inormal: TFXMVECTOR; itextureCoordinate: TFXMVECTOR);
begin
    XMStoreFloat3(@self.position, iposition);
    XMStoreFloat3(@self.normal, inormal);
    XMStoreFloat2(@self.textureCoordinate, itextureCoordinate);
end;



constructor TVertexPositionNormalTexture.Create(iposition: TFXMVECTOR; inormal: TFXMVECTOR; itextureCoordinate: TFXMVECTOR);
begin
    self.init(iposition, inormal, itextureCoordinate);
end;

{ TVertexPositionNormalColorTexture }

procedure TVertexPositionNormalColorTexture.Init(iposition: PXMFLOAT3; inormal: PXMFLOAT3; icolor: PXMFLOAT4; itextureCoordinate: PXMFLOAT2);
begin
    position := iposition^;
    normal := inormal^;
    color := icolor^;
    textureCoordinate := itextureCoordinate^;
end;



procedure TVertexPositionNormalColorTexture.Init(iposition: TFXMVECTOR; inormal: TFXMVECTOR; icolor: TFXMVECTOR; itextureCoordinate: TCXMVECTOR);
begin
    XMStoreFloat3(@self.position, iposition);
    XMStoreFloat3(@self.normal, inormal);
    XMStoreFloat4(@self.color, icolor);
    XMStoreFloat2(@self.textureCoordinate, itextureCoordinate);
end;


end.
