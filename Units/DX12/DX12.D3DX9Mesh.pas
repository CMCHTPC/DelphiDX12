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

   Copyright (C) Microsoft Corporation.
   Licensed under the MIT license

   This unit consists of the following header files
   File name:
   Header version: 9.29.1962.1

  ************************************************************************** }

unit DX12.D3DX9Mesh;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    Win32.ObjIdl,
    DX12.D3D9,
    DX12.D3D9Types,
    DX12.D3DX9Core,
    DX12.D3DX9Math,
    DX12.D3DX9xof;

    {$Z4}

    // for different SDK versions
    {$I DX12.DX9SDKVersion.inc}

const

    // {7ED943DD-52E8-40b5-A8D8-76685C406330}
    IID_ID3DXBaseMesh: TGUID = '{7ED943DD-52E8-40B5-A8D8-76685C406330}';


    // {4020E5C2-1403-4929-883F-E2E849FAC195}
    IID_ID3DXMesh: TGUID = '{4020E5C2-1403-4929-883F-E2E849FAC195}';


    // {8875769A-D579-4088-AAEB-534D1AD84E96}
    IID_ID3DXPMesh: TGUID = '{8875769A-D579-4088-AAEB-534D1AD84E96}';


    // {667EA4C7-F1CD-4386-B523-7C0290B83CC5}
    IID_ID3DXSPMesh: TGUID = '{667EA4C7-F1CD-4386-B523-7C0290B83CC5}';


    // {11EAA540-F9A6-4d49-AE6A-E19221F70CC4}
    IID_ID3DXSkinInfo: TGUID = '{11EAA540-F9A6-4D49-AE6A-E19221F70CC4}';


    // {3CE6CC22-DBF2-44f4-894D-F9C34A337139}
    IID_ID3DXPatchMesh: TGUID = '{3CE6CC22-DBF2-44F4-894D-F9C34A337139}';

    UNUSED16 = ($ffff);
    UNUSED32 = ($ffffffff);

    // interfaces for PRT buffers/simulator
    // GUIDs
    // {F1827E47-00A8-49cd-908C-9D11955F8728}

    IID_ID3DXPRTBuffer: TGUID = '{F1827E47-00A8-49CD-908C-9D11955F8728}';


    // {A758D465-FE8D-45ad-9CF0-D01E56266A07}
    IID_ID3DXPRTCompBuffer: TGUID = '{A758D465-FE8D-45AD-9CF0-D01E56266A07}';


    // {838F01EC-9729-4527-AADB-DF70ADE7FEA9}
    IID_ID3DXTextureGutterHelper: TGUID = '{838F01EC-9729-4527-AADB-DF70ADE7FEA9}';


    // {683A4278-CD5F-4d24-90AD-C4E1B6855D53}
    IID_ID3DXPRTEngine: TGUID = '{683A4278-CD5F-4D24-90AD-C4E1B6855D53}';



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


    // {7F9B00B3-F125-4890-876E-1CFFBF697C4D}
    DXFILEOBJ_CompressedAnimationSet: TGUID = '{7F9B00B3-F125-4890-876E-1C42BF697C4D}';


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
        D3DXMESH_USEHWONLY = $2000, // Valid for ID3DXSkinInfo::ConvertToBlendedMesh
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


    _D3DXCLEANTYPE = (
        D3DXCLEAN_BACKFACING = $00000001,
        D3DXCLEAN_BOWTIES = $00000002,
        // Helper options
        D3DXCLEAN_SKINNING = D3DXCLEAN_BACKFACING, // Bowtie cleaning modifies geometry and breaks skinning
        D3DXCLEAN_OPTIMIZATION = D3DXCLEAN_BACKFACING,
        D3DXCLEAN_SIMPLIFICATION = Ord(D3DXCLEAN_BACKFACING) or Ord(D3DXCLEAN_BOWTIES));

    TD3DXCLEANTYPE = _D3DXCLEANTYPE;
    PD3DXCLEANTYPE = ^TD3DXCLEANTYPE;


    _MAX_FVF_DECL_SIZE = (
        MAX_FVF_DECL_SIZE = Ord(MAXD3DDECLLENGTH) + 1// +1 for END
        );

    TMAX_FVF_DECL_SIZE = _MAX_FVF_DECL_SIZE;
    PMAX_FVF_DECL_SIZE = ^TMAX_FVF_DECL_SIZE;


    _D3DXTANGENT = (
        D3DXTANGENT_WRAP_U = $01,
        D3DXTANGENT_WRAP_V = $02,
        D3DXTANGENT_WRAP_UV = $03,
        D3DXTANGENT_DONT_NORMALIZE_PARTIALS = $04,
        D3DXTANGENT_DONT_ORTHOGONALIZE = $08,
        D3DXTANGENT_ORTHOGONALIZE_FROM_V = $010,
        D3DXTANGENT_ORTHOGONALIZE_FROM_U = $020,
        D3DXTANGENT_WEIGHT_BY_AREA = $040,
        D3DXTANGENT_WEIGHT_EQUAL = $080,
        D3DXTANGENT_WIND_CW = $0100,
        D3DXTANGENT_CALCULATE_NORMALS = $0200,
        D3DXTANGENT_GENERATE_IN_PLACE = $0400);

    TD3DXTANGENT = _D3DXTANGENT;
    PD3DXTANGENT = ^TD3DXTANGENT;

    // D3DXIMT_WRAP_U means the texture wraps in the U direction
    // D3DXIMT_WRAP_V means the texture wraps in the V direction
    // D3DXIMT_WRAP_UV means the texture wraps in both directions
    _D3DXIMT = (
        D3DXIMT_WRAP_U = $01,
        D3DXIMT_WRAP_V = $02,
        D3DXIMT_WRAP_UV = $03);

    TD3DXIMT = _D3DXIMT;
    PD3DXIMT = ^TD3DXIMT;


    // These options are only valid for UVAtlasCreate and UVAtlasPartition, we may add more for UVAtlasPack if necessary
    // D3DXUVATLAS_DEFAULT - Meshes with more than 25k faces go through fast, meshes with fewer than 25k faces go through quality
    // D3DXUVATLAS_GEODESIC_FAST - Uses approximations to improve charting speed at the cost of added stretch or more charts.
    // D3DXUVATLAS_GEODESIC_QUALITY - Provides better quality charts, but requires more time and memory than fast.
    _D3DXUVATLAS = (
        D3DXUVATLAS_DEFAULT = $00,
        D3DXUVATLAS_GEODESIC_FAST = $01,
        D3DXUVATLAS_GEODESIC_QUALITY = $02);

    TD3DXUVATLAS = _D3DXUVATLAS;
    PD3DXUVATLAS = ^TD3DXUVATLAS;



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
        ['{7ED943DD-52E8-40B5-A8D8-76685C406330}']
        // ID3DXBaseMesh
        function DrawSubset(AttribId: DWORD): HRESULT; stdcall;

        function GetNumFaces(): DWORD; stdcall;

        function GetNumVertices(): DWORD; stdcall;

        function GetFVF(): DWORD; stdcall;

        function GetDeclaration(Declaration: TMAX_FVFVertexArray): HRESULT; stdcall;

        function GetNumBytesPerVertex(): DWORD; stdcall;

        function GetOptions(): DWORD; stdcall;

        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;

        function CloneMeshFVF(Options: DWORD; FVF: DWORD; pD3DDevice: IDirect3DDevice9; out ppCloneMesh: ID3DXMesh): HRESULT; stdcall;

        function CloneMesh(Options: DWORD; pDeclaration: PD3DVERTEXELEMENT9; pD3DDevice: IDirect3DDevice9; out ppCloneMesh: ID3DXMesh): HRESULT; stdcall;

        function GetVertexBuffer(out ppVB: IDirect3DVertexBuffer9): HRESULT; stdcall;

        function GetIndexBuffer(out ppIB: IDirect3DIndexBuffer9): HRESULT; stdcall;

        function LockVertexBuffer(Flags: DWORD; out ppData: LPVOID): HRESULT; stdcall;

        function UnlockVertexBuffer(): HRESULT; stdcall;

        function LockIndexBuffer(Flags: DWORD; out ppData: LPVOID): HRESULT; stdcall;

        function UnlockIndexBuffer(): HRESULT; stdcall;

        function GetAttributeTable(pAttribTable: PD3DXATTRIBUTERANGE; pAttribTableSize: PDWORD): HRESULT; stdcall;

        function ConvertPointRepsToAdjacency(pPRep: PDWORD; pAdjacency: PDWORD): HRESULT; stdcall;

        function ConvertAdjacencyToPointReps(pAdjacency: PDWORD; pPRep: PDWORD): HRESULT; stdcall;

        function GenerateAdjacency(Epsilon: single; pAdjacency: PDWORD): HRESULT; stdcall;

        function UpdateSemantics(Declaration: TMAX_FVFVertexArray): HRESULT; stdcall;

    end;




    ID3DXMesh = interface(ID3DXBaseMesh)
        ['{4020E5C2-1403-4929-883F-E2E849FAC195}']
        // ID3DXMesh
        function LockAttributeBuffer(Flags: DWORD; out ppData: pointer): HRESULT; stdcall;

        function UnlockAttributeBuffer(): HRESULT; stdcall;

        function Optimize(Flags: DWORD; pAdjacencyIn: PDWORD; pAdjacencyOut: PDWORD; pFaceRemap: PDWORD; out ppVertexRemap: ID3DXBuffer; out ppOptMesh: ID3DXMesh): HRESULT; stdcall;

        function OptimizeInplace(Flags: DWORD; pAdjacencyIn: PDWORD; pAdjacencyOut: PDWORD; pFaceRemap: PDWORD; out ppVertexRemap: ID3DXBuffer): HRESULT; stdcall;

        function SetAttributeTable(pAttribTable: PD3DXATTRIBUTERANGE; cAttribTableSize: DWORD): HRESULT; stdcall;

    end;



    ID3DXPMesh = interface(ID3DXBaseMesh)
        ['{8875769A-D579-4088-AAEB-534D1AD84E96}']
        // ID3DXPMesh
        function ClonePMeshFVF(Options: DWORD; FVF: DWORD; pD3DDevice: IDirect3DDevice9; out ppCloneMesh: ID3DXPMesh): HRESULT; stdcall;

        function ClonePMesh(Options: DWORD; pDeclaration: PD3DVERTEXELEMENT9; pD3DDevice: IDirect3DDevice9; out ppCloneMesh: ID3DXPMesh): HRESULT; stdcall;

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
        ['{667EA4C7-F1CD-4386-B523-7C0290B83CC5}']
        // ID3DXSPMesh
        function GetNumFaces(): DWORD; stdcall;

        function GetNumVertices(): DWORD; stdcall;

        function GetFVF(): DWORD; stdcall;

        function GetDeclaration(Declaration: TMAX_FVFVertexArray): HRESULT; stdcall;

        function GetOptions(): DWORD; stdcall;

        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;

        function CloneMeshFVF(Options: DWORD; FVF: DWORD; pD3DDevice: IDirect3DDevice9; pAdjacencyOut: PDWORD; pVertexRemapOut: PDWORD; out ppCloneMesh: ID3DXMesh): HRESULT; stdcall;

        function CloneMesh(Options: DWORD; pDeclaration: PD3DVERTEXELEMENT9; pD3DDevice: IDirect3DDevice9; pAdjacencyOut: PDWORD; pVertexRemapOut: PDWORD; out ppCloneMesh: ID3DXMesh): HRESULT; stdcall;

        function ClonePMeshFVF(Options: DWORD; FVF: DWORD; pD3DDevice: IDirect3DDevice9; pVertexRemapOut: PDWORD; pErrorsByFace: Psingle; out ppCloneMesh: ID3DXPMesh): HRESULT; stdcall;

        function ClonePMesh(Options: DWORD; pDeclaration: PD3DVERTEXELEMENT9; pD3DDevice: IDirect3DDevice9; pVertexRemapOut: PDWORD; pErrorsbyFace: Psingle; out ppCloneMesh: ID3DXPMesh): HRESULT; stdcall;

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
        ['{3CE6CC22-DBF2-44F4-894D-F9C34A337139}']
        // ID3DXPatchMesh
        // Return creation parameters
        function GetNumPatches(): DWORD; stdcall;

        function GetNumVertices(): DWORD; stdcall;

        function GetDeclaration(Declaration: TMAX_FVFVertexArray): HRESULT; stdcall;

        function GetControlVerticesPerPatch(): DWORD; stdcall;

        function GetOptions(): DWORD; stdcall;

        function GetDevice(out ppDevice: IDirect3DDevice9): HRESULT; stdcall;

        function GetPatchInfo(PatchInfo: LPD3DXPATCHINFO): HRESULT; stdcall;

        // Control mesh access
        function GetVertexBuffer(out ppVB: IDirect3DVertexBuffer9): HRESULT; stdcall;

        function GetIndexBuffer(out ppIB: IDirect3DIndexBuffer9): HRESULT; stdcall;

        function LockVertexBuffer(flags: DWORD; out ppData: LPVOID): HRESULT; stdcall;

        function UnlockVertexBuffer(): HRESULT; stdcall;

        function LockIndexBuffer(flags: DWORD; out ppData: LPVOID): HRESULT; stdcall;

        function UnlockIndexBuffer(): HRESULT; stdcall;

        function LockAttributeBuffer(flags: DWORD; out ppData: pointer): HRESULT; stdcall;

        function UnlockAttributeBuffer(): HRESULT; stdcall;

        // This function returns the size of the tessellated mesh given a tessellation level.
        // This assumes uniform tessellation. For adaptive tessellation the Adaptive parameter must
        // be set to TRUE and TessellationLevel should be the max tessellation.
        // This will result in the max mesh size necessary for adaptive tessellation.
        function GetTessSize(fTessLevel: single; Adaptive: DWORD; NumTriangles: PDWORD; NumVertices: PDWORD): HRESULT; stdcall;

        //GenerateAdjacency determines which patches are adjacent with provided tolerance
        //this information is used internally to optimize tessellation
        function GenerateAdjacency(Tolerance: single): HRESULT; stdcall;

        //CloneMesh Creates a new patchmesh with the specified decl, and converts the vertex buffer
        //to the new decl. Entries in the new decl which are new are set to 0. If the current mesh
        //has adjacency, the new mesh will also have adjacency
        function CloneMesh(Options: DWORD; pDecl: PD3DVERTEXELEMENT9; out pMesh: ID3DXPatchMesh): HRESULT; stdcall;

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

        function GetDisplaceParam(Texture: IDIRECT3DBASETEXTURE9; MinFilter: PD3DTEXTUREFILTERTYPE; MagFilter: PD3DTEXTUREFILTERTYPE; MipFilter: PD3DTEXTUREFILTERTYPE; Wrap: PD3DTEXTUREADDRESS; dwLODBias: PDWORD): HRESULT; stdcall;

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
        ['{11EAA540-F9A6-4D49-AE6A-E19221F70CC4}']
        // Specify the which vertices do each bones influence and by how much
        function SetBoneInfluence(bone: DWORD; numInfluences: DWORD; vertices: PDWORD; weights: Psingle): HRESULT; stdcall;

        function SetBoneVertexInfluence(boneNum: DWORD; influenceNum: DWORD; weight: single): HRESULT; stdcall;

        function GetNumBoneInfluences(bone: DWORD): DWORD; stdcall;

        function GetBoneInfluence(bone: DWORD; vertices: PDWORD; weights: Psingle): HRESULT; stdcall;

        function GetBoneVertexInfluence(boneNum: DWORD; influenceNum: DWORD; pWeight: Psingle; pVertexNum: PDWORD): HRESULT; stdcall;

        function GetMaxVertexInfluences(maxVertexInfluences: PDWORD): HRESULT; stdcall;

        function GetNumBones(): DWORD; stdcall;

        function FindBoneVertexInfluenceIndex(boneNum: DWORD; vertexNum: DWORD; pInfluenceIndex: PDWORD): HRESULT; stdcall;

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
        function SetBoneOffsetMatrix(Bone: DWORD; pBoneTransform: PD3DXMATRIX): HRESULT; stdcall;

        // pBoneTransform is copied to an internal buffer
        function GetBoneOffsetMatrix(Bone: DWORD): LPD3DXMATRIX; stdcall;

        // A pointer to an internal matrix is returned. Do not free this.
        // Clone a skin info object
        function Clone(out ppSkinInfo: ID3DXSkinInfo): HRESULT; stdcall;

        // Update bone influence information to match vertices after they are reordered. This should be called
        // if the target vertex buffer has been reordered externally.
        function Remap(NumVertices: DWORD; pVertexRemap: PDWORD): HRESULT; stdcall;

        // These methods enable the modification of the vertex layout of the vertices that will be skinned
        function SetFVF(FVF: DWORD): HRESULT; stdcall;

        function SetDeclaration(pDeclaration: PD3DVERTEXELEMENT9): HRESULT; stdcall;

        function GetFVF(): DWORD; stdcall;

        function GetDeclaration(Declaration: TMAX_FVFVertexArray): HRESULT; stdcall;

        // Apply SW skinning based on current pose matrices to the target vertices.
        function UpdateSkinnedMesh(pBoneTransforms: PD3DXMATRIX; pBoneInvTransposeTransforms: PD3DXMATRIX; pVerticesSrc: LPCVOID; pVerticesDst: PVOID): HRESULT; stdcall;

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

    //============================================================================

    // UVAtlas apis

    //============================================================================
    LPD3DXUVATLASCB = function(fPercentDone: single; lpUserContext: LPVOID): HRESULT; stdcall;

    // This callback is used by D3DXComputeIMTFromSignal.

    // uv               - The texture coordinate for the vertex.
    // uPrimitiveID     - Face ID of the triangle on which to compute the signal.
    // uSignalDimension - The number of floats to store in pfSignalOut.
    // pUserData        - The pUserData pointer passed in to ComputeIMTFromSignal.
    // pfSignalOut      - A pointer to where to store the signal data.
    LPD3DXIMTSIGNALCALLBACK = function(uv: PD3DXVECTOR2; uPrimitiveID: UINT; uSignalDimension: UINT; pUserData: PVOID; pfSignalOut: Psingle): HRESULT; stdcall;


    //===========================================================================

    //  Data structures for Spherical Harmonic Precomputation


    //============================================================================

    _D3DXSHCOMPRESSQUALITYTYPE = (
        D3DXSHCQUAL_FASTLOWQUALITY = 1,
        D3DXSHCQUAL_SLOWHIGHQUALITY = 2,
        D3DXSHCQUAL_FORCE_DWORD = $7fffffff);

    TD3DXSHCOMPRESSQUALITYTYPE = _D3DXSHCOMPRESSQUALITYTYPE;
    PD3DXSHCOMPRESSQUALITYTYPE = ^TD3DXSHCOMPRESSQUALITYTYPE;

    _D3DXSHGPUSIMOPT = (
        D3DXSHGPUSIMOPT_SHADOWRES256 = 1,
        D3DXSHGPUSIMOPT_SHADOWRES512 = 0,
        D3DXSHGPUSIMOPT_SHADOWRES1024 = 2,
        D3DXSHGPUSIMOPT_SHADOWRES2048 = 3,
        D3DXSHGPUSIMOPT_HIGHQUALITY = 4,
        D3DXSHGPUSIMOPT_FORCE_DWORD = $7fffffff);

    TD3DXSHGPUSIMOPT = _D3DXSHGPUSIMOPT;
    PD3DXSHGPUSIMOPT = ^TD3DXSHGPUSIMOPT;


    // for all properties that are colors the luminance is computed
    // if the simulator is run with a single channel using the following
    // formula:  R * 0.2125 + G * 0.7154 + B * 0.0721

    _D3DXSHMATERIAL = record
        Diffuse: TD3DCOLORVALUE; // Diffuse albedo of the surface.  (Ignored if object is a Mirror)
        bMirror: boolean; // Must be set to FALSE.  bMirror == TRUE not currently supported
        bSubSurf: boolean; // true if the object does subsurface scattering - can't do this and be a mirror
        // subsurface scattering parameters
        RelativeIndexOfRefraction: single;
        Absorption: TD3DCOLORVALUE;
        ReducedScattering: TD3DCOLORVALUE;
    end;
    TD3DXSHMATERIAL = _D3DXSHMATERIAL;
    PD3DXSHMATERIAL = ^TD3DXSHMATERIAL;


    // allocated in D3DXSHPRTCompSplitMeshSC
    // vertices are duplicated into multiple super clusters but
    // only have a valid status in one super cluster (fill in the rest)

    _D3DXSHPRTSPLITMESHVERTDATA = record
        uVertRemap: UINT; // vertex in original mesh this corresponds to
        uSubCluster: UINT; // cluster index relative to super cluster
        ucVertStatus: UCHAR; // 1 if vertex has valid data, 0 if it is "fill"
    end;
    TD3DXSHPRTSPLITMESHVERTDATA = _D3DXSHPRTSPLITMESHVERTDATA;
    PD3DXSHPRTSPLITMESHVERTDATA = ^TD3DXSHPRTSPLITMESHVERTDATA;


    // used in D3DXSHPRTCompSplitMeshSC
    // information for each super cluster that maps into face/vert arrays

    _D3DXSHPRTSPLITMESHCLUSTERDATA = record
        uVertStart: UINT; // initial index into remapped vertex array
        uVertLength: UINT; // number of vertices in this super cluster
        uFaceStart: UINT; // initial index into face array
        uFaceLength: UINT; // number of faces in this super cluster
        uClusterStart: UINT; // initial index into cluster array
        uClusterLength: UINT; // number of clusters in this super cluster
    end;
    TD3DXSHPRTSPLITMESHCLUSTERDATA = _D3DXSHPRTSPLITMESHCLUSTERDATA;
    PD3DXSHPRTSPLITMESHCLUSTERDATA = ^TD3DXSHPRTSPLITMESHCLUSTERDATA;

    // call back function for simulator
    // return S_OK to keep running the simulator - anything else represents
    // failure and the simulator will abort.
    LPD3DXSHPRTSIMCB = function(fPercentDone: single; lpUserContext: LPVOID): HRESULT; stdcall;



    ID3DXTextureGutterHelper = interface;
    ID3DXPRTBuffer = interface;
    ID3DXPRTCompBuffer = interface;
    LPD3DXPRTCOMPBUFFER = ^ID3DXPRTCompBuffer;
    ID3DXPRTEngine = interface;
    LPD3DXPRTENGINE = ^ID3DXPRTEngine;




    // Buffer interface - contains "NumSamples" samples
    // each sample in memory is stored as NumCoeffs scalars per channel (1 or 3)
    // Same interface is used for both Vertex and Pixel PRT buffers

    ID3DXPRTBuffer = interface(IUnknown)
        ['{F1827E47-00A8-49cd-908C-9D11955F8728}']
        // ID3DXPRTBuffer
        function GetNumSamples(): UINT; stdcall;

        function GetNumCoeffs(): UINT; stdcall;

        function GetNumChannels(): UINT; stdcall;

        function IsTexture(): boolean; stdcall;

        function GetWidth(): UINT; stdcall;

        function GetHeight(): UINT; stdcall;

        // changes the number of samples allocated in the buffer
        function Resize(NewSize: UINT): HRESULT; stdcall;

        // ppData will point to the memory location where sample Start begins
        // pointer is valid for at least NumSamples samples
        function LockBuffer(Start: UINT; NumSamples: UINT; ppData: pointer): HRESULT; stdcall;

        function UnlockBuffer(): HRESULT; stdcall;

        // every scalar in buffer is multiplied by Scale
        function ScaleBuffer(Scale: single): HRESULT; stdcall;

        // every scalar contains the sum of this and pBuffers values
        // pBuffer must have the same storage class/dimensions
        function AddBuffer(pBuffer: ID3DXPRTBuffer): HRESULT; stdcall;

        // GutterHelper (described below) will fill in the gutter
        // regions of a texture by interpolating "internal" values
        function AttachGH(Nameless1: ID3DXTextureGutterHelper): HRESULT; stdcall;

        function ReleaseGH(): HRESULT; stdcall;

        // Evaluates attached gutter helper on the contents of this buffer
        function EvalGH(): HRESULT; stdcall;

        // extracts a given channel into texture pTexture
        // NumCoefficients starting from StartCoefficient are copied
        function ExtractTexture(Channel: UINT; StartCoefficient: UINT; NumCoefficients: UINT; pTexture: IDirect3DTexture9): HRESULT; stdcall;

        // extracts NumCoefficients coefficients into mesh - only applicable on single channel
        // buffers, otherwise just lockbuffer and copy data.  With SHPRT data NumCoefficients
        // should be Order^2
        function ExtractToMesh(NumCoefficients: UINT; Usage: TD3DDECLUSAGE; UsageIndexStart: UINT; pScene: ID3DXMesh): HRESULT; stdcall;

    end;




    // compressed buffers stored a compressed version of a PRTBuffer

    ID3DXPRTCompBuffer = interface(IUnknown)
        ['{A758D465-FE8D-45ad-9CF0-D01E56266A07}']
        // ID3DPRTCompBuffer
        // NumCoeffs and NumChannels are properties of input buffer
        function GetNumSamples(): UINT; stdcall;

        function GetNumCoeffs(): UINT; stdcall;

        function GetNumChannels(): UINT; stdcall;

        function IsTexture(): boolean; stdcall;

        function GetWidth(): UINT; stdcall;

        function GetHeight(): UINT; stdcall;

        // number of clusters, and PCA vectors per-cluster
        function GetNumClusters(): UINT; stdcall;

        function GetNumPCA(): UINT; stdcall;

        // normalizes PCA weights so that they are between [-1,1]
        // basis vectors are modified to reflect this
        function NormalizeData(): HRESULT; stdcall;

        // copies basis vectors for cluster "Cluster" into pClusterBasis
        // (NumPCA+1)*NumCoeffs*NumChannels floats
        function ExtractBasis(Cluster: UINT; pClusterBasis: Psingle): HRESULT; stdcall;

        // UINT per sample - which cluster it belongs to
        function ExtractClusterIDs(pClusterIDs: PUINT): HRESULT; stdcall;

        // copies NumExtract PCA projection coefficients starting at StartPCA
        // into pPCACoefficients - NumSamples*NumExtract floats copied
        function ExtractPCA(StartPCA: UINT; NumExtract: UINT; pPCACoefficients: Psingle): HRESULT; stdcall;

        // copies NumPCA projection coefficients starting at StartPCA
        // into pTexture - should be able to cope with signed formats
        function ExtractTexture(StartPCA: UINT; NumpPCA: UINT; pTexture: IDirect3DTexture9): HRESULT; stdcall;

        // copies NumPCA projection coefficients into mesh pScene
        // Usage is D3DDECLUSAGE where coefficients are to be stored
        // UsageIndexStart is starting index
        function ExtractToMesh(NumPCA: UINT; Usage: TD3DDECLUSAGE; UsageIndexStart: UINT; pScene: ID3DXMesh): HRESULT; stdcall;

    end;




    // ID3DXTextureGutterHelper will build and manage
    // "gutter" regions in a texture - this will allow for
    // bi-linear interpolation to not have artifacts when rendering
    // It generates a map (in texture space) where each texel
    // is in one of 3 states:
    //   0  Invalid - not used at all
    //   1  Inside triangle
    //   2  Gutter texel
    //   4  represents a gutter texel that will be computed during PRT
    // For each Inside/Gutter texel it stores the face it
    // belongs to and barycentric coordinates for the 1st two
    // vertices of that face.  Gutter vertices are assigned to
    // the closest edge in texture space.

    // When used with PRT this requires a unique parameterization
    // of the model - every texel must correspond to a single point
    // on the surface of the model and vice versa

    ID3DXTextureGutterHelper = interface(IUnknown)
        ['{838F01EC-9729-4527-AADB-DF70ADE7FEA9}']
        // ID3DXTextureGutterHelper
        // dimensions of texture this is bound too
        function GetWidth(): UINT; stdcall;

        function GetHeight(): UINT; stdcall;

        // Applying gutters recomputes all of the gutter texels of class "2"
        // based on texels of class "1" or "4"
        // Applies gutters to a raw float buffer - each texel is NumCoeffs floats
        // Width and Height must match GutterHelper
        function ApplyGuttersFloat(pDataIn: Psingle; NumCoeffs: UINT; Width: UINT; Height: UINT): HRESULT; stdcall;

        // Applies gutters to pTexture
        // Dimensions must match GutterHelper
        function ApplyGuttersTex(pTexture: IDirect3DTexture9): HRESULT; stdcall;

        // Applies gutters to a D3DXPRTBuffer
        // Dimensions must match GutterHelper
        function ApplyGuttersPRT(pBuffer: ID3DXPRTBuffer): HRESULT; stdcall;

        // Resamples a texture from a mesh onto this gutterhelpers
        // parameterization.  It is assumed that the UV coordinates
        // for this gutter helper are in TEXTURE 0 (usage/usage index)
        // and the texture coordinates should all be within [0,1] for
        // both sets.

        // pTextureIn - texture represented using parameterization in pMeshIn
        // pMeshIn    - Mesh with texture coordinates that represent pTextureIn
        //              pTextureOut texture coordinates are assumed to be in
        //              TEXTURE 0
        // Usage      - field in DECL for pMeshIn that stores texture coordinates
        //              for pTextureIn
        // UsageIndex - which index for Usage above for pTextureIn
        // pTextureOut- Resampled texture

        // Usage would generally be D3DDECLUSAGE_TEXCOORD  and UsageIndex other than zero
        function ResampleTex(pTextureIn: IDirect3DTexture9; pMeshIn: ID3DXMesh; Usage: TD3DDECLUSAGE; UsageIndex: UINT; pTextureOut: IDirect3DTexture9): HRESULT; stdcall;

        // the routines below provide access to the data structures
        // used by the Apply functions
        // face map is a UINT per texel that represents the
        // face of the mesh that texel belongs too -
        // only valid if same texel is valid in pGutterData
        // pFaceData must be allocated by the user
        function GetFaceMap(pFaceData: PUINT): HRESULT; stdcall;

        // BaryMap is a D3DXVECTOR2 per texel
        // the 1st two barycentric coordinates for the corresponding
        // face (3rd weight is always 1-sum of first two)
        // only valid if same texel is valid in pGutterData
        // pBaryData must be allocated by the user
        function GetBaryMap(pBaryData: PD3DXVECTOR2): HRESULT; stdcall;

        // TexelMap is a D3DXVECTOR2 per texel that
        // stores the location in pixel coordinates where the
        // corresponding texel is mapped
        // pTexelData must be allocated by the user
        function GetTexelMap(pTexelData: PD3DXVECTOR2): HRESULT; stdcall;

        // GutterMap is a BYTE per texel
        // 0/1/2 for Invalid/Internal/Gutter texels
        // 4 represents a gutter texel that will be computed
        // during PRT
        // pGutterData must be allocated by the user
        function GetGutterMap(pGutterData: pbyte): HRESULT; stdcall;

        // face map is a UINT per texel that represents the
        // face of the mesh that texel belongs too -
        // only valid if same texel is valid in pGutterData
        function SetFaceMap(pFaceData: PUINT): HRESULT; stdcall;

        // BaryMap is a D3DXVECTOR2 per texel
        // the 1st two barycentric coordinates for the corresponding
        // face (3rd weight is always 1-sum of first two)
        // only valid if same texel is valid in pGutterData
        function SetBaryMap(pBaryData: PD3DXVECTOR2): HRESULT; stdcall;

        // TexelMap is a D3DXVECTOR2 per texel that
        // stores the location in pixel coordinates where the
        // corresponding texel is mapped
        function SetTexelMap(pTexelData: PD3DXVECTOR2): HRESULT; stdcall;

        // GutterMap is a BYTE per texel
        // 0/1/2 for Invalid/Internal/Gutter texels
        // 4 represents a gutter texel that will be computed
        // during PRT
        function SetGutterMap(pGutterData: pbyte): HRESULT; stdcall;

    end;




    // ID3DXPRTEngine is used to compute a PRT simulation
    // Use the following steps to compute PRT for SH
    // (1) create an interface (which includes a scene)
    // (2) call SetSamplingInfo
    // (3) [optional] Set MeshMaterials/albedo's (required if doing bounces)
    // (4) call ComputeDirectLightingSH
    // (5) [optional] call ComputeBounce
    // repeat step 5 for as many bounces as wanted.
    // if you want to model subsurface scattering you
    // need to call ComputeSS after direct lighting and
    // each bounce.
    // If you want to bake the albedo into the PRT signal, you
    // must call MutliplyAlbedo, otherwise the user has to multiply
    // the albedo themselves.  Not multiplying the albedo allows you
    // to model albedo variation at a finer scale then illumination, and
    // can result in better compression results.
    // Luminance values are computed from RGB values using the following
    // formula:  R * 0.2125 + G * 0.7154 + B * 0.0721

    ID3DXPRTEngine = interface(IUnknown)
        ['{683A4278-CD5F-4d24-90AD-C4E1B6855D53}']
        // ID3DXPRTEngine
        // This sets a material per attribute in the scene mesh and it is
        // the only way to specify subsurface scattering parameters.  if
        // bSetAlbedo is FALSE, NumChannels must match the current
        // configuration of the PRTEngine.  If you intend to change
        // NumChannels (through some other SetAlbedo function) it must
        // happen before SetMeshMaterials is called.

        // NumChannels 1 implies "grayscale" materials, set this to 3 to enable
        //  color bleeding effects
        // bSetAlbedo sets albedo from material if TRUE - which clobbers per texel/vertex
        //  albedo that might have been set before.  FALSE won't clobber.
        // fLengthScale is used for subsurface scattering - scene is mapped into a 1mm unit cube
        //  and scaled by this amount
        function SetMeshMaterials(
        {array} ppMaterials: PD3DXSHMATERIAL; NumMeshes: UINT; NumChannels: UINT; bSetAlbedo: boolean; fLengthScale: single): HRESULT; stdcall;

        // setting albedo per-vertex or per-texel over rides the albedos stored per mesh
        // but it does not over ride any other settings
        // sets an albedo to be used per vertex - the albedo is represented as a float
        // pDataIn input pointer (pointint to albedo of 1st sample)
        // NumChannels 1 implies "grayscale" materials, set this to 3 to enable
        //  color bleeding effects
        // Stride - stride in bytes to get to next samples albedo
        function SetPerVertexAlbedo(pDataIn: PVOID; NumChannels: UINT; Stride: UINT): HRESULT; stdcall;

        // represents the albedo per-texel instead of per-vertex (even if per-vertex PRT is used)
        // pAlbedoTexture - texture that stores the albedo (dimension arbitrary)
        // NumChannels 1 implies "grayscale" materials, set this to 3 to enable
        //  color bleeding effects
        // pGH - optional gutter helper, otherwise one is constructed in computation routines and
        //  destroyed (if not attached to buffers)
        function SetPerTexelAlbedo(pAlbedoTexture: IDirect3DTexture9; NumChannels: UINT; pGH: ID3DXTextureGutterHelper): HRESULT; stdcall;

        // gets the per-vertex albedo
        function GetVertexAlbedo(pVertColors: PD3DXCOLOR; NumVerts: UINT): HRESULT; stdcall;

        // If pixel PRT is being computed normals default to ones that are interpolated
        // from the vertex normals.  This specifies a texture that stores an object
        // space normal map instead (must use a texture format that can represent signed values)
        // pNormalTexture - normal map, must be same dimensions as PRTBuffers, signed
        function SetPerTexelNormal(pNormalTexture: IDirect3DTexture9): HRESULT; stdcall;

        // Copies per-vertex albedo from mesh
        // pMesh - mesh that represents the scene.  It must have the same
        //  properties as the mesh used to create the PRTEngine
        // Usage - D3DDECLUSAGE to extract albedos from
        // NumChannels 1 implies "grayscale" materials, set this to 3 to enable
        //  color bleeding effects
        function ExtractPerVertexAlbedo(pMesh: ID3DXMesh; Usage: TD3DDECLUSAGE; NumChannels: UINT): HRESULT; stdcall;

        // Resamples the input buffer into the output buffer
        // can be used to move between per-vertex and per-texel buffers.  This can also be used
        // to convert single channel buffers to 3-channel buffers and vice-versa.
        function ResampleBuffer(pBufferIn: ID3DXPRTBuffer; pBufferOut: ID3DXPRTBuffer): HRESULT; stdcall;

        // Returns the scene mesh - including modifications from adaptive spatial sampling
        // The returned mesh only has positions, normals and texture coordinates (if defined)
        // pD3DDevice - d3d device that will be used to allocate the mesh
        // pFaceRemap - each face has a pointer back to the face on the original mesh that it comes from
        //  if the face hasn't been subdivided this will be an identity mapping
        // pVertRemap - each vertex contains 3 vertices that this is a linear combination of
        // pVertWeights - weights for each of above indices (sum to 1.0f)
        // ppMesh - mesh that will be allocated and filled
        function GetAdaptedMesh(pD3DDevice: IDirect3DDevice9; pFaceRemap: PUINT; pVertRemap: PUINT; pfVertWeights: Psingle; out ppMesh: ID3DXMesh): HRESULT; stdcall;

        // Number of vertices currently allocated (includes new vertices from adaptive sampling)
        function GetNumVerts(): UINT; stdcall;

        // Number of faces currently allocated (includes new faces)
        function GetNumFaces(): UINT; stdcall;

        // Sets the Minimum/Maximum intersection distances, this can be used to control
        // maximum distance that objects can shadow/reflect light, and help with "bad"
        // art that might have near features that you don't want to shadow.  This does not
        // apply for GPU simulations.
        //  fMin - minimum intersection distance, must be positive and less than fMax
        //  fMax - maximum intersection distance, if 0.0f use the previous value, otherwise
        //      must be strictly greater than fMin
        function SetMinMaxIntersection(fMin: single; fMax: single): HRESULT; stdcall;

        // This will subdivide faces on a mesh so that adaptively simulations can
        // use a more conservative threshold (it won't miss features.)
        // MinEdgeLength - minimum edge length that will be generated, if 0.0f a
        //  reasonable default will be used
        // MaxSubdiv - maximum level of subdivision, if 0 is specified a default
        //  value will be used (5)
        function RobustMeshRefine(MinEdgeLength: single; MaxSubdiv: UINT): HRESULT; stdcall;

        // This sets to sampling information used by the simulator.  Adaptive sampling
        // parameters are currently ignored.
        // NumRays - number of rays to shoot per sample
        // UseSphere - if TRUE uses spherical samples, otherwise samples over
        //  the hemisphere.  Should only be used with GPU and Vol computations
        // UseCosine - if TRUE uses a cosine weighting - not used for Vol computations
        //  or if only the visiblity function is desired
        // Adaptive - if TRUE adaptive sampling (angular) is used
        // AdaptiveThresh - threshold used to terminate adaptive angular sampling
        //  ignored if adaptive sampling is not set
        function SetSamplingInfo(NumRays: UINT; UseSphere: boolean; UseCosine: boolean; Adaptive: boolean; AdaptiveThresh: single): HRESULT; stdcall;

        // Methods that compute the direct lighting contribution for objects
        // always represente light using spherical harmonics (SH)
        // the albedo is not multiplied by the signal - it just integrates
        // incoming light.  If NumChannels is not 1 the vector is replicated

        // SHOrder - order of SH to use
        // pDataOut - PRT buffer that is generated.  Can be single channel
        function ComputeDirectLightingSH(SHOrder: UINT; pDataOut: ID3DXPRTBuffer): HRESULT; stdcall;

        // Adaptive variant of above function.  This will refine the mesh
        // generating new vertices/faces to approximate the PRT signal
        // more faithfully.
        // SHOrder - order of SH to use
        // AdaptiveThresh - threshold for adaptive subdivision (in PRT vector error)
        //  if value is less then 1e-6f, 1e-6f is specified
        // MinEdgeLength - minimum edge length that will be generated
        //  if value is too small a fairly conservative model dependent value
        //  is used
        // MaxSubdiv - maximum subdivision level, if 0 is specified it
        //  will default to 4
        // pDataOut - PRT buffer that is generated.  Can be single channel.
        function ComputeDirectLightingSHAdaptive(SHOrder: UINT; AdaptiveThresh: single; MinEdgeLength: single; MaxSubdiv: UINT; pDataOut: ID3DXPRTBuffer): HRESULT; stdcall;

        // Function that computes the direct lighting contribution for objects
        // light is always represented using spherical harmonics (SH)
        // This is done on the GPU and is much faster then using the CPU.
        // The albedo is not multiplied by the signal - it just integrates
        // incoming light.  If NumChannels is not 1 the vector is replicated.
        // ZBias/ZAngleBias are akin to parameters used with shadow zbuffers.
        // A reasonable default for both values is 0.005, but the user should
        // experiment (ZAngleBias can be zero, ZBias should not be.)
        // Callbacks should not use the Direct3D9Device the simulator is using.
        // SetSamplingInfo must be called with TRUE for UseSphere and
        // FALSE for UseCosine before this method is called.

        // pD3DDevice - device used to run GPU simulator - must support PS2.0
        //  and FP render targets
        // Flags - parameters for the GPU simulator, combination of one or more
        //  D3DXSHGPUSIMOPT flags.  Only one SHADOWRES setting should be set and
        //  the defaults is 512
        // SHOrder - order of SH to use
        // ZBias - bias in normal direction (for depth test)
        // ZAngleBias - scaled by one minus cosine of angle with light (offset in depth)
        // pDataOut - PRT buffer that is filled in.  Can be single channel
        function ComputeDirectLightingSHGPU(pD3DDevice: IDirect3DDevice9; Flags: UINT; SHOrder: UINT; ZBias: single; ZAngleBias: single; pDataOut: ID3DXPRTBuffer): HRESULT; stdcall;

        // Functions that computes subsurface scattering (using material properties)
        // Albedo is not multiplied by result.  This only works for per-vertex data
        // use ResampleBuffer to move per-vertex data into a texture and back.

        // pDataIn - input data (previous bounce)
        // pDataOut - result of subsurface scattering simulation
        // pDataTotal - [optional] results can be summed into this buffer
        function ComputeSS(pDataIn: ID3DXPRTBuffer; pDataOut: ID3DXPRTBuffer; pDataTotal: ID3DXPRTBuffer): HRESULT; stdcall;

        // Adaptive version of ComputeSS.

        // pDataIn - input data (previous bounce)
        // AdaptiveThresh - threshold for adaptive subdivision (in PRT vector error)
        //  if value is less then 1e-6f, 1e-6f is specified
        // MinEdgeLength - minimum edge length that will be generated
        //  if value is too small a fairly conservative model dependent value
        //  is used
        // MaxSubdiv - maximum subdivision level, if 0 is specified it
        //  will default to 4
        // pDataOut - result of subsurface scattering simulation
        // pDataTotal - [optional] results can be summed into this buffer
        function ComputeSSAdaptive(pDataIn: ID3DXPRTBuffer; AdaptiveThresh: single; MinEdgeLength: single; MaxSubdiv: UINT; pDataOut: ID3DXPRTBuffer; pDataTotal: ID3DXPRTBuffer): HRESULT; stdcall;

        // computes a single bounce of inter-reflected light
        // works for SH based PRT or generic lighting
        // Albedo is not multiplied by result

        // pDataIn - previous bounces data
        // pDataOut - PRT buffer that is generated
        // pDataTotal - [optional] can be used to keep a running sum
        function ComputeBounce(pDataIn: ID3DXPRTBuffer; pDataOut: ID3DXPRTBuffer; pDataTotal: ID3DXPRTBuffer): HRESULT; stdcall;

        // Adaptive version of above function.

        // pDataIn - previous bounces data, can be single channel
        // AdaptiveThresh - threshold for adaptive subdivision (in PRT vector error)
        //  if value is less then 1e-6f, 1e-6f is specified
        // MinEdgeLength - minimum edge length that will be generated
        //  if value is too small a fairly conservative model dependent value
        //  is used
        // MaxSubdiv - maximum subdivision level, if 0 is specified it
        //  will default to 4
        // pDataOut - PRT buffer that is generated
        // pDataTotal - [optional] can be used to keep a running sum
        function ComputeBounceAdaptive(pDataIn: ID3DXPRTBuffer; AdaptiveThresh: single; MinEdgeLength: single; MaxSubdiv: UINT; pDataOut: ID3DXPRTBuffer; pDataTotal: ID3DXPRTBuffer): HRESULT; stdcall;

        // Computes projection of distant SH radiance into a local SH radiance
        // function.  This models how direct lighting is attenuated by the
        // scene and is a form of "neighborhood transfer."  The result is
        // a linear operator (matrix) at every sample point, if you multiply
        // this matrix by the distant SH lighting coefficients you get an
        // approximation of the local incident radiance function from
        // direct lighting.  These resulting lighting coefficients can
        // than be projected into another basis or used with any rendering
        // technique that uses spherical harmonics as input.
        // SetSamplingInfo must be called with TRUE for UseSphere and
        // FALSE for UseCosine before this method is called.
        // Generates SHOrderIn*SHOrderIn*SHOrderOut*SHOrderOut scalars
        // per channel at each sample location.

        // SHOrderIn  - Order of the SH representation of distant lighting
        // SHOrderOut - Order of the SH representation of local lighting
        // NumVolSamples  - Number of sample locations
        // pSampleLocs    - position of sample locations
        // pDataOut       - PRT Buffer that will store output results
        function ComputeVolumeSamplesDirectSH(SHOrderIn: UINT; SHOrderOut: UINT; NumVolSamples: UINT; pSampleLocs: PD3DXVECTOR3; pDataOut: ID3DXPRTBuffer): HRESULT; stdcall;

        // At each sample location computes a linear operator (matrix) that maps
        // the representation of source radiance (NumCoeffs in pSurfDataIn)
        // into a local incident radiance function approximated with spherical
        // harmonics.  For example if a light map data is specified in pSurfDataIn
        // the result is an SH representation of the flow of light at each sample
        // point.  If PRT data for an outdoor scene is used, each sample point
        // contains a matrix that models how distant lighting bounces of the objects
        // in the scene and arrives at the given sample point.  Combined with
        // ComputeVolumeSamplesDirectSH this gives the complete representation for
        // how light arrives at each sample point parameterized by distant lighting.
        // SetSamplingInfo must be called with TRUE for UseSphere and
        // FALSE for UseCosine before this method is called.
        // Generates pSurfDataIn->NumCoeffs()*SHOrder*SHOrder scalars
        // per channel at each sample location.

        // pSurfDataIn    - previous bounce data
        // SHOrder        - order of SH to generate projection with
        // NumVolSamples  - Number of sample locations
        // pSampleLocs    - position of sample locations
        // pDataOut       - PRT Buffer that will store output results
        function ComputeVolumeSamples(pSurfDataIn: ID3DXPRTBuffer; SHOrder: UINT; NumVolSamples: UINT; pSampleLocs: PD3DXVECTOR3; pDataOut: ID3DXPRTBuffer): HRESULT; stdcall;

        // Computes direct lighting (SH) for a point not on the mesh
        // with a given normal - cannot use texture buffers.

        // SHOrder      - order of SH to use
        // NumSamples   - number of sample locations
        // pSampleLocs  - position for each sample
        // pSampleNorms - normal for each sample
        // pDataOut     - PRT Buffer that will store output results
        function ComputeSurfSamplesDirectSH(SHOrder: UINT; NumSamples: UINT; pSampleLocs: PD3DXVECTOR3; pSampleNorms: PD3DXVECTOR3; pDataOut: ID3DXPRTBuffer): HRESULT; stdcall;

        // given the solution for PRT or light maps, computes transfer vector at arbitrary
        // position/normal pairs in space

        // pSurfDataIn  - input data
        // NumSamples   - number of sample locations
        // pSampleLocs  - position for each sample
        // pSampleNorms - normal for each sample
        // pDataOut     - PRT Buffer that will store output results
        // pDataTotal   - optional buffer to sum results into - can be NULL
        function ComputeSurfSamplesBounce(pSurfDataIn: ID3DXPRTBuffer; NumSamples: UINT; pSampleLocs: PD3DXVECTOR3; pSampleNorms: PD3DXVECTOR3; pDataOut: ID3DXPRTBuffer;
            pDataTotal: ID3DXPRTBuffer): HRESULT; stdcall;

        // Frees temporary data structures that can be created for subsurface scattering
        // this data is freed when the PRTComputeEngine is freed and is lazily created
        function FreeSSData(): HRESULT; stdcall;

        // Frees temporary data structures that can be created for bounce simulations
        // this data is freed when the PRTComputeEngine is freed and is lazily created
        function FreeBounceData(): HRESULT; stdcall;

        // This computes the Local Deformable PRT (LDPRT) coefficients relative to the
        // per sample normals that minimize error in a least squares sense with respect
        // to the input PRT data set.  These coefficients can be used with skinned/transformed
        // normals to model global effects with dynamic objects.  Shading normals can
        // optionally be solved for - these normals (along with the LDPRT coefficients) can
        // more accurately represent the PRT signal.  The coefficients are for zonal
        // harmonics oriented in the normal/shading normal direction.

        // pDataIn  - SH PRT dataset that is input
        // SHOrder  - Order of SH to compute conv coefficients for
        // pNormOut - Optional array of vectors (passed in) that will be filled with
        //             "shading normals", LDPRT coefficients are optimized for
        //             these normals.  This array must be the same size as the number of
        //             samples in pDataIn
        // pDataOut - Output buffer (SHOrder zonal harmonic coefficients per channel per sample)
        function ComputeLDPRTCoeffs(pDataIn: ID3DXPRTBuffer; SHOrder: UINT; pNormOut: PD3DXVECTOR3; pDataOut: ID3DXPRTBuffer): HRESULT; stdcall;

        // scales all the samples associated with a given sub mesh
        // can be useful when using subsurface scattering
        // fScale - value to scale each vector in submesh by
        function ScaleMeshChunk(uMeshChunk: UINT; fScale: single; pDataOut: ID3DXPRTBuffer): HRESULT; stdcall;

        // mutliplies each PRT vector by the albedo - can be used if you want to have the albedo
        // burned into the dataset, often better not to do this.  If this is not done the user
        // must mutliply the albedo themselves when rendering - just multiply the albedo times
        // the result of the PRT dot product.
        // If pDataOut is a texture simulation result and there is an albedo texture it
        // must be represented at the same resolution as the simulation buffer.  You can use
        // LoadSurfaceFromSurface and set a new albedo texture if this is an issue - but must
        // be careful about how the gutters are handled.

        // pDataOut - dataset that will get albedo pushed into it
        function MultiplyAlbedo(pDataOut: ID3DXPRTBuffer): HRESULT; stdcall;

        // Sets a pointer to an optional call back function that reports back to the
        // user percentage done and gives them the option of quitting
        // pCB - pointer to call back function, return S_OK for the simulation
        //  to continue
        // Frequency - 1/Frequency is roughly the number of times the call back
        //  will be invoked
        // lpUserContext - will be passed back to the users call back
        function SetCallBack(pCB: LPD3DXSHPRTSIMCB; Frequency: single; lpUserContext: LPVOID): HRESULT; stdcall;

        // Returns TRUE if the ray intersects the mesh, FALSE if it does not.  This function
        // takes into account settings from SetMinMaxIntersection.  If the closest intersection
        // is not needed this function is more efficient compared to the ClosestRayIntersection
        // method.
        // pRayPos - origin of ray
        // pRayDir - normalized ray direction (normalization required for SetMinMax to be meaningful)
        function ShadowRayIntersects(pRayPos: PD3DXVECTOR3; pRayDir: PD3DXVECTOR3): boolean; stdcall;

        // Returns TRUE if the ray intersects the mesh, FALSE if it does not.  If there is an
        // intersection the closest face that was intersected and its first two barycentric coordinates
        // are returned.  This function takes into account settings from SetMinMaxIntersection.
        // This is a slower function compared to ShadowRayIntersects and should only be used where
        // needed.  The third vertices barycentric coordinates will be 1 - pU - pV.
        // pRayPos     - origin of ray
        // pRayDir     - normalized ray direction (normalization required for SetMinMax to be meaningful)
        // pFaceIndex  - Closest face that intersects.  This index is based on stacking the pBlockerMesh
        //  faces before the faces from pMesh
        // pU          - Barycentric coordinate for vertex 0
        // pV          - Barycentric coordinate for vertex 1
        // pDist       - Distance along ray where the intersection occured
        function ClosestRayIntersects(pRayPos: PD3DXVECTOR3; pRayDir: PD3DXVECTOR3; pFaceIndex: PDWORD; pU: Psingle; pV: Psingle; pDist: Psingle): boolean; stdcall;

    end;



    {$PACKRECORDS 1}
    _XFILECOMPRESSEDANIMATIONSET = record
        CompressedBlockSize: DWORD;
        TicksPerSec: single;
        PlaybackType: DWORD;
        BufferLength: DWORD;
    end;
    TXFILECOMPRESSEDANIMATIONSET = _XFILECOMPRESSEDANIMATIONSET;
    PXFILECOMPRESSEDANIMATIONSET = ^TXFILECOMPRESSEDANIMATIONSET;

    {$PACKRECORDS DEFAULT}




