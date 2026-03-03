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

   Copyright (c) Microsoft Corporation
   Licensed under the MIT license
   DXCore Interface

   This unit consists of the following header files
   File name: d3dx12_check_feature_support.h
   Header version: SDK 1.717.1-preview  2025 12 28

  ************************************************************************** }
unit DX12.D3DX12_Check_Feature_Support;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D12,
    DX12.D3DCommon,
    DX12.DXGIFormat,
    DX12.DXGIType,
    CStdVector;

    {$I DX12.DX12SDKVersion.inc}
type


    TProtectedResourceSessionTypesLocal = record
        FeatureData: TD3D12_FEATURE_DATA_PROTECTED_RESOURCE_SESSION_TYPES;
        TypeVec: specialize TCStdVector<TGUID>;
    end;


    //================================================================================================
    // D3DX12 Check Feature Support
    //================================================================================================


    { TD3DX12FeatureSupport }

    TD3DX12FeatureSupport = class(TObject)
    private
        // Member data
        // Pointer to the underlying device
        m_pDevice: ID3D12Device;

        // Stores the error code from initialization
        m_hStatus: HRESULT;

        // Feature support data structs
        m_dOptions: TD3D12_FEATURE_DATA_D3D12_OPTIONS;
        m_eMaxFeatureLevel: TD3D_FEATURE_LEVEL;
        m_dGPUVASupport: TD3D12_FEATURE_DATA_GPU_VIRTUAL_ADDRESS_SUPPORT;
        m_dShaderModel: TD3D12_FEATURE_DATA_SHADER_MODEL;
        m_dOptions1: TD3D12_FEATURE_DATA_D3D12_OPTIONS1;
        m_dProtectedResourceSessionSupport: specialize TCStdVector<TD3D12_FEATURE_DATA_PROTECTED_RESOURCE_SESSION_SUPPORT>;
        m_dRootSignature: TD3D12_FEATURE_DATA_ROOT_SIGNATURE;
        m_dArchitecture1: specialize TCStdVector<TD3D12_FEATURE_DATA_ARCHITECTURE1>;
        m_dOptions2: TD3D12_FEATURE_DATA_D3D12_OPTIONS2;
        m_dShaderCache: TD3D12_FEATURE_DATA_SHADER_CACHE;
        m_dCommandQueuePriority: TD3D12_FEATURE_DATA_COMMAND_QUEUE_PRIORITY;
        m_dOptions3: TD3D12_FEATURE_DATA_D3D12_OPTIONS3;
        m_dExistingHeaps: TD3D12_FEATURE_DATA_EXISTING_HEAPS;
        m_dOptions4: TD3D12_FEATURE_DATA_D3D12_OPTIONS4;
        m_dSerialization: specialize TCStdVector<TD3D12_FEATURE_DATA_SERIALIZATION>; // Cat2 NodeIndex
        m_dCrossNode: TD3D12_FEATURE_DATA_CROSS_NODE;
        m_dOptions5: TD3D12_FEATURE_DATA_D3D12_OPTIONS5;
        {$IFDEF D3D12_SDK_VERSION_4}
        m_dDisplayable: TD3D12_FEATURE_DATA_DISPLAYABLE;
        {$ENDIF}
        m_dOptions6: TD3D12_FEATURE_DATA_D3D12_OPTIONS6;
        m_dOptions7: TD3D12_FEATURE_DATA_D3D12_OPTIONS7;
        m_dProtectedResourceSessionTypeCount: specialize TCStdVector<TD3D12_FEATURE_DATA_PROTECTED_RESOURCE_SESSION_TYPE_COUNT>; // Cat2 NodeIndex
        m_dProtectedResourceSessionTypes: specialize TCStdVector<TProtectedResourceSessionTypesLocal>; // Cat3
        {$IFDEF D3D12_SDK_VERSION_3}
        m_dOptions8: TD3D12_FEATURE_DATA_D3D12_OPTIONS8;
        m_dOptions9: TD3D12_FEATURE_DATA_D3D12_OPTIONS9;
        {$ENDIF}
        {$IFDEF D3D12_SDK_VERSION_4}
        m_dOptions10: TD3D12_FEATURE_DATA_D3D12_OPTIONS10;
        m_dOptions11: TD3D12_FEATURE_DATA_D3D12_OPTIONS11;
        {$ENDIF}
        {$IFDEF D3D12_SDK_VERSION_600}
        m_dOptions12: TD3D12_FEATURE_DATA_D3D12_OPTIONS12;
        {$ENDIF}
        {$IFDEF D3D12_SDK_VERSION_602}
        m_dOptions13: TD3D12_FEATURE_DATA_D3D12_OPTIONS13;
        {$ENDIF}
        {$IFDEF D3D12_SDK_VERSION_606}
        m_dOptions14: TD3D12_FEATURE_DATA_D3D12_OPTIONS14;
        m_dOptions15: TD3D12_FEATURE_DATA_D3D12_OPTIONS15;
        {$ENDIF}
        {$IFDEF D3D12_SDK_VERSION_608}
        m_dOptions16: TD3D12_FEATURE_DATA_D3D12_OPTIONS16;
        {$ENDIF}
        {$IFDEF D3D12_SDK_VERSION_609}
        m_dOptions17: TD3D12_FEATURE_DATA_D3D12_OPTIONS17;
        {$ENDIF}
        {$IFDEF D3D12_SDK_VERSION_609}
        m_dOptions18: TD3D12_FEATURE_DATA_D3D12_OPTIONS18;
        {$ENDIF}
        {$IFDEF D3D12_SDK_VERSION_610}
        m_dOptions19: TD3D12_FEATURE_DATA_D3D12_OPTIONS19;
        {$ENDIF}
        {$IFDEF D3D12_SDK_VERSION_611}
        m_dOptions20: TD3D12_FEATURE_DATA_D3D12_OPTIONS20;
        {$ENDIF}
        {$IFDEF D3D12_SDK_VERSION_612}
        m_dOptions21: TD3D12_FEATURE_DATA_D3D12_OPTIONS21;
        {$ENDIF}
        {$IFDEF D3D12_SDK_VERSION_619}
        m_dOptions22: TD3D12_FEATURE_DATA_D3D12_OPTIONS22;
        {$ENDIF}
        {$IFDEF D3D12_SDK_VERSION_617}
        m_dTightAlignment: TD3D12_FEATURE_DATA_TIGHT_ALIGNMENT;
        {$ENDIF}
    private
        // Private structs and helpers declaration

        // Helper function to decide the highest shader model supported by the system
        // Stores the result in m_dShaderModel
        // Must be updated whenever a new shader model is added to the d3d12.h header
        function QueryHighestShaderModel(): HRESULT;
        // Helper function to decide the highest root signature supported
        // Must be updated whenever a new root signature version is added to the d3d12.h header
        function QueryHighestRootSignatureVersion(): HRESULT;
        // Helper funcion to decide the highest feature level
        function QueryHighestFeatureLevel(): HRESULT;
        // Helper function to initialize local protected resource session types structs
        function QueryProtectedResourceSessionTypes(NodeIndex: UINT; Count: UINT): HRESULT;
    public
        // Function declaration
        // Default constructor that creates an empty object
        constructor Create;
        destructor Destroy; override;
        // Initialize data from the given device
        function Init(pDevice: ID3D12Device): HRESULT;
        // Retreives the status of the object. If an error occurred in the initialization process, the function returns the error code.
        function GetStatus(): HRESULT;

        // Getter functions for each feature class
        // D3D12_OPTIONS
        function DoublePrecisionFloatShaderOps(): boolean;
        function OutputMergerLogicOp(): boolean;
        function MinPrecisionSupport(): TD3D12_SHADER_MIN_PRECISION_SUPPORT;
        function TiledResourcesTier(): TD3D12_TILED_RESOURCES_TIER;
        function ResourceBindingTier(): TD3D12_RESOURCE_BINDING_TIER;
        function PSSpecifiedStencilRefSupported(): boolean;
        function TypedUAVLoadAdditionalFormats(): boolean;
        function ROVsSupported(): boolean;
        function ConservativeRasterizationTier(): TD3D12_CONSERVATIVE_RASTERIZATION_TIER;
        function StandardSwizzle64KBSupported(): boolean;
        function CrossAdapterRowMajorTextureSupported(): boolean;
        function VPAndRTArrayIndexFromAnyShaderFeedingRasterizerSupportedWithoutGSEmulation(): boolean;
        function ResourceHeapTier(): TD3D12_RESOURCE_HEAP_TIER;
        function CrossNodeSharingTier(): TD3D12_CROSS_NODE_SHARING_TIER;
        function MaxGPUVirtualAddressBitsPerResource(): UINT;
        // FEATURE_LEVELS
        function MaxSupportedFeatureLevel(): TD3D_FEATURE_LEVEL;
        // FORMAT_SUPPORT
        function FormatSupport(Format: TDXGI_FORMAT; out Support1: TD3D12_FORMAT_SUPPORT1; out Support2: TD3D12_FORMAT_SUPPORT2): HRESULT;
        // MUTLTISAMPLE_QUALITY_LEVELS
        function MultisampleQualityLevels(Format: TDXGI_FORMAT; SampleCount: UINT; Flags: TD3D12_MULTISAMPLE_QUALITY_LEVEL_FLAGS; out NumQualityLevels: UINT): HRESULT;
        // FORMAT_INFO
        function FormatInfo(Format: TDXGI_FORMAT; out PlaneCount: uint8): HRESULT;
        // GPU_VIRTUAL_ADDRESS_SUPPORT
        function MaxGPUVirtualAddressBitsPerProcess(): UINT;
        // SHADER_MODEL
        function HighestShaderModel(): TD3D_SHADER_MODEL;
        // D3D12_OPTIONS1
        function WaveOps(): boolean;
        function WaveLaneCountMin(): UINT;
        function WaveLaneCountMax(): UINT;
        function TotalLaneCount(): UINT;
        function ExpandedComputeResourceStates(): boolean;
        function Int64ShaderOps(): boolean;
        // PROTECTED_RESOURCE_SESSION_SUPPORT
        function ProtectedResourceSessionSupport(NodeIndex: UINT = 0): TD3D12_PROTECTED_RESOURCE_SESSION_SUPPORT_FLAGS;
        // ROOT_SIGNATURE
        function HighestRootSignatureVersion(): TD3D_ROOT_SIGNATURE_VERSION;
        // ARCHITECTURE1
        function TileBasedRenderer(NodeIndex: UINT = 0): boolean;
        function UMA(NodeIndex: UINT = 0): boolean;
        function CacheCoherentUMA(NodeIndex: UINT = 0): boolean;
        function IsolatedMMU(NodeIndex: UINT = 0): boolean;
        // D3D12_OPTIONS2
        function DepthBoundsTestSupported(): boolean;
        function ProgrammableSamplePositionsTier(): TD3D12_PROGRAMMABLE_SAMPLE_POSITIONS_TIER;
        // SHADER_CACHE
        function ShaderCacheSupportFlags(): TD3D12_SHADER_CACHE_SUPPORT_FLAGS;
        // COMMAND_QUEUE_PRIORITY
        function CommandQueuePrioritySupported(CommandListType: TD3D12_COMMAND_LIST_TYPE; Priority: UINT): boolean;
        // D3D12_OPTIONS3
        function CopyQueueTimestampQueriesSupported(): boolean;
        function CastingFullyTypedFormatSupported(): boolean;
        function WriteBufferImmediateSupportFlags(): TD3D12_COMMAND_LIST_SUPPORT_FLAGS;
        function ViewInstancingTier(): TD3D12_VIEW_INSTANCING_TIER;
        function BarycentricsSupported(): boolean;
        // EXISTING_HEAPS
        function ExistingHeapsSupported(): boolean;
        // D3D12_OPTIONS4
        function MSAA64KBAlignedTextureSupported(): boolean;
        function SharedResourceCompatibilityTier(): TD3D12_SHARED_RESOURCE_COMPATIBILITY_TIER;
        function Native16BitShaderOpsSupported(): boolean;
        // SERIALIZATION
        function HeapSerializationTier(NodeIndex: UINT = 0): TD3D12_HEAP_SERIALIZATION_TIER;
        // CROSS_NODE
        // CrossNodeSharingTier handled in D3D12Options
        function CrossNodeAtomicShaderInstructions(): boolean;
        // D3D12_OPTIONS5
        function SRVOnlyTiledResourceTier3(): boolean;
        function RenderPassesTier(): TD3D12_RENDER_PASS_TIER;
        function RaytracingTier(): TD3D12_RAYTRACING_TIER;
        {$IFDEF D3D12_SDK_VERSION_4}
        // DISPLAYABLE
        function DisplayableTexture(): boolean;
        // SharedResourceCompatibilityTier handled in D3D12Options4
        {$ENDIF}
        // D3D12_OPTIONS6
        function AdditionalShadingRatesSupported(): boolean;
        function PerPrimitiveShadingRateSupportedWithViewportIndexing(): boolean;
        function VariableShadingRateTier(): TD3D12_VARIABLE_SHADING_RATE_TIER;
        function ShadingRateImageTileSize(): UINT;
        function BackgroundProcessingSupported(): boolean;
        // QUERY_META_COMMAND
        function QueryMetaCommand(dQueryMetaCommand: PD3D12_FEATURE_DATA_QUERY_META_COMMAND): HRESULT;
        // D3D12_OPTIONS7
        function MeshShaderTier(): TD3D12_MESH_SHADER_TIER;
        function SamplerFeedbackTier(): TD3D12_SAMPLER_FEEDBACK_TIER;
        // PROTECTED_RESOURCE_SESSION_TYPE_COUNT
        function ProtectedResourceSessionTypeCount(NodeIndex: UINT = 0): UINT;
        // PROTECTED_RESOURCE_SESSION_TYPES
        function ProtectedResourceSessionTypes(NodeIndex: UINT = 0): specialize TCStdVector<TGUID>;
        {$IFDEF D3D12_SDK_VERSION_3}
        // D3D12_OPTIONS8
        function UnalignedBlockTexturesSupported(): boolean;
        // D3D12_OPTIONS9
        function MeshShaderPipelineStatsSupported(): boolean;
        function MeshShaderSupportsFullRangeRenderTargetArrayIndex(): boolean;
        function AtomicInt64OnTypedResourceSupported(): boolean;
        function AtomicInt64OnGroupSharedSupported(): boolean;
        function DerivativesInMeshAndAmplificationShadersSupported(): boolean;
        function WaveMMATier(): TD3D12_WAVE_MMA_TIER;
        {$ENDIF}

        {$IFDEF D3D12_SDK_VERSION_4}
        // D3D12_OPTIONS10
        function VariableRateShadingSumCombinerSupported(): boolean;
        function MeshShaderPerPrimitiveShadingRateSupported(): boolean;
        // D3D12_OPTIONS11
        function AtomicInt64OnDescriptorHeapResourceSupported(): boolean;
        {$ENDIF}
        {$IFDEF D3D12_SDK_VERSION_600}
        // D3D12_OPTIONS12
        function MSPrimitivesPipelineStatisticIncludesCulledPrimitives(): TD3D12_TRI_STATE;
        function EnhancedBarriersSupported(): boolean;
        function RelaxedFormatCastingSupported(): boolean;
        {$ENDIF}

        {$IFDEF D3D12_SDK_VERSION_602}
        // D3D12_OPTIONS13
        function UnrestrictedBufferTextureCopyPitchSupported(): boolean;
        function UnrestrictedVertexElementAlignmentSupported(): boolean;
        function InvertedViewportHeightFlipsYSupported(): boolean;
        function InvertedViewportDepthFlipsZSupported(): boolean;
        function TextureCopyBetweenDimensionsSupported(): boolean;
        function AlphaBlendFactorSupported(): boolean;
        {$ENDIF}

        {$IFDEF D3D12_SDK_VERSION_606}
        // D3D12_OPTIONS14
        function AdvancedTextureOpsSupported(): boolean;
        function WriteableMSAATexturesSupported(): boolean;
        function IndependentFrontAndBackStencilRefMaskSupported(): boolean;
        // D3D12_OPTIONS15
        function TriangleFanSupported(): boolean;
        function DynamicIndexBufferStripCutSupported(): boolean;
        {$ENDIF}

        {$IFDEF D3D12_SDK_VERSION_608}
        // D3D12_OPTIONS16
        function DynamicDepthBiasSupported(): boolean;
        {$ENDIF}

        {$IFDEF D3D12_SDK_VERSION_609}
        function GPUUploadHeapSupported(): boolean;
        // D3D12_OPTIONS17
        function NonNormalizedCoordinateSamplersSupported(): boolean;
        function ManualWriteTrackingResourceSupported(): boolean;
        // D3D12_OPTIONS18
        function RenderPassesValid(): boolean;
        {$ENDIF}

        {$IFDEF D3D12_SDK_VERSION_610}
        function MismatchingOutputDimensionsSupported(): boolean;
        function SupportedSampleCountsWithNoOutputs(): UINT;
        function PointSamplingAddressesNeverRoundUp(): boolean;
        function RasterizerDesc2Supported(): boolean;
        function NarrowQuadrilateralLinesSupported(): boolean;
        function AnisoFilterWithPointMipSupported(): boolean;
        function MaxSamplerDescriptorHeapSize(): UINT;
        function MaxSamplerDescriptorHeapSizeWithStaticSamplers(): UINT;
        function MaxViewDescriptorHeapSize(): UINT;
        {$ENDIF}

        {$IFDEF D3D12_SDK_VERSION_611}
        function ComputeOnlyWriteWatchSupported(): boolean;
        {$ENDIF}

        {$IFDEF D3D12_SDK_VERSION_612}
        function ExecuteIndirectTier(): TD3D12_EXECUTE_INDIRECT_TIER;
        function WorkGraphsTier(): TD3D12_WORK_GRAPHS_TIER;
        {$ENDIF}

        {$IFDEF D3D12_SDK_VERSION_617}
        function TightAlignmentSupportTier(): TD3D12_TIGHT_ALIGNMENT_TIER;
        {$ENDIF}

        {$IFDEF D3D12_SDK_VERSION_619}
        // D3D12_OPTIONS22
        function ShaderExecutionReorderingActuallyReorders(): winbool;
        function CreateByteOffsetViewsSupported(): winbool;
        function Max1DDispatchSize(): UINT;
        function Max1DDispatchMeshSize(): UINT;
        {$ENDIF}
    end;


    // ToDo function D3D_Feature_Level.A

