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
   this ALWAYS GENERATED file contains the definitions for the interfaces

   This unit consists of the following header files
   File name: Presentation.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.Presentation;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.DXGICommon,
    DX12.DXGI1_2,
    DX12.PresentationTypes;

    {$Z4}

const
    Dcomp_dll = 'Dcomp.dll';


    IID_IPresentationBuffer: TGUID = '{2E217D3A-5ABB-4138-9A13-A775593C89CA}';
    IID_IPresentationContent: TGUID = '{5668BB79-3D8E-415C-B215-F38020F2D252}';
    IID_IPresentationSurface: TGUID = '{956710FB-EA40-4EBA-A3EB-4375A0EB4EDC}';
    IID_IPresentationSurface2: TGUID = '{95609569-C5F0-47F9-8804-5345F2E2767E}';
    IID_IPresentStatistics: TGUID = '{B44B8BDA-7282-495D-9DD7-CEADD8B4BB86}';
    IID_IPresentationManager: TGUID = '{FB562F82-6292-470A-88B1-843661E7F20C}';
    IID_IPresentationFactory: TGUID = '{8FB37B58-1D74-4F64-A49C-1F97A80A2EC0}';
    IID_IPresentationFactory_SupportHdrAware: TGUID = '{2BD0B885-A16F-4BD9-A59A-D073E069D416}';
    IID_IPresentStatusPresentStatistics: TGUID = '{C9ED2A41-79CB-435E-964E-C8553055420C}';
    IID_ICompositionFramePresentStatistics: TGUID = '{AB41D127-C101-4C0A-911D-F9F2E9D08E64}';
    IID_IIndependentFlipFramePresentStatistics: TGUID = '{8C93BE27-AD94-4DA0-8FD4-2413132D124E}';