// API functions for creating interfaces
//============================================================================
//
//  D3DXCreatePRTBuffer:
//  --------------------
//  Generates a PRT Buffer that can be compressed or filled by a simulator
//  This function should be used to create per-vertex or volume buffers.
//  When buffers are created all values are initialized to zero.
//
//  Parameters:
//    NumSamples
//      Number of sample locations represented
//    NumCoeffs
//      Number of coefficients per sample location (order^2 for SH)
//    NumChannels
//      Number of color channels to represent (1 or 3)
//    ppBuffer
//      Buffer that will be allocated
//
//============================================================================




function D3DXCreatePRTBuffer(
NumSamples : UINT ;
NumCoeffs : UINT ;
NumChannels : UINT ;
out ppBuffer : ID3DXPRTBuffer
    ) : HRESULT;stdcall; external D3DX9_DLL;


//============================================================================
//
//  D3DXCreatePRTBufferTex:
//  --------------------
//  Generates a PRT Buffer that can be compressed or filled by a simulator
//  This function should be used to create per-pixel buffers.
//  When buffers are created all values are initialized to zero.
//
//  Parameters:
//    Width
//      Width of texture
//    Height
//      Height of texture
//    NumCoeffs
//      Number of coefficients per sample location (order^2 for SH)
//    NumChannels
//      Number of color channels to represent (1 or 3)
//    ppBuffer
//      Buffer that will be allocated
//
//============================================================================

