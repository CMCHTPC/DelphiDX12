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

   Copyright (C) Microsoft Corporation.  All Rights Reserved.
   Content:    D3DX10 mesh types and functions

   This unit consists of the following header files
   File name: d3dx10mesh.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3DX10Mesh;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3DCommon,
    DX12.D3D10;

    {$Z4}

const

    D3DX10_DLL = 'd3dx10_43.dll';

    // {7ED943DD-52E8-40b5-A8D8-76685C406330}
    IID_ID3DX10BaseMesh: TGUID = '{7ED943DD-52E8-40B5-A8D8-76685C406330}';


    // {04B0D117-1041-46b1-AA8A-3952848BA22E}
    IID_ID3DX10MeshBuffer: TGUID = '{04B0D117-1041-46B1-AA8A-3952848BA22E}';


    // {4020E5C2-1403-4929-883F-E2E849FAC195}
    IID_ID3DX10Mesh: TGUID = '{4020E5C2-1403-4929-883F-E2E849FAC195}';


    // {8875769A-D579-4088-AAEB-534D1AD84E96}
    IID_ID3DX10PMesh: TGUID = '{8875769A-D579-4088-AAEB-534D1AD84E96}';


    // {667EA4C7-F1CD-4386-B523-7C0290B83CC5}
    IID_ID3DX10SPMesh: TGUID = '{667EA4C7-F1CD-4386-B523-7C0290B83CC5}';


    // {3CE6CC22-DBF2-44f4-894D-F9C34A337139}
    IID_ID3DX10PatchMesh: TGUID = '{3CE6CC22-DBF2-44F4-894D-F9C34A337139}';

    // {420BD604-1C76-4a34-A466-E45D0658A32C}
    IID_ID3DX10SkinInfo: TGUID = '{420BD604-1C76-4A34-A466-E45D0658A32C}';


    // scaling modes for ID3DX10SkinInfo::Compact() & ID3DX10SkinInfo::UpdateMesh()
    D3DX10_SKININFO_NO_SCALING = 0;
    D3DX10_SKININFO_SCALE_TO_1 = 1;
    D3DX10_SKININFO_SCALE_TO_TOTAL = 2;

