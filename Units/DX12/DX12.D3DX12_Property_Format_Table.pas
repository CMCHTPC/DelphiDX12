unit DX12.D3DX12_Property_Format_Table;

{$IFDEF FPC}
{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}
interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D12,
    DX12.D3DCommon,
    DX12.DXGIFormat;

const
    MAP_ALIGN_REQUIREMENT = 16; // Map is required to return 16-byte aligned addresses

    NOMINMAX = 1;

type
    // ----------------------------------------------------------------------------
    // Information describing everything about a D3D Resource Format
    // ----------------------------------------------------------------------------
    {$PACKRECORDS default}
    // on 64bit, size is 40 byte, on 32bit size is 32 byte
    (*
                             32    64
     BitsPerUnit:            16    20
     WidthAligment:          20    24
     bDX9VertexOrIndexFormat 28    32
    *)
    TFORMAT_DETAIL = bitpacked record
        DXGIFormat: uint32; // TDXGI_FORMAT;  // offset 0
        ParentFormat: uint32; // TDXGI_FORMAT; // offset  4
        pDefaultFormatCastSet: PDXGI_FORMAT;  // offset 8  This is dependent on FL/driver version, but is here to save a lot of space
        BitsPerComponent: array [0..4 - 1] of uint8;  // offset 12/16 only used for D3DFTL_PARTIAL_TYPE or FULL_TYPE
        BitsPerUnit: uint8; // offset 16/20
        SRGBFormat: 0..1;  // offset +1, bit 0
        Dummy1: byte; // two bytes to keep boundaries
        Dummy2: byte;
        case integer of
            0: (BitField1: uint32;
                BitField2: uint32;
                case integer of
                    0: (
                    BoolField: SIZE_T); // 8 byte for 64 bit, 4 byte for 32 bit
                    1: (
                    bDX9VertexOrIndexFormat: 0..1; // offset 32 bit 0
                    bDX9TextureFormat: 0..1;
                    bFloatNormFormat: 0..1;
                    bPlanar: 0..1;
                    bYUV: 0..1;
                    bDependantFormatCastSet: 0..1; // This indicates that the format cast set is dependent on FL/driver version
                    bInternal: 0..1;);
            );
            1: (
                WidthAlignment: 0..15; // offset +4 bit 0..3, number of texels to align to in a mip level.
                HeightAlignment: 0..15; // offset +4 bit 4..7, Top level dimensions must be a multiple of these
                DepthAlignment: 0..1; // offset +5 bit 0, values.
                Layout: -1..0; // offset +5 bit 1
                TypeLevel: -2..0;  // offset +5 bit 2..3
                ComponentName0: -4..2; // offset +5 bit 4..6,  RED    ... only used for D3DFTL_PARTIAL_TYPE or FULL_TYPE
                ComponentName1: -4..2; // offset +5,bit 7, offset 26 bit 0..1,  GREEN  ... only used for D3DFTL_PARTIAL_TYPE or FULL_TYPE
                ComponentName2: -4..2; // offset +6, bit 2..4, BLUE   ... only used for D3DFTL_PARTIAL_TYPE or FULL_TYPE
                ComponentName3: -4..2; //offset +6, bit 5..7, ALPHA  ... only used for D3DFTL_PARTIAL_TYPE or FULL_TYPE

                ComponentInterpretation0: -4..3;  // offset +7 bit 0..2,  only used for D3DFTL_FULL_TYPE
                ComponentInterpretation1: -4..3; // offset +7 bit 3..5, only used for D3DFTL_FULL_TYPE
                Reserved1: 0..3; // placeholder offset +7 bit 6..7
                ComponentInterpretation2: -4..3; // offset +8 bit 0..2, only used for D3DFTL_FULL_TYPE
                ComponentInterpretation3: -4..3; // offset +8 bit 3..5, only used for D3DFTL_FULL_TYPE
            );

    end;

    PFORMAT_DETAIL = ^TFORMAT_DETAIL;


    { TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE }

    TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE = record
    private
        s_FormatDetail: array of TFORMAT_DETAIL;
        s_NumFormats: UINT;
        s_FormatNames: array of LPCSTR; // separate from above structure so it can be compiled out of runtime.
    private
        function GetFormatDetail(Format: TDXGI_FORMAT): PFORMAT_DETAIL;
    public
        function GetNumFormats(): UINT;
        function GetFormatTable(): PFORMAT_DETAIL;
        function GetHighestDefinedFeatureLevel(): TD3D_FEATURE_LEVEL;
        function GetFormat(Index: SIZE_T): TDXGI_FORMAT;
        function FormatExists(Format: TDXGI_FORMAT): boolean;
        function FormatExistsInHeader(Format: TDXGI_FORMAT; bExternalHeader: boolean = True): boolean;
        function GetByteAlignment(Format: TDXGI_FORMAT): UINT;
        function IsBlockCompressFormat(Format: TDXGI_FORMAT): boolean;
        function GetName(Format: TDXGI_FORMAT; bHideInternalFormats: boolean = True): LPCSTR;
        function IsSRGBFormat(Format: TDXGI_FORMAT): boolean;
        function GetBitsPerStencil(Format: TDXGI_FORMAT): UINT;
        function GetBitsPerDepth(Format: TDXGI_FORMAT): UINT;
        procedure GetFormatReturnTypes(Format: TDXGI_FORMAT; pInterpretations: PD3D_FORMAT_COMPONENT_INTERPRETATION_Array4);
        function GetNumComponentsInFormat(Format: TDXGI_FORMAT): UINT;
        function GetMinNumComponentsInFormats(FormatA: TDXGI_FORMAT; FormatB: TDXGI_FORMAT): UINT;
        // Converts the sequential component index (range from 0 to GetNumComponentsInFormat()) to
        // the absolute component index (range 0 to 3).
        function Sequential2AbsoluteComponentIndex(Format: TDXGI_FORMAT; SequentialComponentIndex: UINT): UINT;
        function CanBeCastEvenFullyTyped(Format: TDXGI_FORMAT; fl: TD3D_FEATURE_LEVEL): boolean;
        function GetAddressingBitsPerAlignedSize(Format: TDXGI_FORMAT): uint8;
        function GetParentFormat(Format: TDXGI_FORMAT): TDXGI_FORMAT;
        function GetFormatCastSet(Format: TDXGI_FORMAT): TDXGI_FORMAT;
        function GetLayout(Format: TDXGI_FORMAT): TD3D_FORMAT_LAYOUT;
        function GetTypeLevel(Format: TDXGI_FORMAT): TD3D_FORMAT_TYPE_LEVEL;
        function GetBitsPerUnit(Format: TDXGI_FORMAT): UINT;
        function GetBitsPerUnitThrow(Format: TDXGI_FORMAT): UINT;
        function GetBitsPerElement(Format: TDXGI_FORMAT): UINT;  // Legacy function used to support D3D10on9 only. Do not use.
        function GetWidthAlignment(Format: TDXGI_FORMAT): UINT;
        function GetHeightAlignment(Format: TDXGI_FORMAT): UINT;
        function GetDepthAlignment(Format: TDXGI_FORMAT): UINT;
        function Planar(Format: TDXGI_FORMAT): boolean;
        function NonOpaquePlanar(Format: TDXGI_FORMAT): boolean;
        function YUV(Format: TDXGI_FORMAT): boolean;
        function Opaque(Format: TDXGI_FORMAT): boolean;
        function FamilySupportsStencil(Format: TDXGI_FORMAT): boolean;
        function NonOpaquePlaneCount(Format: TDXGI_FORMAT): UINT;
        function DX9VertexOrIndexFormat(Format: TDXGI_FORMAT): boolean;
        function DX9TextureFormat(Format: TDXGI_FORMAT): boolean;
        function FloatNormTextureFormat(Format: TDXGI_FORMAT): boolean;
        function DepthOnlyFormat(format: TDXGI_FORMAT): boolean;
        function GetPlaneCount(Format: TDXGI_FORMAT): uint8;
        function MotionEstimatorAllowedInputFormat(Format: TDXGI_FORMAT): boolean;
        function SupportsSamplerFeedback(Format: TDXGI_FORMAT): boolean;
        function DecodeHistogramAllowedForOutputFormatSupport(Format: TDXGI_FORMAT): boolean;
        function GetPlaneSliceFromViewFormat(ResourceFormat: TDXGI_FORMAT; ViewFormat: TDXGI_FORMAT): uint8;
        function FloatAndNotFloatFormats(FormatA: TDXGI_FORMAT; FormatB: TDXGI_FORMAT): boolean;
        function SNORMAndUNORMFormats(FormatA: TDXGI_FORMAT; FormatB: TDXGI_FORMAT): boolean;
        function ValidCastToR32UAV(CastFrom: TDXGI_FORMAT; CastTo: TDXGI_FORMAT): boolean;
        function IsSupportedTextureDisplayableFormat(Format: TDXGI_FORMAT; bMediaFormatOnly: boolean): boolean;
        function GetFormatComponentInterpretation(Format: TDXGI_FORMAT; AbsoluteComponentIndex: UINT): TD3D_FORMAT_COMPONENT_INTERPRETATION;
        function GetBitsPerComponent(Format: TDXGI_FORMAT; AbsoluteComponentIndex: UINT): UINT;
        function GetComponentName(Format: TDXGI_FORMAT; AbsoluteComponentIndex: UINT): TD3D_FORMAT_COMPONENT_NAME;
        function CalculateExtraPlanarRows(format: TDXGI_FORMAT; plane0Height: UINT;
        {_Out_ } totalHeight: PUINT): HRESULT;
        function CalculateMinimumRowMajorRowPitch(Format: TDXGI_FORMAT; Width: UINT;
        {_Out_ } out RowPitch: UINT): HRESULT;
        function CalculateMinimumRowMajorSlicePitch(Format: TDXGI_FORMAT; TightRowPitch: UINT; Height: UINT;
        {_Out_ } SlicePitch: PUINT): HRESULT;
        procedure GetYCbCrChromaSubsampling(Format: TDXGI_FORMAT;
        {_Out_ } out HorizontalSubsampling: UINT;
        {_Out_ } out VerticalSubsampling: UINT);
        function CalculateResourceSize(Width: UINT; Height: UINT; depth: UINT; format: TDXGI_FORMAT; mipLevels: UINT; subresources: UINT;
        {_Out_ } totalByteSize: PSIZE_T;
        {_Out_writes_opt_(subresources) } pDst: PD3D12_MEMCPY_DEST = nil): HRESULT;
        procedure GetTileShape(pTileShape: PD3D12_TILE_SHAPE; Format: TDXGI_FORMAT; Dimension: TD3D12_RESOURCE_DIMENSION; SampleCount: UINT);
        procedure Get4KTileShape(pTileShape: PD3D12_TILE_SHAPE; Format: TDXGI_FORMAT; Dimension: TD3D12_RESOURCE_DIMENSION; SampleCount: UINT);
        procedure GetMipDimensions(mipSlice: uint8;
        {_Inout_ } pWidth: PUINT64;
        {_Inout_opt_ } pHeight: PUINT64 = nil;
        {_Inout_opt_ } pDepth: PUINT64 = nil);
        procedure GetPlaneSubsampledSizeAndFormatForCopyableLayout(PlaneSlice: UINT; Format: TDXGI_FORMAT; Width: UINT; Height: UINT;
        {_Out_ } out PlaneFormat: TDXGI_FORMAT;
        {_Out_ } out MinPlanePitchWidth: UINT;
        {_Out_ } out PlaneWidth: UINT;
        {_Out_ } out PlaneHeight: UINT);
        function GetDetailTableIndex(Format: TDXGI_FORMAT): UINT;
        function GetDetailTableIndexNoThrow(Format: TDXGI_FORMAT): UINT;
        function GetDetailTableIndexThrow(Format: TDXGI_FORMAT): UINT;
        function SupportsDepth(Format: TDXGI_FORMAT): boolean;
        function SupportsStencil(Format: TDXGI_FORMAT): boolean;
    end;