function D3DXCreatePRTBufferTex(
Width : UINT ;
Height : UINT ;
NumCoeffs : UINT ;
NumChannels : UINT ;
out ppBuffer : ID3DXPRTBuffer
    ) : HRESULT;stdcall; external D3DX9_DLL;


//============================================================================
//
//  D3DXLoadPRTBufferFromFile:
//  --------------------
//  Loads a PRT buffer that has been saved to disk.
//
//  Parameters:
//    pFilename
//      Name of the file to load
//    ppBuffer
//      Buffer that will be allocated
//
//============================================================================

function D3DXLoadPRTBufferFromFileA(
pFilename : LPCSTR ;
out ppBuffer : ID3DXPRTBuffer
    ) : HRESULT;stdcall; external D3DX9_DLL;


function D3DXLoadPRTBufferFromFileW(
pFilename : LPCWSTR ;
out ppBuffer : ID3DXPRTBuffer
    ) : HRESULT;stdcall;  external D3DX9_DLL;




//============================================================================
//
//  D3DXSavePRTBufferToFile:
//  --------------------
//  Saves a PRTBuffer to disk.
//
//  Parameters:
//    pFilename
//      Name of the file to save
//    pBuffer
//      Buffer that will be saved
//
//============================================================================

function D3DXSavePRTBufferToFileA(
pFileName : LPCSTR ;
pBuffer : ID3DXPRTBuffer
    ) : HRESULT;stdcall;  external D3DX9_DLL;


