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
    Content:    D3DX mesh types and functions

   This unit consists of the following header files
   File name: d3dx9anim.h
   Header version: 9.29.1962.1

  ************************************************************************** }
unit DX12.D3DX9Anim;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D9,
    DX12.D3DX9Core,
    DX12.DXFile,
    DX12.D3DX9Mesh,
    DX12.D3DX9Math,
    DX12.D3DX9XOf;

    {$Z4}

const
    // {698CFB3F-9289-4d95-9A57-33A94B5A65F9}
    IID_ID3DXAnimationSet: TGUID = '{698CFB3F-9289-4D95-9A57-33A94B5A65F9}';


    // {FA4E8E3A-9786-407d-8B4C-5995893764AF}
    IID_ID3DXKeyframedAnimationSet: TGUID = '{FA4E8E3A-9786-407D-8B4C-5995893764AF}';


    // {6CC2480D-3808-4739-9F88-DE49FACD8D4C}
    IID_ID3DXCompressedAnimationSet: TGUID = '{6CC2480D-3808-4739-9F88-DE49FACD8D4C}';


    // {AC8948EC-F86D-43e2-96DE-31FC35F96D9E}
    IID_ID3DXAnimationController: TGUID = '{AC8948EC-F86D-43E2-96DE-31FC35F96D9E}';