type

    PD3DXVECTOR3 = pointer; // ToDo
    PD3DXMATRIX = pointer; // ToDo

    // Mesh options - lower 3 bytes only, upper byte used by _D3DX10MESHOPT option flags
    _D3DX10_MESH = (
        D3DX10_MESH_32_BIT = $001, // If set, then use 32 bit indices, if not set use 16 bit indices.
        D3DX10_MESH_GS_ADJACENCY = $004// If set, mesh contains GS adjacency info. Not valid on input.
        );

    TD3DX10_MESH = _D3DX10_MESH;
    PD3DX10_MESH = ^TD3DX10_MESH;


    _D3DX10_ATTRIBUTE_RANGE = record
        AttribId: UINT;
        FaceStart: UINT;
        FaceCount: UINT;
        VertexStart: UINT;
        VertexCount: UINT;
    end;
    TD3DX10_ATTRIBUTE_RANGE = _D3DX10_ATTRIBUTE_RANGE;
    PD3DX10_ATTRIBUTE_RANGE = ^TD3DX10_ATTRIBUTE_RANGE;


    PLPD3DX10_ATTRIBUTE_RANGE = ^TD3DX10_ATTRIBUTE_RANGE;

    _D3DX10_MESH_DISCARD_FLAGS = (
        D3DX10_MESH_DISCARD_ATTRIBUTE_BUFFER = $01,
        D3DX10_MESH_DISCARD_ATTRIBUTE_TABLE = $02,
        D3DX10_MESH_DISCARD_POINTREPS = $04,
        D3DX10_MESH_DISCARD_ADJACENCY = $08,
        D3DX10_MESH_DISCARD_DEVICE_BUFFERS = $10);

    TD3DX10_MESH_DISCARD_FLAGS = _D3DX10_MESH_DISCARD_FLAGS;
    PD3DX10_MESH_DISCARD_FLAGS = ^TD3DX10_MESH_DISCARD_FLAGS;


    _D3DX10_WELD_EPSILONS = record
        Position: single; // NOTE: This does NOT replace the epsilon in GenerateAdjacency
        BlendWeights: single;
        Normal: single;
        PSize: single;
        Specular: single;
        Diffuse: single;
        Texcoord: array [0..8 - 1] of single;
        Tangent: single;
        Binormal: single;
        TessFactor: single;
    end;
    TD3DX10_WELD_EPSILONS = _D3DX10_WELD_EPSILONS;
    PD3DX10_WELD_EPSILONS = ^TD3DX10_WELD_EPSILONS;


    PLPD3DX10_WELD_EPSILONS = ^TD3DX10_WELD_EPSILONS;

    _D3DX10_INTERSECT_INFO = record
        FaceIndex: UINT; // index of face intersected
        U: single; // Barycentric Hit Coordinates
        V: single; // Barycentric Hit Coordinates
        Dist: single; // Ray-Intersection Parameter Distance
    end;
    TD3DX10_INTERSECT_INFO = _D3DX10_INTERSECT_INFO;
    PD3DX10_INTERSECT_INFO = ^TD3DX10_INTERSECT_INFO;

    LPD3DX10_INTERSECT_INFO = ^TD3DX10_INTERSECT_INFO;


    // ID3DX10MeshBuffer is used by D3DX10Mesh vertex and index buffers

    ID3DX10MeshBuffer = interface(IUnknown)
        ['{04B0D117-1041-46b1-AA8A-3952848BA22E}']
        // ID3DX10MeshBuffer
        function Map(
        {out} out ppData: pointer;
        {out} pSize: PSIZE_T): HRESULT; stdcall;

        function Unmap(): HRESULT; stdcall;

        function GetSize(): SIZE_T; stdcall;

    end;


    // D3DX10 Mesh interfaces

    ID3DX10Mesh = interface(IUnknown)
        ['{4020E5C2-1403-4929-883F-E2E849FAC195}']
        // ID3DX10Mesh
        function GetFaceCount(): UINT; stdcall;

        function GetVertexCount(): UINT; stdcall;

        function GetVertexBufferCount(): UINT; stdcall;

        function GetFlags(): UINT; stdcall;

        function GetVertexDescription(
        {out} out ppDesc: PD3D10_INPUT_ELEMENT_DESC; pDeclCount: PUINT): HRESULT; stdcall;

        function SetVertexData(iBuffer: UINT; pData: Pvoid): HRESULT; stdcall;

        function GetVertexBuffer(iBuffer: UINT; out ppVertexBuffer: ID3DX10MeshBuffer): HRESULT; stdcall;

        function SetIndexData(pData: Pvoid; cIndices: UINT): HRESULT; stdcall;

        function GetIndexBuffer(out ppIndexBuffer: ID3DX10MeshBuffer): HRESULT; stdcall;

        function SetAttributeData(pData: PUINT): HRESULT; stdcall;

        function GetAttributeBuffer(out ppAttributeBuffer: ID3DX10MeshBuffer): HRESULT; stdcall;

        function SetAttributeTable(pAttribTable: PD3DX10_ATTRIBUTE_RANGE; cAttribTableSize: UINT): HRESULT; stdcall;

        function GetAttributeTable(pAttribTable: PD3DX10_ATTRIBUTE_RANGE; pAttribTableSize: PUINT): HRESULT; stdcall;

        function GenerateAdjacencyAndPointReps(Epsilon: single): HRESULT; stdcall;

        function GenerateGSAdjacency(): HRESULT; stdcall;

        function SetAdjacencyData(pAdjacency: PUINT): HRESULT; stdcall;

        function GetAdjacencyBuffer(out ppAdjacency: ID3DX10MeshBuffer): HRESULT; stdcall;

        function SetPointRepData(pPointReps: PUINT): HRESULT; stdcall;

        function GetPointRepBuffer(out ppPointReps: ID3DX10MeshBuffer): HRESULT; stdcall;

        function Discard(dwDiscard: TD3DX10_MESH_DISCARD_FLAGS): HRESULT; stdcall;

        function CloneMesh(Flags: UINT; pPosSemantic: LPCSTR; pDesc: PD3D10_INPUT_ELEMENT_DESC; DeclCount: UINT; out ppCloneMesh: ID3DX10Mesh): HRESULT; stdcall;

        function Optimize(Flags: UINT; pFaceRemap: PUINT; out ppVertexRemap: ID3D10BLOB): HRESULT; stdcall;

        function GenerateAttributeBufferFromTable(): HRESULT; stdcall;

        function Intersect(pRayPos: PD3DXVECTOR3; pRayDir: PD3DXVECTOR3; pHitCount: PUINT; pFaceIndex: PUINT; pU: Psingle; pV: Psingle; pDist: Psingle; out ppAllHits: ID3D10Blob): HRESULT; stdcall;

        function IntersectSubset(AttribId: UINT; pRayPos: PD3DXVECTOR3; pRayDir: PD3DXVECTOR3; pHitCount: PUINT; pFaceIndex: PUINT; pU: Psingle; pV: Psingle; pDist: Psingle; out ppAllHits: ID3D10Blob): HRESULT; stdcall;

        // ID3DX10Mesh - Device functions
        function CommitToDevice(): HRESULT; stdcall;

        function DrawSubset(AttribId: UINT): HRESULT; stdcall;

        function DrawSubsetInstanced(AttribId: UINT; InstanceCount: UINT; StartInstanceLocation: UINT): HRESULT; stdcall;

        function GetDeviceVertexBuffer(iBuffer: UINT; out ppVertexBuffer: ID3DX10MeshBuffer): HRESULT; stdcall;

        function GetDeviceIndexBuffer(out ppIndexBuffer: ID3DX10MeshBuffer): HRESULT; stdcall;

    end;


    // ID3DX10Mesh::Optimize options - upper byte only, lower 3 bytes used from _D3DX10MESH option flags
    _D3DX10_MESHOPT = (
        D3DX10_MESHOPT_COMPACT = $01000000,
        D3DX10_MESHOPT_ATTR_SORT = $02000000,
        D3DX10_MESHOPT_VERTEX_CACHE = $04000000,
        D3DX10_MESHOPT_STRIP_REORDER = $08000000,
        D3DX10_MESHOPT_IGNORE_VERTS = $10000000, // optimize faces only, don't touch vertices
        D3DX10_MESHOPT_DO_NOT_SPLIT = $20000000, // do not split vertices shared between attribute groups when attribute sorting
        D3DX10_MESHOPT_DEVICE_INDEPENDENT = $00400000// Only affects VCache.  uses a static known good cache size for all cards
        // D3DX10_MESHOPT_SHAREVB has been removed, please use D3DX10MESH_VB_SHARE instead
        );

    TD3DX10_MESHOPT = _D3DX10_MESHOPT;
    PD3DX10_MESHOPT = ^TD3DX10_MESHOPT;


    //////////////////////////////////////////////////////////////////////////
    // ID3DXSkinInfo
    //////////////////////////////////////////////////////////////////////////


    _D3DX10_SKINNING_CHANNEL = record
        SrcOffset: UINT;
        DestOffset: UINT;
        IsNormal: boolean;
    end;
    TD3DX10_SKINNING_CHANNEL = _D3DX10_SKINNING_CHANNEL;
    PD3DX10_SKINNING_CHANNEL = ^TD3DX10_SKINNING_CHANNEL;


    ID3DX10SkinInfo = interface(IUnknown)
        ['{420BD604-1C76-4a34-A466-E45D0658A32C}']
        // IUnknown
        function GetNumVertices(): UINT; stdcall;

        function GetNumBones(): UINT; stdcall;

        function GetMaxBoneInfluences(): UINT; stdcall;

        function AddVertices(Count: UINT): HRESULT; stdcall;

        function RemapVertices(NewVertexCount: UINT; pVertexRemap: PUINT): HRESULT; stdcall;

        function AddBones(Count: UINT): HRESULT; stdcall;

        function RemoveBone(Index: UINT): HRESULT; stdcall;

        function RemapBones(NewBoneCount: UINT; pBoneRemap: PUINT): HRESULT; stdcall;

        function AddBoneInfluences(BoneIndex: UINT; InfluenceCount: UINT; pIndices: PUINT; pWeights: Psingle): HRESULT; stdcall;

        function ClearBoneInfluences(BoneIndex: UINT): HRESULT; stdcall;

        function GetBoneInfluenceCount(BoneIndex: UINT): UINT; stdcall;

        function GetBoneInfluences(BoneIndex: UINT; Offset: UINT; Count: UINT; pDestIndices: PUINT; pDestWeights: Psingle): HRESULT; stdcall;

        function FindBoneInfluenceIndex(BoneIndex: UINT; VertexIndex: UINT; pInfluenceIndex: PUINT): HRESULT; stdcall;

        function SetBoneInfluence(BoneIndex: UINT; InfluenceIndex: UINT; Weight: single): HRESULT; stdcall;

        function GetBoneInfluence(BoneIndex: UINT; InfluenceIndex: UINT; pWeight: Psingle): HRESULT; stdcall;

        function Compact(MaxPerVertexInfluences: UINT; ScaleMode: UINT; MinWeight: single): HRESULT; stdcall;

        function DoSoftwareSkinning(StartVertex: UINT; VertexCount: UINT; pSrcVertices: Pvoid; SrcStride: UINT; pDestVertices: Pvoid; DestStride: UINT; pBoneMatrices: PD3DXMATRIX;
            pInverseTransposeBoneMatrices: PD3DXMATRIX; pChannelDescs: PD3DX10_SKINNING_CHANNEL; NumChannels: UINT): HRESULT; stdcall;

    end;

    LPD3DX10SKININFO = ^ID3DX10SkinInfo;

    _D3DX10_ATTRIBUTE_WEIGHTS = record
        Position: single;
        Boundary: single;
        Normal: single;
        Diffuse: single;
        Specular: single;
        Texcoord: array [0..8 - 1] of single;
        Tangent: single;
        Binormal: single;
    end;
    TD3DX10_ATTRIBUTE_WEIGHTS = _D3DX10_ATTRIBUTE_WEIGHTS;
    PD3DX10_ATTRIBUTE_WEIGHTS = ^TD3DX10_ATTRIBUTE_WEIGHTS;

    LPD3DX10_ATTRIBUTE_WEIGHTS = ^TD3DX10_ATTRIBUTE_WEIGHTS;


    // Flat API

function D3DX10CreateMesh(pDevice: ID3D10Device; pDeclaration: PD3D10_INPUT_ELEMENT_DESC; DeclCount: UINT; pPositionSemantic: LPCSTR; VertexCount: UINT; FaceCount: UINT; Options: UINT;
    out ppMesh: ID3DX10Mesh): HRESULT; stdcall; external D3DX10_DLL;


function D3DX10CreateSkinInfo(out ppSkinInfo: ID3DX10SKININFO): HRESULT; stdcall; external D3DX10_DLL;


implementation

end.