function D3DXSavePRTBufferToFileW(
pFileName : LPCWSTR ;
pBuffer : ID3DXPRTBuffer
    ) : HRESULT;stdcall;  external D3DX9_DLL;




//============================================================================
//
//  D3DXLoadPRTCompBufferFromFile:
//  --------------------
//  Loads a PRTComp buffer that has been saved to disk.
//
//  Parameters:
//    pFilename
//      Name of the file to load
//    ppBuffer
//      Buffer that will be allocated
//
//============================================================================

function D3DXLoadPRTCompBufferFromFileA(
pFilename : LPCSTR ;
out ppBuffer : ID3DXPRTCompBuffer
    ) : HRESULT;stdcall;  external D3DX9_DLL;


function D3DXLoadPRTCompBufferFromFileW(
pFilename : LPCWSTR ;
out ppBuffer : ID3DXPRTCompBuffer
    ) : HRESULT;stdcall;  external D3DX9_DLL;




//============================================================================
//
//  D3DXSavePRTCompBufferToFile:
//  --------------------
//  Saves a PRTCompBuffer to disk.
//
//  Parameters:
//    pFilename
//      Name of the file to save
//    pBuffer
//      Buffer that will be saved
//
//============================================================================

function D3DXSavePRTCompBufferToFileA(
pFileName : LPCSTR ;
pBuffer : ID3DXPRTCompBuffer
    ) : HRESULT;stdcall;  external D3DX9_DLL;