type




    //----------------------------------------------------------------------------
    // D3DXMESHDATATYPE:
    // -----------------
    // This enum defines the type of mesh data present in a MeshData structure.
    //----------------------------------------------------------------------------
    _D3DXMESHDATATYPE = (
        D3DXMESHTYPE_MESH = $001, // Normal ID3DXMesh data
        D3DXMESHTYPE_PMESH = $002, // Progressive Mesh - ID3DXPMesh
        D3DXMESHTYPE_PATCHMESH = $003, // Patch Mesh - ID3DXPatchMesh
        D3DXMESHTYPE_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    TD3DXMESHDATATYPE = _D3DXMESHDATATYPE;
    PD3DXMESHDATATYPE = ^TD3DXMESHDATATYPE;


    //----------------------------------------------------------------------------
    // D3DXMESHDATA:
    // -------------
    // This struct encapsulates a the mesh data that can be present in a mesh
    // container.  The supported mesh types are pMesh, pPMesh, pPatchMesh.
    // The valid way to access this is determined by the Type enum.
    //----------------------------------------------------------------------------
    _D3DXMESHDATA = record
        MeshType: TD3DXMESHDATATYPE;
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
    // D3DXMESHCONTAINER:
    // ------------------
    // This struct encapsulates a mesh object in a transformation frame
    // hierarchy. The app can derive from this structure to add other app specific
    // data to this.
    //----------------------------------------------------------------------------
    PD3DXMESHCONTAINER = ^_D3DXMESHCONTAINER;

    _D3DXMESHCONTAINER = record
        Name: LPSTR;
        MeshData: TD3DXMESHDATA;
        pMaterials: LPD3DXMATERIAL;
        pEffects: LPD3DXEFFECTINSTANCE;
        NumMaterials: DWORD;
        pAdjacency: PDWORD;
        pSkinInfo: LPD3DXSKININFO;
        pNextMeshContainer: PD3DXMESHCONTAINER
    end;
    TD3DXMESHCONTAINER = _D3DXMESHCONTAINER;


    LPD3DXMESHCONTAINER = ^TD3DXMESHCONTAINER;

    //----------------------------------------------------------------------------
    // D3DXFRAME:
    // ----------
    // This struct is the encapsulates a transform frame in a transformation frame
    // hierarchy. The app can derive from this structure to add other app specific
    // data to this
    //----------------------------------------------------------------------------
    PD3DXFRAME = ^_D3DXFRAME;

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
    // ID3DXAllocateHierarchy:
    // -----------------------
    // This interface is implemented by the application to allocate/free frame and
    // mesh container objects. Methods on this are called during loading and
    // destroying frame hierarchies
    //----------------------------------------------------------------------------




    ID3DXAnimationSet = interface;
    LPD3DXANIMATIONSET = ^ID3DXAnimationSet;

    ID3DXKeyframedAnimationSet = interface;
    LPD3DXKEYFRAMEDANIMATIONSET = ^ID3DXKeyframedAnimationSet;

    ID3DXCompressedAnimationSet = interface;
    LPD3DXCOMPRESSEDANIMATIONSET = ^ID3DXCompressedAnimationSet;



    ID3DXAnimationController = interface;
    LPD3DXANIMATIONCONTROLLER = ^ID3DXAnimationController;



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
        //        Returns the created frame object

        //------------------------------------------------------------------------
        function CreateFrame(Name: LPCSTR; ppNewFrame: PD3DXFRAME): HRESULT; stdcall;

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
        function CreateMeshContainer(Name: LPCSTR; pMeshData: PD3DXMESHDATA; pMaterials: PD3DXMATERIAL; pEffectInstances: PD3DXEFFECTINSTANCE; NumMaterials: DWORD; pAdjacency: PDWORD;
            pSkinInfo: iD3DXSKININFO; out ppNewMeshContainer: PD3DXMESHCONTAINER): HRESULT; stdcall;

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

    LPD3DXALLOCATEHIERARCHY = ^ID3DXAllocateHierarchy;
    {$interfaces COM}



    //----------------------------------------------------------------------------
    // ID3DXLoadUserData:
    // ------------------
    // This interface is implemented by the application to load user data in a .X file
    // When user data is found, these callbacks will be used to allow the application
    // to load the data.
    //----------------------------------------------------------------------------



    {$interfaces corba}
    ID3DXLoadUserData = interface
        function LoadTopLevelData(pXofChildData: ID3DXFILEDATA): HRESULT; stdcall;

        function LoadFrameChildData(pFrame: LPD3DXFRAME; pXofChildData: ID3DXFILEDATA): HRESULT; stdcall;

        function LoadMeshChildData(pMeshContainer: LPD3DXMESHCONTAINER; pXofChildData: ID3DXFILEDATA): HRESULT; stdcall;

    end;

    LPD3DXLOADUSERDATA = ^ID3DXLoadUserData;

    {$interfaces COM}


    //----------------------------------------------------------------------------
    // ID3DXSaveUserData:
    // ------------------
    // This interface is implemented by the application to save user data in a .X file
    // The callbacks are called for all data saved.  The user can then add any
    // child data objects to the object provided to the callback.
    //----------------------------------------------------------------------------


    {$interfaces corba}
    ID3DXSaveUserData = interface
        function AddFrameChildData(pFrame: PD3DXFRAME; pXofSave: ID3DXFILESAVEOBJECT; pXofFrameData: ID3DXFILESAVEDATA): HRESULT; stdcall;

        function AddMeshChildData(pMeshContainer: PD3DXMESHCONTAINER; pXofSave: ID3DXFILESAVEOBJECT; pXofMeshData: ID3DXFILESAVEDATA): HRESULT; stdcall;

        // NOTE: this is called once per Save.  All top level objects should be added using the
        //    provided interface.  One call adds objects before the frame hierarchy, the other after
        function AddTopLevelDataObjectsPre(pXofSave: ID3DXFILESAVEOBJECT): HRESULT; stdcall;

        function AddTopLevelDataObjectsPost(pXofSave: ID3DXFILESAVEOBJECT): HRESULT; stdcall;

        // callbacks for the user to register and then save templates to the XFile
        function RegisterTemplates(pXFileApi: ID3DXFILE): HRESULT; stdcall;

        function SaveTemplates(pXofSave: ID3DXFILESAVEOBJECT): HRESULT; stdcall;

    end;

    LPD3DXSAVEUSERDATA = ^ID3DXSaveUserData;

    {$interfaces COM}



    //----------------------------------------------------------------------------
    // D3DXCALLBACK_SEARCH_FLAGS:
    // --------------------------
    // Flags that can be passed into ID3DXAnimationSet::GetCallback.
    //----------------------------------------------------------------------------
    _D3DXCALLBACK_SEARCH_FLAGS = (
        D3DXCALLBACK_SEARCH_EXCLUDING_INITIAL_POSITION = $01, // exclude callbacks at the initial position from the search
        D3DXCALLBACK_SEARCH_BEHIND_INITIAL_POSITION = $02, // reverse the callback search direction
        D3DXCALLBACK_SEARCH_FORCE_DWORD = $7fffffff);

    TD3DXCALLBACK_SEARCH_FLAGS = _D3DXCALLBACK_SEARCH_FLAGS;
    PD3DXCALLBACK_SEARCH_FLAGS = ^TD3DXCALLBACK_SEARCH_FLAGS;




    //----------------------------------------------------------------------------
    // ID3DXAnimationSet:
    // ------------------
    // This interface implements an animation set.
    //----------------------------------------------------------------------------


    ID3DXAnimationSet = interface(IUnknown)
        ['{698CFB3F-9289-4D95-9A57-33A94B5A65F9}']
        // Name
        function GetName(): LPCSTR; stdcall;

        // Period
        function GetPeriod(): double; stdcall;

        function GetPeriodicPosition(Position: double): double; stdcall;

        // Maps position into animation period
        // Animation names
        function GetNumAnimations(): UINT; stdcall;

        function GetAnimationNameByIndex(Index: UINT; ppName: LPCSTR): HRESULT; stdcall;

        function GetAnimationIndexByName(pName: LPCSTR; pIndex: PUINT): HRESULT; stdcall;

        // SRT
        function GetSRT(
        // Position mapped to period (use GetPeriodicPosition)
            PeriodicPosition: double;
        // Animation index
            Animation: UINT;
        // Returns the scale
            pScale: PD3DXVECTOR3;
        // Returns the rotation as a quaternion
            pRotation: PD3DXQUATERNION; pTranslation: PD3DXVECTOR3): HRESULT; stdcall;

        // Returns the translation
        // Callbacks
        function GetCallback(
        // Position from which to find callbacks
            Position: double;
        // Callback search flags
            Flags: DWORD;
        // Returns the position of the callback
            pCallbackPosition: PDOUBLE; ppCallbackData: LPVOID): HRESULT; stdcall;

    end;




    //----------------------------------------------------------------------------
    // D3DXPLAYBACK_TYPE:
    // ------------------
    // This enum defines the type of animation set loop modes.
    //----------------------------------------------------------------------------
    _D3DXPLAYBACK_TYPE = (
        D3DXPLAY_LOOP = 0,
        D3DXPLAY_ONCE = 1,
        D3DXPLAY_PINGPONG = 2,
        D3DXPLAY_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    TD3DXPLAYBACK_TYPE = _D3DXPLAYBACK_TYPE;
    PD3DXPLAYBACK_TYPE = ^TD3DXPLAYBACK_TYPE;



    //----------------------------------------------------------------------------
    // D3DXKEY_VECTOR3:
    // ----------------
    // This structure describes a vector key for use in keyframe animation.
    // It specifies a vector Value at a given Time. This is used for scale and
    // translation keys.
    //----------------------------------------------------------------------------
    _D3DXKEY_VECTOR3 = record
        Time: single;
        Value: TD3DXVECTOR3;
    end;
    TD3DXKEY_VECTOR3 = _D3DXKEY_VECTOR3;
    PD3DXKEY_VECTOR3 = ^TD3DXKEY_VECTOR3;

    LPD3DXKEY_VECTOR3 = ^TD3DXKEY_VECTOR3;


    //----------------------------------------------------------------------------
    // D3DXKEY_QUATERNION:
    // -------------------
    // This structure describes a quaternion key for use in keyframe animation.
    // It specifies a quaternion Value at a given Time. This is used for rotation
    // keys.
    //----------------------------------------------------------------------------
    _D3DXKEY_QUATERNION = record
        Time: single;
        Value: TD3DXQUATERNION;
    end;
    TD3DXKEY_QUATERNION = _D3DXKEY_QUATERNION;
    PD3DXKEY_QUATERNION = ^TD3DXKEY_QUATERNION;

    LPD3DXKEY_QUATERNION = ^TD3DXKEY_QUATERNION;


    //----------------------------------------------------------------------------
    // D3DXKEY_CALLBACK:
    // -----------------
    // This structure describes an callback key for use in keyframe animation.
    // It specifies a pointer to user data at a given Time.
    //----------------------------------------------------------------------------
    _D3DXKEY_CALLBACK = record
        Time: single;
        pCallbackData: LPVOID;
    end;
    TD3DXKEY_CALLBACK = _D3DXKEY_CALLBACK;
    PD3DXKEY_CALLBACK = ^TD3DXKEY_CALLBACK;

    LPD3DXKEY_CALLBACK = ^TD3DXKEY_CALLBACK;


    //----------------------------------------------------------------------------
    // D3DXCOMPRESSION_FLAGS:
    // ----------------------
    // Flags that can be passed into ID3DXKeyframedAnimationSet::Compress.
    //----------------------------------------------------------------------------
    _D3DXCOMPRESSION_FLAGS = (
        D3DXCOMPRESS_DEFAULT = $00,
        D3DXCOMPRESS_FORCE_DWORD = $7fffffff);

    TD3DXCOMPRESSION_FLAGS = _D3DXCOMPRESSION_FLAGS;
    PD3DXCOMPRESSION_FLAGS = ^TD3DXCOMPRESSION_FLAGS;



    //----------------------------------------------------------------------------
    // ID3DXKeyframedAnimationSet:
    // ---------------------------
    // This interface implements a compressable keyframed animation set.
    //----------------------------------------------------------------------------




    ID3DXKeyframedAnimationSet = interface(ID3DXAnimationSet)
        ['{FA4E8E3A-9786-407D-8B4C-5995893764AF}']
        // Playback
        function GetPlaybackType(): TD3DXPLAYBACK_TYPE; stdcall;

        function GetSourceTicksPerSecond(): double; stdcall;

        // Scale keys
        function GetNumScaleKeys(Animation: UINT): UINT; stdcall;

        function GetScaleKeys(Animation: UINT; pScaleKeys: LPD3DXKEY_VECTOR3): HRESULT; stdcall;

        function GetScaleKey(Animation: UINT; Key: UINT; pScaleKey: LPD3DXKEY_VECTOR3): HRESULT; stdcall;

        function SetScaleKey(Animation: UINT; Key: UINT; pScaleKey: LPD3DXKEY_VECTOR3): HRESULT; stdcall;

        // Rotation keys
        function GetNumRotationKeys(Animation: UINT): UINT; stdcall;

        function GetRotationKeys(Animation: UINT; pRotationKeys: LPD3DXKEY_QUATERNION): HRESULT; stdcall;

        function GetRotationKey(Animation: UINT; Key: UINT; pRotationKey: LPD3DXKEY_QUATERNION): HRESULT; stdcall;

        function SetRotationKey(Animation: UINT; Key: UINT; pRotationKey: LPD3DXKEY_QUATERNION): HRESULT; stdcall;

        // Translation keys
        function GetNumTranslationKeys(Animation: UINT): UINT; stdcall;

        function GetTranslationKeys(Animation: UINT; pTranslationKeys: LPD3DXKEY_VECTOR3): HRESULT; stdcall;

        function GetTranslationKey(Animation: UINT; Key: UINT; pTranslationKey: LPD3DXKEY_VECTOR3): HRESULT; stdcall;

        function SetTranslationKey(Animation: UINT; Key: UINT; pTranslationKey: LPD3DXKEY_VECTOR3): HRESULT; stdcall;

        // Callback keys
        function GetNumCallbackKeys(): UINT; stdcall;

        function GetCallbackKeys(pCallbackKeys: LPD3DXKEY_CALLBACK): HRESULT; stdcall;

        function GetCallbackKey(Key: UINT; pCallbackKey: LPD3DXKEY_CALLBACK): HRESULT; stdcall;

        function SetCallbackKey(Key: UINT; pCallbackKey: LPD3DXKEY_CALLBACK): HRESULT; stdcall;

        // Key removal methods. These are slow, and should not be used once the animation starts playing
        function UnregisterScaleKey(Animation: UINT; Key: UINT): HRESULT; stdcall;

        function UnregisterRotationKey(Animation: UINT; Key: UINT): HRESULT; stdcall;

        function UnregisterTranslationKey(Animation: UINT; Key: UINT): HRESULT; stdcall;

        // One-time animaton SRT keyframe registration
        function RegisterAnimationSRTKeys(
        // Animation name
            pName: LPCSTR;
        // Number of scale keys
            NumScaleKeys: UINT;
        // Number of rotation keys
            NumRotationKeys: UINT;
        // Number of translation keys
            NumTranslationKeys: UINT;
        // Array of scale keys
            pScaleKeys: PD3DXKEY_VECTOR3;
        // Array of rotation keys
            pRotationKeys: PD3DXKEY_QUATERNION;
        // Array of translation keys
            pTranslationKeys: PD3DXKEY_VECTOR3; pAnimationIndex: PDWORD): HRESULT; stdcall;

        // Returns the animation index
        // Compression
        function Compress(
        // Compression flags (use D3DXCOMPRESS_STRONG for better results)
            Flags: DWORD;
        // Compression loss ratio in the [0, 1] range
            Lossiness: single;
        // Frame hierarchy (optional)
            pHierarchy: LPD3DXFRAME; out ppCompressedData: ID3DXBUFFER): HRESULT; stdcall;

        // Returns the compressed animation set
        function UnregisterAnimation(Index: UINT): HRESULT; stdcall;

    end;



    //----------------------------------------------------------------------------
    // ID3DXCompressedAnimationSet:
    // ----------------------------
    // This interface implements a compressed keyframed animation set.
    //----------------------------------------------------------------------------



    ID3DXCompressedAnimationSet = interface(ID3DXAnimationSet)
        ['{6CC2480D-3808-4739-9F88-DE49FACD8D4C}']
        // Playback
        function GetPlaybackType(): TD3DXPLAYBACK_TYPE; stdcall;

        function GetSourceTicksPerSecond(): double; stdcall;

        // Scale keys
        function GetCompressedData(out ppCompressedData: ID3DXBUFFER): HRESULT; stdcall;

        // Callback keys
        function GetNumCallbackKeys(): UINT; stdcall;

        function GetCallbackKeys(pCallbackKeys: LPD3DXKEY_CALLBACK): HRESULT; stdcall;

    end;



    //----------------------------------------------------------------------------
    // D3DXPRIORITY_TYPE:
    // ------------------
    // This enum defines the type of priority group that a track can be assigned to.
    //----------------------------------------------------------------------------
    _D3DXPRIORITY_TYPE = (
        D3DXPRIORITY_LOW = 0, // This track should be blended with all low priority tracks before mixed with the high priority result
        D3DXPRIORITY_HIGH = 1, // This track should be blended with all high priority tracks before mixed with the low priority result
        D3DXPRIORITY_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    TD3DXPRIORITY_TYPE = _D3DXPRIORITY_TYPE;
    PD3DXPRIORITY_TYPE = ^TD3DXPRIORITY_TYPE;


    //----------------------------------------------------------------------------
    // D3DXTRACK_DESC:
    // ---------------
    // This structure describes the mixing information of an animation track.
    // The mixing information consists of the current position, speed, and blending
    // weight for the track.  The Flags field also specifies whether the track is
    // low or high priority.  Tracks with the same priority are blended together
    // and then the two resulting values are blended using the priority blend factor.
    // A track also has an animation set (stored separately) associated with it.
    //----------------------------------------------------------------------------
    _D3DXTRACK_DESC = record
        Priority: TD3DXPRIORITY_TYPE;
        Weight: single;
        Speed: single;
        Position: double;
        Enable: boolean;
    end;
    TD3DXTRACK_DESC = _D3DXTRACK_DESC;
    PD3DXTRACK_DESC = ^TD3DXTRACK_DESC;

    LPD3DXTRACK_DESC = ^TD3DXTRACK_DESC;

    //----------------------------------------------------------------------------
    // D3DXEVENT_TYPE:
    // ---------------
    // This enum defines the type of events keyable via the animation controller.
    //----------------------------------------------------------------------------
    _D3DXEVENT_TYPE = (
        D3DXEVENT_TRACKSPEED = 0,
        D3DXEVENT_TRACKWEIGHT = 1,
        D3DXEVENT_TRACKPOSITION = 2,
        D3DXEVENT_TRACKENABLE = 3,
        D3DXEVENT_PRIORITYBLEND = 4,
        D3DXEVENT_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    TD3DXEVENT_TYPE = _D3DXEVENT_TYPE;
    PD3DXEVENT_TYPE = ^TD3DXEVENT_TYPE;


    //----------------------------------------------------------------------------
    // D3DXTRANSITION_TYPE:
    // --------------------
    // This enum defines the type of transtion performed on a event that
    // transitions from one value to another.
    //----------------------------------------------------------------------------
    _D3DXTRANSITION_TYPE = (
        D3DXTRANSITION_LINEAR = $000, // Linear transition from one value to the next
        D3DXTRANSITION_EASEINEASEOUT = $001, // Ease-In Ease-Out spline transtion from one value to the next
        D3DXTRANSITION_FORCE_DWORD = $7fffffff(* force 32-bit size enum *));

    TD3DXTRANSITION_TYPE = _D3DXTRANSITION_TYPE;
    PD3DXTRANSITION_TYPE = ^TD3DXTRANSITION_TYPE;


    //----------------------------------------------------------------------------
    // D3DXEVENT_DESC:
    // ---------------
    // This structure describes a animation controller event.
    // It gives the event's type, track (if the event is a track event), global
    // start time, duration, transition method, and target value.
    //----------------------------------------------------------------------------
    _D3DXEVENT_DESC = record
        EventType: TD3DXEVENT_TYPE;
        Track: UINT;
        StartTime: double;
        Duration: double;
        Transition: TD3DXTRANSITION_TYPE;
        case integer of
            0: (
                Weight: single;
            );
            1: (
                Speed: single;
            );
            2: (
                Position: double;
            );
            3: (
                Enable: boolean;
            );
    end;
    TD3DXEVENT_DESC = _D3DXEVENT_DESC;
    PD3DXEVENT_DESC = ^TD3DXEVENT_DESC;

    LPD3DXEVENT_DESC = ^TD3DXEVENT_DESC;

    //----------------------------------------------------------------------------
    // D3DXEVENTHANDLE:
    // ----------------
    // Handle values used to efficiently reference animation controller events.
    //----------------------------------------------------------------------------
    TD3DXEVENTHANDLE = DWORD;
    PLPD3DXEVENTHANDLE = ^TD3DXEVENTHANDLE;



    //----------------------------------------------------------------------------
    // ID3DXAnimationCallbackHandler:
    // ------------------------------
    // This interface is intended to be implemented by the application, and can
    // be used to handle callbacks in animation sets generated when
    // ID3DXAnimationController::AdvanceTime() is called.
    //----------------------------------------------------------------------------


    {$interfaces corba}
    ID3DXAnimationCallbackHandler = interface
        //----------------------------------------------------------------------------
        // ID3DXAnimationCallbackHandler::HandleCallback:
        // ----------------------------------------------
        // This method gets called when a callback occurs for an animation set in one
        // of the tracks during the ID3DXAnimationController::AdvanceTime() call.

        // Parameters:
        //  Track
        //      Index of the track on which the callback occured.
        //  pCallbackData
        //      Pointer to user owned callback data.

        //----------------------------------------------------------------------------
        function HandleCallback(Track: UINT; pCallbackData: LPVOID): HRESULT; stdcall;

    end;

    LPD3DXANIMATIONCALLBACKHANDLER = ^ID3DXAnimationCallbackHandler;

    {$interfaces COM}



    //----------------------------------------------------------------------------
    // ID3DXAnimationController:
    // -------------------------
    // This interface implements the main animation functionality. It connects
    // animation sets with the transform frames that are being animated. Allows
    // mixing multiple animations for blended animations or for transistions
    // It adds also has methods to modify blending parameters over time to
    // enable smooth transistions and other effects.
    //----------------------------------------------------------------------------



    ID3DXAnimationController = interface(IUnknown)
        ['{AC8948EC-F86D-43E2-96DE-31FC35F96D9E}']
        // Max sizes
        function GetMaxNumAnimationOutputs(): UINT; stdcall;

        function GetMaxNumAnimationSets(): UINT; stdcall;

        function GetMaxNumTracks(): UINT; stdcall;

        function GetMaxNumEvents(): UINT; stdcall;

        // Animation output registration
        function RegisterAnimationOutput(pName: LPCSTR; pMatrix: PD3DXMATRIX; pScale: PD3DXVECTOR3; pRotation: PD3DXQUATERNION; pTranslation: PD3DXVECTOR3): HRESULT; stdcall;

        // Animation set registration
        function RegisterAnimationSet(pAnimSet: ID3DXANIMATIONSET): HRESULT; stdcall;

        function UnregisterAnimationSet(pAnimSet: iD3DXANIMATIONSET): HRESULT; stdcall;

        function GetNumAnimationSets(): UINT; stdcall;

        function GetAnimationSet(Index: UINT; out ppAnimationSet: ID3DXANIMATIONSET): HRESULT; stdcall;

        function GetAnimationSetByName(szName: LPCSTR; out ppAnimationSet: ID3DXANIMATIONSET): HRESULT; stdcall;

        // Global time
        function AdvanceTime(TimeDelta: double; pCallbackHandler: ID3DXANIMATIONCALLBACKHANDLER): HRESULT; stdcall;

        function ResetTime(): HRESULT; stdcall;

        function GetTime(): double; stdcall;

        // Tracks
        function SetTrackAnimationSet(Track: UINT; pAnimSet: ID3DXANIMATIONSET): HRESULT; stdcall;

        function GetTrackAnimationSet(Track: UINT; out ppAnimSet: ID3DXANIMATIONSET): HRESULT; stdcall;

        function SetTrackPriority(Track: UINT; Priority: TD3DXPRIORITY_TYPE): HRESULT; stdcall;

        function SetTrackSpeed(Track: UINT; Speed: single): HRESULT; stdcall;

        function SetTrackWeight(Track: UINT; Weight: single): HRESULT; stdcall;

        function SetTrackPosition(Track: UINT; Position: double): HRESULT; stdcall;

        function SetTrackEnable(Track: UINT; Enable: boolean): HRESULT; stdcall;

        function SetTrackDesc(Track: UINT; pDesc: LPD3DXTRACK_DESC): HRESULT; stdcall;

        function GetTrackDesc(Track: UINT; pDesc: LPD3DXTRACK_DESC): HRESULT; stdcall;

        // Priority blending
        function SetPriorityBlend(BlendWeight: single): HRESULT; stdcall;

        function GetPriorityBlend(): single; stdcall;

        // Event keying
        function KeyTrackSpeed(Track: UINT; NewSpeed: single; StartTime: double; Duration: double; Transition: TD3DXTRANSITION_TYPE): TD3DXEVENTHANDLE; stdcall;

        function KeyTrackWeight(Track: UINT; NewWeight: single; StartTime: double; Duration: double; Transition: TD3DXTRANSITION_TYPE): TD3DXEVENTHANDLE; stdcall;

        function KeyTrackPosition(Track: UINT; NewPosition: double; StartTime: double): TD3DXEVENTHANDLE; stdcall;

        function KeyTrackEnable(Track: UINT; NewEnable: boolean; StartTime: double): TD3DXEVENTHANDLE; stdcall;

        function KeyPriorityBlend(NewBlendWeight: single; StartTime: double; Duration: double; Transition: TD3DXTRANSITION_TYPE): TD3DXEVENTHANDLE; stdcall;

        // Event unkeying
        function UnkeyEvent(hEvent: TD3DXEVENTHANDLE): HRESULT; stdcall;

        function UnkeyAllTrackEvents(Track: UINT): HRESULT; stdcall;

        function UnkeyAllPriorityBlends(): HRESULT; stdcall;

        // Event enumeration
        function GetCurrentTrackEvent(Track: UINT; EventType: TD3DXEVENT_TYPE): TD3DXEVENTHANDLE; stdcall;

        function GetCurrentPriorityBlend(): TD3DXEVENTHANDLE; stdcall;

        function GetUpcomingTrackEvent(Track: UINT; hEvent: TD3DXEVENTHANDLE): TD3DXEVENTHANDLE; stdcall;

        function GetUpcomingPriorityBlend(hEvent: TD3DXEVENTHANDLE): TD3DXEVENTHANDLE; stdcall;

        function ValidateEvent(hEvent: TD3DXEVENTHANDLE): HRESULT; stdcall;

        function GetEventDesc(hEvent: TD3DXEVENTHANDLE; pDesc: LPD3DXEVENT_DESC): HRESULT; stdcall;

        // Cloning
        function CloneAnimationController(MaxNumAnimationOutputs: UINT; MaxNumAnimationSets: UINT; MaxNumTracks: UINT; MaxNumEvents: UINT; out ppAnimController: ID3DXANIMATIONCONTROLLER): HRESULT; stdcall;

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
function D3DXLoadMeshHierarchyFromXA(Filename: LPCSTR; MeshOptions: DWORD; pD3DDevice: IDIRECT3DDEVICE9; pAlloc: ID3DXALLOCATEHIERARCHY; pUserDataLoader: ID3DXLOADUSERDATA; out ppFrameHierarchy: LPD3DXFRAME;
    out ppAnimController: ID3DXANIMATIONCONTROLLER): HRESULT; stdcall; external D3DX9_DLL;



function D3DXLoadMeshHierarchyFromXW(Filename: LPCWSTR; MeshOptions: DWORD; pD3DDevice: IDIRECT3DDEVICE9; pAlloc: ID3DXALLOCATEHIERARCHY; pUserDataLoader: ID3DXLOADUSERDATA;
    out ppFrameHierarchy: LPD3DXFRAME; out ppAnimController: ID3DXANIMATIONCONTROLLER): HRESULT; stdcall; external D3DX9_DLL;




function D3DXLoadMeshHierarchyFromXInMemory(Memory: LPCVOID; SizeOfMemory: DWORD; MeshOptions: DWORD; pD3DDevice: IDIRECT3DDEVICE9; pAlloc: ID3DXALLOCATEHIERARCHY; pUserDataLoader: ID3DXLOADUSERDATA;
    out ppFrameHierarchy: LPD3DXFRAME; out ppAnimController: ID3DXANIMATIONCONTROLLER): HRESULT; stdcall; external D3DX9_DLL;



//----------------------------------------------------------------------------
// D3DXSaveMeshHierarchyToFile:
// ----------------------------
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
//      The animation controller whose animation sets are to be stored
//  pUserDataSaver
//      Application provided interface to allow adding of user data to
//        data objects saved to .X file

//----------------------------------------------------------------------------
function D3DXSaveMeshHierarchyToFileA(Filename: LPCSTR; XFormat: DWORD; pFrameRoot: PD3DXFRAME; pAnimcontroller: ID3DXANIMATIONCONTROLLER; pUserDataSaver: ID3DXSAVEUSERDATA): HRESULT; stdcall; external D3DX9_DLL;



function D3DXSaveMeshHierarchyToFileW(Filename: LPCWSTR; XFormat: DWORD; pFrameRoot: PD3DXFRAME; pAnimController: ID3DXANIMATIONCONTROLLER; pUserDataSaver: ID3DXSAVEUSERDATA): HRESULT; stdcall; external D3DX9_DLL;




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
function D3DXFrameDestroy(pFrameRoot: LPD3DXFRAME; pAlloc: ID3DXALLOCATEHIERARCHY): HRESULT; stdcall; external D3DX9_DLL;



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
function D3DXFrameAppendChild(pFrameParent: LPD3DXFRAME; pFrameChild: PD3DXFRAME): HRESULT; stdcall; external D3DX9_DLL;



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
function D3DXFrameFind(pFrameRoot: PD3DXFRAME; Name: LPCSTR): LPD3DXFRAME; stdcall; external D3DX9_DLL;



//----------------------------------------------------------------------------
// D3DXFrameRegisterNamedMatrices:
// -------------------------------
// Finds all frames that have non-null names and registers each of those frame
// matrices to the given animation controller

// Parameters:
//    pFrameRoot
//        Pointer to the root node
//    pAnimController
//        Pointer to the animation controller where the matrices are registered

//----------------------------------------------------------------------------
function D3DXFrameRegisterNamedMatrices(pFrameRoot: LPD3DXFRAME; pAnimController: ID3DXANIMATIONCONTROLLER): HRESULT; stdcall; external D3DX9_DLL;



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
function D3DXFrameNumNamedMatrices(pFrameRoot: PD3DXFRAME): UINT; stdcall; external D3DX9_DLL;



//----------------------------------------------------------------------------
// D3DXFrameCalculateBoundingSphere:
// ---------------------------------
// Computes the bounding sphere of all the meshes in the frame hierarchy.

// Parameters:
//    pFrameRoot
//        Pointer to the root node
//    pObjectCenter
//        Returns the center of the bounding sphere
//    pObjectRadius
//        Returns the radius of the bounding sphere

//----------------------------------------------------------------------------
function D3DXFrameCalculateBoundingSphere(pFrameRoot: PD3DXFRAME; pObjectCenter: LPD3DXVECTOR3; pObjectRadius: Psingle): HRESULT; stdcall; external D3DX9_DLL;




//----------------------------------------------------------------------------
// D3DXCreateKeyframedAnimationSet:
// --------------------------------
// This function creates a compressable keyframed animations set interface.

// Parameters:
//  pName
//      Name of the animation set
//  TicksPerSecond
//      Number of keyframe ticks that elapse per second
//  Playback
//      Playback mode of keyframe looping
//  NumAnimations
//      Number of SRT animations
//  NumCallbackKeys
//      Number of callback keys
//  pCallbackKeys
//      Array of callback keys
//  ppAnimationSet
//      Returns the animation set interface

//-----------------------------------------------------------------------------
function D3DXCreateKeyframedAnimationSet(pName: LPCSTR; TicksPerSecond: double; Playback: TD3DXPLAYBACK_TYPE; NumAnimations: UINT; NumCallbackKeys: UINT; pCallbackKeys: PD3DXKEY_CALLBACK;
    out ppAnimationSet: ID3DXKEYFRAMEDANIMATIONSET): HRESULT; stdcall; external D3DX9_DLL;




//----------------------------------------------------------------------------
// D3DXCreateCompressedAnimationSet:
// --------------------------------
// This function creates a compressed animations set interface from
// compressed data.

// Parameters:
//  pName
//      Name of the animation set
//  TicksPerSecond
//      Number of keyframe ticks that elapse per second
//  Playback
//      Playback mode of keyframe looping
//  pCompressedData
//      Compressed animation SRT data
//  NumCallbackKeys
//      Number of callback keys
//  pCallbackKeys
//      Array of callback keys
//  ppAnimationSet
//      Returns the animation set interface

//-----------------------------------------------------------------------------
function D3DXCreateCompressedAnimationSet(pName: LPCSTR; TicksPerSecond: double; Playback: TD3DXPLAYBACK_TYPE; pCompressedData: ID3DXBUFFER; NumCallbackKeys: UINT; pCallbackKeys: PD3DXKEY_CALLBACK;
    out ppAnimationSet: ID3DXCOMPRESSEDANIMATIONSET): HRESULT; stdcall; external D3DX9_DLL;




//----------------------------------------------------------------------------
// D3DXCreateAnimationController:
// ------------------------------
// This function creates an animation controller object.

// Parameters:
//  MaxNumMatrices
//      Maximum number of matrices that can be animated
//  MaxNumAnimationSets
//      Maximum number of animation sets that can be played
//  MaxNumTracks
//      Maximum number of animation sets that can be blended
//  MaxNumEvents
//      Maximum number of outstanding events that can be scheduled at any given time
//  ppAnimController
//      Returns the animation controller interface

//-----------------------------------------------------------------------------
function D3DXCreateAnimationController(MaxNumMatrices: UINT; MaxNumAnimationSets: UINT; MaxNumTracks: UINT; MaxNumEvents: UINT; out ppAnimController: ID3DXANIMATIONCONTROLLER): HRESULT; stdcall; external D3DX9_DLL;




implementation

end.