implementation

// Implementations for TD3DX12FeatureSupport functions

{ TD3DX12FeatureSupport }

// Helper function to decide the highest shader model supported by the system
// Stores the result in m_dShaderModel
// Must be updated whenever a new shader model is added to the d3d12.h header
function TD3DX12FeatureSupport.QueryHighestShaderModel(): HRESULT;

    // Check support in descending order
const
    allModelVersions: array of TD3D_SHADER_MODEL = (
        {$IFDEF D3D12_SDK_VERSION_612}
        D3D_SHADER_MODEL_6_9,
        {$ENDIF}
        {$IFDEF D3D12_SDK_VERSION_606}
        D3D_SHADER_MODEL_6_8,
        {$ENDIF}
        {$IFDEF D3D12_SDK_VERSION_3}
        D3D_SHADER_MODEL_6_7,
        {$ENDIF}
        D3D_SHADER_MODEL_6_6,
        D3D_SHADER_MODEL_6_5,
        D3D_SHADER_MODEL_6_4,
        D3D_SHADER_MODEL_6_3,
        D3D_SHADER_MODEL_6_2,
        D3D_SHADER_MODEL_6_1,
        D3D_SHADER_MODEL_6_0,
        D3D_SHADER_MODEL_5_1
        );
var
    numModelVersions: size_t;
    i: size_t;
