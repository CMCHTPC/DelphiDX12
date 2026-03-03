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
   File name: d3dx9anim.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3DX9Anim9;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D9,
    DX12.DXFile,
    DX12.D3DX9Mesh,
    DX12.D3DX9Math;

    {$Z4}

const
    D3DX9_DLL = 'D3DX9_43.dll';

const

    // {ADE2C06D-3747-4b9f-A514-3440B8284980}
    IID_ID3DXInterpolator: TGUID = '{ADE2C06D-3747-4B9F-A514-3440B8284980}';


    // {6CAA71F8-0972-4cdb-A55B-43B968997515}
    IID_ID3DXKeyFrameInterpolator: TGUID = '{6CAA71F8-0972-4CDB-A55B-43B968997515}';


    // {54B569AC-0AEF-473e-9704-3FEF317F64AB}
    IID_ID3DXAnimationSet: TGUID = '{54B569AC-0AEF-473E-9704-3FEF317F64AB}';


    // {3A714D34-FF61-421e-909F-639F38356708}
    IID_ID3DXAnimationController: TGUID = '{3A714D34-FF61-421E-909F-639F38356708}';

type
    ID3DXInterpolator = interface;
    ID3DXKeyFrameInterpolator = interface;
    ID3DXAnimationSet = interface;
    ID3DXAnimationController = interface;

    {$interfaces corba}
    ID3DXAllocateHierarchy = interface;
    ID3DXLoadUserData = interface;
    ID3DXSaveUserData = interface;
    {$interfaces com}

    LPD3DXINTERPOLATOR = ^ID3DXInterpolator;
    LPD3DXKEYFRAMEINTERPOLATOR = ^ID3DXKeyFrameInterpolator;
    LPD3DXANIMATIONSET = ^ID3DXAnimationSet;
    LPD3DXANIMATIONCONTROLLER = ^ID3DXAnimationController;

    LPD3DXALLOCATEHIERARCHY = ^ID3DXAllocateHierarchy;
    LPD3DXLOADUSERDATA = ^ID3DXLoadUserData;
    LPD3DXSAVEUSERDATA = ^ID3DXSaveUserData;



    //----------------------------------------------------------------------------
    // This enum defines the type of mesh data present in a MeshData structure
    //----------------------------------------------------------------------------
    _D3DXMESHDATATYPE = (
        D3DXMESHTYPE_MESH = $001, // normal ID3DXMesh data
        D3DXMESHTYPE_PMESH = $002, // Progressive Mesh - ID3DXPMesh
        D3DXMESHTYPE_PATCHMESH = $003, // Patch MEsh - ID3DXPatchMesh
        D3DXMESHTYPE_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    TD3DXMESHDATATYPE = _D3DXMESHDATATYPE;
    PD3DXMESHDATATYPE = ^TD3DXMESHDATATYPE;


    //----------------------------------------------------------------------------
    // This struct encapsulates a the mesh data that can be present in a mesh
    //   container.  The supported mesh types are pMesh, pPMesh, pPatchMesh
    //   The valid way to access this is determined by the MeshType enum
    //----------------------------------------------------------------------------
    _D3DXMESHDATA = record
        DataType: TD3DXMESHDATATYPE;
            // current mesh data interface
        case integer of
            0: (
                pMesh: LPD3DXMESH;
            );
            1: (
                pPMesh: LPD3DXPMESH;
            );
            2: (
                pPatchMesh: LPD3DXPATCHMESH;
            );

    end;
    TD3DXMESHDATA = _D3DXMESHDATA;
    PD3DXMESHDATA = ^TD3DXMESHDATA;
    LPD3DXMESHDATA = ^TD3DXMESHDATA;

    //----------------------------------------------------------------------------
    // This struct encapsulates a mesh object in a transformation frame
    // hierarchy. The app can derive from this structure to add other app specific
    // data to this
    //----------------------------------------------------------------------------

    PD3DXMESHCONTAINER = ^TD3DXMESHCONTAINER;

    _D3DXMESHCONTAINER = record
        Name: LPSTR;
        MeshData: TD3DXMESHDATA;
        pMaterials: LPD3DXMATERIAL;
        pEffects: LPD3DXEFFECTINSTANCE;
        NumMaterials: DWORD;
        pAdjacency: PDWORD;
        pSkinInfo: LPD3DXSKININFO;
        pNextMeshContainer: PD3DXMESHCONTAINER;
    end;
    TD3DXMESHCONTAINER = _D3DXMESHCONTAINER;


    LPD3DXMESHCONTAINER = ^TD3DXMESHCONTAINER;

    //----------------------------------------------------------------------------
    // This struct is the encapsulates a transform frame in a transformation frame
    // hierarchy. The app can derive from this structure to add other app specific
    // data to this
    //----------------------------------------------------------------------------
    PD3DXFRAME = ^TD3DXFRAME;

    _D3DXFRAME = record
        Name: LPSTR;
        TransformationMatrix: TD3DXMATRIX;
        pMeshContainer: LPD3DXMESHCONTAINER;
        pFrameSibling: PD3DXFRAME;
        pFrameFirstChild: PD3DXFRAME;
    end;
    TD3DXFRAME = _D3DXFRAME;


    LPD3DXFRAME = ^TD3DXFRAME;




    //----------------------------------------------------------------------------
    // This interface is implemented by the application to allocate/free frame and
    // mesh container objects. Methods on this are called during loading and
    // destroying frame hierarchies
    //----------------------------------------------------------------------------
    //////////////////////////////////////////////////////////////////////////////
    // ID3DXAllocateHierarchy ////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    {$interfaces corba}
    ID3DXAllocateHierarchy = interface
        // ID3DXAllocateHierarchy
        //------------------------------------------------------------------------
        // CreateFrame:
        // ------------
        // Requests allocation of a frame object.

        // Parameters:
        //  Name
        //        Name of the frame to be created
        //    ppNewFrame
        //        Returns returns the created frame object

        //------------------------------------------------------------------------
        function CreateFrame(Name: LPCSTR; out ppNewFrame: PD3DXFRAME): HRESULT; stdcall;

        //------------------------------------------------------------------------
        // CreateMeshContainer:
        // --------------------
        // Requests allocation of a mesh container object.

        // Parameters:
        //  Name
        //        Name of the mesh
        //    pMesh
        //        Pointer to the mesh object if basic polygon data found
        //    pPMesh
        //        Pointer to the progressive mesh object if progressive mesh data found
        //    pPatchMesh
        //        Pointer to the patch mesh object if patch data found
        //    pMaterials
        //        Array of materials used in the mesh
        //    pEffectInstances
        //        Array of effect instances used in the mesh
        //    NumMaterials
        //        Num elements in the pMaterials array
        //    pAdjacency
        //        Adjacency array for the mesh
        //    pSkinInfo
        //        Pointer to the skininfo object if the mesh is skinned
        //    pBoneNames
        //        Array of names, one for each bone in the skinned mesh.
        //        The numberof bones can be found from the pSkinMesh object
        //    pBoneOffsetMatrices
        //        Array of matrices, one for each bone in the skinned mesh.

        //------------------------------------------------------------------------
        function CreateMeshContainer(Name: LPCSTR; pMeshData: LPD3DXMESHDATA; pMaterials: LPD3DXMATERIAL; pEffectInstances: LPD3DXEFFECTINSTANCE; NumMaterials: DWORD; pAdjacency: PDWORD;
            pSkinInfo: ID3DXSkinInfo; out ppNewMeshContainer: LPD3DXMESHCONTAINER): HRESULT; stdcall;

        //------------------------------------------------------------------------
        // DestroyFrame:
        // -------------
        // Requests de-allocation of a frame object.

        // Parameters:
        //  pFrameToFree
        //        Pointer to the frame to be de-allocated

        //------------------------------------------------------------------------
        function DestroyFrame(pFrameToFree: LPD3DXFRAME): HRESULT; stdcall;

        //------------------------------------------------------------------------
        // DestroyMeshContainer:
        // ---------------------
        // Requests de-allocation of a mesh container object.

        // Parameters:
        //  pMeshContainerToFree
        //        Pointer to the mesh container object to be de-allocated

        //------------------------------------------------------------------------
        function DestroyMeshContainer(pMeshContainerToFree: LPD3DXMESHCONTAINER): HRESULT; stdcall;

    end;

    {$interfaces COM}


    //----------------------------------------------------------------------------
    // This interface is implemented by the application to load user data in a .X file
    //   When user data is found, these callbacks will be used to allow the application
    //   to load the data
    //----------------------------------------------------------------------------
    //////////////////////////////////////////////////////////////////////////////
    // ID3DXLoadUserData ////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    {$interfaces corba}
    ID3DXLoadUserData = interface
        function LoadTopLevelData(pXofChildData: IDirectXFileData): HRESULT; stdcall;

        function LoadFrameChildData(pFrame: LPD3DXFRAME; pXofChildData: IDirectXFileData): HRESULT; stdcall;

        function LoadMeshChildData(pMeshContainer: LPD3DXMESHCONTAINER; pXofChildData: IDirectXFileData): HRESULT; stdcall;

    end;

    {$interfaces COM}


    //----------------------------------------------------------------------------
    // This interface is implemented by the application to save user data in a .X file
    //   The callbacks are called for all data saved.  The user can then add any
    //   child data objects to the object provided to the callback
    //----------------------------------------------------------------------------
    //////////////////////////////////////////////////////////////////////////////
    // ID3DXSaveUserData /////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    {$interfaces corba}
    ID3DXSaveUserData = interface
        function AddFrameChildData(pFrame: LPD3DXFRAME; pXofSave: IDirectXFileSaveObject; pXofFrameData: IDirectXFileData): HRESULT; stdcall;

        function AddMeshChildData(pMeshContainer: LPD3DXMESHCONTAINER; pXofSave: IDirectXFileSaveObject; pXofMeshData: IDirectXFileData): HRESULT; stdcall;

        // NOTE: this is called once per Save.  All top level objects should be added using the
        //    provided interface.  One call adds objects before the frame hierarchy, the other after
        function AddTopLevelDataObjectsPre(pXofSave: IDirectXFileSaveObject): HRESULT; stdcall;

        function AddTopLevelDataObjectsPost(pXofSave: IDirectXFileSaveObject): HRESULT; stdcall;

        // callbacks for the user to register and then save templates to the XFile
        function RegisterTemplates(pXFileApi: IDirectXFile): HRESULT; stdcall;

        function SaveTemplates(pXofSave: IDirectXFileSaveObject): HRESULT; stdcall;

    end;

    {$interfaces COM}


    //----------------------------------------------------------------------------
    // This interface defines a SRT (scale/rotate/translate) interpolator. This
    // is an abstract interface. ID3DXKeyFrameInterpolator inherits from this.
    // An application can implement this for custom SRT interpolator
    //----------------------------------------------------------------------------
    //////////////////////////////////////////////////////////////////////////////
    // ID3DXInterpolator /////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    ID3DXInterpolator = interface(IUnknown)
        ['{ADE2C06D-3747-4B9F-A514-3440B8284980}']
        // ID3DXInterpolator
        function GetName(): LPCSTR; stdcall;

        function GetPeriod(): double; stdcall;

        //----------------------------------------------------------------------------
        // GetSRT:
        // -------
        // Returns the scale, rotation and translation at a given time

        // Parameters:
        //    Time
        //        Time at which the interpolator should be queried
        //    pScale
        //        Returns the scale vector
        //    pRotate
        //        Returns the rotation qaternion
        //    pTranslate
        //        Returns the translate vector

        //----------------------------------------------------------------------------
        function GetSRT(
        {in} Time: double;
        {out} pScale: PD3DXVECTOR3;
        {out} pRotate: PD3DXQUATERNION;
        {out} pTranslate: PD3DXVECTOR3): HRESULT; stdcall;

        function GetLastSRT(
        {out} pScale: PD3DXVECTOR3;
        {out} pRotate: PD3DXQUATERNION;
        {out} pTranslate: PD3DXVECTOR3): HRESULT; stdcall;

    end;




    //----------------------------------------------------------------------------
    // This structure describes a vector key for use in keyframe animation.
    // It specifies a vector Value at a given Time. This is used for scale and
    // translation keys
    //----------------------------------------------------------------------------
    _D3DXKEY_VECTOR3 = record
        Time: single;
        Value: TD3DXVECTOR3;
    end;
    TD3DXKEY_VECTOR3 = _D3DXKEY_VECTOR3;
    PD3DXKEY_VECTOR3 = ^TD3DXKEY_VECTOR3;

    LPD3DXKEY_VECTOR3 = ^TD3DXKEY_VECTOR3;


    //----------------------------------------------------------------------------
    // This structure describes a quaternion key for use in keyframe animation.
    // It specifies a quaternion Value at a given Time. This is used for rotation
    // keys
    //----------------------------------------------------------------------------
    _D3DXKEY_QUATERNION = record
        Time: single;
        Value: TD3DXQUATERNION;
    end;
    TD3DXKEY_QUATERNION = _D3DXKEY_QUATERNION;
    PD3DXKEY_QUATERNION = ^TD3DXKEY_QUATERNION;

    LPD3DXKEY_QUATERNION = ^TD3DXKEY_QUATERNION;



    //----------------------------------------------------------------------------
    // This interface implements an SRT (scale/rotate/translate) interpolator
    // It takes a scattered set of keys and interpolates the transform for any
    // given time
    //----------------------------------------------------------------------------
    //////////////////////////////////////////////////////////////////////////////
    // ID3DXKeyFrameInterpolator /////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    ID3DXKeyFrameInterpolator = interface(ID3DXInterpolator)
        ['{6CAA71F8-0972-4CDB-A55B-43B968997515}']
        // ID3DXKeyFrameInterpolator
        function GetNumScaleKeys(): UINT; stdcall;

        function GetScaleKeys(pKeys: LPD3DXKEY_VECTOR3): HRESULT; stdcall;

        function GetNumRotationKeys(): UINT; stdcall;

        function GetRotationKeys(pKeys: LPD3DXKEY_QUATERNION): HRESULT; stdcall;

        function GetNumTranslationKeys(): UINT; stdcall;

        function GetTranslationKeys(pKeys: LPD3DXKEY_VECTOR3): HRESULT; stdcall;

        // the value passed to D3DXCreateKeyFrameInterpolator to scale from the times in LPD3DXKEY_VECTOR3 to global/anim time.
        function GetSourceTicksPerSecond(): double; stdcall;

    end;




    //----------------------------------------------------------------------------
    // This interface implements an set of interpolators. The set consists of
    // interpolators for many nodes for the same animation.
    //----------------------------------------------------------------------------
    //////////////////////////////////////////////////////////////////////////////
    // ID3DXAnimationSet /////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    ID3DXAnimationSet = interface(IUnknown)
        ['{54B569AC-0AEF-473E-9704-3FEF317F64AB}']
        // ID3DXAnimationSet
        function GetName(): LPCSTR; stdcall;

        function GetPeriod(): double; stdcall;

        function GetNumInterpolators(): UINT; stdcall;

        function GetInterpolatorByIndex(Index: UINT; out ppInterpolator: ID3DXInterpolator): HRESULT; stdcall;

        function GetInterpolatorByName(pName: LPCSTR; out ppInterpolator: ID3DXInterpolator): HRESULT; stdcall;

    end;




    //----------------------------------------------------------------------------
    // This structure describes an animation track. A track is a combination
    //  of an animation set (stored separately) and mixing information.
    //  the mixing information consists of the current position, speed, and blending
    //  weight for the track.  The Flags field also specifies whether the track
    //  is low or high priority.  Tracks with the same priority are blended together
    //  and then the two resulting values are blended using the priority blend factor.
    //----------------------------------------------------------------------------
    _D3DXTRACK_DESC = record
        Flags: DWORD;
        Weight: single;
        Speed: single;
        Enable: boolean;
        AnimTime: double;
    end;
    TD3DXTRACK_DESC = _D3DXTRACK_DESC;
    PD3DXTRACK_DESC = ^TD3DXTRACK_DESC;

    LPD3DXTRACK_DESC = ^TD3DXTRACK_DESC;

    //----------------------------------------------------------------------------
    // This enum defines the type of transtion performed on a event that transitions from one value to another
    //----------------------------------------------------------------------------
    _D3DXTRACKFLAG = (
        D3DXTF_LOWPRIORITY = $000, // This track should be blended with all low priority tracks before mixed with the high priority result
        D3DXTF_HIGHPRIORITY = $001, // This track should be blended with all high priority tracks before mixed with the low priority result
        D3DXTF_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    TD3DXTRACKFLAG = _D3DXTRACKFLAG;
    PD3DXTRACKFLAG = ^TD3DXTRACKFLAG;



    //----------------------------------------------------------------------------
    // This interface implements the main animation functionality. It connects
    // animation sets with the transform frames that are being animated. Allows
    // mixing multiple animations for blended animations or for transistions
    // It adds also has methods to modify blending parameters over time to
    // enable smooth transistions and other effects.
    //----------------------------------------------------------------------------
    //----------------------------------------------------------------------------
    // This enum defines the type of transtion performed on a event that transitions from one value to another
    //----------------------------------------------------------------------------


    _D3DXTRANSITIONTYPE = (
        D3DXTRANSITION_LINEAR = $000, // Linear transition from one value to the next
        D3DXTRANSITION_EASEINEASEOUT = $001, // Ease-In Ease-Out spline transtion from one value to the next
        D3DXTRANSITION_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    TD3DXTRANSITIONTYPE = _D3DXTRANSITIONTYPE;
    PD3DXTRANSITIONTYPE = ^TD3DXTRANSITIONTYPE;



    //////////////////////////////////////////////////////////////////////////////
    // ID3DXAnimationController //////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    ID3DXAnimationController = interface(IUnknown)
        ['{3A714D34-FF61-421E-909F-639F38356708}']
        // mixing functionality
        // register outputs of SetTime
        function RegisterMatrix(Name: LPCSTR; pMatrix: PD3DXMATRIX): HRESULT; stdcall;

        // AnimationSets
        function GetNumAnimationSets(): UINT; stdcall;

        function GetAnimationSet(iAnimationSet: DWORD; out ppAnimSet: ID3DXAnimationSet): HRESULT; stdcall;

        function RegisterAnimationSet(pAnimSet: ID3DXAnimationSet): HRESULT; stdcall;

        function UnregisterAnimationSet(pAnimSet: ID3DXAnimationSet): HRESULT; stdcall;

        // Tracks
        function GetMaxNumTracks(): UINT; stdcall;

        function GetTrackDesc(Track: DWORD; pDesc: PD3DXTRACK_DESC): HRESULT; stdcall;

        function SetTrackDesc(Track: DWORD; pDesc: PD3DXTRACK_DESC): HRESULT; stdcall;

        function GetTrackAnimationSet(Track: DWORD; out ppAnimSet: ID3DXAnimationSet): HRESULT; stdcall;

        function SetTrackAnimationSet(Track: DWORD; pAnimSet: ID3DXAnimationSet): HRESULT; stdcall;

        // Individual track field access
        function SetTrackSpeed(Track: DWORD; Speed: single): HRESULT; stdcall;

        function SetTrackWeight(Track: DWORD; Weight: single): HRESULT; stdcall;

        function SetTrackAnimTime(Track: DWORD; AnimTime: double): HRESULT; stdcall;

        function SetTrackEnable(Track: DWORD; Enable: boolean): HRESULT; stdcall;

        // Time
        function GetTime(): double; stdcall;

        function SetTime(Time: double): HRESULT; stdcall;

        function CloneAnimationController(MaxNumMatrices: UINT; MaxNumAnimationSets: UINT; MaxNumTracks: UINT; MaxNumEvents: UINT; out ppAnimController: ID3DXAnimationController): HRESULT; stdcall;

        function GetMaxNumMatrices(): UINT; stdcall;

        function GetMaxNumEvents(): UINT; stdcall;

        function GetMaxNumAnimationSets(): UINT; stdcall;

        // Sequencing abilities
        function KeyTrackSpeed(Track: DWORD; NewSpeed: single; StartTime: double; Duration: double; Method: DWORD): HRESULT; stdcall;

        function KeyTrackWeight(Track: DWORD; NewWeight: single; StartTime: double; Duration: double; Method: DWORD): HRESULT; stdcall;

        function KeyTrackAnimTime(Track: DWORD; NewAnimTime: double; StartTime: double): HRESULT; stdcall;

        function KeyTrackEnable(Track: DWORD; NewEnable: boolean; StartTime: double): HRESULT; stdcall;

        // this functions sets the blend weight to be used to blend high and low priority tracks together.
        //  NOTE: this has no effect unless there are active animations on tracks for a given matrix that have both high and low results
        function GetPriorityBlend(): single; stdcall;

        function SetPriorityBlend(BlendWeight: single): HRESULT; stdcall;

        function KeyPriorityBlend(NewBlendWeight: single; StartTime: double; Duration: double; Method: DWORD): HRESULT; stdcall;

    end;




    //----------------------------------------------------------------------------
    // D3DXLoadMeshHierarchyFromX:
    // ---------------------------
    // Loads the first frame hierarchy in a .X file.

    // Parameters:
    //  Filename
    //      Name of the .X file
    //  MeshOptions
    //      Mesh creation options for meshes in the file (see d3dx9mesh.h)
    //  pD3DDevice
    //      D3D9 device on which meshes in the file are created in
    //  pAlloc
    //      Allocation interface used to allocate nodes of the frame hierarchy
    //  pUserDataLoader
    //      Application provided interface to allow loading of user data
    //  ppFrameHierarchy
    //      Returns root node pointer of the loaded frame hierarchy
    //  ppAnimController
    //      Returns pointer to an animation controller corresponding to animation
    //        in the .X file. This is created with default max tracks and events

//----------------------------------------------------------------------------
function D3DXLoadMeshHierarchyFromXA(
    {in} Filename: LPCSTR;
    {in} MeshOptions: DWORD;
    {in} pD3DDevice: IDirect3DDevice9;
    {in} pAlloc: ID3DXAllocateHierarchy;
    {in} pUserDataLoader: ID3DXLoadUserData;
    {out} out ppFrameHierarchy: LPD3DXFRAME;
    {out} out ppAnimController: ID3DXAnimationController): HRESULT; stdcall; external D3DX9_DLL;


function D3DXLoadMeshHierarchyFromXW(
    {in} Filename: LPCWSTR;
    {in} MeshOptions: DWORD;
    {in} pD3DDevice: IDirect3DDevice9;
    {in} pAlloc: ID3DXAllocateHierarchy;
    {in} pUserDataLoader: ID3DXLoadUserData;
    {out} out ppFrameHierarchy: LPD3DXFRAME;
    {out} out ppAnimController: ID3DXAnimationController): HRESULT; stdcall; external D3DX9_DLL;



function D3DXLoadMeshHierarchyFromXInMemory(
    {in} Memory: LPCVOID;
    {in} SizeOfMemory: DWORD;
    {in} MeshOptions: DWORD;
    {in} pD3DDevice: IDirect3DDevice9;
    {in} pAlloc: ID3DXAllocateHierarchy;
    {in} pUserDataLoader: ID3DXLoadUserData;
    {out} out ppFrameHierarchy: LPD3DXFRAME;
    {out} out ppAnimController: ID3DXAnimationController): HRESULT; stdcall; external D3DX9_DLL;


//----------------------------------------------------------------------------
// D3DXSaveMeshHierarchyToFile:
// ---------------------------
// Creates a .X file and saves the mesh hierarchy and corresponding animations
// in it

// Parameters:
//  Filename
//      Name of the .X file
//  XFormat
//      Format of the .X file (text or binary, compressed or not, etc)
//  pFrameRoot
//      Root node of the hierarchy to be saved
//  pAnimController
//      The animation mixer whose animation sets are to be stored
//  pUserDataSaver
//      Application provided interface to allow adding of user data to
//        data objects saved to .X file

//----------------------------------------------------------------------------
function D3DXSaveMeshHierarchyToFileA(
    {in} Filename: LPCSTR;
    {in} XFormat: DWORD;
    {in} pFrameRoot: LPD3DXFRAME;
    {in} pAnimMixer: ID3DXAnimationController;
    {in} pUserDataSaver: ID3DXSaveUserData): HRESULT; stdcall; external D3DX9_DLL;


function D3DXSaveMeshHierarchyToFileW(
    {in} Filename: LPCWSTR;
    {in} XFormat: DWORD;
    {in} pFrameRoot: LPD3DXFRAME;
    {in} pAnimMixer: ID3DXAnimationController;
    {in} pUserDataSaver: ID3DXSaveUserData): HRESULT; stdcall; external D3DX9_DLL;



//----------------------------------------------------------------------------
// D3DXFrameDestroy:
// -----------------
// Destroys the subtree of frames under the root, including the root

// Parameters:
//    pFrameRoot
//        Pointer to the root node
//  pAlloc
//      Allocation interface used to de-allocate nodes of the frame hierarchy

//----------------------------------------------------------------------------
function D3DXFrameDestroy(
    {in} pFrameRoot: LPD3DXFRAME;
    {in} pAlloc: ID3DXAllocateHierarchy): HRESULT; stdcall; external D3DX9_DLL;


//----------------------------------------------------------------------------
// D3DXFrameAppendChild:
// ---------------------
// Add a child frame to a frame

// Parameters:
//    pFrameParent
//        Pointer to the parent node
//  pFrameChild
//      Pointer to the child node

//----------------------------------------------------------------------------
function D3DXFrameAppendChild(
    {in} pFrameParent: LPD3DXFRAME;
    {in} pFrameChild: LPD3DXFRAME): HRESULT; stdcall; external D3DX9_DLL;


//----------------------------------------------------------------------------
// D3DXFrameFind:
// --------------
// Finds a frame with the given name.  Returns NULL if no frame found.

// Parameters:
//    pFrameRoot
//        Pointer to the root node
//  Name
//      Name of frame to find

//----------------------------------------------------------------------------
function D3DXFrameFind(
    {in} pFrameRoot: LPD3DXFRAME;
    {in} Name: LPCSTR): LPD3DXFRAME; stdcall; external D3DX9_DLL;


//----------------------------------------------------------------------------
// D3DXFrameRegisterNamedMatrices:
// --------------------------
// Finds all frames that have non-null names and registers each of those frame
// matrices to the given animation mixer

// Parameters:
//    pFrameRoot
//        Pointer to the root node
//    pAnimMixer
//        Pointer to the animation mixer where the matrices are registered

//----------------------------------------------------------------------------
function D3DXFrameRegisterNamedMatrices(
    {in} pFrameRoot: LPD3DXFRAME;
    {in} pAnimMixer: ID3DXAnimationController): HRESULT; stdcall; external D3DX9_DLL;


//----------------------------------------------------------------------------
// D3DXFrameNumNamedMatrices:
// --------------------------
// Counts number of frames in a subtree that have non-null names

// Parameters:
//    pFrameRoot
//        Pointer to the root node of the subtree
// Return Value:
//        Count of frames

//----------------------------------------------------------------------------
function D3DXFrameNumNamedMatrices(
    {in} pFrameRoot: LPD3DXFRAME): UINT; stdcall; external D3DX9_DLL;


//----------------------------------------------------------------------------
// D3DXFrameCalculateBoundingSphere:
// ---------------------------------
// Computes the bounding sphere of all the meshes in the frame hierarchy

// Parameters:
//    pFrameRoot
//        Pointer to the root node
//    pObjectCenter
//        Returns the center of the bounding sphere
//    pObjectRadius
//        Returns the radius of the bounding sphere

//----------------------------------------------------------------------------
function D3DXFrameCalculateBoundingSphere(
    {in} pFrameRoot: LPD3DXFRAME;
    {out} pObjectCenter: LPD3DXVECTOR3;
    {out}  pObjectRadius: Psingle): HRESULT; stdcall; external D3DX9_DLL;




//----------------------------------------------------------------------------
// D3DXCreateKeyFrameInterpolator:
// -------------------------------
// Creates a SRT key frame interpolator object from the given set of keys

// Parameters:
//    ScaleKeys
//        Array of scale key vectors
//    NumScaleKeys
//        Num elements in ScaleKeys array
//    RotationKeys
//        Array of rotation key quternions
//    NumRotationKeys
//        Num elements in RotationKeys array
//    TranslateKeys
//        Array of translation key vectors
//    NumTranslateKeys
//        Num elements in TranslateKeys array
//    ScaleInputTimeBy
//        All key times are scaled by this factor
//    ppNewInterpolator
//        Returns the keyframe interpolator interface

//----------------------------------------------------------------------------
function D3DXCreateKeyFrameInterpolator(
    {in} Name: LPCSTR; ScaleKeys: LPD3DXKEY_VECTOR3; NumScaleKeys: UINT; RotationKeys: LPD3DXKEY_QUATERNION; NumRotationKeys: UINT; TranslateKeys: LPD3DXKEY_VECTOR3; NumTranslateKeys: UINT; ScaleInputTimeBy: double;
    {out} out ppNewInterpolator: ID3DXKeyFrameInterpolator): HRESULT; stdcall; external D3DX9_DLL;


//----------------------------------------------------------------------------
// D3DXCreateAnimationSet:
// -----------------------
// Creates an animtions set interface given a set of interpolators

// Parameters:
//    Name
//        Name of the animation set
//    pInterpolators
//        Array of interpolators
//    NumInterpolators
//        Num elements in the pInterpolators array
//    ppAnimSet
//        Returns the animation set interface

//-----------------------------------------------------------------------------
function D3DXCreateAnimationSet(
    {in} Name: LPCSTR;
    {in array} ppInterpolators: LPD3DXINTERPOLATOR;
    {in} NumInterpolators: UINT;
    {out} out ppAnimSet: ID3DXAnimationSet): HRESULT; stdcall; external D3DX9_DLL;


//----------------------------------------------------------------------------
// D3DXCreateAnimationController:
// -------------------------
// Creates an animtion mixer object

// Parameters:
//    MaxNumMatrices
//        The upper limit for the number of matrices that can be animated by the
//        the object
//    MaxNumAnimationSets
//        The upper limit of the number of animation sets that can be played by
//        the object
//    MaxNumTracks
//        The upper limit of the number of animation sets that can be blended at
//        any time.
//    MaxNumEvents
//        The upper limit of the number of outstanding events that can be
//        scheduled at once.
//    ppAnimController
//        Returns the animation controller interface

//-----------------------------------------------------------------------------
function D3DXCreateAnimationController(
    {in} MaxNumMatrices: UINT;
    {in} MaxNumAnimationSets: UINT;
    {in} MaxNumTracks: UINT;
    {in} MaxNumEvents: UINT;
    {out} out ppAnimController: ID3DXAnimationController): HRESULT; stdcall; external D3DX9_DLL;




implementation

end.