function D3DXSavePRTCompBufferToFileW(
pFileName : LPCWSTR ;
pBuffer : ID3DXPRTCompBuffer
    ) : HRESULT;stdcall; external D3DX9_DLL;



//============================================================================
//
//  D3DXCreatePRTCompBuffer:
//  --------------------
//  Compresses a PRT buffer (vertex or texel)
//
//  Parameters:
//    D3DXSHCOMPRESSQUALITYTYPE
//      Quality of compression - low is faster (computes PCA per voronoi cluster)
//      high is slower but better quality (clusters based on distance to affine subspace)
//    NumClusters
//      Number of clusters to compute
//    NumPCA
//      Number of basis vectors to compute
//    pCB
//      Optional Callback function
//    lpUserContext
//      Optional user context
//    pBufferIn
//      Buffer that will be compressed
//    ppBufferOut
//      Compressed buffer that will be created
//
//============================================================================


function D3DXCreatePRTCompBuffer(
Quality : TD3DXSHCOMPRESSQUALITYTYPE ;
NumClusters : UINT ;
NumPCA : UINT ;
pCB : LPD3DXSHPRTSIMCB ;
lpUserContext : LPVOID ;
pBufferIn : ID3DXPRTBuffer ;
out ppBufferOut : ID3DXPRTCompBuffer
    ) : HRESULT;stdcall; external D3DX9_DLL;


//============================================================================
//
//  D3DXCreateTextureGutterHelper:
//  --------------------
//  Generates a "GutterHelper" for a given set of meshes and texture
//  resolution
//
//  Parameters:
//    Width
//      Width of texture
//    Height
//      Height of texture
//    pMesh
//      Mesh that represents the scene
//    GutterSize
//      Number of texels to over rasterize in texture space
//      this should be at least 1.0
//    ppBuffer
//      GutterHelper that will be created
//
//============================================================================


function D3DXCreateTextureGutterHelper(
Width : UINT ;
Height : UINT ;
pMesh : ID3DXMesh ;
GutterSize : single ;
out ppBuffer : ID3DXTextureGutterHelper
    ) : HRESULT;stdcall; external D3DX9_DLL;



//============================================================================
//
//  D3DXCreatePRTEngine:
//  --------------------
//  Computes a PRTEngine which can efficiently generate PRT simulations
//  of a scene
//
//  Parameters:
//    pMesh
//      Mesh that represents the scene - must have an AttributeTable
//      where vertices are in a unique attribute.
//    pAdjacency
//      Optional adjacency information
//    ExtractUVs
//      Set this to true if textures are going to be used for albedos
//      or to store PRT vectors
//    pBlockerMesh
//      Optional mesh that just blocks the scene
//    ppEngine
//      PRTEngine that will be created
//
//============================================================================


function D3DXCreatePRTEngine(
pMesh : ID3DXMesh ;
pAdjacency : PDWORD ;
ExtractUVs : boolean ;
pBlockerMesh : ID3DXMesh ;
out ppEngine : ID3DXPRTEngine
    ) : HRESULT;stdcall; external D3DX9_DLL;


//============================================================================
//
//  D3DXConcatenateMeshes:
//  --------------------
//  Concatenates a group of meshes into one common mesh.  This can optionaly transform
//  each sub mesh or its texture coordinates.  If no DECL is given it will
//  generate a union of all of the DECL's of the sub meshes, promoting channels
//  and types if neccesary.  It will create an AttributeTable if possible, one can
//  call OptimizeMesh with attribute sort and compacting enabled to ensure this.
//
//  Parameters:
//    ppMeshes
//      Array of pointers to meshes that can store PRT vectors
//    NumMeshes
//      Number of meshes
//    Options
//      Passed through to D3DXCreateMesh
//    pGeomXForms
//      [optional] Each sub mesh is transformed by the corresponding
//      matrix if this array is supplied
//    pTextureXForms
//      [optional] UV coordinates for each sub mesh are transformed
//      by corresponding matrix if supplied
//    pDecl
//      [optional] Only information in this DECL is used when merging
//      data
//    pD3DDevice
//      D3D device that is used to create the new mesh
//    ppMeshOut
//      Mesh that will be created
//
//============================================================================


function D3DXConcatenateMeshes(
{in array} ppMeshes : LPD3DXMESH ;
NumMeshes : UINT ;
Options : DWORD ;
pGeomXForms : PD3DXMATRIX ;
pTextureXForms : PD3DXMATRIX ;
pDecl : PD3DVERTEXELEMENT9 ;
pD3DDevice : IDirect3DDevice9 ;
out ppMeshOut : ID3DXMesh
    ) : HRESULT;stdcall;external D3DX9_DLL;


//============================================================================
//
//  D3DXSHPRTCompSuperCluster:
//  --------------------------
//  Used with compressed results of D3DXSHPRTSimulation.
//  Generates "super clusters" - groups of clusters that can be drawn in
//  the same draw call.  A greedy algorithm that minimizes overdraw is used
//  to group the clusters.
//
//  Parameters:
//   pClusterIDs
//      NumVerts cluster ID's (extracted from a compressed buffer)
//   pScene
//      Mesh that represents composite scene passed to the simulator
//   MaxNumClusters
//      Maximum number of clusters allocated per super cluster
//   NumClusters
//      Number of clusters computed in the simulator
//   pSuperClusterIDs
//      Array of length NumClusters, contains index of super cluster
//      that corresponding cluster was assigned to
//   pNumSuperClusters
//      Returns the number of super clusters allocated
//
//============================================================================

function D3DXSHPRTCompSuperCluster(
pClusterIDs : PUINT ;
pScene : ID3DXMesh ;
MaxNumClusters : UINT ;
NumClusters : UINT ;
pSuperClusterIDs : PUINT ;
pNumSuperClusters : PUINT
    ) : HRESULT;stdcall; external D3DX9_DLL;