begin
    numModelVersions := Length(allModelVersions);

    for  i := 0 to numModelVersions - 1 do
    begin
        m_dShaderModel.HighestShaderModel := allModelVersions[i];
        Result := m_pDevice.CheckFeatureSupport(D3D12_FEATURE_SHADER_MODEL, @m_dShaderModel, sizeof(TD3D12_FEATURE_DATA_SHADER_MODEL));
        if (Result <> E_INVALIDARG) then
        begin
            // Indicates that the version is recognizable by the runtime and stored in the struct
            // Also terminate on unexpected error code
            if (FAILED(Result)) then
            begin
                m_dShaderModel.HighestShaderModel := TD3D_SHADER_MODEL(0);
            end;
            Exit;
        end;
    end;

    // Shader model may not be supported. Continue the rest initializations
    m_dShaderModel.HighestShaderModel := TD3D_SHADER_MODEL(0);
    Result := S_OK;
end;


// Helper function to decide the highest root signature supported
// Must be updated whenever a new root signature version is added to the d3d12.h header
function TD3DX12FeatureSupport.QueryHighestRootSignatureVersion(): HRESULT;
const
    allRootSignatureVersions: array of TD3D_ROOT_SIGNATURE_VERSION =
        (
        {$IFDEF D3D12_SDK_VERSION_609}
        D3D_ROOT_SIGNATURE_VERSION_1_2,
        {$ENDIF}
        D3D_ROOT_SIGNATURE_VERSION_1_1, D3D_ROOT_SIGNATURE_VERSION_1_0, D3D_ROOT_SIGNATURE_VERSION_1);
var
    numRootSignatureVersions: size_t;
    i: size_t;
begin
    numRootSignatureVersions := Length(allRootSignatureVersions);
    for  i := 0 to numRootSignatureVersions - 1 do
    begin
        m_dRootSignature.HighestVersion := allRootSignatureVersions[i];
        Result := m_pDevice.CheckFeatureSupport(D3D12_FEATURE_ROOT_SIGNATURE, @m_dRootSignature, sizeof(TD3D12_FEATURE_DATA_ROOT_SIGNATURE));
        if (Result <> E_INVALIDARG) then
        begin
            if (FAILED(Result)) then
            begin
                m_dRootSignature.HighestVersion := TD3D_ROOT_SIGNATURE_VERSION(0);
            end;
            // If succeeded, the highest version is already written into the member struct
            Exit;
        end;
    end;

    // No version left. Set to invalid value and continue.
    m_dRootSignature.HighestVersion := TD3D_ROOT_SIGNATURE_VERSION(0);
    Result := S_OK;
end;


// Helper funcion to decide the highest feature level
function TD3DX12FeatureSupport.QueryHighestFeatureLevel(): HRESULT;
    // Check against a list of all feature levels present in d3dcommon.h
    // Needs to be updated for future feature levels
const
    allLevels: array of TD3D_FEATURE_LEVEL =
        (
        {$IFDEF D3D12_SDK_VERSION_3}
        D3D_FEATURE_LEVEL_12_2,
        {$ENDIF}
        D3D_FEATURE_LEVEL_12_1, D3D_FEATURE_LEVEL_12_0, D3D_FEATURE_LEVEL_11_1, D3D_FEATURE_LEVEL_11_0, D3D_FEATURE_LEVEL_10_1, D3D_FEATURE_LEVEL_10_0, D3D_FEATURE_LEVEL_9_3, D3D_FEATURE_LEVEL_9_2, D3D_FEATURE_LEVEL_9_1
        {$IFDEF D3D12_SDK_VERSION_5}
        , D3D_FEATURE_LEVEL_1_0_CORE
        {$ENDIF}
        {$IFDEF D3D12_SDK_VERSION_611}
        , D3D_FEATURE_LEVEL_1_0_GENERIC
        {$ENDIF}
        );