var

    D3D12_PROPERTY_LAYOUT_FORMAT_TABLE: TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE;

implementation

uses
    DX12.D3D12TokenizedProgramFormat;

const
    INTSAFE_E_ARITHMETIC_OVERFLOW = HRESULT($80070216);

    UINT_MAX = UINT($ffffffff);


    R = D3DFCN_R;
    G = D3DFCN_G;
    B = D3DFCN_B;
    A = D3DFCN_A;
    D = D3DFCN_D;
    S = D3DFCN_S;
    X = D3DFCN_X;

    _TYPELESS = D3DFCI_TYPELESS;
    _FLOAT = D3DFCI_FLOAT;
    _SNORM = D3DFCI_SNORM;
    _UNORM = D3DFCI_UNORM;
    _SINT = D3DFCI_SINT;
    _UINT = D3DFCI_UINT;
    _UNORM_SRGB = D3DFCI_UNORM_SRGB;
    _FIXED_2_8 = D3DFCI_BIASED_FIXED_2_8;


    // separate from above structure so it can be compiled out of the runtime.
    cD3D12_PROPERTY_LAYOUT_FORMAT_TABLE_FormatNames: array of LPCSTR =
        ( //   Name
        'UNKNOWN', 'R32G32B32A32_TYPELESS', 'R32G32B32A32_FLOAT', 'R32G32B32A32_UINT', 'R32G32B32A32_SINT', 'R32G32B32_TYPELESS', 'R32G32B32_FLOAT', 'R32G32B32_UINT', 'R32G32B32_SINT',
        'R16G16B16A16_TYPELESS', 'R16G16B16A16_FLOAT', 'R16G16B16A16_UNORM', 'R16G16B16A16_UINT', 'R16G16B16A16_SNORM', 'R16G16B16A16_SINT', 'R32G32_TYPELESS', 'R32G32_FLOAT', 'R32G32_UINT',
        'R32G32_SINT', 'R32G8X24_TYPELESS', 'D32_FLOAT_S8X24_UINT', 'R32_FLOAT_X8X24_TYPELESS', 'X32_TYPELESS_G8X24_UINT', 'R10G10B10A2_TYPELESS', 'R10G10B10A2_UNORM', 'R10G10B10A2_UINT',
        'R11G11B10_FLOAT', 'R8G8B8A8_TYPELESS', 'R8G8B8A8_UNORM', 'R8G8B8A8_UNORM_SRGB', 'R8G8B8A8_UINT', 'R8G8B8A8_SNORM', 'R8G8B8A8_SINT', 'R16G16_TYPELESS', 'R16G16_FLOAT', 'R16G16_UNORM',
        'R16G16_UINT', 'R16G16_SNORM', 'R16G16_SINT', 'R32_TYPELESS', 'D32_FLOAT', 'R32_FLOAT', 'R32_UINT', 'R32_SINT', 'R24G8_TYPELESS', 'D24_UNORM_S8_UINT', 'R24_UNORM_X8_TYPELESS',
        'X24_TYPELESS_G8_UINT', 'R8G8_TYPELESS', 'R8G8_UNORM', 'R8G8_UINT', 'R8G8_SNORM', 'R8G8_SINT', 'R16_TYPELESS', 'R16_FLOAT', 'D16_UNORM', 'R16_UNORM', 'R16_UINT', 'R16_SNORM',
        'R16_SINT', 'R8_TYPELESS', 'R8_UNORM', 'R8_UINT', 'R8_SNORM', 'R8_SINT', 'A8_UNORM', 'R1_UNORM', 'R9G9B9E5_SHAREDEXP', 'R8G8_B8G8_UNORM', 'G8R8_G8B8_UNORM', 'BC1_TYPELESS', 'BC1_UNORM',
        'BC1_UNORM_SRGB', 'BC2_TYPELESS', 'BC2_UNORM', 'BC2_UNORM_SRGB', 'BC3_TYPELESS', 'BC3_UNORM', 'BC3_UNORM_SRGB', 'BC4_TYPELESS', 'BC4_UNORM', 'BC4_SNORM', 'BC5_TYPELESS', 'BC5_UNORM',
        'BC5_SNORM', 'B5G6R5_UNORM', 'B5G5R5A1_UNORM', 'B8G8R8A8_UNORM', 'B8G8R8X8_UNORM', 'R10G10B10_XR_BIAS_A2_UNORM', 'B8G8R8A8_TYPELESS', 'B8G8R8A8_UNORM_SRGB', 'B8G8R8X8_TYPELESS',
        'B8G8R8X8_UNORM_SRGB', 'BC6H_TYPELESS', 'BC6H_UF16', 'BC6H_SF16', 'BC7_TYPELESS', 'BC7_UNORM', 'BC7_UNORM_SRGB', 'AYUV', 'Y410', 'Y416', 'NV12', 'P010', 'P016', '420_OPAQUE', 'YUY2',
        'Y210', 'Y216', 'NV11', 'AI44', 'IA44', 'P8', 'A8P8', 'B4G4R4A4_UNORM', '', // 116
        '', // 117
        '', // 118
        '', // 119
        '', // 120
        '', // 121
        '', // 122
        '', // 123
        '', // 124
        '', // 125
        '', // 126
        '', // 127
        '', // 128
        '', // 129

        'P208', 'V208', 'V408', '', // 133
        '', // 134
        '', // 135
        '', // 136
        '', // 137
        '', // 138
        '', // 139
        '', // 140
        '', // 141
        '', // 142
        '', // 143
        '', // 144
        '', // 145
        '', // 146
        '', // 147
        '', // 148
        '', // 149
        '', // 150
        '', // 151
        '', // 152
        '', // 153
        '', // 154
        '', // 155
        '', // 156
        '', // 157
        '', // 158
        '', // 159
        '', // 160
        '', // 161
        '', // 162
        '', // 163
        '', // 164
        '', // 165
        '', // 166
        '', // 167
        '', // 168
        '', // 169
        '', // 170
        '', // 171
        '', // 172
        '', // 173
        '', // 174
        '', // 175
        '', // 176
        '', // 177
        '', // 178
        '', // 179
        '', // 180
        '', // 181
        '', // 182
        '', // 183
        '', // 184
        '', // 185
        '', // 186
        '', // 187
        '', // 188

        'SAMPLER_FEEDBACK_MIN_MIP_OPAQUE', 'SAMPLER_FEEDBACK_MIP_REGION_USED_OPAQUE', 'A4B4G4R4_UNORM');


    // --------------------------------------------------------------------------------------------------------------------------------
    // Format Cast Sets
    // --------------------------------------------------------------------------------------------------------------------------------
    cD3DFCS_UNKNOWN: array of TDXGI_FORMAT =
        (DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );


    cD3DFCS_R32G32B32A32: array of TDXGI_FORMAT =
        (DXGI_FORMAT_R32G32B32A32_TYPELESS, DXGI_FORMAT_R32G32B32A32_FLOAT, DXGI_FORMAT_R32G32B32A32_UINT, DXGI_FORMAT_R32G32B32A32_SINT, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_R32G32B32: array of TDXGI_FORMAT =
        (DXGI_FORMAT_R32G32B32_TYPELESS, DXGI_FORMAT_R32G32B32_FLOAT, DXGI_FORMAT_R32G32B32_UINT, DXGI_FORMAT_R32G32B32_SINT, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_R16G16B16A16: array of TDXGI_FORMAT =
        (DXGI_FORMAT_R16G16B16A16_TYPELESS, DXGI_FORMAT_R16G16B16A16_FLOAT, DXGI_FORMAT_R16G16B16A16_UNORM, DXGI_FORMAT_R16G16B16A16_UINT, DXGI_FORMAT_R16G16B16A16_SNORM, DXGI_FORMAT_R16G16B16A16_SINT,
        DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_R32G32: array of TDXGI_FORMAT =
        (DXGI_FORMAT_R32G32_TYPELESS, DXGI_FORMAT_R32G32_FLOAT, DXGI_FORMAT_R32G32_UINT, DXGI_FORMAT_R32G32_SINT, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_R32G8X24: array of TDXGI_FORMAT =
        (DXGI_FORMAT_R32G8X24_TYPELESS, DXGI_FORMAT_D32_FLOAT_S8X24_UINT, DXGI_FORMAT_R32_FLOAT_X8X24_TYPELESS, DXGI_FORMAT_X32_TYPELESS_G8X24_UINT, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_R11G11B10: array of TDXGI_FORMAT =
        (DXGI_FORMAT_R11G11B10_FLOAT, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_R8G8B8A8: array of TDXGI_FORMAT =
        (DXGI_FORMAT_R8G8B8A8_TYPELESS, DXGI_FORMAT_R8G8B8A8_UNORM, DXGI_FORMAT_R8G8B8A8_UNORM_SRGB, DXGI_FORMAT_R8G8B8A8_UINT, DXGI_FORMAT_R8G8B8A8_SNORM, DXGI_FORMAT_R8G8B8A8_SINT,
        DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_R16G16: array of TDXGI_FORMAT =
        (DXGI_FORMAT_R16G16_TYPELESS, DXGI_FORMAT_R16G16_FLOAT, DXGI_FORMAT_R16G16_UNORM, DXGI_FORMAT_R16G16_UINT, DXGI_FORMAT_R16G16_SNORM, DXGI_FORMAT_R16G16_SINT, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_R32: array of TDXGI_FORMAT =
        (DXGI_FORMAT_R32_TYPELESS, DXGI_FORMAT_D32_FLOAT, DXGI_FORMAT_R32_FLOAT, DXGI_FORMAT_R32_UINT, DXGI_FORMAT_R32_SINT, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_R24G8: array of TDXGI_FORMAT =
        (DXGI_FORMAT_R24G8_TYPELESS, DXGI_FORMAT_D24_UNORM_S8_UINT, DXGI_FORMAT_R24_UNORM_X8_TYPELESS, DXGI_FORMAT_X24_TYPELESS_G8_UINT, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_R8G8: array of TDXGI_FORMAT =
        (DXGI_FORMAT_R8G8_TYPELESS, DXGI_FORMAT_R8G8_UNORM, DXGI_FORMAT_R8G8_UINT, DXGI_FORMAT_R8G8_SNORM, DXGI_FORMAT_R8G8_SINT, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_R16: array of TDXGI_FORMAT =
        (DXGI_FORMAT_R16_TYPELESS, DXGI_FORMAT_R16_FLOAT, DXGI_FORMAT_D16_UNORM, DXGI_FORMAT_R16_UNORM, DXGI_FORMAT_R16_UINT, DXGI_FORMAT_R16_SNORM, DXGI_FORMAT_R16_SINT, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_R8: array of TDXGI_FORMAT =
        (DXGI_FORMAT_R8_TYPELESS, DXGI_FORMAT_R8_UNORM, DXGI_FORMAT_R8_UINT, DXGI_FORMAT_R8_SNORM, DXGI_FORMAT_R8_SINT, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_A8: array of TDXGI_FORMAT =
        (DXGI_FORMAT_A8_UNORM, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_R1: array of TDXGI_FORMAT =
        (DXGI_FORMAT_R1_UNORM, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_R9G9B9E5: array of TDXGI_FORMAT =
        (DXGI_FORMAT_R9G9B9E5_SHAREDEXP, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_R8G8_B8G8: array of TDXGI_FORMAT =
        (DXGI_FORMAT_R8G8_B8G8_UNORM, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_G8R8_G8B8: array of TDXGI_FORMAT =
        (DXGI_FORMAT_G8R8_G8B8_UNORM, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_BC1: array of TDXGI_FORMAT =
        (DXGI_FORMAT_BC1_TYPELESS, DXGI_FORMAT_BC1_UNORM, DXGI_FORMAT_BC1_UNORM_SRGB, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_BC2: array of TDXGI_FORMAT =
        (DXGI_FORMAT_BC2_TYPELESS, DXGI_FORMAT_BC2_UNORM, DXGI_FORMAT_BC2_UNORM_SRGB, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_BC3: array of TDXGI_FORMAT =
        (DXGI_FORMAT_BC3_TYPELESS, DXGI_FORMAT_BC3_UNORM, DXGI_FORMAT_BC3_UNORM_SRGB, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_BC4: array of TDXGI_FORMAT =
        (DXGI_FORMAT_BC4_TYPELESS, DXGI_FORMAT_BC4_UNORM, DXGI_FORMAT_BC4_SNORM, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_BC5: array of TDXGI_FORMAT =
        (DXGI_FORMAT_BC5_TYPELESS, DXGI_FORMAT_BC5_UNORM, DXGI_FORMAT_BC5_SNORM, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_B5G6R5: array of TDXGI_FORMAT =
        (DXGI_FORMAT_B5G6R5_UNORM, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_B5G5R5A1: array of TDXGI_FORMAT =
        (DXGI_FORMAT_B5G5R5A1_UNORM, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_B8G8R8A8: array of TDXGI_FORMAT =
        (DXGI_FORMAT_B8G8R8A8_TYPELESS, DXGI_FORMAT_B8G8R8A8_UNORM, DXGI_FORMAT_B8G8R8A8_UNORM_SRGB, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_B8G8R8X8: array of TDXGI_FORMAT =
        (DXGI_FORMAT_B8G8R8X8_TYPELESS, DXGI_FORMAT_B8G8R8X8_UNORM, DXGI_FORMAT_B8G8R8X8_UNORM_SRGB, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_R10G10B10A2: array of TDXGI_FORMAT =
        (DXGI_FORMAT_R10G10B10A2_TYPELESS, DXGI_FORMAT_R10G10B10A2_UNORM, DXGI_FORMAT_R10G10B10A2_UINT, DXGI_FORMAT_R10G10B10_XR_BIAS_A2_UNORM, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_BC6H: array of TDXGI_FORMAT =
        (DXGI_FORMAT_BC6H_TYPELESS, DXGI_FORMAT_BC6H_UF16, DXGI_FORMAT_BC6H_SF16, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_BC7: array of TDXGI_FORMAT =
        (DXGI_FORMAT_BC7_TYPELESS, DXGI_FORMAT_BC7_UNORM, DXGI_FORMAT_BC7_UNORM_SRGB, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_AYUV: array of TDXGI_FORMAT =
        (DXGI_FORMAT_AYUV, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_NV12: array of TDXGI_FORMAT =
        (DXGI_FORMAT_NV12, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_YUY2: array of TDXGI_FORMAT =
        (DXGI_FORMAT_YUY2, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_P010: array of TDXGI_FORMAT =
        (DXGI_FORMAT_P010, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_P016: array of TDXGI_FORMAT =
        (DXGI_FORMAT_P016, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_NV11: array of TDXGI_FORMAT =
        (DXGI_FORMAT_NV11, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_420_OPAQUE: array of TDXGI_FORMAT =
        (DXGI_FORMAT_420_OPAQUE, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_Y410: array of TDXGI_FORMAT =
        (DXGI_FORMAT_Y410, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_Y416: array of TDXGI_FORMAT =
        (DXGI_FORMAT_Y416, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_Y210: array of TDXGI_FORMAT =
        (DXGI_FORMAT_Y210, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_Y216: array of TDXGI_FORMAT =
        (DXGI_FORMAT_Y216, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_AI44: array of TDXGI_FORMAT =
        (DXGI_FORMAT_AI44, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_IA44: array of TDXGI_FORMAT =
        (DXGI_FORMAT_IA44, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_P8: array of TDXGI_FORMAT =
        (DXGI_FORMAT_P8, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_A8P8: array of TDXGI_FORMAT =
        (DXGI_FORMAT_A8P8, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_B4G4R4A4: array of TDXGI_FORMAT =
        (DXGI_FORMAT_B4G4R4A4_UNORM, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_P208: array of TDXGI_FORMAT =
        (DXGI_FORMAT_P208, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_V208: array of TDXGI_FORMAT =
        (DXGI_FORMAT_V208, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3DFCS_V408: array of TDXGI_FORMAT =
        (DXGI_FORMAT_V408, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );


    cD3DFCS_A4B4G4R4: array of TDXGI_FORMAT =
        (DXGI_FORMAT_A4B4G4R4_UNORM, DXGI_FORMAT_UNKNOWN // not part of cast set, just the "null terminator"
        );

    cD3D12_PROPERTY_LAYOUT_FORMAT_TABLE_s_FormatDetail: array of TFORMAT_DETAIL =
        (
        //   DXGI_FORMAT                                           ParentFormat                              pDefaultFormatCastSet BitsPerComponent[4], BitsPerUnit,    SRGB,  WidthAlignment, HeightAlignment, DepthAlignment,   Layout,           TypeLevel,            ComponentName[4],ComponentInterpretation[4],                          bDX9VertexOrIndexFormat bDX9TextureFormat,   bFloatNormFormat, bPlanar, bYUV    bDependantFormatCastSet bInternal
        //        (DXGIFormat: ord(DXGI_FORMAT_UNKNOWN) ;ParentFormat: ord(DXGI_FORMAT_UNKNOWN);  pDefaultFormatCastSet: @cD3DFCS_UNKNOWN;   BitsPerComponent:(0,0,0,0);BitsPerUnit: 0;  SRGBFormat :  0; Dummy1:0; Dummy2:0; WidthAlignment: 1 ;HeightAlignment: 1; DepthAlignment:  1;  Layout: ord(D3DFL_CUSTOM);  TypeLevel: ord(D3DFTL_NO_TYPE);   ComponentName0:ord(X); ComponentName1: ord(X); ComponentName2: ord(X) ComponentName3: X;         _TYPELESS, _TYPELESS, _TYPELESS, _TYPELESS,          TRUE,                   FALSE,               FALSE,            FALSE,   FALSE,  FALSE,                  FALSE,    ),
        );



procedure ASSUME(x: boolean);
begin
    assert(x);
end;


// UINT addition

function Safe_UIntAdd(uAugend: UINT; uAddend: UINT; puResult: PUINT): HRESULT; inline;
begin
    if ((uAugend + uAddend) >= uAugend) then
    begin
        puResult^ := (uAugend + uAddend);
        Result := S_OK;
        Exit;
    end;
    puResult^ := UINT_MAX;
    Result := E_FAIL;
end;


// UINT multiplication

function Safe_UIntMult(uMultiplicand: UINT; uMultiplier: UINT; puResult: PUINT): HRESULT; inline;
var
    ull64Result: ULONGLONG;
begin
    ull64Result := ULONGLONG(uMultiplicand) * ULONGLONG(uMultiplier);

    if (ull64Result <= UINT_MAX) then
    begin
        puResult^ := UINT(ull64Result);
        Result := S_OK;
        Exit;
    end;
    puResult^ := UINT_MAX;
    Result := E_FAIL;
end;

//----------------------------------------------------------------------------
// DivideAndRoundUp
function DivideAndRoundUp(dividend: UINT; divisor: UINT; {_Out_}  DivResult: PUINT): HRESULT; inline;
var
    adjustedDividend: UINT;
begin
    Result := Safe_UIntAdd(dividend, (divisor - 1), @adjustedDividend);

    if SUCCEEDED(Result) then
        DivResult^ := (adjustedDividend div divisor)
    else
        DivResult^ := 0;
end;



function IsPow2(Val: UINT): boolean; inline;
begin
    Result := (0 = (Val and (Val - 1)));
end;


{ TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE }

//---------------------------------------------------------------------------------------------------------------------------------
// GetFormatDetail
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetFormatDetail(Format: TDXGI_FORMAT): PFORMAT_DETAIL;
var
    Index: UINT;
begin
    Index := GetDetailTableIndex(Format);
    if (UINT(-1) = Index) then
    begin
        Result := nil;
        Exit;
    end;

    Result := @s_FormatDetail[Index];
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetNumFormats
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetNumFormats(): UINT;
begin
    Result := s_NumFormats;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetFormatTable
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetFormatTable(): PFORMAT_DETAIL;
begin
    Result := @s_FormatDetail[0];
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetHighestDefinedFeatureLevel
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetHighestDefinedFeatureLevel(): TD3D_FEATURE_LEVEL;
begin
    Result := D3D_FEATURE_LEVEL_12_2;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetFormat
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetFormat(Index: SIZE_T): TDXGI_FORMAT;
begin
    if (Index < GetNumFormats()) then
    begin
        Result := TDXGI_FORMAT(s_FormatDetail[Index].DXGIFormat);
        Exit;
    end;

    Result := TDXGI_FORMAT(-1);
end;


//---------------------------------------------------------------------------------------------------------------------------------
// FormatExists
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.FormatExists(Format: TDXGI_FORMAT): boolean;
begin
    Result := GetFormat(Ord(Format)) <> TDXGI_FORMAT(-1);
end;


//---------------------------------------------------------------------------------------------------------------------------------
// FormatExistsInHeader
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.FormatExistsInHeader(Format: TDXGI_FORMAT; bExternalHeader: boolean): boolean;
var
    Index: UINT;
begin
    Index := GetDetailTableIndex(Format);
    if ((UINT(-1) = Index) or ((bExternalHeader and (GetFormatDetail(Format)^.bInternal = 1)))) then
        Result := False
    else
        Result := True;

end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetByteAlignment
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetByteAlignment(Format: TDXGI_FORMAT): UINT;
var
    bits: UINT;
begin
    bits := GetBitsPerUnit(Format);
    if (not IsBlockCompressFormat(Format)) then
    begin
        bits := bits * GetWidthAlignment(Format) * GetHeightAlignment(Format) * GetDepthAlignment(Format);
    end;
    assert((bits and $7) = 0); // Unit must be byte-aligned
    Result := bits shr 3;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// IsBlockCompressFormat - returns true if format is block compressed. This function is a helper function for GetBitsPerUnit and
// if this function returns true then GetBitsPerUnit returns block size.
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.IsBlockCompressFormat(Format: TDXGI_FORMAT): boolean;
begin
    // Returns true if BC1, BC2, BC3, BC4, BC5, BC6, BC7, or ASTC
    Result := ((Format >= DXGI_FORMAT_BC1_TYPELESS) and (Format <= DXGI_FORMAT_BC5_SNORM)) or ((Format >= DXGI_FORMAT_BC6H_TYPELESS) and (Format <= DXGI_FORMAT_BC7_UNORM_SRGB));
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetName
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetName(Format: TDXGI_FORMAT; bHideInternalFormats: boolean): LPCSTR;
var
    Index: UINT;
begin
    Index := GetDetailTableIndex(Format);
    if ((UINT(-1) = Index) or ((bHideInternalFormats and (GetFormatDetail(Format)^.bInternal = 1))) or (s_FormatNames[Index] = '')) then
        Result := 'Unrecognized'
    else
        Result := s_FormatNames[Index];
end;


//---------------------------------------------------------------------------------------------------------------------------------
// IsSRGBFormat
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.IsSRGBFormat(Format: TDXGI_FORMAT): boolean;
var
    Index: UINT;
begin
    Index := GetDetailTableIndex(Format);
    if (UINT(-1) = Index) then
    begin
        Result := False;
        Exit;
    end;

    Result := (s_FormatDetail[Index].SRGBFormat = 1);
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetBitsPerStencil
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetBitsPerStencil(Format: TDXGI_FORMAT): UINT;
var
    Index: UINT;
    comp: UINT;
    Name: TD3D_FORMAT_COMPONENT_NAME;
begin
    Index := GetDetailTableIndexThrow(Format);
    if ((s_FormatDetail[Index].TypeLevel <> Ord(D3DFTL_PARTIAL_TYPE)) and (s_FormatDetail[Index].TypeLevel <> Ord(D3DFTL_FULL_TYPE))) then
    begin
        Result := 0;
        Exit;
    end;
    for  comp := 0 to 3 do
    begin
        Name := D3DFCN_D;
        case (comp) of
            0: Name := TD3D_FORMAT_COMPONENT_NAME(s_FormatDetail[Index].ComponentName0);
            1: Name := TD3D_FORMAT_COMPONENT_NAME(s_FormatDetail[Index].ComponentName1);
            2: Name := TD3D_FORMAT_COMPONENT_NAME(s_FormatDetail[Index].ComponentName2);
            3: Name := TD3D_FORMAT_COMPONENT_NAME(s_FormatDetail[Index].ComponentName3);
        end;
        if (Name = D3DFCN_S) then
        begin
            Result := s_FormatDetail[Index].BitsPerComponent[comp];
            Exit;
        end;
    end;
    Result := 0;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetBitsPerDepth
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetBitsPerDepth(Format: TDXGI_FORMAT): UINT;
var
    Index: UINT;
    Name: TD3D_FORMAT_COMPONENT_NAME;
    comp: UINT;
begin
    Index := GetDetailTableIndexThrow(Format);
    if ((s_FormatDetail[Index].TypeLevel <> Ord(D3DFTL_PARTIAL_TYPE)) and (s_FormatDetail[Index].TypeLevel <> Ord(D3DFTL_FULL_TYPE))) then
    begin
        Result := 0;
        Exit;
    end;
    for  comp := 0 to 3 do
    begin

        Name := D3DFCN_D;
        case (comp) of

            0: Name := TD3D_FORMAT_COMPONENT_NAME(s_FormatDetail[Index].ComponentName0);
            1: Name := TD3D_FORMAT_COMPONENT_NAME(s_FormatDetail[Index].ComponentName1);
            2: Name := TD3D_FORMAT_COMPONENT_NAME(s_FormatDetail[Index].ComponentName2);
            3: Name := TD3D_FORMAT_COMPONENT_NAME(s_FormatDetail[Index].ComponentName3);
        end;
        if (Name = D3DFCN_D) then
        begin
            Result := s_FormatDetail[Index].BitsPerComponent[comp];
            Exit;
        end;
    end;
    Result := 0;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetFormatReturnTypes
// return array with 4 entries
procedure TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetFormatReturnTypes(Format: TDXGI_FORMAT; pInterpretations: PD3D_FORMAT_COMPONENT_INTERPRETATION_Array4);
var
    Index: UINT;
begin
    Index := GetDetailTableIndexThrow(Format);
    pInterpretations^[Ord(D3D10_SB_4_COMPONENT_R)] := TD3D_FORMAT_COMPONENT_INTERPRETATION(s_FormatDetail[Index].ComponentInterpretation0);
    pInterpretations^[Ord(D3D10_SB_4_COMPONENT_G)] := TD3D_FORMAT_COMPONENT_INTERPRETATION(s_FormatDetail[Index].ComponentInterpretation1);
    pInterpretations^[Ord(D3D10_SB_4_COMPONENT_B)] := TD3D_FORMAT_COMPONENT_INTERPRETATION(s_FormatDetail[Index].ComponentInterpretation2);
    pInterpretations^[Ord(D3D10_SB_4_COMPONENT_A)] := TD3D_FORMAT_COMPONENT_INTERPRETATION(s_FormatDetail[Index].ComponentInterpretation3);
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetNumComponentsInFormat
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetNumComponentsInFormat(Format: TDXGI_FORMAT): UINT;
var
    n: UINT = 0;
    Index: UINT;
    comp: UINT;
    Name: TD3D_FORMAT_COMPONENT_NAME;
begin

    Index := GetDetailTableIndexThrow(Format);
    for comp := 0 to 3 do
    begin
        Name := D3DFCN_D;
        case (comp) of
            0: Name := TD3D_FORMAT_COMPONENT_NAME(s_FormatDetail[Index].ComponentName0);
            1: Name := TD3D_FORMAT_COMPONENT_NAME(s_FormatDetail[Index].ComponentName1);
            2: Name := TD3D_FORMAT_COMPONENT_NAME(s_FormatDetail[Index].ComponentName2);
            3: Name := TD3D_FORMAT_COMPONENT_NAME(s_FormatDetail[Index].ComponentName3);
        end;
        if (Name <> D3DFCN_X) then
        begin
            Inc(n);
        end;
    end;
    Result := n;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetMinNumComponentsInFormats
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetMinNumComponentsInFormats(FormatA: TDXGI_FORMAT; FormatB: TDXGI_FORMAT): UINT;
var
    NumComponentsFormatA: UINT;
    NumComponentsFormatB: UINT;
begin
    NumComponentsFormatA := GetNumComponentsInFormat(FormatA);
    NumComponentsFormatB := GetNumComponentsInFormat(FormatB);
    if (NumComponentsFormatA < NumComponentsFormatB) then
        Result := NumComponentsFormatA
    else
        Result := NumComponentsFormatB;

end;


//---------------------------------------------------------------------------------------------------------------------------------
// Sequential2AbsoluteComponentIndex
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.Sequential2AbsoluteComponentIndex(Format: TDXGI_FORMAT; SequentialComponentIndex: UINT): UINT;
var
    n: UINT = 0;
    Index: UINT;
    comp: UINT;
    Name: TD3D_FORMAT_COMPONENT_NAME;
begin

    Index := GetDetailTableIndexThrow(Format);
    for   comp := 0 to 3 do
    begin
        Name := TD3D_FORMAT_COMPONENT_NAME(0);
        case (comp) of

            0: Name := TD3D_FORMAT_COMPONENT_NAME(s_FormatDetail[Index].ComponentName0);
            1: Name := TD3D_FORMAT_COMPONENT_NAME(s_FormatDetail[Index].ComponentName1);
            2: Name := TD3D_FORMAT_COMPONENT_NAME(s_FormatDetail[Index].ComponentName2);
            3: Name := TD3D_FORMAT_COMPONENT_NAME(s_FormatDetail[Index].ComponentName3);
        end;
        if (Name <> D3DFCN_X) then
        begin
            if (SequentialComponentIndex = n) then
            begin
                Result := comp;
                Exit;
            end;
            Inc(n);
        end;
    end;
    Result := UINT(-1);
end;


//---------------------------------------------------------------------------------------------------------------------------------
// CanBeCastEvenFullyTyped
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.CanBeCastEvenFullyTyped(Format: TDXGI_FORMAT; fl: TD3D_FEATURE_LEVEL): boolean;
begin
    //SRGB can be cast away/back, and XR_BIAS can be cast to/from UNORM
    case (fl) of

        D3D_FEATURE_LEVEL_1_0_GENERIC,
        D3D_FEATURE_LEVEL_1_0_CORE:
        begin
            Result := False;
            Exit;
        end;

    end;
    case (Format) of
        DXGI_FORMAT_R8G8B8A8_UNORM,
        DXGI_FORMAT_R8G8B8A8_UNORM_SRGB,
        DXGI_FORMAT_B8G8R8A8_UNORM,
        DXGI_FORMAT_B8G8R8A8_UNORM_SRGB:
        begin
            Result := True;
            Exit;
        end;
        DXGI_FORMAT_R10G10B10A2_UNORM,
        DXGI_FORMAT_R10G10B10_XR_BIAS_A2_UNORM:
        begin
            Result := (fl >= D3D_FEATURE_LEVEL_10_0);
        end;

        else
            Result := False;
    end;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetAddressingBitsPerAlignedSize
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetAddressingBitsPerAlignedSize(Format: TDXGI_FORMAT): uint8;
var
    byteAlignment: UINT;
    addressBitsPerElement: uint8 = 0;
begin
    byteAlignment := GetByteAlignment(Format);
    case (byteAlignment) of
        1: addressBitsPerElement := 0;
        2: addressBitsPerElement := 1;
        4: addressBitsPerElement := 2;
        8: addressBitsPerElement := 3;
        16: addressBitsPerElement := 4;
            // The format is not supported
        else
            addressBitsPerElement := uint8(-1);
    end;
    Result := addressBitsPerElement;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetParentFormat
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetParentFormat(Format: TDXGI_FORMAT): TDXGI_FORMAT;
begin
    Result := TDXGI_FORMAT(s_FormatDetail[Ord(Format)].ParentFormat);
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetFormatCastSet
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetFormatCastSet(Format: TDXGI_FORMAT): TDXGI_FORMAT;
begin
    Result := TDXGI_FORMAT(s_FormatDetail[Ord(Format)].pDefaultFormatCastSet^);
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetLayout
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetLayout(Format: TDXGI_FORMAT): TD3D_FORMAT_LAYOUT;
begin
    Result := TD3D_FORMAT_LAYOUT(s_FormatDetail[GetDetailTableIndexNoThrow(Format)].Layout);
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetTypeLevel
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetTypeLevel(Format: TDXGI_FORMAT): TD3D_FORMAT_TYPE_LEVEL;
begin
    Result := TD3D_FORMAT_TYPE_LEVEL(s_FormatDetail[GetDetailTableIndexNoThrow(Format)].TypeLevel);
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetBitsPerUnit - returns bits per pixel unless format is a block compress format then it returns bits per block.
// use IsBlockCompressFormat() to determine if block size is returned.
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetBitsPerUnit(Format: TDXGI_FORMAT): UINT;
begin
    Result := s_FormatDetail[GetDetailTableIndexNoThrow(Format)].BitsPerUnit;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetBitsPerUnitThrow
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetBitsPerUnitThrow(Format: TDXGI_FORMAT): UINT;
begin
    Result := s_FormatDetail[GetDetailTableIndexThrow(Format)].BitsPerUnit;
end;


// Legacy function used to support D3D10on9 only. Do not use.
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetBitsPerElement(Format: TDXGI_FORMAT): UINT;
begin

end;



function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetWidthAlignment(Format: TDXGI_FORMAT): UINT;
begin
    Result := s_FormatDetail[GetDetailTableIndexNoThrow(Format)].WidthAlignment;
end;



function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetHeightAlignment(Format: TDXGI_FORMAT): UINT;
begin
    Result := s_FormatDetail[GetDetailTableIndexNoThrow(Format)].HeightAlignment;
end;



function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetDepthAlignment(Format: TDXGI_FORMAT): UINT;
begin
    Result := s_FormatDetail[GetDetailTableIndexNoThrow(Format)].DepthAlignment;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// Planar
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.Planar(Format: TDXGI_FORMAT): boolean;
begin
    Result := s_FormatDetail[GetDetailTableIndexNoThrow(Format)].bPlanar = 1;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// Non-opaque Planar
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.NonOpaquePlanar(Format: TDXGI_FORMAT): boolean;
begin
    Result := Planar(Format) and not Opaque(Format);
end;


//---------------------------------------------------------------------------------------------------------------------------------
// YUV
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.YUV(Format: TDXGI_FORMAT): boolean;
begin
    Result := s_FormatDetail[GetDetailTableIndexNoThrow(Format)].bYUV = 1;
end;



function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.Opaque(Format: TDXGI_FORMAT): boolean;
begin
    Result := (Format = DXGI_FORMAT_420_OPAQUE);
end;


//---------------------------------------------------------------------------------------------------------------------------------
// Format family supports stencil
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.FamilySupportsStencil(Format: TDXGI_FORMAT): boolean;
begin
    case (GetParentFormat(Format)) of
        DXGI_FORMAT_R32G8X24_TYPELESS,
        DXGI_FORMAT_R24G8_TYPELESS:
            Result := True;
        else
            Result := False;
    end;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// Plane count for non-opaque planar formats
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.NonOpaquePlaneCount(Format: TDXGI_FORMAT): UINT;
begin
    if (not NonOpaquePlanar(Format)) then
    begin
        Result := 1;
        Exit;
    end;

    // V208 and V408 are the only 3-plane formats.
    if ((Format = DXGI_FORMAT_V208) or (Format = DXGI_FORMAT_V408)) then
        Result := 3
    else
        Result := 2;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// DX9VertexOrIndexFormat
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.DX9VertexOrIndexFormat(Format: TDXGI_FORMAT): boolean;
begin
    Result := s_FormatDetail[GetDetailTableIndexThrow(Format)].bDX9VertexOrIndexFormat = 1;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// DX9TextureFormat
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.DX9TextureFormat(Format: TDXGI_FORMAT): boolean;
begin
    Result := s_FormatDetail[GetDetailTableIndexThrow(Format)].bDX9TextureFormat = 1;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// FloatNormTextureFormat
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.FloatNormTextureFormat(Format: TDXGI_FORMAT): boolean;
begin
    Result := s_FormatDetail[GetDetailTableIndexThrow(Format)].bFloatNormFormat = 1;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// Depth Only Format
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.DepthOnlyFormat(format: TDXGI_FORMAT): boolean;
begin
    case (Format) of
        DXGI_FORMAT_D32_FLOAT,
        DXGI_FORMAT_D16_UNORM:
            Result := True;
        else
            Result := False;
    end;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetPlaneCount
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetPlaneCount(Format: TDXGI_FORMAT): uint8;
begin
    case (GetParentFormat(Format)) of

        DXGI_FORMAT_NV12,
        DXGI_FORMAT_NV11,
        DXGI_FORMAT_P208,
        DXGI_FORMAT_P016,
        DXGI_FORMAT_P010,
        DXGI_FORMAT_R24G8_TYPELESS,
        DXGI_FORMAT_R32G8X24_TYPELESS:
            Result := 2;
        DXGI_FORMAT_V208,
        DXGI_FORMAT_V408:
            Result := 3;
        else
            Result := 1;
    end;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// Formats allowed by runtime for decode histogram.  Scopes to tested formats.
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.MotionEstimatorAllowedInputFormat(Format: TDXGI_FORMAT): boolean;
begin
    Result := Format = DXGI_FORMAT_NV12;
end;



function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.SupportsSamplerFeedback(Format: TDXGI_FORMAT): boolean;
begin
    case (Format) of
        DXGI_FORMAT_SAMPLER_FEEDBACK_MIN_MIP_OPAQUE,
        DXGI_FORMAT_SAMPLER_FEEDBACK_MIP_REGION_USED_OPAQUE:
            Result := True;
        else
            Result := False;
    end;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// Formats allowed by runtime for decode histogram.
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.DecodeHistogramAllowedForOutputFormatSupport
    (Format: TDXGI_FORMAT): boolean;
begin
    Result := (
        (* YUV 4:2:0 *)
        Format = DXGI_FORMAT_NV12) or (Format = DXGI_FORMAT_P010) or (Format = DXGI_FORMAT_P016)
        (* YUV 4:2:2 *) or (Format = DXGI_FORMAT_YUY2) or (Format = DXGI_FORMAT_Y210) or (Format = DXGI_FORMAT_Y216)
        (* YUV 4:4:4 *) or (Format = DXGI_FORMAT_AYUV) or (Format = DXGI_FORMAT_Y410) or (Format = DXGI_FORMAT_Y416);
end;


//----------------------------------------------------------------------------------------------------------------------------------
// GetPlaneSliceFromViewFormat
// Maps resource format + view format to a plane index for resource formats where the plane index can be inferred from this information.
// For planar formats where the plane index is ambiguous given this information (examples: V208, V408), this function returns 0.
// This function returns 0 for non-planar formats.
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetPlaneSliceFromViewFormat(ResourceFormat: TDXGI_FORMAT; ViewFormat: TDXGI_FORMAT): uint8;
begin
    Result := 0;
    case (GetParentFormat(ResourceFormat)) of

        DXGI_FORMAT_R24G8_TYPELESS:
        begin
            case (ViewFormat) of

                DXGI_FORMAT_R24_UNORM_X8_TYPELESS:
                    Result := 0;
                DXGI_FORMAT_X24_TYPELESS_G8_UINT:
                    Result := 1;
                else
                    ASSUME(False);
            end;
        end;
        DXGI_FORMAT_R32G8X24_TYPELESS:
        begin
            case (ViewFormat) of

                DXGI_FORMAT_R32_FLOAT_X8X24_TYPELESS:
                    Result := 0;
                DXGI_FORMAT_X32_TYPELESS_G8X24_UINT:
                    Result := 1;
                else
                    ASSUME(False);
            end;
        end;
        DXGI_FORMAT_NV12,
        DXGI_FORMAT_NV11,
        DXGI_FORMAT_P208:
        begin
            case (ViewFormat) of

                DXGI_FORMAT_R8_UNORM,
                DXGI_FORMAT_R8_UINT:
                    Result := 0;
                DXGI_FORMAT_R8G8_UNORM,
                DXGI_FORMAT_R8G8_UINT:
                    Result := 1;
                else
                    ASSUME(False);
            end;
        end;
        DXGI_FORMAT_P016,
        DXGI_FORMAT_P010:
        begin
            case (ViewFormat) of

                DXGI_FORMAT_R16_UNORM,
                DXGI_FORMAT_R16_UINT:
                    Result := 0;
                DXGI_FORMAT_R16G16_UNORM,
                DXGI_FORMAT_R16G16_UINT,
                DXGI_FORMAT_R32_UINT:
                    Result := 1;
                else
                    ASSUME(False);
            end;
        end;
    end;
end;



function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.FloatAndNotFloatFormats(FormatA: TDXGI_FORMAT; FormatB: TDXGI_FORMAT): boolean;
var
    NumComponents: UINT;
    c: UINT;
    fciA: TD3D_FORMAT_COMPONENT_INTERPRETATION;
    fciB: TD3D_FORMAT_COMPONENT_INTERPRETATION;
begin
    NumComponents := GetMinNumComponentsInFormats(FormatA, FormatB);
    for  c := 0 to NumComponents - 1 do
    begin
        fciA := GetFormatComponentInterpretation(FormatA, c);
        fciB := GetFormatComponentInterpretation(FormatB, c);
        if ((fciA <> fciB) and ((fciA = D3DFCI_FLOAT) or (fciB = D3DFCI_FLOAT))) then
        begin
            Result := True;
            Exit;
        end;
    end;
    Result := False;
end;



function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.SNORMAndUNORMFormats(FormatA: TDXGI_FORMAT; FormatB: TDXGI_FORMAT): boolean;
var
    NumComponents: UINT;
    c: UINT;
    fciA: TD3D_FORMAT_COMPONENT_INTERPRETATION;
    fciB: TD3D_FORMAT_COMPONENT_INTERPRETATION;
begin
    NumComponents := GetMinNumComponentsInFormats(FormatA, FormatB);
    for c := 0 to NumComponents - 1 do
    begin
        fciA := GetFormatComponentInterpretation(FormatA, c);
        fciB := GetFormatComponentInterpretation(FormatB, c);
        if (((fciA = D3DFCI_SNORM) and (fciB = D3DFCI_UNORM)) or ((fciB = D3DFCI_SNORM) and (fciA = D3DFCI_UNORM))) then
        begin
            Result := True;
            Exit;
        end;
    end;
    Result := False;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// ValidCastToR32UAV

// D3D11 has a limitation on typed UAVs (e.g. Texture1D/2D/3D) whereby the only format that can be read is R32_*.  Lots of formats
// can be written though, with type conversion (e.g. R8G8B8A8_*).  If an API user wants to do image processing in-place, in either
// the Compute Shader or the Pixel Shader, the only format available is R32_* (since it can be read and written at the same time).

// We were able to allow resources (Texture1D/2D/3D), created with a format from a small set of families that have 32 bits per element
// (such as R8G8B8A8_TYPELESS), to be cast to R32_* when creating a UAV.  This means the Compute Shader or Pixel Shader can
// do simultaneous read+write on the resource when bound as an R32_* UAV, with the caveat that the shader code has to do manual
// type conversion manually, but later on the resource can be used as an SRV or RT as the desired type (e.g. R8G8B8A8_UNORM), and
// thus have access to filtering/blending where the hardware knows what the format is.

// If we didn't have this ability to cast some formats to R32_* UAVs, applications would have to keep an extra allocation around
// and do a rendering pass that copies from the R32_* UAV to whatever typed resource they really wanted.  For formats not included
// in this list, such as any format that doesn't have 32-bits per component, as well as some 32-bit per component formats like
// R24G8 or R11G11B10_FLOAT there is no alternative for an application but to do the extra copy as mentioned, or avoid in-place
// image editing in favor of ping-ponging between buffers with multiple passes.

function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.ValidCastToR32UAV(CastFrom: TDXGI_FORMAT; CastTo: TDXGI_FORMAT): boolean;
begin
    // Allow casting of 32 bit formats to R32_*
    if (((CastTo = DXGI_FORMAT_R32_UINT) or (CastTo = DXGI_FORMAT_R32_SINT) or (CastTo = DXGI_FORMAT_R32_FLOAT)) and ((CastFrom = DXGI_FORMAT_R10G10B10A2_TYPELESS) or (CastFrom =
        DXGI_FORMAT_R8G8B8A8_TYPELESS) or (CastFrom = DXGI_FORMAT_B8G8R8A8_TYPELESS) or (CastFrom = DXGI_FORMAT_B8G8R8X8_TYPELESS) or (CastFrom = DXGI_FORMAT_R16G16_TYPELESS) or (CastFrom = DXGI_FORMAT_R32_TYPELESS))) then
    begin
        Result := True;
        Exit;
    end;
    Result := False;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// IsSupportedTextureDisplayableFormat

// List of formats associated with Feature_D3D1XDisplayable
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.IsSupportedTextureDisplayableFormat
    (Format: TDXGI_FORMAT; bMediaFormatOnly: boolean): boolean;
begin
    if (bMediaFormatOnly) then
    begin
        Result := (False or ((Format = DXGI_FORMAT_NV12) or (Format = DXGI_FORMAT_YUY2)));
        Exit;
    end
    else
    begin
        Result := (False // eases evolution
            or ((Format = DXGI_FORMAT_B8G8R8A8_UNORM) or (Format = DXGI_FORMAT_R8G8B8A8_UNORM) or (Format = DXGI_FORMAT_R16G16B16A16_FLOAT) or (Format = DXGI_FORMAT_R10G10B10A2_UNORM) or
            (Format = DXGI_FORMAT_NV12) or (Format = DXGI_FORMAT_YUY2)));
    end;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetFormatComponentInterpretation
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetFormatComponentInterpretation(Format: TDXGI_FORMAT; AbsoluteComponentIndex: UINT): TD3D_FORMAT_COMPONENT_INTERPRETATION;
var
    interp: TD3D_FORMAT_COMPONENT_INTERPRETATION;
begin
    case (AbsoluteComponentIndex) of
        0: interp := TD3D_FORMAT_COMPONENT_INTERPRETATION(s_FormatDetail[GetDetailTableIndexNoThrow(Format)].ComponentInterpretation0);
        1: interp := TD3D_FORMAT_COMPONENT_INTERPRETATION(s_FormatDetail[GetDetailTableIndexNoThrow(Format)].ComponentInterpretation1);
        2: interp := TD3D_FORMAT_COMPONENT_INTERPRETATION(s_FormatDetail[GetDetailTableIndexNoThrow(Format)].ComponentInterpretation2);
        3: interp := TD3D_FORMAT_COMPONENT_INTERPRETATION(s_FormatDetail[GetDetailTableIndexNoThrow(Format)].ComponentInterpretation3);
    end;
    Result := interp;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetBitsPerComponent
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetBitsPerComponent(Format: TDXGI_FORMAT; AbsoluteComponentIndex: UINT): UINT;
begin
    if (AbsoluteComponentIndex > 3) then
    begin
        Result := UINT(-1);
        Exit;
    end;
    Result := s_FormatDetail[GetDetailTableIndexNoThrow(Format)].BitsPerComponent[AbsoluteComponentIndex];
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetComponentName
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetComponentName(Format: TDXGI_FORMAT; AbsoluteComponentIndex: UINT): TD3D_FORMAT_COMPONENT_NAME;
var
    Name: TD3D_FORMAT_COMPONENT_NAME;
begin
    case (AbsoluteComponentIndex) of
        0: Name := TD3D_FORMAT_COMPONENT_NAME(s_FormatDetail[GetDetailTableIndexNoThrow(Format)].ComponentName0);
        1: Name := TD3D_FORMAT_COMPONENT_NAME(s_FormatDetail[GetDetailTableIndexNoThrow(Format)].ComponentName1);
        2: Name := TD3D_FORMAT_COMPONENT_NAME(s_FormatDetail[GetDetailTableIndexNoThrow(Format)].ComponentName2);
        3: Name := TD3D_FORMAT_COMPONENT_NAME(s_FormatDetail[GetDetailTableIndexNoThrow(Format)].ComponentName3);
    end;
    Result := Name;
end;


//----------------------------------------------------------------------------
// CalculateExtraPlanarRows
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.CalculateExtraPlanarRows(format: TDXGI_FORMAT; plane0Height: UINT; totalHeight: PUINT): HRESULT;
var
    extraHalfHeight: UINT;
    round: UINT;
    extraPlaneHeight: UINT;
begin
    if (not Planar(format)) then
    begin
        totalHeight^ := plane0Height;
        Result := S_OK;
    end;

    // blockWidth, blockHeight, and blockSize only reflect the size of plane 0.  Each planar format has additonal planes that must
    // be counted.  Each format increases size by another 0.5x, 1x, or 2x.  Grab the number of "half allocation" increments so integer
    // math can be used to calculate the extra size.


    case (GetParentFormat(format)) of

        DXGI_FORMAT_NV12,
        DXGI_FORMAT_P010,
        DXGI_FORMAT_P016,
        DXGI_FORMAT_420_OPAQUE:
        begin
            extraHalfHeight := 1;
            round := 1;
        end;

        DXGI_FORMAT_NV11, DXGI_FORMAT_P208:
        begin
            extraHalfHeight := 2;
            round := 0;
        end;
        DXGI_FORMAT_V208:
        begin
            extraHalfHeight := 2;
            round := 1;
        end;

        DXGI_FORMAT_V408:
        begin
            extraHalfHeight := 4;
            round := 0;
        end;

        DXGI_FORMAT_R24G8_TYPELESS,
        DXGI_FORMAT_R32G8X24_TYPELESS:
        begin
            totalHeight^ := plane0Height;
            Result := S_OK;
            Exit;
        end;
        else
        begin
            assert(False);
            Result := S_OK;
            exit;
        end;
    end;


    if (FAILED(Safe_UIntMult(plane0Height, extraHalfHeight, @extraPlaneHeight)) or FAILED(Safe_UIntAdd(extraPlaneHeight, round, @extraPlaneHeight)) or FAILED(Safe_UIntAdd(plane0Height, (extraPlaneHeight shr 1), @totalHeight))) then
    begin
        Result := INTSAFE_E_ARITHMETIC_OVERFLOW;
        Exit;
    end;

    Result := S_OK;
end;


// This helper function calculates the Row Pitch for a given format. For Planar formats this function returns
// the row major RowPitch of the resource. The RowPitch is the same for all the planes. For Planar
// also use the CalculateExtraPlanarRows function to calculate the corresonding height or use the CalculateMinimumRowMajorSlicePitch
// function. For Block Compressed Formats, this function returns the RowPitch of a row of blocks. For packed subsampled formats and other formats,
// this function returns the row pitch of one single row of pixels.
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.CalculateMinimumRowMajorRowPitch(Format: TDXGI_FORMAT; Width: UINT; {_out_} out RowPitch: UINT): HRESULT;
var
    NumUnits: UINT;
    WidthAlignment: UINT;
    Mask: UINT;
begin
    // Early out for DXGI_FORMAT_UNKNOWN special case.
    if (Format = DXGI_FORMAT_UNKNOWN) then
    begin
        RowPitch := Width;
        Result := S_OK;
        Exit;
    end;

    WidthAlignment := GetWidthAlignment(Format);


    if (IsBlockCompressFormat(Format)) then
    begin
        // This function calculates the minimum stride needed for a block row when the format
        // is block compressed.The GetBitsPerUnit value stored in the format table indicates
        // the size of a compressed block for block compressed formats.
        assert(WidthAlignment <> 0);
        if (FAILED(DivideAndRoundUp(Width, WidthAlignment, @NumUnits))) then
        begin
            Result := INTSAFE_E_ARITHMETIC_OVERFLOW;
            Exit;
        end;
    end
    else
    begin
        // All other formats must have strides aligned to their width alignment requirements.
        // The Width may not be aligned to the WidthAlignment.  This is not an error for this
        // function as we expect to allow formats like NV12 to have odd dimensions in the future.

        // The following alignement code expects only pow2 alignment requirements.  Only block
        // compressed formats currently have non-pow2 alignment requriements.
        assert(IsPow2(WidthAlignment));

        Mask := WidthAlignment - 1;
        if (FAILED(Safe_UIntAdd(Width, Mask, @NumUnits))) then
        begin
            Result := INTSAFE_E_ARITHMETIC_OVERFLOW;
            Exit;
        end;

        NumUnits := NumUnits and not Mask;
    end;

    if (FAILED(Safe_UIntMult(NumUnits, GetBitsPerUnit(Format), @RowPitch))) then
    begin
        Result := INTSAFE_E_ARITHMETIC_OVERFLOW;
        Exit;
    end;

    // This must to always be Byte aligned.
    assert((RowPitch and 7) = 0);
    RowPitch := RowPitch shr 3;

    Result := S_OK;
end;


// This helper function calculates the SlicePitch for a given format. For Planar formats the slice pitch includes the extra
// planes.
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.CalculateMinimumRowMajorSlicePitch(Format: TDXGI_FORMAT; TightRowPitch: UINT; Height: UINT; SlicePitch: PUINT): HRESULT;
var
    HeightOfPacked: UINT;
    PlanarHeight: UINT;
    HeightAlignment: UINT;
begin
    if (Planar(Format)) then
    begin

        if (FAILED(CalculateExtraPlanarRows(Format, Height, @PlanarHeight))) then
        begin
            Result := INTSAFE_E_ARITHMETIC_OVERFLOW;
            Exit;
        end;

        Result := Safe_UIntMult(TightRowPitch, PlanarHeight, @SlicePitch);
        exit;
    end
    else if (Format = DXGI_FORMAT_UNKNOWN) then
    begin
        Result := Safe_UIntMult(TightRowPitch, Height, SlicePitch);
        Exit;
    end;

    HeightAlignment := GetHeightAlignment(Format);

    // Caution assert to make sure that no new format breaks this assumption that all HeightAlignment formats are BC or Planar.
    // This is to make sure that Height handled correctly for this calculation.
    assert((HeightAlignment = 1) or IsBlockCompressFormat(Format));


    if (FAILED(DivideAndRoundUp(Height, HeightAlignment, @HeightOfPacked))) then
    begin
        Result := INTSAFE_E_ARITHMETIC_OVERFLOW;
        Exit;
    end;

    if (FAILED(Safe_UIntMult(HeightOfPacked, TightRowPitch, SlicePitch))) then
    begin
        Result := INTSAFE_E_ARITHMETIC_OVERFLOW;
        Exit;
    end;

    Result := S_OK;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetYCbCrChromaSubsampling
procedure TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetYCbCrChromaSubsampling(Format: TDXGI_FORMAT; out HorizontalSubsampling: UINT; out VerticalSubsampling: UINT);
begin
    case (Format) of

        // YCbCr 4:2:0
        DXGI_FORMAT_NV12,
        DXGI_FORMAT_P010,
        DXGI_FORMAT_P016,
        DXGI_FORMAT_420_OPAQUE:
        begin
            HorizontalSubsampling := 2;
            VerticalSubsampling := 2;
        end;

        // YCbCr 4:2:2
        DXGI_FORMAT_P208,
        DXGI_FORMAT_YUY2,
        DXGI_FORMAT_Y210:
        begin
            HorizontalSubsampling := 2;
            VerticalSubsampling := 1;
        end;

        // YCbCr 4:4:0
        DXGI_FORMAT_V208:
        begin
            HorizontalSubsampling := 1;
            VerticalSubsampling := 2;
        end;

        // YCbCr 4:4:4
        DXGI_FORMAT_AYUV,
        DXGI_FORMAT_V408,
        DXGI_FORMAT_Y410,
        DXGI_FORMAT_Y416,
        // Fallthrough

        // YCbCr palletized  4:4:4:
        DXGI_FORMAT_AI44,
        DXGI_FORMAT_IA44,
        DXGI_FORMAT_P8,
        DXGI_FORMAT_A8P8:
        begin
            HorizontalSubsampling := 1;
            VerticalSubsampling := 1;
        end;

        // YCbCr 4:1:1
        DXGI_FORMAT_NV11:
        begin
            HorizontalSubsampling := 4;
            VerticalSubsampling := 1;
        end;

        else
        begin
            // All YCbCr formats should be in this list.
            assert(not YUV(Format));
            HorizontalSubsampling := 1;
            VerticalSubsampling := 1;
        end;
    end;
end;


//----------------------------------------------------------------------------
// CalculateResourceSize
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.CalculateResourceSize(Width: UINT; Height: UINT; depth: UINT; format: TDXGI_FORMAT; mipLevels: UINT; subresources: UINT; totalByteSize: PSIZE_T; pDst: PD3D12_MEMCPY_DEST): HRESULT;
var
    tableIndex: UINT;
    formatDetail: PFORMAT_DETAIL;
    fIsBlockCompressedFormat: boolean;
    subWidth: UINT;
    subHeight: UINT;
    subDepth: UINT;
    s: UINT;
    iM: uint;
    blockWidth: UINT;
    blockSize, blockHeight: UINT;
    rowPitch, depthPitch: UINT;
    subresourceByteSize: SIZE_T;
    dst: PD3D12_MEMCPY_DEST;
    subresourceByteSizeAligned: SIZE_T;
begin
    tableIndex := GetDetailTableIndexNoThrow(format);
    if (tableIndex = UINT(-1)) then
    begin
        Result := E_INVALIDARG;
        Exit;
    end;

    totalByteSize^ := 0;

    formatDetail := @s_FormatDetail[tableIndex];

    fIsBlockCompressedFormat := IsBlockCompressFormat(format);

    // No format currently requires depth alignment.
    assert(formatDetail^.DepthAlignment = 1);

    subWidth := Width;
    subHeight := Height;
    subDepth := depth;
    iM := 0;
    for s := 0 to subresources - 1 do
    begin

        if (FAILED(DivideAndRoundUp(subWidth, formatDetail^.WidthAlignment, (*_Out_*) @blockWidth))) then
        begin
            Result := INTSAFE_E_ARITHMETIC_OVERFLOW;
            Exit;
        end;


        if (fIsBlockCompressedFormat) then
        begin
            if (FAILED(DivideAndRoundUp(subHeight, formatDetail^.HeightAlignment, (*_Out_*) @blockHeight))) then
            begin
                Result := INTSAFE_E_ARITHMETIC_OVERFLOW;
                Exit;
            end;

            // Block Compressed formats use BitsPerUnit as block size.
            blockSize := formatDetail^.BitsPerUnit;
        end
        else
        begin
            // The height must *not* be aligned to HeightAlign.  As there is no plane pitch/stride, the expectation is that the 2nd plane
            // begins immediately after the first.  The only formats with HeightAlignment other than 1 are planar or block compressed, and
            // block compressed is handled above.
            assert((formatDetail^.bPlanar = 1) or (formatDetail^.HeightAlignment = 1));
            blockHeight := subHeight;

            // Combined with the division os subWidth by the width alignment above, this helps achieve rounding the stride up to an even multiple of
            // block width.  This is especially important for formats like NV12 and P208 whose chroma plane is wider than the luma.
            blockSize := formatDetail^.BitsPerUnit * formatDetail^.WidthAlignment;
        end;

        if (Ord(DXGI_FORMAT_UNKNOWN) = formatDetail^.DXGIFormat) then
        begin
            blockSize := 8;
        end;

        // Convert block width size to bytes.
        assert((blockSize and $7) = 0);
        blockSize := blockSize shr 3;

        if (formatDetail^.bPlanar = 1) then
        begin
            if (FAILED(CalculateExtraPlanarRows(format, blockHeight, (*_Out_*) @blockHeight))) then
            begin
                Result := INTSAFE_E_ARITHMETIC_OVERFLOW;
                Exit;
            end;
        end;

        // Calculate rowPitch, depthPitch, and total subresource size.


        if (FAILED(Safe_UIntMult(blockWidth, blockSize, @rowPitch)) or FAILED(Safe_UIntMult(blockHeight, rowPitch, @depthPitch))) then
        begin
            Result := INTSAFE_E_ARITHMETIC_OVERFLOW;
            Exit;
        end;

        subresourceByteSize := SIZE_T(uint64(subDepth) * uint64(depthPitch));

        if (pDst <> nil) then
        begin

            dst := @pDst[s];

            // This data will be returned straight from the API to satisfy Map. So, strides/ alignment must be API-correct.
            dst^.pData := pointer(totalByteSize);
            assert((s <> 0) or (dst^.pData = nil));

            dst^.RowPitch := rowPitch;
            dst^.SlicePitch := depthPitch;
        end;

        // Align the subresource size.
        assert(((MAP_ALIGN_REQUIREMENT and (MAP_ALIGN_REQUIREMENT - 1)) = 0), 'This code expects MAP_ALIGN_REQUIREMENT to be a power of 2.');

        subresourceByteSizeAligned := subresourceByteSize + MAP_ALIGN_REQUIREMENT - 1;
        subresourceByteSizeAligned := subresourceByteSizeAligned and not (MAP_ALIGN_REQUIREMENT - 1);
        totalByteSize := totalByteSize + subresourceByteSizeAligned;


        // Iterate over mip levels and array elements
        Inc(iM);
        if (iM >= mipLevels) then
        begin
            iM := 0;

            subWidth := Width;
            subHeight := Height;
            subDepth := depth;
        end
        else
        begin
            if (1 <> subWidth) then  subWidth := subWidth div 2;
            if (1 <> subHeight) then  subHeight := subHeight div 2;
            if (1 <> subDepth) then  subDepth := subDepth div 2;
        end;
    end;

    Result := S_OK;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetTileShape

// Retrieve 64K Tiled Resource tile shape
procedure TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetTileShape(pTileShape: PD3D12_TILE_SHAPE; Format: TDXGI_FORMAT; Dimension: TD3D12_RESOURCE_DIMENSION; SampleCount: UINT);
var
    BPU: UINT;
begin
    BPU := GetBitsPerUnit(Format);

    case (Dimension) of

        D3D12_RESOURCE_DIMENSION_UNKNOWN,
        D3D12_RESOURCE_DIMENSION_BUFFER,
        D3D12_RESOURCE_DIMENSION_TEXTURE1D:
        begin
            assert(not IsBlockCompressFormat(Format));
            if (BPU = 0) then
                pTileShape^.WidthInTexels := D3D12_TILED_RESOURCE_TILE_SIZE_IN_BYTES
            else
                pTileShape^.WidthInTexels := D3D12_TILED_RESOURCE_TILE_SIZE_IN_BYTES * 8 div BPU;
            pTileShape^.HeightInTexels := 1;
            pTileShape^.DepthInTexels := 1;
        end;

        D3D12_RESOURCE_DIMENSION_TEXTURE2D:
        begin
            if (IsBlockCompressFormat(Format)) then
            begin
                // Currently only supported block sizes are 64 and 128.
                // These equations calculate the size in texels for a tile. It relies on the fact that 64 * 64 blocks fit in a tile if the block size is 128 bits.
                assert((BPU = 64) or (BPU = 128));
                pTileShape^.WidthInTexels := 64 * GetWidthAlignment(Format);
                pTileShape^.HeightInTexels := 64 * GetHeightAlignment(Format);
                pTileShape^.DepthInTexels := 1;
                if (BPU = 64) then
                begin
                    // If bits per block are 64 we double width so it takes up the full tile size.
                    // This is only true for BC1 and BC4
                    assert(((Format >= DXGI_FORMAT_BC1_TYPELESS) and (Format <= DXGI_FORMAT_BC1_UNORM_SRGB)) or ((Format >= DXGI_FORMAT_BC4_TYPELESS) and (Format <= DXGI_FORMAT_BC4_SNORM)));
                    pTileShape^.WidthInTexels *= 2;
                end;
            end
            else
            begin
                pTileShape^.DepthInTexels := 1;
                if (BPU <= 8) then
                begin
                    pTileShape^.WidthInTexels := 256;
                    pTileShape^.HeightInTexels := 256;
                end
                else if (BPU <= 16) then
                begin
                    pTileShape^.WidthInTexels := 256;
                    pTileShape^.HeightInTexels := 128;
                end
                else if (BPU <= 32) then
                begin
                    pTileShape^.WidthInTexels := 128;
                    pTileShape^.HeightInTexels := 128;
                end
                else if (BPU <= 64) then
                begin
                    pTileShape^.WidthInTexels := 128;
                    pTileShape^.HeightInTexels := 64;
                end
                else if (BPU <= 128) then
                begin
                    pTileShape^.WidthInTexels := 64;
                    pTileShape^.HeightInTexels := 64;
                end
                else
                begin
                    ASSUME(False);
                end;

                if (SampleCount <= 1) then
                begin
                    (* Do nothing *)
                end
                else if (SampleCount <= 2) then
                begin
                    pTileShape^.WidthInTexels := pTileShape^.WidthInTexels div 2;
                    pTileShape^.HeightInTexels := pTileShape^.HeightInTexels div 1;
                end
                else if (SampleCount <= 4) then
                begin
                    pTileShape^.WidthInTexels := pTileShape^.WidthInTexels div 2;
                    pTileShape^.HeightInTexels := pTileShape^.HeightInTexels div 2;
                end
                else if (SampleCount <= 8) then
                begin
                    pTileShape^.WidthInTexels := pTileShape^.WidthInTexels div 4;
                    pTileShape^.HeightInTexels := pTileShape^.HeightInTexels div 2;
                end
                else if (SampleCount <= 16) then
                begin
                    pTileShape^.WidthInTexels := pTileShape^.WidthInTexels div 4;
                    pTileShape^.HeightInTexels := pTileShape^.HeightInTexels div 4;
                end
                else
                begin
                    ASSUME(False);
                end;
            end;
        end;

        D3D12_RESOURCE_DIMENSION_TEXTURE3D:
        begin
            if (IsBlockCompressFormat(Format)) then
            begin
                // Currently only supported block sizes are 64 and 128.
                // These equations calculate the size in texels for a tile. It relies on the fact that 16*16*16 blocks fit in a tile if the block size is 128 bits.
                assert((BPU = 64) or (BPU = 128));
                pTileShape^.WidthInTexels := 16 * GetWidthAlignment(Format);
                pTileShape^.HeightInTexels := 16 * GetHeightAlignment(Format);
                pTileShape^.DepthInTexels := 16 * GetDepthAlignment(Format);
                if (BPU = 64) then
                begin
                    // If bits per block are 64 we double width so it takes up the full tile size.
                    // This is only true for BC1 and BC4
                    assert(((Format >= DXGI_FORMAT_BC1_TYPELESS) and (Format <= DXGI_FORMAT_BC1_UNORM_SRGB)) or ((Format >= DXGI_FORMAT_BC4_TYPELESS) and (Format <= DXGI_FORMAT_BC4_SNORM)));
                    pTileShape^.WidthInTexels := 2;
                end;
            end
            else if ((Format = DXGI_FORMAT_R8G8_B8G8_UNORM) or (Format = DXGI_FORMAT_G8R8_G8B8_UNORM)) then
            begin
                //RGBG and GRGB are treated as 2x1 block format
                pTileShape^.WidthInTexels := 64;
                pTileShape^.HeightInTexels := 32;
                pTileShape^.DepthInTexels := 16;
            end
            else
            begin
                // Not a block format so BPU is bits per pixel.
                assert((GetWidthAlignment(Format) = 1) and ((GetHeightAlignment(Format) = 1) or (GetDepthAlignment(Format) <> 0)));
                case (BPU) of

                    8: begin
                        pTileShape^.WidthInTexels := 64;
                        pTileShape^.HeightInTexels := 32;
                        pTileShape^.DepthInTexels := 32;
                    end;
                    16: begin
                        pTileShape^.WidthInTexels := 32;
                        pTileShape^.HeightInTexels := 32;
                        pTileShape^.DepthInTexels := 32;
                    end;
                    32: begin
                        pTileShape^.WidthInTexels := 32;
                        pTileShape^.HeightInTexels := 32;
                        pTileShape^.DepthInTexels := 16;
                    end;
                    64: begin
                        pTileShape^.WidthInTexels := 32;
                        pTileShape^.HeightInTexels := 16;
                        pTileShape^.DepthInTexels := 16;
                    end;
                    128:
                    begin
                        pTileShape^.WidthInTexels := 16;
                        pTileShape^.HeightInTexels := 16;
                        pTileShape^.DepthInTexels := 16;
                    end;
                end;
            end;
        end;
    end;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// Get4KTileShape

// Retrieve 4K Tiled Resource tile shape
procedure TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.Get4KTileShape(pTileShape: PD3D12_TILE_SHAPE; Format: TDXGI_FORMAT; Dimension: TD3D12_RESOURCE_DIMENSION; SampleCount: UINT);
var
    BPU: UINT;
begin
    BPU := GetBitsPerUnit(Format);

    case (Dimension) of

        D3D12_RESOURCE_DIMENSION_UNKNOWN,
        D3D12_RESOURCE_DIMENSION_BUFFER,
        D3D12_RESOURCE_DIMENSION_TEXTURE1D:
        begin
            assert(not IsBlockCompressFormat(Format));
            if (BPU = 0) then
                pTileShape^.WidthInTexels := 4096
            else
                pTileShape^.WidthInTexels := 4096 * 8 div BPU;
            pTileShape^.HeightInTexels := 1;
            pTileShape^.DepthInTexels := 1;
        end;

        D3D12_RESOURCE_DIMENSION_TEXTURE2D:
        begin
            pTileShape^.DepthInTexels := 1;
            if (IsBlockCompressFormat(Format)) then
            begin
                // Currently only supported block sizes are 64 and 128.
                // These equations calculate the size in texels for a tile. It relies on the fact that 16*16*16 blocks fit in a tile if the block size is 128 bits.
                assert((BPU = 64) or (BPU = 128));
                pTileShape^.WidthInTexels := 16 * GetWidthAlignment(Format);
                pTileShape^.HeightInTexels := 16 * GetHeightAlignment(Format);
                if (BPU = 64) then
                begin
                    // If bits per block are 64 we double width so it takes up the full tile size.
                    // This is only true for BC1 and BC4
                    assert(((Format >= DXGI_FORMAT_BC1_TYPELESS) and (Format <= DXGI_FORMAT_BC1_UNORM_SRGB)) or ((Format >= DXGI_FORMAT_BC4_TYPELESS) and (Format <= DXGI_FORMAT_BC4_SNORM)));
                    pTileShape^.WidthInTexels := pTileShape^.WidthInTexels * 2;
                end;
            end
            else
            begin
                if (BPU <= 8) then
                begin
                    pTileShape^.WidthInTexels := 64;
                    pTileShape^.HeightInTexels := 64;
                end
                else if (BPU <= 16) then
                begin
                    pTileShape^.WidthInTexels := 64;
                    pTileShape^.HeightInTexels := 32;
                end
                else if (BPU <= 32) then
                begin
                    pTileShape^.WidthInTexels := 32;
                    pTileShape^.HeightInTexels := 32;
                end
                else if (BPU <= 64) then
                begin
                    pTileShape^.WidthInTexels := 32;
                    pTileShape^.HeightInTexels := 16;
                end
                else if (BPU <= 128) then
                begin
                    pTileShape^.WidthInTexels := 16;
                    pTileShape^.HeightInTexels := 16;
                end
                else
                begin
                    ASSUME(False);
                end;

                if (SampleCount <= 1) then
                begin
                    (* Do nothing *)
                end
                else if (SampleCount <= 2) then
                begin
                    pTileShape^.WidthInTexels := pTileShape^.WidthInTexels div 2;
                    pTileShape^.HeightInTexels := pTileShape^.HeightInTexels div 1;
                end
                else if (SampleCount <= 4) then
                begin
                    pTileShape^.WidthInTexels := pTileShape^.WidthInTexels div 2;
                    pTileShape^.HeightInTexels := pTileShape^.HeightInTexels div 2;
                end
                else if (SampleCount <= 8) then
                begin
                    pTileShape^.WidthInTexels := pTileShape^.WidthInTexels div 4;
                    pTileShape^.HeightInTexels := pTileShape^.HeightInTexels div 2;
                end
                else if (SampleCount <= 16) then
                begin
                    pTileShape^.WidthInTexels := pTileShape^.WidthInTexels div 4;
                    pTileShape^.HeightInTexels := pTileShape^.HeightInTexels div 4;
                end
                else
                begin
                    ASSUME(False);
                end;

                assert(GetWidthAlignment(Format) = 1);
                assert(GetHeightAlignment(Format) = 1);
                assert(GetDepthAlignment(Format) = 1);
            end;
        end;
        D3D12_RESOURCE_DIMENSION_TEXTURE3D:
        begin
            if (IsBlockCompressFormat(Format)) then
            begin
                // Currently only supported block sizes are 64 and 128.
                // These equations calculate the size in texels for a tile. It relies on the fact that 16*16*16 blocks fit in a tile if the block size is 128 bits.
                assert((BPU = 64) or (BPU = 128));
                pTileShape^.WidthInTexels := 8 * GetWidthAlignment(Format);
                pTileShape^.HeightInTexels := 8 * GetHeightAlignment(Format);
                pTileShape^.DepthInTexels := 4;
                if (BPU = 64) then
                begin
                    // If bits per block are 64 we double width so it takes up the full tile size.
                    // This is only true for BC1 and BC4
                    assert(((Format >= DXGI_FORMAT_BC1_TYPELESS) and (Format <= DXGI_FORMAT_BC1_UNORM_SRGB)) or ((Format >= DXGI_FORMAT_BC4_TYPELESS) and (Format <= DXGI_FORMAT_BC4_SNORM)));
                    pTileShape^.DepthInTexels := pTileShape^.DepthInTexels * 2;
                end;
            end
            else
            begin
                if (BPU <= 8) then
                begin
                    pTileShape^.WidthInTexels := 16;
                    pTileShape^.HeightInTexels := 16;
                    pTileShape^.DepthInTexels := 16;
                end
                else if (BPU <= 16) then
                begin
                    pTileShape^.WidthInTexels := 16;
                    pTileShape^.HeightInTexels := 16;
                    pTileShape^.DepthInTexels := 8;
                end
                else if (BPU <= 32) then
                begin
                    pTileShape^.WidthInTexels := 16;
                    pTileShape^.HeightInTexels := 8;
                    pTileShape^.DepthInTexels := 8;
                end
                else if (BPU <= 64) then
                begin
                    pTileShape^.WidthInTexels := 8;
                    pTileShape^.HeightInTexels := 8;
                    pTileShape^.DepthInTexels := 8;
                end
                else if (BPU <= 128) then
                begin
                    pTileShape^.WidthInTexels := 8;
                    pTileShape^.HeightInTexels := 8;
                    pTileShape^.DepthInTexels := 4;
                end
                else
                begin
                    ASSUME(False);
                end;

                assert(GetWidthAlignment(Format) = 1);
                assert(GetHeightAlignment(Format) = 1);
                assert(GetDepthAlignment(Format) = 1);
            end;
        end;

    end;
end;



procedure TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetMipDimensions(mipSlice: uint8; pWidth: PUINT64; pHeight: PUINT64; pDepth: PUINT64);
var
    denominator: UINT;
    mipWidth: uint64;
    mipHeight: uint64;
    mipDepth: uint64;
begin
    denominator := (1 shl mipSlice); // 2 ^ subresource
    mipWidth := pWidth^ div denominator;
    if pHeight <> nil then mipHeight := pHeight^ div denominator
    else
        mipHeight := 1;
    if pDepth <> nil then  mipDepth := pDepth^ div denominator
    else
        mipDepth := 1;

    // Adjust dimensions for degenerate mips
    if (mipHeight = 0) then
        mipHeight := 1;
    if (mipWidth = 0) then
        mipWidth := 1;
    if (mipDepth = 0) then
        mipDepth := 1;

    pWidth^ := mipWidth;
    if (pHeight <> nil) then pHeight^ := mipHeight;
    if (pDepth <> nil) then pDepth^ := mipDepth;
end;



procedure TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetPlaneSubsampledSizeAndFormatForCopyableLayout
    (PlaneSlice: UINT; Format: TDXGI_FORMAT; Width: UINT; Height: UINT; out PlaneFormat: TDXGI_FORMAT; out MinPlanePitchWidth: UINT; out PlaneWidth: UINT; out PlaneHeight: UINT);
var
    ParentFormat: TDXGI_FORMAT;
begin
    ParentFormat := GetParentFormat(Format);

    if (Planar(ParentFormat)) then
    begin
        case (ParentFormat) of

            // YCbCr 4:2:0
            DXGI_FORMAT_NV12:
            begin
                case (PlaneSlice) of

                    0: begin
                        PlaneFormat := DXGI_FORMAT_R8_TYPELESS;
                        PlaneWidth := Width;
                        PlaneHeight := Height;
                    end;
                    1: begin
                        PlaneFormat := DXGI_FORMAT_R8G8_TYPELESS;
                        PlaneWidth := (Width + 1) shr 1;
                        PlaneHeight := (Height + 1) shr 1;
                    end;
                    else
                        ASSUME(False);
                end;

                MinPlanePitchWidth := PlaneWidth;
            end;

            DXGI_FORMAT_P010,
            DXGI_FORMAT_P016:
            begin
                case (PlaneSlice) of

                    0: begin
                        PlaneFormat := DXGI_FORMAT_R16_TYPELESS;
                        PlaneWidth := Width;
                        PlaneHeight := Height;
                    end;
                    1: begin
                        PlaneFormat := DXGI_FORMAT_R16G16_TYPELESS;
                        PlaneWidth := (Width + 1) shr 1;
                        PlaneHeight := (Height + 1) shr 1;
                    end;
                    else
                        ASSUME(False);
                end;
                ;

                MinPlanePitchWidth := PlaneWidth;
            end;

            // YCbCr 4:2:2
            DXGI_FORMAT_P208:
            begin
                case (PlaneSlice) of

                    0: begin
                        PlaneFormat := DXGI_FORMAT_R8_TYPELESS;
                        PlaneWidth := Width;
                        PlaneHeight := Height;
                    end;
                    1: begin
                        PlaneFormat := DXGI_FORMAT_R8G8_TYPELESS;
                        PlaneWidth := (Width + 1) shr 1;
                        PlaneHeight := Height;
                    end;
                    else
                        ASSUME(False);
                end;
                ;

                MinPlanePitchWidth := PlaneWidth;
            end;

            // YCbCr 4:4:0
            DXGI_FORMAT_V208:
            begin
                PlaneFormat := DXGI_FORMAT_R8_TYPELESS;
                case (PlaneSlice) of

                    0: begin
                        PlaneWidth := Width;
                        PlaneHeight := Height;
                    end;
                    1,
                    2: begin
                        PlaneWidth := Width;
                        PlaneHeight := (Height + 1) shr 1;
                    end;
                    else
                        ASSUME(False);
                end;
                ;

                MinPlanePitchWidth := PlaneWidth;
            end;

            // YCbCr 4:4:4
            DXGI_FORMAT_V408:
            begin
                case (PlaneSlice) of

                    0,
                    1,
                    2: begin
                        PlaneFormat := DXGI_FORMAT_R8_TYPELESS;
                        PlaneWidth := Width;
                        PlaneHeight := Height;
                        MinPlanePitchWidth := PlaneWidth;
                    end;
                    else
                        ASSUME(False);
                end;
            end;

            // YCbCr 4:1:1
            DXGI_FORMAT_NV11:
            begin
                case (PlaneSlice) of

                    0: begin
                        PlaneFormat := DXGI_FORMAT_R8_TYPELESS;
                        PlaneWidth := Width;
                        PlaneHeight := Height;
                        MinPlanePitchWidth := Width;
                    end;
                    1: begin
                        PlaneFormat := DXGI_FORMAT_R8G8_TYPELESS;
                        PlaneWidth := (Width + 3) shr 2;
                        PlaneHeight := Height;

                        // NV11 has unused padding to the right of the chroma plane in the RowMajor (linear) copyable layout.
                        MinPlanePitchWidth := (Width + 1) shr 1;
                    end;
                    else
                        ASSUME(False);
                end;
                ;

            end;

            DXGI_FORMAT_R32G8X24_TYPELESS,
            DXGI_FORMAT_R24G8_TYPELESS:
            begin
                case (PlaneSlice) of

                    0: begin
                        PlaneFormat := DXGI_FORMAT_R32_TYPELESS;
                        PlaneWidth := Width;
                        PlaneHeight := Height;
                        MinPlanePitchWidth := Width;
                    end;
                    1: begin
                        PlaneFormat := DXGI_FORMAT_R8_TYPELESS;
                        PlaneWidth := Width;
                        PlaneHeight := Height;
                        MinPlanePitchWidth := Width;
                    end;
                    else
                        ASSUME(False);
                end;
                ;
            end;

            else
                ASSUME(False);
        end;
        ;
    end
    else
    begin
        assert(PlaneSlice = 0);
        PlaneFormat := Format;
        PlaneWidth := Width;
        PlaneHeight := Height;
        MinPlanePitchWidth := PlaneWidth;
    end;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetDetailTableIndex
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetDetailTableIndex(Format: TDXGI_FORMAT): UINT;
begin
    if (UINT(Format) < Length(s_FormatDetail)) then
    begin
        assert(s_FormatDetail[UINT(Format)].DXGIFormat = uint(Format));
        Result := UINT(Format);
        exit;
    end;

    Result := UINT(-1);
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetDetailTableIndexNoThrow
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetDetailTableIndexNoThrow(Format: TDXGI_FORMAT): UINT;
var
    Index: UINT;
begin
    Index := GetDetailTableIndex(Format);
    assert(UINT(-1) <> Index); // Needs to be validated externally.
    Result := Index;
end;


//---------------------------------------------------------------------------------------------------------------------------------
// GetDetailTableIndexThrow
function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.GetDetailTableIndexThrow(Format: TDXGI_FORMAT): UINT;
begin
    Result := GetDetailTableIndex(Format);
end;



function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.SupportsDepth(Format: TDXGI_FORMAT): boolean;
begin
    // If the number of bits associated with depth in the format is greater then 0, then the format supports depth
    Result := (GetComponentName(Format, 0) = D3DFCN_D);
end;



function TD3D12_PROPERTY_LAYOUT_FORMAT_TABLE.SupportsStencil(Format: TDXGI_FORMAT): boolean;
begin
    // If the number of bits associated with stencil in the format is greater then 0, then the format supports stencil
    Result := GetBitsPerStencil(Format) > 0;
end;

end.
