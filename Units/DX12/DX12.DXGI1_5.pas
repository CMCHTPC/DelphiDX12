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
   File name: dxgi1_5.h 
   Header version: 10.0.26100.6584
   
  ************************************************************************** }
unit DX12.DXGI1_5;

{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.DXGIFormat,
    DX12.DXGI,
    DX12.DXGI1_2,
    DX12.DXGI1_3,
    DX12.DXGI1_4;

    {$Z4}

const


    IID_IDXGIOutput5: TGUID = '{80A07424-AB52-42EB-833C-0C42FD282D98}';
    IID_IDXGISwapChain4: TGUID = '{3D585D5A-BD4A-489E-B1F4-3DBCB6452FFB}';
    IID_IDXGIDevice4: TGUID = '{95B4F95F-D8DA-4CA4-9EE6-3B76D5968A10}';
    IID_IDXGIFactory5: TGUID = '{7632E1F5-EE65-4DCA-87FD-84CD75F8838D}';




type


    IDXGIOutput5 = interface;




    IDXGISwapChain4 = interface;




    IDXGIDevice4 = interface;




    IDXGIFactory5 = interface;




    TDXGI_OUTDUPL_FLAG = (
        DXGI_OUTDUPL_COMPOSITED_UI_CAPTURE_ONLY = 1
        );




    PDXGI_OUTDUPL_FLAG = ^TDXGI_OUTDUPL_FLAG;

    IDXGIOutput5 = interface(IDXGIOutput4)
        ['{80A07424-AB52-42EB-833C-0C42FD282D98}']
        function DuplicateOutput1(
        {_In_} pDevice: IUnknown; Flags: UINT;
        {_In_} SupportedFormatsCount: UINT;
        {_In_reads_(SupportedFormatsCount)} pSupportedFormats: PDXGI_FORMAT;
        {_COM_Outptr_} out ppOutputDuplication: IDXGIOutputDuplication): HRESULT; stdcall;

    end;




    TDXGI_HDR_METADATA_TYPE = (
        DXGI_HDR_METADATA_TYPE_NONE = 0,
        DXGI_HDR_METADATA_TYPE_HDR10 = 1,
        DXGI_HDR_METADATA_TYPE_HDR10PLUS = 2
        );


    PDXGI_HDR_METADATA_TYPE = ^TDXGI_HDR_METADATA_TYPE;

    TDXGI_HDR_METADATA_HDR10 = record
        RedPrimary: array [0..1] of uint16;
        GreenPrimary: array [0..1] of uint16;
        BluePrimary: array [0..1] of uint16;
        WhitePoint: array [0..1] of uint16;
        MaxMasteringLuminance: UINT;
        MinMasteringLuminance: UINT;
        MaxContentLightLevel: uint16;
        MaxFrameAverageLightLevel: uint16;
    end;


    PDXGI_HDR_METADATA_HDR10 = ^TDXGI_HDR_METADATA_HDR10;

    TDXGI_HDR_METADATA_HDR10PLUS = record
        Data: array [0..71] of TBYTE;
    end;




    PDXGI_HDR_METADATA_HDR10PLUS = ^TDXGI_HDR_METADATA_HDR10PLUS;

    IDXGISwapChain4 = interface(IDXGISwapChain3)
        ['{3D585D5A-BD4A-489E-B1F4-3DBCB6452FFB}']
        function SetHDRMetaData(
        {_In_} _Type: TDXGI_HDR_METADATA_TYPE;
        {_In_} Size: UINT;
        {_In_reads_opt_(Size)} pMetaData: pointer): HRESULT; stdcall;

    end;




    TDXGI_OFFER_RESOURCE_FLAGS = (
        DXGI_OFFER_RESOURCE_FLAG_ALLOW_DECOMMIT = $1
        );


    PDXGI_OFFER_RESOURCE_FLAGS = ^TDXGI_OFFER_RESOURCE_FLAGS;

    TDXGI_RECLAIM_RESOURCE_RESULTS = (
        DXGI_RECLAIM_RESOURCE_RESULT_OK = 0,
        DXGI_RECLAIM_RESOURCE_RESULT_DISCARDED = 1,
        DXGI_RECLAIM_RESOURCE_RESULT_NOT_COMMITTED = 2
        );
    PDXGI_RECLAIM_RESOURCE_RESULTS = ^TDXGI_RECLAIM_RESOURCE_RESULTS;

    IDXGIDevice4 = interface(IDXGIDevice3)
        ['{95B4F95F-D8DA-4CA4-9EE6-3B76D5968A10}']
        function OfferResources1(
        {_In_} NumResources: UINT;
        {_In_reads_(NumResources)} ppResources: PIDXGIResource;
        {_In_} Priority: TDXGI_OFFER_RESOURCE_PRIORITY;
        {_In_} Flags: UINT): HRESULT; stdcall;

        function ReclaimResources1(
        {_In_} NumResources: UINT;
        {_In_reads_(NumResources)} ppResources: PIDXGIResource;
        {_Out_writes_all_(NumResources)} pResults: PDXGI_RECLAIM_RESOURCE_RESULTS): HRESULT; stdcall;

    end;




    TDXGI_FEATURE = (
        DXGI_FEATURE_PRESENT_ALLOW_TEARING = 0
        );




    PDXGI_FEATURE = ^TDXGI_FEATURE;

    IDXGIFactory5 = interface(IDXGIFactory4)
        ['{7632e1f5-ee65-4dca-87fd-84cd75f8838d}']
        function CheckFeatureSupport(Feature: TDXGI_FEATURE;
        {_Inout_updates_bytes_(FeatureSupportDataSize)} pFeatureSupportData: pointer; FeatureSupportDataSize: UINT): HRESULT; stdcall;

    end;




implementation


end.