var
    dFeatureLevel: TD3D12_FEATURE_DATA_FEATURE_LEVELS;
begin

    dFeatureLevel.NumFeatureLevels := Length(allLevels);
    dFeatureLevel.pFeatureLevelsRequested := @allLevels[0];

    Result := m_pDevice.CheckFeatureSupport(D3D12_FEATURE_FEATURE_LEVELS, @dFeatureLevel, sizeof(TD3D12_FEATURE_DATA_FEATURE_LEVELS));
    if (SUCCEEDED(Result)) then
    begin
        m_eMaxFeatureLevel := dFeatureLevel.MaxSupportedFeatureLevel;
    end
    else
    begin
        m_eMaxFeatureLevel := TD3D_FEATURE_LEVEL(0);

        if (Result = DXGI_ERROR_UNSUPPORTED) then
        begin
            // Indicates that none supported. Continue initialization
            Result := S_OK;
        end;
    end;
end;


// Helper function to initialize local protected resource session types structs
function TD3DX12FeatureSupport.QueryProtectedResourceSessionTypes(NodeIndex: UINT; Count: UINT): HRESULT;
var
    CurrentPRSTypes: TProtectedResourceSessionTypesLocal;
begin
    CurrentPRSTypes := m_dProtectedResourceSessionTypes.Item[NodeIndex];
    CurrentPRSTypes.FeatureData.NodeIndex := NodeIndex;
    CurrentPRSTypes.FeatureData.Count := Count;
    CurrentPRSTypes.TypeVec.resize(CurrentPRSTypes.FeatureData.Count);
    CurrentPRSTypes.FeatureData.pTypes := CurrentPRSTypes.TypeVec.Data();

    Result := m_pDevice.CheckFeatureSupport(D3D12_FEATURE_PROTECTED_RESOURCE_SESSION_TYPES, m_dProtectedResourceSessionTypes.PtrItem[NodeIndex], sizeof(TD3D12_FEATURE_DATA_PROTECTED_RESOURCE_SESSION_TYPES));
    if (FAILED(Result)) then
    begin
        // Resize TypeVec to empty
        CurrentPRSTypes.TypeVec.Clear();
    end;
end;



constructor TD3DX12FeatureSupport.Create;
begin
    m_pDevice := nil;
    m_hStatus := E_INVALIDARG;
end;



destructor TD3DX12FeatureSupport.Destroy;
begin
    inherited Destroy;
end;



function TD3DX12FeatureSupport.Init(pDevice: ID3D12Device): HRESULT;
var
    uNodeCount: UINT;
    iNodeIndex: UINT;
    dArchLocal: TD3D12_FEATURE_DATA_ARCHITECTURE;
begin
    if (pDevice = nil) then
    begin
        m_hStatus := E_INVALIDARG;
        Result := m_hStatus;
        Exit;
    end;

    m_pDevice := pDevice;

    // Initialize static feature support data structures
    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS, @m_dOptions, sizeof(m_dOptions)))) then
    begin
        m_dOptions.Clear;
    end;

    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_GPU_VIRTUAL_ADDRESS_SUPPORT, @m_dGPUVASupport, sizeof(m_dGPUVASupport)))) then
    begin
        m_dGPUVASupport.Clear;
    end;

    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS1, @m_dOptions1, sizeof(m_dOptions1)))) then
    begin
        m_dOptions1.Clear;
    end;

    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS2, @m_dOptions2, sizeof(m_dOptions2)))) then
    begin
        m_dOptions2.Clear;
    end;

    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_SHADER_CACHE, @m_dShaderCache, sizeof(m_dShaderCache)))) then
    begin
        m_dShaderCache.Clear;
    end;

    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS3, @m_dOptions3, sizeof(m_dOptions3)))) then
    begin
        m_dOptions3.Clear;
    end;

    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_EXISTING_HEAPS, @m_dExistingHeaps, sizeof(m_dExistingHeaps)))) then
    begin
        m_dExistingHeaps.Clear;
    end;

    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS4, @m_dOptions4, sizeof(m_dOptions4)))) then
    begin
        m_dOptions4.Clear;
    end;

    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_CROSS_NODE, @m_dCrossNode, sizeof(m_dCrossNode)))) then
    begin
        m_dCrossNode.Clear;
    end;

    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS5, @m_dOptions5, sizeof(m_dOptions5)))) then
    begin
        m_dOptions5.Clear;
    end;

    {$IFDEF D3D12_SDK_VERSION_4}
    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_DISPLAYABLE, @m_dDisplayable, sizeof(m_dDisplayable)))) then
    begin
        m_dDisplayable.Clear;
    end;
    {$ENDIF}

    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS6, @m_dOptions6, sizeof(m_dOptions6)))) then
    begin
        m_dOptions6.Clear;
    end;

    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS7, @m_dOptions7, sizeof(m_dOptions7)))) then
    begin
        m_dOptions7.Clear;
    end;

    {$IFDEF D3D12_SDK_VERSION_3}
    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS8, @m_dOptions8, sizeof(m_dOptions8)))) then
    begin
        m_dOptions8.Clear;
    end;

    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS9, @m_dOptions9, sizeof(m_dOptions9)))) then
    begin
        m_dOptions9.Clear;
    end;
    {$ENDIF}

    {$IFDEF D3D12_SDK_VERSION_4}
    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS10, @m_dOptions10, sizeof(m_dOptions10)))) then
    begin
        m_dOptions10.Clear;
    end;

    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS11, @m_dOptions11, sizeof(m_dOptions11)))) then
    begin
        m_dOptions11.Clear;
    end;
    {$ENDIF}

    {$IFDEF D3D12_SDK_VERSION_600}
    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS12, @m_dOptions12, sizeof(m_dOptions12)))) then
    begin
        m_dOptions12.Clear;
        m_dOptions12.MSPrimitivesPipelineStatisticIncludesCulledPrimitives := TD3D12_TRI_STATE.D3D12_TRI_STATE_UNKNOWN;
    end;
    {$ENDIF}

    {$IFDEF D3D12_SDK_VERSION_602}
    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS13, @m_dOptions13, sizeof(m_dOptions13)))) then
    begin
        m_dOptions13.Clear;
    end;
    {$ENDIF}

    {$IFDEF D3D12_SDK_VERSION_606}
    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS14, @m_dOptions14, sizeof(m_dOptions14)))) then
    begin
        m_dOptions14.Clear;
    end;

    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS15, @m_dOptions15, sizeof(m_dOptions15)))) then
    begin
        m_dOptions15.Clear;
    end;
    {$ENDIF}

    {$IFDEF D3D12_SDK_VERSION_608}
    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS16, @m_dOptions16, sizeof(m_dOptions16)))) then
    begin
        m_dOptions16.Clear;
    end;
    {$ENDIF}

    {$IFDEF D3D12_SDK_VERSION_609}
    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS17, @m_dOptions17, sizeof(m_dOptions17)))) then
    begin
        m_dOptions17.Clear;
    end;

    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS18, @m_dOptions18, sizeof(m_dOptions18)))) then
    begin
        m_dOptions18.RenderPassesValid := False;
    end;
    {$ENDIF}

    {$IFDEF D3D12_SDK_VERSION_610}
    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS19, @m_dOptions19, sizeof(m_dOptions19)))) then
    begin
        m_dOptions19.Clear;
        m_dOptions19.SupportedSampleCountsWithNoOutputs := 1;
        m_dOptions19.MaxSamplerDescriptorHeapSize := D3D12_MAX_SHADER_VISIBLE_SAMPLER_HEAP_SIZE;
        m_dOptions19.MaxSamplerDescriptorHeapSizeWithStaticSamplers := D3D12_MAX_SHADER_VISIBLE_SAMPLER_HEAP_SIZE;
        m_dOptions19.MaxViewDescriptorHeapSize := D3D12_MAX_SHADER_VISIBLE_DESCRIPTOR_HEAP_SIZE_TIER_1;
    end;
    {$ENDIF}

    {$IFDEF D3D12_SDK_VERSION_611}
    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS20, @m_dOptions20, sizeof(m_dOptions20)))) then
    begin
        m_dOptions20.Clear;
    end;
    {$ENDIF}

    {$IFDEF D3D12_SDK_VERSION_612}
    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS21, @m_dOptions21, sizeof(m_dOptions21)))) then
    begin
        m_dOptions21.Clear;
    end;
    {$ENDIF}

    {$IFDEF D3D12_SDK_VERSION_619}
    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS22, @m_dOptions22, sizeof(m_dOptions22)))) then
    begin
        m_dOptions22.Clear;
    end;
    {$ENDIF}

    {$IFDEF D3D12_SDK_VERSION_617}
    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_D3D12_TIGHT_ALIGNMENT, @m_dTightAlignment, sizeof(m_dTightAlignment)))) then
    begin
        m_dTightAlignment.Clear;
    end;
    {$ENDIF}

    // Initialize per-node feature support data structures
    uNodeCount := m_pDevice.GetNodeCount();
    m_dProtectedResourceSessionSupport.resize(uNodeCount);
    m_dArchitecture1.resize(uNodeCount);
    m_dSerialization.resize(uNodeCount);
    m_dProtectedResourceSessionTypeCount.resize(uNodeCount);
    m_dProtectedResourceSessionTypes.resize(uNodeCount);
    for  iNodeIndex := 0 to uNodeCount - 1 do
    begin
        m_dProtectedResourceSessionSupport.PtrItem[iNodeIndex]^.NodeIndex := iNodeIndex;
        if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_PROTECTED_RESOURCE_SESSION_SUPPORT, m_dProtectedResourceSessionSupport.PtrItem[iNodeIndex], sizeof(m_dProtectedResourceSessionSupport.Item[iNodeIndex])))) then
        begin
            m_dProtectedResourceSessionSupport.PtrItem[iNodeIndex]^.Support := D3D12_PROTECTED_RESOURCE_SESSION_SUPPORT_FLAG_NONE;
        end;

        m_dArchitecture1.PtrItem[iNodeIndex]^.NodeIndex := iNodeIndex;
        if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_ARCHITECTURE1, m_dArchitecture1.PtrItem[iNodeIndex], sizeof(m_dArchitecture1.Item[iNodeIndex])))) then
        begin
            dArchLocal.Clear;
            dArchLocal.NodeIndex := iNodeIndex;
            if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_ARCHITECTURE, @dArchLocal, sizeof(dArchLocal)))) then
            begin
                dArchLocal.TileBasedRenderer := False;
                dArchLocal.UMA := False;
                dArchLocal.CacheCoherentUMA := False;
            end;

            m_dArchitecture1.PtrItem[iNodeIndex]^.TileBasedRenderer := dArchLocal.TileBasedRenderer;
            m_dArchitecture1.PtrItem[iNodeIndex]^.UMA := dArchLocal.UMA;
            m_dArchitecture1.PtrItem[iNodeIndex]^.CacheCoherentUMA := dArchLocal.CacheCoherentUMA;
            m_dArchitecture1.PtrItem[iNodeIndex]^.IsolatedMMU := False;
        end;

        m_dSerialization.PtrItem[iNodeIndex]^.NodeIndex := iNodeIndex;
        if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_SERIALIZATION, m_dSerialization.PtrItem[iNodeIndex], sizeof(m_dSerialization.Item[iNodeIndex])))) then
        begin
            m_dSerialization.PtrItem[iNodeIndex]^.HeapSerializationTier := D3D12_HEAP_SERIALIZATION_TIER_0;
        end;

        m_dProtectedResourceSessionTypeCount.PtrItem[iNodeIndex]^.NodeIndex := iNodeIndex;
        if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_PROTECTED_RESOURCE_SESSION_TYPE_COUNT, m_dProtectedResourceSessionTypeCount.PtrItem[iNodeIndex], sizeof(m_dProtectedResourceSessionTypeCount.Item[iNodeIndex])))) then
        begin
            m_dProtectedResourceSessionTypeCount.PtrItem[iNodeIndex]^.Count := 0;
        end;

        // Special procedure to initialize local protected resource session types structs
        // Must wait until session type count initialized
        QueryProtectedResourceSessionTypes(iNodeIndex, m_dProtectedResourceSessionTypeCount.PtrItem[iNodeIndex]^.Count);
    end;

    // Initialize features that requires highest version check
    m_hStatus := QueryHighestShaderModel();
    if (FAILED(m_hStatus)) then
    begin
        Result := m_hStatus;
        Exit;
    end;
    m_hStatus := QueryHighestRootSignatureVersion();
    if (FAILED(m_hStatus)) then
    begin
        Result := m_hStatus;
        Exit;
    end;

    // Initialize Feature Levels data
    m_hStatus := QueryHighestFeatureLevel();
    if (FAILED(m_hStatus)) then
    begin
        Result := m_hStatus;
        Exit;
    end;

    Result := m_hStatus;
