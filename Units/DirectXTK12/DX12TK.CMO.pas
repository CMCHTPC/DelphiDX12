//--------------------------------------------------------------------------------------
// File: CMO.h

// .CMO files are built by Visual Studio's MeshContentTask and an example renderer was
// provided in the VS Direct3D Starter Kit
// https://devblogs.microsoft.com/cppblog/developing-an-app-with-the-visual-studio-3d-starter-kit-part-1-of-3/
// https://devblogs.microsoft.com/cppblog/developing-an-app-with-the-visual-studio-3d-starter-kit-part-2-of-3/
// https://devblogs.microsoft.com/cppblog/developing-an-app-with-the-visual-studio-3d-starter-kit-part-3-of-3/

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkId=248929
// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------
unit DX12TK.CMO;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DirectX.Math;

    // .CMO files

    // UINT - Mesh count
    // { [Mesh count]
    //      UINT - Length of name
    //      wchar_t[] - Name of mesh (if length > 0)
    //      UINT - Material count
    //      { [Material count]
    //          UINT - Length of material name
    //          wchar_t[] - Name of material (if length > 0)
    //          Material structure
    //          UINT - Length of pixel shader name
    //          wchar_t[] - Name of pixel shader (if length > 0)
    //          { [8]
    //              UINT - Length of texture name
    //              wchar_t[] - Name of texture (if length > 0)
    //          }
    //      }
    //      BYTE - 1 if there is skeletal animation data present
    //      UINT - SubMesh count
    //      { [SubMesh count]
    //          SubMesh structure
    //      }
    //      UINT - IB Count
    //      { [IB Count]
    //          UINT - Number of USHORTs in IB
    //          USHORT[] - Array of indices
    //      }
    //      UINT - VB Count
    //      { [VB Count]
    //          UINT - Number of verts in VB
    //          Vertex[] - Array of vertices
    //      }
    //      UINT - Skinning VB Count
    //      { [Skinning VB Count]
    //          UINT - Number of verts in Skinning VB
    //          SkinningVertex[] - Array of skinning verts
    //      }
    //      MeshExtents structure
    //      [If skeleton animation data is not present, file ends here]
    //      UINT - Bone count
    //      { [Bone count]
    //          UINT - Length of bone name
    //          wchar_t[] - Bone name (if length > 0)
    //          Bone structure
    //      }
    //      UINT - Animation clip count
    //      { [Animation clip count]
    //          UINT - Length of clip name
    //          wchar_t[] - Clip name (if length > 0)
    //          float - Start time
    //          float - End time
    //          UINT - Keyframe count
    //          { [Keyframe count]
    //              Keyframe structure
    //          }
    //      }
    // }

const
    MAX_TEXTURE = 8;
    NUM_BONE_INFLUENCES = 4;

type
    TMaterial = packed record
        Ambient: TXMFLOAT4;
        Diffuse: TXMFLOAT4;
        Specular: TXMFLOAT4;
        SpecularPower: single;
        Emissive: TXMFLOAT4;
        UVTransform: TXMFLOAT4X4;
    end;
    PMaterial = ^TMaterial;


    TSubMesh = packed record
        MaterialIndex: uint32;
        IndexBufferIndex: uint32;
        VertexBufferIndex: uint32;
        StartIndex: uint32;
        PrimCount: uint32;
    end;
    PSubMesh = ^TSubMesh;


    // Vertex struct for Visual Studio Shader Designer (DGSL) holding position, normal,
    // tangent, color (RGBA), and texture mapping information
    TVertex = packed record
        position: TXMFLOAT3;
        normal: TXMFLOAT3;
        tangent: TXMFLOAT4;
        color: uint32;
        textureCoordinate: TXMFLOAT2;
    end;
    PVertex = ^TVertex;


    TSkinningVertex = packed record
        boneIndex: array [0..NUM_BONE_INFLUENCES - 1] of uint32;
        boneWeight: array [0..NUM_BONE_INFLUENCES - 1] of single;
    end;
    PSkinningVertex = ^TSkinningVertex;


    TMeshExtents = packed record
        CenterX: single;
        CenterY: single;
        CenterZ: single;
        Radius: single;
        MinX: single;
        MinY: single;
        MinZ: single;
        MaxX: single;
        MaxY: single;
        MaxZ: single;
    end;
    PMeshExtents = ^TMeshExtents;


    TBone = packed record
        ParentIndex: int32;
        InvBindPos: TXMFLOAT4X4;
        BindPos: TXMFLOAT4X4;
        LocalTransform: TXMFLOAT4X4;
    end;
    PBone = ^TBone;


    TClip = packed record
        StartTime: single;
        EndTime: single;
        keys: uint32;
    end;
    PClip = ^TClip;


    TKeyframe = packed record
        BoneIndex: uint32;
        Time: single;
        Transform: TXMFLOAT4X4;
    end;
    PKeyframe = ^TKeyframe;


const
    s_defMaterial: TMaterial = (
        Ambient: (f: (0.2, 0.2, 0.2, 1.0));
        Diffuse: (f: (0.8, 0.8, 0.8, 1.0));
        Specular: (f: (0.0, 0.0, 0.0, 1.0));
        SpecularPower: 1.0;
        Emissive: (f: (0.0, 0.0, 0.0, 1.0));
        UVTransform: (m: (
        (1.0, 0.0, 0.0, 0.0),
        (0.0, 1.0, 0.0, 0.0),
        (0.0, 0.0, 1.0, 0.0),
        (0.0, 0.0, 0.0, 1.0))));


implementation


{$if sizeof(TMaterial) <> 132}
{$error CMO Mesh structure size incorrect}
{$endif}

{$if sizeof(TSubMesh) <> 20}
{$error CMO Mesh structure size incorrect}
{$endif}

{$if sizeof(TVertex) <> 52}
{$error CMO Mesh structure size incorrect}
{$endif}

{$if sizeof(TSkinningVertex) <> 32}
{$error CMO Mesh structure size incorrect}
{$endif}

{$if sizeof(TMeshExtents) <> 40}
{$error CMO Mesh structure size incorrect}
{$endif}

{$if sizeof(TBone) <> 196}
{$error CMO Mesh structure size incorrect}
{$endif}

{$if sizeof(TClip) <> 12}
{$error CMO Mesh structure size incorrect}
{$endif}
{$if sizeof(TKeyframe) <> 72}
{$error CMO Mesh structure size incorrect}
{$endif}

end.