type
    REFIID = ^TGUID;

    (* Forward Declarations *)


    IPresentationBuffer = interface;


    IPresentationContent = interface;


    IPresentationSurface = interface;


    IPresentationSurface2 = interface;


    IPresentStatistics = interface;


    IPresentationManager = interface;


    IPresentationFactory = interface;


    IPresentationFactory_SupportHdrAware = interface;


    IPresentStatusPresentStatistics = interface;


    ICompositionFramePresentStatistics = interface;


    IIndependentFlipFramePresentStatistics = interface;


    IPresentationBuffer = interface(IUnknown)
        ['{2E217D3A-5ABB-4138-9A13-A775593C89CA}']
        function GetAvailableEvent(availableEventHandle: PHANDLE): HRESULT; stdcall;

        function IsAvailable(isAvailable: Pboolean): HRESULT; stdcall;

    end;


    IPresentationContent = interface(IUnknown)
        ['{5668BB79-3D8E-415C-B215-F38020F2D252}']
        procedure SetTag(tag: UINT_PTR); stdcall;

    end;


    IPresentationSurface = interface(IPresentationContent)
        ['{956710FB-EA40-4EBA-A3EB-4375A0EB4EDC}']
        function SetBuffer(presentationBuffer: IPresentationBuffer): HRESULT; stdcall;

        function SetColorSpace(colorSpace: TDXGI_COLOR_SPACE_TYPE): HRESULT; stdcall;

        function SetAlphaMode(alphaMode: TDXGI_ALPHA_MODE): HRESULT; stdcall;

        function SetSourceRect(sourceRect: PRECT): HRESULT; stdcall;

        function SetTransform(transform: PPresentationTransform): HRESULT; stdcall;

        function RestrictToOutput(output: IUnknown): HRESULT; stdcall;

        function SetDisableReadback(Value: boolean): HRESULT; stdcall;

        function SetLetterboxingMargins(leftLetterboxSize: single; topLetterboxSize: single; rightLetterboxSize: single; bottomLetterboxSize: single): HRESULT; stdcall;

    end;


    IPresentationSurface2 = interface(IPresentationSurface)
        ['{95609569-C5F0-47F9-8804-5345F2E2767E}']
        procedure SetIsHdrContent(isHdrContent: boolean); stdcall;

    end;


    IPresentStatistics = interface(IUnknown)
        ['{B44B8BDA-7282-495D-9DD7-CEADD8B4BB86}']
        function GetPresentId(): uint64; stdcall;

        function GetKind(): TPresentStatisticsKind; stdcall;

    end;


    IPresentationManager = interface(IUnknown)
        ['{FB562F82-6292-470A-88B1-843661E7F20C}']
        function AddBufferFromResource(resource: IUnknown; out presentationBuffer: IPresentationBuffer): HRESULT; stdcall;

        function CreatePresentationSurface(compositionSurfaceHandle: HANDLE; out presentationSurface: IPresentationSurface): HRESULT; stdcall;

        function GetNextPresentId(): uint64; stdcall;

        function SetTargetTime(targetTime: TSystemInterruptTime): HRESULT; stdcall;

        function SetPreferredPresentDuration(preferredDuration: TSystemInterruptTime; deviationTolerance: TSystemInterruptTime): HRESULT; stdcall;

        function ForceVSyncInterrupt(forceVsyncInterrupt: boolean): HRESULT; stdcall;

        function Present(): HRESULT; stdcall;

        function GetPresentRetiringFence(riid: REFIID; out fence): HRESULT; stdcall;

        function CancelPresentsFrom(presentIdToCancelFrom: uint64): HRESULT; stdcall;

        function GetLostEvent(lostEventHandle: PHANDLE): HRESULT; stdcall;

        function GetPresentStatisticsAvailableEvent(presentStatisticsAvailableEventHandle: PHANDLE): HRESULT; stdcall;

        function EnablePresentStatisticsKind(presentStatisticsKind: TPresentStatisticsKind; Enabled: boolean): HRESULT; stdcall;

        function GetNextPresentStatistics(out nextPresentStatistics: IPresentStatistics): HRESULT; stdcall;

    end;


    IPresentationFactory = interface(IUnknown)
        ['{8FB37B58-1D74-4F64-A49C-1F97A80A2EC0}']
        function IsPresentationSupported(): boolean; stdcall;

        function IsPresentationSupportedWithIndependentFlip(): boolean; stdcall;

        function CreatePresentationManager(out ppPresentationManager: IPresentationManager): HRESULT; stdcall;

    end;


    IPresentationFactory_SupportHdrAware = interface(IUnknown)
        ['{2BD0B885-A16F-4BD9-A59A-D073E069D416}']
    end;


    TPresentStatus = (
        PresentStatus_Queued = 0,
        PresentStatus_Skipped = 1,
        PresentStatus_Canceled = 2);

    PPresentStatus = ^TPresentStatus;


    IPresentStatusPresentStatistics = interface(IPresentStatistics)
        ['{C9ED2A41-79CB-435E-964E-C8553055420C}']
        function GetCompositionFrameId(): TCompositionFrameId; stdcall;

        function GetPresentStatus(): TPresentStatus; stdcall;

    end;


    TCompositionFrameInstanceKind = (
        CompositionFrameInstanceKind_ComposedOnScreen = 0,
        CompositionFrameInstanceKind_ScanoutOnScreen = 1,
        CompositionFrameInstanceKind_ComposedToIntermediate = 2);

    PCompositionFrameInstanceKind = ^TCompositionFrameInstanceKind;


    TCompositionFrameDisplayInstance = record
        displayAdapterLUID: TLUID;
        displayVidPnSourceId: UINT;
        displayUniqueId: UINT;
        renderAdapterLUID: TLUID;
        instanceKind: TCompositionFrameInstanceKind;
        finalTransform: TPresentationTransform;
        requiredCrossAdapterCopy: boolean;
        colorSpace: TDXGI_COLOR_SPACE_TYPE;
    end;
    PCompositionFrameDisplayInstance = ^TCompositionFrameDisplayInstance;


    ICompositionFramePresentStatistics = interface(IPresentStatistics)
        ['{AB41D127-C101-4C0A-911D-F9F2E9D08E64}']
        function GetContentTag(): UINT_PTR; stdcall;

        function GetCompositionFrameId(): TCompositionFrameId; stdcall;

        procedure GetDisplayInstanceArray(displayInstanceArrayCount: PUINT; out displayInstanceArray: PCompositionFrameDisplayInstance); stdcall;

    end;


    IIndependentFlipFramePresentStatistics = interface(IPresentStatistics)
        ['{8C93BE27-AD94-4DA0-8FD4-2413132D124E}']
        function GetOutputAdapterLUID(): TLUID; stdcall;

        function GetOutputVidPnSourceId(): UINT; stdcall;

        function GetContentTag(): UINT_PTR; stdcall;

        function GetDisplayedTime(): TSystemInterruptTime; stdcall;

        function GetPresentDuration(): TSystemInterruptTime; stdcall;

    end;


    // Main entrypoint for creating a presentation factory

function CreatePresentationFactory(
    {_In_ } d3dDevice: IUnknown;
    {_In_ } riid: REFIID;
    {_Outptr_ }  out presentationFactory): HRESULT; stdcall; external Dcomp_dll;


implementation

end.