end;



function TD3DX12FeatureSupport.GetStatus(): HRESULT;
begin
    Result := m_hStatus;
end;



function TD3DX12FeatureSupport.DoublePrecisionFloatShaderOps(): boolean;
begin
    Result := m_dOptions.DoublePrecisionFloatShaderOps;
end;



function TD3DX12FeatureSupport.OutputMergerLogicOp(): boolean;
begin
    Result := m_dOptions.OutputMergerLogicOp;
end;



function TD3DX12FeatureSupport.MinPrecisionSupport(): TD3D12_SHADER_MIN_PRECISION_SUPPORT;
begin
    Result := m_dOptions.MinPrecisionSupport;
end;



function TD3DX12FeatureSupport.TiledResourcesTier(): TD3D12_TILED_RESOURCES_TIER;
begin
    Result := m_dOptions.TiledResourcesTier;
end;



function TD3DX12FeatureSupport.ResourceBindingTier(): TD3D12_RESOURCE_BINDING_TIER;
begin
    Result := m_dOptions.ResourceBindingTier;
end;



function TD3DX12FeatureSupport.PSSpecifiedStencilRefSupported(): boolean;
begin
    Result := m_dOptions.PSSpecifiedStencilRefSupported;
end;



function TD3DX12FeatureSupport.TypedUAVLoadAdditionalFormats(): boolean;
begin
    Result := m_dOptions.TypedUAVLoadAdditionalFormats;
end;



function TD3DX12FeatureSupport.ROVsSupported(): boolean;
begin
    Result := m_dOptions.ROVsSupported;
end;



function TD3DX12FeatureSupport.ConservativeRasterizationTier(): TD3D12_CONSERVATIVE_RASTERIZATION_TIER;
begin
    Result := m_dOptions.ConservativeRasterizationTier;
end;



function TD3DX12FeatureSupport.StandardSwizzle64KBSupported(): boolean;
begin
    Result := m_dOptions.StandardSwizzle64KBSupported;
end;



function TD3DX12FeatureSupport.CrossAdapterRowMajorTextureSupported(): boolean;
begin
    Result := m_dOptions.CrossAdapterRowMajorTextureSupported;
end;



function TD3DX12FeatureSupport.VPAndRTArrayIndexFromAnyShaderFeedingRasterizerSupportedWithoutGSEmulation
    (): boolean;
begin
    Result := m_dOptions.VPAndRTArrayIndexFromAnyShaderFeedingRasterizerSupportedWithoutGSEmulation;
end;



function TD3DX12FeatureSupport.ResourceHeapTier(): TD3D12_RESOURCE_HEAP_TIER;
begin
    Result := m_dOptions.ResourceHeapTier;
end;