//============================================================================
//
//  D3DXSHPRTCompSplitMeshSC:
//  -------------------------
//  Used with compressed results of the vertex version of the PRT simulator.
//  After D3DXSHRTCompSuperCluster has been called this function can be used
//  to split the mesh into a group of faces/vertices per super cluster.
//  Each super cluster contains all of the faces that contain any vertex
//  classified in one of its clusters.  All of the vertices connected to this
//  set of faces are also included with the returned array ppVertStatus
//  indicating whether or not the vertex belongs to the supercluster.
//
//  Parameters:
//   pClusterIDs
//      NumVerts cluster ID's (extracted from a compressed buffer)
//   NumVertices
//      Number of vertices in original mesh
//   NumClusters
//      Number of clusters (input parameter to compression)
//   pSuperClusterIDs
//      Array of size NumClusters that will contain super cluster ID's (from
//      D3DXSHCompSuerCluster)
//   NumSuperClusters
//      Number of superclusters allocated in D3DXSHCompSuerCluster
//   pInputIB
//      Raw index buffer for mesh - format depends on bInputIBIs32Bit
//   InputIBIs32Bit
//      Indicates whether the input index buffer is 32-bit (otherwise 16-bit
//      is assumed)
//   NumFaces
//      Number of faces in the original mesh (pInputIB is 3 times this length)
//   ppIBData
//      LPD3DXBUFFER holds raw index buffer that will contain the resulting split faces.
//      Format determined by bIBIs32Bit.  Allocated by function
//   pIBDataLength
//      Length of ppIBData, assigned in function
//   OutputIBIs32Bit
//      Indicates whether the output index buffer is to be 32-bit (otherwise
//      16-bit is assumed)
//   ppFaceRemap
//      LPD3DXBUFFER mapping of each face in ppIBData to original faces.  Length is
//      *pIBDataLength/3.  Optional paramter, allocated in function
//   ppVertData
//      LPD3DXBUFFER contains new vertex data structure.  Size of pVertDataLength
//   pVertDataLength
//      Number of new vertices in split mesh.  Assigned in function
//   pSCClusterList
//      Array of length NumClusters which pSCData indexes into (Cluster* fields)
//      for each SC, contains clusters sorted by super cluster
//   pSCData
//      Structure per super cluster - contains indices into ppIBData,
//      pSCClusterList and ppVertData
//
//============================================================================

function D3DXSHPRTCompSplitMeshSC(
pClusterIDs : PUINT ;
NumVertices : UINT ;
NumClusters : UINT ;
pSuperClusterIDs : PUINT ;
NumSuperClusters : UINT ;
pInputIB : LPVOID ;
InputIBIs32Bit : boolean ;
NumFaces : UINT ;
out ppIBData : ID3DXBuffer ;
pIBDataLength : PUINT ;
OutputIBIs32Bit : boolean ;
out ppFaceRemap : ID3DXBuffer ;
out ppVertData : ID3DXBuffer ;
pVertDataLength : PUINT ;
pSCClusterList : PUINT ;
pSCData : PD3DXSHPRTSPLITMESHCLUSTERDATA
    ) : HRESULT;stdcall; external D3DX9_DLL;



  

function D3DXCreateMesh(
NumFaces : DWORD ;
NumVertices : DWORD ;
Options : DWORD ;
pDeclaration : PD3DVERTEXELEMENT9 ;
pD3DDevice : IDirect3DDevice9 ;
out ppMesh : ID3DXMESH
    ) : HRESULT;stdcall;  external D3DX9_DLL;


function D3DXCreateMeshFVF(
NumFaces : DWORD ;
NumVertices : DWORD ;
Options : DWORD ;
FVF : DWORD ;
pD3DDevice : IDirect3DDevice9 ;
out ppMesh : ID3DXMESH
    ) : HRESULT;stdcall;  external D3DX9_DLL;


function D3DXCreateSPMesh(
pMesh : ID3DXMESH ;
pAdjacency : PDWORD ;
pVertexAttributeWeights : PD3DXATTRIBUTEWEIGHTS ;
pVertexWeights : Psingle ;
out ppSMesh : ID3DXSPMESH
    ) : HRESULT;stdcall;   external D3DX9_DLL;


// clean a mesh up for simplification, try to make manifold
function D3DXCleanMesh(
CleanType : TD3DXCLEANTYPE ;
pMeshIn : ID3DXMESH ;
pAdjacencyIn : PDWORD ;
out ppMeshOut : ID3DXMESH ;
pAdjacencyOut : PDWORD ;
out ppErrorsAndWarnings : ID3DXBUFFER
    ) : HRESULT;stdcall;    external D3DX9_DLL;


function D3DXValidMesh(
pMeshIn : ID3DXMESH ;
pAdjacency : PDWORD ;
out ppErrorsAndWarnings : ID3DXBUFFER
    ) : HRESULT;stdcall;   external D3DX9_DLL;


function D3DXGeneratePMesh(
pMesh : ID3DXMESH ;
pAdjacency : PDWORD ;
pVertexAttributeWeights : PD3DXATTRIBUTEWEIGHTS ;
pVertexWeights : Psingle ;
MinValue : DWORD ;
Options : DWORD ;
out ppPMesh : ID3DXPMESH
    ) : HRESULT;stdcall;    external D3DX9_DLL;


function D3DXSimplifyMesh(
pMesh : ID3DXMESH ;
pAdjacency : PDWORD ;
pVertexAttributeWeights : PD3DXATTRIBUTEWEIGHTS ;
pVertexWeights : Psingle ;
MinValue : DWORD ;
Options : DWORD ;
out ppMesh : ID3DXMESH
    ) : HRESULT;stdcall;  external D3DX9_DLL;


function D3DXComputeBoundingSphere(
// pointer to first position
pFirstPosition : PD3DXVECTOR3 ;
NumVertices : DWORD ;
// count in bytes to subsequent position vectors
dwStride : DWORD ;
pCenter : PD3DXVECTOR3 ;
pRadius : Psingle
    ) : HRESULT;stdcall;    external D3DX9_DLL;


function D3DXComputeBoundingBox(
// pointer to first position
pFirstPosition : PD3DXVECTOR3 ;
NumVertices : DWORD ;
// count in bytes to subsequent position vectors
dwStride : DWORD ;
pMin : PD3DXVECTOR3 ;
pMax : PD3DXVECTOR3
    ) : HRESULT;stdcall;    external D3DX9_DLL;


function D3DXComputeNormals(
pMesh : ID3DXBASEMESH ;
pAdjacency : PDWORD
    ) : HRESULT;stdcall;   external D3DX9_DLL;


function D3DXCreateBuffer(
NumBytes : DWORD ;
out ppBuffer : ID3DXBUFFER
    ) : HRESULT;stdcall;         external D3DX9_DLL;



function D3DXLoadMeshFromXA(
pFilename : LPCSTR ;
Options : DWORD ;
pD3DDevice : IDirect3DDevice9 ;
out ppAdjacency : ID3DXBuffer ;
out ppMaterials : ID3DXBuffer ;
out ppEffectInstances : ID3DXBuffer ;
pNumMaterials : PDWORD ;
out ppMesh : ID3DXMESH
    ) : HRESULT;stdcall;       external D3DX9_DLL;


function D3DXLoadMeshFromXW(
pFilename : LPCWSTR ;
Options : DWORD ;
pD3DDevice : IDirect3DDevice9 ;
out ppAdjacency : ID3DXBuffer ;
out ppMaterials : ID3DXBuffer ;
out ppEffectInstances : ID3DXBuffer ;
pNumMaterials : PDWORD ;
out ppMesh : ID3DXMESH
    ) : HRESULT;stdcall;      external D3DX9_DLL;


function D3DXLoadMeshFromXInMemory(
Memory : LPCVOID ;
SizeOfMemory : DWORD ;
Options : DWORD ;
pD3DDevice : IDirect3DDevice9 ;
out ppAdjacency : ID3DXBuffer ;
out ppMaterials : ID3DXBuffer ;
out ppEffectInstances : ID3DXBuffer ;
pNumMaterials : PDWORD ;
out ppMesh : ID3DXMESH
    ) : HRESULT;stdcall;   external D3DX9_DLL;


function D3DXLoadMeshFromXResource(
Module : HMODULE ;
Name : LPCSTR ;
MeshType : LPCSTR ;
Options : DWORD ;
pD3DDevice : IDirect3DDevice9 ;
out ppAdjacency : ID3DXBuffer ;
out ppMaterials : ID3DXBuffer ;
out ppEffectInstances : ID3DXBuffer ;
pNumMaterials : PDWORD ;
out ppMesh : ID3DXMESH
    ) : HRESULT;stdcall;   external D3DX9_DLL;


function D3DXSaveMeshToXA(
pFilename : LPCSTR ;
pMesh : ID3DXMESH ;
pAdjacency : PDWORD ;
pMaterials : PD3DXMATERIAL ;
pEffectInstances : PD3DXEFFECTINSTANCE ;
NumMaterials : DWORD ;
Format : DWORD
    ) : HRESULT;stdcall;  external D3DX9_DLL;


function D3DXSaveMeshToXW(
pFilename : LPCWSTR ;
pMesh : ID3DXMESH ;
pAdjacency : PDWORD ;
pMaterials : PD3DXMATERIAL ;
pEffectInstances : PD3DXEFFECTINSTANCE ;
NumMaterials : DWORD ;
Format : DWORD
    ) : HRESULT;stdcall;  external D3DX9_DLL;


function D3DXCreatePMeshFromStream(
pStream : IStream ;
Options : DWORD ;
pD3DDevice : IDirect3DDevice9 ;
out ppMaterials : ID3DXBuffer ;
out ppEffectInstances : ID3DXBuffer ;
pNumMaterials : PDWORD ;
out ppPMesh : ID3DXPMESH
    ) : HRESULT;stdcall; external D3DX9_DLL;


// Creates a skin info object based on the number of vertices, number of bones, and a declaration describing the vertex layout of the target vertices
// The bone names and initial bone transforms are not filled in the skin info object by this method.
function D3DXCreateSkinInfo(
NumVertices : DWORD ;
pDeclaration : PD3DVERTEXELEMENT9 ;
NumBones : DWORD ;
out ppSkinInfo : ID3DXSKININFO
    ) : HRESULT;stdcall;     external D3DX9_DLL;


// Creates a skin info object based on the number of vertices, number of bones, and a FVF describing the vertex layout of the target vertices
// The bone names and initial bone transforms are not filled in the skin info object by this method.
function D3DXCreateSkinInfoFVF(
NumVertices : DWORD ;
FVF : DWORD ;
NumBones : DWORD ;
out ppSkinInfo : ID3DXSKININFO
    ) : HRESULT;stdcall;    external D3DX9_DLL;



function D3DXLoadMeshFromXof(
pxofMesh : ID3DXFileData ;
Options : DWORD ;
pD3DDevice : IDirect3DDevice9 ;
out ppAdjacency : ID3DXBuffer ;
out ppMaterials : ID3DXBuffer ;
out ppEffectInstances : ID3DXBuffer ;
pNumMaterials : PDWORD ;
out ppMesh : ID3DXMESH
    ) : HRESULT;stdcall;   external D3DX9_DLL;


// This similar to D3DXLoadMeshFromXof, except also returns skinning info if present in the file
// If skinning info is not present, ppSkinInfo will be NULL
function D3DXLoadSkinMeshFromXof(
pxofMesh : ID3DXFILEDATA ;
Options : DWORD ;
pD3DDevice : IDirect3DDevice9 ;
out ppAdjacency : ID3DXBuffer ;
out ppMaterials : ID3DXBuffer ;
out ppEffectInstances : ID3DXBuffer ;
pMatOut : PDWORD ;
out ppSkinInfo : ID3DXSKININFO ;
out ppMesh : ID3DXMESH
    ) : HRESULT;stdcall;     external D3DX9_DLL;



// The inverse of D3DXConvertTo{Indexed}BlendedMesh() functions. It figures out the skinning info from
// the mesh and the bone combination table and populates a skin info object with that data. The bone
// names and initial bone transforms are not filled in the skin info object by this method. This works
// with either a non-indexed or indexed blended mesh. It examines the FVF or declarator of the mesh to
// determine what type it is.
function D3DXCreateSkinInfoFromBlendedMesh(
pMesh : ID3DXBASEMESH ;
NumBones : DWORD ;
pBoneCombinationTable : PD3DXBONECOMBINATION ;
out ppSkinInfo : ID3DXSKININFO
    ) : HRESULT;stdcall;  external D3DX9_DLL;


function D3DXTessellateNPatches(
pMeshIn : ID3DXMESH ;
pAdjacencyIn : PDWORD ;
NumSegs : single ;
// if false use linear intrep for normals, if true use quadratic
QuadraticInterpNormals : boolean ;
out ppMeshOut : ID3DXMESH ;
out ppAdjacencyOut : ID3DXBUFFER
    ) : HRESULT;stdcall;   external D3DX9_DLL;



//generates implied outputdecl from input decl
//the decl generated from this should be used to generate the output decl for
//the tessellator subroutines.

