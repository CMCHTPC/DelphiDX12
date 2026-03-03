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
   Content:    D3DX mesh types and functions

   This unit consists of the following header files
   File name: d3dx9mesh.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3DX9Mesh9;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    Win32.ObjIdl,
    DX12.D3D9,
    DX12.D3D9Types,
    DX12.D3DX9,
    DX12.D3DX9Core,
    DX12.D3DX9Math,
    DX12.DXFile; // defines LPDIRECTXFILEDATA

    {$Z4}

const
    D3DX9_DLL = 'D3DX9_43.dll';


const

    // {2A835771-BF4D-43f4-8E14-82A809F17D8A}
    IID_ID3DXBaseMesh: TGUID = '{2A835771-BF4D-43F4-8E14-82A809F17D8A}';


    // {CCAE5C3B-4DD1-4d0f-997E-4684CA64557F}
    IID_ID3DXMesh: TGUID = '{CCAE5C3B-4DD1-4D0F-997E-4684CA64557F}';


    // {19FBE386-C282-4659-97BD-CB869B084A6C}
    IID_ID3DXPMesh: TGUID = '{19FBE386-C282-4659-97BD-CB869B084A6C}';


    // {4E3CA05C-D4FF-4d11-8A02-16459E08F6F4}
    IID_ID3DXSPMesh: TGUID = '{4E3CA05C-D4FF-4D11-8A02-16459E08F6F4}';


    // {0E7DBBF3-421A-4dd8-B738-A5DAC3A48767}
    IID_ID3DXSkinInfo: TGUID = '{0E7DBBF3-421A-4DD8-B738-A5DAC3A48767}';


    // {0AD3E8BC-290D-4dc7-91AB-73A82755B13E}
    IID_ID3DXPatchMesh: TGUID = '{0AD3E8BC-290D-4DC7-91AB-73A82755B13E}';


    UNUSED16 = ($ffff);
    UNUSED32 = ($ffffffff);


    //////////////////////////////////////////////////////////////////////////////

    //  Definitions of .X file templates used by mesh load/save functions
    //    that are not RM standard

    //////////////////////////////////////////////////////////////////////////////
    // {3CF169CE-FF7C-44ab-93C0-F78F62D172E2}

    DXFILEOBJ_XSkinMeshHeader: TGUID = '{3CF169CE-FF7C-44AB-93C0-F78F62D172E2}';


    // {B8D65549-D7C9-4995-89CF-53A9A8B031E3}
    DXFILEOBJ_VertexDuplicationIndices: TGUID = '{B8D65549-D7C9-4995-89CF-53A9A8B031E3}';


    // {A64C844A-E282-4756-8B80-250CDE04398C}
    DXFILEOBJ_FaceAdjacency: TGUID = '{A64C844A-E282-4756-8B80-250CDE04398C}';


    // {6F0D123B-BAD2-4167-A0D0-80224F25FABB}
    DXFILEOBJ_SkinWeights: TGUID = '{6F0D123B-BAD2-4167-A0D0-80224F25FABB}';


    // {A3EB5D44-FC22-429d-9AFB-3221CB9719A6}
    DXFILEOBJ_Patch: TGUID = '{A3EB5D44-FC22-429D-9AFB-3221CB9719A6}';


    // {D02C95CC-EDBA-4305-9B5D-1820D7704BBF}
    DXFILEOBJ_PatchMesh: TGUID = '{D02C95CC-EDBA-4305-9B5D-1820D7704BBF}';


    // {B9EC94E1-B9A6-4251-BA18-94893F02C0EA}
    DXFILEOBJ_PatchMesh9: TGUID = '{B9EC94E1-B9A6-4251-BA18-94893F02C0EA}';


    // {B6C3E656-EC8B-4b92-9B62-681659522947}
    DXFILEOBJ_PMInfo: TGUID = '{B6C3E656-EC8B-4B92-9B62-681659522947}';


    // {917E0427-C61E-4a14-9C64-AFE65F9E9844}
    DXFILEOBJ_PMAttributeRange: TGUID = '{917E0427-C61E-4A14-9C64-AFE65F9E9844}';


    // {574CCC14-F0B3-4333-822D-93E8A8A08E4C}
    DXFILEOBJ_PMVSplitRecord: TGUID = '{574CCC14-F0B3-4333-822D-93E8A8A08E4C}';


    // {B6E70A0E-8EF9-4e83-94AD-ECC8B0C04897}
    DXFILEOBJ_FVFData: TGUID = '{B6E70A0E-8EF9-4E83-94AD-ECC8B0C04897}';


    // {F752461C-1E23-48f6-B9F8-8350850F336F}
    DXFILEOBJ_VertexElement: TGUID = '{F752461C-1E23-48F6-B9F8-8350850F336F}';


    // {BF22E553-292C-4781-9FEA-62BD554BDD93}
    DXFILEOBJ_DeclData: TGUID = '{BF22E553-292C-4781-9FEA-62BD554BDD93}';


    // {F1CFE2B3-0DE3-4e28-AFA1-155A750A282D}
    DXFILEOBJ_EffectFloats: TGUID = '{F1CFE2B3-0DE3-4E28-AFA1-155A750A282D}';


    // {D55B097E-BDB6-4c52-B03D-6051C89D0E42}
    DXFILEOBJ_EffectString: TGUID = '{D55B097E-BDB6-4C52-B03D-6051C89D0E42}';


    // {622C0ED0-956E-4da9-908A-2AF94F3CE716}
    DXFILEOBJ_EffectDWord: TGUID = '{622C0ED0-956E-4DA9-908A-2AF94F3CE716}';


    // {3014B9A0-62F5-478c-9B86-E4AC9F4E418B}
    DXFILEOBJ_EffectParamFloats: TGUID = '{3014B9A0-62F5-478C-9B86-E4AC9F4E418B}';


    // {1DBC4C88-94C1-46ee-9076-2C28818C9481}
    DXFILEOBJ_EffectParamString: TGUID = '{1DBC4C88-94C1-46EE-9076-2C28818C9481}';


    // {E13963BC-AE51-4c5d-B00F-CFA3A9D97CE5}
    DXFILEOBJ_EffectParamDWord: TGUID = '{E13963BC-AE51-4C5D-B00F-CFA3A9D97CE5}';


    // {E331F7E4-0559-4cc2-8E99-1CEC1657928F}
    DXFILEOBJ_EffectInstance: TGUID = '{E331F7E4-0559-4CC2-8E99-1CEC1657928F}';


    // {9E415A43-7BA6-4a73-8743-B73D47E88476}
    DXFILEOBJ_AnimTicksPerSecond: TGUID = '{9E415A43-7BA6-4A73-8743-B73D47E88476}';

    XSkinMeshHeader_Template = ansistring('template XSkinMeshHeader { <3CF169CE-FF7C-44ab-93C0-F78F62D172E2>  WORD nMaxSkinWeightsPerVertex; WORD nMaxSkinWeightsPerFace; WORD nBones; }');
    VertexDuplicationIndices_Template = ansistring('template VertexDuplicationIndices { <B8D65549-D7C9-4995-89CF-53A9A8B031E3> DWORD nIndices; DWORD nOriginalVertices; array DWORD indices[nIndices]; }');
    FaceAdjacency_Template = ansistring('template FaceAdjacency { <A64C844A-E282-4756-8B80-250CDE04398C> DWORD nIndices; array DWORD indices[nIndices]; }');
    SkinWeights_Template = ansistring('template SkinWeights { <6F0D123B-BAD2-4167-A0D0-80224F25FABB> STRING transformNodeName; DWORD nWeights; array DWORD vertexIndices[nWeights]; array float weights[nWeights]; Matrix4x4 matrixOffset; }');
    Patch_Template = ansistring('template Patch { <A3EB5D44-FC22-429D-9AFB-3221CB9719A6> DWORD nControlIndices; array DWORD controlIndices[nControlIndices]; }');
    PatchMesh_Template = ansistring('template PatchMesh { <D02C95CC-EDBA-4305-9B5D-1820D7704BBF> DWORD nVertices; array Vector vertices[nVertices]; DWORD nPatches; array Patch patches[nPatches]; [ ... ] }');
    PatchMesh9_Template = ansistring('template PatchMesh9 { <B9EC94E1-B9A6-4251-BA18-94893F02C0EA> DWORD Type; DWORD Degree; DWORD Basis; DWORD nVertices; array Vector vertices[nVertices]; DWORD nPatches;  array Patch patches[nPatches]; [ ... ] }');
    EffectFloats_Template = ansistring('template EffectFloats { <F1CFE2B3-0DE3-4e28-AFA1-155A750A282D> DWORD nFloats; array float Floats[nFloats]; }');
    EffectString_Template = ansistring('template EffectString { <D55B097E-BDB6-4c52-B03D-6051C89D0E42> STRING Value; }');
    EffectDWord_Template = ansistring('template EffectDWord { <622C0ED0-956E-4da9-908A-2AF94F3CE716> DWORD Value; }');
    EffectParamFloats_Template = ansistring('template EffectParamFloats { <3014B9A0-62F5-478c-9B86-E4AC9F4E418B> STRING ParamName; DWORD nFloats; array float Floats[nFloats]; }');
    EffectParamString_Template = ansistring('template EffectParamString { <1DBC4C88-94C1-46ee-9076-2C28818C9481> STRING ParamName; STRING Value; }');
    EffectParamDWord_Template = ansistring('template EffectParamDWord { <E13963BC-AE51-4c5d-B00F-CFA3A9D97CE5> STRING ParamName; DWORD Value; }');
    EffectInstance_Template = ansistring('template EffectInstance { <E331F7E4-0559-4cc2-8E99-1CEC1657928F> STRING EffectFilename; [ ... ] }');
    AnimTicksPerSecond_Template = ansistring('template { <9E415A43-7BA6-4a73-8743-B73D47E88476> DWORD AnimTicksPerSecond; }');


    XSKINEXP_TEMPLATES = ansistring('"xof 0303txt 0032' + XSkinMeshHeader_Template + VertexDuplicationIndices_Template + FaceAdjacency_Template + SkinWeights_Template + Patch_Template +
        PatchMesh_Template + PatchMesh9_Template + '" "' + EffectFloats_Template + EffectString_Template + EffectDWord_Template + '" "' + EffectParamFloats_Template + '" "' + EffectParamString_Template +
        EffectParamDWord_Template + EffectInstance_Template + '" "' + AnimTicksPerSecond_Template + '"');


    FVFData_Template = ansistring('template FVFData { <B6E70A0E-8EF9-4e83-94AD-ECC8B0C04897> DWORD dwFVF; DWORD nDWords; array DWORD data[nDWords]; }');

    VertexElement_Template = ansistring('template VertexElement { <F752461C-1E23-48f6-B9F8-8350850F336F> DWORD Type; DWORD Method; DWORD Usage; DWORD UsageIndex; }');
    DeclData_Template = ansistring('template DeclData { <BF22E553-292C-4781-9FEA-62BD554BDD93> DWORD nElements; array VertexElement Elements[nElements]; DWORD nDWords;  array DWORD data[nDWords]; }');
    PMAttributeRange_Template = ansistring('template PMAttributeRange { <917E0427-C61E-4a14-9C64-AFE65F9E9844> DWORD iFaceOffset; DWORD nFacesMin; DWORD nFacesMax; DWORD iVertexOffset; DWORD nVerticesMin; DWORD nVerticesMax; }');
    PMVSplitRecord_Template = ansistring('template PMVSplitRecord { <574CCC14-F0B3-4333-822D-93E8A8A08E4C> DWORD iFaceCLW;  DWORD iVlrOffset; DWORD iCode; }');
    PMInfo_Template =
        ansistring('template PMInfo { <B6C3E656-EC8B-4b92-9B62-681659522947> DWORD nAttributes; array PMAttributeRange attributeRanges[nAttributes]; DWORD nMaxValence; DWORD nMinLogicalVertices; DWORD nMaxLogicalVertices; DWORD nVSplits;  array PMVSplitRecord splitRecords[nVSplits];DWORD nAttributeMispredicts; array DWORD attributeMispredicts[nAttributeMispredicts]; }');


    XEXTENSIONS_TEMPLATES = ansistring('"xof 0303txt 0032' + FVFData_Template + VertexElement_Template + DeclData_Template + PMAttributeRange_Template + PMVSplitRecord_Template + PMInfo_Template + '"');