// Special procedure for handling caps that is also part of other features
function TD3DX12FeatureSupport.CrossNodeSharingTier(): TD3D12_CROSS_NODE_SHARING_TIER;
begin
    if (m_dCrossNode.SharingTier > D3D12_CROSS_NODE_SHARING_TIER_NOT_SUPPORTED) then
    begin
        Result := m_dCrossNode.SharingTier;
    end
    else
    begin
        Result := m_dOptions.CrossNodeSharingTier;
    end;
end;



function TD3DX12FeatureSupport.MaxGPUVirtualAddressBitsPerResource(): UINT;
begin
    if (m_dOptions.MaxGPUVirtualAddressBitsPerResource > 0) then
    begin
        Result := m_dOptions.MaxGPUVirtualAddressBitsPerResource;
    end
    else
    begin
        Result := m_dGPUVASupport.MaxGPUVirtualAddressBitsPerResource;
    end;
end;


// 1: Architecture
// Combined with Architecture1

// 2: Feature Levels
// Simply returns the highest supported feature level
function TD3DX12FeatureSupport.MaxSupportedFeatureLevel(): TD3D_FEATURE_LEVEL;
begin
    Result := m_eMaxFeatureLevel;
end;


// 3: Feature Format Support
function TD3DX12FeatureSupport.FormatSupport(Format: TDXGI_FORMAT; out Support1: TD3D12_FORMAT_SUPPORT1; out Support2: TD3D12_FORMAT_SUPPORT2): HRESULT;
var
    dFormatSupport: TD3D12_FEATURE_DATA_FORMAT_SUPPORT;
begin
    dFormatSupport.Format := Format;

    // It is possible that the function call returns an error
    Result := m_pDevice.CheckFeatureSupport(D3D12_FEATURE_FORMAT_SUPPORT, @dFormatSupport, sizeof(TD3D12_FEATURE_DATA_FORMAT_SUPPORT));

    Support1 := dFormatSupport.Support1;
    Support2 := dFormatSupport.Support2; // Two outputs. Probably better just to take in the struct as an argument?
end;


// 4: Multisample Quality Levels
function TD3DX12FeatureSupport.MultisampleQualityLevels(Format: TDXGI_FORMAT; SampleCount: UINT; Flags: TD3D12_MULTISAMPLE_QUALITY_LEVEL_FLAGS; out NumQualityLevels: UINT): HRESULT;
var
    dMultisampleQualityLevels: TD3D12_FEATURE_DATA_MULTISAMPLE_QUALITY_LEVELS;
begin

    dMultisampleQualityLevels.Format := Format;
    dMultisampleQualityLevels.SampleCount := SampleCount;
    dMultisampleQualityLevels.Flags := Flags;

    Result := m_pDevice.CheckFeatureSupport(D3D12_FEATURE_MULTISAMPLE_QUALITY_LEVELS, @dMultisampleQualityLevels, sizeof(TD3D12_FEATURE_DATA_MULTISAMPLE_QUALITY_LEVELS));

    if (SUCCEEDED(Result)) then
    begin
        NumQualityLevels := dMultisampleQualityLevels.NumQualityLevels;
    end
    else
    begin
        NumQualityLevels := 0;
    end;
end;


// 5: Format Info
function TD3DX12FeatureSupport.FormatInfo(Format: TDXGI_FORMAT; out PlaneCount: uint8): HRESULT;
var
    dFormatInfo: TD3D12_FEATURE_DATA_FORMAT_INFO;
begin

    dFormatInfo.Format := Format;

    Result := m_pDevice.CheckFeatureSupport(D3D12_FEATURE_FORMAT_INFO, @dFormatInfo, sizeof(TD3D12_FEATURE_DATA_FORMAT_INFO));
    if (FAILED(Result)) then
    begin
        PlaneCount := 0;
    end
    else
    begin
        PlaneCount := dFormatInfo.PlaneCount;
    end;
end;


// 6: GPU Virtual Address Support
// MaxGPUVirtualAddressBitsPerResource handled in D3D12Options
function TD3DX12FeatureSupport.MaxGPUVirtualAddressBitsPerProcess(): UINT;
begin
    Result := m_dGPUVASupport.MaxGPUVirtualAddressBitsPerProcess;
end;


// 7: Shader Model
function TD3DX12FeatureSupport.HighestShaderModel(): TD3D_SHADER_MODEL;
begin
    Result := m_dShaderModel.HighestShaderModel;
end;


// 8: D3D12 Options1
function TD3DX12FeatureSupport.WaveOps(): boolean;
begin
    Result := m_dOptions1.WaveOps;
end;



function TD3DX12FeatureSupport.WaveLaneCountMin(): UINT;
begin
    Result := m_dOptions1.WaveLaneCountMin;
end;



function TD3DX12FeatureSupport.WaveLaneCountMax(): UINT;
begin
    Result := m_dOptions1.WaveLaneCountMax;
end;



function TD3DX12FeatureSupport.TotalLaneCount(): UINT;
begin
    Result := m_dOptions1.TotalLaneCount;
end;



function TD3DX12FeatureSupport.ExpandedComputeResourceStates(): boolean;
begin
    Result := m_dOptions1.ExpandedComputeResourceStates;
end;



function TD3DX12FeatureSupport.Int64ShaderOps(): boolean;
begin
    Result := m_dOptions1.Int64ShaderOps;
end;


// 10: Protected Resource Session Support
function TD3DX12FeatureSupport.ProtectedResourceSessionSupport(NodeIndex: UINT): TD3D12_PROTECTED_RESOURCE_SESSION_SUPPORT_FLAGS;
begin
    Result := m_dProtectedResourceSessionSupport.PtrItem[NodeIndex]^.Support;
end;


// 12: Root Signature
function TD3DX12FeatureSupport.HighestRootSignatureVersion(): TD3D_ROOT_SIGNATURE_VERSION;
begin
    Result := m_dRootSignature.HighestVersion;
end;


// 16: Architecture1
// Same data fields can be queried from m_dArchitecture
function TD3DX12FeatureSupport.TileBasedRenderer(NodeIndex: UINT): boolean;
begin
    Result := m_dArchitecture1.PtrItem[NodeIndex]^.TileBasedRenderer;
end;



function TD3DX12FeatureSupport.UMA(NodeIndex: UINT): boolean;
begin
    Result := m_dArchitecture1.PtrItem[NodeIndex]^.UMA;
end;



function TD3DX12FeatureSupport.CacheCoherentUMA(NodeIndex: UINT): boolean;
begin
    Result := m_dArchitecture1.PtrItem[NodeIndex]^.CacheCoherentUMA;
end;



function TD3DX12FeatureSupport.IsolatedMMU(NodeIndex: UINT): boolean;
begin
    Result := m_dArchitecture1.PtrItem[NodeIndex]^.IsolatedMMU;
end;


// 18: D3D12 Options2
function TD3DX12FeatureSupport.DepthBoundsTestSupported(): boolean;
begin
    Result := m_dOptions2.DepthBoundsTestSupported;
end;



function TD3DX12FeatureSupport.ProgrammableSamplePositionsTier(): TD3D12_PROGRAMMABLE_SAMPLE_POSITIONS_TIER;
begin
    Result := m_dOptions2.ProgrammableSamplePositionsTier;
end;


// 19: Shader Cache
function TD3DX12FeatureSupport.ShaderCacheSupportFlags(): TD3D12_SHADER_CACHE_SUPPORT_FLAGS;
begin
    Result := m_dShaderCache.SupportFlags;
end;


// 20: Command Queue Priority
function TD3DX12FeatureSupport.CommandQueuePrioritySupported(CommandListType: TD3D12_COMMAND_LIST_TYPE; Priority: UINT): boolean;
begin
    m_dCommandQueuePriority.CommandListType := CommandListType;
    m_dCommandQueuePriority.Priority := Priority;

    if (FAILED(m_pDevice.CheckFeatureSupport(D3D12_FEATURE_COMMAND_QUEUE_PRIORITY, @m_dCommandQueuePriority, sizeof(TD3D12_FEATURE_DATA_COMMAND_QUEUE_PRIORITY)))) then
    begin
        Result := False;
    end;

    Result := m_dCommandQueuePriority.PriorityForTypeIsSupported;