function D3DXGenerateOutputDecl(
pOutput : PD3DVERTEXELEMENT9 ;
pInput : PD3DVERTEXELEMENT9
    ) : HRESULT;stdcall;    external D3DX9_DLL;


//loads patches from an XFileData
//since an X file can have up to 6 different patch meshes in it,
//returns them in an array - pNumPatches will contain the number of
//meshes in the actual file.
function D3DXLoadPatchMeshFromXof(
pXofObjMesh : ID3DXFILEDATA ;
Options : DWORD ;
pD3DDevice : IDirect3DDevice9 ;
out ppMaterials : ID3DXBUFFER ;
out ppEffectInstances : ID3DXBUFFER ;
pNumMaterials : PDWORD ;
out ppMesh : ID3DXPATCHMESH
    ) : HRESULT;stdcall; external D3DX9_DLL;


//computes the size a single rect patch.
function D3DXRectPatchSize(
//segments for each edge (4)
pfNumSegs : Psingle ;
//output number of triangles
pdwTriangles : PDWORD ;
pdwVertices : PDWORD
    ) : HRESULT;stdcall;    external D3DX9_DLL;


//computes the size of a single triangle patch
function D3DXTriPatchSize(
//segments for each edge (3)
pfNumSegs : Psingle ;
//output number of triangles
pdwTriangles : PDWORD ;
pdwVertices : PDWORD
    ) : HRESULT;stdcall;   external D3DX9_DLL;



//tessellates a patch into a created mesh
//similar to D3D RT patch
function D3DXTessellateRectPatch(
pVB : IDIRECT3DVERTEXBUFFER9 ;
pNumSegs : Psingle ;
pdwInDecl : PD3DVERTEXELEMENT9 ;
pRectPatchInfo : PD3DRECTPATCH_INFO ;
pMesh : ID3DXMESH
    ) : HRESULT;stdcall;    external D3DX9_DLL;



function D3DXTessellateTriPatch(
pVB : IDIRECT3DVERTEXBUFFER9 ;
pNumSegs : Psingle ;
pInDecl : PD3DVERTEXELEMENT9 ;
pTriPatchInfo : PD3DTRIPATCH_INFO ;
pMesh : ID3DXMESH
    ) : HRESULT;stdcall;    external D3DX9_DLL;




//creates an NPatch PatchMesh from a D3DXMESH
function D3DXCreateNPatchMesh(
pMeshSysMem : ID3DXMESH ;
out pPatchMesh : ID3DXPATCHMESH
    ) : HRESULT;stdcall;        external D3DX9_DLL;



//creates a patch mesh
function D3DXCreatePatchMesh(
//patch type
pInfo : PD3DXPATCHINFO ;
//number of patches
dwNumPatches : DWORD ;
//number of control vertices
dwNumVertices : DWORD ;
//options
dwOptions : DWORD ;
//format of control vertices
pDecl : PD3DVERTEXELEMENT9 ;
pD3DDevice : IDirect3DDevice9 ;
out pPatchMesh : ID3DXPatchMesh
    ) : HRESULT;stdcall;     external D3DX9_DLL;



//returns the number of degenerates in a patch mesh -
//text output put in string.
function D3DXValidPatchMesh(
pMesh : ID3DXPATCHMESH ;
dwcDegenerateVertices : PDWORD ;
dwcDegeneratePatches : PDWORD ;
out ppErrorsAndWarnings : ID3DXBUFFER
    ) : HRESULT;stdcall;   external D3DX9_DLL;


function D3DXGetFVFVertexSize(
FVF : DWORD
    ) : UINT;stdcall;external D3DX9_DLL;


function D3DXGetDeclVertexSize(
pDecl : PD3DVERTEXELEMENT9 ;
Stream : DWORD
    ) : UINT;stdcall; external D3DX9_DLL;


function D3DXGetDeclLength(
pDecl : PD3DVERTEXELEMENT9
    ) : UINT;stdcall; external D3DX9_DLL;


function D3DXDeclaratorFromFVF(
FVF : DWORD ;
pDeclarator :TMAX_FVFVertexArray
    ) : HRESULT;stdcall; external D3DX9_DLL;


function D3DXFVFFromDeclarator(
pDeclarator : PD3DVERTEXELEMENT9 ;
pFVF : PDWORD
    ) : HRESULT;stdcall;  external D3DX9_DLL;


function D3DXWeldVertices(
pMesh : ID3DXMESH ;
Flags : DWORD ;
pEpsilons : PD3DXWELDEPSILONS ;
pAdjacencyIn : PDWORD ;
pAdjacencyOut : PDWORD ;
pFaceRemap : PDWORD ;
out ppVertexRemap : ID3DXBUFFER
    ) : HRESULT;stdcall;   external D3DX9_DLL;




function D3DXIntersect(
pMesh : ID3DXBASEMESH ;
pRayPos : PD3DXVECTOR3 ;
pRayDir : PD3DXVECTOR3 ;
// True if any faces were intersected
pHit : Pboolean ;
// index of closest face intersected
pFaceIndex : PDWORD ;
// Barycentric Hit Coordinates
pU : Psingle ;
// Barycentric Hit Coordinates
pV : Psingle ;
// Ray-Intersection Parameter Distance
pDist : Psingle ;
// Array of D3DXINTERSECTINFOs for all hits (not just closest)
out {array} ppAllHits : PID3DXBuffer ;
pCountOfHits : PDWORD
    ) : HRESULT;stdcall;  external D3DX9_DLL;


function D3DXIntersectSubset(
pMesh : ID3DXBASEMESH ;
AttribId : DWORD ;
pRayPos : PD3DXVECTOR3 ;
pRayDir : PD3DXVECTOR3 ;
// True if any faces were intersected
pHit : Pboolean ;
// index of closest face intersected
pFaceIndex : PDWORD ;
// Barycentric Hit Coordinates
pU : Psingle ;
// Barycentric Hit Coordinates
pV : Psingle ;
// Ray-Intersection Parameter Distance
pDist : Psingle ;
// Array of D3DXINTERSECTINFOs for all hits (not just closest)
out {array} ppAllHits : PID3DXBUFFER ;
pCountOfHits : PDWORD
    ) : HRESULT;stdcall;  external D3DX9_DLL;



function D3DXSplitMesh(
pMeshIn : ID3DXMESH ;
pAdjacencyIn : PDWORD ;
MaxSize : DWORD ;
Options : DWORD ;
pMeshesOut : PDWORD ;
out ppMeshArrayOut : ID3DXBUFFER ;
out ppAdjacencyArrayOut : ID3DXBUFFER ;
out ppFaceRemapArrayOut : ID3DXBUFFER ;
out ppVertRemapArrayOut : ID3DXBUFFER
    ) : HRESULT;stdcall;  external D3DX9_DLL;


function D3DXIntersectTri(
// Triangle vertex 0 position
p0 : PD3DXVECTOR3 ;
// Triangle vertex 1 position
p1 : PD3DXVECTOR3 ;
// Triangle vertex 2 position
p2 : PD3DXVECTOR3 ;
// Ray origin
pRayPos : PD3DXVECTOR3 ;
// Ray direction
pRayDir : PD3DXVECTOR3 ;
// Barycentric Hit Coordinates
pU : Psingle ;
// Barycentric Hit Coordinates
pV : Psingle ;
pDist : Psingle
    ) : boolean;stdcall;   external D3DX9_DLL;


function D3DXSphereBoundProbe(
pCenter : PD3DXVECTOR3 ;
Radius : single ;
pRayPosition : PD3DXVECTOR3 ;
pRayDirection : PD3DXVECTOR3
    ) : boolean;stdcall; external D3DX9_DLL;


function D3DXBoxBoundProbe(
pMin : PD3DXVECTOR3 ;
pMax : PD3DXVECTOR3 ;
pRayPosition : PD3DXVECTOR3 ;
pRayDirection : PD3DXVECTOR3
    ) : boolean;stdcall;   external D3DX9_DLL;



function D3DXComputeTangentFrame(
pMesh : ID3DXMesh ;
dwOptions : DWORD
    ) : HRESULT;stdcall; external D3DX9_DLL;


function D3DXComputeTangentFrameEx(
pMesh : ID3DXMesh ;
dwTextureInSemantic : DWORD ;
dwTextureInIndex : DWORD ;
dwUPartialOutSemantic : DWORD ;
dwUPartialOutIndex : DWORD ;
dwVPartialOutSemantic : DWORD ;
dwVPartialOutIndex : DWORD ;
dwNormalOutSemantic : DWORD ;
dwNormalOutIndex : DWORD ;
dwOptions : DWORD ;
pdwAdjacency : PDWORD ;
fPartialEdgeThreshold : single ;
fSingularPointThreshold : single ;
fNormalEdgeThreshold : single ;
out ppMeshOut :ID3DXMesh  ;
out ppVertexMapping : ID3DXBuffer
    ) : HRESULT;stdcall;    external D3DX9_DLL;



//D3DXComputeTangent
//
//Computes the Tangent vectors for the TexStage texture coordinates
//and places the results in the TANGENT[TangentIndex] specified in the meshes' DECL
//puts the binorm in BINORM[BinormIndex] also specified in the decl.
//
//If neither the binorm or the tangnet are in the meshes declaration,
//the function will fail.
//
//If a tangent or Binorm field is in the Decl, but the user does not
//wish D3DXComputeTangent to replace them, then D3DX_DEFAULT specified
//in the TangentIndex or BinormIndex will cause it to ignore the specified
//semantic.
//
//Wrap should be specified if the texture coordinates wrap.

function D3DXComputeTangent(
Mesh : ID3DXMESH ;
TexStage : DWORD ;
TangentIndex : DWORD ;
BinormIndex : DWORD ;
Wrap : DWORD ;
pAdjacency : PDWORD
    ) : HRESULT;stdcall;   external D3DX9_DLL;


//============================================================================
//
// UVAtlas apis
//
//============================================================================
// This function creates atlases for meshes. There are two modes of operation,
// either based on the number of charts, or the maximum allowed stretch. If the
// maximum allowed stretch is 0, then each triangle will likely be in its own
// chart.
//
// The parameters are as follows:
//  pMesh - Input mesh to calculate an atlas for. This must have a position
//          channel and at least a 2-d texture channel.
//  uMaxChartNumber - The maximum number of charts required for the atlas.
//                    If this is 0, it will be parameterized based solely on
//                    stretch.
//  fMaxStretch - The maximum amount of stretch, if 0, no stretching is allowed,
//                if 1, then any amount of stretching is allowed.
//  uWidth - The width of the texture the atlas will be used on.
//  uHeight - The height of the texture the atlas will be used on.
//  fGutter - The minimum distance, in texels between two charts on the atlas.
//            this gets scaled by the width, so if fGutter is 2.5, and it is
//            used on a 512x512 texture, then the minimum distance will be
//            2.5 / 512 in u-v space.
//  dwTextureIndex - Specifies which texture coordinate to write to in the
//                   output mesh (which is cloned from the input mesh). Useful
//                   if your vertex has multiple texture coordinates.
//  pdwAdjacency - a pointer to an array with 3 DWORDs per face, indicating
//                 which triangles are adjacent to each other.
//  pdwFalseEdgeAdjacency - a pointer to an array with 3 DWORDS per face, indicating
//                          at each face, whether an edge is a false edge or not (using
//                          the same ordering as the adjacency data structure). If this
//                          is NULL, then it is assumed that there are no false edges. If
//                          not NULL, then a non-false edge is indicated by -1 and a false
//                          edge is indicated by any other value (it is not required, but
//                          it may be useful for the caller to use the original adjacency
//                          value). This allows you to parameterize a mesh of quads, and
//                          the edges down the middle of each quad will not be cut when
//                          parameterizing the mesh.
//  pfIMTArray - a pointer to an array with 3 FLOATs per face, describing the
//               integrated metric tensor for that face. This lets you control
//               the way this triangle may be stretched in the atlas. The IMT
//               passed in will be 3 floats (a,b,c) and specify a symmetric
//               matrix (a b) that, given a vector (s,t), specifies the
//                      (b c)
//               distance between a vector v1 and a vector v2 = v1 + (s,t) as
//               sqrt((s, t) * M * (s, t)^T).
//               In other words, this lets one specify the magnitude of the
//               stretch in an arbitrary direction in u-v space. For example
//               if a = b = c = 1, then this scales the vector (1,1) by 2, and
//               the vector (1,-1) by 0. Note that this is multiplying the edge
//               length by the square of the matrix, so if you want the face to
//               stretch to twice its
//               size with no shearing, the IMT value should be (2, 0, 2), which
//               is just the identity matrix times 2.
//               Note that this assumes you have an orientation for the triangle
//               in some 2-D space. For D3DXUVAtlas, this space is created by
//               letting S be the direction from the first to the second
//               vertex, and T be the cross product between the normal and S.
//
//  pStatusCallback - Since the atlas creation process can be very CPU intensive,
//                    this allows the programmer to specify a function to be called
//                    periodically, similarly to how it is done in the PRT simulation
//                    engine.
//  fCallbackFrequency - This lets you specify how often the callback will be
//                       called. A decent default should be 0.0001f.
//  pUserContext - a void pointer to be passed back to the callback function
//  dwOptions - A combination of flags in the D3DXUVATLAS enum
//  ppMeshOut - A pointer to a location to store a pointer for the newly created
//              mesh.
//  ppFacePartitioning - A pointer to a location to store a pointer for an array,
//                       one DWORD per face, giving the final partitioning
//                       created by the atlasing algorithm.
//  ppVertexRemapArray - A pointer to a location to store a pointer for an array,
//                       one DWORD per vertex, giving the vertex it was copied
//                       from, if any vertices needed to be split.
//  pfMaxStretchOut - A location to store the maximum stretch resulting from the
//                    atlasing algorithm.
//  puNumChartsOut - A location to store the number of charts created, or if the
//                   maximum number of charts was too low, this gives the minimum
//                    number of charts needed to create an atlas.