type

    //patch mesh can be quads or tris
    _D3DXPATCHMESHTYPE = (
        D3DXPATCHMESH_RECT = $001,
        D3DXPATCHMESH_TRI = $002,
        D3DXPATCHMESH_NPATCH = $003,
        D3DXPATCHMESH_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    TD3DXPATCHMESHTYPE = _D3DXPATCHMESHTYPE;
    PD3DXPATCHMESHTYPE = ^TD3DXPATCHMESHTYPE;



    // Mesh options - lower 3 bytes only, upper byte used by _D3DXMESHOPT option flags
    _D3DXMESH = (
        D3DXMESH_32BIT = $001, // If set, then use 32 bit indices, if not set use 16 bit indices.
        D3DXMESH_DONOTCLIP = $002, // Use D3DUSAGE_DONOTCLIP for VB & IB.
        D3DXMESH_POINTS = $004, // Use D3DUSAGE_POINTS for VB & IB.
        D3DXMESH_RTPATCHES = $008, // Use D3DUSAGE_RTPATCHES for VB & IB.
        D3DXMESH_NPATCHES = $4000, // Use D3DUSAGE_NPATCHES for VB & IB.
        D3DXMESH_VB_SYSTEMMEM = $010, // Use D3DPOOL_SYSTEMMEM for VB. Overrides D3DXMESH_MANAGEDVERTEXBUFFER
        D3DXMESH_VB_MANAGED = $020, // Use D3DPOOL_MANAGED for VB.
        D3DXMESH_VB_WRITEONLY = $040, // Use D3DUSAGE_WRITEONLY for VB.
        D3DXMESH_VB_DYNAMIC = $080, // Use D3DUSAGE_DYNAMIC for VB.
        D3DXMESH_VB_SOFTWAREPROCESSING = $8000, // Use D3DUSAGE_SOFTWAREPROCESSING for VB.
        D3DXMESH_IB_SYSTEMMEM = $100, // Use D3DPOOL_SYSTEMMEM for IB. Overrides D3DXMESH_MANAGEDINDEXBUFFER
        D3DXMESH_IB_MANAGED = $200, // Use D3DPOOL_MANAGED for IB.
        D3DXMESH_IB_WRITEONLY = $400, // Use D3DUSAGE_WRITEONLY for IB.
        D3DXMESH_IB_DYNAMIC = $800, // Use D3DUSAGE_DYNAMIC for IB.
        D3DXMESH_IB_SOFTWAREPROCESSING = $10000, // Use D3DUSAGE_SOFTWAREPROCESSING for IB.
        D3DXMESH_VB_SHARE = $1000, // Valid for Clone* calls only, forces cloned mesh/pmesh to share vertex buffer
        D3DXMESH_USEHWONLY = $2000, // Valid for ID3DXSkinMesh::ConvertToBlendedMesh
        // Helper options
        D3DXMESH_SYSTEMMEM = $110, // D3DXMESH_VB_SYSTEMMEM | D3DXMESH_IB_SYSTEMMEM
        D3DXMESH_MANAGED = $220, // D3DXMESH_VB_MANAGED | D3DXMESH_IB_MANAGED
        D3DXMESH_WRITEONLY = $440, // D3DXMESH_VB_WRITEONLY | D3DXMESH_IB_WRITEONLY
        D3DXMESH_DYNAMIC = $880, // D3DXMESH_VB_DYNAMIC | D3DXMESH_IB_DYNAMIC
        D3DXMESH_SOFTWAREPROCESSING = $18000// D3DXMESH_VB_SOFTWAREPROCESSING | D3DXMESH_IB_SOFTWAREPROCESSING
        );

    TD3DXMESH = _D3DXMESH;
    PD3DXMESH = ^TD3DXMESH;



    //patch mesh options
    _D3DXPATCHMESH = (
        D3DXPATCHMESH_DEFAULT = &00);

    TD3DXPATCHMESH = _D3DXPATCHMESH;
    PD3DXPATCHMESH = ^TD3DXPATCHMESH;

    // option field values for specifying min value in D3DXGeneratePMesh and D3DXSimplifyMesh
    _D3DXMESHSIMP = (
        D3DXMESHSIMP_VERTEX = $1,
        D3DXMESHSIMP_FACE = $2);

    TD3DXMESHSIMP = _D3DXMESHSIMP;
    PD3DXMESHSIMP = ^TD3DXMESHSIMP;


    _MAX_FVF_DECL_SIZE = (
        MAX_FVF_DECL_SIZE = MAXD3DDECLLENGTH + 1// +1 for END
        );

    TMAX_FVF_DECL_SIZE = _MAX_FVF_DECL_SIZE;
    PMAX_FVF_DECL_SIZE = ^TMAX_FVF_DECL_SIZE;



    _D3DXATTRIBUTERANGE = record
        AttribId: DWORD;
        FaceStart: DWORD;
        FaceCount: DWORD;
        VertexStart: DWORD;
        VertexCount: DWORD;
    end;
    TD3DXATTRIBUTERANGE = _D3DXATTRIBUTERANGE;
    PD3DXATTRIBUTERANGE = ^TD3DXATTRIBUTERANGE;
    LPD3DXATTRIBUTERANGE = ^TD3DXATTRIBUTERANGE;

    _D3DXMATERIAL = record
        MatD3D: TD3DMATERIAL9;
        pTextureFilename: LPSTR;
    end;
    TD3DXMATERIAL = _D3DXMATERIAL;
    PD3DXMATERIAL = ^TD3DXMATERIAL;
    LPD3DXMATERIAL = ^TD3DXMATERIAL;

    _D3DXEFFECTDEFAULTTYPE = (
        D3DXEDT_STRING = $1, // pValue points to a null terminated ASCII string
        D3DXEDT_FLOATS = $2, // pValue points to an array of floats - number of floats is NumBytes / sizeof(float)
        D3DXEDT_DWORD = $3, // pValue points to a DWORD
        D3DXEDT_FORCEDWORD = $7fffffff);

    TD3DXEFFECTDEFAULTTYPE = _D3DXEFFECTDEFAULTTYPE;
    PD3DXEFFECTDEFAULTTYPE = ^TD3DXEFFECTDEFAULTTYPE;


    _D3DXEFFECTDEFAULT = record
        pParamName: LPSTR;
        DefaultType: TD3DXEFFECTDEFAULTTYPE; // type of the data pointed to by pValue
        NumBytes: DWORD; // size in bytes of the data pointed to by pValue
        pValue: LPVOID; // data for the default of the effect
    end;
    TD3DXEFFECTDEFAULT = _D3DXEFFECTDEFAULT;
    PD3DXEFFECTDEFAULT = ^TD3DXEFFECTDEFAULT;
    LPD3DXEFFECTDEFAULT = ^TD3DXEFFECTDEFAULT;


    _D3DXEFFECTINSTANCE = record
        pEffectFilename: LPSTR;
        NumDefaults: DWORD;
        pDefaults: LPD3DXEFFECTDEFAULT;
    end;
    TD3DXEFFECTINSTANCE = _D3DXEFFECTINSTANCE;
    PD3DXEFFECTINSTANCE = ^TD3DXEFFECTINSTANCE;
    LPD3DXEFFECTINSTANCE = ^TD3DXEFFECTINSTANCE;

    _D3DXATTRIBUTEWEIGHTS = record
        Position: single;
        Boundary: single;
        Normal: single;
        Diffuse: single;
        Specular: single;
        Texcoord: array [0..7] of single;
        Tangent: single;
        Binormal: single;
    end;
    TD3DXATTRIBUTEWEIGHTS = _D3DXATTRIBUTEWEIGHTS;
    PD3DXATTRIBUTEWEIGHTS = ^TD3DXATTRIBUTEWEIGHTS;
    LPD3DXATTRIBUTEWEIGHTS = ^TD3DXATTRIBUTEWEIGHTS;

    _D3DXWELDEPSILONSFLAGS = (
        D3DXWELDEPSILONS_WELDALL = $1, // weld all vertices marked by adjacency as being overlapping
        D3DXWELDEPSILONS_WELDPARTIALMATCHES = $2, // if a given vertex component is within epsilon, modify partial matched
        // vertices so that both components identical AND if all components "equal"
        // remove one of the vertices
        D3DXWELDEPSILONS_DONOTREMOVEVERTICES = $4, // instructs weld to only allow modifications to vertices and not removal
        // ONLY valid if D3DXWELDEPSILONS_WELDPARTIALMATCHES is set
        // useful to modify vertices to be equal, but not allow vertices to be removed
        D3DXWELDEPSILONS_DONOTSPLIT = $8// instructs weld to specify the D3DXMESHOPT_DONOTSPLIT flag when doing an Optimize(ATTR_SORT)
        // if this flag is not set, all vertices that are in separate attribute groups
        // will remain split and not welded.  Setting this flag can slow down software vertex processing
        );

    TD3DXWELDEPSILONSFLAGS = _D3DXWELDEPSILONSFLAGS;
    PD3DXWELDEPSILONSFLAGS = ^TD3DXWELDEPSILONSFLAGS;


    _D3DXWELDEPSILONS = record
        Position: single; // NOTE: This does NOT replace the epsilon in GenerateAdjacency
        BlendWeights: single;
        Normal: single;
        PSize: single;
        Specular: single;
        Diffuse: single;
        Texcoord: array [0..7] of single;
        Tangent: single;
        Binormal: single;
        TessFactor: single;
    end;
    TD3DXWELDEPSILONS = _D3DXWELDEPSILONS;
    PD3DXWELDEPSILONS = ^TD3DXWELDEPSILONS;
    LPD3DXWELDEPSILONS = ^TD3DXWELDEPSILONS;

    ID3DXBaseMesh = interface;
    LPD3DXBASEMESH = ^ID3DXBaseMesh;

    ID3DXMesh = interface;
    LPD3DXMESH = ^ID3DXMesh;

    ID3DXPMesh = interface;
    LPD3DXPMESH = ^ID3DXPMesh;

    ID3DXSPMesh = interface;
    LPD3DXSPMESH = ^ID3DXSPMesh;

    ID3DXSkinInfo = interface;
    LPD3DXSKININFO = ^ID3DXSkinInfo;

    ID3DXPatchMesh = interface;
    LPD3DXPATCHMESH = ^ID3DXPatchMesh;

    TMAX_FVFVertexArray = array [0..Ord(MAX_FVF_DECL_SIZE) - 1] of TD3DVERTEXELEMENT9;
    PMAX_FVFVertexArray = ^TMAX_FVFVertexArray;

    ID3DXBaseMesh = interface(IUnknown)
        ['{2A835771-BF4D-43F4-8E14-82A809F17D8A}']
        // ID3DXBaseMesh
        function DrawSubset(AttribId: DWORD): HRESULT; stdcall;

        function GetNumFaces(): DWORD; stdcall;

        function GetNumVertices(): DWORD; stdcall;

        function GetFVF(): DWORD; stdcall;

        function GetDeclaration(Declaration: TMAX_FVFVertexArray // array [0..MAX_FVF_DECL_SIZE-1] of TD3DVERTEXELEMENT9
            ): HRESULT; stdcall;

        function GetNumBytesPerVertex(): DWORD; stdcall;

        function GetOptions(): DWORD; stdcall;

        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;

        function CloneMeshFVF(Options: DWORD; FVF: DWORD; pD3DDevice: IDirect3DDevice9; out ppCloneMesh: ID3DXMesh): HRESULT; stdcall;

        function CloneMesh(Options: DWORD; pDeclaration: PD3DVERTEXELEMENT9; pD3DDevice: IDirect3DDevice9; out ppCloneMesh: ID3DXMesh): HRESULT; stdcall;

        function GetVertexBuffer(out ppVB: IDirect3DVertexBuffer9): HRESULT; stdcall;

        function GetIndexBuffer(out ppIB: IDirect3DIndexBuffer9): HRESULT; stdcall;

        function LockVertexBuffer(Flags: DWORD; out ppData: pointer): HRESULT; stdcall;

        function UnlockVertexBuffer(): HRESULT; stdcall;

        function LockIndexBuffer(Flags: DWORD; out ppData: pointer): HRESULT; stdcall;

        function UnlockIndexBuffer(): HRESULT; stdcall;

        function GetAttributeTable(pAttribTable: PD3DXATTRIBUTERANGE; pAttribTableSize: PDWORD): HRESULT; stdcall;

        function ConvertPointRepsToAdjacency(pPRep: PDWORD; pAdjacency: PDWORD): HRESULT; stdcall;

        function ConvertAdjacencyToPointReps(pAdjacency: PDWORD; pPRep: PDWORD): HRESULT; stdcall;

        function GenerateAdjacency(Epsilon: single; pAdjacency: PDWORD): HRESULT; stdcall;

        function UpdateSemantics(Declaration: TMAX_FVFVertexArray): HRESULT; stdcall;

    end;




    ID3DXMesh = interface(ID3DXBaseMesh)
        ['{CCAE5C3B-4DD1-4D0F-997E-4684CA64557F}']
        // ID3DXMesh
        function LockAttributeBuffer(Flags: DWORD; out ppData: PDWORD): HRESULT; stdcall;

        function UnlockAttributeBuffer(): HRESULT; stdcall;

        function Optimize(Flags: DWORD; pAdjacencyIn: PDWORD; pAdjacencyOut: PDWORD; pFaceRemap: PDWORD; out ppVertexRemap: ID3DXBuffer; out ppOptMesh: ID3DXMesh): HRESULT; stdcall;

        function OptimizeInplace(Flags: DWORD; pAdjacencyIn: PDWORD; pAdjacencyOut: PDWORD; pFaceRemap: PDWORD; out ppVertexRemap: ID3DXBuffer): HRESULT; stdcall;

        function SetAttributeTable(pAttribTable: PD3DXATTRIBUTERANGE; cAttribTableSize: DWORD): HRESULT; stdcall;

    end;



    ID3DXPMesh = interface(ID3DXBaseMesh)
        ['{19FBE386-C282-4659-97BD-CB869B084A6C}']
        // ID3DXPMesh
        function ClonePMeshFVF(Options: DWORD; FVF: DWORD; pD3D: IDirect3DDevice9; out ppCloneMesh: ID3DXPMesh): HRESULT; stdcall;

        function ClonePMesh(Options: DWORD; pDeclaration: PD3DVERTEXELEMENT9; pD3D: IDirect3DDevice9; out ppCloneMesh: ID3DXPMesh): HRESULT; stdcall;

        function SetNumFaces(Faces: DWORD): HRESULT; stdcall;

        function SetNumVertices(Vertices: DWORD): HRESULT; stdcall;

        function GetMaxFaces(): DWORD; stdcall;

        function GetMinFaces(): DWORD; stdcall;

        function GetMaxVertices(): DWORD; stdcall;

        function GetMinVertices(): DWORD; stdcall;

        function Save(pStream: IStream; pMaterials: PD3DXMATERIAL; pEffectInstances: PD3DXEFFECTINSTANCE; NumMaterials: DWORD): HRESULT; stdcall;

        function Optimize(Flags: DWORD; pAdjacencyOut: PDWORD; pFaceRemap: PDWORD; out ppVertexRemap: ID3DXBuffer; out ppOptMesh: ID3DXMesh): HRESULT; stdcall;

        function OptimizeBaseLOD(Flags: DWORD; pFaceRemap: PDWORD): HRESULT; stdcall;

        function TrimByFaces(NewFacesMin: DWORD; NewFacesMax: DWORD; rgiFaceRemap: PDWORD; rgiVertRemap: PDWORD): HRESULT; stdcall;

        function TrimByVertices(NewVerticesMin: DWORD; NewVerticesMax: DWORD; rgiFaceRemap: PDWORD; rgiVertRemap: PDWORD): HRESULT; stdcall;

        function GetAdjacency(pAdjacency: PDWORD): HRESULT; stdcall;

        //  Used to generate the immediate "ancestor" for each vertex when it is removed by a vsplit.  Allows generation of geomorphs
        //     Vertex buffer must be equal to or greater than the maximum number of vertices in the pmesh
        function GenerateVertexHistory(pVertexHistory: PDWORD): HRESULT; stdcall;

    end;



    ID3DXSPMesh = interface(IUnknown)
        ['{4E3CA05C-D4FF-4D11-8A02-16459E08F6F4}']
        // ID3DXSPMesh
        function GetNumFaces(): DWORD; stdcall;

        function GetNumVertices(): DWORD; stdcall;

        function GetFVF(): DWORD; stdcall;

        function GetDeclaration(Declaration: TMAX_FVFVertexArray // array [0..MAX_FVF_DECL_SIZE-1] of TD3DVERTEXELEMENT9
            ): HRESULT; stdcall;

        function GetOptions(): DWORD; stdcall;

        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;

        function CloneMeshFVF(Options: DWORD; FVF: DWORD; pD3D: IDirect3DDevice9; pAdjacencyOut: PDWORD; pVertexRemapOut: PDWORD; out ppCloneMesh: ID3DXMesh): HRESULT; stdcall;

        function CloneMesh(Options: DWORD; pDeclaration: PD3DVERTEXELEMENT9; pD3DDevice: IDirect3DDevice9; pAdjacencyOut: PDWORD; pVertexRemapOut: PDWORD; out ppCloneMesh: ID3DXMesh): HRESULT; stdcall;

        function ClonePMeshFVF(Options: DWORD; FVF: DWORD; pD3D: IDirect3DDevice9; pVertexRemapOut: PDWORD; pErrorsByFace: Psingle; out ppCloneMesh: ID3DXPMesh): HRESULT; stdcall;

        function ClonePMesh(Options: DWORD; pDeclaration: PD3DVERTEXELEMENT9; pD3D: IDirect3DDevice9; pVertexRemapOut: PDWORD; pErrorsbyFace: Psingle; out ppCloneMesh: ID3DXPMesh): HRESULT; stdcall;

        function ReduceFaces(Faces: DWORD): HRESULT; stdcall;

        function ReduceVertices(Vertices: DWORD): HRESULT; stdcall;

        function GetMaxFaces(): DWORD; stdcall;

        function GetMaxVertices(): DWORD; stdcall;

        function GetVertexAttributeWeights(pVertexAttributeWeights: LPD3DXATTRIBUTEWEIGHTS): HRESULT; stdcall;

        function GetVertexWeights(pVertexWeights: Psingle): HRESULT; stdcall;

    end;



    // ID3DXMesh::Optimize options - upper byte only, lower 3 bytes used from _D3DXMESH option flags
    _D3DXMESHOPT = (
        D3DXMESHOPT_COMPACT = $01000000,
        D3DXMESHOPT_ATTRSORT = $02000000,
        D3DXMESHOPT_VERTEXCACHE = $04000000,
        D3DXMESHOPT_STRIPREORDER = $08000000,
        D3DXMESHOPT_IGNOREVERTS = $10000000, // optimize faces only, don't touch vertices
        D3DXMESHOPT_DONOTSPLIT = $20000000, // do not split vertices shared between attribute groups when attribute sorting
        D3DXMESHOPT_DEVICEINDEPENDENT = $00400000// Only affects VCache.  uses a static known good cache size for all cards
        // D3DXMESHOPT_SHAREVB has been removed, please use D3DXMESH_VB_SHARE instead
        );

    TD3DXMESHOPT = _D3DXMESHOPT;
    PD3DXMESHOPT = ^TD3DXMESHOPT;


    // Subset of the mesh that has the same attribute and bone combination.
    // This subset can be rendered in a single draw call
    _D3DXBONECOMBINATION = record
        AttribId: DWORD;
        FaceStart: DWORD;
        FaceCount: DWORD;
        VertexStart: DWORD;
        VertexCount: DWORD;
        BoneId: PDWORD;
    end;
    TD3DXBONECOMBINATION = _D3DXBONECOMBINATION;
    PD3DXBONECOMBINATION = ^TD3DXBONECOMBINATION;
    LPD3DXBONECOMBINATION = ^TD3DXBONECOMBINATION;

    // The following types of patch combinations are supported:
    // Patch type   Basis       Degree
    // Rect         Bezier      2,3,5
    // Rect         B-Spline    2,3,5
    // Rect         Catmull-Rom 3
    // Tri          Bezier      2,3,5
    // N-Patch      N/A         3

    _D3DXPATCHINFO = record
        PatchType: TD3DXPATCHMESHTYPE;
        Degree: TD3DDEGREETYPE;
        Basis: TD3DBASISTYPE;
    end;
    TD3DXPATCHINFO = _D3DXPATCHINFO;
    PD3DXPATCHINFO = ^TD3DXPATCHINFO;
    LPD3DXPATCHINFO = ^TD3DXPATCHINFO;




    ID3DXPatchMesh = interface(IUnknown)
        ['{0AD3E8BC-290D-4DC7-91AB-73A82755B13E}']
        // ID3DXPatchMesh
        // Return creation parameters
        function GetNumPatches(): DWORD; stdcall;

        function GetNumVertices(): DWORD; stdcall;

        function GetDeclaration(Nameless1: LPD3DVERTEXELEMENT9): HRESULT; stdcall;

        function GetControlVerticesPerPatch(): DWORD; stdcall;

        function GetOptions(): DWORD; stdcall;

        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;

        function GetPatchInfo(PatchInfo: LPD3DXPATCHINFO): HRESULT; stdcall;

        // Control mesh access
        function GetVertexBuffer(out ppVB: IDirect3DVertexBuffer9): HRESULT; stdcall;

        function GetIndexBuffer(out ppIB: IDirect3DIndexBuffer9): HRESULT; stdcall;

        function LockVertexBuffer(flags: DWORD; out ppData: pointer): HRESULT; stdcall;

        function UnlockVertexBuffer(): HRESULT; stdcall;

        function LockIndexBuffer(flags: DWORD; out ppData: pointer): HRESULT; stdcall;

        function UnlockIndexBuffer(): HRESULT; stdcall;

        function LockAttributeBuffer(flags: DWORD; out ppData: pointer): HRESULT; stdcall;

        function UnlockAttributeBuffer(): HRESULT; stdcall;

        // This function returns the size of the tessellated mesh given a tessellation level.
        // This assumes uniform tessellation. For adaptive tessellation the Adaptive parameter must
        // be set to TRUE and TessellationLevel should be the max tessellation.
        // This will result in the max mesh size necessary for adaptive tessellation.
        function GetTessSize(fTessLevel: single; Adapative: DWORD; NumTriangles: PDWORD; NumVertices: PDWORD): HRESULT; stdcall;

        //GenerateAdjacency determines which patches are adjacent with provided tolerance
        //this information is used internally to optimize tessellation
        function GenerateAdjacency(Tolerance: single): HRESULT; stdcall;

        //CloneMesh Creates a new patchmesh with the specified decl, and converts the vertex buffer
        //to the new decl. Entries in the new decl which are new are set to 0. If the current mesh
        //has adjacency, the new mesh will also have adjacency
        function CloneMesh(Options: DWORD; pDecl: PD3DVERTEXELEMENT9; pMesh: ID3DXPatchMesh): HRESULT; stdcall;

        // Optimizes the patchmesh for efficient tessellation. This function is designed
        // to perform one time optimization for patch meshes that need to be tessellated
        // repeatedly by calling the Tessellate() method. The optimization performed is
        // independent of the actual tessellation level used.
        // Currently Flags is unused.
        // If vertices are changed, Optimize must be called again
        function Optimize(flags: DWORD): HRESULT; stdcall;

        //gets and sets displacement parameters
        //displacement maps can only be 2D textures MIP-MAPPING is ignored for non adapative tessellation
        function SetDisplaceParam(Texture: IDirect3DBaseTexture9; MinFilter: TD3DTEXTUREFILTERTYPE; MagFilter: TD3DTEXTUREFILTERTYPE; MipFilter: TD3DTEXTUREFILTERTYPE; Wrap: TD3DTEXTUREADDRESS; dwLODBias: DWORD): HRESULT; stdcall;

        function GetDisplaceParam(out Texture: IDirect3DBaseTexture9; MinFilter: PD3DTEXTUREFILTERTYPE; MagFilter: PD3DTEXTUREFILTERTYPE; MipFilter: PD3DTEXTUREFILTERTYPE; Wrap: PD3DTEXTUREADDRESS; dwLODBias: PDWORD): HRESULT; stdcall;

        // Performs the uniform tessellation based on the tessellation level.
        // This function will perform more efficiently if the patch mesh has been optimized using the Optimize() call.
        function Tessellate(fTessLevel: single; pMesh: ID3DXMesh): HRESULT; stdcall;

        // Performs adaptive tessellation based on the Z based adaptive tessellation criterion.
        // pTrans specifies a 4D vector that is dotted with the vertices to get the per vertex
        // adaptive tessellation amount. Each edge is tessellated to the average of the criterion
        // at the 2 vertices it connects.
        // MaxTessLevel specifies the upper limit for adaptive tesselation.
        // This function will perform more efficiently if the patch mesh has been optimized using the Optimize() call.
        function TessellateAdaptive(pTrans: PD3DXVECTOR4; dwMaxTessLevel: DWORD; dwMinTessLevel: DWORD; pMesh: ID3DXMesh): HRESULT; stdcall;

    end;




    ID3DXSkinInfo = interface(IUnknown)
        ['{0E7DBBF3-421A-4DD8-B738-A5DAC3A48767}']
        // Specify the which vertices do each bones influence and by how much
        function SetBoneInfluence(bone: DWORD; numInfluences: DWORD; vertices: PDWORD; weights: Psingle): HRESULT; stdcall;

        function GetNumBoneInfluences(bone: DWORD): DWORD; stdcall;

        function GetBoneInfluence(bone: DWORD; vertices: PDWORD; weights: Psingle): HRESULT; stdcall;

        function GetMaxVertexInfluences(maxVertexInfluences: PDWORD): HRESULT; stdcall;

        function GetNumBones(): DWORD; stdcall;

        // This gets the max face influences based on a triangle mesh with the specified index buffer
        function GetMaxFaceInfluences(pIB: IDirect3DIndexBuffer9; NumFaces: DWORD; maxFaceInfluences: PDWORD): HRESULT; stdcall;

        // Set min bone influence. Bone influences that are smaller than this are ignored
        function SetMinBoneInfluence(MinInfl: single): HRESULT; stdcall;

        // Get min bone influence.
        function GetMinBoneInfluence(): single; stdcall;

        // Bone names are returned by D3DXLoadSkinMeshFromXof. They are not used by any other method of this object
        function SetBoneName(Bone: DWORD; pName: LPCSTR): HRESULT; stdcall;

        // pName is copied to an internal string buffer
        function GetBoneName(Bone: DWORD): LPCSTR; stdcall;

        // A pointer to an internal string buffer is returned. Do not free this.
        // Bone offset matrices are returned by D3DXLoadSkinMeshFromXof. They are not used by any other method of this object
        function SetBoneOffsetMatrix(Bone: DWORD; pBoneTransform: LPD3DXMATRIX): HRESULT; stdcall;

        // pBoneTransform is copied to an internal buffer
        function GetBoneOffsetMatrix(Bone: DWORD): LPD3DXMATRIX; stdcall;

        // A pointer to an internal matrix is returned. Do not free this.
        // Clone a skin info object
        function Clone(ppSkinInfo: LPD3DXSKININFO): HRESULT; stdcall;

        // Update bone influence information to match vertices after they are reordered. This should be called
        // if the target vertex buffer has been reordered externally.
        function Remap(NumVertices: DWORD; pVertexRemap: PDWORD): HRESULT; stdcall;

        // These methods enable the modification of the vertex layout of the vertices that will be skinned
        function SetFVF(FVF: DWORD): HRESULT; stdcall;

        function SetDeclaration(pDeclaration: PD3DVERTEXELEMENT9): HRESULT; stdcall;

        function GetFVF(): DWORD; stdcall;

        function GetDeclaration(Declaration: TMAX_FVFVertexArray // array [0..MAX_FVF_DECL_SIZE-1] of TD3DVERTEXELEMENT9
            ): HRESULT; stdcall;

        // Apply SW skinning based on current pose matrices to the target vertices.
        function UpdateSkinnedMesh(pBoneTransforms: PD3DXMATRIX; pBoneInvTransposeTransforms: PD3DXMATRIX; pVerticesSrc: PVOID; pVerticesDst: PVOID): HRESULT; stdcall;

        // Takes a mesh and returns a new mesh with per vertex blend weights and a bone combination
        // table that describes which bones affect which subsets of the mesh
        function ConvertToBlendedMesh(pMesh: ID3DXMesh; Options: DWORD; pAdjacencyIn: PDWORD; pAdjacencyOut: LPDWORD; pFaceRemap: PDWORD; out ppVertexRemap: ID3DXBuffer; pMaxFaceInfl: PDWORD;
            pNumBoneCombinations: PDWORD; out ppBoneCombinationTable: ID3DXBuffer; out ppMesh: ID3DXMesh): HRESULT; stdcall;

        // Takes a mesh and returns a new mesh with per vertex blend weights and indices
        // and a bone combination table that describes which bones palettes affect which subsets of the mesh
        function ConvertToIndexedBlendedMesh(pMesh: ID3DXMesh; Options: DWORD; paletteSize: DWORD; pAdjacencyIn: PDWORD; pAdjacencyOut: LPDWORD; pFaceRemap: PDWORD; out ppVertexRemap: ID3DXBuffer;
            pMaxVertexInfl: PDWORD; pNumBoneCombinations: PDWORD; out ppBoneCombinationTable: ID3DXBuffer; out ppMesh: ID3DXMesh): HRESULT; stdcall;
    end;

    _D3DXINTERSECTINFO = record
        FaceIndex: DWORD; // index of face intersected
        U: single; // Barycentric Hit Coordinates
        V: single; // Barycentric Hit Coordinates
        Dist: single; // Ray-Intersection Parameter Distance
    end;
    TD3DXINTERSECTINFO = _D3DXINTERSECTINFO;
    PD3DXINTERSECTINFO = ^TD3DXINTERSECTINFO;
    LPD3DXINTERSECTINFO = ^TD3DXINTERSECTINFO;



function D3DXCreateMesh(NumFaces: DWORD; NumVertices: DWORD; Options: DWORD; pDeclaration: PD3DVERTEXELEMENT9; pD3D: IDirect3DDevice9; out ppMesh: ID3DXMesh): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateMeshFVF(NumFaces: DWORD; NumVertices: DWORD; Options: DWORD; FVF: DWORD; pD3D: IDirect3DDevice9; out ppMesh: ID3DXMesh): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateSPMesh(pMesh: ID3DXMesh; pAdjacency: PDWORD; pVertexAttributeWeights: PD3DXATTRIBUTEWEIGHTS; pVertexWeights: Psingle; out ppSMesh: ID3DXSPMesh): HRESULT; stdcall; external D3DX9_DLL;


// clean a mesh up for simplification, try to make manifold
function D3DXCleanMesh(pMeshIn: ID3DXMesh; pAdjacencyIn: PDWORD; out ppMeshOut: ID3DXMesh; pAdjacencyOut: PDWORD; out ppErrorsAndWarnings: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;


function D3DXValidMesh(pMeshIn: ID3DXMesh; pAdjacency: PDWORD; out ppErrorsAndWarnings: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;


function D3DXGeneratePMesh(pMesh: ID3DXMesh; pAdjacency: PDWORD; pVertexAttributeWeights: PD3DXATTRIBUTEWEIGHTS; pVertexWeights: Psingle; MinValue: DWORD; Options: DWORD; out ppPMesh: ID3DXPMesh): HRESULT; stdcall; external D3DX9_DLL;


function D3DXSimplifyMesh(pMesh: ID3DXMesh; pAdjacency: PDWORD; pVertexAttributeWeights: PD3DXATTRIBUTEWEIGHTS; pVertexWeights: Psingle; MinValue: DWORD; Options: DWORD; out ppMesh: ID3DXMesh): HRESULT; stdcall; external D3DX9_DLL;


function D3DXComputeBoundingSphere(
    // pointer to first position
    pFirstPosition: LPD3DXVECTOR3; NumVertices: DWORD;
    // count in bytes to subsequent position vectors
    dwStride: DWORD; pCenter: PD3DXVECTOR3; pRadius: Psingle): HRESULT; stdcall; external D3DX9_DLL;


function D3DXComputeBoundingBox(
    // pointer to first position
    pFirstPosition: LPD3DXVECTOR3; NumVertices: DWORD;
    // count in bytes to subsequent position vectors
    dwStride: DWORD; pMin: PD3DXVECTOR3; pMax: PD3DXVECTOR3): HRESULT; stdcall; external D3DX9_DLL;


function D3DXComputeNormals(pMesh: ID3DXBaseMesh; pAdjacency: PDWORD): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateBuffer(NumBytes: DWORD; out ppBuffer: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;



function D3DXLoadMeshFromXA(pFilename: LPCSTR; Options: DWORD; pD3D: IDirect3DDevice9; out ppAdjacency: ID3DXBuffer; out ppMaterials: ID3DXBuffer; out ppEffectInstances: ID3DXBuffer;
    pNumMaterials: PDWORD; ppMesh: ID3DXMesh): HRESULT; stdcall; external D3DX9_DLL;


function D3DXLoadMeshFromXW(pFilename: LPCWSTR; Options: DWORD; pD3D: IDirect3DDevice9; out ppAdjacency: ID3DXBuffer; out ppMaterials: ID3DXBuffer; out ppEffectInstances: ID3DXBuffer;
    pNumMaterials: PDWORD; ppMesh: ID3DXMesh): HRESULT; stdcall; external D3DX9_DLL;



function D3DXLoadMeshFromXInMemory(Memory: LPCVOID; SizeOfMemory: DWORD; Options: DWORD; pD3D: IDirect3DDevice9; out ppAdjacency: ID3DXBuffer; out ppMaterials: ID3DXBuffer;
    out ppEffectInstances: ID3DXBuffer; pNumMaterials: PDWORD; out ppMesh: ID3DXMesh): HRESULT; stdcall; external D3DX9_DLL;


function D3DXLoadMeshFromXResource(Module: HMODULE; Name: LPCSTR; _Type: LPCSTR; Options: DWORD; pD3D: IDirect3DDevice9; out ppAdjacency: ID3DXBuffer; out ppMaterials: ID3DXBuffer;
    out ppEffectInstances: ID3DXBuffer; pNumMaterials: PDWORD; out ppMesh: ID3DXMesh): HRESULT; stdcall; external D3DX9_DLL;


function D3DXSaveMeshToXA(pFilename: LPCSTR; pMesh: ID3DXMesh; pAdjacency: PDWORD; pMaterials: PD3DXMATERIAL; pEffectInstances: PD3DXEFFECTINSTANCE; NumMaterials: DWORD; Format: DWORD): HRESULT; stdcall; external D3DX9_DLL;


function D3DXSaveMeshToXW(pFilename: LPCWSTR; pMesh: ID3DXMesh; pAdjacency: PDWORD; pMaterials: PD3DXMATERIAL; pEffectInstances: PD3DXEFFECTINSTANCE; NumMaterials: DWORD; Format: DWORD): HRESULT; stdcall; external D3DX9_DLL;



function D3DXCreatePMeshFromStream(pStream: IStream; Options: DWORD; pD3DDevice: IDirect3DDevice9; out ppMaterials: ID3DXBuffer; out ppEffectInstances: ID3DXBuffer; pNumMaterials: PDWORD;
    out ppPMesh: ID3DXPMesh): HRESULT; stdcall; external D3DX9_DLL;


// Creates a skin info object based on the number of vertices, number of bones, and a declaration describing the vertex layout of the target vertices
// The bone names and initial bone transforms are not filled in the skin info object by this method.
function D3DXCreateSkinInfo(NumVertices: DWORD; pDeclaration: PD3DVERTEXELEMENT9; NumBones: DWORD; out ppSkinInfo: ID3DXSkinInfo): HRESULT; stdcall; external D3DX9_DLL;


// Creates a skin info object based on the number of vertices, number of bones, and a FVF describing the vertex layout of the target vertices
// The bone names and initial bone transforms are not filled in the skin info object by this method.
function D3DXCreateSkinInfoFVF(NumVertices: DWORD; FVF: DWORD; NumBones: DWORD; out ppSkinInfo: ID3DXSkinInfo): HRESULT; stdcall; external D3DX9_DLL;




function D3DXLoadMeshFromXof(pXofObjMesh: IDirectXFileData; Options: DWORD; pD3DDevice: IDirect3DDevice9; out ppAdjacency: ID3DXBuffer; out ppMaterials: ID3DXBuffer; out ppEffectInstances: ID3DXBuffer;
    pNumMaterials: PDWORD; out ppMesh: ID3DXMesh): HRESULT; stdcall; external D3DX9_DLL;


// This similar to D3DXLoadMeshFromXof, except also returns skinning info if present in the file
// If skinning info is not present, ppSkinInfo will be NULL
function D3DXLoadSkinMeshFromXof(pxofobjMesh: IDirectXFileData; Options: DWORD; pD3D: IDirect3DDevice9; out ppAdjacency: ID3DXBuffer; out ppMaterials: ID3DXBuffer; out ppEffectInstances: ID3DXBuffer;
    pMatOut: PDWORD; out ppSkinInfo: ID3DXSkinInfo; out ppMesh: ID3DXMesh): HRESULT; stdcall; external D3DX9_DLL;


// The inverse of D3DXConvertTo{Indexed}BlendedMesh() functions. It figures out the skinning info from
// the mesh and the bone combination table and populates a skin info object with that data. The bone
// names and initial bone transforms are not filled in the skin info object by this method. This works
// with either a non-indexed or indexed blended mesh. It examines the FVF or declarator of the mesh to
// determine what type it is.
function D3DXCreateSkinInfoFromBlendedMesh(pMesh: ID3DXBaseMesh; NumBoneCombinations: DWORD; pBoneCombinationTable: LPD3DXBONECOMBINATION; out ppSkinInfo: ID3DXSkinInfo): HRESULT; stdcall; external D3DX9_DLL;


function D3DXTessellateNPatches(pMeshIn: ID3DXMesh; pAdjacencyIn: PDWORD; NumSegs: single;
    // if false use linear intrep for normals, if true use quadratic
    QuadraticInterpNormals: boolean; out ppMeshOut: ID3DXMesh; out ppAdjacencyOut: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;



//generates implied outputdecl from input decl
//the decl generated from this should be used to generate the output decl for
//the tessellator subroutines.

function D3DXGenerateOutputDecl(pOutput: PD3DVERTEXELEMENT9; pInput: PD3DVERTEXELEMENT9): HRESULT; stdcall; external D3DX9_DLL;


//loads patches from an XFileData
//since an X file can have up to 6 different patch meshes in it,
//returns them in an array - pNumPatches will contain the number of
//meshes in the actual file.
function D3DXLoadPatchMeshFromXof(pXofObjMesh: IDirectXFileData; Options: DWORD; pDevice: IDirect3DDevice9; out ppMaterials: ID3DXBuffer; out ppEffectInstances: ID3DXBuffer; pNumMaterials: PDWORD;
    out ppMesh: ID3DXPatchMesh): HRESULT; stdcall; external D3DX9_DLL;


//computes the size a single rect patch.
function D3DXRectPatchSize(
    //segments for each edge (4)
    pfNumSegs: Psingle;
    //output number of triangles
    pdwTriangles: PDWORD; pdwVertices: PDWORD): HRESULT; stdcall; external D3DX9_DLL;


//computes the size of a single triangle patch
function D3DXTriPatchSize(
    //segments for each edge (3)
    pfNumSegs: Psingle;
    //output number of triangles
    pdwTriangles: PDWORD; pdwVertices: PDWORD): HRESULT; stdcall; external D3DX9_DLL;



//tessellates a patch into a created mesh
//similar to D3D RT patch
function D3DXTessellateRectPatch(pVB: IDirect3DVertexBuffer9; pNumSegs: Psingle; pdwInDecl: PD3DVERTEXELEMENT9; pRectPatchInfo: PD3DRECTPATCH_INFO; pMesh: ID3DXMesh): HRESULT; stdcall; external D3DX9_DLL;



function D3DXTessellateTriPatch(pVB: IDirect3DVertexBuffer9; pNumSegs: Psingle; pInDecl: PD3DVERTEXELEMENT9; pTriPatchInfo: PD3DTRIPATCH_INFO; pMesh: ID3DXMesh): HRESULT; stdcall; external D3DX9_DLL;




//creates an NPatch PatchMesh from a D3DXMESH
function D3DXCreateNPatchMesh(pMeshSysMem: ID3DXMesh; out pPatchMesh: ID3DXPatchMesh): HRESULT; stdcall; external D3DX9_DLL;



//creates a patch mesh
function D3DXCreatePatchMesh(
    //patch type
    pInfo: LPD3DXPATCHINFO;
    //number of patches
    dwNumPatches: DWORD;
    //number of control vertices
    dwNumVertices: DWORD;
    //options
    dwOptions: DWORD;
    //format of control vertices
    pDecl: PD3DVERTEXELEMENT9; pDevice: IDirect3DDevice9; out pPatchMesh: ID3DXPatchMesh): HRESULT; stdcall; external D3DX9_DLL;



//returns the number of degenerates in a patch mesh -
//text output put in string.
function D3DXValidPatchMesh(pMesh: ID3DXPatchMesh; dwcDegenerateVertices: PDWORD; dwcDegeneratePatches: PDWORD; out ppErrorsAndWarnings: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;


function D3DXGetFVFVertexSize(FVF: DWORD): UINT; stdcall; external D3DX9_DLL;


function D3DXGetDeclVertexSize({in} pDecl: PD3DVERTEXELEMENT9;{in} Stream: DWORD): UINT; stdcall; external D3DX9_DLL;


function D3DXGetDeclLength(pDecl: PD3DVERTEXELEMENT9): UINT; stdcall; external D3DX9_DLL;


function D3DXDeclaratorFromFVF(FVF: DWORD; pDeclarator: TMAX_FVFVertexArray // array [0..MAX_FVF_DECL_SIZE-1] of TD3DVERTEXELEMENT9
    ): HRESULT; stdcall; external D3DX9_DLL;


function D3DXFVFFromDeclarator(pDeclarator: PD3DVERTEXELEMENT9; pFVF: PDWORD): HRESULT; stdcall; external D3DX9_DLL;


function D3DXWeldVertices(pMesh: ID3DXMesh; Flags: DWORD; pEpsilons: PD3DXWELDEPSILONS; pAdjacencyIn: PDWORD; pAdjacencyOut: PDWORD; pFaceRemap: PDWORD; out ppVertexRemap: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;




function D3DXIntersect(pMesh: ID3DXBaseMesh; pRayPos: PD3DXVECTOR3; pRayDir: PD3DXVECTOR3;
    // True if any faces were intersected
    pHit: Pboolean;
    // index of closest face intersected
    pFaceIndex: PDWORD;
    // Barycentric Hit Coordinates
    pU: Psingle;
    // Barycentric Hit Coordinates
    pV: Psingle;
    // Ray-Intersection Parameter Distance
    pDist: Psingle;
    // Array of D3DXINTERSECTINFOs for all hits (not just closest)
    out ppAllHits: ID3DXBuffer; pCountOfHits: PDWORD): HRESULT; stdcall; external D3DX9_DLL;


function D3DXIntersectSubset(pMesh: ID3DXBaseMesh; AttribId: DWORD; pRayPos: PD3DXVECTOR3; pRayDir: PD3DXVECTOR3;
    // True if any faces were intersected
    pHit: Pboolean;
    // index of closest face intersected
    pFaceIndex: PDWORD;
    // Barycentric Hit Coordinates
    pU: Psingle;
    // Barycentric Hit Coordinates
    pV: Psingle;
    // Ray-Intersection Parameter Distance
    pDist: Psingle;
    // Array of D3DXINTERSECTINFOs for all hits (not just closest)
    out ppAllHits: ID3DXBuffer; pCountOfHits: PDWORD): HRESULT; stdcall; external D3DX9_DLL;



function D3DXSplitMesh(pMeshIn: ID3DXMesh; pAdjacencyIn: PDWORD; MaxSize: DWORD; Options: DWORD; pMeshesOut: PDWORD; out ppMeshArrayOut: ID3DXBuffer; out ppAdjacencyArrayOut: ID3DXBuffer;
    out ppFaceRemapArrayOut: ID3DXBuffer; out ppVertRemapArrayOut: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;


function D3DXIntersectTri(
    // Triangle vertex 0 position
    p0: PD3DXVECTOR3;
    // Triangle vertex 1 position
    p1: PD3DXVECTOR3;
    // Triangle vertex 2 position
    p2: PD3DXVECTOR3;
    // Ray origin
    pRayPos: PD3DXVECTOR3;
    // Ray direction
    pRayDir: PD3DXVECTOR3;
    // Barycentric Hit Coordinates
    pU: Psingle;
    // Barycentric Hit Coordinates
    pV: Psingle; pDist: Psingle): longbool; stdcall; external D3DX9_DLL;


function D3DXSphereBoundProbe(pCenter: PD3DXVECTOR3; Radius: single; pRayPosition: PD3DXVECTOR3; pRayDirection: PD3DXVECTOR3): longbool; stdcall; external D3DX9_DLL;


function D3DXBoxBoundProbe(pMin: PD3DXVECTOR3; pMax: PD3DXVECTOR3; pRayPosition: PD3DXVECTOR3; pRayDirection: PD3DXVECTOR3): longbool; stdcall; external D3DX9_DLL;




//D3DXComputeTangent

//Computes the Tangent vectors for the TexStage texture coordinates
//and places the results in the TANGENT[TangentIndex] specified in the meshes' DECL
//puts the binorm in BINORM[BinormIndex] also specified in the decl.

//If neither the binorm or the tangnet are in the meshes declaration,
//the function will fail.

//If a tangent or Binorm field is in the Decl, but the user does not
//wish D3DXComputeTangent to replace them, then D3DX_DEFAULT specified
//in the TangentIndex or BinormIndex will cause it to ignore the specified
//semantic.

//Wrap should be specified if the texture coordinates wrap.

function D3DXComputeTangent(Mesh: ID3DXMesh; TexStage: DWORD; TangentIndex: DWORD; BinormIndex: DWORD; Wrap: DWORD; Adjacency: PDWORD): HRESULT; stdcall; external D3DX9_DLL;


function D3DXConvertMeshSubsetToSingleStrip(MeshIn: ID3DXBaseMesh; AttribId: DWORD; IBOptions: DWORD; out ppIndexBuffer: IDirect3DIndexBuffer9; pNumIndices: PDWORD): HRESULT; stdcall; external D3DX9_DLL;



function D3DXConvertMeshSubsetToStrips(MeshIn: ID3DXBaseMesh; AttribId: DWORD; IBOptions: DWORD; out ppIndexBuffer: IDIRECT3DINDEXBUFFER9; pNumIndices: PDWORD; out ppStripLengths: ID3DXBuffer;
    pNumStrips: PDWORD): HRESULT; stdcall; external D3DX9_DLL;




implementation

end.