end;


// 21: D3D12 Options3
function TD3DX12FeatureSupport.CopyQueueTimestampQueriesSupported(): boolean;
begin
    Result := m_dOptions3.CopyQueueTimestampQueriesSupported;
end;



function TD3DX12FeatureSupport.CastingFullyTypedFormatSupported(): boolean;
begin
    Result := m_dOptions3.CastingFullyTypedFormatSupported;
end;



function TD3DX12FeatureSupport.WriteBufferImmediateSupportFlags(): TD3D12_COMMAND_LIST_SUPPORT_FLAGS;
begin
    Result := m_dOptions3.WriteBufferImmediateSupportFlags;
end;



function TD3DX12FeatureSupport.ViewInstancingTier(): TD3D12_VIEW_INSTANCING_TIER;
begin
    Result := m_dOptions3.ViewInstancingTier;
end;



function TD3DX12FeatureSupport.BarycentricsSupported(): boolean;
begin
    Result := m_dOptions3.BarycentricsSupported;
end;


// 22: Existing Heaps
function TD3DX12FeatureSupport.ExistingHeapsSupported(): boolean;
begin
    Result := m_dExistingHeaps.Supported;
end;


// 23: D3D12 Options4
function TD3DX12FeatureSupport.MSAA64KBAlignedTextureSupported(): boolean;
begin
    Result := m_dOptions4.MSAA64KBAlignedTextureSupported;
end;



function TD3DX12FeatureSupport.SharedResourceCompatibilityTier(): TD3D12_SHARED_RESOURCE_COMPATIBILITY_TIER;
begin
    Result := m_dOptions4.SharedResourceCompatibilityTier;
end;



function TD3DX12FeatureSupport.Native16BitShaderOpsSupported(): boolean;
begin
    Result := m_dOptions4.Native16BitShaderOpsSupported;
end;


// 24: Serialization
function TD3DX12FeatureSupport.HeapSerializationTier(NodeIndex: UINT): TD3D12_HEAP_SERIALIZATION_TIER;
begin
    Result := m_dSerialization.PtrItem[NodeIndex]^.HeapSerializationTier;
end;


// 25: Cross Node
// CrossNodeSharingTier handled in D3D12Options
function TD3DX12FeatureSupport.CrossNodeAtomicShaderInstructions(): boolean;
begin
    Result := m_dCrossNode.AtomicShaderInstructions;
end;


// 27: D3D12 Options5
function TD3DX12FeatureSupport.SRVOnlyTiledResourceTier3(): boolean;
begin
    Result := m_dOptions5.SRVOnlyTiledResourceTier3;
end;



function TD3DX12FeatureSupport.RenderPassesTier(): TD3D12_RENDER_PASS_TIER;
begin
    Result := m_dOptions5.RenderPassesTier;
end;



function TD3DX12FeatureSupport.RaytracingTier(): TD3D12_RAYTRACING_TIER;
begin
    Result := m_dOptions5.RaytracingTier;
end;

{$IFDEF D3D12_SDK_VERSION_4}
// 28: Displayable
function TD3DX12FeatureSupport.DisplayableTexture(): boolean;
begin
    Result := m_dDisplayable.DisplayableTexture;
end;
// SharedResourceCompatibilityTier handled in D3D12Options4
{$ENDIF}

// 30: D3D12 Options6
function TD3DX12FeatureSupport.AdditionalShadingRatesSupported(): boolean;
begin
    Result := m_dOptions6.AdditionalShadingRatesSupported;
end;



function TD3DX12FeatureSupport.PerPrimitiveShadingRateSupportedWithViewportIndexing
    (): boolean;
begin
    Result := m_dOptions6.PerPrimitiveShadingRateSupportedWithViewportIndexing;
end;



function TD3DX12FeatureSupport.VariableShadingRateTier(): TD3D12_VARIABLE_SHADING_RATE_TIER;
begin
    Result := m_dOptions6.VariableShadingRateTier;
end;



function TD3DX12FeatureSupport.ShadingRateImageTileSize(): UINT;
begin
    Result := m_dOptions6.ShadingRateImageTileSize;
end;



function TD3DX12FeatureSupport.BackgroundProcessingSupported(): boolean;
begin
    Result := m_dOptions6.BackgroundProcessingSupported;
end;


// 31: Query Meta Command
// Keep the original call routine
function TD3DX12FeatureSupport.QueryMetaCommand(dQueryMetaCommand: PD3D12_FEATURE_DATA_QUERY_META_COMMAND): HRESULT;
begin
    Result := m_pDevice.CheckFeatureSupport(D3D12_FEATURE_QUERY_META_COMMAND, dQueryMetaCommand, sizeof(TD3D12_FEATURE_DATA_QUERY_META_COMMAND));
end;


// 32: D3D12 Options7
function TD3DX12FeatureSupport.MeshShaderTier(): TD3D12_MESH_SHADER_TIER;
begin
    Result := m_dOptions7.MeshShaderTier;
end;



function TD3DX12FeatureSupport.SamplerFeedbackTier(): TD3D12_SAMPLER_FEEDBACK_TIER;
begin
    Result := m_dOptions7.SamplerFeedbackTier;
end;


// 33: Protected Resource Session Type Count
function TD3DX12FeatureSupport.ProtectedResourceSessionTypeCount(NodeIndex: UINT): UINT;
begin
    Result := m_dProtectedResourceSessionTypeCount.PtrItem[NodeIndex]^.Count;
end;


// 34: Protected Resource Session Types
function TD3DX12FeatureSupport.ProtectedResourceSessionTypes(NodeIndex: UINT): specialize TCStdVector<TGUID>;
begin
    Result := m_dProtectedResourceSessionTypes.PtrItem[NodeIndex]^.TypeVec;
end;


{$IFDEF D3D12_SDK_VERSION_3}
// 36: Options8
function TD3DX12FeatureSupport.UnalignedBlockTexturesSupported(): boolean;
begin
    Result := m_dOptions8.UnalignedBlockTexturesSupported;
end;


// 37: Options9
function TD3DX12FeatureSupport.MeshShaderPipelineStatsSupported(): boolean;
begin
    Result := m_dOptions9.MeshShaderPipelineStatsSupported;
end;



function TD3DX12FeatureSupport.MeshShaderSupportsFullRangeRenderTargetArrayIndex
    (): boolean;
begin
    Result := m_dOptions9.MeshShaderSupportsFullRangeRenderTargetArrayIndex;
end;



function TD3DX12FeatureSupport.AtomicInt64OnTypedResourceSupported(): boolean;
begin
    Result := m_dOptions9.AtomicInt64OnTypedResourceSupported;
end;



function TD3DX12FeatureSupport.AtomicInt64OnGroupSharedSupported(): boolean;
begin
    Result := m_dOptions9.AtomicInt64OnGroupSharedSupported;
end;



function TD3DX12FeatureSupport.DerivativesInMeshAndAmplificationShadersSupported
    (): boolean;
begin
    Result := m_dOptions9.DerivativesInMeshAndAmplificationShadersSupported;
end;



function TD3DX12FeatureSupport.WaveMMATier(): TD3D12_WAVE_MMA_TIER;
begin
    Result := m_dOptions9.WaveMMATier;
end;
{$ENDIF}

{$IFDEF D3D12_SDK_VERSION_4}
// 39: Options10
function TD3DX12FeatureSupport.VariableRateShadingSumCombinerSupported(): boolean;
begin
    Result := m_dOptions10.VariableRateShadingSumCombinerSupported;
end;



function TD3DX12FeatureSupport.MeshShaderPerPrimitiveShadingRateSupported(): boolean;
begin
    Result := m_dOptions10.MeshShaderPerPrimitiveShadingRateSupported;
end;