function D3DXUVAtlasCreate(
pMesh : ID3DXMESH ;
uMaxChartNumber : UINT ;
fMaxStretch : single ;
uWidth : UINT ;
uHeight : UINT ;
fGutter : single ;
dwTextureIndex : DWORD ;
pdwAdjacency : PDWORD ;
pdwFalseEdgeAdjacency : PDWORD ;
pfIMTArray : Psingle ;
pStatusCallback : LPD3DXUVATLASCB ;
fCallbackFrequency : single ;
pUserContext : LPVOID ;
dwOptions : DWORD ;
out ppMeshOut : ID3DXMESH ;
out ppFacePartitioning : ID3DXBUFFER ;
out ppVertexRemapArray : ID3DXBUFFER ;
pfMaxStretchOut : Psingle ;
puNumChartsOut : PUINT
    ) : HRESULT;stdcall;  external D3DX9_DLL;


// This has the same exact arguments as Create, except that it does not perform the
// final packing step. This method allows one to get a partitioning out, and possibly
// modify it before sending it to be repacked. Note that if you change the
// partitioning, you'll also need to calculate new texture coordinates for any faces
// that have switched charts.
//
// The partition result adjacency output parameter is meant to be passed to the
// UVAtlasPack function, this adjacency cuts edges that are between adjacent
// charts, and also can include cuts inside of a chart in order to make it
// equivalent to a disc. For example:
//
// _______
// | ___ |
// | |_| |
// |_____|
//
// In order to make this equivalent to a disc, we would need to add a cut, and it
// Would end up looking like:
// _______
// | ___ |
// | |_|_|
// |_____|
//
// The resulting partition adjacency parameter cannot be NULL, because it is
// required for the packing step.



function D3DXUVAtlasPartition(
pMesh : ID3DXMESH ;
uMaxChartNumber : UINT ;
fMaxStretch : single ;
dwTextureIndex : DWORD ;
pdwAdjacency : PDWORD ;
pdwFalseEdgeAdjacency : PDWORD ;
pfIMTArray : Psingle ;
pStatusCallback : LPD3DXUVATLASCB ;
fCallbackFrequency : single ;
pUserContext : LPVOID ;
dwOptions : DWORD ;
out ppMeshOut : ID3DXMESH ;
out ppFacePartitioning : ID3DXBUFFER ;
out ppVertexRemapArray : ID3DXBUFFER ;
out ppPartitionResultAdjacency : ID3DXBUFFER ;
pfMaxStretchOut : Psingle ;
puNumChartsOut : PUINT
    ) : HRESULT;stdcall; external D3DX9_DLL;


// This takes the face partitioning result from Partition and packs it into an
// atlas of the given size. pdwPartitionResultAdjacency should be derived from
// the adjacency returned from the partition step. This value cannot be NULL
// because Pack needs to know where charts were cut in the partition step in
// order to find the edges of each chart.
// The options parameter is currently reserved.
function D3DXUVAtlasPack(
pMesh : ID3DXMesh ;
uWidth : UINT ;
uHeight : UINT ;
fGutter : single ;
dwTextureIndex : DWORD ;
pdwPartitionResultAdjacency : PDWORD ;
pStatusCallback : LPD3DXUVATLASCB ;
fCallbackFrequency : single ;
pUserContext : LPVOID ;
dwOptions : DWORD ;
pFacePartitioning : ID3DXBUFFER
    ) : HRESULT;stdcall;   external D3DX9_DLL;



//============================================================================
//
// IMT Calculation apis
//
// These functions all compute the Integrated Metric Tensor for use in the
// UVAtlas API. They all calculate the IMT with respect to the canonical
// triangle, where the coordinate system is set up so that the u axis goes
// from vertex 0 to 1 and the v axis is N x u. So, for example, the second
// vertex's canonical uv coordinates are (d,0) where d is the distance between
// vertices 0 and 1. This way the IMT does not depend on the parameterization
// of the mesh, and if the signal over the surface doesn't change, then
// the IMT doesn't need to be recalculated.
//============================================================================
// This function is used to calculate the IMT from per vertex data. It sets
// up a linear system over the triangle, solves for the jacobian J, then
// constructs the IMT from that (J^TJ).
// This function allows you to calculate the IMT based off of any value in a
// mesh (color, normal, etc) by specifying the correct stride of the array.
// The IMT computed will cause areas of the mesh that have similar values to
// take up less space in the texture.
//
// pMesh            - The mesh to calculate the IMT for.
// pVertexSignal    - A float array of size uSignalStride * v, where v is the
//                    number of vertices in the mesh.
// uSignalDimension - How many floats per vertex to use in calculating the IMT.
// uSignalStride    - The number of bytes per vertex in the array. This must be
//                    a multiple of sizeof(float)
// ppIMTData        - Where to store the buffer holding the IMT data




function D3DXComputeIMTFromPerVertexSignal(
pMesh : ID3DXMESH ;
// uSignalDimension floats per vertex
pfVertexSignal : Psingle ;
uSignalDimension : UINT ;
// stride of signal in bytes
uSignalStride : UINT ;
// reserved for future use
dwOptions : DWORD ;
pStatusCallback : LPD3DXUVATLASCB ;
pUserContext : LPVOID ;
out ppIMTData : ID3DXBUFFER
    ) : HRESULT;stdcall;  external D3DX9_DLL;


// This function is used to calculate the IMT from data that varies over the
// surface of the mesh (generally at a higher frequency than vertex data).
// This function requires the mesh to already be parameterized (so it already
// has texture coordinates). It allows the user to define a signal arbitrarily
// over the surface of the mesh.
//
// pMesh            - The mesh to calculate the IMT for.
// dwTextureIndex   - This describes which set of texture coordinates in the
//                    mesh to use.
// uSignalDimension - How many components there are in the signal.
// fMaxUVDistance   - The subdivision will continue until the distance between
//                    all vertices is at most fMaxUVDistance.
// dwOptions        - reserved for future use
// pSignalCallback  - The callback to use to get the signal.
// pUserData        - A pointer that will be passed in to the callback.
// ppIMTData        - Where to store the buffer holding the IMT data
function D3DXComputeIMTFromSignal(
pMesh : ID3DXMESH ;
dwTextureIndex : DWORD ;
uSignalDimension : UINT ;
fMaxUVDistance : single ;
// reserved for future use
dwOptions : DWORD ;
pSignalCallback : LPD3DXIMTSIGNALCALLBACK ;
pUserData : PVOID ;
pStatusCallback : LPD3DXUVATLASCB ;
pUserContext : LPVOID ;
out ppIMTData : ID3DXBUFFER
    ) : HRESULT;stdcall; external D3DX9_DLL;


// This function is used to calculate the IMT from texture data. Given a texture
// that maps over the surface of the mesh, the algorithm computes the IMT for
// each face. This will cause large areas that are very similar to take up less
// room when parameterized with UVAtlas. The texture is assumed to be
// interpolated over the mesh bilinearly.
//
// pMesh            - The mesh to calculate the IMT for.
// pTexture         - The texture to load data from.
// dwTextureIndex   - This describes which set of texture coordinates in the
//                    mesh to use.
// dwOptions        - Combination of one or more D3DXIMT flags.
// ppIMTData        - Where to store the buffer holding the IMT data
function D3DXComputeIMTFromTexture(
pMesh : ID3DXMESH ;
pTexture : IDIRECT3DTEXTURE9 ;
dwTextureIndex : DWORD ;
dwOptions : DWORD ;
pStatusCallback :LPD3DXUVATLASCB ;
pUserContext : LPVOID ;
out ppIMTData : ID3DXBUFFER
    ) : HRESULT;stdcall;  external D3DX9_DLL;


// This function is very similar to ComputeIMTFromTexture, but it uses a
// float array to pass in the data, and it can calculate higher dimensional
// values than 4.
//
// pMesh            - The mesh to calculate the IMT for.
// dwTextureIndex   - This describes which set of texture coordinates in the
//                    mesh to use.
// pfFloatArray     - a pointer to a float array of size
//                    uWidth*uHeight*uComponents
// uWidth           - The width of the texture
// uHeight          - The height of the texture
// uSignalDimension - The number of floats per texel in the signal
// uComponents      - The number of floats in each texel
// dwOptions        - Combination of one or more D3DXIMT flags
// ppIMTData        - Where to store the buffer holding the IMT data
function D3DXComputeIMTFromPerTexelSignal(
pMesh : ID3DXMESH ;
dwTextureIndex : DWORD ;
pfTexelSignal : Psingle ;
uWidth : UINT ;
uHeight : UINT ;
uSignalDimension : UINT ;
uComponents : UINT ;
dwOptions : DWORD ;
pStatusCallback : LPD3DXUVATLASCB ;
pUserContext : LPVOID ;
out ppIMTData : ID3DXBUFFER
    ) : HRESULT;stdcall;  external D3DX9_DLL;


function D3DXConvertMeshSubsetToSingleStrip(
MeshIn : ID3DXBASEMESH ;
AttribId : DWORD ;
IBOptions : DWORD ;
out ppIndexBuffer : IDIRECT3DINDEXBUFFER9 ;
pNumIndices : PDWORD
    ) : HRESULT;stdcall;  external D3DX9_DLL;


function D3DXConvertMeshSubsetToStrips(
MeshIn : ID3DXBASEMESH ;
AttribId : DWORD ;
IBOptions : DWORD ;
out ppIndexBuffer : IDIRECT3DINDEXBUFFER9 ;
pNumIndices : PDWORD ;
out ppStripLengths : ID3DXBUFFER ;
pNumStrips : PDWORD
    ) : HRESULT;stdcall;   external D3DX9_DLL;



//============================================================================
//
//  D3DXOptimizeFaces:
//  --------------------
//  Generate a face remapping for a triangle list that more effectively utilizes
//    vertex caches.  This optimization is identical to the one provided
//    by ID3DXMesh::Optimize with the hardware independent option enabled.
//
//  Parameters:
//   pbIndices
//      Triangle list indices to use for generating a vertex ordering
//   NumFaces
//      Number of faces in the triangle list
//   NumVertices
//      Number of vertices referenced by the triangle list
//   b32BitIndices
//      TRUE if indices are 32 bit, FALSE if indices are 16 bit
//   pFaceRemap
//      Destination buffer to store face ordering
//      The number stored for a given element is where in the new ordering
//        the face will have come from.  See ID3DXMesh::Optimize for more info.
//
//============================================================================
function D3DXOptimizeFaces(
pbIndices : LPCVOID ;
cFaces : UINT ;
cVertices : UINT ;
b32BitIndices : boolean ;
pFaceRemap : PDWORD
    ) : HRESULT;stdcall; external D3DX9_DLL;


//============================================================================
//
//  D3DXOptimizeVertices:
//  --------------------
//  Generate a vertex remapping to optimize for in order use of vertices for
//    a given set of indices.  This is commonly used after applying the face
//    remap generated by D3DXOptimizeFaces
//
//  Parameters:
//   pbIndices
//      Triangle list indices to use for generating a vertex ordering
//   NumFaces
//      Number of faces in the triangle list
//   NumVertices
//      Number of vertices referenced by the triangle list
//   b32BitIndices
//      TRUE if indices are 32 bit, FALSE if indices are 16 bit
//   pVertexRemap
//      Destination buffer to store vertex ordering
//      The number stored for a given element is where in the new ordering
//        the vertex will have come from.  See ID3DXMesh::Optimize for more info.
//
//============================================================================
function D3DXOptimizeVertices(
pbIndices : LPCVOID ;
cFaces : UINT ;
cVertices : UINT ;
b32BitIndices : boolean ;
pVertexRemap : PDWORD
    ) : HRESULT;stdcall;  external D3DX9_DLL;







implementation

end.