// 40: Options11
function TD3DX12FeatureSupport.AtomicInt64OnDescriptorHeapResourceSupported(): boolean;
begin
    Result := m_dOptions11.AtomicInt64OnDescriptorHeapResourceSupported;
end;
{$ENDIF}

{$IFDEF D3D12_SDK_VERSION_600}
// 41: Options12
function TD3DX12FeatureSupport.MSPrimitivesPipelineStatisticIncludesCulledPrimitives
    (): TD3D12_TRI_STATE;
begin
    Result := m_dOptions12.MSPrimitivesPipelineStatisticIncludesCulledPrimitives;
end;



function TD3DX12FeatureSupport.EnhancedBarriersSupported(): boolean;
begin
    Result := m_dOptions12.EnhancedBarriersSupported;
end;



function TD3DX12FeatureSupport.RelaxedFormatCastingSupported(): boolean;
begin
    Result := m_dOptions12.RelaxedFormatCastingSupported;
end;
{$ENDIF}

{$IFDEF D3D12_SDK_VERSION_602}
// 42: Options13
function TD3DX12FeatureSupport.UnrestrictedBufferTextureCopyPitchSupported(): boolean;
begin
    Result := m_dOptions13.UnrestrictedBufferTextureCopyPitchSupported;
end;



function TD3DX12FeatureSupport.UnrestrictedVertexElementAlignmentSupported(): boolean;
begin
    Result := m_dOptions13.UnrestrictedVertexElementAlignmentSupported;
end;



function TD3DX12FeatureSupport.InvertedViewportHeightFlipsYSupported(): boolean;
begin
    Result := m_dOptions13.InvertedViewportHeightFlipsYSupported;
end;



function TD3DX12FeatureSupport.InvertedViewportDepthFlipsZSupported(): boolean;
begin
    Result := m_dOptions13.InvertedViewportDepthFlipsZSupported;
end;



function TD3DX12FeatureSupport.TextureCopyBetweenDimensionsSupported(): boolean;
begin
    Result := m_dOptions13.TextureCopyBetweenDimensionsSupported;
end;



function TD3DX12FeatureSupport.AlphaBlendFactorSupported(): boolean;
begin
    Result := m_dOptions13.AlphaBlendFactorSupported;
end;
{$ENDIF}


{$IFDEF D3D12_SDK_VERSION_606}
// 43: Options14
function TD3DX12FeatureSupport.AdvancedTextureOpsSupported(): boolean;
begin
    Result := m_dOptions14.AdvancedTextureOpsSupported;
end;



function TD3DX12FeatureSupport.WriteableMSAATexturesSupported(): boolean;
begin
    Result := m_dOptions14.WriteableMSAATexturesSupported;
end;



function TD3DX12FeatureSupport.IndependentFrontAndBackStencilRefMaskSupported(): boolean;
begin
    Result := m_dOptions14.IndependentFrontAndBackStencilRefMaskSupported;
end;


// 44: Options15
function TD3DX12FeatureSupport.TriangleFanSupported(): boolean;
begin
    Result := m_dOptions15.TriangleFanSupported;
end;



function TD3DX12FeatureSupport.DynamicIndexBufferStripCutSupported(): boolean;
begin
    Result := m_dOptions15.DynamicIndexBufferStripCutSupported;
end;
{$ENDIF}

{$IFDEF D3D12_SDK_VERSION_608}
// 45: Options16
function TD3DX12FeatureSupport.DynamicDepthBiasSupported(): boolean;
begin
    Result := m_dOptions16.DynamicDepthBiasSupported;
end;
{$ENDIF}

{$IFDEF D3D12_SDK_VERSION_609}
function TD3DX12FeatureSupport.GPUUploadHeapSupported(): boolean;
begin
    Result := m_dOptions16.GPUUploadHeapSupported;
end;


// 46: Options17
function TD3DX12FeatureSupport.NonNormalizedCoordinateSamplersSupported(): boolean;
begin
    Result := m_dOptions17.NonNormalizedCoordinateSamplersSupported;
end;



function TD3DX12FeatureSupport.ManualWriteTrackingResourceSupported(): boolean;
begin
    Result := m_dOptions17.ManualWriteTrackingResourceSupported;
end;


// 47: Option18
function TD3DX12FeatureSupport.RenderPassesValid(): boolean;
begin
    Result := m_dOptions18.RenderPassesValid;
end;
{$ENDIF}

{$IFDEF D3D12_SDK_VERSION_610}
function TD3DX12FeatureSupport.MismatchingOutputDimensionsSupported(): boolean;
begin
    Result := m_dOptions19.MismatchingOutputDimensionsSupported;
end;



function TD3DX12FeatureSupport.SupportedSampleCountsWithNoOutputs(): UINT;
begin
    Result := m_dOptions19.SupportedSampleCountsWithNoOutputs;
end;



function TD3DX12FeatureSupport.PointSamplingAddressesNeverRoundUp(): boolean;
begin
    Result := m_dOptions19.PointSamplingAddressesNeverRoundUp;
end;



function TD3DX12FeatureSupport.RasterizerDesc2Supported(): boolean;
begin
    Result := m_dOptions19.RasterizerDesc2Supported;
end;



function TD3DX12FeatureSupport.NarrowQuadrilateralLinesSupported(): boolean;
begin
    Result := m_dOptions19.NarrowQuadrilateralLinesSupported;
end;



function TD3DX12FeatureSupport.AnisoFilterWithPointMipSupported(): boolean;
begin
    Result := m_dOptions19.AnisoFilterWithPointMipSupported;
end;



function TD3DX12FeatureSupport.MaxSamplerDescriptorHeapSize(): UINT;
begin
    Result := m_dOptions19.MaxSamplerDescriptorHeapSize;
end;



function TD3DX12FeatureSupport.MaxSamplerDescriptorHeapSizeWithStaticSamplers(): UINT;
begin
    Result := m_dOptions19.MaxSamplerDescriptorHeapSizeWithStaticSamplers;
end;



function TD3DX12FeatureSupport.MaxViewDescriptorHeapSize(): UINT;
begin
    Result := m_dOptions19.MaxViewDescriptorHeapSize;
end;
{$ENDIF}


{$IFDEF D3D12_SDK_VERSION_611}
// 49: Options20
function TD3DX12FeatureSupport.ComputeOnlyWriteWatchSupported(): boolean;
begin
    Result := m_dOptions20.ComputeOnlyWriteWatchSupported;
end;
{$ENDIF}

{$IFDEF D3D12_SDK_VERSION_612}
// 50: Options21
function TD3DX12FeatureSupport.ExecuteIndirectTier(): TD3D12_EXECUTE_INDIRECT_TIER;
begin
    Result := m_dOptions21.ExecuteIndirectTier;
end;



function TD3DX12FeatureSupport.WorkGraphsTier(): TD3D12_WORK_GRAPHS_TIER;
begin
    Result := m_dOptions21.WorkGraphsTier;
end;
{$ENDIF}


{$IFDEF D3D12_SDK_VERSION_617}
// 51: TightAlignment
function TD3DX12FeatureSupport.TightAlignmentSupportTier(): TD3D12_TIGHT_ALIGNMENT_TIER;
begin
    Result := m_dTightAlignment.SupportTier;
end;

function TD3DX12FeatureSupport.ShaderExecutionReorderingActuallyReorders(
  ): winbool;
begin
     Result := m_dOptions22.ShaderExecutionReorderingActuallyReorders;
end;

function TD3DX12FeatureSupport.CreateByteOffsetViewsSupported(): winbool;
begin
   Result := m_dOptions22.CreateByteOffsetViewsSupported;
end;

function TD3DX12FeatureSupport.Max1DDispatchSize(): UINT;
begin
    Result := m_dOptions22.Max1DDispatchSize;
end;

function TD3DX12FeatureSupport.Max1DDispatchMeshSize(): UINT;
begin
    Result := m_dOptions22.Max1DDispatchMeshSize;
end;

{$ENDIF}

end.
